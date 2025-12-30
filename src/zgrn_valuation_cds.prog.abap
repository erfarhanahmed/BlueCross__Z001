*&---------------------------------------------------------------------*
*& Report ZGRN_VALUATION_CDS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgrn_valuation_cds.

*-----------------------------------------------------------------------
* Target: S/4HANA 2023  |  Data source: CDS view entity ZI_GRNItemEnriched
* Notes:
*  - All TYPES/DATA before selection screen (per review point #3)
*  - Class definition right after selection screen (per review point #2)
*  - Alias ~ used in Open SQL (per review point #1)
*  - No text element changes in INITIALIZATION (per review point #4)
*  - SALV exceptions caught (per review point #5)
*-----------------------------------------------------------------------
* Baseline fields and behavior were derived from your ECC report.
*-----------------------------------------------------------------------

"--- DDIC anchors for typing only
TABLES: mkpf, mseg, ekko, ekpo, lfa1, mcha, qals, qave, ekkn, t161t.  "types only

"--- Types (aligned with ZI_GRNItemEnriched’s projection & your CDS rectifications)
TYPES: BEGIN OF ty_out,
         mblnr             TYPE mseg-mblnr,
         mjahr             TYPE mseg-mjahr,
         budat             TYPE mkpf-budat,
         bldat             TYPE mkpf-bldat,
         xblnr             TYPE mkpf-xblnr,
         tcode             TYPE c LENGTH 20,       "from CDS alias
         werks             TYPE mseg-werks,
         matnr             TYPE mseg-matnr,
         materialtext      TYPE makt-maktx,
         bwart             TYPE mseg-bwart,
         charg             TYPE mseg-charg,
         quantity          TYPE mseg-erfmg,       "paired with Meins
         meins             TYPE mseg-meins,
         amountlocal       TYPE mseg-dmbtr,       "paired with CurrencyLocal
         currencylocal     TYPE t001-waers,
         ebeln             TYPE ekko-ebeln,
         ebelp             TYPE ekpo-ebelp,
         bsart             TYPE ekko-bsart,
         potypetext        TYPE t161t-batxt,
         podocdate         TYPE ekko-bedat,
         poitemchangedate  TYPE ekpo-aedat,
         lifnr             TYPE lfa1-lifnr,
         vendorname        TYPE lfa1-name1,
         vendorcity        TYPE lfa1-ort01,
         vendorbatch       TYPE mcha-licha,
         batchmfgdate      TYPE mcha-hsdat,
         batchexpdate      TYPE mcha-vfdat,
         daysmfgtoreceipt  TYPE i,
         inspectionlot     TYPE qals-prueflos,
         inspectionstatus  TYPE c LENGTH 20,
         usagedecisiondate TYPE qave-vdatum,
         costcenter        TYPE ekkn-kostl,
         sgtxt             TYPE mseg-sgtxt,
       END OF ty_out.

TYPES: BEGIN OF ty_manu, "A2 view (Material, Vendor, Manufacturer), qty summarized
         matnr        TYPE mseg-matnr,
         materialtext TYPE makt-maktx,
         lifnr        TYPE lfa1-lifnr,
         vendorname   TYPE lfa1-name1,
         manufacturer TYPE mseg-sgtxt,   "legacy used SGTXT as manufacturer free-text
         quantity     TYPE mseg-erfmg,
       END OF ty_manu.

"--- Data
DATA: gt_out  TYPE STANDARD TABLE OF ty_out  WITH EMPTY KEY,
      gt_manu TYPE STANDARD TABLE OF ty_manu WITH EMPTY KEY.

"=========================
" Selection screen
"=========================
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-t01.
SELECT-OPTIONS: s_date FOR mkpf-budat OBLIGATORY,
                s_mat  FOR mseg-matnr,
                s_mov  FOR mseg-bwart,
                s_lif  FOR mseg-lifnr,
                s_bsrt FOR ekko-bsart.
PARAMETERS:     p_werks TYPE mseg-werks OBLIGATORY,
                p_year  TYPE mkpf-mjahr OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-t02.
PARAMETERS: p_a1 RADIOBUTTON GROUP rg DEFAULT 'X',   "All Details
            p_a2 RADIOBUTTON GROUP rg.               "Manufacturer view
SELECTION-SCREEN END OF BLOCK b2.

"=========================
" Local class definition placed right after selection-screen (per review #2)
"=========================
CLASS lcl_events DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS on_link_click FOR EVENT link_click OF cl_salv_events_table
      IMPORTING row column.
ENDCLASS.

"=========================
" START-OF-SELECTION
"=========================
START-OF-SELECTION.

  " Example plant-level authorization (adapt to your concept)
  AUTHORITY-CHECK OBJECT 'M_MATE_WRK' ID 'WERKS' FIELD p_werks.
  IF sy-subrc <> 0.
    MESSAGE e398(00) WITH 'Not authorized for Plant' p_werks.
  ENDIF.

  " Pull data from CDS view entity; alias-qualified fields with '~' (per review #1)
  SELECT
      e~mblnr,
      e~mjahr,
      e~budat,
      e~bldat,
      e~xblnr,
      e~tcode,
      e~werks,
      e~matnr,
      e~materialtext,
      e~bwart,
      e~charg,
      e~quantity,
      e~meins,
      e~amountlocal,
      e~currencylocal,
      e~ebeln,
      e~ebelp,
      e~bsart,
      e~potypetext,
      e~podocdate,
      e~poitemchangedate,
      e~lifnr,
      e~vendorname,
      e~vendorcity,
      e~vendorbatch,
      e~batchmfgdate,
      e~batchexpdate,
      e~daysmfgtoreceipt,
      e~inspectionlot,
      e~inspectionstatus,
      e~usagedecisiondate,
      e~costcenter,
      e~sgtxt
    FROM zi_grnitemenriched AS e
    INTO CORRESPONDING FIELDS OF TABLE @gt_out
    WHERE e~budat IN @s_date
      AND e~werks  =  @p_werks
      AND e~mjahr  =  @p_year
      AND e~matnr  IN @s_mat
      AND e~bwart  IN @s_mov
      AND e~lifnr  IN @s_lif
      AND e~bsart  IN @s_bsrt.

  IF sy-subrc <> 0 OR gt_out IS INITIAL.
    MESSAGE 'No records found for selection.' TYPE 'I'.
    LEAVE PROGRAM.
  ENDIF.

  SORT gt_out BY budat mblnr mjahr ebeln ebelp.

  IF p_a2 = 'X'.
    PERFORM build_manu.
    PERFORM display_manu.
  ELSE.
    PERFORM display_all.
  ENDIF.

"=========================
" Forms
"=========================
FORM build_manu.
  DATA: ls_key TYPE ty_manu.
  FIELD-SYMBOLS <m> TYPE ty_manu.

  LOOP AT gt_out ASSIGNING FIELD-SYMBOL(<r>).
    ls_key-matnr        = <r>-matnr.
    ls_key-materialtext = <r>-materialtext.
    ls_key-lifnr        = <r>-lifnr.
    ls_key-vendorname   = <r>-vendorname.
    ls_key-manufacturer = <r>-sgtxt.

    READ TABLE gt_manu ASSIGNING <m>
         WITH KEY matnr        = ls_key-matnr
                  lifnr        = ls_key-lifnr
                  manufacturer = ls_key-manufacturer.
    IF sy-subrc = 0.
      <m>-quantity = <m>-quantity + <r>-quantity.
    ELSE.
      ls_key-quantity = <r>-quantity.
      APPEND ls_key TO gt_manu.
    ENDIF.
  ENDLOOP.

  SORT gt_manu BY matnr lifnr manufacturer.
ENDFORM.

FORM display_all.
  DATA: lo_alv    TYPE REF TO cl_salv_table,
        lo_cols   TYPE REF TO cl_salv_columns_table,
        lo_col    TYPE REF TO cl_salv_column_table,
        lo_events TYPE REF TO cl_salv_events_table,
        lo_hdlr   TYPE REF TO lcl_events.

  TRY.
      cl_salv_table=>factory(
        IMPORTING r_salv_table = lo_alv
        CHANGING  t_table      = gt_out ).

      lo_cols = lo_alv->get_columns( ).

      " Hotspots (MBLNR / LIFNR / EBELN); handle cx_salv_not_found per review #5
      lo_col = CAST cl_salv_column_table( lo_cols->get_column( 'MBLNR' ) ).
      lo_col->set_cell_type( if_salv_c_cell_type=>hotspot ).

      lo_col = CAST cl_salv_column_table( lo_cols->get_column( 'LIFNR' ) ).
      lo_col->set_cell_type( if_salv_c_cell_type=>hotspot ).

      lo_col = CAST cl_salv_column_table( lo_cols->get_column( 'EBELN' ) ).
      lo_col->set_cell_type( if_salv_c_cell_type=>hotspot ).

      lo_alv->get_display_settings( )->set_striped_pattern( abap_true ).
      lo_alv->get_functions( )->set_all( abap_true ).

      lo_events = lo_alv->get_event( ).
      CREATE OBJECT lo_hdlr.
      SET HANDLER lo_hdlr->on_link_click FOR lo_events.

      lo_alv->display( ).

    CATCH cx_salv_not_found cx_salv_msg INTO DATA(lx_salv).
      MESSAGE lx_salv->get_text( ) TYPE 'I'.
  ENDTRY.
ENDFORM.

FORM display_manu.
  DATA: lo_alv    TYPE REF TO cl_salv_table,
        lo_cols   TYPE REF TO cl_salv_columns_table,
        lo_col    TYPE REF TO cl_salv_column_table,
        lo_events TYPE REF TO cl_salv_events_table,
        lo_hdlr   TYPE REF TO lcl_events.

  TRY.
      cl_salv_table=>factory(
        IMPORTING r_salv_table = lo_alv
        CHANGING  t_table      = gt_manu ).

      lo_cols = lo_alv->get_columns( ).

      " Hotspot only on vendor for A2
      lo_col = CAST cl_salv_column_table( lo_cols->get_column( 'LIFNR' ) ).
      lo_col->set_cell_type( if_salv_c_cell_type=>hotspot ).

      lo_alv->get_display_settings( )->set_striped_pattern( abap_true ).
      lo_alv->get_functions( )->set_all( abap_true ).

      lo_events = lo_alv->get_event( ).
      CREATE OBJECT lo_hdlr.
      SET HANDLER lo_hdlr->on_link_click FOR lo_events.

      lo_alv->display( ).

    CATCH cx_salv_not_found cx_salv_msg INTO DATA(lx_salv2).
      MESSAGE lx_salv2->get_text( ) TYPE 'I'.
  ENDTRY.
ENDFORM.

"=========================
" Local class implementation
"=========================
CLASS lcl_events IMPLEMENTATION.
  METHOD on_link_click.
    DATA lv_col TYPE lvc_fname.
    lv_col = column.

    IF p_a2 = 'X'. " Manufacturer view
      DATA ls_manu TYPE ty_manu.
      READ TABLE gt_manu INTO ls_manu INDEX row.
      CHECK sy-subrc = 0.
      IF lv_col = 'LIFNR'.
        SET PARAMETER ID 'LIF' FIELD ls_manu-lifnr.
        CALL TRANSACTION 'MK03' AND SKIP FIRST SCREEN.
      ENDIF.
      RETURN.
    ENDIF.

    DATA ls_out TYPE ty_out.
    READ TABLE gt_out INTO ls_out INDEX row.
    CHECK sy-subrc = 0.

    CASE lv_col.
      WHEN 'MBLNR'.
        SET PARAMETER ID 'MBN' FIELD ls_out-mblnr.
        CALL TRANSACTION 'MIGO' AND SKIP FIRST SCREEN.
      WHEN 'LIFNR'.
        SET PARAMETER ID 'LIF' FIELD ls_out-lifnr.
        CALL TRANSACTION 'MK03' AND SKIP FIRST SCREEN.
      WHEN 'EBELN'.
        SET PARAMETER ID 'BES' FIELD ls_out-ebeln.
        CALL TRANSACTION 'ME23N' AND SKIP FIRST SCREEN.
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
