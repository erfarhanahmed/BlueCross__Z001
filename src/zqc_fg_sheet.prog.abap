*&---------------------------------------------------------------------*
*& Report ZQC_FG_SHEET
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zqc_fg_sheet.

*
**&---------------------------------------------------------------------*
**& Report  ZBMR_DATE
**&DEVELOPED BY JYOTSNA
**&---------------------------------------------------------------------*
**&we have converted script to smartform on 19.8.24
**&changes for fg long material description on 8.10.24 by Jyotsna
**retest ads added on 5.12.24 r21 - Jyotsna
***manufacturere & supplier logic is added on 24.12.24 for rm - Jyotsna
****DESIGNEE IN QA IS ALLOWED FOR REPRINT.
****allowed qa for master print & to upload copy on 9.7.25- Jyotsna
**&---------------------------------------------------------------------*
*report zbmr_date_11_7.
***pack size is mapped as per COA from specification on 5.3.23
TABLES : mcha,
         mch1,
         makt,
         a602,
         konp,
         mkpf,
         mseg,
         zqc_fg_sheet,
         mvke,
         tvm5t,
         t001w,
         mara,
         qinf,
         zpassw,
         aufk,
         pa0002,
         itcpo,
         qmat,
         afpo,
         zqc_fg_sheet_r,
         qals,
         zmigo,
         lfa1,
         ekpo,
         ekko,
         zpo_matnr,
         pa0001,
         qave,
         zqc_fg_sheet_q,
         zqms_depthead1,
         zqms_depthead2,
         zqc_fg_sheet_q1,
         qamr,
         zcoadata,
         jest.

DATA:
*      v_ac_xstring type xstring,
  v_en_string TYPE string,
*      v_en_xstring type xstring,
  v_de_string TYPE string,
*      v_de_xstring type string,
  v_error_msg TYPE string.
DATA: o_encryptor        TYPE REF TO cl_hard_wired_encryptor,
      o_cx_encrypt_error TYPE REF TO cx_encrypt_error.

DATA : it_qals             TYPE TABLE OF qals,
       wa_qals             TYPE qals,
       it_qals1            TYPE TABLE OF qals,
       wa_qals1            TYPE qals,
       it_afpo             TYPE TABLE OF afpo,
       wa_afpo             TYPE afpo,
       it_qamv             TYPE TABLE OF qamv,
       wa_qamv             TYPE qamv,
       it_zqspecification  TYPE TABLE OF zqspecification,
       wa_zqspecification  TYPE zqspecification,
       it_zqspecificationc TYPE TABLE OF zqspecificationc,
       wa_zqspecificationc TYPE zqspecificationc,
       it_zfginsp          TYPE TABLE OF zfginsp,
       wa_zfginsp          TYPE zfginsp,
       it_zfginspc         TYPE TABLE OF zfginspc,
       wa_zfginspc         TYPE zfginspc,
       it_zfginspr         TYPE TABLE OF zfginspr,
       wa_zfginspr         TYPE zfginspr.

DATA : charg       TYPE mcha-charg,
       hsdat       TYPE mcha-hsdat,
       vfdat       TYPE mcha-vfdat,
       lwedt       TYPE mch1-lwedt,
       werks       TYPE mcha-werks,
       matnr       TYPE mcha-matnr,
       mblnr       TYPE qals-mblnr,
*       MENGE       TYPE MSEG-MENGE,
       menge(14)   TYPE c,
       mtart       TYPE mara-mtart,
       tp1(2)      TYPE c,
       format(20)  TYPE c,
       enstehdat   TYPE qals-enstehdat,
       formnm(15)  TYPE c,
       maktx1      TYPE makt-maktx,
       maktx2      TYPE makt-maktx,
       normt       TYPE mara-normt,
*       MAKTX       TYPE MAKT-MAKTX,
       maktx(100)  TYPE c,
       mjahr       TYPE mkpf-mjahr,
       mfgr        TYPE lfa1-name1,
       sname1      TYPE lfa1-name1,
       mjahr1      TYPE mkpf-mjahr,
       sampqty     TYPE mseg-menge,
       sqtyuom     TYPE mseg-meins,
       a           TYPE i,
       a1          TYPE i,
       pack        TYPE tvm5t-bezei,
       packtxt(19) TYPE c,
       kunnr       TYPE t001w-kunnr,
       text1(70)   TYPE c,
       hsdat1(7)   TYPE c,
       vfdat1(7)   TYPE c,
       aufnr       TYPE qals-aufnr,
       cpudt       TYPE sy-datum,
       name1       TYPE name1,
       mfgname     TYPE name1,
       licha(30)   TYPE c,
       grndate     TYPE sy-datum,
       vdatum      TYPE sy-datum,
       sampo       TYPE zcoadata-sampon,
       sampb       TYPE zcoadata-sampby,
       qtysamp     TYPE zcoadata-sampqty.

DATA: rtdname1 LIKE stxh-tdname.
DATA : BEGIN OF ritext1 OCCURS 0.
         INCLUDE STRUCTURE tline.
DATA : END OF ritext1.
DATA : ln1 TYPE i.
DATA : nolines TYPE i.
DATA: w_itext3(135) TYPE c,
      r11(1200)     TYPE c,
      r12(1200)     TYPE c.
*       mblnr TYPE mblnr,
*       menge TYPE mseg-menge,
*       meinh TYPE mseg-meinh.


DATA: ads(18)  TYPE c,
      adsmatnr TYPE mara-matnr.
DATA : v_fm TYPE rs38l_fnam.
DATA : control  TYPE ssfctrlop.
DATA: control_parameters TYPE ssfctrlop.
DATA : w_ssfcompop TYPE ssfcompop.

TYPES: BEGIN OF check,
         frm(1) TYPE c,
       END OF check.

DATA: it_check TYPE TABLE OF check,
      wa_check TYPE check.
DATA : w_return    TYPE ssfcrescl.
***************************************
DATA : psmng TYPE afpo-psmng.
DATA : manhsdat TYPE sy-datum.
*      mjahr2(4) TYPE c.
DATA : iprkz    TYPE mara-iprkz,
       mhdhb    TYPE  mara-mhdhb,
       mhdhb1   TYPE  mara-mhdhb,
       w_vfdat  TYPE mcha-vfdat,
       w_vfdat1 TYPE mcha-vfdat.

DATA : meins TYPE afpo-meins,
       lichn TYPE qals-lichn.

***********************************

DATA: it_afru1 TYPE TABLE OF afru,
      wa_afru1 TYPE afru,
      it_aufk1 TYPE TABLE OF aufk,
      wa_aufk1 TYPE aufk,
      it_aufm1 TYPE TABLE OF aufm,
      wa_aufm1 TYPE aufm.


DATA: specf     TYPE zqspecification-specification,
      shelflife TYPE zqspecification-shelflife.
DATA: ver(2) TYPE c,  " version


      effdt  TYPE sy-datum.
DATA: format1(30) TYPE c.
DATA: vern1 TYPE zqc_fg_sheet-version.

DATA : test TYPE qamv-verwmerkm.

DATA  num(70).
DATA: matnr1(18) TYPE c.
DATA: s1 TYPE i.
DATA : mmline1 LIKE tline OCCURS 0 WITH HEADER LINE.
DATA : mmline2 LIKE tline OCCURS 0 WITH HEADER LINE.
DATA : w_itexta(1200) TYPE c.
DATA : w_itext2(1200) TYPE c.
DATA: w_itexta1(100) TYPE c,
      w_itexta2(100) TYPE c.
DATA :  options        TYPE itcpo.
*DATA: R11(1200)     TYPE C.
DATA: ntxt2(100) TYPE c.
DATA: text2(1500) TYPE c,
*      text3(73) TYPE c,
*      text4(72) TYPE c,
      pg(9)       TYPE c,
*      pg1(4)      type c,
      b           TYPE i,
      bl1         TYPE i,
      u           TYPE i,
      c(1)        TYPE c,
      d(1)        TYPE c,
      bld1(1)     TYPE c,
      bld2(1)     TYPE c,
      e1(1)       TYPE c,
      e2(1)       TYPE c.
DATA: ctxt1(100) TYPE c.
DATA ntxt1(200) TYPE c.
DATA: ntxt3(1) TYPE c.
DATA: ntxt5(1) TYPE c.
DATA: cnt TYPE i VALUE  1.
DATA: b1(2) TYPE c.
DATA: pernr1 TYPE pa0001-pernr,
      pernr2 TYPE pa0001-pernr,
      pernr3 TYPE pa0001-pernr.
TYPES : BEGIN OF txt1,
          txt1(100) TYPE c,
        END OF txt1.
DATA: it_txt1 TYPE TABLE OF zfgads1,
      wa_txt1 TYPE zfgads1.

DATA : uname   TYPE zqc_fg_sheet-name,
       usname  TYPE zqc_fg_sheet-name,
       usname1 TYPE zqc_fg_sheet-name,
       udate   TYPE zqc_fg_sheet-printdt,
       uzeit   TYPE zqc_fg_sheet-cputm.

DATA : batchsz      TYPE stpo-menge,
       batchsz1     TYPE p,
       batchsz2(10) TYPE c,
       batchsz3(15) TYPE c,
       batchuom     TYPE stpo-meins,
       mrp          TYPE konp-kbetr,
       batchsz4(15) TYPE c.
DATA : zqc_fg_sheet_wa TYPE zqc_fg_sheet.
DATA: i1(1) TYPE c.
DATA: vendor(7) TYPE c.
DATA: a2(34) TYPE c,                                                    "Changed by Vinayak S.
      a3(9)  TYPE c,
      a4(11) TYPE c,
      a5(22) TYPE c.                                                    "Added by Vinayak S.

DATA: insp1(12) TYPE c,
      name(50)  TYPE c.
DATA: aplant LIKE qals-werk.  "AUTHORIZATION CHECK
DATA : msg TYPE string.
DATA: btrtl TYPE pa0001-btrtl.
DATA: puname(40) TYPE c.
DATA: type1(1) TYPE c.
DATA: docdesc(50) TYPE c.
DATA: matnr2 TYPE mara-matnr.
DATA: q1(1) TYPE c.
DATA: pruefdatub TYPE qamr-pruefdatub.
DATA: pruefdatuv TYPE qamr-pruefdatuv.

SELECTION-SCREEN BEGIN OF BLOCK merkmale2 WITH FRAME TITLE TEXT-001.
  PARAMETERS : preview AS CHECKBOX DEFAULT 'X' .
*parameters : pernr    like pa0001-pernr matchcode object prem,           "Commented by Vinayak S.
*             pass(10) type c.
*PARAMETERS:   reprint AS CHECKBOX.
  PARAMETERS : print   RADIOBUTTON GROUP c1,
               reprint RADIOBUTTON GROUP c1,
               upload  RADIOBUTTON GROUP c1.

SELECTION-SCREEN END OF BLOCK merkmale2.

SELECTION-SCREEN BEGIN OF BLOCK merkmale1 WITH FRAME TITLE TEXT-001.

  PARAMETERS:   r1 RADIOBUTTON GROUP r1.
  PARAMETERS : insp      LIKE qals-prueflos,
*             name(50)  TYPE c,
               sname(50) TYPE c,
               sampdt    TYPE sy-datum.
  PARAMETERS : r2  RADIOBUTTON GROUP r1,
               r21 RADIOBUTTON GROUP r1,
               r3  RADIOBUTTON GROUP r1.
  PARAMETERS : fgcode TYPE mara-matnr.
  PARAMETERS : p_plant TYPE mseg-werks.
SELECTION-SCREEN END OF BLOCK merkmale1.

AT SELECTION-SCREEN.
  PERFORM authorization.

AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.
    CHECK screen-name EQ 'PASS'.
    screen-invisible = 1.
    MODIFY SCREEN.
  ENDLOOP.

START-OF-SELECTION.

  CLEAR : puname.
*  select single * from pa0002 where pernr eq pernr and endda ge sy-datum.      "Commented by Vinayak S.
*  if sy-subrc eq 0.
*    concatenate pa0002-vorna pa0002-nachn into puname separated by space.
*  endif.

  CLEAR : i1.
  CONCATENATE 'BCL' p_plant INTO vendor.

*  PERFORM PASSW.

*  select single * from pa0002 where pernr eq pernr and endda gt sy-datum .     "Commented by Vinayak S.
*  if sy-subrc eq 0.
*    name = pa0002-vorna.
*  endif.
SELECT SINGLE PERSNUMBER FROM usr21 INTO @DATA(LV_PERSNUMBER) WHERE bname = @sy-uname.
  IF sy-subrc eq 0.
    SELECT SINGLE NAME_TEXT from ADRP INTO @DATA(LV_NAME) WHERE PERSNUMBER = @LV_PERSNUMBER.
      IF SY-SUBRC EQ 0.
        NAME = LV_NAME.
      ENDIF.

  ENDIF.

***************************5.5.22********************
  IF r1 EQ 'X'.
    SELECT SINGLE * FROM qamr WHERE prueflos = insp AND pruefdatub NE 0.        "Changed by Vinayak S.   pruefdatuv => pruefdatub
    IF sy-subrc EQ 0 AND qamr-aenderdat is INITIAL.
      pruefdatub = qamr-pruefdatub.
    ELSE.
      pruefdatub = qamr-aenderdat.
    ENDIF.

    SELECT SINGLE * FROM qave WHERE prueflos EQ insp AND vcode NE space.
    IF sy-subrc EQ 0.
      vdatum = qave-vdatum.
      IF preview EQ 'X'.
        MESSAGE 'USAGE DECISION IS ALREDY DONE' TYPE 'I'.
      ELSE.
        IF sy-uname EQ 'ITBOM01'.
          MESSAGE 'USAGE DECISION IS ALREDY DONE' TYPE 'I'.
        ELSE.
          MESSAGE 'USAGE DECISION IS ALREDY DONE' TYPE 'E'.
        ENDIF.
      ENDIF.
    ENDIF.
    SELECT SINGLE * FROM qals WHERE prueflos EQ insp.
    IF sy-subrc EQ 0.
      werks = qals-werk.
    ENDIF.
*    if pernr ne '00007413'. "20.6.22                         "Commented by Vinayak S.
*      clear : pernr1,pernr2,pernr3.
*      if reprint eq 'X'.
*        if werks eq '1000'.
**          SELECT SINGLE * FROM ZQMS_DEPTHEAD WHERE BTRTL EQ '1228'.
*          select single * from zqms_depthead1 where btrtl eq '1228' and to_dt ge sy-datum..
*          if sy-subrc eq 0.
*            pernr1 = zqms_depthead1-pernr.
*          endif.
*          select single * from zqms_depthead2 where btrtl eq '1228' and from_dt le sy-datum and to_dt ge sy-datum..
*          if sy-subrc eq 0.
*            pernr2 = zqms_depthead2-pernr.
*          endif.
*          select single * from zqms_depthead1 where btrtl eq '1228' and to_dt ge sy-datum. "ADDED ON 8.6.25
*          if sy-subrc eq 0.
*            pernr3 = zqms_depthead1-pernr1.
*          endif.
*          if pernr1 ne pernr.
*            if pernr2 ne pernr.
*              if pernr3 ne pernr.
*                message 'MESSAGE ONLY QA DEPARTMENT IS ALLOWED FOR REPRINT' type 'E'.
*              endif.
*            endif.
*          endif.
**          IF pernr EQ '00002051'.
**          ELSEIF pernr EQ '00005693'.
***      ELSEIF pernr EQ '00007413'.
**          ELSE.
**            MESSAGE 'ONLY QA DEPARTMENT IS ALLOWED FOR REPRINT' TYPE 'E'.
**          ENDIF.
*          perform passw.
*        elseif werks eq '1001'.
**          IF pernr EQ '00011924'.
***      ELSEIF pernr EQ '00007413'.
**          ELSE.
**            MESSAGE 'ONLY QA DEPARTMENT IS ALLOWED FOR REPRINT' TYPE 'E'.
**          ENDIF.
*
**          SELECT SINGLE * FROM ZQMS_DEPTHEAD WHERE BTRTL EQ '1328'.
*          select single * from zqms_depthead1 where btrtl eq '1328' and to_dt ge sy-datum..
*          if sy-subrc eq 0.
*            pernr1 = zqms_depthead1-pernr.
*          endif.
*          select single * from zqms_depthead2 where btrtl eq '1328' and from_dt le sy-datum and to_dt ge sy-datum..
*          if sy-subrc eq 0.
*            pernr2 = zqms_depthead2-pernr.
*          endif.
*          select single * from zqms_depthead1 where btrtl eq '1328' and to_dt ge sy-datum. "ADDED ON 8.6.25
*          if sy-subrc eq 0.
*            pernr3 = zqms_depthead1-pernr1.
*          endif.
*
*          if pernr1 ne pernr.
*            if pernr2 ne pernr.
*              if pernr3 ne pernr.
*                message 'MESSAGE ONLY QA DEPARTMENT IS ALLOWED FOR REPRINT' type 'E'.
*              endif.
*            endif.
*          endif.
*
*        endif.
*        perform passw.
*      else.
*        if werks eq '1000'.
*          select single * from pa0001 where pernr eq pernr and endda ge sy-datum and btrtl eq '1223'.
**            and btrtl eq '1223'.
*          if sy-subrc eq 4.
*            if sy-uname eq 'BCLLDEVP1'.
*            else.
*              message 'ONLY QC DEPARTMENT IS ALLOWED TO PRINT' type 'E'.
*            endif.
*          endif.
*        elseif werks eq '1001'.
*          select single * from pa0001 where pernr eq pernr and endda ge sy-datum and btrtl eq '1323'.
*          if sy-subrc eq 4.
*            message 'ONLY QC DEPARTMENT IS ALLOWED TO PRINT' type 'E'.
*          endif.
*        endif.
*        perform passw.
*      endif.
*    endif.
  ELSE.
    werks = p_plant.
  ENDIF.

***********************************************************

  IF reprint EQ 'X'.
    IF r2 EQ 'X' OR r3 EQ 'X'.
      IF p_plant EQ '1000'.
*        SELECT SINGLE * FROM ZQMS_DEPTHEAD WHERE BTRTL EQ '1228'.
        SELECT SINGLE * FROM zqms_depthead1 WHERE btrtl EQ '1228' AND to_dt GE sy-datum..
        IF sy-subrc EQ 0.
          pernr1 = zqms_depthead1-pernr.
        ENDIF.
        SELECT SINGLE * FROM zqms_depthead2 WHERE btrtl EQ '1228' AND from_dt LE sy-datum AND to_dt GE sy-datum..
        IF sy-subrc EQ 0.
          pernr2 = zqms_depthead2-pernr.
        ENDIF.
        SELECT SINGLE * FROM zqms_depthead1 WHERE btrtl EQ '1228' AND to_dt GE sy-datum..
        IF sy-subrc EQ 0.
          pernr3 = zqms_depthead1-pernr1.
        ENDIF.
*        if pernr ne pernr1.                        "Commented by Vinayak S.
*          if pernr ne pernr2.
*            if pernr ne pernr3.
*              message 'INVALID USER' type 'E'.
*            endif.
*          endif.
*        endif.

*        IF pernr EQ '00005693'.  "FOR PLANT 1000
**    elseif pernr eq '00004230'.  "FOR PLANT 1001
*        ELSEIF pernr EQ '00014022'.
**        ELSEIF PERNR EQ '00007413'.
*        ELSE.
*          MESSAGE 'INVALID USER' TYPE 'E'.
*        ENDIF.
        PERFORM passw.
      ELSEIF p_plant EQ '1001'.
**      if pernr eq '00011406'.  "FOR PLANT 1000
*        IF pernr EQ '00011924'.  "FOR PLANT 1001
**        ELSEIF PERNR EQ '00014178'.  "9.6.21
**        ELSEIF PERNR EQ '00014278'.
**        ELSEIF PERNR EQ '00012108'.
**        ELSEIF PERNR EQ '00014022'.
**        ELSEIF PERNR EQ '00007413'.
*        ELSE.
*          MESSAGE 'INVALID USER' TYPE 'E'.
*        ENDIF.

*        SELECT SINGLE * FROM ZQMS_DEPTHEAD WHERE BTRTL EQ '1328'.
        SELECT SINGLE * FROM zqms_depthead1 WHERE btrtl EQ '1328' AND to_dt GE sy-datum.
        IF sy-subrc EQ 0.
          pernr1 = zqms_depthead1-pernr.
        ENDIF.
        SELECT SINGLE * FROM zqms_depthead2 WHERE btrtl EQ '1328' AND from_dt LE sy-datum AND to_dt GE sy-datum.
        IF sy-subrc EQ 0.
          pernr2 = zqms_depthead2-pernr.
        ENDIF.
        SELECT SINGLE * FROM zqms_depthead1 WHERE btrtl EQ '1328' AND to_dt GE sy-datum.
        IF sy-subrc EQ 0.
          pernr3 = zqms_depthead1-pernr1.
        ENDIF.
*        if pernr ne pernr1.              "Commented by Vinayak S.
*          if pernr ne pernr2.
*            if pernr ne pernr3.
*              message 'INVALID USER' type 'E'.
*            endif.
*          endif.
*        endif.

        PERFORM passw.
      ENDIF.
    ENDIF.
  ELSEIF upload EQ 'X'.
*    select single * from pa0001 where pernr eq pernr and endda ge sy-datum.              "Commented by Vinayak S.
*    if sy-subrc eq 0.
*      btrtl = pa0001-btrtl.
*    endif.
*    if p_plant eq '1000' and ( btrtl eq '1223' or btrtl eq '1228' ).
*    elseif p_plant eq '1001' and ( btrtl eq '1323' or btrtl eq '1328').
*    else.
*      message 'ONLY QC DEPARTMENT IS ALLOWED FOR UPLOAD COPY' type 'E'.
*    endif.
*    perform passw.
  ENDIF.

  IF r1 EQ 'X'.
    IF insp IS INITIAL.
      MESSAGE 'ENTER INSPECTION LOT NUMBER' TYPE 'E'.
    ENDIF.

    PERFORM insp.
  ELSEIF r2 EQ 'X' OR r3 EQ 'X' OR r21 EQ 'X'.
    IF fgcode IS   INITIAL.
      MESSAGE 'ENTER PRODUCT CODE' TYPE 'E'.
    ENDIF.
    IF p_plant IS INITIAL.
      MESSAGE 'ENTER PLANT' TYPE 'E'.
    ENDIF.
    PERFORM product.
  ENDIF.

FORM insp.

*  IF REPRINT EQ 'X'.
*    PERFORM PASSW.
*    IF NAME IS NOT INITIAL.
*      MESSAGE 'REMOVE NAME FOR REPRINT' TYPE 'E'.
*    ENDIF.
*    IF SNAME IS NOT INITIAL.
*      MESSAGE 'REMOVE SAMPLED BY NAME FOR REPRINT' TYPE 'E'.
*    ENDIF.
*  ELSE.
*    IF NAME IS INITIAL.
*      MESSAGE 'ENTER NAME' TYPE 'E'.
*    ENDIF.
*    IF SNAME IS INITIAL.
*      MESSAGE 'ENTER SAMPLE BY NAME' TYPE 'E'.
*    ENDIF.
*  ENDIF.
  CLEAR : mtart.
  SELECT SINGLE * FROM qals WHERE prueflos EQ insp.
  IF sy-subrc EQ 0.
    SELECT SINGLE * FROM mara WHERE matnr EQ qals-matnr.
    IF sy-subrc EQ 0.
      mtart = mara-mtart.
    ENDIF.
  ENDIF.

  IF mtart EQ 'ZROH' AND werks EQ '1000'.
  ELSEIF mtart EQ 'ZROH' OR mtart EQ 'ZVRP'.
    MESSAGE 'ONLY FOR FINISHED GOODS' TYPE 'E'.
  ENDIF.

  IF insp+0(2) = '15'.
    MESSAGE 'NOT FOR STABILITY INSPECTION LOT' TYPE 'E'.
  ENDIF.

  IF reprint EQ 'X'.
    SELECT SINGLE * FROM zqc_fg_sheet WHERE prueflos EQ insp.
*  AND PRINTED EQ 'X'.
    IF sy-subrc NE 0.
      MESSAGE 'PRINT IS NOT YET TAKEN' TYPE 'E'.
    ENDIF.
  ENDIF.
  IF mtart NE 'ZROH'.
    SELECT SINGLE * FROM zqc_fg_sheet WHERE prueflos EQ insp.
    IF sy-subrc EQ 0.
      IF sname IS NOT INITIAL.
        MESSAGE 'REMOVE SAMPLED BY NAME' TYPE 'E'.
      ENDIF.
      IF sampdt IS NOT INITIAL.
        MESSAGE 'REMOVE SAMPLED ON DATE ' TYPE 'E'.
      ENDIF.
    ENDIF.
    SELECT SINGLE * FROM zqc_fg_sheet WHERE prueflos EQ insp.
    IF sy-subrc EQ 4.
      IF sname IS INITIAL.
        MESSAGE 'ENTER SAMPLED BY NAME' TYPE 'E'.
      ENDIF.
      IF sampdt IS INITIAL.
        MESSAGE 'ENTER SAMPLED ON DATE ' TYPE 'E'.
      ENDIF.
    ENDIF.
  ENDIF.
  i1 = 'A'.
  SELECT * FROM qals INTO TABLE it_qals WHERE prueflos EQ insp.
  IF sy-subrc NE 0.
    MESSAGE 'NO DATA FOUND FO THIS INSPECTION LOT' TYPE 'E'.
    EXIT.
  ENDIF.

  insp1 = insp.
  SELECT * FROM qamv INTO TABLE it_qamv WHERE prueflos EQ insp.
  IF reprint NE 'X'.
    IF preview NE 'X'.
      SELECT SINGLE * FROM zqc_fg_sheet WHERE prueflos EQ insp AND printed EQ 'X'.
      IF sy-subrc EQ 0.
        MESSAGE 'PRINT IS ALREADY TAKEN ' TYPE 'E'.
      ENDIF.
    ENDIF.
  ENDIF.

  enstehdat = sampdt.
  uname = name.

  udate = sy-datum.
  uzeit = sy-uzeit.

  SELECT SINGLE * FROM zqc_fg_sheet_r WHERE prueflos EQ insp AND budat EQ sy-datum.
  IF sy-subrc EQ 0.
    SELECT SINGLE * FROM zqc_fg_sheet WHERE prueflos EQ insp.
    IF sy-subrc EQ 0.
      udate = zqc_fg_sheet-printdt.
      uzeit = zqc_fg_sheet_r-cputm.  "17.11.22
      IF uzeit EQ 0.
        uzeit = zqc_fg_sheet-cputm.
      ENDIF.
      uname = zqc_fg_sheet-name.
    ENDIF.
  ENDIF.

  SELECT SINGLE * FROM zqc_fg_sheet WHERE prueflos EQ insp.
*  AND PRINTED EQ 'X'.
  IF sy-subrc EQ 0.
*    UNAME = ZQC_FG_SHEET-NAME.
*    UDATE = ZQC_FG_SHEET-PRINTDT.
*    UZEIT = ZQC_FG_SHEET-CPUTM.
    usname = zqc_fg_sheet-samby.
    enstehdat = zqc_fg_sheet-sampdt.
  ELSE.
*    UNAME = NAME.
*    UDATE = SY-DATUM.
*    UZEIT = SY-UZEIT.
    usname = sname.
    enstehdat = sampdt.
  ENDIF.
  usname1 = usname.

  IF reprint EQ 'X'.  "ADDED ON 20.3.23
    SELECT SINGLE * FROM zqc_fg_sheet_q WHERE prueflos EQ insp.
    IF sy-subrc EQ 0.
      udate = zqc_fg_sheet_q-budat.
      uzeit = zqc_fg_sheet_q-cputm.  "17.11.22
    ENDIF.
  ENDIF.

  CLEAR : cpudt.
  LOOP AT it_qals INTO wa_qals.
    CLEAR : mblnr,mjahr.
    charg = wa_qals-charg.
    matnr = wa_qals-matnr.
    mblnr = wa_qals-mblnr.
    mjahr = wa_qals-mjahr.

    menge = wa_qals-losmenge.
    CONDENSE menge.
*    MEINS = WA_QALS-MENGENEINH.
    CONCATENATE menge wa_qals-mengeneinh INTO menge SEPARATED BY space.
    CONDENSE menge.
    lichn = wa_qals-lichn.
    IF lichn EQ space.
      SELECT SINGLE * FROM mcha WHERE matnr EQ wa_qals-matnr AND werks EQ wa_qals-werk AND charg EQ wa_qals-charg.
      IF sy-subrc EQ 0.
        lichn = mcha-licha.
      ENDIF.
    ENDIF.
    CLEAR : mfgr,sname1.
    SELECT SINGLE * FROM zmigo WHERE mblnr EQ mblnr AND mjahr = mjahr.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM lfa1 WHERE lifnr EQ zmigo-mfgr.
      IF sy-subrc EQ 0.
        mfgr = lfa1-name1.
      ENDIF.
    ENDIF.
************manufacturere added on 23.12.24*********
    IF mfgr EQ space.
      CLEAR : it_qals1,wa_qals1.
      SELECT * FROM qals INTO TABLE it_qals1 WHERE charg EQ wa_qals-charg AND lifnr NE space.
      LOOP AT it_qals1 INTO wa_qals1.
        SELECT SINGLE * FROM jest WHERE objnr EQ wa_qals1-objnr AND stat EQ 'I0224'.
        IF sy-subrc EQ 0.
          DELETE it_qals1 WHERE prueflos EQ wa_qals1-prueflos.
        ENDIF.
      ENDLOOP.
      DELETE it_qals1 WHERE charg EQ space.  "31.1.24
      SORT it_qals1.
      READ TABLE it_qals1 INTO wa_qals1 WITH KEY charg = wa_qals-charg.
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM zmigo WHERE mblnr EQ wa_qals1-mblnr AND mjahr = wa_qals1-mjahr.
        IF sy-subrc EQ 0.
          SELECT SINGLE * FROM lfa1 WHERE lifnr EQ zmigo-mfgr.
          IF sy-subrc EQ 0.
            mfgr = lfa1-name1.
          ENDIF.
        ENDIF.
      ENDIF.

    ENDIF.

*    break-point.

    IF mfgr EQ space AND mtart EQ 'ZRQC'.
      SELECT SINGLE * FROM mseg WHERE mblnr EQ wa_qals-mblnr AND mjahr EQ wa_qals-mjahr AND zeile EQ wa_qals-zeile AND sgtxt NE space.
      IF sy-subrc EQ 0.
        mfgr = mseg-sgtxt.
      ENDIF.
    ENDIF.
*************************************
    SELECT SINGLE * FROM lfa1 WHERE lifnr EQ wa_qals-lifnr.
    IF sy-subrc EQ 0.
      sname1 = lfa1-name1.
    ENDIF.
    IF sname1 EQ space.
      READ TABLE it_qals1 INTO wa_qals1 WITH KEY charg = wa_qals-charg.
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM lfa1 WHERE lifnr EQ wa_qals1-lifnr.
        IF sy-subrc EQ 0.
          sname1 = lfa1-name1.
        ENDIF.
      ENDIF.
    ENDIF.
    SELECT SINGLE * FROM mkpf WHERE mblnr = mblnr AND mjahr =  mjahr.
    IF sy-subrc EQ 0.
      cpudt = mkpf-budat.
    ENDIF.

    SELECT SINGLE * FROM zcoadata WHERE prueflos EQ insp.
    IF sy-subrc EQ 0.
      sampo = zcoadata-sampon.
      sampb = zcoadata-sampby.
      qtysamp = zcoadata-sampqty.
*      PACKSZ = ZCOADATA-PACK.
*      FOOT = ZCOADATA-FOOTER.
    ENDIF.

    CLEAR : ads,adsmatnr.
    adsmatnr = wa_qals-matnr.
    IF adsmatnr CS 'H'.
    ELSE.
      PACK adsmatnr TO adsmatnr.
    ENDIF.
    CONDENSE adsmatnr.
    IF wa_qals-prueflos+0(2) EQ '89'.
      CONCATENATE 'ADS/' adsmatnr '/U' INTO ads.
    ELSE.
      CONCATENATE 'ADS/' adsmatnr INTO ads.
    ENDIF.
    CONDENSE ads.
    SELECT SINGLE * FROM mara WHERE matnr EQ wa_qals-matnr.
    IF sy-subrc EQ 0.
      mtart = mara-mtart.
      IF mara-mtart EQ 'ZHLB'.
        IF r3 EQ 'X'.
*          TEXT1 = 'Coated Product Analytical Data Sheet'.
          text1 = 'Bulk Product Analytical Data Sheet (Uncoated Tablet)'.
        ELSE.
          IF insp+0(2) EQ '89'.
            text1 = 'Bulk Product Analytical Data Sheet (Uncoated Tablet)'.
          ELSE.
            SELECT SINGLE * FROM qmat WHERE matnr EQ wa_qals-matnr AND art EQ '89'.
            IF sy-subrc EQ 0.
              text1 = 'Bulk Product Analytical Data Sheet (Coated Tablet)'.
            ELSE.
              text1 = 'Bulk Product Analytical Data Sheet'.
            ENDIF.
          ENDIF.
*        ELSEIF R3 EQ 'X'.
*          TEXT1 = 'Coated Product Analytical Data Sheet'.
        ENDIF.
      ELSEIF mara-mtart EQ 'ZROH'.
        IF werks EQ '1000' AND insp+0(2) EQ '09'.
          text1 = 'Raw Material Analytical Data Sheet (Retest)'.
        ELSE.
          text1 = 'Raw Material Analytical Data Sheet'.
        ENDIF.
      ELSEIF mara-mtart EQ 'ZVRP'.
        text1 = 'Packing Material Analytical Data Sheet'.
      ELSEIF mara-mtart EQ 'ZRQC'.
        text1 = 'Ancillary Material Analytical Data Sheet'.
      ELSE.
*         MARA-MTART EQ 'ZFRT'.

        text1 = 'Finished Product Analytical Data Sheet'.


      ENDIF.
    ENDIF.
    CLEAR : q1.
    IF reprint EQ 'X'.
      SELECT SINGLE * FROM zqc_fg_sheet_r WHERE prueflos EQ insp AND budat EQ sy-datum.
      IF sy-subrc EQ 0.
      ELSE.
        CONCATENATE text1 '(QA COPY)' INTO text1 SEPARATED BY space.
        q1 = 'Y'.
      ENDIF.
    ENDIF.

*    ENSTEHDAT = WA_QALS-ENSTEHDAT.
    IF mtart EQ 'ZROH'.
      CLEAR : maktx1,maktx2,maktx,normt.
      SELECT SINGLE * FROM makt WHERE matnr EQ wa_qals-matnr AND spras EQ 'EN'.
      IF sy-subrc EQ 0.
        maktx1 = makt-maktx.
      ENDIF.
      SELECT SINGLE * FROM makt WHERE matnr EQ wa_qals-matnr AND spras EQ 'Z1'.
      IF sy-subrc EQ 0.
        maktx2 = makt-maktx.
      ENDIF.
      SELECT SINGLE * FROM mara WHERE matnr EQ wa_qals-matnr.
      IF sy-subrc EQ 0.
        normt = mara-normt.
      ENDIF.
      CONCATENATE maktx1 maktx2 normt INTO maktx SEPARATED BY space.

******************************************************************* NEW CHANGE ON 5.1.22*****************
      SELECT SINGLE * FROM ekko WHERE ebeln EQ wa_qals-ebeln.
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM zpo_matnr WHERE matnr EQ wa_qals-matnr.
        IF sy-subrc EQ 0.
          IF ekko-aedat GE zpo_matnr-effectdt.
            SELECT SINGLE * FROM ekpo WHERE ebeln EQ wa_qals-ebeln AND ebelp EQ wa_qals-ebelp.
            IF sy-subrc EQ 0.
              maktx = ekpo-txz01.
              normt = space.
              maktx1 = space.
              maktx2 = space.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
*****************************************************
    ELSE.
      CLEAR : maktx1,maktx2,maktx,normt.
      SELECT SINGLE * FROM makt WHERE matnr EQ wa_qals-matnr AND spras EQ 'EN'.
      IF sy-subrc EQ 0.
        maktx1 = makt-maktx.
      ENDIF.
      SELECT SINGLE * FROM makt WHERE matnr EQ wa_qals-matnr AND spras EQ 'Z1'.
      IF sy-subrc EQ 0.
        maktx2 = makt-maktx.
      ENDIF.

      CONCATENATE maktx1 maktx2 INTO maktx SEPARATED BY space.

*      SELECT SINGLE * FROM makt WHERE matnr EQ wa_qals-matnr AND spras EQ 'EN'.
*      IF sy-subrc EQ 0.
*        maktx = makt-maktx.
*      ENDIF.
    ENDIF.
    CONDENSE maktx.
    SELECT SINGLE * FROM mch1 WHERE matnr EQ wa_qals-matnr AND charg EQ wa_qals-charg.          "Changed by Vinayak S.
    IF sy-subrc EQ 0.                                                                            "MCHA=>MCH1
      hsdat = mch1-hsdat.
      vfdat = mch1-vfdat.
      lwedt = mch1-lwedt.
      werks = wa_qals-werk.

      CLEAR : hsdat1,vfdat1,aufnr.
      CONCATENATE mch1-hsdat+4(2) '/' mch1-hsdat+0(4) INTO hsdat1.
      CONCATENATE mch1-vfdat+4(2) '/' mch1-vfdat+0(4) INTO vfdat1.
******************* 89 insp lot ******************************

      IF hsdat1 EQ '00/0000' AND vfdat1 EQ '00/0000'.
        IF wa_qals-art EQ '89'.
          aufnr = wa_qals-aufnr.
          IF aufnr EQ space.
            PERFORM mfgexp.
*          concatenate sy-datum+4(2) '/' sy-datum+0(4) into hsdat1.
          ENDIF.
        ENDIF.
      ENDIF.
**************************************************************

      CLEAR : format.
      IF werks EQ '1001'.
        IF mtart EQ 'ZHLB'.
          format1 = 'Format No.: QC/GM/099-F15'.
*          if reprint eq 'X'.
*            select single * from zqc_fg_sheet_r where prueflos eq insp and budat eq sy-datum.
*            if sy-subrc eq 4.
*              format1 = 'Format No.: QC/GM/099-F20'.
*            endif.
*          endif.

        ELSEIF mtart EQ 'ZFRT' OR mtart EQ 'ZDSM' OR mtart EQ 'ZESC' OR mtart EQ 'ZESM'.
          format1 = 'Format No.: QC/GM/099-F11'.
        ELSEIF mtart EQ 'ZRQC'.
          format1 = 'Format No.: QC/GM/099-F12'.
*          IF mtart EQ 'ZFRT'.
*          format1 = 'Format no.: QC/GM/099-F1'.

*          if reprint eq 'X'.
*            select single * from zqc_fg_sheet_r where prueflos eq insp and budat eq sy-datum.
*            if sy-subrc eq 4.
*              format1 = 'Format No.: QC/GM/099-F16'.
*            endif.
*          endif.

        ENDIF.
      ELSEIF werks EQ '1000'.
        IF mtart EQ 'ZHLB'.
          IF insp+0(2) EQ '89'.
*            format1 = 'Format No.: SOP/QC/060-00-F5'.
            format1 = 'Format No.: SOP/QC/060-F5'.
          ELSE.
            SELECT SINGLE * FROM qmat WHERE matnr EQ matnr AND art EQ '89'.
            IF sy-subrc EQ 0.
              format1 = 'Format No.: SOP/QC/060-F7'.
*              format1 = 'Format No.: SOP/QC/060-00-F7'.
            ELSE.
*              format1 = 'Format No.: SOP/QC/060-00-F6'.
              format1 = 'Format No.: SOP/QC/060-F6'.
            ENDIF.
          ENDIF.
        ELSEIF mtart EQ 'ZFRT' OR mtart EQ 'ZDSM' OR mtart EQ 'ZESC' OR mtart EQ 'ZESM'.
*          format1 = 'Format No.: SOP/QC/060-00-F8'.
          format1 = 'Format No.: SOP/QC/060-F8'.
*          IF mtart EQ 'ZFRT'.
*          format1 = 'Format no.: QC/GM/099-F1'.
        ELSEIF mtart EQ 'ZROH'.
          IF insp+0(2) EQ '09'.
            format1 = 'Format No.: SOP/QC/060-F17'.
          ELSE.
            format1 = 'Format No.: SOP/QC/060-F15'.
          ENDIF.
        ELSEIF mtart EQ 'ZRQC'.
          format1 = 'Format No.: SOP/QC/060-F19'.
        ENDIF.

      ENDIF.
      SELECT SINGLE * FROM t001w WHERE werks EQ werks.
      IF sy-subrc EQ 0.
        IF werks EQ '1000'.
          kunnr = t001w-ort01.
        ELSE.
          kunnr = t001w-kunnr.
        ENDIF.
      ENDIF.
    ENDIF.
    mjahr = wa_qals-paendterm.
    mjahr1 = mjahr + 1.
  ENDLOOP.

  CLEAR : ver,effdt.

  IF insp+0(2) EQ '89'.  "added on 12.9.22

    SELECT * FROM zfginspc INTO TABLE it_zfginspc WHERE matnr EQ matnr AND werks EQ werks.
    SORT it_zfginspc DESCENDING BY version.
    READ TABLE it_zfginspc INTO wa_zfginspc WITH KEY matnr = matnr.
    IF sy-subrc EQ 0.
      SHIFT wa_zfginspc-version LEFT DELETING LEADING '0'.
      ver = wa_zfginspc-version.
      UNPACK ver TO ver.
      effdt = wa_zfginspc-budat.
    ENDIF.

  ELSE.

    SELECT * FROM zfginsp INTO TABLE it_zfginsp WHERE matnr EQ matnr AND werks EQ werks.
    SORT it_zfginsp DESCENDING BY version.
    READ TABLE it_zfginsp INTO wa_zfginsp WITH KEY matnr = matnr.
    IF sy-subrc EQ 0.
      SHIFT wa_zfginsp-version LEFT DELETING LEADING '0'.
      ver = wa_zfginsp-version.
      UNPACK ver TO ver.
      effdt = wa_zfginsp-budat.
    ENDIF.

  ENDIF.

  IF insp+0(2) EQ '89'.
    SELECT * FROM zqspecificationc INTO TABLE it_zqspecificationc WHERE matnr EQ matnr AND werks EQ werks.
    SORT it_zqspecificationc DESCENDING BY revision.
    CLEAR : specf, shelflife. "specification number &shelf life.
    READ TABLE it_zqspecificationc INTO wa_zqspecificationc WITH KEY matnr = matnr werks = werks.
    IF sy-subrc EQ 0.
      specf = wa_zqspecificationc-specification.
      shelflife = wa_zqspecificationc-shelflife.
    ENDIF.
    pack = wa_zqspecificationc-pack.
    CONDENSE pack.
  ELSE.
    SELECT * FROM zqspecification INTO TABLE it_zqspecification WHERE matnr EQ matnr AND werks EQ werks.
    SORT it_zqspecification DESCENDING BY revision.
    CLEAR : specf, shelflife. "specification number &shelf life.
    READ TABLE it_zqspecification INTO wa_zqspecification WITH KEY matnr = matnr werks = werks.
    IF sy-subrc EQ 0.
      specf = wa_zqspecification-specification.
      shelflife = wa_zqspecification-shelflife.
    ENDIF.
    pack = wa_zqspecification-pack.
    CONDENSE pack.
  ENDIF.

*  select single * from mvke where matnr eq matnr and vkorg eq '1000' and vtweg eq '10'.
*  if sy-subrc eq 0.
*    select single * from tvm5t where spras eq 'EN' and mvgr5 eq mvke-mvgr5.
*    if sy-subrc eq 0.
**      pack = tvm5t-bezei.
*    endif.
*  else.
*    select single * from mvke where matnr eq matnr and vkorg eq '1000' and vtweg eq '80'.
*    if sy-subrc eq 0.
*      select single * from tvm5t where spras eq 'EN' and mvgr5 eq mvke-mvgr5.
*      if sy-subrc eq 0.
**        pack = tvm5t-bezei.
*      endif.
*    else.
*      select single * from mvke where matnr eq matnr and vkorg eq '2000' and vtweg eq '20'.
*      if sy-subrc eq 0.
*        select single * from tvm5t where spras eq 'EN' and mvgr5 eq mvke-mvgr5.
*        if sy-subrc eq 0.
**          pack = tvm5t-bezei.
*        endif.
*      endif.
*
*    endif.
*  endif.



*  IF PACK CS 'ML' .
  packtxt = 'Pack Size'.
*  ELSEIF PACK CS 'L' .
*    PACKTXT = 'Pack Size:'.
*  ELSE.
*    PACKTXT = 'No. of tabs/ Strip:'.
*  ENDIF.


*IF MATNR CS 'H'.
*ELSE.
*  PACK MATNR TO MATNR.
*  CONDENSE MATNR.
*ENDIF.
***  SELECT * FROM AFPO INTO TABLE IT_AFPO WHERE DWERK EQ WERKS AND CHARG EQ CHARG AND MATNR EQ MATNR .
***  IF IT_AFPO IS NOT INITIAL.
***    LOOP AT IT_AFPO INTO WA_AFPO.
****     WHERE MATNR CS 'H'.
***      BATCHSZ = WA_AFPO-PSMNG.
***      BATCHUOM = WA_AFPO-MEINS.
***      EXIT.
***    ENDLOOP.
***  ENDIF.
  CLEAR :  batchsz, batchuom. "20.6.22
  SELECT * FROM afpo INTO TABLE it_afpo WHERE dwerk EQ werks AND charg EQ charg .  "15.2.21
  IF it_afpo IS NOT INITIAL.
    LOOP AT it_afpo INTO wa_afpo WHERE matnr CS 'H'.
      SELECT SINGLE * FROM aufk WHERE aufnr EQ wa_afpo-aufnr AND loekz EQ space.
      IF sy-subrc EQ 0.
*     WHERE MATNR CS 'H'.
        batchsz = wa_afpo-psmng.
        batchuom = wa_afpo-meins.
        EXIT.
      ENDIF.
*      exit.
    ENDLOOP.
  ENDIF.

  batchsz1 = batchsz.
  batchsz2 = batchsz1.

  CONCATENATE  batchsz2  batchuom INTO batchsz3 SEPARATED BY space.
  CONDENSE batchsz3.

  SELECT SINGLE * FROM a602 WHERE kschl EQ 'Z001' AND vkorg EQ '1000' AND matnr EQ matnr AND charg EQ charg AND datbi GT sy-datum.
  IF sy-subrc EQ 0.
    SELECT SINGLE * FROM konp WHERE knumh EQ a602-knumh AND kschl EQ 'Z001' .
    IF sy-subrc EQ 0.
      mrp = konp-kbetr.
    ENDIF.
  ELSE.
    SELECT SINGLE * FROM a602 WHERE kschl EQ 'Z001' AND vkorg EQ '2000' AND matnr EQ matnr AND charg EQ charg AND datbi GT sy-datum.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM konp WHERE knumh EQ a602-knumh AND kschl EQ 'Z001' .
      IF sy-subrc EQ 0.
        mrp = konp-kbetr.
      ENDIF.
    ENDIF.
  ENDIF.

  SELECT SINGLE * FROM mara WHERE matnr EQ matnr AND mtart IN ('ZDSM','ZESM').  "23.11.22
  IF sy-subrc EQ 0.
    mrp = 0.
  ENDIF.

****************SAMPLE REMOVAL************
  SELECT SINGLE * FROM mseg WHERE mjahr  EQ mjahr AND bwart EQ '344' AND matnr EQ matnr AND lgort EQ 'CSM' AND charg EQ charg.
  IF sy-subrc EQ 0.
    sampqty = mseg-menge.
    sqtyuom = mseg-meins.
  ENDIF.
  sampqty = qals-lmenge03.                      "Added by Vinayak S.
  num = matnr.
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
*     CLIENT                  = SY-MANDT
      id                      = 'PRUE'
      language                = 'E'
      name                    = num
      object                  = 'MATERIAL'
*     ARCHIVE_HANDLE          = 0
*                  IMPORTING
*     HEADER                  =
    TABLES
      lines                   = mmline2
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
  CLEAR : r11.
  LOOP AT mmline2.
    IF sy-tabix EQ 1.
      MOVE mmline2-tdline TO w_itexta1.
    ELSEIF sy-tabix EQ 2.
      MOVE mmline2-tdline TO w_itexta2.
    ENDIF.

    IF sy-tabix LE 2.
*  move mmline2-tdline to w_itexta.
      MOVE mmline2-tdline TO r11.
      CONCATENATE w_itexta r11  INTO w_itexta SEPARATED BY space.
*  elseif sy-tabix eq 2.
*    move mmline2-tdline to w_itextb.
*  else.
*    move mmline2-tdline to w_itext2.
*    concatenate s3 w_itext2 into s3 separated by space.
*  endif.
*    WRITE :  / 'LR',LRNO.
*  exit.
    ENDIF.
  ENDLOOP.
  CONDENSE : w_itexta,w_itexta1,w_itexta2.
*********** label claim****************


**************************

*  IF PREVIEW EQ 'X'.
*    ITCPO-TDPREVIEW = ''.
*    ITCPO-TDNOPRINT = 'X'.
*    ITCPO-TDPREVIEW = 'X'.
*
*    CALL FUNCTION 'OPEN_FORM'
*      EXPORTING
*        DEVICE                      = 'PRINTER'
*        DIALOG                      = 'X'
**       OPTIONS                     = OPTIONS
*        OPTIONS                     = ITCPO
**       TDPREVIEW                   = 'X'
**       FORM                        = 'ZFGINSP1_N5'
*        FORM                        = 'ZFGINSP1_N7_1'
**       FORM                        = FORMNM
**       FORM                        = 'ZRMRESTREP_8'
*      EXCEPTIONS
*        CANCELED                    = 1
*        DEVICE                      = 2
*        FORM                        = 3
*        OPTIONS                     = 4
*        UNCLOSED                    = 5
*        MAIL_OPTIONS                = 6
*        ARCHIVE_ERROR               = 7
*        INVALID_FAX_NUMBER          = 8
*        MORE_PARAMS_NEEDED_IN_BATCH = 9
*        SPOOL_ERROR                 = 10
*        CODEPAGE                    = 11
*        OTHERS                      = 12.
*    IF SY-SUBRC <> 0.
*    ENDIF.
*
*  ELSE.
*
*    ITCPO-TDNOPREV = 'X'.
*
*    ITCPO-TDIMMED = 'X'." added on 7.2.23
*    ITCPO-TDDELETE = 'X'.
*
*
*    CALL FUNCTION 'OPEN_FORM'
*      EXPORTING
*        DEVICE                      = 'PRINTER'
*        DIALOG                      = 'X'
**       OPTIONS                     = OPTIONS
*        OPTIONS                     = ITCPO
**       TDPREVIEW                   = 'X'
**       FORM                        = 'ZFGINSP1_N5'
*        FORM                        = 'ZFGINSP1_N7_1'
**       FORM                        = FORMNM
**       FORM                        = 'ZRMRESTREP_8'
*      EXCEPTIONS
*        CANCELED                    = 1
*        DEVICE                      = 2
*        FORM                        = 3
*        OPTIONS                     = 4
*        UNCLOSED                    = 5
*        MAIL_OPTIONS                = 6
*        ARCHIVE_ERROR               = 7
*        INVALID_FAX_NUMBER          = 8
*        MORE_PARAMS_NEEDED_IN_BATCH = 9
*        SPOOL_ERROR                 = 10
*        CODEPAGE                    = 11
*        OTHERS                      = 12.
*    IF SY-SUBRC <> 0.
*    ENDIF.
*
*  ENDIF.


*  CALL FUNCTION 'OPEN_FORM'
*    EXPORTING
*      DEVICE                      = 'PRINTER'
**     TDNOPREV                    = 'X'
**     DIALOG                      = 'X'
**     FORM                        = 'ZFGINSP7'
**     FORM                        = 'ZFGINSP8'
**     FORM                        = 'ZFGINSP84'
**     FORM                        = 'ZFGINSP86'
*      FORM                        = 'ZFGINSP1'
**     FORM                        = FORMNM
**     FORM                        = 'ZRMRESTREP_8'
*    EXCEPTIONS
*      CANCELED                    = 1
*      DEVICE                      = 2
*      FORM                        = 3
*      OPTIONS                     = 4
*      UNCLOSED                    = 5
*      MAIL_OPTIONS                = 6
*      ARCHIVE_ERROR               = 7
*      INVALID_FAX_NUMBER          = 8
*      MORE_PARAMS_NEEDED_IN_BATCH = 9
*      SPOOL_ERROR                 = 10
*      CODEPAGE                    = 11
*      OTHERS                      = 12.
*  IF SY-SUBRC <> 0.
*  ENDIF.
  IF sy-ucomm EQ 'PRNT'.
    IF reprint NE 'X'.
      SELECT SINGLE * FROM zqc_fg_sheet WHERE prueflos EQ insp AND matnr EQ matnr AND charg EQ charg AND printed EQ 'X'.
      IF sy-subrc EQ 0.
        MESSAGE 'PRINT HAS BEEN ALREDAY TAKEN, TO REPRINT NEED APPROVAL' TYPE 'E'.
        a = 1.
        EXIT.
      ENDIF.
    ENDIF.
  ENDIF.
*************************************************************
*  IF INSP+0(2) = '89'.
  IF insp+0(2) = '89' .
    CONCATENATE 'BCL' '3000' INTO vendor.
  ELSE.
    CONCATENATE 'BCL' werks INTO vendor.                    "Changed by Vinayak S.
  ENDIF.
  IF mtart EQ 'ZROH' AND werks EQ '1000'.
    IF insp+0(2) = '09' .
      CONCATENATE 'BCL' '3000' INTO vendor.
    ENDIF.
  ENDIF.

  SELECT SINGLE * FROM qinf WHERE matnr EQ matnr AND lieferant EQ vendor AND werk EQ werks.
  IF sy-subrc EQ 0.
    matnr1 = qinf-matnr.
    IF matnr1 CS 'H'.
      s1 = strlen( matnr1 ).
*        WRITE : S1.
      IF s1 EQ 6.
        a2 = '                                  '.          "Changed by Vinayak S.
        CONCATENATE matnr1 qinf-zaehl INTO num SEPARATED BY a2.
      ELSEIF s1 EQ 9.
        a3 = '         '.
        CONCATENATE matnr1 qinf-zaehl INTO num SEPARATED BY a3.
      ELSEIF s1 EQ 7.
        a4 = '           '.
        CONCATENATE matnr1 qinf-zaehl INTO num SEPARATED BY a4.
      ENDIF.
    ELSE.
      CONCATENATE qinf-matnr qinf-zaehl INTO num SEPARATED BY a5.         "Changed by Vinayak S.
    ENDIF.
  ENDIF.

*    NUM = '000000000000041007000001'.
*
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
*     CLIENT                  = SY-MANDT
      id                      = 'QINF'
      language                = 'E'
      name                    = num
      object                  = 'QINF'
*     ARCHIVE_HANDLE          = 0
*                  IMPORTING
*     HEADER                  =
    TABLES
      lines                   = mmline1
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

**********************************************************************

*  CALL FUNCTION 'READ_TEXT'
*    EXPORTING
**     CLIENT                  = SY-MANDT
*      ID                      = 'IVER'
*      LANGUAGE                = 'E'
*      NAME                    = NUM
*      OBJECT                  = 'MATERIAL'
**     ARCHIVE_HANDLE          = 0
**                  IMPORTING
**     HEADER                  =
*    TABLES
*      LINES                   = MMLINE1
*    EXCEPTIONS
*      ID                      = 1
*      LANGUAGE                = 2
*      NAME                    = 3
*      NOT_FOUND               = 4
*      OBJECT                  = 5
*      REFERENCE_CHECK         = 6
*      WRONG_ACCESS_TO_ARCHIVE = 7
*      OTHERS                  = 8.
*  IF SY-SUBRC <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.

*CALL FUNCTION 'WRITE_FORM'
*  EXPORTING
*    ELEMENT = 'TEST'
**   function = 'SET'
**   type    = 'BODY'
*    WINDOW  = 'MAIN'.

*CALL FUNCTION 'WRITE_FORM'
*  EXPORTING
*    ELEMENT = 'DESC'
**   function = 'SET'
**   type    = 'BODY'
*    WINDOW  = 'MAIN'.
*
*CALL FUNCTION 'WRITE_FORM'
*  EXPORTING
*    ELEMENT = 'IDEN'
**   function = 'SET'
**   type    = 'BODY'
*    WINDOW  = 'MAIN'.

*  IF MTART EQ 'ZHLB'.
**    CALL FUNCTION 'WRITE_FORM'
**      EXPORTING
**        ELEMENT = 'TEST1H'
***       function = 'SET'
***       type    = 'BODY'
**        WINDOW  = 'MAIN'.
*  ELSEIF MTART EQ 'ZROH'.
**    CALL FUNCTION 'WRITE_FORM'
**      EXPORTING
**        ELEMENT = 'TEST1R'
***       function = 'SET'
***       type    = 'BODY'
**        WINDOW  = 'MAIN'.
*  ELSE.
**    CALL FUNCTION 'WRITE_FORM'
**      EXPORTING
**        ELEMENT = 'TEST1'
**       function = 'SET'
**       type    = 'BODY'
**        WINDOW  = 'MAIN'.
*  ENDIF.

  PERFORM printcomm.


*  BREAK-POINT.

*  LOOP AT MMLINE1.
*    CLEAR : TEXT2,PG,B,C,U,D,BL1,BLD1.
**  text3,text4.
**  if sy-tabix eq 1.
**  MOVE MMLINE21-TDLINE TO W_ITEXTA.
**  elseif sy-tabix eq 2.
**    move mmline2-tdline to w_itextb.
**  else.
*    MOVE MMLINE1-TDLINE TO W_ITEXT2.
*    CONCATENATE TEXT2 W_ITEXT2 INTO TEXT2 SEPARATED BY SPACE.
**  endif.
**    WRITE :  / 'LR',LRNO.
*    PG = TEXT2+0(9).
*
*    IF PG CS 'NEW-PAGE'.
*      B = 1.
*    ENDIF.
**  if pg cs 'BOLD'.
**    b = '1'.
**    bl1 = '1'.
**  endif.
*
*    IF PG CS 'BOLD'.
*      BLD1 = '1'.
*    ENDIF.
*
*    IF PG CS 'ULINE1'.
*      U = 2.
*    ELSEIF PG CS 'ULINE'.
*      U = 1.
*    ENDIF.
*
*    IF TEXT2+72(1) EQ '-'.
*      C = '1'.
*    ELSEIF TEXT2+72(1) EQ '_'.
*      C = '1'.
*    ELSEIF TEXT2+71(2) EQ '-S'.
*      D = '1'.
*      C = '1'.
*    ELSE.
*      C = '0'.
*    ENDIF.
**   IF TEXT2+72(1) EQ '_'.
**    C = 1.
**  ELSE.
**    C = 0.
**  ENDIF.
*    IF TEXT2+72(1) EQ '_'.
*      TEXT2+73(1) = '_'.
*    ELSEIF TEXT2+72(1) EQ '-'.
**    REPLACE '-' WITH '.' INTO text2.
*      TEXT2+72(1) = ''.
*
*    ELSEIF TEXT2+71(2) EQ '-S'.
**    REPLACE '-' WITH '.' INTO text2.
*      TEXT2+71(2) = ''.
**    text3 = text2.
**    text4 = text3.
*    ENDIF.
*
*    IF BLD1 EQ '1'.
*      TEXT2 = SPACE.
*    ENDIF.
*
**  IF TEXT2 CS 'ULINE'.
**TEXT2 = SPACE.
**    CALL FUNCTION 'WRITE_FORM'
**      EXPORTING
**        ELEMENT = 'TESTLINE'
***       function = 'SET'
***       type    = 'BODY'
**        WINDOW  = 'MAIN'.
**  ELSE.
*    IF U EQ 1.
*
*      TEXT2 = SPACE.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'TESTLINE1'
**         function = 'SET'
**         type    = 'BODY'
*          WINDOW  = 'MAIN'.
*
*    ELSEIF U EQ 2.
*
*      TEXT2 = SPACE.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'TESTLINE2'
**         function = 'SET'
**         type    = 'BODY'
*          WINDOW  = 'MAIN'.
*
*    ELSEIF B EQ 1.
*      TEXT2 = SPACE.
**    if bl1 eq 1.
**      call function 'WRITE_FORM'
**        exporting
**          element = 'TESTBOLD'
***         function = 'SET'
***         type    = 'BODY'
**          window  = 'MAIN'.
**    else.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'TESTNEW'
**         function = 'SET'
**         type    = 'BODY'
*          WINDOW  = 'MAIN'.
**    endif.
*
*
*    ELSE.
*      IF A EQ 1.
*        IF A1 EQ 1.
*
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'TESTCONT1'
**             function = 'SET'
**             type    = 'BODY'
*              WINDOW  = 'MAIN'.
*
*        ELSE.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'TESTCONT'
**             function = 'SET'
**             type    = 'BODY'
*              WINDOW  = 'MAIN'.
*        ENDIF.
*      ELSE.
*        IF BLD2 EQ '1'.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'TESTBOLD'
**             function = 'SET'
**             type    = 'BODY'
*              WINDOW  = 'MAIN'.
*        ELSE.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'TEST'
**             function = 'SET'
**             type    = 'BODY'
*              WINDOW  = 'MAIN'.
*        ENDIF.
*      ENDIF.
*    ENDIF.
**  IF U EQ 1.
**    CALL FUNCTION 'WRITE_FORM'
**      EXPORTING
**        ELEMENT = 'TESTLINE'
***       function = 'SET'
***       type    = 'BODY'
**        WINDOW  = 'MAIN'.
**  ENDIF.
**  ENDIF.
*
**  IF TEXT2+72(1) EQ '-'.
**    A = 1.
**  ELSE.
**    A = 0.
**  ENDIF.
*    A = C.
*    A1 = D.
*    BLD2 = BLD1.
*  ENDLOOP.
  CONDENSE : text2.
*,w_itextb.
*concatenate w_itexta w_itextb into w_itext1 separated by space.
*condense w_itext1.

***********CODE ABOVE THIS****************
*IF MATNR CS 'H'.
*ELSE.
*  PACK MATNR TO MATNR.
*  CONDENSE MATNR.
*ENDIF.
  IF sy-ucomm EQ 'PRNT'.
*  MESSAGE 'PRINTOUT' TYPE 'I'.
  ELSE.
    SELECT SINGLE * FROM zqc_fg_sheet WHERE prueflos EQ insp AND matnr EQ matnr AND charg EQ charg AND printed EQ 'X'.
    IF sy-subrc EQ 0.
      MESSAGE 'PRINT HAS BEEN ALREDAY TAKEN, TO REPRINT NEED APPROVAL' TYPE 'I'.
    ENDIF.
  ENDIF.

*CONCATENATE 'ZINSP' '_' MATNR INTO FORMNM.
  CLEAR : a.

*CALL FUNCTION 'WRITE_FORM'
*  EXPORTING
*    ELEMENT = 'TEST'
**   function = 'SET'
**   type    = 'BODY'
*    WINDOW  = 'MAIN'.
*
*CALL FUNCTION 'WRITE_FORM'
*  EXPORTING
*    ELEMENT = 'DESC'
**   function = 'SET'
**   type    = 'BODY'
*    WINDOW  = 'MAIN'.
*
*CALL FUNCTION 'WRITE_FORM'
*  EXPORTING
*    ELEMENT = 'IDEN'
**   function = 'SET'
**   type    = 'BODY'
*    WINDOW  = 'MAIN'.
*LOOP AT IT_QAMV INTO WA_QAMV.
*  CLEAR : TEST.
*  TEST = WA_QAMV-VERWMERKM.
*
*  CALL FUNCTION 'WRITE_FORM'
*    EXPORTING
*      ELEMENT                  = TEST
**     function                 = 'SET'
**     type                     = 'BODY'
*      WINDOW                   = 'MAIN'
*    EXCEPTIONS
*      ELEMENT                  = 1
*      FUNCTION                 = 2
*      TYPE                     = 3
*      UNOPENED                 = 4
*      UNSTARTED                = 5
*      WINDOW                   = 6
*      BAD_PAGEFORMAT_FOR_PRINT = 7
*      SPOOL_ERROR              = 8
*      CODEPAGE                 = 9
*      OTHERS                   = 10.
*  CASE SY-SUBRC.
*    WHEN 1.
**            message e184(bctrain) with 'OTHER USER ALREADY PROCESSING, PLZ TRY AFTER SOME TIME' .
**            MESSAGE 'OTHER USER ALREADY PROCESSING, PLZ TRY AFTER SOME TIME' TYPE 'E'.
**      MESSAGE I000(0U) WITH SY-MSGV1.
*    WHEN 2.
**      MESSAGE I184(BCTRAIN) WITH 'system failure'.
*    WHEN 0.
**            message i184(bctrain) with 'success'.
*    WHEN OTHERS.
**      MESSAGE I184(BCTRAIN) WITH 'others'.
*  ENDCASE.
**  BREAK-POINT.
**  IF SY-SUBRC <> 0.
*** Implement suitable error handling here
**
**  ENDIF.
*
*
****************************
*
*
******************************
*
*ENDLOOP.
*  CALL FUNCTION 'WRITE_FORM'
*    EXPORTING
*      ELEMENT = 'ENDTEST'
**     function = 'SET'
**     type    = 'BODY'
*      WINDOW  = 'MAIN'.

*  IF sy-ucomm EQ 'PRNT'.
*  IF REPRINT EQ 'X'.
*    SELECT SINGLE * FROM ZQC_FG_SHEET WHERE PRUEFLOS EQ INSP.
*    IF SY-SUBRC EQ 0.
*      MOVE-CORRESPONDING ZQC_FG_SHEET TO ZQC_FG_SHEET_WA.
*      ZQC_FG_SHEET_WA-REPRINT = PERNR.
*      ZQC_FG_SHEET_WA-REPRDT = SY-DATUM.
*      MODIFY ZQC_FG_SHEET FROM ZQC_FG_SHEET_WA.
*      COMMIT WORK AND WAIT .
*      CLEAR : ZQC_FG_SHEET_WA.
*    ELSE.
*      MESSAGE 'NO DATA FOUND' TYPE 'E'.
*    ENDIF.
*
*  ELSE.
**      IF PREVIEW NE 'X'.
*    SELECT SINGLE * FROM ZQC_FG_SHEET WHERE PRUEFLOS EQ INSP.
*    IF SY-SUBRC EQ 4.
*      ZQC_FG_SHEET_WA-PRUEFLOS = INSP.
*      ZQC_FG_SHEET_WA-MATNR = MATNR.
*      ZQC_FG_SHEET_WA-VERSION = VER.
*      ZQC_FG_SHEET_WA-CHARG = CHARG.
*      ZQC_FG_SHEET_WA-PRINTDT = SY-DATUM.
*      ZQC_FG_SHEET_WA-USNAM = SY-UNAME.
*      ZQC_FG_SHEET_WA-CPUTM = SY-UZEIT.
*      ZQC_FG_SHEET_WA-NAME = NAME.
*      ZQC_FG_SHEET_WA-PRINTED = 'X'.
*      ZQC_FG_SHEET_WA-SAMBY = SNAME.
*      ZQC_FG_SHEET_WA-SAMPDT = SAMPDT.
*      MODIFY ZQC_FG_SHEET FROM ZQC_FG_SHEET_WA.
*      COMMIT WORK AND WAIT .
*      CLEAR : ZQC_FG_SHEET_WA.
*    ENDIF.
**      ENDIF.
*  ENDIF.
*  ENDIF.
*  IF A NE 1.
*    CALL FUNCTION 'CLOSE_FORM'
**   IMPORTING
**     RESULT                         =
**     RDI_RESULT                     =
**   TABLES
**     OTFDATA                        =
**   EXCEPTIONS
**     UNOPENED                       = 1
**     BAD_PAGEFORMAT_FOR_PRINT       = 2
**     SEND_ERROR                     = 3
**     SPOOL_ERROR                    = 4
**     CODEPAGE                       = 5
**     OTHERS                         = 6
*      .
*    IF SY-SUBRC <> 0.
** Implement suitable error handling here
*    ENDIF.
*  ENDIF.



*  ****************call smartforms******************

  PERFORM prtform.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  INSP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  PROD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM product.
  CLEAR : i1.
  IF reprint EQ 'X'.
    i1 = 'A'.
  ENDIF.

  insp = space.
  udate = space.
  batchsz = space.
  batchuom = space.

  matnr = fgcode.
  werks = p_plant.
  SELECT SINGLE * FROM t001w WHERE werks EQ werks.
  IF sy-subrc EQ 0.
    IF werks EQ '1000'.
      kunnr = t001w-ort01.
    ELSE.
      kunnr = t001w-kunnr.
    ENDIF.
  ENDIF.
  CLEAR : ads,adsmatnr.
  adsmatnr = matnr.
  IF adsmatnr CS 'H'.
  ELSE.
    PACK adsmatnr TO adsmatnr.
  ENDIF.
  CONDENSE adsmatnr.
  IF r3 EQ 'X'.
    CONCATENATE 'ADS/' adsmatnr '/U' INTO ads.
  ELSEIF r2 EQ 'X'.
    CONCATENATE 'ADS/' adsmatnr INTO ads.
  ENDIF.
  CONDENSE ads.

*   SELECT SINGLE * FROM ZQC_FG_SHEET WHERE PRUEFLOS EQ INSP AND PRINTED EQ 'X'.
*  IF SY-SUBRC EQ 0.
*    MESSAGE 'PRINT IS ALREADY TAKEN ' TYPE 'E'.
*  ENDIF.

  CLEAR : ver,effdt.
  CLEAR : vern1.
  IF r2 EQ 'X'.
    SELECT * FROM zfginsp INTO TABLE it_zfginsp WHERE matnr EQ matnr AND werks EQ werks.
    SORT it_zfginsp DESCENDING BY version.
    READ TABLE it_zfginsp INTO wa_zfginsp WITH KEY matnr = matnr .
    IF sy-subrc EQ 0.
      vern1 = wa_zfginsp-version.
      SHIFT wa_zfginsp-version LEFT DELETING LEADING '0'.
      ver = wa_zfginsp-version.
      UNPACK ver TO ver.
      effdt = wa_zfginsp-budat.
    ENDIF.
  ELSEIF r3 EQ 'X'.
    SELECT * FROM zfginspc INTO TABLE it_zfginspc WHERE matnr EQ matnr AND werks EQ werks.
    SORT it_zfginspc DESCENDING BY version.
    READ TABLE it_zfginspc INTO wa_zfginspc WITH KEY matnr = matnr.
    IF sy-subrc EQ 0.
      vern1 = wa_zfginspc-version.
      SHIFT wa_zfginspc-version LEFT DELETING LEADING '0'.
      ver = wa_zfginspc-version.
      UNPACK ver TO ver.
      effdt = wa_zfginspc-budat.
    ENDIF.
  ELSEIF r21 EQ 'X'.
    SELECT * FROM zfginspr INTO TABLE it_zfginspr WHERE matnr EQ matnr AND werks EQ werks.
    SORT it_zfginspr DESCENDING BY version.
    READ TABLE it_zfginspr INTO wa_zfginspr WITH KEY matnr = matnr.
    IF sy-subrc EQ 0.
      vern1 = wa_zfginspr-version.
      SHIFT wa_zfginspr-version LEFT DELETING LEADING '0'.
      ver = wa_zfginspr-version.
      UNPACK ver TO ver.
      effdt = wa_zfginspr-budat.
    ENDIF.
  ENDIF.

***  MATNR = MATNR.
*    ENSTEHDAT = WA_QALS-ENSTEHDAT.
  SELECT SINGLE  * FROM mara WHERE matnr EQ matnr.
  IF sy-subrc EQ 0.
    mtart = mara-mtart.
  ENDIF.

  IF mtart EQ 'ZROH'.
    CLEAR : maktx1,maktx2,maktx,normt.
    SELECT SINGLE * FROM makt WHERE matnr EQ matnr AND spras EQ 'EN'.
    IF sy-subrc EQ 0.
      maktx1 = makt-maktx.
    ENDIF.
    SELECT SINGLE * FROM makt WHERE matnr EQ matnr AND spras EQ 'Z1'.
    IF sy-subrc EQ 0.
      maktx2 = makt-maktx.
    ENDIF.
    SELECT SINGLE * FROM mara WHERE matnr EQ matnr.
    IF sy-subrc EQ 0.
      normt = mara-normt.
    ENDIF.
    CONCATENATE maktx1 maktx2 normt INTO maktx SEPARATED BY space.
  ELSE.
    CLEAR : maktx1,maktx2,maktx,normt.
    SELECT SINGLE * FROM makt WHERE matnr EQ matnr AND spras EQ 'EN'.
    IF sy-subrc EQ 0.
      maktx1 = makt-maktx.
    ENDIF.
    SELECT SINGLE * FROM makt WHERE matnr EQ matnr AND spras EQ 'Z1'.
    IF sy-subrc EQ 0.
      maktx2 = makt-maktx.
    ENDIF.

    CONCATENATE maktx1 maktx2 INTO maktx SEPARATED BY space.

*    SELECT SINGLE * FROM makt WHERE matnr EQ matnr AND spras EQ 'EN'.
*    IF sy-subrc EQ 0.
*      maktx = makt-maktx.
*    ENDIF.
  ENDIF.
  CONDENSE maktx.
  IF r2 EQ 'X'.
    SELECT * FROM zqspecification INTO TABLE it_zqspecification WHERE matnr EQ matnr AND werks EQ werks.
  ELSEIF r3 EQ 'X'.
    SELECT * FROM zqspecificationc INTO TABLE it_zqspecificationc WHERE matnr EQ matnr AND werks EQ werks.
  ENDIF.
  SORT it_zqspecification DESCENDING BY revision.
  SORT it_zqspecificationc DESCENDING BY revision.
  CLEAR : specf, shelflife. "specification number &shelf life.
  IF r2 EQ 'X' OR r21 EQ 'X'.  "R21 ADDDE ON 5.12.24
    READ TABLE it_zqspecification INTO wa_zqspecification WITH KEY matnr = matnr werks = werks.
    IF sy-subrc EQ 0.
      specf = wa_zqspecification-specification.
      shelflife = wa_zqspecification-shelflife.
      pack = wa_zqspecification-pack.
      CONDENSE pack.
    ENDIF.
  ELSEIF r3 EQ 'X'.
    READ TABLE it_zqspecificationc INTO wa_zqspecificationc WITH KEY matnr = matnr werks = werks.
    IF sy-subrc EQ 0.
      specf = wa_zqspecificationc-specification.
      shelflife = wa_zqspecificationc-shelflife.
      pack = wa_zqspecificationc-pack.
      CONDENSE pack.
    ENDIF.
  ENDIF.
************************************************************************************************************
*  IF REPRINT NE 'X'.
*    IF R2 EQ 'X'.
*      SELECT SINGLE * FROM ZQC_FG_SHEET WHERE PRUEFLOS EQ '000000000000' AND MATNR EQ MATNR AND VERSION EQ VER.
**  AND PRINTED EQ 'X'.
*      IF SY-SUBRC EQ 0.
*        MESSAGE 'PRINT ALREADY TAKEN' TYPE 'E'.
*      ENDIF.
*    ELSEIF R3 EQ 'X'.
*      SELECT SINGLE * FROM ZQC_FG_SHEET WHERE PRUEFLOS EQ '111111111111' AND MATNR EQ MATNR AND VERSION EQ VER.
**  AND PRINTED EQ 'X'.
*      IF SY-SUBRC EQ 0.
*        MESSAGE 'PRINT ALREADY TAKEN' TYPE 'E'.
*      ENDIF.
*    ENDIF.
*  ENDIF.
  IF reprint NE 'X'.

    IF preview NE 'X' .
      IF upload EQ 'X'.
      ELSE.
        IF r2 EQ 'X'.
          SELECT SINGLE * FROM zqc_fg_sheet WHERE prueflos EQ '000000000000' AND matnr EQ matnr AND version EQ ver.
*  AND PRINTED EQ 'X'.
          IF sy-subrc EQ 0.
            MESSAGE 'PRINT ALREADY TAKEN' TYPE 'E'.
          ENDIF.
        ELSEIF r3 EQ 'X'.
          SELECT SINGLE * FROM zqc_fg_sheet WHERE prueflos EQ '111111111111' AND matnr EQ matnr AND version EQ ver.
*  AND PRINTED EQ 'X'.
          IF sy-subrc EQ 0.
            MESSAGE 'PRINT ALREADY TAKEN' TYPE 'E'.
          ENDIF.
        ELSEIF r21 EQ 'X'.
          SELECT SINGLE * FROM zqc_fg_sheet WHERE prueflos EQ '999999999999' AND matnr EQ matnr AND version EQ ver.
*  AND PRINTED EQ 'X'.
          IF sy-subrc EQ 0.
            MESSAGE 'PRINT ALREADY TAKEN' TYPE 'E'.
          ENDIF.
        ENDIF.
      ENDIF.


    ENDIF.
  ENDIF.

  IF reprint EQ 'X'.

*    uname = name.
*    udate = sy-datum.
*    uzeit = sy-uzeit.
*    usname = sname.

    SELECT SINGLE * FROM zqc_fg_sheet_q1 WHERE matnr EQ matnr AND cpudt EQ sy-datum.  "2.10.23
    IF sy-subrc EQ 0.
      uname = name.
      udate = zqc_fg_sheet_q1-budat.
      uzeit = zqc_fg_sheet_q1-cputm.
      usname = sname.

    ELSE.

      uname = name.
      udate = sy-datum.
      uzeit = sy-uzeit.
      usname = sname.
    ENDIF.

  ELSE.

    IF r2 EQ 'X'.
      SELECT SINGLE * FROM zqc_fg_sheet WHERE prueflos EQ '000000000000' AND  matnr EQ matnr AND version EQ ver.
*  AND PRINTED EQ 'X'.
      IF sy-subrc EQ 0.
        uname = zqc_fg_sheet-name.
        udate = zqc_fg_sheet-printdt.
        uzeit = zqc_fg_sheet-cputm.
        usname = zqc_fg_sheet-samby.
      ELSE.
        uname = name.
        udate = sy-datum.
        uzeit = sy-uzeit.
        usname = sname.
      ENDIF.
    ELSEIF r3 EQ 'X'.
      SELECT SINGLE * FROM zqc_fg_sheet WHERE prueflos EQ '111111111111' AND  matnr EQ matnr AND version EQ ver.
*  AND PRINTED EQ 'X'.
      IF sy-subrc EQ 0.
        uname = zqc_fg_sheet-name.
        udate = zqc_fg_sheet-printdt.
        uzeit = zqc_fg_sheet-cputm.
        usname = zqc_fg_sheet-samby.
      ELSE.
        uname = name.
        udate = sy-datum.
        uzeit = sy-uzeit.
        usname = sname.
      ENDIF.

    ELSEIF r21 EQ 'X'.
      SELECT SINGLE * FROM zqc_fg_sheet WHERE prueflos EQ '999999999999' AND  matnr EQ matnr AND version EQ ver.
*  AND PRINTED EQ 'X'.
      IF sy-subrc EQ 0.
        uname = zqc_fg_sheet-name.
        udate = zqc_fg_sheet-printdt.
        uzeit = zqc_fg_sheet-cputm.
        usname = zqc_fg_sheet-samby.
      ELSE.
        uname = name.
        udate = sy-datum.
        uzeit = sy-uzeit.
        usname = sname.
      ENDIF.
    ENDIF.
  ENDIF.
  usname1 = usname.


***********************************************************************************************************
  CLEAR : format.
  SELECT SINGLE * FROM mara WHERE matnr EQ matnr.
  IF sy-subrc EQ 0.
    mtart = mara-mtart.
    IF mara-mtart EQ 'ZHLB'.
      IF r2 EQ 'X'.
        SELECT SINGLE * FROM qmat WHERE matnr EQ matnr AND art EQ '89'.
        IF sy-subrc EQ 0.
          IF werks EQ '1000'.
*            format1 = 'Format No.: SOP/QC/060-00-F4'.
            IF reprint EQ 'X'.
              format1 = 'Format No.: SOP/QC/060-F11'.
            ELSE.
              format1 = 'Format No.: SOP/QC/060-F4'.
            ENDIF.
          ENDIF.
          text1 = 'Bulk Product Analytical Data Sheet (Coated Tablet)'.
        ELSE.
          IF werks EQ '1000'.
*            format1 = 'Format No.: SOP/QC/060-00-F3'.
            IF reprint EQ 'X'.
              format1 = 'Format No.: SOP/QC/060-F10'.  "5.3.23
            ELSE.
              format1 = 'Format No.: SOP/QC/060-F3'.  "5.3.23
            ENDIF.
          ENDIF.
          text1 = 'Bulk Product Analytical Data Sheet'.
        ENDIF.
      ELSEIF r3 EQ 'X'.
        IF werks EQ '1000'.
*          format1 = 'Format No.: SOP/QC/060-00-F2'.
          IF reprint EQ 'X'.
            format1 = 'Format No.: SOP/QC/060-F9'.  "5.3.23
          ELSE.
            format1 = 'Format No.: SOP/QC/060-F2'.  "5.3.23
          ENDIF.
        ENDIF.

        text1 = 'Bulk Product Analytical Data Sheet (Uncoated Tablet)'.
*        TEXT1 = 'Coated Product Analytical Data Sheet'.
      ENDIF.
    ELSEIF mara-mtart EQ 'ZROH'.
      IF werks EQ '1000'.
        IF r2 EQ 'X'.
*          FORMAT1 = 'Format No.: SOP/QC/060-F14'.
*          FORMAT1 = 'Format No.: SOP/QC/060-F24'. "10.12.24
          IF reprint EQ 'X'.
            format1 = 'Format No.: SOP/QC/060-F24'. "17.4.25
          ELSE.
            format1 = 'Format No.: SOP/QC/060-F14'. "17.4.25
          ENDIF.
        ELSEIF r21 EQ 'X'.
*          FORMAT1 = 'Format No.: SOP/QC/060-F16'.
*          format1 = 'Format No.: SOP/QC/060-F25'.  "10.12.24
          IF reprint EQ 'X'.
            format1 = 'Format No.: SOP/QC/060-F25'.  "17.4.25
          ELSE.
            format1 = 'Format No.: SOP/QC/060-F16'.  "17.4.25
          ENDIF.
        ENDIF.
      ENDIF.
      IF r21 EQ 'X'.
        text1 = 'Raw Material Analytical Data Sheet (Retest)'.
      ELSE.
        text1 = 'Raw Material Analytical Data Sheet'.
      ENDIF.
    ELSEIF mara-mtart EQ 'ZVRP'.
      IF r21 EQ 'X'.
        text1 = 'Packing Material Analytical Data Sheet (Retest)'.
      ELSE.
        text1 = 'Packing Material Analytical Data Sheet'.
      ENDIF.
      IF reprint EQ 'X'.
        format1 = 'Format No.: SOP/QC/060-F27'.  "17.4.25
      ENDIF.
    ELSEIF mara-mtart EQ 'ZRQC'.
      IF werks EQ '1000'.
        IF r2 EQ 'X'.
*          FORMAT1 = 'Format No.: SOP/QC/060-F18'.
*          format1 = 'Format No.: SOP/QC/060-F26'.  "10.12.24
          IF reprint EQ 'X'.
            format1 = 'Format No.: SOP/QC/060-F26'.  "17.4.25
          ELSE.
            format1 = 'Format No.: SOP/QC/060-F18'.  "17.4.25
          ENDIF.
        ENDIF.
      ELSEIF werks EQ '1001'.
        format1 = 'Format No.: QC/GM/099-F12'.  "17.5.25
      ENDIF.
      IF r21 EQ 'X'.
        text1 = 'Ancillary Material Analytical Data Sheet (Retest)'.
      ELSE.
        text1 = 'Ancillary Material Analytical Data Sheet'.
      ENDIF.
    ELSE.
*         MARA-MTART EQ 'ZFRT'.

      text1 = 'Finished Product Analytical Data Sheet'.

    ENDIF.
*    IF mara-mtart EQ 'ZFRT'.
*      text1 = 'Finished Product Analytical Data Sheet'.
*    ELSEIF mara-mtart EQ 'ZHLB'.
*      text1 = 'Semifinished Product Analytical Data Sheet'.
*    ENDIF.
  ENDIF.

  CLEAR : q1.
  IF reprint EQ 'X'.
    SELECT SINGLE * FROM zqc_fg_sheet_r WHERE prueflos EQ insp AND budat EQ sy-datum.
    IF sy-subrc EQ 0.
    ELSE.
      CONCATENATE text1 '(QA COPY)' INTO text1 SEPARATED BY space.
      q1 = 'Y'.
    ENDIF.
  ENDIF.

  IF werks EQ '1001'.
    IF mtart EQ 'ZHLB'.
      format1 = 'Format No.: QC/GM/099-F10'.
      IF reprint EQ 'X'.
        format1 = 'Format No.: QC/GM/099-F20'.
      ENDIF.
*       FORMAT1 = '11'.
    ELSEIF mtart EQ 'ZFRT' OR mtart EQ 'ZDSM' OR mtart EQ 'ZESC' OR mtart EQ 'ZESM'.
      format1 = 'Format No.: QC/GM/099-F1'.
      IF reprint EQ 'X'.
        format1 = 'Format No.: QC/GM/099-F16'.
      ENDIF.
*      IF mtart EQ 'ZFRT'.
*      format1 = 'Format no.: QC/GM/099-F1'.
    ENDIF.
  ELSEIF werks EQ '1000'.
    IF mtart EQ 'ZHLB'.
*      FORMAT1 = 'Format No.: SOP/QC/060-00-F3'.

*       FORMAT1 = '11'.
    ELSEIF mtart EQ 'ZFRT' OR mtart EQ 'ZDSM' OR mtart EQ 'ZESC' OR mtart EQ 'ZESM'.
*      format1 = 'Format No.: SOP/QC/060-00-F1'.
      format1 = 'Format No.: SOP/QC/060-F1'.  "5.3.23
      IF reprint EQ 'X'.
*        select single * from zqc_fg_sheet_r where prueflos eq insp and budat eq sy-datum.
*        if sy-subrc eq 4.
        format1 = 'Format No.: SOP/QC/060-F12'.  "5.3.23
*        endif.
      ENDIF.

*      IF mtart EQ 'ZFRT'.
*      format1 = 'Format no.: QC/GM/099-F1'.
    ENDIF.

  ENDIF.




*    SELECT SINGLE * FROM MCHA WHERE MATNR EQ WA_QALS-MATNR AND WERKS EQ WA_QALS-WERK AND CHARG EQ WA_QALS-CHARG.
*    IF SY-SUBRC EQ 0.
*      HSDAT = MCHA-HSDAT.
*      VFDAT = MCHA-VFDAT.
*      WERKS = WA_QALS-WERK.
*    ENDIF.
*    MJAHR = WA_QALS-PAENDTERM.
*    MJAHR1 = MJAHR + 1.
*  ENDLOOP.


*  select single * from mvke where matnr eq matnr and vkorg eq '1000' and vtweg eq '10'.
*  if sy-subrc eq 0.
*    select single * from tvm5t where spras eq 'EN' and mvgr5 eq mvke-mvgr5.
*    if sy-subrc eq 0.
*      pack = tvm5t-bezei.
*    endif.
*  else.
*    select single * from mvke where matnr eq matnr and vkorg eq '1000' and vtweg eq '80'.
*    if sy-subrc eq 0.
*      select single * from tvm5t where spras eq 'EN' and mvgr5 eq mvke-mvgr5.
*      if sy-subrc eq 0.
*        pack = tvm5t-bezei.
*      endif.
*    else.
*      select single * from mvke where matnr eq matnr and vkorg eq '2000' and vtweg eq '20'.
*      if sy-subrc eq 0.
*        select single * from tvm5t where spras eq 'EN' and mvgr5 eq mvke-mvgr5.
*        if sy-subrc eq 0.
*          pack = tvm5t-bezei.
*        endif.
*      endif.
*    endif.
*  endif.
*

*  IF PACK CS 'ML' .
  packtxt = 'Pack Size'.
*  ELSEIF PACK CS 'L' .
*    PACKTXT = 'Pack Size:'.
*  ELSE.
*    PACKTXT = 'No. of tabs/ Strip:'.
*  ENDIF.


*IF MATNR CS 'H'.
*ELSE.
*  PACK MATNR TO MATNR.
*  CONDENSE MATNR.
*ENDIF.
  SELECT * FROM afpo INTO TABLE it_afpo WHERE dwerk EQ werks AND charg EQ charg .
  LOOP AT it_afpo INTO wa_afpo WHERE matnr CS 'H'.
*    BATCHSZ = WA_AFPO-PSMNG.
*    BATCHUOM = WA_AFPO-MEINS.
    EXIT.
  ENDLOOP.

  SELECT SINGLE * FROM a602 WHERE kschl EQ 'Z001' AND vkorg EQ '1000' AND matnr EQ matnr AND charg EQ charg AND datbi GT sy-datum.
  IF sy-subrc EQ 0.
    SELECT SINGLE * FROM konp WHERE knumh EQ a602-knumh AND kschl EQ 'Z001' .
    IF sy-subrc EQ 0.
      mrp = konp-kbetr.
    ENDIF.
  ELSE.
    SELECT SINGLE * FROM a602 WHERE kschl EQ 'Z001' AND vkorg EQ '2000' AND matnr EQ matnr AND charg EQ charg AND datbi GT sy-datum.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM konp WHERE knumh EQ a602-knumh AND kschl EQ 'Z001' .
      IF sy-subrc EQ 0.
        mrp = konp-kbetr.
      ENDIF.
    ENDIF.
  ENDIF.

  SELECT SINGLE * FROM mara WHERE matnr EQ matnr AND mtart IN ('ZDSM','ZESM').
  IF sy-subrc EQ 0.
    mrp = 0.
  ENDIF.

****************SAMPLE REMOVAL************
  SELECT SINGLE * FROM mseg WHERE mjahr  EQ mjahr AND bwart EQ '344' AND matnr EQ matnr AND lgort EQ 'CSM' AND charg EQ charg.
  IF sy-subrc EQ 0.
    sampqty = mseg-menge.
    sqtyuom = mseg-meins.
  ENDIF.
  num = matnr.
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
*     CLIENT                  = SY-MANDT
      id                      = 'PRUE'
      language                = 'E'
      name                    = num
      object                  = 'MATERIAL'
*     ARCHIVE_HANDLE          = 0
*                  IMPORTING
*     HEADER                  =
    TABLES
      lines                   = mmline2
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.



  CLEAR : r11.
  LOOP AT mmline2.
    IF sy-tabix EQ 1.
      MOVE mmline2-tdline TO w_itexta1.
    ELSEIF sy-tabix EQ 2.
      MOVE mmline2-tdline TO w_itexta2.
    ENDIF.
    IF sy-tabix LE 2.
*  move mmline2-tdline to w_itexta.
      MOVE mmline2-tdline TO r11.
      CONCATENATE w_itexta r11  INTO w_itexta SEPARATED BY space.
*  elseif sy-tabix eq 2.
*    move mmline2-tdline to w_itextb.
*  else.
*    move mmline2-tdline to w_itext2.
*    concatenate s3 w_itext2 into s3 separated by space.
*  endif.
*    WRITE :  / 'LR',LRNO.
*  exit.
    ENDIF.
  ENDLOOP.
  CONDENSE : w_itexta,w_itexta1,w_itexta2.

*********** label claim****************

*  IF REPRINT EQ 'X'.
*
*    CALL FUNCTION 'OPEN_FORM'
*      EXPORTING
*        DEVICE                      = 'PRINTER'
**       DIALOG                      = 'X'
*        FORM                        = 'ZFGINSP1'
**       FORM                        = FORMNM
**       FORM                        = 'ZRMRESTREP_8'
*      EXCEPTIONS
*        CANCELED                    = 1
*        DEVICE                      = 2
*        FORM                        = 3
*        OPTIONS                     = 4
*        UNCLOSED                    = 5
*        MAIL_OPTIONS                = 6
*        ARCHIVE_ERROR               = 7
*        INVALID_FAX_NUMBER          = 8
*        MORE_PARAMS_NEEDED_IN_BATCH = 9
*        SPOOL_ERROR                 = 10
*        CODEPAGE                    = 11
*        OTHERS                      = 12.
*    IF SY-SUBRC <> 0.
*    ENDIF.
*
*  ELSE.

*  IF PREVIEW EQ 'X'.
*    ITCPO-TDPREVIEW = ''.
*    ITCPO-TDNOPRINT = 'X'.
*    ITCPO-TDPREVIEW = 'X'.
*
*    CALL FUNCTION 'OPEN_FORM'
*      EXPORTING
*        DEVICE                      = 'PRINTER'
*        DIALOG                      = 'X'
**       OPTIONS                     = OPTIONS
*        OPTIONS                     = ITCPO
**       TDPREVIEW                   = 'X'
**       FORM                        = 'ZFGINSP1_N5'
*        FORM                        = 'ZFGINSP1_N7_1'
**       FORM                        = FORMNM
**       FORM                        = 'ZRMRESTREP_8'
*      EXCEPTIONS
*        CANCELED                    = 1
*        DEVICE                      = 2
*        FORM                        = 3
*        OPTIONS                     = 4
*        UNCLOSED                    = 5
*        MAIL_OPTIONS                = 6
*        ARCHIVE_ERROR               = 7
*        INVALID_FAX_NUMBER          = 8
*        MORE_PARAMS_NEEDED_IN_BATCH = 9
*        SPOOL_ERROR                 = 10
*        CODEPAGE                    = 11
*        OTHERS                      = 12.
*    IF SY-SUBRC <> 0.
*    ENDIF.
*
*  ELSE.
*
*    ITCPO-TDNOPREV = 'X'.
*
*    ITCPO-TDIMMED = 'X'.
*    ITCPO-TDDELETE = 'X'.
*
*    CALL FUNCTION 'OPEN_FORM'
*      EXPORTING
*        DEVICE                      = 'PRINTER'
*        DIALOG                      = 'X'
**       OPTIONS                     = OPTIONS
*        OPTIONS                     = ITCPO
**       TDPREVIEW                   = 'X'
**       FORM                        = 'ZFGINSP1_N5'
*        FORM                        = 'ZFGINSP1_N7_1'
**       FORM                        = FORMNM
**       FORM                        = 'ZRMRESTREP_8'
*      EXCEPTIONS
*        CANCELED                    = 1
*        DEVICE                      = 2
*        FORM                        = 3
*        OPTIONS                     = 4
*        UNCLOSED                    = 5
*        MAIL_OPTIONS                = 6
*        ARCHIVE_ERROR               = 7
*        INVALID_FAX_NUMBER          = 8
*        MORE_PARAMS_NEEDED_IN_BATCH = 9
*        SPOOL_ERROR                 = 10
*        CODEPAGE                    = 11
*        OTHERS                      = 12.
*    IF SY-SUBRC <> 0.
*    ENDIF.
*
*  ENDIF.


  IF sy-ucomm EQ 'PRNT'.
*    IF REPRINT NE 'X' .
    IF print EQ 'X'.
      IF r3 EQ 'X'.
        SELECT SINGLE * FROM zqc_fg_sheet WHERE prueflos EQ '111111111111' AND matnr EQ matnr AND version EQ ver AND printed EQ 'X'.
        IF sy-subrc EQ 0.
          MESSAGE 'PRINT HAS BEEN ALREDAY TAKEN, TO REPRINT NEED APPROVAL' TYPE 'E'.
          a = 1.
*        EXIT.
        ENDIF.
      ELSEIF r21 EQ 'X'.
        SELECT SINGLE * FROM zqc_fg_sheet WHERE prueflos EQ '999999999999' AND matnr EQ matnr AND version EQ ver AND printed EQ 'X'.
        IF sy-subrc EQ 0.
          MESSAGE 'PRINT HAS BEEN ALREDAY TAKEN, TO REPRINT NEED APPROVAL' TYPE 'E'.
          a = 1.
*        EXIT.
        ENDIF.
      ELSE.
        SELECT SINGLE * FROM zqc_fg_sheet WHERE prueflos EQ '000000000000' AND matnr EQ matnr AND version EQ ver AND printed EQ 'X'.
        IF sy-subrc EQ 0.
          MESSAGE 'PRINT HAS BEEN ALREDAY TAKEN, TO REPRINT NEED APPROVAL' TYPE 'E'.
          a = 1.
*        EXIT.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

  IF r2 EQ 'X'.
    SELECT SINGLE * FROM qinf WHERE matnr EQ matnr AND lieferant EQ vendor AND werk EQ p_plant.
    IF sy-subrc EQ 0.
      matnr1 = qinf-matnr.
      IF matnr1 CS 'H'.
        s1 = strlen( matnr1 ).
*        WRITE : S1.
        IF s1 EQ 6.
          a2 = '            '.
          CONCATENATE matnr1 qinf-zaehl INTO num SEPARATED BY a2.
        ELSEIF s1 EQ 9.
          a3 = '         '.
          CONCATENATE matnr1 qinf-zaehl INTO num SEPARATED BY a3.
        ELSEIF s1 EQ 7.
          a4 = '           '.
          CONCATENATE matnr1 qinf-zaehl INTO num SEPARATED BY a4.
        ENDIF.
      ELSE.
        a5 = '                      '.
        CONCATENATE qinf-matnr qinf-zaehl INTO num SEPARATED BY a5.
      ENDIF.
    ENDIF.

*    NUM = '000000000000041007000001'.
*
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
*       CLIENT                  = SY-MANDT
        id                      = 'QINF'
        language                = 'E'
        name                    = num
        object                  = 'QINF'
*       ARCHIVE_HANDLE          = 0
*                  IMPORTING
*       HEADER                  =
      TABLES
        lines                   = mmline1
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

***    CALL FUNCTION 'READ_TEXT'
***      EXPORTING
****       CLIENT                  = SY-MANDT
***        id                      = 'IVER'
***        language                = 'E'
***        name                    = num
***        object                  = 'MATERIAL'
****       ARCHIVE_HANDLE          = 0
****                  IMPORTING
****       HEADER                  =
***      TABLES
***        lines                   = mmline1
***      EXCEPTIONS
***        id                      = 1
***        language                = 2
***        name                    = 3
***        not_found               = 4
***        object                  = 5
***        reference_check         = 6
***        wrong_access_to_archive = 7
***        OTHERS                  = 8.
***    IF sy-subrc <> 0.
**** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
****         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
***    ENDIF.


  ELSEIF r3 EQ 'X'.

    SELECT SINGLE * FROM qinf WHERE matnr EQ matnr AND lieferant EQ 'BCL1000' AND werk EQ p_plant.             "Changed by Vinayak S. A3000 => BCL1000
    IF sy-subrc EQ 0.
      matnr1 = qinf-matnr.
      IF matnr1 CS 'H'.
        s1 = strlen( matnr1 ).
*        WRITE : S1.
        IF s1 EQ 6.
          a2 = '            '.
          CONCATENATE matnr1 qinf-zaehl INTO num SEPARATED BY a2.
        ELSEIF s1 EQ 9.
          a3 = '         '.
          CONCATENATE matnr1 qinf-zaehl INTO num SEPARATED BY a3.
        ELSEIF s1 EQ 7.
          a4 = '           '.
          CONCATENATE matnr1 qinf-zaehl INTO num SEPARATED BY a4.
        ENDIF.
      ELSE.
        CONCATENATE matnr1 qinf-zaehl INTO num SEPARATED BY a5.  "Changes for RM retest
      ENDIF.
*      num = '000000000000100525000007'.
    ENDIF.

*    NUM = '000000000000041007000001'.
*
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
*       CLIENT                  = SY-MANDT
        id                      = 'QINF'
        language                = 'E'
        name                    = num
        object                  = 'QINF'
*       ARCHIVE_HANDLE          = 0
*                  IMPORTING
*       HEADER                  =
      TABLES
        lines                   = mmline1
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

  ELSEIF r21 EQ 'X'.

    SELECT SINGLE * FROM qinf WHERE matnr EQ matnr AND lieferant EQ 'BCL1000' AND werk EQ p_plant.            "Changed by Vinayak S. A3000 => BCL1000
    IF sy-subrc EQ 0.
      matnr1 = qinf-matnr.
      IF matnr1 CS 'H'.
*        S1 = STRLEN( MATNR1 ).
**        WRITE : S1.
*        IF S1 EQ 6.
*          A2 = '            '.
*          CONCATENATE MATNR1 QINF-ZAEHL INTO NUM SEPARATED BY A2.
*        ELSEIF S1 EQ 9.
*          A3 = '         '.
*          CONCATENATE MATNR1 QINF-ZAEHL INTO NUM SEPARATED BY A3.
*        ELSEIF S1 EQ 7.
*          A4 = '           '.
*          CONCATENATE MATNR1 QINF-ZAEHL INTO NUM SEPARATED BY A4.
*        ENDIF.
      ELSE.
        CONCATENATE matnr1 qinf-zaehl INTO num SEPARATED BY A5.  "Changes for RM retest
      ENDIF.
*      num = '000000000000100525000007'.
    ENDIF.

*    NUM = '000000000000041007000001'.
*
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
*       CLIENT                  = SY-MANDT
        id                      = 'QINF'
        language                = 'E'
        name                    = num
        object                  = 'QINF'
*       ARCHIVE_HANDLE          = 0
*                  IMPORTING
*       HEADER                  =
      TABLES
        lines                   = mmline1
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.


  ENDIF.

*CALL FUNCTION 'WRITE_FORM'
*  EXPORTING
*    ELEMENT = 'TEST'
**   function = 'SET'
**   type    = 'BODY'
*    WINDOW  = 'MAIN'.

*CALL FUNCTION 'WRITE_FORM'
*  EXPORTING
*    ELEMENT = 'DESC'
**   function = 'SET'
**   type    = 'BODY'
*    WINDOW  = 'MAIN'.
*
*CALL FUNCTION 'WRITE_FORM'
*  EXPORTING
*    ELEMENT = 'IDEN'
**   function = 'SET'
**   type    = 'BODY'
*    WINDOW  = 'MAIN'.
*  IF MTART EQ 'ZHLB'.
*    CALL FUNCTION 'WRITE_FORM'
*      EXPORTING
*        ELEMENT = 'TEST1H'
**       function = 'SET'
**       type    = 'BODY'
*        WINDOW  = 'MAIN'.
*  ELSEIF MTART EQ 'ZFRT' OR MTART EQ 'ZESC' OR MTART EQ 'ZDSM' OR MTART EQ 'ZESM'.
*    CALL FUNCTION 'WRITE_FORM'
*      EXPORTING
*        ELEMENT = 'TEST1F'
**       function = 'SET'
**       type    = 'BODY'
*        WINDOW  = 'MAIN'.
*  ELSEIF MTART EQ 'ZROH'.
*    CALL FUNCTION 'WRITE_FORM'
*      EXPORTING
*        ELEMENT = 'TEST1R1'
**       function = 'SET'
**       type    = 'BODY'
*        WINDOW  = 'MAIN'.
*  ELSE.
*    CALL FUNCTION 'WRITE_FORM'
*      EXPORTING
*        ELEMENT = 'TEST1'
**       function = 'SET'
**       type    = 'BODY'
*        WINDOW  = 'MAIN'.
*  ENDIF.
*

  CLEAR : ntxt1.
*  BREAK-POINT .
  PERFORM printcomm.
*  LOOP AT MMLINE1.
*    IF MMLINE1-TDLINE CS 'Reconciliation of Testing sample:'.
*      BREAK-POINT.
*    ENDIF.
*    IF MMLINE1-TDLINE CS 'Conclusion' .
*      BREAK-POINT.
*    ENDIF.
*
*    IF NTXT1 IS NOT INITIAL.
*
*      IF NTXT3 EQ 'A' .
*        CLEAR : NTXT2.
**      CONDENSE ntxt1 NO-GAPS.
*        REPLACE '-' WITH '' INTO NTXT1.
*        CONCATENATE NTXT1 MMLINE1-TDLINE INTO NTXT2.
*        MOVE NTXT2 TO WA_TXT1-TXT1.
*        WA_TXT1-TXT2 = 'L4'.
*        CLEAR : NTXT3.
*
*       ELSEIF NTXT3 EQ 'L' .
*        CLEAR : NTXT2.
**      CONDENSE ntxt1 NO-GAPS.
*        REPLACE '-' WITH '' INTO NTXT1.
*        CONCATENATE NTXT1 MMLINE1-TDLINE INTO NTXT2.
*        MOVE NTXT2 TO WA_TXT1-TXT1.
*        WA_TXT1-TXT2 = 'L3'.
*        CLEAR : NTXT3.
*
*      ELSEIF NTXT5 EQ 'A'.
*        CLEAR : NTXT2.
**      CONDENSE ntxt1 NO-GAPS.
*        REPLACE '-' WITH '' INTO NTXT1.
*        CONCATENATE NTXT1 MMLINE1-TDLINE INTO NTXT2.
*        MOVE NTXT2 TO WA_TXT1-TXT1.
*        WA_TXT1-TXT2 = 'L5'.
*        CLEAR : NTXT3,NTXT5.
*      ELSE.
*        CLEAR : NTXT2.
**      CONDENSE ntxt1 NO-GAPS.
*        REPLACE '-' WITH '' INTO NTXT1.
*        CONCATENATE NTXT1 MMLINE1-TDLINE INTO NTXT2.
*        MOVE NTXT2 TO WA_TXT1-TXT1.
*        WA_TXT1-TXT2 = 'L5'.
*      ENDIF.
*    ELSE.
*      MOVE MMLINE1-TDLINE TO WA_TXT1-TXT1.
*    ENDIF.
**********************************************************************
*
*    IF B1 EQ 'B1'.
*      WA_TXT1-TXT2 = 'B2'.
*      CLEAR : B1.
*    ELSEIF MMLINE1-TDLINE CS 'ULINE1' OR MMLINE1-TDLINE CS 'ULINE'.
*      WA_TXT1-TXT2 = 'L1'.
*      WA_TXT1-CNT = CNT.
*    ELSEIF MMLINE1-TDLINE+69(3) = '- -'.
*      WA_TXT1-TXT2 = 'L2'.
*      CLEAR : NTXT1,NTXT2.
*      NTXT1 = MMLINE1-TDLINE .
*      CONDENSE NTXT1.
*      CLEAR : NTXT5.
*      NTXT5 = 'A'.
*    ELSEIF MMLINE1-TDLINE+70(2) = ' - '.
*      WA_TXT1-TXT2 = 'L2'.
*      CLEAR : NTXT1,NTXT2.
*      NTXT1 = MMLINE1-TDLINE .
*      CONDENSE NTXT1.
*
*    ELSEIF MMLINE1-TDLINE+70(2) = '-S' OR MMLINE1-TDLINE+70(2) = '--'.
*      MMLINE1-TDLINE+70(2) = '  '.
*      WA_TXT1-TXT2 = 'L2'.
*      CLEAR : NTXT1,NTXT2.
*      NTXT1 = MMLINE1-TDLINE .
**      CONDENSE NTXT1.
*      NTXT3 = 'A'.
*    ELSEIF MMLINE1-TDLINE+70(2) = '-L'.
*      MMLINE1-TDLINE+70(2) = '  '.
*      WA_TXT1-TXT2 = 'L2'.
*      CLEAR : NTXT1,NTXT2.
*      NTXT1 = MMLINE1-TDLINE .
**      CONDENSE NTXT1.
*      NTXT3 = 'L'.
*    ELSEIF  WA_TXT1-TXT2 = 'L3'.
*      CLEAR : NTXT1,NTXT2.
*    ELSEIF  WA_TXT1-TXT2 = 'L4' OR WA_TXT1-TXT2 = 'L5'.
*      CLEAR : NTXT1,NTXT2.
*    ELSEIF  WA_TXT1-TXT1+0(8) = 'NEW-PAGE'.
*      WA_TXT1-TXT2 = 'N1'.
*    ELSEIF  WA_TXT1-TXT1+0(4) = 'BOLD'.
*      CLEAR : B1.
*      B1 = 'B1'.
*      WA_TXT1-TXT2 = B1.
*    ELSE.
*      WA_TXT1-TXT2 = SPACE.
*    ENDIF.
*
*    IF WA_TXT1-TXT2 EQ 'L2'.
*    ELSEIF WA_TXT1-TXT2 EQ 'B1'.
*    ELSE.
*
*      WA_TXT1-CNT = CNT.
*      COLLECT WA_TXT1 INTO IT_TXT1.
*      CLEAR WA_TXT1.
*    ENDIF.
*    CNT = CNT + 1.
*  ENDLOOP.
*  BREAK-POINT.
*    CLEAR : TEXT2,PG,B,C,U,D,BL1,BLD1,E1.
**  text3,text4.
**  if sy-tabix eq 1.
**  MOVE MMLINE21-TDLINE TO W_ITEXTA.
**  elseif sy-tabix eq 2.
**    move mmline2-tdline to w_itextb.
**  else.
*    MOVE MMLINE1-TDLINE TO W_ITEXT2.
*    CONCATENATE TEXT2 W_ITEXT2 INTO TEXT2 SEPARATED BY SPACE.
**  endif.
**    WRITE :  / 'LR',LRNO.
*    PG = TEXT2+0(9).
*
*    IF PG CS 'NEW-PAGE'.
*      B = 1.
*    ENDIF.
**  if pg cs 'BOLD'.
**    b = '1'.
**    bl1 = '1'.
**  endif.
*
*    IF PG CS 'BOLD'.
*      BLD1 = '1'.
*    ENDIF.
*
*    IF PG CS 'ULINE1'.
*      U = 2.
*    ELSEIF PG CS 'ULINE'.
*      U = 1.
*    ENDIF.
*
*    IF TEXT2+72(1) EQ '-'.
*      C = '1'.
*    ELSEIF TEXT2+72(1) EQ '_'.
*      C = '1'.
*    ELSEIF TEXT2+71(2) EQ '-S'.
*      D = '1'.
*      C = '1'.
*    ELSEIF TEXT2+71(2) EQ '-T'.
*      E1 = '1'.
*      C = '1'.
*    ELSE.
*      C = '0'.
*    ENDIF.
**   IF TEXT2+72(1) EQ '_'.
**    C = 1.
**  ELSE.
**    C = 0.
**  ENDIF.
*    IF TEXT2+72(1) EQ '_'.
*      TEXT2+73(1) = '_'.
*    ELSEIF TEXT2+72(1) EQ '-'.
**    REPLACE '-' WITH '.' INTO text2.
****      TEXT2+72(1) = ''.
**      IF CTXT1 IS NOT INITIAL.
**        CONCATENATE CTXT1 TEXT2 INTO WA_TXT1-TXT1.
**        WA_TXT1-TXT2 = '='.
**      ENDIF.
*      CLEAR : CTXT1.
*      CTXT1 = TEXT2.
*      CONDENSE CTXT1.
*
*    ELSEIF TEXT2+71(2) EQ '-S'.
**    REPLACE '-' WITH '.' INTO text2.
*      TEXT2+71(2) = ''.
**    text3 = text2.
**    text4 = text3.
*    ELSEIF TEXT2+71(2) EQ '-T'.
**    REPLACE '-' WITH '.' INTO text2.
*      TEXT2+71(2) = ''.
**    text3 = text2.
**    text4 = text3.
*    ENDIF.
*
*    IF BLD1 EQ '1'.
*      TEXT2 = SPACE.
*    ENDIF.
*    CLEAR :  NTXT1.
*    IF CTXT1 IS NOT INITIAL.
**      CTXT1+72(1) = ''.
**      CONDENSE : ctxt1, text2.
*      CONCATENATE CTXT1 TEXT2 INTO NTXT1.
*      WA_TXT1-TXT2 = '='.
**      CLEAR : ctxt1.  "new
*      IF C NE '1'.
*        CLEAR : CTXT1.
*      ENDIF.
*    ELSE.
*      NTXT1 = TEXT2.
*    ENDIF.
*    CONDENSE NTXT1.
**    CLEAR : CTXT1.
**  IF TEXT2 CS 'ULINE'.
**TEXT2 = SPACE.
**    CALL FUNCTION 'WRITE_FORM'
**      EXPORTING
**        ELEMENT = 'TESTLINE'
***       function = 'SET'
***       type    = 'BODY'
**        WINDOW  = 'MAIN'.
**  ELSE.
*    IF U EQ 1.
*
*      TEXT2 = SPACE.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'TESTLINE1'
**         function = 'SET'
**         type    = 'BODY'
*          WINDOW  = 'MAIN'.
*      WA_TXT1-TXT1 = '*_________________________'.
**      IF TEXT2+72(1) NE '-'.
*      COLLECT WA_TXT1 INTO IT_TXT1.
*      CLEAR WA_TXT1.
**      ENDIF.
*    ELSEIF U EQ 2.
*
*      TEXT2 = SPACE.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'TESTLINE2'
**         function = 'SET'
**         type    = 'BODY'
*          WINDOW  = 'MAIN'.
*
*      WA_TXT1-TXT1 = '   _____________________________________________________________________________________________'.
**      IF TEXT2+72(1) NE '-'.
*      COLLECT WA_TXT1 INTO IT_TXT1.
*      CLEAR WA_TXT1.
**      ENDIF.
*
*    ELSEIF B EQ 1.
*      TEXT2 = SPACE.
**    if bl1 eq 1.
**      call function 'WRITE_FORM'
**        exporting
**          element = 'TESTBOLD'
***         function = 'SET'
***         type    = 'BODY'
**          window  = 'MAIN'.
**    else.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'TESTNEW'
**         function = 'SET'
**         type    = 'BODY'
*          WINDOW  = 'MAIN'.
**    endif.
*      WA_TXT1-TXT1 = 'NEW PAGE'.
**      IF TEXT2+72(1) NE '-'.
*      COLLECT WA_TXT1 INTO IT_TXT1.
*      CLEAR WA_TXT1.
**      ENDIF.
*    ELSE.
*      IF A EQ 1.
*        IF A1 EQ 1.
*
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'TESTCONT1'
**             function = 'SET'
**             type    = 'BODY'
*              WINDOW  = 'MAIN'.
**          WA_TXT1-TXT1 = TEXT2.
*          WA_TXT1-TXT1 = NTXT1.
*
*          IF TEXT2+72(1) NE '-'.
*            COLLECT WA_TXT1 INTO IT_TXT1.
*            CLEAR WA_TXT1.
*          ENDIF.
*
*        ELSE.
*          IF E2 EQ '1'.
*            CALL FUNCTION 'WRITE_FORM'
*              EXPORTING
*                ELEMENT = 'TESTCONT1'
**               function = 'SET'
**               type    = 'BODY'
*                WINDOW  = 'MAIN'.
**            WA_TXT1-TXT1 = TEXT2.
*            WA_TXT1-TXT1 = NTXT1.
*            IF TEXT2+72(1) NE '-'.
*              COLLECT WA_TXT1 INTO IT_TXT1.
*              CLEAR WA_TXT1.
*            ENDIF.
*          ELSE.
*            CALL FUNCTION 'WRITE_FORM'
*              EXPORTING
*                ELEMENT = 'TESTCONT'
**               function = 'SET'
**               type    = 'BODY'
*                WINDOW  = 'MAIN'.
**            WA_TXT1-TXT1 = TEXT2.
*            WA_TXT1-TXT1 = NTXT1.
*            IF TEXT2+72(1) NE '-'.
*              COLLECT WA_TXT1 INTO IT_TXT1.
*              CLEAR WA_TXT1.
*            ENDIF.
**            WA_TXT1-TXT2 = '='.
*          ENDIF.
*        ENDIF.
*      ELSE.
*        IF BLD2 EQ '1'.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'TESTBOLD'
**             function = 'SET'
**             type    = 'BODY'
*              WINDOW  = 'MAIN'.
**          WA_TXT1-TXT1 = TEXT2.
*          WA_TXT1-TXT1 = NTXT1.
*          WA_TXT1-TXT2 = 'BLD2'.
*          IF TEXT2+72(1) NE '-'.
*            COLLECT WA_TXT1 INTO IT_TXT1.
*            CLEAR WA_TXT1.
*          ENDIF.
*        ELSE.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'TEST'
**             function = 'SET'
**             type    = 'BODY'
*              WINDOW  = 'MAIN'.
**          WA_TXT1-TXT1 = TEXT2.
*          WA_TXT1-TXT1 = NTXT1.
*          IF TEXT2+72(1) NE '-'.
*            COLLECT WA_TXT1 INTO IT_TXT1.
*            CLEAR WA_TXT1.
*          ENDIF.
*        ENDIF.
*      ENDIF.
*    ENDIF.
**  IF U EQ 1.
**    CALL FUNCTION 'WRITE_FORM'
**      EXPORTING
**        ELEMENT = 'TESTLINE'
***       function = 'SET'
***       type    = 'BODY'
**        WINDOW  = 'MAIN'.
**  ENDIF.
**  ENDIF.
*
**  IF TEXT2+72(1) EQ '-'.
**    A = 1.
**  ELSE.
**    A = 0.
**  ENDIF.
*    A = C.
*    A1 = D.
*    BLD2 = BLD1.
*    E2 = E1.
*    WA_TXT1-CNT = CNT.
**    COLLECT WA_TXT1 INTO IT_TXT1.
**    CLEAR WA_TXT1.
*    CNT = CNT + 1.
*
*
*    WA_TXT1-TXT1 = WA_
*  ENDLOOP.
  CONDENSE : text2.

*,w_itextb.
*concatenate w_itexta w_itextb into w_itext1 separated by space.
*condense w_itext1.

***********CODE ABOVE THIS****************
*IF MATNR CS 'H'.
*ELSE.
*  PACK MATNR TO MATNR.
*  CONDENSE MATNR.
*ENDIF.
*  IF SY-UCOMM EQ 'PRNT'.
**  MESSAGE 'PRINTOUT' TYPE 'I'.
*  ELSE.
*    SELECT SINGLE * FROM ZQC_FG_SHEET WHERE PRUEFLOS EQ INSP AND MATNR EQ MATNR AND CHARG EQ CHARG AND PRINTED EQ 'X'.
*    IF SY-SUBRC EQ 0.
*      MESSAGE 'PRINT HAS BEEN ALREDAY TAKEN, TO REPRINT NEED APPROVAL' TYPE 'I'.
*    ENDIF.
*  ENDIF.

*CONCATENATE 'ZINSP' '_' MATNR INTO FORMNM.
  CLEAR : a.

*CALL FUNCTION 'WRITE_FORM'
*  EXPORTING
*    ELEMENT = 'TEST'
**   function = 'SET'
**   type    = 'BODY'
*    WINDOW  = 'MAIN'.
*
*CALL FUNCTION 'WRITE_FORM'
*  EXPORTING
*    ELEMENT = 'DESC'
**   function = 'SET'
**   type    = 'BODY'
*    WINDOW  = 'MAIN'.
*
*CALL FUNCTION 'WRITE_FORM'
*  EXPORTING
*    ELEMENT = 'IDEN'
**   function = 'SET'
**   type    = 'BODY'
*    WINDOW  = 'MAIN'.
*LOOP AT IT_QAMV INTO WA_QAMV.
*  CLEAR : TEST.
*  TEST = WA_QAMV-VERWMERKM.
*
*  CALL FUNCTION 'WRITE_FORM'
*    EXPORTING
*      ELEMENT                  = TEST
**     function                 = 'SET'
**     type                     = 'BODY'
*      WINDOW                   = 'MAIN'
*    EXCEPTIONS
*      ELEMENT                  = 1
*      FUNCTION                 = 2
*      TYPE                     = 3
*      UNOPENED                 = 4
*      UNSTARTED                = 5
*      WINDOW                   = 6
*      BAD_PAGEFORMAT_FOR_PRINT = 7
*      SPOOL_ERROR              = 8
*      CODEPAGE                 = 9
*      OTHERS                   = 10.
*  CASE SY-SUBRC.
*    WHEN 1.
**            message e184(bctrain) with 'OTHER USER ALREADY PROCESSING, PLZ TRY AFTER SOME TIME' .
**            MESSAGE 'OTHER USER ALREADY PROCESSING, PLZ TRY AFTER SOME TIME' TYPE 'E'.
**      MESSAGE I000(0U) WITH SY-MSGV1.
*    WHEN 2.
**      MESSAGE I184(BCTRAIN) WITH 'system failure'.
*    WHEN 0.
**            message i184(bctrain) with 'success'.
*    WHEN OTHERS.
**      MESSAGE I184(BCTRAIN) WITH 'others'.
*  ENDCASE.
**  BREAK-POINT.
**  IF SY-SUBRC <> 0.
*** Implement suitable error handling here
**
**  ENDIF.
*
*
****************************
*
*
******************************
*
*ENDLOOP.
*  CALL FUNCTION 'WRITE_FORM'
*    EXPORTING
*      ELEMENT = 'ENDTEST'
**     function = 'SET'
**     type    = 'BODY'
*      WINDOW  = 'MAIN'.

*  IF sy-ucomm EQ 'PRNT'.
*  IF REPRINT EQ 'X'.
**      break-point.
**      select single * from zqc_fg_sheet where matnr eq matnr and version eq ver.
*    IF R2 EQ 'X'.
*      SELECT SINGLE * FROM ZQC_FG_SHEET WHERE PRUEFLOS EQ '000000000000' AND MATNR EQ MATNR AND VERSION EQ VERN1.
*      IF SY-SUBRC EQ 0.
*        MOVE-CORRESPONDING ZQC_FG_SHEET TO ZQC_FG_SHEET_WA.
*        ZQC_FG_SHEET_WA-REPRINT = PERNR.
*        ZQC_FG_SHEET_WA-REPRDT = SY-DATUM.
*        MODIFY ZQC_FG_SHEET FROM ZQC_FG_SHEET_WA.
*        COMMIT WORK AND WAIT .
*        CLEAR : ZQC_FG_SHEET_WA.
*      ELSE.
*        MESSAGE 'NO DATA FOUND' TYPE 'E'.
*      ENDIF.
*    ELSEIF R3 EQ 'X'.
*      SELECT SINGLE * FROM ZQC_FG_SHEET WHERE PRUEFLOS EQ '111111111111' AND MATNR EQ MATNR AND VERSION EQ VERN1.
*      IF SY-SUBRC EQ 0.
*        MOVE-CORRESPONDING ZQC_FG_SHEET TO ZQC_FG_SHEET_WA.
*        ZQC_FG_SHEET_WA-REPRINT = PERNR.
*        ZQC_FG_SHEET_WA-REPRDT = SY-DATUM.
*        MODIFY ZQC_FG_SHEET FROM ZQC_FG_SHEET_WA.
*        COMMIT WORK AND WAIT .
*        CLEAR : ZQC_FG_SHEET_WA.
*      ELSE.
*        MESSAGE 'NO DATA FOUND' TYPE 'E'.
*      ENDIF.
*    ENDIF.
*
*
*  ELSE.
*    SELECT SINGLE * FROM ZQC_FG_SHEET WHERE PRUEFLOS EQ INSP.
*    IF SY-SUBRC EQ 4.
*      IF R2 EQ 'X'.
*        ZQC_FG_SHEET_WA-PRUEFLOS = INSP.
*        ZQC_FG_SHEET_WA-MATNR = MATNR.
*        ZQC_FG_SHEET_WA-VERSION = VER.
*        ZQC_FG_SHEET_WA-CHARG = CHARG.
*        ZQC_FG_SHEET_WA-PRINTDT = SY-DATUM.
*        ZQC_FG_SHEET_WA-USNAM = SY-UNAME.
*        ZQC_FG_SHEET_WA-CPUTM = SY-UZEIT.
*        ZQC_FG_SHEET_WA-NAME = NAME.
*        ZQC_FG_SHEET_WA-PRINTED = 'X'.
*        ZQC_FG_SHEET_WA-SAMBY = SNAME.
*        MODIFY ZQC_FG_SHEET FROM ZQC_FG_SHEET_WA.
*        COMMIT WORK AND WAIT .
*        CLEAR : ZQC_FG_SHEET_WA.
*      ELSEIF R3 EQ 'X'.
*        ZQC_FG_SHEET_WA-PRUEFLOS = '111111111111'.
*        ZQC_FG_SHEET_WA-MATNR = MATNR.
*        ZQC_FG_SHEET_WA-VERSION = VER.
*        ZQC_FG_SHEET_WA-CHARG = CHARG.
*        ZQC_FG_SHEET_WA-PRINTDT = SY-DATUM.
*        ZQC_FG_SHEET_WA-USNAM = SY-UNAME.
*        ZQC_FG_SHEET_WA-CPUTM = SY-UZEIT.
*        ZQC_FG_SHEET_WA-NAME = NAME.
*        ZQC_FG_SHEET_WA-PRINTED = 'X'.
*        ZQC_FG_SHEET_WA-SAMBY = SNAME.
*        MODIFY ZQC_FG_SHEET FROM ZQC_FG_SHEET_WA.
*        COMMIT WORK AND WAIT .
*        CLEAR : ZQC_FG_SHEET_WA.
*      ENDIF.
*    ENDIF.
*  ENDIF.
*  ENDIF.
*  IF A NE 1.
*    CALL FUNCTION 'CLOSE_FORM'
**   IMPORTING
**     RESULT                         =
**     RDI_RESULT                     =
**   TABLES
**     OTFDATA                        =
**   EXCEPTIONS
**     UNOPENED                       = 1
**     BAD_PAGEFORMAT_FOR_PRINT       = 2
**     SEND_ERROR                     = 3
**     SPOOL_ERROR                    = 4
**     CODEPAGE                       = 5
**     OTHERS                         = 6
*      .
*    IF SY-SUBRC <> 0.
** Implement suitable error handling here
*    ENDIF.
*  ENDIF.

****************call smartforms******************
  PERFORM prtform.

*  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*    EXPORTING
**     FORMNAME           = 'ZRMSMP_N4_1'
**     formname           = 'ZRMSMP_N4_2'
*      FORMNAME           = 'ZFGINSP5'
**     VARIANT            = ' '
**     DIRECT_CALL        = ' '
*    IMPORTING
*      FM_NAME            = V_FM
*    EXCEPTIONS
*      NO_FORM            = 1
*      NO_FUNCTION_MODULE = 2
*      OTHERS             = 3.
*
*  CALL FUNCTION V_FM
*    EXPORTING
*      FORMAT           = FORMAT
*      TEXT1            = TEXT1
*      KUNNR            = KUNNR
*      MATNR            = MATNR
*      VER              = VER
*      EFFDT            = EFFDT
*      UNAME            = UNAME
*      UDATE            = UDATE
*      UZEIT            = UZEIT
*      MAKTX            = MAKTX
*      W_ITEXTA1        = W_ITEXTA1
*      W_ITEXTA2        = W_ITEXTA2
*      CHARG            = CHARG
*      BATCHSZ          = BATCHSZ
*      HSDAT1           = HSDAT1
*      VFDAT1           = VFDAT1
*      PACKTXT          = PACKTXT
*      PACK             = PACK
*      SPECF            = SPECF
*      INSP1            = INSP1
*      MRP              = MRP
*      SAMPQTY          = SAMPQTY
*      SQTYUOM          = SQTYUOM
*      ENSTEHDAT        = ENSTEHDAT
*      USNAME1          = USNAME1
*      SHELFLIFE        = SHELFLIFE
*    TABLES
*      IT_TXT1          = IT_TXT1
**     it_vbrp          = it_vbrp
**     ITAB_DIVISION    = ITAB_DIVISION
**     ITAB_STORAGE     = ITAB_STORAGE
**     ITAB_PA0002      = ITAB_PA0002
*    EXCEPTIONS
*      FORMATTING_ERROR = 1
*      INTERNAL_ERROR   = 2
*      SEND_ERROR       = 3
*      USER_CANCELED    = 4
*      OTHERS           = 5.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PASSW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM passw .
*  select single * from zpassw where pernr = pernr.             "Commented by Vinayak S.
*  if sy-subrc eq 0.
*
*    if sy-uname ne zpassw-uname.
*      message 'INVALID LOGIN ID' type 'E'.
*    endif.
*    v_en_string = zpassw-password.
**&———————————————————————** Decryption – String to String*&———————————————————————*
*    try.
*        create object o_encryptor.
*        call method o_encryptor->decrypt_string2string
*          exporting
*            the_string = v_en_string
*          receiving
*            result     = v_de_string.
*      catch cx_encrypt_error into o_cx_encrypt_error.
*        call method o_cx_encrypt_error->if_message~get_text
*          receiving
*            result = v_error_msg.
*        message v_error_msg type 'E'.
*    endtry.
*    if v_de_string eq pass.
**      message 'CORRECT PASSWORD' type 'I'.
*    else.
*      message 'INCORRECT PASSWORD' type 'E'.
*    endif.
*  else.
*    message 'NOT VALID USER' type 'E'.
*    exit.
*  endif.
**  CLEAR : PASS.
**  PASS = '   '.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MFGEXP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM mfgexp .
  CLEAR : psmng.
  IF aufnr EQ space.
    SELECT SINGLE aufnr FROM afpo INTO aufnr WHERE dwerk EQ werks AND matnr EQ matnr AND charg EQ charg.
    IF sy-subrc EQ 0.
      SELECT * FROM aufk INTO TABLE it_aufk1 WHERE aufnr EQ aufnr AND loekz EQ space.
      SELECT * FROM afru INTO TABLE it_afru1 WHERE aufnr EQ aufnr.
      SELECT * FROM aufm INTO TABLE it_aufm1 WHERE aufnr EQ aufnr AND bwart EQ '261'.
    ENDIF.
    SELECT SINGLE * FROM afpo WHERE aufnr EQ aufnr.
    IF sy-subrc EQ 0.
      psmng = afpo-psmng.
      meins = afpo-meins.
    ENDIF.
    SORT it_aufm1 DESCENDING.

    CLEAR : manhsdat.
    LOOP AT it_aufm1 INTO wa_aufm1 WHERE aufnr EQ aufnr AND werks EQ werks. "4.11.2019
      manhsdat = wa_aufm1-budat.
      EXIT.
    ENDLOOP.
    IF manhsdat NE '00000000'.
      CLEAR : iprkz,mhdhb,mhdhb1,w_vfdat,w_vfdat1.
      SELECT SINGLE * FROM mara WHERE matnr EQ matnr.
      IF sy-subrc EQ 0.
        iprkz = mara-iprkz.
        mhdhb = mara-mhdhb.
      ENDIF.
      IF mhdhb NE 0 AND iprkz EQ '2'.
        CALL FUNCTION 'HR_JP_MONTH_BEGIN_END_DATE'
          EXPORTING
            iv_date           = manhsdat
          IMPORTING
*           EV_MONTH_BEGIN_DATE       =
            ev_month_end_date = w_vfdat.
        mhdhb1 = mhdhb - 1.
        CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
          EXPORTING
            months  = mhdhb1
            olddate = w_vfdat
          IMPORTING
            newdate = w_vfdat1.
        CONCATENATE manhsdat+4(2) '/' manhsdat+0(4) INTO hsdat1.
        CONCATENATE w_vfdat1+4(2) '/' w_vfdat1+0(4) INTO vfdat1.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  AUTHORIZATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM authorization .
  IF r1 EQ 'X'.
    SELECT SINGLE * FROM qals WHERE prueflos EQ insp.
    IF sy-subrc EQ 0.
      aplant = qals-werk.
    ENDIF.
  ELSEIF r2 EQ 'X' OR r3 EQ 'X'.
    aplant = p_plant.
  ENDIF.

**  loop at itab_t001w into wa_t001w.
*  AUTHORITY-CHECK OBJECT 'M_BCO_WERK'
*         ID 'WERKS' FIELD aplant.
*  IF sy-subrc <> 0.
*    CONCATENATE 'No authorization for Plant' aplant INTO msg
*    SEPARATED BY space.
*    MESSAGE msg TYPE 'E'.
*  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PRINTCOMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM printcomm .
  LOOP AT mmline1.
*    IF MMLINE1-TDLINE CS 'Rabeprazole Sodium WS-'.
*      BREAK-POINT.
*    ENDIF.
*    IF MMLINE1-TDLINE CS 'Conclusion' .
*      BREAK-POINT.
*    ENDIF.

    IF ntxt1 IS NOT INITIAL.

      IF ntxt3 EQ 'A' .
        CLEAR : ntxt2.
*      CONDENSE ntxt1 NO-GAPS.
*        REPLACE '-' WITH '' INTO NTXT1.
        CONCATENATE ntxt1 mmline1-tdline INTO ntxt2.
        MOVE ntxt2 TO wa_txt1-txt1.
        wa_txt1-txt2 = 'L4'.
        CLEAR : ntxt3.

      ELSEIF ntxt3 EQ 'L' .
        CLEAR : ntxt2.
*      CONDENSE ntxt1 NO-GAPS.
        REPLACE '-' WITH '' INTO ntxt1.
        CONCATENATE ntxt1 mmline1-tdline INTO ntxt2.
        MOVE ntxt2 TO wa_txt1-txt1.
        wa_txt1-txt2 = 'L3'.
        CLEAR : ntxt3.

      ELSEIF ntxt5 EQ 'A'.
        CLEAR : ntxt2.
*      CONDENSE ntxt1 NO-GAPS.
        REPLACE '-' WITH '' INTO ntxt1.
        CONCATENATE ntxt1 mmline1-tdline INTO ntxt2.
        MOVE ntxt2 TO wa_txt1-txt1.
        wa_txt1-txt2 = 'L4'.  "L5
        CLEAR : ntxt3,ntxt5.
      ELSE.
        CLEAR : ntxt2.
*      CONDENSE ntxt1 NO-GAPS.
        REPLACE '-' WITH '' INTO ntxt1.
        CONCATENATE ntxt1 mmline1-tdline INTO ntxt2.
        MOVE ntxt2 TO wa_txt1-txt1.
        wa_txt1-txt2 = 'L4'.  "L5
      ENDIF.
    ELSE.
      MOVE mmline1-tdline TO wa_txt1-txt1.
    ENDIF.
*********************************************************************

    IF b1 EQ 'B1'.
      wa_txt1-txt2 = 'B2'.
      CLEAR : b1.
    ELSEIF mmline1-tdline CS 'ULINE1' OR mmline1-tdline CS 'ULINE'.
      wa_txt1-txt2 = 'L1'.
      wa_txt1-cnt = cnt.
    ELSEIF mmline1-tdline+71(1) = '-'.
      mmline1-tdline+71(1) = ' '.
      wa_txt1-txt2 = 'L2'.
      CLEAR : ntxt1,ntxt2.
      ntxt1 = mmline1-tdline .
*      CONDENSE NTXT1.
      ntxt3 = 'A'.
    ELSEIF mmline1-tdline+69(3) = '- -'.
      wa_txt1-txt2 = 'L2'.
      CLEAR : ntxt1,ntxt2.
      ntxt1 = mmline1-tdline .
      CONDENSE ntxt1.
      CLEAR : ntxt5.
      ntxt5 = 'A'.
    ELSEIF mmline1-tdline+70(2) = ' - '.
      wa_txt1-txt2 = 'L2'.
      CLEAR : ntxt1,ntxt2.
      ntxt1 = mmline1-tdline .
      CONDENSE ntxt1.

    ELSEIF mmline1-tdline+70(2) = '-S' OR mmline1-tdline+70(2) = '--'.
      mmline1-tdline+70(2) = '  '.
      wa_txt1-txt2 = 'L2'.
      CLEAR : ntxt1,ntxt2.
      ntxt1 = mmline1-tdline .
*      CONDENSE NTXT1.
      ntxt3 = 'A'.
*    ELSEIF MMLINE1-TDLINE+71(1) = '-'.
*      MMLINE1-TDLINE+71(1) = ' '.
*      WA_TXT1-TXT2 = 'L2'.
*      CLEAR : NTXT1,NTXT2.
*      NTXT1 = MMLINE1-TDLINE .
**      CONDENSE NTXT1.
*      NTXT3 = 'A'.
    ELSEIF mmline1-tdline+70(2) = '-L'.
      mmline1-tdline+70(2) = '  '.
      wa_txt1-txt2 = 'L2'.
      CLEAR : ntxt1,ntxt2.
      ntxt1 = mmline1-tdline .
*      CONDENSE NTXT1.
      ntxt3 = 'L'.
    ELSEIF  wa_txt1-txt2 = 'L3'.
      CLEAR : ntxt1,ntxt2.
    ELSEIF  wa_txt1-txt2 = 'L4' OR wa_txt1-txt2 = 'L5'.
      CLEAR : ntxt1,ntxt2.
    ELSEIF  wa_txt1-txt1+0(8) = 'NEW-PAGE'.
      wa_txt1-txt2 = 'N1'.
    ELSEIF  wa_txt1-txt1+0(4) = 'BOLD' OR wa_txt1-txt1+0(4) = 'Bold' OR wa_txt1-txt1+0(4) = 'bold'.
      CLEAR : b1.
      b1 = 'B1'.
      wa_txt1-txt2 = b1.
    ELSE.
      wa_txt1-txt2 = space.
    ENDIF.

    IF wa_txt1-txt2 EQ 'L2'.
    ELSEIF wa_txt1-txt2 EQ 'B1'.
    ELSE.

      wa_txt1-cnt = cnt.
      COLLECT wa_txt1 INTO it_txt1.
      CLEAR wa_txt1.
    ENDIF.
    cnt = cnt + 1.
  ENDLOOP.
*BREAK-POINT.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PRTFORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM prtform .

  IF r1 EQ 'X'.
    type1 = 'I'.  "INSPECTION LOT
  ELSEIF r3 EQ 'X'.
    type1 = 'U'.   "UNCOATED
  ELSE.
    type1 = 'P'.  "PRODUCT
  ENDIF.
  CLEAR : docdesc,matnr2.
  matnr2 = matnr.
  IF matnr2 CS 'H'.
  ELSE.
    PACK matnr2 TO matnr2.
  ENDIF.
  CONDENSE matnr2.
*  IF R1 EQ 'X' AND WERKS EQ '1000' AND MTART EQ 'ZROH'.
*    CONCATENATE 'ADS/RM/' MATNR2 INTO DOCDESC.
*  ELSEIF R1 EQ 'X' AND WERKS EQ '1000' AND MTART EQ 'ZRQC'.
*    CONCATENATE 'ADS/ANC/' MATNR2 INTO DOCDESC.
*  ELSEIF R1 EQ 'X' AND WERKS EQ '1000'.
**     AND MTART NE 'ZROH'.
*    CONCATENATE 'ADS/RM/' SPECF '/' MATNR2 INTO DOCDESC.
*  ELSEIF R1 EQ 'X' AND WERKS EQ '1001'.
*    DOCDESC = ADS.
*  ELSEIF R1 NE 'X' AND WERKS EQ '1000' AND MTART EQ 'ZROH'.
*    CONCATENATE 'ADS/RM/' MATNR2 INTO DOCDESC.
*  ELSEIF R1 NE 'X' AND WERKS EQ '1000' AND MTART EQ 'ZRQC'.
*    CONCATENATE 'ADS/ANC/' MATNR2 INTO DOCDESC.
*  ELSEIF R1 NE 'X' AND WERKS EQ '1000'.
**     AND MTART NE 'ZROH'.
*    CONCATENATE 'ADS/RM/' SPECF '/' MATNR2 INTO DOCDESC.
*  ELSEIF R1 NE 'X' AND WERKS EQ '1001'.
*    DOCDESC = ADS.
*  ENDIF.

*BREAK-POINT .
  IF r1 EQ 'X' AND werks EQ '1000' AND mtart EQ 'ZROH' AND insp+0(2) EQ '09'.
    CONCATENATE 'ADS/RM/' matnr2 '/R'INTO docdesc.
  ELSEIF r1 EQ 'X' AND werks EQ '1000' AND mtart EQ 'ZROH'.
    CONCATENATE 'ADS/RM/' matnr2 INTO docdesc.
  ELSEIF r21 EQ 'X' AND werks EQ '1000' AND mtart EQ 'ZROH'.
    CONCATENATE 'ADS/RM/' matnr2 '/R'INTO docdesc.
  ELSEIF r1 EQ 'X' AND werks EQ '1000' AND mtart EQ 'ZRQC'.
    CONCATENATE 'ADS/ANC/' matnr2 INTO docdesc.
  ELSEIF r1 EQ 'X' AND werks EQ '1000'.
*     AND MTART NE 'ZROH'.
    CONCATENATE 'ADS/' specf '/' matnr2 INTO docdesc.
  ELSEIF r1 EQ 'X' AND werks EQ '1001'.
    docdesc = ads.
*****************ADD R3**************************************************************************************
  ELSEIF ( r2 EQ 'X'OR r3 EQ 'X' ) AND werks EQ '1000' AND mtart EQ 'ZROH'.
    CONCATENATE 'ADS/RM/' matnr2 INTO docdesc.
  ELSEIF ( r2 EQ 'X'OR r3 EQ 'X' ) AND werks EQ '1000' AND mtart EQ 'ZRQC'.
    CONCATENATE 'ADS/ANC/' matnr2 INTO docdesc.
  ELSEIF ( r2 EQ 'X'OR r3 EQ 'X' ) AND werks EQ '1000'.
*     AND MTART NE 'ZROH'.
    CONCATENATE 'ADS/' specf '/' matnr2 INTO docdesc.
  ELSEIF ( r2 EQ 'X'OR r3 EQ 'X' ) AND werks EQ '1001'.
    docdesc = ads.
  ENDIF.


  CONDENSE docdesc.

  IF preview EQ space AND reprint EQ space.
*    select single * from pa0001 where pernr eq pernr and endda ge sy-datum.          "Commented by Vinayak S.
*    if sy-subrc eq 0.
*      if pa0001-btrtl eq '1223' or pa0001-btrtl eq '1228' or pa0001-btrtl eq '1323' or pa0001-btrtl eq '1328'.
*      else.
*        message 'ONLY QC IS ALLOWED TO PRINT' type 'E'.
*      endif.
*    endif.
  ENDIF.

  control-no_open   = 'X'.
  control-no_close  = 'X'.
  IF preview EQ 'X'.
    w_ssfcompop-tdnoprint = 'X'.
  ELSE.
    w_ssfcompop-tdnoprev = 'X'.
  ENDIF.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
*     FORMNAME           = 'ZRMSMP_N4_1'
*     formname           = 'ZRMSMP_N4_2'
*     FORMNAME           = 'ZFGINSP9'
*     FORMNAME           = 'ZFGINSP9'
*     FORMNAME           = 'ZFGINSP10'
      formname           = 'ZFGINSP10'
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
      fm_name            = v_fm
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.

  CALL FUNCTION 'SSF_OPEN'
    EXPORTING
      control_parameters = control
      output_options     = w_ssfcompop.

  CLEAR : batchsz4.
  IF batchsz GT 0.
    batchsz4 = batchsz3.
  ENDIF.
  CONDENSE batchsz4.

  REPLACE ALL OCCURRENCES OF '<(>' IN w_itexta1 WITH ''.
  REPLACE ALL OCCURRENCES OF '<)>' IN w_itexta1 WITH ''.
  REPLACE ALL OCCURRENCES OF '<(>' IN w_itexta2 WITH ''.
  REPLACE ALL OCCURRENCES OF '<)>' IN w_itexta2 WITH ''.

  wa_check-frm = 'A'.
  COLLECT wa_check INTO it_check.
  CLEAR wa_check.
*  BREAK-POINT .

  IF preview EQ 'X'.
*    CONTROL-PREVIEW = 'X'.
*    W_SSFCOMPOP-TDNOPRINT = 'X'.
*    CONTROL-DEVICE = ''.
*    CONTROL-NO_DIALOG = 'X'.
*    CONTROL_PARAMETERS-NO_DIALOG = 'X'.
*  ELSE.
**    W_SSFCOMPOP-TDNOPREV =  'X'.
    IF sy-ucomm EQ 'PRNT'.
      MESSAGE 'PRINT COMMAND IS NOT ALLOWED IN PREVIEW' TYPE 'E'.
      EXIT.
      SELECT SINGLE * FROM zqc_fg_sheet WHERE prueflos EQ insp.
      IF sy-subrc EQ 0.
        MESSAGE 'REMOVE PREVIEW PRINT IS ALREDY TAKEN' TYPE 'E'.
        EXIT.
      ENDIF.
    ENDIF.
  ENDIF.
  LOOP AT it_check INTO wa_check.
    CLEAR : tp1.
    IF mtart EQ 'ZROH' OR mtart EQ 'ZRQC'.
      tp1 = 'RM'.
    ELSEIF mtart EQ 'ZHLB'.
      tp1 = 'HB'.
    ELSE.
      tp1 = 'AL'.
    ENDIF.
    PERFORM venbatch.

    CALL FUNCTION v_fm
      EXPORTING
        output_options     = w_ssfcompop
        control_parameters = control
        user_settings      = 'X'
        format             = format
        text1              = text1
        kunnr              = kunnr
        matnr              = matnr
        ver                = ver
        effdt              = effdt
        uname              = uname
        udate              = udate
        uzeit              = uzeit
        maktx              = maktx
        w_itexta1          = w_itexta1
        w_itexta2          = w_itexta2
        charg              = charg
        batchsz            = batchsz4
        hsdat1             = hsdat1
        vfdat1             = vfdat1
        hsdat              = hsdat
        vfdat              = vfdat
        packtxt            = packtxt
        pack               = pack
        specf              = specf
        insp1              = insp1
        mrp                = mrp
        sampqty            = sampqty
        sqtyuom            = sqtyuom
        enstehdat          = enstehdat
        usname1            = usname1
        shelflife          = shelflife
        type1              = type1
        docdesc            = docdesc
        format1            = format1
        mtart              = mtart
        q1                 = q1
        licha              = licha
        cpudt              = cpudt
        mblnr              = mblnr
        menge              = menge
        vdatum             = vdatum
        meins              = meins
        mfgr               = mfgr
        sname1             = sname1
        tp1                = tp1
        pruefdatuv         = pruefdatuv
        sampo              = sampo
        sampb              = sampb
        qtysamp            = qtysamp
        lwedt              = lwedt                                      "Added by Vinayak S.
        pruefdatub         = pruefdatub
      IMPORTING
        job_output_info    = w_return " This will have all output
      TABLES
        it_txt1            = it_txt1
*       it_vbrp            = it_vbrp
*       ITAB_DIVISION      = ITAB_DIVISION
*       ITAB_STORAGE       = ITAB_STORAGE
*       ITAB_PA0002        = ITAB_PA0002
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.
  ENDLOOP.



* *******************UPDATE DATA HERE*********************
  IF preview NE 'X'.
    IF sy-ucomm EQ 'PRNT'.
      IF r1 EQ 'X'.
        IF reprint EQ 'X'.
          SELECT SINGLE * FROM zqc_fg_sheet WHERE prueflos EQ insp.
          IF sy-subrc EQ 0.
            MOVE-CORRESPONDING zqc_fg_sheet TO zqc_fg_sheet_wa.
*            zqc_fg_sheet_wa-reprint = pernr.                   "Commented by Vinayak S.
            zqc_fg_sheet_wa-reprdt = sy-datum.
            MODIFY zqc_fg_sheet FROM zqc_fg_sheet_wa.
            COMMIT WORK AND WAIT .
            CLEAR : zqc_fg_sheet_wa.
          ELSE.
            MESSAGE 'NO DATA FOUND' TYPE 'E'.
          ENDIF.
        ELSE.
          SELECT SINGLE * FROM zqc_fg_sheet WHERE prueflos EQ insp.
          IF sy-subrc EQ 4.
            zqc_fg_sheet_wa-prueflos = insp.
            zqc_fg_sheet_wa-matnr = matnr.
            zqc_fg_sheet_wa-version = ver.
            zqc_fg_sheet_wa-charg = charg.
            zqc_fg_sheet_wa-printdt = sy-datum.
            zqc_fg_sheet_wa-usnam = sy-uname.
            zqc_fg_sheet_wa-cputm = sy-uzeit.
            zqc_fg_sheet_wa-name = name.
            zqc_fg_sheet_wa-printed = 'X'.
            zqc_fg_sheet_wa-samby = sname.
            zqc_fg_sheet_wa-sampdt = sampdt.
            MODIFY zqc_fg_sheet FROM zqc_fg_sheet_wa.
            COMMIT WORK AND WAIT .
            CLEAR : zqc_fg_sheet_wa.
          ENDIF.
        ENDIF.
      ELSE.
*****************************************************************************
        IF reprint EQ 'X'.
          IF r2 EQ 'X'.
            SELECT SINGLE * FROM zqc_fg_sheet WHERE prueflos EQ '000000000000' AND matnr EQ matnr AND version EQ vern1.
            IF sy-subrc EQ 0.
              MOVE-CORRESPONDING zqc_fg_sheet TO zqc_fg_sheet_wa.
*              zqc_fg_sheet_wa-reprint = pernr.               "Commented by Vinayak S.
              zqc_fg_sheet_wa-reprdt = sy-datum.
              MODIFY zqc_fg_sheet FROM zqc_fg_sheet_wa.
              COMMIT WORK AND WAIT .
              CLEAR : zqc_fg_sheet_wa.
            ELSE.
              MESSAGE 'NO DATA FOUND' TYPE 'E'.
            ENDIF.
          ELSEIF r3 EQ 'X'.
            SELECT SINGLE * FROM zqc_fg_sheet WHERE prueflos EQ '111111111111' AND matnr EQ matnr AND version EQ vern1.
            IF sy-subrc EQ 0.
              MOVE-CORRESPONDING zqc_fg_sheet TO zqc_fg_sheet_wa.
*              zqc_fg_sheet_wa-reprint = pernr.                 "Commented by Vinayak S.
              zqc_fg_sheet_wa-reprdt = sy-datum.
              MODIFY zqc_fg_sheet FROM zqc_fg_sheet_wa.
              COMMIT WORK AND WAIT .
              CLEAR : zqc_fg_sheet_wa.
            ELSE.
              MESSAGE 'NO DATA FOUND' TYPE 'E'.
            ENDIF.
          ELSEIF r21 EQ 'X'.
            SELECT SINGLE * FROM zqc_fg_sheet WHERE prueflos EQ '999999999999' AND matnr EQ matnr AND version EQ vern1.
            IF sy-subrc EQ 0.
              MOVE-CORRESPONDING zqc_fg_sheet TO zqc_fg_sheet_wa.
*              zqc_fg_sheet_wa-reprint = pernr.                       "Commented by Vinayak S.
              zqc_fg_sheet_wa-reprdt = sy-datum.
              MODIFY zqc_fg_sheet FROM zqc_fg_sheet_wa.
              COMMIT WORK AND WAIT .
              CLEAR : zqc_fg_sheet_wa.
            ELSE.
              MESSAGE 'NO DATA FOUND' TYPE 'E'.
            ENDIF.

          ENDIF.
        ELSE.
          SELECT SINGLE * FROM zqc_fg_sheet WHERE prueflos EQ insp.
          IF sy-subrc EQ 4.
            IF r2 EQ 'X'.
              zqc_fg_sheet_wa-prueflos = insp.
              zqc_fg_sheet_wa-matnr = matnr.
              zqc_fg_sheet_wa-version = ver.
              zqc_fg_sheet_wa-charg = charg.
              zqc_fg_sheet_wa-printdt = sy-datum.
              zqc_fg_sheet_wa-usnam = sy-uname.
              zqc_fg_sheet_wa-cputm = sy-uzeit.
              zqc_fg_sheet_wa-name = name.
              zqc_fg_sheet_wa-printed = 'X'.
              zqc_fg_sheet_wa-samby = sname.
              MODIFY zqc_fg_sheet FROM zqc_fg_sheet_wa.
              COMMIT WORK AND WAIT .
              CLEAR : zqc_fg_sheet_wa.
            ELSEIF r3 EQ 'X'.
              zqc_fg_sheet_wa-prueflos = '111111111111'.
              zqc_fg_sheet_wa-matnr = matnr.
              zqc_fg_sheet_wa-version = ver.
              zqc_fg_sheet_wa-charg = charg.
              zqc_fg_sheet_wa-printdt = sy-datum.
              zqc_fg_sheet_wa-usnam = sy-uname.
              zqc_fg_sheet_wa-cputm = sy-uzeit.
              zqc_fg_sheet_wa-name = name.
              zqc_fg_sheet_wa-printed = 'X'.
              zqc_fg_sheet_wa-samby = sname.
              MODIFY zqc_fg_sheet FROM zqc_fg_sheet_wa.
              COMMIT WORK AND WAIT .
              CLEAR : zqc_fg_sheet_wa.
            ELSEIF r21 EQ 'X'.
              zqc_fg_sheet_wa-prueflos = '999999999999'.
              zqc_fg_sheet_wa-matnr = matnr.
              zqc_fg_sheet_wa-version = ver.
              zqc_fg_sheet_wa-charg = charg.
              zqc_fg_sheet_wa-printdt = sy-datum.
              zqc_fg_sheet_wa-usnam = sy-uname.
              zqc_fg_sheet_wa-cputm = sy-uzeit.
              zqc_fg_sheet_wa-name = name.
              zqc_fg_sheet_wa-printed = 'X'.
              zqc_fg_sheet_wa-samby = sname.
              MODIFY zqc_fg_sheet FROM zqc_fg_sheet_wa.
              COMMIT WORK AND WAIT .
              CLEAR : zqc_fg_sheet_wa.

            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
*************************************************
*  BREAK-POINT.
  CALL FUNCTION 'SSF_CLOSE'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VENBATCH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM venbatch .
*************************** VENDOR BATCH*********************************************************************************************************
  licha = lichn.
  CLEAR : rtdname1.
  CONCATENATE matnr werks charg INTO rtdname1.
*            RTDNAME1 = '00000000000010010010000000108421'.

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      client                  = sy-mandt
      id                      = 'VERM'
      language                = 'E'
      name                    = rtdname1
      object                  = 'CHARGE'
*     ARCHIVE_HANDLE          = 0
*            IMPORTING
*     HEADER                  = THEAD
    TABLES
      lines                   = ritext1
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
*    ************

  DESCRIBE TABLE ritext1 LINES ln1.
  nolines = 0.
  CLEAR : w_itext3,r11,r12.
  LOOP AT ritext1."WHERE tdline NE ' '.
    CONDENSE ritext1-tdline.
    nolines =  nolines  + 1.
    IF ritext1-tdline IS NOT  INITIAL   .
      IF ritext1-tdline NE '.'.

        IF nolines LE  1.
*                  MOVE ITEXT-TDLINE TO T1.
          MOVE ritext1-tdline TO w_itext3.
          CONCATENATE r11 w_itext3  INTO r11.
*                  SEPARATED BY SPACE.
        ENDIF.

*              move ritext1-tdline to w_itext3.
*              concatenate r3 w_itext3  into r3 separated by space.
      ENDIF.
    ENDIF.
  ENDLOOP.
*            WRITE : LICHA,R11.

  IF licha+0(15) = r11+0(15).  "11.9.20  "long vendor batch
    licha = r11.
  ENDIF.

**********************************************************************************************************************
ENDFORM.
