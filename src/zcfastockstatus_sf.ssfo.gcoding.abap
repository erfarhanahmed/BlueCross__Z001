clear GV_TITLE.
GV_TITLE =  'IR13-C :  CFA STOCK (EXCESS & SHORTAGE)'.

*** identify shortfall/excess stock and then assign color
*** for printing and delete other details.
clear gw_fdata.
loop at gt_fdata into gw_fdata.
  clear gv_inv.
  gv_inv = gw_fdata-zvalst + gw_fdata-zvalit.

 gw_fdata-spart = 'XX'.
***for color print
  if gw_fdata-zvallow is not initial
    and gw_fdata-zvalhigh is not initial.
    if gv_inv <= gw_fdata-zvallow.
      gw_fdata-spart = 'RR'.  "Red
    elseif  gv_inv >= gw_fdata-zvalhigh.
      gw_fdata-spart = 'OO'.    "Orange
    endif.
  endif.
  modify gt_fdata from gw_fdata transporting spart.
  clear gw_fdata.
endloop.

if gt_fdata[] is not initial.
**delete data where Red/Orange is not set
  sort gt_fdata by spart.
  delete gt_fdata where spart = 'XX'.

  clear gt_maktx[].

  gt_maktx[] = gt_fdata[].
  sort gt_maktx by maktx.
  delete adjacent duplicates from gt_maktx comparing maktx.

  sort gt_maktx by maktx zshort_nm.
  sort gt_fdata by maktx zshort_nm.

endif.





























