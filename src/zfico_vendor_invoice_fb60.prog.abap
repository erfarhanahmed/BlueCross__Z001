*&---------------------------------------------------------------------*
*& Report ZFICO_VENDOR_INVOICE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFICO_VENDOR_INVOICE_FB60.

TYPES : BEGIN OF TY_FILE,
*DOCUMENTHEADER
          SR_NO(3)       TYPE   C,  "001
          BUS_ACT        TYPE   GLVOR,
          HEADER_TXT     TYPE   BKTXT,
          COMP_CODE      TYPE   BUKRS,
          DOC_DATE(10)   TYPE   C ,   "   BLDAT,
          PSTNG_DATE(10) TYPE   C  ,   "BUDAT,
          FISC_YEAR      TYPE   GJAHR,
          DOC_TYPE       TYPE   BLART,
          REF_DOC_NO     TYPE   XBLNR,
          DE_CRE_IND     TYPE   ACPI_TBTKZ,
* ACCOUNTGL
          ITEMNO_ACC     TYPE   POSNR_ACC,
          GL_ACCOUNT     TYPE   HKONT,
          ITEM_TEXT      TYPE   SGTXT,
          ALLOC_NMBR     TYPE   ACPI_ZUONR,
          TAX_CODE       TYPE   MWSKZ,
          COSTCENTER     TYPE   KOSTL,
          ITEMNO_TAX     TYPE   TAXPS,
*ACCOUNTPAYABLE
*    ITEMNO_ACC_v    TYPE   POSNR_ACC,
          VENDOR_NO      TYPE   LIFNR,
          ITEM_TEXT_1    TYPE   SGTXT,
          BUSINESSPLACE  TYPE   ACPI_BRANCH,
          SECTIONCODE    TYPE   ACPI_SECCO1,

*ACCOUNTTAX
*   ITEMNO_ACC_1      TYPE POSNR_ACC,
          GL_ACCOUNT_1   TYPE HKONT,
          COND_KEY       TYPE KSCHL,
          ACCT_KEY       TYPE KTOSL,
          TAX_CODE_1     TYPE MWSKZ,
          TAX_RATE       TYPE MSATZ_F05L,
          ITEMNO_TAX_1   TYPE TAXPS,
*CURRENCYAMOUNT
*    ITEMNO_ACC_c    TYPE   POSNR_ACC,
          CURRENCY       TYPE   WAERS,
          AMT_DOCCUR     TYPE   BAPIDOCCUR,
          AMT_BASE       TYPE   BAPIAMTBASE,
          QUANTITY       TYPE MENGE_D,
          BASE_UOM       TYPE MEINS,
          HSN_SAC        TYPE J_1IG_HSN_SAC,
          BELNR(10)      TYPE C,
          REMARK(100)    TYPE C,


        END OF  TY_FILE.

TYPES : BEGIN OF TY_FILE1,
          SR_NO(3)     TYPE   C,  "001
          DE_CRE_IND   TYPE   ACPI_TBTKZ,
          ITEMNO_ACC   TYPE   POSNR_ACC,
          GL_ACCOUNT   TYPE   HKONT,
          GL_ACCOUNT_1 TYPE   HKONT,
          TAX_CODE     TYPE   MWSKZ,
          ITEMNO_TAX   TYPE   TAXPS,
          VENDOR_NO    TYPE   LIFNR,
          COND_KEY     TYPE   KSCHL,
          ACCT_KEY     TYPE   KTOSL,
          CURRENCY     TYPE   WAERS,
          TAX_RATE     TYPE   MSATZ_F05L,
          AMT_DOCCUR   TYPE   BAPIDOCCUR,
          AMT_BASE     TYPE   BAPIAMTBASE,

        END OF TY_FILE1.

DATA : WA_RETURN         LIKE  BAPIRET2 OCCURS 0 WITH HEADER LINE.
DATA : WA_DOCUMENTHEADER LIKE  BAPIACHE09 OCCURS 0 WITH HEADER LINE.
DATA : WA_ACCOUNTGL      LIKE  BAPIACGL09 OCCURS 0 WITH HEADER LINE.
DATA : WA_ACCOUNTPAYABLE LIKE  BAPIACAP09 OCCURS 0 WITH HEADER LINE.
DATA : WA_ACCOUNTTAX     LIKE  BAPIACTX09 OCCURS 0 WITH HEADER LINE.
DATA : WA_CURRENCYAMOUNT LIKE  BAPIACCR09 OCCURS 0 WITH HEADER LINE.
DATA  EXTENSION1        TYPE TABLE OF BAPIACEXTC WITH HEADER LINE.

DATA :OBJ_TYPE LIKE BAPIACHE08-OBJ_TYPE,
      OBJ_KEY  LIKE BAPIACHE02-OBJ_KEY,
      OBJ_SYS  LIKE BAPIACHE02-OBJ_SYS.

DATA: LV_TDC_CAL TYPE BSEG_ALV-AZBET .
DATA: IT_FIELDCAT  TYPE SLIS_T_FIELDCAT_ALV.
DATA: WA_FIELDCAT  TYPE SLIS_FIELDCAT_ALV.
DATA: IS_LAYOUT TYPE SLIS_LAYOUT_ALV.


DATA : IT_DUMMY TYPE STANDARD TABLE OF TY_FILE1,
       WA_DUMMY TYPE TY_FILE1.

DATA: EXTENSION2 LIKE BAPIPAREX
    OCCURS 0 WITH HEADER LINE.
DATA : IT_FILE_1 TYPE STANDARD TABLE OF TY_FILE,
       WA_FILE_1 TYPE TY_FILE.
DATA : IT_FILE_11 TYPE STANDARD TABLE OF TY_FILE,
       WA_FILE_11 TYPE TY_FILE.
DATA : IT_FILE_12 TYPE STANDARD TABLE OF TY_FILE,
       WA_FILE_12 TYPE TY_FILE.

*DATA : it_file TYPE TABLE OF alsmex_tabline,
*       wa_file TYPE alsmex_tabline.
DATA : IT_FILE TYPE ALSMEX_TABLINE  OCCURS 0 WITH HEADER LINE.


DATA: IT_ACC TYPE TABLE OF BAPIACWT09,
      WA_ACC TYPE BAPIACWT09.

SELECTION-SCREEN BEGIN OF BLOCK A WITH FRAME TITLE TEXT-001.
  PARAMETERS : P_FILE TYPE RLGRAP-FILENAME,
               P_TEST TYPE CHAR1 AS CHECKBOX DEFAULT 'X'.

SELECTION-SCREEN END OF BLOCK A.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      PROGRAM_NAME  = SYST-CPROG
      DYNPRO_NUMBER = SYST-DYNNR
*     FIELD_NAME    = ' '
    IMPORTING
      FILE_NAME     = P_FILE.

START-OF-SELECTION.

  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      FILENAME                = P_FILE
      I_BEGIN_COL             = '1'
      I_BEGIN_ROW             = '2'
      I_END_COL               = '24'
      I_END_ROW               = '9999'
    TABLES
      INTERN                  = IT_FILE
    EXCEPTIONS
      INCONSISTENT_PARAMETERS = 1
      UPLOAD_OLE              = 2
      OTHERS                  = 3.

  LOOP AT IT_FILE.

    CASE IT_FILE-COL.
      WHEN 1.
        WA_FILE_1-SR_NO        = IT_FILE-VALUE.
*      WHEN 2.
*        wa_file_1-BUS_ACT      = it_file-value.
      WHEN 2.
        WA_FILE_1-HEADER_TXT   = IT_FILE-VALUE.
      WHEN 3.
        WA_FILE_1-COMP_CODE    = IT_FILE-VALUE.
      WHEN 4.
        WA_FILE_1-DOC_DATE     = IT_FILE-VALUE.
      WHEN 5.
        WA_FILE_1-PSTNG_DATE     = IT_FILE-VALUE.
      WHEN 6.
        WA_FILE_1-FISC_YEAR     = IT_FILE-VALUE.
      WHEN 7.
        WA_FILE_1-DOC_TYPE     = IT_FILE-VALUE.
      WHEN 8.
        WA_FILE_1-REF_DOC_NO   = IT_FILE-VALUE.
      WHEN 9.
        WA_FILE_1-DE_CRE_IND   = IT_FILE-VALUE.
      WHEN 10.
        WA_FILE_1-ITEMNO_ACC   = IT_FILE-VALUE.
      WHEN 11.
        WA_FILE_1-GL_ACCOUNT   = IT_FILE-VALUE.
      WHEN 12.
        WA_FILE_1-ITEM_TEXT    = IT_FILE-VALUE.
      WHEN 13.
        WA_FILE_1-ALLOC_NMBR  = IT_FILE-VALUE.
      WHEN 14.
        WA_FILE_1-TAX_CODE     = IT_FILE-VALUE.
      WHEN 15.
        WA_FILE_1-COSTCENTER   = IT_FILE-VALUE.
*       WHEN 16.
*        wa_file_1-ITEMNO_TAX   = it_file-value.  "COMMENTED
      WHEN 16.
        WA_FILE_1-VENDOR_NO    = IT_FILE-VALUE.
*       WHEN 15.
*        wa_file_1-ITEM_TEXT_1  = it_file-value.
      WHEN 17.
        WA_FILE_1-BUSINESSPLACE  = IT_FILE-VALUE.
      WHEN 18.
        WA_FILE_1-SECTIONCODE    = IT_FILE-VALUE.
*      WHEN 18.
*        wa_file_1-GL_ACCOUNT_1   = it_file-value.
*      WHEN 20.
*           wa_file_1-COND_KEY   = it_file-value.
*      WHEN 21.
*         wa_file_1-ACCT_KEY      = it_file-value. COMMENTED
**      WHEN 20.
**        wa_file_1-TAX_CODE_1     = it_file-value.
*      WHEN 22.
*        wa_file_1-TAX_RATE       = it_file-value.
*      WHEN 22.
*         wa_file_1-ITEMNO_TAX_1  = it_file-value.
      WHEN 19.
        WA_FILE_1-CURRENCY       = IT_FILE-VALUE.
      WHEN 20.
        WA_FILE_1-AMT_DOCCUR     = IT_FILE-VALUE.
      WHEN 21.
        WA_FILE_1-AMT_BASE       = IT_FILE-VALUE.
      WHEN 22.
        WA_FILE_1-QUANTITY = IT_FILE-VALUE.
      WHEN 23.
        WA_FILE_1-BASE_UOM = IT_FILE-VALUE.
*    BASE_UOM TYPE MEINS,
      WHEN 24.
        WA_FILE_1-HSN_SAC = IT_FILE-VALUE.


    ENDCASE.

    AT END OF ROW .
      APPEND WA_FILE_1 TO IT_FILE_1.
      CLEAR WA_FILE_1.
    ENDAT.
    CLEAR : IT_FILE.
  ENDLOOP.

  DATA : LV_KBETR TYPE KBETR,
         LV_ITEM1 TYPE I,
         LV_COUNT TYPE P DECIMALS 3,
         LV_PER   TYPE P DECIMALS 3,
         LV_PER1  TYPE P DECIMALS 3,
         LV_PER2  TYPE P DECIMALS 3,
         LV_PER3  TYPE P DECIMALS 3.

*calculating amount tax for item AMT_DOCCUR
  SORT IT_FILE_1 BY SR_NO.

  IF IT_FILE_1 IS NOT INITIAL .
    LOOP AT IT_FILE_1 INTO WA_FILE_1 .

    if wa_file_1-BUSINESSPLACE is not INITIAL.
DATA(bus) = wa_file_1-BUSINESSPLACE.
ENDIF.

      IF  WA_FILE_1-TAX_CODE IS NOT INITIAL AND  WA_FILE_1-TAX_CODE NE 'V0'.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            INPUT  = WA_FILE_1-GL_ACCOUNT
          IMPORTING
            OUTPUT = WA_FILE_1-GL_ACCOUNT.
        APPEND WA_ACCOUNTGL.
        """" If tax code X series..................
        IF  WA_FILE_1-TAX_CODE+(1) = 'X'.
          WA_DUMMY-SR_NO = WA_FILE_1-SR_NO.
          SELECT SINGLE * FROM T030K INTO  @DATA(WA_JII) WHERE KTOPL = '1000' AND MWSKZ = @WA_FILE_1-TAX_CODE.

          IF WA_JII-KTOSL = 'JII'.



            LV_COUNT = LV_COUNT + 1.
            IF WA_FILE_1-DE_CRE_IND = 'H'.
              WA_DUMMY-AMT_DOCCUR = WA_FILE_1-AMT_DOCCUR * -1.
            ENDIF.
            LV_ITEM1 = LV_ITEM1 + 1.
            WA_DUMMY-ITEMNO_ACC   = LV_ITEM1.
            WA_DUMMY-DE_CRE_IND   = WA_FILE_1-DE_CRE_IND.
            WA_DUMMY-ITEMNO_TAX   = LV_ITEM1.
            WA_DUMMY-GL_ACCOUNT   = WA_FILE_1-GL_ACCOUNT.
            WA_DUMMY-TAX_CODE     = WA_FILE_1-TAX_CODE.
            WA_DUMMY-VENDOR_NO    = WA_FILE_1-VENDOR_NO.
            WA_DUMMY-AMT_DOCCUR   = WA_FILE_1-AMT_DOCCUR.
            WA_DUMMY-AMT_BASE    = WA_FILE_1-AMT_DOCCUR.

            SELECT SINGLE KSCHL,
               ALAND,
               MWSKZ,
               KNUMH
               FROM A003
               INTO  @DATA(WA_A003_JII)
               WHERE MWSKZ = @WA_FILE_1-TAX_CODE
               AND   KSCHL  IN ( 'JIIG'  ) .
            WA_DUMMY-COND_KEY =  WA_A003_JII-KSCHL.

*condition record no and amount
            SELECT SINGLE KNUMH ,
                  KBETR FROM KONP
                  INTO @DATA(WA_KONP_JII)
                   WHERE KNUMH = @WA_A003_JII-KNUMH.

            WA_KONP_JII-KBETR =  WA_KONP_JII-KBETR / 10 .
            WA_DUMMY-TAX_RATE   = WA_KONP_JII-KBETR .
*GL account
            if bus = 'IS27'.


                  SELECT SINGLE * FROM J_1IT030K INTO  @data(WA_ISD_GL) WHERE BUPLA = 'IS27' AND MWSKZ = @WA_FILE_1-TAX_CODE
                                                                       AND  KTOSL IN ( 'JII' ).

                  WA_DUMMY-GL_ACCOUNT_1  =  WA_ISD_GL-KONTS.
                  WA_DUMMY-ACCT_KEY      =  WA_ISD_GL-KTOSL.
CLEAR: WA_ISD_GL.
              ELSE.
            SELECT SINGLE KTOPL,
                    KTOSL,
                    MWSKZ,
                    LAND1,
                    KONTS,
                    KONTH FROM  T030K
                    INTO  @DATA(WA_T030K_JII)
                    WHERE MWSKZ = @WA_FILE_1-TAX_CODE
                    AND   KTOSL IN ( 'JII' ).
            WA_DUMMY-GL_ACCOUNT_1  =  WA_T030K_JII-KONTS.
            WA_DUMMY-ACCT_KEY      =  WA_T030K_JII-KTOSL.
            endif.

*     WA_DUMMY-TAX_RATE =  WA_DUMMY-TAX_RATE + WA_DUMMY-TAX_RATE.

            LV_PER   = 100 +  WA_DUMMY-TAX_RATE.
            LV_PER2  =   WA_DUMMY-AMT_DOCCUR.

            LV_PER2     =  LV_PER2 * WA_KONP_JII-KBETR / LV_PER .
*    LV_PER2     =  LV_PER2 / 2.
            WA_DUMMY-AMT_DOCCUR   = LV_PER2.

            APPEND WA_DUMMY TO IT_DUMMY.
            CLEAR :WA_DUMMY , LV_PER,LV_PER2,WA_KONP_JII,WA_T030K_JII, WA_A003_JII.

          ELSE.
            DO 2 TIMES.
              LV_COUNT = LV_COUNT + 1.
              IF WA_FILE_1-DE_CRE_IND = 'H'.
                WA_DUMMY-AMT_DOCCUR = WA_FILE_1-AMT_DOCCUR * -1.
              ENDIF.
              LV_ITEM1 = LV_ITEM1 + 1.
              WA_DUMMY-ITEMNO_ACC   = LV_ITEM1.
              WA_DUMMY-DE_CRE_IND   = WA_FILE_1-DE_CRE_IND.
              WA_DUMMY-ITEMNO_TAX   = LV_ITEM1.
              WA_DUMMY-GL_ACCOUNT   = WA_FILE_1-GL_ACCOUNT.
              WA_DUMMY-TAX_CODE     = WA_FILE_1-TAX_CODE.
              WA_DUMMY-VENDOR_NO    = WA_FILE_1-VENDOR_NO.
              WA_DUMMY-AMT_DOCCUR   = WA_FILE_1-AMT_DOCCUR.
              WA_DUMMY-AMT_BASE    = WA_FILE_1-AMT_DOCCUR.
              WA_DUMMY-SR_NO = WA_FILE_1-SR_NO.

*condition record no
              IF LV_COUNT = 1.
                SELECT SINGLE KSCHL,
                       ALAND,
                       MWSKZ,
                       KNUMH
                       FROM A003
                       INTO  @DATA(WA_A003)
                       WHERE MWSKZ = @WA_FILE_1-TAX_CODE
                       AND   KSCHL  IN ( 'JICG'  ) .
                WA_DUMMY-COND_KEY =  WA_A003-KSCHL.

*condition record no and amount
                SELECT SINGLE KNUMH ,
                      KBETR FROM KONP
                      INTO @DATA(WA_KONP)
                       WHERE KNUMH = @WA_A003-KNUMH.

                WA_KONP-KBETR =  WA_KONP-KBETR / 10 .
                WA_DUMMY-TAX_RATE   = WA_KONP-KBETR .
*GL account
                IF bus = 'IS27'.
                  CLEAR: WA_ISD_GL.
                  SELECT SINGLE * FROM J_1IT030K INTO  @WA_ISD_GL WHERE BUPLA = 'IS27' AND MWSKZ = @WA_FILE_1-TAX_CODE
                                                                       AND  KTOSL IN ( 'JIC' ).

                  WA_DUMMY-GL_ACCOUNT_1  =  WA_ISD_GL-KONTS.
                  WA_DUMMY-ACCT_KEY      =  WA_ISD_GL-KTOSL.

                ELSE.
                  SELECT SINGLE KTOPL,
                   KTOSL,
                   MWSKZ,
                   LAND1,
                   KONTS,
                   KONTH FROM  T030K
                   INTO  @DATA(WA_T030K)
                   WHERE MWSKZ = @WA_FILE_1-TAX_CODE
                   AND   KTOSL IN ( 'JIC' ).
                  WA_DUMMY-GL_ACCOUNT_1  =  WA_T030K-KONTS.
                  WA_DUMMY-ACCT_KEY      =  WA_T030K-KTOSL.
                ENDIF.


                WA_DUMMY-TAX_RATE =  WA_DUMMY-TAX_RATE + WA_DUMMY-TAX_RATE.

                LV_PER   = 100 +  WA_DUMMY-TAX_RATE.
                LV_PER2  =   WA_DUMMY-AMT_DOCCUR.

                LV_PER2     =  LV_PER2 * WA_KONP-KBETR / LV_PER .
*    LV_PER2     =  LV_PER2 / 2.
                WA_DUMMY-AMT_DOCCUR   = LV_PER2.

              ENDIF.
              IF LV_COUNT = 2.

                SELECT SINGLE KSCHL,
                     ALAND,
                     MWSKZ,
                     KNUMH
                     FROM A003
                     INTO  @DATA(WA_A003_1)
                     WHERE MWSKZ = @WA_FILE_1-TAX_CODE
                     AND   KSCHL  IN ( 'JISG'  ) .
                WA_DUMMY-COND_KEY =  WA_A003_1-KSCHL.

                SELECT SINGLE KNUMH ,
                 KBETR FROM KONP
                 INTO @DATA(WA_KONP_1)
                  WHERE KNUMH = @WA_A003_1-KNUMH.

                WA_KONP_1-KBETR     =  WA_KONP_1-KBETR / 10 .
                WA_DUMMY-TAX_RATE   = WA_KONP_1-KBETR .



                IF bus = 'IS27'.
                  CLEAR: WA_ISD_GL.
                  SELECT SINGLE * FROM J_1IT030K INTO  @WA_ISD_GL WHERE BUPLA = 'IS27' AND MWSKZ = @WA_FILE_1-TAX_CODE
                                                                       AND  KTOSL IN ( 'JIS' ).

                  WA_DUMMY-GL_ACCOUNT_1  =  WA_ISD_GL-KONTS.
                  WA_DUMMY-ACCT_KEY      =  WA_ISD_GL-KTOSL.

                ELSE.
                  SELECT SINGLE KTOPL,
                        KTOSL,
                        MWSKZ,
                        LAND1,
                        KONTS,
                        KONTH FROM  T030K
                        INTO  @DATA(WA_T030K_1)
                        WHERE MWSKZ = @WA_FILE_1-TAX_CODE
                        AND   KTOSL IN ( 'JIS' ).
                  WA_DUMMY-GL_ACCOUNT_1   =  WA_T030K_1-KONTS.
                  WA_DUMMY-ACCT_KEY       =  WA_T030K_1-KTOSL.
                ENDIF.

                WA_DUMMY-TAX_RATE =  WA_DUMMY-TAX_RATE + WA_DUMMY-TAX_RATE.

                LV_PER   = 100 +  WA_DUMMY-TAX_RATE.
                LV_PER2  =   WA_DUMMY-AMT_DOCCUR.

                LV_PER2     =  LV_PER2 * WA_KONP_1-KBETR / LV_PER .
*    LV_PER2     =  LV_PER2 / 2.
                WA_DUMMY-AMT_DOCCUR   = LV_PER2.

              ENDIF.

              APPEND WA_DUMMY TO IT_DUMMY.
              CLEAR :WA_DUMMY , LV_PER,LV_PER2,WA_KONP_1,WA_KONP,WA_T030K,WA_T030K_1, WA_A003_1, WA_A003.
            ENDDO.


          ENDIF.
          CLEAR :LV_COUNT,LV_ITEM1.
        ENDIF.

        """"""""" If tax code series Z**"""""""""""""""""
        IF  WA_FILE_1-TAX_CODE+(1) = 'Z'.
          WA_DUMMY-SR_NO = WA_FILE_1-SR_NO.
          SELECT SINGLE * FROM A003 INTO  @DATA(WA_JII_Z) WHERE  MWSKZ = @WA_FILE_1-TAX_CODE.

          IF WA_JII_Z-KSCHL = 'JIIN'.

            LV_COUNT = LV_COUNT + 1.
            IF WA_FILE_1-DE_CRE_IND = 'H'.
              WA_DUMMY-AMT_DOCCUR = WA_FILE_1-AMT_DOCCUR * -1.
            ENDIF.
            LV_ITEM1 = LV_ITEM1 + 1.
            WA_DUMMY-ITEMNO_ACC   = LV_ITEM1.
            WA_DUMMY-DE_CRE_IND   = WA_FILE_1-DE_CRE_IND.
            WA_DUMMY-ITEMNO_TAX   = LV_ITEM1.
            WA_DUMMY-GL_ACCOUNT   = WA_FILE_1-GL_ACCOUNT.
            WA_DUMMY-TAX_CODE     = WA_FILE_1-TAX_CODE.
            WA_DUMMY-VENDOR_NO    = WA_FILE_1-VENDOR_NO.
            WA_DUMMY-AMT_DOCCUR   = WA_FILE_1-AMT_DOCCUR.
            WA_DUMMY-AMT_BASE    = WA_FILE_1-AMT_DOCCUR.

            SELECT SINGLE KSCHL,
               ALAND,
               MWSKZ,
               KNUMH
               FROM A003
               INTO  @WA_A003_JII
               WHERE MWSKZ = @WA_FILE_1-TAX_CODE
               AND   KSCHL  IN ( 'JIIN'  ) .
            WA_DUMMY-COND_KEY =  WA_A003_JII-KSCHL.

*condition record no and amount
            SELECT SINGLE KNUMH ,
                  KBETR FROM KONP
                  INTO @WA_KONP_JII
                   WHERE KNUMH = @WA_A003_JII-KNUMH.

            WA_KONP_JII-KBETR =  WA_KONP_JII-KBETR / 10 .
            WA_DUMMY-TAX_RATE   = WA_KONP_JII-KBETR .
*GL account

*         WA_DUMMY-GL_ACCOUNT_1  = wa_file_1-GL_ACCOUNT .
            WA_DUMMY-ACCT_KEY      =  'NVV'.

*     WA_DUMMY-TAX_RATE =  WA_DUMMY-TAX_RATE + WA_DUMMY-TAX_RATE.

            LV_PER   = 100 +  WA_DUMMY-TAX_RATE.
            LV_PER2  =   WA_DUMMY-AMT_DOCCUR.

            LV_PER2     =  LV_PER2 * WA_KONP_JII-KBETR / LV_PER .
*    LV_PER2     =  LV_PER2 / 2.
            WA_DUMMY-AMT_DOCCUR   = LV_PER2.

            APPEND WA_DUMMY TO IT_DUMMY.
            CLEAR :WA_DUMMY , LV_PER,LV_PER2,WA_KONP_JII,WA_T030K_JII, WA_A003_JII.

          ELSE.
            DO 2 TIMES.
              LV_COUNT = LV_COUNT + 1.
              IF WA_FILE_1-DE_CRE_IND = 'H'.
                WA_DUMMY-AMT_DOCCUR = WA_FILE_1-AMT_DOCCUR * -1.
              ENDIF.
              LV_ITEM1 = LV_ITEM1 + 1.
              WA_DUMMY-ITEMNO_ACC   = LV_ITEM1.
              WA_DUMMY-DE_CRE_IND   = WA_FILE_1-DE_CRE_IND.
              WA_DUMMY-ITEMNO_TAX   = LV_ITEM1.
              WA_DUMMY-GL_ACCOUNT   = WA_FILE_1-GL_ACCOUNT.
              WA_DUMMY-TAX_CODE     = WA_FILE_1-TAX_CODE.
              WA_DUMMY-VENDOR_NO    = WA_FILE_1-VENDOR_NO.
              WA_DUMMY-AMT_DOCCUR   = WA_FILE_1-AMT_DOCCUR.
              WA_DUMMY-AMT_BASE    = WA_FILE_1-AMT_DOCCUR.
              WA_DUMMY-SR_NO = WA_FILE_1-SR_NO.

*condition record no
              IF LV_COUNT = 1.
                SELECT SINGLE KSCHL,
                       ALAND,
                       MWSKZ,
                       KNUMH
                       FROM A003
                       INTO  @WA_A003
                       WHERE MWSKZ = @WA_FILE_1-TAX_CODE
                       AND   KSCHL  IN ( 'JICN'  ) .
                WA_DUMMY-COND_KEY =  WA_A003-KSCHL.

*condition record no and amount
                SELECT SINGLE KNUMH ,
                      KBETR FROM KONP
                      INTO @WA_KONP
                       WHERE KNUMH = @WA_A003-KNUMH.

                WA_KONP-KBETR =  WA_KONP-KBETR / 10 .
                WA_DUMMY-TAX_RATE   = WA_KONP-KBETR .
*GL account

                WA_DUMMY-ACCT_KEY      =  'NVV'.

                WA_DUMMY-TAX_RATE =  WA_DUMMY-TAX_RATE + WA_DUMMY-TAX_RATE.

                LV_PER   = 100 +  WA_DUMMY-TAX_RATE.
                LV_PER2  =   WA_DUMMY-AMT_DOCCUR.

                LV_PER2     =  LV_PER2 * WA_KONP-KBETR / LV_PER .
                WA_DUMMY-AMT_DOCCUR   = LV_PER2.
                WA_DUMMY-TAX_RATE   = WA_KONP-KBETR .
              ENDIF.
              IF LV_COUNT = 2.

                SELECT SINGLE KSCHL,
                     ALAND,
                     MWSKZ,
                     KNUMH
                     FROM A003
                     INTO  @WA_A003_1
                     WHERE MWSKZ = @WA_FILE_1-TAX_CODE
                     AND   KSCHL  IN ( 'JISN'  ) .
                WA_DUMMY-COND_KEY =  WA_A003_1-KSCHL.

                SELECT SINGLE KNUMH ,
                 KBETR FROM KONP
                 INTO @WA_KONP_1
                  WHERE KNUMH = @WA_A003_1-KNUMH.

                WA_KONP_1-KBETR     =  WA_KONP_1-KBETR / 10 .
                WA_DUMMY-TAX_RATE   = WA_KONP_1-KBETR .

*               WA_DUMMY-GL_ACCOUNT_1  =   wa_file_1-GL_ACCOUNT.
                WA_DUMMY-ACCT_KEY      =  'NVV'.


                WA_DUMMY-TAX_RATE =  WA_DUMMY-TAX_RATE + WA_DUMMY-TAX_RATE.

                LV_PER   = 100 +  WA_DUMMY-TAX_RATE.
                LV_PER2  =   WA_DUMMY-AMT_DOCCUR.

                LV_PER2     =  LV_PER2 * WA_KONP_1-KBETR / LV_PER .
*    LV_PER2     =  LV_PER2 / 2.
                WA_DUMMY-AMT_DOCCUR   = LV_PER2.
                WA_DUMMY-TAX_RATE   = WA_KONP_1-KBETR .
              ENDIF.

              APPEND WA_DUMMY TO IT_DUMMY.
              CLEAR :WA_DUMMY , LV_PER,LV_PER2,WA_KONP_1,WA_KONP,WA_T030K,WA_T030K_1, WA_A003_1, WA_A003.
            ENDDO.

          ENDIF.
          CLEAR :LV_COUNT,LV_ITEM1.
        ENDIF.


        IF  WA_FILE_1-TAX_CODE+(1) = 'R'.
          WA_DUMMY-SR_NO = WA_FILE_1-SR_NO.
          SELECT SINGLE * FROM T030K INTO  @WA_JII WHERE KTOPL = '1000' AND MWSKZ = @WA_FILE_1-TAX_CODE.

          IF WA_JII-KTOSL = 'JII' OR WA_JII-KTOSL = 'JRI'  .

            LV_COUNT = LV_COUNT + 1.
            IF WA_FILE_1-DE_CRE_IND = 'H'.
              WA_DUMMY-AMT_DOCCUR = WA_FILE_1-AMT_DOCCUR * -1.
            ENDIF.
            LV_ITEM1 = LV_ITEM1 + 1.
            WA_DUMMY-ITEMNO_ACC   = LV_ITEM1.
            WA_DUMMY-DE_CRE_IND   = WA_FILE_1-DE_CRE_IND.
            WA_DUMMY-ITEMNO_TAX   = LV_ITEM1.
            WA_DUMMY-GL_ACCOUNT   = WA_FILE_1-GL_ACCOUNT.
            WA_DUMMY-TAX_CODE     = WA_FILE_1-TAX_CODE.
            WA_DUMMY-VENDOR_NO    = WA_FILE_1-VENDOR_NO.
            WA_DUMMY-AMT_DOCCUR   = WA_FILE_1-AMT_DOCCUR.
            WA_DUMMY-AMT_BASE    = WA_FILE_1-AMT_DOCCUR.

            SELECT SINGLE KSCHL,ALAND,MWSKZ,KNUMH FROM A003 INTO  @WA_A003_JII WHERE MWSKZ = @WA_FILE_1-TAX_CODE AND   KSCHL  IN ( 'JIIG' ) .
            IF SY-SUBRC = 0.
              WA_DUMMY-COND_KEY =  WA_A003_JII-KSCHL.
            ENDIF.
*condition record no and amount
            SELECT SINGLE KNUMH ,KBETR FROM KONP INTO @WA_KONP_JII WHERE KNUMH = @WA_A003_JII-KNUMH.
            IF SY-SUBRC = 0.
              WA_KONP_JII-KBETR =  WA_KONP_JII-KBETR / 10 .
              WA_DUMMY-TAX_RATE   = WA_KONP_JII-KBETR .
              LV_PER   = 100 +  WA_DUMMY-TAX_RATE.
              LV_PER2  =   WA_DUMMY-AMT_DOCCUR.
              LV_PER2     =  LV_PER2 * WA_KONP_JII-KBETR / LV_PER .
              WA_DUMMY-AMT_DOCCUR   = LV_PER2.
            ENDIF.
*GL account
            SELECT SINGLE KTOPL,KTOSL,MWSKZ,LAND1,KONTS,KONTH FROM  T030K INTO  @WA_T030K_JII WHERE MWSKZ = @WA_FILE_1-TAX_CODE AND  KTOSL IN ( 'JII' ).
            IF SY-SUBRC = 0.
              WA_DUMMY-GL_ACCOUNT_1  =  WA_T030K_JII-KONTS.
              WA_DUMMY-ACCT_KEY      =  WA_T030K_JII-KTOSL.
            ENDIF.

            APPEND WA_DUMMY TO IT_DUMMY.
            CLEAR :WA_DUMMY , LV_PER,LV_PER2,WA_KONP_JII,WA_T030K_JII, WA_A003_JII.

            WA_DUMMY-SR_NO = WA_FILE_1-SR_NO.
            LV_ITEM1 = LV_ITEM1 + 1.
            WA_DUMMY-ITEMNO_ACC   = LV_ITEM1.
            WA_DUMMY-DE_CRE_IND   = WA_FILE_1-DE_CRE_IND.
            WA_DUMMY-ITEMNO_TAX   = LV_ITEM1.
            WA_DUMMY-GL_ACCOUNT   = WA_FILE_1-GL_ACCOUNT.
            WA_DUMMY-TAX_CODE     = WA_FILE_1-TAX_CODE.
            WA_DUMMY-VENDOR_NO    = WA_FILE_1-VENDOR_NO.
            WA_DUMMY-AMT_DOCCUR   = WA_FILE_1-AMT_DOCCUR.
            WA_DUMMY-AMT_BASE    = WA_FILE_1-AMT_DOCCUR.

            SELECT SINGLE KSCHL,ALAND,MWSKZ,KNUMH FROM A003 INTO  @WA_A003_JII WHERE MWSKZ = @WA_FILE_1-TAX_CODE AND KSCHL  IN ( 'JIIR'  ) .
            IF SY-SUBRC = 0.
              WA_DUMMY-COND_KEY =  WA_A003_JII-KSCHL.
            ENDIF.
*condition record no and amount
            SELECT SINGLE KNUMH , KBETR FROM KONP INTO @WA_KONP_JII WHERE KNUMH = @WA_A003_JII-KNUMH.
            IF SY-SUBRC = 0.
              WA_KONP_JII-KBETR =  WA_KONP_JII-KBETR / 10 .
              WA_DUMMY-TAX_RATE   = WA_KONP_JII-KBETR .
              LV_PER   = 100 + ( WA_DUMMY-TAX_RATE * -1 ).
              LV_PER2  =   WA_DUMMY-AMT_DOCCUR.
              LV_PER2     =  LV_PER2 * WA_KONP_JII-KBETR / LV_PER .
              WA_DUMMY-AMT_DOCCUR   = LV_PER2.
            ENDIF.
*GL account
            SELECT SINGLE KTOPL,KTOSL,MWSKZ,LAND1,KONTS,KONTH FROM  T030K INTO  @WA_T030K_JII WHERE MWSKZ = @WA_FILE_1-TAX_CODE AND  KTOSL IN ( 'JRI' ).
            IF SY-SUBRC = 0.
              WA_DUMMY-GL_ACCOUNT_1  =  WA_T030K_JII-KONTS.
              WA_DUMMY-ACCT_KEY      =  WA_T030K_JII-KTOSL.
            ENDIF.



            APPEND WA_DUMMY TO IT_DUMMY.
            CLEAR :WA_DUMMY , LV_PER,LV_PER2,WA_KONP_JII,WA_T030K_JII, WA_A003_JII.

          ELSE.
            DO 4 TIMES.
              LV_COUNT = LV_COUNT + 1.
              IF WA_FILE_1-DE_CRE_IND = 'H'.
                WA_DUMMY-AMT_DOCCUR = WA_FILE_1-AMT_DOCCUR * -1.
              ENDIF.
              LV_ITEM1 = LV_ITEM1 + 1.
              WA_DUMMY-ITEMNO_ACC   = LV_ITEM1.
              WA_DUMMY-DE_CRE_IND   = WA_FILE_1-DE_CRE_IND.
              WA_DUMMY-ITEMNO_TAX   = LV_ITEM1.
              WA_DUMMY-GL_ACCOUNT   = WA_FILE_1-GL_ACCOUNT.
              WA_DUMMY-TAX_CODE     = WA_FILE_1-TAX_CODE.
              WA_DUMMY-VENDOR_NO    = WA_FILE_1-VENDOR_NO.
              WA_DUMMY-AMT_DOCCUR   = WA_FILE_1-AMT_DOCCUR.
              WA_DUMMY-AMT_BASE    = WA_FILE_1-AMT_DOCCUR.
              WA_DUMMY-SR_NO = WA_FILE_1-SR_NO.

*condition record no
              IF LV_COUNT = 1.
                SELECT SINGLE KSCHL,
                       ALAND,
                       MWSKZ,
                       KNUMH
                       FROM A003
                       INTO  @WA_A003
                       WHERE MWSKZ = @WA_FILE_1-TAX_CODE
                       AND   KSCHL  IN ( 'JICG'  ) .
                WA_DUMMY-COND_KEY =  WA_A003-KSCHL.

*condition record no and amount
                SELECT SINGLE KNUMH ,
                      KBETR FROM KONP
                      INTO @WA_KONP
                       WHERE KNUMH = @WA_A003-KNUMH.

                WA_KONP-KBETR =  WA_KONP-KBETR / 10 .
                WA_DUMMY-TAX_RATE   = WA_KONP-KBETR .
*GL account
                SELECT SINGLE KTOPL,
                        KTOSL,
                        MWSKZ,
                        LAND1,
                        KONTS,
                        KONTH FROM  T030K
                        INTO  @WA_T030K
                        WHERE MWSKZ = @WA_FILE_1-TAX_CODE
                        AND   KTOSL IN ( 'JIC' ).
                WA_DUMMY-GL_ACCOUNT_1  =  WA_T030K-KONTS.
                WA_DUMMY-ACCT_KEY      =  WA_T030K-KTOSL.

                WA_DUMMY-TAX_RATE =  WA_DUMMY-TAX_RATE + WA_DUMMY-TAX_RATE.

                LV_PER   = 100 +  WA_DUMMY-TAX_RATE.
                LV_PER2  =   WA_DUMMY-AMT_DOCCUR.

                LV_PER2     =  LV_PER2 * WA_KONP-KBETR / LV_PER .
*    LV_PER2     =  LV_PER2 / 2.
                WA_DUMMY-AMT_DOCCUR   = LV_PER2.

              ENDIF.
              IF LV_COUNT = 2.

                SELECT SINGLE KSCHL,
                     ALAND,
                     MWSKZ,
                     KNUMH
                     FROM A003
                     INTO  @WA_A003_1
                     WHERE MWSKZ = @WA_FILE_1-TAX_CODE
                     AND   KSCHL  IN ( 'JISG'  ) .
                WA_DUMMY-COND_KEY =  WA_A003_1-KSCHL.

                SELECT SINGLE KNUMH ,
                 KBETR FROM KONP
                 INTO @WA_KONP_1
                  WHERE KNUMH = @WA_A003_1-KNUMH.

                WA_KONP_1-KBETR     =  WA_KONP_1-KBETR / 10 .
                WA_DUMMY-TAX_RATE   = WA_KONP_1-KBETR .


                SELECT SINGLE KTOPL,
                      KTOSL,
                      MWSKZ,
                      LAND1,
                      KONTS,
                      KONTH FROM  T030K
                      INTO  @WA_T030K_1
                      WHERE MWSKZ = @WA_FILE_1-TAX_CODE
                      AND   KTOSL IN ( 'JIS' ).
                WA_DUMMY-GL_ACCOUNT_1   =  WA_T030K_1-KONTS.
                WA_DUMMY-ACCT_KEY       =  WA_T030K_1-KTOSL.


                WA_DUMMY-TAX_RATE =  WA_DUMMY-TAX_RATE + WA_DUMMY-TAX_RATE.

                LV_PER   = 100 +  WA_DUMMY-TAX_RATE.
                LV_PER2  =   WA_DUMMY-AMT_DOCCUR.

                LV_PER2     =  LV_PER2 * WA_KONP_1-KBETR / LV_PER .
*    LV_PER2     =  LV_PER2 / 2.
                WA_DUMMY-AMT_DOCCUR   = LV_PER2.

              ENDIF.

              IF LV_COUNT = 4.

                SELECT SINGLE KSCHL,
                     ALAND,
                     MWSKZ,
                     KNUMH
                     FROM A003
                     INTO  @WA_A003_1
                     WHERE MWSKZ = @WA_FILE_1-TAX_CODE
                     AND   KSCHL  IN ( 'JISR'  ) .
                WA_DUMMY-COND_KEY =  WA_A003_1-KSCHL.

                SELECT SINGLE KNUMH ,
                 KBETR FROM KONP
                 INTO @WA_KONP_1
                  WHERE KNUMH = @WA_A003_1-KNUMH.

                WA_KONP_1-KBETR     =  WA_KONP_1-KBETR / 10 .
                WA_DUMMY-TAX_RATE   = WA_KONP_1-KBETR .


                SELECT SINGLE KTOPL,
                      KTOSL,
                      MWSKZ,
                      LAND1,
                      KONTS,
                      KONTH FROM  T030K
                      INTO  @WA_T030K_1
                      WHERE MWSKZ = @WA_FILE_1-TAX_CODE
                      AND   KTOSL IN ( 'JRS' ).
                WA_DUMMY-GL_ACCOUNT_1   =  WA_T030K_1-KONTS.
                WA_DUMMY-ACCT_KEY       =  WA_T030K_1-KTOSL.


                WA_DUMMY-TAX_RATE =  WA_DUMMY-TAX_RATE + WA_DUMMY-TAX_RATE.

                LV_PER   = 100 + ( WA_DUMMY-TAX_RATE * -1 ).
                LV_PER2  =   WA_DUMMY-AMT_DOCCUR.

                LV_PER2     =  LV_PER2 * WA_KONP_1-KBETR / LV_PER .
*    LV_PER2     =  LV_PER2 / 2.
                WA_DUMMY-AMT_DOCCUR   = LV_PER2.

              ENDIF.


              IF LV_COUNT = 3.

                SELECT SINGLE KSCHL,
                     ALAND,
                     MWSKZ,
                     KNUMH
                     FROM A003
                     INTO  @WA_A003_1
                     WHERE MWSKZ = @WA_FILE_1-TAX_CODE
                     AND   KSCHL  IN ( 'JICR'  ) .
                WA_DUMMY-COND_KEY =  WA_A003_1-KSCHL.

                SELECT SINGLE KNUMH ,
                 KBETR FROM KONP
                 INTO @WA_KONP_1
                  WHERE KNUMH = @WA_A003_1-KNUMH.

                WA_KONP_1-KBETR     =  WA_KONP_1-KBETR / 10 .
                WA_DUMMY-TAX_RATE   = WA_KONP_1-KBETR .


                SELECT SINGLE KTOPL,
                      KTOSL,
                      MWSKZ,
                      LAND1,
                      KONTS,
                      KONTH FROM  T030K
                      INTO  @WA_T030K_1
                      WHERE MWSKZ = @WA_FILE_1-TAX_CODE
                      AND   KTOSL IN ( 'JRC' ).
                WA_DUMMY-GL_ACCOUNT_1   =  WA_T030K_1-KONTS.
                WA_DUMMY-ACCT_KEY       =  WA_T030K_1-KTOSL.


                WA_DUMMY-TAX_RATE =  WA_DUMMY-TAX_RATE + WA_DUMMY-TAX_RATE.
                LV_PER   = 100 + ( WA_DUMMY-TAX_RATE * -1 ).
                LV_PER2  =   WA_DUMMY-AMT_DOCCUR.
                LV_PER2     =  LV_PER2 * WA_KONP_1-KBETR / LV_PER .
                WA_DUMMY-AMT_DOCCUR   = LV_PER2.

              ENDIF.

              APPEND WA_DUMMY TO IT_DUMMY.
              CLEAR :WA_DUMMY , LV_PER,LV_PER2,WA_KONP_1,WA_KONP,WA_T030K,WA_T030K_1, WA_A003_1, WA_A003.
            ENDDO.


          ENDIF.
          CLEAR :LV_COUNT,LV_ITEM1.
        ENDIF.

      ENDIF.
    ENDLOOP.
  ENDIF.

*calculating amount tax for main AMT_DOCCUR
  DATA : LV_AMOUNT TYPE P DECIMALS 2.
  DATA : LV_BUKRS TYPE BKPF-BUKRS,
         LV_MWSKZ TYPE BSEG-MWSKZ,
         LV_WAERS TYPE BKPF-WAERS,
         LV_WRBTR TYPE BSEG-WRBTR,
         LV_FWSTE TYPE BSET-FWSTE.
  LOOP AT IT_FILE_1 INTO WA_FILE_1 .
    IF  WA_FILE_1-TAX_CODE IS NOT INITIAL AND  WA_FILE_1-TAX_CODE NE 'V0'.

      LV_BUKRS = WA_FILE_1-COMP_CODE.
      LV_MWSKZ = WA_FILE_1-TAX_CODE.
      LV_WAERS = WA_FILE_1-CURRENCY.
      LV_WRBTR = WA_FILE_1-AMT_DOCCUR.
*if wa_file_1-tax_code+(1) ne 'R'.
      CALL FUNCTION 'CALCULATE_TAX_FROM_GROSSAMOUNT'
        EXPORTING
          I_BUKRS = LV_BUKRS
          I_MWSKZ = LV_MWSKZ
          I_WAERS = LV_WAERS
          I_WRBTR = LV_WRBTR
        IMPORTING
          E_FWAST = LV_FWSTE.

      WA_FILE_1-AMT_DOCCUR = WA_FILE_1-AMT_DOCCUR - LV_FWSTE .
      WA_FILE_1-AMT_BASE   = WA_FILE_1-AMT_DOCCUR.
      MODIFY IT_FILE_1 FROM WA_FILE_1  TRANSPORTING AMT_DOCCUR AMT_BASE.
      CLEAR : WA_FILE_1 . "LV_PER1,LV_PER3,wa_konp_2,lv_kbetr1,LV_AMOUNT,wa_a003_2.
      CLEAR :LV_BUKRS ,  LV_MWSKZ,LV_WAERS, LV_WRBTR, LV_FWSTE.
*     endif.
    ENDIF .
  ENDLOOP.

  DATA : D1 LIKE SY-DATUM,
         D2 LIKE SY-DATUM.
  IT_FILE_11 = IT_FILE_1.
  DATA(IT_FILE_NR) =  IT_FILE_1 .


  DELETE IT_FILE_NR WHERE TAX_CODE IS INITIAL .


  SORT IT_FILE_1 BY SR_NO.
  SORT IT_FILE_11 BY SR_NO .
*  DELETE ADJACENT DUPLICATES FROM IT_FILE_11 COMPARING SR_NO.
  DELETE IT_FILE_11 WHERE DOC_DATE is INITIAL.

  LOOP AT IT_FILE_11 INTO WA_FILE_11.


    WA_DOCUMENTHEADER-USERNAME      = SY-UNAME.
    WA_DOCUMENTHEADER-BUS_ACT       =  'RFBU'.  "wa_file_1-BUS_ACT.
    WA_DOCUMENTHEADER-HEADER_TXT    = WA_FILE_1-HEADER_TXT.
    WA_DOCUMENTHEADER-COMP_CODE     = WA_FILE_11-COMP_CODE.
    WA_DOCUMENTHEADER-FISC_YEAR     = WA_FILE_11-FISC_YEAR .
    WA_DOCUMENTHEADER-DOC_TYPE      = WA_FILE_11-DOC_TYPE  .
    WA_DOCUMENTHEADER-REF_DOC_NO    = WA_FILE_11-REF_DOC_NO.

    CONCATENATE   WA_FILE_11-DOC_DATE+6(4)
                  WA_FILE_11-DOC_DATE+3(2)
                  WA_FILE_11-DOC_DATE+(2) INTO D1.

    CONCATENATE WA_FILE_11-PSTNG_DATE+6(4)
                WA_FILE_11-PSTNG_DATE+3(2)
                WA_FILE_11-PSTNG_DATE+(2) INTO D2.

    WA_DOCUMENTHEADER-DOC_DATE      = D1.
    WA_DOCUMENTHEADER-PSTNG_DATE    = D2.



    DATA : LV_ITEM    LIKE BAPIACGL09-ITEMNO_ACC.
    LV_ITEM = '1'.
    CLEAR : WA_FILE_1.
    REFRESH : WA_ACCOUNTGL[].
    REFRESH : WA_ACCOUNTPAYABLE[].
    REFRESH : WA_CURRENCYAMOUNT[].

    LOOP AT IT_FILE_1 INTO WA_FILE_1 WHERE SR_NO = WA_FILE_11-SR_NO.


      IF  WA_FILE_1-TAX_CODE IS NOT INITIAL .
        LV_TDC_CAL = LV_TDC_CAL + WA_FILE_1-AMT_DOCCUR .
      ENDIF.



      IF WA_FILE_1-DE_CRE_IND = 'H'.
        WA_FILE_1-AMT_DOCCUR = WA_FILE_1-AMT_DOCCUR * -1.

      ENDIF.
* ACCOUNTGL
      IF WA_FILE_1-COSTCENTER NE ' '.
        WA_ACCOUNTGL-ITEMNO_ACC  = LV_ITEM.
        WA_ACCOUNTGL-GL_ACCOUNT  = WA_FILE_1-GL_ACCOUNT.
        WA_ACCOUNTGL-ITEM_TEXT   = WA_FILE_1-ITEM_TEXT.
        WA_ACCOUNTGL-ALLOC_NMBR  = WA_FILE_1-ALLOC_NMBR.
        WA_ACCOUNTGL-TAX_CODE    = WA_FILE_1-TAX_CODE.
        WA_ACCOUNTGL-COSTCENTER  = WA_FILE_1-COSTCENTER. "'0000110101'. "wa_file_1-COSTCENTER.
*    wa_accountgl-profit_ctr  = '0000002600'.
        WA_ACCOUNTGL-ITEMNO_TAX  = LV_ITEM.
        WA_ACCOUNTGL-QUANTITY = WA_FILE_1-QUANTITY.
        WA_ACCOUNTGL-BASE_UOM = WA_FILE_1-BASE_UOM.

*        WA_ACCOUNTGL-STAT_CON = 'X' .

        "<---Added for Updating HSN/SAC Code on 18-Nov-2025 by madhuri
        EXTENSION1-FIELD1 = WA_FILE_1-HSN_SAC.
        APPEND EXTENSION1.
        CLEAR: EXTENSION1.


        CLEAR EXTENSION2.
        EXTENSION2-STRUCTURE  = 'BSEG'.         "Because HSN_SAC exists in BSEG
        EXTENSION2-VALUEPART1 = WA_FILE_1-HSN_SAC.    "Your HSN code
        EXTENSION2-VALUEPART2 = LV_ITEM.    "Your HSN code

        APPEND EXTENSION2.


        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            INPUT  = WA_ACCOUNTGL-GL_ACCOUNT
          IMPORTING
            OUTPUT = WA_ACCOUNTGL-GL_ACCOUNT.
        APPEND WA_ACCOUNTGL.

      ELSEIF WA_FILE_1-VENDOR_NO NE ' '.

*   *ACCOUNTPAYABLE
*        WA_ACCOUNTGL-STAT_CON            = 'X' .
        WA_ACCOUNTPAYABLE-ITEMNO_ACC     = LV_ITEM.
        WA_ACCOUNTPAYABLE-VENDOR_NO      = WA_FILE_1-VENDOR_NO .
        WA_ACCOUNTPAYABLE-ITEM_TEXT      = WA_FILE_1-ITEM_TEXT.
        WA_ACCOUNTPAYABLE-BUSINESSPLACE  = WA_FILE_1-BUSINESSPLACE.
        WA_ACCOUNTPAYABLE-SECTIONCODE    = WA_FILE_1-SECTIONCODE.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            INPUT  = WA_ACCOUNTPAYABLE-VENDOR_NO
          IMPORTING
            OUTPUT = WA_ACCOUNTPAYABLE-VENDOR_NO.
        APPEND WA_ACCOUNTPAYABLE.

      ENDIF.

*   *  CURRENCYAMOUNT
      WA_CURRENCYAMOUNT-ITEMNO_ACC     = LV_ITEM.
      WA_CURRENCYAMOUNT-CURRENCY       = WA_FILE_1-CURRENCY.
      WA_CURRENCYAMOUNT-AMT_DOCCUR     = WA_FILE_1-AMT_DOCCUR.

      IF WA_FILE_1-DE_CRE_IND = 'H'.
        WA_FILE_1-AMT_BASE = WA_FILE_1-AMT_BASE * -1.
      ENDIF.

      WA_CURRENCYAMOUNT-AMT_BASE       = WA_FILE_1-AMT_BASE.  "NOW

      APPEND  WA_CURRENCYAMOUNT.


      CLEAR : WA_CURRENCYAMOUNT.
      CLEAR: WA_CURRENCYAMOUNT.
      CLEAR: WA_ACCOUNTPAYABLE.
      CLEAR: WA_ACCOUNTGL.
      CLEAR: WA_ACCOUNTTAX.
      LV_ITEM = LV_ITEM + 1.
    ENDLOOP.

    DATA : LV_ITEM_2 TYPE I,
           LV_ITEM_3 TYPE I,
           LV_CAL    TYPE BAPIDOCCUR.
    DESCRIBE TABLE WA_ACCOUNTGL LINES DATA(LV_LINES).

******  now
    LV_ITEM = LV_ITEM + 1.
    LOOP AT IT_FILE_1 INTO WA_FILE_1 WHERE SR_NO = WA_FILE_11-SR_NO.
      CHECK WA_FILE_1-TAX_CODE IS NOT INITIAL.

      WA_FILE_1-GL_ACCOUNT = |{ WA_FILE_1-GL_ACCOUNT ALPHA = IN }|.


      LOOP AT IT_DUMMY INTO WA_DUMMY WHERE GL_ACCOUNT = WA_FILE_1-GL_ACCOUNT
                                      "AND  VENDOR_NO = wa_file_1-VENDOR_NO
                                      AND SR_NO = WA_FILE_11-SR_NO.

*lv_lines = lv_lines + 1.

        WA_ACCOUNTTAX-ITEMNO_ACC     = LV_ITEM . "lv_lines.
        WA_ACCOUNTTAX-GL_ACCOUNT     = WA_DUMMY-GL_ACCOUNT_1.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            INPUT  = WA_DUMMY-GL_ACCOUNT
          IMPORTING
            OUTPUT = WA_DUMMY-GL_ACCOUNT.

        WA_ACCOUNTTAX-COND_KEY      = WA_DUMMY-COND_KEY.
        WA_ACCOUNTTAX-ACCT_KEY      = WA_DUMMY-ACCT_KEY.
        WA_ACCOUNTTAX-TAX_CODE      = WA_DUMMY-TAX_CODE.
        WA_ACCOUNTTAX-TAX_RATE      = WA_DUMMY-TAX_RATE.
        WA_ACCOUNTTAX-ITEMNO_TAX    = LV_LINES.  "NOW ADDED

        APPEND : WA_ACCOUNTTAX.

        WA_CURRENCYAMOUNT-ITEMNO_ACC     = LV_ITEM. "lv_lines .
        WA_CURRENCYAMOUNT-CURRENCY       = 'INR'.
        WA_CURRENCYAMOUNT-AMT_DOCCUR     = WA_DUMMY-AMT_DOCCUR.
        IF WA_DUMMY-DE_CRE_IND = 'H'.
          WA_DUMMY-AMT_BASE = WA_DUMMY-AMT_BASE * -1.
        ENDIF.
*    for base price
        LV_CAL  = WA_DUMMY-AMT_DOCCUR + WA_DUMMY-AMT_DOCCUR.
        WA_CURRENCYAMOUNT-AMT_BASE       = WA_DUMMY-AMT_BASE - LV_CAL.   "NOW

        APPEND  WA_CURRENCYAMOUNT.
        LV_ITEM = LV_ITEM + 1.

        CLEAR: LV_CAL,WA_DUMMY.
      ENDLOOP.
*         APPEND  WA_CURRENCYAMOUNT.
*        LV_ITEM = LV_ITEM + 1.
*
*        CLEAR: LV_CAL,WA_DUMMY.
    ENDLOOP.
    CLEAR : LV_LINES.

    DATA: LV_LIFNR TYPE LFA1-LIFNR .

    LV_LIFNR = |{ WA_FILE_11-VENDOR_NO ALPHA = IN }|.


    SELECT  * FROM LFBW INTO TABLE @DATA(IT_LFBW) WHERE LIFNR = @LV_LIFNR .

    CLEAR : LV_LIFNR .
    LOOP AT IT_LFBW INTO DATA(WA_LFBW).

*      WA_ACC-BAS_AMT_LC =  WA_FILE_11-AMT_BASE  .
      WA_ACC-ITEMNO_ACC  = 1. " Link to the vendor line item
      WA_ACC-WT_TYPE     = WA_LFBW-WITHT.
      WA_ACC-WT_CODE     = WA_LFBW-WT_WITHCD.
      WA_ACC-BAS_AMT_IND = 'X'. " Indicator for base amount
* Optionally, you can manually specify amounts if needed, otherwise SAP calculates them
      WA_ACC-BAS_AMT_TC =   WA_ACC-BAS_AMT_LC  = LV_TDC_CAL .             "WA_FILE_11-AMT_BASE. " Base amount
*      WA_ACC-AWH_AMT_LC  = '100.00'. " Withholding tax amount
      APPEND WA_ACC TO IT_ACC.

      CLEAR : WA_ACC , LV_TDC_CAL.

    ENDLOOP.


    DATA :LV_COUNT2 TYPE P DECIMALS 2.
    DATA :LV_COUNT3 TYPE P DECIMALS 2.
    DATA :LV_VAR    TYPE P DECIMALS 2.


    IF P_TEST IS NOT INITIAL .
      CALL FUNCTION 'BAPI_ACC_DOCUMENT_CHECK'
        EXPORTING
          DOCUMENTHEADER = WA_DOCUMENTHEADER
*        IMPORTING
*         OBJ_TYPE       = WA_DOCUMENTHEADER-OBJ_TYPE
*         OBJ_KEY        = WA_DOCUMENTHEADER-OBJ_KEY
*         OBJ_SYS        = WA_DOCUMENTHEADER-OBJ_SYS
        TABLES
*         criteria       = criteria
          ACCOUNTGL      = WA_ACCOUNTGL
          ACCOUNTPAYABLE = WA_ACCOUNTPAYABLE
          ACCOUNTTAX     = WA_ACCOUNTTAX
          EXTENSION1     = EXTENSION1
          CURRENCYAMOUNT = WA_CURRENCYAMOUNT
          EXTENSION2     = EXTENSION2
          ACCOUNTWT      = IT_ACC
          RETURN         = WA_RETURN.
      .

    ELSE.

      CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
        EXPORTING
          DOCUMENTHEADER = WA_DOCUMENTHEADER
        IMPORTING
          OBJ_TYPE       = WA_DOCUMENTHEADER-OBJ_TYPE
          OBJ_KEY        = WA_DOCUMENTHEADER-OBJ_KEY
          OBJ_SYS        = WA_DOCUMENTHEADER-OBJ_SYS
        TABLES
*         criteria       = criteria
          ACCOUNTGL      = WA_ACCOUNTGL
          ACCOUNTPAYABLE = WA_ACCOUNTPAYABLE
          ACCOUNTTAX     = WA_ACCOUNTTAX
          EXTENSION1     = EXTENSION1
          CURRENCYAMOUNT = WA_CURRENCYAMOUNT
          EXTENSION2     = EXTENSION2
          ACCOUNTWT      = IT_ACC
          RETURN         = WA_RETURN.

    ENDIF.
    REFRESH : IT_ACC .

    READ TABLE WA_RETURN WITH KEY TYPE = 'E'.
    IF  SY-SUBRC = 0.
      LOOP AT WA_RETURN WHERE TYPE = 'E'.
        IF SY-TABIX = 2.
          MOVE : WA_RETURN-MESSAGE TO WA_FILE_11-REMARK.
        ENDIF.
      ENDLOOP.
    ELSE.
      CLEAR :WA_RETURN.
      REFRESH : WA_RETURN.
      IF P_TEST IS  INITIAL .
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            WAIT = 'X'
*       IMPORTING
*           RETURN        =
          .
      ENDIF.
      MOVE :   WA_DOCUMENTHEADER-OBJ_KEY+(10)    TO WA_FILE_11-BELNR. "wa_DOCUMENTHEADER-obj_key
      MOVE :  'Document Posted '                 TO WA_FILE_11-REMARK. "wa_DOCUMENTHEADER-obj_key

    ENDIF.
    APPEND :WA_FILE_11 TO IT_FILE_12.
    CLEAR : WA_FILE_11.
    CLEAR : WA_DOCUMENTHEADER ,LV_COUNT2,LV_COUNT3,LV_VAR ,LV_KBETR,LV_ITEM1,
            LV_COUNT,LV_PER  ,LV_PER1 ,LV_PER2 ,LV_PER3, EXTENSION2 , EXTENSION1.

    REFRESH :WA_ACCOUNTGL,
             WA_CURRENCYAMOUNT,
             WA_ACCOUNTPAYABLE,
             WA_ACCOUNTTAX,
             EXTENSION2,
             EXTENSION1,
*           it_dummy,
             WA_RETURN.
*  ENDLOOP.
  ENDLOOP.


  IF IT_FILE_12 IS NOT INITIAL.
    LOOP AT IT_FILE_1 INTO WA_FILE_1.
      READ TABLE IT_FILE_12 INTO WA_FILE_12 WITH KEY SR_NO =  WA_FILE_1-SR_NO.
      IF SY-SUBRC = 0 .
        MOVE : WA_FILE_12-BELNR  TO WA_FILE_1-BELNR.
        MOVE : WA_FILE_12-REMARK TO WA_FILE_1-REMARK.
      ENDIF.
      MODIFY :IT_FILE_1 FROM WA_FILE_1.
    ENDLOOP.
    PERFORM : DISPLAY_ALV.

  ENDIF.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV .

  DATA:N TYPE STRING VALUE 1.

  WA_FIELDCAT-COL_POS = N.
  WA_FIELDCAT-FIELDNAME = 'SR_NO'.
  WA_FIELDCAT-SELTEXT_M = 'Sr.No.'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR : WA_FIELDCAT.

  WA_FIELDCAT-COL_POS = N.
  WA_FIELDCAT-FIELDNAME = 'HEADER_TXT'.
  WA_FIELDCAT-SELTEXT_M = 'Header Text'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR : WA_FIELDCAT.

  WA_FIELDCAT-COL_POS = N.
  WA_FIELDCAT-FIELDNAME = 'COMP_CODE'.
  WA_FIELDCAT-SELTEXT_M = 'Com. Code'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR : WA_FIELDCAT.

  WA_FIELDCAT-COL_POS = N.
  WA_FIELDCAT-FIELDNAME = 'DOC_DATE'.
  WA_FIELDCAT-SELTEXT_M = 'Doc. Date'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR : WA_FIELDCAT.

  WA_FIELDCAT-COL_POS = N.
  WA_FIELDCAT-FIELDNAME = 'DOC_TYPE'.
  WA_FIELDCAT-SELTEXT_M = 'Doc. Dt'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR : WA_FIELDCAT.

  WA_FIELDCAT-COL_POS = N.
  WA_FIELDCAT-FIELDNAME = 'PSTNG_DATE'.
  WA_FIELDCAT-SELTEXT_M = 'Posting Date'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR : WA_FIELDCAT.

  WA_FIELDCAT-COL_POS = N.
  WA_FIELDCAT-FIELDNAME = 'FISC_YEAR'.
  WA_FIELDCAT-SELTEXT_M = 'Fical_year'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR : WA_FIELDCAT.

  WA_FIELDCAT-COL_POS = N.
  WA_FIELDCAT-FIELDNAME = 'REF_DOC_NO'.
  WA_FIELDCAT-SELTEXT_M = 'Ref.'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR : WA_FIELDCAT.

  WA_FIELDCAT-COL_POS = N.
  WA_FIELDCAT-FIELDNAME = 'DE_CRE_IND'.
  WA_FIELDCAT-SELTEXT_M = 'Debit_Credit'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR : WA_FIELDCAT.

  WA_FIELDCAT-COL_POS = N.
  WA_FIELDCAT-FIELDNAME = 'ITEMNO_ACC'.
  WA_FIELDCAT-SELTEXT_M = 'Item'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR : WA_FIELDCAT.

  WA_FIELDCAT-COL_POS = N.
  WA_FIELDCAT-FIELDNAME = 'GL_ACCOUNT'.
  WA_FIELDCAT-SELTEXT_M = 'Account'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR : WA_FIELDCAT.

  WA_FIELDCAT-COL_POS = N.
  WA_FIELDCAT-FIELDNAME = 'ITEM_TEXT'.
  WA_FIELDCAT-SELTEXT_M = 'Item_Text'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR : WA_FIELDCAT.

  WA_FIELDCAT-COL_POS = N.
  WA_FIELDCAT-FIELDNAME = 'COSTCENTER'.
  WA_FIELDCAT-SELTEXT_M = 'Cost_Center'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR : WA_FIELDCAT.

  WA_FIELDCAT-COL_POS = N.
  WA_FIELDCAT-FIELDNAME = 'VENDOR_NO'.
  WA_FIELDCAT-SELTEXT_M = 'Vendor_No'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR : WA_FIELDCAT.

  WA_FIELDCAT-COL_POS = N.
  WA_FIELDCAT-FIELDNAME = 'BUSINESSPLACE'.
  WA_FIELDCAT-SELTEXT_M = 'Business_Place'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR : WA_FIELDCAT.

  WA_FIELDCAT-COL_POS = N.
  WA_FIELDCAT-FIELDNAME = 'SECTIONCODE'.
  WA_FIELDCAT-SELTEXT_M = 'Section Code'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR : WA_FIELDCAT.

  WA_FIELDCAT-COL_POS = N.
  WA_FIELDCAT-FIELDNAME = 'CURRENCY'.
  WA_FIELDCAT-SELTEXT_M = 'Currency'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR : WA_FIELDCAT.

  WA_FIELDCAT-COL_POS = N.
  WA_FIELDCAT-FIELDNAME = 'ALLOC_NMBR'.
  WA_FIELDCAT-SELTEXT_M = 'Assignment'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR : WA_FIELDCAT.

  WA_FIELDCAT-COL_POS = N.
  WA_FIELDCAT-FIELDNAME = 'TAX_CODE'.
  WA_FIELDCAT-SELTEXT_M = 'Tax Code'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR : WA_FIELDCAT.

  WA_FIELDCAT-COL_POS = N.
  WA_FIELDCAT-FIELDNAME = 'AMT_DOCCUR'.
  WA_FIELDCAT-SELTEXT_M = 'Amount'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR : WA_FIELDCAT.

  WA_FIELDCAT-COL_POS = N.
  WA_FIELDCAT-FIELDNAME = 'BELNR'.
  WA_FIELDCAT-SELTEXT_M = 'Doc. No.'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR : WA_FIELDCAT.


  WA_FIELDCAT-COL_POS = N.
  WA_FIELDCAT-FIELDNAME = 'REMARK'.
  WA_FIELDCAT-SELTEXT_M = 'Message With Status'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR : WA_FIELDCAT.

  IS_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM      = SY-REPID
      I_CALLBACK_USER_COMMAND = 'UCOMM'
      IS_LAYOUT               = IS_LAYOUT
      IT_FIELDCAT             = IT_FIELDCAT[]
    TABLES
      T_OUTTAB                = IT_FILE_1.
* EXCEPTIONS
*     PROGRAM_ERROR           = 1
*     OTHERS                  = 2
  .
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
