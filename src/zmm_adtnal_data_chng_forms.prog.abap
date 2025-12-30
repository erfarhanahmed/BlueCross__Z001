*&---------------------------------------------------------------------*
*& Include          ZMM_ADTNAL_DATA_CHNG_FORMS
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form F_GET_F4_VAL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM F_GET_F4_VAL .

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
*     PROGRAM_NAME = SYST-CPROG
*     DYNPRO_NUMBER = SYST-DYNNR
      FIELD_NAME = 'P_FILE'
    IMPORTING
      FILE_NAME  = P_FILE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM F_GET_DATA .

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    = I_FIELD_SEPERATOR
      I_LINE_HEADER        = 'X'
      I_TAB_RAW_DATA       = IT_TYPE
      I_FILENAME           = P_FILE
*     I_STEP               = 1
    TABLES
      I_TAB_CONVERTED_DATA = IT_UPLOAD
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC NE 0.
    MESSAGE 'Please check the file name' TYPE 'E'.
    LEAVE TO CURRENT TRANSACTION.
*    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO  WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
  .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_change_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM F_CHANGE_DATA .

  FREE: GT_MESSAGE, GT_RETURN.

  LOOP AT IT_UPLOAD INTO WA_UPLOAD.
*CONVERT MATERIAL NUMBER EXTERNAL TO INTERNAL
    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        INPUT        = WA_UPLOAD-MATERIAL
      IMPORTING
        OUTPUT       = WA_UPLOAD-MATERIAL
      EXCEPTIONS
        LENGTH_ERROR = 1.


    GT_MEINH_WS_UPD-WSMEI = WA_UPLOAD-BATCH_SPEC_UOM.
    GT_MEINH_WS_UPD-ATNAM = WA_UPLOAD-CHAR_NAME.
    GT_MEINH_WS_UPD-ATWRT = WA_UPLOAD-PLAN_VAL..
    GT_MEINH_WS_UPD-XFHDW = WA_UPLOAD-L_BATCH_UOM.
    GT_MEINH_WS_UPD-XBEWW = WA_UPLOAD-VAL_UOM.
    APPEND GT_MEINH_WS_UPD.
    CLEAR: GT_MEINH_WS_UPD.

    GT_MEINH_WS_UPDX-WSMEI = WA_UPLOAD-BATCH_SPEC_UOM.
    GT_MEINH_WS_UPDX-ATNAM = 'X'.
    GT_MEINH_WS_UPDX-ATWRT = 'X'.
    GT_MEINH_WS_UPDX-XFHDW = 'X'.
    GT_MEINH_WS_UPDX-XBEWW = 'X'.
    APPEND GT_MEINH_WS_UPDX.
    CLEAR: GT_MEINH_WS_UPDX.


    CALL FUNCTION 'VBWS_UOM_MAINTAIN_DARK'
      EXPORTING
        I_MATNR               = WA_UPLOAD-MATERIAL "I_MATNR
        I_KZWSM               = WA_UPLOAD-UOM    "I_KZWSM
        I_KZWSMX              = 'X'
        I_TYPE_OF_BLOCK       = 'E'
        I_EXIT_BY_FIRST_ERROR = 'X' "COMMENTED
*       I_LIST_ERRORS_ONLY    = ' '
        I_USER                = SY-UNAME
        I_BUFFER_REFRESH      = 'X'     "COMMENTED
*       I_UPDATE_BUFFER_ONLY  = ' '
        I_NO_UPDATE           = ''    "TEST MODE = 'X' , DATABASE UPDATE = ' '.
*       I_RFC_SENDER          = I_RFC_SENDER
*       I_CALLING_METHOD      = I_CALLING_METHOD
*     IMPORTING
*       E_KZWSM               = E_KZWSM
*       E_KZWSM_OLD           = E_KZWSM_OLD
      TABLES
        I_MEINH_WS_UPD        = GT_MEINH_WS_UPD
        I_MEINH_WS_UPDX       = GT_MEINH_WS_UPDX
        I_MEINH_WS_SFN        = I_MEINH_WS_SFN
        I_MEINH_WS_SFNX       = I_MEINH_WS_SFNX
        E_MEINH_WS            = GT_MEINH_WS
        E_MEINH               = GT_MEINH
        E_MEINH_OLD           = E_MEINH_OLD
        E_MESSAGE             = GT_MESSAGE
        E_RETURN              = GT_RETURN
      EXCEPTIONS
        ERROR                 = 1.

    IF SY-SUBRC = 0.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          WAIT = 'X'.
*   IMPORTING
*     RETURN        = RETURN
    ENDIF.

*Append messages to another internal table for display process
    APPEND LINES OF GT_RETURN TO GT_RETURN1.

    CLEAR : WA_UPLOAD.
    REFRESH: GT_MEINH_WS_UPD , GT_MEINH_WS_UPDX.
  ENDLOOP.

  REFRESH: GT_RETURN.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_Disp_msg
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM F_DISP_MSG .

* DISPLAY MESSAGE
  CLEAR: GV_NO.
  LOOP AT GT_RETURN1 .
    GV_NO = GV_NO + 1 .

    GS_MSG-SR_NO = GV_NO.
    GS_MSG-ID    = GT_RETURN1-TYPE.
    GS_MSG-MESSAGE   = GT_RETURN1-MESSAGE.
    APPEND GS_MSG TO GT_MSG.

*    WRITE:/ SPACE,1(5) GV_NO,10(80) GT_RETURN1-MESSAGE .  "GT_RETURN-ID
    CLEAR: GS_MSG, GT_RETURN1.
  ENDLOOP.

  CLEAR: GV_NO.
  REFRESH :  GT_RETURN1.

  PERFORM : F_POP_MSG_FCAT. "fieldcat populate
  PERFORM : F_DISP_MSG_ALV. "Dispaly message

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_pop_msg_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM F_POP_MSG_FCAT .

  DATA : COUNT     TYPE CHAR4.
  CLEAR: COUNT.

  COUNT = COUNT + 1.
  GS_FCAT-COL_POS = COUNT.
  GS_FCAT-FIELDNAME = 'SR_NO'.
  GS_FCAT-TABNAME = 'GT_MSG'.
  GS_FCAT-SELTEXT_M = 'Sr No'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR: GS_FCAT.

  GS_FCAT-COL_POS = COUNT.
  GS_FCAT-FIELDNAME = 'ID'.
  GS_FCAT-TABNAME = 'GT_MSG'.
  GS_FCAT-SELTEXT_L = 'Message Type'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-COL_POS = COUNT.
  GS_FCAT-FIELDNAME = 'MESSAGE'.
  GS_FCAT-TABNAME = 'GT_MSG'.
  GS_FCAT-SELTEXT_L = 'Messages'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

*  *******************  POP LAYOUT **************
  GS_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
  GS_LAYOUT-ZEBRA = 'X'.
* **********************************************

ENDFORM.
*&---------------------------------------------------------------------*
*& Form F_DISP_MSG_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM F_DISP_MSG_ALV .


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM       = SY-REPID
*      I_CALLBACK_PF_STATUS_SET = 'F_PF_STATUS_SET'
*     I_CALLBACK_USER_COMMAND  = ' '
*     I_CALLBACK_TOP_OF_PAGE   = ' '
      IS_LAYOUT                = GS_LAYOUT
      IT_FIELDCAT              = GT_FCAT
    TABLES
      T_OUTTAB                 = GT_MSG
    EXCEPTIONS
      PROGRAM_ERROR            = 1.

ENDFORM.

*FORM F_PF_STATUS_SET USING GT_EXTAB TYPE SLIS_T_EXTAB.
*  REFRESH: GT_EXTAB.
*
*  SET PF-STATUS 'ZSTANDARD' EXCLUDING GT_EXTAB.  "Created Custom menu status
*ENDFORM.
