*&---------------------------------------------------------------------*
*&      Form  CONVERT_XL_ITAB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM convert_xl_itab .

  IF p_local IS NOT INITIAL.

    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
      EXPORTING
        i_line_header        = 'X'
        i_tab_raw_data       = i_tab_raw_data
        i_filename           = p_local
      TABLES
        i_tab_converted_data = gt_final[]
      EXCEPTIONS
        conversion_failed    = 1
        OTHERS               = 2.

    IF sy-subrc <> 0.

    ELSE.

      DATA: lt_final     TYPE STANDARD TABLE OF ty_final,
            lw_final     TYPE ty_final,

            lt_final2    TYPE STANDARD TABLE OF ty_final,
            lw_final2    TYPE ty_final,

            lt_final3    TYPE STANDARD TABLE OF ty_final,
            lw_final3    TYPE ty_final,

            lw_final_nxt TYPE ty_final..

      lt_final2[] = gt_final[].

      SORT lt_final2 BY xblnr.
      DELETE ADJACENT DUPLICATES FROM lt_final2 COMPARING xblnr.

      LOOP AT lt_final2 INTO lw_final2. "--- unique XBLNR

        lt_final3[] = gt_final[].
        DELETE lt_final3 WHERE xblnr <> lw_final2-xblnr.

        LOOP AT lt_final3 INTO lw_final3. "--- each line of XBLNR

          DATA(lv_index) = sy-tabix + 1.  "--- 1,2,3

          "lw_final3-line_no = sy-tabix.

          CLEAR: lw_final_nxt.
          READ TABLE lt_final3 INTO  lw_final_nxt  "--- get next line details in current one
                               INDEX lv_index.
          IF sy-subrc = 0.
            lw_final3-newbs_nxt = lw_final_nxt-newbs.
            lw_final3-newko_nxt = lw_final_nxt-newko.
            lw_final3-wrbtr_nxt = lw_final_nxt-wrbtr.
            lw_final3-sgtxt_nxt = lw_final_nxt-sgtxt_nxt.
          ENDIF.

          APPEND lw_final3 TO lt_final.

          CLEAR: lw_final3.

        ENDLOOP.

        CLEAR: lw_final2.

      ENDLOOP.

      gt_final[] = lt_final[].

    ENDIF.

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  BDCDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM bdcdata .

  DATA: lt_final  TYPE STANDARD TABLE OF ty_final,
        lw_final  TYPE ty_final,
        lt_final2 TYPE STANDARD TABLE OF ty_final,
        lv_mode   TYPE c.

  lt_final[] = gt_final[].
  SORT lt_final BY blart xblnr.
  DELETE ADJACENT DUPLICATES FROM lt_final COMPARING blart xblnr.

  LOOP AT lt_final INTO lw_final.

    "---- Item detaisl -------------------------------
    lt_final2[] = gt_final[].
    DELETE lt_final2 WHERE blart <> lw_final-blart.
    DELETE lt_final2 WHERE xblnr <> lw_final-xblnr.

    CLEAR: gw_final.
    LOOP AT lt_final2 INTO gw_final. "--- unique xblnr

      IF sy-tabix = 1. "--- initial screen

        CLEAR: gw_bdcdata.

        CONCATENATE gw_final-bldat+6(2)
                    gw_final-bldat+4(2)
                    gw_final-bldat+0(4)
                    INTO gw_final-bldat.

        CONCATENATE gw_final-budat+6(2)
                    gw_final-budat+4(2)
                    gw_final-budat+0(4)
                    INTO gw_final-budat.

        "-- Populating internal table for bdcdata
        PERFORM bdc_dynpro USING  'SAPMF05A'    '0100'.
        PERFORM bdc_field USING:  'BKPF-BLDAT'  gw_final-bldat,
                                  'BKPF-BLART'  gw_final-blart,
                                  'BKPF-BUKRS'  gw_final-bukrs,
                                  'BKPF-BUDAT'  gw_final-budat,
                                  'BKPF-XBLNR'  gw_final-xblnr,
                                  'BKPF-BKTXT'  gw_final-bktxt,
                                  'RF05A-NEWBS' gw_final-newbs,
                                  'RF05A-NEWKO' gw_final-newko,
                                  'BDC_OKCODE'  '/00'.

      ENDIF. "--- end header details

      "----------------------------------------------------------
      PERFORM bdc_dynpro USING  'SAPMF05A'   '0300'.
      PERFORM bdc_field USING:  'BDC_OKCODE' '/00',
                                'BSEG-WRBTR' gw_final-wrbtr,
                                'BSEG-BUPLA' gw_final-bupla.

      IF gw_final-valut IS NOT INITIAL.
        CONCATENATE gw_final-valut+6(2)
                    gw_final-valut+4(2)
                    gw_final-valut+0(4)
                    INTO gw_final-valut.
        PERFORM bdc_field USING:  'BSEG-VALUT' gw_final-valut.
      ENDIF.

      PERFORM bdc_field USING:  'BSEG-ZUONR'   gw_final-zuonr,
                                'BSEG-SGTXT'   gw_final-sgtxt,
                                'RF05A-NEWBS'  gw_final-newbs_nxt,
                                'RF05A-NEWKO'  gw_final-newko_nxt.
      "---------------------------------------------------------

      PERFORM bdc_dynpro USING  'SAPLKACB'   '0002'.
      PERFORM bdc_field USING:  'COBL-GSBER' gw_final-gsber,
                                'COBL-KOSTL' gw_final-kostl,
                                'BDC_OKCODE' '=ENTE'.
      CLEAR: gw_final.

    ENDLOOP.

    "PERFORM bdc_field USING 'BDC_OKCODE' '=RW'. "--- back

    PERFORM bdc_dynpro USING 'SAPMF05A' '0300'.
    PERFORM bdc_field USING 'BDC_OKCODE' '=BU'.

    PERFORM bdc_dynpro USING 'SAPLKACB' '0002'.
    PERFORM bdc_field USING 'BDC_OKCODE' '=ENTE'.

    "--- Calling Transaction f-02 only when G/L doc balance is zero
    IF p_backg = 'X'.
      lv_mode = 'N'.
    ELSEIF p_foreg = 'X'.
      lv_mode = 'A'.
    ENDIF.

    CALL TRANSACTION 'F-02' USING         gt_bdcdata
                            MODE          lv_mode
                            UPDATE        'A'
                            MESSAGES INTO gt_bdcmsgcoll.

    LOOP AT gt_bdcmsgcoll INTO gw_bdcmsgcoll.

      IF gw_bdcmsgcoll-msgtyp = 'E' OR gw_bdcmsgcoll-msgtyp = 'S'.

        CALL FUNCTION 'FORMAT_MESSAGE'
          EXPORTING
            id        = gw_bdcmsgcoll-msgid
            lang      = gw_bdcmsgcoll-msgspra
            no        = gw_bdcmsgcoll-msgnr
            v1        = gw_bdcmsgcoll-msgv1
            v2        = gw_bdcmsgcoll-msgv2
            v3        = gw_bdcmsgcoll-msgv3
            v4        = gw_bdcmsgcoll-msgv4
          IMPORTING
            msg       = gw_final-message
          EXCEPTIONS
            not_found = 1
            OTHERS    = 2.

        IF sy-subrc = 0.

          IF gw_bdcmsgcoll-msgtyp = 'E'.
            gw_final-status = 'Error'.
          ELSEIF gw_bdcmsgcoll-msgtyp = 'S'.
            gw_final-status = 'Success'.
          ENDIF.

          MODIFY gt_final FROM gw_final
                          TRANSPORTING status
                                       message
                          WHERE blart = lw_final-blart
                          AND   xblnr = lw_final-xblnr.

        ENDIF.

      ENDIF.

      CLEAR: gw_bdcmsgcoll.

    ENDLOOP.

    CLEAR: lw_final, gt_bdcdata[], gt_bdcmsgcoll[].

  ENDLOOP.

ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM bdc_dynpro USING program dynpro.
  CLEAR gw_bdcdata.
  gw_bdcdata-program  = program.
  gw_bdcdata-dynpro   = dynpro.
  gw_bdcdata-dynbegin = 'X'.
  APPEND gw_bdcdata TO gt_bdcdata.
ENDFORM.                    "BDC_DYNPRO

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.
  IF fval <> space.
    CLEAR gw_bdcdata.
    gw_bdcdata-fnam = fnam.
    gw_bdcdata-fval = fval.
    APPEND gw_bdcdata TO gt_bdcdata.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FILL_BAPI
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM fill_bapi .
*
*  LOOP AT gt_header INTO gw_header.
*
*    "--- Fill Document Header ---------------------
*    doc_header-pstng_date = gw_item-budat.    "sy-datlo.
*    doc_header-doc_type   = gw_header-blart.  "'SA'.
*    doc_header-comp_code  = gw_header-bukrs.  "5000
*    doc_header-doc_date   = gw_header-bldat.  "sy-datlo.
*    doc_header-username   = sy-uname.
*    doc_header-ref_doc_no = gw_header-xblnr.  "'reference'.
*    doc_header-ac_doc_no  = '8'.
*    doc_header-header_txt = gw_header-bktxt.  "'TEST' .
*    "doc_header-fis_period = gv_monat.
*    "doc_header-fisc_year  = gv_year.
*    "doc_header-bus_act    = 'RFBU'.
*
*    LOOP AT gt_item INTO gw_item
*                    WHERE xblnr = gw_header-xblnr.
*
*      lv_index = sy-tabix.
*
*      "--- Fill Line 1 of Document Item
*      CLEAR doc_item.
*      doc_item-itemno_acc = lv_index.        "'1'.
*      doc_item-
*      doc_item-gl_account = gw_item-newko.   "'0000680106'.
*      doc_item-costcenter = gw_item-kostl.   "'H909'.
*      doc_item-pstng_date = gw_item-budat.   "sy-datum.
*      doc_item-item_text  = gw_item-sgtxt.   "'TEST POSTING DEBIT ITEM'.
*      doc_item-bus_area   = gw_item-gsber.
*      "doc_item-profit_ctr = gw_item-.
*      APPEND doc_item.
*
**      "newbs type rf05a-newbs,     "Posting Key for the Next Line Item
**      "newko type rf05a-newko,     "Account "g/l code
**      bupla type bseg-bupla,    "business plac,
**      valut type bseg-valut ,   "value date.
**      zuonr type bseg-zuonr,  "assignment no,
**      sgtxt type bseg-sgtxt,   "item text,
*
*      "--- Fill Line 2 of Document Item
*      CLEAR doc_ar.
*      doc_ar-itemno_acc = lv_index. " '2'.
*      doc_ar-item_text  = gw_item-sgtxt. "  'CREDIT ITEM'.
*
*      APPEND doc_ar.
*
*      "-- Fill Line 1 of Document Value.
*      IF gw_item-newbs = '50'.
*        gw_item-wrbtr = -1 * gw_item-wrbtr.
*      ENDIF.
*
*      CLEAR doc_values.
*      doc_values-itemno_acc   = lv_index. "'1'.
*      doc_values-amt_doccur   = gw_item-wrbtr. " '-200.00'.
*      doc_values-currency_iso = 'INR'.
*      doc_values-currency     = 'INR'.
*      APPEND doc_values.
*
*    ENDLOOP.
*
*
*    "--------------------------------------------
*
*    CALL FUNCTION 'BAPI_ACC_DOCUMENT_CHECK'
*      EXPORTING
*        documentheader    = doc_header
*      IMPORTING
*        obj_type          = doc_header-obj_type
*        obj_key           = doc_header-obj_key
*        obj_sys           = doc_header-obj_sys
*      TABLES
*        accountgl         = doc_item
*        accountreceivable = doc_ar
*        currencyamount    = doc_values
*        return            = return
*        extension1        = extension1.
*
*    LOOP AT return WHERE type = 'E'.
*      EXIT.
*    ENDLOOP.
*
*    CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
*      EXPORTING
*        documentheader    = doc_header
*      IMPORTING
*        obj_type          = doc_header-obj_type
*        obj_key           = doc_header-obj_key
*        obj_sys           = doc_header-obj_sys
*      TABLES
*        accountgl         = doc_item
*        accountreceivable = doc_ar
*        currencyamount    = doc_values
*        return            = return.
*
*    LOOP AT return WHERE type = 'E'.
*      EXIT.
*    ENDLOOP.
*
*    IF sy-subrc EQ 0.
*      WRITE: / 'error!'.
*    ELSE.
*
*      CLEAR return.
*      REFRESH return.
*
*      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*        EXPORTING
*          wait   =
*        importing
*          return = return.
*
*      WRITE: / 'BAPI worked!!'.
*      WRITE: / doc_header-obj_key, ' posted'.
*
*    ENDIF.
*
*  ENDLOOP.
*

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_REPORT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM display_report .

  DATA: lw_layout TYPE slis_layout_alv,

        lt_sort   TYPE slis_t_sortinfo_alv,
        lw_sort   TYPE slis_sortinfo_alv.

  lw_layout-colwidth_optimize = 'X'.

  IF gt_final[] IS NOT INITIAL.

    PERFORM fill_fcat.

    CLEAR: lw_sort.
    lw_sort-spos = 1.
    lw_sort-fieldname = 'BUKRS'.
    lw_sort-up = 'X'.
    APPEND lw_sort TO lt_sort.

    CLEAR: lw_sort.
    lw_sort-spos = 2.
    lw_sort-fieldname = 'BUDAT'.
    lw_sort-up = 'X'.
    APPEND lw_sort TO lt_sort.

    CLEAR: lw_sort.
    lw_sort-spos = 3.
    lw_sort-fieldname = 'BLART'.
    lw_sort-up = 'X'.
    APPEND lw_sort TO lt_sort.

    CLEAR: lw_sort.
    lw_sort-spos = 4.
    lw_sort-fieldname = 'XBLNR'.
    lw_sort-up = 'X'.
    APPEND lw_sort TO lt_sort.

    CLEAR: lw_sort.
    lw_sort-spos = 5.
    lw_sort-fieldname = 'STATUS'.
    lw_sort-up = 'X'.
    APPEND lw_sort TO lt_sort.

    CLEAR: lw_sort.
    lw_sort-spos = 6.
    lw_sort-fieldname = 'MESSAGE'.
    lw_sort-up = 'X'.
    APPEND lw_sort TO lt_sort.


    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_grid_title  = 'GL Account Posting Log'
        it_fieldcat   = gt_fcat
        is_layout     = lw_layout
        it_sort       = lt_sort
      TABLES
        t_outtab      = gt_final
      EXCEPTIONS
        program_error = 1
        OTHERS        = 2.
    IF sy-subrc <> 0.

    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FILL_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM fill_fcat .

  PERFORM fcat_field USING :
  'BUKRS' 'Company Code',
  'BUDAT' 'Posting Date',
  'BLART' 'Document Type',
  'XBLNR' 'Reference',
  'BKTXT' 'Document Header Text',
  'NEWBS' 'Posting Key Debit/Credit',
  'NEWKO' 'GL Code',
  'WRBTR' 'Amount',
  'BUPLA' 'Bussiness Place',
  'KOSTL' 'Cost Center',
  'GSBER' 'Business Area',
  'VALUT' 'Value Date',
  'ZUONR' 'Assignment',
  'SGTXT' 'Text',
  "'LINE_NO' 'Line Number',
  'STATUS'  'Status',
  'MESSAGE' 'Message'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT_FIELD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM fcat_field  USING lv_fieldname
                       lv_text.

  gw_fcat-fieldname = lv_fieldname.
  gw_fcat-seltext_m = lv_text.
  APPEND gw_fcat TO gt_fcat.
  CLEAR gw_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FILL_BDCDATA_CALL_TXN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM fill_bdcdata_call_txn .

  PERFORM bdcdata.

  IF p_backg = 'X'.

    "---- Additional logic for value date controlling ----
    DATA: lt_final TYPE STANDARD TABLE OF ty_final,
          lw_final TYPE ty_final.

    lt_final[] = gt_final[].
    DELETE lt_final WHERE message = 'Field BSEG-VALUT. does not exist in the screen SAPMF05A 0300'.
    DELETE gt_final WHERE message <> 'Field BSEG-VALUT. does not exist in the screen SAPMF05A 0300'.

    IF gt_final[] IS NOT INITIAL.
      lw_final-valut = ''.
      MODIFY gt_final FROM lw_final
                      TRANSPORTING valut
                      WHERE valut IS NOT INITIAL.
      "--- again calling bdc with initial value date
      PERFORM bdcdata.

      APPEND LINES OF gt_final TO lt_final.
      gt_final[] = lt_final[].
    ENDIF.

  ENDIF.

ENDFORM.
