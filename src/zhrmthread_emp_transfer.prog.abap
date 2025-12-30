*&---------------------------------------------------------------------*
*& Report ZHRMTHREAD_EMP_SEPARATE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZHRMTHREAD_EMP_TRANSFER.
TABLES: PERNR,PA0000.

DATA:LV_DATE_LOW  TYPE CHAR10,
     LV_DATE_HIGH TYPE CHAR10.

TYPES: BEGIN OF TY_EMPOYEE,
         serialNumber         TYPE I,
         COMPANYCODE           TYPE STRING,    "added
         EMPLOYEECODE          TYPE STRING,
         TRANSFERPROMOTIONTYPE TYPE STRING,
         DATEOFEVENT           TYPE STRING,
         DATEOFEFFECT          TYPE STRING,
         FROMENTITY            TYPE STRING,
         TOENTITY              TYPE STRING,
       END OF TY_EMPOYEE.

TYPES: BEGIN OF TY_RAW,
         serialNumber         TYPE I,
         COMPANYCODE           TYPE STRING,    "added
         EMPLOYEECODE          TYPE STRING,
         TRANSFERPROMOTIONTYPE TYPE STRING,
         DATEOFEVENT           TYPE STRING,
         DATEOFEFFECT          TYPE STRING,
         FROMENTITY            TYPE STRING,
         TOENTITY              TYPE STRING,
       END OF TY_RAW.

TYPES: TY_RAW_TAB      TYPE STANDARD TABLE OF TY_RAW      WITH EMPTY KEY,
       TY_EMPLOYEE_TAB TYPE STANDARD TABLE OF TY_EMPOYEE  WITH EMPTY KEY.

TYPES : BEGIN OF TY_MSG,
          EMPLOYEECODE      TYPE STRING,
          FIRSTNAME         TYPE STRING,
          LASTNAME          TYPE STRING,
          DATEOFEVENT       TYPE STRING,
          DATEOFEFFECT      TYPE STRING,
          "GENDER               TYPE STRING,
          "EXIT_DATE            TYPE STRING,
          "EMPLOYEE_STATUS_CODE TYPE STRING,
          "EMPLOYEE_STATUS_NAME TYPE STRING,
          PAYROLL_AREA_CODE TYPE STRING,
          MSG_TYPE          TYPE BDC_MART,
          MSG               TYPE STRING,
        END OF TY_MSG.

TYPES: BEGIN OF TY_TOKEN,
         ACCESS_TOKEN TYPE STRING,
         TOKEN_TYPE   TYPE STRING,
         EXPIRES_IN   TYPE I,
         USERNAME     TYPE STRING,
         DBNAME       TYPE STRING,
       END OF TY_TOKEN.

DATA: LS_P0000  TYPE P0000,
      LS_P0001  TYPE P0001,
      LS_RET    TYPE BAPIRETURN1,
      LS_RET_01 TYPE BAPIRETURN1,
      LV_SUBRC  TYPE SY-SUBRC,
      LS_FCAT   TYPE SLIS_FIELDCAT_ALV,
      LS_LAYOUT TYPE SLIS_LAYOUT_ALV,
      IS_LAYOUT TYPE SLIS_LAYOUT_ALV,
      IT_MSG    TYPE TABLE OF TY_MSG,
      WA_MSG    TYPE TY_MSG,
      V_MSG     TYPE STRING,
      LT_FCAT   TYPE STANDARD TABLE OF SLIS_FIELDCAT_ALV.

DATA: GV_TOKEN    TYPE STRING,
      GT_EMPLOYEE TYPE TY_EMPLOYEE_TAB.

DATA: LV_JSON TYPE STRING,
      LV_SP   TYPE STRING,
      LV_EMP  TYPE STRING.

CONSTANTS:
  GC_TOKEN_URL TYPE STRING VALUE 'https://apipoint.hrmthread.com/hrmthreadapi/api/v1/Token',
  GC_DATA_URL  TYPE STRING VALUE 'https://apipoint.hrmthread.com/hrmthreadapi/api/v1/CommonAPI'.

CONSTANTS:
  GC_USERNAME    TYPE STRING VALUE '200',
  GC_PASSWORD    TYPE STRING VALUE '3644a684f98ea8fe223c713b77189a77',
  GC_CLIENTKEY   TYPE STRING VALUE 'bclpl',
  GC_COMPANYCODE TYPE STRING VALUE 'bclpl'.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-T01.
  SELECT-OPTIONS: P_SEPDT FOR SY-DATUM.
  PARAMETERS: P_PERNR TYPE PERNR_D,
              P_MASSN TYPE P0000-MASSN,
              P_MASSG TYPE P0000-MASSG.
SELECTION-SCREEN END OF BLOCK B1.

START-OF-SELECTION.

  PERFORM GET_TOKEN USING GC_TOKEN_URL CHANGING GV_TOKEN.

  LV_DATE_LOW  = |{ P_SEPDT-LOW  DATE = ISO }|.

  IF P_SEPDT-HIGH IS INITIAL.
    LV_DATE_HIGH =  LV_DATE_LOW .
  ELSE.
    LV_DATE_HIGH = |{ P_SEPDT-HIGH DATE = ISO }|.
  ENDIF.

  LV_SP  = |[employeeTransfer] 'bclpl','{ LV_DATE_LOW }','{ LV_DATE_HIGH }'|.
  LV_EMP = ''.

  PERFORM CALL_EMPLOYEE_API   USING GC_DATA_URL GV_TOKEN LV_SP LV_EMP CHANGING LV_JSON.
  PERFORM PARSE_EMPLOYEE_JSON USING LV_JSON CHANGING GT_EMPLOYEE.
  PERFORM EMP_TRANSFER      CHANGING GT_EMPLOYEE.
  PERFORM EMPLOY_DATA_STATUS .



*&---------------------------------------------------------------------*
*& Form GET_TOKEN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GC_TOKEN_URL
*&      <-- GV_TOKEN
*&---------------------------------------------------------------------*
FORM GET_TOKEN USING    IV_URL    TYPE STRING
               CHANGING EV_TOKEN  TYPE STRING.

  DATA: LO_CLIENT  TYPE REF TO IF_HTTP_CLIENT,
        LO_REQUEST TYPE REF TO IF_HTTP_REQUEST,
        LV_BODY    TYPE STRING,
        LV_CODE    TYPE I,
        LV_REASON  TYPE STRING,
        LV_JSON    TYPE STRING,
        LS_TOK     TYPE TY_TOKEN.

  CLEAR EV_TOKEN.

  TRY.
      CL_HTTP_CLIENT=>CREATE_BY_URL(
        EXPORTING
          URL    = IV_URL
        IMPORTING
          CLIENT = LO_CLIENT ).

      LO_REQUEST = LO_CLIENT->REQUEST.

      LV_BODY = |grant_type=password| &&
                |&Username={ CL_HTTP_UTILITY=>ESCAPE_URL( GC_USERNAME ) }| &&
                |&Password={ CL_HTTP_UTILITY=>ESCAPE_URL( GC_PASSWORD ) }| &&
                |&clientKey={ CL_HTTP_UTILITY=>ESCAPE_URL( GC_CLIENTKEY ) }| &&
                |&companyCode={ CL_HTTP_UTILITY=>ESCAPE_URL( GC_COMPANYCODE ) }|.

      LO_REQUEST->SET_METHOD( 'POST' ).
      LO_REQUEST->SET_HEADER_FIELD( NAME = 'Content-Type' VALUE = 'application/x-www-form-urlencoded' ).
      LO_REQUEST->SET_HEADER_FIELD( NAME = 'Accept' VALUE = 'application/json' ).
      LO_REQUEST->SET_CDATA( LV_BODY ).

      LO_CLIENT->SEND( ).
      LO_CLIENT->RECEIVE( ).

      LO_CLIENT->RESPONSE->GET_STATUS( IMPORTING CODE = LV_CODE REASON = LV_REASON ).
      IF LV_CODE <> 200.
        WRITE: / 'Token call failed: HTTP', LV_CODE, LV_REASON.
        RETURN.
      ENDIF.

      LV_JSON = LO_CLIENT->RESPONSE->GET_CDATA( ).
      CLEAR LS_TOK.
      /UI2/CL_JSON=>DESERIALIZE( EXPORTING JSON = LV_JSON CHANGING DATA = LS_TOK ).
      EV_TOKEN = LS_TOK-ACCESS_TOKEN.

    CATCH CX_ROOT INTO DATA(LX1).
      WRITE: / 'Exception in GET_TOKEN:', LX1->GET_TEXT( ).
      CLEAR EV_TOKEN.
  ENDTRY.


ENDFORM.

FORM CALL_EMPLOYEE_API USING IV_URL    TYPE STRING
                             IV_TOKEN  TYPE STRING
                             IV_SP     TYPE STRING
                             IV_EMP    TYPE STRING
                    CHANGING EV_JSON   TYPE STRING.

  DATA: LO_CLIENT  TYPE REF TO IF_HTTP_CLIENT,
        LO_REQUEST TYPE REF TO IF_HTTP_REQUEST,
        LV_CODE    TYPE I,
        LV_REASON  TYPE STRING,
        LV_AUTH    TYPE STRING,
        LV_BODY    TYPE STRING.

  CLEAR EV_JSON.

  TRY.
      CL_HTTP_CLIENT=>CREATE_BY_URL(
        EXPORTING
          URL    = IV_URL
        IMPORTING
          CLIENT = LO_CLIENT ).

      LO_REQUEST = LO_CLIENT->REQUEST.
      CONCATENATE 'Bearer' IV_TOKEN INTO LV_AUTH SEPARATED BY SPACE.

      LV_BODY = |SP={ CL_HTTP_UTILITY=>ESCAPE_URL( IV_SP ) }| &&
                |&EmployeeCode={ CL_HTTP_UTILITY=>ESCAPE_URL( IV_EMP ) }|.

      LO_REQUEST->SET_METHOD( 'POST' ).
      LO_REQUEST->SET_HEADER_FIELD( NAME = 'Authorization' VALUE = LV_AUTH ).
      LO_REQUEST->SET_HEADER_FIELD( NAME = 'Content-Type' VALUE = 'application/x-www-form-urlencoded' ).
      LO_REQUEST->SET_HEADER_FIELD( NAME = 'Accept' VALUE = 'application/json' ).
      LO_REQUEST->SET_CDATA( LV_BODY ).

      LO_CLIENT->SEND( ).
      LO_CLIENT->RECEIVE( ).

      LO_CLIENT->RESPONSE->GET_STATUS( IMPORTING CODE = LV_CODE REASON = LV_REASON ).
      IF LV_CODE <> 200.
        WRITE: / 'Data call failed: HTTP', LV_CODE, LV_REASON.
        RETURN.
      ENDIF.

      EV_JSON = LO_CLIENT->RESPONSE->GET_CDATA( ).

    CATCH CX_ROOT INTO DATA(LX2).
      WRITE: / 'Exception in CALL_EMPLOYEE_API:', LX2->GET_TEXT( ).
      CLEAR EV_JSON.
  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PARSE_EMPLOYEE_JSON
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_JSON
*&      <-- GT_EMPLOYEE
*&---------------------------------------------------------------------*
FORM PARSE_EMPLOYEE_JSON USING    IV_JSON TYPE STRING
                         CHANGING CT_EMPLOYEE TYPE TY_EMPLOYEE_TAB.

  DATA: LT_RAW      TYPE TY_RAW_TAB,
        LS_RAW      TYPE TY_RAW,
        LS_EMPLOYEE TYPE TY_EMPOYEE.

  CLEAR LT_RAW.
  /UI2/CL_JSON=>DESERIALIZE( EXPORTING JSON = IV_JSON CHANGING DATA = LT_RAW ).

  CLEAR CT_EMPLOYEE.
  LOOP AT LT_RAW INTO LS_RAW.
    CLEAR LS_EMPLOYEE.
    MOVE-CORRESPONDING LS_RAW TO LS_EMPLOYEE.
    APPEND LS_EMPLOYEE TO CT_EMPLOYEE.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form EMP_SEPARATION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM EMP_TRANSFER  CHANGING CT_EMPLOYEE TYPE TY_EMPLOYEE_TAB..

  DATA: LT_ACT TYPE TABLE OF P0000.
  DATA: LV_DAY      TYPE STRING,
        LV_MONTH    TYPE STRING,
        LV_YEAR     TYPE STRING,
        LV_DATE_OUT TYPE STRING.


  LOOP AT CT_EMPLOYEE INTO DATA(WA_EMP).

    CLEAR:P_SEPDT.
    "SPLIT WA_EMP-DATE_OF_EXIT AT '/' INTO LV_DAY LV_MONTH LV_YEAR.
    P_PERNR = WA_EMP-EMPLOYEECODE.

    " Prepare IT0000 Action row
    CLEAR LS_P0000.
    LS_P0000-PERNR = P_PERNR.
    LS_P0000-BEGDA = |{ LV_YEAR }{ LV_MONTH }{ LV_DAY }|. " Exit Date
    LS_P0000-ENDDA = '99991231'.
    LS_P0000-MASSN = P_MASSN.
    LS_P0000-MASSG = P_MASSG.

    CALL FUNCTION 'HR_READ_INFOTYPE'
      EXPORTING
        PERNR     = P_PERNR
        INFTY     = '0000'
        BEGDA     = LS_P0000-BEGDA
        ENDDA     = LS_P0000-ENDDA
      TABLES
        INFTY_TAB = LT_ACT
      EXCEPTIONS
        OTHERS    = 1.


    " Lock employee
    CALL FUNCTION 'HR_EMPLOYEE_ENQUEUE' EXPORTING NUMBER = P_PERNR EXCEPTIONS OTHERS = 1.
    IF SY-SUBRC <> 0.
      WRITE: / 'Could not lock PERNR', P_PERNR, '— aborting.'.
      LEAVE LIST-PROCESSING.
    ENDIF.

    " Insert IT0000 Action (Separation)
    CALL FUNCTION 'HR_INFOTYPE_OPERATION'
      EXPORTING
        INFTY         = '0000'
        NUMBER        = P_PERNR
        VALIDITYBEGIN = LS_P0000-BEGDA
        VALIDITYEND   = LS_P0000-ENDDA
        RECORD        = LS_P0000
        OPERATION     = 'INS'
        TCLAS         = 'A'
        DIALOG_MODE   = '0'   " silent
        "NOCOMMIT      = ABAP_TRUE
      IMPORTING
        RETURN        = LS_RET.

    IF SY-SUBRC = 0.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          WAIT = 'X'.

    ENDIF.

    CLEAR LS_P0001.

    SELECT SINGLE * FROM PA0001
                    INTO CORRESPONDING FIELDS OF LS_P0001
                    WHERE PERNR = P_PERNR AND
                          ENDDA GE SY-DATUM.

    LS_P0001-BEGDA = LS_P0000-BEGDA.
    LS_P0001-ENDDA = '99991231'.
    LS_P0001-PLANS = '99999999'.

    " Insert IT0000 Action (Separation)
    CALL FUNCTION 'HR_INFOTYPE_OPERATION'
      EXPORTING
        INFTY         = '0001'
        NUMBER        = P_PERNR
        VALIDITYBEGIN = LS_P0000-BEGDA "Exit Date
        VALIDITYEND   = LS_P0001-ENDDA
        RECORD        = LS_P0001
        OPERATION     = 'INS'
        TCLAS         = 'A'
        DIALOG_MODE   = '0'   " silent
        "NOCOMMIT      = ABAP_TRUE
      IMPORTING
        RETURN        = LS_RET_01.


    CALL FUNCTION 'HR_EMPLOYEE_DEQUEUE' EXPORTING NUMBER = P_PERNR.
    CLEAR: WA_MSG.

    WA_MSG-EMPLOYEECODE = P_PERNR.
    "WA_MSG-EXIT_DATE    = WA_EMP-DATE_OF_EXIT.
    WA_MSG-MSG_TYPE     = LS_RET_01-TYPE.
    WA_MSG-MSG          = LS_RET_01-MESSAGE.
    APPEND WA_MSG TO IT_MSG.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form EMPLOY_DATA_STATUS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM EMPLOY_DATA_STATUS .
  LS_FCAT-COL_POS = '1'.
  LS_FCAT-FIELDNAME = 'EMPLOYEECODE'.
  LS_FCAT-SELTEXT_L = 'Employee ID'.
  APPEND LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS = '2'.
  LS_FCAT-FIELDNAME = 'EXIT_DATE'.
  LS_FCAT-SELTEXT_L = 'Exit Date'.
  APPEND LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.


  LS_FCAT-COL_POS = '3'.
  LS_FCAT-FIELDNAME = 'MSG_TYPE'.
  LS_FCAT-SELTEXT_L = 'Message Type'.
  APPEND LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS = '4'.
  LS_FCAT-FIELDNAME = 'MSG'.
  LS_FCAT-SELTEXT_L = 'Message'.
  APPEND LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_LAYOUT-COLWIDTH_OPTIMIZE = ABAP_TRUE.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM = SY-CPROG
      IS_LAYOUT          = IS_LAYOUT
      IT_FIELDCAT        = LT_FCAT
    TABLES
      T_OUTTAB           = IT_MSG
    EXCEPTIONS
      PROGRAM_ERROR      = 1
      OTHERS             = 2.
  .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
