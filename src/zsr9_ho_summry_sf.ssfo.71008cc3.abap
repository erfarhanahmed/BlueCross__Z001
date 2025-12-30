****** productivity
CLEAR GV_GM_PRDVTY_TOT.
catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
  GV_GM_PRDVTY_TOT = GV_GM_SALE_TOT / GV_GM_BZIRK_TOT.
endcatch.
















