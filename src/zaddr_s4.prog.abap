*&---------------------------------------------------------------------*
*& Report ZADDR_S4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zaddr_s4.

TABLES: sscrfields.
DATA: gv_lifnr TYPE lfa1-lifnr.

PARAMETERS: p_bukrs TYPE bukrs OBLIGATORY DEFAULT 'BCLL'.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
  PARAMETERS: r1 RADIOBUTTON GROUP g1 DEFAULT 'X',
              r2 RADIOBUTTON GROUP g1.
  SELECT-OPTIONS: s_lifnr FOR gv_lifnr.
SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.
  " keep same semantics as ECC groups
  IF r1 = abap_true.
    APPEND VALUE #( sign = 'I' option = 'BT' low = '0000010000' high = '0000029999' ) TO s_lifnr.
  ELSEIF r2 = abap_true.
    APPEND VALUE #( sign = 'I' option = 'BT' low = '0000100000' high = '0000199999' ) TO s_lifnr.
  ENDIF.

START-OF-SELECTION.
  "IF_SALV_GUI_TABLE_IDA
  DATA(lo_alv) = cl_salv_gui_table_ida=>create_for_cds_view(
                    iv_cds_view_name = 'ZI_SUPPLIEROVERVIEW' ).

  " pass CDS parameter
  lo_alv->set_view_parameters( VALUE #( ( name = 'P_COMPANYCODE' value = p_bukrs ) ) ).

  "Filters: batch + date + billing document type set per mode
  DATA(lo_ranges) = NEW cl_salv_range_tab_collector( ).

  lo_ranges->add_ranges_for_name(
            iv_name   = 'SUPPLIER'
            it_ranges = s_lifnr[] ).
*  " apply vendor filters (no client-side slicing)
*  lo_alv->add_selection_conditions(
*    VALUE if_salv_gui_types_ida=>yt_selparam(
*      ( name  = 'SUPPLIER' sign = 'I' option = 'CP' low = COND lifnr( WHEN s_lifnr[] IS INITIAL THEN '%' ELSE '' ) )
*    ) ).

  lo_ranges->get_collected_ranges( IMPORTING et_named_ranges = DATA(it_ranges) ).

*  " translate ABAP select-options to IDA ranges
  lo_alv->set_select_options( it_ranges ).

*  lo_alv->set_select_options( it_ranges = cl_salv_ida_range=>from_range_tab( s_lifnr ) ).

  " Optimize columns and title
  lo_alv->fullscreen( )->display( ).
