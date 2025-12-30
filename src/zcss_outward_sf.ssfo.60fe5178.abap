clear gw_0006.
read table gt_0006 into gw_0006 with key
pernr = gw_fdata_lp-zemp_req.
if sy-subrc = 0.
  clear gv_state_nm.
  select single bezei from t005u into gv_state_nm
    where spras = sy-langu
    and land1 = gw_0006-land1
    and bland = gw_0006-state.
endif.






















