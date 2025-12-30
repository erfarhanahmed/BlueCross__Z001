

DATA : knumv_temp TYPE konv-knumv.
DATA : konv_t TYPE PRCD_ELEMENTS.

SELECT SINGLE fkdat knumv FROM vbrk
  INTO ( fkdat , knumv_temp )
 WHERE VBELN = IS_HDREF-BIL_NUMBER.

SELECT SINGLE * FROM PRCD_ELEMENTS INTO konv_t
  WHERE knumv = knumv_temp AND kschl = 'ZFR0' AND KWERT NE ''.

IF konv_t-KWERT IS NOT INITIAL.
CONCATENATE 'We hereby declare that Basic'
        'Price is Inclusive with Freight' INTO
         LW_DEC SEPARATED BY SPACE .
ENDIF.





