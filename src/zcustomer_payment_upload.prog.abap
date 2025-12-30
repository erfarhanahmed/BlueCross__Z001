*&---------------------------------------------------------------------*
*& Report ZCUSTOMER_PAYMENT_UPLOAD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZCUSTOMER_PAYMENT_UPLOAD.
types: BEGIN OF ts_zcust_payment,
        bu_partner TYPE zcust_payment-bu_partner,
        vkorg      TYPE zcust_payment-vkorg,
        vtweg      TYPE zcust_payment-vtweg,
        spart      TYPE zcust_payment-spart,
        zterm      TYPE zcust_payment-zterm,
        kukla TYPE kna1-kukla,
        msg type char50,
      END OF ts_zcust_payment.


 data:it_raw       TYPE truxs_t_text_data,
       it_file type STANDARD TABLE OF zcust_payment.
 DATA:lt_final  type STANDARD TABLE OF ts_zcust_payment,
      ls_final type ts_zcust_payment.
*      ls_kna1 type ls_knal.
data: ls_fcat type slis_fieldcat_alv,
        lt_fcat type STANDARD TABLE OF slis_fieldcat_alv.
DATA: kna1     TYPE  kna1,
            knb1     TYPE  knb1,
            knal TYPE kna1-kukla,
            knvv     TYPE knvv,
            i_kna1   TYPE kna1,
            i_knb1   TYPE  knb1,
            fknas    TYPE STANDARD TABLE OF fknas,
            fknvl    TYPE STANDARD TABLE OF fknvl,
            fknb5    TYPE STANDARD TABLE OF fknb5,
            fknbk    TYPE STANDARD TABLE OF fknbk,
            fknva    TYPE STANDARD TABLE OF fknva,
            fknvd    TYPE STANDARD TABLE OF fknvd,
            fknvi    TYPE STANDARD TABLE OF fknvi,
            fknvk    TYPE STANDARD TABLE OF fknvk,
            i_fknvl  TYPE STANDARD TABLE OF fknvl,
            fknvp    TYPE STANDARD TABLE OF fknvp,
            fknvs    TYPE STANDARD TABLE OF fknvs,
            fknza    TYPE STANDARD TABLE OF fknza,
            i_fknas  TYPE STANDARD TABLE OF fknas,
            i_fknb5  TYPE STANDARD TABLE OF fknb5,
            i_fknbk  TYPE STANDARD TABLE OF fknbk,
            i_fknva  TYPE STANDARD TABLE OF fknva,
            i_fknvd  TYPE STANDARD TABLE OF fknvd,
            i_fknvi  TYPE STANDARD TABLE OF fknvi,
            i_fknvk  TYPE STANDARD TABLE OF fknvk,
            i_fknvl1 TYPE STANDARD TABLE OF fknvl,
            i_fknvp  TYPE STANDARD TABLE OF fknvp,
            i_fknvs  TYPE STANDARD TABLE OF fknvs,
            i_fknza  TYPE STANDARD TABLE OF fknza.




SELECTION-SCREEN BEGIN OF  BLOCK b1 WITH FRAME TITLE text-001.
  PARAMETERS: p_file LIKE rlgrap-filename.
  SELECTION-SCREEN SKIP 2.
  SELECTION-SCREEN PUSHBUTTON 10(20) TEXT-002 USER-COMMAND cl1.
SELECTION-SCREEN END OF block b1.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  CALL FUNCTION 'F4_FILENAME'
    IMPORTING
      file_name = p_file.


AT SELECTION-SCREEN.
  IF p_file IS INITIAL AND sy-ucomm = 'ONLI'.
    MESSAGE 'Please select Input file' TYPE 'E'.
  ENDIF.

  IF sy-ucomm = 'CL1'.
    PERFORM show_template.
  ENDIF.
START-OF-SELECTION.
PERFORM get_data.
PERFORM update_data.
PERFORM dis_data.

form get_data.
 CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
*     I_LINE_HEADER        = 'X'
      i_tab_raw_data       = it_raw
      i_filename           = p_file
    TABLES
*     I_TAB_CONVERTED_DATA = IT_BPDETAILS
      i_tab_converted_data = it_file
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
 delete it_file INDEX 1.
 ENDFORM.

*&---------------------------------------------------------------------*
*& Form show_template
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM show_template .

  DATA : lv_filename TYPE string,
         lv_path     TYPE string,
         lv_file     TYPE ibipparms-path,
         lv_fullpath TYPE string.

  DATA: "xexcel TYPE ty_excel,
    "iexcel TYPE TABLE OF ty_excel,
    lt_excel_structure      TYPE TABLE OF zcust_payment, "ZEXCL_STRUCT1,"ty_excel_structure,
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
      default_file_name = 'Cust_paymentterms_Template.xlsx' ""'Test.xlsx'
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
*&---------------------------------------------------------------------*
*& Form update_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM update_data .
 loop at it_file ASSIGNING FIELD-SYMBOL(<fs>).
   CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
     EXPORTING
       input         = <fs>-bu_partner
    IMPORTING
      OUTPUT        = <fs>-bu_partner.
             .

   select SINGLE * from knvv INTO @DATA(ls_knvv)
     WHERE kunnr = @<fs>-bu_partner and VKORG = @<fs>-VKORG and vtweg = @<fs>-vtweg and  spart = @<fs>-spart.
     ls_knvv-zterm = <fs>-zterm.
     MOVE-CORRESPONDING ls_knvv to knvv.
*select SINGLE * from  kna1 into data(ls_kna1) WHERE kukla = CustomerClass.

 SELECT SINGLE kukla
  FROM kna1
  INTO @DATA(lv_kukla)
 WHERE kunnr = @<fs>-bu_partner.
CALL FUNCTION 'CUSTOMER_UPDATE'
        EXPORTING
          i_kna1  = kna1
          i_knb1  = knb1
          i_knvv  = knvv
          i_ykna1 = i_kna1
          i_yknb1 = i_knb1
        TABLES
          t_xknas = fknas
          t_xknb5 = fknb5
          t_xknbk = fknbk
          t_xknva = fknva
          t_xknvd = fknvd
          t_xknvi = fknvi
          t_xknvk = fknvk
          t_xknvl = i_fknvl
          t_xknvp = fknvp
          t_xknvs = fknvs
          t_xknza = fknza
          t_yknas = i_fknas
          t_yknb5 = i_fknb5
          t_yknbk = i_fknbk
          t_yknva = i_fknva
          t_yknvd = i_fknvd
          t_yknvi = i_fknvi
          t_yknvk = i_fknvk
          t_yknvl = i_fknvl1
          t_yknvp = i_fknvp
          t_yknvs = i_fknvs
          t_yknza = i_fknza
*         T_XKNA1_ADDR        =
*         T_YKNA1_ADDR        =
*         T_XKNVA_ADDR        =
*         T_YKNVA_ADDR        =
*         T_XKNVV_ADDR        =
*         T_YKNVV_ADDR        =
*         T_XKNVI_ADDR        =
*         T_YKNVI_ADDR        =
*         T_XKNADDR_EXT       =
*         T_YKNADDR_EXT       =
        .

IF  sy-subrc = 0.
commit work.
 MOVE-CORRESPONDING <fs> to ls_final.
 ls_final-msg = 'Successfully updated'.
 APPEND ls_final to lt_final.
else.
  ROLLBACK WORK.
ENDIF.
endloop.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form dis_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM dis_data .


  ls_fcat-col_pos = '1'.
  ls_fcat-fieldname = 'BU_PARTNER'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'Business Partner'.
  append ls_fcat to lt_fcat.
  CLEAr ls_fcat.

   ls_fcat-col_pos = '2'.
  ls_fcat-fieldname = 'kukla'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'Customer Class'.
  append ls_fcat to lt_fcat.
  CLEAr ls_fcat.
*   ls_fcat-col_pos = '3'.
*  ls_fcat-fieldname = 'VTWEG'.
*  ls_fcat-tabname = 'LT_FINAL'.
*  ls_fcat-seltext_l = 'Dist Channel'.
*  append ls_fcat to lt_fcat.
*  CLEAr ls_fcat.
*   ls_fcat-col_pos = '4'.
*  ls_fcat-fieldname = 'SPART'.
*  ls_fcat-tabname = 'LT_FINAL'.
*  ls_fcat-seltext_l = 'Division'.
*  append ls_fcat to lt_fcat.
*  CLEAr ls_fcat.
*   ls_fcat-col_pos = '5'.
*  ls_fcat-fieldname = 'ZTERM'.
*  ls_fcat-tabname = 'LT_FINAL'.
*  ls_fcat-seltext_l = 'Payment Term'.
* append ls_fcat to lt_fcat.
*  CLEAr ls_fcat.
*   ls_fcat-col_pos = '6'.
*  ls_fcat-fieldname = 'MSG'.
*  ls_fcat-tabname = 'LT_FINAL'.
*  ls_fcat-seltext_l = 'Message'.
* append ls_fcat to lt_fcat.
*  CLEAr ls_fcat.
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING

   I_CALLBACK_PROGRAM                = sy-cprog
*   I_CALLBACK_PF_STATUS_SET          = ' '
*   I_CALLBACK_USER_COMMAND           = ' '
*   I_CALLBACK_TOP_OF_PAGE            = ' '
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
*   I_STRUCTURE_NAME                  =
*   I_BACKGROUND_ID                   = ' '
*   I_GRID_TITLE                      =
*   I_GRID_SETTINGS                   =
*   IS_LAYOUT                         =
   IT_FIELDCAT                       = lt_fcat
*   IT_EXCLUDING                      =
*   IT_SPECIAL_GROUPS                 =
*   IT_SORT                           =
*   IT_FILTER                         =
*   IS_SEL_HIDE                       =
*   I_DEFAULT                         = 'X'
*   I_SAVE                            = ' '
*   IS_VARIANT                        =
*   IT_EVENTS                         =
*   IT_EVENT_EXIT                     =
*   IS_PRINT                          =
*   IS_REPREP_ID                      =
*   I_SCREEN_START_COLUMN             = 0
*   I_SCREEN_START_LINE               = 0
*   I_SCREEN_END_COLUMN               = 0
*   I_SCREEN_END_LINE                 = 0
*   I_HTML_HEIGHT_TOP                 = 0
*   I_HTML_HEIGHT_END                 = 0
*   IT_ALV_GRAPHICS                   =
*   IT_HYPERLINK                      =
*   IT_ADD_FIELDCAT                   =
*   IT_EXCEPT_QINFO                   =
*   IR_SALV_FULLSCREEN_ADAPTER        =
*   O_PREVIOUS_SRAL_HANDLER           =
*   O_COMMON_HUB                      =
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER           =
*   ES_EXIT_CAUSED_BY_USER            =
  TABLES
    t_outtab                          = lt_final
* EXCEPTIONS
*   PROGRAM_ERROR                     = 1
*   OTHERS                            = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

ENDFORM.
