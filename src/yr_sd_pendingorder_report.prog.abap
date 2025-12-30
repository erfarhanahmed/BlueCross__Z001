*&---------------------------------------------------------------------*
*& Report YR_SD_PENDINGORDER_REPORT
*developed by Madhavi.
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT yr_sd_pendingorder_report.


TABLES: ysdir1,
        t001w,
        zpenexclude.

TYPES: BEGIN OF ty_makt,
         matnr TYPE matnr,
         maktx TYPE makt-maktx,
       END OF ty_makt.

TYPES: BEGIN OF ty_mvke,
         matnr TYPE mvke-matnr,
         vkorg TYPE mvke-vkorg,
         vtweg TYPE mvke-vtweg,
         mvgr5 TYPE mvke-mvgr5,
       END OF ty_mvke.

TYPES: BEGIN OF ty_tvm5t,
         mvgr5 TYPE mvke-mvgr5,
         bezei TYPE tvm5t-bezei,
       END OF ty_tvm5t.
*


TYPES: BEGIN OF typ_inv,
         vbeln   TYPE vbeln_vf,
         posnr_i TYPE posnr_vf,
         vbtyp   TYPE vbtyp,
         knumv   TYPE knumv,
         fkdat   TYPE fkdat,
         fkimg_i TYPE fkimg,
         vrkme_i TYPE vrkme,
         netwr_i TYPE netwr,
         matnr_i TYPE matnr,
         werks_i TYPE werks,
       END OF typ_inv.

TYPES: BEGIN OF ty_final,
         matnr   TYPE matnr,
         maktx   TYPE maktx,
         salpack TYPE string,
         pendqty TYPE i,
         value   TYPE i,
         holdqty TYPE i,
         holdval TYPE i,
       END OF ty_final.

TYPES: BEGIN OF typ_mard,
         matnr TYPE matnr,
         werks TYPE werks_d,
         lgort TYPE lgort_d,
         labst TYPE labst,
         insme TYPE insme,
         einme TYPE einme,
         speme TYPE speme,
         retme TYPE retme,
       END OF typ_mard.

TYPES: BEGIN OF ty_mard,
         matnr TYPE matnr,
         werks TYPE werks,
         labst TYPE mard-labst,
       END OF ty_mard.

TYPES: BEGIN OF typ_marc,
         matnr TYPE matnr,
         werks TYPE werks_d,
         trame TYPE trame,
       END OF typ_marc.

TYPES: BEGIN OF ty_werks,
         matnr  TYPE matnr,
         werks  TYPE werks_d,
         kwmeng TYPE ysdir1-kwmeng,
         netwr  TYPE ysdir1-netwr,
       END OF ty_werks.

TYPES: BEGIN OF typ_ysdir1,
         vbeln    TYPE vbeln,
         vbeln_1  TYPE vbeln,
         posnr    TYPE posnr,
         vbeln_2  TYPE vbeln,
         vbeln_3  TYPE vbeln,
         posnr_3  TYPE posnr,
         gbstk    TYPE ysdir1-gbstk,
         cmgst    TYPE ysdir1-cmgst,
         spstg    TYPE ysdir1-spstg,
         lfsta    TYPE ysdir1-lfsta,
         gbsta    TYPE ysdir1-gbsta,
         kunnr    TYPE kunnr,
         matnr    TYPE matnr,
         netwr    TYPE netwr_ap,
         waerk    TYPE waerk,
         kwmeng   TYPE kwmeng,
         vrkme    TYPE vrkme,
         werks    TYPE werks_ext,
         netvalue TYPE dmbtr,
       END OF typ_ysdir1.

TYPES: BEGIN OF typ_matnr,
         matnr TYPE matnr,
       END OF typ_matnr.

TYPES: BEGIN OF typ_makt,
         matnr TYPE matnr,
         spras TYPE spras,
         maktx TYPE maktx,
       END OF typ_makt.

TYPES: BEGIN OF ty_knvv,
         kunnr TYPE knvv-kunnr,
         kdgrp TYPE knvv-kdgrp,
       END OF ty_knvv.

TYPES: BEGIN OF typ_t001w,
         werks TYPE werks_d,
         name1 TYPE name1,
       END OF typ_t001w.

TYPES: BEGIN OF typ_mara,
         matkl TYPE matkl,
         matnr TYPE matnr,
         spart TYPE spart,
       END OF typ_mara.

TYPES: BEGIN OF typ_vbfa1,
         vbelv   TYPE vbeln_von,
         posnv   TYPE posnr_von,
         vbeln   TYPE vbeln_nach,
         posnn   TYPE posnr_nach,
         vbtyp_n TYPE vbtyp_n,
         rfmng   TYPE rfmng,
         meins   TYPE meins,
       END OF typ_vbfa1.

TYPES: BEGIN OF ty_vbfa,
         vbelv   TYPE vbeln_von,
         posnv   TYPE posnr_von,
         vbeln   TYPE vbeln_nach,
         posnn   TYPE posnr_nach,
         vbtyp_n TYPE vbtyp_n,
         rfmng   TYPE rfmng,
         meins   TYPE meins,
       END OF ty_vbfa.

TYPES: BEGIN OF typ_mvke,
         matnr TYPE matnr,
         vkorg TYPE vkorg,
         vtweg TYPE vtweg,
         mvgr5 TYPE mvgr5,
       END OF typ_mvke.

TYPES: BEGIN OF typ_konp,
         knumh TYPE knumh,
         kopos TYPE kopos,
         kbetr TYPE kbetr,
         konwa TYPE konwa,
       END OF typ_konp.

TYPES: BEGIN OF typ_t023t,
         spras TYPE spras,
         matkl TYPE matkl,
         wgbez TYPE wgbez,
       END OF typ_t023t.

TYPES: BEGIN OF typ_knumv,
         knumv TYPE knumv,
       END OF typ_knumv.

TYPES: BEGIN OF typ_vbeln,
         vbeln TYPE vbeln,
         posnr TYPE posnr,
       END OF typ_vbeln.

TYPES: BEGIN OF typ_konv,
         knumv TYPE knumv,
         kposn TYPE kposn,
         stunr TYPE stunr,
         zaehk TYPE dzaehk,
         kwert TYPE kwert,
       END OF typ_konv.

TYPES: BEGIN OF  typ_kunnr,
         kunnr TYPE kunnr,
       END OF typ_kunnr.

TYPES: BEGIN OF typ_bsid,
         bukrs TYPE bukrs,
         kunnr TYPE kunnr,
         umsks TYPE umsks,
         umskz TYPE umskz,
         augdt TYPE augdt,
         augbl TYPE augbl,
         zuonr TYPE dzuonr,
         gjahr TYPE gjahr,
         belnr TYPE belnr_d,
         buzei TYPE buzei,
         budat TYPE budat,
         blart TYPE blart,
         bschl TYPE bschl,
         shkzg TYPE shkzg,
         gsber TYPE gsber,
         dmbtr TYPE dmbtr,
         zfbdt TYPE dzfbdt,
         zbd1t TYPE dzbd1t,
         vbeln TYPE vbeln,
       END OF typ_bsid.


TYPES: BEGIN OF ty_knkk,
         kunnr TYPE kunnr,
         klimk TYPE knkk-klimk,
         skfor TYPE knkk-skfor,
       END OF ty_knkk.

TYPES: BEGIN OF ty_cust,
         kunnr TYPE kunnr,
       END OF ty_cust.


DATA:
  it_makt   TYPE TABLE OF ty_makt,
  wa_makt   TYPE ty_makt,
  it_mvke   TYPE TABLE OF ty_mvke,
  wa_mvke   TYPE ty_mvke,
  it_tvm5t  TYPE TABLE OF ty_tvm5t,
  wa_tvm5t  TYPE ty_tvm5t,
  it_output TYPE TABLE OF yrpending_sat,
  wa_output TYPE yrpending_sat,
  g_date    TYPE string,
  g_date1   TYPE string,
  l_date    TYPE sy-datum,
  l_date1   TYPE sy-datum,
  l_day     TYPE char2,
  l_month   TYPE char2,
  l_year    TYPE char4,
  l_day1    TYPE char2,
  l_month1  TYPE char2,
  l_year1   TYPE char4,
  g_header  TYPE string,
  g_pendqty TYPE string,
  g_value   TYPE string,
  g_holdqty TYPE string,
  g_holdval TYPE string.

DATA:
      fm_name TYPE rs38l_fnam.

DATA: itab_inv          TYPE TABLE OF typ_inv,
      itab_mard         TYPE TABLE OF typ_mard,
      itab_marc         TYPE TABLE OF typ_marc,
      itab_ysdir1       TYPE TABLE OF typ_ysdir1,
      wa_ysdir1         TYPE typ_ysdir1,
      itab_credit       TYPE TABLE OF typ_ysdir1,
      wa_credit         TYPE typ_ysdir1,
      itab_crelimit     TYPE TABLE OF typ_ysdir1,
      wa_crelimit       TYPE typ_ysdir1,
      it_mard           TYPE TABLE OF ty_mard,
      it_werks          TYPE TABLE OF ty_werks,
      wa_werks          TYPE ty_werks,
      wa_mard           TYPE ty_mard,
      it_mard1          TYPE TABLE OF ty_mard,
      wa_mard1          TYPE ty_mard,
      itab_overdue      TYPE TABLE OF typ_ysdir1,
      wa_overdue        TYPE typ_ysdir1,
      itab_po           TYPE TABLE OF typ_ysdir1,
      it_po_werks       TYPE TABLE OF typ_ysdir1,
      wa_po_werks       TYPE typ_ysdir1,
      wa_po             TYPE typ_ysdir1,
      itab_others       TYPE TABLE OF typ_ysdir1,
      itab_others_werks TYPE TABLE OF typ_ysdir1,
      wa_others_werks   TYPE typ_ysdir1,
      wa_others         TYPE typ_ysdir1,
      itab_vbeln        TYPE TABLE OF typ_vbeln,
      wa_vbeln          TYPE typ_vbeln,
      itab_kunnr        TYPE TABLE OF typ_kunnr,
      wa_kunnr          TYPE typ_kunnr,
      itab_matnr        TYPE TABLE OF typ_matnr,
      itab_vbfa         TYPE TABLE OF ty_vbfa,
      wa_vbfa           TYPE ty_vbfa,
      itab_bsid         TYPE TABLE OF typ_bsid,
      itab_vbfa1        TYPE TABLE OF typ_vbfa1,
      wa_vbfa1          TYPE typ_vbfa1,
      itab_makt         TYPE TABLE OF typ_makt,
      it_final          TYPE TABLE OF ty_final,
      wa_final          TYPE ty_final,
      itab_t001w        TYPE TABLE OF typ_t001w,
      itab_t001w1       TYPE TABLE OF typ_t001w,
      wa_t001w1         TYPE typ_t001w,
      wa_t001w          TYPE typ_t001w,
      itab_t001w_1      TYPE TABLE OF typ_t001w,
      itab_mara         TYPE TABLE OF typ_mara,
      itab_mvke         TYPE TABLE OF typ_mvke,
      itab_a004         TYPE TABLE OF a004,
      itab_konp         TYPE TABLE OF typ_konp,
      itab_tvm5t        TYPE TABLE OF tvm5t,
      itab_t023t        TYPE TABLE OF typ_t023t,
      itab_knumv        TYPE TABLE OF typ_knumv,
      itab_konv         TYPE SORTED TABLE OF typ_konv WITH UNIQUE KEY knumv
                                                              kposn
                                                              stunr
                                                              zaehk,
      itab_knvv         TYPE TABLE OF ty_knvv,
      wa_knvv           TYPE ty_knvv.
DATA: lw_newtable TYPE REF TO data,
      lw_newline  TYPE REF TO data.

DATA: g_type TYPE char4.

FIELD-SYMBOLS: <fs>,
               <fs_inv>    TYPE typ_inv,
               <fs_mard>   TYPE typ_mard,
               <fs_marc>   TYPE typ_marc,
               <fs_ysdir1> TYPE typ_ysdir1,
               <fs_t001w>  TYPE typ_t001w,
               <fs_mara>   TYPE typ_mara,
               <fs_a004>   TYPE a004,
               <fs_bsid>   TYPE typ_bsid,
               <fs_vbfa>   TYPE typ_vbfa1,
               <fs_konp>   TYPE typ_konp,
               <fs_konv>   TYPE typ_konv.

FIELD-SYMBOLS: <dyn_table>  TYPE STANDARD TABLE,
               <dyn_table1> TYPE STANDARD TABLE,
               <dyn_total>  TYPE STANDARD TABLE,
               <dyn_wa>,
               <dyn_wa1>.

DATA: wa_matnr TYPE typ_matnr,
      wa_t023t TYPE typ_t023t,
      l_vkorg  TYPE vkorg,
      l_vtweg  TYPE vtweg,
      wa_knumv TYPE typ_knumv.

DATA: no      TYPE dlyyr VALUE '2',
      no1     TYPE dlyyr,
      moff    LIKE sy-fdpos,
      msg(40) TYPE c.

DATA: g_repid      LIKE sy-repid VALUE sy-repid,
      it_fldcat    TYPE lvc_t_fcat,
      wa_it_fldcat TYPE lvc_s_fcat.

RANGES: r_dat FOR sy-datum,
        r_dat1 FOR sy-datum,
        r_dat2 FOR sy-datum,
        r_werks FOR t001w-werks.

DATA:
  it_knkk TYPE TABLE OF ty_knkk,
  wa_knkk TYPE ty_knkk,
  wa_cust TYPE ty_cust,
  it_cust TYPE TABLE OF ty_cust.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_audat FOR ysdir1-audat.
  SELECT-OPTIONS: s_werks1 FOR t001w-werks.
SELECTION-SCREEN END OF BLOCK b1.

l_date = s_audat-low.
l_date1 = s_audat-high.

l_year = l_date(4).
l_month = l_date+4(2).
l_day  = l_date+6(2).

CONCATENATE l_day '.' l_month '.' l_year INTO g_date.

l_year1 = l_date1(4).
l_month1 = l_date1+4(2).
l_day1  = l_date1+6(2).

CONCATENATE l_day1 '.' l_month1 '.' l_year1 INTO g_date1.

CONCATENATE 'Summary of Pending Orders from' g_date 'to' g_date1 INTO g_header SEPARATED BY space.


START-OF-SELECTION.


*  SELECT vbeln vbeln_1 posnr vbeln_2 vbeln_3 posnr_3 gbstk cmgst
*      spstg lfsta gbsta kunnr matnr netwr waerk kwmeng vrkme werks FROM
*      ysdir1 INTO TABLE itab_ysdir1 WHERE audat IN s_audat AND vbtyp = 'C' AND auart IN ('ZBDO','ZCDO') AND werks IN s_werks1.
  SELECT FROM  vbak AS a
      INNER  JOIN vbap AS b ON b~vbeln = a~vbeln
    FIELDS
     a~vbeln,
     b~vbeln,
     b~posnr,
     a~vbeln,
     b~vbeln,
     b~posnr,
     a~gbstk,
     a~cmgst,
     a~spstg,
     b~lfsta,
     b~gbsta,
     a~kunnr,
     b~matnr,
     b~netwr,
     b~waerk,
     b~kwmeng,
     b~vrkme,
     b~werks

    WHERE a~audat IN @s_audat
      AND a~vbtyp = 'C'
      AND a~auart IN ('ZBDO','ZCDO')
      AND b~werks IN @s_werks1
      AND ( a~gbstk = 'A' OR a~gbstk = 'B' )
      AND ( b~gbsta = 'A' OR b~gbsta = 'B' )

      INTO TABLE @itab_ysdir1 .

  IF sy-subrc = 0.
    DELETE itab_ysdir1 WHERE matnr IS INITIAL.
    SORT itab_ysdir1 BY vbeln.
  ENDIF.

  LOOP AT itab_ysdir1 ASSIGNING <fs_ysdir1>.
    <fs_ysdir1>-netvalue = <fs_ysdir1>-netwr / <fs_ysdir1>-kwmeng.
  ENDLOOP.

*  DELETE ITAB_YSDIR1 WHERE KWMENG IS INITIAL.

  IF itab_ysdir1 IS NOT INITIAL.
    SELECT kunnr klimk skfor FROM knkk INTO TABLE it_knkk
        FOR ALL ENTRIES IN itab_ysdir1 WHERE kunnr = itab_ysdir1-kunnr.
  ENDIF.

  LOOP AT itab_ysdir1 ASSIGNING <fs_ysdir1> WHERE lfsta = 'B'.
    wa_vbeln-vbeln = <fs_ysdir1>-vbeln.
    wa_vbeln-posnr = <fs_ysdir1>-posnr.
    APPEND wa_vbeln TO itab_vbeln.
    CLEAR wa_vbeln.
  ENDLOOP.

  IF itab_vbeln IS NOT INITIAL.
*    Get the partial delivered quantity
    SELECT vbelv posnv vbeln posnn vbtyp_n rfmng meins FROM vbfa
      INTO TABLE itab_vbfa FOR ALL ENTRIES IN itab_vbeln WHERE
      vbelv = itab_vbeln-vbeln AND posnv = itab_vbeln-posnr
      AND vbtyp_n = 'J'.
  ENDIF.

  DELETE itab_vbfa WHERE rfmng IS  INITIAL.

  LOOP AT itab_ysdir1 ASSIGNING <fs_ysdir1>.
    READ TABLE itab_vbfa INTO wa_vbfa WITH KEY vbelv = <fs_ysdir1>-vbeln
                                               posnv = <fs_ysdir1>-posnr
                                                     BINARY SEARCH.
    IF sy-subrc = 0.
      <fs_ysdir1>-kwmeng = <fs_ysdir1>-kwmeng - wa_vbfa-rfmng.
      MODIFY itab_ysdir1 FROM <fs_ysdir1> TRANSPORTING kwmeng.
    ENDIF.
  ENDLOOP.

  SORT itab_ysdir1 BY matnr.

  IF itab_ysdir1 IS NOT INITIAL.

    SELECT matnr werks labst FROM mard INTO TABLE it_mard
       FOR ALL ENTRIES IN itab_ysdir1 WHERE matnr  = itab_ysdir1-matnr
                                      AND  werks =   itab_ysdir1-werks.

    IF sy-subrc = 0.
      SORT it_mard BY matnr.
    ENDIF.


    SELECT matnr maktx FROM makt INTO TABLE it_makt FOR ALL ENTRIES IN
      itab_ysdir1 WHERE matnr = itab_ysdir1-matnr.
    IF sy-subrc = 0.
      SORT it_makt BY matnr.
    ENDIF.

    SELECT matnr vkorg vtweg mvgr5 FROM mvke INTO TABLE it_mvke FOR
      ALL ENTRIES IN itab_ysdir1 WHERE matnr = itab_ysdir1-matnr
                               AND   vkorg = '1000'
                               AND   vtweg = '10'.
    IF sy-subrc = 0.
      SORT it_mvke BY matnr.
    ENDIF.
    SELECT mvgr5 bezei FROM tvm5t INTO TABLE it_tvm5t
     FOR ALL ENTRIES IN it_mvke WHERE spras = sy-langu
                                AND mvgr5 = it_mvke-mvgr5.
    IF sy-subrc = 0.
      SORT it_tvm5t BY mvgr5.
    ENDIF.
  ENDIF.


  LOOP AT it_mard INTO wa_mard.

    wa_mard1-matnr = wa_mard-matnr.

    wa_mard1-werks = wa_mard-werks.

    wa_mard1-labst = wa_mard-labst.

    COLLECT wa_mard1 INTO it_mard1.
    CLEAR wa_mard1.

  ENDLOOP.

  SORT it_mard1 BY matnr.

  LOOP AT it_mard1 INTO wa_mard1.
    LOOP AT itab_ysdir1 ASSIGNING <fs_ysdir1> WHERE matnr = wa_mard1-matnr
                                            AND   werks = wa_mard1-werks .
      IF wa_mard1-labst > <fs_ysdir1>-kwmeng.

        wa_mard1-labst = wa_mard1-labst - <fs_ysdir1>-kwmeng.
        <fs_ysdir1>-netvalue = <fs_ysdir1>-netvalue * <fs_ysdir1>-kwmeng.
        APPEND <fs_ysdir1> TO itab_others.

      ELSE.

        <fs_ysdir1>-kwmeng = <fs_ysdir1>-kwmeng - wa_mard1-labst.
        <fs_ysdir1>-netvalue = <fs_ysdir1>-netvalue * <fs_ysdir1>-kwmeng.
        APPEND <fs_ysdir1> TO itab_po.

      ENDIF.
    ENDLOOP.
  ENDLOOP.

  LOOP AT itab_ysdir1 INTO wa_ysdir1.
    wa_werks-matnr = wa_ysdir1-matnr.
    wa_werks-werks = wa_ysdir1-werks.
    wa_werks-kwmeng = wa_ysdir1-kwmeng.
    wa_werks-netwr = wa_ysdir1-netvalue.
    COLLECT wa_werks INTO it_werks.
    CLEAR wa_werks.
  ENDLOOP.

  LOOP AT itab_po INTO wa_po.
    wa_po_werks-matnr = wa_po-matnr.
    wa_po_werks-werks = wa_po-werks.
    wa_po_werks-kwmeng = wa_po-kwmeng.
    wa_po_werks-netvalue = wa_po-netvalue.
    COLLECT wa_po_werks INTO it_po_werks.
    CLEAR wa_po_werks.
  ENDLOOP.

  LOOP AT itab_others INTO wa_others.
    wa_others_werks-matnr = wa_others-matnr.
    wa_others_werks-werks = wa_others-werks.
    wa_others_werks-kwmeng = wa_others-kwmeng.
    wa_others_werks-netvalue = wa_others-netvalue.
    COLLECT wa_others_werks INTO itab_others_werks.
    CLEAR wa_others_werks.
  ENDLOOP.

  LOOP AT it_werks INTO wa_werks.

    wa_final-matnr = wa_werks-matnr.

    READ TABLE it_po_werks INTO wa_po_werks WITH KEY matnr = wa_werks-matnr
                                               werks = wa_werks-werks.
    IF sy-subrc = 0.
      wa_final-pendqty = wa_po_werks-kwmeng.
      wa_final-value =   wa_po_werks-netvalue.
    ENDIF.

    READ TABLE itab_others_werks INTO wa_others_werks WITH KEY matnr = wa_werks-matnr
                                             werks = wa_werks-werks.
    IF sy-subrc = 0.
      wa_final-holdqty = wa_others_werks-kwmeng.
      wa_final-holdval = wa_others_werks-netvalue.
    ENDIF.

    COLLECT wa_final INTO it_final.
    CLEAR: wa_final.

  ENDLOOP.

  LOOP AT it_final INTO wa_final.
    READ TABLE it_makt INTO wa_makt WITH KEY matnr = wa_final-matnr.
    IF sy-subrc = 0.
      wa_final-maktx = wa_makt-maktx.
    ENDIF.

    READ TABLE it_mvke INTO wa_mvke WITH KEY matnr = wa_final-matnr.
    IF sy-subrc = 0.
      READ TABLE it_tvm5t INTO wa_tvm5t WITH KEY mvgr5 = wa_mvke-mvgr5.
      IF sy-subrc = 0.
        wa_final-salpack = wa_tvm5t-bezei.
      ENDIF.
    ENDIF.

    MODIFY it_final FROM wa_final TRANSPORTING  maktx salpack.
    CLEAR wa_final.
  ENDLOOP.

  LOOP AT it_final INTO wa_final.
    SELECT SINGLE * FROM zpenexclude WHERE matnr EQ wa_final-matnr.
    IF sy-subrc EQ 0.
      wa_final-pendqty = 0.
      wa_final-value = 0.
    ENDIF.

    PACK wa_final-matnr TO wa_final-matnr.
    CONDENSE wa_final-matnr.
    wa_output-matnr = wa_final-matnr.
    wa_output-maktx = wa_final-maktx.
    wa_output-bezei = wa_final-salpack.

    wa_output-pendqty = wa_final-pendqty.
    PACK wa_output-pendqty TO wa_output-pendqty.
    CONDENSE wa_output-pendqty.
    wa_output-value = wa_final-value.
    PACK wa_output-value TO wa_output-value.
    CONDENSE wa_output-value.
    wa_output-holdqty = wa_final-holdqty.
    PACK wa_output-holdqty TO wa_output-holdqty.
    CONDENSE wa_output-holdqty.
    wa_output-holdval = wa_final-holdval.
    PACK wa_output-holdval TO wa_output-holdval.
    CONDENSE wa_output-holdval.
    APPEND wa_output TO it_output.
    CLEAR wa_output.
  ENDLOOP.

  LOOP AT it_output INTO wa_output.
    g_pendqty = g_pendqty + wa_output-pendqty.
    g_value  = g_value + wa_output-value.
    g_holdqty = g_holdqty + wa_output-holdqty.
    g_holdval = g_holdval + wa_output-holdval.
  ENDLOOP.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'YR_SD_PENDINGORDER_SAT'
    IMPORTING
      fm_name            = fm_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CALL FUNCTION fm_name
    EXPORTING
      g_header         = g_header
      g_pendqty        = g_pendqty
      g_value          = g_value
      g_holdqty        = g_holdqty
      g_holdval        = g_holdval
    TABLES
      it_output        = it_output
    EXCEPTIONS
      formatting_error = 1
      internal_error   = 2
      send_error       = 3
      user_canceled    = 4
      OTHERS           = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
