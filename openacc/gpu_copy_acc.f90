! nvfortran -acc -Minfo=accel -o vec_add_acc vec_add_acc.f90

! This script is meant to launch an actual basical parallel add kernel.
! This test shows that data is able to be copied in and out of the GPU along with basic compute.

program vec_add_acc
    use openacc
    implicit none

    integer, parameter :: n = 10
    real :: a(n), b(n), c(n)
    integer :: i
    integer :: err
    character(256) :: string_buffer

    ! Initialize arrays
    do i = 1, n
        a(i) = real(i)
        b(i) = 2.0 * real(i)
    end do

    print *, "Array A before:"
    print *, a
    print *, "Array B before:"
    print *, b

    !$acc data copyin(a,b) copyout(c)
    !$acc parallel loop
    do i = 1, n
        c(i) = a(i) + b(i)
    end do
    !$acc end parallel loop
    !$acc end data

    print *, "Array C after A + B:"
    print *, c

end program vec_add_acc

