!nvfortran -acc -gpu=cc100 probe.f90 -o probe

program probe
  use openacc
  implicit none
  integer :: devtype, ndev, ierr
  devtype = acc_get_device_type()
  print *, "devtype=", devtype
  ndev = acc_get_num_devices(devtype)
  print *, "num_devices=", ndev
  if (ndev > 0) then
     call acc_set_device_num(0, devtype)
     print *, "set device success"
  end if
end program probe