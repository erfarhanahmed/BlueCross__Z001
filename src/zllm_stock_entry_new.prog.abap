*&---------------------------------------------------------------------*
*& Report  ZDISTRIBUTOR_SALE1
*& DEVELOPED BY JYOTSNA : 14.10.22
*&---------------------------------------------------------------------*
*&changes done on 11.10.24 to take material code from PO if same batch prefix with different pack size.
** if under quality the do not allow for dispatch Jyotsna 11.10.24
*& PARAMETER ID IS ADDED ON 20.10.24 - JYOTSNA - 'KD0'
*&---------------------------------------------------------------------*
*REPORT ZDISTRIBUTOR_SALE1_A1.
REPORT ZLLM_STOCK_ENTRY_NEW.


TABLES :
*  zdist_sale,
  KNA1,
  VBRK,
  VBRP,
  MAKT,
  USR05,
  MARA,
  A602,
  KONP,
*         zdist_invalid ,
  ZLLM,
  MCHA,
****************************************
  LFA1,
  EKKO,
  EKPO.
*  ZPRODBATCHES.
*  ZTP_PRD_PREFIX.

TYPE-POOLS : SLIS.


DATA: COUNT TYPE I.
TYPES : BEGIN OF ITAB1,
          KUNRG       TYPE VBRK-KUNRG,
          KUNAG       TYPE VBRK-KUNAG,
          LIFNR       TYPE LFA1-LIFNR,
          MATNR       TYPE VBRP-MATNR,
          CHARG       TYPE VBRP-CHARG,
          EBELN       TYPE EKPO-EBELN,
          FKIMG(15)   TYPE C,
          STATUS(15)  TYPE C,
          REMARK(100) TYPE C,
*          fkimg    type vbrp-fkimg,
          BUZEI(3)    TYPE C,
          NAME1       TYPE ADRC-NAME1,
          PAYER       TYPE KNA1-NAME1,
          CUSTOMER    TYPE KNA1-NAME1,
        END OF ITAB1.

TYPES : BEGIN OF ITAB2,
          KUNRG     TYPE ZDIST_SALE-KUNRG,
          KUNAG     TYPE ZDIST_SALE-KUNAG,
          BUDAT     TYPE ZDIST_SALE-BUDAT,
          UZEIT     TYPE ZDIST_SALE-UZEIT,
          BUZEI     TYPE ZDIST_SALE-BUZEI,
          MATNR     TYPE ZDIST_SALE-MATNR,
          CHARG     TYPE ZDIST_SALE-CHARG,
          FKIMG(15) TYPE C,
          FKDAT     TYPE SY-DATUM,
          RATE      TYPE P DECIMALS 2,
          VAL       TYPE P DECIMALS 2,
          UNAME     TYPE ZDIST_SALE-UNAME,
        END OF ITAB2.

DATA: IT_TAB1 TYPE TABLE OF ITAB1,
      WA_TAB1 TYPE ITAB1,
      IT_TAB2 TYPE TABLE OF ITAB2,
      WA_TAB2 TYPE ITAB2.

DATA: ZDIST_SALE_WA TYPE ZDIST_SALE.
DATA: ZDIST_CN_WA TYPE ZDIST_CN.
DATA: E   TYPE I,
      E1  TYPE I,
      PO1 TYPE I.

DATA: DATE2 TYPE SY-DATUM.
DATA: RATE TYPE P DECIMALS 2,
      VAL  TYPE P DECIMALS 2,
      MRP  TYPE KONP-KBETR.

******************************
DATA: G_REPID     LIKE SY-REPID,
      FIELDCAT    TYPE SLIS_T_FIELDCAT_ALV,
      WA_FIELDCAT LIKE LINE OF FIELDCAT,
      SORT        TYPE SLIS_T_SORTINFO_ALV,
      WA_SORT     LIKE LINE OF SORT,
      LAYOUT      TYPE SLIS_LAYOUT_ALV,
      L_GLAY      TYPE LVC_S_GLAY.

DATA: G_REPID1     LIKE SY-REPID,
      FIELDCAT1    TYPE SLIS_T_FIELDCAT_ALV,
      WA_FIELDCAT1 LIKE LINE OF FIELDCAT,
      SORT1        TYPE SLIS_T_SORTINFO_ALV,
      WA_SORT1     LIKE LINE OF SORT,
      LAYOUT1      TYPE SLIS_LAYOUT_ALV,
      L_GLAY1      TYPE LVC_S_GLAY.
****************************************************

DATA: VARIANT TYPE DISVARIANT.
DATA : GR_ALVGRID    TYPE REF TO CL_GUI_ALV_GRID,
       GR_CCONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
       GT_FCAT       TYPE LVC_T_FCAT,
       GS_LAYO       TYPE LVC_S_LAYO.
DATA: C_ALVGD   TYPE REF TO CL_GUI_ALV_GRID.         "ALV grid object
DATA: IT_DROPDOWN TYPE LVC_T_DROP,
      TY_DROPDOWN TYPE LVC_S_DROP,
*data declaration for refreshing of alv
      STABLE      TYPE LVC_S_STBL.
*Global variable declaration
DATA: GSTRING TYPE C.
*Data declarations for ALV
DATA: C_CCONT   TYPE REF TO CL_GUI_CUSTOM_CONTAINER,         "Custom container object
*      C_ALVGD   TYPE REF TO CL_GUI_ALV_GRID,         "ALV grid object
      IT_FCAT   TYPE LVC_T_FCAT,                  "Field catalogue
      IT_LAYOUT TYPE LVC_S_LAYO.                  "Layout
*ok code declaration
DATA: OK_CODE  TYPE UI_FUNC,
      OK_CODE1 TYPE UI_FUNC,
      OK_CODE4 TYPE UI_FUNC.
*data: count type  i.
DATA: SDATE1 TYPE SY-DATUM.


DATA:
*      it_vbrk  type table of vbrk,
*      wa_vbrk  type vbrk,
*      it_vbrp  type table of vbrp,
*      wa_vbrp  type vbrp,
*      it_vbrk1 type table of vbrk,
*      wa_vbrk1 type vbrk,
*      it_vbrp1 type table of vbrp,
*      wa_vbrp1 type vbrp,
  IT_MCHA TYPE TABLE OF MCHA,
  WA_MCHA TYPE MCHA.

DATA: IT_ZLLM       TYPE TABLE OF ZLLM,
      WA_ZLLM       TYPE ZLLM,
      IT_ZLLM_DSP   TYPE TABLE OF ZLLM_DSP,
      WA_ZLLM_DSP   TYPE ZLLM_DSP,
      IT_ZLLM_DSP11 TYPE TABLE OF ZLLM_DSP,
      WA_ZLLM_DSP11 TYPE ZLLM_DSP,
      IT_EKBE       TYPE TABLE OF EKBE,
      WA_EKBE       TYPE EKBE,
      IT_MSEG       TYPE TABLE OF MSEG,
      WA_MSEG       TYPE MSEG,
      IT_MSEG1      TYPE TABLE OF MSEG,
      WA_MSEG1      TYPE MSEG.

DATA: FQTY  TYPE DD01V-DATATYPE.

TYPES: BEGIN OF DISP1,

         LIFNR        TYPE LFA1-LIFNR,
         NAME1        TYPE LFA1-NAME1,
         STATUS(15)   TYPE C,
         BUZEI        TYPE ZDIST_SALE-BUZEI,
         MATNR        TYPE ZDIST_SALE-MATNR,
         CHARG        TYPE ZDIST_SALE-CHARG,
         EBELN        TYPE EKPO-EBELN,
         FKIMG(15)    TYPE C,
         DISP_QTY(15) TYPE C,
         QTY(15)      TYPE C,
         QTY1         TYPE VBRP-FKIMG,
         BUDAT        TYPE ZDIST_SALE-BUDAT,
         UZEIT        TYPE ZDIST_SALE-UZEIT,
         UNAME        TYPE ZDIST_SALE-UNAME,
         MAKTX        TYPE MAKT-MAKTX,
         CUSTOMER     TYPE   KNA1-NAME1,
         FKDAT        TYPE SY-DATUM,
         RATE         TYPE P DECIMALS 2,
         VAL          TYPE P DECIMALS 2,
         MATNR1       TYPE MARA-MATNR,
         FKIMG1       TYPE VBRP-FKIMG,
         DISP_QTY1    TYPE VBRP-FKIMG,
         WERKS        TYPE MCHA-WERKS,
         ERSDA        TYPE MCHA-ERSDA,
         MBLNR        TYPE MSEG-MBLNR,
         REMARK       TYPE ZLLM-REMARK,
         QAREMARK     TYPE ZLLM-REMARK,
         CPUDT        TYPE SY-DATUM,
         CPUTM        TYPE SY-UZEIT,
         DOC(30)      TYPE C,
         CHGDT        TYPE ZLLM-CHGDT,
         CHGTM        TYPE ZLLM-CHGTM,

*         STYPE(6) TYPE C,
*         LIFNR    TYPE LFA1-LIFNR,
*         NAME1    TYPE LFA1-NAME1,
**         STATUS(15)   TYPE C,
*         BUZEI    TYPE ZDIST_SALE-BUZEI,
*         MATNR    TYPE ZDIST_SALE-MATNR,
*         CHARG    TYPE ZDIST_SALE-CHARG,
**         EBELN        TYPE EKPO-EBELN,
*         FKIMG    TYPE I,
**         DISP_QTY(15) TYPE C,
**         QTY(15)      TYPE C,
**         QTY1         TYPE VBRP-FKIMG,
**         BUDAT        TYPE ZDIST_SALE-BUDAT,
**         UZEIT        TYPE ZDIST_SALE-UZEIT,
**         UNAME        TYPE ZDIST_SALE-UNAME,
*         MAKTX    TYPE MAKT-MAKTX,
*         XBLNR    TYPE XBLNR,
*         BLDAT    TYPE SY-DATUM,
**         CUSTOMER     TYPE   KNA1-NAME1,
**         FKDAT        TYPE SY-DATUM,
**         RATE         TYPE P DECIMALS 2,
**         VAL          TYPE P DECIMALS 2,
**         MATNR1       TYPE MARA-MATNR,
**         FKIMG1       TYPE VBRP-FKIMG,
**         DISP_QTY1    TYPE VBRP-FKIMG,
**         WERKS        TYPE MCHA-WERKS,
**         ERSDA        TYPE MCHA-ERSDA,
**         MBLNR        TYPE MSEG-MBLNR,
**         REMARK       TYPE ZLLM-REMARK,
**         QAREMARK     TYPE ZLLM-REMARK,
*         UNAME    TYPE SY-UNAME,
*         CPUDT    TYPE SY-DATUM,
*         CPUTM    TYPE SY-UZEIT,
**         DOC(30)      TYPE C,
**         CHGDT        TYPE ZLLM-CHGDT,
**         CHGTM        TYPE ZLLM-CHGTM,
       END OF DISP1.

TYPES: BEGIN OF DISP4,


         STYPE(6) TYPE C,
         LIFNR    TYPE LFA1-LIFNR,
         NAME1    TYPE LFA1-NAME1,
*         STATUS(15)   TYPE C,
         BUZEI    TYPE ZDIST_SALE-BUZEI,
         MATNR    TYPE ZDIST_SALE-MATNR,
         CHARG    TYPE ZDIST_SALE-CHARG,
*         EBELN        TYPE EKPO-EBELN,
         FKIMG    TYPE I,
*         DISP_QTY(15) TYPE C,
*         QTY(15)      TYPE C,
*         QTY1         TYPE VBRP-FKIMG,
*         BUDAT        TYPE ZDIST_SALE-BUDAT,
*         UZEIT        TYPE ZDIST_SALE-UZEIT,
*         UNAME        TYPE ZDIST_SALE-UNAME,
         MAKTX    TYPE MAKT-MAKTX,
         XBLNR    TYPE XBLNR,
         BLDAT    TYPE SY-DATUM,
*         CUSTOMER     TYPE   KNA1-NAME1,
*         FKDAT        TYPE SY-DATUM,
*         RATE         TYPE P DECIMALS 2,
*         VAL          TYPE P DECIMALS 2,
*         MATNR1       TYPE MARA-MATNR,
*         FKIMG1       TYPE VBRP-FKIMG,
*         DISP_QTY1    TYPE VBRP-FKIMG,
*         WERKS        TYPE MCHA-WERKS,
*         ERSDA        TYPE MCHA-ERSDA,
*         MBLNR        TYPE MSEG-MBLNR,
*         REMARK       TYPE ZLLM-REMARK,
*         QAREMARK     TYPE ZLLM-REMARK,
         UNAME    TYPE SY-UNAME,
         CPUDT    TYPE SY-DATUM,
         CPUTM    TYPE SY-UZEIT,
*         DOC(30)      TYPE C,
*         CHGDT        TYPE ZLLM-CHGDT,
*         CHGTM        TYPE ZLLM-CHGTM,
       END OF DISP4.


TYPES: BEGIN OF DISP2,
         KUNRG     TYPE ZDIST_SALE-KUNRG,
         KUNAG     TYPE ZDIST_SALE-KUNAG,
         BUDAT     TYPE ZDIST_SALE-BUDAT,
         UZEIT     TYPE ZDIST_SALE-UZEIT,
         BUZEI     TYPE ZDIST_SALE-BUZEI,
         MATNR     TYPE ZDIST_SALE-MATNR,
         CHARG     TYPE ZDIST_SALE-CHARG,
         FKIMG(15) TYPE C,
         FKDAT     TYPE SY-DATUM,
         RATE      TYPE P DECIMALS 2,
         VAL       TYPE P DECIMALS 2,
         UNAME     TYPE ZDIST_SALE-UNAME,
       END OF DISP2.

TYPES: BEGIN OF DISP3,
         EBELN      TYPE EKPO-EBELN,
         MATNR      TYPE ZDIST_SALE-MATNR,
         CHARG      TYPE ZDIST_SALE-CHARG,
         BUZEI      TYPE ZDIST_SALE-BUZEI,
         FKIMG(15)  TYPE C,
         FKIMG1(15) TYPE C,  "TOTAL QTY
         FKDAT      TYPE SY-DATUM,
*         rate       type p decimals 2,
*         val        type p decimals 2,
*         uname      type zdist_sale-uname,
         REMARK     TYPE ZLLM-REMARK,
         NAME1      TYPE LFA1-NAME1,
         MAKTX      TYPE MAKT-MAKTX,
         LIFNR      TYPE LFA1-LIFNR,
         STATUS     TYPE ZLLM-STATUS,
       END OF DISP3.

TYPES: BEGIN OF DSP1,
         MATNR    TYPE MARA-MATNR,
         CHARG    TYPE MCHB-CHARG,
         LIFNR    TYPE LFA1-LIFNR,
         DISP_QTY TYPE MSEG-MENGE,
         EBELN    TYPE EKPO-EBELN,
       END OF DSP1.

DATA: IT_DISP1 TYPE TABLE OF DISP1,
      WA_DISP1 TYPE DISP1,
      IT_DISP2 TYPE TABLE OF DISP2,
      WA_DISP2 TYPE DISP2,
      IT_DISP3 TYPE TABLE OF DISP3,
      WA_DISP3 TYPE DISP3,
      IT_DISP4 TYPE TABLE OF DISP4,
      WA_DISP4 TYPE DISP4,
      IT_DSP1  TYPE TABLE OF DSP1,
      WA_DSP1  TYPE DSP1.
DATA: PLANT    TYPE VBRP-WERKS,
      MSG      TYPE STRING,
      DOC1(30) TYPE C,
      MATNR1   TYPE MCHA-MATNR.
**************************************
DATA: LO_GOS_MANAGER TYPE REF TO CL_GOS_MANAGER,
      LS_BORIDENT    TYPE BORIDENT,
      LV_MBLNR(30)   TYPE C.
***********************************************
*data: qty type p.
DATA: COUNT1(3) TYPE C.
DATA: ZLLM_WA TYPE ZLLM.
DATA: ZLLM_DSP_WA TYPE ZLLM_DSP.
DATA LV_FLDCAT TYPE LVC_S_FCAT.
DATA: BUZEI TYPE BSEG-BUZEI.
DATA: QTY1 TYPE MSEG-MENGE.
DATA: C_FILE TYPE STRING.

TYPES: BEGIN OF UPD1,
         STYPE(6)  TYPE C,
         CHARG(10) TYPE C,
         QTY(15)   TYPE C,
         STAT(1)   TYPE C,
         EBELN(10) TYPE C,
       END OF UPD1.

TYPES: BEGIN OF UPD11,
         STYPE(6)  TYPE C,
         CHARG(10) TYPE C,
         QTY(15)   TYPE C,
         XBLNR     TYPE XBLNR,
         BLDAT     TYPE BLDAT,

       END OF UPD11.

TYPES: BEGIN OF UPD2,
         STYPE(6)  TYPE C,
         CHARG(10) TYPE C,
         MATNR     TYPE MATNR,
         QTY(15)   TYPE C,
         STAT(1)   TYPE C,
         EBELN(10) TYPE C,
       END OF UPD2.

TYPES: BEGIN OF UPD12,
         STYPE(6)  TYPE C,
         CHARG(10) TYPE C,
         QTY(15)   TYPE C,
         MATNR     TYPE MATNR,
         XBLNR     TYPE XBLNR,
         BLDAT     TYPE BLDAT,

*         STAT(1)   TYPE C,
*         EBELN(10) TYPE C,
       END OF UPD12.

TYPES: BEGIN OF UPD3,
         STYPE(6)  TYPE C,
         CHARG(10) TYPE C,
         QTY(15)   TYPE C,
       END OF UPD3.

TYPES: BEGIN OF DIS1,
         STYPE(6)  TYPE C,
         CHARG(10) TYPE C,
         QTY       TYPE ZLLM-FKIMG,
       END OF DIS1.

DATA: IT_UPD1  TYPE TABLE OF UPD1,
      WA_UPD1  TYPE UPD1,
      IT_UPD2  TYPE TABLE OF UPD2,
      WA_UPD2  TYPE UPD2,
      IT_UPD3  TYPE TABLE OF UPD3,
      WA_UPD3  TYPE UPD3,
      IT_UPD4  TYPE TABLE OF UPD3,
      WA_UPD4  TYPE UPD3,
      IT_UPD5  TYPE TABLE OF UPD3,
      WA_UPD5  TYPE UPD3,
      IT_TOT1  TYPE TABLE OF UPD3,
      WA_TOT1  TYPE UPD3,
      IT_UPD11 TYPE TABLE OF UPD11,
      WA_UPD11 TYPE UPD11,
      IT_UPD12 TYPE TABLE OF UPD12,
      WA_UPD12 TYPE UPD12,
      IT_DIS1  TYPE TABLE OF DIS1,
      WA_DIS1  TYPE DIS1.
DATA: IT_ZPRODBATCHES  TYPE TABLE OF ZPRODBATCHES,
      WA_ZPRODBATCHES  TYPE ZPRODBATCHES,
      IT_ZPRODBATCHES1 TYPE TABLE OF ZPRODBATCHES,  "FOR SAMPLE
      WA_ZPRODBATCHES1 TYPE ZPRODBATCHES.
DATA: GJAHR TYPE BKPF-GJAHR.
DATA: A TYPE I,
      B TYPE I.
DATA: SQTY TYPE I.

DATA:VAR(20) TYPE C,
*       var TYPE char25 VALUE 'ght5678',
     MOFF    TYPE I,
     MLEN    TYPE I,
     ALP     TYPE CHAR10,
     NUM     TYPE CHAR10,
     LEN     TYPE I,
     OFF     TYPE I.
DATA:  MCODE LIKE MARA-MATNR.
DATA IT_TYPE   TYPE TRUXS_T_TEXT_DATA.
**************************************************

SELECTION-SCREEN BEGIN OF BLOCK MERKMALE1 WITH FRAME TITLE TEXT-001.
*parameters : lifnr like lfa1-lifnr.
PARAMETERS :
*R1  RADIOBUTTON GROUP R1  USER-COMMAND R2 DEFAULT 'X',
*             r11 radiobutton group r1,
  R12 RADIOBUTTON GROUP R1 USER-COMMAND M1 DEFAULT 'X',
  R1A RADIOBUTTON GROUP R1,
*  R2  RADIOBUTTON GROUP R1,
  R2A RADIOBUTTON GROUP R1,
  R3  RADIOBUTTON GROUP R1,
  R4  RADIOBUTTON GROUP R1.
*  S1  RADIOBUTTON GROUP R1,
*  S2  RADIOBUTTON GROUP R1,
*  S3  RADIOBUTTON GROUP R1.

SELECTION-SCREEN END OF BLOCK MERKMALE1 .
*
SELECTION-SCREEN BEGIN OF BLOCK MERKMALE2 WITH FRAME TITLE TEXT-002.
PARAMETERS : LIFNR LIKE LFA1-LIFNR MATCHCODE OBJECT ZTP1.
PARAMETERS : INVNO LIKE ZLLM_DSP-XBLNR,
             INVDT LIKE SY-DATUM.
SELECTION-SCREEN END OF BLOCK MERKMALE2 .

SELECTION-SCREEN BEGIN OF BLOCK MERKMALE5 WITH FRAME TITLE TEXT-004.
*PARAMETERS : P_FILE TYPE RLGRAP-FILENAME.
PARAMETERS : E_FILE TYPE RLGRAP-FILENAME.
SELECTION-SCREEN END OF BLOCK MERKMALE5 .

SELECTION-SCREEN BEGIN OF BLOCK MERKMALE6 WITH FRAME TITLE TEXT-010.
PARAMETERS : D_FILE TYPE RLGRAP-FILENAME.
SELECTION-SCREEN END OF BLOCK MERKMALE6.




*SELECTION-SCREEN BEGIN OF BLOCK MERKMALE3 WITH FRAME TITLE TEXT-003.
*SELECT-OPTIONS : MATNR FOR MARA-MATNR,
*CHARG FOR MCHA-CHARG,
*VENDOR FOR MCHA-LIFNR MATCHCODE OBJECT ZTP1.
*SELECTION-SCREEN END OF BLOCK MERKMALE3 .
*
*SELECTION-SCREEN BEGIN OF BLOCK MERKMALE4 WITH FRAME TITLE TEXT-003.
*PARAMETERS : BAT   LIKE MCHA-CHARG.
*PARAMETERS : STYPE(6) TYPE C DEFAULT 'SALE' MATCHCODE OBJECT ZTP2.
*SELECTION-SCREEN END OF BLOCK MERKMALE4.
AT SELECTION-SCREEN ON VALUE-REQUEST FOR E_FILE.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      PROGRAM_NAME  = SYST-CPROG
      DYNPRO_NUMBER = SYST-DYNNR
      FIELD_NAME    = ' '
    IMPORTING
      FILE_NAME     = E_FILE.





AT SELECTION-SCREEN ON VALUE-REQUEST FOR D_FILE.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      PROGRAM_NAME  = SYST-CPROG
      DYNPRO_NUMBER = SYST-DYNNR
      FIELD_NAME    = 'D_FILE'
    IMPORTING
      FILE_NAME     = D_FILE.



AT SELECTION-SCREEN OUTPUT.

  IF R12 EQ 'X'.

    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*LIFNR*'.
        SCREEN-ACTIVE = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*E_FILE*'.
        SCREEN-ACTIVE = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.


    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*D_FILE*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*INVNO*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*INVDT*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.

  ELSEIF R2A EQ 'X'.

    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*LIFNR*'.
        SCREEN-ACTIVE = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*D_FILE*'.
        SCREEN-ACTIVE = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.


    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*E_FILE*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*INVNO*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*INVDT*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.

  ELSEIF R1A EQ 'X'.



    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*LIFNR*'.
        SCREEN-ACTIVE = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*D_FILE*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.

    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*E_FILE*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*INVNO*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*INVDT*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.

  ELSEIF R4 EQ 'X'.
    CALL TRANSACTION 'ZTP_REPORT'.

    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*LIFNR*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.

    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*MATNR*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*CHARG*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*VENDOR*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*STYPE*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*BAT*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*E_FILE*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*D_FILE*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.

    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*INVNO*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*INVDT*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.

  ELSE.

    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*MATNR*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*CHARG*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*VENDOR*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*STYPE*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*BAT*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*E_FILE*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*D_FILE*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.

    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*INVNO*'.
        SCREEN-ACTIVE = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*INVDT*'.
        SCREEN-ACTIVE = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.

  ENDIF.


*    if r11 eq 'X'.
*      loop at screen.
*        if screen-name cp '*P_FILE*'.
*          screen-active = 1.
*          modify screen.
*        endif.
*      endloop.
*      loop at screen.
*        if screen-name cp '*E_FILE*'.
*          screen-active = 0.
*          modify screen.
*        endif.
*      endloop.

*    IF R2A EQ 'X'.
*
*      LOOP AT SCREEN.
*        IF SCREEN-NAME CP '*P_FILE*'.
*          SCREEN-ACTIVE = 0.
*          MODIFY SCREEN.
*        ENDIF.
*      ENDLOOP.
*      LOOP AT SCREEN.
*        IF SCREEN-NAME CP '*E_FILE*'.
*          SCREEN-ACTIVE = 0.
*          MODIFY SCREEN.
*        ENDIF.
*      ENDLOOP.
*      LOOP AT SCREEN.
*        IF SCREEN-NAME CP '*D_FILE*'.
*          SCREEN-ACTIVE = 1.
*          MODIFY SCREEN.
*        ENDIF.
*      ENDLOOP.
*
*
*
*
*
*    ELSEIF R12 EQ 'X'.
*
*      LOOP AT SCREEN.
*        IF SCREEN-NAME CP '*P_FILE*'.
*          SCREEN-ACTIVE = 0.
*          MODIFY SCREEN.
*        ENDIF.
*      ENDLOOP.
*      LOOP AT SCREEN.
*        IF SCREEN-NAME CP '*E_FILE*'.
*          SCREEN-ACTIVE = 1.
*          MODIFY SCREEN.
*        ENDIF.
*      ENDLOOP.
*      LOOP AT SCREEN.
*        IF SCREEN-NAME CP '*D_FILE*'.
*          SCREEN-ACTIVE = 0.
*          MODIFY SCREEN.
*        ENDIF.
*      ENDLOOP.
*
*    ELSE.
*      LOOP AT SCREEN.
*        IF SCREEN-NAME CP '*P_FILE*'.
*          SCREEN-ACTIVE = 0.
*          MODIFY SCREEN.
*        ENDIF.
*      ENDLOOP.
*      LOOP AT SCREEN.
*        IF SCREEN-NAME CP '*E_FILE*'.
*          SCREEN-ACTIVE = 0.
*          MODIFY SCREEN.
*        ENDIF.
*      ENDLOOP.
*      LOOP AT SCREEN.
*        IF SCREEN-NAME CP '*D_FILE*'.
*          SCREEN-ACTIVE = 0.
*          MODIFY SCREEN.
*        ENDIF.
*      ENDLOOP.
*    ENDIF.
*
*  ELSEIF S1 EQ 'X' OR S2 EQ 'X' OR S3 EQ 'X'.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*LIFNR*'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*MATNR*'.
*        SCREEN-ACTIVE = 1.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*CHARG*'.
*        SCREEN-ACTIVE = 1.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*VENDOR*'.
*        SCREEN-ACTIVE = 1.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*STYPE*'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*BAT*'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*P_FILE*'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*E_FILE*'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*D_FILE*'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*
*  ELSEIF R3 EQ 'X'.
*
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*LIFNR*'.
*        SCREEN-ACTIVE = 1.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*MATNR*'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*CHARG*'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*VENDOR*'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*STYPE*'.
*        SCREEN-ACTIVE = 1.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*BAT*'.
*        SCREEN-ACTIVE = 1.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*P_FILE*'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*E_FILE*'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*D_FILE*'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*
*  ENDIF.

  SELECT SINGLE * FROM USR05 WHERE BNAME = SY-UNAME AND PARID EQ 'KD0'.
  IF SY-SUBRC EQ 0.
    LIFNR = USR05-PARVA.
  ENDIF.

  IF SY-UNAME EQ 'PPBOM03'.

  ELSE.
    LOOP AT SCREEN.
      IF SCREEN-NAME = 'LIFNR'.
        SCREEN-INPUT = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.


  SELECT SINGLE * FROM USR05 WHERE BNAME = SY-UNAME AND PARID EQ '3000'.
*    'ZPLANT'.
  IF SY-SUBRC EQ 0.
    PLANT = USR05-PARVA.
  ENDIF.
  PERFORM AUTHORIZATION.

*  loop at screen.
*    if screen-name = 'KUNRG'.
*      screen-input = 0.
*      modify screen.
*    endif.
*  endloop.
*
*  loop at screen.
*    if screen-name = 'FKART'.
*      screen-input = 0.
*      modify screen.
*    endif.
*  endloop.



*AT SELECTION-SCREEN ON VALUE-REQUEST FOR E_FILE.
*  CALL FUNCTION 'F4_FILENAME'
*    EXPORTING
*      PROGRAM_NAME  = SYST-CPROG
*      DYNPRO_NUMBER = SYST-DYNNR
*      FIELD_NAME    = ' '
*    IMPORTING
*      FILE_NAME     = E_FILE.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR D_FILE.
*  CALL FUNCTION 'F4_FILENAME'
*    EXPORTING
*      PROGRAM_NAME  = SYST-CPROG
*      DYNPRO_NUMBER = SYST-DYNNR
*      FIELD_NAME    = ' '
*    IMPORTING
*      FILE_NAME     = D_FILE.
*

INITIALIZATION.
  G_REPID = SY-REPID.

START-OF-SELECTION.

  UNPACK LIFNR TO LIFNR.  "25.10.24
  CLEAR : IT_FCAT,IT_TAB1,WA_TAB1,IT_DISP1,WA_DISP1.

*BREAK-POINT.
*  IF R1 EQ 'X'.  "create
*    IF LIFNR IS INITIAL.
*      MESSAGE 'enter VENDOR CODE' TYPE 'I'.
*      EXIT.
*    ENDIF.
*
*    PERFORM FORM1.
*  ELSE
  IF R12 EQ 'X'.
    IF LIFNR IS INITIAL.
      MESSAGE 'enter VENDOR CODE' TYPE 'I'.
      EXIT.
    ENDIF.
    PERFORM FORM11.
  ELSEIF R1A EQ 'X'.
    IF LIFNR IS INITIAL.
      MESSAGE 'enter VENDOR CODE' TYPE 'I'.
      EXIT.
    ENDIF.

    PERFORM CHANGESTAT.
*  ELSEIF R2 EQ 'X'. "dispatch
*    IF LIFNR IS INITIAL.
*      MESSAGE 'enter VENDOR CODE' TYPE 'I'.
*      EXIT.
*    ENDIF.
*    PERFORM MODIFY.
  ELSEIF R2A EQ 'X'. "dispatch UPLOAD
    IF LIFNR IS INITIAL.
      MESSAGE 'enter VENDOR CODE' TYPE 'I'.
      EXIT.
    ENDIF.
    PERFORM UPDDISP.
*  ELSEIF S1 EQ 'X' OR S2 EQ 'X'.
*    PERFORM CURRSTK.
*  ELSEIF S3 EQ 'X'.
*    PERFORM LLMDISPATCH.
  ELSEIF R3 EQ 'X'.  "ATTACHMENT
    IF LIFNR IS INITIAL.
      MESSAGE 'enter VENDOR CODE' TYPE 'I'.
      EXIT.
    ENDIF.
*    IF BAT IS INITIAL.
*      MESSAGE 'ENTER Batch No.' TYPE 'I'.
*      EXIT.
*    ENDIF.
*    IF STYPE IS INITIAL.
*      MESSAGE 'Select Product Type' TYPE 'I'.
*      EXIT.
*    ENDIF.
    PERFORM ATTACH.
  ELSEIF R4 EQ 'X'.
    CALL TRANSACTION 'ZTP_REPORT'.
  ENDIF.

*&---------------------------------------------------------------------*
*&      Module  STATUS_9001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_9001 OUTPUT.
  SET PF-STATUS 'STATUS'.
  SET TITLEBAR 'CREATE'.
  PERFORM DATA1.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  DATA1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DATA1 .
*  BREAK-POINT.
  CREATE OBJECT GR_ALVGRID
    EXPORTING
*     i_parent          = gr_ccontainer
      I_PARENT          = CL_GUI_CUSTOM_CONTAINER=>SCREEN0
    EXCEPTIONS
      ERROR_CNTL_CREATE = 1
      ERROR_CNTL_INIT   = 2
      ERROR_CNTL_LINK   = 3
      ERROR_DP_CREATE   = 4
      OTHERS            = 5.
  IF SY-SUBRC <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


  PERFORM ALV_BUILD_FIELDCAT.
  PERFORM DROPDOWN_TABLE.


  CALL METHOD GR_ALVGRID->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_BUFFER_ACTIVE =
*     I_BYPASSING_BUFFER            =
*     I_CONSISTENCY_CHECK           =
*     I_STRUCTURE_NAME              =
      IS_VARIANT      = VARIANT
      I_SAVE          = 'A'
*     I_DEFAULT       = 'X'
      IS_LAYOUT       = GS_LAYO
*     IS_PRINT        =
*     IT_SPECIAL_GROUPS             =
*     IT_TOOLBAR_EXCLUDING          =
*     IT_HYPERLINK    =
*     IT_ALV_GRAPHICS =
*     IT_EXCEPT_QINFO =
*     IR_SALV_ADAPTER =
    CHANGING
      IT_OUTTAB       = IT_TAB1
      IT_FIELDCATALOG = IT_FCAT
*     IT_SORT         =
*     IT_FILTER       =
*      EXCEPTIONS
*     INVALID_PARAMETER_COMBINATION = 1
*     PROGRAM_ERROR   = 2
*     TOO_MANY_LINES  = 3
*     others          = 4
    .
  IF SY-SUBRC <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ALV_BUILD_FIELDCAT .

**  *Build the field catalogue
*  call function 'LVC_FIELDCATALOG_MERGE'
*    exporting
*      i_structure_name = 'ZLLM'
**     I_STRUCTURE_NAME = 'ITAB1'
*    changing
**     IT_outtab        = it_tab1
*      ct_fieldcat      = it_fcat.
*
*  data lv_fldcat type lvc_s_fcat.
*
**LOOP AT IT_FCAT INTO lv_fldcat.
*  CASE LS_FCAT-FIELDNAME.

  LV_FLDCAT-FIELDNAME = 'MATNR'.
*  LV_FLDCAT-TABNAME   = 'IT_TAB1'.
  LV_FLDCAT-SCRTEXT_M = 'MATERIAL CODE'.
  LV_FLDCAT-EDIT   = 'X'.
  LV_FLDCAT-F4AVAILABL = 'X'.
  LV_FLDCAT-REF_TABLE = 'MARA'.
  LV_FLDCAT-REF_FIELD = 'MATNR'.
  LV_FLDCAT-OUTPUTLEN = 10.

  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'CHARG'.
*  LV_FLDCAT-TABNAME   = 'IT_TAB1'.
  LV_FLDCAT-SCRTEXT_M = 'BATCH'.
  LV_FLDCAT-EDIT   = 'X'.
*  lv_fldcat-f4availabl = 'X'.
*  lv_fldcat-ref_table = 'VBRP'.
*  lv_fldcat-ref_field = 'CHARG'.
  LV_FLDCAT-OUTPUTLEN = 10.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'EBELN'.
*  LV_FLDCAT-TABNAME   = 'IT_TAB1'.
  LV_FLDCAT-SCRTEXT_M = 'PURCHASE ORDER NO.'.
  LV_FLDCAT-EDIT   = 'X'.
*  lv_fldcat-f4availabl = 'X'.
*  lv_fldcat-ref_table = 'VBRP'.
*  lv_fldcat-ref_field = 'CHARG'.
  LV_FLDCAT-OUTPUTLEN = 10.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'FKIMG'.
  LV_FLDCAT-SCRTEXT_M = 'QUANTITY'.
  LV_FLDCAT-EDIT   = 'X'.
  LV_FLDCAT-OUTPUTLEN = 10.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'STATUS'.
  LV_FLDCAT-SCRTEXT_M = 'STATUS'.
*  lv_fldcat-edit   = 'X'.
  LV_FLDCAT-OUTPUTLEN = 10.
*  lv_fldcat-drdn_hndl = '3'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LOOP AT IT_FCAT INTO LV_FLDCAT.

*    if    lv_fldcat-fieldname eq 'STATUS'.
*  loop at it_fcat into lv_fldcat.
    CASE LV_FLDCAT-FIELDNAME.
      WHEN 'STATUS'.
        LV_FLDCAT-FIELDNAME = 'STATUS'.
        LV_FLDCAT-SCRTEXT_M = 'STATUS'.
        LV_FLDCAT-EDIT   = 'X'.
        LV_FLDCAT-OUTPUTLEN = 10.
        LV_FLDCAT-DRDN_HNDL = '3'.

        MODIFY IT_FCAT FROM LV_FLDCAT.
        CLEAR LV_FLDCAT.

*      if 1 eq 2.
*        ls_fcat-drdn_alias = abap_true.
*      endif.
*      ls_fcat-checktable = '!'.        "do not check foreign keys
*        modify it_fcat from lv_fldcat.
*      endif.
    ENDCASE.
  ENDLOOP.

  LV_FLDCAT-FIELDNAME = 'REMARK'.
  LV_FLDCAT-SCRTEXT_M = 'REMARK IF ANY'.
  LV_FLDCAT-EDIT   = 'X'.
  LV_FLDCAT-OUTPUTLEN = 100.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_9001 INPUT.
  GR_ALVGRID->CHECK_CHANGED_DATA( ).
  CASE OK_CODE.
    WHEN 'SAVE'.
*      break-point.
      GR_ALVGRID->CHECK_CHANGED_DATA( ).
      PERFORM DATAUPD.
*      message 'SAVE' type 'I'.
*      leave to screen 0.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
  ENDCASE.
  CLEAR: OK_CODE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  DATAUPD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DATAUPD .
*  perform sale.
*  perform newsale.
  PERFORM CRCHK1.

  DATE2 = SY-DATUM.
  DATE2+4(2) = '01'.
*  break-point.
*CLEAR : e1.
  LOOP AT IT_TAB1 INTO WA_TAB1 WHERE FKIMG GT 0.
    READ TABLE IT_MCHA INTO WA_MCHA WITH KEY MATNR = WA_TAB1-MATNR CHARG = WA_TAB1-CHARG.
    IF SY-SUBRC EQ 0.
      E = 1.
      MESSAGE E963(ZHR_MESSAGE) WITH WA_TAB1-CHARG.
      EXIT.
    ENDIF.
    CLEAR : PO1.
    SELECT SINGLE * FROM EKKO WHERE EBELN EQ WA_TAB1-EBELN AND LIFNR EQ WA_TAB1-LIFNR.
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM EKPO WHERE MATNR EQ WA_TAB1-MATNR AND ELIKZ EQ SPACE.
      IF SY-SUBRC EQ 0.
        PO1 = 1.
      ENDIF.
    ENDIF.
    IF PO1 NE 1.
      MESSAGE 'CHECK PURCHASE ORDER NO.' TYPE 'I'.
    ENDIF.
  ENDLOOP.
*    read table it_vbrp into wa_vbrp with key charg = wa_tab1-charg.
*    if sy-subrc eq 4.
*      read table it_vbrp1 into wa_vbrp1 with key charg = wa_tab1-charg.
*      if sy-subrc eq 4.
*        e = 1.
*        message e962(zhr_message) with wa_tab1-charg.
**        message 'INVALID MATERIAL CODE & BATCH' type 'E'.
**           message i962(zhr_message) with wa_tab1-charg.
*        exit.
*      endif.
*    endif.
**    if e1 eq 1.
**      EXIT.
**    ENDIF.
*  endloop.


  COUNT1 = 1.

  IF E NE 1.

*    IF R1 EQ 'X'.
*      COUNT1 = 1.
*      LOOP AT IT_TAB1 INTO WA_TAB1 WHERE FKIMG GT 0.
*        ZLLM_WA-MATNR = WA_TAB1-MATNR.
*        ZLLM_WA-CHARG = WA_TAB1-CHARG.
*        ZLLM_WA-FKIMG = WA_TAB1-FKIMG.
*        ZLLM_WA-LIFNR = WA_TAB1-LIFNR.
*        ZLLM_WA-EBELN = WA_TAB1-EBELN.
*
*        IF WA_TAB1-STATUS EQ 'Q - UNDER TEST'.
*          ZLLM_WA-STATUS = 'Q'.
*        ELSE.
*          ZLLM_WA-STATUS = 'R'.
*        ENDIF.
*
*        ZLLM_WA-REMARK = WA_TAB1-REMARK.
*        ZLLM_WA-UNAME = SY-UNAME.
*        ZLLM_WA-CPUDT = SY-DATUM.
*        ZLLM_WA-CPUTM = SY-UZEIT.
*        MODIFY ZLLM FROM ZLLM_WA.
*        COMMIT WORK AND WAIT.
*        CLEAR ZLLM_WA.
*        COUNT1 = COUNT1 + 1.
*      ENDLOOP.
*      IF SY-SUBRC EQ 0.
*        MESSAGE 'SAVE DATA' TYPE 'I'.
*      ENDIF.
*      CLEAR : IT_TAB1,WA_TAB1,IT_TAB2,WA_TAB2.
*      LEAVE TO SCREEN 0.
*    ENDIF.
*

  ENDIF.




*  leave to screen 0.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SALE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*form sale .
*  sdate1 = sy-datum - 360.
*
*
*  select * from vbrk into table it_vbrk where fkart in ('ZCDF','ZBDF') and fkdat ge sdate1 and kunrg eq kunrg and fksto ne 'X'.
*  if sy-subrc eq 0.
*    select * from vbrp into table it_vbrp for all entries in it_vbrk where vbeln eq it_vbrk-vbeln.
*  endif.
*  delete it_vbrp where fkimg eq 0.
*  delete it_vbrp where netwr  le 0.
*  loop at it_vbrp into wa_vbrp.
*    select single * from mara where matnr eq wa_vbrp-matnr and mtart in ('ZFRT','ZHWA').
*    if sy-subrc eq 4.
*      delete it_vbrp where matnr eq wa_vbrp-matnr.
*    endif.
*  endloop.
*  sort it_vbrk descending by fkdat.
*  sort it_vbrp descending by vbeln.
*
*  select * from vbrk into table it_vbrk1 where fkart in ('ZSTO','ZSTI') and fkdat ge sdate1 and regio eq 'PB' and fksto ne 'X'.
*  if sy-subrc eq 0.
*    select * from vbrp into table it_vbrp1 for all entries in it_vbrk1 where vbeln eq it_vbrk1-vbeln.
*  endif.
*  delete it_vbrp1 where fkimg eq 0.
*  delete it_vbrp1 where netwr  le 0.
*  loop at it_vbrp1 into wa_vbrp1.
*    select single * from mara where matnr eq wa_vbrp1-matnr and mtart in ('ZFRT','ZHWA').
*    if sy-subrc eq 4.
*      delete it_vbrp1 where matnr eq wa_vbrp1-matnr.
*    endif.
*  endloop.
*  sort it_vbrk1 descending by fkdat.
*  sort it_vbrp1 descending by vbeln.
*******************************************
*
*
*endform.
*&---------------------------------------------------------------------*
*&      Form  FORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FORM1 .
*   perform sale.


*  IF R1 EQ 'X'.
*    IF LIFNR IS INITIAL.
*      MESSAGE 'ENTER third party vendor code' TYPE 'E'.
*    ENDIF.
*  ENDIF.

  COUNT = 1.
  DO 100 TIMES.
    WA_TAB1-LIFNR = LIFNR.
    SELECT SINGLE * FROM LFA1  WHERE LIFNR EQ LIFNR.
    IF SY-SUBRC EQ 0.
      WA_TAB1-NAME1 = LFA1-NAME1.
    ENDIF.
    WA_TAB1-MATNR = SPACE.
    WA_TAB1-CHARG = SPACE.
    WA_TAB1-FKIMG = SPACE.
    WA_TAB1-EBELN = SPACE.
*    WA_TAB1-STATUS = 'Q - Under Test'.
    WA_TAB1-STATUS = 'R - RELEASED'.
*    wa_tab1-status = space.

    WA_TAB1-REMARK = SPACE.
    WA_TAB1-BUZEI = COUNT.
    COLLECT WA_TAB1 INTO IT_TAB1.
    CLEAR WA_TAB1.
    COUNT = COUNT + 1.
  ENDDO.

  CALL SCREEN 9001.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FORM2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  STATUS_9002  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*module status_9002 output.
*  set pf-status 'STATUS1'.
*  set titlebar 'CREATE1'.
*  perform data2.
*endmodule.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9002  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*module user_command_9002 input.
*  case ok_code.
**    when 'SAVE'.
***      BREAK-POINT.
**      perform dataupd.
**      message 'SAVE' type 'I'.
**      leave to screen 0.
*    when 'BACK' or 'EXIT' or 'CANCEL'.
*      leave to screen 0.
*  endcase.
*  clear: ok_code.
*endmodule.
**&---------------------------------------------------------------------*
*&      Form  DATA2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DATA2 .
  CREATE OBJECT GR_ALVGRID
    EXPORTING
*     i_parent          = gr_ccontainer
      I_PARENT          = CL_GUI_CUSTOM_CONTAINER=>SCREEN0
    EXCEPTIONS
      ERROR_CNTL_CREATE = 1
      ERROR_CNTL_INIT   = 2
      ERROR_CNTL_LINK   = 3
      ERROR_DP_CREATE   = 4
      OTHERS            = 5.
  IF SY-SUBRC <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  PERFORM ALV_BUILD_FIELDCAT1.
  PERFORM DROPDOWN_TABLE.

  CALL METHOD GR_ALVGRID->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_BUFFER_ACTIVE =
*     I_BYPASSING_BUFFER            =
*     I_CONSISTENCY_CHECK           =
*     I_STRUCTURE_NAME              =
      IS_VARIANT      = VARIANT
      I_SAVE          = 'A'
*     I_DEFAULT       = 'X'
      IS_LAYOUT       = GS_LAYO
*     IS_PRINT        =
*     IT_SPECIAL_GROUPS             =
*     IT_TOOLBAR_EXCLUDING          =
*     IT_HYPERLINK    =
*     IT_ALV_GRAPHICS =
*     IT_EXCEPT_QINFO =
*     IR_SALV_ADAPTER =
    CHANGING
      IT_OUTTAB       = IT_DISP1
      IT_FIELDCATALOG = IT_FCAT
*     IT_SORT         =
*     IT_FILTER       =
*      EXCEPTIONS
*     INVALID_PARAMETER_COMBINATION = 1
*     PROGRAM_ERROR   = 2
*     TOO_MANY_LINES  = 3
*     others          = 4
    .
  IF SY-SUBRC <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_BUILD_FIELDCAT1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ALV_BUILD_FIELDCAT1 .

  IF R3 EQ 'X'.
    LV_FLDCAT-FIELDNAME = 'DOC'.
*  LV_FLDCAT-TABNAME   = 'IT_TAB1'.
    LV_FLDCAT-SCRTEXT_M = 'MATERIAL BATCH KEY'.
*  lv_fldcat-edit   = 'X'.
*  lv_fldcat-f4availabl = 'X'.
*  lv_fldcat-ref_table = 'MARA'.
*  lv_fldcat-ref_field = 'MATNR'.
    LV_FLDCAT-OUTPUTLEN = 30.

    APPEND LV_FLDCAT TO IT_FCAT.
    CLEAR LV_FLDCAT.
  ENDIF.

  LV_FLDCAT-FIELDNAME = 'EBELN'.
*  LV_FLDCAT-TABNAME   = 'IT_TAB1'.
  LV_FLDCAT-SCRTEXT_M = 'PO NO.'.
*  lv_fldcat-edit   = 'X'.
*  LV_FLDCAT-F4AVAILABL = 'X'.
*  LV_FLDCAT-REF_TABLE = 'MARA'.
*  LV_FLDCAT-REF_FIELD = 'MATNR'.
  LV_FLDCAT-OUTPUTLEN = 10.

  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.


  LV_FLDCAT-FIELDNAME = 'MATNR'.
*  LV_FLDCAT-TABNAME   = 'IT_TAB1'.
  LV_FLDCAT-SCRTEXT_M = 'MATERIAL CODE'.
*  lv_fldcat-edit   = 'X'.
  LV_FLDCAT-F4AVAILABL = 'X'.
  LV_FLDCAT-REF_TABLE = 'MARA'.
  LV_FLDCAT-REF_FIELD = 'MATNR'.
  LV_FLDCAT-OUTPUTLEN = 10.

  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'CHARG'.
*  LV_FLDCAT-TABNAME   = 'IT_TAB1'.
  LV_FLDCAT-SCRTEXT_M = 'BATCH'.
*  lv_fldcat-edit   = 'X'.
*  lv_fldcat-f4availabl = 'X'.
*  lv_fldcat-ref_table = 'VBRP'.
*  lv_fldcat-ref_field = 'CHARG'.
  LV_FLDCAT-OUTPUTLEN = 10.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'FKIMG'.
  LV_FLDCAT-SCRTEXT_M = 'ORIGINAL QTY'.
*  lv_fldcat-edit   = 'X'.
  LV_FLDCAT-OUTPUTLEN = 10.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'DISP_QTY'.
  LV_FLDCAT-SCRTEXT_M = 'ALREADY DISPATCHED QTY'.
*  lv_fldcat-edit   = 'X'.
  LV_FLDCAT-OUTPUTLEN = 10.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'QTY'.
  LV_FLDCAT-SCRTEXT_M = 'DISPATCH QTY'.
  LV_FLDCAT-EDIT   = 'X'.
  LV_FLDCAT-OUTPUTLEN = 10.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'STATUS'.
  LV_FLDCAT-SCRTEXT_M = 'STATUS'.
*  lv_fldcat-edit   = 'X'.
  LV_FLDCAT-OUTPUTLEN = 10.
*  lv_fldcat-drdn_hndl = '3'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.


  LV_FLDCAT-FIELDNAME = 'QAREMARK'.
  LV_FLDCAT-SCRTEXT_M = 'QA REMARK'.
*  lv_fldcat-edit   = 'X'.
*  lv_fldcat-outputlen = 100.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'CHGDT'.
  LV_FLDCAT-SCRTEXT_M = 'RELEASE DATE'.
*  lv_fldcat-outputlen = 100.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'CHGTM'.
  LV_FLDCAT-SCRTEXT_M = 'RELEASE TIME'.
*  lv_fldcat-outputlen = 100.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'REMARK'.
  LV_FLDCAT-SCRTEXT_M = 'ENTER REMARK IF ANY'.
  LV_FLDCAT-EDIT   = 'X'.
  LV_FLDCAT-OUTPUTLEN = 100.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.



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
*SELECT WERKS NAME1 FROM T001W INTO TABLE ITAB_T001W WHERE WERKS IN PLANT.
*
*  LOOP AT ITAB_T001W INTO WA_T001W.
  AUTHORITY-CHECK OBJECT 'M_BCO_WERK' ID 'WERKS' FIELD PLANT.
  IF SY-SUBRC <> 0.
    CONCATENATE 'No authorization for Plant' PLANT INTO MSG
    SEPARATED BY SPACE.
    MESSAGE MSG TYPE 'E'.
  ENDIF.
*  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MODIFY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM MODIFY.
*  CLEAR : IT_ZLLM, WA_ZLLM.
*  SELECT * FROM ZLLM INTO TABLE IT_ZLLM WHERE LIFNR EQ LIFNR AND STATUS EQ 'R'.
*  IF SY-SUBRC EQ 4.
*    MESSAGE'NO DATA FOUND' TYPE 'E'.
*  ENDIF.
*  IF IT_ZLLM IS NOT INITIAL.
*    SELECT * FROM ZLLM_DSP INTO TABLE IT_ZLLM_DSP FOR ALL ENTRIES IN IT_ZLLM WHERE MATNR EQ IT_ZLLM-MATNR AND CHARG EQ IT_ZLLM-CHARG AND LIFNR EQ
*    IT_ZLLM-LIFNR.
*  ENDIF.
*
*  LOOP AT IT_ZLLM_DSP INTO WA_ZLLM_DSP.
*    READ TABLE IT_ZLLM INTO WA_ZLLM WITH KEY MATNR = WA_ZLLM_DSP-MATNR CHARG = WA_ZLLM_DSP-CHARG LIFNR = WA_ZLLM_DSP-LIFNR.
*    IF SY-SUBRC EQ 0.
*      WA_DSP1-EBELN = WA_ZLLM-EBELN.
*      WA_DSP1-MATNR = WA_ZLLM_DSP-MATNR.
*      WA_DSP1-CHARG = WA_ZLLM_DSP-CHARG.
*      WA_DSP1-LIFNR = WA_ZLLM_DSP-LIFNR.
*      WA_DSP1-DISP_QTY = WA_ZLLM_DSP-FKIMG.
*      COLLECT WA_DSP1 INTO IT_DSP1.
*      CLEAR WA_DSP1.
*    ENDIF.
*  ENDLOOP.
*
*  COUNT1 = 1.
*  LOOP AT IT_ZLLM INTO WA_ZLLM.
*    WA_DISP1-EBELN = WA_ZLLM-EBELN.
*    WA_DISP1-LIFNR = WA_ZLLM-LIFNR.
*    SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_ZLLM-LIFNR.
*    IF SY-SUBRC EQ 0.
*      WA_DISP1-NAME1 = LFA1-NAME1.
*    ENDIF.
**    wa_disp1-buzei = count1.
*    WA_DISP1-MATNR = WA_ZLLM-MATNR.
*    WA_DISP1-MATNR1 = WA_ZLLM-MATNR.
*    WA_DISP1-CHARG = WA_ZLLM-CHARG.
*    IF WA_ZLLM-STATUS EQ 'R'.
*      WA_DISP1-STATUS = 'RELEASED'.
*    ENDIF.
*    SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_ZLLM-MATNR.
*    IF SY-SUBRC EQ 0.
*      WA_DISP1-MAKTX = MAKT-MAKTX.
*    ENDIF.
*    WA_DISP1-FKIMG = WA_ZLLM-FKIMG.
*    WA_DISP1-FKIMG1 = WA_ZLLM-FKIMG.
*    READ TABLE IT_DSP1 INTO WA_DSP1 WITH KEY MATNR = WA_ZLLM-MATNR CHARG = WA_ZLLM-CHARG LIFNR = WA_ZLLM-LIFNR.
*    IF SY-SUBRC EQ 0.
*      WA_DISP1-DISP_QTY = WA_DSP1-DISP_QTY.
*      WA_DISP1-DISP_QTY1 = WA_DSP1-DISP_QTY.
*    ENDIF.
*    CONDENSE : WA_DISP1-FKIMG, WA_DISP1-DISP_QTY.
*    WA_DISP1-QAREMARK = WA_ZLLM-QAREMARK.
*    WA_DISP1-CHGDT = WA_ZLLM-CHGDT.
*    WA_DISP1-CHGTM = WA_ZLLM-CHGTM.
**    clear : doc1.
**    concatenate wa_zllm-matnr '_' wa_zllm-charg into doc1.
**    wa_disp1-doc = doc1.
*    COLLECT WA_DISP1 INTO IT_DISP1.
*    CLEAR WA_DISP1.
**    count1 = count1 + 1.
*  ENDLOOP.
**  break-point .
*  LOOP AT IT_DISP1 INTO WA_DISP1.
*    IF WA_DISP1-DISP_QTY1 GE WA_DISP1-FKIMG1.
**      write : / wa_disp1-disp_qty, wa_disp1-fkimg.
*      DELETE IT_DISP1 WHERE CHARG = WA_DISP1-CHARG AND MATNR EQ  WA_DISP1-MATNR AND LIFNR EQ WA_DISP1-LIFNR.
*    ENDIF.
*  ENDLOOP.
*
**  break-point.
*
*  SORT IT_DISP1 BY MAKTX CHARG.
*  LOOP AT IT_DISP1 INTO WA_DISP1.
*    PACK WA_DISP1-MATNR1 TO WA_DISP1-MATNR1.
*    MODIFY IT_DISP1 FROM WA_DISP1 TRANSPORTING MATNR1.
*    CLEAR WA_DISP1.
*  ENDLOOP.
*
*  CALL SCREEN 9002.
*
*
**  wa_fieldcat1-fieldname = 'MATNR1'.
**  wa_fieldcat1-seltext_l = 'PRODUCT CODE'.
**  append wa_fieldcat1 to fieldcat1.
**  clear : wa_fieldcat1.
**
**  wa_fieldcat1-fieldname = 'MAKTX'.
**  wa_fieldcat1-seltext_l = 'PRODUCT NAME'.
**  append wa_fieldcat1 to fieldcat1.
**  clear : wa_fieldcat1.
**
**  wa_fieldcat1-fieldname = 'CHARG'.
**  wa_fieldcat1-seltext_l = 'BATCH'.
**  append wa_fieldcat1 to fieldcat1.
**  clear : wa_fieldcat1.
**
**  wa_fieldcat1-fieldname = 'FKIMG'.
**  wa_fieldcat1-seltext_l = 'QTY'.
**  wa_fieldcat1-edit = 'X'.
**  append wa_fieldcat1 to fieldcat1.
**  clear : wa_fieldcat1.
**
**
**  wa_fieldcat1-fieldname = 'NAME1'.
**  wa_fieldcat1-seltext_l = 'VENDOR NAME'.
***  wa_fieldcat1-edit = 'X'.
**  append wa_fieldcat1 to fieldcat1.
**  clear : wa_fieldcat1.
**
**  wa_fieldcat1-fieldname = 'STATUS'.
**  wa_fieldcat1-seltext_l = 'STATUS'.
**  wa_fieldcat1-edit = 'X'.
**  wa_fieldcat1-ref_tabname = 'ZLLM_STAT'.
**  wa_fieldcat1-ref_fieldname = 'STATUS'.
**  append wa_fieldcat1 to fieldcat1.
**  clear : wa_fieldcat1.
**
**
**  l_glay-edt_cll_cb = 'X'.
**
***  ls_layout-colwidth_optimize = 'X'.
**
***  wa_fieldcat1-fieldname = 'CHK'.
***  wa_fieldcat1-seltext_l = 'SELECT'.
***  wa_fieldcat1-checkbox = 'X'.
***  wa_fieldcat1-edit = 'X'.
***  APPEND wa_fieldcat1 TO fieldcat1.
***  CLEAR wa_fieldcat1.
**
**
**
**  layout-zebra = 'X'.
**  layout-colwidth_optimize = 'X'.
**  layout-window_titlebar  = 'THIRD PARTY STOCK ENTRY'.
**
**
**  call function 'REUSE_ALV_GRID_DISPLAY'
**    exporting
***     I_INTERFACE_CHECK       = ' '
***     I_BYPASSING_BUFFER      = ' '
***     I_BUFFER_ACTIVE         = ' '
**      i_callback_program      = g_repid
***     I_CALLBACK_PF_STATUS_SET          = 'STATUS'
**      i_callback_user_command = 'USER_COMM1'
**      i_callback_top_of_page  = 'TOP1'
***     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
***     I_CALLBACK_HTML_END_OF_LIST       = ' '
***     I_STRUCTURE_NAME        =
***     I_BACKGROUND_ID         = ' '
***     I_GRID_TITLE            =
***     I_GRID_SETTINGS         = L_GLAY
**      is_layout               = layout1
**      it_fieldcat             = fieldcat1
***     IT_EXCLUDING            =
***     IT_SPECIAL_GROUPS       =
***     IT_SORT                 =
***     IT_FILTER               =
***     IS_SEL_HIDE             =
***     I_DEFAULT               = 'X'
**      i_save                  = 'A'
***     IS_VARIANT              =
***     IT_EVENTS               =
***     IT_EVENT_EXIT           =
***     IS_PRINT                =
***     IS_REPREP_ID            =
***     I_SCREEN_START_COLUMN   = 0
***     I_SCREEN_START_LINE     = 0
***     I_SCREEN_END_COLUMN     = 0
***     I_SCREEN_END_LINE       = 0
***     I_HTML_HEIGHT_TOP       = 0
***     I_HTML_HEIGHT_END       = 0
***     IT_ALV_GRAPHICS         =
***     IT_HYPERLINK            =
***     IT_ADD_FIELDCAT         =
***     IT_EXCEPT_QINFO         =
***     IR_SALV_FULLSCREEN_ADAPTER        =
*** IMPORTING
***     E_EXIT_CAUSED_BY_CALLER =
***     ES_EXIT_CAUSED_BY_USER  =
**    tables
**      t_outtab                = it_disp1
**    exceptions
**      program_error           = 1
**      others                  = 2.
**  if sy-subrc <> 0.
*** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
***         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
**  endif.
**
**  clear : layout1,fieldcat1.
***  call screen 9003.
*ENDFORM.

*form user_comm1 using ucomm1 like sy-ucomm selfield type slis_selfield.
**  IF R1 EQ 'X'.
*  case sy-ucomm. "SELFIELD-FIELDNAME.
**      loop at it_tab5 into wa_tab5 WHERE nsampqty ne 0 AND chk ne 'X'.
**        MESSAGE 'TICK THE CHECKBOX TO SAVE DATA' TYPE 'E'.
**      ENDLOOP.
**      BREAK-POINT.
*    when '&DATA_SAVE'(001).
**       when '&DATA_SAVE'.
*      if r11 eq 'X'.
*        perform update.
*      endif.
**      BREAK-POINT.
**      LEAVE TO SCREEN 0.
**      stop.
**      leave to transaction 'ZDISTSALE'.  "JYOTSNA
*      exit.
*
**      SET SCREEN 0.
*
**      PERFORM BDC.
*
*    when others.
*  endcase.
*
*endform.                    "USER_COMM
*
FORM TOP1.
  DATA: COMMENT    TYPE SLIS_T_LISTHEADER,
        WA_COMMENT LIKE LINE OF COMMENT.

  WA_COMMENT-TYP = 'A'.
  WA_COMMENT-INFO = 'THIRD PARTY STOCK'.
*  WA_COMMENT-INFO = P_FRMDT.
  APPEND WA_COMMENT TO COMMENT.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = COMMENT.
*     I_LOGO                   = 'ENJOYSAP_LOGO'
*     I_END_OF_LIST_GRID       =
*     I_ALV_FORM               =
  CLEAR COMMENT.
ENDFORM.                    "TOP
**&---------------------------------------------------------------------*
**&      Module  STATUS_9003  OUTPUT
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
*
**&---------------------------------------------------------------------*
**&      Form  DATAMOD
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**  -->  p1        text
**  <--  p2        text
**----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  CHK1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CHK1 .
  CLEAR : E.
*  break-point.


  DATA: FQTY  TYPE DD01V-DATATYPE.
  LOOP AT IT_DISP1 INTO WA_DISP1 WHERE CHARG NE SPACE.

    CALL FUNCTION 'NUMERIC_CHECK'
      EXPORTING
        STRING_IN = WA_DISP1-FKIMG
      IMPORTING
*       STRING_OUT       =
        HTYPE     = FQTY.

    IF FQTY <> 'NUMC'.
      E = 1.
      MESSAGE 'CHECK QTY' TYPE 'E'.
      EXIT.
*      break-point.
*      CLEAR : <fs>.
    ENDIF.
  ENDLOOP.

*  break-point.
*  loop at it_disp1 into wa_disp1 where fkimg gt 0 and charg ne space.
*    read table it_vbrp into wa_vbrp with key charg = wa_disp1-charg.
*    if sy-subrc eq 4.
*      read table it_vbrp1 into wa_vbrp1 with key charg = wa_disp1-charg.
*      if sy-subrc eq 4.
*        e = 1.
*        message e962(zhr_message) with wa_disp1-charg.
**        message 'INVALID MATERIAL CODE & BATCH' type 'E'.
*        exit.
*      endif.
*    endif.
*  endloop.

***************************************************************************************
*  break-point.
*  count1 = 1.
*  loop at it_disp1 into wa_disp1 where fkimg gt 0 and charg ne space.
*    clear : rate,val.
*    wa_disp2-kunrg = wa_disp1-kunrg.
*    if wa_disp2-kunrg eq space.
*      wa_disp2-kunrg = kunrg.
*    endif.
*    wa_disp2-kunag = wa_disp1-kunag.
*    if wa_disp2-kunag eq space.
*      wa_disp2-kunag = kunag.
*    endif.
*    wa_disp2-budat = wa_disp1-budat.
*    if wa_disp2-budat eq 0.
*      wa_disp2-budat = sy-datum.
*    endif.
*    wa_disp2-uzeit = wa_disp1-uzeit.
*    if wa_disp2-uzeit eq 0.
*      wa_disp2-uzeit = sy-uzeit.
*    endif.
*    wa_disp2-buzei = count1.
*    wa_disp2-matnr = wa_disp1-matnr.
**    wa_disp2-rate = wa_disp1-rate.
**    wa_disp2-val = wa_disp1-val.
*    clear : rate,val.
*    read table it_vbrp into wa_vbrp with key charg = wa_disp1-charg.
*    if sy-subrc eq 0.
*      rate = wa_vbrp-netwr / wa_vbrp-fkimg.
*      val = rate * wa_disp1-fkimg.
*      wa_disp2-rate = rate.
*      wa_disp2-val = val.
*      if wa_disp2-matnr eq space.
*        wa_disp2-matnr = wa_vbrp-matnr.
*      endif.
*    endif.
*    if wa_disp2-val le 0.
*      read table it_vbrp1 into wa_vbrp1 with key charg = wa_disp1-charg.
*      if sy-subrc eq 0.
*        rate = wa_vbrp1-netwr / wa_vbrp1-fkimg.
*        val = rate * wa_disp1-fkimg.
*        wa_disp2-rate = rate.
*        wa_disp2-val = val.
*        if wa_disp2-matnr eq space.
*          wa_disp2-matnr = wa_vbrp1-matnr.
*        endif.
*      endif.
*    endif.
*
*
*
**    if wa_disp2-matnr eq space.
**      read table it_vbrp1 into wa_vbrp1 with key charg = wa_disp1-charg.
**      if sy-subrc eq 0.
**        rate = wa_vbrp1-netwr / wa_vbrp1-fkimg.
**        val = rate * wa_disp1-fkimg.
**        wa_disp2-matnr = wa_vbrp1-matnr.
**        wa_disp2-rate = rate.
**        wa_disp2-val = val.
**      endif.
**    endif.
*    wa_disp2-charg = wa_disp1-charg.
*    wa_disp2-fkimg = wa_disp1-fkimg.
*    wa_disp2-fkdat = wa_disp1-fkdat.
*    if wa_disp2-fkdat eq 0.
*      wa_disp2-fkdat = sy-datum.
*    endif.
*    wa_disp2-uname = wa_disp1-uname.
*    if wa_disp2-uname eq space.
*      wa_disp2-uname = sy-uname.
*    endif.
*    collect wa_disp2 into it_disp2.
*    clear : wa_disp2.
*    count1 = count1 + 1.
*  endloop.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CRCHK1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CRCHK1 .
  CLEAR : E.
*  break-point.
  LOOP AT IT_TAB1  INTO WA_TAB1 WHERE CHARG NE SPACE.
    SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_TAB1-MATNR AND MTART IN ('ZHWA','ZDSM').
    IF SY-SUBRC EQ 4.
      MESSAGE 'CHECK PRODUCT CODE' TYPE 'E'.
    ENDIF.
    SELECT SINGLE * FROM MCHA WHERE MATNR EQ WA_TAB1-MATNR AND CHARG EQ WA_TAB1-CHARG..
    IF SY-SUBRC EQ 0.
      E = 1.
      MESSAGE 'THIS PRODUCT CODE & BATCH NO. IS ALREDY EXIST' TYPE 'E'.
    ENDIF.
    SELECT SINGLE * FROM ZLLM WHERE MATNR EQ WA_TAB1-MATNR AND CHARG EQ WA_TAB1-CHARG..
    IF SY-SUBRC EQ 0.
      E = 1.
      MESSAGE 'THIS PRODUCT CODE & BATCH NO. IS ALREDY ENTERED' TYPE 'E'.
    ENDIF.
  ENDLOOP.

  LOOP AT IT_TAB1  INTO WA_TAB1 WHERE CHARG NE SPACE.
    IF WA_TAB1-FKIMG CA SY-ABCDE.
      E = 1.
      MESSAGE E965(ZHR_MESSAGE) WITH WA_TAB1-CHARG.
      EXIT.
    ENDIF.
  ENDLOOP.



*  loop at it_tab1  into wa_tab1 where charg ne space.
*
*    call function 'NUMERIC_CHECK'
*      exporting
*        string_in = wa_tab1-fkimg
*      importing
**       STRING_OUT       =
*        htype     = fqty.
*
*    if fqty <> 'NUMC'.
*      e = 1.
*      message e965(zhr_message) with wa_tab1-charg.
**      message 'CHECK QTY' type 'E'.
*      exit.
**      break-point.
**      CLEAR : <fs>.
*    endif.
*  endloop.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  RATE1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  UPDATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM UPDATE .
*  PERFORM CRCHK2.
*
*  IF IT_DISP1 IS NOT INITIAL.
*    SELECT * FROM ZLLM_DSP INTO TABLE IT_ZLLM_DSP11 FOR ALL ENTRIES IN IT_DISP1 WHERE MATNR EQ IT_DISP1-MATNR AND CHARG EQ IT_DISP1-CHARG AND
*    LIFNR EQ IT_DISP1-LIFNR.
*  ENDIF.
*  SORT IT_ZLLM_DSP11 DESCENDING BY BUZEI.
**  BREAK-POINT.
**  delete from zllm where lifnr eq lifnr and matnr eq matnr and charg eq charg.
**  break-point .
*
*  LOOP AT IT_DISP1 INTO WA_DISP1 WHERE DISP_QTY EQ 0.
*    SELECT SINGLE * FROM ZLLM WHERE MATNR EQ WA_DISP1-MATNR AND CHARG EQ WA_DISP1-CHARG.
*    IF SY-SUBRC EQ 0.
*      IF ZLLM-STATUS NE WA_DISP1-STATUS.
*        MOVE-CORRESPONDING ZLLM TO ZLLM_WA.
*        ZLLM_WA-STATUS = WA_DISP1-STATUS.
*        ZLLM_WA-CHGUM = SY-UNAME.
*        ZLLM_WA-CHGDT = SY-DATUM.
*        ZLLM_WA-CHGTM = SY-UZEIT.
*        MODIFY ZLLM FROM ZLLM_WA.
*        COMMIT WORK AND WAIT.
*        CLEAR ZLLM_WA.
*      ENDIF.
*    ENDIF.
*  ENDLOOP.
**  if sy-subrc eq 0.
**    message 'SAVE DATA' type 'I'.
**  endif.
*
**  break-point.
*  LOOP AT IT_DISP1 INTO WA_DISP1 WHERE QTY GT 0.
*    CLEAR : QTY1.
*    QTY1 = WA_DISP1-FKIMG1 - WA_DISP1-DISP_QTY1.
*    WA_DISP1-QTY1 = WA_DISP1-QTY.
*    IF WA_DISP1-QTY1 GT QTY1.
*      MESSAGE 'CHECK ENTERED QUANTITY' TYPE 'E'.
*    ENDIF.
*    SELECT SINGLE * FROM ZLLM WHERE MATNR EQ WA_DISP1-MATNR AND CHARG EQ WA_DISP1-CHARG.
*    IF SY-SUBRC EQ 0.
*      READ TABLE IT_ZLLM_DSP11 INTO WA_ZLLM_DSP11 WITH KEY MATNR = WA_DISP1-MATNR CHARG = WA_DISP1-CHARG LIFNR = WA_DISP1-LIFNR.
*      IF SY-SUBRC EQ 0.
*        BUZEI = WA_ZLLM_DSP11-BUZEI + 1.
*      ENDIF.
*      CONDENSE : WA_DISP1-QTY.
*      ZLLM_DSP_WA-MATNR  = WA_DISP1-MATNR.
*      ZLLM_DSP_WA-CHARG  = WA_DISP1-CHARG.
*      ZLLM_DSP_WA-BUZEI  = BUZEI.
*      ZLLM_DSP_WA-LIFNR = WA_DISP1-LIFNR.
*      ZLLM_DSP_WA-FKIMG = WA_DISP1-QTY.
*      ZLLM_DSP_WA-FKDAT = SY-DATUM.
*      ZLLM_DSP_WA-REMARK = WA_DISP1-REMARK.
*      ZLLM_DSP_WA-UNAME = SY-UNAME.
*      ZLLM_DSP_WA-CPUDT = SY-DATUM.
*      ZLLM_DSP_WA-CPUTM = SY-UZEIT.
*      MODIFY ZLLM_DSP FROM ZLLM_DSP_WA.
*      COMMIT WORK AND WAIT.
*      CLEAR ZLLM_DSP_WA.
*    ENDIF.
*  ENDLOOP.
*  IF SY-SUBRC EQ 0.
*    MESSAGE 'SAVE DATA' TYPE 'I'.
*  ENDIF.
*
*  LEAVE TO SCREEN 0.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CRCHK2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CRCHK2 .
*  CLEAR : E.
**  break-point.
*
*  LOOP AT IT_DISP1  INTO WA_DISP1 WHERE CHARG NE SPACE.
*    IF WA_DISP1-FKIMG CA SY-ABCDE.
*      E = 1.
*      MESSAGE E965(ZHR_MESSAGE) WITH WA_DISP1-CHARG.
*      EXIT.
*    ENDIF.
*  ENDLOOP.
*
*
*
*
**  loop at it_disp1  into wa_disp1 where charg ne space.
**
**    call function 'NUMERIC_CHECK'
**      exporting
**        string_in = wa_disp1-fkimg
**      importing
***       STRING_OUT       =
**        htype     = fqty.
**
**    if fqty <> 'NUMC'.
**      e = 1.
**      message e965(zhr_message) with wa_disp1-charg.
***      message 'CHECK QTY' type 'E'.
**      exit.
***      break-point.
***      CLEAR : <fs>.
**    endif.
**  endloop.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  NEWSALE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*form newsale .
*  if it_tab1 is not initial.
*    select * from mcha into table it_mcha for all entries in it_tab1 where charg eq it_tab1-charg and werks eq '2028'.
*  endif.
*  loop at it_mcha into wa_mcha.
*
*    select single * from zdist_invalid where matnr eq wa_mcha-matnr and charg eq wa_mcha-charg. "ADDED ON 16.8.23
*    if sy-subrc eq 0.
*      delete it_mcha where matnr eq zdist_invalid-matnr and charg eq zdist_invalid-charg.
*    endif.
*
*    select single * from mara where matnr eq wa_mcha-matnr and mtart in ('ZFRT','ZHWA').
*    if sy-subrc eq 4.
*      delete it_mcha where matnr eq wa_mcha-matnr and charg eq wa_mcha-charg.
*    endif.
*  endloop.
*
*
*endform.
*&---------------------------------------------------------------------*
*&      Form  FORM1CN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  CNMODIFY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  CNUPDATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  DROPDOWN_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DROPDOWN_TABLE .
  DATA: LT_DROPDOWN TYPE LVC_T_DROP,
        LS_DROPDOWN TYPE LVC_S_DROP.
* First SLART listbox (handle '1').
  LS_DROPDOWN-HANDLE = '3'.
  LS_DROPDOWN-VALUE = 'R - RELEASED'.
  APPEND LS_DROPDOWN TO LT_DROPDOWN.
*  ls_dropdown-handle = '3'.
*  ls_dropdown-value = 'Dispatched'.
*  append ls_dropdown to lt_dropdown.
  LS_DROPDOWN-HANDLE = '3'.
  LS_DROPDOWN-VALUE = 'Q - UNDER TEST'.
  APPEND LS_DROPDOWN TO LT_DROPDOWN.

*  *method to display the dropdown in ALV
  CALL METHOD GR_ALVGRID->SET_DROP_DOWN_TABLE
    EXPORTING
      IT_DROP_DOWN = LT_DROPDOWN.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  STATUS_9002  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_9002 OUTPUT.
  SET PF-STATUS 'STATUS'.
  SET TITLEBAR 'MODIFY'.
  PERFORM ALV. "DISPATCH ENTRY

  CASE OK_CODE1.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      CLEAR: OK_CODE.
      LEAVE PROGRAM.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ALV .

  CLEAR : IT_FCAT,LV_FLDCAT.
  CREATE OBJECT GR_ALVGRID
    EXPORTING
*     i_parent          = gr_ccontainer
      I_PARENT          = CL_GUI_CUSTOM_CONTAINER=>SCREEN0
    EXCEPTIONS
      ERROR_CNTL_CREATE = 1
      ERROR_CNTL_INIT   = 2
      ERROR_CNTL_LINK   = 3
      ERROR_DP_CREATE   = 4
      OTHERS            = 5.
  IF SY-SUBRC <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  PERFORM ALV_BUILD_FIELDCAT1. "DISPATCH
  PERFORM DROPDOWN_TABLE.
  CALL METHOD GR_ALVGRID->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_BUFFER_ACTIVE =
*     I_BYPASSING_BUFFER            =
*     I_CONSISTENCY_CHECK           =
*     I_STRUCTURE_NAME              =
      IS_VARIANT      = VARIANT
      I_SAVE          = 'A'
*     I_DEFAULT       = 'X'
      IS_LAYOUT       = GS_LAYO
*     IS_PRINT        =
*     IT_SPECIAL_GROUPS             =
*     IT_TOOLBAR_EXCLUDING          =
*     IT_HYPERLINK    =
*     IT_ALV_GRAPHICS =
*     IT_EXCEPT_QINFO =
*     IR_SALV_ADAPTER =
    CHANGING
      IT_OUTTAB       = IT_DISP1
      IT_FIELDCATALOG = IT_FCAT
*     IT_SORT         =
*     IT_FILTER       =
*      EXCEPTIONS
*     INVALID_PARAMETER_COMBINATION = 1
*     PROGRAM_ERROR   = 2
*     TOO_MANY_LINES  = 3
*     others          = 4
    .
  IF SY-SUBRC <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9002  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_9002 INPUT.
  GR_ALVGRID->CHECK_CHANGED_DATA( ).
  CASE OK_CODE1.
    WHEN 'SAVE'.
*      break-point.
      GR_ALVGRID->CHECK_CHANGED_DATA( ).
      PERFORM UPDATE.
*      message 'SAVE' type 'I'.
*      leave to screen 0.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
  ENDCASE.
  CLEAR: OK_CODE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  DATMOD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DATMOD .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CURRSTK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM CURRSTK .
*  CLEAR : IT_ZLLM, WA_ZLLM.
*  SELECT * FROM ZLLM INTO TABLE IT_ZLLM WHERE MATNR IN MATNR AND CHARG IN CHARG AND LIFNR IN VENDOR.
*  IF IT_ZLLM IS NOT INITIAL.
*    SELECT * FROM ZLLM_DSP INTO TABLE IT_ZLLM_DSP FOR ALL ENTRIES IN IT_ZLLM  WHERE MATNR EQ IT_ZLLM-MATNR AND CHARG EQ IT_ZLLM-CHARG AND LIFNR EQ
*    IT_ZLLM-LIFNR.
*  ENDIF.
*  IF IT_ZLLM IS INITIAL.
*    MESSAGE'NO DATA FOUND' TYPE 'E'.
*  ENDIF.
*  LOOP AT IT_ZLLM_DSP INTO WA_ZLLM_DSP.
*    WA_DSP1-MATNR = WA_ZLLM_DSP-MATNR.
*    WA_DSP1-CHARG = WA_ZLLM_DSP-CHARG.
*    WA_DSP1-LIFNR = WA_ZLLM_DSP-LIFNR.
*    WA_DSP1-DISP_QTY = WA_ZLLM_DSP-FKIMG.
*    COLLECT WA_DSP1 INTO IT_DSP1.
*    CLEAR WA_DSP1.
*  ENDLOOP.
*  COUNT1 = 1.
*
*  IF S1 EQ 'X'.
*    LOOP AT IT_ZLLM INTO WA_ZLLM.
*      SELECT SINGLE * FROM MCHA WHERE MATNR EQ WA_ZLLM-MATNR AND CHARG EQ WA_ZLLM-CHARG.
*      IF SY-SUBRC EQ 4.
*        WA_DISP1-EBELN = WA_ZLLM-EBELN.
*        WA_DISP1-LIFNR = WA_ZLLM-LIFNR.
*        SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_ZLLM-LIFNR.
*        IF SY-SUBRC EQ 0.
*          WA_DISP1-NAME1 = LFA1-NAME1.
*        ENDIF.
**    wa_disp1-buzei = count1.
*        WA_DISP1-MATNR = WA_ZLLM-MATNR.
*        WA_DISP1-MATNR1 = WA_ZLLM-MATNR.
*        WA_DISP1-CHARG = WA_ZLLM-CHARG.
*        IF WA_ZLLM-STATUS EQ 'R'.
*          WA_DISP1-STATUS = 'RELEASED'.
*        ELSE.
*          WA_DISP1-STATUS = 'UNDER TEST'.
*        ENDIF.
*        CLEAR : QTY1.
*        READ TABLE IT_DSP1 INTO WA_DSP1 WITH KEY MATNR = WA_ZLLM-MATNR CHARG = WA_ZLLM-CHARG LIFNR = WA_ZLLM-LIFNR.
*        IF SY-SUBRC EQ 0.
*          WA_DISP1-DISP_QTY = WA_DSP1-DISP_QTY.
*          QTY1 = WA_DSP1-DISP_QTY.
*        ENDIF.
*        IF  QTY1 GE WA_ZLLM-FKIMG.
*          WA_DISP1-STATUS = 'DISPATCHED'.
*        ENDIF.
*        SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_ZLLM-MATNR.
*        IF SY-SUBRC EQ 0.
*          WA_DISP1-MAKTX = MAKT-MAKTX.
*        ENDIF.
*        WA_DISP1-FKIMG1 = WA_ZLLM-FKIMG.
*        WA_DISP1-REMARK = WA_ZLLM-REMARK.
*        WA_DISP1-CPUDT = WA_ZLLM-CPUDT.
*        WA_DISP1-CPUTM = WA_ZLLM-CPUTM.
*        WA_DISP1-QAREMARK = WA_ZLLM-QAREMARK.
*        WA_DISP1-CHGDT = WA_ZLLM-CHGDT.
*        WA_DISP1-CHGTM = WA_ZLLM-CHGTM.
*        COLLECT WA_DISP1 INTO IT_DISP1.
*        CLEAR WA_DISP1.
**    count1 = count1 + 1.
*      ENDIF.
*    ENDLOOP.
*
*  ELSEIF S2 EQ 'X' OR S3 EQ 'X'.
*    IF IT_ZLLM IS NOT INITIAL.
*      SELECT * FROM MSEG INTO TABLE IT_MSEG FOR ALL ENTRIES IN IT_ZLLM WHERE BWART EQ '101' AND MATNR EQ IT_ZLLM-MATNR AND CHARG EQ IT_ZLLM-CHARG
*      %_HINTS ORACLE 'INDEX("MSEG" "MSEG~Z15")'.
*      IF IT_MSEG IS NOT INITIAL.
*        SELECT * FROM MSEG INTO TABLE IT_MSEG1 FOR ALL ENTRIES IN IT_MSEG WHERE SMBLN EQ IT_MSEG-MBLNR AND SJAHR EQ IT_MSEG-MJAHR
*        %_HINTS ORACLE 'INDEX("MSEG" "MSEG~S")'.
*      ENDIF.
*    ENDIF.
*    SORT IT_MSEG BY MBLNR DESCENDING.
*
*    LOOP AT IT_ZLLM INTO WA_ZLLM.
**      select single * from mcha where matnr eq wa_zllm-matnr and charg eq wa_zllm-charg.
**      if sy-subrc eq 4.
*      WA_DISP1-LIFNR = WA_ZLLM-LIFNR.
*      WA_DISP1-EBELN = WA_ZLLM-EBELN.
*      SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_ZLLM-LIFNR.
*      IF SY-SUBRC EQ 0.
*        WA_DISP1-NAME1 = LFA1-NAME1.
*      ENDIF.
**    wa_disp1-buzei = count1.
*      WA_DISP1-MATNR = WA_ZLLM-MATNR.
*      WA_DISP1-MATNR1 = WA_ZLLM-MATNR.
*      WA_DISP1-CHARG = WA_ZLLM-CHARG.
*      IF WA_ZLLM-STATUS EQ 'R'.
*        WA_DISP1-STATUS = 'RELEASED'.
*      ELSE.
*        WA_DISP1-STATUS = 'UNDER TEST'.
*      ENDIF.
*      SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_ZLLM-MATNR.
*      IF SY-SUBRC EQ 0.
*        WA_DISP1-MAKTX = MAKT-MAKTX.
*      ENDIF.
*      WA_DISP1-FKIMG1 = WA_ZLLM-FKIMG.
*      READ TABLE IT_MSEG INTO WA_MSEG WITH KEY MATNR = WA_ZLLM-MATNR CHARG = WA_ZLLM-CHARG.
*      IF SY-SUBRC EQ 0.
*        READ TABLE IT_MSEG1 INTO WA_MSEG1 WITH KEY SMBLN = WA_MSEG-MBLNR.
*        IF SY-SUBRC EQ 4.
*          WA_DISP1-MBLNR = WA_MSEG-MBLNR.
*          WA_DISP1-WERKS = WA_MSEG-WERKS.
*          WA_DISP1-BUDAT = WA_MSEG-BUDAT_MKPF.
*        ENDIF.
*      ENDIF.
*      WA_DISP1-REMARK = WA_ZLLM-REMARK.
*      WA_DISP1-CPUDT = WA_ZLLM-CPUDT.
*      WA_DISP1-CPUTM = WA_ZLLM-CPUTM.
*
*      WA_DISP1-QAREMARK = WA_ZLLM-QAREMARK.
*      WA_DISP1-CHGDT = WA_ZLLM-CHGDT.
*      WA_DISP1-CHGTM = WA_ZLLM-CHGTM.
*
*      COLLECT WA_DISP1 INTO IT_DISP1.
*      CLEAR WA_DISP1.
**    count1 = count1 + 1.
**      endif.
*    ENDLOOP.
*  ENDIF.
*  SORT IT_DISP1 BY MAKTX CHARG.
*  LOOP AT IT_DISP1 INTO WA_DISP1.
*    PACK WA_DISP1-MATNR1 TO WA_DISP1-MATNR1.
*    MODIFY IT_DISP1 FROM WA_DISP1 TRANSPORTING MATNR1.
*    CLEAR WA_DISP1.
*  ENDLOOP.
*
*
*  WA_FIELDCAT1-FIELDNAME = 'EBELN'.
*  WA_FIELDCAT1-SELTEXT_L = 'PO NO.'.
*  APPEND WA_FIELDCAT1 TO FIELDCAT1.
*  CLEAR : WA_FIELDCAT1.
*
*  WA_FIELDCAT1-FIELDNAME = 'MATNR1'.
*  WA_FIELDCAT1-SELTEXT_L = 'PRODUCT CODE'.
*  APPEND WA_FIELDCAT1 TO FIELDCAT1.
*  CLEAR : WA_FIELDCAT1.
*
*  WA_FIELDCAT1-FIELDNAME = 'MAKTX'.
*  WA_FIELDCAT1-SELTEXT_L = 'PRODUCT NAME'.
*  WA_FIELDCAT1-OUTPUTLEN = 30.
*  APPEND WA_FIELDCAT1 TO FIELDCAT1.
*  CLEAR : WA_FIELDCAT1.
*
*  WA_FIELDCAT1-FIELDNAME = 'CHARG'.
*  WA_FIELDCAT1-SELTEXT_L = 'BATCH'.
*  APPEND WA_FIELDCAT1 TO FIELDCAT1.
*  CLEAR : WA_FIELDCAT1.
*
*  WA_FIELDCAT1-FIELDNAME = 'FKIMG1'.
*  WA_FIELDCAT1-SELTEXT_L = 'QTY'.
**  wa_fieldcat1-edit = 'X'.
*  APPEND WA_FIELDCAT1 TO FIELDCAT1.
*  CLEAR : WA_FIELDCAT1.
*
*  WA_FIELDCAT1-FIELDNAME = 'LIFNR'.
*  WA_FIELDCAT1-SELTEXT_L = 'VENDOR CODE'.
**  wa_fieldcat1-edit = 'X'.
*  WA_FIELDCAT1-OUTPUTLEN = 10.
*  APPEND WA_FIELDCAT1 TO FIELDCAT1.
*  CLEAR : WA_FIELDCAT1.
*
*
*  WA_FIELDCAT1-FIELDNAME = 'NAME1'.
*  WA_FIELDCAT1-SELTEXT_L = 'VENDOR NAME'.
**  wa_fieldcat1-edit = 'X'.
*  WA_FIELDCAT1-OUTPUTLEN = 30.
*  APPEND WA_FIELDCAT1 TO FIELDCAT1.
*  CLEAR : WA_FIELDCAT1.
*
*  WA_FIELDCAT1-FIELDNAME = 'STATUS'.
*  WA_FIELDCAT1-SELTEXT_L = 'STATUS'.
*  APPEND WA_FIELDCAT1 TO FIELDCAT1.
*  CLEAR : WA_FIELDCAT1.
*
*  WA_FIELDCAT1-FIELDNAME = 'DISP_QTY'.
*  WA_FIELDCAT1-SELTEXT_L = 'DISPATCHED QTY'.
*  APPEND WA_FIELDCAT1 TO FIELDCAT1.
*  CLEAR : WA_FIELDCAT1.
*
*  IF S2 EQ 'X'.
*    WA_FIELDCAT1-FIELDNAME = 'WERKS'.
*    WA_FIELDCAT1-SELTEXT_L = 'GRN PLANT'.
*    APPEND WA_FIELDCAT1 TO FIELDCAT1.
*    CLEAR : WA_FIELDCAT1.
*
*    WA_FIELDCAT1-FIELDNAME = 'MBLNR'.
*    WA_FIELDCAT1-SELTEXT_L = 'GRN NO.'.
*    APPEND WA_FIELDCAT1 TO FIELDCAT1.
*    CLEAR : WA_FIELDCAT1.
*
*    WA_FIELDCAT1-FIELDNAME = 'BUDAT'.
*    WA_FIELDCAT1-SELTEXT_L = 'GRN POSTING DATE'.
*    APPEND WA_FIELDCAT1 TO FIELDCAT1.
*    CLEAR : WA_FIELDCAT1.
*  ENDIF.
*
*  WA_FIELDCAT1-FIELDNAME = 'REMARK'.
*  WA_FIELDCAT1-SELTEXT_L = 'PRODUCTION REMARK'.
*  APPEND WA_FIELDCAT1 TO FIELDCAT1.
*  CLEAR : WA_FIELDCAT1.
*
*  WA_FIELDCAT1-FIELDNAME = 'CPUDT'.
*  WA_FIELDCAT1-SELTEXT_L = 'PROD. ENTRY DATE'.
*  APPEND WA_FIELDCAT1 TO FIELDCAT1.
*  CLEAR : WA_FIELDCAT1.
*
*  WA_FIELDCAT1-FIELDNAME = 'CPUTM'.
*  WA_FIELDCAT1-SELTEXT_L = 'PROD ENTRY TIME'.
*  APPEND WA_FIELDCAT1 TO FIELDCAT1.
*  CLEAR : WA_FIELDCAT1.
*
*  WA_FIELDCAT1-FIELDNAME = 'QAREMARK'.
*  WA_FIELDCAT1-SELTEXT_L = 'QC REMARK'.
*  APPEND WA_FIELDCAT1 TO FIELDCAT1.
*  CLEAR : WA_FIELDCAT1.
*
*  WA_FIELDCAT1-FIELDNAME = 'CHGDT'.
*  WA_FIELDCAT1-SELTEXT_L = 'QC ENTRY DATE'.
*  APPEND WA_FIELDCAT1 TO FIELDCAT1.
*  CLEAR : WA_FIELDCAT1.
*
*  WA_FIELDCAT1-FIELDNAME = 'CHGTM'.
*  WA_FIELDCAT1-SELTEXT_L = 'QC ENTRY TIME'.
*  APPEND WA_FIELDCAT1 TO FIELDCAT1.
*  CLEAR : WA_FIELDCAT1.
*
*
*  L_GLAY-EDT_CLL_CB = 'X'.
*
**  ls_layout-colwidth_optimize = 'X'.
*
**  wa_fieldcat1-fieldname = 'CHK'.
**  wa_fieldcat1-seltext_l = 'SELECT'.
**  wa_fieldcat1-checkbox = 'X'.
**  wa_fieldcat1-edit = 'X'.
**  APPEND wa_fieldcat1 TO fieldcat1.
**  CLEAR wa_fieldcat1.
*
*
*
*  LAYOUT-ZEBRA = 'X'.
*  LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
*  LAYOUT-WINDOW_TITLEBAR  = 'THIRD PARTY AVAILABLE STOCK DATAILS'.
*
*
*  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*    EXPORTING
**     I_INTERFACE_CHECK       = ' '
**     I_BYPASSING_BUFFER      = ' '
**     I_BUFFER_ACTIVE         = ' '
*      I_CALLBACK_PROGRAM      = G_REPID
**     I_CALLBACK_PF_STATUS_SET          = 'STATUS'
*      I_CALLBACK_USER_COMMAND = 'USER_COMM1'
*      I_CALLBACK_TOP_OF_PAGE  = 'TOP1'
**     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
**     I_CALLBACK_HTML_END_OF_LIST       = ' '
**     I_STRUCTURE_NAME        =
**     I_BACKGROUND_ID         = ' '
**     I_GRID_TITLE            =
**     I_GRID_SETTINGS         = L_GLAY
*      IS_LAYOUT               = LAYOUT1
*      IT_FIELDCAT             = FIELDCAT1
**     IT_EXCLUDING            =
**     IT_SPECIAL_GROUPS       =
**     IT_SORT                 =
**     IT_FILTER               =
**     IS_SEL_HIDE             =
**     I_DEFAULT               = 'X'
*      I_SAVE                  = 'A'
**     IS_VARIANT              =
**     IT_EVENTS               =
**     IT_EVENT_EXIT           =
**     IS_PRINT                =
**     IS_REPREP_ID            =
**     I_SCREEN_START_COLUMN   = 0
**     I_SCREEN_START_LINE     = 0
**     I_SCREEN_END_COLUMN     = 0
**     I_SCREEN_END_LINE       = 0
**     I_HTML_HEIGHT_TOP       = 0
**     I_HTML_HEIGHT_END       = 0
**     IT_ALV_GRAPHICS         =
**     IT_HYPERLINK            =
**     IT_ADD_FIELDCAT         =
**     IT_EXCEPT_QINFO         =
**     IR_SALV_FULLSCREEN_ADAPTER        =
** IMPORTING
**     E_EXIT_CAUSED_BY_CALLER =
**     ES_EXIT_CAUSED_BY_USER  =
*    TABLES
*      T_OUTTAB                = IT_DISP1
*    EXCEPTIONS
*      PROGRAM_ERROR           = 1
*      OTHERS                  = 2.
*  IF SY-SUBRC <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.
*
*  CLEAR : LAYOUT1,FIELDCAT1.
**  call screen 9003.
**endform.
*
*ENDFORM.

FORM USER_COMM1 USING UCOMM LIKE SY-UCOMM
                     SELFIELD TYPE SLIS_SELFIELD.



  CASE SELFIELD-FIELDNAME.
    WHEN 'MATNR'.
      SET PARAMETER ID 'MAT' FIELD SELFIELD-VALUE.
      CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
    WHEN 'VBELN1'.
      SET PARAMETER ID 'BV' FIELD SELFIELD-VALUE.
      CALL TRANSACTION 'VL03N' AND SKIP FIRST SCREEN.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.                    "USER_COMM
*&---------------------------------------------------------------------*
*&      Module  ACTIVATE_DMS_GOS  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE ACTIVATE_DMS_GOS OUTPUT.

  DATA: LV_DEL    TYPE C,
        LV_ENAME  TYPE ZEMNAM,
        LV_BTEXT  TYPE ZBTEXT,
        LV_STAGE  TYPE ZSTAGE,
        LV_PERSNO TYPE PERSNO,
        LV_WERKS  TYPE PA0001-WERKS,
        LV_BTRTL  TYPE PA0001-BTRTL.
*  break-point.
  CONDENSE INVNO.

  LV_MBLNR = INVNO.

*  CLEAR: MATNR1.
*  MATNR1 = MCODE.
*  PACK MATNR1 TO MATNR1.
*  CONDENSE MATNR1.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
    EXPORTING
      INPUT  = LV_MBLNR
    IMPORTING
      OUTPUT = LV_MBLNR.

  LS_BORIDENT-OBJKEY = LV_MBLNR.

*    CONCATENATE ls_borident-objkey '_' sy-datum+0(4)
  CONCATENATE LS_BORIDENT-OBJKEY '_' INVDT "Commented & Added by Gokulan.03.01.2021
  INTO LS_BORIDENT-OBJKEY.

  CONDENSE LS_BORIDENT-OBJKEY.

  FREE MEMORY ID 'ZDEL'.

  FREE MEMORY ID: 'ZENAME',
                  'ZBTEXT',
                  'ZSTAGE',
                  'ZPERSNO'.
*  break-point.
*  lv_persno = sy-uname.
  LV_PERSNO = SY-UNAME.
*   lv_werks = PLANT.
*    LV_BTEXT = DEPT.
*    LV_ENAME = ENAME.
  IF LV_PERSNO NE '00000000'.
    CLEAR : LV_ENAME.
    SELECT SINGLE ENAME WERKS BTRTL INTO (LV_ENAME,LV_WERKS,LV_BTRTL) FROM PA0001
       WHERE PERNR EQ LV_PERSNO
       AND BEGDA <= SY-DATUM
    AND ENDDA >= SY-DATUM.
    IF LV_WERKS IS NOT INITIAL AND
       LV_BTRTL IS NOT INITIAL.
      CLEAR : LV_BTEXT.
      SELECT SINGLE BTEXT INTO LV_BTEXT FROM T001P
        WHERE WERKS EQ LV_WERKS
      AND BTRTL EQ LV_BTRTL.
    ENDIF.
  ENDIF.


  LV_STAGE = 'THIRD PARTY DISPATCH ENTRY'.
  EXPORT: LV_ENAME TO MEMORY ID 'ZENAME',
          LV_BTEXT TO MEMORY ID 'ZBTEXT',
          LV_STAGE TO MEMORY ID 'ZSTAGE',
          LV_PERSNO TO MEMORY ID 'ZPERSNO'.

*    IF R3 = ABAP_TRUE. " Commented by Karthik on 31.12.2019

*    IF r1c = abap_true OR r2 = abap_true OR r3 = abap_true.
  LV_DEL = ABAP_TRUE.
  EXPORT LV_DEL TO MEMORY ID 'ZDEL'. " To restrict Deletion option
*    ENDIF.

  CREATE OBJECT LO_GOS_MANAGER
    EXPORTING
      IS_OBJECT      = LS_BORIDENT
      IP_NO_COMMIT   = ' '
    EXCEPTIONS
      OBJECT_INVALID = 1.

*  ELSEIF r21 = abap_true OR r21a = abap_true. " For Reviewed by and Approved by
*
  PERFORM ACTIVATE_DMS_GOS_DISP. " To activate DMS GOS for Display
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  ACTIVATE_DMS_GOS_DISP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ACTIVATE_DMS_GOS_DISP .
*  BREAK-POINT.
  DATA: LT_SEL TYPE TGOS_SELS,
        LS_SEL TYPE SGOS_SELS,
        LV_DEL TYPE C.

  CLEAR LT_SEL.

  IF SY-UNAME EQ 'ITBOM01' .
    FREE MEMORY ID 'ZDEL'. " Commented by Karthik on 31.12.2019
    EXPORT LV_DEL TO MEMORY ID 'ZDEL'. " To restrict Deletion option
    CONDENSE INVNO.
    LV_MBLNR = INVNO.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        INPUT  = LV_MBLNR
      IMPORTING
        OUTPUT = LV_MBLNR.

    LS_BORIDENT-OBJKEY = LV_MBLNR.
*BREAK-POINT.
*  CONCATENATE ls_borident-objkey '_' sy-datum+0(4)
    CONCATENATE LS_BORIDENT-OBJKEY '_' INVDT "Commented & Added by Gokulan.03.01.2021
    INTO LS_BORIDENT-OBJKEY.

    CONDENSE LS_BORIDENT-OBJKEY.

    CREATE OBJECT LO_GOS_MANAGER
      EXPORTING
        IS_OBJECT            = LS_BORIDENT
        IT_SERVICE_SELECTION = LT_SEL
        IP_NO_COMMIT         = ' '
      EXCEPTIONS
        OBJECT_INVALID       = 1.

  ELSE.

    LS_SEL-SIGN = 'I'.
    LS_SEL-OPTION = 'EQ'.
    LS_SEL-LOW = 'VIEW_ATTA'.
    LS_SEL-HIGH = 'VIEW_ATTA'.
    APPEND LS_SEL TO LT_SEL.
    CLEAR LS_SEL.

*  FREE MEMORY ID 'ZDEL'. " Commented by Karthik on 31.12.2019

*  if r13 <> abap_true.
    LV_DEL = ABAP_TRUE.
*  endif.

    EXPORT LV_DEL TO MEMORY ID 'ZDEL'. " To restrict Deletion option
    CONDENSE INVNO.
    LV_MBLNR = INVNO.
*    ccnum.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        INPUT  = LV_MBLNR
      IMPORTING
        OUTPUT = LV_MBLNR.

    LS_BORIDENT-OBJKEY = LV_MBLNR.

*  CONCATENATE ls_borident-objkey '_' sy-datum+0(4)
    CONCATENATE LS_BORIDENT-OBJKEY '_' INVDT "
    INTO LS_BORIDENT-OBJKEY.

    CONDENSE LS_BORIDENT-OBJKEY.

    CREATE OBJECT LO_GOS_MANAGER
      EXPORTING
        IS_OBJECT            = LS_BORIDENT
        IT_SERVICE_SELECTION = LT_SEL
        IP_NO_COMMIT         = ' '
      EXCEPTIONS
        OBJECT_INVALID       = 1.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ATTACH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ATTACH .
*  CLEAR : VAR,LEN,ALP,NUM.
*  VAR = INVNO.
*  FIND REGEX '([[:alpha:]]*)' IN VAR IGNORING CASE MATCH OFFSET MOFF MATCH LENGTH MLEN.
*  IF MLEN GT 0.
*    LEN = STRLEN( VAR ).
*    ALP = VAR+0(MLEN).
**num = var+mlen(len).
**WRITE:/ alp, num.
*    CONDENSE ALP.
*  ENDIF.
*  SELECT SINGLE * FROM ZTP_PRD_PREFIX WHERE PREFIX EQ ALP AND LIFNR EQ LIFNR AND STYPE EQ STYPE.
*  IF SY-SUBRC EQ 0.
*    MCODE = ZTP_PRD_PREFIX-MATNR.
*  ENDIF.

  CLEAR : IT_ZLLM, WA_ZLLM.

  SELECT * FROM ZLLM_DSP  INTO TABLE IT_ZLLM_DSP WHERE LIFNR EQ LIFNR AND XBLNR EQ INVNO AND BLDAT EQ INVDT.
  IF SY-SUBRC EQ 4.
    MESSAGE'NO DATA FOUND' TYPE 'E'.
  ENDIF.
  COUNT1 = 1.

  LOOP AT IT_ZLLM_DSP INTO WA_ZLLM_DSP.
    WA_DISP4-STYPE = WA_ZLLM_DSP-STYPE.
    WA_DISP4-CHARG = WA_ZLLM_DSP-CHARG.
    WA_DISP4-BUZEI = WA_ZLLM_DSP-BUZEI.
    WA_DISP4-MATNR = WA_ZLLM_DSP-MATNR.
    SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_ZLLM_DSP-MATNR AND SPRAS EQ 'EN'.
    IF SY-SUBRC EQ 0.
      WA_DISP4-MAKTX = MAKT-MAKTX.
    ENDIF.
    WA_DISP4-LIFNR = WA_ZLLM_DSP-LIFNR.
    SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_ZLLM_DSP-LIFNR.
    IF SY-SUBRC EQ 0.
      WA_DISP4-NAME1 = LFA1-NAME1.
    ENDIF.
    WA_DISP4-FKIMG = WA_ZLLM_DSP-FKIMG.
    WA_DISP4-XBLNR = WA_ZLLM_DSP-XBLNR.
    WA_DISP4-BLDAT = WA_ZLLM_DSP-BLDAT.
    WA_DISP4-UNAME = WA_ZLLM_DSP-UNAME.
    WA_DISP4-CPUDT = WA_ZLLM_DSP-CPUDT.
    WA_DISP4-CPUTM = WA_ZLLM_DSP-CPUTM.
    COLLECT WA_DISP4 INTO IT_DISP4.
    CLEAR WA_DISP4.
  ENDLOOP.

  SORT IT_DISP4 BY MAKTX CHARG.
  LOOP AT IT_DISP4 INTO WA_DISP4.
    PACK WA_DISP4-MATNR TO WA_DISP4-MATNR.
    PACK WA_DISP4-LIFNR TO WA_DISP4-LIFNR.
    MODIFY IT_DISP4 FROM WA_DISP4 TRANSPORTING MATNR LIFNR.
    CLEAR WA_DISP4.
  ENDLOOP.

  CALL SCREEN 9003.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  STATUS_9003  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_9003 OUTPUT.
  SET PF-STATUS 'STATUS'.
  SET TITLEBAR 'ATTACH'.
  PERFORM ALV2.
  CASE OK_CODE1.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      CLEAR: OK_CODE1.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9003  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_9003 INPUT.
  GR_ALVGRID->CHECK_CHANGED_DATA( ).
  CASE OK_CODE1.
    WHEN 'SAVE'.
      MESSAGE' FILES ATTACHED' TYPE 'I'.
*      break-point.
      GR_ALVGRID->CHECK_CHANGED_DATA( ).
*      perform update.
*      message 'SAVE' type 'I'.
*      leave to screen 0.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
  ENDCASE.
  CLEAR: OK_CODE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  ALV2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ALV2 .
  CLEAR : IT_FCAT,LV_FLDCAT.
  CREATE OBJECT GR_ALVGRID
    EXPORTING
*     i_parent          = gr_ccontainer
      I_PARENT          = CL_GUI_CUSTOM_CONTAINER=>SCREEN0
    EXCEPTIONS
      ERROR_CNTL_CREATE = 1
      ERROR_CNTL_INIT   = 2
      ERROR_CNTL_LINK   = 3
      ERROR_DP_CREATE   = 4
      OTHERS            = 5.
  IF SY-SUBRC <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


  PERFORM ALV_BUILD_FIELDCAT2.
*  PERFORM DROPDOWN_TABLE.
  CALL METHOD GR_ALVGRID->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_BUFFER_ACTIVE =
*     I_BYPASSING_BUFFER            =
*     I_CONSISTENCY_CHECK           =
*     I_STRUCTURE_NAME              =
      IS_VARIANT      = VARIANT
      I_SAVE          = 'A'
*     I_DEFAULT       = 'X'
      IS_LAYOUT       = GS_LAYO
*     IS_PRINT        =
*     IT_SPECIAL_GROUPS             =
*     IT_TOOLBAR_EXCLUDING          =
*     IT_HYPERLINK    =
*     IT_ALV_GRAPHICS =
*     IT_EXCEPT_QINFO =
*     IR_SALV_ADAPTER =
    CHANGING
      IT_OUTTAB       = IT_DISP4
      IT_FIELDCATALOG = IT_FCAT
*     IT_SORT         =
*     IT_FILTER       =
*      EXCEPTIONS
*     INVALID_PARAMETER_COMBINATION = 1
*     PROGRAM_ERROR   = 2
*     TOO_MANY_LINES  = 3
*     others          = 4
    .
  IF SY-SUBRC <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_BUILD_FIELDCAT2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ALV_BUILD_FIELDCAT2 .


*  LV_FLDCAT-FIELDNAME = 'MATNR'.
**  LV_FLDCAT-TABNAME   = 'IT_TAB1'.
*  LV_FLDCAT-SCRTEXT_M = 'MATERIAL CODE'.
**  lv_fldcat-edit   = 'X'.
*  LV_FLDCAT-F4AVAILABL = 'X'.
*  LV_FLDCAT-REF_TABLE = 'MARA'.
*  LV_FLDCAT-REF_FIELD = 'MATNR'.
*  LV_FLDCAT-OUTPUTLEN = 10.
*  APPEND LV_FLDCAT TO IT_FCAT.
*  CLEAR LV_FLDCAT.

* LV_FLDCAT-FIELDNAME = 'BUZEI'.
*  LV_FLDCAT-SCRTEXT_M = 'SR. NO.'.
*  APPEND LV_FLDCAT TO IT_FCAT.
*  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'STYPE'.
  LV_FLDCAT-SCRTEXT_M = 'TYPE OF PRODUCT'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'CHARG'.
*  LV_FLDCAT-TABNAME   = 'IT_TAB1'.
  LV_FLDCAT-SCRTEXT_M = 'BATCH'.
*  lv_fldcat-edit   = 'X'.
*  lv_fldcat-f4availabl = 'X'.
*  lv_fldcat-ref_table = 'VBRP'.
*  lv_fldcat-ref_field = 'CHARG'.
  LV_FLDCAT-OUTPUTLEN = 10.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'FKIMG'.
  LV_FLDCAT-SCRTEXT_M = 'QUANTITY'.
*  lv_fldcat-edit   = 'X'.
  LV_FLDCAT-OUTPUTLEN = 10.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'MATNR'.
  LV_FLDCAT-SCRTEXT_M = 'MATERIAL CODE'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'MAKTX'.
  LV_FLDCAT-SCRTEXT_M = 'MATERIAL NAME'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

*  LV_FLDCAT-FIELDNAME = 'STATUS'.
*  LV_FLDCAT-SCRTEXT_M = 'STATUS'.
**  lv_fldcat-edit   = 'X'.
*  LV_FLDCAT-OUTPUTLEN = 10.
**  lv_fldcat-drdn_hndl = '3'.
*  APPEND LV_FLDCAT TO IT_FCAT.
*  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'LIFNR'.
*  LV_FLDCAT-TABNAME   = 'IT_TAB1'.
  LV_FLDCAT-SCRTEXT_M = 'VENDOR CODE'.
  LV_FLDCAT-OUTPUTLEN = 10.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'NAME1'.
*  LV_FLDCAT-TABNAME   = 'IT_TAB1'.
  LV_FLDCAT-SCRTEXT_M = 'VENDOR NAME'.
  LV_FLDCAT-OUTPUTLEN = 40.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'XBLNR'.
  LV_FLDCAT-SCRTEXT_M = 'INVOICE NUMBER'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'BLDAT'.
  LV_FLDCAT-SCRTEXT_M = 'INVOICE DATE'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'CPUDT'.
  LV_FLDCAT-SCRTEXT_M = 'ENTRY DATE'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'CPUTM'.
  LV_FLDCAT-SCRTEXT_M = 'ENTRY TIME'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'UNAME'.
  LV_FLDCAT-SCRTEXT_M = 'ENTRY BY'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

*  loop at it_fcat into lv_fldcat.
*
**    if    lv_fldcat-fieldname eq 'STATUS'.
**  loop at it_fcat into lv_fldcat.
*    case lv_fldcat-fieldname.
*      when 'STATUS'.
*        lv_fldcat-fieldname = 'STATUS'.
*        lv_fldcat-scrtext_m = 'STATUS'.
**        lv_fldcat-edit   = 'X'.
*        lv_fldcat-outputlen = 10.
*        lv_fldcat-drdn_hndl = '3'.
*
*        modify it_fcat from lv_fldcat.
*        clear lv_fldcat.
*
**      if 1 eq 2.
**        ls_fcat-drdn_alias = abap_true.
**      endif.
**      ls_fcat-checktable = '!'.        "do not check foreign keys
**        modify it_fcat from lv_fldcat.
**      endif.
*    endcase.
*  endloop.

*  lv_fldcat-fieldname = 'REMARK'.
*  lv_fldcat-scrtext_m = 'REMARK IF ANY'.
**  lv_fldcat-edit   = 'X'.
*  lv_fldcat-outputlen = 100.
*  append lv_fldcat to it_fcat.
*  clear lv_fldcat.
*
*  lv_fldcat-fieldname = 'CPUDT'.
*  lv_fldcat-scrtext_m = 'ENTRY DATE'.
*  lv_fldcat-outputlen = 100.
*  append lv_fldcat to it_fcat.
*  clear lv_fldcat.
*
*  lv_fldcat-fieldname = 'CPUTM'.
*  lv_fldcat-scrtext_m = 'ENTRY TIME'.
*  lv_fldcat-outputlen = 100.
*  append lv_fldcat to it_fcat.
*  clear lv_fldcat.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  LLMDISPATCH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM LLMDISPATCH .
*  CLEAR : IT_ZLLM, WA_ZLLM.
*  SELECT * FROM ZLLM INTO TABLE IT_ZLLM WHERE MATNR IN MATNR AND CHARG IN CHARG AND LIFNR IN VENDOR.
*  IF SY-SUBRC EQ 0.
*    SELECT * FROM ZLLM_DSP INTO TABLE IT_ZLLM_DSP FOR ALL ENTRIES IN IT_ZLLM WHERE MATNR EQ IT_ZLLM-MATNR AND CHARG EQ IT_ZLLM-CHARG AND LIFNR EQ IT_ZLLM-LIFNR.
*  ENDIF.
*
*  IF IT_ZLLM_DSP IS INITIAL.
*    MESSAGE 'NO DATA FOUND' TYPE 'E'.
*  ENDIF.
*  COUNT1 = 1.
*
**  if s1 eq 'X'.
**    loop at it_zllm into wa_zllm.
**      select single * from mcha where matnr eq wa_zllm-matnr and charg eq wa_zllm-charg.
**      if sy-subrc eq 4.
**        wa_disp1-lifnr = wa_zllm-lifnr.
**        select single * from lfa1 where lifnr eq wa_zllm-lifnr.
**        if sy-subrc eq 0.
**          wa_disp1-name1 = lfa1-name1.
**        endif.
***    wa_disp1-buzei = count1.
**        wa_disp1-matnr = wa_zllm-matnr.
**        wa_disp1-matnr1 = wa_zllm-matnr.
**        wa_disp1-charg = wa_zllm-charg.
**        wa_disp1-status = wa_zllm-status.
**        select single * from makt where matnr eq wa_zllm-matnr.
**        if sy-subrc eq 0.
**          wa_disp1-maktx = makt-maktx.
**        endif.
**        wa_disp1-fkimg1 = wa_zllm-fkimg.
**        wa_disp1-remark = wa_zllm-remark.
**        wa_disp1-cpudt = wa_zllm-cpudt.
**        wa_disp1-cputm = wa_zllm-cputm.
**        collect wa_disp1 into it_disp1.
**        clear wa_disp1.
***    count1 = count1 + 1.
**      endif.
**    endloop.
**
**  elseif s2 eq 'X' or s3 eq 'X'.
*  IF IT_ZLLM IS NOT INITIAL.
*    SELECT * FROM MSEG INTO TABLE IT_MSEG FOR ALL ENTRIES IN IT_ZLLM WHERE BWART EQ '101' AND MATNR EQ IT_ZLLM-MATNR AND CHARG EQ IT_ZLLM-CHARG
*    %_HINTS ORACLE 'INDEX("MSEG" "MSEG~Z15")'.
*    IF IT_MSEG IS NOT INITIAL.
*      SELECT * FROM MSEG INTO TABLE IT_MSEG1 FOR ALL ENTRIES IN IT_MSEG WHERE SMBLN EQ IT_MSEG-MBLNR AND SJAHR EQ IT_MSEG-MJAHR
*      %_HINTS ORACLE 'INDEX("MSEG" "MSEG~S")'.
*    ENDIF.
*  ENDIF.
*  SORT IT_MSEG BY MBLNR DESCENDING.
*  SORT IT_ZLLM_DSP BY MATNR CHARG LIFNR.
*  SORT IT_ZLLM BY MATNR CHARG LIFNR.
*
*  LOOP AT IT_ZLLM_DSP INTO WA_ZLLM_DSP.
*    WA_DISP3-MATNR = WA_ZLLM_DSP-MATNR.
*    WA_DISP3-CHARG = WA_ZLLM_DSP-CHARG.
*    WA_DISP3-BUZEI = WA_ZLLM_DSP-BUZEI.
*    WA_DISP3-FKIMG = WA_ZLLM_DSP-FKIMG.
*    WA_DISP3-FKDAT = WA_ZLLM_DSP-FKDAT.
*    WA_DISP3-REMARK = WA_ZLLM_DSP-REMARK.
*    WA_DISP3-LIFNR = WA_ZLLM_DSP-LIFNR.
*    ON CHANGE OF WA_ZLLM_DSP-CHARG.
*      READ TABLE IT_ZLLM INTO WA_ZLLM WITH KEY MATNR = WA_ZLLM_DSP-MATNR CHARG = WA_ZLLM_DSP-CHARG LIFNR = WA_ZLLM_DSP-LIFNR.
*      IF SY-SUBRC EQ 0.
*        WA_DISP3-EBELN = WA_ZLLM-EBELN.
*        WA_DISP3-FKIMG1 = WA_ZLLM-FKIMG.
*        WA_DISP3-STATUS = WA_ZLLM-STATUS.
*        SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_ZLLM-LIFNR.
*        IF SY-SUBRC EQ 0.
*          WA_DISP3-NAME1 = LFA1-NAME1.
*        ENDIF.
*        SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_ZLLM-MATNR AND SPRAS EQ 'EN'.
*        IF SY-SUBRC EQ 0.
*          WA_DISP3-MAKTX = MAKT-MAKTX.
*        ENDIF.
*      ENDIF.
*    ENDON.
*    COLLECT WA_DISP3 INTO IT_DISP3.
*    CLEAR WA_DISP3.
*  ENDLOOP.
*
*
*  SORT IT_DISP3 BY MATNR CHARG FKDAT.
*  LOOP AT IT_DISP3 INTO WA_DISP3.
*    PACK WA_DISP3-MATNR TO WA_DISP3-MATNR.
*    MODIFY IT_DISP3 FROM WA_DISP3 TRANSPORTING MATNR.
*    CLEAR WA_DISP3.
*  ENDLOOP.
*
*
*  WA_FIELDCAT1-FIELDNAME = 'EBELN'.
*  WA_FIELDCAT1-SELTEXT_L = 'PO NO.'.
*  APPEND WA_FIELDCAT1 TO FIELDCAT1.
*  CLEAR : WA_FIELDCAT1.
*
*
*  WA_FIELDCAT1-FIELDNAME = 'MATNR'.
*  WA_FIELDCAT1-SELTEXT_L = 'PRODUCT CODE'.
*  APPEND WA_FIELDCAT1 TO FIELDCAT1.
*  CLEAR : WA_FIELDCAT1.
*
*  WA_FIELDCAT1-FIELDNAME = 'MAKTX'.
*  WA_FIELDCAT1-SELTEXT_L = 'PRODUCT NAME'.
*  WA_FIELDCAT1-OUTPUTLEN = 30.
*  APPEND WA_FIELDCAT1 TO FIELDCAT1.
*  CLEAR : WA_FIELDCAT1.
*
*  WA_FIELDCAT1-FIELDNAME = 'CHARG'.
*  WA_FIELDCAT1-SELTEXT_L = 'BATCH'.
*  APPEND WA_FIELDCAT1 TO FIELDCAT1.
*  CLEAR : WA_FIELDCAT1.
*
*  WA_FIELDCAT1-FIELDNAME = 'FKIMG1'.
*  WA_FIELDCAT1-SELTEXT_L = 'TOTAL QTY'.
**  wa_fieldcat1-edit = 'X'.
*  APPEND WA_FIELDCAT1 TO FIELDCAT1.
*  CLEAR : WA_FIELDCAT1.
*
*  WA_FIELDCAT1-FIELDNAME = 'FKIMG'.
*  WA_FIELDCAT1-SELTEXT_L = 'DISPATCHED QTY'.
**  wa_fieldcat1-edit = 'X'.
*  APPEND WA_FIELDCAT1 TO FIELDCAT1.
*  CLEAR : WA_FIELDCAT1.
*
*  WA_FIELDCAT1-FIELDNAME = 'FKDAT'.
*  WA_FIELDCAT1-SELTEXT_L = 'DISPATCHED DATE'.
**  wa_fieldcat1-edit = 'X'.
*  APPEND WA_FIELDCAT1 TO FIELDCAT1.
*  CLEAR : WA_FIELDCAT1.
*
*  WA_FIELDCAT1-FIELDNAME = 'LIFNR'.
*  WA_FIELDCAT1-SELTEXT_L = 'VENDOR CODE'.
**  wa_fieldcat1-edit = 'X'.
*  WA_FIELDCAT1-OUTPUTLEN = 10.
*  APPEND WA_FIELDCAT1 TO FIELDCAT1.
*  CLEAR : WA_FIELDCAT1.
*
*
*  WA_FIELDCAT1-FIELDNAME = 'NAME1'.
*  WA_FIELDCAT1-SELTEXT_L = 'VENDOR NAME'.
**  wa_fieldcat1-edit = 'X'.
*  WA_FIELDCAT1-OUTPUTLEN = 30.
*  APPEND WA_FIELDCAT1 TO FIELDCAT1.
*  CLEAR : WA_FIELDCAT1.
*
**  wa_fieldcat1-fieldname = 'STATUS'.
**  wa_fieldcat1-seltext_l = 'STATUS'.
**  append wa_fieldcat1 to fieldcat1.
**  clear : wa_fieldcat1.
*
**  if s2 eq 'X'.
**    wa_fieldcat1-fieldname = 'WERKS'.
**    wa_fieldcat1-seltext_l = 'GRN PLANT'.
**    append wa_fieldcat1 to fieldcat1.
**    clear : wa_fieldcat1.
**
**    wa_fieldcat1-fieldname = 'MBLNR'.
**    wa_fieldcat1-seltext_l = 'GRN NO.'.
**    append wa_fieldcat1 to fieldcat1.
**    clear : wa_fieldcat1.
**
**    wa_fieldcat1-fieldname = 'BUDAT'.
**    wa_fieldcat1-seltext_l = 'GRN POSTING DATE'.
**    append wa_fieldcat1 to fieldcat1.
**    clear : wa_fieldcat1.
**  endif.
*
*  WA_FIELDCAT1-FIELDNAME = 'REMARK'.
*  WA_FIELDCAT1-SELTEXT_L = 'REMARK'.
*  APPEND WA_FIELDCAT1 TO FIELDCAT1.
*  CLEAR : WA_FIELDCAT1.
*
**  wa_fieldcat1-fieldname = 'CPUDT'.
**  wa_fieldcat1-seltext_l = 'ENTRY DATE'.
**  append wa_fieldcat1 to fieldcat1.
**  clear : wa_fieldcat1.
**
**  wa_fieldcat1-fieldname = 'CPUTM'.
**  wa_fieldcat1-seltext_l = 'ENTRY TIME'.
**  append wa_fieldcat1 to fieldcat1.
**  clear : wa_fieldcat1.
*
*
*  L_GLAY-EDT_CLL_CB = 'X'.
*
**  ls_layout-colwidth_optimize = 'X'.
*
**  wa_fieldcat1-fieldname = 'CHK'.
**  wa_fieldcat1-seltext_l = 'SELECT'.
**  wa_fieldcat1-checkbox = 'X'.
**  wa_fieldcat1-edit = 'X'.
**  APPEND wa_fieldcat1 TO fieldcat1.
**  CLEAR wa_fieldcat1.
*
*
*
*  LAYOUT-ZEBRA = 'X'.
*  LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
*  LAYOUT-WINDOW_TITLEBAR  = 'THIRD PARTY DISPATCH DETAILS'.
*
*
*  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*    EXPORTING
**     I_INTERFACE_CHECK       = ' '
**     I_BYPASSING_BUFFER      = ' '
**     I_BUFFER_ACTIVE         = ' '
*      I_CALLBACK_PROGRAM      = G_REPID
**     I_CALLBACK_PF_STATUS_SET          = 'STATUS'
*      I_CALLBACK_USER_COMMAND = 'USER_COMM1'
*      I_CALLBACK_TOP_OF_PAGE  = 'TOP1'
**     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
**     I_CALLBACK_HTML_END_OF_LIST       = ' '
**     I_STRUCTURE_NAME        =
**     I_BACKGROUND_ID         = ' '
**     I_GRID_TITLE            =
**     I_GRID_SETTINGS         = L_GLAY
*      IS_LAYOUT               = LAYOUT1
*      IT_FIELDCAT             = FIELDCAT1
**     IT_EXCLUDING            =
**     IT_SPECIAL_GROUPS       =
**     IT_SORT                 =
**     IT_FILTER               =
**     IS_SEL_HIDE             =
**     I_DEFAULT               = 'X'
*      I_SAVE                  = 'A'
**     IS_VARIANT              =
**     IT_EVENTS               =
**     IT_EVENT_EXIT           =
**     IS_PRINT                =
**     IS_REPREP_ID            =
**     I_SCREEN_START_COLUMN   = 0
**     I_SCREEN_START_LINE     = 0
**     I_SCREEN_END_COLUMN     = 0
**     I_SCREEN_END_LINE       = 0
**     I_HTML_HEIGHT_TOP       = 0
**     I_HTML_HEIGHT_END       = 0
**     IT_ALV_GRAPHICS         =
**     IT_HYPERLINK            =
**     IT_ADD_FIELDCAT         =
**     IT_EXCEPT_QINFO         =
**     IR_SALV_FULLSCREEN_ADAPTER        =
** IMPORTING
**     E_EXIT_CAUSED_BY_CALLER =
**     ES_EXIT_CAUSED_BY_USER  =
*    TABLES
*      T_OUTTAB                = IT_DISP3
*    EXCEPTIONS
*      PROGRAM_ERROR           = 1
*      OTHERS                  = 2.
*  IF SY-SUBRC <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.
*
*  CLEAR : LAYOUT1,FIELDCAT1.
**  call screen 9003.
**endform.
*
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CHANGESTAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CHANGESTAT .
*  break-point .
  CLEAR : IT_ZLLM, WA_ZLLM.
  SELECT * FROM ZLLM INTO TABLE IT_ZLLM WHERE LIFNR EQ LIFNR AND STATUS EQ 'Q'.
  IF SY-SUBRC EQ 4.
    MESSAGE'NO DATA FOUND' TYPE 'E'.
  ENDIF.

  LOOP AT IT_ZLLM INTO WA_ZLLM.
    WA_DISP1-EBELN = WA_ZLLM-EBELN.
    WA_DISP1-LIFNR = WA_ZLLM-LIFNR.
    SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_ZLLM-LIFNR.
    IF SY-SUBRC EQ 0.
      WA_DISP1-NAME1 = LFA1-NAME1.
    ENDIF.
*    wa_disp1-buzei = count1.
    WA_DISP1-MATNR = WA_ZLLM-MATNR.
    WA_DISP1-MATNR1 = WA_ZLLM-MATNR.
    WA_DISP1-CHARG = WA_ZLLM-CHARG.
    IF WA_ZLLM-STATUS EQ 'Q'.
      WA_DISP1-STATUS = 'Q- UNDER TEST'.
    ENDIF.
    SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_ZLLM-MATNR.
    IF SY-SUBRC EQ 0.
      WA_DISP1-MAKTX = MAKT-MAKTX.
    ENDIF.
    WA_DISP1-FKIMG = WA_ZLLM-FKIMG.
    WA_DISP1-FKIMG1 = WA_ZLLM-FKIMG.
    WA_DISP1-REMARK = WA_ZLLM-REMARK.
    WA_DISP1-CPUDT = WA_ZLLM-CPUDT.
    WA_DISP1-CPUTM = WA_ZLLM-CPUTM.
*    clear : doc1.
*    concatenate wa_zllm-matnr '_' wa_zllm-charg into doc1.
*    wa_disp1-doc = doc1.
    COLLECT WA_DISP1 INTO IT_DISP1.
    CLEAR WA_DISP1.
*    count1 = count1 + 1.
  ENDLOOP.


*  break-point.

  SORT IT_DISP1 BY MAKTX CHARG.
  LOOP AT IT_DISP1 INTO WA_DISP1.
    PACK WA_DISP1-MATNR1 TO WA_DISP1-MATNR1.
    MODIFY IT_DISP1 FROM WA_DISP1 TRANSPORTING MATNR1.
    CLEAR WA_DISP1.
  ENDLOOP.

  CALL SCREEN 9004.
ENDFORM.
**&---------------------------------------------------------------------*
**&      Module  STATUS_9004  OUTPUT
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
*MODULE STATUS_9004 OUTPUT.
*  SET PF-STATUS 'STATUS'.
*  SET TITLEBAR 'TITLE1'.
*  PERFORM ALV4.
*  CASE OK_CODE4.
*    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
*      CLEAR: OK_CODE4.
*      LEAVE PROGRAM.
*  ENDCASE.
*ENDMODULE.
**&---------------------------------------------------------------------*
**&      Form  ALV4
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**  -->  p1        text
**  <--  p2        text
**----------------------------------------------------------------------*
FORM ALV4 .
  CLEAR : IT_FCAT,LV_FLDCAT.
  CREATE OBJECT GR_ALVGRID
    EXPORTING
*     i_parent          = gr_ccontainer
      I_PARENT          = CL_GUI_CUSTOM_CONTAINER=>SCREEN0
    EXCEPTIONS
      ERROR_CNTL_CREATE = 1
      ERROR_CNTL_INIT   = 2
      ERROR_CNTL_LINK   = 3
      ERROR_DP_CREATE   = 4
      OTHERS            = 5.
  IF SY-SUBRC <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  PERFORM ALV_BUILD_FIELDCAT4.
  PERFORM DROPDOWN_TABLE.
  CALL METHOD GR_ALVGRID->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_BUFFER_ACTIVE =
*     I_BYPASSING_BUFFER            =
*     I_CONSISTENCY_CHECK           =
*     I_STRUCTURE_NAME              =
      IS_VARIANT      = VARIANT
      I_SAVE          = 'A'
*     I_DEFAULT       = 'X'
      IS_LAYOUT       = GS_LAYO
*     IS_PRINT        =
*     IT_SPECIAL_GROUPS             =
*     IT_TOOLBAR_EXCLUDING          =
*     IT_HYPERLINK    =
*     IT_ALV_GRAPHICS =
*     IT_EXCEPT_QINFO =
*     IR_SALV_ADAPTER =
    CHANGING
      IT_OUTTAB       = IT_DISP1
      IT_FIELDCATALOG = IT_FCAT
*     IT_SORT         =
*     IT_FILTER       =
*      EXCEPTIONS
*     INVALID_PARAMETER_COMBINATION = 1
*     PROGRAM_ERROR   = 2
*     TOO_MANY_LINES  = 3
*     others          = 4
    .
  IF SY-SUBRC <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_BUILD_FIELDCAT4
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ALV_BUILD_FIELDCAT4 .

  LV_FLDCAT-FIELDNAME = 'EBELN'.
*  LV_FLDCAT-TABNAME   = 'IT_TAB1'.
  LV_FLDCAT-SCRTEXT_M = 'PURCHASE ORDER NO.'.
*  lv_fldcat-edit   = 'X'.
*  LV_FLDCAT-F4AVAILABL = 'X'.
*  LV_FLDCAT-REF_TABLE = 'MARA'.
*  LV_FLDCAT-REF_FIELD = 'MATNR'.
  LV_FLDCAT-OUTPUTLEN = 10.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'MATNR'.
*  LV_FLDCAT-TABNAME   = 'IT_TAB1'.
  LV_FLDCAT-SCRTEXT_M = 'MATERIAL CODE'.
*  lv_fldcat-edit   = 'X'.
  LV_FLDCAT-F4AVAILABL = 'X'.
  LV_FLDCAT-REF_TABLE = 'MARA'.
  LV_FLDCAT-REF_FIELD = 'MATNR'.
  LV_FLDCAT-OUTPUTLEN = 10.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'CHARG'.
*  LV_FLDCAT-TABNAME   = 'IT_TAB1'.
  LV_FLDCAT-SCRTEXT_M = 'BATCH'.
*  lv_fldcat-edit   = 'X'.
*  lv_fldcat-f4availabl = 'X'.
*  lv_fldcat-ref_table = 'VBRP'.
*  lv_fldcat-ref_field = 'CHARG'.
  LV_FLDCAT-OUTPUTLEN = 10.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'FKIMG'.
  LV_FLDCAT-SCRTEXT_M = 'ORIGINAL QTY'.
*  lv_fldcat-edit   = 'X'.
  LV_FLDCAT-OUTPUTLEN = 10.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.


  LV_FLDCAT-FIELDNAME = 'STATUS'.
  LV_FLDCAT-SCRTEXT_M = 'STATUS'.
  LV_FLDCAT-EDIT   = 'X'.
  LV_FLDCAT-OUTPUTLEN = 10.
*  lv_fldcat-drdn_hndl = '3'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LOOP AT IT_FCAT INTO LV_FLDCAT.

*    if    lv_fldcat-fieldname eq 'STATUS'.
*  loop at it_fcat into lv_fldcat.
    CASE LV_FLDCAT-FIELDNAME.
      WHEN 'STATUS'.
        LV_FLDCAT-FIELDNAME = 'STATUS'.
        LV_FLDCAT-SCRTEXT_M = 'STATUS'.
        LV_FLDCAT-EDIT   = 'X'.
        LV_FLDCAT-OUTPUTLEN = 10.
        LV_FLDCAT-DRDN_HNDL = '3'.

        MODIFY IT_FCAT FROM LV_FLDCAT.
        CLEAR LV_FLDCAT.

*      if 1 eq 2.
*        ls_fcat-drdn_alias = abap_true.
*      endif.
*      ls_fcat-checktable = '!'.        "do not check foreign keys
*        modify it_fcat from lv_fldcat.
*      endif.
    ENDCASE.
  ENDLOOP.

  LV_FLDCAT-FIELDNAME = 'REMARK'.
  LV_FLDCAT-SCRTEXT_M = 'PRODUCTION REMARK'.
*  lv_fldcat-edit   = 'X'.
*  lv_fldcat-outputlen = 100.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'CPUDT'.
  LV_FLDCAT-SCRTEXT_M = 'PROD ENTRY DATE'.
*  lv_fldcat-outputlen = 100.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'CPUTM'.
  LV_FLDCAT-SCRTEXT_M = 'PROD ENTRY TIME'.
*  lv_fldcat-outputlen = 100.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'QAREMARK'.
  LV_FLDCAT-SCRTEXT_M = 'ENTER REMARK IF ANY'.
  LV_FLDCAT-EDIT   = 'X'.
  LV_FLDCAT-OUTPUTLEN = 100.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9004  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_9004 INPUT.
  GR_ALVGRID->CHECK_CHANGED_DATA( ).
  CASE OK_CODE4.
    WHEN 'SAVE'.
*      break-point.
      GR_ALVGRID->CHECK_CHANGED_DATA( ).
      PERFORM UPDATESTATUS.
*      message 'SAVE' type 'I'.
*      leave to screen 0.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
  ENDCASE.
  CLEAR: OK_CODE4.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  UPDATESTATUS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM UPDATESTATUS .
  LOOP AT IT_DISP1 INTO WA_DISP1 .
    SELECT SINGLE * FROM ZLLM WHERE MATNR EQ WA_DISP1-MATNR AND CHARG EQ WA_DISP1-CHARG AND LIFNR EQ WA_DISP1-LIFNR.
    IF SY-SUBRC EQ 0.
      MOVE-CORRESPONDING ZLLM TO ZLLM_WA.
      ZLLM_WA-STATUS = WA_DISP1-STATUS.
*      zllm_wa-qastatus = wa_disp1-status.
      ZLLM_WA-QAREMARK = WA_DISP1-QAREMARK.
      ZLLM_WA-CHGUM = SY-UNAME.
      ZLLM_WA-CHGDT = SY-DATUM.
      ZLLM_WA-CHGTM = SY-UZEIT.
      MODIFY ZLLM FROM ZLLM_WA.
      COMMIT WORK AND WAIT.
      CLEAR ZLLM_WA.
    ENDIF.
  ENDLOOP.

  IF SY-SUBRC EQ 0.
    MESSAGE 'SAVE DATA' TYPE 'I'.
  ENDIF.

  LEAVE TO SCREEN 0.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FORM11
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FORM11 .

  IF R12 EQ 'X'.

    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
      EXPORTING
        I_FIELD_SEPERATOR    = 'X'
        I_LINE_HEADER        = 'X'
        I_TAB_RAW_DATA       = IT_TYPE
        I_FILENAME           = E_FILE
      TABLES
        I_TAB_CONVERTED_DATA = IT_UPD1[].
  IF SY-SUBRC <> 0.
 MESSAGE 'Error in file uploading' TYPE 'E'.
  ENDIF.
*BREAK-POINT .
  ENDIF.
*  break-point.

  SELECT * FROM ZPRODBATCHES  INTO TABLE IT_ZPRODBATCHES WHERE KUNNR EQ LIFNR AND ENDDA GE SY-DATUM.
  SORT IT_ZPRODBATCHES DESCENDING BY MATNR.

  SELECT * FROM ZPRODBATCHES  INTO TABLE IT_ZPRODBATCHES1 WHERE KUNNR EQ LIFNR AND ENDDA GE SY-DATUM AND COMB_MATNR1 NE SPACE.
  SORT IT_ZPRODBATCHES1 DESCENDING BY MATNR.

  LOOP AT IT_UPD1 INTO WA_UPD1.
    CLEAR : VAR,LEN,ALP,NUM.
    TRANSLATE WA_UPD1-CHARG TO UPPER CASE.
    CONDENSE WA_UPD1-CHARG NO-GAPS.
    VAR = WA_UPD1-CHARG.
    FIND REGEX '([[:alpha:]]*)' IN VAR IGNORING CASE MATCH OFFSET MOFF MATCH LENGTH MLEN.
    IF MLEN GT 0.
      LEN = STRLEN( VAR ).
      ALP = VAR+0(MLEN).
      CONDENSE ALP.
      WA_UPD2-CHARG = WA_UPD1-CHARG.
      IF WA_UPD1-STYPE EQ 'SAMPLE'.
        WA_UPD2-STYPE = 'SAMPLE'.
      ELSE.
        WA_UPD2-STYPE = 'SALE'.
      ENDIF.

*      SELECT SINGLE * FROM ZTP_PRD_PREFIX WHERE PREFIX EQ ALP AND LIFNR EQ LIFNR AND STYPE EQ WA_UPD1-STYPE.
*      IF SY-SUBRC EQ 0.
*        WA_UPD2-MATNR = ZTP_PRD_PREFIX-MATNR.
*      ENDIF.
************ADDDED ON 28.11.24*******************
      IF WA_UPD2-STYPE EQ 'SAMPLE'.
        READ TABLE IT_ZPRODBATCHES1 INTO WA_ZPRODBATCHES1 WITH KEY BATCH_PREFIX = ALP KUNNR = LIFNR.
        IF SY-SUBRC EQ 0.
          WA_UPD2-MATNR = WA_ZPRODBATCHES1-COMB_MATNR1.
        ENDIF.
      ELSE.
        READ TABLE IT_ZPRODBATCHES INTO WA_ZPRODBATCHES WITH KEY BATCH_PREFIX = ALP KUNNR = LIFNR.
        IF SY-SUBRC EQ 0.
          WA_UPD2-MATNR = WA_ZPRODBATCHES-MATNR.
        ENDIF.
      ENDIF.
********CHECK MATERIAL CODE FROM PO FROM **************
      IF WA_UPD1-EBELN  IS NOT INITIAL.
        SELECT SINGLE * FROM EKPO WHERE EBELN EQ WA_UPD1-EBELN.
        IF SY-SUBRC EQ 0.
          IF WA_UPD2-STYPE EQ 'SAMPLE'.
            READ TABLE IT_ZPRODBATCHES1 INTO WA_ZPRODBATCHES1 WITH KEY BATCH_PREFIX = ALP KUNNR = LIFNR COMB_MATNR1 = EKPO-MATNR.
            IF SY-SUBRC EQ 0.
              WA_UPD2-MATNR = WA_ZPRODBATCHES1-COMB_MATNR1.
            ENDIF.
          ELSE.
            READ TABLE IT_ZPRODBATCHES INTO WA_ZPRODBATCHES WITH KEY BATCH_PREFIX = ALP KUNNR = LIFNR MATNR = EKPO-MATNR.
            IF SY-SUBRC EQ 0.
              WA_UPD2-MATNR = WA_ZPRODBATCHES-MATNR.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
      WA_UPD2-QTY = WA_UPD1-QTY.
      WA_UPD2-STAT = WA_UPD1-STAT.
      WA_UPD2-EBELN = WA_UPD1-EBELN.
      COLLECT WA_UPD2 INTO IT_UPD2.
      CLEAR WA_UPD2.
    ENDIF.
  ENDLOOP.

*  BREAK-POINT .

  LOOP AT IT_UPD2 INTO WA_UPD2.
    SELECT SINGLE * FROM ZLLM WHERE CHARG EQ WA_UPD2-CHARG AND STYPE EQ WA_UPD2-STYPE AND LIFNR EQ LIFNR.
    IF SY-SUBRC EQ 0.
      WA_UPD3-STYPE = WA_UPD2-STYPE.
      WA_UPD3-CHARG = WA_UPD2-CHARG.
      COLLECT WA_UPD3 INTO IT_UPD3.
      CLEAR WA_UPD3.
    ENDIF.
  ENDLOOP.
*  BREAK-POINT .
  CLEAR : A.
  LOOP AT IT_UPD2 INTO WA_UPD2.
    SELECT SINGLE * FROM ZLLM WHERE CHARG EQ WA_UPD2-CHARG AND STYPE EQ WA_UPD2-STYPE AND LIFNR EQ LIFNR.
    IF SY-SUBRC EQ 4.
      ZLLM_WA-CHARG = WA_UPD2-CHARG.
      ZLLM_WA-STYPE = WA_UPD2-STYPE.
      ZLLM_WA-MATNR = WA_UPD2-MATNR.
      ZLLM_WA-FKIMG = WA_UPD2-QTY.
      ZLLM_WA-LIFNR = LIFNR.
      ZLLM_WA-EBELN = WA_UPD2-EBELN.
      IF WA_UPD2-STAT EQ 'Q'.
        ZLLM_WA-STATUS = 'Q'.
      ELSE.
        ZLLM_WA-STATUS = 'R'.
      ENDIF.
      ZLLM_WA-UNAME = SY-UNAME.
      ZLLM_WA-CPUDT = SY-DATUM.
      ZLLM_WA-CPUTM = SY-UZEIT.
      A = 1.
      MODIFY ZLLM FROM ZLLM_WA.
      CLEAR ZLLM_WA.
    ENDIF.
  ENDLOOP.
  IF SY-SUBRC EQ 0.
    FORMAT COLOR 1.
    IF A EQ 1.
      WRITE : 'ENTRIES ARE UPDATED' .
      SKIP.
    ENDIF.
  ENDIF.
  FORMAT COLOR 6.
  IF IT_UPD3 IS NOT INITIAL.
    WRITE : / 'FOLLOWING ENTRIES:-  ALREADY EXIST' .
  ENDIF.
  LOOP AT IT_UPD3 INTO WA_UPD3.
    WRITE : / WA_UPD3-STYPE,WA_UPD3-CHARG.
  ENDLOOP.

*  break-point.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  STATUS_9011  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  UPDDISP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM UPDDISP .
  IF R2A EQ 'X'.

    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
      EXPORTING
        I_FIELD_SEPERATOR    = 'X'
        I_LINE_HEADER        = 'X'
        I_TAB_RAW_DATA       = IT_TYPE
        I_FILENAME           = D_FILE
      TABLES
        I_TAB_CONVERTED_DATA = IT_UPD11[].

*BREAK-POINT .
  ENDIF.
*  break-point.
  SELECT * FROM ZPRODBATCHES  INTO TABLE IT_ZPRODBATCHES WHERE KUNNR EQ LIFNR AND ENDDA GE SY-DATUM.
  SORT IT_ZPRODBATCHES DESCENDING BY MATNR.

  SELECT * FROM ZPRODBATCHES  INTO TABLE IT_ZPRODBATCHES1 WHERE KUNNR EQ LIFNR AND ENDDA GE SY-DATUM AND COMB_MATNR1 NE SPACE.
  SORT IT_ZPRODBATCHES1 DESCENDING BY MATNR.

*  SELECT * FROM ZPRODBATCHES  INTO TABLE IT_ZPRODBATCHES WHERE KUNNR EQ LIFNR AND ENDDA GE SY-DATUM.
*  SORT IT_ZPRODBATCHES DESCENDING BY MATNR.

  LOOP AT IT_UPD11 INTO WA_UPD11.
    CLEAR : VAR,LEN,ALP,NUM.
    TRANSLATE WA_UPD11-CHARG TO UPPER CASE.
    CONDENSE WA_UPD11-CHARG NO-GAPS.

    VAR = WA_UPD11-CHARG.
    FIND REGEX '([[:alpha:]]*)' IN VAR IGNORING CASE MATCH OFFSET MOFF MATCH LENGTH MLEN.
    IF MLEN GT 0.
      LEN = STRLEN( VAR ).
      ALP = VAR+0(MLEN).
*num = var+mlen(len).
*WRITE:/ alp, num.
      CONDENSE ALP.

      WA_UPD12-STYPE = WA_UPD11-STYPE.
*      TRANSLATE WA_UPD11-CHARG TO UPPER CASE.
      WA_UPD12-CHARG = WA_UPD11-CHARG.
      WA_UPD12-QTY = WA_UPD11-QTY.
      CONDENSE WA_UPD12-QTY.

      SELECT SINGLE * FROM ZLLM WHERE STYPE EQ WA_UPD11-STYPE AND CHARG EQ WA_UPD11-CHARG.
      IF SY-SUBRC EQ 0.
        WA_UPD12-MATNR = ZLLM-MATNR.
      ENDIF.
      IF  WA_UPD12-MATNR IS INITIAL.
        IF WA_UPD12-STYPE EQ 'SAMPLE'.
          READ TABLE IT_ZPRODBATCHES1 INTO WA_ZPRODBATCHES1 WITH KEY BATCH_PREFIX = ALP  KUNNR = LIFNR.
          IF SY-SUBRC EQ 0.
            WA_UPD12-MATNR = WA_ZPRODBATCHES1-COMB_MATNR1.
          ENDIF.
        ELSE.
          READ TABLE IT_ZPRODBATCHES INTO WA_ZPRODBATCHES WITH KEY BATCH_PREFIX = ALP  KUNNR = LIFNR.
          IF SY-SUBRC EQ 0.
            WA_UPD12-MATNR = WA_ZPRODBATCHES-MATNR.
          ENDIF.
        ENDIF.
      ENDIF.
      WA_UPD12-XBLNR = WA_UPD11-XBLNR.
      WA_UPD12-BLDAT = WA_UPD11-BLDAT.
      COLLECT WA_UPD12 INTO IT_UPD12.
      CLEAR WA_UPD12.
    ENDIF.
  ENDLOOP.
*  BREAK-POINT.
  LOOP AT IT_UPD12 INTO WA_UPD12.
    SELECT SINGLE * FROM ZLLM WHERE STYPE EQ WA_UPD12-STYPE AND CHARG EQ WA_UPD12-CHARG AND STATUS EQ 'R'.
    IF SY-SUBRC EQ 4.
      FORMAT COLOR 6.
      WRITE : / 'THIS BATCH IS NOT UPLOADED IN STOCK OR NOT RELEASED',WA_UPD12-STYPE,WA_UPD12-CHARG,WA_UPD12-QTY.
    ENDIF.
  ENDLOOP.
*  BREAK-POINT.
  LOOP AT IT_UPD12 INTO WA_UPD12.  " total file  qty
*    SELECT SINGLE * FROM ZLLM WHERE STYPE EQ WA_UPD12-STYPE AND CHARG EQ WA_UPD12-CHARG.
*    IF SY-SUBRC EQ 0.
    WA_TOT1-STYPE = WA_UPD12-STYPE.
    WA_TOT1-CHARG = WA_UPD12-CHARG.
    WA_TOT1-QTY = WA_UPD12-QTY.
    CONDENSE  WA_TOT1-QTY.
    COLLECT WA_TOT1 INTO IT_TOT1.
    CLEAR WA_TOT1.
*    ENDIF.
  ENDLOOP.


  LOOP AT IT_TOT1 INTO WA_TOT1.  "order qty
    SELECT SINGLE * FROM ZLLM WHERE STYPE EQ WA_TOT1-STYPE AND CHARG EQ WA_TOT1-CHARG AND STATUS EQ 'R'.
    IF SY-SUBRC EQ 0.
      WA_UPD3-STYPE = ZLLM-STYPE.
      WA_UPD3-CHARG = ZLLM-CHARG.
      WA_UPD3-QTY = ZLLM-FKIMG.
      CONDENSE  WA_UPD3-QTY.
      COLLECT WA_UPD3 INTO IT_UPD3.
      CLEAR WA_UPD3.
    ENDIF.
  ENDLOOP.

  SELECT * FROM ZLLM_DSP INTO TABLE IT_ZLLM_DSP FOR ALL ENTRIES IN IT_UPD3 WHERE STYPE EQ IT_UPD3-STYPE AND CHARG EQ IT_UPD3-CHARG.
  SORT IT_ZLLM_DSP DESCENDING BY BUZEI.
  CLEAR : A.
  LOOP AT IT_ZLLM_DSP INTO WA_ZLLM_DSP. "disp qty
    WA_DIS1-STYPE = WA_ZLLM_DSP-STYPE.
    WA_DIS1-CHARG = WA_ZLLM_DSP-CHARG.
    WA_DIS1-QTY = WA_ZLLM_DSP-FKIMG.
    COLLECT WA_DIS1 INTO IT_DIS1.
    CLEAR WA_DIS1.
  ENDLOOP.

*  BREAK-POINT.

  LOOP AT IT_UPD3 INTO WA_UPD3.  "qty to dispatch
    READ TABLE IT_DIS1 INTO WA_DIS1 WITH KEY STYPE = WA_UPD3-STYPE CHARG = WA_UPD3-CHARG.
    IF SY-SUBRC EQ 4.
      READ TABLE IT_TOT1 INTO WA_TOT1 WITH KEY STYPE = WA_UPD3-STYPE CHARG = WA_UPD3-CHARG.
      IF SY-SUBRC EQ 0.
        WA_UPD4-STYPE = WA_UPD3-STYPE.
        WA_UPD4-CHARG = WA_UPD3-CHARG.
        WA_UPD4-QTY = WA_TOT1-QTY.
        CONDENSE  WA_UPD4-QTY.
        COLLECT WA_UPD4 INTO IT_UPD4.
        CLEAR WA_UPD4.
      ENDIF.
    ENDIF.
  ENDLOOP.

*  BREAK-POINT.
  LOOP AT IT_UPD3 INTO WA_UPD3.  "qty to dispatch
    READ TABLE IT_DIS1 INTO WA_DIS1 WITH KEY STYPE = WA_UPD3-STYPE CHARG = WA_UPD3-CHARG.
    IF SY-SUBRC EQ 0.
      CLEAR : SQTY.
      SQTY =  WA_UPD3-QTY - WA_DIS1-QTY.
      IF SQTY GT 0.
        WA_UPD4-STYPE = WA_UPD3-STYPE.
        WA_UPD4-CHARG = WA_UPD3-CHARG.
        READ TABLE IT_TOT1 INTO WA_TOT1 WITH KEY STYPE = WA_UPD3-STYPE CHARG = WA_UPD3-CHARG.
        IF SY-SUBRC EQ 0.
          IF WA_TOT1-QTY LE SQTY.
            WA_UPD4-QTY = WA_TOT1-QTY.
          ELSE.
            WA_UPD4-QTY = SQTY.
          ENDIF.
        ENDIF.
        CONDENSE  WA_UPD4-QTY.
        COLLECT WA_UPD4 INTO IT_UPD4.
        CLEAR WA_UPD4.
      ENDIF.
    ENDIF.
  ENDLOOP.


*  BREAK-POINT.

*  BREAK-POINT.

******************************
  CLEAR : GJAHR.
  IF SY-DATUM+4(2) GE '04'.
    GJAHR = SY-DATUM+0(4).
  ELSE.
    GJAHR = SY-DATUM+0(4) - 1.
  ENDIF.
*  BREAK-POINT .
  CLEAR : A.
  IF IT_UPD4 IS NOT INITIAL.
    LOOP AT IT_UPD4 INTO WA_UPD4.
*    SELECT SINGLE * FROM ZLLM WHERE MATNR EQ WA_UPD2-MATNR AND CHARG EQ WA_UPD2-CHARG.
*    IF SY-SUBRC EQ 4.
      ZLLM_DSP_WA-STYPE = WA_UPD4-STYPE.
      ZLLM_DSP_WA-CHARG = WA_UPD4-CHARG.
      READ TABLE IT_ZLLM_DSP INTO WA_ZLLM_DSP WITH KEY STYPE = WA_UPD4-STYPE CHARG = WA_UPD4-CHARG.
      IF SY-SUBRC EQ 0.
        BUZEI = WA_ZLLM_DSP-BUZEI.
      ENDIF.
      BUZEI = BUZEI + 1.
      ZLLM_DSP_WA-BUZEI = BUZEI.
      READ TABLE IT_UPD12 INTO WA_UPD12 WITH KEY STYPE = WA_UPD4-STYPE CHARG = WA_UPD4-CHARG.
      IF SY-SUBRC EQ 0.
        ZLLM_DSP_WA-MATNR = WA_UPD12-MATNR.
      ENDIF.
      ZLLM_DSP_WA-LIFNR = LIFNR.
      CONDENSE  WA_UPD4-QTY.
      ZLLM_DSP_WA-FKIMG = WA_UPD4-QTY.
      ZLLM_DSP_WA-FKDAT = SY-DATUM.
      ZLLM_DSP_WA-GJAHR = GJAHR.
      READ TABLE IT_UPD12 INTO WA_UPD12 WITH KEY STYPE = WA_UPD4-STYPE CHARG = WA_UPD4-CHARG.
      IF SY-SUBRC EQ 0.
        ZLLM_DSP_WA-XBLNR = WA_UPD12-XBLNR.
        ZLLM_DSP_WA-BLDAT = WA_UPD12-BLDAT.
      ENDIF.
      ZLLM_DSP_WA-REMARK = SPACE.
      ZLLM_DSP_WA-UNAME = SY-UNAME.
      ZLLM_DSP_WA-CPUDT = SY-DATUM.
      ZLLM_DSP_WA-CPUTM = SY-UZEIT.
      A = 1.
      MODIFY ZLLM_DSP FROM ZLLM_DSP_WA.
      COMMIT WORK AND WAIT .
      CLEAR ZLLM_DSP_WA.
*    ENDIF.
    ENDLOOP.
  ENDIF.
  IF SY-SUBRC EQ 0.
    FORMAT COLOR 1.
    IF A EQ 1.
      WRITE : 'ENTRIES ARE UPDATED' .
      SKIP.
    ENDIF.
  ENDIF.


*  *  IF IT_UPD4 IS INITIAL.
*    FORMAT COLOR 6.
*    WRITE : / 'NO DATA TO UPLOAD'.
*    SKIP.
*    SKIP.
*    WRITE : / 'FOLLOWING DATA IS ALREDY UPDATED FOR DISPATCH'.
*    SKIP.
*    LOOP AT IT_TOT1 INTO WA_TOT1.
*      WRITE : / WA_TOT1-STYPE,WA_TOT1-CHARG,WA_TOT1-QTY.
*    ENDLOOP.
*    EXIT.
*  ENDIF.

*  **************alreday dispatch***
  CLEAR : B.
  LOOP AT IT_TOT1 INTO WA_TOT1.
    READ TABLE IT_UPD4 INTO WA_UPD4 WITH KEY STYPE = WA_TOT1-STYPE CHARG = WA_TOT1-CHARG.
    IF SY-SUBRC EQ 4.
      WA_UPD5-STYPE = WA_TOT1-STYPE.
      WA_UPD5-CHARG = WA_TOT1-CHARG.
      WA_UPD5-QTY = WA_TOT1-QTY.
      B = 1.
      CONDENSE  WA_UPD5-QTY.
      COLLECT WA_UPD5 INTO IT_UPD5.
      CLEAR WA_UPD5.
    ENDIF.
  ENDLOOP.



  IF B EQ 1.
    FORMAT COLOR 6.
    IF IT_UPD3 IS NOT INITIAL.
      WRITE : / 'FOLLOWING ENTRIES ARE ALREADY DISPATCHED' .
    ENDIF.
    LOOP AT IT_UPD5 INTO WA_UPD5.
      WRITE : / WA_UPD5-STYPE,WA_UPD5-CHARG,WA_UPD5-QTY.
    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  STATUS_9004  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_9004 OUTPUT.
  SET PF-STATUS 'STATUS'.
  SET TITLEBAR 'TITLE1'.
  PERFORM ALV4.
  CASE OK_CODE4.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      CLEAR: OK_CODE4.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.
