CLEAR lv_irn.
SELECT SINGLE irn
  FROM j_1ig_invrefnum
  INTO lv_irn
  WHERE docno = vbeln
  and   IRN_STATUS = 'ACT'.
