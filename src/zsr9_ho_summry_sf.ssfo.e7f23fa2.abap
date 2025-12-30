****** productivity
clear gv_prdvty.
catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
  gv_prdvty = GW_SR9_PRDVTY_TOT-sale / GW_SR9_PRDVTY_TOT-bzirk_cnt.
endcatch.





















