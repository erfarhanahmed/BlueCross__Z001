
*num1 = num1 + 1.
*delete it_tab1 WHERE count eq 1.
*BREAK-POINT.
*
*nval = 2.
*READ TABLE it_tab1 INTO wa_tab1 with KEY count = 2.
*if sy-subrc eq 4.
*  nval = 6.
*endif.
*if nval eq 6.
*  delete it_tab1 WHERE count eq 5.
*ENDIF.


*delete it_tab1 WHERE count ne 2.







