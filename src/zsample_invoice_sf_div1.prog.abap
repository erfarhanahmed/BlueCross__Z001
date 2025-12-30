*&---------------------------------------------------------------------*
*& Report  ZSAMPLE_INVOICE_SF1
*& DEVELOPED BY JYOTSNA: 17.8.23
*&---------------------------------------------------------------------*
*&SAMPLE DELIVERY CHALLAN PRINT IN R3 IS CONVERTED INTO A4 PAGE ON 11.9.24 BY JYOTSNA
*&
*&---------------------------------------------------------------------*
REPORT ZSAMPLE_INVOICE_SF5.

TABLES : VBRK,
         MARC,
         MAKT,
         MVKE,
         TVM5T,
         MCHA,
         A602,
         "prcd_elements,konp,
         KONP,
         T001W,
         KNA1,
         ADRC,
         YTERRALLC,
         PA0001,
         PA0006,
         T005S,
         ZDRPDEST,
         LFA1,
         MARA,
*****         zpassw,
         T247,
         PA0105,
         PA0185,
         IBATCH,
         MARM.

DATA: IT_ZSAMPINVH TYPE TABLE OF ZSAMPINVH,
      WA_ZSAMPINVH TYPE ZSAMPINVH,
      IT_ZSAMPINVP TYPE TABLE OF ZSAMPINVP,
      WA_ZSAMPINVP TYPE ZSAMPINVP,
      IT_RZDSMTER  TYPE TABLE OF ZDSMTER,
      WA_RZDSMTER  TYPE ZDSMTER,
      IT_ZZDSMTER  TYPE TABLE OF ZDSMTER,
      WA_ZZDSMTER  TYPE ZDSMTER.

TYPES: BEGIN OF ITAB1,
         COUNT(3)  TYPE C,
         STEUC     TYPE MARC-STEUC,
         CHARG     TYPE ZSAMPINVP-CHARG,
         MAKTX     TYPE  MAKT-MAKTX,
         BEZEI     TYPE TVM5T-BEZEI,
         EXP(7)    TYPE C,
         QTY(10)   TYPE C,
         RATE(15)  TYPE C,
         VALUE(20) TYPE C,
         TAX(10)   TYPE C,
         TYP(1)    TYPE C,
*         vbeln    type zsampinvp-vbeln,
*         fkdat    type zsampinvp-fkdat,
*         sampcode  type zsampinvp-sampcode,
*
*         lgort    type zsampinvp-lgort,
*
*         bzirk    type zsampinvp-bzirk,
       END OF ITAB1.

TYPES: BEGIN OF DISP1,
         VBELN    TYPE ZSAMPINVH-VBELN,
         FKDAT    TYPE ZSAMPINVH-FKDAT,
         SAMPCODE TYPE ZSAMPINVP-SAMPCODE,
         CHARG    TYPE ZSAMPINVP-CHARG,
         MAKTX    TYPE  MAKT-MAKTX,
         QTY      TYPE ZSAMPINVP-QTY,
         PERNR    TYPE PA0001-PERNR,
         ENAME    TYPE PA0001-ENAME,
         EXP(7)   TYPE C,
         STEUC    TYPE  MARC-STEUC,
         BOX(5)   TYPE C,
         SPR(5)   TYPE C,
         BOXNO    TYPE P DECIMALS 2,
         SPRNO    TYPE P DECIMALS 2,
       END OF DISP1.
DATA: BOXNO TYPE P DECIMALS 2,
      SPRNO TYPE P DECIMALS 2.
DATA: IT_TAB1  TYPE TABLE OF ITAB1,
      WA_TAB1  TYPE ITAB1,
      IT_TAB11 TYPE TABLE OF ITAB1,
      WA_TAB11 TYPE ITAB1,
      IT_DISP1 TYPE TABLE OF DISP1,
      WA_DISP1 TYPE DISP1.
DATA: BOX TYPE P.
TYPES : BEGIN OF ST_CHECK,
          VBELN TYPE VBRK-VBELN,
          GJAHR TYPE ZSAMPINVP-GJAHR,
        END OF ST_CHECK.

DATA : V_FM TYPE RS38L_FNAM.
DATA: FORMAT(10) TYPE C.
DATA: I_OTF     TYPE ITCOO    OCCURS 0 WITH HEADER LINE,
      I_TLINE   LIKE TLINE    OCCURS 0 WITH HEADER LINE,
      I_RECORD  LIKE SOLISTI1 OCCURS 0 WITH HEADER LINE,
      I_XSTRING TYPE XSTRING,
* Objects to send mail.
      I_OBJPACK LIKE SOPCKLSTI1 OCCURS 0 WITH HEADER LINE,
      I_OBJTXT  LIKE SOLISTI1   OCCURS 0 WITH HEADER LINE,
      I_OBJBIN  LIKE SOLIX      OCCURS 0 WITH HEADER LINE,
      I_RECLIST LIKE SOMLRECI1  OCCURS 0 WITH HEADER LINE,
      V_LEN_IN  LIKE SOOD-OBJLEN.
DATA: IN_MAILID TYPE AD_SMTPADR.
DATA: NTEXT1(100) TYPE C.
DATA: W_CTRLOP TYPE SSFCTRLOP,
      W_COMPOP TYPE SSFCOMPOP.
DATA : W_RETURN    TYPE SSFCRESCL.
DATA: COUNT TYPE I.
DATA: QTY    TYPE P,
      TQTY   TYPE P,
      TYP(1) TYPE C.
DATA: STOTQTY     TYPE VBRP-FKIMG,
      SAMPQTY(15) TYPE C.
DATA : IT_CHECK TYPE TABLE OF ST_CHECK,
       WA_CHECK TYPE          ST_CHECK.
DATA : CONTROL  TYPE SSFCTRLOP.
DATA : W_SSFCOMPOP TYPE SSFCOMPOP.
DATA: VBELN TYPE ZSAMPINVH-VBELN,
      GJAHR TYPE ZSAMPINVH-GJAHR.
DATA: CNAME(40) TYPE C.
DATA: GSTNO1   TYPE KNA1-STCD3,
      REGIO1   TYPE KNA1-REGIO,
      NAME1_1  TYPE ADRC-NAME1,
      NAME1_2  TYPE ADRC-NAME2,
      NAME1_3  TYPE ADRC-NAME3,
      NAME1_4  TYPE ADRC-NAME4,
      PHONE1_1 TYPE ADRC-TEL_NUMBER,
      LOCAT1   TYPE ADRC-NAME4,
      DEST1    TYPE T001W-ORT01.
DATA: ENAME TYPE PA0001-ENAME.
DATA: ADRC1    TYPE PA0006-NAME2,
      ADRC2    TYPE PA0006-STRAS,
      ADRC3    TYPE PA0006-LOCAT,
      ADRC4    TYPE PA0006-ORT01,
      ADRC5    TYPE PA0006-ORT02,
      PSTLZ    TYPE PA0006-PSTLZ,
      STATE    TYPE T005S-FPRCD,
      TELNR    TYPE  PA0006-TELNR,
      DEST     TYPE ZDRPDEST-ZZ_HQDESC,
      TNAME    TYPE LFA1-NAME1,
      LRNO     TYPE ZSAMPINVH-LR_NO,
      LRDT     TYPE SY-DATUM,
      CASE(10) TYPE C.
DATA: PSOEMAIL TYPE PA0105-USRID_LONG,
      RMEMAIL  TYPE PA0105-USRID_LONG,
      ZMEMAIL  TYPE PA0105-USRID_LONG.

DATA: EXP(7) TYPE C.
DATA: RATE    TYPE P DECIMALS 2,
      VALUE   TYPE P DECIMALS 2,
      TVALUE  TYPE P DECIMALS 2,
      TOTVAL1 TYPE P,
      TOTVAL2 TYPE P DECIMALS 2,
      TAX     TYPE P DECIMALS 2.
DATA: FTEXT1(1) TYPE C.
DATA: TOTVAL(12) TYPE C.
DATA: USEMON(10) TYPE C,
      DIV(3)     TYPE C,
      PAN        TYPE PA0185-ICNUM,
      REG        TYPE PA0006-STATE,
      DCOUNT     TYPE I.
DATA: TOTQTY(10) TYPE C.
DATA: INVDT   TYPE SY-DATUM,
      BZIRK   TYPE ZSAMPINVH-BZIRK,
      RM      TYPE ZDSMTER-BZIRK,
      RMNAME  TYPE PA0001-ENAME,
      RMTELNR TYPE PA0006-TELNR,
      ZM      TYPE ZDSMTER-BZIRK,
      ZMNAME  TYPE PA0001-ENAME,
      ZMTELNR TYPE PA0006-TELNR.
DATA: TOTTAX(7) TYPE C,
      TTAX      TYPE P DECIMALS 2.
DATA:
*        v_ac_xstring type xstring,
  V_EN_STRING TYPE STRING,
*        v_en_xstring type xstring,
  V_DE_STRING TYPE STRING,
*        v_de_xstring type string,
  V_ERROR_MSG TYPE STRING.
DATA: O_ENCRYPTOR        TYPE REF TO CL_HARD_WIRED_ENCRYPTOR,
      O_CX_ENCRYPT_ERROR TYPE REF TO CX_ENCRYPT_ERROR.
DATA: S1(1) TYPE C.  "SIGN1

TYPE-POOLS:  SLIS.

DATA: G_REPID     LIKE SY-REPID,
      FIELDCAT    TYPE SLIS_T_FIELDCAT_ALV,
      WA_FIELDCAT LIKE LINE OF FIELDCAT,
      SORT        TYPE SLIS_T_SORTINFO_ALV,
      WA_SORT     LIKE LINE OF SORT,
      LAYOUT      TYPE SLIS_LAYOUT_ALV.

*************************************************
*selection-screen begin of block merkmale1 with frame title text-001.
*parameters : pernr    like pa0001-pernr matchcode object prem,
*             pass(10) type c.
*selection-screen end of block merkmale1.

SELECTION-SCREEN BEGIN OF BLOCK MERKMALE2 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS : INV FOR VBRK-VBELN,
                 FKDAT FOR VBRK-FKDAT OBLIGATORY.
  PARAMETERS : WERKS LIKE ZSAMPINVH-WERKS.
  PARAMETERS: R2 RADIOBUTTON GROUP R1,
              R3 RADIOBUTTON GROUP R1.
  PARAMETERS : R1  RADIOBUTTON GROUP R1,
               R11 RADIOBUTTON GROUP R1,
               R12 RADIOBUTTON GROUP R1.
  PARAMETERS : EMAIL(70) TYPE C.


SELECTION-SCREEN END OF BLOCK MERKMALE2.

AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.
    CHECK SCREEN-NAME EQ 'PASS'.
    SCREEN-INVISIBLE = 1.
    MODIFY SCREEN.
  ENDLOOP.

INITIALIZATION.
  G_REPID = SY-REPID.

START-OF-SELECTION.
*  clear : s1.
*  if pernr is not initial.
*    perform passw.
*    if pernr eq '00004391'.
**      s1 = 'M'.
*    endif.
*****    if sy-uname eq 'SDPUN05' or sy-uname eq 'SDPUN06' or sy-uname eq 'BCLLDEVP1' and werks eq '2030'.
*****      s1 = 'P'.
*****    endif.

*    IF PERNR EQ '00008872'.
*      S1 = 'G'.
*    ENDIF.
*  endif.

  SELECT * FROM ZSAMPINVH INTO TABLE IT_ZSAMPINVH WHERE VBELN IN INV AND FKDAT IN FKDAT AND WERKS EQ WERKS.
  IF SY-SUBRC EQ 0.
    IF WERKS EQ '2002'.
      SELECT * FROM ZSAMPINVP INTO TABLE IT_ZSAMPINVP FOR ALL ENTRIES IN IT_ZSAMPINVH WHERE GJAHR EQ IT_ZSAMPINVH-GJAHR AND VBELN EQ IT_ZSAMPINVH-VBELN
        AND WERKS EQ SPACE .
    ELSE.
      SELECT * FROM ZSAMPINVP INTO TABLE IT_ZSAMPINVP FOR ALL ENTRIES IN IT_ZSAMPINVH WHERE GJAHR EQ IT_ZSAMPINVH-GJAHR AND VBELN EQ IT_ZSAMPINVH-VBELN
        AND WERKS EQ IT_ZSAMPINVH-WERKS.
    ENDIF.
  ENDIF.

  IF IT_ZSAMPINVH IS INITIAL .
    MESSAGE 'INVOICE DATA NOT FOUND ON GIVEN PARAMETERS' TYPE 'E'.
  ENDIF.




  LOOP AT IT_ZSAMPINVH INTO WA_ZSAMPINVH.
    WA_CHECK-VBELN = WA_ZSAMPINVH-VBELN.
    WA_CHECK-GJAHR = WA_ZSAMPINVH-GJAHR.
    COLLECT WA_CHECK INTO IT_CHECK.
    CLEAR WA_CHECK.
  ENDLOOP.


  IF R1 EQ 'X'.
    PERFORM DELCH.
  ELSEIF R11 EQ 'X' OR R12 EQ 'X' .
    IF SY-HOST EQ 'SAPQLT' OR SY-HOST EQ 'SAPDEV'.
*     if sy-host eq 'SAPDEV'.
    ELSE.
      IF R12 EQ 'X'.
        IF EMAIL IS INITIAL.
          MESSAGE 'ENTER EMAIL ID' TYPE 'E'.
        ENDIF.
      ENDIF.
      PERFORM DELCHEMAIL.
    ENDIF.
*  elseif r12 eq 'X'.
*
*    if r12 eq 'X'.
*      if email is initial.
*        message 'ENTER EMAIL ID' type 'E'.
*      endif.
*    endif.
*    perform delchemail.

  ELSEIF R2 EQ 'X' .
    PERFORM PACKLIST.
  ELSEIF R3 EQ 'X'.
    PERFORM ALV.
  ENDIF.




*&---------------------------------------------------------------------*
*&      Form  FORM2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*-----------------------------------------------------------*
*&      Form  FORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FORM1 .



  CLEAR : COUNT,DIV.
  COUNT = 1.
  LOOP AT IT_ZSAMPINVP INTO WA_ZSAMPINVP WHERE VBELN EQ VBELN AND GJAHR EQ GJAHR.
    READ TABLE IT_ZSAMPINVH INTO WA_ZSAMPINVH WITH KEY GJAHR = WA_ZSAMPINVP-GJAHR VBELN = WA_ZSAMPINVP-VBELN.
    IF SY-SUBRC EQ 0.
      WA_TAB1-COUNT = COUNT.
      CONDENSE WA_TAB1-COUNT.
*      wa_tab1-gjahr = wa_zsampinvp-gjahr.
*      wa_tab1-vbeln = wa_zsampinvp-vbeln.
*      wa_tab1-fkdat = wa_zsampinvp-fkdat.
      CLEAR : TYP.
      SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_ZSAMPINVP-SAMPCODE .
      IF SY-SUBRC EQ 0.
        IF MARA-MTART EQ 'ZDSI'.
          TYP = 'D'.
        ENDIF.
      ENDIF.
      WA_TAB1-TYP = TYP.
      WA_TAB1-CHARG = WA_ZSAMPINVP-CHARG.
*      wa_tab1-lgort = wa_zsampinvp-lgort.
      CLEAR : QTY.
      QTY = WA_ZSAMPINVP-QTY.
      WA_TAB1-QTY = QTY.
      TQTY = TQTY + QTY.
*      wa_tab1-bzirk = wa_zsampinvp-bzirk.
      SELECT SINGLE * FROM MARC WHERE MATNR = WA_ZSAMPINVP-SAMPCODE  AND WERKS = WA_ZSAMPINVH-WERKS.
      IF SY-SUBRC = 0.
        WA_TAB1-STEUC = MARC-STEUC.
      ENDIF.
      SELECT SINGLE * FROM MAKT WHERE MATNR = WA_ZSAMPINVP-SAMPCODE  AND SPRAS EQ 'EN'.
      IF SY-SUBRC = 0.
        WA_TAB1-MAKTX = MAKT-MAKTX.
      ENDIF.
      SELECT SINGLE * FROM MVKE WHERE MATNR = WA_ZSAMPINVP-SAMPCODE AND VKORG EQ '1000' AND VTWEG EQ '80'.
      IF SY-SUBRC = 0.
        SELECT SINGLE * FROM TVM5T WHERE SPRAS EQ 'EN' AND MVGR5 = MVKE-MVGR5.
        IF SY-SUBRC = 0.
          WA_TAB1-BEZEI = TVM5T-BEZEI.
        ENDIF.
      ENDIF.
      CLEAR EXP.
*      select single * from mcha where matnr = wa_zsampinvp-sampcode and charg = wa_zsampinvp-charg and werks = wa_zsampinvh-werks. commented by rushi 19.11.25
*      if sy-subrc = 0.
*        concatenate mcha-vfdat+4(2) '/' mcha-vfdat+0(4) into exp.
*        wa_tab1-exp = exp.
*      endif.
      SELECT SINGLE * FROM IBATCH WHERE MATERIAL EQ  WA_ZSAMPINVP-SAMPCODE AND PLANT EQ WA_ZSAMPINVP-WERKS AND BATCH EQ WA_ZSAMPINVP-CHARG. "added by rushi
      IF SY-SUBRC EQ 0.
        CONCATENATE IBATCH-SHELFLIFEEXPIRATIONDATE+4(2) '/' IBATCH-SHELFLIFEEXPIRATIONDATE+2(2) INTO EXP.
        WA_TAB1-EXP = EXP.
      ENDIF.

      CLEAR : RATE,VALUE.
      SELECT SINGLE * FROM A602 WHERE KSCHL = 'ZSAM'  AND MATNR =  WA_ZSAMPINVP-SAMPCODE AND CHARG =  WA_ZSAMPINVP-CHARG.
      IF SY-SUBRC = 0.
        SELECT SINGLE * FROM KONP WHERE   KSCHL = 'ZSAM' AND KNUMH = A602-KNUMH.
        IF SY-SUBRC = 0.
          RATE = KONP-KBETR.
          VALUE = WA_ZSAMPINVP-QTY *  KONP-KBETR.
          TVALUE = TVALUE + VALUE .
        ENDIF.
      ENDIF.
      WA_TAB1-RATE = RATE.
      WA_TAB1-VALUE = VALUE.
      TAX = 0.
      WA_TAB1-TAX = TAX.
      CONDENSE:   WA_TAB1-RATE ,WA_TAB1-VALUE.
      COLLECT WA_TAB1 INTO IT_TAB1.
      CLEAR WA_TAB1.
      COUNT = COUNT + 1.
    ENDIF.
  ENDLOOP.

  SORT IT_TAB1 BY TYP MAKTX.
  CLEAR : IT_TAB11,WA_TAB11.

************* clear : count,div.
  COUNT = 1.
  LOOP AT IT_TAB1 INTO WA_TAB1.

    WA_TAB11-COUNT = COUNT.
    CONDENSE WA_TAB11-COUNT.


    WA_TAB11-TYP = WA_TAB1-TYP.

    WA_TAB11-CHARG = WA_TAB1-CHARG.

    WA_TAB11-QTY = WA_TAB1-QTY.

    STOTQTY = STOTQTY + WA_TAB1-QTY.

    WA_TAB11-STEUC = WA_TAB1-STEUC.

    WA_TAB11-MAKTX = WA_TAB1-MAKTX.

    WA_TAB11-BEZEI = WA_TAB1-BEZEI.

    WA_TAB11-EXP = WA_TAB1-EXP.

    WA_TAB11-RATE = WA_TAB1-RATE.
    WA_TAB11-VALUE = WA_TAB1-VALUE.
    WA_TAB11-TAX = WA_TAB1-TAX.
    CONDENSE:   WA_TAB11-RATE ,WA_TAB11-VALUE.
    COLLECT WA_TAB11 INTO IT_TAB11.
    CLEAR WA_TAB11.
    COUNT = COUNT + 1.

  ENDLOOP.



*  loop at it_tab1 into wa_tab1.
*    write : / '1',wa_tab1-count,wa_tab1-steuc,wa_tab1-charg,wa_tab1-maktx,wa_tab1-bezei,wa_tab1-exp,wa_tab1-qty,wa_tab1-rate,wa_tab1-value,wa_tab1-tax.
**    wa_tab1-gjahr,wa_tab1-vbeln,wa_tab1-fkdat,wa_tab1-sampcode,wa_tab1-charg,wa_tab1-lgort,wa_tab1-qty,wa_tab1-bzirk,wa_tab1-steuc,
**    wa_tab1-maktx,wa_tab1-bezei,wa_tab1-exp,wa_tab1-rate,wa_tab1-value.
*  endloop.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SUPPREC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SUPPREC .
  DATA : LV_ADRC TYPE ADRC-NAME4.
  CNAME = 'BLUE CROSS LABORATORIES PVT LTD.'.
  CLEAR : DEST1,GSTNO1,REGIO1,NAME1_1,NAME1_2,NAME1_3,NAME1_4, PHONE1_1,LOCAT1.
  CLEAR : ADRC1,ADRC2,ADRC3,ADRC4,ADRC5,PSTLZ,TELNR,STATE,DEST,PSOEMAIL.
  READ TABLE IT_ZSAMPINVH INTO WA_ZSAMPINVH WITH KEY VBELN = WA_CHECK-VBELN GJAHR = WA_CHECK-GJAHR.
  IF SY-SUBRC EQ 0.
*********************SUPPLIER********************

    SELECT SINGLE * FROM T001W WHERE WERKS = WA_ZSAMPINVH-POSTWERKS.
    IF SY-SUBRC EQ 0.
      DEST1 = T001W-ORT01.
      SELECT SINGLE * FROM KNA1 WHERE KUNNR = T001W-KUNNR.
      IF SY-SUBRC EQ 0.
        GSTNO1 = KNA1-STCD3.
        REGIO1 =    KNA1-REGIO.
        NAME1_1 = KNA1-NAME1.
        NAME1_2  = KNA1-STRAS.
        SELECT SINGLE * FROM ADRC WHERE ADDRNUMBER  = KNA1-ADRNR.
        IF SY-SUBRC EQ 0.
*          name1_1 = adrc-name1.
*          name1_2 = adrc-name2.
          NAME1_3 = ADRC-STR_SUPPL1.
          NAME1_4 = ADRC-STR_SUPPL2.
          PHONE1_1 = ADRC-TEL_NUMBER.
          "locat1 =  adrc-extension1.
          "locat1 =  adrc-name4.

        ENDIF.
        SELECT SINGLE NAME4 FROM ADRC INTO LV_ADRC WHERE ADDRNUMBER = T001W-ADRNR.
        IF SY-SUBRC = 0.
          LOCAT1 = LV_ADRC .
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

**************RECEIPIENT DET*******************
  READ TABLE IT_ZSAMPINVH INTO WA_ZSAMPINVH WITH KEY VBELN = WA_CHECK-VBELN GJAHR = WA_CHECK-GJAHR.
  IF SY-SUBRC EQ 0.
    SELECT SINGLE * FROM YTERRALLC WHERE BZIRK EQ WA_ZSAMPINVH-BZIRK AND BEGDA LE WA_ZSAMPINVH-FKDAT AND ENDDA GE WA_ZSAMPINVH-FKDAT.
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM PA0001 WHERE PLANS EQ YTERRALLC-PLANS AND BEGDA LE WA_ZSAMPINVH-FKDAT AND ENDDA GE WA_ZSAMPINVH-FKDAT.
      IF SY-SUBRC EQ 0.
        ENAME = PA0001-ENAME.
        SELECT SINGLE * FROM PA0105 WHERE PERNR EQ PA0001-PERNR AND SUBTY EQ '0010' AND ENDDA GE SY-DATUM.
        IF SY-SUBRC EQ 0.
          PSOEMAIL = PA0105-USRID_LONG.
        ENDIF.
        SELECT SINGLE * FROM PA0006 WHERE PERNR EQ PA0001-PERNR AND SUBTY EQ '1' AND BEGDA LE WA_ZSAMPINVH-FKDAT AND ENDDA GE WA_ZSAMPINVH-FKDAT.
        IF SY-SUBRC EQ 0.
          ADRC1 = PA0006-NAME2.
          ADRC2 = PA0006-STRAS.
          ADRC3 = PA0006-LOCAT.
          ADRC4 = PA0006-ORT01.
          ADRC5 = PA0006-ORT02.
          PSTLZ = PA0006-PSTLZ.
          TELNR = PA0006-TELNR.
          SELECT SINGLE * FROM T005S WHERE LAND1 EQ 'IN' AND BLAND EQ PA0006-STATE.
          IF SY-SUBRC EQ 0.
            STATE = T005S-FPRCD.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
    SELECT SINGLE * FROM ZDRPDEST WHERE BZIRK EQ WA_ZSAMPINVH-BZIRK.
    IF SY-SUBRC EQ 0.
      DEST = ZDRPDEST-ZZ_HQDESC.
    ENDIF.

  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ZMRM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ZMRM .
  CLEAR : IT_RZDSMTER,WA_RZDSMTER,IT_ZZDSMTER,WA_ZZDSMTER.
  CLEAR : RMNAME,ZMNAME,RM,ZM,RMTELNR,ZMTELNR,RMEMAIL,ZMEMAIL.
  CLEAR : DIV.
*  break-point.

  IF BZIRK+0(2) EQ 'R-'.

    RM = BZIRK.
  ELSEIF  BZIRK+0(2) EQ 'Z-'.
    RM = BZIRK.
  ELSEIF BZIRK+0(2) EQ 'D-'.
    ZM = BZIRK.
  ELSEIF BZIRK+0(2) EQ 'G-'.
    ZM = BZIRK.

  ENDIF.
  PERFORM PSODATA.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  TRANSP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM TRANSP .
  READ TABLE IT_ZSAMPINVH INTO WA_ZSAMPINVH WITH KEY VBELN = WA_CHECK-VBELN GJAHR = WA_CHECK-GJAHR.
  IF SY-SUBRC EQ 0.
    SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_ZSAMPINVH-TRANSPORTER.
    IF SY-SUBRC EQ 0.
      TNAME = LFA1-NAME1.
    ENDIF.
  ENDIF.
  LRNO = WA_ZSAMPINVH-LR_NO.
  LRDT = WA_ZSAMPINVH-LR_DT.
  IF ( WA_ZSAMPINVH-END_CASE GT 0 )  OR ( WA_ZSAMPINVH-START_CASE GT 0 ).   "addde on 5.5.24
    CASE = WA_ZSAMPINVH-END_CASE - WA_ZSAMPINVH-START_CASE + 1 .
  ENDIF.
  CONDENSE CASE.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PASSWORD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM PASSW.
*  select single * from zpassw where pernr = pernr.
*  if sy-subrc eq 0.
*
**    IF sy-uname NE zpassw-uname.
**      MESSAGE 'INVALID LOGIN ID' TYPE 'E'.
**    ENDIF.
*    v_en_string = zpassw-password.
**  &———————————————————————** Decryption – String to String*&———————————————————————*
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
**        message 'CORRECT PASSWORD' type 'I'.
*    else.
*      message 'INCORRECT PASSWORD' type 'E'.
*    endif.
*  else.
*    message 'NOT VALID USER' type 'E'.
*    exit.
*  endif.
**    CLEAR : PASS.
**    PASS = '   '.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DELCH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DELCH .
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
*     formname           = 'ZSAMPINV_1'
*     formname           = 'ZSAMPINV_1_A1'
      FORMNAME           = 'ZSAMPINV_1_A11'
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

  SORT IT_CHECK BY VBELN.
  LOOP AT IT_CHECK INTO WA_CHECK.
    CLEAR : VBELN,GJAHR,TVALUE,TOTVAL,TOTVAL1,TOTVAL2,FTEXT1.
    VBELN = WA_CHECK-VBELN.
    GJAHR = WA_CHECK-GJAHR.
    READ TABLE IT_ZSAMPINVH INTO WA_ZSAMPINVH WITH KEY VBELN = WA_CHECK-VBELN GJAHR = WA_CHECK-GJAHR.
    IF SY-SUBRC EQ 0.
      INVDT = WA_ZSAMPINVH-FKDAT.
      BZIRK = WA_ZSAMPINVH-BZIRK.
    ENDIF.
    IF INVDT GE '20231227'.  "NEW FOOTER TEXT
      FTEXT1 = 'N'.
    ENDIF.
    PERFORM FORM1.

    PERFORM SUPPREC.  "SUPPLIER RECEIPIENT DETAILS
    PERFORM ZMRM.
    PERFORM TRANSP.
    PERFORM DIV.
    TTAX = 0.
    TOTTAX = TTAX.
    TOTVAL1 = TVALUE.
    TOTVAL2 = TOTVAL1.
    TOTVAL = TOTVAL2.
    SAMPQTY = STOTQTY.

*          read table it_lstcst into wa_lstcst with key  kunnr  = mkunnr1.
*          if sy-subrc = 0.
*            mcstno1 = wa_lstcst-j_1icstno.
**                      Mlstno = wa_lstcst-j_1ilstno.
**                      CONCATENATE 'DRUG LIC NO. '  wa_invoice-locat ',' MCSTNO ','  MLSTNO INTO wa_invoice-locat.
*          endif.

    CALL FUNCTION V_FM
      EXPORTING
        CONTROL_PARAMETERS = CONTROL
      " user_settings      = 'X'
        OUTPUT_OPTIONS     = W_SSFCOMPOP
        FORMAT             = FORMAT
        VBELN              = VBELN
        GSTNO1             = GSTNO1
        REGIO1             = REGIO1
        NAME1_1            = NAME1_1
        NAME1_2            = NAME1_2
        NAME1_3            = NAME1_3
        NAME1_4            = NAME1_4
        DEST1              = DEST1
        LOCAT1             = LOCAT1
        CNAME              = CNAME
        ADRC1              = ADRC1
        ADRC2              = ADRC2
        ADRC3              = ADRC3
        ADRC4              = ADRC4
        ADRC5              = ADRC5
        PSTLZ              = PSTLZ
        TELNR              = TELNR
        STATE              = STATE
        ENAME              = ENAME
        INVDT              = INVDT
        DEST               = DEST
        ZMNAME             = ZMNAME
        ZMTELNR            = ZMTELNR
        RMNAME             = RMNAME
        RMTELNR            = RMTELNR
        TNAME              = TNAME
        LRNO               = LRNO
        LRDT               = LRDT
        CASE               = CASE
        TOTTAX             = TOTTAX
        TOTVAL             = TOTVAL
        S1                 = S1
        USEMON             = USEMON
        DIV                = DIV
        PAN                = PAN
        SAMPQTY            = SAMPQTY
        FTEXT1             = FTEXT1
        PSOEMAIL             = PSOEMAIL
      TABLES
        IT_TAB1            = IT_TAB11
      EXCEPTIONS
        FORMATTING_ERROR   = 1
        INTERNAL_ERROR     = 2
        SEND_ERROR         = 3
        USER_CANCELED      = 4
        OTHERS             = 5.
    CLEAR : IT_TAB1.
    CLEAR:    FORMAT,VBELN,GSTNO1,REGIO1,NAME1_1,NAME1_2, NAME1_3,NAME1_4,DEST1,LOCAT1,CNAME, ADRC1,ADRC2,ADRC3,ADRC4,ADRC5,PSTLZ,TELNR,STATE,
    ENAME,INVDT, DEST,ZMNAME,ZMTELNR,RMNAME,RMTELNR,TNAME,LRNO,LRDT,CASE, TOTTAX, TOTVAL,DIV,USEMON,PAN,STOTQTY,SAMPQTY.
  ENDLOOP.
  CLEAR : IT_TAB1,IT_TAB11,WA_TAB11,WA_TAB1.
  CALL FUNCTION 'SSF_CLOSE'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PACKLIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM PACKLIST .
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      FORMNAME           = 'ZSAMPINV_PKL2'
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
  SORT IT_CHECK BY VBELN.
  LOOP AT IT_CHECK INTO WA_CHECK.
    CLEAR : VBELN,GJAHR,TVALUE,TOTVAL,TOTVAL1,TOTVAL2,TQTY,TOTQTY.
    VBELN = WA_CHECK-VBELN.
    GJAHR = WA_CHECK-GJAHR.
    READ TABLE IT_ZSAMPINVH INTO WA_ZSAMPINVH WITH KEY VBELN = WA_CHECK-VBELN GJAHR = WA_CHECK-GJAHR.
    IF SY-SUBRC EQ 0.
      INVDT = WA_ZSAMPINVH-FKDAT.
      BZIRK = WA_ZSAMPINVH-BZIRK.
    ENDIF.
    PERFORM FORM1.
    PERFORM DIV.
    SORT IT_TAB1 BY TYP MAKTX.
    PERFORM SUPPREC.  "SUPPLIER RECEIPIENT DETAILS
    PERFORM ZMRM.
    PERFORM TRANSP.
    TTAX = 0.
    TOTTAX = TTAX.
    TOTVAL1 = TVALUE.
    TOTVAL2 = TOTVAL1.
    TOTVAL = TOTVAL2.
    TOTQTY = TQTY.
    IF REG NE '90'.
*      MESSAGE 'PACKING LIST IS ALLOWED ONLY FOR NEPAL' TYPE 'W'.
    ENDIF.

*          read table it_lstcst into wa_lstcst with key  kunnr  = mkunnr1.
*          if sy-subrc = 0.
*            mcstno1 = wa_lstcst-j_1icstno.
**                      Mlstno = wa_lstcst-j_1ilstno.
**                      CONCATENATE 'DRUG LIC NO. '  wa_invoice-locat ',' MCSTNO ','  MLSTNO INTO wa_invoice-locat.
*          endif.

    CALL FUNCTION V_FM
      EXPORTING
        CONTROL_PARAMETERS = CONTROL
      " user_settings      = 'X'
        OUTPUT_OPTIONS     = W_SSFCOMPOP
        FORMAT             = FORMAT
        VBELN              = VBELN
        GSTNO1             = GSTNO1
        REGIO1             = REGIO1
        NAME1_1            = NAME1_1
        NAME1_2            = NAME1_2
        NAME1_3            = NAME1_3
        NAME1_4            = NAME1_4
        DEST1              = DEST1
        LOCAT1             = LOCAT1
        CNAME              = CNAME
        ADRC1              = ADRC1
        ADRC2              = ADRC2
        ADRC3              = ADRC3
        ADRC4              = ADRC4
        ADRC5              = ADRC5
        PSTLZ              = PSTLZ
        TELNR              = TELNR
        STATE              = STATE
        ENAME              = ENAME
        INVDT              = INVDT
        DEST               = DEST
        ZMNAME             = ZMNAME
        ZMTELNR            = ZMTELNR
        RMNAME             = RMNAME
        RMTELNR            = RMTELNR
        TNAME              = TNAME
        LRNO               = LRNO
        LRDT               = LRDT
        CASE               = CASE
        TOTTAX             = TOTTAX
        TOTVAL             = TOTVAL
        S1                 = S1
        DIV                = DIV
        USEMON             = USEMON
        TOTQTY             = TOTQTY
      TABLES
        IT_TAB1            = IT_TAB1
      EXCEPTIONS
        FORMATTING_ERROR   = 1
        INTERNAL_ERROR     = 2
        SEND_ERROR         = 3
        USER_CANCELED      = 4
        OTHERS             = 5.
    CLEAR : IT_TAB1.
    CLEAR:    FORMAT,VBELN,GSTNO1,REGIO1,NAME1_1,NAME1_2, NAME1_3,NAME1_4,DEST1,LOCAT1,CNAME, ADRC1,ADRC2,ADRC3,ADRC4,ADRC5,PSTLZ,TELNR,STATE,
    ENAME,INVDT, DEST,ZMNAME,ZMTELNR,RMNAME,RMTELNR,TNAME,LRNO,LRDT,CASE, TOTTAX, TOTVAL, TQTY,TOTQTY,DIV,USEMON.
  ENDLOOP.
  CLEAR : IT_TAB1.
  CALL FUNCTION 'SSF_CLOSE'.
  "call function 'SSF_CLOSE'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DRUGLIC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  DIV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DIV .
  CLEAR: USEMON.
  READ TABLE IT_ZSAMPINVH INTO WA_ZSAMPINVH WITH KEY GJAHR = WA_ZSAMPINVP-GJAHR VBELN = WA_ZSAMPINVP-VBELN.
  IF SY-SUBRC EQ 0.
    SELECT SINGLE * FROM T247 WHERE SPRAS EQ 'EN' AND MNR EQ WA_ZSAMPINVH-USED_MTH.
    IF SY-SUBRC EQ 0.
      CONCATENATE T247-KTX WA_ZSAMPINVH-USED_YEAR INTO USEMON SEPARATED BY SPACE.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ALV .
  PERFORM FORM2.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FORM2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FORM2 .

  LOOP AT IT_ZSAMPINVP INTO WA_ZSAMPINVP.
    READ TABLE IT_ZSAMPINVH INTO WA_ZSAMPINVH WITH KEY GJAHR = WA_ZSAMPINVP-GJAHR VBELN = WA_ZSAMPINVP-VBELN.
    IF SY-SUBRC EQ 0.
      WA_DISP1-VBELN = WA_ZSAMPINVH-VBELN.
      WA_DISP1-FKDAT = WA_ZSAMPINVH-FKDAT.
      WA_DISP1-SAMPCODE = WA_ZSAMPINVP-SAMPCODE.
      WA_DISP1-CHARG = WA_ZSAMPINVP-CHARG.
      CLEAR EXP.
*      select single * from mcha where matnr = wa_zsampinvp-sampcode and charg = wa_zsampinvp-charg and werks = wa_zsampinvh-werks. comment by rushi 19.11.25
*      if sy-subrc = 0.
*        concatenate mcha-vfdat+4(2) '/' mcha-vfdat+0(4) into exp.
*        wa_tab1-exp = exp.
*      endif.

      SELECT SINGLE * FROM IBATCH WHERE MATERIAL EQ  WA_ZSAMPINVP-SAMPCODE AND PLANT EQ WA_ZSAMPINVH-WERKS AND BATCH EQ WA_ZSAMPINVP-CHARG. " added by rushi
      IF SY-SUBRC EQ 0.
        CONCATENATE IBATCH-SHELFLIFEEXPIRATIONDATE+4(2) '/' IBATCH-SHELFLIFEEXPIRATIONDATE+2(2) INTO EXP.
        WA_TAB1-EXP = EXP.
      ENDIF.

      WA_DISP1-EXP = EXP.
      WA_DISP1-QTY = WA_ZSAMPINVP-QTY.
      SELECT SINGLE * FROM MAKT WHERE MATNR = WA_ZSAMPINVP-SAMPCODE  AND SPRAS EQ 'EN'.
      IF SY-SUBRC = 0.
        WA_DISP1-MAKTX = MAKT-MAKTX.
      ENDIF.
      SELECT SINGLE * FROM YTERRALLC WHERE BZIRK EQ WA_ZSAMPINVH-BZIRK AND BEGDA LE WA_ZSAMPINVH-FKDAT AND ENDDA GE WA_ZSAMPINVH-FKDAT.
      IF SY-SUBRC EQ 0.
        SELECT SINGLE * FROM PA0001 WHERE PLANS EQ YTERRALLC-PLANS AND BEGDA LE WA_ZSAMPINVH-FKDAT AND ENDDA GE WA_ZSAMPINVH-FKDAT.
        IF SY-SUBRC EQ 0.
          WA_DISP1-ENAME = PA0001-ENAME.
          WA_DISP1-PERNR = PA0001-PERNR.
        ENDIF.
      ENDIF.
      SELECT SINGLE * FROM MARC WHERE MATNR = WA_ZSAMPINVP-SAMPCODE  AND WERKS = WA_ZSAMPINVH-WERKS.
      IF SY-SUBRC = 0.
        WA_DISP1-STEUC = MARC-STEUC.
      ENDIF.
      CLEAR : BOX.
      SELECT SINGLE * FROM MARM WHERE MATNR = WA_ZSAMPINVP-SAMPCODE AND MEINH = 'BOX'.
      IF SY-SUBRC EQ 0.
        BOX = MARM-UMREZ / MARM-UMREN.
        WA_DISP1-BOX = BOX.
        CONDENSE WA_DISP1-BOX.
      ENDIF.

      SELECT SINGLE * FROM MARM WHERE MATNR = WA_ZSAMPINVP-SAMPCODE AND MEINH = 'SPR'.
      IF SY-SUBRC EQ 0.
        WA_DISP1-SPR = MARM-UMREZ.
        CONDENSE WA_DISP1-SPR.
      ENDIF.
      IF WA_DISP1-BOX GT 0.
        BOXNO = WA_DISP1-QTY / WA_DISP1-BOX.
        WA_DISP1-BOXNO = BOXNO.
*        condense wa_disp1-boxno.
      ENDIF.
      IF WA_DISP1-SPR GT 0.
        SPRNO = WA_DISP1-QTY / WA_DISP1-SPR.
        WA_DISP1-SPRNO = SPRNO.
*        condense wa_disp1-sprno.
      ENDIF.

      COLLECT WA_DISP1 INTO IT_DISP1.
      CLEAR WA_DISP1.
    ENDIF.
  ENDLOOP.

  WA_FIELDCAT-FIELDNAME = 'VBELN'.
  WA_FIELDCAT-SELTEXT_L = 'INVOICE'.
  APPEND WA_FIELDCAT TO FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'FKDAT'.
  WA_FIELDCAT-SELTEXT_L = 'INV. DATE'.
  APPEND WA_FIELDCAT TO FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'PERNR'.
  WA_FIELDCAT-SELTEXT_L = 'EMPLOYEE CODE'.
  APPEND WA_FIELDCAT TO FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'ENAME'.
  WA_FIELDCAT-SELTEXT_L = 'EMPLOYEE NAME'.
  APPEND WA_FIELDCAT TO FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'SAMPCODE'.
  WA_FIELDCAT-SELTEXT_L = 'PRD CODE'.
  APPEND WA_FIELDCAT TO FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'MAKTX'.
  WA_FIELDCAT-SELTEXT_L = 'PRD NAME'.
  APPEND WA_FIELDCAT TO FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'CHARG'.
  WA_FIELDCAT-SELTEXT_L = 'BATCH'.
  APPEND WA_FIELDCAT TO FIELDCAT.
  CLEAR WA_FIELDCAT.


  WA_FIELDCAT-FIELDNAME = 'QTY'.
  WA_FIELDCAT-SELTEXT_L = 'QUANTITY'.
  APPEND WA_FIELDCAT TO FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'BOX'.
  WA_FIELDCAT-SELTEXT_L = 'BOX SIZE'.
  APPEND WA_FIELDCAT TO FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'BOXNO'.
  WA_FIELDCAT-SELTEXT_L = 'BOX NUMBER'.
  APPEND WA_FIELDCAT TO FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'SPR'.
  WA_FIELDCAT-SELTEXT_L = 'SHIPPER SIZE'.
  APPEND WA_FIELDCAT TO FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'SPRNO'.
  WA_FIELDCAT-SELTEXT_L = 'SHIPPER NUMBER'.
  APPEND WA_FIELDCAT TO FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'EXP'.
  WA_FIELDCAT-SELTEXT_L = 'EXPIRY'.
  APPEND WA_FIELDCAT TO FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'STEUC'.
  WA_FIELDCAT-SELTEXT_L = 'HSN CODE'.
  APPEND WA_FIELDCAT TO FIELDCAT.
  CLEAR WA_FIELDCAT.

  LAYOUT-ZEBRA = 'X'.
  LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
  LAYOUT-WINDOW_TITLEBAR  = 'SAMPLE INVOICE DETAILS'.


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
      T_OUTTAB                = IT_DISP1
    EXCEPTIONS
      PROGRAM_ERROR           = 1
      OTHERS                  = 2.
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.                    "SUMMARY

*&---------------------------------------------------------------------*
*&      Form  TOP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM TOP.

  DATA: COMMENT    TYPE SLIS_T_LISTHEADER,
        WA_COMMENT LIKE LINE OF COMMENT.

  WA_COMMENT-TYP = 'A'.
  WA_COMMENT-INFO = 'SAMPLE INVOICE DETAILS'.
*  WA_COMMENT-INFO = P_FRMDT.
  APPEND WA_COMMENT TO COMMENT.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = COMMENT
*     I_LOGO             = 'ENJOYSAP_LOGO'
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .

  CLEAR COMMENT.

ENDFORM.                    "TOP



*&---------------------------------------------------------------------*
*&      Form  USER_COMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->UCOMM      text
*      -->SELFIELD   text
*----------------------------------------------------------------------*
FORM USER_COMM USING UCOMM LIKE SY-UCOMM
                     SELFIELD TYPE SLIS_SELFIELD.



  CASE SELFIELD-FIELDNAME.
    WHEN 'VBELN'.
      SET PARAMETER ID 'VF' FIELD SELFIELD-VALUE.
      CALL TRANSACTION 'VF03' AND SKIP FIRST SCREEN.
    WHEN 'VBELN1'.
      SET PARAMETER ID 'BV' FIELD SELFIELD-VALUE.
      CALL TRANSACTION 'VL03N' AND SKIP FIRST SCREEN.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.                    "USER_COMM
*&---------------------------------------------------------------------*
*&      Form  DELCHEMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DELCHEMAIL .
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
*     formname           = 'ZSAMPINV_1'
*     formname           = 'ZSAMPINV_1_A1'
      FORMNAME           = 'ZSAMPINV_1_A11'
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
      FM_NAME            = V_FM
    EXCEPTIONS
      NO_FORM            = 1
      NO_FUNCTION_MODULE = 2
      OTHERS             = 3.

* *   * Set the control parameter
  W_CTRLOP-GETOTF = ABAP_TRUE.
  W_CTRLOP-NO_DIALOG = ABAP_TRUE.
  W_COMPOP-TDNOPREV = ABAP_TRUE.
  W_CTRLOP-PREVIEW = SPACE.
*  w_compop-tddest = 'LOCL'.


*  call function 'SSF_OPEN'
*    exporting
*      control_parameters = control.

  SORT IT_CHECK BY VBELN.
  LOOP AT IT_CHECK INTO WA_CHECK.
    CLEAR : VBELN,GJAHR,TVALUE,TOTVAL,TOTVAL1,TOTVAL2,FTEXT1.
    VBELN = WA_CHECK-VBELN.
    GJAHR = WA_CHECK-GJAHR.
    READ TABLE IT_ZSAMPINVH INTO WA_ZSAMPINVH WITH KEY VBELN = WA_CHECK-VBELN GJAHR = WA_CHECK-GJAHR.
    IF SY-SUBRC EQ 0.
      INVDT = WA_ZSAMPINVH-FKDAT.
      BZIRK = WA_ZSAMPINVH-BZIRK.
    ENDIF.
    IF INVDT GE '20231227'.  "NEW FOOTER TEXT
      FTEXT1 = 'N'.
    ENDIF.
    PERFORM FORM1.
    SORT IT_TAB1 BY TYP MAKTX.
    PERFORM SUPPREC.  "SUPPLIER RECEIPIENT DETAILS
    PERFORM ZMRM.
    PERFORM TRANSP.
    PERFORM DIV.
    TTAX = 0.
    TOTTAX = TTAX.
    TOTVAL1 = TVALUE.
    TOTVAL2 = TOTVAL1.
    TOTVAL = TOTVAL2.

*          read table it_lstcst into wa_lstcst with key  kunnr  = mkunnr1.
*          if sy-subrc = 0.
*            mcstno1 = wa_lstcst-j_1icstno.
**                      Mlstno = wa_lstcst-j_1ilstno.
**                      CONCATENATE 'DRUG LIC NO. '  wa_invoice-locat ',' MCSTNO ','  MLSTNO INTO wa_invoice-locat.
*          endif.

    CALL FUNCTION V_FM
      EXPORTING
        CONTROL_PARAMETERS = W_CTRLOP
        OUTPUT_OPTIONS     = W_COMPOP
        USER_SETTINGS      = ABAP_TRUE
        FORMAT             = FORMAT
        VBELN              = VBELN
        GSTNO1             = GSTNO1
        REGIO1             = REGIO1
        NAME1_1            = NAME1_1
        NAME1_2            = NAME1_2
        NAME1_3            = NAME1_3
        NAME1_4            = NAME1_4
        DEST1              = DEST1
        LOCAT1             = LOCAT1
        CNAME              = CNAME
        ADRC1              = ADRC1
        ADRC2              = ADRC2
        ADRC3              = ADRC3
        ADRC4              = ADRC4
        ADRC5              = ADRC5
        PSTLZ              = PSTLZ
        TELNR              = TELNR
        STATE              = STATE
        ENAME              = ENAME
        INVDT              = INVDT
        DEST               = DEST
        ZMNAME             = ZMNAME
        ZMTELNR            = ZMTELNR
        RMNAME             = RMNAME
        RMTELNR            = RMTELNR
        TNAME              = TNAME
        LRNO               = LRNO
        LRDT               = LRDT
        CASE               = CASE
        TOTTAX             = TOTTAX
        TOTVAL             = TOTVAL
        S1                 = S1
        USEMON             = USEMON
        DIV                = DIV
        PAN                = PAN
        SAMPQTY            = SAMPQTY
        FTEXT1             = FTEXT1
        PSOEMAIL             = PSOEMAIL
      IMPORTING
        JOB_OUTPUT_INFO    = W_RETURN " This will have all output
      TABLES
        IT_TAB1            = IT_TAB1
      EXCEPTIONS
        FORMATTING_ERROR   = 1
        INTERNAL_ERROR     = 2
        SEND_ERROR         = 3
        USER_CANCELED      = 4
        OTHERS             = 5.

    I_OTF[] = W_RETURN-OTFDATA[].

* Import Binary file and filesize
    CALL FUNCTION 'CONVERT_OTF'
      EXPORTING
        FORMAT                = 'PDF'
        MAX_LINEWIDTH         = 132
      IMPORTING
        BIN_FILESIZE          = V_LEN_IN
        BIN_FILE              = I_XSTRING   " This is NOT Binary. This is Hexa
      TABLES
        OTF                   = I_OTF
        LINES                 = I_TLINE
      EXCEPTIONS
        ERR_MAX_LINEWIDTH     = 1
        ERR_FORMAT            = 2
        ERR_CONV_NOT_POSSIBLE = 3
        OTHERS                = 4.
* Sy-subrc check not checked



*  * Convert Hexa String to Binary format
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        BUFFER     = I_XSTRING
      TABLES
        BINARY_TAB = I_OBJBIN[].
* Sy-subrc check not required.

*    DATA: IN_MAILID TYPE AD_SMTPADR.

* Begin of sending email to multiple users
* If business want email to be sent to all users at one time, it can be done

* For now we do not want to send 1 email to multiple users
* Mail has to be sent one email at a time

*  IF P2 EQ 'X'.
*
*      CLEAR IN_MAILID.
    IF R11 EQ 'X'.
      IF PSOEMAIL IS NOT INITIAL.
        IN_MAILID = PSOEMAIL.
        PERFORM SEND_MAIL USING IN_MAILID .
      ENDIF.
      IF RMEMAIL IS NOT INITIAL.
        IN_MAILID = RMEMAIL.
        PERFORM SEND_MAIL USING IN_MAILID .
      ENDIF.
      IF ZMEMAIL IS NOT INITIAL.
        IN_MAILID = ZMEMAIL.
        PERFORM SEND_MAIL USING IN_MAILID .
      ENDIF.
    ELSEIF R12 EQ 'X'.
      IF EMAIL IS NOT INITIAL.
        IN_MAILID = EMAIL.
        PERFORM SEND_MAIL USING IN_MAILID .
      ENDIF.
    ENDIF.
*    in_mailid = 'JYOTSNA@BLUECROSSLABS.COM'.
*    perform send_mail using in_mailid .
*    in_mailid = 'EDP_NSK@BLUECROSSLABS.COM'.
*    perform send_mail using in_mailid .
    CLEAR : IT_TAB1.
    CLEAR:    FORMAT,VBELN,GSTNO1,REGIO1,NAME1_1,NAME1_2, NAME1_3,NAME1_4,DEST1,LOCAT1,CNAME, ADRC1,ADRC2,ADRC3,ADRC4,ADRC5,PSTLZ,TELNR,STATE,
    ENAME,INVDT, DEST,ZMNAME,ZMTELNR,RMNAME,RMTELNR,TNAME,LRNO,LRDT,CASE, TOTTAX, TOTVAL .
  ENDLOOP.
  CLEAR : IT_TAB1.
*  call function 'SSF_CLOSE'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SEND_MAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IN_MAILID  text
*----------------------------------------------------------------------*
FORM SEND_MAIL  USING    P_IN_MAILID.
  DATA: SALUTATION TYPE STRING.
  DATA: BODY TYPE STRING.
  DATA: FOOTER TYPE STRING.

  DATA: LO_SEND_REQUEST TYPE REF TO CL_BCS,
        LO_DOCUMENT     TYPE REF TO CL_DOCUMENT_BCS,
        LO_SENDER       TYPE REF TO IF_SENDER_BCS,
        LO_RECIPIENT    TYPE REF TO IF_RECIPIENT_BCS VALUE IS INITIAL,LT_MESSAGE_BODY TYPE BCSY_TEXT,
        LX_DOCUMENT_BCS TYPE REF TO CX_DOCUMENT_BCS,
        LV_SENT_TO_ALL  TYPE OS_BOOLEAN.

  "create send request
  LO_SEND_REQUEST = CL_BCS=>CREATE_PERSISTENT( ).

  "create message body and subject
  SALUTATION ='Dear Sir/Madam,'.
  APPEND SALUTATION TO LT_MESSAGE_BODY.
  APPEND INITIAL LINE TO LT_MESSAGE_BODY.
*  IF r4 EQ 'X'.
  BODY = 'Please find the attached SAMPLE DELIVERY CHALLAN in PDF format.'.
*  ELSEIF r6 EQ 'X'.
*    body = 'Please find the attached Detail for QC REJECTION in PDF format.'.
*  ELSE.
*    body = 'Please find the attached INSPECTION LOTS in PDF format.'.
*  ENDIF.
  APPEND BODY TO LT_MESSAGE_BODY.
  APPEND INITIAL LINE TO LT_MESSAGE_BODY.

  FOOTER = 'With Regards,'.
  APPEND FOOTER TO LT_MESSAGE_BODY.
  FOOTER = 'BLUE CROSS LABORATORIES PVT LTD.'.
  APPEND FOOTER TO LT_MESSAGE_BODY.

*  IF r4 EQ 'X'.
  NTEXT1 = 'SAMPLE DELIVERY CHALLAN'.
*  ELSEIF r6 EQ 'X'.
*    ntext1 = 'REJECTION DONE BY QUALITY CONTROL'.
*  ELSE.
*    ntext1 = 'INSPECTION PLAN NOT ATTACHED'.
*  ENDIF.
  "put your text into the document

*  IF r4 EQ 'X'.
*    lo_document = cl_document_bcs=>create_document(
*  i_type = 'RAW'
*  i_text = lt_message_body
*  i_subject = 'HALB LYING FOR MORE THAN 20 DAYS' ).
*
**DATA: l_size TYPE sood-objlen. " Size of Attachment
**l_size = l_lines * 255.
*    TRY.
*
*        lo_document->add_attachment(
*        EXPORTING
*        i_attachment_type = 'PDF'
*        i_attachment_subject = 'HALB LYING FOR MORE THAN 20 DAYS'
*        i_att_content_hex = i_objbin[] ).
*      CATCH cx_document_bcs INTO lx_document_bcs.
*
*    ENDTRY.
*  ELSEIF r6 EQ 'X'.
*    lo_document = cl_document_bcs=>create_document(
*  i_type = 'RAW'
*  i_text = lt_message_body
*  i_subject = 'REJECTION BY QUALITY CONTROL' ).
*
**DATA: l_size TYPE sood-objlen. " Size of Attachment
**l_size = l_lines * 255.
*    TRY.
*
*        lo_document->add_attachment(
*        EXPORTING
*        i_attachment_type = 'PDF'
*        i_attachment_subject = 'REJECTION BY QUALITY CONTROL'
*        i_att_content_hex = i_objbin[] ).
*      CATCH cx_document_bcs INTO lx_document_bcs.
*
*    ENDTRY.
*
*  ELSE.
  LO_DOCUMENT = CL_DOCUMENT_BCS=>CREATE_DOCUMENT(
    I_TYPE    = 'RAW'
    I_TEXT    = LT_MESSAGE_BODY
    I_SUBJECT = 'SAMPLE DELIVERY CHALLAN' ).

*DATA: l_size TYPE sood-objlen. " Size of Attachment
*l_size = l_lines * 255.
  TRY.

      LO_DOCUMENT->ADD_ATTACHMENT(
        EXPORTING
          I_ATTACHMENT_TYPE    = 'PDF'
          I_ATTACHMENT_SUBJECT = 'SAMPLE DELIVERY CHALLAN'
          I_ATT_CONTENT_HEX    = I_OBJBIN[] ).
    CATCH CX_DOCUMENT_BCS INTO LX_DOCUMENT_BCS.

  ENDTRY.

*  ENDIF.

* Add attachment
* Pass the document to send request
  LO_SEND_REQUEST->SET_DOCUMENT( LO_DOCUMENT ).

  "Create sender
  LO_SENDER = CL_SAPUSER_BCS=>CREATE( SY-UNAME ).

  "Set sender
  LO_SEND_REQUEST->SET_SENDER( LO_SENDER ).

  "Create recipient
  LO_RECIPIENT = CL_CAM_ADDRESS_BCS=>CREATE_INTERNET_ADDRESS( IN_MAILID ).

*Set recipient
  LO_SEND_REQUEST->ADD_RECIPIENT(
    EXPORTING
      I_RECIPIENT = LO_RECIPIENT
      I_EXPRESS   = ABAP_TRUE
  ).

  LO_SEND_REQUEST->ADD_RECIPIENT( LO_RECIPIENT ).

* Send email
  LO_SEND_REQUEST->SEND(
    EXPORTING
      I_WITH_ERROR_SCREEN = ABAP_TRUE
    RECEIVING
      RESULT              = LV_SENT_TO_ALL ).

  CONCATENATE 'Email sent to' IN_MAILID INTO DATA(LV_MSG) SEPARATED BY SPACE.
  WRITE:/ LV_MSG COLOR COL_POSITIVE.
  SKIP.
* Commit Work to send the email
  COMMIT WORK.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PSODATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM PSODATA .
  SELECT * FROM ZDSMTER INTO TABLE IT_RZDSMTER WHERE ZMONTH EQ INVDT+4(2) AND ZYEAR EQ INVDT+0(4) AND BZIRK EQ BZIRK.
  READ TABLE IT_ZSAMPINVH INTO WA_ZSAMPINVH WITH KEY VBELN = WA_CHECK-VBELN GJAHR = WA_CHECK-GJAHR.
  IF SY-SUBRC EQ 0.
    READ TABLE IT_RZDSMTER INTO WA_RZDSMTER WITH KEY BZIRK = BZIRK ZDSM+0(2) = 'R-'.
    IF SY-SUBRC EQ 0.
      RM = WA_RZDSMTER-ZDSM.
      SELECT SINGLE * FROM YTERRALLC WHERE BZIRK EQ WA_RZDSMTER-ZDSM AND BEGDA LE WA_ZSAMPINVH-FKDAT AND ENDDA GE WA_ZSAMPINVH-FKDAT.
      IF SY-SUBRC EQ 0.
        SELECT SINGLE * FROM PA0001 WHERE PLANS EQ YTERRALLC-PLANS AND BEGDA LE WA_ZSAMPINVH-FKDAT AND ENDDA GE WA_ZSAMPINVH-FKDAT.
        IF SY-SUBRC EQ 0.
          RMNAME = PA0001-ENAME.
          SELECT SINGLE * FROM PA0105 WHERE PERNR EQ PA0001-PERNR AND SUBTY EQ '0010' AND ENDDA GE SY-DATUM.
          IF SY-SUBRC EQ 0.
            RMEMAIL = PA0105-USRID_LONG.
          ENDIF.
          SELECT SINGLE * FROM PA0006 WHERE PERNR EQ PA0001-PERNR AND SUBTY EQ '1' AND BEGDA LE WA_ZSAMPINVH-FKDAT AND ENDDA GE WA_ZSAMPINVH-FKDAT.
          IF SY-SUBRC EQ 0.
            RMTELNR = PA0006-TELNR.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    CLEAR : DCOUNT.

*    READ TABLE IT_RZDSMTER INTO WA_RZDSMTER WITH KEY BZIRK = BZIRK SPART = '50'.
*    IF SY-SUBRC EQ 0.
*      READ TABLE IT_RZDSMTER INTO WA_RZDSMTER WITH KEY BZIRK = BZIRK SPART = '60'.
*      IF SY-SUBRC EQ 0.
*        DIV = 'BCL'.
*      ELSE.
*        DIV = 'BC'.
*      ENDIF.
*    ELSE.
*      DIV = 'XL'.
*    ENDIF.

    READ TABLE IT_RZDSMTER INTO WA_RZDSMTER WITH KEY BZIRK = BZIRK SPART = '50'.
    IF SY-SUBRC EQ 0.
      DIV = 'BC'.
      DCOUNT = DCOUNT + 1.
    ENDIF.
    READ TABLE IT_RZDSMTER INTO WA_RZDSMTER WITH KEY BZIRK = BZIRK SPART = '60'.
    IF SY-SUBRC EQ 0.
      DIV = 'XL'.
      DCOUNT = DCOUNT + 1.
    ENDIF.
    READ TABLE IT_RZDSMTER INTO WA_RZDSMTER WITH KEY BZIRK = BZIRK SPART = '70'.
    IF SY-SUBRC EQ 0.
      DIV = 'LS'.
      DCOUNT = DCOUNT + 1.
    ENDIF.
    IF DCOUNT GT 1.
      DIV = 'BCL'.
    ENDIF.

  ENDIF.
*************pan no****************
  CLEAR : PAN,REG.
  SELECT SINGLE * FROM YTERRALLC WHERE BZIRK EQ WA_ZSAMPINVH-BZIRK AND BEGDA LE WA_ZSAMPINVH-FKDAT AND ENDDA GE WA_ZSAMPINVH-FKDAT.
  IF SY-SUBRC EQ 0.
    SELECT SINGLE * FROM PA0001 WHERE PLANS EQ YTERRALLC-PLANS AND ENDDA GE SY-DATUM.
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM PA0185 WHERE PERNR EQ PA0001-PERNR AND SUBTY EQ '02' AND ENDDA GE SY-DATUM.
      IF SY-SUBRC EQ 0.
        PAN = PA0185-ICNUM.
      ENDIF.
      SELECT SINGLE * FROM PA0006 WHERE PERNR EQ PA0001-PERNR AND STATE NE SPACE AND ENDDA GE SY-DATUM.
      IF SY-SUBRC EQ 0.
        REG = PA0006-STATE.
      ENDIF.
    ENDIF.
  ENDIF.
************ZM**************
  SELECT * FROM ZDSMTER INTO TABLE IT_ZZDSMTER WHERE ZMONTH EQ INVDT+4(2) AND ZYEAR EQ INVDT+0(4) AND BZIRK EQ RM.

  READ TABLE IT_ZSAMPINVH INTO WA_ZSAMPINVH WITH KEY VBELN = WA_CHECK-VBELN GJAHR = WA_CHECK-GJAHR.
  IF SY-SUBRC EQ 0.

    READ TABLE IT_ZZDSMTER INTO WA_ZZDSMTER WITH KEY BZIRK = RM ZDSM+0(2) = 'D-'.
    IF SY-SUBRC EQ 0.
*      ZM = WA_RZDSMTER-ZDSM.
      ZM = WA_ZZDSMTER-ZDSM.
      SELECT SINGLE * FROM YTERRALLC WHERE BZIRK EQ WA_ZZDSMTER-ZDSM AND BEGDA LE WA_ZSAMPINVH-FKDAT AND ENDDA GE WA_ZSAMPINVH-FKDAT.
      IF SY-SUBRC EQ 0.
        SELECT SINGLE * FROM PA0001 WHERE PLANS EQ YTERRALLC-PLANS AND BEGDA LE WA_ZSAMPINVH-FKDAT AND ENDDA GE WA_ZSAMPINVH-FKDAT.
        IF SY-SUBRC EQ 0.
          ZMNAME = PA0001-ENAME.
          SELECT SINGLE * FROM PA0105 WHERE PERNR EQ PA0001-PERNR AND SUBTY EQ '0010' AND ENDDA GE SY-DATUM.
          IF SY-SUBRC EQ 0.
            ZMEMAIL = PA0105-USRID_LONG.
          ENDIF.
          SELECT SINGLE * FROM PA0006 WHERE PERNR EQ PA0001-PERNR AND SUBTY EQ '1' AND BEGDA LE WA_ZSAMPINVH-FKDAT AND ENDDA GE WA_ZSAMPINVH-FKDAT.
          IF SY-SUBRC EQ 0.
            ZMTELNR = PA0006-TELNR.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

  IF ZM EQ 'D-KOL' OR ZM EQ 'D-KOL1'.  "7.12.023
    CLEAR PAN.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  RMDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
