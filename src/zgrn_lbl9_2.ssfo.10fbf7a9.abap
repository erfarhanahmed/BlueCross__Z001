
*num1 = num1 + 1.
*BREAK-POINT.
**delete it_tab1 WHERE count eq 1.
*nval = 1.
*READ TABLE it_tab1 INTO wa_tab1 with KEY count = 1.
*if sy-subrc eq 4.
*  nval = 5.
*endif.

*LOOP at it_tab1 INTO wa_tab1.
*
*  ENDLOOP.





