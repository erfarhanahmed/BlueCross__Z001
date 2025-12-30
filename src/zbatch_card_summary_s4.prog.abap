*&---------------------------------------------------------------------*
*& Report ZBATCH_CARD_SUMMARY_S4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbatch_card_summary_s4.

PARAMETERS: batch TYPE vbrp-charg OBLIGATORY.
SELECT-OPTIONS: s_date FOR sy-datum.
PARAMETERS: r1 RADIOBUTTON GROUP r1 DEFAULT 'X',  "Transfer
            r2 RADIOBUTTON GROUP r1.              "Sale
PARAMETERS: p_max TYPE i DEFAULT 500.

INITIALIZATION.
  IF s_date[] IS INITIAL.
    APPEND VALUE #( sign = 'I' option = 'EQ' low = sy-datum ) TO s_date.
  ENDIF.

START-OF-SELECTION.

  "=== 1) Main list (identical columns to ECC itab1) ===
  DATA(lo_alv) = cl_salv_gui_table_ida=>create_for_cds_view( 'ZI_BATCHCARD_BILLING' ).

  "Filters: batch + date + billing document type set per mode
  DATA(lo_ranges) = NEW cl_salv_range_tab_collector( ).

  lo_ranges->add_ranges_for_name(
    iv_name   = 'CHARG'
    it_ranges = VALUE rseloption( ( sign = 'I' option = 'EQ' low = batch ) ) ).

  lo_ranges->add_ranges_for_name(
    iv_name   = 'BILLINGDOCUMENTDATE'
    it_ranges = s_date[] ).

*  DATA lt_types TYPE rseloption_t.
  DATA lt_types TYPE rseloption.
  IF r1 = abap_true.
    "Transfer: ZF8, ZJSP  (match ECC)
    APPEND VALUE #( sign = 'I' option = 'EQ' low = 'ZF8' )  TO lt_types.
    APPEND VALUE #( sign = 'I' option = 'EQ' low = 'ZJSP' ) TO lt_types.
  ELSE.
    "Sale: ZCDF, ZBDF (match ECC)
    APPEND VALUE #( sign = 'I' option = 'EQ' low = 'ZCDF' ) TO lt_types.
    APPEND VALUE #( sign = 'I' option = 'EQ' low = 'ZBDF' ) TO lt_types.
  ENDIF.

  lo_ranges->add_ranges_for_name(
    iv_name   = 'BILLINGDOCUMENTTYPE'
    it_ranges = lt_types ).

  lo_ranges->get_collected_ranges( IMPORTING et_named_ranges = DATA(it_ranges) ).
  lo_alv->set_select_options( it_ranges ).
  lo_alv->set_maximum_number_of_rows( p_max ).

  DATA(lr_disp) = lo_alv->display_options( ).

  DATA: lv_title TYPE sytitle.
*  IF_SALV_GUI_TYPES_IDA=>YT_SORT_RULE
  DATA lt_sort_rule TYPE if_salv_gui_types_ida=>yt_sort_rule.

  lv_title = COND string( WHEN r1 = abap_true THEN 'BATCH TRANSFER' ELSE 'BATCH SALE' ).
  "Match ECC captions
  lr_disp->set_title( lv_title ).

  "Optional deterministic sort: Plant, Date, VBELN
  DATA(lo_layout) = lo_alv->default_layout( ).

  APPEND VALUE #( field_name = 'WERKS' descending = abap_false ) TO lt_sort_rule.
  APPEND VALUE #( field_name = 'FKDAT' descending = abap_false ) TO lt_sort_rule.
  APPEND VALUE #( field_name = 'VBELN' descending = abap_false ) TO lt_sort_rule.

  lo_layout->set_sort_order( it_sort_order = lt_sort_rule ).
  lo_alv->fullscreen( )->display( ).



  "=== 2) BSR summary block (Receipt @ BSR − Control Sample) ===
  "Compute via CDS so it appears as one-row grid, exactly the printed block.
  DATA(lo_bsr) = cl_salv_gui_table_ida=>create_for_cds_view( 'ZI_BSR_TOTAL' ).
  DATA(lo_bsr_ranges) = NEW cl_salv_range_tab_collector( ).
  lo_bsr_ranges->add_ranges_for_name( iv_name = 'BATCH'
                                      it_ranges = VALUE rseloption( ( sign = 'I' option = 'EQ' low = batch ) ) ).

  lo_bsr_ranges->get_collected_ranges( IMPORTING et_named_ranges = DATA(it_BSR_ranges) ).
  lo_bsr->set_select_options( it_bsr_ranges  ).
  DATA(lo_bsrdisp) = lo_bsr->display_options( ).
  lo_bsrdisp->set_title( 'Receipt @ BSR / Control Sample' ).
  lo_bsr->fullscreen( )->display( ).
