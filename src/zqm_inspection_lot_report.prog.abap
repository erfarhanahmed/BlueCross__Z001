

report ZQM_INSPECTION_LOT_REPORT.

TABLES :SSCRFIELDS.
INCLUDE <ICON>.

DATA: FILE     TYPE IBIPPARMS-PATH.


SELECTION-SCREEN:BEGIN OF BLOCK A WITH FRAME.
  PARAMETERS:PATH  TYPE RLGRAP-FILENAME .
SELECTION-SCREEN:END OF BLOCK A.
SELECTION-SCREEN FUNCTION KEY 1.

AT SELECTION-SCREEN.
  IF SSCRFIELDS-UCOMM = 'FC01'.
    PERFORM DOWNLOAD.
  ENDIF.

INITIALIZATION.
  CONCATENATE ICON_NEXT_OBJECT 'Template Download' INTO SSCRFIELDS-FUNCTXT_01.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR PATH.
   CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = sy-repid
      dynpro_number = sy-dynnr
      field_name    = 'PATH'
    IMPORTING
      file_name     = path.

start-of-selection.
PERFORM get_file_data.

perform alv_dis.

start-of-selection.


FORM GET_FILE_DATA .

 DATA: lt_raw  TYPE truxs_t_text_data,
      lt_data TYPE TABLE OF ZINSP_str.

CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
  EXPORTING
    i_tab_raw_data       = Lt_raw
    i_filename           = PATH
    i_line_header        = 'X'  " if first row has headers
     I_FIELD_SEPERATOR    = 'X'
  TABLES
    i_tab_converted_data = Lt_DATA[]
  EXCEPTIONS
    conversion_failed    = 1
    OTHERS               = 2.
IF sy-subrc <> 0.
  MESSAGE 'Excel upload failed' TYPE 'E'.
ENDIF.

IF LT_DATA IS NOT INITIAL.
data:it_final TYPE TABLE OF zinsp.
*wa_final TYPE it_final.
MOVE-CORRESPONDING lt_data to it_final.

modify zinsp from TABLE it_final.
commit work.
IF sy-subrc = 0.
write: 'Records uploaded sucessfully'.
ENDIF.

ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form DOWNLOAD
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DOWNLOAD .
 DATA : LV_FILENAME TYPE STRING,
         LV_PATH     TYPE STRING,
         LV_FILE     TYPE IBIPPARMS-PATH,
         LV_FULLPATH TYPE STRING.

  DATA:
    LT_EXCEL_STRUCTURE      TYPE TABLE OF Zinsp_str, "ZEXCL_STRUCT1,"ty_excel_structure,
    LR_EXCEL_STRUCTURE      TYPE REF TO DATA,
    LV_CONTENT              TYPE XSTRING,
    LS_STREAM               TYPE /IWBEP/IF_MGW_CORE_SRV_RUNTIME=>TY_S_MEDIA_RESOURCE,
    LO_TABLE_ROW_DESCRIPTOR TYPE REF TO CL_ABAP_STRUCTDESCR,
    LO_SOURCE_TABLE_DESCR   TYPE REF TO CL_ABAP_TABLEDESCR,
    V_FILENAME              TYPE BAPIDOCID,
    LS_HEADER               TYPE IHTTPNVP.


  CALL METHOD CL_GUI_FRONTEND_SERVICES=>FILE_SAVE_DIALOG
    EXPORTING
      WINDOW_TITLE      = 'Enter File Name'
      DEFAULT_EXTENSION = 'XLSX'
      DEFAULT_FILE_NAME = 'Inspection_create_Template.xls' ""'Test.xlsx'
    CHANGING
      FILENAME          = LV_FILENAME
      PATH              = LV_PATH
      FULLPATH          = LV_FULLPATH.

  LV_FILE = LV_FULLPATH.

  GET REFERENCE OF LT_EXCEL_STRUCTURE INTO LR_EXCEL_STRUCTURE.
  DATA(LO_ITAB_SERVICES) = CL_SALV_ITAB_SERVICES=>CREATE_FOR_TABLE_REF( LR_EXCEL_STRUCTURE ).
  LO_SOURCE_TABLE_DESCR ?= CL_ABAP_TABLEDESCR=>DESCRIBE_BY_DATA_REF( LR_EXCEL_STRUCTURE ).
  LO_TABLE_ROW_DESCRIPTOR ?= LO_SOURCE_TABLE_DESCR->GET_TABLE_LINE_TYPE( ).
  DATA(LT_FIELDS) = LO_TABLE_ROW_DESCRIPTOR->GET_DDIC_FIELD_LIST( P_LANGU = SY-LANGU ).

  DATA(LO_TOOL_XLS) = CL_SALV_EXPORT_TOOL_ATS_XLS=>CREATE_FOR_EXCEL(
    EXPORTING
      R_DATA = LR_EXCEL_STRUCTURE ).

  DATA(LO_CONFIG) = LO_TOOL_XLS->CONFIGURATION( ).
  LOOP AT LT_FIELDS ASSIGNING FIELD-SYMBOL(<LFS_FIELD>) .
    LO_CONFIG->ADD_COLUMN(
      EXPORTING
        HEADER_TEXT  = CONV STRING( <LFS_FIELD>-SCRTEXT_L )
        FIELD_NAME   = CONV STRING( <LFS_FIELD>-FIELDNAME )
        DISPLAY_TYPE = IF_SALV_BS_MODEL_COLUMN=>UIE_TEXT_VIEW ).
  ENDLOOP .

  LO_TOOL_XLS->READ_RESULT( IMPORTING CONTENT = LV_CONTENT ).

  DATA : LT_BINARY_TAB TYPE TABLE OF SDOKCNTASC,
         LV_LENGTH     TYPE I.

  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      BUFFER        = LV_CONTENT
    IMPORTING
      OUTPUT_LENGTH = LV_LENGTH
    TABLES
      BINARY_TAB    = LT_BINARY_TAB.

  CALL METHOD CL_GUI_FRONTEND_SERVICES=>GUI_DOWNLOAD
    EXPORTING
*     filename                = 'test.xls'
      BIN_FILESIZE            = LV_LENGTH
      FILENAME                = CONV STRING( LV_FILE ) "'test.xlsx'
      FILETYPE                = 'BIN'
*     write_field_separator   = 'X'
*     header                  = '00'
    CHANGING
      DATA_TAB                = LT_BINARY_TAB "iexcel
    EXCEPTIONS
      FILE_WRITE_ERROR        = 1
      NO_BATCH                = 2
      GUI_REFUSE_FILETRANSFER = 3
      INVALID_TYPE            = 4
      NO_AUTHORITY            = 5
      UNKNOWN_ERROR           = 6
      HEADER_NOT_ALLOWED      = 7
      SEPARATOR_NOT_ALLOWED   = 8
      FILESIZE_NOT_ALLOWED    = 9
      HEADER_TOO_LONG         = 10
      DP_ERROR_CREATE         = 11
      DP_ERROR_SEND           = 12
      DP_ERROR_WRITE          = 13
      UNKNOWN_DP_ERROR        = 14
      ACCESS_DENIED           = 15
      DP_OUT_OF_MEMORY        = 16
      DISK_FULL               = 17
      DP_TIMEOUT              = 18
      FILE_NOT_FOUND          = 19
      DATAPROVIDER_EXCEPTION  = 20
      CONTROL_FLUSH_ERROR     = 21
      NOT_SUPPORTED_BY_GUI    = 22
      ERROR_NO_GUI            = 23
      OTHERS                  = 24.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ALV_DIS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM ALV_DIS .

*DATA: it_fcat TYPE STANDARD TABLE OF slis_fieldcat_alv,
*      wa_fact type slis_fieldcat_alv,
*      is_layout TYPE slis_layout_alv,
*      no type i.
*REFRESH LT_FCAT.
*
*
*  LS_FCAT-COL_POS =  no + 1..
*  LS_FCAT-TABNAME = 'IT_ALV'.
*  LS_FCAT-FIELDNAME = 'ROW'.
*  LS_FCAT-SELTEXT_L = 'Row'.
*  APPEND LS_FCAT TO LT_FCAT.
*   CLEAR ls_fcat.
*   LS_FCAT-COL_POS =  no + 1..
*  LS_FCAT-TABNAME = 'IT_ALV'.
*  LS_FCAT-FIELDNAME = 'LV_STRING1'.
*  LS_FCAT-SELTEXT_L = 'Message'.
*  APPEND LS_FCAT TO LT_FCAT.
*   CLEAR ls_fcat.
*
*
*
*  ls_layout-colwidth_optimize = abap_true.
*CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
* EXPORTING
*   I_CALLBACK_PROGRAM                = sy-cprog
*   is_layout                         = is_layout
*   IT_FIELDCAT                       = lt_fcat
*
*  TABLES
*    T_OUTTAB                          = it_alv
* EXCEPTIONS
*   PROGRAM_ERROR                     = 1
*   OTHERS                            = 2 .
*          .
*IF SY-SUBRC <> 0.
** Implement suitable error handling here
*ENDIF.

ENDFORM.
