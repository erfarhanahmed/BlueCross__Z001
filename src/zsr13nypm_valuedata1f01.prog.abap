*----------------------------------------------------------------------*
***INCLUDE ZSR13N_VALUEDATA1F01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  VALUEDATA1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form valuedata1 .

  data : mdoj       type sy-datum,
         enddate    type sy-datum,
         mday(2)    type n,
         myear(4)   type n,
         currmth(2) type n,
         mmth1(2)   type n.

  clear : it_zdsmter1 , wa_zdsmter1, it_zdsmter1 , wa_zdsmter1.
  c_date = cryrdt.
  myear = c_date+0(4).
  currmth = mdate+4(2).

  select * from zdsmter into  table it_zdsmter5 where zyear = mdate+0(4)  and zmonth = currmth and zdsm in zone.

  select * from zdsmter into  table it_zdsmter1 where zyear >= myear and zdsm in ter.
  loop at it_zdsmter1 into wa_zdsmter1 where zdsm+0(2) = 'R-' and zmonth >= 4 and zyear = myear.
    read table it_zdsmter5 into wa_zdsmter5 with key bzirk = wa_zdsmter1-zdsm.
    if sy-subrc = 0.
      wa_zdsmter2-zdsm = wa_zdsmter1-zdsm.
      wa_zdsmter2-bzirk  = wa_zdsmter1-bzirk.
      wa_zdsmter2-zmonth = wa_zdsmter1-zmonth.
      wa_zdsmter2-zyear =  wa_zdsmter1-zyear.
      enddate+0(4) = wa_zdsmter1-zyear.
      enddate+4(2) = wa_zdsmter1-zmonth.
      enddate+6(2) = '01'.
      select single * from yterrallc where bzirk = wa_zdsmter1-bzirk and spart = wa_zdsmter1-spart AND begda <= enddate AND endda >= enddate.
      if sy-subrc = 0.
        if enddate <= yterrallc-endda.
          collect wa_zdsmter2 into it_zdsmter2.
        else.
*             WRITE : /1 'TER TERMINATED',WA_ZDSMTER2-BZIRK,  ENDDATE, YTERRALLC-ENDDA .
        endif.
      endif.
*       COLLECT WA_ZDSMTER2 INTO IT_ZDSMTER2.
*     write : /1  WA_ZDSMTER1-bzirk, WA_ZDSMTER1-ZDSM, WA_ZDSMTER1-ZMONTH, WA_ZDSMTER1-ZYEAR.
      clear wa_zdsmter2.
    endif.
  endloop.
  myear = myear + 1.
  loop at it_zdsmter1 into wa_zdsmter1 where zdsm+0(2) = 'R-' and zmonth <= 3 and zyear = myear .
    read table it_zdsmter5 into wa_zdsmter5 with key bzirk = wa_zdsmter1-zdsm.
    if sy-subrc = 0.
      wa_zdsmter2-zdsm = wa_zdsmter1-zdsm.
      wa_zdsmter2-bzirk  = wa_zdsmter1-bzirk.
      wa_zdsmter2-zmonth = wa_zdsmter1-zmonth.
      wa_zdsmter2-zyear =  wa_zdsmter1-zyear.
      enddate+0(4) = wa_zdsmter1-zyear.
      enddate+4(2) = wa_zdsmter1-zmonth.
      enddate+6(2) = '01'.
      select single * from yterrallc where bzirk = wa_zdsmter1-bzirk and spart = wa_zdsmter1-spart AND begda <= enddate AND endda >= enddate..
      if sy-subrc = 0.
        if enddate <= yterrallc-endda.
          collect wa_zdsmter2 into it_zdsmter2.
        else.
          write : /1 'TER TERMINATED',wa_zdsmter2-bzirk,  enddate, yterrallc-endda .
        endif.
      endif.
*    COLLECT WA_ZDSMTER2 INTO IT_ZDSMTER2.
*    write : /1  WA_ZDSMTER1-bzirk, WA_ZDSMTER1-ZDSM, WA_ZDSMTER1-ZMONTH, WA_ZDSMTER1-ZYEAR.
      clear wa_zdsmter2.
    endif.
  endloop.

  clear wa_zdsmter2.
  sort it_zdsmter2 by zdsm zmonth zyear.
  loop at it_zdsmter2 into wa_zdsmter2 where zmonth = 4.
    wa_sumfin-bzirk   = wa_zdsmter2-zdsm.
*   write : /1 WA_ZDSMTER2-ZDSM , WA_ZDSMTER2-bzirk..
    read table it_tgt1 into wa_tgt1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-apr_tgt = wa_tgt1-month01.
    endif.
    read table it_tgtp1 into wa_tgtp1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-apr_ptgt = wa_tgtp1-month01.
    endif.

    read table it_netvalp1 into  wa_netvalp1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-apr_pval = wa_netvalp1-netval.
    endif.
    read table it_netval1 into  wa_netval1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-apr_val = wa_netval1-netval.
    endif.
    collect wa_sumfin into it_tabsum.
    clear wa_sumfin.
    clear wa_zdsmter2.
  endloop.
  if currmth > 3 and currmth < 5.
    mmth1 = currmth.
  else.
    mmth1 = 5.
  endif.
  loop at it_zdsmter2 into wa_zdsmter2 where zmonth = mmth1.
    wa_sumfin-bzirk   = wa_zdsmter2-zdsm.
    read table it_tgt1 into wa_tgt1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-may_tgt = wa_tgt1-month02.
    endif.
    read table it_tgtp1 into wa_tgtp1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-may_ptgt = wa_tgtp1-month02.
    endif.

    read table it_netvalp2 into  wa_netvalp1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-may_pval = wa_netvalp1-netval.
    endif.
    read table it_netval2 into  wa_netval1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-may_val = wa_netval1-netval.
    endif.
    collect wa_sumfin into it_tabsum.
    clear wa_sumfin.
    clear : wa_zdsmter2 , wa_netvalp1 , wa_netval1.
  endloop.

  if currmth > 3 and currmth < 6.
    mmth1 = currmth.
  else.
    mmth1 = 6.
  endif.
  loop at it_zdsmter2 into wa_zdsmter2 where zmonth = mmth1.
    wa_sumfin-bzirk   = wa_zdsmter2-zdsm.
    read table it_tgt1 into wa_tgt1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-jun_tgt = wa_tgt1-month03.
    endif.
    read table it_tgtp1 into wa_tgtp1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-jun_ptgt = wa_tgtp1-month03.
    endif.

    read table it_netvalp3 into  wa_netvalp1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-jun_pval = wa_netvalp1-netval.
    endif.
    read table it_netval3 into  wa_netval1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-jun_val = wa_netval1-netval.
    endif.
    collect wa_sumfin into it_tabsum.
    clear wa_sumfin.
    clear : wa_zdsmter2 , wa_netvalp1 , wa_netval1.
  endloop.

  if currmth > 3 and currmth < 7.
    mmth1 = currmth.
  else.
    mmth1 = 7.
  endif.
  loop at it_zdsmter2 into wa_zdsmter2 where zmonth = mmth1.
    wa_sumfin-bzirk   = wa_zdsmter2-zdsm.
    read table it_tgt1 into wa_tgt1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-jul_tgt = wa_tgt1-month04.
    endif.
    read table it_tgtp1 into wa_tgtp1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-jul_ptgt = wa_tgtp1-month04.
    endif.

    read table it_netvalp4 into  wa_netvalp1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-jul_pval = wa_netvalp1-netval.
    endif.
    read table it_netval4 into  wa_netval1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-jul_val = wa_netval1-netval.
    endif.
    collect wa_sumfin into it_tabsum.
    clear wa_sumfin.
    clear : wa_zdsmter2 , wa_netvalp1 , wa_netval1.
  endloop.

  if currmth > 3 and currmth < 8.
    mmth1 = currmth.
  else.
    mmth1 = 8.
  endif.
  loop at it_zdsmter2 into wa_zdsmter2 where zmonth = mmth1.
    wa_sumfin-bzirk   = wa_zdsmter2-zdsm.
    read table it_tgt1 into wa_tgt1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-aug_tgt = wa_tgt1-month05.
    endif.
    read table it_tgtp1 into wa_tgtp1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-aug_ptgt = wa_tgtp1-month05.
    endif.

    read table it_netvalp5 into  wa_netvalp1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-aug_pval = wa_netvalp1-netval.
    endif.
    read table it_netval5 into  wa_netval1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-aug_val = wa_netval1-netval.
    endif.
    collect wa_sumfin into it_tabsum.
    clear wa_sumfin.
    clear : wa_zdsmter2 , wa_netvalp1 , wa_netval1.
  endloop.

  if currmth > 3 and currmth < 9.
    mmth1 = currmth.
  else.
    mmth1 = 9.
  endif.
  loop at it_zdsmter2 into wa_zdsmter2 where zmonth = mmth1.
    wa_sumfin-bzirk   = wa_zdsmter2-zdsm.
    read table it_tgt1 into wa_tgt1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-sep_tgt = wa_tgt1-month06.
    endif.
    read table it_tgtp1 into wa_tgtp1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-sep_ptgt = wa_tgtp1-month06.
    endif.

    read table it_netvalp6 into  wa_netvalp1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-sep_pval = wa_netvalp1-netval.
    endif.
    read table it_netval6 into  wa_netval1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-sep_val = wa_netval1-netval.
    endif.
    collect wa_sumfin into it_tabsum.
    clear wa_sumfin.
    clear : wa_zdsmter2 , wa_netvalp1 , wa_netval1.
  endloop.

  if currmth > 3 and currmth < 10.
    mmth1 = currmth.
  else.
    mmth1 = 10.
  endif.
  loop at it_zdsmter2 into wa_zdsmter2 where zmonth = mmth1.
    wa_sumfin-bzirk   = wa_zdsmter2-zdsm.
    read table it_tgt1 into wa_tgt1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-oct_tgt = wa_tgt1-month07.
    endif.
    read table it_tgtp1 into wa_tgtp1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-oct_ptgt = wa_tgtp1-month07.
    endif.

    read table it_netvalp7 into  wa_netvalp1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-oct_pval = wa_netvalp1-netval.
    endif.
    read table it_netval7 into  wa_netval1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-oct_val = wa_netval1-netval.
    endif.
    collect wa_sumfin into it_tabsum.
    clear wa_sumfin.
    clear : wa_zdsmter2 , wa_netvalp1 , wa_netval1.
  endloop.

  if currmth > 3 and currmth < 11.
    mmth1 = currmth.
  else.
    mmth1 = 11.
  endif.
  loop at it_zdsmter2 into wa_zdsmter2 where zmonth = mmth1.
    wa_sumfin-bzirk   = wa_zdsmter2-zdsm.
    read table it_tgt1 into wa_tgt1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-nov_tgt = wa_tgt1-month08.
    endif.
    read table it_tgtp1 into wa_tgtp1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-nov_ptgt = wa_tgtp1-month08.
    endif.

    read table it_netvalp8 into  wa_netvalp1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-nov_pval = wa_netvalp1-netval.
    endif.
    read table it_netval8 into  wa_netval1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-nov_val = wa_netval1-netval.
    endif.
    collect wa_sumfin into it_tabsum.
    clear wa_sumfin.
    clear : wa_zdsmter2 , wa_netvalp1 , wa_netval1.
  endloop.

  if currmth > 3 and currmth < 12.
    mmth1 = currmth.
  else.
    mmth1 = 12.
  endif.
  loop at it_zdsmter2 into wa_zdsmter2 where zmonth = mmth1.
    wa_sumfin-bzirk   = wa_zdsmter2-zdsm.
    read table it_tgt1 into wa_tgt1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-dec_tgt = wa_tgt1-month09.
    endif.
    read table it_tgtp1 into wa_tgtp1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-dec_ptgt = wa_tgtp1-month09.
    endif.

    read table it_netvalp9 into  wa_netvalp1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-dec_pval = wa_netvalp1-netval.
    endif.
    read table it_netval9 into  wa_netval1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-dec_val = wa_netval1-netval.
    endif.
    collect wa_sumfin into it_tabsum.
    clear wa_sumfin.
    clear : wa_zdsmter2 , wa_netvalp1 , wa_netval1.
  endloop.

  if  currmth >= 1 and currmth < 4 .
    mmth1 = 1.
  else.
    mmth1 = currmth.
  endif.
  loop at it_zdsmter2 into wa_zdsmter2 where zmonth = mmth1.
    wa_sumfin-bzirk   = wa_zdsmter2-zdsm.
    read table it_tgt1 into wa_tgt1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-jan_tgt = wa_tgt1-month10.
    endif.
    read table it_tgtp1 into wa_tgtp1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-jan_ptgt = wa_tgtp1-month10.
    endif.

    read table it_netvalp10 into  wa_netvalp1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-jan_pval = wa_netvalp1-netval.
    endif.
    read table it_netval10 into  wa_netval1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-jan_val = wa_netval1-netval.
    endif.
    collect wa_sumfin into it_tabsum.
    clear wa_sumfin.
    clear : wa_zdsmter2 , wa_netvalp1 , wa_netval1.
  endloop.

  if  currmth >= 2 and currmth < 4 .
    mmth1 = 2.
  else.
    mmth1 = currmth.
  endif.
  loop at it_zdsmter2 into wa_zdsmter2 where zmonth = mmth1.
    wa_sumfin-bzirk   = wa_zdsmter2-zdsm.
    read table it_tgt1 into wa_tgt1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-feb_tgt = wa_tgt1-month11.
    endif.
    read table it_tgtp1 into wa_tgtp1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-feb_ptgt = wa_tgtp1-month11.
    endif.

    read table it_netvalp11 into  wa_netvalp1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-feb_pval = wa_netvalp1-netval.
    endif.
    read table it_netval11 into  wa_netval1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-feb_val = wa_netval1-netval.
    endif.
    collect wa_sumfin into it_tabsum.
    clear wa_sumfin.
    clear : wa_zdsmter2 , wa_netvalp1 , wa_netval1.
  endloop.

  if  currmth = 3.
    mmth1 = 3.
  else.
    mmth1 = currmth.
  endif.
  loop at it_zdsmter2 into wa_zdsmter2 where zmonth = mmth1.
    wa_sumfin-bzirk   = wa_zdsmter2-zdsm.
    read table it_tgt1 into wa_tgt1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-mar_tgt = wa_tgt1-month12.
    endif.
    read table it_tgtp1 into wa_tgtp1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-mar_ptgt = wa_tgtp1-month12.
    endif.

    read table it_netvalp12 into  wa_netvalp1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-mar_pval = wa_netvalp1-netval.
    endif.
    read table it_netval12 into  wa_netval1 with key bzirk = wa_zdsmter2-bzirk.
    if sy-subrc = 0.
      wa_sumfin-mar_val = wa_netval1-netval.
    endif.
    collect wa_sumfin into it_tabsum.
    clear wa_sumfin.
    clear : wa_zdsmter2 , wa_netvalp1 , wa_netval1.
  endloop.

  clear : wa_tabsum, it_ztotpso, wa_ztotpso.
  c_date = pdate.
  c_date+6(2) = '01'.
  c_date+4(2) = '04'.
  select *  from ztotpso into table it_ztotpso
        for all entries in it_sumfin
            where   bzirk = it_sumfin-bzirk and begda >= c_date and begda <= mdate.

  loop at it_tabsum into wa_sumfin.
    clear : wa_tabsum, it_ztotpso, wa_ztotpso.
    c_date = pdate.
    c_date+6(2) = '01'.
    c_date+4(2) = '04'.
    select *  from ztotpso into table it_ztotpso
          for all entries in it_sumfin
              where   bzirk = it_sumfin-bzirk and begda >= c_date and begda <= mdate.

    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_sumfin-bzirk  begda = c_date.
    if sy-subrc = 0.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc + wa_ztotpso-xl + wa_ztotpso-ls - wa_ztotpso-hbe.
    endif.
    if wa_sumfin-apr_pval > 0 and mtotpso > 0.
      wa_sumfin-papr_ypm = ( wa_sumfin-apr_pval / mtotpso ).
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_sumfin-bzirk  begda = c_date.
    if sy-subrc = 0.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc + wa_ztotpso-xl + wa_ztotpso-ls - wa_ztotpso-hbe.
    endif.
    if wa_sumfin-may_pval > 0 and mtotpso > 0.
      wa_sumfin-pmay_ypm = ( wa_sumfin-may_pval / mtotpso ).
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_sumfin-bzirk  begda = c_date.
    if sy-subrc = 0.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc + wa_ztotpso-xl + wa_ztotpso-ls - wa_ztotpso-hbe.
    endif.
    if wa_sumfin-jun_pval > 0 and mtotpso > 0.
      wa_sumfin-pjun_ypm = ( wa_sumfin-jun_pval / mtotpso ).
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_sumfin-bzirk  begda = c_date.
    if sy-subrc = 0.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc + wa_ztotpso-xl + wa_ztotpso-ls - wa_ztotpso-hbe.
    endif.
    if wa_sumfin-jul_pval > 0 and mtotpso > 0.
      wa_sumfin-pjul_ypm = ( wa_sumfin-jul_pval / mtotpso ).
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_sumfin-bzirk  begda = c_date.
    if sy-subrc = 0.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc + wa_ztotpso-xl + wa_ztotpso-ls - wa_ztotpso-hbe.
    endif.
    if wa_sumfin-aug_pval > 0 and mtotpso > 0.
      wa_sumfin-paug_ypm = ( wa_sumfin-aug_pval / mtotpso ).
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_sumfin-bzirk  begda = c_date.
    if sy-subrc = 0.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc + wa_ztotpso-xl + wa_ztotpso-ls - wa_ztotpso-hbe.
    endif.
    if wa_sumfin-sep_pval > 0 and mtotpso > 0.
      wa_sumfin-psep_ypm = ( wa_sumfin-sep_pval / mtotpso ).
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_sumfin-bzirk  begda = c_date.
    if sy-subrc = 0.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc + wa_ztotpso-xl + wa_ztotpso-ls - wa_ztotpso-hbe.
    endif.
    if wa_sumfin-oct_pval > 0 and mtotpso > 0.
      wa_sumfin-poct_ypm = ( wa_sumfin-oct_pval / mtotpso ).
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_sumfin-bzirk  begda = c_date.
    if sy-subrc = 0.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc + wa_ztotpso-xl + wa_ztotpso-ls - wa_ztotpso-hbe.
    endif.
    if wa_sumfin-nov_pval > 0 and mtotpso > 0.
      wa_sumfin-pnov_ypm = ( wa_sumfin-nov_pval / mtotpso ).
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_sumfin-bzirk  begda = c_date.
    if sy-subrc = 0.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc + wa_ztotpso-xl + wa_ztotpso-ls - wa_ztotpso-hbe.
    endif.
    if wa_sumfin-dec_pval > 0 and mtotpso > 0.
      wa_sumfin-pdec_ypm = ( wa_sumfin-dec_pval / mtotpso ).
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_sumfin-bzirk  begda = c_date.
    if sy-subrc = 0.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc + wa_ztotpso-xl + wa_ztotpso-ls - wa_ztotpso-hbe.
    endif.
    if wa_sumfin-jan_pval > 0 and mtotpso > 0.
      wa_sumfin-pjan_ypm = ( wa_sumfin-jan_pval / mtotpso ).
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.

    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_sumfin-bzirk  begda = c_date.
    if sy-subrc = 0.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc + wa_ztotpso-xl + wa_ztotpso-ls - wa_ztotpso-hbe.
    endif.
    if wa_sumfin-feb_pval > 0 and mtotpso > 0.
      wa_sumfin-pfeb_ypm = ( wa_sumfin-feb_pval / mtotpso ).
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_sumfin-bzirk  begda = c_date.
    if sy-subrc = 0.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc + wa_ztotpso-xl + wa_ztotpso-ls - wa_ztotpso-hbe.
    endif.
    if wa_sumfin-mar_pval > 0 and mtotpso > 0.
      wa_sumfin-pmar_ypm = ( wa_sumfin-mar_pval / mtotpso ).
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.

****************MASUMA
    write : /1 'CURRENT YEAR YPM', c_date.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_sumfin-bzirk  begda = c_date.
    if sy-subrc = 0.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc + wa_ztotpso-xl + wa_ztotpso-ls - wa_ztotpso-hbe.
    endif.
    if wa_sumfin-apr_val > 0 and mtotpso > 0.
      wa_sumfin-apr_ypm = ( wa_sumfin-apr_val / mtotpso ).
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_sumfin-bzirk  begda = c_date.
    if sy-subrc = 0.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc + wa_ztotpso-xl + wa_ztotpso-ls - wa_ztotpso-hbe.
    endif.
    if wa_sumfin-may_val > 0 and mtotpso > 0.
      wa_sumfin-may_ypm = ( wa_sumfin-may_val / mtotpso ).
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_sumfin-bzirk  begda = c_date.
    if sy-subrc = 0.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc + wa_ztotpso-xl + wa_ztotpso-ls - wa_ztotpso-hbe.
    endif.
    if wa_sumfin-jun_val > 0 and mtotpso > 0.
      wa_sumfin-jun_ypm = ( wa_sumfin-jun_val / mtotpso ).
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_sumfin-bzirk  begda = c_date.
    if sy-subrc = 0.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc + wa_ztotpso-xl + wa_ztotpso-ls - wa_ztotpso-hbe.
    endif.
    if wa_sumfin-jul_val > 0 and mtotpso > 0.
      wa_sumfin-jul_ypm = ( wa_sumfin-jul_val / mtotpso ).
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_sumfin-bzirk  begda = c_date.
    if sy-subrc = 0.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc + wa_ztotpso-xl + wa_ztotpso-ls - wa_ztotpso-hbe.
    endif.
    if wa_sumfin-aug_val > 0 and mtotpso > 0.
      wa_sumfin-aug_ypm = ( wa_sumfin-aug_val / mtotpso ).
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_sumfin-bzirk  begda = c_date.
    if sy-subrc = 0.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc + wa_ztotpso-xl + wa_ztotpso-ls - wa_ztotpso-hbe.
    endif.
    if wa_sumfin-sep_val > 0 and mtotpso > 0.
      wa_sumfin-sep_ypm = ( wa_sumfin-sep_val / mtotpso ).
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_sumfin-bzirk  begda = c_date.
    if sy-subrc = 0.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc + wa_ztotpso-xl + wa_ztotpso-ls - wa_ztotpso-hbe.
    endif.
    if wa_sumfin-oct_val > 0 and mtotpso > 0.
      wa_sumfin-oct_ypm = ( wa_sumfin-oct_val / mtotpso ).
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_sumfin-bzirk  begda = c_date.
    if sy-subrc = 0.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc + wa_ztotpso-xl + wa_ztotpso-ls - wa_ztotpso-hbe.
    endif.
    if wa_sumfin-nov_val > 0 and mtotpso > 0.
      wa_sumfin-nov_ypm = ( wa_sumfin-nov_val / mtotpso ).
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_sumfin-bzirk  begda = c_date.
    if sy-subrc = 0.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc + wa_ztotpso-xl + wa_ztotpso-ls - wa_ztotpso-hbe.
    endif.
    if wa_sumfin-dec_val > 0 and mtotpso > 0.
      wa_sumfin-dec_ypm = ( wa_sumfin-dec_val / mtotpso ).
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_sumfin-bzirk  begda = c_date.
    if sy-subrc = 0.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc + wa_ztotpso-xl + wa_ztotpso-ls - wa_ztotpso-hbe.
    endif.
    if wa_sumfin-jan_val > 0 and mtotpso > 0.
      wa_sumfin-jan_ypm = ( wa_sumfin-jan_val / mtotpso ).
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.

    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_sumfin-bzirk  begda = c_date.
    if sy-subrc = 0.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc + wa_ztotpso-xl + wa_ztotpso-ls - wa_ztotpso-hbe.
    endif.
    if wa_sumfin-feb_val > 0 and mtotpso > 0.
      wa_sumfin-feb_ypm = ( wa_sumfin-feb_val / mtotpso ).
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_sumfin-bzirk  begda = c_date.
    if sy-subrc = 0.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc + wa_ztotpso-xl + wa_ztotpso-ls - wa_ztotpso-hbe.
    endif.
    if wa_sumfin-mar_val > 0 and mtotpso > 0.
      wa_sumfin-mar_ypm = ( wa_sumfin-mar_val / mtotpso ).
    endif.
    modify it_tabsum from wa_sumfin.
    clear : wa_sumfin.
  endloop.
  clear : wa_tabsum, it_ztotpso, wa_ztotpso.
endform.


form pyypmdata .

  data : cryrtotsale type p decimals 2.
  data : cryrtotpso(5) type c.

  c_date = pdate.
  c_date+6(2) = '01'.
  write : / pdate , mdate, 'to calculate p.y. ypm'.
  clear : it_ztotpso, wa_ztotpso.
  select *  from ztotpso into table it_ztotpso
      for all entries in it_tabfin
          where   bzirk = it_tabfin-bzirk and begda >= c_date and begda <= mdate.

  clear wa_tabfin.
  loop at it_tabfin into wa_tabfin.
    c_date = pdate.
    c_date+6(2) = '01'.
    cryrtotpso = 0.
    cryrtotsale = 0.
    mtotpso = 0.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_tabfin-bzirk  begda = c_date.
    if wa_tabfin-spart = '60'.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-xl - wa_ztotpso-hbe.
    elseif wa_tabfin-spart = '70'.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-ls - wa_ztotpso-hbe.
    else.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc - wa_ztotpso-hbe.
    endif.
    cryrtotpso = cryrtotpso + mtotpso.
    cryrtotsale = cryrtotsale + wa_tabfin-apr_pgrosspts.
    if wa_tabfin-apr_pgrosspts > 0 and mtotpso > 0.

      wa_tabfin-papr_ypm = wa_tabfin-apr_pgrosspts / mtotpso.
    endif.
    modify it_tabfin from wa_tabfin.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
    mtotpso = 0.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_tabfin-bzirk  begda = c_date.
    if wa_tabfin-spart = '60'.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-xl - wa_ztotpso-hbe.
    elseif wa_tabfin-spart = '70'.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-ls - wa_ztotpso-hbe.
    else.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc - wa_ztotpso-hbe.
    endif.
    cryrtotpso = cryrtotpso + mtotpso.
    cryrtotsale = cryrtotsale + wa_tabfin-may_pgrosspts.
    if wa_tabfin-may_pgrosspts > 0 and mtotpso > 0.
      wa_tabfin-pmay_ypm =  wa_tabfin-may_pgrosspts / mtotpso .
    endif.

    modify it_tabfin from wa_tabfin.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
*    WRITE : /1 C_DATE, 'JUN'.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_tabfin-bzirk  begda = c_date.
    if wa_tabfin-spart = '60'.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-xl - wa_ztotpso-hbe.
    elseif wa_tabfin-spart = '70'.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-ls - wa_ztotpso-hbe.
    else.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc - wa_ztotpso-hbe.
    endif.
    cryrtotpso = cryrtotpso + mtotpso.
    cryrtotsale = cryrtotsale + wa_tabfin-jun_pgrosspts.
    if wa_tabfin-jun_pgrosspts > 0 and mtotpso > 0.
      wa_tabfin-pjun_ypm =  wa_tabfin-jun_pgrosspts / mtotpso.
    endif.

    modify it_tabfin from wa_tabfin.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
*    WRITE : /1 C_DATE, 'JUL'.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_tabfin-bzirk  begda = c_date.
    if wa_tabfin-spart = '60'.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-xl - wa_ztotpso-hbe.
    elseif wa_tabfin-spart = '70'.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-ls - wa_ztotpso-hbe.
    else.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc - wa_ztotpso-hbe.
    endif.
    cryrtotpso = cryrtotpso + mtotpso.
    cryrtotsale = cryrtotsale + wa_tabfin-jul_pgrosspts.
    if wa_tabfin-jul_pgrosspts > 0 and mtotpso > 0.
      wa_tabfin-pjul_ypm =  wa_tabfin-jul_pgrosspts / mtotpso .
    endif.

    modify it_tabfin from wa_tabfin.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
*    WRITE : /1 C_DATE, 'AUG' .
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_tabfin-bzirk  begda = c_date.
    if wa_tabfin-spart = '60'.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-xl - wa_ztotpso-hbe.
    elseif wa_tabfin-spart = '70'.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-ls - wa_ztotpso-hbe.
    else.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc - wa_ztotpso-hbe.
    endif.
    cryrtotpso = cryrtotpso + mtotpso.
    cryrtotsale = cryrtotsale + wa_tabfin-aug_pgrosspts.
    if wa_tabfin-aug_pgrosspts > 0 and mtotpso > 0.
      wa_tabfin-paug_ypm = ( wa_tabfin-aug_pgrosspts / mtotpso ).
    endif.

    modify it_tabfin from wa_tabfin.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
*    WRITE : /1 C_DATE, 'SEP'.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_tabfin-bzirk  begda = c_date.
    if wa_tabfin-spart = '60'.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-xl - wa_ztotpso-hbe.
    elseif wa_tabfin-spart = '70'.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-ls - wa_ztotpso-hbe.
    else.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc - wa_ztotpso-hbe.
    endif.
    cryrtotpso = cryrtotpso + mtotpso.
    cryrtotsale = cryrtotsale + wa_tabfin-sep_pgrosspts.
    if wa_tabfin-sep_pgrosspts > 0 and mtotpso > 0.
      wa_tabfin-psep_ypm = ( wa_tabfin-sep_pgrosspts / mtotpso ).
    endif.

    modify it_tabfin from wa_tabfin.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
*    WRITE : /1 C_DATE, 'OCT'.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_tabfin-bzirk  begda = c_date.
    if wa_tabfin-spart = '60'.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-xl - wa_ztotpso-hbe.
    elseif wa_tabfin-spart = '70'.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-ls - wa_ztotpso-hbe.
    else.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc - wa_ztotpso-hbe.
    endif.
    cryrtotpso = cryrtotpso + mtotpso.
    cryrtotsale = cryrtotsale + wa_tabfin-oct_pgrosspts.
    if wa_tabfin-oct_pgrosspts > 0 and mtotpso > 0.
      wa_tabfin-poct_ypm = ( wa_tabfin-oct_pgrosspts / mtotpso ).
    endif.

    modify it_tabfin from wa_tabfin.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
*    WRITE : /1 C_DATE, 'NOV'.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_tabfin-bzirk  begda = c_date.
    if wa_tabfin-spart = '60'.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-xl - wa_ztotpso-hbe.
    elseif wa_tabfin-spart = '70'.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-ls - wa_ztotpso-hbe.
    else.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc - wa_ztotpso-hbe.
    endif.
    cryrtotpso = cryrtotpso + mtotpso.
    cryrtotsale = cryrtotsale + wa_tabfin-nov_pgrosspts.
    if wa_tabfin-nov_pgrosspts > 0 and mtotpso > 0.
      wa_tabfin-pnov_ypm = ( wa_tabfin-nov_pgrosspts / mtotpso ).
    endif.

    modify it_tabfin from wa_tabfin.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
*    WRITE : /1 C_DATE, 'DEC'.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_tabfin-bzirk  begda = c_date.
    if wa_tabfin-spart = '60'.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-xl - wa_ztotpso-hbe.
    elseif wa_tabfin-spart = '70'.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-ls - wa_ztotpso-hbe.
    else.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc - wa_ztotpso-hbe.
    endif.
    cryrtotpso = cryrtotpso + mtotpso.
    cryrtotsale = cryrtotsale + wa_tabfin-dec_pgrosspts.
    if wa_tabfin-dec_pgrosspts > 0 and mtotpso > 0.
      wa_tabfin-pdec_ypm = ( wa_tabfin-dec_pgrosspts / mtotpso ).
    endif.

    modify it_tabfin from wa_tabfin.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
*    WRITE : /1 C_DATE, 'JAN'.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_tabfin-bzirk  begda = c_date.
    if wa_tabfin-spart = '60'.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-xl - wa_ztotpso-hbe.
    elseif wa_tabfin-spart = '70'.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-ls - wa_ztotpso-hbe.
    else.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc - wa_ztotpso-hbe.
    endif.
    cryrtotpso = cryrtotpso + mtotpso.
    cryrtotsale = cryrtotsale + wa_tabfin-jan_pgrosspts.
    if wa_tabfin-jan_pgrosspts > 0 and mtotpso > 0.
      wa_tabfin-pjan_ypm = ( wa_tabfin-jan_pgrosspts / mtotpso ).
    endif.

    modify it_tabfin from wa_tabfin.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
*    WRITE : /1 C_DATE, 'FEB'.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_tabfin-bzirk  begda = c_date.
    if wa_tabfin-spart = '60'.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-xl - wa_ztotpso-hbe.
    elseif wa_tabfin-spart = '70'.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-ls - wa_ztotpso-hbe.
    else.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc - wa_ztotpso-hbe.
    endif.
    cryrtotpso = cryrtotpso + mtotpso.
    cryrtotsale = cryrtotsale + wa_tabfin-feb_pgrosspts.
    if wa_tabfin-feb_pgrosspts > 0 and mtotpso > 0.
      wa_tabfin-pfeb_ypm = ( wa_tabfin-feb_pgrosspts / mtotpso ).
    endif.

    modify it_tabfin from wa_tabfin.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
*    WRITE : /1 C_DATE, 'MAR'.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_tabfin-bzirk  begda = c_date.
    mtotpso = 0.
    if wa_tabfin-spart = '60'.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-xl - wa_ztotpso-hbe.
    elseif wa_tabfin-spart = '70'.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-ls - wa_ztotpso-hbe.
    else.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc - wa_ztotpso-hbe.
    endif.
    cryrtotpso = cryrtotpso + mtotpso.
    cryrtotsale = cryrtotsale + wa_tabfin-mar_pgrosspts.
    if wa_tabfin-mar_pgrosspts > 0 and mtotpso > 0.
      wa_tabfin-pmar_ypm = ( wa_tabfin-mar_pgrosspts / mtotpso ).
    endif.

    if cryrtotpso > 0 and cryrtotsale > 0.
      wa_tabfin-pavg_ypm = ( cryrtotsale / cryrtotpso ).
    endif.
    modify it_tabfin from wa_tabfin.
*    collect wa_tabFIN into it_tabFIN.
    clear wa_tabfin.
  endloop.
endform.
