*&---------------------------------------------------------------------*
*& Report  YR_CLAIMORDR_UPLOAD_RAM
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  ZSD_SO_UPDATE.

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

*DATA: BEGIN OF ITAB OCCURS 0,
*      headerno(12) TYPE N,
*      NO(12) TYPE N,
*      DOC_TYPE TYPE AUART,
*      SALES_ORG TYPE VKORG,
*      DISTR_CHAN TYPE VTWEG,
*      DIVISION  TYPE SPART,
*      PARTN_NUMB TYPE KUNNR,
*      SHIP_TO    TYPE KUNNR,
*      PURCH_NO_C TYPE BSTKD,
**      PURCH_DATE TYPE BSTDK,
*      PURCH_DATE TYPE char10,
*      PURCH_NO_S TYPE BSTKD_E,
*      PO_DAT_S TYPE char10,
**      PO_DAT_S TYPE BSTDK_E,
**      PRICE_DATE TYPE PRSDT,
*      PRICE_DATE TYPE char10,
*      ORD_REASON TYPE AUGRU,
*      MATERIAL TYPE MATNR,
*      TARGET_QTY TYPE DZMENG,
*      "COND_VALUE TYPE BAPIKBETR1,
*      batch type CHARG_D,
*      collect type submi,
**  DUN_DATE TYPE MAHDT,
*  DUN_DATE TYPE char10,
*      END OF ITAB.
*
*    data : tt_itab type table of itab.

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
tables: vbap.
SELECTION-SCREEN BEGIN OF  BLOCK b1 WITH FRAME TITLE text-001.
*  PARAMETERS: p_file LIKE rlgrap-filename.
*  SELECTION-SCREEN SKIP 2.
*  SELECTION-SCREEN PUSHBUTTON 10(20) TEXT-002 USER-COMMAND cl1.
  SELECT-OPTIONS s_vbeln FOR vbap-vbeln.
SELECTION-SCREEN END OF block b1.
*PARAMETERS: P_FILE TYPE RLGRAP-FILENAME OBLIGATORY.
DATA : it_excel TYPE TABLE OF alsmex_tabline.
data: sales_vbeln TYPE BAPIVBELN-VBELN.
data : SALES_HEADER_OUT TYPE  BAPISDHD.
data : SALES_HEADER_STATUS TYPE	BAPISDHDST,
START-OF-SELECTION.


SELECT * from vbak INTO TABLE @DATA(itab) WHERE vbeln in @s_vbeln and auart = 'ZXPY'.
if itab is NOT INITIAL.
  SELECT * from vbpa INTO TABLE @DATA(it_vbpa) FOR ALL ENTRIES IN @itab WHERE vbeln = @itab-vbeln.

SELECT * from vbap INTO TABLE @DATA(it_vbap) for ALL ENTRIES IN @itab WHERE vbeln = @itab-vbeln.
SELECT * FROM mara INTO TABLE @DATA(it_mara) FOR ALL ENTRIES IN @it_vbap WHERE matnr = @it_vbap-matnr.
  endif.


  LOOP AT ITAB INTO DATA(wa_tab).  " Where vbeln = wa_tab-vbeln..

    CLEAR: HEADER_INX, HEADER, WA_VBELN, RETURN, RETURN[],
    ITEM, ITEM[], PATNER, PATNER[], CONDITION, CONDITION[],
    CONDITION_CHK, CONDITION_CHK[].
sales_vbeln = wa_tab-vbeln.
HEADER_INX-DOC_TYPE     = 'X'.
HEADER_INX-UPDATEFLAG     = 'U'.
HEADER_INX-SALES_ORG    = 'X'.
HEADER_INX-DISTR_CHAN   = 'X'.
HEADER_INX-DIVISION     = 'X'.


    HEADER-DOC_TYPE = wa_tab-AUART.
    HEADER-SALES_ORG = wa_tab-VKORG.
    HEADER-DISTR_CHAN = wa_tab-VTWEG.
    HEADER-DIVISION = wa_tab-SPART.

*
*REad TABLE it_vbpa INTO DATA(wa_vbpa) WITH key PARVW = 'AG'.
*if sy-subrc = 0.
*    PATNER-PARTN_ROLE = 'AG'.
*    PATNER-PARTN_NUMB = wa_vbpa-kunnr.
*    APPEND PATNER.
*    CLEAR PATNER.
*endif.
*REad TABLE it_vbpa INTO wa_vbpa WITH key PARVW = 'WE'.
*if sy-subrc = 0.
*    CLEAR PATNER.
*    PATNER-PARTN_ROLE = 'WE'.
*    PATNER-PARTN_NUMB =  wa_vbpa-kunnr.
*    APPEND PATNER.
*endif.


    LOOP AT it_vbap INTO DATA(wa_vbap) WHERE vbeln = wa_tab-vbeln.

 DATA lv_itm_no TYPE char6.

 lv_itm_no = wa_vbap-POSNR.
lv_itm_no = |{ lv_itm_no ALPHA = IN }|.
  CLEAR WA_ITEMX.
  WA_ITEMX-ITM_NUMBER = lv_itm_no.  "ITAB_ITM-NO.
  WA_ITEMX-MATERIAL   = 'X'.
  WA_ITEMX-DIVISION   = 'X'.
  WA_ITEMX-BATCH      = 'X'.
  APPEND WA_ITEMX TO ITEMS_INX.

READ TABLE it_mara INTO DATA(wa_mara) with key matnr = wa_vbap-matnr.
if sy-subrc = 0.
     ITEM-DIVISION = wa_mara-SPART .
     endif.

      ITEM-ITM_NUMBER = lv_itm_no.
      ITEM-MATERIAL = wa_vbap-matnr.

      ITEM-BATCH = wa_vbap-charg.
      APPEND ITEM.
      CLEAR ITEM.

    ENDLOOP.


*BREAK-POINT.
CALL FUNCTION 'SD_SALESDOCUMENT_CHANGE'
  EXPORTING
   SALESDOCUMENT                   = sales_vbeln
   ORDER_HEADER_IN                 = HEADER
    ORDER_HEADER_INX                = HEADER_INX
*   SIMULATION                      = ' '
*   INT_NUMBER_ASSIGNMENT           = ' '
*   BEHAVE_WHEN_ERROR               = ' '
*   BUSINESS_OBJECT                 = ' '
*   CONVERT_PARVW_AUART             = ' '
*   CALL_FROM_BAPI                  = ' '
*   LOGIC_SWITCH                    =
*   I_CRM_LOCK_MODE                 = ' '
*   NO_STATUS_BUF_INIT              = ' '
*   CALL_ACTIVE                     = ' '
*   I_WITHOUT_INIT                  = ' '
*   I_TESTRUN_EXTENDED              = ' '
*   I_NO_DEQUEUE_ALL                = ' '
*   I_NO_BOPF_TRANS_MGR_CALLS       = ABAP_FALSE
* IMPORTING
*   SALES_HEADER_OUT                =
*   SALES_HEADER_STATUS             =
  TABLES
    RETURN                          = RETURN
   ITEM_IN                         = ITEM
   ITEM_INX                        = items_inx
*   SCHEDULE_IN                     =
*   SCHEDULE_INX                    =
*   PARTNERS                        =  PATNER
*   PARTNERCHANGES                  =
*   PARTNERADDRESSES                =
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
*   CONDITIONS_IN                   =
*   CONDITIONS_INX                  =
*   SALES_CONTRACT_IN               =
*   SALES_CONTRACT_INX              =
*   EXTENSIONIN                     =
*   ITEMS_EX                        =
*   SCHEDULE_EX                     =
*   BUSINESS_EX                     =
*   INCOMPLETE_LOG                  =
*   EXTENSIONEX                     =
*   CONDITIONS_EX                   =
*   SALES_SCHED_CONF_IN             =
*   DEL_SCHEDULE_EX                 =
*   DEL_SCHEDULE_IN                 =
*   DEL_SCHEDULE_INX                =
*   CORR_CUMQTY_IN                  =
*   CORR_CUMQTY_INX                 =
*   CORR_CUMQTY_EX                  =
*   PARTNERS_EX                     =
*   TEXTHEADERS_EX                  =
*   TEXTLINES_EX                    =
*   BATCH_CHARC                     =
*   CAMPAIGN_ASGN                   =
*   CONDITIONS_KONV_EX              =
* EXCEPTIONS
*   INCOV_NOT_IN_ITEM               = 1
*   OTHERS                          = 2
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.

CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
 EXPORTING
   WAIT          = 'X'
* IMPORTING
*   RETURN        =
          .

*ENDIF.

    ITAB_VBELN-VBELN = wa_tab-vbeln.
*    ITAB_VBELN-NO = ITAB_HDR-NO.

    LOOP AT RETURN WHERE TYPE = 'E' OR TYPE = 'A' or TYPE = 'S' OR TYPE = 'W'.
      ITAB_VBELN-MESG = RETURN-MESSAGE.
      APPEND ITAB_VBELN.
    ENDLOOP.

    IF SY-SUBRC <> 0.
      APPEND ITAB_VBELN.
    ENDIF.
    CLEAR ITAB_VBELN.

  ENDLOOP.
*CLEAR wa_tab3.
*ENDLOOP.
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
