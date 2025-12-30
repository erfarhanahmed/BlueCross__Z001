*&---------------------------------------------------------------------*
*&  Include           ZSR13_OPEN_FORMF01
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
***INCLUDE ZSR13_OPEN_FORMF01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  OPEN_FORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM OPEN_FORM .
  call function 'OPEN_FORM'
 EXPORTING
*   APPLICATION                       = 'TX'
*   ARCHIVE_INDEX                     =
*   ARCHIVE_PARAMS                    =
*   DEVICE                            = 'PRINTER'
*   DIALOG                            = 'X'
    FORM                              = FORMNM
*   LANGUAGE                          = SY-LANGU
*   OPTIONS                           =
*   MAIL_SENDER                       =
*   MAIL_RECIPIENT                    =
*   MAIL_APPL_OBJECT                  =
*   RAW_DATA_INTERFACE                = '*'
*   SPONUMIV                          =
* IMPORTING
*   LANGUAGE                          =
*   NEW_ARCHIVE_PARAMS                =
*   RESULT                            =
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

ENDFORM.                    " OPEN_FORM


form close_form1.
  call function 'CLOSE_FORM'
*   IMPORTING
*     result                        = result
*     RDI_RESULT                     =
*   TABLES
*     OTFDATA                        = l_otf_data.
*   EXCEPTIONS
*     UNOPENED                       = 1
*     BAD_PAGEFORMAT_FOR_PRINT       = 2
*     SEND_ERROR                     = 3
*     SPOOL_ERROR                    = 4
*     CODEPAGE                       = 5
*     OTHERS                         = 6
            .
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

endform.
*&---------------------------------------------------------------------*
*&      Form  FRM_SR14_PRN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FRM_SR13_PRN .
   data : mlen(2) type c.
*  CLEAR : MCTR , MCN_VAL, MVAL.
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
*
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
        AVGQTY = DQTYSUM / MCTR.
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
    CLEAR : QTY1 , QTY2, QTY3 , QTY4, QTY5 , QTY6, QTY7 , PQTY8, QTY9 , QTY10,QTY11, QTY12, ASOFQTY, QTYSUM.
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
    CLEAR : QTY1 , QTY2, QTY3 , QTY4, QTY5 , QTY6, QTY7 , PQTY8, QTY9 , QTY10,QTY11, QTY12, ASOFQTY, QTYSUM.
*   MCTR = 1.

    QTY1 = WA_TABFIN-APR_GROSSPTS.
    IF CRYRDT <= MDATE.
      QTY2 = WA_TABFIN-MAY_GROSSPTS.
*     MCTR = 2.
    ENDIF.
    CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
    EXPORTING
      MONTHS  = '1'
      OLDDATE = C_date
    IMPORTING
      NEWDATE = C_date.

    IF CRYRDT <= MDATE.
      QTY3 = WA_TABFIN-JUN_GROSSPTS.
*     MCTR = 3.
    ENDIF.
    CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
    EXPORTING
      MONTHS  = '1'
      OLDDATE = C_date
    IMPORTING
      NEWDATE = C_date.

    IF CRYRDT <= MDATE.
      QTY4 = WA_TABFIN-JUL_GROSSPTS.
*     MCTR = 4.
    ENDIF.
    CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
    EXPORTING
      MONTHS  = '1'
      OLDDATE = C_date
    IMPORTING
      NEWDATE = C_date.

    IF CRYRDT <= MDATE.
      QTY5 = WA_TABFIN-AUG_GROSSPTS.
*     MCTR = 5.
    ELSE.
      QTY5 = ' '.
    ENDIF.
    CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
    EXPORTING
      MONTHS  = '1'
      OLDDATE = C_date
    IMPORTING
      NEWDATE = C_date.

    IF CRYRDT <= MDATE.
      QTY6 = WA_TABFIN-SEP_GROSSPTS.
*     MCTR = 6.
    ELSE.
      QTY6 = ' '.
    ENDIF.
    CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
    EXPORTING
      MONTHS  = '1'
      OLDDATE = C_date
    IMPORTING
      NEWDATE = C_date.

    IF CRYRDT <= MDATE.
      QTY7 = WA_TABFIN-OCT_GROSSPTS.
*     MCTR = 7.
    ELSE.
      QTY7 = ' '.
    ENDIF.
    CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
    EXPORTING
      MONTHS  = '1'
      OLDDATE = C_date
    IMPORTING
      NEWDATE = C_date.

    IF CRYRDT <= MDATE.
      QTY8 = WA_TABFIN-NOV_GROSSPTS.
*     MCTR = 8.
    ELSE.
      QTY8 = ' '.
    ENDIF.
    CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
    EXPORTING
      MONTHS  = '1'
      OLDDATE = C_date
    IMPORTING
      NEWDATE = C_date.

    IF CRYRDT <= MDATE.
      QTY9 = WA_TABFIN-DEC_GROSSPTS.
*     MCTR = 9.
    ELSE.
      QTY9 = ' '.
    ENDIF.
    CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
    EXPORTING
      MONTHS  = '1'
      OLDDATE = C_date
    IMPORTING
      NEWDATE = C_date.

    IF CRYRDT <= MDATE.
      QTY10 = WA_TABFIN-JAN_GROSSPTS.
*     MCTR = 10.
    ELSE.
      QTY10 = ' '.
    ENDIF.
    CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
    EXPORTING
      MONTHS  = '1'
      OLDDATE = C_date
    IMPORTING
      NEWDATE = C_date.

    IF CRYRDT <= MDATE.
      QTY11 = WA_TABFIN-FEB_GROSSPTS.
*     MCTR = 11.
    ELSE.
      QTY11 = ' '.
    ENDIF.
    CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
    EXPORTING
      MONTHS  = '1'
      OLDDATE = C_date
    IMPORTING
      NEWDATE = C_date.

    IF CRYRDT <= MDATE.
      QTY12 = WA_TABFIN-MAR_GROSSPTS.
*     MCTR = 12.
    ELSE.
      QTY12 = ' '.
    ENDIF.
    CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
    EXPORTING
      MONTHS  = '1'
      OLDDATE = C_date
    IMPORTING
      NEWDATE = C_date.

    QTYSUM =  WA_TABFIN-CURR_GROSSPTS.
    AVGQTY = WA_TABFIN-CURR_GROSSPTS / MCTR.
    PERFORM WRITE_MAIN_FORM.
    TAG = 'CU.GR.%'.
    ELNAME = 'CDET'.          " GRTHDET
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
   ENDAT.
  ENDLOOP.

ENDFORM.                    " FRM_SR14_PRN

FORM WRITE_MAIN_FORM .
call function 'WRITE_FORM'
 EXPORTING
   ELEMENT                        = ELNAME
*   FUNCTION                       = 'SET'
*   TYPE                           = 'BODY'
   WINDOW                         = 'MAIN'
* IMPORTING
*   PENDING_LINES                  =
 EXCEPTIONS
   ELEMENT                        = 1
   FUNCTION                       = 2
   TYPE                           = 3
   UNOPENED                       = 4
   UNSTARTED                      = 5
   WINDOW                         = 6
   BAD_PAGEFORMAT_FOR_PRINT       = 7
   SPOOL_ERROR                    = 8
   CODEPAGE                       = 9
   OTHERS                         = 10
          .
if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
endif.
ENDFORM.                    " WRITE_MAIN_FORM
*&---------------------------------------------------------------------*
*&      Form  GROUP-TOTAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GROUP-TOTAL .
  call function 'WRITE_FORM'
   EXPORTING
     ELEMENT                        = 'GROUP_TOTAL'
*     FUNCTION                       = 'SET'
     TYPE                           = 'BODY'
*     WINDOW                         = 'MAIN'
*   IMPORTING
*     PENDING_LINES                  =
   EXCEPTIONS
     ELEMENT                        = 1
     FUNCTION                       = 2
     TYPE                           = 3
     UNOPENED                       = 4
     UNSTARTED                      = 5
     WINDOW                         = 6
     BAD_PAGEFORMAT_FOR_PRINT       = 7
     SPOOL_ERROR                    = 8
     CODEPAGE                       = 9
     OTHERS                         = 10
            .
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.


ENDFORM.                    " GROUP-TOTAL


FORM NEW_SR13FORM .
  call function 'WRITE_FORM'
   EXPORTING
*     ELEMENT                        = 'RM'
*     FUNCTION                       = 'SET'
     TYPE                           = 'BODY'
     WINDOW                         = 'WINDOW1'
*   IMPORTING
*     PENDING_LINES                  =
   EXCEPTIONS
     ELEMENT                        = 1
     FUNCTION                       = 2
     TYPE                           = 3
     UNOPENED                       = 4
     UNSTARTED                      = 5
     WINDOW                         = 6
     BAD_PAGEFORMAT_FOR_PRINT       = 7
     SPOOL_ERROR                    = 8
     CODEPAGE                       = 9
     OTHERS                         = 10
            .
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.


ENDFORM.                    " NEW_RMFORM

FORM SR13CLOSE.
call function 'END_FORM'
      EXCEPTIONS
        unopened                 = 1
        bad_pageformat_for_print = 2
        spool_error              = 3
        codepage                 = 4
        others                   = 5.
    if sy-subrc <> 0.
      message id sy-msgid type sy-msgty number sy-msgno
              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.
ENDFORM.

form start_form.
  call function 'START_FORM'
   EXPORTING
*     ARCHIVE_INDEX          =
     FORM                   = FORMNM
*     LANGUAGE               = ' '
*     STARTPAGE              = ' '
*     PROGRAM                = ' '
*     MAIL_APPL_OBJECT       =
*   IMPORTING
*     LANGUAGE               =
   EXCEPTIONS
     FORM                   = 1
     FORMAT                 = 2
     UNENDED                = 3
     UNOPENED               = 4
     UNUSED                 = 5
     SPOOL_ERROR            = 6
     CODEPAGE               = 7
     OTHERS                 = 8
            .
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  STCALCGRTH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM STCALCGRTH .
  CLEAR : QTY1 , QTY2, QTY3 , QTY4, QTY5 , QTY6, QTY7 , QTY8, QTY9 , QTY10, QTY11, QTY12, ASOFQTY, QTYSUM.
  IF PQTY1 > 0 AND DQTY1 > 0.
    QTY1 = ( ( DQTY1 / PQTY1 ) * 100 ) - 100.
  ELSEIF   PQTY1 > 0 AND DQTY1 <= 0.
    QTY1 = -100 .
  ELSEIF  PQTY1 <= 0 AND DQTY1 > 0.
    QTY1 = 100 .
  ENDIF.
  QTYSUM = QTY1.
  IF DQTY2 > 0.
     PQTY1 = PQTY1 + PQTY2.
     DQTY1 = DQTY1 + DQTY2.
     IF PQTY1 > 0 AND DQTY1 > 0.
       QTY2 = ( ( DQTY1 / PQTY1 ) * 100 ) - 100.
     ELSEIF   PQTY1 > 0 AND DQTY1 <= 0.
       QTY2 = -100 .
     ELSEIF  PQTY1 <= 0 AND DQTY1 > 0.
       QTY2  = 100 .
     ENDIF.
     QTYSUM = QTY2.
  ENDIF.
  IF DQTY3 > 0.
     PQTY1 = PQTY1 + PQTY3.
     DQTY1 = DQTY1 + DQTY3.
     IF PQTY1 > 0 AND DQTY1 > 0.
       QTY3 = ( ( DQTY1 / PQTY1 ) * 100 ) - 100.
     ELSEIF   PQTY1 > 0 AND DQTY1 <= 0.
       QTY3 = -100 .
     ELSEIF  PQTY1 <= 0 AND DQTY1 > 0.
       QTY3  = 100 .
     ENDIF.
     QTYSUM = QTY3.
  ENDIF.
  IF DQTY4 > 0.
     PQTY1 = PQTY1 + PQTY4.
     DQTY1 = DQTY1 + DQTY4.
     IF PQTY1 > 0 AND DQTY1 > 0.
       QTY4 = ( ( DQTY1 / PQTY1 ) * 100 ) - 100.
     ELSEIF   PQTY1 > 0 AND DQTY1 <= 0.
       QTY4 = -100 .
     ELSEIF  PQTY1 <= 0 AND DQTY1 > 0.
       QTY4  = 100 .
     ENDIF.
     QTYSUM = QTY4.
  ENDIF.
  IF DQTY5 > 0.
     PQTY1 = PQTY1 + PQTY5.
     DQTY1 = DQTY1 + DQTY5.
     IF PQTY1 > 0 AND DQTY1 > 0.
       QTY5 = ( ( DQTY1 / PQTY1 ) * 100 ) - 100.
     ELSEIF   PQTY1 > 0 AND DQTY1 <= 0.
       QTY5 = -100 .
     ELSEIF  PQTY1 <= 0 AND DQTY1 > 0.
       QTY5  = 100 .
     ENDIF.
     QTYSUM = QTY5.
  ENDIF.
  IF DQTY6 > 0.
     PQTY1 = PQTY1 + PQTY6.
     DQTY1 = DQTY1 + DQTY6.
     IF PQTY1 > 0 AND DQTY1 > 0.
       QTY6 = ( ( DQTY1 / PQTY1 ) * 100 ) - 100.
     ELSEIF   PQTY1 > 0 AND DQTY1 <= 0.
       QTY6 = -100 .
     ELSEIF  PQTY1 <= 0 AND DQTY1 > 0.
       QTY6  = 100 .
     ENDIF.
     QTYSUM = QTY6.
  ENDIF.
  IF DQTY7 > 0.
     PQTY1 = PQTY1 + PQTY7.
     DQTY1 = DQTY1 + DQTY7.
     IF PQTY1 > 0 AND DQTY1 > 0.
       QTY7 = ( ( DQTY1 / PQTY1 ) * 100 ) - 100.
     ELSEIF   PQTY1 > 0 AND DQTY1 <= 0.
       QTY7 = -100 .
     ELSEIF  PQTY1 <= 0 AND DQTY1 > 0.
       QTY7 = 100 .
     ENDIF.
     QTYSUM = QTY7.
  ENDIF.
  IF DQTY8 > 0.
     PQTY1 = PQTY1 + PQTY8.
     DQTY1 = DQTY1 + DQTY8.
     IF PQTY1 > 0 AND DQTY1 > 0.
       QTY8 = ( ( DQTY1 / PQTY1 ) * 100 ) - 100.
     ELSEIF   PQTY1 > 0 AND DQTY1 <= 0.
       QTY8 = -100 .
     ELSEIF  PQTY1 <= 0 AND DQTY1 > 0.
       QTY8 = 100 .
     ENDIF.
     QTYSUM = QTY8.
  ENDIF.
  IF DQTY9 > 0.
     PQTY1 = PQTY1 + PQTY9.
     DQTY1 = DQTY1 + DQTY9.
     IF PQTY1 > 0 AND DQTY1 > 0.
       QTY9 = ( ( DQTY1 / PQTY1 ) * 100 ) - 100.
     ELSEIF   PQTY1 > 0 AND DQTY1 <= 0.
       QTY9 = -100 .
     ELSEIF  PQTY1 <= 0 AND DQTY1 > 0.
       QTY9  = 100 .
     ENDIF.
     QTYSUM = QTY9.
  ENDIF.
  IF DQTY10 > 0.
     PQTY1 = PQTY1 + PQTY10.
     DQTY1 = DQTY1 + DQTY10.
     IF PQTY1 > 0 AND DQTY1 > 0.
       QTY10 = ( ( DQTY1 / PQTY1 ) * 100 ) - 100.
     ELSEIF   PQTY1 > 0 AND DQTY1 <= 0.
       QTY10 = -100 .
     ELSEIF  PQTY1 <= 0 AND DQTY1 > 0.
       QTY10  = 100 .
     ENDIF.
     QTYSUM = QTY10.
  ENDIF.
  IF DQTY11 > 0.
     PQTY1 = PQTY1 + PQTY11.
     DQTY1 = DQTY1 + DQTY11.
     IF PQTY1 > 0 AND DQTY1 > 0.
       QTY11 = ( ( DQTY1 / PQTY1 ) * 100 ) - 100.
     ELSEIF   PQTY1 > 0 AND DQTY1 <= 0.
       QTY11 = -100 .
     ELSEIF  PQTY1 <= 0 AND DQTY1 > 0.
       QTY11  = 100 .
     ENDIF.
     QTYSUM = QTY11.
  ENDIF.
  IF DQTY12 > 0.
     PQTY1 = PQTY1 + PQTY12.
     DQTY1 = DQTY1 + DQTY12.
     IF PQTY1 > 0 AND DQTY1 > 0.
       QTY12 = ( ( DQTY1 / PQTY1 ) * 100 ) - 100.
     ELSEIF   PQTY1 > 0 AND DQTY1 <= 0.
       QTY12 = -100 .
     ELSEIF  PQTY1 <= 0 AND DQTY1 > 0.
       QTY12  = 100 .
     ENDIF.
     QTYSUM = QTY12.
  ENDIF.
ENDFORM.                    " STCALCGRTH

*&---------------------------------------------------------------------*
*&      Form  SUMMWRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SUMMWRITE .
  DATA : MVAL TYPE P.
  DATA : MTGT TYPE P.
  read table IT_TABSUM into WA_SUMFIN with key BZIRK = WA_TABFIN-bzirk.
  CLEAR : QTY1 , QTY2, QTY3 , QTY4, QTY5 , QTY6, QTY7 , QTY8, QTY9 , QTY10, QTY11, QTY12, ASOFQTY, QTYSUM.
    QTY1 = WA_SUMFIN-APR_PVAL.
    QTY2 = WA_SUMFIN-MAY_PVAL.
    QTY3 = WA_SUMFIN-JUN_PVAL.
    QTY4 = WA_SUMFIN-JUL_PVAL.
    QTY5 = WA_SUMFIN-AUG_PVAL.
    QTY6 = WA_SUMFIN-SEP_PVAL.
    QTY7 = WA_SUMFIN-OCT_PVAL.
    QTY8 = WA_SUMFIN-NOV_PVAL.
    QTY9 = WA_SUMFIN-DEC_PVAL.
    QTY10 = WA_SUMFIN-JAN_PVAL.
    QTY11 = WA_SUMFIN-FEB_PVAL.
    QTY12 = WA_SUMFIN-MAR_PVAL.
    QTYSUM =  WA_SUMFIN-APR_PVAL + WA_SUMFIN-MAY_PVAL + WA_SUMFIN-JUN_PVAL +
              WA_SUMFIN-JUL_PVAL + WA_SUMFIN-AUG_PVAL + WA_SUMFIN-SEP_PVAL +
              WA_SUMFIN-OCT_PVAL + WA_SUMFIN-NOV_PVAL + WA_SUMFIN-DEC_PVAL +
              WA_SUMFIN-JAN_PVAL + WA_SUMFIN-FEB_PVAL + WA_SUMFIN-MAR_PVAL .

  PRDNAME = 'PREV.YR.NET SALES(month)'.
  ELNAME = 'NDET'.
  PERFORM WRITE_MAIN_FORM.
  PERFORM GROUP-TOTAL.
  CLEAR : QTY1 , QTY2, QTY3 , QTY4, QTY5 , QTY6, QTY7 , QTY8, QTY9 , QTY10, QTY11, QTY12, ASOFQTY, QTYSUM.
  TAG = 'P.Y.YPM'.
  PRDNAME = '         PREV.YR. Y.P.M.'.
  ELNAME = 'NDET'.
    AVGQTY = WA_SUMFIN-PAVG_YPM..
    QTY1 = WA_SUMFIN-PAPR_YPM.
    QTY2 = WA_SUMFIN-PMAY_YPM.
    QTY3 = WA_SUMFIN-PJUN_YPM.
    QTY4 = WA_SUMFIN-PJUL_YPM.
    QTY5 = WA_SUMFIN-PAUG_YPM.
    QTY6 = WA_SUMFIN-PSEP_YPM.
    QTY7 = WA_SUMFIN-POCT_YPM.
    QTY8 = WA_SUMFIN-PNOV_YPM.
    QTY9 = WA_SUMFIN-PDEC_YPM.
    QTY10 = WA_SUMFIN-PJAN_YPM.
    QTY11 = WA_SUMFIN-PFEB_YPM.
    QTY12 = WA_SUMFIN-PMAR_YPM.
    QTYSUM =  ''.
    PERFORM WRITE_MAIN_FORM.
  PERFORM GROUP-TOTAL.
  CLEAR : QTY1 , QTY2, QTY3 , QTY4, QTY5 , QTY6, QTY7 , QTY8, QTY9 , QTY10, QTY11, QTY12, ASOFQTY, QTYSUM.
  QTY1 = WA_SUMFIN-APR_TGT.
    QTY2 = WA_SUMFIN-MAY_TGT.
    QTY3 = WA_SUMFIN-JUN_TGT.
    QTY4 = WA_SUMFIN-JUL_TGT.
    QTY5 = WA_SUMFIN-AUG_TGT.
    QTY6 = WA_SUMFIN-SEP_TGT.
    QTY7 = WA_SUMFIN-OCT_TGT.
    QTY8 = WA_SUMFIN-NOV_TGT.
    QTY9 = WA_SUMFIN-DEC_TGT.
    QTY10 = WA_SUMFIN-JAN_TGT.
    QTY11 = WA_SUMFIN-FEB_TGT.
    QTY12 = WA_SUMFIN-MAR_TGT.
    QTYSUM =  WA_SUMFIN-APR_TGT + WA_SUMFIN-MAY_TGT + WA_SUMFIN-JUN_TGT +
              WA_SUMFIN-JUL_TGT + WA_SUMFIN-AUG_TGT + WA_SUMFIN-SEP_TGT +
              WA_SUMFIN-OCT_TGT + WA_SUMFIN-NOV_TGT + WA_SUMFIN-DEC_TGT +
              WA_SUMFIN-JAN_TGT + WA_SUMFIN-FEB_TGT + WA_SUMFIN-MAR_TGT .
  PRDNAME = 'CURR.YR.Sale Trgt(month)'.
  ELNAME = 'NDET'.
  PERFORM WRITE_MAIN_FORM.
  PERFORM GROUP-TOTAL.
  CLEAR : QTY1 , QTY2, QTY3 , QTY4, QTY5 , QTY6, QTY7 , QTY8, QTY9 , QTY10, QTY11, QTY12, ASOFQTY, QTYSUM.
    QTY1 = WA_SUMFIN-APR_VAL.
    QTY2 = WA_SUMFIN-MAY_VAL.
    QTY3 = WA_SUMFIN-JUN_VAL.
    QTY4 = WA_SUMFIN-JUL_VAL.
    QTY5 = WA_SUMFIN-AUG_VAL.
    QTY6 = WA_SUMFIN-SEP_VAL.
    QTY7 = WA_SUMFIN-OCT_VAL.
    QTY8 = WA_SUMFIN-NOV_VAL.
    QTY9 = WA_SUMFIN-DEC_VAL.
    QTY10 = WA_SUMFIN-JAN_VAL.
    QTY11 = WA_SUMFIN-FEB_VAL.
    QTY12 = WA_SUMFIN-MAR_VAL.
    QTYSUM =  WA_SUMFIN-APR_VAL + WA_SUMFIN-MAY_VAL + WA_SUMFIN-JUN_VAL +
              WA_SUMFIN-JUL_VAL + WA_SUMFIN-AUG_VAL + WA_SUMFIN-SEP_VAL +
              WA_SUMFIN-OCT_VAL + WA_SUMFIN-NOV_VAL + WA_SUMFIN-DEC_VAL +
              WA_SUMFIN-JAN_VAL + WA_SUMFIN-FEB_VAL + WA_SUMFIN-MAR_VAL .

  PRDNAME = 'CURR.YR.NET SALES(month)'.
  ELNAME = 'NDET'.
  PERFORM WRITE_MAIN_FORM.
  PERFORM GROUP-TOTAL.
  CLEAR : QTY1 , QTY2, QTY3 , QTY4, QTY5 , QTY6, QTY7 , QTY8, QTY9 , QTY10, QTY11, QTY12, ASOFQTY, QTYSUM.
  TAG = 'YPM    '.
  PRDNAME = '         CURR.YR. Y.P.M.'.
    ELNAME = 'NDET'.
*    AVGQTY = WA_SUMFIN-AVG_YPM..
    QTY1 = WA_SUMFIN-APR_YPM.
    QTY2 = WA_SUMFIN-MAY_YPM.
    QTY3 = WA_SUMFIN-JUN_YPM.
    QTY4 = WA_SUMFIN-JUL_YPM.
    QTY5 = WA_SUMFIN-AUG_YPM.
    QTY6 = WA_SUMFIN-SEP_YPM.
    QTY7 = WA_SUMFIN-OCT_YPM.
    QTY8 = WA_SUMFIN-NOV_YPM.
    QTY9 = WA_SUMFIN-DEC_YPM.
    QTY10 = WA_SUMFIN-JAN_YPM.
    QTY11 = WA_SUMFIN-FEB_YPM.
    QTY12 = WA_SUMFIN-MAR_YPM.
    QTYSUM =  ''.
    PERFORM WRITE_MAIN_FORM.
    PERFORM GROUP-TOTAL.

  CLEAR : QTY1 , QTY2, QTY3 , QTY4, QTY5 , QTY6, QTY7 , QTY8, QTY9 , QTY10, QTY11, QTY12, ASOFQTY, QTYSUM.
    IF WA_SUMFIN-APR_VAL > 0 AND WA_SUMFIN-APR_TGT > 0.
        QTY1 = ( WA_SUMFIN-APR_VAL / WA_SUMFIN-APR_TGT ) * 100.
    ENDIF.
    IF WA_SUMFIN-MAY_VAL > 0 AND WA_SUMFIN-MAY_TGT > 0.
      QTY2 = ( WA_SUMFIN-MAY_VAL  / WA_SUMFIN-MAY_TGT ) * 100.
    ENDIF.
    IF WA_SUMFIN-JUN_VAL > 0 AND WA_SUMFIN-JUN_TGT > 0.
      QTY3 = ( WA_SUMFIN-JUN_VAL / WA_SUMFIN-JUN_TGT ) * 100.
    ENDIF.
    IF WA_SUMFIN-JUL_VAL > 0 AND WA_SUMFIN-JUL_TGT > 0.
      QTY4 = ( WA_SUMFIN-JUL_VAL  / WA_SUMFIN-JUL_TGT ) * 100.
    ENDIF.
    IF WA_SUMFIN-AUG_VAL > 0 AND WA_SUMFIN-AUG_TGT > 0.
      QTY5 = ( WA_SUMFIN-AUG_VAL  / WA_SUMFIN-AUG_TGT ) * 100.
    ENDIF.
    IF WA_SUMFIN-SEP_VAL > 0 AND WA_SUMFIN-SEP_TGT > 0.
      QTY6 = ( WA_SUMFIN-SEP_VAL  / WA_SUMFIN-SEP_TGT ) * 100.
    ENDIF.
    IF WA_SUMFIN-OCT_VAL > 0 AND WA_SUMFIN-OCT_TGT > 0.
      QTY7 = ( WA_SUMFIN-OCT_VAL  / WA_SUMFIN-OCT_TGT ) * 100.
    ENDIF.
    IF WA_SUMFIN-NOV_VAL > 0 AND WA_SUMFIN-NOV_TGT > 0.
      QTY8 = ( WA_SUMFIN-NOV_VAL  / WA_SUMFIN-NOV_TGT ) * 100.
    ENDIF.
    IF WA_SUMFIN-DEC_VAL > 0 AND WA_SUMFIN-DEC_TGT > 0.
      QTY9 = ( WA_SUMFIN-DEC_VAL  / WA_SUMFIN-DEC_TGT ) * 100.
    ENDIF.
    IF WA_SUMFIN-JAN_VAL > 0 AND WA_SUMFIN-JAN_TGT > 0.
      QTY10 = ( WA_SUMFIN-JAN_VAL  / WA_SUMFIN-JAN_TGT ) * 100.
    ENDIF.
    IF WA_SUMFIN-FEB_VAL > 0 AND WA_SUMFIN-FEB_TGT > 0.
      QTY11 = ( WA_SUMFIN-FEB_VAL  / WA_SUMFIN-FEB_TGT ) * 100.
    ENDIF.
    IF WA_SUMFIN-MAR_VAL > 0 AND WA_SUMFIN-MAR_TGT > 0.
      QTY12 = ( WA_SUMFIN-MAR_VAL  / WA_SUMFIN-MAR_TGT ) * 100.
    ENDIF.


  PRDNAME = '% TO Sale Trgt   (month)'.
  ELNAME = 'NDET'.
  PERFORM WRITE_MAIN_FORM.
  PERFORM GROUP-TOTAL.

    CLEAR : QTY1 , QTY2, QTY3 , QTY4, QTY5 , QTY6, QTY7 , QTY8, QTY9 , QTY10, QTY11, QTY12, ASOFQTY, QTYSUM.
    IF WA_SUMFIN-apr_VAL > 0 AND WA_SUMFIN-apr_PVAL > 0.
       QTY1 = ( ( WA_SUMFIN-APR_VAL / WA_SUMFIN-APR_PVAL ) * 100 ) - 100.
    endif.
    IF WA_SUMFIN-MAY_VAL > 0 AND WA_SUMFIN-MAY_PVAL > 0.
      QTY2 = ( ( WA_SUMFIN-MAY_VAL  / WA_SUMFIN-MAY_PVAL ) * 100  ) - 100..
    ENDIF.
    IF WA_SUMFIN-JUN_VAL > 0 AND WA_SUMFIN-JUN_PVAL > 0.
      QTY3 = ( ( WA_SUMFIN-JUN_VAL / WA_SUMFIN-JUN_PVAL ) * 100  ) - 100..
    ENDIF.
    IF WA_SUMFIN-JUL_VAL > 0 AND WA_SUMFIN-JUL_PVAL > 0.
      QTY4 = ( ( WA_SUMFIN-JUL_VAL  / WA_SUMFIN-JUL_PVAL ) * 100  ) - 100..
    ENDIF.
    IF WA_SUMFIN-AUG_VAL > 0 AND WA_SUMFIN-AUG_PVAL > 0.
      QTY5 = ( ( WA_SUMFIN-AUG_VAL  / WA_SUMFIN-AUG_PVAL ) * 100 ) - 100.
    ENDIF.
    IF WA_SUMFIN-SEP_VAL > 0 AND WA_SUMFIN-SEP_PVAL > 0.
      QTY6 = ( ( WA_SUMFIN-SEP_VAL  / WA_SUMFIN-SEP_PVAL ) * 100 ) - 100.
    ENDIF.
    IF WA_SUMFIN-OCT_VAL > 0 AND WA_SUMFIN-OCT_PVAL > 0.
      QTY7 = ( ( WA_SUMFIN-OCT_VAL  / WA_SUMFIN-OCT_PVAL ) * 100 ) - 100.
    ENDIF.
    IF WA_SUMFIN-NOV_VAL > 0 AND WA_SUMFIN-NOV_PVAL > 0.
      QTY8 = ( ( WA_SUMFIN-NOV_VAL  / WA_SUMFIN-NOV_PVAL ) * 100 ) - 100.
    ENDIF.
    IF WA_SUMFIN-DEC_VAL > 0 AND WA_SUMFIN-DEC_PVAL > 0.
      QTY9 = ( ( WA_SUMFIN-DEC_VAL  / WA_SUMFIN-DEC_PVAL ) * 100 ) - 100.
    ENDIF.
    IF WA_SUMFIN-JAN_VAL > 0 AND WA_SUMFIN-JAN_PVAL > 0.
      QTY10 = ( ( WA_SUMFIN-JAN_VAL  / WA_SUMFIN-JAN_PVAL ) * 100 ) - 100.
    ENDIF.
    IF WA_SUMFIN-FEB_VAL > 0 AND WA_SUMFIN-FEB_PVAL > 0.
      QTY11 = ( ( WA_SUMFIN-FEB_VAL  / WA_SUMFIN-FEB_PVAL ) * 100 ) - 100.
    ENDIF.
    IF WA_SUMFIN-MAR_VAL > 0 AND WA_SUMFIN-MAR_PVAL > 0.
      QTY12 = ( ( WA_SUMFIN-MAR_VAL  / WA_SUMFIN-MAR_PVAL ) * 100 ) - 100.
    ENDIF.

  PRDNAME = '% TO Growth      (month) '.
  ELNAME = 'NDET'.
  PERFORM WRITE_MAIN_FORM.
  PERFORM GROUP-TOTAL.

  CLEAR : QTY1 , QTY2, QTY3 , QTY4, QTY5 , QTY6, QTY7 , QTY8, QTY9 , QTY10, QTY11, QTY12, ASOFQTY, QTYSUM.
  CLEAR : MVAL, MTGT .
    IF WA_SUMFIN-JUN_VAL > 0 .
      MVAL = WA_SUMFIN-APR_VAL + WA_SUMFIN-MAY_VAL + WA_SUMFIN-JUN_VAL.
      MTGT = WA_SUMFIN-APR_TGT + WA_SUMFIN-MAY_TGT + WA_SUMFIN-JUN_TGT.
      IF MVAL > 0 AND MTGT > 0.
        QTY3 = ( MVAL  / MTGT ) * 100.
      ENDIF.
    ENDIF.

    IF WA_SUMFIN-SEP_VAL > 0 .
      MVAL = WA_SUMFIN-JUL_VAL + WA_SUMFIN-AUG_VAL + WA_SUMFIN-SEP_VAL.
      MTGT = WA_SUMFIN-JUL_TGT + WA_SUMFIN-AUG_TGT + WA_SUMFIN-SEP_TGT.
      IF MVAL > 0 AND MTGT > 0.
         QTY6 =  ( MVAL  / MTGT ) * 100.
      ENDIF.
    ENDIF.

    IF WA_SUMFIN-DEC_VAL > 0 .
      MVAL = WA_SUMFIN-OCT_VAL + WA_SUMFIN-NOV_VAL + WA_SUMFIN-DEC_VAL.
      MTGT = WA_SUMFIN-OCT_TGT + WA_SUMFIN-NOV_TGT + WA_SUMFIN-DEC_TGT.
      IF MVAL > 0 AND MTGT > 0.
        QTY9 =  ( MVAL  / MTGT ) * 100.
      ENDIF.
    ENDIF.
    IF WA_SUMFIN-MAR_VAL > 0 .
      MVAL = WA_SUMFIN-JAN_VAL + WA_SUMFIN-FEB_VAL + WA_SUMFIN-MAR_VAL.
      MTGT = WA_SUMFIN-JAN_TGT + WA_SUMFIN-FEB_TGT + WA_SUMFIN-MAR_TGT.
      IF MVAL > 0 AND MTGT > 0.
        QTY12 =  ( MVAL  / MTGT ) * 100.
      ENDIF.
    ENDIF.

  PRDNAME = '% TO Sale Trgt     (qtr)'.
  ELNAME = 'NDET'.
  PERFORM WRITE_MAIN_FORM.
  PERFORM GROUP-TOTAL.
  CLEAR : QTY1 , QTY2, QTY3 , QTY4, QTY5 , QTY6, QTY7 , QTY8, QTY9 , QTY10, QTY11, QTY12, ASOFQTY, QTYSUM.
  CLEAR : MVAL, MTGT .
    QTY1 = WA_SUMFIN-APR_PVAL.
    QTY2 = QTY1 + WA_SUMFIN-MAY_PVAL.
    QTY3 = QTY2 + WA_SUMFIN-JUN_PVAL.
    QTY4 = QTY3 + WA_SUMFIN-JUL_PVAL.
    QTY5 = QTY4 + WA_SUMFIN-AUG_PVAL.
    QTY6 = QTY5 + WA_SUMFIN-SEP_PVAL.
    QTY7 = QTY6 + WA_SUMFIN-OCT_PVAL.
    QTY8 = QTY7 + WA_SUMFIN-NOV_PVAL.
    QTY9 = QTY8 + WA_SUMFIN-DEC_PVAL.
    QTY10 = QTY9 + WA_SUMFIN-JAN_PVAL.
    QTY11 = QTY10 + WA_SUMFIN-FEB_PVAL.
    QTY12 = QTY11 + WA_SUMFIN-MAR_PVAL.
    QTYSUM =  QTY12.

  PRDNAME = 'PREV.YR. NET SALES (cum)'.
  ELNAME = 'NDET'.
  PERFORM WRITE_MAIN_FORM.
  PERFORM GROUP-TOTAL.

  CLEAR : QTY1 , QTY2, QTY3 , QTY4, QTY5 , QTY6, QTY7 , QTY8, QTY9 , QTY10, QTY11, QTY12, ASOFQTY, QTYSUM.
  CLEAR : MVAL, MTGT .
    QTY1 = WA_SUMFIN-APR_TGT.
    QTY2 = QTY1 + WA_SUMFIN-MAY_TGT.
    QTY3 = QTY2 + WA_SUMFIN-JUN_TGT.
    QTY4 = QTY3 + WA_SUMFIN-JUL_TGT.
    QTY5 = QTY4 + WA_SUMFIN-AUG_TGT.
    QTY6 = QTY5 + WA_SUMFIN-SEP_TGT.
    QTY7 = QTY6 + WA_SUMFIN-OCT_TGT.
    QTY8 = QTY7 + WA_SUMFIN-NOV_TGT.
    QTY9 = QTY8 + WA_SUMFIN-DEC_TGT.
    QTY10 = QTY9 + WA_SUMFIN-JAN_TGT.
    QTY11 = QTY10 + WA_SUMFIN-FEB_TGT.
    QTY12 = QTY11 + WA_SUMFIN-MAR_TGT.
    QTYSUM = qty12.

  PRDNAME = 'CURR.YR. Sale Trgt (cum)'.
  ELNAME = 'NDET'.
  PERFORM WRITE_MAIN_FORM.
  PERFORM GROUP-TOTAL.

  CLEAR : QTY1 , QTY2, QTY3 , QTY4, QTY5 , QTY6, QTY7 , QTY8, QTY9 , QTY10, QTY11, QTY12, ASOFQTY, QTYSUM.
  CLEAR : MVAL, MTGT .
    QTY1 = WA_SUMFIN-APR_VAL.
    QTY2 = QTY1 + WA_SUMFIN-MAY_VAL.
    QTY3 = QTY2 + WA_SUMFIN-JUN_VAL.
    QTY4 = QTY3 + WA_SUMFIN-JUL_VAL.
    QTY5 = QTY4 + WA_SUMFIN-AUG_VAL.
    QTY6 = QTY5 + WA_SUMFIN-SEP_VAL.
    QTY7 = QTY6 + WA_SUMFIN-OCT_VAL.
    QTY8 = QTY7 + WA_SUMFIN-NOV_VAL.
    QTY9 = QTY8 + WA_SUMFIN-DEC_VAL.
    QTY10 = QTY9 + WA_SUMFIN-JAN_VAL.
    QTY11 = QTY10 + WA_SUMFIN-FEB_VAL.
    QTY12 = QTY11 + WA_SUMFIN-MAR_VAL.
    QTYSUM = QTY12.

  PRDNAME = 'CURR.YR. NET SALES (cum)'.
  ELNAME = 'NDET'.
  PERFORM WRITE_MAIN_FORM.
  PERFORM GROUP-TOTAL.

  CLEAR : QTY1 , QTY2, QTY3 , QTY4, QTY5 , QTY6, QTY7 , QTY8, QTY9 , QTY10, QTY11, QTY12, ASOFQTY, QTYSUM.
  CLEAR : MVAL, MTGT .
    MVAL = WA_SUMFIN-APR_VAL.
    MTGT = WA_SUMFIN-APR_TGT.
    IF MVAL > 0 AND MTGT > 0.
      QTY1 = ( MVAL / MTGT ) * 100.
    ENDIF.
    IF WA_SUMFIN-MAY_VAL > 0 .
      MVAL = MVAL + WA_SUMFIN-MAY_VAL.
      MTGT = MTGT + WA_SUMFIN-MAY_TGT.
      IF MVAL > 0 AND MTGT > 0.
         QTY2 = ( MVAL / MTGT ) * 100.
      ENDIF.
    ENDIF.
    IF WA_SUMFIN-JUN_VAL > 0 .
    MVAL = MVAL + WA_SUMFIN-JUN_VAL.
    MTGT = MTGT + WA_SUMFIN-JUN_TGT.
    IF MVAL > 0 AND MTGT > 0.
      QTY3 = ( MVAL / MTGT ) * 100.
    ENDIF.
    ENDIF.
    IF WA_SUMFIN-JUL_VAL > 0 .
    MVAL = MVAL + WA_SUMFIN-JUL_VAL.
    MTGT = MTGT + WA_SUMFIN-JUL_TGT.
    IF MVAL > 0 AND MTGT > 0.
      QTY4 = ( MVAL / MTGT ) * 100.
    ENDIF.
    ENDIF.
    IF WA_SUMFIN-AUG_VAL > 0 .
    MVAL = MVAL + WA_SUMFIN-AUG_VAL.
    MTGT = MTGT + WA_SUMFIN-AUG_TGT.
    IF MVAL > 0 AND MTGT > 0.
      QTY5 = ( MVAL / MTGT ) * 100.
    ENDIF.
    ENDIF.
    IF WA_SUMFIN-SEP_VAL > 0 .
    MVAL = MVAL + WA_SUMFIN-SEP_VAL.
    MTGT = MTGT + WA_SUMFIN-SEP_TGT.
    IF MVAL > 0 AND MTGT > 0.
      QTY6 = ( MVAL / MTGT ) * 100.
    ENDIF.
    ENDIF.
    IF WA_SUMFIN-OCT_VAL > 0 .
    MVAL = MVAL + WA_SUMFIN-OCT_VAL.
    MTGT = MTGT + WA_SUMFIN-OCT_TGT.
    IF MVAL > 0 AND MTGT > 0.
      QTY7 = ( MVAL / MTGT ) * 100.
    ENDIF.
    ENDIF.
    IF WA_SUMFIN-NOV_VAL > 0 .
    MVAL = MVAL + WA_SUMFIN-NOV_VAL.
    MTGT = MTGT + WA_SUMFIN-NOV_TGT.
    IF MVAL > 0 AND MTGT > 0.
      QTY8 = ( MVAL / MTGT ) * 100.
    ENDIF.
    ENDIF.
    IF WA_SUMFIN-DEC_VAL > 0 .
    MVAL = MVAL + WA_SUMFIN-DEC_VAL.
    MTGT = MTGT + WA_SUMFIN-DEC_TGT.
    IF MVAL > 0 AND MTGT > 0.
      QTY9 = ( MVAL / MTGT ) * 100.
    ENDIF.
    ENDIF.
    IF WA_SUMFIN-JAN_VAL > 0 .
    MVAL = MVAL + WA_SUMFIN-JAN_VAL.
    MTGT = MTGT + WA_SUMFIN-JAN_TGT.
    IF MVAL > 0 AND MTGT > 0.
      QTY10 = ( MVAL / MTGT ) * 100.
    ENDIF.
    ENDIF.
    IF WA_SUMFIN-FEB_VAL > 0 .
    MVAL = MVAL + WA_SUMFIN-FEB_VAL.
    MTGT = MTGT + WA_SUMFIN-FEB_TGT.
    IF MVAL > 0 AND MTGT > 0.
      QTY11 = ( MVAL / MTGT ) * 100.
    ENDIF.
    ENDIF.
    IF WA_SUMFIN-MAR_VAL > 0 .
    MVAL = MVAL + WA_SUMFIN-MAR_VAL.
    MTGT = MTGT + WA_SUMFIN-MAR_TGT.
    IF MVAL > 0 AND MTGT > 0.
      QTY12 = ( MVAL / MTGT ) * 100.
    ENDIF.
    ENDIF.
*    QTYSUM = QTY12.

  pRDNAME = '% TO Sale Trgt     (cum)'.
  ELNAME = 'NDET'.
  PERFORM WRITE_MAIN_FORM.
  PERFORM GROUP-TOTAL.

  CLEAR : QTY1 , QTY2, QTY3 , QTY4, QTY5 , QTY6, QTY7 , QTY8, QTY9 , QTY10, QTY11, QTY12, ASOFQTY, QTYSUM.
  CLEAR : MVAL, MTGT .
    MVAL = WA_SUMFIN-APR_VAL.
    MTGT = WA_SUMFIN-APR_PVAL.
    IF MVAL > 0 AND MTGT > 0.
      QTY1 =  ( ( MVAL / MTGT ) * 100 ) - 100 .
    ENDIF.
    IF WA_SUMFIN-MAY_VAL > 0 .
      MVAL = MVAL + WA_SUMFIN-MAY_VAL.
      MTGT = MTGT + WA_SUMFIN-MAY_PVAL.
      IF MVAL > 0 AND MTGT > 0.
        QTY2 = ( ( MVAL / MTGT ) * 100 ) - 100 .
      ENDIF.
    ENDIF.
    IF WA_SUMFIN-JUN_VAL > 0 .
        MVAL = MVAL + WA_SUMFIN-JUN_VAL.
        MTGT = MTGT + WA_SUMFIN-JUN_PVAL.
        IF MVAL > 0 AND MTGT > 0.
          QTY3 = ( ( MVAL / MTGT ) * 100 ) - 100 .
        ENDIF.
    ENDIF.
    IF WA_SUMFIN-JUL_VAL > 0 .
    MVAL = MVAL + WA_SUMFIN-JUL_VAL.
    MTGT = MTGT + WA_SUMFIN-JUL_PVAL.
    IF MVAL > 0 AND MTGT > 0.
      QTY4 = ( ( MVAL / MTGT ) * 100 ) - 100 .
    ENDIF.
    ENDIF.
    IF WA_SUMFIN-AUG_VAL > 0 .
    MVAL = MVAL + WA_SUMFIN-AUG_VAL.
    MTGT = MTGT + WA_SUMFIN-AUG_PVAL.
    IF MVAL > 0 AND MTGT > 0.
      QTY5 = ( ( MVAL / MTGT ) * 100 ) - 100 .
    ENDIF.
    ENDIF.
    IF WA_SUMFIN-SEP_VAL > 0 .
    MVAL = MVAL + WA_SUMFIN-SEP_VAL.
    MTGT = MTGT + WA_SUMFIN-SEP_PVAL.
    IF MVAL > 0 AND MTGT > 0.
      QTY6 = ( ( MVAL / MTGT ) * 100 ) - 100 .
    ENDIF.
    ENDIF.
    IF WA_SUMFIN-OCT_VAL > 0 .
    MVAL = MVAL + WA_SUMFIN-OCT_VAL.
    MTGT = MTGT + WA_SUMFIN-OCT_PVAL.
    IF MVAL > 0 AND MTGT > 0.
      QTY7 = ( ( MVAL / MTGT ) * 100 ) - 100 .
    ENDIF.
    ENDIF.
    IF WA_SUMFIN-NOV_VAL > 0 .
    MVAL = MVAL + WA_SUMFIN-NOV_VAL.
    MTGT = MTGT + WA_SUMFIN-NOV_PVAL.
    IF MVAL > 0 AND MTGT > 0.
      QTY8 = ( ( MVAL / MTGT ) * 100 ) - 100 .
    ENDIF.
    ENDIF.
    IF WA_SUMFIN-DEC_VAL > 0 .
    MVAL = MVAL + WA_SUMFIN-DEC_VAL.
    MTGT = MTGT + WA_SUMFIN-DEC_PVAL.
    IF MVAL > 0 AND MTGT > 0.
      QTY9 = ( ( MVAL / MTGT ) * 100 ) - 100 .
    ENDIF.
    ENDIF.
    IF WA_SUMFIN-JAN_VAL > 0 .
    MVAL = MVAL + WA_SUMFIN-JAN_VAL.
    MTGT = MTGT + WA_SUMFIN-JAN_PVAL.
    IF MVAL > 0 AND MTGT > 0.
      QTY10 = ( ( MVAL / MTGT ) * 100 ) - 100 .
    ENDIF.
    ENDIF.
    IF WA_SUMFIN-FEB_VAL > 0 .
    MVAL = MVAL + WA_SUMFIN-FEB_VAL.
    MTGT = MTGT + WA_SUMFIN-FEB_PVAL.
    IF MVAL > 0 AND MTGT > 0.
      QTY11 = ( ( MVAL / MTGT ) * 100 ) - 100 .
    ENDIF.
    ENDIF.
    IF WA_SUMFIN-MAR_VAL > 0 .
    MVAL = MVAL + WA_SUMFIN-MAR_VAL.
    MTGT = MTGT + WA_SUMFIN-MAR_PVAL.
    IF MVAL > 0 AND MTGT > 0.
      QTY12 = ( ( MVAL / MTGT ) * 100 ) - 100 .
    ENDIF.
    ENDIF.
*    QTYSUM = QTY12.

  PRDNAME = 'NET CUMM. GROWTH%         '.
  ELNAME = 'NDET'.
  PERFORM WRITE_MAIN_FORM.
  PERFORM GROUP-TOTAL.
ENDFORM.                    " SUMMWRITE

*&---------------------------------------------------------------------*
*&      Form  TOTCALCGRTH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM TOTCALCGRTH .
  CLEAR : QTY1 , QTY2, QTY3 , QTY4, QTY5 , QTY6, QTY7 , QTY8, QTY9 , QTY10, QTY11, QTY12, ASOFQTY, QTYSUM.
  IF FPQTY1 > 0 AND FDQTY1 > 0.
    QTY1 = ( ( FDQTY1 / FPQTY1 ) * 100 ) - 100.
  ELSEIF   FPQTY1 > 0 AND FDQTY1 <= 0.
    QTY1 = -100 .
  ELSEIF  FPQTY1 <= 0 AND FDQTY1 > 0.
    QTY1 = 100 .
  ENDIF.
  QTYSUM = QTY1.
  IF FDQTY2 > 0.
     FPQTY1 = FPQTY1 + FPQTY2.
     FDQTY1 = FDQTY1 + FDQTY2.
     IF FPQTY1 > 0 AND FDQTY1 > 0.
       QTY2 = ( ( FDQTY1 / FPQTY1 ) * 100 ) - 100.
     ELSEIF   FPQTY1 > 0 AND FDQTY1 <= 0.
       QTY2 = -100 .
     ELSEIF  FPQTY1 <= 0 AND FDQTY1 > 0.
       QTY2  = 100 .
     ENDIF.
     QTYSUM = QTY2.
  ENDIF.
  IF FDQTY3 > 0.
     FPQTY1 = FPQTY1 + FPQTY3.
     FDQTY1 = FDQTY1 + FDQTY3.
     IF FPQTY1 > 0 AND FDQTY1 > 0.
       QTY3 = ( ( FDQTY1 / FPQTY1 ) * 100 ) - 100.
     ELSEIF   FPQTY1 > 0 AND FDQTY1 <= 0.
       QTY3 = -100 .
     ELSEIF  FPQTY1 <= 0 AND FDQTY1 > 0.
       QTY3  = 100 .
     ENDIF.
     QTYSUM = QTY3.
  ENDIF.
  IF FDQTY4 > 0.
     FPQTY1 = FPQTY1 + FPQTY4.
     FDQTY1 = FDQTY1 + FDQTY4.
     IF FPQTY1 > 0 AND FDQTY1 > 0.
       QTY4 = ( ( FDQTY1 / FPQTY1 ) * 100 ) - 100.
     ELSEIF   FPQTY1 > 0 AND FDQTY1 <= 0.
       QTY4 = -100 .
     ELSEIF  FPQTY1 <= 0 AND FDQTY1 > 0.
       QTY4  = 100 .
     ENDIF.
     QTYSUM = QTY4.
  ENDIF.
  IF FDQTY5 > 0.
     FPQTY1 = FPQTY1 + FPQTY5.
     FDQTY1 = FDQTY1 + FDQTY5.
     IF FPQTY1 > 0 AND FDQTY1 > 0.
       QTY5 = ( ( FDQTY1 / FPQTY1 ) * 100 ) - 100.
     ELSEIF   FPQTY1 > 0 AND FDQTY1 <= 0.
       QTY5 = -100 .
     ELSEIF  FPQTY1 <= 0 AND FDQTY1 > 0.
       QTY5  = 100 .
     ENDIF.
     QTYSUM = QTY5.
  ENDIF.
  IF FDQTY6 > 0.
     FPQTY1 = FPQTY1 + FPQTY6.
     FDQTY1 = FDQTY1 + FDQTY6.
     IF FPQTY1 > 0 AND FDQTY1 > 0.
       QTY6 = ( ( FDQTY1 / FPQTY1 ) * 100 ) - 100.
     ELSEIF   FPQTY1 > 0 AND FDQTY1 <= 0.
       QTY6 = -100 .
     ELSEIF  FPQTY1 <= 0 AND FDQTY1 > 0.
       QTY6  = 100 .
     ENDIF.
     QTYSUM = QTY6.
  ENDIF.
  IF FDQTY7 > 0.
     FPQTY1 = FPQTY1 + FPQTY7.
     FDQTY1 = FDQTY1 + FDQTY7.
     IF FPQTY1 > 0 AND FDQTY1 > 0.
       QTY7 = ( ( FDQTY1 / FPQTY1 ) * 100 ) - 100.
     ELSEIF   FPQTY1 > 0 AND FDQTY1 <= 0.
       QTY7 = -100 .
     ELSEIF  FPQTY1 <= 0 AND FDQTY1 > 0.
       QTY7 = 100 .
     ENDIF.
     QTYSUM = QTY7.
  ENDIF.
  IF FDQTY8 > 0.
     FPQTY1 = FPQTY1 + FPQTY8.
     FDQTY1 = FDQTY1 + FDQTY8.
     IF FPQTY1 > 0 AND FDQTY1 > 0.
       QTY8 = ( ( FDQTY1 / FPQTY1 ) * 100 ) - 100.
     ELSEIF   FPQTY1 > 0 AND FDQTY1 <= 0.
       QTY8 = -100 .
     ELSEIF  FPQTY1 <= 0 AND FDQTY1 > 0.
       QTY8 = 100 .
     ENDIF.
     QTYSUM = QTY8.
  ENDIF.
  IF FDQTY9 > 0.
     FPQTY1 = FPQTY1 + FPQTY9.
     FDQTY1 = FDQTY1 + FDQTY9.
     IF FPQTY1 > 0 AND FDQTY1 > 0.
       QTY9 = ( ( FDQTY1 / FPQTY1 ) * 100 ) - 100.
     ELSEIF   FPQTY1 > 0 AND FDQTY1 <= 0.
       QTY9 = -100 .
     ELSEIF  FPQTY1 <= 0 AND FDQTY1 > 0.
       QTY9  = 100 .
     ENDIF.
     QTYSUM = QTY9.
  ENDIF.
  IF FDQTY10 > 0.
     FPQTY1 = FPQTY1 + FPQTY10.
     FDQTY1 = FDQTY1 + FDQTY10.
     IF FPQTY1 > 0 AND FDQTY1 > 0.
       QTY10 = ( ( FDQTY1 / FPQTY1 ) * 100 ) - 100.
     ELSEIF   FPQTY1 > 0 AND FDQTY1 <= 0.
       QTY10 = -100 .
     ELSEIF  FPQTY1 <= 0 AND FDQTY1 > 0.
       QTY10  = 100 .
     ENDIF.
     QTYSUM = QTY10.
  ENDIF.
  IF FDQTY11 > 0.
     FPQTY1 = FPQTY1 + FPQTY11.
     FDQTY1 = FDQTY1 + FDQTY11.
     IF FPQTY1 > 0 AND FDQTY1 > 0.
       QTY11 = ( ( FDQTY1 / FPQTY1 ) * 100 ) - 100.
     ELSEIF   FPQTY1 > 0 AND FDQTY1 <= 0.
       QTY11 = -100 .
     ELSEIF  FPQTY1 <= 0 AND FDQTY1 > 0.
       QTY11  = 100 .
     ENDIF.
     QTYSUM = QTY11.
  ENDIF.
  IF FDQTY12 > 0.
     FPQTY1 = FPQTY1 + FPQTY12.
     FDQTY1 = FDQTY1 + FDQTY12.
     IF FPQTY1 > 0 AND FDQTY1 > 0.
       QTY12 = ( ( FDQTY1 / FPQTY1 ) * 100 ) - 100.
     ELSEIF   FPQTY1 > 0 AND FDQTY1 <= 0.
       QTY12 = -100 .
     ELSEIF  FPQTY1 <= 0 AND FDQTY1 > 0.
       QTY12  = 100 .
     ENDIF.
     QTYSUM = QTY12.
  ENDIF.



ENDFORM.                    " TOTCALCGRTH
