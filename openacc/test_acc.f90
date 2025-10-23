! $FC -acc -gpu=cc100 test_acc.f90 -o test_acc

program test
    use openacc
    implicit none
    print *, "Before init"
    !$acc parallel
    !$acc end parallel
    print *, "After parallel region"
end program