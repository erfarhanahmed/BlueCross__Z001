
num1 = num1 + 1.
*BREAK-POINT.
delete it_tab1 WHERE count eq 2.
*
*nval = 3.
*READ TABLE it_tab1 INTO wa_tab1 with KEY count = 1.
*if sy-subrc eq 4.
*  nval = 7.
*endif.
*
*if nval eq 7.
*  delete it_tab1 WHERE count eq 6.
*endif.
*
**delete it_tab1 WHERE count ne 3.







