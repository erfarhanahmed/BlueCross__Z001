IF gs_conad-street IS NOT INITIAL.
  sh_ad_l1 = gs_conad-street.
ENDIF.

IF gs_conad-str_suppl1 IS NOT INITIAL.
  sh_ad_l2 = gs_conad-str_suppl1.
endif.
IF gs_conad-str_suppl2 IS NOT INITIAL.
  CONCATENATE sh_ad_l2 gs_conad-str_suppl2 INTO
  sh_ad_l2 SEPARATED BY SPACE.
endif.
IF gs_conad-str_suppl3 IS NOT INITIAL.
coNCATENATE sh_ad_l2 gs_conad-str_suppl3 INTO
  sh_ad_l2 SEPARATED BY SPACE.
endif.
IF gs_conad-location IS NOT INITIAL.
coNCATENATE sh_ad_l2 gs_conad-location INTO
  sh_ad_l2 SEPARATED BY SPACE.
ENDIF.

IF gs_conad-city1 is NOT INITIAL.
  sh_ad_l3 = gs_conad-city1.
ENDIF.
IF gs_conad-post_code1 IS NOT INITIAL.
  CONCATENATE sh_ad_l3 gs_conad-post_code1
  INTO sh_ad_l3 SEPARATED BY space.
ENDIF.
data : bezei type t005u-bezei.
SELECT SINGLE bezei FROM t005u INTO bezei
  WHERE spras = 'EN' AND land1 = gs_conad-COUNTRY
  AND bland = gs_conad-region.

CONCATENATE sh_ad_l3 bezei INTO sh_ad_l3
SEPARATED BY SPACE.





















