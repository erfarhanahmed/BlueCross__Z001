*&---------------------------------------------------------------------*
*&  Include           ZSR13_SR13EMAILF01
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
***INCLUDE ZSR13_SR13EMAILF01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SR13EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SR13EMAIL .
  DATA : MLEN(2) TYPE C.
  SORT IT_TABFIN BY BZIRK  PRN_SEQ .
  CTR = 0.
  options-tdgetotf = 'X'.
  loop at it_tam1 into wa_tam1.
    PERFORM OPEN_FORM1.
    SORT IT_TABFIN BY BZIRK  PRN_SEQ .
    CTR = 0.
    read table it_tabtot into wa_tabtot with key  BZIRK = WA_TAM1-RM.
    options-tdgetotf = 'X'.
    MPERNR = WA_TAM1-PERNR.


mtitle = 'SR-13 : RM MONTH/PRODUCT GROUPWISE'.
    mtitle1 = ' SALES TREND (VALUE)'.
    mtitle2 = ' AS OF '.
    mm = MDATE+4(2).
  call function 'MONTH_NAMES_GET'
    tables
      month_names = month_name.
  read table month_name index mm.

  MTITLE2+7(3) = month_name-ktx.
  MTITLE2+10(1) = '`' .
  MTITLE2+11(2) = MDATE+2(2).


*  mtitle = 'SR-13 : RM MONTH/PRODUCT GROUPWISE SALES TREND (VALUE) AS OF '.
*  mm = MDATE+4(2).
*  call function 'MONTH_NAMES_GET'
*    tables
*      month_names = month_name.
*  read table month_name index mm.
*
*  MTITLE+63(3) = month_name-ktx.
*  MTITLE+66(1) = '`' .
*  MTITLE+67(2) = MDATE+2(2).

    PRDNAME = WA_TABFIN-GRP_NAME.
    PERFORM START_FORM.
    PERFORM NEW_SR13FORM.
    LOOP AT IT_TABFIN into wa_tabFIN WHERE BZIRK = WA_TAM1-RM.
*      MTITLE+72(20) =  WA_TABFIN-ename.
*      SELECT SINGLE ZZ_HQDESC FROM  ZTHR_HEQ_DES INTO ZHQNAME  WHERE ZZ_HQCODE = WA_TABFIN-HQ.
*      MTITLE+95(15) = ZHQNAME.
  MENAME = WA_TABFIN-ename.
  mlen = STRLEN( WA_TABFIN-ename ).
  MTITLE2+24(MLEN) =  WA_TABFIN-ename.
  MLEN = MLEN + 24 .
  MTITLE2+MLEN(3) =  ' - '.
  MLEN = MLEN + 3 .
  SELECT SINGLE ZZ_HQDESC FROM  ZTHR_HEQ_DES INTO ZHQNAME  WHERE ZZ_HQCODE = WA_TABFIN-HQ.
  MTITLE2+MLEN(15) = ZHQNAME.
      PRDNAME = WA_TABFIN-GRP_NAME.
    ON  CHANGE  OF WA_TABFIN-SPART.
      IF CTR > 0.
        PERFORM GROUP-TOTAL.
        PRDNAME = 'SUB TOTAL '.
        TAG = 'PR.YR. '.
        ELNAME = 'PDET_ST'.
        AVGQTY = PQTYSUM / 12.
        PERFORM WRITE_MAIN_FORM.
        TAG = 'CR.YR. '.
        ELNAME = 'CDET_ST'.
        AVGQTY = DQTYSUM / MCTR .
        PERFORM WRITE_MAIN_FORM.
        PERFORM STCALCGRTH.
        AVGQTY = ' '.
        TAG = 'CU.GR.%'.
        ELNAME = 'GRTHDET_T'.
        PERFORM WRITE_MAIN_FORM.
        PERFORM GROUP-TOTAL.
        CTR = CTR + 1.
        CLEAR : PQTY1 , PQTY2, PQTY3 , PQTY4, PQTY5 , PQTY6, PQTY7 , PQTY8, PQTY9 , PQTY10,PQTY11, PQTY12, PQTYASON, PQTYSUM.
        CLEAR : DQTY1 , DQTY2, DQTY3 , DQTY4, DQTY5 , DQTY6, DQTY7 , DQTY8, DQTY9 , DQTY10,DQTY11, DQTY12, DQTYSUM.
      ELSE.
        CTR = 1.
      ENDIF.
    ENDON.
    PRDNAME = WA_TABFIN-GRP_NAME.
    TAG = 'PR.YR. '.
    ELNAME = 'PDET'.
    AVGQTY = WA_TABFIN-PREV_GROSSPTS / 12.
    QTY1 = WA_TABFIN-APR_PGROSSPTS.
    QTY2 = WA_TABFIN-MAY_PGROSSPTS.
    QTY3 = WA_TABFIN-JUN_PGROSSPTS.
    QTY4 = WA_TABFIN-JUL_PGROSSPTS.
    QTY5 = WA_TABFIN-AUG_PGROSSPTS.
    QTY6 = WA_TABFIN-SEP_PGROSSPTS.
    QTY7 = WA_TABFIN-OCT_PGROSSPTS.
    QTY8 = WA_TABFIN-NOV_PGROSSPTS.
    QTY9 = WA_TABFIN-DEC_PGROSSPTS.
    QTY10 = WA_TABFIN-JAN_PGROSSPTS.
    QTY11 = WA_TABFIN-FEB_PGROSSPTS.
    QTY12 = WA_TABFIN-MAR_PGROSSPTS.
    ASOFQTY = WA_TABFIN-ASOF_VALTOT.
    QTYSUM =  WA_TABFIN-PREV_GROSSPTS.

    PQTY1 = PQTY1 + WA_TABFIN-APR_PGROSSPTS.
    PQTY2 = PQTY2 + WA_TABFIN-MAY_PGROSSPTS.
    PQTY3 = PQTY3 + WA_TABFIN-JUN_PGROSSPTS.
    PQTY4 = PQTY4 + WA_TABFIN-JUL_PGROSSPTS.
    PQTY5 = PQTY5 + WA_TABFIN-AUG_PGROSSPTS.
    PQTY6 = PQTY6 + WA_TABFIN-SEP_PGROSSPTS.
    PQTY7 = PQTY7 + WA_TABFIN-OCT_PGROSSPTS.
    PQTY8 = PQTY8 + WA_TABFIN-NOV_PGROSSPTS.
    PQTY9 = PQTY9 + WA_TABFIN-DEC_PGROSSPTS.
    PQTY10 = PQTY10 + WA_TABFIN-JAN_PGROSSPTS.
    PQTY11 = PQTY11 + WA_TABFIN-FEB_PGROSSPTS.
    PQTY12 = PQTY12 + WA_TABFIN-MAR_PGROSSPTS.
    PQTYASON = PQTYASON + WA_TABFIN-ASOF_VALTOT.
    PQTYSUM = PQTYSUM + WA_TABFIN-PREV_GROSSPTS.
    DQTY1 = DQTY1 + WA_TABFIN-APR_GROSSPTS.
    DQTY2 = DQTY2 + WA_TABFIN-MAY_GROSSPTS.
    DQTY3 = DQTY3 + WA_TABFIN-JUN_GROSSPTS.
    DQTY4 = DQTY4 + WA_TABFIN-JUL_GROSSPTS.
    DQTY5 = DQTY5 + WA_TABFIN-AUG_GROSSPTS.
    DQTY6 = DQTY6 + WA_TABFIN-SEP_GROSSPTS.
    DQTY7 = DQTY7 + WA_TABFIN-OCT_GROSSPTS.
    DQTY8 = DQTY8 + WA_TABFIN-NOV_GROSSPTS.
    DQTY9 = DQTY9 + WA_TABFIN-DEC_GROSSPTS.
    DQTY10 = DQTY10 + WA_TABFIN-JAN_GROSSPTS.
    DQTY11 = DQTY11 + WA_TABFIN-FEB_GROSSPTS.
    DQTY12 = DQTY12 + WA_TABFIN-MAR_GROSSPTS.
    DQTYSUM = DQTYSUM + WA_TABFIN-CURR_GROSSPTS.
    FPQTY1 = FPQTY1 + WA_TABFIN-APR_PGROSSPTS.
    FPQTY2 = FPQTY2 + WA_TABFIN-MAY_PGROSSPTS.
    FPQTY3 = FPQTY3 + WA_TABFIN-JUN_PGROSSPTS.
    FPQTY4 = FPQTY4 + WA_TABFIN-JUL_PGROSSPTS.
    FPQTY5 = FPQTY5 + WA_TABFIN-AUG_PGROSSPTS.
    FPQTY6 = FPQTY6 + WA_TABFIN-SEP_PGROSSPTS.
    FPQTY7 = FPQTY7 + WA_TABFIN-OCT_PGROSSPTS.
    FPQTY8 = FPQTY8 + WA_TABFIN-NOV_PGROSSPTS.
    FPQTY9 = FPQTY9 + WA_TABFIN-DEC_PGROSSPTS.
    FPQTY10 = FPQTY10 + WA_TABFIN-JAN_PGROSSPTS.
    FPQTY11 = FPQTY11 + WA_TABFIN-FEB_PGROSSPTS.
    FPQTY12 = FPQTY12 + WA_TABFIN-MAR_PGROSSPTS.
    FPQTYASON = FPQTYASON + WA_TABFIN-ASOF_VALTOT.
    FPQTYSUM = FPQTYSUM + WA_TABFIN-PREV_GROSSPTS.
    FDQTY1 = FDQTY1 + WA_TABFIN-APR_GROSSPTS.
    FDQTY2 = FDQTY2 + WA_TABFIN-MAY_GROSSPTS.
    FDQTY3 = FDQTY3 + WA_TABFIN-JUN_GROSSPTS.
    FDQTY4 = FDQTY4 + WA_TABFIN-JUL_GROSSPTS.
    FDQTY5 = FDQTY5 + WA_TABFIN-AUG_GROSSPTS.
    FDQTY6 = FDQTY6 + WA_TABFIN-SEP_GROSSPTS.
    FDQTY7 = FDQTY7 + WA_TABFIN-OCT_GROSSPTS.
    FDQTY8 = FDQTY8 + WA_TABFIN-NOV_GROSSPTS.
    FDQTY9 = FDQTY9 + WA_TABFIN-DEC_GROSSPTS.
    FDQTY10 = FDQTY10 + WA_TABFIN-JAN_GROSSPTS.
    FDQTY11 = FDQTY11 + WA_TABFIN-FEB_GROSSPTS.
    FDQTY12 = FDQTY12 + WA_TABFIN-MAR_GROSSPTS.
    FDQTYSUM = FDQTYSUM + WA_TABFIN-CURR_GROSSPTS.
    PERFORM WRITE_MAIN_FORM.

    TAG = 'CU.YR. '.
    ELNAME = 'CDET'.
    AVGQTY = WA_TABFIN-CURR_GROSSPTS / MCTR .
    QTY1 = WA_TABFIN-APR_GROSSPTS.
    QTY2 = WA_TABFIN-MAY_GROSSPTS.
    QTY3 = WA_TABFIN-JUN_GROSSPTS.
    QTY4 = WA_TABFIN-JUL_GROSSPTS.
    QTY5 = WA_TABFIN-AUG_GROSSPTS.
    QTY6 = WA_TABFIN-SEP_GROSSPTS.
    QTY7 = WA_TABFIN-OCT_GROSSPTS.
    QTY8 = WA_TABFIN-NOV_GROSSPTS.
    QTY9 = WA_TABFIN-DEC_GROSSPTS.
    QTY10 = WA_TABFIN-JAN_GROSSPTS.
    QTY11 = WA_TABFIN-FEB_GROSSPTS.
    QTY12 = WA_TABFIN-MAR_GROSSPTS.
    QTYSUM =  WA_TABFIN-CURR_GROSSPTS.
    PERFORM WRITE_MAIN_FORM.
    TAG = 'CU.GR.%'.
    ELNAME = 'CDET'.
    AVGQTY = ' '.
    QTY1 = WA_TABFIN-APR_GRTH.
    QTY2 = WA_TABFIN-MAY_GRTH.
    QTY3 = WA_TABFIN-JUN_GRTH.
    QTY4 = WA_TABFIN-JUL_GRTH.
    QTY5 = WA_TABFIN-AUG_GRTH.
    QTY6 = WA_TABFIN-SEP_GRTH.
    QTY7 = WA_TABFIN-OCT_GRTH.
    QTY8 = WA_TABFIN-NOV_GRTH.
    QTY9 = WA_TABFIN-DEC_GRTH.
    QTY10 = WA_TABFIN-JAN_GRTH.
    QTY11 = WA_TABFIN-FEB_GRTH.
    QTY12 = WA_TABFIN-MAR_GRTH.
    QTYSUM =  WA_TABFIN-GRTH.
    PERFORM WRITE_MAIN_FORM.


    CLEAR : QTY1, QTY2, QTY3,QTY4, QTY5, QTY6, QTY7, QTY8, QTY9, QTY10, QTY11, QTY12, QTYSUM.
    TAG = 'MON.GR%'.
    ELNAME = 'CDET'.
    AVGQTY = ' '.
    IF WA_TABFIN-APR_GROSSPTS > 0 AND WA_TABFIN-APR_PGROSSPTS > 0.
       QTY1 = ( ( WA_TABFIN-APR_GROSSPTS / WA_TABFIN-APR_PGROSSPTS ) * 100 ) - 100..
    ELSEIF WA_TABFIN-APR_GROSSPTS > 0 AND WA_TABFIN-APR_PGROSSPTS <= 0.
      QTY1 = '100'.
    ELSEIF WA_TABFIN-APR_GROSSPTS <= 0 AND WA_TABFIN-APR_PGROSSPTS > 0.
      QTY1 = '-100'.
    ENDIF.
    IF MAYDT <= MDATE.
       IF WA_TABFIN-MAY_GROSSPTS > 0 AND WA_TABFIN-MAY_PGROSSPTS > 0.
          QTY2 = ( ( WA_TABFIN-MAY_GROSSPTS / WA_TABFIN-MAY_PGROSSPTS ) * 100 ) - 100..
       ELSEIF WA_TABFIN-MAY_GROSSPTS > 0 AND WA_TABFIN-MAY_PGROSSPTS <= 0.
          QTY2 = '100'.
       ELSEIF WA_TABFIN-MAY_GROSSPTS <= 0 AND WA_TABFIN-MAY_PGROSSPTS > 0.
          QTY2 = '-100'.
       ENDIF.
    ENDIF.
    IF JUNDT <= MDATE.
       IF WA_TABFIN-JUN_GROSSPTS > 0 AND WA_TABFIN-JUN_PGROSSPTS > 0.
          QTY3 = ( ( WA_TABFIN-JUN_GROSSPTS / WA_TABFIN-JUN_PGROSSPTS ) * 100 ) - 100..
       ELSEIF WA_TABFIN-JUN_GROSSPTS > 0 AND WA_TABFIN-JUN_PGROSSPTS <= 0.
          QTY3 = '100'.
       ELSEIF WA_TABFIN-JUN_GROSSPTS <= 0 AND WA_TABFIN-JUN_PGROSSPTS > 0.
          QTY3 = '-100'.
       ENDIF.
    ENDIF.
    IF JULDT <= MDATE.
       IF WA_TABFIN-JUL_GROSSPTS > 0 AND WA_TABFIN-JUL_PGROSSPTS > 0.
          QTY4 = ( ( WA_TABFIN-JUL_GROSSPTS / WA_TABFIN-JUL_PGROSSPTS ) * 100 ) - 100..
       ELSEIF WA_TABFIN-JUL_GROSSPTS > 0 AND WA_TABFIN-JUL_PGROSSPTS <= 0.
          QTY4 = '100'.
       ELSEIF WA_TABFIN-JUL_GROSSPTS <= 0 AND WA_TABFIN-JUL_PGROSSPTS > 0.
          QTY4 = '-100'.
       ENDIF.
    ENDIF.
    IF AUGDT <= MDATE.
       IF WA_TABFIN-AUG_GROSSPTS > 0 AND WA_TABFIN-AUG_PGROSSPTS > 0.
          QTY5 = ( ( WA_TABFIN-AUG_GROSSPTS / WA_TABFIN-AUG_PGROSSPTS ) * 100 ) - 100..
       ELSEIF WA_TABFIN-AUG_GROSSPTS > 0 AND WA_TABFIN-AUG_PGROSSPTS <= 0.
          QTY5 = '100'.
       ELSEIF WA_TABFIN-AUG_GROSSPTS <= 0 AND WA_TABFIN-AUG_PGROSSPTS > 0.
          QTY5 = '-100'.
       ENDIF.
    ENDIF.
    IF SEPDT <= MDATE.
       IF WA_TABFIN-SEP_GROSSPTS > 0 AND WA_TABFIN-SEP_PGROSSPTS > 0.
          QTY6 = ( ( WA_TABFIN-SEP_GROSSPTS / WA_TABFIN-SEP_PGROSSPTS ) * 100 ) - 100..
       ELSEIF WA_TABFIN-SEP_GROSSPTS > 0 AND WA_TABFIN-SEP_PGROSSPTS <= 0.
          QTY6 = '100'.
       ELSEIF WA_TABFIN-SEP_GROSSPTS <= 0 AND WA_TABFIN-SEP_PGROSSPTS > 0.
          QTY6 = '-100'.
       ENDIF.
    ENDIF.
    IF OCTDT <= MDATE.
       IF WA_TABFIN-OCT_GROSSPTS > 0 AND WA_TABFIN-OCT_PGROSSPTS > 0.
          QTY7 = ( ( WA_TABFIN-OCT_GROSSPTS / WA_TABFIN-OCT_PGROSSPTS ) * 100 ) - 100..
       ELSEIF WA_TABFIN-OCT_GROSSPTS > 0 AND WA_TABFIN-OCT_PGROSSPTS <= 0.
          QTY7 = '100'.
       ELSEIF WA_TABFIN-OCT_GROSSPTS <= 0 AND WA_TABFIN-OCT_PGROSSPTS > 0.
          QTY7 = '-100'.
       ENDIF.
    ENDIF.
    IF NOVDT <= MDATE.
       IF WA_TABFIN-NOV_GROSSPTS > 0 AND WA_TABFIN-NOV_PGROSSPTS > 0.
          QTY8 = ( ( WA_TABFIN-NOV_GROSSPTS / WA_TABFIN-NOV_PGROSSPTS ) * 100 ) - 100..
       ELSEIF WA_TABFIN-NOV_GROSSPTS > 0 AND WA_TABFIN-NOV_PGROSSPTS <= 0.
          QTY8 = '100'.
       ELSEIF WA_TABFIN-NOV_GROSSPTS <= 0 AND WA_TABFIN-NOV_PGROSSPTS > 0.
          QTY8 = '-100'.
       ENDIF.
    ENDIF.
    IF DECDT <= MDATE.
       IF WA_TABFIN-DEC_GROSSPTS > 0 AND WA_TABFIN-DEC_PGROSSPTS > 0.
          QTY9 = ( ( WA_TABFIN-DEC_GROSSPTS / WA_TABFIN-DEC_PGROSSPTS ) * 100 ) - 100..
       ELSEIF WA_TABFIN-DEC_GROSSPTS > 0 AND WA_TABFIN-DEC_PGROSSPTS <= 0.
          QTY9 = '100'.
       ELSEIF WA_TABFIN-DEC_GROSSPTS <= 0 AND WA_TABFIN-DEC_PGROSSPTS > 0.
          QTY9 = '-100'.
       ENDIF.
    ENDIF.
    IF JANDT <= MDATE.
       IF WA_TABFIN-JAN_GROSSPTS > 0 AND WA_TABFIN-JAN_PGROSSPTS > 0.
          QTY10 = ( ( WA_TABFIN-JAN_GROSSPTS / WA_TABFIN-JAN_PGROSSPTS ) * 100 ) - 100..
       ELSEIF WA_TABFIN-JAN_GROSSPTS > 0 AND WA_TABFIN-JAN_PGROSSPTS <= 0.
          QTY10 = '100'.
       ELSEIF WA_TABFIN-JAN_GROSSPTS <= 0 AND WA_TABFIN-JAN_PGROSSPTS > 0.
          QTY10 = '-100'.
       ENDIF.
    ENDIF.
    IF FEBDT <= MDATE.
       IF WA_TABFIN-FEB_GROSSPTS > 0 AND WA_TABFIN-FEB_PGROSSPTS > 0.
          QTY11 = ( ( WA_TABFIN-FEB_GROSSPTS / WA_TABFIN-FEB_PGROSSPTS ) * 100 ) - 100..
       ELSEIF WA_TABFIN-FEB_GROSSPTS > 0 AND WA_TABFIN-FEB_PGROSSPTS <= 0.
          QTY11 = '100'.
       ELSEIF WA_TABFIN-FEB_GROSSPTS <= 0 AND WA_TABFIN-FEB_PGROSSPTS > 0.
          QTY11 = '-100'.
       ENDIF.
    ENDIF.
    IF MARDT <= MDATE.
       IF WA_TABFIN-MAR_GROSSPTS > 0 AND WA_TABFIN-MAR_PGROSSPTS > 0.
          QTY12 = ( ( WA_TABFIN-MAR_GROSSPTS / WA_TABFIN-MAR_PGROSSPTS ) * 100 ) - 100..
       ELSEIF WA_TABFIN-MAR_GROSSPTS > 0 AND WA_TABFIN-MAR_PGROSSPTS <= 0.
          QTY12 = '100'.
       ELSEIF WA_TABFIN-MAR_GROSSPTS <= 0 AND WA_TABFIN-MAR_PGROSSPTS > 0.
          QTY12 = '-100'.
       ENDIF.
    ENDIF.
*    QTYSUM =  WA_TABFIN-MGRTH.
    PERFORM WRITE_MAIN_FORM.

    TAG = 'MTPT% M'.
    ELNAME = 'CDET'.
    AVGQTY = ' '.
    QTY1 = WA_TABFIN-APR_MTPT_PER.
    QTY2 = WA_TABFIN-MAY_MTPT_PER.
    QTY3 = WA_TABFIN-JUN_MTPT_PER.
    QTY4 = WA_TABFIN-JUL_MTPT_PER.
    QTY5 = WA_TABFIN-AUG_MTPT_PER.
    QTY6 = WA_TABFIN-SEP_MTPT_PER.
    QTY7 = WA_TABFIN-OCT_MTPT_PER.
    QTY8 = WA_TABFIN-NOV_MTPT_PER.
    QTY9 = WA_TABFIN-DEC_MTPT_PER.
    QTY10 = WA_TABFIN-JAN_MTPT_PER.
    QTY11 = WA_TABFIN-FEB_MTPT_PER.
    QTY12 = WA_TABFIN-MAR_MTPT_PER.
    QTYSUM =  ' '.
    PERFORM WRITE_MAIN_FORM.
    TAG = 'YPM    '.
    ELNAME = 'YPMDET'.
    AVGQTY = WA_TABFIN-AVG_YPM.
    QTY1 = WA_TABFIN-APR_YPM.
    QTY2 = WA_TABFIN-MAY_YPM.
    QTY3 = WA_TABFIN-JUN_YPM.
    QTY4 = WA_TABFIN-JUL_YPM.
    QTY5 = WA_TABFIN-AUG_YPM.
    QTY6 = WA_TABFIN-SEP_YPM.
    QTY7 = WA_TABFIN-OCT_YPM.
    QTY8 = WA_TABFIN-NOV_YPM.
    QTY9 = WA_TABFIN-DEC_YPM.
    QTY10 = WA_TABFIN-JAN_YPM.
    QTY11 = WA_TABFIN-FEB_YPM.
    QTY12 = WA_TABFIN-MAR_YPM.
    QTYSUM =  ''.
    PERFORM WRITE_MAIN_FORM.
    TAG = 'NO.MTPT'.
    ELNAME = 'CDET'.
    AVGQTY = ' '.
    QTY1 = WA_TABFIN-APR_TOTSE_ACH.
    QTY2 = WA_TABFIN-MAY_TOTSE_ACH.
    QTY3 = WA_TABFIN-JUN_TOTSE_ACH.
    QTY4 = WA_TABFIN-JUL_TOTSE_ACH.
    QTY5 = WA_TABFIN-AUG_TOTSE_ACH.
    QTY6 = WA_TABFIN-SEP_TOTSE_ACH.
    QTY7 = WA_TABFIN-OCT_TOTSE_ACH.
    QTY8 = WA_TABFIN-NOV_TOTSE_ACH.
    QTY9 = WA_TABFIN-DEC_TOTSE_ACH.
    QTY10 = WA_TABFIN-JAN_TOTSE_ACH.
    QTY11 = WA_TABFIN-FEB_TOTSE_ACH.
    QTY12 = WA_TABFIN-MAR_TOTSE_ACH.
    QTYSUM =  ' '.
    PERFORM WRITE_MAIN_FORM.
  ENDLOOP.
        IF CTR = 2.
          PERFORM GROUP-TOTAL.
          PRDNAME = 'SUB TOTAL '.
          TAG = 'PR.YR. '.
          ELNAME = 'PDET_ST'.
          AVGQTY = PQTYSUM / 12.
          PERFORM WRITE_MAIN_FORM.
          TAG = 'CR.YR. '.
          ELNAME = 'CDET_ST'.
          AVGQTY = DQTYSUM / MCTR.
          PERFORM WRITE_MAIN_FORM.
          PERFORM STCALCGRTH.
          TAG = 'CU.GR.%'.
          ELNAME = 'GRTHDET_T'.
          AVGQTY = ' '.
          PERFORM WRITE_MAIN_FORM.
*          PERFORM GROUP-TOTAL.
          CTR = 0.
        ENDIF.
        PERFORM GROUP-TOTAL.
        PRDNAME = 'TOTAL (GROSS)'.
        TAG = 'PR.YR. '.
        ELNAME = 'PDET_TOT'.
        AVGQTY = FPQTYSUM / 12.
        PERFORM WRITE_MAIN_FORM.
        TAG = 'CR.YR. '.
        ELNAME = 'CDET_TOT'.
        AVGQTY = FDQTYSUM / MCTR .
        PERFORM WRITE_MAIN_FORM.
        PERFORM TOTCALCGRTH.
        TAG = 'CU.GR.%'.
        ELNAME = 'GRTHDET_T'.
        AVGQTY = ' '.
        PERFORM WRITE_MAIN_FORM.
        PERFORM GROUP-TOTAL.
        PERFORM SUMMWRITE.
        CLEAR : PQTY1 , PQTY2, PQTY3 , PQTY4, PQTY5 , PQTY6, PQTY7 , PQTY8, PQTY9 , PQTY10,PQTY11, PQTY12, PQTYASON, PQTYSUM.
        CLEAR : DQTY1 , DQTY2, DQTY3 , DQTY4, DQTY5 , DQTY6, DQTY7 , DQTY8, DQTY9 , DQTY10,DQTY11, DQTY12, DQTYSUM.
        CLEAR : FPQTY1 , FPQTY2, FPQTY3 , FPQTY4, FPQTY5 , FPQTY6, FPQTY7 , FPQTY8, FPQTY9 , FPQTY10,FPQTY11, FPQTY12, FPQTYASON, FPQTYSUM.
        CLEAR : FDQTY1 , FDQTY2, FDQTY3 , FDQTY4, FDQTY5 , FDQTY6, FDQTY7 , FDQTY8, FDQTY9 , FDQTY10,FDQTY11, FDQTY12, FDQTYSUM.
        PERFORM SR13CLOSE.
        PERFORM CLOSE_FORM.
  ENDLOOP.
ENDFORM.                    " SR13EMAIL
*&---------------------------------------------------------------------*
*&      Form  SR13EMAIL1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SR13EMAIL1 .
  DATA : MLEN(2) TYPE C.
  SORT IT_TABFIN BY BZIRK  PRN_SEQ .
  CTR = 0.
  options-tdgetotf = 'X'.
  PERFORM OPEN_FORM1.
  SORT IT_TABFIN BY BZIRK  PRN_SEQ .
  CTR = 0.
  LOOP AT IT_TABFIN INTO WA_TABFIN.

    mtitle = 'SR-13 : RM MONTH/PRODUCT GROUPWISE'.
    mtitle1 = ' SALES TREND (VALUE)'.
    mtitle2 = ' AS OF '.
    mm = MDATE+4(2).
  call function 'MONTH_NAMES_GET'
    tables
      month_names = month_name.
  read table month_name index mm.

  MTITLE2+7(3) = month_name-ktx.
  MTITLE2+10(1) = '`' .
  MTITLE2+11(2) = MDATE+2(2).

  mlen = STRLEN( WA_TABFIN-ename ).
  MTITLE2+24(MLEN) =  WA_TABFIN-ename.
  MLEN = MLEN + 24 .
  MTITLE2+MLEN(3) =  ' - '.
  MLEN = MLEN + 3 .
  SELECT SINGLE ZZ_HQDESC FROM  ZTHR_HEQ_DES INTO ZHQNAME  WHERE ZZ_HQCODE = WA_TABFIN-HQ.
  MTITLE2+MLEN(15) = ZHQNAME.
*    mtitle = 'SR-13 : RM MONTH/PRODUCT GROUPWISE SALES TREND (VALUE) AS OF '.
*    mm = MDATE+4(2).
*  call function 'MONTH_NAMES_GET'
*    tables
*      month_names = month_name.
*  read table month_name index mm.
*
*  MTITLE+63(3) = month_name-ktx.
*  MTITLE+66(1) = '`' .
*  MTITLE+67(2) = MDATE+2(2).
*
*  MTITLE+72(20) =  WA_TABFIN-ename.
*
*  SELECT SINGLE ZZ_HQDESC FROM  ZTHR_HEQ_DES INTO ZHQNAME  WHERE ZZ_HQCODE = WA_TABFIN-HQ.
*  MTITLE+95(15) = ZHQNAME.
*    MTITLE+83(15) = wa_tabfin-hq.
    PRDNAME = WA_TABFIN-GRP_NAME.
    AT NEW BZIRK.
      PERFORM SR13CLOSE.
      PERFORM START_FORM.
      PERFORM NEW_SR13FORM.
      CTR = 0.
    ENDAT.
    ON  CHANGE  OF WA_TABFIN-SPART.
      IF CTR > 0.
        PERFORM GROUP-TOTAL.
        PRDNAME = 'SUB TOTAL '.
        TAG = 'PR.YR. '.
        ELNAME = 'PDET_ST'.
        AVGQTY = PQTYSUM / 12.
        PERFORM WRITE_MAIN_FORM.
        TAG = 'CR.YR. '.
        ELNAME = 'CDET_ST'.
        AVGQTY = DQTYSUM / MCTR .
        PERFORM WRITE_MAIN_FORM.
        PERFORM STCALCGRTH.
        AVGQTY = ' '.
        TAG = 'CU.GR.%'.
        ELNAME = 'GRTHDET_T'.
        PERFORM WRITE_MAIN_FORM.
        PERFORM GROUP-TOTAL.
        CTR = CTR + 1.
        CLEAR : PQTY1 , PQTY2, PQTY3 , PQTY4, PQTY5 , PQTY6, PQTY7 , PQTY8, PQTY9 , PQTY10,PQTY11, PQTY12, PQTYASON, PQTYSUM.
        CLEAR : DQTY1 , DQTY2, DQTY3 , DQTY4, DQTY5 , DQTY6, DQTY7 , DQTY8, DQTY9 , DQTY10,DQTY11, DQTY12, DQTYSUM.
      ELSE.
        CTR = 1.
      ENDIF.
    ENDON.
    PRDNAME = WA_TABFIN-GRP_NAME.
    TAG = 'PR.YR. '.
    ELNAME = 'PDET'.
    AVGQTY = WA_TABFIN-PREV_GROSSPTS / 12.
    QTY1 = WA_TABFIN-APR_PGROSSPTS.
    QTY2 = WA_TABFIN-MAY_PGROSSPTS.
    QTY3 = WA_TABFIN-JUN_PGROSSPTS.
    QTY4 = WA_TABFIN-JUL_PGROSSPTS.
    QTY5 = WA_TABFIN-AUG_PGROSSPTS.
    QTY6 = WA_TABFIN-SEP_PGROSSPTS.
    QTY7 = WA_TABFIN-OCT_PGROSSPTS.
    QTY8 = WA_TABFIN-NOV_PGROSSPTS.
    QTY9 = WA_TABFIN-DEC_PGROSSPTS.
    QTY10 = WA_TABFIN-JAN_PGROSSPTS.
    QTY11 = WA_TABFIN-FEB_PGROSSPTS.
    QTY12 = WA_TABFIN-MAR_PGROSSPTS.
    ASOFQTY = WA_TABFIN-ASOF_VALTOT.
    QTYSUM =  WA_TABFIN-PREV_GROSSPTS.

    PQTY1 = PQTY1 + WA_TABFIN-APR_PGROSSPTS.
    PQTY2 = PQTY2 + WA_TABFIN-MAY_PGROSSPTS.
    PQTY3 = PQTY3 + WA_TABFIN-JUN_PGROSSPTS.
    PQTY4 = PQTY4 + WA_TABFIN-JUL_PGROSSPTS.
    PQTY5 = PQTY5 + WA_TABFIN-AUG_PGROSSPTS.
    PQTY6 = PQTY6 + WA_TABFIN-SEP_PGROSSPTS.
    PQTY7 = PQTY7 + WA_TABFIN-OCT_PGROSSPTS.
    PQTY8 = PQTY8 + WA_TABFIN-NOV_PGROSSPTS.
    PQTY9 = PQTY9 + WA_TABFIN-DEC_PGROSSPTS.
    PQTY10 = PQTY10 + WA_TABFIN-JAN_PGROSSPTS.
    PQTY11 = PQTY11 + WA_TABFIN-FEB_PGROSSPTS.
    PQTY12 = PQTY12 + WA_TABFIN-MAR_PGROSSPTS.
    PQTYASON = PQTYASON + WA_TABFIN-ASOF_VALTOT.
    PQTYSUM = PQTYSUM + WA_TABFIN-PREV_GROSSPTS.
    DQTY1 = DQTY1 + WA_TABFIN-APR_GROSSPTS.
    DQTY2 = DQTY2 + WA_TABFIN-MAY_GROSSPTS.
    DQTY3 = DQTY3 + WA_TABFIN-JUN_GROSSPTS.
    DQTY4 = DQTY4 + WA_TABFIN-JUL_GROSSPTS.
    DQTY5 = DQTY5 + WA_TABFIN-AUG_GROSSPTS.
    DQTY6 = DQTY6 + WA_TABFIN-SEP_GROSSPTS.
    DQTY7 = DQTY7 + WA_TABFIN-OCT_GROSSPTS.
    DQTY8 = DQTY8 + WA_TABFIN-NOV_GROSSPTS.
    DQTY9 = DQTY9 + WA_TABFIN-DEC_GROSSPTS.
    DQTY10 = DQTY10 + WA_TABFIN-JAN_GROSSPTS.
    DQTY11 = DQTY11 + WA_TABFIN-FEB_GROSSPTS.
    DQTY12 = DQTY12 + WA_TABFIN-MAR_GROSSPTS.
    DQTYSUM = DQTYSUM + WA_TABFIN-CURR_GROSSPTS.
    FPQTY1 = FPQTY1 + WA_TABFIN-APR_PGROSSPTS.
    FPQTY2 = FPQTY2 + WA_TABFIN-MAY_PGROSSPTS.
    FPQTY3 = FPQTY3 + WA_TABFIN-JUN_PGROSSPTS.
    FPQTY4 = FPQTY4 + WA_TABFIN-JUL_PGROSSPTS.
    FPQTY5 = FPQTY5 + WA_TABFIN-AUG_PGROSSPTS.
    FPQTY6 = FPQTY6 + WA_TABFIN-SEP_PGROSSPTS.
    FPQTY7 = FPQTY7 + WA_TABFIN-OCT_PGROSSPTS.
    FPQTY8 = FPQTY8 + WA_TABFIN-NOV_PGROSSPTS.
    FPQTY9 = FPQTY9 + WA_TABFIN-DEC_PGROSSPTS.
    FPQTY10 = FPQTY10 + WA_TABFIN-JAN_PGROSSPTS.
    FPQTY11 = FPQTY11 + WA_TABFIN-FEB_PGROSSPTS.
    FPQTY12 = FPQTY12 + WA_TABFIN-MAR_PGROSSPTS.
    FPQTYASON = FPQTYASON + WA_TABFIN-ASOF_VALTOT.
    FPQTYSUM = FPQTYSUM + WA_TABFIN-PREV_GROSSPTS.
    FDQTY1 = FDQTY1 + WA_TABFIN-APR_GROSSPTS.
    FDQTY2 = FDQTY2 + WA_TABFIN-MAY_GROSSPTS.
    FDQTY3 = FDQTY3 + WA_TABFIN-JUN_GROSSPTS.
    FDQTY4 = FDQTY4 + WA_TABFIN-JUL_GROSSPTS.
    FDQTY5 = FDQTY5 + WA_TABFIN-AUG_GROSSPTS.
    FDQTY6 = FDQTY6 + WA_TABFIN-SEP_GROSSPTS.
    FDQTY7 = FDQTY7 + WA_TABFIN-OCT_GROSSPTS.
    FDQTY8 = FDQTY8 + WA_TABFIN-NOV_GROSSPTS.
    FDQTY9 = FDQTY9 + WA_TABFIN-DEC_GROSSPTS.
    FDQTY10 = FDQTY10 + WA_TABFIN-JAN_GROSSPTS.
    FDQTY11 = FDQTY11 + WA_TABFIN-FEB_GROSSPTS.
    FDQTY12 = FDQTY12 + WA_TABFIN-MAR_GROSSPTS.
    FDQTYSUM = FDQTYSUM + WA_TABFIN-CURR_GROSSPTS.
    PERFORM WRITE_MAIN_FORM.

    TAG = 'CU.YR. '.
    ELNAME = 'CDET'.
    AVGQTY = WA_TABFIN-CURR_GROSSPTS / MCTR .
    QTY1 = WA_TABFIN-APR_GROSSPTS.
    QTY2 = WA_TABFIN-MAY_GROSSPTS.
    QTY3 = WA_TABFIN-JUN_GROSSPTS.
    QTY4 = WA_TABFIN-JUL_GROSSPTS.
    QTY5 = WA_TABFIN-AUG_GROSSPTS.
    QTY6 = WA_TABFIN-SEP_GROSSPTS.
    QTY7 = WA_TABFIN-OCT_GROSSPTS.
    QTY8 = WA_TABFIN-NOV_GROSSPTS.
    QTY9 = WA_TABFIN-DEC_GROSSPTS.
    QTY10 = WA_TABFIN-JAN_GROSSPTS.
    QTY11 = WA_TABFIN-FEB_GROSSPTS.
    QTY12 = WA_TABFIN-MAR_GROSSPTS.
    QTYSUM =  WA_TABFIN-CURR_GROSSPTS.
    PERFORM WRITE_MAIN_FORM.
    TAG = 'CU.GR.%'.
    ELNAME = 'CDET'.
    AVGQTY = ' '.
    QTY1 = WA_TABFIN-APR_GRTH.
    QTY2 = WA_TABFIN-MAY_GRTH.
    QTY3 = WA_TABFIN-JUN_GRTH.
    QTY4 = WA_TABFIN-JUL_GRTH.
    QTY5 = WA_TABFIN-AUG_GRTH.
    QTY6 = WA_TABFIN-SEP_GRTH.
    QTY7 = WA_TABFIN-OCT_GRTH.
    QTY8 = WA_TABFIN-NOV_GRTH.
    QTY9 = WA_TABFIN-DEC_GRTH.
    QTY10 = WA_TABFIN-JAN_GRTH.
    QTY11 = WA_TABFIN-FEB_GRTH.
    QTY12 = WA_TABFIN-MAR_GRTH.
    QTYSUM =  WA_TABFIN-GRTH.
    PERFORM WRITE_MAIN_FORM.

    CLEAR : QTY1, QTY2, QTY3,QTY4, QTY5, QTY6, QTY7, QTY8, QTY9, QTY10, QTY11, QTY12, QTYSUM.
    TAG = 'MON.GR%'.
    ELNAME = 'CDET'.
    AVGQTY = ' '.
    IF WA_TABFIN-APR_GROSSPTS > 0 AND WA_TABFIN-APR_PGROSSPTS > 0.
       QTY1 = ( ( WA_TABFIN-APR_GROSSPTS / WA_TABFIN-APR_PGROSSPTS ) * 100 ) - 100..
    ELSEIF WA_TABFIN-APR_GROSSPTS > 0 AND WA_TABFIN-APR_PGROSSPTS <= 0.
      QTY1 = '100'.
    ELSEIF WA_TABFIN-APR_GROSSPTS <= 0 AND WA_TABFIN-APR_PGROSSPTS > 0.
      QTY1 = '-100'.
    ENDIF.
    IF MAYDT <= MDATE.
       IF WA_TABFIN-MAY_GROSSPTS > 0 AND WA_TABFIN-MAY_PGROSSPTS > 0.
          QTY2 = ( ( WA_TABFIN-MAY_GROSSPTS / WA_TABFIN-MAY_PGROSSPTS ) * 100 ) - 100..
       ELSEIF WA_TABFIN-MAY_GROSSPTS > 0 AND WA_TABFIN-MAY_PGROSSPTS <= 0.
          QTY2 = '100'.
       ELSEIF WA_TABFIN-MAY_GROSSPTS <= 0 AND WA_TABFIN-MAY_PGROSSPTS > 0.
          QTY2 = '-100'.
       ENDIF.
    ENDIF.
    IF JUNDT <= MDATE.
       IF WA_TABFIN-JUN_GROSSPTS > 0 AND WA_TABFIN-JUN_PGROSSPTS > 0.
          QTY3 = ( ( WA_TABFIN-JUN_GROSSPTS / WA_TABFIN-JUN_PGROSSPTS ) * 100 ) - 100..
       ELSEIF WA_TABFIN-JUN_GROSSPTS > 0 AND WA_TABFIN-JUN_PGROSSPTS <= 0.
          QTY3 = '100'.
       ELSEIF WA_TABFIN-JUN_GROSSPTS <= 0 AND WA_TABFIN-JUN_PGROSSPTS > 0.
          QTY3 = '-100'.
       ENDIF.
    ENDIF.
    IF JULDT <= MDATE.
       IF WA_TABFIN-JUL_GROSSPTS > 0 AND WA_TABFIN-JUL_PGROSSPTS > 0.
          QTY4 = ( ( WA_TABFIN-JUL_GROSSPTS / WA_TABFIN-JUL_PGROSSPTS ) * 100 ) - 100..
       ELSEIF WA_TABFIN-JUL_GROSSPTS > 0 AND WA_TABFIN-JUL_PGROSSPTS <= 0.
          QTY4 = '100'.
       ELSEIF WA_TABFIN-JUL_GROSSPTS <= 0 AND WA_TABFIN-JUL_PGROSSPTS > 0.
          QTY4 = '-100'.
       ENDIF.
    ENDIF.
    IF AUGDT <= MDATE.
       IF WA_TABFIN-AUG_GROSSPTS > 0 AND WA_TABFIN-AUG_PGROSSPTS > 0.
          QTY5 = ( ( WA_TABFIN-AUG_GROSSPTS / WA_TABFIN-AUG_PGROSSPTS ) * 100 ) - 100..
       ELSEIF WA_TABFIN-AUG_GROSSPTS > 0 AND WA_TABFIN-AUG_PGROSSPTS <= 0.
          QTY5 = '100'.
       ELSEIF WA_TABFIN-AUG_GROSSPTS <= 0 AND WA_TABFIN-AUG_PGROSSPTS > 0.
          QTY5 = '-100'.
       ENDIF.
    ENDIF.
    IF SEPDT <= MDATE.
       IF WA_TABFIN-SEP_GROSSPTS > 0 AND WA_TABFIN-SEP_PGROSSPTS > 0.
          QTY6 = ( ( WA_TABFIN-SEP_GROSSPTS / WA_TABFIN-SEP_PGROSSPTS ) * 100 ) - 100..
       ELSEIF WA_TABFIN-SEP_GROSSPTS > 0 AND WA_TABFIN-SEP_PGROSSPTS <= 0.
          QTY6 = '100'.
       ELSEIF WA_TABFIN-SEP_GROSSPTS <= 0 AND WA_TABFIN-SEP_PGROSSPTS > 0.
          QTY6 = '-100'.
       ENDIF.
    ENDIF.
    IF OCTDT <= MDATE.
       IF WA_TABFIN-OCT_GROSSPTS > 0 AND WA_TABFIN-OCT_PGROSSPTS > 0.
          QTY7 = ( ( WA_TABFIN-OCT_GROSSPTS / WA_TABFIN-OCT_PGROSSPTS ) * 100 ) - 100..
       ELSEIF WA_TABFIN-OCT_GROSSPTS > 0 AND WA_TABFIN-OCT_PGROSSPTS <= 0.
          QTY7 = '100'.
       ELSEIF WA_TABFIN-OCT_GROSSPTS <= 0 AND WA_TABFIN-OCT_PGROSSPTS > 0.
          QTY7 = '-100'.
       ENDIF.
    ENDIF.
    IF NOVDT <= MDATE.
       IF WA_TABFIN-NOV_GROSSPTS > 0 AND WA_TABFIN-NOV_PGROSSPTS > 0.
          QTY8 = ( ( WA_TABFIN-NOV_GROSSPTS / WA_TABFIN-NOV_PGROSSPTS ) * 100 ) - 100..
       ELSEIF WA_TABFIN-NOV_GROSSPTS > 0 AND WA_TABFIN-NOV_PGROSSPTS <= 0.
          QTY8 = '100'.
       ELSEIF WA_TABFIN-NOV_GROSSPTS <= 0 AND WA_TABFIN-NOV_PGROSSPTS > 0.
          QTY8 = '-100'.
       ENDIF.
    ENDIF.
    IF DECDT <= MDATE.
       IF WA_TABFIN-DEC_GROSSPTS > 0 AND WA_TABFIN-DEC_PGROSSPTS > 0.
          QTY9 = ( ( WA_TABFIN-DEC_GROSSPTS / WA_TABFIN-DEC_PGROSSPTS ) * 100 ) - 100..
       ELSEIF WA_TABFIN-DEC_GROSSPTS > 0 AND WA_TABFIN-DEC_PGROSSPTS <= 0.
          QTY9 = '100'.
       ELSEIF WA_TABFIN-DEC_GROSSPTS <= 0 AND WA_TABFIN-DEC_PGROSSPTS > 0.
          QTY9 = '-100'.
       ENDIF.
    ENDIF.
    IF JANDT <= MDATE.
       IF WA_TABFIN-JAN_GROSSPTS > 0 AND WA_TABFIN-JAN_PGROSSPTS > 0.
          QTY10 = ( ( WA_TABFIN-JAN_GROSSPTS / WA_TABFIN-JAN_PGROSSPTS ) * 100 ) - 100..
       ELSEIF WA_TABFIN-JAN_GROSSPTS > 0 AND WA_TABFIN-JAN_PGROSSPTS <= 0.
          QTY10 = '100'.
       ELSEIF WA_TABFIN-JAN_GROSSPTS <= 0 AND WA_TABFIN-JAN_PGROSSPTS > 0.
          QTY10 = '-100'.
       ENDIF.
    ENDIF.
    IF FEBDT <= MDATE.
       IF WA_TABFIN-FEB_GROSSPTS > 0 AND WA_TABFIN-FEB_PGROSSPTS > 0.
          QTY11 = ( ( WA_TABFIN-FEB_GROSSPTS / WA_TABFIN-FEB_PGROSSPTS ) * 100 ) - 100..
       ELSEIF WA_TABFIN-FEB_GROSSPTS > 0 AND WA_TABFIN-FEB_PGROSSPTS <= 0.
          QTY11 = '100'.
       ELSEIF WA_TABFIN-FEB_GROSSPTS <= 0 AND WA_TABFIN-FEB_PGROSSPTS > 0.
          QTY11 = '-100'.
       ENDIF.
    ENDIF.
    IF MARDT <= MDATE.
       IF WA_TABFIN-MAR_GROSSPTS > 0 AND WA_TABFIN-MAR_PGROSSPTS > 0.
          QTY12 = ( ( WA_TABFIN-MAR_GROSSPTS / WA_TABFIN-MAR_PGROSSPTS ) * 100 ) - 100..
       ELSEIF WA_TABFIN-MAR_GROSSPTS > 0 AND WA_TABFIN-MAR_PGROSSPTS <= 0.
          QTY12 = '100'.
       ELSEIF WA_TABFIN-MAR_GROSSPTS <= 0 AND WA_TABFIN-MAR_PGROSSPTS > 0.
          QTY12 = '-100'.
       ENDIF.
    ENDIF.
*    QTYSUM =  WA_TABFIN-MGRTH.
    PERFORM WRITE_MAIN_FORM.

    TAG = 'MTPT% M'.
    ELNAME = 'CDET'.
    AVGQTY = ' '.
    QTY1 = WA_TABFIN-APR_MTPT_PER.
    QTY2 = WA_TABFIN-MAY_MTPT_PER.
    QTY3 = WA_TABFIN-JUN_MTPT_PER.
    QTY4 = WA_TABFIN-JUL_MTPT_PER.
    QTY5 = WA_TABFIN-AUG_MTPT_PER.
    QTY6 = WA_TABFIN-SEP_MTPT_PER.
    QTY7 = WA_TABFIN-OCT_MTPT_PER.
    QTY8 = WA_TABFIN-NOV_MTPT_PER.
    QTY9 = WA_TABFIN-DEC_MTPT_PER.
    QTY10 = WA_TABFIN-JAN_MTPT_PER.
    QTY11 = WA_TABFIN-FEB_MTPT_PER.
    QTY12 = WA_TABFIN-MAR_MTPT_PER.
    QTYSUM =  ' '.
    PERFORM WRITE_MAIN_FORM.
    TAG = 'YPM    '.
    ELNAME = 'YPMDET'.
    AVGQTY = WA_TABFIN-AVG_YPM.
    QTY1 = WA_TABFIN-APR_YPM.
    QTY2 = WA_TABFIN-MAY_YPM.
    QTY3 = WA_TABFIN-JUN_YPM.
    QTY4 = WA_TABFIN-JUL_YPM.
    QTY5 = WA_TABFIN-AUG_YPM.
    QTY6 = WA_TABFIN-SEP_YPM.
    QTY7 = WA_TABFIN-OCT_YPM.
    QTY8 = WA_TABFIN-NOV_YPM.
    QTY9 = WA_TABFIN-DEC_YPM.
    QTY10 = WA_TABFIN-JAN_YPM.
    QTY11 = WA_TABFIN-FEB_YPM.
    QTY12 = WA_TABFIN-MAR_YPM.
    QTYSUM =  ''.
    PERFORM WRITE_MAIN_FORM.
    TAG = 'NO.MTPT'.
    ELNAME = 'CDET'.
    AVGQTY = ' '.
    QTY1 = WA_TABFIN-APR_TOTSE_ACH.
    QTY2 = WA_TABFIN-MAY_TOTSE_ACH.
    QTY3 = WA_TABFIN-JUN_TOTSE_ACH.
    QTY4 = WA_TABFIN-JUL_TOTSE_ACH.
    QTY5 = WA_TABFIN-AUG_TOTSE_ACH.
    QTY6 = WA_TABFIN-SEP_TOTSE_ACH.
    QTY7 = WA_TABFIN-OCT_TOTSE_ACH.
    QTY8 = WA_TABFIN-NOV_TOTSE_ACH.
    QTY9 = WA_TABFIN-DEC_TOTSE_ACH.
    QTY10 = WA_TABFIN-JAN_TOTSE_ACH.
    QTY11 = WA_TABFIN-FEB_TOTSE_ACH.
    QTY12 = WA_TABFIN-MAR_TOTSE_ACH.
    QTYSUM =  ' '.
    PERFORM WRITE_MAIN_FORM.
      AT END OF BZIRK.
*        PERFORM GROUP-TOTAL.
*        WRITE :/1 CTR.
        IF CTR = 2.
          PERFORM GROUP-TOTAL.
          PRDNAME = 'SUB TOTAL '.
          TAG = 'PR.YR. '.
          ELNAME = 'PDET_ST'.
          AVGQTY = PQTYSUM / 12.
          PERFORM WRITE_MAIN_FORM.
          TAG = 'CR.YR. '.
          ELNAME = 'CDET_ST'.
          AVGQTY = DQTYSUM / MCTR.
          PERFORM WRITE_MAIN_FORM.
          PERFORM STCALCGRTH.
          TAG = 'CU.GR.%'.
          ELNAME = 'GRTHDET_T'.
          AVGQTY = ' '.
          PERFORM WRITE_MAIN_FORM.
*          PERFORM GROUP-TOTAL.
          CTR = 0.
        ENDIF.
        PERFORM GROUP-TOTAL.
        PRDNAME = 'TOTAL (GROSS)'.
        TAG = 'PR.YR. '.
        ELNAME = 'PDET_TOT'.
        AVGQTY = FPQTYSUM / 12.
        PERFORM WRITE_MAIN_FORM.
        TAG = 'CR.YR. '.
        ELNAME = 'CDET_TOT'.
        AVGQTY = FDQTYSUM / MCTR.
        PERFORM WRITE_MAIN_FORM.
        PERFORM TOTCALCGRTH.
        TAG = 'CU.GR.%'.
        ELNAME = 'GRTHDET_T'.
        AVGQTY = ' '.
        PERFORM WRITE_MAIN_FORM.
        PERFORM GROUP-TOTAL.
        PERFORM SUMMWRITE.
        CLEAR : PQTY1 , PQTY2, PQTY3 , PQTY4, PQTY5 , PQTY6, PQTY7 , PQTY8, PQTY9 , PQTY10,PQTY11, PQTY12, PQTYASON, PQTYSUM.
        CLEAR : DQTY1 , DQTY2, DQTY3 , DQTY4, DQTY5 , DQTY6, DQTY7 , DQTY8, DQTY9 , DQTY10,DQTY11, DQTY12, DQTYSUM.
        CLEAR : FPQTY1 , FPQTY2, FPQTY3 , FPQTY4, FPQTY5 , FPQTY6, FPQTY7 , FPQTY8, FPQTY9 , FPQTY10,FPQTY11, FPQTY12, FPQTYASON, FPQTYSUM.
        CLEAR : FDQTY1 , FDQTY2, FDQTY3 , FDQTY4, FDQTY5 , FDQTY6, FDQTY7 , FDQTY8, FDQTY9 , FDQTY10,FDQTY11, FDQTY12, FDQTYSUM.

        PERFORM SR13CLOSE.
     endat.
   AT LAST.
      PERFORM GROUP-TOTAL.
      PERFORM SR13CLOSE.
      PERFORM CLOSE_FORM2.
   ENDAT.
  ENDLOOP.

ENDFORM.                    " SR13EMAIL1

form close_form.
  call function 'CLOSE_FORM'
   IMPORTING
     result         = result
   TABLES
     OTFDATA        = l_otf_data.
            .
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

  call function 'CONVERT_OTF'
        EXPORTING
          format       = 'PDF'
        IMPORTING
          bin_filesize = l_bin_filesize
        TABLES
          otf          = l_otf_data
          lines        = l_asc_data.

      call function 'SX_TABLE_LINE_WIDTH_CHANGE'
        EXPORTING
          line_width_dst = '255'
        TABLES
          content_in     = l_asc_data
          content_out    = objbin.

      write PDATE to wa_d1 dd/mm/yyyy.
      write MDATE to wa_d2 dd/mm/yyyy.

      describe table objbin lines righe_attachment.
      objtxt = 'This eMail is meant for information only. Please DO NOT REPLY'.append objtxt.
      objtxt = '                                 '.append objtxt.
      objtxt = 'BLUE CROSS LABORATORIES LTD.'.append objtxt.
      describe table objtxt lines righe_testo.
      doc_chng-obj_name = 'URGENT'.
      doc_chng-expiry_dat = sy-datum + 10.
      condense ltx.
      condense objtxt.
*      CONCATENATE 'SR9 for the period' ltx '-' INTO doc_chng-obj_descr SEPARATED BY space.
      concatenate 'SR-13:MONTHWISE PRODUCT GROUP SALE TREND - RM WISE  ' wa_d1 'TO ' wa_d2  into doc_chng-obj_descr separated by space.
      doc_chng-sensitivty = 'F'.
      doc_chng-doc_size = righe_testo * 255 .

      clear objpack-transf_bin.

      objpack-head_start = 1.
      objpack-head_num = 0.
      objpack-body_start = 1.
      objpack-body_num = 4.
      objpack-doc_type = 'TXT'.
      append objpack.

      objpack-transf_bin = 'X'.
      objpack-head_start = 1.
      objpack-head_num = 0.
      objpack-body_start = 1.
      objpack-body_num = righe_attachment.
      objpack-doc_type = 'PDF'.
      objpack-obj_name = 'TEST'.
      condense ltx.



      concatenate 'SR-13 : '  Mename '.' into objpack-obj_descr separated by space.
      objpack-doc_size = righe_attachment * 255.
      append objpack.
      clear objpack.

      loop at it_tam2 into wa_tam2 where pernr = MPERNR.
        reclist-receiver =   wa_tam2-usrid_long.
        reclist-express = 'X'.
        reclist-rec_type = 'U'.
        reclist-notif_del = 'X'. " request delivery notification
        reclist-notif_ndel = 'X'. " request not delivered notification
        append reclist.
        clear reclist.
      endloop.

      describe table reclist lines mcount.
      if mcount > 0.
        data: sender like soextreci1-receiver.
***ADDED BY SATHISH.B
        types: begin of t_usr21,
             bname type usr21-bname,
             persnumber type usr21-persnumber,
             addrnumber type usr21-addrnumber,
            end of t_usr21.

        types: begin of t_adr6,
                 addrnumber type usr21-addrnumber,
                 persnumber type usr21-persnumber,
                 smtp_addr type adr6-smtp_addr,
                end of t_adr6.

        data: it_usr21 type table of t_usr21,
              wa_usr21 type t_usr21,
              it_adr6 type table of t_adr6,
              wa_adr6 type t_adr6.
        select  bname persnumber addrnumber from usr21 into table it_usr21
            where bname = sy-uname.
        if sy-subrc = 0.
          select addrnumber persnumber smtp_addr from adr6 into table it_adr6
            for all entries in it_usr21 where addrnumber = it_usr21-addrnumber
                                        and   persnumber = it_usr21-persnumber.
        endif.
        loop at it_usr21 into wa_usr21.
          read table it_adr6 into wa_adr6 with key addrnumber = wa_usr21-addrnumber.
          if sy-subrc = 0.
            sender = wa_adr6-smtp_addr.
          endif.
        endloop.
        call function 'SO_DOCUMENT_SEND_API1'
                  exporting
                   document_data                    = doc_chng
                   put_in_outbox                    = 'X'
                   sender_address                   = sender
                   sender_address_type              = 'SMTP'
*   COMMIT_WORK                      = ' '
* IMPORTING
*   SENT_TO_ALL                      =
*   NEW_OBJECT_ID                    =
*   SENDER_ID                        =
                  tables
                    packing_list                     = objpack
*   OBJECT_HEADER                    =
                   contents_bin                     = objbin
                   contents_txt                     = objtxt
*   CONTENTS_HEX                     =
*   OBJECT_PARA                      =
*   OBJECT_PARB                      =
                    receivers                        = reclist
                 exceptions
                   too_many_receivers               = 1
                   document_not_sent                = 2
                   document_type_not_exist          = 3
                   operation_no_authorization       = 4
                   parameter_error                  = 5
                   x_error                          = 6
                   enqueue_error                    = 7
                   others                           = 8
                          .
        if sy-subrc <> 0.
          message id sy-msgid type sy-msgty number sy-msgno
                  with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        endif.

        commit work.


        if sy-subrc eq 0.
          write : / 'EMAIL SENT ON ',wa_tam2-usrid_long.
        endif.

        clear   : objpack,
                 objhead,
                 objtxt,
                 objbin,
                 reclist.

        refresh : objpack,
                  objhead,
                  objtxt,
                  objbin,
                  reclist.
      ELSE.
        write : / 'EMAIL ID NOT MAINTAINED FOR EMP. CODE :',wa_tam1-pernr, wa_TAM1-RM.
      endif.
*      loop at it_tam1 into wa_tam1.
*        read table it_tam2 into wa_tam2 with key  pernr = wa_tam1-pernr .
*        if sy-subrc eq 4.
*          format color 6.
*          write : / 'EMAIL ID NOT MAINTAINED FOR EMP. CODE :',wa_tam1-pernr, wa_tam1-rm.
*        endif.
*    endloop.

endform.


FORM OPEN_FORM1 .

       call function 'OPEN_FORM'
        EXPORTING
           DEVICE                            = 'PRINTER'
           DIALOG                            = ''
*           FORM                              = FORMNM
           LANGUAGE                          = SY-LANGU
           OPTIONS                           = options
        EXCEPTIONS
          CANCELED                          = 1
          DEVICE                            = 2
          FORM                              = 3
          OPTIONS                           = 4
          UNCLOSED                          = 5
          MAIL_OPTIONS                      = 6
          ARCHIVE_ERROR                     = 7
          INVALID_FAX_NUMBER                = 8
          MORE_PARAMS_NEEDED_IN_BATCH       = 9
          SPOOL_ERROR                       = 10
          CODEPAGE                          = 11
          OTHERS                            = 12
          .
      if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      endif.

ENDFORM.                    " OPEN_FORM1

form close_form2.
  call function 'CLOSE_FORM'
   IMPORTING
     result         = result
   TABLES
     OTFDATA        = l_otf_data.

            .
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

  call function 'CONVERT_OTF'
        EXPORTING
          format       = 'PDF'
        IMPORTING
          bin_filesize = l_bin_filesize
        TABLES
          otf          = l_otf_data
          lines        = l_asc_data.

      call function 'SX_TABLE_LINE_WIDTH_CHANGE'
        EXPORTING
          line_width_dst = '255'
        TABLES
          content_in     = l_asc_data
          content_out    = objbin.

      write PDATE to wa_d1 dd/mm/yyyy.
      write MDATE to wa_d2 dd/mm/yyyy.

      describe table objbin lines righe_attachment.
      objtxt = 'This eMail is meant for information only. Please DO NOT REPLY'.append objtxt.
      objtxt = '                                 '.append objtxt.
      objtxt = 'BLUE CROSS LABORATORIES LTD.'.append objtxt.
      describe table objtxt lines righe_testo.
      doc_chng-obj_name = 'URGENT'.
      doc_chng-expiry_dat = sy-datum + 10.
      condense ltx.
      condense objtxt.
*      CONCATENATE 'SR9 for the period' ltx '-' INTO doc_chng-obj_descr SEPARATED BY space.
      concatenate 'SR-13: MONTH/PRODUCT GROUP SALES TREND(VALUE) - RM WISE  ' wa_d1 'TO ' wa_d2 WA_TABFIN-ename  into doc_chng-obj_descr separated by space.
      doc_chng-sensitivty = 'F'.
      doc_chng-doc_size = righe_testo * 255 .

      clear objpack-transf_bin.

      objpack-head_start = 1.
      objpack-head_num = 0.
      objpack-body_start = 1.
      objpack-body_num = 4.
      objpack-doc_type = 'TXT'.
      append objpack.

      objpack-transf_bin = 'X'.
      objpack-head_start = 1.
      objpack-head_num = 0.
      objpack-body_start = 1.
      objpack-body_num = righe_attachment.
      objpack-doc_type = 'PDF'.
      objpack-obj_name = 'TEST'.
      condense ltx.

      concatenate 'SR-13 ' '.' into objpack-obj_descr separated by space.
      objpack-doc_size = righe_attachment * 255.
      append objpack.
      clear objpack.

        reclist-receiver = UEMAIL.
        reclist-express = 'X'.
        reclist-rec_type = 'U'.
        reclist-notif_del = 'X'. " request delivery notification
        reclist-notif_ndel = 'X'. " request not delivered notification
        append reclist.
        clear reclist.

      describe table reclist lines mcount.
      if mcount > 0.
        data: sender like soextreci1-receiver.
***ADDED BY SATHISH.B
        types: begin of t_usr21,
             bname type usr21-bname,
             persnumber type usr21-persnumber,
             addrnumber type usr21-addrnumber,
            end of t_usr21.

        types: begin of t_adr6,
                 addrnumber type usr21-addrnumber,
                 persnumber type usr21-persnumber,
                 smtp_addr type adr6-smtp_addr,
                end of t_adr6.

        data: it_usr21 type table of t_usr21,
              wa_usr21 type t_usr21,
              it_adr6 type table of t_adr6,
              wa_adr6 type t_adr6.
        select  bname persnumber addrnumber from usr21 into table it_usr21
            where bname = sy-uname.
        if sy-subrc = 0.
          select addrnumber persnumber smtp_addr from adr6 into table it_adr6
            for all entries in it_usr21 where addrnumber = it_usr21-addrnumber
                                        and   persnumber = it_usr21-persnumber.
        endif.
        loop at it_usr21 into wa_usr21.
          read table it_adr6 into wa_adr6 with key addrnumber = wa_usr21-addrnumber.
          if sy-subrc = 0.
            sender = wa_adr6-smtp_addr.
          endif.
        endloop.
        call function 'SO_DOCUMENT_SEND_API1'
                  exporting
                   document_data                    = doc_chng
                   put_in_outbox                    = 'X'
                   sender_address                   = sender
                   sender_address_type              = 'SMTP'
*   COMMIT_WORK                      = ' '
* IMPORTING
*   SENT_TO_ALL                      =
*   NEW_OBJECT_ID                    =
*   SENDER_ID                        =
                  tables
                    packing_list                     = objpack
*   OBJECT_HEADER                    =
                   contents_bin                     = objbin
                   contents_txt                     = objtxt
*   CONTENTS_HEX                     =
*   OBJECT_PARA                      =
*   OBJECT_PARB                      =
                    receivers                        = reclist
                 exceptions
                   too_many_receivers               = 1
                   document_not_sent                = 2
                   document_type_not_exist          = 3
                   operation_no_authorization       = 4
                   parameter_error                  = 5
                   x_error                          = 6
                   enqueue_error                    = 7
                   others                           = 8
                          .
        if sy-subrc <> 0.
          message id sy-msgid type sy-msgty number sy-msgno
                  with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        endif.

        commit work.


        if sy-subrc eq 0.

          write : / 'EMAIL SENT ON ',wa_tam2-usrid_long.
        endif.



        clear   : objpack,
                 objhead,
                 objtxt,
                 objbin,
                 reclist.

        refresh : objpack,
                  objhead,
                  objtxt,
                  objbin,
                  reclist.

      endif.
*      loop at it_tam1 into wa_tam1.
*      read table it_tam2 into wa_tam2 with key  pernr = wa_tam1-pernr .
*      if sy-subrc eq 4.
*        format color 6.
*        write : / 'EMAIL ID NOT MAINTAINED FOR EMP. CODE :',wa_tam1-pernr.
*      endif.
*    endloop.
endform.
