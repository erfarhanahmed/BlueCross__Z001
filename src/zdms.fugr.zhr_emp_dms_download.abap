FUNCTION ZHR_EMP_DMS_DOWNLOAD.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_DOC_NUMBER) TYPE  DOKNR
*"     REFERENCE(I_DOC_TYPE) TYPE  DOKAR DEFAULT 'ZHR'
*"     REFERENCE(I_DOC_VERSION) TYPE  DOKVR DEFAULT '00'
*"     REFERENCE(I_DOC_PART) TYPE  DOKTL_D DEFAULT '000'
*"  EXPORTING
*"     REFERENCE(E_FILE_CONTENT) TYPE  XSTRING
*"     REFERENCE(E_ACCESS_INFO) TYPE  SDOKFILACI
*"  EXCEPTIONS
*"      FILE_NOT_FOUND
*"      FILE_PHYSICAL_LOC_ERROR
*"      FILE_CONVERSION_ERROR
*"----------------------------------------------------------------------

*--------------------------------------------------------------------*
*Download file from DMS
*--------------------------------------------------------------------*

  DATA LV_DOC_NUMBER      TYPE          DOKNR.
  DATA LS_PSX_DRAW        TYPE          DRAW.
  DATA LS_DESCRIPTION	    TYPE          DRAT-DKTXT.
  DATA LT_DOC_FILE        TYPE TABLE OF CVAPI_DOC_FILE.
  DATA LS_DOC_FILE        TYPE          CVAPI_DOC_FILE.
  DATA LS_OBJECT_ID       TYPE          SDOKOBJECT.
  DATA LT_ACCESS_INFO     TYPE TABLE OF SDOKFILACI.
  DATA LS_ACCESS_INFO     TYPE          SDOKFILACI.
  DATA LT_CONTENT_BINARY  TYPE TABLE OF SDOKCNTBIN.
  DATA LS_INPUT_LENGTH    TYPE          I.

*---Get physical location of the file

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      INPUT  = I_DOC_NUMBER
    IMPORTING
      OUTPUT = LV_DOC_NUMBER.

  CALL FUNCTION 'CVAPI_DOC_GETDETAIL'
    EXPORTING
*     PF_BATCHMODE    = 'X'
      PF_DOKAR        = I_DOC_TYPE
      PF_DOKNR        = LV_DOC_NUMBER
      PF_DOKVR        = I_DOC_VERSION
      PF_DOKTL        = I_DOC_PART
      PF_READ_KPRO    = 'X'
*     PF_ACTIVE_FILES = 'X'
    IMPORTING
      PSX_DRAW        = LS_PSX_DRAW
      PFX_DESCRIPTION = LS_DESCRIPTION
    TABLES
      PT_FILES        = LT_DOC_FILE
    EXCEPTIONS
      NOT_FOUND       = 1
      NO_AUTH         = 2
      ERROR           = 3
      OTHERS          = 4.
  IF SY-SUBRC <> 0.
    RAISE FILE_NOT_FOUND.
  ELSE.

*---Get the physical file
    READ TABLE LT_DOC_FILE INTO LS_DOC_FILE INDEX 1.

    LS_OBJECT_ID-CLASS = 'DMS_PCD1'.
    LS_OBJECT_ID-OBJID = LS_DOC_FILE-PH_OBJID.

*---Get the binary format of the file
    CALL FUNCTION 'SDOK_PHIO_LOAD_CONTENT'
      EXPORTING
        OBJECT_ID           = LS_OBJECT_ID
      TABLES
        FILE_ACCESS_INFO    = LT_ACCESS_INFO
        FILE_CONTENT_BINARY = LT_CONTENT_BINARY
      EXCEPTIONS
        NOT_EXISTING        = 1
        NOT_AUTHORIZED      = 2
        NO_CONTENT          = 3
        BAD_STORAGE_TYPE    = 4
        OTHERS              = 5.
    IF SY-SUBRC <> 0.
      RAISE FILE_PHYSICAL_LOC_ERROR.
    ELSE.
      READ TABLE LT_ACCESS_INFO INTO LS_ACCESS_INFO INDEX 1.

      E_ACCESS_INFO = LS_ACCESS_INFO.
      LS_INPUT_LENGTH = LS_ACCESS_INFO-FILE_SIZE.

      CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
        EXPORTING
          INPUT_LENGTH = LS_INPUT_LENGTH
        IMPORTING
          BUFFER       = E_FILE_CONTENT
        TABLES
          BINARY_TAB   = LT_CONTENT_BINARY
        EXCEPTIONS
          FAILED       = 1
          OTHERS       = 2.
      IF SY-SUBRC <> 0.
        RAISE FILE_CONVERSION_ERROR.
      ENDIF.
    ENDIF.
  ENDIF.


ENDFUNCTION.
