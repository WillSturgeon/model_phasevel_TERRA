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

      ! only one buf‐alias, no stray scalar 'buf'!
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


c------------- build model, mineos format -------------- 
c---------------------- 0S (0:56) ----------------------
c---------------------- MC2 modes! ---------------------
      durand_modes=(/018,019,021,022,023,025,027,028,030,032,
     + 034,035,038,043,049,051,057,061,066,072,076,079,084,097,
     + 098,108,111,112,123,127,132,141,143,144,161,166,167,179,
     + 197,198,200,202,216,223,225,234,235,251,253,254,271,275,
     + 291,320,342,382,415 /)

c Open the 'TERRA_modellist.txt file and read model paths. currently there are 67 TERRA models
      open(unit=101, file='../TERRA_modellist_April2025.txt',
     1  status='old', action='read')
      do l = 1,numModels
        read(101,'(A)') modelLine(l)
      end do
      close(101)
c      write(*,*)'after modellist'
c Read the list of files from TERRA_filelist.txt

      open(unit=100,file='../TERRA_filelist.txt',
     1  status='old',action='read')
      numFiles = 0
      do i = 1,maxFiles
        read(100,'(A)') fileList(i)
        numFiles = numFiles + 1
      end do
      close(100)

c Loop over each model path read from the file
      do modelIdx = 1, numModels 
      part2 = trim(modelLine(modelIdx))
c      write(*,*) 'model = ', part2

c Find the position of the first '/' in the string
      firstSlashPos = INDEX(part2, '/')

c Find the position of the second '/' by searching after the first '/'
      secondSlashPos = INDEX(part2(firstSlashPos+1:), '/') + firstSlashPos

c Extract the substring after the second '/'
      newVar = part2(secondSlashPos+2:)

c Extract the substring between the two slashes (first part)
      firstpart = part2(firstSlashPos+1:secondSlashPos-0)
c      write(*,*)'========> ',newVar, ' --- ',firstpart

c Output the result to verify
c      write(*,*) 'After second slash: ', trim(newVar)
      
c Loop over each file in the list
      do j = 1,maxFiles
        inputFileName = trim(fileList(j))

      part1 = '/media/will/Monika1/convert'
      part3 = '/mineos_profiles_'
      part4 = trim(inputFileName)
      finalPath = trim(part1)// "/" // trim(firstpart) // trim(part3) //
     & trim(newVar) // "/" //trim(part4)

c      write(*,*) 'part1 ', trim(part1)
c      write(*,*) 'firstpart ', trim(firstpart)
c      write(*,*) 'part3 ', trim(part3)
c      write(*,*) 'newVar ', trim(newVar)
c      write(*,*) 'part4 ', trim(part4)



c      write(*,*)'---> ', finalPath

      model_file = trim(finalPath)
      write(*,*) j, model_file

c c-----  load reference model
c       write(*,*) "------------------------------------------"
c       write(*,*) 'model_file ',model_file,mm

c-----  load reference model (original count)
c       open(112,file=model_file,status="old",access="sequential")
c       read(112,'(a)') premstr
c       read(112,*) premifanis, premtref, premifdeck
c       read(112,*) premnm, premnic, premnoc
c       do i = 1, premnm
c         read(112,201) prrad(i), prrho(i), prvpv(i), prvsv(i),
c      1                 prqka(i), prqmu(i), prvph(i), prvsh(i), preta(i)
c       end do
c       close(112)
c   201  format(f8.0,3f9.2,2f9.1,2f9.2,f9.5)

c----- load reference model + insert zero‐depth layer at top
      open(112,file=model_file,status='old',access='sequential')
      read(112,'(a)')             premstr
      read(112,*)                 premifanis, premtref, premifdeck
      read(112,*)                 orig_nm, premnic, premnoc        ! original layer count
      new_premnm = orig_nm + 1                                      
c      now fill in layer 1 with your zero-depth numbers
      prrad(1) = 0.0
      prrho(1) = 13088.50
      prvpv(1) = 11262.20
      prvsv(1) = 3667.80
      prqka(1) = 1327.7
      prqmu(1) = 84.6
      prvph(1) = 11262.20
      prvsh(1) = 3667.80
      preta(1) = 1.00000
c     now read the orig_nm real rows into slots 2…new_premnm
      do i = 1, orig_nm
        read(112,*) prrad(i+1), prrho(i+1), prvpv(i+1), prvsv(i+1), 
     1                prqka(i+1), prqmu(i+1), prvph(i+1), prvsh(i+1), 
     2                preta(i+1)
      end do
      close(112)
      premnm = new_premnm   ! hand the new total back to the rest of the code

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
c      nmaxin=5
      nmaxin=0

c            ! — initialize the output‐directory string so we don’t pass garbage —
      outputs_dir = '/media/will/Monika1/convert'
c       model_file='/home/will/Documents/rapid_mineos/'
c      1 // 'models/prem_noocean.txt'
c       model_file='/media/will/MC2/TERRA_models_Franck/'
c      1 // 'convert/106_scale/mineos_profiles_106_scale'
c      1 // '----conv/-10.0_-10.0.txt'


c-----------------------------------------------------------------------
      call forward_model_mineos(
     1 phvel_all,grvel_all,lorder_all,attn_all,per_all,jcomin,epsin,
     1 wgravin,lminin,lmaxin,wminin,wmaxin,nminin,nmaxin,
     1 model_file,outputs_dir,premnm)

      write(*,*)'pppppp'

c      write(path1,'(A)') "/data/will/TERRA/muller_cmb_temp/"
c     1 "muller_3000/",
c     1 trim(model_file),
c     1 "_out.txt"
c     Find position of ".txt" in inputFileName
      pos = index(inputFileName, '.txt')

c     If ".txt" is found, construct path1 without ".txt"
      if (pos > 0) then
        path1 =  "/media/will/WS/" //trim(newVar) // "/" 
     1   // trim(inputFileName(:pos-1)) // '_0S_pred_CRUST1.txt'
        path1=trim(path1)
      else
        path1 =  "/media/will/WS/" //trim(newVar) // "/" 
     1          // trim(inputFileName) // '_0S_pred_CRUST1.txt'
        path1=trim(path1)
      end if

c c     If ".txt" is found, construct path2 without ".txt"
c       if (pos > 0) then
c         path2 =  "/media/will/WS/" //trim(newVar) // "/" 
c      1   // trim(inputFileName(:pos-1)) // '_1S_pred_CRUST1.txt'
c         path2=trim(path1)
c       else
c         path2 =  "/media/will/WS/" //trim(newVar) // "/" 
c      1          // trim(inputFileName) // '_1S_pred_CRUST1.txt'
c         path2=trim(path2)
c       end if

c c     If ".txt" is found, construct path2 without ".txt"
c       if (pos > 0) then
c         path3 =  "/media/will/WS/" //trim(newVar) // "/" 
c      1   // trim(inputFileName(:pos-1)) // '_2S_pred_CRUST1.txt'
c         path3=trim(path3)
c       else
c         path3 =  "/media/will/WS/" //trim(newVar) // "/" 
c      1          // trim(inputFileName) // '_2S_pred_CRUST1.txt'
c         path3=trim(path3)
c       end if

c c     If ".txt" is found, construct path2 without ".txt"
c       if (pos > 0) then
c         path4 =  "/media/will/WS/" //trim(newVar) // "/" 
c      1   // trim(inputFileName(:pos-1)) // '_3S_pred_CRUST1.txt'
c         path4=trim(path4)
c       else
c         path4 =  "/media/will/WS/" //trim(newVar) // "/" 
c      1          // trim(inputFileName) // '_3S_pred_CRUST1.txt'
c         path4=trim(path4)
c       end if

c c     If ".txt" is found, construct path2 without ".txt"
c       if (pos > 0) then
c         path5 =  "/media/will/WS/" //trim(newVar) // "/" 
c      1   // trim(inputFileName(:pos-1)) // '_4S_pred_CRUST1.txt'
c         path5=trim(path5)
c       else
c         path5 =  "/media/will/WS/" //trim(newVar) // "/" 
c      1          // trim(inputFileName) // '_4S_pred_CRUST1.txt'
c         path5=trim(path5)
c       end if

c c     If ".txt" is found, construct path2 without ".txt"
c       if (pos > 0) then
c         path6 =  "/media/will/WS/" //trim(newVar) // "/" 
c      1   // trim(inputFileName(:pos-1)) // '_5S_pred_CRUST1.txt'
c         path6=trim(path6)
c       else
c         path6 =  "/media/will/WS/" //trim(newVar) // "/" 
c      1          // trim(inputFileName) // '_5S_pred_CRUST1.txt'
c         path6=trim(path6)
c       end if

cc     If ".txt" is found, construct path2 without ".txt"
c      if (pos > 0) then
c        path7 = '/data/will/TERRA' // trim(part2)
c     1          // trim(inputFileName(:pos-1)) // '_6S_pred_CRUST1.txt'
c        path7=trim(path7)
c      else
c        path7 = '/data/will/TERRA' // trim(part2)
c     1          // trim(inputFileName) // '_6S_pred_CRUST1.txt'
c        path7=trim(path7)
c      end if

c      !--- figure out the directory portion of path1 (everything up to the last '/') ---
      slash_pos = 0
      do i = 1, len_trim(path1)
        if (path1(i:i) == '/') slash_pos = i
      end do
      path_dir = path1(:slash_pos-1)

c      !--- create it (and any missing parents) if it doesn’t already exist ---
      call execute_command_line('mkdir -p '//trim(path_dir))

c     fundamental modes
      open(1,file=path1,access='sequential',position='append')
      do i=2,449
            write(1,*)trim(inputFileName),i,tcom_all(i),
     1      cvel_all(i),gcom_all(i),qmod_all(i)
      enddo
      close(1)

c c     first overtone
c       open(2,file=path2,access='sequential',position='append')
c       do i=450,897
c             write(2,*)trim(inputFileName),i-448,tcom_all(i),
c      1      cvel_all(i),gcom_all(i),qmod_all(i)
c       enddo
c       close(2)

c c     second overtone
c       open(3,file=path3,access='sequential',position='append')
c       do i=898,1345
c             write(3,*)trim(inputFileName),i-896,tcom_all(i),
c      1      cvel_all(i),gcom_all(i),qmod_all(i)
c       enddo
c       close(3)

c c     third overtone
c       open(4,file=path4,access='sequential',position='append')
c       do i=1346,1793
c             write(4,*)trim(inputFileName),i-1344,tcom_all(i),
c      1      cvel_all(i),gcom_all(i),qmod_all(i)
c       enddo
c       close(4)

c c     fourth overtone
c       open(5,file=path5,access='sequential',position='append')
c       do i=1794,2241
c             write(5,*)trim(inputFileName),i-1792,tcom_all(i),
c      1      cvel_all(i),gcom_all(i),qmod_all(i)
c       enddo
c       close(5)

c c     fifth overtone
c       open(6,file=path6,access='sequential',position='append')
c       do i=2242,2689
c             write(6,*)trim(inputFileName),i-2240,tcom_all(i),
c      1      cvel_all(i),gcom_all(i),qmod_all(i)
c       enddo
c       close(6)

c     sixth overtone **** wk=3000 means we can't do this one....
c      open(7,file=path7,access='sequential',position='append')
c      do i=2690,3137
c            write(7,*)trim(inputFileName),i-2688,tcom_all(i),
c     1      cvel_all(i),gcom_all(i),qmod_all(i)
c      enddo
c      close(7)

      enddo
      enddo

      end program