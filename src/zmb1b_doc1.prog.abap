*&---------------------------------------------------------------------*
*& Report  ZMB1B_DOC1
*& Changes are done on 7.7.2 by Jyotsna for plant merging.
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report ZMB1B_DOC1.
tables : mseg,
         mch1,
         makt,
         mara,
         jest,
         zmigo,
         lfa1,
         t001w,
         zmb1b_doc1,
         mkpf,
         qals.

data: maktx1     type makt-maktx,
      maktx2     type makt-maktx,
      normt      type mara-normt,
      mtart      type mara-mtart,
      maktx(100) type c,
      count1     type i.

data: it_mseg type table of mseg,
      wa_mseg type mseg,
      it_qals type table of qals,
      wa_qals type qals,
      it_mcha type table of mch1,
      wa_mcha type mch1.
data: sgtxt type lfa1-name1.
data: pqty          type mseg-menge,
      totcase       type i,
      looseqty      type mseg-menge,
      case(20)      type c,
      totcase1(5)   type c,
      looseqty1     type p,
      looseqty2(10) type c.
data: mumrez type marm-umrez.

data : ln type i.
data : ln1 type i.
data : nolines type i.
data: w_itext3(135) type c,
      r11(1200)     type c,
      r12(1200)     type c,
      licha(25)     type c.
data: rtdname1 like stxh-tdname.
data : begin of ritext1 occurs 0.
         include structure tline.
       data : end of ritext1.
types : begin of doc1,
          mblnr type mseg-mblnr,
        end of doc1.

types : begin of itab1,
          mblnr     type mseg-mblnr,
          licha(30) type c,
          sgtxt(40) type c,

        end of itab1.
data: it_doc1 type table of doc1,
      wa_doc1 type doc1,
      it_tab1 type table of zcha1,
      wa_tab1 type zcha1.
data: kunnr type t001w-ORT01.
data: mblnr1(10) type c,
      mjahr1(4)  type c,
      vbeln(10)  type c,
      fkdat      type sy-datum.
data: ftext1(300) type c,
      ftext2(300) type c,
      ttext1(300) type c,
      ttext2(300) type c.
data: qty1 type p.
***********************
data : v_fm type rs38l_fnam.
data: format(10) type c.
data : control  type ssfctrlop.
data : w_ssfcompop type ssfcompop.
***********************************************************
selection-screen begin of block merkmale1 with frame title text-001.
select-options : mblnr for mseg-mblnr.
parameters : year  like mseg-mjahr,
             werks like mseg-werks.
selection-screen end of block merkmale1 .
*****************************************************

select * from mseg into table it_mseg where mblnr in mblnr and mjahr eq year and xauto ne space and werks eq werks.
if it_mseg is initial.
  message 'NO DATA FOUND' type 'I'.
  exit.
endif.

loop at it_mseg into wa_mseg.
  wa_doc1-mblnr = wa_mseg-mblnr.
  collect wa_doc1 into it_doc1.
  clear wa_doc1.
endloop.
sort it_doc1 by mblnr.
delete adjacent duplicates from it_doc1 comparing mblnr.

call function 'SSF_FUNCTION_MODULE_NAME'
  exporting
*   formname           = 'ZTRF_CHALLAN'
*    formname           = 'ZTRF_CHALLAN_1'
 formname           = 'ZTRF_CHALLAN_2'
*   VARIANT            = ' '
*   DIRECT_CALL        = ' '
  importing
    fm_name            = v_fm
  exceptions
    no_form            = 1
    no_function_module = 2
    others             = 3.

control-no_open   = 'X'.
control-no_close  = 'X'.


call function 'SSF_OPEN'
  exporting
    control_parameters = control.

loop at it_doc1 into wa_doc1.
  clear : mblnr1.
  mblnr1 = wa_doc1-mblnr.
  mjahr1 = year.


  select single * from t001w where werks eq werks.
  if sy-subrc eq 0.
    kunnr = t001w-ORT01.
  endif.

  select single * from zmb1b_doc1 where mblnr eq wa_doc1-mblnr and mjahr eq year.
  if sy-subrc eq 0.
    vbeln = zmb1b_doc1-vbeln.
    select single * from mkpf where mblnr eq zmb1b_doc1-mblnr and mjahr eq zmb1b_doc1-mjahr.
    if sy-subrc eq 0.
      fkdat = mkpf-budat.
    endif.
  endif.

  select single * from mseg where mblnr eq wa_doc1-mblnr and mjahr eq year and xauto ne space and werks eq werks.
  if sy-subrc eq 0.
*    if werks eq '1001'.
    if werks eq '2024'.
      ftext1 = 'BLUE CROSS LABORATORIES PVT LTD.'.
      ftext2 = 'Mfg. Lic. No.: 271 dated 20.10.95, 395 DATED 13.08.98'.
*    elseif werks eq '2024'.
    elseif werks eq '1001'.
*      ftext1 = 'BLUE CROSS LABORATORIES PVT LTD., (WHOLESALE PREMISES)'.
      ftext1 = 'BLUE CROSS LABORATORIES PVT LTD.'.
*      ftext2 = ' Wholesale Licence No. 20B/GA-540-5638,  21B/GA-340-563 Dated 06.12.2016'.
      ftext2 = ' Wholesale Licence No. 20B/GA-SGO-5638,  21B/GA-SGO-5639 Dated 06.12.2016'. "changed on 6.6.25 as per Amit m- Jyotsna
    endif.
*    if mseg-umwrk eq '2024'.
    if mseg-umwrk eq '1001'.
*      ttext1 = 'BLUE CROSS LABORATORIES PVT LTD., (WHOLESALE PREMISES)'.
      ttext1 = 'BLUE CROSS LABORATORIES PVT LTD.'.
*      ttext2 = ' Wholesale Licence No. 20B/GA-540-5638,  21B/GA-340-563 Dated 06.12.2016'.
      ttext2 = ' Wholesale Licence No. 20B/GA-SGO-5638,  21B/GA-SGO-5639 Dated 06.12.2016'. "changed on 6.6.25 as per Amit m- Jyotsna
*    elseif mseg-umwrk eq '1001'.
    elseif mseg-umwrk eq '2024'.
      ttext1 = 'BLUE CROSS LABORATORIES PVT LTD.'.
      ttext2 = 'Mfg. Lic. No.: 271 dated 20.10.95, 395 DATED 13.08.98'.
    endif.
  endif.

  perform form1.



  call function v_fm
    exporting
      control_parameters = control
      user_settings      = 'X'
      output_options     = w_ssfcompop
      format             = format
      kunnr              = kunnr
      mblnr1             = mblnr1
      mjahr1             = mjahr1
      vbeln              = vbeln
      fkdat              = fkdat
      ftext1             = ftext1
      ftext2             = ftext2
      ttext1             = ttext1
      ttext2             = ttext2
    tables
      it_tab1            = it_tab1
    exceptions
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      others             = 5.

endloop.
call function 'SSF_CLOSE'.



*&---------------------------------------------------------------------*
*&      Form  VENBATCH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form venbatch .
**************************** VENDOR BATCH*********************************************************************************************************
  clear : licha.
  select single * from mch1 where matnr eq wa_mseg-matnr and charg eq wa_mseg-charg. "and werks eq wa_mseg-werks.    Commented by Jayesh
  if sy-subrc eq 0.
    licha = mch1-licha.
  endif.
  clear : rtdname1.
  concatenate wa_mseg-matnr wa_mseg-werks wa_mseg-charg into rtdname1.
*            RTDNAME1 = '00000000000010010010000000108421'.

  call function 'READ_TEXT'
    exporting
      client                  = sy-mandt
      id                      = 'VERM'
      language                = 'E'
      name                    = rtdname1
      object                  = 'CHARGE'
*     ARCHIVE_HANDLE          = 0
*            IMPORTING
*     HEADER                  = THEAD
    tables
      lines                   = ritext1
    exceptions
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      others                  = 8.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.
*    ************

  describe table ritext1 lines ln1.
  nolines = 0.
  clear : w_itext3,r11,r12.
  loop at ritext1."WHERE tdline NE ' '.
    condense ritext1-tdline.
    nolines =  nolines  + 1.
    if ritext1-tdline is not  initial   .
      if ritext1-tdline ne '.'.

        if nolines le  1.
*                  MOVE ITEXT-TDLINE TO T1.
          move ritext1-tdline to w_itext3.
          concatenate r11 w_itext3  into r11.
*                  SEPARATED BY SPACE.
        endif.

*              move ritext1-tdline to w_itext3.
*              concatenate r3 w_itext3  into r3 separated by space.
      endif.
    endif.
  endloop.
*            WRITE : LICHA,R11.



   DATA : BATCH_DETAILS    TYPE TABLE OF CLBATCH,
             WA_BATCH_DETAILS TYPE CLBATCH,
             Batchno          TYPE ATWTB.


      CALL FUNCTION 'VB_BATCH_GET_DETAIL'                                      "added by Jayesh 25.09.25
        EXPORTING
          MATNR              = WA_mseg-MATNR
          CHARG              = WA_mseg-CHARG
          WERKS              = WA_mseg-WERKS
          GET_CLASSIFICATION = 'X'
*         EXISTENCE_CHECK    =
*         READ_FROM_BUFFER   =
*         NO_CLASS_INIT      = ' '
*         LOCK_BATCH         = ' '
*       IMPORTING
*         YMCHA              =
*         CLASSNAME          =
*         BATCH_DEL_FLG      =
        TABLES
          CHAR_OF_BATCH      = BATCH_DETAILS
        EXCEPTIONS
          NO_MATERIAL        = 1
          NO_BATCH           = 2
          NO_PLANT           = 3
          MATERIAL_NOT_FOUND = 4
          PLANT_NOT_FOUND    = 5
          NO_AUTHORITY       = 6
          BATCH_NOT_EXIST    = 7
          LOCK_ON_BATCH      = 8
          OTHERS             = 9.
      IF SY-SUBRC <> 0.
* Implement suitable error handling here
      ENDIF.


      READ TABLE BATCH_DETAILS INTO WA_BATCH_DETAILS WITH KEY ATNAM = 'ZVENDOR_BATCH'.




  if licha+0(15) = r11+0(15).  "11.9.20  "long vendor batch
    licha = r11.
    licha = wa_batch_details-atwtb.             "Added field here
  endif.
  wa_tab1-licha = licha.
endform.
*&---------------------------------------------------------------------*
*&      Form  MFGR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form mfgr .
  clear : sgtxt.
  clear : it_qals,wa_qals,it_mcha,wa_mcha.
  select * from qals into table it_qals where charg eq wa_mseg-charg and lifnr ne space.
  select * from mch1 into table it_mcha where charg eq wa_mseg-charg and lifnr ne space.
  loop at it_qals into wa_qals .
    select single * from jest where objnr eq wa_qals-objnr and stat eq 'I0224'.
    if sy-subrc eq 0.
      delete it_qals where prueflos eq wa_qals-prueflos.
    endif.
  endloop.

  read table it_qals into wa_qals with key charg = wa_mseg-charg.
  if sy-subrc eq 0.
    select single * from zmigo where mblnr eq wa_qals-mblnr.
    if sy-subrc eq 0.
      select single * from lfa1 where lifnr eq zmigo-mfgr.
      if sy-subrc eq 0.
        sgtxt = lfa1-name1.  "25.4.20
      endif.
    endif.
  endif.
  if sgtxt eq space.
    select single * from zmigo where mblnr eq wa_mseg-mblnr.
    if sy-subrc eq 0.
      select single * from lfa1 where lifnr eq zmigo-mfgr.
      if sy-subrc eq 0.
        sgtxt = lfa1-name1.  "25.4.20
      endif.
    endif.
  endif.
  if sgtxt eq space.
    read table it_mcha into wa_mcha with key charg = wa_mseg-charg.
    if sy-subrc eq 0.
      select single * from mseg where bwart eq '101' and charg eq wa_mcha-charg and lifnr ne space.
      if sy-subrc eq 0.
        select single * from zmigo where mblnr eq mseg-mblnr.
        if sy-subrc eq 0.
          select single * from lfa1 where lifnr eq zmigo-mfgr.
          if sy-subrc eq 0.
            sgtxt = lfa1-name1.  "25.4.20
          endif.
        endif.
      endif.
    endif.
  endif.



  DATA : LT_EKPO TYPE EKPO,                                                                              "ADDED BY JAYESH
               LT_LFA1 TYPE LFA1.
        DATA :WA_LFA1_NAME1 TYPE LFA1-NAME1,
              LV_MFG        TYPE STRING.
        DATA : wa_T001W TYPE T001W-ORT01.


select single * from mseg where bwart eq '101' and charg eq wa_mcha-charg and lifnr ne space.
      if sy-subrc eq 0.

        SELECT * FROM EKPO INTO LT_EKPO WHERE EBELN = MSEG-EBELN AND EBELP = MSEG-EBELP .                "ADDED BY JAYESH
        ENDSELECT.
        IF LT_EKPO IS NOT INITIAL .
          SELECT SINGLE NAME1 FROM LFA1 INTO WA_LFA1_NAME1 WHERE LIFNR = LT_EKPO-MFRNR.
        ENDIF.
        ENDIF.


  wa_tab1-sgtxt = sgtxt.
  wa_tab1-sgtxt = WA_LFA1_NAME1.                             "Added by Jayesh

endform.
*&---------------------------------------------------------------------*
*&      Form  CASES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form cases .
  clear : pqty,totcase,looseqty,totcase1,looseqty1,looseqty2.
  select single umrez from marm into mumrez  where matnr = wa_mseg-matnr and meinh = 'SPR'.                     "changed here for MEINH value   => meinh = 'SPR'.
  pqty = wa_mseg-menge.
  if mumrez gt 0.
    totcase = pqty div mumrez.
    looseqty = pqty mod mumrez.
  endif.
  totcase1 = totcase.
  looseqty1 = looseqty.
  looseqty2 = looseqty1.
  condense : totcase1,looseqty2.
  if looseqty gt 0.
    concatenate totcase1  ' X (1*' looseqty2')' into case.
  else.
    case = totcase1.
  endif.
  condense case.

  wa_tab1-cases = case.
  if mtart eq 'ZFRT' or mtart eq 'ZESC' or mtart eq 'ZESM'                         or mtart eq 'ZROH'.            "Added by Jayesh
  else.
    wa_tab1-cases = space.
  endif.

endform.
*&---------------------------------------------------------------------*
*&      Form  FORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form form1 .
  clear : count1.
  count1 = 1.
  loop at it_mseg into wa_mseg where mblnr eq wa_doc1-mblnr.
    wa_tab1-cnt = count1.
    condense wa_tab1-cnt.
    wa_tab1-matnr = wa_mseg-matnr.
    wa_tab1-charg = wa_mseg-charg.
    select single * from mch1 where matnr eq wa_mseg-matnr and charg eq wa_mseg-charg.  " and werks eq wa_mseg-werks.             Commented by Jayesh
    if sy-subrc eq 0.
      wa_tab1-vfdat = mch1-vfdat.
    endif.
    clear: maktx,maktx1,maktx2,normt,mtart.
    select single * from makt where spras eq 'EN' and matnr eq wa_mseg-matnr.
    if sy-subrc eq 0.
      maktx1 = makt-maktx.
    endif.
    select single * from makt where spras eq 'Z1' and matnr eq wa_mseg-matnr.  "9.12.20
    if sy-subrc eq 0.
      maktx2 = makt-maktx.
    endif.
    select single * from mara where matnr eq wa_mseg-matnr.
    if sy-subrc eq 0.
      normt = mara-normt.
      mtart  = mara-mtart.
    endif.
    concatenate maktx1 maktx2 normt into maktx separated by space.
    condense : maktx.
    wa_tab1-maktx = maktx.
    if mtart eq 'ZFRT' or mtart eq 'ZESC' or mtart eq 'ZESM'.
      clear : qty1.
      qty1 = wa_mseg-erfmg.
      wa_tab1-menge = qty1.
    else.
      wa_tab1-menge = wa_mseg-erfmg.
    endif.
    condense wa_tab1-menge.
    wa_tab1-meins = wa_mseg-meins.
    wa_tab1-werks = wa_mseg-werks.
    wa_tab1-umwrk = wa_mseg-umwrk.

    perform venbatch.
    if mtart eq 'ZROH'.
      perform mfgr.
    elseif mtart eq 'ZFRT' or mtart eq 'ZESC' or mtart eq 'ZESM'.
      concatenate 'BLUE CROSS' kunnr into wa_tab1-sgtxt separated by space.
    endif.
    perform cases.
    select single * from qals where mblnr eq wa_mseg-mblnr and mjahr eq wa_mseg-mjahr AND MATNR EQ WA_MSEG-MATNR AND CHARG EQ WA_MSEG-CHARG
      AND LAGORTCHRG EQ WA_MSEG-LGORT.
    if sy-subrc eq 0.
      wa_tab1-prueflos = qals-prueflos.
    endif.

    collect wa_tab1 into it_tab1.
    clear wa_tab1.
    count1 = count1 + 1.
  endloop.
endform.
