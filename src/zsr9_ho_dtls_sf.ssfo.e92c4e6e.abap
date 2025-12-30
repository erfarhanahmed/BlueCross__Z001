****** productivity
clear gv_prdvty.
catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
  gv_prdvty = gw_sr9_prdvty-sale / gw_sr9_prdvty-bzirk_cnt.
endcatch.
























