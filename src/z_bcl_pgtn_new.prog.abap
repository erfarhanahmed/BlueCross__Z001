*&---------------------------------------------------------------------*
*& Report Z_BCL_PGTN_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_BCL_PGTN_NEW NO STANDARD PAGE HEADING LINE-SIZE 150
*REPORT Z_BCL_PGTN NO STANDARD PAGE HEADING LINE-SIZE 150
 LINE-COUNT 60.
*------This is a report for the Material Management--*
* For PACKED GOODS TRANSFER NOTE
* This Report is Demanded by Mr.Dhigolkar
* This Report Is Deveploded by Pramod Kumar.Started
* On 04.09.2001
* Changes carried out by Anjali Singh on 28.01.02 on request of
* Mr. Mahuli (packaging Department)
* Updated by Jyotsna 04/07/2008
*----------------------------------------------------*

*----Tables------------------------------------------*
TABLES : MKPF,
         MSEG,
         MAKT,
         MARC,
         T001W,
         ADRC,
         QALS,
         MVKE,
         TVM5T,
*         zcsm_qty,
         ZCSM_QTY_BATCH,
         ZSHIPPER,
         MCHA,
         JEST,
         PA0002,
         ZPASSW.


DATA: IT_MKPF TYPE TABLE OF MKPF,
      WA_MKPF TYPE MKPF,
      IT_MSEG TYPE TABLE OF MSEG,
      WA_MSEG TYPE MSEG,
      IT_QALS TYPE TABLE OF QALS, "10.9.22
      WA_QALS TYPE QALS.

TYPES: BEGIN OF ITAB1,
         MBLNR TYPE MKPF-MBLNR,
         BUDAT TYPE MKPF-BUDAT,
       END OF ITAB1.

TYPES: BEGIN OF ITAB2,
         MBLNR      LIKE MKPF-MBLNR,  "Material Doc no
         BUDAT      LIKE MKPF-BUDAT,
         MATNR      LIKE MSEG-MATNR,  "Material No
         SGTXT      LIKE MSEG-SGTXT,  "Price
         CHARG      LIKE MSEG-CHARG,  "Batch no
*         ABLAD     LIKE MSEG-ABLAD,  "Packages
         ABLAD(100) TYPE C,
*       erfmg   LIKE mseg-erfmg,  "qty
         ERFMG(12)  TYPE C,
         ERFME      LIKE MSEG-ERFME,  "unit
         VFDAT      LIKE MSEG-VFDAT,  "expiry date
         HSDAT      LIKE MSEG-HSDAT,  "mfg date

         MAKTX      LIKE MAKT-MAKTX,  "material desc
         NAME1      LIKE T001W-NAME1, "plant name1
         NAME2      LIKE T001W-NAME2, "plant name2
         NAME3      LIKE ADRC-NAME3,  "plant name3
         ANZGEB     LIKE QALS-ANZGEB, "no of container
         GEBEH      LIKE QALS-GEBEH,  "batch completion
         MVGR5      LIKE MVKE-MVGR5,  "packsize
         MVGR1      LIKE MVKE-MVGR1,  "packsize

*      bezei   like tvm5t-bezei, "des pack size
         BEZEI(6)   TYPE C,
         INSMK      LIKE MSEG-INSMK,
         ELIKZ      TYPE MSEG-ELIKZ,
         CSQTY(10)  TYPE C,
       END OF ITAB2.

TYPES: BEGIN OF ITAB3,
         COUNTER(10) TYPE C,
         MAKTX       LIKE MAKT-MAKTX,  "material desc
         MATNR       LIKE MSEG-MATNR,  "Material No
         CHARG       LIKE MSEG-CHARG,  "Batch no
*         ABLAD       LIKE MSEG-ABLAD,  "Packages
         ABLAD(100)  TYPE C,
         ERFMG(20)   TYPE C,
         ERFME(3)    TYPE C, "unit
         W_HSDAT(10) TYPE C,
         W_VFDAT(10) TYPE C,
         SGTXT       LIKE MSEG-SGTXT,  "Price
         STATUS(10)  TYPE C,
         BEZEI(6)    TYPE C,
         MBLNR       LIKE MKPF-MBLNR,  "Material Doc no
         BUDAT       TYPE MKPF-BUDAT,
         CSQTY(10)   TYPE C,
         PRUEFLOS    TYPE QALS-PRUEFLOS,

*         NAME1       LIKE T001W-NAME1, "plant name1
*         NAME2       LIKE T001W-NAME2, "plant name2
*         NAME3       LIKE ADRC-NAME3,  "plant name3
*         ANZGEB      LIKE QALS-ANZGEB, "no of container
*         GEBEH       LIKE QALS-GEBEH,  "batch completion
*         MVGR5       LIKE MVKE-MVGR5,  "packsize
*         MVGR1       LIKE MVKE-MVGR1,  "packsize
*
**      bezei   like tvm5t-bezei, "des pack size
*
*         INSMK       LIKE MSEG-INSMK,

       END OF ITAB3.

DATA: IT_TAB1 TYPE TABLE OF ITAB1,
      WA_TAB1 TYPE ITAB1,
      IT_TAB2 TYPE TABLE OF ITAB2,
      WA_TAB2 TYPE ITAB2,
      IT_TAB3 TYPE TABLE OF ITAB3,
      WA_TAB3 TYPE ITAB3.
DATA: NAME1 TYPE ADRC-NAME1,
      NAME2 TYPE ADRC-NAME1,
      NAME3 TYPE ADRC-NAME1,
      CITY1 TYPE ADRC-CITY1.
DATA : MUMREZ        LIKE MARM-UMREZ,
       PQTY          TYPE I,
       TOTCASE(5)    TYPE N,
       LOOSEQTY(5)   TYPE N,
       CSQTY         TYPE I,
       SGTXT(100)    TYPE C,
       MUMREZ1(10)   TYPE C,
       TOTCASE1(10)  TYPE C,
       LOOSEQTY1(10) TYPE C,
       CSQTY1(10)    TYPE C.

DATA: CS TYPE I.
DATA: QTY TYPE P.
DATA : V_FM TYPE RS38L_FNAM.
DATA : FORMAT(100) TYPE C.
DATA : MSG TYPE STRING.
*DATA: P_BUDAT TYPE SY-DATUM.
*----Selection screen for this report----------------*
DATA: UNAME(40) TYPE C.

DATA: O_ENCRYPTOR        TYPE REF TO CL_HARD_WIRED_ENCRYPTOR,
      O_CX_ENCRYPT_ERROR TYPE REF TO CX_ENCRYPT_ERROR.
DATA:
*      v_ac_xstring type xstring,
  V_EN_STRING TYPE STRING,
*      v_en_xstring type xstring,
  V_DE_STRING TYPE STRING,
*      v_de_xstring type string,
  V_ERROR_MSG TYPE STRING.

DATA : R1 VALUE 'X'.

SELECTION-SCREEN BEGIN OF BLOCK MERKMALE2 WITH FRAME TITLE TEXT-002.
*PARAMETERS : PERNR    TYPE PA0001-PERNR,
*             PASS(10) TYPE C.
*PARAMETERS : phynr LIKE qprs-phynr.
SELECTION-SCREEN END OF BLOCK MERKMALE2 .

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
*PARAMETERS : R1 RADIOBUTTON GROUP R1 USER-COMMAND R2 DEFAULT 'X'.
SELECT-OPTIONS S_MBLNR FOR MSEG-MBLNR . "Material no
*PARAMETER P_SRNO(10) TYPE C.           "Serial No
PARAMETERS : P_BUDAT LIKE MKPF-BUDAT DEFAULT SY-DATUM.
*SELECT-OPTIONS : P_BUDAT1 FOR  MKPF-BUDAT .
PARAMETERS : PLANT LIKE MSEG-WERKS.
*PARAMETERS : R2 RADIOBUTTON GROUP R1 .
*PARAMETERS : R3 RADIOBUTTON GROUP R1.

SELECTION-SCREEN END OF BLOCK B1.

*---Data Declearation--------------------------------*

DATA : COUNTER(3) TYPE N.
COUNTER = 0.
DATA : COMPANY_ADDRESS(100) TYPE C.
DATA : W_VFDAT(10) TYPE C.
DATA : W_HSDAT(10) TYPE C.
DATA: M1(2) TYPE C,
      Y1(4) TYPE C.

*----Internal Table Decleration----------------------*
*---Header Internal table----------------------------*

DATA : BEGIN OF T_HEADER OCCURS 0,
         MBLNR LIKE MKPF-MBLNR, "Material Doc no
         BUDAT LIKE MKPF-BUDAT, "Order date
       END OF T_HEADER.

AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.
    CHECK SCREEN-NAME EQ 'PASS'.
    SCREEN-INVISIBLE = 1.
    MODIFY SCREEN.
  ENDLOOP.

  IF R1 EQ 'X'.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*S_MBLNR*'.
        SCREEN-ACTIVE = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*P_BUDAT*'.
        SCREEN-ACTIVE = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*PLANT*'.
        SCREEN-ACTIVE = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.

*  ELSEIF R2 EQ 'X'.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*S_MBLNR*'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*P_BUDAT*'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*PLANT*'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*
*    CALL TRANSACTION 'ZPGTN_UPD'.

*  ELSEIF R3 EQ 'X'.

*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*S_MBLNR*'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*P_BUDAT*'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*PLANT*'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*
*    CALL TRANSACTION 'ZPRDINSP_YLD'.

  ENDIF.

*---Start of selection-----------------------*

START-OF-SELECTION.

  IF R1 EQ 'X'.
    PERFORM PASS.
*  BREAK-POINT .
*    CLEAR : UNAME.       "Commented by Vinayak S.
*    SELECT SINGLE * FROM PA0002 WHERE PERNR EQ PERNR AND ENDDA GE SY-DATUM.
*    IF SY-SUBRC EQ 0.
*      CONCATENATE PA0002-VORNA PA0002-NACHN INTO UNAME SEPARATED BY SPACE.
*    ENDIF.

    IF S_MBLNR IS INITIAL.
      MESSAGE 'ENTER MATERIAL DOCUMENT NUMBER' TYPE 'E'.
    ENDIF.
    IF P_BUDAT IS INITIAL.
      MESSAGE 'ENTER DOCUMENT POSTING DATE' TYPE 'E'.
    ENDIF.
    IF PLANT IS INITIAL.
      MESSAGE 'ENTER PLANT' TYPE 'E'.
    ENDIF.
    PERFORM AUTHORIZATION.
    CLEAR T_HEADER.
    REFRESH T_HEADER.
    PERFORM T_HEADER.
    PERFORM T_DETAILS.
    PERFORM WRITE_T_DETAILS.
*  ELSEIF R2 EQ 'X'.                      "Commented by Vinayak S.
*    CALL TRANSACTION 'ZPGTN_UPD'.
*  ELSEIF R3 EQ 'X'.
*    CALL TRANSACTION 'ZPRDINSP_YLD'.
  ENDIF.
*  PERFORM WRITE_FOOTER.

*&---------------------------------------------------------------------*
*&      Form  T_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM T_HEADER.

* Select all the document from mkpf which has been input by
* the user
  SELECT * FROM MKPF INTO TABLE IT_MKPF WHERE MBLNR IN S_MBLNR AND BUDAT EQ P_BUDAT.

  LOOP AT IT_MKPF INTO WA_MKPF.
    WA_TAB1-MBLNR = WA_MKPF-MBLNR. "Material Doc no
    WA_TAB1-BUDAT = WA_MKPF-BUDAT. "Order date
    COLLECT WA_TAB1 INTO IT_TAB1.
    CLEAR WA_TAB1.
  ENDLOOP.

*    T_HEADER-MBLNR = MKPF-MBLNR.
*    APPEND T_HEADER.
*    CLEAR T_HEADER.
*  ENDSELECT.
ENDFORM.                    " T_HEADER

*&---------------------------------------------------------------------*
*&      Form  T_DETAILS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM T_DETAILS.
  CLEAR : NAME1,NAME2,NAME3,CITY1.
  SELECT SINGLE * FROM T001W WHERE WERKS = PLANT.
  IF SY-SUBRC = 0.
    IF T001W-WERKS EQ '1000'.
      CITY1 = T001W-ORT01.
    ELSE.
      CITY1 = T001W-KUNNR.
    ENDIF.

    NAME1 = T001W-NAME1. "plant name1
    NAME2 = T001W-NAME2. "plant name2
*    SELECT SINGLE * FROM ADRC WHERE NAME1 = T001W-NAME1.
*    IF SY-SUBRC = 0.
*      NAME3 = ADRC-NAME3.  "plant name3
*    ENDIF.

  ENDIF.


  IF IT_TAB1 IS NOT INITIAL.
    SELECT * FROM MSEG INTO TABLE IT_MSEG FOR ALL ENTRIES IN IT_TAB1 WHERE MBLNR EQ IT_TAB1-MBLNR AND BWART EQ '101' AND
      WERKS EQ PLANT AND LGORT GE 'FG01' AND LGORT LE 'FG04'.
  ENDIF.
  IF IT_MSEG IS INITIAL.
    MESSAGE 'NO DATA FOUND' TYPE 'E'.
  ENDIF.

*  LOOP AT T_HEADER .
  LOOP AT IT_TAB1 INTO WA_TAB1.
*---select the requried data from mseg for the document which is
*   selected in the range
    LOOP AT IT_MSEG INTO WA_MSEG WHERE MBLNR = WA_TAB1-MBLNR.
      SELECT SINGLE * FROM MSEG WHERE SMBLN EQ WA_TAB1-MBLNR.
      IF SY-SUBRC EQ 4.
        WA_TAB2-MBLNR = WA_MSEG-MBLNR.  "Material Doc no
        WA_TAB2-BUDAT = WA_TAB1-BUDAT.
        WA_TAB2-MATNR = WA_MSEG-MATNR.  "Material No
        WA_TAB2-SGTXT = WA_MSEG-SGTXT.  "price
        WA_TAB2-CHARG = WA_MSEG-CHARG.  "Batch no
*      WA_TAB2-ABLAD = WA_MSEG-ABLAD.  "Packages
*      WA_TAB2-ERFMG = WA_MSEG-ERFMG.  "qty
        WA_TAB2-ERFME = WA_MSEG-ERFME.  "unit
        WA_TAB2-VFDAT = WA_MSEG-VFDAT.  "expiry date
        WA_TAB2-HSDAT = WA_MSEG-HSDAT.  "expiry date

        WA_TAB2-INSMK = WA_MSEG-INSMK.   "stock status"
        WA_TAB2-ELIKZ = WA_MSEG-ELIKZ.

*  -select the material description from the makt
        SELECT SINGLE * FROM MAKT WHERE MATNR = WA_MSEG-MATNR AND SPRAS EQ 'EN'.
        IF SY-SUBRC = 0.
          WA_TAB2-MAKTX = MAKT-MAKTX.  "material desc
        ENDIF.
*--this is to select the name and address of the company
        SELECT SINGLE * FROM T001W WHERE WERKS = WA_MSEG-WERKS.
        IF SY-SUBRC = 0.
          WA_TAB2-NAME1 = T001W-NAME1. "plant name1
          WA_TAB2-NAME2 = T001W-NAME2. "plant name2

          SELECT SINGLE * FROM ADRC WHERE NAME1 = T001W-NAME1.
          IF SY-SUBRC = 0.
            WA_TAB2-NAME3 = ADRC-NAME3.  "plant name3
          ENDIF.
        ENDIF.
**    SELECT SINGLE * FROM qals WHERE mblnr = mseg-mblnr.
***---this is for the no of container and batch completion which
***   is retrived from the QALS table
**    if sy-subrc = 0.
**    t_details-anzgeb = qals-anzgeb. "no of container
**    if qals-gebeh = 'N'.
**    t_details-gebeh  = qals-gebeh.  "batch completion
**    Else.
**    t_details-gebeh  = 'Y'.  "batch completion
**    endif.
**    endif.
        SELECT SINGLE * FROM MVKE WHERE MATNR = WA_MSEG-MATNR.
        IF SY-SUBRC EQ 0.
          WA_TAB2-MVGR5 = MVKE-MVGR5.
          WA_TAB2-MVGR1 = MVKE-MVGR1.
          SELECT SINGLE * FROM TVM5T WHERE MVGR5 = MVKE-MVGR5.
          IF SY-SUBRC EQ 0.
            WA_TAB2-BEZEI = TVM5T-BEZEI.
          ENDIF.
        ENDIF.
*****CALCULATE CONTROL SAMPLE QTY****************
        CS = 0.
*        IF WA_MSEG-ELIKZ EQ 'X'.
*          CS = 1.
*        ELSE.

        SELECT SINGLE ZZ_SMPQTY FROM ZTB_MIGOITM INTO @DATA(LV_SMPQTY) WHERE MBLNR = @WA_MSEG-mblnr. "AND CHARG = @WA_MSEG-CHARG AND LGORT = 'CSM'.
        IF sy-subrc eq 0.
          CSQTY = LV_SMPQTY.           "ADDED BY VINAYAK S.
          WA_TAB2-CSQTY = CSQTY.

        ENDIF.

        SELECT SINGLE * FROM ZCSM_QTY_BATCH WHERE MBLNR EQ WA_MSEG-MBLNR.
        IF SY-SUBRC EQ 0.
          CS = 1.
        ENDIF.
*        ENDIF.

*        IF WA_MSEG-ELIKZ EQ 'X'.
        IF CS EQ 1.
*          SELECT SINGLE * FROM zcsm_qty WHERE werks EQ wa_mseg-werks AND matnr EQ wa_mseg-matnr.
*          IF sy-subrc EQ 4.
*            MESSAGE i900(pg) WITH wa_mseg-matnr.  "MAINTAIN CONTROL SAMPLE QUANTITY IN MASTER
*          ENDIF.
          CLEAR : CSQTY,CSQTY1.

          SELECT SINGLE * FROM ZCSM_QTY_BATCH WHERE MBLNR EQ WA_MSEG-MBLNR AND MATNR EQ WA_MSEG-MATNR AND CHARG EQ WA_MSEG-CHARG AND WERKS EQ WA_MSEG-WERKS.
          IF SY-SUBRC EQ 0.
            CSQTY = ZCSM_QTY_BATCH-MENGE.
          ENDIF.

*          IF csqty EQ 0.
*            SELECT SINGLE * FROM zcsm_qty WHERE werks EQ wa_mseg-werks AND matnr EQ wa_mseg-matnr.
*            IF sy-subrc EQ 0.
*              csqty = zcsm_qty-menge.
*            ENDIF.
*          ENDIF.
*          IF CSQTY EQ 0.
*            MESSAGE I900(PG) WITH WA_MSEG-MATNR.
*          ENDIF.
          WA_MSEG-ERFMG =  WA_MSEG-ERFMG - CSQTY.  "qty
          WA_TAB2-CSQTY = CSQTY.
          CONDENSE WA_TAB2-CSQTY.
        ENDIF.

        WA_TAB2-ERFMG = WA_MSEG-ERFMG.  "qty
*** SOC by CK on Date 26.12.2025 18:03:34
        WA_TAB2-ERFMG = WA_TAB2-ERFMG - CSQTY.
        WA_MSEG-ERFMG = WA_TAB2-ERFMG.
*** EOC by CK on Date 26.12.2025 18:03:34
***************shipper*****************
        CLEAR : MUMREZ,PQTY,TOTCASE,LOOSEQTY,SGTXT,MUMREZ1.
        SELECT SINGLE UMREZ FROM MARM INTO MUMREZ  WHERE MATNR = WA_MSEG-MATNR AND MEINH = 'SPR'.
        SELECT SINGLE * FROM ZSHIPPER WHERE MATNR EQ WA_MSEG-MATNR.  "30.5.22
        IF SY-SUBRC EQ 0.
          SELECT SINGLE * FROM MCHA WHERE MATNR EQ WA_MSEG-MATNR AND CHARG EQ WA_MSEG-CHARG AND ERSDA LE ZSHIPPER-TO_DT.
          IF SY-SUBRC EQ 0.
            MUMREZ = ZSHIPPER-UMREZ.
          ENDIF.
        ENDIF.

*      PQTY = WA_MSEG-MENGE.
        PQTY = WA_MSEG-ERFMG.
        IF MUMREZ GT 0.
          TOTCASE = PQTY DIV MUMREZ.
          LOOSEQTY = PQTY MOD MUMREZ.
        ENDIF.

        IF TOTCASE = 0.
          MUMREZ = LOOSEQTY.
          PQTY = 1.
          LOOSEQTY = 0.
        ELSE.
          PQTY = TOTCASE.
        ENDIF.
        MUMREZ1 = MUMREZ.
        CONDENSE MUMREZ1.
        CLEAR : TOTCASE1.
        WRITE TOTCASE TO TOTCASE1 NO-ZERO.
        CONDENSE TOTCASE1.
        CLEAR : LOOSEQTY1.
        WRITE LOOSEQTY TO LOOSEQTY1 NO-ZERO.
        CONDENSE LOOSEQTY1.
        IF LOOSEQTY GT 0.
*        CONCATENATE MUMREZ1 'X' TOTCASE1 ' + ' ' 1X ' LOOSEQTY1 INTO SGTXT.
          CONCATENATE TOTCASE1 'X' MUMREZ1 ' + ' ' 1X ' LOOSEQTY1 INTO SGTXT.
        ELSE.
*        CONCATENATE MUMREZ1 'X ' TOTCASE1 INTO SGTXT.
***          CONCATENATE TOTCASE1 'X ' MUMREZ1 INTO SGTXT.
          IF TOTCASE1 EQ 0.
            CONCATENATE  '1 X ' MUMREZ1 INTO SGTXT.  "7.7.22
          ELSE.
            CONCATENATE TOTCASE1 'X ' MUMREZ1 INTO SGTXT.
          ENDIF.
        ENDIF.
        CLEAR : CSQTY1.
*        IF WA_TAB2-ELIKZ EQ 'X'.
*        IF CS EQ 1.
*          CSQTY1 = CSQTY.
*          CONCATENATE SGTXT ',' 'CS' CSQTY1 INTO SGTXT SEPARATED BY SPACE.
*        ENDIF.
        CONDENSE SGTXT.
        WA_TAB2-ABLAD = SGTXT.


***********************************************

        COLLECT WA_TAB2 INTO IT_TAB2.
        CLEAR WA_TAB2.
      ENDIF.
    ENDLOOP.
  ENDLOOP.


ENDFORM.                    " T_DETAILS

*&---------------------------------------------------------------------*
*&      Form  WRITE_T_DETAILS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM WRITE_T_DETAILS.
  SORT IT_TAB2 BY MBLNR.
  CLEAR : COUNTER.
  IF IT_TAB2 IS NOT INITIAL.
    SELECT * FROM QALS INTO TABLE IT_QALS FOR ALL ENTRIES IN IT_TAB2 WHERE WERK EQ PLANT AND MATNR EQ IT_TAB2-MATNR AND CHARG = IT_TAB2-CHARG.
  ENDIF.

  LOOP AT IT_QALS INTO WA_QALS.
    SELECT SINGLE * FROM JEST WHERE OBJNR EQ WA_QALS-OBJNR AND STAT EQ 'I0224'.
    IF SY-SUBRC EQ 0.
      DELETE IT_QALS WHERE PRUEFLOS = WA_QALS-PRUEFLOS.
    ENDIF.
  ENDLOOP.

  SORT IT_QALS BY ENSTEHDAT DESCENDING.

  LOOP AT IT_TAB2 INTO WA_TAB2.
    COUNTER = COUNTER + 1.


    WA_TAB3-COUNTER = COUNTER.
    CONDENSE WA_TAB3-COUNTER.
    WA_TAB3-MAKTX = WA_TAB2-MAKTX.
    WA_TAB3-MATNR = WA_TAB2-MATNR.
    WA_TAB3-CHARG = WA_TAB2-CHARG.
    WA_TAB3-ABLAD = WA_TAB2-ABLAD.
    READ TABLE IT_QALS INTO WA_QALS WITH KEY MATNR = WA_TAB2-MATNR CHARG = WA_TAB2-CHARG.
    IF SY-SUBRC EQ 0.
      WA_TAB3-PRUEFLOS = WA_QALS-PRUEFLOS.
    ENDIF.
*    CONCATENATE WA_TAB2-ERFMG WA_TAB2-ERFME INTO  WA_TAB3-ERFMG SEPARATED BY SPACE.
    CLEAR : QTY.
    QTY = WA_TAB2-ERFMG.
    WA_TAB3-ERFMG = QTY.

    CONDENSE   WA_TAB3-ERFMG.
    WA_TAB3-ERFME = WA_TAB2-ERFME.
    CONDENSE WA_TAB3-ERFME.
    CLEAR : W_VFDAT,W_HSDAT.
    CONCATENATE WA_TAB2-VFDAT+4(2) '.' WA_TAB2-VFDAT+0(4) INTO W_VFDAT.
    CONCATENATE WA_TAB2-HSDAT+4(2) '.' WA_TAB2-HSDAT+0(4) INTO W_HSDAT.
    WA_TAB3-W_HSDAT = W_HSDAT.
    WA_TAB3-W_VFDAT = W_VFDAT.
    WA_TAB3-SGTXT = WA_TAB2-SGTXT.
    CONDENSE  WA_TAB3-SGTXT.
    IF WA_TAB2-INSMK = 'S' OR WA_TAB2-INSMK = '3'.
*      WA_TAB3-STATUS = 'BLOCKED' .
      WA_TAB3-STATUS = 'QUARANTINE' .
    ENDIF.
    IF WA_TAB2-INSMK = 'X' OR WA_TAB2-INSMK = 'X'.
      WA_TAB3-STATUS = 'QUALITY' .
    ENDIF.
    IF WA_TAB2-INSMK = SPACE OR WA_TAB2-INSMK = 'F'.
      WA_TAB3-STATUS = 'UN-RESTRIC'.
    ENDIF.
    WA_TAB3-BEZEI = WA_TAB2-BEZEI.
    WA_TAB3-MBLNR = WA_TAB2-MBLNR.
    WA_TAB3-BUDAT = WA_TAB2-BUDAT.
    WA_TAB3-CSQTY = WA_TAB2-CSQTY.
    CONDENSE WA_TAB3-CSQTY.

    COLLECT WA_TAB3 INTO IT_TAB3.
    CLEAR WA_TAB3.
  ENDLOOP.

  SORT IT_TAB3 BY MBLNR MATNR CHARG BUDAT.
*  LOOP AT IT_TAB3 INTO WA_TAB3.
*    WRITE : / 'A', WA_TAB3-COUNTER, WA_TAB3-MAKTX,WA_TAB3-MATNR,WA_TAB3-CHARG,WA_TAB3-ABLAD,WA_TAB3-ERFMG,
*    WA_TAB3-ERFME, WA_TAB3-W_HSDAT,WA_TAB3-W_VFDAT, WA_TAB3-SGTXT,WA_TAB3-STATUS,WA_TAB3-BEZEI,WA_TAB3-MBLNR.
*  ENDLOOP.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
*     FORMNAME           = 'ZPGTN3'
*     formname           = 'ZPGTN1'
      FORMNAME           = 'ZPGTN1_A1'
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
      FM_NAME            = V_FM
    EXCEPTIONS
      NO_FORM            = 1
      NO_FUNCTION_MODULE = 2
      OTHERS             = 3.

  CALL FUNCTION V_FM
    EXPORTING
*     from_dt          = from_dt
*     to_dt            = to_dt
      FORMAT           = FORMAT
      NAME1            = NAME1
      NAME2            = NAME2
      NAME3            = NAME3
      CITY1            = CITY1
      P_BUDAT          = P_BUDAT
      UNAME            = UNAME
*     AUBEL            = AUBEL
*     adrc             = adrc
*     t001w            = t001w
*     J_1IMOCUST       = J_1IMOCUST
*     G_LSTNO          = G_LSTNO
*     WA_ADRC          = WA_ADRC
*     VBKD             = VBKD
*     vbrk             = vbrk
*     fkdat            = fkdat
*     TOTAL            = TOTAL
*     TOTAL1           = TOTAL1
*     VBRK             = VBRK
*     W_TAX            = W_TAX
*     W_VALUE          = W_VALUE
*     SPELL            = SPELL
*     W_DIFF           = W_DIFF
*     EMNAME           = EMNAME
*     RMNAME           = RMNAME
*     CLMDT            = CLMDT
    TABLES
      IT_TAB3          = IT_TAB3
*     it_vbrp          = it_vbrp
*     ITAB_DIVISION    = ITAB_DIVISION
*     ITAB_STORAGE     = ITAB_STORAGE
*     ITAB_PA0002      = ITAB_PA0002
    EXCEPTIONS
      FORMATTING_ERROR = 1
      INTERNAL_ERROR   = 2
      SEND_ERROR       = 3
      USER_CANCELED    = 4
      OTHERS           = 5.


ENDFORM.                    " WRITE_T_DETAILS

*-----End Of Page---------------------------*
END-OF-PAGE.
  WRITE :/3  SY-ULINE(113).

*&---------------------------------------------------------------------*
*&      Form  WRITE_FOOTER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM WRITE_FOOTER.
*  SKIP 3.
*  WRITE :/10 'Issued by Packaging',
*          85 'Received By'.


ENDFORM.                    " WRITE_FOOTER
*&---------------------------------------------------------------------*
*&      Form  AUTHORIZATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM AUTHORIZATION .
  AUTHORITY-CHECK OBJECT 'M_BCO_WERK'
             ID 'WERKS' FIELD PLANT.
  IF SY-SUBRC <> 0.
    CONCATENATE 'No authorization for Plant' PLANT INTO MSG
    SEPARATED BY SPACE.
    MESSAGE MSG TYPE 'E'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UPDATECS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  PASS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM PASS .

  SELECT SINGLE TECHDESC FROM USR21 INTO @DATA(LV_UNAME) WHERE BNAME = @SY-UNAME.
  UNAME = LV_UNAME.         "Added by Vinayak S.
*  SELECT SINGLE * FROM ZPASSW WHERE PERNR = PERNR.
*  IF SY-SUBRC EQ 0.
*
*    IF SY-UNAME NE ZPASSW-UNAME.
*      MESSAGE 'INVALID LOGIN ID' TYPE 'E'.
*    ENDIF.
*    V_EN_STRING = ZPASSW-PASSWORD.
**&———————————————————————** Decryption – String to String*&———————————————————————*
*    TRY.
*        CREATE OBJECT O_ENCRYPTOR.
*        CALL METHOD O_ENCRYPTOR->DECRYPT_STRING2STRING
*          EXPORTING
*            THE_STRING = V_EN_STRING
*          RECEIVING
*            RESULT     = V_DE_STRING.
*      CATCH CX_ENCRYPT_ERROR INTO O_CX_ENCRYPT_ERROR.
*        CALL METHOD O_CX_ENCRYPT_ERROR->IF_MESSAGE~GET_TEXT
*          RECEIVING
*            RESULT = V_ERROR_MSG.
*        MESSAGE V_ERROR_MSG TYPE 'E'.
*    ENDTRY.
*    IF V_DE_STRING EQ PASS.
**      message 'CORRECT PASSWORD' type 'I'.
*    ELSE.
*      MESSAGE 'INCORRECT PASSWORD' TYPE 'E'.
*    ENDIF.
*  ELSE.
*    MESSAGE 'NOT VALID USER' TYPE 'E'.
*    EXIT.
*  ENDIF.
*  CLEAR : PASS.
*  PASS = '   '.
ENDFORM.
