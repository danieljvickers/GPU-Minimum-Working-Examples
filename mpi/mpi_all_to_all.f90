program mpi_sum_ranks_checked
    use mpi
    implicit none


    !! mpifort -o mpi_all_to_all mpi_all_to_all.f90
    !! mpifort -o mpi_all_to_all mpi_all_to_all.f90

    integer :: ierr, my_rank, nprocs
    integer :: value, sum_all
    integer :: error_class, result_len
    character(len=MPI_MAX_ERROR_STRING) :: error_string

    ! Utility: error checking wrapper
contains
    subroutine check_mpi_error(ierr, msg)
        integer, intent(in) :: ierr
        character(*), intent(in) :: msg
        integer :: error_class, result_len

        if (ierr /= MPI_SUCCESS) then
            call MPI_Error_class(ierr, error_class, ierr)
            call MPI_Error_string(ierr, error_string, result_len, ierr)
            print *, "MPI ERROR during: ", trim(msg)
            print *, "  Error class: ", error_class
            print *, "  Error string:", trim(error_string)
            call MPI_Abort(MPI_COMM_WORLD, ierr, ierr)
        end if
    end subroutine check_mpi_error

!-----------------------------
! Main program starts here
!-----------------------------
    call MPI_Init(ierr)
    call check_mpi_error(ierr, "MPI_Init")

    call MPI_Comm_rank(MPI_COMM_WORLD, my_rank, ierr)
    call check_mpi_error(ierr, "MPI_Comm_rank")

    call MPI_Comm_size(MPI_COMM_WORLD, nprocs, ierr)
    call check_mpi_error(ierr, "MPI_Comm_size")

    ! Ensure nprocs is reasonable (optional safety)
    if (nprocs < 1 .or. nprocs > 4) then
        print *, "Warning: Example designed for 1–4 ranks; running with", nprocs
    end if

    ! Each rank gets its own number
    value = my_rank

    ! Global reduction
    call MPI_Allreduce(value, sum_all, 1, MPI_INTEGER, MPI_SUM, MPI_COMM_WORLD, ierr)
    call check_mpi_error(ierr, "MPI_Allreduce")

    print *, 'Rank', my_rank, 'of', nprocs, 'computed global sum =', sum_all

    call MPI_Finalize(ierr)
    call check_mpi_error(ierr, "MPI_Finalize")

end program mpi_sum_ranks_checked

