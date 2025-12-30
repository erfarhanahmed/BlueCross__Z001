*IF gs_buyad-street IS NOT INITIAL.
*  so_ad_l1 = gs_buyad-street.
*ENDIF.
*
*IF gs_buyad-str_suppl1 IS NOT INITIAL.
*  so_ad_l2 = gs_buyad-str_suppl1.
*endif.
*IF gs_buyad-str_suppl2 IS NOT INITIAL.
*  CONCATENATE so_ad_l2 gs_buyad-str_suppl2 INTO
*  so_ad_l2 SEPARATED BY SPACE.
*endif.
*IF gs_buyad-str_suppl3 IS NOT INITIAL.
*coNCATENATE so_ad_l2 gs_buyad-str_suppl3 INTO
*  so_ad_l2 SEPARATED BY SPACE.
*endif.
*IF gs_buyad-location IS NOT INITIAL.
*coNCATENATE so_ad_l2 gs_buyad-location INTO
*  so_ad_l2 SEPARATED BY SPACE.
*ENDIF.
*
*IF gs_buyad-city1 is NOT INITIAL.
*  so_ad_l3 = gs_buyad-city1.
*ENDIF.
*IF gs_buyad-post_code1 IS NOT INITIAL.
*  CONCATENATE so_ad_l3 gs_buyad-post_code1
*  INTO so_ad_l3 SEPARATED BY space.
*ENDIF.
*data : bezei type t005u-bezei.
*SELECT SINGLE bezei FROM t005u INTO bezei
*  WHERE spras = 'EN' AND land1 = gs_buyad-COUNTRY
*  AND bland = gs_buyad-region.
*
*CONCATENATE so_ad_l3 bezei INTO so_ad_l3
*SEPARATED BY SPACE.


*BREAK sapabap.
READ TABLE  it_isd INTO wa_isd INDEX 1.


SELECT SINGLE *  FROM j_1bbranch
INTO @DATA(wa_branch)
WHERE branch = @wa_isd-rec_bupla .
wa_name = wa_branch-name.
gv_GSTIN = wa_branch-GSTIN.

SELECT SINGLE street,STR_SUPPL2,region,POST_CODE1
  FROM adrc
  INTO @DATA(wa_adrc)
  WHERE addrnumber = @wa_branch-adrnr.


gv_street = wa_adrc-street.
gv_supp =  wa_adrc-str_suppl2.
gv_reg = wa_adrc-region.
gv_post = wa_adrc-POST_CODE1.







