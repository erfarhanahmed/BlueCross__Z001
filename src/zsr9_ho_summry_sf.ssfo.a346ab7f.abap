clear gw_sr9_summ_zm.
clear gv_div_cnt.

loop at gt_sr9_summ_zm into gw_sr9_summ_zm where div = 'LS'.
  gv_div_cnt = gv_div_cnt + gw_sr9_summ_zm-per_cnt.
endloop.



















