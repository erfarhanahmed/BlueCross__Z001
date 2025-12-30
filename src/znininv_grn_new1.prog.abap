*&---------------------------------------------------------------------*
*& Report  ZNININV_GRN1
*& Developed bu Jyotsna
*&---------------------------------------------------------------------*
*&IMPORTANT - MATERIAL NAME, MANUFACTURER FOR RM
*& FOR FEW MATERIAL DESCRIPTION IS BASED ON TABLE ZPO_MATNR
******* allowed second line approver from table ZQMS_DEPTHEAD1 ON 26.11.24 BY JYOTSNA
*****maker & checker can not be same login - Jyotsna9.2.25
***change for supplier name   via bcll - 29.3.25
***** grn receipt unit change as erfme - Jyotsna 29.4.25
*&---------------------------------------------------------------------*

REPORT znininv_grn_new1 NO STANDARD PAGE HEADING LINE-SIZE 500.
TABLES : mseg,
         mkpf,
         t001w,
         lfa1,
         t024,
         ekpo,
         makt,
         mch1,
         qals,
         j_1iexcdtl,
         j_1iexchdr,
         t001l,
         j_1ipart1,
         mara,
         ekko,
         zmigo,
         zpo_matnr,
         ekpa,
         eban,
         pa0001,
         t001p,
         zpassw,
         pa0002,
         jest,
         v_usr_name,
         zcoadata,
         qave,
         zmigo_chk,
         hrp1000,
*         ZQMS_DEPTHEAD,
         zqms_depthead1,
         zqms_depthead2,
         adrc,
         zpur_req1,
         zpa0001,
         pa0105.


TYPE-POOLS:  slis.

DATA: g_repid     LIKE sy-repid,
      fieldcat    TYPE slis_t_fieldcat_alv,
      wa_fieldcat LIKE LINE OF fieldcat,
      sort        TYPE slis_t_sortinfo_alv,
      wa_sort     LIKE LINE OF sort,
      layout      TYPE slis_layout_alv.

DATA : it_mseg  TYPE TABLE OF mseg,
       wa_mseg  TYPE mseg,
       it_mseg1 TYPE TABLE OF mseg,
       wa_mseg1 TYPE mseg,
       it_mseg2 TYPE TABLE OF mseg,
       wa_mseg2 TYPE mseg,
       it_mseg3 TYPE TABLE OF mseg,
       wa_mseg3 TYPE mseg,
       it_mseg4 TYPE TABLE OF mseg,
       wa_mseg4 TYPE mseg,
       it_ekko  TYPE TABLE OF ekko,
       wa_ekko  TYPE ekko,
       it_qals  TYPE TABLE OF qals,
       wa_qals  TYPE qals,
       it_mcha  TYPE TABLE OF mcha,
       wa_mcha  TYPE mcha,
       it_mcha1 TYPE TABLE OF mcha,
       wa_mcha1 TYPE mcha,
       it_qals1 TYPE TABLE OF qals,
       wa_qals1 TYPE qals,
       it_qals2 TYPE TABLE OF qals,
       wa_qals2 TYPE qals.
*****************************************
DATA: it_ekpo TYPE TABLE OF ekpo,
      wa_ekpo TYPE ekpo.
TYPES: BEGIN OF itap1,
         ebeln TYPE ekpo-ebeln,
         ebelp TYPE ekpo-ebelp,
         matnr TYPE ekpo-matnr,
         txz01 TYPE ekpo-txz01,
         menge TYPE ekpo-menge,
         meins TYPE ekpo-meins,
         netpr TYPE ekpo-netpr,
         peinh TYPE ekpo-peinh,
         netwr TYPE ekpo-netwr,
         banfn TYPE ekpo-banfn,
         bnfpo TYPE ekpo-bnfpo,
         bednr TYPE pa0001-pernr,
         ename TYPE pa0001-ename,
         btext TYPE t001p-btext,
       END OF itap1.
TYPES: BEGIN OF chk1,
         mblnr    TYPE mseg-mblnr,
         mjahr    TYPE mseg-mjahr,
         chkby(1) TYPE c,
       END OF chk1.
DATA: it_tap1 TYPE TABLE OF itap1,
      wa_tap1 TYPE itap1,
      it_chk1 TYPE TABLE OF chk1,
      wa_chk1 TYPE chk1.
DATA: bednr TYPE pa0001-pernr.
DATA: c_ccont   TYPE REF TO cl_gui_custom_container,         "Custom container object
      c_alvgd   TYPE REF TO cl_gui_alv_grid,         "ALV grid object
      it_fcat   TYPE lvc_t_fcat,                  "Field catalogue
      it_layout TYPE lvc_s_layo.                  "Layout
*ok code declaration
DATA:
  ok_code       TYPE ui_func.
DATA: stable TYPE lvc_s_stbl.
DATA: zmigo_chk_wa TYPE zmigo_chk.

**************************************
DATA: mjahr TYPE mseg-mjahr.

TYPES : BEGIN OF itab1,
          mblnr       TYPE  mseg-mblnr,
          mjahr       TYPE mseg-mjahr,
          ebeln       TYPE mseg-ebeln,
          werks       TYPE mseg-werks,
          lifnr       TYPE mseg-lifnr,
          ekgrp       TYPE ekko-ekgrp,
          budat       TYPE mkpf-budat,
          xblnr       TYPE mkpf-xblnr,
          bldat       TYPE mkpf-bldat,
*  w_name1 type kna1-name1,
          w_name1(35) TYPE c,
          v_name1     TYPE lfa1-name1,
          eknam       TYPE t024-eknam,
          exnum       TYPE j_1iexchdr-exnum,
          exbed       TYPE j_1iexchdr-exbed,
          exdat       TYPE j_1iexchdr-exdat,
          lgort       TYPE mseg-lgort,
          lgobe       TYPE t001l-lgobe,
          bedat       TYPE ekko-bedat,
          docno       TYPE j_1ipart1-docno,
          docyr       TYPE j_1ipart1-docyr,
          kunnr       TYPE t001w-kunnr,
          ort01       TYPE t001w-ort01,                   "Rushi.
          aedat       TYPE ekko-aedat,
          batchno     TYPE atwtb,

*  MATNR TYPE MSEG-MATNR,
*  sgtxt TYPE mseg-sgtxt,
        END OF itab1.

TYPES : BEGIN OF bt1,
          mjahr TYPE mseg-mjahr,
          charg TYPE mseg-charg,
        END OF bt1.

TYPES : BEGIN OF itab3,
          mblnr        TYPE mseg-mblnr,
          mjahr        TYPE mseg-mjahr,
          lgort        TYPE mseg-lgort,
          werks        TYPE mseg-werks,
          zeile        TYPE mseg-zeile,
          matnr        TYPE mseg-matnr,
          charg        TYPE mseg-charg,
          prueflos     TYPE qals-prueflos,
          ablad        TYPE mseg-ablad,
*          licha    TYPE mcha-licha,
          licha(25)    TYPE c,
          menge        TYPE mseg-menge,
          erfmg        TYPE mseg-erfmg,
          erfme        TYPE mseg-erfme,
          meins        TYPE mseg-meins,
          uom          TYPE mseg-meins,
          anzgeb       TYPE qals-anzgeb,
*          V_NAME1   TYPE LFA1-NAME1,
          v_name1(100) TYPE c,
          vn_ort01     TYPE lfa1-ort01,
          hsdat        TYPE mcha-hsdat,
          sgtxt        TYPE mseg-sgtxt,
          vfdat        TYPE mcha-vfdat,
*          matnr    type mseg-matnr,
          knttp        TYPE ekpo-knttp,
          kostl        TYPE mseg-kostl,
          ebeln        TYPE mseg-ebeln,
        END OF itab3.

TYPES : BEGIN OF itab4,
          mblnr        TYPE mseg-mblnr,
          mjahr        TYPE mseg-mjahr,
          werks        TYPE mseg-werks,
          zeile        TYPE mseg-zeile,
          matnr        TYPE mseg-matnr,
          maktx(100)   TYPE c,
          charg        TYPE mseg-charg,
          prueflos     TYPE qals-prueflos,
          ablad        TYPE mseg-ablad,
*          licha        TYPE mcha-licha,
          licha(25)    TYPE c,
          menge(20)    TYPE c,
          erfmg(20)    TYPE c,
*          efrme     type mseg-erfme,
          meins        TYPE mseg-meins,
*          uom       type mseg-meins,
          anzgeb       TYPE qals-anzgeb,
          v_name1      TYPE lfa1-name1,
          vn_ort01     TYPE lfa1-ort01,
          hsdat        TYPE mcha-hsdat,
          sgtxt        TYPE mseg-sgtxt,
          vfdat        TYPE mcha-vfdat,
*          matnr    type mseg-matnr,
          knttp        TYPE ekpo-knttp,
          kostl        TYPE mseg-kostl,
          ename        TYPE pa0001-ename,
          qcstatus(50) TYPE c,
          qcdate       TYPE sy-datum,
          lgort        TYPE mseg-lgort,
          npage(1)     TYPE c,
          ebeln        TYPE mseg-ebeln,
          vezeiterf    TYPE qave-vezeiterf,
          vn_name1     TYPE adrc-name1,
          lmenge04(20) TYPE c,
          lmenge01(20) TYPE c,
          rejqty(1)    TYPE c,
          mengeneinh   TYPE qals-mengeneinh,
          stext        TYPE hrp1000-stext,
*          vn_ort01     type lfa1-ort01,
        END OF itab4.

TYPES : BEGIN OF doc1,
          mblnr TYPE mseg-mblnr,
          mjahr TYPE mseg-mjahr,
          ebeln TYPE mseg-ebeln,
        END OF doc1.
TYPES: BEGIN OF po1,
         ebeln TYPE ekpo-ebeln,
         aedat TYPE cpudt,
         xblnr TYPE xblnr,
         bldat TYPE bldat,
         lifnr TYPE lifnr,
         name1 TYPE ad_name1,
       END OF po1.

TYPES : BEGIN OF ninv1,
          zeile     TYPE mseg-zeile,
          knttp     TYPE ekpo-knttp,
          asset(18) TYPE c,
          sgtxt     TYPE ekpo-txz01,
          erfmg(10) TYPE c,
          erfme     TYPE mseg-erfme,
          mblnr     TYPE mseg-mblnr,
          mjahr     TYPE mseg-mjahr,
          ebeln     TYPE mseg-ebeln,
        END OF ninv1.

DATA : it_tab1    TYPE TABLE OF itab1,
       wa_tab1    TYPE itab1,
       it_tab2    TYPE TABLE OF itab1,
       wa_tab2    TYPE itab1,
       it_tab3    TYPE TABLE OF itab3,
       wa_tab3    TYPE itab3,
*       IT_TAB4    TYPE TABLE OF ITAB4,
*       WA_TAB4    TYPE ITAB4,
*       IT_TAB4    TYPE TABLE OF ZMB90_2A,
*       WA_TAB4    TYPE ZMB90_2A,
*       IT_TAB5    TYPE TABLE OF ZMB90_2A,
*       WA_TAB5    TYPE ZMB90_2A,
*       IT_TAB4    TYPE TABLE OF ZMB90_2b,
*       WA_TAB4    TYPE ZMB90_2b,
*       IT_TAB5    TYPE TABLE OF ZMB90_2b,
*       WA_TAB5    TYPE ZMB90_2b,

       it_tab4    TYPE TABLE OF zmb90_2b1,
       wa_tab4    TYPE zmb90_2b1,
       it_tab5    TYPE TABLE OF zmb90_2b1,
       wa_tab5    TYPE zmb90_2b1,

       it_bt1     TYPE TABLE OF bt1,
       wa_bt1     TYPE bt1,
       it_doc1    TYPE TABLE OF doc1,
       wa_doc1    TYPE doc1,
       it_hrp1000 TYPE TABLE OF hrp1000,
       wa_hrp1000 TYPE hrp1000,
       it_pa0001  TYPE TABLE OF pa0001,
       wa_pa0001  TYPE pa0001,
       it_ninv1   TYPE TABLE OF ninv1,
       wa_ninv1   TYPE ninv1,
*       IT_NINV2   TYPE TABLE OF NINV1,
*       WA_NINV2   TYPE NINV1,
*       IT_PO1     TYPE TABLE OF PO1,
*       WA_PO1     TYPE PO1.
       it_ninv2   TYPE TABLE OF zmb90_inv1,
       wa_ninv2   TYPE zmb90_inv1,
       it_po1     TYPE TABLE OF zmb90_inv2,
       wa_po1     TYPE zmb90_inv2.
DATA: scharg TYPE mseg-charg.  "batch no.
DATA: mblnr TYPE mseg-mblnr.
DATA: kunnr TYPE t001w-kunnr.
DATA: budat TYPE sy-datum,
      cputm TYPE sy-uzeit,
      bldat TYPE sy-datum,
      ebeln TYPE ekko-ebeln,
      ebelp TYPE ekpo-ebelp,
      aedat TYPE ekko-aedat,
      xblnr TYPE mkpf-xblnr.
DATA:  name_text TYPE  v_usr_name-name_text.
DATA: npage(1) TYPE c.
DATA: txt1(10) TYPE c.
DATA: lifnr TYPE mseg-lifnr,
      name1 TYPE adrc-name1.
DATA:  lgort TYPE  mseg-lgort.
DATA : cc           TYPE mseg-anln1,
*       maktx     type makt-maktx,
       maktx(98)    TYPE c,
       maktx1(40)   TYPE c,
       maktx2(40)   TYPE c,
       normt        TYPE mara-normt,
       mtart        TYPE mara-mtart,
*       LICHA       TYPE MCHA-LICHA,
       licha(25)    TYPE c,
       anzgeb       TYPE qals-anzgeb,
       prueflos     TYPE qals-prueflos,
       sgtxt        TYPE mseg-sgtxt,
       vfdat        TYPE mcha-vfdat,
       hsdat        TYPE mcha-hsdat,
*       V_NAME1      TYPE LFA1-NAME1,
       v_name1(100) TYPE c,
       vn_name1     TYPE lfa1-name1,
       vn_ort01     TYPE lfa1-ort01,
       asset(18)    TYPE c,
       bsart        TYPE ekko-bsart,
       rwerks       TYPE ekko-reswk,
       format1(100) TYPE c,
       trf(1)       TYPE c,
       vdatum       TYPE qave-vdatum.

DATA:  uname(40) TYPE c.
DATA: udate TYPE sy-datum,
      utime TYPE sy-uzeit.

DATA : mfgdt TYPE sy-datum.
DATA : BEGIN OF ritext1 OCCURS 0.
         INCLUDE STRUCTURE tline.
DATA : END OF ritext1.
DATA: checkbyname TYPE pa0001-ename,
      checkbydt   TYPE sy-datum,
      checkbytm   TYPE sy-uzeit,
      checkbydesg TYPE hrp1000-stext.

DATA : ln TYPE i.
DATA : ln1 TYPE i.
DATA : nolines TYPE i.
DATA: w_itext3(135) TYPE c,
      r11(1200)     TYPE c,
      r12(1200)     TYPE c.
DATA: rtdname1 LIKE stxh-tdname.
DATA: o_encryptor        TYPE REF TO cl_hard_wired_encryptor,
      o_cx_encrypt_error TYPE REF TO cx_encrypt_error.
DATA:
*      v_ac_xstring type xstring,
  v_en_string TYPE string,
*      v_en_xstring type xstring,
  v_de_string TYPE string,
*      v_de_xstring type string,
  v_error_msg TYPE string.
DATA: noninv TYPE i.

DATA : v_fm TYPE rs38l_fnam.
DATA: format(100) TYPE c.
DATA : control  TYPE ssfctrlop.
DATA : w_ssfcompop TYPE ssfcompop.
DATA: depth(1) TYPE c.
DATA : depthead TYPE pa0001-btrtl.

DATA: pernr    TYPE pa0001-pernr.
*SELECTION-SCREEN BEGIN OF BLOCK MERKMALE3 WITH FRAME TITLE TEXT-002. """RN
*  PARAMETERS : PERNR    TYPE PA0001-PERNR.
**             pass(10) type c.              """"""""""" NC
**PARAMETERS : phynr LIKE qprs-phynr.
*SELECTION-SCREEN END OF BLOCK MERKMALE3 .

SELECTION-SCREEN BEGIN OF BLOCK merkmale1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS : grn FOR mseg-mblnr .
  PARAMETERS : mblnr1 TYPE mseg-mblnr.
  PARAMETERS : year LIKE mseg-mjahr .
  PARAMETERS : plant LIKE mseg-werks .
  PARAMETERS :
*r1 RADIOBUTTON GROUP r1,
    r3  RADIOBUTTON GROUP r1 USER-COMMAND r2 DEFAULT 'X',
    r31 RADIOBUTTON GROUP r1,
    r2  RADIOBUTTON GROUP r1,
    r4  RADIOBUTTON GROUP r1,
    r41 RADIOBUTTON GROUP r1,
    r5  RADIOBUTTON GROUP r1,
    r6  RADIOBUTTON GROUP r1,
    r7  RADIOBUTTON GROUP r1.
SELECTION-SCREEN END OF BLOCK merkmale1 .

SELECTION-SCREEN BEGIN OF BLOCK merkmale2 WITH FRAME TITLE TEXT-002.
  SELECT-OPTIONS : po FOR ekpo-ebeln.
SELECTION-SCREEN END OF BLOCK merkmale2 .

INITIALIZATION.
  g_repid = sy-repid.

AT SELECTION-SCREEN OUTPUT.

  IF r31 EQ 'X'.
    LOOP AT SCREEN.
      IF screen-name CP '*MBLNR1*'.
        screen-active = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF screen-name CP '*GRN*'.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ELSEIF r6 EQ 'X'.
    LOOP AT SCREEN.
      IF screen-name CP '*MBLNR1*'.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF screen-name CP '*GRN*'.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    CALL   TRANSACTION 'MSC2N'. ""rn

  ELSEIF r41 EQ 'X'.
    LOOP AT SCREEN.
      IF screen-name CP '*MBLNR1*'.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF screen-name CP '*GRN*'.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    CALL TRANSACTION 'ZLABEL'.
  ELSEIF r7 EQ 'X'.
    LOOP AT SCREEN.
      IF screen-name CP '*MBLNR1*'.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF screen-name CP '*GRN*'.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    CALL TRANSACTION 'ZSTOCK_OUT'.
  ELSE.

    LOOP AT SCREEN.
      IF screen-name CP '*MBLNR1*'.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF screen-name CP '*GRN*'.
        screen-active = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

  LOOP AT SCREEN.
    CHECK screen-name EQ 'PASS'.
    screen-invisible = 1.
    MODIFY SCREEN.
  ENDLOOP.



START-OF-SELECTION.

  SELECT SINGLE pernr   FROM pa0105                                        "Added by Jayesh
         INTO pernr
         WHERE usrid = sy-uname.


  IF r6 EQ 'X'.
    CALL   TRANSACTION 'ZMSC2N'.

  ELSEIF r41 EQ 'X'.
    CALL TRANSACTION 'ZLABEL'.
  ELSEIF r7 EQ 'X'.
    CALL TRANSACTION 'ZSTOCK_OUT'.
  ELSE.

    PERFORM pass.
    CLEAR : uname.
    SELECT SINGLE * FROM pa0002 WHERE endda GE sy-datum. """ PERNR EQ PERNR AND ENDDA GE SY-DATUM.  "RN
    IF sy-subrc EQ 0.
      CONCATENATE pa0002-vorna pa0002-nachn INTO uname SEPARATED BY space.
    ENDIF.
    uname = sy-uname. "added by rushi 25.09.25
    udate = sy-datum.
    utime = sy-uzeit.

    IF r5 EQ 'X'.
      IF po IS INITIAL.
        MESSAGE 'ENTER PO NUMBER' TYPE 'E'.
      ENDIF.
      PERFORM poview.
    ELSEIF r31 EQ 'X'.
      IF mblnr1 IS INITIAL.
        MESSAGE 'ENTER GRN NUMBER' TYPE 'E'.
      ENDIF.
      IF year IS INITIAL.
        MESSAGE 'ENTER YEAR' TYPE 'E'.
      ENDIF.
      IF plant IS INITIAL.
        MESSAGE 'ENTER PLANT' TYPE 'E'.
      ENDIF.

      SELECT SINGLE * FROM mkpf WHERE mblnr EQ mblnr1 AND mjahr EQ year AND usnam EQ sy-uname."9.2.25
      IF sy-subrc EQ 0.
        MESSAGE 'MAKE & CHECKER SAP LOGIN CAN NOT BE SAME' TYPE 'E'.
      ENDIF.

*      IF GRN-LOW IS INITIAL.
*        MESSAGE 'ENTER GRN NUMBER' TYPE 'E'.
*      ENDIF.
*      IF GRN-HIGH IS NOT INITIAL.
*        MESSAGE 'ENTER SINGLE GRN NUMBER' TYPE 'E'.
*      ENDIF.
      PERFORM grncheck.
    ELSE.
      IF grn IS INITIAL.
        MESSAGE 'ENTER GRN NUMBER' TYPE 'E'.
      ENDIF.
      IF year IS INITIAL.
        MESSAGE 'ENTER YEAR' TYPE 'E'.
      ENDIF.
      IF plant IS INITIAL.
        MESSAGE 'ENTER PLANT' TYPE 'E'.
      ENDIF.
    ENDIF.

    mfgdt+6(2) = '14'.
    mfgdt+4(2) = '07'.
    mfgdt+0(4) = '2020'.

    IF r2 EQ 'X'.
      PERFORM non_inv.
    ELSEIF r3 EQ 'X'.
      PERFORM inv.
    ELSEIF r4 EQ 'X'.

      SELECT SINGLE * FROM pa0105 INTO @DATA(wa_pa0105)
                                       WHERE usrid = @sy-uname.



      IF sy-subrc NE 0.
*      IF SY-UNAME NE 'ITBOM01'.
        MESSAGE 'NOT VALID USER' TYPE 'E'.
      ENDIF.
      PERFORM invothr.
    ENDIF.
  ENDIF.

FORM non_inv.

  SELECT * FROM mseg INTO TABLE it_mseg WHERE mblnr IN grn AND mjahr EQ year AND werks EQ plant
    AND bwart EQ '101'.  "added on 15.7.20
  IF sy-subrc EQ 0.

    SELECT * FROM ekko INTO TABLE it_ekko FOR ALL ENTRIES IN it_mseg WHERE ebeln EQ it_mseg-ebeln AND  bukrs EQ '1000'. " bukrs eq 'BCLL'
    " AND BSART IN ('ZNIV','ZI','ZSER').                           Commented by Jayesh
  ENDIF.
  SORT it_mseg.
  it_mseg1 = it_mseg.
  DELETE ADJACENT DUPLICATES FROM it_mseg COMPARING mblnr mjahr.

  LOOP AT it_mseg1 INTO wa_mseg1.
    READ TABLE it_ekko INTO wa_ekko WITH KEY ebeln = wa_mseg1-ebeln.
    IF sy-subrc EQ 0.
*      SELECT SINGLE * FROM EKPO WHERE EBELN EQ WA_EKKO-EBELN AND
*    WRITE : / '*',WA_MSEG-MBLNR.
      wa_tab1-mblnr = wa_mseg1-mblnr.
      wa_tab1-mjahr = wa_mseg1-mjahr.
      wa_tab1-ebeln = wa_mseg1-ebeln.
      wa_tab1-werks = wa_mseg1-werks.
      wa_tab1-ekgrp = wa_ekko-ekgrp.

      IF wa_mseg1-lifnr NE '          '.
        wa_tab1-lifnr = wa_mseg1-lifnr.
      ELSE.
        SELECT SINGLE * FROM mseg WHERE mblnr EQ wa_mseg1-mblnr AND mjahr EQ wa_mseg1-mjahr AND lifnr NE '          '.
        IF sy-subrc EQ 0.
          wa_tab1-lifnr = mseg-lifnr.
        ENDIF.
      ENDIF.
      COLLECT wa_tab1 INTO it_tab1.
      CLEAR wa_tab1.
    ENDIF.
  ENDLOOP.
*  BREAK-POINT.

  LOOP AT it_tab1 INTO wa_tab1.
    READ TABLE it_ekko INTO wa_ekko WITH KEY ebeln = wa_tab1-ebeln bsart = 'ZNIV'.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM qals WHERE mblnr EQ wa_tab1-mblnr AND mjahr EQ wa_tab1-mjahr.
      IF sy-subrc EQ 0.
        DELETE it_tab1 WHERE ebeln EQ wa_ekko-ebeln.
      ENDIF.
    ENDIF.
  ENDLOOP.


  LOOP AT it_tab1 INTO wa_tab1.
*  WRITE : / wa_tab1-mblnr,wa_tab1-mjahr,wa_tab1-ebeln.
    wa_tab2-mblnr = wa_tab1-mblnr.
    wa_tab2-mjahr = wa_tab1-mjahr.
    wa_tab2-ebeln = wa_tab1-ebeln.
    SELECT SINGLE * FROM ekko WHERE ebeln EQ wa_tab1-ebeln.
    IF sy-subrc EQ 0.
      wa_tab2-aedat = ekko-aedat.
    ENDIF.
    SELECT SINGLE * FROM mkpf WHERE mblnr EQ wa_tab1-mblnr AND mjahr EQ wa_tab1-mjahr.
    IF sy-subrc EQ 0.
      wa_tab2-budat = mkpf-budat.
      wa_tab2-xblnr = mkpf-xblnr.
      wa_tab2-bldat = mkpf-bldat.
    ENDIF.
*  WRITE : / 'plant', wa_tab1-werks.
    wa_tab2-werks = wa_tab1-werks.
    SELECT SINGLE * FROM t001w WHERE werks EQ wa_tab1-werks.
    IF sy-subrc EQ 0.
      IF wa_tab1-werks EQ '1000' OR wa_tab1-werks EQ '1001'.
        wa_tab2-w_name1 = 'BLUE CROSS LABORATORIES PVT LTD.'.
      ELSE.
*    WRITE : / 'description',t001w-name1.
        wa_tab2-w_name1 = t001w-name1.
      ENDIF.
    ENDIF.
*  WRITE : / 'Vendor',wa_tab1-lifnr.
    wa_tab2-lifnr = wa_tab1-lifnr.
    SELECT SINGLE * FROM lfa1 WHERE lifnr EQ wa_tab1-lifnr.
    IF sy-subrc EQ 0.
*    WRITE : / 'Name', lfa1-name1.
      wa_tab2-v_name1 = lfa1-name1.
    ENDIF.
*  WRITE : / 'PO no.',wa_tab1-ebeln.
    wa_tab2-ebeln = wa_tab1-ebeln.
*  WRITE : / 'Pur. group:',wa_tab1-ekgrp.
    wa_tab2-ekgrp = wa_tab1-ekgrp.
    SELECT SINGLE * FROM t024 WHERE ekgrp EQ wa_tab1-ekgrp.
    IF sy-subrc EQ 0.
*    WRITE : t024-eknam.
      wa_tab2-eknam = t024-eknam.
    ENDIF.
    COLLECT wa_tab2 INTO it_tab2.
    CLEAR wa_tab2.
  ENDLOOP.



  LOOP AT it_tab2 INTO wa_tab2.
    LOOP AT it_mseg1 INTO wa_mseg1 WHERE mblnr EQ wa_tab2-mblnr AND mjahr EQ wa_tab2-mjahr AND ebeln EQ wa_tab2-ebeln.
      SELECT SINGLE * FROM ekpo WHERE ebeln EQ wa_tab2-ebeln AND ebelp EQ wa_mseg1-ebelp AND knttp IN ('K','A').
      IF sy-subrc EQ 0.
        wa_ninv1-mblnr = wa_tab2-mblnr.
        wa_ninv1-mjahr = wa_tab2-mjahr.
        wa_ninv1-ebeln = wa_tab2-ebeln.
        wa_ninv1-sgtxt = ekpo-txz01.
        wa_ninv1-knttp = ekpo-knttp.
        CLEAR :cc,asset.
        IF ekpo-knttp = 'A'.
          CONCATENATE wa_mseg1-anln1 wa_mseg1-anln2 INTO asset SEPARATED BY space.
          CONDENSE asset.
        ELSE.
          asset = wa_mseg1-kostl.
        ENDIF.
        wa_ninv1-asset = asset.
        wa_ninv1-erfmg = wa_mseg1-erfmg.
        wa_ninv1-erfme = wa_mseg1-erfme.
        wa_ninv1-zeile = wa_mseg1-zeile.
        COLLECT wa_ninv1 INTO it_ninv1.
        CLEAR wa_ninv1.
      ENDIF.
    ENDLOOP.
  ENDLOOP.
  DATA : wa_t001w2 TYPE t001w-ort01. ""added rushi

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZMB90_INV2_1'
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
      fm_name            = v_fm
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.

  control-no_open   = 'X'.
  control-no_close  = 'X'.

  CALL FUNCTION 'SSF_OPEN'
    EXPORTING
      control_parameters = control.
*  loop at it_tab2 into wa_tab2.
  LOOP AT it_mseg INTO wa_mseg.
    PERFORM data1.
    CLEAR : mblnr,checkbyname,checkbydt,checkbytm.
    mblnr = wa_mseg-mblnr.
    mjahr = wa_mseg-mjahr.
*    PERFORM FORM1.
    SELECT SINGLE * FROM t001w WHERE werks EQ plant.
    IF sy-subrc EQ 0.
      kunnr = t001w-kunnr.
    ENDIF.
    SELECT SINGLE * FROM zmigo_chk WHERE mblnr EQ mblnr.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ zmigo_chk-pernr AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        checkbyname = pa0001-ename.
        checkbydt = zmigo_chk-cpudt.
        checkbytm = zmigo_chk-cputm.
        SELECT SINGLE * FROM hrp1000 WHERE objid = pa0001-plans AND endda GE sy-datum AND langu EQ 'EN'.
        IF sy-subrc EQ 0.
          checkbydesg = hrp1000-stext.
        ENDIF.
        IF checkbydesg EQ space.
          CLEAR : it_hrp1000,wa_hrp1000,it_pa0001,wa_pa0001.
          SELECT * FROM pa0001 INTO TABLE it_pa0001 WHERE pernr EQ zmigo_chk-pernr AND plans NE '99999999'.
          SORT it_pa0001 DESCENDING BY endda.
          SELECT * FROM hrp1000 INTO TABLE it_hrp1000 FOR ALL ENTRIES IN it_pa0001 WHERE objid EQ it_pa0001-plans AND langu EQ 'EN'.
          SORT it_hrp1000 DESCENDING BY endda.
          READ TABLE it_hrp1000 INTO wa_hrp1000 WITH KEY langu = 'EN'.
          IF sy-subrc EQ 0.
            checkbydesg = wa_hrp1000-stext.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    CLEAR: budat,bldat,xblnr,name_text,lifnr,ebeln,aedat,cputm.
    SELECT SINGLE * FROM mkpf WHERE mblnr EQ mblnr.
    IF sy-subrc EQ 0.
      budat = mkpf-budat.
      bldat = mkpf-bldat.
      cputm = mkpf-cputm.
      xblnr = mkpf-xblnr.
      SELECT SINGLE * FROM  v_usr_name WHERE bname EQ mkpf-usnam.
      IF sy-subrc EQ 0.
        name_text = v_usr_name-name_text.
      ENDIF.
    ENDIF.
    SELECT SINGLE * FROM mseg WHERE mblnr EQ mblnr AND ebeln = wa_tab2-ebeln AND lifnr NE space.
    IF sy-subrc EQ 0.
      lifnr = mseg-lifnr.
      SELECT SINGLE * FROM lfa1 WHERE lifnr EQ lifnr.
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM adrc WHERE addrnumber EQ lfa1-adrnr.
        IF sy-subrc EQ 0.
          name1 = adrc-name1.
        ENDIF.
      ENDIF.
    ENDIF.
    SELECT SINGLE * FROM mseg WHERE mblnr EQ mblnr AND ebeln EQ wa_tab2-ebeln.
    IF sy-subrc EQ 0.
      ebeln = mseg-ebeln.
      SELECT SINGLE * FROM ekko WHERE ebeln EQ mseg-ebeln.
      IF sy-subrc EQ 0.
        aedat = ekko-aedat.
      ENDIF.
    ENDIF.

    lgort = wa_tab2-lgort.
    plant = wa_tab2-werks.


    uname = sy-uname.                        "Added by Jayesh
    udate = sy-datum.
    utime = sy-uzeit.

    CALL FUNCTION v_fm
      EXPORTING
        control_parameters = control
        user_settings      = 'X'
        output_options     = w_ssfcompop
        format             = format1
        kunnr              = kunnr      "Changed by Jayesh
        mblnr              = mblnr
        budat              = budat
        bldat              = bldat
        xblnr              = xblnr
        ebeln              = ebeln
        aedat              = aedat
        lgort              = lgort
        plant              = plant
        name_text          = name_text
        npage              = npage
        txt1               = txt1
        lifnr              = lifnr
        uname              = uname
        udate              = udate
        utime              = utime
        checkbyname        = checkbyname
        checkbydt          = checkbydt
        checkbytm          = checkbytm
        checkbydesg        = checkbydesg
        name1              = name1
        cputm              = cputm
        wa_t001w2          = wa_t001w2 ""rushi
      TABLES
        it_tab1            = it_ninv2
        it_tab2            = it_po1
*       itab_division      = itab_division
*       itab_storage       = itab_storage
*       itab_pa0002        = itab_pa0002
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.


  ENDLOOP.

  CLEAR : format, kunnr,mblnr,budat,bldat,xblnr,ebeln,aedat,lgort,plant,name_text, npage,txt1,lifnr.
  CLEAR : it_ninv1,wa_ninv1,it_ninv2,wa_ninv2.
  CALL FUNCTION 'SSF_CLOSE'.
ENDFORM.

FORM inv.

  SELECT * FROM mseg INTO TABLE it_mseg WHERE mblnr IN grn AND mjahr EQ year AND werks EQ plant
     AND bwart EQ '101'. "added on 15.7.20
  IF sy-subrc EQ 0.
    SELECT * FROM ekko INTO TABLE it_ekko FOR ALL ENTRIES IN it_mseg WHERE ebeln EQ it_mseg-ebeln AND bukrs EQ '1000'. "  bukrs eq 'BCLL'
*      and bsart in ('ZL','ZI', 'ZUB','ZTRF','ZNIV' ). "Commented By Varsha 15-09-2025
  ENDIF.

  SORT it_mseg BY mblnr ebeln.
  it_mseg1 = it_mseg.
  DELETE ADJACENT DUPLICATES FROM it_mseg COMPARING mblnr ebeln.

  LOOP AT it_mseg INTO wa_mseg.
    READ TABLE it_ekko INTO wa_ekko WITH KEY ebeln = wa_mseg-ebeln.
    IF sy-subrc EQ 0.
*    WRITE : / '*',WA_MSEG-MBLNR.
      wa_tab1-mblnr = wa_mseg-mblnr.
      wa_tab1-mjahr = wa_mseg-mjahr.
      wa_tab1-ebeln = wa_mseg-ebeln.
      wa_tab1-werks = wa_mseg-werks.
      wa_tab1-ekgrp = wa_ekko-ekgrp.
      wa_tab1-bedat = wa_ekko-bedat.
      wa_tab1-lgort = wa_mseg-lgort.
*    WA_TAB1-MATNR = WA_MSEG-MATNR.
*    wa_tab1-sgtxt = wa_mseg-sgtxt.
      SELECT SINGLE * FROM j_1ipart1 WHERE mblnr EQ wa_mseg-mblnr AND mjahr EQ wa_mseg-mjahr.
      IF sy-subrc EQ 0.
        wa_tab1-docno = j_1ipart1-docno.
        wa_tab1-docyr = j_1ipart1-docyr.
      ENDIF.
      SELECT SINGLE * FROM t001l WHERE werks EQ wa_mseg-werks AND lgort EQ wa_mseg-lgort.
      IF sy-subrc EQ 0.
        wa_tab1-lgobe = t001l-lgobe.
      ENDIF.

      IF wa_mseg-lifnr NE '          '.
        wa_tab1-lifnr = wa_mseg-lifnr.
      ELSE.
*      select single * from mseg where mblnr eq wa_mseg-mblnr and mjahr eq wa_mseg-mjahr and lifnr ne '          '.
*      if sy-subrc eq 0.
*        wa_tab1-lifnr = mseg-lifnr.
*      endif.
        SELECT SINGLE * FROM qals WHERE matnr EQ wa_mseg-matnr AND charg EQ wa_mseg-charg AND sellifnr NE '          '.
        IF sy-subrc EQ 0.
          wa_tab1-lifnr = qals-sellifnr.
        ENDIF.
      ENDIF.
      IF wa_tab1-lifnr EQ space.
        SELECT SINGLE * FROM mch1 WHERE matnr EQ wa_mseg-matnr AND charg EQ wa_mseg-charg AND lifnr GE '0000010000' AND lifnr LE '0000029999'.
        IF sy-subrc EQ 0.
          wa_tab1-lifnr = mch1-lifnr.
        ENDIF.
      ENDIF.

      SELECT SINGLE * FROM j_1iexcdtl WHERE werks EQ wa_mseg-werks AND matnr EQ wa_mseg-matnr AND charg EQ wa_mseg-charg AND rdoc1 EQ wa_mseg-ebeln
        AND ritem1 EQ wa_mseg-ebelp.
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM j_1iexchdr WHERE docyr EQ j_1iexcdtl-docyr AND docno EQ j_1iexcdtl-docno.
        IF sy-subrc EQ 0.
          wa_tab1-exnum = j_1iexchdr-exnum.
          wa_tab1-exbed = j_1iexchdr-exbed.
          wa_tab1-exdat = j_1iexchdr-exdat.
        ENDIF.

      ENDIF.
*       DATA : BATCH_DETAILS    TYPE TABLE OF CLBATCH,
*              WA_BATCH_DETAILS TYPE CLBATCH,
*              Batchno          TYPE ATWTB.
*
*
*      CALL FUNCTION 'VB_BATCH_GET_DETAIL'
*        EXPORTING
*          MATNR              = WA_MSEG-MATNR
*          CHARG              = WA_MSEG-CHARG
*          WERKS              = WA_MSEG-WERKS
*          GET_CLASSIFICATION = 'X'
**         EXISTENCE_CHECK    =
**         READ_FROM_BUFFER   =
**         NO_CLASS_INIT      = ' '
**         LOCK_BATCH         = ' '
**       IMPORTING
**         YMCHA              =
**         CLASSNAME          =
**         BATCH_DEL_FLG      =
*        TABLES
*          CHAR_OF_BATCH      = BATCH_DETAILS
*        EXCEPTIONS
*          NO_MATERIAL        = 1
*          NO_BATCH           = 2
*          NO_PLANT           = 3
*          MATERIAL_NOT_FOUND = 4
*          PLANT_NOT_FOUND    = 5
*          NO_AUTHORITY       = 6
*          BATCH_NOT_EXIST    = 7
*          LOCK_ON_BATCH      = 8
*          OTHERS             = 9.
*      IF SY-SUBRC <> 0.
** Implement suitable error handling here
*      ENDIF.
*
*
*      READ TABLE BATCH_DETAILS INTO WA_BATCH_DETAILS WITH KEY ATNAM = 'ZVENDOR_BATCH'.
*      IF SY-SUBRC = 0 .
*       WA_TAB1-BATCHNO  = WA_BATCH_DETAILS-ATWTB.
*      ENDIF.
      DATA : wa_t001w2 TYPE t001w-ort01. ""Rushi

      COLLECT wa_tab1 INTO it_tab1.     "Final collect
      CLEAR wa_tab1.
      SELECT SINGLE ort01 FROM t001w INTO wa_t001w2  WHERE werks EQ wa_tab1-werks. ""Rushi
*
*        LOOP AT batch_details INTO wa_batch_details WHERE atnam = 'ZVENDOR_BATCH'.
*          Batchno = wa_batch_details-ATWTB .
*
*        ENDLOOP.
    ENDIF.

  ENDLOOP.




  DATA : lt_ekpo TYPE ekpo, "ADDED BY RUSHI
         lt_lfa1 TYPE lfa1.
  DATA :wa_lfa1_name1 TYPE lfa1-name1,
        lv_mfg        TYPE string.

  DATA : wa_t001w TYPE t001w-ort01.

  SELECT * FROM ekpo INTO lt_ekpo WHERE ebeln = wa_mseg-ebeln AND ebelp = wa_mseg-ebelp .
  ENDSELECT.
  IF lt_ekpo IS NOT INITIAL .
    SELECT SINGLE name1 FROM lfa1 INTO wa_lfa1_name1 WHERE lifnr = lt_ekpo-mfrnr.

  ENDIF.
  lv_mfg = wa_lfa1_name1.


  LOOP AT it_tab1 INTO wa_tab1.
    READ TABLE it_ekko INTO wa_ekko WITH KEY ebeln = wa_tab1-ebeln bsart = 'ZNIV'.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM qals WHERE mblnr EQ wa_tab1-mblnr AND mjahr EQ wa_tab1-mjahr.
      IF sy-subrc EQ 4.
        DELETE it_tab1 WHERE ebeln EQ wa_ekko-ebeln.
      ENDIF.
    ENDIF.
  ENDLOOP.

*  BREAK-POINT .

  LOOP AT it_tab1 INTO wa_tab1.
*  WRITE : / wa_tab1-mblnr,wa_tab1-mjahr,wa_tab1-ebeln.
    wa_tab2-mblnr = wa_tab1-mblnr.
    wa_tab2-mjahr = wa_tab1-mjahr.
    wa_tab2-ebeln = wa_tab1-ebeln.
    wa_tab2-exnum = wa_tab1-exnum.
    wa_tab2-exbed = wa_tab1-exbed.
    wa_tab2-exdat = wa_tab1-exdat.
    wa_tab2-bedat = wa_tab1-bedat.
    wa_tab2-lgort = wa_tab1-lgort.
    wa_tab2-lgobe = wa_tab1-lgobe.
    wa_tab2-docno = wa_tab1-docno.
    wa_tab2-docyr = wa_tab1-docyr.
*  WA_TAB2-MATNR = WA_TAB1-MATNR.
*  wa_tab2-sgtxt = wa_tab1-sgtxt.
    SELECT SINGLE * FROM mkpf WHERE mblnr EQ wa_tab1-mblnr AND mjahr EQ wa_tab1-mjahr.
    IF sy-subrc EQ 0.
*    WRITE : / 'Goods receipt date',mkpf-budat.
*    WRITE : / 'Current date',sy-datum.
*    WRITE : / 'Challan no',mkpf-xblnr,mkpf-bldat.
      wa_tab2-budat = mkpf-budat.
      wa_tab2-xblnr = mkpf-xblnr.
      wa_tab2-bldat = mkpf-bldat.
    ENDIF.
*  WRITE : / 'plant', wa_tab1-werks.
    wa_tab2-werks = wa_tab1-werks.
    SELECT SINGLE * FROM t001w WHERE werks EQ wa_tab1-werks.
    IF sy-subrc EQ 0.
*    if wa_tab1-werks eq '1000' or wa_tab1-werks eq '1001'.
*      wa_tab2-w_name1 = 'BLUE CROSS LABORATORIES PVT LTD.'.
*    else.
*    WRITE : / 'description',t001w-name1.
      wa_tab2-w_name1 = t001w-name1.
*    endif.
    ENDIF.
*  WRITE : / 'Vendor',wa_tab1-lifnr.
    wa_tab2-lifnr = wa_tab1-lifnr.
    SELECT SINGLE * FROM lfa1 WHERE lifnr EQ wa_tab1-lifnr.
    IF sy-subrc EQ 0.
*    WRITE : / 'Name', lfa1-name1.
      wa_tab2-v_name1 = lfa1-name1.
    ENDIF.
**    IF  wa_tab2-v_name1 EQ space.
*    select single * from ekko where ebeln eq wa_tab1-ebeln and bsart eq 'ZUB'.
*    if sy-subrc eq 0.
*      select single * from t001w where werks eq ekko-reswk.
*      if sy-subrc eq 0.
*        wa_tab2-v_name1 = t001w-name1.
*      endif.
*    else.
*      select single * from lfa1 where lifnr eq wa_tab1-lifnr.
*      if sy-subrc eq 0.
**        WRITE : / 'Name', lfa1-name1.
*        wa_tab2-v_name1 = lfa1-name1.
*      endif.
*    endif.
**    ENDIF.
*  WRITE : / 'PO no.',wa_tab1-ebeln.
    wa_tab2-ebeln = wa_tab1-ebeln.
*  WRITE : / 'Pur. group:',wa_tab1-ekgrp.
    wa_tab2-ekgrp = wa_tab1-ekgrp.
    SELECT SINGLE * FROM t024 WHERE ekgrp EQ wa_tab1-ekgrp.
    IF sy-subrc EQ 0.
*    WRITE : t024-eknam.
      wa_tab2-eknam = t024-eknam.
    ENDIF.
    SELECT SINGLE * FROM t001w WHERE werks EQ wa_tab1-werks.
    IF sy-subrc EQ 0.
      wa_tab2-kunnr = t001w-kunnr.
    ENDIF.

    COLLECT wa_tab2 INTO it_tab2.
    CLEAR wa_tab2.

    SELECT SINGLE ort01 FROM t001w INTO wa_t001w  WHERE werks EQ wa_tab1-werks.

  ENDLOOP.


  IF r3 EQ 'X'.
    SORT it_tab2 BY mblnr ebeln .
    LOOP AT it_tab2 INTO wa_tab2.
      CLEAR : v_name1,vn_name1,vn_ort01,bsart,format1.

      IF it_mseg1 IS NOT INITIAL.
        SELECT * FROM qals INTO TABLE it_qals FOR ALL ENTRIES IN it_mseg1 WHERE werk EQ it_mseg1-werks AND matnr EQ it_mseg1-matnr AND
          charg EQ it_mseg1-charg AND ebeln EQ it_mseg1-ebeln.
      ENDIF.
      SORT it_qals DESCENDING BY enstehdat entstezeit.
*************************************************************************
      SELECT SINGLE * FROM ekko WHERE ebeln EQ wa_tab2-ebeln AND bsart EQ 'ZSTO'. " changed in zub to zsto
      IF sy-subrc EQ 0.
        IF it_mseg1 IS NOT INITIAL.
          SELECT * FROM mcha INTO TABLE it_mcha FOR ALL ENTRIES IN it_mseg1 WHERE charg EQ it_mseg1-charg AND lifnr NE space.
        ENDIF.
        LOOP AT it_mcha INTO wa_mcha.
          CLEAR : mjahr .
          wa_bt1-charg = wa_mcha-charg.
          wa_bt1-mjahr = wa_mcha-ersda+0(4).
          COLLECT wa_bt1 INTO it_bt1.
          CLEAR wa_bt1.
        ENDLOOP.



        IF it_mseg1 IS NOT INITIAL.
          SELECT * FROM mseg INTO TABLE it_mseg2 FOR ALL ENTRIES IN it_mseg1 WHERE
*            WERKS EQ IT_MSEG1-WERKS AND  "19.5.21
             matnr EQ it_mseg1-matnr AND
            charg EQ it_mseg1-charg AND bwart EQ '101' AND lifnr NE space AND ebeln EQ it_mseg1-ebeln.
          SORT it_mseg2  DESCENDING BY mblnr.
        ENDIF.

**********************************

        IF it_mseg2 IS INITIAL.
          IF it_mseg1 IS NOT INITIAL.
            READ TABLE it_mcha INTO wa_mcha WITH KEY charg = wa_mseg1-charg.
            IF sy-subrc EQ 0.
              CLEAR : mjahr.
              mjahr = wa_mcha-ersda+0(4).
*              SELECT * FROM MSEG INTO TABLE IT_MSEG3 FOR ALL ENTRIES IN IT_MSEG1 WHERE MJAHR EQ MJAHR AND CHARG EQ IT_MSEG1-CHARG AND BWART EQ '101' AND LIFNR NE SPACE.
*              SORT IT_MSEG3  DESCENDING BY MBLNR.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
*****************************************************************************
      SORT it_mseg1 BY mblnr ebeln ebelp.
*********************************************************************************
      IF it_mseg1 IS NOT INITIAL.
        SELECT * FROM mcha INTO TABLE it_mcha1 FOR ALL ENTRIES IN it_mseg1 WHERE charg EQ it_mseg1-charg AND lifnr NE space.
      ENDIF.
      SORT it_mcha1 BY ersda.
      IF it_mcha1 IS NOT INITIAL.
        SELECT * FROM mseg INTO TABLE it_mseg3 FOR ALL ENTRIES IN it_mcha1 WHERE bwart EQ '101' AND matnr EQ it_mcha1-matnr AND werks EQ it_mcha1-werks
          AND charg EQ it_mcha1-charg.
      ENDIF.
*      loop at it_mcha1 into wa_mcha1.
*
*      endloop.
******************************************************************************************

      LOOP AT it_mseg1 INTO wa_mseg1 WHERE mblnr EQ wa_tab2-mblnr AND mjahr EQ wa_tab2-mjahr AND ebeln EQ wa_tab2-ebeln.
        CLEAR : maktx,licha,anzgeb,prueflos,sgtxt,vfdat,hsdat,v_name1, bsart, rwerks.
        SELECT SINGLE * FROM ekpo WHERE ebeln EQ wa_tab2-ebeln AND ebelp EQ wa_mseg1-ebelp.
        IF sy-subrc EQ 0.
          IF ekpo-knttp NE 'A' OR ekpo-knttp NE 'A'.
            ekpo-knttp = ekpo-knttp.
            CLEAR : maktx, normt,maktx1,maktx2.
            SELECT SINGLE * FROM makt WHERE spras EQ 'EN' AND matnr EQ wa_mseg1-matnr.
            IF sy-subrc EQ 0.
              maktx1 = makt-maktx.
            ENDIF.
            SELECT SINGLE * FROM makt WHERE spras EQ 'Z1' AND matnr EQ wa_mseg1-matnr.  "9.12.20
            IF sy-subrc EQ 0.
              maktx2 = makt-maktx.
            ENDIF.
            CONCATENATE maktx1 maktx2 INTO maktx SEPARATED BY space.
            SELECT SINGLE * FROM mara WHERE matnr EQ wa_mseg1-matnr.
            IF sy-subrc EQ 0.
              normt = mara-normt.
              mtart = mara-mtart.
            ENDIF.
            CONDENSE : maktx, normt.
            CONCATENATE maktx normt INTO maktx SEPARATED BY ','.
******************************************************************* NEW CHANGE ON 4.1.22*****************
*            SELECT SINGLE * FROM ekko WHERE ebeln EQ wa_mseg1-ebeln.
*            IF sy-subrc EQ 0.
*              SELECT SINGLE * FROM zpo_matnr WHERE matnr EQ wa_mseg1-matnr.
**                 AND EFFECTDT GE EKKO-AEDAT.
*              IF sy-subrc EQ 0.
*                IF ekko-aedat GE zpo_matnr-effectdt.
*                  maktx = ekpo-txz01.
*                  normt = space.
*                ENDIF.
*              ENDIF.
*            ENDIF.
*            BREAK-POINT .
            SELECT SINGLE * FROM ekko WHERE ebeln EQ wa_mseg1-ebeln.
            IF sy-subrc EQ 0.
              SELECT SINGLE * FROM ekpa WHERE ebeln EQ wa_mseg1-ebeln AND parvw EQ 'HR'.
              IF sy-subrc EQ 0.
                SELECT SINGLE * FROM zpo_matnr WHERE matnr EQ wa_mseg1-matnr AND lifnr EQ ekpa-lifn2.
*                 AND EFFECTDT GE EKKO-AEDAT.
                IF sy-subrc EQ 0.
                  IF ekko-aedat GE zpo_matnr-effectdt.
*                  MAKTX = EKPO-TXZ01.
                    maktx = zpo_matnr-maktx.
                    normt = space.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.

*

*    WRITE : / '*', wa_mseg1-zeile,wa_mseg1-sgtxt.
            CLEAR cc.
            IF ekpo-knttp = 'A'.
              wa_mseg1-kostl = wa_mseg1-anln1+2(10).
            ENDIF.
            SELECT SINGLE * FROM mch1 WHERE matnr EQ wa_mseg1-matnr AND charg EQ wa_mseg1-charg ."changes by rushi 16.09.25
*              and werks eq wa_mseg1-werks and charg eq wa_mseg1-charg.
            IF sy-subrc EQ 0.
              licha = mch1-licha.
              vfdat = mch1-vfdat.
              hsdat = mch1-hsdat.
            ENDIF.
*************************** VENDOR BATCH*********************************************************************************************************
            CLEAR : rtdname1.
            CONCATENATE wa_mseg1-matnr wa_mseg1-werks wa_mseg1-charg INTO rtdname1.
*            RTDNAME1 = '00000000000010010010000000108421'.

            CALL FUNCTION 'READ_TEXT'
              EXPORTING
                client                  = sy-mandt
                id                      = 'VERM'
                language                = 'E'
                name                    = rtdname1
                object                  = 'CHARGE'
*               ARCHIVE_HANDLE          = 0
*            IMPORTING
*               HEADER                  = THEAD
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
            IF wa_tab2-budat GE '20200914'.
              IF licha+0(15) = r11+0(15).  "11.9.20  "long vendor batch
                licha = r11.
              ENDIF.
            ENDIF.
**************************************************************************************************************************
*            sgtxt = wa_mseg1-sgtxt.
            SELECT SINGLE * FROM ekko WHERE ebeln EQ wa_tab2-ebeln.
            IF sy-subrc EQ 0.
              bsart = ekko-bsart.
              rwerks = ekko-reswk.
            ENDIF.
*            IF MTART EQ 'ZROH' AND BSART EQ 'ZL'.
            IF mtart EQ 'ZROH' AND ( bsart EQ 'ZL' OR bsart EQ 'ZI' ).

              IF wa_tab2-budat GE mfgdt.

                SELECT SINGLE * FROM zmigo WHERE mblnr EQ wa_mseg1-mblnr AND zeile EQ wa_mseg1-zeile.
                IF sy-subrc EQ 0.
                  SELECT SINGLE * FROM lfa1 WHERE lifnr EQ zmigo-mfgr.
                  IF sy-subrc EQ 0.
                    sgtxt = lfa1-name1.  "25.4.20
                  ENDIF.
*                ELSE.
*                  SGTXT = LFA1-NAME1.  "25.4.20
                ENDIF.
*                IF SGTXT EQ SPACE.  15.7.20
*                  SGTXT = WA_MSEG1-SGTXT. " 3.7.20
*                ENDIF.
              ELSE.
                sgtxt = wa_mseg1-sgtxt.
              ENDIF.
              IF sgtxt EQ space.
                IF wa_tab2-budat LE '20210112'.
                  sgtxt = wa_mseg1-sgtxt.
                ENDIF.
              ENDIF.
            ELSE.
              IF mtart EQ 'ZROH'.
                IF wa_tab2-budat GE '20210131'.
                  READ TABLE it_mseg2 INTO wa_mseg2 WITH KEY matnr = wa_mseg1-matnr charg = wa_mseg1-charg.
                  IF sy-subrc EQ 0.
                    SELECT SINGLE * FROM zmigo WHERE mblnr EQ wa_mseg2-mblnr AND zeile EQ wa_mseg2-zeile.
                    IF sy-subrc EQ 0.
                      SELECT SINGLE * FROM lfa1 WHERE lifnr EQ zmigo-mfgr.
                      IF sy-subrc EQ 0.
                        sgtxt = lfa1-name1.  "25.4.20
                      ENDIF.
                    ELSE.
                      sgtxt = wa_mseg1-sgtxt.
                    ENDIF.
                  ELSE.
*                    READ TABLE IT_MSEG3 INTO WA_MSEG3 WITH KEY CHARG = WA_MSEG1-CHARG.
*                    IF SY-SUBRC EQ 0.
*                      SELECT SINGLE * FROM ZMIGO WHERE MBLNR EQ WA_MSEG3-MBLNR AND ZEILE EQ WA_MSEG3-ZEILE.
*                      IF SY-SUBRC EQ 0.
*                        SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ ZMIGO-MFGR.
*                        IF SY-SUBRC EQ 0.
*                          SGTXT = LFA1-NAME1.  "25.4.20
*                        ENDIF.
*                      ELSE.
*                        SGTXT = WA_MSEG1-SGTXT.
*                      ENDIF.
*                    ENDIF.

                  ENDIF.

                ELSE.
                  sgtxt = wa_mseg1-sgtxt.
                ENDIF.
              ELSE.
                sgtxt = wa_mseg1-sgtxt.
              ENDIF.
            ENDIF.

*            break-point.
            IF sgtxt EQ space.

              READ TABLE it_mseg3 INTO wa_mseg3 WITH KEY charg = wa_mseg1-charg.
              IF sy-subrc EQ 0.
                SELECT SINGLE * FROM zmigo WHERE mblnr EQ wa_mseg3-mblnr AND zeile EQ wa_mseg3-zeile.
                IF sy-subrc EQ 0.
                  SELECT SINGLE * FROM lfa1 WHERE lifnr EQ zmigo-mfgr.
                  IF sy-subrc EQ 0.
                    sgtxt = lfa1-name1.  "25.4.20
                  ENDIF.
                ELSE.
                  sgtxt = wa_mseg1-sgtxt.
                ENDIF.
              ENDIF.

            ENDIF.

*       SELECT SINGLE * FROM QALS WHERE MATNR EQ WA_MSEG1-MATNR AND WERK EQ WA_MSEG1-WERKS AND CHARG EQ WA_MSEG1-CHARG.
            READ TABLE it_qals INTO wa_qals WITH KEY werk = wa_mseg1-werks  matnr = wa_mseg1-matnr charg = wa_mseg1-charg mblnr = wa_mseg1-mblnr.
            IF sy-subrc EQ 0.
              anzgeb = wa_qals-anzgeb.
              prueflos = wa_qals-prueflos.
            ENDIF.
*      WA_MSEG1-KOSTL = WA_MSEG1-ANLN1.
*      2(10).
************************************
            CLEAR : vn_name1,vn_ort01,v_name1.

            IF bsart EQ 'ZSTO' AND  wa_tab2-budat GE mfgdt.  "as per AKG supplier will be sending plant 15.7.20 " change in zub to ZSTO 25.09.25
*              SELECT SINGLE * FROM T001W WHERE WERKS EQ RWERKS.
*              IF SY-SUBRC EQ 0.
*                V_NAME1 = T001W-NAME1.
*              ENDIF.
              SELECT SINGLE * FROM mch1 WHERE matnr EQ wa_mseg1-matnr AND charg EQ wa_mseg1-charg AND lifnr NE space.
              IF sy-subrc EQ 0.
                SELECT SINGLE * FROM lfa1 WHERE lifnr EQ mch1-lifnr.
                IF sy-subrc EQ 0.
                  vn_name1 = lfa1-name1.
                  vn_ort01 = lfa1-ort01.
                ENDIF.
              ENDIF.


*              if vn_name1 IS NOT INITIAL.
              SELECT SINGLE * FROM t001w WHERE werks EQ rwerks.
              IF sy-subrc EQ 0.
                v_name1 = t001w-name1.
                IF v_name1 IS NOT INITIAL.
                  CLEAR : vdatum.
                  SELECT SINGLE * FROM qave WHERE prueflos EQ prueflos.
                  IF sy-subrc EQ 0.
                    vdatum = qave-vdatum.
                  ENDIF.
                  IF vdatum EQ '00000000' OR vdatum GE '20250401'.
                    IF vn_name1 NE space.
                      CONCATENATE vn_name1 'through Blue Cross' INTO v_name1 SEPARATED BY space.
                    ENDIF.
                  ENDIF.
                ENDIF.
              ENDIF.
*              endif.

            ELSE.
              SELECT SINGLE * FROM lfa1 WHERE lifnr EQ wa_mseg1-lifnr.
              IF sy-subrc EQ 0.
                v_name1 = lfa1-name1.
              ELSE.
                SELECT SINGLE * FROM qals WHERE matnr EQ wa_mseg1-matnr AND charg EQ wa_mseg1-charg AND sellifnr NE '          '.
                IF sy-subrc EQ 0.
                  SELECT SINGLE * FROM lfa1 WHERE lifnr EQ qals-lifnr.
                  IF sy-subrc EQ 0.
                    v_name1 = lfa1-name1.
                  ENDIF.
                ELSE.
                  SELECT SINGLE * FROM mch1 WHERE matnr EQ wa_mseg1-matnr AND charg EQ wa_mseg1-charg AND lifnr GE '0000010000' AND lifnr LE '0000029999'.
                  IF sy-subrc EQ 0.
                    SELECT SINGLE * FROM lfa1 WHERE lifnr EQ mch1-lifnr.
                    IF sy-subrc EQ 0.
                      v_name1 = lfa1-name1.
                    ENDIF.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
****************************** added on 22.5.23****************
            IF bsart EQ 'ZSTO' AND vn_name1 EQ space. "change zub to ZSTO 25.09.25
              SELECT * FROM qals INTO TABLE it_qals1 WHERE charg EQ wa_mseg1-charg AND lifnr NE space.
              LOOP AT it_qals1 INTO wa_qals1.
                SELECT SINGLE * FROM jest WHERE objnr EQ wa_qals1-objnr AND stat EQ 'I0224'.
                IF sy-subrc EQ 0.
                  DELETE it_qals1 WHERE prueflos EQ wa_qals1-prueflos.
                ENDIF.
              ENDLOOP.
              SORT it_qals1.
              READ TABLE it_qals1 INTO wa_qals1 WITH KEY charg  = wa_mseg1-charg.
              IF sy-subrc EQ 0.
                SELECT SINGLE * FROM lfa1 WHERE lifnr EQ wa_qals1-lifnr.
                IF sy-subrc EQ 0.
                  vn_name1 = lfa1-name1.
                  vn_ort01 = lfa1-ort01.
                ENDIF.
                IF sgtxt EQ space.
                  SELECT SINGLE * FROM zmigo WHERE mblnr EQ wa_qals1-mblnr.
                  IF sy-subrc EQ 0.
                    SELECT SINGLE * FROM lfa1 WHERE lifnr EQ zmigo-mfgr.
                    IF sy-subrc EQ 0.
                      sgtxt = lfa1-name1.
                    ENDIF.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
            wa_doc1-mblnr = wa_mseg1-mblnr.
            wa_doc1-mjahr = wa_mseg1-mjahr.
            wa_doc1-ebeln = wa_mseg1-ebeln.

            COLLECT wa_doc1 INTO it_doc1.
            CLEAR wa_doc1.
            wa_tab3-mblnr = wa_mseg1-mblnr.
            wa_tab3-mjahr = wa_mseg1-mjahr.
            wa_tab3-ebeln = wa_mseg1-ebeln.
            wa_tab3-lgort = wa_mseg1-lgort.
            wa_tab3-werks = wa_mseg1-werks.
            wa_tab3-zeile = wa_mseg1-zeile.
            wa_tab3-matnr = wa_mseg1-matnr.
            wa_tab3-charg = wa_mseg1-charg.
            wa_tab3-prueflos = wa_qals-prueflos.
            wa_tab3-ablad = wa_mseg1-ablad.
            wa_tab3-licha = licha.
            wa_tab3-menge = wa_mseg1-menge.
            wa_tab3-erfmg = wa_mseg1-erfmg.
            wa_tab3-erfme = wa_mseg1-erfme.
            wa_tab3-meins = wa_mseg1-meins.
            wa_tab3-uom = wa_mseg-meins.
            wa_tab3-anzgeb = anzgeb.
            wa_tab3-v_name1 = v_name1.
            wa_tab3-vn_ort01 = vn_ort01.
            wa_tab3-hsdat = hsdat.
            wa_tab3-sgtxt = sgtxt.
            wa_tab3-vfdat = vfdat.
            wa_tab3-matnr = wa_mseg1-matnr.
            wa_tab3-knttp = ekpo-knttp.
            wa_tab3-kostl = wa_mseg1-kostl.
            COLLECT wa_tab3 INTO it_tab3.
            CLEAR wa_tab3.




          ENDIF.
        ENDIF.

        IF wa_tab2-budat LT '20200806' AND wa_tab2-werks EQ '1001'.
          format1 = 'ST/GM/002-20-F3'.
        ELSEIF bsart EQ 'ZSTO' AND wa_tab2-werks EQ '1001'.  " change in zub to ZSTO 25.09.25
          format1 = 'ST/GM/002-F6'.
        ELSEIF wa_tab2-werks EQ '1001'.
          format1 = 'ST/GM/002-F3'.
        ELSE.
          format1 = 'Format NO.: SOP/ST/033-03-F1'.
        ENDIF.
        CLEAR wa_qals. "add
      ENDLOOP.
    ENDLOOP.
  ENDIF.
  IF it_tab3 IS NOT INITIAL.
    SELECT * FROM qals INTO TABLE it_qals2 FOR ALL ENTRIES IN it_tab3 WHERE charg EQ it_tab3-charg AND lifnr NE space.
  ENDIF.
  LOOP AT it_qals2 INTO wa_qals2.
    SELECT SINGLE * FROM jest WHERE objnr EQ wa_qals2-objnr AND stat EQ 'I0224'.
    IF sy-subrc EQ 0.
      DELETE it_qals2 WHERE prueflos EQ wa_qals2-prueflos.
    ENDIF.
  ENDLOOP.
  DELETE it_qals2 WHERE charg EQ space.  "31.1.24
  SORT it_qals2.
*  read table it_qals1 into wa_qals1 with key charg  = wa_mseg1-charg.
*  if sy-subrc eq 0.
*    select single * from lfa1 where lifnr eq wa_qals1-lifnr.
*    if sy-subrc eq 0.
*      vn_name1 = lfa1-name1.
*      vn_ort01 = lfa1-ort01.
*    endif.
*  endif.

  SORT it_doc1 BY mjahr mblnr.
  DELETE ADJACENT DUPLICATES FROM it_doc1.
  CLEAR: it_tab4,wa_tab4.
  LOOP AT it_tab3 INTO wa_tab3.

    CLEAR : maktx, normt,maktx1,maktx2.
    SELECT SINGLE * FROM makt WHERE spras EQ 'EN' AND matnr EQ wa_tab3-matnr.
    IF sy-subrc EQ 0.
      maktx1 = makt-maktx.
    ENDIF.
    SELECT SINGLE * FROM makt WHERE spras EQ 'Z1' AND matnr EQ wa_tab3-matnr.  "9.12.20
    IF sy-subrc EQ 0.
      maktx2 = makt-maktx.
    ENDIF.
    CONCATENATE maktx1 maktx2 INTO maktx SEPARATED BY space.
    SELECT SINGLE * FROM mara WHERE matnr EQ wa_tab3-matnr.
    IF sy-subrc EQ 0.
      normt = mara-normt.
      mtart = mara-mtart.
    ENDIF.
    CONDENSE : maktx, normt.
    CONCATENATE maktx normt INTO maktx SEPARATED BY ','.

*    write : /'4', wa_tab3-mblnr,
*    / wa_tab3-zeile,maktx,wa_tab3-werks,wa_tab3-matnr, / wa_tab3-charg, wa_tab3-prueflos,
*    wa_tab3-ablad, wa_tab3-licha, wa_tab3-menge,wa_tab3-meins,wa_tab3-anzgeb,wa_tab3-v_name1,
*    / wa_tab3-hsdat,wa_tab3-sgtxt, wa_tab3-vfdat.
    wa_tab4-mblnr = wa_tab3-mblnr.
    SELECT SINGLE * FROM mkpf WHERE mblnr EQ wa_tab3-mblnr AND mjahr EQ wa_tab3-mjahr.
    IF sy-subrc EQ 0.
      wa_tab4-xblnr = mkpf-xblnr.
      wa_tab4-bldat = mkpf-bldat.
    ENDIF.
    wa_tab4-ebeln = wa_tab3-ebeln.
    SELECT SINGLE * FROM ekko WHERE ebeln EQ wa_tab3-ebeln.
    IF sy-subrc EQ 0.
      wa_tab4-lifnr = ekko-lifnr.
      wa_tab4-aedat = ekko-aedat.
      SELECT SINGLE * FROM lfa1 WHERE lifnr EQ ekko-lifnr.
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM adrc WHERE addrnumber EQ lfa1-adrnr.
        IF sy-subrc EQ 0.
          wa_tab4-name1 = adrc-name1.
        ENDIF.
      ENDIF.
    ENDIF.

    SELECT SINGLE * FROM ekko WHERE ebeln EQ wa_tab3-ebeln AND reswk GT 0.
    IF sy-subrc EQ 0.
      READ TABLE it_qals2 INTO wa_qals2 WITH KEY charg  = wa_tab3-charg.
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM lfa1 WHERE lifnr EQ wa_qals2-lifnr.
        IF sy-subrc EQ 0.
          wa_tab4-vn_name1 = lfa1-name1.
          wa_tab4-vn_ort01 = lfa1-ort01.
        ENDIF.
      ENDIF.
    ENDIF.
    IF wa_tab4-vn_name1 IS INITIAL.
      SELECT SINGLE * FROM mch1 WHERE charg EQ wa_tab3-charg AND lifnr GT 0.
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM lfa1 WHERE lifnr EQ mch1-lifnr.
        IF sy-subrc EQ 0.
          SELECT SINGLE * FROM adrc WHERE addrnumber EQ lfa1-adrnr.
          IF sy-subrc EQ 0.
            wa_tab4-vn_name1 = adrc-name1.
          ENDIF.
          wa_tab4-vn_ort01 = lfa1-ort01.
        ENDIF.
      ENDIF.
    ENDIF.

    wa_tab4-mjahr = wa_tab3-mjahr.
    wa_tab4-zeile = wa_tab3-zeile.
    wa_tab4-lgort = wa_tab3-lgort.
    wa_tab4-maktx = maktx.
    wa_tab4-matnr = wa_tab3-matnr.
    wa_tab4-charg = wa_tab3-charg.
    wa_tab4-prueflos = wa_tab3-prueflos.
    wa_tab4-ablad = wa_tab3-ablad.
    wa_tab4-licha = wa_tab3-licha.
    wa_tab4-menge = wa_tab3-menge.
    wa_tab4-erfmg = wa_tab3-erfmg.
    wa_tab4-erfme = wa_tab3-erfme.
    CONDENSE wa_tab4-erfmg.
    wa_tab4-meins = wa_tab3-meins.
    wa_tab4-anzgeb = wa_tab3-anzgeb.
    wa_tab4-v_name1 = wa_tab3-v_name1.
    wa_tab4-hsdat = wa_tab3-hsdat.
    wa_tab4-sgtxt = wa_tab3-sgtxt.
    wa_tab4-vfdat = wa_tab3-vfdat.
    IF wa_tab3-lgort NE 'PM01'.
      wa_tab4-npage = 'Y'.
    ENDIF.
    SELECT SINGLE * FROM zcoadata WHERE prueflos EQ wa_tab3-prueflos AND udpernr GT 0.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ zcoadata-udpernr AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        wa_tab4-ename = pa0001-ename.
        SELECT SINGLE * FROM hrp1000 WHERE plvar = '01'   AND objid = pa0001-plans AND langu EQ 'EN' AND endda GE sy-datum AND otype EQ 'S'.
        IF sy-subrc EQ 0.
          wa_tab4-stext = hrp1000-stext.
        ENDIF.
      ENDIF.
    ENDIF.
*    BREAK-POINT .
    IF wa_tab4-ename EQ space.
      SELECT SINGLE * FROM qave WHERE prueflos EQ wa_tab3-prueflos .
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM  v_usr_name WHERE bname EQ qave-vname.
        IF sy-subrc EQ 0.
          wa_tab4-ename = v_usr_name-name_text.
        ENDIF.
        wa_tab4-stext = 'Q.C. Department'.
      ENDIF.
    ENDIF.
    SELECT SINGLE * FROM qave WHERE prueflos EQ wa_tab3-prueflos AND vcode EQ 'A1'.
    IF sy-subrc EQ 0.
      wa_tab4-qcstatus = 'APPROVED'.
      wa_tab4-qcdate = qave-vdatum.
      wa_tab4-vezeiterf = qave-vezeiterf.
    ENDIF.
    SELECT SINGLE * FROM qave WHERE prueflos EQ wa_tab3-prueflos AND vcode EQ 'A2'.
    IF sy-subrc EQ 0.
      wa_tab4-qcstatus = 'PARTIALLY APPROVED'.
      wa_tab4-qcdate = qave-vdatum.
      wa_tab4-vezeiterf = qave-vezeiterf.
      SELECT SINGLE * FROM qals WHERE prueflos EQ wa_tab3-prueflos.
      IF sy-subrc EQ 0.
        wa_tab4-lmenge04 = qals-lmenge04.
        wa_tab4-lmenge01 = qals-lmenge01 + qals-lmenge03.
        wa_tab4-mengeneinh = qals-mengeneinh.
        wa_tab4-rejqty = 'P'.
      ENDIF.
    ENDIF.
    SELECT SINGLE * FROM qave WHERE prueflos EQ wa_tab3-prueflos AND vcode EQ 'A3'.
    IF sy-subrc EQ 0.
      wa_tab4-qcstatus = 'REJECTED'.
      wa_tab4-qcdate = qave-vdatum.
      wa_tab4-vezeiterf = qave-vezeiterf.
      SELECT SINGLE * FROM qals WHERE prueflos EQ wa_tab3-prueflos.
      IF sy-subrc EQ 0.
        wa_tab4-lmenge04 = qals-lmenge04 + qals-lmenge03.
        wa_tab4-mengeneinh = qals-mengeneinh.
        wa_tab4-rejqty = 'R'.
      ENDIF.
    ENDIF.
    CONDENSE : wa_tab4-menge,wa_tab4-lmenge04,wa_tab4-lmenge01.

    COLLECT wa_tab4 INTO it_tab4.
    CLEAR wa_tab4.
*    wa_tab3-efrmg,wa_tab3-efrme,
*    / wa_tab3-vn_ort01,
*    wa_tab3-knttp, wa_tab3-kostl.

  ENDLOOP.


  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
*     formname           = 'ZMB90_41_1'
*     FORMNAME           = 'ZMB90_41_7'
*     FORMNAME           = 'ZMB90_41_8'  "6.8.24 Jyotsna: page cut correction
*     formname           = 'ZMB90_41_9'  "6.8.24 Jyotsna: page cut correction
      formname           = 'ZMB90_41_10'  " 29.4.25 RECEIPT UNIT CORRECTION - JYOTSNA
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
      fm_name            = v_fm
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.

  control-no_open   = 'X'.
  control-no_close  = 'X'.

  CALL FUNCTION 'SSF_OPEN'
    EXPORTING
      control_parameters = control.


  LOOP AT it_doc1 INTO wa_doc1.
    CLEAR : it_tab5,wa_tab5.
    LOOP AT it_tab4 INTO wa_tab4 WHERE mblnr = wa_doc1-mblnr AND ebeln = wa_doc1-ebeln.
      CLEAR : scharg.
      scharg = wa_tab4-charg.
      MOVE-CORRESPONDING wa_tab4 TO wa_tab5.


      DATA : batch_details    TYPE TABLE OF clbatch,
             wa_batch_details TYPE clbatch,
             batchno          TYPE atwtb.

*     DATA : wa_inspe type TABLE of ZMB90_2B1.


      CALL FUNCTION 'VB_BATCH_GET_DETAIL' "added by rushi
        EXPORTING
          matnr              = wa_tab5-matnr
          charg              = wa_tab5-charg
          werks              = wa_tab5-werks
          get_classification = 'X'
*         EXISTENCE_CHECK    =
*         READ_FROM_BUFFER   =
*         NO_CLASS_INIT      = ' '
*         LOCK_BATCH         = ' '
*       IMPORTING
*         YMCHA              =
*         CLASSNAME          =
*         BATCH_DEL_FLG      =
        TABLES
          char_of_batch      = batch_details
        EXCEPTIONS
          no_material        = 1
          no_batch           = 2
          no_plant           = 3
          material_not_found = 4
          plant_not_found    = 5
          no_authority       = 6
          batch_not_exist    = 7
          lock_on_batch      = 8
          OTHERS             = 9.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.


      READ TABLE batch_details INTO wa_batch_details WITH KEY atnam = 'ZVENDOR_BATCH'.
      IF sy-subrc = 0 .
        wa_tab5-batchno  = wa_batch_details-atwtb.
**       wa_tab5-PRUEFLOS = wa_inspe-QPLOS.
*        wa_tab5-PRUEFLOS = WA_QALS-QPLOS.
      ENDIF.


      COLLECT wa_tab5 INTO it_tab5.
      CLEAR wa_tab5.
    ENDLOOP.

    CLEAR : mblnr,checkbyname,checkbydt,checkbytm.
    mblnr = wa_doc1-mblnr.
*    PERFORM FORM1.
    SELECT SINGLE * FROM t001w WHERE werks EQ plant.
    IF sy-subrc EQ 0.
      kunnr = t001w-kunnr.
    ENDIF.
    SELECT SINGLE * FROM zmigo_chk WHERE mblnr EQ mblnr.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ zmigo_chk-pernr AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        checkbyname = pa0001-ename.
        checkbydt = zmigo_chk-cpudt.
        checkbytm = zmigo_chk-cputm.
        SELECT SINGLE * FROM hrp1000 WHERE objid = pa0001-plans AND endda GE sy-datum AND langu EQ 'EN'.
        IF sy-subrc EQ 0.
          checkbydesg = hrp1000-stext.
        ENDIF.
        IF checkbydesg EQ space.
          CLEAR : it_hrp1000,wa_hrp1000,it_pa0001,wa_pa0001.
          SELECT * FROM pa0001 INTO TABLE it_pa0001 WHERE pernr EQ zmigo_chk-pernr AND plans NE '99999999'.
          SORT it_pa0001 DESCENDING BY endda.
          SELECT * FROM hrp1000 INTO TABLE it_hrp1000 FOR ALL ENTRIES IN it_pa0001 WHERE objid EQ it_pa0001-plans AND langu EQ 'EN'.
          SORT it_hrp1000 DESCENDING BY endda.
          READ TABLE it_hrp1000 INTO wa_hrp1000 WITH KEY langu = 'EN'.
          IF sy-subrc EQ 0.
            checkbydesg = wa_hrp1000-stext.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
    CLEAR: budat,bldat,xblnr,name_text,lifnr,name1,ebeln,aedat.
    SELECT SINGLE * FROM mkpf WHERE mblnr EQ mblnr.
    IF sy-subrc EQ 0.
      budat = mkpf-budat.
      bldat = mkpf-bldat.
      xblnr = mkpf-xblnr.
      cputm = mkpf-cputm.
      SELECT SINGLE * FROM  v_usr_name WHERE bname EQ mkpf-usnam.
      IF sy-subrc EQ 0.
        name_text = v_usr_name-name_text.
      ENDIF.
    ENDIF.
    SELECT SINGLE * FROM mseg WHERE mblnr EQ mblnr AND ebeln = wa_doc1-ebeln AND lifnr NE space.
    IF sy-subrc EQ 0.
      lifnr = mseg-lifnr.
      SELECT SINGLE * FROM lfa1 WHERE lifnr EQ lifnr.
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM adrc WHERE addrnumber EQ lfa1-adrnr.
        IF sy-subrc EQ 0.
          name1 = adrc-name1.
        ENDIF.
      ENDIF.
    ENDIF.
    IF lifnr EQ space.
      SELECT SINGLE * FROM mch1 WHERE charg EQ scharg AND lifnr NE space.
      IF sy-subrc EQ 0.
        lifnr = mch1-lifnr.
        SELECT SINGLE * FROM lfa1 WHERE lifnr EQ lifnr.
        IF sy-subrc EQ 0.
          SELECT SINGLE * FROM adrc WHERE addrnumber EQ lfa1-adrnr.
          IF sy-subrc EQ 0.
            name1 = adrc-name1.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    SELECT SINGLE * FROM mseg WHERE mblnr EQ mblnr AND ebeln EQ wa_doc1-ebeln.
    IF sy-subrc EQ 0.
      ebeln = mseg-ebeln.
      SELECT SINGLE * FROM ekko WHERE ebeln EQ mseg-ebeln.
      IF sy-subrc EQ 0.
        aedat = ekko-aedat.
      ENDIF.
    ENDIF.

    SELECT SINGLE * FROM ekko WHERE ebeln EQ wa_doc1-ebeln AND reswk NE space.
    IF sy-subrc EQ 0.
      trf = 'Y'.
    ENDIF.

**CALL FUNCTION '/1BCDWB/SF00000028'
**  EXPORTING
***   ARCHIVE_INDEX              =
***   ARCHIVE_INDEX_TAB          =
***   ARCHIVE_PARAMETERS         =
**   CONTROL_PARAMETERS         = control
***   MAIL_APPL_OBJ              =
***   MAIL_RECIPIENT             =
***   MAIL_SENDER                =
**   OUTPUT_OPTIONS             = w_ssfcompop
**   USER_SETTINGS              = 'X'
**    FORMAT                     = format1
**    KUNNR                      = KUNNR
**    MBLNR                      = mblnr
**    BUDAT                      = budat
**    PLANT                      = plant
**    LGORT                      = lgort
**    NAME_TEXT                  = name_text
**    TXT1                       = txt1
**    LIFNR                      = lifnr
**    BLDAT                      = bldat
**    EBELN                      = ebeln
**    AEDAT                      = aedat
**    XBLNR                      = xblnr
**    UNAME                      = uname
**    UDATE                      = udate
**    UTIME                      = utime
**    CHECKBYNAME                = checkbyname
**    CHECKBYDT                  = checkbydt
**    CHECKBYTM                  = checkbytm
**    CHECKBYDESG                = checkbydesg
**    NAME1                      = name1
**    FORMAT1                    = format1
**    TRF                        = trf
**    CPUTM                      = cputm
**    WA_T001W                   = WA_T001W
**    WA_LFA1_NAME1              = WA_LFA1_NAME1
**    BATCHNO                    = BATCHNO
*** IMPORTING
***   DOCUMENT_OUTPUT_INFO       =
***   JOB_OUTPUT_INFO            =
***   JOB_OUTPUT_OPTIONS         =
**  TABLES
**    IT_TAB1                    = it_tab5
** EXCEPTIONS
**   FORMATTING_ERROR           = 1
**   INTERNAL_ERROR             = 2
**   SEND_ERROR                 = 3
**   USER_CANCELED              = 4
**   OTHERS                     = 5
**          .
**IF SY-SUBRC <> 0.
*** Implement suitable error handling here
**ENDIF.



    CALL FUNCTION v_fm
      EXPORTING
        control_parameters = control
        user_settings      = 'X'
        output_options     = w_ssfcompop
        format             = format1
        kunnr              = kunnr
        mblnr              = mblnr
        budat              = budat
        cputm              = cputm
        bldat              = bldat
        xblnr              = xblnr
        ebeln              = ebeln
        aedat              = aedat
        lgort              = lgort
        plant              = plant
        name_text          = name_text
        npage              = npage
        txt1               = txt1
        lifnr              = lifnr
        uname              = uname
        udate              = udate
        utime              = utime
        checkbyname        = checkbyname
        checkbydt          = checkbydt
        checkbytm          = checkbytm
        checkbydesg        = checkbydesg
        name1              = name1
        format1            = format1
        trf                = trf
        wa_t001w           = wa_t001w
        wa_lfa1_name1      = wa_lfa1_name1
        batchno            = batchno
      TABLES
        it_tab1            = it_tab5
*       itab_division      = itab_division
*       itab_storage       = itab_storage
*       itab_pa0002        = itab_pa0002
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.


  ENDLOOP.
  CLEAR : format, kunnr,mblnr,budat,bldat,xblnr,ebeln,aedat,lgort,plant,name_text, npage,txt1,lifnr,name1.

  CALL FUNCTION 'SSF_CLOSE'.



*  call function 'CLOSE_FORM'
*    exceptions
*      unopened                 = 1
*      bad_pageformat_for_print = 2
*      send_error               = 3
*      spool_error              = 4
*      codepage                 = 5
*      others                   = 6.
*
*  if sy-subrc <> 0.
*    message id sy-msgid type sy-msgty number sy-msgno
*            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*  endif.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  INV_LAZER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  INVOTHR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM invothr .
  SELECT * FROM mseg INTO TABLE it_mseg WHERE mblnr IN grn.
*   in grn and mjahr eq year and werks eq plant
*     and bwart eq '101'. "added on 15.7.20
*  if sy-subrc eq 0.
*    select * from ekko into table it_ekko for all entries in it_mseg where ebeln eq it_mseg-ebeln and bukrs eq 'BCLL'
*      and bsart in ('ZL','ZI', 'ZUB').
*  endif.
  SORT it_mseg.
  it_mseg1 = it_mseg.
  DELETE ADJACENT DUPLICATES FROM it_mseg COMPARING mblnr mjahr.

*PO
  LOOP AT it_mseg INTO wa_mseg.
    SELECT * FROM mseg INTO TABLE it_mseg4 WHERE bwart EQ '101' AND matnr EQ wa_mseg-matnr AND charg EQ wa_mseg-charg AND werks EQ wa_mseg-werks AND ebeln NE space.
  ENDLOOP.

  SORT it_mseg4 DESCENDING.

****************

*CALL FUNCTION 'VB_BATCH_GET_DETAIL'
*  EXPORTING
*    MATNR                    = wa_mseg-matnr
*    CHARG                    = wa_mseg-charg
*    WERKS                    = wa_mseg-werks
**   GET_CLASSIFICATION       =
**   EXISTENCE_CHECK          =
**   READ_FROM_BUFFER         =
**   NO_CLASS_INIT            = ' '
**   LOCK_BATCH               = ' '
** IMPORTING
**   YMCHA                    =
**   CLASSNAME                =
**   BATCH_DEL_FLG            =
* TABLES
*   CHAR_OF_BATCH            = IT_batch_details
* EXCEPTIONS
*   NO_MATERIAL              = 1
*   NO_BATCH                 = 2
*   NO_PLANT                 = 3
*   MATERIAL_NOT_FOUND       = 4
*   PLANT_NOT_FOUND          = 5
*   NO_AUTHORITY             = 6
*   BATCH_NOT_EXIST          = 7
*   LOCK_ON_BATCH            = 8
*   OTHERS                   = 9
*          .
*IF SY-SUBRC <> 0.
** Implement suitable error handling here
*ENDIF.


  CALL FUNCTION 'OPEN_FORM'
    EXPORTING
*     APPLICATION                 = 'TX'
*     ARCHIVE_INDEX               =
*     ARCHIVE_PARAMS              =
      device                      = 'PRINTER'
      dialog                      = 'X'
*     FORM                        = ' '
      language                    = sy-langu
*     OPTIONS                     =
*     MAIL_SENDER                 =
*     MAIL_RECIPIENT              =
*     MAIL_APPL_OBJECT            =
*     RAW_DATA_INTERFACE          = '*'
*     SPONUMIV                    =
* IMPORTING
*     LANGUAGE                    =
*     NEW_ARCHIVE_PARAMS          =
*     RESULT                      =
    EXCEPTIONS
      canceled                    = 1
      device                      = 2
      form                        = 3
      options                     = 4
      unclosed                    = 5
      mail_options                = 6
      archive_error               = 7
      invalid_fax_number          = 8
      more_params_needed_in_batch = 9
      spool_error                 = 10
      codepage                    = 11
      OTHERS                      = 12.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.



  LOOP AT it_mseg INTO wa_mseg.
*    read table it_ekko into wa_ekko with key ebeln = wa_mseg-ebeln.
*    if sy-subrc eq 0.
*    WRITE : / '*',WA_MSEG-MBLNR.
*     SELECT SINGLE * read table it_ekko into wa_ekko with key ebeln = wa_mseg-ebeln.
    wa_tab1-mblnr = wa_mseg-mblnr.
    wa_tab1-mjahr = wa_mseg-mjahr.
    READ TABLE it_mseg4 INTO wa_mseg4 WITH KEY matnr = wa_mseg-matnr charg = wa_mseg-charg werks = wa_mseg-werks bwart = '101'.
    IF sy-subrc EQ 0.
      wa_tab1-ebeln = wa_mseg4-ebeln.
      SELECT SINGLE * FROM ekko WHERE ebeln EQ wa_mseg4-ebeln.
      IF sy-subrc EQ 0.
        wa_tab1-ekgrp = ekko-ekgrp.
        wa_tab1-bedat = ekko-bedat.
      ENDIF.
    ENDIF.
    wa_tab1-werks = wa_mseg-werks.

    wa_tab1-lgort = wa_mseg-lgort.
*    WA_TAB1-MATNR = WA_MSEG-MATNR.
*    wa_tab1-sgtxt = wa_mseg-sgtxt.
    SELECT SINGLE * FROM j_1ipart1 WHERE mblnr EQ wa_mseg-mblnr AND mjahr EQ wa_mseg-mjahr.
    IF sy-subrc EQ 0.
      wa_tab1-docno = j_1ipart1-docno.
      wa_tab1-docyr = j_1ipart1-docyr.
    ENDIF.
    SELECT SINGLE * FROM t001l WHERE werks EQ wa_mseg-werks AND lgort EQ wa_mseg-lgort.
    IF sy-subrc EQ 0.
      wa_tab1-lgobe = t001l-lgobe.
    ENDIF.

    IF wa_mseg-lifnr NE '          '.
      wa_tab1-lifnr = wa_mseg-lifnr.
    ELSE.
*      select single * from mseg where mblnr eq wa_mseg-mblnr and mjahr eq wa_mseg-mjahr and lifnr ne '          '.
*      if sy-subrc eq 0.
*        wa_tab1-lifnr = mseg-lifnr.
*      endif.
      SELECT SINGLE * FROM qals WHERE matnr EQ wa_mseg-matnr AND charg EQ wa_mseg-charg AND sellifnr NE '          '.
      IF sy-subrc EQ 0.
        wa_tab1-lifnr = qals-sellifnr.
      ENDIF.
    ENDIF.
    IF wa_tab1-lifnr EQ space.
      SELECT SINGLE * FROM mch1 WHERE matnr EQ wa_mseg-matnr AND charg EQ wa_mseg-charg AND lifnr GE '0000010000' AND lifnr LE '0000029999'.
      IF sy-subrc EQ 0.
        wa_tab1-lifnr = mch1-lifnr.
      ENDIF.
    ENDIF.

    SELECT SINGLE * FROM j_1iexcdtl WHERE werks EQ wa_mseg-werks AND matnr EQ wa_mseg-matnr AND charg EQ wa_mseg-charg AND rdoc1 EQ wa_mseg-ebeln
      AND ritem1 EQ wa_mseg-ebelp.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM j_1iexchdr WHERE docyr EQ j_1iexcdtl-docyr AND docno EQ j_1iexcdtl-docno.
      IF sy-subrc EQ 0.
        wa_tab1-exnum = j_1iexchdr-exnum.
        wa_tab1-exbed = j_1iexchdr-exbed.
        wa_tab1-exdat = j_1iexchdr-exdat.
      ENDIF.
    ENDIF.

    COLLECT wa_tab1 INTO it_tab1.
    CLEAR wa_tab1.
*    endif.
  ENDLOOP.


  LOOP AT it_tab1 INTO wa_tab1.
*  WRITE : / wa_tab1-mblnr,wa_tab1-mjahr,wa_tab1-ebeln.
    wa_tab2-mblnr = wa_tab1-mblnr.
    wa_tab2-mjahr = wa_tab1-mjahr.
    wa_tab2-ebeln = wa_tab1-ebeln.
    wa_tab2-exnum = wa_tab1-exnum.
    wa_tab2-exbed = wa_tab1-exbed.
    wa_tab2-exdat = wa_tab1-exdat.
    wa_tab2-bedat = wa_tab1-bedat.
    wa_tab2-lgort = wa_tab1-lgort.
    wa_tab2-lgobe = wa_tab1-lgobe.
    wa_tab2-docno = wa_tab1-docno.
    wa_tab2-docyr = wa_tab1-docyr.
*  WA_TAB2-MATNR = WA_TAB1-MATNR.
*  wa_tab2-sgtxt = wa_tab1-sgtxt.
    SELECT SINGLE * FROM mkpf WHERE mblnr EQ wa_tab1-mblnr AND mjahr EQ wa_tab1-mjahr.
    IF sy-subrc EQ 0.
*    WRITE : / 'Goods receipt date',mkpf-budat.
*    WRITE : / 'Current date',sy-datum.
*    WRITE : / 'Challan no',mkpf-xblnr,mkpf-bldat.
      wa_tab2-budat = mkpf-budat.
      wa_tab2-xblnr = mkpf-xblnr.
      wa_tab2-bldat = mkpf-bldat.
    ENDIF.
*  WRITE : / 'plant', wa_tab1-werks.
    wa_tab2-werks = wa_tab1-werks.
    SELECT SINGLE * FROM t001w WHERE werks EQ wa_tab1-werks.
    IF sy-subrc EQ 0.
*    if wa_tab1-werks eq '1000' or wa_tab1-werks eq '1001'.
*      wa_tab2-w_name1 = 'BLUE CROSS LABORATORIES PVT LTD.'.
*    else.
*    WRITE : / 'description',t001w-name1.
      wa_tab2-w_name1 = t001w-name1.
*    endif.
    ENDIF.
*  WRITE : / 'Vendor',wa_tab1-lifnr.
    wa_tab2-lifnr = wa_tab1-lifnr.
    SELECT SINGLE * FROM lfa1 WHERE lifnr EQ wa_tab1-lifnr.
    IF sy-subrc EQ 0.
*    WRITE : / 'Name', lfa1-name1.
      wa_tab2-v_name1 = lfa1-name1.
    ENDIF.
**    IF  wa_tab2-v_name1 EQ space.
*    select single * from ekko where ebeln eq wa_tab1-ebeln and bsart eq 'ZUB'.
*    if sy-subrc eq 0.
*      select single * from t001w where werks eq ekko-reswk.
*      if sy-subrc eq 0.
*        wa_tab2-v_name1 = t001w-name1.
*      endif.
*    else.
*      select single * from lfa1 where lifnr eq wa_tab1-lifnr.
*      if sy-subrc eq 0.
**        WRITE : / 'Name', lfa1-name1.
*        wa_tab2-v_name1 = lfa1-name1.
*      endif.
*    endif.
**    ENDIF.
*  WRITE : / 'PO no.',wa_tab1-ebeln.
    wa_tab2-ebeln = wa_tab1-ebeln.
*  WRITE : / 'Pur. group:',wa_tab1-ekgrp.
    wa_tab2-ekgrp = wa_tab1-ekgrp.
    SELECT SINGLE * FROM t024 WHERE ekgrp EQ wa_tab1-ekgrp.
    IF sy-subrc EQ 0.
*    WRITE : t024-eknam.
      wa_tab2-eknam = t024-eknam.
    ENDIF.
    SELECT SINGLE * FROM t001w WHERE werks EQ wa_tab1-werks.
    IF sy-subrc EQ 0.


      wa_tab2-kunnr = t001w-kunnr.
      wa_tab2-kunnr = t001w-ort01. "" added by rushi
    ENDIF.

    COLLECT wa_tab2 INTO it_tab2.
    CLEAR wa_tab2.
  ENDLOOP.


  IF r4 EQ 'X'.

    LOOP AT it_tab2 INTO wa_tab2.
      CLEAR : v_name1,vn_name1,vn_ort01,bsart,format1.
*    SELECT SINGLE * FROM MSEG WHERE MBLNR EQ WA_TAB2-MBLNR AND MJAHR EQ WA_TAB2-MJAHR.
*      IF SY-SUBRC EQ 0.
*        SELECT SINGLE * FROM mara WHERE matnr eq MSEG-matnr AND MTART EQ 'ZROH'.
*      if SY-SUBRC EQ 0.

      CALL FUNCTION 'START_FORM'
        EXPORTING
*         form        = 'ZGRN_MB90_D1'
          form        = 'ZGRN_MB90_D2'
          language    = sy-langu
        EXCEPTIONS
          form        = 1
          format      = 2
          unended     = 3
          unopened    = 4
          unused      = 5
          spool_error = 6
          codepage    = 7
          OTHERS      = 8.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
*      WRITE : / 'PLANT',wa_tab2-werks.
*  ELSE.
*
**    SELECT SINGLE * FROM mara WHERE matnr eq wa_tab2-matnr.
**      if mara-mtart eq 'ZROH'.
*  call function 'START_FORM'
*    EXPORTING
*      form        = 'ZGRN_MB90_31'
*      language    = sy-langu
*    EXCEPTIONS
*      form        = 1
*      format      = 2
*      unended     = 3
*      unopened    = 4
*      unused      = 5
*      spool_error = 6
*      codepage    = 7
*      others      = 8.
*  if sy-subrc <> 0.
*    message id sy-msgid type sy-msgty number sy-msgno
*            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*  endif.
*
* ENDIF.
* ENDIF.
*  ELSEIF R3 EQ 'X'.
*      call function 'START_FORM'
*    EXPORTING
*      form        = 'ZGRN_MB90_L1'
*      language    = sy-langu
*    EXCEPTIONS
*      form        = 1
*      format      = 2
*      unended     = 3
*      unopened    = 4
*      unused      = 5
*      spool_error = 6
*      codepage    = 7
*      others      = 8.
*  if sy-subrc <> 0.
*    message id sy-msgid type sy-msgty number sy-msgno
*            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*  endif.
*    ENDIF.


      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'A3'
          window  = 'WINDOW1'.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'A1'
          window  = 'WINDOW7'.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'A1'
          window  = 'WINDOW3'.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'A1'
          window  = 'WINDOW5'.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'A1'
          window  = 'WINDOW6'.

      IF it_mseg1 IS NOT INITIAL.
        SELECT * FROM qals INTO TABLE it_qals FOR ALL ENTRIES IN it_mseg1 WHERE werk EQ it_mseg1-werks AND matnr EQ it_mseg1-matnr AND
          charg EQ it_mseg1-charg.
      ENDIF.
      SORT it_qals DESCENDING BY enstehdat entstezeit.
*************************************************************************
      SELECT SINGLE * FROM ekko WHERE ebeln EQ wa_tab2-ebeln AND bsart EQ 'ZSTO'. " change in zub to ZSTO 25.09.25
      IF sy-subrc EQ 0.
        IF it_mseg1 IS NOT INITIAL.
          SELECT * FROM mcha INTO TABLE it_mcha FOR ALL ENTRIES IN it_mseg1 WHERE charg EQ it_mseg1-charg AND lifnr NE space.
        ENDIF.
        LOOP AT it_mcha INTO wa_mcha.
          CLEAR : mjahr .
          wa_bt1-charg = wa_mcha-charg.
          wa_bt1-mjahr = wa_mcha-ersda+0(4).
          COLLECT wa_bt1 INTO it_bt1.
          CLEAR wa_bt1.
        ENDLOOP.



        IF it_mseg1 IS NOT INITIAL.
          SELECT * FROM mseg INTO TABLE it_mseg2 FOR ALL ENTRIES IN it_mseg1 WHERE
*            WERKS EQ IT_MSEG1-WERKS AND  "19.5.21
             matnr EQ it_mseg1-matnr AND
            charg EQ it_mseg1-charg AND bwart EQ '101' AND lifnr NE space.
          SORT it_mseg2  DESCENDING BY mblnr.
        ENDIF.

*        IF IT_MSEG2 IS INITIAL.
*          IF IT_MSEG1 IS NOT INITIAL.
*            IF IT_BT1 IS NOT INITIAL.
*              SELECT * FROM MSEG INTO TABLE IT_MSEG3 FOR ALL ENTRIES IN IT_BT1 WHERE MJAHR EQ IT_BT1-MJAHR AND CHARG EQ IT_BT1-CHARG AND BWART EQ '101' AND LIFNR NE SPACE.
*              SORT IT_MSEG3  DESCENDING BY MBLNR.
*            ENDIF.
*          ENDIF.
*        ENDIF.

        IF it_mseg2 IS INITIAL.
          IF it_mseg1 IS NOT INITIAL.
            READ TABLE it_mcha INTO wa_mcha WITH KEY charg = wa_mseg1-charg.
            IF sy-subrc EQ 0.
              CLEAR : mjahr.
              mjahr = wa_mcha-ersda+0(4).
*              SELECT * FROM MSEG INTO TABLE IT_MSEG3 FOR ALL ENTRIES IN IT_MSEG1 WHERE MJAHR EQ MJAHR AND CHARG EQ IT_MSEG1-CHARG AND BWART EQ '101' AND LIFNR NE SPACE.
*              SORT IT_MSEG3  DESCENDING BY MBLNR.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
*****************************************************************************

      LOOP AT it_mseg1 INTO wa_mseg1 WHERE mblnr EQ wa_tab2-mblnr AND mjahr EQ wa_tab2-mjahr.
        CLEAR : maktx,licha,anzgeb,prueflos,sgtxt,vfdat,hsdat,v_name1, bsart, rwerks.
        SELECT SINGLE * FROM ekpo WHERE ebeln EQ wa_tab2-ebeln AND matnr EQ wa_mseg1-matnr .
*          ebelp eq wa_mseg1-ebelp.
        IF sy-subrc EQ 0.
          IF ekpo-knttp NE 'A' OR ekpo-knttp NE 'A'.
            ekpo-knttp = ekpo-knttp.
            CLEAR : maktx, normt,maktx1,maktx2.
            SELECT SINGLE * FROM makt WHERE spras EQ 'EN' AND matnr EQ wa_mseg1-matnr.
            IF sy-subrc EQ 0.
              maktx1 = makt-maktx.
            ENDIF.
            SELECT SINGLE * FROM makt WHERE spras EQ 'Z1' AND matnr EQ wa_mseg1-matnr.  "9.12.20
            IF sy-subrc EQ 0.
              maktx2 = makt-maktx.
            ENDIF.
            CONCATENATE maktx1 maktx2 INTO maktx SEPARATED BY space.
            SELECT SINGLE * FROM mara WHERE matnr EQ wa_mseg1-matnr.
            IF sy-subrc EQ 0.
              normt = mara-normt.
              mtart = mara-mtart.
            ENDIF.
            CONDENSE : maktx, normt.
            CONCATENATE maktx normt INTO maktx SEPARATED BY ','.

*            SELECT SINGLE * FROM EKKO WHERE EBELN EQ WA_MSEG1-EBELN.
*            IF SY-SUBRC EQ 0.
*              SELECT SINGLE * FROM ZPO_MATNR WHERE MATNR EQ WA_MSEG1-MATNR.
**                 AND EFFECTDT GE EKKO-AEDAT.
*              IF SY-SUBRC EQ 0.
*                IF EKKO-AEDAT GE ZPO_MATNR-EFFECTDT.
*                  MAKTX = EKPO-TXZ01.
*                  NORMT = SPACE.
*                ENDIF.
*              ENDIF.
*            ENDIF.
            SELECT SINGLE * FROM ekko WHERE ebeln EQ wa_mseg1-ebeln.
            IF sy-subrc EQ 0.
              SELECT SINGLE * FROM ekpa WHERE ebeln EQ wa_mseg1-ebeln AND parvw EQ 'HR'.
              IF sy-subrc EQ 0.
                SELECT SINGLE * FROM zpo_matnr WHERE matnr EQ wa_mseg1-matnr AND lifnr EQ ekpa-lifn2.
*                 AND EFFECTDT GE EKKO-AEDAT.
                IF sy-subrc EQ 0.
                  IF ekko-aedat GE zpo_matnr-effectdt.
*                  MAKTX = EKPO-TXZ01.
                    maktx = zpo_matnr-maktx.
                    normt = space.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.



*    WRITE : / '*', wa_mseg1-zeile,wa_mseg1-sgtxt.
            CLEAR cc.
            IF ekpo-knttp = 'A'.
              wa_mseg1-kostl = wa_mseg1-anln1+2(10).
            ENDIF.
            SELECT SINGLE * FROM mch1 WHERE matnr EQ wa_mseg1-matnr AND charg EQ wa_mseg1-charg. "comment 16.09.25 rushi
*              and werks eq wa_mseg1-werks and charg eq wa_mseg1-charg.
            IF sy-subrc EQ 0.
              licha = mch1-licha.
              vfdat = mch1-vfdat.
              hsdat = mch1-hsdat.
            ENDIF.
*************************** VENDOR BATCH*********************************************************************************************************
            CLEAR : rtdname1.
            CONCATENATE wa_mseg1-matnr wa_mseg1-werks wa_mseg1-charg INTO rtdname1.
*            RTDNAME1 = '00000000000010010010000000108421'.

            CALL FUNCTION 'READ_TEXT'
              EXPORTING
                client                  = sy-mandt
                id                      = 'VERM'
                language                = 'E'
                name                    = rtdname1
                object                  = 'CHARGE'
*               ARCHIVE_HANDLE          = 0
*            IMPORTING
*               HEADER                  = THEAD
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

            DATA : batch_details    TYPE TABLE OF clbatch,
                   wa_batch_details TYPE clbatch,
                   batchno          TYPE atwtb.

*     DATA : wa_inspe type TABLE of ZMB90_2B1.


            CALL FUNCTION 'VB_BATCH_GET_DETAIL' "added by rushi 24.09.25
              EXPORTING
                matnr              = wa_mseg1-matnr
                charg              = wa_mseg1-charg
                werks              = wa_mseg1-werks
                get_classification = 'X'
*               EXISTENCE_CHECK    =
*               READ_FROM_BUFFER   =
*               NO_CLASS_INIT      = ' '
*               LOCK_BATCH         = ' '
*       IMPORTING
*               YMCHA              =
*               CLASSNAME          =
*               BATCH_DEL_FLG      =
              TABLES
                char_of_batch      = batch_details
              EXCEPTIONS
                no_material        = 1
                no_batch           = 2
                no_plant           = 3
                material_not_found = 4
                plant_not_found    = 5
                no_authority       = 6
                batch_not_exist    = 7
                lock_on_batch      = 8
                OTHERS             = 9.
            IF sy-subrc <> 0.
* Implement suitable error handling here
            ENDIF.


            READ TABLE batch_details INTO wa_batch_details WITH KEY atnam = 'ZVENDOR_BATCH'.
*      IF SY-SUBRC = 0 .
*        WA_TAB5-BATCHNO  = WA_BATCH_DETAILS-ATWTB.
***       wa_tab5-PRUEFLOS = wa_inspe-QPLOS.
**        wa_tab5-PRUEFLOS = WA_QALS-QPLOS.
*      ENDIF.




            IF wa_tab2-budat GE '20200914'.
              IF licha+0(15) = r11+0(15).  "11.9.20  "long vendor batch

*                LICHA = R11.
                licha = wa_batch_details-atwtb. "changes in 24.09.25

              ENDIF.
            ENDIF.
**************************************************************************************************************************
*            sgtxt = wa_mseg1-sgtxt.
            SELECT SINGLE * FROM ekko WHERE ebeln EQ wa_tab2-ebeln.
            IF sy-subrc EQ 0.
              bsart = ekko-bsart.
              rwerks = ekko-reswk.
            ENDIF.
*            IF MTART EQ 'ZROH' AND BSART EQ 'ZL'.
            IF mtart EQ 'ZROH' AND ( bsart EQ 'ZL' OR bsart EQ 'ZI' ).

              IF wa_tab2-budat GE mfgdt.

                SELECT SINGLE * FROM zmigo WHERE mblnr EQ wa_mseg1-mblnr AND zeile EQ wa_mseg1-zeile.
                IF sy-subrc EQ 0.
                  SELECT SINGLE * FROM lfa1 WHERE lifnr EQ zmigo-mfgr.
                  IF sy-subrc EQ 0.
                    sgtxt = lfa1-name1.  "25.4.20
                  ENDIF.
*                ELSE.
*                  SGTXT = LFA1-NAME1.  "25.4.20
                ENDIF.
*                IF SGTXT EQ SPACE.  15.7.20
*                  SGTXT = WA_MSEG1-SGTXT. " 3.7.20
*                ENDIF.
              ELSE.
                sgtxt = wa_mseg1-sgtxt.
              ENDIF.
              IF sgtxt EQ space.
                IF wa_tab2-budat LE '20210112'.
                  sgtxt = wa_mseg1-sgtxt.
                ENDIF.
              ENDIF.
            ELSE.
              IF mtart EQ 'ZROH'.
                IF wa_tab2-budat GE '20210131'.
                  READ TABLE it_mseg2 INTO wa_mseg2 WITH KEY matnr = wa_mseg1-matnr charg = wa_mseg1-charg.
                  IF sy-subrc EQ 0.
                    SELECT SINGLE * FROM zmigo WHERE mblnr EQ wa_mseg2-mblnr AND zeile EQ wa_mseg2-zeile.
                    IF sy-subrc EQ 0.
                      SELECT SINGLE * FROM lfa1 WHERE lifnr EQ zmigo-mfgr.
                      IF sy-subrc EQ 0.
                        sgtxt = lfa1-name1.  "25.4.20
                      ENDIF.
                    ELSE.
                      sgtxt = wa_mseg1-sgtxt.
                    ENDIF.
                  ELSE.
*                    READ TABLE IT_MSEG3 INTO WA_MSEG3 WITH KEY CHARG = WA_MSEG1-CHARG.
*                    IF SY-SUBRC EQ 0.
*                      SELECT SINGLE * FROM ZMIGO WHERE MBLNR EQ WA_MSEG3-MBLNR AND ZEILE EQ WA_MSEG3-ZEILE.
*                      IF SY-SUBRC EQ 0.
*                        SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ ZMIGO-MFGR.
*                        IF SY-SUBRC EQ 0.
*                          SGTXT = LFA1-NAME1.  "25.4.20
*                        ENDIF.
*                      ELSE.
*                        SGTXT = WA_MSEG1-SGTXT.
*                      ENDIF.
*                    ENDIF.

                  ENDIF.

                ELSE.
                  sgtxt = wa_mseg1-sgtxt.
                ENDIF.
              ELSE.
                sgtxt = wa_mseg1-sgtxt.
              ENDIF.
            ENDIF.

            DATA : lt_ekpo TYPE ekpo, "ADDED BY RUSHI  24.09.25
                   lt_lfa1 TYPE lfa1.
            DATA :wa_lfa1_name1 TYPE lfa1-name1,
                  lv_mfg        TYPE string.

            DATA : wa_t001w TYPE t001w-ort01.

            SELECT * FROM ekpo INTO lt_ekpo WHERE ebeln = wa_mseg-ebeln AND ebelp = wa_mseg-ebelp .
            ENDSELECT.
            IF lt_ekpo IS NOT INITIAL .
              SELECT SINGLE name1 FROM lfa1 INTO wa_lfa1_name1 WHERE lifnr = lt_ekpo-mfrnr.
              IF sy-subrc = 0.
                sgtxt = wa_lfa1_name1.
              ENDIF.
            ENDIF.



*       SELECT SINGLE * FROM QALS WHERE MATNR EQ WA_MSEG1-MATNR AND WERK EQ WA_MSEG1-WERKS AND CHARG EQ WA_MSEG1-CHARG.
            READ TABLE it_qals INTO wa_qals WITH KEY werk = wa_mseg1-werks  matnr = wa_mseg1-matnr charg = wa_mseg1-charg mblnr = wa_mseg1-mblnr.
            IF sy-subrc EQ 0.
              anzgeb = wa_qals-anzgeb.
              prueflos = wa_qals-prueflos.
            ENDIF.
*      WA_MSEG1-KOSTL = WA_MSEG1-ANLN1.
*      2(10).
************************************
            CLEAR : vn_name1,vn_ort01,v_name1.
            IF bsart EQ 'ZSTO' AND  wa_tab2-budat GE mfgdt.  "as per AKG supplier will be sending plant 15.7.20 " changes in zub to ZSTO 25.09.25
              SELECT SINGLE * FROM t001w WHERE werks EQ rwerks.
              IF sy-subrc EQ 0.
                v_name1 = t001w-name1.
              ENDIF.
              SELECT SINGLE * FROM mch1 WHERE matnr EQ wa_mseg1-matnr AND charg EQ wa_mseg1-charg AND lifnr NE space.
              IF sy-subrc EQ 0.
                SELECT SINGLE * FROM lfa1 WHERE lifnr EQ mch1-lifnr.
                IF sy-subrc EQ 0.
                  vn_name1 = lfa1-name1.
                  vn_ort01 = lfa1-ort01.
                ENDIF.
              ENDIF.
            ELSE.
              SELECT SINGLE * FROM lfa1 WHERE lifnr EQ wa_mseg1-lifnr.
              IF sy-subrc EQ 0.
                v_name1 = lfa1-name1.
              ELSE.
                SELECT SINGLE * FROM qals WHERE matnr EQ wa_mseg1-matnr AND charg EQ wa_mseg1-charg AND sellifnr NE '          '.
                IF sy-subrc EQ 0.
                  SELECT SINGLE * FROM lfa1 WHERE lifnr EQ qals-lifnr.
                  IF sy-subrc EQ 0.
                    v_name1 = lfa1-name1.
                  ENDIF.
                ELSE.
                  SELECT SINGLE * FROM mch1 WHERE matnr EQ wa_mseg1-matnr AND charg EQ wa_mseg1-charg AND lifnr GE '0000010000' AND lifnr LE '0000029999'.
                  IF sy-subrc EQ 0.
                    SELECT SINGLE * FROM lfa1 WHERE lifnr EQ mch1-lifnr.
                    IF sy-subrc EQ 0.
                      v_name1 = lfa1-name1.
                    ENDIF.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
******************************



*            if bsart eq 'ZUB'.
*              IF WA_TAB2-BUDAT GE MFGDT.
            IF wa_tab2-budat GE '20200727'.
              CALL FUNCTION 'WRITE_FORM'  "AS ADVISED BY AKG ADDED ORIGINAL SUPPLIER.
                EXPORTING
                  element = 'AN'
                  window  = 'MAIN'.
            ELSE.
              CALL FUNCTION 'WRITE_FORM'
                EXPORTING
                  element = 'A3'
                  window  = 'MAIN'.
            ENDIF.
*            else.
*              call function 'WRITE_FORM'
*                exporting
*                  element = 'A3'
*                  window  = 'MAIN'.
*            endif.

            SELECT SINGLE * FROM ekpo WHERE ebeln EQ wa_tab2-ebeln AND ebelp EQ wa_mseg1-ebelp.
            IF sy-subrc EQ 0.
*      WRITE : / 'E',ekpo-knttp.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'A2'
*          WINDOW  = 'MAIN'.
            ENDIF.
*    WRITE : wa_mseg1-kostl,wa_mseg1-erfmg,wa_mseg1-erfme.
*    CALL FUNCTION 'WRITE_FORM'
*      EXPORTING
*        ELEMENT = 'A3'
*        WINDOW  = 'MAIN'.
            AT END OF mblnr .
              CALL FUNCTION 'WRITE_FORM'
                EXPORTING
                  element = 'A31'
                  window  = 'MAIN'.
            ENDAT.
          ENDIF.
        ENDIF.

        IF wa_tab2-budat LT '20200806' AND wa_tab2-werks EQ '1001'.
          format1 = 'ST/GM/002-20-F3'.
        ELSEIF bsart EQ 'ZSTO' AND wa_tab2-werks EQ '1001'. " changes in zub to ZSTO 25.09.25
          format1 = 'ST/GM/002-F6'.
        ELSEIF wa_tab2-werks EQ '1001'.
          format1 = 'ST/GM/002-F3'.
        ENDIF.

      ENDLOOP.

*      if wa_tab2-budat lt '20200615' and wa_tab2-werks eq '1001'.
*        format1 = 'ST/GM/002-20-F3'.
*      elseif bsart eq 'ZUB' and wa_tab2-werks eq '1001'.
*        format1 = 'ST/GM/002-F6'.
*      elseif wa_tab2-werks eq '1001'.
*        format1 = 'ST/GM/002-F3'.
*      endif.

      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'A5'
          window  = 'WINDOW2'.
      CALL FUNCTION 'END_FORM'
        EXCEPTIONS
          unopened                 = 1
          bad_pageformat_for_print = 2
          spool_error              = 3
          codepage                 = 4
          OTHERS                   = 5.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.



    ENDLOOP.
  ENDIF.

  CALL FUNCTION 'CLOSE_FORM'
    EXCEPTIONS
      unopened                 = 1
      bad_pageformat_for_print = 2
      send_error               = 3
      spool_error              = 4
      codepage                 = 5
      OTHERS                   = 6.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  POVIEW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM poview .
  SELECT * FROM ekpo INTO TABLE it_ekpo WHERE ebeln IN po AND loekz EQ space.

  IF it_ekpo IS NOT INITIAL.
    LOOP AT it_ekpo INTO wa_ekpo.
      wa_tap1-ebeln = wa_ekpo-ebeln.
      wa_tap1-ebelp = wa_ekpo-ebelp.
      wa_tap1-matnr = wa_ekpo-matnr.
      wa_tap1-txz01 = wa_ekpo-txz01.
      wa_tap1-menge = wa_ekpo-menge.
      wa_tap1-meins = wa_ekpo-meins.
      wa_tap1-netpr = wa_ekpo-netpr.
      wa_tap1-peinh = wa_ekpo-peinh.
      wa_tap1-netwr = wa_ekpo-netwr.
      wa_tap1-banfn = wa_ekpo-banfn.
      wa_tap1-bnfpo = wa_ekpo-bnfpo.
      SELECT SINGLE * FROM eban WHERE banfn EQ wa_ekpo-banfn AND bnfpo EQ wa_ekpo-bnfpo.
      IF sy-subrc EQ 0.
        CLEAR: bednr.
*        WRITE: EBAN-BEDNR.
        UNPACK eban-bednr TO bednr.
        wa_tap1-bednr = bednr.
        SELECT SINGLE * FROM pa0001 WHERE pernr EQ bednr AND endda GE sy-datum.
        IF sy-subrc EQ 0.
          wa_tap1-ename = pa0001-ename.
          SELECT SINGLE * FROM t001p WHERE btrtl EQ pa0001-btrtl AND molga EQ '40'.
          IF sy-subrc EQ 0.
            wa_tap1-btext = t001p-btext.
          ENDIF.
        ENDIF.
      ENDIF.
      COLLECT wa_tap1 INTO it_tap1.
      CLEAR wa_tap1.
    ENDLOOP.
  ENDIF.

  LOOP AT it_tap1 INTO wa_tap1.
    IF wa_tap1-matnr GT 0.
      PACK : wa_tap1-matnr TO wa_tap1-matnr.
    ENDIF.
    CONDENSE : wa_tap1-matnr.
    MODIFY it_tap1 FROM wa_tap1 TRANSPORTING matnr.
  ENDLOOP.





  wa_fieldcat-fieldname = 'EBELN'.
  wa_fieldcat-seltext_l = 'PO. NO.'.
  APPEND wa_fieldcat TO fieldcat.


  wa_fieldcat-fieldname = 'EBELP'.
  wa_fieldcat-seltext_l = 'ITEM NO'.
  APPEND wa_fieldcat TO fieldcat.


  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_l = 'ITEM CODE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'TXZ01'.
  wa_fieldcat-seltext_l = 'MATERIAL'.
  APPEND wa_fieldcat TO fieldcat.




  wa_fieldcat-fieldname = 'MENGE'.
  wa_fieldcat-seltext_l = 'TOTAL QTY'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'MEINS'.
  wa_fieldcat-seltext_l = 'UOM'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'NETPR'.
  wa_fieldcat-seltext_l = 'NET RATE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'PEINH'.
  wa_fieldcat-seltext_l = 'PER'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'NETWR'.
  wa_fieldcat-seltext_l = 'TOT NET VAL'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'BEDNR'.
  wa_fieldcat-seltext_l = 'TRACKING NO.'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'ENAME'.
  wa_fieldcat-seltext_l = 'EMPLOYEE NAME'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'BTEXT'.
  wa_fieldcat-seltext_l = 'DEPATYMENT'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'BANFN'.
  wa_fieldcat-seltext_l = 'PO REQ. NO'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'BNFPO'.
  wa_fieldcat-seltext_l = 'REQ. ITEM NO'.
  APPEND wa_fieldcat TO fieldcat.







*   WA_FIELDCAT-fieldname = 'ELIKZ'.
*  WA_FIELDCAT-seltext_s = 'DEL. INDICATOR'.
*  APPEND WA_FIELDCAT TO FIELDCAT.



  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'PO DETAILS'.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = g_repid
      i_callback_user_command = 'USER_COMM'
      i_callback_top_of_page  = 'TOP'
      is_layout               = layout
      it_fieldcat             = fieldcat
      i_save                  = 'A'
    TABLES
      t_outtab                = it_tap1
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.

FORM top.

  DATA: comment    TYPE slis_t_listheader,
        wa_comment LIKE LINE OF comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'PURCHASE ORDER DETAILS'.
*  WA_COMMENT-INFO = P_FRMDT.
  APPEND wa_comment TO comment.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = comment
*     I_LOGO             = 'ENJOYSAP_LOGO'
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .

  CLEAR comment.

ENDFORM.                    "TOP



*&---------------------------------------------------------------------*
*&      Form  USER_COMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->UCOMM      text
*      -->SELFIELD   text
*----------------------------------------------------------------------*
FORM user_comm USING ucomm LIKE sy-ucomm
                     selfield TYPE slis_selfield.



  CASE selfield-fieldname.
    WHEN 'EBELN'.
      SET PARAMETER ID 'BES' FIELD selfield-value.
      CALL TRANSACTION 'ME23N' AND SKIP FIRST SCREEN.
    WHEN 'VBELN1'.
      SET PARAMETER ID 'BV' FIELD selfield-value.
      CALL TRANSACTION 'VL03N' AND SKIP FIRST SCREEN.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.                    "USER_COMM
*&---------------------------------------------------------------------*
*&      Form  PASS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM pass .
*  select single * from zpassw where pernr = pernr.   """"""""""""" CMT BY NC 15.09.2025
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
*  clear : pass.
*  pass = '   '.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GRNCHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM grncheck .
  CLEAR : noninv,ebeln,ebelp.
  noninv = 0.
*  SELECT * FROM mseg INTO TABLE it_mseg WHERE mblnr in grn AND mjahr eq year AND werks eq plant AND ebeln gt 0.
*    if it_mseg IS NOT INITIAL.
*      Read TABLE it_mseg INTO wa_mseg with KEY  MJAHR = YEAR  WERKS = PLANT
*    ENDIF.
  SELECT SINGLE * FROM mseg WHERE mblnr EQ mblnr1 AND mjahr EQ year AND werks EQ plant AND ebeln GT 0.
  IF sy-subrc EQ 0.
    ebeln = mseg-ebeln.
    ebelp = mseg-ebelp.
    SELECT SINGLE * FROM ekko WHERE ebeln EQ mseg-ebeln AND bsart IN ( 'ZNIV','ZSER' ,'ZDOM' ).
    IF sy-subrc EQ 0.
      noninv = 1.
    ENDIF.
  ENDIF.
  IF noninv EQ 1.
    PERFORM checkdept1.
  ELSE.
    PERFORM checkdept.
  ENDIF.
  SELECT SINGLE * FROM mseg WHERE mblnr EQ mblnr1 AND mjahr EQ year AND werks EQ plant.
  IF sy-subrc EQ 0.
    SELECT SINGLE * FROM zmigo_chk WHERE mblnr  EQ mseg-mblnr.
    IF sy-subrc EQ 0.
      MESSAGE 'THIS GRN IS ALREDAY APPROVED ' TYPE 'E'.
    ENDIF.
    wa_chk1-mblnr = mseg-mblnr.
    wa_chk1-mjahr = mseg-mjahr.
    wa_chk1-chkby = space.
    COLLECT wa_chk1 INTO it_chk1.
    CLEAR wa_chk1.
  ENDIF.
  CALL SCREEN 9001.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  STATUS_9001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9001 OUTPUT.
*  SET PF-STATUS 'STATUS'.
  SET PF-STATUS 'ZSTATUS'.
  SET TITLEBAR 'TITLE'.
  PERFORM pbo.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM pbo .
*  BREAK-POINT.

  CREATE OBJECT c_ccont
    EXPORTING
      container_name = 'CCONT'.
*  create object for alv grid


  CREATE OBJECT c_alvgd
    EXPORTING
      i_parent = cl_gui_custom_container=>screen0.

*  SET FIELD FOR ALV
  PERFORM alv_build_fieldcat1.
* Set ALV attributes FOR LAYOUT
  PERFORM alv_report_layout.
  CHECK NOT c_alvgd IS INITIAL.
* Call ALV GRID
  CALL METHOD c_alvgd->set_table_for_first_display
    EXPORTING
      is_layout                     = it_layout
      i_save                        = 'A'
    CHANGING
      it_outtab                     = it_chk1
      it_fieldcatalog               = it_fcat
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_BUILD_FIELDCAT1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_build_fieldcat1 .
  DATA lv_fldcat TYPE lvc_s_fcat.
  CLEAR :   lv_fldcat.

  lv_fldcat-fieldname = 'MBLNR'.
  lv_fldcat-scrtext_l = 'GRN NO.'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'MJAHR'.
  lv_fldcat-scrtext_l = 'GRN YEAR'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'CHKBY'.
  lv_fldcat-scrtext_l = 'APPROVED'.
  lv_fldcat-edit = 'X'.
  lv_fldcat-checkbox = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_REPORT_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_report_layout .
  it_layout-cwidth_opt = 'X'.
  it_layout-col_opt = 'X'.
  it_layout-zebra = 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9001 INPUT.
  CASE ok_code.
    WHEN 'SAVE'.
      PERFORM checkedbyupd.
    WHEN 'BACK'.
*      MESSAGE 'CHECK2' TYPE 'I'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  CHECKEDBYUPD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM checkedbyupd .
  IF r31 EQ 'X'.

    c_alvgd->check_changed_data( ).
    CASE ok_code.
      WHEN 'SAVE'.

*        *Cells of the alv are made non editable after entering OK to save
        CALL METHOD c_alvgd->set_ready_for_input
          EXPORTING
            i_ready_for_input = 0.
*Row and column of the alv are refreshed after changing values
        stable-row = 'X'.
        stable-col = 'X'.
*REfreshed ALV display with the changed values
*This ALV is non editable and contains new values
        CALL METHOD c_alvgd->refresh_table_display
          EXPORTING
            is_stable = stable
          EXCEPTIONS
            finished  = 1
            OTHERS    = 2.
        IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.

        PERFORM savegrnchk.
*  PERFORM INSPCHK.
      WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
        LEAVE PROGRAM.
    ENDCASE.
    CLEAR: ok_code.
  ELSE.
    CASE ok_code.
      WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
        LEAVE PROGRAM.
    ENDCASE.
    CLEAR: ok_code.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SAVEGRNCHK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM savegrnchk .
  LOOP AT it_chk1 INTO wa_chk1 WHERE chkby NE space.
    SELECT SINGLE * FROM zmigo_chk WHERE mblnr  EQ wa_chk1-mblnr.
    IF sy-subrc EQ 4.

      zmigo_chk_wa-mblnr = wa_chk1-mblnr.
      zmigo_chk_wa-mjahr = wa_chk1-mjahr.
      zmigo_chk_wa-pernr = pernr.
      zmigo_chk_wa-uname = sy-uname.
      zmigo_chk_wa-cpudt = sy-datum.
      zmigo_chk_wa-cputm = sy-uzeit.

      MODIFY zmigo_chk FROM zmigo_chk_wa .
      CLEAR zmigo_chk_wa.
    ENDIF.
  ENDLOOP.
  IF sy-subrc EQ 0.
    MESSAGE 'DATA SAVED' TYPE 'I'.
  ENDIF.
  SET SCREEN 0.
  EXIT.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CHECKDEPT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM checkdept .
  CLEAR : depth.
  IF plant EQ '1000'.
    SELECT SINGLE * FROM zqms_depthead1 WHERE btrtl EQ '1222' AND to_dt GE sy-datum.
*    IF SY-SUBRC EQ 0.                                              """RN
*      IF PERNR = ZQMS_DEPTHEAD1-PERNR.
*        DEPTH = 'Y'.
*      ELSEIF PERNR = ZQMS_DEPTHEAD1-REVIEWER.
*        DEPTH = 'Y'.
*      ELSEIF PERNR = ZQMS_DEPTHEAD1-APPROVER.
*        DEPTH = 'Y'.
*      ENDIF.
*    ENDIF.
    SELECT SINGLE * FROM pa0001 WHERE btrtl EQ '1222' AND endda GE sy-datum.  ""PERNR EQ PERNR AND BTRTL EQ '1222' AND ENDDA GE SY-DATUM.  "ADDED ON 13.10.23 ""RN
    IF sy-subrc EQ 0.
      depth = 'Y'.
    ENDIF.

      CLEAR : pernr.
    SELECT SINGLE * FROM pa0105 WHERE usrid EQ sy-uname.
    IF sy-subrc EQ 0.
      pernr = pa0105-pernr.
    ENDIF.

    SELECT SINGLE * FROM zPA0001 WHERE pernr EQ pernr AND btrtl EQ '1222' AND endda GE sy-datum.     "PERNR EQ PERNR AND BTRTL EQ '1322' AND ENDDA GE SY-DATUM. ""RN
    IF sy-subrc EQ 0.
      depth = 'Y'.
    ENDIF.

  ELSEIF plant EQ '1001'.
    SELECT SINGLE * FROM zqms_depthead1 WHERE btrtl EQ '1322' AND to_dt GE sy-datum..
*    IF SY-SUBRC EQ 0.                                """RN
*      IF PERNR = ZQMS_DEPTHEAD1-PERNR.
*        DEPTH = 'Y'.
*      ELSEIF PERNR = ZQMS_DEPTHEAD1-REVIEWER.
*        DEPTH = 'Y'.
*      ELSEIF PERNR = ZQMS_DEPTHEAD1-APPROVER.
*        DEPTH = 'Y'.
*      ENDIF.
*    ENDIF.

*    SELECT SINGLE * FROM PA0001 WHERE BTRTL EQ '1322' AND ENDDA GE SY-DATUM.     "PERNR EQ PERNR AND BTRTL EQ '1322' AND ENDDA GE SY-DATUM. ""RN
*    IF SY-SUBRC EQ 0.
*      DEPTH = 'Y'.
*    ENDIF.
    CLEAR : pernr.
    SELECT SINGLE * FROM pa0105 WHERE usrid EQ sy-uname.
    IF sy-subrc EQ 0.
      pernr = pa0105-pernr.
    ENDIF.

    SELECT SINGLE * FROM zPA0001 WHERE pernr EQ pernr AND btrtl EQ '1322' AND endda GE sy-datum.     "PERNR EQ PERNR AND BTRTL EQ '1322' AND ENDDA GE SY-DATUM. ""RN
    IF sy-subrc EQ 0.
      depth = 'Y'.
    ENDIF.

  ENDIF.
  IF depth NE 'Y'.
    MESSAGE 'INVALID APPROVER FOR GRN' TYPE 'E'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DATA1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM data1 .
  CLEAR : it_ninv2,wa_ninv2,it_po1,wa_po1.
  LOOP AT it_ninv1 INTO wa_ninv1 WHERE mblnr EQ wa_mseg-mblnr AND mjahr EQ wa_mseg-mjahr.
    wa_ninv2-sgtxt = wa_ninv1-sgtxt.
    wa_ninv2-knttp = wa_ninv1-knttp.
    wa_ninv2-asset = wa_ninv1-asset.
    wa_ninv2-erfmg = wa_ninv1-erfmg.
    wa_ninv2-erfme = wa_ninv1-erfme.
    wa_ninv2-zeile = wa_ninv1-zeile.
    wa_ninv2-ebeln = wa_ninv1-ebeln.
    COLLECT wa_ninv2 INTO it_ninv2.
    CLEAR wa_ninv2.

    wa_po1-ebeln = wa_ninv1-ebeln.
    SELECT SINGLE * FROM ekko WHERE ebeln EQ  wa_ninv1-ebeln.
    IF sy-subrc EQ 0.
      wa_po1-aedat = ekko-aedat.
      wa_po1-lifnr = ekko-lifnr.
      SELECT SINGLE * FROM lfa1 WHERE lifnr EQ ekko-lifnr.
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM adrc WHERE addrnumber EQ lfa1-adrnr.
        IF sy-subrc EQ 0.
          wa_po1-name1 = adrc-name1.
        ENDIF.
      ENDIF.
    ENDIF.
    SELECT SINGLE * FROM mkpf WHERE mblnr EQ wa_mseg-mblnr.
    IF sy-subrc EQ 0.
      wa_po1-bldat = mkpf-bldat.
      wa_po1-xblnr = mkpf-xblnr.
    ENDIF.

    COLLECT wa_po1 INTO it_po1.
    CLEAR wa_po1.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CHECKDEPT1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM checkdept1 .
  CLEAR : depth,depthead.
  SELECT SINGLE * FROM eban WHERE ebeln EQ ebeln AND ebelp EQ ebelp AND loekz EQ space.
  IF sy-subrc EQ 0.
    SELECT SINGLE * FROM zpur_req1 WHERE banfn EQ eban-banfn AND bnfpo EQ eban-bnfpo.
    IF sy-subrc EQ 0.
      depthead = zpur_req1-btrtl.
    ENDIF.
  ENDIF.
  IF depthead IS INITIAL.
    SELECT SINGLE * FROM ekpo WHERE ebeln EQ ebeln AND ebelp EQ ebelp AND bednr NE space AND loekz EQ space.
    IF sy-subrc EQ 0.
      CONDENSE ekpo-bednr.
      depthead = ekpo-bednr.
    ENDIF.
  ENDIF.
  IF depthead GT 0.
    SELECT SINGLE * FROM zqms_depthead1 WHERE btrtl EQ depthead AND to_dt GE sy-datum..
**    IF SY-SUBRC EQ 0.                                  """RN
**      IF PERNR = ZQMS_DEPTHEAD1-PERNR.
**        DEPTH = 'Y'.
**      ELSEIF PERNR = ZQMS_DEPTHEAD1-REVIEWER.
**        DEPTH = 'Y'.
**      ELSEIF PERNR = ZQMS_DEPTHEAD1-APPROVER.
**        DEPTH = 'Y'.
***      ELSEIF PERNR = ZQMS_DEPTHEAD1-PERNR1.
***        DEPTH = 'Y'.
**      ENDIF.
**    ENDIF.

    SELECT SINGLE * FROM zqms_depthead2 WHERE btrtl EQ depthead AND from_dt LE sy-datum AND to_dt GE sy-datum..
*    IF SY-SUBRC EQ 0.                       """"RN
*      IF PERNR = ZQMS_DEPTHEAD2-PERNR.
*        DEPTH = 'Y'.
*      ENDIF.
*    ENDIF.
*    IF DEPTHEAD EQ '1315'.
*      IF PERNR EQ '00005059'.
*        DEPTH = 'Y'.
*      ENDIF.
*    ENDIF.
*
*
*
*  ENDIF.

******************allow store************
    IF plant EQ '1000'.
      SELECT SINGLE * FROM zqms_depthead1 WHERE btrtl EQ '1222' AND to_dt GE sy-datum..
*    IF SY-SUBRC EQ 0.                                           ""RN
*      IF PERNR = ZQMS_DEPTHEAD1-PERNR.
*        DEPTH = 'Y'.
*      ELSEIF PERNR = ZQMS_DEPTHEAD1-REVIEWER.
*        DEPTH = 'Y'.
*      ELSEIF PERNR = ZQMS_DEPTHEAD1-APPROVER.
*        DEPTH = 'Y'.
*      ELSEIF PERNR = ZQMS_DEPTHEAD1-PERNR1.
*        DEPTH = 'Y'.
*      ENDIF.
    ENDIF.
    SELECT SINGLE * FROM pa0001 WHERE btrtl EQ '1222' AND endda GE sy-datum. " PERNR EQ PERNR AND BTRTL EQ '1222' AND ENDDA GE SY-DATUM.  "ADDED ON 13.10.23 """RN
    IF sy-subrc EQ 0.
      depth = 'Y'.
    ENDIF.
     CLEAR : pernr.
    SELECT SINGLE * FROM pa0105 WHERE usrid EQ sy-uname.
    IF sy-subrc EQ 0.
      pernr = pa0105-pernr.
    ENDIF.
    SELECT SINGLE * FROM zPA0001 WHERE  pernr EQ pernr AND btrtl EQ '1222' AND endda GE sy-datum.
    IF sy-subrc EQ 0.
      depth = 'Y'.
    ENDIF.

  ELSEIF plant EQ '1001'.
    SELECT SINGLE * FROM zqms_depthead1 WHERE btrtl EQ '1322' AND to_dt GE sy-datum..
    IF sy-subrc EQ 0.                          ""RN
      IF pernr = zqms_depthead1-pernr.
        depth = 'Y'.
      ELSEIF pernr = zqms_depthead1-reviewer.
        depth = 'Y'.
      ELSEIF pernr = zqms_depthead1-approver.
        depth = 'Y'.
      ELSEIF pernr = zqms_depthead1-pernr1.
        depth = 'Y'.
      ENDIF.
    ENDIF.
*    SELECT SINGLE * FROM PA0001 WHERE BTRTL EQ '1322' AND   PERNR EQ PERNR AND BTRTL EQ '1322' AND ENDDA GE SY-DATUM.
*    IF SY-SUBRC EQ 0.
*      DEPTH = 'Y'.
*    ENDIF.
    CLEAR : pernr.
    SELECT SINGLE * FROM pa0105 WHERE usrid EQ sy-uname.
    IF sy-subrc EQ 0.
      pernr = pa0105-pernr.
    ENDIF.
    SELECT SINGLE * FROM zPA0001 WHERE  pernr EQ pernr AND btrtl EQ '1322' AND endda GE sy-datum.
    IF sy-subrc EQ 0.
      depth = 'Y'.
    ENDIF.
  ENDIF.
**********************************************
depth = 'Y'.

  IF depth NE 'Y'.
    MESSAGE 'INVALID APPROVER FOR GRN' TYPE 'E'.
  ENDIF.




ENDFORM.
