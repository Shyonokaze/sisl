subroutine write_open_gf(fname, iu)
  use io_m, only: open_file

  implicit none

  ! Input parameters
  character(len=*), intent(in) :: fname
  integer, intent(out) :: iu

  ! Define f2py intents
!f2py intent(in) :: fname
!f2py intent(out) :: iu

  ! Open file (ensure we start from a clean slate)!
  call open_file(fname, 'write', 'unknown', 'unformatted', iu)

end subroutine write_open_gf

subroutine write_gf_header( iu, nspin, cell, na_u, no_u, na_used, no_used, &
    xa_used, lasto_used, Bloch, pre_expand, mu, nkpt, kpt, kw, NE, E)
  use io_m, only: iostat_update

  implicit none

  ! Precision 
  integer, parameter :: dp = selected_real_kind(p=15)

  ! Input parameters
  integer, intent(in) :: iu
  ! Variables for the size
  integer, intent(in) :: nspin
  real(dp), intent(in) :: cell(3,3)
  integer, intent(in) :: na_u, no_u, na_used, no_used
  real(dp), intent(in) :: xa_used(3,na_used)
  integer, intent(in) :: lasto_used(0:na_used)
  integer, intent(in) :: Bloch(3)
  integer, intent(in) :: pre_expand
  real(dp), intent(in) :: mu
  integer, intent(in) :: nkpt
  real(dp), intent(in) :: kpt(3,nkpt), kw(nkpt)
  integer, intent(in) :: NE
  complex(dp), intent(in) :: E(NE)

! Define f2py intents
!f2py intent(in) :: iu
!f2py intent(in) :: nspin, cell, na_u, no_u, na_used, no_used
!f2py intent(in) :: xa_used, lasto_used, Bloch, pre_expand
!f2py intent(in) :: mu
!f2py intent(in) :: nkpt, kpt, w, NE, E

  integer :: ierr

  write(iu, iostat=ierr) nspin, cell
  call iostat_update(ierr)
  write(iu, iostat=ierr) na_u, no_u
  call iostat_update(ierr)
  write(iu, iostat=ierr) na_used, no_used
  call iostat_update(ierr)
  write(iu, iostat=ierr) xa_used, lasto_used
  call iostat_update(ierr)
  write(iu, iostat=ierr) .false., Bloch, pre_expand
  call iostat_update(ierr)
  write(iu, iostat=ierr) mu
  call iostat_update(ierr)

  ! k-points
  write(iu, iostat=ierr) nkpt
  call iostat_update(ierr)
  write(iu, iostat=ierr) kpt, kw
  call iostat_update(ierr)

  write(iu, iostat=ierr) NE
  call iostat_update(ierr)
  write(iu, iostat=ierr) E
  call iostat_update(ierr)

end subroutine write_gf_header

subroutine write_gf_hs(iu, ik, iE, E, no_u, H, S)
  use io_m, only: iostat_update

  implicit none

  ! Precision 
  integer, parameter :: dp = selected_real_kind(p=15)

  ! Input parameters
  integer, intent(in) :: iu
  integer, intent(in) :: ik, iE
  complex(dp), intent(in) :: E
  ! Variables for the size
  integer, intent(in) :: no_u
  complex(dp), intent(in) :: H(no_u,no_u), S(no_u,no_u)

! Define f2py intents
!f2py intent(in) :: iu
!f2py intent(in) :: ik, iE, E
!f2py intent(in) :: no_u
!f2py intent(in) :: H, S

  integer :: ierr

  write(iu, iostat=ierr) ik, iE, E
  call iostat_update(ierr)
  write(iu, iostat=ierr) H
  call iostat_update(ierr)
  write(iu, iostat=ierr) S
  call iostat_update(ierr)

end subroutine write_gf_hs

subroutine write_gf_se(iu, ik, iE, E, no_u, SE)
  use io_m, only: iostat_update

  implicit none

  ! Precision 
  integer, parameter :: dp = selected_real_kind(p=15)

  ! Input parameters
  integer, intent(in) :: iu
  integer, intent(in) :: ik, iE
  complex(dp), intent(in) :: E
  ! Variables for the size
  integer, intent(in) :: no_u
  complex(dp), intent(in) :: SE(no_u,no_u)

! Define f2py intents
!f2py intent(in) :: iu
!f2py intent(in) :: ik, iE, E
!f2py intent(in) :: no_u
!f2py intent(in) :: SE

  integer :: ierr

  if ( iE > 1 ) then
    write(iu, iostat=ierr) ik, iE, E
    call iostat_update(ierr)
  end if
  write(iu, iostat=ierr) SE
  call iostat_update(ierr)

end subroutine write_gf_se

subroutine close_gf(iu)

  implicit none

  ! Input parameters
  integer, intent(in) :: iu

  ! Define f2py intents
!f2py intent(in) :: iu

  ! Open file
  close(iu)

end subroutine close_gf
