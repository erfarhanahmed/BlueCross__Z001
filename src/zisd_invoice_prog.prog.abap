*&---------------------------------------------------------------------*
*& Report ZISD_INVOICE_PROG
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZISD_INVOICE_PROG.

TABLES : J_1IG_ISD_DISTR.

DATA : SSF_FUNCNAME TYPE RS38L_FNAM.

*
*TYPES :BEGIN OF TY_J_1IG_ISD_DISTR,
*       REC_BELNR TYPE J_1IG_ISD_DISTR-REC_BELNR,
*       BUDAT TYPE J_1IG_ISD_DISTR-BUDAT,
*       REC_BUPLA  TYPE J_1IG_ISD_DISTR-REC_BUPLA,
*       BELNR TYPE J_1IG_ISD_DISTR-belnr,
*       REC_UGST  TYPE J_1IG_ISD_DISTR-REC_UGST,
*       REC_IGST TYPE J_1IG_ISD_DISTR-REC_IGST,
*       REC_CGST TYPE J_1IG_ISD_DISTR-rec_cgst,
*       REC_SGST TYPE J_1IG_ISD_DISTR-rec_sgst,
*  END OF TY_J_1IG_ISD_DISTR.
*
**DATA : IT_ISD TYPE TABLE OF TY_J_1IG_ISD_DISTR.
DATA : IT_ISD like J_1IG_ISD_DISTR OCCURS 0 WITH HEADER LINE.
DATA : WA_ISD TYPE J_1IG_ISD_DISTR.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.

SELECT-OPTIONS: S_BELNR FOR J_1IG_ISD_DISTR-REC_BELNR  OBLIGATORY NO-EXTENSION NO INTERVALS.

SELECTION-SCREEN END OF BLOCK B1.

START-OF-SELECTION.

SELECT * FROM J_1IG_ISD_DISTR
INTO TABLE IT_ISD
WHERE REC_BELNR IN S_BELNR.


CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
  EXPORTING
    formname                 = 'ZISD_INVOICE'
*   VARIANT                  = ' '
*   DIRECT_CALL              = ' '
 IMPORTING
   FM_NAME                  = SSF_FUNCNAME
 EXCEPTIONS
   NO_FORM                  = 1
   NO_FUNCTION_MODULE       = 2
   OTHERS                   = 3
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.
CALL FUNCTION '/1BCDWB/SF00000111'
* EXPORTING
*   ARCHIVE_INDEX              =
*   ARCHIVE_INDEX_TAB          =
*   ARCHIVE_PARAMETERS         =
*   CONTROL_PARAMETERS         =
*   MAIL_APPL_OBJ              =
*   MAIL_RECIPIENT             =
*   MAIL_SENDER                =
*   OUTPUT_OPTIONS             =
*   USER_SETTINGS              = 'X'
* IMPORTING
*   DOCUMENT_OUTPUT_INFO       =
*   JOB_OUTPUT_INFO            =
*   JOB_OUTPUT_OPTIONS         =
  TABLES
    it_isd                     = it_isd
 EXCEPTIONS
   FORMATTING_ERROR           = 1
   INTERNAL_ERROR             = 2
   SEND_ERROR                 = 3
   USER_CANCELED              = 4
   OTHERS                     = 5
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.
