*&---------------------------------------------------------------------*
*& Report ZMB90_LABEL_SF
*& T-CODE  ZLABEL
*& developed by Madhavi Wadekar
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMB90_LABEL_SF.

TABLES : MSEG,
         MKPF,
         QALS,
         MAKT,
         LFA1,
         MCH1,
         MARA,
         EKKO,
         ZMIGO,
         T001W,
         EKPO,
         ZPO_MATNR,
         JEST,
         EKPA,
         PA0002,
         ZPASSW,
         ADRC,
         V_USR_NAME,
         PA0001,
         ZGRN_LABEL,
         ZGRN_LABEL_APR,
         zinsp.

DATA : IT_MSEG       TYPE TABLE OF MSEG,
       WA_MSEG       TYPE MSEG,
       IT_QALS       TYPE TABLE OF QALS,
       WA_QALS       TYPE QALS,
       IT_QALS1      TYPE TABLE OF QALS,
       WA_QALS1      TYPE QALS,
       IT_QALS2      TYPE TABLE OF QALS,
       WA_QALS2      TYPE QALS,
       IT_QALS3      TYPE TABLE OF QALS,
       WA_QALS3      TYPE QALS,
       IT_ZGRN_LABEL TYPE TABLE OF ZGRN_LABEL,
       WA_ZGRN_LABEL TYPE ZGRN_LABEL.


TYPES : BEGIN OF ITAB1,
          MBLNR         TYPE MSEG-MBLNR,
          MJAHR         TYPE MSEG-MJAHR,
          MATNR         TYPE MSEG-MATNR,
          CHARG         TYPE MSEG-CHARG,
          LGORT         TYPE MSEG-LGORT,
          WEANZ         TYPE MSEG-WEANZ,
          VFDAT         TYPE MSEG-VFDAT,
          HSDAT         TYPE MSEG-HSDAT,
          LIFNR         TYPE MSEG-LIFNR,
*          menge       type mseg-menge,
          MENGE(10)     TYPE C,
          MEINS         TYPE MSEG-MEINS,
*          MAKTX       TYPE MAKT-MAKTX,
          MAKTX(100)    TYPE C,
          NAME1         TYPE AD_NAME1,
          ONAME1        TYPE AD_NAME1,
          BUDAT         TYPE MKPF-BUDAT,
          PRUEFLOS      TYPE QALS-PRUEFLOS,
*          LICHA       TYPE MCHA-LICHA,
          LICHA(25)     TYPE C,
          SGTXT         TYPE MSEG-SGTXT,
          ABLAD         TYPE MSEG-ABLAD,
          NORMT         TYPE MARA-NORMT,
          WERKS         TYPE MSEG-WERKS,
          BSART         TYPE EKKO-BSART,
          FORMAT1(100)  TYPE C,
          COUNT(3)      TYPE C,
          LBL(10)       TYPE C,
          QTY           TYPE MSEG-ZEILE,
          WA_LFA1_NAME1 TYPE NAME1_GP,                      "  Changed by Jayesh
          Batchno       TYPE ATWTB,            " Chaged vy Jayesh
        END OF ITAB1.
DATA: WERKS1 TYPE MSEG-WERKS.
DATA: MAKTX1 TYPE MAKT-MAKTX,
      MAKTX2 TYPE MAKT-MAKTX.

TYPES: BEGIN OF ITAB2,
         MBLNR TYPE MSEG-MBLNR,
       END OF ITAB2.

TYPES: BEGIN OF ITAB3,
         MBLNR         TYPE MSEG-MBLNR,
         MATNR         TYPE MSEG-MATNR,
         CHARG         TYPE MSEG-CHARG,
         WEANZ         TYPE MSEG-WEANZ,
         COUNT         TYPE BSEG-BUZEI,
         COUNT1        TYPE BSEG-BUZEI,
********************************************

         MAKTX(100)    TYPE C,
         NORMT         TYPE MARA-NORMT,
         LICHA(25)     TYPE C,
         PRUEFLOS      TYPE QALS-PRUEFLOS,
         SGTXT         TYPE MSEG-SGTXT,
         NAME1         TYPE ADRC-NAME1,
         HSDAT         TYPE MCHA-HSDAT,
         VFDAT         TYPE MCHA-VFDAT,
         MENGE         TYPE MSEG-MENGE,
         MEINS         TYPE MSEG-MEINS,
         ABLAD         TYPE MSEG-ABLAD,
         BUDAT         TYPE MKPF-BUDAT,
         FORMAT1(50)   TYPE C,
         MTART         TYPE MARA-MTART,
         TRF(1)        TYPE C,
         VN_NAME1      TYPE ADRC-NAME1,
         NAME_TEXT     TYPE V_USR_NAME-NAME_TEXT,
         WA_LFA1_NAME1 TYPE NAME1_GP,                   "  Changed by Jayesh
         Batchno       TYPE ATWTB,            " Changed by Jayesh
****************************

       END OF ITAB3.

TYPES: BEGIN OF ITAB4,
         MBLNR TYPE MSEG-MBLNR,
         MJAHR TYPE MSEG-MJAHR,
       END OF ITAB4.

TYPES: BEGIN OF CNT1,
         MBLNR    TYPE MSEG-MBLNR,
         MJAHR    TYPE MSEG-MJAHR,
         COUNT(2) TYPE N,
       END OF CNT1.

DATA : IT_TAB1 TYPE TABLE OF ITAB1,
       WA_TAB1 TYPE ITAB1,
       IT_TAB2 TYPE TABLE OF ITAB2,
       WA_TAB2 TYPE ITAB2,
       IT_TAB3 TYPE TABLE OF ITAB3,
       WA_TAB3 TYPE ITAB3,
       IT_TAB4 TYPE TABLE OF ITAB4,
       WA_TAB4 TYPE ITAB4,
       IT_CNT1 TYPE TABLE OF CNT1,
       WA_CNT1 TYPE CNT1.

DATA: ZGRN_LABEL_WA TYPE ZGRN_LABEL.
DATA: FORMNAME(30) TYPE C.
DATA: CTR TYPE I.

DATA : COUNT TYPE I VALUE 1.
DATA: COUNT1 TYPE I VALUE 1.
DATA : FMNM(15) TYPE C .
DATA: MTART  TYPE MARA-MTART,
      BSART  TYPE EKKO-BSART,
      RWERKS TYPE EKKO-RESWK.
DATA:  FNAME TYPE     RS38L_FNAM.
DATA : CONTROL  TYPE SSFCTRLOP.
DATA:  SSFCOMPOP TYPE SSFCOMPOP.
DATA: SSFCRESOP TYPE SSFCRESOP.
DATA : W_SSFCOMPOP TYPE SSFCOMPOP.
DATA : FORMAT1(100) TYPE C.

DATA : BEGIN OF RITEXT1 OCCURS 0.
         INCLUDE STRUCTURE TLINE.
DATA : END OF RITEXT1.

DATA : LN TYPE I.
DATA : LN1 TYPE I.
DATA : NOLINES TYPE I.
DATA: W_ITEXT3(135) TYPE C,
      R11(1200)     TYPE C,
      R12(1200)     TYPE C.
DATA: RTDNAME1 LIKE STXH-TDNAME.
DATA: N  TYPE I,
      N1 TYPE I.
DATA: QTY TYPE MSEG-ZEILE.
DATA: FORMAT(100) TYPE C.
DATA: LBL(10) TYPE C.
DATA: CNT1 TYPE I,
      CNT2 TYPE I.
DATA: P_MITTEL TYPE MSEG-ZEILE.
DATA:  UNAME(40) TYPE C.
DATA: UDATE TYPE SY-DATUM,
      UTIME TYPE SY-UZEIT.
DATA: O_ENCRYPTOR        TYPE REF TO CL_HARD_WIRED_ENCRYPTOR,
      O_CX_ENCRYPT_ERROR TYPE REF TO CX_ENCRYPT_ERROR.
DATA:
*      v_ac_xstring type xstring,
  V_EN_STRING TYPE STRING,
*      v_en_xstring type xstring,
  V_DE_STRING TYPE STRING,
*      v_de_xstring type string,
  V_ERROR_MSG TYPE STRING.
DATA: G_REPID     LIKE SY-REPID.
DATA: QT1 TYPE I,
      QT2 TYPE I.

DATA : LT_EKPO TYPE EKPO,                                                                              "ADDED BY JAYESH
       LT_LFA1 TYPE LFA1.
DATA :WA_LFA1_NAME1 TYPE LFA1-NAME1,
      LV_MFG        TYPE STRING.
DATA : wa_T001W TYPE T001W-ORT01.


SELECTION-SCREEN BEGIN OF BLOCK MERKMALE3 WITH FRAME TITLE TEXT-002.
*parameters : pernr    type pa0001-pernr,
*             pass(10) type c.
  PARAMETERS : PREVIEW AS CHECKBOX DEFAULT 'X'.
  PARAMETERS : SEL AS CHECKBOX,
               PG1 TYPE I.
SELECTION-SCREEN END OF BLOCK MERKMALE3.

SELECTION-SCREEN BEGIN OF BLOCK MERKMALE1 WITH FRAME TITLE TEXT-001.
  PARAMETERS : LAB1 RADIOBUTTON GROUP R3.
  SELECT-OPTIONS : DOC_NO FOR MSEG-MBLNR .
  SELECT-OPTIONS : STORAGE FOR QALS-LAGORTCHRG.
  PARAMETERS : YEAR LIKE MSEG-MJAHR .
  PARAMETERS : PLANT LIKE MSEG-WERKS .

  PARAMETERS : R1  RADIOBUTTON GROUP R1,
               R1A RADIOBUTTON GROUP R1,
*             r2 radiobutton group r1,
               R3  RADIOBUTTON GROUP R1,
               R4  RADIOBUTTON GROUP R1,
               R5  RADIOBUTTON GROUP R1.

  PARAMETERS : LABEL TYPE I.

  PARAMETERS :
*p1 RADIOBUTTON GROUP r2,
               P2 RADIOBUTTON GROUP R2 DEFAULT 'X'.
  PARAMETERS : PR1 RADIOBUTTON GROUP R2,
               PR2 RADIOBUTTON GROUP R2,
               PR3 RADIOBUTTON GROUP R2.
  PARAMETERS : LAB2 RADIOBUTTON GROUP R3,
               LAB3 RADIOBUTTON GROUP R3.
*PARAMETERS :
SELECTION-SCREEN END OF BLOCK MERKMALE1.




INITIALIZATION.
  G_REPID = SY-REPID.

AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.
    CHECK SCREEN-NAME EQ 'PASS'.
    SCREEN-INVISIBLE = 1.
    MODIFY SCREEN.
  ENDLOOP.

START-OF-SELECTION.

  IF LAB1 EQ 'X'.

    IF DOC_NO IS INITIAL.
      MESSAGE 'ENTER MATERIAL DOCUMENT NO. ' TYPE 'E'.
    ENDIF.
    IF YEAR IS INITIAL.
      MESSAGE 'ENTER YEAR' TYPE 'E'.
    ENDIF.

    IF PLANT IS INITIAL.
      MESSAGE 'ENTER PLANT' TYPE 'E'.
    ENDIF.

    PERFORM PASS.
    CLEAR : UNAME.
*    select single * from pa0002 where pernr eq pernr and endda ge sy-datum.
*    if sy-subrc eq 0.
*      concatenate pa0002-vorna pa0002-nachn into uname separated by space.
*    endif.
    UDATE = SY-DATUM.
    UTIME = SY-UZEIT.

    IF R1 EQ 'X' OR R1A EQ 'X'.
      IF R1A EQ 'X' AND PLANT NE '1001'.
        MESSAGE '301 IS ALLOWED FOR PLANT 1001' TYPE 'E'.

      ENDIF.
      PERFORM FORM1.
*elseif r2 eq 'X'.
*  perform form2.
    ELSEIF R3 EQ 'X'.
      PERFORM FORM3.
    ELSEIF R4 EQ 'X'.
      PERFORM FORM4.
    ELSEIF R5 EQ 'X'.
      PERFORM FORM5.
    ENDIF.

  ELSEIF LAB2 EQ 'X'.
    CALL TRANSACTION 'ZGIL'.
  ELSEIF LAB3 EQ 'X'.
    CALL TRANSACTION 'ZLABEL_REQ'.
  ENDIF.

*&---------------------------------------------------------------------*
*&      Form  FORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM FORM1.
  IF R1 EQ 'X'.

    SELECT * FROM MSEG INTO TABLE IT_MSEG WHERE MBLNR IN DOC_NO AND MJAHR EQ YEAR AND BWART NE '305' AND BWART NE '309' AND WERKS EQ PLANT
      AND XAUTO EQ SPACE AND LGORT IN STORAGE.  "31.5.20
*  and mblnr ge '5000000000' and mblnr le '5999999999' .
    IF SY-SUBRC NE 0.
      EXIT.
    ENDIF.

  ELSEIF R1A EQ 'X'.

    SELECT * FROM MSEG INTO TABLE IT_MSEG WHERE MBLNR IN DOC_NO AND MJAHR EQ YEAR AND BWART NE '305' AND BWART NE '309' AND WERKS EQ PLANT
       AND XAUTO NE SPACE AND LGORT IN STORAGE.  "31.5.20
*  and mblnr ge '5000000000' and mblnr le '5999999999' .
    IF SY-SUBRC NE 0.
      EXIT.
    ENDIF.
  ENDIF.
  LOOP AT IT_MSEG INTO WA_MSEG.
    CLEAR : MTART,BSART,RWERKS,FORMAT1.
    SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_MSEG-MATNR AND MTART IN ('ZROH','ZVRP','ZRQC').
    IF SY-SUBRC EQ 0.
      MTART = MARA-MTART.
      SELECT SINGLE * FROM EKKO WHERE EBELN EQ WA_MSEG-EBELN.
      IF SY-SUBRC EQ 0.
        BSART = EKKO-BSART.
        RWERKS = EKKO-RESWK.
      ENDIF.


*  write : / wa_mseg-mblnr,'material',wa_mseg-bwart,wa_mseg-matnr,'batch',wa_mseg-charg,'no of gr slip',wa_mseg-weanz,'exp. dt',wa_mseg-vfdat,
*            'mfg. dt',wa_mseg-hsdat,'vendor',wa_mseg-lifnr,'qty',wa_mseg-menge,wa_mseg-meins.
      WA_TAB1-MBLNR = WA_MSEG-MBLNR.
      WA_TAB1-MJAHR = WA_MSEG-MJAHR.
      WA_TAB1-MATNR = WA_MSEG-MATNR.
      WA_TAB1-CHARG = WA_MSEG-CHARG.
      WA_TAB1-WERKS = WA_MSEG-WERKS.
      WA_TAB1-LGORT = WA_MSEG-LGORT.  "22.5.22
      WA_TAB1-BSART = BSART.
      IF LABEL NE 0.
        WA_TAB1-WEANZ = LABEL.
      ELSE.
        WA_TAB1-WEANZ = WA_MSEG-WEANZ.
      ENDIF.
      SELECT SINGLE * FROM MCH1 WHERE MATNR EQ WA_MSEG-MATNR AND CHARG EQ WA_MSEG-CHARG.             "werks eq wa_mseg-werks and         commented by jayesh 19-09-2025
      IF SY-SUBRC EQ 0.
        WA_TAB1-VFDAT = MCH1-VFDAT.
        WA_TAB1-HSDAT = MCH1-HSDAT..
      ELSE.
        WA_TAB1-VFDAT = WA_MSEG-VFDAT.
        WA_TAB1-HSDAT = WA_MSEG-HSDAT.
      ENDIF.


      SELECT SINGLE * FROM QALS WHERE CHARG EQ WA_MSEG-CHARG AND BWART EQ '101'.
      IF SY-SUBRC EQ 0.
        SELECT SINGLE * FROM MSEG WHERE MBLNR EQ QALS-MBLNR AND CHARG EQ QALS-CHARG.

        WA_MSEG-EBELN = MSEG-EBELN.                                                                      "Added by Jayesh
        WA_MSEG-EBELP = MSEG-EBELP.
*           AND sgtxt NE '     '.

*        DATA : LT_EKPO TYPE EKPO,                                                                              "ADDED BY JAYESH
*               LT_LFA1 TYPE LFA1.
*        DATA :WA_LFA1_NAME1 TYPE LFA1-NAME1,
*              LV_MFG        TYPE STRING.
*        DATA : wa_T001W TYPE T001W-ORT01.

        SELECT * FROM EKPO INTO LT_EKPO WHERE EBELN = WA_MSEG-EBELN AND EBELP = WA_MSEG-EBELP .                "ADDED BY JAYESH
        ENDSELECT.
        IF LT_EKPO IS NOT INITIAL .
          SELECT SINGLE NAME1 FROM LFA1 INTO WA_LFA1_NAME1 WHERE LIFNR = LT_EKPO-MFRNR.
        ENDIF.

        IF SY-SUBRC EQ 0.
          WA_TAB1-SGTXT = MSEG-SGTXT.
          WA_TAB1-WA_LFA1_NAME1 = WA_LFA1_NAME1.                                                               "ADDED BY JAYESH
          IF MSEG-LIFNR NE '     '.
            WA_TAB1-LIFNR = MSEG-LIFNR.
            SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ MSEG-LIFNR.
            IF SY-SUBRC EQ 0.
*    write : lfa1-name1.
*              WA_LFA1_NAME1 = lfa1-name1.
              WA_TAB1-NAME1 = LFA1-NAME1.
            ENDIF.
          ELSE.
            SELECT SINGLE * FROM MCH1 WHERE MATNR EQ WA_MSEG-MATNR AND CHARG EQ WA_MSEG-CHARG.   "werks eq wa_mseg-werks and         commented by jayesh 19-09-2025
            IF SY-SUBRC EQ 0.
              WA_TAB1-LIFNR = MCH1-LIFNR.
              SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ MCH1-LIFNR.
              IF SY-SUBRC EQ 0.
*    write : lfa1-name1.
                WA_TAB1-NAME1 = LFA1-NAME1.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ELSE.
        SELECT SINGLE * FROM MSEG WHERE MATNR EQ WA_MSEG-MATNR AND CHARG EQ WA_MSEG-CHARG  AND BWART EQ '305'.
        IF SY-SUBRC EQ 0.
          WA_TAB1-SGTXT = MSEG-SGTXT.
          IF MSEG-LIFNR NE '    '.
            WA_TAB1-LIFNR = MSEG-LIFNR.
            SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ MSEG-LIFNR.
            IF SY-SUBRC EQ 0.
*    write : lfa1-name1.
              WA_TAB1-NAME1 = LFA1-NAME1.
            ENDIF.
          ELSE.
            SELECT SINGLE * FROM MCH1 WHERE MATNR EQ WA_MSEG-MATNR AND CHARG EQ WA_MSEG-CHARG.          "werks eq wa_mseg-werks and    commented by jayesh 19-09-2025
            IF SY-SUBRC EQ 0.
              WA_TAB1-LIFNR = MCH1-LIFNR.
              SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ MCH1-LIFNR.
              IF SY-SUBRC EQ 0.
*    write : lfa1-name1.
                WA_TAB1-NAME1 = LFA1-NAME1.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
*      break-point .

*      wa_tab1-lifnr = wa_mseg-lifnr.
*      wa_tab1-sgtxt = wa_mseg-sgtxt.
      WA_TAB1-MENGE = WA_MSEG-MENGE.
      WA_TAB1-MEINS = WA_MSEG-MEINS.
      WA_TAB1-ABLAD = WA_MSEG-ABLAD.
      IF WA_MSEG-MBLNR EQ '4906363076'.  "3.12.20
        IF WA_TAB1-ABLAD EQ SPACE.
          WA_TAB1-ABLAD = WA_MSEG-SGTXT.
        ENDIF.
      ENDIF.
      WA_TAB1-NORMT = MARA-NORMT.
*WRITE : / 'TEST',MARA-NORMT.


*      SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_MSEG-MATNR.
*      IF SY-SUBRC EQ 0.
**    write : makt-maktx.
*        WA_TAB1-MAKTX = MAKT-MAKTX.
*      ENDIF.
      CLEAR : MAKTX1,MAKTX2.
      SELECT SINGLE * FROM MAKT WHERE SPRAS EQ 'EN' AND MATNR EQ WA_MSEG-MATNR.
      IF SY-SUBRC EQ 0.
*    write : makt-maktx.
        MAKTX1 = MAKT-MAKTX.
      ENDIF.
*      BREAK-POINT.
      SELECT SINGLE * FROM MAKT WHERE SPRAS EQ 'Z1' AND MATNR EQ WA_MSEG-MATNR.
      IF SY-SUBRC EQ 0.
*    write : makt-maktx.
        MAKTX2 = MAKT-MAKTX.
      ENDIF.
      CONCATENATE MAKTX1 MAKTX2 INTO WA_TAB1-MAKTX SEPARATED BY SPACE.

*****************  new logic on 4.1.21*******
*      SELECT SINGLE * FROM ekpo WHERE ebeln EQ wa_mseg-ebeln AND ebelp EQ wa_mseg-ebelp.
*      IF sy-subrc EQ 0.
*        SELECT SINGLE * FROM zpo_matnr WHERE matnr EQ wa_mseg-matnr.
*        IF sy-subrc EQ 0.
*          IF ekko-aedat GE zpo_matnr-effectdt.
*            wa_tab1-maktx = ekpo-txz01.
*            wa_tab1-normt = space.
*          ENDIF.
*        ENDIF.
*      ENDIF.
      SELECT SINGLE * FROM EKKO WHERE EBELN EQ WA_MSEG-EBELN.  "18.11.22
      IF SY-SUBRC EQ 0.
        SELECT SINGLE * FROM EKPA WHERE EBELN EQ WA_MSEG-EBELN AND PARVW EQ 'HR'.  "18.11.22
        IF SY-SUBRC EQ 0.
          SELECT SINGLE * FROM ZPO_MATNR WHERE MATNR EQ WA_MSEG-MATNR AND LIFNR EQ EKPA-LIFN2.
          IF SY-SUBRC EQ 0.
            IF EKKO-AEDAT GE ZPO_MATNR-EFFECTDT.
*            WA_TAB1-MAKTX = EKPO-TXZ01.
              WA_TAB1-MAKTX = ZPO_MATNR-MAKTX.
              WA_TAB1-NORMT = SPACE.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.


*      SELECT SINGLE * FROM lfa1 WHERE lifnr EQ wa_mseg-lifnr.
*      IF sy-subrc EQ 0.
**    write : lfa1-name1.
*        wa_tab1-name1 = lfa1-name1.
*      ENDIF.
      SELECT SINGLE * FROM MKPF WHERE MBLNR EQ WA_MSEG-MBLNR AND MJAHR EQ WA_MSEG-MJAHR.
      IF SY-SUBRC EQ 0.
*    write : mkpf-budat.
        WA_TAB1-BUDAT = MKPF-BUDAT.
      ENDIF.
      SELECT SINGLE * FROM QALS WHERE WERK EQ WA_MSEG-WERKS AND CHARG EQ WA_MSEG-CHARG AND MATNR EQ WA_MSEG-MATNR AND MBLNR EQ WA_MSEG-MBLNR
        AND LAGORTCHRG EQ WA_MSEG-LGORT. "storage added on 22.5.22
      IF SY-SUBRC EQ 0.
*    write : qals-prueflos.
        WA_TAB1-PRUEFLOS = QALS-PRUEFLOS.
      ENDIF.
      IF WA_TAB1-PRUEFLOS is INITIAL.    "added by madhuri
     SELECT SINGLE * FROM zinsp WHERE WERKS EQ WA_MSEG-WERKS AND CHARG EQ WA_MSEG-CHARG AND MATNR EQ WA_MSEG-MATNR" AND MBLNR EQ WA_MSEG-MBLNR
        AND LGORT EQ WA_MSEG-LGORT. "sto
     IF  sy-subrc = 0.
      WA_TAB1-PRUEFLOS = zinsp-PRUEFLOS.
     ENDIF.
      ENDIF.
      SELECT SINGLE * FROM MCH1 WHERE CHARG EQ WA_MSEG-CHARG.  "and werks eq wa_mseg-werks.        commented by jayesh 19-09-2025
      IF SY-SUBRC EQ 0.
*      WRITE : mcha-licha.
        WA_TAB1-LICHA = MCH1-LICHA.
      ENDIF.

**************  LONG VENDOR BATCH *********
      CLEAR : RTDNAME1.
      CONCATENATE WA_MSEG-MATNR WA_MSEG-WERKS WA_MSEG-CHARG INTO RTDNAME1.
*            RTDNAME1 = '00000000000010010010000000108421'.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'VERM'
          LANGUAGE                = 'E'
          NAME                    = RTDNAME1
          OBJECT                  = 'CHARGE'
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
*    ************

      DESCRIBE TABLE RITEXT1 LINES LN1.
      NOLINES = 0.
      CLEAR : W_ITEXT3,R11,R12.
      LOOP AT RITEXT1."WHERE tdline NE ' '.
        CONDENSE RITEXT1-TDLINE.
        NOLINES =  NOLINES  + 1.
        IF RITEXT1-TDLINE IS NOT  INITIAL   .
          IF RITEXT1-TDLINE NE '.'.

            IF NOLINES LE  1.
*                  MOVE ITEXT-TDLINE TO T1.
              MOVE RITEXT1-TDLINE TO W_ITEXT3.
              CONCATENATE R11 W_ITEXT3  INTO R11.
*                  SEPARATED BY SPACE.
            ENDIF.

*              move ritext1-tdline to w_itext3.
*              concatenate r3 w_itext3  into r3 separated by space.
          ENDIF.
        ENDIF.
      ENDLOOP.
*            WRITE : LICHA,R11.
      IF WA_TAB1-BUDAT GE '20200910'.
        IF WA_TAB1-LICHA+0(15) = R11+0(15).  "11.9.20  "long vendor batch
          WA_TAB1-LICHA = R11.
        ENDIF.
      ENDIF.
**************************************************************************************************************************
*********************************************
      IF MTART EQ 'ZROH' AND BSART EQ 'ZL'.

        IF WA_TAB1-BUDAT GE '20200727'.
          SELECT SINGLE * FROM ZMIGO WHERE MBLNR EQ WA_MSEG-MBLNR AND ZEILE EQ WA_MSEG-ZEILE.
          IF SY-SUBRC EQ 0.
            SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ ZMIGO-MFGR.
            IF SY-SUBRC EQ 0.
              WA_TAB1-SGTXT = LFA1-NAME1.  "25.4.20
            ENDIF.
*                ELSE.
*                  SGTXT = LFA1-NAME1.  "25.4.20
          ENDIF.
*                IF SGTXT EQ SPACE.  15.7.20
*                  SGTXT = WA_MSEG1-SGTXT. " 3.7.20
*                ENDIF.
        ELSE.
*          SGTXT = WA_tab1-SGTXT.
        ENDIF.
      ELSE.
*        SGTXT = WA_MSEG1-SGTXT.
      ENDIF.

      IF WA_TAB1-BUDAT GE '20200727'.
        IF BSART EQ 'ZUB'.
          SELECT SINGLE * FROM T001W WHERE WERKS EQ RWERKS.
          IF SY-SUBRC EQ 0.
            WA_TAB1-NAME1 = T001W-NAME1.
          ENDIF.

          SELECT SINGLE * FROM MCH1 WHERE MATNR EQ WA_MSEG-MATNR AND CHARG EQ WA_MSEG-CHARG AND LIFNR NE SPACE.
          IF SY-SUBRC EQ 0.
            SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ MCH1-LIFNR.
            IF SY-SUBRC EQ 0.
              WA_TAB1-ONAME1 = LFA1-NAME1.
            ENDIF.
          ENDIF.
***************original supplier**************
          CLEAR : IT_QALS2,WA_QALS2.
          SELECT * FROM QALS INTO TABLE IT_QALS2 WHERE CHARG EQ  WA_MSEG-CHARG AND LIFNR NE SPACE.
          LOOP AT IT_QALS2 INTO WA_QALS2.
            SELECT SINGLE * FROM JEST WHERE OBJNR EQ WA_QALS2-OBJNR AND STAT EQ 'I0224'.
            IF SY-SUBRC EQ 0.
              DELETE IT_QALS2 WHERE PRUEFLOS EQ WA_QALS2-PRUEFLOS.
            ENDIF.
          ENDLOOP.
          READ TABLE IT_QALS2 INTO WA_QALS2 WITH KEY CHARG = WA_MSEG-CHARG.
          IF SY-SUBRC EQ 0.
            SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_QALS2-LIFNR.
            IF SY-SUBRC EQ 0.
              WA_TAB1-ONAME1 = LFA1-NAME1.
            ENDIF.
          ENDIF.
*******************************************************************
        ELSE.
          SELECT SINGLE * FROM MCH1 WHERE MATNR EQ WA_MSEG-MATNR AND CHARG EQ WA_MSEG-CHARG AND LIFNR NE SPACE.
          IF SY-SUBRC EQ 0.
            SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ MCH1-LIFNR.
            IF SY-SUBRC EQ 0.
              WA_TAB1-NAME1 = LFA1-NAME1.
            ENDIF.
          ELSE.
*            wa_tab1-name1 = space.
          ENDIF.

        ENDIF.
      ENDIF.


      IF WA_TAB1-WERKS EQ '1000'.
        WA_TAB1-FORMAT1 = 'SOP/ST/004-F1'.
      ELSEIF WA_TAB1-WERKS EQ '1001' AND WA_TAB1-BUDAT LT '20200806'.
        WA_TAB1-FORMAT1 = 'ST/GM/005-F1'.
      ELSEIF WA_TAB1-WERKS EQ '1001' AND BSART EQ 'ZUB'.
        WA_TAB1-FORMAT1 = 'ST/GM/005-F3'.
      ELSEIF WA_TAB1-WERKS EQ '1001'.
        IF R1A EQ 'X'.
          WA_TAB1-FORMAT1 = 'ST/GM/005-F3'.  "16.6.25
        ELSE.
          WA_TAB1-FORMAT1 = 'ST/GM/005-F1'.
        ENDIF.
      ENDIF.
      WA_TAB1-LBL = LABEL.
      WA_TAB1-QTY = 2.
*      break-point.
      SELECT SINGLE * FROM MCH1 WHERE CHARG EQ WA_MSEG-CHARG AND LIFNR NE SPACE.
      IF SY-SUBRC EQ 0.
        SELECT SINGLE * FROM MSEG WHERE BWART EQ '101' AND MATNR EQ MCH1-MATNR AND CHARG EQ MCH1-CHARG AND LIFNR NE SPACE.
        IF SY-SUBRC EQ 0.
          SELECT SINGLE * FROM ZMIGO WHERE MBLNR EQ MSEG-MBLNR AND ZEILE EQ MSEG-ZEILE.
          IF SY-SUBRC EQ 0.
            SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ ZMIGO-MFGR.
            IF SY-SUBRC EQ 0.
              WA_TAB1-SGTXT = LFA1-NAME1.  "25.4.20
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
*      if wa_tab1-sgtxt eq space and wa_tab1-budat ge '20250601'.
*        wa_tab1-sgtxt = wa_mseg-sgtxt.
*      endif.
*

      COLLECT WA_TAB1 INTO IT_TAB1.
      CLEAR WA_TAB1.
    ENDIF.
  ENDLOOP.

*******************no of labels*********************************************
  IF IT_TAB1 IS NOT INITIAL.
    SELECT * FROM   ZGRN_LABEL INTO TABLE IT_ZGRN_LABEL FOR ALL ENTRIES IN IT_TAB1 WHERE MBLNR EQ IT_TAB1-MBLNR AND MJAHR EQ IT_TAB1-MJAHR.
  ENDIF.
  LOOP AT IT_ZGRN_LABEL INTO WA_ZGRN_LABEL.
    ON CHANGE OF WA_ZGRN_LABEL-MBLNR.
      COUNT1 = 1.
    ENDON.
    WA_CNT1-MBLNR = WA_ZGRN_LABEL-MBLNR.
    WA_CNT1-MJAHR = WA_ZGRN_LABEL-MJAHR.
    WA_CNT1-COUNT = COUNT1.
    COLLECT WA_CNT1 INTO IT_CNT1.
    CLEAR WA_CNT1.
    COUNT1 = COUNT1 + 1.
  ENDLOOP.
*  LOOP AT IT_CNT1 INTO WA_CNT1.
*    WRITE : / WA_CNT1-MBLNR,WA_CNT1-MJAHR,WA_CNT1-COUNT.
*  ENDLOOP.
******************LABEL CONTROL ******************
  PERFORM PRTCONTROL.
  IF SEL EQ 'X'.
    PERFORM SELECPAGE.
  ELSE.
    PERFORM SFFORM.
  ENDIF.


ENDFORM.                                                    "FORM1

*&---------------------------------------------------------------------*
*&      Form  FORM2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM FORM2.


  SELECT * FROM MSEG INTO TABLE IT_MSEG WHERE MBLNR IN DOC_NO AND MJAHR EQ YEAR AND BWART EQ '305' AND WERKS EQ PLANT.
*  and mblnr ge '5000000000' and mblnr le '5999999999' .
  IF SY-SUBRC NE 0.
    EXIT.
  ENDIF.

  LOOP AT IT_MSEG INTO WA_MSEG.
*  write : / wa_mseg-mblnr,'material',wa_mseg-bwart,wa_mseg-matnr,'batch',wa_mseg-charg,'no of gr slip',wa_mseg-weanz,'exp. dt',wa_mseg-vfdat,
*            'mfg. dt',wa_mseg-hsdat,'vendor',wa_mseg-lifnr,'qty',wa_mseg-menge,wa_mseg-meins.
    WA_TAB1-MBLNR = WA_MSEG-MBLNR.
    WA_TAB1-MATNR = WA_MSEG-MATNR.
    WA_TAB1-CHARG = WA_MSEG-CHARG.
    WA_TAB1-WERKS = WA_MSEG-WERKS.
    IF LABEL NE 0.
      WA_TAB1-WEANZ = LABEL.
    ELSE.
      WA_TAB1-WEANZ = WA_MSEG-WEANZ.
    ENDIF.

*  wa_tab1-vfdat = wa_mseg-vfdat.
*  wa_tab1-hsdat = wa_mseg-hsdat.
*  wa_tab1-lifnr = wa_mseg-lifnr.

    SELECT SINGLE * FROM QALS WHERE CHARG EQ WA_MSEG-CHARG AND BWART EQ '101'.
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM MSEG WHERE MBLNR EQ QALS-MBLNR AND CHARG EQ QALS-CHARG AND SGTXT NE '     '.
      IF SY-SUBRC EQ 0.
        WA_TAB1-SGTXT = MSEG-SGTXT.
*        wa_tab1-lifnr = mseg-lifnr.
*        SELECT SINGLE * FROM lfa1 WHERE lifnr EQ mseg-lifnr.
*        IF sy-subrc EQ 0.
**    write : lfa1-name1.
*          wa_tab1-name1 = lfa1-name1.
*        ENDIF.
      ENDIF.
    ELSE.
      SELECT SINGLE * FROM MSEG WHERE MATNR EQ WA_MSEG-MATNR AND CHARG EQ WA_MSEG-CHARG  AND BWART EQ '305'.
      IF SY-SUBRC EQ 0.
        WA_TAB1-SGTXT = MSEG-SGTXT.
*        wa_tab1-lifnr = mseg-lifnr.
*        SELECT SINGLE * FROM lfa1 WHERE lifnr EQ mseg-lifnr.
*        IF sy-subrc EQ 0.
**    write : lfa1-name1.
*          wa_tab1-name1 = lfa1-name1.
*        ENDIF.
      ENDIF.
    ENDIF.

*    wa_tab1-sgtxt = wa_mseg-sgtxt.
    WA_TAB1-MENGE = WA_MSEG-MENGE.
    WA_TAB1-MEINS = WA_MSEG-MEINS.
    WA_TAB1-ABLAD = WA_MSEG-ABLAD.


*    SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_MSEG-MATNR.
*    IF SY-SUBRC EQ 0.
**    write : makt-maktx.
*      WA_TAB1-MAKTX = MAKT-MAKTX.
*    ENDIF.

    CLEAR : MAKTX1,MAKTX2.
    SELECT SINGLE * FROM MAKT WHERE SPRAS EQ 'EN' AND MATNR EQ WA_MSEG-MATNR.
    IF SY-SUBRC EQ 0.
*    write : makt-maktx.
      MAKTX1 = MAKT-MAKTX.
    ENDIF.
    SELECT SINGLE * FROM MAKT WHERE SPRAS EQ 'Z1' AND MATNR EQ WA_MSEG-MATNR.
    IF SY-SUBRC EQ 0.
*    write : makt-maktx.
      MAKTX2 = MAKT-MAKTX.
    ENDIF.
    CONCATENATE MAKTX1 MAKTX2 INTO WA_TAB1-MAKTX SEPARATED BY SPACE.

    SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_MSEG-MATNR.
    IF SY-SUBRC EQ 0.
      WA_TAB1-NORMT = MARA-NORMT.
    ENDIF.

*****************  new logic on 4.1.21*******
*    SELECT SINGLE * FROM EKPO WHERE EBELN EQ WA_MSEG-EBELN AND EBELP EQ WA_MSEG-EBELP.
*    IF SY-SUBRC EQ 0.
*      SELECT SINGLE * FROM ZPO_MATNR WHERE MATNR EQ WA_MSEG-MATNR.
*      IF SY-SUBRC EQ 0.
*        IF EKKO-AEDAT GE ZPO_MATNR-EFFECTDT.
*          WA_TAB1-MAKTX = EKPO-TXZ01.
*          WA_TAB1-NORMT = SPACE.
*        ENDIF.
*      ENDIF.
*    ENDIF.
    SELECT SINGLE * FROM EKKO WHERE EBELN EQ WA_MSEG-EBELN.
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM EKPA WHERE EBELN EQ WA_MSEG-EBELN AND PARVW EQ 'HR'.  "18.11.22
      IF SY-SUBRC EQ 0.
        SELECT SINGLE * FROM ZPO_MATNR WHERE MATNR EQ WA_MSEG-MATNR AND LIFNR EQ EKPA-LIFN2.
        IF SY-SUBRC EQ 0.
          IF EKKO-AEDAT GE ZPO_MATNR-EFFECTDT.
*          WA_TAB1-MAKTX = EKPO-TXZ01.
            WA_TAB1-MAKTX = ZPO_MATNR-MAKTX.
            WA_TAB1-NORMT = SPACE.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

*  select single * from lfa1 where lifnr eq wa_mseg-lifnr.
*  if sy-subrc eq 0.
**    write : lfa1-name1.
*    wa_tab1-name1 = lfa1-name1.
*  endif.
    SELECT SINGLE * FROM MKPF WHERE MBLNR EQ WA_MSEG-MBLNR AND MJAHR EQ WA_MSEG-MJAHR.
    IF SY-SUBRC EQ 0.
*    write : mkpf-budat.
      WA_TAB1-BUDAT = MKPF-BUDAT.
    ENDIF.
    SELECT SINGLE * FROM QALS WHERE CHARG EQ WA_MSEG-CHARG.
    IF SY-SUBRC EQ 0.
*    write : qals-prueflos.
      WA_TAB1-PRUEFLOS = QALS-PRUEFLOS.
    ENDIF.
    IF WA_TAB1-PRUEFLOS is INITIAL.    "added by madhuri
     SELECT SINGLE * from zinsp WHERE CHARG EQ WA_MSEG-CHARG.
       IF SY-SUBRC EQ 0.
      WA_TAB1-PRUEFLOS = zinsp-PRUEFLOS.
    ENDIF.
      ENDIF.

    SELECT SINGLE * FROM MCH1 WHERE CHARG EQ WA_MSEG-CHARG. "and werks eq wa_mseg-werks.  commented by jayesh 19-09-2025
    IF SY-SUBRC EQ 0.
*      WRITE : mcha-licha.
      WA_TAB1-LICHA = MCH1-LICHA.
      WA_TAB1-HSDAT = MCH1-HSDAT.
      WA_TAB1-VFDAT = MCH1-VFDAT.
      WA_TAB1-LIFNR = MCH1-LIFNR.

********************************************************************************
*      **************  LONG VENDOR BATCH *********
      CLEAR : RTDNAME1.
      CONCATENATE WA_MSEG-MATNR WA_MSEG-WERKS WA_MSEG-CHARG INTO RTDNAME1.
*            RTDNAME1 = '00000000000010010010000000108421'.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'VERM'
          LANGUAGE                = 'E'
          NAME                    = RTDNAME1
          OBJECT                  = 'CHARGE'
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
*    ************

      DESCRIBE TABLE RITEXT1 LINES LN1.
      NOLINES = 0.
      CLEAR : W_ITEXT3,R11,R12.
      LOOP AT RITEXT1."WHERE tdline NE ' '.
        CONDENSE RITEXT1-TDLINE.
        NOLINES =  NOLINES  + 1.
        IF RITEXT1-TDLINE IS NOT  INITIAL   .
          IF RITEXT1-TDLINE NE '.'.

            IF NOLINES LE  1.
*                  MOVE ITEXT-TDLINE TO T1.
              MOVE RITEXT1-TDLINE TO W_ITEXT3.
              CONCATENATE R11 W_ITEXT3  INTO R11.
*                  SEPARATED BY SPACE.
            ENDIF.

*              move ritext1-tdline to w_itext3.
*              concatenate r3 w_itext3  into r3 separated by space.
          ENDIF.
        ENDIF.
      ENDLOOP.
*            WRITE : LICHA,R11.
      IF WA_TAB1-BUDAT GE '20200910'.
        IF WA_TAB1-LICHA+0(15) = R11+0(15).  "11.9.20  "long vendor batch
          WA_TAB1-LICHA = R11.
        ENDIF.
      ENDIF.
*************************************************************************************

      SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ MCH1-LIFNR.
      IF SY-SUBRC EQ 0.
*    write : lfa1-name1.
        WA_TAB1-NAME1 = LFA1-NAME1.
      ENDIF.

    ENDIF.


    IF WA_TAB1-WERKS EQ '1000'.
      WA_TAB1-FORMAT1 = 'SOP/ST/004-F1'.
    ELSEIF WA_TAB1-WERKS EQ '1001'.
      WA_TAB1-FORMAT1 = 'ST/GM/005-F1'.
    ENDIF.



    COLLECT WA_TAB1 INTO IT_TAB1.
    CLEAR WA_TAB1.
  ENDLOOP.

*uline.

  CALL FUNCTION 'OPEN_FORM'
    EXPORTING
*     APPLICATION                       = 'TX'
*     ARCHIVE_INDEX                     =
*     ARCHIVE_PARAMS                    =
      DEVICE   = 'PRINTER'
      DIALOG   = 'X'
*     FORM     = 'ZLABEL1'
      LANGUAGE = SY-LANGU
*     OPTIONS  =
*     MAIL_SENDER                       =
*     MAIL_RECIPIENT                    =
*     MAIL_APPL_OBJECT                  =
*     RAW_DATA_INTERFACE                = '*'
*     SPONUMIV =
* IMPORTING
*     LANGUAGE =
*     NEW_ARCHIVE_PARAMS                =
*     RESULT   =
    EXCEPTIONS
      CANCELED = 1
      DEVICE   = 2
*     FORM     = 3
*     OPTIONS  = 4
*     UNCLOSED = 5
*     MAIL_OPTIONS                      = 6
*     ARCHIVE_ERROR                     = 7
*     INVALID_FAX_NUMBER                = 8
*     MORE_PARAMS_NEEDED_IN_BATCH       = 9
*     SPOOL_ERROR                       = 10
*     CODEPAGE = 11
*     OTHERS   = 12
    .
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


  CALL FUNCTION 'START_FORM'
    EXPORTING
*     ARCHIVE_INDEX          =
      FORM        = FMNM
*     LANGUAGE    = ' '
*     STARTPAGE   = ' '
*     PROGRAM     = ' '
*     MAIL_APPL_OBJECT       =
*   IMPORTING
*     LANGUAGE    =
    EXCEPTIONS
*     FORM        = 1
      FORMAT      = 2
      UNENDED     = 3
      UNOPENED    = 4
      UNUSED      = 5
      SPOOL_ERROR = 6
      CODEPAGE    = 7
      OTHERS      = 8.
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.



  LOOP AT IT_TAB1 INTO WA_TAB1.
    IF WA_TAB1-PRUEFLOS NE '000000000000'.

*  call function 'START_FORM'
*   EXPORTING
**     ARCHIVE_INDEX          =
*     FORM                   = 'ZLABEL1'
**     LANGUAGE               = ' '
**     STARTPAGE              = ' '
**     PROGRAM                = ' '
**     MAIL_APPL_OBJECT       =
**   IMPORTING
**     LANGUAGE               =
*   EXCEPTIONS
*     FORM                   = 1
**     FORMAT                 = 2
**     UNENDED                = 3
**     UNOPENED               = 4
**     UNUSED                 = 5
**     SPOOL_ERROR            = 6
**     CODEPAGE               = 7
**     OTHERS                 = 8
*            .
*  if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  endif.


*  WRITE : / .
*   WRITE : /'doc no', wa_tab1-mblnr,wa_tab1-weanz.
      WHILE ( COUNT LE WA_TAB1-WEANZ ).
*  if count le wa_tab1-weanz.

*  write : / 'BLUE CROSS LABS. LTD'.
*  WRITE : / 'Name of Material',wa_tab1-maktx.
*  WRITE : / 'Mfgr. B. No.',wa_tab1-licha, '  ','Insp. Lot',wa_tab1-prueflos.
*  WRITE : / 'Mfg''r'.
*  write : / 'Suppl',wa_tab1-name1.
*  WRITE : / 'Mfg. Dt.',wa_tab1-hsdat, ' ','Exp. Dt.',wa_tab1-vfdat.
*  WRITE : / 'Quantity',wa_tab1-menge,wa_tab1-meins, ' ','Pkd.'.
*  WRITE : / 'Cont.No.',count, 'of',wa_tab1-weanz.
*  WRITE : / 'Date of receipt',wa_tab1-budat.
*  WRITE : / 'I.D. no.',wa_tab1-charg, ' ','Material Code',wa_tab1-matnr.




        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            ELEMENT = 'HEAD'
*           FUNCTION                       = 'SET'
*           TYPE    = 'BODY'
            WINDOW  = 'MAIN'.


        COUNT = COUNT + 1.
* ENDIF.
      ENDWHILE.
      COUNT = 1.


*call function 'END_FORM'
** IMPORTING
**   RESULT                         =
* EXCEPTIONS
*   UNOPENED                       = 1
*   BAD_PAGEFORMAT_FOR_PRINT       = 2
*   SPOOL_ERROR                    = 3
*   CODEPAGE                       = 4
*   OTHERS                         = 5
*          .
*if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*endif.
    ENDIF.
  ENDLOOP.


  CALL FUNCTION 'END_FORM'
* IMPORTING
*   RESULT                         =
    EXCEPTIONS
      UNOPENED                 = 1
      BAD_PAGEFORMAT_FOR_PRINT = 2
      SPOOL_ERROR              = 3
      CODEPAGE                 = 4
      OTHERS                   = 5.
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CALL FUNCTION 'CLOSE_FORM'
* IMPORTING
*   RESULT                         =
*   RDI_RESULT                     =
* TABLES
*   OTFDATA                        =
    EXCEPTIONS
      UNOPENED                 = 1
      BAD_PAGEFORMAT_FOR_PRINT = 2
      SEND_ERROR               = 3
      SPOOL_ERROR              = 4
      CODEPAGE                 = 5
*     OTHERS                   = 6
    .
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.



ENDFORM.                                                    "FORM2

*&---------------------------------------------------------------------*
*&      Form  FORM3
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM FORM3.


  SELECT * FROM MSEG INTO TABLE IT_MSEG WHERE MBLNR IN DOC_NO AND MJAHR EQ YEAR AND BWART EQ '309' AND XAUTO EQ 'X' AND WERKS EQ PLANT.
*  and mblnr ge '5000000000' and mblnr le '5999999999' .
  IF SY-SUBRC NE 0.
    EXIT.
  ENDIF.
  SELECT * FROM QALS INTO TABLE IT_QALS FOR ALL ENTRIES IN IT_MSEG WHERE MATNR = IT_MSEG-MATNR AND
    CHARG = IT_MSEG-CHARG AND ART EQ '08'
     AND MBLNR EQ IT_MSEG-MBLNR.  "ADDED ON 4.6.2019
    SELECT * from zinsp INTO TABLE @DATA(it_zinsp3) FOR ALL ENTRIES IN @it_mseg WHERE MATNR = @IT_MSEG-MATNR AND
                  CHARG = @IT_MSEG-CHARG AND LGORT IN @STORAGE AND WERKS EQ @IT_MSEG-WERKS .   "added by madhuri


*   and lagortchrg in storage.

  SORT IT_QALS DESCENDING.

  LOOP AT IT_MSEG INTO WA_MSEG.
*  write : / wa_mseg-mblnr,'material',wa_mseg-bwart,wa_mseg-matnr,'batch',wa_mseg-charg,'no of gr slip',wa_mseg-weanz,'exp. dt',wa_mseg-vfdat,
*            'mfg. dt',wa_mseg-hsdat,'vendor',wa_mseg-lifnr,'qty',wa_mseg-menge,wa_mseg-meins.
    WA_TAB1-MBLNR = WA_MSEG-MBLNR.
    WA_TAB1-MJAHR = WA_MSEG-MJAHR.
    WA_TAB1-MATNR = WA_MSEG-MATNR.
    WA_TAB1-CHARG = WA_MSEG-CHARG.
    WA_TAB1-WERKS = WA_MSEG-WERKS.
    IF LABEL NE 0.
      WA_TAB1-WEANZ = LABEL.
    ELSE.
      WA_TAB1-WEANZ = WA_MSEG-WEANZ.
    ENDIF.

*  wa_tab1-vfdat = wa_mseg-vfdat.
*  wa_tab1-hsdat = wa_mseg-hsdat.
*  wa_tab1-lifnr = wa_mseg-lifnr.
*   Wa_tab1-SGTXT = wa_mseg-SGTXT.
    WA_TAB1-MENGE = WA_MSEG-MENGE.
    WA_TAB1-MEINS = WA_MSEG-MEINS.
    WA_TAB1-ABLAD = WA_MSEG-ABLAD.
************************manufacturer*******************
    CLEAR : MTART.
    SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_MSEG-MATNR.
    IF SY-SUBRC EQ 0.
      MTART = MARA-MTART.
    ENDIF.
    IF MTART EQ 'ZROH'.
      SELECT SINGLE * FROM MSEG WHERE MATNR EQ WA_MSEG-MATNR AND CHARG EQ WA_MSEG-CHARG AND BWART EQ '101'.
      IF SY-SUBRC EQ 0.
        WERKS1 = MSEG-WERKS.
        SELECT SINGLE * FROM ZMIGO WHERE MBLNR EQ MSEG-MBLNR AND ZEILE EQ MSEG-ZEILE.
        IF SY-SUBRC EQ 0.
          SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ ZMIGO-MFGR.
          IF SY-SUBRC EQ 0.
            WA_TAB1-SGTXT = LFA1-NAME1.  "25.4.20
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
**********************************end of mfgr*******************

    SELECT SINGLE * FROM QALS WHERE CHARG EQ WA_MSEG-CHARG AND BWART EQ '101'.
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM MSEG WHERE MBLNR EQ QALS-MBLNR AND CHARG = QALS-CHARG.

      WA_MSEG-EBELN = MSEG-EBELN.                                                                  "Added by Jayesh
      WA_MSEG-EBELP = MSEG-EBELP.

      SELECT * FROM EKPO INTO LT_EKPO WHERE EBELN = WA_MSEG-EBELN AND EBELP = WA_MSEG-EBELP .      "added by jayesh
      ENDSELECT.
      IF LT_EKPO IS NOT INITIAL .
        SELECT SINGLE NAME1 FROM LFA1 INTO WA_LFA1_NAME1 WHERE LIFNR = LT_EKPO-MFRNR.
      ENDIF.

*           AND sgtxt NE '     '.
      IF SY-SUBRC EQ 0.
        IF WA_TAB1-SGTXT EQ SPACE.
          WA_TAB1-SGTXT = MSEG-SGTXT.
          WA_TAB1-WA_LFA1_NAME1 = WA_LFA1_NAME1.                                                  " added by jayesh
        ENDIF.
        IF MSEG-LIFNR NE '     '.
          WA_TAB1-LIFNR = MSEG-LIFNR.
          SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ MSEG-LIFNR.
          IF SY-SUBRC EQ 0.
*    write : lfa1-name1.
            WA_TAB1-NAME1 = LFA1-NAME1.
          ENDIF.
        ELSE.
          SELECT SINGLE * FROM MCH1 WHERE MATNR EQ WA_MSEG-MATNR AND CHARG EQ WA_MSEG-CHARG.     "and werks eq wa_mseg-werks      commented by jayesh 19-09-2025
          IF SY-SUBRC EQ 0.
            WA_TAB1-LIFNR = MCH1-LIFNR.
            SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ MCH1-LIFNR.
            IF SY-SUBRC EQ 0.
*    write : lfa1-name1.
              WA_TAB1-NAME1 = LFA1-NAME1.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ELSE.
      SELECT SINGLE * FROM MSEG WHERE MATNR EQ WA_MSEG-MATNR AND CHARG EQ WA_MSEG-CHARG  AND BWART EQ '305'.
      IF SY-SUBRC EQ 0.
        IF WA_TAB1-SGTXT EQ SPACE.
          WA_TAB1-SGTXT = MSEG-SGTXT.
        ENDIF.
        IF MSEG-LIFNR NE '    '.
          WA_TAB1-LIFNR = MSEG-LIFNR.
          SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ MSEG-LIFNR.
          IF SY-SUBRC EQ 0.
*    write : lfa1-name1.
            WA_TAB1-NAME1 = LFA1-NAME1.
          ENDIF.
        ELSE.
          SELECT SINGLE * FROM MCH1 WHERE MATNR EQ WA_MSEG-MATNR AND CHARG EQ WA_MSEG-CHARG.     "and werks eq wa_mseg-werks     commented by jayesh 19-09-2025
          IF SY-SUBRC EQ 0.
            WA_TAB1-LIFNR = MCH1-LIFNR.
            SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ MCH1-LIFNR.
            IF SY-SUBRC EQ 0.
*    write : lfa1-name1.
              WA_TAB1-NAME1 = LFA1-NAME1.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
    IF WA_TAB1-SGTXT EQ SPACE.
      WA_TAB1-SGTXT = WA_MSEG-SGTXT.  "8.6.21
    ENDIF.
    IF WA_TAB1-LIFNR EQ SPACE.
      SELECT SINGLE * FROM MSEG WHERE MBLNR EQ WA_MSEG-MBLNR AND MJAHR EQ WA_MSEG-MJAHR AND MATNR EQ WA_MSEG-MATNR AND CHARG EQ WA_MSEG-CHARG AND XAUTO EQ SPACE.
      IF SY-SUBRC EQ 0.
        SELECT SINGLE * FROM T001W WHERE WERKS EQ MSEG-WERKS.
        IF SY-SUBRC EQ 0.
          WA_TAB1-NAME1 = T001W-NAME1.
        ENDIF.
      ENDIF.
*      if werks1 ne plant.
      IF WA_TAB1-NAME1 EQ SPACE.
        SELECT SINGLE * FROM MCH1 WHERE MATNR EQ WA_MSEG-MATNR AND CHARG EQ WA_MSEG-CHARG AND LIFNR NE SPACE.
        IF SY-SUBRC EQ 0.
          SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ MCH1-LIFNR.
          IF SY-SUBRC EQ 0.
            WA_TAB1-NAME1 = LFA1-NAME1.  "ORIGINAL SUPPLIER
          ENDIF.
        ENDIF.
      ENDIF.
      IF WA_TAB1-NAME1 EQ SPACE.
        SELECT SINGLE * FROM MCH1 WHERE CHARG EQ WA_MSEG-CHARG AND LIFNR NE SPACE.
        IF SY-SUBRC EQ 0.
          SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ MCH1-LIFNR.
          IF SY-SUBRC EQ 0.
            WA_TAB1-NAME1 = LFA1-NAME1.  "ORIGINAL SUPPLIER
          ENDIF.
        ENDIF.
      ENDIF.

    ENDIF.
*******************  added on 28.6.22********
    IF WA_TAB1-LIFNR EQ SPACE.
      CLEAR : IT_QALS1,WA_QALS1.
      SELECT * FROM QALS INTO TABLE IT_QALS1 WHERE ART EQ '01' AND CHARG EQ WA_MSEG-CHARG AND LIFNR NE SPACE.
      LOOP AT IT_QALS1 INTO WA_QALS1.
        SELECT SINGLE * FROM JEST WHERE OBJNR EQ WA_QALS1-OBJNR AND STAT EQ 'I0224'.
        IF SY-SUBRC EQ 4.
          SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_QALS1-LIFNR.
          IF SY-SUBRC EQ 0.
            WA_TAB1-NAME1 = LFA1-NAME1.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.

*    SELECT SINGLE * FROM qals WHERE charg EQ wa_mseg-charg AND bwart EQ '101'.
*    IF sy-subrc EQ 0.
*      SELECT SINGLE * FROM mseg WHERE mblnr EQ qals-mblnr AND sgtxt NE '     '.
*      IF sy-subrc EQ 0.
*        wa_tab1-sgtxt = mseg-sgtxt.
*        wa_tab1-lifnr = mseg-lifnr.
*        SELECT SINGLE * FROM lfa1 WHERE lifnr EQ mseg-lifnr.
*        IF sy-subrc EQ 0.
**    write : lfa1-name1.
*          wa_tab1-name1 = lfa1-name1.
*        ENDIF.
*      ENDIF.
*    ELSE.
*      SELECT SINGLE * FROM mseg WHERE matnr EQ wa_mseg-matnr AND charg EQ wa_mseg-charg  AND bwart EQ '305'.
*      IF sy-subrc EQ 0.
*        wa_tab1-sgtxt = mseg-sgtxt.
*        wa_tab1-lifnr = mseg-lifnr.
*        SELECT SINGLE * FROM lfa1 WHERE lifnr EQ mseg-lifnr.
*        IF sy-subrc EQ 0.
**    write : lfa1-name1.
*          wa_tab1-name1 = lfa1-name1.
*        ENDIF.
*      ENDIF.
*    ENDIF.

*    SELECT SINGLE * FROM mseg WHERE mjahr EQ year AND charg EQ wa_mseg-charg AND sgtxt NE ' '.
**  mblnr in doc_no AND
*    IF sy-subrc EQ 0.
*      wa_tab1-sgtxt = mseg-sgtxt.
*    ENDIF.
***    SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_MSEG-MATNR.
***    IF SY-SUBRC EQ 0.
****    write : makt-maktx.
***      WA_TAB1-MAKTX = MAKT-MAKTX.
***    ENDIF.

    CLEAR : MAKTX1,MAKTX2.
    SELECT SINGLE * FROM MAKT WHERE SPRAS EQ 'EN' AND MATNR EQ WA_MSEG-MATNR.
    IF SY-SUBRC EQ 0.
*    write : makt-maktx.
      MAKTX1 = MAKT-MAKTX.
    ENDIF.
    SELECT SINGLE * FROM MAKT WHERE SPRAS EQ 'Z1' AND MATNR EQ WA_MSEG-MATNR.
    IF SY-SUBRC EQ 0.
*    write : makt-maktx.
      MAKTX2 = MAKT-MAKTX.
    ENDIF.
    CONCATENATE MAKTX1 MAKTX2 INTO WA_TAB1-MAKTX SEPARATED BY SPACE.

    SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_MSEG-MATNR.
    IF SY-SUBRC EQ 0.
      WA_TAB1-NORMT = MARA-NORMT.
    ENDIF.


*****************  new logic on 4.1.21*******
*    SELECT SINGLE * FROM EKPO WHERE EBELN EQ WA_MSEG-EBELN AND EBELP EQ WA_MSEG-EBELP.
*    IF SY-SUBRC EQ 0.
*      SELECT SINGLE * FROM ZPO_MATNR WHERE MATNR EQ WA_MSEG-MATNR.
*      IF SY-SUBRC EQ 0.
*        IF EKKO-AEDAT GE ZPO_MATNR-EFFECTDT.
*          WA_TAB1-MAKTX = EKPO-TXZ01.
*          WA_TAB1-NORMT = SPACE.
*        ENDIF.
*      ENDIF.
*    ENDIF.

*    SELECT SINGLE * FROM EKPO WHERE EBELN EQ WA_MSEG-EBELN AND EBELP EQ WA_MSEG-EBELP.
*    IF SY-SUBRC EQ 0.
    SELECT SINGLE * FROM EKKO WHERE EBELN EQ  WA_MSEG-EBELN.
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM EKPA WHERE EBELN EQ WA_MSEG-EBELN AND PARVW EQ 'HR'.  "18.11.22
      IF SY-SUBRC EQ 0.
        SELECT SINGLE * FROM ZPO_MATNR WHERE MATNR EQ WA_MSEG-MATNR AND LIFNR EQ EKPA-LIFN2.
        IF SY-SUBRC EQ 0.
          IF EKKO-AEDAT GE ZPO_MATNR-EFFECTDT.
*          WA_TAB1-MAKTX = EKPO-TXZ01.
            WA_TAB1-MAKTX = ZPO_MATNR-MAKTX.
            WA_TAB1-NORMT = SPACE.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

*  select single * from lfa1 where lifnr eq wa_mseg-lifnr.
*  if sy-subrc eq 0.
**    write : lfa1-name1.
*    wa_tab1-name1 = lfa1-name1.
*  endif.
    SELECT SINGLE * FROM MKPF WHERE MBLNR EQ WA_MSEG-MBLNR AND MJAHR EQ WA_MSEG-MJAHR.
    IF SY-SUBRC EQ 0.
*    write : mkpf-budat.
      WA_TAB1-BUDAT = MKPF-BUDAT.
    ENDIF.
*    select single * from qals where matnr eq wa_mseg-matnr and charg eq wa_mseg-charg and art eq '08'.
*    if sy-subrc eq 0.
**    write : qals-prueflos.
*      wa_tab1-prueflos = qals-prueflos.
*    endif.
    READ TABLE IT_QALS INTO WA_QALS WITH KEY MATNR = WA_MSEG-MATNR CHARG = WA_MSEG-CHARG ART = '08'.
    IF SY-SUBRC EQ 0.
*    write : qals-prueflos.
      WA_TAB1-PRUEFLOS = WA_QALS-PRUEFLOS.
    ENDIF.
    IF WA_TAB1-PRUEFLOS is INITIAL.    "added by madhuri
     REad TABLE it_zinsp3 INTO DATA(wa_zinsp3) with key  MATNR = WA_MSEG-MATNR CHARG = WA_MSEG-CHARG.
     IF  sy-subrc = 0.
      WA_TAB1-PRUEFLOS = wa_zinsp3-PRUEFLOS.
     ENDIF.
      ENDIF.

    SELECT SINGLE * FROM MCH1 WHERE CHARG EQ WA_MSEG-CHARG AND MATNR EQ WA_MSEG-MATNR.     "and werks eq wa_mseg-werks.     "Changed by Jayesh
    IF SY-SUBRC EQ 0.
*      WRITE : mcha-licha.
      WA_TAB1-LICHA = MCH1-LICHA.
      WA_TAB1-HSDAT = MCH1-HSDAT.
      WA_TAB1-VFDAT = MCH1-VFDAT.
*      wa_tab1-lifnr = mcha-lifnr.

*      SELECT SINGLE * FROM lfa1 WHERE lifnr EQ mcha-lifnr.
*      IF sy-subrc EQ 0.
**    write : lfa1-name1.
*        wa_tab1-name1 = lfa1-name1.
*      ENDIF.

************************************************************************************

**************  LONG VENDOR BATCH *********
      CLEAR : RTDNAME1.
      CONCATENATE WA_MSEG-MATNR WA_MSEG-WERKS WA_MSEG-CHARG INTO RTDNAME1.
*            RTDNAME1 = '00000000000010010010000000108421'.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'VERM'
          LANGUAGE                = 'E'
          NAME                    = RTDNAME1
          OBJECT                  = 'CHARGE'
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
*    ************

      DESCRIBE TABLE RITEXT1 LINES LN1.
      NOLINES = 0.
      CLEAR : W_ITEXT3,R11,R12.
      LOOP AT RITEXT1."WHERE tdline NE ' '.
        CONDENSE RITEXT1-TDLINE.
        NOLINES =  NOLINES  + 1.
        IF RITEXT1-TDLINE IS NOT  INITIAL   .
          IF RITEXT1-TDLINE NE '.'.

            IF NOLINES LE  1.
*                  MOVE ITEXT-TDLINE TO T1.
              MOVE RITEXT1-TDLINE TO W_ITEXT3.
              CONCATENATE R11 W_ITEXT3  INTO R11.
*                  SEPARATED BY SPACE.
            ENDIF.

*              move ritext1-tdline to w_itext3.
*              concatenate r3 w_itext3  into r3 separated by space.
          ENDIF.
        ENDIF.
      ENDLOOP.
*            WRITE : LICHA,R11.
      IF WA_TAB1-BUDAT GE '20200910'.
        IF WA_TAB1-LICHA+0(15) = R11+0(15).  "11.9.20  "long vendor batch
          WA_TAB1-LICHA = R11.
        ENDIF.
      ENDIF.
*******************************************************************************************

    ENDIF.

    IF WA_TAB1-WERKS EQ '1000'.
      WA_TAB1-FORMAT1 = 'SOP/ST/004-F1'.
    ELSEIF WA_TAB1-WERKS EQ '1001'.
      WA_TAB1-FORMAT1 = 'ST/GM/005-F1'.
    ENDIF.


    COLLECT WA_TAB1 INTO IT_TAB1.
    CLEAR WA_TAB1.
  ENDLOOP.


  PERFORM PRTCONTROL.
*  PERFORM sfform.
  IF SEL EQ 'X'.
    PERFORM SELECPAGE.
  ELSE.
    PERFORM SFFORM.
  ENDIF.

*uline.

*  call function 'OPEN_FORM'
*    exporting
**     APPLICATION                       = 'TX'
**     ARCHIVE_INDEX                     =
**     ARCHIVE_PARAMS                    =
*      device   = 'PRINTER'
*      dialog   = 'X'
**     FORM     = 'ZLABEL1'
*      language = sy-langu
**     OPTIONS  =
**     MAIL_SENDER                       =
**     MAIL_RECIPIENT                    =
**     MAIL_APPL_OBJECT                  =
**     RAW_DATA_INTERFACE                = '*'
**     SPONUMIV =
** IMPORTING
**     LANGUAGE =
**     NEW_ARCHIVE_PARAMS                =
**     RESULT   =
*    exceptions
*      canceled = 1
*      device   = 2
**     FORM     = 3
**     OPTIONS  = 4
**     UNCLOSED = 5
**     MAIL_OPTIONS                      = 6
**     ARCHIVE_ERROR                     = 7
**     INVALID_FAX_NUMBER                = 8
**     MORE_PARAMS_NEEDED_IN_BATCH       = 9
**     SPOOL_ERROR                       = 10
**     CODEPAGE = 11
**     OTHERS   = 12
*    .
*  if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  endif.
*
*
*  call function 'START_FORM'
*    exporting
**     ARCHIVE_INDEX          =
*      form        = fmnm
**     LANGUAGE    = ' '
**     STARTPAGE   = ' '
**     PROGRAM     = ' '
**     MAIL_APPL_OBJECT       =
**   IMPORTING
**     LANGUAGE    =
*    exceptions
**     FORM        = 1
*      format      = 2
*      unended     = 3
*      unopened    = 4
*      unused      = 5
*      spool_error = 6
*      codepage    = 7
*      others      = 8.
*  if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  endif.
*
*
*
*  loop at it_tab1 into wa_tab1.
*    if wa_tab1-prueflos ne '000000000000'.
*
**  call function 'START_FORM'
**   EXPORTING
***     ARCHIVE_INDEX          =
**     FORM                   = 'ZLABEL1'
***     LANGUAGE               = ' '
***     STARTPAGE              = ' '
***     PROGRAM                = ' '
***     MAIL_APPL_OBJECT       =
***   IMPORTING
***     LANGUAGE               =
**   EXCEPTIONS
**     FORM                   = 1
***     FORMAT                 = 2
***     UNENDED                = 3
***     UNOPENED               = 4
***     UNUSED                 = 5
***     SPOOL_ERROR            = 6
***     CODEPAGE               = 7
***     OTHERS                 = 8
**            .
**  if sy-subrc <> 0.
*** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
***         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
**  endif.
*
*
**  WRITE : / .
**   WRITE : /'doc no', wa_tab1-mblnr,wa_tab1-weanz.
*      while ( count le wa_tab1-weanz ).
**  if count le wa_tab1-weanz.
*
**  write : / 'BLUE CROSS LABS. LTD'.
**  WRITE : / 'Name of Material',wa_tab1-maktx.
**  WRITE : / 'Mfgr. B. No.',wa_tab1-licha, '  ','Insp. Lot',wa_tab1-prueflos.
**  WRITE : / 'Mfg''r'.
**  write : / 'Suppl',wa_tab1-name1.
**  WRITE : / 'Mfg. Dt.',wa_tab1-hsdat, ' ','Exp. Dt.',wa_tab1-vfdat.
**  WRITE : / 'Quantity',wa_tab1-menge,wa_tab1-meins, ' ','Pkd.'.
**  WRITE : / 'Cont.No.',count, 'of',wa_tab1-weanz.
**  WRITE : / 'Date of receipt',wa_tab1-budat.
**  WRITE : / 'I.D. no.',wa_tab1-charg, ' ','Material Code',wa_tab1-matnr.
*
*
**        if werks1 eq plant.
*
*        call function 'WRITE_FORM'
*          exporting
*            element = 'HEAD'
**           FUNCTION                       = 'SET'
**           TYPE    = 'BODY'
*            window  = 'MAIN'.
**        else.
**          call function 'WRITE_FORM'
**            exporting
**              element = 'HEAD1'
***             FUNCTION                       = 'SET'
***             TYPE    = 'BODY'
**              window  = 'MAIN'.
**        endif.
*
*
*        count = count + 1.
** ENDIF.
*      endwhile.
*      count = 1.
*
*
**call function 'END_FORM'
*** IMPORTING
***   RESULT                         =
** EXCEPTIONS
**   UNOPENED                       = 1
**   BAD_PAGEFORMAT_FOR_PRINT       = 2
**   SPOOL_ERROR                    = 3
**   CODEPAGE                       = 4
**   OTHERS                         = 5
**          .
**if sy-subrc <> 0.
*** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
***         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
**endif.
*    endif.
*  endloop.
*
*
*  call function 'END_FORM'
** IMPORTING
**   RESULT                         =
*    exceptions
*      unopened                 = 1
*      bad_pageformat_for_print = 2
*      spool_error              = 3
*      codepage                 = 4
*      others                   = 5.
*  if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  endif.
*
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
**     OTHERS                   = 6
*    .
*  if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  endif.
*


ENDFORM.                                                    "FORM3



*&---------------------------------------------------------------------*
*&      Form  form4
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM FORM4.

  SELECT * FROM MSEG INTO TABLE IT_MSEG WHERE MBLNR IN DOC_NO AND MJAHR EQ YEAR AND BWART EQ '322' AND XAUTO NE 'X' AND WERKS EQ PLANT
    AND LGORT IN STORAGE.
*  and mblnr ge '5000000000' and mblnr le '5999999999' .
  IF SY-SUBRC NE 0.
    EXIT.
  ENDIF.
  SELECT * FROM QALS INTO TABLE IT_QALS FOR ALL ENTRIES IN IT_MSEG WHERE MATNR = IT_MSEG-MATNR AND
    CHARG = IT_MSEG-CHARG AND LAGORTCHRG IN STORAGE AND WERK EQ IT_MSEG-WERKS  AND ART EQ '09'.

     SELECT * from zinsp INTO TABLE @DATA(it_zinsp4) FOR ALL ENTRIES IN @it_mseg WHERE MATNR = @IT_MSEG-MATNR AND
                  CHARG = @IT_MSEG-CHARG AND LGORT IN @STORAGE AND WERKS EQ @IT_MSEG-WERKS .   "added by madhuri

  SORT IT_QALS DESCENDING.
  LOOP AT IT_MSEG INTO WA_MSEG.
    READ TABLE IT_QALS INTO WA_QALS WITH KEY MATNR = WA_MSEG-MATNR CHARG = WA_MSEG-CHARG ART = '09' LAGORTVORG = WA_MSEG-LGORT.
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_MSEG-MATNR AND MTART IN ('ZROH','ZVRP').
      IF SY-SUBRC EQ 0.
*  write : / wa_mseg-mblnr,'material',wa_mseg-bwart,wa_mseg-matnr,'batch',wa_mseg-charg,'no of gr slip',wa_mseg-weanz,'exp. dt',wa_mseg-vfdat,
*            'mfg. dt',wa_mseg-hsdat,'vendor',wa_mseg-lifnr,'qty',wa_mseg-menge,wa_mseg-meins.
        WA_TAB1-MBLNR = WA_MSEG-MBLNR.
        WA_TAB1-MJAHR = WA_MSEG-MJAHR.
        WA_TAB1-MATNR = WA_MSEG-MATNR.
        WA_TAB1-CHARG = WA_MSEG-CHARG.
        WA_TAB1-WERKS = WA_MSEG-WERKS.
        IF LABEL NE 0.
          WA_TAB1-WEANZ = LABEL.
        ELSE.
          WA_TAB1-WEANZ = WA_MSEG-WEANZ.
        ENDIF.


        SELECT SINGLE * FROM MCH1 WHERE MATNR EQ WA_MSEG-MATNR AND CHARG EQ WA_MSEG-CHARG.        "and werks eq wa_mseg-werks        commented by jayesh 19-09-2025
        IF SY-SUBRC EQ 0.
          WA_TAB1-VFDAT = MCH1-VFDAT.
          WA_TAB1-HSDAT = MCH1-HSDAT.
        ELSE.
          WA_TAB1-VFDAT = WA_MSEG-VFDAT.
          WA_TAB1-HSDAT = WA_MSEG-HSDAT.
        ENDIF.


*      wa_tab1-lifnr = wa_mseg-lifnr.
*      wa_tab1-sgtxt = wa_mseg-sgtxt.
*      wa_tab1-menge = wa_mseg-menge.
        WA_TAB1-MEINS = WA_MSEG-MEINS.
        WA_TAB1-ABLAD = WA_MSEG-ABLAD.


***      SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_MSEG-MATNR.
***      IF SY-SUBRC EQ 0.
****    write : makt-maktx.
***        WA_TAB1-MAKTX = MAKT-MAKTX.
***      ENDIF.

        CLEAR : MAKTX1,MAKTX2.
        SELECT SINGLE * FROM MAKT WHERE SPRAS EQ 'EN' AND MATNR EQ WA_MSEG-MATNR.
        IF SY-SUBRC EQ 0.
*    write : makt-maktx.
          MAKTX1 = MAKT-MAKTX.
        ENDIF.
        SELECT SINGLE * FROM MAKT WHERE SPRAS EQ 'Z1' AND MATNR EQ WA_MSEG-MATNR.
        IF SY-SUBRC EQ 0.
*    write : makt-maktx.
          MAKTX2 = MAKT-MAKTX.
        ENDIF.
        CONCATENATE MAKTX1 MAKTX2 INTO WA_TAB1-MAKTX SEPARATED BY SPACE.

        SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_MSEG-MATNR.
        IF SY-SUBRC EQ 0.
          WA_TAB1-NORMT = MARA-NORMT.
        ENDIF.

*****************  new logic on 4.1.21*******
*      SELECT SINGLE * FROM EKPO WHERE EBELN EQ WA_MSEG-EBELN AND EBELP EQ WA_MSEG-EBELP.
*      IF SY-SUBRC EQ 0.
*        SELECT SINGLE * FROM ZPO_MATNR WHERE MATNR EQ WA_MSEG-MATNR.
*        IF SY-SUBRC EQ 0.
*          IF EKKO-AEDAT GE ZPO_MATNR-EFFECTDT.
*            WA_TAB1-MAKTX = EKPO-TXZ01.
*            WA_TAB1-NORMT = SPACE.
*          ENDIF.
*        ENDIF.
*      ENDIF.

        SELECT SINGLE * FROM EKKO WHERE EBELN EQ WA_MSEG-EBELN.
        IF SY-SUBRC EQ 0.
          SELECT SINGLE * FROM EKPA WHERE EBELN EQ WA_MSEG-EBELN AND PARVW EQ 'HR'.  "18.11.22
          IF SY-SUBRC EQ 0.
            SELECT SINGLE * FROM ZPO_MATNR WHERE MATNR EQ WA_MSEG-MATNR AND LIFNR EQ EKPA-LIFN2.
            IF SY-SUBRC EQ 0.
              IF EKKO-AEDAT GE ZPO_MATNR-EFFECTDT.
                WA_TAB1-MAKTX = ZPO_MATNR-MAKTX.
                WA_TAB1-NORMT = SPACE.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

        SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_MSEG-LIFNR.
        IF SY-SUBRC EQ 0.
*    write : lfa1-name1.
          WA_TAB1-NAME1 = LFA1-NAME1.
        ENDIF.
        SELECT SINGLE * FROM MKPF WHERE MBLNR EQ WA_MSEG-MBLNR AND MJAHR EQ WA_MSEG-MJAHR.
        IF SY-SUBRC EQ 0.
*    write : mkpf-budat.
          WA_TAB1-BUDAT = MKPF-BUDAT.
        ENDIF.
*      read table it_qals into wa_qals with key matnr = wa_mseg-matnr charg = wa_mseg-charg art = '09'.
*      if sy-subrc eq 0.
*    write : qals-prueflos.
        WA_TAB1-PRUEFLOS = WA_QALS-PRUEFLOS.
        IF WA_TAB1-PRUEFLOS is INITIAL.    "added by madhuri
     REad TABLE it_zinsp4 INTO DATA(wa_zinsp4) with key  MATNR = WA_MSEG-MATNR CHARG = WA_MSEG-CHARG.
     IF  sy-subrc = 0.
      WA_TAB1-PRUEFLOS = wa_zinsp4-PRUEFLOS.
     ENDIF.
      ENDIF.
        WA_TAB1-MENGE = WA_QALS-LOSMENGE.
*      endif.
        SELECT SINGLE * FROM MCH1 WHERE CHARG EQ WA_MSEG-CHARG. "and werks eq wa_mseg-werks.
        IF SY-SUBRC EQ 0.
*      WRITE : mcha-licha.
          WA_TAB1-LICHA = MCH1-LICHA.
        ENDIF.

****************************************
**************  LONG VENDOR BATCH *********
        CLEAR : RTDNAME1.
        CONCATENATE WA_MSEG-MATNR WA_MSEG-WERKS WA_MSEG-CHARG INTO RTDNAME1.
*            RTDNAME1 = '00000000000010010010000000108421'.

        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'VERM'
            LANGUAGE                = 'E'
            NAME                    = RTDNAME1
            OBJECT                  = 'CHARGE'
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
*    ************

        DESCRIBE TABLE RITEXT1 LINES LN1.
        NOLINES = 0.
        CLEAR : W_ITEXT3,R11,R12.
        LOOP AT RITEXT1."WHERE tdline NE ' '.
          CONDENSE RITEXT1-TDLINE.
          NOLINES =  NOLINES  + 1.
          IF RITEXT1-TDLINE IS NOT  INITIAL   .
            IF RITEXT1-TDLINE NE '.'.

              IF NOLINES LE  1.
*                  MOVE ITEXT-TDLINE TO T1.
                MOVE RITEXT1-TDLINE TO W_ITEXT3.
                CONCATENATE R11 W_ITEXT3  INTO R11.
*                  SEPARATED BY SPACE.
              ENDIF.

*              move ritext1-tdline to w_itext3.
*              concatenate r3 w_itext3  into r3 separated by space.
            ENDIF.
          ENDIF.
        ENDLOOP.
*            WRITE : LICHA,R11.
        IF WA_TAB1-BUDAT GE '20200910'.
          IF WA_TAB1-LICHA+0(15) = R11+0(15).  "11.9.20  "long vendor batch
            WA_TAB1-LICHA = R11.
          ENDIF.
        ENDIF.

*************************************************

        SELECT SINGLE * FROM QALS WHERE CHARG EQ WA_MSEG-CHARG AND BWART EQ '101'.
        IF SY-SUBRC EQ 0.
          SELECT SINGLE * FROM MSEG WHERE MBLNR EQ QALS-MBLNR AND CHARG EQ QALS-CHARG.
*           AND sgtxt NE '     '.
             WA_MSEG-EBELN = MSEG-EBELN.                                                                  "Added by Jayesh
      WA_MSEG-EBELP = MSEG-EBELP.

      SELECT * FROM EKPO INTO LT_EKPO WHERE EBELN = WA_MSEG-EBELN AND EBELP = WA_MSEG-EBELP .      "added by jayesh
      ENDSELECT.
      IF LT_EKPO IS NOT INITIAL .
        SELECT SINGLE NAME1 FROM LFA1 INTO WA_LFA1_NAME1 WHERE LIFNR = LT_EKPO-MFRNR.
      ENDIF.

          IF SY-SUBRC EQ 0.
            WA_TAB1-SGTXT = MSEG-SGTXT.
            WA_TAB1-WA_LFA1_NAME1 = WA_LFA1_NAME1.                                                 "added by Jayesh
            IF MSEG-LIFNR NE '     '.
              WA_TAB1-LIFNR = MSEG-LIFNR.
              SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ MSEG-LIFNR.
              IF SY-SUBRC EQ 0.
*    write : lfa1-name1.
                WA_TAB1-NAME1 = LFA1-NAME1.
              ENDIF.
            ELSE.
              SELECT SINGLE * FROM MCH1 WHERE MATNR EQ WA_MSEG-MATNR AND CHARG EQ WA_MSEG-CHARG.   "and werks eq wa_mseg-werks      commented by jayesh 19-09-2025
              IF SY-SUBRC EQ 0.
                WA_TAB1-LIFNR = MCH1-LIFNR.
                SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ MCH1-LIFNR.
                IF SY-SUBRC EQ 0.
*    write : lfa1-name1.
                  WA_TAB1-NAME1 = LFA1-NAME1.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ELSE.
          SELECT SINGLE * FROM MSEG WHERE MATNR EQ WA_MSEG-MATNR AND CHARG EQ WA_MSEG-CHARG  AND BWART EQ '305'.
          IF SY-SUBRC EQ 0.
            WA_TAB1-SGTXT = MSEG-SGTXT.
            IF MSEG-LIFNR NE '    '.
              WA_TAB1-LIFNR = MSEG-LIFNR.
              SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ MSEG-LIFNR.
              IF SY-SUBRC EQ 0.
*    write : lfa1-name1.
                WA_TAB1-NAME1 = LFA1-NAME1.
              ENDIF.
            ELSE.
              SELECT SINGLE * FROM MCH1 WHERE MATNR EQ WA_MSEG-MATNR AND CHARG EQ WA_MSEG-CHARG.  " and werks eq wa_mseg-werks    commented by jayesh 19-09-2025
              IF SY-SUBRC EQ 0.
                WA_TAB1-LIFNR = MCH1-LIFNR.
                SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ MCH1-LIFNR.
                IF SY-SUBRC EQ 0.
*    write : lfa1-name1.
                  WA_TAB1-NAME1 = LFA1-NAME1.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

*      SELECT SINGLE * FROM qals WHERE charg EQ wa_mseg-charg AND bwart EQ '101'.
*      IF sy-subrc EQ 0.
*        SELECT SINGLE * FROM mseg WHERE mblnr EQ qals-mblnr AND sgtxt NE '     '.
*        IF sy-subrc EQ 0.
*          wa_tab1-sgtxt = mseg-sgtxt.
*          wa_tab1-lifnr = mseg-lifnr.
*          SELECT SINGLE * FROM lfa1 WHERE lifnr EQ mseg-lifnr.
*          IF sy-subrc EQ 0.
**    write : lfa1-name1.
*            wa_tab1-name1 = lfa1-name1.
*          ENDIF.
*        ENDIF.
*      ELSE.
*        SELECT SINGLE * FROM mseg WHERE matnr EQ wa_mseg-matnr AND charg EQ wa_mseg-charg  AND bwart EQ '305'.
*        IF sy-subrc EQ 0.
*          wa_tab1-sgtxt = mseg-sgtxt.
*          wa_tab1-lifnr = mseg-lifnr.
*          SELECT SINGLE * FROM lfa1 WHERE lifnr EQ mseg-lifnr.
*          IF sy-subrc EQ 0.
**    write : lfa1-name1.
*            wa_tab1-name1 = lfa1-name1.
*          ENDIF.
*        ENDIF.
*      ENDIF.

*      SELECT SINGLE * FROM mseg WHERE matnr EQ wa_mseg-matnr AND charg EQ wa_mseg-charg AND werks EQ wa_mseg-werks
*        AND bwart EQ '101'.
*      IF sy-subrc EQ 0.
**      WRITE : mcha-licha.
**        wa_tab1-sgtxt = mseg-sgtxt.
*        wa_tab1-lifnr = mseg-lifnr.
*        SELECT SINGLE * FROM lfa1 WHERE lifnr EQ mseg-lifnr.
*        IF sy-subrc EQ 0.
**    write : lfa1-name1.
*          wa_tab1-name1 = lfa1-name1.
*        ENDIF.
*      ENDIF.

        IF WA_TAB1-WERKS EQ '1000'.
          WA_TAB1-FORMAT1 = 'SOP/ST/004-F1'.
        ELSEIF WA_TAB1-WERKS EQ '1001'.
          WA_TAB1-FORMAT1 = 'ST/GM/005-F1'.
        ENDIF.


        COLLECT WA_TAB1 INTO IT_TAB1.
        CLEAR WA_TAB1.
      ENDIF.
    ENDIF.
  ENDLOOP.

  PERFORM PRTCONTROL.
*  PERFORM sfform.

  IF SEL EQ 'X'.
    PERFORM SELECPAGE.
  ELSE.
    PERFORM SFFORM.
  ENDIF.

**uline.
*
*  call function 'OPEN_FORM'
*    exporting
**     APPLICATION                       = 'TX'
**     ARCHIVE_INDEX                     =
**     ARCHIVE_PARAMS                    =
*      device   = 'PRINTER'
*      dialog   = 'X'
**     FORM     = 'ZLABEL1'
*      language = sy-langu
**     OPTIONS  =
**     MAIL_SENDER                       =
**     MAIL_RECIPIENT                    =
**     MAIL_APPL_OBJECT                  =
**     RAW_DATA_INTERFACE                = '*'
**     SPONUMIV =
** IMPORTING
**     LANGUAGE =
**     NEW_ARCHIVE_PARAMS                =
**     RESULT   =
*    exceptions
*      canceled = 1
*      device   = 2
**     FORM     = 3
**     OPTIONS  = 4
**     UNCLOSED = 5
**     MAIL_OPTIONS                      = 6
**     ARCHIVE_ERROR                     = 7
**     INVALID_FAX_NUMBER                = 8
**     MORE_PARAMS_NEEDED_IN_BATCH       = 9
**     SPOOL_ERROR                       = 10
**     CODEPAGE = 11
**     OTHERS   = 12
*    .
*  if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  endif.
*
*
*  call function 'START_FORM'
*    exporting
**     ARCHIVE_INDEX          =
*      form        = fmnm
**     LANGUAGE    = ' '
**     STARTPAGE   = ' '
**     PROGRAM     = ' '
**     MAIL_APPL_OBJECT       =
**   IMPORTING
**     LANGUAGE    =
*    exceptions
**     FORM        = 1
*      format      = 2
*      unended     = 3
*      unopened    = 4
*      unused      = 5
*      spool_error = 6
*      codepage    = 7
*      others      = 8.
*  if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  endif.
*
*
*
*  loop at it_tab1 into wa_tab1.
*    if wa_tab1-prueflos ne '000000000000'.
*
**  call function 'START_FORM'
**   EXPORTING
***     ARCHIVE_INDEX          =
**     FORM                   = 'ZLABEL1'
***     LANGUAGE               = ' '
***     STARTPAGE              = ' '
***     PROGRAM                = ' '
***     MAIL_APPL_OBJECT       =
***   IMPORTING
***     LANGUAGE               =
**   EXCEPTIONS
**     FORM                   = 1
***     FORMAT                 = 2
***     UNENDED                = 3
***     UNOPENED               = 4
***     UNUSED                 = 5
***     SPOOL_ERROR            = 6
***     CODEPAGE               = 7
***     OTHERS                 = 8
**            .
**  if sy-subrc <> 0.
*** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
***         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
**  endif.
*
*
**  WRITE : / .
**   WRITE : /'doc no', wa_tab1-mblnr,wa_tab1-weanz.
*      while ( count le wa_tab1-weanz ).
**  if count le wa_tab1-weanz.
*
**  write : / 'BLUE CROSS LABS. LTD'.
**  WRITE : / 'Name of Material',wa_tab1-maktx.
**  WRITE : / 'Mfgr. B. No.',wa_tab1-licha, '  ','Insp. Lot',wa_tab1-prueflos.
**  WRITE : / 'Mfg''r'.
**  write : / 'Suppl',wa_tab1-name1.
**  WRITE : / 'Mfg. Dt.',wa_tab1-hsdat, ' ','Exp. Dt.',wa_tab1-vfdat.
**  WRITE : / 'Quantity',wa_tab1-menge,wa_tab1-meins, ' ','Pkd.'.
**  WRITE : / 'Cont.No.',count, 'of',wa_tab1-weanz.
**  WRITE : / 'Date of receipt',wa_tab1-budat.
**  WRITE : / 'I.D. no.',wa_tab1-charg, ' ','Material Code',wa_tab1-matnr.
*
*
*
*
*        call function 'WRITE_FORM'
*          exporting
*            element = 'HEAD'
**           FUNCTION                       = 'SET'
**           TYPE    = 'BODY'
*            window  = 'MAIN'.
*
*
*        count = count + 1.
** ENDIF.
*      endwhile.
*      count = 1.
*
*
**call function 'END_FORM'
*** IMPORTING
***   RESULT                         =
** EXCEPTIONS
**   UNOPENED                       = 1
**   BAD_PAGEFORMAT_FOR_PRINT       = 2
**   SPOOL_ERROR                    = 3
**   CODEPAGE                       = 4
**   OTHERS                         = 5
**          .
**if sy-subrc <> 0.
*** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
***         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
**endif.
*    endif.
*  endloop.
*
*
*  call function 'END_FORM'
** IMPORTING
**   RESULT                         =
*    exceptions
*      unopened                 = 1
*      bad_pageformat_for_print = 2
*      spool_error              = 3
*      codepage                 = 4
*      others                   = 5.
*  if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  endif.
*
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
**     OTHERS                   = 6
*    .
*  if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  endif.

ENDFORM.                                                    "FORM1

*&---------------------------------------------------------------------*
*&      Form  form5
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM FORM5.



  SELECT * FROM MSEG INTO TABLE IT_MSEG WHERE MBLNR IN DOC_NO AND MJAHR EQ YEAR AND BWART EQ '322' AND XAUTO NE 'X' AND WERKS EQ PLANT.
*  and mblnr ge '5000000000' and mblnr le '5999999999' .
  IF SY-SUBRC NE 0.
    EXIT.
  ENDIF.
  SELECT * FROM QALS INTO TABLE IT_QALS FOR ALL ENTRIES IN IT_MSEG WHERE MATNR = IT_MSEG-MATNR AND
    CHARG = IT_MSEG-CHARG AND LAGORTCHRG IN STORAGE AND WERK EQ IT_MSEG-WERKS  AND ART EQ '08'.
     SELECT * from zinsp INTO TABLE @DATA(it_zinsp5) FOR ALL ENTRIES IN @it_mseg WHERE MATNR = @IT_MSEG-MATNR AND
                  CHARG = @IT_MSEG-CHARG AND LGORT IN @STORAGE AND WERKS EQ @IT_MSEG-WERKS .   "added by madhuri
  SORT IT_QALS DESCENDING.
  LOOP AT IT_MSEG INTO WA_MSEG.
    SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_MSEG-MATNR AND MTART IN ('ZROH','ZVRP').
    IF SY-SUBRC EQ 0.
*  write : / wa_mseg-mblnr,'material',wa_mseg-bwart,wa_mseg-matnr,'batch',wa_mseg-charg,'no of gr slip',wa_mseg-weanz,'exp. dt',wa_mseg-vfdat,
*            'mfg. dt',wa_mseg-hsdat,'vendor',wa_mseg-lifnr,'qty',wa_mseg-menge,wa_mseg-meins.
      WA_TAB1-MBLNR = WA_MSEG-MBLNR.
      WA_TAB1-MJAHR = WA_MSEG-MJAHR.
      WA_TAB1-MATNR = WA_MSEG-MATNR.
      WA_TAB1-CHARG = WA_MSEG-CHARG.
      WA_TAB1-WERKS = WA_MSEG-WERKS.
      IF LABEL NE 0.
        WA_TAB1-WEANZ = LABEL.
      ELSE.
        WA_TAB1-WEANZ = WA_MSEG-WEANZ.
      ENDIF.


      SELECT SINGLE * FROM MCH1 WHERE MATNR EQ WA_MSEG-MATNR AND CHARG EQ WA_MSEG-CHARG.  " and werks eq wa_mseg-werks     commented by jayesh 19-09-2025
      IF SY-SUBRC EQ 0.
        WA_TAB1-VFDAT = MCH1-VFDAT.
        WA_TAB1-HSDAT = MCH1-HSDAT.
      ELSE.
        WA_TAB1-VFDAT = WA_MSEG-VFDAT.
        WA_TAB1-HSDAT = WA_MSEG-HSDAT.
      ENDIF.


*      wa_tab1-lifnr = wa_mseg-lifnr.
*      wa_tab1-sgtxt = wa_mseg-sgtxt.
      WA_TAB1-MENGE = WA_MSEG-MENGE.
      WA_TAB1-MEINS = WA_MSEG-MEINS.
      WA_TAB1-ABLAD = WA_MSEG-ABLAD.

      SELECT SINGLE * FROM QALS WHERE CHARG EQ WA_MSEG-CHARG AND BWART EQ '101'.
      IF SY-SUBRC EQ 0.
        SELECT SINGLE * FROM MSEG WHERE MBLNR EQ QALS-MBLNR AND CHARG EQ QALS-CHARG.
*           AND sgtxt NE '     '.

           WA_MSEG-EBELN = MSEG-EBELN.                                                                  "Added by Jayesh
      WA_MSEG-EBELP = MSEG-EBELP.

      SELECT * FROM EKPO INTO LT_EKPO WHERE EBELN = WA_MSEG-EBELN AND EBELP = WA_MSEG-EBELP .      "added by jayesh
      ENDSELECT.
      IF LT_EKPO IS NOT INITIAL .
        SELECT SINGLE NAME1 FROM LFA1 INTO WA_LFA1_NAME1 WHERE LIFNR = LT_EKPO-MFRNR.
      ENDIF.


        IF SY-SUBRC EQ 0.
          WA_TAB1-SGTXT = MSEG-SGTXT.
          WA_TAB1-WA_LFA1_NAME1 = WA_LFA1_NAME1.                                                      "added by Jayesh
*        ENDIF.
          IF WA_MSEG-LIFNR NE '     '.
            WA_TAB1-LIFNR = WA_MSEG-LIFNR.
            SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_MSEG-LIFNR.
            IF SY-SUBRC EQ 0.
*    write : lfa1-name1.
              WA_TAB1-NAME1 = LFA1-NAME1.
            ENDIF.
          ELSE.
            SELECT SINGLE * FROM MCH1 WHERE MATNR EQ WA_MSEG-MATNR AND CHARG EQ WA_MSEG-CHARG.  "and werks eq wa_mseg-werks    commented by jayesh 19-09-2025
            IF SY-SUBRC EQ 0.
              WA_TAB1-LIFNR = MCH1-LIFNR.
              SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ MCH1-LIFNR.
              IF SY-SUBRC EQ 0.
*    write : lfa1-name1.
                WA_TAB1-NAME1 = LFA1-NAME1.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ELSE.
        SELECT SINGLE * FROM MSEG WHERE MATNR EQ WA_MSEG-MATNR AND CHARG EQ WA_MSEG-CHARG  AND BWART EQ '305'.
        IF SY-SUBRC EQ 0.
          WA_TAB1-SGTXT = MSEG-SGTXT.
          IF MSEG-LIFNR NE '    '.
            WA_TAB1-LIFNR = MSEG-LIFNR.
            SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ MSEG-LIFNR.
            IF SY-SUBRC EQ 0.
*    write : lfa1-name1.
              WA_TAB1-NAME1 = LFA1-NAME1.
            ENDIF.
          ELSE.
            SELECT SINGLE * FROM MCH1 WHERE MATNR EQ WA_MSEG-MATNR AND CHARG EQ WA_MSEG-CHARG.    "and werks eq wa_mseg-werks        commented by jayesh 19-09-2025
            IF SY-SUBRC EQ 0.
              WA_TAB1-LIFNR = MCH1-LIFNR.
              SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ MCH1-LIFNR.
              IF SY-SUBRC EQ 0.
*    write : lfa1-name1.
                WA_TAB1-NAME1 = LFA1-NAME1.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.

*      SELECT SINGLE * FROM qals WHERE charg EQ wa_mseg-charg AND bwart EQ '101'.
*      IF sy-subrc EQ 0.
*        SELECT SINGLE * FROM mseg WHERE mblnr EQ qals-mblnr AND sgtxt NE '     '.
*        IF sy-subrc EQ 0.
*          wa_tab1-sgtxt = mseg-sgtxt.
*          wa_tab1-lifnr = mseg-lifnr.
*          SELECT SINGLE * FROM lfa1 WHERE lifnr EQ mseg-lifnr.
*          IF sy-subrc EQ 0.
**    write : lfa1-name1.
*            wa_tab1-name1 = lfa1-name1.
*          ENDIF.
*        ENDIF.
*      ELSE.
*        SELECT SINGLE * FROM mseg WHERE matnr EQ wa_mseg-matnr AND charg EQ wa_mseg-charg  AND bwart EQ '305'.
*        IF sy-subrc EQ 0.
*          wa_tab1-sgtxt = mseg-sgtxt.
*          wa_tab1-lifnr = mseg-lifnr.
*          SELECT SINGLE * FROM lfa1 WHERE lifnr EQ mseg-lifnr.
*          IF sy-subrc EQ 0.
**    write : lfa1-name1.
*            wa_tab1-name1 = lfa1-name1.
*          ENDIF.
*        ENDIF.
*      ENDIF.

*      SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_MSEG-MATNR.
*      IF SY-SUBRC EQ 0.
**    write : makt-maktx.
*        WA_TAB1-MAKTX = MAKT-MAKTX.
*      ENDIF.

      CLEAR : MAKTX1,MAKTX2.
      SELECT SINGLE * FROM MAKT WHERE SPRAS EQ 'EN' AND MATNR EQ WA_MSEG-MATNR.
      IF SY-SUBRC EQ 0.
*    write : makt-maktx.
        MAKTX1 = MAKT-MAKTX.
      ENDIF.
      SELECT SINGLE * FROM MAKT WHERE SPRAS EQ 'Z1' AND MATNR EQ WA_MSEG-MATNR.
      IF SY-SUBRC EQ 0.
*    write : makt-maktx.
        MAKTX2 = MAKT-MAKTX.
      ENDIF.
      CONCATENATE MAKTX1 MAKTX2 INTO WA_TAB1-MAKTX SEPARATED BY SPACE.

      SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_MSEG-MATNR.
      IF SY-SUBRC EQ 0.
        WA_TAB1-NORMT = MARA-NORMT.
      ENDIF.

*****************  new logic on 4.1.21*******
*      SELECT SINGLE * FROM EKPO WHERE EBELN EQ WA_MSEG-EBELN AND EBELP EQ WA_MSEG-EBELP.
*      IF SY-SUBRC EQ 0.
*        SELECT SINGLE * FROM ZPO_MATNR WHERE MATNR EQ WA_MSEG-MATNR.
*        IF SY-SUBRC EQ 0.
*          IF EKKO-AEDAT GE ZPO_MATNR-EFFECTDT.
*            WA_TAB1-MAKTX = EKPO-TXZ01.
*            WA_TAB1-NORMT = SPACE.
*          ENDIF.
*        ENDIF.
*      ENDIF.
      SELECT SINGLE * FROM EKKO WHERE EBELN EQ WA_MSEG-EBELN.
      IF SY-SUBRC EQ 0.
        SELECT SINGLE * FROM EKPA WHERE EBELN EQ WA_MSEG-EBELN AND PARVW EQ 'HR'.  "18.11.22
        IF SY-SUBRC EQ 0.
          SELECT SINGLE * FROM ZPO_MATNR WHERE MATNR EQ WA_MSEG-MATNR AND LIFNR EQ EKPA-LIFN2.
          IF SY-SUBRC EQ 0.
            IF EKKO-AEDAT GE ZPO_MATNR-EFFECTDT.
              WA_TAB1-MAKTX = ZPO_MATNR-MAKTX.
              WA_TAB1-NORMT = SPACE.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.

*      SELECT SINGLE * FROM lfa1 WHERE lifnr EQ wa_mseg-lifnr.
*      IF sy-subrc EQ 0.
**    write : lfa1-name1.
*        wa_tab1-name1 = lfa1-name1.
*      ENDIF.
      SELECT SINGLE * FROM MKPF WHERE MBLNR EQ WA_MSEG-MBLNR AND MJAHR EQ WA_MSEG-MJAHR.
      IF SY-SUBRC EQ 0.
*    write : mkpf-budat.
        WA_TAB1-BUDAT = MKPF-BUDAT.
      ENDIF.
      READ TABLE IT_QALS INTO WA_QALS WITH KEY MATNR = WA_MSEG-MATNR CHARG = WA_MSEG-CHARG ART = '08'.
      IF SY-SUBRC EQ 0.
*    write : qals-prueflos.
        WA_TAB1-PRUEFLOS = WA_QALS-PRUEFLOS.
      ENDIF.

      IF WA_TAB1-PRUEFLOS is INITIAL.    "added by madhuri
     REad TABLE it_zinsp5 INTO DATA(wa_zinsp5) with key  MATNR = WA_MSEG-MATNR CHARG = WA_MSEG-CHARG.
     IF  sy-subrc = 0.
      WA_TAB1-PRUEFLOS = wa_zinsp5-PRUEFLOS.
     ENDIF.
      ENDIF.
      SELECT SINGLE * FROM MCH1 WHERE CHARG EQ WA_MSEG-CHARG. "and werks eq wa_mseg-werks.
      IF SY-SUBRC EQ 0.
*      WRITE : mcha-licha.
        WA_TAB1-LICHA = MCH1-LICHA.
      ENDIF.

***************************************************
*      **************  LONG VENDOR BATCH *********
      CLEAR : RTDNAME1.
      CONCATENATE WA_MSEG-MATNR WA_MSEG-WERKS WA_MSEG-CHARG INTO RTDNAME1.
*            RTDNAME1 = '00000000000010010010000000108421'.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'VERM'
          LANGUAGE                = 'E'
          NAME                    = RTDNAME1
          OBJECT                  = 'CHARGE'
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
*    ************

      DESCRIBE TABLE RITEXT1 LINES LN1.
      NOLINES = 0.
      CLEAR : W_ITEXT3,R11,R12.
      LOOP AT RITEXT1."WHERE tdline NE ' '.
        CONDENSE RITEXT1-TDLINE.
        NOLINES =  NOLINES  + 1.
        IF RITEXT1-TDLINE IS NOT  INITIAL   .
          IF RITEXT1-TDLINE NE '.'.

            IF NOLINES LE  1.
*                  MOVE ITEXT-TDLINE TO T1.
              MOVE RITEXT1-TDLINE TO W_ITEXT3.
              CONCATENATE R11 W_ITEXT3  INTO R11.
*                  SEPARATED BY SPACE.
            ENDIF.

*              move ritext1-tdline to w_itext3.
*              concatenate r3 w_itext3  into r3 separated by space.
          ENDIF.
        ENDIF.
      ENDLOOP.
*            WRITE : LICHA,R11.
      IF WA_TAB1-BUDAT GE '20200910'.
        IF WA_TAB1-LICHA+0(15) = R11+0(15).  "11.9.20  "long vendor batch
          WA_TAB1-LICHA = R11.
        ENDIF.
      ENDIF.

***********************************************************


*      SELECT SINGLE * FROM mseg WHERE matnr EQ wa_mseg-matnr AND charg EQ wa_mseg-charg AND werks EQ wa_mseg-werks
*        AND bwart EQ '101'.
*      IF sy-subrc EQ 0.
**      WRITE : mcha-licha.
*        wa_tab1-sgtxt = mseg-sgtxt.
*        wa_tab1-lifnr = mseg-lifnr.
*        SELECT SINGLE * FROM lfa1 WHERE lifnr EQ mseg-lifnr.
*        IF sy-subrc EQ 0.
**    write : lfa1-name1.
*          wa_tab1-name1 = lfa1-name1.
*        ENDIF.
*      ENDIF.

      IF WA_TAB1-WERKS EQ '1000'.
        WA_TAB1-FORMAT1 = 'SOP/ST/004-F1'.
      ELSEIF WA_TAB1-WERKS EQ '1001'.
        WA_TAB1-FORMAT1 = 'ST/GM/005-F1'.
      ENDIF.


      COLLECT WA_TAB1 INTO IT_TAB1.
      CLEAR WA_TAB1.
    ENDIF.
  ENDLOOP.

  PERFORM PRTCONTROL.
*  PERFORM sfform.

  IF SEL EQ 'X'.
    PERFORM SELECPAGE.
  ELSE.
    PERFORM SFFORM.
  ENDIF.

**uline.
*
*  call function 'OPEN_FORM'
*    exporting
**     APPLICATION                       = 'TX'
**     ARCHIVE_INDEX                     =
**     ARCHIVE_PARAMS                    =
*      device   = 'PRINTER'
*      dialog   = 'X'
**     FORM     = 'ZLABEL1'
*      language = sy-langu
**     OPTIONS  =
**     MAIL_SENDER                       =
**     MAIL_RECIPIENT                    =
**     MAIL_APPL_OBJECT                  =
**     RAW_DATA_INTERFACE                = '*'
**     SPONUMIV =
** IMPORTING
**     LANGUAGE =
**     NEW_ARCHIVE_PARAMS                =
**     RESULT   =
*    exceptions
*      canceled = 1
*      device   = 2
**     FORM     = 3
**     OPTIONS  = 4
**     UNCLOSED = 5
**     MAIL_OPTIONS                      = 6
**     ARCHIVE_ERROR                     = 7
**     INVALID_FAX_NUMBER                = 8
**     MORE_PARAMS_NEEDED_IN_BATCH       = 9
**     SPOOL_ERROR                       = 10
**     CODEPAGE = 11
**     OTHERS   = 12
*    .
*  if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  endif.
*
*
*  call function 'START_FORM'
*    exporting
**     ARCHIVE_INDEX          =
*      form        = fmnm
**     LANGUAGE    = ' '
**     STARTPAGE   = ' '
**     PROGRAM     = ' '
**     MAIL_APPL_OBJECT       =
**   IMPORTING
**     LANGUAGE    =
*    exceptions
**     FORM        = 1
*      format      = 2
*      unended     = 3
*      unopened    = 4
*      unused      = 5
*      spool_error = 6
*      codepage    = 7
*      others      = 8.
*  if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  endif.
*
*
*
*  loop at it_tab1 into wa_tab1.
*    if wa_tab1-prueflos ne '000000000000'.
*
**  call function 'START_FORM'
**   EXPORTING
***     ARCHIVE_INDEX          =
**     FORM                   = 'ZLABEL1'
***     LANGUAGE               = ' '
***     STARTPAGE              = ' '
***     PROGRAM                = ' '
***     MAIL_APPL_OBJECT       =
***   IMPORTING
***     LANGUAGE               =
**   EXCEPTIONS
**     FORM                   = 1
***     FORMAT                 = 2
***     UNENDED                = 3
***     UNOPENED               = 4
***     UNUSED                 = 5
***     SPOOL_ERROR            = 6
***     CODEPAGE               = 7
***     OTHERS                 = 8
**            .
**  if sy-subrc <> 0.
*** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
***         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
**  endif.
*
*
**  WRITE : / .
**   WRITE : /'doc no', wa_tab1-mblnr,wa_tab1-weanz.
*      while ( count le wa_tab1-weanz ).
**  if count le wa_tab1-weanz.
*
**  write : / 'BLUE CROSS LABS. LTD'.
**  WRITE : / 'Name of Material',wa_tab1-maktx.
**  WRITE : / 'Mfgr. B. No.',wa_tab1-licha, '  ','Insp. Lot',wa_tab1-prueflos.
**  WRITE : / 'Mfg''r'.
**  write : / 'Suppl',wa_tab1-name1.
**  WRITE : / 'Mfg. Dt.',wa_tab1-hsdat, ' ','Exp. Dt.',wa_tab1-vfdat.
**  WRITE : / 'Quantity',wa_tab1-menge,wa_tab1-meins, ' ','Pkd.'.
**  WRITE : / 'Cont.No.',count, 'of',wa_tab1-weanz.
**  WRITE : / 'Date of receipt',wa_tab1-budat.
**  WRITE : / 'I.D. no.',wa_tab1-charg, ' ','Material Code',wa_tab1-matnr.
*
*
*
*
*        call function 'WRITE_FORM'
*          exporting
*            element = 'HEAD'
**           FUNCTION                       = 'SET'
**           TYPE    = 'BODY'
*            window  = 'MAIN'.
*
*
*        count = count + 1.
** ENDIF.
*      endwhile.
*      count = 1.
*
*
**call function 'END_FORM'
*** IMPORTING
***   RESULT                         =
** EXCEPTIONS
**   UNOPENED                       = 1
**   BAD_PAGEFORMAT_FOR_PRINT       = 2
**   SPOOL_ERROR                    = 3
**   CODEPAGE                       = 4
**   OTHERS                         = 5
**          .
**if sy-subrc <> 0.
*** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
***         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
**endif.
*    endif.
*  endloop.
*
*
*  call function 'END_FORM'
** IMPORTING
**   RESULT                         =
*    exceptions
*      unopened                 = 1
*      bad_pageformat_for_print = 2
*      spool_error              = 3
*      codepage                 = 4
*      others                   = 5.
*  if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  endif.
*
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
**     OTHERS                   = 6
*    .
*  if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  endif.


ENDFORM.                                                    "form5
*&---------------------------------------------------------------------*
*&      Form  SFFORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SFFORM .
  LOOP AT IT_TAB1 INTO WA_TAB1.
    WA_TAB2-MBLNR = WA_TAB1-MBLNR.
    COLLECT WA_TAB2 INTO IT_TAB2.
    CLEAR WA_TAB2.
  ENDLOOP.
  SORT IT_TAB2 BY MBLNR.
  DELETE ADJACENT DUPLICATES FROM IT_TAB2.

*uline.
*  loop at it_tab2 into wa_tab2.

***  if label is initial.
****      label = wa_tab1-weanz.
***    label = 1..
***  endif.
  IF PR1 EQ 'X'.
*    if label is initial.
*      label = 1.
*    endif.
*    FORMNAME = 'ZGRN_LBL7_1'.
    FORMNAME = 'ZGRN_LBL9_1'.
  ELSEIF PR2 EQ 'X'.
*    if label is initial.
*      label = 2.
*    endif.
*    FORMNAME = 'ZGRN_LBL7_2'.
    FORMNAME = 'ZGRN_LBL9_2'.
*      FORMNAME = 'ZGRN_LBL9_3'.
*    formname = 'ZGRN_LBL6_12'.
  ELSEIF PR3 EQ 'X'.
*    if label is initial.
*      label = 3.
*    endif.
*    FORMNAME = 'ZGRN_LBL7_3'.
    FORMNAME = 'ZGRN_LBL9_3'.
  ELSE.
*    formname = 'ZGRN_LBL7'.
*    FORMNAME = 'ZGRN_LBL7'.
    FORMNAME = 'ZGRN_LBL9'.
  ENDIF.

*   call function 'SSF_FUNCTION_MODULE_NAME'
*    exporting
**     FORMNAME           = 'ZREJ_LBL'
*      formname           = 'ZGRN_LBL5'
**     VARIANT            = ‘ ‘
**     DIRECT_CALL        = ‘ ‘
*    importing
*      fm_name            = fname
*    exceptions
*      no_form            = 1
*      no_function_module = 2
*      others             = 3.
*  control-no_open   = 'X'.
*  control-no_close  = 'X'.
*

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
*     FORMNAME           = 'ZREJ_LBL'
      FORMNAME           = FORMNAME
*     VARIANT            = ‘ ‘
*     DIRECT_CALL        = ‘ ‘
    IMPORTING
      FM_NAME            = FNAME
    EXCEPTIONS
      NO_FORM            = 1
      NO_FUNCTION_MODULE = 2
      OTHERS             = 3.
  CONTROL-NO_OPEN   = 'X'.
  CONTROL-NO_CLOSE  = 'X'.

  IF PREVIEW EQ 'X'.
    SSFCOMPOP-TDNOPRINT = 'X'.
  ELSE.
    SSFCOMPOP-TDNOPRINT = ''.
  ENDIF.
*   CONTROL-preview  = 'X'.



  CALL FUNCTION 'SSF_OPEN'
    EXPORTING
      CONTROL_PARAMETERS = CONTROL
      OUTPUT_OPTIONS     = SSFCOMPOP
    IMPORTING
      JOB_OUTPUT_OPTIONS = SSFCRESOP.

******************************

*CALL FUNCTION 'SSF_OPEN'
** EXPORTING
**   ARCHIVE_PARAMETERS       =
**   USER_SETTINGS            = 'X'
**   MAIL_SENDER              =
**   MAIL_RECIPIENT           =
**   MAIL_APPL_OBJ            =
**   OUTPUT_OPTIONS           =
*   CONTROL_PARAMETERS       =
** IMPORTING
**   JOB_OUTPUT_OPTIONS       =
** EXCEPTIONS
**   FORMATTING_ERROR         = 1
**   INTERNAL_ERROR           = 2
**   SEND_ERROR               = 3
**   USER_CANCELED            = 4
**   OTHERS                   = 5
*          .
*IF SY-SUBRC <> 0.
** Implement suitable error handling here
*ENDIF.

****************************


  LBL = LABEL.
  CONDENSE LBL.
  CLEAR : CNT1,CNT2.
  LOOP AT IT_TAB1 INTO WA_TAB1.
    IF LABEL IS INITIAL.
      CNT1 = CNT1 + WA_TAB1-WEANZ.
    ELSE.
      CNT1 = CNT1 + LABEL.
    ENDIF.
    WA_TAB2-MBLNR = WA_TAB1-MBLNR.
    COLLECT WA_TAB2 INTO IT_TAB2.
    CLEAR WA_TAB2.
  ENDLOOP.
  SORT IT_TAB2 BY  MBLNR.
  DELETE ADJACENT DUPLICATES FROM IT_TAB2 COMPARING MBLNR.
  SORT IT_TAB3 BY  MBLNR MATNR CHARG.
  DELETE ADJACENT DUPLICATES FROM IT_TAB3 COMPARING MBLNR MATNR CHARG.
  CNT2 = LABEL * CNT1.

*  n = label DIV 4.
*  n1 =  label MOD 4 .
  IF PR1 EQ 'X'.
    N = CNT1 DIV 1.
    N1 =  CNT1 MOD 1 .
    IF N1 GT 0.
      N = N + 1.
    ENDIF.
  ELSEIF PR2 EQ 'X'.
    N = CNT1 DIV 2.
    N1 =  CNT1 MOD 2.
    IF N1 GT 0.
      N = N + 1.
    ENDIF.
  ELSE.
    N = CNT1 DIV 4.
    N1 =  CNT1 MOD 4 .
    IF N1 GT 0.
      N = N + 1.
    ENDIF.
  ENDIF.
  QTY = 0.

*  break-point.

*  LOOP AT it_tab1 INTO wa_tab1.
  CLEAR : COUNT,COUNT1.
  COUNT = 1.
  COUNT1 = 1.
*  LOOP AT it_tab2 INTO wa_tab2.

  IF IT_TAB1 IS NOT INITIAL.
    SELECT * FROM QALS INTO TABLE IT_QALS3 FOR ALL ENTRIES IN IT_TAB1 WHERE CHARG EQ IT_TAB1-CHARG AND LIFNR NE SPACE.
  ENDIF.
  LOOP AT IT_QALS3 INTO WA_QALS3.
    SELECT SINGLE * FROM JEST WHERE OBJNR EQ WA_QALS3-OBJNR AND STAT EQ 'I0224'.
    IF SY-SUBRC EQ 0.
      DELETE IT_QALS3 WHERE PRUEFLOS EQ WA_QALS3-PRUEFLOS.
    ENDIF.
  ENDLOOP.
  SORT IT_QALS3.

  LOOP AT IT_TAB1 INTO WA_TAB1.
*       WHERE mblnr EQ wa_tab2-mblnr.
    DO WA_TAB1-WEANZ TIMES.
      ON CHANGE OF WA_TAB1-MBLNR.
        COUNT1 = 1.
      ENDON.
      ON CHANGE OF WA_TAB1-MATNR.
        COUNT1 = 1.
      ENDON.
      ON CHANGE OF WA_TAB1-CHARG.  "afdded on 16.10.23
        COUNT1 = 1.
      ENDON.
      WA_TAB3-MBLNR = WA_TAB1-MBLNR.
*********************************************
      SELECT SINGLE * FROM MSEG WHERE MBLNR EQ WA_TAB1-MBLNR AND EBELN GT 0.
      IF SY-SUBRC EQ 0.
        SELECT SINGLE * FROM EKKO WHERE EBELN EQ MSEG-EBELN AND RESWK GT 0.
        IF SY-SUBRC EQ 0.
          WA_TAB3-TRF = 'Y'.
          READ TABLE IT_QALS3 INTO WA_QALS3 WITH KEY CHARG  = WA_TAB1-CHARG.
          IF SY-SUBRC EQ 0.
            SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_QALS3-LIFNR.
            IF SY-SUBRC EQ 0.
              SELECT SINGLE * FROM ADRC WHERE ADDRNUMBER EQ LFA1-ADRNR.
              IF SY-SUBRC EQ 0.
                WA_TAB3-VN_NAME1 = ADRC-NAME1.
              ENDIF.
            ENDIF.
          ENDIF.
          IF WA_TAB3-VN_NAME1 EQ SPACE.
            SELECT SINGLE * FROM MCH1 WHERE CHARG EQ WA_TAB1-CHARG AND LIFNR GT 0.
            IF SY-SUBRC EQ 0.
              SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ MCH1-LIFNR.
              IF SY-SUBRC EQ 0.
                SELECT SINGLE * FROM ADRC WHERE ADDRNUMBER EQ LFA1-ADRNR.
                IF SY-SUBRC EQ 0.
                  WA_TAB3-VN_NAME1 = ADRC-NAME1.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.



*            read table it_qals3 into wa_qals3 with key charg  = wa_tab1-charg.
*            if sy-subrc eq 0.
*              select single * from lfa1 where lifnr eq wa_qals3-lifnr.
*              if sy-subrc eq 0.
*                select single * from adrc where addrnumber eq lfa1-adrnr.
*                if sy-subrc eq 0.
*                  wa_tab3-vn_name1 = adrc-name1.
*                endif.
*              endif.
*            endif.
*            if wa_tab3-vn_name1 eq space.
*              select single * from mcha where charg eq wa_tab1-charg and lifnr gt 0.
*              if sy-subrc eq 0.
*                select single * from lfa1 where lifnr eq mcha-lifnr.
*                if sy-subrc eq 0.
*                  select single * from adrc where addrnumber eq lfa1-adrnr.
*                  if sy-subrc eq 0.
*                    wa_tab3-vn_name1 = adrc-name1.
*                  endif.
*                endif.
*              endif.
*            endif.
*          endif.
*        endif.
*      endif.
*************************************
      WA_TAB3-MATNR = WA_TAB1-MATNR.
      WA_TAB3-CHARG = WA_TAB1-CHARG.
      WA_TAB3-WEANZ = WA_TAB1-WEANZ.
      WA_TAB3-MAKTX = WA_TAB1-MAKTX.
      WA_TAB3-NORMT = WA_TAB1-NORMT.
      WA_TAB3-LICHA = WA_TAB1-LICHA.
      WA_TAB3-PRUEFLOS = WA_TAB1-PRUEFLOS.
      WA_TAB3-SGTXT = WA_TAB1-SGTXT.
      WA_TAB3-NAME1 = WA_TAB1-NAME1.
      WA_TAB3-HSDAT = WA_TAB1-HSDAT.
      WA_TAB3-VFDAT = WA_TAB1-VFDAT.
      WA_TAB3-MENGE = WA_TAB1-MENGE.
      WA_TAB3-MEINS = WA_TAB1-MEINS.
      WA_TAB3-ABLAD = WA_TAB1-ABLAD.
      WA_TAB3-BUDAT = WA_TAB1-BUDAT.
      WA_TAB3-WA_LFA1_NAME1 = WA_TAB1-WA_LFA1_NAME1.
      WA_TAB3-FORMAT1 = WA_TAB1-FORMAT1.
      SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_TAB1-MATNR.
      IF SY-SUBRC EQ 0.
        WA_TAB3-MTART = MARA-MTART.
      ENDIF.

*********************

*      *********************************************
      IF R1A EQ 'X' AND WA_TAB3-ABLAD EQ SPACE.
        SELECT SINGLE * FROM MKPF WHERE MBLNR EQ WA_TAB3-MBLNR.
        IF SY-SUBRC EQ 0.
          WA_TAB3-ABLAD = MKPF-XBLNR.
        ENDIF.
      ENDIF.
      IF WA_TAB3-TRF EQ SPACE AND R1A EQ 'X'. "16.6.25
*        select single * from mseg where mblnr eq wa_tab1-mblnr .
*          and ebeln gt 0.
*        if sy-subrc eq 0.
*          select single * from ekko where ebeln eq mseg-ebeln and reswk gt 0.
*          if sy-subrc eq 0.
        WA_TAB3-TRF = 'Y'.
        IF WA_TAB3-VN_NAME1 EQ SPACE.
          SELECT SINGLE * FROM MCH1 WHERE CHARG EQ WA_TAB1-CHARG AND LIFNR GT 0.
          IF SY-SUBRC EQ 0.
            SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ MCH1-LIFNR.
            IF SY-SUBRC EQ 0.
              WA_TAB3-VN_NAME1 = LFA1-NAME1.
            ENDIF.
          ENDIF.
        ENDIF.
*        wa_tab3-vn_name1 = wa_tab1-sgtxt.
        WA_TAB3-NAME1 = 'BLUE CROSS LABS PVT LTD.-GOA2'.
*        concatenate wa_tab1-sgtxt 'TO BLUE CROSS LABS PVT LTD-GOA2' into wa_tab3-vn_name1 .

      ENDIF.
************************grn done by name*****************

      IF R4 EQ 'X' OR R5 EQ 'X'.
*        select single * from pa0001 where pernr eq pernr and endda ge sy-datum.
*        if sy-subrc eq 0.
*          wa_tab3-name_text = pa0001-ename.
*        endif.
      ELSE.
        SELECT SINGLE * FROM MKPF WHERE MBLNR EQ WA_TAB1-MBLNR AND MJAHR EQ WA_TAB1-MJAHR.
        IF SY-SUBRC EQ 0.
          SELECT SINGLE * FROM V_USR_NAME WHERE BNAME EQ MKPF-USNAM.
          IF SY-SUBRC EQ 0.
            WA_TAB3-NAME_TEXT = V_USR_NAME-NAME_TEXT.
          ENDIF.
        ENDIF.
      ENDIF.
********************************************
*      if label is initial.
*        wa_tab3-lbl = wa_tab1-weanz.
*      else.
*        wa_tab3-lbl = label.
*      endif.


      DATA : BATCH_DETAILS    TYPE TABLE OF CLBATCH,
             WA_BATCH_DETAILS TYPE CLBATCH,
             Batchno          TYPE ATWTB.

      CALL FUNCTION 'VB_BATCH_GET_DETAIL'
        EXPORTING
          MATNR              = WA_TAB1-MATNR
          CHARG              = WA_TAB1-CHARG
          WERKS              = WA_TAB1-WERKS
          GET_CLASSIFICATION = 'X'
*         EXISTENCE_CHECK    =
*         READ_FROM_BUFFER   =
*         NO_CLASS_INIT      = ' '
*         LOCK_BATCH         = ' '
* IMPORTING
*         YMCHA              =
*         CLASSNAME          =
*         BATCH_DEL_FLG      =
        TABLES
          CHAR_OF_BATCH      = BATCH_DETAILS
* EXCEPTIONS
*         NO_MATERIAL        = 1
*         NO_BATCH           = 2
*         NO_PLANT           = 3
*         MATERIAL_NOT_FOUND = 4
*         PLANT_NOT_FOUND    = 5
*         NO_AUTHORITY       = 6
*         BATCH_NOT_EXIST    = 7
*         LOCK_ON_BATCH      = 8
*         OTHERS             = 9
        .
      IF SY-SUBRC <> 0.
* Implement suitable error handling here
      ENDIF.

      READ TABLE BATCH_DETAILS INTO WA_BATCH_DETAILS WITH KEY ATNAM = 'ZVENDOR_BATCH'.
      IF SY-SUBRC = 0 .
        WA_TAB3-BATCHNO  = WA_BATCH_DETAILS-ATWTB.
**       wa_tab5-PRUEFLOS = wa_inspe-QPLOS.
*        wa_tab5-PRUEFLOS = WA_QALS-QPLOS.
      ENDIF.

*      COLLECT WA_TAB3 INTO IT_TAB3.
*      CLEAR WA_TAB3.



      WA_TAB3-COUNT = COUNT.
      WA_TAB3-COUNT1  = COUNT1.
      COLLECT WA_TAB3 INTO IT_TAB3.
      CLEAR WA_TAB3.
      COUNT = COUNT + 1.
      COUNT1 = COUNT1 + 1.
    ENDDO.
  ENDLOOP.
*  break-point.
  DO  N TIMES.

    IF IT_TAB3 IS NOT INITIAL.

*    format = 'SOP/QC/008-F3'.
*    loop at it_tab1 into wa_tab1.

*CALL FUNCTION fname
*  EXPORTING
**   ARCHIVE_INDEX              =
**   ARCHIVE_INDEX_TAB          =
**   ARCHIVE_PARAMETERS         =
*   CONTROL_PARAMETERS         = control
**   MAIL_APPL_OBJ              =
**   MAIL_RECIPIENT             =
**   MAIL_SENDER                =
*   OUTPUT_OPTIONS             = ssfcompop
*   USER_SETTINGS              = 'X'
*    P_MITTEL                   = qty
*    LBL                        = label
*    UNAME                      = uname
*    UDATE                      = udate
*    UTIME                      = utime
*    WA_LFA1_NAME1              = WA_LFA1_NAME1
** IMPORTING
**   DOCUMENT_OUTPUT_INFO       =
**   JOB_OUTPUT_INFO            =
**   JOB_OUTPUT_OPTIONS         =
*  TABLES
*    IT_TAB1                    = it_tab3
* EXCEPTIONS
*   FORMATTING_ERROR           = 1
*   INTERNAL_ERROR             = 2
*   SEND_ERROR                 = 3
*   USER_CANCELED              = 4
*   OTHERS                     = 5
*          .
*IF SY-SUBRC <> 0.
** Implement suitable error handling here
*ENDIF.









      CALL FUNCTION FNAME
        EXPORTING
          CONTROL_PARAMETERS = CONTROL
          USER_SETTINGS      = 'X'
*         OUTPUT_OPTIONS     = W_SSFCOMPOP
          OUTPUT_OPTIONS     = SSFCOMPOP
          LBL                = LABEL
          P_MITTEL           = QTY
          N                  = N
          UNAME              = UNAME
          UDATE              = UDATE
          UTIME              = UTIME
        TABLES
          IT_TAB1            = IT_TAB3
        EXCEPTIONS
          FORMATTING_ERROR   = 1
          INTERNAL_ERROR     = 2
          SEND_ERROR         = 3
          USER_CANCELED      = 4
          OTHERS             = 5.
*      enddo .
      IF PR1 EQ 'X'.
        QTY = QTY + 1.
      ELSEIF PR2 EQ 'X'.
        QTY = QTY + 2.
      ELSEIF PR3 EQ 'X'.
        QTY = QTY + 3.
      ELSE.
        QTY = QTY + 4.
      ENDIF.
*    endloop.
*    break-point.
    ENDIF.
  ENDDO.
  LBL = LBL + LBL.
  QTY = 0.
*  ENDLOOP.

  LOOP AT IT_TAB1 INTO WA_TAB1.
    WA_TAB4-MBLNR = WA_TAB1-MBLNR.
    WA_TAB4-MJAHR = WA_TAB1-MJAHR.
    COLLECT WA_TAB4 INTO IT_TAB4.
    CLEAR WA_TAB4.
  ENDLOOP.
  SORT IT_TAB4 BY MBLNR MJAHR.
  DELETE ADJACENT DUPLICATES FROM IT_TAB4 COMPARING MBLNR MJAHR.

  IF SSFCRESOP-TDPREVIEW EQ SPACE.
    WRITE : / 'LABELS ARE PRINTED' .
    LOOP AT IT_TAB4 INTO WA_TAB4.
*      SELECT SINGLE * FROM  ZGRN_LABEL WHERE MBLNR EQ WA_TAB4-MBLNR AND MJAHR EQ WA_TAB4-MJAHR.
*      IF SY-SUBRC EQ 4.
      ZGRN_LABEL_WA-MBLNR = WA_TAB4-MBLNR.
      ZGRN_LABEL_WA-MJAHR = WA_TAB4-MJAHR.
*      zgrn_label_wa-pernr = pernr.
      ZGRN_LABEL_WA-UDATE = SY-DATUM.
      ZGRN_LABEL_WA-UTIME = SY-UZEIT.
      MODIFY ZGRN_LABEL FROM ZGRN_LABEL_WA.
      CLEAR ZGRN_LABEL_WA.
*      ENDIF.
    ENDLOOP.
*******************HOD LABELS**************



  ENDIF.

  CLEAR : IT_TAB3,WA_TAB3,IT_TAB1,WA_TAB1,IT_TAB2,WA_TAB2.
  CLEAR : LBL,QTY,CNT1,CNT2,N1,N.

  IF SSFCRESOP-TDPREVIEW EQ SPACE.
    WRITE : / 'LABELS ARE PRINTED' .
*    ZGRN_LABEL-MBLNR =
  ENDIF.
*  endloop.

  CALL FUNCTION 'SSF_CLOSE'.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PASS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM PASS .
*  select single * from zpassw where pernr = pernr.
*  if sy-subrc eq 0.
*
*    if sy-uname ne zpassw-uname.
*      message 'INVALID LOGIN ID' type 'E'.
*    endif.
*    v_en_string = zpassw-password.
*&———————————————————————** Decryption – String to String*&———————————————————————*
*    try.
*        create object o_encryptor.
*        call method o_encryptor->decrypt_string2string
*          exporting
*            the_string = v_en_string
*          receiving
*            result     = v_de_string.
*      catch cx_encrypt_error into o_cx_encrypt_error.
*        call method o_cx_encrypt_error->if_message~get_text
*          receiving
*            result = v_error_msg.
*        message v_error_msg type 'E'.
*    endtry.
*    if v_de_string eq pass.
**      message 'CORRECT PASSWORD' type 'I'.
*    else.
*      message 'INCORRECT PASSWORD' type 'E'.
*    endif.
*  else.
*    message 'NOT VALID USER' type 'E'.
*    exit.
*  endif.
*  clear : pass.
*  pass = '   '.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PRTCONTROL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM PRTCONTROL .
  LOOP AT IT_TAB1 INTO WA_TAB1.
    CLEAR : CTR.
    SELECT SINGLE * FROM ZGRN_LABEL WHERE MBLNR EQ WA_TAB1-MBLNR AND MJAHR EQ WA_TAB1-MJAHR.
    IF SY-SUBRC EQ 0.
      CTR = 1.
      READ TABLE IT_CNT1 INTO WA_CNT1 WITH KEY MBLNR = WA_TAB1-MBLNR MJAHR = WA_TAB1-MJAHR COUNT = 2.
      IF SY-SUBRC EQ 4.
        SELECT SINGLE * FROM ZGRN_LABEL_APR WHERE MBLNR EQ WA_TAB1-MBLNR AND MJAHR EQ WA_TAB1-MJAHR AND APPR_BY GT 0.
        IF SY-SUBRC EQ 0.
          CTR = 0.
        ENDIF.
      ENDIF.
      READ TABLE IT_CNT1 INTO WA_CNT1 WITH KEY MBLNR = WA_TAB1-MBLNR MJAHR = WA_TAB1-MJAHR COUNT = 3.
      IF SY-SUBRC EQ 4.
        SELECT SINGLE * FROM ZGRN_LABEL_APR WHERE MBLNR EQ WA_TAB1-MBLNR AND MJAHR EQ WA_TAB1-MJAHR AND QAAPPR GT 0.
        IF SY-SUBRC EQ 0.
          CTR = 0.
        ENDIF.
      ENDIF.
    ENDIF.
    IF CTR EQ 1.
      IF PREVIEW EQ 'X'.
        MESSAGE 'LABELS ARE ALREDAY PRINTED' TYPE 'I'.
      ELSE.
        MESSAGE 'LABELS ARE ALREDAY PRINTED' TYPE 'E'.
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SELECPAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SELECPAGE .
  LOOP AT IT_TAB1 INTO WA_TAB1.
    WA_TAB2-MBLNR = WA_TAB1-MBLNR.
    COLLECT WA_TAB2 INTO IT_TAB2.
    CLEAR WA_TAB2.
  ENDLOOP.
  SORT IT_TAB2 BY MBLNR.
  DELETE ADJACENT DUPLICATES FROM IT_TAB2.

*uline.
*  loop at it_tab2 into wa_tab2.

***  if label is initial.
****      label = wa_tab1-weanz.
***    label = 1..
***  endif.
  IF PR1 EQ 'X'.
*    if label is initial.
*      label = 1.
*    endif.
*    FORMNAME = 'ZGRN_LBL7_1'.
    FORMNAME = 'ZGRN_LBL9_1'.
  ELSEIF PR2 EQ 'X'.
*    if label is initial.
*      label = 2.
*    endif.
*    FORMNAME = 'ZGRN_LBL7_2'.
    FORMNAME = 'ZGRN_LBL9_2'.
*      FORMNAME = 'ZGRN_LBL9_3'.
*    formname = 'ZGRN_LBL6_12'.
  ELSEIF PR3 EQ 'X'.
*    if label is initial.
*      label = 3.
*    endif.
*    FORMNAME = 'ZGRN_LBL7_3'.
    FORMNAME = 'ZGRN_LBL9_3'.
  ELSE.
*    formname = 'ZGRN_LBL7'.
*    FORMNAME = 'ZGRN_LBL7'.
    FORMNAME = 'ZGRN_LBL9'.
  ENDIF.

*   call function 'SSF_FUNCTION_MODULE_NAME'
*    exporting
**     FORMNAME           = 'ZREJ_LBL'
*      formname           = 'ZGRN_LBL5'
**     VARIANT            = ‘ ‘
**     DIRECT_CALL        = ‘ ‘
*    importing
*      fm_name            = fname
*    exceptions
*      no_form            = 1
*      no_function_module = 2
*      others             = 3.
*  control-no_open   = 'X'.
*  control-no_close  = 'X'.
*

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
*     FORMNAME           = 'ZREJ_LBL'
      FORMNAME           = FORMNAME
*     VARIANT            = ‘ ‘
*     DIRECT_CALL        = ‘ ‘
    IMPORTING
      FM_NAME            = FNAME
    EXCEPTIONS
      NO_FORM            = 1
      NO_FUNCTION_MODULE = 2
      OTHERS             = 3.
  CONTROL-NO_OPEN   = 'X'.
  CONTROL-NO_CLOSE  = 'X'.

  IF PREVIEW EQ 'X'.
    SSFCOMPOP-TDNOPRINT = 'X'.
  ELSE.
    SSFCOMPOP-TDNOPRINT = ''.
  ENDIF.




  CALL FUNCTION 'SSF_OPEN'
    EXPORTING
      CONTROL_PARAMETERS = CONTROL
      OUTPUT_OPTIONS     = SSFCOMPOP
    IMPORTING
      JOB_OUTPUT_OPTIONS = SSFCRESOP.


  LBL = LABEL.
  CONDENSE LBL.
  CLEAR : CNT1,CNT2.
  LOOP AT IT_TAB1 INTO WA_TAB1.
    IF LABEL IS INITIAL.
      CNT1 = CNT1 + WA_TAB1-WEANZ.
    ELSE.
      CNT1 = CNT1 + LABEL.
    ENDIF.
    WA_TAB2-MBLNR = WA_TAB1-MBLNR.
    COLLECT WA_TAB2 INTO IT_TAB2.
    CLEAR WA_TAB2.
  ENDLOOP.
  SORT IT_TAB2 BY  MBLNR.
  DELETE ADJACENT DUPLICATES FROM IT_TAB2 COMPARING MBLNR.
  SORT IT_TAB3 BY  MBLNR MATNR CHARG.
  DELETE ADJACENT DUPLICATES FROM IT_TAB3 COMPARING MBLNR MATNR CHARG.
  CNT2 = LABEL * CNT1.

*  n = label DIV 4.
*  n1 =  label MOD 4 .
  IF PR1 EQ 'X'.
    N = CNT1 DIV 1.
    N1 =  CNT1 MOD 1 .
    IF N1 GT 0.
      N = N + 1.
    ENDIF.
  ELSEIF PR2 EQ 'X'.
    N = CNT1 DIV 2.
    N1 =  CNT1 MOD 2.
    IF N1 GT 0.
      N = N + 1.
    ENDIF.
  ELSE.
    N = CNT1 DIV 4.
    N1 =  CNT1 MOD 4 .
    IF N1 GT 0.
      N = N + 1.
    ENDIF.
  ENDIF.
  QTY = 0.

*  break-point.

*  LOOP AT it_tab1 INTO wa_tab1.
  CLEAR : COUNT,COUNT1.
  COUNT = 1.
  COUNT1 = 1.
*  LOOP AT it_tab2 INTO wa_tab2.

  IF IT_TAB1 IS NOT INITIAL.
    SELECT * FROM QALS INTO TABLE IT_QALS3 FOR ALL ENTRIES IN IT_TAB1 WHERE CHARG EQ IT_TAB1-CHARG AND LIFNR NE SPACE.
  ENDIF.
  LOOP AT IT_QALS3 INTO WA_QALS3.
    SELECT SINGLE * FROM JEST WHERE OBJNR EQ WA_QALS3-OBJNR AND STAT EQ 'I0224'.
    IF SY-SUBRC EQ 0.
      DELETE IT_QALS3 WHERE PRUEFLOS EQ WA_QALS3-PRUEFLOS.
    ENDIF.
  ENDLOOP.
  SORT IT_QALS3.

  LOOP AT IT_TAB1 INTO WA_TAB1.
*       WHERE mblnr EQ wa_tab2-mblnr.
    DO WA_TAB1-WEANZ TIMES.
      ON CHANGE OF WA_TAB1-MBLNR.
        COUNT1 = 1.
      ENDON.
      ON CHANGE OF WA_TAB1-MATNR.
        COUNT1 = 1.
      ENDON.
      ON CHANGE OF WA_TAB1-CHARG.  "afdded on 16.10.23
        COUNT1 = 1.
      ENDON.
      WA_TAB3-MBLNR = WA_TAB1-MBLNR.
*********************************************
      SELECT SINGLE * FROM MSEG WHERE MBLNR EQ WA_TAB1-MBLNR AND EBELN GT 0.
      IF SY-SUBRC EQ 0.
        SELECT SINGLE * FROM EKKO WHERE EBELN EQ MSEG-EBELN AND RESWK GT 0.
        IF SY-SUBRC EQ 0.
          WA_TAB3-TRF = 'Y'.
          READ TABLE IT_QALS3 INTO WA_QALS3 WITH KEY CHARG  = WA_TAB1-CHARG.
          IF SY-SUBRC EQ 0.
            SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_QALS3-LIFNR.
            IF SY-SUBRC EQ 0.
              SELECT SINGLE * FROM ADRC WHERE ADDRNUMBER EQ LFA1-ADRNR.
              IF SY-SUBRC EQ 0.
                WA_TAB3-VN_NAME1 = ADRC-NAME1.
              ENDIF.
            ENDIF.
          ENDIF.
          IF WA_TAB3-VN_NAME1 EQ SPACE.
            SELECT SINGLE * FROM MCH1 WHERE CHARG EQ WA_TAB1-CHARG AND LIFNR GT 0.
            IF SY-SUBRC EQ 0.
              SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ MCH1-LIFNR.
              IF SY-SUBRC EQ 0.
                SELECT SINGLE * FROM ADRC WHERE ADDRNUMBER EQ LFA1-ADRNR.
                IF SY-SUBRC EQ 0.
                  WA_TAB3-VN_NAME1 = ADRC-NAME1.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
*************************************
      WA_TAB3-MATNR = WA_TAB1-MATNR.
      WA_TAB3-CHARG = WA_TAB1-CHARG.
      WA_TAB3-WEANZ = WA_TAB1-WEANZ.
      WA_TAB3-MAKTX = WA_TAB1-MAKTX.
      WA_TAB3-NORMT = WA_TAB1-NORMT.
      WA_TAB3-LICHA = WA_TAB1-LICHA.
      WA_TAB3-PRUEFLOS = WA_TAB1-PRUEFLOS.
      WA_TAB3-SGTXT = WA_TAB1-SGTXT.
      WA_TAB3-NAME1 = WA_TAB1-NAME1.
      WA_TAB3-HSDAT = WA_TAB1-HSDAT.
      WA_TAB3-VFDAT = WA_TAB1-VFDAT.
      WA_TAB3-MENGE = WA_TAB1-MENGE.
      WA_TAB3-MEINS = WA_TAB1-MEINS.
      WA_TAB3-ABLAD = WA_TAB1-ABLAD.
      WA_TAB3-BUDAT = WA_TAB1-BUDAT.
      WA_TAB3-FORMAT1 = WA_TAB1-FORMAT1.
      SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_TAB1-MATNR.
      IF SY-SUBRC EQ 0.
        WA_TAB3-MTART = MARA-MTART.
      ENDIF.
************************grn done by name*****************

      IF R4 EQ 'X' OR R5 EQ 'X'.
*        select single * from pa0001 where pernr eq pernr and endda ge sy-datum.
*        if sy-subrc eq 0.
*          wa_tab3-name_text = pa0001-ename.
*        endif.
      ELSE.
        SELECT SINGLE * FROM MKPF WHERE MBLNR EQ WA_TAB1-MBLNR AND MJAHR EQ WA_TAB1-MJAHR.
        IF SY-SUBRC EQ 0.
          SELECT SINGLE * FROM V_USR_NAME WHERE BNAME EQ MKPF-USNAM.
          IF SY-SUBRC EQ 0.
            WA_TAB3-NAME_TEXT = V_USR_NAME-NAME_TEXT.
          ENDIF.
        ENDIF.
      ENDIF.
********************************************
*      if label is initial.
*        wa_tab3-lbl = wa_tab1-weanz.
*      else.
*        wa_tab3-lbl = label.
*      endif.
      WA_TAB3-COUNT = COUNT.
      WA_TAB3-COUNT1  = COUNT1.
      COLLECT WA_TAB3 INTO IT_TAB3.
      CLEAR WA_TAB3.
      COUNT = COUNT + 1.
      COUNT1 = COUNT1 + 1.
    ENDDO.
  ENDLOOP.
*  break-point.
  PG1 = PG1 - 1.
  DO  N TIMES.

    IF IT_TAB3 IS NOT INITIAL.

      QT2 = PG1 * 4.
      QT1 = QT2 - 3.

      IF QTY GT QT1  AND QTY LE QT2.

*    format = 'SOP/QC/008-F3'.
*    loop at it_tab1 into wa_tab1.
        CALL FUNCTION FNAME
          EXPORTING
            CONTROL_PARAMETERS = CONTROL
            USER_SETTINGS      = 'X'
            OUTPUT_OPTIONS     = SSFCOMPOP
            LBL                = LABEL
            P_MITTEL           = QTY
            N                  = N
            UNAME              = UNAME
            UDATE              = UDATE
            UTIME              = UTIME
          TABLES
            IT_TAB1            = IT_TAB3
*    EXCEPTIONS
*           FORMATTING_ERROR   = 1
*           INTERNAL_ERROR     = 2
*           SEND_ERROR         = 3
*           USER_CANCELED      = 4
*           OTHERS             = 5
          .
      ENDIF.
*      enddo .
      IF PR1 EQ 'X'.
        QTY = QTY + 1.
      ELSEIF PR2 EQ 'X'.
        QTY = QTY + 2.
      ELSEIF PR3 EQ 'X'.
        QTY = QTY + 3.
      ELSE.
        QTY = QTY + 4.
      ENDIF.
*    endloop.
*    break-point.
    ENDIF.
  ENDDO.
  LBL = LBL + LBL.
  QTY = 0.
*  ENDLOOP.

  LOOP AT IT_TAB1 INTO WA_TAB1.
    WA_TAB4-MBLNR = WA_TAB1-MBLNR.
    WA_TAB4-MJAHR = WA_TAB1-MJAHR.
    COLLECT WA_TAB4 INTO IT_TAB4.
    CLEAR WA_TAB4.
  ENDLOOP.
  SORT IT_TAB4 BY MBLNR MJAHR.
  DELETE ADJACENT DUPLICATES FROM IT_TAB4 COMPARING MBLNR MJAHR.

  IF SSFCRESOP-TDPREVIEW EQ SPACE.
    WRITE : / 'LABELS ARE PRINTED' .
    LOOP AT IT_TAB4 INTO WA_TAB4.
*      SELECT SINGLE * FROM  ZGRN_LABEL WHERE MBLNR EQ WA_TAB4-MBLNR AND MJAHR EQ WA_TAB4-MJAHR.
*      IF SY-SUBRC EQ 4.
      ZGRN_LABEL_WA-MBLNR = WA_TAB4-MBLNR.
      ZGRN_LABEL_WA-MJAHR = WA_TAB4-MJAHR.
*      zgrn_label_wa-pernr = pernr.
      ZGRN_LABEL_WA-UDATE = SY-DATUM.
      ZGRN_LABEL_WA-UTIME = SY-UZEIT.
      MODIFY ZGRN_LABEL FROM ZGRN_LABEL_WA.
      CLEAR ZGRN_LABEL_WA.
*      ENDIF.
    ENDLOOP.
*******************HOD LABELS**************
  ENDIF.

  CLEAR : IT_TAB3,WA_TAB3,IT_TAB1,WA_TAB1,IT_TAB2,WA_TAB2.
  CLEAR : LBL,QTY,CNT1,CNT2,N1,N.

  IF SSFCRESOP-TDPREVIEW EQ SPACE.
    WRITE : / 'LABELS ARE PRINTED' .
*    ZGRN_LABEL-MBLNR =
  ENDIF.
*  endloop.

  CALL FUNCTION 'SSF_CLOSE'.

ENDFORM.
