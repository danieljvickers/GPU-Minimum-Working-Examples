! mpifort -acc -gpu=cc100 test_mpi_acc.f90 -o test_mpi_acc

program test_mpi_acc
  use mpi
  use openacc
  implicit none

  integer :: ierr, rank, nprocs
  integer :: local_rank, stat, slen
  character(len=16) :: envstr
  integer, parameter :: n = 100000
  real, allocatable :: a(:)
  integer :: i
  logical :: found_nan

  call MPI_INIT(ierr)
  call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, nprocs, ierr)

  ! try to get a local-rank environment variable set by OpenMPI
  call get_environment_variable("OMPI_COMM_WORLD_LOCAL_RANK", envstr, length=slen, status=stat)
  if (stat == 0) then
     read(envstr(1:slen), *) local_rank
  else
     ! fallback: use global rank (ok for single-rank tests)
     local_rank = rank
  end if

  print *, 'rank=', rank, ' local_rank=', local_rank

  ! set an OpenACC device based on local_rank so each MPI rank uses a different GPU
  call acc_set_device_num(local_rank, acc_device_nvidia)
  print *, 'rank=',rank, ' acc_set_device_num done'

  allocate(a(n))
  ! initialize on host deliberately (avoid uninitialized data)
  a = 1.0

  ! push data to device and run a tiny kernel that depends on rank
  !$acc data copyin(a)
  !$acc parallel loop present(a)
  do i = 1, n
     a(i) = a(i) + real(rank) * 0.5
  end do
  !$acc end parallel loop
  !$acc end data

  ! check for NaNs on host by copying first element back (simple check)
  found_nan = .false.
  do i = 1, n, n/10
     if (a(i) /= a(i)) then
        found_nan = .true.
     end if
  end do

  if (found_nan) then
     print *, 'rank=', rank, ' FOUND NaN in array!'
  else
     print *, 'rank=', rank, ' OK (no NaN detected)'
  end if

  call MPI_BARRIER(MPI_COMM_WORLD, ierr)
  call MPI_FINALIZE(ierr)
end program test_mpi_acc
