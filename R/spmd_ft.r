spmd.comm.agree <- function(comm, flag){
  .Call("spmd_comm_agree", as.integer(comm), as.integer(flag),
        PACKAGE = "pbdMPI")
} # End of spmd.comm.agree().

comm.agree <- spmd.comm.agree

spmd.comm.revoke <- function(comm = .pbd_env$SPMD.CT$comm){
  if(spmd.comm.size(comm) == 0){
    stop(paste("It seems no members (workers) associated with comm", comm))
  }
  ret <- .Call("spmd_comm_revoke", as.integer(comm), PACKAGE = "pbdMPI")
  invisible(ret)
} # End of spmd.comm.revoke().

comm.revoke <- spmd.comm.revoke
