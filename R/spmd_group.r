spmd.group.size <- function(group){
  .Call("spmd_group_size", group, PACKAGE = "pbdMPI")
} # End of spmd.group.size().

group.size <- spmd.group.size

spmd.group.rank <- function(group){
  .Call("spmd_group_rank", group, PACKAGE = "pbdMPI")
} # End of spmd.group.rank().

group.rank <- spmd.group.rank

spmd.group.translate.ranks <- function(group1, ranks1, group2){
  .Call("spmd_group_translate_ranks", group1, ranks1, group2, PACKAGE = "pbdMPI")
} # End of spmd.group.translate.ranks().

group.translate.ranks <- spmd.group.translate.ranks

# FIXME: returns and integer equal to MPI_IDENT, MPI_SIMILAR, or MPI_UNEQUAL
spmd.group.compare <- function(group1, group2){
  .Call("spmd_group_compare", group1, group2, PACKAGE = "pbdMPI")
} # End of spmd.group.compare().

group.compare <- spmd.group.compare

spmd.comm.group <- function(comm = .pbd_env$SPMD.CT$comm){
  .Call("spmd_comm_group", as.integer(comm), PACKAGE = "pbdMPI")
} # End of spmd.comm.group().

comm.group <- spmd.comm.group

spmd.group.union <- function(group1, group2){
  .Call("spmd_group_union", group1, group2, PACKAGE = "pbdMPI")
} # End of spmd.group.union().

group.union <- spmd.group.union

spmd.group.intersection <- function(group1, group2){
  .Call("spmd_group_intersection", group1, group2, PACKAGE = "pbdMPI")
} # End of spmd.group.intersection().

group.intersection <- spmd.group.intersection

spmd.group.difference <- function(group1, group2){
  .Call("spmd_group_difference", group1, group2, PACKAGE = "pbdMPI")
} # End of spmd.group.difference().

group.difference <- spmd.group.difference

spmd.group.incl <- function(group, ranks){
  .Call("spmd_group_incl", group, ranks, PACKAGE = "pbdMPI")
} # End of spmd.group.incl().

group.incl <- spmd.group.incl

spmd.group.excl <- function(group, ranks){
  .Call("spmd_group_excl", group, ranks, PACKAGE = "pbdMPI")
} # End of spmd.group.excl().

group.excl <- spmd.group.excl

spmd.group.range.incl <- function(group, ranges){
  .Call("spmd_group_range_incl", group, ranges, PACKAGE = "pbdMPI")
} # End of spmd.group.range.incl().

group.range.incl <- spmd.group.range.incl

spmd.group.range.excl <- function(group, ranges){
  .Call("spmd_group_range_excl", group, ranges, PACKAGE = "pbdMPI")
} # End of spmd.group.range.excl().

group.range.excl <- spmd.group.range.excl

spmd.group.free <- function(group){
  .Call("spmd_group_free", group, ranges, PACKAGE = "pbdMPI")
} # End of spmd.group.free().

group.free <- spmd.group.free

# TODO: MPI_GROUP_EMPTY, MPI_GROUP_NULL
