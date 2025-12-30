**&---------------------------------------------------------------------*
**& Include          ZXM06U14
**&---------------------------------------------------------------------*
*break ctplna.
*break ctplabap.
*data : lv_price like ztp_cost11-gstval1.
*DATA : wa_tab like ZTP_me21n.
**if I_EKKO-bsart = 'Z3P'.
**
**if    i_ekpo-matnr ne '' and
**      i_ekpo-menge ne 0  and
**      i_ekpo-netwr ne 0.
**select single * from ZTP_me21n into
**             wa_tab where bukrs = i_ekpo-bukrs and
**                          bname = SYST-UNAME   and
**                          lifnr = i_ekko-lifnr and
**                          DATAB ge i_ekko-AEDAT and
**                          STATUS = 'A' .
**if sy-subrc ne 0.
**select single gstval1 into lv_price
**            from ztp_cost11 where
***                werks   = i_ekpo-werks and
**                 FGLIFNR = i_ekko-lifnr and
**                 matnr = i_ekpo-matnr.
**if sy-subrc eq 0.
**  if i_ekpo-netpr le lv_price.
**     message 'Cost sheet Value is Less then Net Pice' type 'I' DISPLAY LIKE 'W'.
**  elseif  i_ekpo-netpr ge lv_price.
**     message 'Cost sheet Value is More then Net Pice' TYPE 'I' DISPLAY LIKE 'W'.
**  endif.
**else.
**
**message 'Cost Sheet not maintained for this Material with this Vendor'
**         type 'I' DISPLAY LIKE 'W'.
**
**endif.
**endif.
**endif.
**endif.
