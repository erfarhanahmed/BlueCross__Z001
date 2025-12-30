BREAK sales.
CLEAR gv_rate_zcon.
TYPES:BEGIN OF lty_vbrk,
        vbeln TYPE  vbeln_vf,
        fkart	TYPE fkart,
        knumv	TYPE knumv,
      END OF lty_vbrk.
BREAK pwc_abap1.
DATA:lt_vbrk          TYPE TABLE OF lty_vbrk,
     lw_vbrk          TYPE          lty_vbrk,
     lt_prcd_elements TYPE TABLE OF prcd_elements,
     lw_prcd_elements TYPE          prcd_elements.
*
SELECT SINGLE vbeln
       fkart
       knumv
       FROM vbrk
       INTO lw_vbrk
       WHERE vbeln = is_hdref-bil_number.
IF sy-subrc EQ 0 and gv_fkart NE 'ZST4' .
  SELECT * FROM prcd_elements
           INTO TABLE lt_prcd_elements
           WHERE knumv = lw_vbrk-knumv.
ENDif.

   " ZST2
 IF gv_fkart EQ 'ZST4'.
SELECT SINGLE VBELV FROM VBFA  INTO @DATA(WA_VB) WHERE VBELN =
@lw_vbrk-VBELN .
SELECT SINGLE VBELV FROM LIPS INTO @DATA(WA_LIPS) WHERE VBELN =
@WA_VB.
SELECT SINGLE knumv from vbak INTO @data(wa_knumv) WHERE VBELN =
@WA_LIPS.
SELECT SINGLE KURSK from vbrp into @data(wa_kursk) WHERE VBELN =
  @lw_vbrk-VBELN .
  SELECT * FROM prcd_elements
           INTO TABLE lt_prcd_elements
           WHERE knumv = lw_vbrk-knumv ."wa_knumv.

endif.
"sk


IF sy-subrc EQ 0 ."and gv_fkart NE 'ZST4' .
    READ TABLE lt_prcd_elements INTO lw_prcd_elements
               WITH KEY kschl = 'ZPR0' kposn = gs_itgen-itm_number.
    IF sy-subrc EQ 0 .
      gv_rate_zcon = lw_prcd_elements-kbetr  .
      gv_base = lw_prcd_elements-kwert ."* lw_prcd_elements-KKURS.
     gv_rate_zcon = lw_prcd_elements-kwert / gs_itgen-fkimg.
      IF lw_prcd_elements-kwert IS INITIAL.
        gv_base = lw_prcd_elements-kbetr * gs_itgen-fkimg.
      ENDIF.
      gv_pr00 = gv_pr00 + gv_base.
    ENDIF.
CLEAR: gv_base.
LOOP AT lt_prcd_elements INTO lw_prcd_elements WHERE kschl = 'ZPR0'.
gv_base = gv_base  + lw_prcd_elements-kwert.
CLEAR: lw_prcd_elements.
ENDLOOP.
********************
*LOOP AT lt_prcd_elements INTO data(lw_prcd_elements1).
gv_tax = gv_base + gv_tax.   "added by nakul 24.6.25
*ENDLOOP.
********************
gv_rate_zcon = gv_base / gs_itgen-fkimg.

"sk
   IF gv_fkart EQ 'ZST4'.
    READ TABLE lt_prcd_elements INTO lw_prcd_elements
               WITH KEY kschl = 'ZPR0' kposn = gs_itgen-itm_number.
    IF sy-subrc EQ 0 .
      gv_rate_zcon = lw_prcd_elements-kbetr  .
      gv_base = lw_prcd_elements-kwert * wa_kursk.
     gv_rate_zcon = lw_prcd_elements-kwert / gs_itgen-fkimg.
      IF lw_prcd_elements-kwert IS INITIAL.
        gv_base = lw_prcd_elements-kbetr * gs_itgen-fkimg.
      ENDIF.
      "gv_pr00 = gv_pr00 + gv_base.
*      gv_pr00 = gv_base.   "commented by nakul
      gv_pr00 = gv_tax.   "added by nakul
    ENDIF.
endif.


    READ TABLE lt_prcd_elements INTO lw_prcd_elements
               WITH KEY kschl = 'ZFCL' kposn = gs_itgen-itm_number.
    IF sy-subrc EQ 0.
      gv_rate_zcon = lw_prcd_elements-kbetr.
      gv_base = lw_prcd_elements-kwert.
*      gv_pr00 = gv_pr00 + gv_base.   "commented by nakul
      gv_pr00 = gv_pr00 + gv_tax.    "added by nakul
    ENDIF.

    LOOP AT lt_prcd_elements INTO lw_prcd_elements.
*      WHERE kposn = gs_itgen-itm_number.
      CASE lw_prcd_elements-kschl.
        WHEN 'JOIG'. "Integrated GST " CHNGING ZOIG
"Commented by Arun m on 30.07.2024
          IF gv_fkart NE 'ZST2' AND gv_fkart NE 'ZST0'.
            gv_ja1xperc = lw_prcd_elements-kbetr.". "desc.
            gv_ja1x = gv_ja1x + lw_prcd_elements-kwert.
            IF gv_fkart = 'ZST1' OR gv_fkart = 'ZSEZ'.
              IF option = 'BOND'.
                CLEAR : gv_ja1xperc, gv_ja1x.
              ENDIF.
            ENDIF.
            ENDIF.
"Commented by Arun m on 30.07.2024
"Added by Arun m on 30.07.2024
*           IF gv_fkart NE 'ZST2' AND gv_fkart EQ 'ZST0'.
*            gv_ja1xperc = lw_prcd_elements-kbetr.". "desc.
*            gv_ja1x = gv_ja1x + lw_prcd_elements-kwert.
*            IF gv_fkart = 'ZST1' OR gv_fkart = 'ZSEZ'.
*              IF option = 'BOND'.
*                CLEAR : gv_ja1xperc, gv_ja1x.
*              ENDIF.
*            ENDIF.
"Added by Arun m on 30.07.2024

            IF gv_fkart = 'ZST3'.
              CLEAR : gv_ja1xperc, gv_ja1x.
            ENDIF.
*          ENDIF.
        WHEN 'ZOIG'.
          IF gv_fkart = 'ZST2'. "or  gv_fkart = 'ZST4' .
 " AND option = 'REBATE'.
            gv_ja1xperc = lw_prcd_elements-kbetr.". "desc.
            gv_ja1x = gv_ja1x + lw_prcd_elements-kwert.

            ELSEIF gv_fkart = 'ZST4'. "or  gv_fkart = 'ZST4' .
            gv_ja1xperc = lw_prcd_elements-kbetr . "desc.
            gv_ja1x = gv_ja1x + lw_prcd_elements-kwert * wa_kursk.".

          ENDIF.
        WHEN 'JOCG'. "CENTRAL GST
          IF gv_fkart NE 'ZST0'.
            gv_jexpperc =  lw_prcd_elements-kbetr..
            gv_jexp = gv_jexp + lw_prcd_elements-kwert.
          ENDIF.
        WHEN 'JOSG'. "STATE GST
          IF gv_fkart NE 'ZST0'.
            gv_jecsperc = lw_prcd_elements-kbetr.. "desc
            gv_jecs = gv_jecs + lw_prcd_elements-kwert.
          ENDIF.
        WHEN 'ZINS'.  "Insurance
          gv_zins = gv_zins + lw_prcd_elements-kwert.
        WHEN 'ZFR1' OR 'ZFR2'. "freight for lumsome in export
          gv_zfrv = gv_zfrv + lw_prcd_elements-kwert.
          gv_zfrvper = lw_prcd_elements-kbetr.
          IF lw_prcd_elements-kpein = '1000'.
            IF lw_prcd_elements-kmein = 'L'.
              gv_zkfrunit = 'KL'.
            ELSEIF lw_prcd_elements-kmein = 'KG'.
              gv_zkfrunit = 'TO'.
            ENDIF.
          ELSEIF lw_prcd_elements-kpein = '1'.
            gv_zkfrunit = lw_prcd_elements-kmein.
          ENDIF.
        WHEN 'ZCMP'.
          BREAK pwc_abap1.
          zcmp_rate = lw_prcd_elements-kbetr.
          gv_zcmp = gv_zcmp + lw_prcd_elements-kwert.
        WHEN 'ZTCS'.
          BREAK pwc_abap1.
          ztcs_rate = lw_prcd_elements-kbetr.
          gv_ztcs = gv_ztcs + lw_prcd_elements-kwert.
        when 'JTC1'.
        GV_JTC1_PER = lw_prcd_elements-kbetr.
       gv_jtc1 = gv_jtc1 + lw_prcd_elements-kwert.

      ENDCASE.
    ENDLOOP.
    gv_pr00 = gv_tax.
    gv_total = gv_zfrv + gv_zins + gv_jexp
           + gv_jecs +  gv_pr00 + gv_ja1x + gv_zcmp + gv_ztcs
           + gv_jtc1.

  ENDIF.

*   " ZST2
* IF gv_fkart EQ 'ZST2'.
*SELECT SINGLE VBELV FROM VBFA  INTO @DATA(WA_VBELV) WHERE VBELN =
*lw_vbrk-VBELN AND VBTYP_N = 'J'.
*SELECT SINGLE VBELV FROM LIPS INTO @DATA(WA_LIPS) WHERE VBELV =
*@WA_VBELV.
*SELECT SINGLE knumv from vbak INTO @data(wa_knumv) WHERE VBELNVBELV.
*
*
*
data: num1 TYPE J_1ITAXVAR-J_1ITAXAM1.

DATA AMT_IN_NUM TYPE J_1ITAXVAR-J_1ITAXAM1.
AMT_IN_NUM =  gv_total.


CALL FUNCTION 'J_1I6_ROUND_TO_NEAREST_AMT'
 EXPORTING
    I_AMOUNT                 = AMT_IN_NUM
       IMPORTING
          E_AMOUNT       = num1.

 gv_total = num1.


IF gs_itgen-material = 'FULLLLCOALLLL00001'.
  gv_rate_zcon = gv_rate_zcon / 1000.
ENDIF.
