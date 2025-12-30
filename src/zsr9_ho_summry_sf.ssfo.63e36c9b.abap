clear gv_terr_cnt.
******  TOTAL div count
clear gw_sr9_prdvty.
loop at gt_sr9_prdvty into gw_sr9_prdvty .
  gv_terr_cnt = gv_terr_cnt + gw_sr9_prdvty-per_cnt.
endloop.




















