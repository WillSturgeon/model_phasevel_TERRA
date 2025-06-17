      program main

      implicit real*8(a-h,o-z)

      integer*4 mk
      parameter (mk=650)
      integer*4 pk
      parameter (pk=450)
      integer*4 wk
      parameter (wk=3000)

      character*256  model_file,outputs_dir
      character*256  out_plain_file,out_bin_file
      character*256  dbase_name,eigenasc,kernelasc
      real*4      rad(mk)
      real*4      omega
      real*4      kkappa(mk),kmu(mk)
      real*8      alpha(mk),beta(mk)
      real*4      kalpha(mk),kbeta(mk)
      real*4      rhobar,bigg,tau
      real*4      fl
      real*4      phvel_all(pk),grvel_all(pk)
      real*4      attn_all(pk),per_all(pk)
      integer*4   lorder_all(pk)
      integer*4   jcomin,wgravin,lminin,lmaxin
      integer*4   wminin,wmaxin,nminin,nmaxin
      real*4      epsin

      real*4    per_eigen,phvel_eigen,grvel_eigen,attn_eigen
      integer*4 norder_eigen,lorder_eigen,eigid_eigen,
     +          nraw_eigen,ncol_eigen,npar_eigen,foff_eigen,
     +          commid_eigen
      character*2 datatype_eigen
      character*64 dir_eigen
      character*32 dfile_eigen
      character*17 lddate_eigen
      character*1 typeo_eigen
      character*35 path

c      ! only one buf‐alias, no stray scalar 'buf'!
      real*4 abuf
      common/c_eigen/norder_eigen,lorder_eigen,
     +      eigid_eigen,per_eigen,phvel_eigen,grvel_eigen,
     +      attn_eigen,nraw_eigen,ncol_eigen,npar_eigen,
     +      foff_eigen,commid_eigen,typeo_eigen,
     +      datatype_eigen,dir_eigen,dfile_eigen,lddate_eigen

      common r(mk),fmu(mk),flam(mk),qshear(mk),qkappa(mk),
     + xa2(mk),xlam(mk),rho(mk),qro(3,mk),g(mk),qg(3,mk),
     + fcon(mk),fspl(3,mk),lcon(mk),lspl(3,mk),ncon(mk),
     + nspl(3,mk),ccon(mk),cspl(3,mk),acon(mk),aspl(3,mk)
      common/bits/pi,rn,vn,wn,w,wsq,wray,qinv,cg,wgrav,tref,fct,eps,fl,
     +  fl1,fl2,fl3,sfl3,jcom,nord,l,kg,kount,knsw,ifanis,iback

      ! merged /eifx/ block:
      common/eifx/vpv(mk),vph(mk),vsv(mk),vsh(mk),eta(mk),wrk(mk*10),
     +      a(14,mk),dum(mk)

      common/c_buf/nn,ll,ww,qq,gc,buf(6*mk)
      common/will/cvel,wmhz,tcom,gcom,qmod,cvel_all(wk),wmhz_all(wk),
     +  tcom_all(wk),gcom_all(wk),qmod_all(wk)

      dimension abuf(6*mk+5)
      equivalence (nn,abuf)

      data bigg,tau/6.6723d-11,1.d3/,rhobar/5515.d0/
c-----------------------------------------------------------------------
c---- declarations for model inputs etc
      character*40    premstr
      integer         premifanis,premifdeck,premnm,premnoc
      real*4          premnic
      parameter       (maxmod=700)
      real*8          prrad(maxmod), prrho(maxmod)
      real*8          prvpv(maxmod), prvsv(maxmod)
      real*8          prqka(maxmod), prqmu(maxmod)
      real*8          prvph(maxmod), prvsh(maxmod)
      real*8          preta(maxmod)
      integer         i,mm,k
      real*4          moho, mineos_moho
      real*8          radius(300)
      integer, dimension(0:56) :: durand_modes
      character*256   modelin
      character(len=:), allocatable ::path1,path2,path3
      character(len=:), allocatable ::path4,path5,path6
      character(len=:), allocatable ::path7

c New variables for file processing
      character(len=256) :: inputFileName, outputFilePattern
      character(len=256) :: line
      integer :: fileUnit, inputFileUnit, ioStatus
      integer :: numFiles, fileIndex
      integer, parameter :: maxFiles = 15908
      character(len=256) :: fileList(maxFiles)
      character*256 :: part1, part2, part3, part4
      character*512 :: finalPath
      integer :: pos
      CHARACTER(LEN=256) :: newVar, firstpart
      integer :: firstSlashPos, secondSlashPos

      integer, parameter :: numModels = 67
      integer :: modelIdx, l
      character(len=256) :: modelLine(numModels)
      character(len=256), allocatable :: modelPaths(:)
      integer :: readStatus
      integer :: orig_nm, new_premnm
      character(len=256) :: path_dir
      integer :: slash_pos

c------------- build model, mineos format --------------

c      c New variables for command-line parsing
      character(len=256) :: model_arg, modelbase, modelprofile_dir
      character*256      model_parent     
      integer :: argstat, pos_slash
      character(len=512) :: outdir   
      logical :: lzero
      integer :: nic_int

c      !-----------------------------------------------------------------------
c      ! Read command-line arguments and construct model_file path
c      !-----------------------------------------------------------------------
      call get_command_argument(1, model_arg, status=argstat)
      if (argstat /= 0) then
         write(*,*) 'Error: missing first argument (model path)'
         stop 1
      end if

      call get_command_argument(2, inputFileName, status=argstat)
      if (argstat /= 0) then
         write(*,*) 'Error: missing second argument (coordinate file)'
         stop 1
      end if

c      ! Extract basename from model_arg (after last '/')
      pos_slash = 0
      do i = 1, len_trim(model_arg)
         if (model_arg(i:i) == '/') pos_slash = i
      end do
      if (pos_slash > 0) then
         modelbase = model_arg(pos_slash+1:len_trim(model_arg))
      else
         modelbase = trim(model_arg)
      end if

c----- Trim a trailing “----conv” or “--conv” (if present) -------------
      model_parent = model_arg
      if (len_trim(model_arg) >= 8 .and.
     +    model_arg(len_trim(model_arg)-7:len_trim(model_arg))
     +    == '----conv') then
         model_parent = model_arg(1:len_trim(model_arg)-8)
      else if (len_trim(model_arg) >= 6 .and.
     +         model_arg(len_trim(model_arg)-5:len_trim(model_arg))
     +         == '--conv') then
         model_parent = model_arg(1:len_trim(model_arg)-6)
      end if

c      ! Build the subdirectory name and final path
c      ! Build the subdirectory name and final path
      modelprofile_dir = trim(model_parent)//
     1  '/mineos_profiles_'//trim(modelbase)

      finalPath  = trim(modelprofile_dir)//'/'//trim(inputFileName)
      model_file = trim(finalPath)

c      write(*,*) j, model_file

c-----------------------------------------------------------------------
c--- LOAD PROFILE ------------------------------------------------------
c-----------------------------------------------------------------------
      open(112,file=model_file,status='old',access='sequential')

      read(112,'(A)') premstr
      read(112,*)     premifanis, premtref, premifdeck
      read(112,*)     premnm, premnic, premnoc           ! layer count

c----- read all existing layers ----------------------------------------
      do i = 1, premnm
         read(112,*) prrad(i), prrho(i), prvpv(i), prvsv(i),
     1               prqka(i), prqmu(i), prvph(i), prvsh(i), preta(i)
      end do
      close(112)

  201 format(f8.0,3f9.2,2f9.1,2f9.2,f9.5)

c c      !— print out the updated model to stdout for inspection —
c       write(*,*) '===== UPDATED MODEL: ', trim(model_file)
c c      ! first the title line
c       write(*,'(A)') trim(premstr)
c c      ! then the anisotropy line
c       write(*,*) premifanis, premtref, premifdeck
c c      ! then the new layer count + nic+noc
c       write(*,*) premnm, premnic, premnoc

c c      ! now each radius‐row (with the inserted zero‐depth at i=1)
c       do i = 1, premnm
c         write(*,201) prrad(i), prrho(i), prvpv(i), prvsv(i),
c      1           prqka(i), prqmu(i), prvph(i), prvsh(i), preta(i)
c       end do

c-----------------------------------------------------------------------
c------------------------- input parameters ----------------------------
c-----------------------------------------------------------------------

c ------- jcom - 1=radial, 2=toroidal, 3=spheroidal, 4=inner core toroidal
c ------- eps - 10−7 for periods > 10 s. 10−12 − 10−10 for periods between 5-10 s
c ------- wgrav - frequency in millihertz (mHz) above which gravitational terms are neglected; this gives about a factor of 3 increase in speed.

      jcomin=3
      epsin=1e-7
      wgravin=10
      lminin=2
      lmaxin=450
      wminin=0
      wmaxin=166.0
      nminin=0
      nmaxin=5

      outputs_dir = '/media/will/WS/TERRA_predictions'

c-----------------------------------------------------------------------
      call forward_model_mineos(
     1 phvel_all,grvel_all,lorder_all,attn_all,per_all,jcomin,epsin,
     1 wgravin,lminin,lmaxin,wminin,wmaxin,nminin,nmaxin,
     1 model_file,outputs_dir,premnm)

c      write(path1,'(A)') "/data/will/TERRA/muller_cmb_temp/"
c     1 "muller_3000/",
c     1 trim(model_file),
c     1 "_out.txt"
c     Find position of ".txt" in inputFileName

c  ! e.g. /media/…/TERRA_models/CMB2600----conv
      outdir = trim(outputs_dir)//'/'//trim(modelbase)  
c
      ! Ensure that directory (and parents) exist
      call execute_command_line('mkdir -p ' // trim(outdir))

c      ! Construct the filename
      pos = index(inputFileName, '.txt')

*-----------------------------------------------------------------------
*  Build full paths – one variable per overtone (0S … 5S)
*-----------------------------------------------------------------------
      if (pos > 0) then
         path1 = trim(outdir)//'/'//
     1            trim(inputFileName(:pos-1))//'_0S_pred_CRUST1.txt'
         path2 = trim(outdir)//'/'//
     1            trim(inputFileName(:pos-1))//'_1S_pred_CRUST1.txt'
         path3 = trim(outdir)//'/'//
     1            trim(inputFileName(:pos-1))//'_2S_pred_CRUST1.txt'
         path4 = trim(outdir)//'/'//
     1            trim(inputFileName(:pos-1))//'_3S_pred_CRUST1.txt'
         path5 = trim(outdir)//'/'//
     1            trim(inputFileName(:pos-1))//'_4S_pred_CRUST1.txt'
         path6 = trim(outdir)//'/'//
     1            trim(inputFileName(:pos-1))//'_5S_pred_CRUST1.txt'
      else
         path1 = trim(outdir)//'/'//
     1            trim(inputFileName)//'_0S_pred_CRUST1.txt'
         path2 = trim(outdir)//'/'//
     1            trim(inputFileName)//'_1S_pred_CRUST1.txt'
         path3 = trim(outdir)//'/'//
     1            trim(inputFileName)//'_2S_pred_CRUST1.txt'
         path4 = trim(outdir)//'/'//
     1            trim(inputFileName)//'_3S_pred_CRUST1.txt'
         path5 = trim(outdir)//'/'//
     1            trim(inputFileName)//'_4S_pred_CRUST1.txt'
         path6 = trim(outdir)//'/'//
     1            trim(inputFileName)//'_5S_pred_CRUST1.txt'
      end if

*-----------------------------------------------------------------------
*  Make sure destination directory exists (once is enough)
*-----------------------------------------------------------------------
      call execute_command_line('mkdir -p ' // trim(outdir))

*-----------------------------------------------------------------------
*  Fundamental mode 0S   (indices 2 … 449)
*-----------------------------------------------------------------------
      open(1, file=path1, access='sequential', position='append')
      do i = 2, 449
         write(1,*) trim(inputFileName), i,
     1              tcom_all(i), cvel_all(i), gcom_all(i), qmod_all(i)
      end do
      close(1)

*-----------------------------------------------------------------------
*  First overtone 1S  (indices 450 … 897)
*-----------------------------------------------------------------------
      open(2, file=path2, access='sequential', position='append')
      do i = 450, 897
         write(2,*) trim(inputFileName), i-448,
     1              tcom_all(i), cvel_all(i), gcom_all(i), qmod_all(i)
      end do
      close(2)

*-----------------------------------------------------------------------
*  Second overtone 2S  (indices 898 … 1345)
*-----------------------------------------------------------------------
      open(3, file=path3, access='sequential', position='append')
      do i = 898, 1345
         write(3,*) trim(inputFileName), i-896,
     1              tcom_all(i), cvel_all(i), gcom_all(i), qmod_all(i)
      end do
      close(3)

*-----------------------------------------------------------------------
*  Third overtone 3S  (indices 1346 … 1793)
*-----------------------------------------------------------------------
      open(4, file=path4, access='sequential', position='append')
      do i = 1346, 1793
         write(4,*) trim(inputFileName), i-1344,
     1              tcom_all(i), cvel_all(i), gcom_all(i), qmod_all(i)
      end do
      close(4)

*-----------------------------------------------------------------------
*  Fourth overtone 4S  (indices 1794 … 2241)
*-----------------------------------------------------------------------
c      open(5, file=path5, access='sequential', position='append')
c      do i = 1794, 2241
c         write(5,*) trim(inputFileName), i-1792,
c     1              tcom_all(i), cvel_all(i), gcom_all(i), qmod_all(i)
c      end do
c      close(5)

*-----------------------------------------------------------------------
*  Fifth overtone 5S  (indices 2242 … 2689)
*-----------------------------------------------------------------------
      open(6, file=path6, access='sequential', position='append')
      do i = 2242, 2689
         write(6,*) trim(inputFileName), i-2240,
     1              tcom_all(i), cvel_all(i), gcom_all(i), qmod_all(i)
      end do
      close(6)

      end program
