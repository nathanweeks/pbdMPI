#include "spmd.h"

SEXP spmd_group_free(SEXP R_comm){
    MPI_Comm;
	return(AsInt(
		spmd_errhandler(MPI_Comm_free(&comm[INTEGER(R_comm)[0]]))));
} /* End of spmd_group_free(). */
