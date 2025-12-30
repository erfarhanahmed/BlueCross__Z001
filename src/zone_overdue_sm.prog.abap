*&---------------------------------------------------------------------*
*& Report  ZONE_OD1
*&DEVELOPED BY JYOTSNA.
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

report  zone_od11 no standard page heading line-size 300.
tables : zdsmter,
         bsas,
         mara,
         kna1,
         pa0001,
         yterrallc,
         pa0105,
         zthr_heq_des,
         zdrphq,
         tvfkt,
         t003t,
         bkpf.

type-pools:  slis.

data: g_repid     like sy-repid,
      fieldcat    type slis_t_fieldcat_alv,
      wa_fieldcat like line of fieldcat,
      sort        type slis_t_sortinfo_alv,
      wa_sort     like line of sort,
      layout      type slis_layout_alv.

types : begin of typ_konv,
          knumv type prcd_elements-knumv,
          kposn type prcd_elements-kposn,
          kschl type prcd_elements-kschl,
          kwert type prcd_elements-kwert,
        end of typ_konv.

data :it_zdsmter1        type table of zdsmter,
      wa_zdsmter1        type zdsmter,
      it_zdsmter         type table of zdsmter,
      wa_zdsmter         type zdsmter,
      it_ysd_cus_div_dis type table of ysd_cus_div_dis,
      wa_ysd_cus_div_dis type ysd_cus_div_dis,
      it_bsid            type table of bsid,
      wa_bsid            type bsid,
      it_kna1            type table of kna1,
      wa_kna1            type kna1,
      it_vbrk            type table of vbrk,
      wa_vbrk            type vbrk,
      it_vbrp            type table of vbrp,
      wa_vbrp            type vbrp,
      it_konv            type table of typ_konv,
      wa_konv            type typ_konv,
      it_yterrallc       type table of yterrallc,
      wa_yterrallc       type yterrallc.

types : begin of itab1,
          sm      type zdsmter-zdsm,
          reg     type zdsmter-zdsm,
          spart   type zdsmter-spart,
          zm      type zdsmter-bzirk,
          rm      type zdsmter-bzirk,
          bzirk   type zdsmter-bzirk,
          text(9) type c,
          val     type p,
        end of itab1.

types : begin of itac3,
          bzirk  type ysd_cus_div_dis-bzirk,
          kunnr  type ysd_cus_div_dis-kunnr,
          spart  type ysd_cus_div_dis-spart,
          percnt type ysd_cus_div_dis-percnt,
        end of   itac3.

types : begin of itab3,
          reg       type zdsmter-bzirk,
          dmbtr     type bsid-dmbtr,
          kunnr     type bsid-kunnr,
          belnr     type bsid-belnr,
          vbeln     type bsid-vbeln,
          zfbdt     type bsid-zfbdt,
          shkzg     type bsid-shkzg,
          rebzg     type bsid-rebzg,
          rebzj     type bsid-rebzj,
          zfbdt1    type bsas-zfbdt,
          l_date_1  type bsas-zfbdt,
          l_date1_1 type bsas-zfbdt,
          gjahr     type bsis-gjahr,
        end of itab3.

types : begin of itab4,
          reg       type zdsmter-bzirk,
          kunnr     type bsid-kunnr,
          dmbtr     type p,
          belnr     type bsid-belnr,
          vbeln     type bsid-vbeln,
          zfbdt     type bsid-zfbdt,
          shkzg     type bsid-shkzg,
          rebzg     type bsid-rebzg,
          rebzj     type bsid-rebzj,
          zfbdt1    type bsas-zfbdt,
          l_date_1  type bsas-zfbdt,
          l_date1_1 type bsas-zfbdt,
          fkdat     type vbrk-fkdat,
          bcpts     type p,
          xlpts     type p,
          ls_pts     type p,
          name1     type kna1-name1,
          ort01     type kna1-ort01,
          fkart     type vbrk-fkart,
          val       type p,
          remark(7) type c,
*  fkart TYPE vbrk-fkart,
          vtext     type tvfkt-vtext,
          gjahr     type bsis-gjahr,
        end of itab4.

types : begin of itas1,
          vbeln  type vbrp-vbeln,
          fkdat  type vbrk-fkdat,
          bcpts  type p,
          xlpts  type p,
          ls_pts type p,
          val    type p,
          fkart  type vbrk-fkart,
        end of itas1.

types : begin of itas2,
          vbeln type vbrp-vbeln,
          fkdat type vbrk-fkdat,
          bcpts type p,
          xlpts type p,
          fkart type vbrk-fkart,
        end of itas2.

types : begin of itap1,
          reg          type yterrallc-bzirk,
          zm_name      type pa0001-ename,
          w_usrid_long type pa0105-usrid_long,
          zm_hqdesc    type zthr_heq_des-zz_hqdesc,
        end of itap1.

types : begin of itap2,
          reg          type yterrallc-bzirk,
          w_usrid_long type pa0105-usrid_long,
        end of itap2.

data : it_tab1  type table of itab1,
       wa_tab1  type itab1,
       it_tab2  type table of itab1,
       wa_tab2  type itab1,
       it_tac1  type table of itab1,
       wa_tac1  type itab1,
       it_tac2  type table of itab1,
       wa_tac2  type itab1,
       it_tac3  type table of itac3,
       wa_tac3  type itac3,
       it_tac4  type table of itac3,
       wa_tac4  type itac3,
       it_tab3  type table of itab3,
       wa_tab3  type itab3,
       it_tab4  type table of itab4,
       wa_tab4  type itab4,
       it_tab41 type table of itab4,
       wa_tab41 type itab4,
       it_tas1  type table of itas1,
       wa_tas1  type itas1,
       it_tas2  type table of itas2,
       wa_tas2  type itas2,
       it_tap1  type table of itap1,
       wa_tap1  type itap1,
       it_tap2  type table of itap2,
       wa_tap2  type itap2.

types : begin of sm1,
          sm  type zdsmter-zdsm,
          reg type zdsmter-zdsm,
        end of sm1.

types : begin of sm2,
          sm  type zdsmter-zdsm,
          reg type zdsmter-zdsm,
          zm  type zdsmter-zdsm,
          rm  type zdsmter-zdsm,
        end of sm2.


data: it_sm1 type table of sm1,
      wa_sm1 type sm1,
      it_sm2 type table of sm2,
      wa_sm2 type sm2.

data : msg       type string,
       month(2)  type c,
       year(4)   type c,
       date1     type sy-datum,
       date2     type sy-datum,
       l_date1_1 type sy-datum,
       l_date_1  type bsas-zfbdt,
       bcpts     type p,
       xlpts     type p,
       ls_pts    type p,
       val       type p,
       count     type i.

data : tot_val type p,
       tot_bc  type p,
       tot_xl  type p,
       tot_ls  type p,
       tot_due type p,
       t_val   type p,
       t_bc    type p,
       t_xl    type p,
       t_ls    type p,
       t_due   type p,
       to_val  type p,
       to_bc   type p,
       to_xl   type p,
       to_ls   type p,
       to_due  type p,
       tot     type p.
data: smemailid type pa0105-usrid_long.
data : w_usrid_long type pa0105-usrid_long,
       zm_name      type pa0001-ename,
       zm_hqdesc    type  zthr_heq_des-zz_hqdesc.
data : options        type itcpo,
       l_otf_data     like itcoo occurs 10,
       l_asc_data     like tline occurs 10,
       l_docs         like docs  occurs 10,
       l_pdf_data     like solisti1 occurs 10,
       l_pdf_data1    like solisti1 occurs 10,
       l_bin_filesize type i.
data :  result      like  itcpp.
data: docdata like solisti1  occurs  10,
      objhead like solisti1  occurs  1,
      objbin1 like solisti1  occurs 10,
      objbin  like solisti1  occurs 10.
data: listobject like abaplist  occurs  1 .
data: doc_chng like sodocchgi1.
data reclist    like somlreci1  occurs  1 with header line.
data mcount type i.
data : v_werks type werks_d.
data : v_text(70) type c.
data: ltx like t247-ltx.

data : usrid_long like pa0105-usrid_long.
*data : w_usrid_long type pa0105-usrid_long.
data righe_attachment type i.
data righe_testo type i.
data tab_lines type i.
data  begin of objpack occurs 0 .
        include structure  sopcklsti1.
data end of objpack.

data begin of objtxt occurs 0.
        include structure solisti1.
data end of objtxt.
data: v_msg(125) type c.
data : page1 type i value 1,
       page2 type i,
       page3 type i.
*DATA: LMDATE1 TYPE SY-DATUM.


selection-screen begin of block b1 with frame title text-001.
*parameter : zone like zdsmter-zdsm matchcode object zsr9_1 obligatory.
select-options : zone for zdsmter-zdsm matchcode object zsr9_1 .
*parameter : amt type vbrp-netwr default  '500' NO-DISPLAY.
parameter : amt type vbrp-netwr no-display.
parameter : p1 as checkbox.


parameter : r1 radiobutton group r1,
            r2 radiobutton group r1,
            r3 radiobutton group r1,
            r4 radiobutton group r1.
parameter : uemail(70) type c.
parameters : sm like zdsmter-zdsm matchcode object zsr9_5 .
parameters : r7 radiobutton group r1,
             r5 radiobutton group r1,
             r6 radiobutton group r1.

selection-screen end of block b1.

initialization.
  g_repid = sy-repid.

at selection-screen.



  if r5 eq 'X' or r6 eq 'X' or r7 eq 'X'.

    select * from zdsmter into table it_zdsmter1 where zdsm eq sm and zmonth eq sy-datum+4(2) and zyear eq sy-datum+0(4).


    loop at it_zdsmter1 into wa_zdsmter1.
      authority-check object 'ZON1_1'  id 'ZDSM' field wa_zdsmter1-bzirk.
      if sy-subrc <> 0.
        concatenate 'No authorization for Zone' wa_zdsmter1-zdsm into msg
        separated by space.
        message msg type 'E'.
      endif.
    endloop.

  else.

    select * from zdsmter into table it_zdsmter1 where zdsm in zone and zmonth eq sy-datum+4(2) and zyear eq sy-datum+0(4).


    loop at it_zdsmter1 into wa_zdsmter1.
      authority-check object 'ZON1_1'
             id 'ZDSM' field wa_zdsmter1-zdsm.
      if sy-subrc <> 0.
        concatenate 'No authorization for Zone' wa_zdsmter1-zdsm into msg
        separated by space.
        message msg type 'E'.
      endif.
    endloop.
    if r4 eq 'X'.
      if uemail eq '                                                                     '.
        message 'ENTER EMAIL ID' type 'E'.
      endif.
    endif.

  endif.

start-of-selection.

  if r5 eq 'X' or r6 eq 'X' or r7 eq 'X'.
    if sm is initial.
      message 'ENTER SM CODE' type 'E'.
    endif.
  else.
    if zone is initial.
      message 'ENTER ZONE' type 'E'.
    endif.
  endif.

  date1+6(2) = '01'.
  date1+4(2) = sy-datum+4(2).
  date1+0(4) = sy-datum+0(4).


  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date           = date1
    importing
*     EV_MONTH_BEGIN_DATE       =
      ev_month_end_date = date2.

  month = sy-datum+4(2).
  year = sy-datum+0(4).


  if r5 eq 'X' or r6 eq 'X' or r7 eq 'X'.
    select * from zdsmter into table it_zdsmter where zmonth eq month and zyear eq year .
*      AND ZDSM EQ SM.

  else.
    select * from zdsmter into table it_zdsmter where zmonth eq month and zyear eq year   and zdsm in zone.
  endif.


  if it_zdsmter is initial.
    exit.
  endif.

  if r5 eq 'X' or r6 eq 'X' or r7 eq 'X'.
    loop at it_zdsmter into wa_zdsmter where zdsm+0(2) cs 'G-' and bzirk+0(2) cs 'D-' and zdsm eq sm.
      wa_sm1-sm = wa_zdsmter-zdsm.
      wa_sm1-reg = wa_zdsmter-bzirk.
      collect wa_sm1 into it_sm1.
      clear wa_sm1.
    endloop.
    loop at it_sm1 into wa_sm1.
      loop at it_zdsmter into wa_zdsmter where zmonth = month and zyear = year and zdsm = wa_sm1-reg and bzirk+0(2) = 'R-'.
        wa_sm2-sm = wa_sm1-sm.
        wa_sm2-reg = wa_sm1-reg.
        wa_sm2-rm = wa_zdsmter-bzirk.
        read table it_zdsmter into wa_zdsmter with key zmonth = month zyear = year bzirk = wa_sm2-rm zdsm+0(2) = 'Z-'.
        if sy-subrc eq 0.
          wa_sm2-zm = wa_zdsmter-zdsm.
        endif.
        collect wa_sm2 into it_sm2.
        clear wa_sm2.
      endloop.
    endloop.
    loop at it_sm2 into wa_sm2.
      wa_tac1-sm = wa_sm2-sm.
      wa_tac1-reg = wa_sm2-reg.
      wa_tac1-zm = wa_sm2-zm.
      wa_tac1-rm = wa_sm2-rm.
      collect wa_tac1 into it_tac1.
      clear wa_tac1.
    endloop.

*    LOOP AT IT_TAC1 INTO WA_TAC1.
*      WA_TAC2-SM = WA_TAC1-SM.
*      WA_TAC2-REG = WA_TAC1-REG.
*      WA_TAC2-ZM = WA_TAC1-ZM.
*      WA_TAC2-RM = WA_TAC1-RM.
*      COLLECT WA_TAC1 INTO IT_TAC1.
*      CLEAR WA_TAC1.
*    ENDLOOP.

    loop at it_zdsmter into wa_zdsmter where zdsm+0(2) cs 'R-'.
      loop at it_tac1 into wa_tac1 where rm = wa_zdsmter-zdsm.
        wa_tac2-sm = wa_tac1-sm.
        wa_tac2-reg = wa_tac1-reg.
        wa_tac2-zm = wa_tac1-zm.
        wa_tac2-rm = wa_tac1-rm.
        wa_tac2-bzirk = wa_zdsmter-bzirk.
        wa_tac2-spart = wa_zdsmter-spart.
        collect wa_tac2 into it_tac2.
        clear wa_tac2.
      endloop.
    endloop.


  else.

    loop at it_zdsmter into wa_zdsmter where bzirk+0(2) cs 'Z-' .
*  or bzirk+0(2) cs 'R-'.
*  WRITE : / wa_zdsmter-bzirk.
      select * from zdsmter where zdsm eq wa_zdsmter-bzirk and zmonth eq month and zyear eq year.
        if sy-subrc eq 0.
*        WRITE : / 'RM',ZDSMTER-BZIRK,ZDSMTER-SPART.
          wa_tab1-reg = wa_zdsmter-zdsm.
*        wa_tab1-spart = wa_zdsmter-zdsmspart.
          wa_tab1-zm = wa_zdsmter-bzirk.
          wa_tab1-rm = zdsmter-bzirk.
          collect wa_tab1 into it_tab1.
          clear wa_tab1.
        endif.
      endselect.
    endloop.

    loop at it_tab1 into wa_tab1.
      wa_tab2-text = 'INDIRECT'.
      wa_tab2-reg = wa_tab1-reg.
      wa_tab2-spart = wa_tab1-spart.
      wa_tab2-zm = wa_tab1-zm.
      wa_tab2-rm = wa_tab1-rm.
      collect wa_tab2 into it_tab2.
      clear wa_tab2.
    endloop.

*****************************
*****************************
    loop at it_zdsmter into wa_zdsmter where bzirk+0(2) cs 'R-'.
      wa_tac1-reg = wa_zdsmter-zdsm.
      wa_tac1-rm = wa_zdsmter-bzirk.
      collect wa_tac1 into it_tac1.
      clear wa_tac1.
    endloop.

    loop at it_tac1 into wa_tac1.
      wa_tab2-text = 'DIRECT'.
      wa_tab2-reg = wa_tac1-reg.
      wa_tab2-rm = wa_tac1-rm.
      collect wa_tab2 into it_tab2.
      clear wa_tab2.
    endloop.

    loop at it_tab2 into wa_tab2.
      select * from zdsmter where zdsm eq wa_tab2-rm and zmonth eq month and zyear eq year.
        if sy-subrc eq 0.
*        WRITE : / '**',WA_TAb2-TEXT, 'reg',WA_tab2-REG,'zm',WA_tab2-ZM,'rm',WA_tab2-RM.
*        WRITE :  zdsmter-bzirk,zdsmter-spart.
*        wa_tac2-text = wa_tab2-text.
          wa_tac2-reg = wa_tab2-reg.
*        wa_tac2-zm = wa_tab2-zm.
          wa_tac2-rm = wa_tab2-rm.
          wa_tac2-bzirk = zdsmter-bzirk.
          wa_tac2-spart = zdsmter-spart.
          collect wa_tac2 into it_tac2.
          clear wa_tac2.
        endif.
      endselect.
    endloop.
  endif.

*  LOOP AT IT_TAC2 INTO WA_TAC2.
*    WRITE : / WA_TAC2-REG,WA_TAC2-RM,WA_TAC2-BZIRK,WA_TAC2-SPART.
*  ENDLOOP.

  if it_tac2 is not initial.
    select * from ysd_cus_div_dis into table it_ysd_cus_div_dis for all entries in it_tac2 where spart eq it_tac2-spart
      and bzirk eq it_tac2-bzirk  and begda le date1 and endda ge date2.
  endif.
  sort it_ysd_cus_div_dis by kunnr.
  loop at it_ysd_cus_div_dis into wa_ysd_cus_div_dis.
*  WRITE : / 'a',wa_ysd_cus_div_dis-bzirk,wa_ysd_cus_div_dis-kunnr,wa_ysd_cus_div_dis-spart,wa_ysd_cus_div_dis-percnt.
    wa_tac3-bzirk = wa_ysd_cus_div_dis-bzirk.
    wa_tac3-spart = wa_ysd_cus_div_dis-spart.
    wa_tac3-kunnr = wa_ysd_cus_div_dis-kunnr.
*    wa_tac3-percnt = wa_ysd_cus_div_dis-percnt.
    collect wa_tac3 into it_tac3.
    clear wa_tac3.
  endloop.
  sort it_tac3 by bzirk spart.
  loop at it_tac3 into wa_tac3.
*    WRITE : / 'kk',wa_tac3-bzirk,wa_tac3-spart,wa_tac3-kunnr,wa_tac3-percnt.
    wa_tac4-kunnr = wa_tac3-kunnr.
    collect wa_tac4 into it_tac4.
    clear wa_tac4.
  endloop.
  sort it_tac4 by  kunnr.
  delete adjacent duplicates from it_tac4.

  perform od.
  perform sale.

  loop at it_tab3 into wa_tab3 .
*    WRITE : / wa_tab3-kunnr, wa_tab3-dmbtr, wa_tab3-belnr,wa_tab3-VBELN,wa_tab3-ZFBDT,wa_tab3-rebzj,
*    'DUEDT',wa_tab3-l_date1_1.
    wa_tab41-reg = wa_tab3-reg.
    wa_tab41-kunnr = wa_tab3-kunnr.
    wa_tab41-dmbtr = wa_tab3-dmbtr.
    wa_tab41-belnr = wa_tab3-belnr.
    wa_tab41-gjahr = wa_tab3-gjahr.

    if wa_tab3-vbeln ne '          '.
      wa_tab41-vbeln = wa_tab3-vbeln.
    else.
      wa_tab41-vbeln = wa_tab3-belnr.
    endif.
    wa_tab41-zfbdt = wa_tab3-zfbdt.
    wa_tab41-rebzj = wa_tab3-rebzj.

*    if wa_tab3-dmbtr gt 0.
*      wa_tab41-l_date1_1 = wa_tab3-l_date1_1.
*    ENDIF.
*    if wa_tab3-l_date1_1 lt sy-datum AND wa_tab3-dmbtr gt 0.
*      wa_tab41-remark = 'OVERDUE'.
*    endif.
    read table it_tas1 into wa_tas1 with key vbeln = wa_tab3-vbeln.
    if sy-subrc eq 0.
*      WRITE : WA_TAS1-FKDAT,'BC',WA_TAS1-BCPTS,'XL',WA_TAS1-XLPTS.
      wa_tab41-fkdat = wa_tas1-fkdat.
      wa_tab41-fkart = wa_tas1-fkart.

      if wa_tas1-fkart eq 'ZCDF' or wa_tas1-fkart eq 'ZBDF'.
        if wa_tab3-dmbtr gt 0.
          wa_tab41-l_date1_1 = wa_tab3-l_date1_1.
        endif.
        if wa_tab3-l_date1_1 lt sy-datum and wa_tab3-dmbtr gt 0.
          wa_tab41-remark = 'OVERDUE'.
        elseif wa_tab3-l_date1_1 eq sy-datum and wa_tab3-dmbtr gt 0.
          wa_tab41-remark = 'DUE'.
        endif.
      endif.

      wa_tab41-bcpts = wa_tas1-bcpts.
      wa_tab41-xlpts = wa_tas1-xlpts.
      wa_tab41-ls_pts = wa_tas1-ls_pts.
*************dov type****************
      select single * from tvfkt where spras eq 'EN' and fkart eq wa_tas1-fkart.
      if sy-subrc eq 0.
        wa_tab41-vtext = tvfkt-vtext.
*        WRITE : TVFKT-VTEXT.
      endif.
****************************************
      wa_tab41-val = wa_tas1-val.
    else.
      select single * from bkpf where bukrs eq 'BCLL' and belnr eq wa_tab3-belnr and gjahr eq wa_tab3-gjahr.
      if sy-subrc eq 0.
        wa_tab41-fkart = bkpf-blart.
        select single * from t003t where spras eq 'EN' and blart eq bkpf-blart.
        if sy-subrc eq 0.
          wa_tab41-vtext = t003t-ltext.
        endif.
      endif.
    endif.
    select single * from kna1 where kunnr eq wa_tab3-kunnr.
    if sy-subrc eq 0.
      wa_tab41-name1 = kna1-name1.
      wa_tab41-ort01 = kna1-ort01.
    endif.

    collect wa_tab41 into it_tab41.
    clear wa_tab41.
  endloop.

  loop at it_tab41 into wa_tab41.
    if  p1 eq 'X'.
      if wa_tab41-remark eq 'DUE' or wa_tab41-remark eq 'OVERDUE' .
        wa_tab4-reg = wa_tab41-reg.
        wa_tab4-kunnr = wa_tab41-kunnr.
        wa_tab4-dmbtr = wa_tab41-dmbtr.
        wa_tab4-belnr = wa_tab41-belnr.
        wa_tab4-gjahr = wa_tab41-gjahr.
        wa_tab4-vbeln = wa_tab41-vbeln.
        wa_tab4-zfbdt = wa_tab41-zfbdt.
        wa_tab4-rebzj = wa_tab41-rebzj.
        wa_tab4-fkdat = wa_tab41-fkdat.
        wa_tab4-fkart = wa_tab41-fkart.
        wa_tab4-l_date1_1 = wa_tab41-l_date1_1.
        wa_tab4-remark = wa_tab41-remark.
        wa_tab4-bcpts = wa_tab41-bcpts.
        wa_tab4-xlpts = wa_tab41-xlpts.
        wa_tab4-ls_pts = wa_tab41-ls_pts.
        wa_tab4-vtext = wa_tab41-vtext.
        wa_tab4-val = wa_tab41-val.
        wa_tab4-name1 = wa_tab41-name1.
        wa_tab4-ort01 = wa_tab41-ort01.
        collect wa_tab4 into it_tab4.
        clear wa_tab4.
      endif.
    else.
      wa_tab4-reg = wa_tab41-reg.
      wa_tab4-kunnr = wa_tab41-kunnr.
      wa_tab4-dmbtr = wa_tab41-dmbtr.
      wa_tab4-belnr = wa_tab41-belnr.
      wa_tab4-gjahr = wa_tab41-gjahr.
      wa_tab4-vbeln = wa_tab41-vbeln.
      wa_tab4-zfbdt = wa_tab41-zfbdt.
      wa_tab4-rebzj = wa_tab41-rebzj.
      wa_tab4-fkdat = wa_tab41-fkdat.
      wa_tab4-fkart = wa_tab41-fkart.
      wa_tab4-l_date1_1 = wa_tab41-l_date1_1.
      wa_tab4-remark = wa_tab41-remark.
      wa_tab4-bcpts = wa_tab41-bcpts.
      wa_tab4-xlpts = wa_tab41-xlpts.
      wa_tab4-ls_pts = wa_tab41-ls_pts.
      wa_tab4-vtext = wa_tab41-vtext.
      wa_tab4-val = wa_tab41-val.
      wa_tab4-name1 = wa_tab41-name1.
      wa_tab4-ort01 = wa_tab41-ort01.
      collect wa_tab4 into it_tab4.
      clear wa_tab4.
    endif.
  endloop.

*  select single * from yterrallc where bzirk eq zone and endda ge sy-datum.
*  if sy-subrc eq 0.
*    select single * from zdrphq where bzirk eq zone.
*    if sy-subrc eq 0.
*      select single * from zthr_heq_des where zz_hqcode eq zdrphq-zz_hqcode.
*      if sy-subrc eq 0.
*        zm_hqdesc =  zthr_heq_des-zz_hqdesc.
*      endif.
*    endif.
*    select single * from pa0001 where plans eq yterrallc-plans and endda ge sy-datum.
*    if sy-subrc eq 0.
*      zm_name = pa0001-ename.
*      select single * from pa0105 where pernr eq pa0001-pernr and subty eq '0010'.
*      if sy-subrc eq 0.
*        w_usrid_long = pa0105-usrid_long.
*      endif.
*    else.
*      zm_name = 'VACANT'.
*    endif.
*  endif.

*  LOOP AT IT_TAB4 INTO WA_TAB4.
*    WRITE : / '*', wa_tab4-kunnr, wa_tab4-dmbtr, wa_tab4-belnr,wa_tab4-VBELN,wa_tab4-ZFBDT,wa_tab4-rebzj,'DUEDT',wa_tab4-l_date1_1, WA_TAB4-FKDAT,'BC',WA_TAB4-BCPTS,
*    'XL',WA_TAB4-XLPTS,WA_TAB4-FKART,WA_TAB4-VTEXT.
*  ENDLOOP.
  sort it_tab4 by reg kunnr.
  if r1 eq 'X' or r7 eq 'X'.
    perform alv.
  elseif r2 eq 'X' or r5 eq 'X'.
    perform form.
  elseif r3 eq 'X'.
    perform zmemail.
  elseif r4 eq 'X' or r6 eq 'X'.
    perform email.
  endif.

*&---------------------------------------------------------------------*
*&      Form  EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

form email.

  options-tdgetotf = 'X'.
  call function 'OPEN_FORM'
    exporting
      device   = 'PRINTER'
      dialog   = ''
*     form     = 'ZSR9_1'
      language = sy-langu
      options  = options
    exceptions
      canceled = 1
      device   = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

  call function 'START_FORM'
    exporting
      form        = 'ZMDUE_OD1'
      language    = sy-langu
    exceptions
      form        = 1
      format      = 2
      unended     = 3
      unopened    = 4
      unused      = 5
      spool_error = 6
      codepage    = 7
      others      = 8.
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.


  sort it_tab4 by reg kunnr.

  if r6 eq 'X'.
    select single * from yterrallc where bzirk eq sm and endda ge sy-datum.
    if sy-subrc eq 0.
      select single * from pa0001 where plans eq yterrallc-plans and endda ge sy-datum.
      if sy-subrc eq 0.
        select single * from pa0105 where pernr eq pa0001-pernr and subty eq '0010' and endda ge sy-datum.
        if sy-subrc eq 0.
          smemailid = pa0105-usrid_long.
        endif.
      endif.
    endif.
    if smemailid eq space.
      message 'CHECK SM EMAIL ID' type 'E'.
    endif.
  endif.




  loop at it_tab4 into wa_tab4.

    on change of wa_tab4-reg.
      select single * from yterrallc where bzirk eq wa_tab4-reg and endda ge sy-datum.
      if sy-subrc eq 0.
        select single * from zdrphq where bzirk eq wa_tab4-reg.
        if sy-subrc eq 0.
          select single * from zthr_heq_des where zz_hqcode eq zdrphq-zz_hqcode.
          if sy-subrc eq 0.
            zm_hqdesc =  zthr_heq_des-zz_hqdesc.
          endif.
        endif.
        select single * from pa0001 where plans eq yterrallc-plans and endda ge sy-datum.
        if sy-subrc eq 0.
          zm_name = pa0001-ename.
        else.
          zm_name = 'VACANT'.
        endif.
      endif.


      page1 = 1.
      page3 = page1 + page2.
      if page2 ge 1.
        call function 'WRITE_FORM'
          exporting
            element = 'HEAD'
            window  = 'MAIN'.
      else.
        call function 'WRITE_FORM'
          exporting
            element = 'HEAD1'
            window  = 'MAIN'.
      endif.

      page1 = page1 + 1.
      page2 = page2 + 1.

    endon.

*    if page1 ge 2.
*      call function 'WRITE_FORM'
*        EXPORTING
*          element = 'H1'
*          window  = 'WINDOW1'.
*    endif.

    on change of wa_tab4-kunnr .
      count = 1.
    endon.






*****************zm name & hq*************
*    select single * from yterrallc where bzirk eq wa_tab4-reg and endda ge sy-datum.
*    if sy-subrc eq 0.
*      select single * from zdrphq where bzirk eq zone.
*      if sy-subrc eq 0.
*        select single * from zthr_heq_des where zz_hqcode eq zdrphq-zz_hqcode.
*        if sy-subrc eq 0.
*          zm_hqdesc =  zthr_heq_des-zz_hqdesc.
*        endif.
*      endif.
*      select single * from pa0001 where plans eq yterrallc-plans and endda ge sy-datum.
*      if sy-subrc eq 0.
*        zm_name = pa0001-ename.
*      else.
*        zm_name = 'VACANT'.
*      endif.
*    endif.
************************

*    WRITE : / wa_tab4-kunnr,wa_tab4-name1,wa_tab4-ort01,wa_tab4-vbeln, wa_tab4-fkdat, WA_TAB4-VAL, wa_tab4-bcpts,
*    wa_tab4-xlpts,wa_tab4-l_date1_1, wa_tab4-dmbtr,wa_tab4-remark,COUNT.
*    if wa_tab4-dmbtr gt amt.
    tot_val = tot_val +  wa_tab4-val.
    tot_bc = tot_bc +  wa_tab4-bcpts.
    tot_xl = tot_xl +  wa_tab4-xlpts.
    tot_due = tot_due +  wa_tab4-dmbtr.
*    endif.
    if wa_tab4-remark eq 'OVERDUE'.
*      WRITE : / '*',WA_TAB4-VAL.
      to_val = to_val +  wa_tab4-val.
      to_bc = to_bc +  wa_tab4-bcpts.
      to_xl = to_xl +  wa_tab4-xlpts.
      to_due = to_due +  wa_tab4-dmbtr.
    endif.

    t_val = t_val +  wa_tab4-val.
    t_bc = t_bc +  wa_tab4-bcpts.
    t_xl = t_xl +  wa_tab4-xlpts.
    t_due = t_due +  wa_tab4-dmbtr.

*    if wa_tab4-dmbtr gt amt.
    on change of wa_tab4-kunnr.
      call function 'WRITE_FORM'
        exporting
          element = 'DET1'
          window  = 'MAIN'.
    else.
      call function 'WRITE_FORM'
        exporting
          element = 'DET2'
          window  = 'MAIN'.
    endon.
*    endif.
    at end of kunnr.
*      WRITE : / WA_TAB4-NAME1,WA_TAB4-KUNNR,WA_TAB4-DMBTR,WA_TAB4-VBELN.
*      TOT =  tot_val + tot_bc + tot_xl + tot_due.
      if tot_val ne 0.
        if count gt 1.
          call function 'WRITE_FORM'
            exporting
              element = 'GRP1'
              window  = 'MAIN'.
          tot_val = 0.
          tot_bc = 0.
          tot_xl = 0.
          tot_due = 0.
        else.
          call function 'WRITE_FORM'
            exporting
              element = 'GRP2'
              window  = 'MAIN'.
          tot_val = 0.
          tot_bc = 0.
          tot_xl = 0.
          tot_due = 0.
        endif.
      endif.
    endat.

    at end of reg.
      call function 'WRITE_FORM'
        exporting
          element = 'RM_TOT'
          window  = 'MAIN'.
      t_val = 0.
      t_bc = 0.
      t_xl = 0.
      t_due = 0.

      call function 'WRITE_FORM'
        exporting
          element = 'RM_TOT1'
          window  = 'MAIN'.
      to_val = 0.
      to_bc = 0.
      to_xl = 0.
      to_due = 0.

    endat.
    count = count + 1.
  endloop.
  call function 'END_FORM'
    exceptions
      unopened                 = 1
      bad_pageformat_for_print = 2
      spool_error              = 3
      codepage                 = 4
      others                   = 5.
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.

  call function 'CLOSE_FORM'
    importing
      result  = result
    tables
      otfdata = l_otf_data.

  call function 'CONVERT_OTF'
    exporting
      format       = 'PDF'
    importing
      bin_filesize = l_bin_filesize
    tables
      otf          = l_otf_data
      lines        = l_asc_data.

  call function 'SX_TABLE_LINE_WIDTH_CHANGE'
    exporting
      line_width_dst = '255'
    tables
      content_in     = l_asc_data
      content_out    = objbin.

*  WRITE S_budat-LOW TO wa_d1 DD/MM/YYYY.
*  WRITE S_budat-HIGH TO wa_d2 DD/MM/YYYY.

  describe table objbin lines righe_attachment.
  objtxt = 'This eMail is meant for information only. Please DO NOT REPLY'.append objtxt.
  objtxt = '                                 '.append objtxt.
  objtxt = 'BLUE CROSS LABORATORIES LTD.'.append objtxt.
  describe table objtxt lines righe_testo.
  doc_chng-obj_name = 'URGENT'.
  doc_chng-expiry_dat = sy-datum + 10.
  condense ltx.
  condense objtxt.
*      CONCATENATE 'SR9 for the period' ltx '-' INTO doc_chng-obj_descr SEPARATED BY space.
  concatenate 'CUSTOMER OVERDUE FOR ZONE' '.'  into doc_chng-obj_descr separated by space.
  doc_chng-sensitivty = 'F'.
  doc_chng-doc_size = righe_testo * 255 .

  clear objpack-transf_bin.

  objpack-head_start = 1.
  objpack-head_num = 0.
  objpack-body_start = 1.
  objpack-body_num = 4.
  objpack-doc_type = 'TXT'.
  append objpack.

  objpack-transf_bin = 'X'.
  objpack-head_start = 1.
  objpack-head_num = 0.
  objpack-body_start = 1.
  objpack-body_num = righe_attachment.
  objpack-doc_type = 'PDF'.
  objpack-obj_name = 'TEST'.
  condense ltx.

  concatenate 'CUSTOMER OVERDUE' '.' into objpack-obj_descr separated by space.
  objpack-doc_size = righe_attachment * 255.
  append objpack.
  clear objpack.

*  LOOP AT it_TAM2 INTO wa_TAM2 WHERE PERNR = wa_TAm1-PERNR.
*  reclist-receiver =   w_usrid_long.
  if r6 eq 'X'.
    reclist-receiver =   smemailid.
  else.
    reclist-receiver =   uemail.
  endif.
  reclist-express = 'X'.
  reclist-rec_type = 'U'.
  reclist-notif_del = 'X'. " request delivery notification
  reclist-notif_ndel = 'X'. " request not delivered notification
  append reclist.
  clear reclist.
*  ENdloop.
  describe table reclist lines mcount.
  if mcount > 0.
    data: sender like soextreci1-receiver.
***ADDED BY SATHISH.B
    types: begin of t_usr21,
             bname      type usr21-bname,
             persnumber type usr21-persnumber,
             addrnumber type usr21-addrnumber,
           end of t_usr21.

    types: begin of t_adr6,
             addrnumber type usr21-addrnumber,
             persnumber type usr21-persnumber,
             smtp_addr  type adr6-smtp_addr,
           end of t_adr6.

    data: it_usr21 type table of t_usr21,
          wa_usr21 type t_usr21,
          it_adr6  type table of t_adr6,
          wa_adr6  type t_adr6.
    select  bname persnumber addrnumber from usr21 into table it_usr21
        where bname = sy-uname.
    if sy-subrc = 0.
      select addrnumber persnumber smtp_addr from adr6 into table it_adr6
        for all entries in it_usr21 where addrnumber = it_usr21-addrnumber
                                    and   persnumber = it_usr21-persnumber.
    endif.
    loop at it_usr21 into wa_usr21.
      read table it_adr6 into wa_adr6 with key addrnumber = wa_usr21-addrnumber.
      if sy-subrc = 0.
        sender = wa_adr6-smtp_addr.
      endif.
    endloop.
    call function 'SO_DOCUMENT_SEND_API1'
      exporting
        document_data              = doc_chng
        put_in_outbox              = 'X'
        sender_address             = sender
        sender_address_type        = 'SMTP'
*       COMMIT_WORK                = ' '
* IMPORTING
*       SENT_TO_ALL                =
*       NEW_OBJECT_ID              =
*       SENDER_ID                  =
      tables
        packing_list               = objpack
*       OBJECT_HEADER              =
        contents_bin               = objbin
        contents_txt               = objtxt
*       CONTENTS_HEX               =
*       OBJECT_PARA                =
*       OBJECT_PARB                =
        receivers                  = reclist
      exceptions
        too_many_receivers         = 1
        document_not_sent          = 2
        document_type_not_exist    = 3
        operation_no_authorization = 4
        parameter_error            = 5
        x_error                    = 6
        enqueue_error              = 7
        others                     = 8.
    if sy-subrc <> 0.
      message id sy-msgid type sy-msgty number sy-msgno
              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.

    commit work.


    if sy-subrc eq 0.

      write : / 'EMAIL SENT ON ',uemail.
    endif.



    clear   : objpack,
             objhead,
             objtxt,
             objbin,
             reclist.

    refresh : objpack,
              objhead,
              objtxt,
              objbin,
              reclist.

  endif.


endform.                    "email


*&---------------------------------------------------------------------*
*&      Form  zmEMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form zmemail.

  select * from yterrallc into table it_yterrallc where bzirk in zone and endda ge sy-datum.
  if it_yterrallc is not initial.
    loop at it_yterrallc into wa_yterrallc.
      select single * from pa0001 where plans eq wa_yterrallc-plans and endda ge sy-datum.
      if sy-subrc eq 0.
        wa_tap1-reg = wa_yterrallc-bzirk.
        wa_tap1-zm_name = pa0001-ename.
        select single * from pa0105 where pernr eq pa0001-pernr and subty eq '0010'.
        if sy-subrc eq 0.
          wa_tap1-w_usrid_long = pa0105-usrid_long.
          select single * from zdrphq where bzirk eq wa_yterrallc-bzirk.
          if sy-subrc eq 0.
            select single * from zthr_heq_des where zz_hqcode eq zdrphq-zz_hqcode.
            if sy-subrc eq 0.
              wa_tap1-zm_hqdesc =  zthr_heq_des-zz_hqdesc.
            endif.
          endif.
        endif.
      else.
        wa_tap1-zm_name = 'VACANT'.
      endif.
      collect wa_tap1 into it_tap1.
      clear wa_tap1.
    endloop.
  endif.
  sort it_tap1 by reg.
  delete adjacent duplicates from it_tap1 comparing reg.

  loop at it_tap1 into wa_tap1.
    wa_tap2-reg = wa_tap1-reg.
    wa_tap2-w_usrid_long = wa_tap1-w_usrid_long.
    collect wa_tap2 into it_tap2.
    clear wa_tap2.
  endloop.
  sort it_tap2 by reg.
  delete adjacent duplicates from it_tap2 comparing reg.
*  SELECT SINGLE * FROM YTERRALLC WHERE BZIRK EQ ZONE AND ENDDA GE SY-DATUM.
*  IF SY-SUBRC EQ 0.
*    SELECT SINGLE * FROM PA0001 WHERE PLANS EQ YTERRALLC-PLANS AND ENDDA GE SY-DATUM.
*    IF SY-SUBRC EQ 0.
**      W_PERNR = PA0001-PERNR.
*      select SINGLE * FROM pa0105 WHERE pernr eq PA0001-pernr AND subty eq '0010'.
*      if sy-subrc eq 0.
*        w_usrid_long = pa0105-usrid_long.
*      ENDIF.
*    ENDIF.
*  ENDIF.
  sort it_tab4 by reg kunnr.
  options-tdgetotf = 'X'.
  loop at it_tap1 into wa_tap1.
    call function 'OPEN_FORM'
      exporting
        device   = 'PRINTER'
        dialog   = ''
*       form     = 'ZSR9_1'
        language = sy-langu
        options  = options
      exceptions
        canceled = 1
        device   = 2.
    if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.

    call function 'START_FORM'
      exporting
        form        = 'ZMDUE_OD1'
        language    = sy-langu
      exceptions
        form        = 1
        format      = 2
        unended     = 3
        unopened    = 4
        unused      = 5
        spool_error = 6
        codepage    = 7
        others      = 8.
    if sy-subrc <> 0.
      message id sy-msgid type sy-msgty number sy-msgno
              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.



    loop at it_tab4 into wa_tab4 where reg eq wa_tap1-reg.

      on change of wa_tab4-reg.
        select single * from yterrallc where bzirk eq wa_tab4-reg and endda ge sy-datum.
        if sy-subrc eq 0.
          select single * from zdrphq where bzirk eq wa_tab4-reg.
          if sy-subrc eq 0.
            select single * from zthr_heq_des where zz_hqcode eq zdrphq-zz_hqcode.
            if sy-subrc eq 0.
              zm_hqdesc =  zthr_heq_des-zz_hqdesc.
            endif.
          endif.
          select single * from pa0001 where plans eq yterrallc-plans and endda ge sy-datum.
          if sy-subrc eq 0.
            zm_name = pa0001-ename.
          else.
            zm_name = 'VACANT'.
          endif.
        endif.


*        page1 = 1.
*        page3 = page1 + page2.
*        if page2 ge 1.
*          call function 'WRITE_FORM'
*            EXPORTING
*              element = 'HEAD'
*              window  = 'MAIN'.
*        else.
        call function 'WRITE_FORM'
          exporting
            element = 'HEAD1'
            window  = 'MAIN'.
*        endif.
*
*        page1 = page1 + 1.
*        page2 = page2 + 1.

      endon.

*    if page1 ge 2.
*      call function 'WRITE_FORM'
*        EXPORTING
*          element = 'H1'
*          window  = 'WINDOW1'.
*    endif.

      on change of wa_tab4-kunnr .
        count = 1.
      endon.






*****************zm name & hq*************
*    select single * from yterrallc where bzirk eq wa_tab4-reg and endda ge sy-datum.
*    if sy-subrc eq 0.
*      select single * from zdrphq where bzirk eq zone.
*      if sy-subrc eq 0.
*        select single * from zthr_heq_des where zz_hqcode eq zdrphq-zz_hqcode.
*        if sy-subrc eq 0.
*          zm_hqdesc =  zthr_heq_des-zz_hqdesc.
*        endif.
*      endif.
*      select single * from pa0001 where plans eq yterrallc-plans and endda ge sy-datum.
*      if sy-subrc eq 0.
*        zm_name = pa0001-ename.
*      else.
*        zm_name = 'VACANT'.
*      endif.
*    endif.
************************

*    WRITE : / wa_tab4-kunnr,wa_tab4-name1,wa_tab4-ort01,wa_tab4-vbeln, wa_tab4-fkdat, WA_TAB4-VAL, wa_tab4-bcpts,
*    wa_tab4-xlpts,wa_tab4-l_date1_1, wa_tab4-dmbtr,wa_tab4-remark,COUNT.
*    if wa_tab4-dmbtr gt amt.
      tot_val = tot_val +  wa_tab4-val.
      tot_bc = tot_bc +  wa_tab4-bcpts.
      tot_xl = tot_xl +  wa_tab4-xlpts.
      tot_ls = tot_ls +  wa_tab4-ls_pts.
      tot_due = tot_due +  wa_tab4-dmbtr.
*    endif.
      if wa_tab4-remark eq 'OVERDUE'.
*      WRITE : / '*',WA_TAB4-VAL.
        to_val = to_val +  wa_tab4-val.
        to_bc = to_bc +  wa_tab4-bcpts.
        to_xl = to_xl +  wa_tab4-xlpts.
        to_ls = to_ls +  wa_tab4-ls_pts.
        to_due = to_due +  wa_tab4-dmbtr.
      endif.

      t_val = t_val +  wa_tab4-val.
      t_bc = t_bc +  wa_tab4-bcpts.
      t_xl = t_xl +  wa_tab4-xlpts.
      t_ls = t_ls +  wa_tab4-ls_pts.
      t_due = t_due +  wa_tab4-dmbtr.

*    if wa_tab4-dmbtr gt amt.
      on change of wa_tab4-kunnr.
        call function 'WRITE_FORM'
          exporting
            element = 'DET1'
            window  = 'MAIN'.
      else.
        call function 'WRITE_FORM'
          exporting
            element = 'DET2'
            window  = 'MAIN'.
      endon.
*    endif.
      at end of kunnr.
*      WRITE : / WA_TAB4-NAME1,WA_TAB4-KUNNR,WA_TAB4-DMBTR,WA_TAB4-VBELN.
*      TOT =  tot_val + tot_bc + tot_xl + tot_due.
        if tot_val ne 0.
          if count gt 1.
            call function 'WRITE_FORM'
              exporting
                element = 'GRP1'
                window  = 'MAIN'.
            tot_val = 0.
            tot_bc = 0.
            tot_xl = 0.
            tot_ls = 0.
            tot_due = 0.
          else.
            call function 'WRITE_FORM'
              exporting
                element = 'GRP2'
                window  = 'MAIN'.
            tot_val = 0.
            tot_bc = 0.
            tot_xl = 0.
            tot_ls = 0.
            tot_due = 0.
          endif.
        endif.
      endat.

      at end of reg.
        call function 'WRITE_FORM'
          exporting
            element = 'RM_TOT'
            window  = 'MAIN'.
        t_val = 0.
        t_bc = 0.
        t_xl = 0.
        t_ls = 0.
        t_due = 0.

        call function 'WRITE_FORM'
          exporting
            element = 'RM_TOT1'
            window  = 'MAIN'.
        to_val = 0.
        to_bc = 0.
        to_xl = 0.
        to_ls = 0.
        to_due = 0.

      endat.
      count = count + 1.
    endloop.

    call function 'END_FORM'
      exceptions
        unopened                 = 1
        bad_pageformat_for_print = 2
        spool_error              = 3
        codepage                 = 4
        others                   = 5.
    if sy-subrc <> 0.
      message id sy-msgid type sy-msgty number sy-msgno
              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.

    call function 'CLOSE_FORM'
      importing
        result  = result
      tables
        otfdata = l_otf_data.

    call function 'CONVERT_OTF'
      exporting
        format       = 'PDF'
      importing
        bin_filesize = l_bin_filesize
      tables
        otf          = l_otf_data
        lines        = l_asc_data.

    call function 'SX_TABLE_LINE_WIDTH_CHANGE'
      exporting
        line_width_dst = '255'
      tables
        content_in     = l_asc_data
        content_out    = objbin.

*  WRITE S_budat-LOW TO wa_d1 DD/MM/YYYY.
*  WRITE S_budat-HIGH TO wa_d2 DD/MM/YYYY.

    describe table objbin lines righe_attachment.
    objtxt = 'This eMail is meant for information only. Please DO NOT REPLY'.append objtxt.
    objtxt = '                                 '.append objtxt.
    objtxt = 'BLUE CROSS LABORATORIES LTD.'.append objtxt.
    describe table objtxt lines righe_testo.
    doc_chng-obj_name = 'URGENT'.
    doc_chng-expiry_dat = sy-datum + 10.
    condense ltx.
    condense objtxt.
*      CONCATENATE 'SR9 for the period' ltx '-' INTO doc_chng-obj_descr SEPARATED BY space.
    concatenate 'CUSTOMER OVERDUE FOR ZONE' '.'  into doc_chng-obj_descr separated by space.
    doc_chng-sensitivty = 'F'.
    doc_chng-doc_size = righe_testo * 255 .

    clear objpack-transf_bin.

    objpack-head_start = 1.
    objpack-head_num = 0.
    objpack-body_start = 1.
    objpack-body_num = 4.
    objpack-doc_type = 'TXT'.
    append objpack.

    objpack-transf_bin = 'X'.
    objpack-head_start = 1.
    objpack-head_num = 0.
    objpack-body_start = 1.
    objpack-body_num = righe_attachment.
    objpack-doc_type = 'PDF'.
    objpack-obj_name = 'TEST'.
    condense ltx.

    concatenate 'CUSTOMER OVERDUE' '.' into objpack-obj_descr separated by space.
    objpack-doc_size = righe_attachment * 255.
    append objpack.
    clear objpack.

*  LOOP AT it_TAM2 INTO wa_TAM2 WHERE PERNR = wa_TAm1-PERNR.
    reclist-receiver =   wa_tap1-w_usrid_long.
    reclist-express = 'X'.
    reclist-rec_type = 'U'.
    reclist-notif_del = 'X'. " request delivery notification
    reclist-notif_ndel = 'X'. " request not delivered notification
    append reclist.
    clear reclist.
*  ENdloop.
    describe table reclist lines mcount.
    if mcount > 0.
      data: sender like soextreci1-receiver.
***ADDED BY SATHISH.B
      types: begin of t_usr21,
               bname      type usr21-bname,
               persnumber type usr21-persnumber,
               addrnumber type usr21-addrnumber,
             end of t_usr21.

      types: begin of t_adr6,
               addrnumber type usr21-addrnumber,
               persnumber type usr21-persnumber,
               smtp_addr  type adr6-smtp_addr,
             end of t_adr6.

      data: it_usr21 type table of t_usr21,
            wa_usr21 type t_usr21,
            it_adr6  type table of t_adr6,
            wa_adr6  type t_adr6.
      select  bname persnumber addrnumber from usr21 into table it_usr21
          where bname = sy-uname.
      if sy-subrc = 0.
        select addrnumber persnumber smtp_addr from adr6 into table it_adr6
          for all entries in it_usr21 where addrnumber = it_usr21-addrnumber
                                      and   persnumber = it_usr21-persnumber.
      endif.
      loop at it_usr21 into wa_usr21.
        read table it_adr6 into wa_adr6 with key addrnumber = wa_usr21-addrnumber.
        if sy-subrc = 0.
          sender = wa_adr6-smtp_addr.
        endif.
      endloop.
      call function 'SO_DOCUMENT_SEND_API1'
        exporting
          document_data              = doc_chng
          put_in_outbox              = 'X'
          sender_address             = sender
          sender_address_type        = 'SMTP'
*         COMMIT_WORK                = ' '
* IMPORTING
*         SENT_TO_ALL                =
*         NEW_OBJECT_ID              =
*         SENDER_ID                  =
        tables
          packing_list               = objpack
*         OBJECT_HEADER              =
          contents_bin               = objbin
          contents_txt               = objtxt
*         CONTENTS_HEX               =
*         OBJECT_PARA                =
*         OBJECT_PARB                =
          receivers                  = reclist
        exceptions
          too_many_receivers         = 1
          document_not_sent          = 2
          document_type_not_exist    = 3
          operation_no_authorization = 4
          parameter_error            = 5
          x_error                    = 6
          enqueue_error              = 7
          others                     = 8.
      if sy-subrc <> 0.
        message id sy-msgid type sy-msgty number sy-msgno
                with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      endif.

      commit work.


      if sy-subrc eq 0.

        write : / 'EMAIL SENT ON ',wa_tap1-w_usrid_long.
      endif.



      clear   : objpack,
               objhead,
               objtxt,
               objbin,
               reclist.

      refresh : objpack,
                objhead,
                objtxt,
                objbin,
                reclist.

    endif.
  endloop.

endform.                    "EMAIL
*&---------------------------------------------------------------------*
*&      Form  ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form alv.

  loop at it_tab4 into wa_tab4.
*    WRITE : / wa_tab4-kunnr,wa_tab4-dmbtr,wa_tab4-belnr,wa_tab4-vbeln,wa_tab4-zfbdt,wa_tab4-l_date1_1,
*    wa_tab4-fkdat,WA_TAB4-VAL,wa_tab4-bcpts,wa_tab4-xlpts.

    pack wa_tab4-kunnr to wa_tab4-kunnr.
    condense wa_tab4-kunnr.
    modify it_tab4 from wa_tab4 transporting kunnr.
  endloop.

  wa_fieldcat-fieldname = 'KUNNR'.
  wa_fieldcat-seltext_l = 'CUSTOMER CODE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'NAME1'.
  wa_fieldcat-seltext_l = 'CUSTOMER NAME'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'ORT01'.
  wa_fieldcat-seltext_l = 'CUSTOMER PLACE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'DMBTR'.
  wa_fieldcat-seltext_l = 'DUE AMOUNT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'BELNR'.
  wa_fieldcat-seltext_l = 'DOC NO'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'FKDAT'.
  wa_fieldcat-seltext_l = 'INVOICE DATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'VBELN'.
  wa_fieldcat-seltext_l = 'INVOICE NO'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'FKART'.
  wa_fieldcat-seltext_l = 'DOC TYPE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'VTEXT'.
  wa_fieldcat-seltext_l = 'DOC DESCRIPTION'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'VBELN'.
  wa_fieldcat-seltext_l = 'INVOICE NO'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'VAL'.
  wa_fieldcat-seltext_l = 'INVOICE AMOUNT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'L_DATE1_1'.
  wa_fieldcat-seltext_l = 'DUE DATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'ZFBDT'.
  wa_fieldcat-seltext_l = 'LR DATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'BCPTS'.
  wa_fieldcat-seltext_l = 'BLUE CROSS VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'XLPTS'.
  wa_fieldcat-seltext_l = 'EXCEL VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LS_PTS'.
  wa_fieldcat-seltext_l = 'BC-LIFE SCI. VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'REMARK'.
  wa_fieldcat-seltext_l = 'REMARK'.
  append wa_fieldcat to fieldcat.



  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'ZONAL OVERDUE'.


  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = g_repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
      i_callback_user_command = 'USER_COMM'
      i_callback_top_of_page  = 'TOP'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         =
      is_layout               = layout
      it_fieldcat             = fieldcat
*     IT_EXCLUDING            =
*     IT_SPECIAL_GROUPS       =
*     IT_SORT                 =
*     IT_FILTER               =
*     IS_SEL_HIDE             =
*     I_DEFAULT               = 'X'
      i_save                  = 'A'
*     IS_VARIANT              =
*     IT_EVENTS               =
*     IT_EVENT_EXIT           =
*     IS_PRINT                =
*     IS_REPREP_ID            =
*     I_SCREEN_START_COLUMN   = 0
*     I_SCREEN_START_LINE     = 0
*     I_SCREEN_END_COLUMN     = 0
*     I_SCREEN_END_LINE       = 0
*     I_HTML_HEIGHT_TOP       = 0
*     I_HTML_HEIGHT_END       = 0
*     IT_ALV_GRAPHICS         =
*     IT_HYPERLINK            =
*     IT_ADD_FIELDCAT         =
*     IT_EXCEPT_QINFO         =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER =
*     ES_EXIT_CAUSED_BY_USER  =
    tables
      t_outtab                = it_tab4
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

endform.                    "SUMMARY

*&---------------------------------------------------------------------*
*&      Form  FORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form form.

  call function 'OPEN_FORM'
    exporting
      device   = 'PRINTER'
      dialog   = 'X'
*     form     = 'ZSR9_1'
      language = sy-langu
    exceptions
      canceled = 1
      device   = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.
  call function 'START_FORM'
    exporting
      form        = 'ZMDUE_OD1'
      language    = sy-langu
    exceptions
      form        = 1
      format      = 2
      unended     = 3
      unopened    = 4
      unused      = 5
      spool_error = 6
      codepage    = 7
      others      = 8.
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.


  sort it_tab4 by reg kunnr.
  loop at it_tab4 into wa_tab4.

    on change of wa_tab4-reg.
      select single * from yterrallc where bzirk eq wa_tab4-reg and endda ge sy-datum.
      if sy-subrc eq 0.
        select single * from zdrphq where bzirk eq wa_tab4-reg.
        if sy-subrc eq 0.
          select single * from zthr_heq_des where zz_hqcode eq zdrphq-zz_hqcode.
          if sy-subrc eq 0.
            zm_hqdesc =  zthr_heq_des-zz_hqdesc.
          endif.
        endif.
        select single * from pa0001 where plans eq yterrallc-plans and endda ge sy-datum.
        if sy-subrc eq 0.
          zm_name = pa0001-ename.
        else.
          zm_name = 'VACANT'.
        endif.
      endif.


      page1 = 1.
      page3 = page1 + page2.
      if page2 ge 1.
        call function 'WRITE_FORM'
          exporting
            element = 'HEAD'
            window  = 'MAIN'.
      else.
        call function 'WRITE_FORM'
          exporting
            element = 'HEAD1'
            window  = 'MAIN'.
      endif.

      page1 = page1 + 1.
      page2 = page2 + 1.

    endon.

*    if page1 ge 2.
*      call function 'WRITE_FORM'
*        EXPORTING
*          element = 'H1'
*          window  = 'WINDOW1'.
*    endif.

    on change of wa_tab4-kunnr .
      count = 1.
    endon.






*****************zm name & hq*************
*    select single * from yterrallc where bzirk eq wa_tab4-reg and endda ge sy-datum.
*    if sy-subrc eq 0.
*      select single * from zdrphq where bzirk eq zone.
*      if sy-subrc eq 0.
*        select single * from zthr_heq_des where zz_hqcode eq zdrphq-zz_hqcode.
*        if sy-subrc eq 0.
*          zm_hqdesc =  zthr_heq_des-zz_hqdesc.
*        endif.
*      endif.
*      select single * from pa0001 where plans eq yterrallc-plans and endda ge sy-datum.
*      if sy-subrc eq 0.
*        zm_name = pa0001-ename.
*      else.
*        zm_name = 'VACANT'.
*      endif.
*    endif.
************************

*    WRITE : / wa_tab4-kunnr,wa_tab4-name1,wa_tab4-ort01,wa_tab4-vbeln, wa_tab4-fkdat, WA_TAB4-VAL, wa_tab4-bcpts,
*    wa_tab4-xlpts,wa_tab4-l_date1_1, wa_tab4-dmbtr,wa_tab4-remark,COUNT.
*    if wa_tab4-dmbtr gt amt.
    tot_val = tot_val +  wa_tab4-val.
    tot_bc = tot_bc +  wa_tab4-bcpts.
    tot_xl = tot_xl +  wa_tab4-xlpts.
    tot_ls = tot_ls +  wa_tab4-ls_pts.
    tot_due = tot_due +  wa_tab4-dmbtr.
*    endif.
    if wa_tab4-remark eq 'OVERDUE'.
*      WRITE : / '*',WA_TAB4-VAL.
      to_val = to_val +  wa_tab4-val.
      to_bc = to_bc +  wa_tab4-bcpts.
      to_xl = to_xl +  wa_tab4-xlpts.
      to_ls = to_ls +  wa_tab4-ls_pts.
      to_due = to_due +  wa_tab4-dmbtr.
    endif.

    t_val = t_val +  wa_tab4-val.
    t_bc = t_bc +  wa_tab4-bcpts.
    t_xl = t_xl +  wa_tab4-xlpts.
    t_ls = t_ls +  wa_tab4-ls_pts.
    t_due = t_due +  wa_tab4-dmbtr.

*    if wa_tab4-dmbtr gt amt.
    on change of wa_tab4-kunnr.
      call function 'WRITE_FORM'
        exporting
          element = 'DET1'
          window  = 'MAIN'.
    else.
      call function 'WRITE_FORM'
        exporting
          element = 'DET2'
          window  = 'MAIN'.
    endon.
*    endif.
    at end of kunnr.
*      WRITE : / WA_TAB4-NAME1,WA_TAB4-KUNNR,WA_TAB4-DMBTR,WA_TAB4-VBELN.
*      TOT =  tot_val + tot_bc + tot_xl + tot_due.
      if tot_val ne 0.
        if count gt 1.
          call function 'WRITE_FORM'
            exporting
              element = 'GRP1'
              window  = 'MAIN'.
          tot_val = 0.
          tot_bc = 0.
          tot_xl = 0.
          tot_ls = 0.
          tot_due = 0.
        else.
          call function 'WRITE_FORM'
            exporting
              element = 'GRP2'
              window  = 'MAIN'.
          tot_val = 0.
          tot_bc = 0.
          tot_xl = 0.
          tot_ls = 0.
          tot_due = 0.
        endif.
      endif.
    endat.

    at end of reg.
      call function 'WRITE_FORM'
        exporting
          element = 'RM_TOT'
          window  = 'MAIN'.
      t_val = 0.
      t_bc = 0.
      t_xl = 0.
      t_ls = 0.
      t_due = 0.

      call function 'WRITE_FORM'
        exporting
          element = 'RM_TOT1'
          window  = 'MAIN'.
      to_val = 0.
      to_bc = 0.
      to_xl = 0.
      to_ls = 0.
      to_due = 0.

    endat.
    count = count + 1.
  endloop.
  call function 'END_FORM'
    exceptions
      unopened                 = 1
      bad_pageformat_for_print = 2
      spool_error              = 3
      codepage                 = 4
      others                   = 5.
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.
  call function 'CLOSE_FORM'
* IMPORTING
*   RESULT                         =
*   RDI_RESULT                     =
* TABLES
*   OTFDATA                        =
    exceptions
      unopened                 = 1
      bad_pageformat_for_print = 2
      send_error               = 3
      spool_error              = 4
      codepage                 = 5
      others                   = 6.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

endform.                    "FORM

*&---------------------------------------------------------------------*
*&      Form  TOP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form top.

  data: comment    type slis_t_listheader,
        wa_comment like line of comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'ZONAL OVERDUE'.
*  WA_COMMENT-INFO = P_FRMDT.
  append wa_comment to comment.

  call function 'REUSE_ALV_COMMENTARY_WRITE'
    exporting
      it_list_commentary = comment
*     I_LOGO             = 'ENJOYSAP_LOGO'
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .

  clear comment.

endform.                    "TOP



*&---------------------------------------------------------------------*
*&      Form  USER_COMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->UCOMM      text
*      -->SELFIELD   text
*----------------------------------------------------------------------*
form user_comm using ucomm like sy-ucomm
                     selfield type slis_selfield.



  case selfield-fieldname.
    when 'VBELN'.
      set parameter id 'VF' field selfield-value.
      call transaction 'VF03' and skip first screen.
    when 'VBELN1'.
      set parameter id 'BV' field selfield-value.
      call transaction 'VL03N' and skip first screen.
    when others.
  endcase.
endform.                    "USER_COMM
*&---------------------------------------------------------------------*
*&      Form  sale
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form sale.
  if it_tab3 is not initial.
    select * from vbrk into table it_vbrk for all entries in it_tab3 where vbeln eq it_tab3-vbeln.
*      and fkart in ('ZBDF','ZCDF').
    if sy-subrc eq 0.
      select * from vbrp into table it_vbrp for all entries in it_vbrk where vbeln eq it_vbrk-vbeln.
*         and pstyv eq 'ZAN'.
    endif.
  endif.
*  select knumv kposn kschl kwert  from prcd_elements into table it_konv for all entries in it_vbrk where knumv = it_vbrk-knumv
*    and kschl in ('ZPED', 'ZEX4').

  loop at it_vbrp into wa_vbrp.
    clear : bcpts, xlpts,val.
    read table it_vbrk into wa_vbrk with key vbeln = wa_vbrp-vbeln.
    if sy-subrc eq 0.
      wa_tas1-vbeln = wa_vbrp-vbeln.
      wa_tas1-fkart = wa_vbrk-fkart.
      wa_tas1-fkdat = wa_vbrk-fkdat.
      val = wa_vbrp-netwr + wa_vbrp-mwsbp.
      wa_tas1-val = val.
*      WA_TAS1-FKART = WA_VBRK-FKART.
      select single * from mara where matnr eq wa_vbrp-matnr.
      if sy-subrc eq 0.
        if mara-spart eq '50'.
          bcpts = wa_vbrp-netwr + wa_vbrp-mwsbp.
          wa_tas1-bcpts = bcpts.
        elseif mara-spart eq '60'.
          xlpts = wa_vbrp-netwr + wa_vbrp-mwsbp.
          wa_tas1-xlpts = xlpts.
        elseif mara-spart eq '70'.
          ls_pts = wa_vbrp-netwr + wa_vbrp-mwsbp.
          wa_tas1-ls_pts = ls_pts.
        endif.
      endif.
      collect wa_tas1 into it_tas1.
      clear wa_tas1.
    endif.
  endloop.
endform.                    "sale

*&---------------------------------------------------------------------*
*&      Form  od
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form od.

*  WRITE : / wa_tac4-kunnr.
  if it_tac4 is not initial.
    select * from bsid into table it_bsid for all entries in it_tac4 where kunnr eq it_tac4-kunnr and umskz ne 'V'.
    select * from kna1 into table it_kna1 for all entries in it_tac4 where kunnr eq it_tac4-kunnr.
  endif.
  loop at it_bsid into wa_bsid.
    if wa_bsid-shkzg eq 'H'.
      wa_bsid-dmbtr = wa_bsid-dmbtr * ( - 1 ).
    endif.
    wa_tab3-kunnr = wa_bsid-kunnr.
    wa_tab3-dmbtr = wa_bsid-dmbtr.
    wa_tab3-belnr = wa_bsid-belnr.
    wa_tab3-gjahr = wa_bsid-gjahr.
    wa_tab3-vbeln = wa_bsid-vbeln.
    wa_tab3-zfbdt = wa_bsid-zfbdt.
    wa_tab3-shkzg = wa_bsid-shkzg.
    wa_tab3-rebzg = wa_bsid-rebzg.
    wa_tab3-rebzj = wa_bsid-rebzj.

    select single * from bsas where bukrs = 'BCLL' and belnr eq wa_bsid-rebzg and gjahr = wa_bsid-rebzj .
    if sy-subrc eq 0.
*        l_date = bsas-zfbdt.
      wa_tab3-zfbdt1 = bsas-zfbdt.
      l_date_1 = bsas-zfbdt.
      l_date1_1 = l_date_1 + wa_bsid-zbd1t.
      wa_tab3-l_date1_1 = l_date1_1.
    else.
      l_date_1 = wa_bsid-zfbdt.
      l_date1_1 = l_date_1 + wa_bsid-zbd1t.
      wa_tab3-l_date1_1 = l_date1_1.
    endif.
    read table it_tac3 into wa_tac3 with key kunnr = wa_bsid-kunnr.
    if sy-subrc eq 0.
      read table it_tac2 into wa_tac2 with key bzirk  = wa_tac3-bzirk.
      if sy-subrc eq 0.
        wa_tab3-reg = wa_tac2-reg.
      endif.
    endif.

    collect wa_tab3 into it_tab3.
    clear wa_tab3.
  endloop.

*  LOOP at it_tab3 INTO wa_tab3.
*    WRITE : / 'ooo', wa_tab3-kunnr, wa_tab3-dmbtr, wa_tab3-belnr,wa_tab3-VBELN,wa_tab3-ZFBDT,wa_tab3-shkzg,wa_tab3-rebzg,
*              wa_tab3-rebzj,wa_tab3-l_date_1,wa_tab3-l_date1_1.
*  ENDLOOP.
endform.                    "od
