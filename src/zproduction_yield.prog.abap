*&---------------------------------------------------------------------*
*& Report  ZPRODUCTION_YIELD
*&DEVELOPD BY JYOTSNA 28.7.22 TO CHECK PRODUCTION YIELD AT VARIOS LEVELS.
*&---------------------------------------------------------------------*
*&24.2.25-- mapped halb batch from order for MPT BATCHES- JYOTSNA
*&
*&---------------------------------------------------------------------*
REPORT ZPRODUCTION_YIELD NO STANDARD PAGE HEADING LINE-SIZE 200.
TABLES AFPO.

TYPES: BEGIN OF TY_RESULT,
         MATNR TYPE MATNR,
         CHARG TYPE CHARG_D,
         GRAN  TYPE AFVV-GMNGA,
         COMP  TYPE AFVV-GMNGA,
         COAT  TYPE AFVV-GMNGA,
         INSP  TYPE AFVV-GMNGA,
         BULK  TYPE AFVV-GMNGA,
         FPRD  TYPE AFVV-GMNGA,
         GRANA TYPE P DECIMALS 3,
         COMPA TYPE P DECIMALS 3,
         COATA TYPE P DECIMALS 3,
         INSPA TYPE P DECIMALS 3,
         BULKA TYPE P DECIMALS 3,
         FPRDA TYPE P DECIMALS 3,
         GRANR TYPE P DECIMALS 3,
         COMPR TYPE P DECIMALS 3,
         COATR TYPE P DECIMALS 3,
         INSPR TYPE P DECIMALS 3,
         BULKR TYPE P DECIMALS 3,
         FPRDR TYPE P DECIMALS 3,
*          TYPE P DECIMALS 3,
       END OF TY_RESULT.

DATA : GV_FLAG   .
TYPES : BEGIN OF ITAB3,
          CHARG   TYPE AFPO-CHARG,
          MATNR   TYPE AFPO-MATNR,
          PER1    TYPE P DECIMALS 2,
          PER2    TYPE P DECIMALS 2,
          PER3    TYPE P DECIMALS 2,
          PER4    TYPE P DECIMALS 2,
          PER5    TYPE P DECIMALS 2,
          PER6    TYPE P DECIMALS 2,
          AQTY1   TYPE P DECIMALS 3,
          RQTY1   TYPE P DECIMALS 3,
          AQTY2   TYPE P DECIMALS 3,
          RQTY2   TYPE P DECIMALS 3,
          AQTY3   TYPE P DECIMALS 3,
          RQTY3   TYPE P DECIMALS 3,
          AQTY4   TYPE P DECIMALS 3,
          RQTY4   TYPE P DECIMALS 3,
          AQTY5   TYPE P DECIMALS 3,
          RQTY5   TYPE P DECIMALS 3,
          SQTY5   TYPE P DECIMALS 3,
          INSPQTY TYPE P DECIMALS 3,
          RQTY6   TYPE P DECIMALS 3,
        END OF ITAB3.


TYPES TT_RESULT_TABLE TYPE TABLE OF TY_RESULT WITH EMPTY KEY.
DATA GT_RESULT TYPE TT_RESULT_TABLE.

DATA : IT_FCAT   TYPE SLIS_T_FIELDCAT_ALV,
       WA_FCAT   TYPE SLIS_FIELDCAT_ALV,
       WA_LAYOUT TYPE SLIS_LAYOUT_ALV.

SELECTION-SCREEN BEGIN OF BLOCK MERKMALE1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS : S_MATNR FOR AFPO-MATNR .
  SELECT-OPTIONS : S_CHARG FOR AFPO-CHARG .
  PARAMETERS :  P_WERKS LIKE AFPO-DWERK .
  PARAMETERS : R1 RADIOBUTTON GROUP R1,
               R2 RADIOBUTTON GROUP R1.

SELECTION-SCREEN END OF BLOCK MERKMALE1.

INITIALIZATION.


AT SELECTION-SCREEN.
  PERFORM AUTHORIZATION.
  IF P_WERKS IS INITIAL.
    MESSAGE 'ENTER PLANT' TYPE 'E'.
  ENDIF.
  IF S_CHARG IS INITIAL.
    MESSAGE 'ENTER BATCH' TYPE 'E'.
  ENDIF.

  IF S_MATNR IS INITIAL.
    MESSAGE 'ENTER MATERIAL' TYPE 'E'.
  ENDIF.

START-OF-SELECTION .
  PERFORM GET_DATA.
  PERFORM PREPARE_FIELD_CAT .
  PERFORM DISPLAY_ALV.




*&---------------------------------------------------------------------*
*&      Form  TOP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM TOP.

  DATA: COMMENT    TYPE SLIS_T_LISTHEADER,
        WA_COMMENT LIKE LINE OF COMMENT.

  WA_COMMENT-TYP = 'A'.
  WA_COMMENT-INFO = 'BATCH WISE, STAGE WISE YIELD PERCENTGE'.
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
*&      Form  AUTHORIZATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM AUTHORIZATION .

  AUTHORITY-CHECK OBJECT 'M_BCO_WERK'
         ID 'WERKS' FIELD P_WERKS.
  IF SY-SUBRC <> 0.
*    CONCATENATE 'No authorization for Plant' P_WERKS INTO MSG
*    SEPARATED BY SPACE.
*    MESSAGE MSG TYPE 'E'.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_DATA .
  "1. Process Orders

  SELECT AUFNR, MATNR, CHARG, DWERK, DAUAT , PSMNG , WEMNG
  FROM AFPO
  INTO TABLE @DATA(LT_AFPO)
        WHERE MATNR IN @S_MATNR
        AND   CHARG IN @S_CHARG
        AND   DWERK = @P_WERKS.

  IF LT_AFPO IS INITIAL.
    MESSAGE 'No process orders found for given input.' TYPE 'I'.
    EXIT.
  ENDIF.


  "4. Order Header
  IF LT_AFPO IS NOT INITIAL.
    SELECT AUFNR, AUFPL
    FROM AFKO
    INTO TABLE @DATA(LT_AFKO)
          FOR ALL ENTRIES IN @LT_AFPO
          WHERE AUFNR = @LT_AFPO-AUFNR.
    IF LT_AFKO IS NOT INITIAL.
*
      SELECT  A~AUFNR,
              A~MATNR,
              A~CHARG
      FROM AUFM AS A
      INNER JOIN MARA AS B
      ON A~MATNR = B~MATNR
      INTO TABLE @DATA(LT_AUFM)
            FOR ALL ENTRIES IN @LT_AFKO
            WHERE A~AUFNR = @LT_AFKO-AUFNR
            AND A~BWART = '261'
            AND B~MTART = 'ZHLB'.

      IF LT_AUFM IS NOT INITIAL.
        SELECT  AUFNR,
                MATNR,
                CHARG,
                PSMNG ,
                WEMNG
        FROM AFPO
        FOR ALL ENTRIES IN @LT_AUFM
        WHERE MATNR = @LT_AUFM-MATNR
        AND   CHARG = @LT_AUFM-CHARG
        INTO TABLE @DATA(LT_AFPO_1).
      ENDIF.
      "--- Step 3: Get AUFPL from AFKO (based on AFPO-AUFNR)
      IF LT_AFPO_1 IS NOT INITIAL.
        SELECT  AUFNR,
                AUFPL
        FROM AFKO
        FOR ALL ENTRIES IN @LT_AFPO_1
        WHERE AUFNR = @LT_AFPO_1-AUFNR
        INTO TABLE @DATA(LT_AFKO_1).
      ENDIF.

      "--- Step 4: Get GMNGA and SMENG from AFRU using AUFPL & VORNR = '0020'
      IF LT_AFKO_1 IS NOT INITIAL.
        SELECT  AUFPL,
                VORNR,
                GMNGA,
                SMENG
        FROM AFRU
        FOR ALL ENTRIES IN @LT_AFKO_1
        WHERE AUFPL = @LT_AFKO_1-AUFPL
        INTO TABLE @DATA(LT_AFRU).
      ENDIF.
      IF LT_AFKO_1 IS NOT INITIAL.
        SELECT  A~AUFNR,
                A~MATNR,
                A~CHARG
        FROM AUFM AS A
        INNER JOIN MARA AS B
        ON A~MATNR = B~MATNR
        INTO TABLE @DATA(LT_AUFM_1)
              FOR ALL ENTRIES IN @LT_AFKO_1
              WHERE A~AUFNR = @LT_AFKO_1-AUFNR
              AND A~BWART = '261'
              AND B~MTART = 'ZHLB'.

        IF LT_AUFM_1 IS NOT INITIAL.
          SELECT AUFNR,
                 MATNR,
                 CHARG ,
                 PSMNG ,
                 WEMNG
          FROM AFPO
          FOR ALL ENTRIES IN @LT_AUFM_1
          WHERE MATNR = @LT_AUFM_1-MATNR
          AND   CHARG = @LT_AUFM_1-CHARG
          INTO TABLE @DATA(LT_AFPO_2).
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.


  "6. Inspection Lots
  IF LT_AFPO IS NOT INITIAL.
    SELECT PRUEFLOS, AUFNR, LMENGEIST, LMENGE01, OBJNR
    FROM QALS
    INTO TABLE @DATA(LT_QALS)
          FOR ALL ENTRIES IN @LT_AFPO
          WHERE AUFNR = @LT_AFPO-AUFNR.

    SELECT OBJNR
    FROM JEST
    INTO TABLE @DATA(LT_JEST)
          FOR ALL ENTRIES IN @LT_QALS
          WHERE OBJNR = @LT_QALS-OBJNR
          AND STAT =  'I0224'
          AND INACT = ''.

    LOOP AT LT_JEST INTO DATA(LS_JEST).
      DELETE LT_QALS WHERE OBJNR = LS_JEST-OBJNR.
    ENDLOOP.

  ENDIF.

  "11. Build Final Output
  LOOP AT LT_AFPO ASSIGNING FIELD-SYMBOL(<FS_AFPO>).
    IF <FS_AFPO>-DAUAT = 'ZNF1' OR <FS_AFPO>-DAUAT = 'ZNF4' OR <FS_AFPO>-DAUAT = 'ZGF1'.
      GV_FLAG = 'X' .
    ENDIF.

    DATA(GS_RESULT) = VALUE TY_RESULT( ).

    GS_RESULT-FPRDA = <FS_AFPO>-PSMNG.
    GS_RESULT-FPRDR = <FS_AFPO>-WEMNG.
    IF <FS_AFPO>-PSMNG IS NOT INITIAL.
      GS_RESULT-FPRD = ( <FS_AFPO>-WEMNG / <FS_AFPO>-PSMNG ) * 100 .
    ENDIF.

    GS_RESULT-CHARG = <FS_AFPO>-CHARG.
    GS_RESULT-MATNR = <FS_AFPO>-MATNR.
    "Order Header
    READ TABLE LT_AFKO WITH KEY AUFNR = <FS_AFPO>-AUFNR INTO DATA(LS_AFKO).
    IF SY-SUBRC = 0.

**********
      READ TABLE LT_AUFM INTO DATA(LS_AUFM) WITH KEY AUFNR = LS_AFKO-AUFNR.
      IF SY-SUBRC IS INITIAL.
        READ TABLE LT_AFPO_1 INTO DATA(LS_AFPO_1)
              WITH KEY MATNR = LS_AUFM-MATNR
              CHARG = LS_AUFM-CHARG  .
        IF SY-SUBRC IS INITIAL.
**********  Bulk Yeild
          GS_RESULT-BULK = ( LS_AFPO_1-WEMNG / LS_AFPO_1-PSMNG ) * 100.
          GS_RESULT-BULKR =  LS_AFPO_1-WEMNG .
          GS_RESULT-BULKA =   LS_AFPO_1-PSMNG .

          READ TABLE LT_AFKO_1 WITH KEY AUFNR = LS_AFPO_1-AUFNR INTO DATA(LS_AFKO_1) .
          IF SY-SUBRC IS INITIAL.
**********    Compression

            READ TABLE LT_AFRU INTO DATA(LS_AFRU) WITH KEY AUFPL = LS_AFKO_1-AUFPL
                  VORNR = '0020'.
            IF SY-SUBRC IS INITIAL.
              GS_RESULT-COMPA =  LS_AFRU-SMENG .
              GS_RESULT-COMPR =  LS_AFRU-GMNGA .
              IF LS_AFRU-SMENG > 0.
                GS_RESULT-COMP = ( LS_AFRU-GMNGA / LS_AFRU-SMENG ) * 100.
              ENDIF.
            ENDIF.

**********   Coating
            READ TABLE LT_AFRU INTO LS_AFRU WITH KEY AUFPL = LS_AFKO_1-AUFPL
            VORNR = '0040'.
            IF SY-SUBRC IS INITIAL.
              GS_RESULT-COATA =  LS_AFRU-SMENG .
              GS_RESULT-COATR =  LS_AFRU-GMNGA .
              IF LS_AFRU-SMENG > 0.
                GS_RESULT-COAT = ( LS_AFRU-GMNGA / LS_AFRU-SMENG ) * 100.
              ENDIF.
            ENDIF.

*********   Granulation / Blend
            READ TABLE LT_AUFM_1 INTO DATA(LS_AUFM_1) WITH KEY AUFNR = LS_AFKO_1-AUFNR.
            IF SY-SUBRC IS INITIAL.
              READ TABLE LT_AFPO_2 INTO DATA(LS_AFPO_2)
                    WITH KEY MATNR = LS_AUFM_1-MATNR
                    CHARG = LS_AUFM_1-CHARG  .
              IF SY-SUBRC IS INITIAL.

                GS_RESULT-GRANA =  LS_AFPO_2-PSMNG .
                GS_RESULT-GRANR =  LS_AFPO_2-WEMNG .
                IF LS_AFPO_2-PSMNG IS NOT INITIAL.
                  GS_RESULT-GRAN = ( LS_AFPO_2-WEMNG / LS_AFPO_2-PSMNG ) * 100.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    "Inspection Lot & UD Info
    READ TABLE LT_QALS WITH KEY AUFNR = <FS_AFPO>-AUFNR INTO DATA(LS_QALS).
    IF SY-SUBRC = 0.
      GS_RESULT-INSPA =  LS_QALS-LMENGEIST .
      GS_RESULT-INSPR =  LS_QALS-LMENGE01.
      IF LS_QALS-LMENGEIST > 0.
        GS_RESULT-INSP = ( LS_QALS-LMENGE01 / LS_QALS-LMENGEIST ) * 100.
      ENDIF.
    ENDIF.

    APPEND GS_RESULT TO GT_RESULT.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PREPARE_FIELD_CAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PREPARE_FIELD_CAT .
  IF R1 EQ 'X'.
    PERFORM FIELD_CAT_1.
  ELSEIF R2 EQ 'X'.
    PERFORM FIELD_CAT_2.
  ENDIF.
ENDFORM.


FORM FIELD_CAT_1 .
  DATA : LV_COUNT TYPE I VALUE '1'.
*  PERFORM FILL_FCAT USING p_field P_colpos P_ITAB p_desc_m p_edit P_SUM..
  PERFORM FILL_FCAT USING 'CHARG'       LV_COUNT  'BATCH'             . LV_COUNT = LV_COUNT + 1.
  PERFORM FILL_FCAT USING 'MATNR'       LV_COUNT  'MATERIAL NO.'     . LV_COUNT = LV_COUNT + 1.
  IF GV_FLAG = 'X'.
    PERFORM FILL_FCAT USING 'GRAN'   LV_COUNT  'Granulation'         . LV_COUNT = LV_COUNT + 1.
    PERFORM FILL_FCAT USING 'COMP'   LV_COUNT  'COMPRESSION %'       . LV_COUNT = LV_COUNT + 1.
    PERFORM FILL_FCAT USING 'COAT'   LV_COUNT  'COATING %'           . LV_COUNT = LV_COUNT + 1.
    PERFORM FILL_FCAT USING 'INSP'   LV_COUNT  'INSPECTION %'        . LV_COUNT = LV_COUNT + 1.
    PERFORM FILL_FCAT USING 'FPRD'   LV_COUNT  'FINISHED PRODUCT %'  . LV_COUNT = LV_COUNT + 1.
  ELSE.
    PERFORM FILL_FCAT USING 'BULK'  LV_COUNT  'Bulk Yield'          . LV_COUNT = LV_COUNT + 1.
    PERFORM FILL_FCAT USING 'FPRD'  LV_COUNT  'FINISHED PRODUCT %'  . LV_COUNT = LV_COUNT + 1.
  ENDIF.

ENDFORM.

FORM FIELD_CAT_2 .
  DATA : LV_COUNT TYPE I VALUE '1'.
  PERFORM FILL_FCAT USING 'CHARG'       LV_COUNT  'BATCH'             . LV_COUNT = LV_COUNT + 1.
  PERFORM FILL_FCAT USING 'MATNR'       LV_COUNT  'MATERIAL NO.'     . LV_COUNT = LV_COUNT + 1.
  IF GV_FLAG = 'X'.
  PERFORM FILL_FCAT USING 'GRANA'  LV_COUNT  'BLEND ACT QTY'             . LV_COUNT = LV_COUNT + 1.
  PERFORM FILL_FCAT USING 'GRANR'  LV_COUNT  'BLEND REC QTY'             . LV_COUNT = LV_COUNT + 1.
  PERFORM FILL_FCAT USING 'GRAN'   LV_COUNT  'BLEND %'             . LV_COUNT = LV_COUNT + 1.

  PERFORM FILL_FCAT USING 'COMPA'  LV_COUNT  'COMP. ACT QTY'       . LV_COUNT = LV_COUNT + 1.
  PERFORM FILL_FCAT USING 'COMPR'  LV_COUNT  'COMP. REC QTY'       . LV_COUNT = LV_COUNT + 1.
  PERFORM FILL_FCAT USING 'COMP'   LV_COUNT  'COMPRESSION %'       . LV_COUNT = LV_COUNT + 1.

  PERFORM FILL_FCAT USING 'COATA'  LV_COUNT  'COAT. ACT QTY'           . LV_COUNT = LV_COUNT + 1.
  PERFORM FILL_FCAT USING 'COATR'  LV_COUNT  'COAT. REC QTY'           . LV_COUNT = LV_COUNT + 1.
  PERFORM FILL_FCAT USING 'COAT'   LV_COUNT  'COATING %'           . LV_COUNT = LV_COUNT + 1.
  ELSE.
  PERFORM FILL_FCAT USING 'BULKA'  LV_COUNT  'Bulk Act Qty'          . LV_COUNT = LV_COUNT + 1.
  PERFORM FILL_FCAT USING 'BULKR'  LV_COUNT  'Bulk Rec Qty'          . LV_COUNT = LV_COUNT + 1.
  PERFORM FILL_FCAT USING 'BULK'  LV_COUNT  'Bulk Yield'          . LV_COUNT = LV_COUNT + 1.

  PERFORM FILL_FCAT USING 'INSPA'  LV_COUNT  'INSP. ACT QTY'        . LV_COUNT = LV_COUNT + 1.
  PERFORM FILL_FCAT USING 'INSPR'  LV_COUNT  'INSP. REC QTY'        . LV_COUNT = LV_COUNT + 1.
  PERFORM FILL_FCAT USING 'INSP'   LV_COUNT  'INSPECTION %'        . LV_COUNT = LV_COUNT + 1.

  PERFORM FILL_FCAT USING 'FPRDA'   LV_COUNT  'FINISHED ACT QTY'  . LV_COUNT = LV_COUNT + 1.
  PERFORM FILL_FCAT USING 'FPRDR'   LV_COUNT  'FINISHED REC QTY'  . LV_COUNT = LV_COUNT + 1.
  PERFORM FILL_FCAT USING 'FPRD'    LV_COUNT  'FINISHED PRODUCT %'  . LV_COUNT = LV_COUNT + 1.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form FILL_FCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> FIELD
*&      --> LENGTH
*&      --> DESC_M
*&      --> EDIT
*&---------------------------------------------------------------------*
FORM FILL_FCAT  USING    P_FIELD
      P_COLPOS
      P_DESC_M
      .
  WA_FCAT-FIELDNAME = P_FIELD.
  WA_FCAT-COL_POS   = P_COLPOS.
  WA_FCAT-SELTEXT_M = P_DESC_M.
  WA_FCAT-TABNAME   = 'GT_RESULT'.

  APPEND WA_FCAT TO IT_FCAT.

ENDFORM.

*& Form DISPLAY_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV .

  WA_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
  WA_LAYOUT-ZEBRA = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM = SY-REPID
      IS_LAYOUT          = WA_LAYOUT
      IT_FIELDCAT        = IT_FCAT
    TABLES
      T_OUTTAB           = GT_RESULT
    EXCEPTIONS
      PROGRAM_ERROR      = 1
      OTHERS             = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.
