*&---------------------------------------------------------------------*
*& Report ZFICO_VENDOR_INVOICE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFICO_VENDOR_INVOICE.

TYPES : BEGIN OF ty_file,
*DOCUMENTHEADER
    sr_no(3)        TYPE   c,  "001
    BUS_ACT         TYPE   GLVOR,
    HEADER_TXT      TYPE   BKTXT,
    COMP_CODE       TYPE   BUKRS,
    DOC_DATE(10)    TYPE   C ,   "   BLDAT,
    PSTNG_DATE(10)  TYPE   C  ,   "BUDAT,
    FISC_YEAR       TYPE   GJAHR,
    DOC_TYPE        TYPE   BLART,
    REF_DOC_NO      TYPE   XBLNR,
    DE_CRE_IND      TYPE   ACPI_TBTKZ,
* ACCOUNTGL
    ITEMNO_ACC      TYPE   POSNR_ACC,
    GL_ACCOUNT      TYPE   HKONT,
    ITEM_TEXT       TYPE   SGTXT,
    ALLOC_NMBR      TYPE   ACPI_ZUONR,
    TAX_CODE        TYPE   MWSKZ,
    COSTCENTER      TYPE   KOSTL,
    ITEMNO_TAX      TYPE   TAXPS,
*ACCOUNTPAYABLE
*    ITEMNO_ACC_v    TYPE   POSNR_ACC,
    VENDOR_NO       TYPE   LIFNR,
    ITEM_TEXT_1     TYPE   SGTXT,
    BUSINESSPLACE   TYPE   ACPI_BRANCH,
    SECTIONCODE     TYPE   ACPI_SECCO1,

*ACCOUNTTAX
*   ITEMNO_ACC_1      TYPE POSNR_ACC,
   GL_ACCOUNT_1     TYPE HKONT,
   COND_KEY         TYPE KSCHL,
   ACCT_KEY         TYPE KTOSL,
   TAX_CODE_1       TYPE MWSKZ,
   TAX_RATE         TYPE MSATZ_F05L,
   ITEMNO_TAX_1     TYPE TAXPS,
*CURRENCYAMOUNT
*    ITEMNO_ACC_c    TYPE   POSNR_ACC,
    CURRENCY        TYPE   WAERS,
    AMT_DOCCUR      TYPE   BAPIDOCCUR,
    AMT_BASE        TYPE   BAPIAMTBASE,

    belnr(10)       TYPE c,
    remark(100)     TYPE c,

    END OF  ty_file.

    TYPES : BEGIN OF TY_FILE1,
      DE_CRE_IND    TYPE   ACPI_TBTKZ,
      ITEMNO_ACC    TYPE   POSNR_ACC,
      GL_ACCOUNT    TYPE   HKONT,
      GL_ACCOUNT_1  TYPE   HKONT,
      TAX_CODE      TYPE   MWSKZ,
      ITEMNO_TAX    TYPE   TAXPS,
      VENDOR_NO     TYPE   LIFNR,
      COND_KEY      TYPE   KSCHL,
      ACCT_KEY      TYPE   KTOSL,
      CURRENCY      TYPE   WAERS,
      TAX_RATE      TYPE   MSATZ_F05L,
      AMT_DOCCUR    TYPE   BAPIDOCCUR,
      AMT_BASE      TYPE   BAPIAMTBASE,

    END OF TY_FILE1.

DATA : wa_return         LIKE  bapiret2 OCCURS 0 WITH HEADER LINE.
DATA : wa_DOCUMENTHEADER LIKE  BAPIACHE09 OCCURS 0 WITH HEADER LINE.
DATA : wa_ACCOUNTGL      LIKE  BAPIACGL09 OCCURS 0 WITH HEADER LINE.
DATA : wa_ACCOUNTPAYABLE LIKE  BAPIACAP09 OCCURS 0 WITH HEADER LINE.
DATA : wa_ACCOUNTTAX     LIKE  BAPIACTX09 OCCURS 0 WITH HEADER LINE.
DATA : wa_CURRENCYAMOUNT LIKE  BAPIACCR09 OCCURS 0 WITH HEADER LINE.

DATA :obj_type   LIKE bapiache08-obj_type,
      obj_key    LIKE bapiache02-obj_key,
      obj_sys    LIKE bapiache02-obj_sys.


DATA: it_fieldcat  TYPE slis_t_fieldcat_alv.
DATA: wa_fieldcat  TYPE slis_fieldcat_alv.
DATA: is_layout TYPE slis_layout_alv.


DATA :  it_dummy TYPE STANDARD TABLE OF ty_file1,
        wa_dummy TYPE ty_file1.


DATA : it_file_1 TYPE STANDARD TABLE OF ty_file,
       wa_file_1 TYPE ty_file.
DATA : it_file_11 TYPE STANDARD TABLE OF ty_file,
       wa_file_11 TYPE ty_file.
DATA : it_file_12 TYPE STANDARD TABLE OF ty_file,
       wa_file_12 TYPE ty_file.

*DATA : it_file TYPE TABLE OF alsmex_tabline,
*       wa_file TYPE alsmex_tabline.
DATA : it_file TYPE alsmex_tabline  OCCURS 0 WITH HEADER LINE.

SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-001.
  PARAMETERS : p_file TYPE rlgrap-filename.

SELECTION-SCREEN END OF BLOCK a.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
*     FIELD_NAME    = ' '
    IMPORTING
      file_name     = p_file.

START-OF-SELECTION.

  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = p_file
      i_begin_col             = '1'
      i_begin_row             = '2'
      i_end_col               = '21'
      i_end_row               = '9999'
    TABLES
      intern                  = it_file
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.

    LOOP AT it_file.

    CASE it_file-col.
      WHEN 1.
        wa_file_1-sr_no        = it_file-value.
*      WHEN 2.
*        wa_file_1-BUS_ACT      = it_file-value.
      WHEN 2.
        wa_file_1-HEADER_TXT   = it_file-value.
      WHEN 3.
        wa_file_1-COMP_CODE    = it_file-value.
      WHEN 4.
        wa_file_1-DOC_DATE     = it_file-value.
      WHEN 5.
      wa_file_1-PSTNG_DATE     = it_file-value.
      WHEN 6.
       wa_file_1-FISC_YEAR     = it_file-value.
      WHEN 7.
        wa_file_1-DOC_TYPE     = it_file-value.
      WHEN 8.
        wa_file_1-REF_DOC_NO   = it_file-value.
      WHEN 9.
        wa_file_1-DE_CRE_IND   = it_file-value.
      WHEN 10.
        wa_file_1-ITEMNO_ACC   = it_file-value.
      WHEN 11.
        wa_file_1-GL_ACCOUNT   = it_file-value.
      WHEN 12.
        wa_file_1-ITEM_TEXT    = it_file-value.
       WHEN 13.
         wa_file_1-ALLOC_NMBR  = it_file-value.
      WHEN 14.
        wa_file_1-TAX_CODE     = it_file-value.
      WHEN 15.
        wa_file_1-COSTCENTER   = it_file-value.
*       WHEN 16.
*        wa_file_1-ITEMNO_TAX   = it_file-value.  "COMMENTED
      WHEN 16.
        wa_file_1-VENDOR_NO    = it_file-value.
*       WHEN 15.
*        wa_file_1-ITEM_TEXT_1  = it_file-value.
      WHEN 17.
        wa_file_1-BUSINESSPLACE  = it_file-value.
      WHEN 18.
        wa_file_1-SECTIONCODE    = it_file-value.
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
        wa_file_1-CURRENCY       = it_file-value.
      WHEN 20.
        wa_file_1-AMT_DOCCUR     = it_file-value.
      WHEN 21.
        wa_file_1-AMT_BASE       = it_file-value.

           ENDCASE.

    AT END OF row .
      APPEND wa_file_1 TO it_file_1.
      CLEAR wa_file_1.
    ENDAT.
    CLEAR : it_file.
  ENDLOOP.

  data : lv_KBETR type KBETR,
         LV_ITEM1 TYPE i,
         lv_count TYPE p DECIMALS 2,
         LV_PER   TYPE p DECIMALS 2,
         LV_PER1  TYPE p DECIMALS 2,
         LV_PER2  TYPE p DECIMALS 2,
         LV_PER3  TYPE p DECIMALS 2.

*calculating amount tax for item AMT_DOCCUR
  SORT it_file_1 by sr_no.

  IF IT_FILE_1 IS NOT INITIAL .
    LOOP at IT_FILE_1 INTO wa_file_1 .
    IF  wa_file_1-tax_code is NOT INITIAL and  wa_file_1-tax_code ne 'V0'.
       DO 2 TIMES.
          lv_count = lv_count + 1.
     if wa_file_1-DE_CRE_IND = 'H'.
       WA_DUMMY-AMT_DOCCUR = wa_file_1-AMT_DOCCUR * -1.
    ENDIF.
    lv_item1 = lv_item1 + 1.
    WA_DUMMY-ITEMNO_ACC   = lv_item1.
    WA_DUMMY-DE_CRE_IND   = wa_file_1-DE_CRE_IND.
    WA_DUMMY-ITEMNO_TAX   = lv_item1.
    WA_DUMMY-GL_ACCOUNT   = wa_file_1-GL_ACCOUNT.
    WA_DUMMY-TAX_CODE     = wa_file_1-TAX_CODE.
    WA_DUMMY-VENDOR_NO    = wa_file_1-VENDOR_NO.
    WA_DUMMY-AMT_DOCCUR   = wa_file_1-AMT_DOCCUR.
    WA_DUMMY-AMT_BASE    = wa_file_1-AMT_DOCCUR.


*condition record no
     if lv_count = 1.
        SELECT SINGLE KSCHL,
               ALAND,
               MWSKZ,
               KNUMH
               from A003
               INTO  @data(wa_a003)
               WHERE MWSKZ = @wa_file_1-TAX_CODE
               AND   KSCHL  IN ( 'JICG'  ) .
        WA_DUMMY-COND_KEY =  wa_a003-KSCHL.

*condition record no and amount
        SELECT SINGLE KNUMH ,
              KBETR FROM KONP
              INTO @data(wa_konp)
               WHERE KNUMH = @wa_a003-KNUMH.

            wa_konp-kbetr =  wa_konp-KBETR / 10 .
        WA_DUMMY-TAX_RATE   = wa_konp-kbetr .
*GL account
       SELECT SINGLE KTOPL,
               KTOSL,
               MWSKZ,
               LAND1,
               KONTS,
               KONTH from  T030K
               INTO  @data(WA_t030k)
               WHERE MWSKZ = @wa_file_1-TAX_CODE
               AND   KTOSL IN ( 'JIC' ).
         WA_DUMMY-GL_ACCOUNT_1  =  wa_t030k-KONTS.
         WA_DUMMY-ACCT_KEY      =  wa_t030k-KTOSL.

     WA_DUMMY-TAX_RATE =  WA_DUMMY-TAX_RATE + WA_DUMMY-TAX_RATE.

          LV_PER   = 100 +  WA_DUMMY-TAX_RATE.
          LV_PER2  =   WA_DUMMY-AMT_DOCCUR.

    LV_PER2     =  LV_PER2 * wa_konp-kbetr / LV_PER .
*    LV_PER2     =  LV_PER2 / 2.
    WA_DUMMY-AMT_DOCCUR   = LV_PER2.

         ENDIF.
        if lv_count = 2.
          SELECT SINGLE KSCHL,
               ALAND,
               MWSKZ,
               KNUMH
               from A003
               INTO  @data(wa_a003_1)
               WHERE MWSKZ = @wa_file_1-TAX_CODE
               AND   KSCHL  IN ( 'JISG'  ) .
             WA_DUMMY-COND_KEY =  wa_a003_1-KSCHL.

             SELECT SINGLE KNUMH ,
              KBETR FROM KONP
              INTO @data(wa_konp_1)
               WHERE KNUMH = @wa_a003-KNUMH.

           wa_konp_1-kbetr     =  wa_konp_1-kbetr / 10 .
           WA_DUMMY-TAX_RATE   = wa_konp_1-kbetr .


         SELECT SINGLE KTOPL,
               KTOSL,
               MWSKZ,
               LAND1,
               KONTS,
               KONTH from  T030K
               INTO  @data(WA_t030k_1)
               WHERE MWSKZ = @wa_file_1-TAX_CODE
               AND   KTOSL IN ( 'JIS' ).
           WA_DUMMY-GL_ACCOUNT_1   =  wa_t030k_1-KONTS.
           WA_DUMMY-ACCT_KEY       =  wa_t030k_1-KTOSL.


    WA_DUMMY-TAX_RATE =  WA_DUMMY-TAX_RATE + WA_DUMMY-TAX_RATE.

           LV_PER   = 100 +  WA_DUMMY-TAX_RATE.
          LV_PER2  =   WA_DUMMY-AMT_DOCCUR.

          LV_PER2     =  LV_PER2 * wa_konp_1-kbetr / LV_PER .
*    LV_PER2     =  LV_PER2 / 2.
          WA_DUMMY-AMT_DOCCUR   = LV_PER2.

          ENDIF.

      APPEND WA_DUMMY to it_dummy.
      CLEAR :WA_DUMMY , LV_PER,LV_PER2,wa_konp_1,wa_konp,WA_t030k,WA_t030k_1.
      ENDDO.
      CLEAR :LV_COUNT,lv_item1.
      ENDIF.
      ENDLOOP.
      ENDIF.

*calculating amount tax for main AMT_DOCCUR
DATA : LV_AMOUNT TYPE p DECIMALS 2.
         data :  lv_bukrs TYPE BKPF-BUKRS ,
                 lv_MWSKZ TYPE bseg-MWSKZ,
                 lv_waers TYPE bkpf-WAERS,
                 lv_wrbtr TYPE bseg-WRBTR,
                 lv_FWSTE TYPE BSET-FWSTE.
LOOP at IT_FILE_1 INTO wa_file_1 .
    IF  wa_file_1-tax_code is NOT INITIAL and  wa_file_1-tax_code ne 'V0'.

       SELECT SINGLE KSCHL,
               ALAND,
               MWSKZ,
               KNUMH
               from A003
               INTO  @data(wa_a003_2)
               WHERE MWSKZ = @wa_file_1-TAX_CODE
               AND   KSCHL  IN ( 'JICG'  ) .
        WA_DUMMY-COND_KEY =  wa_a003_2-KSCHL.

*condition record no and amount
        SELECT SINGLE KNUMH ,
              KBETR FROM KONP
              INTO @data(wa_konp_2)
               WHERE KNUMH = @wa_a003_2-KNUMH.


           wa_konp_2-kbetr     =  wa_konp_2-kbetr / 10 .
                data(lv_kbetr1)   = wa_konp_2-kbetr .

         lv_kbetr1 =  lv_kbetr1 + lv_kbetr1.

           LV_PER1   = 100 +  lv_kbetr1.
          LV_PER3  =   wa_file_1-AMT_DOCCUR.

*          LV_AMOUNT     =  LV_PER3 * lv_kbetr1 / LV_PER1 .
*          LV_PER3    = LV_PER3 - LV_AMOUNT.
*          wa_file_1-AMT_DOCCUR = LV_PER3 .


        lv_bukrs = wa_file_1-COMP_CODE.
        lv_MWSKZ = wa_file_1-TAX_CODE.
        lv_waers = wa_file_1-CURRENCY.
        lv_wrbtr = wa_file_1-AMT_DOCCUR.

          CALL FUNCTION 'CALCULATE_TAX_FROM_GROSSAMOUNT'
            EXPORTING
              I_BUKRS                       = lv_bukrs
              I_MWSKZ                       = lv_MWSKZ
              I_WAERS                       = lv_waers
              I_WRBTR                       = lv_wrbtr
           IMPORTING
             E_FWAST                        = lv_FWSTE.

           wa_file_1-AMT_DOCCUR = wa_file_1-AMT_DOCCUR - lv_FWSTE .
           wa_file_1-AMT_BASE   = wa_file_1-AMT_DOCCUR.
     MODIFY IT_FILE_1 FROM wa_file_1  TRANSPORTING AMT_DOCCUR AMT_BASE.
     CLEAR : wa_file_1 ,LV_PER1,LV_PER3,wa_konp_2,lv_kbetr1,LV_AMOUNT,wa_a003_2.
     CLEAR :lv_bukrs ,  lv_MWSKZ,lv_waers, lv_wrbtr.
    ENDIF .
 ENDLOOP.

   DATA : d1 LIKE sy-datum,
          d2 LIKE sy-datum.
  it_file_11 = it_file_1.
  SORT it_file_1 by sr_no.
  SORT it_file_11 by sr_no.
  DELETE ADJACENT DUPLICATES FROM it_file_11 COMPARING sr_no.

  LOOP at it_file_11 INTO wa_file_11.


  wa_DOCUMENTHEADER-username      = sy-uname.
  wa_DOCUMENTHEADER-BUS_ACT       =  'RFBU'.  "wa_file_1-BUS_ACT.
  wa_DOCUMENTHEADER-HEADER_TXT    = wa_file_1-HEADER_TXT.
  wa_DOCUMENTHEADER-COMP_CODE     = wa_file_11-COMP_CODE.
  wa_DOCUMENTHEADER-FISC_YEAR     = wa_file_11-FISC_YEAR .
  wa_DOCUMENTHEADER-DOC_TYPE      = wa_file_11-DOC_TYPE  .
  wa_DOCUMENTHEADER-REF_DOC_NO    = wa_file_11-REF_DOC_NO.

  CONCATENATE   wa_file_11-DOC_DATE+6(4)
                wa_file_11-DOC_DATE+3(2)
                wa_file_11-DOC_DATE+(2) INTO d1.

    CONCATENATE wa_file_11-PSTNG_DATE+6(4)
                wa_file_11-PSTNG_DATE+3(2)
                wa_file_11-PSTNG_DATE+(2) INTO d2.

    wa_DOCUMENTHEADER-DOC_DATE      = d1.
    wa_DOCUMENTHEADER-PSTNG_DATE    = d2.



  DATA : lv_item    LIKE bapiacgl09-itemno_acc.
    lv_item = '1'.
    CLEAR : wa_file_1.
    REFRESH : wa_ACCOUNTGL[].
    REFRESH : wa_ACCOUNTPAYABLE[].
    REFRESH : wa_CURRENCYAMOUNT[].

    LOOP at it_file_1 INTO wa_file_1 WHERE sr_no = wa_file_11-sr_no.
    if wa_file_1-DE_CRE_IND = 'H'.
       wa_file_1-AMT_DOCCUR = wa_file_1-AMT_DOCCUR * -1.

    ENDIF.
* ACCOUNTGL
  if wa_file_1-COSTCENTER NE ' '.
    wa_ACCOUNTGL-ITEMNO_ACC  = lv_item.
    wa_ACCOUNTGL-GL_ACCOUNT  = wa_file_1-GL_ACCOUNT.
    wa_ACCOUNTGL-ITEM_TEXT   = wa_file_1-ITEM_TEXT.
    wa_ACCOUNTGL-ALLOC_NMBR  = wa_file_1-ALLOC_NMBR.
    wa_ACCOUNTGL-TAX_CODE    = wa_file_1-TAX_CODE.
    wa_ACCOUNTGL-COSTCENTER  = wa_file_1-COSTCENTER. "'0000110101'. "wa_file_1-COSTCENTER.
    wa_accountgl-profit_ctr  = '0000002600'.
    wa_ACCOUNTGL-ITEMNO_TAX  = lv_item.

 CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
   EXPORTING
     INPUT         = wa_ACCOUNTGL-GL_ACCOUNT
  IMPORTING
    OUTPUT        = wa_ACCOUNTGL-GL_ACCOUNT.
  APPEND wa_ACCOUNTGL.

  ELSEIF wa_file_1-VENDOR_NO NE ' '.

*   *ACCOUNTPAYABLE
    wa_ACCOUNTPAYABLE-ITEMNO_ACC     =  lv_item.
    wa_ACCOUNTPAYABLE-VENDOR_NO      = wa_file_1-VENDOR_NO .
    wa_ACCOUNTPAYABLE-ITEM_TEXT      = wa_file_1-ITEM_TEXT.
    wa_ACCOUNTPAYABLE-BUSINESSPLACE  = wa_file_1-BUSINESSPLACE.
    wa_ACCOUNTPAYABLE-SECTIONCODE    = wa_file_1-SECTIONCODE.

     CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = wa_ACCOUNTPAYABLE-VENDOR_NO
          IMPORTING
            output = wa_ACCOUNTPAYABLE-VENDOR_NO.
    APPEND wa_ACCOUNTPAYABLE.

   ENDIF.

*   *  CURRENCYAMOUNT
    wa_CURRENCYAMOUNT-ITEMNO_ACC     = lv_item.
    wa_CURRENCYAMOUNT-CURRENCY       = wa_file_1-CURRENCY.
    wa_CURRENCYAMOUNT-AMT_DOCCUR     = wa_file_1-AMT_DOCCUR.

    if wa_file_1-DE_CRE_IND = 'H'.
       wa_file_1-AMT_BASE = wa_file_1-AMT_BASE * -1.
    ENDIF.

    wa_CURRENCYAMOUNT-AMT_BASE       = wa_file_1-AMT_BASE.  "NOW

    APPEND  wa_CURRENCYAMOUNT.


    CLEAR : wa_CURRENCYAMOUNT.
    CLEAR: wa_CURRENCYAMOUNT.
    CLEAR: wa_ACCOUNTPAYABLE.
    CLEAR: wa_ACCOUNTGL.
    CLEAR: wa_ACCOUNTTAX.
    lv_item = lv_item + 1.
  ENDLOOP.

  DATA : lv_item_2 TYPE i,
         lv_item_3 TYPE i,
         lv_cal    TYPE BAPIDOCCUR.
  DESCRIBE TABLE wa_ACCOUNTGL LINES data(lv_lines).

******  now
   lv_item = lv_item + 1.
   LOOP at it_file_1 INTO wa_file_1 WHERE sr_no = wa_file_11-sr_no.
   check WA_FILE_1-TAX_CODE is not initial.
   LOOP at it_dummy INTO WA_DUMMY WHERE GL_ACCOUNT = wa_file_1-GL_ACCOUNT
                                   AND  VENDOR_NO = wa_file_1-VENDOR_NO.

*lv_lines = lv_lines + 1.

   wa_ACCOUNTTAX-ITEMNO_ACC     = lv_item . "lv_lines.
   wa_ACCOUNTTAX-GL_ACCOUNT     = WA_DUMMY-GL_ACCOUNT_1.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
   EXPORTING
     INPUT         = WA_DUMMY-GL_ACCOUNT
  IMPORTING
     OUTPUT        = WA_DUMMY-GL_ACCOUNT.

   wa_ACCOUNTTAX-COND_KEY      = WA_DUMMY-COND_KEY.
   wa_ACCOUNTTAX-ACCT_KEY      = WA_DUMMY-ACCT_KEY.
   wa_ACCOUNTTAX-TAX_CODE      = WA_DUMMY-TAX_CODE.
   wa_ACCOUNTTAX-TAX_RATE      = WA_DUMMY-TAX_RATE.
   wa_ACCOUNTTAX-ITEMNO_TAX    = lv_lines.  "NOW ADDED

    APPEND : wa_ACCOUNTTAX.

    wa_CURRENCYAMOUNT-ITEMNO_ACC     = lv_item. "lv_lines .
    wa_CURRENCYAMOUNT-CURRENCY       = 'INR'.
    wa_CURRENCYAMOUNT-AMT_DOCCUR     = wa_dummy-AMT_DOCCUR.
    if WA_DUMMY-DE_CRE_IND = 'H'.
       WA_DUMMY-AMT_BASE = WA_DUMMY-AMT_BASE * -1.
    ENDIF.
*    for base price
    lv_cal  = wa_dummy-AMT_DOCCUR + wa_dummy-AMT_DOCCUR.
    wa_CURRENCYAMOUNT-AMT_BASE       = WA_DUMMY-AMT_BASE - lv_cal.   "NOW

    APPEND  wa_CURRENCYAMOUNT.
     lv_item = lv_item + 1.

     Clear: lv_cal,WA_DUMMY.
    endloop.
    endloop.
   CLEAR : lv_lines.

data :lv_count2 TYPE p DECIMALS 2.
data :lv_count3 TYPE p DECIMALS 2.
data :lv_var    TYPE p DECIMALS 2.

    CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
      EXPORTING
        documentheader = wa_DOCUMENTHEADER
      IMPORTING
        obj_type       = wa_DOCUMENTHEADER-obj_type
        obj_key        = wa_DOCUMENTHEADER-obj_key
        obj_sys        = wa_DOCUMENTHEADER-obj_sys
      TABLES
*       criteria       = criteria
        accountgl      = wa_ACCOUNTGL
        accountpayable = wa_ACCOUNTPAYABLE
        ACCOUNTTAX     = wa_ACCOUNTTAX
        currencyamount = wa_CURRENCYAMOUNT
        return         = wa_return.

     READ TABLE wa_return WITH KEY type = 'E'.
    IF  sy-subrc = 0.
      LOOP AT wa_return WHERE type = 'E'.
        IF sy-tabix = 2.
          MOVE : wa_return-message TO wa_file_11-remark.
        ENDIF.
       ENDLOOP.
    ELSE.
       CLEAR :wa_return.
       REFRESH : wa_return.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
       EXPORTING
         WAIT          = 'X'
*       IMPORTING
*         RETURN        =
                .
      MOVE :   wa_DOCUMENTHEADER-obj_key+(10)    TO wa_file_11-belnr. "wa_DOCUMENTHEADER-obj_key
      MOVE :  'Document Posted '                 TO wa_file_11-remark. "wa_DOCUMENTHEADER-obj_key

    ENDIF.
  APPEND :wa_file_11 TO it_file_12.
  CLEAR : wa_file_11.
  CLEAR : wa_DOCUMENTHEADER ,lv_count2,lv_count3,lv_var ,lv_KBETR,LV_ITEM1,
          lv_count,LV_PER  ,LV_PER1 ,LV_PER2 ,LV_PER3 .

  REFRESH :wa_ACCOUNTGL,
           wa_CURRENCYAMOUNT,
           wa_ACCOUNTPAYABLE,
           wa_ACCOUNTTAX,
*           it_dummy,
           wa_return.
*  ENDLOOP.
  ENDLOOP.


  if it_file_12 is NOT INITIAL.
    LOOP at it_file_1 INTO wa_file_1.
      READ TABLE it_file_12 INTO wa_file_12 with key sr_no =  wa_file_1-sr_no.
       if sy-subrc = 0 .
         move : wa_file_12-belnr  TO wa_file_1-belnr.
         move : wa_file_12-remark TO wa_file_1-remark.
       ENDIF.
       MODIFY :it_file_1 from wa_file_1.
    ENDLOOP.
    PERFORM : display_alv.

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

  DATA:n TYPE string VALUE 1.

  wa_fieldcat-col_pos = n.
  wa_fieldcat-fieldname = 'SR_NO'.
  wa_fieldcat-seltext_m = 'Sr.No.'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR : wa_fieldcat.

   wa_fieldcat-col_pos = n.
  wa_fieldcat-fieldname = 'HEADER_TXT'.
  wa_fieldcat-seltext_m = 'Header Text'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR : wa_fieldcat.

  wa_fieldcat-col_pos = n.
  wa_fieldcat-fieldname = 'COMP_CODE'.
  wa_fieldcat-seltext_m = 'Com. Code'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR : wa_fieldcat.

  wa_fieldcat-col_pos = n.
  wa_fieldcat-fieldname = 'DOC_DATE'.
  wa_fieldcat-seltext_m = 'Doc. Date'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR : wa_fieldcat.

  wa_fieldcat-col_pos = n.
  wa_fieldcat-fieldname = 'DOC_TYPE'.
  wa_fieldcat-seltext_m = 'Doc. Dt'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR : wa_fieldcat.

  wa_fieldcat-col_pos = n.
  wa_fieldcat-fieldname = 'PSTNG_DATE'.
  wa_fieldcat-seltext_m = 'Posting Date'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR : wa_fieldcat.

  wa_fieldcat-col_pos = n.
  wa_fieldcat-fieldname = 'FISC_YEAR'.
  wa_fieldcat-seltext_m = 'Fical_year'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR : wa_fieldcat.

  wa_fieldcat-col_pos = n.
  wa_fieldcat-fieldname = 'REF_DOC_NO'.
  wa_fieldcat-seltext_m = 'Ref.'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR : wa_fieldcat.

  wa_fieldcat-col_pos = n.
  wa_fieldcat-fieldname = 'DE_CRE_IND'.
  wa_fieldcat-seltext_m = 'Debit_Credit'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR : wa_fieldcat.

  wa_fieldcat-col_pos = n.
  wa_fieldcat-fieldname = 'ITEMNO_ACC'.
  wa_fieldcat-seltext_m = 'Item'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR : wa_fieldcat.

  wa_fieldcat-col_pos = n.
  wa_fieldcat-fieldname = 'GL_ACCOUNT'.
  wa_fieldcat-seltext_m = 'Account'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR : wa_fieldcat.

  wa_fieldcat-col_pos = n.
  wa_fieldcat-fieldname = 'ITEM_TEXT'.
  wa_fieldcat-seltext_m = 'Item_Text'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR : wa_fieldcat.

  wa_fieldcat-col_pos = n.
  wa_fieldcat-fieldname = 'COSTCENTER'.
  wa_fieldcat-seltext_m = 'Cost_Center'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR : wa_fieldcat.

  wa_fieldcat-col_pos = n.
  wa_fieldcat-fieldname = 'VENDOR_NO'.
  wa_fieldcat-seltext_m = 'Vendor_No'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR : wa_fieldcat.

  wa_fieldcat-col_pos = n.
  wa_fieldcat-fieldname = 'BUSINESSPLACE'.
  wa_fieldcat-seltext_m = 'Business_Place'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR : wa_fieldcat.

  wa_fieldcat-col_pos = n.
  wa_fieldcat-fieldname = 'SECTIONCODE'.
  wa_fieldcat-seltext_m = 'Section Code'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR : wa_fieldcat.

  wa_fieldcat-col_pos = n.
  wa_fieldcat-fieldname = 'CURRENCY'.
  wa_fieldcat-seltext_m = 'Currency'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR : wa_fieldcat.

  wa_fieldcat-col_pos = n.
  wa_fieldcat-fieldname = 'ALLOC_NMBR'.
  wa_fieldcat-seltext_m = 'Assignment'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR : wa_fieldcat.

  wa_fieldcat-col_pos = n.
  wa_fieldcat-fieldname = 'TAX_CODE'.
  wa_fieldcat-seltext_m = 'Tax Code'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR : wa_fieldcat.

  wa_fieldcat-col_pos = n.
  wa_fieldcat-fieldname = 'AMT_DOCCUR'.
  wa_fieldcat-seltext_m = 'Amount'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR : wa_fieldcat.

  wa_fieldcat-col_pos = n.
  wa_fieldcat-fieldname = 'BELNR'.
  wa_fieldcat-seltext_m = 'Doc. No.'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR : wa_fieldcat.


  wa_fieldcat-col_pos = n.
  wa_fieldcat-fieldname = 'REMARK'.
  wa_fieldcat-seltext_m = 'Message With Status'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR : wa_fieldcat.

  is_layout-colwidth_optimize = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = sy-repid
      i_callback_user_command = 'UCOMM'
      is_layout               = is_layout
      it_fieldcat             = it_fieldcat[]
    TABLES
      t_outtab                = it_file_1.
* EXCEPTIONS
*     PROGRAM_ERROR           = 1
*     OTHERS                  = 2
  .
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
