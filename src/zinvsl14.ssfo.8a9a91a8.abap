
clear :lv_qrcode ,lv_irn.
sELECT SINGLE ack_no  signed_qrcode irn
  FROM j_1ig_invrefnum
  INTO (lv_ackno  , lv_qrcode , lv_irn )
  WHERE docno = billno
  and   IRN_STATUS = 'ACT'.
DATA lr_object TYPE REF TO cl_document_bcs.
data: ls_qrtext TYPE soli.
DATA:lv_lines TYPE i.
REFRESH : lt_qrtext.
clear : ls_qrtext.
FREE: lr_object.
CLEAR: gv_qr1, gv_qr2, gv_qr3, gv_qr4, gv_qr5.

gv_qrcode = lv_qrcode.
CREATE OBJECT lr_object.
CALL METHOD lr_object->string_to_soli
  EXPORTING
    ip_string = gv_qrcode   " QR CODE TEXT
  RECEIVING
    rt_soli   = lt_qrtext.

DESCRIBE TABLE  lt_qrtext LINES lv_lines.
IF 1 LE lv_lines.
  read TABLE lt_qrtext INTO ls_qrtext INDEX 1.
*  gv_qr1 = lt_qrtext [ 1 ] - line.
  gv_qr1 = ls_qrtext-line.
ENDIF.
IF 2 LE lv_lines.
  clear : ls_qrtext.
  read TABLE lt_qrtext INTO ls_qrtext INDEX 2.
*  gv_qr2 = lt_qrtext[ 2 ]-LINE.
   gv_qr2 = ls_qrtext-line.
ENDIF.
IF 3 LE lv_lines.
  clear : ls_qrtext.
  read TABLE lt_qrtext INTO ls_qrtext INDEX 3.
*  gv_qr3 = lt_qrtext[ 3 ]-LINE.
     gv_qr3 = ls_qrtext-line.
ENDIF.
IF 4 LE lv_lines.
  clear : ls_qrtext.
  read TABLE lt_qrtext INTO ls_qrtext INDEX 4.
*  gv_qr4 = lt_qrtext[ 4 ]-LINE.
   gv_qr4 = ls_qrtext-line.
ENDIF.
IF 5 LE lv_lines.
  clear : ls_qrtext.
  read TABLE lt_qrtext INTO ls_qrtext INDEX 5.
*  gv_qr5 = lt_qrtext[ 5 ]-LINE.
    gv_qr5 = ls_qrtext-line.
ENDIF.
















