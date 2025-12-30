*&---------------------------------------------------------------------*
*& Report  ZDOMINV_GST1_NEW13_NEW3_NEW4
*& developed by Jyotsna
***restrict print if no accounting entry on 6.6.25
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ZDOMINV_GST1_NEW13_NEW3_N2.
TABLES: VBRK,
        VBRP,
        MVKE,
        TVM5T,
        MCHA,
        A602,
        KONP,
*        konv,
        MARC,
        MARM,
        KNA1,
        ADRC,
        T001W,
        VBAK,
        J_1IMOCUST,
        VBPA,
        ZUPLOAD,
        STXH,
        BSAD,
        BSEG,
        T685T,
        MARA,
        BSID,
        MAKT,ADR6,
        YTERRALLC,
        PA0001,
        PA0105,
        ZT001W,
        J_1IG_EWAYBILL,
        ZNLEM,
        ZEWAY_LIMIT,
        ZTRANSPORT,
        BKPF,
        PRCD_ELEMENTS,
        IBATCH,
        LFA1,
        MCH1.


*********************   email variables
DATA :  RESULT      LIKE  ITCPP.
DATA : OPTIONS        TYPE ITCPO,
       L_OTF_DATA     LIKE ITCOO OCCURS 10,
       L_ASC_DATA     LIKE TLINE OCCURS 10,
       L_DOCS         LIKE DOCS  OCCURS 10,
       L_PDF_DATA     LIKE SOLISTI1 OCCURS 10,
       L_PDF_DATA1    LIKE SOLISTI1 OCCURS 10,
       L_BIN_FILESIZE TYPE I.

DATA: DOCDATA LIKE SOLISTI1  OCCURS  10,
      OBJHEAD LIKE SOLISTI1  OCCURS  1,
      OBJBIN1 LIKE SOLISTI1  OCCURS 10,
      OBJBIN  LIKE SOLISTI1  OCCURS 10.

DATA RIGHE_ATTACHMENT TYPE I.
DATA RIGHE_TESTO TYPE I.
DATA: DOC_CHNG LIKE SODOCCHGI1.
DATA: LTX LIKE T247-LTX.
DATA RECLIST    LIKE SOMLRECI1  OCCURS  1 WITH HEADER LINE.
DATA MCOUNT TYPE I.
DATA CNT TYPE I.
DATA: TCS TYPE KONP-KBETR.

DATA  BEGIN OF OBJPACK OCCURS 0 .
INCLUDE STRUCTURE  SOPCKLSTI1.
DATA END OF OBJPACK.

DATA BEGIN OF OBJTXT OCCURS 0.
INCLUDE STRUCTURE SOLISTI1.
DATA END OF OBJTXT.


DATA : V_ADRNR LIKE VBPA-ADRNR.




*********************   email variables  end
*






DATA : IT_VBRK TYPE TABLE OF VBRK WITH HEADER LINE,
       WA_VBRK TYPE VBRK,
       IT_VBRP TYPE TABLE OF VBRP,
       WA_VBRP TYPE VBRP.

TYPES : BEGIN OF ST_CHECK,
          VBELN TYPE VBRK-VBELN,
          KUNAG TYPE VBRK-KUNAG,
        END OF ST_CHECK.

DATA : IT_CHECK  TYPE TABLE OF ST_CHECK,
       WA_CHECK  TYPE          ST_CHECK,
       IT_CHECK1 TYPE TABLE OF ST_CHECK,
       WA_CHECK1 TYPE          ST_CHECK.

*TYPES: BEGIN OF typ_konv,
*         knumv LIKE konv-knumv,
*         kposn LIKE konv-kposn,
*         stunr LIKE konv-stunr,
*         zaehk LIKE konv-zaehk,
*         kschl LIKE konv-kschl,
*         krech LIKE konv-krech,
*         kawrt LIKE konv-kawrt,
*         kbetr LIKE konv-kbetr,
*         kwert LIKE konv-kwert,
*       END OF typ_konv.

TYPES: BEGIN OF TYP_KONV,
         KNUMV LIKE PRCD_ELEMENTS-KNUMV,
         KPOSN LIKE PRCD_ELEMENTS-KPOSN,
         STUNR LIKE PRCD_ELEMENTS-STUNR,
         ZAEHK LIKE PRCD_ELEMENTS-ZAEHK,
         KSCHL LIKE PRCD_ELEMENTS-KSCHL,
         KRECH LIKE PRCD_ELEMENTS-KRECH,
         KAWRT LIKE PRCD_ELEMENTS-KAWRT,
         KBETR TYPE KBETR,
         KWERT LIKE PRCD_ELEMENTS-KWERT,
       END OF TYP_KONV.

DATA : IT_KONV TYPE TABLE OF TYP_KONV,
       WA_KONV TYPE TYP_KONV.

TYPES : BEGIN OF ITAB1,
          VBELN      TYPE VBRP-VBELN,
          MATNR      TYPE VBRP-MATNR,
          ARKTX      TYPE VBRP-ARKTX,
          CHARG      TYPE VBRP-CHARG,
          FKIMG      TYPE I,
*  FKIMG(12) TYPE C,
          BEZEI      TYPE TVM5T-BEZEI,
          STEUC      TYPE MARC-STEUC,
          HSDAT(7)   TYPE C,
          VFDAT(7)   TYPE C,
          FKDAT      TYPE VBRK-FKDAT,
*          MRP       TYPE KONP-KBETR,
*          PTS       TYPE KONP-KBETR,
*          PTR       TYPE KONP-KBETR,
          "MRP        TYPE ZINVS3-MRP,
          MRP(7)        TYPE C,
          "PTS        TYPE ZINVS3-PTS,
          PTS(7)        TYPE C,
          "PTR        TYPE ZINVS3-PTR,
          PTR(7)        TYPE C,
          VAL        TYPE KONP-KBETR,
          NET        TYPE KONP-KBETR,
          TNET       TYPE KONP-KBETR,
          TAXABLE    TYPE KONP-KBETR,
          TTAXABLE   TYPE KONP-KBETR,
          "DISPER     TYPE ZINVS3-DISPER,
          DISPER(7)   TYPE C,
*    DISPER TYPE p DECIMALS 2,
          TEXT1(10)  TYPE C,
          TEXT2(4)   TYPE C,
          DIS        TYPE KBETR,
          JOCG_AMT   TYPE KWERT,
          JOCG_RT(7) TYPE C,
*          joig_rt1(2) type c,
*          jocg_rt1(2) type c,
*          josg_rt1(2) type c,
          JOIG_RT1(3) TYPE C,
          JOCG_RT1(3) TYPE C,
          JOSG_RT1(3) TYPE C,
          JOSG_AMT   TYPE PRCD_ELEMENTS-KWERT,
          JOSG_RT(7)  TYPE C,
          JOIG_AMT   TYPE PRCD_ELEMENTS-KWERT,
          JOIG_RT(7)  TYPE C,

          ZDIT       TYPE PRCD_ELEMENTS-KBETR,
          DISCNT     TYPE PRCD_ELEMENTS-KBETR,
          ZSPD       TYPE PRCD_ELEMENTS-KBETR,
          ODIS       TYPE PRCD_ELEMENTS-KBETR,
          KUNAG      TYPE VBRK-KUNAG,
          WERKS      TYPE VBRP-WERKS,
          AUBEL      TYPE VBRP-AUBEL,
          ERZET      TYPE VBRK-ERZET,
          VGBEL      TYPE VBRP-VGBEL,
          SRL        TYPE P DECIMALS 0,


        END OF ITAB1.

TYPES : BEGIN OF INV1 ,
          VBELN TYPE VBRK-VBELN,
        END OF INV1.

TYPES : BEGIN OF ITAB2,

          COUNT(3)  TYPE C,
          VBELN     TYPE VBRK-VBELN,
          CHARG     TYPE VBRP-CHARG,
          FKIMG(12) TYPE C,
          STEUC     TYPE MARC-STEUC,
          ARKTX     TYPE VBRP-ARKTX,
          BEZEI     TYPE TVM5T-BEZEI,
          TEXT1(10) TYPE C,
          TEXT2(4)  TYPE C,
          VFDAT(7)  TYPE C,
          MRP(7)    TYPE C,
          PTS(7)    TYPE C,
          PTR(7)    TYPE C,
          VAL       TYPE KONP-KBETR,
          DIS       TYPE KONP-KBETR,
***************
          JOCG_AMT  TYPE KONP-KBETR,
          JOCG_RT1(3) TYPE C,
          JOIG_AMT  TYPE PRCD_ELEMENTS-KWERT,
          JOIG_RT1(3) TYPE C,
          JOSG_AMT  TYPE PRCD_ELEMENTS-KWERT,
          JOSG_RT1(3) TYPE C,
          ODIS      TYPE PRCD_ELEMENTS-KBETR,
          DISPER(7) TYPE C,
          W_CASE(7) TYPE C,
          TAXABLE   TYPE PRCD_ELEMENTS-KBETR,
          TTAXABLE  TYPE PRCD_ELEMENTS-KBETR,
        END OF ITAB2.

TYPES: BEGIN OF ITAS1,
         VBELN     TYPE VBRK-VBELN,
         MATNR     TYPE VBRP-MATNR,
         CHARG     TYPE VBRP-CHARG,
         SRL       TYPE P DECIMALS 0,
         W_CASE(5) TYPE C,
       END OF ITAS1.

TYPES: BEGIN OF CUS1,
         KUNAG TYPE VBRK-KUNAG,
         VBELN TYPE VBRK-VBELN,
       END OF CUS1.

TYPES: BEGIN OF CUS3,
         KUNAG TYPE VBRK-KUNAG,
         VBELN TYPE VBRK-VBELN,
         BEGDA TYPE BEGDA,
         SPART TYPE MARA-SPART,
       END OF CUS3.


TYPES: BEGIN OF CUS2,
         KUNAG     TYPE VBRK-KUNAG,
         VBELN     TYPE VBRK-VBELN,
         SMTP_ADDR TYPE ADR6-SMTP_ADDR,
       END OF CUS2.

TYPES: BEGIN OF MAIL1,
         KUNAG TYPE VBRK-KUNAG,
         BZIRK TYPE ZDSMTER-BZIRK,
         SPART TYPE ZDSMTER-SPART,
       END OF MAIL1.

TYPES: BEGIN OF MAIL2,
         KUNAG TYPE VBRK-KUNAG,
         BZIRK TYPE ZDSMTER-BZIRK,
*         SPART TYPE ZDSMTER-SPART,
       END OF MAIL2.

TYPES: BEGIN OF MAIL3,
         KUNAG      TYPE VBRK-KUNAG,
         USRID_LONG TYPE PA0105-USRID_LONG,
*         SPART TYPE ZDSMTER-SPART,
       END OF MAIL3.

DATA : IT_TAB1            TYPE TABLE OF ITAB1,
       WA_TAB1            TYPE ITAB1,
       IT_TAB2            TYPE TABLE OF ZINVS3,
       WA_TAB2            TYPE ZINVS3,
       IT_INV1            TYPE TABLE OF INV1,
       WA_INV1            TYPE INV1,
       IT_TAS1            TYPE TABLE OF ITAS1,
       WA_TAS1            TYPE ITAS1,
       IT_CUS1            TYPE TABLE OF CUS1,
       WA_CUS1            TYPE CUS1,
       IT_CUS2            TYPE TABLE OF CUS2,
       WA_CUS2            TYPE CUS2,
       IT_CUS3            TYPE TABLE OF CUS3,
       WA_CUS3            TYPE CUS3,
       IT_MAIL1           TYPE TABLE OF MAIL1,
       WA_MAIL1           TYPE MAIL1,
       IT_MAIL2           TYPE TABLE OF MAIL2,
       WA_MAIL2           TYPE MAIL2,
       IT_MAIL3           TYPE TABLE OF MAIL3,
       WA_MAIL3           TYPE MAIL3,
       IT_YSD_CUS_DIV_DIS TYPE TABLE OF YSD_CUS_DIV_DIS,
       WA_YSD_CUS_DIV_DIS TYPE YSD_CUS_DIV_DIS,
       IT_ZDSMTER         TYPE TABLE OF ZDSMTER,
       WA_ZDSMTER         TYPE ZDSMTER.

DATA : EXTENSION_A TYPE BU_ID_NUMBER,
       EXTENSION_B TYPE BU_ID_NUMBER.

DATA : DATE1 TYPE SY-DATUM,
       DATE2 TYPE SY-DATUM.

DATA : MDIV TYPE MARA-SPART,
       MCNT TYPE P DECIMALS 0.

DATA: MRP            TYPE KONP-KBETR,
      PTS            TYPE KONP-KBETR,
      PTR            TYPE KONP-KBETR,
      VAL            TYPE KONP-KBETR,
      DISPER         TYPE KONP-KBETR,
      TEXT1(10)      TYPE C,
      TEXT2(4)       TYPE C,
      HSDAT(7)       TYPE C,
      VFDAT(7)       TYPE C,
      FKIMG          TYPE I,
      FKIMG1(7)      TYPE C,
      TVAL           TYPE KBETR,
      TDIS           TYPE KBETR,
      TNET           TYPE PRCD_ELEMENTS-KBETR,
      TTAXABLE       TYPE KBETR,
      TOTTAXABLE     TYPE KBETR,
      TZDIT          TYPE KBETR,
      DISCNT1        TYPE KONP-KBETR,
      DISCNT2(10)    TYPE C,
      DISCNT(200)    TYPE C,
      TTAX           TYPE PRCD_ELEMENTS-KBETR,
      IGST           TYPE PRCD_ELEMENTS-KBETR,
      SGST           TYPE PRCD_ELEMENTS-KBETR,
      CGST           TYPE PRCD_ELEMENTS-KBETR,
      TAMT           TYPE KBETR,
      RVAL           TYPE KBETR,
      RVAL1          TYPE KBETR,
      BC             TYPE KBETR,
      BC1(10)        TYPE C,
      XL1(10)        TYPE C,
      LS1(10)        TYPE C,
      EWAYBILL(100)  TYPE C,
*             type string,
      EWAYDATE(15)   TYPE C,
*             type string,
      BCVAL(100)     TYPE C,
      SPARTVAL(200)  TYPE C,
      XLVAL(100)     TYPE C,
      LSVAL(100)     TYPE C,
      XL             TYPE KBETR,
      LS             TYPE KBETR,
      CN             TYPE KBETR,
      CNVAL          TYPE PRCD_ELEMENTS-KBETR,
      CNVAL1(10)     TYPE C,
      W_CREDIT(15)   TYPE C,
      CREDIT(255)    TYPE C,
      CN1            TYPE PRCD_ELEMENTS-KBETR,
      CN2            TYPE I,
      NETAMT1        TYPE I,
      CREDITBAL1(25) TYPE C,
      CREDITBAL(50)  TYPE C,
      NETAMT         TYPE KBETR,
      NETAMT2        TYPE KBETR,
      TODIS          TYPE PRCD_ELEMENTS-KBETR,
      TTNET          TYPE PRCD_ELEMENTS-KBETR,
      TOTNET         TYPE PRCD_ELEMENTS-KBETR,
      TOTJOSG        TYPE KBETR,
      TOTJOCG        TYPE KBETR,
      TOTJOIG        TYPE KBETR,
      TOTDIS         TYPE PRCD_ELEMENTS-KBETR.
DATA : C_STATE(2) TYPE C,
       CNAME1     TYPE ADRC-NAME1,
       CNAME2     TYPE ADRC-NAME2,
       CNAME3     TYPE ADRC-NAME3,
       CNAME4     TYPE ADRC-NAME4,
       CCITY      TYPE ADRC-CITY1,
       EXTENSION1 TYPE STRING,
       CCITY1     TYPE KNA1-ORT01,
       CPSTLZ     TYPE KNA1-PSTLZ,
       CSTNO      LIKE J_1IMOCUST-J_1ICSTNO,
       TINNO      LIKE J_1IMOCUST-J_1ILSTNO,
       PANNO      LIKE KNA1-J_1IPANNO,

       BILLNO     LIKE VBRK-VBELN,
       BDATE      LIKE VBRK-FKDAT,
       GD1        TYPE SY-DATUM,
       GD2        TYPE SY-DATUM,
       BTIME      LIKE VBRK-ERZET,
       BDATE1(10) TYPE C,
       INVTYP1(3) TYPE C,
       INVTYP2(7) TYPE C,
       V_NAME1    TYPE ADRC-NAME1,
       V_BOLNR    LIKE LIKP-BOLNR, "LR No
       V_LFDAT    LIKE LIKP-LFDAT, "LR date
       V_ZFBDT    TYPE BSEG-ZFBDT. "LR date
DATA : V_ZTERM  TYPE DZTERM.
DATA : V_BAHNS LIKE KNA1-BAHNS,
       V_BAHNE LIKE KNA1-BAHNE.
DATA : P_STATE(3) TYPE C,
       PNAME1     TYPE ADRC-NAME1,
       PNAME2     TYPE ADRC-NAME2,
       PNAME3     TYPE ADRC-NAME3,
       PNAME4     TYPE ADRC-NAME4,
       PCITY1     TYPE ADRC-CITY1,
       P_PSTLZ    TYPE T001W-PSTLZ.
DATA : PAY   LIKE ADRC-CITY1,
       DRUG  LIKE ADRC-EXTENSION1,
       PHONE LIKE ADRC-TEL_NUMBER.
DATA: EWAY1(15) TYPE C,
      EWAY2(5)  TYPE C,
      GJAHR     TYPE BKPF-GJAHR.

DATA : E_CSTNO    LIKE J_1IMOCUST-J_1ICSTNO,
       E_TINNO    LIKE J_1IMOCUST-J_1ILSTNO,
       E_STATE(3) TYPE C.
DATA : V_AUBEL LIKE VBRP-AUBEL,
       V_BSTNK LIKE VBAK-BSTNK,
       V_BSTDK LIKE VBAK-BSTDK,
       A_KUNNR TYPE VBPA-KUNNR.
DATA : IT_BSAD  TYPE TABLE OF BSAD,
       WA_BSAD  TYPE BSAD,
       IT_BSAD1 TYPE TABLE OF BSAD,
       WA_BSAD1 TYPE BSAD.
DATA : ADV TYPE VBRP-NETWR.
DATA: ADV1(10) TYPE C.
DATA: ADV2(10) TYPE C.
DATA: ADJ(255) TYPE C.
DATA : ADVTXT TYPE BSEG-ZUONR.

DATA : V_BELNR LIKE BKPF-BELNR.
DATA : V_GJAHR      LIKE BKPF-GJAHR,
       V_KUNAG      TYPE VBRK-KUNAG,
       W_ZFBDT      TYPE SY-DATUM,
       P_DOCNO      TYPE VBRK-VBELN,
       W_ZFBDT1(10) TYPE C.
*DATA : CN TYPE VBRP-NETWR.

*DATA : W_RETURN TYPE RS38L_FNAM.
DATA : W_RETURN    TYPE SSFCRESCL.

DATA : ITLINE LIKE TLINE OCCURS 0 WITH HEADER LINE.
DATA : SIMPLE  LIKE STXH-TDNAME.
DATA : NOCASE(5).
DATA : COUNT TYPE I.
DATA : CNT1 TYPE I.
CONSTANTS : RBSELECTED TYPE C LENGTH 1 VALUE 'X'.
DATA : NET TYPE KONP-KBETR.
DATA  NUM(70).
DATA : MMLINE1  LIKE TLINE OCCURS 0 WITH HEADER LINE.
DATA : MMLINE2 LIKE TLINE OCCURS 0 WITH HEADER LINE.
DATA EWAY LIKE  TLINE-TDLINE.
DATA: ED1(2) TYPE C,
      EM1(2) TYPE C,
      EY1(4) TYPE C.
DATA: ITYP TYPE VBRK-FKART.
DATA EWAYDT LIKE  TLINE-TDLINE.

DATA : ITLINE1 LIKE TLINE OCCURS 0 WITH HEADER LINE.
DATA : SIMPLE1  LIKE STXH-TDNAME.
DATA : MATTEXT(25).

DATA : JOCG_AMT TYPE PRCD_ELEMENTS-KWERT,
       JOCG_RT  TYPE KBETR,
       JOSG_AMT TYPE PRCD_ELEMENTS-KWERT,
       JOSG_RT  TYPE KBETR,
       JOIG_AMT TYPE PRCD_ELEMENTS-KWERT,
       JOIG_RT  TYPE KBETR,
       JOUG_AMT TYPE PRCD_ELEMENTS-KWERT,
       JOUG_RT  TYPE PRCD_ELEMENTS-KBETR,
       JOIG_RT1 TYPE ZTAX,
       JOSG_RT1 TYPE KBETR,
       JOCG_RT1 TYPE KBETR,
       JOUG_RT1 TYPE I.
DATA: JOIG_RT2 TYPE KBETR,
      JOSG_RT2 TYPE KBETR,
      JOCG_RT2 TYPE KBETR,
      JOUG_RT2 TYPE P DECIMALS 1.

DATA: V1 TYPE P DECIMALS 2,
      V2 TYPE P DECIMALS 0.

DATA : W_CS1(2)   TYPE N,
       W_CS2(5)   TYPE N,
       W_CASE(5)  TYPE C,
       W_CASE1(5) TYPE C,
       W_CASE2(5) TYPE C,
       W_QUN      TYPE I,
       SRL(3)     TYPE P DECIMALS 0.

TYPES: BEGIN OF TYP_T001W,
         WERKS TYPE WERKS_D,
         NAME1 TYPE NAME1,
       END OF TYP_T001W.

DATA : ITAB_T001W TYPE TABLE OF TYP_T001W,
       WA_T001W   TYPE TYP_T001W.
DATA : MSG TYPE STRING.

TYPES: BEGIN OF T_USR05,
         BNAME TYPE USR05-BNAME,
         PARID TYPE USR05-PARID,
         PARVA TYPE USR05-PARVA,
       END OF T_USR05.

DATA : WA_USR05 TYPE T_USR05.
DATA : VBELN TYPE VBRK-VBELN.
DATA : FKDAT TYPE VBRK-FKDAT.
DATA : NTXT1(20)  TYPE C,
       NTXT2(100) TYPE C,
*       tcstxt(19) type c.
       TCSTXT(50) TYPE C.
DATA: TAX1(1) TYPE C.
DATA IRN TYPE J_1IG_IRN.
DATA: NLEMTXT1(100) TYPE C,
      NLEMTXT2(100) TYPE C,
      NLEMTXT3(100) TYPE C,
      NLEMTXT(300)  TYPE C.

DATA : V_FM TYPE RS38L_FNAM.
DATA: FORMAT(10) TYPE C.
DATA : CONTROL  TYPE SSFCTRLOP.
DATA : W_SSFCOMPOP TYPE SSFCOMPOP.

DATA: I_OTF       TYPE ITCOO    OCCURS 0 WITH HEADER LINE,
      I_TLINE     LIKE TLINE    OCCURS 0 WITH HEADER LINE,
      I_RECORD    LIKE SOLISTI1 OCCURS 0 WITH HEADER LINE,
      I_XSTRING   TYPE XSTRING,
* Objects to send mail.
      I_OBJPACK   LIKE SOPCKLSTI1 OCCURS 0 WITH HEADER LINE,
      I_OBJTXT    LIKE SOLISTI1   OCCURS 0 WITH HEADER LINE,
      I_OBJBIN    LIKE SOLIX      OCCURS 0 WITH HEADER LINE,
      I_RECLIST   LIKE SOMLRECI1  OCCURS 0 WITH HEADER LINE,
* Work Area declarations
      WA_OBJHEAD  TYPE SOLI_TAB,
      W_CTRLOP    TYPE SSFCTRLOP,
      W_COMPOP    TYPE SSFCOMPOP,
*      w_return    TYPE ssfcrescl,
      WA_BUFFER   TYPE STRING,
* Variables declarations
      V_FORM_NAME TYPE RS38L_FNAM,
      V_LEN_IN    LIKE SOOD-OBJLEN.

DATA: IN_MAILID TYPE AD_SMTPADR.

SELECTION-SCREEN  BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-002.

  SELECT-OPTIONS: INVOICE FOR VBRK-VBELN,
                  SDATE FOR VBRK-FKDAT,
                  CUST FOR VBRK-KUNAG.
  PARAMETERS : PLANT LIKE VBRP-WERKS OBLIGATORY .

SELECTION-SCREEN : END OF BLOCK B1.
SELECTION-SCREEN  BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002.
*parameters : r1  radiobutton group a1,
**             R2  RADIOBUTTON GROUP A1,
*             r21 radiobutton group a1.
  PARAMETERS : P1 RADIOBUTTON GROUP R1,
               P3 RADIOBUTTON GROUP R1,
               P4 RADIOBUTTON GROUP R1,
               P2 RADIOBUTTON GROUP R1.
  SELECT-OPTIONS: S_EMAIL FOR ADR6-SMTP_ADDR NO INTERVALS.
  PARAMETERS : R2 AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN : END OF BLOCK B2.

SELECTION-SCREEN  BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-002.
*PARAMETERS : R3 RADIOBUTTON GROUP B1.
*             R4 RADIOBUTTON GROUP B1,
*             R6 RADIOBUTTON GROUP B1,
*             R5 RADIOBUTTON GROUP B1.

SELECTION-SCREEN : END OF BLOCK B3.


SELECTION-SCREEN  BEGIN OF BLOCK BL5 WITH FRAME TITLE TEXT-002.

*IF R5 = RBSELECTED .
*  PARAMETER: P_EMAIL1 LIKE SOMLRECI1-RECEIVER     MODIF ID SP2 .
*
*ENDIF.

SELECTION-SCREEN : END OF BLOCK BL5.

AT SELECTION-SCREEN.
  PERFORM AUTHORIZATION.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
*    IF R5 = 'X'.
*      IF SCREEN-GROUP1 = 'SP2'.
*        SCREEN-INPUT = '1'.
*        SCREEN-INVISIBLE = '0'.
*        SCREEN-REQUIRED = '0'.
*      ENDIF.
*    ELSE.
    IF SCREEN-GROUP1 = 'SP2'.
      SCREEN-INPUT = '0'.
      SCREEN-INVISIBLE = '1'.
      SCREEN-REQUIRED = '0'.

    ENDIF.

*    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.

  SELECT SINGLE BNAME PARID PARVA FROM USR05 INTO WA_USR05 WHERE BNAME = SY-UNAME AND PARID = 'ZPLANT'.
*  PLANT-SIGN = 'I'.
*  PLANT-OPTION = 'BT'.
*  PLANT-LOW = WA_USR05-PARVA.
*  PLANT-HIGH = WA_USR05-PARVA.
  PLANT = WA_USR05-PARVA.
*  APPEND PLANT.


START-OF-SELECTION.

  PERFORM AUTHORIZATION.

  IF P2 EQ 'X'.
    IF S_EMAIL IS INITIAL.
      MESSAGE 'ENTER EMAIL ADDRESS' TYPE 'E'.
    ENDIF.
  ENDIF.

  IF INVOICE IS INITIAL AND SDATE IS INITIAL.
    MESSAGE 'ENTER INVOICE NUMBER OF DATE' TYPE 'I'.
    EXIT.
  ENDIF.
**** new invoice format*****
  GD1+6(2) = '01'.
  GD1+4(2) = '01'.
  GD1+0(4) = '2020'.

  GD2+6(2) = '01'.
  GD2+4(2) = '02'.
  GD2+0(4) = '2020'.

*  SELECT * FROM vbrk INTO TABLE it_vbrk WHERE vbeln IN invoice AND fkdat IN sdate "AND fkart IN ('ZBDF','ZCDF')
*     AND fksto NE 'X' AND kunag IN cust.
  SELECT * FROM VBRK INTO TABLE IT_VBRK WHERE VBELN IN INVOICE AND FKDAT IN SDATE AND FKART IN ('ZBDF','ZCDF') AND FKSTO NE 'X' AND KUNAG IN CUST.
  IF SY-SUBRC EQ 0.
    SELECT * FROM VBRP INTO TABLE IT_VBRP FOR ALL ENTRIES IN IT_VBRK WHERE VBELN EQ IT_VBRK-VBELN AND WERKS EQ PLANT.
    SELECT KNUMV KPOSN STUNR ZAEHK KSCHL KRECH KAWRT KBETR KWERT FROM PRCD_ELEMENTS INTO TABLE IT_KONV FOR ALL ENTRIES IN IT_VBRK WHERE KNUMV = IT_VBRK-KNUMV.
*    SELECT knumv kposn stunr zaehk kschl krech kawrt kbetr kwert FROM KONV INTO TABLE it_konv FOR ALL ENTRIES IN it_vbrk WHERE knumv = it_vbrk-knumv.
  ENDIF.
  DELETE IT_VBRP WHERE FKIMG EQ 0.

  LOOP AT IT_VBRK INTO WA_VBRK.
    READ TABLE IT_VBRP INTO WA_VBRP WITH KEY VBELN = WA_VBRK-VBELN.
    IF SY-SUBRC EQ 0.
      WA_CHECK-VBELN = WA_VBRK-VBELN.
      WA_CHECK-KUNAG = WA_VBRK-KUNAG.
      COLLECT WA_CHECK INTO IT_CHECK.
      CLEAR WA_CHECK.

      WA_CHECK1-VBELN = WA_VBRK-VBELN.
      WA_CHECK1-KUNAG = WA_VBRK-KUNAG.
      COLLECT WA_CHECK1 INTO IT_CHECK1.
      CLEAR WA_CHECK1.
    ENDIF.
  ENDLOOP.


  IF P1 EQ 'X'.
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
*       formname           = 'ZINVSL13'
        FORMNAME           = 'ZINVSL14'
*       VARIANT            = ' '
*       DIRECT_CALL        = ' '
      IMPORTING
        FM_NAME            = V_FM
      EXCEPTIONS
        NO_FORM            = 1
        NO_FUNCTION_MODULE = 2
        OTHERS             = 3.

**    CONTROL-NO_OPEN   = 'X'.
**    CONTROL-NO_CLOSE  = 'X'.

*      *******SOC added by sanjay*******
*IF p_prev = abap_true.
***    CONTROL-PREVIEW   = ABAP_TRUE.
***    CONTROL-NO_DIALOG = ABAP_TRUE.
*ENDIF.

********EOC added by sanjay*******
*    CALL FUNCTION 'SSF_OPEN'
*      EXPORTING
*        control_parameters = control.

    DATA:CONTROL_PARAMETERS TYPE SSFCTRLOP,
         W_CNT              TYPE I,
         W_CNT2             TYPE I.
    BREAK CTPLGW.

    sort IT_CHECK by vbeln ascending.

    LOOP AT IT_CHECK INTO WA_CHECK.


      DESCRIBE TABLE IT_CHECK LINES W_CNT .

      IF W_CNT > 1 .
*      AT FIRST.
*        CONTROL-NO_CLOSE = 'X'. "do not close spool
*      ENDAT.
*      AT LAST.
*        CONTROL-NO_CLOSE = SPACE. "close the spool at the end of data
*      ENDAT.

        W_CNT2 = SY-TABIX .
        CASE W_CNT2.
          WHEN 1.
            CONTROL-NO_OPEN   = SPACE .
            CONTROL-NO_CLOSE  = 'X' .
          WHEN W_CNT .
            CONTROL-NO_OPEN   = 'X' .
            CONTROL-NO_CLOSE  = SPACE .
          WHEN OTHERS.
            CONTROL-NO_OPEN   = 'X' .
            CONTROL-NO_CLOSE  = 'X' .
        ENDCASE.

      ENDIF.
      CLEAR : VBELN,NTXT1,NTXT2,FKDAT,TAX1.
      VBELN = WA_CHECK-VBELN.
      SELECT SINGLE * FROM VBRK WHERE VBELN EQ VBELN.
      IF SY-SUBRC EQ 0.
        FKDAT = VBRK-FKDAT.
      ENDIF.
      IF FKDAT GE '20201001'.
        TCSTXT = 'TCS - IT COLLECTED'.
      ELSE.
        TCSTXT = SPACE.
      ENDIF.
      IF FKDAT GE '20201005'.
*        tcstxt = 'TCS - IT COLLECTED'.
        SELECT SINGLE IRN FROM J_1IG_INVREFNUM INTO IRN WHERE BUKRS EQ '1000' AND DOCNO EQ VBELN AND IRN NE SPACE.
        IF SY-SUBRC EQ 0.
          TAX1 = 'A'.
          NTXT1 = 'TAX INVOICE'.
          NTXT2 = 'Issued under sec. 31 of CGST act, 2017 read with rule 48 of CGST Rule, 2017'.
        ELSE.
          NTXT1 = 'PACKING LIST'.
          NTXT2 = SPACE.
        ENDIF.
      ELSE.
*        tcstxt = space.
        TAX1 = 'A'.
        NTXT1 = 'TAX INVOICE'.
        NTXT2 = 'Issued under sec. 31 of CGST act, 2017 read with rule 48 of CGST Rule, 2017'.
      ENDIF.


      PERFORM FORM1.

      IF R2 EQ 'X'.
        EWAY1 = 'E-WAY BILL NO.:'.
        EWAY2 = 'DATE:'.
      ENDIF.
*******************check for eway bill CONDITION  6.6.25*************************
      PERFORM EWAYCHECK.

***********check accounting doc*****
      CLEAR : GJAHR.
      IF FKDAT+4(2) GE '04'.
        GJAHR = FKDAT+0(4).
      ELSE.
        GJAHR = FKDAT+0(4) - 1.
      ENDIF.
*      SELECT SINGLE * FROM bkpf WHERE bukrs EQ 'BCLL' AND gjahr EQ gjahr AND awkey EQ vbeln.
      SELECT SINGLE * FROM BKPF WHERE BUKRS EQ '1000' AND GJAHR EQ GJAHR AND AWKEY EQ VBELN.
      IF SY-SUBRC EQ 4.
        IF SY-UNAME EQ 'ITBOM01'.
          MESSAGE 'CHECK ACCOUNTING DOCUMENT' TYPE 'I'.
        ELSE.
          MESSAGE 'CHECK ACCOUNTING DOCUMENT' TYPE 'E'.
        ENDIF.
      ENDIF.
*******************************************************************

*******************************************************************
      CALL FUNCTION V_FM
        EXPORTING
          CONTROL_PARAMETERS = CONTROL
*         USER_SETTINGS      = 'X'
*         OUTPUT_OPTIONS     = W_SSFCOMPOP
          FORMAT             = FORMAT
          PNAME1             = PNAME1
          PNAME2             = PNAME2
          PNAME3             = PNAME3
          PNAME4             = PNAME4
          PHONE              = PHONE
          DRUG               = DRUG
          E_TINNO            = E_TINNO
          E_STATE            = E_STATE
          PCITY1             = PCITY1
          A_KUNNR            = A_KUNNR
          BILLNO             = VBELN
          BDATE1             = BDATE1
          BTIME              = BTIME
          INVTYP1            = INVTYP1
          INVTYP2            = INVTYP2
          W_ZFBDT1           = W_ZFBDT1
          CNAME1             = CNAME1
          CNAME2             = CNAME2
          CNAME3             = CNAME3
          CNAME4             = CNAME4
          C_STATE            = C_STATE
          CCITY              = CCITY
          V_BSTNK            = V_BSTNK
          V_BSTDK            = V_BSTDK
          EXTENSION1         = EXTENSION1
          TINNO              = TINNO
          PANNO              = PANNO
          V_BAHNS            = V_BAHNS
          V_BAHNE            = V_BAHNE
          V_NAME1            = V_NAME1
          CCITY1             = CCITY1
          V_BOLNR            = V_BOLNR
          V_ZFBDT            = V_ZFBDT
          NOCASE             = NOCASE
          EWAYBILL           = EWAYBILL
          EWAYDATE           = EWAYDATE
          EWAY1              = EWAY1
          EWAY2              = EWAY2
          TVAL               = TVAL
          TDIS               = TDIS
          TZDIT              = TZDIT
          TTAXABLE           = TTAXABLE
          TOTJOIG            = TOTJOIG
          TOTJOCG            = TOTJOCG
          TOTJOSG            = TOTJOSG
          TOTTAXABLE         = TOTTAXABLE
          TAMT               = TAMT
          ADV                = ADV
          CN                 = CN
          RVAL1              = RVAL1
          NETAMT             = NETAMT
          SPARTVAL           = SPARTVAL
          CREDIT             = CREDIT
          ADJ                = ADJ
          CREDITBAL          = CREDITBAL
          DISCNT             = DISCNT
          W_ZFBDT            = W_ZFBDT
          TCS                = TCS
          NTXT1              = NTXT1
          NTXT2              = NTXT2
          TCSTXT             = TCSTXT
          NLEMTXT            = NLEMTXT
          TAX1               = TAX1
          CPSTLZ             = CPSTLZ
*         P_docno            = vbeln
        IMPORTING
          JOB_OUTPUT_INFO    = W_RETURN " This will have all output
*         P_STCD3            = P_STCD3
*         P_EXTENSION1       = P_EXTENSION1
*         P_CITY1            = P_CITY1
*         Z_NAME1            = Z_NAME1
*         Z_NAME2            = Z_NAME2
*         Z_NAME3            = Z_NAME3
*         Z_NAME4            = Z_NAME4
*         STCD3              = STCD3
*         Z_EXTENSION1       = Z_EXTENSION1
*         Z_CITY1            = Z_CITY1
*         TEXT               = TEXT
*         VBELN              = VBELN
*         Z_FKDAT1           = Z_FKDAT1
*         Z_CPUTM            = Z_CPUTM
*         INVTYP1            = INVTYP1
*         INVTYP2            = INVTYP2
*         NAME1              = NAME1
*         NAME2              = NAME2
*         NAME3              = NAME3
*         NAME4              = NAME4
*         NAME5              = NAME5
*         NETWORD2WORD       = NETWORD2-WORD
*         NETWORD1WORD       = NETWORD1-WORD
*         TOTQTY             = TOTQTY
*         TOTCASE1           = TOTCASE1
*         TOTZGRP            = TOTZGRP
*         TOTXVA             = TOTXVA
*         TOTVA              = TOTVA
*         DIFF1              = DIFF1
*         TOTVA2             = TOTVA2
*         Z_RDOC1            = Z_RDOC1
*         P_TEXT1            = P_TEXT1
*         TEXT2              = TEXT2
*         P_TEXT2            = P_TEXT2
*         W_NAME1            = W_NAME1
*         Z_ORT01            = Z_ORT01
*         Z_BOLNR            = Z_BOLNR
*         Z_ZFBDT            = Z_ZFBDT
*         Z_BTGEW            = Z_BTGEW
*         EWAY               = EWAY
*         EWAYDT             = EWAYDT
*
        TABLES
          IT_TAB2            = IT_TAB2
**       itab_division      = itab_division
**       itab_storage       = itab_storage
**       itab_pa0002        = itab_pa0002
        EXCEPTIONS
          FORMATTING_ERROR   = 1
          INTERNAL_ERROR     = 2
          SEND_ERROR         = 3
          USER_CANCELED      = 4
          OTHERS             = 5.

      CLEAR : TVAL,TDIS,TNET,IGST,CGST,SGST,TAMT,TODIS,TTNET,ADV,NETAMT1,NETAMT,CN,CN1,CN2,CREDIT,DISCNT,DISCNT1,DISCNT2,XL,BC,LS,BC1,XL1,LS1,EWAYBILL,EWAYDATE,
     EWAY,EWAYDT,CREDIT,CREDITBAL,CREDITBAL1,ADJ,TOTNET,TOTJOIG,TOTJOCG,TOTJOSG,TOTDIS,TTAXABLE,TZDIT,TOTTAXABLE,RVAL,RVAL1,CNT1,NETAMT2,XLVAL,BCVAL,LSVAL.
      REFRESH :MMLINE1,MMLINE2.
      REFRESH ITLINE.
      CLEAR : ITLINE.
*      CONTROL-NO_OPEN = 'X'. "do not open new spool
    ENDLOOP.
*    CALL FUNCTION 'SSF_CLOSE'.
  ELSEIF P2 EQ 'X'.
    LOOP AT S_EMAIL.
      LOOP AT IT_CHECK1 INTO WA_CHECK1.

        CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
          EXPORTING
*           FORMNAME           = 'ZINVS6N4'
*           formname           = 'ZINVSL13'
            FORMNAME           = 'ZINVSL14'
*      p_sform
          IMPORTING
            FM_NAME            = V_FORM_NAME
          EXCEPTIONS
            NO_FORM            = 1
            NO_FUNCTION_MODULE = 2
            OTHERS             = 3.

        IF SY-SUBRC <> 0.
          MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
          WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.

* Set the control parameter
        W_CTRLOP-GETOTF = ABAP_TRUE.
        W_CTRLOP-NO_DIALOG = ABAP_TRUE.
        W_COMPOP-TDNOPREV = ABAP_TRUE.
        W_CTRLOP-PREVIEW = SPACE.
        W_COMPOP-TDDEST = 'LOCL'.

        LOOP AT IT_CHECK INTO WA_CHECK WHERE VBELN EQ WA_CHECK1-VBELN.
          CLEAR : VBELN,FKDAT,TAX1.
          CLEAR : NTXT1,NTXT2.
          VBELN = WA_CHECK-VBELN.
          SELECT SINGLE * FROM VBRK WHERE VBELN EQ VBELN.
          IF SY-SUBRC EQ 0.
            FKDAT = VBRK-FKDAT.
          ENDIF.
          IF FKDAT GE '20201001'.
            TCSTXT = 'TCS - IT COLLECTED'.
          ELSE.
            TCSTXT = SPACE.
          ENDIF.
          IF FKDAT GE '20201005'.
*            tcstxt = 'TCS - IT COLLECTED'.
            SELECT SINGLE IRN FROM J_1IG_INVREFNUM INTO IRN WHERE BUKRS EQ '1000' AND DOCNO EQ VBELN AND IRN NE SPACE.
            IF SY-SUBRC EQ 0.
              TAX1 = 'A'.
              NTXT1 = 'TAX INVOICE'.
              NTXT2 = 'Issued under sec. 31 of CGST act, 2017 read with rule 48 of CGST Rule, 2017'.
            ELSE.
              NTXT1 = 'PACKING LIST'.
              NTXT2 = SPACE.
            ENDIF.
          ELSE.
*            tcstxt = space.
            TAX1 = 'A'.
            NTXT1 = 'TAX INVOICE'.
            NTXT2 = 'Issued under sec. 31 of CGST act, 2017 read with rule 48 of CGST Rule, 2017'.
          ENDIF.

          PERFORM FORM1.

          IF R2 EQ 'X'.
            EWAY1 = 'E-WAY BILL NO.:'.
            EWAY2 = 'DATE:'.
          ENDIF.

*******************check for eway bill CONDITION*************************
          PERFORM EWAYCHECK.

*          IF TAX1 NE SPACE.
*            IF EWAY EQ SPACE.
*              SELECT SINGLE * FROM VBRK WHERE VBELN EQ WA_CHECK-VBELN.
*              IF SY-SUBRC EQ 0.
*                SELECT SINGLE * FROM VBRP WHERE VBELN EQ VBRK-VBELN AND WERKS NE '2007' AND WERKS NE '2016' .
*                IF SY-SUBRC EQ 0.
*                  IF TOTJOIG GT 0.
*                    ITYP = 'ZSTO'.
*                  ELSE.
*                    ITYP = 'ZSTI'.
*                  ENDIF.
*                  SELECT SINGLE * FROM T001W WHERE WERKS EQ VBRP-WERKS .
*                  IF SY-SUBRC EQ 0.
*                    SELECT SINGLE * FROM ZEWAY_LIMIT WHERE REGIO EQ T001W-REGIO AND FKART EQ ITYP.
*                    IF SY-SUBRC EQ 0.
*                      IF ZEWAY_LIMIT-NETWR LE ( VBRK-NETWR + VBRK-MWSBK ).
*                        CLEAR TAX1.
*
*                        NTXT1 = 'PACKING LIST'.
*                        NTXT2 = SPACE.
*
*                      ENDIF.
*                    ENDIF.
*                  ENDIF.
*                ENDIF.
*              ENDIF.
*            ENDIF.
*          ENDIF.
*******************************************************************
*******SOC added by sanjay*******
*IF p_prev = abap_true.
          W_CTRLOP-PREVIEW   = ABAP_TRUE.
          W_CTRLOP-NO_DIALOG = ABAP_TRUE.
*ENDIF.

*******EOC added by sanjay*******
          CALL FUNCTION V_FORM_NAME
*        call function v_fm
            EXPORTING
              CONTROL_PARAMETERS = W_CTRLOP
              OUTPUT_OPTIONS     = W_COMPOP
              USER_SETTINGS      = ABAP_TRUE
              FORMAT             = FORMAT
              PNAME1             = PNAME1
              PNAME2             = PNAME2
              PNAME3             = PNAME3
              PNAME4             = PNAME4
              PHONE              = PHONE
              DRUG               = DRUG
              E_TINNO            = E_TINNO
              E_STATE            = E_STATE
              PCITY1             = PCITY1
              A_KUNNR            = A_KUNNR
              BILLNO             = VBELN
              BDATE1             = BDATE1
              BTIME              = BTIME
              INVTYP1            = INVTYP1
              INVTYP2            = INVTYP2
              W_ZFBDT1           = W_ZFBDT1
              CNAME1             = CNAME1
              CNAME2             = CNAME2
              CNAME3             = CNAME3
              CNAME4             = CNAME4
              C_STATE            = C_STATE
              CCITY              = CCITY
              V_BSTNK            = V_BSTNK
              V_BSTDK            = V_BSTDK
              EXTENSION1         = EXTENSION1
              TINNO              = TINNO
              PANNO              = PANNO
              V_BAHNS            = V_BAHNS
              V_BAHNE            = V_BAHNE
              V_NAME1            = V_NAME1
              CCITY1             = CCITY1
              V_BOLNR            = V_BOLNR
              V_ZFBDT            = V_ZFBDT
              NOCASE             = NOCASE
              EWAYBILL           = EWAYBILL
              EWAYDATE           = EWAYDATE
              EWAY1              = EWAY1
              EWAY2              = EWAY2
              TVAL               = TVAL
              TDIS               = TDIS
              TZDIT              = TZDIT
              TTAXABLE           = TTAXABLE
              TOTJOIG            = TOTJOIG
              TOTJOCG            = TOTJOCG
              TOTJOSG            = TOTJOSG
              TOTTAXABLE         = TOTTAXABLE
              TAMT               = TAMT
              ADV                = ADV
              CN                 = CN
              RVAL1              = RVAL1
              NETAMT             = NETAMT
              SPARTVAL           = SPARTVAL
              CREDIT             = CREDIT
              ADJ                = ADJ
              CREDITBAL          = CREDITBAL
              DISCNT             = DISCNT
              W_ZFBDT            = W_ZFBDT
              TCS                = TCS
              NTXT1              = NTXT1
              NTXT2              = NTXT2
              TCSTXT             = TCSTXT
              NLEMTXT            = NLEMTXT
              TAX1               = TAX1
              CPSTLZ             = CPSTLZ
*             P_DOCNO            = vbeln
            IMPORTING
              JOB_OUTPUT_INFO    = W_RETURN " This will have all output
*
            TABLES
              IT_TAB2            = IT_TAB2
            EXCEPTIONS
              FORMATTING_ERROR   = 1
              INTERNAL_ERROR     = 2
              SEND_ERROR         = 3
              USER_CANCELED      = 4
              OTHERS             = 5.

          CLEAR : TVAL,TDIS,TNET,IGST,CGST,SGST,TAMT,TODIS,TTNET,ADV,NETAMT1,NETAMT,CN,CN1,CN2,CREDIT,DISCNT,DISCNT1,DISCNT2,XL,BC,LS,BC1,XL1,LS1,EWAYBILL,EWAYDATE,
         EWAY,EWAYDT,CREDIT,CREDITBAL,CREDITBAL1,ADJ,TOTNET,TOTJOIG,TOTJOCG,TOTJOSG,TOTDIS,TTAXABLE,TZDIT,TOTTAXABLE,RVAL,RVAL1,CNT1,NETAMT2,XLVAL,BCVAL,LSVAL.
          REFRESH :MMLINE1,MMLINE2.
          REFRESH ITLINE.
          CLEAR : ITLINE.
        ENDLOOP.
**********************************************************


*    CALL FUNCTION 'SSF_CLOSE'.

*    * Get Output Text Format (OTF)
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
        IN_MAILID = S_EMAIL-LOW.
        PERFORM SEND_MAIL USING IN_MAILID .
*
      ENDLOOP.
    ENDLOOP.
  ELSEIF P3 EQ 'X'.

    LOOP AT IT_VBRK INTO WA_VBRK.
      WA_CUS1-KUNAG = WA_VBRK-KUNAG.
      WA_CUS1-VBELN = WA_VBRK-VBELN.
      COLLECT WA_CUS1 INTO IT_CUS1.
      CLEAR WA_CUS1.
    ENDLOOP.
    SORT IT_CUS1 .
    DELETE ADJACENT DUPLICATES FROM IT_CUS1 COMPARING KUNAG VBELN.
    LOOP AT IT_CUS1 INTO WA_CUS1.
      SELECT SINGLE * FROM KNA1 WHERE KUNNR EQ WA_CUS1-KUNAG.
      IF SY-SUBRC EQ 0.
        SELECT SINGLE * FROM ADR6 WHERE ADDRNUMBER EQ KNA1-ADRNR.
        IF SY-SUBRC EQ 0.
          WA_CUS2-KUNAG = WA_CUS1-KUNAG.
          WA_CUS2-VBELN = WA_CUS1-VBELN.
          WA_CUS2-SMTP_ADDR = ADR6-SMTP_ADDR.
          COLLECT WA_CUS2 INTO IT_CUS2.
          CLEAR WA_CUS2.
        ENDIF.
      ENDIF.
    ENDLOOP.

*    LOOP AT IT_CHECK INTO WA_CHECK.

    LOOP AT IT_CUS2 INTO WA_CUS2.
      LOOP AT IT_CHECK1 INTO WA_CHECK1 WHERE VBELN EQ WA_CUS2-VBELN AND KUNAG EQ WA_CUS2-KUNAG.
*        SELECT SINGLE * FROM KNA1 WHERE KUNNR EQ WA_CUS1-KUNAG.
*        IF SY-SUBRC EQ 0.
*          SELECT SINGLE * FROM ADR6 WHERE ADDRNUMBER EQ KNA1-ADRNR.
*          IF SY-SUBRC EQ 0.
*            IF ADR6-SMTP_ADDR IS NOT INITIAL.
        CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
          EXPORTING
*           formname           = 'ZINVSL13'
            FORMNAME           = 'ZINVSL14'
*      p_sform
          IMPORTING
            FM_NAME            = V_FORM_NAME
          EXCEPTIONS
            NO_FORM            = 1
            NO_FUNCTION_MODULE = 2
            OTHERS             = 3.

        IF SY-SUBRC <> 0.
          MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
          WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.

* Set the control parameter
        W_CTRLOP-GETOTF = ABAP_TRUE.
        W_CTRLOP-NO_DIALOG = ABAP_TRUE.
        W_COMPOP-TDNOPREV = ABAP_TRUE.
        W_CTRLOP-PREVIEW = SPACE.
        W_COMPOP-TDDEST = 'LOCL'.

        LOOP AT IT_CHECK INTO WA_CHECK WHERE VBELN EQ WA_CHECK1-VBELN AND KUNAG EQ WA_CUS2-KUNAG.
          CLEAR : VBELN,FKDAT,TAX1.
          CLEAR : NTXT1,NTXT2.
          VBELN = WA_CHECK-VBELN.
          SELECT SINGLE * FROM VBRK WHERE VBELN EQ VBELN.
          IF SY-SUBRC EQ 0.
            FKDAT = VBRK-FKDAT.
          ENDIF.
          IF FKDAT GE '20201001'.
            TCSTXT = 'TCS - IT COLLECTED'.
          ELSE.
            TCSTXT = SPACE.
          ENDIF.

          IF FKDAT GE '20201005'.
*            tcstxt = 'TCS - IT COLLECTED'.
            SELECT SINGLE IRN FROM J_1IG_INVREFNUM INTO IRN WHERE BUKRS EQ '1000' AND DOCNO EQ VBELN AND IRN NE SPACE.
            IF SY-SUBRC EQ 0.
              TAX1 = 'A'.
              NTXT1 = 'TAX INVOICE'.
              NTXT2 = 'Issued under sec. 31 of CGST act, 2017 read with rule 48 of CGST Rule, 2017'.
            ELSE.
              NTXT1 = 'PACKING LIST'.
              NTXT2 = SPACE.
            ENDIF.
          ELSE.
*            tcstxt = space.
            TAX1 = 'A'.
            NTXT1 = 'TAX INVOICE'.
            NTXT2 = 'Issued under sec. 31 of CGST act, 2017 read with rule 48 of CGST Rule, 2017'.
          ENDIF.

          PERFORM FORM1.

          IF R2 EQ 'X'.
            EWAY1 = 'E-WAY BILL NO.:'.
            EWAY2 = 'DATE:'.
          ENDIF.

*******************check for eway bill CONDITION*************************
          PERFORM EWAYCHECK.

*          IF TAX1 NE SPACE.
*            IF EWAY EQ SPACE.
*              SELECT SINGLE * FROM VBRK WHERE VBELN EQ WA_CHECK-VBELN.
*              IF SY-SUBRC EQ 0.
*                SELECT SINGLE * FROM VBRP WHERE VBELN EQ VBRK-VBELN AND WERKS NE '2007' AND WERKS NE '2016' .
*                IF SY-SUBRC EQ 0.
*                  IF TOTJOIG GT 0.
*                    ITYP = 'ZSTO'.
*                  ELSE.
*                    ITYP = 'ZSTI'.
*                  ENDIF.
*                  SELECT SINGLE * FROM T001W WHERE WERKS EQ VBRP-WERKS .
*                  IF SY-SUBRC EQ 0.
*                    SELECT SINGLE * FROM ZEWAY_LIMIT WHERE REGIO EQ T001W-REGIO AND FKART EQ ITYP.
*                    IF SY-SUBRC EQ 0.
*                      IF ZEWAY_LIMIT-NETWR LE ( VBRK-NETWR + VBRK-MWSBK ).
*                        CLEAR TAX1.
*
*                        NTXT1 = 'PACKING LIST'.
*                        NTXT2 = SPACE.
*
*                      ENDIF.
*                    ENDIF.
*                  ENDIF.
*                ENDIF.
*              ENDIF.
*            ENDIF.
*          ENDIF.

*******************************************************************

          CALL FUNCTION V_FORM_NAME
*        call function v_fm
            EXPORTING
              CONTROL_PARAMETERS = W_CTRLOP
              OUTPUT_OPTIONS     = W_COMPOP
              USER_SETTINGS      = ABAP_TRUE
              FORMAT             = FORMAT
              PNAME1             = PNAME1
              PNAME2             = PNAME2
              PNAME3             = PNAME3
              PNAME4             = PNAME4
              PHONE              = PHONE
              DRUG               = DRUG
              E_TINNO            = E_TINNO
              E_STATE            = E_STATE
              PCITY1             = PCITY1
              A_KUNNR            = A_KUNNR
              BILLNO             = VBELN
              BDATE1             = BDATE1
              BTIME              = BTIME
              INVTYP1            = INVTYP1
              INVTYP2            = INVTYP2
              W_ZFBDT1           = W_ZFBDT1
              CNAME1             = CNAME1
              CNAME2             = CNAME2
              CNAME3             = CNAME3
              CNAME4             = CNAME4
              C_STATE            = C_STATE
              CCITY              = CCITY
              V_BSTNK            = V_BSTNK
              V_BSTDK            = V_BSTDK
              EXTENSION1         = EXTENSION1
              TINNO              = TINNO
              PANNO              = PANNO
              V_BAHNS            = V_BAHNS
              V_BAHNE            = V_BAHNE
              V_NAME1            = V_NAME1
              CCITY1             = CCITY1
              V_BOLNR            = V_BOLNR
              V_ZFBDT            = V_ZFBDT
              NOCASE             = NOCASE
              EWAYBILL           = EWAYBILL
              EWAYDATE           = EWAYDATE
              EWAY1              = EWAY1
              EWAY2              = EWAY2
              TVAL               = TVAL
              TDIS               = TDIS
              TZDIT              = TZDIT
              TTAXABLE           = TTAXABLE
              TOTJOIG            = TOTJOIG
              TOTJOCG            = TOTJOCG
              TOTJOSG            = TOTJOSG
              TOTTAXABLE         = TOTTAXABLE
              TAMT               = TAMT
              ADV                = ADV
              CN                 = CN
              RVAL1              = RVAL1
              NETAMT             = NETAMT
              SPARTVAL           = SPARTVAL
              CREDIT             = CREDIT
              ADJ                = ADJ
              CREDITBAL          = CREDITBAL
              DISCNT             = DISCNT
              W_ZFBDT            = W_ZFBDT
              TCS                = TCS
              NTXT1              = NTXT1
              NTXT2              = NTXT2
              TCSTXT             = TCSTXT
              NLEMTXT            = NLEMTXT
              TAX1               = TAX1
              CPSTLZ             = CPSTLZ
*             P_DOCNO            = vbeln
            IMPORTING
              JOB_OUTPUT_INFO    = W_RETURN " This will have all output
*
            TABLES
              IT_TAB2            = IT_TAB2
            EXCEPTIONS
              FORMATTING_ERROR   = 1
              INTERNAL_ERROR     = 2
              SEND_ERROR         = 3
              USER_CANCELED      = 4
              OTHERS             = 5.

          CLEAR : TVAL,TDIS,TNET,IGST,CGST,SGST,TAMT,TODIS,TTNET,ADV,NETAMT1,NETAMT,CN,CN1,CN2,CREDIT,DISCNT,DISCNT1,DISCNT2,XL,BC,LS,BC1,XL1,LS1,EWAYBILL,EWAYDATE,
         EWAY,EWAYDT,CREDIT,CREDITBAL,CREDITBAL1,ADJ,TOTNET,TOTJOIG,TOTJOCG,TOTJOSG,TOTDIS,TTAXABLE,TZDIT,TOTTAXABLE,RVAL,RVAL1,CNT1,NETAMT2,XLVAL,BCVAL,LSVAL.
          REFRESH :MMLINE1,MMLINE2.
          REFRESH ITLINE.
          CLEAR : ITLINE.
        ENDLOOP.
**********************************************************


*    CALL FUNCTION 'SSF_CLOSE'.

*    * Get Output Text Format (OTF)
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
*    LOOP AT S_EMAIL.
*      CLEAR IN_MAILID.

        IN_MAILID = WA_CUS2-SMTP_ADDR.
        PERFORM SEND_MAIL USING IN_MAILID .
*    ENDLOOP.
*      ENDIF.
*    ENDIF.
*  ENDIF.
      ENDLOOP.
    ENDLOOP.



  ELSEIF P4 EQ 'X'.

    LOOP AT IT_VBRK INTO WA_VBRK.
      WA_CUS3-KUNAG = WA_VBRK-KUNAG.
      WA_CUS3-VBELN = WA_VBRK-VBELN.
      COLLECT WA_CUS3 INTO IT_CUS3.
      CLEAR WA_CUS3.
    ENDLOOP.
    SORT IT_CUS3 .
    DELETE ADJACENT DUPLICATES FROM IT_CUS3 COMPARING KUNAG VBELN .
    LOOP AT IT_CUS3 INTO WA_CUS3.
      MDIV = ''.
      MCNT = 0.
*      clear it_vbrp.
*      select * FROM vbrp into table it_vbrp where vbeln = wa_cus3-vbeln and werks = plant.
      LOOP AT IT_VBRP INTO WA_VBRP WHERE VBELN = WA_CUS3-VBELN.
        MCNT = MCNT + 1.
        IF MDIV NE WA_VBRP-SPART.
          IF MCNT = 1.

            WA_CUS3-SPART = WA_VBRP-SPART.
            WA_CUS3-BEGDA = WA_VBRP-FBUDA.
            MODIFY IT_CUS3 FROM WA_CUS3 TRANSPORTING SPART BEGDA.
          ELSE.

            WA_CUS3-SPART = '99'.
            WA_CUS3-BEGDA = WA_VBRP-FBUDA.
            MODIFY IT_CUS3 FROM WA_CUS3 TRANSPORTING SPART BEGDA.
            EXIT.
          ENDIF.

        ENDIF.

        MDIV = WA_VBRP-SPART.
      ENDLOOP.
    ENDLOOP.



*
*    LOOP AT IT_VBRK INTO WA_VBRK.
*      WA_CUS1-KUNAG = WA_VBRK-KUNAG.
*      WA_CUS1-VBELN = WA_VBRK-VBELN.
*      COLLECT WA_CUS1 INTO IT_CUS1.
*      CLEAR WA_CUS1.
*    ENDLOOP.
*    SORT IT_CUS1 .
*    DELETE ADJACENT DUPLICATES FROM IT_CUS1 COMPARING KUNAG.
*    DATE1 = SY-DATUM.
*    DATE1+6(2) = '01'.

*    CALL FUNCTION 'HR_JP_MONTH_BEGIN_END_DATE'
*      EXPORTING
*        IV_DATE           = DATE1
*      IMPORTING
**       EV_MONTH_BEGIN_DATE       =
*        EV_MONTH_END_DATE = DATE2.
**    WRITE : / DATE1,DATE2.
*    SELECT * FROM ZDSMTER INTO TABLE IT_ZDSMTER WHERE ZMONTH EQ SY-DATUM+4(2) AND ZYEAR EQ SY-DATUM+0(4).
*
*    SELECT * FROM YSD_CUS_DIV_DIS INTO TABLE IT_YSD_CUS_DIV_DIS FOR ALL ENTRIES IN IT_CUS1 WHERE KUNNR EQ IT_CUS1-KUNAG AND BEGDA GE DATE1 AND BEGDA LE DATE2.
*    LOOP AT IT_YSD_CUS_DIV_DIS INTO WA_YSD_CUS_DIV_DIS.
*      WA_MAIL1-KUNAG = WA_YSD_CUS_DIV_DIS-KUNNR.
*      WA_MAIL1-BZIRK = WA_YSD_CUS_DIV_DIS-BZIRK.
*      WA_MAIL1-SPART = WA_YSD_CUS_DIV_DIS-SPART.
*      COLLECT WA_MAIL1 INTO IT_MAIL1.
*      CLEAR WA_MAIL1.
*    ENDLOOP.
*
*    LOOP AT IT_MAIL1 INTO WA_MAIL1.
*      WA_MAIL2-KUNAG = WA_MAIL1-KUNAG.
*      WA_MAIL2-BZIRK = WA_MAIL1-BZIRK.
*      COLLECT WA_MAIL2 INTO IT_MAIL2.
*      READ TABLE IT_ZDSMTER INTO WA_ZDSMTER WITH KEY BZIRK = WA_MAIL1-BZIRK SPART = WA_MAIL1-SPART ZDSM+0(2) = 'R-'.
*      IF SY-SUBRC EQ 0.
*        WA_MAIL2-KUNAG = WA_MAIL1-KUNAG.
*        WA_MAIL2-BZIRK = WA_ZDSMTER-ZDSM.
*        COLLECT WA_MAIL2 INTO IT_MAIL2.
**        WRITE : / 'RM',WA_ZDSMTER-ZDSM.
*        READ TABLE IT_ZDSMTER INTO WA_ZDSMTER WITH KEY BZIRK = WA_ZDSMTER-ZDSM ZDSM+0(2) = 'Z-'.
*        IF SY-SUBRC EQ 0.
**          WRITE : / 'DZM',WA_ZDSMTER-ZDSM.
*          WA_MAIL2-KUNAG = WA_MAIL1-KUNAG.
*          WA_MAIL2-BZIRK = WA_ZDSMTER-ZDSM.
*          COLLECT WA_MAIL2 INTO IT_MAIL2.
*        ENDIF.
*        READ TABLE IT_ZDSMTER INTO WA_ZDSMTER WITH KEY BZIRK = WA_ZDSMTER-ZDSM ZDSM+0(2) = 'D-'.
*        IF SY-SUBRC EQ 0.
**          WRITE : / 'ZM',WA_ZDSMTER-ZDSM.
*          WA_MAIL2-KUNAG = WA_MAIL1-KUNAG.
*          WA_MAIL2-BZIRK = WA_ZDSMTER-ZDSM.
*          COLLECT WA_MAIL2 INTO IT_MAIL2.
*        ENDIF.
*      ENDIF.
*      CLEAR : WA_MAIL1.
*    ENDLOOP.
*
*    SORT IT_MAIL2 .
*    LOOP AT IT_MAIL2 INTO WA_MAIL2.
*      SELECT SINGLE * FROM YTERRALLC WHERE BZIRK EQ WA_MAIL2-BZIRK AND ENDDA GE SY-DATUM.
*      IF SY-SUBRC EQ 0.
*        SELECT SINGLE * FROM PA0001 WHERE PLANS EQ YTERRALLC-PLANS AND ENDDA GT SY-DATUM.
*        IF SY-SUBRC EQ 0.
*          SELECT SINGLE * FROM PA0105 WHERE PERNR EQ PA0001-PERNR AND SUBTY EQ '0010'.
*          IF SY-SUBRC EQ 0.
*            IF PA0105-USRID_LONG NE SPACE.
**              WRITE : / pa0001-pernr,wa_mail2-kunag,wa_mail2-bzirk,PA0105-USRID_LONG.
*              WA_MAIL3-KUNAG = WA_MAIL2-KUNAG.
*              WA_MAIL3-USRID_LONG = PA0105-USRID_LONG.
*              COLLECT WA_MAIL3 INTO IT_MAIL3.
*              CLEAR WA_MAIL3.
*            ENDIF.
*          ENDIF.
*        ENDIF.
*      ENDIF.
*    ENDLOOP.



*    EXIT.

*    LOOP AT IT_MAIL2 INTO WA_MAIL2.
    LOOP AT IT_CUS3 INTO WA_CUS3.
      PERFORM GET_MAIL_ADDRESS USING WA_CUS3-KUNAG WA_CUS3-SPART  WA_CUS3-BEGDA.
*      SELECT SINGLE * FROM kna1 WHERE kunnr EQ wa_cus3-kunag.
*      IF sy-subrc EQ 0.
*        SELECT SINGLE * FROM adr6 WHERE addrnumber EQ kna1-adrnr.
*        IF sy-subrc EQ 0.
*          IF adr6-smtp_addr IS NOT INITIAL.
      CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
        EXPORTING
*         FORMNAME           = 'ZINVSL13'
          FORMNAME           = 'ZINVSL14'
*      p_sform
        IMPORTING
          FM_NAME            = V_FORM_NAME
        EXCEPTIONS
          NO_FORM            = 1
          NO_FUNCTION_MODULE = 2
          OTHERS             = 3.

      IF SY-SUBRC <> 0.
        MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
        WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.

* Set the control parameter
      W_CTRLOP-GETOTF = ABAP_TRUE.
      W_CTRLOP-NO_DIALOG = ABAP_TRUE.
      W_COMPOP-TDNOPREV = ABAP_TRUE.
      W_CTRLOP-PREVIEW = SPACE.
      W_COMPOP-TDDEST = 'LOCL'.

      LOOP AT IT_CHECK INTO WA_CHECK WHERE KUNAG EQ WA_CUS3-KUNAG AND VBELN = WA_CUS3-VBELN.
        CLEAR : VBELN,FKDAT,TAX1.
        CLEAR : NTXT1,NTXT2.
        VBELN = WA_CHECK-VBELN.
        SELECT SINGLE * FROM VBRK WHERE VBELN EQ VBELN.
        IF SY-SUBRC EQ 0.
          FKDAT = VBRK-FKDAT.
        ENDIF.
        IF FKDAT GE '20201001'.
          TCSTXT = 'TCS - IT COLLECTED'.
        ELSE.
          TCSTXT = SPACE.
        ENDIF.

        IF FKDAT GE '20201005'.
*                tcstxt = 'TCS - IT COLLECTED'.
          SELECT SINGLE IRN FROM J_1IG_INVREFNUM INTO IRN WHERE BUKRS EQ '1000' AND DOCNO EQ VBELN AND IRN NE SPACE.
          IF SY-SUBRC EQ 0.
            TAX1 = 'A'.
            NTXT1 = 'TAX INVOICE'.
            NTXT2 = 'Issued under sec. 31 of CGST act, 2017 read with rule 48 of CGST Rule, 2017'.
          ELSE.
            NTXT1 = 'PACKING LIST'.
            NTXT2 = SPACE.
          ENDIF.
        ELSE.
*                tcstxt = space.
          TAX1 = 'A'.
          NTXT1 = 'TAX INVOICE'.
          NTXT2 = 'Issued under sec. 31 of CGST act, 2017 read with rule 48 of CGST Rule, 2017'.
        ENDIF.

        PERFORM FORM1.

        IF R2 EQ 'X'.
          EWAY1 = 'E-WAY BILL NO.:'.
          EWAY2 = 'DATE:'.
        ENDIF.


*******************check for eway bill CONDITION*************************
        PERFORM EWAYCHECK.

*        IF TAX1 NE SPACE.
*          IF EWAY EQ SPACE.
*            SELECT SINGLE * FROM VBRK WHERE VBELN EQ WA_CHECK-VBELN.
*            IF SY-SUBRC EQ 0.
*              SELECT SINGLE * FROM VBRP WHERE VBELN EQ VBRK-VBELN AND WERKS NE '2007' AND WERKS NE '2016' .
*              IF SY-SUBRC EQ 0.
*                IF TOTJOIG GT 0.
*                  ITYP = 'ZSTO'.
*                ELSE.
*                  ITYP = 'ZSTI'.
*                ENDIF.
*                SELECT SINGLE * FROM T001W WHERE WERKS EQ VBRP-WERKS .
*                IF SY-SUBRC EQ 0.
*                  SELECT SINGLE * FROM ZEWAY_LIMIT WHERE REGIO EQ T001W-REGIO AND FKART EQ ITYP.
*                  IF SY-SUBRC EQ 0.
*                    IF ZEWAY_LIMIT-NETWR LE ( VBRK-NETWR + VBRK-MWSBK ).
*                      CLEAR TAX1.
*
*                      NTXT1 = 'PACKING LIST'.
*                      NTXT2 = SPACE.
*
*                    ENDIF.
*                  ENDIF.
*                ENDIF.
*              ENDIF.
*            ENDIF.
*          ENDIF.
*        ENDIF.
*******************************************************************

        CALL FUNCTION V_FORM_NAME
*        call function v_fm
          EXPORTING
            CONTROL_PARAMETERS = W_CTRLOP
            OUTPUT_OPTIONS     = W_COMPOP
            USER_SETTINGS      = ABAP_TRUE
            FORMAT             = FORMAT
            PNAME1             = PNAME1
            PNAME2             = PNAME2
            PNAME3             = PNAME3
            PNAME4             = PNAME4
            PHONE              = PHONE
            DRUG               = DRUG
            E_TINNO            = E_TINNO
            E_STATE            = E_STATE
            PCITY1             = PCITY1
            A_KUNNR            = A_KUNNR
            BILLNO             = VBELN
            BDATE1             = BDATE1
            BTIME              = BTIME
            INVTYP1            = INVTYP1
            INVTYP2            = INVTYP2
            W_ZFBDT1           = W_ZFBDT1
            CNAME1             = CNAME1
            CNAME2             = CNAME2
            CNAME3             = CNAME3
            CNAME4             = CNAME4
            C_STATE            = C_STATE
            CCITY              = CCITY
            V_BSTNK            = V_BSTNK
            V_BSTDK            = V_BSTDK
            EXTENSION1         = EXTENSION1
            TINNO              = TINNO
            PANNO              = PANNO
            V_BAHNS            = V_BAHNS
            V_BAHNE            = V_BAHNE
            V_NAME1            = V_NAME1
            CCITY1             = CCITY1
            V_BOLNR            = V_BOLNR
            V_ZFBDT            = V_ZFBDT
            NOCASE             = NOCASE
            EWAYBILL           = EWAYBILL
            EWAYDATE           = EWAYDATE
            EWAY1              = EWAY1
            EWAY2              = EWAY2
            TVAL               = TVAL
            TDIS               = TDIS
            TZDIT              = TZDIT
            TTAXABLE           = TTAXABLE
            TOTJOIG            = TOTJOIG
            TOTJOCG            = TOTJOCG
            TOTJOSG            = TOTJOSG
            TOTTAXABLE         = TOTTAXABLE
            TAMT               = TAMT
            ADV                = ADV
            CN                 = CN
            RVAL1              = RVAL1
            NETAMT             = NETAMT
            SPARTVAL           = SPARTVAL
            CREDIT             = CREDIT
            ADJ                = ADJ
            CREDITBAL          = CREDITBAL
            DISCNT             = DISCNT
            W_ZFBDT            = W_ZFBDT
            TCS                = TCS
            NTXT1              = NTXT1
            NTXT2              = NTXT2
            TCSTXT             = TCSTXT
            NLEMTXT            = NLEMTXT
            TAX1               = TAX1
            CPSTLZ             = CPSTLZ
*           P_DOCNO            = vbeln
          IMPORTING
            JOB_OUTPUT_INFO    = W_RETURN " This will have all output
*
          TABLES
            IT_TAB2            = IT_TAB2
          EXCEPTIONS
            FORMATTING_ERROR   = 1
            INTERNAL_ERROR     = 2
            SEND_ERROR         = 3
            USER_CANCELED      = 4
            OTHERS             = 5.

        CLEAR : TVAL,TDIS,TNET,IGST,CGST,SGST,TAMT,TODIS,TTNET,ADV,NETAMT1,NETAMT,CN,CN1,CN2,CREDIT,DISCNT,DISCNT1,DISCNT2,XL,BC,BC1,XL1,LS,LS1,EWAYBILL,EWAYDATE,
       EWAY,EWAYDT,CREDIT,CREDITBAL,CREDITBAL1,ADJ,TOTNET,TOTJOIG,TOTJOCG,TOTJOSG,TOTDIS,TTAXABLE,TZDIT,TOTTAXABLE,RVAL,RVAL1,CNT1,NETAMT2,XLVAL,BCVAL,LSVAL.
        REFRESH :MMLINE1,MMLINE2.
        REFRESH ITLINE.
        CLEAR : ITLINE.
      ENDLOOP.
**********************************************************


*    CALL FUNCTION 'SSF_CLOSE'.

*    * Get Output Text Format (OTF)
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
      LOOP AT IT_MAIL3 INTO WA_MAIL3 WHERE KUNAG EQ WA_CUS3-KUNAG.
        CLEAR IN_MAILID.
        IN_MAILID = WA_MAIL3-USRID_LONG.
        PERFORM SEND_MAIL USING IN_MAILID .
      ENDLOOP.
*          ENDIF.
*        ENDIF.
*      ENDIF.
    ENDLOOP.

  ENDIF.



FORM GET_MAIL_ADDRESS USING CUST_CODE DIV DATE.
  REFRESH : IT_MAIL1, IT_MAIL2,IT_MAIL3.
  DATE1 = DATE.
  DATE1+6(2) = '01'.

  CALL FUNCTION 'HR_JP_MONTH_BEGIN_END_DATE'
    EXPORTING
      IV_DATE           = DATE1
    IMPORTING
*     EV_MONTH_BEGIN_DATE       =
      EV_MONTH_END_DATE = DATE2.
*    WRITE : / DATE1,DATE2.
  SELECT * FROM ZDSMTER INTO TABLE IT_ZDSMTER WHERE ZMONTH EQ DATE1+4(2) AND ZYEAR EQ DATE1+0(4).
  IF DIV = 99.
    SELECT * FROM YSD_CUS_DIV_DIS INTO TABLE IT_YSD_CUS_DIV_DIS WHERE KUNNR = CUST_CODE   AND BEGDA GE DATE1 AND BEGDA LE DATE2.
    LOOP AT IT_YSD_CUS_DIV_DIS INTO WA_YSD_CUS_DIV_DIS.
      WA_MAIL1-KUNAG = WA_YSD_CUS_DIV_DIS-KUNNR.
      WA_MAIL1-BZIRK = WA_YSD_CUS_DIV_DIS-BZIRK.
      WA_MAIL1-SPART = WA_YSD_CUS_DIV_DIS-SPART.
      COLLECT WA_MAIL1 INTO IT_MAIL1.
      CLEAR WA_MAIL1.
    ENDLOOP.
  ELSE.
    SELECT * FROM YSD_CUS_DIV_DIS INTO TABLE IT_YSD_CUS_DIV_DIS WHERE KUNNR = CUST_CODE  AND SPART = DIV  AND BEGDA GE DATE1 AND BEGDA LE DATE2.
    LOOP AT IT_YSD_CUS_DIV_DIS INTO WA_YSD_CUS_DIV_DIS.
      WA_MAIL1-KUNAG = WA_YSD_CUS_DIV_DIS-KUNNR.
      WA_MAIL1-BZIRK = WA_YSD_CUS_DIV_DIS-BZIRK.
      WA_MAIL1-SPART = WA_YSD_CUS_DIV_DIS-SPART.
      COLLECT WA_MAIL1 INTO IT_MAIL1.
      CLEAR WA_MAIL1.
    ENDLOOP.

  ENDIF.

  LOOP AT IT_MAIL1 INTO WA_MAIL1.
    WA_MAIL2-KUNAG = WA_MAIL1-KUNAG.
    WA_MAIL2-BZIRK = WA_MAIL1-BZIRK.
    COLLECT WA_MAIL2 INTO IT_MAIL2.
    READ TABLE IT_ZDSMTER INTO WA_ZDSMTER WITH KEY BZIRK = WA_MAIL1-BZIRK SPART = WA_MAIL1-SPART ZDSM+0(2) = 'R-'.
    IF SY-SUBRC EQ 0.
      WA_MAIL2-KUNAG = WA_MAIL1-KUNAG.
      WA_MAIL2-BZIRK = WA_ZDSMTER-ZDSM.
      COLLECT WA_MAIL2 INTO IT_MAIL2.
*        WRITE : / 'RM',WA_ZDSMTER-ZDSM.
      READ TABLE IT_ZDSMTER INTO WA_ZDSMTER WITH KEY BZIRK = WA_ZDSMTER-ZDSM ZDSM+0(2) = 'Z-'.
      IF SY-SUBRC EQ 0.
*          WRITE : / 'DZM',WA_ZDSMTER-ZDSM.
        WA_MAIL2-KUNAG = WA_MAIL1-KUNAG.
        WA_MAIL2-BZIRK = WA_ZDSMTER-ZDSM.
        COLLECT WA_MAIL2 INTO IT_MAIL2.
      ENDIF.
      READ TABLE IT_ZDSMTER INTO WA_ZDSMTER WITH KEY BZIRK = WA_ZDSMTER-ZDSM ZDSM+0(2) = 'D-'.
      IF SY-SUBRC EQ 0.
*          WRITE : / 'ZM',WA_ZDSMTER-ZDSM.
        WA_MAIL2-KUNAG = WA_MAIL1-KUNAG.
        WA_MAIL2-BZIRK = WA_ZDSMTER-ZDSM.
        COLLECT WA_MAIL2 INTO IT_MAIL2.
      ENDIF.
    ENDIF.
    CLEAR : WA_MAIL1.
  ENDLOOP.

  SORT IT_MAIL2 .
  LOOP AT IT_MAIL2 INTO WA_MAIL2.
    SELECT SINGLE * FROM YTERRALLC WHERE BZIRK EQ WA_MAIL2-BZIRK AND ENDDA GE SY-DATUM.
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM PA0001 WHERE PLANS EQ YTERRALLC-PLANS AND ENDDA GT SY-DATUM.
      IF SY-SUBRC EQ 0.
        SELECT SINGLE * FROM PA0105 WHERE PERNR EQ PA0001-PERNR AND SUBTY EQ '0010'.
        IF SY-SUBRC EQ 0.
          IF PA0105-USRID_LONG NE SPACE.
*              WRITE : / pa0001-pernr,wa_mail2-kunag,wa_mail2-bzirk,PA0105-USRID_LONG.
            WA_MAIL3-KUNAG = WA_MAIL2-KUNAG.
            WA_MAIL3-USRID_LONG = PA0105-USRID_LONG.
            COLLECT WA_MAIL3 INTO IT_MAIL3.
            CLEAR WA_MAIL3.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.



ENDFORM.


*************************************************************************

*  *&---------------------------------------------------------------------*
*&      Form  ADV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ADV.
  CLEAR : IT_BSAD, ADV.
  SELECT * FROM BSAD INTO TABLE IT_BSAD WHERE BUKRS EQ '1000' AND KUNNR EQ WA_VBRK-KUNAG AND UMSKS EQ 'A' AND UMSKZ EQ 'V' AND BUDAT EQ WA_VBRK-FKDAT
    AND BLART EQ 'DZ'.
  IF IT_BSAD IS NOT INITIAL.
    CLEAR : ADV.
    LOOP AT IT_BSAD INTO WA_BSAD.
      CLEAR : ADV,ADV1.
      ADV = WA_BSAD-DMBTR.
      ADV1 = ADV.
      CONDENSE ADV1.
      SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000' AND BELNR EQ WA_BSAD-BELNR AND GJAHR = WA_BSAD-GJAHR AND BSCHL EQ '40'.
      IF SY-SUBRC EQ 0.
        CONCATENATE 'ADV DD NO.' BSEG-ZUONR '-' ADV1 INTO ADJ SEPARATED BY SPACE.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CN .
  CLEAR : IT_BSAD,CN,V_BELNR,V_GJAHR,W_ZFBDT,W_ZFBDT1.
  SELECT SINGLE BELNR GJAHR INTO (V_BELNR, V_GJAHR ) FROM BKPF  WHERE AWTYP EQ 'VBRK'   AND AWKEY EQ WA_VBRK-VBELN AND BUKRS EQ WA_VBRK-BUKRS.

  SELECT SINGLE * FROM BSID WHERE BUKRS EQ '1000' AND KUNNR EQ WA_VBRK-KUNAG AND BELNR EQ V_BELNR AND GJAHR EQ V_GJAHR.
  IF SY-SUBRC EQ 0.
    W_ZFBDT = BSID-ZFBDT + BSID-ZBD1T.
  ELSE.
    SELECT SINGLE * FROM BSAD WHERE BUKRS EQ '1000' AND KUNNR EQ WA_VBRK-KUNAG AND BELNR EQ V_BELNR AND GJAHR EQ V_GJAHR.
    IF SY-SUBRC EQ 0.
      W_ZFBDT = BSAD-ZFBDT + BSAD-ZBD1T.
    ENDIF.
  ENDIF.

  W_ZFBDT1+0(2) = W_ZFBDT+6(2).
  W_ZFBDT1+2(1) = '/'.
  W_ZFBDT1+3(2) = W_ZFBDT+4(2).
  W_ZFBDT1+5(1) = '/'.
  W_ZFBDT1+6(4) = W_ZFBDT+0(4).

*  WRITE : / V_BELNR,V_GJAHR.
  SELECT * FROM BSAD INTO TABLE IT_BSAD1 WHERE BUKRS EQ '1000' AND KUNNR EQ WA_VBRK-KUNAG AND BELNR EQ V_BELNR AND GJAHR EQ V_GJAHR.
  IF SY-SUBRC EQ 0.
    SELECT * FROM BSAD INTO TABLE IT_BSAD FOR ALL ENTRIES IN IT_BSAD1 WHERE BUKRS EQ '1000' AND KUNNR EQ IT_BSAD1-KUNNR AND AUGBL EQ IT_BSAD1-AUGBL AND AUGDT EQ
      IT_BSAD1-AUGDT AND BSCHL IN ( '11', '14', '40','16','19' ).
  ENDIF.

  CLEAR : CNVAL1,W_CREDIT,CN1,CN,CREDIT.
  LOOP AT IT_BSAD INTO WA_BSAD WHERE BSCHL = '11'.
    CONCATENATE CREDIT 'CN' INTO CREDIT.
    EXIT.
  ENDLOOP.
  LOOP AT IT_BSAD INTO WA_BSAD WHERE BSCHL = '11' OR BSCHL = '14' OR  BSCHL = '16'..
    CLEAR : CNVAL,CNVAL1.
    IF WA_BSAD-SHKZG EQ 'S'.
      WA_BSAD-DMBTR = WA_BSAD-DMBTR * ( - 1 ).
    ENDIF.
    CN = CN + WA_BSAD-DMBTR.
    CNVAL1 = WA_BSAD-DMBTR.
    W_CREDIT = W_CREDIT + CNVAL1.
    CONDENSE CNVAL1.
    IF WA_BSAD-VBELN IS INITIAL.
      CONCATENATE CREDIT WA_BSAD-BELNR '-' CNVAL1 INTO CREDIT SEPARATED BY SPACE.
    ELSE.
      CONCATENATE CREDIT WA_BSAD-VBELN '-' CNVAL1 ',' INTO CREDIT SEPARATED BY SPACE.
    ENDIF.
  ENDLOOP.

************ advance********************
  CLEAR : ADJ,ADV,ADV1,ADVTXT.
  LOOP AT IT_BSAD INTO WA_BSAD WHERE BSCHL = '19'.
    CONCATENATE ADJ 'ADV DD NO:' INTO ADJ.
    EXIT.
  ENDLOOP.

  LOOP AT IT_BSAD INTO WA_BSAD WHERE BSCHL = '19'.
    CLEAR : ADV2.
    IF WA_BSAD-SHKZG EQ 'S'.
      WA_BSAD-DMBTR = WA_BSAD-DMBTR * ( - 1 ).
    ENDIF.
    ADV = ADV + WA_BSAD-DMBTR.
    ADV1 = ADV.
    ADV2 = WA_BSAD-DMBTR.
*    CNVAL1 = WA_BSAD-DMBTR.
*    W_CREDIT = W_CREDIT + CNVAL1.
*    CONDENSE CNVAL1.
    SELECT SINGLE * FROM BSEG WHERE BUKRS EQ '1000' AND BELNR EQ WA_BSAD-BELNR AND GJAHR = WA_BSAD-GJAHR AND BSCHL EQ '40'.
    IF SY-SUBRC EQ 0.
      ADVTXT = BSEG-ZUONR.
*      WRITE :  / BSEG-BELNR,ADJ, BSEG-ZUONR, ADV2.
    ENDIF.
    CONCATENATE ADJ ADVTXT '-' ADV2 ',' INTO ADJ SEPARATED BY SPACE.
  ENDLOOP.
  CONDENSE ADJ.
*WRITE : ADJ.
*******************

*   CLEAR : IT_BSAD, ADV.
*  SELECT * FROM BSAD INTO TABLE IT_BSAD WHERE BUKRS EQ 'BCLL' AND KUNNR EQ WA_VBRK-KUNAG AND UMSKS EQ 'A' AND UMSKZ EQ 'V' AND BUDAT EQ WA_VBRK-FKDAT
*    AND BLART EQ 'DZ'.
*  IF IT_BSAD IS NOT INITIAL.
*    CLEAR : ADV.
*    LOOP AT IT_BSAD INTO WA_BSAD.
*      CLEAR : ADV,ADV1.
*      ADV = WA_BSAD-DMBTR.
*      ADV1 = ADV.
*      CONDENSE ADV1.
*      SELECT SINGLE * FROM BSEG WHERE BUKRS EQ 'BCLL' AND BELNR EQ WA_BSAD-BELNR AND GJAHR = WA_BSAD-GJAHR AND BSCHL EQ '40'.
*      IF SY-SUBRC EQ 0.
*        CONCATENATE 'ADV DD NO.' BSEG-ZUONR '-' ADV1 INTO ADJ SEPARATED BY SPACE.
*      ENDIF.
*    ENDLOOP.
*  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  AUTHORIZATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM AUTHORIZATION .
  SELECT WERKS NAME1 FROM T001W INTO TABLE ITAB_T001W WHERE WERKS EQ PLANT.

  LOOP AT ITAB_T001W INTO WA_T001W.
    AUTHORITY-CHECK OBJECT 'M_BCO_WERK'
           ID 'WERKS' FIELD WA_T001W-WERKS.
    IF SY-SUBRC <> 0.
      CONCATENATE 'No authorization for Plant' WA_T001W-WERKS INTO MSG
      SEPARATED BY SPACE.
      MESSAGE MSG TYPE 'E'.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ADV1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ADV1.
  CLEAR : DISCNT1,DISCNT,DISCNT2.
*  loop at it_tab1 into wa_tab1 where vbeln eq wa_vbrk-vbeln and zdit gt 0.
  LOOP AT IT_TAB1 INTO WA_TAB1 WHERE VBELN EQ WA_VBRK-VBELN AND ODIS GT 0.
*    discnt1 = discnt1 + wa_tab1-zdit.
    DISCNT1 = DISCNT1 + WA_TAB1-ODIS.
  ENDLOOP.
ENDFORM.



*FORM MAIL_REQUIREMENT_TO_PARTY.
*
*  CALL FUNCTION 'CONVERT_OTF'
*    EXPORTING
*      FORMAT       = 'PDF'
*    IMPORTING
*      BIN_FILESIZE = L_BIN_FILESIZE
*    TABLES
*      OTF          = L_OTF_DATA
*      LINES        = L_ASC_DATA.
*
*  CALL FUNCTION 'SX_TABLE_LINE_WIDTH_CHANGE'
*    EXPORTING
*      LINE_WIDTH_DST = '255'
*    TABLES
*      CONTENT_IN     = L_ASC_DATA
*      CONTENT_OUT    = OBJBIN.
*
*
*
*  TYPES: BEGIN OF T_YSD_CUS_DIV_DIS,
*           KUNNR  TYPE KUNNR,
*           SPART  TYPE SPART,
*           ENDDA  TYPE ENDDA,
*           BEGDA  TYPE BEGDA,
*           BZIRK  TYPE BZIRK,
*           PERCNT TYPE CHGPERC_KK,
*         END OF T_YSD_CUS_DIV_DIS.
*
*  TYPES: BEGIN OF T_YTERRALLC,
*           SPART TYPE SPART,
*           BZIRK TYPE BZIRK,
*           ENDDA TYPE ENDDA,
*           BEGDA TYPE BEGDA,
*           PLANS TYPE PLANS,
*         END OF T_YTERRALLC.
*
*
*
*
*  DATA :  WA_BZIRK TYPE BZIRK.
*  DATA :  WA_BZIRK1 TYPE BZIRK.
*
*  DATA :  WA_ZRM TYPE BZIRK.
*  DATA :  WA_ZDSM TYPE BZIRK.
*  DATA :  YYYY(4) TYPE P DECIMALS 0.
*  DATA :  MM(2) TYPE P DECIMALS 0.
*  DATA :  WA_PERNR TYPE PERSNO.
*  DATA :  WA_E_MAIL TYPE COMM_ID_LONG.
*  DATA : V_SPART  TYPE SPART.
*
*
*
*
*  YYYY = BDATE+0(4).
*  MM  = BDATE+4(2).
*  TYPES: BEGIN OF T_EMAIL,
*           BZIRK  TYPE BZIRK,
*           PERNR  TYPE PERSNO,
*           E_MAIL TYPE COMM_ID_LONG,
*         END OF T_EMAIL.
*
*  DATA: IT_YSD_CUS_DIV_DIS TYPE TABLE OF T_YSD_CUS_DIV_DIS,
*        WA_YSD_CUS_DIV_DIS TYPE T_YSD_CUS_DIV_DIS,
*        IT_EMAIL           TYPE TABLE OF T_EMAIL,
*        WA_EMAIL           TYPE T_EMAIL,
*        IT_YTERRALLC       TYPE TABLE OF T_YTERRALLC,
*        WA_YTERRALLC       TYPE T_YTERRALLC.
*  CLEAR : WA_BZIRK, WA_BZIRK1.
**    pary email address
*  SELECT SINGLE ADRNR INTO V_ADRNR FROM VBPA
*  WHERE VBELN = WA_VBRK-VBELN AND PARVW EQ 'AG'.
**  SELECT SINGLE SMTP_ADDR INTO P_EMAIL1 FROM ADR6 WHERE ADDRNUMBER = V_ADRNR AND PERSNUMBER = SPACE.
**  IF  P_EMAIL1 IS INITIAL.
**    P_EMAIL1 = 'DUMMY@BLUECROSSLABS.COM'.
**  ENDIF.
*
*
**  READ TABLE  IT_VBRP INTO WA_VBRP WITH  KEY SPART = '50'.
**  IF SY-SUBRC = 0.
**    V_SPART = '50'.
**    READ TABLE  IT_VBRP   INTO WA_VBRP WITH  KEY SPART = '60'.
**    IF SY-SUBRC = 0.
**      V_SPART = '99'.
**    ENDIF.
**  ELSE.
**    V_SPART = '60'.
**  ENDIF.
*
**  IF V_SPART <> '99'.
**    SELECT   KUNNR SPART ENDDA   BEGDA  BZIRK   PERCNT  FROM  YSD_CUS_DIV_DIS INTO TABLE
**    IT_YSD_CUS_DIV_DIS WHERE KUNNR = WA_TAB1-KUNAG AND SPART = V_SPART AND ENDDA GE BDATE AND BEGDA LE BDATE .
**
**    SORT IT_YSD_CUS_DIV_DIS  BY PERCNT DESCENDING.
**    READ TABLE  IT_YSD_CUS_DIV_DIS INTO WA_YSD_CUS_DIV_DIS WITH KEY KUNNR = WA_TAB1-KUNAG.
**    IF SY-SUBRC = 0.
**      WA_BZIRK = WA_YSD_CUS_DIV_DIS-BZIRK.
**    ENDIF.
**
**  ELSE.
**    SELECT   KUNNR SPART ENDDA   BEGDA  BZIRK   PERCNT  FROM  YSD_CUS_DIV_DIS INTO TABLE
**    IT_YSD_CUS_DIV_DIS WHERE KUNNR = WA_TAB1-KUNAG AND SPART = '50' AND ENDDA GE BDATE AND BEGDA LE BDATE .
**    SORT IT_YSD_CUS_DIV_DIS  BY PERCNT DESCENDING.
**
**
**
**
***    READ TABLE  IT_YSD_CUS_DIV_DIS INTO WA_YSD_CUS_DIV_DIS WITH KEY KUNNR = WA_TAB1-KUNAG.
***    IF SY-SUBRC = 0.
***      WA_BZIRK = WA_YSD_CUS_DIV_DIS-BZIRK.
***    ENDIF.
***
***    SELECT   KUNNR SPART ENDDA   BEGDA  BZIRK   PERCNT  FROM  YSD_CUS_DIV_DIS INTO TABLE
***    IT_YSD_CUS_DIV_DIS WHERE KUNNR = WA_TAB1-KUNAG AND SPART = '60' AND ENDDA GE BDATE AND BEGDA LE BDATE .
***
***    SORT IT_YSD_CUS_DIV_DIS  BY PERCNT DESCENDING.
***    READ TABLE  IT_YSD_CUS_DIV_DIS INTO WA_YSD_CUS_DIV_DIS WITH KEY KUNNR = WA_TAB1-KUNAG.
***    IF SY-SUBRC = 0.
***      WA_BZIRK1 = WA_YSD_CUS_DIV_DIS-BZIRK.
***    ENDIF.
**
**  ENDIF.
*
*
*
**  SELECT   SPART BZIRK ENDDA   BEGDA  PLANS     FROM  YTERRALLC INTO TABLE
**  IT_YTERRALLC WHERE BZIRK = WA_BZIRK AND ENDDA GE BDATE AND BEGDA LE BDATE.
**
**  WA_EMAIL-PERNR = ''.
**  WA_EMAIL-BZIRK = ''.
***  WA_EMAIL-E_MAIL = P_EMAIL1.
**  APPEND WA_EMAIL TO IT_EMAIL.
**  REFRESH IT_YSD_CUS_DIV_DIS.
**  IF R4 = 'X'.
**    SELECT   KUNNR SPART ENDDA   BEGDA  BZIRK   PERCNT  FROM  YSD_CUS_DIV_DIS INTO TABLE
**    IT_YSD_CUS_DIV_DIS WHERE KUNNR = WA_TAB1-KUNAG AND SPART = '50' AND ENDDA GE BDATE AND BEGDA LE BDATE .
**    SORT IT_YSD_CUS_DIV_DIS  BY PERCNT DESCENDING.
**    CNT = 0.
**    LOOP AT IT_YSD_CUS_DIV_DIS INTO WA_YSD_CUS_DIV_DIS .
**      SELECT  SINGLE   SPART BZIRK ENDDA   BEGDA  PLANS     FROM  YTERRALLC INTO
**      WA_YTERRALLC WHERE BZIRK = WA_YSD_CUS_DIV_DIS-BZIRK AND ENDDA GE BDATE AND BEGDA LE BDATE.
**      IF SY-SUBRC = 0.
**        CNT = CNT + 1.
**        IF CNT > 4.
**          EXIT.
**        ENDIF.
**        SELECT SINGLE PERNR FROM PA0001 INTO WA_PERNR WHERE PLANS = WA_YTERRALLC-PLANS AND ENDDA GE BDATE AND BEGDA LE BDATE.
**        WA_EMAIL-PERNR = WA_PERNR.
**        WA_EMAIL-BZIRK = WA_YSD_CUS_DIV_DIS-BZIRK .
**        SELECT SINGLE  USRID_LONG INTO  WA_E_MAIL FROM PA0105 WHERE PERNR = WA_PERNR.
**        WA_EMAIL-E_MAIL = WA_E_MAIL.
**        APPEND WA_EMAIL TO IT_EMAIL.
**      ENDIF.
**
**    ENDLOOP.
**
**
**    SELECT SINGLE  ZDSM  FROM ZDSMTER INTO  WA_ZRM WHERE BZIRK = WA_BZIRK  AND ZMONTH = MM AND ZYEAR = YYYY.
**
**    SELECT   SPART BZIRK ENDDA   BEGDA  PLANS     FROM  YTERRALLC INTO TABLE
**    IT_YTERRALLC WHERE BZIRK = WA_ZRM AND ENDDA GE BDATE AND BEGDA LE BDATE.
**
**    LOOP AT IT_YTERRALLC INTO WA_YTERRALLC.
**      SELECT SINGLE PERNR FROM PA0001 INTO WA_PERNR WHERE PLANS = WA_YTERRALLC-PLANS AND ENDDA GE BDATE AND BEGDA LE BDATE.
**      WA_EMAIL-PERNR = WA_PERNR.
**      WA_EMAIL-BZIRK = WA_ZRM.
**      SELECT SINGLE  USRID_LONG INTO  WA_E_MAIL FROM PA0105 WHERE PERNR = WA_PERNR.
**      WA_EMAIL-E_MAIL = WA_E_MAIL.
**      APPEND WA_EMAIL TO IT_EMAIL.
**
**    ENDLOOP.
**
**
**
**    SELECT SINGLE  ZDSM  FROM ZDSMTER INTO  WA_ZDSM WHERE BZIRK = WA_ZRM   AND ZMONTH = MM AND ZYEAR = YYYY.
**    SELECT   SPART BZIRK ENDDA   BEGDA  PLANS     FROM  YTERRALLC INTO TABLE
**    IT_YTERRALLC WHERE BZIRK = WA_ZDSM  AND ENDDA GE BDATE AND BEGDA LE BDATE.
**
**    LOOP AT IT_YTERRALLC INTO WA_YTERRALLC.
**      SELECT SINGLE PERNR FROM PA0001 INTO WA_PERNR WHERE PLANS = WA_YTERRALLC-PLANS AND ENDDA GE BDATE AND BEGDA LE BDATE.
**      WA_EMAIL-PERNR = WA_PERNR.
**      WA_EMAIL-BZIRK = WA_ZDSM.
**      SELECT SINGLE  USRID_LONG INTO  WA_E_MAIL FROM PA0105 WHERE PERNR = WA_PERNR.
**      WA_EMAIL-E_MAIL = WA_E_MAIL.
**      APPEND WA_EMAIL TO IT_EMAIL.
**
**    ENDLOOP.
**
**
***    IF WA_BZIRK1 IS  NOT INITIAL.
**    REFRESH  IT_YSD_CUS_DIV_DIS.
**    SELECT   KUNNR SPART ENDDA   BEGDA  BZIRK   PERCNT  FROM  YSD_CUS_DIV_DIS INTO TABLE
**  IT_YSD_CUS_DIV_DIS WHERE KUNNR = WA_TAB1-KUNAG AND SPART = '60' AND ENDDA GE BDATE AND BEGDA LE BDATE .
**    SORT IT_YSD_CUS_DIV_DIS  BY PERCNT DESCENDING.
**    CNT = 0.
**    LOOP AT IT_YSD_CUS_DIV_DIS INTO WA_YSD_CUS_DIV_DIS .
**      SELECT  SINGLE   SPART BZIRK ENDDA   BEGDA  PLANS     FROM  YTERRALLC INTO
**      WA_YTERRALLC WHERE BZIRK = WA_YSD_CUS_DIV_DIS-BZIRK AND ENDDA GE BDATE AND BEGDA LE BDATE.
**      IF SY-SUBRC = 0.
**        CNT = CNT + 1.
**        IF CNT > 4.
**          EXIT.
**        ENDIF.
**        SELECT SINGLE PERNR FROM PA0001 INTO WA_PERNR WHERE PLANS = WA_YTERRALLC-PLANS AND ENDDA GE BDATE AND BEGDA LE BDATE.
**        WA_EMAIL-PERNR = WA_PERNR.
**        WA_EMAIL-BZIRK = WA_YSD_CUS_DIV_DIS-BZIRK .
**        SELECT SINGLE  USRID_LONG INTO  WA_E_MAIL FROM PA0105 WHERE PERNR = WA_PERNR.
**        WA_EMAIL-E_MAIL = WA_E_MAIL.
**        APPEND WA_EMAIL TO IT_EMAIL.
**      ENDIF.
**
**    ENDLOOP.
**    SELECT SINGLE  ZDSM  FROM ZDSMTER INTO  WA_ZRM WHERE BZIRK = WA_BZIRK1  AND ZMONTH = MM AND ZYEAR = YYYY.
**
**    SELECT   SPART BZIRK ENDDA   BEGDA  PLANS     FROM  YTERRALLC INTO TABLE
**    IT_YTERRALLC WHERE BZIRK = WA_ZRM AND  ENDDA GE BDATE AND BEGDA LE BDATE.
**
**    LOOP AT IT_YTERRALLC INTO WA_YTERRALLC.
**      SELECT SINGLE PERNR FROM PA0001 INTO WA_PERNR WHERE PLANS = WA_YTERRALLC-PLANS AND ENDDA GE BDATE AND BEGDA LE BDATE.
**      WA_EMAIL-PERNR = WA_PERNR.
**      WA_EMAIL-BZIRK = WA_ZRM.
**      SELECT SINGLE  USRID_LONG INTO  WA_E_MAIL FROM PA0105 WHERE PERNR = WA_PERNR.
**      WA_EMAIL-E_MAIL = WA_E_MAIL.
**      APPEND WA_EMAIL TO IT_EMAIL.
**
**    ENDLOOP.
**
**
**
**    SELECT SINGLE  ZDSM  FROM ZDSMTER INTO  WA_ZDSM WHERE BZIRK = WA_ZRM   AND ZMONTH = MM AND ZYEAR = YYYY.
**    SELECT   SPART BZIRK ENDDA   BEGDA  PLANS     FROM  YTERRALLC INTO TABLE
**    IT_YTERRALLC WHERE BZIRK = WA_ZDSM AND  ENDDA GE BDATE AND BEGDA LE BDATE.
**
**    LOOP AT IT_YTERRALLC INTO WA_YTERRALLC.
**      SELECT SINGLE PERNR FROM PA0001 INTO WA_PERNR WHERE PLANS = WA_YTERRALLC-PLANS AND ENDDA GE BDATE AND BEGDA LE BDATE.
**      WA_EMAIL-PERNR = WA_PERNR.
**      WA_EMAIL-BZIRK = WA_ZDSM.
**      SELECT SINGLE  USRID_LONG INTO  WA_E_MAIL FROM PA0105 WHERE PERNR = WA_PERNR.
**      WA_EMAIL-E_MAIL = WA_E_MAIL.
**      APPEND WA_EMAIL TO IT_EMAIL.
**
**    ENDLOOP.
***    ENDIF.
**  ENDIF.
**
*
*
*  SORT IT_EMAIL BY PERNR E_MAIL.
*  DELETE ADJACENT DUPLICATES FROM IT_EMAIL COMPARING PERNR E_MAIL.
*  "loop at it_email into wa_email.
*  IF WA_EMAIL-E_MAIL NE '' .
*    DESCRIBE TABLE OBJBIN LINES RIGHE_ATTACHMENT.
*    OBJTXT = 'This eMail is meant for information only. Please DO NOT REPLY'.APPEND OBJTXT.
*    OBJTXT = '                                 '.APPEND OBJTXT.
*    OBJTXT = 'BLUE CROSS LABORATORIES LTD.'.APPEND OBJTXT.
*    DESCRIBE TABLE OBJTXT LINES RIGHE_TESTO.
*    DOC_CHNG-OBJ_NAME = 'URGENT'.
*    DOC_CHNG-EXPIRY_DAT = SY-DATUM + 10.
*    CONDENSE LTX.
*    CONDENSE OBJTXT.
*
**  WRITE S_begda-LOW TO wa_d1 DD/MM/YYYY.
**  WRITE S_begda-HIGH TO wa_d2 DD/MM/YYYY.
*
**      CONCATENATE 'SR9 for the period' ltx '-' INTO doc_chng-obj_descr SEPARATED BY space.
*    CONCATENATE 'Domestic Invoice '  IT_VBRK-VBELN  INTO DOC_CHNG-OBJ_DESCR SEPARATED BY SPACE.
*    DOC_CHNG-SENSITIVTY = 'F'.
*    DOC_CHNG-DOC_SIZE = RIGHE_TESTO * 255 .
*
*    CLEAR OBJPACK-TRANSF_BIN.
*
*    OBJPACK-HEAD_START = 1.
*    OBJPACK-HEAD_NUM = 0.
*    OBJPACK-BODY_START = 1.
*    OBJPACK-BODY_NUM = 4.
*    OBJPACK-DOC_TYPE = 'TXT'.
*    APPEND OBJPACK.
*
*    OBJPACK-TRANSF_BIN = 'X'.
*    OBJPACK-HEAD_START = 1.
*    OBJPACK-HEAD_NUM = 0.
*    OBJPACK-BODY_START = 1.
*    OBJPACK-BODY_NUM = RIGHE_ATTACHMENT.
*    OBJPACK-DOC_TYPE = 'PDF'.
*    OBJPACK-OBJ_NAME = 'TEST'.
*    CONDENSE LTX.
*    CONCATENATE 'Domestic Invoice '  IT_VBRK-VBELN  INTO OBJPACK-OBJ_DESCR SEPARATED BY SPACE.
**  concatenate 'SR-9 NET' '.' into objpack-obj_descr separated by space.
**  objpack-doc_size = righe_attachment * 255.
**    APPEND OBJPACK.
**    CLEAR OBJPACK.
***    CLEAR P_EMAIL1.
**    CLEAR V_ADRNR.
*
*
*
**    LOOP AT IT_EMAIL INTO WA_EMAIL.
**      RECLIST-RECEIVER =   WA_EMAIL-E_MAIL.
**      RECLIST-EXPRESS = 'X'.
**      RECLIST-REC_TYPE = 'U'.
**      RECLIST-NOTIF_DEL = 'X'. " request delivery notification
**      RECLIST-NOTIF_NDEL = 'X'. " request not delivered notification
**      APPEND RECLIST.
**      CLEAR RECLIST.
**    ENDLOOP.
*
*
*    DESCRIBE TABLE RECLIST LINES MCOUNT.
*    IF MCOUNT > 0.
*      DATA: SENDER LIKE SOEXTRECI1-RECEIVER.
****ADDED BY SATHISH.B
*      TYPES: BEGIN OF T_USR21,
*               BNAME      TYPE USR21-BNAME,
*               PERSNUMBER TYPE USR21-PERSNUMBER,
*               ADDRNUMBER TYPE USR21-ADDRNUMBER,
*             END OF T_USR21.
*
*      TYPES: BEGIN OF T_ADR6,
*               ADDRNUMBER TYPE USR21-ADDRNUMBER,
*               PERSNUMBER TYPE USR21-PERSNUMBER,
*               SMTP_ADDR  TYPE ADR6-SMTP_ADDR,
*             END OF T_ADR6.
*
*      DATA: IT_USR21 TYPE TABLE OF T_USR21,
*            WA_USR21 TYPE T_USR21,
*            IT_ADR6  TYPE TABLE OF T_ADR6,
*            WA_ADR6  TYPE T_ADR6.
*
*      SELECT  BNAME PERSNUMBER ADDRNUMBER FROM USR21 INTO TABLE IT_USR21
*          WHERE BNAME = SY-UNAME.
*      IF SY-SUBRC = 0.
*        SELECT ADDRNUMBER PERSNUMBER SMTP_ADDR FROM ADR6 INTO TABLE IT_ADR6
*          FOR ALL ENTRIES IN IT_USR21 WHERE ADDRNUMBER = IT_USR21-ADDRNUMBER
*                                      AND   PERSNUMBER = IT_USR21-PERSNUMBER.
*      ENDIF.
*      LOOP AT IT_USR21 INTO WA_USR21.
*        READ TABLE IT_ADR6 INTO WA_ADR6 WITH KEY ADDRNUMBER = WA_USR21-ADDRNUMBER.
*        IF SY-SUBRC = 0.
*          SENDER = WA_ADR6-SMTP_ADDR.
*        ENDIF.
*      ENDLOOP.
*
*      CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
*        EXPORTING
*          DOCUMENT_DATA              = DOC_CHNG
*          PUT_IN_OUTBOX              = 'X'
*          SENDER_ADDRESS             = SENDER
*          SENDER_ADDRESS_TYPE        = 'SMTP'
**         COMMIT_WORK                = ' '
**   IMPORTING
**         SENT_TO_ALL                =
**         NEW_OBJECT_ID              =
**         SENDER_ID                  =
*        TABLES
*          PACKING_LIST               = OBJPACK
**         OBJECT_HEADER              =
*          CONTENTS_BIN               = OBJBIN
*          CONTENTS_TXT               = OBJTXT
**         CONTENTS_HEX               =
**         OBJECT_PARA                =
**         OBJECT_PARB                =
*          RECEIVERS                  = RECLIST
*        EXCEPTIONS
*          TOO_MANY_RECEIVERS         = 1
*          DOCUMENT_NOT_SENT          = 2
*          DOCUMENT_TYPE_NOT_EXIST    = 3
*          OPERATION_NO_AUTHORIZATION = 4
*          PARAMETER_ERROR            = 5
*          X_ERROR                    = 6
*          ENQUEUE_ERROR              = 7
*          OTHERS                     = 8.
*      IF SY-SUBRC <> 0.
*        MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*      ENDIF.
*
*      COMMIT WORK.
*      IF SY-SUBRC EQ 0.
*        WRITE : / 'EMAIL SENT ON ',P_EMAIL1.
*      ENDIF.
*
*      CLEAR   : OBJPACK,
*                OBJHEAD,
*                OBJTXT,
*                OBJBIN,
*                RECLIST.
*
*      REFRESH : OBJPACK,
*                OBJHEAD,
*                OBJTXT,
*                OBJBIN,
*                RECLIST.
*
*    ENDIF.
*  ENDIF.
*  "ENDLOOP.
*
*
*
*
*
*ENDFORM.

*FORM MAIL_REQUIREMENT.
*
*  CALL FUNCTION 'CONVERT_OTF'
*    EXPORTING
*      FORMAT       = 'PDF'
*    IMPORTING
*      BIN_FILESIZE = L_BIN_FILESIZE
*    TABLES
*      OTF          = L_OTF_DATA
*      LINES        = L_ASC_DATA.
*
*  CALL FUNCTION 'SX_TABLE_LINE_WIDTH_CHANGE'
*    EXPORTING
*      LINE_WIDTH_DST = '255'
*    TABLES
*      CONTENT_IN     = L_ASC_DATA
*      CONTENT_OUT    = OBJBIN.
*
*
*
*
*  DESCRIBE TABLE OBJBIN LINES RIGHE_ATTACHMENT.
*  OBJTXT = 'This eMail is meant for information only. Please DO NOT REPLY'.APPEND OBJTXT.
*  OBJTXT = '                                 '.APPEND OBJTXT.
*  OBJTXT = 'BLUE CROSS LABORATORIES LTD.'.APPEND OBJTXT.
*  DESCRIBE TABLE OBJTXT LINES RIGHE_TESTO.
*  DOC_CHNG-OBJ_NAME = 'URGENT'.
*  DOC_CHNG-EXPIRY_DAT = SY-DATUM + 10.
*  CONDENSE LTX.
*  CONDENSE OBJTXT.
*
**  WRITE S_begda-LOW TO wa_d1 DD/MM/YYYY.
**  WRITE S_begda-HIGH TO wa_d2 DD/MM/YYYY.
*
**      CONCATENATE 'SR9 for the period' ltx '-' INTO doc_chng-obj_descr SEPARATED BY space.
*  CONCATENATE 'Domestic Invoice '  IT_VBRK-VBELN  INTO DOC_CHNG-OBJ_DESCR SEPARATED BY SPACE.
*  DOC_CHNG-SENSITIVTY = 'F'.
*  DOC_CHNG-DOC_SIZE = RIGHE_TESTO * 255 .
*
*  CLEAR OBJPACK-TRANSF_BIN.
*
*  OBJPACK-HEAD_START = 1.
*  OBJPACK-HEAD_NUM = 0.
*  OBJPACK-BODY_START = 1.
*  OBJPACK-BODY_NUM = 4.
*  OBJPACK-DOC_TYPE = 'TXT'.
*  APPEND OBJPACK.
*
*  OBJPACK-TRANSF_BIN = 'X'.
*  OBJPACK-HEAD_START = 1.
*  OBJPACK-HEAD_NUM = 0.
*  OBJPACK-BODY_START = 1.
*  OBJPACK-BODY_NUM = RIGHE_ATTACHMENT.
*  OBJPACK-DOC_TYPE = 'PDF'.
*  OBJPACK-OBJ_NAME = 'TEST'.
*  CONDENSE LTX.
*  CONCATENATE 'Domestic Invoice '  IT_VBRK-VBELN  INTO OBJPACK-OBJ_DESCR SEPARATED BY SPACE.
**  concatenate 'SR-9 NET' '.' into objpack-obj_descr separated by space.
**  objpack-doc_size = righe_attachment * 255.
*  APPEND OBJPACK.
*  CLEAR OBJPACK.
*
*  RECLIST-RECEIVER =   P_EMAIL1.
*  RECLIST-EXPRESS = 'X'.
*  RECLIST-REC_TYPE = 'U'.
*  RECLIST-NOTIF_DEL = 'X'. " request delivery notification
*  RECLIST-NOTIF_NDEL = 'X'. " request not delivered notification
*  APPEND RECLIST.
*  CLEAR RECLIST.
*
*  DESCRIBE TABLE RECLIST LINES MCOUNT.
*  IF MCOUNT > 0.
*    DATA: SENDER LIKE SOEXTRECI1-RECEIVER.
****ADDED BY SATHISH.B
*    TYPES: BEGIN OF T_USR21,
*             BNAME      TYPE USR21-BNAME,
*             PERSNUMBER TYPE USR21-PERSNUMBER,
*             ADDRNUMBER TYPE USR21-ADDRNUMBER,
*           END OF T_USR21.
*
*    TYPES: BEGIN OF T_ADR6,
*             ADDRNUMBER TYPE USR21-ADDRNUMBER,
*             PERSNUMBER TYPE USR21-PERSNUMBER,
*             SMTP_ADDR  TYPE ADR6-SMTP_ADDR,
*           END OF T_ADR6.
*
*    DATA: IT_USR21 TYPE TABLE OF T_USR21,
*          WA_USR21 TYPE T_USR21,
*          IT_ADR6  TYPE TABLE OF T_ADR6,
*          WA_ADR6  TYPE T_ADR6.
*
*    SELECT  BNAME PERSNUMBER ADDRNUMBER FROM USR21 INTO TABLE IT_USR21
*        WHERE BNAME = SY-UNAME.
*    IF SY-SUBRC = 0.
*      SELECT ADDRNUMBER PERSNUMBER SMTP_ADDR FROM ADR6 INTO TABLE IT_ADR6
*        FOR ALL ENTRIES IN IT_USR21 WHERE ADDRNUMBER = IT_USR21-ADDRNUMBER
*                                    AND   PERSNUMBER = IT_USR21-PERSNUMBER.
*    ENDIF.
*    LOOP AT IT_USR21 INTO WA_USR21.
*      READ TABLE IT_ADR6 INTO WA_ADR6 WITH KEY ADDRNUMBER = WA_USR21-ADDRNUMBER.
*      IF SY-SUBRC = 0.
*        SENDER = WA_ADR6-SMTP_ADDR.
*      ENDIF.
*    ENDLOOP.
*
*    CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
*      EXPORTING
*        DOCUMENT_DATA              = DOC_CHNG
*        PUT_IN_OUTBOX              = 'X'
*        SENDER_ADDRESS             = SENDER
*        SENDER_ADDRESS_TYPE        = 'SMTP'
**       COMMIT_WORK                = ' '
**   IMPORTING
**       SENT_TO_ALL                =
**       NEW_OBJECT_ID              =
**       SENDER_ID                  =
*      TABLES
*        PACKING_LIST               = OBJPACK
**       OBJECT_HEADER              =
*        CONTENTS_BIN               = OBJBIN
*        CONTENTS_TXT               = OBJTXT
**       CONTENTS_HEX               =
**       OBJECT_PARA                =
**       OBJECT_PARB                =
*        RECEIVERS                  = RECLIST
*      EXCEPTIONS
*        TOO_MANY_RECEIVERS         = 1
*        DOCUMENT_NOT_SENT          = 2
*        DOCUMENT_TYPE_NOT_EXIST    = 3
*        OPERATION_NO_AUTHORIZATION = 4
*        PARAMETER_ERROR            = 5
*        X_ERROR                    = 6
*        ENQUEUE_ERROR              = 7
*        OTHERS                     = 8.
*    IF SY-SUBRC <> 0.
*      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.
*
*    COMMIT WORK.
*    IF SY-SUBRC EQ 0.
*      WRITE : / 'EMAIL SENT ON ',P_EMAIL1.
*    ENDIF.
*
*    CLEAR   : OBJPACK,
*              OBJHEAD,
*              OBJTXT,
*              OBJBIN,
*              RECLIST.
*
*    REFRESH : OBJPACK,
*              OBJHEAD,
*              OBJTXT,
*              OBJBIN,
*              RECLIST.
*
*  ENDIF.
*
*
*
*
*
*
*
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FORM1 .
  CLEAR : IT_TAB1,WA_TAB1,IT_TAB2,WA_TAB2.

  CLEAR : FORMAT, PNAME1, PNAME2, PNAME3,PNAME4 , PHONE, DRUG, E_TINNO, E_STATE, PCITY1, A_KUNNR, BILLNO, BDATE1, BTIME, INVTYP1 , INVTYP2,
       W_ZFBDT1, CNAME1, CNAME2, CNAME3, CNAME4 , C_STATE,CCITY , V_BSTNK, V_BSTDK, EXTENSION1, TINNO, PANNO , V_BAHNS, V_BAHNE ,
       V_NAME1, CCITY1, V_BOLNR, V_ZFBDT, NOCASE, EWAYBILL, EWAYDATE , EWAY1  , EWAY2,TVAL,TDIS, TZDIT,TTAXABLE , TOTJOIG ,TOTJOCG,
       TOTJOSG ,TOTTAXABLE, TAMT,ADV, CN ,RVAL1 ,NETAMT,SPARTVAL , CREDIT , ADJ , CREDITBAL , DISCNT , W_ZFBDT  .


  LOOP AT IT_VBRK INTO WA_VBRK WHERE VBELN EQ WA_CHECK-VBELN.
    WA_INV1-VBELN = WA_VBRK-VBELN.
    COLLECT WA_INV1 INTO IT_INV1.
    CLEAR WA_INV1.

*    WA_CUS1-KUNAG = WA_VBRK-KUNAG.
*    COLLECT WA_CUS1 INTO IT_CUS1.
*    CLEAR WA_CUS1.
  ENDLOOP.
  SORT IT_INV1 BY  VBELN.
  DELETE ADJACENT DUPLICATES FROM IT_INV1.
  SRL = 0.
  CNT = 1.
  CLEAR : TCS.
  CLEAR : NLEMTXT1, NLEMTXT2, NLEMTXT3, NLEMTXT.
  LOOP AT IT_VBRP INTO WA_VBRP WHERE VBELN EQ WA_CHECK-VBELN .
    ON CHANGE OF WA_VBRP-VBELN.
      CNT = 1.
    ENDON.
    CLEAR : MRP,PTS,PTR,VAL,DISPER,JOIG_AMT,JOIG_RT,JOSG_AMT,JOSG_RT,JOCG_AMT,JOCG_RT,JOUG_AMT,JOUG_RT,TEXT1,TEXT2,HSDAT,VFDAT,FKIMG,DISCNT1.
    CLEAR : JOIG_RT1,JOSG_RT1,JOCG_RT1,JOUG_RT1,TCS.
    READ TABLE IT_VBRK INTO WA_VBRK WITH KEY VBELN = WA_VBRP-VBELN.
    IF SY-SUBRC EQ 0.
*      srl = srl + 1.
      WA_TAB1-VBELN = WA_VBRP-VBELN.
      WA_TAB1-MATNR = WA_VBRP-MATNR.
*      WA_TAB1-ARKTX = WA_VBRP-ARKTX.
      IF WA_VBRP-VBELN EQ '0116563245'.  "ADDED ON 18.1.23
        SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_VBRP-MATNR AND SPRAS EQ 'EN'.
        IF SY-SUBRC EQ 0.
          WA_TAB1-ARKTX = MAKT-MAKTX.
        ENDIF.
      ELSE.
        WA_TAB1-ARKTX = WA_VBRP-ARKTX.
      ENDIF.

*      IF WA_VBRK-FKDAT GE '20221221'. "nlem condition on 21.12.22   "Commented by Varsha 18-11-2025
      IF WA_VBRK-FKDAT GE '20250922'. "nlem condition on 21.12.22
        SELECT SINGLE * FROM ZNLEM WHERE MATNR EQ WA_VBRP-MATNR.
        IF SY-SUBRC EQ 0.
          CONCATENATE WA_TAB1-ARKTX '##' INTO WA_TAB1-ARKTX SEPARATED BY SPACE.
****************new text added on 10.9.25 as per Raghav - Jyotsna
          NLEMTXT1 = '##IMP NOTE: Due to reduction in GST Rate, the effective MRP payable by the consumer is'.
          NLEMTXT2 = 'lower than the MRP printed on the pack. Accordingly, you should bill your Retailers at'.
          NLEMTXT3 = 'lower GST Rate so that the benefit of lower MRP is duly passed on to Consumers.'.
          CONCATENATE NLEMTXT1 NLEMTXT2 NLEMTXT3 INTO NLEMTXT SEPARATED BY SPACE.
*          NLEMTXT1 = '## IMP NOTE: MRP of this product has been reduced and has to be given effect immediately.'. "Commented by Varsha 18-11-2025
*          NLEMTXT2 = 'Accordingly, we are billing you at lower PTS. You should also bill your Retailers'.
*          NLEMTXT3 = 'at lower PTR so that they should sell to Consumers at lower MRP as mentioned above.'.

        ENDIF.
      ENDIF.
      WA_TAB1-CHARG = WA_VBRP-CHARG.
      WA_TAB1-FKIMG = WA_VBRP-FKIMG.
      SELECT SINGLE * FROM MVKE WHERE MATNR EQ WA_VBRP-MATNR AND VKORG EQ '1000' AND VTWEG EQ '10'.

      IF SY-SUBRC EQ 0.
        SELECT SINGLE * FROM TVM5T WHERE SPRAS EQ 'EN' AND MVGR5 EQ MVKE-MVGR5.
        IF SY-SUBRC EQ 0.
          WA_TAB1-BEZEI = TVM5T-BEZEI.
        ENDIF.
      ENDIF.
      SELECT SINGLE * FROM MARC WHERE MATNR EQ WA_VBRP-MATNR AND WERKS EQ WA_VBRP-WERKS.
      IF SY-SUBRC EQ 0.
        WA_TAB1-STEUC = MARC-STEUC.
      ENDIF.
******************Added by VARSHA 19-9-2025*********
      SELECT SINGLE * FROM IBATCH WHERE MATERIAL EQ WA_VBRP-MATNR AND PLANT EQ WA_VBRP-WERKS AND BATCH EQ WA_VBRP-CHARG.
      IF SY-SUBRC EQ 0.
        CONCATENATE IBATCH-SHELFLIFEEXPIRATIONDATE+4(2) '/' IBATCH-SHELFLIFEEXPIRATIONDATE+2(2) INTO VFDAT.
        WA_TAB1-VFDAT = VFDAT.
      ENDIF.
***********************************
      SELECT SINGLE * FROM MCH1 WHERE MATNR EQ WA_VBRP-MATNR  AND CHARG EQ WA_VBRP-CHARG.  "AND WERKS EQ WA_VBRP-WERKS
      IF SY-SUBRC EQ 0.
        CONCATENATE MCH1-HSDAT+4(2) '/' MCH1-HSDAT+0(4) INTO HSDAT.
        WA_TAB1-HSDAT = HSDAT.
*        CONCATENATE MCHA-VFDAT+4(2) '/' MCHA-VFDAT+2(2) INTO VFDAT.    " Commented By Varsha 19-09-2025
*        WA_TAB1-VFDAT = VFDAT.
      ENDIF.

      READ TABLE IT_KONV INTO WA_KONV WITH KEY KNUMV = WA_VBRK-KNUMV KPOSN = WA_VBRP-POSNR KSCHL = 'Z001'.
      IF SY-SUBRC EQ 0.
        MRP = WA_KONV-KBETR.
        WA_TAB1-MRP = MRP.
      ENDIF.

*    PTS = ( ( 6429 / 100 ) * ( MRP / 100 ) ).
*    PTR = ( ( 7143 / 100 ) * ( MRP / 100 ) ).
*    WA_TAB1-PTS = PTS.
*    WA_TAB1-PTR = PTR.
*    VAL = PTS * WA_VBRP-FKIMG.
*
********** PTR, PTS*************
      READ TABLE IT_KONV INTO WA_KONV WITH KEY KNUMV = WA_VBRK-KNUMV KPOSN = WA_VBRP-POSNR KSCHL = 'ZGRP'.
      IF SY-SUBRC = 0.
        WA_TAB1-NET = WA_KONV-KWERT.
      ENDIF.
      READ TABLE IT_KONV INTO WA_KONV WITH KEY KNUMV = WA_VBRK-KNUMV KPOSN = WA_VBRP-POSNR KSCHL = 'Z015'.
      IF SY-SUBRC = 0.
        PTR = WA_KONV-KAWRT / WA_VBRP-FKIMG.
        WA_TAB1-PTR = PTR.
      ENDIF.
      READ TABLE IT_KONV INTO WA_KONV WITH KEY KNUMV = WA_VBRK-KNUMV KPOSN = WA_VBRP-POSNR KSCHL = 'ZFRG'.
      IF SY-SUBRC = 0.
        PTS = WA_KONV-KAWRT / WA_VBRP-FKIMG.
        WA_TAB1-PTS = PTS.
      ELSE.
        READ TABLE IT_KONV INTO WA_KONV WITH KEY KNUMV = WA_VBRK-KNUMV KPOSN = WA_VBRP-POSNR KSCHL = 'ZGRP'.
        IF SY-SUBRC = 0.
          PTS = WA_KONV-KAWRT / WA_VBRP-FKIMG.
          WA_TAB1-PTS = PTS.
        ENDIF.
      ENDIF.
      READ TABLE IT_KONV INTO WA_KONV WITH KEY KNUMV = WA_VBRK-KNUMV KPOSN = WA_VBRP-POSNR KSCHL = 'ZDIT'.
      IF SY-SUBRC = 0.
        WA_TAB1-ZDIT = WA_KONV-KWERT * ( - 1 ). "
*        WA_TAB1-DISCNT = WA_KONV-KAWRT / 100.
      ENDIF.
      READ TABLE IT_KONV INTO WA_KONV WITH KEY KNUMV = WA_VBRK-KNUMV KPOSN = WA_VBRP-POSNR KSCHL = 'ZSPD'.
      IF SY-SUBRC = 0.
        WA_TAB1-ZSPD = WA_KONV-KWERT * ( - 1 ).  "*
      ENDIF.
      WA_TAB1-ODIS = WA_TAB1-ZDIT + WA_TAB1-ZSPD.

      LOOP AT IT_KONV INTO WA_KONV WHERE KNUMV = WA_VBRK-KNUMV AND KSCHL = 'ZTC3'.
        TCS = TCS + WA_KONV-KWERT.
      ENDLOOP.
      IF TCS NE 0.
        TCSTXT = 'TCS - IT COLLECTED'.
      ENDIF.
      IF TCS EQ 0.
        LOOP AT IT_KONV INTO WA_KONV WHERE KNUMV = WA_VBRK-KNUMV AND KSCHL = 'ZTDS'.  "30.6.21
          TCS = TCS + WA_KONV-KWERT.
        ENDLOOP.
        IF TCS NE 0.
          TCSTXT = 'TDS amount to be deducted by you @0.1%'.
        ENDIF.
      ENDIF.
      IF TCS EQ 0.
        TCSTXT = SPACE.
      ENDIF.





********************************
      READ TABLE IT_KONV INTO WA_KONV WITH KEY KNUMV = WA_VBRK-KNUMV KPOSN = WA_VBRP-POSNR KSCHL = 'ZFRG'.
      IF SY-SUBRC EQ 0.
        WA_TAB1-DIS = WA_KONV-KWERT * ( - 1 ).
        DISPER = ( WA_KONV-KBETR ) * ( - 1 ).    "/ 10
        WA_TAB1-DISPER = DISPER.
      ENDIF.
      IF WA_TAB1-DISPER EQ SPACE.
        WA_TAB1-DISPER = '0.00'.
      ENDIF.
************* TAXES ***************************
      READ TABLE IT_KONV INTO WA_KONV WITH KEY KNUMV = WA_VBRK-KNUMV  KPOSN = WA_VBRP-POSNR KSCHL = 'JOIG'.
      IF SY-SUBRC EQ 0.
        JOIG_AMT = WA_KONV-KWERT.
        JOIG_RT = WA_KONV-KBETR / 10 .
      ENDIF.
      READ TABLE IT_KONV INTO WA_KONV WITH KEY KNUMV = WA_VBRK-KNUMV KPOSN = WA_VBRP-POSNR KSCHL = 'JOCG'.
      IF SY-SUBRC EQ 0.
        JOCG_AMT = WA_KONV-KWERT.
        JOCG_RT = WA_KONV-KBETR / 10.
      ENDIF.
      READ TABLE IT_KONV INTO WA_KONV WITH KEY KNUMV = WA_VBRK-KNUMV KPOSN = WA_VBRP-POSNR KSCHL = 'JOSG'.
      IF SY-SUBRC EQ 0.
        JOSG_AMT = WA_KONV-KWERT.
        JOSG_RT = WA_KONV-KBETR / 10.
      ENDIF.
      READ TABLE IT_KONV INTO WA_KONV WITH KEY KNUMV = WA_VBRK-KNUMV KPOSN = WA_VBRP-POSNR KSCHL = 'JOUG'.
      IF SY-SUBRC EQ 0.
        JOUG_AMT = WA_KONV-KWERT.
        JOUG_RT = WA_KONV-KBETR / 10.
      ENDIF.


      WA_TAB1-JOIG_AMT = JOIG_AMT.
      WA_TAB1-JOIG_RT = JOIG_RT.
      WA_TAB1-JOCG_AMT = JOCG_AMT.
      WA_TAB1-JOCG_RT = JOCG_RT.
      IF JOSG_AMT NE 0.
        WA_TAB1-JOSG_AMT = JOSG_AMT.
        WA_TAB1-JOSG_RT = JOSG_RT.
      ELSE.
        WA_TAB1-JOSG_AMT = JOUG_AMT.
        WA_TAB1-JOSG_RT = JOUG_RT.
      ENDIF.

*check fraction******

*      joig_rt1 = joig_rt.
*      jocg_rt1 = jocg_rt.
*      josg_rt1 = josg_rt.
*      joug_rt1 = joug_rt.
**      CONDENSE : joig_rt1,josg_rt1,josg_rt1,joug_rt1.
*      wa_tab1-joig_rt1 = joig_rt1.
*      wa_tab1-jocg_rt1 = jocg_rt1.
*      if josg_amt ne 0.
*        wa_tab1-josg_rt1 = josg_rt1.
*      else.
*        wa_tab1-josg_rt1 = joug_rt1.
*      endif.

      CLEAR : V1,V2.
      V1 = FRAC( JOIG_RT ).
      V2 = FRAC( JOCG_RT ).

      IF V1 GT 0.
        JOIG_RT2 = JOIG_RT.
        WA_TAB1-JOIG_RT1 = JOIG_RT2.
      ELSE.
        JOIG_RT1 = JOIG_RT.
        WA_TAB1-JOIG_RT1 = JOIG_RT1.
      ENDIF.
      IF V2 GT 0.
        JOCG_RT2 = JOCG_RT.
        JOSG_RT2 = JOSG_RT.
        JOUG_RT2 = JOUG_RT.
*      CONDENSE : joig_rt1,josg_rt1,josg_rt1,joug_rt1.
        WA_TAB1-JOIG_RT1 = JOIG_RT2.
        WA_TAB1-JOCG_RT1 = JOCG_RT2.
        IF JOSG_AMT NE 0.
          WA_TAB1-JOSG_RT1 = JOSG_RT2.
        ELSE.
          WA_TAB1-JOSG_RT1 = JOUG_RT2.
        ENDIF.
      ELSE.
        JOIG_RT1 = JOIG_RT.
        JOCG_RT1 = JOCG_RT.
        JOSG_RT1 = JOSG_RT.
        JOUG_RT1 = JOUG_RT.
*      CONDENSE : joig_rt1,josg_rt1,josg_rt1,joug_rt1.
        WA_TAB1-JOIG_RT1 = JOIG_RT1 * 10.
        WA_TAB1-JOCG_RT1 = JOCG_RT1.
        IF JOSG_AMT NE 0.
          WA_TAB1-JOSG_RT1 = JOSG_RT1.
        ELSE.
          WA_TAB1-JOSG_RT1 = JOUG_RT1.
        ENDIF.
      ENDIF.

*    WRITE : 'GST',JOIG_RT,JOCG_RT,JOSG_RT,JOUG_RT.



******* location********
      CLEAR : TEXT1.
 DATA: LV_PLANT TYPE IBATCH-PLANT.
  SELECT PLANT  INTO LV_PLANT FROM IBATCH  WHERE BATCH = WA_VBRP-CHARG .

  IF LV_PLANT IS NOT INITIAL.
      IF LV_PLANT = '1000'.
        TEXT1 = 'BCL-NSK'.
      ELSEIF LV_PLANT = '1001'.
        TEXT1 = 'BCL-GOA'.
   ENDIF.
endif.
ENDSELECT.
     IF TEXT1 IS INITIAL.
        DATA(LV_LENGTH) = STRLEN( wa_vbrp-matnr ).
        DATA(LV_SP)   = 40  .
        DATA(LV_SPACES) = REPEAT( VAL = SPACE OCC = LV_SP ).

        DATA(LV_NAME) = |{ wa_vbrp-matnr  WIDTH = LV_SP ALIGN = LEFT }|." { wa_vbrp-vkorg_ana } | ." {wa_vbrp-vtweg_ana }|.
        LV_LENGTH  = STRLEN( LV_NAME ).

        CONCATENATE LV_NAME '100010' INTO SIMPLE1.

*    select single * from stxh where tdname eq simple1 and tdid = '0001' and tdobject ='VBBP'.
*        select single * from stxh where tdname eq simple1 and tdid = '0001' and tdobject ='MVKE'.
*         SIMPLE1 = '000000000000012012100010'.
*      IF SY-SUBRC IS INITIAL.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = '0001'
            LANGUAGE                = 'E'
            NAME                    = SIMPLE1
*           object                  = 'VBBP'
            OBJECT                  = 'MVKE'
          TABLES
            LINES                   = ITLINE1
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.

*      ELSE.
*        CLEAR : ITLINE1.
*        "CONCATENATE WA_VBRP-MATNR  '100010' INTO SIMPLE1.
*        DATA(LV_LENGTH) = STRLEN( wa_vbrp-matnr ).
*        DATA(LV_SP)   = 40  .
*        DATA(LV_SPACES) = REPEAT( VAL = SPACE OCC = LV_SP ).
*
*        DATA(LV_NAME) = |{ wa_vbrp-matnr  WIDTH = LV_SP ALIGN = LEFT }|." { wa_vbrp-vkorg_ana } | ." {wa_vbrp-vtweg_ana }|.
*        LV_LENGTH  = STRLEN( LV_NAME ).
*
*        CONCATENATE LV_NAME '100010' INTO SIMPLE1.
*
**    select single * from stxh where tdname eq simple1 and tdid = '0001' and tdobject ='VBBP'.
**        select single * from stxh where tdname eq simple1 and tdid = '0001' and tdobject ='MVKE'.
**         SIMPLE1 = '000000000000012012100010'.
**      IF SY-SUBRC IS INITIAL.
*        CALL FUNCTION 'READ_TEXT'
*          EXPORTING
*            CLIENT                  = SY-MANDT
*            ID                      = '0001'
*            LANGUAGE                = 'E'
*            NAME                    = SIMPLE1
**           object                  = 'VBBP'
*            OBJECT                  = 'MVKE'
*          TABLES
*            LINES                   = ITLINE1
*          EXCEPTIONS
*            ID                      = 1
*            LANGUAGE                = 2
*            NAME                    = 3
*            NOT_FOUND               = 4
*            OBJECT                  = 5
*            REFERENCE_CHECK         = 6
*            WRONG_ACCESS_TO_ARCHIVE = 7
*            OTHERS                  = 8.
*
*        IF SY-SUBRC <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*        ENDIF.


        READ TABLE ITLINE1 INDEX 1.
        MOVE ITLINE1-TDLINE TO MATTEXT." NO. OF. CASES
*      replace all OCCURRENCES OF '<(>&<)>' in itab_vbrp1-mattext with 'and'.
        TEXT1 = MATTEXT.
        CLEAR : ITLINE1,ITLINE1[],MATTEXT.
        ENDIF.

      WA_TAB1-TEXT1 = TEXT1.

      IF WA_VBRP-KONDM = '02'.
        TEXT2 = ' '.
      ELSE.
        TEXT2 = 'NLEM'.
      ENDIF.
      WA_TAB1-TEXT2 = TEXT2.

      WA_TAB1-VAL = WA_TAB1-NET + WA_TAB1-DIS.
      WA_TAB1-TNET = WA_TAB1-NET + WA_TAB1-JOIG_AMT + WA_TAB1-JOSG_AMT + WA_TAB1-JOCG_AMT.
*      wa_tab1-taxable = wa_tab1-net - wa_tab1-zdit.
      WA_TAB1-TAXABLE = WA_TAB1-NET - WA_TAB1-ODIS.
      WA_TAB1-TTAXABLE = WA_TAB1-TAXABLE + WA_TAB1-JOIG_AMT + WA_TAB1-JOSG_AMT + WA_TAB1-JOCG_AMT.
************** CASES**********

****************************
      WA_TAB1-KUNAG = WA_VBRK-KUNAG.
      WA_TAB1-WERKS = WA_VBRP-WERKS.
      WA_TAB1-AUBEL = WA_VBRP-AUBEL.
      WA_TAB1-FKDAT = WA_VBRK-FKDAT.
      WA_TAB1-ERZET = WA_VBRK-ERZET.
      WA_TAB1-VGBEL = WA_VBRP-VGBEL.
*********TOTAL*************
      WA_TAB1-SRL = CNT.
      CNT = CNT + 1.

      COLLECT WA_TAB1 INTO IT_TAB1.
      CLEAR WA_TAB1.
    ENDIF.
  ENDLOOP.

*LOOP AT IT_TAB1 INTO WA_TAB1.
*  CLEAR : NET.
*
*  WRITE : /'1',WA_TAB1-STEUC,WA_TAB1-CHARG,WA_TAB1-MATNR,WA_TAB1-ARKTX,WA_TAB1-BEZEI,WA_TAB1-TEXT1,WA_TAB1-TEXT2,WA_TAB1-VFDAT,WA_TAB1-MRP,
*  WA_TAB1-PTR,WA_TAB1-FKIMG,WA_TAB1-PTS,WA_TAB1-VAL,WA_TAB1-DISPER,WA_TAB1-DIS,NET,
*  WA_TAB1-JOIG_RT,WA_TAB1-JOCG_RT,WA_TAB1-JOSG_RT.
*ENDLOOP.
*  IF R3 = 'X'.
*    CALL FUNCTION 'OPEN_FORM'
*      EXPORTING
**       APPLICATION                 = 'TX'
**       ARCHIVE_INDEX               =
**       ARCHIVE_PARAMS              =
*        DEVICE                      = 'PRINTER'
*        DIALOG                      = 'X'
**       FORM                        = 'Z_TRF_INVOICE_1 '
*        LANGUAGE                    = SY-LANGU
**       OPTIONS                     =
**       MAIL_SENDER                 =
**       MAIL_RECIPIENT              =
**       MAIL_APPL_OBJECT            =
**       RAW_DATA_INTERFACE          = '*'
**       SPONUMIV                    =
** IMPORTING
**       LANGUAGE                    =
**       NEW_ARCHIVE_PARAMS          =
**       RESULT                      =
*      EXCEPTIONS
*        CANCELED                    = 1
*        DEVICE                      = 2
*        FORM                        = 3
*        OPTIONS                     = 4
*        UNCLOSED                    = 5
*        MAIL_OPTIONS                = 6
*        ARCHIVE_ERROR               = 7
*        INVALID_FAX_NUMBER          = 8
*        MORE_PARAMS_NEEDED_IN_BATCH = 9
*        SPOOL_ERROR                 = 10
*        CODEPAGE                    = 11
*        OTHERS                      = 12.
*    IF SY-SUBRC <> 0.
*      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.
*  ENDIF.
  SORT IT_TAB1 BY VBELN ARKTX CHARG .
*  sort it_tab1 by srl.
  SORT IT_VBRK BY FKDAT VBELN .
  LOOP AT IT_VBRK INTO WA_VBRK WHERE VBELN EQ WA_CHECK-VBELN.
    CLEAR : DISCNT1.
*    PERFORM ADV.
    PERFORM CN.
    PERFORM ADV1.

    CLEAR : TVAL,TDIS,TNET,IGST,SGST,CGST,TAMT,TODIS,TTNET,DISCNT2,DISCNT,XL,LS,LS1,BC,BC1,XL1,LS1,EWAYBILL,EWAYDATE,TOTNET,TOTJOSG,TOTJOCG,TOTJOIG,TOTDIS,
    TTAXABLE,TZDIT,TOTTAXABLE.
    REFRESH ITLINE.
    CLEAR : ITLINE.
    W_CS1 = 1.
    COUNT = 1.
    REFRESH MMLINE1.
    CLEAR : MMLINE1.
    CNT1 = 1.

    LOOP AT IT_TAB1 INTO WA_TAB1 WHERE VBELN EQ WA_VBRK-VBELN.

      TVAL = TVAL + WA_TAB1-VAL.
      TDIS = TDIS + WA_TAB1-DIS.
      TNET = TNET + WA_TAB1-NET.
*      tzdit = tzdit + wa_tab1-zdit.
      TZDIT = TZDIT + WA_TAB1-ODIS.
      TTAXABLE = TTAXABLE + WA_TAB1-TAXABLE.
      TOTTAXABLE = TOTTAXABLE + WA_TAB1-TTAXABLE.
      IGST = IGST + WA_TAB1-JOIG_AMT.
      SGST = SGST + WA_TAB1-JOSG_AMT.
      CGST = CGST + WA_TAB1-JOCG_AMT.
      TOTNET = TOTNET + ( WA_TAB1-NET + WA_TAB1-JOIG_AMT + WA_TAB1-JOSG_AMT + WA_TAB1-JOCG_AMT ).
      TOTJOIG = TOTJOIG + WA_TAB1-JOIG_AMT.
      TOTJOCG = TOTJOCG + WA_TAB1-JOCG_AMT.
      TOTJOSG = TOTJOSG + WA_TAB1-JOSG_AMT.
      TOTDIS = TOTDIS + WA_TAB1-DIS.

      TODIS = TODIS + WA_TAB1-ODIS.
      TTNET = TNET - TODIS.
      TAMT = TTNET + IGST + SGST + CGST + TCS.
      SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_TAB1-MATNR.
      IF SY-SUBRC EQ 0.
        IF MARA-SPART EQ '50'.
          BC = BC + WA_TAB1-NET .
*        - WA_TAB1-ODIS ) + WA_TAB1-JOIG_AMT + WA_TAB1-JOSG_AMT + WA_TAB1-JOCG_AMT ).
        ELSEIF MARA-SPART EQ '60'.
          XL = XL + WA_TAB1-NET .
        ELSEIF MARA-SPART EQ '70'.
          LS = LS + WA_TAB1-NET .
*        - WA_TAB1-ODIS ) + WA_TAB1-JOIG_AMT + WA_TAB1-JOSG_AMT + WA_TAB1-JOCG_AMT ).
        ENDIF.
      ENDIF.
      BC1 = BC.
      XL1 = XL.
      LS1 = LS.
      CONDENSE : BC1, XL1,LS1.
      IF BC NE 0.
        CONCATENATE 'BLUE CROSS' BC1  INTO BCVAL SEPARATED BY SPACE.
      ENDIF.
      IF XL NE 0.
        CONCATENATE 'EXCEL' XL1  INTO XLVAL SEPARATED BY SPACE.
      ENDIF.
      IF LS NE 0.
        CONCATENATE 'BCLS' LS1  INTO LSVAL SEPARATED BY SPACE.
      ENDIF.

      CONCATENATE BCVAL XLVAL LSVAL INTO SPARTVAL SEPARATED BY SPACE.
************************************
*      IF WA_TAB1-DISCNT GT 0.
*      ON CHANGE OF WA_TAB1-VBELN.
*        READ TABLE IT_KONV INTO WA_KONV WITH KEY KNUMV = WA_VBRK-KNUMV KSCHL = 'ZDIT'.
*        IF SY-SUBRC = 0.
*          WA_TAB1-ZDIT = WA_KONV-KWERT * ( - 1 ).
*          WA_TAB1-DISCNT = WA_KONV-KAWRT / 100.
*        ENDIF.
*        DISCNT1 = DISCNT1 + WA_TAB1-DISCNT.
      DISCNT2 = DISCNT1.
      SELECT SINGLE * FROM T685T WHERE SPRAS EQ 'EN' AND KSCHL EQ 'ZDIT'.
      IF SY-SUBRC EQ 0.
        CONCATENATE T685T-VTEXT '-' DISCNT2 INTO DISCNT.
      ENDIF.
*      ENDON.
*******************CASES****************8
      CLEAR W_CASE.
      SELECT SINGLE * FROM MARM WHERE MATNR = WA_TAB1-MATNR AND MEINH = 'SPR'.

*      matnr meinh umrez umren from marm into table itab_marm for all  entries in itab_vbrp1 where matnr = itab_vbrp1-matnr and meinh = 'SPR'.
*        read table itab_marm with key matnr = itab_vbrp1-matnr.
      IF SY-SUBRC = 0.
*      IF WA_TAB1-FKIMG GT MARM-UMREN.
        W_QUN = WA_TAB1-FKIMG.
        W_QUN = W_QUN * MARM-UMREN.
        W_CS2 = W_QUN MOD MARM-UMREZ.
        IF W_CS2 = 0.
          W_CS2 = W_QUN / MARM-UMREZ.
          W_CS2 = W_CS2 - 1.
          W_CS2 = W_CS1 + W_CS2.
          W_CASE1 = W_CS1.
          W_CASE2 = W_CS2.
          SHIFT W_CASE1 LEFT DELETING LEADING '0'.
          SHIFT W_CASE2 LEFT DELETING LEADING '0'.
          CONDENSE: W_CASE1, W_CASE2.
          CONCATENATE W_CASE1 '-' W_CASE2 INTO W_CASE.
          WA_TAS1-VBELN = WA_TAB1-VBELN.
          WA_TAS1-MATNR = WA_TAB1-MATNR.
          WA_TAS1-CHARG = WA_TAB1-CHARG.
          WA_TAS1-SRL = WA_TAB1-SRL.
          WA_TAS1-W_CASE = W_CASE.
          COLLECT WA_TAS1 INTO IT_TAS1.
          CLEAR WA_TAS1.
          W_CS1 = W_CS2 + 1.
        ENDIF.
*      ENDIF.
      ENDIF.
      SHIFT  W_CASE LEFT DELETING LEADING SPACE.

**************ADDRESS***************
      SELECT SINGLE * FROM KNA1 WHERE KUNNR EQ WA_TAB1-KUNAG.
*       (w_land1, w_regio, w_add, w_niels)
      IF SY-SUBRC EQ 0.
        V_BAHNS = KNA1-BAHNS.
        V_BAHNE = KNA1-BAHNE.
        SELECT SINGLE * FROM ADRC WHERE ADDRNUMBER = KNA1-ADRNR.
        IF SY-SUBRC EQ 0.
          CLEAR : C_STATE,CNAME1,CNAME2,CNAME3,CNAME4,CCITY.
          CNAME1 = KNA1-NAME1.
          CNAME2 = ADRC-STREET.
          CNAME3 = ADRC-STR_SUPPL1.
          CNAME4 = ADRC-STR_SUPPL2.
          CCITY =  ADRC-CITY1.
          CCITY1 = KNA1-ORT01.
          CPSTLZ = KNA1-PSTLZ.
          C_STATE = KNA1-STCD3.
          TINNO = KNA1-STCD3.
          PANNO = KNA1-J_1IPANNO.  "Added by Varsha 18-09-2025
*          extension1 = adrc-extension1.    "Commented by Varsha 18-09-2025
          SELECT SINGLE * FROM J_1IMOCUST WHERE KUNNR = WA_TAB1-KUNAG.
          IF SY-SUBRC EQ 0.
            CSTNO = J_1IMOCUST-J_1ICSTNO.
*          TINNO = J_1IMOCUST-J_1ILSTNO.
*            panno = j_1imocust-j_1ipanno.   "Commented by Varsha 18-09-2025
          ENDIF.
        ENDIF.


********** Added by Varsha 18-09-2025*********************


        SELECT IDNUMBER , TYPE FROM BUT0ID INTO TABLE @DATA(IT_IDS)
          WHERE PARTNER = @KNA1-KUNNR AND TYPE IN ('ZDL20B' , 'ZDL21B' ).

        LOOP AT IT_IDS INTO DATA(LS_IDS).
          CASE LS_IDS-TYPE.
            WHEN 'ZDL20B'.
              EXTENSION_A = LS_IDS-IDNUMBER.
            WHEN 'ZDL21B'.
              EXTENSION_B = LS_IDS-IDNUMBER.
          ENDCASE.
        ENDLOOP.

        CONCATENATE EXTENSION_A EXTENSION_B INTO EXTENSION1 SEPARATED BY ','.

*****************************************************

      ENDIF.
      SELECT SINGLE * FROM T001W WHERE WERKS EQ WA_TAB1-WERKS.
      SELECT SINGLE * FROM KNA1 WHERE KUNNR EQ T001W-KUNNR.
      SELECT SINGLE * FROM ADRC WHERE ADDRNUMBER = T001W-ADRNR.
      CLEAR : P_STATE,PNAME1,PNAME2,PNAME3,PNAME4,PCITY1.
*****************************************Added & commented by VARSHA 20-09-2025***************
      PNAME1 = T001W-NAME1.
      PNAME2 = T001W-STRAS.
      PNAME3 = ADRC-STR_SUPPL1.
      PNAME4 = ADRC-STR_SUPPL2.
      PCITY1 = T001W-ORT01.
      P_PSTLZ = T001W-PSTLZ.
      DRUG = ADRC-NAME4.


*            SELECT SINGLE * FROM ZT001W WHERE WERKS EQ WA_TAB1-WERKS AND FROM_DT LE WA_VBRK-FKDAT AND TO_DT GE WA_VBRK-FKDAT.
*            IF SY-SUBRC EQ 0.
**              PNAME1 = ZT001W-NAME2.
**              PNAME2 = ZT001W-NAME3.
**              PNAME3 = ZT001W-NAME4.
**              PNAME4 = SPACE.
**              PCITY1 = ZT001W-ORT01.
*              DRUG = ZT001W-EXTENSION1.
*            ELSE.
**              PNAME1 = ADRC-NAME1.
***              PNAME2 = ADRC-NAME2.
**              PNAME3 = ADRC-NAME3.
**              PNAME4 = ADRC-NAME4.
**              PCITY1 = ADRC-CITY1.
*              DRUG = ADRC-EXTENSION1.
*            ENDIF.
**********************************************************************************
      P_STATE = KNA1-STCD3.

      PHONE = ADRC-TEL_NUMBER.
      E_STATE = KNA1-STCD3+0(2).
      E_TINNO = KNA1-STCD3.

      CLEAR : V_BSTNK,V_BSTDK.
      SELECT SINGLE * FROM VBAK WHERE VBELN EQ WA_TAB1-AUBEL.
      IF SY-SUBRC EQ 0.
        V_BSTNK = VBAK-BSTNK.
        V_BSTDK = VBAK-BSTDK.
      ENDIF.
      SELECT SINGLE * FROM VBPA WHERE VBELN = WA_TAB1-VBELN AND PARVW EQ 'AG'.
      IF SY-SUBRC EQ 0.
        A_KUNNR = VBPA-KUNNR.
      ENDIF.
      sort IT_TAB2. "by vbeln . "add by ps
                              "ADD BY PS
      CLEAR : BILLNO,BDATE,BTIME,BDATE1.
      BILLNO = WA_TAB1-VBELN.
      BDATE  = WA_TAB1-FKDAT.

      BDATE1+0(2) = WA_TAB1-FKDAT+6(2).
      BDATE1+2(1) = '/'.
      BDATE1+3(2) = WA_TAB1-FKDAT+4(2).
      BDATE1+5(1) = '/'.
      BDATE1+6(4) = WA_TAB1-FKDAT+0(4).

      CLEAR : INVTYP1,INVTYP2,TTAX.
      TTAX = IGST + CGST + SGST.
      IF TTAX GT 0 AND TINNO NE SPACE.
        INVTYP1 = 'B2B'.
      ELSE.
        INVTYP1 = 'B2C'.
      ENDIF.
      INVTYP2 = 'Regular'.

      BTIME  = WA_TAB1-ERZET.
*      SELECT SINGLE * FROM vbpa WHERE vbeln EQ wa_tab1-vgbel AND parvw EQ 'SP'.
*      IF sy-subrc EQ 0.
**        adrnr into (v_adrnr) from vbpa where vbeln eq v_vgbel and parvw eq 'SP'.
*        SELECT SINGLE * FROM adrc WHERE addrnumber EQ vbpa-adrnr.
*        IF sy-subrc EQ 0.
*          v_name1 = adrc-name1.
*        ENDIF.
*      ENDIF.
*
*      if wa_tab1-fkdat ge '20240401'.  "aaded on 1.4.24
*      clear v_name1.
*        select single t_name from zteway_transport into v_name1 where bukrs eq 'BCLL' and docno eq wa_tab1-vbeln.
**        IF SY-SUBRC EQ 0.
**            v_name1 = ZTEWAY_TRANSPORT-T_NAME.
**        ENDIF.
*      endif.



*****      IF WA_TAB1-FKDAT GE '20240401'.  "aaded on 1.4.24                               " commented by ps 3277 line to 3297
*****        SELECT SINGLE * FROM VBPA WHERE VBELN EQ VBRK-VBELN AND PARVW EQ 'ZT'.
*****        IF SY-SUBRC EQ 0.
******        adrnr into (v_adrnr) from vbpa where vbeln eq v_vgbel and parvw eq 'SP'.
*****          SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ VBPA-LIFNR.
*****          IF SY-SUBRC EQ 0.
*****            V_NAME1 = LFA1-NAME1.
*****          ENDIF.
*****        ENDIF.
*****
*****      ELSE.
*****
*****        CLEAR V_NAME1.
*****        SELECT SINGLE T_NAME FROM ZTEWAY_TRANSPORT INTO V_NAME1 WHERE BUKRS EQ '1000' AND DOCNO EQ WA_TAB1-VBELN.
*****        IF V_NAME1 IS INITIAL.
*****          SELECT SINGLE * FROM ZTRANSPORT WHERE KUNNR EQ WA_TAB1-KUNAG.
*****          IF SY-SUBRC EQ 0.
*****            V_NAME1 = ZTRANSPORT-TRPNAME.
*****          ENDIF.
*****        ENDIF.
*****      ENDIF.


  IF WA_TAB1-FKDAT GE '20240401'.  "aaded on 1.4.24
        CLEAR V_NAME1.
        SELECT SINGLE T_NAME FROM ZTEWAY_TRANSPORT INTO V_NAME1 WHERE BUKRS EQ '1000' AND DOCNO EQ WA_TAB1-VBELN.
        IF V_NAME1 IS INITIAL.
          SELECT SINGLE * FROM ZTRANSPORT WHERE KUNNR EQ WA_TAB1-KUNAG.
          IF SY-SUBRC EQ 0.
            V_NAME1 = ZTRANSPORT-TRPNAME.
          ENDIF.
        ENDIF.

      ELSE.

        SELECT SINGLE * FROM VBPA WHERE VBELN EQ WA_TAB1-VGBEL AND PARVW EQ 'ZT'.
        IF SY-SUBRC EQ 0.
*        adrnr into (v_adrnr) from vbpa where vbeln eq v_vgbel and parvw eq 'SP'.
          SELECT SINGLE * FROM ADRC WHERE ADDRNUMBER EQ VBPA-ADRNR.
          IF SY-SUBRC EQ 0.
            V_NAME1 = ADRC-NAME1.
          ENDIF.
        ENDIF.
      ENDIF.

      SELECT  SINGLE * FROM ZUPLOAD WHERE VBELN EQ WA_TAB1-VBELN.
      IF SY-SUBRC EQ 0.
        V_BOLNR = ZUPLOAD-BOLNR.
        V_ZFBDT = ZUPLOAD-ZFBDT.
        NOCASE = ZUPLOAD-CASES.
      ENDIF.

*************************

*** for NO OF CASES (MAINTAINED IN DELIVERY DOCUMENT HEADER )
      REFRESH ITLINE.
      CLEAR : ITLINE.
*    SELECT SINGLE VGBEL INTO (V_VGBEL) FROM VBRP WHERE VBELN EQ VBRK-VBELN.
      SELECT SINGLE * FROM STXH WHERE TDNAME EQ WA_TAB1-VGBEL AND TDID = '0002' AND TDOBJECT = 'VBBK'.
*                     and tdspras eq 'EN'.

      CONCATENATE WA_TAB1-VGBEL ' ' INTO SIMPLE.

      IF SY-SUBRC IS INITIAL.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = '0002'
            LANGUAGE                = 'E'
            NAME                    = SIMPLE
            OBJECT                  = 'VBBK'
          TABLES
            LINES                   = ITLINE
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

        READ TABLE ITLINE INDEX 1.
*        move itline-tdline to nocase." NO. OF. CASES
      ENDIF.

*    name1 into (v_name1) from adrc where addrnumber eq v_adrnr.
************* EWAY BILL NO & DATE*****************************


      CLEAR : EWAY,EWAYDT,ED1,EM1,EY1.
      SELECT SINGLE * FROM J_1IG_EWAYBILL WHERE BUKRS EQ '1000' AND DOCNO EQ  WA_CHECK-VBELN AND STATUS EQ 'A' AND EBILLNO GT 0.
      IF SY-SUBRC EQ 0.
        EWAY = J_1IG_EWAYBILL-EBILLNO.
        EWAYBILL = EWAY.
        CONDENSE EWAYBILL.

        ED1 = J_1IG_EWAYBILL-ERDAT+6(2).
        EM1 = J_1IG_EWAYBILL-ERDAT+4(2).
        EY1 = J_1IG_EWAYBILL-ERDAT+0(4).
        CONCATENATE ED1 EM1 EY1 INTO EWAYDT SEPARATED BY '.'.
        EWAYDATE = EWAYDT.
        CONDENSE EWAYDATE.

*    EWAYDT = J_1IG_EWAYBILL-ERDAT.
      ELSE.
        NUM =  WA_TAB1-VBELN.

        CALL FUNCTION 'READ_TEXT'
          EXPORTING
*           CLIENT                  = SY-MANDT
            ID                      = 'YWAY'
            LANGUAGE                = 'E'
            NAME                    = NUM
            OBJECT                  = 'VBBK'
*           ARCHIVE_HANDLE          = 0
*                  IMPORTING
*           HEADER                  =
          TABLES
            LINES                   = MMLINE1
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
        LOOP AT MMLINE1.
          EWAY =  MMLINE1-TDLINE+0(20).
*    WRITE :  / 'LR',LRNO.
          EXIT.
        ENDLOOP.

        EWAYBILL = EWAY.
        CONDENSE EWAYBILL.

        CALL FUNCTION 'READ_TEXT'
          EXPORTING
*           CLIENT                  = SY-MANDT
            ID                      = 'YWAD'
            LANGUAGE                = 'E'
            NAME                    = NUM
            OBJECT                  = 'VBBK'
*           ARCHIVE_HANDLE          = 0
*                  IMPORTING
*           HEADER                  =
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
          EWAYDT =  MMLINE2-TDLINE+0(20).
*    WRITE :  / 'LR',LRNO.
          EXIT.
        ENDLOOP.
        EWAYDATE = EWAYDT.
        CONDENSE EWAYDATE.

      ENDIF.
****************************************

*    IF CN NE 0.
*      CN2 = TAMT - CN.
*      CN1 = CN2.
*    ENDIF.
      NETAMT1 = TAMT - ( ADV + CN ).
      NETAMT2 = TAMT - ( ADV + CN ).
      NETAMT = NETAMT1.
      AT END OF VBELN.
*        BREAK-POINT.


*        rval = netamt - tamt.
*        if rval lt 0.
*          rval = rval * ( - 1 ).
*          rval1 = rval.
**          CONCATENATE '-' RVAL INTO RVAL.
**        ELSE.
**          RVAL = RVAL1.
*          concatenate '-' rval1 into rval1.
*        else.
*          rval1 = rval.
*        endif.


        IF NETAMT LT 0.
          CREDITBAL1 = NETAMT * ( - 1 ).
          CONCATENATE '(Credit Balance' CREDITBAL1 ')' INTO CREDITBAL SEPARATED BY SPACE.
          CONDENSE CREDITBAL.
          NETAMT = 0.

        ENDIF.
        IF NETAMT NE 0.
          RVAL = NETAMT - NETAMT2.
          IF RVAL GT -1 AND RVAL LT 1.
            RVAL1 = RVAL.
          ENDIF.

        ELSE.
          IF TAMT GT ADV.
            IF CN NE 0.
              IF ( ADV + CN ) NE TAMT.
                CLEAR : RVAL,RVAL1.
                RVAL = TAMT - ( ADV + CN ).
                IF RVAL GT -1 AND RVAL LT 1.
                  RVAL1 = RVAL.
                ENDIF.
              ENDIF.
            ELSE.
              RVAL = TAMT -  ADV .
              IF RVAL GT -1 AND RVAL LT 1.
                RVAL1 = RVAL.
              ENDIF.
            ENDIF.
          ELSE.
            RVAL1 = '0.00'.
          ENDIF.
        ENDIF.
*        CONDENSE RVAL1.
        IF RVAL1 EQ SPACE.
          RVAL1 = '0.00'.
        ENDIF.
      ENDAT.
      AT END OF VBELN.
        IF ADV GT TAMT.
          ADV = TAMT.
        ENDIF.
      ENDAT.

*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'ITEM'
*        EXCEPTIONS
*          OTHERS  = 1.



*      IF COUNT GT 22.
*        CALL FUNCTION 'CONTROL_FORM'
*          EXPORTING
*            COMMAND = 'NEW-PAGE'.
*        COUNT = 1.
*      ENDIF.


      COUNT = COUNT + 1.
      CNT1 = CNT1 + 1.
    ENDLOOP.


*    clear : tval,tdis,tnet,igst,cgst,sgst,tamt,todis,ttnet,adv,netamt1,netamt,cn,cn1,cn2,credit,discnt,discnt1,discnt2,xl,bc,bc1,xl1,ewaybill,ewaydate,
*    eway,ewaydt,credit,creditbal,creditbal1,adj,totnet,totjoig,totjocg,totjosg,totdis,ttaxable,tzdit,tottaxable,rval,rval1,cnt1,netamt2,xlval,bcval.
*    refresh :mmline1,mmline2.
*    refresh itline.
*    clear : itline.
  ENDLOOP.
  COUNT = 1.
  LOOP AT IT_TAB1 INTO WA_TAB1.
    WA_TAB2-COUNT = COUNT.
    WA_TAB2-VBELN = WA_TAB1-VBELN.
    WA_TAB2-CHARG = WA_TAB1-CHARG.
    WA_TAB2-FKIMG = WA_TAB1-FKIMG.
    CONDENSE WA_TAB2-FKIMG.
    WA_TAB2-STEUC = WA_TAB1-STEUC.
*    select single * from makt where matnr eq wa_tab1-matnr.
*    if sy-subrc eq 0.
*      wa_tab2-arktx = makt-maktx.
*    endif.
    WA_TAB2-ARKTX = WA_TAB1-ARKTX.

*    IF WA_TAB1-FKDAT GE '20221221'.
*      SELECT SINGLE * FROM ZNLEM WHERE MATNR EQ WA_TAB1-MATNR.
*      IF SY-SUBRC EQ 0.
*        CONCATENATE WA_TAB2-ARKTX '##' INTO WA_TAB2-ARKTX SEPARATED BY SPACE.
*        NLEMTXT1 = '## IMP NOTE: MRP of this product has been reduced and has to be given effect immediately.'.
*        NLEMTXT2 = 'Accordingly, we are billing you at lower PTS. You should also bill your Retailers'.
*        NLEMTXT3 = 'at lower PTR so that they should sell to Consumers at lower MRP as mentioned above.'.
*        CONCATENATE NLEMTXT1 NLEMTXT2 NLEMTXT3 INTO NLEMTXT SEPARATED BY SPACE.
*      ENDIF.
*    ENDIF.

    WA_TAB2-BEZEI = WA_TAB1-BEZEI.
    WA_TAB2-TEXT1 = WA_TAB1-TEXT1.
    WA_TAB2-TEXT2 = WA_TAB1-TEXT2.
    WA_TAB2-VFDAT  = WA_TAB1-VFDAT.
    WA_TAB2-MRP = WA_TAB1-MRP.
    WA_TAB2-PTR = WA_TAB1-PTR.
    READ TABLE IT_TAS1 INTO WA_TAS1 WITH KEY VBELN = WA_TAB1-VBELN MATNR = WA_TAB1-MATNR CHARG = WA_TAB1-CHARG SRL = WA_TAB1-SRL.
    IF SY-SUBRC EQ 0.
      WA_TAB2-W_CASE = WA_TAS1-W_CASE.
    ENDIF.
    WA_TAB2-PTS = WA_TAB1-PTS.
    WA_TAB2-VAL = WA_TAB1-VAL.
    WA_TAB2-DISPER = WA_TAB1-DISPER.
    WA_TAB2-DIS = WA_TAB1-DIS.
    WA_TAB2-ODIS = WA_TAB1-ODIS.
    WA_TAB2-TAXABLE = WA_TAB1-TAXABLE.
    WA_TAB2-JOIG_RT1 = WA_TAB1-JOIG_RT1.
    WA_TAB2-JOIG_AMT = WA_TAB1-JOIG_AMT.
    WA_TAB2-JOCG_RT1 = WA_TAB1-JOCG_RT1 * 10.
    WA_TAB2-JOCG_AMT = WA_TAB1-JOCG_AMT.
    WA_TAB2-JOSG_RT1 = WA_TAB1-JOSG_RT1 * 10.
    WA_TAB2-JOSG_AMT = WA_TAB1-JOSG_AMT.
    WA_TAB2-TTAXABLE = WA_TAB1-TTAXABLE.

    COLLECT WA_TAB2 INTO IT_TAB2.
    CLEAR WA_TAB2.
    COUNT = COUNT + 1.
  ENDLOOP.
**clear :lv_ackno,lv_irn,lv_qrcode.
**SELECT SINGLE ack_no irn signed_qrcode
**  FROM j_1ig_invrefnum
**  INTO (lv_ackno , lv_irn , lv_qrcode )
**  WHERE docno = vbrk-vbeln.

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

  BODY = 'Please find the attached SALE INVOICE in PDF format.'.
  APPEND BODY TO LT_MESSAGE_BODY.
  APPEND INITIAL LINE TO LT_MESSAGE_BODY.

  FOOTER = 'With Regards,'.
  APPEND FOOTER TO LT_MESSAGE_BODY.
  FOOTER = 'BLUE CROSS LABORATORIES PVT LTD.'.
  APPEND FOOTER TO LT_MESSAGE_BODY.
  "put your text into the document
  LO_DOCUMENT = CL_DOCUMENT_BCS=>CREATE_DOCUMENT(
    I_TYPE    = 'RAW'
    I_TEXT    = LT_MESSAGE_BODY
    I_SUBJECT = 'INVOICE' ).

*DATA: l_size TYPE sood-objlen. " Size of Attachment
*l_size = l_lines * 255.
  TRY.
      LO_DOCUMENT->ADD_ATTACHMENT(
        EXPORTING
          I_ATTACHMENT_TYPE    = 'PDF'
          I_ATTACHMENT_SUBJECT = 'INVOICE'
          I_ATT_CONTENT_HEX    = I_OBJBIN[] ).
    CATCH CX_DOCUMENT_BCS INTO LX_DOCUMENT_BCS.
  ENDTRY.

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
*&      Form  EWAYCHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM EWAYCHECK .
  IF TAX1 NE SPACE.
    IF EWAY EQ SPACE.
      SELECT SINGLE * FROM VBRK WHERE VBELN EQ WA_CHECK-VBELN.
      IF SY-SUBRC EQ 0.
        IF VBRK-FKDAT GE '20240222'.
*          SELECT SINGLE * FROM vbrp WHERE vbeln EQ vbrk-vbeln AND werks NE '2007' AND werks NE '2016'.
          SELECT SINGLE * FROM VBRP WHERE VBELN EQ VBRK-VBELN AND WERKS NE '2007' .  "plant 2016 is adde on 30.5.24
          IF SY-SUBRC EQ 0.
            IF TOTJOIG GT 0.
              ITYP = 'ZSTO'.
            ELSE.
              ITYP = 'ZSTI'.
            ENDIF.
            SELECT SINGLE * FROM T001W WHERE WERKS EQ VBRP-WERKS .
            IF SY-SUBRC EQ 0.
              SELECT SINGLE * FROM ZEWAY_LIMIT WHERE REGIO EQ T001W-REGIO AND FKART EQ ITYP.
              IF SY-SUBRC EQ 0.
                IF ZEWAY_LIMIT-NETWR LE ( VBRK-NETWR + VBRK-MWSBK ).
                  IF T001W-WERKS EQ '2011' AND VBRK-ZTERM EQ 'Z007'.
                    IF ZEWAY_LIMIT-OTHR LE ( VBRK-NETWR + VBRK-MWSBK ).
                      CLEAR TAX1.
                      NTXT1 = 'PACKING LIST'.
                      NTXT2 = SPACE.
                    ENDIF.
                  ELSE.
                    CLEAR TAX1.

                    NTXT1 = 'PACKING LIST'.
                    NTXT2 = SPACE.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
