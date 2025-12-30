FUNCTION Z_SRV_DMS_UPLOAD.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(FILE_NAME) TYPE  STRING
*"     REFERENCE(FILE_CONTENT) TYPE  XSTRING
*"     REFERENCE(DOC_TYPE) TYPE  DOKAR DEFAULT 'ZCS'
*"     REFERENCE(DOC_VERSION) TYPE  DOKVR DEFAULT '00'
*"     REFERENCE(DOC_PART) TYPE  DOKTL_D DEFAULT '000'
*"     REFERENCE(STORAGE_CAT) TYPE  CV_STORAGE_CAT DEFAULT 'ZDMS_BC '
*"     REFERENCE(VBELN) TYPE  CHAR20
*"     REFERENCE(POSNR) TYPE  POSNR
*"  EXPORTING
*"     REFERENCE(E_DOC_NUMBER) TYPE  DOKNR
*"     REFERENCE(E_FILE_NAME) TYPE  ZFILE_NAME
*"     REFERENCE(E_FILE_TYPE) TYPE  CHAR03
*"  EXCEPTIONS
*"      DOCUMENT_NO_NOT_CREATE
*"      DOCUMENT_NOT_UPLOADED
*"----------------------------------------------------------------------

*--------------------------------------------------------------------*
*To Upload the documents to DMS
*--------------------------------------------------------------------*

  TYPES: BEGIN OF TS_RAW_LINE,
           LINE(2550) TYPE X,
         END OF TS_RAW_LINE.

  DATA LV_APPTYP(5)       TYPE          C.
  DATA LV_FNAME(255)      TYPE          C.
  DATA LV_FLINK           TYPE          PIN_PE_LDESCRIP.
  DATA LV_REDOCPATH(255)  TYPE          C.
  DATA LV_REFNAME(255)    TYPE          C.
  DATA LV_DOCPATH(255)    TYPE          C.
  DATA LS_DRAW            TYPE          DRAW.
  DATA LS_API_CTRL        TYPE          CVAPI_API_CONTROL.
  DATA IT_DRAT            TYPE TABLE OF DMS_DB_DRAT.
  DATA WA_DRAT            TYPE          DMS_DB_DRAT.
  DATA LS_MESSAGE         TYPE          MESSAGES.
  DATA LV_DOCUMENTNUMBER  TYPE          DRAW-DOKNR.
  DATA LV_SIZE            TYPE          I.
  DATA LT_BINDATA         TYPE TABLE OF TS_RAW_LINE.
  DATA LS_BINDATA         TYPE          TS_RAW_LINE.
  DATA LS_DRAO            TYPE          DRAO.
  DATA LT_DRAO            TYPE TABLE OF DRAO.
  DATA LS_FILES           TYPE          CVAPI_DOC_FILE.
  DATA LT_FILES           TYPE          CVAPI_TBL_DOC_FILES.


  LV_FLINK = FILE_NAME.
  "Start by prachi/priya
  TRANSLATE LV_FLINK TO UPPER CASE.

  DATA: LV_TEMP(255)            TYPE C,
        LV_TEMPNAME(255)        TYPE C,
        LV_EXTENSION(255)       TYPE C,
        LV_EXTENSION_FINAL(255) TYPE C,
        LV_TEMPNAME_FINAL(255)  TYPE C.

  CALL FUNCTION 'STRING_REVERSE'
    EXPORTING
      STRING  = LV_FLINK
      LANG    = SY-LANGU
    IMPORTING
      RSTRING = LV_REDOCPATH.

  SPLIT LV_REDOCPATH AT '\' INTO LV_REFNAME LV_REDOCPATH.

  SPLIT LV_REFNAME AT '.' INTO LV_EXTENSION LV_REFNAME.

  CALL FUNCTION 'STRING_REVERSE'
    EXPORTING
      STRING  = LV_EXTENSION
      LANG    = SY-LANGU
    IMPORTING
      RSTRING = LV_APPTYP.

  REPLACE ALL OCCURRENCES OF '.' IN LV_REFNAME WITH ' '.
  CONDENSE LV_REFNAME.

  CALL FUNCTION 'STRING_REVERSE'
    EXPORTING
      STRING  = LV_REDOCPATH
      LANG    = SY-LANGU
    IMPORTING
      RSTRING = LV_DOCPATH.

  CONCATENATE LV_DOCPATH '\' INTO LV_DOCPATH.

  CALL FUNCTION 'STRING_REVERSE'
    EXPORTING
      STRING  = LV_REFNAME
      LANG    = SY-LANGU
    IMPORTING
      RSTRING = LV_TEMPNAME_FINAL.

  CONCATENATE LV_APPTYP '.' LV_TEMPNAME_FINAL INTO LV_REFNAME.
  CONCATENATE LV_TEMPNAME_FINAL '.' LV_APPTYP INTO LV_FNAME.

*  End by prachi/priya

**---Split file name to get extension and file name
*  CALL FUNCTION 'SPLIT_FILENAME'
*    EXPORTING
*      long_filename  = lv_flink
*    IMPORTING
**     pure_filename  = lv_fname
*      pure_extension = lv_apptyp.
*
*  TRANSLATE lv_apptyp TO UPPER CASE.
*
**---Get file name in reverse order
*  CALL FUNCTION 'STRING_REVERSE'
*    EXPORTING
*      string  = lv_flink
*      lang    = sy-langu
*    IMPORTING
*      rstring = lv_redocpath.
*
*  SPLIT lv_redocpath AT '\' INTO lv_refname lv_redocpath.
*
*  CALL FUNCTION 'STRING_REVERSE'
*    EXPORTING
*      string  = lv_redocpath
*      lang    = sy-langu
*    IMPORTING
*      rstring = lv_docpath.
*
*  CONCATENATE lv_docpath '\' INTO lv_docpath.
*
*  CALL FUNCTION 'STRING_REVERSE'
*    EXPORTING
*      string  = lv_refname
*      lang    = sy-langu
*    IMPORTING
*      rstring = lv_fname.

*---Data for file number on DMS
  LS_DRAW-DOKAR = DOC_TYPE.         "Document Type
  LS_DRAW-DWNAM = SY-UNAME.         "Uploaded By
  LS_DRAW-DOKVR = DOC_VERSION.      "Document Version
  LS_DRAW-DOKTL = DOC_PART.         "Document Part

  LS_API_CTRL-TCODE = 'CV01N'.

*  LS_API_CTRL-COMP_PATH = 'E:\usr\sap\BCD\SYS\global\'.

*--------------------------------------------------------------------*
*-- File name in format = VBELN-POSNR-File name
*   So that we can search the respective document on the basis of VBELN
*--------------------------------------------------------------------*
  IF POSNR IS INITIAL.
    CONCATENATE VBELN '-' LV_FNAME INTO LV_FNAME.
  ELSE.
    CONCATENATE VBELN '-' POSNR '-' LV_FNAME INTO LV_FNAME.
  ENDIF.
  WA_DRAT-DKTXT = LV_FNAME.
  APPEND WA_DRAT TO IT_DRAT.

*---Generate Document Number on DMS
  CALL FUNCTION 'CVAPI_DOC_CREATE'
    EXPORTING
      PS_DRAW        = LS_DRAW
      PS_API_CONTROL = LS_API_CTRL
    IMPORTING
      PSX_MESSAGE    = LS_MESSAGE
      PFX_DOKNR      = LV_DOCUMENTNUMBER
    TABLES
      PT_DRAT_X      = IT_DRAT.
  IF LS_MESSAGE-MSG_TYPE = 'E'.
    RAISE DOCUMENT_NO_NOT_CREATE.
  ELSE.
    COMMIT WORK AND WAIT.
    WAIT UP TO 2 SECONDS.
  ENDIF.

  IF LV_DOCUMENTNUMBER IS NOT INITIAL.
    LS_DRAW-DOKNR = LV_DOCUMENTNUMBER.

*---Convert the xstring file to binary
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        BUFFER        = FILE_CONTENT
      IMPORTING
        OUTPUT_LENGTH = LV_SIZE
      TABLES
        BINARY_TAB    = LT_BINDATA.

    CLEAR LS_BINDATA.
    LOOP AT LT_BINDATA INTO LS_BINDATA.
      CLEAR LS_DRAO.
      LS_DRAO-ORBLK = LS_BINDATA-LINE.
      LS_DRAO-ORLN = LV_SIZE.
      LS_DRAO-DOKAR = LS_DRAW-DOKAR.
      LS_DRAO-DOKNR = LV_DOCUMENTNUMBER.
      LS_DRAO-DOKVR = '00'.
      LS_DRAO-DOKTL = '000'.
      LS_DRAO-APPNR = '1 '.
      APPEND LS_DRAO TO LT_DRAO.
      CLEAR LS_DRAO.
    ENDLOOP.

    LS_FILES-APPNR = '1'.
    LS_FILES-DAPPL = LV_APPTYP.
    LS_FILES-ACTIVE_VERSION = 'X'.
    LS_FILES-FILENAME = LV_FNAME.
    LS_FILES-UPDATEFLAG =  'I'.
    LS_FILES-LANGU = SY-LANGU.
**********************************************************************
    "using the standard storage category as it is working
    LS_FILES-STORAGE_CAT = STORAGE_CAT .
    LS_FILES-DESCRIPTION = LV_FNAME.
    LS_FILES-CHECKED_IN = 'X'.
    LS_FILES-CREATED_BY = SY-UNAME.
    LS_FILES-CREATED_AT = SY-UZEIT.
    APPEND LS_FILES TO LT_FILES.

    CALL FUNCTION 'CVAPI_DOC_CHECKIN'
      EXPORTING
        PF_DOKAR           = LS_DRAW-DOKAR
        PF_DOKNR           = LV_DOCUMENTNUMBER
        PF_DOKVR           = LS_DRAW-DOKVR
        PF_DOKTL           = LS_DRAW-DOKTL
*       PS_DOC_STATUS      =
*       PF_FTP_DEST        = 'SAPFTP'
        PF_HTTP_DEST       = 'SAPHTTP'
        PS_API_CONTROL     = LS_API_CTRL
        PF_CONTENT_PROVIDE = 'TBL'
      IMPORTING
        PSX_MESSAGE        = LS_MESSAGE
      TABLES
        PT_FILES_X         = LT_FILES
        PT_CONTENT         = LT_DRAO.

    IF LS_MESSAGE-MSG_TYPE = 'E'.
      RAISE DOCUMENT_NO_NOT_CREATE.
    ELSE.
      E_DOC_NUMBER = LV_DOCUMENTNUMBER.
      E_FILE_NAME  = LV_FNAME.
      E_FILE_TYPE  = LV_APPTYP.
      COMMIT WORK AND WAIT.
      MESSAGE S043(SGOS_MSG).
    ENDIF.

  ENDIF.

ENDFUNCTION.
