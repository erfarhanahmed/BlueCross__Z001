*&---------------------------------------------------------------------*
*& Report ZQM_NOTIF_SAMPLE_AUTO_QMO1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZQM_NOTIF_SAMPLE_AUTO_QMO1.
DATA : EXTERNAL_NUMBER TYPE  BAPI2078_NOTHDRE-NOTIF_NO .
DATA : NOTTIF_TYPE TYPE BAPI2078_NOTHDRE-NOTIF_TYPE.
DATA : NOTIFHEADER TYPE BAPI2078_NOTHDRI.
DATA : RETURN TYPE TABLE OF BAPIRET2.
DATA : LT_RETURN TYPE TABLE OF BAPIRET2.

TYPES : BEGIN OF TY_FINAL,
          QMNUM    TYPE QMNUM,
          MATNR    TYPE MATNR,
          MAWERK   TYPE QMEL-MAWERK,
          CHARG    TYPE CHARG,
          LGORT    TYPE QLGORTCHAR,
          QMGRP    TYPE QMGRP,
          QMCOD    TYPE QMCOD,
          QMTXT    TYPE QMTXT,
          PRIMPACK TYPE QST010100-PRIMPACK,
          GBTYP    TYPE QST010100-GBTYP,
          MENGE    TYPE QST010100-MENGE,
          MEINH    TYPE QST010100-MEINH,
          STABICON TYPE QST010100-STABICON,
          ABORT    TYPE QST010100-ABORT,
          KTEXT    TYPE QST010100-KTEXT,
*          MENGE  TYPE MENGE,

        END OF TY_FINAL.
DATA: IT_DATA          TYPE STANDARD TABLE OF TY_FINAL,
      WA_DATA          TYPE TY_FINAL,
      IT_RAW           TYPE TRUXS_T_TEXT_DATA,
      LV_FILENAME      TYPE RLGRAP-FILENAME,
      LV_CLEANED_VALUE TYPE STRING.
DATA : IT_EXCEL TYPE TABLE OF ALSMEX_TABLINE.

DATA: LT_BDCDATA TYPE TABLE OF BDCDATA,
      LS_BDCDATA TYPE BDCDATA,
      LT_MSG     TYPE TABLE OF BDCMSGCOLL.

DATA : NOTIFHEADER2 TYPE  BAPI2078_NOTHDRE.
*       LV_FILENAME      TYPE RLGRAP-FILENAME.
*PARAMETERS : P_NOTIF TYPE BAPI2078_NOTHDRE-NOTIF_NO OBLIGATORY.
PARAMETERS: P_FILE TYPE RLGRAP-FILENAME OBLIGATORY.
PARAMETERS : P_MODE TYPE CTU_PARAMS-DISMODE DEFAULT 'N'.
*2.
* Data declarations (replace with actual parameter types from SE37)
*  DATA: LS_IMPORT_PARAMS  TYPE TYPE_FOR_IMPORT_STRUCTURE, " Structure for import data
*        LT_TABLE_PARAMS   TYPE TABLE OF TYPE_FOR_TABLE_STRUCTURE, " Internal table for table data
*        LS_EXPORT_PARAMS  TYPE TYPE_FOR_EXPORT_STRUCTURE, " Structure for export data
*        LV_RETURN_MESSAGE TYPE C LENGTH 255. " Variable for return messages




AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      PROGRAM_NAME  = SYST-CPROG
      DYNPRO_NUMBER = SYST-DYNNR
      FIELD_NAME    = ' '
    IMPORTING
      FILE_NAME     = P_FILE.

START-OF-SELECTION.
  LV_FILENAME  =  P_FILE.
  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      FILENAME                = LV_FILENAME
      I_BEGIN_COL             = '1'
      I_BEGIN_ROW             = '2'
      I_END_COL               = '199'
      I_END_ROW               = '99999'
    TABLES
      INTERN                  = IT_EXCEL
    EXCEPTIONS
      INCONSISTENT_PARAMETERS = 1
      UPLOAD_OLE              = 2
      OTHERS                  = 3.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  LOOP AT IT_EXCEL INTO DATA(WA_EXCEL).
    CASE WA_EXCEL-COL.
      WHEN 1.
        WA_DATA-QMNUM =   WA_EXCEL-VALUE.
      WHEN 2.
        WA_DATA-MATNR  = WA_EXCEL-VALUE.
      WHEN 3.
        WA_DATA-MAWERK = WA_EXCEL-VALUE  .
      WHEN 4.
        WA_DATA-CHARG = WA_EXCEL-VALUE .
      WHEN 5.
        WA_DATA-LGORT = WA_EXCEL-VALUE.
      WHEN 6.
        WA_DATA-QMGRP  = WA_EXCEL-VALUE.
      WHEN 7.
        WA_DATA-QMCOD  = WA_EXCEL-VALUE.
      WHEN 8.
        WA_DATA-QMTXT  = WA_EXCEL-VALUE.
      WHEN 9.
        WA_DATA-PRIMPACK  = WA_EXCEL-VALUE.
      WHEN 10.
        WA_DATA-GBTYP  = WA_EXCEL-VALUE.
      WHEN 11.
        WA_DATA-MENGE  = WA_EXCEL-VALUE.
      WHEN 12.
        WA_DATA-MEINH  = WA_EXCEL-VALUE.
      WHEN 13.
        WA_DATA-STABICON  = WA_EXCEL-VALUE.
      WHEN 14.
        WA_DATA-ABORT  = WA_EXCEL-VALUE.
      WHEN 15.
        WA_DATA-KTEXT  = WA_EXCEL-VALUE.

    ENDCASE.

    AT END OF ROW.
      APPEND WA_DATA TO IT_DATA .
*      MODIFY zincvaldata FROM wa_data.
    ENDAT.
  ENDLOOP.
  BREAK CTPLSK.
*  BREAK-POINT.
  LOOP AT IT_DATA INTO DATA(WAA_DATA).

*  NOTTIF_TYPE = 'QS'.
*  NOTIFHEADER-MATERIAL = '11309'.
**  NOTIFHEADER-REFOBJECTTYPE = 'QS'.
*  NOTIFHEADER-MATERIAL_PLANT = '1000'.
*  NOTIFHEADER-BATCH = '0000001718'.
*  NOTIFHEADER-STOR_LOC_BATCH = 'FG01'.
*  NOTIFHEADER-CODE = '4'.
*  NOTIFHEADER-CODE_GROUP = 'QM'.
*  NOTIFHEADER-SHORT_TEXT = 'Test'.
*  NOTIFHEADER-NOTIF_DATE = SY-DATUM.
*  EXTERNAL_NUMBER = P_NOTIF. "'TEST1'.

    NOTTIF_TYPE = 'QS'.
    NOTIFHEADER-MATERIAL = WAA_DATA-MATNR.
*  NOTIFHEADER-REFOBJECTTYPE = 'QS'.
    NOTIFHEADER-MATERIAL_PLANT = WAA_DATA-MAWERK.
    NOTIFHEADER-BATCH = WAA_DATA-CHARG.
    NOTIFHEADER-STOR_LOC_BATCH = WAA_DATA-LGORT.
    NOTIFHEADER-CODE = WAA_DATA-QMCOD.
    NOTIFHEADER-CODE_GROUP = WAA_DATA-QMGRP.
    NOTIFHEADER-SHORT_TEXT = WAA_DATA-QMTXT.
    NOTIFHEADER-NOTIF_DATE = SY-DATUM.
    EXTERNAL_NUMBER = WAA_DATA-QMNUM. "'TEST1'.
    CALL FUNCTION 'BAPI_QUALNOT_CREATE'
      EXPORTING
        EXTERNAL_NUMBER = EXTERNAL_NUMBER
        NOTIF_TYPE      = NOTTIF_TYPE
        NOTIFHEADER     = NOTIFHEADER
*       TASK_DETERMINATION       = ' '
*       SENDER          =
* IMPORTING
*       NOTIFHEADER_EXPORT       =
      TABLES
*       NOTITEM         =
*       NOTIFCAUS       =
*       NOTIFACTV       =
*       NOTIFTASK       =
*       NOTIFPARTNR     =
*       LONGTEXTS       =
*       KEY_RELATIONSHIPS        =
        RETURN          = RETURN.
    " Check for errors from the BAPI call
    IF SY-SUBRC = 0.
      CLEAR : NOTIFHEADER2.
      CALL FUNCTION 'BAPI_QUALNOT_SAVE'
        EXPORTING
          NUMBER      = EXTERNAL_NUMBER
        IMPORTING
          NOTIFHEADER = NOTIFHEADER2
        TABLES
          RETURN      = RETURN.
      " Commit the transaction
      IF SY-SUBRC = 0.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            WAIT = 'X'.

*--------------------------------------------------------------
**2.
*
        DATA : I_WQMSM  TYPE WQMSM.
        DATA : I_VIQMEL  TYPE VIQMEL.
        DATA : E_SUBRC TYPE  SY-SUBRC.
        DATA : E_PROTOCOL TYPE TABLE OF RQEVP.
        CALL FUNCTION 'QST01_FA_CREATE_INITIAL_SAMPLE'
          EXPORTING
            I_WQMSM    = I_WQMSM
            I_VIQMEL   = I_VIQMEL
          IMPORTING
            E_SUBRC    = E_SUBRC
          TABLES
            E_PROTOCOL = E_PROTOCOL.
***********
*      Create Initial Sample



        PERFORM BDC_DYNPRO      USING 'SAPLIQS0' '0200'.
        PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                      'RIWO00-QMNUM'.
        PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                      '/00'.
        PERFORM BDC_FIELD       USING 'RIWO00-QMNUM'
                                      WAA_DATA-QMNUM. "'STAB02'.
        PERFORM BDC_DYNPRO      USING 'SAPLIQS0' '7200'.
        PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                      '=AX03'.
        PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                      'G_CONTROL_TAB-ICONE(03)'.
*        PERFORM BDC_FIELD       USING 'VIQMEL-MATNR'
*                                       WAA_DATA-MATNR. "'11309'.
*        PERFORM BDC_FIELD       USING 'VIQMEL-MAWERK'
*                                      WAA_DATA-MAWERK. " '1000'.
*        PERFORM BDC_FIELD       USING 'VIQMEL-CHARG'
*                                       WAA_DATA-CHARG. "'0000001718'.
*        PERFORM BDC_FIELD       USING 'VIQMEL-LGORTCHARG'
*                                     WAA_DATA-LGORT. "  'FG01'.
*        PERFORM BDC_FIELD       USING 'VIQMEL-QMGRP'
*                                      WAA_DATA-QMGRP. " 'QM'.
*        PERFORM BDC_FIELD       USING 'VIQMEL-QMCOD'
*                                       WAA_DATA-QMCOD. "'4'.
*        PERFORM BDC_FIELD       USING 'RIWO00-HEADKTXT'
*                                      'Stability Study'.
        PERFORM BDC_DYNPRO      USING 'SAPLQST01' '0100'.
        PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                      'QST010100-KTEXT'.
        PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                      '=AENDEING'.
        PERFORM BDC_FIELD       USING 'QST010100-PRART'
                                      '09'.
        PERFORM BDC_FIELD       USING 'QST010100-PRIMPACK'
                                       WAA_DATA-PRIMPACK. "'BOTTLE'.
        PERFORM BDC_FIELD       USING 'QST010100-GBTYP'
                                       WAA_DATA-GBTYP.      "'020000'.
        PERFORM BDC_FIELD       USING 'QST010100-MENGE'
                                       WAA_DATA-MENGE. "'100'.
        PERFORM BDC_FIELD       USING 'QST010100-MEINH'
                                       WAA_DATA-MEINH. "'EA'.
        PERFORM BDC_FIELD       USING 'QST010100-STABICON'
                                       WAA_DATA-STABICON. "'00000001'.
        PERFORM BDC_FIELD       USING 'QST010100-ABORT'
                                       WAA_DATA-ABORT. "'01'.
        PERFORM BDC_FIELD       USING 'QST010100-KTEXT'
                                      WAA_DATA-KTEXT ." 'ok'.
*        PERFORM BDC_TRANSACTION USING 'QM02'.
         CALL TRANSACTION 'QM02' USING LT_BDCDATA MODE P_MODE UPDATE 'S' MESSAGES INTO LT_MSG.
           REFRESH : LT_BDCDATA.
      ENDIF.
    ELSE.
      ROLLBACK WORK.
    ENDIF.

  ENDLOOP.








*
*
*
*
*        PERFORM BDC_DYNPRO      USING 'SAPLIQS0' '0200'.
*        PERFORM BDC_FIELD       USING 'BDC_CURSOR'
*                                      WAA_DATA-QMNUM. "'RIWO00-QMNUM'.
*        PERFORM BDC_FIELD       USING 'BDC_OKCODE'
*                                      '/00'.
*        PERFORM BDC_FIELD       USING 'RIWO00-QMNUM' WAA_DATA-QMNUM ."P_NOTIF.
**                                    'STAB02'.
*        PERFORM BDC_DYNPRO      USING 'SAPLIQS0' '7200'.
*        PERFORM BDC_FIELD       USING 'BDC_OKCODE'
*                                      '=AX03'.
*        PERFORM BDC_FIELD       USING 'BDC_CURSOR'
*                                      'G_CONTROL_TAB-ICONE(03)'.
**      PERFORM BDC_FIELD       USING 'VIQMEL-MATNR'
***                                    '11309'.
**      PERFORM BDC_FIELD       USING 'VIQMEL-MAWERK'
**                                    '1000'.
**      PERFORM BDC_FIELD       USING 'VIQMEL-CHARG'
**                                    '0000001718'.
**      PERFORM BDC_FIELD       USING 'VIQMEL-LGORTCHARG'
**                                    'FG01'.
**      PERFORM BDC_FIELD       USING 'VIQMEL-QMGRP'
**                                    'QM'.
**      PERFORM BDC_FIELD       USING 'VIQMEL-QMCOD'
**                                    '4'.
*        PERFORM BDC_FIELD       USING 'RIWO00-HEADKTXT'
*                                      'Stability Study'.
*        PERFORM BDC_DYNPRO      USING 'SAPLQST01' '0100'.
*        PERFORM BDC_FIELD       USING 'BDC_CURSOR'
*                                      'QST010100-KTEXT'.
*        PERFORM BDC_FIELD       USING 'BDC_OKCODE'
*                                      '=AENDEING'.
*        PERFORM BDC_FIELD       USING 'QST010100-PRART'
*                                      '09'.
*        PERFORM BDC_FIELD       USING 'QST010100-PRIMPACK'
*                                      WAA_DATA-PRIMPACK."'BOTTLE'.
*        PERFORM BDC_FIELD       USING 'QST010100-GBTYP'
*                                      WAA_DATA-GBTYP.       "'020000'.
*        PERFORM BDC_FIELD       USING 'QST010100-MENGE'
*                                      WAA_DATA-MENGE."'100'.
*        PERFORM BDC_FIELD       USING 'QST010100-MEINH'
*                                      WAA_DATA-MEINH."'EA'.
*        PERFORM BDC_FIELD       USING 'QST010100-STABICON'
*                                     WAA_DATA-STABICON." '00000001'.
*        PERFORM BDC_FIELD       USING 'QST010100-ABORT'
*                                      WAA_DATA-ABORT."'01'.
*        PERFORM BDC_FIELD       USING 'QST010100-KTEXT'
*                                      'ok'.
*        CALL TRANSACTION 'QM02' USING LT_BDCDATA MODE P_MODE UPDATE 'S' MESSAGES INTO LT_MSG.
*
*        REFRESH : LT_BDCDATA.
*        BREAK-POINT.
*
*        PERFORM BDC_DYNPRO      USING 'SAPLIQS0' '0200'.
*        PERFORM BDC_FIELD       USING 'BDC_CURSOR'
*                                      'RIWO00-QMNUM'.
*        PERFORM BDC_FIELD       USING 'BDC_OKCODE'
*                                      '/00'.
*        PERFORM BDC_FIELD       USING 'RIWO00-QMNUM'  WAA_DATA-QMNUM ."P_NOTIF .
**                                    'STAB02'.
*        PERFORM BDC_DYNPRO      USING 'SAPLIQS0' '7200'.
*        PERFORM BDC_FIELD       USING 'BDC_OKCODE'
*                                      '/00'.
**      PERFORM BDC_FIELD       USING 'BDC_CURSOR'
**                                    'VIQMEL-CHARG'.
**      PERFORM BDC_FIELD       USING 'VIQMEL-CHARG'
**                                    '0000001718'.
**      PERFORM BDC_FIELD       USING 'VIQMEL-LGORTCHARG'
**                                    'FG01'.
**      PERFORM BDC_FIELD       USING 'VIQMEL-QMGRP'
**                                    'QM'.
**      PERFORM BDC_FIELD       USING 'VIQMEL-QMCOD'
**                                    '4'.
**      PERFORM BDC_FIELD       USING 'RIWO00-HEADKTXT'
**                                    'Stability Study'.
*        PERFORM BDC_DYNPRO      USING 'SAPLIQS0' '7200'.
*        PERFORM BDC_FIELD       USING 'BDC_OKCODE'
*                                      '=AX03'.
*        PERFORM BDC_FIELD       USING 'BDC_CURSOR'
*                                      'G_CONTROL_TAB-ICONE(03)'.
**      PERFORM BDC_FIELD       USING 'VIQMEL-CHARG'
**                                    '0000001718'.
**      PERFORM BDC_FIELD       USING 'VIQMEL-LGORTCHARG'
**                                    'FG01'.
**      PERFORM BDC_FIELD       USING 'VIQMEL-QMGRP'
**                                    'QM'.
**      PERFORM BDC_FIELD       USING 'VIQMEL-QMCOD'
**                                    '4'.
**      PERFORM BDC_FIELD       USING 'RIWO00-HEADKTXT'
**                                    'Stability Study'.
*        PERFORM BDC_DYNPRO      USING 'SAPLQST01' '0300'.
*        PERFORM BDC_FIELD       USING 'BDC_CURSOR'
*                                      'QST010300-ANZLAB'.
*        PERFORM BDC_FIELD       USING 'BDC_OKCODE'
*                                      '=FREIAEND'.
*        PERFORM BDC_FIELD       USING 'QST010300-PRIMPACK'
*                                      WAA_DATA-PRIMPACK."'BOTTLE'.
*        PERFORM BDC_FIELD       USING 'QST010300-GBTYP'
*                                      WAA_DATA-GBTYP.       "'020000'.
*        PERFORM BDC_FIELD       USING 'QST010300-MENGE'
*                                      WAA_DATA-MENGE."'100'.
*        PERFORM BDC_FIELD       USING 'QST010300-MEINH'
*                                      WAA_DATA-MEINH."'EA'.
*        PERFORM BDC_FIELD       USING 'QST010300-EINGDT'
*                                      '13.11.2025'.
*        PERFORM BDC_FIELD       USING 'QST010300-KTEXT'
*                                      'ok'.
*        PERFORM BDC_FIELD       USING 'QST010300-ANZLAB'
*                                      '10'.
*        PERFORM BDC_DYNPRO      USING 'SAPLQPRS' '0121'.
*        PERFORM BDC_FIELD       USING 'BDC_CURSOR'
*                                      'RQPRS-PZTXT'.
*        PERFORM BDC_FIELD       USING 'BDC_OKCODE'
*                                      '=CLSE'.
*        PERFORM BDC_FIELD       USING 'RQPRS-FRGNA'
*                                      'CTPLSK'.
**      PERFORM BDC_FIELD       USING 'RQPRS-FRGDT'
**                                    '13.11.2025'.
**      PERFORM BDC_FIELD       USING 'RQPRS-FRGZT'
**                                    '12:17:12'.
*        PERFORM BDC_FIELD       USING 'RQPRS-PZTXT'
*                                      'OK'.
**      PERFORM BDC_TRANSACTION USING 'QM02'.
*        CALL TRANSACTION 'QM02' USING LT_BDCDATA MODE P_MODE UPDATE 'S' MESSAGES INTO LT_MSG.


*      Sample COnfirmation

*  ENDLOOP.


*-----------------------------------------------------
* Helper form to add BDC lines
*-----------------------------------------------------
FORM BDC_FIELD USING FIELD VALUE.
  CLEAR LS_BDCDATA.
*  LS_BDCDATA-PROGRAM  = PROGRAM.
*  LS_BDCDATA-DYNPRO   = DYNPRO.
*  LS_BDCDATA-DYNBEGIN = ' '.
  LS_BDCDATA-FNAM     = FIELD.
  LS_BDCDATA-FVAL     = VALUE.
  CONDENSE LS_BDCDATA-FVAL .
  APPEND LS_BDCDATA TO LT_BDCDATA.
ENDFORM.
FORM BDC_DYNPRO USING PROGRAM SCREEN.
  CLEAR LS_BDCDATA.
  LS_BDCDATA-PROGRAM = PROGRAM.
  LS_BDCDATA-DYNPRO  = SCREEN.
  LS_BDCDATA-DYNBEGIN = 'X'.
  APPEND LS_BDCDATA TO LT_BDCDATA.
ENDFORM.
*
*
**---------------------------------------------------------------
**3
*  CALL FUNCTION 'QST01_FA_RELEASE_INIT_SAMPLE'
** EXPORTING
**   I_WQMSM          =
**   I_VIQMEL         =
** IMPORTING
**   E_SUBRC          =
** TABLES
**   E_PROTOCOL       =
*    .
*
**---------------------------------------------------------------
**4
*  CALL FUNCTION 'QST01_FA_INSPLOT_INIT_SAMPLE'
** EXPORTING
**   I_WQMSM          =
**   I_VIQMEL         =
** IMPORTING
**   E_SUBRC          =
** TABLES
**   E_PROTOCOL       =
*    .
*
**---------------------------------------------------------------
**5
*  CALL FUNCTION 'QST01_FT_RELEASE_INIT_SAMPLE'
*    EXPORTING
*      I_VIQMEL      =
*      I_CUSTOMIZING =
*      I_MANUM       =
**     I_FBCALL      =
** IMPORTING
**     E_QNQMASM0    =
**     E_QNQMAQMEL0  =
**     E_BUCH        =
*    TABLES
*      TI_IVIQMFE    =
*      TI_IVIQMUR    =
*      TI_IVIQMSM    =
*      TI_IVIQMMA    =
*      TI_IHPA       =
**     TE_CONTAINER  =
**     TE_LINES      =
** EXCEPTIONS
**     ACTION_STOPPED       = 1
**     OTHERS        = 2
*    .
*  IF SY-SUBRC <> 0.
** Implement suitable error handling here
*  ENDIF.

*---------------------------------------------------------------
*---------------------------------------------------------------
*---------------------------------------------------------------
*---------------------------------------------------------------
