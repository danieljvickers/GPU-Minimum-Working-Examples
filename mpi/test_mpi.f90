! mpifort test_mpi.f90 -o test_mpi
! mpirun -np 4 ./test_mpi

program mpi_test
  use mpi
  implicit none

  integer :: ierr, rank, nprocs, name_len
  character(len=MPI_MAX_PROCESSOR_NAME) :: pname

  call MPI_Init(ierr)
  call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
  call MPI_Comm_size(MPI_COMM_WORLD, nprocs, ierr)
  call MPI_Get_processor_name(pname, name_len, ierr)

  write(*,'(A,I0,A,I0,A)') 'Hello from rank ', rank, ' of ', nprocs, ' on ', trim(pname)

  call MPI_Barrier(MPI_COMM_WORLD, ierr)

  if (rank == 0) then
    write(*,*) 'All ranks reached barrier; finalizing.'
  end if

  call MPI_Finalize(ierr)
end program mpi_test
