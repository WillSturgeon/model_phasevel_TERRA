
C program expand_4
C This subroutine expands velocity models delta_vs/vs in spherical 
C harmonics

      implicit double precision (a-h,o-z)
      character*80 f177,fsph177, getunx
      integer lmaxin
      data lhmodel/0/
      data lhmax/0/


      call chekcl('|  :r:1:Heterogeneous model file'
     1          //'|-lmax:o:1:max spherical harmonic degree'      
     1          //'|')
       
      lmax=inunx('-lmax',1,llmax)
      f177=getunx(' ',1,lhmodel)

      fmul=1.

      write(*,*) 'lmax ',lmax
      write(*,*)'input file ',f177
      write(*,*) len_trim(f177)

      call expand2(f177,lmax,fmul)

      end

C ---------------------------------------------------------

      subroutine expand2(f177,lmax,fmul)

      implicit double precision (a-h,o-z)
      parameter (MXORD=100)
      dimension a1(((MXORD+2)*(MXORD+3))/2)
     1    ,a2(((MXORD+2)*(MXORD+3))/2)
     1    ,dwk1(MXORD+5),dwk2(MXORD+5)
     1    ,ya((MXORD+1)**2)
      dimension grid(360,180),in(72)
      character*80 getunx,oform,hmask,rname,dummy,f177,fsph177
      real reunx
      real*4 the1,the2

      oform='r'
      loform=len(oform)
      

      if(lmax.gt.MXORD) stop 'increase dimensions'

      pi=4.d0*datan(1.d0)
      radian=180.d0/pi

      open(1,file=f177,status='old')

      if(lhmask.le.0) then

        nx=180    ! c2.0
        ny=90     ! c2.0

c        write(*,*)'lhmask',lhmask, nx, ny

        read(1,*) ((grid(ix,iy),iy=1,ny),ix=1,nx)
        close(1)

c        write(*,*)'grid', '1,1 ', grid(1,1), '   1,2',grid(1,2),'   1,10',grid(1,10),'   2,1', grid(2,1)

        dth=180.d0/(ny*radian)
        dph=360.d0/(nx*radian)
      else

        nx=180    ! c2.0
        ny=90     ! c2.0

        do ix=1,nx
          do iy=1,ny
            grid(ix,iy)=0.
          enddo
        enddo

        ir=0
   55   read(1,'(a)',end=56) rname
        lrname=istlen(rname)
        ir=ir+1
        do iy=1,ny
          read(1,'(8x,72z1)') in
          if(hmask(ir:ir).eq.'1') then
            do ix=1,nx
              grid(ix,iy)=grid(ix,iy)+0.1*in(ix)
            enddo
          endif
        enddo
        goto 55
   56   continue

        dth=2.d0/radian   ! c2.0
        dph=2.d0/radian   ! c2.0

      endif

      do i=1,(lmax+1)**2
        ya(i)=0.d0
      enddo

      do iy=1,ny
        the1=(iy-1)*dth*radian   
        the2=the1+dth*radian
        call legint(the1,the2,lmax,a1,a2,dwk1,dwk2,1)
        ky=0
        ka=0
        do l=0,lmax
          do m=0,l
            ky=ky+1
            ka=ka+1

            if(m.eq.0) then
              fac=fmul*dph
              do ix=1,nx
                ya(ky)=ya(ky)+grid(ix,iy)*a2(ka)*fac
              enddo
            else
              cmp1=fmul*2.d0/m
              smp1=0.d0
              cd=dcos(m*dph)
              sd=dsin(m*dph)
              do ix=1,nx
                cmp2=cmp1*cd-smp1*sd
                smp2=cmp1*sd+smp1*cd
                ya(ky)=ya(ky)
     1           +grid(ix,iy)*a2(ka)*(smp2-smp1)
                cmp1=cmp2
                smp1=smp2
              enddo
            endif

            if(m.ne.0) then
              ky=ky+1
              cmp1=fmul*2.d0/m
              smp1=0.d0
              cd=dcos(m*dph)
              sd=dsin(m*dph)
              do ix=1,nx
                cmp2=cmp1*cd-smp1*sd
                smp2=cmp1*sd+smp1*cd
                ya(ky)=ya(ky)
     1           -grid(ix,iy)*a2(ka)*(cmp2-cmp1)
                cmp1=cmp2
                smp1=smp2
              enddo
            endif
          enddo  ! over m
        enddo  ! over l
      enddo    ! over iy

      ya(1)=ya(1)-dsqrt(4.*pi)*sval
        lf177=istlen(f177)
        fsph177(1:lf177)=f177
        fsph177=trim(f177)//'.sph2'
        write(*,*)'fsph177 = ',fsph177
        lfsph177=istlen(fsph177)
        write(*,*)'legnth ',lfsph177
        open(17,file=fsph177(1:lfsph177),status='unknown',iostat=ierr)

      if(oform(1:loform).eq.'r') then
        lmax2=lmax
        write(17,'(i3)') lmax2  ! ATTENTION: ME 3smac
        write(17,'(5e16.8)') (ya(i),i=1,(lmax+1)**2)
      else if(oform(1:loform).eq.'p') then
         write(*,*)'oform p'
        i1=1
        do l=0,lmax
          write(17,'(1p11e12.4)') (ya(i),i=i1,i1+2*l)
          i1=i1+2*l+1
        enddo
      endif

       close(17)

      end