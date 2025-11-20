program mpi_sum_ranks_checked
    use mpi
    implicit none

    !! mpifort -o mpi_all_to_all mpi_all_to_all.f90

    integer :: ierr, my_rank, nprocs
    integer :: value, sum_all
    integer :: error_class, result_len
    character(len=MPI_MAX_ERROR_STRING) :: error_string

    call MPI_Init(ierr)

    call MPI_Comm_rank(MPI_COMM_WORLD, my_rank, ierr)

    call MPI_Comm_size(MPI_COMM_WORLD, nprocs, ierr)

    ! Ensure nprocs is reasonable (optional safety)
    if (nprocs < 1 .or. nprocs > 4) then
        print *, "Warning: Example designed for 1–4 ranks; running with", nprocs
    end if

    ! Each rank gets its own number
    value = my_rank

    ! Global reduction
    call MPI_Allreduce(value, sum_all, 1, MPI_INTEGER, MPI_SUM, MPI_COMM_WORLD, ierr)

    print *, 'Rank', my_rank, 'of', nprocs, 'computed global sum =', sum_all

    call MPI_Finalize(ierr)

end program mpi_sum_ranks_checked

