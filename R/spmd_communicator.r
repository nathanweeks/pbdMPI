spmd.barrier <- function(comm = .SPMD.CT$comm){
  ret <- .Call("spmd_barrier", as.integer(comm), PACKAGE = "pbdMPI")
  invisible(ret)
} # End of spmd.barrier().

barrier <- spmd.barrier

spmd.comm.set.errhandler <- function(comm = .SPMD.CT$comm){
  ret <- .Call("spmd_comm_set_errhandler", as.integer(comm),
               PACKAGE = "pbdMPI")
  invisible(ret)
} # End of spmd.comm.set.errhandler().

comm.set.errhandler <- spmd.comm.set.errhandler

spmd.comm.is.null <- function(comm = .SPMD.CT$comm){
  .Call("spmd_comm_is_null", as.integer(comm), PACKAGE = "pbdMPI")
} # End of spmd.comm.is.null().

comm.is.null <- spmd.comm.is.null

spmd.comm.rank <- function(comm = .SPMD.CT$comm){
  .Call("spmd_comm_rank", as.integer(comm), PACKAGE = "pbdMPI")
} # End of spmd.comm.rank().

comm.rank <- spmd.comm.rank

spmd.comm.size <- function(comm = .SPMD.CT$comm){
  tmp <- .Call("spmd_comm_is_null", as.integer(comm), PACKAGE = "pbdMPI")

  if(tmp == 1){
    0L
  } else{
    .Call("spmd_comm_size", as.integer(comm), PACKAGE = "pbdMPI")
  }
} # End of spmd.comm.size().

comm.size <- spmd.comm.size

spmd.comm.dup <- function(comm, newcomm){
  ret <- .Call("spmd_comm_dup", as.integer(comm), as.integer(newcomm),
               PACKAGE = "pbdMPI")
  invisible(ret)
} # End of spmd.comm.dup().

comm.dup <- spmd.comm.dup

spmd.comm.free <- function(comm = .SPMD.CT$comm){
  if(spmd.comm.size(comm) == 0){
    stop(paste("It seems no members (workers) associated with comm", comm))
  }
  ret <- .Call("spmd_comm_free", as.integer(comm), PACKAGE = "pbdMPI")
  invisible(ret)
} # End of spmd.comm.free().

comm.free <- spmd.comm.free

spmd.init <- function(){
  ### Check even ".__DISABLE_MPI_INIT" is set by external API.
  # if(! exists(".__DISABLE_MPI_INIT__", envir = .GlobalEnv) ||
  #    get(".__DISABLE_MPI_INIT__", envir = .GlobalEnv) != TRUE){
  #   assign(".__DISABLE_MPI_INIT__", FALSE, envir = .GlobalEnv)
  # }

  ### We still need to initial memory for our own communicators.
  ### Copy the COMM_WORLD to the comm 0.
  ret <- .Call("spmd_initialize", PACKAGE = "pbdMPI")
  # assign(".comm.size", spmd.comm.size(), envir = .GlobalEnv)
  # assign(".comm.rank", spmd.comm.rank(), envir = .GlobalEnv)
  invisible(ret)
} # End of spmd.init().

init <- spmd.init

spmd.finalize <- function(mpi.finalize = .SPMD.CT$mpi.finalize){
  ### Do not remove ".__DISABLE_MPI_INIT__", leave it in .GlobalEnv for later
  ### uses.

  ### Only free the memory. Manually shut down MPI by "mpi.finalize".
  ### Let users take care of MPI shut down business.
  ret <- .Call("spmd_finalize", mpi.finalize, PACKAGE = "pbdMPI")
  invisible(ret)
} # End of spmd.finalize().

finalize <- spmd.finalize

spmd.is.master <- function(){
  tmp <- is.loaded("spmd_comm_get_parent", PACKAGE = "pbdMPI")
  if(tmp){
    as.logical(.Call("spmd_is_master", PACKAGE = "pbdMPI"))
  } else{
    if(spmd.comm.size(1L) > 0){
      spmd.comm.rank(1L) == 0
    } else{
      spmd.comm.rank(0L) == 0
    }
  }
} # End of spmd.is.master().

is.master <- spmd.is.master

spmd.get.processor.name <- function(short = TRUE){
  name <- .Call("spmd_get_processor_name", PACKAGE = "pbdMPI")
  if(short){
    name <- unlist(strsplit(name, "\\."))[1]
  }
  name
} # End of spmd.get.processor.name().

get.processor.name <- spmd.get.processor.name

spmd.comm.disconnect <- function(comm = .SPMD.CT$comm){
  if(spmd.comm.size(comm)== 0){
    stop(paste("It seems no members (workers) associated with comm", comm))
  }
  if(! is.loaded("spmd_comm_disconnect", PACKAGE = "pbdMPI")){
    stop("MPI_Comm_disconnect is not supported.")
  }
  ret <- .Call("spmd_comm_disconnect", as.integer(comm), PACKAGE = "pbdMPI")
  invisible(ret)
}

comm.disconnect <- spmd.comm.disconnect

spmd.comm.spawn <- function(worker, worker.arg, n.workers,
    info = .SPMD.CT$info, rank.source = .SPMD.CT$rank.source,
    intercomm = .SPMD.CT$intercomm){
  if(! is.loaded("spmd_comm_spawn", PACKAGE = "pbdMPI")){
    stop("spmd_comm_spawn is not supported.")
  }

  if(! is.character(worker)){
    stop("Character argument (worker) expected.")
  } else if(n.workers < 1){
    stop("Choose a positive number of workers.")
  }

  ret <- .Call("spmd_comm_spawn", as.character(worker),
               as.character(worker.arg), as.integer(n.workers),
               as.integer(info), as.integer(rank.source),
               as.integer(intercomm), PACKAGE = "pbdMPI")
  invisible(ret)
} # End of spmd.comm.spawn().

comm.spawn <- spmd.comm.spawn

spmd.comm.get.parent <- function(comm = .SPMD.CT$intercomm){
  if(! is.loaded("spmd_comm_get_parent", PACKAGE = "pbdMPI")){
    stop("MPI_Comm_get_parent is not supported.")
  }
  .Call("spmd_comm_get_parent", as.integer(comm), PACKAGE = "pbdMPI")
} # End of spmd.comm.get.parent().

comm.get.parent <- spmd.comm.get.parent

spmd.intercomm.merge <- function(intercomm = .SPMD.CT$intercomm,
    high = 0L, comm = .SPMD.CT$comm){
  ret <- .Call("spmd_intercomm_merge", as.integer(intercomm), as.integer(high),
               as.integer(comm), PACKAGE = "pbdMPI")
  invisible(ret)
} # End of spmd.intercomm.merge().

intercomm.merge <- spmd.intercomm.merge


### Fortran supporting function.
spmd.comm.c2f <- function(comm = .SPMD.CT$comm){
  .Call("spmd_comm_c2f", as.integer(comm), PACKAGE = "pbdMPI")
} # End of spmd.comm.c2f().

comm.c2f <- spmd.comm.c2f