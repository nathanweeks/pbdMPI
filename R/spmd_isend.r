### S4 functions.

### Default method.
spmd.isend.default <- function(x,
    rank.dest = .SPMD.CT$rank.dest, tag = .SPMD.CT$tag,
    comm = .SPMD.CT$comm, request = .SPMD.CT$request){
  spmd.isend.raw(serialize(x, NULL), rank.dest = as.integer(rank.dest),
                 tag = as.integer(tag), comm = as.integer(comm),
                 request = as.integer(request))
  invisible()
} # End of spmd.isend.default().

### For isend.
spmd.isend.integer <- function(x,
    rank.dest = .SPMD.CT$rank.dest, tag = .SPMD.CT$tag,
    comm = .SPMD.CT$comm, request = .SPMD.CT$request){
  .Call("spmd_isend_integer", x, as.integer(rank.dest), as.integer(tag),
        as.integer(comm), as.integer(request), PACKAGE = "pbdMPI")
  invisible()
} # End of spmd.isend.integer().

spmd.isend.double <- function(x,
    rank.dest = .SPMD.CT$rank.dest, tag = .SPMD.CT$tag,
    comm = .SPMD.CT$comm, request = .SPMD.CT$request){
  .Call("spmd_isend_double", x, as.integer(rank.dest), as.integer(tag),
        as.integer(comm), as.integer(request), PACKAGE = "pbdMPI")
  invisible()
} # End of spmd.isend.double().

spmd.isend.raw <- function(x,
    rank.dest = .SPMD.CT$rank.dest, tag = .SPMD.CT$tag,
    comm = .SPMD.CT$comm, request = .SPMD.CT$request){
  .Call("spmd_isend_raw", x, as.integer(rank.dest), as.integer(tag),
        as.integer(comm), as.integer(request), PACKAGE = "pbdMPI")
  invisible()
} # End of spmd.isend.double().


### S4 methods.
setGeneric(
  name = "isend",
  useAsDefault = spmd.isend.default
)

### For isend.
setMethod(
  f = "isend",
  signature = signature(x = "ANY"),
  definition = spmd.isend.default
)
setMethod(
  f = "isend",
  signature = signature(x = "integer"),
  definition = spmd.isend.integer
)
setMethod(
  f = "isend",
  signature = signature(x = "numeric"),
  definition = spmd.isend.double
)
setMethod(
  f = "isend",
  signature = signature(x = "raw"),
  definition = spmd.isend.raw
)
