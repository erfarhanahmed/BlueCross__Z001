REPORT ZHRMTHREAD_EMP_CREATE.

TYPES: TY_C4   TYPE C LENGTH 4,
       TY_C10  TYPE C LENGTH 10,
       TY_C12  TYPE C LENGTH 12,
       TY_C255 TYPE C LENGTH 255.

*---------------------------------------------------------------------*
* Types
*---------------------------------------------------------------------*
TYPES: BEGIN OF TY_EMPOYEE,
         SERIAL_NUMBER           TYPE I,
         COMPANYCODE             TYPE STRING,    "added
         EMPLOYEECODE            TYPE STRING,
         SALUTATION              TYPE STRING,    "anrex(005),           "Title "added
         FIRSTNAME               TYPE STRING,
         MIDDLENAME              TYPE STRING,
         LASTNAME                TYPE STRING,
         GENDER                  TYPE STRING,
         DATE_OF_BIRTH           TYPE STRING,
         JOINING_DATE            TYPE STRING,
         EMPLOYEE_STATUS_CODE    TYPE STRING,
         EMPLOYEE_STATUS_NAME    TYPE STRING,
         DEPARTMENT_CODE         TYPE STRING,
         DEPARTMENT_NAME         TYPE STRING,
         DESIGNATION_CODE        TYPE STRING,
         DESIGNATION_NAME        TYPE STRING,
         REGION_CODE             TYPE STRING,
         REGION_NAME             TYPE STRING,
         POSITION_CODE           TYPE STRING, "stras
         POSITION_NAME           TYPE STRING, "stras
         PAYROLL_AREA_CODE       TYPE STRING,
         PAYROLL_AREA            TYPE STRING,
         CURRENT_ADRESS_FLAT_NO  TYPE STRING, "stras
         CURRENT_ADDRESS_PREMISE TYPE STRING, "stras
         CURRENT_ADDRESS_ROAD    TYPE STRING, "2nd address
         CURRENT_ADDRESS_AREA    TYPE STRING,  "2nd address
         CURRENT_ADDRESS_TOWN    TYPE STRING, "ort01 "city
         CURRENT_ADDRESS_PINCODE TYPE STRING, "postal code
         CURRENT_ADDRESS_STATE   TYPE STRING,
         CURRENT_ADDRESS_COUNTRY TYPE STRING,
         OFFICIAL_EMAIL          TYPE STRING,
         SUB_GROUP_CODE          TYPE STRING,
         SUB_GROUP_NAME          TYPE STRING,
         HQ_CODE                 TYPE STRING,
         HQ_NAME                 TYPE STRING,
         PAN_NO                  TYPE STRING,
         BANKACCOUNTNUMBER       TYPE STRING,
         BANK_KEY                TYPE STRING,
         RECORD_MODE             TYPE STRING,
         TELEPHONE               TYPE STRING,
         MOBILE_NO               TYPE STRING,
       END OF TY_EMPOYEE.

TYPES TY_EMPLOYEE_TAB TYPE STANDARD TABLE OF TY_EMPOYEE WITH EMPTY KEY.

TYPES: BEGIN OF TY_TOKEN,
         ACCESS_TOKEN TYPE STRING,
         TOKEN_TYPE   TYPE STRING,
         EXPIRES_IN   TYPE I,
         USERNAME     TYPE STRING,
         DBNAME       TYPE STRING,
       END OF TY_TOKEN.

TYPES: BEGIN OF TY_RAW,
         SERIAL_NUMBER           TYPE I,
         COMPANYCODE             TYPE STRING,    "added
         EMPLOYEECODE            TYPE STRING,
         SALUTATION              TYPE STRING,    "anrex(005),           "Title "added
         FIRSTNAME               TYPE STRING,
         MIDDLENAME              TYPE STRING,
         LASTNAME                TYPE STRING,
         GENDER                  TYPE STRING,
         DATE_OF_BIRTH           TYPE STRING,
         JOINING_DATE            TYPE STRING,
         EMPLOYEE_STATUS_CODE    TYPE STRING,
         EMPLOYEE_STATUS_NAME    TYPE STRING,
         DEPARTMENT_CODE         TYPE STRING,
         DEPARTMENT_NAME         TYPE STRING,
         DESIGNATION_CODE        TYPE STRING,
         DESIGNATION_NAME        TYPE STRING,
         REGION_CODE             TYPE STRING,
         REGION_NAME             TYPE STRING,
         POSITION_CODE           TYPE STRING, "stras
         POSITION_NAME           TYPE STRING, "stras
         PAYROLL_AREA_CODE       TYPE STRING,
         PAYROLL_AREA            TYPE STRING,
         CURRENT_ADRESS_FLAT_NO  TYPE STRING, "stras
         CURRENT_ADDRESS_PREMISE TYPE STRING, "stras
         CURRENT_ADDRESS_ROAD    TYPE STRING, "2nd address
         CURRENT_ADDRESS_AREA    TYPE STRING,  "2nd address
         CURRENT_ADDRESS_TOWN    TYPE STRING, "ort01 "city
         CURRENT_ADDRESS_PINCODE TYPE STRING, "postal code
         CURRENT_ADDRESS_STATE   TYPE STRING,
         CURRENT_ADDRESS_COUNTRY TYPE STRING,
         OFFICIAL_EMAIL          TYPE STRING,
         SUB_GROUP_CODE          TYPE STRING,
         SUB_GROUP_NAME          TYPE STRING,
         HQ_CODE                 TYPE STRING,
         HQ_NAME                 TYPE STRING,
         PAN_NO                  TYPE STRING,
         BANKACCOUNTNUMBER       TYPE STRING,
         BANK_KEY                TYPE STRING,
         RECORD_MODE             TYPE STRING,
         TELEPHONE               TYPE STRING,
         MOBILE_NO               TYPE STRING,
       END OF TY_RAW.
TYPES TY_RAW_TAB TYPE STANDARD TABLE OF TY_RAW WITH EMPTY KEY.

TYPES : BEGIN OF TY_MSG,
          EMPLOYEECODE         TYPE STRING,
          FIRSTNAME            TYPE STRING,
          LASTNAME             TYPE STRING,
          GENDER               TYPE STRING,
          JOINING_DATE         TYPE STRING,
          EMPLOYEE_STATUS_CODE TYPE STRING,
          EMPLOYEE_STATUS_NAME TYPE STRING,
          PAYROLL_AREA_CODE    TYPE STRING,
          MSG_TYPE             TYPE BDC_MART,
          MSG                  TYPE STRING,
        END OF TY_MSG.


DATA :IT_BDCMSGCOLL  TYPE STANDARD TABLE OF BDCMSGCOLL,
      IT_BDCMSG_EMIL TYPE STANDARD TABLE OF BDCMSGCOLL,
      WA_BDCMSGCOLL  TYPE BDCMSGCOLL,
      IT_MSG         TYPE TABLE OF TY_MSG,
      WA_MSG         TYPE TY_MSG,
      V_MSG          TYPE STRING,
      LT_FCAT        TYPE STANDARD TABLE OF SLIS_FIELDCAT_ALV,
      LS_FCAT        TYPE SLIS_FIELDCAT_ALV,
      LS_LAYOUT      TYPE  SLIS_LAYOUT_ALV,
      IS_LAYOUT      TYPE SLIS_LAYOUT_ALV,
      LV_STRAS       TYPE CHAR60,
      LV_ORT01       TYPE CHAR40,
      LV_LOCAT       TYPE CHAR40,
      LV_FLAT_NO     TYPE CHAR40.

"All Below Declarations for mail format
DATA : IT_CONTENTS TYPE STANDARD TABLE OF SOLISTI1,
       WA_CONTENTS TYPE SOLISTI1,
       W_DOCUMENT  TYPE REF TO CL_DOCUMENT_BCS.

DATA: GO_SEND_REQUEST  TYPE REF TO  CL_BCS,
      GO_DOCUMENT      TYPE REF TO  CL_DOCUMENT_BCS,
      LO_RECIPIENT     TYPE REF TO  IF_RECIPIENT_BCS,
      LO_BCS_EXCEPTION TYPE REF TO  CX_BCS.
DATA: SEND_REQUEST     TYPE REF TO CL_BCS.

DATA: DOCUMENT           TYPE REF TO CL_DOCUMENT_BCS.
DATA: SENDER             TYPE REF TO CL_SAPUSER_BCS.
DATA: SENDER1            TYPE REF TO CL_CAM_ADDRESS_BCS.
DATA: RECIPIENT          TYPE REF TO IF_RECIPIENT_BCS.
DATA: BCS_EXCEPTION      TYPE REF TO CX_BCS.
DATA: SENT_TO_ALL        TYPE OS_BOOLEAN.
DATA: TL_CONTENTS        TYPE STANDARD TABLE OF SOLI.
DATA: P_FROMID           TYPE ADR6-SMTP_ADDR.

DATA: BEGIN OF S_TOID OCCURS 0,
        LOW TYPE ADR6-SMTP_ADDR,
      END OF S_TOID.

DATA: BEGIN OF S_CCID OCCURS 0,
        LOW TYPE ADR6-SMTP_ADDR,
      END OF S_CCID.

CONSTANTS:
*-- Constants used in the body of the Email (HTML)
  C_HTM      TYPE CHAR3   VALUE 'HTM',
  C_SPACE(6) TYPE C       VALUE '&nbsp;',
  C_NEW_LINE TYPE CHAR255 VALUE '<br>'.

DATA: GV_FNAME        TYPE RS38L_FNAM,       "Fucntion Module
      GV_SUBJECT      TYPE SO_OBJ_DES,
      GV_TITLE        TYPE SO_OBJ_DES,
      LV_BIN_FILESIZE TYPE I,
      LV_SENT_TO_ALL  TYPE OS_BOOLEAN,
      LV_EMAIL        TYPE AD_SMTPADR,
      LV_ATT_NAME     TYPE CHAR50,
      LV_SUB          TYPE STRING.


TYPES: BEGIN OF TY_POSITION,
         SERIAL_NUMBER TYPE I,
         COMPANY_CODE  TYPE CHAR5,
         POSITION_CODE TYPE CHAR8,
         POSITION_NAME TYPE CHAR8,
       END OF TY_POSITION.

TYPES TY_POSITION_TAB TYPE STANDARD TABLE OF TY_POSITION WITH EMPTY KEY.

TYPES: BEGIN OF TY_RECORD,
         SEARK(012),            "Search Term
         BEGDA(010),            "start date
         ENDDA(010),            "To date
         SHORT(012),            "Short text
         STEXT(040),            "Long Text
         SOBID(045),            "ID of Related Object
       END OF TY_RECORD.
DATA : IT_FINAL TYPE TABLE OF TY_RECORD,
       WA_FINAL TYPE TY_RECORD.
DATA : IT_BDC       TYPE TABLE OF BDCDATA WITH HEADER LINE,
       IT_RAW       TYPE TRUXS_T_TEXT_DATA,
       GT_BDC       TYPE STANDARD TABLE OF BDCDATA,
       IT_BDC_EMAIL TYPE TABLE OF BDCDATA WITH HEADER LINE.
DATA : IT_BDCMSGCOLL_1 TYPE STANDARD TABLE OF BDCMSGCOLL,
       WA_BDCMSGCOLL_1 TYPE BDCMSGCOLL.


DATA: LV_JSON TYPE STRING,
      LV_SP   TYPE STRING,
      LV_EMP  TYPE STRING.

"END
*---------------------------------------------------------------------*
* Constants
*---------------------------------------------------------------------*
CONSTANTS:
  GC_TOKEN_URL TYPE STRING VALUE 'https://apipoint.hrmthread.com/hrmthreadapi/api/v1/Token',
  GC_DATA_URL  TYPE STRING VALUE 'https://apipoint.hrmthread.com/hrmthreadapi/api/v1/CommonAPI'.

CONSTANTS:
  GC_USERNAME    TYPE STRING VALUE '200',
  GC_PASSWORD    TYPE STRING VALUE '3644a684f98ea8fe223c713b77189a77', "'3644a684f98ea8fe223c713b77189a77',
  GC_CLIENTKEY   TYPE STRING VALUE 'bclpl',
  GC_COMPANYCODE TYPE STRING VALUE 'bclpl'.

*---------------------------------------------------------------------*
* Data
*---------------------------------------------------------------------*
DATA: GV_TOKEN    TYPE STRING,
      GT_EMPLOYEE TYPE TY_EMPLOYEE_TAB.  "global BDC buffer
DATA: GT_POSITION TYPE TY_POSITION_TAB,
      WA_POSITION TYPE TY_POSITION.

DATA:LV_DATE_LOW  TYPE CHAR10,
     LV_DATE_HIGH TYPE CHAR10.

SELECTION-SCREEN BEGIN OF BLOCK A.
  SELECT-OPTIONS: S_DATE FOR SY-DATUM.
  PARAMETERS: P_PERNR  TYPE PA0000-PERNR.
  PARAMETERS: C_EMPCRT TYPE C AS CHECKBOX.
  PARAMETERS: C_EMPUPD TYPE C AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK A.

SELECTION-SCREEN BEGIN OF BLOCK B.
  PARAMETERS: C_EMLUPD TYPE C  AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK B.
SELECTION-SCREEN BEGIN OF BLOCK C.
SELECTION-SCREEN END OF BLOCK C.


*---------------------------------------------------------------------*
* Start
*---------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM GET_TOKEN USING GC_TOKEN_URL CHANGING GV_TOKEN.

  LV_SP  = '[Position] ''bclpl'''.
  IF P_PERNR IS NOT INITIAL.
    LV_EMP = P_PERNR.
  ELSE.
    LV_EMP = ''.
  ENDIF.
  PERFORM CALL_POSITION_API  USING GC_DATA_URL GV_TOKEN LV_SP LV_EMP CHANGING LV_JSON.
  PERFORM PARSE_POSITION_JSON USING LV_JSON CHANGING GT_POSITION.

  LOOP AT GT_POSITION INTO WA_POSITION.
    WA_FINAL-SEARK = WA_POSITION-POSITION_CODE.
    WA_FINAL-BEGDA = '01.01.1900'.
    WA_FINAL-ENDDA = '31.12.9999'.
    WA_FINAL-SHORT = WA_POSITION-POSITION_NAME.
    WA_FINAL-STEXT = WA_POSITION-POSITION_NAME.
    WA_FINAL-SOBID = ''.
    APPEND WA_FINAL TO IT_FINAL.
    CLEAR WA_FINAL.
  ENDLOOP.

  PERFORM GET_TOKEN USING GC_TOKEN_URL CHANGING GV_TOKEN.

  LV_DATE_LOW  = |{ S_DATE-LOW  DATE = ISO }|.
  IF S_DATE-HIGH IS INITIAL.
    LV_DATE_HIGH = LV_DATE_LOW.
  ELSE.
    LV_DATE_HIGH = |{ S_DATE-HIGH DATE = ISO }|.
  ENDIF.

*  LV_SP  = '[employeeData] ''bclpl'',''1980-01-01'',''2025-11-30'''.
  LV_SP  = |[employeeData] 'bclpl','{ LV_DATE_LOW }','{ LV_DATE_HIGH }'|.
  IF P_PERNR IS NOT INITIAL.
    LV_EMP = P_PERNR.
  ELSE.
    LV_EMP = ''.
  ENDIF.

  PERFORM CALL_EMPLOYEE_API   USING GC_DATA_URL GV_TOKEN LV_SP LV_EMP CHANGING LV_JSON.
  PERFORM PARSE_EMPLOYEE_JSON USING LV_JSON CHANGING GT_EMPLOYEE.
  PERFORM EMPLOYEE_CREATE_BDC USING LV_JSON CHANGING GT_EMPLOYEE.
  PERFORM EMPLOY_DATA_STATUS .
  PERFORM EMAIL_DATA.
*---------------------------------------------------------------------*
* HTTP: Get token
*---------------------------------------------------------------------*
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

*---------------------------------------------------------------------*
* HTTP: Call CommonAPI (employee data)
*---------------------------------------------------------------------*
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

"==================== JSON -> ITAB Parser ==============================
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

*---------------------------------------------------------------------*
* Helpers for BDC  — typed exactly like BDCDATA
*---------------------------------------------------------------------*
FORM BDC_FIELD USING FNAM LIKE BDCDATA-FNAM
                     FVAL LIKE BDCDATA-FVAL.
  DATA LS_BDC TYPE BDCDATA.
  CLEAR LS_BDC.
  LS_BDC-FNAM = FNAM.
  LS_BDC-FVAL = FVAL.
  APPEND LS_BDC TO GT_BDC.
ENDFORM.

FORM BDC_DYNPRO USING PROGRAM LIKE BDCDATA-PROGRAM
                      DYNPRO  LIKE BDCDATA-DYNPRO.
  DATA LS_BDC TYPE BDCDATA.
  CLEAR LS_BDC.
  LS_BDC-PROGRAM  = PROGRAM.
  LS_BDC-DYNPRO   = DYNPRO.
  LS_BDC-DYNBEGIN = 'X'.
  APPEND LS_BDC TO GT_BDC.
ENDFORM.

FORM BDC_FIELD_1 USING FNAM FVAL.
  CLEAR IT_BDC.
  IT_BDC-FNAM = FNAM.
  IT_BDC-FVAL = FVAL.
  APPEND IT_BDC.
ENDFORM.

FORM BDC_DYNPRO_1 USING PROGRAM DYNPRO.
  CLEAR IT_BDC.
  IT_BDC-PROGRAM  = PROGRAM.
  IT_BDC-DYNPRO   = DYNPRO.
  IT_BDC-DYNBEGIN = 'X'.
  APPEND IT_BDC.
ENDFORM.


FORM BDC_FIELD_EMAIL USING FNAM FVAL.
  CLEAR IT_BDC.
  IT_BDC_EMAIL-FNAM = FNAM.
  IT_BDC_EMAIL-FVAL = FVAL.
  APPEND IT_BDC_EMAIL.
ENDFORM.

FORM BDC_DYNPRO_EMAIL USING PROGRAM DYNPRO.
  CLEAR IT_BDC.
  IT_BDC_EMAIL-PROGRAM  = PROGRAM.
  IT_BDC_EMAIL-DYNPRO   = DYNPRO.
  IT_BDC_EMAIL-DYNBEGIN = 'X'.
  APPEND IT_BDC_EMAIL.
ENDFORM.


FORM DATE_OUT USING    IV_DATS TYPE DATS
              CHANGING EV_OUT  TYPE TY_C10.
  IF IV_DATS IS INITIAL.
    CLEAR EV_OUT.
    RETURN.
  ENDIF.
  DATA LV_D TYPE D.
  LV_D = IV_DATS.
  WRITE LV_D TO EV_OUT.   "user-format into CHAR(10)
ENDFORM.

*---------------------------------------------------------------------*
* Build SM35 session "PA30" to update IT0105 0010 + 0001
*---------------------------------------------------------------------*
FORM EMPLOYEE_CREATE_BDC  USING    P_LV_JSON      TYPE STRING "unused
                          CHANGING GT_EMPLOYEE  TYPE TY_EMPLOYEE_TAB.

  DATA: WA_EMP         TYPE TY_EMPOYEE,
        LV_PERNR_RAW   TYPE STRING,
        LV_PERNR_INT   TYPE PERNR_D,
        LV_PERNR_C     TYPE TY_C12,
        LV_BEGDA       TYPE TY_C10,
        LV_BIRTHDATE   TYPE TY_C10,
        LV_ENDDA       TYPE DATS VALUE '99991231',
        LV_BEGDA_C     TYPE TY_C10,
        LV_ENDDA_C     TYPE TY_C10,
        LV_BIRTHDATE_C TYPE TY_C10,
        LV_EMAIL_C     TYPE TY_C255,
        LV_CHOICE_C    TYPE TY_C4  VALUE '0105',
        LV_FVAL        LIKE BDCDATA-FVAL,
        LV_OBJ_ID      TYPE RANGE OF HROBJID.


  SELECT OBJID  FROM HRP1000
                INTO TABLE @DATA(LI_HRP1000)
                WHERE OTYPE = 'S'.

  SORT GT_EMPLOYEE BY EMPLOYEECODE.
  LOOP AT GT_EMPLOYEE INTO WA_EMP.

    SELECT SINGLE *  FROM PA0000
                     INTO @DATA(WA_PA0000)
                     WHERE PERNR =  @WA_EMP-EMPLOYEECODE.

    IF SY-SUBRC NE 0.
      IF WA_EMP-POSITION_CODE IS NOT INITIAL.
        READ TABLE LI_HRP1000 INTO DATA(LW_HRP1000) WITH KEY OBJID = WA_EMP-POSITION_CODE.
        IF SY-SUBRC <> 0.
          LOOP AT IT_FINAL INTO WA_FINAL WHERE SEARK = WA_EMP-POSITION_CODE.
            REFRESH: IT_BDC.
            PERFORM BDC_DYNPRO_1      USING 'SAPMH5A0' '5100'.
            PERFORM BDC_FIELD_1       USING 'BDC_CURSOR'          'PM0D1-SEARK'.
            PERFORM BDC_FIELD_1       USING 'BDC_OKCODE'          '/00'.
            PERFORM BDC_FIELD_1       USING 'PPHDR-PLVAR'          '01'.
            PERFORM BDC_FIELD_1       USING 'PM0D1-SEARK'           WA_FINAL-SEARK  . "
            PERFORM BDC_FIELD_1       USING 'PM0D1-TIMR6'          'X'.
            PERFORM BDC_FIELD_1       USING 'PPHDR-BEGDA'           WA_FINAL-BEGDA  .
            PERFORM BDC_FIELD_1       USING 'PPHDR-ENDDA'           WA_FINAL-ENDDA  .

            PERFORM BDC_DYNPRO_1      USING 'SAPMH5A0' '5100'.
            PERFORM BDC_FIELD_1       USING 'BDC_OKCODE'           '=INSE'.
            PERFORM BDC_FIELD_1       USING 'PPHDR-PLVAR'          '01'.
            PERFORM BDC_FIELD_1       USING 'PM0D1-SEARK'           WA_FINAL-SEARK  . "
            PERFORM BDC_FIELD_1       USING 'BDC_CURSOR'           'TT_T777T-ITEXT(01)'.
            PERFORM BDC_FIELD_1       USING 'PM0D1-TIMR6'          'X'.
            PERFORM BDC_FIELD_1       USING 'PPHDR-BEGDA'           WA_FINAL-BEGDA  .
            PERFORM BDC_FIELD_1       USING 'PPHDR-ENDDA'           WA_FINAL-ENDDA  .
            PERFORM BDC_FIELD_1       USING 'MARKFELD(01)'          'X'.

            PERFORM BDC_DYNPRO_1      USING 'MP100000' '2000'.
            PERFORM BDC_FIELD_1       USING 'BDC_CURSOR'           'P1000-STEXT'.
            PERFORM BDC_FIELD_1       USING 'BDC_OKCODE'           '=UPD'.
            PERFORM BDC_FIELD_1       USING 'P1000-BEGDA'           WA_FINAL-BEGDA  .
            PERFORM BDC_FIELD_1       USING 'P1000-ENDDA'           WA_FINAL-ENDDA  .
            PERFORM BDC_FIELD_1       USING 'P1000-SHORT'           WA_FINAL-SHORT .
            PERFORM BDC_FIELD_1       USING 'P1000-STEXT'           WA_FINAL-STEXT .


            PERFORM BDC_DYNPRO_1      USING 'SAPMH5A0' '5100'.
            PERFORM BDC_FIELD_1       USING 'BDC_OKCODE'            '=INSE'.
            PERFORM BDC_FIELD_1       USING 'PPHDR-PLVAR'           '01'.
            PERFORM BDC_FIELD_1       USING 'PM0D1-SEARK'            WA_FINAL-SEARK  .
            PERFORM BDC_FIELD_1       USING 'BDC_CURSOR'            'TT_T777T-ITEXT(02)'.
            PERFORM BDC_FIELD_1       USING 'PM0D1-TIMR6'           'X'.
            PERFORM BDC_FIELD_1       USING 'PPHDR-BEGDA'           WA_FINAL-BEGDA  .
            PERFORM BDC_FIELD_1       USING 'PPHDR-ENDDA'           WA_FINAL-ENDDA  .
            PERFORM BDC_FIELD_1       USING 'MARKFELD(01)'          ''.
            PERFORM BDC_FIELD_1       USING 'MARKFELD(02)'          'X'.


            PERFORM BDC_DYNPRO_1      USING 'MP100100' '2000'.
            PERFORM BDC_FIELD_1       USING 'BDC_CURSOR'            'P1001-SOBID'.
            PERFORM BDC_FIELD_1       USING 'BDC_OKCODE'            '/00'.
            PERFORM BDC_FIELD_1       USING 'P1001-BEGDA'           WA_FINAL-BEGDA  .
            PERFORM BDC_FIELD_1       USING 'P1001-ENDDA'           WA_FINAL-ENDDA  .
            PERFORM BDC_FIELD_1       USING 'P1001-RSIGN'           'A'.
            PERFORM BDC_FIELD_1       USING 'P1001-RELAT'           '003'.
            PERFORM BDC_FIELD_1       USING 'P1001-SCLAS'           'O'.
            PERFORM BDC_FIELD_1       USING 'P1001-SOBID'           WA_FINAL-SOBID  .

            PERFORM BDC_DYNPRO_1      USING 'MP100100' '2000'.
            PERFORM BDC_FIELD_1       USING 'BDC_CURSOR'          'P1001-BEGDA'.
            PERFORM BDC_FIELD_1       USING 'BDC_OKCODE'          '=UPD'.
            PERFORM BDC_FIELD_1       USING 'P1001-BEGDA'          WA_FINAL-BEGDA  .
            PERFORM BDC_FIELD_1       USING 'P1001-ENDDA'          WA_FINAL-ENDDA  .
            PERFORM BDC_FIELD_1       USING 'P1001-RSIGN'          'A'.
            PERFORM BDC_FIELD_1       USING 'P1001-RELAT'          '003'.
            PERFORM BDC_FIELD_1       USING 'P1001-SCLAS'          'O'.
            PERFORM BDC_FIELD_1       USING 'P1001-SOBID'          WA_FINAL-SOBID  .

            PERFORM BDC_DYNPRO_1      USING 'SAPMH5A0' '5100'.
            PERFORM BDC_FIELD_1       USING 'BDC_OKCODE'          '=INSE'.
            PERFORM BDC_FIELD_1       USING 'PPHDR-PLVAR'          '01'.
            PERFORM BDC_FIELD_1       USING 'PM0D1-SEARK'             WA_FINAL-SEARK  .
            PERFORM BDC_FIELD_1       USING 'BDC_CURSOR'          'TT_T777T-ITEXT(06)'.
            PERFORM BDC_FIELD_1       USING 'PM0D1-TIMR6'          'X'.
            PERFORM BDC_FIELD_1       USING 'PPHDR-BEGDA'           WA_FINAL-BEGDA  .
            PERFORM BDC_FIELD_1       USING 'PPHDR-ENDDA'           WA_FINAL-ENDDA  .
            PERFORM BDC_FIELD_1       USING 'MARKFELD(02)'          ''.
            PERFORM BDC_FIELD_1       USING 'MARKFELD(06)'          'X'.

            PERFORM BDC_DYNPRO_1      USING 'MP100700' '2000'.
            PERFORM BDC_FIELD_1       USING 'BDC_CURSOR'          'P1007-VACAN'.
            PERFORM BDC_FIELD_1       USING 'BDC_OKCODE'          '/00'.
            PERFORM BDC_FIELD_1       USING 'P1007-BEGDA'         WA_FINAL-BEGDA  .
            PERFORM BDC_FIELD_1       USING 'P1007-ENDDA'         WA_FINAL-ENDDA  .
            PERFORM BDC_FIELD_1       USING 'P1007-VACAN'          ''.
            PERFORM BDC_FIELD_1       USING 'P1007-STATUS'          '0'.

            PERFORM BDC_DYNPRO_1      USING 'MP100700' '2000'.
            PERFORM BDC_FIELD_1       USING 'BDC_CURSOR'          'P1007-STATUS'.
            PERFORM BDC_FIELD_1       USING 'BDC_OKCODE'          '/00'.
            PERFORM BDC_FIELD_1       USING 'P1007-BEGDA'          WA_FINAL-BEGDA  .
            PERFORM BDC_FIELD_1       USING 'P1007-ENDDA'          WA_FINAL-ENDDA  .
            PERFORM BDC_FIELD_1       USING 'P1007-VACAN'          ''.
            PERFORM BDC_FIELD_1       USING 'P1007-STATUS'          '2'.

            PERFORM BDC_DYNPRO_1      USING 'MP100700' '2000'.
            PERFORM BDC_FIELD_1       USING 'BDC_CURSOR'          'P1007-VACAN'.
            PERFORM BDC_FIELD_1       USING 'BDC_OKCODE'          '=UPD'.
            PERFORM BDC_FIELD_1       USING 'P1007-BEGDA'         WA_FINAL-BEGDA  .
            PERFORM BDC_FIELD_1       USING 'P1007-ENDDA'         WA_FINAL-ENDDA  .
            PERFORM BDC_FIELD_1       USING 'P1007-VACAN'          ''.
            PERFORM BDC_FIELD_1       USING 'P1007-STATUS'          '2'.

            PERFORM BDC_DYNPRO_1      USING 'SAPMH5A0' '5100'.
            PERFORM BDC_FIELD_1       USING 'BDC_OKCODE'          '=BACK'.
            PERFORM BDC_FIELD_1       USING 'PPHDR-PLVAR'         '01'.
            PERFORM BDC_FIELD_1       USING 'PM0D1-SEARK'          WA_FINAL-SEARK  .

            CALL TRANSACTION 'PO13' USING IT_BDC[] MODE 'N' UPDATE 'A' MESSAGES INTO IT_BDCMSGCOLL_1.
          ENDLOOP.

          CLEAR: IT_BDC, IT_BDCMSGCOLL_1.

        ENDIF.


        IF C_EMPCRT IS NOT INITIAL.
          LV_PERNR_RAW = WA_EMP-EMPLOYEECODE.
          LV_PERNR_INT = LV_PERNR_RAW.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              INPUT  = LV_PERNR_INT
            IMPORTING
              OUTPUT = LV_PERNR_INT.
          CLEAR:LV_PERNR_C.
          LV_PERNR_C = LV_PERNR_INT .

          REPLACE ALL OCCURRENCES OF '/' IN WA_EMP-JOINING_DATE WITH '.'.
          REPLACE ALL OCCURRENCES OF '/' IN WA_EMP-DATE_OF_BIRTH WITH '.'.
          PERFORM DATE_OUT USING LV_ENDDA     CHANGING LV_ENDDA_C.

          LV_EMAIL_C = WA_EMP-OFFICIAL_EMAIL.

          CLEAR GT_BDC.
          PERFORM BDC_DYNPRO USING 'SAPMP50A' '2000'.

          LV_FVAL = 'T529T-MNTXT(01)'.                      PERFORM BDC_FIELD USING 'BDC_CURSOR'        LV_FVAL.
          LV_FVAL = '=PICK'.                                PERFORM BDC_FIELD USING 'BDC_OKCODE'        LV_FVAL.
          LV_FVAL = LV_PERNR_C.                             PERFORM BDC_FIELD USING 'RP50G-PERNR'       LV_FVAL.
          LV_FVAL = WA_EMP-JOINING_DATE.                    PERFORM BDC_FIELD USING 'RP50G-EINDA'       LV_FVAL.
          LV_FVAL = 'X'.                                    PERFORM BDC_FIELD USING 'RP50G-SELEC(01)'   LV_FVAL.

          PERFORM BDC_DYNPRO USING 'MP000000' '2000'.

          LV_FVAL = 'PSPAR-PLANS'.                          PERFORM BDC_FIELD USING 'BDC_CURSOR'        LV_FVAL.
          LV_FVAL = '=UPD'.                                 PERFORM BDC_FIELD USING 'BDC_OKCODE'        LV_FVAL.
          LV_FVAL = WA_EMP-JOINING_DATE.                    PERFORM BDC_FIELD USING 'P0000-BEGDA'       LV_FVAL.
          LV_FVAL = '31.12.9999'.                           PERFORM BDC_FIELD USING 'P0000-ENDDA'       LV_FVAL.
          LV_FVAL = '01'.                                   PERFORM BDC_FIELD USING 'P0000-MASSN'       LV_FVAL.
          LV_FVAL = WA_EMP-POSITION_CODE.                   PERFORM BDC_FIELD USING 'PSPAR-PLANS'       LV_FVAL.

          CLEAR WA_EMP-REGION_CODE.
          CASE WA_EMP-PAYROLL_AREA_CODE.
            WHEN 10.
              WA_EMP-REGION_CODE = '1000'.
            WHEN 12.
              WA_EMP-REGION_CODE = '1500'.
            WHEN 14.
              WA_EMP-REGION_CODE = '1200'.
            WHEN 15.
              WA_EMP-REGION_CODE = '1300'.
          ENDCASE.

          LV_FVAL = WA_EMP-REGION_CODE.                     PERFORM BDC_FIELD USING 'PSPAR-WERKS'       LV_FVAL. "region code or name

          TRANSLATE WA_EMP-EMPLOYEE_STATUS_CODE TO UPPER CASE.
          CASE WA_EMP-EMPLOYEE_STATUS_CODE.
            WHEN 'CONFIRMED'.
              CLEAR WA_EMP-EMPLOYEE_STATUS_CODE.
              WA_EMP-EMPLOYEE_STATUS_CODE = '1'.
            WHEN 'RESIGNED'.
            WHEN 'PROBATION'.
              CLEAR WA_EMP-EMPLOYEE_STATUS_CODE.
              WA_EMP-EMPLOYEE_STATUS_CODE = '1'.
            WHEN 'PROBATIONER'.
              CLEAR WA_EMP-EMPLOYEE_STATUS_CODE.
              WA_EMP-EMPLOYEE_STATUS_CODE = '1'.
            WHEN OTHERS.
          ENDCASE.

          LV_FVAL = WA_EMP-EMPLOYEE_STATUS_CODE.                PERFORM BDC_FIELD  USING 'PSPAR-PERSG'        LV_FVAL.
          LV_FVAL = WA_EMP-SUB_GROUP_CODE.                      PERFORM BDC_FIELD  USING 'PSPAR-PERSK'        LV_FVAL.

          PERFORM BDC_DYNPRO USING 'MP000200' '2040'.

          LV_FVAL = 'P0002-GBDAT'.                              PERFORM BDC_FIELD USING 'BDC_CURSOR'          LV_FVAL.
          LV_FVAL = '=UPD'.                                     PERFORM BDC_FIELD USING 'BDC_OKCODE'          LV_FVAL.
          LV_FVAL = WA_EMP-JOINING_DATE.                        PERFORM BDC_FIELD USING 'P0002-BEGDA'         LV_FVAL.
          LV_FVAL = '31.12.9999'.                               PERFORM BDC_FIELD USING 'P0002-ENDDA'         LV_FVAL.

          SPLIT WA_EMP-SALUTATION AT '.' INTO DATA(LV_SAL) DATA(LV_VAL).

          LV_FVAL = LV_SAL.                                    PERFORM BDC_FIELD USING 'Q0002-ANREX'          LV_FVAL.
          CLEAR: LV_SAL, LV_VAL.

          LV_FVAL = WA_EMP-LASTNAME.                           PERFORM BDC_FIELD USING 'P0002-NACHN'          LV_FVAL.
          LV_FVAL = WA_EMP-FIRSTNAME.                          PERFORM BDC_FIELD USING 'P0002-VORNA'          LV_FVAL.

          TRANSLATE WA_EMP-GENDER TO UPPER CASE.
          CASE WA_EMP-GENDER.
            WHEN 'MALE'.
              CLEAR WA_EMP-GENDER.
              WA_EMP-GENDER = '1'.
            WHEN 'FEMALE'.
              CLEAR WA_EMP-GENDER.
              WA_EMP-GENDER = '2'.
            WHEN OTHERS.
          ENDCASE.
          LV_FVAL = WA_EMP-GENDER.                            PERFORM BDC_FIELD USING 'P0002-GESCH'         LV_FVAL.
          LV_FVAL = 'EN'.                                     PERFORM BDC_FIELD USING 'P0002-SPRSL'         LV_FVAL.
          LV_FVAL = WA_EMP-DATE_OF_BIRTH.                     PERFORM BDC_FIELD USING 'P0002-GBDAT'         LV_FVAL.
          LV_FVAL = 'IN'.                                     PERFORM BDC_FIELD USING 'P0002-NATIO'         LV_FVAL.

          PERFORM BDC_DYNPRO USING 'MP000100' '2000'.

          LV_FVAL = 'P0001-BTRTL'.                            PERFORM BDC_FIELD USING 'BDC_CURSOR'          LV_FVAL.
          LV_FVAL = '=UPD'.                                   PERFORM BDC_FIELD USING 'BDC_OKCODE'          LV_FVAL.
          LV_FVAL = WA_EMP-JOINING_DATE.                      PERFORM BDC_FIELD USING 'P0001-BEGDA'         LV_FVAL.
          LV_FVAL = '31.12.9999'.                             PERFORM BDC_FIELD USING 'P0001-ENDDA'         LV_FVAL.
          LV_FVAL = WA_EMP-DEPARTMENT_CODE.                   PERFORM BDC_FIELD USING 'P0001-BTRTL'         LV_FVAL.
          LV_FVAL = WA_EMP-PAYROLL_AREA_CODE.                 PERFORM BDC_FIELD USING 'P0001-ABKRS'         LV_FVAL.
          LV_FVAL = WA_EMP-HQ_CODE.                           PERFORM BDC_FIELD USING 'P0001-ZZ_HQCODE'     LV_FVAL.

          PERFORM BDC_DYNPRO USING 'MP000600' '2000'.

          LV_FVAL = 'P0006-ORT01'.                            PERFORM BDC_FIELD USING 'BDC_CURSOR'          LV_FVAL.
          LV_FVAL = '=UPD'.                                   PERFORM BDC_FIELD USING 'BDC_OKCODE'          LV_FVAL.
          LV_FVAL = WA_EMP-JOINING_DATE.                      PERFORM BDC_FIELD USING 'P0006-BEGDA'         LV_FVAL.
          LV_FVAL = '31.12.9999'.                             PERFORM BDC_FIELD USING 'P0006-ENDDA'         LV_FVAL.

          CLEAR: LV_FLAT_NO.
          LV_FLAT_NO = WA_EMP-CURRENT_ADRESS_FLAT_NO.
          LV_FVAL = LV_FLAT_NO.                               PERFORM BDC_FIELD USING 'P0006-NAME2'         LV_FVAL.

          CLEAR:LV_STRAS.
          LV_STRAS = WA_EMP-CURRENT_ADDRESS_PREMISE.
          LV_FVAL  = LV_STRAS.                                PERFORM BDC_FIELD USING 'P0006-STRAS'         LV_FVAL.

          CLEAR:LV_LOCAT.
          LV_LOCAT = WA_EMP-CURRENT_ADDRESS_ROAD && WA_EMP-CURRENT_ADDRESS_AREA.
          LV_FVAL = LV_LOCAT.                                 PERFORM BDC_FIELD USING 'P0006-LOCAT'         LV_FVAL.

          LV_FVAL = WA_EMP-CURRENT_ADDRESS_PINCODE.           PERFORM BDC_FIELD USING 'P0006-PSTLZ'         LV_FVAL.

          CLEAR: LV_ORT01.
          LV_ORT01 = |{ WA_EMP-CURRENT_ADDRESS_TOWN } { WA_EMP-CURRENT_ADDRESS_STATE }|.
          LV_FVAL = LV_ORT01.                                 PERFORM BDC_FIELD USING 'P0006-ORT01'         LV_FVAL.

          LV_FVAL = WA_EMP-CURRENT_ADDRESS_STATE.             PERFORM BDC_FIELD USING 'P0006-ORT02'         LV_FVAL.

          LV_FVAL = 'IN'.                                     PERFORM BDC_FIELD USING 'P0006-LAND1'         LV_FVAL.

          PERFORM BDC_DYNPRO USING 'MP000700' '2000'.

          LV_FVAL = '/EBCK'.                                  PERFORM BDC_FIELD USING 'BDC_OKCODE'          LV_FVAL.
          LV_FVAL = 'P0007-BEGDA'.                            PERFORM BDC_FIELD USING 'BDC_CURSOR'          LV_FVAL.


*          "bank details
*          PERFORM BDC_DYNPRO USING 'MP000900' '2000'.
*
*          LV_FVAL = 'P0009-ZLSCH'.                            PERFORM BDC_FIELD USING 'BDC_CURSOR'           LV_FVAL.
*          LV_FVAL = '=UPD'.                                   PERFORM BDC_FIELD USING 'BDC_OKCODE'           LV_FVAL.
*          LV_FVAL = '0'.                                      PERFORM BDC_FIELD USING 'P0009-BNKSA'          LV_FVAL.
*          LV_FVAL = WA_EMP-BANK_KEY.                          PERFORM BDC_FIELD USING 'P0009-BANKL'          LV_FVAL.
*          LV_FVAL = WA_EMP-BANKACCOUNTNUMBER.                 PERFORM BDC_FIELD USING 'P0009-BANKN'          LV_FVAL.
*          LV_FVAL = WA_EMP-PAN_NO.                            PERFORM BDC_FIELD USING 'P0009-ZWECK'          LV_FVAL.
*          LV_FVAL = 'INR'.                                    PERFORM BDC_FIELD USING 'P0009-WAERS'          LV_FVAL.
*          LV_FVAL = 'IN'.                                     PERFORM BDC_FIELD USING 'P0009-BANKS'          LV_FVAL.
*          LV_FVAL = WA_EMP-FIRSTNAME && WA_EMP-LASTNAME.      PERFORM BDC_FIELD USING 'Q0009-EMFTX'          LV_FVAL.
*          LV_FVAL = WA_EMP-CURRENT_ADDRESS_TOWN.              PERFORM BDC_FIELD USING 'Q0009-BKORT'          LV_FVAL.
*          LV_FVAL = WA_EMP-CURRENT_ADDRESS_PINCODE.           PERFORM BDC_FIELD USING 'Q0009-BKPLZ'          LV_FVAL.
*          LV_FVAL = 'IN'.                                     PERFORM BDC_FIELD USING 'Q0009-ADRS_BANKS'     LV_FVAL.
*          LV_FVAL = 'T'.                                      PERFORM BDC_FIELD USING 'P0009-ZLSCH'          LV_FVAL.
*          "end of bank details




*          PERFORM BDC_DYNPRO USING 'MP000900' '2000'.
*          LV_FVAL = '/EBCK'.                                  PERFORM BDC_FIELD USING 'BDC_OKCODE'          LV_FVAL.
*          LV_FVAL = 'P0009-BEGDA'.                            PERFORM BDC_FIELD USING 'BDC_CURSOR'          LV_FVAL.

          PERFORM BDC_DYNPRO USING 'SAPMP50A' '2000'.

          LV_FVAL = '/EBCK'.                                  PERFORM BDC_FIELD USING 'BDC_OKCODE'          LV_FVAL.
          LV_FVAL = 'RP50G-PERNR'.                            PERFORM BDC_FIELD USING 'BDC_CURSOR'          LV_FVAL.


          DATA: LW_RETURN TYPE BAPIRETURN1,
                LV_PERNR  TYPE BAPIP0001-PERNR.

          CLEAR: LW_RETURN,LV_PERNR.
          LV_PERNR = LV_PERNR_C.

          CALL FUNCTION 'BAPI_EMPLOYEE_DEQUEUE'
            EXPORTING
              NUMBER = LV_PERNR
            IMPORTING
              RETURN = LW_RETURN.

          DATA(LV_MODE) = 'N'.
          CALL TRANSACTION 'PA40' USING GT_BDC[] MODE LV_MODE UPDATE 'A' MESSAGES INTO IT_BDCMSGCOLL.

          MOVE-CORRESPONDING WA_EMP TO WA_MSG .
          LOOP AT IT_BDCMSGCOLL INTO WA_BDCMSGCOLL WHERE MSGTYP = 'S' OR MSGTYP = 'E'.
            CALL FUNCTION 'FORMAT_MESSAGE'
              EXPORTING
                ID        = WA_BDCMSGCOLL-MSGID
                LANG      = WA_BDCMSGCOLL-MSGSPRA
                NO        = WA_BDCMSGCOLL-MSGNR
                V1        = WA_BDCMSGCOLL-MSGV1
                V2        = WA_BDCMSGCOLL-MSGV2
                V3        = WA_BDCMSGCOLL-MSGV3
                V4        = WA_BDCMSGCOLL-MSGV4
              IMPORTING
                MSG       = V_MSG
              EXCEPTIONS
                NOT_FOUND = 1.

            WA_MSG-MSG_TYPE = WA_BDCMSGCOLL-MSGTYP.
            IF V_MSG IS  NOT INITIAL.
              CONCATENATE WA_MSG-MSG V_MSG INTO WA_MSG-MSG.
              CLEAR V_MSG.
            ENDIF.
            CLEAR:  V_MSG.

            WA_MSG-EMPLOYEECODE = WA_EMP-EMPLOYEECODE.
            WA_MSG-FIRSTNAME = WA_EMP-FIRSTNAME.
            APPEND WA_MSG TO IT_MSG.

          ENDLOOP.
        ENDIF.

      ELSE.
        WA_MSG-MSG = | 'FOR' { WA_EMP-EMPLOYEECODE } 'In API - Position is not available' |.
        WA_MSG-MSG_TYPE = 'E'.
        WA_MSG-EMPLOYEECODE = WA_EMP-EMPLOYEECODE.
        WA_MSG-FIRSTNAME = WA_EMP-FIRSTNAME.
        APPEND WA_MSG TO IT_MSG.
      ENDIF.

*     CLEAR WA_PA0000.
*     SELECT SINGLE *  FROM PA0000
*                      INTO @WA_PA0000
*                      WHERE PERNR =  @WA_EMP-EMPLOYEECODE.
*
*      "bank detail creation
*      IF WA_PA0000-PERNR is NOT INITIAL.
*
*        DATA: L_RETURN  TYPE BAPIRETURN1,
*              V_SUBTY   TYPE SUBTY           VALUE '0010',
*              LV_OP     TYPE PSPAR-ACTIO,
*              LT_PA0009 TYPE TABLE OF P0009,
*              V_BEGDA   TYPE PRELP-BEGDA.
*
*        IF WA_EMP-JOINING_DATE IS NOT INITIAL.
*          DATA(V_JDATE) = WA_EMP-JOINING_DATE.
*          REPLACE ALL OCCURRENCES OF '-' IN V_JDATE WITH ''.
*          REPLACE ALL OCCURRENCES OF '.' IN V_JDATE WITH ''.
*          REPLACE ALL OCCURRENCES OF '/' IN V_JDATE WITH ''.
*          IF V_JDATE CO '0123456789' AND STRLEN( V_JDATE ) = 8.
*            V_BEGDA = V_JDATE+4(4) && V_JDATE+2(2) && V_JDATE+0(2).
*            "LV_BEGDA = LV_JDATE.
*          ENDIF.
*        ENDIF.
*
*
*        CALL FUNCTION 'BAPI_EMPLOYEE_ENQUEUE'
*          EXPORTING
*            NUMBER = LV_PERNR
*          IMPORTING
*            RETURN = L_RETURN.
*
*        CALL FUNCTION 'HR_READ_INFOTYPE'
*          EXPORTING
*            PERNR     = LV_PERNR
*            INFTY     = '0009'
*            BEGDA     = V_BEGDA
*            ENDDA     = '99991231'
*          TABLES
*            INFTY_TAB = LT_PA0009
*          EXCEPTIONS
*            OTHERS    = 1.
*
*        READ TABLE LT_PA0009 INTO DATA(LS_PA0009) WITH KEY PERNR = WA_EMP-EMPLOYEECODE.
*        IF SY-SUBRC <> 0.
*
*          DATA: ZENDDA TYPE D VALUE '99991231'.
*
*          CLEAR LS_PA0009.
*
*          LS_PA0009-PERNR = LV_PERNR.
*          LS_PA0009-SUBTY = '0'.
*          LS_PA0009-BEGDA = V_BEGDA.
*          LS_PA0009-BNKSA = '0'.
*          LS_PA0009-BANKL = WA_EMP-BANK_KEY.
*          LS_PA0009-BANKN = WA_EMP-BANKACCOUNTNUMBER.
*          LS_PA0009-ZWECK = WA_EMP-PAN_NO.
*          LS_PA0009-WAERS = 'INR'.
*          LS_PA0009-BANKS = 'IN'.
*          LS_PA0009-EMFTX = WA_EMP-FIRSTNAME && WA_EMP-LASTNAME.
*          LS_PA0009-BKORT = WA_EMP-CURRENT_ADDRESS_TOWN.
*          LS_PA0009-BKPLZ = WA_EMP-CURRENT_ADDRESS_PINCODE.
*          LS_PA0009-ADRS_BANKS = 'IN'.
*          LS_PA0009-ZLSCH = 'T'.
*          LS_PA0009-ENDDA = ZENDDA.
*          LV_OP = 'INS'.
*
*          APPEND LS_PA0009 TO LT_PA0009.
*          "CLEAR LS_PA0009.
*        ENDIF.
*
*        "BANK_CREATE
*        CALL FUNCTION 'HR_INFOTYPE_OPERATION'
*          EXPORTING
*            INFTY         = '0009'
*            SUBTYPE       = V_SUBTY
*            NUMBER        = LV_PERNR
*            VALIDITYBEGIN = V_BEGDA
*            VALIDITYEND   = ZENDDA
*            RECORD        = LS_PA0009
*            OPERATION     = LV_OP          " 'INS' or 'MOD'
*            TCLAS         = 'A'
*            DIALOG_MODE   = '0'
*            NOCOMMIT      = ' '            " we will COMMIT ourselves
*          IMPORTING
*            RETURN        = L_RETURN.
*
*       CLEAR: WA_MSG.
*
*       WA_MSG = VALUE #( EMPLOYEECODE = WA_EMP-EMPLOYEECODE
*                         FIRSTNAME    = WA_EMP-FIRSTNAME
*                         LASTNAME     = WA_EMP-LASTNAME
*                         MSG_TYPE     = L_RETURN-TYPE
*                         MSG          = |0009(1) { L_RETURN-ID }-{ L_RETURN-NUMBER }: { L_RETURN-MESSAGE }| ).
*       APPEND WA_MSG TO IT_MSG.
*
*        IF L_RETURN-TYPE CA 'EA'.
*          CALL FUNCTION 'BAPI_EMPLOYEE_DEQUEUE'
*            EXPORTING
*              NUMBER = LV_PERNR
*            IMPORTING
*              RETURN = L_RETURN.
*        ENDIF.
*
*        COMMIT WORK AND WAIT.
*
*        CALL FUNCTION 'BAPI_EMPLOYEE_DEQUEUE'
*          EXPORTING
*            NUMBER = LV_PERNR
*          IMPORTING
*            RETURN = L_RETURN.
*
*      ENDIF.

    ELSEIF WA_EMP-RECORD_MODE = 'E'.
      PERFORM UPDATE_EMPLOYEE USING WA_EMP.
    ENDIF.


    IF C_EMLUPD IS NOT INITIAL AND WA_EMP-POSITION_CODE IS NOT INITIAL.
      DATA:
        LV_EMAIL       TYPE P0105-USRID_LONG,
        LT_P0105       TYPE TABLE OF P0105,
        LS_P0105       TYPE P0105,
        LV_BEGDA_EMAIL TYPE BEGDA,
        LV_ENDDA_EMAIL TYPE ENDDA,
        LS_RETURN      TYPE BAPIRETURN1,
        LV_SUBTY       TYPE SUBTY           VALUE '0010',
        LV_OPR         TYPE PSPAR-ACTIO.

      CLEAR:LV_PERNR, LS_P0105,LS_RETURN,LT_P0105.
      LV_PERNR =  WA_EMP-EMPLOYEECODE.
      LV_BEGDA_EMAIL = SY-DATUM.
      LV_ENDDA_EMAIL = '99991231'.
      LV_EMAIL = WA_EMP-OFFICIAL_EMAIL.

      CALL FUNCTION 'BAPI_EMPLOYEE_ENQUEUE'
        EXPORTING
          NUMBER = LV_PERNR
        IMPORTING
          RETURN = LS_RETURN.

      CALL FUNCTION 'HR_READ_INFOTYPE'
        EXPORTING
          PERNR     = LV_PERNR
          INFTY     = '0105'
          BEGDA     = '18000101'
          ENDDA     = '99991231'
        TABLES
          INFTY_TAB = LT_P0105
        EXCEPTIONS
          OTHERS    = 1.

      CLEAR LV_OPR.
      READ TABLE LT_P0105 INTO LS_P0105 WITH KEY PERNR = WA_EMP-EMPLOYEECODE.
      IF SY-SUBRC = 0.
        LV_OPR  = 'MOD'.
        LS_P0105-USRID_LONG = LV_EMAIL.    " new email
        LV_BEGDA_EMAIL = LV_BEGDA_EMAIL.
        LV_ENDDA_EMAIL = LV_ENDDA_EMAIL.
      ELSE.
        CLEAR LS_P0105.
        LS_P0105-PERNR      = LV_PERNR.
        LS_P0105-SUBTY      = LV_SUBTY.
        LS_P0105-BEGDA      = LV_BEGDA_EMAIL.
        LS_P0105-ENDDA      = LV_ENDDA_EMAIL.
        LS_P0105-USRID_LONG = LV_EMAIL.
        LV_OPR  = 'INS'.
      ENDIF.

      "EMAIL_UPDATE
      CALL FUNCTION 'HR_INFOTYPE_OPERATION'
        EXPORTING
          INFTY         = '0105'
          SUBTYPE       = LV_SUBTY
          NUMBER        = LV_PERNR
          VALIDITYBEGIN = LV_BEGDA_EMAIL
          VALIDITYEND   = LV_ENDDA_EMAIL
          RECORD        = LS_P0105
          OPERATION     = LV_OPR           " 'INS' or 'MOD'
          TCLAS         = 'A'
          DIALOG_MODE   = '0'
          NOCOMMIT      = ' '            " We will COMMIT ourselves
        IMPORTING
          RETURN        = LS_RETURN.

      CLEAR WA_MSG.
      WA_MSG = VALUE #( EMPLOYEECODE = WA_EMP-EMPLOYEECODE
                        FIRSTNAME    = WA_EMP-FIRSTNAME
                        LASTNAME     = WA_EMP-LASTNAME
                        MSG_TYPE     = LS_RETURN-TYPE
                        MSG          = |0105(1) { LS_RETURN-ID }-{ LS_RETURN-NUMBER }: { LS_RETURN-MESSAGE }| ).
      APPEND WA_MSG TO IT_MSG.

      IF LS_RETURN-TYPE CA 'EA'.
        CALL FUNCTION 'BAPI_EMPLOYEE_DEQUEUE'
          EXPORTING
            NUMBER = LV_PERNR
          IMPORTING
            RETURN = LS_RETURN.
      ENDIF.

      COMMIT WORK AND WAIT.

      CALL FUNCTION 'BAPI_EMPLOYEE_DEQUEUE'
        EXPORTING
          NUMBER = LV_PERNR
        IMPORTING
          RETURN = LS_RETURN.
    ENDIF.
    CLEAR: WA_EMP,WA_MSG,LV_LOCAT.
    REFRESH: GT_BDC,IT_BDCMSGCOLL.

  ENDLOOP.
ENDFORM.


FORM EMPLOY_DATA_STATUS.

  LS_FCAT-COL_POS = '1'.
  LS_FCAT-FIELDNAME = 'EMPLOYEECODE'.
  LS_FCAT-SELTEXT_L = 'Employee ID'.
  APPEND LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS = '2'.
  LS_FCAT-FIELDNAME = 'FIRSTNAME'.
  LS_FCAT-SELTEXT_L = 'Employee Name'.
  APPEND LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS = '3'.
  LS_FCAT-FIELDNAME = 'LASTNAME'.
  LS_FCAT-SELTEXT_L = 'Last Name'.
  APPEND LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS = '4'.
  LS_FCAT-FIELDNAME = 'GENDER'.
  LS_FCAT-SELTEXT_L = 'Gender'.
  APPEND LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS = '6'.
  LS_FCAT-FIELDNAME = 'JOINING_DATE'.
  LS_FCAT-SELTEXT_L = 'Joining Date'.
  APPEND LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS = '7'.
  LS_FCAT-FIELDNAME = 'EMPLOYEE_STATUS_CODE'.
  LS_FCAT-SELTEXT_L = 'Status'.
  APPEND LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS = '8'.
  LS_FCAT-FIELDNAME = 'EMPLOYEE_STATUS_NAME'.
  LS_FCAT-SELTEXT_L = 'Status Description'.
  APPEND LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS = '9'.
  LS_FCAT-FIELDNAME = 'PAYROLL_AREA_CODE'.
  LS_FCAT-SELTEXT_L = 'Payroll Code'.
  APPEND LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS = '10'.
  LS_FCAT-FIELDNAME = 'MSG_TYPE'.
  LS_FCAT-SELTEXT_L = 'Message Type'.
  APPEND LS_FCAT TO LT_FCAT.
  CLEAR LS_FCAT.

  LS_FCAT-COL_POS = '11'.
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
*&---------------------------------------------------------------------*
*& Form EMAIL_DATA
*&---------------------------------------------------------------------*
FORM EMAIL_DATA .

  DATA: VSUBJECT TYPE STRING.
  CLEAR   : IT_CONTENTS[].
  CLEAR : IT_CONTENTS[].

  "email body
  WA_CONTENTS-LINE = '<HTML> <BODY>'.
  APPEND WA_CONTENTS TO IT_CONTENTS.
  CLEAR : WA_CONTENTS.

  CONCATENATE '<p style="font-family:Calibri;font-size:15;">' 'Dear Sir / Madam,' INTO WA_CONTENTS-LINE.
  APPEND WA_CONTENTS TO IT_CONTENTS.
  CLEAR : WA_CONTENTS.

  PERFORM LINE_BREAK.
  PERFORM LINE_BREAK.

  CONCATENATE 'Following Status of Employee Creation' '.'
      INTO WA_CONTENTS-LINE.
  APPEND WA_CONTENTS TO IT_CONTENTS.
  CLEAR : WA_CONTENTS.

  "html body
  WA_CONTENTS-LINE = '<table style="font-family:calibri;font-size:15;MARGIN:10px;"'.   " bordercolor="blue"'.
  APPEND WA_CONTENTS TO IT_CONTENTS.
  CLEAR : WA_CONTENTS.

  WA_CONTENTS-LINE = 'cellspacing="0" cellpadding="1" width="75%" '.
  APPEND WA_CONTENTS TO IT_CONTENTS.
  CLEAR : WA_CONTENTS.

  WA_CONTENTS-LINE = 'border="1"><tbody><tr>'.
  APPEND WA_CONTENTS TO IT_CONTENTS.
  CLEAR : WA_CONTENTS.

  WA_CONTENTS-LINE = '<th bgcolor="#C0C0C0">Employee ID</th>'.                    "66CCFF
  APPEND WA_CONTENTS TO IT_CONTENTS.
  CLEAR : WA_CONTENTS.

  WA_CONTENTS-LINE = '<th bgcolor="#C0C0C0">Employee Name</th>'.
  APPEND WA_CONTENTS TO IT_CONTENTS.
  CLEAR : WA_CONTENTS.

  WA_CONTENTS-LINE = '<th bgcolor="#C0C0C0">Message Type</th>'.
  APPEND WA_CONTENTS TO IT_CONTENTS.
  CLEAR : WA_CONTENTS.

  WA_CONTENTS-LINE = '<th bgcolor="#C0C0C0">Message</th>'.
  APPEND WA_CONTENTS TO IT_CONTENTS.
  CLEAR : WA_CONTENTS.

  LOOP AT IT_MSG INTO DATA(WA_MS).

    WA_CONTENTS-LINE = '<tr align = "center">'.
    APPEND WA_CONTENTS TO IT_CONTENTS.
    CLEAR : WA_CONTENTS.

    CONCATENATE '<td>' WA_MS-EMPLOYEECODE '</td>' INTO WA_CONTENTS-LINE SEPARATED BY SPACE.
    APPEND WA_CONTENTS TO IT_CONTENTS.
    CLEAR : WA_CONTENTS.

    CONCATENATE '<td>' WA_MS-FIRSTNAME '</td>' INTO WA_CONTENTS-LINE SEPARATED BY SPACE.
    APPEND WA_CONTENTS TO IT_CONTENTS.
    CLEAR : WA_CONTENTS.

    CONCATENATE '<td>' WA_MS-MSG_TYPE '</td>' INTO WA_CONTENTS-LINE SEPARATED BY SPACE.
    APPEND WA_CONTENTS TO IT_CONTENTS.
    CLEAR : WA_CONTENTS.

    CONCATENATE '<td>' WA_MS-MSG '</td>' INTO WA_CONTENTS-LINE SEPARATED BY SPACE.
    APPEND WA_CONTENTS TO IT_CONTENTS.
    CLEAR : WA_CONTENTS.

  ENDLOOP.

  WA_CONTENTS-LINE = '</tbody> </table>'.
  APPEND WA_CONTENTS TO IT_CONTENTS.
  CLEAR : WA_CONTENTS.

  PERFORM LINE_BREAK.
  PERFORM LINE_BREAK.

  WA_CONTENTS-LINE = 'Kindly note:'.
  APPEND WA_CONTENTS TO IT_CONTENTS.
  CLEAR : WA_CONTENTS.

  PERFORM LINE_BREAK.

  CONCATENATE C_SPACE C_SPACE C_SPACE C_SPACE '-  this is system generated email' INTO WA_CONTENTS-LINE SEPARATED BY SPACE.
  APPEND WA_CONTENTS TO IT_CONTENTS.
  CLEAR : WA_CONTENTS.

  PERFORM LINE_BREAK.
  PERFORM LINE_BREAK.

  WA_CONTENTS-LINE = 'Regards.'.
  APPEND WA_CONTENTS TO IT_CONTENTS.
  CLEAR : WA_CONTENTS.

  PERFORM LINE_BREAK.
  PERFORM SET_EMAILID.


  TRY.
*     -------- create persistent send request ------------------------
      GO_SEND_REQUEST = CL_BCS=>CREATE_PERSISTENT( ).

      GO_DOCUMENT = CL_DOCUMENT_BCS=>CREATE_DOCUMENT(
        I_TYPE    = 'HTM'
        I_TEXT    = IT_CONTENTS
*       i_length  = '12'
        I_SUBJECT = '' ).             "'


      "Subject
      VSUBJECT = 'Employee Creation Status'.

      CALL METHOD GO_SEND_REQUEST->SET_MESSAGE_SUBJECT
        EXPORTING
          IP_SUBJECT = VSUBJECT.

      CALL METHOD GO_SEND_REQUEST->SET_DOCUMENT( GO_DOCUMENT ).

      "from
      SENDER1 = CL_CAM_ADDRESS_BCS=>CREATE_INTERNET_ADDRESS( P_FROMID ).
      CALL METHOD GO_SEND_REQUEST->SET_SENDER
        EXPORTING
          I_SENDER = SENDER1.

      "to
      LO_RECIPIENT = CL_CAM_ADDRESS_BCS=>CREATE_INTERNET_ADDRESS( S_TOID-LOW ).
      CALL METHOD GO_SEND_REQUEST->ADD_RECIPIENT
        EXPORTING
          I_RECIPIENT = LO_RECIPIENT
          I_EXPRESS   = 'X'.

      CLEAR LO_RECIPIENT.

      "cc
      LO_RECIPIENT = CL_CAM_ADDRESS_BCS=>CREATE_INTERNET_ADDRESS( S_CCID-LOW ).
      CALL METHOD GO_SEND_REQUEST->ADD_RECIPIENT
        EXPORTING
          I_RECIPIENT = LO_RECIPIENT
          I_COPY      = 'X'.

      CLEAR LO_RECIPIENT.

      CALL METHOD GO_SEND_REQUEST->SEND_REQUEST->SET_LINK_TO_OUTBOX( 'X' ).

*     ---------- send document ---------------------------------------
      CALL METHOD GO_SEND_REQUEST->SET_SEND_IMMEDIATELY
        EXPORTING
          I_SEND_IMMEDIATELY = 'X'.

      CALL METHOD GO_SEND_REQUEST->SEND(
        EXPORTING
          I_WITH_ERROR_SCREEN = 'X'
        RECEIVING
          RESULT              = LV_SENT_TO_ALL ).

      IF LV_SENT_TO_ALL = 'X'.
        MESSAGE S000(8I) WITH 'Email send successfully'.
      ELSEIF LV_SENT_TO_ALL IS INITIAL.
        MESSAGE S000(8I) WITH 'Email not send'.
      ENDIF.
      COMMIT WORK.
    CATCH CX_BCS INTO LO_BCS_EXCEPTION.
  ENDTRY.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form LINE_BREAK
*&---------------------------------------------------------------------*

FORM LINE_BREAK .
  WA_CONTENTS-LINE = '<br>'.
  APPEND WA_CONTENTS TO IT_CONTENTS.
  CLEAR : WA_CONTENTS.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_EMAILID
*&---------------------------------------------------------------------*

FORM SET_EMAILID .
  P_FROMID    = 'edp_staff@bluecrosslabs.com'. "from list
  S_TOID-LOW  = 'edp_staff@bluecrosslabs.com'.  "to list
  S_CCID-LOW  = 'edp_staff@bluecrosslabs.com'.  "cc list

  SORT S_TOID BY LOW. DELETE ADJACENT DUPLICATES FROM S_TOID COMPARING LOW.
  SORT S_CCID BY LOW. DELETE ADJACENT DUPLICATES FROM S_CCID COMPARING LOW.
  DELETE S_TOID WHERE LOW EQ SPACE.
  DELETE S_CCID WHERE LOW EQ SPACE.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form CALL_POSITION_API
*&---------------------------------------------------------------------*


FORM CALL_POSITION_API  USING IV_URL    TYPE STRING
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
      WRITE: / 'Exception in CALL_POSITION_API:', LX2->GET_TEXT( ).
      CLEAR EV_JSON.
  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PARSE_POSITION_JSON
*&---------------------------------------------------------------------*

FORM PARSE_POSITION_JSON  USING    IV_JSON TYPE STRING
                       CHANGING CT_POSITION TYPE TY_POSITION_TAB.

  DATA: LT_RAW      TYPE TY_POSITION_TAB,
        LS_RAW      TYPE TY_POSITION,
        LS_POSITION TYPE TY_POSITION.

  CLEAR LT_RAW.
  /UI2/CL_JSON=>DESERIALIZE( EXPORTING JSON = IV_JSON CHANGING DATA = LT_RAW ).

  CLEAR CT_POSITION.
  LOOP AT LT_RAW INTO LS_RAW.
    CLEAR LS_POSITION.
    MOVE-CORRESPONDING LS_RAW TO LS_POSITION.
    APPEND LS_POSITION TO CT_POSITION.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form UPDATE_EMPLOYEE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM UPDATE_EMPLOYEE USING WA_EMP TYPE TY_EMPOYEE.

  "Get the current employee row being processed in the caller's LOOP
  DATA: LS_EMP TYPE TY_EMPOYEE,
        LV_IDX TYPE SY-TABIX VALUE '0'.


  LS_EMP-EMPLOYEECODE = WA_EMP-EMPLOYEECODE.
  READ TABLE GT_EMPLOYEE INTO LS_EMP WITH KEY  EMPLOYEECODE = LS_EMP-EMPLOYEECODE.
  IF SY-SUBRC <> 0 OR LS_EMP-EMPLOYEECODE IS INITIAL.
    RETURN. "nothing to do
  ENDIF.

  "Normalize PERNR and dates
  DATA: LV_PERNR TYPE PERNR-PERNR,
        LV_BEGDA TYPE BEGDA,
        LV_ENDDA TYPE ENDDA VALUE '99991231'.

  LV_PERNR = LS_EMP-EMPLOYEECODE.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      INPUT  = LV_PERNR
    IMPORTING
      OUTPUT = LV_PERNR.

  LV_BEGDA = SY-DATUM.
  IF LS_EMP-JOINING_DATE IS NOT INITIAL.
    DATA(LV_JDATE) = LS_EMP-JOINING_DATE.
    REPLACE ALL OCCURRENCES OF '-' IN LV_JDATE WITH ''.
    REPLACE ALL OCCURRENCES OF '.' IN LV_JDATE WITH ''.
    REPLACE ALL OCCURRENCES OF '/' IN LV_JDATE WITH ''.
    IF LV_JDATE CO '0123456789' AND STRLEN( LV_JDATE ) = 8.
      LV_BEGDA = LV_JDATE+4(4) && LV_JDATE+2(2) && LV_JDATE+0(2).
    ENDIF.
  ENDIF.

  "Ensure employee exists (this branch is called only when PA0000 exists, but keep it safe)
  SELECT SINGLE PERNR FROM PA0000 INTO @DATA(LV_EXIST)
    WHERE PERNR = @LV_PERNR.
  IF SY-SUBRC <> 0.
    RETURN.
  ENDIF.

  DATA: LS_RET TYPE BAPIRETURN1,
        LS_MSG TYPE TY_MSG.
  DATA LV_OPER TYPE ACTIO VALUE 'MOD'.

  "---------------- IT0001 (Organizational Assignment) -----------------
  DATA LS_P0001 TYPE P0001.
  CLEAR LS_P0001.


  SELECT SINGLE * FROM PA0001 INTO @DATA(LW_PA0001)
                              WHERE PERNR = @LV_PERNR AND
                              ENDDA GE @SY-DATUM AND
                              BEGDA LE @SY-DATUM.

  LS_P0001-BEGDA = LW_PA0001-BEGDA.
  LS_P0001-ENDDA = LW_PA0001-ENDDA.
  LS_P0001-PERNR = LW_PA0001-PERNR.
  LS_P0001-BUKRS = LW_PA0001-BUKRS.
  "LS_P0001-VDSK1 =
  LS_P0001-SNAME = LW_PA0001-SNAME.
  LS_P0001-ENAME = LW_PA0001-ENAME.
  LS_P0001-INFTY = '0001'.


  LS_P0001-WERKS = LW_PA0001-WERKS. " LV_WERKS.
  LS_P0001-BTRTL = LS_EMP-DEPARTMENT_CODE.

  "Employee Group mapping as in your create branch
  DATA(LV_PERSG) = LS_EMP-EMPLOYEE_STATUS_CODE.
  TRANSLATE LV_PERSG TO UPPER CASE.
  IF LV_PERSG = 'CONFIRMED' OR LV_PERSG = 'PROBATION' OR LV_PERSG = 'PROBATIONER'.
    LV_PERSG = '1'.
  ENDIF.
  LS_P0001-PERSG = LV_PERSG.
  LS_P0001-PERSK = LS_EMP-SUB_GROUP_CODE.
  LS_P0001-SBMOD = LW_PA0001-SBMOD.
  LS_P0001-OTYPE = LW_PA0001-OTYPE.

  IF LS_EMP-POSITION_CODE IS NOT INITIAL.
    LS_P0001-PLANS = LS_EMP-POSITION_CODE.
  ENDIF.

  "Optional fields (existence-safe)
  FIELD-SYMBOLS: <ABKRS> TYPE ANY, <ZZHQ> TYPE ANY.
  ASSIGN COMPONENT 'ABKRS'     OF STRUCTURE LS_P0001 TO <ABKRS>.
  IF <ABKRS> IS ASSIGNED. <ABKRS> = LS_EMP-PAYROLL_AREA_CODE. ENDIF.
  ASSIGN COMPONENT 'ZZ_HQCODE' OF STRUCTURE LS_P0001 TO <ZZHQ>.
  IF <ZZHQ>  IS ASSIGNED. <ZZHQ>  = LS_EMP-HQ_CODE.          ENDIF.

  IF LS_P0001-ZZ_HQCODE NE LW_PA0001-ZZ_HQCODE OR
     LS_P0001-ABKRS NE LW_PA0001-ABKRS.


    CALL FUNCTION 'HR_EMPLOYEE_ENQUEUE'
      EXPORTING
        NUMBER = LV_PERNR
      EXCEPTIONS
        OTHERS = 1.
    IF SY-SUBRC <> 0.
      LS_MSG = VALUE #( EMPLOYEECODE = LS_EMP-EMPLOYEECODE
                        FIRSTNAME    = LS_EMP-FIRSTNAME
                        LASTNAME     = LS_EMP-LASTNAME
                        MSG_TYPE     = 'E'
                        MSG          = |Lock failed for { LS_EMP-EMPLOYEECODE }| ).
      APPEND LS_MSG TO IT_MSG.
      RETURN.
    ENDIF.


    CALL FUNCTION 'HR_INFOTYPE_OPERATION'
      EXPORTING
        NUMBER        = LV_PERNR
        INFTY         = '0001'
        VALIDITYBEGIN = LS_P0001-BEGDA
        VALIDITYEND   = LS_P0001-ENDDA
        RECORD        = LS_P0001
        OPERATION     = LV_OPER
        TCLAS         = 'A'
        DIALOG_MODE   = '0'
        NOCOMMIT      = ' '
      IMPORTING
        RETURN        = LS_RET.

    LS_MSG = VALUE #( EMPLOYEECODE = LS_EMP-EMPLOYEECODE
                      FIRSTNAME    = LS_EMP-FIRSTNAME
                      LASTNAME     = LS_EMP-LASTNAME
                      MSG_TYPE     = LS_RET-TYPE
                      MSG          = |0001 { LS_RET-ID }-{ LS_RET-NUMBER }: { LS_RET-MESSAGE }| ).
    APPEND LS_MSG TO IT_MSG.

    CALL FUNCTION 'BAPI_EMPLOYEE_DEQUEUE'
      EXPORTING
        NUMBER = LV_PERNR
      IMPORTING
        RETURN = LS_RET.

    COMMIT WORK AND WAIT.
  ENDIF.
  "---------------- IT0002 (Personal Data) -----------------------------
  DATA LS_P0002 TYPE P0002.
  CLEAR LS_P0002.

  SELECT SINGLE * FROM PA0002
                  INTO @DATA(LW_P0002)
                  WHERE PERNR EQ @LV_PERNR AND
                        ENDDA GE @SY-DATUM AND
                        BEGDA LE @SY-DATUM.


  LS_P0002-BEGDA = LW_P0002-BEGDA. "LV_BEGDA.
  LS_P0002-ENDDA = LW_P0002-ENDDA.  "LV_ENDDA.

  "Title: ANRED (fallback to ANREX if your structure uses it)
  DATA(LV_SAL) = LS_EMP-SALUTATION.
  IF LV_SAL CS '.'.
    SPLIT LV_SAL AT '.' INTO LV_SAL DATA(LV_DUMMY).
  ENDIF.

  CASE LV_SAL.
    WHEN 'Mr'.
      CLEAR LV_SAL.
      LV_SAL = '1'.
    WHEN 'Mrs'.
      CLEAR LV_SAL.
      LV_SAL = '2'.
    WHEN 'Miss'.
      CLEAR LV_SAL.
      LV_SAL = '3'.
    WHEN 'Ms'.
      CLEAR LV_SAL.
      LV_SAL = '4'.
  ENDCASE.

  FIELD-SYMBOLS: <ANRED> TYPE ANY, <ANREX> TYPE ANY.
  ASSIGN COMPONENT 'ANRED' OF STRUCTURE LS_P0002 TO <ANRED>.
  IF <ANRED> IS ASSIGNED.
    <ANRED> = LV_SAL.
  ELSE.
    ASSIGN COMPONENT 'ANREX' OF STRUCTURE LS_P0002 TO <ANREX>.
    IF <ANREX> IS ASSIGNED. <ANREX> = LV_SAL. ENDIF.
  ENDIF.

  LS_P0002-NACHN = LS_EMP-LASTNAME.
  LS_P0002-VORNA = LS_EMP-FIRSTNAME.

  DATA(LV_GESCH) = LS_EMP-GENDER.
  TRANSLATE LV_GESCH TO UPPER CASE.
  IF LV_GESCH = 'MALE'.
    LV_GESCH = '1'.
  ELSEIF LV_GESCH = 'FEMALE'.
    LV_GESCH = '2'.
  ENDIF.
  LS_P0002-GESCH = LV_GESCH.
  "LS_P0002-SPRSL = 'EN'.
  LS_P0002-PERNR = LV_PERNR.
  LS_P0002-INFTY = '0002'.

  IF LS_EMP-DATE_OF_BIRTH IS NOT INITIAL.
    DATA(LV_BD) = LS_EMP-DATE_OF_BIRTH.
    REPLACE ALL OCCURRENCES OF '-' IN LV_BD WITH ''.
    REPLACE ALL OCCURRENCES OF '.' IN LV_BD WITH ''.
    REPLACE ALL OCCURRENCES OF '/' IN LV_BD WITH ''.
    IF LV_BD CO '0123456789' AND STRLEN( LV_BD ) = 8.
      LS_P0002-GBDAT = LV_BD+4(4) && LV_BD+2(2) && LV_BD+0(2) .
    ENDIF.
  ENDIF.
  LS_P0002-NATIO = LW_P0002-NATIO. "'IN'.
  LS_P0002-SPRSL = LW_P0002-SPRSL.
  LS_P0002-AEDTM = LW_P0002-AEDTM.
  LS_P0002-GBJHR = LV_BD+4(4).
  LS_P0002-GBMON = LV_BD+2(2).
  LS_P0002-GBTAG = LV_BD+0(2).

  IF  LS_P0002-GBDAT NE LW_P0002-GBDAT OR
      LS_P0002-GESCH NE LW_P0002-GESCH OR
      LS_P0002-NACHN NE LW_P0002-NACHN OR
      LS_P0002-VORNA NE LW_P0002-VORNA OR
      LS_P0002-ANRED NE LW_P0002-ANRED.

    CALL FUNCTION 'HR_EMPLOYEE_ENQUEUE'
      EXPORTING
        NUMBER = LV_PERNR
      EXCEPTIONS
        OTHERS = 1.

    CALL FUNCTION 'HR_INFOTYPE_OPERATION'
      EXPORTING
        INFTY         = '0002'
        NUMBER        = LV_PERNR
        VALIDITYBEGIN = LS_P0002-BEGDA
        VALIDITYEND   = LS_P0002-ENDDA
        RECORD        = LS_P0002
        OPERATION     = LV_OPER
        TCLAS         = 'A'
        DIALOG_MODE   = '0'
        NOCOMMIT      = ' '
      IMPORTING
        RETURN        = LS_RET.

    LS_MSG = VALUE #( EMPLOYEECODE = LS_EMP-EMPLOYEECODE
                      FIRSTNAME    = LS_EMP-FIRSTNAME
                      LASTNAME     = LS_EMP-LASTNAME
                      MSG_TYPE     = LS_RET-TYPE
                      MSG          = |0002 { LS_RET-ID }-{ LS_RET-NUMBER }: { LS_RET-MESSAGE }| ).
    APPEND LS_MSG TO IT_MSG.


    CALL FUNCTION 'BAPI_EMPLOYEE_DEQUEUE'
      EXPORTING
        NUMBER = LV_PERNR
      IMPORTING
        RETURN = LS_RET.

    COMMIT WORK AND WAIT.
  ENDIF.

  "---------------- IT0006 (Address) SUBTY = 1 -------------------------
  DATA LS_P0006 TYPE P0006.
  CLEAR LS_P0006.

  SELECT SINGLE * FROM PA0006
                  INTO @DATA(LW_P0006)
                  WHERE PERNR EQ @LV_PERNR AND
                        ENDDA GE @SY-DATUM AND
                        BEGDA LE @SY-DATUM.

  IF
    LW_P0006-NAME2 NE LS_EMP-CURRENT_ADRESS_FLAT_NO OR
    LW_P0006-STRAS NE LS_EMP-CURRENT_ADDRESS_PREMISE OR
    LW_P0006-LOCAT NE LS_EMP-CURRENT_ADDRESS_ROAD && LS_EMP-CURRENT_ADDRESS_AREA OR
    LW_P0006-PSTLZ NE LS_EMP-CURRENT_ADDRESS_PINCODE OR
    LW_P0006-ORT01 NE LS_EMP-CURRENT_ADDRESS_TOWN OR
    LW_P0006-ORT02 NE LS_EMP-CURRENT_ADDRESS_STATE OR
    ( LW_P0006-TELNR NE LS_EMP-TELEPHONE OR
    LW_P0006-TELNR NE LS_EMP-MOBILE_NO ).

    LS_P0006-INFTY = '0006'.
    LS_P0006-PERNR = LV_PERNR.
    LS_P0006-SUBTY = LW_P0006-SUBTY.
    LS_P0006-NAME2 = LS_EMP-CURRENT_ADRESS_FLAT_NO .
    LS_P0006-STRAS = LS_EMP-CURRENT_ADDRESS_PREMISE .
    LS_P0006-LOCAT = LS_EMP-CURRENT_ADDRESS_ROAD && LS_EMP-CURRENT_ADDRESS_AREA .
    LS_P0006-PSTLZ = LS_EMP-CURRENT_ADDRESS_PINCODE .
    LS_P0006-ORT01 = LS_EMP-CURRENT_ADDRESS_TOWN .
    LS_P0006-TELNR = LS_EMP-TELEPHONE.
    IF LS_P0006-TELNR IS INITIAL.
      LS_P0006-TELNR = LS_EMP-MOBILE_NO.
    ENDIF.
    LS_P0006-BEGDA = LW_P0006-BEGDA .
    LS_P0006-ENDDA = LW_P0006-ENDDA .
    LS_P0006-ANSSA = LW_P0006-ANSSA .

    FIELD-SYMBOLS <ORT02> TYPE ANY.
    ASSIGN COMPONENT 'ORT02' OF STRUCTURE LS_P0006 TO <ORT02>.
    IF <ORT02> IS ASSIGNED. <ORT02> = LS_EMP-CURRENT_ADDRESS_STATE. ENDIF.
    LS_P0006-LAND1 = COND LAND1( WHEN LS_EMP-CURRENT_ADDRESS_COUNTRY IS INITIAL THEN 'IN'
                                 ELSE LS_EMP-CURRENT_ADDRESS_COUNTRY ).


    CALL FUNCTION 'HR_EMPLOYEE_ENQUEUE'
      EXPORTING
        NUMBER = LV_PERNR
      EXCEPTIONS
        OTHERS = 1.
    "UPDATE_ADDRESS
    CALL FUNCTION 'HR_INFOTYPE_OPERATION'
      EXPORTING
        INFTY         = '0006'
        NUMBER        = LV_PERNR
        SUBTYPE       = '1'            "Permanent address
        VALIDITYBEGIN = LW_P0006-BEGDA
        VALIDITYEND   = LW_P0006-ENDDA
        RECORD        = LS_P0006
        OPERATION     = LV_OPER
        TCLAS         = 'A'
        DIALOG_MODE   = '0'
        NOCOMMIT      = ' '
      IMPORTING
        RETURN        = LS_RET.

    LS_MSG = VALUE #( EMPLOYEECODE = LS_EMP-EMPLOYEECODE
                      FIRSTNAME    = LS_EMP-FIRSTNAME
                      LASTNAME     = LS_EMP-LASTNAME
                      MSG_TYPE     = LS_RET-TYPE
                      MSG          = |0006(1) { LS_RET-ID }-{ LS_RET-NUMBER }: { LS_RET-MESSAGE }| ).
    APPEND LS_MSG TO IT_MSG.

    "Unlock & commit for this employee (0105 is handled by your code after this PERFORM)
    CALL FUNCTION 'BAPI_EMPLOYEE_DEQUEUE'
      EXPORTING
        NUMBER = LV_PERNR
      IMPORTING
        RETURN = LS_RET.

    COMMIT WORK AND WAIT.
  ENDIF.

  "---------------- IT0009 (Bank Details) SUBTY = 1 -------------------------

  DATA: L_RETURN  TYPE BAPIRETURN1,
        V_SUBTY   TYPE SUBTY           VALUE '0010',
        LV_OP     TYPE PSPAR-ACTIO,
        LT_PA0009 TYPE TABLE OF P0009,
        V_BEGDA   TYPE PRELP-BEGDA.

  IF WA_EMP-JOINING_DATE IS NOT INITIAL.
    DATA(V_JDATE) = WA_EMP-JOINING_DATE.
    REPLACE ALL OCCURRENCES OF '-' IN V_JDATE WITH ''.
    REPLACE ALL OCCURRENCES OF '.' IN V_JDATE WITH ''.
    REPLACE ALL OCCURRENCES OF '/' IN V_JDATE WITH ''.
    IF V_JDATE CO '0123456789' AND STRLEN( V_JDATE ) = 8.
      V_BEGDA = V_JDATE+4(4) && V_JDATE+2(2) && V_JDATE+0(2).
      "LV_BEGDA = LV_JDATE.
    ENDIF.
  ENDIF.


  CALL FUNCTION 'BAPI_EMPLOYEE_ENQUEUE'
    EXPORTING
      NUMBER = LV_PERNR
    IMPORTING
      RETURN = L_RETURN.

  CALL FUNCTION 'HR_READ_INFOTYPE'
    EXPORTING
      PERNR     = LV_PERNR
      INFTY     = '0009'
      BEGDA     = V_BEGDA
      ENDDA     = '99991231'
    TABLES
      INFTY_TAB = LT_PA0009
    EXCEPTIONS
      OTHERS    = 1.

  READ TABLE LT_PA0009 INTO DATA(LS_PA0009) WITH KEY PERNR = WA_EMP-EMPLOYEECODE.
  IF SY-SUBRC <> 0.

    DATA: ZENDDA TYPE D VALUE '99991231'.
    CLEAR LS_PA0009.

    LS_PA0009-PERNR = LV_PERNR.
    LS_PA0009-SUBTY = '0'.
    LS_PA0009-BEGDA = V_BEGDA.
    LS_PA0009-BNKSA = '0'.
    LS_PA0009-BANKL = WA_EMP-BANK_KEY.
    LS_PA0009-BANKN = WA_EMP-BANKACCOUNTNUMBER.
    LS_PA0009-ZWECK = WA_EMP-PAN_NO.
    LS_PA0009-WAERS = 'INR'.
    LS_PA0009-BANKS = 'IN'.
    LS_PA0009-EMFTX = WA_EMP-FIRSTNAME && WA_EMP-LASTNAME.
    LS_PA0009-BKORT = WA_EMP-CURRENT_ADDRESS_TOWN.
    LS_PA0009-BKPLZ = WA_EMP-CURRENT_ADDRESS_PINCODE.
    LS_PA0009-ADRS_BANKS = 'IN'.
    LS_PA0009-ZLSCH = 'T'.
    LS_PA0009-ENDDA = ZENDDA.
    LV_OP = 'INS'.

  ELSE.
    SELECT SINGLE * FROM PA0009
            INTO @DATA(LW_P0009)
            WHERE PERNR EQ @LV_PERNR AND
                  ENDDA GE @SY-DATUM AND
                  BEGDA LE @SY-DATUM.

    CLEAR LS_PA0009.
    LS_PA0009-EMFTX = LS_EMP-FIRSTNAME && LS_EMP-LASTNAME.
    LS_PA0009-BKORT = LS_EMP-CURRENT_ADDRESS_TOWN.
    LS_PA0009-BKPLZ = LS_EMP-CURRENT_ADDRESS_PINCODE.
    LS_PA0009-WAERS = LW_P0009-WAERS.
    LS_PA0009-BNKSA = '0'.
    LS_PA0009-SUBTY = LW_P0009-SUBTY.
    LS_PA0009-ENDDA = LW_P0009-ENDDA.
    LS_PA0009-BEGDA = LW_P0009-BEGDA.
    LS_PA0009-PERNR = LV_PERNR.
    LS_PA0009-BANKL = LS_EMP-BANK_KEY.
    LS_PA0009-BANKN = LS_EMP-BANKACCOUNTNUMBER.
    LS_PA0009-ZWECK = LS_EMP-PAN_NO.
    LS_PA0009-WAERS = LW_P0009-WAERS.
    LS_PA0009-BANKS = LW_P0009-BANKS.
    LS_PA0009-INFTY = '0009'.
    LS_PA0009-AEDTM = LW_P0009-AEDTM.
    LS_PA0009-ZLSCH = LW_P0009-ZLSCH.
    LS_PA0009-ADRS_BANKS = 'IN'.
    LV_OP = 'MOD'.

  ENDIF.

  IF LV_OP = 'INS'.
    "BANK_CREATE
    CALL FUNCTION 'HR_INFOTYPE_OPERATION'
      EXPORTING
        INFTY         = '0009'
        SUBTYPE       = V_SUBTY
        NUMBER        = LV_PERNR
        VALIDITYBEGIN = V_BEGDA
        VALIDITYEND   = ZENDDA
        RECORD        = LS_PA0009
        OPERATION     = LV_OP          " 'INS' or 'MOD'
        TCLAS         = 'A'
        DIALOG_MODE   = '0'
        NOCOMMIT      = ' '            " we will COMMIT ourselves
      IMPORTING
        RETURN        = L_RETURN.

  ELSEIF LS_PA0009-BANKL NE LW_P0009-BANKL OR
         LS_PA0009-BANKN NE LW_P0009-BANKN OR
         LS_PA0009-BKPLZ NE LW_P0009-BKPLZ OR
         LS_PA0009-BKORT NE LW_P0009-BKORT.

    "BANK_UPDATE

    CALL FUNCTION 'HR_INFOTYPE_OPERATION'
      EXPORTING
        INFTY         = '0009'
        SUBTYPE       = V_SUBTY
        NUMBER        = LV_PERNR
        VALIDITYBEGIN = V_BEGDA
        VALIDITYEND   = ZENDDA
        RECORD        = LS_PA0009
        OPERATION     = LV_OP          " 'INS' or 'MOD'
        TCLAS         = 'A'
        DIALOG_MODE   = '0'
        NOCOMMIT      = ' '            " we will COMMIT ourselves
      IMPORTING
        RETURN        = L_RETURN.

  ENDIF.

  CLEAR: WA_MSG.

  WA_MSG = VALUE #( EMPLOYEECODE = WA_EMP-EMPLOYEECODE
                    FIRSTNAME    = WA_EMP-FIRSTNAME
                    LASTNAME     = WA_EMP-LASTNAME
                    MSG_TYPE     = L_RETURN-TYPE
                    MSG          = |0009(1) { L_RETURN-ID }-{ L_RETURN-NUMBER }: { L_RETURN-MESSAGE }| ).
  APPEND WA_MSG TO IT_MSG.

  IF L_RETURN-TYPE CA 'EA'.
    CALL FUNCTION 'BAPI_EMPLOYEE_DEQUEUE'
      EXPORTING
        NUMBER = LV_PERNR
      IMPORTING
        RETURN = L_RETURN.
  ENDIF.

  COMMIT WORK AND WAIT.

  CALL FUNCTION 'BAPI_EMPLOYEE_DEQUEUE'
    EXPORTING
      NUMBER = LV_PERNR
    IMPORTING
      RETURN = L_RETURN.

  """""""""""""""""""""""""""""""""""""""'



*  DATA LS_P0009 TYPE P0009.
*  CLEAR LS_P0009.
*
*  SELECT SINGLE * FROM PA0009
*                  INTO @DATA(LW_P0009)
*                  WHERE PERNR EQ @LV_PERNR AND
*                        ENDDA GE @SY-DATUM AND
*                        BEGDA LE @SY-DATUM.
*
*  LS_P0009-EMFTX = LS_EMP-FIRSTNAME && LS_EMP-LASTNAME.
*  LS_P0009-BKORT = LS_EMP-CURRENT_ADDRESS_TOWN.
*  LS_P0009-BKPLZ = LS_EMP-CURRENT_ADDRESS_PINCODE.
*  LS_P0009-WAERS = LW_P0009-WAERS.
*  LS_P0009-BNKSA = '0'.
*  LS_P0009-SUBTY = LW_P0009-SUBTY.
*  LS_P0009-ENDDA = LW_P0009-ENDDA.
*  LS_P0009-BEGDA = LW_P0009-BEGDA.
*  LS_P0009-PERNR = LV_PERNR.
*  LS_P0009-BANKL = LS_EMP-BANK_KEY.
*  LS_P0009-BANKN = LS_EMP-BANKACCOUNTNUMBER.
*  LS_P0009-ZWECK = LS_EMP-PAN_NO.
*  LS_P0009-WAERS = LW_P0009-WAERS.
*  LS_P0009-BANKS = LW_P0009-BANKS.
*  LS_P0009-INFTY = '0009'.
*  LS_P0009-AEDTM = LW_P0009-AEDTM.
*  LS_P0009-ZLSCH = LW_P0009-ZLSCH.
*  LS_P0009-ADRS_BANKS = 'IN'.
*
*  IF LS_P0009-BANKL NE LW_P0009-BANKL OR
*     LS_P0009-BANKN NE LW_P0009-BANKN OR
*     LS_P0009-BKPLZ NE LW_P0009-BKPLZ OR
*     LS_P0009-BKORT NE LW_P0009-BKORT.
*
*
*    CALL FUNCTION 'HR_EMPLOYEE_ENQUEUE'
*      EXPORTING
*        NUMBER = LV_PERNR
*      EXCEPTIONS
*        OTHERS = 1.
*
*    "BANK DETAILS
*    CALL FUNCTION 'HR_INFOTYPE_OPERATION'
*      EXPORTING
*        INFTY         = '0009'
*        NUMBER        = LV_PERNR
*        SUBTYPE       = '0'            "Permanent address
*        VALIDITYBEGIN = LS_P0009-BEGDA
*        VALIDITYEND   = LS_P0009-ENDDA
*        RECORD        = LS_P0009
*        OPERATION     = LV_OPER
*        TCLAS         = 'A'
*        DIALOG_MODE   = '0'
*        NOCOMMIT      = ' '
*      IMPORTING
*        RETURN        = LS_RET.
*
*    LS_MSG = VALUE #( EMPLOYEECODE = LS_EMP-EMPLOYEECODE
*                      FIRSTNAME    = LS_EMP-FIRSTNAME
*                      LASTNAME     = LS_EMP-LASTNAME
*                      MSG_TYPE     = LS_RET-TYPE
*                      MSG          = |0009(1) { LS_RET-ID }-{ LS_RET-NUMBER }: { LS_RET-MESSAGE }| ).
*    APPEND LS_MSG TO IT_MSG.
*
*    "Unlock & commit for this employee (0105 is handled by your code after this PERFORM)
*    CALL FUNCTION 'BAPI_EMPLOYEE_DEQUEUE'
*      EXPORTING
*        NUMBER = LV_PERNR
*      IMPORTING
*        RETURN = LS_RET.
*
*    COMMIT WORK AND WAIT.
*  ENDIF.
ENDFORM.
