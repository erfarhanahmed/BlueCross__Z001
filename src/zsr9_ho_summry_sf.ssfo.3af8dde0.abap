clear gv_mnth_grth.
catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
  gv_mnth_grth = ( gw_sr9_summ-sale / gw_sr9_summ-psale ) * 100 - 100..
endcatch.
















