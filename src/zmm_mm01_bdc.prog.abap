*&---------------------------------------------------------------------*
*& Report zmm_mm01_bdc
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmm_mm01_bdc.



TYPES: BEGIN OF ty_final,
         matnr TYPE rmmg1-matnr,
         mbrsh TYPE RMMG1-MBRSH,
         mtart TYPE RMMG1-mtart,
         maktx TYPE makt-maktx,
         bmatn TYPE mara-bmatn,
         mfrnr TYPE mara-mfrnr,
         mfrpn TYPE MARA-MFRPN,
         matkl TYPE mara-matkl,
         ekwsl TYPE mara-ekwsl,
         begru TYPE mara-begru,
       END OF ty_final.

DATA: wa_final TYPE ty_final,
      it_final TYPE TABLE OF ty_final.

TABLES :sscrfields.
INCLUDE <icon>.
DATA: file     TYPE ibipparms-path.
DATA: it_fcat   TYPE STANDARD TABLE OF slis_fieldcat_alv,
      wa_fact   TYPE slis_fieldcat_alv,
      is_layout TYPE slis_layout_alv.
DATA : it_bdc TYPE TABLE OF bdcdata,
       wa_bdc TYPE bdcdata.
DATA: it_intern     TYPE TABLE OF  alsmex_tabline,
      wa_intern     TYPE  alsmex_tabline,
      filename      TYPE  rlgrap-filename,
      it_bdcmsgcoll TYPE STANDARD TABLE OF bdcmsgcoll,
      wa_bdcmsgcoll TYPE bdcmsgcoll,
      i_begin_col   TYPE  i,
      i_begin_row   TYPE  i,
      i_end_col     TYPE  i,
      i_end_row     TYPE  i,
      lv_count      TYPE i,
      lv_string     TYPE string,
      lt_fcat       TYPE STANDARD TABLE OF slis_fieldcat_alv,
      ls_fcat       TYPE slis_fieldcat_alv,
      ls_layout     TYPE  slis_layout_alv.
DATA :v_msg TYPE string.
TYPES : BEGIN OF ty_msg,

*          plnnr    TYPE  plnnr,
          matnr    TYPE  matnr,
          msg_type TYPE bdc_mart,
          msg      TYPE string,
        END OF ty_msg.
DATA: it_msg TYPE TABLE OF ty_msg,
      wa_msg TYPE ty_msg.
SELECTION-SCREEN:BEGIN OF BLOCK a WITH FRAME.
  PARAMETERS:path  TYPE rlgrap-filename .
SELECTION-SCREEN:END OF BLOCK a.
SELECTION-SCREEN FUNCTION KEY 1.


AT SELECTION-SCREEN.
  IF sscrfields-ucomm = 'FC01'.
    PERFORM download.
  ENDIF.

INITIALIZATION.
  CONCATENATE icon_next_object 'Template Download' INTO sscrfields-functxt_01.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR path.
  CALL FUNCTION 'F4_FILENAME'
*   EXPORTING
*     PROGRAM_NAME        = SYST-CPROG
*     DYNPRO_NUMBER       = SYST-DYNNR
*     FIELD_NAME          = ' '
    IMPORTING
      file_name = file.
  path = file.

START-OF-SELECTION.
  PERFORM get_file_data.
  PERFORM bdc.
  PERFORM alv_data.

FORM bdc.



  LOOP AT it_final INTO wa_final.

CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
  EXPORTING
    input              = wa_final-matnr
 IMPORTING
   OUTPUT             = wa_final-matnr
* EXCEPTIONS
*   LENGTH_ERROR       = 1
*   OTHERS             = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

    perform bdc_dynpro      using 'SAPLMGMM' '0060'.
    perform bdc_field       using 'BDC_CURSOR'
                                  'RMMG1-MATNR'.
    perform bdc_field       using 'BDC_OKCODE'
                                  '=ENTR'.
    perform bdc_field       using 'RMMG1-MATNR'
                                    wa_final-matnr .  "'110000143-05'.
    perform bdc_field       using 'RMMG1-MBRSH'
                                         wa_final-mbrsh.   " 'P'.
    perform bdc_field       using 'RMMG1-MTART'
                                     wa_final-mtart.    "'ZMFN'.
    perform bdc_dynpro      using 'SAPLMGMM' '0070'.
    perform bdc_field       using 'BDC_CURSOR'
                                  'MSICHTAUSW-DYTXT(01)'.
    perform bdc_field       using 'BDC_OKCODE'
                                  '=ENTR'.
    perform bdc_field       using 'MSICHTAUSW-KZSEL(01)'
                                  'X'.
    perform bdc_dynpro      using 'SAPLMGMM' '3002'.
    perform bdc_field       using 'BDC_OKCODE'
                                  '=BU'.
    perform bdc_field       using 'SKTEXT-MAKTX(01)'
                                      wa_final-maktx.     "'test5'.
    perform bdc_field       using 'MARA-BMATN'
                                        wa_final-bmatn.      "'110000143'.
     perform bdc_field       using 'MARA-MFRPN'
                                  wa_final-MFRPN.
    perform bdc_field       using 'MARA-MFRNR'
                                  wa_final-mfrnr.        "'39000654'.
    perform bdc_field       using 'MARA-MATKL'
                                  wa_final-matkl.           "'11009'.
    perform bdc_field       using 'MARA-EKWSL'
                                  wa_final-ekwsl.     "'1'.
    perform bdc_field       using 'BDC_CURSOR'
                                  'MARA-BEGRU'.
    perform bdc_field       using 'MARA-BEGRU'
                                  wa_final-begru.       "'1'.


    CALL TRANSACTION 'MM01' USING it_bdc
                     MODE 'N'
                     UPDATE 'S'
                   MESSAGES INTO it_bdcmsgcoll.

    LOOP AT it_bdcmsgcoll INTO wa_bdcmsgcoll . "WHERE  msgtyp = 'S' ."msgtyp = 'E' or msgtyp = 'W'.
      CALL FUNCTION 'FORMAT_MESSAGE'
        EXPORTING
          id        = wa_bdcmsgcoll-msgid
          lang      = wa_bdcmsgcoll-msgspra
          no        = wa_bdcmsgcoll-msgnr
          v1        = wa_bdcmsgcoll-msgv1
          v2        = wa_bdcmsgcoll-msgv2
          v3        = wa_bdcmsgcoll-msgv3
          v4        = wa_bdcmsgcoll-msgv4
        IMPORTING
          msg       = v_MSG
        EXCEPTIONS
          not_found = 1.

*      wa_msg-plnnr = wa_final-plnnr.
      wa_msg-matnr = wa_final-matnr.
      wa_msg-msg_type = wa_bdcmsgcoll-msgtyp.
      wa_msg-msg = v_msg.
      APPEND wa_msg TO it_msg.
      CLEAR: wa_msg, v_msg.
    ENDLOOP.
REFRESH : it_bdcmsgcoll , it_bdc.
    CLEAR: wa_final.

  ENDLOOP.
ENDFORM.
*perform bdc_transaction using 'C201'.
*
*perform close_group.

FORM bdc_field USING fnam fval.
  wa_bdc-fnam = fnam.
  wa_bdc-fval = fval.
  APPEND wa_bdc TO it_bdc.
  CLEAR:wa_bdc .
ENDFORM.

FORM bdc_dynpro USING program dynpro.
*  CLEAR it_bdc.
  wa_bdc-program  = program.
  wa_bdc-dynpro   = dynpro.
  wa_bdc-dynbegin = 'X'.
  APPEND wa_bdc TO it_bdc.
  CLEAR:wa_bdc.
ENDFORM.

FORM get_file_data .

  REFRESH it_final.
  DATA:lv_string TYPE char16.
  filename = path.
  i_begin_col = '1'.
  i_begin_row = 2.
  i_end_col   = 9999.
  i_end_row   = 9999.

  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = filename
      i_begin_col             = i_begin_col
      i_begin_row             = i_begin_row
      i_end_col               = i_end_col
      i_end_row               = i_end_row
    TABLES
      intern                  = it_intern
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.



  LOOP AT it_intern INTO wa_intern.

    CASE wa_intern-col.
      WHEN '0001'.
        wa_final-matnr = wa_intern-value.
        WHEN '0002'.
        wa_final-mbrsh  = wa_intern-value.
        WHEN '0003'.
        wa_final-mtart  = wa_intern-value.
      WHEN '0004'.
        wa_final-maktx  = wa_intern-value.
      WHEN '0005'.
        wa_final-bmatn = wa_intern-value.
      WHEN '0006'.
        wa_final-mfrnr = wa_intern-value.
         WHEN '0007'.
        wa_final-MFRPN = wa_intern-value.
      WHEN '0008'.
        wa_final-matkl  = wa_intern-value.
      WHEN '0009'.
        wa_final-ekwsl = wa_intern-value.
      WHEN '0010'.
        wa_final-begru = wa_intern-value.
*      WHEN '0008'.
*        wa_final-verwe_1 = wa_intern-value.
*      WHEN '0009'.
*        wa_final-Statu = wa_intern-value.
*      WHEN '0010'.

    ENDCASE.
    AT END OF row.
      APPEND wa_final TO it_final.
      CLEAR :wa_final,lv_string.
    ENDAT.
    CLEAR wa_intern.
  ENDLOOP.
ENDFORM.


FORM alv_data .
*  ls_fcat-col_pos = '1'.
**  LS_FCAT-TABNAME = 'IT_ALV'.
*  ls_fcat-fieldname = 'PLNNR'.
*  ls_fcat-seltext_l = 'Phase'.
*  APPEND ls_fcat TO lt_fcat.
*  CLEAR ls_fcat.

  ls_fcat-col_pos = '2'.
*  LS_FCAT-TABNAME = 'IT_ALV'.
  ls_fcat-fieldname = 'MATNR'.
  ls_fcat-seltext_l = 'Resource'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos = '3'.
*  LS_FCAT-TABNAME = 'IT_ALV'.
  ls_fcat-fieldname = 'MSG_TYPE'.
  ls_fcat-seltext_l = 'Message Type'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos = '4'.
*  LS_FCAT-TABNAME = 'IT_ALV'.
  ls_fcat-fieldname = 'MSG'.
  ls_fcat-seltext_l = 'Message'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_layout-colwidth_optimize = abap_true.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-cprog
      is_layout          = is_layout
      it_fieldcat        = lt_fcat
    TABLES
      t_outtab           = it_msg
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.


FORM download .

  DATA : lv_filename TYPE STRING,
         lv_path     TYPE STRING,
         lv_file     TYPE ibipparms-path,
         lv_fullpath TYPE STRING.

  DATA:
    lt_excel_structure      TYPE TABLE OF zstr_mm01, "ZEXCL_STRUCT1,"ty_excel_structure,
    lr_excel_structure      TYPE REF TO DATA,
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
      default_file_name = 'MM01_create_Template.xlsx' ""'Test.xlsx'
    CHANGING
      filename          = lv_filename
      PATH              = lv_path
      fullpath          = lv_fullpath.

  lv_file = lv_fullpath.

  GET REFERENCE OF lt_excel_structure INTO lr_excel_structure.
  DATA(lo_itab_services) = cl_salv_itab_services=>create_for_table_ref( lr_excel_structure ).
  lo_source_table_descr ?= cl_abap_tabledescr=>describe_by_data_ref( lr_excel_structure ).
  lo_table_row_descriptor ?= lo_source_table_descr->get_table_line_type( ).
  DATA(lt_fields) = lo_table_row_descriptor->get_ddic_field_list( p_langu = sy-langu ).

  DATA(lo_tool_xls) = cl_salv_export_tool_ats_xls=>create_for_excel(
    EXPORTING
      r_data = lr_excel_structure ).

  DATA(lo_config) = lo_tool_xls->configuration( ).
  LOOP AT lt_fields ASSIGNING FIELD-SYMBOL(<lfs_field>) .
    lo_config->add_column(
      EXPORTING
        header_text  = CONV STRING( <lfs_field>-scrtext_l )
        field_name   = CONV STRING( <lfs_field>-fieldname )
        display_type = if_salv_bs_model_column=>uie_text_view ).
  ENDLOOP .

  lo_tool_xls->read_result( IMPORTING content = lv_content ).

  DATA : lt_binary_tab TYPE TABLE OF sdokcntasc,
         lv_length     TYPE I.

  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      BUFFER        = lv_content
    IMPORTING
      output_length = lv_length
    TABLES
      binary_tab    = lt_binary_tab.

  CALL METHOD cl_gui_frontend_services=>gui_download
    EXPORTING
*     filename                = 'test.xls'
      bin_filesize            = lv_length
      filename                = CONV STRING( lv_file ) "'test.xlsx'
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
