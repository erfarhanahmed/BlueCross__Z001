clear gv_terr_cnt.
******  XL div count
clear gw_sr9_prdvty.
loop at gt_sr9_prdvty into gw_sr9_prdvty where div = 'XL'.
  gv_terr_cnt = gv_terr_cnt + gw_sr9_prdvty-per_cnt.
endloop.





















