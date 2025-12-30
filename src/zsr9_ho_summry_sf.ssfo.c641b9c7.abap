clear gv_sale_tot.
******  BC div count
clear gw_sr9_prdvty.
loop at gt_sr9_prdvty into gw_sr9_prdvty where div = 'BC'.
  gv_sale_tot = gv_sale_tot + gw_sr9_prdvty-target.
endloop.

if gv_sale_tot is not initial.
  gv_sale_tot = gv_sale_tot / 100.
endif.
















