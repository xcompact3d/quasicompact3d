!################################################################################
!This file is part of Incompact3d.
!
!Incompact3d
!Copyright (c) 2012 Eric Lamballais and Sylvain Laizet
!eric.lamballais@univ-poitiers.fr / sylvain.laizet@gmail.com
!
!    Incompact3d is free software: you can redistribute it and/or modify
!    it under the terms of the GNU General Public License as published by
!    the Free Software Foundation.
!
!    Incompact3d is distributed in the hope that it will be useful,
!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!    GNU General Public License for more details.
!
!    You should have received a copy of the GNU General Public License
!    along with the code.  If not, see <http://www.gnu.org/licenses/>.
!-------------------------------------------------------------------------------
!-------------------------------------------------------------------------------
!    We kindly request that you cite Incompact3d in your publications and 
!    presentations. The following citations are suggested:
!
!    1-Laizet S. & Lamballais E., 2009, High-order compact schemes for 
!    incompressible flows: a simple and efficient method with the quasi-spectral 
!    accuracy, J. Comp. Phys.,  vol 228 (15), pp 5989-6015
!
!    2-Laizet S. & Li N., 2011, Incompact3d: a powerful tool to tackle turbulence 
!    problems with up to 0(10^5) computational cores, Int. J. of Numerical 
!    Methods in Fluids, vol 67 (11), pp 1735-1757
!################################################################################

!*******************************************************************
!
subroutine test_scalar_min_max(phi)
!
!*******************************************************************

USE decomp_2d
USE decomp_2d_poisson
USE variables
USE param
USE var
USE MPI


implicit none

integer :: i,j,k
real(mytype) :: phimax,phimin,cfl
real(mytype) :: phimax1,phimin1

real(mytype),dimension(xsize(1),xsize(2),xsize(3)) :: phi
integer :: code

phimax=-1609._mytype
phimin=1609._mytype
do k=1,xsize(3)
do j=1,xsize(2)
do i=1,xsize(1)
   if (phi(i,j,k).gt.phimax) phimax=phi(i,j,k)
   if (phi(i,j,k).lt.phimin) phimin=phi(i,j,k)
enddo
enddo
enddo


call MPI_REDUCE(phimax,phimax1,1,real_type,MPI_MAX,0,MPI_COMM_WORLD,code)
call MPI_REDUCE(phimin,phimin1,1,real_type,MPI_MIN,0,MPI_COMM_WORLD,code)
if (nrank==0) then
   print *,'PHI max=',phimax1
   print *,'PHI min=',phimin1
endif


return
end subroutine test_scalar_min_max

!*******************************************************************
!
subroutine test_density_min_max(rho)
!
!*******************************************************************

USE decomp_2d
USE decomp_2d_poisson
USE variables
USE param
USE var
USE MPI


implicit none

integer :: i,j,k
real(mytype) :: rhomax,rhomin,cfl
real(mytype) :: rhomax1,rhomin1

real(mytype),dimension(xsize(1),xsize(2),xsize(3)) :: rho
integer :: code

rhomax=-1609._mytype
rhomin=1609._mytype
do k=1,xsize(3)
do j=1,xsize(2)
do i=1,xsize(1)
   if (rho(i,j,k).gt.rhomax) rhomax=rho(i,j,k)
   if (rho(i,j,k).lt.rhomin) rhomin=rho(i,j,k)
enddo
enddo
enddo


call MPI_REDUCE(rhomax,rhomax1,1,real_type,MPI_MAX,0,MPI_COMM_WORLD,code)
call MPI_REDUCE(rhomin,rhomin1,1,real_type,MPI_MIN,0,MPI_COMM_WORLD,code)
if (nrank==0) then
   print *,'RHO max=',rhomax1
   print *,'RHO min=',rhomin1
endif


return
end subroutine test_density_min_max

!*******************************************************************
!
subroutine test_speed_min_max(ux,uy,uz)
!
!*******************************************************************

USE decomp_2d
USE decomp_2d_poisson
USE variables
USE param
USE var
USE MPI


implicit none

integer :: i,j,k
real(mytype) :: uxmax,uymax,uzmax,uxmin,uymin,uzmin,cfl
real(mytype) :: uxmax1,uymax1,uzmax1,uxmin1,uymin1,uzmin1

real(mytype),dimension(xsize(1),xsize(2),xsize(3)) :: ux,uy,uz
integer :: code

uxmax=-1609._mytype
uymax=-1609._mytype
uzmax=-1609._mytype
uxmin=1609._mytype
uymin=1609._mytype
uzmin=1609._mytype
do k=1,xsize(3)
do j=1,xsize(2)
do i=1,xsize(1)
   if (ux(i,j,k).gt.uxmax) uxmax=ux(i,j,k)
   if (uy(i,j,k).gt.uymax) uymax=uy(i,j,k)
   if (uz(i,j,k).gt.uzmax) uzmax=uz(i,j,k)
   if (ux(i,j,k).lt.uxmin) uxmin=ux(i,j,k)
   if (uy(i,j,k).lt.uymin) uymin=uy(i,j,k)
   if (uz(i,j,k).lt.uzmin) uzmin=uz(i,j,k)
enddo
enddo
enddo


call MPI_REDUCE(uxmax,uxmax1,1,real_type,MPI_MAX,0,MPI_COMM_WORLD,code)
call MPI_REDUCE(uymax,uymax1,1,real_type,MPI_MAX,0,MPI_COMM_WORLD,code)
call MPI_REDUCE(uzmax,uzmax1,1,real_type,MPI_MAX,0,MPI_COMM_WORLD,code)
call MPI_REDUCE(uxmin,uxmin1,1,real_type,MPI_MIN,0,MPI_COMM_WORLD,code)
call MPI_REDUCE(uymin,uymin1,1,real_type,MPI_MIN,0,MPI_COMM_WORLD,code)
call MPI_REDUCE(uzmin,uzmin1,1,real_type,MPI_MIN,0,MPI_COMM_WORLD,code)
if (nrank==0) then
   print *,'U,V,W max=',uxmax1,uymax1,uzmax1
   print *,'U,V,W min=',uxmin1,uymin1,uzmin1
endif


return
end subroutine test_speed_min_max

!*******************************************************************
!
subroutine restart(ux1,uy1,uz1,ep1,pp3,phi1,gx1,gy1,gz1,px1,py1,pz1,phis1,&
                   hx1,hy1,hz1,phiss1,phG,irestart)
!
!*******************************************************************

USE decomp_2d
USE decomp_2d_io
USE variables
USE param
USE MPI

implicit none

TYPE(DECOMP_INFO) :: phG
integer :: i,j,k,irestart,nzmsize,fh,ierror,code
real(mytype), dimension(xsize(1),xsize(2),xsize(3)) :: ux1,uy1,uz1,ep1
real(mytype), dimension(xsize(1),xsize(2),xsize(3)) :: gx1,gy1,gz1
real(mytype), dimension(xsize(1),xsize(2),xsize(3)) :: hx1,hy1,hz1
real(mytype), dimension(xsize(1),xsize(2),xsize(3)) :: px1,py1,pz1
real(mytype), dimension(xsize(1),xsize(2),xsize(3)) :: phi1, phis1, phiss1
real(mytype), dimension(phG%zst(1):phG%zen(1),phG%zst(2):phG%zen(2),phG%zst(3):phG%zen(3)) :: pp3
integer (kind=MPI_OFFSET_KIND) :: filesize, disp
real(mytype) :: xdt
integer, dimension(2) :: dims, dummy_coords
logical, dimension(2) :: dummy_periods

if (iscalar==0) then
   if (nscheme.ne.4) then
      if (irestart==1) then !write
         call MPI_FILE_OPEN(MPI_COMM_WORLD, 'sauve.dat', &
              MPI_MODE_CREATE+MPI_MODE_WRONLY, MPI_INFO_NULL, &
              fh, ierror)
         filesize = 0_MPI_OFFSET_KIND
         call MPI_FILE_SET_SIZE(fh,filesize,ierror)  ! guarantee overwriting
         disp = 0_MPI_OFFSET_KIND
         call decomp_2d_write_var(fh,disp,1,ux1)
         call decomp_2d_write_var(fh,disp,1,uy1)
         call decomp_2d_write_var(fh,disp,1,uz1)
         call decomp_2d_write_var(fh,disp,1,gx1)
         call decomp_2d_write_var(fh,disp,1,gy1)
         call decomp_2d_write_var(fh,disp,1,gz1)
         call decomp_2d_write_var(fh,disp,1,px1)
         call decomp_2d_write_var(fh,disp,1,py1)
         call decomp_2d_write_var(fh,disp,1,pz1)
         call decomp_2d_write_var(fh,disp,1,pp3,phG)
         call MPI_FILE_CLOSE(fh,ierror)
      else
         if (nrank==0) print *,'RESTART'
         call MPI_FILE_OPEN(MPI_COMM_WORLD, 'sauve.dat', &
              MPI_MODE_RDONLY, MPI_INFO_NULL, &
              fh, ierror)
         disp = 0_MPI_OFFSET_KIND
         call decomp_2d_read_var(fh,disp,1,ux1)   
         call decomp_2d_read_var(fh,disp,1,uy1)
         call decomp_2d_read_var(fh,disp,1,uz1)
         call decomp_2d_read_var(fh,disp,1,gx1)
         call decomp_2d_read_var(fh,disp,1,gy1)
         call decomp_2d_read_var(fh,disp,1,gz1)
         call decomp_2d_read_var(fh,disp,1,px1)
         call decomp_2d_read_var(fh,disp,1,py1)
         call decomp_2d_read_var(fh,disp,1,pz1)
         call decomp_2d_read_var(fh,disp,1,pp3,phG)
         call MPI_FILE_CLOSE(fh,ierror)
      endif
   else !AB3
     if (irestart==1) then !write
         call MPI_FILE_OPEN(MPI_COMM_WORLD, 'sauve.dat', &
              MPI_MODE_CREATE+MPI_MODE_WRONLY, MPI_INFO_NULL, &
              fh, ierror)
         filesize = 0_MPI_OFFSET_KIND
         call MPI_FILE_SET_SIZE(fh,filesize,ierror)  ! guarantee overwriting
         disp = 0_MPI_OFFSET_KIND
         call decomp_2d_write_var(fh,disp,1,ux1)
         call decomp_2d_write_var(fh,disp,1,uy1)
         call decomp_2d_write_var(fh,disp,1,uz1)
         call decomp_2d_write_var(fh,disp,1,gx1)
         call decomp_2d_write_var(fh,disp,1,gy1)
         call decomp_2d_write_var(fh,disp,1,gz1)
         call decomp_2d_write_var(fh,disp,1,hx1)
         call decomp_2d_write_var(fh,disp,1,hy1)
         call decomp_2d_write_var(fh,disp,1,hz1)
         call decomp_2d_write_var(fh,disp,1,px1)
         call decomp_2d_write_var(fh,disp,1,py1)
         call decomp_2d_write_var(fh,disp,1,pz1)
         call decomp_2d_write_var(fh,disp,1,pp3,phG)
         call MPI_FILE_CLOSE(fh,ierror)
      else
         if (nrank==0) print *,'RESTART'
         call MPI_FILE_OPEN(MPI_COMM_WORLD, 'sauve.dat', &
              MPI_MODE_RDONLY, MPI_INFO_NULL, &
              fh, ierror)
         disp = 0_MPI_OFFSET_KIND
         call decomp_2d_read_var(fh,disp,1,ux1)   
         call decomp_2d_read_var(fh,disp,1,uy1)
         call decomp_2d_read_var(fh,disp,1,uz1)
         call decomp_2d_read_var(fh,disp,1,gx1)
         call decomp_2d_read_var(fh,disp,1,gy1)
         call decomp_2d_read_var(fh,disp,1,gz1)
         call decomp_2d_read_var(fh,disp,1,hx1)
         call decomp_2d_read_var(fh,disp,1,hy1)
         call decomp_2d_read_var(fh,disp,1,hz1)
         call decomp_2d_read_var(fh,disp,1,px1)
         call decomp_2d_read_var(fh,disp,1,py1)
         call decomp_2d_read_var(fh,disp,1,pz1)
         call decomp_2d_read_var(fh,disp,1,pp3,phG)
         call MPI_FILE_CLOSE(fh,ierror)
      endif 
   endif
else !SCALAR 
if (nscheme.ne.4) then
      if (irestart==1) then !write
         call MPI_FILE_OPEN(MPI_COMM_WORLD, 'sauve.dat', &
              MPI_MODE_CREATE+MPI_MODE_WRONLY, MPI_INFO_NULL, &
              fh, ierror)
         filesize = 0_MPI_OFFSET_KIND
         call MPI_FILE_SET_SIZE(fh,filesize,ierror)  ! guarantee overwriting
         disp = 0_MPI_OFFSET_KIND
         call decomp_2d_write_var(fh,disp,1,ux1)
         call decomp_2d_write_var(fh,disp,1,uy1)
         call decomp_2d_write_var(fh,disp,1,uz1)
         call decomp_2d_write_var(fh,disp,1,gx1)
         call decomp_2d_write_var(fh,disp,1,gy1)
         call decomp_2d_write_var(fh,disp,1,gz1)
         call decomp_2d_write_var(fh,disp,1,px1)
         call decomp_2d_write_var(fh,disp,1,py1)
         call decomp_2d_write_var(fh,disp,1,pz1)
         call decomp_2d_write_var(fh,disp,1,pp3,phG)
         call decomp_2d_write_var(fh,disp,1,phi1)
         call decomp_2d_write_var(fh,disp,1,phis1)
         call MPI_FILE_CLOSE(fh,ierror)
      else
         if (nrank==0) print *,'RESTART'
         call MPI_FILE_OPEN(MPI_COMM_WORLD, 'sauve.dat', &
              MPI_MODE_RDONLY, MPI_INFO_NULL, &
              fh, ierror)
         disp = 0_MPI_OFFSET_KIND
         call decomp_2d_read_var(fh,disp,1,ux1)   
         call decomp_2d_read_var(fh,disp,1,uy1)
         call decomp_2d_read_var(fh,disp,1,uz1)
         call decomp_2d_read_var(fh,disp,1,gx1)
         call decomp_2d_read_var(fh,disp,1,gy1)
         call decomp_2d_read_var(fh,disp,1,gz1)
         call decomp_2d_read_var(fh,disp,1,px1)
         call decomp_2d_read_var(fh,disp,1,py1)
         call decomp_2d_read_var(fh,disp,1,pz1)
         call decomp_2d_read_var(fh,disp,1,pp3,phG)
         call decomp_2d_read_var(fh,disp,1,phi1)
         call decomp_2d_read_var(fh,disp,1,phis1)
         call MPI_FILE_CLOSE(fh,ierror)
      endif
   else !SCALAR + AB3
     if (irestart==1) then !write
         call MPI_FILE_OPEN(MPI_COMM_WORLD, 'sauve.dat', &
              MPI_MODE_CREATE+MPI_MODE_WRONLY, MPI_INFO_NULL, &
              fh, ierror)
         filesize = 0_MPI_OFFSET_KIND
         call MPI_FILE_SET_SIZE(fh,filesize,ierror)  ! guarantee overwriting
         disp = 0_MPI_OFFSET_KIND
         call decomp_2d_write_var(fh,disp,1,ux1)
         call decomp_2d_write_var(fh,disp,1,uy1)
         call decomp_2d_write_var(fh,disp,1,uz1)
         call decomp_2d_write_var(fh,disp,1,gx1)
         call decomp_2d_write_var(fh,disp,1,gy1)
         call decomp_2d_write_var(fh,disp,1,gz1)
         call decomp_2d_write_var(fh,disp,1,hx1)
         call decomp_2d_write_var(fh,disp,1,hy1)
         call decomp_2d_write_var(fh,disp,1,hz1)
         call decomp_2d_write_var(fh,disp,1,px1)
         call decomp_2d_write_var(fh,disp,1,py1)
         call decomp_2d_write_var(fh,disp,1,pz1)
         call decomp_2d_write_var(fh,disp,1,pp3,phG)
         call decomp_2d_write_var(fh,disp,1,phi1)
         call decomp_2d_write_var(fh,disp,1,phis1)
         call decomp_2d_write_var(fh,disp,1,phiss1)
         call MPI_FILE_CLOSE(fh,ierror)
      else
         if (nrank==0) print *,'RESTART'
         call MPI_FILE_OPEN(MPI_COMM_WORLD, 'sauve.dat', &
              MPI_MODE_RDONLY, MPI_INFO_NULL, &
              fh, ierror)
         disp = 0_MPI_OFFSET_KIND
         call decomp_2d_read_var(fh,disp,1,ux1)   
         call decomp_2d_read_var(fh,disp,1,uy1)
         call decomp_2d_read_var(fh,disp,1,uz1)
         call decomp_2d_read_var(fh,disp,1,gx1)
         call decomp_2d_read_var(fh,disp,1,gy1)
         call decomp_2d_read_var(fh,disp,1,gz1)
         call decomp_2d_read_var(fh,disp,1,hx1)
         call decomp_2d_read_var(fh,disp,1,hy1)
         call decomp_2d_read_var(fh,disp,1,hz1)
         call decomp_2d_read_var(fh,disp,1,px1)
         call decomp_2d_read_var(fh,disp,1,py1)
         call decomp_2d_read_var(fh,disp,1,pz1)
         call decomp_2d_read_var(fh,disp,1,pp3,phG)
         call decomp_2d_read_var(fh,disp,1,phi1)
         call decomp_2d_read_var(fh,disp,1,phis1)
         call decomp_2d_read_var(fh,disp,1,phiss1)
         call MPI_FILE_CLOSE(fh,ierror)
      endif 
   endif
endif

if (irestart==0) then
! reconstruction of the dp/dx, dp/dy and dp/dz from px1,py1 and pz1
! Temporal scheme (1:AB2, 2: RK3, 3:RK4, 4:AB3)
   if (nscheme==1) xdt=adt(1)+bdt(1)
   if (nscheme==2) xdt=(3._mytype/4._mytype)*dt + (-5._mytype/12._mytype)*dt
   if (nscheme==3) xdt=0.041717869325_mytype*dt
   if (nscheme==4) xdt=adt(1)+bdt(1)+cdt(1)
   
   do k=1,xsize(3)
   do j=1,xsize(2)
      dpdyx1(j,k)=py1(1,j,k)/xdt
      dpdzx1(j,k)=pz1(1,j,k)/xdt
      dpdyxn(j,k)=py1(nx,j,k)/xdt
      dpdzxn(j,k)=pz1(nx,j,k)/xdt
   enddo
   enddo
   
   if (xsize(3)==1) then
      do j=1,xsize(2)
      do i=1,xsize(1)
         dpdxz1(i,j)=px1(i,j,1)/xdt
         dpdyz1(i,j)=py1(i,j,1)/xdt
      enddo
      enddo
   endif
   if (xsize(3)==nz) then
      do j=1,xsize(2)
      do i=1,xsize(1)
         dpdxzn(i,j)=px1(i,j,nz)/xdt
         dpdyzn(i,j)=py1(i,j,nz)/xdt
      enddo
      enddo
   endif

   ! determine the processor grid in use
   call MPI_CART_GET(DECOMP_2D_COMM_CART_X, 2, &
         dims, dummy_periods, dummy_coords, code)

   if (dims(1)==1) then
      do k=1,xsize(3)
      do i=1,xsize(1)
      dpdxy1(i,k)=px1(i,1,k)/xdt
      dpdzy1(i,k)=pz1(i,1,k)/xdt
      enddo
      enddo
      do k=1,xsize(3)
      do i=1,xsize(1)
      dpdxyn(i,k)=px1(i,xsize(2),k)/xdt
      dpdzyn(i,k)=pz1(i,xsize(2),k)/xdt
      enddo
      enddo
   else
!find j=1 and j=ny
      if (xstart(2)==1) then
         do k=1,xsize(3)
         do i=1,xsize(1)
         dpdxy1(i,k)=px1(i,1,k)/xdt
         dpdzy1(i,k)=pz1(i,1,k)/xdt
         enddo
         enddo
      endif
!      print *,nrank,xstart(2),ny-(nym/p_row)
       if (ny-(nym/dims(1))==xstart(2)) then
         do k=1,xsize(3)
         do i=1,xsize(1)
         dpdxyn(i,k)=px1(i,xsize(2),k)/xdt
         dpdzyn(i,k)=pz1(i,xsize(2),k)/xdt
         enddo
         enddo
      endif

   endif


   if (nrank==0) print *,'reconstruction pressure gradients done!'
endif

if (irestart==0) then
if (ivirt==2) then
   call MPI_FILE_OPEN(MPI_COMM_WORLD, 'epsilon.dat', &
        MPI_MODE_RDONLY, MPI_INFO_NULL, &
        fh, ierror)
   disp = 0_MPI_OFFSET_KIND
   call decomp_2d_read_var(fh,disp,1,ep1) 
   call MPI_FILE_CLOSE(fh,ierror)
   if (nrank==0) print *,'read epsilon file done from restart'
endif
endif

end subroutine restart
!
!*******************************************************************
subroutine stretching()
!
!*******************************************************************
!
USE decomp_2d
USE decomp_2d_poisson
USE variables
USE param
USE var
USE MPI

implicit none

real(mytype) :: yinf,den,xnum,xcx,den1,den2,den3,den4,xnum1,cst
integer :: j

yinf=-yly/2._mytype
den=2._mytype*beta*yinf
xnum=-yinf-sqrt(pi*pi*beta*beta+yinf*yinf)
alpha=abs(xnum/den)
xcx=1._mytype/beta/alpha
if (alpha.ne.0._mytype) then
   if (istret.eq.1) yp(1)=0._mytype
   if (istret.eq.2) yp(1)=0._mytype
   if (istret.eq.1) yeta(1)=0._mytype
   if (istret.eq.2) yeta(1)=-1._mytype/2._mytype
   if (istret.eq.3) yp(1)=0._mytype
   if (istret.eq.3) yeta(1)=-1._mytype/2._mytype
   do j=2,ny!-1
      if (istret==1) then
         if (ncly.eq.0) yeta(j)=(j-1._mytype)*(1._mytype/ny)
         if ((ncly.eq.1).or.(ncly.eq.2)) yeta(j)=(j-1._mytype)*(1._mytype/(ny-1._mytype))
      endif
      if (istret==2) then
         if (ncly.eq.0) yeta(j)=(j-1._mytype)*(1._mytype/ny)-0.5_mytype
         if ((ncly.eq.1).or.(ncly.eq.2)) yeta(j)=(j-1._mytype)*(1._mytype/(ny-1._mytype))-0.5_mytype
      endif
      if (istret==3) then
         if (ncly.eq.0) yeta(j)=((j-1._mytype)*(1._mytype/2._mytype/ny)-0.5_mytype)
         if ((ncly.eq.1).or.(ncly.eq.2)) yeta(j)=((j-1._mytype)*(1._mytype/2._mytype/(ny-1._mytype))-0.5_mytype)
      endif
      den1=sqrt(alpha*beta+1.)
      xnum=den1/sqrt(alpha/pi)/sqrt(beta)/sqrt(pi)
      den=2._mytype*sqrt(alpha/pi)*sqrt(beta)*pi*sqrt(pi)
      den3=((sin(pi*yeta(j)))*(sin(pi*yeta(j)))/beta/pi)+alpha/pi
      den4=2._mytype*alpha*beta-cos(2._mytype*pi*yeta(j))+1._mytype
      if ((ncly.ne.0).and.(j==ny).and.(istret==1)) then
         xnum1=0._mytype
      else
         xnum1=(atan(xnum*tan(pi*yeta(j))))*den4/den1/den3/den
      endif
      cst=sqrt(beta)*pi/(2._mytype*sqrt(alpha)*sqrt(alpha*beta+1._mytype))
      if (istret==1) then
         if (yeta(j).lt.0.5_mytype) yp(j)=xnum1-cst-yinf
         if (yeta(j).eq.0.5_mytype) yp(j)=0._mytype-yinf
         if (yeta(j).gt.0.5_mytype) yp(j)=xnum1+cst-yinf
      endif
      if (istret==2) then
         if (yeta(j).lt.0.5_mytype) yp(j)=xnum1-cst+yly
         if (yeta(j).eq.0.5_mytype) yp(j)=0._mytype+yly
         if (yeta(j).gt.0.5_mytype) yp(j)=xnum1+cst+yly
      endif
      if (istret==3) then
         if (yeta(j).lt.0.5_mytype) yp(j)=(xnum1-cst+yly)*2._mytype
         if (yeta(j).eq.0.5_mytype) yp(j)=(0._mytype+yly)*2._mytype
         if (yeta(j).gt.0.5_mytype) yp(j)=(xnum1+cst+yly)*2._mytype
      endif
   enddo

endif
!if (nrank==0) then
!do j=1,ny
!print *,j,yp(j),yeta(j)
!enddo
!endif
!stop
if (alpha.eq.0.) then
   yp(1)=-1.e10_mytype
   do j=2,ny
      yeta(j)=(j-1._mytype)*(1._mytype/ny)
      yp(j)=-beta*cos(pi*yeta(j))/sin(yeta(j)*pi)
   enddo
endif
if (alpha.ne.0._mytype) then
   do j=1,ny
      if (istret==1) then
         if (ncly.eq.0) yetai(j)=(j-0.5_mytype)*(1._mytype/ny)
         if ((ncly.eq.1).or.(ncly.eq.2)) yetai(j)=(j-0.5_mytype)*(1._mytype/(ny-1._mytype))
      endif
      if (istret==2) then
         if (ncly.eq.0) yetai(j)=(j-0.5_mytype)*(1._mytype/ny)-0.5_mytype
         if ((ncly.eq.1).or.(ncly.eq.2)) yetai(j)=(j-0.5_mytype)*(1._mytype/(ny-1._mytype))-0.5_mytype
      endif
      if (istret==3) then
         if (ncly.eq.0) yetai(j)=(j-0.5)*(1./2./ny)-0.5_mytype
         if ((ncly.eq.1).or.(ncly.eq.2)) yetai(j)=(j-0.5_mytype)*(1._mytype/2._mytype/(ny-1._mytype))-0.5_mytype
      endif
      
      den1=sqrt(alpha*beta+1.)
      xnum=den1/sqrt(alpha/pi)/sqrt(beta)/sqrt(pi)
      den=2._mytype*sqrt(alpha/pi)*sqrt(beta)*pi*sqrt(pi)
      den3=((sin(pi*yetai(j)))*(sin(pi*yetai(j)))/beta/pi)+alpha/pi
      den4=2._mytype*alpha*beta-cos(2._mytype*pi*yetai(j))+1.
      xnum1=(atan(xnum*tan(pi*yetai(j))))*den4/den1/den3/den
      cst=sqrt(beta)*pi/(2._mytype*sqrt(alpha)*sqrt(alpha*beta+1.))
      if (istret==1) then
         if (yetai(j).lt.0.5_mytype) ypi(j)=xnum1-cst-yinf
         if (yetai(j).eq.0.5_mytype) ypi(j)=0._mytype-yinf
         if (yetai(j).gt.0.5_mytype) ypi(j)=xnum1+cst-yinf
      endif
      if (istret==2) then
         if (yetai(j).lt.0.5_mytype) ypi(j)=xnum1-cst+yly
         if (yetai(j).eq.0.5_mytype) ypi(j)=0._mytype+yly
         if (yetai(j).gt.0.5_mytype) ypi(j)=xnum1+cst+yly
      endif
      if (istret==3) then
         if (yetai(j).lt.0.5_mytype) ypi(j)=(xnum1-cst+yly)*2._mytype
         if (yetai(j).eq.0.5_mytype) ypi(j)=(0._mytype+yly)*2._mytype
         if (yetai(j).gt.0.5_mytype) ypi(j)=(xnum1+cst+yly)*2._mytype
      endif
   enddo
endif
if (alpha.eq.0._mytype) then
   ypi(1)=-1.e10_mytype
   do j=2,ny
      yetai(j)=(j-1._mytype)*(1._mytype/ny)
      ypi(j)=-beta*cos(pi*yetai(j))/sin(yetai(j)*pi)
   enddo
endif

do j=1,ny
   ppy(j)=yly*(alpha/pi+(1./pi/beta)*sin(pi*yeta(j))* &
        sin(pi*yeta(j)))
   pp2y(j)=ppy(j)*ppy(j)
   pp4y(j)=(-2._mytype/beta*cos(pi*yeta(j))*sin(pi*yeta(j)))
enddo
do j=1,ny
   ppyi(j)=yly*(alpha/pi+(1./pi/beta)*sin(pi*yetai(j))* &
        sin(pi*yetai(j)))
   pp2yi(j)=ppyi(j)*ppyi(j)
   pp4yi(j)=(-2._mytype/beta*cos(pi*yetai(j))*sin(pi*yetai(j)))
enddo

end subroutine stretching

!*****************************************************************
!
subroutine inversion5_v1(aaa,eee,spI)
!
!*****************************************************************

USE decomp_2d
USE decomp_2d_poisson
USE variables
USE param
USE var
USE MPI

implicit none

! decomposition object for spectral space
TYPE(DECOMP_INFO) :: spI

#ifdef DOUBLE_PREC
  real(mytype), parameter :: epsilon = 1.e-16_mytype
#else
  real(mytype), parameter :: epsilon = 1.e-8_mytype
#endif

complex(mytype),dimension(spI%yst(1):spI%yen(1),ny/2,spI%yst(3):spI%yen(3),5) :: aaa
complex(mytype),dimension(spI%yst(1):spI%yen(1),spI%yst(2):spI%yen(2),spI%yst(3):spI%yen(3)) :: eee
integer :: i,j,k,m,mi,jc
integer,dimension(2) :: ja,jb
complex(mytype),dimension(spI%yst(1):spI%yen(1),spI%yst(3):spI%yen(3)) :: sr
complex(mytype),dimension(spI%yst(1):spI%yen(1),spI%yst(3):spI%yen(3)) :: a1,b1

real(mytype) :: tmp1,tmp2,tmp3,tmp4

do i=1,2
   ja(i)=4-i
   jb(i)=5-i
enddo
do m=1,ny/2-2
   do i=1,2
      mi=m+i
      do k=spI%yst(3),spI%yen(3)
      do j=spI%yst(1),spI%yen(1) 
         if (real(aaa(j,m,k,3), kind=mytype).ne.0._mytype) tmp1=real(aaa(j,mi,k,3-i), kind=mytype)/real(aaa(j,m,k,3), kind=mytype)
         if (aimag(aaa(j,m,k,3)).ne.0._mytype)tmp2=aimag(aaa(j,mi,k,3-i))/aimag(aaa(j,m,k,3))
         sr(j,k)=cmplx(tmp1,tmp2, kind=mytype)
         eee(j,mi,k)=cmplx(real(eee(j,mi,k), kind=mytype)-tmp1*real(eee(j,m,k), kind=mytype),&
              aimag(eee(j,mi,k))-tmp2*aimag(eee(j,m,k)), kind=mytype)
      enddo
      enddo
      do jc=ja(i),jb(i)
      do k=spI%yst(3),spI%yen(3)
      do j=spI%yst(1),spI%yen(1) 
         aaa(j,mi,k,jc)=cmplx(real(aaa(j,mi,k,jc), kind=mytype)-real(sr(j,k), kind=mytype)*real(aaa(j,m,k,jc+i), kind=mytype),&
              aimag(aaa(j,mi,k,jc))-aimag(sr(j,k))*aimag(aaa(j,m,k,jc+i)), kind=mytype)
      enddo
      enddo
      enddo
   enddo
enddo


do k=spI%yst(3),spI%yen(3)
do j=spI%yst(1),spI%yen(1) 
   if (abs(real(aaa(j,ny/2-1,k,3), kind=mytype)).gt.epsilon) then
      tmp1=real(aaa(j,ny/2,k,2), kind=mytype)/real(aaa(j,ny/2-1,k,3), kind=mytype)
   else
      tmp1=0._mytype
   endif
   if (abs(aimag(aaa(j,ny/2-1,k,3))).gt.epsilon) then
      tmp2=aimag(aaa(j,ny/2,k,2))/aimag(aaa(j,ny/2-1,k,3))
   else
      tmp2=0._mytype
   endif
   sr(j,k)=cmplx(tmp1,tmp2, kind=mytype)
   b1(j,k)=cmplx(real(aaa(j,ny/2,k,3), kind=mytype)-tmp1*real(aaa(j,ny/2-1,k,4), kind=mytype),&
        aimag(aaa(j,ny/2,k,3))-tmp2*aimag(aaa(j,ny/2-1,k,4)), kind=mytype)

   if (abs(real(b1(j,k), kind=mytype)).gt.epsilon) then
      tmp1=real(sr(j,k), kind=mytype)/real(b1(j,k), kind=mytype)
      tmp3=real(eee(j,ny/2,k), kind=mytype)/real(b1(j,k), kind=mytype)-tmp1*real(eee(j,ny/2-1,k), kind=mytype)
   else
      tmp1=0._mytype
      tmp3=0._mytype
   endif
   if (abs(aimag(b1(j,k))).gt.epsilon) then
      tmp2=aimag(sr(j,k))/aimag(b1(j,k))
      tmp4=aimag(eee(j,ny/2,k))/aimag(b1(j,k))-tmp2*aimag(eee(j,ny/2-1,k))
   else
      tmp2=0._mytype
      tmp4=0._mytype
   endif
   a1(j,k)=cmplx(tmp1,tmp2, kind=mytype)
   eee(j,ny/2,k)=cmplx(tmp3,tmp4, kind=mytype)
   
   if (abs(real(aaa(j,ny/2-1,k,3), kind=mytype)).gt.epsilon) then
      tmp1=1._mytype/real(aaa(j,ny/2-1,k,3), kind=mytype)
   else
      tmp1=0.
   endif
   if (abs(aimag(aaa(j,ny/2-1,k,3))).gt.epsilon) then
      tmp2=1._mytype/aimag(aaa(j,ny/2-1,k,3))
   else
      tmp2=0._mytype
   endif
   b1(j,k)=cmplx(tmp1,tmp2, kind=mytype)
   a1(j,k)=cmplx(real(aaa(j,ny/2-1,k,4), kind=mytype)*real(b1(j,k), kind=mytype),&
        aimag(aaa(j,ny/2-1,k,4))*aimag(b1(j,k)), kind=mytype)
   eee(j,ny/2-1,k)=cmplx(real(eee(j,ny/2-1,k))*real(b1(j,k))-real(a1(j,k))*real(eee(j,ny/2,k)),&
        aimag(eee(j,ny/2-1,k))*aimag(b1(j,k))-aimag(a1(j,k))*aimag(eee(j,ny/2,k)), kind=mytype)
enddo
enddo

do i=ny/2-2,1,-1
do k=spI%yst(3),spI%yen(3)
do j=spI%yst(1),spI%yen(1) 
   if (abs(real(aaa(j,i,k,3), kind=mytype)).gt.epsilon) then
      tmp1=1._mytype/real(aaa(j,i,k,3), kind=mytype)
   else
      tmp1=0._mytype
   endif
   if (abs(aimag(aaa(j,i,k,3))).gt.epsilon) then
      tmp2=1._mytype/aimag(aaa(j,i,k,3))
   else
      tmp2=0._mytype
   endif
   sr(j,k)=cmplx(tmp1,tmp2, kind=mytype)
   a1(j,k)=cmplx(real(aaa(j,i,k,4), kind=mytype)*real(sr(j,k), kind=mytype),&
        aimag(aaa(j,i,k,4))*aimag(sr(j,k)), kind=mytype)
   b1(j,k)=cmplx(real(aaa(j,i,k,5), kind=mytype)*real(sr(j,k), kind=mytype),&
        aimag(aaa(j,i,k,5))*aimag(sr(j,k)), kind=mytype)
   eee(j,i,k)=cmplx(real(eee(j,i,k), kind=mytype)*real(sr(j,k), kind=mytype)-&
        real(a1(j,k), kind=mytype)*real(eee(j,i+1,k), kind=mytype)-&
        real(b1(j,k), kind=mytype)*real(eee(j,i+2,k), kind=mytype),&
        aimag(eee(j,i,k))*aimag(sr(j,k))-&
        aimag(a1(j,k))*aimag(eee(j,i+1,k))-aimag(b1(j,k))*aimag(eee(j,i+2,k)), kind=mytype)
enddo
enddo
enddo

return

end subroutine inversion5_v1 

!*****************************************************************
!
subroutine inversion5_v2(aaa,eee,spI)
!
!*****************************************************************

USE decomp_2d
USE decomp_2d_poisson
USE variables
USE param
USE var
USE MPI

implicit none

! decomposition object for spectral space
TYPE(DECOMP_INFO) :: spI

#ifdef DOUBLE_PREC
  real(mytype), parameter :: epsilon = 1.e-16_mytype
#else
  real(mytype), parameter :: epsilon = 1.e-8_mytype
#endif

complex(mytype),dimension(spI%yst(1):spI%yen(1),nym,spI%yst(3):spI%yen(3),5) :: aaa
complex(mytype),dimension(spI%yst(1):spI%yen(1),nym,spI%yst(3):spI%yen(3)) :: eee
integer :: i,j,k,m,mi,jc
integer,dimension(2) :: ja,jb
complex(mytype),dimension(spI%yst(1):spI%yen(1),spI%yst(3):spI%yen(3)) :: sr
complex(mytype),dimension(spI%yst(1):spI%yen(1),spI%yst(3):spI%yen(3)) :: a1,b1

real(mytype) :: tmp1,tmp2,tmp3,tmp4

do i=1,2
   ja(i)=4-i
   jb(i)=5-i
enddo
do m=1,nym-2
do i=1,2
   mi=m+i
   do k=spI%yst(3),spI%yen(3)
   do j=spI%yst(1),spI%yen(1) 
      if (real(aaa(j,m,k,3), kind=mytype).ne.0._mytype) tmp1=real(aaa(j,mi,k,3-i), kind=mytype)/real(aaa(j,m,k,3), kind=mytype)
      if (aimag(aaa(j,m,k,3)).ne.0._mytype)tmp2=aimag(aaa(j,mi,k,3-i))/aimag(aaa(j,m,k,3))
      sr(j,k)=cmplx(tmp1,tmp2, kind=mytype)
      eee(j,mi,k)=cmplx(real(eee(j,mi,k), kind=mytype)-tmp1*real(eee(j,m,k), kind=mytype),&
           aimag(eee(j,mi,k))-tmp2*aimag(eee(j,m,k)), kind=mytype)
   enddo
   enddo
   do jc=ja(i),jb(i)
   do k=spI%yst(3),spI%yen(3)
   do j=spI%yst(1),spI%yen(1) 
      aaa(j,mi,k,jc)=cmplx(real(aaa(j,mi,k,jc), kind=mytype)-real(sr(j,k), kind=mytype)*real(aaa(j,m,k,jc+i), kind=mytype),&
           aimag(aaa(j,mi,k,jc))-aimag(sr(j,k))*aimag(aaa(j,m,k,jc+i)), kind=mytype)
   enddo
   enddo
   enddo
enddo
enddo
do k=spI%yst(3),spI%yen(3)
do j=spI%yst(1),spI%yen(1) 
   if (abs(real(aaa(j,nym-1,k,3), kind=mytype)).gt.epsilon) then
      tmp1=real(aaa(j,nym,k,2), kind=mytype)/real(aaa(j,nym-1,k,3), kind=mytype)
   else
      tmp1=0._mytype
   endif
   if (abs(aimag(aaa(j,nym-1,k,3))).gt.epsilon) then
      tmp2=aimag(aaa(j,nym,k,2))/aimag(aaa(j,nym-1,k,3))
   else
      tmp2=0._mytype
   endif
   sr(j,k)=cmplx(tmp1,tmp2, kind=mytype)
   b1(j,k)=cmplx(real(aaa(j,nym,k,3), kind=mytype)-tmp1*real(aaa(j,nym-1,k,4), kind=mytype),&
        aimag(aaa(j,nym,k,3))-tmp2*aimag(aaa(j,nym-1,k,4)), kind=mytype)
   if (abs(real(b1(j,k), kind=mytype)).gt.epsilon) then
      tmp1=real(sr(j,k), kind=mytype)/real(b1(j,k), kind=mytype)
      tmp3=real(eee(j,nym,k), kind=mytype)/real(b1(j,k), kind=mytype)-tmp1*real(eee(j,nym-1,k), kind=mytype)
   else
      tmp1=0._mytype
      tmp3=0._mytype
   endif
   if (abs(aimag(b1(j,k))).gt.epsilon) then
      tmp2=aimag(sr(j,k))/aimag(b1(j,k))
      tmp4=aimag(eee(j,nym,k))/aimag(b1(j,k))-tmp2*aimag(eee(j,nym-1,k))
   else
      tmp2=0._mytype
      tmp4=0._mytype
   endif
   a1(j,k)=cmplx(tmp1,tmp2, kind=mytype)
   eee(j,nym,k)=cmplx(tmp3,tmp4, kind=mytype)
   
   if (abs(real(aaa(j,nym-1,k,3), kind=mytype)).gt.epsilon) then
      tmp1=1._mytype/real(aaa(j,nym-1,k,3), kind=mytype)
   else
      tmp1=0._mytype
   endif
   if (abs(aimag(aaa(j,nym-1,k,3))).gt.epsilon) then
      tmp2=1._mytype/aimag(aaa(j,nym-1,k,3))
   else
      tmp2=0._mytype
   endif
   b1(j,k)=cmplx(tmp1,tmp2, kind=mytype)
   a1(j,k)=cmplx(real(aaa(j,nym-1,k,4), kind=mytype)*real(b1(j,k), kind=mytype),&
        aimag(aaa(j,nym-1,k,4))*aimag(b1(j,k)), kind=mytype)
   eee(j,nym-1,k)=cmplx(real(eee(j,nym-1,k), kind=mytype)*real(b1(j,k), kind=mytype)-&
        real(a1(j,k), kind=mytype)*real(eee(j,nym,k), kind=mytype),&
        aimag(eee(j,nym-1,k))*aimag(b1(j,k))-aimag(a1(j,k))*aimag(eee(j,nym,k)), kind=mytype)
enddo
enddo

do i=nym-2,1,-1
do k=spI%yst(3),spI%yen(3)
do j=spI%yst(1),spI%yen(1) 
   if (abs(real(aaa(j,i,k,3), kind=mytype)).gt.epsilon) then
      tmp1=1._mytype/real(aaa(j,i,k,3), kind=mytype)
   else
      tmp1=0._mytype
   endif
   if (abs(aimag(aaa(j,i,k,3))).gt.epsilon) then
      tmp2=1._mytype/aimag(aaa(j,i,k,3))
   else
      tmp2=0._mytype
   endif
   sr(j,k)=cmplx(tmp1,tmp2, kind=mytype)
   a1(j,k)=cmplx(real(aaa(j,i,k,4), kind=mytype)*real(sr(j,k), kind=mytype),&
        aimag(aaa(j,i,k,4))*aimag(sr(j,k)), kind=mytype)
   b1(j,k)=cmplx(real(aaa(j,i,k,5), kind=mytype)*real(sr(j,k), kind=mytype),&
        aimag(aaa(j,i,k,5))*aimag(sr(j,k)), kind=mytype)
   eee(j,i,k)=cmplx(real(eee(j,i,k), kind=mytype)*real(sr(j,k), kind=mytype)-&
        real(a1(j,k), kind=mytype)*real(eee(j,i+1,k), kind=mytype)-&
        real(b1(j,k), kind=mytype)*real(eee(j,i+2,k), kind=mytype),&
        aimag(eee(j,i,k))*aimag(sr(j,k))-&
        aimag(a1(j,k))*aimag(eee(j,i+1,k))-aimag(b1(j,k))*aimag(eee(j,i+2,k)), kind=mytype)
enddo
enddo
enddo

return

end subroutine inversion5_v2

!********************************************************************
!
subroutine channel (ux)
!
!********************************************************************

USE decomp_2d
USE decomp_2d_poisson
USE variables
USE param
USE var
USE MPI

implicit none

real(mytype),dimension(ysize(1),ysize(2),ysize(3)) :: ux

integer :: j,i,k,code
real(mytype) :: can,ut3,ut,ut4

ut3=0.
do k=1,ysize(3)
do i=1,ysize(1)
   ut=0.
   do j=1,ny-1
      if (istret.ne.0) ut=ut+(yp(j+1)-yp(j))*(ux(i,j+1,k)-0.5_mytype*(ux(i,j+1,k)-ux(i,j,k)))
      if (istret.eq.0) ut=ut+(yly/(ny-1))*(ux(i,j+1,k)-0.5_mytype*(ux(i,j+1,k)-ux(i,j,k)))
   enddo
   ut=ut/yly
   ut3=ut3+ut
enddo
enddo
ut3=ut3/ysize(1)/ysize(3)

call MPI_ALLREDUCE(ut3,ut4,1,real_type,MPI_SUM,MPI_COMM_WORLD,code)
ut4=ut4/nproc

!can=-2.*xnu*gdt(itr) ! Poisseuille    
can=-(2._mytype/3._mytype-ut4) ! constant flow rate

if (nrank==0) print *,nrank,'UT',ut4,can

do k=1,ysize(3)
do i=1,ysize(1)
do j=2,ny-1
   ux(i,j,k)=-can+ux(i,j,k)
enddo
enddo
enddo

return
end subroutine channel



!*****************************************************************
!
subroutine collect_data()
!
!*****************************************************************

USE decomp_2d
USE decomp_2d_poisson
USE variables
USE param
USE var
USE MPI

implicit none

integer :: i,j,imin,ii,code
real(mytype), dimension(200) :: ta
integer,dimension(200) :: tai,tbi

!TOTAL TIME FOR COLLECTION T=50000*0.01=500
!I want 100 files
!100 numbers from 0 to 500

if (nrank==0) then
call random_number(ta)
do i=1,200
   tai(i)=int(ta(i)*2000./dt)
enddo
do j=1,200
imin=999998
ii=0
do i=1,200
   if (tai(i).le.imin) then
      imin=tai(i)
      ii=i
   endif
enddo
tbi(j)=imin
tai(ii)=999999
enddo
idata=tbi
do i=1,200
print *,i,idata(i),'VALUE COLLECTION DATA'
enddo
endif

call MPI_BCAST(idata,200,MPI_INTEGER,0,MPI_COMM_WORLD,code)

end subroutine collect_data

!*****************************************************************
!  SUBROUTINE: eval_error
! DESCRIPTION: Given a (known) solution, compare with numerical
!              value and compute (normalised) l2 norm.
!*****************************************************************
SUBROUTINE eval_error(sol_num, sol_exact, name)

  USE var
  USE MPI
  
  IMPLICIT NONE

  REAL(mytype), INTENT(IN), DIMENSION(xsize(1),xsize(2),xsize(3)) :: sol_num, sol_exact
  CHARACTER(LEN=*), INTENT(IN) :: name

  REAL(mytype) :: err
  INTEGER :: ijk
  INTEGER :: nvect1
  INTEGER :: ierr

  nvect1 = xsize(1) * xsize(2) * xsize(3)
  err = 0._mytype
  DO ijk = 1,nvect1
    err = err + (sol_num(ijk,1,1) - sol_exact(ijk,1,1))**2
  ENDDO

  CALL MPI_ALLREDUCE(MPI_IN_PLACE, err, 1, MPI_DOUBLE, MPI_SUM, MPI_COMM_WORLD, ierr)
  err = err / float(nxm * nym * nzm)
  err = err**0.5

  IF (nrank.eq.0) THEN
    PRINT *, "Error in ", name, " = ", err
  ENDIF
  
ENDSUBROUTINE eval_error

!*****************************************************************
!  SUBROUTINE: eval_error_vel
! DESCRIPTION: Compute an exact solution for rho and compare with
!              the numerically obtained solution.
!*****************************************************************
SUBROUTINE eval_error_vel(ux1_num, uy1_num, uz1_num)

  USE var
  USE MPI

  IMPLICIT NONE

  REAL(mytype), INTENT(IN), DIMENSION(xsize(1),xsize(2),xsize(3)) :: ux1_num, uy1_num, uz1_num

  REAL(mytype), DIMENSION(xsize(1),xsize(2),xsize(3)) :: ux1_exact, uy1_exact, uz1_exact
  REAL(mytype) :: x,y,z
  REAL(mytype) :: xspec,yspec,zspec
  INTEGER :: i,j,k

  ! Compute the exact solution
  DO k = 1, xsize(3)
    z = float(k + xstart(3) - 2) * dz
    zspec = (2._mytype * PI) * (z / zlz)
    DO j = 1, xsize(2)
      y = float(j + xstart(2) - 2) * dy
      yspec = (2._mytype * PI) * (y / yly)
      DO i = 1, xsize(1)
        x = float(i + xstart(1) - 2) * dx
        xspec = (2._mytype * PI) * (x / xlx)

        ux1_exact(i,j,k) = (xlx / (2._mytype * PI)) * SIN(xspec) * COS(yspec) * COS(zspec)
        uy1_exact(i,j,k) = (yly / (2._mytype * PI)) * COS(xspec) * SIN(yspec) * COS(zspec)
        uz1_exact(i,j,k) = -2._mytype * (zlz / (2._mytype * PI)) * COS(xspec) * COS(yspec) * SIN(zspec)
      ENDDO
    ENDDO
  ENDDO

  ! Compare against the numerical solution
  CALL eval_error(ux1_num, ux1_exact, "UVEL")
  CALL eval_error(uy1_num, uy1_exact, "VVEL")
  CALL eval_error(uz1_num, uz1_exact, "WVEL")
  
ENDSUBROUTINE eval_error_vel

!*****************************************************************
!  SUBROUTINE: eval_error_rho
! DESCRIPTION: Compute an exact solution for rho and compare with
!              the numerically obtained solution.
!*****************************************************************
SUBROUTINE eval_error_rho(rho_num)

  USE var
  USE MPI

  IMPLICIT NONE

  REAL(mytype), INTENT(IN), DIMENSION(xsize(1),xsize(2),xsize(3)) :: rho_num

  REAL(mytype), DIMENSION(xsize(1),xsize(2),xsize(3)) :: rho_exact
  REAL(mytype) :: x,y,z
  REAL(mytype) :: xspec,yspec,zspec
  INTEGER :: i,j,k

  ! Compute the exact solution
  DO k = 1, xsize(3)
    z = float(k + xstart(3) - 2) * dz
    zspec = (2._mytype * PI) * (z / zlz)
    DO j = 1, xsize(2)
      y = float(j + xstart(2) - 2) * dy
      yspec = (2._mytype * PI) * (y / yly)
      DO i = 1, xsize(1)
        x = float(i + xstart(1) - 2) * dx
        xspec = (2._mytype * PI) * (x / xlx)
        rho_exact(i, j, k) = 2._mytype + SIN(xspec) * SIN(yspec) * SIN(zspec)
      ENDDO
    ENDDO
  ENDDO

  ! Compare against the numerical solution
  CALL eval_error(rho_num, rho_exact, "RHO")
  
ENDSUBROUTINE eval_error_rho

!*****************************************************************
!  SUBROUTINE: updateXYZ
! DESCRIPTION: Given a set of new values in pencil 'X', update
!              by transposing to 'Y' then 'Z'.
!       INPUT: var1, the variable in 'X' stencil
!              size1, the size array of var1
!              size2, the size array of var2
!              size3, the size array of var3
!              idx1, the actual pencil of var1: 1 = X, 2 = Y, 3 = Z
!              idx2, the actual pencil of var2: 1 = X, 2 = Y, 3 = Z
!              idx3, the actual pencil of var3: 1 = X, 2 = Y, 3 = Z
!      OUTPUT: var2, var3 the variable in 'Y' and 'Z' stencils
!              with updated values
!*****************************************************************
SUBROUTINE updateXYZ(var1, var2, var3, size1, size2, size3, idx1, idx2, idx3)

  USE var
  
  IMPLICIT NONE

  INTEGER, INTENT(IN) :: idx1, idx2, idx3
  INTEGER, DIMENSION(3), INTENT(IN) :: size1, size2, size3

  REAL(mytype), DIMENSION(size1(1), size1(2), size1(3)), INTENT(IN) :: var1
  REAL(mytype), DIMENSION(size2(1), size2(2), size2(3)), INTENT(OUT) :: var2
  REAL(mytype), DIMENSION(size3(1), size3(2), size3(3)), INTENT(OUT) :: var3

  ! IF((idx1.EQ.idx2).OR.(idx1.EQ.idx3).OR.(idx2.EQ.idx3)) THEN
  !   PRINT *, "Transpose: ", idx1, "->", idx2, "->" idx3, " is invalid!"
  !   STOP
  ! ENDIF

  ! idx1->idx2
  IF(idx1.EQ.1) THEN
    IF(idx2.EQ.2) THEN
      CALL transpose_x_to_y(var1, var2)
    ELSE
      PRINT *, "X->Z not yet implemented"
      STOP
      ! CALL transpose_x_to_z(var1, var2)
    ENDIF
  ELSEIF(idx1.EQ.2) THEN
    IF(idx2.EQ.1) THEN
      CALL transpose_y_to_x(var1, var2)
    ELSE
      CALL transpose_y_to_z(var1, var2)
    ENDIF
  ELSE
    IF(idx2.EQ.1) THEN
      PRINT *, "Z->X not yet implemented"
      STOP
      ! CALL transpose_z_to_x(var1, var2)
    ELSE
      CALL transpose_z_to_y(var1, var2)
    ENDIF
  ENDIF

  ! idx2->idx3
  IF(idx2.EQ.1) THEN
    IF(idx3.EQ.2) THEN
      CALL transpose_x_to_y(var2, var3)
    ELSE
      PRINT *, "X->Z not yet implemented"
      STOP
      ! CALL transpose_x_to_z(var2, var3)
    ENDIF
  ELSEIF(idx2.EQ.2) THEN
    IF(idx3.EQ.1) THEN
      CALL transpose_y_to_x(var2, var3)
    ELSE
      CALL transpose_y_to_z(var2, var3)
    ENDIF
  ELSE
    IF(idx3.EQ.1) THEN
      PRINT *, "Z->X not yet implemented"
      STOP
      ! CALL transpose_z_to_x(var2, var3)
    ELSE
      CALL transpose_z_to_y(var2, var3)
    ENDIF
  ENDIF
    
ENDSUBROUTINE updateXYZ

