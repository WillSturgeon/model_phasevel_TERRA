      parameter (MXLH=100)
      parameter (MXLENY=(MXLH+1)**2)
            
      parameter (MXSPHR=MXLENY)
      dimension atd(MXSPHR),buf(MXSPHR),ata(MXSPHR,MXSPHR),atax(MXSPHR),atay(MXSPHR),crcof(MXSPHR)
      double precision  evc1(MXSPHR,MXSPHR),evc(MXSPHR),eigv(MXSPHR),eigv1(MXSPHR),wevc(MXSPHR,MXSPHR)
     1    ,wk1(MXSPHR),x(MXSPHR), y(MXSPHR), det, det_log,wk2(MXSPHR),wk3(MXSPHR),covd0(MXLENY),w,f1
      character*80 getunx,filepmod,outfilee

      dimension wts(MXSPHR),d0(MXSPHR),d1(MXSPHR)

      real*4 :: etasng  
      double precision, dimension(MXSPHR) :: invDampedEigv
      double precision, dimension(MXSPHR, MXSPHR) :: R
      double precision, dimension(MXSPHR) :: x_out

      call chekcl('| :r:3:Input evc, input sph, output sph'
     1          //'|-c:o:1:Cutoff eigenvalue number (damping eigenvalue number)'
     1          //'|-e:o:1:damping parameter eta'
     1          //'|')

c --- load .evc file
      open(7,file=getunx(' ',1,ll),form='unformatted',status='old')
      read(7) lmaxh,lmaxa,lmaxhr,lmaxar
      write(*,*) lmaxh,lmaxa,lmaxhr,lmaxar

      lenyh=(lmaxh+1)**2
      numatd=lenyh

      lenyhr=(lmaxhr+1)**2
      numatdr=lenyhr

      read(7) (wts(i),i=1,numatdr)
      do i=1,numatdr
        read(7) eigv1(i),(evc1(k,i),k=1,numatdr)
cc        write(*,*)'numatdr ',numatdr
cc        write(*,*)'eigv1(i) ', eigv1(i)
cc        write(*,*)'evc1(k,i) ',(evc1(k,i),k=1,numatdr)
cc        write(*,*)i,k
cc        write(*,*)'eigv1(i) ', eigv1(i), 
      enddo
      close(7)

c ---- load TERRA .sph file
      open(10,file=getunx(' ',2,ll),status='old')
      read(10,*) lmax
      write(*,*) 'model lmax =',lmax
      np=(lmax+1)**2
      read(10,'(5e16.8)') (x(i),i=1,np)
c      write(*,*)  (x(i),i=1,np)
      close(10)

c--- load icut (eigenvalue cutoff value)
      icut=inunx('-c',1,ll)

c--- or load damping value e
      etasng = reunx('-e', 1, lf)
      write(*,*) 'Debug: etasng = ', etasng
            
      if(icut.eq.0.and.etasng.eq.0.) then
        write(6,*) 'no damping used'
        eta=0.
      endif

      if(icut.ne.0.and.etasng.ne.0.) stop 'specify only one of -c or -e'      
                
      if(icut.ne.0) then
       write(6,*) 'selecting damping using eigenvalue number'
       write(6,*) 'Eigenvalue ',icut,' = ',eigv1(icut)
        if(icut.ge.numatdr) then
         eta=0.
        else
         eta=eigv1(icut)
         etad=0.
         write(*,*)'--- 1 ',eta
        endif
      else
       eta=dble(etasng)
       write(6,*) 'damping using eta =',eta
       write(*,*)'--- 2 ',eta
      endif

      write(*,*) 'seems to be working up to here?'
c --- load .evc file
      open(8,file=getunx(' ',1,ll),form='unformatted',status='old')
      read(8) lmaxh,lmaxa,lmaxhr,lmaxar

      lenyh=(lmaxh+1)**2
      numatd=lenyh

      lenyhr=(lmaxhr+1)**2
      numatdr=lenyhr

      read(8) (wts(i),i=1,numatdr)
c - taken from Paula's mk3d_res.f
      do i=1,numatdr
c      do while(i.lt.numatdr)
c        i=i+1
        write(*,*) 'i ',i, numatdr, evc1(1,1), eigv1(1)
        read(8) eigv(i),(evc(k),k=1,numatdr)
        write(*,*) 'eigv(i) ', eigv(i), eta

c        if(i.eq.1) then
c         eta=eigv(1)*damp
c         write(6,*) eigv(1),eta
c        endif
        sum=0.
        do j=1,numatdr
c          sum=sum+twtsinv(j)*x(j)*evc(j)
           sum=sum+x(j)*evc(j)
        enddo
c       f1=1./(eigv(i)+eta)
        f1=eigv(i)/(eigv(i)+eta)
        w=sum*f1
        do j=1,numatdr
          x_out(j)=x_out(j)+w*evc(j)
        enddo
      enddo
      close(8)
100   continue

      open(20,file=getunx(' ',3,ll))
      write(20,*) lmax
      write(20,'(5e16.8)') (x_out(i),i=1,np)
      close(20)
                                  
      end

c-=----------------------------------------------------------------
      function sdot(n,a,inca,b,incb)
      dimension b(incb,*)
      double precision a(inca,*)
         sum=0.
         do i=1,n
            sum=sum+a(1,i)*b(1,i)
         enddo
         sdot=sum
         return
      end
                                                        
