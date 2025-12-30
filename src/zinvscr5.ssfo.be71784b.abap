CLEAR :lv_qrcode.
SELECT SINGLE ack_no  signed_qrcode
  FROM j_1ig_invrefnum
  INTO (lv_ackno  , lv_qrcode )
  WHERE docno = vbeln.
IF sy-subrc NE 0.
  lv_b2c = 'X'.
ENDIF.
