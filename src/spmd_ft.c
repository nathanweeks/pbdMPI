#include "spmd.h"
#include <mpi-ext.h>

/* ULFM API */
SEXP spmd_comm_agree(SEXP R_comm, SEXP R_flag){
    int flag = INTEGER(R_flag)[0];
    spmd_errhandler(MPIX_Comm_agree(comm[INTEGER(R_comm)[0]], &flag));
	return(AsInt(flag));
} /* End of spmd_comm_agree(). */

SEXP spmd_comm_revoke(SEXP R_comm){
	return(AsInt(
		spmd_errhandler(MPIX_Comm_revoke(comm[INTEGER(R_comm)[0]]))));
} /* End of spmd_comm_revoke(). */

