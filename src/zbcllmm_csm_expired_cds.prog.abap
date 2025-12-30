*&---------------------------------------------------------------------*
*& Report ZBCLLMM_CSM_EXPIRED_CDS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbcllmm_csm_expired_cds.

TABLES: mara.

PARAMETERS: p_werks TYPE werks_d OBLIGATORY,
            p_from  TYPE sy-datum OBLIGATORY,
            p_to    TYPE sy-datum OBLIGATORY.
SELECT-OPTIONS: s_matnr FOR mara-matnr.

PARAMETERS: r1 RADIOBUTTON GROUP g1 DEFAULT 'X',
            r2 RADIOBUTTON GROUP g1.
PARAMETERS: p_tstrun  AS CHECKBOX DEFAULT abap_true.

TYPES: BEGIN OF ty_row,
         material     TYPE matnr,
         materialtext TYPE maktx,
         plant        TYPE werks_d,
         plantname    TYPE t001w-name1,
         sloc         TYPE lgort_d,
         batch        TYPE charg_d,
         qtycsm       TYPE mchb-cspem,
         baseuom      TYPE meins,
         mfgdate      TYPE hsdat,
         expirydate   TYPE vfdat,
         duedate      TYPE dats,
         isexpired    TYPE abap_boolean,      " <- corrected
         pricectrl    TYPE vprsv,
         rate         TYPE p LENGTH 15 DECIMALS 6,
         value        TYPE p LENGTH 15 DECIMALS 2,
         currency     TYPE waers,
         mattype      TYPE mtart,
       END OF ty_row.
DATA: gt_rows TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

START-OF-SELECTION.
  SELECT *
    FROM zc_csm_due_batches( p_werks     = @p_werks,
                             p_date_from = @p_from,
                             p_date_to   = @p_to )
    INTO CORRESPONDING FIELDS OF TABLE @gt_rows
    WHERE material IN @s_matnr.

  IF gt_rows IS INITIAL.
    MESSAGE 'No CSM batches found for selection' TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  IF r1 = abap_true.
    PERFORM display_salv.
  ELSE.
    PERFORM post_scrapping.
  ENDIF.

*--------------------------------------------------------------------
FORM display_salv.
  DATA lo_alv TYPE REF TO cl_salv_table.
  TRY.
      cl_salv_table=>factory(
        IMPORTING r_salv_table = lo_alv
        CHANGING  t_table      = gt_rows
      ).
      lo_alv->get_display_settings( )->set_list_header(
        |CSM Due-for-Destruction (Plant { p_werks }, { p_from }–{ p_to })|
      ).
      lo_alv->get_display_settings( )->set_striped_pattern( abap_true ).
      lo_alv->get_columns( )->set_optimize( abap_true ).
      lo_alv->display( ).

    CATCH cx_salv_msg INTO DATA(ls_msg).
  ENDTRY.
ENDFORM.

*--------------------------------------------------------------------
FORM post_scrapping.
  DATA lt_post TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.
*  lt_post = FILTER #( gt_rows WHERE isexpired = abap_true ). " only expired
  lt_post = VALUE #( FOR ls_row IN gt_rows WHERE ( isexpired = abap_true ) ( ls_row ) ). " only expired
  IF lt_post IS INITIAL.
    MESSAGE 'Nothing to post (no expired rows in range).' TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  DATA: lv_cc   TYPE kostl,
        lv_gl   TYPE hkont,
        lt_ret  TYPE TABLE OF bapiret2,
        ls_head TYPE bapi2017_gm_head_01,
        lt_item TYPE TABLE OF bapi2017_gm_item_create,
        ls_item TYPE bapi2017_gm_item_create.

  PERFORM read_controls USING p_werks CHANGING lv_cc lv_gl.

  ls_head-pstng_date = sy-datum.
  ls_head-doc_date   = sy-datum.
  ls_head-pr_uname   = sy-uname.

  DATA(ls_code) = VALUE bapi2017_gm_code( gm_code = '03' ).

  LOOP AT lt_post ASSIGNING FIELD-SYMBOL(<r>).
    CLEAR ls_item.
    ls_item-material  = <r>-material.
    ls_item-plant     = <r>-plant.
    ls_item-stge_loc  = <r>-sloc.
    ls_item-batch     = <r>-batch.
    ls_item-move_type = '555'.
    ls_item-entry_qnt = <r>-qtycsm.
    ls_item-entry_uom = <r>-baseuom.
    IF lv_cc IS NOT INITIAL.
      ls_item-costcenter = lv_cc.
    ENDIF.
    IF lv_gl IS NOT INITIAL.
      ls_item-gl_account = lv_gl.
    ENDIF.
    APPEND ls_item TO lt_item.
  ENDLOOP.

  CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
    EXPORTING
      goodsmvt_header = ls_head
      goodsmvt_code   = ls_code
      testrun         = COND bapi2017_gm_gen-testrun( WHEN p_tstrun = abap_true THEN 'X' ELSE '' )
    TABLES
      goodsmvt_item   = lt_item
      return          = lt_ret.

  DATA(lv_has_err) = xsdbool(
                       line_exists( lt_ret[ type = 'E' ] )
                    OR line_exists( lt_ret[ type = 'A' ] ) ).

  IF lv_has_err = abap_true.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    PERFORM show_bapi_messages USING lt_ret.
    MESSAGE 'Posting failed. See messages.' TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' EXPORTING wait = abap_true.
  PERFORM show_bapi_messages USING lt_ret.
  MESSAGE |Posted { lines( lt_item ) } item(s).| TYPE 'S'.
ENDFORM.

*--------------------------------------------------------------------
FORM read_controls  USING    iv_werks TYPE werks_d
                    CHANGING ev_kostl TYPE kostl
                             ev_hkont TYPE hkont.
  DATA: lt_tvar TYPE TABLE OF tvarv, ls_tvar TYPE tvarv.
  DATA: lv_name TYPE rvari_vnam.

  CLEAR: ev_kostl, ev_hkont.
  lv_name = |ZCSM_CC_{ iv_werks }|.

  SELECT * FROM tvarv INTO TABLE @lt_tvar
    WHERE name = @lv_name AND type = 'P'.
  IF sy-subrc = 0.
    READ TABLE lt_tvar INTO ls_tvar INDEX 1.
    ev_kostl = ls_tvar-low.
  ENDIF.

  SELECT * FROM tvarv INTO TABLE lt_tvar
    WHERE name = 'ZCSM_GL' AND type = 'P'.
  IF sy-subrc = 0.
    READ TABLE lt_tvar INTO ls_tvar INDEX 1.
    ev_hkont = ls_tvar-low.
  ENDIF.
ENDFORM.

*--------------------------------------------------------------------
FORM show_bapi_messages USING it_ret TYPE STANDARD TABLE.
  DATA ls TYPE bapiret2.
  LOOP AT it_ret INTO ls.
    MESSAGE ID ls-id TYPE 'S' NUMBER ls-number
      WITH ls-message_v1 ls-message_v2 ls-message_v3 ls-message_v4
      DISPLAY LIKE ls-type.
  ENDLOOP.
ENDFORM.
