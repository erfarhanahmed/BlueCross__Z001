clear GV_SALE_TOT.
******  XL div count
clear gw_sr9_prdvty.
loop at gt_sr9_prdvty into gw_sr9_prdvty where div = 'XL'.
  GV_SALE_TOT = GV_SALE_TOT + gw_sr9_prdvty-target.
endloop.

if gv_sale_tot is not initial.
  gv_sale_tot = gv_sale_tot / 100.
endif.















