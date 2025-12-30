*lv_uname = sy-UNAME.

select single TECHDESC from usr21
  into @lv_uname where  BNAME = @sy-UNAME.



















