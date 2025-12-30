*&---------------------------------------------------------------------*
*& Report  ZBOM_REPORT
*& developed by Jyotsna 7.6.20
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ZBOM_REPORT9.

TABLES : MAST,
         STPO,
         STKO,
         STZU,
         MAKT,
         T001W,
         MARA,
         T005U,
         MKAL,T415T.

TYPE-POOLS:  SLIS.

DATA: G_REPID     LIKE SY-REPID,
      FIELDCAT    TYPE SLIS_T_FIELDCAT_ALV,
      WA_FIELDCAT LIKE LINE OF FIELDCAT,
      SORT        TYPE SLIS_T_SORTINFO_ALV,
      WA_SORT     LIKE LINE OF SORT,
      LAYOUT      TYPE SLIS_LAYOUT_ALV.

DATA : IT_MAST            TYPE TABLE OF MAST,
       WA_MAST            TYPE MAST,
       IT_STKO            TYPE TABLE OF STKO,
       WA_STKO            TYPE STKO,
       IT_STPO            TYPE TABLE OF STPO,
       WA_STPO            TYPE STPO,
       IT_STAS            TYPE TABLE OF STAS,
       WA_STAS            TYPE STAS,
       IT_MARA            TYPE TABLE OF MARA,
       WA_MARA            TYPE MARA,
       IT_VBRK            TYPE TABLE OF VBRK,
       WA_VBRK            TYPE VBRK,
       IT_VBRP            TYPE TABLE OF VBRP,
       WA_VBRP            TYPE VBRP,
       IT_ZQSPECIFICATION TYPE TABLE OF ZQSPECIFICATION,
       WA_ZQSPECIFICATION TYPE ZQSPECIFICATION,
       IT_MKAL            TYPE TABLE OF MKAL,
       WA_MKAL            TYPE MKAL.


TYPES : BEGIN OF ITAB1,
          MATNR TYPE MAST-MATNR,
          WERKS TYPE MAST-WERKS,
          STLNR TYPE MAST-STLNR,
          STLAN TYPE MAST-STLAN,
          BMENG TYPE STKO-BMENG,
          ZTEXT TYPE STZU-ZTEXT,
          TEXT1 TYPE STRING,
          BMEIN TYPE STKO-BMEIN,
          STLAL TYPE MAST-STLAL,
          MAKTX TYPE MAKT-MAKTX,
          STKTX TYPE STKO-STKTX,
        END OF ITAB1.

TYPES : BEGIN OF ITAB2,
          MATNR      TYPE MAST-MATNR,
          MAKTX      TYPE MAKT-MAKTX,
          WERKS      TYPE MAST-WERKS,
          STLNR      TYPE MAST-STLNR,
          STLAN      TYPE MAST-STLAN,
          STLAL      TYPE MAST-STLAL,
          BMENG      TYPE STKO-BMENG,
          ZTEXT      TYPE STZU-ZTEXT,
          TEXT1(100) TYPE C,
          POTX1      TYPE STPO-POTX1,
          IDNRK      TYPE STPO-IDNRK,
          MENGE      TYPE STPO-MENGE,
          MEINS      TYPE STPO-MEINS,
          POSNR      TYPE STPO-POSNR,
*          IMAKTX     TYPE MAKT-MAKTX,
          IMAKTX(65) TYPE C,
          NORMT      TYPE MARA-NORMT,
          SORTF      TYPE STPO-SORTF,
*          EFFECTDT   TYPE SY-DATUM,
*          VERSION    TYPE ZBOMVER-VERSION,
*          MFR(50)    TYPE C,
          ZMFR       TYPE STKO-ZMFR,

        END OF ITAB2.

TYPES : BEGIN OF ITAB3,
          MATNR      TYPE MAST-MATNR,
          MAKTX      TYPE MAKT-MAKTX,
          WERKS      TYPE MAST-WERKS,
          STLNR      TYPE MAST-STLNR,
          STLAN      TYPE MAST-STLAN,
          STLAL      TYPE MAST-STLAL,
          BMENG(20)  TYPE C,
*       TYPE STKO-BMENG,
          ZTEXT      TYPE STZU-ZTEXT,
          TEXT1(100) TYPE C,
*          IDNRK      TYPE STPO-IDNRK,
*          MENGE      TYPE STPO-MENGE,
*          MEINS      TYPE STPO-MEINS,
*          POSNR      TYPE STPO-POSNR,
*          IMAKTX     TYPE MAKT-MAKTX,
*          NORMT      TYPE MARA-NORMT,
        END OF ITAB3.

TYPES : BEGIN OF ITAB4,
          MATNR      TYPE MAST-MATNR,
          MAKTX      TYPE MAKT-MAKTX,
          WERKS      TYPE MAST-WERKS,
          STLNR      TYPE MAST-STLNR,
          STLAN      TYPE MAST-STLAN,
          STLAL      TYPE MAST-STLAL,
          BMENG(20)  TYPE C,
*       TYPE STKO-BMENG,
          ZTEXT      TYPE STZU-ZTEXT,
          TEXT1(100) TYPE C,
          BEZEI      TYPE T005U-BEZEI,
*          IDNRK      TYPE STPO-IDNRK,
*          MENGE      TYPE STPO-MENGE,
*          MEINS      TYPE STPO-MEINS,
*          POSNR      TYPE STPO-POSNR,
*          IMAKTX     TYPE MAKT-MAKTX,
*          NORMT      TYPE MARA-NORMT,
        END OF ITAB4.

TYPES : BEGIN OF EXP1,
          MATNR TYPE MARA-MATNR,
        END OF EXP1.

TYPES : BEGIN OF MAT1,
          MAT(3) TYPE C,
          CN(3)  TYPE C,
        END OF MAT1.

TYPES : BEGIN OF MAT2,
          MAT(3) TYPE C,
          BEZEI  TYPE T005U-BEZEI,
        END OF MAT2.

DATA : IT_TAB1 TYPE TABLE OF ITAB1,
       WA_TAB1 TYPE ITAB1,
       IT_TAB2 TYPE TABLE OF ITAB2,
       WA_TAB2 TYPE ITAB2,
       IT_TAB3 TYPE TABLE OF ITAB3,
       WA_TAB3 TYPE ITAB3,
       IT_TAB4 TYPE TABLE OF ITAB4,
       WA_TAB4 TYPE ITAB4,
       IT_EXP1 TYPE TABLE OF EXP1,
       WA_EXP1 TYPE EXP1,
       IT_MAT1 TYPE TABLE OF MAT1,
       WA_MAT1 TYPE MAT1,
       IT_MAT2 TYPE TABLE OF MAT2,
       WA_MAT2 TYPE MAT2.

DATA : MATNR TYPE MARA-MATNR,
       MAKTX TYPE MAKT-MAKTX,
       ZTEXT TYPE STZU-ZTEXT,
       STKTX TYPE STKO-STKTX,
*       BQTY  TYPE STKO-BMENG,
       BQTY  TYPE P,
       MEINS TYPE STPO-MEINS,
       KUNNR TYPE T001W-KUNNR,
       STLAN TYPE MAST-STLAN,
       STLAL TYPE MAST-STLAL.
DATA: EFFECTDT    TYPE SY-DATUM,
      EFFECTENDDT TYPE SY-DATUM,
      VERSION(3)  TYPE C,
      MFR(50)     TYPE C,
      EFFBATCH    TYPE MCHB-CHARG,
      STTXT       TYPE T415T-STTXT.
DATA: MAKTX1     TYPE MAKT-MAKTX,
      MAKTX2     TYPE MAKT-MAKTX,
      MAKTX3(65) TYPE C,
      NORMT      TYPE MARA-NORMT.

DATA : DATE1      TYPE SY-DATUM,
       MAT(3)     TYPE C,
       MAT1(2)    TYPE C,
       BOMTXT(20) TYPE C.

DATA:   RTDNAME           LIKE STXH-TDNAME.
DATA : BEGIN OF RITEXT1 OCCURS 0.
         INCLUDE STRUCTURE TLINE.
       DATA : END OF RITEXT1.
DATA : W_ITEXT(135) TYPE C,
       R1(1200)     TYPE C.
DATA : NOLINES TYPE I.
DATA : V_FM        TYPE RS38L_FNAM,
       FORMAT(100) TYPE C.
DATA : CONTROL  TYPE SSFCTRLOP.
DATA : W_SSFCOMPOP TYPE SSFCOMPOP.
DATA: SHELFLIFE  TYPE ZQSPECIFICATION-SHELFLIFE.
DATA: lv_IPRKZ TYPE mara-IPRKZ.

TYPES : BEGIN OF ST_CHECK,
          MATNR TYPE MAST-MATNR,
          WERKS TYPE MAST-WERKS,
          STLAN TYPE MAST-STLAN,
          STLNR TYPE MAST-STLNR,
          STLAL TYPE MAST-STLAL,
        END OF ST_CHECK.

DATA : IT_CHECK TYPE TABLE OF ST_CHECK,
       WA_CHECK TYPE          ST_CHECK.
DATA  NUM(70).
DATA : MMLINE2 LIKE TLINE OCCURS 0 WITH HEADER LINE.
*DATA : W_ITEXT1(1035) TYPE C.
DATA : W_ITEXT1 TYPE STRING.
DATA : W_ITEXTA(1035) TYPE C.
DATA : W_ITEXTB(1035) TYPE C.

SELECTION-SCREEN BEGIN OF BLOCK MERKMALE1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : MATERIAL FOR MAST-MATNR,
                 BOM FOR MAST-STLAL.
SELECT-OPTIONS  PLANT FOR MAST-WERKS.
SELECT-OPTIONS : MTART FOR MARA-MTART.

PARAMETERS :
  P1  RADIOBUTTON GROUP R1 DEFAULT 'X',
  P2  RADIOBUTTON GROUP R1,
  P21 RADIOBUTTON GROUP R1,
  P3  RADIOBUTTON GROUP R1,
  P4  RADIOBUTTON GROUP R1.

SELECTION-SCREEN END OF BLOCK MERKMALE1 .


INITIALIZATION.
  G_REPID = SY-REPID.

*  plant-sign = 'I'.
*  plant-option = 'EQ'.
*  plant-low = plant-low.
*  append plant.
*  clear plant.
*
*
*  plant-sign = 'I'.
*  plant-option = 'EQ'.
*  plant-HIGH = plant-high.
*  append plant.
*  clear plant.


*at selection-screen on material.


*  select matnr werks from mast into table it_check where matnr in material and werks EQ '1000' and stlal eq '01'.
*    EQ '1000' .

START-OF-SELECTION.

  IF P4 EQ 'X'.
    CALL TRANSACTION 'ZRMACT_EXCP'.
  ELSEIF P1 EQ 'X' .
    IF MATERIAL IS INITIAL.
      MESSAGE 'ENTER PRODUCT CODE' TYPE 'E'.
    ENDIF.
    IF PLANT IS INITIAL .
      MESSAGE 'ENTER PLANT' TYPE 'E'.
    ENDIF.
  ELSEIF P2 EQ 'X' .
    IF MATERIAL IS INITIAL.
      MESSAGE 'ENTER PRODUCT CODE' TYPE 'E'.
    ENDIF.
    IF PLANT IS INITIAL .
      MESSAGE 'ENTER PLANT' TYPE 'E'.
    ENDIF.
  ENDIF.

  SELECT MATNR WERKS STLAN STLNR STLAL FROM MAST INTO TABLE IT_CHECK WHERE MATNR IN MATERIAL AND WERKS IN PLANT AND STLAN EQ 1 AND STLAL IN BOM.
*    and stlal eq '01'.

  IF P1 EQ 'X'.
    PERFORM SMFORM.
  ELSEIF P2 EQ 'X' OR P3 EQ 'X'.
    PERFORM ALV.
  ELSEIF P21 EQ 'X'.

    PERFORM ALVHEAD.
  ENDIF.

FORM SMFORM.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
*     FORMNAME           = 'ZBOM4'  "12.4.21
*     FORMNAME           = 'ZBOM3'  "
      FORMNAME           = 'ZBOM2'  "
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
      FM_NAME            = V_FM
    EXCEPTIONS
      NO_FORM            = 1
      NO_FUNCTION_MODULE = 2
      OTHERS             = 3.

  CONTROL-NO_OPEN   = 'X'.
  CONTROL-NO_CLOSE  = 'X'.


  CALL FUNCTION 'SSF_OPEN'
    EXPORTING
      CONTROL_PARAMETERS = CONTROL.

  LOOP AT IT_CHECK INTO WA_CHECK.
    SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_CHECK-MATNR AND LVORM EQ SPACE.
    IF SY-SUBRC EQ 0.
      PERFORM FORM1.


      NUM = WA_CHECK-MATNR.
*
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
*         CLIENT                  = SY-MANDT
          ID                      = 'PRUE'
          LANGUAGE                = 'E'
          NAME                    = NUM
          OBJECT                  = 'MATERIAL'
*         ARCHIVE_HANDLE          = 0
*                  IMPORTING
*         HEADER                  =
        TABLES
          LINES                   = MMLINE2
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
      IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.

      LOOP AT MMLINE2.
        IF SY-TABIX EQ 1.
          MOVE MMLINE2-TDLINE TO W_ITEXTA.
        ELSEIF SY-TABIX EQ 2.
          MOVE MMLINE2-TDLINE TO W_ITEXTB.
*      ELSE.
*        MOVE MMLINE2-TDLINE TO W_ITEXT2.
*        CONCATENATE S3 W_ITEXT2 INTO S3 SEPARATED BY SPACE.
        ENDIF.
*    WRITE :  / 'LR',LRNO.
*      EXIT.
      ENDLOOP.
      CONDENSE : W_ITEXTA,W_ITEXTB.
      CONCATENATE W_ITEXTA W_ITEXTB INTO W_ITEXT1 SEPARATED BY SPACE.
      REPLACE '<(>&<)>' WITH '&' INTO W_ITEXT1.
      CONDENSE W_ITEXT1.
      CLEAR : EFFECTDT,VERSION,MFR,EFFBATCH,EFFECTENDDT,STTXT,STKTX.
      SELECT * FROM MKAL INTO TABLE IT_MKAL WHERE MATNR = WA_CHECK-MATNR AND STLAL EQ WA_CHECK-STLAL AND WERKS EQ WA_CHECK-WERKS.
      SORT IT_MKAL DESCENDING BY VERID.
      READ TABLE IT_MKAL INTO WA_MKAL WITH KEY MATNR = WA_CHECK-MATNR STLAL = WA_CHECK-STLAL WERKS = WA_CHECK-WERKS.
      IF SY-SUBRC EQ 0.
        EFFECTDT = WA_MKAL-ADATU.
        EFFECTENDDT = WA_MKAL-BDATU.
        VERSION = WA_MKAL-VERID.
        EFFBATCH = WA_MKAL-TEXT1.
*      READ TABLE IT_MAST INTO WA_MAST WITH KEY MATNR = WA_CHECK-MATNR WERKS = WA_CHECK-WERKS STLAL = WA_CHECK-STLAL.
*      IF SY-SUBRC EQ 0.
*        SELECT SINGLE * FROM STKO WHERE STLNR EQ WA_MAST-STLNR AND STLAL EQ WA_MAST-STLAL.
*        IF SY-SUBRC EQ 0.
*          STKTX = STKO-STKTX.
*          MFR = STKO-ZMFR.
*          SELECT SINGLE * FROM T415T WHERE SPRAS EQ 'EN' AND STLST EQ STKO-STLST.
*          IF SY-SUBRC EQ 0.
*            STTXT = T415T-STTXT.
*          ENDIF.
*        ENDIF.
*      ENDIF.
      ENDIF.

      READ TABLE IT_MAST INTO WA_MAST WITH KEY MATNR = WA_CHECK-MATNR WERKS = WA_CHECK-WERKS STLAL = WA_CHECK-STLAL.
      IF SY-SUBRC EQ 0.
        SELECT SINGLE * FROM STKO WHERE STLNR EQ WA_MAST-STLNR AND STLAL EQ WA_MAST-STLAL.
        IF SY-SUBRC EQ 0.
          STKTX = STKO-STKTX.
          MFR = STKO-ZMFR.
          SELECT SINGLE * FROM T415T WHERE SPRAS EQ 'EN' AND STLST EQ STKO-STLST.
          IF SY-SUBRC EQ 0.
            STTXT = T415T-STTXT.
          ENDIF.
        ENDIF.
      ENDIF.

      CLEAR : BOMTXT.
      SELECT SINGLE * FROM MAST WHERE MATNR = WA_CHECK-MATNR AND WERKS EQ WA_CHECK-WERKS AND STLAL EQ '02'.
      IF SY-SUBRC EQ 0.
        CONCATENATE 'Alternate BOM' WA_CHECK-STLAL INTO BOMTXT SEPARATED BY SPACE.
      ENDIF.


*      CALL FUNCTION V_FM
*        EXPORTING
*          CONTROL_PARAMETERS = CONTROL
*          USER_SETTINGS      = 'X'
*          OUTPUT_OPTIONS     = W_SSFCOMPOP
*          FORMAT             = FORMAT
*          MATNR              = MATNR
*          MAKTX              = MAKTX
*          ZTEXT              = ZTEXT
*          STKTX              = STKTX
*          BQTY               = BQTY
*          MEINS              = MEINS
*          MAST               = MAST
*          KUNNR              = KUNNR
*          STLAN              = WA_CHECK-STLAN
*          STLAL              = WA_CHECK-STLAL
*          SHELFLIFE          = SHELFLIFE
*          W_ITEXT1           = W_ITEXT1
*          EFFECTDT           = EFFECTDT
*          EFFECTENDDT        = EFFECTENDDT
*          VERSION            = VERSION
*          MFR                = MFR
*          BOMTXT             = BOMTXT
*          EFFBATCH           = EFFBATCH
*          STTXT              = STTXT
**         j_1imocust         = j_1imocust
**         g_lstno            = g_lstno
**         wa_adrc            = wa_adrc
**         vbkd               = vbkd
**         vbak               = vbak
**         total              = total
**         total1             = total1
**         vbrk               = vbrk
**         w_tax              = w_tax
**         w_value            = w_value
**         spell              = spell
**         w_diff             = w_diff
**         emname             = emname
**         rmname             = rmname
**         clmdt              = clmdt
*        TABLES
*          IT_TAB2            = IT_TAB2
**         itab_division      = itab_division
**         itab_storage       = itab_storage
**         itab_pa0002        = itab_pa0002
*        EXCEPTIONS
*          FORMATTING_ERROR   = 1
*          INTERNAL_ERROR     = 2
*          SEND_ERROR         = 3
*          USER_CANCELED      = 4
*          OTHERS             = 5.

CALL FUNCTION V_FM
  EXPORTING
*   ARCHIVE_INDEX              =
*   ARCHIVE_INDEX_TAB          =
*   ARCHIVE_PARAMETERS         =
    CONTROL_PARAMETERS         = CONTROL
*   MAIL_APPL_OBJ              =
*   MAIL_RECIPIENT             =
*   MAIL_SENDER                =
   OUTPUT_OPTIONS             = W_SSFCOMPOP
   USER_SETTINGS              = 'X'
    MATNR                      = MATNR
    FORMAT                     = FORMAT
    MAKTX                      = MAKTX
    ZTEXT                      = ZTEXT
    BQTY                       = BQTY
    MEINS                      = MEINS
    MAST                       = MAST
    KUNNR                      = KUNNR
    STLAN                      = WA_CHECK-STLAN
    STLAL                      = WA_CHECK-STLAL
    SHELFLIFE                  = SHELFLIFE
    STKTX                      = STKTX
    W_ITEXT1                   = W_ITEXT1
    MFR                        = MFR
    VERSION                    = VERSION
    EFFECTDT                   = EFFECTDT
    BOMTXT                     = BOMTXT
    EFFBATCH                   = EFFBATCH
    EFFECTENDDT                = EFFECTENDDT
    STTXT                      = STTXT
    LV_IPRKZ                   = LV_IPRKZ
* IMPORTING
*   DOCUMENT_OUTPUT_INFO       =
*   JOB_OUTPUT_INFO            =
*   JOB_OUTPUT_OPTIONS         =
  TABLES
    IT_TAB2                    = IT_TAB2
 EXCEPTIONS
   FORMATTING_ERROR           = 1
   INTERNAL_ERROR             = 2
   SEND_ERROR                 = 3
   USER_CANCELED              = 4
   OTHERS                     = 5
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.


*    call function 'WRITE_FORM'
*      exporting
*        element = 'H1'
*        window  = 'WINDOW1'.

*    loop at it_tab2 into wa_tab2 where matnr eq wa_tab1-matnr.
*      write : / 'COMPONANT',wa_tab2-idnrk.
*      call function 'WRITE_FORM'
*        exporting
*          element = 'T1'
*          window  = 'MAIN'.
*    endloop.
*
*    call function 'END_FORM'
*      exceptions
*        unopened                 = 1
*        bad_pageformat_for_print = 2
*        spool_error              = 3
*        codepage                 = 4
*        others                   = 5.
*    if sy-subrc <> 0.
*      message id sy-msgid type sy-msgty number sy-msgno
*              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*    endif.

*    endloop.
    ENDIF.
  ENDLOOP.
  CALL FUNCTION 'SSF_CLOSE'.

*  call function 'CLOSE_FORM'
** IMPORTING
**   RESULT                         =
**   RDI_RESULT                     =
** TABLES
**   OTFDATA                        =
*    exceptions
*      unopened                 = 1
*      bad_pageformat_for_print = 2
*      send_error               = 3
*      spool_error              = 4
*      codepage                 = 5
*      others                   = 6.
*  if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  endif.


*  call function 'SSF_CLOSE'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FORM1 .

  REFRESH : IT_TAB1,IT_TAB2.
  CLEAR : IT_TAB1,IT_TAB2,WA_TAB1,WA_TAB2.
  CLEAR : IT_TAB1,WA_TAB1,MAST.
  CLEAR: SHELFLIFE,FORMAT, MATNR,MAKTX,ZTEXT,BQTY,MEINS, MAST,KUNNR, STLAN,STLAL.


  SELECT * FROM MAST INTO TABLE IT_MAST WHERE MATNR EQ WA_CHECK-MATNR AND WERKS EQ WA_CHECK-WERKS AND STLAN EQ 1 AND STLNR EQ WA_CHECK-STLNR
    AND STLAL EQ WA_CHECK-STLAL .
  IF SY-SUBRC EQ 0.
    SELECT * FROM STAS INTO TABLE IT_STAS FOR ALL ENTRIES IN IT_MAST WHERE STLNR EQ IT_MAST-STLNR AND STLAL EQ IT_MAST-STLAL.
    SELECT * FROM STPO INTO TABLE IT_STPO FOR ALL ENTRIES IN IT_STAS WHERE STLNR EQ IT_STAS-STLNR AND STLKN EQ IT_STAS-STLKN AND LKENZ EQ SPACE.
    SELECT * FROM MARA INTO TABLE IT_MARA FOR ALL ENTRIES IN IT_MAST WHERE MATNR EQ IT_MAST-MATNR AND MTART IN MTART.
  ENDIF.

  SORT IT_STPO BY POSNR.

  LOOP AT IT_MAST INTO WA_MAST WHERE MATNR EQ WA_CHECK-MATNR AND WERKS EQ WA_CHECK-WERKS AND
    STLAN EQ 1 AND STLNR EQ WA_CHECK-STLNR AND STLAL EQ WA_CHECK-STLAL.
    READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_MAST-MATNR.
    IF SY-SUBRC EQ 0.

      WA_TAB1-MATNR = WA_MAST-MATNR.
      SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_MAST-MATNR AND SPRAS EQ 'EN'.
      IF SY-SUBRC EQ 0.
        WA_TAB1-MAKTX = MAKT-MAKTX.
      ENDIF.
      WA_TAB1-WERKS = WA_MAST-WERKS.
      WA_TAB1-STLAL = WA_MAST-STLAL.
      WA_TAB1-STLNR = WA_MAST-STLNR.
      WA_TAB1-STLAN = WA_MAST-STLAN.
      SELECT SINGLE * FROM STKO WHERE STLNR EQ WA_MAST-STLNR AND STLAL EQ WA_MAST-STLAL.
      IF SY-SUBRC EQ 0.
        WA_TAB1-BMENG = STKO-BMENG.
        WA_TAB1-BMEIN = STKO-BMEIN.
      ENDIF.
      SELECT SINGLE * FROM STZU WHERE STLNR EQ WA_MAST-STLNR AND STLAN EQ WA_MAST-STLAN.
      IF SY-SUBRC EQ 0.
        WA_TAB1-ZTEXT = STZU-ZTEXT.
      ENDIF.
      SELECT SINGLE * FROM STKO WHERE STLNR EQ WA_MAST-STLNR AND STLAL EQ WA_MAST-STLAL.
      IF SY-SUBRC EQ 0.
        WA_TAB1-STKTX = STKO-STKTX.
      ENDIF.
*****  read text******
      CONCATENATE '500' STKO-STLTY STKO-STLNR INTO RTDNAME.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'MZU'
          LANGUAGE                = 'E'
          NAME                    = RTDNAME
          OBJECT                  = 'BOM'
*         ARCHIVE_HANDLE          = 0
*            IMPORTING
*         HEADER                  = THEAD
        TABLES
          LINES                   = RITEXT1
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
      IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.


*        IF LTEXTV = 'X'.
*          DESCRIBE TABLE RITEXT LINES LN.
*  if ritext1 is not initial.
      NOLINES = 0.
      LOOP AT RITEXT1."WHERE tdline NE ' '.
        CONDENSE RITEXT1-TDLINE.
        NOLINES =  NOLINES  + 1.
        IF NOLINES GT  1.
          IF RITEXT1-TDLINE IS NOT  INITIAL   .
            IF RITEXT1-TDLINE NE '.'.
              MOVE RITEXT1-TDLINE TO W_ITEXT.
              CONCATENATE R1 W_ITEXT  INTO R1 SEPARATED BY SPACE.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDLOOP.
*  endif.
      WA_TAB1-TEXT1 = R1.
*****************************

      COLLECT WA_TAB1 INTO IT_TAB1.
      CLEAR WA_TAB1.
    ENDIF.
  ENDLOOP.

  SELECT * FROM ZQSPECIFICATION INTO TABLE IT_ZQSPECIFICATION FOR ALL ENTRIES IN IT_TAB1 WHERE MATNR EQ IT_TAB1-MATNR AND WERKS EQ IT_TAB1-WERKS.
  SORT IT_ZQSPECIFICATION DESCENDING BY REVISION.

  SELECT SINGLE * FROM MAST WHERE MATNR = WA_CHECK-MATNR.


  LOOP AT IT_STAS INTO WA_STAS.
    LOOP AT IT_STPO INTO WA_STPO WHERE STLNR = WA_STAS-STLNR  AND STLKN EQ WA_STAS-STLKN.
      READ TABLE IT_TAB1 INTO WA_TAB1 WITH KEY STLNR = WA_STPO-STLNR STLAL = WA_STAS-STLAL MATNR = WA_CHECK-MATNR WERKS = WA_CHECK-WERKS.
      IF SY-SUBRC EQ 0.
*    where stlnr eq wa_tab1-stlnr.
*      write : / 'A',wa_tab1-matnr,wa_tab1-werks,wa_tab1-stlnr,wa_tab1-stlan.
*      write : / 'B',wa_stpo-idnrk,wa_stpo-menge, wa_stpo-meins.
        WA_TAB2-MATNR = WA_TAB1-MATNR.
        WA_TAB2-STLAL = WA_TAB1-STLAL.
        WA_TAB2-WERKS = WA_TAB1-WERKS.
        WA_TAB2-STLAN = WA_TAB1-STLAN.
        WA_TAB2-STLNR = WA_TAB1-STLNR.
        WA_TAB2-BMENG = WA_TAB1-BMENG.
        WA_TAB2-ZTEXT = WA_TAB1-ZTEXT.
        WA_TAB2-TEXT1 = WA_TAB1-TEXT1.
        WA_TAB2-IDNRK = WA_STPO-IDNRK.
        WA_TAB2-POTX1 = WA_STPO-POTX1.

        WA_TAB2-MENGE = WA_STPO-MENGE.
        WA_TAB2-MEINS = WA_STPO-MEINS.
        WA_TAB2-POSNR = WA_STPO-POSNR.
        CLEAR : MAKTX1,MAKTX2,MAKTX3,NORMT.
        SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_STPO-IDNRK AND SPRAS EQ 'EN'.
        IF SY-SUBRC EQ 0.
          MAKTX1 = MAKT-MAKTX.
        ENDIF.
        SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_STPO-IDNRK AND SPRAS EQ 'Z1'.
        IF SY-SUBRC EQ 0.
          MAKTX2 = MAKT-MAKTX.
        ENDIF.
        SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_STPO-IDNRK.
        IF SY-SUBRC EQ 0.
          NORMT = MARA-NORMT.
        ENDIF.
        CONCATENATE MAKTX1 MAKTX2 NORMT INTO MAKTX3 SEPARATED BY SPACE.
        CONDENSE MAKTX3.
        WA_TAB2-IMAKTX = MAKTX3.


*        SELECT SINGLE * FROM ZBOMVER WHERE MATNR EQ WA_TAB1-MATNR AND STLAL EQ WA_TAB1-STLAL AND WERKS EQ WA_TAB1-WERKS.
*        IF SY-SUBRC EQ 0.
*          WA_TAB2-EFFECTDT = ZBOMVER-BUDAT.
*          WA_TAB2-VERSION = ZBOMVER-VERSION.
*          WA_TAB2-MFR = ZBOMVER-MFR.
*        ENDIF.


        COLLECT WA_TAB2 INTO IT_TAB2.
        CLEAR WA_TAB2.
      ENDIF.
    ENDLOOP.
  ENDLOOP.


  IF P2 EQ 'X'.
    WA_FIELDCAT-FIELDNAME = 'MATNR'.
    WA_FIELDCAT-SELTEXT_L = 'MATERIAL CODE'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'WERKS'.
    WA_FIELDCAT-SELTEXT_L = 'PLANT'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'STLAL'.
    WA_FIELDCAT-SELTEXT_L = 'BOM No.'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'STLAN'.
    WA_FIELDCAT-SELTEXT_L = 'BOM ID.'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'STLNR'.
    WA_FIELDCAT-SELTEXT_L = 'BOM NO.'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'BMENG'.
    WA_FIELDCAT-SELTEXT_L = 'BMENG'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'ZTEXT'.
    WA_FIELDCAT-SELTEXT_L = 'VERSION'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'TEXT1'.
    WA_FIELDCAT-SELTEXT_L = 'BOM ADDITIONAL TEXT'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'POTX1'.
    WA_FIELDCAT-SELTEXT_L = 'BOM STAGE'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'IDNRK'.
    WA_FIELDCAT-SELTEXT_L = 'BOM COMPONENT'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'MENGE'.
    WA_FIELDCAT-SELTEXT_L = 'QUANTITY'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'MEINS'.
    WA_FIELDCAT-SELTEXT_L = 'UNIT'.
    APPEND WA_FIELDCAT TO FIELDCAT.




    LAYOUT-ZEBRA = 'X'.
    LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
    LAYOUT-WINDOW_TITLEBAR  = 'BOM DETAILS'.


    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
*       I_INTERFACE_CHECK       = ' '
*       I_BYPASSING_BUFFER      = ' '
*       I_BUFFER_ACTIVE         = ' '
        I_CALLBACK_PROGRAM      = G_REPID
*       I_CALLBACK_PF_STATUS_SET          = ' '
        I_CALLBACK_USER_COMMAND = 'USER_COMM'
        I_CALLBACK_TOP_OF_PAGE  = 'TOP'
*       I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*       I_CALLBACK_HTML_END_OF_LIST       = ' '
*       I_STRUCTURE_NAME        =
*       I_BACKGROUND_ID         = ' '
*       I_GRID_TITLE            =
*       I_GRID_SETTINGS         =
        IS_LAYOUT               = LAYOUT
        IT_FIELDCAT             = FIELDCAT
*       IT_EXCLUDING            =
*       IT_SPECIAL_GROUPS       =
*       IT_SORT                 =
*       IT_FILTER               =
*       IS_SEL_HIDE             =
*       I_DEFAULT               = 'X'
        I_SAVE                  = 'A'
*       IS_VARIANT              =
*       IT_EVENTS               =
*       IT_EVENT_EXIT           =
*       IS_PRINT                =
*       IS_REPREP_ID            =
*       I_SCREEN_START_COLUMN   = 0
*       I_SCREEN_START_LINE     = 0
*       I_SCREEN_END_COLUMN     = 0
*       I_SCREEN_END_LINE       = 0
*       I_HTML_HEIGHT_TOP       = 0
*       I_HTML_HEIGHT_END       = 0
*       IT_ALV_GRAPHICS         =
*       IT_HYPERLINK            =
*       IT_ADD_FIELDCAT         =
*       IT_EXCEPT_QINFO         =
*       IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*       E_EXIT_CAUSED_BY_CALLER =
*       ES_EXIT_CAUSED_BY_USER  =
      TABLES
        T_OUTTAB                = IT_TAB2
      EXCEPTIONS
        PROGRAM_ERROR           = 1
        OTHERS                  = 2.
    IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.
  ENDIF.
  SORT IT_TAB2 BY  STLNR POSNR.
  LOOP AT IT_TAB1 INTO WA_TAB1 WHERE MATNR EQ WA_CHECK-MATNR.

    CLEAR :  ZTEXT,BQTY,MEINS,STKTX,EFFECTDT, VERSION,MFR.
    ZTEXT = WA_TAB1-ZTEXT.
    STKTX = WA_TAB1-STKTX.
    MATNR = WA_TAB1-MATNR.
    ZTEXT  = WA_TAB1-ZTEXT.
    BQTY = WA_TAB1-BMENG.
    MEINS  = WA_TAB1-BMEIN.
    SELECT SINGLE * FROM T001W WHERE WERKS EQ WA_TAB1-WERKS.
    IF SY-SUBRC EQ 0.
*      IF T001W-WERKS EQ '1000'.
        KUNNR = T001W-ORT01.
*      ELSE.
*        KUNNR = T001W-KUNNR.
*      ENDIF.
    ENDIF.
    READ TABLE IT_mara INTO WA_MARA WITH KEY MATNR = WA_TAB1-MATNR. "WERKS = WA_TAB1-WERKS.
    IF SY-SUBRC EQ 0.
      SHELFLIFE = WA_MARA-MHDHB + 1.             "WA_ZQSPECIFICATION-SHELFLIFE.
      LV_IPRKZ = wa_mara-IPRKZ.
                                      "  Months logic added in this place.
    ENDIF.


  ENDLOOP.
*    call function 'START_FORM'
*      exporting
*        form        = 'ZBOM'
*        language    = sy-langu
*      exceptions
*        form        = 1
*        format      = 2
*        unended     = 3
*        unopened    = 4
*        unused      = 5
*        spool_error = 6
*        codepage    = 7
*        others      = 8.
*    if sy-subrc <> 0.
*      message id sy-msgid type sy-msgty number sy-msgno
*              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*    endif.

  SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_TAB1-MATNR AND SPRAS EQ 'EN'.
  IF SY-SUBRC EQ 0.
    MAKTX = MAKT-MAKTX.
  ENDIF.

ENDFORM.

FORM USER_COMM USING UCOMM LIKE SY-UCOMM
                     SELFIELD TYPE SLIS_SELFIELD.



  CASE SELFIELD-FIELDNAME.
    WHEN 'MATNR'.
      SET PARAMETER ID 'MAT' FIELD SELFIELD-VALUE.
      CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
    WHEN 'IDNRK'.
      SET PARAMETER ID 'MAT' FIELD SELFIELD-VALUE.
      CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
    WHEN 'VBELN1'.
      SET PARAMETER ID 'BV' FIELD SELFIELD-VALUE.
      CALL TRANSACTION 'VL03N' AND SKIP FIRST SCREEN.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.                    "USER_COMM
*&---------------------------------------------------------------------*
*&      Form  ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ALV .

*refresh : it_tab1,it_tab2.
*  clear : it_tab1,wa_tab1,mast.

  SELECT * FROM MAST INTO TABLE IT_MAST WHERE MATNR IN MATERIAL AND WERKS IN PLANT AND STLAN EQ 1 .
  IF SY-SUBRC EQ 0.
    SELECT * FROM STAS INTO TABLE IT_STAS FOR ALL ENTRIES IN IT_MAST WHERE STLNR EQ IT_MAST-STLNR AND STLAL EQ IT_MAST-STLAL.
    SELECT * FROM STPO INTO TABLE IT_STPO FOR ALL ENTRIES IN IT_STAS WHERE STLNR EQ IT_STAS-STLNR AND STLKN EQ IT_STAS-STLKN AND LKENZ EQ SPACE.
    SELECT * FROM MARA  INTO TABLE IT_MARA FOR ALL ENTRIES IN IT_MAST WHERE MATNR EQ IT_MAST-MATNR AND MTART IN MTART.
  ENDIF.
  SORT IT_STPO BY POSNR.

  LOOP AT IT_MAST INTO WA_MAST WHERE STLAN EQ 1.
    SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_MAST-MATNR AND LVORM EQ SPACE.
    IF SY-SUBRC EQ 0.
      READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_MAST-MATNR.
      IF SY-SUBRC EQ 0.

        WA_TAB1-MATNR = WA_MAST-MATNR.
        SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_MAST-MATNR AND SPRAS EQ 'EN'.
        IF SY-SUBRC EQ 0.
          WA_TAB1-MAKTX = MAKT-MAKTX.
        ENDIF.
        WA_TAB1-WERKS = WA_MAST-WERKS.
        WA_TAB1-STLNR = WA_MAST-STLNR.
        WA_TAB1-STLAL = WA_MAST-STLAL.
        WA_TAB1-STLAN = WA_MAST-STLAN.
        SELECT SINGLE * FROM STKO WHERE STLNR EQ WA_MAST-STLNR AND STLAL EQ WA_MAST-STLAL.
        IF SY-SUBRC EQ 0.
          WA_TAB1-BMENG = STKO-BMENG.
          WA_TAB1-BMEIN = STKO-BMEIN.
        ENDIF.
        SELECT SINGLE * FROM STZU WHERE STLNR EQ WA_MAST-STLNR AND STLAN EQ WA_MAST-STLAN.
        IF SY-SUBRC EQ 0.
          WA_TAB1-ZTEXT = STZU-ZTEXT.
        ENDIF.
*****  read text******
        CONCATENATE '500' STKO-STLTY STKO-STLNR INTO RTDNAME.

        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'MZU'
            LANGUAGE                = 'E'
            NAME                    = RTDNAME
            OBJECT                  = 'BOM'
*           ARCHIVE_HANDLE          = 0
*            IMPORTING
*           HEADER                  = THEAD
          TABLES
            LINES                   = RITEXT1
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.


*        IF LTEXTV = 'X'.
*          DESCRIBE TABLE RITEXT LINES LN.
*  if ritext1 is not initial.
        NOLINES = 0.
        LOOP AT RITEXT1."WHERE tdline NE ' '.
          CONDENSE RITEXT1-TDLINE.
          NOLINES =  NOLINES  + 1.
          IF NOLINES GT  1.
            IF RITEXT1-TDLINE IS NOT  INITIAL   .
              IF RITEXT1-TDLINE NE '.'.
                MOVE RITEXT1-TDLINE TO W_ITEXT.
                CONCATENATE R1 W_ITEXT  INTO R1 SEPARATED BY SPACE.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.
*  endif.
        WA_TAB1-TEXT1 = R1.
*****************************

        COLLECT WA_TAB1 INTO IT_TAB1.
        CLEAR WA_TAB1.
      ENDIF.
    ENDIF.
  ENDLOOP.

  SELECT SINGLE * FROM MAST WHERE MATNR = WA_CHECK-MATNR AND WERKS EQ PLANT AND STLAN EQ 1.

*loop at it_tab1 into wa_tab1.
  LOOP AT IT_MAST INTO WA_MAST WHERE STLAN EQ 1.
    SELECT SINGLE * FROM STKO WHERE STLNR EQ WA_MAST-STLNR AND STLAL EQ WA_MAST-STLAL AND STLST EQ '01'.
    IF SY-SUBRC EQ 0.
      LOOP AT IT_STAS INTO WA_STAS WHERE STLNR EQ WA_MAST-STLNR AND STLAL EQ WA_MAST-STLAL.
        LOOP AT IT_STPO INTO WA_STPO WHERE STLNR = WA_STAS-STLNR  AND STLKN EQ WA_STAS-STLKN.
          READ TABLE IT_TAB1 INTO WA_TAB1 WITH KEY STLNR = WA_STPO-STLNR STLAL = WA_STAS-STLAL .
          IF SY-SUBRC EQ 0.
*    where stlnr eq wa_tab1-stlnr.
*      write : / 'A',wa_tab1-matnr,wa_tab1-werks,wa_tab1-stlnr,wa_tab1-stlan.
*      write : / 'B',wa_stpo-idnrk,wa_stpo-menge, wa_stpo-meins.
            WA_TAB2-MATNR = WA_TAB1-MATNR.
            WA_TAB2-MAKTX = WA_TAB1-MAKTX.
            WA_TAB2-WERKS = WA_TAB1-WERKS.
            WA_TAB2-STLAN = WA_TAB1-STLAN.
            WA_TAB2-STLAL = WA_TAB1-STLAL.
            WA_TAB2-STLNR = WA_TAB1-STLNR.
            WA_TAB2-BMENG = WA_TAB1-BMENG.
            WA_TAB2-ZTEXT = WA_TAB1-ZTEXT.
            WA_TAB2-TEXT1 = WA_TAB1-TEXT1.
            WA_TAB2-IDNRK = WA_STPO-IDNRK.
            WA_TAB2-POTX1 = WA_STPO-POTX1.
            WA_TAB2-MENGE = WA_STPO-MENGE.
            WA_TAB2-MEINS = WA_STPO-MEINS.
            WA_TAB2-POSNR = WA_STPO-POSNR.
            WA_TAB2-SORTF = WA_STPO-SORTF.
*          SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_STPO-IDNRK AND SPRAS EQ 'EN'.
*          IF SY-SUBRC EQ 0.
*            WA_TAB2-IMAKTX = MAKT-MAKTX.
*          ENDIF.
            CLEAR : MAKTX1,MAKTX2,MAKTX3,NORMT.
            SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_STPO-IDNRK AND SPRAS EQ 'EN'.
            IF SY-SUBRC EQ 0.
              MAKTX1 = MAKT-MAKTX.
            ENDIF.
            SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_STPO-IDNRK AND SPRAS EQ 'Z1'.
            IF SY-SUBRC EQ 0.
              MAKTX2 = MAKT-MAKTX.
            ENDIF.
            SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_STPO-IDNRK.
            IF SY-SUBRC EQ 0.
              NORMT = MARA-NORMT.
            ENDIF.
            CONCATENATE MAKTX1 MAKTX2 NORMT INTO MAKTX3 SEPARATED BY SPACE.
            CONDENSE MAKTX3.
            WA_TAB2-IMAKTX = MAKTX3.
            COLLECT WA_TAB2 INTO IT_TAB2.
            CLEAR WA_TAB2.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDIF.
  ENDLOOP.

  IF P3 EQ 'X'.
    PERFORM LIST.

  ELSE.


    WA_FIELDCAT-FIELDNAME = 'MATNR'.
    WA_FIELDCAT-SELTEXT_L = 'PRODUCT CODE'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'MAKTX'.
    WA_FIELDCAT-SELTEXT_L = 'PRODUCT NAME'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'WERKS'.
    WA_FIELDCAT-SELTEXT_L = 'PLANT'.
    APPEND WA_FIELDCAT TO FIELDCAT.

*    WA_FIELDCAT-FIELDNAME = 'STLAL'.
*    WA_FIELDCAT-SELTEXT_L = 'BOM NO..'.
*    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'STLAN'.
    WA_FIELDCAT-SELTEXT_L = 'BOM ID.'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'STLNR'.
    WA_FIELDCAT-SELTEXT_L = 'BOM NO.'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'STLAL'.
    WA_FIELDCAT-SELTEXT_L = 'ALT BOM NO.'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'BMENG'.
    WA_FIELDCAT-SELTEXT_L = 'BMENG'.
    APPEND WA_FIELDCAT TO FIELDCAT.

     WA_FIELDCAT-FIELDNAME = 'SORTF'.
    WA_FIELDCAT-SELTEXT_L = 'SORT STRING'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'ZTEXT'.
    WA_FIELDCAT-SELTEXT_L = 'VERSION'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'TEXT1'.
    WA_FIELDCAT-SELTEXT_L = 'BOM ADDITIONAL TEXT'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'POTX1'.
    WA_FIELDCAT-SELTEXT_L = 'BOM STAGE'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'POSNR'.
    WA_FIELDCAT-SELTEXT_L = 'COMPONENT NO'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'IDNRK'.
    WA_FIELDCAT-SELTEXT_L = 'BOM COMPONENT'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'IMAKTX'.
    WA_FIELDCAT-SELTEXT_L = 'COMPONENT NAME'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'NORMT'.
    WA_FIELDCAT-SELTEXT_L = 'PHARMACOPIE STATUS'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'MENGE'.
    WA_FIELDCAT-SELTEXT_L = 'QUANTITY'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'MEINS'.
    WA_FIELDCAT-SELTEXT_L = 'UNIT'.
    APPEND WA_FIELDCAT TO FIELDCAT.




    LAYOUT-ZEBRA = 'X'.
    LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
    LAYOUT-WINDOW_TITLEBAR  = 'BOM DETAILS'.


    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
*       I_INTERFACE_CHECK       = ' '
*       I_BYPASSING_BUFFER      = ' '
*       I_BUFFER_ACTIVE         = ' '
        I_CALLBACK_PROGRAM      = G_REPID
*       I_CALLBACK_PF_STATUS_SET          = ' '
        I_CALLBACK_USER_COMMAND = 'USER_COMM'
        I_CALLBACK_TOP_OF_PAGE  = 'TOP'
*       I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*       I_CALLBACK_HTML_END_OF_LIST       = ' '
*       I_STRUCTURE_NAME        =
*       I_BACKGROUND_ID         = ' '
*       I_GRID_TITLE            =
*       I_GRID_SETTINGS         =
        IS_LAYOUT               = LAYOUT
        IT_FIELDCAT             = FIELDCAT
*       IT_EXCLUDING            =
*       IT_SPECIAL_GROUPS       =
*       IT_SORT                 =
*       IT_FILTER               =
*       IS_SEL_HIDE             =
*       I_DEFAULT               = 'X'
        I_SAVE                  = 'A'
*       IS_VARIANT              =
*       IT_EVENTS               =
*       IT_EVENT_EXIT           =
*       IS_PRINT                =
*       IS_REPREP_ID            =
*       I_SCREEN_START_COLUMN   = 0
*       I_SCREEN_START_LINE     = 0
*       I_SCREEN_END_COLUMN     = 0
*       I_SCREEN_END_LINE       = 0
*       I_HTML_HEIGHT_TOP       = 0
*       I_HTML_HEIGHT_END       = 0
*       IT_ALV_GRAPHICS         =
*       IT_HYPERLINK            =
*       IT_ADD_FIELDCAT         =
*       IT_EXCEPT_QINFO         =
*       IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*       E_EXIT_CAUSED_BY_CALLER =
*       ES_EXIT_CAUSED_BY_USER  =
      TABLES
        T_OUTTAB                = IT_TAB2
      EXCEPTIONS
        PROGRAM_ERROR           = 1
        OTHERS                  = 2.
    IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

  ENDIF.

*&---------------------------------------------------------------------*
*&      Form  TOP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FORM2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM FORM2 .
*
*ENDFORM.

FORM TOP.

  DATA: COMMENT    TYPE SLIS_T_LISTHEADER,
        WA_COMMENT LIKE LINE OF COMMENT.

  WA_COMMENT-TYP = 'A'.
  WA_COMMENT-INFO = 'BOM DETAILS'.
*  WA_COMMENT-INFO = P_FRMDT.
  APPEND WA_COMMENT TO COMMENT.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = COMMENT
*     I_LOGO             = 'ENJOYSAP_LOGO'
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .

*  clear comment.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  LIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM LIST.
  LOOP AT IT_TAB2 INTO WA_TAB2.
    WA_TAB3-MATNR = WA_TAB2-MATNR.
    WA_TAB3-MAKTX = WA_TAB2-MAKTX.
    WA_TAB3-WERKS = WA_TAB2-WERKS.
    WA_TAB3-STLAN = WA_TAB2-STLAN.
    WA_TAB3-STLAL = WA_TAB2-STLAL.
    WA_TAB3-STLNR = WA_TAB2-STLNR.
    WA_TAB3-BMENG = WA_TAB2-BMENG.
    WA_TAB3-ZTEXT = WA_TAB2-ZTEXT.
    WA_TAB3-TEXT1 = WA_TAB2-TEXT1.
    SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_TAB2-MATNR AND MTART IN ( 'ZESC','ZESM' ).
    IF SY-SUBRC EQ 0.
      WA_EXP1-MATNR = MARA-MATNR.
      COLLECT WA_EXP1 INTO IT_EXP1.
      CLEAR WA_EXP1.
    ENDIF.
    COLLECT WA_TAB3 INTO IT_TAB3.
    CLEAR WA_TAB3.
  ENDLOOP.

  SORT IT_EXP1 BY MATNR.
  DELETE ADJACENT DUPLICATES FROM IT_EXP1 COMPARING MATNR.
  PERFORM SALE.

  LOOP AT IT_TAB3 INTO WA_TAB3.
    WA_TAB4-MATNR = WA_TAB3-MATNR.
    WA_TAB4-MAKTX = WA_TAB3-MAKTX.
    WA_TAB4-WERKS = WA_TAB3-WERKS.
    WA_TAB4-STLAN = WA_TAB3-STLAN.
    WA_TAB4-STLAL = WA_TAB3-STLAL.
    WA_TAB4-STLNR = WA_TAB3-STLNR.
    WA_TAB4-BMENG = WA_TAB3-BMENG.
    WA_TAB4-ZTEXT = WA_TAB3-ZTEXT.
    WA_TAB4-TEXT1 = WA_TAB3-TEXT1.
    SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_TAB3-MATNR AND MTART IN ( 'ZESC','ZESM' ).
    IF SY-SUBRC EQ 0.
      READ TABLE IT_MAT2 INTO WA_MAT2 WITH KEY MAT = WA_TAB3-MATNR+10(3).
      IF SY-SUBRC EQ 0.
        WA_TAB4-BEZEI = WA_MAT2-BEZEI.
      ENDIF.
    ENDIF.
    COLLECT WA_TAB4 INTO IT_TAB4.
    CLEAR WA_TAB4.
  ENDLOOP.

  SORT IT_TAB3 BY MATNR WERKS STLAN STLAL STLNR BMENG.
  DELETE ADJACENT DUPLICATES FROM IT_TAB3 COMPARING MATNR WERKS STLAN STLAL STLNR BMENG.


  WA_FIELDCAT-FIELDNAME = 'MATNR'.
  WA_FIELDCAT-SELTEXT_L = 'PRODUCT CODE'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'MAKTX'.
  WA_FIELDCAT-SELTEXT_L = 'PRODUCT NAME'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'WERKS'.
  WA_FIELDCAT-SELTEXT_L = 'PLANT'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'STLAN'.
  WA_FIELDCAT-SELTEXT_L = 'BOM ID.'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'STLNR'.
  WA_FIELDCAT-SELTEXT_L = 'BOM NO.'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'STLAL'.
  WA_FIELDCAT-SELTEXT_L = 'ALT BOM NO.'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'BMENG'.
  WA_FIELDCAT-SELTEXT_L = 'BMENG'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'ZTEXT'.
  WA_FIELDCAT-SELTEXT_L = 'VERSION'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'TEXT1'.
  WA_FIELDCAT-SELTEXT_L = 'BOM ADDITIONAL TEXT'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'BEZEI'.
  WA_FIELDCAT-SELTEXT_L = 'COUNTRY'.
  APPEND WA_FIELDCAT TO FIELDCAT.

*  WA_FIELDCAT-FIELDNAME = 'IDNRK'.
*  WA_FIELDCAT-SELTEXT_L = 'BOM COMPONENT'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'IMAKTX'.
*  WA_FIELDCAT-SELTEXT_L = 'COMPONENT NAME'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'NORMT'.
*  WA_FIELDCAT-SELTEXT_L = 'PHARMACOPIE STATUS'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'MENGE'.
*  WA_FIELDCAT-SELTEXT_L = 'QUANTITY'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'MEINS'.
*  WA_FIELDCAT-SELTEXT_L = 'UNIT'.
*  APPEND WA_FIELDCAT TO FIELDCAT.




  LAYOUT-ZEBRA = 'X'.
  LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
  LAYOUT-WINDOW_TITLEBAR  = 'LIST OF PRODUCT CODES HAVING BOM'.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      I_CALLBACK_PROGRAM      = G_REPID
*     I_CALLBACK_PF_STATUS_SET          = ' '
      I_CALLBACK_USER_COMMAND = 'USER_COMM'
      I_CALLBACK_TOP_OF_PAGE  = 'TOP'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         =
      IS_LAYOUT               = LAYOUT
      IT_FIELDCAT             = FIELDCAT
*     IT_EXCLUDING            =
*     IT_SPECIAL_GROUPS       =
*     IT_SORT                 =
*     IT_FILTER               =
*     IS_SEL_HIDE             =
*     I_DEFAULT               = 'X'
      I_SAVE                  = 'A'
*     IS_VARIANT              =
*     IT_EVENTS               =
*     IT_EVENT_EXIT           =
*     IS_PRINT                =
*     IS_REPREP_ID            =
*     I_SCREEN_START_COLUMN   = 0
*     I_SCREEN_START_LINE     = 0
*     I_SCREEN_END_COLUMN     = 0
*     I_SCREEN_END_LINE       = 0
*     I_HTML_HEIGHT_TOP       = 0
*     I_HTML_HEIGHT_END       = 0
*     IT_ALV_GRAPHICS         =
*     IT_HYPERLINK            =
*     IT_ADD_FIELDCAT         =
*     IT_EXCEPT_QINFO         =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER =
*     ES_EXIT_CAUSED_BY_USER  =
    TABLES
      T_OUTTAB                = IT_TAB4
    EXCEPTIONS
      PROGRAM_ERROR           = 1
      OTHERS                  = 2.
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SALE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SALE.
  DATE1 = SY-DATUM - 360.

  IF IT_EXP1 IS NOT INITIAL.
    SELECT * FROM VBRK INTO TABLE IT_VBRK WHERE FKART IN ( 'Z002', 'Z003','Z004' )  AND FKDAT GE DATE1 AND FKDAT LE SY-DATUM.
    IF SY-SUBRC EQ 0.
      SELECT * FROM VBRP INTO TABLE IT_VBRP FOR ALL ENTRIES IN IT_VBRK WHERE VBELN = IT_VBRK-VBELN.
    ENDIF.
  ENDIF.
  IF IT_VBRP IS NOT INITIAL.
    LOOP AT IT_VBRP INTO WA_VBRP.
      WA_MAT1-MAT = WA_VBRP-MATNR+10(3).
      WA_MAT1-CN = WA_VBRP-LLAND_AUFT.
      COLLECT WA_MAT1 INTO IT_MAT1.
      CLEAR WA_MAT1.
    ENDLOOP.
  ENDIF.

  SORT IT_VBRK DESCENDING BY VBELN.
  IF IT_EXP1 IS NOT INITIAL.
    LOOP AT IT_EXP1 INTO WA_EXP1.
      CLEAR : MAT,MAT1.
*      WRITE : / 'a',WA_EXP1-MATNR.
      MAT = WA_EXP1-MATNR+10(3).
      READ TABLE IT_MAT1 INTO WA_MAT1 WITH KEY MAT = MAT.
      IF SY-SUBRC EQ 0.
*        WRITE : WA_MAT1-CN.
        SELECT SINGLE * FROM T005U WHERE SPRAS EQ 'EN' AND LAND1 EQ WA_MAT1-CN.
        IF SY-SUBRC EQ 0.
*          WRITE : T005U-BEZEI.
          WA_MAT2-MAT = WA_MAT1-MAT.
          WA_MAT2-BEZEI = T005U-BEZEI.
          COLLECT WA_MAT2 INTO IT_MAT2.
          CLEAR WA_MAT2.
        ENDIF.
*      ELSE.
*        MAT1 = WA_EXP1-MATNR+11(2).
      ENDIF.
    ENDLOOP.
  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALVHEAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ALVHEAD .
*refresh : it_tab1,it_tab2.
*  clear : it_tab1,wa_tab1,mast.

  SELECT * FROM MAST INTO TABLE IT_MAST WHERE MATNR IN MATERIAL AND WERKS IN PLANT AND STLAN EQ 1 .
  IF SY-SUBRC EQ 0.
    SELECT * FROM STAS INTO TABLE IT_STAS FOR ALL ENTRIES IN IT_MAST WHERE STLNR EQ IT_MAST-STLNR AND STLAL EQ IT_MAST-STLAL.
    SELECT * FROM STPO INTO TABLE IT_STPO FOR ALL ENTRIES IN IT_STAS WHERE STLNR EQ IT_STAS-STLNR AND STLKN EQ IT_STAS-STLKN AND LKENZ EQ SPACE.
    SELECT * FROM MARA  INTO TABLE IT_MARA FOR ALL ENTRIES IN IT_MAST WHERE MATNR EQ IT_MAST-MATNR AND MTART IN MTART.
  ENDIF.
  SORT IT_STPO BY POSNR.

  LOOP AT IT_MAST INTO WA_MAST WHERE STLAN EQ 1.
    SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_MAST-MATNR AND LVORM EQ SPACE.
    IF SY-SUBRC EQ 0.
      READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_MAST-MATNR.
      IF SY-SUBRC EQ 0.

        WA_TAB1-MATNR = WA_MAST-MATNR.
        SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_MAST-MATNR AND SPRAS EQ 'EN'.
        IF SY-SUBRC EQ 0.
          WA_TAB1-MAKTX = MAKT-MAKTX.
        ENDIF.
        WA_TAB1-WERKS = WA_MAST-WERKS.
        WA_TAB1-STLNR = WA_MAST-STLNR.
        WA_TAB1-STLAL = WA_MAST-STLAL.
        WA_TAB1-STLAN = WA_MAST-STLAN.
        SELECT SINGLE * FROM STKO WHERE STLNR EQ WA_MAST-STLNR AND STLAL EQ WA_MAST-STLAL.
        IF SY-SUBRC EQ 0.
          WA_TAB1-BMENG = STKO-BMENG.
          WA_TAB1-BMEIN = STKO-BMEIN.
        ENDIF.
        SELECT SINGLE * FROM STZU WHERE STLNR EQ WA_MAST-STLNR AND STLAN EQ WA_MAST-STLAN.
        IF SY-SUBRC EQ 0.
          WA_TAB1-ZTEXT = STZU-ZTEXT.
        ENDIF.
*****  read text******
        CONCATENATE '500' STKO-STLTY STKO-STLNR INTO RTDNAME.

        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'MZU'
            LANGUAGE                = 'E'
            NAME                    = RTDNAME
            OBJECT                  = 'BOM'
*           ARCHIVE_HANDLE          = 0
*            IMPORTING
*           HEADER                  = THEAD
          TABLES
            LINES                   = RITEXT1
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.


*        IF LTEXTV = 'X'.
*          DESCRIBE TABLE RITEXT LINES LN.
*  if ritext1 is not initial.
        NOLINES = 0.
        LOOP AT RITEXT1."WHERE tdline NE ' '.
          CONDENSE RITEXT1-TDLINE.
          NOLINES =  NOLINES  + 1.
          IF NOLINES GT  1.
            IF RITEXT1-TDLINE IS NOT  INITIAL   .
              IF RITEXT1-TDLINE NE '.'.
                MOVE RITEXT1-TDLINE TO W_ITEXT.
                CONCATENATE R1 W_ITEXT  INTO R1 SEPARATED BY SPACE.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.
*  endif.
        WA_TAB1-TEXT1 = R1.
*****************************

        COLLECT WA_TAB1 INTO IT_TAB1.
        CLEAR WA_TAB1.
      ENDIF.
    ENDIF.
  ENDLOOP.

  SELECT SINGLE * FROM MAST WHERE MATNR = WA_CHECK-MATNR AND WERKS EQ PLANT AND STLAN EQ 1.
  IF IT_MAST IS NOT INITIAL.
    SELECT  * FROM STKO INTO TABLE IT_STKO FOR ALL ENTRIES IN IT_MAST WHERE STLNR EQ IT_MAST-STLNR AND STLAL EQ IT_MAST-STLAL AND STLST EQ '01' AND LOEKZ EQ SPACE.
  ENDIF.

  LOOP AT IT_STKO INTO WA_STKO.
    READ TABLE IT_MAST INTO WA_MAST WITH KEY STLNR = WA_STKO-STLNR STLAL = WA_STKO-STLAL.
    IF SY-SUBRC EQ 0.
      WA_TAB2-WERKS = WA_MAST-WERKS.
      WA_TAB2-MATNR = WA_MAST-MATNR.
      WA_TAB2-STLNR = WA_MAST-STLNR.
      WA_TAB2-STLAL = WA_MAST-STLAL.
      WA_TAB2-BMENG = WA_STKO-BMENG.
      WA_TAB2-MEINS = WA_STKO-BMEIN.
      WA_TAB2-ZMFR = WA_STKO-ZMFR.

      CLEAR : MAKTX1,MAKTX2,MAKTX3,NORMT.
      SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_MAST-MATNR AND SPRAS EQ 'EN'.
      IF SY-SUBRC EQ 0.
        MAKTX1 = MAKT-MAKTX.
      ENDIF.
      SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_MAST-MATNR AND SPRAS EQ 'Z1'.
      IF SY-SUBRC EQ 0.
        MAKTX2 = MAKT-MAKTX.
      ENDIF.
      SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_MAST-MATNR.
      IF SY-SUBRC EQ 0.
        NORMT = MARA-NORMT.
      ENDIF.
      CONCATENATE MAKTX1 MAKTX2 NORMT INTO MAKTX3 SEPARATED BY SPACE.
      CONDENSE MAKTX3.
      WA_TAB2-MAKTX = MAKTX3.

      COLLECT WA_TAB2 INTO IT_TAB2.
      CLEAR WA_TAB2.
    ENDIF.
  ENDLOOP.



  IF P3 EQ 'X'.
    PERFORM LIST.

  ELSE.


    WA_FIELDCAT-FIELDNAME = 'MATNR'.
    WA_FIELDCAT-SELTEXT_L = 'PRODUCT CODE'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'MAKTX'.
    WA_FIELDCAT-SELTEXT_L = 'PRODUCT NAME'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'WERKS'.
    WA_FIELDCAT-SELTEXT_L = 'PLANT'.
    APPEND WA_FIELDCAT TO FIELDCAT.

*    WA_FIELDCAT-FIELDNAME = 'STLAL'.
*    WA_FIELDCAT-SELTEXT_L = 'BOM NO..'.
*    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'STLAN'.
    WA_FIELDCAT-SELTEXT_L = 'BOM ID.'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'STLNR'.
    WA_FIELDCAT-SELTEXT_L = 'BOM NO.'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'STLAL'.
    WA_FIELDCAT-SELTEXT_L = 'ALT BOM NO.'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'BMENG'.
    WA_FIELDCAT-SELTEXT_L = 'BMENG'.
    APPEND WA_FIELDCAT TO FIELDCAT.

*    WA_FIELDCAT-FIELDNAME = 'ZTEXT'.
*    WA_FIELDCAT-SELTEXT_L = 'VERSION'.
*    APPEND WA_FIELDCAT TO FIELDCAT.
*
*    WA_FIELDCAT-FIELDNAME = 'TEXT1'.
*    WA_FIELDCAT-SELTEXT_L = 'BOM ADDITIONAL TEXT'.
*    APPEND WA_FIELDCAT TO FIELDCAT.
*
*    WA_FIELDCAT-FIELDNAME = 'POTX1'.
*    WA_FIELDCAT-SELTEXT_L = 'BOM STAGE'.
*    APPEND WA_FIELDCAT TO FIELDCAT.
*
*    WA_FIELDCAT-FIELDNAME = 'POSNR'.
*    WA_FIELDCAT-SELTEXT_L = 'COMPONENT NO'.
*    APPEND WA_FIELDCAT TO FIELDCAT.
*
*    WA_FIELDCAT-FIELDNAME = 'IDNRK'.
*    WA_FIELDCAT-SELTEXT_L = 'BOM COMPONENT'.
*    APPEND WA_FIELDCAT TO FIELDCAT.
*
*    WA_FIELDCAT-FIELDNAME = 'IMAKTX'.
*    WA_FIELDCAT-SELTEXT_L = 'COMPONENT NAME'.
*    APPEND WA_FIELDCAT TO FIELDCAT.
*
*    WA_FIELDCAT-FIELDNAME = 'NORMT'.
*    WA_FIELDCAT-SELTEXT_L = 'PHARMACOPIE STATUS'.
*    APPEND WA_FIELDCAT TO FIELDCAT.

*    WA_FIELDCAT-FIELDNAME = 'MENGE'.
*    WA_FIELDCAT-SELTEXT_L = 'QUANTITY'.
*    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'MEINS'.
    WA_FIELDCAT-SELTEXT_L = 'UNIT'.
    APPEND WA_FIELDCAT TO FIELDCAT.

    WA_FIELDCAT-FIELDNAME = 'ZMFR'.
    WA_FIELDCAT-SELTEXT_L = 'MFR NO'.
    APPEND WA_FIELDCAT TO FIELDCAT.




    LAYOUT-ZEBRA = 'X'.
    LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
    LAYOUT-WINDOW_TITLEBAR  = 'BOM HEADER DETAILS'.


    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
*       I_INTERFACE_CHECK       = ' '
*       I_BYPASSING_BUFFER      = ' '
*       I_BUFFER_ACTIVE         = ' '
        I_CALLBACK_PROGRAM      = G_REPID
*       I_CALLBACK_PF_STATUS_SET          = ' '
        I_CALLBACK_USER_COMMAND = 'USER_COMM'
        I_CALLBACK_TOP_OF_PAGE  = 'TOP'
*       I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*       I_CALLBACK_HTML_END_OF_LIST       = ' '
*       I_STRUCTURE_NAME        =
*       I_BACKGROUND_ID         = ' '
*       I_GRID_TITLE            =
*       I_GRID_SETTINGS         =
        IS_LAYOUT               = LAYOUT
        IT_FIELDCAT             = FIELDCAT
*       IT_EXCLUDING            =
*       IT_SPECIAL_GROUPS       =
*       IT_SORT                 =
*       IT_FILTER               =
*       IS_SEL_HIDE             =
*       I_DEFAULT               = 'X'
        I_SAVE                  = 'A'
*       IS_VARIANT              =
*       IT_EVENTS               =
*       IT_EVENT_EXIT           =
*       IS_PRINT                =
*       IS_REPREP_ID            =
*       I_SCREEN_START_COLUMN   = 0
*       I_SCREEN_START_LINE     = 0
*       I_SCREEN_END_COLUMN     = 0
*       I_SCREEN_END_LINE       = 0
*       I_HTML_HEIGHT_TOP       = 0
*       I_HTML_HEIGHT_END       = 0
*       IT_ALV_GRAPHICS         =
*       IT_HYPERLINK            =
*       IT_ADD_FIELDCAT         =
*       IT_EXCEPT_QINFO         =
*       IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*       E_EXIT_CAUSED_BY_CALLER =
*       ES_EXIT_CAUSED_BY_USER  =
      TABLES
        T_OUTTAB                = IT_TAB2
      EXCEPTIONS
        PROGRAM_ERROR           = 1
        OTHERS                  = 2.
    IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

  ENDIF.

ENDFORM.
