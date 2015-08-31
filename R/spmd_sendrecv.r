### S4 functions.

### Default method.
spmd.sendrecv.default <- function(x, x.buffer = NULL,
    rank.dest = (comm.rank(.pbdMPIEnv$SPMD.CT$comm) + 1) %%
                comm.size(.pbdMPIEnv$SPMD.CT$comm),
    send.tag = .pbdMPIEnv$SPMD.CT$tag,
    rank.source = (comm.rank(.pbdMPIEnv$SPMD.CT$comm) - 1) %%
                  comm.size(.pbdMPIEnv$SPMD.CT$comm),
    recv.tag = .pbdMPIEnv$SPMD.CT$tag, comm = .pbdMPIEnv$SPMD.CT$comm,
    status = .pbdMPIEnv$SPMD.CT$status){
  x.raw <- serialize(x, NULL)
  total.new <- spmd.sendrecv.integer(length(x.raw), integer(1),
                 rank.dest = rank.source,
                 send.tag =  send.tag,
                 rank.source = rank.dest,
                 recv.tag =  recv.tag,
                 comm = comm, status = status)
  unserialize(spmd.sendrecv.raw(x.raw, raw(total.new),
                rank.dest = rank.dest,
                send.tag = send.tag,
                rank.source = rank.source,
                recv.tag = recv.tag,
                comm = comm, status = status))
} # End of spmd.sendrecv.default().


### For sendrecv.
spmd.sendrecv.integer <- function(x, x.buffer,
    rank.dest = (comm.rank(.pbdMPIEnv$SPMD.CT$comm) + 1) %%
                comm.size(.pbdMPIEnv$SPMD.CT$comm),
    send.tag = .pbdMPIEnv$SPMD.CT$tag,
    rank.source = (comm.rank(.pbdMPIEnv$SPMD.CT$comm) - 1) %%
                  comm.size(.pbdMPIEnv$SPMD.CT$comm),
    recv.tag = .pbdMPIEnv$SPMD.CT$tag, comm = .pbdMPIEnv$SPMD.CT$comm,
    status = .pbdMPIEnv$SPMD.CT$status){
  .Call("spmd_sendrecv_integer", x, x.buffer,
        as.integer(rank.dest), as.integer(send.tag), as.integer(rank.source),
        as.integer(recv.tag),
        as.integer(comm), as.integer(status), PACKAGE = "pbdMPI")
} # End of spmd.sendrecv.integer().

spmd.sendrecv.double <- function(x, x.buffer,
    rank.dest = (comm.rank(.pbdMPIEnv$SPMD.CT$comm) + 1) %%
                comm.size(.pbdMPIEnv$SPMD.CT$comm),
    send.tag = .pbdMPIEnv$SPMD.CT$tag,
    rank.source = (comm.rank(.pbdMPIEnv$SPMD.CT$comm) - 1) %%
                  comm.size(.pbdMPIEnv$SPMD.CT$comm),
    recv.tag = .pbdMPIEnv$SPMD.CT$tag, comm = .pbdMPIEnv$SPMD.CT$comm,
    status = .pbdMPIEnv$SPMD.CT$status){
  .Call("spmd_sendrecv_double", x, x.buffer,
        as.integer(rank.dest), as.integer(send.tag), as.integer(rank.source),
        as.integer(recv.tag),
        as.integer(comm), as.integer(status), PACKAGE = "pbdMPI")
} # End of spmd.sendrecv.double().

spmd.sendrecv.raw <- function(x, x.buffer,
    rank.dest = (comm.rank(.pbdMPIEnv$SPMD.CT$comm) + 1) %%
                comm.size(.pbdMPIEnv$SPMD.CT$comm),
    send.tag = .pbdMPIEnv$SPMD.CT$tag,
    rank.source = (comm.rank(.pbdMPIEnv$SPMD.CT$comm) - 1) %%
                  comm.size(.pbdMPIEnv$SPMD.CT$comm),
    recv.tag = .pbdMPIEnv$SPMD.CT$tag, comm = .pbdMPIEnv$SPMD.CT$comm,
    status = .pbdMPIEnv$SPMD.CT$status){
  .Call("spmd_sendrecv_raw", x, x.buffer,
        as.integer(rank.dest), as.integer(send.tag), as.integer(rank.source),
        as.integer(recv.tag),
        as.integer(comm), as.integer(status), PACKAGE = "pbdMPI")
} # End of spmd.sendrecv.raw().


### S4 methods for recv.
setGeneric(
  name = "sendrecv",
  useAsDefault = spmd.sendrecv.default
)
setMethod(
  f = "sendrecv",
  signature = signature(x = "ANY", x.buffer = "ANY"),
  definition = spmd.sendrecv.default
)
setMethod(
  f = "sendrecv",
  signature = signature(x = "integer", x.buffer = "integer"),
  definition = spmd.sendrecv.integer
)
setMethod(
  f = "sendrecv",
  signature = signature(x = "numeric", x.buffer = "numeric"),
  definition = spmd.sendrecv.double
)
setMethod(
  f = "sendrecv",
  signature = signature(x = "raw", x.buffer = "raw"),
  definition = spmd.sendrecv.raw
)

