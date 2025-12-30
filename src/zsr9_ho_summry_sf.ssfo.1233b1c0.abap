
data : lv_sale_tot type zval_dec0,
       lv_tgt_tot  type zval_dec0.

******  % div ACH
clear lv_sale_tot.
clear lv_tgt_tot.
clear gw_sr9_prdvty.
loop at gt_sr9_prdvty into gw_sr9_prdvty .
  lv_sale_tot = lv_sale_tot + gw_sr9_prdvty-sale.
  lv_tgt_tot = lv_tgt_tot + gw_sr9_prdvty-target.
endloop.

if lv_tgt_tot is not initial.
  lv_sale_tot = lv_sale_tot / 100.
  lv_tgt_tot = lv_tgt_tot / 100.

*****  get % achievment - Total
  clear gv_sale_tot.
  gv_sale_tot = ( lv_sale_tot / lv_tgt_tot ) * 100.
endif.



















