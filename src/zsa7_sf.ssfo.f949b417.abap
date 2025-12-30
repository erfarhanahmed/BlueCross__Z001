data : lv_str  type string,
       lv_str1 type string.

clear gv_title.
  gv_title = 'SA-7 : DZM PERFORMANCE SALE (GROSS)'.


clear lv_str.
concatenate 'FOR THE PERIOD :'
sdate+6(2) '.' sdate+4(2) '.' sdate+0(4) into lv_str.
clear lv_str1.
concatenate
edate+6(2) '.' edate+4(2) '.' edate+0(4) into lv_str1.

clear gv_title1.
concatenate lv_str
       'TO' lv_str1 into gv_title1 separated by space.








