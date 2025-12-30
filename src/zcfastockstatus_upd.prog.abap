*&---------------------------------------------------------------------*
*& Report  ZCFASTOCKSTATUS_UPD
*&---------------------------------------------------------------------*
*&DESCRIPTION       : CFA Stock status for shortfall/excess stock
*CREATED BY         : Shraddha Pradhan
*CREATED ON         : 18/08/2022
*Request No         : BCDK931543
*&---------------------------------------------------------------------*
*&Modification History
*&---------------------------
*&Changed by/date       : 08/09/2022
*&DESCRIPTION           : Add Excel download with formatting like color/bold etc.
*&                        add chkbox parameters for MAX value calculation
*&Request No.          : BCDK931623
*&---------------------------------------------------------------------*
*&Changed by/date       : 16/09/2022
*&DESCRIPTION           : logic change for MAX and high/low calculation.
*&Request No.          : BCDK931675 , BCDK931677
*&---------------------------------------------------------------------*

REPORT zcfastockstatus_upd.

INCLUDE: zr_ir13c_ole2_utils.
TABLES: t001w,
        mara,
        mvke,
        tvm5t,
        konp.


CONSTANTS :gc_true         TYPE c VALUE 'X',
           gc_email_sender TYPE adr6-smtp_addr VALUE 'ir13c@bluecrosslabs.com'.

FIELD-SYMBOLS: <dyn_tab> TYPE STANDARD TABLE,
               <dyn_wa>.

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

TYPES: BEGIN OF inv1,
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
       END OF inv1.



TYPES: BEGIN OF ty_mard,
         matnr TYPE matnr,
         werks TYPE werks,
         labst TYPE mard-labst,
       END OF ty_mard.



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

TYPES: BEGIN OF typ_tvm4t,
         spras TYPE spras,
         mvgr4 TYPE mvgr4,
         maktx TYPE tvm4t-bezei,
       END OF typ_tvm4t.

TYPES: BEGIN OF ty_knvv,
         kunnr TYPE knvv-kunnr,
         kdgrp TYPE knvv-kdgrp,
       END OF ty_knvv.

TYPES: BEGIN OF typ_t001w,
         werks TYPE werks_d,
         name1 TYPE name1,
         doc   TYPE c,
       END OF typ_t001w.

TYPES: BEGIN OF typ_mara,
         matkl  TYPE matkl,
         matnr  TYPE matnr,
         spart  TYPE spart,
         mvgr4  TYPE mvgr4,
         mvgr41 TYPE mvgr4,
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
         kschl TYPE prcd_elements-kschl,
         kwert TYPE prcd_elements-kwert,
       END OF typ_konv.

TYPES: BEGIN OF typ_konv1,
         knumv TYPE knumv,
         kposn TYPE kposn,
         kschl TYPE prcd_elements-kschl,
         kawrt TYPE prcd_elements-kawrt,
         kwert TYPE prcd_elements-kwert,
       END OF typ_konv1.

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

TYPES BEGIN OF ty_fdata_alv.
        INCLUDE STRUCTURE zcfastockstatus.
TYPES : cell      TYPE slis_t_specialcol_alv.  "for cell color
TYPES END OF ty_fdata_alv.

DATA: itab_inv      TYPE TABLE OF typ_inv,
      wa_inv        TYPE typ_inv,
      itab_inv1     TYPE TABLE OF inv1,
      itab_inv2     TYPE TABLE OF typ_inv,
      wa_inv1       TYPE inv1,
      wa_inv2       TYPE typ_inv,
      itab_ysdir1   TYPE TABLE OF typ_ysdir1,
      wa_ysdir1     TYPE typ_ysdir1,
      itab_ysdir2   TYPE TABLE OF typ_inv,
      wa_ysdir2     TYPE typ_inv,
      itab_credit   TYPE TABLE OF typ_ysdir1,
      wa_credit     TYPE typ_ysdir1,
      itab_crelimit TYPE TABLE OF typ_ysdir1,
      wa_crelimit   TYPE typ_ysdir1,

      it_mard1      TYPE TABLE OF ty_mard,
      wa_mard1      TYPE ty_mard,
      it_mard2      TYPE TABLE OF ty_mard,
      wa_mard2      TYPE ty_mard,
      itab_overdue  TYPE TABLE OF typ_ysdir1,
      wa_overdue    TYPE typ_ysdir1,
      itab_po       TYPE TABLE OF typ_ysdir1,
      wa_po         TYPE typ_ysdir1,
      itab_others   TYPE TABLE OF typ_ysdir1,
      wa_others     TYPE typ_ysdir1,
      itab_vbeln    TYPE TABLE OF typ_vbeln,
      wa_vbeln      TYPE typ_vbeln,
      itab_kunnr    TYPE TABLE OF typ_kunnr,
      wa_kunnr      TYPE typ_kunnr,
      itab_matnr    TYPE TABLE OF typ_matnr,
      itab_vbfa     TYPE TABLE OF ty_vbfa,
      wa_vbfa       TYPE ty_vbfa,
      itab_bsid     TYPE TABLE OF typ_bsid,
      itab_vbfa1    TYPE TABLE OF typ_vbfa1,
      wa_vbfa1      TYPE typ_vbfa1,
      itab_makt     TYPE TABLE OF typ_makt,
      wa_makt       TYPE typ_makt,
      itab_tvm4t    TYPE TABLE OF typ_tvm4t,
      wa_tvm4t      TYPE typ_tvm4t,
      itab_t001w    TYPE TABLE OF zplant,
      wa_t001w      TYPE zplant,

      itab_mara     TYPE TABLE OF typ_mara,
      wa_mara       TYPE typ_mara,
      itab_mvke     TYPE TABLE OF typ_mvke,
      itab_a004     TYPE TABLE OF a004,
      itab_konp     TYPE TABLE OF typ_konp,
      itab_tvm5t    TYPE TABLE OF tvm5t,

      itab_t023t    TYPE TABLE OF typ_t023t,
      itab_knumv    TYPE TABLE OF typ_knumv,
      itab_knumv1   TYPE TABLE OF typ_knumv,

      itab_knvv     TYPE TABLE OF ty_knvv,
      wa_knvv       TYPE ty_knvv.

DATA :gv_bin_filesize TYPE so_obj_len,
      gv_bin_xstr     TYPE xstring,
      gv_text         TYPE string,
      gv_sent_to_all  TYPE os_boolean,
      gv_subject      TYPE so_obj_des.

DATA : gt_fdata       TYPE TABLE OF zcfastockstatus,
       gw_fdata       TYPE zcfastockstatus,
       gt_fdata1      TYPE TABLE OF zcfastockstatus,
       gt_fdata_alv   TYPE TABLE OF ty_fdata_alv,
       gw_fdata_alv   TYPE  ty_fdata_alv,
       gt_maktx       TYPE TABLE OF zcfastockstatus,

       gw_output_opts TYPE ssfcompop,
       gw_contrl_para TYPE ssfctrlop,
       gt_otf_data    TYPE ssfcrescl,
       gt_otf         TYPE STANDARD TABLE OF itcoo,
       gt_tline       TYPE STANDARD TABLE OF tline,
       gt_pdf_data    TYPE solix_tab,
       gt_text        TYPE bcsy_text.


"Object References
DATA: lo_bcs     TYPE REF TO cl_bcs,
      lo_doc_bcs TYPE REF TO cl_document_bcs,
      lo_recep   TYPE REF TO if_recipient_bcs,
      lo_sender  TYPE REF TO if_sender_bcs,  "cl_sapuser_bcs,
      lo_cx_bcx  TYPE REF TO cx_bcs.

DATA : gt_fieldcat1 TYPE slis_t_fieldcat_alv,
       gw_fieldcat1 TYPE slis_fieldcat_alv,
       gw_layout    TYPE slis_layout_alv,
       gw_cell      LIKE LINE OF gw_fdata_alv-cell.

DATA : stock  TYPE mard-labst,
       stock1 TYPE mard-labst,
       qty1   TYPE zsales_tab1-c_qty.


TYPES : BEGIN OF typ_vbrp,
          vbeln TYPE vbrp-vbeln,
          posnr TYPE vbrp-posnr,
          fkimg TYPE vbrp-fkimg,

          matnr TYPE vbrp-matnr,
          arktx TYPE vbrp-arktx,
          charg TYPE vbrp-charg,
          pstyv TYPE vbrp-pstyv,
          werks TYPE vbrp-werks,

          lgort TYPE vbrp-lgort,
          kzwi2 TYPE vbrp-kzwi2,

          mwsbp TYPE vbrp-mwsbp,
          vrkme TYPE vbrp-vrkme,
          netwr TYPE vbrp-netwr,

        END OF typ_vbrp.


FIELD-SYMBOLS: <fs>,
               <fs_mvgr41> TYPE any,
               <fs_maktx>  TYPE any,
               <fs_inv>    TYPE typ_inv,
               <fs_inv1>   TYPE typ_inv,

               <fs_ysdir1> TYPE typ_ysdir1,

               <fs_mara>   TYPE typ_mara,
               <fs_a004>   TYPE a004,
               <fs_bsid>   TYPE typ_bsid,
               <fs_vbfa>   TYPE typ_vbfa1,
               <fs_konp>   TYPE typ_konp,
               <fs_konv>   TYPE typ_konv,
               <fs_konv1>  TYPE typ_konv.

DATA: wa_matnr  TYPE typ_matnr,
      wa_mvke   TYPE typ_mvke,
      wa_tvm5t  TYPE tvm5t,
      wa_t023t  TYPE typ_t023t,
      l_vkorg   TYPE vkorg,
      l_vtweg   TYPE vtweg,
      g_value   TYPE dmbtr,
      wa_knumv  TYPE typ_knumv,
      wa_knumv1 TYPE typ_knumv.
DATA : wa_maktx  TYPE makt-maktx,
       wa_maktx1 TYPE makt-maktx.

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
        r_dat3 FOR sy-datum.


DATA : it_marc  TYPE TABLE OF marc,
       wa_marc  TYPE marc,
       it_mard  TYPE TABLE OF mard,
       wa_mard  TYPE mard,
       it_vbrk  TYPE TABLE OF vbrk,
       wa_vbrk  TYPE vbrk,
       it_vbrp  TYPE TABLE OF vbrp,
       wa_vbrp  TYPE vbrp,
       it_konv  TYPE TABLE OF typ_konv,
       wa_konv  TYPE typ_konv,
       it_vbrk1 TYPE TABLE OF vbrk,
       wa_vbrk1 TYPE vbrk,
       it_vbrp1 TYPE TABLE OF vbrp,
       wa_vbrp1 TYPE vbrp,
       it_konv1 TYPE TABLE OF typ_konv1,
       wa_konv1 TYPE typ_konv1,
       it_t001w TYPE TABLE OF t001w.

DATA : pts       TYPE p DECIMALS 2,
       zped_rate TYPE p DECIMALS 2,
       zgrp_rate TYPE p DECIMALS 2,
       ed_rate   TYPE p DECIMALS 2.



TYPES : BEGIN OF itas1,
          matnr     TYPE mard-matnr,
          werks     TYPE mard-werks,
          cqty      TYPE p,
          pts       TYPE p,
          nqty      TYPE p,
          npts      TYPE p,
          ed_rate   TYPE prcd_elements-kwert,
          zped_rate TYPE prcd_elements-kwert,
        END OF itas1.


TYPES : BEGIN OF mat1,
          matnr TYPE mara-matnr,
          mvgr4 TYPE mvke-mvgr4,
        END OF mat1.

DATA : it_tas1  TYPE TABLE OF typ_inv,
       wa_tas1  TYPE typ_inv,
       it_tas2  TYPE TABLE OF typ_inv,
       wa_tas2  TYPE typ_inv,
       it_tran1 TYPE TABLE OF typ_inv,
       wa_tran1 TYPE typ_inv,
       it_stk1  TYPE TABLE OF typ_inv,
       wa_stk1  TYPE typ_inv,

       it_mat1  TYPE TABLE OF mat1,
       wa_mat1  TYPE mat1,
       it_a602  TYPE TABLE OF a602,
       wa_a602  TYPE a602.


DATA : date1   TYPE sy-datum,
       lmdat1  TYPE sy-datum,
       lmdat2  TYPE sy-datum,
       llmdat1 TYPE sy-datum,
       llmdat2 TYPE sy-datum,
       lydate1 TYPE sy-datum,
       lydate2 TYPE sy-datum.

DATA : gv_valmax TYPE p.


DATA : t1 TYPE i,
       t2 TYPE i,
       t3 TYPE i,
       t4 TYPE i.

DATA : it_zsales_tab1 TYPE TABLE OF zsales_tab1,
       wa_zsales_tab1 TYPE zsales_tab1.

** for excel format
DATA : gt_zcfastkstat TYPE TABLE OF zcfastockstatus,
       gw_zcfastkstat TYPE zcfastockstatus,
       gt_matnr       TYPE TABLE OF zcfastockstatus,
       gw_matnr       TYPE zcfastockstatus,
       gt_plants      TYPE TABLE OF zplant,
       gw_plants      TYPE zplant.

DATA: dyn_tab  TYPE REF TO data,
      dyn_line TYPE REF TO data.

DATA: lt_lfldcat TYPE lvc_t_fcat,
      lw_lfldcat TYPE lvc_s_fcat.

DATA : gv_sum  TYPE p,
       gv_rowi TYPE i,
       gv_rowe TYPE i,
       gv_coli TYPE i,
       gv_cole TYPE i.



SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.

PARAMETERS : r1_alv  RADIOBUTTON GROUP r1 USER-COMMAND u1.          " for ALV disp
SELECTION-SCREEN SKIP.
SELECTION-SCREEN SKIP.
SELECTION-SCREEN COMMENT 1(50) text-003.
PARAMETERS : r3_exl RADIOBUTTON GROUP r1,                         " for EXCEL download
             p_path TYPE string.
SELECTION-SCREEN SKIP.
PARAMETERS : r2_pdf  RADIOBUTTON GROUP r1,                        " for PDF in email
             p_email TYPE ad_smtpadr.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.
PARAMETERS : p_sl AS CHECKBOX TYPE c USER-COMMAND u1 DEFAULT 'X' .
SELECTION-SCREEN SKIP.
PARAMETERS :  p_lms AS CHECKBOX TYPE c DEFAULT 'X' .
SELECTION-SCREEN SKIP.
PARAMETERS : p_llm AS CHECKBOX TYPE c DEFAULT 'X' .
SELECTION-SCREEN SKIP.
PARAMETERS :  p_lys AS CHECKBOX TYPE c DEFAULT 'X' .
SELECTION-SCREEN END OF BLOCK b2.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_path.

  CALL METHOD cl_gui_frontend_services=>directory_browse
    CHANGING
      selected_folder = p_path.

AT SELECTION-SCREEN OUTPUT.
  IF r1_alv = 'X'.
    LOOP AT SCREEN.
      IF screen-name = 'P_EMAIL' OR screen-name = 'P_PATH'.
        screen-input = 0.
      ELSE.
        screen-input = 1.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.
  ENDIF.

  IF r2_pdf = 'X'.
    LOOP AT SCREEN.
      IF screen-name = 'P_EMAIL'.
        screen-input = 1.
      ELSEIF screen-name = 'P_PATH'.
        screen-input = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.
  ENDIF.

  IF r3_exl = 'X'.
    LOOP AT SCREEN.
      IF screen-name = 'P_PATH'.
        screen-input = 1.
      ELSEIF screen-name = 'P_EMAIL'.
        screen-input = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.
  ENDIF.

  IF p_sl <> 'X' AND p_lms <> 'X' AND p_llm <> 'X' AND p_lys <> 'X'.
    MESSAGE 'MAX value calculated from Sale(SL) as no checkbox is selected)' TYPE 'I'.
  ENDIF.

START-OF-SELECTION.

   perform select.
   perform fill.

 if r1_alv = 'X'.
    perform set_alv_color.    "set color for alv column
    if gt_fdata_alv[] is not initial.
      perform alv.          " display ALV
    endif.
  elseif r2_pdf = 'X'.
    if p_email is not initial.
    perform pdf_layout.     " get PDF output
    if gt_otf[] is not initial.
      perform send_email.         "send email
    endif.
    ELSE.
       message 'Email address should not be blank.' type 'S' .
    endif.
  elseif r3_exl = 'X'.        "download XLS file with color formatting
    if p_path is not initial.
    perform get_excel.
    ELSE.
       message 'File path/location should not be blank.' type 'S' .
    endif.
  endif.

*&---------------------------------------------------------------------*
*&      Form  SELECT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM select .


*** get plant details.
  IF r3_exl = 'X'.
    CLEAR :gt_plants[].
    SELECT * FROM zplant INTO TABLE gt_plants.
    IF sy-subrc = 0.
      SORT gt_plants BY zseq_no.
      CLEAR itab_t001w[].
      itab_t001w[] = gt_plants[].
    ENDIF.
  ELSE.
    CLEAR itab_t001w[].
    SELECT * FROM zplant INTO TABLE itab_t001w WHERE ztype = 'C'.
  ENDIF.

**************************************
  date1 = sy-datum.
  date1+6(2) = '01'.
  lmdat2 = date1 - 1.
  lmdat1 = lmdat2.
  lmdat1+6(2) = '01'.
  llmdat2 = lmdat1 - 1.
  llmdat1 = llmdat2.
  llmdat1+6(2) = '01'.
  lydate1 = date1.
  lydate1+0(4) = lydate1+0(4) - 1.

  CALL FUNCTION 'HR_JP_MONTH_BEGIN_END_DATE'
    EXPORTING
      iv_date           = lydate1
    IMPORTING
      ev_month_end_date = lydate2.

  CLEAR it_mard[].
  SELECT * FROM mard INTO TABLE it_mard
    FOR ALL ENTRIES IN itab_t001w
    WHERE werks = itab_t001w-werks
    AND lgort NE 'CSM'.

  CLEAR itab_mara[].
  SELECT matkl matnr spart FROM mara INTO TABLE itab_mara
    WHERE  mtart IN ('ZFRT','ZHWA','ZESC')
    AND lvorm NE 'X'.

  SORT itab_mara BY matkl.

  CLEAR wa_mara.
  LOOP AT itab_mara INTO wa_mara.
    SELECT SINGLE * FROM mara WHERE matnr EQ wa_mara-matnr AND mtart EQ 'ZESC'.
    IF sy-subrc EQ 0.
      IF wa_mara-matnr+10(3) NE '425'.
        DELETE itab_mara WHERE matnr EQ wa_mara-matnr.
      ENDIF.
    ENDIF.
  ENDLOOP.

  CLEAR wa_mara.
  LOOP AT itab_mara INTO wa_mara.
    SELECT SINGLE * FROM mvke WHERE matnr EQ wa_mara-matnr AND vkorg EQ '1000' AND vtweg EQ '10'.
    IF sy-subrc EQ 0.
      wa_mara-mvgr4 = mvke-mvgr4.
      MODIFY itab_mara FROM wa_mara TRANSPORTING mvgr4.
    ENDIF.
  ENDLOOP.

  IF itab_mara IS NOT INITIAL.

    SORT itab_mara BY matnr.
    CLEAR itab_makt[].
    SELECT matnr spras maktx FROM makt INTO TABLE itab_makt
      FOR ALL ENTRIES IN itab_mara
      WHERE matnr EQ itab_mara-matnr AND spras EQ 'EN'.

    SORT itab_mara BY mvgr4.
    CLEAR itab_tvm4t[].
    SELECT spras mvgr4 bezei FROM tvm4t INTO TABLE itab_tvm4t
      FOR ALL ENTRIES IN itab_mara
      WHERE mvgr4 EQ itab_mara-mvgr4
      AND spras EQ 'EN'.

    SORT itab_mara BY matnr.
    CLEAR itab_mvke[].
    SELECT matnr vkorg vtweg mvgr5 FROM mvke INTO TABLE itab_mvke
      FOR ALL ENTRIES IN itab_mara
      WHERE matnr = itab_mara-matnr
      AND vkorg = '1000'
      AND vtweg = '10'.

    CLEAR itab_t023t[].
    SELECT spras matkl wgbez FROM t023t INTO TABLE itab_t023t
      FOR ALL ENTRIES IN itab_mara
      WHERE spras = sy-langu
      AND matkl = itab_mara-matkl.

    CLEAR itab_a004[].
    SELECT * FROM a004 INTO TABLE itab_a004
      FOR ALL ENTRIES IN itab_mara
      WHERE kappl = 'V' AND kschl = 'ZPTS' AND vkorg = '1000' AND
      vtweg IN ('10', '80') AND matnr = itab_mara-matnr AND datbi >= sy-datum
      AND datab =< sy-datum.

    SORT itab_a004 BY matnr vtweg.
    IF itab_a004 IS NOT INITIAL.
      SELECT knumh kopos kbetr konwa FROM konp INTO TABLE itab_konp
        FOR ALL ENTRIES IN itab_a004
        WHERE knumh = itab_a004-knumh
        AND kappl = 'V'
        AND kschl = 'ZPTS'.
      SORT itab_konp BY knumh.
    ENDIF.
  ENDIF.

  CLEAR itab_tvm5t[].
  SELECT * FROM tvm5t INTO TABLE itab_tvm5t WHERE spras = sy-langu.

********************* pending sales order****************
  TYPES: BEGIN OF ty_knkk,
           kunnr TYPE kunnr,
           klimk TYPE knkk-klimk,
           skfor TYPE knkk-skfor,
         END OF ty_knkk.

  TYPES: BEGIN OF ty_cust,
           kunnr TYPE kunnr,
         END OF ty_cust.

  DATA: it_knkk TYPE TABLE OF ty_knkk,
        wa_knkk TYPE ty_knkk,
        wa_cust TYPE ty_cust,
        it_cust TYPE TABLE OF ty_cust.

  CLEAR itab_ysdir1[].
  SELECT vbeln vbeln_1 posnr vbeln_2 vbeln_3 posnr_3 gbstk cmgst spstg lfsta gbsta kunnr matnr netwr waerk kwmeng vrkme werks FROM
    ysdir1 INTO TABLE itab_ysdir1 WHERE audat GE sy-datum AND vbtyp = 'C' AND auart IN ('ZBDO','ZCDO') .

  IF sy-subrc = 0.
    SORT itab_ysdir1 BY vbeln.
  ENDIF.

  LOOP AT itab_ysdir1 ASSIGNING <fs_ysdir1>.
    <fs_ysdir1>-netvalue = <fs_ysdir1>-netwr / <fs_ysdir1>-kwmeng.
  ENDLOOP.


  IF itab_ysdir1 IS NOT INITIAL.
    CLEAR it_knkk[].
   SELECT PARTNER CREDIT_LIMIT FROM UKMBP_CMS_SGM INTO TABLE it_knkk " FROM UKMBP_CMS_SGM INTO TABLE it_knkk
      FOR ALL ENTRIES IN itab_ysdir1
      WHERE PARTNER = itab_ysdir1-kunnr.
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

  DELETE itab_vbfa WHERE rfmng IS INITIAL.

  LOOP AT itab_ysdir1 ASSIGNING <fs_ysdir1>.
    READ TABLE itab_vbfa INTO wa_vbfa WITH KEY vbelv = <fs_ysdir1>-vbeln  posnv = <fs_ysdir1>-posnr BINARY SEARCH.
    IF sy-subrc = 0.
      <fs_ysdir1>-kwmeng = <fs_ysdir1>-kwmeng - wa_vbfa-rfmng.
      MODIFY itab_ysdir1 FROM <fs_ysdir1> TRANSPORTING kwmeng.
    ENDIF.
  ENDLOOP.

  SORT itab_ysdir1 BY matnr.

  IF itab_ysdir1 IS NOT INITIAL.
    CLEAR it_mard2[].
    SELECT matnr werks labst FROM mard INTO TABLE it_mard2
      FOR ALL ENTRIES IN itab_ysdir1
      WHERE matnr  = itab_ysdir1-matnr
      AND  werks =   itab_ysdir1-werks.

    IF sy-subrc = 0.
      SORT it_mard2 BY matnr.
    ENDIF.

  ENDIF.

  LOOP AT it_mard2 INTO wa_mard2.

    wa_mard1-matnr = wa_mard2-matnr.

    wa_mard1-werks = wa_mard2-werks.

    wa_mard1-labst = wa_mard2-labst.

    COLLECT wa_mard1 INTO it_mard1.
    CLEAR wa_mard1.

  ENDLOOP.

  SORT it_mard1 BY matnr.

  LOOP AT it_mard1 INTO wa_mard1.
    LOOP AT itab_ysdir1 ASSIGNING <fs_ysdir1> WHERE matnr = wa_mard1-matnr
                                            AND   werks = wa_mard1-werks .
      IF wa_mard1-labst > <fs_ysdir1>-kwmeng.

        wa_mard1-labst = wa_mard1-labst - <fs_ysdir1>-kwmeng.

      ELSE.

        <fs_ysdir1>-kwmeng = <fs_ysdir1>-kwmeng - wa_mard1-labst.
        <fs_ysdir1>-netvalue = <fs_ysdir1>-netvalue * <fs_ysdir1>-kwmeng.
        APPEND <fs_ysdir1> TO itab_po.
        DELETE itab_ysdir1.
      ENDIF.
    ENDLOOP.
  ENDLOOP.

*  *  Get the customer open items
  SELECT bukrs kunnr umsks umskz augdt augbl zuonr gjahr belnr
    buzei budat blart bschl shkzg gsber dmbtr zfbdt zbd1t vbeln
    FROM bsid INTO TABLE itab_bsid WHERE bukrs = '1000'
                                   AND   blart NE 'DZ'
                                   AND   shkzg = 'S'.

  SORT itab_bsid BY kunnr.

  DATA: g_duedate TYPE sy-datum.

  IF itab_bsid IS NOT INITIAL.

    SELECT kunnr kdgrp FROM knvv INTO TABLE itab_knvv
      FOR ALL ENTRIES IN itab_bsid WHERE kunnr = itab_bsid-kunnr
                                   AND  vkorg = '1000'
                                   AND  vtweg = '10'
                                   AND  spart = '50'.
    IF sy-subrc = 0.
      SORT itab_knvv BY kunnr.
    ENDIF.
  ENDIF.

  LOOP AT itab_bsid ASSIGNING <fs_bsid>.
*    Calculation of Due Date
    no = <fs_bsid>-zbd1t.
    READ TABLE itab_knvv INTO wa_knvv WITH KEY kunnr = <fs_bsid>-kunnr.
    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING
        date      = <fs_bsid>-zfbdt
        days      = no
        months    = no1
        years     = no1
      IMPORTING
        calc_date = <fs_bsid>-zfbdt. "Due date

    IF wa_knvv-kdgrp = '01'.
      g_duedate = <fs_bsid>-zfbdt + 3.
    ELSE.
      g_duedate = <fs_bsid>-zfbdt + 10.
    ENDIF.
    IF g_duedate < sy-datum.
      wa_kunnr-kunnr = <fs_bsid>-kunnr.
      APPEND wa_kunnr TO itab_kunnr.
    ENDIF.
  ENDLOOP.
  SORT itab_kunnr BY kunnr.
  DELETE ADJACENT DUPLICATES FROM itab_kunnr COMPARING kunnr.

  IF itab_kunnr IS NOT INITIAL.
    LOOP AT itab_ysdir1 ASSIGNING <fs_ysdir1>.
      READ TABLE itab_kunnr INTO wa_kunnr WITH KEY
      kunnr = <fs_ysdir1>-kunnr BINARY SEARCH.
      IF sy-subrc = 0.
        <fs_ysdir1>-netvalue = <fs_ysdir1>-netvalue * <fs_ysdir1>-kwmeng.
        MOVE-CORRESPONDING <fs_ysdir1> TO wa_overdue.
        wa_overdue-netwr = <fs_ysdir1>-netvalue.
        APPEND wa_overdue TO itab_overdue.
        CLEAR wa_overdue.
        DELETE itab_ysdir1.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF itab_ysdir1 IS NOT INITIAL.
    SELECT PARTNER CREDIT_LIMIT  FROM UKMBP_CMS_SGM INTO TABLE it_knkk       " kunnr replace by partner " commented skfor
      FOR ALL ENTRIES IN itab_ysdir1 WHERE PARTNER = itab_ysdir1-kunnr.
  ENDIF.

  LOOP AT it_knkk INTO wa_knkk.
    IF wa_knkk-skfor > wa_knkk-klimk.
      wa_cust-kunnr = wa_knkk-kunnr.
      APPEND wa_cust TO it_cust.
    ENDIF.
    CLEAR: wa_cust,wa_knkk.
  ENDLOOP.

  IF it_cust IS NOT INITIAL.
    SELECT vbeln vbeln_1 posnr vbeln_2 vbeln_3 posnr_3 gbstk cmgst
    spstg lfsta gbsta kunnr matnr netwr waerk kwmeng vrkme werks FROM
    ysdir1 INTO TABLE itab_credit FOR ALL ENTRIES IN it_cust WHERE kunnr = it_cust-kunnr.
    IF sy-subrc = 0.
      SORT itab_credit BY vbeln.
    ENDIF.
  ENDIF.

  LOOP AT itab_ysdir1 ASSIGNING <fs_ysdir1>.
    READ TABLE itab_credit INTO wa_credit WITH KEY vbeln = <fs_ysdir1>-vbeln BINARY SEARCH.
    IF sy-subrc = 0.
      <fs_ysdir1>-netvalue = <fs_ysdir1>-netvalue * <fs_ysdir1>-kwmeng.
      MOVE-CORRESPONDING <fs_ysdir1> TO wa_crelimit.
      APPEND wa_crelimit TO itab_crelimit.
      CLEAR wa_crelimit.
      DELETE itab_ysdir1.
    ENDIF.
  ENDLOOP.

  LOOP AT itab_ysdir1 ASSIGNING <fs_ysdir1>.

    <fs_ysdir1>-netvalue = <fs_ysdir1>-netvalue * <fs_ysdir1>-kwmeng.
    MOVE-CORRESPONDING <fs_ysdir1> TO wa_others.
    APPEND wa_others TO itab_others.
    CLEAR wa_others.
    DELETE itab_ysdir1.
  ENDLOOP.

  LOOP AT itab_crelimit INTO wa_crelimit.
    wa_ysdir1 = wa_crelimit.
    APPEND wa_ysdir1 TO itab_ysdir1.
    CLEAR:wa_ysdir1, wa_crelimit.
  ENDLOOP.

  LOOP AT itab_overdue INTO wa_overdue.
    wa_ysdir1 = wa_overdue.
    APPEND wa_ysdir1 TO itab_ysdir1.
    CLEAR: wa_ysdir1, wa_overdue.
  ENDLOOP.

  LOOP AT itab_po INTO wa_po.
    wa_ysdir1 = wa_po.
    APPEND wa_ysdir1 TO itab_ysdir1.
    CLEAR: wa_ysdir1, wa_po.
  ENDLOOP.

  LOOP AT itab_others INTO wa_others.
    wa_ysdir1 = wa_others.
    APPEND wa_ysdir1 TO itab_ysdir1.
    CLEAR: wa_ysdir1, wa_others.
  ENDLOOP.

  LOOP AT itab_ysdir1 INTO wa_ysdir1.

    wa_ysdir2-matnr_i = wa_ysdir1-matnr.
    wa_ysdir2-werks_i = wa_ysdir1-werks.
    wa_ysdir2-fkimg_i = wa_ysdir1-kwmeng.
    wa_ysdir2-netwr_i = wa_ysdir1-netvalue.
    COLLECT wa_ysdir2 INTO itab_ysdir2.
    CLEAR wa_ysdir2.
  ENDLOOP.


  SORT itab_mara BY matkl matnr.

*********************LAST YEAR CURRENT MONTH***********************
  CLEAR : it_zsales_tab1,wa_zsales_tab1.

  SELECT * FROM zsales_tab1 INTO TABLE it_zsales_tab1 WHERE datab GE lmdat1 AND datbi LE lmdat2.
  LOOP AT it_zsales_tab1 INTO wa_zsales_tab1.
    CLEAR : qty1.

    wa_inv-matnr_i = wa_zsales_tab1-matnr.
    wa_inv-werks_i = wa_zsales_tab1-werks.
    wa_inv-netwr_i = wa_zsales_tab1-net + wa_zsales_tab1-ed.
    wa_inv-fkimg_i = wa_zsales_tab1-c_qty + wa_zsales_tab1-f_qty.
    qty1 = wa_zsales_tab1-nep_c_qty + wa_zsales_tab1-nep_f_qty.
    IF qty1 GT 0.
      wa_inv-matnr_i+10(3) = '425'.
    ENDIF.
    wa_mat1-matnr = wa_inv-matnr_i.
    COLLECT wa_mat1 INTO it_mat1.
    CLEAR wa_mat1.
    COLLECT wa_inv INTO itab_inv.
    CLEAR wa_inv.

  ENDLOOP.
*********************LAST MONTH***********************
  CLEAR : it_zsales_tab1,wa_zsales_tab1.

  SELECT * FROM zsales_tab1 INTO TABLE it_zsales_tab1 WHERE datab GE lydate1 AND datbi LE lydate2.
  LOOP AT it_zsales_tab1 INTO wa_zsales_tab1.
    CLEAR : qty1.
    wa_inv2-matnr_i = wa_zsales_tab1-matnr.
    wa_inv2-werks_i = wa_zsales_tab1-werks.
    wa_inv2-netwr_i = wa_zsales_tab1-net + wa_zsales_tab1-ed.
    wa_inv2-fkimg_i = wa_zsales_tab1-c_qty + wa_zsales_tab1-f_qty.
    qty1 = wa_zsales_tab1-nep_c_qty + wa_zsales_tab1-nep_f_qty.
    IF qty1 GT 0.
      wa_inv2-matnr_i+10(3) = '425'.
    ENDIF.
    wa_mat1-matnr = wa_inv2-matnr_i.
    COLLECT wa_mat1 INTO it_mat1.
    CLEAR wa_mat1.
    COLLECT wa_inv2 INTO itab_inv2.
    CLEAR wa_inv2.

  ENDLOOP.

*********************LAST TO LAST  MONTH***********************
  CLEAR : it_zsales_tab1,wa_zsales_tab1.

  SELECT * FROM zsales_tab1 INTO TABLE it_zsales_tab1 WHERE datab GE llmdat1 AND datbi LE llmdat2.
  LOOP AT it_zsales_tab1 INTO wa_zsales_tab1.
    CLEAR :qty1.

    wa_inv1-matnr_i = wa_zsales_tab1-matnr.
    wa_inv1-werks_i = wa_zsales_tab1-werks.
    wa_inv1-netwr_i = wa_zsales_tab1-net + wa_zsales_tab1-ed.
    wa_inv1-fkimg_i = wa_zsales_tab1-c_qty + wa_zsales_tab1-f_qty.
    qty1 = wa_zsales_tab1-nep_c_qty + wa_zsales_tab1-nep_f_qty.
    IF qty1 GT 0.
      wa_inv1-matnr_i+10(3) = '425'.
    ENDIF.
    wa_mat1-matnr = wa_inv1-matnr_i.
    COLLECT wa_mat1 INTO it_mat1.
    CLEAR wa_mat1.
    COLLECT wa_inv1 INTO itab_inv1.
    CLEAR wa_inv1.

  ENDLOOP.

*********************CURRENT MONTH SALE ***********************
  SELECT * FROM vbrk INTO TABLE it_vbrk WHERE fkdat GE date1 AND fkart IN ('ZBDF','ZCDF') AND fksto NE 'X'.
  IF sy-subrc EQ 0.
    SELECT * FROM vbrp INTO TABLE it_vbrp FOR ALL ENTRIES IN it_vbrk WHERE  vbeln = it_vbrk-vbeln AND fkimg NE 0 .
  ENDIF.
  IF it_vbrk IS NOT INITIAL.
    SELECT knumv kposn kschl kwert  FROM prcd_elements INTO TABLE it_konv FOR ALL ENTRIES IN it_vbrk WHERE knumv = it_vbrk-knumv
        AND kschl IN ('ZPED', 'ZEX4', 'ZGRP' ).
  ENDIF.

  SORT it_konv BY knumv kposn kschl.
  SORT it_vbrp BY vbeln.
  DELETE it_vbrp WHERE fkimg EQ 0.

  LOOP AT it_vbrp INTO wa_vbrp .
    CLEAR : pts,zped_rate,ed_rate.
    wa_tas1-matnr_i = wa_vbrp-matnr.
    wa_tas1-werks_i = wa_vbrp-werks.
    IF wa_vbrp-pstyv = 'ZAN'.
      wa_tas1-fkimg_i = wa_vbrp-fkimg.
    ENDIF.
    IF wa_vbrp-pstyv = 'ZAN'.
      READ TABLE it_vbrk INTO wa_vbrk WITH KEY vbeln = wa_vbrp-vbeln.
      IF sy-subrc EQ 0.
        READ TABLE it_konv INTO wa_konv WITH KEY knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZEX4' BINARY SEARCH.
        IF sy-subrc EQ 0.
          ed_rate = wa_konv-kwert.
        ENDIF.
        READ TABLE it_konv INTO wa_konv WITH KEY knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZPED' BINARY SEARCH.
        IF sy-subrc EQ 0.
          zped_rate = wa_konv-kwert.
        ENDIF.
        READ TABLE it_konv INTO wa_konv WITH KEY knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZGRP' BINARY SEARCH.
        IF sy-subrc EQ 0.
          zgrp_rate = wa_konv-kwert.
        ENDIF.
        pts = zped_rate + ed_rate.
        IF pts LE 0.
          pts =  zgrp_rate.
        ENDIF.
        wa_tas1-netwr_i = pts.
      ENDIF.
    ENDIF.
    COLLECT wa_tas1 INTO it_tas1.
    CLEAR wa_tas1.
  ENDLOOP.

  SELECT * FROM vbrk INTO TABLE it_vbrk1 WHERE fkdat GE date1 AND vbtyp EQ 'M' AND vkorg EQ '2000' AND  vtweg EQ '20'
     AND kalsm IN ( 'ZEXPNP','ZDOMON' ) AND fksto NE 'X' AND fkart IN ( 'Z002','Z004' ).
  IF sy-subrc EQ 0.

    SELECT * FROM vbrp INTO TABLE it_vbrp1 FOR ALL ENTRIES IN it_vbrk1 WHERE vbeln EQ it_vbrk1-vbeln AND fkimg GT 0 .
  ENDIF.
  IF it_vbrk1 IS NOT INITIAL.
    SELECT knumv kposn kschl kawrt kwert  FROM prcd_elements INTO TABLE it_konv1 FOR ALL ENTRIES IN it_vbrk1 WHERE knumv = it_vbrk1-knumv
      AND kschl IN ( 'ZCIN','DIFF' ).
  ENDIF.

  LOOP AT it_vbrp1 INTO wa_vbrp1.
    CLEAR : pts.
    wa_tas1-matnr_i = wa_vbrp1-matnr.
    wa_tas1-werks_i = wa_vbrp1-werks.
    wa_tas1-fkimg_i = wa_vbrp1-fkimg.

    IF wa_vbrp1-pstyv = 'TAN'.
      READ TABLE it_vbrk1 INTO wa_vbrk1 WITH KEY vbeln = wa_vbrp1-vbeln.
      IF sy-subrc EQ 0.
        READ TABLE it_konv1 INTO wa_konv1 WITH KEY knumv = wa_vbrk1-knumv kposn = wa_vbrp1-posnr kschl = 'ZCIN'.
        IF sy-subrc EQ 0.
          pts = wa_konv1-kwert.
        ENDIF.
        IF pts EQ 0.
          READ TABLE it_konv1 INTO wa_konv1 WITH KEY knumv = wa_vbrk1-knumv kposn = wa_vbrp1-posnr kschl = 'DIFF'.
          IF sy-subrc EQ 0.
            pts = wa_konv1-kawrt / wa_vbrp1-fkimg.
          ENDIF.
        ENDIF.
        wa_tas1-netwr_i = pts * wa_vbrp1-fkimg.
      ENDIF.
    ENDIF.
    COLLECT wa_tas1 INTO it_tas1.
    CLEAR wa_tas1.
  ENDLOOP.

  LOOP AT it_tas1 INTO wa_tas1.

    wa_tas2-matnr_i = wa_tas1-matnr_i.
    wa_tas2-werks_i = wa_tas1-werks_i.
    wa_tas2-fkimg_i = wa_tas1-fkimg_i.
    wa_tas2-netwr_i = wa_tas1-netwr_i.
    COLLECT wa_tas2 INTO it_tas2.
    CLEAR wa_tas2.
    wa_mat1-matnr = wa_tas1-matnr_i.
    SELECT SINGLE * FROM mvke WHERE matnr EQ wa_tas1-matnr_i AND vkorg EQ '1000' AND vtweg EQ '10'.
    IF sy-subrc EQ 0.
      wa_mat1-mvgr4 = mvke-mvgr4.
    ENDIF.
    IF wa_mat1-mvgr4 EQ space.  "24.11.21
      SELECT SINGLE * FROM mvke WHERE matnr EQ wa_tas1-matnr_i AND vkorg EQ '2000' AND vtweg EQ '20'.
      IF sy-subrc EQ 0.
        wa_mat1-mvgr4 = mvke-mvgr4.
      ENDIF.
    ENDIF.
    COLLECT wa_mat1 INTO it_mat1.
    CLEAR wa_mat1.
  ENDLOOP.

********************** CURRENT SALE ENDS**********
*************************TRANSIT********************
*  SELECT * FROM MARC INTO TABLE IT_MARC WHERE WERKS IN S_WERKS1 AND TRAME GT 0.
  SELECT * FROM marc INTO TABLE it_marc
    FOR ALL ENTRIES IN itab_t001w
    WHERE werks = itab_t001w-werks AND trame GT 0.
  LOOP AT it_marc INTO wa_marc.

    wa_tran1-matnr_i = wa_marc-matnr.
    wa_tran1-werks_i = wa_marc-werks.
    wa_tran1-fkimg_i = wa_marc-trame.
    READ TABLE itab_a004 ASSIGNING <fs_a004> WITH KEY matnr = wa_marc-matnr BINARY SEARCH.
    IF sy-subrc = 0.
      READ TABLE itab_konp ASSIGNING <fs_konp> WITH KEY knumh = <fs_a004>-knumh BINARY SEARCH.
      IF sy-subrc = 0.
        wa_tran1-netwr_i = <fs_konp>-kbetr.
      ENDIF.
    ENDIF.

    COLLECT wa_tran1 INTO it_tran1.
    CLEAR wa_tran1.
    wa_mat1-matnr = wa_marc-matnr.
    SELECT SINGLE * FROM mvke WHERE matnr EQ wa_marc-matnr AND vkorg EQ '1000' AND vtweg EQ '10'.
    IF sy-subrc EQ 0.
      wa_mat1-mvgr4 = mvke-mvgr4.
    ENDIF.
    IF wa_mat1-mvgr4 EQ space.  "24.11.21
      SELECT SINGLE * FROM mvke WHERE matnr EQ wa_marc-matnr AND vkorg EQ '2000' AND vtweg EQ '20'.
      IF sy-subrc EQ 0.
        wa_mat1-mvgr4 = mvke-mvgr4.
      ENDIF.
    ENDIF.

    COLLECT wa_mat1 INTO it_mat1.
    CLEAR wa_mat1.
  ENDLOOP.
**********************STOCK***********************************
  LOOP AT it_mard INTO wa_mard .

    CLEAR : stock,stock1.
    IF wa_mard-werks EQ '1000' OR wa_mard-werks EQ '1001'.
      stock = wa_mard-labst.
      IF stock GT 0.
        wa_stk1-matnr_i = wa_mard-matnr.
        wa_stk1-werks_i = wa_mard-werks.
        wa_stk1-fkimg_i = stock.
        READ TABLE itab_a004 ASSIGNING <fs_a004> WITH KEY matnr = wa_mard-matnr BINARY SEARCH.
        IF sy-subrc = 0.
          READ TABLE itab_konp ASSIGNING <fs_konp> WITH KEY knumh = <fs_a004>-knumh BINARY SEARCH.
          IF sy-subrc = 0.
            wa_stk1-netwr_i = <fs_konp>-kbetr.
          ENDIF.
        ENDIF.
        COLLECT wa_stk1 INTO it_stk1.
        CLEAR wa_stk1.
        wa_mat1-matnr = wa_mard-matnr.
        COLLECT wa_mat1 INTO it_mat1.
        CLEAR wa_mat1.
      ENDIF.

      stock1 =  wa_mard-speme.

      IF stock1 GT 0.
        wa_tran1-matnr_i = wa_mard-matnr.
        wa_tran1-werks_i = wa_mard-werks.
        wa_tran1-fkimg_i = stock1.
        READ TABLE itab_a004 ASSIGNING <fs_a004> WITH KEY matnr = wa_mard-matnr BINARY SEARCH.
        IF sy-subrc = 0.
          READ TABLE itab_konp ASSIGNING <fs_konp> WITH KEY knumh = <fs_a004>-knumh BINARY SEARCH.
          IF sy-subrc = 0.
            wa_tran1-netwr_i = <fs_konp>-kbetr.
          ENDIF.
        ENDIF.
        COLLECT wa_tran1 INTO it_tran1.
        CLEAR wa_tran1.
        wa_mat1-matnr = wa_mard-matnr.
        COLLECT wa_mat1 INTO it_mat1.
        CLEAR wa_mat1.
      ENDIF.

    ELSE.
      stock = wa_mard-labst + wa_mard-retme + wa_mard-speme + wa_mard-insme.
      IF stock GT 0.
        wa_stk1-matnr_i = wa_mard-matnr.
        wa_stk1-werks_i = wa_mard-werks.
        wa_stk1-fkimg_i = stock.
        READ TABLE itab_a004 ASSIGNING <fs_a004> WITH KEY matnr = wa_mard-matnr BINARY SEARCH.
        IF sy-subrc = 0.
          READ TABLE itab_konp ASSIGNING <fs_konp> WITH KEY knumh = <fs_a004>-knumh BINARY SEARCH.
          IF sy-subrc = 0.
            wa_stk1-netwr_i = <fs_konp>-kbetr.
          ENDIF.
        ENDIF.
        COLLECT wa_stk1 INTO it_stk1.
        CLEAR wa_stk1.
        wa_mat1-matnr = wa_mard-matnr.
        COLLECT wa_mat1 INTO it_mat1.
        CLEAR wa_mat1.
      ENDIF.
    ENDIF.
  ENDLOOP.
**********************************************************
ENDFORM.                    " SELECT

*&---------------------------------------------------------------------*
*&      Form  FILL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fill.

  DATA: w_val   TYPE dmbtr,
        w_val1  TYPE dmbtr,
        w_kbetr TYPE kbetr,
        wa_flag TYPE c,
        w_flag1 TYPE c.

  DATA: l_var   TYPE string,
        l_flag1 TYPE string.


  SORT itab_t001w BY zseq_no.
  SORT it_mat1 BY matnr.
  DELETE ADJACENT DUPLICATES FROM it_mat1.

  LOOP AT it_mat1 INTO wa_mat1.
    IF wa_mat1-mvgr4 EQ space.
      SELECT SINGLE * FROM mvke WHERE matnr EQ wa_mat1-matnr AND vkorg EQ '2000' AND vtweg EQ '20'.
      IF sy-subrc EQ 0.
        wa_mat1-mvgr4 = mvke-mvgr4.
        MODIFY it_mat1 FROM wa_mat1 TRANSPORTING mvgr4.
        CLEAR wa_mat1.
      ELSE.
        SELECT SINGLE * FROM mvke WHERE matnr EQ wa_mat1-matnr AND vkorg EQ '1000' AND vtweg EQ '10'.
        IF sy-subrc EQ 0.
          wa_mat1-mvgr4 = mvke-mvgr4.
          MODIFY it_mat1 FROM wa_mat1 TRANSPORTING mvgr4.
          CLEAR wa_mat1.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.



  IF it_mat1 IS NOT INITIAL.
    SELECT * FROM a602 INTO TABLE it_a602 FOR ALL ENTRIES IN it_mat1 WHERE kschl EQ 'ZCIN' AND matnr EQ it_mat1-matnr AND datbi GE sy-datum.
  ENDIF.
  SORT it_a602 DESCENDING BY datab.


  LOOP AT it_mat1 INTO wa_mat1.
    READ TABLE it_tran1 INTO wa_tran1 WITH KEY matnr_i = wa_mat1-matnr.
    IF sy-subrc EQ 4.
      wa_tran1-matnr_i = wa_mat1-matnr.
      wa_tran1-netwr_i = 0.
      wa_tran1-fkimg_i = 0.
      COLLECT wa_tran1 INTO it_tran1.
      CLEAR wa_tran1.
    ENDIF.
    READ TABLE itab_inv INTO wa_inv WITH KEY matnr_i = wa_mat1-matnr.
    IF sy-subrc EQ 4.
      wa_inv-matnr_i = wa_mat1-matnr.
      wa_inv-netwr_i = 0.
      wa_inv-fkimg_i = 0.
      COLLECT wa_inv INTO itab_inv.
      CLEAR wa_inv.
    ENDIF.
    READ TABLE itab_inv2 INTO wa_inv2 WITH KEY matnr_i = wa_mat1-matnr.
    IF sy-subrc EQ 4.
      wa_inv2-matnr_i = wa_mat1-matnr.
      wa_inv2-netwr_i = 0.
      wa_inv2-fkimg_i = 0.
      COLLECT wa_inv2 INTO itab_inv2.
      CLEAR wa_inv2.
    ENDIF.


    READ TABLE itab_inv1 INTO wa_inv1 WITH KEY matnr_i = wa_mat1-matnr.
    IF sy-subrc EQ 4.
      wa_inv1-matnr_i = wa_mat1-matnr.
      wa_inv1-netwr_i = 0.
      wa_inv1-fkimg_i = 0.
      COLLECT wa_inv1 INTO itab_inv1.
      CLEAR wa_inv1.
    ENDIF.
    READ TABLE it_stk1 INTO wa_stk1 WITH KEY matnr_i = wa_mat1-matnr.
    IF sy-subrc EQ 4.
      wa_stk1-matnr_i = wa_mat1-matnr.
      wa_stk1-netwr_i = 0.
      wa_stk1-fkimg_i = 0.
      COLLECT wa_stk1 INTO it_stk1.
      CLEAR wa_stk1.
    ENDIF.
    READ TABLE it_tas2 INTO wa_tas2 WITH KEY matnr_i = wa_mat1-matnr.
    IF sy-subrc EQ 4.
      wa_tas2-matnr_i = wa_mat1-matnr.
      wa_tas2-netwr_i = 0.
      wa_tas2-fkimg_i = 0.
      COLLECT wa_tas2 INTO it_tas2.
      CLEAR wa_tas2.
    ENDIF.
  ENDLOOP.


  LOOP AT itab_mara ASSIGNING <fs_mara> .
    CLEAR : t1,t2,t3,t4.
    t1 = 1.
    t2 = 1.
    t3 = 1.
    READ TABLE it_tran1 INTO wa_tran1 WITH KEY matnr_i = <fs_mara>-matnr.
    IF sy-subrc EQ 4.
      t1 = 0.
    ENDIF.


    READ TABLE it_stk1 INTO wa_stk1 WITH KEY matnr_i = <fs_mara>-matnr.
    IF sy-subrc EQ 4.
      t2 = 0.
    ENDIF.

    READ TABLE it_tas2 INTO wa_tas2 WITH KEY matnr_i = <fs_mara>-matnr.
    IF sy-subrc EQ 4.
      t3 = 0.
    ENDIF.

    t4 = t1 + t2 + t3.
    IF t4 EQ 0.
      DELETE itab_mara WHERE matnr EQ <fs_mara>-matnr.
    ENDIF.
  ENDLOOP.

  LOOP AT itab_mara INTO wa_mara.
    IF wa_mara-mvgr4 EQ space.
      SELECT SINGLE * FROM mvke WHERE matnr EQ wa_mara-matnr AND vkorg EQ '2000' AND vtweg EQ '20'.
      IF sy-subrc EQ 0.
        wa_mara-mvgr4 = mvke-mvgr4.
        MODIFY itab_mara FROM wa_mara TRANSPORTING mvgr4.
        CLEAR wa_mara.
      ELSE.
        SELECT SINGLE * FROM mvke WHERE matnr EQ wa_mara-matnr AND vkorg EQ '1000' AND vtweg EQ '10'.
        IF sy-subrc EQ 0.
          wa_mara-mvgr4 = mvke-mvgr4.
          MODIFY itab_mara FROM wa_mara TRANSPORTING mvgr4.
          CLEAR wa_mara.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.



  LOOP AT itab_mara INTO wa_mara.
    IF wa_mara-matnr GE '000000000042500000' AND wa_mara-matnr LE '000000000042599999' .
      CONCATENATE 'NEP' wa_mara-mvgr4 INTO wa_mara-mvgr41.
      MODIFY itab_mara FROM wa_mara TRANSPORTING mvgr41.
      CLEAR wa_mara.
    ENDIF.
  ENDLOOP.

  SORT itab_mara BY matkl mvgr4.

  LOOP AT itab_mara ASSIGNING <fs_mara> .
    CLEAR: w_kbetr, wa_mvke, wa_tvm4t, w_flag1, wa_tvm5t, l_vkorg, l_vtweg.

    SELECT SINGLE * FROM mvke WHERE matnr EQ <fs_mara>-matnr AND  vkorg EQ '1000' AND vtweg EQ '10'.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM tvm5t WHERE spras EQ 'EN' AND mvgr5 EQ mvke-mvgr5.
      IF sy-subrc EQ 0.
        wa_tvm5t-bezei = tvm5t-bezei.
      ENDIF.
    ELSE.
      SELECT SINGLE * FROM mvke WHERE matnr EQ <fs_mara>-matnr AND  vkorg EQ '2000' AND vtweg EQ '20'.
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM tvm5t WHERE spras EQ 'EN' AND mvgr5 EQ mvke-mvgr5.
        IF sy-subrc EQ 0.
          wa_tvm5t-bezei = tvm5t-bezei.
        ENDIF.
      ENDIF.
    ENDIF.

    LOOP AT it_tas2 ASSIGNING <fs_inv> WHERE matnr_i = <fs_mara>-matnr.
      CLEAR : w_val.
      w_val = <fs_inv>-fkimg_i.

      gw_fdata-matnr = <fs_mara>-matnr.
      CLEAR : wa_maktx.
      READ TABLE itab_tvm4t INTO wa_tvm4t WITH KEY mvgr4 = <fs_mara>-mvgr4.
      IF sy-subrc EQ 0.
        wa_maktx = wa_tvm4t-maktx.
      ELSE.
        SELECT SINGLE  bezei FROM tvm4t INTO  wa_maktx
          WHERE mvgr4 = <fs_mara>-mvgr4
          AND spras = sy-langu.
      ENDIF.
      gw_fdata-maktx = wa_maktx.
      gw_fdata-mvgr4 = <fs_mara>-mvgr4.
      gw_fdata-matkl = <fs_mara>-matkl.
      gw_fdata-mvgr41 = <fs_mara>-mvgr41.
      gw_fdata-spart = <fs_mara>-spart.
      gw_fdata-bezei = wa_tvm5t-bezei.
      gw_fdata-werks = <fs_inv>-werks_i.
      CLEAR: wa_t001w.
      READ TABLE itab_t001w INTO wa_t001w WITH KEY werks = <fs_inv>-werks_i.
      IF sy-subrc = 0.
        gw_fdata-zshort_nm = wa_t001w-zshort_nm.
        gw_fdata-zseq_no = wa_t001w-zseq_no.
      ENDIF.
      gw_fdata-zvalsl = w_val.

      COLLECT gw_fdata INTO gt_fdata.
***  collect w/0 MATERIAL and then update to Z table.
      CLEAR gw_fdata-matnr.
      COLLECT gw_fdata INTO gt_fdata1.
      CLEAR gw_fdata.

    ENDLOOP.

    LOOP AT it_stk1 ASSIGNING <fs_inv> WHERE matnr_i = <fs_mara>-matnr.
      CLEAR : w_val.

      w_val = <fs_inv>-fkimg_i.

      gw_fdata-matnr = <fs_mara>-matnr.
      CLEAR : wa_maktx.
      READ TABLE itab_tvm4t INTO wa_tvm4t WITH KEY mvgr4 = <fs_mara>-mvgr4.
      IF sy-subrc EQ 0.
        wa_maktx = wa_tvm4t-maktx.
      ELSE.
        SELECT SINGLE  bezei FROM tvm4t INTO  wa_maktx
          WHERE mvgr4 = <fs_mara>-mvgr4
          AND spras = sy-langu.
      ENDIF.
      gw_fdata-maktx = wa_maktx.
      gw_fdata-mvgr4 = <fs_mara>-mvgr4.
      gw_fdata-matkl = <fs_mara>-matkl.
      gw_fdata-mvgr41 = <fs_mara>-mvgr41.
      gw_fdata-spart = <fs_mara>-spart.
      gw_fdata-bezei = wa_tvm5t-bezei.
      gw_fdata-werks = <fs_inv>-werks_i.
      CLEAR: wa_t001w.
      READ TABLE itab_t001w INTO wa_t001w WITH KEY werks = <fs_inv>-werks_i.
      IF sy-subrc = 0.
        gw_fdata-zshort_nm = wa_t001w-zshort_nm.
        gw_fdata-zseq_no = wa_t001w-zseq_no.
      ENDIF.
      gw_fdata-zvalst = w_val.

      COLLECT gw_fdata INTO gt_fdata.
***  collect w/0 MATERIAL and then update to Z table.
      CLEAR gw_fdata-matnr.
      COLLECT gw_fdata INTO gt_fdata1.
      CLEAR gw_fdata.
    ENDLOOP.

****change by jyotsna**
    LOOP AT it_tran1 ASSIGNING <fs_inv> WHERE matnr_i = <fs_mara>-matnr.

      CLEAR : w_val.

      gw_fdata-matnr = <fs_mara>-matnr.
      CLEAR : wa_maktx.
      READ TABLE itab_tvm4t INTO wa_tvm4t WITH KEY mvgr4 = <fs_mara>-mvgr4.
      IF sy-subrc EQ 0.
        wa_maktx = wa_tvm4t-maktx.
      ELSE.
        SELECT SINGLE  bezei FROM tvm4t INTO  wa_maktx
          WHERE mvgr4 = <fs_mara>-mvgr4
          AND spras = sy-langu.
      ENDIF.
      gw_fdata-maktx = wa_maktx.
      gw_fdata-mvgr4 = <fs_mara>-mvgr4.
      gw_fdata-matkl = <fs_mara>-matkl.
      gw_fdata-mvgr41 = <fs_mara>-mvgr41.
      gw_fdata-spart = <fs_mara>-spart.
      gw_fdata-bezei = wa_tvm5t-bezei.
      gw_fdata-werks = <fs_inv>-werks_i.
      CLEAR: wa_t001w.
      READ TABLE itab_t001w INTO wa_t001w WITH KEY werks = <fs_inv>-werks_i.
      IF sy-subrc = 0.
        gw_fdata-zshort_nm = wa_t001w-zshort_nm.
        gw_fdata-zseq_no = wa_t001w-zseq_no.
      ENDIF.
      gw_fdata-zvalit = <fs_inv>-fkimg_i.

      COLLECT gw_fdata INTO gt_fdata.
***  collect w/0 MATERIAL and then update to Z table.
      CLEAR gw_fdata-matnr.
      COLLECT gw_fdata INTO gt_fdata1.
      CLEAR gw_fdata.

    ENDLOOP.

    LOOP AT itab_inv ASSIGNING <fs_inv> WHERE matnr_i = <fs_mara>-matnr.
      CLEAR : w_val.

      w_val = <fs_inv>-fkimg_i.


      gw_fdata-matnr = <fs_mara>-matnr.
      CLEAR : wa_maktx.
      READ TABLE itab_tvm4t INTO wa_tvm4t WITH KEY mvgr4 = <fs_mara>-mvgr4.
      IF sy-subrc EQ 0.
        wa_maktx = wa_tvm4t-maktx.
      ELSE.
        SELECT SINGLE  bezei FROM tvm4t INTO  wa_maktx
          WHERE mvgr4 = <fs_mara>-mvgr4
          AND spras = sy-langu.
      ENDIF.
      gw_fdata-maktx = wa_maktx.
      gw_fdata-mvgr4 = <fs_mara>-mvgr4.
      gw_fdata-matkl = <fs_mara>-matkl.
      gw_fdata-mvgr41 = <fs_mara>-mvgr41.
      gw_fdata-spart = <fs_mara>-spart.
      gw_fdata-bezei = wa_tvm5t-bezei.
      gw_fdata-werks = <fs_inv>-werks_i.
      CLEAR: wa_t001w.
      READ TABLE itab_t001w INTO wa_t001w WITH KEY werks = <fs_inv>-werks_i.
      IF sy-subrc = 0.
        gw_fdata-zshort_nm = wa_t001w-zshort_nm.
        gw_fdata-zseq_no = wa_t001w-zseq_no.
      ENDIF.
      gw_fdata-zvallms = <fs_inv>-fkimg_i.

      COLLECT gw_fdata INTO gt_fdata.
***  collect w/0 MATERIAL and then update to Z table.
      CLEAR gw_fdata-matnr.
      COLLECT gw_fdata INTO gt_fdata1.
      CLEAR gw_fdata.
    ENDLOOP.


    LOOP AT itab_inv1 ASSIGNING <fs_inv> WHERE matnr_i = <fs_mara>-matnr AND fkdat IN r_dat2.
      CLEAR : w_val.

      w_val = <fs_inv>-fkimg_i.

      gw_fdata-matnr = <fs_mara>-matnr.
      CLEAR : wa_maktx.
      READ TABLE itab_tvm4t INTO wa_tvm4t WITH KEY mvgr4 = <fs_mara>-mvgr4.
      IF sy-subrc EQ 0.
        wa_maktx = wa_tvm4t-maktx.
      ELSE.
        SELECT SINGLE  bezei FROM tvm4t INTO  wa_maktx
          WHERE mvgr4 = <fs_mara>-mvgr4
          AND spras = sy-langu.
      ENDIF.
      gw_fdata-maktx = wa_maktx.
      gw_fdata-mvgr4 = <fs_mara>-mvgr4.
      gw_fdata-matkl = <fs_mara>-matkl.
      gw_fdata-mvgr41 = <fs_mara>-mvgr41.
      gw_fdata-spart = <fs_mara>-spart.
      gw_fdata-bezei = wa_tvm5t-bezei.
      gw_fdata-werks = <fs_inv>-werks_i.
      CLEAR: wa_t001w.
      READ TABLE itab_t001w INTO wa_t001w WITH KEY werks = <fs_inv>-werks_i.
      IF sy-subrc = 0.
        gw_fdata-zshort_nm = wa_t001w-zshort_nm.
        gw_fdata-zseq_no = wa_t001w-zseq_no.
      ENDIF.
      gw_fdata-zvalllm = <fs_inv>-fkimg_i.
      COLLECT gw_fdata INTO gt_fdata.
***  collect w/0 MATERIAL and then update to Z table.
      CLEAR gw_fdata-matnr.
      COLLECT gw_fdata INTO gt_fdata1.
      CLEAR gw_fdata.

    ENDLOOP.


    LOOP AT itab_inv2 ASSIGNING <fs_inv> WHERE matnr_i = <fs_mara>-matnr.
      CLEAR : w_val.


      w_val = <fs_inv>-fkimg_i.

      gw_fdata-matnr = <fs_mara>-matnr.
      CLEAR : wa_maktx.
      READ TABLE itab_tvm4t INTO wa_tvm4t WITH KEY mvgr4 = <fs_mara>-mvgr4.
      IF sy-subrc EQ 0.
        wa_maktx = wa_tvm4t-maktx.
      ELSE.
        SELECT SINGLE  bezei FROM tvm4t INTO  wa_maktx
          WHERE mvgr4 = <fs_mara>-mvgr4
          AND spras = sy-langu.
      ENDIF.
      gw_fdata-maktx = wa_maktx.
      gw_fdata-matkl = <fs_mara>-matkl.
      gw_fdata-mvgr4 = <fs_mara>-mvgr4.
      gw_fdata-mvgr41 = <fs_mara>-mvgr41.
      gw_fdata-spart = <fs_mara>-spart.
      gw_fdata-bezei = wa_tvm5t-bezei.
      gw_fdata-werks = <fs_inv>-werks_i.
      CLEAR: wa_t001w.
      READ TABLE itab_t001w INTO wa_t001w WITH KEY werks = <fs_inv>-werks_i.
      IF sy-subrc = 0.
        gw_fdata-zshort_nm = wa_t001w-zshort_nm.
        gw_fdata-zseq_no = wa_t001w-zseq_no.
      ENDIF.
      gw_fdata-zvallys = <fs_inv>-fkimg_i.
      COLLECT gw_fdata INTO gt_fdata.
***  collect w/0 MATERIAL and then update to Z table.
      CLEAR gw_fdata-matnr.
      COLLECT gw_fdata INTO gt_fdata1.
      CLEAR gw_fdata.

    ENDLOOP.
  ENDLOOP.

****  fill low - 25% and High-200% values cols
  IF gt_fdata1[] IS NOT INITIAL.
    SORT gt_fdata1 by werks.
    delete gt_fdata1 WHERE werks is INITIAL.
***    delete existing data from ZCFASTOCKSTATUS
    CALL FUNCTION 'ENQUEUE_E_TABLE'
      EXPORTING
        mode_rstable   = 'E'
        tabname        = 'ZCFASTOCKSTATUS'
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ELSE.
      DELETE FROM zcfastockstatus.
    ENDIF.


*** get excess/shortage calculation based on MAX val only for fields and NOT for Plants.
    SORT gt_fdata1 BY matkl matnr spart zseq_no.
    CLEAR gw_fdata.
    LOOP AT gt_fdata1 INTO gw_fdata.
      gw_fdata-mandt = sy-mandt.
      CLEAR wa_t001w.
      READ TABLE itab_t001w INTO wa_t001w WITH KEY werks = gw_fdata-werks ztype = 'C'.  "only for fields i.e.type C
      IF sy-subrc = 0.
***    check for MAX value from SL/LMS/LLM/LYS - based on selected checkboxes at input
        IF p_sl = 'X'.
          CLEAR gv_valmax.
          gv_valmax = gw_fdata-zvalsl.
        ENDIF.
        IF p_lms = 'X'.
          CLEAR gv_valmax.
          gv_valmax = gw_fdata-zvallms.
        ENDIF.
        IF p_llm = 'X'.
          CLEAR gv_valmax.
          gv_valmax = gw_fdata-zvalllm.
        ENDIF.
        IF p_lys = 'X'.
          CLEAR gv_valmax.
          gv_valmax = gw_fdata-zvallys.
        ENDIF.
        IF p_sl NE 'X' AND p_lms NE 'X' AND p_llm NE 'X' AND p_lys NE 'X'.
          CLEAR gv_valmax.
          gv_valmax = gw_fdata-zvalsl.
        ENDIF.

        IF gw_fdata-zvalsl >= gv_valmax AND p_sl = 'X' .
          gv_valmax = gw_fdata-zvalsl.
        ENDIF.
        IF gw_fdata-zvallms >= gv_valmax AND p_lms = 'X' .
          gv_valmax = gw_fdata-zvallms.
        ENDIF.
        IF gw_fdata-zvalllm >= gv_valmax AND p_llm = 'X' .
          gv_valmax = gw_fdata-zvalllm .
        ENDIF.
        IF gw_fdata-zvallys  >= gv_valmax AND p_lys = 'X'.
          gv_valmax = gw_fdata-zvallys .
        ENDIF.
***  calculate 25% and 200% of MAX value
        IF gv_valmax IS NOT INITIAL.
          gw_fdata-zvallow = ( gv_valmax * 25 ) / 100.
          gw_fdata-zvalhigh = ( gv_valmax * 200 ) / 100.
        ENDIF.
      ENDIF.

      gw_fdata-aedat = sy-datum.
      gw_fdata-druhr = sy-uzeit.
      MODIFY gt_fdata1 FROM gw_fdata TRANSPORTING mandt zvallow zvalhigh aedat druhr.
      CLEAR gw_fdata.
    ENDLOOP.

****  update to Z table
    MODIFY zcfastockstatus FROM TABLE gt_fdata1[].
    IF sy-subrc = 0.
      CALL FUNCTION 'DEQUEUE_E_TABLE'
        EXPORTING
          mode_rstable = 'E'
          tabname      = 'ZCFASTOCKSTATUS'.

    ENDIF.

  ENDIF.
ENDFORM.                    " FILL

*&---------------------------------------------------------------------*
*&      Form  ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv .

  DATA: lw_pos TYPE i.

  lw_pos = 1.
  gw_fieldcat1-fieldname  = 'ZSHORT_NM'.
  gw_fieldcat1-seltext_l  = 'Location'.
  gw_fieldcat1-tabname = 'GT_FDATA'.
  gw_fieldcat1-col_pos = lw_pos.
  APPEND gw_fieldcat1 TO gt_fieldcat1.
  CLEAR gw_fieldcat1.

  gw_fieldcat1-fieldname  = 'WERKS'.
  gw_fieldcat1-seltext_l  = 'Plant'.
  gw_fieldcat1-tabname = 'GT_FDATA'.
  gw_fieldcat1-col_pos = lw_pos + 1.
  APPEND gw_fieldcat1 TO gt_fieldcat1.
  CLEAR gw_fieldcat1.

  gw_fieldcat1-fieldname  = 'MAKTX'.
  gw_fieldcat1-seltext_l  = 'Product'.
  gw_fieldcat1-tabname = 'GT_FDATA'.
  gw_fieldcat1-col_pos = lw_pos + 1.
  APPEND gw_fieldcat1 TO gt_fieldcat1.
  CLEAR gw_fieldcat1.

  gw_fieldcat1-fieldname  = 'BEZEI'.
  gw_fieldcat1-seltext_l  = 'SL PCK'.
  gw_fieldcat1-tabname = 'GT_FDATA'.
  gw_fieldcat1-col_pos = lw_pos + 1.
  APPEND gw_fieldcat1 TO gt_fieldcat1.
  CLEAR gw_fieldcat1.

  gw_fieldcat1-fieldname  = 'MATKL'.
  gw_fieldcat1-seltext_l  = 'Mat.Group'.
  gw_fieldcat1-tabname = 'GT_FDATA'.
  gw_fieldcat1-col_pos = lw_pos + 1.
  APPEND gw_fieldcat1 TO gt_fieldcat1.
  CLEAR gw_fieldcat1.

  gw_fieldcat1-fieldname  = 'MVGR4'.
  gw_fieldcat1-seltext_l  = 'Mat.Group 4'.
  gw_fieldcat1-tabname = 'GT_FDATA'.
  gw_fieldcat1-col_pos = lw_pos + 1.
  APPEND gw_fieldcat1 TO gt_fieldcat1.
  CLEAR gw_fieldcat1.

  gw_fieldcat1-fieldname  = 'MVGR41'.
  gw_fieldcat1-seltext_l  = 'Mat.Group 4-NEP'.
  gw_fieldcat1-tabname = 'GT_FDATA'.
  gw_fieldcat1-col_pos = lw_pos + 1.
  APPEND gw_fieldcat1 TO gt_fieldcat1.
  CLEAR gw_fieldcat1.

  gw_fieldcat1-fieldname  = 'SPART'.
  gw_fieldcat1-seltext_l  = 'Division'.
  gw_fieldcat1-tabname = 'GT_FDATA'.
  gw_fieldcat1-col_pos = lw_pos + 1.
  APPEND gw_fieldcat1 TO gt_fieldcat1.
  CLEAR gw_fieldcat1.

  gw_fieldcat1-fieldname  = 'ZVALST'.
  gw_fieldcat1-seltext_l  = 'ST'.
  gw_fieldcat1-tabname = 'GT_FDATA'.
  gw_fieldcat1-col_pos = lw_pos + 1.
  APPEND gw_fieldcat1 TO gt_fieldcat1.
  CLEAR gw_fieldcat1.

  gw_fieldcat1-fieldname  = 'ZVALIT'.
  gw_fieldcat1-seltext_l  = 'IT'.
  gw_fieldcat1-tabname = 'GT_FDATA'.
  gw_fieldcat1-col_pos = lw_pos + 1.
  APPEND gw_fieldcat1 TO gt_fieldcat1.

  CLEAR gw_fieldcat1.
  gw_fieldcat1-fieldname  = 'ZVALSL'.
  gw_fieldcat1-seltext_l  = 'SL'.
  gw_fieldcat1-tabname = 'GT_FDATA'.
  gw_fieldcat1-col_pos = lw_pos + 1.
  APPEND gw_fieldcat1 TO gt_fieldcat1.

  CLEAR gw_fieldcat1.
  gw_fieldcat1-fieldname  = 'ZVALLMS'.
  gw_fieldcat1-seltext_l  = 'LMS'.
  gw_fieldcat1-tabname = 'GT_FDATA'.
  gw_fieldcat1-col_pos = lw_pos + 1.
  APPEND gw_fieldcat1 TO gt_fieldcat1.
  CLEAR gw_fieldcat1.

  gw_fieldcat1-fieldname  = 'ZVALLLM'.
  gw_fieldcat1-seltext_l  = 'LLM'.
  gw_fieldcat1-tabname = 'GT_FDATA'.
  gw_fieldcat1-col_pos = lw_pos + 1.
  APPEND gw_fieldcat1 TO gt_fieldcat1.
  CLEAR gw_fieldcat1.

  gw_fieldcat1-fieldname  = 'ZVALLYS'.
  gw_fieldcat1-seltext_l  = 'LYS'.
  gw_fieldcat1-tabname = 'GT_FDATA'.
  gw_fieldcat1-col_pos = lw_pos + 1.
  APPEND gw_fieldcat1 TO gt_fieldcat1.
  CLEAR gw_fieldcat1.

  gw_fieldcat1-fieldname  = 'ZVALLOW'.
  gw_fieldcat1-seltext_l  = 'LOW'.
  gw_fieldcat1-tabname = 'GT_FDATA'.
  gw_fieldcat1-col_pos = lw_pos + 1.
  APPEND gw_fieldcat1 TO gt_fieldcat1.
  CLEAR gw_fieldcat1.

  gw_fieldcat1-fieldname  = 'ZVALHIGH'.
  gw_fieldcat1-seltext_l  = 'HIGH'.
  gw_fieldcat1-tabname = 'GT_FDATA'.
  gw_fieldcat1-col_pos = lw_pos + 1.
  APPEND gw_fieldcat1 TO gt_fieldcat1.
  CLEAR gw_fieldcat1.

  CLEAR gw_layout.
  gw_layout-colwidth_optimize = 'X'.          "Optimization of Col width
  gw_layout-zebra             = 'X'.
  gw_layout-coltab_fieldname = 'CELL'.        "alternate colours for diaplay


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program     = g_repid
      i_callback_top_of_page = 'INCLUDE_TOP_OF_PAGE'
      is_layout              = gw_layout
      it_fieldcat            = gt_fieldcat1
      i_default              = 'X'
      i_save                 = 'A'
    TABLES
      t_outtab               = gt_fdata_alv
    EXCEPTIONS
      program_error          = 1
      OTHERS                 = 2.

ENDFORM.                    " ALV
*&---------------------------------------------------------------------*
*&      Form  PDF_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM pdf_layout .

  DATA: fm_name TYPE  tdsfname.

  IF gt_fdata1[] IS NOT INITIAL.
***    remove nepal data
    SORT gt_fdata1 BY spart.
    DELETE gt_fdata1 WHERE spart =  '30'.
***    move data to gt_fdata[]
    CLEAR gt_fdata[].
    gt_fdata[] = gt_fdata1[].

***  get distinct product data
    CLEAR gt_maktx[].
    gt_maktx[] = gt_fdata[].

    SORT gt_maktx BY maktx.
    DELETE ADJACENT DUPLICATES FROM gt_maktx COMPARING maktx.

    SORT gt_fdata BY maktx zshort_nm.

    CLEAR fm_name.
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname = 'ZCFASTOCKSTATUS_SF'
      IMPORTING
        fm_name  = fm_name.

    gw_output_opts-tdnoprev = gc_true.
    gw_output_opts-tddest    = 'LOCL'.
    gw_output_opts-tdnoprint = gc_true.

    gw_contrl_para-getotf = gc_true.
    gw_contrl_para-no_dialog = gc_true.
    gw_contrl_para-preview = space.

**    gw_output_opts-tdnoprev = space.
**    gw_output_opts-tddest    = 'LOCL'.
**    gw_output_opts-tdnoprint = space.
**
**    gw_contrl_para-no_dialog = space.
**    gw_contrl_para-preview = space.

    CALL FUNCTION fm_name
      EXPORTING
        control_parameters = gw_contrl_para
*       MAIL_APPL_OBJ      =
*       MAIL_RECIPIENT     =
*       MAIL_SENDER        =
        output_options     = gw_output_opts
*       USER_SETTINGS      = 'X'
      IMPORTING
*       document_output_info =
        job_output_info    = gt_otf_data
*       job_output_options =
      TABLES
        gt_fdata           = gt_fdata
        gt_maktx           = gt_maktx
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    gt_otf[] = gt_otf_data-otfdata[].

    CALL FUNCTION 'CONVERT_OTF'
      EXPORTING
        format                = 'PDF'
      IMPORTING
        bin_filesize          = gv_bin_filesize
        bin_file              = gv_bin_xstr
      TABLES
        otf                   = gt_otf[]
        lines                 = gt_tline[]
      EXCEPTIONS
        err_max_linewidth     = 1
        err_format            = 2
        err_conv_not_possible = 3
        OTHERS                = 4.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SEND_EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM send_email .
***Xstring to binary
  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer     = gv_bin_xstr
    TABLES
      binary_tab = gt_pdf_data.

  TRY.
*     -------- create persistent send request ------------------------
      lo_bcs = cl_bcs=>create_persistent( ).

****  email body
      CONCATENATE 'This eMail is meant for information only. Please DO NOT REPLY.' cl_abap_char_utilities=>newline INTO gv_text.
      APPEND gv_text TO gt_text.
      CLEAR gv_text.
      CLEAR gv_text.
      CONCATENATE cl_abap_char_utilities=>newline gv_text INTO gv_text.
      CONCATENATE cl_abap_char_utilities=>newline gv_text INTO gv_text.
      APPEND ' BLUE CROSS LABORATORIES PRIVATE LTD.' TO gt_text.

****Add the email body content to document
      CLEAR : gv_text, gv_subject.
      CONCATENATE sy-datum+6(2) sy-datum+4(2) sy-datum+0(4) INTO gv_text SEPARATED BY '.'.
      CONCATENATE 'CFA excess/shortage stock status as of date' gv_text INTO gv_subject SEPARATED BY space.
      lo_doc_bcs = cl_document_bcs=>create_document(
                     i_type    = 'RAW'
                     i_text    = gt_text[]
                     i_length  = '12'
                     i_subject = gv_subject ).   "Subject of the Email

***     Add attachment to document and Add document to send request
***The internal table gt_pdf_data[] contains the content of our attachment.

      CALL METHOD lo_doc_bcs->add_attachment
        EXPORTING
          i_attachment_type    = 'PDF'
          i_attachment_size    = gv_bin_filesize
          i_attachment_subject = 'IR13-C'
          i_att_content_hex    = gt_pdf_data.

*     add document to send request
      CALL METHOD lo_bcs->set_document( lo_doc_bcs ).

****    Set Sender
      lo_sender = cl_cam_address_bcs=>create_internet_address( i_address_string = gc_email_sender
                                                               i_address_name = 'CFA Excess/Shortage Stock' ).

      CALL METHOD lo_bcs->set_sender
        EXPORTING
          i_sender = lo_sender.

****    Add recipient (e–mail address)
      lo_recep = cl_cam_address_bcs=>create_internet_address( p_email ).

      "Add recipient with its respective attributes to send request
      CALL METHOD lo_bcs->add_recipient
        EXPORTING
          i_recipient = lo_recep
          i_express   = gc_true.

****    Set Send Immediately
      CALL METHOD lo_bcs->set_send_immediately
        EXPORTING
          i_send_immediately = gc_true.

***Send the Email
      CALL METHOD lo_bcs->send(
        EXPORTING
          i_with_error_screen = gc_true
        RECEIVING
          result              = gv_sent_to_all ).

      IF gv_sent_to_all IS NOT INITIAL.
        COMMIT WORK.
        MESSAGE 'Email sent successfully' TYPE 'S'.
      ENDIF.

    CATCH cx_bcs INTO lo_cx_bcx.
      "Appropriate Exception Handling
      WRITE: 'Exception:', lo_cx_bcx->error_type.
  ENDTRY.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  INCLUDE_TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM include_top_of_page.
  DATA: lt_header TYPE slis_t_listheader,
        lw_header TYPE slis_listheader,
        lv_info   TYPE string,
        lv_name1  TYPE pbtxt.


  lw_header-typ  = 'H'.
  CLEAR lv_info.
  lv_info = 'CFA - EXCESS / SHORTAGE OF STOCK STATUS'.
  lw_header-info = lv_info.
  APPEND lw_header TO lt_header.
  CLEAR lw_header.

  lw_header-typ  = 'S'.
  CLEAR lv_info.
  lv_info = 'RED cell indicates Shortfall.'.
  lw_header-info = lv_info.
  APPEND lw_header TO lt_header.
  CLEAR lw_header.

  lw_header-typ  = 'S'.
  CLEAR lv_info.
  lv_info = 'YELLOW cell indicates Excess stock.'.
  lw_header-info = lv_info.
  APPEND lw_header TO lt_header.
  CLEAR lw_header.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lt_header.
ENDFORM. "INCLUDE_TOP_OF_PAGE
*&---------------------------------------------------------------------*
*&      Form  SET_ALV_COLOR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_alv_color .
  DATA: lv_inv TYPE fkimg.

  IF gt_fdata1[] IS NOT INITIAL.

    CLEAR gw_fdata.
    LOOP AT gt_fdata1 INTO gw_fdata.
      MOVE-CORRESPONDING gw_fdata TO gw_fdata_alv.
      APPEND gw_fdata_alv TO gt_fdata_alv.
      CLEAR gw_fdata.
      CLEAR gw_fdata_alv.
    ENDLOOP.
  ENDIF.
***  Add color to cell based on calculation
  IF gt_fdata_alv[] IS NOT INITIAL.
    SORT gt_fdata_alv BY maktx zshort_nm.
    LOOP AT gt_fdata_alv INTO gw_fdata_alv WHERE mvgr41 NE 'NEP'.
      CLEAR lv_inv.
      lv_inv = gw_fdata_alv-zvalst + gw_fdata_alv-zvalit.
      IF gw_fdata_alv-zvallow IS NOT INITIAL
      AND gw_fdata_alv-zvalhigh IS NOT INITIAL.
        IF lv_inv <= gw_fdata_alv-zvallow.
          gw_cell-fieldname = 'ZVALST' .
          gw_cell-color-col = 6.
          APPEND gw_cell TO gw_fdata_alv-cell.
          gw_cell-fieldname = 'ZVALIT' .
          gw_cell-color-col = 6.
          APPEND gw_cell TO gw_fdata_alv-cell.
        ELSEIF  lv_inv >= gw_fdata_alv-zvalhigh.
          gw_cell-fieldname = 'ZVALST' .
          gw_cell-color-col = 3.
          APPEND gw_cell TO gw_fdata_alv-cell.
          gw_cell-fieldname = 'ZVALIT' .
          gw_cell-color-col = 3.
          APPEND gw_cell TO gw_fdata_alv-cell.
        ENDIF.
      ENDIF.
      MODIFY gt_fdata_alv FROM gw_fdata_alv TRANSPORTING cell.
      CLEAR gw_fdata_alv.
    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_EXCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_excel .
  clear : gt_zcfastkstat[].
**  select * from zcfastockstatus into table gt_zcfastkstat.
  gt_zcfastkstat[] = gt_fdata1[].

  clear gt_matnr[].
  gt_matnr[] = gt_zcfastkstat[].
  sort gt_matnr by maktx mvgr41.
  delete adjacent duplicates from gt_matnr comparing maktx mvgr41.

  PERFORM get_l_fcat.
  PERFORM fill_excel.
  PERFORM disp_excel.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_L_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_l_fcat .

  DATA lv_pos TYPE i.

  lv_pos = 1.
  CLEAR lw_lfldcat.
  lw_lfldcat-fieldname = 'MVGR41'.
  lw_lfldcat-seltext = 'NEPAL'.
  lw_lfldcat-datatype = 'CHAR'.
  lw_lfldcat-intlen = 4.
  lw_lfldcat-col_pos = lv_pos.
  APPEND lw_lfldcat TO lt_lfldcat.

  lv_pos = lv_pos + 1.
  CLEAR lw_lfldcat.
  lw_lfldcat-fieldname = 'MVGR4'.
  lw_lfldcat-seltext = 'GROUP-4'.
  lw_lfldcat-datatype = 'CHAR'.
  lw_lfldcat-intlen = 4.
  lw_lfldcat-col_pos = lv_pos.
  APPEND lw_lfldcat TO lt_lfldcat.

  lv_pos = lv_pos + 1.
  CLEAR lw_lfldcat.
  lw_lfldcat-fieldname = 'MAKTX'.
  lw_lfldcat-seltext = 'PRODUCT'.
  lw_lfldcat-datatype = 'CHAR'.
  lw_lfldcat-intlen = 30.
  lw_lfldcat-col_pos = lv_pos.
  APPEND lw_lfldcat TO lt_lfldcat.

  lv_pos = lv_pos + 1.
  CLEAR lw_lfldcat.
  lw_lfldcat-fieldname = 'BEZEI'.
  lw_lfldcat-seltext = 'PACK'.
  lw_lfldcat-datatype = 'CHAR'.
  lw_lfldcat-intlen = 5.
  lw_lfldcat-col_pos = lv_pos.
  APPEND lw_lfldcat TO lt_lfldcat.

  lv_pos = lv_pos + 1.
  CLEAR lw_lfldcat.
  lw_lfldcat-fieldname = 'TYP'.
  lw_lfldcat-seltext = 'TYPE'.
  lw_lfldcat-datatype = 'CHAR'.
  lw_lfldcat-intlen = 4.
  lw_lfldcat-col_pos = lv_pos.
  APPEND lw_lfldcat TO lt_lfldcat.



  CLEAR gw_plants.
  LOOP AT gt_plants INTO gw_plants WHERE ztype = 'C'.

    lv_pos = lv_pos + 1.
    CLEAR lw_lfldcat.
    lw_lfldcat-fieldname = gw_plants-werks.
    lw_lfldcat-seltext = gw_plants-name1.
    lw_lfldcat-datatype = 'QUAN'.
    lw_lfldcat-intlen = 13.
    lw_lfldcat-decimals = 2.
    lw_lfldcat-col_pos = lv_pos.
    lw_lfldcat-no_zero = 'X'.
    APPEND lw_lfldcat TO lt_lfldcat.
  ENDLOOP.

  lv_pos = lv_pos + 1.
  CLEAR lw_lfldcat.
  lw_lfldcat-fieldname = 'TOTAL'.
  lw_lfldcat-seltext = 'TOTAL'.
  lw_lfldcat-datatype = 'QUAN'.
  lw_lfldcat-intlen = 13.
  lw_lfldcat-decimals = 2.
  lw_lfldcat-col_pos = lv_pos.
  APPEND lw_lfldcat TO lt_lfldcat.

  LOOP AT gt_plants INTO gw_plants WHERE ztype NE 'C'.
    lv_pos = lv_pos + 1.
    CLEAR lw_lfldcat.
    lw_lfldcat-fieldname = gw_plants-werks.
    lw_lfldcat-seltext = gw_plants-name1.
    lw_lfldcat-datatype = 'QUAN'.
    lw_lfldcat-intlen = 13.
    lw_lfldcat-decimals = 2.
    lw_lfldcat-col_pos = lv_pos.
    lw_lfldcat-no_zero = 'X'.
    APPEND lw_lfldcat TO lt_lfldcat.
  ENDLOOP.

  lv_pos = lv_pos + 1.
  CLEAR lw_lfldcat.
  lw_lfldcat-fieldname = 'GTOTAL'.
  lw_lfldcat-seltext = 'GRAND TOTAL'.
  lw_lfldcat-datatype = 'QUAN'.
  lw_lfldcat-intlen = 13.
  lw_lfldcat-decimals = 2.
  lw_lfldcat-col_pos = lv_pos.
  APPEND lw_lfldcat TO lt_lfldcat.


  CALL METHOD cl_alv_table_create=>create_dynamic_table
    EXPORTING
      it_fieldcatalog           = lt_lfldcat
    IMPORTING
      ep_table                  = dyn_tab
    EXCEPTIONS
      generate_subpool_dir_full = 1
      OTHERS                    = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  ASSIGN dyn_tab->* TO <dyn_tab>.

  CREATE DATA dyn_line LIKE LINE OF <dyn_tab>.
  ASSIGN dyn_line->* TO <dyn_wa>.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FILL_EXCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fill_excel .

  DATA : lv_tot_zvalsl  TYPE zzvalsl,
         lv_tot_zvalst  TYPE zzvalst,
         lv_tot_zvalit  TYPE zzvalit,
         lv_tot_zvallms TYPE zzvallms,
         lv_tot_zvalllm TYPE zzvalllm,
         lv_tot_zvallys TYPE zzvallys.

  DATA : lv_gtot_zvalsl  TYPE zzvalsl,
         lv_gtot_zvalst  TYPE zzvalst,
         lv_gtot_zvalit  TYPE zzvalit,
         lv_gtot_zvallms TYPE zzvallms,
         lv_gtot_zvalllm TYPE zzvalllm,
         lv_gtot_zvallys TYPE zzvallys.


  IF gt_zcfastkstat[] IS NOT INITIAL.
    SORT gt_zcfastkstat BY maktx.
    LOOP AT gt_zcfastkstat INTO gw_zcfastkstat WHERE mvgr41 NE 'NEP'.
***      decide for RED/YELLOW color for cell based on calc
      CLEAR gv_sum.
      gv_sum = gw_zcfastkstat-zvalst + gw_zcfastkstat-zvalit.
      IF gw_zcfastkstat-zvallow IS NOT INITIAL
      AND gw_zcfastkstat-zvalhigh IS NOT INITIAL .
        IF gv_sum <= gw_zcfastkstat-zvallow.
          CLEAR gw_zcfastkstat-zshort_nm.
          gw_zcfastkstat-zshort_nm = 'SHORTAGE'.
        ENDIF.

        IF gv_sum >= gw_zcfastkstat-zvalhigh.
          CLEAR gw_zcfastkstat-zshort_nm.
          gw_zcfastkstat-zshort_nm = 'EXCESS'.
        ENDIF.
      ENDIF.
      MODIFY gt_zcfastkstat FROM gw_zcfastkstat TRANSPORTING zshort_nm.
      CLEAR gw_zcfastkstat.
    ENDLOOP.

    SORT gt_zcfastkstat BY maktx.
    SORT gt_matnr BY maktx.
  ENDIF.

*** get data into dyanamic table as per required display format
  CLEAR gw_matnr.
  LOOP AT gt_matnr INTO gw_matnr.

*****************************   for SL  *****************************
    CLEAR gw_zcfastkstat.
    LOOP AT gt_zcfastkstat INTO gw_zcfastkstat WHERE maktx = gw_matnr-maktx and mvgr41 = gw_matnr-mvgr41.

      ASSIGN COMPONENT 'MAKTX' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-maktx.
      ENDIF.

      ASSIGN COMPONENT 'BEZEI' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-bezei.
      ENDIF.

*** get SL - Sales data
      ASSIGN COMPONENT 'TYP' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = 'SL'.
      ENDIF.

      ASSIGN COMPONENT gw_zcfastkstat-werks OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-zvalsl.
      ENDIF.

      ASSIGN COMPONENT 'MVGR4' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-mvgr4.
      ENDIF.

      ASSIGN COMPONENT 'MVGR41' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-mvgr41.
      ENDIF.
*** for total of CFA/fields and grand total i.e.fields + plants
      CLEAR : lv_tot_zvalsl,lv_gtot_zvalsl.
      CLEAR gw_plants.
      READ TABLE gt_plants INTO gw_plants WITH KEY werks = gw_zcfastkstat-werks.
      IF sy-subrc = 0.
        IF gw_plants-ztype = 'C'.
          lv_tot_zvalsl = gw_zcfastkstat-zvalsl.
        ENDIF.
        lv_gtot_zvalsl = gw_zcfastkstat-zvalsl.
      ENDIF.
      ASSIGN COMPONENT 'TOTAL' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = lv_tot_zvalsl.
      ENDIF.
      ASSIGN COMPONENT 'GTOTAL' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = lv_gtot_zvalsl.
      ENDIF.

      COLLECT <dyn_wa> INTO <dyn_tab>.
      CLEAR: <dyn_wa>.
    ENDLOOP.
*****************************   for ST  *****************************
    CLEAR gw_zcfastkstat.
    LOOP AT gt_zcfastkstat INTO gw_zcfastkstat WHERE maktx = gw_matnr-maktx and mvgr41 = gw_matnr-mvgr41.

      ASSIGN COMPONENT 'MAKTX' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-maktx.
      ENDIF.

      ASSIGN COMPONENT 'BEZEI' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-bezei.
      ENDIF.

*** get ST - stock data
      ASSIGN COMPONENT 'TYP' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = 'ST'.
      ENDIF.

      ASSIGN COMPONENT gw_zcfastkstat-werks OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-zvalst.
      ENDIF.

      ASSIGN COMPONENT 'MVGR4' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-mvgr4.
      ENDIF.

      ASSIGN COMPONENT 'MVGR41' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-mvgr41.
      ENDIF.
*** for total of CFA/fields and grand total i.e.fields + plants
      CLEAR :lv_tot_zvalst,lv_gtot_zvalst.
      CLEAR gw_plants.
      READ TABLE gt_plants INTO gw_plants WITH KEY werks = gw_zcfastkstat-werks.
      IF sy-subrc = 0.
        IF gw_plants-ztype = 'C'.
          lv_tot_zvalst = gw_zcfastkstat-zvalst.
        ENDIF.
        lv_gtot_zvalst = gw_zcfastkstat-zvalst.
      ENDIF.

      ASSIGN COMPONENT 'TOTAL' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = lv_tot_zvalst.
      ENDIF.

      ASSIGN COMPONENT 'GTOTAL' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = lv_gtot_zvalst.
      ENDIF.

      COLLECT <dyn_wa> INTO <dyn_tab>.
      CLEAR: <dyn_wa>.
    ENDLOOP.
*****************************   for IT *****************************
    CLEAR gw_zcfastkstat.
    LOOP AT gt_zcfastkstat INTO gw_zcfastkstat WHERE maktx = gw_matnr-maktx and mvgr41 = gw_matnr-mvgr41.

      ASSIGN COMPONENT 'MAKTX' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-maktx.
      ENDIF.

      ASSIGN COMPONENT 'BEZEI' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-bezei.
      ENDIF.

*** IT - get In-transit data
      ASSIGN COMPONENT 'TYP' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = 'IT'.
      ENDIF.

      ASSIGN COMPONENT gw_zcfastkstat-werks OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-zvalit.
      ENDIF.

      ASSIGN COMPONENT 'MVGR4' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-mvgr4.
      ENDIF.

      ASSIGN COMPONENT 'MVGR41' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-mvgr41.
      ENDIF.

*** for total of CFA/fields & grand total i.e.fields + plants
      CLEAR : lv_tot_zvalit,lv_gtot_zvalit.
      CLEAR gw_plants.
      READ TABLE gt_plants INTO gw_plants WITH KEY werks = gw_zcfastkstat-werks.
      IF sy-subrc = 0.
        IF gw_plants-ztype = 'C'.
          lv_tot_zvalit =  gw_zcfastkstat-zvalit.
        ENDIF.
        lv_gtot_zvalit =  gw_zcfastkstat-zvalit.

      ENDIF.

      ASSIGN COMPONENT 'TOTAL' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = lv_tot_zvalit.
      ENDIF.

      ASSIGN COMPONENT 'GTOTAL' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = lv_gtot_zvalit.
      ENDIF.

      COLLECT <dyn_wa> INTO <dyn_tab>.
      CLEAR: <dyn_wa>.
    ENDLOOP.

*****************************   for LMS  *****************************
    CLEAR gw_zcfastkstat.
    LOOP AT gt_zcfastkstat INTO gw_zcfastkstat WHERE maktx = gw_matnr-maktx and mvgr41 = gw_matnr-mvgr41.

      ASSIGN COMPONENT 'MAKTX' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-maktx.
      ENDIF.

      ASSIGN COMPONENT 'BEZEI' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-bezei.
      ENDIF.

*** get LMS - Last month sale data
      ASSIGN COMPONENT 'TYP' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = 'LMS'.
      ENDIF.

      ASSIGN COMPONENT gw_zcfastkstat-werks OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-zvallms.
      ENDIF.

      ASSIGN COMPONENT 'MVGR4' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-mvgr4.
      ENDIF.

      ASSIGN COMPONENT 'MVGR41' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-mvgr41.
      ENDIF.
*** for total of CFA/fields & grand total i.e.fields + plants
      CLEAR : lv_tot_zvallms,lv_gtot_zvallms.
      CLEAR gw_plants.
      READ TABLE gt_plants INTO gw_plants WITH KEY werks = gw_zcfastkstat-werks.
      IF sy-subrc = 0.
        IF   gw_plants-ztype = 'C'.
          lv_tot_zvallms =  gw_zcfastkstat-zvallms.
        ENDIF.
        lv_gtot_zvallms =  gw_zcfastkstat-zvallms.

      ENDIF.

      ASSIGN COMPONENT 'TOTAL' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = lv_tot_zvallms.
      ENDIF.

      ASSIGN COMPONENT 'GTOTAL' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = lv_gtot_zvallms.
      ENDIF.


      COLLECT <dyn_wa> INTO <dyn_tab>.
      CLEAR: <dyn_wa>.
    ENDLOOP.
*****************************   for LLM  *****************************
    CLEAR gw_zcfastkstat.
    LOOP AT gt_zcfastkstat INTO gw_zcfastkstat WHERE maktx = gw_matnr-maktx and mvgr41 = gw_matnr-mvgr41.

      ASSIGN COMPONENT 'MAKTX' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-maktx.
      ENDIF.

      ASSIGN COMPONENT 'BEZEI' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-bezei.
      ENDIF.

*** get LLM - last to last month sale data
      ASSIGN COMPONENT 'TYP' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = 'LLM'.
      ENDIF.

      ASSIGN COMPONENT gw_zcfastkstat-werks OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-zvalllm.
      ENDIF.

      ASSIGN COMPONENT 'MVGR4' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-mvgr4.
      ENDIF.

      ASSIGN COMPONENT 'MVGR41' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-mvgr41.
      ENDIF.
*** for total of CFA/fields & grand total i.e.fields + plants
      CLEAR : lv_tot_zvalllm,lv_gtot_zvalllm.
      CLEAR gw_plants.
      READ TABLE gt_plants INTO gw_plants WITH KEY werks = gw_zcfastkstat-werks.

      IF sy-subrc = 0.
        IF gw_plants-ztype = 'C'.
          lv_tot_zvalllm =  gw_zcfastkstat-zvalllm.
        ENDIF.
        lv_gtot_zvalllm =  gw_zcfastkstat-zvalllm.
      ENDIF.

      ASSIGN COMPONENT 'TOTAL' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = lv_tot_zvalllm.
      ENDIF.

      ASSIGN COMPONENT 'GTOTAL' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = lv_gtot_zvalllm.
      ENDIF.

      COLLECT <dyn_wa> INTO <dyn_tab>.
      CLEAR: <dyn_wa>.
    ENDLOOP.
*****************************   for LYS  *****************************
    CLEAR gw_zcfastkstat.
    LOOP AT gt_zcfastkstat INTO gw_zcfastkstat WHERE maktx = gw_matnr-maktx and mvgr41 = gw_matnr-mvgr41.

      ASSIGN COMPONENT 'MAKTX' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-maktx.
      ENDIF.

      ASSIGN COMPONENT 'BEZEI' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-bezei.
      ENDIF.

*** get LYS - last year sale data
      ASSIGN COMPONENT 'TYP' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = 'LYS'.
      ENDIF.

      ASSIGN COMPONENT gw_zcfastkstat-werks OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-zvallys.
      ENDIF.

      ASSIGN COMPONENT 'MVGR4' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-mvgr4.
      ENDIF.

      ASSIGN COMPONENT 'MVGR41' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = gw_zcfastkstat-mvgr41.
      ENDIF.

*** for total of CFA/fields & grand total i.e.fields + plants
      CLEAR :lv_tot_zvallys,lv_gtot_zvallys.
      CLEAR gw_plants.
      READ TABLE gt_plants INTO gw_plants WITH KEY werks = gw_zcfastkstat-werks.
      IF sy-subrc = 0.
        IF gw_plants-ztype = 'C'.
          lv_tot_zvallys =  gw_zcfastkstat-zvallys.
        ENDIF.
        lv_gtot_zvallys =  gw_zcfastkstat-zvallys.

      ENDIF.

      ASSIGN COMPONENT 'TOTAL' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = lv_tot_zvallys.
      ENDIF.

      ASSIGN COMPONENT 'GTOTAL' OF STRUCTURE <dyn_wa> TO <fs>.
      IF sy-subrc = 0.
        <fs> = lv_gtot_zvallys.
      ENDIF.

      COLLECT <dyn_wa> INTO <dyn_tab>.
      CLEAR: <dyn_wa>.

    ENDLOOP.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISP_EXCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM disp_excel .
  DATA : lv_lines         TYPE i,
         lv_rows          TYPE i,
         lv_complete_path TYPE char256,
         lo_column   type  ole2_object.


  LOOP AT lt_lfldcat INTO lw_lfldcat.
    gs_fieldcat-field = lw_lfldcat-fieldname.
    gs_fieldcat-text = lw_lfldcat-seltext.
    gs_fieldcat-width = lw_lfldcat-intlen.
    APPEND gs_fieldcat TO gt_fieldcat.
    CLEAR gs_fieldcat.
  ENDLOOP.

* Create the document;
  PERFORM create_document.


* Print the data:
  PERFORM print_data_fieldcat USING <dyn_tab> 1 1 'X'.
  DESCRIBE TABLE gt_fieldcat LINES lv_lines.
  DESCRIBE TABLE <dyn_tab> LINES lv_rows.
  lv_rows = lv_rows + 1.

* Bold the header:
  PERFORM change_format USING 1 1 1 lv_lines   "Range of cells
  0 space   "Font Colour
  0 space   "Background Colour
  12  'X'   "Size
  1   'X'.  "Bold

*** Bold the TYPE column and rows:
  CLEAR lw_lfldcat.
  READ TABLE lt_lfldcat INTO lw_lfldcat WITH KEY fieldname = 'TYP'.
  IF sy-subrc = 0.
    PERFORM change_format USING 1 lw_lfldcat-col_pos lv_rows lw_lfldcat-col_pos   "Range of cells
    0 space   "Font Colour
    0 space   "Background Colour
    0 space   "Size
    1   'X'.  "Bold
  ENDIF.

*** Bold the TOTAL column and rows:
  CLEAR lw_lfldcat.
  READ TABLE lt_lfldcat INTO lw_lfldcat WITH KEY fieldname = 'TOTAL'.
  IF sy-subrc = 0.
    PERFORM change_format USING 1 lw_lfldcat-col_pos lv_rows lw_lfldcat-col_pos   "Range of cells
    0 space   "Font Colour
    0 space   "Background Colour
    12  'X'   "Size
    1   'X'.  "Bold
  ENDIF.

*** Bold the GRAND TOTAL column and rows:
  CLEAR lw_lfldcat.
  READ TABLE lt_lfldcat INTO lw_lfldcat WITH KEY fieldname = 'GTOTAL'.
  IF sy-subrc = 0.
    PERFORM change_format USING 1 lw_lfldcat-col_pos lv_rows lw_lfldcat-col_pos   "Range of cells
    0 space   "Font Colour
    0 space   "Background Colour
    12  'X'   "Size
    1   'X'.  "Bold
  ENDIF.
*** Change the colour of the header.
  PERFORM set_soft_colour USING 1 1 1 lv_lines         "range of cells
  c_theme_col_white 'X'                "font colour
  0 space                "font tintandshade
  c_theme_col_black 'X'  "background colour
  0 space.            "bkg col. tintandshade

** Add borders
  PERFORM add_border USING 1 1 lv_rows lv_lines.

*** for cell color based on calculations
  IF <dyn_tab> IS NOT INITIAL.

    CLEAR : gv_rowi,gv_rowe,gv_coli,gv_cole.
    CLEAR: gw_fdata.
    LOOP AT <dyn_tab> ASSIGNING <dyn_wa> .
      gv_rowi = gv_rowe = sy-tabix + 1.

      ASSIGN COMPONENT 'MAKTX' OF STRUCTURE <dyn_wa> TO <fs_maktx>.
      IF sy-subrc = 0.
        ASSIGN COMPONENT 'MVGR41' OF STRUCTURE <dyn_wa> TO <fs_mvgr41>.
        IF sy-subrc = 0.
          ASSIGN COMPONENT 'TYP' OF STRUCTURE <dyn_wa> TO <fs>.
          IF sy-subrc = 0 AND <fs> = 'ST'.
            CLEAR gw_zcfastkstat.
            LOOP AT gt_zcfastkstat INTO gw_zcfastkstat WHERE maktx = <fs_maktx>.

              IF gw_zcfastkstat-zshort_nm = 'SHORTAGE' AND <fs> = 'ST' AND <fs_mvgr41> NE 'NEP'.
                CLEAR lw_lfldcat.
                READ TABLE lt_lfldcat INTO lw_lfldcat WITH KEY fieldname = gw_zcfastkstat-werks.
                IF sy-subrc = 0.
                  gv_coli = lw_lfldcat-col_pos.
                  gv_cole = lw_lfldcat-col_pos.
                  gv_rowi = gv_rowi.
                  gv_rowe = gv_rowe.
                ENDIF.
***  RED color cell
                PERFORM change_format USING gv_rowi gv_coli gv_rowe gv_cole         "range of cells
                      0 space               "font colour
                      c_col_red 'X'  "background colour
                      12 'X'        "font size
                      1 'X'.       "font bold

***RED color to TYPE col for ST value
                PERFORM change_format USING gv_rowi 5 gv_rowe 5   "Range of cells
                      0 space               "font colour
                      c_col_red 'X'  "background colour
                      12 'X'        "font size
                      1 'X'.       "font bold
              ENDIF.

              IF gw_zcfastkstat-zshort_nm = 'EXCESS' AND <fs> = 'ST' AND <fs_mvgr41> NE 'NEP'.
                CLEAR lw_lfldcat.
                READ TABLE lt_lfldcat INTO lw_lfldcat WITH KEY fieldname = gw_zcfastkstat-werks.
                IF sy-subrc = 0.
                  gv_coli = lw_lfldcat-col_pos.
                  gv_cole = lw_lfldcat-col_pos.
                  gv_rowi = gv_rowi.
                  gv_rowe = gv_rowe.
                ENDIF.
*** YELLOW color cell
                PERFORM change_format USING gv_rowi gv_coli gv_rowe gv_cole         "range of cells
                      0 space                "font colour
                      c_col_yellow 'X'       "background colour
                      12 'X'        "font size
                      1 'X'.       "font bold
***YELLOW color to TYPE col for ST value
                PERFORM change_format USING gv_rowi 5 gv_rowe 5   "Range of cells
                      0 space                "font colour
                      c_col_yellow 'X'       "background colour
                      12 'X'        "font size
                      1 'X'.       "font bold
              ENDIF.

            ENDLOOP.
          ELSE.
            IF <fs> = 'SL'.
* Bold the header:
              PERFORM change_format USING gv_rowi 3 gv_rowe 3         "range of cells
              0 space   "Font Colour
              0 space   "Background Colour
              12  'X'   "Size
              1   'X'.  "Bold
*** Change the colour of the MATERIAL column
              PERFORM set_soft_colour USING gv_rowi 3 gv_rowe 3         "range of cells
                    c_theme_col_white 'X'                "font colour
                    0 space                "font tintandshade
                    c_theme_col_black 'X'  "background colour
**                    0 space.            "bkg col. tintandshade
                     '0.49' 'X'.            "bkg col. tintandshade

            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.

** to set cursor to first column after excel opening
* Select the Column
  call method of go_worksheet 'Columns' = lo_column
  exporting
  #1 = 1.
  call method of lo_column 'select'.

*** Change the name of the worksheet:
  SET PROPERTY OF go_worksheet 'Name' = 'IR13-C'.

*** Return to the worksheet 1
  CALL METHOD OF go_application 'Worksheets' = go_worksheet
  EXPORTING #1 = 1.
  CALL METHOD OF go_worksheet 'Activate'.


*** File name
  CONCATENATE p_path '\IR13-C'  '.xls' INTO lv_complete_path.

*** Save the document
  CALL METHOD OF go_workbook 'SAVEAS'
    EXPORTING
      #1 = lv_complete_path.
  IF sy-subrc EQ 0.
    MESSAGE 'file downloaded successfully' TYPE 'S'.
  ELSE.
    MESSAGE 'error downloading the file' TYPE 'E'.
  ENDIF.


*** Close the document and free memory
  PERFORM close_document.

ENDFORM.
