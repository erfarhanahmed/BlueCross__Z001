FUNCTION Z_SRV_CREATE_DOC_IN_DMS.
*"----------------------------------------------------------------------
*"*"Update Function Module:
*"
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(GV_FILE) TYPE  IBIPPARMS-PATH OPTIONAL
*"     VALUE(VBELN) TYPE  CHAR20 OPTIONAL
*"     VALUE(POSNR) TYPE  POSNR OPTIONAL
*"     VALUE(IS_OBJECT) TYPE  SIBFLPORB OPTIONAL
*"     VALUE(DOC_TYPE) TYPE  DOKAR OPTIONAL
*"     VALUE(LV_TCODE) TYPE  STRING OPTIONAL
*"----------------------------------------------------------------------
  TYPES: BEGIN OF TS_RAW_LINE,
           LINE(2550) TYPE X,
         END OF TS_RAW_LINE.
  DATA: GS_DRAW           TYPE          DRAW,
        GS_API_CTRL       TYPE          CVAPI_API_CONTROL,
        GS_MESSAGE        TYPE          MESSAGES,
        GV_DOCUMENTNUMBER TYPE          DRAW-DOKNR,
        GT_DRAT           TYPE TABLE OF DMS_DB_DRAT,
        WA_DRAT           TYPE          DMS_DB_DRAT,
        GT_BINDATA        TYPE TABLE OF TS_RAW_LINE,
        GS_BINDATA        TYPE          TS_RAW_LINE,
        GS_DRAO           TYPE          DRAO,
        GT_DRAO           TYPE TABLE OF DRAO,
        GS_FILES          TYPE          CVAPI_DOC_FILE,
        GT_FILES          TYPE          CVAPI_TBL_DOC_FILES,
        GV_APPTYP(3)      TYPE          C,
        GV_ORG_TYP(3)     TYPE          C,
        GV_REDOCPATH(255) TYPE          C,
        GV_REFNAME(255)   TYPE          C,
        GV_ORG_FILE(255)  TYPE          C,
        GV_DOCPATH(255)   TYPE          C.

  DATA: IT_ZDMS_GOS TYPE TABLE OF ZDMS_GOS,
        WA_ZDMS_GOS TYPE ZDMS_GOS.

  DATA: GV_FILE1     TYPE STRING,
        GV_PATH      TYPE PIN_PE_LDESCRIP,
        GT_DATA      TYPE TABLE OF X255,
        GV_CONTENT   TYPE XSTRING,
        GV_LENGTH    TYPE I,
        GV_DOC_NO    TYPE DOKNR,
        GV_FILE_NAME TYPE ZFILE_NAME,
        GV_FILE_TYPE TYPE CHAR03,
        GV_ZIP_NAME  TYPE STRING.
  "******************************************************
  DATA:
        GS_RETURN TYPE BAPIRETURN1.

  CONSTANTS: GC_DOC_VER   TYPE DOKVR VALUE '00',
             GC_DOC_PART  TYPE DOKTL VALUE '000',
             GC_BIN       TYPE CHAR10 VALUE 'BIN',
             GC_APPNR     TYPE APPNR VALUE '1',
             GC_XFELD     TYPE XFELD VALUE 'I',
             GC_ACT_VER   TYPE CV_FILE_ACT_VERSION VALUE 'X',
             GC_CHECK_IN  TYPE XFELD VALUE 'X',
             GC_MSG_TYP   TYPE BAPI_MTYPE VALUE 'E',
             GC_INS_OPER  TYPE PSPAR-ACTIO VALUE 'INS',
             GC_TCLASS    TYPE PSPAR-TCLAS VALUE 'A',
             GC_FTP_DEST  TYPE RFCDES-RFCDEST VALUE 'SAPFTPA',
             GC_HTTP_DEST TYPE RFCDES-RFCDEST VALUE 'SAPHTTPA',
             GC_CONT_PR   TYPE MCDOK-CONTENT_PROVIDE VALUE 'TBL',
             GC_SYMSGTY   TYPE SYMSGTY VALUE 'E'.
*--------------------------------------------------------------------*

  DATA LV_DOC_TYPE TYPE DOKAR.
  DATA: LV_RET_CODE,
        LT_FTAB     TYPE TABLE OF SVAL,
        LS_FTAB     TYPE SVAL.
  CLEAR : LS_FTAB , LT_FTAB[].
  LS_FTAB-TABNAME = 'TDWAT'.
  LS_FTAB-FIELDNAME  = 'DOKAR'.

*  CASE SY-TCODE.
  CASE LV_TCODE. "ANBU
    WHEN 'CS01' OR 'CS02' OR 'CS03'.
      LS_FTAB-VALUE = 'ZCS'.
    WHEN 'ZQMS'.
      LS_FTAB-VALUE = 'ZCC'.
*{   INSERT         DS4K900241                                        1
 WHEN 'ZQMS_NEW'.
      LS_FTAB-VALUE = 'ZCC'.
*}   INSERT
    WHEN 'FB01' OR 'FB02' OR 'FB03' OR 'FB60' OR 'MIRO' OR 'MIR4'.
      LS_FTAB-VALUE = 'ZFI'.
    WHEN 'QP01' OR 'QP02' OR 'QP03'.
      LS_FTAB-VALUE = 'ZQM'.
    WHEN 'PA30' OR 'PA40'.
      LS_FTAB-VALUE = 'ZHR'.
    WHEN 'CO01' OR 'CO02' OR 'CO03'.
      LS_FTAB-VALUE = 'ZPP'.
    WHEN 'MSC1N' OR 'MSC2N' OR 'MSC3N'.
      LS_FTAB-VALUE = 'ZMM'.
*    WHEN 'ZEMPDATA'.
*      ls_ftab-value = 'ZRA'.
*    WHEN 'ZDMS_SOP'. "25.3.21
*      ls_ftab-value = 'ZRA'.
*     WHEN 'ZSOPUPD'. "25.3.21
*      ls_ftab-value = 'ZRA'.
    WHEN 'ZMFG1'. "22.7.21
      LS_FTAB-VALUE = 'ZRA'.
    WHEN 'ZMFG3'. "22.7.21
      LS_FTAB-VALUE = 'ZRA'.
*    WHEN 'ZaSOPUPD'.
*      ls_ftab-value = 'ZRA'.
    WHEN 'ZADSUPD'.  "22.3.21.*
      LS_FTAB-VALUE = 'ZRA'.
    WHEN 'ZLLM_INV'.  "3.8.21.*
      LS_FTAB-VALUE = 'ZRA'.
    WHEN 'ZHW_REPORT'.  " 16.9.21
      LS_FTAB-VALUE = 'ZIT'.

    WHEN 'ZTPBATCH'.  " 31.12.23
      LS_FTAB-VALUE = 'ZRA'.

    WHEN 'ZTPBATCH_R'.  " 31.12.23
      LS_FTAB-VALUE = 'ZRA'.
    WHEN 'ZTP'.  " 15.4.24
      LS_FTAB-VALUE = 'ZRA'.

*    WHEN 'ZDMS_SOP'.  "15.2.22
*      ls_ftab-value = 'ZRA'.
*    WHEN 'ZSOPUPD'.  "15.2.22
*      ls_ftab-value = 'ZRA'.
*    WHEN 'ZDMS_SOP_1'.  "12.4.22
*      ls_ftab-value = 'ZRA'.
*    WHEN 'ZDMS_SOP_2'.  "12.4.22
*      ls_ftab-value = 'ZRA'.
*    WHEN 'ZDMS_SOP_C'.  "12.4.22
*      ls_ftab-value = 'ZRA'.
*    WHEN 'ZDMS_SOP_4'.  "12.4.22
*      ls_ftab-value = 'ZRA'.
*    WHEN 'ZDMS_SOP_5'.  "12.4.22
*      ls_ftab-value = 'ZRA'.
*    WHEN 'ZDMS_SOP_6'.  "12.4.22
*      ls_ftab-value = 'ZRA'.
*    WHEN 'ZDMS_SOP_7'.  "12.4.22
*      ls_ftab-value = 'ZRA'.
*    WHEN 'ZDMS_SOP_8'.  "12.4.22
*      ls_ftab-value = 'ZRA'.
*    WHEN 'ZDMS_SOP_12'.  "12.4.22
*      ls_ftab-value = 'ZRA'.
*    WHEN 'ZDMS_SOP_13'.  "12.4.22
*      ls_ftab-value = 'ZRA'.
*    WHEN 'ZDMS_SOP_14'.  "12.4.22
*      ls_ftab-value = 'ZRA'.
    WHEN 'ZDEV1'.  "19.9.22  "ADDED FOR DEVIATION ON 12.12.22
      LS_FTAB-VALUE = 'ZCC'.
    WHEN 'ZDEV2'.  "19.9.22
      LS_FTAB-VALUE = 'ZCC'.
    WHEN 'ZDEV3'.  "19.9.22
      LS_FTAB-VALUE = 'ZCC'.
    WHEN 'ZDEV6'.  "19.9.22
      LS_FTAB-VALUE = 'ZCC'.
*    WHEN 'ZDEV8'.  "19.9.22
*      ls_ftab-value = 'ZCC'.
    WHEN 'ZDEV4'.  "19.9.22
      LS_FTAB-VALUE = 'ZCC'.
    WHEN 'ZDEV5'.  "19.9.22
      LS_FTAB-VALUE = 'ZCC'.
*    WHEN 'ZDEV7'.  "19.9.22
*      ls_ftab-value = 'ZCC'.
    WHEN 'ZDEV9'.  "19.9.22
      LS_FTAB-VALUE = 'ZCC'.
    WHEN 'ZDEV_PR'.  "19.9.22
      LS_FTAB-VALUE = 'ZCC'.

    WHEN 'ZOOS1'.  " 17.11.24
      LS_FTAB-VALUE = 'ZRA'.
    WHEN 'ZOOS2'.  " 17.11.24
      LS_FTAB-VALUE = 'ZRA'.
    WHEN 'ZOOS3'.  " 17.11.24
      LS_FTAB-VALUE = 'ZRA'.
    WHEN 'ZOOS_P2A'.  " 17.11.24
      LS_FTAB-VALUE = 'ZRA'.
    WHEN 'ZOOS_P2B'.  " 17.11.24
      LS_FTAB-VALUE = 'ZRA'.
    WHEN 'ZOOS_P2C'.  " 17.11.24
      LS_FTAB-VALUE = 'ZRA'.
    WHEN 'ZOOS_P3'.  " 17.11.24
      LS_FTAB-VALUE = 'ZRA'.
        WHEN 'ZOOS_P1'.  " 19.8.25
      LS_FTAB-VALUE = 'ZRA'.
    WHEN 'ZOOS_F1'.  " 17.11.24
      LS_FTAB-VALUE = 'ZRA'.
    WHEN 'ZOOS_P4'.  " 17.11.24
      LS_FTAB-VALUE = 'ZRA'.
    WHEN 'ZREJECT1'.  " 14.4.25
      LS_FTAB-VALUE = 'ZRA'.
    WHEN 'ZREJECT3'.  " 14.4.25
      LS_FTAB-VALUE = 'ZRA'.
  ENDCASE.

  APPEND LS_FTAB TO LT_FTAB.

*-------------> Commented by Karthik on 01.10.2019

*
*  CALL FUNCTION 'POPUP_GET_VALUES'
*    EXPORTING
**     NO_VALUE_CHECK        = ' '
*      POPUP_TITLE  = 'Select Document type'
*      START_COLUMN = '5'
*      START_ROW    = '5'
*    IMPORTING
*      RETURNCODE   = LV_RET_CODE
*    TABLES
*      FIELDS       = LT_FTAB
**     EXCEPTIONS
**     ERROR_IN_FIELDS       = 1
**     OTHERS       = 2
*    .
*  IF SY-SUBRC <> 0.
** Implement suitable error handling here
*  ENDIF.

*--------------> End of Comments

*  IF LV_RET_CODE NE 'A'.
  READ TABLE LT_FTAB INTO LS_FTAB INDEX 1.
  IF SY-SUBRC EQ 0.
    LV_DOC_TYPE = LS_FTAB-VALUE.
    DATA: LT_FILE_NAMES TYPE FILETABLE,
          LWA_FILE_NAME TYPE FILE_TABLE,
          LV_SUBRC      TYPE I.
    REFRESH : LT_FILE_NAMES.
    CALL METHOD CL_GUI_FRONTEND_SERVICES=>FILE_OPEN_DIALOG
      EXPORTING
        WINDOW_TITLE            = 'Multiple Selection'
*       DEFAULT_EXTENSION       =
*       DEFAULT_FILENAME        =
        FILE_FILTER             = '|'
        INITIAL_DIRECTORY       = 'C:Temp'
        MULTISELECTION          = 'X'
      CHANGING
        FILE_TABLE              = LT_FILE_NAMES[]
        RC                      = LV_SUBRC
*       USER_ACTION             =
      EXCEPTIONS
        FILE_OPEN_DIALOG_FAILED = 1
        CNTL_ERROR              = 2
        ERROR_NO_GUI            = 3
        OTHERS                  = 4.
    IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

    CHECK LT_FILE_NAMES[] IS NOT INITIAL.
    TYPES : BEGIN OF TY_STRING,
              DOC_TYPE TYPE DOKAR,
              FILE     TYPE STRING,
              STRING   TYPE XSTRING,
            END OF TY_STRING.
    DATA : LT_STRING TYPE TABLE OF TY_STRING,
           LS_STRING TYPE TY_STRING.
    CLEAR : LS_STRING,LT_STRING[].

    LOOP AT LT_FILE_NAMES INTO LWA_FILE_NAME.
      CLEAR : GV_LENGTH , GV_FILE1 ,GT_DATA[].
      GV_FILE = LWA_FILE_NAME.
      GV_FILE1 = GV_FILE.
      "***** File Upload From Presentation
      CALL FUNCTION 'GUI_UPLOAD'
        EXPORTING
          FILENAME                = GV_FILE1
          FILETYPE                = GC_BIN "'BIN'
        IMPORTING
          FILELENGTH              = GV_LENGTH
        TABLES
          DATA_TAB                = GT_DATA
        EXCEPTIONS
          FILE_OPEN_ERROR         = 1
          FILE_READ_ERROR         = 2
          NO_BATCH                = 3
          GUI_REFUSE_FILETRANSFER = 4
          INVALID_TYPE            = 5
          NO_AUTHORITY            = 6
          UNKNOWN_ERROR           = 7
          BAD_DATA_FORMAT         = 8
          HEADER_NOT_ALLOWED      = 9
          SEPARATOR_NOT_ALLOWED   = 10
          HEADER_TOO_LONG         = 11
          UNKNOWN_DP_ERROR        = 12
          ACCESS_DENIED           = 13
          DP_OUT_OF_MEMORY        = 14
          DISK_FULL               = 15
          DP_TIMEOUT              = 16
          OTHERS                  = 17.

      IF SY-SUBRC = 0.

********code added by anbu starts for size check
******if sy-uname = 'AMS_JAYA'.
******https://www.gbmb.org/mb-to-bytes
******1 MB = 1000000 Bytes (in decimal)
******1 MB = 1048576 Bytes (in binary)
******2 MB = 2000000 Bytes (in decimal)
******2 MB = 2097152 Bytes (in binary)
******5 MB = 5242880 Bytes (in binary)
*
*          DATA : SIZE TYPE I.
*          DATA : WA_STRING TYPE STRING.
*          TABLES : ZDMS_FILESIZE.
*
*          CLEAR : ZDMS_FILESIZE,SIZE,WA_STRING.
*          SELECT SINGLE * FROM ZDMS_FILESIZE.
*          IF SY-SUBRC = 0.
*            IF ZDMS_FILESIZE-FILESIZE NE ' '.
*              SIZE = 1048576 * ZDMS_FILESIZE-FILESIZE.
******    convert filesize into, binary.
*
*              IF GV_LENGTH GT SIZE.
******     CONCATENATE 'File size exceeds the Limit of Size maintained in ZDMS_FILESIZE table'
*                CONCATENATE 'File size exceeds the Limit'
*                ZDMS_FILESIZE-FILESIZE 'MB' INTO WA_STRING SEPARATED BY SPACE.
*                MESSAGE WA_STRING TYPE 'I'.
*                RETURN.
*              ENDIF.
*            ELSE.
*              MESSAGE 'please maintain filesize in table ZDMS_FILESIZE' TYPE 'I'.
*              RETURN.
*            ENDIF.
*          ELSE.
*            MESSAGE 'please maintain filesize in table ZDMS_FILESIZE' TYPE 'I'.
*            RETURN.
*          ENDIF.
******endif.
********code added by anbu ends for size check

        "**** Converting Binary to Xstring
        CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
          EXPORTING
            INPUT_LENGTH = GV_LENGTH
          IMPORTING
            BUFFER       = GV_CONTENT
          TABLES
            BINARY_TAB   = GT_DATA
          EXCEPTIONS
            FAILED       = 1
            OTHERS       = 2.

        LS_STRING-DOC_TYPE = LV_DOC_TYPE.
        LS_STRING-FILE = GV_FILE1.
        LS_STRING-STRING =  GV_CONTENT.
        APPEND LS_STRING TO LT_STRING.
        CLEAR : GV_CONTENT , LS_STRING.
      ENDIF.
    ENDLOOP.

*-- Create Attachement and link it to order
    DATA:IV_ROLTYPE	 TYPE OBLROLTYPE,
         LS_OBJECT_A TYPE SIBFLPORB,
         LS_OBJECT_B TYPE SIBFLPORB,
         IS_ATTCONT	 TYPE GOS_S_ATTCONT,
         LV_RELTYPE  TYPE OBLRELTYPE.
    DATA : LS_ZDMS_GOS TYPE ZDMS_GOS.

    "OSCON_DMODE_UPDATE_TASK  - > in update task.
    LOOP AT LT_STRING INTO LS_STRING.
      CLEAR : GV_DOC_NO,GV_FILE_NAME,GV_FILE_TYPE, LS_ZDMS_GOS.
      "**** File Uploading into DMS
      CALL FUNCTION 'Z_SRV_DMS_UPLOAD'
        EXPORTING
          FILE_NAME              = LS_STRING-FILE
          FILE_CONTENT           = LS_STRING-STRING
          DOC_TYPE               = LV_DOC_TYPE
          VBELN                  = VBELN
          POSNR                  = POSNR
        IMPORTING
          E_DOC_NUMBER           = GV_DOC_NO
          E_FILE_NAME            = GV_FILE_NAME
          E_FILE_TYPE            = GV_FILE_TYPE
        EXCEPTIONS
          DOCUMENT_NO_NOT_CREATE = 1
          DOCUMENT_NOT_UPLOADED  = 2
          OTHERS                 = 3.

      IF  GV_DOC_NO IS NOT INITIAL.

**code added by anbu starts 4.01.2019
        DATA : LS_TCODE1  TYPE ZDMS_GOS_TCODE.
        CLEAR :  LS_TCODE1.
        SELECT SINGLE * FROM ZDMS_GOS_TCODE INTO LS_TCODE1 WHERE TCODE = LV_TCODE.
        IF SY-SUBRC EQ 0.
          LS_ZDMS_GOS-KEYVALUE = LS_TCODE1-KEYVALUE.
        ENDIF.
**code added by anbu ends on 4.01.2019
        LS_ZDMS_GOS-DOC_KEY     = VBELN.
        LS_ZDMS_GOS-DOKNR       = GV_DOC_NO.
        LS_ZDMS_GOS-FILENAME    = GV_FILE_NAME.
        LS_ZDMS_GOS-ZFILE_NAME  = GV_FILE_TYPE.
        LS_ZDMS_GOS-ZUSERID     = SY-UNAME.
        LS_ZDMS_GOS-ZDATE  = SY-DATUM.
        LS_ZDMS_GOS-ZTIME  = SY-UZEIT.

*        IF sy-tcode = 'ZQMS'.
        IF SY-TCODE = 'ZQMS'
*          OR sy-tcode EQ 'ZADSUPD' OR   sy-tcode EQ 'ZMFG1' OR sy-tcode EQ 'ZMFG3'  "22.3.21
*          OR sy-tcode EQ 'ZDMS_SOP_1'  OR sy-tcode EQ 'ZDMS_SOP_C' OR sy-tcode EQ 'ZDMS_SOP_4'  " 12.4.22
*          OR sy-tcode EQ 'ZDMS_SOP_5' OR sy-tcode EQ 'ZDMS_SOP_6' OR sy-tcode EQ 'ZDMS_SOP_7'
*          OR sy-tcode EQ 'ZDMS_SOP_8'  OR sy-tcode EQ 'ZDMS_SOP_2'
           OR SY-TCODE EQ 'ZDEV1'
          OR SY-TCODE EQ 'ZDEV2' OR SY-TCODE EQ 'ZDEV3' OR SY-TCODE EQ 'ZDEV6'
*           OR sy-tcode EQ 'ZDEV8'
          OR SY-TCODE EQ 'ZDEV4' OR SY-TCODE EQ 'ZDEV5'
*          OR sy-tcode EQ 'ZDEV7'
          OR SY-TCODE EQ 'ZDEV9'  "ADDED ON  21.9.22
           OR SY-TCODE EQ 'ZOOS1'  OR SY-TCODE EQ 'ZOOS2' OR SY-TCODE EQ 'ZOOS3' "ADDED ON  18.11.24
 OR SY-TCODE EQ 'ZOOS_P2A' OR SY-TCODE EQ 'ZOOS_P2B'  OR SY-TCODE EQ 'ZOOS_P2C' OR SY-TCODE EQ 'ZOOS_P3'
          OR SY-TCODE EQ 'ZREJECT1' OR SY-TCODE EQ 'ZREJECT3'.

          DATA: LV_ENAME1  TYPE ZEMNAM,
                LV_BTEXT1  TYPE ZBTEXT,
                LV_STAGE1  TYPE ZSTAGE,
                LV_PERSNO1 TYPE PERSNO,
                ZVER       TYPE BUZEI.

          IMPORT: LV_ENAME TO LV_ENAME1 FROM MEMORY ID 'ZENAME',
                  LV_BTEXT TO LV_BTEXT1 FROM MEMORY ID 'ZBTEXT',
                  LV_STAGE TO LV_STAGE1 FROM MEMORY ID 'ZSTAGE',
                  LV_PERSNO TO LV_PERSNO1 FROM MEMORY ID 'ZPERSNO'.
*                  zver TO zver1 FROM MEMORY ID 'ZVER'.
*          BREAK-POINT.
          LS_ZDMS_GOS-ENAME = LV_ENAME1.
          LS_ZDMS_GOS-BTEXT = LV_BTEXT1.
          LS_ZDMS_GOS-STAGE = LV_STAGE1.
          LS_ZDMS_GOS-PERNR = LV_PERSNO1.
*          ls_zdms_gos-version = zver1.

*          IF sy-tcode EQ 'ZDMS_SOP'.
*            SELECT * FROM zdms_gos INTO TABLE it_zdms_gos WHERE doc_key EQ vbeln.
*            SORT it_zdms_gos DESCENDING BY version.
*
*            READ TABLE it_zdms_gos INTO wa_zdms_gos WITH KEY doc_key = vbeln.
*            IF sy-subrc EQ 0.
*              zver = wa_zdms_gos-version + 1.
*            ELSE.
*              zver = 1 / 10.
*            ENDIF.
*            ls_zdms_gos-version = zver.
*          ENDIF.

        ENDIF.


********** jYOTSNA - ENHANCEMENT FOR TCDE ZEMPDATA 13.2.2020 ******************
*        IF sy-tcode = 'ZEMPDATA'.
*          DATA: lifnr1  TYPE lifnr.
*          IMPORT: lifnr TO lifnr1 FROM MEMORY ID 'ZLIFNR'.
*          ls_zdms_gos-lifnr = lifnr1.
*        ENDIF.

*        IF sy-tcode = 'ZDMS_SOP'.
*
*          DATA: lv_ename2  TYPE zemnam,
*                lv_btext2  TYPE zbtext,
*                lv_stage2  TYPE zstage,
*                lv_persno2 TYPE persno.
*
*          IMPORT: lv_ename TO lv_ename2 FROM MEMORY ID 'ZENAME',
*                  lv_btext TO lv_btext2 FROM MEMORY ID 'ZBTEXT',
*                  lv_stage TO lv_stage2 FROM MEMORY ID 'ZSTAGE',
*                  lv_persno TO lv_persno2 FROM MEMORY ID 'ZPERSNO'.
*
*          ls_zdms_gos-ename = lv_ename2.
*          ls_zdms_gos-btext = lv_btext2.
*          ls_zdms_gos-stage = lv_stage2.
*          ls_zdms_gos-pernr = lv_persno2.
*
*          BREAK-POINT  .
*          DATA: sop1(20) TYPE c.
*          IMPORT: sop TO sop1 FROM MEMORY ID 'ZSOP'.
*
*          ls_zdms_gos-doc_key = sop1.
*        ENDIF.
******** JYOTSNA -- ENDS HERE*********************


        MODIFY ZDMS_GOS FROM LS_ZDMS_GOS .
        COMMIT WORK AND WAIT.
        IS_ATTCONT-ATTA_CAT = CL_GOS_API=>C_MSG.
        IV_ROLTYPE = CL_GOS_API=>C_ATTACHMENT.
        LV_RELTYPE = CL_GOS_API=>C_ATTA.
      ENDIF.
    ENDLOOP.
  ENDIF.
*  ENDIF.
ENDFUNCTION.
