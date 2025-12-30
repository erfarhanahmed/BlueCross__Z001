"Name: \PR:SAPMF05A\FO:PAI_PERIODE_PRUEFEN\SE:BEGIN\EI
ENHANCEMENT 0 ZFB70N.
if sy-tcode = 'FBZ1' or
   sy-tcode = 'FBA2'.
data : lv_date like sy-datum.
lv_date = sy-datum - 30.
if bkpf-bldat ne '00000000'.
if bkpf-bldat le lv_date.
message 'Invoice Date is less then 30 days Pls change and proceed'
         type 'I' DISPLAY LIKE 'E'.
leave to TRANSACTION 'SESSION_MANAGER'.
endif.
endif.
endif.
ENDENHANCEMENT.
