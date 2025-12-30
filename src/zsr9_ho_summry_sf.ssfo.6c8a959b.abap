catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
  gw_sr9_summ-per = ( gw_sr9_summ-sale /  gw_sr9_summ-target ) * 100.
endcatch.

**** all GM-wise total
GV_GM_TGT_TOT = GV_GM_SALE_TOT + gw_sr9_summ-sale.

catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
  GV_GM_TGT_TOT = ( GV_GM_SALE_TOT /  GV_GM_TARGET_TOT ) * 100.
endcatch.













