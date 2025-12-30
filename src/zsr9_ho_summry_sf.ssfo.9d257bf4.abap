clear gw_sr9_summ_rm.
clear gv_div_cnt.

loop at gt_sr9_summ_rm into gw_sr9_summ_rm where div = 'LS'.
  gv_div_cnt = gv_div_cnt  + gw_sr9_summ_rm-per_cnt.
endloop.


















