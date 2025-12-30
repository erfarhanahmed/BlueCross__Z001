*&---------------------------------------------------------------------*
*& Report  ZSAMP_DOCTOR_NEWUPD
**upload excel file as per format mentioned below - Dr.Sample data
*--------------------------------------------------------------------------------------------------------------------------------------------------------
** Terr.Code  SampleCode  DoctorUniqueCode  ActivityDate  sampleQty DoctorName  Emp.Id  ZONE  BATCH INVOICE INV DATE  Qualification Speciality  Place
*---------------------------------------------------------------------------------------------------------------------------------------------------------
**  TRI-5     832009      435399            25-04-2023    10        C.M.RADHAKRISHNAN 100 D-MAD ZYU2302 24178 20-03-2023  MD PAED   PED         THIRUPUR
**  TRI-5     832009      928028            07-04-2023    10        D Baskar    100     D-MAD   ZYU2302 24178 20-03-2023  PED       PED         KARANAMPETTAI
**  TRI-5     832009      434956            20-04-2023    10        FAZILULLAH  100     D-MAD   ZYU2302 24178 20-03-2023  MBBS DCH  PED         VELLALOOR/PERIYAKOIL
*--------------------------------------------------------------------------------------------------------------------------------------------------------------

*&---------------------------------------------------------------------*
*& Description - for uploading doctor's sample data from Excel and update rate from batch
*& TR - BCDK933654,BCDK933674
*& T-code - ZSAMPDOC_UPD
*&-------------------------------------------------------------------------------------------------*
*& Date - 12.10.2023
*& Description - Rate checklist and updatation from cust.table
*& TR - BCDK933684,BCDK933686
*& T-code - ZSAMPDOC_UPD
*&-------------------------------------------------------------------------------------------------*
*& Date - 13.10.2023
*& Description - delete zero rate data
*& TR - BCDK933694
*& T-code - ZSAMPDOC_UPD
*&--------------------------------------------------------------------------------------------------*
*& Date - 16.10.2023
*& Description - Rate for export batches is now revised as discussed with Sandeep/Jyotsna
*& TR - BCDK933708
*& T-code - ZSAMPDOC_UPD
*&---------------------------------------------------------------------------------------------------*
*& Date - 18.10.2023
*& Description - Add new options for - missing doctors list,delete nepal data,upload missing doctors
*& TR - BCDK933712
*& T-code - ZSAMPDOC_UPD
*&----------------------------------------------------------------------------------------------------*
*& Date - 14.12.2023
*& Description - Add new options for - delete records (ZSAMPDOC_UPDATE) as per sample given date at input.
*& TR - BCDK933936
*& T-code - ZSAMPDOC_UPD
*&----------------------------------------------------------------------------------------------------*

report zsampdoc_update_newupd_2.
tables: zsampdoc_update,
        mara,
        konp,mvke,tvm5t,zpack_size,zsamp_sale_samp,zsamp_sale_cost,zsamp_doctor.

data: it_zsampdoc_update type table of zsampdoc_update,
      wa_zsampdoc_update type zsampdoc_update.

types : begin of mat1,
          matnr type mara-matnr,
          charg type mchb-charg,
        end of mat1.

data: it_mat1 type table of mat1,
      wa_mat1 type mat1.

data: srate    type konp-kbetr,
      samprate type konp-kbetr,
      r1       type konp-kbetr,
      r2       type konp-kbetr,
      r3       type konp-kbetr.
data: charg type zsampinvp-charg.
data: ebeln    type ekpo-ebeln,
      fgmatnr  type mara-matnr,
      fgpack   type tvm5t-bezei,
      samppack type tvm5t-bezei,
      mrp      type konp-kbetr.
data: salepk type zpack_size-pack,
      samppk type zpack_size-pack.
data: vbeln type zsampinvp-vbeln,
      gjahr type zsampinvp-gjahr,
      fkdat type zsampinvp-fkdat.

data: fdate1 type sy-datum,
      fdate2 type sy-datum.
data: it_a602            type table of a602,
      wa_a602            type a602,
      it_ekbe            type table of ekbe,
      wa_ekbe            type ekbe,
      it_ekko            type table of ekko,
      wa_ekko            type ekko,
      it_ekpo            type table of ekpo,
      wa_ekpo            type ekpo,
      it_zsamp_sale_samp type table of zsamp_sale_samp,
      wa_zsamp_sale_samp type zsamp_sale_samp,
      it_a6021           type table of a602,
      wa_a6021           type a602.

data f_name type rlgrap-filename.
data it_type   type truxs_t_text_data.
types: begin of ty_data1,
         bzirk       type zdsmter-bzirk,
         matnr       type mara-matnr,
         docno       type pa0001-pernr,
         budat       type sy-datum,
         qty(10)     type c,
         docname     type pa0001-ename,
         pernr       type pa0001-pernr,
         zdsm        type zdsmter-zdsm,
         batch       type charg_d,
         vbeln       type vbeln,
         fkdat       type fkdat,
         docqualfctn type zdocqualfctn,
         docspeclty  type zdocspeclty,
         docplace    type zdocplace,
       end of ty_data1.
data: a type i.
data: count  type i,
      gv_msg type string.

data: it_file1 type table of ty_data1,
      wa_file1 type  ty_data1.

data : gt_fcat type slis_t_fieldcat_alv,
       gw_fcat like line of gt_fcat.


data:  zsampdoc_update_wa type  zsampdoc_update.
data : gt_zsamp_dr        type table of zsampdoc_update,
       gw_zsamp_dr        type zsampdoc_update,
       gt_zdoctor         type table of zsamp_doctor,
       gw_zdoctor         type zsamp_doctor,
       gt_missing_zdoctor type table of zsamp_doctor,
       gw_missing_zdoctor type zsamp_doctor.
data: mtart type mara-mtart,
      vkorg type mvke-vkorg,
      vtweg type mvke-vtweg.

selection-screen : begin of block b2 with frame title text-002.
parameters : p_rad1  radiobutton group rg1 user-command rb1 default 'X',        "Upload Doctor's Sample data
             p_rad6  radiobutton group rg1,                                 " Delete Nepal data from Dr.Master and Transaction tables
             p_rad5  radiobutton group rg1,                 "Display Doctor's checklist i.e.missing in Dr.master
             p_rad7  radiobutton group rg1,                 "Upload missing doctors if any
             p_rad2  radiobutton group rg1,                                   "Update Rate from Batch
             p_rad21 radiobutton group rg1,                         "Update Rate for Export Batches
             p_rad4  radiobutton group rg1,                 "Display Rate Checklist
             p_rad3  radiobutton group rg1.                 "Delete zero rate data

selection-screen uline.

parameters : p_rad8 radiobutton group rg1.    "delete data as per input
selection-screen end of block b2.

selection-screen : begin of block b1 with frame title text-001.
parameter p_file type rlgrap-filename.
parameters ctumode like ctu_params-dismode default 'N'.
selection-screen end of block b1.

selection-screen : begin of block b3 with frame title text-003.
select-options: matnr for mara-matnr,
                batch for zsampdoc_update-batch,
                budat for zsampdoc_update-budat.
selection-screen end of block b3.

at selection-screen output.

  if p_rad1 = 'X'.
    loop at screen.
      if screen-name cp '*P_FILE*' or screen-name cp '*CTUMODE*' .
        screen-active = 1.
        modify screen.
      endif.

      if screen-name cp '*MATNR*' or screen-name cp '*BUDAT*'  or screen-name cp '*BATCH*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
  elseif p_rad4 = 'X' or p_rad3 = 'X' or p_rad5 = 'X' or p_rad6 = 'X' or p_rad7 = 'X'.
    loop at screen.
      if screen-name cp '*P_FILE*' or screen-name cp '*CTUMODE*' .
        screen-active = 0.
        modify screen.
      endif.

      if screen-name cp '*MATNR*' or screen-name cp '*BUDAT*' or screen-name cp '*BATCH*' .
        screen-active = 0.
        modify screen.
      endif.
    endloop.
  elseif p_rad2 = 'X'.
    loop at screen.
      if screen-name cp '*P_FILE*' or screen-name cp '*CTUMODE*' .
        screen-active = 0.
        modify screen.
      endif.

      if screen-name cp '*MATNR*' or screen-name cp '*BUDAT*' or screen-name cp '*BATCH*' .
        screen-active = 1.
        modify screen.
      endif.

      if screen-name cp '*BATCH*' .
        screen-active = 0.
        modify screen.
      endif.
    endloop.
  elseif p_rad8 = 'X'.
    loop at screen.
      if screen-name cp '*P_FILE*' or screen-name cp '*CTUMODE*' .
        screen-active = 0.
        modify screen.
      endif.

      if screen-name cp '*BUDAT*'.
        screen-active = 1.
        modify screen.
      endif.

      if screen-name cp '*BATCH*' or screen-name cp '*MATNR*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
  else.
    loop at screen.
      if screen-name cp '*P_FILE*' or screen-name cp '*CTUMODE*' .
        screen-active = 0.
        modify screen.
      endif.

      if screen-name cp '*MATNR*' or screen-name cp '*BUDAT*' or screen-name cp '*BATCH*' .
        screen-active = 1.
        modify screen.
      endif.
    endloop.
  endif.

at selection-screen on value-request for p_file.

  call function 'F4_FILENAME'
    exporting
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = ' '
    importing
      file_name     = p_file.

start-of-selection.

  if p_rad1 = 'X'.      "Upload Doctor's Sample data
    perform upload_data_xls.
  elseif  p_rad2 = 'X' or p_rad21 eq 'X'.       "Update Rate from Batch OR "Update Rate for Export Batches
    perform update_rate_from_batch.
  elseif  p_rad3 = 'X'.               "Delete zero rate data
*****    perform update_rate_from_ztable.
    select * from zsampdoc_update into table it_zsampdoc_update where rate eq 0.
    describe table it_zsampdoc_update lines count.
    delete from zsampdoc_update where rate = 0.
    if sy-subrc = 0.
      clear gv_msg.
      gv_msg = count.
      concatenate gv_msg 'Records deleted' into gv_msg separated by space.
      message gv_msg type 'I'.
    endif.
  elseif p_rad5 = 'X'.     "Missing doctors list in Master
    perform get_missing_doctors.
    if gt_missing_zdoctor[] is not initial.
      sort gt_missing_zdoctor by docno zterr.
      delete adjacent duplicates from gt_missing_zdoctor[] comparing docno zterr.
      perform build_fcat_1.
      perform display_dr_list.
    endif.
  elseif p_rad6 = 'X'.        "delete Nepal data from master + transaction tables
    clear gv_msg.
    delete from zsamp_doctor where zm = 'D-KHAT'.
    if sy-subrc = 0.
      gv_msg = 'Doctors'.
    endif.
    delete from zsampdoc_update where zdsm = 'D-KHAT'.
    if sy-subrc = 0.
      concatenate gv_msg 'with transaction details in ZSAMPDOC_UPDATE are deleted.' into gv_msg separated by space.
      message gv_msg type 'I'.
    endif.
  elseif p_rad7 = 'X'.        "upload missing doctor - call upload prog.
    submit zdoctor_master_upload and return.
  elseif p_rad8 = 'X'.     "delete data as per date input
    if sy-uname = 'ITBOM03' or sy-uname = 'ITBOM01'.
      if budat is not initial.
        delete from zsampdoc_update where budat in budat.
        if sy-subrc = 0.
          gv_msg = 'Records deleted'.
          message gv_msg type 'I'.
        endif.
      else.
        gv_msg = 'Please enter date range for deletion'.
        message gv_msg type 'I'.
      endif.
    else.
      concatenate sy-uname: 'You are not authorised for this action.' into gv_msg.
      message gv_msg type 'E'.
    endif.

  else.
    perform get_zero_rate_dtls. "Display Rate Checklist
    if it_zsampdoc_update[] is not initial.
      perform build_fcat.
      perform display_list.
    endif.
  endif.


*&---------------------------------------------------------------------*
*&      Form  UPLOAD_DATA_XLS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form upload_data_xls .

  if p_file is  initial.
    message 'Pls select file for upload' type 'I'.
  endif.

  f_name = p_file.
  call function 'TEXT_CONVERT_XLS_TO_SAP'
    exporting
      i_field_seperator    = 'X'
      i_line_header        = 'X'
      i_tab_raw_data       = it_type
      i_filename           = p_file
    tables
      i_tab_converted_data = it_file1[].
  clear : a.
  clear : count.


  if it_file1 is not initial.
    loop at it_file1 into wa_file1.
      unpack wa_file1-matnr to wa_file1-matnr.
      select single * from zsampdoc_update where bzirk eq wa_file1-bzirk and matnr eq wa_file1-matnr and docno eq wa_file1-docno and budat eq wa_file1-budat.
      if sy-subrc eq 0.
        count = count + 1.
        write : / 'duplicate entry',wa_file1-bzirk, wa_file1-matnr, wa_file1-docno,wa_file1-budat,wa_file1-qty, wa_file1-docname, wa_file1-pernr,wa_file1-zdsm.
        delete it_file1 where bzirk eq wa_file1-bzirk and matnr eq wa_file1-matnr and docno eq wa_file1-docno and budat eq wa_file1-budat.
      else.
        a = 1.
        gw_zsamp_dr-mandt = sy-mandt.
        gw_zsamp_dr-bzirk = wa_file1-bzirk.
        gw_zsamp_dr-matnr = wa_file1-matnr.
        gw_zsamp_dr-docno = wa_file1-docno.
        gw_zsamp_dr-budat = wa_file1-budat.
        gw_zsamp_dr-qty = wa_file1-qty.
        gw_zsamp_dr-docname = wa_file1-docname.
        gw_zsamp_dr-pernr = wa_file1-pernr.
        gw_zsamp_dr-zdsm = wa_file1-zdsm.

        gw_zsamp_dr-batch = wa_file1-batch.
        gw_zsamp_dr-vbeln = wa_file1-vbeln.
        gw_zsamp_dr-fkdat = wa_file1-fkdat.

        gw_zsamp_dr-docqualfctn = wa_file1-docqualfctn.
        gw_zsamp_dr-docspeclty = wa_file1-docspeclty.
        gw_zsamp_dr-docplace = wa_file1-docplace.

        gw_zsamp_dr-cpudt = sy-datum.
        gw_zsamp_dr-uzeit = sy-uzeit.
        gw_zsamp_dr-uname = sy-uname.
        append gw_zsamp_dr to gt_zsamp_dr.
        clear gw_zsamp_dr.
      endif.
    endloop.
  endif.

  if gt_zsamp_dr[] is not initial.
    modify zsampdoc_update from table gt_zsamp_dr.
    if sy-subrc eq 0.
      if a eq 1.
        write : / 'DATA UPDATED'.
      endif.
    endif.
  endif.
  if count gt 1.
    write : / 'TOTAL DUPLICATE RECORDS' ,count.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  UPDATE_RATE_FROM_BATCH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form update_rate_from_batch .
  select * from zsampdoc_update into table it_zsampdoc_update where matnr in matnr and budat in budat and batch in batch."rate le 0.

  if it_zsampdoc_update is initial.
    message 'NO DATA FOUND' type 'E'.
  endif.

  loop at it_zsampdoc_update into wa_zsampdoc_update.
    wa_mat1-matnr = wa_zsampdoc_update-matnr.
    wa_mat1-charg = wa_zsampdoc_update-batch.
    collect wa_mat1 into it_mat1.
    clear wa_mat1 .
  endloop.

  sort it_mat1 by matnr charg.
  delete adjacent duplicates from it_mat1 comparing matnr charg.

****************rates**********************
  clear : fdate1,fdate2.
*  ************rate**********
  fdate2 = sy-datum - 720.
  fdate1 = sy-datum - 60.
  if it_mat1  is not initial.
    if p_rad21 eq 'X'.
      select * from a602 into table it_a602 for all entries in it_mat1 where kappl eq 'V' and kschl eq 'Z001' and charg eq it_mat1-charg and datbi ge sy-datum.
    else.
      select * from a602 into table it_a602 for all entries in it_mat1 where kappl eq 'V' and kschl eq 'Z001' and vkorg eq '1000'
    and charg eq it_mat1-charg and datbi ge sy-datum.
    endif.

    select * from ekbe into table it_ekbe for all entries in it_mat1 where bwart eq '101' and bewtp eq 'E' and budat ge fdate2 and
        budat le sy-datum and matnr eq it_mat1-matnr and charg eq it_mat1-charg.
    if sy-subrc eq 0.
      select * from ekko into table it_ekko for all entries in it_ekbe where ebeln eq it_ekbe-ebeln and bsart in ( 'ZL','ZNIV','ZS' ).
      if sy-subrc eq 0.
        select * from ekpo into table it_ekpo for all entries in it_ekko where ebeln = it_ekko-ebeln.
      endif.
    endif.

    select * from zsamp_sale_samp into table it_zsamp_sale_samp for all entries in it_mat1 where sampcode eq it_mat1-matnr.
    if sy-subrc eq 0.
      if p_rad21 eq 'X'.
        select * from a602 into table it_a6021 for all entries in it_zsamp_sale_samp where kappl eq 'V' and kschl = 'Z001' and  matnr = it_zsamp_sale_samp-matnr and datab ge fdate2  and datbi ge sy-datum.
      else.
        select * from a602 into table it_a6021 for all entries in it_zsamp_sale_samp where kappl eq 'V' and kschl = 'Z001' and vkorg eq '1000'
          and  matnr = it_zsamp_sale_samp-matnr and datab ge fdate2  and datbi ge sy-datum.
      endif.
    endif.
  endif.

  if p_rad21 eq 'X'.
    loop at it_a602 into wa_a602.
      select single * from mara where matnr eq wa_a602-matnr and mtart eq 'ZESC'.
      if sy-subrc eq 4.
        delete it_a602 where matnr = wa_a602-matnr.
      endif.
    endloop.

    loop at it_a6021 into wa_a6021.
      select single * from mara where matnr eq wa_a6021-matnr and mtart eq 'ZESC'.
      if sy-subrc eq 4.
        delete it_a6021 where matnr = wa_a6021-matnr.
      endif.
    endloop.

  else.
    loop at it_a602 into wa_a602.
      select single * from mara where matnr eq wa_a602-matnr and mtart eq 'ZFRT'.
      if sy-subrc eq 4.
        delete it_a602 where matnr = wa_a602-matnr.
      endif.
    endloop.

    loop at it_a6021 into wa_a6021.
      select single * from mara where matnr eq wa_a6021-matnr and mtart eq 'ZFRT'.
      if sy-subrc eq 4.
        delete it_a6021 where matnr = wa_a6021-matnr.
      endif.
    endloop.
  endif.

  loop at it_ekbe into wa_ekbe.
    read table it_ekko into wa_ekko with key ebeln = wa_ekbe-ebeln.
    if sy-subrc eq 4.
      delete it_ekbe where ebeln = wa_ekbe-ebeln.
    endif.
  endloop.

  sort it_a602 descending by datab.
  sort it_a602 descending by datab.
  sort it_ekbe descending by budat.
  sort it_ekbe descending by budat.
  sort it_a6021 descending by datab.

  if p_rad21 eq 'X'.
    mtart = 'ZESC'.
    vkorg = '2000'.
    vtweg = '20'.
  else.
    mtart = 'ZFRT'.
    vkorg = '1000'.
    vtweg = '10'.
  endif.

  loop at it_zsampdoc_update into wa_zsampdoc_update.
    write : / wa_zsampdoc_update-bzirk,wa_zsampdoc_update-matnr,wa_zsampdoc_update-batch,wa_zsampdoc_update-rate.
    clear : samprate,charg,ebeln,fgmatnr,fgpack,mrp,samppack,vbeln,fkdat,gjahr.
    clear : salepk,samppk.
    clear: samprate,srate,charg.


    read table it_a602 into wa_a602 with key kappl = 'V' kschl = 'Z001'  charg = wa_zsampdoc_update-batch.
    if sy-subrc eq 0.
      select single * from konp where knumh eq wa_a602-knumh.
      if sy-subrc eq 0.
        select single * from mara where matnr eq wa_a602-matnr and mtart eq mtart.
        if sy-subrc eq 0.

          srate = konp-kbetr.
          ebeln = space.

          charg = wa_zsampdoc_update-batch.
          fgmatnr = wa_a602-matnr.
          mrp = konp-kbetr.

          select single * from mvke where matnr eq wa_a602-matnr and vkorg eq vkorg and vtweg eq vtweg.
          if sy-subrc eq 0.
            select single * from tvm5t where spras eq 'EN' and mvgr5 eq mvke-mvgr5.
            if sy-subrc eq 0.
              fgpack = tvm5t-bezei.
            endif.

            select single * from zpack_size where mvgr5 eq mvke-mvgr5.
            if sy-subrc eq 0.
              salepk = zpack_size-pack.
            endif.
            select single * from zpack_size where mvgr5 eq mvke-mvgr5.
            if sy-subrc eq 4.
              write : / 'maintain data in ZPACK_SIZE for ',mvke-mvgr5.
            endif.
          endif.
          select single * from mvke where matnr eq wa_zsampdoc_update-matnr and vkorg eq '1000' and vtweg eq '80'.
          if sy-subrc eq 0.
            select single * from tvm5t where spras eq 'EN' and mvgr5 eq mvke-mvgr5.
            if sy-subrc eq 0.
              samppack = tvm5t-bezei.
            endif.
            select single * from zpack_size where mvgr5 eq mvke-mvgr5.
            if sy-subrc eq 0.
              samppk = zpack_size-pack.
            endif.
            select single * from zpack_size where mvgr5 eq mvke-mvgr5.
            if sy-subrc eq 4.
              write : / 'maintain data in ZPACK_SIZE for ',mvke-mvgr5.
            endif.
          endif.
        endif.
      endif.
    endif.
    if srate gt 0.

      if p_rad21 eq 'X'.  " export formula as discussed with Sandeep Sharma on 16.10.23
        clear : r1,r2,r3.
        r1 = 85 / 100.
        r2 = 80 / 100.
        r3 = srate * r1 * r2.
        samprate = ( ( r3 * samppk ) / salepk ).
      else.
        samprate = ( ( ( srate * 6429 ) / 10000 ) * samppk ) / salepk.
      endif.
    endif.

    if srate le 0.
      select single * from zsamp_sale_samp where sampcode eq wa_zsampdoc_update-matnr.
      if sy-subrc eq 0.
        read table it_a6021 into wa_a6021 with key kappl = 'V' kschl = 'Z001' vkorg = vkorg matnr = zsamp_sale_samp-matnr.
        if sy-subrc eq 0.
          select single * from konp where knumh eq wa_a6021-knumh.
          if sy-subrc eq 0.
            select single * from mara where matnr eq wa_a6021-matnr and mtart eq mtart.
            if sy-subrc eq 0.
              srate = konp-kbetr.
              ebeln = space.
              charg = wa_zsampdoc_update-batch.
              fgmatnr = wa_a6021-matnr.
              mrp = konp-kbetr.

              select single * from mvke where matnr eq wa_a6021-matnr and vkorg eq vkorg and vtweg eq vtweg.
              if sy-subrc eq 0.
                select single * from tvm5t where spras eq 'EN' and mvgr5 eq mvke-mvgr5.
                if sy-subrc eq 0.
                  fgpack = tvm5t-bezei.
                endif.
                select single * from zpack_size where mvgr5 eq mvke-mvgr5.
                if sy-subrc eq 0.
*                  WRITE : 'SALE PACK',ZPACK_SIZE-PACK,'SAMP PKG'.
                  salepk = zpack_size-pack.
                endif.
                select single * from zpack_size where mvgr5 eq mvke-mvgr5.
                if sy-subrc eq 4.
                  write : / 'maintain data in ZPACK_SIZE for ',mvke-mvgr5.
                endif.
              endif.
              select single * from mvke where matnr eq wa_zsampdoc_update-matnr and vkorg eq vkorg and vtweg eq vtweg.
              if sy-subrc eq 0.
                select single * from tvm5t where spras eq 'EN' and mvgr5 eq mvke-mvgr5.
                if sy-subrc eq 0.
                  samppack = tvm5t-bezei.
                endif.
                select single * from zpack_size where mvgr5 eq mvke-mvgr5.
                if sy-subrc eq 0.
                  samppk = zpack_size-pack.
                endif.
                select single * from zpack_size where mvgr5 eq mvke-mvgr5.
                if sy-subrc eq 4.
                  write : / 'maintain data in ZPACK_SIZE for ',mvke-mvgr5.
                endif.
              endif.
            endif.
          endif.
        endif.
      endif.
      if srate gt 0.
        samprate = ( ( ( srate * 6429 ) / 10000 ) * samppk ) / salepk.
      endif.
    endif.

    if srate le 0.
      loop at it_ekbe into wa_ekbe where matnr = wa_zsampdoc_update-matnr and charg = wa_zsampdoc_update-batch and budat le wa_zsampdoc_update-budat.
*        IF SY-SUBRC EQ 0.
        read table it_ekko into wa_ekko with key ebeln = wa_ekbe-ebeln.
        if sy-subrc eq 0.
          read table it_ekpo into wa_ekpo with key ebeln = wa_ekbe-ebeln ebelp = wa_ekbe-ebelp.
          if sy-subrc eq 0.
            samprate = wa_ekpo-netpr / wa_ekpo-peinh.
            ebeln = wa_ekbe-ebeln.
            charg = wa_ekbe-charg.
            fgpack = space.
            fgmatnr = space.
            mrp = 0.
            select single * from mvke where matnr eq wa_zsampdoc_update-matnr and vkorg eq '1000' and vtweg eq '80'.
            if sy-subrc eq 0.
              select single * from tvm5t where spras eq 'EN' and mvgr5 eq mvke-mvgr5.
              if sy-subrc eq 0.
                samppack = tvm5t-bezei.
              endif.
            endif.
          endif.
        endif.
        exit.
      endloop.
    endif.
    wa_zsampdoc_update-rate = samprate.
    modify it_zsampdoc_update from wa_zsampdoc_update transporting rate.
    clear wa_zsampdoc_update.
    write : 'rate',samprate.
  endloop.

****    update rate
  if it_zsampdoc_update[] is not initial.
    modify zsampdoc_update from table it_zsampdoc_update[].
    if sy-subrc = 0.
      message 'Rate updated sucessfully' type 'S'.
    endif.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  UPDATE_RATE_FROM_ZTABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form update_rate_from_ztable .
  select * from zsampdoc_update into table it_zsampdoc_update where budat in budat and matnr in matnr and rate eq 0.
  if sy-subrc eq 4.
    message 'NO DATA FOUND' type 'E'.
  endif.

  loop at it_zsampdoc_update into wa_zsampdoc_update .
    select single * from zsamp_sale_cost where sampcode eq wa_zsampdoc_update-matnr and datab le wa_zsampdoc_update-budat and datbi ge
      wa_zsampdoc_update-budat.
    if sy-subrc eq 0.
      move-corresponding wa_zsampdoc_update to zsampdoc_update_wa.
      zsampdoc_update_wa-rate = zsamp_sale_cost-kbetr.
      modify zsampdoc_update from zsampdoc_update_wa.
      clear zsampdoc_update_wa.
    endif.
  endloop.

  if sy-subrc eq 0.
    message 'RATE IS UPDATED' type 'I'.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  GET_ZERO_RATE_DTLS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form get_zero_rate_dtls .
  select * from zsampdoc_update into table it_zsampdoc_update where rate eq 0.
  if sy-subrc <> 0.
    message 'NO DATA FOUND' type 'E'.
  else.
    sort it_zsampdoc_update by matnr batch.
    delete adjacent duplicates from it_zsampdoc_update comparing matnr batch.
  endif.

endform.
*&---------------------------------------------------------------------*
*&      Form  BUILD_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form build_fcat .
  data lv_pos type i.

  clear gt_fcat[].

  lv_pos = 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'MATNR'.
  gw_fcat-seltext_l = 'SAMPLE CODE'.
  gw_fcat-outputlen = '10'.
  gw_fcat-no_zero = 'X'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'BATCH'.
  gw_fcat-seltext_l = 'BATCH'.
  gw_fcat-outputlen = '10'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'RATE'.
  gw_fcat-seltext_l = 'RATE'.
  gw_fcat-col_pos = lv_pos.

  append gw_fcat to gt_fcat.
endform.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_LIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form display_list .
  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
      i_callback_program = sy-repid
*****      i_callback_user_command = 'USER_COMMAND'
*****      i_callback_top_of_page  = 'TOP_OF_PAGE'
      i_grid_title       = 'Rate Checklist'
*****      is_layout               = gw_layout
      it_fieldcat        = gt_fcat
*****      it_sort                 = gt_sort
*     I_DEFAULT          = 'X'
      i_save             = 'A'
    tables
      t_outtab           = it_zsampdoc_update[]
    exceptions
      program_error      = 1
      others             = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  UPDATE_RATE_FROM_BATCH1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form update_rate_from_batch1 .

endform.
*&---------------------------------------------------------------------*
*&      Form  GET_MISSING_DOCTORS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form get_missing_doctors .

  types : begin of ty_zsampdoc_update,
            docno type persno,
          end of ty_zsampdoc_update.

  data: lt_zsampdoc_update type table of ty_zsampdoc_update,
        lw_zsampdoc_update type ty_zsampdoc_update,
        lt_zdsmter         type table of zdsmter,
        lw_zdsmter         type zdsmter,
        lt_zsampdoc_bzirk  type table of zsampdoc_update,
        lw_zsampdoc_bzirk  type zsampdoc_update.

  clear it_zsampdoc_update[].
  clear gt_zdoctor[].
  select * from zsamp_doctor into table gt_zdoctor.
  if sy-subrc = 0.
    sort gt_zdoctor by docno.
    clear lt_zsampdoc_update[].
    select distinct ( docno ) from zsampdoc_update into table lt_zsampdoc_update.
    if sy-subrc = 0.
      sort lt_zsampdoc_update by docno.
      loop at gt_zdoctor into gw_zdoctor.
        delete lt_zsampdoc_update where docno = gw_zdoctor-docno.
      endloop.
      if lt_zsampdoc_update[] is not initial.
        sort lt_zsampdoc_update by docno.
        clear it_zsampdoc_update[].
        select * from zsampdoc_update into table it_zsampdoc_update
          for all entries in lt_zsampdoc_update
          where docno = lt_zsampdoc_update-docno.
        if sy-subrc = 0.
*****   get unique territories
          clear lt_zsampdoc_bzirk[].
          lt_zsampdoc_bzirk[] = it_zsampdoc_update[].
          sort lt_zsampdoc_bzirk by bzirk.
          delete adjacent duplicates from lt_zsampdoc_bzirk comparing bzirk.
***** get regions/RM details against Terr.BZIRK
          clear lt_zdsmter[].
          select * from zdsmter into table lt_zdsmter
            for all entries in lt_zsampdoc_bzirk
            where zyear = lt_zsampdoc_bzirk-budat+0(4)
            and bzirk = lt_zsampdoc_bzirk-bzirk.
**** get details in doctor master table format for further uploading.
          clear gt_missing_zdoctor[].
          loop at it_zsampdoc_update into wa_zsampdoc_update.
            gw_missing_zdoctor-docno = wa_zsampdoc_update-docno.
            gw_missing_zdoctor-zterr = wa_zsampdoc_update-bzirk.
            gw_missing_zdoctor-zm = wa_zsampdoc_update-zdsm.
            gw_missing_zdoctor-docname = wa_zsampdoc_update-docname.
            gw_missing_zdoctor-docqualfctn = wa_zsampdoc_update-docqualfctn.
            gw_missing_zdoctor-docspeclty = wa_zsampdoc_update-docspeclty.
            gw_missing_zdoctor-docspeclty = wa_zsampdoc_update-docspeclty.
            gw_missing_zdoctor-docplace = wa_zsampdoc_update-docplace.

            clear lw_zdsmter.
            read table lt_zdsmter into lw_zdsmter with key bzirk = wa_zsampdoc_update-bzirk.
            if sy-subrc = 0.
              gw_missing_zdoctor-rm = lw_zdsmter-zdsm.
            endif.
            collect gw_missing_zdoctor into gt_missing_zdoctor.
*****            APPEND gw_missing_zdoctor TO gt_missing_zdoctor.
            clear gw_missing_zdoctor.
          endloop.
        endif.
*****        loop at lt_zsampdoc_update into lw_zsampdoc_update.
*****          wa_zsampdoc_update-docno = lw_zsampdoc_update-docno.
*****          append wa_zsampdoc_update to it_zsampdoc_update.
*****          clear wa_zsampdoc_update.
*****        endloop.
      endif.
    endif.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  BUILD_FCAT_1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form build_fcat_1 .
  data lv_pos type i.

  clear gt_fcat[].

  lv_pos = 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'DOCNO'.
  gw_fcat-seltext_l = 'DOCNO'.
  gw_fcat-outputlen = '10'.
  gw_fcat-no_zero = 'X'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'DOCNAME'.
  gw_fcat-seltext_l = 'DOCNAME'.
  gw_fcat-outputlen = '10'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'ZTERR'.
  gw_fcat-seltext_l = 'TERR.'.
  gw_fcat-outputlen = '10'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'RM'.
  gw_fcat-seltext_l = 'REGION'.
  gw_fcat-outputlen = '10'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'ZM'.
  gw_fcat-seltext_l = 'ZONE'.
  gw_fcat-outputlen = '10'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'DOCQUALFCTN'.
  gw_fcat-seltext_l = 'DOCQUALFCTN'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'DOCSPECLTY'.
  gw_fcat-seltext_l = 'DOCSPECLTY'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'DOCPLACE'.
  gw_fcat-seltext_l = 'DOCPLACE'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.
endform.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_DR_LIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form display_dr_list .
  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
      i_callback_program = sy-repid
      i_grid_title       = 'Missing Doctors List - To be uploaded in table ZSAMP_DOCTOR'
      it_fieldcat        = gt_fcat
      i_save             = 'A'
    tables
      t_outtab           = gt_missing_zdoctor[]
    exceptions
      program_error      = 1
      others             = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.
endform.
