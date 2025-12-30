
*SELECT * FROM J_1IG_ISD_DISTR
*INTO TABLE IT_J_1IG_ISD_DISTR
*WHERE REC_BELNR = J_1IG_ISD_DISTR-REC_BELNR.




LOOP AT IT_ISD INTO WA_ISD.


ENDLOOP.










*DATA: LV_BUKRS  TYPE BUKRS.

*GT_REFDL[] = IT_REFDL[].
*GT_REFOR[] = IT_REFOR[].
*GT_REFPO[] = IT_REFPO[].
*
*"Check if the Deliv. numbers of all items are same.
*"And delete the rows with same delivery numbers.
*DELETE ADJACENT DUPLICATES FROM GT_REFDL
*COMPARING DELIV_NUMB.
*
*
*DELETE ADJACENT DUPLICATES FROM GT_REFOR
*COMPARING ORDER_NUMB.
*
*"Check the numbers of lines left.
*DESCRIBE TABLE GT_REFDL LINES GV_TABIX.
*IF GV_TABIX GT 1.
*  GV_TEMPD = 'X'. "Set suitable flag.
*ENDIF.
*CLEAR GV_TABIX.
*DESCRIBE TABLE GT_REFOR LINES GV_TABIX.
*IF GV_TABIX GT 1.
*  GV_TEMPS = 'X'. "Set suitable flag.
*  GV_TEMPP = 'X'. "Set suitable flag.
*ENDIF.
*
******Sagar*************************************************************
*
****
**BREAK-POINT.
*DATA : GT_J_1IEXCDTL LIKE TABLE OF J_1IEXCDTL WITH HEADER LINE.
*
*  SELECT SINGLE * FROM VBRP
*    INTO CORRESPONDING FIELDS OF GS_VBRP
*    WHERE VBELN = IS_HDREF-BIL_NUMBER .
*  IF SY-SUBRC = 0.
**      is_hdref-bil_number = gs_vbrp-vbeln.
*    SELECT SINGLE WAERK "doc. currency
**              KURRF "exc. rate
*            FKART "doc. type
*            KNUMV "doc. condition
*            BUKRS "Company Code
*            KALSM "Pricing procedure        *************
*    FROM VBRK
*    INTO (GV_WAERK, GV_FKART, GV_KNUMV, LV_BUKRS, GV_KALSM)"gv_kurrf,
*    WHERE VBELN = GS_VBRP-VBELN.
*
*    SELECT SINGLE KURSK POSNR
*    FROM VBRP
*    INTO (GV_KURRF, GV_POSNR)
*    WHERE VBELN = GS_VBRP-VBELN.
***********************************************************************
**   SELECT * FROM konv
**  INTO CORRESPONDING FIELDS OF TABLE gt_kond
**  WHERE knumv = gv_knumv.
*  ELSE.
*****End****************************************************************
*
**
*    "to get the exchange rate if not in INR
*    SELECT SINGLE WAERK "doc. currency
**                  KURRF "exc. rate
*                  FKART "doc. type
*                  KNUMV "doc. condition
*                  BUKRS "Company Code
*                  KALSM "Pricing procedure        *************
*      FROM VBRK
*      INTO (GV_WAERK, GV_FKART, GV_KNUMV, LV_BUKRS, GV_KALSM)"gv_kurrf,
*      WHERE VBELN = IS_HDREF-BIL_NUMBER.
*
*    SELECT SINGLE KURSK POSNR
*     FROM VBRP
*     INTO (GV_KURRF, GV_POSNR)
*     WHERE VBELN = IS_HDREF-BIL_NUMBER.
***********************************************************************
*
*  ENDIF.
**ENDIF.
*
*" Begin of chnages by naga on 31.10.2023.
**BREAK-POINT.
*if LV_BUKRS is NOT INITIAL.
*   SELECT SINGLE paval
*     from T001Z
*     INTO lw_J_1IPANNO
*     WHERE bukrs = lv_bukrs
*      and PARTY = 'J_1I02'.
*  endif.
*
*" End of chnages by naga on 31.10.2023.
*
*
*BREAK SALES.
**
**"if doc. currency is not INR
*IF GV_WAERK <> 'INR'.
*  IF GV_PR00 IS NOT INITIAL.  "accesseble value
*    GV_PR00 = GV_PR00 * GV_KURRF.
*  ENDIF.
*
*  IF GV_P101 IS NOT INITIAL.  "accesseble value FOR STO
*    GV_P101 = GV_P101 * GV_KURRF.
*  ENDIF.
*
*  IF GV_ZVAL IS NOT INITIAL. "accessible value
*    "doc type 'ZCON' only
*    GV_ZVAL =  GV_ZVAL * GV_KURRF.
*  ENDIF.
**if gv_fkart <> 'ZEOU'.
*  IF GV_JEXP IS  NOT INITIAL.
*    GV_JEXP = GV_JEXP * GV_KURRF.
*  ENDIF.
*
*  IF GV_JECS IS  NOT INITIAL.
*    GV_JECS = GV_JECS * GV_KURRF.
*  ENDIF.
*
*  IF GV_JA1X IS  NOT INITIAL.
*    GV_JA1X = GV_JA1X * GV_KURRF.
*  ENDIF.
*
**endif.
*  IF GV_ZKFR IS NOT INITIAL. "freight
*    GV_ZKFR =  GV_ZKFR * GV_KURRF.
*  ENDIF.
*  IF GV_ZFRV IS NOT INITIAL. "freight
*    GV_ZFRV =  GV_ZFRV * GV_KURRF.
*  ENDIF.
*  IF GV_JIVC IS NOT INITIAL. "CST
*    GV_JIVC =  GV_JIVC * GV_KURRF.
*  ENDIF.
*  IF GV_JIVP IS NOT INITIAL. "VAT
*    GV_JIVP =  GV_JIVP * GV_KURRF.
*  ENDIF.
*  IF GV_ZINS IS NOT INITIAL. "insurance
*    GV_ZINS =  GV_ZINS * GV_KURRF.
*  ENDIF.
*   IF GV_AD_FEE IS NOT INITIAL.
*    GV_AD_FEE = GV_AD_FEE * GV_KURRF.
*  ENDIF.
*ENDIF.
*
** Added by Omkar28/07/2010
*IF GV_FKART EQ 'ZEXP' OR GV_FKART EQ 'ZF8' ."OR GV_FKART EQ 'ZST1' .
*
*  PERFORM ROUNDOFF USING LV_BUKRS CHANGING GV_PR00.
*  PERFORM ROUNDOFF USING LV_BUKRS CHANGING GV_P101.
*  PERFORM ROUNDOFF USING LV_BUKRS CHANGING GV_ZVAL.
*  PERFORM ROUNDOFF USING LV_BUKRS CHANGING GV_JEXP.
*  PERFORM ROUNDOFF USING LV_BUKRS CHANGING GV_JECS.
*  PERFORM ROUNDOFF USING LV_BUKRS CHANGING GV_JA1X.
*  PERFORM ROUNDOFF USING LV_BUKRS CHANGING GV_ZKFR.
*  PERFORM ROUNDOFF USING LV_BUKRS CHANGING GV_ZFRV.
*  PERFORM ROUNDOFF USING LV_BUKRS CHANGING GV_JIVC.
*  PERFORM ROUNDOFF USING LV_BUKRS CHANGING GV_JIVP.
*  PERFORM ROUNDOFF USING LV_BUKRS CHANGING GV_ZINS.
*
*ENDIF.
*
*
*
*IF GV_FKART = 'ZEXP' OR GV_FKART EQ 'ZST1'.
**  "if doc. type is ZEXP there are 2 options
**  "as export under BOND exp. type is 'B'
**  "Export Under Rebate exp. type is 'N'
**  "Export under Letter Of undertaking exp. type is 'U'
*  SELECT SINGLE EXPIND
*    FROM J_1IEXCHDR
*    INTO GV_EXPIND
*    WHERE EXNUM = IS_J_1IEXCHDR-EXNUM
*    AND EXDAT = IS_J_1IEXCHDR-EXDAT.
*  IF SY-SUBRC = 0.
*    IF GV_EXPIND = 'N'.
*      CLEAR:GV_JIVC, GV_JIVP.
*      GV_TOTAL = GV_ZVAL + GV_PR00 + GV_JEXP
*                  + GV_JECS + GV_P101
*                  + GV_JA1X + GV_ZKFR + GV_ZFRV
*                  + GV_ZINS + GV_DIFF.
*    ELSEIF
*     GV_EXPIND = 'B' OR GV_EXPIND = 'U'.
*      CLEAR:GV_JEXP, GV_JECS, GV_JA1X.
*      GV_TOTAL = GV_ZVAL + GV_PR00 + GV_P101
*      + GV_ZKFR + GV_ZFRV + GV_JIVC
*      + GV_JIVP + GV_ZINS + GV_DIFF.
*    ELSE.
*    CLEAR:GV_JEXP, GV_JECS.
*    IF OPTION = 'REBATE'.
*      GV_TOTAL = GV_ZVAL + GV_PR00 + GV_P101 + GV_JA1X
*      + GV_ZKFR + GV_ZFRV + GV_JIVC
*      + GV_JIVP + GV_ZINS + GV_DIFF.
*    ELSEIF OPTION = 'BOND'.
*      CLEAR:GV_JEXP, GV_JECS , GV_JA1XPERC , GV_JA1X.
*    GV_TOTAL = GV_ZVAL + GV_PR00 + GV_P101
*      + GV_ZKFR + GV_ZFRV + GV_JIVC
*      + GV_JIVP + GV_ZINS + GV_DIFF.
*    ENDIF.
*    ENDIF.
*    ELSE.
*     CLEAR:GV_JEXP, GV_JECS.
*      GV_TOTAL = GV_ZVAL + GV_PR00 + GV_P101
*      + GV_ZKFR + GV_ZFRV + GV_JIVC
*      + GV_JIVP + GV_ZINS + GV_DIFF.
*  ENDIF.
*ENDIF.
*
*IF GV_FKART = 'ZF8'.
**  "if doc. type is ZEXP there are 2 options
**  "as export under BOND exp. type is 'B'
**  "Export Under Rebate exp. type is 'N'
**  "Export under Letter Of undertaking exp. type is 'U'
*  CLEAR:GV_ZKFRPER,GV_ZKFRUNIT.
*  SELECT SINGLE EXPIND
*    FROM J_1IEXCHDR
*    INTO GV_EXPIND
*    WHERE EXNUM = IS_J_1IEXCHDR-EXNUM
*    AND EXDAT = IS_J_1IEXCHDR-EXDAT.
*  IF SY-SUBRC = 0.
*    IF GV_EXPIND = 'N'.
*      CLEAR:GV_JIVC, GV_JIVP.
*      GV_TOTAL = GV_ZVAL + GV_PR00 + GV_JEXP
*                  + GV_JECS + GV_P101
*                  + GV_JA1X + GV_ZKFR + GV_ZFRV
*                  + GV_ZINS + GV_DIFF.
*
*    ELSEIF
*     GV_EXPIND = 'B' OR GV_EXPIND = 'U'.
*      CLEAR:GV_JEXP, GV_JECS, GV_JA1X, GV_JEXPPERC,
*            GV_JECSPERC, GV_JA1XPERC.
*      GV_TOTAL = GV_ZVAL + GV_PR00 + GV_P101
*      + GV_ZKFR + GV_ZFRV + GV_JIVC
*      + GV_JIVP + GV_ZINS + GV_DIFF.
*
*    ELSEIF GV_EXPIND <> 'N'
*      OR GV_EXPIND <> 'B'
*      OR GV_EXPIND <> 'U'.
*      GV_TOTAL = GV_ZVAL + GV_PR00 + GV_JEXP + GV_JECS + GV_P101
*        + GV_JA1X + GV_ZKFR + GV_ZFRV + GV_JIVC
*        + GV_JIVP + GV_ZINS + GV_DIFF.
*    ENDIF.
*  ENDIF.
*ENDIF.
*
*
*
*"Get Excise Duty Amount
*GV_EXCTOT = GV_JEXP + GV_JECS + GV_JA1X.
*
*
*"to extract data from "zopass" table
*
*
*"time of removal in words
*GV_TIME1 = IS_J_1IEXCHDR-REMTIME(2).
*GV_TIME2 = IS_J_1IEXCHDR-REMTIME+2(2).
*GV_TIME3 = IS_J_1IEXCHDR-REMTIME+4(2).
*
*IF GV_TIME1 IS NOT INITIAL.
*  CALL FUNCTION 'SPELL_AMOUNT'
*   EXPORTING
*     AMOUNT          = GV_TIME1
**       CURRENCY        = ' '
**       FILLER          = ' '
*     LANGUAGE        = 'E'
*   IMPORTING
*     IN_WORDS        = GV_TI_WORD
*   EXCEPTIONS
*     NOT_FOUND       = 1
*     TOO_LARGE       = 2
*     OTHERS          = 3
*            .
*  IF SY-SUBRC <> 0.
**MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.
*  CONCATENATE GV_TI_WORD-WORD 'Hrs'
*  INTO GV_TI_WORD-WORD
*  SEPARATED BY SPACE.
*ENDIF.
*
*IF GV_TIME2 IS NOT INITIAL.
*  CALL FUNCTION 'SPELL_AMOUNT'
* EXPORTING
*   AMOUNT          = GV_TIME2
**   CURRENCY        = ' '
**   FILLER          = ' '
*   LANGUAGE        = 'E'
* IMPORTING
*   IN_WORDS        = GV_TI2_WORD
* EXCEPTIONS
*   NOT_FOUND       = 1
*   TOO_LARGE       = 2
*   OTHERS          = 3
*          .
*  IF SY-SUBRC <> 0.
**MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.
*  CONCATENATE GV_TI2_WORD-WORD 'Mins'
*  INTO GV_TI2_WORD-WORD
*  SEPARATED BY SPACE.
*ENDIF.
*
*IF GV_TIME3 IS NOT INITIAL.
*  CALL FUNCTION 'SPELL_AMOUNT'
*   EXPORTING
*     AMOUNT          = GV_TIME3
**   CURRENCY        = ' '
**   FILLER          = ' '
*     LANGUAGE        = 'E'
*   IMPORTING
*     IN_WORDS        = GV_TI3_WORD
*   EXCEPTIONS
*     NOT_FOUND       = 1
*     TOO_LARGE       = 2
*     OTHERS          = 3
*            .
*  IF SY-SUBRC <> 0.
**MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.
*
*  CONCATENATE GV_TI3_WORD-WORD 'Secs'
*  INTO GV_TI3_WORD-WORD
*  SEPARATED BY SPACE.
*ENDIF.
*CONCATENATE GV_TI_WORD-WORD GV_TI2_WORD-WORD
*GV_TI3_WORD-WORD
*INTO GV_TIME_WORD
*SEPARATED BY SPACE.
*
**Added By Girish (AAKIT) 27th Aug 2011
**Additional Excise Duty
*SELECT SINGLE EXAED INTO GV_EXAED
*  FROM J_1IEXCHDR
*  WHERE EXNUM EQ IS_J_1IEXCHDR-EXNUM
*  AND EXDAT = IS_J_1IEXCHDR-EXDAT.
*
*GV_TOTAL = GV_TOTAL + GV_EXAED.
*
*
*GV_EXCTOT = GV_EXCTOT + GV_EXAED.
*
*IF GV_EXCTOT IS NOT INITIAL.
*  "Get Excise Duty Amount in Words.
*  CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
*    EXPORTING
*      AMT_IN_NUM         = GV_EXCTOT
*    IMPORTING
*      AMT_IN_WORDS       = GV_EXWRDS
*    EXCEPTIONS
*      DATA_TYPE_MISMATCH = 1
*      OTHERS             = 2.
*  IF SY-SUBRC <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ELSEIF SY-SUBRC = 0.
*    SHIFT GV_EXWRDS LEFT DELETING LEADING SPACE.
*    TRANSLATE GV_EXWRDS TO LOWER CASE.
*    CONCATENATE GV_EXWRDS 'only' INTO GV_EXWRDS
*    SEPARATED BY SPACE.
*  ENDIF.
*ELSE.
*  GV_EXWRDS = '--------- NIL ---------'.
*ENDIF.
*
*"Get Invoice Amount in Words.
*CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
*  EXPORTING
*    AMT_IN_NUM         = GV_TOTAL
*  IMPORTING
*    AMT_IN_WORDS       = GV_AMWRDS
*  EXCEPTIONS
*    DATA_TYPE_MISMATCH = 1
*    OTHERS             = 2.
*IF SY-SUBRC <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*ENDIF.
*
*SHIFT GV_AMWRDS LEFT DELETING LEADING SPACE.
*TRANSLATE GV_AMWRDS TO LOWER CASE.
*CONCATENATE GV_AMWRDS 'only' INTO GV_AMWRDS
*SEPARATED BY SPACE.
*
*
*SELECT SINGLE FKDAT INTO FKDAT
*  FROM VBRK WHERE VBELN = IS_HDREF-BIL_NUMBER.
*
*SELECT SINGLE IRN INTO IRN
*  FROM ZITA_EINV_9013 WHERE BELNR = IS_HDREF-BIL_NUMBER.
*
*"ADDED BY ARUN M ON 20.12.2023
*SELECT SINGLE * FROM VBRK
*INTO @data(GS_VBRK1)
*WHERE VBELN = @IS_HDREF-BIL_NUMBER.
*  IF sy-subrc = 0.
*SELECT SINGLE EIKTO FROM KNVV INTO (LV_EIKTO_1) WHERE KUNNR =
*GS_VBRK1-KUNAG and VKORG = GS_VBRK1-VKORG and VTWEG = GS_VBRK1-VTWEG
*and SPART = GS_VBRK1-SPART .
**and VKORG = '1000' and VTWEG = '10' and SPART = '20'.
*"ADDED BY ARUN M ON 20.12.2023
*  ENDIF.
*
*SELECT SINGLE * FROM VBPA
*INTO @data(GS_VBPA)
*WHERE VBELN = @IS_HDREF-BIL_NUMBER and PARVW = 'WE'.
*  IF sy-subrc = 0.
*SELECT SINGLE EIKTO FROM KNVV INTO (LV_SP_AAH) WHERE KUNNR =
*GS_VBPA-KUNNR and VKORG = GS_VBRK1-VKORG and VTWEG = GS_VBRK1-VTWEG
*and SPART = GS_VBRK1-SPART .
**and VKORG = '1000' and VTWEG = '10' and SPART = '20'.
*"ADDED BY ARUN M ON 21.12.2023
*  ENDIF.
