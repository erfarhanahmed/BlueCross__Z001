****title
data : lv_ktx type fcktx,
       lv_str TYPE string.

select single ktx from t247 into lv_ktx
  where spras = sy-langu
  and mnr = gw_sr9_gm-zmonth.
clear gv_title.
concatenate gw_sr9_gm-div '(Vs. FIELD TARGET)'
            into gv_title separated by space.
clear gv_title1.
clear lv_str.
CONCATENATE lv_ktx '.' gw_sr9_gm-zyear INTO lv_str.
if r_net = 'X'.
  concatenate 'SR-9 NET: ALL SM/ZM SALES SUMMARY FOR MONTH -'
               lv_str  '(000)'
               into gv_title1 SEPARATED BY space.

endif.

if r_gross = 'X'.
  concatenate 'SR-9 GROSS: ALL SM/ZM SALES SUMMARY FOR MONTH -'
               lv_str '(000)'
               into gv_title1 SEPARATED BY space.

endif.
















