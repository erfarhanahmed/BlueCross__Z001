clear gv_mnth_grth.

catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
  gv_mnth_grth = ( GW_SR9_PRDVTY_TOT-sale / GW_SR9_PRDVTY_TOT-psale ) * 100 - 100.
endcatch.


















