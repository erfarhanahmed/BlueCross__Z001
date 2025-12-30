
**num1 = num1 + 1.
*BREAK-POINT.
*delete it_tab1 WHERE count eq 3.
*
*nval = 4.
*READ TABLE it_tab1 INTO wa_tab1 with KEY count = 1.
*if sy-subrc eq 4.
*  nval = 8.
*endif.
*
*if nval eq 8.
*  delete it_tab1 WHERE count eq 7.
*endif.
*
**delete it_tab1 WHERE count ne 4.








