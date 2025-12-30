report ZJ_1IG  no standard page heading line-size 255.
data : bdcdata       LIKE bdcdata OCCURS 0 WITH HEADER LINE,
       wa_bdcdata    TYPE bdcdata,
       wa_bdcdata1   type bdcdata,
       it_msg1        TYPE TABLE OF bdcmsgcoll,
        wa_msg        TYPE bdcmsgcoll.

perform bdc_dynpro      using 'SAPMSSY0'        '0120'.
perform bdc_field       using 'BDC_CURSOR'      '04/03'.
perform bdc_field       using 'BDC_OKCODE'      '=&ALL'.

perform bdc_dynpro      using 'SAPMSSY0'        '0120'.
perform bdc_field       using 'BDC_CURSOR'      '04/03'.
perform bdc_field       using 'BDC_OKCODE'      '=&GST'.

perform bdc_dynpro      using 'SAPMSSY0'        '0120'.
perform bdc_field       using 'BDC_CURSOR'      '04/03'.
perform bdc_field       using 'BDC_OKCODE'      '=&F03'.
*perform bdc_transaction using 'ZJ_1IG'.

 CALL TRANSACTION 'ZJ_1IG_INV' USING BDCDATA mode 'A'
*  CALL TRANSACTION 'ZJ_1IG' USING BDCDATA mode 'N'
                                     "OPTIONS FROM WA_CTU_PARAMS
                                     MESSAGES INTO IT_MSG1.


FORM BDC_DYNPRO USING PROGRAM DYNPRO.
  CLEAR BDCDATA.
  BDCDATA-PROGRAM  = PROGRAM.
  BDCDATA-DYNPRO   = DYNPRO.
  BDCDATA-DYNBEGIN = 'X'.
  APPEND BDCDATA.
ENDFORM.                    "BDC_DYNPRO

FORM BDC_FIELD USING FNAM FVAL.
  CLEAR BDCDATA.
  BDCDATA-FNAM = FNAM.
  BDCDATA-FVAL = FVAL.
  APPEND BDCDATA.

ENDFORM.
