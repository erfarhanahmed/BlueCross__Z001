*&---------------------------------------------------------------------*
*& Report  ZSA7_REPORT1
*&
*&---------------------------------------------------------------------*
*& BCDK934844 / 16.04.2024
*& Desc - Add new div
*&---------------------------------------------------------------------*
report zsa7_report1_a1 no standard page heading line-size 500..
tables : zdsmter,
         zprdgroup,
         vbrk,
         pa0001,
         ysd_cus_div_dis,
         mara,
         makt,
         mvke,tvm5t,
         zthr_heq_des,
         ysd_dist_targt,
         zmtpt,
         yterrallc,
         pa0105.

type-pools:  slis.

data: g_repid     like sy-repid,
      fieldcat    type slis_t_fieldcat_alv,
      wa_fieldcat like line of fieldcat,
      sort        type slis_t_sortinfo_alv,
      wa_sort     like line of sort,
      layout      type slis_layout_alv.

types : begin of typ_konv,
          knumv type konv-knumv,
          kposn type konv-kposn,
          kschl type konv-kschl,
          kwert type konv-kwert,
        end of typ_konv.

data : it_zdsmter         type table of zdsmter,
       wa_zdsmter         type zdsmter,
       it_zdsmter1        type table of zdsmter,
       wa_zdsmter1        type zdsmter,
       it_yterrallc       type table of yterrallc,
       wa_yterrallc       type yterrallc,
       it_vbrk            type table of vbrk,
       wa_vbrk            type vbrk,
       it_vbrp            type table of vbrp,
       wa_vbrp            type vbrp,
       it_konv            type table of typ_konv,
       wa_konv            type typ_konv,
       it_ysd_cus_div_dis type table of ysd_cus_div_dis,
       wa_ysd_cus_div_dis type ysd_cus_div_dis.

data : msg      type string,
       month(2) type c,
       year(4)  type c,
       year1(4) type c,
       s_date   type sy-datum,
       tgt(10)  type p decimals 0,
       mtpt(10) type p decimals 0,
       d1(2)    type c,
       d2(4)    type c,
       d3(2)    type c,
       d4(4)    type c.

types : begin of itab1,
          reg       type zdsmter-zdsm,
          spart     type zdsmter-spart,
          zm        type zdsmter-bzirk,
          rm        type zdsmter-bzirk,
          bzirk     type zdsmter-bzirk,
          text(9)   type c,
          sval      type p decimals 2,
          acn_val   type p decimals 2,
          oth_val   type p decimals 2,
          net       type p decimals 2,
          plans     type yterrallc-plans,
          ename     type pa0001-ename,
          zz_hqdesc type zthr_heq_des-zz_hqdesc,
          short     type hrp1000-short,
          begda     type pa0302-begda,
          pernr     type pa0001-pernr,
        end of itab1.

types : begin of itab4,
          reg       type zdsmter-zdsm,
          spart     type zdsmter-spart,
          zm        type zdsmter-bzirk,
          dzm       type zdsmter-bzirk,
          rm        type zdsmter-bzirk,
          bzirk     type zdsmter-bzirk,
          grp_code  type zprdgroup-grp_code,
          grp_name  type zprdgroup-grp_name,
          matkl     type maktx,
          text(9)   type c,
          sval      type p,
          acn_val   type p decimals 2,
          oth_val   type p decimals 2,
          net       type p decimals 2,
          plans     type yterrallc-plans,
          ename     type pa0001-ename,
          zz_hqdesc type zthr_heq_des-zz_hqdesc,
          short     type hrp1000-short,
          begda     type pa0302-begda,
          pernr     type pa0001-pernr,
          kunnr     type ysd_cus_div_dis-kunnr,
          percnt    type ysd_cus_div_dis-percnt,
          qty       type p,
          matnr     type vbrp-matnr,
          maktx     type vbrp-arktx,
          bezei     type tvm5t-bezei,
          rm_plans  type yterrallc-plans,
          div(4)    type c,

        end of itab4.

types : begin of itab7,
          reg       type zdsmter-zdsm,
          spart     type zdsmter-spart,
          zm        type zdsmter-bzirk,
          rm        type zdsmter-bzirk,
          bzirk     type zdsmter-bzirk,
          grp_code  type zprdgroup-grp_code,
          text(9)   type c,
          sval      type p,
          acn_val   type p decimals 2,
          oth_val   type p decimals 2,
          net       type p decimals 2,
          plans     type yterrallc-plans,
          ename     type pa0001-ename,
          zz_hqdesc type zthr_heq_des-zz_hqdesc,
          short     type hrp1000-short,
          begda     type pa0302-begda,
          pernr     type pa0001-pernr,
          kunnr     type ysd_cus_div_dis-kunnr,
          percnt    type ysd_cus_div_dis-percnt,
          qty       type p,
          matnr     type vbrp-matnr,
          maktx     type vbrp-arktx,
          bezei     type tvm5t-bezei,
          rm_plans  type yterrallc-plans,
          div(4)    type c,
          rm_ename  type pa0001-ename,
          zm_ename  type pa0001-ename,
        end of itab7.

types : begin of itab5,
          kunnr type ysd_cus_div_dis-kunnr,
          spart type ysd_cus_div_dis-spart,
        end of itab5.

types : begin of itas1,
          vbeln        type vbrp-vbeln,
          matnr        type vbrp-matnr,
          charg        type vbrp-charg,
          fkimg_s      type vbrp-fkimg,
          fkimg_b      type vbrp-fkimg,
          arktx        type vbrp-arktx,
          lgort        type vbrp-lgort,
          kzwi2        type vbrp-kzwi2,
          bed_rate     type p decimals 2,
          xed_rate     type p decimals 2,
          ls_ed_rate   type p decimals 2,
          werks        type vbrp-werks,
          zped         type p decimals 2,
*  zped type p decimals 2,
          bpts         type p decimals 2,
          xpts         type p decimals 2,
          ls_pts       type p decimals 2,
          netwr        type vbrp-netwr,
          mwsbp        type vbrp-mwsbp,
          kzwi4        type vbrp-kzwi4,
          skfbp        type vbrp-skfbp,
          bzped_rate   type p decimals 2,
          xzped_rate   type p decimals 2,
          ls_zped_rate type p decimals 2,
          bzgrp_rate   type p decimals 2,
          xzgrp_rate   type p decimals 2,
          ls_zgrp_rate type p decimals 2,
          fkdat        type vbrk-fkdat,
          fkart        type vbrk-fkart,
          bzirk        type ysd_cus_div_dis-bzirk,
          val          type p decimals 2,
          bnetwr       type p decimals 2,
          xnetwr       type p decimals 2,
          ls_netwr     type p decimals 2,
          spart        type mara-spart,
          kunag        type vbrk-kunag,
          pts          type p,

        end of itas1.

types : begin of itam1,
          pernr type pa0001-pernr,
          rm    type yterrallc-bzirk,
        end of itam1.

types : begin of itam2,
          pernr      type pa0001-pernr,
          usrid_long type pa0105-usrid_long,
        end of itam2.

data : it_tab1  type table of itab1,
       wa_tab1  type itab1,
       it_tab2  type table of itab1,
       wa_tab2  type itab1,
       it_tab3  type table of itab1,
       wa_tab3  type itab1,
       it_tab31 type table of itab1,
       wa_tab31 type itab1,
       it_tac1  type table of itab1,
       wa_tac1  type itab1,
       it_tac2  type table of itab1,
       wa_tac2  type itab1,
       it_tac3  type table of itab1,
       wa_tac3  type itab1,
       it_tab4  type table of itab4,
       wa_tab4  type itab4,

       it_tab5  type table of itab5,
       wa_tab5  type itab5,
       it_tab6  type table of itab4,
       wa_tab6  type itab4,
       it_tab7  type table of itab7,
       wa_tab7  type itab7,
       it_tas1  type table of itas1,
       wa_tas1  type itas1,
       it_tas2  type table of itas1,
       wa_tas2  type itas1,
       it_tas3  type table of itas1,
       wa_tas3  type itas1,
       it_tas4  type table of itas1,
       wa_tas4  type itas1,
       it_tam1  type table of itam1,
       wa_tam1  type itam1,
       it_tam2  type table of itam2,
       wa_tam2  type itam2.

data : pts       type p,
       val       type p,
       qty       type p,
       val1      type p decimals 2,
       pso_ename type pa0001-ename,
       rm_ename  type pa0001-ename.
data : page1   type i value 1,
       page2   type i,
       page3   type i,
       g_sval  type p,
       g_qty   type p,
       pso_tot type p,
       count   type i.

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
data : w_usrid_long type pa0105-usrid_long.
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

data : wa_d1(10) type c,
       wa_d2(10) type c,
       c1(241)   type c.
types : begin of dist1,
          kunag type zdist_sale-kunag,
          matnr type zdist_sale-matnr,
          spart type mara-spart,
          netwr type zdist_sale-netwr,
          fkimg type p,
        end of dist1.

types : begin of dist2,
          kunag type ysd_cus_div_dis-kunnr,
          matnr type zdist_sale-matnr,
          spart type mara-spart,
          netwr type zdist_sale-netwr,
          fkimg type p,
        end of dist2.

types : begin of dist3,
          kunag type ysd_cus_div_dis-kunnr,
          matnr type zdist_sale-matnr,
          spart type mara-spart,
          s_val type zdist_sale-netwr,
          s_qty type p,
        end of dist3.

data : it_dist1 type table of dist1,
       wa_dist1 type dist1,
       it_dist2 type table of dist2,
       wa_dist2 type dist2,
       it_dist3 type table of dist3,
       wa_dist3 type dist3.

data : distval type p decimals 2,
       distqty type p.


data: it_zdist_sale       type table of zdist_sale,
      wa_zdist_sale       type zdist_sale,
      it_ysd_cus_div_dis1 type table of ysd_cus_div_dis,
      wa_ysd_cus_div_dis1 type ysd_cus_div_dis.

selection-screen begin of block b1 with frame title text-001.
parameter : zone like zdsmter-zdsm matchcode object zsr9_1 obligatory..
select-options : pso for pa0001-pernr matchcode object zsr9_3 no intervals.
select-options : s_budat for vbrk-fkdat obligatory.
selection-screen end of block b1.
selection-screen begin of block b2 with frame title text-001.
parameter : r3 radiobutton group r1,
            r1 radiobutton group r1,
            r2 radiobutton group r1,
            r4 radiobutton group r1,
            r7 radiobutton group r1,
            r5 radiobutton group r1,
            r6 radiobutton group r1.

parameter : uemail(70) type c.
selection-screen end of block b2.

initialization.
  g_repid = sy-repid.

at selection-screen.

  select * from zdsmter into table it_zdsmter1 where zdsm eq zone.

  loop at it_zdsmter1 into wa_zdsmter1.
    authority-check object 'ZON1_1'
           id 'ZDSM' field wa_zdsmter1-zdsm.
    if sy-subrc <> 0.
      concatenate 'No authorization for Zone' wa_zdsmter1-zdsm into msg
      separated by space.
      message msg type 'E'.
    endif.
  endloop.

  d1 = s_budat-low+4(2).
  d2 = s_budat-low+0(4).

  d3 = s_budat-high+4(2).
  d4 = s_budat-high+0(4).

  if d1 ne d3.
    message 'ENTER DATES WITHIN SAME MONTH' type 'E'.
  endif.

  if d2 ne d4.
    message 'ENTER DATES WITHIN SAME YEAR' type 'E'.
  endif.
  if r6 eq 'X'.
    if uemail eq '                                                                     '.
      message 'ENTER EMAIL ID' type 'E'.
    endif.
  endif.

start-of-selection.

  month = s_budat-low+4(2).
  year = s_budat-low+0(4).

  if month lt 4.
    year1 = year - 1.
  else.
    year1 = year.
  endif.
  s_date+6(2) = '15'.
  s_date+4(2) = month.
  s_date+0(4) = year.
*  WRITE : / 'start date',s_date.

  select * from zdsmter into table it_zdsmter where zmonth eq month and zyear eq year and zdsm eq zone.
  if sy-subrc ne 0.
    exit.
  endif.

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
        wa_tac2-text = wa_tab2-text.
        wa_tac2-reg = wa_tab2-reg.
        wa_tac2-zm = wa_tab2-zm.
        wa_tac2-rm = wa_tab2-rm.
        wa_tac2-bzirk = zdsmter-bzirk.
        wa_tac2-spart = zdsmter-spart.
        collect wa_tac2 into it_tac2.
        clear wa_tac2.
      endif.
    endselect.
  endloop.
*  uline.
  if it_tac2 is not initial.
    select * from yterrallc into table it_yterrallc for all entries in it_tac2 where spart eq it_tac2-spart and
      bzirk eq it_tac2-bzirk and begda le s_budat-low and endda ge s_budat-high.
  endif.

  loop at it_tac2 into wa_tac2 .
*    WRITE : /'text', wa_tac2-text,'reg',wa_tac2-reg,'zm',wa_tac2-zm,'rm',wa_tac2-rm,'bzirk',wa_tac2-bzirk,'div',wa_tac2-spart.
    wa_tab3-reg = wa_tac2-reg.
    wa_tab3-zm = wa_tac2-zm.
    wa_tab3-rm = wa_tac2-rm.
    wa_tab3-bzirk = wa_tac2-bzirk.
    wa_tab3-spart = wa_tac2-spart.
    read table it_yterrallc into wa_yterrallc with key spart = wa_tac2-spart bzirk = wa_tac2-bzirk.
    if sy-subrc eq 0.
*      WRITE : wa_yterrallc-plans.
      wa_tab3-plans = wa_yterrallc-plans.
      wa_tac3-reg = wa_tac2-reg.
      wa_tac3-zm = wa_tac2-zm.
      wa_tac3-rm = wa_tac2-rm.
      wa_tac3-bzirk = wa_tac2-bzirk.
      wa_tac3-plans = wa_tac2-plans.
      collect wa_tac3 into it_tac3.
      clear wa_tac3 .
      select single * from pa0001 where plans eq wa_yterrallc-plans and begda le s_date and endda ge s_budat-low.
      if sy-subrc eq 0.
*        WRITE : pa0001-pernr.
        wa_tab3-pernr = pa0001-pernr.
        select single * from zthr_heq_des where zz_hqcode eq pa0001-zz_hqcode.
        if sy-subrc eq 0.
          wa_tab3-zz_hqdesc = zthr_heq_des-zz_hqdesc.
        endif.
      endif.
    endif.
    collect wa_tab3 into it_tab3.
    clear wa_tab3.
  endloop.

  loop at it_tab3 into wa_tab3 where pernr in pso .
    wa_tab31-reg = wa_tab3-reg.
    wa_tab31-zm = wa_tab3-zm.
    wa_tab31-rm = wa_tab3-rm.
    wa_tab31-bzirk = wa_tab3-bzirk.
    wa_tab31-spart = wa_tab3-spart.
    wa_tab31-plans = wa_tab3-plans.
    wa_tab31-pernr = wa_tab3-pernr.
*    WA_tab31-KUNNR = YSD_CUS_DIV_DIS-KUNNR.
*    WA_tab31-PERCNT = YSD_CUS_DIV_DIS-PERCNT.
    wa_tab31-zz_hqdesc = wa_tab3-zz_hqdesc.
    collect wa_tab31 into it_tab31.
    clear wa_tab31.
  endloop.
*    WRITE : / WA_TAB3-REG,WA_TAB3-ZM,WA_TAB3-RM,WA_TAB3-BZIRK,WA_TAB3-SPART,WA_TAB3-PLANS,WA_TAB3-PERNR.
  if it_tab31 is not initial.
    select * from ysd_cus_div_dis into table it_ysd_cus_div_dis for all entries in it_tab31 where bzirk eq
       it_tab31-bzirk and spart eq it_tab31-spart and begda le s_budat-low and endda ge s_budat-high.
  endif.
  loop at it_ysd_cus_div_dis into wa_ysd_cus_div_dis.
    read table it_tab3 into wa_tab3 with key bzirk = wa_ysd_cus_div_dis-bzirk spart = wa_ysd_cus_div_dis-spart.
    if sy-subrc eq 0.
      wa_tab4-reg = wa_tab3-reg.
      wa_tab4-zm = wa_tab3-zm.
      wa_tab4-rm = wa_tab3-rm.
      wa_tab4-bzirk = wa_tab3-bzirk.
      wa_tab4-spart = wa_tab3-spart.
      wa_tab4-plans = wa_tab3-plans.
      wa_tab4-pernr = wa_tab3-pernr.

      wa_tab4-kunnr = wa_ysd_cus_div_dis-kunnr.
      wa_tab4-percnt = wa_ysd_cus_div_dis-percnt.
      wa_tab4-zz_hqdesc = wa_tab3-zz_hqdesc.
      collect wa_tab4 into it_tab4.
      clear wa_tab4.
    endif.
  endloop.

  loop at it_tab4 into wa_tab4.
*    WRITE : / WA_TAB4-REG,WA_TAB4-RM,WA_TAB4-PLANS,WA_TAB4-PERNR,WA_TAB4-BZIRK,WA_TAB4-SPART,WA_TAB4-KUNNR,WA_TAB4-PERCNT.
    wa_tab5-kunnr = wa_tab4-kunnr.
    wa_tab5-spart = wa_tab4-spart.
    collect wa_tab5 into it_tab5.
    clear wa_tab5.
  endloop.

  sort it_tab5.
  delete adjacent duplicates from it_tab5.
*  LOOP AT IT_TAB5 INTO WA_TAB5.
*    WRITE : / WA_TAB5-KUNNR,WA_TAB5-SPART.
*  ENDLOOP.

  perform sale.
  perform zdistsale.
*  BREAK-POINT.
  if it_tab4 is not initial.
    loop at it_tab4 into wa_tab4.
*    WRITE : / 'o', WA_TAB4-REG,WA_TAB4-RM,WA_TAB4-PLANS,WA_TAB4-PERNR,WA_TAB4-BZIRK,
*    WA_TAB4-SPART,WA_TAB4-KUNNR,WA_TAB4-PERCNT.
      loop at it_tas2 into wa_tas2 where kunag eq wa_tab4-kunnr and spart = wa_tab4-spart.
        clear : val,qty.
*        BREAK-POINT.
*      WRITE : / wa_tas2-matnr.
        val = wa_tas2-pts * ( wa_tab4-percnt / 100 ).
        qty = wa_tas2-fkimg_s * ( wa_tab4-percnt / 100 ).
*      WRITE : val,qty.
        wa_tab6-reg = wa_tab4-reg.
        wa_tab6-rm = wa_tab4-rm.
        wa_tab6-zm = wa_tab4-zm.
        wa_tab6-plans = wa_tab4-plans.
        wa_tab6-pernr = wa_tab4-pernr.
        wa_tab6-bzirk = wa_tab4-bzirk.
        wa_tab6-matnr = wa_tas2-matnr.
        select single * from zprdgroup where rep_type eq 'SR121314' and prd_code eq wa_tas2-matnr.
        if sy-subrc eq 0.
          wa_tab6-grp_code = zprdgroup-grp_code.
        endif.
        select single * from yterrallc where bzirk eq wa_tab4-rm and begda le s_budat-low and endda ge s_budat-high.
        if sy-subrc eq 0.
          wa_tab6-rm_plans = yterrallc-plans.
        endif.
        wa_tab6-zz_hqdesc = wa_tab4-zz_hqdesc.
        select single * from makt where matnr eq wa_tas2-matnr and spras eq 'EN'.
        if sy-subrc eq 0.
          wa_tab6-maktx = makt-maktx.
        endif.
        select single * from mvke where matnr eq wa_tas2-matnr.
        if sy-subrc eq 0.
          select single * from tvm5t where spras eq 'EN' and mvgr5 eq mvke-mvgr5.
          if sy-subrc eq 0.
*          WRITE : TVM5T-BEZEI.
            wa_tab6-bezei = tvm5t-bezei.
          endif.
        endif.
        wa_tab6-sval = val.
        wa_tab6-qty = qty.
*****************************DIVISION*********************************
        select single * from zdsmter where zmonth eq month and zyear eq year and bzirk eq wa_tab4-bzirk and spart eq '50'.
        if sy-subrc eq 0.
          select single * from zdsmter where zmonth eq month and zyear eq year and bzirk eq wa_tab4-bzirk and spart eq '60'.
          if sy-subrc eq 0.
*        WRITE : 'BCL'.
            wa_tab6-div = 'BCL'.
          else.
*        WRITE : 'BC'.
            wa_tab6-div = 'BC'.
          endif.
        else.
          select single * from zdsmter where zmonth eq month and zyear eq year and bzirk eq wa_tab4-bzirk and spart eq '70'.
          if sy-subrc = 0.
            wa_tab6-div = 'BCLS'.
          else.
            wa_tab6-div = 'XL'.
          endif.
        endif.
***********************************************************************
        collect wa_tab6 into it_tab6.
        clear wa_tab6.
      endloop.
    endloop.
  endif.
*  sort it_tab6 by reg rm bzirk grp_code.

  loop at it_tab6 into wa_tab6.
    select single * from zprdgroup where prd_code = wa_tab6-matnr  and  rep_type = 'SR121314'.
    if sy-subrc = 0.
      wa_tab6-matkl = zprdgroup-grp_code.
      wa_tab6-grp_name = zprdgroup-grp_name.

      modify  it_tab6 from wa_tab6 transporting matkl grp_name.
    endif.
  endloop.

  sort it_tab6 by reg rm bzirk grp_name.
  if r1 eq 'X'.
**************** PSO LAYOUT**********
    call function 'OPEN_FORM'
      exporting
        device   = 'PRINTER'
        dialog   = 'X'
*       form     = 'ZSR9_1'
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
        form        = 'ZSA7_N'
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
    loop at it_tab6 into wa_tab6.

      on change of wa_tab6-bzirk.
        clear : pso_ename,rm_ename.
*      WRITE : / '*',  wa_tab6-bzirk,wa_tab6-plans, wa_tab6-zz_hqdesc.
        select single * from pa0001 where pernr eq wa_tab6-pernr.
        if sy-subrc eq 0.
          pso_ename = pa0001-ename.
        endif.
        select single * from pa0001 where plans eq wa_tab6-rm_plans and begda le s_date and endda ge s_budat-low.
        if sy-subrc eq 0.
          rm_ename = pa0001-ename.
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
*    WRITE : / wa_tab6-matnr,WA_TAB6-MAKTX,WA_TAB6-BEZEI,wa_tab6-sval,wa_tab6-qty.
      g_qty = g_qty + wa_tab6-qty.
      g_sval = g_sval + wa_tab6-sval.
      count = count + 1.
      pso_tot = pso_tot + wa_tab6-sval.
      call function 'WRITE_FORM'
        exporting
          element = 'PSO1'
          window  = 'MAIN'.
      at end of matkl.
        tgt = 0.
        mtpt = 0.
        select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq year1.
        if sy-subrc = 0.
          if month = '01'.
            tgt =  ysd_dist_targt-month10.
          elseif month = '02'.
            tgt =  ysd_dist_targt-month11.
          elseif month = '03'.
            tgt =  ysd_dist_targt-month12.
          elseif month = '04'.
            tgt =  ysd_dist_targt-month01.
          elseif month = '05'.
            tgt =  ysd_dist_targt-month02.
          elseif month = '06'.
            tgt =  ysd_dist_targt-month03.
          elseif month = '07'.
            tgt =  ysd_dist_targt-month04.
          elseif month = '08'.
            tgt =  ysd_dist_targt-month05.
          elseif month = '09'.
            tgt =  ysd_dist_targt-month06.
          elseif month = '10'.
            tgt =  ysd_dist_targt-month07.
          elseif month = '11'.
            tgt =  ysd_dist_targt-month08.
          elseif month = '12'.
            tgt =  ysd_dist_targt-month09.

          endif.
          select single * from zmtpt where begda le s_budat-low and endda ge s_budat-low and from_amt le tgt and to_amt ge tgt and matkl eq wa_tab6-matkl.
          if sy-subrc = 0.
            mtpt = zmtpt-target.
          endif.
        endif.
        if count gt 1.
          call function 'WRITE_FORM'
            exporting
              element = 'GRP1'
              window  = 'MAIN'.
        else.
          call function 'WRITE_FORM'
            exporting
              element = 'GRP2'
              window  = 'MAIN'.
        endif.
        g_qty = 0.
        g_sval = 0.
        count = 0.
      endat.
      at end of bzirk.
        call function 'WRITE_FORM'
          exporting
            element = 'PSO_TOT'
            window  = 'MAIN'.
        pso_tot = 0.
      endat.
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

  elseif r2 eq 'X'.
*********EMAIL TO PSO**********

    loop at it_tab6 into wa_tab6.
      wa_tam1-pernr = wa_tab6-pernr.
      collect wa_tam1 into it_tam1.
      clear wa_tam1.
    endloop.
    sort it_tam1.
    delete adjacent duplicates from it_tam1.
    loop at it_tam1 into wa_tam1.
      select single * from pa0105 where pernr eq wa_tam1-pernr and subty eq '0010'.
      if sy-subrc eq 0.
        wa_tam2-pernr = wa_tam1-pernr.
        wa_tam2-usrid_long = pa0105-usrid_long.
        collect wa_tam2 into it_tam2.
        clear wa_tam2.
      endif.
    endloop.

    options-tdgetotf = 'X'.

    loop at it_tam1 into wa_tam1.
      call function 'OPEN_FORM'
        exporting
          device   = 'PRINTER'
          dialog   = ''
*         form     = 'ZSR9_1'
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
          form        = 'ZSA7_N'
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


      loop at it_tab6 into wa_tab6 where pernr eq wa_tam1-pernr.
*        WRITE : / wa_tab6-pernr.
        on change of wa_tab6-bzirk.
          clear : pso_ename,rm_ename.
*      WRITE : / '*',  wa_tab6-bzirk,wa_tab6-plans, wa_tab6-zz_hqdesc.
          select single * from pa0001 where pernr eq wa_tab6-pernr.
          if sy-subrc eq 0.
            pso_ename = pa0001-ename.
          endif.
          select single * from pa0001 where plans eq wa_tab6-rm_plans and begda le s_date and endda ge s_budat-low.
          if sy-subrc eq 0.
            rm_ename = pa0001-ename.
          endif.
          page1 = 1.
          page3 = page1 + page2.
*          IF PAGE2 GE 1.
          call function 'WRITE_FORM'
            exporting
              element = 'HEAD'
              window  = 'MAIN'.
*          ELSE.
*            call function 'WRITE_FORM'
*              EXPORTING
*                element = 'HEAD1'
*                window  = 'MAIN'.
*          ENDIF.
          page1 = page1 + 1.
          page2 = page2 + 1.
        endon.
*    WRITE : / wa_tab6-matnr,WA_TAB6-MAKTX,WA_TAB6-BEZEI,wa_tab6-sval,wa_tab6-qty.
        g_qty = g_qty + wa_tab6-qty.
        g_sval = g_sval + wa_tab6-sval.
        pso_tot = pso_tot + wa_tab6-sval.
        call function 'WRITE_FORM'
          exporting
            element = 'PSO1'
            window  = 'MAIN'.
        at end of matkl.
          tgt = 0.
          mtpt = 0.
          select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq year1.
          if sy-subrc = 0.
            if month = '01'.
              tgt =  ysd_dist_targt-month10.
            elseif month = '02'.
              tgt =  ysd_dist_targt-month11.
            elseif month = '03'.
              tgt =  ysd_dist_targt-month12.
            elseif month = '04'.
              tgt =  ysd_dist_targt-month01.
            elseif month = '05'.
              tgt =  ysd_dist_targt-month02.
            elseif month = '06'.
              tgt =  ysd_dist_targt-month03.
            elseif month = '07'.
              tgt =  ysd_dist_targt-month04.
            elseif month = '08'.
              tgt =  ysd_dist_targt-month05.
            elseif month = '09'.
              tgt =  ysd_dist_targt-month06.
            elseif month = '10'.
              tgt =  ysd_dist_targt-month07.
            elseif month = '11'.
              tgt =  ysd_dist_targt-month08.
            elseif month = '12'.
              tgt =  ysd_dist_targt-month09.

            endif.
            select single * from zmtpt where begda le s_budat-low and endda ge s_budat-low and from_amt le tgt and to_amt ge tgt and matkl eq wa_tab6-matkl.
            if sy-subrc = 0.
              mtpt = zmtpt-target.
            endif.
          endif.










          call function 'WRITE_FORM'
            exporting
              element = 'GRP1'
              window  = 'MAIN'.
          g_qty = 0.
          g_sval = 0.
        endat.
        at end of bzirk.
          call function 'WRITE_FORM'
            exporting
              element = 'PSO_TOT'
              window  = 'MAIN'.
          pso_tot = 0.
        endat.
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

      write s_budat-low to wa_d1 dd/mm/yyyy.
      write s_budat-high to wa_d2 dd/mm/yyyy.

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
      concatenate 'SA-7 FROM:' wa_d1 'TO ' wa_d2  into doc_chng-obj_descr separated by space.
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

      concatenate 'SA-7' '.' into objpack-obj_descr separated by space.
      objpack-doc_size = righe_attachment * 255.
      append objpack.
      clear objpack.

      loop at it_tam2 into wa_tam2 where pernr = wa_tam1-pernr.
        reclist-receiver =   wa_tam2-usrid_long.
        reclist-express = 'X'.
        reclist-rec_type = 'U'.
        reclist-notif_del = 'X'. " request delivery notification
        reclist-notif_ndel = 'X'. " request not delivered notification
        append reclist.
        clear reclist.
      endloop.
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
*           COMMIT_WORK                = ' '
* IMPORTING
*           SENT_TO_ALL                =
*           NEW_OBJECT_ID              =
*           SENDER_ID                  =
          tables
            packing_list               = objpack
*           OBJECT_HEADER              =
            contents_bin               = objbin
            contents_txt               = objtxt
*           CONTENTS_HEX               =
*           OBJECT_PARA                =
*           OBJECT_PARB                =
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

          write : / 'EMAIL SENT ON ',wa_tam2-usrid_long.
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
    loop at it_tam1 into wa_tam1.
      read table it_tam2 into wa_tam2 with key  pernr = wa_tam1-pernr .
      if sy-subrc eq 4.
        format color 6.
        write : / 'EMAIL ID NOT MAINTAINED FOR EMP. CODE :',wa_tam1-pernr.
      endif.
    endloop.



  elseif r3 eq 'X'.

********************PSO ALV PRINT OUT ***********************

    loop at it_tab6 into wa_tab6.
*      WRITE : / wa_tab6-pernr.
      wa_tab7-pernr = wa_tab6-pernr.
      select single * from pa0001 where pernr eq wa_tab6-pernr.
      if sy-subrc eq 0.
*        WRITE : pa0001-ename.
        wa_tab7-ename = pa0001-ename.
      endif.
*      WRITE :  wa_tab6-plans, wa_tab6-bzirk,wa_tab6-zz_hqdesc,  WA_TAB6-DIV,WA_TAB6-BEZEI, wa_tab6-matnr,
*       WA_TAB6-MAKTX,wa_tab6-sval,wa_tab6-qty,wa_tab6-rm, wa_tab6-rm_plans, wa_tab6-reg.
      wa_tab7-plans = wa_tab6-plans.
      wa_tab7-bzirk = wa_tab6-bzirk.
      wa_tab7-zz_hqdesc = wa_tab6-zz_hqdesc.
      wa_tab7-div = wa_tab6-div.
      wa_tab7-bezei = wa_tab6-bezei.
      wa_tab7-matnr = wa_tab6-matnr.
      wa_tab7-maktx = wa_tab6-maktx.
      wa_tab7-sval = wa_tab6-sval.
      wa_tab7-qty = wa_tab6-qty.
      wa_tab7-rm = wa_tab6-rm.
      wa_tab7-rm_plans = wa_tab6-rm_plans.
      wa_tab7-reg = wa_tab6-reg.

      select single * from pa0001 where plans eq wa_tab6-rm_plans and begda le s_budat-high and endda ge s_budat-high.
      if sy-subrc eq 0.
*        WRITE : pa0001-ename.
        wa_tab7-rm_ename = pa0001-ename.
      endif.
      select single * from yterrallc where bzirk eq wa_tab6-reg and begda le s_budat-low and endda ge s_budat-high.
      if sy-subrc eq 0.
        select single * from pa0001 where plans eq yterrallc-plans and begda le s_budat-high and endda ge s_budat-high.
        if sy-subrc eq 0.
*          WRITE : pa0001-ename.
          wa_tab7-zm_ename = pa0001-ename.
        endif.
      endif.

      collect wa_tab7 into it_tab7.
      clear wa_tab7.
    endloop.

    loop at it_tab7 into wa_tab7.
      pack wa_tab7-matnr to wa_tab7-matnr.
      condense wa_tab7-matnr.
      modify it_tab7 from wa_tab7 transporting matnr.
    endloop.

    wa_fieldcat-fieldname = 'PERNR'.
    wa_fieldcat-seltext_l = 'PSO CODE'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'ENAME'.
    wa_fieldcat-seltext_l = 'PSO NAME'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'PLANS'.
    wa_fieldcat-seltext_l = 'PSO POSITION CODE'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'BZIRK'.
    wa_fieldcat-seltext_l = 'PSO TERITTORY CODE'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'ZZ_HQDESC'.
    wa_fieldcat-seltext_l = 'PSO HQRT.'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'DIV'.
    wa_fieldcat-seltext_l = 'PSO DIVISION'.
    append wa_fieldcat to fieldcat.
*
    wa_fieldcat-fieldname = 'BEZEI'.
    wa_fieldcat-seltext_l = 'PACK SIZE'.
    append wa_fieldcat to fieldcat.
*
*
    wa_fieldcat-fieldname = 'MATNR'.
    wa_fieldcat-seltext_l = 'PRODUCT CODE'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'MAKTX'.
    wa_fieldcat-seltext_l = 'PRODUCT NAME'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'SVAL'.
    wa_fieldcat-seltext_l = 'GROSS VALUE'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'QTY'.
    wa_fieldcat-seltext_l = 'QUANTITY'.
    append wa_fieldcat to fieldcat.
*
    wa_fieldcat-fieldname = 'RM_ENAME'.
    wa_fieldcat-seltext_l = 'RM NAME'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'RM'.
    wa_fieldcat-seltext_l = 'RM CODE'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'ZM_ENAME'.
    wa_fieldcat-seltext_l = 'ZM NAME'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'ZM'.
    wa_fieldcat-seltext_l = 'ZM CODE'.
    append wa_fieldcat to fieldcat.




    layout-zebra = 'X'.
    layout-colwidth_optimize = 'X'.
    layout-window_titlebar  = 'PSO GROSS SALE DETAILS'.


    call function 'REUSE_ALV_GRID_DISPLAY'
      exporting
*       I_INTERFACE_CHECK       = ' '
*       I_BYPASSING_BUFFER      = ' '
*       I_BUFFER_ACTIVE         = ' '
        i_callback_program      = g_repid
*       I_CALLBACK_PF_STATUS_SET          = ' '
        i_callback_user_command = 'USER_COMM'
        i_callback_top_of_page  = 'TOP'
*       I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*       I_CALLBACK_HTML_END_OF_LIST       = ' '
*       I_STRUCTURE_NAME        =
*       I_BACKGROUND_ID         = ' '
*       I_GRID_TITLE            =
*       I_GRID_SETTINGS         =
        is_layout               = layout
        it_fieldcat             = fieldcat
*       IT_EXCLUDING            =
*       IT_SPECIAL_GROUPS       =
*       IT_SORT                 =
*       IT_FILTER               =
*       IS_SEL_HIDE             =
*       I_DEFAULT               = 'X'
        i_save                  = 'A'
*       IS_VARIANT              =
*       IT_EVENTS               =
*       IT_EVENT_EXIT           =
*       IS_PRINT                =
*       IS_REPREP_ID            =
*       I_SCREEN_START_COLUMN   = 0
*       I_SCREEN_START_LINE     = 0
*       I_SCREEN_END_COLUMN     = 0
*       I_SCREEN_END_LINE       = 0
*       I_HTML_HEIGHT_TOP       = 0
*       I_HTML_HEIGHT_END       = 0
*       IT_ALV_GRAPHICS         =
*       IT_HYPERLINK            =
*       IT_ADD_FIELDCAT         =
*       IT_EXCEPT_QINFO         =
*       IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*       E_EXIT_CAUSED_BY_CALLER =
*       ES_EXIT_CAUSED_BY_USER  =
      tables
        t_outtab                = it_tab7
      exceptions
        program_error           = 1
        others                  = 2.
    if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.



  elseif r4 eq 'X'.
*******EMAIL TO RM/******

    loop at it_tab6 into wa_tab6.
      select single * from yterrallc  where bzirk eq wa_tab6-rm and begda le s_budat-low and endda ge s_budat-high.
      if sy-subrc eq 0.
        select single * from pa0001 where plans eq yterrallc-plans and begda le s_date and endda ge s_budat-high.
        if sy-subrc eq 0.
          wa_tam1-pernr = pa0001-pernr.
          wa_tam1-rm = wa_tab6-rm.
        endif.
      endif.
      collect wa_tam1 into it_tam1.
      clear wa_tam1.
    endloop.

    sort it_tam1.
    delete adjacent duplicates from it_tam1.
    loop at it_tam1 into wa_tam1.
      select single * from pa0105 where pernr eq wa_tam1-pernr and subty eq '0010'.
      if sy-subrc eq 0.
        wa_tam2-pernr = wa_tam1-pernr.
        wa_tam2-usrid_long = pa0105-usrid_long.
        collect wa_tam2 into it_tam2.
        clear wa_tam2.
      endif.
    endloop.

    options-tdgetotf = 'X'.

    loop at it_tam1 into wa_tam1 where pernr ne 0.
      call function 'OPEN_FORM'
        exporting
          device   = 'PRINTER'
          dialog   = ''
*         form     = 'ZSR9_1'
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
          form        = 'ZSA7_N'
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


      loop at it_tab6 into wa_tab6 where rm eq wa_tam1-rm.
*        WRITE : / wa_tab6-pernr.
        on change of wa_tab6-bzirk.
          clear : pso_ename,rm_ename.
*      WRITE : / '*',  wa_tab6-bzirk,wa_tab6-plans, wa_tab6-zz_hqdesc.
          select single * from pa0001 where pernr eq wa_tab6-pernr.
          if sy-subrc eq 0.
            pso_ename = pa0001-ename.
          endif.
          select single * from pa0001 where plans eq wa_tab6-rm_plans and begda le s_date and endda ge s_budat-low.
          if sy-subrc eq 0.
            rm_ename = pa0001-ename.
          endif.
          page1 = 1.
          page3 = page1 + page2.
*          IF PAGE2 GE 1.
          call function 'WRITE_FORM'
            exporting
              element = 'HEAD'
              window  = 'MAIN'.
*          ELSE.
*            call function 'WRITE_FORM'
*              EXPORTING
*                element = 'HEAD1'
*                window  = 'MAIN'.
*          ENDIF.
          page1 = page1 + 1.
          page2 = page2 + 1.
        endon.
*    WRITE : / wa_tab6-matnr,WA_TAB6-MAKTX,WA_TAB6-BEZEI,wa_tab6-sval,wa_tab6-qty.
        g_qty = g_qty + wa_tab6-qty.
        g_sval = g_sval + wa_tab6-sval.
        pso_tot = pso_tot + wa_tab6-sval.
        call function 'WRITE_FORM'
          exporting
            element = 'PSO1'
            window  = 'MAIN'.
        at end of matkl.
          tgt = 0.
          mtpt = 0.
          select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq year1.
          if sy-subrc = 0.
            if month = '01'.
              tgt =  ysd_dist_targt-month10.
            elseif month = '02'.
              tgt =  ysd_dist_targt-month11.
            elseif month = '03'.
              tgt =  ysd_dist_targt-month12.
            elseif month = '04'.
              tgt =  ysd_dist_targt-month01.
            elseif month = '05'.
              tgt =  ysd_dist_targt-month02.
            elseif month = '06'.
              tgt =  ysd_dist_targt-month03.
            elseif month = '07'.
              tgt =  ysd_dist_targt-month04.
            elseif month = '08'.
              tgt =  ysd_dist_targt-month05.
            elseif month = '09'.
              tgt =  ysd_dist_targt-month06.
            elseif month = '10'.
              tgt =  ysd_dist_targt-month07.
            elseif month = '11'.
              tgt =  ysd_dist_targt-month08.
            elseif month = '12'.
              tgt =  ysd_dist_targt-month09.

            endif.
            select single * from zmtpt where begda le s_budat-low and endda ge s_budat-low and from_amt le tgt and to_amt ge tgt and matkl eq wa_tab6-matkl.
            if sy-subrc = 0.
              mtpt = zmtpt-target.
            endif.
          endif.











          call function 'WRITE_FORM'
            exporting
              element = 'GRP1'
              window  = 'MAIN'.
          g_qty = 0.
          g_sval = 0.
        endat.
        at end of bzirk.
          call function 'WRITE_FORM'
            exporting
              element = 'PSO_TOT'
              window  = 'MAIN'.
          pso_tot = 0.
        endat.
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

      write s_budat-low to wa_d1 dd/mm/yyyy.
      write s_budat-high to wa_d2 dd/mm/yyyy.

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
      concatenate 'SA-7 FROM:' wa_d1 'TO ' wa_d2  into doc_chng-obj_descr separated by space.
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

      concatenate 'SA-7' '.' into objpack-obj_descr separated by space.
      objpack-doc_size = righe_attachment * 255.
      append objpack.
      clear objpack.

      loop at it_tam2 into wa_tam2 where pernr = wa_tam1-pernr.
        reclist-receiver =   wa_tam2-usrid_long.
        reclist-express = 'X'.
        reclist-rec_type = 'U'.
        reclist-notif_del = 'X'. " request delivery notification
        reclist-notif_ndel = 'X'. " request not delivered notification
        append reclist.
        clear reclist.
      endloop.
      describe table reclist lines mcount.
      if mcount > 0.
*        data: sender like soextreci1-receiver.
***ADDED BY SATHISH.B
*        types: begin of t_usr21,
*             bname type usr21-bname,
*             persnumber type usr21-persnumber,
*             addrnumber type usr21-addrnumber,
*            end of t_usr21.
*
*        types: begin of t_adr6,
*                 addrnumber type usr21-addrnumber,
*                 persnumber type usr21-persnumber,
*                 smtp_addr type adr6-smtp_addr,
*                end of t_adr6.
*
*        data: it_usr21 type table of t_usr21,
*              wa_usr21 type t_usr21,
*              it_adr6 type table of t_adr6,
*              wa_adr6 type t_adr6.
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
*           COMMIT_WORK                = ' '
* IMPORTING
*           SENT_TO_ALL                =
*           NEW_OBJECT_ID              =
*           SENDER_ID                  =
          tables
            packing_list               = objpack
*           OBJECT_HEADER              =
            contents_bin               = objbin
            contents_txt               = objtxt
*           CONTENTS_HEX               =
*           OBJECT_PARA                =
*           OBJECT_PARB                =
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

          write : / 'EMAIL SENT ON ',wa_tam2-usrid_long.
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
    loop at it_tam1 into wa_tam1.
      read table it_tam2 into wa_tam2 with key  pernr = wa_tam1-pernr .
      if sy-subrc eq 4.
        format color 6.
        write : / 'EMAIL ID NOT MAINTAINED FOR EMP. CODE :',wa_tam1-pernr.
      endif.
    endloop.




  elseif r7 eq 'X'.
*******EMAIL TO RM/******

    loop at it_tab6 into wa_tab6.
      select single * from yterrallc  where bzirk eq wa_tab6-zm and begda le s_budat-low and endda ge s_budat-high.
      if sy-subrc eq 0.
        select single * from pa0001 where plans eq yterrallc-plans and begda le s_date and endda ge s_budat-high.
        if sy-subrc eq 0.
          wa_tam1-pernr = pa0001-pernr.
          wa_tam1-rm = wa_tab6-zm.
        endif.
      endif.
      collect wa_tam1 into it_tam1.
      clear wa_tam1.
    endloop.

    sort it_tam1.
    delete adjacent duplicates from it_tam1.
    loop at it_tam1 into wa_tam1.
      select single * from pa0105 where pernr eq wa_tam1-pernr and subty eq '0010'.
      if sy-subrc eq 0.
        wa_tam2-pernr = wa_tam1-pernr.
        wa_tam2-usrid_long = pa0105-usrid_long.
        collect wa_tam2 into it_tam2.
        clear wa_tam2.
      endif.
    endloop.

    options-tdgetotf = 'X'.

    loop at it_tam1 into wa_tam1 where pernr ne 0.
      call function 'OPEN_FORM'
        exporting
          device   = 'PRINTER'
          dialog   = ''
*         form     = 'ZSR9_1'
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
          form        = 'ZSA7_N'
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


      loop at it_tab6 into wa_tab6 where zm eq wa_tam1-rm.
*        WRITE : / wa_tab6-pernr.
        on change of wa_tab6-bzirk.
          clear : pso_ename,rm_ename.
*      WRITE : / '*',  wa_tab6-bzirk,wa_tab6-plans, wa_tab6-zz_hqdesc.
          select single * from pa0001 where pernr eq wa_tab6-pernr.
          if sy-subrc eq 0.
            pso_ename = pa0001-ename.
          endif.
          select single * from pa0001 where plans eq wa_tab6-rm_plans and begda le s_date and endda ge s_budat-low.
          if sy-subrc eq 0.
            rm_ename = pa0001-ename.
          endif.
          page1 = 1.
          page3 = page1 + page2.
*          IF PAGE2 GE 1.
          call function 'WRITE_FORM'
            exporting
              element = 'HEAD'
              window  = 'MAIN'.
*          ELSE.
*            call function 'WRITE_FORM'
*              EXPORTING
*                element = 'HEAD1'
*                window  = 'MAIN'.
*          ENDIF.
          page1 = page1 + 1.
          page2 = page2 + 1.
        endon.
*    WRITE : / wa_tab6-matnr,WA_TAB6-MAKTX,WA_TAB6-BEZEI,wa_tab6-sval,wa_tab6-qty.
        g_qty = g_qty + wa_tab6-qty.
        g_sval = g_sval + wa_tab6-sval.
        pso_tot = pso_tot + wa_tab6-sval.
        call function 'WRITE_FORM'
          exporting
            element = 'PSO1'
            window  = 'MAIN'.
        at end of matkl.
          tgt = 0.
          mtpt = 0.
          select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq year1.
          if sy-subrc = 0.
            if month = '01'.
              tgt =  ysd_dist_targt-month10.
            elseif month = '02'.
              tgt =  ysd_dist_targt-month11.
            elseif month = '03'.
              tgt =  ysd_dist_targt-month12.
            elseif month = '04'.
              tgt =  ysd_dist_targt-month01.
            elseif month = '05'.
              tgt =  ysd_dist_targt-month02.
            elseif month = '06'.
              tgt =  ysd_dist_targt-month03.
            elseif month = '07'.
              tgt =  ysd_dist_targt-month04.
            elseif month = '08'.
              tgt =  ysd_dist_targt-month05.
            elseif month = '09'.
              tgt =  ysd_dist_targt-month06.
            elseif month = '10'.
              tgt =  ysd_dist_targt-month07.
            elseif month = '11'.
              tgt =  ysd_dist_targt-month08.
            elseif month = '12'.
              tgt =  ysd_dist_targt-month09.

            endif.
            select single * from zmtpt where begda le s_budat-low and endda ge s_budat-low and from_amt le tgt and to_amt ge tgt and matkl eq wa_tab6-matkl.
            if sy-subrc = 0.
              mtpt = zmtpt-target.
            endif.
          endif.











          call function 'WRITE_FORM'
            exporting
              element = 'GRP1'
              window  = 'MAIN'.
          g_qty = 0.
          g_sval = 0.
        endat.
        at end of bzirk.
          call function 'WRITE_FORM'
            exporting
              element = 'PSO_TOT'
              window  = 'MAIN'.
          pso_tot = 0.
        endat.
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

      write s_budat-low to wa_d1 dd/mm/yyyy.
      write s_budat-high to wa_d2 dd/mm/yyyy.

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
      concatenate 'SA-7 FROM:' wa_d1 'TO ' wa_d2  into doc_chng-obj_descr separated by space.
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

      concatenate 'SA-7' '.' into objpack-obj_descr separated by space.
      objpack-doc_size = righe_attachment * 255.
      append objpack.
      clear objpack.

      loop at it_tam2 into wa_tam2 where pernr = wa_tam1-pernr.
        reclist-receiver =   wa_tam2-usrid_long.
        reclist-express = 'X'.
        reclist-rec_type = 'U'.
        reclist-notif_del = 'X'. " request delivery notification
        reclist-notif_ndel = 'X'. " request not delivered notification
        append reclist.
        clear reclist.
      endloop.
      describe table reclist lines mcount.
      if mcount > 0.
*        data: sender like soextreci1-receiver.
***ADDED BY SATHISH.B
*        types: begin of t_usr21,
*             bname type usr21-bname,
*             persnumber type usr21-persnumber,
*             addrnumber type usr21-addrnumber,
*            end of t_usr21.
*
*        types: begin of t_adr6,
*                 addrnumber type usr21-addrnumber,
*                 persnumber type usr21-persnumber,
*                 smtp_addr type adr6-smtp_addr,
*                end of t_adr6.
*
*        data: it_usr21 type table of t_usr21,
*              wa_usr21 type t_usr21,
*              it_adr6 type table of t_adr6,
*              wa_adr6 type t_adr6.
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
*           COMMIT_WORK                = ' '
* IMPORTING
*           SENT_TO_ALL                =
*           NEW_OBJECT_ID              =
*           SENDER_ID                  =
          tables
            packing_list               = objpack
*           OBJECT_HEADER              =
            contents_bin               = objbin
            contents_txt               = objtxt
*           CONTENTS_HEX               =
*           OBJECT_PARA                =
*           OBJECT_PARB                =
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

          write : / 'EMAIL SENT ON ',wa_tam2-usrid_long.
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
    loop at it_tam1 into wa_tam1.
      read table it_tam2 into wa_tam2 with key  pernr = wa_tam1-pernr .
      if sy-subrc eq 4.
        format color 6.
        write : / 'EMAIL ID NOT MAINTAINED FOR EMP. CODE :',wa_tam1-pernr.
      endif.
    endloop.









  elseif r5 eq 'X'.
*******EMAIL TO ZM******


    loop at it_tab6 into wa_tab6.
      select single * from yterrallc  where bzirk eq wa_tab6-reg and begda le s_budat-low and endda ge s_budat-high.
      if sy-subrc eq 0.
        select single * from pa0001 where plans eq yterrallc-plans and begda le s_date and endda ge s_budat-high.
        if sy-subrc eq 0.
          wa_tam1-pernr = pa0001-pernr.
*          WA_TAM1-Reg = WA_TAB6-Reg.
        endif.
      endif.
      collect wa_tam1 into it_tam1.
      clear wa_tam1.
    endloop.

    sort it_tam1.
    delete adjacent duplicates from it_tam1.
    delete it_tam1 where pernr = 0.

    loop at it_tam1 into wa_tam1.
      select single * from pa0105 where pernr eq wa_tam1-pernr and subty eq '0010'.
      if sy-subrc eq 0.
        wa_tam2-pernr = wa_tam1-pernr.
        wa_tam2-usrid_long = pa0105-usrid_long.
        collect wa_tam2 into it_tam2.
        clear wa_tam2.
      endif.
    endloop.

    options-tdgetotf = 'X'.

*    loop at it_tam1 into wa_tam1.
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
        form        = 'ZSA7_N'
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


    loop at it_tab6 into wa_tab6 .
*        WRITE : / wa_tab6-pernr.
      on change of wa_tab6-bzirk.
        clear : pso_ename,rm_ename.
*      WRITE : / '*',  wa_tab6-bzirk,wa_tab6-plans, wa_tab6-zz_hqdesc.
        select single * from pa0001 where pernr eq wa_tab6-pernr.
        if sy-subrc eq 0.
          pso_ename = pa0001-ename.
        endif.
        select single * from pa0001 where plans eq wa_tab6-rm_plans and begda le s_date and endda ge s_budat-low.
        if sy-subrc eq 0.
          rm_ename = pa0001-ename.
        endif.
        page1 = 1.
        page3 = page1 + page2.
*          IF PAGE2 GE 1.
        call function 'WRITE_FORM'
          exporting
            element = 'HEAD'
            window  = 'MAIN'.
*          ELSE.
*            call function 'WRITE_FORM'
*              EXPORTING
*                element = 'HEAD1'
*                window  = 'MAIN'.
*          ENDIF.
        page1 = page1 + 1.
        page2 = page2 + 1.
      endon.

*    WRITE : / wa_tab6-matnr,WA_TAB6-MAKTX,WA_TAB6-BEZEI,wa_tab6-sval,wa_tab6-qty.
      g_qty = g_qty + wa_tab6-qty.
      g_sval = g_sval + wa_tab6-sval.
      pso_tot = pso_tot + wa_tab6-sval.
      call function 'WRITE_FORM'
        exporting
          element = 'PSO1'
          window  = 'MAIN'.
      at end of matkl.

        tgt = 0.
        mtpt = 0.
        select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq year1.
        if sy-subrc = 0.
          if month = '01'.
            tgt =  ysd_dist_targt-month10.
          elseif month = '02'.
            tgt =  ysd_dist_targt-month11.
          elseif month = '03'.
            tgt =  ysd_dist_targt-month12.
          elseif month = '04'.
            tgt =  ysd_dist_targt-month01.
          elseif month = '05'.
            tgt =  ysd_dist_targt-month02.
          elseif month = '06'.
            tgt =  ysd_dist_targt-month03.
          elseif month = '07'.
            tgt =  ysd_dist_targt-month04.
          elseif month = '08'.
            tgt =  ysd_dist_targt-month05.
          elseif month = '09'.
            tgt =  ysd_dist_targt-month06.
          elseif month = '10'.
            tgt =  ysd_dist_targt-month07.
          elseif month = '11'.
            tgt =  ysd_dist_targt-month08.
          elseif month = '12'.
            tgt =  ysd_dist_targt-month09.

          endif.
          select single * from zmtpt where begda le s_budat-low and endda ge s_budat-low and from_amt le tgt and to_amt ge tgt and matkl eq wa_tab6-matkl.
          if sy-subrc = 0.
            mtpt = zmtpt-target.
          endif.
        endif.







        call function 'WRITE_FORM'
          exporting
            element = 'GRP1'
            window  = 'MAIN'.
        g_qty = 0.
        g_sval = 0.
      endat.
      at end of bzirk.
        call function 'WRITE_FORM'
          exporting
            element = 'PSO_TOT'
            window  = 'MAIN'.
        pso_tot = 0.
      endat.
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

    write s_budat-low to wa_d1 dd/mm/yyyy.
    write s_budat-high to wa_d2 dd/mm/yyyy.

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
    concatenate 'SA-7 FROM:' wa_d1 'TO ' wa_d2  into doc_chng-obj_descr separated by space.
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

    concatenate 'SA-7' '.' into objpack-obj_descr separated by space.
    objpack-doc_size = righe_attachment * 255.
    append objpack.
    clear objpack.

    loop at it_tam2 into wa_tam2 where pernr = wa_tam1-pernr.
      reclist-receiver =   wa_tam2-usrid_long.
      reclist-express = 'X'.
      reclist-rec_type = 'U'.
      reclist-notif_del = 'X'. " request delivery notification
      reclist-notif_ndel = 'X'. " request not delivered notification
      append reclist.
      clear reclist.
    endloop.
    describe table reclist lines mcount.
    if mcount > 0.
*        data: sender like soextreci1-receiver.
***ADDED BY SATHISH.B
*        types: begin of t_usr21,
*             bname type usr21-bname,
*             persnumber type usr21-persnumber,
*             addrnumber type usr21-addrnumber,
*            end of t_usr21.
*
*        types: begin of t_adr6,
*                 addrnumber type usr21-addrnumber,
*                 persnumber type usr21-persnumber,
*                 smtp_addr type adr6-smtp_addr,
*                end of t_adr6.
*
*        data: it_usr21 type table of t_usr21,
*              wa_usr21 type t_usr21,
*              it_adr6 type table of t_adr6,
*              wa_adr6 type t_adr6.
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

        write : / 'EMAIL SENT ON ',wa_tam2-usrid_long.
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

*    endloop.
    loop at it_tam1 into wa_tam1.
      read table it_tam2 into wa_tam2 with key  pernr = wa_tam1-pernr .
      if sy-subrc eq 4.
        format color 6.
        write : / 'EMAIL ID NOT MAINTAINED FOR EMP. CODE :',wa_tam1-pernr.
      endif.
    endloop.



  elseif r6 eq 'X'.
***EMAIL TO SPECIFIC**********




    options-tdgetotf = 'X'.

*    loop at it_tam1 into wa_tam1.
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
        form        = 'ZSA7_N'
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


    loop at it_tab6 into wa_tab6 .
*        WRITE : / wa_tab6-pernr.
      on change of wa_tab6-bzirk.
        clear : pso_ename,rm_ename.
*      WRITE : / '*',  wa_tab6-bzirk,wa_tab6-plans, wa_tab6-zz_hqdesc.
        select single * from pa0001 where pernr eq wa_tab6-pernr.
        if sy-subrc eq 0.
          pso_ename = pa0001-ename.
        endif.
        select single * from pa0001 where plans eq wa_tab6-rm_plans and begda le s_date and endda ge s_budat-low.
        if sy-subrc eq 0.
          rm_ename = pa0001-ename.
        endif.
        page1 = 1.
        page3 = page1 + page2.
*          IF PAGE2 GE 1.
        call function 'WRITE_FORM'
          exporting
            element = 'HEAD'
            window  = 'MAIN'.
*          ELSE.
*            call function 'WRITE_FORM'
*              EXPORTING
*                element = 'HEAD1'
*                window  = 'MAIN'.
*          ENDIF.
        page1 = page1 + 1.
        page2 = page2 + 1.
      endon.
*    WRITE : / wa_tab6-matnr,WA_TAB6-MAKTX,WA_TAB6-BEZEI,wa_tab6-sval,wa_tab6-qty.
      g_qty = g_qty + wa_tab6-qty.
      g_sval = g_sval + wa_tab6-sval.
      pso_tot = pso_tot + wa_tab6-sval.
      call function 'WRITE_FORM'
        exporting
          element = 'PSO1'
          window  = 'MAIN'.
      at end of matkl.
        tgt = 0.
        mtpt = 0.
        select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq year1.
        if sy-subrc = 0.
          if month = '01'.
            tgt =  ysd_dist_targt-month10.
          elseif month = '02'.
            tgt =  ysd_dist_targt-month11.
          elseif month = '03'.
            tgt =  ysd_dist_targt-month12.
          elseif month = '04'.
            tgt =  ysd_dist_targt-month01.
          elseif month = '05'.
            tgt =  ysd_dist_targt-month02.
          elseif month = '06'.
            tgt =  ysd_dist_targt-month03.
          elseif month = '07'.
            tgt =  ysd_dist_targt-month04.
          elseif month = '08'.
            tgt =  ysd_dist_targt-month05.
          elseif month = '09'.
            tgt =  ysd_dist_targt-month06.
          elseif month = '10'.
            tgt =  ysd_dist_targt-month07.
          elseif month = '11'.
            tgt =  ysd_dist_targt-month08.
          elseif month = '12'.
            tgt =  ysd_dist_targt-month09.

          endif.
          select single * from zmtpt where begda le s_budat-low and endda ge s_budat-low and from_amt le tgt and to_amt ge tgt and matkl eq wa_tab6-matkl.
          if sy-subrc = 0.
            mtpt = zmtpt-target.
          endif.
        endif.

        call function 'WRITE_FORM'
          exporting
            element = 'GRP1'
            window  = 'MAIN'.
        g_qty = 0.
        g_sval = 0.
      endat.
      at end of bzirk.
        call function 'WRITE_FORM'
          exporting
            element = 'PSO_TOT'
            window  = 'MAIN'.
        pso_tot = 0.
      endat.
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

    write s_budat-low to wa_d1 dd/mm/yyyy.
    write s_budat-high to wa_d2 dd/mm/yyyy.

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
    concatenate 'SA-7 FROM:' wa_d1 'TO ' wa_d2  into doc_chng-obj_descr separated by space.
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

    concatenate 'SA-7' '.' into objpack-obj_descr separated by space.
    objpack-doc_size = righe_attachment * 255.
    append objpack.
    clear objpack.

*    loop at it_tam2 into wa_tam2 where pernr = wa_tam1-pernr.
    reclist-receiver =   uemail.
    reclist-express = 'X'.
    reclist-rec_type = 'U'.
    reclist-notif_del = 'X'. " request delivery notification
    reclist-notif_ndel = 'X'. " request not delivered notification
    append reclist.
    clear reclist.
*    endloop.
    describe table reclist lines mcount.
    if mcount > 0.
*        data: sender like soextreci1-receiver.
***ADDED BY SATHISH.B
*        types: begin of t_usr21,
*             bname type usr21-bname,
*             persnumber type usr21-persnumber,
*             addrnumber type usr21-addrnumber,
*            end of t_usr21.
*
*        types: begin of t_adr6,
*                 addrnumber type usr21-addrnumber,
*                 persnumber type usr21-persnumber,
*                 smtp_addr type adr6-smtp_addr,
*                end of t_adr6.
*
*        data: it_usr21 type table of t_usr21,
*              wa_usr21 type t_usr21,
*              it_adr6 type table of t_adr6,
*              wa_adr6 type t_adr6.
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

*    endloop.
    loop at it_tam1 into wa_tam1.
      read table it_tam2 into wa_tam2 with key  pernr = wa_tam1-pernr .
      if sy-subrc eq 4.
        format color 6.
        write : / 'EMAIL ID NOT MAINTAINED FOR EMP. CODE :',wa_tam1-pernr.
      endif.
    endloop.



  endif.
*&---------------------------------------------------------------------*
*&      Form  TOP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form top.

  data: comment    type slis_t_listheader,
        wa_comment like line of comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'DETAILS FROM: '.
  wa_comment-info+19(2) = s_budat-low+6(2).
  wa_comment-info+21(1) = '.'.
  wa_comment-info+22(2) = s_budat-low+4(2).
  wa_comment-info+24(1) = '.'.
  wa_comment-info+25(4) = s_budat-low+0(4).
  wa_comment-info+30(2) = 'TO'.

  wa_comment-info+33(2) = s_budat-high+6(2).
  wa_comment-info+35(1) = '.'.
  wa_comment-info+36(2) = s_budat-high+4(2).
  wa_comment-info+38(1) = '.'.
  wa_comment-info+39(4) = s_budat-high+0(4).
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
*&      Form  SALE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form sale.
  if it_tab5 is not initial.
    select * from vbrk into table it_vbrk for all entries in it_tab5 where fkdat in s_budat and fkart in ('ZBDF','ZCDF')
       and kunag eq it_tab5-kunnr and fksto ne 'X'.
    if sy-subrc eq 0.
      select * from vbrp into table it_vbrp for all entries in it_vbrk where  vbeln = it_vbrk-vbeln and fkimg ne 0
        and pstyv eq 'ZAN'.
      if sy-subrc ne 0.
*        EXIT.
      endif.
    endif.
  endif.

  if it_vbrk is not initial.
    select knumv kposn kschl kwert  from konv into table it_konv for all entries in it_vbrk where knumv = it_vbrk-knumv
      and kschl in ('ZPED', 'ZEX4','ZGRP').
  endif.
  sort it_konv by knumv kposn kschl.
  sort it_vbrp by vbeln.
  delete it_vbrp where fkimg eq 0.
  if it_vbrp is not initial.
    loop at it_vbrp into wa_vbrp from sy-tabix.
      if wa_vbrp-pstyv = 'ZAN'.

        wa_tas1-vbeln = wa_vbrp-vbeln.
        wa_tas1-fkimg_s = wa_vbrp-fkimg.
        wa_tas1-matnr = wa_vbrp-matnr.
        wa_tas1-arktx = wa_vbrp-arktx.
        wa_tas1-charg = wa_vbrp-charg.
        wa_tas1-werks = wa_vbrp-werks.


        read table it_vbrk into wa_vbrk with key vbeln = wa_vbrp-vbeln.
        if sy-subrc eq 0.
          wa_tas1-fkdat = wa_vbrk-fkdat.
          wa_tas1-kunag = wa_vbrk-kunag.
          select single * from mara where matnr eq wa_vbrp-matnr.
          if sy-subrc eq 0.
            wa_tas1-spart = mara-spart.
            if mara-spart eq '50'.
              read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZEX4' binary search.
              if sy-subrc eq 0.
                wa_tas1-bed_rate = wa_konv-kwert.
              endif.
              read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZPED' binary search.
              if sy-subrc eq 0.
                wa_tas1-bzped_rate = wa_konv-kwert.
              endif.
              read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZGRP' binary search.
              if sy-subrc eq 0.
                wa_tas1-bzgrp_rate = wa_konv-kwert.
              endif.
            elseif mara-spart eq '60'.
              read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZEX4' binary search.
              if sy-subrc eq 0.
                wa_tas1-xed_rate = wa_konv-kwert.
              endif.
              read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZPED' binary search.
              if sy-subrc eq 0.
                wa_tas1-xzped_rate = wa_konv-kwert.
              endif.
              read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZGRP' binary search.
              if sy-subrc eq 0.
                wa_tas1-xzgrp_rate = wa_konv-kwert.
              endif.
            elseif mara-spart eq '70'.
              read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZEX4' binary search.
              if sy-subrc eq 0.
                wa_tas1-ls_ed_rate = wa_konv-kwert.
              endif.
              read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZPED' binary search.
              if sy-subrc eq 0.
                wa_tas1-ls_zped_rate = wa_konv-kwert.
              endif.
              read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZGRP' binary search.
              if sy-subrc eq 0.
                wa_tas1-ls_zgrp_rate = wa_konv-kwert.
              endif.
            endif.
          endif.
        endif.
        collect wa_tas1 into it_tas1.
        clear wa_tas1.

      endif.
    endloop.
  endif.
  if it_tas1 is not initial.
    loop at it_tas1 into wa_tas1.
      clear : pts,val1.
      wa_tas2-kunag = wa_tas1-kunag.
      wa_tas2-spart = wa_tas1-spart.
      val1 = wa_tas1-bzgrp_rate + wa_tas1-xzgrp_rate + wa_tas1-ls_zgrp_rate.
      if val1 gt 0.
        if wa_tas1-spart eq '50'.
          pts = wa_tas1-bzgrp_rate.
        elseif wa_tas1-spart eq '60'.
          pts = wa_tas1-xzgrp_rate.
        elseif wa_tas1-spart eq '70'.
          pts = wa_tas1-ls_zgrp_rate.
        endif.
      else.
        if wa_tas1-spart eq '50'.
          pts = wa_tas1-bzped_rate + wa_tas1-bed_rate.
        elseif wa_tas1-spart eq '60'.
          pts = wa_tas1-xzped_rate + wa_tas1-xed_rate.
        elseif wa_tas1-spart eq '70'.
          pts = wa_tas1-ls_zped_rate + wa_tas1-ls_ed_rate.
        endif.
      endif.
      wa_tas2-pts = pts.
      wa_tas2-matnr = wa_tas1-matnr.
      wa_tas2-fkimg_s = wa_tas1-fkimg_s.
      collect wa_tas2 into it_tas2.
      clear wa_tas2.
    endloop.
  endif.

endform.                    "SALE
*&---------------------------------------------------------------------*
*&      Form  ZDISTSALE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form zdistsale .
*  BREAK-POINT .
  clear :it_zdist_sale.
  clear : it_dist1,wa_dist1,it_dist2,wa_dist2.
  select * from zdist_sale into table it_zdist_sale where fkdat ge s_budat-low and fkdat le s_budat-high.
*     and flag eq space.
  if it_zdist_sale is not initial.
    loop at it_zdist_sale into wa_zdist_sale.
      select single * from mara where matnr eq wa_zdist_sale-matnr and spart in ( '50','60','70' ).
      if sy-subrc eq 0.
*    wa_tab1-kunrg = wa_zdist_sale-kunrg.
        wa_dist1-kunag = wa_zdist_sale-kunag.
        wa_dist1-matnr = wa_zdist_sale-matnr.
        wa_dist1-spart = mara-spart.
        wa_dist1-netwr =   wa_zdist_sale-netwr.
        wa_dist1-fkimg =   wa_zdist_sale-fkimg.
        collect wa_dist1 into it_dist1.
        clear wa_dist1.
      endif.
    endloop.
  endif.

  clear : it_ysd_cus_div_dis1,wa_ysd_cus_div_dis1.
  if it_dist1 is not initial.
    select * from ysd_cus_div_dis into table it_ysd_cus_div_dis1 for all entries in it_dist1 where kunnr eq it_dist1-kunag and spart eq it_dist1-spart
      and begda ge s_budat-low and endda le s_budat-high.
  endif.
*  BREAK-POINT.
*  IF IT_YSD_CUS_DIV_DIS1 IS NOT INITIAL.
*    LOOP AT IT_YSD_CUS_DIV_DIS1 INTO WA_YSD_CUS_DIV_DIS1.
*      LOOP AT IT_DIST1 INTO WA_DIST1 WHERE KUNAG = WA_YSD_CUS_DIV_DIS1-KUNNR AND SPART = WA_YSD_CUS_DIV_DIS1-SPART.
*        WA_DIST2-KUNAG  = WA_YSD_CUS_DIV_DIS1-KUNNR.
*        WA_DIST2-MATNR = WA_DIST1-MATNR.
*        WA_DIST2-SPART = WA_DIST1-SPART.
*        WA_DIST2-MATNR = WA_DIST1-MATNR.
*        CLEAR : DISTVAL,DISTQTY.
**        DISTVAL = ( WA_DIST1-NETWR * ( WA_YSD_CUS_DIV_DIS1-PERCNT / 100 ) ).
**        DISTQTY = ( WA_DIST1-FKIMG * ( WA_YSD_CUS_DIV_DIS1-PERCNT / 100 ) ).
*        DISTVAL = ( WA_DIST1-NETWR ).
*        DISTQTY = ( WA_DIST1-FKIMG ).
*        WA_DIST2-NETWR = DISTVAL.
*        WA_DIST2-FKIMG = DISTQTY.
*        COLLECT WA_DIST2 INTO IT_DIST2.
*        CLEAR WA_DIST2.
*      ENDLOOP.
*    ENDLOOP.
*  ENDIF.

*  BREAK-POINT.
  if it_ysd_cus_div_dis1 is not initial.
*    LOOP AT IT_YSD_CUS_DIV_DIS1 INTO WA_YSD_CUS_DIV_DIS1.
    loop at it_dist1 into wa_dist1 .
*        WHERE KUNAG = WA_YSD_CUS_DIV_DIS1-KUNNR AND SPART = WA_YSD_CUS_DIV_DIS1-SPART.
      read table it_ysd_cus_div_dis1 into wa_ysd_cus_div_dis1 with key kunnr = wa_dist1-kunag spart = wa_dist1-spart.
      if sy-subrc eq 0.
        wa_dist2-kunag  = wa_ysd_cus_div_dis1-kunnr.
        wa_dist2-matnr = wa_dist1-matnr.
        wa_dist2-spart = wa_dist1-spart.
        wa_dist2-matnr = wa_dist1-matnr.
        clear : distval,distqty.
*        DISTVAL = ( WA_DIST1-NETWR * ( WA_YSD_CUS_DIV_DIS1-PERCNT / 100 ) ).
*        DISTQTY = ( WA_DIST1-FKIMG * ( WA_YSD_CUS_DIV_DIS1-PERCNT / 100 ) ).
        distval = ( wa_dist1-netwr ).
        distqty = ( wa_dist1-fkimg ).
        wa_dist2-netwr = distval.
        wa_dist2-fkimg = distqty.
        collect wa_dist2 into it_dist2.
        clear wa_dist2.
      endif.
    endloop.
*    ENDLOOP.
  endif.
*BREAK-POINT.

  clear : it_dist3,wa_dist3.
  loop at it_dist2 into wa_dist2.
    wa_dist3-kunag =  wa_dist2-kunag.
    wa_dist3-matnr =  wa_dist2-matnr.
    wa_dist3-spart = wa_dist2-spart.
    wa_dist3-s_val =  wa_dist2-netwr.
    wa_dist3-s_qty =  wa_dist2-fkimg.
    collect wa_dist3 into it_dist3.
    clear wa_dist3.
  endloop.
*BREAK-POINT.
  loop at it_dist3 into wa_dist3.
    wa_tas2-kunag = wa_dist3-kunag.
    wa_tas2-spart = wa_dist3-spart.
    wa_tas2-pts = wa_dist3-s_val.
    wa_tas2-matnr = wa_dist3-matnr.
    wa_tas2-fkimg_s = wa_dist3-s_qty.
    collect wa_tas2 into it_tas2.
    clear wa_tas2.
  endloop.
*  BREAK-POINT .
endform.
