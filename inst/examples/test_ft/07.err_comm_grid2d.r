# Create two communicators, representing a PxP 2D grid of
# the processes. Either return MPIX_ERR_PROC_FAILED at all ranks,
# then no communicator has been created, or MPI_SUCCESS and all communicators
# have been created at all ranks.
#   integer :: rank ! makes this global (for writes)

suppressMessages(library(pbdMPI, quietly = TRUE))
verbose = FALSE

# return rowcomm, colcomm
ft_comm_grid2d <- function(comm, p) {
  rank <- comm.rank(comm)

  rowcomm <- try(comm.split(comm=comm, color=rank%%p, key=rank), silent=TRUE)
  colcomm <- try(comm.split(comm=comm, color=rank%/%p,key=rank), silent=TRUE)

  flag <- try(comm.agree(comm=comm,
                         flag=class(rowcomm) != "try-error" &&
                              class(colcomm) != "try-error"), silent=TRUE)
  if (class(flag) == "try-error") {
    if (class(rowcomm) != "try-error") comm.free(comm=rowcomm)
    if (class(colcomm) != "try-error") comm.free(comm=colcomm)
    stop("MPIX_ERR_PROC_FAILED")
  } else {
    return(list(rowcomm=rowcomm, colcomm=colcomm))
  }
}

print_timings <- function(scomm, tff, twf) {
  # Storage for min and max times
  mintff <- reduce(x=tff, op="min", rank.dest = 0, comm=scomm)
  maxtff <- reduce(x=tff, op="max", rank.dest = 0, comm=scomm)
  mintwf <- reduce(x=twf, op="min", rank.dest = 0, comm=scomm)
  maxtwf <- reduce(x=twf, op="max", rank.dest = 0, comm=scomm)

# FIXME: there has to be a bug in reduce() somewhere...
  if(1 == comm.rank(scomm)) {
      cat("## Timings ########### Min         ### Max         ##\n",
          "ftgrid  (safe)      # ", mintff, " # ", maxtff, "\n",
          "ftgrid  (safe w/f)  # ", mintwf, " # ", maxtwf, "\n")
  }
}

verbose <- ifelse(any(commandArgs() == "-v"), TRUE, FALSE)
init()
rank <- comm.rank()
np <- comm.size()
victim = (rank == comm.size()-1)
p <- as.integer(sqrt(np))

   # To collect the timings, we need a communicator that still
   # works after we inject a failure:
   # this split creates a communicator that excludes the victim;
   # we can do this, because we know the victim a-priori, in this
   # example.
scomm <- comm.split(color=ifelse(victim, NA, 1), key=rank)

# Let's work on a copy of MPI_COMM_WORLD, good practice anyway.
fcomm <- comm.dup(0)
# We set an errhandler on fcomm, so that a failure is not fatal anymore.
comm.set.errhandler(comm=fcomm)

# Time a consistent failure resilient dup
start <- proc.time()
grid2d <- ft_comm_grid2d(comm=fcomm, p=p)
tff=proc.time()-start
if(verbose) {
  cat("Rank ", rank, ": ft_comm_grid2d (safe) completed (rc=", 
      ifelse(class(grid2d) != "try-error", "MPI_SUCCESS", grid2d), ") duration ", tff, " (s)\n")
}

if (class(grid2d) != "try-error") {
  comm.free(comm=grid2d$rowcomm)
  comm.free(comm=grid2d$colcomm)
}

# Time a consistent failure resilient dup,  w/failure
if(victim) {
  if(verbose) stop("Rank ", rank, ": suicide")
}
start=proc.time()

grid2d <- try(ft_comm_grid2d(comm=fcomm, p=p), silent=TRUE)
twf=proc.time()-start

if (verbose) {
  cat("Rank ", rank, ": ft_comm_grid2d (safe) completed (rc=",
      ifelse(class(grid2d) != "try-error", "MPI_SUCCESS", grid2d), ") duration ", twf, " (s)\n")
}

if (class(grid2d) != "try-error") {
  comm.free(comm=grid2d$rowcomm)
  comm.free(comm=grid2d$colcomm)
}

comm.free(comm=fcomm)

print_timings(scomm=scomm, tff=tff, twf=twf)
comm.free(comm=scomm)

finalize()
