*&---------------------------------------------------------------------*
*& Report  YR_CLAIMORDR_UPLOAD_RAM
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  YR_CLAIMORDR_UPLOAD_RAM.

TYPE-POOLS: SLIS.

DATA: HEADER TYPE BAPISDHD1.
DATA: HEADER_INX TYPE BAPISDHD1X.

DATA: WA_VBELN TYPE VBELN_VA.

DATA: RETURN TYPE TABLE OF BAPIRET2 WITH HEADER LINE,
      ITEM TYPE TABLE OF BAPISDITM WITH HEADER LINE,
      PATNER TYPE TABLE OF BAPIPARNR WITH HEADER LINE,
      CONDITION TYPE TABLE OF BAPICOND WITH HEADER LINE,
      CONDITION_CHK TYPE TABLE OF BAPICONDX WITH HEADER LINE.
DATA: ITEMS_INX TYPE TABLE OF BAPISDITMX,
      WA_ITEMX TYPE BAPISDITMX.

DATA: BEGIN OF ITAB OCCURS 0,
      headerno(12) TYPE N,
      NO(12) TYPE N,
      DOC_TYPE TYPE AUART,
      SALES_ORG TYPE VKORG,
      DISTR_CHAN TYPE VTWEG,
      DIVISION  TYPE SPART,
      PARTN_NUMB TYPE KUNNR,
      SHIP_TO    TYPE KUNNR,
      PURCH_NO_C TYPE BSTKD,
*      PURCH_DATE TYPE BSTDK,
      PURCH_DATE TYPE char10,
      PURCH_NO_S TYPE BSTKD_E,
      PO_DAT_S TYPE char10,
*      PO_DAT_S TYPE BSTDK_E,
*      PRICE_DATE TYPE PRSDT,
      PRICE_DATE TYPE char10,
      ORD_REASON TYPE AUGRU,
      MATERIAL TYPE MATNR,
      TARGET_QTY TYPE DZMENG,
      "COND_VALUE TYPE BAPIKBETR1,
      batch type CHARG_D,
      collect type submi,
*  DUN_DATE TYPE MAHDT,
  DUN_DATE TYPE char10,
      END OF ITAB.

    data : tt_itab type table of itab.

DATA: BEGIN OF ITAB_HDR OCCURS 0,
       headerno(12) TYPE N,
      NO(12) TYPE N,
      DOC_TYPE TYPE AUART,
      SALES_ORG TYPE VKORG,
      DISTR_CHAN TYPE VTWEG,
      DIVISION  TYPE SPART,
      PARTN_NUMB TYPE KUNNR,
      SHIP_TO    TYPE KUNNR,
*      PURCH_DATE TYPE BSTDK,
      PURCH_DATE TYPE char10,
      PURCH_NO_C TYPE BSTKD,
      PURCH_NO_S TYPE BSTKD_E,
*      PO_DAT_S TYPE BSTDK_E,
        PO_DAT_S TYPE char10,
*      PRICE_DATE TYPE PRSDT,
     PRICE_DATE TYPE char10,
      ORD_REASON TYPE AUGRU,
     collect type submi,
*    DUN_DATE TYPE MAHDT,
   DUN_DATE TYPE char10,
      END OF ITAB_HDR.

DATA: BEGIN OF ITAB_ITM OCCURS 0,
   headerno(12) TYPE N,
      NO(12) TYPE N,
      MATERIAL TYPE MATNR,
      TARGET_QTY TYPE DZMENG,
      batch type CHARG_D,
      "COND_VALUE TYPE BAPIKBETR1,
      END OF ITAB_ITM.

DATA: BEGIN OF ITAB_VBELN OCCURS 0,
      NO(12) TYPE N,
      VBELN TYPE VBELN_VA,
      MESG TYPE BAPI_MSG,
      END OF ITAB_VBELN.

DATA: FILE TYPE STRING,
      WA_CNT(4) TYPE N,
      ALV_FLDCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FLD LIKE LINE OF ALV_FLDCAT,
      ALV_LAYOUT TYPE  SLIS_LAYOUT_ALV.
data: LV_FILENAME TYPE RLGRAP-FILENAME.
DATA : GT_RAW     TYPE TRUXS_T_TEXT_DATA.

SELECTION-SCREEN BEGIN OF  BLOCK b1 WITH FRAME TITLE text-001.
  PARAMETERS: p_file LIKE rlgrap-filename.
  SELECTION-SCREEN SKIP 2.
  SELECTION-SCREEN PUSHBUTTON 10(20) TEXT-002 USER-COMMAND cl1.
SELECTION-SCREEN END OF block b1.
*PARAMETERS: P_FILE TYPE RLGRAP-FILENAME OBLIGATORY.
DATA : it_excel TYPE TABLE OF alsmex_tabline.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      PROGRAM_NAME  = SYST-CPROG
      DYNPRO_NUMBER = SYST-DYNNR
      FIELD_NAME    = ' '
    IMPORTING
      FILE_NAME     = P_FILE.

AT SELECTION-SCREEN.
 IF sy-ucomm = 'CL1'.
    PERFORM show_template.
  ENDIF.
START-OF-SELECTION.
  LV_FILENAME  =  P_FILE.
*
*  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
*    EXPORTING
*      I_FIELD_SEPERATOR    = 'X'
*      I_LINE_HEADER        = 'X'
*      I_TAB_RAW_DATA       = GT_RAW
*      I_FILENAME           = LV_FILENAME
*    TABLES
*      I_TAB_CONVERTED_DATA = Itab
*    EXCEPTIONS
*      CONVERSION _FAILED    = 1
*      OTHERS               = 2.

CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
  EXPORTING
    FILENAME                      = lv_filename
    I_BEGIN_COL                   = '1'
    I_BEGIN_ROW                   = '2'
    I_END_COL                     = '21'
    I_END_ROW                     = '99999'
  TABLES
    INTERN                        = it_excel
 EXCEPTIONS
   INCONSISTENT_PARAMETERS       = 1
   UPLOAD_OLE                    = 2
   OTHERS                        = 3
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.

CLEAR itab.
REFRESH itab.

DATA: lv_row TYPE i.
CLEAR lv_row.

LOOP AT it_excel INTO data(wa_excel).

  AT NEW row.
    CLEAR itab.
  ENDAT.

 CASE wa_excel-col.

  WHEN 1.   itab-headerno    = wa_excel-value.   " HEADERNO (Sales Order Temp)
  WHEN 2.   itab-no      = wa_excel-value.   " ITEMNO (Item Temp)

  WHEN 3.   itab-doc_type    = wa_excel-value.   " Sales Document Type
  WHEN 4.   itab-sales_org   = wa_excel-value.   " Sales Organization
  WHEN 5.   itab-distr_chan  = wa_excel-value.   " Distribution Channel
  WHEN 6.   itab-division    = wa_excel-value.   " Division

  WHEN 7.   itab-partn_numb  = wa_excel-value.   " Customer (Sold-to)
  WHEN 8.   itab-ship_to     = wa_excel-value.   " Customer (Ship-to)

  WHEN 9.   itab-purch_no_c  = wa_excel-value.   " Customer Reference
  WHEN 10.  itab-purch_date  = wa_excel-value.   " Customer Ref. Date

  WHEN 11.  itab-PURCH_NO_S = wa_excel-value.   " OPTIONAL Ref (if used)
  WHEN 12.  itab-PO_DAT_S = wa_excel-value.   " OPTIONAL Ref Date (if used)

  WHEN 13.  itab-price_date = wa_excel-value.   " Pricing Date
  WHEN 14.  itab-ord_reason = wa_excel-value.   " Order Reason

  WHEN 15.  itab-material   = wa_excel-value.   " Material
  WHEN 16.  itab-target_qty = wa_excel-value.   " Target Quantity
  WHEN 17.  itab-batch      = wa_excel-value.   " Batch
  WHEN 18.  itab-collect    = wa_excel-value.   " Collective Number
  WHEN 19.  itab-DUN_DATE   = wa_excel-value.


ENDCASE.


  AT END OF row.
    APPEND itab.
  ENDAT.

ENDLOOP.

data(itab3) = itab[].
SORT itab3 by headerno.
delete ADJACENT DUPLICATES FROM itab3 COMPARING headerno.
DATA: lv_date TYPE sy-datum.
LOOP AT itab3 INTO DATA(wa_tab3).




LOOP AT itab Where headerno = wa_tab3-HEADERNO.

IF itab-purch_date IS NOT INITIAL AND strlen( itab-purch_date ) >= 10.
    CONCATENATE itab-purch_date+6(4)
                itab-purch_date+3(2)
                itab-purch_date+0(2)
           INTO itab-purch_date.
  ENDIF.

  IF itab-po_dat_s IS NOT INITIAL AND strlen( itab-po_dat_s ) >= 10.
    CONCATENATE itab-po_dat_s+6(4)
                itab-po_dat_s+3(2)
                itab-po_dat_s+0(2)
           INTO itab-po_dat_s.
  ENDIF.

  IF itab-price_date IS NOT INITIAL AND strlen( itab-price_date ) >= 10.
    CONCATENATE itab-price_date+6(4)
                itab-price_date+3(2)
                itab-price_date+0(2)
           INTO itab-price_date.
  ENDIF.
 IF itab-DUN_DATE IS NOT INITIAL AND strlen( itab-DUN_DATE ) >= 10.
    CONCATENATE itab-DUN_DATE+6(4)
                itab-DUN_DATE+3(2)
                itab-DUN_DATE+0(2)
           INTO itab-DUN_DATE.
  ENDIF.

   " ON CHANGE OF ITAB-NO.
    ON CHANGE OF  ITAB-HEADERNO.
      MOVE-CORRESPONDING ITAB TO ITAB_HDR.
 IF ITAB-ORD_REASON IS NOT INITIAL.
    ITAB_HDR-ORD_REASON = ITAB-ORD_REASON.
  ENDIF.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          INPUT  = ITAB_HDR-PARTN_NUMB
        IMPORTING
          OUTPUT = ITAB_HDR-PARTN_NUMB.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          INPUT  = ITAB_HDR-SHIP_TO
        IMPORTING
          OUTPUT = ITAB_HDR-SHIP_TO.

      APPEND ITAB_HDR.
      CLEAR ITAB_HDR.
    ENDON.

    MOVE-CORRESPONDING ITAB TO ITAB_ITM.


    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        INPUT        = ITAB_ITM-MATERIAL
      IMPORTING
        OUTPUT       = ITAB_ITM-MATERIAL
      EXCEPTIONS
        LENGTH_ERROR = 1
        OTHERS       = 2.
    IF SY-SUBRC <> 0.
      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

    APPEND ITAB_ITM.
    CLEAR ITAB_ITM.
  ENDLOOP.



  LOOP AT ITAB_HDR Where headerno = wa_tab3-HEADERNO..

    CLEAR: HEADER_INX, HEADER, WA_VBELN, RETURN, RETURN[],
    ITEM, ITEM[], PATNER, PATNER[], CONDITION, CONDITION[],
    CONDITION_CHK, CONDITION_CHK[].

HEADER_INX-DOC_TYPE     = 'X'.
HEADER_INX-SALES_ORG    = 'X'.
HEADER_INX-DISTR_CHAN   = 'X'.
HEADER_INX-DIVISION     = 'X'.
HEADER_INX-PURCH_DATE  = 'X'.
HEADER_INX-PURCH_NO_C  = 'X'.
HEADER_INX-PURCH_NO_S  = 'X'.
HEADER_INX-PO_DAT_S    = 'X'.
HEADER_INX-PRICE_DATE  = 'X'.
HEADER_INX-ORD_REASON  = 'X'.
HEADER_INX-DUN_DATE  = 'X'.




    header-COLLECT_NO = itab_hdr-COLLECT.
    HEADER-DOC_TYPE = ITAB_HDR-DOC_TYPE.
    HEADER-SALES_ORG = ITAB_HDR-SALES_ORG.
    HEADER-DISTR_CHAN = ITAB_HDR-DISTR_CHAN.
    HEADER-DIVISION = ITAB_HDR-DIVISION.
    HEADER-PURCH_DATE = ITAB_HDR-PURCH_DATE.
    HEADER-PURCH_NO_C = ITAB_HDR-PURCH_NO_C.
    HEADER-PURCH_NO_S = ITAB_HDR-PURCH_NO_S.
    HEADER-PO_DAT_S = ITAB_HDR-PO_DAT_S.
    HEADER-PRICE_DATE = ITAB_HDR-PRICE_DATE.
    HEADER-ORD_REASON = ITAB_HDR-ORD_REASON.
    HEADER-DUN_DATE = ITAB_HDR-DUN_DATE.

   CONDENSE HEADER-ORD_REASON.

    PATNER-PARTN_ROLE = 'AG'.
    PATNER-PARTN_NUMB = ITAB_HDR-PARTN_NUMB.
    APPEND PATNER.
    CLEAR PATNER.

    CLEAR PATNER.
    PATNER-PARTN_ROLE = 'WE'.
    PATNER-PARTN_NUMB = ITAB_HDR-SHIP_TO.
    APPEND PATNER.

    LOOP AT ITAB_ITM WHERE HEADERNO = ITAB_HDR-HEADERNO.
      "WA_CNT = WA_CNT + 1.
      "WA_CNT = WA_CNT + 1.
 DATA lv_itm_no TYPE char6.
WA_CNT = WA_CNT + 10.
 lv_itm_no = wa_cnt.
lv_itm_no = |{ lv_itm_no ALPHA = IN }|.
  CLEAR WA_ITEMX.
  WA_ITEMX-ITM_NUMBER = lv_itm_no.  "ITAB_ITM-NO.
  WA_ITEMX-MATERIAL   = 'X'.
  WA_ITEMX-updateflag = 'I'   .
  WA_ITEMX-TARGET_QTY = 'X'.
  WA_ITEMX-BATCH      = 'X'.
  APPEND WA_ITEMX TO ITEMS_INX.

      ITEM-ITM_NUMBER = lv_itm_no. "WA_CNT. "WA_CNT.
      ITEM-MATERIAL = ITAB_ITM-MATERIAL.
      ITEM-TARGET_QTY = ITAB_ITM-TARGET_QTY.
      ITEM-BATCH = ITAB_ITM-BATCH.
      APPEND ITEM.
      CLEAR ITEM.

*      CONDITION-ITM_NUMBER = WA_CNT.
*      CONDITION-COND_ST_NO = '20'.
*      CONDITION-COND_COUNT = '1'.
*      CONDITION-COND_TYPE = 'Z001'.
*      CONDITION-COND_VALUE = ITAB_ITM-COND_VALUE.
*      CONDITION-CURRENCY = 'INR'.
*      APPEND CONDITION.
*      CLEAR CONDITION.

      CONDITION_CHK-ITM_NUMBER = WA_CNT.
      CONDITION_CHK-COND_ST_NO = '20'.
      CONDITION_CHK-COND_COUNT = '1'.
      CONDITION_CHK-COND_TYPE = 'Z001'.
*      CONDITION_CHK-UPDATEFLAG = 'U'.
      CONDITION_CHK-COND_VALUE = 'X'.
      APPEND CONDITION_CHK.
      CLEAR CONDITION_CHK.

    ENDLOOP.
CLEAR:WA_CNT.
*    CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
*      EXPORTING
*        SALES_HEADER_IN      = HEADER
*      IMPORTING
*        SALESDOCUMENT_EX     = WA_VBELN
*      TABLES
*        RETURN               = RETURN
*        SALES_ITEMS_IN       = ITEM
*        SALES_PARTNERS       = PATNER
*        SALES_CONDITIONS_IN  = CONDITION
**        SALES_CONDITIONS_INX = CONDITION_CHK.

              .
CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
  EXPORTING
*   SALESDOCUMENT                   =
    SALES_HEADER_IN                 = HEADER
    SALES_HEADER_INX                = HEADER_INX
*   SENDER                          =
*   BINARY_RELATIONSHIPTYPE         = ' '
*   INT_NUMBER_ASSIGNMENT           = ' '
*   BEHAVE_WHEN_ERROR               = ' '
*   LOGIC_SWITCH                    = ' '
*   BUSINESS_OBJECT                 = ' '
*   TESTRUN                         =
*   CONVERT_PARVW_AUART             = ' '
   STATUS_BUFFER_REFRESH            = 'X'
*   CALL_ACTIVE                     = ' '
*   I_WITHOUT_INIT                  = ' '
   I_REFRESH_V45I                   = 'X'
*   I_TESTRUN_EXTENDED              = ' '
   I_CHECK_AG                       = 'X'
*   I_NO_DEQUEUE_ALL                = ' '
*   I_NO_BOPF_TRANS_MGR_CALLS       = ABAP_FALSE
 IMPORTING
   SALESDOCUMENT_EX                = WA_VBELN
*   SALES_HEADER_OUT                =
*   SALES_HEADER_STATUS             =
 TABLES
    RETURN                          = RETURN
    SALES_ITEMS_IN                  = ITEM
    SALES_ITEMS_INX                  = ITEMS_INX
    SALES_PARTNERS                  = PATNER
*   SALES_SCHEDULES_IN              =
*   SALES_SCHEDULES_INX             =
*   SALES_CONDITIONS_IN              = CONDITION
*   SALES_CONDITIONS_INX             = CONDITION_CHK.
*   SALES_CFGS_REF                  =
*   SALES_CFGS_INST                 =
*   SALES_CFGS_PART_OF              =
*   SALES_CFGS_VALUE                =
*   SALES_CFGS_BLOB                 =
*   SALES_CFGS_VK                   =
*   SALES_CFGS_REFINST              =
*   SALES_CCARD                     =
*   SALES_TEXT                      =
*   SALES_KEYS                      =
*   SALES_CONTRACT_IN               =
*   SALES_CONTRACT_INX              =
*   EXTENSIONIN                     =
*   PARTNERADDRESSES                =
*   SALES_SCHED_CONF_IN             =
*   ITEMS_EX                        =
*   SCHEDULE_EX                     =
*   BUSINESS_EX                     =
*   INCOMPLETE_LOG                  =
*   EXTENSIONEX                     =
*   CONDITIONS_EX                   =
*   PARTNERS_EX                     =
*   TEXTHEADERS_EX                  =
*   TEXTLINES_EX                    =
*   BATCH_CHARC                     =
*   CAMPAIGN_ASGN                   =
          .

IF WA_VBELN is not INITIAL.

CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
 EXPORTING
   WAIT          = 'X'
* IMPORTING
*   RETURN        =
          .

ENDIF.

    ITAB_VBELN-VBELN = WA_VBELN.
    ITAB_VBELN-NO = ITAB_HDR-NO.

    LOOP AT RETURN WHERE TYPE = 'E' OR TYPE = 'A' or TYPE = 'S' OR TYPE = 'W'.
      ITAB_VBELN-MESG = RETURN-MESSAGE.
      APPEND ITAB_VBELN.
    ENDLOOP.

    IF SY-SUBRC <> 0.
      APPEND ITAB_VBELN.
    ENDIF.
    CLEAR ITAB_VBELN.

  ENDLOOP.
CLEAR wa_tab3.
ENDLOOP.
 " COMMIT WORK AND WAIT.

  DESCRIBE TABLE ITAB_VBELN.
  IF SY-TFILL > 0.

    WA_FLD-FIELDNAME = 'NO'.
    WA_FLD-SELTEXT_L = 'Legacy Order No'.
    APPEND WA_FLD TO ALV_FLDCAT.

    WA_FLD-FIELDNAME = 'VBELN'.
    WA_FLD-SELTEXT_L = 'SAP Order No'.
    APPEND WA_FLD TO ALV_FLDCAT.

    WA_FLD-FIELDNAME = 'MESG'.
    WA_FLD-SELTEXT_L = ' Mesg'.
    APPEND WA_FLD TO ALV_FLDCAT.

    ALV_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
    ALV_LAYOUT-ZEBRA = 'X'.


    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        IS_LAYOUT     = ALV_LAYOUT
        IT_FIELDCAT   = ALV_FLDCAT
      TABLES
        T_OUTTAB      = ITAB_VBELN
      EXCEPTIONS
        PROGRAM_ERROR = 1
        OTHERS        = 2.
    IF SY-SUBRC <> 0.
      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

  ENDIF.
*&---------------------------------------------------------------------*
*& Form show_template
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SHOW_TEMPLATE .

DATA : lv_filename TYPE string,
         lv_path     TYPE string,
         lv_file     TYPE ibipparms-path,
         lv_fullpath TYPE string.

  DATA: "xexcel TYPE ty_excel,
    "iexcel TYPE TABLE OF ty_excel,
    lt_excel_structure      TYPE TABLE OF ZTT_ITAB2 , "ZEXCL_STRUCT1,"ty_excel_structure,
    lr_excel_structure      TYPE REF TO data,
    lv_content              TYPE xstring,
    ls_stream               TYPE /iwbep/if_mgw_core_srv_runtime=>ty_s_media_resource,
    lo_table_row_descriptor TYPE REF TO cl_abap_structdescr,
    lo_source_table_descr   TYPE REF TO cl_abap_tabledescr,
    v_filename              TYPE bapidocid,
    ls_header               TYPE ihttpnvp.


  CALL METHOD cl_gui_frontend_services=>file_save_dialog
    EXPORTING
      window_title      = 'Enter File Name'
      default_extension = 'XLSX'
      default_file_name = 'SDCREATE.xlsx' ""'Test.xlsx'
    CHANGING
      filename          = lv_filename
      path              = lv_path
      fullpath          = lv_fullpath.

  lv_file = lv_fullpath.

  GET REFERENCE OF lt_excel_structure INTO lr_excel_structure.
  DATA(lo_itab_services) = cl_salv_itab_services=>create_for_table_ref( lr_excel_structure ).
  lo_source_table_descr ?= cl_abap_tabledescr=>describe_by_data_ref( lr_excel_structure ).
  lo_table_row_descriptor ?= lo_source_table_descr->get_table_line_type( ).
  DATA(lt_fields) = lo_table_row_descriptor->get_ddic_field_list( p_langu = sy-langu  ) .

  DATA(lo_tool_xls) = cl_salv_export_tool_ats_xls=>create_for_excel(
                            EXPORTING r_data =  lr_excel_structure ).

  DATA(lo_config) = lo_tool_xls->configuration( ).
  LOOP AT lt_fields ASSIGNING FIELD-SYMBOL(<lfs_field>) .
    lo_config->add_column(
      EXPORTING
        header_text          =  CONV string( <lfs_field>-scrtext_l )
        field_name           =  CONV string( <lfs_field>-fieldname )
        display_type         =   if_salv_bs_model_column=>uie_text_view ).
  ENDLOOP .

  lo_tool_xls->read_result(  IMPORTING content  = lv_content  ).

  DATA : lt_binary_tab TYPE TABLE OF sdokcntasc,
         lv_length     TYPE i.

  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer        = lv_content
    IMPORTING
      output_length = lv_length
    TABLES
      binary_tab    = lt_binary_tab.

  CALL METHOD cl_gui_frontend_services=>gui_download
    EXPORTING
*     filename                = 'test.xls'
      bin_filesize            = lv_length
      filename                = CONV string( lv_file ) "'test.xlsx'
      filetype                = 'BIN'
*     write_field_separator   = 'X'
*     header                  = '00'
    CHANGING
      data_tab                = lt_binary_tab "iexcel
    EXCEPTIONS
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      not_supported_by_gui    = 22
      error_no_gui            = 23
      OTHERS                  = 24.
ENDFORM.
