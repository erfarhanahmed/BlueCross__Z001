"Name: \PR:SAPLCKDI\FO:FCODE_KIS1_F0F\SE:END\EI
ENHANCEMENT 0 ZCK11N.
*break CTPLNA.
*if sy-tcode = 'CK11N'.
*data : lv_per like vbrp-netwr.
*data : wa_tab1 like ztb_ck11.
*data : wa_tab like t_kis1_temp.
*loop at t_kis1_temp into wa_tab
*              where typps = 'G'.
*select single * into wa_tab1
*            from ztb_ck11 where
*                 werks = CKI64A-werks and
*                 matnr = CKI64A-matnr and
*                 kstar = wa_tab-kstar.
*
*if sy-subrc eq 0.
*wa_tab-wertn     = ( CKI64A-losgr *  wa_tab1-per ) / 100.
*wa_tab-wrtfw_kpf = ( CKI64A-losgr *  wa_tab1-per ) / 100..
*wa_tab-wrtfw_pos = ( CKI64A-losgr *  wa_tab1-per ) / 100..
*modify t_kis1_temp from wa_tab.
*endif.
*clear : lv_per.
*clear : wa_tab.
*endloop.
*endif.
ENDENHANCEMENT.
