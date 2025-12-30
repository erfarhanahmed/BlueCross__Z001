*&---------------------------------------------------------------------*
*& Report  ZSR13NYPM
*&---------------------------------------------------------------------*
*&DESCRIPTION       :
*&
*&CREATED BY         :
*&CREATED ON         :
*&Request No         :
*&T-Code             : ZSR13
*&---------------------------------------------------------------------*
*&Modification History
*&---------------------------
*&Changed by/date      : 11.05.2023
*&DESCRIPTION          : change script to smartform and changed mail sending part as well.
*&                       form used is common as in ZSR12
*&Request No.          :BCDK932944 , BCDK933790
*&---------------------------------------------------------------------*
*&Changed by/date      : shraddhap / 16.11.2023
*&DESCRIPTION          : error correction for divide by zero.
*&Request No.          : BCDK933790
*&---------------------------------------------------------------------*
*&Changed by/date      : shraddhap / 01.07.2024
*&DESCRIPTION          : corr in RM name at header and Yterrallc add date in selection - PERFORM valuedata1
*&Request No.          : BCDK935391,BCDK935407
*&---------------------------------------------------------------------*
*&Changed by/date      : 02.08.2024
*&DESCRIPTION          : Corr.to remove wrong div.data in output.
*&                       select curr.Yr data from ZPQV/ZCUMPSO.
*&Request No.          :BCDK935563,BCDK935565,BCDK935697
*&---------------------------------------------------------------------------------------*
*&Changed by/date      : 24.09.2024
*&DESCRIPTION          : Corr.for growth when prev or curr year sale is zero.
*&Request No.          :BCDK935816
*&---------------------------------------------------------------------------------------*
report  zsr13nypm_a2.

tables : zrpqv,
         zdsmter,
         zprdgroup,
         yterrallc,
         ysd_dist_targt,
         zrcumpso,
         pa0001,
         makt,
         mvke,
         tvm5t,
         mara,
         t023,
         tvm4t,
         zmtpt_ach,
         ztotpso,
         zdrphq,
         t247,
         t023t.

type-pools:  slis.

data: g_repid     like sy-repid,
      mdatael     type element,
      mdiv        type zprdgroup-grp_div,
      fieldcat    type slis_t_fieldcat_alv,
      wa_fieldcat like line of fieldcat,
      sort        type slis_t_sortinfo_alv,
      wa_sort     like line of sort,
      layout      type slis_layout_alv.

data : it_zrpqv       type table of zrpqv,
       wa_zrpqv       type zrpqv,
       it_t171t       type table of t171t,
       wa_t171t       type t171t,

       it_zprdgroup   type table of zprdgroup,
       wa_zprdgroup   type zprdgroup,
       it_zsales_tab2 type table of zrpqv,
       wa_zsales_tab2 type zrpqv,
       it_zsales_tab3 type table of zrpqv,
       wa_zsales_tab3 type zrpqv.

data : l_date      type sy-datum,
       c_date      type sy-datum,
       ll_date     type sy-datum,
       lc_date     type sy-datum,
       aprdt       type sy-datum,
       maydt       type sy-datum,
       jundt       type sy-datum,
       juldt       type sy-datum,
       augdt       type sy-datum,
       sepdt       type sy-datum,
       octdt       type sy-datum,
       novdt       type sy-datum,
       decdt       type sy-datum,
       jandt       type sy-datum,
       febdt       type sy-datum,
       mardt       type sy-datum,
       cryrdt      type sy-datum,
       mdays       type string,
       mplan       type yterrallc-plans,
       mename      type pa0001-ename,
       mtotpso     type  ztotpso-bcl,
       mhq         type zthr_heq_des-zz_hqdesc,
       zhqname     type zthr_heq_des-zz_hqdesc,
       mpernr      type pa0001-pernr,
       mctr(2)     type n,
       grpname(25) type c,
       flag(1)     type c,
       ll_mth      type string,
       ll_day      type string,
       ll_yr       type string,
       mmth1       type string,
       mmth2       type string,
       mmth3       type string,
       mmth4       type string,
       mmth5       type string,
       mmth6       type string,
       mmth7       type string,
       mmth8       type string,
       mmth9       type string,
       mmth10      type string,
       mmth11      type string,
       mmth12      type string,
       myr1        type string,
       myr2        type string,
       myr3        type string,
       myr4        type string,
       myr5        type string,
       myr6        type string,
       myr7        type string,
       myr8        type string,
       myr9        type string,
       myr10       type string,
       myr11       type string,
       myr12       type string.

data: month_name type table of t247 with header line.
data: mm(2)        type n,
      ctr(10)      type n,
      mtitle(150)  type c,
      mtitle1(150) type c,
      mtitle2(150) type c,
      tag(8)       type c,
      elname(10)   type c,
      avgqty(9)    type p,
      prdname(25)  type c,
      formnm(10)   type c,
      w_month(30)  type c,
      w_year(4)    type c.

data : qty1(8)   type p,
       qty2(8)   type p,
       qty3(8)   type p,
       qty4(8)   type p,
       qty5(8)   type p,
       qty6(8)   type p,
       qty7(8)   type p,
       qty8(8)   type p,
       qty9(8)   type p,
       qty10(8)  type p,
       qty11(8)  type p,
       qty12(8)  type p,
       qtysum(8) type p.
data : dqty1(8)   type p,
       dqty2(8)   type p,
       dqty3(8)   type p,
       dqty4(8)   type p,
       dqty5(8)   type p,
       dqty6(8)   type p,
       dqty7(8)   type p,
       dqty8(8)   type p,
       dqty9(8)   type p,
       dqty10(8)  type p,
       dqty11(8)  type p,
       dqty12(8)  type p,
       dqtysum(8) type p.
data : pqty1(8)    type p,
       pqty2(8)    type p,
       pqty3(8)    type p,
       pqty4(8)    type p,
       pqty5(8)    type p,
       pqty6(8)    type p,
       pqty7(8)    type p,
       pqty8(8)    type p,
       pqty9(8)    type p,
       pqty10(8)   type p,
       pqty11(8)   type p,
       pqty12(8)   type p,
       pqtyason(8) type p,
       pqtysum(8)  type p.
data : fdqty1(8)   type p,
       fdqty2(8)   type p,
       fdqty3(8)   type p,
       fdqty4(8)   type p,
       fdqty5(8)   type p,
       fdqty6(8)   type p,
       fdqty7(8)   type p,
       fdqty8(8)   type p,
       fdqty9(8)   type p,
       fdqty10(8)  type p,
       fdqty11(8)  type p,
       fdqty12(8)  type p,
       fdqtysum(8) type p.
data : fpqty1(8)    type p,
       fpqty2(8)    type p,
       fpqty3(8)    type p,
       fpqty4(8)    type p,
       fpqty5(8)    type p,
       fpqty6(8)    type p,
       fpqty7(8)    type p,
       fpqty8(8)    type p,
       fpqty9(8)    type p,
       fpqty10(8)   type p,
       fpqty11(8)   type p,
       fpqty12(8)   type p,
       fpqtyason(8) type p,
       fpqtysum(8)  type p.

types : begin of itac_1,
          reg   type zdsmter-zdsm,
          zm    type zdsmter-zdsm,
          rm    type zdsmter-zdsm,
          bzirk type zdsmter-bzirk,
          pernr type pa0001-pernr,
          ename type pa0001-ename,
          hq    type zthr_heq_des-zz_hqdesc,
        end of itac_1.

types : begin of itab_tername,
          bzirk type zdsmter-bzirk,
          pernr type pa0001-pernr,
          ename type pa0001-ename,
          hq    type zthr_heq_des-zz_hqdesc,
        end of itab_tername.

types : begin of itab_1,
          bzirk    type zdsmter-bzirk,
          matnr    type zrpqv-matnr,
          grosspts type zrpqv-grosspts,
          grossqty type zrpqv-grossqty,
        end of itab_1.

types : begin of inetval_1,
          bzirk  type zdsmter-bzirk,
          netval type zrcumpso-netval,
        end of inetval_1.


types : begin of itgt_1,
          bzirk   type zdsmter-bzirk,
          month01 type ysd_dist_targt-month01,
          month02 type ysd_dist_targt-month01,
          month03 type ysd_dist_targt-month01,
          month04 type ysd_dist_targt-month01,
          month05 type ysd_dist_targt-month01,
          month06 type ysd_dist_targt-month01,
          month07 type ysd_dist_targt-month01,
          month08 type ysd_dist_targt-month01,
          month09 type ysd_dist_targt-month01,
          month10 type ysd_dist_targt-month01,
          month11 type ysd_dist_targt-month01,
          month12 type ysd_dist_targt-month01,
        end of itgt_1.

types : begin of itab_p1,
          bzirk    type zdsmter-bzirk,
          matnr    type zrpqv-matnr,
          grosspts type zrpqv-grosspts,
          grossqty type zrpqv-grossqty,
        end of itab_p1.

types : begin of itab_tot,
          bzirk         type zdsmter-bzirk,
          pernr         type pa0001-pernr,
          ename         type pa0001-ename,
          hq            type zthr_heq_des-zz_hqdesc,
          spart         type mara-spart,
          matnr         type mara-matnr,
          grp_code      type zprdgroup-grp_code,
          grp_name      type zprdgroup-grp_name,
          grp_div(2)    type c,
          prn_seq(4)    type n,
          maktx         type makt-maktx,
          matkl         type mara-matkl,
          mvgr4         type mvke-mvgr4,
          bezei         type tvm4t-bezei,
          pack          type tvm5t-bezei,
          apr_qty       type zrpqv-grossqty,
          apr_grosspts  type zrpqv-grosspts,
          apr_pqty      type zrpqv-grossqty,
          apr_pgrosspts type zrpqv-grossqty,
          may_qty       type zrpqv-grossqty,
          may_grosspts  type zrpqv-grosspts,
          may_pqty      type zrpqv-grossqty,
          may_pgrosspts type zrpqv-grossqty,
          jun_qty       type zrpqv-grossqty,
          jun_grosspts  type zrpqv-grosspts,
          jun_pqty      type zrpqv-grossqty,
          jun_pgrosspts type zrpqv-grossqty,
          jul_qty       type zrpqv-grossqty,
          jul_grosspts  type zrpqv-grosspts,
          jul_pqty      type zrpqv-grossqty,
          jul_pgrosspts type zrpqv-grossqty,
          aug_qty       type zrpqv-grossqty,
          aug_grosspts  type zrpqv-grosspts,
          aug_pqty      type zrpqv-grossqty,
          aug_pgrosspts type zrpqv-grossqty,
          sep_qty       type zrpqv-grossqty,
          sep_grosspts  type zrpqv-grosspts,
          sep_pqty      type zrpqv-grossqty,
          sep_pgrosspts type zrpqv-grossqty,
          oct_qty       type zrpqv-grossqty,
          oct_grosspts  type zrpqv-grosspts,
          oct_pqty      type zrpqv-grossqty,
          oct_pgrosspts type zrpqv-grossqty,
          nov_qty       type zrpqv-grossqty,
          nov_grosspts  type zrpqv-grosspts,
          nov_pqty      type zrpqv-grossqty,
          nov_pgrosspts type zrpqv-grossqty,
          dec_qty       type zrpqv-grossqty,
          dec_grosspts  type zrpqv-grosspts,
          dec_pqty      type zrpqv-grossqty,
          dec_pgrosspts type zrpqv-grossqty,
          jan_qty       type zrpqv-grossqty,
          jan_grosspts  type zrpqv-grosspts,
          jan_pqty      type zrpqv-grossqty,
          jan_pgrosspts type zrpqv-grosspts,
          feb_qty       type zrpqv-grossqty,
          feb_grosspts  type zrpqv-grosspts,
          feb_pqty      type zrpqv-grossqty,
          feb_pgrosspts type zrpqv-grossqty,
          mar_qty       type zrpqv-grossqty,
          mar_grosspts  type zrpqv-grosspts,
          mar_pqty      type zrpqv-grossqty,
          mar_pgrosspts type zrpqv-grossqty,
          apr_totse_ach type zmtpt_ach-totalse_ach,
          apr_mtpt_per  type p,
          pavg_ypm      type p,
          papr_ypm      type p,
          pmay_ypm      type p,
          pjun_ypm      type p,
          pjul_ypm      type p,
          paug_ypm      type p,
          psep_ypm      type p,
          poct_ypm      type p,
          pnov_ypm      type p,
          pdec_ypm      type p,
          pjan_ypm      type p,
          pfeb_ypm      type p,
          pmar_ypm      type p,
          avg_ypm       type p,
          apr_ypm       type p,
          may_totse_ach type zmtpt_ach-totalse_ach,
          may_mtpt_per  type p,
          may_ypm       type p,
          jun_totse_ach type zmtpt_ach-totalse_ach,
          jun_mtpt_per  type p,
          jun_ypm       type p,
          jul_totse_ach type zmtpt_ach-totalse_ach,
          jul_mtpt_per  type p,
          jul_ypm       type p,
          aug_totse_ach type zmtpt_ach-totalse_ach,
          aug_mtpt_per  type p,
          aug_ypm       type p,
          sep_totse_ach type zmtpt_ach-totalse_ach,
          sep_mtpt_per  type p,
          sep_ypm       type p,
          oct_totse_ach type zmtpt_ach-totalse_ach,
          oct_mtpt_per  type p,
          oct_ypm       type p,
          nov_totse_ach type zmtpt_ach-totalse_ach,
          nov_mtpt_per  type p,
          nov_ypm       type p,
          dec_totse_ach type zmtpt_ach-totalse_ach,
          dec_mtpt_per  type p,
          dec_ypm       type p,
          jan_totse_ach type zmtpt_ach-totalse_ach,
          jan_mtpt_per  type p,
          jan_ypm       type p,
          feb_totse_ach type zmtpt_ach-totalse_ach,
          feb_mtpt_per  type p,
          feb_ypm       type p,
          mar_totse_ach type zmtpt_ach-totalse_ach,
          mar_mtpt_per  type p,
          mar_ypm       type p,
          curr_qty      type p,
          curr_grosspts type p,
          prev_qty      type p,
          prev_grosspts type p,
          asof_qtytot   type p,
          asof_valtot   type p,
          curr_qtytot   type p,
          curr_valtot   type p,
          apr_grth      type p,
          may_grth      type p,
          jun_grth      type p,
          jul_grth      type p,
          aug_grth      type p,
          sep_grth      type p,
          oct_grth      type p,
          nov_grth      type p,
          dec_grth      type p,
          jan_grth      type p,
          feb_grth      type p,
          mar_grth      type p,
          grth          type p,
          apr_qgrth     type p,
          may_qgrth     type p,
          jun_qgrth     type p,
          jul_qgrth     type p,
          aug_qgrth     type p,
          sep_qgrth     type p,
          oct_qgrth     type p,
          nov_qgrth     type p,
          dec_qgrth     type p,
          jan_qgrth     type p,
          feb_qgrth     type p,
          mar_qgrth     type p,
          qgrth         type p,
        end of itab_tot.


types : begin of itab_sum,
          bzirk    type zdsmter-bzirk,
          apr_pval type zrcumpso-netval,
          apr_val  type zrcumpso-netval,
          may_pval type zrcumpso-netval,
          may_val  type zrcumpso-netval,
          jun_pval type zrcumpso-netval,
          jun_val  type zrcumpso-netval,
          jul_pval type zrcumpso-netval,
          jul_val  type zrcumpso-netval,
          aug_pval type zrcumpso-netval,
          aug_val  type zrcumpso-netval,
          sep_pval type zrcumpso-netval,
          sep_val  type zrcumpso-netval,
          oct_pval type zrcumpso-netval,
          oct_val  type zrcumpso-netval,
          nov_pval type zrcumpso-netval,
          nov_val  type zrcumpso-netval,
          dec_pval type zrcumpso-netval,
          dec_val  type zrcumpso-netval,
          jan_pval type zrcumpso-netval,
          jan_val  type zrcumpso-netval,
          feb_pval type zrcumpso-netval,
          feb_val  type zrcumpso-netval,
          mar_pval type zrcumpso-netval,
          mar_val  type zrcumpso-netval,
          apr_ptgt type ysd_dist_targt-month01,
          apr_tgt  type ysd_dist_targt-month01,
          may_ptgt type ysd_dist_targt-month01,
          may_tgt  type ysd_dist_targt-month01,
          jun_ptgt type ysd_dist_targt-month01,
          jun_tgt  type ysd_dist_targt-month01,
          jul_ptgt type ysd_dist_targt-month01,
          jul_tgt  type ysd_dist_targt-month01,
          aug_ptgt type ysd_dist_targt-month01,
          aug_tgt  type ysd_dist_targt-month01,
          sep_ptgt type ysd_dist_targt-month01,
          sep_tgt  type ysd_dist_targt-month01,
          oct_ptgt type ysd_dist_targt-month01,
          oct_tgt  type ysd_dist_targt-month01,
          nov_ptgt type ysd_dist_targt-month01,
          nov_tgt  type ysd_dist_targt-month01,
          dec_ptgt type ysd_dist_targt-month01,
          dec_tgt  type ysd_dist_targt-month01,
          jan_ptgt type ysd_dist_targt-month01,
          jan_tgt  type ysd_dist_targt-month01,
          feb_ptgt type ysd_dist_targt-month01,
          feb_tgt  type ysd_dist_targt-month01,
          mar_ptgt type ysd_dist_targt-month01,
          mar_tgt  type ysd_dist_targt-month01,
          pavg_ypm type p,
          papr_ypm type p,
          pmay_ypm type p,
          pjun_ypm type p,
          pjul_ypm type p,
          paug_ypm type p,
          psep_ypm type p,
          poct_ypm type p,
          pnov_ypm type p,
          pdec_ypm type p,
          pjan_ypm type p,
          pfeb_ypm type p,
          pmar_ypm type p,
          apr_ypm  type p,
          may_ypm  type p,
          jun_ypm  type p,
          jul_ypm  type p,
          aug_ypm  type p,
          sep_ypm  type p,
          oct_ypm  type p,
          nov_ypm  type p,
          dec_ypm  type p,
          jan_ypm  type p,
          feb_ypm  type p,
          mar_ypm  type p,
        end of itab_sum.

data : it_zdsmter1 type table of zdsmter,
       wa_zdsmter1 type zdsmter,
       it_zdsmter  type table of zdsmter,
       wa_zdsmter  type zdsmter.

data :
  it_zdsmter21 type table of zdsmter,
  wa_zdsmter21 type zdsmter,
  wa_zdsmter3  type zdsmter,
  it_zdsmter4  type table of zdsmter,
  wa_zdsmter4  type zdsmter,
  it_zdsmter5  type table of zdsmter,
  wa_zdsmter5  type zdsmter,
  it_zmtpt_ach type table of zmtpt_ach,
  wa_zmtpt_ach type zmtpt_ach,
  it_ztotpso   type table of ztotpso,
  wa_ztotpso   type ztotpso,
  it_zdsmter2  type table of zdsmter,
  wa_zdsmter2  type zdsmter.

data : it_tac1      type table of itac_1,
       wa_tac1      type itac_1,
       it_tac11     type table of itac_1,
       wa_tac11     type itac_1,
       it_tac2      type table of itac_1,
       wa_tac2      type itac_1,
       it_tac3      type table of itac_1,
       wa_tac3      type itac_1,
       it_tgt1      type table of itgt_1,
       wa_tgt1      type itgt_1,
       it_tgtp1     type table of itgt_1,
       wa_tgtp1     type itgt_1,

       it_netval1   type table of inetval_1,
       wa_netval1   type inetval_1,
       it_netvalp1  type table of inetval_1,
       wa_netvalp1  type inetval_1,

       it_netval2   type table of inetval_1,
       wa_netval2   type inetval_1,
       it_netvalp2  type table of inetval_1,
       wa_netvalp2  type inetval_1,
       it_netval3   type table of inetval_1,
       wa_netval3   type inetval_1,
       it_netvalp3  type table of inetval_1,
       wa_netvalp3  type inetval_1,
       it_netval4   type table of inetval_1,
       wa_netval4   type inetval_1,
       it_netvalp4  type table of inetval_1,
       wa_netvalp4  type inetval_1,
       it_netval5   type table of inetval_1,
       wa_netval5   type inetval_1,
       it_netvalp5  type table of inetval_1,
       wa_netvalp5  type inetval_1,
       it_netval6   type table of inetval_1,
       wa_netval6   type inetval_1,
       it_netvalp6  type table of inetval_1,
       wa_netvalp6  type inetval_1,
       it_netval7   type table of inetval_1,
       wa_netval7   type inetval_1,
       it_netvalp7  type table of inetval_1,
       wa_netvalp7  type inetval_1,
       it_netval8   type table of inetval_1,
       wa_netval8   type inetval_1,
       it_netvalp8  type table of inetval_1,
       wa_netvalp8  type inetval_1,
       it_netval9   type table of inetval_1,
       wa_netval9   type inetval_1,
       it_netvalp9  type table of inetval_1,
       wa_netvalp9  type inetval_1,
       it_netval10  type table of inetval_1,
       wa_netval10  type inetval_1,
       it_netvalp10 type table of inetval_1,
       wa_netvalp10 type inetval_1,
       it_netval11  type table of inetval_1,
       wa_netval11  type inetval_1,
       it_netvalp11 type table of inetval_1,
       wa_netvalp11 type inetval_1,
       it_netval12  type table of inetval_1,
       wa_netval12  type inetval_1,
       it_netvalp12 type table of inetval_1,
       wa_netvalp12 type inetval_1,
       it_tab1      type table of itab_1,
       wa_tab1      type itab_1,
       it_tab2      type table of itab_1,
       wa_tab2      type itab_1,
       it_tab3      type table of itab_1,
       wa_tab3      type itab_1,
       it_tab4      type table of itab_1,
       wa_tab4      type itab_1,
       it_tab5      type table of itab_1,
       wa_tab5      type itab_1,
       it_tab6      type table of itab_1,
       wa_tab6      type itab_1,
       it_tab7      type table of itab_1,
       wa_tab7      type itab_1,
       it_tab8      type table of itab_1,
       wa_tab8      type itab_1,
       it_tab9      type table of itab_1,
       wa_tab9      type itab_1,
       it_tab10     type table of itab_1,
       wa_tab10     type itab_1,
       it_tab11     type table of itab_1,
       wa_tab11     type itab_1,
       it_tab12     type table of itab_1,
       wa_tab12     type itab_1,
       it_tabfin    type table of itab_tot,
       wa_tabfin    type itab_tot,
       it_sumfin    type table of itab_sum,
       wa_sumfin    type itab_sum,
       it_tabsum    type table of itab_sum,
       wa_tabsum    type itab_sum,
       it_tabtot1   type table of itab_tot,
       wa_tabtot1   type itab_tot,
       it_tabtot    type table of itab_tot,
       wa_tabtot    type itab_tot.

data : it_tabp1  type table of itab_p1,
       wa_tabp1  type itab_p1,
       it_tabp2  type table of itab_p1,
       wa_tabp2  type itab_p1,
       it_tabp3  type table of itab_p1,
       wa_tabp3  type itab_p1,
       it_tabp4  type table of itab_p1,
       wa_tabp4  type itab_p1,
       it_tabp5  type table of itab_p1,
       wa_tabp5  type itab_p1,
       it_tabp6  type table of itab_p1,
       wa_tabp6  type itab_p1,
       it_tabp7  type table of itab_p1,
       wa_tabp7  type itab_p1,
       it_tabp8  type table of itab_p1,
       wa_tabp8  type itab_p1,
       it_tabp9  type table of itab_p1,
       wa_tabp9  type itab_p1,
       it_tabp10 type table of itab_p1,
       wa_tabp10 type itab_p1,
       it_tabp11 type table of itab_p1,
       wa_tabp11 type itab_p1,
       it_tabp12 type table of itab_p1,
       wa_tabp12 type itab_p1.

data : mdate1 like sy-datum.
data : pdate like sy-datum.
data : mintgt like zmtpt-target.
data : mth type fcmnr.
data : yr type mjahr.
data : pryr type mjahr.
data : tgtyr type mjahr.

data : mcurramt   type zrpqv-grosspts,
       mprevamt   type zrpqv-grosspts,
       mcurrqty   type zrpqv-grosspts,
       mprevqty   type zrpqv-grosspts,
       asofamt    type zrpqv-grosspts,
       asofqty(8) type p.


data : msg      type string,
       sdate    type sy-datum,
       month(2) type c,
       year(4)  type c,
       date1    type sy-datum,
       date2    type sy-datum,
       text(12) type c.

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

types : begin of itam1,
          pernr type pa0001-pernr,
          rm    type yterrallc-bzirk,
        end of itam1.


types : begin of itam2,
          pernr      type pa0001-pernr,
          usrid_long type pa0105-usrid_long,
        end of itam2.

data : it_tam2 type table of itam2,
       wa_tam2 type itam2,
       it_tam1 type table of itam1,
       wa_tam1 type itam1.
data : curryrst type sy-datum.

***** for new smartform print
data : gt_fdata          type table of zty_sr12_fdata,
       gw_fdata          type zty_sr12_fdata,
       gt_fdata_all      type table of zty_sr12_fdata,
       gw_fdata_all      type zty_sr12_fdata,
       gt_sr12_total     type table of zty_sr12_fdata,
       gw_sr12_total     type zty_sr12_fdata,
       gt_sr12_total_all type table of zty_sr12_fdata,
       gw_sr12_total_all type zty_sr12_fdata,
       gt_fdata_zm       type table of zty_sr12_fdata,
       gw_fdata_zm       type  zty_sr12_fdata,
       gt_fdata_zm_all   type table of zty_sr12_fdata,
       gw_fdata_zm_all   type  zty_sr12_fdata,
       gt_otf            type standard table of itcoo,
       gt_otf_data       type ssfcrescl,
       gt_tline          type standard table of tline,
       gt_pdf_data       type solix_tab,
       gt_text           type bcsy_text.

"Object References
data: lo_bcs     type ref to cl_bcs,
      lo_doc_bcs type ref to cl_document_bcs,
      lo_recep   type ref to if_recipient_bcs,
      lo_sender  type ref to if_sender_bcs,  "cl_sapuser_bcs,
      lo_cx_bcx  type ref to cx_bcs.


data : gv_title        type string,
       gv_bin_filesize type so_obj_len,
       gv_bin_xstr     type xstring,
       gv_text         type string,
       gv_sent_to_all  type os_boolean,
       gv_subject      type so_obj_des.

selection-screen begin of block b1 with frame title text-001.
select-options : zone for zdsmter-zdsm matchcode object zsr9_1.
*  PARAMETER : ZONE LIKE zdsmter-zdsm MATCHCODE OBJECT ZSR9_1.
select-options : ter for zdsmter-bzirk  matchcode object zsr7r no intervals.
parameter : mdate like sy-datum default sy-datum.
parameter : r1 radiobutton group r1,
            r2 radiobutton group r1,
            r3 radiobutton group r1,
            r6 radiobutton group r1,
            r4 radiobutton group r1,
            r7 radiobutton group r1,
            r5 radiobutton group r1.

parameter : uemail(70) type c.
selection-screen end of block b1.

initialization.
  g_repid = sy-repid.

start-of-selection.
  if r5 eq 'X'.
    if uemail eq '                                                                     '.
      message 'ENTER EMAIL ID' type 'E'.
    endif.
  endif.

start-of-selection.

  select * from zdsmter into table it_zdsmter1 where zdsm in zone.

  loop at it_zdsmter1 into wa_zdsmter1.
    authority-check object 'ZON1_1'
           id 'ZDSM' field wa_zdsmter1-zdsm.
    if sy-subrc <> 0.
      concatenate 'No authorization for Zone' wa_zdsmter1-zdsm into msg
      separated by space.
      message msg type 'E'.
    endif.
  endloop.



start-of-selection.
  mth = mdate+4(2).
  yr = mdate+0(4).
  if mth <= 3.
    tgtyr = yr - 1.
  else.
    tgtyr = yr.
  endif.
  pryr = tgtyr - 1.

  mdate+6(2) = '01'.

  pdate = mdate.
  pdate+0(4) = pryr.
  pdate+4(2) = '04'.
  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '-12'
      olddate = mdate
    importing
      newdate = date1.

*WRITE :/1 MDATE, MTH , YR, TGTYR , PRYR , PDATE , DATE1.

  cryrdt = mdate.
  cryrdt+6(2) = '01'.
  cryrdt+4(2) = '04'.
  cryrdt+0(4) = tgtyr.

  c_date = cryrdt.

  mmth1 = ''.
  mmth2 = ''.
  mmth3 = ''.
  mmth4 = ''.
  mmth5 = ''.
  mmth6 = ''.
  mmth7 = ''.
  mmth8 = ''.
  mmth9 = ''.
  mmth10 = ''.
  mmth11 = ''.
  mmth12 = ''.

  perform nameupdt.
  perform mthlydata.
  perform summarizedata.
*PERFORM VALUEDATA.
  perform valuedata1.
  perform grpdata.
*PERFORM wrtGRPDATA.
*PERFORM PYYPMDATA.
  perform mtptdata.
*PERFORM wrtGRPDATA.

  loop at it_tabfin into wa_tabfin.
    wa_tam1-pernr = wa_tabfin-pernr.
    wa_tam1-rm = wa_tabfin-bzirk.
    collect wa_tam1 into it_tam1.
    clear wa_tam1.
  endloop.
  sort it_tam1 by pernr.
  delete adjacent duplicates from it_tam1 comparing rm.

  if r1 = 'X' .
    perform dispnetvaldata.
    perform dispdata.
  elseif r2 = 'X' .

******  FORMNM = 'ZSR12C_FRM'.
******  PERFORM OPEN_FORM.
******  PERFORM FRM_SR13_PRN.
******  PERFORM CLOSE_FORM1.

    perform get_data_sform.
    if gt_fdata[] is not initial.
      perform print_sform.
    endif.

  elseif r3 eq 'X' .
    loop at it_tam1 into wa_tam1.
      select single usrid_long from pa0105 into usrid_long where pernr eq wa_tam1-pernr and subty = '0010'.
      if sy-subrc eq 0.
        wa_tam2-pernr = wa_tam1-pernr.
        wa_tam2-usrid_long = usrid_long.
        collect wa_tam2 into it_tam2.
        clear wa_tam2.
      endif.
    endloop.
    sort it_tam2 by pernr usrid_long.
    delete adjacent duplicates from it_tam2 comparing pernr usrid_long.
*****    formnm = 'ZSR13_FRM'.
*****    perform sr13email.

    perform get_data_sform.
    if gt_fdata[] is not initial and gt_fdata_all[] is not initial.
      perform email_form.
    endif.
  elseif r4 eq 'X' .
    loop at it_tam1 into wa_tam1.
      read table it_tac1 into  wa_tac1 with key rm = wa_tam1-rm.
      if sy-subrc = 0.
        select single * from yterrallc where bzirk eq wa_tac1-reg and begda le mdate and endda ge mdate . "  sy-datum.
        mplan = yterrallc-plans.
        if sy-subrc eq 0.
          select single * from pa0001 where plans = mplan and begda le mdate and endda ge mdate.
          if sy-subrc = 0.
            mpernr = pa0001-pernr.
            select single usrid_long from pa0105 into usrid_long where pernr eq mpernr and subty = '0010'.
            if sy-subrc eq 0.
              wa_tam2-pernr = wa_tam1-pernr.
              wa_tam2-usrid_long = usrid_long.
              collect wa_tam2 into it_tam2.
              clear wa_tam2.
            endif.
          endif.
        endif.
      endif.
    endloop.
    sort it_tam2 by pernr usrid_long.
    delete adjacent duplicates from it_tam2 comparing pernr usrid_long.
*****    formnm = 'ZSR13_FRM'.
*****    perform sr13email.

    perform get_data_sform.
    if gt_fdata[] is not initial and gt_fdata_all[] is not initial.
      perform email_form.
    endif.
  elseif r6 eq 'X' or r7 eq 'X' .
    loop at it_tam1 into wa_tam1.
      read table it_tac11 into  wa_tac11 with key rm = wa_tam1-rm.
      if sy-subrc = 0.
        select single * from yterrallc where bzirk eq wa_tac11-reg and begda le mdate and endda ge mdate . "  sy-datum.
        mplan = yterrallc-plans.
        if sy-subrc eq 0.
          select single * from pa0001 where plans = mplan and begda le mdate and endda ge mdate.
          if sy-subrc = 0.
            mpernr = pa0001-pernr.
            select single usrid_long from pa0105 into usrid_long where pernr eq mpernr and subty = '0010'.
            if sy-subrc eq 0.
              wa_tam2-pernr = wa_tam1-pernr.
              wa_tam2-usrid_long = usrid_long.
              collect wa_tam2 into it_tam2.
              clear wa_tam2.
            endif.
          endif.
        endif.
      endif.
    endloop.
    sort it_tam2 by pernr usrid_long.
    delete adjacent duplicates from it_tam2 comparing pernr usrid_long.
******    formnm = 'ZSR13_FRM'.
******    perform sr13email.

    perform get_data_sform.
    if gt_fdata[] is not initial and gt_fdata_all[] is not initial.
      perform email_form.
    endif.
  elseif r5 eq 'X' .
*****    formnm = 'ZSR13_FRM'.
*****    perform sr13email1.

    perform get_data_sform.
    if gt_fdata[] is not initial and uemail is  not initial.
      perform send_to_emailid.
    endif.
  endif.


  select * from zdsmter into table it_zdsmter where zmonth eq mth and zyear eq yr and zdsm in zone.
  if sy-subrc ne 0.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '-1'
        olddate = date1
      importing
        newdate = date2.
*    WRITE : / 'old date',date2.
    month = date2+4(2).
    year = date2+0(4).
    select * from zdsmter into table it_zdsmter where zmonth eq mth and zyear eq yr and zdsm in zone.
    if sy-subrc ne 0.
      exit.
    endif.
  endif.
*&---------------------------------------------------------------------*
*&      Form  NAMEUPDT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form nameupdt .
  data : mdate1 type sy-datum.

  mth = mdate+4(2).
  yr  = mdate+0(4).

  mdate1 = mdate.
  mdate1+6(2) = '16'.
  write : /1 mdate.
  select * from zdsmter into table it_zdsmter where zmonth eq mth and zyear eq yr and zdsm in zone.
*loop at it_zdsmter into wa_zdsmter where bzirk+0(2) cs 'R-'.
  loop at it_zdsmter into wa_zdsmter where bzirk in ter.
    select single * from yterrallc where bzirk eq wa_zdsmter-zdsm and begda le mdate and endda ge mdate.
*   write : / 'data found', yterrallc-begda, yterrallc-endda, yterrallc-bzirk..
    if sy-subrc = 0.
*      write : / 'data found', yterrallc-begda, yterrallc-endda.
      select single * from yterrallc where bzirk eq wa_zdsmter-bzirk and begda le mdate and endda ge mdate.
      if sy-subrc = 0.
*         write : / 'data found', yterrallc-begda, yterrallc-endda, yterrallc-bzirk..
        wa_tac1-reg = wa_zdsmter-zdsm.
        wa_tac1-rm = wa_zdsmter-bzirk.
        collect wa_tac1 into it_tac1.
        clear wa_tac1.
      endif.
    endif.
  endloop.

  clear it_zdsmter.

*IF R6 = 'X'.
  loop at it_tac1 into wa_tac1 where rm cs 'Z-' .
    select * from zdsmter into table it_zdsmter where zmonth eq mth and zyear eq yr and zdsm = wa_tac1-rm .
    loop at it_zdsmter into wa_zdsmter.
      wa_tac11-reg = wa_tac1-rm.
      wa_tac11-rm  = wa_zdsmter-bzirk..
*       WRITE : /1 WA_TAC11-REG ,wa_TAC11-RM .
      collect wa_tac11 into it_tac11.
      clear :  wa_tac11 .
    endloop.
  endloop.
  if r7 = 'X'.
    clear : it_tac11, wa_tac11.
    loop at it_tac1 into wa_tac1 where rm cs 'R-'  and reg cs 'D-'.
      select * from zdsmter into table it_zdsmter where zmonth eq mth and zyear eq yr and bzirk = wa_tac1-reg .
      loop at it_zdsmter into wa_zdsmter.
        wa_tac11-reg = wa_zdsmter-zdsm..
        wa_tac11-rm  = wa_tac1-rm.
*       WRITE : /1 WA_TAC11-REG ,wa_TAC11-RM .
        collect wa_tac11 into it_tac11.
        clear :  wa_tac11 .
      endloop.
    endloop.

  endif.
  clear it_zdsmter.

  sort it_tac1 by reg.
  loop at it_tac1 into wa_tac1.
*      WRITE :/1 wa_taC1-reg , wa_taC1-rm.
    select * from zdsmter into table it_zdsmter where zdsm eq wa_tac1-rm and zmonth eq mth and zyear eq yr
            and zdsm in ter.
    loop at it_zdsmter into wa_zdsmter.
*      WRITE :/1 wa_zdsmter-ZDSM.
*      WRITE :/1 wa_TAC1-REG , wa_TAC1-RM,  WA_zdsmter-ZDSM.
      select single * from yterrallc where bzirk eq wa_zdsmter-bzirk and begda le mdate and endda ge mdate.
      if sy-subrc = 0.
        wa_tac2-reg = wa_tac1-reg.
        wa_tac2-rm = wa_tac1-rm.
        wa_tac2-bzirk = wa_zdsmter-bzirk.
        collect wa_tac2 into it_tac2.
      else.
        select single * from yterrallc where bzirk eq wa_zdsmter-bzirk and begda le mdate and endda >= cryrdt.
*        IF YTERRALLC-endda >= CRYRDT.
        if sy-subrc = 0.
          wa_tac2-reg = wa_tac1-reg.
          wa_tac2-rm = wa_tac1-rm.
          wa_tac2-bzirk = wa_zdsmter-bzirk.
          collect wa_tac2 into it_tac2.
          clear wa_tac2.
        endif.
      endif.
      clear wa_tac2.
    endloop.
  endloop.

*  SORT IT_tac2 BY bzirk.
*  DELETE ADJACENT DUPLICATES FROM IT_tac2 COMPARING BZIRK.
  sort it_tac2 by reg rm bzirk.
  loop at it_tac2 into wa_tac2.
*   WRITE :/1 wa_TAC2-REG , wa_TAC2-RM,  WA_tac2-bzirk.
    select single * from zdrphq where bzirk eq wa_tac2-rm .
    if sy-subrc = 0.
      mhq = zdrphq-zz_hqcode.
    else.
      mhq = ''.
    endif.
    select single * from yterrallc where bzirk eq wa_tac2-rm and begda le mdate and endda ge sy-datum.
    if sy-subrc = 0.
      mplan = yterrallc-plans.
      select single * from pa0001 where plans = mplan and begda le mdate1 and endda ge mdate . " sy-datum.
      if sy-subrc = 0.
        mename = pa0001-ename.
        mpernr = pa0001-pernr.
      else.
        mename = 'VACANT'.
        mpernr = 0.
      endif.
    else.
      mplan = 0.
      mename = 'VACANT'.
      mpernr = 0.
    endif.

    wa_tac3-reg = wa_tac2-reg.
    read table it_tac11 into wa_tac11 with key rm = wa_tac2-rm.
    if sy-subrc = 0.
      wa_tac3-zm = wa_tac11-reg.
    endif.
    wa_tac3-rm = wa_tac2-rm.
    wa_tac3-bzirk = wa_tac2-bzirk.
    wa_tac3-pernr = mpernr.
    wa_tac3-ename = mename.
    wa_tac3-hq = mhq.
*    WRITE : /1 WA_TAC3-REG , WA_TAC3-RM, WA_TAC3-ZM, WA_TAC3-BZIRK.
    collect wa_tac3 into it_tac3.
    clear wa_tac3.

  endloop.
endform.                    " NAMEUPDT

*&---------------------------------------------------------------------*
*&      Form  MTHLYDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form mthlydata .
  c_date = pdate.
  mth = c_date+4(2).
  yr  = c_date+0(4).
* WRITE : /1 C_DATE , MTH , YR .


  if it_tac3 is not initial.
*  WRITE :/1 'APR-14'.
    select bzirk matnr grosspts grossqty  from zrpqv into table it_tabp1
                 for all entries in it_tac3
                     where  zmonth = mth and zyear = yr and bzirk = it_tac3-bzirk.

    select bzirk  month01 month02 month03 month04 month05 month06
                    month07 month08 month09 month10 month11 month12
                      from ysd_dist_targt into table it_tgtp1 where  trgyear = yr .
*                      FOR ALL ENTRIES IN IT_TAC3
*                        where  trgyear = YR . "  AND BZIRK = IT_TAC3-BZIRK.

* select bzirk  NETVAL from ZRCUMPSO into table it_NETVALP1
*                      FOR ALL ENTRIES IN IT_TAC3  WHERE  ZMONTH = MTH AND
*                         ZYEAR  = YR AND BZIRK = IT_TAC3-BZIRK.
    select bzirk  netval from zrcumpso into table it_netvalp1 where  zmonth = mth and zyear  = yr . " AND BZIRK = IT_TAC3-BZIRK.

  endif.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '1'
      olddate = c_date
    importing
      newdate = c_date.
  mth = c_date+4(2).
  yr  = c_date+0(4).

  if it_tac3 is not initial.
    select bzirk matnr grosspts grossqty  from zrpqv into table it_tabp2
          for all entries in it_tac3
          where  zmonth = mth and zyear = yr  and bzirk = it_tac3-bzirk.

    select bzirk  netval from zrcumpso into table it_netvalp2  where  zmonth = mth and zyear  = yr. " AND BZIRK = IT_TAC3-BZIRK.
  endif.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '1'
      olddate = c_date
    importing
      newdate = c_date.
  mth = c_date+4(2).
  yr  = c_date+0(4).
  if it_tac3 is not initial.
    select bzirk matnr grosspts grossqty  from zrpqv into table it_tabp3
      for all entries in it_tac3
      where  zmonth = mth and zyear = yr and bzirk = it_tac3-bzirk.

    select bzirk  netval from zrcumpso into table it_netvalp3 where  zmonth = mth and zyear  = yr. " AND BZIRK = IT_TAC3-BZIRK.
  endif.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '1'
      olddate = c_date
    importing
      newdate = c_date.
  mth = c_date+4(2).
  yr  = c_date+0(4).

  if it_tac3 is not initial.
    select bzirk matnr grosspts grossqty  from zrpqv into table it_tabp4
      for all entries in it_tac3
      where  zmonth = mth and zyear = yr and bzirk = it_tac3-bzirk.

    select bzirk  netval from zrcumpso into table it_netvalp4 where  zmonth = mth and  zyear  = yr. " AND BZIRK = IT_TAC3-BZIRK.
  endif.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '1'
      olddate = c_date
    importing
      newdate = c_date.
  mth = c_date+4(2).
  yr  = c_date+0(4).

  if it_tac3 is not initial.
    select bzirk matnr grosspts grossqty  from zrpqv into table it_tabp5
      for all entries in it_tac3
      where  zmonth = mth and zyear = yr and bzirk = it_tac3-bzirk.
    select bzirk  netval from zrcumpso into table it_netvalp5  where  zmonth = mth and  zyear  = yr. "  AND BZIRK = IT_TAC3-BZIRK.
  endif.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '1'
      olddate = c_date
    importing
      newdate = c_date.
  mth = c_date+4(2).
  yr  = c_date+0(4).

  if it_tac3 is not initial.
    select bzirk matnr grosspts grossqty  from zrpqv into table it_tabp6
      for all entries in it_tac3
      where  zmonth = mth and zyear = yr and bzirk = it_tac3-bzirk.
    select bzirk  netval from zrcumpso into table it_netvalp6 where  zmonth = mth and zyear  = yr. "  AND BZIRK = IT_TAC3-BZIRK.
  endif.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '1'
      olddate = c_date
    importing
      newdate = c_date.
  mth = c_date+4(2).
  yr  = c_date+0(4).

  if it_tac3 is not initial.
    select bzirk matnr grosspts grossqty  from zrpqv into table it_tabp7
     for all entries in it_tac3
     where  zmonth = mth and zyear = yr and bzirk = it_tac3-bzirk.
    select bzirk  netval from zrcumpso into table it_netvalp7  where  zmonth = mth and zyear  = yr. "  AND BZIRK = IT_TAC3-BZIRK.
  endif.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '1'
      olddate = c_date
    importing
      newdate = c_date.
  mth = c_date+4(2).
  yr  = c_date+0(4).

  if it_tac3 is not initial.
    select bzirk matnr grosspts grossqty  from zrpqv into table it_tabp8
      for all entries in it_tac3
      where  zmonth = mth and zyear = yr and bzirk = it_tac3-bzirk.
    select bzirk  netval from zrcumpso into table it_netvalp8 where  zmonth = mth and zyear  = yr . " AND BZIRK = IT_TAC3-BZIRK.
  endif.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '1'
      olddate = c_date
    importing
      newdate = c_date.
  mth = c_date+4(2).
  yr  = c_date+0(4).

  if it_tac3 is not initial.
    select bzirk matnr grosspts grossqty  from zrpqv into table it_tabp9
      for all entries in it_tac3
      where  zmonth = mth and zyear = yr and bzirk = it_tac3-bzirk.
    select bzirk  netval from zrcumpso into table it_netvalp9 where  zmonth = mth and zyear  = yr. " AND BZIRK = IT_TAC3-BZIRK.
  endif.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '1'
      olddate = c_date
    importing
      newdate = c_date.
  mth = c_date+4(2).
  yr  = c_date+0(4).

  if it_tac3 is not initial.
    select bzirk matnr grosspts grossqty  from zrpqv into table it_tabp10
      for all entries in it_tac3
      where  zmonth = mth and zyear = yr and bzirk = it_tac3-bzirk.
    select bzirk  netval from zrcumpso into table it_netvalp10 where  zmonth = mth and zyear  = yr. " AND BZIRK = IT_TAC3-BZIRK.
  endif.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '1'
      olddate = c_date
    importing
      newdate = c_date.
  mth = c_date+4(2).
  yr  = c_date+0(4).

  if it_tac3 is not initial.
    select bzirk matnr grosspts grossqty  from zrpqv into table it_tabp11
      for all entries in it_tac3
      where  zmonth = mth and zyear = yr and bzirk = it_tac3-bzirk.
    select bzirk  netval from zrcumpso into table it_netvalp11  where  zmonth = mth and zyear  = yr. " AND BZIRK = IT_TAC3-BZIRK.
  endif.
  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '1'
      olddate = c_date
    importing
      newdate = c_date.
  mth = c_date+4(2).
  yr  = c_date+0(4).

  if it_tac3 is not initial.
    select bzirk matnr grosspts grossqty  from zrpqv into table it_tabp12
      for all entries in it_tac3
      where  zmonth = mth and zyear = yr and bzirk = it_tac3-bzirk.
    select bzirk  netval from zrcumpso into table it_netvalp12 where  zmonth = mth and zyear  = yr.

  endif.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '1'
      olddate = c_date
    importing
      newdate = c_date.
  mth = c_date+4(2).
  yr  = c_date+0(4).
  mctr = 1.
  if it_tac3 is not initial.
    aprdt = c_date.
*****    select bzirk matnr grosspts grossqty  from zrpqv into table it_tab1
    select bzirk matnr grosspts grossqty  from zpqv into table it_tab1
                  for all entries in it_tac3
                    where  zmonth = mth and zyear = yr and bzirk = it_tac3-bzirk.
    select bzirk  month01 month02 month03 month04 month05 month06
                  month07 month08 month09 month10 month11 month12
                    from ysd_dist_targt into table it_tgt1 where  trgyear = yr . "AND BZIRK = IT_TAC3-BZIRK.
*****    select bzirk  netval from zrcumpso into table it_netval1 where  zmonth = mth and zyear  = yr . " AND BZIRK = IT_TAC3-BZIRK.
    select bzirk  netval from zcumpso into table it_netval1 where  zmonth = mth and zyear  = yr . " AND BZIRK = IT_TAC3-BZIRK.
    mctr = 1.
  endif.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '1'
      olddate = c_date
    importing
      newdate = c_date.
  mth = c_date+4(2).
  yr  = c_date+0(4).
  maydt = c_date.
  if c_date <= mdate and  it_tac3 is not initial.

*****    select bzirk matnr grosspts grossqty  from zrpqv into table it_tab2
    select bzirk matnr grosspts grossqty  from zpqv into table it_tab2
      for all entries in it_tac3
      where  zmonth = mth and zyear = yr and bzirk = it_tac3-bzirk.
*****    select bzirk  netval from zrcumpso into table it_netval2 where  zmonth = mth and zyear  = yr . "AND BZIRK = IT_TAC3-BZIRK.
    select bzirk  netval from zcumpso into table it_netval2 where  zmonth = mth and zyear  = yr . "AND BZIRK = IT_TAC3-BZIRK.
    mctr = 2.
  endif.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '1'
      olddate = c_date
    importing
      newdate = c_date.
  mth = c_date+4(2).
  yr  = c_date+0(4).
  jundt = c_date.
  if c_date <= mdate and it_tac3 is not initial.

*****    select bzirk matnr grosspts grossqty  from zrpqv into table it_tab3
    select bzirk matnr grosspts grossqty  from zpqv into table it_tab3
      for all entries in it_tac3
      where  zmonth = mth and zyear = yr and bzirk = it_tac3-bzirk.
*****    select bzirk  netval from zrcumpso into table it_netval3 where  zmonth = mth and zyear  = yr. " AND BZIRK = IT_TAC3-BZIRK.
    select bzirk  netval from zcumpso into table it_netval3 where  zmonth = mth and zyear  = yr. " AND BZIRK = IT_TAC3-BZIRK.
    mctr = 3.
  endif.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '1'
      olddate = c_date
    importing
      newdate = c_date.
  mth = c_date+4(2).
  yr  = c_date+0(4).
  juldt = c_date.
  if c_date <= mdate and it_tac3 is not initial.
*****    select bzirk matnr grosspts grossqty  from zrpqv into table it_tab4
    select bzirk matnr grosspts grossqty  from zpqv into table it_tab4
      for all entries in it_tac3
      where  zmonth = mth and zyear = yr and bzirk = it_tac3-bzirk.
*****    select bzirk  netval from zrcumpso into table it_netval4 where  zmonth = mth and zyear  = yr. "  AND BZIRK = IT_TAC3-BZIRK.
    select bzirk  netval from zcumpso into table it_netval4 where  zmonth = mth and zyear  = yr. "  AND BZIRK = IT_TAC3-BZIRK.
    mctr = 4.
  endif.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '1'
      olddate = c_date
    importing
      newdate = c_date.
  mth = c_date+4(2).
  yr  = c_date+0(4).
  augdt = c_date.
  if c_date <= mdate and  it_tac3 is not initial.
*****    select bzirk matnr grosspts grossqty  from zrpqv into table it_tab5
    select bzirk matnr grosspts grossqty  from zpqv into table it_tab5
      for all entries in it_tac3
      where  zmonth = mth and zyear = yr and bzirk = it_tac3-bzirk.
*****    select bzirk  netval from zrcumpso into table it_netval5 where  zmonth = mth and zyear  = yr. " AND BZIRK = IT_TAC3-BZIRK.
    select bzirk  netval from zcumpso into table it_netval5 where  zmonth = mth and zyear  = yr. " AND BZIRK = IT_TAC3-BZIRK.
    mctr = 5.
  endif.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '1'
      olddate = c_date
    importing
      newdate = c_date.
  mth = c_date+4(2).
  yr  = c_date+0(4).
  sepdt = c_date.
  if c_date <= mdate and it_tac3 is not initial.
*****    select bzirk matnr grosspts grossqty  from zrpqv into table it_tab6
    select bzirk matnr grosspts grossqty  from zpqv into table it_tab6
      for all entries in it_tac3
      where  zmonth = mth and zyear = yr and bzirk = it_tac3-bzirk.
*****    select bzirk  netval from zrcumpso into table it_netval6 where  zmonth = mth and zyear  = yr. " AND BZIRK = IT_TAC3-BZIRK.
    select bzirk  netval from zcumpso into table it_netval6 where  zmonth = mth and zyear  = yr. " AND BZIRK = IT_TAC3-BZIRK.
    mctr = 6.
  endif.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '1'
      olddate = c_date
    importing
      newdate = c_date.
  mth = c_date+4(2).
  yr  = c_date+0(4).
  octdt = c_date.
  if c_date <= mdate and it_tac3 is not initial.
*****    select bzirk matnr grosspts grossqty  from zrpqv into table it_tab7
    select bzirk matnr grosspts grossqty  from zpqv into table it_tab7
      for all entries in it_tac3
      where  zmonth = mth and zyear = yr and bzirk = it_tac3-bzirk.
*****    select bzirk  netval from zrcumpso into table it_netval7 where  zmonth = mth and zyear  = yr . " AND BZIRK = IT_TAC3-BZIRK.
    select bzirk  netval from zcumpso into table it_netval7 where  zmonth = mth and zyear  = yr . " AND BZIRK = IT_TAC3-BZIRK.
    mctr = 7.
  endif.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '1'
      olddate = c_date
    importing
      newdate = c_date.
  mth = c_date+4(2).
  yr  = c_date+0(4).
  novdt = c_date.
  if c_date <= mdate and  it_tac3 is not initial.
    novdt = c_date.
*****    select bzirk matnr grosspts grossqty  from zrpqv into table it_tab8
    select bzirk matnr grosspts grossqty  from zpqv into table it_tab8
      for all entries in it_tac3
      where  zmonth = mth and zyear = yr and bzirk = it_tac3-bzirk.
*****    select bzirk  netval from zrcumpso into table it_netval8 where  zmonth = mth and zyear  = yr. " AND BZIRK = IT_TAC3-BZIRK.
    select bzirk  netval from zcumpso into table it_netval8 where  zmonth = mth and zyear  = yr. " AND BZIRK = IT_TAC3-BZIRK.
    mctr = 8.
  endif.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '1'
      olddate = c_date
    importing
      newdate = c_date.
  mth = c_date+4(2).
  yr  = c_date+0(4).
  decdt = c_date.
  if c_date <= mdate and it_tac3 is not initial.
    decdt = c_date.
*****    select bzirk matnr grosspts grossqty  from zrpqv into table it_tab9
    select bzirk matnr grosspts grossqty  from zpqv into table it_tab9
      for all entries in it_tac3
      where  zmonth = mth and zyear = yr and bzirk = it_tac3-bzirk.
*****    select bzirk  netval from zrcumpso into table it_netval9 where  zmonth = mth and zyear  = yr. " AND BZIRK = IT_TAC3-BZIRK.
    select bzirk  netval from zcumpso into table it_netval9 where  zmonth = mth and zyear  = yr. " AND BZIRK = IT_TAC3-BZIRK.
    mctr = 9.
  endif.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '1'
      olddate = c_date
    importing
      newdate = c_date.
  mth = c_date+4(2).
  yr  = c_date+0(4).
  jandt = c_date.
  if c_date <= mdate and it_tac3 is not initial.

****    select bzirk matnr grosspts grossqty  from zrpqv into table it_tab10
    select bzirk matnr grosspts grossqty  from zpqv into table it_tab10
      for all entries in it_tac3
      where  zmonth = mth and zyear = yr and bzirk = it_tac3-bzirk.
*****    select bzirk  netval from zrcumpso into table it_netval10 where  zmonth = mth and zyear  = yr. " AND BZIRK = IT_TAC3-BZIRK.
    select bzirk  netval from zcumpso into table it_netval10 where  zmonth = mth and zyear  = yr. " AND BZIRK = IT_TAC3-BZIRK.
    mctr = 10.
  endif.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '1'
      olddate = c_date
    importing
      newdate = c_date.
  mth = c_date+4(2).
  yr  = c_date+0(4).
  febdt = c_date.
  if c_date <= mdate and it_tac3 is not initial.

*****    select bzirk matnr grosspts grossqty  from zrpqv into table it_tab11
    select bzirk matnr grosspts grossqty  from zpqv into table it_tab11
             for all entries in it_tac3  where  zmonth = mth and zyear = yr and bzirk = it_tac3-bzirk.
*****    select bzirk  netval from zrcumpso into table it_netval11 where  zmonth = mth and zyear  = yr . " AND BZIRK = IT_TAC3-BZIRK.
    select bzirk  netval from zcumpso into table it_netval11 where  zmonth = mth and zyear  = yr . " AND BZIRK = IT_TAC3-BZIRK.
    mctr = 11.
  endif.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '1'
      olddate = c_date
    importing
      newdate = c_date.
  mth = c_date+4(2).
  yr  = c_date+0(4).
  mardt = c_date.
  if c_date <= mdate and it_tac3 is not initial.
*****    select bzirk matnr grosspts grossqty  from zrpqv into table it_tab12
    select bzirk matnr grosspts grossqty  from zpqv into table it_tab12
      for all entries in it_tac3     where  zmonth = mth and zyear = yr and bzirk = it_tac3-bzirk.
*****    select bzirk  netval from zrcumpso into table it_netval12 where  zmonth = mth and zyear  = yr. " AND BZIRK = IT_TAC3-BZIRK.
    select bzirk  netval from zcumpso into table it_netval12 where  zmonth = mth and zyear  = yr. " AND BZIRK = IT_TAC3-BZIRK.
    mctr = 12.
  endif.

endform.                    " MTHLYDATA
*&---------------------------------------------------------------------*
*&      Form  SUMMARIZEDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form summarizedata .
  ctr = 0.
  loop at it_tabp1 into wa_tabp1.
    read table it_tac3 into  wa_tac3 with key bzirk = wa_tabp1-bzirk.
    wa_tabtot-bzirk = wa_tac3-rm.
    wa_tabtot-apr_pqty = wa_tabp1-grossqty.
    wa_tabtot-apr_pgrosspts = wa_tabp1-grosspts.
    wa_tabtot-matnr = wa_tabp1-matnr.
    collect wa_tabtot into it_tabtot.
    clear wa_tabtot.
*        WRITE :/1 wa_tabp1-BZIRK, WA_TAC3-RM.
  endloop.

  loop at it_tabp2 into wa_tabp2.
    read table it_tac3 into  wa_tac3 with key bzirk = wa_tabp2-bzirk.
    wa_tabtot-bzirk = wa_tac3-rm.
    wa_tabtot-may_pqty = wa_tabp2-grossqty.
    wa_tabtot-may_pgrosspts = wa_tabp2-grosspts.
    wa_tabtot-matnr = wa_tabp2-matnr.
    collect wa_tabtot into it_tabtot.
    clear wa_tabtot.
  endloop.
  loop at it_tabp3 into wa_tabp3.
    read table it_tac3 into  wa_tac3 with key bzirk = wa_tabp3-bzirk.
    wa_tabtot-bzirk = wa_tac3-rm.
    wa_tabtot-jun_pqty = wa_tabp3-grossqty.
    wa_tabtot-jun_pgrosspts = wa_tabp3-grosspts.
    wa_tabtot-matnr = wa_tabp3-matnr.
    collect wa_tabtot into it_tabtot.
    clear wa_tabtot.
  endloop.
  loop at it_tabp4 into wa_tabp4.
    read table it_tac3 into  wa_tac3 with key bzirk = wa_tabp4-bzirk.
    wa_tabtot-bzirk = wa_tac3-rm.
    wa_tabtot-jul_pqty = wa_tabp4-grossqty.
    wa_tabtot-jul_pgrosspts = wa_tabp4-grosspts.
    wa_tabtot-matnr = wa_tabp4-matnr.
    collect wa_tabtot into it_tabtot.
    clear wa_tabtot.
  endloop.
  loop at it_tabp5 into wa_tabp5.
    read table it_tac3 into  wa_tac3 with key bzirk = wa_tabp5-bzirk.
    wa_tabtot-bzirk = wa_tac3-rm.
    wa_tabtot-aug_pqty = wa_tabp5-grossqty.
    wa_tabtot-aug_pgrosspts = wa_tabp5-grosspts.
    wa_tabtot-matnr = wa_tabp5-matnr.
    collect wa_tabtot into it_tabtot.
    clear wa_tabtot.
  endloop.
  loop at it_tabp6 into wa_tabp6.
    read table it_tac3 into  wa_tac3 with key bzirk = wa_tabp6-bzirk.
    wa_tabtot-bzirk = wa_tac3-rm.
    wa_tabtot-sep_pqty = wa_tabp6-grossqty.
    wa_tabtot-sep_pgrosspts = wa_tabp6-grosspts.
    wa_tabtot-matnr = wa_tabp6-matnr.
    collect wa_tabtot into it_tabtot.
    clear wa_tabtot.
  endloop.

  loop at it_tabp7 into wa_tabp7.
    read table it_tac3 into  wa_tac3 with key bzirk = wa_tabp7-bzirk.
    wa_tabtot-bzirk = wa_tac3-rm.
    wa_tabtot-oct_pqty = wa_tabp7-grossqty.
    wa_tabtot-oct_pgrosspts = wa_tabp7-grosspts.
    wa_tabtot-matnr = wa_tabp7-matnr.
    collect wa_tabtot into it_tabtot.
    clear wa_tabtot.
  endloop.

  loop at it_tabp8 into wa_tabp8.
    read table it_tac3 into  wa_tac3 with key bzirk = wa_tabp8-bzirk.
    wa_tabtot-bzirk = wa_tac3-rm.
    wa_tabtot-nov_pqty = wa_tabp8-grossqty.
    wa_tabtot-nov_pgrosspts = wa_tabp8-grosspts.
    wa_tabtot-matnr = wa_tabp8-matnr.
    collect wa_tabtot into it_tabtot.
    clear wa_tabtot.
  endloop.

  loop at it_tabp9 into wa_tabp9.
    read table it_tac3 into  wa_tac3 with key bzirk = wa_tabp9-bzirk.
    wa_tabtot-bzirk = wa_tac3-rm.
    wa_tabtot-dec_pqty = wa_tabp9-grossqty.
    wa_tabtot-dec_pgrosspts = wa_tabp9-grosspts.
    wa_tabtot-matnr = wa_tabp9-matnr.
    collect wa_tabtot into it_tabtot.
    clear wa_tabtot.
  endloop.

  loop at it_tabp10 into wa_tabp10.
    read table it_tac3 into  wa_tac3 with key bzirk = wa_tabp10-bzirk.
    wa_tabtot-bzirk = wa_tac3-rm.
    wa_tabtot-jan_pqty = wa_tabp10-grossqty.
    wa_tabtot-jan_pgrosspts = wa_tabp10-grosspts.
    wa_tabtot-matnr = wa_tabp10-matnr.
    collect wa_tabtot into it_tabtot.
    clear wa_tabtot.
  endloop.

  loop at it_tabp11 into wa_tabp11.
    read table it_tac3 into  wa_tac3 with key bzirk = wa_tabp11-bzirk.
    wa_tabtot-bzirk = wa_tac3-rm.
    wa_tabtot-feb_pqty = wa_tabp11-grossqty.
    wa_tabtot-feb_pgrosspts = wa_tabp11-grosspts.
    wa_tabtot-matnr = wa_tabp11-matnr.
    collect wa_tabtot into it_tabtot.
    clear wa_tabtot.
  endloop.

  loop at it_tabp12 into wa_tabp12.
    read table it_tac3 into  wa_tac3 with key bzirk = wa_tabp12-bzirk.
    wa_tabtot-bzirk = wa_tac3-rm.
    wa_tabtot-mar_pqty = wa_tabp12-grossqty.
    wa_tabtot-mar_pgrosspts = wa_tabp12-grosspts.
    wa_tabtot-matnr = wa_tabp12-matnr.
    collect wa_tabtot into it_tabtot.
    clear wa_tabtot.
  endloop.

  loop at it_tab1 into wa_tab1.
    read table it_tac3 into  wa_tac3 with key bzirk = wa_tab1-bzirk.
    wa_tabtot-bzirk = wa_tac3-rm.
    wa_tabtot-apr_grosspts = wa_tab1-grosspts.
    wa_tabtot-apr_qty = wa_tab1-grossqty.
    wa_tabtot-matnr = wa_tab1-matnr.
    collect wa_tabtot into it_tabtot.
    clear wa_tabtot.
  endloop.

  loop at it_tab2 into wa_tab2.
    read table it_tac3 into  wa_tac3 with key bzirk = wa_tab2-bzirk.
    wa_tabtot-bzirk = wa_tac3-rm.
    wa_tabtot-may_grosspts = wa_tab2-grosspts.
    wa_tabtot-may_qty = wa_tab2-grossqty.
    wa_tabtot-matnr = wa_tab2-matnr.
    collect wa_tabtot into it_tabtot.
    clear wa_tabtot.
  endloop.

  loop at it_tab3 into wa_tab3.
    read table it_tac3 into  wa_tac3 with key bzirk = wa_tab3-bzirk.
    wa_tabtot-bzirk = wa_tac3-rm.
    wa_tabtot-jun_qty = wa_tab3-grossqty.
    wa_tabtot-jun_grosspts = wa_tab3-grosspts.
    wa_tabtot-matnr = wa_tab3-matnr.
    collect wa_tabtot into it_tabtot.
    clear wa_tabtot.
  endloop.
  loop at it_tab4 into wa_tab4.
    read table it_tac3 into  wa_tac3 with key bzirk = wa_tab4-bzirk.
    wa_tabtot-bzirk = wa_tac3-rm.
    wa_tabtot-jul_qty = wa_tab4-grossqty.
    wa_tabtot-jul_grosspts = wa_tab4-grosspts.
    wa_tabtot-matnr = wa_tab4-matnr.
    collect wa_tabtot into it_tabtot.
    clear wa_tabtot.
  endloop.
  loop at it_tab5 into wa_tab5.
    read table it_tac3 into  wa_tac3 with key bzirk = wa_tab5-bzirk.
    wa_tabtot-bzirk = wa_tac3-rm.
    wa_tabtot-aug_qty = wa_tab5-grossqty.
    wa_tabtot-aug_grosspts = wa_tab5-grosspts.
    wa_tabtot-matnr = wa_tab5-matnr.
    collect wa_tabtot into it_tabtot.
    clear wa_tabtot.
  endloop.
  loop at it_tab6 into wa_tab6.
    read table it_tac3 into  wa_tac3 with key bzirk = wa_tab6-bzirk.
    wa_tabtot-bzirk = wa_tac3-rm.
    wa_tabtot-sep_qty = wa_tab6-grossqty.
    wa_tabtot-sep_grosspts = wa_tab6-grosspts.
    wa_tabtot-matnr = wa_tab6-matnr.
    collect wa_tabtot into it_tabtot.
    clear wa_tabtot.
  endloop.
  loop at it_tab7 into wa_tab7.
    read table it_tac3 into  wa_tac3 with key bzirk = wa_tab7-bzirk.
    wa_tabtot-bzirk = wa_tac3-rm.
    wa_tabtot-oct_qty = wa_tab7-grossqty.
    wa_tabtot-oct_grosspts = wa_tab7-grosspts.
    wa_tabtot-matnr = wa_tab7-matnr.
    collect wa_tabtot into it_tabtot.
    clear wa_tabtot.
  endloop.

  loop at it_tab8 into wa_tab8.
    read table it_tac3 into  wa_tac3 with key bzirk = wa_tab8-bzirk.
    wa_tabtot-bzirk = wa_tac3-rm.
    wa_tabtot-nov_qty = wa_tab8-grossqty.
    wa_tabtot-nov_grosspts = wa_tab8-grosspts.
    wa_tabtot-matnr = wa_tab8-matnr.
    collect wa_tabtot into it_tabtot.
    clear wa_tabtot.
  endloop.

  loop at it_tab9 into wa_tab9.
    read table it_tac3 into  wa_tac3 with key bzirk = wa_tab9-bzirk.
    wa_tabtot-bzirk = wa_tac3-rm.
    wa_tabtot-dec_qty = wa_tab9-grossqty.
    wa_tabtot-dec_grosspts = wa_tab9-grosspts.
    wa_tabtot-matnr = wa_tab9-matnr.
    collect wa_tabtot into it_tabtot.
    clear wa_tabtot.
  endloop.

  loop at it_tab10 into wa_tab10.
    read table it_tac3 into  wa_tac3 with key bzirk = wa_tab10-bzirk.
    wa_tabtot-bzirk = wa_tac3-rm.
    wa_tabtot-jan_qty = wa_tab10-grossqty.
    wa_tabtot-jan_grosspts = wa_tab10-grosspts.
    wa_tabtot-matnr = wa_tab10-matnr.
    collect wa_tabtot into it_tabtot.
    clear wa_tabtot.
  endloop.

  loop at it_tab11 into wa_tab11.
    read table it_tac3 into  wa_tac3 with key bzirk = wa_tab11-bzirk.
    wa_tabtot-bzirk = wa_tac3-rm.
    wa_tabtot-feb_qty = wa_tab11-grossqty.
    wa_tabtot-feb_grosspts = wa_tab11-grosspts.
    wa_tabtot-matnr = wa_tab11-matnr.
    collect wa_tabtot into it_tabtot.
    clear wa_tabtot.
  endloop.

  loop at it_tab12 into wa_tab12.
    read table it_tac3 into  wa_tac3 with key bzirk = wa_tab12-bzirk.
    wa_tabtot-bzirk = wa_tac3-rm.
    wa_tabtot-mar_qty = wa_tab12-grossqty.
    wa_tabtot-mar_grosspts = wa_tab12-grosspts.
    wa_tabtot-matnr = wa_tab12-matnr.
    collect wa_tabtot into it_tabtot.
    clear wa_tabtot.
  endloop.
  sort it_tabtot by bzirk matnr.
endform.                    " SUMMARIZEDATA
*&---------------------------------------------------------------------*
*&      Form  DISPDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form dispdata .
******** Added to show monthly growth instead of cumm.growth only in ALV output.
  loop at it_tabfin into wa_tabfin.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      wa_tabfin-apr_grth = ( ( wa_tabfin-apr_grosspts / wa_tabfin-apr_pgrosspts ) * 100 ) - 100 .
    endcatch.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      wa_tabfin-apr_qgrth = ( ( wa_tabfin-apr_qty / wa_tabfin-apr_pqty ) * 100 ) - 100 .
    endcatch.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      wa_tabfin-may_grth = ( ( wa_tabfin-may_grosspts / wa_tabfin-may_pgrosspts ) * 100 ) - 100 .
    endcatch.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      wa_tabfin-may_qgrth = ( ( wa_tabfin-may_qty / wa_tabfin-may_pqty ) * 100 ) - 100 .
    endcatch.

    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      wa_tabfin-jun_grth = ( ( wa_tabfin-jun_grosspts / wa_tabfin-jun_pgrosspts ) * 100 ) - 100 .
    endcatch.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      wa_tabfin-jun_qgrth = ( ( wa_tabfin-jun_qty / wa_tabfin-jun_pqty ) * 100 ) - 100 .
    endcatch.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      wa_tabfin-jul_grth = ( ( wa_tabfin-jul_grosspts / wa_tabfin-jul_pgrosspts ) * 100 ) - 100 .
    endcatch.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      wa_tabfin-jul_qgrth = ( ( wa_tabfin-jul_qty / wa_tabfin-jul_pqty ) * 100 ) - 100 .
    endcatch.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      wa_tabfin-aug_grth = ( ( wa_tabfin-aug_grosspts / wa_tabfin-aug_pgrosspts ) * 100 ) - 100 .
    endcatch.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      wa_tabfin-aug_qgrth = ( ( wa_tabfin-aug_qty / wa_tabfin-aug_pqty ) * 100 ) - 100 .
    endcatch.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      wa_tabfin-sep_grth = ( ( wa_tabfin-sep_grosspts / wa_tabfin-sep_pgrosspts ) * 100 ) - 100 .
    endcatch.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      wa_tabfin-sep_qgrth = ( ( wa_tabfin-sep_qty / wa_tabfin-sep_pqty ) * 100 ) - 100 .
    endcatch.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      wa_tabfin-oct_grth = ( ( wa_tabfin-oct_grosspts / wa_tabfin-oct_pgrosspts ) * 100 ) - 100 .
    endcatch.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      wa_tabfin-oct_qgrth = ( ( wa_tabfin-oct_qty / wa_tabfin-oct_pqty ) * 100 ) - 100 .
    endcatch.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      wa_tabfin-nov_grth = ( ( wa_tabfin-nov_grosspts / wa_tabfin-nov_pgrosspts ) * 100 ) - 100 .
    endcatch.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      wa_tabfin-nov_qgrth = ( ( wa_tabfin-nov_qty / wa_tabfin-nov_pqty ) * 100 ) - 100 .
    endcatch.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      wa_tabfin-dec_grth = ( ( wa_tabfin-dec_grosspts / wa_tabfin-dec_pgrosspts ) * 100 ) - 100 .
    endcatch.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      wa_tabfin-dec_qgrth = ( ( wa_tabfin-dec_qty / wa_tabfin-dec_pqty ) * 100 ) - 100 .
    endcatch.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      wa_tabfin-jan_grth = ( ( wa_tabfin-jan_grosspts / wa_tabfin-jan_pgrosspts ) * 100 ) - 100 .
    endcatch.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      wa_tabfin-jan_qgrth = ( ( wa_tabfin-jan_qty / wa_tabfin-jan_pqty ) * 100 ) - 100 .
    endcatch.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      wa_tabfin-feb_grth = ( ( wa_tabfin-feb_grosspts / wa_tabfin-feb_pgrosspts ) * 100 ) - 100 .
    endcatch.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      wa_tabfin-feb_qgrth = ( ( wa_tabfin-feb_qty / wa_tabfin-feb_pqty ) * 100 ) - 100 .
    endcatch.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      wa_tabfin-mar_grth = ( ( wa_tabfin-mar_grosspts / wa_tabfin-mar_pgrosspts ) * 100 ) - 100 .
    endcatch.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      wa_tabfin-mar_qgrth = ( ( wa_tabfin-mar_qty / wa_tabfin-mar_pqty ) * 100 ) - 100 .
    endcatch.
    modify it_tabfin from wa_tabfin transporting apr_grth apr_qgrth may_grth may_qgrth jun_grth jun_qgrth jul_grth jul_qgrth
                                                 aug_grth aug_qgrth sep_grth sep_qgrth oct_grth oct_qgrth nov_grth nov_qgrth
                                                 dec_grth dec_qgrth jan_grth jan_qgrth feb_grth feb_qgrth mar_grth mar_qgrth.
    clear wa_tabfin.
  endloop.

  clear wa_fieldcat.
  clear fieldcat.
  wa_fieldcat-fieldname = 'ENAME'.
  wa_fieldcat-seltext_l = 'ENAME'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'GRP_CODE'.
  wa_fieldcat-seltext_l = 'GRP_CODE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'GRP_NAME'.
  wa_fieldcat-seltext_l = 'GRP_NAME'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'BZIRK'.
  wa_fieldcat-seltext_l = 'BZIRK'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'APR_PGROSSPTS'.
  wa_fieldcat-seltext_l = 'APR PREV YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'APR_GROSSPTS'.
  wa_fieldcat-seltext_l = 'APR CURR YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'APR_GRTH'.
  wa_fieldcat-seltext_l = 'APR GRTH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MAY_PGROSSPTS'.
  wa_fieldcat-seltext_l = 'MAY PREV YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MAY_GROSSPTS'.
  wa_fieldcat-seltext_l = 'MAY CURR YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MAY_GRTH'.
  wa_fieldcat-seltext_l = 'MAY GRTH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'JUN_PGROSSPTS'.
  wa_fieldcat-seltext_l = 'JUN PREV YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'JUN_GROSSPTS'.
  wa_fieldcat-seltext_l = 'JUN CURR YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'JUN_GRTH'.
  wa_fieldcat-seltext_l = 'JUN GRTH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'JUL_PGROSSPTS'.
  wa_fieldcat-seltext_l = 'JUL PREV YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'JUL_GROSSPTS'.
  wa_fieldcat-seltext_l = 'JUL CURR YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'JUL_GRTH'.
  wa_fieldcat-seltext_l = 'JUL GRTH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'AUG_PGROSSPTS'.
  wa_fieldcat-seltext_l = 'AUG PREV YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'AUG_GROSSPTS'.
  wa_fieldcat-seltext_l = 'AUG CURR YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'AUG_GRTH'.
  wa_fieldcat-seltext_l = 'AUG GRTH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'SEP_PGROSSPTS'.
  wa_fieldcat-seltext_l = 'SEP PREV YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'SEP_GROSSPTS'.
  wa_fieldcat-seltext_l = 'SEP CURR YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'SEP_GRTH'.
  wa_fieldcat-seltext_l = 'SEP GRTH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'OCT_PGROSSPTS'.
  wa_fieldcat-seltext_l = 'OCT PREV YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'OCT_GROSSPTS'.
  wa_fieldcat-seltext_l = 'OCT CURR YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'OCT_GRTH'.
  wa_fieldcat-seltext_l = 'OCT GRTH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'NOV_PGROSSPTS'.
  wa_fieldcat-seltext_l = 'NOV PREV YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'NOV_GROSSPTS'.
  wa_fieldcat-seltext_l = 'NOV CURR YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'NOV_GRTH'.
  wa_fieldcat-seltext_l = 'NOV GRTH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'DEC_PGROSSPTS'.
  wa_fieldcat-seltext_l = 'DEC PREV YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'DEC_GROSSPTS'.
  wa_fieldcat-seltext_l = 'DEC CURR YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'DEC_GRTH'.
  wa_fieldcat-seltext_l = 'DEC GRTH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'JAN_PGROSSPTS'.
  wa_fieldcat-seltext_l = 'JAN PREV YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'JAN_GROSSPTS'.
  wa_fieldcat-seltext_l = 'JAN CURR YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'JAN_GRTH'.
  wa_fieldcat-seltext_l = 'JAN GRTH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'FEB_PGROSSPTS'.
  wa_fieldcat-seltext_l = 'FEB PREV YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'FEB_GROSSPTS'.
  wa_fieldcat-seltext_l = 'FEB CURR YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'FEB_GRTH'.
  wa_fieldcat-seltext_l = 'FEB GRTH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MAR_PGROSSPTS'.
  wa_fieldcat-seltext_l = 'MAR PREV YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MAR_GROSSPTS'.
  wa_fieldcat-seltext_l = 'MAR CURR YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MAR_GRTH'.
  wa_fieldcat-seltext_l = 'MAR GRTH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'ASOF_VALTOT'.
  wa_fieldcat-seltext_l = 'PREV TOT '.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CURR_VALTOT'.
  wa_fieldcat-seltext_l = 'CURR TOT '.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'GRTH'.
  wa_fieldcat-seltext_l = 'GROWTH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'PREV_GROSSPTS'.
  wa_fieldcat-seltext_l = 'TOTAL PR.YR '.
  append wa_fieldcat to fieldcat.

  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'SR-13 : RM/MONTH WISE PRODUCT GROUPWISE REPORT'.

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
      t_outtab                = it_tabfin
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

endform.                    " DISPDATA

form top.

  data: comment     type  slis_t_listheader,
        wa_comment1 like line of comment,
        wa_comment  like line of comment.

  wa_comment-typ = 'A'.
  if r1 = 'X'.
    wa_comment-info = 'SR-13 : RM/MONTH WISE PRODUCT GROUPWISE VALUE SALE AS OF'.
  elseif r2 = 'X'.
    wa_comment-info = 'SR-13 : RM/MONTH WISE PRODUCT GROUPWISE UNIT SALE AS OF'.
  endif.
  c_date := mdate.
*   WA_COMMENT-INFO = MDATE.

*  PERFORM MTH_NAMES_GET.

* wa_comment-info+45{10) = MONTH_NAMES_GET(s_budat-low).

  mm = mdate+4(2).
  call function 'MONTH_NAMES_GET'
    tables
      month_names = month_name.
  read table month_name index mm.

  wa_comment-info+44(3) = month_name-ktx.
  wa_comment-info+47(1) = '`'.
  wa_comment-info+48(2) = mdate+2(2).

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
*&      Form  GRPDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form grpdata .
  loop at it_tabtot into wa_tabtot.
    read table it_tac3 into  wa_tac3 with key rm = wa_tabtot-bzirk.
*         WRITE :/1 WA_tabtot-bzirk, WA_TABTOT-APR_GROSSPTS.
*         select  single * FROM it_tac3  where bzirk = wa_tabtot-bzirk.
    wa_tabfin-ename  = wa_tac3-ename.
    wa_tabfin-hq     = wa_tac3-hq.
    wa_tabfin-pernr  = wa_tac3-pernr.
    wa_tabfin-bzirk = wa_tabtot-bzirk.
    select single * from zprdgroup where prd_code  eq wa_tabtot-matnr and rep_type = 'SR121314'.
    wa_tabfin-grp_code  = zprdgroup-grp_code.
    wa_tabfin-grp_name  = zprdgroup-grp_name.
    wa_tabfin-prn_seq = zprdgroup-prn_seq.
    wa_tabfin-spart = zprdgroup-grp_div.
    wa_tabfin-apr_grosspts = wa_tabtot-apr_grosspts.
    wa_tabfin-apr_pgrosspts = wa_tabtot-apr_pgrosspts.
    wa_tabfin-apr_qty = wa_tabtot-apr_qty.
    wa_tabfin-apr_pqty = wa_tabtot-apr_pqty.
    wa_tabfin-may_grosspts = wa_tabtot-may_grosspts.
    wa_tabfin-may_pgrosspts = wa_tabtot-may_pgrosspts.
    wa_tabfin-may_qty = wa_tabtot-may_qty.
    wa_tabfin-may_pqty = wa_tabtot-may_pqty.
    wa_tabfin-jun_grosspts = wa_tabtot-jun_grosspts.
    wa_tabfin-jun_pgrosspts = wa_tabtot-jun_pgrosspts.
    wa_tabfin-jun_qty = wa_tabtot-jun_qty.
    wa_tabfin-jun_pqty = wa_tabtot-jun_pqty.
    wa_tabfin-jul_grosspts = wa_tabtot-jul_grosspts.
    wa_tabfin-jul_pgrosspts = wa_tabtot-jul_pgrosspts.
    wa_tabfin-jul_qty = wa_tabtot-jul_qty.
    wa_tabfin-jul_pqty = wa_tabtot-jul_pqty.
    wa_tabfin-aug_grosspts = wa_tabtot-aug_grosspts.
    wa_tabfin-aug_pgrosspts = wa_tabtot-aug_pgrosspts.
    wa_tabfin-aug_qty = wa_tabtot-aug_qty.
    wa_tabfin-aug_pqty = wa_tabtot-aug_pqty.
    wa_tabfin-sep_grosspts = wa_tabtot-sep_grosspts.
    wa_tabfin-sep_pgrosspts = wa_tabtot-sep_pgrosspts.
    wa_tabfin-sep_qty = wa_tabtot-sep_qty.
    wa_tabfin-sep_pqty = wa_tabtot-sep_pqty.
    wa_tabfin-oct_grosspts = wa_tabtot-oct_grosspts.
    wa_tabfin-oct_pgrosspts = wa_tabtot-oct_pgrosspts.
    wa_tabfin-oct_qty = wa_tabtot-oct_qty.
    wa_tabfin-oct_pqty = wa_tabtot-oct_pqty.
    wa_tabfin-nov_grosspts = wa_tabtot-nov_grosspts.
    wa_tabfin-nov_pgrosspts = wa_tabtot-nov_pgrosspts.
    wa_tabfin-nov_qty = wa_tabtot-nov_qty.
    wa_tabfin-nov_pqty = wa_tabtot-nov_pqty.
    wa_tabfin-dec_grosspts = wa_tabtot-dec_grosspts.
    wa_tabfin-dec_pgrosspts = wa_tabtot-dec_pgrosspts.
    wa_tabfin-dec_qty = wa_tabtot-dec_qty.
    wa_tabfin-dec_pqty = wa_tabtot-dec_pqty.
    wa_tabfin-jan_grosspts = wa_tabtot-jan_grosspts.
    wa_tabfin-jan_pgrosspts = wa_tabtot-jan_pgrosspts.
    wa_tabfin-jan_qty = wa_tabtot-jan_qty.
    wa_tabfin-jan_pqty = wa_tabtot-jan_pqty.
    wa_tabfin-feb_grosspts = wa_tabtot-feb_grosspts.
    wa_tabfin-feb_pgrosspts = wa_tabtot-feb_pgrosspts.
    wa_tabfin-feb_qty = wa_tabtot-feb_qty.
    wa_tabfin-feb_pqty = wa_tabtot-feb_pqty.
    wa_tabfin-mar_grosspts = wa_tabtot-mar_grosspts.
    wa_tabfin-mar_pgrosspts = wa_tabtot-mar_pgrosspts.
    wa_tabfin-mar_qty = wa_tabtot-mar_qty.
    wa_tabfin-mar_pqty = wa_tabtot-mar_pqty.
    wa_tabfin-curr_qty = wa_tabtot-apr_qty + wa_tabtot-may_qty + wa_tabtot-jun_qty +
                         wa_tabtot-jul_qty + wa_tabtot-aug_qty + wa_tabtot-sep_qty +
                         wa_tabtot-oct_qty + wa_tabtot-nov_qty + wa_tabtot-dec_qty +
                         wa_tabtot-jan_qty + wa_tabtot-feb_qty + wa_tabtot-mar_qty .
    wa_tabfin-prev_qty = wa_tabtot-apr_pqty + wa_tabtot-may_pqty + wa_tabtot-jun_pqty +
                         wa_tabtot-jul_pqty + wa_tabtot-aug_pqty + wa_tabtot-sep_pqty +
                         wa_tabtot-oct_pqty + wa_tabtot-nov_pqty + wa_tabtot-dec_pqty +
                         wa_tabtot-jan_pqty + wa_tabtot-feb_pqty + wa_tabtot-mar_pqty .
    wa_tabfin-curr_grosspts = wa_tabtot-apr_grosspts + wa_tabtot-may_grosspts + wa_tabtot-jun_grosspts +
                         wa_tabtot-jul_grosspts + wa_tabtot-aug_grosspts + wa_tabtot-sep_grosspts +
                         wa_tabtot-oct_grosspts + wa_tabtot-nov_grosspts + wa_tabtot-dec_grosspts +
                         wa_tabtot-jan_grosspts + wa_tabtot-feb_grosspts + wa_tabtot-mar_grosspts .
    wa_tabfin-prev_grosspts = wa_tabtot-apr_pgrosspts + wa_tabtot-may_pgrosspts + wa_tabtot-jun_pgrosspts +
                         wa_tabtot-jul_pgrosspts + wa_tabtot-aug_pgrosspts + wa_tabtot-sep_pgrosspts +
                         wa_tabtot-oct_pgrosspts + wa_tabtot-nov_pgrosspts + wa_tabtot-dec_pgrosspts +
                         wa_tabtot-jan_pgrosspts + wa_tabtot-feb_pgrosspts + wa_tabtot-mar_pgrosspts .
    collect wa_tabfin into it_tabfin.
    clear wa_tabfin.
  endloop.
  if it_tabfin[] is not initial.
    sort it_tabfin[] by prev_grosspts curr_grosspts.
    delete it_tabfin[] where prev_grosspts is initial and curr_grosspts is initial.
  endif.
  sort it_tabfin by bzirk prn_seq ascending.
  loop at it_tabfin into wa_tabfin.
*      IF wa_tabFIN-GRP_CODE = 10.
*      WRITE : /1 WA_TABFIN-APR_GROSSPTS.
*      ENDIF.
    mcurramt = wa_tabfin-apr_grosspts.
    mprevamt = wa_tabfin-apr_pgrosspts.
    mcurrqty = mcurrqty + wa_tabfin-apr_qty.
    mprevqty = mprevqty + wa_tabfin-apr_pqty.
    asofamt = wa_tabfin-apr_pgrosspts.
    asofqty = asofqty + wa_tabfin-apr_pqty.
    if mcurramt > 0  and mcurrqty > 0 and mprevqty > 0 and mprevamt > 0.
      wa_tabfin-apr_grth = ( ( mcurramt / mprevamt ) * 100 ) - 100 .
      wa_tabfin-apr_qgrth = ( ( mcurrqty / mprevqty ) * 100 ) - 100 .
    elseif mcurramt > 0  and mcurrqty > 0 and mprevqty = 0 and mprevamt = 0.  "BCDK935816 / 24.09.2024 added to correct tge growth calc.
      wa_tabfin-apr_grth =  100 .
      wa_tabfin-apr_qgrth =  100 .
    elseif mcurramt = 0  and mcurrqty = 0 and mprevqty > 0 and mprevamt > 0.  "BCDK935816 / 24.09.2024 added to correct tge growth calc.
      wa_tabfin-apr_grth = -100 .
      wa_tabfin-apr_qgrth = -100 .
    endif.
    c_date = pdate.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.

    mprevamt = mprevamt + wa_tabfin-may_pgrosspts.
    mprevqty = mprevqty + wa_tabfin-may_pqty.
    mcurramt = mcurramt + wa_tabfin-may_grosspts.
    mcurrqty = mcurrqty + wa_tabfin-may_qty.
    if c_date <= date1.
      asofamt = asofamt + wa_tabfin-may_pgrosspts.
      asofqty = asofqty + wa_tabfin-may_pqty.
      if mcurramt > 0  and mcurrqty > 0 and mprevqty > 0 and mprevamt > 0.
        wa_tabfin-may_grth = ( ( mcurramt / mprevamt ) * 100 ) - 100 .
        wa_tabfin-may_qgrth = ( ( mcurrqty / mprevqty ) * 100 ) - 100 .
      elseif mcurramt > 0  and mcurrqty > 0 and mprevqty = 0 and mprevamt = 0.  "BCDK935816 / 24.09.2024 added to correct tge growth calc.
        wa_tabfin-may_grth =  100 .
        wa_tabfin-may_qgrth =  100 .
      elseif mcurramt = 0  and mcurrqty = 0 and mprevqty > 0 and mprevamt > 0.  "BCDK935816 / 24.09.2024 added to correct tge growth calc.
        wa_tabfin-may_grth = -100 .
        wa_tabfin-may_qgrth = -100 .
      endif.
    endif.

    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.

    mcurramt = mcurramt + wa_tabfin-jun_grosspts.
    mprevamt = mprevamt + wa_tabfin-jun_pgrosspts.
    mcurrqty = mcurrqty + wa_tabfin-jun_qty.
    mprevqty = mprevqty + wa_tabfin-jun_pqty.
    if c_date <= date1.
      asofamt = asofamt + wa_tabfin-jun_pgrosspts.
      asofqty = asofqty + wa_tabfin-jun_pqty.
      if mcurramt > 0  and mcurrqty > 0 and mprevqty > 0 and mprevamt > 0.
        wa_tabfin-jun_grth = ( ( mcurramt / mprevamt ) * 100 ) - 100 .
        wa_tabfin-jun_qgrth = ( ( mcurrqty / mprevqty ) * 100 ) - 100 .
      elseif mcurramt > 0  and mcurrqty > 0 and mprevqty = 0 and mprevamt = 0.  "BCDK935816 / 24.09.2024 added to correct tge growth calc.
        wa_tabfin-jun_grth =  100 .
        wa_tabfin-jun_qgrth =  100 .
      elseif mcurramt = 0  and mcurrqty = 0 and mprevqty > 0 and mprevamt > 0.  "BCDK935816 / 24.09.2024 added to correct tge growth calc.
        wa_tabfin-jun_grth = -100 .
        wa_tabfin-jun_qgrth = -100 .
      endif.
    endif.

    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.

    mcurramt = mcurramt + wa_tabfin-jul_grosspts.
    mprevamt = mprevamt + wa_tabfin-jul_pgrosspts.
    mcurrqty = mcurrqty + wa_tabfin-jul_qty.
    mprevqty = mprevqty + wa_tabfin-jul_pqty.
    if c_date <= date1.
      asofamt = asofamt + wa_tabfin-jul_pgrosspts.
      asofqty = asofqty + wa_tabfin-jul_pqty.
      if mcurramt > 0  and mcurrqty > 0 and mprevqty > 0 and mprevamt > 0.
        wa_tabfin-jul_grth = ( ( mcurramt / mprevamt ) * 100 ) - 100 .
        wa_tabfin-jul_qgrth = ( ( mcurrqty / mprevqty ) * 100 ) - 100 .
      elseif mcurramt > 0  and mcurrqty > 0 and mprevqty = 0 and mprevamt = 0.  "BCDK935816 / 24.09.2024 added to correct tge growth calc.
        wa_tabfin-jul_grth =  100 .
        wa_tabfin-jul_qgrth =  100 .
      elseif mcurramt = 0  and mcurrqty = 0 and mprevqty > 0 and mprevamt > 0.  "BCDK935816 / 24.09.2024 added to correct tge growth calc.
        wa_tabfin-jul_grth = -100 .
        wa_tabfin-jul_qgrth = -100 .
      endif.
    endif.

    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.

    mcurramt = mcurramt + wa_tabfin-aug_grosspts.
    mprevamt = mprevamt + wa_tabfin-aug_pgrosspts.
    mcurrqty = mcurrqty + wa_tabfin-aug_qty.
    mprevqty = mprevqty + wa_tabfin-aug_pqty.
    if c_date <= date1.
      asofamt = asofamt + wa_tabfin-aug_pgrosspts.
      asofqty = asofqty + wa_tabfin-aug_pqty.
      if mcurramt > 0  and mcurrqty > 0 and mprevqty > 0 and mprevamt > 0.
        wa_tabfin-aug_grth = ( ( mcurramt / mprevamt ) * 100 ) - 100 .
        wa_tabfin-aug_qgrth = ( ( mcurrqty / mprevqty ) * 100 ) - 100 .
      elseif mcurramt > 0  and mcurrqty > 0 and mprevqty = 0 and mprevamt = 0.  "BCDK935816 / 24.09.2024 added to correct tge growth calc.
        wa_tabfin-aug_grth =  100 .
        wa_tabfin-aug_qgrth =  100 .
      elseif mcurramt = 0  and mcurrqty = 0 and mprevqty > 0 and mprevamt > 0.  "BCDK935816 / 24.09.2024 added to correct tge growth calc.
        wa_tabfin-aug_grth = -100 .
        wa_tabfin-aug_qgrth = -100 .
      endif.
    endif.

    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.

    mcurramt = mcurramt + wa_tabfin-sep_grosspts.
    mprevamt = mprevamt + wa_tabfin-sep_pgrosspts.
    mcurrqty = mcurrqty + wa_tabfin-sep_qty.
    mprevqty = mprevqty + wa_tabfin-sep_pqty.
    if c_date <= date1.
      asofamt = asofamt + wa_tabfin-sep_pgrosspts.
      asofqty = asofqty + wa_tabfin-sep_pqty.
      if mcurramt > 0  and mcurrqty > 0 and mprevqty > 0 and mprevamt > 0.
        wa_tabfin-sep_grth = ( ( mcurramt / mprevamt ) * 100 ) - 100 .
        wa_tabfin-sep_qgrth = ( ( mcurrqty / mprevqty ) * 100 ) - 100 .
      elseif mcurramt > 0  and mcurrqty > 0 and mprevqty = 0 and mprevamt = 0.  "BCDK935816 / 24.09.2024 added to correct tge growth calc.
        wa_tabfin-sep_grth =  100 .
        wa_tabfin-sep_qgrth =  100 .
      elseif mcurramt = 0  and mcurrqty = 0 and mprevqty > 0 and mprevamt > 0.  "BCDK935816 / 24.09.2024 added to correct tge growth calc.
        wa_tabfin-sep_grth = -100 .
        wa_tabfin-sep_qgrth = -100 .
      endif.
    endif.

    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.

    mcurramt = mcurramt + wa_tabfin-oct_grosspts.
    mprevamt = mprevamt + wa_tabfin-oct_pgrosspts.
    mcurrqty = mcurrqty + wa_tabfin-oct_qty.
    mprevqty = mprevqty + wa_tabfin-oct_pqty.
    if c_date <= date1.
      asofamt = asofamt + wa_tabfin-oct_pgrosspts.
      asofqty = asofqty + wa_tabfin-oct_pqty.
      if mcurramt > 0  and mcurrqty > 0 and mprevqty > 0 and mprevamt > 0.
        wa_tabfin-oct_grth = ( ( mcurramt / mprevamt ) * 100 ) - 100 .
        wa_tabfin-oct_qgrth = ( ( mcurrqty / mprevqty ) * 100 ) - 100 .
      elseif mcurramt > 0  and mcurrqty > 0 and mprevqty = 0 and mprevamt = 0.  "BCDK935816 / 24.09.2024 added to correct tge growth calc.
        wa_tabfin-oct_grth =  100 .
        wa_tabfin-oct_qgrth =  100 .
      elseif mcurramt = 0  and mcurrqty = 0 and mprevqty > 0 and mprevamt > 0.  "BCDK935816 / 24.09.2024 added to correct tge growth calc.
        wa_tabfin-oct_grth = -100 .
        wa_tabfin-oct_qgrth = -100 .
      endif.
    endif.

    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.

    mcurramt = mcurramt + wa_tabfin-nov_grosspts.
    mprevamt = mprevamt + wa_tabfin-nov_pgrosspts.
    mcurrqty = mcurrqty + wa_tabfin-nov_qty.
    mprevqty = mprevqty + wa_tabfin-nov_pqty.
    if c_date <= date1.
      asofamt = asofamt + wa_tabfin-nov_pgrosspts.
      asofqty = asofqty + wa_tabfin-nov_pqty.
      if mcurramt > 0  and mcurrqty > 0 and mprevqty > 0 and mprevamt > 0.
        wa_tabfin-nov_grth = ( ( mcurramt / mprevamt ) * 100 ) - 100 .
        wa_tabfin-nov_qgrth = ( ( mcurrqty / mprevqty ) * 100 ) - 100 .
      elseif mcurramt > 0  and mcurrqty > 0 and mprevqty = 0 and mprevamt = 0.  "BCDK935816 / 24.09.2024 added to correct tge growth calc.
        wa_tabfin-nov_grth =  100 .
        wa_tabfin-nov_qgrth =  100 .
      elseif mcurramt = 0  and mcurrqty = 0 and mprevqty > 0 and mprevamt > 0.  "BCDK935816 / 24.09.2024 added to correct tge growth calc.
        wa_tabfin-nov_grth = -100 .
        wa_tabfin-nov_qgrth = -100 .
      endif.
    endif.

    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.

    mcurramt = mcurramt + wa_tabfin-dec_grosspts.
    mprevamt = mprevamt + wa_tabfin-dec_pgrosspts.
    mcurrqty = mcurrqty + wa_tabfin-dec_qty.
    mprevqty = mprevqty + wa_tabfin-dec_pqty.
    if c_date <= date1.
      asofamt = asofamt + wa_tabfin-dec_pgrosspts.
      asofqty = asofqty + wa_tabfin-dec_pqty.
      if mcurramt > 0  and mcurrqty > 0 and mprevqty > 0 and mprevamt > 0.
        wa_tabfin-dec_grth = ( ( mcurramt / mprevamt ) * 100 ) - 100 .
        wa_tabfin-dec_qgrth = ( ( mcurrqty / mprevqty ) * 100 ) - 100 .
      elseif mcurramt > 0  and mcurrqty > 0 and mprevqty = 0 and mprevamt = 0.  "BCDK935816 / 24.09.2024 added to correct tge growth calc.
        wa_tabfin-dec_grth =  100 .
        wa_tabfin-dec_qgrth =  100 .
      elseif mcurramt = 0  and mcurrqty = 0 and mprevqty > 0 and mprevamt > 0.  "BCDK935816 / 24.09.2024 added to correct tge growth calc.
        wa_tabfin-dec_grth = -100 .
        wa_tabfin-dec_qgrth = -100 .
      endif.
    endif.

    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.

    mcurramt = mcurramt + wa_tabfin-jan_grosspts.
    mprevamt = mprevamt + wa_tabfin-jan_pgrosspts.
    mcurrqty = mcurrqty + wa_tabfin-jan_qty.
    mprevqty = mprevqty + wa_tabfin-jan_pqty.
    if c_date <= date1.
      asofamt = asofamt + wa_tabfin-jan_pgrosspts.
      asofqty = asofqty + wa_tabfin-jan_pqty.
      if mcurramt > 0  and mcurrqty > 0 and mprevqty > 0 and mprevamt > 0.
        wa_tabfin-jan_grth = ( ( mcurramt / mprevamt ) * 100 ) - 100 .
        wa_tabfin-jan_qgrth = ( ( mcurrqty / mprevqty ) * 100 ) - 100 .
      elseif mcurramt > 0  and mcurrqty > 0 and mprevqty = 0 and mprevamt = 0.  "BCDK935816 / 24.09.2024 added to correct tge growth calc.
        wa_tabfin-jan_grth =  100 .
        wa_tabfin-jan_qgrth =  100 .
      elseif mcurramt = 0  and mcurrqty = 0 and mprevqty > 0 and mprevamt > 0.  "BCDK935816 / 24.09.2024 added to correct tge growth calc.
        wa_tabfin-jan_grth = -100 .
        wa_tabfin-jan_qgrth = -100 .
      endif.
    endif.

    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.

    mcurramt = mcurramt + wa_tabfin-feb_grosspts.
    mprevamt = mprevamt + wa_tabfin-feb_pgrosspts.
    mcurrqty = mcurrqty + wa_tabfin-feb_qty.
    mprevqty = mprevqty + wa_tabfin-feb_pqty.
    if c_date <= date1.
      asofamt = asofamt + wa_tabfin-feb_pgrosspts.
      asofqty = asofqty + wa_tabfin-feb_pqty.
      if mcurramt > 0  and mcurrqty > 0 and mprevqty > 0 and mprevamt > 0.
        wa_tabfin-feb_grth = ( ( mcurramt / mprevamt ) * 100 ) - 100 .
        wa_tabfin-feb_qgrth = ( ( mcurrqty / mprevqty ) * 100 ) - 100 .
      elseif mcurramt > 0  and mcurrqty > 0 and mprevqty = 0 and mprevamt = 0.  "BCDK935816 / 24.09.2024 added to correct tge growth calc.
        wa_tabfin-feb_grth =  100 .
        wa_tabfin-feb_qgrth =  100 .
      elseif mcurramt = 0  and mcurrqty = 0 and mprevqty > 0 and mprevamt > 0.  "BCDK935816 / 24.09.2024 added to correct tge growth calc.
        wa_tabfin-feb_grth = -100 .
        wa_tabfin-feb_qgrth = -100 .
      endif.
    endif.

    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.

    mcurramt = mcurramt + wa_tabfin-mar_grosspts.
    mprevamt = mprevamt + wa_tabfin-mar_pgrosspts.
    mcurrqty = mcurrqty + wa_tabfin-mar_qty.
    mprevqty = mprevqty + wa_tabfin-mar_pqty.
    if c_date <= date1.
      asofamt = asofamt + wa_tabfin-mar_pgrosspts.
      asofqty = asofqty + wa_tabfin-mar_pqty.
      if mcurramt > 0  and mcurrqty > 0 and mprevqty > 0 and mprevamt > 0.
        wa_tabfin-mar_grth = ( ( mcurramt / mprevamt ) * 100 ) - 100 .
        wa_tabfin-mar_qgrth = ( ( mcurrqty / mprevqty ) * 100 ) - 100 .
      elseif mcurramt > 0  and mcurrqty > 0 and mprevqty = 0 and mprevamt = 0.  "BCDK935816 / 24.09.2024 added to correct tge growth calc.
        wa_tabfin-mar_grth =  100 .
        wa_tabfin-mar_qgrth =  100 .
      elseif mcurramt = 0  and mcurrqty = 0 and mprevqty > 0 and mprevamt > 0.  "BCDK935816 / 24.09.2024 added to correct tge growth calc.
        wa_tabfin-mar_grth = -100 .
        wa_tabfin-mar_qgrth = -100 .
      endif.
    endif.
    wa_tabfin-asof_valtot = asofamt.
    wa_tabfin-asof_qtytot = asofqty.
    wa_tabfin-curr_qtytot = mcurrqty.
    wa_tabfin-curr_valtot = mcurramt.
    wa_tabfin-prev_grosspts = mprevamt.
    wa_tabfin-prev_qty = mprevqty.
    if mcurramt > 0   and asofamt > 0.
      wa_tabfin-grth = ( ( mcurramt / asofamt ) * 100 ) - 100 .
    elseif mcurramt > 0   and asofamt = 0.          "BCDK935816 / 24.09.2024 added to correct tge growth calc.
      wa_tabfin-grth = 100.
    elseif mcurramt = 0   and asofamt > 0.          "BCDK935816 / 24.09.2024 added to correct tge growth calc.
      wa_tabfin-grth = -100.
    endif.
    if  mcurrqty > 0 and asofqty > 0.
      wa_tabfin-qgrth = ( ( mcurrqty / asofqty ) * 100 ) - 100 .
    endif.
    modify it_tabfin from wa_tabfin.
    clear wa_tabfin.
*******  BCDK935816 / 24.09.2024 added to correct tge growth calc.
    clear: mcurrqty,
           mcurramt,
           mprevqty,
           mprevamt,
           asofamt,
           asofqty.
  endloop.

endform.                    " GRPDATA

*&---------------------------------------------------------------------*
*&      Form  VALUEDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form valuedata .
  data curyrmth(2) type  c.

  loop at it_tgt1 into wa_tgt1.
    read table it_tac3 into  wa_tac3 with key bzirk = wa_tgt1-bzirk.
    wa_sumfin-bzirk = wa_tac3-rm.
    select single * from yterrallc where bzirk eq wa_tgt1-bzirk and endda  < mdate and endda > cryrdt.
    if sy-subrc = 0.
      curyrmth = yterrallc-endda+4(2).
      write : /1 wa_tgt1-bzirk, yterrallc-endda, curyrmth.
    else .
      curyrmth = ' '.
    endif.

    wa_sumfin-apr_tgt = wa_tgt1-month01.
    wa_sumfin-may_tgt = wa_tgt1-month02.
    wa_sumfin-jun_tgt = wa_tgt1-month03.
    wa_sumfin-jul_tgt = wa_tgt1-month04.
    wa_sumfin-aug_tgt = wa_tgt1-month05.
    wa_sumfin-sep_tgt = wa_tgt1-month06.
    wa_sumfin-oct_tgt = wa_tgt1-month07.
    wa_sumfin-nov_tgt = wa_tgt1-month08.
    wa_sumfin-dec_tgt = wa_tgt1-month09.
    wa_sumfin-jan_tgt = wa_tgt1-month10.
    wa_sumfin-feb_tgt = wa_tgt1-month11.
    wa_sumfin-mar_tgt = wa_tgt1-month12.
    read table it_tgtp1 into  wa_tgtp1 with key bzirk = wa_tgt1-bzirk.
    if sy-subrc = 0.
      wa_sumfin-apr_ptgt = wa_tgtp1-month01.
      wa_sumfin-may_ptgt = wa_tgtp1-month02.
      wa_sumfin-jun_ptgt = wa_tgtp1-month03.
      wa_sumfin-jul_ptgt = wa_tgtp1-month04.
      wa_sumfin-aug_ptgt = wa_tgtp1-month05.
      wa_sumfin-sep_ptgt = wa_tgtp1-month06.
      wa_sumfin-oct_ptgt = wa_tgtp1-month07.
      wa_sumfin-nov_ptgt = wa_tgtp1-month08.
      wa_sumfin-dec_ptgt = wa_tgtp1-month09.
      wa_sumfin-jan_ptgt = wa_tgtp1-month10.
      wa_sumfin-feb_ptgt = wa_tgtp1-month11.
      wa_sumfin-mar_ptgt = wa_tgtp1-month12.
    endif.
    if curyrmth = 4 .
      wa_sumfin-may_tgt = 0.
      wa_sumfin-may_ptgt = 0.
      wa_sumfin-jun_tgt = 0.
      wa_sumfin-jun_ptgt = 0.
      wa_sumfin-jul_tgt = 0.
      wa_sumfin-jul_ptgt = 0.
      wa_sumfin-aug_tgt = 0.
      wa_sumfin-aug_ptgt = 0.
      wa_sumfin-sep_tgt = 0.
      wa_sumfin-sep_ptgt = 0.
      wa_sumfin-oct_tgt = 0.
      wa_sumfin-oct_ptgt = 0.
      wa_sumfin-nov_tgt = 0.
      wa_sumfin-nov_ptgt = 0.
      wa_sumfin-dec_tgt = 0.
      wa_sumfin-dec_ptgt = 0.
      wa_sumfin-jan_tgt = 0.
      wa_sumfin-jan_ptgt = 0.
      wa_sumfin-feb_tgt = 0.
      wa_sumfin-feb_ptgt = 0.
      wa_sumfin-mar_tgt = 0.
      wa_sumfin-mar_ptgt = 0.
    endif.
    if curyrmth = 5 .
      wa_sumfin-jun_tgt = 0.
      wa_sumfin-jun_ptgt = 0.
      wa_sumfin-jul_tgt = 0.
      wa_sumfin-jul_ptgt = 0.
      wa_sumfin-aug_tgt = 0.
      wa_sumfin-aug_ptgt = 0.
      wa_sumfin-sep_tgt = 0.
      wa_sumfin-sep_ptgt = 0.
      wa_sumfin-oct_tgt = 0.
      wa_sumfin-oct_ptgt = 0.
      wa_sumfin-nov_tgt = 0.
      wa_sumfin-nov_ptgt = 0.
      wa_sumfin-dec_tgt = 0.
      wa_sumfin-dec_ptgt = 0.
      wa_sumfin-jan_tgt = 0.
      wa_sumfin-jan_ptgt = 0.
      wa_sumfin-feb_tgt = 0.
      wa_sumfin-feb_ptgt = 0.
      wa_sumfin-mar_tgt = 0.
      wa_sumfin-mar_ptgt = 0.
    endif.
    if curyrmth = 6 .
      wa_sumfin-jul_tgt = 0.
      wa_sumfin-jul_ptgt = 0.
      wa_sumfin-aug_tgt = 0.
      wa_sumfin-aug_ptgt = 0.
      wa_sumfin-sep_tgt = 0.
      wa_sumfin-sep_ptgt = 0.
      wa_sumfin-oct_tgt = 0.
      wa_sumfin-oct_ptgt = 0.
      wa_sumfin-nov_tgt = 0.
      wa_sumfin-nov_ptgt = 0.
      wa_sumfin-dec_tgt = 0.
      wa_sumfin-dec_ptgt = 0.
      wa_sumfin-jan_tgt = 0.
      wa_sumfin-jan_ptgt = 0.
      wa_sumfin-feb_tgt = 0.
      wa_sumfin-feb_ptgt = 0.
      wa_sumfin-mar_tgt = 0.
      wa_sumfin-mar_ptgt = 0.
    endif.
    if curyrmth = 7 .
      wa_sumfin-aug_tgt = 0.
      wa_sumfin-aug_ptgt = 0.
      wa_sumfin-sep_tgt = 0.
      wa_sumfin-sep_ptgt = 0.
      wa_sumfin-oct_tgt = 0.
      wa_sumfin-oct_ptgt = 0.
      wa_sumfin-nov_tgt = 0.
      wa_sumfin-nov_ptgt = 0.
      wa_sumfin-dec_tgt = 0.
      wa_sumfin-dec_ptgt = 0.
      wa_sumfin-jan_tgt = 0.
      wa_sumfin-jan_ptgt = 0.
      wa_sumfin-feb_tgt = 0.
      wa_sumfin-feb_ptgt = 0.
      wa_sumfin-mar_tgt = 0.
      wa_sumfin-mar_ptgt = 0.
    endif.
    if curyrmth = 8 .
      wa_sumfin-sep_tgt = 0.
      wa_sumfin-sep_ptgt = 0.
      wa_sumfin-oct_tgt = 0.
      wa_sumfin-oct_ptgt = 0.
      wa_sumfin-nov_tgt = 0.
      wa_sumfin-nov_ptgt = 0.
      wa_sumfin-dec_tgt = 0.
      wa_sumfin-dec_ptgt = 0.
      wa_sumfin-jan_tgt = 0.
      wa_sumfin-jan_ptgt = 0.
      wa_sumfin-feb_tgt = 0.
      wa_sumfin-feb_ptgt = 0.
      wa_sumfin-mar_tgt = 0.
      wa_sumfin-mar_ptgt = 0.
    endif.
    if curyrmth = 9 .
      wa_sumfin-oct_tgt = 0.
      wa_sumfin-oct_ptgt = 0.
      wa_sumfin-nov_tgt = 0.
      wa_sumfin-nov_ptgt = 0.
      wa_sumfin-dec_tgt = 0.
      wa_sumfin-dec_ptgt = 0.
      wa_sumfin-jan_tgt = 0.
      wa_sumfin-jan_ptgt = 0.
      wa_sumfin-feb_tgt = 0.
      wa_sumfin-feb_ptgt = 0.
      wa_sumfin-mar_tgt = 0.
      wa_sumfin-mar_ptgt = 0.
    endif.
    if curyrmth = 10 .
      wa_sumfin-nov_tgt = 0.
      wa_sumfin-nov_ptgt = 0.
      wa_sumfin-dec_tgt = 0.
      wa_sumfin-dec_ptgt = 0.
      wa_sumfin-jan_tgt = 0.
      wa_sumfin-jan_ptgt = 0.
      wa_sumfin-feb_tgt = 0.
      wa_sumfin-feb_ptgt = 0.
      wa_sumfin-mar_tgt = 0.
      wa_sumfin-mar_ptgt = 0.
    endif.
    if curyrmth = 11 .
      wa_sumfin-dec_tgt = 0.
      wa_sumfin-dec_ptgt = 0.
      wa_sumfin-jan_tgt = 0.
      wa_sumfin-jan_ptgt = 0.
      wa_sumfin-feb_tgt = 0.
      wa_sumfin-feb_ptgt = 0.
      wa_sumfin-mar_tgt = 0.
      wa_sumfin-mar_ptgt = 0.
    endif.
    if curyrmth = 12 .
      wa_sumfin-jan_tgt = 0.
      wa_sumfin-jan_ptgt = 0.
      wa_sumfin-feb_tgt = 0.
      wa_sumfin-feb_ptgt = 0.
      wa_sumfin-mar_tgt = 0.
      wa_sumfin-mar_ptgt = 0.
    endif.
    if curyrmth = 1 .
      wa_sumfin-feb_tgt = 0.
      wa_sumfin-feb_ptgt = 0.
      wa_sumfin-mar_tgt = 0.
      wa_sumfin-mar_ptgt = 0.
    endif.
    if curyrmth = 2 .
      wa_sumfin-mar_tgt = 0.
      wa_sumfin-mar_ptgt = 0.
    endif.
    curryrst = cryrdt.

    read table it_netvalp1 into  wa_netvalp1 with key bzirk = wa_tgt1-bzirk.
    if sy-subrc = 0.
      select single * from yterrallc where bzirk eq wa_tgt1-bzirk and endda ge curryrst.
      if sy-subrc = 0.
        wa_sumfin-apr_pval = wa_netvalp1-netval.
      endif.
    endif.
    read table it_netval1 into  wa_netval1 with key bzirk = wa_tgt1-bzirk.
    if sy-subrc = 0.
      wa_sumfin-apr_val = wa_netval1-netval.
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = curryrst
      importing
        newdate = curryrst.

    read table it_netvalp2 into  wa_netvalp2 with key bzirk = wa_tgt1-bzirk.
    if sy-subrc = 0.
      select single * from yterrallc where bzirk eq wa_tgt1-bzirk and endda ge curryrst.
      if sy-subrc = 0.
        wa_sumfin-may_pval = wa_netvalp2-netval.
      endif.
    endif.
    read table it_netval2 into  wa_netval2 with key bzirk = wa_tgt1-bzirk.
    if sy-subrc = 0.
      wa_sumfin-may_val = wa_netval2-netval.
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = curryrst
      importing
        newdate = curryrst.

    read table it_netvalp3 into  wa_netvalp3 with key bzirk = wa_tgt1-bzirk.
    if sy-subrc = 0.
      select single * from yterrallc where bzirk eq wa_tgt1-bzirk and endda ge curryrst.
      if sy-subrc = 0.
        wa_sumfin-jun_pval = wa_netvalp3-netval.
      endif.
    endif.
    read table it_netval3 into  wa_netval3 with key bzirk = wa_tgt1-bzirk.
    if sy-subrc = 0.
      wa_sumfin-jun_val = wa_netval3-netval.
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = curryrst
      importing
        newdate = curryrst.

    read table it_netvalp4 into  wa_netvalp4 with key bzirk = wa_tgt1-bzirk.
    if sy-subrc = 0.
      select single * from yterrallc where bzirk eq wa_tgt1-bzirk and endda ge curryrst.
      if sy-subrc = 0.
        wa_sumfin-jul_pval = wa_netvalp4-netval.
      endif.
    endif.
    read table it_netval4 into  wa_netval4 with key bzirk = wa_tgt1-bzirk.
    if sy-subrc = 0.
      wa_sumfin-jul_val = wa_netval4-netval.
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = curryrst
      importing
        newdate = curryrst.

    read table it_netvalp5 into  wa_netvalp5 with key bzirk = wa_tgt1-bzirk.
    if sy-subrc = 0.
      select single * from yterrallc where bzirk eq wa_tgt1-bzirk and endda ge curryrst.
      if sy-subrc = 0.
        wa_sumfin-aug_pval = wa_netvalp5-netval.
      endif.
    endif.
    read table it_netval5 into  wa_netval5 with key bzirk = wa_tgt1-bzirk.
    if sy-subrc = 0.
      wa_sumfin-aug_val = wa_netval5-netval.
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = curryrst
      importing
        newdate = curryrst.

    read table it_netvalp6 into  wa_netvalp6 with key bzirk = wa_tgt1-bzirk.
    if sy-subrc = 0.
      select single * from yterrallc where bzirk eq wa_tgt1-bzirk and endda ge curryrst.
      if sy-subrc = 0.
        wa_sumfin-sep_pval = wa_netvalp6-netval.
      endif.
    endif.
    read table it_netval6 into  wa_netval6 with key bzirk = wa_tgt1-bzirk.
    if sy-subrc = 0.
      wa_sumfin-sep_val = wa_netval6-netval.
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = curryrst
      importing
        newdate = curryrst.

    read table it_netvalp7 into  wa_netvalp7 with key bzirk = wa_tgt1-bzirk.
    if sy-subrc = 0.
      select single * from yterrallc where bzirk eq wa_tgt1-bzirk and endda ge curryrst.
      if sy-subrc = 0.
        wa_sumfin-oct_pval = wa_netvalp7-netval.
      endif.
    endif.
    read table it_netval7 into  wa_netval7 with key bzirk = wa_tgt1-bzirk.
    if sy-subrc = 0.
      wa_sumfin-oct_val = wa_netval7-netval.
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = curryrst
      importing
        newdate = curryrst.

    read table it_netvalp8 into  wa_netvalp8 with key bzirk = wa_tgt1-bzirk.
    if sy-subrc = 0.
      select single * from yterrallc where bzirk eq wa_tgt1-bzirk and endda ge curryrst.
      if sy-subrc = 0.
        wa_sumfin-nov_pval = wa_netvalp8-netval.
      endif.
    endif.
    read table it_netval8 into  wa_netval8 with key bzirk = wa_tgt1-bzirk.
    if sy-subrc = 0.
      wa_sumfin-nov_val = wa_netval8-netval.
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = curryrst
      importing
        newdate = curryrst.

    read table it_netvalp9 into  wa_netvalp9 with key bzirk = wa_tgt1-bzirk.
    if sy-subrc = 0.
      select single * from yterrallc where bzirk eq wa_tgt1-bzirk and endda ge curryrst.
      if sy-subrc = 0.
        wa_sumfin-dec_pval = wa_netvalp9-netval.
      endif.
    endif.
    read table it_netval9 into  wa_netval9 with key bzirk = wa_tgt1-bzirk.
    if sy-subrc = 0.
      wa_sumfin-dec_val = wa_netval9-netval.
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = curryrst
      importing
        newdate = curryrst.

    read table it_netvalp10 into  wa_netvalp10 with key bzirk = wa_tgt1-bzirk.
    if sy-subrc = 0.
      select single * from yterrallc where bzirk eq wa_tgt1-bzirk and endda ge curryrst.
      if sy-subrc = 0.
        wa_sumfin-jan_pval = wa_netvalp10-netval.
      endif.
    endif.
    read table it_netval10 into  wa_netval10 with key bzirk = wa_tgt1-bzirk.
    if sy-subrc = 0.
      wa_sumfin-jan_val = wa_netval10-netval.
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = curryrst
      importing
        newdate = curryrst.

    read table it_netvalp11 into  wa_netvalp11 with key bzirk = wa_tgt1-bzirk.
    if sy-subrc = 0.
      select single * from yterrallc where bzirk eq wa_tgt1-bzirk and endda ge curryrst.
      if sy-subrc = 0.
        wa_sumfin-feb_pval = wa_netvalp11-netval.
      endif.
    endif.
    read table it_netval11 into  wa_netval11 with key bzirk = wa_tgt1-bzirk.
    if sy-subrc = 0.
      wa_sumfin-feb_val = wa_netval11-netval.
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = curryrst
      importing
        newdate = curryrst.

    read table it_netvalp12 into  wa_netvalp12 with key bzirk = wa_tgt1-bzirk.
    if sy-subrc = 0.
      wa_sumfin-mar_pval = wa_netvalp12-netval.
    endif.
    read table it_netval12 into  wa_netval12 with key bzirk = wa_tgt1-bzirk.
    if sy-subrc = 0.
      wa_sumfin-mar_val = wa_netval12-netval.
    endif.

    collect wa_sumfin into it_tabsum.
    clear wa_sumfin.
  endloop.

endform.                    " VALUEDATA
*&---------------------------------------------------------------------*
*&      Form  DISPNETVALDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form dispnetvaldata .

  wa_fieldcat-fieldname = 'BZIRK'.
  wa_fieldcat-seltext_l = 'BZIRK'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'APR_PVAL'.
  wa_fieldcat-seltext_l = 'APR PREV YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'APR_VAL'.
  wa_fieldcat-seltext_l = 'APR CURR YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MAY_PVAL'.
  wa_fieldcat-seltext_l = 'MAY PREV YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MAY_VAL'.
  wa_fieldcat-seltext_l = 'MAY CURR YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'JUN_PVAL'.
  wa_fieldcat-seltext_l = 'JUN PREV YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'JUN_VAL'.
  wa_fieldcat-seltext_l = 'JUN CURR YEAR'.
  append wa_fieldcat to fieldcat.


  wa_fieldcat-fieldname = 'APR_PTGT'.
  wa_fieldcat-seltext_l = 'APR PREV TRGT'.
  append wa_fieldcat to fieldcat.
  wa_fieldcat-fieldname = 'APR_TGT'.
  wa_fieldcat-seltext_l = 'APR TRGT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MAY_PTGT'.
  wa_fieldcat-seltext_l = 'MAY PREV TRGT'.
  append wa_fieldcat to fieldcat.
  wa_fieldcat-fieldname = 'MAY_TGT'.
  wa_fieldcat-seltext_l = 'MAY TRGT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'JUN_PTGT'.
  wa_fieldcat-seltext_l = 'JUN PREV TRGT'.
  append wa_fieldcat to fieldcat.
  wa_fieldcat-fieldname = 'JUN_TGT'.
  wa_fieldcat-seltext_l = 'JUN TRGT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'JUL_PTGT'.
  wa_fieldcat-seltext_l = 'JUL PREV TRGT'.
  append wa_fieldcat to fieldcat.
  wa_fieldcat-fieldname = 'JUL_TGT'.
  wa_fieldcat-seltext_l = 'JUL TRGT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'AUG_PTGT'.
  wa_fieldcat-seltext_l = 'AUG PREV TRGT'.
  append wa_fieldcat to fieldcat.
  wa_fieldcat-fieldname = 'AUG_TGT'.
  wa_fieldcat-seltext_l = 'AUG TRGT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'SEP_PTGT'.
  wa_fieldcat-seltext_l = 'SEP PREV TRGT'.
  append wa_fieldcat to fieldcat.
  wa_fieldcat-fieldname = 'SEP_TGT'.
  wa_fieldcat-seltext_l = 'SEP TRGT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'OCT_PTGT'.
  wa_fieldcat-seltext_l = 'OCT PREV TRGT'.
  append wa_fieldcat to fieldcat.
  wa_fieldcat-fieldname = 'OCT_TGT'.
  wa_fieldcat-seltext_l = 'OCT TRGT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'NOV_PTGT'.
  wa_fieldcat-seltext_l = 'NOV PREV TRGT'.
  append wa_fieldcat to fieldcat.
  wa_fieldcat-fieldname = 'NOV_TGT'.
  wa_fieldcat-seltext_l = 'NOV TRGT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'DEC_PTGT'.
  wa_fieldcat-seltext_l = 'DEC PREV TRGT'.
  append wa_fieldcat to fieldcat.
  wa_fieldcat-fieldname = 'DEC_TGT'.
  wa_fieldcat-seltext_l = 'DEC TRGT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'JAN_PTGT'.
  wa_fieldcat-seltext_l = 'JAN PREV TRGT'.
  append wa_fieldcat to fieldcat.
  wa_fieldcat-fieldname = 'JAN_TGT'.
  wa_fieldcat-seltext_l = 'JAN TRGT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'FEB_PTGT'.
  wa_fieldcat-seltext_l = 'FEB PREV TRGT'.
  append wa_fieldcat to fieldcat.
  wa_fieldcat-fieldname = 'FEB_TGT'.
  wa_fieldcat-seltext_l = 'FEB TRGT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MAR_PTGT'.
  wa_fieldcat-seltext_l = 'MAR PREV TRGT'.
  append wa_fieldcat to fieldcat.
  wa_fieldcat-fieldname = 'MAR_TGT'.
  wa_fieldcat-seltext_l = 'MAR TRGT'.
  append wa_fieldcat to fieldcat.

  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'SR-13 : RM/MONTH WISE PRODUCT GROUPWISE REPORT'.

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
      t_outtab                = it_tabsum
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

endform.                    " DISPNETVALDATA
*&---------------------------------------------------------------------*
*&      Form  MTPTDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form mtptdata .
  data : cryrtotsale type p decimals 2.
  data : cryrtotpso(5) type c.

  cryrtotpso = 0.
  cryrtotsale = 0.

  mth = mdate+4(2).
  yr = mdate+0(4).
  if mth <= 3.
    tgtyr = yr - 1.
  else.
    tgtyr = yr.
  endif.
  pryr = tgtyr - 1.
  c_date = mdate.
  c_date+6(2) = '01'.
  c_date+4(2) = '04'.
  c_date+0(4) = tgtyr.
  clear wa_tabfin.
*   WRITE : /1 C_DATE, 'APR'.
  select *  from zmtpt_ach into table it_zmtpt_ach
      for all entries in it_tabfin
          where   bzirk = it_tabfin-bzirk and grp_code = it_tabfin-grp_code and begda >= c_date and begda <= mdate.

  select *  from ztotpso into table it_ztotpso
      for all entries in it_tabfin
          where   bzirk = it_tabfin-bzirk and begda >= c_date and begda <= mdate.

  loop at it_tabfin into wa_tabfin.
    cryrtotpso = 0.
    cryrtotsale = 0.

*    WRITE : /1 wa_TABFIN-bzirk , wa_TABFIN-GRP_CODE, C_DATE.
    c_date = mdate.
    c_date+6(2) = '01'.
    c_date+4(2) = '04'.
    c_date+0(4) = tgtyr.
    read table it_zmtpt_ach into wa_zmtpt_ach with key bzirk = wa_tabfin-bzirk  grp_code = wa_tabfin-grp_code  begda = c_date.
    if sy-subrc = 0.
      wa_tabfin-apr_totse_ach = wa_zmtpt_ach-totalse_ach.
      if wa_zmtpt_ach-target > 0 and wa_tabfin-apr_grosspts > 0.
        wa_tabfin-apr_mtpt_per = ( wa_tabfin-apr_grosspts / wa_zmtpt_ach-target ) * 100.
      endif.
    endif.

*    WRITE : /1 wa_TABFIN-bzirk , wa_TABFIN-GRP_CODE, WA_ZMTPT_ACH-TOTALSE_ACH, WA_ZMTPT_ACH-TARGET.
    read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_tabfin-bzirk  begda = c_date.
    if wa_tabfin-spart = '60'.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-xl - wa_ztotpso-hbe.
    elseif wa_tabfin-spart = '70'.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-ls - wa_ztotpso-hbe.
    else.
      mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc - wa_ztotpso-hbe.
    endif.
*    WRITE : /1 wa_TABFIN-bzirk , WA_ZTOTPSO-BCL , WA_ZTOTPSO-XL , WA_ZTOTPSO-BC.
    cryrtotpso = cryrtotpso + mtotpso.
    cryrtotsale = cryrtotsale + wa_tabfin-apr_grosspts.

    if wa_tabfin-apr_grosspts > 0 and mtotpso > 0.
      wa_tabfin-apr_ypm = wa_tabfin-apr_grosspts / mtotpso.
    endif.
    modify it_tabfin from wa_tabfin.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
*    WRITE : /1 C_DATE, 'MAY'.
    if c_date <= mdate.
      read table it_zmtpt_ach  into  wa_zmtpt_ach with key bzirk = wa_tabfin-bzirk grp_code = wa_tabfin-grp_code begda = c_date.
      if sy-subrc = 0.
        wa_tabfin-may_totse_ach = wa_zmtpt_ach-totalse_ach.
        if wa_zmtpt_ach-target > 0 and wa_tabfin-may_grosspts > 0.
          wa_tabfin-may_mtpt_per = ( wa_tabfin-may_grosspts / wa_zmtpt_ach-target ) * 100.
        endif.
      endif.

      read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_tabfin-bzirk  begda = c_date.
      if wa_tabfin-spart = '60'.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-xl - wa_ztotpso-hbe.
      elseif wa_tabfin-spart = '70'.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-ls - wa_ztotpso-hbe.
      else.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc - wa_ztotpso-hbe.
      endif.

      cryrtotpso = cryrtotpso + mtotpso.
      cryrtotsale = cryrtotsale + wa_tabfin-may_grosspts.
      if wa_tabfin-may_grosspts > 0 and mtotpso > 0.
        wa_tabfin-may_ypm =  wa_tabfin-may_grosspts / mtotpso .
      endif.
    endif.
    modify it_tabfin from wa_tabfin.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
*    WRITE : /1 C_DATE, 'JUN'.
    if c_date <= mdate.
      read table it_zmtpt_ach  into  wa_zmtpt_ach with key bzirk = wa_tabfin-bzirk grp_code = wa_tabfin-grp_code begda = c_date.
      if sy-subrc = 0.
        wa_tabfin-jun_totse_ach = wa_zmtpt_ach-totalse_ach.
        if wa_zmtpt_ach-target > 0 and wa_tabfin-jun_grosspts > 0.
          wa_tabfin-jun_mtpt_per =  ( wa_tabfin-jun_grosspts / wa_zmtpt_ach-target  ) * 100.
        endif.
      endif.
      read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_tabfin-bzirk  begda = c_date.
      if wa_tabfin-spart = '60'.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-xl - wa_ztotpso-hbe.
      elseif wa_tabfin-spart = '70'.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-ls - wa_ztotpso-hbe.
      else.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc - wa_ztotpso-hbe.
      endif.
      cryrtotpso = cryrtotpso + mtotpso.
      cryrtotsale = cryrtotsale + wa_tabfin-jun_grosspts.
      if wa_tabfin-jun_grosspts > 0 and mtotpso > 0.
        wa_tabfin-jun_ypm =  wa_tabfin-jun_grosspts / mtotpso.
      endif.
    endif.
    modify it_tabfin from wa_tabfin.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
*    WRITE : /1 C_DATE, 'JUL'.
    if c_date <= mdate.
      read table it_zmtpt_ach  into  wa_zmtpt_ach with key bzirk = wa_tabfin-bzirk grp_code = wa_tabfin-grp_code begda = c_date.
      if sy-subrc = 0.
        wa_tabfin-jul_totse_ach = wa_zmtpt_ach-totalse_ach.
        if wa_zmtpt_ach-target > 0 and wa_tabfin-jul_grosspts > 0.
          wa_tabfin-jul_mtpt_per = ( wa_tabfin-jul_grosspts / wa_zmtpt_ach-target  ) * 100.
        endif.
      endif.
      read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_tabfin-bzirk  begda = c_date.
      if wa_tabfin-spart = '60'.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-xl - wa_ztotpso-hbe.
      elseif wa_tabfin-spart = '70'.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-ls - wa_ztotpso-hbe.
      else.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc - wa_ztotpso-hbe.
      endif.
      cryrtotpso = cryrtotpso + mtotpso.
      cryrtotsale = cryrtotsale + wa_tabfin-jul_grosspts.
      if wa_tabfin-jul_grosspts > 0 and mtotpso > 0.
        wa_tabfin-jul_ypm =  wa_tabfin-jul_grosspts / mtotpso .
      endif.
    endif.
    modify it_tabfin from wa_tabfin.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
*    WRITE : /1 C_DATE, 'AUG' .
    if c_date <= mdate.
      read table it_zmtpt_ach  into  wa_zmtpt_ach with key bzirk = wa_tabfin-bzirk grp_code = wa_tabfin-grp_code begda = c_date.
      if sy-subrc = 0.
        wa_tabfin-aug_totse_ach = wa_zmtpt_ach-totalse_ach.
        if wa_zmtpt_ach-target > 0 and wa_tabfin-aug_grosspts > 0.
          wa_tabfin-aug_mtpt_per = ( wa_tabfin-aug_grosspts / wa_zmtpt_ach-target )  * 100.
        endif.
      endif.
      read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_tabfin-bzirk  begda = c_date.
      if wa_tabfin-spart = '60'.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-xl - wa_ztotpso-hbe.
      elseif wa_tabfin-spart = '70'.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-ls - wa_ztotpso-hbe.
      else.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc - wa_ztotpso-hbe.
      endif.
      cryrtotpso = cryrtotpso + mtotpso.
      cryrtotsale = cryrtotsale + wa_tabfin-aug_grosspts.
      if wa_tabfin-aug_grosspts > 0 and mtotpso > 0.
        wa_tabfin-aug_ypm = ( wa_tabfin-aug_grosspts / mtotpso ).
      endif.
    endif.
    modify it_tabfin from wa_tabfin.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
*    WRITE : /1 C_DATE, 'SEP'.
    if c_date <= mdate.
      read table it_zmtpt_ach  into  wa_zmtpt_ach with key bzirk = wa_tabfin-bzirk grp_code = wa_tabfin-grp_code begda = c_date.
      if sy-subrc = 0.
        wa_tabfin-sep_totse_ach = wa_zmtpt_ach-totalse_ach.
        if wa_zmtpt_ach-target > 0 and wa_tabfin-sep_grosspts > 0.
          wa_tabfin-sep_mtpt_per = ( wa_tabfin-sep_grosspts / wa_zmtpt_ach-target ) * 100.
        endif.
      endif.
      read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_tabfin-bzirk  begda = c_date.
      if wa_tabfin-spart = '60'.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-xl - wa_ztotpso-hbe.
      elseif wa_tabfin-spart = '70'.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-ls - wa_ztotpso-hbe.
      else.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc - wa_ztotpso-hbe.
      endif.
      cryrtotpso = cryrtotpso + mtotpso.
      cryrtotsale = cryrtotsale + wa_tabfin-sep_grosspts.
      if wa_tabfin-sep_grosspts > 0 and mtotpso > 0.
        wa_tabfin-sep_ypm = ( wa_tabfin-sep_grosspts / mtotpso ).
      endif.
    endif.
    modify it_tabfin from wa_tabfin.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
*    WRITE : /1 C_DATE, 'OCT'.
    if c_date <= mdate.
      read table it_zmtpt_ach  into  wa_zmtpt_ach with key bzirk = wa_tabfin-bzirk grp_code = wa_tabfin-grp_code begda = c_date.
      if sy-subrc = 0.
        wa_tabfin-oct_totse_ach = wa_zmtpt_ach-totalse_ach.
        if wa_zmtpt_ach-target > 0 and wa_tabfin-oct_grosspts > 0.
          wa_tabfin-oct_mtpt_per = ( wa_tabfin-oct_grosspts / wa_zmtpt_ach-target ) * 100.
        endif.
      endif.
      read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_tabfin-bzirk  begda = c_date.
      if wa_tabfin-spart = '60'.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-xl - wa_ztotpso-hbe.
      elseif wa_tabfin-spart = '70'.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-ls - wa_ztotpso-hbe.
      else.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc - wa_ztotpso-hbe.
      endif.
      cryrtotpso = cryrtotpso + mtotpso.
      cryrtotsale = cryrtotsale + wa_tabfin-oct_grosspts.
      if wa_tabfin-oct_grosspts > 0 and mtotpso > 0.
        wa_tabfin-oct_ypm = ( wa_tabfin-oct_grosspts / mtotpso ).
      endif.
    endif.
    modify it_tabfin from wa_tabfin.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
*    WRITE : /1 C_DATE, 'NOV'.
    if c_date <= mdate.
      read table it_zmtpt_ach  into  wa_zmtpt_ach with key bzirk = wa_tabfin-bzirk grp_code = wa_tabfin-grp_code begda = c_date.
      if sy-subrc = 0.
        wa_tabfin-nov_totse_ach = wa_zmtpt_ach-totalse_ach.
        if wa_zmtpt_ach-target > 0 and wa_tabfin-nov_grosspts > 0.
          wa_tabfin-nov_mtpt_per = ( wa_tabfin-nov_grosspts / wa_zmtpt_ach-target ) * 100.
        endif.
      endif.
      read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_tabfin-bzirk  begda = c_date.
      if wa_tabfin-spart = '60'.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-xl - wa_ztotpso-hbe.
      elseif wa_tabfin-spart = '70'.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-ls - wa_ztotpso-hbe.
      else.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc - wa_ztotpso-hbe.
      endif.
      cryrtotpso = cryrtotpso + mtotpso.
      cryrtotsale = cryrtotsale + wa_tabfin-nov_grosspts.
      if wa_tabfin-nov_grosspts > 0 and mtotpso > 0.
        wa_tabfin-nov_ypm = ( wa_tabfin-nov_grosspts / mtotpso ).
      endif.
    endif.
    modify it_tabfin from wa_tabfin.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
*    WRITE : /1 C_DATE, 'DEC'.
    if c_date <= mdate.
      read table it_zmtpt_ach  into  wa_zmtpt_ach with key bzirk = wa_tabfin-bzirk grp_code = wa_tabfin-grp_code begda = c_date.
      if sy-subrc = 0.
        wa_tabfin-dec_totse_ach = wa_zmtpt_ach-totalse_ach.
        if wa_zmtpt_ach-target > 0 and wa_tabfin-dec_grosspts > 0.
          wa_tabfin-dec_mtpt_per = ( wa_tabfin-dec_grosspts / wa_zmtpt_ach-target ) * 100.
        endif.
      endif.
      read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_tabfin-bzirk  begda = c_date.
      if wa_tabfin-spart = '60'.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-xl - wa_ztotpso-hbe.
      elseif wa_tabfin-spart = '70'.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-ls - wa_ztotpso-hbe.
      else.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc - wa_ztotpso-hbe.
      endif.
      cryrtotpso = cryrtotpso + mtotpso.
      cryrtotsale = cryrtotsale + wa_tabfin-dec_grosspts.
      if wa_tabfin-dec_grosspts > 0 and mtotpso > 0.
        wa_tabfin-dec_ypm = ( wa_tabfin-dec_grosspts / mtotpso ).
      endif.
    endif.
    modify it_tabfin from wa_tabfin.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
*    WRITE : /1 C_DATE, 'JAN'.
    if c_date <= mdate.
      read table it_zmtpt_ach  into  wa_zmtpt_ach with key bzirk = wa_tabfin-bzirk grp_code = wa_tabfin-grp_code begda = c_date.
      if sy-subrc = 0.
        wa_tabfin-jan_totse_ach = wa_zmtpt_ach-totalse_ach.
        if wa_zmtpt_ach-target > 0 and wa_tabfin-jan_grosspts > 0.
          wa_tabfin-jan_mtpt_per = ( wa_tabfin-jan_grosspts / wa_zmtpt_ach-target ) * 100.
        endif.
      endif.
      read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_tabfin-bzirk  begda = c_date.
      if wa_tabfin-spart = '60'.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-xl - wa_ztotpso-hbe.
      elseif wa_tabfin-spart = '70'.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-ls - wa_ztotpso-hbe.
      else.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc - wa_ztotpso-hbe.
      endif.
      cryrtotpso = cryrtotpso + mtotpso.
      cryrtotsale = cryrtotsale + wa_tabfin-jan_grosspts.
      if wa_tabfin-jan_grosspts > 0 and mtotpso > 0.
        wa_tabfin-jan_ypm = ( wa_tabfin-jan_grosspts / mtotpso ).
      endif.
    endif.
    modify it_tabfin from wa_tabfin.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
*    WRITE : /1 C_DATE, 'FEB'.
    if c_date <= mdate.
      read table it_zmtpt_ach  into  wa_zmtpt_ach with key bzirk = wa_tabfin-bzirk grp_code = wa_tabfin-grp_code begda = c_date.
      if sy-subrc = 0.
        wa_tabfin-feb_totse_ach = wa_zmtpt_ach-totalse_ach.
        if wa_zmtpt_ach-target > 0 and wa_tabfin-feb_grosspts > 0.
          wa_tabfin-feb_mtpt_per = ( wa_tabfin-feb_grosspts / wa_zmtpt_ach-target ) * 100.
        endif.
      endif.
      read table it_ztotpso  into  wa_ztotpso with key bzirk = wa_tabfin-bzirk  begda = c_date.
      if wa_tabfin-spart = '60'.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-xl - wa_ztotpso-hbe.
      elseif wa_tabfin-spart = '70'.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-ls - wa_ztotpso-hbe.
      else.
        mtotpso = wa_ztotpso-bcl + wa_ztotpso-bc - wa_ztotpso-hbe.
      endif.
      cryrtotpso = cryrtotpso + mtotpso.
      cryrtotsale = cryrtotsale + wa_tabfin-feb_grosspts.
      if wa_tabfin-feb_grosspts > 0 and mtotpso > 0.
        wa_tabfin-feb_ypm = ( wa_tabfin-feb_grosspts / mtotpso ).
      endif.
    endif.
    modify it_tabfin from wa_tabfin.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.
*    WRITE : /1 C_DATE, 'MAR'.
    mtotpso = 0.
    if c_date <= mdate.
      read table it_zmtpt_ach  into  wa_zmtpt_ach with key bzirk = wa_tabfin-bzirk grp_code = wa_tabfin-grp_code begda = c_date.
      if sy-subrc = 0.
        wa_tabfin-mar_totse_ach = wa_zmtpt_ach-totalse_ach.
        if wa_zmtpt_ach-target > 0 and wa_tabfin-mar_grosspts > 0.
          wa_tabfin-mar_mtpt_per = ( wa_tabfin-mar_grosspts / wa_zmtpt_ach-target ) * 100.
        endif.
      endif.
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
      cryrtotsale = cryrtotsale + wa_tabfin-mar_grosspts.
      if wa_tabfin-mar_grosspts > 0 and mtotpso > 0.
        wa_tabfin-mar_ypm = ( wa_tabfin-mar_grosspts / mtotpso ).
      endif.
    endif.
    if cryrtotpso > 0 and cryrtotsale > 0.
      wa_tabfin-avg_ypm = ( cryrtotsale / cryrtotpso ).
    endif.

    modify it_tabfin from wa_tabfin.
*    collect wa_tabFIN into it_tabFIN.
    clear wa_tabfin.
*  WRITE : /1 MDATE , C_DATE.
  endloop.
endform.                    " MTPTDATA

include zsr13nypm_openformf01.
*INCLUDE zsr13nypm_openformf01.
*INCLUDE ZSR13N_OPENFORMF01.
*INCLUDE ZSR13_OPEN_FORMF01.
*&---------------------------------------------------------------------*
*&      Form  WRTGRPDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form wrtgrpdata .
  loop at it_tabfin into wa_tabfin.
    write : /1 wa_tabfin-grp_code , wa_tabfin-apr_grosspts,  wa_tabfin-may_grosspts,  wa_tabfin-jun_grosspts.
  endloop.
endform.                    " WRTGRPDATA

include zsr13nypm_emailf01.
*INCLUDE zsr13nypm_emailf01.
*INCLUDE ZSR13N_EMAILF01.
*INCLUDE ZSR13_SR13EMAILF01.

include zsr13nypm_valuedata1f01.
*INCLUDE zsr13nypm_valuedata1f01.
*INCLUDE zsr13n_valuedata1f01.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA_SFORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form get_data_sform .
  data : mlen(2) type c.
  clear : gt_fdata[], gt_sr12_total[],gt_fdata_zm[].

  sort it_tabfin by bzirk  prn_seq .
  ctr = 0.
  loop at it_tabfin into wa_tabfin.
    mtitle = 'SR-13 : RM MONTH/PRODUCT GROUPWISE'.
    mtitle1 = ' SALES TREND (VALUE)'.
    mtitle2 = ' AS OF '.
    mm = mdate+4(2).
    call function 'MONTH_NAMES_GET'
      tables
        month_names = month_name.
    read table month_name index mm.

    mtitle2+7(3) = month_name-ktx.
    mtitle2+10(1) = '`' .
    mtitle2+11(2) = mdate+2(2).

    mlen = strlen( wa_tabfin-ename ).
    mtitle2+24(mlen) =  wa_tabfin-ename.
    mlen = mlen + 24 .
    mtitle2+mlen(3) =  ' - '.
    mlen = mlen + 3 .
    select single zz_hqdesc from  zthr_heq_des into zhqname  where zz_hqcode = wa_tabfin-hq.
    mtitle2+mlen(15) = zhqname.


    prdname = wa_tabfin-grp_name.
    gw_fdata-grp_name = prdname.
    at new bzirk.
*****      PERFORM SR13CLOSE.
*****      PERFORM START_FORM.
*****      PERFORM NEW_SR13FORM.
      ctr = 0.
      gw_fdata-bzirk = wa_tabfin-bzirk.
      gw_fdata-hq = zhqname.
      gw_fdata-pernr = wa_tabfin-pernr.
      gw_fdata-ename = wa_tabfin-ename.
      gw_fdata-spart = wa_tabfin-spart.
    endat.
    on  change  of wa_tabfin-spart.
      if ctr > 0.
*****        perform group-total.
        prdname = 'SUB TOTAL '.
        tag = 'PR.YR. '.
*****        elname = 'PDET_ST'.
        avgqty = pqtysum / 12.
*****        perform write_main_form.
        gw_fdata-bzirk = wa_tabfin-bzirk.
        gw_fdata-pernr = wa_tabfin-pernr.
        gw_fdata-ename = wa_tabfin-ename.
        gw_fdata-spart = wa_tabfin-spart.

        gw_fdata-grp_name = prdname.
        gw_fdata-hq = prdname.
        gw_fdata-tag = tag.
        gw_fdata-avg_val = avgqty.
        gw_fdata-apr_val = pqty1.
        gw_fdata-may_val = pqty2.
        gw_fdata-jun_val = pqty3.
        gw_fdata-jul_val = pqty4.
        gw_fdata-aug_val = pqty5.
        gw_fdata-sep_val = pqty6.
        gw_fdata-oct_val = pqty7.
        gw_fdata-nov_val = pqty8.
        gw_fdata-dec_val = pqty9.
        gw_fdata-jan_val = pqty10.
        gw_fdata-feb_val = pqty11.
        gw_fdata-mar_val = pqty12.
        gw_fdata-cum_tot_val = pqtyason.
        gw_fdata-yrly_tot_val = pqtysum.
        append gw_fdata to gt_fdata.
        clear gw_fdata.

        tag = 'CR.YR. '.
*****        elname = 'CDET_ST'.
        avgqty = dqtysum / mctr.
*****        perform write_main_form.
        gw_fdata-bzirk = wa_tabfin-bzirk.
        gw_fdata-pernr = wa_tabfin-pernr.
        gw_fdata-ename = wa_tabfin-ename.
        gw_fdata-spart = wa_tabfin-spart.
        gw_fdata-hq = prdname.
        gw_fdata-tag = tag.
        gw_fdata-avg_val = avgqty.
        gw_fdata-apr_val = dqty1.
        gw_fdata-may_val = dqty2.
        gw_fdata-jun_val = dqty3.
        gw_fdata-jul_val = dqty4.
        gw_fdata-aug_val = dqty5.
        gw_fdata-sep_val = dqty6.
        gw_fdata-oct_val = dqty7.
        gw_fdata-nov_val = dqty8.
        gw_fdata-dec_val = dqty9.
        gw_fdata-jan_val = dqty10.
        gw_fdata-feb_val = dqty11.
        gw_fdata-mar_val = dqty12.
        gw_fdata-yrly_tot_val = dqtysum.
        append gw_fdata to gt_fdata.
        clear gw_fdata.

        perform stcalcgrth.
        avgqty = ' '.
        tag = 'CU.GR.%'.
*****        elname = 'GRTHDET_T'.
*****        perform write_main_form.
*****        perform group-total.
        gw_fdata-bzirk = wa_tabfin-bzirk.
        gw_fdata-hq = zhqname.
        gw_fdata-pernr = wa_tabfin-pernr.
        gw_fdata-ename = wa_tabfin-ename.
        gw_fdata-spart = wa_tabfin-spart.
        gw_fdata-hq = prdname.
        gw_fdata-tag = tag.
        gw_fdata-avg_val = avgqty.
        gw_fdata-apr_val = qty1.
        gw_fdata-may_val = qty2.
        gw_fdata-jun_val = qty3.
        gw_fdata-jul_val = qty4.
        gw_fdata-aug_val = qty5.
        gw_fdata-sep_val = qty6.
        gw_fdata-oct_val = qty7.
        gw_fdata-nov_val = qty8.
        gw_fdata-dec_val = qty9.
        gw_fdata-jan_val = qty10.
        gw_fdata-feb_val = qty11.
        gw_fdata-mar_val = qty12.
        gw_fdata-yrly_tot_val = qtysum.
        append gw_fdata to gt_fdata.
        clear gw_fdata.
        ctr = ctr + 1.
        clear : pqty1 , pqty2, pqty3 , pqty4, pqty5 , pqty6, pqty7 , pqty8, pqty9 , pqty10,pqty11, pqty12, pqtyason, pqtysum.
        clear : dqty1 , dqty2, dqty3 , dqty4, dqty5 , dqty6, dqty7 , dqty8, dqty9 , dqty10,dqty11, dqty12, dqtysum.
      else.
        ctr = 1.
      endif.
    endon.

    gw_fdata-bzirk = wa_tabfin-bzirk.
    gw_fdata-hq = zhqname.
    gw_fdata-pernr = wa_tabfin-pernr.
    gw_fdata-ename = wa_tabfin-ename.
    gw_fdata-spart = wa_tabfin-spart.

    prdname = wa_tabfin-grp_name.
    gw_fdata-grp_name = prdname.
    tag = 'PR.YR. '.
*****    elname = 'PDET'.
    clear : qty1 , qty2, qty3 , qty4, qty5 , qty6, qty7 , pqty8, qty9 , qty10,qty11, qty12, asofqty, qtysum.
    avgqty = wa_tabfin-prev_grosspts / 12.
    qty1 = wa_tabfin-apr_pgrosspts.
    qty2 = wa_tabfin-may_pgrosspts.
    qty3 = wa_tabfin-jun_pgrosspts.
    qty4 = wa_tabfin-jul_pgrosspts.
    qty5 = wa_tabfin-aug_pgrosspts.
    qty6 = wa_tabfin-sep_pgrosspts.
    qty7 = wa_tabfin-oct_pgrosspts.
    qty8 = wa_tabfin-nov_pgrosspts.
    qty9 = wa_tabfin-dec_pgrosspts.
    qty10 = wa_tabfin-jan_pgrosspts.
    qty11 = wa_tabfin-feb_pgrosspts.
    qty12 = wa_tabfin-mar_pgrosspts.
    asofqty = wa_tabfin-asof_valtot.
    qtysum =  wa_tabfin-prev_grosspts.

    gw_fdata-tag = tag.
    gw_fdata-avg_val = avgqty.
    gw_fdata-apr_val = qty1.
    gw_fdata-may_val = qty2.
    gw_fdata-jun_val = qty3.
    gw_fdata-jul_val = qty4.
    gw_fdata-aug_val = qty5.
    gw_fdata-sep_val = qty6.
    gw_fdata-oct_val = qty7.
    gw_fdata-nov_val = qty8.
    gw_fdata-dec_val = qty9.
    gw_fdata-jan_val = qty10.
    gw_fdata-feb_val = qty11.
    gw_fdata-mar_val = qty12.
    gw_fdata-cum_tot_val = asofqty.
    gw_fdata-yrly_tot_val = qtysum.

    append gw_fdata to gt_fdata.
    clear gw_fdata.

    pqty1 = pqty1 + wa_tabfin-apr_pgrosspts.
    pqty2 = pqty2 + wa_tabfin-may_pgrosspts.
    pqty3 = pqty3 + wa_tabfin-jun_pgrosspts.
    pqty4 = pqty4 + wa_tabfin-jul_pgrosspts.
    pqty5 = pqty5 + wa_tabfin-aug_pgrosspts.
    pqty6 = pqty6 + wa_tabfin-sep_pgrosspts.
    pqty7 = pqty7 + wa_tabfin-oct_pgrosspts.
    pqty8 = pqty8 + wa_tabfin-nov_pgrosspts.
    pqty9 = pqty9 + wa_tabfin-dec_pgrosspts.
    pqty10 = pqty10 + wa_tabfin-jan_pgrosspts.
    pqty11 = pqty11 + wa_tabfin-feb_pgrosspts.
    pqty12 = pqty12 + wa_tabfin-mar_pgrosspts.
    pqtyason = pqtyason + wa_tabfin-asof_valtot.
    pqtysum = pqtysum + wa_tabfin-prev_grosspts.
    dqty1 = dqty1 + wa_tabfin-apr_grosspts.
    dqty2 = dqty2 + wa_tabfin-may_grosspts.
    dqty3 = dqty3 + wa_tabfin-jun_grosspts.
    dqty4 = dqty4 + wa_tabfin-jul_grosspts.
    dqty5 = dqty5 + wa_tabfin-aug_grosspts.
    dqty6 = dqty6 + wa_tabfin-sep_grosspts.
    dqty7 = dqty7 + wa_tabfin-oct_grosspts.
    dqty8 = dqty8 + wa_tabfin-nov_grosspts.
    dqty9 = dqty9 + wa_tabfin-dec_grosspts.
    dqty10 = dqty10 + wa_tabfin-jan_grosspts.
    dqty11 = dqty11 + wa_tabfin-feb_grosspts.
    dqty12 = dqty12 + wa_tabfin-mar_grosspts.
    dqtysum = dqtysum + wa_tabfin-curr_grosspts.
    fpqty1 = fpqty1 + wa_tabfin-apr_pgrosspts.
    fpqty2 = fpqty2 + wa_tabfin-may_pgrosspts.
    fpqty3 = fpqty3 + wa_tabfin-jun_pgrosspts.
    fpqty4 = fpqty4 + wa_tabfin-jul_pgrosspts.
    fpqty5 = fpqty5 + wa_tabfin-aug_pgrosspts.
    fpqty6 = fpqty6 + wa_tabfin-sep_pgrosspts.
    fpqty7 = fpqty7 + wa_tabfin-oct_pgrosspts.
    fpqty8 = fpqty8 + wa_tabfin-nov_pgrosspts.
    fpqty9 = fpqty9 + wa_tabfin-dec_pgrosspts.
    fpqty10 = fpqty10 + wa_tabfin-jan_pgrosspts.
    fpqty11 = fpqty11 + wa_tabfin-feb_pgrosspts.
    fpqty12 = fpqty12 + wa_tabfin-mar_pgrosspts.
    fpqtyason = fpqtyason + wa_tabfin-asof_valtot.
    fpqtysum = fpqtysum + wa_tabfin-prev_grosspts.
    fdqty1 = fdqty1 + wa_tabfin-apr_grosspts.
    fdqty2 = fdqty2 + wa_tabfin-may_grosspts.
    fdqty3 = fdqty3 + wa_tabfin-jun_grosspts.
    fdqty4 = fdqty4 + wa_tabfin-jul_grosspts.
    fdqty5 = fdqty5 + wa_tabfin-aug_grosspts.
    fdqty6 = fdqty6 + wa_tabfin-sep_grosspts.
    fdqty7 = fdqty7 + wa_tabfin-oct_grosspts.
    fdqty8 = fdqty8 + wa_tabfin-nov_grosspts.
    fdqty9 = fdqty9 + wa_tabfin-dec_grosspts.
    fdqty10 = fdqty10 + wa_tabfin-jan_grosspts.
    fdqty11 = fdqty11 + wa_tabfin-feb_grosspts.
    fdqty12 = fdqty12 + wa_tabfin-mar_grosspts.
    fdqtysum = fdqtysum + wa_tabfin-curr_grosspts.
*****    perform write_main_form.

    tag = 'CU.YR. '.
*****    elname = 'CDET'.
    clear : qty1 , qty2, qty3 , qty4, qty5 , qty6, qty7 , pqty8, qty9 , qty10,qty11, qty12, asofqty, qtysum.
*   MCTR = 1.

    qty1 = wa_tabfin-apr_grosspts.
    if cryrdt <= mdate.
      qty2 = wa_tabfin-may_grosspts.
*     MCTR = 2.
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.

    if cryrdt <= mdate.
      qty3 = wa_tabfin-jun_grosspts.
*     MCTR = 3.
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.

    if cryrdt <= mdate.
      qty4 = wa_tabfin-jul_grosspts.
*     MCTR = 4.
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.

    if cryrdt <= mdate.
      qty5 = wa_tabfin-aug_grosspts.
*     MCTR = 5.
    else.
      qty5 = ' '.
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.

    if cryrdt <= mdate.
      qty6 = wa_tabfin-sep_grosspts.
*     MCTR = 6.
    else.
      qty6 = ' '.
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.

    if cryrdt <= mdate.
      qty7 = wa_tabfin-oct_grosspts.
*     MCTR = 7.
    else.
      qty7 = ' '.
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.

    if cryrdt <= mdate.
      qty8 = wa_tabfin-nov_grosspts.
*     MCTR = 8.
    else.
      qty8 = ' '.
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.

    if cryrdt <= mdate.
      qty9 = wa_tabfin-dec_grosspts.
*     MCTR = 9.
    else.
      qty9 = ' '.
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.

    if cryrdt <= mdate.
      qty10 = wa_tabfin-jan_grosspts.
*     MCTR = 10.
    else.
      qty10 = ' '.
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.

    if cryrdt <= mdate.
      qty11 = wa_tabfin-feb_grosspts.
*     MCTR = 11.
    else.
      qty11 = ' '.
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.

    if cryrdt <= mdate.
      qty12 = wa_tabfin-mar_grosspts.
*     MCTR = 12.
    else.
      qty12 = ' '.
    endif.
    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = c_date
      importing
        newdate = c_date.

    qtysum =  wa_tabfin-curr_grosspts.
    avgqty = wa_tabfin-curr_grosspts / mctr.
*****    perform write_main_form.

    gw_fdata-bzirk = wa_tabfin-bzirk.
    gw_fdata-hq = zhqname.
    gw_fdata-pernr = wa_tabfin-pernr.
    gw_fdata-ename = wa_tabfin-ename.
    gw_fdata-spart = wa_tabfin-spart.


    gw_fdata-tag = tag.
    gw_fdata-avg_val = avgqty.
    gw_fdata-apr_val = qty1.
    gw_fdata-may_val = qty2.
    gw_fdata-jun_val = qty3.
    gw_fdata-jul_val = qty4.
    gw_fdata-aug_val = qty5.
    gw_fdata-sep_val = qty6.
    gw_fdata-oct_val = qty7.
    gw_fdata-nov_val = qty8.
    gw_fdata-dec_val = qty9.
    gw_fdata-jan_val = qty10.
    gw_fdata-feb_val = qty11.
    gw_fdata-mar_val = qty12.
    gw_fdata-cum_tot_val = asofqty.
    gw_fdata-yrly_tot_val = qtysum.

    append gw_fdata to gt_fdata.
    clear gw_fdata.

    tag = 'CU.GR.%'.
*****    elname = 'CDET'.          " GRTHDET
    avgqty = ' '.
    qty1 = wa_tabfin-apr_grth.
    qty2 = wa_tabfin-may_grth.
    qty3 = wa_tabfin-jun_grth.
    qty4 = wa_tabfin-jul_grth.
    qty5 = wa_tabfin-aug_grth.
    qty6 = wa_tabfin-sep_grth.
    qty7 = wa_tabfin-oct_grth.
    qty8 = wa_tabfin-nov_grth.
    qty9 = wa_tabfin-dec_grth.
    qty10 = wa_tabfin-jan_grth.
    qty11 = wa_tabfin-feb_grth.
    qty12 = wa_tabfin-mar_grth.
    qtysum =  wa_tabfin-grth.
*****    perform write_main_form.

    gw_fdata-bzirk = wa_tabfin-bzirk.
    gw_fdata-hq = zhqname.
    gw_fdata-pernr = wa_tabfin-pernr.
    gw_fdata-ename = wa_tabfin-ename.
    gw_fdata-spart = wa_tabfin-spart.

    gw_fdata-tag = tag.
    gw_fdata-avg_val = avgqty.
    gw_fdata-apr_val = qty1.
    gw_fdata-may_val = qty2.
    gw_fdata-jun_val = qty3.
    gw_fdata-jul_val = qty4.
    gw_fdata-aug_val = qty5.
    gw_fdata-sep_val = qty6.
    gw_fdata-oct_val = qty7.
    gw_fdata-nov_val = qty8.
    gw_fdata-dec_val = qty9.
    gw_fdata-jan_val = qty10.
    gw_fdata-feb_val = qty11.
    gw_fdata-mar_val = qty12.
    gw_fdata-cum_tot_val = asofqty.
    gw_fdata-yrly_tot_val = qtysum.

    append gw_fdata to gt_fdata.
    clear gw_fdata.

    clear : qty1, qty2, qty3,qty4, qty5, qty6, qty7, qty8, qty9, qty10, qty11, qty12, qtysum.
    tag = 'MON.GR%'.
*****    elname = 'CDET'.
    avgqty = ' '.
    if wa_tabfin-apr_grosspts > 0 and wa_tabfin-apr_pgrosspts > 0.
      qty1 = ( ( wa_tabfin-apr_grosspts / wa_tabfin-apr_pgrosspts ) * 100 ) - 100..
    elseif wa_tabfin-apr_grosspts > 0 and wa_tabfin-apr_pgrosspts <= 0.
      qty1 = '100'.
    elseif wa_tabfin-apr_grosspts <= 0 and wa_tabfin-apr_pgrosspts > 0.
      qty1 = '-100'.
    endif.
    if maydt <= mdate.
      if wa_tabfin-may_grosspts > 0 and wa_tabfin-may_pgrosspts > 0.
        qty2 = ( ( wa_tabfin-may_grosspts / wa_tabfin-may_pgrosspts ) * 100 ) - 100..
      elseif wa_tabfin-may_grosspts > 0 and wa_tabfin-may_pgrosspts <= 0.
        qty2 = '100'.
      elseif wa_tabfin-may_grosspts <= 0 and wa_tabfin-may_pgrosspts > 0.
        qty2 = '-100'.
      endif.
    endif.
    if jundt <= mdate.
      if wa_tabfin-jun_grosspts > 0 and wa_tabfin-jun_pgrosspts > 0.
        qty3 = ( ( wa_tabfin-jun_grosspts / wa_tabfin-jun_pgrosspts ) * 100 ) - 100..
      elseif wa_tabfin-jun_grosspts > 0 and wa_tabfin-jun_pgrosspts <= 0.
        qty3 = '100'.
      elseif wa_tabfin-jun_grosspts <= 0 and wa_tabfin-jun_pgrosspts > 0.
        qty3 = '-100'.
      endif.
    endif.
    if juldt <= mdate.
      if wa_tabfin-jul_grosspts > 0 and wa_tabfin-jul_pgrosspts > 0.
        qty4 = ( ( wa_tabfin-jul_grosspts / wa_tabfin-jul_pgrosspts ) * 100 ) - 100..
      elseif wa_tabfin-jul_grosspts > 0 and wa_tabfin-jul_pgrosspts <= 0.
        qty4 = '100'.
      elseif wa_tabfin-jul_grosspts <= 0 and wa_tabfin-jul_pgrosspts > 0.
        qty4 = '-100'.
      endif.
    endif.
    if augdt <= mdate.
      if wa_tabfin-aug_grosspts > 0 and wa_tabfin-aug_pgrosspts > 0.
        qty5 = ( ( wa_tabfin-aug_grosspts / wa_tabfin-aug_pgrosspts ) * 100 ) - 100..
      elseif wa_tabfin-aug_grosspts > 0 and wa_tabfin-aug_pgrosspts <= 0.
        qty5 = '100'.
      elseif wa_tabfin-aug_grosspts <= 0 and wa_tabfin-aug_pgrosspts > 0.
        qty5 = '-100'.
      endif.
    endif.
    if sepdt <= mdate.
      if wa_tabfin-sep_grosspts > 0 and wa_tabfin-sep_pgrosspts > 0.
        qty6 = ( ( wa_tabfin-sep_grosspts / wa_tabfin-sep_pgrosspts ) * 100 ) - 100..
      elseif wa_tabfin-sep_grosspts > 0 and wa_tabfin-sep_pgrosspts <= 0.
        qty6 = '100'.
      elseif wa_tabfin-sep_grosspts <= 0 and wa_tabfin-sep_pgrosspts > 0.
        qty6 = '-100'.
      endif.
    endif.
    if octdt <= mdate.
      if wa_tabfin-oct_grosspts > 0 and wa_tabfin-oct_pgrosspts > 0.
        qty7 = ( ( wa_tabfin-oct_grosspts / wa_tabfin-oct_pgrosspts ) * 100 ) - 100..
      elseif wa_tabfin-oct_grosspts > 0 and wa_tabfin-oct_pgrosspts <= 0.
        qty7 = '100'.
      elseif wa_tabfin-oct_grosspts <= 0 and wa_tabfin-oct_pgrosspts > 0.
        qty7 = '-100'.
      endif.
    endif.
    if novdt <= mdate.
      if wa_tabfin-nov_grosspts > 0 and wa_tabfin-nov_pgrosspts > 0.
        qty8 = ( ( wa_tabfin-nov_grosspts / wa_tabfin-nov_pgrosspts ) * 100 ) - 100..
      elseif wa_tabfin-nov_grosspts > 0 and wa_tabfin-nov_pgrosspts <= 0.
        qty8 = '100'.
      elseif wa_tabfin-nov_grosspts <= 0 and wa_tabfin-nov_pgrosspts > 0.
        qty8 = '-100'.
      endif.
    endif.
    if decdt <= mdate.
      if wa_tabfin-dec_grosspts > 0 and wa_tabfin-dec_pgrosspts > 0.
        qty9 = ( ( wa_tabfin-dec_grosspts / wa_tabfin-dec_pgrosspts ) * 100 ) - 100..
      elseif wa_tabfin-dec_grosspts > 0 and wa_tabfin-dec_pgrosspts <= 0.
        qty9 = '100'.
      elseif wa_tabfin-dec_grosspts <= 0 and wa_tabfin-dec_pgrosspts > 0.
        qty9 = '-100'.
      endif.
    endif.
    if jandt <= mdate.
      if wa_tabfin-jan_grosspts > 0 and wa_tabfin-jan_pgrosspts > 0.
        qty10 = ( ( wa_tabfin-jan_grosspts / wa_tabfin-jan_pgrosspts ) * 100 ) - 100..
      elseif wa_tabfin-jan_grosspts > 0 and wa_tabfin-jan_pgrosspts <= 0.
        qty10 = '100'.
      elseif wa_tabfin-jan_grosspts <= 0 and wa_tabfin-jan_pgrosspts > 0.
        qty10 = '-100'.
      endif.
    endif.
    if febdt <= mdate.
      if wa_tabfin-feb_grosspts > 0 and wa_tabfin-feb_pgrosspts > 0.
        qty11 = ( ( wa_tabfin-feb_grosspts / wa_tabfin-feb_pgrosspts ) * 100 ) - 100..
      elseif wa_tabfin-feb_grosspts > 0 and wa_tabfin-feb_pgrosspts <= 0.
        qty11 = '100'.
      elseif wa_tabfin-feb_grosspts <= 0 and wa_tabfin-feb_pgrosspts > 0.
        qty11 = '-100'.
      endif.
    endif.
    if mardt <= mdate.
      if wa_tabfin-mar_grosspts > 0 and wa_tabfin-mar_pgrosspts > 0.
        qty12 = ( ( wa_tabfin-mar_grosspts / wa_tabfin-mar_pgrosspts ) * 100 ) - 100..
      elseif wa_tabfin-mar_grosspts > 0 and wa_tabfin-mar_pgrosspts <= 0.
        qty12 = '100'.
      elseif wa_tabfin-mar_grosspts <= 0 and wa_tabfin-mar_pgrosspts > 0.
        qty12 = '-100'.
      endif.
    endif.

*****    perform write_main_form.

    gw_fdata-bzirk = wa_tabfin-bzirk.
    gw_fdata-hq = zhqname.
    gw_fdata-pernr = wa_tabfin-pernr.
    gw_fdata-ename = wa_tabfin-ename.
    gw_fdata-spart = wa_tabfin-spart.

    gw_fdata-tag = tag.
    gw_fdata-avg_val = avgqty.
    gw_fdata-apr_val = qty1.
    gw_fdata-may_val = qty2.
    gw_fdata-jun_val = qty3.
    gw_fdata-jul_val = qty4.
    gw_fdata-aug_val = qty5.
    gw_fdata-sep_val = qty6.
    gw_fdata-oct_val = qty7.
    gw_fdata-nov_val = qty8.
    gw_fdata-dec_val = qty9.
    gw_fdata-jan_val = qty10.
    gw_fdata-feb_val = qty11.
    gw_fdata-mar_val = qty12.
    gw_fdata-cum_tot_val = asofqty.
    gw_fdata-yrly_tot_val = qtysum.

    append gw_fdata to gt_fdata.
    clear gw_fdata.

    tag = 'MTPT% M'.
*****    elname = 'CDET'.
    avgqty = ' '.
    qty1 = wa_tabfin-apr_mtpt_per.
    qty2 = wa_tabfin-may_mtpt_per.
    qty3 = wa_tabfin-jun_mtpt_per.
    qty4 = wa_tabfin-jul_mtpt_per.
    qty5 = wa_tabfin-aug_mtpt_per.
    qty6 = wa_tabfin-sep_mtpt_per.
    qty7 = wa_tabfin-oct_mtpt_per.
    qty8 = wa_tabfin-nov_mtpt_per.
    qty9 = wa_tabfin-dec_mtpt_per.
    qty10 = wa_tabfin-jan_mtpt_per.
    qty11 = wa_tabfin-feb_mtpt_per.
    qty12 = wa_tabfin-mar_mtpt_per.
    qtysum =  ' '.
*****    perform write_main_form.

    gw_fdata-bzirk = wa_tabfin-bzirk.
    gw_fdata-hq = zhqname.
    gw_fdata-pernr = wa_tabfin-pernr.
    gw_fdata-ename = wa_tabfin-ename.
    gw_fdata-spart = wa_tabfin-spart.

    gw_fdata-tag = tag.
    gw_fdata-avg_val = avgqty.
    gw_fdata-apr_val = qty1.
    gw_fdata-may_val = qty2.
    gw_fdata-jun_val = qty3.
    gw_fdata-jul_val = qty4.
    gw_fdata-aug_val = qty5.
    gw_fdata-sep_val = qty6.
    gw_fdata-oct_val = qty7.
    gw_fdata-nov_val = qty8.
    gw_fdata-dec_val = qty9.
    gw_fdata-jan_val = qty10.
    gw_fdata-feb_val = qty11.
    gw_fdata-mar_val = qty12.
    gw_fdata-cum_tot_val = asofqty.
    gw_fdata-yrly_tot_val = qtysum.

    append gw_fdata to gt_fdata.
    clear gw_fdata.

    tag = 'YPM    '.
*****    elname = 'YPMDET'.
    avgqty = wa_tabfin-avg_ypm.
    qty1 = wa_tabfin-apr_ypm.
    qty2 = wa_tabfin-may_ypm.
    qty3 = wa_tabfin-jun_ypm.
    qty4 = wa_tabfin-jul_ypm.
    qty5 = wa_tabfin-aug_ypm.
    qty6 = wa_tabfin-sep_ypm.
    qty7 = wa_tabfin-oct_ypm.
    qty8 = wa_tabfin-nov_ypm.
    qty9 = wa_tabfin-dec_ypm.
    qty10 = wa_tabfin-jan_ypm.
    qty11 = wa_tabfin-feb_ypm.
    qty12 = wa_tabfin-mar_ypm.
    qtysum =  ''.
*****    perform write_main_form.

    gw_fdata-bzirk = wa_tabfin-bzirk.
    gw_fdata-hq = zhqname.
    gw_fdata-pernr = wa_tabfin-pernr.
    gw_fdata-ename = wa_tabfin-ename.
    gw_fdata-spart = wa_tabfin-spart.

    gw_fdata-tag = tag.
    gw_fdata-avg_val = avgqty.
    gw_fdata-apr_val = qty1.
    gw_fdata-may_val = qty2.
    gw_fdata-jun_val = qty3.
    gw_fdata-jul_val = qty4.
    gw_fdata-aug_val = qty5.
    gw_fdata-sep_val = qty6.
    gw_fdata-oct_val = qty7.
    gw_fdata-nov_val = qty8.
    gw_fdata-dec_val = qty9.
    gw_fdata-jan_val = qty10.
    gw_fdata-feb_val = qty11.
    gw_fdata-mar_val = qty12.
    gw_fdata-cum_tot_val = asofqty.
    gw_fdata-yrly_tot_val = qtysum.

    append gw_fdata to gt_fdata.
    clear gw_fdata.


    tag = 'NO.MTPT'.
*****    elname = 'CDET'.
    avgqty = ' '.
    qty1 = wa_tabfin-apr_totse_ach.
    qty2 = wa_tabfin-may_totse_ach.
    qty3 = wa_tabfin-jun_totse_ach.
    qty4 = wa_tabfin-jul_totse_ach.
    qty5 = wa_tabfin-aug_totse_ach.
    qty6 = wa_tabfin-sep_totse_ach.
    qty7 = wa_tabfin-oct_totse_ach.
    qty8 = wa_tabfin-nov_totse_ach.
    qty9 = wa_tabfin-dec_totse_ach.
    qty10 = wa_tabfin-jan_totse_ach.
    qty11 = wa_tabfin-feb_totse_ach.
    qty12 = wa_tabfin-mar_totse_ach.
    qtysum =  ' '.
*****    perform write_main_form.

    gw_fdata-bzirk = wa_tabfin-bzirk.
    gw_fdata-hq = zhqname.
    gw_fdata-pernr = wa_tabfin-pernr.
    gw_fdata-ename = wa_tabfin-ename.
    gw_fdata-spart = wa_tabfin-spart.

    gw_fdata-tag = tag.
    gw_fdata-avg_val = avgqty.
    gw_fdata-apr_val = qty1.
    gw_fdata-may_val = qty2.
    gw_fdata-jun_val = qty3.
    gw_fdata-jul_val = qty4.
    gw_fdata-aug_val = qty5.
    gw_fdata-sep_val = qty6.
    gw_fdata-oct_val = qty7.
    gw_fdata-nov_val = qty8.
    gw_fdata-dec_val = qty9.
    gw_fdata-jan_val = qty10.
    gw_fdata-feb_val = qty11.
    gw_fdata-mar_val = qty12.
    gw_fdata-cum_tot_val = asofqty.
    gw_fdata-yrly_tot_val = qtysum.

    append gw_fdata to gt_fdata.
    clear gw_fdata.

    at end of bzirk.
      if ctr = 2.
*****        perform group-total.
        prdname = 'SUB TOTAL '.
        tag = 'PR.YR. '.
*****        elname = 'PDET_ST'.
        avgqty = pqtysum / 12.
*****        perform write_main_form.

        gw_fdata-bzirk = wa_tabfin-bzirk.
        gw_fdata-hq = zhqname.
        gw_fdata-pernr = wa_tabfin-pernr.
        gw_fdata-ename = wa_tabfin-ename.
        gw_fdata-spart = wa_tabfin-spart.

        gw_fdata-grp_name = prdname.
        gw_fdata-tag = tag.
        gw_fdata-avg_val = avgqty.
        gw_fdata-apr_val = pqty1.
        gw_fdata-may_val = pqty2.
        gw_fdata-jun_val = pqty3.
        gw_fdata-jul_val = pqty4.
        gw_fdata-aug_val = pqty5.
        gw_fdata-sep_val = pqty6.
        gw_fdata-oct_val = pqty7.
        gw_fdata-nov_val = pqty8.
        gw_fdata-dec_val = pqty9.
        gw_fdata-jan_val = pqty10.
        gw_fdata-feb_val = pqty11.
        gw_fdata-mar_val = pqty12.
        gw_fdata-cum_tot_val = pqtyason.
        gw_fdata-yrly_tot_val = pqtysum.
        append gw_fdata to gt_fdata.
        clear gw_fdata.

        tag = 'CR.YR. '.
*****        elname = 'CDET_ST'.
        avgqty = dqtysum / mctr.
*****        perform write_main_form.

        gw_fdata-bzirk = wa_tabfin-bzirk.
        gw_fdata-hq = zhqname.
        gw_fdata-pernr = wa_tabfin-pernr.
        gw_fdata-ename = wa_tabfin-ename.
        gw_fdata-spart = wa_tabfin-spart.

        gw_fdata-tag = tag.
        gw_fdata-avg_val = avgqty.
        gw_fdata-apr_val = dqty1.
        gw_fdata-may_val = dqty2.
        gw_fdata-jun_val = dqty3.
        gw_fdata-jul_val = dqty4.
        gw_fdata-aug_val = dqty5.
        gw_fdata-sep_val = dqty6.
        gw_fdata-oct_val = dqty7.
        gw_fdata-nov_val = dqty8.
        gw_fdata-dec_val = dqty9.
        gw_fdata-jan_val = dqty10.
        gw_fdata-feb_val = dqty11.
        gw_fdata-mar_val = dqty12.
        gw_fdata-yrly_tot_val = dqtysum.
        append gw_fdata to gt_fdata.
        clear gw_fdata.


        perform stcalcgrth.
        tag = 'CU.GR.%'.
*****        elname = 'GRTHDET_T'.
        avgqty = ' '.
*****        perform write_main_form.
        gw_fdata-bzirk = wa_tabfin-bzirk.
        gw_fdata-hq = zhqname.
        gw_fdata-pernr = wa_tabfin-pernr.
        gw_fdata-ename = wa_tabfin-ename.
        gw_fdata-spart = wa_tabfin-spart.

        gw_fdata-tag = tag.
        gw_fdata-avg_val = avgqty.
        gw_fdata-apr_val = qty1.
        gw_fdata-may_val = qty2.
        gw_fdata-jun_val = qty3.
        gw_fdata-jul_val = qty4.
        gw_fdata-aug_val = qty5.
        gw_fdata-sep_val = qty6.
        gw_fdata-oct_val = qty7.
        gw_fdata-nov_val = qty8.
        gw_fdata-dec_val = qty9.
        gw_fdata-jan_val = qty10.
        gw_fdata-feb_val = qty11.
        gw_fdata-mar_val = qty12.
        gw_fdata-yrly_tot_val = qtysum.
        append gw_fdata to gt_fdata.
        clear gw_fdata.

        ctr = 0.
      endif.
*****      perform group-total.
      prdname = 'TOTAL (GROSS)'.
      tag = 'PR.YR. '.
*****      elname = 'PDET_TOT'.
      avgqty = fpqtysum / 12.
*****      perform write_main_form.

      gw_fdata-bzirk = wa_tabfin-bzirk.
      gw_fdata-hq = prdname."zhqname.
      gw_fdata-pernr = wa_tabfin-pernr.
      gw_fdata-ename = wa_tabfin-ename.
      gw_fdata-spart = wa_tabfin-spart.

      gw_fdata-grp_name = prdname.
      gw_fdata-tag = tag.
      gw_fdata-avg_val = avgqty.
      gw_fdata-apr_val = fpqty1.
      gw_fdata-may_val = fpqty2.
      gw_fdata-jun_val = fpqty3.
      gw_fdata-jul_val = fpqty4.
      gw_fdata-aug_val = fpqty5.
      gw_fdata-sep_val = fpqty6.
      gw_fdata-oct_val = fpqty7.
      gw_fdata-nov_val = fpqty8.
      gw_fdata-dec_val = fpqty9.
      gw_fdata-jan_val = fpqty10.
      gw_fdata-feb_val = fpqty11.
      gw_fdata-mar_val = fpqty12.
      gw_fdata-cum_tot_val = fpqtyason.
      gw_fdata-yrly_tot_val = fpqtysum.
      append gw_fdata to gt_fdata.
      clear gw_fdata.


      tag = 'CR.YR. '.
*****      elname = 'CDET_TOT'.
      avgqty = fdqtysum / mctr.
*****      perform write_main_form.

      gw_fdata-bzirk = wa_tabfin-bzirk.
      gw_fdata-hq = prdname."zhqname.
      gw_fdata-pernr = wa_tabfin-pernr.
      gw_fdata-ename = wa_tabfin-ename.
      gw_fdata-spart = wa_tabfin-spart.

      gw_fdata-tag = tag.
      gw_fdata-avg_val = avgqty.
      gw_fdata-apr_val = fdqty1.
      gw_fdata-may_val = fdqty2.
      gw_fdata-jun_val = fdqty3.
      gw_fdata-jul_val = fdqty4.
      gw_fdata-aug_val = fdqty5.
      gw_fdata-sep_val = fdqty6.
      gw_fdata-oct_val = fdqty7.
      gw_fdata-nov_val = fdqty8.
      gw_fdata-dec_val = fdqty9.
      gw_fdata-jan_val = fdqty10.
      gw_fdata-feb_val = fdqty11.
      gw_fdata-mar_val = fdqty12.
      gw_fdata-yrly_tot_val = fdqtysum.
      append gw_fdata to gt_fdata.
      clear gw_fdata.

      perform totcalcgrth.
      tag = 'CU.GR.%'.
*****      elname = 'GRTHDET_T'.
      avgqty = ' '.
*****      perform write_main_form.
*****      perform group-total.
      gw_fdata-bzirk = wa_tabfin-bzirk.
      gw_fdata-hq = prdname."zhqname.
      gw_fdata-pernr = wa_tabfin-pernr.
      gw_fdata-ename = wa_tabfin-ename.
      gw_fdata-spart = wa_tabfin-spart.

      gw_fdata-tag = tag.
      gw_fdata-avg_val = avgqty.
      gw_fdata-apr_val = qty1.
      gw_fdata-may_val = qty2.
      gw_fdata-jun_val = qty3.
      gw_fdata-jul_val = qty4.
      gw_fdata-aug_val = qty5.
      gw_fdata-sep_val = qty6.
      gw_fdata-oct_val = qty7.
      gw_fdata-nov_val = qty8.
      gw_fdata-dec_val = qty9.
      gw_fdata-jan_val = qty10.
      gw_fdata-feb_val = qty11.
      gw_fdata-mar_val = qty12.
      gw_fdata-yrly_tot_val = qtysum.
      append gw_fdata to gt_fdata.
      clear gw_fdata.

*****      perform summwrite.
      perform summwrite_sf.
      clear : pqty1 , pqty2, pqty3 , pqty4, pqty5 , pqty6, pqty7 , pqty8, pqty9 , pqty10,pqty11, pqty12, pqtyason, pqtysum.
      clear : dqty1 , dqty2, dqty3 , dqty4, dqty5 , dqty6, dqty7 , dqty8, dqty9 , dqty10,dqty11, dqty12, dqtysum.
      clear : fpqty1 , fpqty2, fpqty3 , fpqty4, fpqty5 , fpqty6, fpqty7 , fpqty8, fpqty9 , fpqty10,fpqty11, fpqty12, fpqtyason, fpqtysum.
      clear : fdqty1 , fdqty2, fdqty3 , fdqty4, fdqty5 , fdqty6, fdqty7 , fdqty8, fdqty9 , fdqty10,fdqty11, fdqty12, fdqtysum.

*****      perform sr13close.
    endat.
*****    at last.
*****      perform group-total.
*****      perform sr13close.
*****    endat.
  endloop.

  if gt_fdata[] is not initial and ( r3 = 'X' or r4 = 'X' or r6 = 'X' or r7 = 'X') .
    clear gt_fdata_all[].
    gt_fdata_all[] = gt_fdata[].

    clear gt_sr12_total_all[].
    gt_sr12_total_all[] = gt_sr12_total[].
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  SUMMWRITE_SF
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form summwrite_sf .
  data : mval type p.
  data : mtgt type p.
  read table it_tabsum into wa_sumfin with key bzirk = wa_tabfin-bzirk.
  clear : qty1 , qty2, qty3 , qty4, qty5 , qty6, qty7 , qty8, qty9 , qty10, qty11, qty12, asofqty, qtysum.
  qty1 = wa_sumfin-apr_pval.
  qty2 = wa_sumfin-may_pval.
  qty3 = wa_sumfin-jun_pval.
  qty4 = wa_sumfin-jul_pval.
  qty5 = wa_sumfin-aug_pval.
  qty6 = wa_sumfin-sep_pval.
  qty7 = wa_sumfin-oct_pval.
  qty8 = wa_sumfin-nov_pval.
  qty9 = wa_sumfin-dec_pval.
  qty10 = wa_sumfin-jan_pval.
  qty11 = wa_sumfin-feb_pval.
  qty12 = wa_sumfin-mar_pval.
  qtysum =  wa_sumfin-apr_pval + wa_sumfin-may_pval + wa_sumfin-jun_pval +
            wa_sumfin-jul_pval + wa_sumfin-aug_pval + wa_sumfin-sep_pval +
            wa_sumfin-oct_pval + wa_sumfin-nov_pval + wa_sumfin-dec_pval +
            wa_sumfin-jan_pval + wa_sumfin-feb_pval + wa_sumfin-mar_pval .

  prdname = 'PREV.YR. NET SALE(month)'.
*****  ELNAME = 'NDET'.
*****  PERFORM WRITE_MAIN_FORM.
*****  PERFORM GROUP-TOTAL.

  gw_sr12_total-bzirk = wa_sumfin-bzirk.

  gw_sr12_total-grp_name = prdname.
  gw_sr12_total-apr_val = qty1.
  gw_sr12_total-may_val = qty2.
  gw_sr12_total-jun_val = qty3.
  gw_sr12_total-jul_val = qty4.
  gw_sr12_total-aug_val = qty5.
  gw_sr12_total-sep_val = qty6.
  gw_sr12_total-oct_val = qty7.
  gw_sr12_total-nov_val = qty8.
  gw_sr12_total-dec_val = qty9.
  gw_sr12_total-jan_val = qty10.
  gw_sr12_total-feb_val = qty11.
  gw_sr12_total-mar_val = qty12.
  gw_sr12_total-yrly_tot_val = qtysum.
  append gw_sr12_total to gt_sr12_total.
  clear gw_sr12_total.

  clear : qty1 , qty2, qty3 , qty4, qty5 , qty6, qty7 , qty8, qty9 , qty10, qty11, qty12, asofqty, qtysum.
  qty1 = wa_sumfin-apr_tgt.
  qty2 = wa_sumfin-may_tgt.
  qty3 = wa_sumfin-jun_tgt.
  qty4 = wa_sumfin-jul_tgt.
  qty5 = wa_sumfin-aug_tgt.
  qty6 = wa_sumfin-sep_tgt.
  qty7 = wa_sumfin-oct_tgt.
  qty8 = wa_sumfin-nov_tgt.
  qty9 = wa_sumfin-dec_tgt.
  qty10 = wa_sumfin-jan_tgt.
  qty11 = wa_sumfin-feb_tgt.
  qty12 = wa_sumfin-mar_tgt.
  qtysum =  wa_sumfin-apr_tgt + wa_sumfin-may_tgt + wa_sumfin-jun_tgt +
            wa_sumfin-jul_tgt + wa_sumfin-aug_tgt + wa_sumfin-sep_tgt +
            wa_sumfin-oct_tgt + wa_sumfin-nov_tgt + wa_sumfin-dec_tgt +
            wa_sumfin-jan_tgt + wa_sumfin-feb_tgt + wa_sumfin-mar_tgt .

  prdname = 'CURR.YR.Sale Trgt(month)'.
*****  ELNAME = 'NDET'.
*****  PERFORM WRITE_MAIN_FORM.
*****  PERFORM GROUP-TOTAL.
  gw_sr12_total-bzirk = wa_sumfin-bzirk.
  gw_sr12_total-grp_name = prdname.

  gw_sr12_total-apr_val = qty1.
  gw_sr12_total-may_val = qty2.
  gw_sr12_total-jun_val = qty3.
  gw_sr12_total-jul_val = qty4.
  gw_sr12_total-aug_val = qty5.
  gw_sr12_total-sep_val = qty6.
  gw_sr12_total-oct_val = qty7.
  gw_sr12_total-nov_val = qty8.
  gw_sr12_total-dec_val = qty9.
  gw_sr12_total-jan_val = qty10.
  gw_sr12_total-feb_val = qty11.
  gw_sr12_total-mar_val = qty12.
  gw_sr12_total-yrly_tot_val = qtysum.
  append gw_sr12_total to gt_sr12_total.
  clear gw_sr12_total.

  clear : qty1 , qty2, qty3 , qty4, qty5 , qty6, qty7 , qty8, qty9 , qty10, qty11, qty12, asofqty, qtysum.
  qty1 = wa_sumfin-apr_val.
  qty2 = wa_sumfin-may_val.
  qty3 = wa_sumfin-jun_val.
  qty4 = wa_sumfin-jul_val.
  qty5 = wa_sumfin-aug_val.
  qty6 = wa_sumfin-sep_val.
  qty7 = wa_sumfin-oct_val.
  qty8 = wa_sumfin-nov_val.
  qty9 = wa_sumfin-dec_val.
  qty10 = wa_sumfin-jan_val.
  qty11 = wa_sumfin-feb_val.
  qty12 = wa_sumfin-mar_val.
  qtysum =  wa_sumfin-apr_val + wa_sumfin-may_val + wa_sumfin-jun_val +
            wa_sumfin-jul_val + wa_sumfin-aug_val + wa_sumfin-sep_val +
            wa_sumfin-oct_val + wa_sumfin-nov_val + wa_sumfin-dec_val +
            wa_sumfin-jan_val + wa_sumfin-feb_val + wa_sumfin-mar_val .

  prdname = 'CURR.YR. NET SALE(month)'.
*****  ELNAME = 'NDET'.
*****  PERFORM WRITE_MAIN_FORM.
*****  PERFORM GROUP-TOTAL.
  gw_sr12_total-bzirk = wa_sumfin-bzirk.
  gw_sr12_total-grp_name = prdname.

  gw_sr12_total-apr_val = qty1.
  gw_sr12_total-may_val = qty2.
  gw_sr12_total-jun_val = qty3.
  gw_sr12_total-jul_val = qty4.
  gw_sr12_total-aug_val = qty5.
  gw_sr12_total-sep_val = qty6.
  gw_sr12_total-oct_val = qty7.
  gw_sr12_total-nov_val = qty8.
  gw_sr12_total-dec_val = qty9.
  gw_sr12_total-jan_val = qty10.
  gw_sr12_total-feb_val = qty11.
  gw_sr12_total-mar_val = qty12.
  gw_sr12_total-yrly_tot_val = qtysum.
  append gw_sr12_total to gt_sr12_total.
  clear gw_sr12_total.

  clear : qty1 , qty2, qty3 , qty4, qty5 , qty6, qty7 , qty8, qty9 , qty10, qty11, qty12, asofqty, qtysum.
  if wa_sumfin-apr_val > 0 and wa_sumfin-apr_tgt > 0.
    qty1 = ( wa_sumfin-apr_val / wa_sumfin-apr_tgt ) * 100.
  endif.
  if wa_sumfin-may_val > 0 and wa_sumfin-may_tgt > 0.
    qty2 = ( wa_sumfin-may_val  / wa_sumfin-may_tgt ) * 100.
  endif.
  if wa_sumfin-jun_val > 0 and wa_sumfin-jun_tgt > 0.
    qty3 = ( wa_sumfin-jun_val / wa_sumfin-jun_tgt ) * 100.
  endif.
  if wa_sumfin-jul_val > 0 and wa_sumfin-jul_tgt > 0.
    qty4 = ( wa_sumfin-jul_val  / wa_sumfin-jul_tgt ) * 100.
  endif.
  if wa_sumfin-aug_val > 0 and wa_sumfin-aug_tgt > 0.
    qty5 = ( wa_sumfin-aug_val  / wa_sumfin-aug_tgt ) * 100.
  endif.
  if wa_sumfin-sep_val > 0 and wa_sumfin-sep_tgt > 0.
    qty6 = ( wa_sumfin-sep_val  / wa_sumfin-sep_tgt ) * 100.
  endif.
  if wa_sumfin-oct_val > 0 and wa_sumfin-oct_tgt > 0.
    qty7 = ( wa_sumfin-oct_val  / wa_sumfin-oct_tgt ) * 100.
  endif.
  if wa_sumfin-nov_val > 0 and wa_sumfin-nov_tgt > 0.
    qty8 = ( wa_sumfin-nov_val  / wa_sumfin-nov_tgt ) * 100.
  endif.
  if wa_sumfin-dec_val > 0 and wa_sumfin-dec_tgt > 0.
    qty9 = ( wa_sumfin-dec_val  / wa_sumfin-dec_tgt ) * 100.
  endif.
  if wa_sumfin-jan_val > 0 and wa_sumfin-jan_tgt > 0.
    qty10 = ( wa_sumfin-jan_val  / wa_sumfin-jan_tgt ) * 100.
  endif.
  if wa_sumfin-feb_val > 0 and wa_sumfin-feb_tgt > 0.
    qty11 = ( wa_sumfin-feb_val  / wa_sumfin-feb_tgt ) * 100.
  endif.
  if wa_sumfin-mar_val > 0 and wa_sumfin-mar_tgt > 0.
    qty12 = ( wa_sumfin-mar_val  / wa_sumfin-mar_tgt ) * 100.
  endif.

  prdname = '% TO Sale Trgt (month)'.
*****  ELNAME = 'NDET'.
*****  PERFORM WRITE_MAIN_FORM.
*****  PERFORM GROUP-TOTAL.
  gw_sr12_total-bzirk = wa_sumfin-bzirk.
  gw_sr12_total-grp_name = prdname.

  gw_sr12_total-apr_val = qty1.
  gw_sr12_total-may_val = qty2.
  gw_sr12_total-jun_val = qty3.
  gw_sr12_total-jul_val = qty4.
  gw_sr12_total-aug_val = qty5.
  gw_sr12_total-sep_val = qty6.
  gw_sr12_total-oct_val = qty7.
  gw_sr12_total-nov_val = qty8.
  gw_sr12_total-dec_val = qty9.
  gw_sr12_total-jan_val = qty10.
  gw_sr12_total-feb_val = qty11.
  gw_sr12_total-mar_val = qty12.
  gw_sr12_total-yrly_tot_val = qtysum.
  append gw_sr12_total to gt_sr12_total.
  clear gw_sr12_total.

  clear : qty1 , qty2, qty3 , qty4, qty5 , qty6, qty7 , qty8, qty9 , qty10, qty11, qty12, asofqty, qtysum.
  qty1 = wa_sumfin-papr_ypm.
  qty2 = wa_sumfin-pmay_ypm.
  qty3 = wa_sumfin-pjun_ypm.
  qty4 = wa_sumfin-pjul_ypm.
  qty5 = wa_sumfin-paug_ypm.
  qty6 = wa_sumfin-psep_ypm.
  qty7 = wa_sumfin-poct_ypm.
  qty8 = wa_sumfin-pnov_ypm.
  qty9 = wa_sumfin-pdec_ypm.
  qty10 = wa_sumfin-pjan_ypm.
  qty11 = wa_sumfin-pfeb_ypm.
  qty12 = wa_sumfin-pmar_ypm.
  qtysum = ' ' .
*    QTYSUM =  WA_SUMFIN-APR_TGT + WA_SUMFIN-MAY_TGT + WA_SUMFIN-JUN_TGT +
*              WA_SUMFIN-JUL_TGT + WA_SUMFIN-AUG_TGT + WA_SUMFIN-SEP_TGT +
*              WA_SUMFIN-OCT_TGT + WA_SUMFIN-NOV_TGT + WA_SUMFIN-DEC_TGT +
*              WA_SUMFIN-JAN_TGT + WA_SUMFIN-FEB_TGT + WA_SUMFIN-MAR_TGT .

  prdname = 'PREV.YR. Y.P.M'.
*****  ELNAME = 'NDET'.
*****  PERFORM WRITE_MAIN_FORM.
*****  PERFORM GROUP-TOTAL.
  gw_sr12_total-bzirk = wa_sumfin-bzirk.
  gw_sr12_total-grp_name = prdname.

  gw_sr12_total-apr_val = qty1.
  gw_sr12_total-may_val = qty2.
  gw_sr12_total-jun_val = qty3.
  gw_sr12_total-jul_val = qty4.
  gw_sr12_total-aug_val = qty5.
  gw_sr12_total-sep_val = qty6.
  gw_sr12_total-oct_val = qty7.
  gw_sr12_total-nov_val = qty8.
  gw_sr12_total-dec_val = qty9.
  gw_sr12_total-jan_val = qty10.
  gw_sr12_total-feb_val = qty11.
  gw_sr12_total-mar_val = qty12.
  gw_sr12_total-yrly_tot_val = qtysum.
  append gw_sr12_total to gt_sr12_total.
  clear gw_sr12_total.

  clear : qty1 , qty2, qty3 , qty4, qty5 , qty6, qty7 , qty8, qty9 , qty10, qty11, qty12, asofqty, qtysum.
  qty1 = wa_sumfin-apr_ypm.
  qty2 = wa_sumfin-may_ypm.
  qty3 = wa_sumfin-jun_ypm.
  qty4 = wa_sumfin-jul_ypm.
  qty5 = wa_sumfin-aug_ypm.
  qty6 = wa_sumfin-sep_ypm.
  qty7 = wa_sumfin-oct_ypm.
  qty8 = wa_sumfin-nov_ypm.
  qty9 = wa_sumfin-dec_ypm.
  qty10 = wa_sumfin-jan_ypm.
  qty11 = wa_sumfin-feb_ypm.
  qty12 = wa_sumfin-mar_ypm.
  qtysum = ' ' .
*    QTYSUM =  WA_SUMFIN-APR_TGT + WA_SUMFIN-MAY_TGT + WA_SUMFIN-JUN_TGT +
*              WA_SUMFIN-JUL_TGT + WA_SUMFIN-AUG_TGT + WA_SUMFIN-SEP_TGT +
*              WA_SUMFIN-OCT_TGT + WA_SUMFIN-NOV_TGT + WA_SUMFIN-DEC_TGT +
*              WA_SUMFIN-JAN_TGT + WA_SUMFIN-FEB_TGT + WA_SUMFIN-MAR_TGT .

  prdname = 'CURR.YR. Y.P.M'.
*****  ELNAME = 'NDET'.
*****  PERFORM WRITE_MAIN_FORM.
*****  PERFORM GROUP-TOTAL.
  gw_sr12_total-bzirk = wa_sumfin-bzirk.
  gw_sr12_total-grp_name = prdname.

  gw_sr12_total-apr_val = qty1.
  gw_sr12_total-may_val = qty2.
  gw_sr12_total-jun_val = qty3.
  gw_sr12_total-jul_val = qty4.
  gw_sr12_total-aug_val = qty5.
  gw_sr12_total-sep_val = qty6.
  gw_sr12_total-oct_val = qty7.
  gw_sr12_total-nov_val = qty8.
  gw_sr12_total-dec_val = qty9.
  gw_sr12_total-jan_val = qty10.
  gw_sr12_total-feb_val = qty11.
  gw_sr12_total-mar_val = qty12.
  gw_sr12_total-yrly_tot_val = qtysum.
  append gw_sr12_total to gt_sr12_total.
  clear gw_sr12_total.


  clear : qty1 , qty2, qty3 , qty4, qty5 , qty6, qty7 , qty8, qty9 , qty10, qty11, qty12, asofqty, qtysum.
  if wa_sumfin-apr_val > 0 and wa_sumfin-apr_pval > 0.
    qty1 = ( ( wa_sumfin-apr_val / wa_sumfin-apr_pval ) * 100 ) - 100.
  endif.
  if wa_sumfin-may_val > 0 and wa_sumfin-may_pval > 0.
    qty2 = ( ( wa_sumfin-may_val  / wa_sumfin-may_pval ) * 100  ) - 100..
  endif.
  if wa_sumfin-jun_val > 0 and wa_sumfin-jun_pval > 0.
    qty3 = ( ( wa_sumfin-jun_val / wa_sumfin-jun_pval ) * 100  ) - 100..
  endif.
  if wa_sumfin-jul_val > 0 and wa_sumfin-jul_pval > 0.
    qty4 = ( ( wa_sumfin-jul_val  / wa_sumfin-jul_pval ) * 100  ) - 100..
  endif.
  if wa_sumfin-aug_val > 0 and wa_sumfin-aug_pval > 0.
    qty5 = ( ( wa_sumfin-aug_val  / wa_sumfin-aug_pval ) * 100 ) - 100.
  endif.
  if wa_sumfin-sep_val > 0 and wa_sumfin-sep_pval > 0.
    qty6 = ( ( wa_sumfin-sep_val  / wa_sumfin-sep_pval ) * 100 ) - 100.
  endif.
  if wa_sumfin-oct_val > 0 and wa_sumfin-oct_pval > 0.
    qty7 = ( ( wa_sumfin-oct_val  / wa_sumfin-oct_pval ) * 100 ) - 100.
  endif.
  if wa_sumfin-nov_val > 0 and wa_sumfin-nov_pval > 0.
    qty8 = ( ( wa_sumfin-nov_val  / wa_sumfin-nov_pval ) * 100 ) - 100.
  endif.
  if wa_sumfin-dec_val > 0 and wa_sumfin-dec_pval > 0.
    qty9 = ( ( wa_sumfin-dec_val  / wa_sumfin-dec_pval ) * 100 ) - 100.
  endif.
  if wa_sumfin-jan_val > 0 and wa_sumfin-jan_pval > 0.
    qty10 = ( ( wa_sumfin-jan_val  / wa_sumfin-jan_pval ) * 100 ) - 100.
  endif.
  if wa_sumfin-feb_val > 0 and wa_sumfin-feb_pval > 0.
    qty11 = ( ( wa_sumfin-feb_val  / wa_sumfin-feb_pval ) * 100 ) - 100.
  endif.
  if wa_sumfin-mar_val > 0 and wa_sumfin-mar_pval > 0.
    qty12 = ( ( wa_sumfin-mar_val  / wa_sumfin-mar_pval ) * 100 ) - 100.
  endif.

  prdname = '% TO Growth (month)'.
*****  ELNAME = 'NDET'.
*****  PERFORM WRITE_MAIN_FORM.
*****  PERFORM GROUP-TOTAL.
  gw_sr12_total-bzirk = wa_sumfin-bzirk.
  gw_sr12_total-grp_name = prdname.

  gw_sr12_total-apr_val = qty1.
  gw_sr12_total-may_val = qty2.
  gw_sr12_total-jun_val = qty3.
  gw_sr12_total-jul_val = qty4.
  gw_sr12_total-aug_val = qty5.
  gw_sr12_total-sep_val = qty6.
  gw_sr12_total-oct_val = qty7.
  gw_sr12_total-nov_val = qty8.
  gw_sr12_total-dec_val = qty9.
  gw_sr12_total-jan_val = qty10.
  gw_sr12_total-feb_val = qty11.
  gw_sr12_total-mar_val = qty12.
  gw_sr12_total-yrly_tot_val = qtysum.
  append gw_sr12_total to gt_sr12_total.
  clear gw_sr12_total.

  clear : qty1 , qty2, qty3 , qty4, qty5 , qty6, qty7 , qty8, qty9 , qty10, qty11, qty12, asofqty, qtysum.
  clear : mval, mtgt .
  if wa_sumfin-jun_val > 0 .
    mval = wa_sumfin-apr_val + wa_sumfin-may_val + wa_sumfin-jun_val.
    mtgt = wa_sumfin-apr_tgt + wa_sumfin-may_tgt + wa_sumfin-jun_tgt.
    if mval > 0 and mtgt > 0.
      qty3 = ( mval  / mtgt ) * 100.
    endif.
  endif.

  if wa_sumfin-sep_val > 0 .
    mval = wa_sumfin-jul_val + wa_sumfin-aug_val + wa_sumfin-sep_val.
    mtgt = wa_sumfin-jul_tgt + wa_sumfin-aug_tgt + wa_sumfin-sep_tgt.
    if mval > 0 and mtgt > 0.
      qty6 =  ( mval  / mtgt ) * 100.
    endif.
  endif.

  if wa_sumfin-dec_val > 0 .
    mval = wa_sumfin-oct_val + wa_sumfin-nov_val + wa_sumfin-dec_val.
    mtgt = wa_sumfin-oct_tgt + wa_sumfin-nov_tgt + wa_sumfin-dec_tgt.
    if mval > 0 and mtgt > 0.
      qty9 =  ( mval  / mtgt ) * 100.
    endif.
  endif.
  if wa_sumfin-mar_val > 0 .
    mval = wa_sumfin-jan_val + wa_sumfin-feb_val + wa_sumfin-mar_val.
    mtgt = wa_sumfin-jan_tgt + wa_sumfin-feb_tgt + wa_sumfin-mar_tgt.
    if mval > 0 and mtgt > 0.
      qty12 =  ( mval  / mtgt ) * 100.
    endif.
  endif.

  prdname = '% TO Sale Trgt (qtr)'.
*****  ELNAME = 'NDET'.
*****  PERFORM WRITE_MAIN_FORM.
*****  PERFORM GROUP-TOTAL.
  gw_sr12_total-bzirk = wa_sumfin-bzirk.
  gw_sr12_total-grp_name = prdname.

  gw_sr12_total-apr_val = qty1.
  gw_sr12_total-may_val = qty2.
  gw_sr12_total-jun_val = qty3.
  gw_sr12_total-jul_val = qty4.
  gw_sr12_total-aug_val = qty5.
  gw_sr12_total-sep_val = qty6.
  gw_sr12_total-oct_val = qty7.
  gw_sr12_total-nov_val = qty8.
  gw_sr12_total-dec_val = qty9.
  gw_sr12_total-jan_val = qty10.
  gw_sr12_total-feb_val = qty11.
  gw_sr12_total-mar_val = qty12.
  gw_sr12_total-yrly_tot_val = qtysum.
  append gw_sr12_total to gt_sr12_total.
  clear gw_sr12_total.

  clear : qty1 , qty2, qty3 , qty4, qty5 , qty6, qty7 , qty8, qty9 , qty10, qty11, qty12, asofqty, qtysum.
  clear : mval, mtgt .
  qty1 = wa_sumfin-apr_pval.
  qty2 = qty1 + wa_sumfin-may_pval.
  qty3 = qty2 + wa_sumfin-jun_pval.
  qty4 = qty3 + wa_sumfin-jul_pval.
  qty5 = qty4 + wa_sumfin-aug_pval.
  qty6 = qty5 + wa_sumfin-sep_pval.
  qty7 = qty6 + wa_sumfin-oct_pval.
  qty8 = qty7 + wa_sumfin-nov_pval.
  qty9 = qty8 + wa_sumfin-dec_pval.
  qty10 = qty9 + wa_sumfin-jan_pval.
  qty11 = qty10 + wa_sumfin-feb_pval.
  qty12 = qty11 + wa_sumfin-mar_pval.
  qtysum =  qty12.

  prdname = 'PREV.YR. NET SALES (cum)'.
*****  ELNAME = 'NDET'.
*****  PERFORM WRITE_MAIN_FORM.
*****  PERFORM GROUP-TOTAL.
  gw_sr12_total-bzirk = wa_sumfin-bzirk.
  gw_sr12_total-grp_name = prdname.

  gw_sr12_total-apr_val = qty1.
  gw_sr12_total-may_val = qty2.
  gw_sr12_total-jun_val = qty3.
  gw_sr12_total-jul_val = qty4.
  gw_sr12_total-aug_val = qty5.
  gw_sr12_total-sep_val = qty6.
  gw_sr12_total-oct_val = qty7.
  gw_sr12_total-nov_val = qty8.
  gw_sr12_total-dec_val = qty9.
  gw_sr12_total-jan_val = qty10.
  gw_sr12_total-feb_val = qty11.
  gw_sr12_total-mar_val = qty12.
  gw_sr12_total-yrly_tot_val = qtysum.
  append gw_sr12_total to gt_sr12_total.
  clear gw_sr12_total.


  clear : qty1 , qty2, qty3 , qty4, qty5 , qty6, qty7 , qty8, qty9 , qty10, qty11, qty12, asofqty, qtysum.
  clear : mval, mtgt .
  qty1 = wa_sumfin-apr_tgt.
  qty2 = qty1 + wa_sumfin-may_tgt.
  qty3 = qty2 + wa_sumfin-jun_tgt.
  qty4 = qty3 + wa_sumfin-jul_tgt.
  qty5 = qty4 + wa_sumfin-aug_tgt.
  qty6 = qty5 + wa_sumfin-sep_tgt.
  qty7 = qty6 + wa_sumfin-oct_tgt.
  qty8 = qty7 + wa_sumfin-nov_tgt.
  qty9 = qty8 + wa_sumfin-dec_tgt.
  qty10 = qty9 + wa_sumfin-jan_tgt.
  qty11 = qty10 + wa_sumfin-feb_tgt.
  qty12 = qty11 + wa_sumfin-mar_tgt.
  qtysum = qty12.

  prdname = 'CURR.YR. Sale Trgt (cum)'.
*****  ELNAME = 'NDET'.
*****  PERFORM WRITE_MAIN_FORM.
*****  PERFORM GROUP-TOTAL.
  gw_sr12_total-bzirk = wa_sumfin-bzirk.
  gw_sr12_total-grp_name = prdname.

  gw_sr12_total-apr_val = qty1.
  gw_sr12_total-may_val = qty2.
  gw_sr12_total-jun_val = qty3.
  gw_sr12_total-jul_val = qty4.
  gw_sr12_total-aug_val = qty5.
  gw_sr12_total-sep_val = qty6.
  gw_sr12_total-oct_val = qty7.
  gw_sr12_total-nov_val = qty8.
  gw_sr12_total-dec_val = qty9.
  gw_sr12_total-jan_val = qty10.
  gw_sr12_total-feb_val = qty11.
  gw_sr12_total-mar_val = qty12.
  gw_sr12_total-yrly_tot_val = qtysum.
  append gw_sr12_total to gt_sr12_total.
  clear gw_sr12_total.

  clear : qty1 , qty2, qty3 , qty4, qty5 , qty6, qty7 , qty8, qty9 , qty10, qty11, qty12, asofqty, qtysum.
  clear : mval, mtgt .
  if wa_sumfin-apr_val is not initial.
    qty1 = wa_sumfin-apr_val.
  endif.
  if wa_sumfin-may_val is not initial.
    qty2 = qty1 + wa_sumfin-may_val.
  endif.
  if wa_sumfin-jun_val is not initial.
    qty3 = qty2 + wa_sumfin-jun_val.
  endif.
  if wa_sumfin-jul_val is not initial.
    qty4 = qty3 + wa_sumfin-jul_val.
  endif.
  if wa_sumfin-aug_val is not initial.
    qty5 = qty4 + wa_sumfin-aug_val.
  endif.
  if wa_sumfin-sep_val is not initial.
    qty6 = qty5 + wa_sumfin-sep_val.
  endif.
  if wa_sumfin-oct_val is not initial.
    qty7 = qty6 + wa_sumfin-oct_val.
  endif.
  if wa_sumfin-nov_val is not initial.
    qty8 = qty7 + wa_sumfin-nov_val.
  endif.
  if wa_sumfin-dec_val is not initial.
    qty9 = qty8 + wa_sumfin-dec_val.
  endif.
  if wa_sumfin-jan_val is not initial.
    qty10 = qty9 + wa_sumfin-jan_val.
  endif.
  if wa_sumfin-feb_val is not initial.
    qty11 = qty10 + wa_sumfin-feb_val.
  endif.
  if wa_sumfin-mar_val is not initial.
    qty12 = qty11 + wa_sumfin-mar_val.
  endif.
  qtysum = qty12.

  prdname = 'CURR.YR. NET SALES (cum)'.
*****  ELNAME = 'NDET'.
*****  PERFORM WRITE_MAIN_FORM.
*****  PERFORM GROUP-TOTAL.
  gw_sr12_total-bzirk = wa_sumfin-bzirk.
  gw_sr12_total-grp_name = prdname.

  gw_sr12_total-apr_val = qty1.
  gw_sr12_total-may_val = qty2.
  gw_sr12_total-jun_val = qty3.
  gw_sr12_total-jul_val = qty4.
  gw_sr12_total-aug_val = qty5.
  gw_sr12_total-sep_val = qty6.
  gw_sr12_total-oct_val = qty7.
  gw_sr12_total-nov_val = qty8.
  gw_sr12_total-dec_val = qty9.
  gw_sr12_total-jan_val = qty10.
  gw_sr12_total-feb_val = qty11.
  gw_sr12_total-mar_val = qty12.
  gw_sr12_total-yrly_tot_val = qtysum.
  append gw_sr12_total to gt_sr12_total.
  clear gw_sr12_total.

  clear : qty1 , qty2, qty3 , qty4, qty5 , qty6, qty7 , qty8, qty9 , qty10, qty11, qty12, asofqty, qtysum.
  clear : mval, mtgt .
  mval = wa_sumfin-apr_val.
  mtgt = wa_sumfin-apr_tgt.
  if mval > 0 and mtgt > 0.
    qty1 = ( mval / mtgt ) * 100.
  endif.
  if wa_sumfin-may_val > 0 .
    mval = mval + wa_sumfin-may_val.
    mtgt = mtgt + wa_sumfin-may_tgt.
    if mval > 0 and mtgt > 0.
      qty2 = ( mval / mtgt ) * 100.
    endif.
  endif.
  if wa_sumfin-jun_val > 0 .
    mval = mval + wa_sumfin-jun_val.
    mtgt = mtgt + wa_sumfin-jun_tgt.
    if mval > 0 and mtgt > 0.
      qty3 = ( mval / mtgt ) * 100.
    endif.
  endif.
  if wa_sumfin-jul_val > 0 .
    mval = mval + wa_sumfin-jul_val.
    mtgt = mtgt + wa_sumfin-jul_tgt.
    if mval > 0 and mtgt > 0.
      qty4 = ( mval / mtgt ) * 100.
    endif.
  endif.
  if wa_sumfin-aug_val > 0 .
    mval = mval + wa_sumfin-aug_val.
    mtgt = mtgt + wa_sumfin-aug_tgt.
    if mval > 0 and mtgt > 0.
      qty5 = ( mval / mtgt ) * 100.
    endif.
  endif.
  if wa_sumfin-sep_val > 0 .
    mval = mval + wa_sumfin-sep_val.
    mtgt = mtgt + wa_sumfin-sep_tgt.
    if mval > 0 and mtgt > 0.
      qty6 = ( mval / mtgt ) * 100.
    endif.
  endif.
  if wa_sumfin-oct_val > 0 .
    mval = mval + wa_sumfin-oct_val.
    mtgt = mtgt + wa_sumfin-oct_tgt.
    if mval > 0 and mtgt > 0.
      qty7 = ( mval / mtgt ) * 100.
    endif.
  endif.
  if wa_sumfin-nov_val > 0 .
    mval = mval + wa_sumfin-nov_val.
    mtgt = mtgt + wa_sumfin-nov_tgt.
    if mval > 0 and mtgt > 0.
      qty8 = ( mval / mtgt ) * 100.
    endif.
  endif.
  if wa_sumfin-dec_val > 0 .
    mval = mval + wa_sumfin-dec_val.
    mtgt = mtgt + wa_sumfin-dec_tgt.
    if mval > 0 and mtgt > 0.
      qty9 = ( mval / mtgt ) * 100.
    endif.
  endif.
  if wa_sumfin-jan_val > 0 .
    mval = mval + wa_sumfin-jan_val.
    mtgt = mtgt + wa_sumfin-jan_tgt.
    if mval > 0 and mtgt > 0.
      qty10 = ( mval / mtgt ) * 100.
    endif.
  endif.
  if wa_sumfin-feb_val > 0 .
    mval = mval + wa_sumfin-feb_val.
    mtgt = mtgt + wa_sumfin-feb_tgt.
    if mval > 0 and mtgt > 0.
      qty11 = ( mval / mtgt ) * 100.
    endif.
  endif.
  if wa_sumfin-mar_val > 0 .
    mval = mval + wa_sumfin-mar_val.
    mtgt = mtgt + wa_sumfin-mar_tgt.
    if mval > 0 and mtgt > 0.
      qty12 = ( mval / mtgt ) * 100.
    endif.
  endif.
*    QTYSUM = QTY12.

  prdname = '% TO Sale Trgt (cum)'.
*****  ELNAME = 'NDET'.
*****  PERFORM WRITE_MAIN_FORM.
*****  PERFORM GROUP-TOTAL.
  gw_sr12_total-bzirk = wa_sumfin-bzirk.
  gw_sr12_total-grp_name = prdname.
  gw_sr12_total-apr_val = qty1.
  gw_sr12_total-may_val = qty2.
  gw_sr12_total-jun_val = qty3.
  gw_sr12_total-jul_val = qty4.
  gw_sr12_total-aug_val = qty5.
  gw_sr12_total-sep_val = qty6.
  gw_sr12_total-oct_val = qty7.
  gw_sr12_total-nov_val = qty8.
  gw_sr12_total-dec_val = qty9.
  gw_sr12_total-jan_val = qty10.
  gw_sr12_total-feb_val = qty11.
  gw_sr12_total-mar_val = qty12.
  gw_sr12_total-yrly_tot_val = qtysum.
  append gw_sr12_total to gt_sr12_total.
  clear gw_sr12_total.

  clear : qty1 , qty2, qty3 , qty4, qty5 , qty6, qty7 , qty8, qty9 , qty10, qty11, qty12, asofqty, qtysum.
  clear : mval, mtgt .
  mval = wa_sumfin-apr_val.
  mtgt = wa_sumfin-apr_pval.
  if mval > 0 and mtgt > 0.
    qty1 =  ( ( mval / mtgt ) * 100 ) - 100 .
  endif.
  if wa_sumfin-may_val > 0 .
    mval = mval + wa_sumfin-may_val.
    mtgt = mtgt + wa_sumfin-may_pval.
    if mval > 0 and mtgt > 0.
      qty2 = ( ( mval / mtgt ) * 100 ) - 100 .
    endif.
  endif.
  if wa_sumfin-jun_val > 0 .
    mval = mval + wa_sumfin-jun_val.
    mtgt = mtgt + wa_sumfin-jun_pval.
    if mval > 0 and mtgt > 0.
      qty3 = ( ( mval / mtgt ) * 100 ) - 100 .
    endif.
  endif.
  if wa_sumfin-jul_val > 0 .
    mval = mval + wa_sumfin-jul_val.
    mtgt = mtgt + wa_sumfin-jul_pval.
    if mval > 0 and mtgt > 0.
      qty4 = ( ( mval / mtgt ) * 100 ) - 100 .
    endif.
  endif.
  if wa_sumfin-aug_val > 0 .
    mval = mval + wa_sumfin-aug_val.
    mtgt = mtgt + wa_sumfin-aug_pval.
    if mval > 0 and mtgt > 0.
      qty5 = ( ( mval / mtgt ) * 100 ) - 100 .
    endif.
  endif.
  if wa_sumfin-sep_val > 0 .
    mval = mval + wa_sumfin-sep_val.
    mtgt = mtgt + wa_sumfin-sep_pval.
    if mval > 0 and mtgt > 0.
      qty6 = ( ( mval / mtgt ) * 100 ) - 100 .
    endif.
  endif.
  if wa_sumfin-oct_val > 0 .
    mval = mval + wa_sumfin-oct_val.
    mtgt = mtgt + wa_sumfin-oct_pval.
    if mval > 0 and mtgt > 0.
      qty7 = ( ( mval / mtgt ) * 100 ) - 100 .
    endif.
  endif.
  if wa_sumfin-nov_val > 0 .
    mval = mval + wa_sumfin-nov_val.
    mtgt = mtgt + wa_sumfin-nov_pval.
    if mval > 0 and mtgt > 0.
      qty8 = ( ( mval / mtgt ) * 100 ) - 100 .
    endif.
  endif.
  if wa_sumfin-dec_val > 0 .
    mval = mval + wa_sumfin-dec_val.
    mtgt = mtgt + wa_sumfin-dec_pval.
    if mval > 0 and mtgt > 0.
      qty9 = ( ( mval / mtgt ) * 100 ) - 100 .
    endif.
  endif.
  if wa_sumfin-jan_val > 0 .
    mval = mval + wa_sumfin-jan_val.
    mtgt = mtgt + wa_sumfin-jan_pval.
    if mval > 0 and mtgt > 0.
      qty10 = ( ( mval / mtgt ) * 100 ) - 100 .
    endif.
  endif.
  if wa_sumfin-feb_val > 0 .
    mval = mval + wa_sumfin-feb_val.
    mtgt = mtgt + wa_sumfin-feb_pval.
    if mval > 0 and mtgt > 0.
      qty11 = ( ( mval / mtgt ) * 100 ) - 100 .
    endif.
  endif.
  if wa_sumfin-mar_val > 0 .
    mval = mval + wa_sumfin-mar_val.
    mtgt = mtgt + wa_sumfin-mar_pval.
    if mval > 0 and mtgt > 0.
      qty12 = ( ( mval / mtgt ) * 100 ) - 100 .
    endif.
  endif.
*    QTYSUM = QTY12.

  prdname = 'NET CUMM. GROWTH%'.
*****  ELNAME = 'NDET'.
*****  PERFORM WRITE_MAIN_FORM.
*****  PERFORM GROUP-TOTAL.
  gw_sr12_total-bzirk = wa_sumfin-bzirk.
  gw_sr12_total-grp_name = prdname.
  gw_sr12_total-apr_val = qty1.
  gw_sr12_total-may_val = qty2.
  gw_sr12_total-jun_val = qty3.
  gw_sr12_total-jul_val = qty4.
  gw_sr12_total-aug_val = qty5.
  gw_sr12_total-sep_val = qty6.
  gw_sr12_total-oct_val = qty7.
  gw_sr12_total-nov_val = qty8.
  gw_sr12_total-dec_val = qty9.
  gw_sr12_total-jan_val = qty10.
  gw_sr12_total-feb_val = qty11.
  gw_sr12_total-mar_val = qty12.
  gw_sr12_total-yrly_tot_val = qtysum.
  append gw_sr12_total to gt_sr12_total.
  clear gw_sr12_total.

endform.
*&---------------------------------------------------------------------*
*&      Form  PRINT_SFORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form print_sform .
  data: fm_name type  tdsfname.
  data: gw_output_opts type ssfcompop,
        gw_contrl_para type ssfctrlop.

**** title
  clear gv_title.
  concatenate mtitle mtitle1 mtitle2+0(13) into gv_title.
****  zm-wise data
  clear gt_fdata_zm[].
  gt_fdata_zm[] = gt_fdata[].

  sort gt_fdata_zm by spart.
  delete gt_fdata_zm where spart = '**'.
  sort gt_fdata_zm by bzirk.
  delete adjacent duplicates from gt_fdata_zm comparing bzirk.
*****  if gt_fdata_zm[] is not initial.
*****    loop at gt_fdata_zm into gw_fdata_zm.
*****      clear wa_tabfin.
*****      read table it_tabfin into wa_tabfin with key bzirk = gw_fdata_zm-bzirk.
*****      if sy-subrc = 0.
*****        gw_fdata_zm-pernr = wa_tabfin-pernr.
*****        gw_fdata_zm-ename = wa_tabfin-ename.
*****        gw_fdata_zm-hq = wa_tabfin-hq.
*****        gw_fdata_zm-spart = wa_tabfin-spart.
*****        modify gt_fdata_zm from gw_fdata_zm transporting pernr ename hq spart.
*****        clear gw_fdata_zm.
*****      endif.
*****    endloop.
*****  endif.
****  form printing
  clear fm_name.
  call function 'SSF_FUNCTION_MODULE_NAME'
    exporting
      formname = 'ZSR12C_FRM_SF'
    importing
      fm_name  = fm_name.


  gw_output_opts-tdnoprev = space.
  gw_output_opts-tddest    = 'LOCL'.
  gw_output_opts-tdnoprint = space.

  gw_contrl_para-no_dialog = space.
  gw_contrl_para-preview = space.

  call function fm_name
    exporting
      control_parameters = gw_contrl_para
*     MAIL_APPL_OBJ      =
*     MAIL_RECIPIENT     =
*     MAIL_SENDER        =
      output_options     = gw_output_opts
*     USER_SETTINGS      = 'X'
      gv_title           = gv_title
*       IMPORTING
*     document_output_info =
*     job_output_info    =
*     job_output_options =
    tables
      gt_fdata           = gt_fdata[]
      gt_sr12_total      = gt_sr12_total[]
      gt_fdata_zm        = gt_fdata_zm[]
    exceptions
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      others             = 5.
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  EMAIL_FORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form email_form .
  data: fm_name type  tdsfname.
  data: gw_output_opts type ssfcompop,
        gw_contrl_para type ssfctrlop.

**** title
  clear gv_title.
  concatenate mtitle mtitle1 mtitle2+0(13) into gv_title.
****  zm-wise data
  clear gt_fdata_zm[].
  gt_fdata_zm[] = gt_fdata[].
  sort gt_fdata_zm by spart.
  delete gt_fdata_zm where spart = '**'.
  sort gt_fdata_zm by bzirk.
  delete adjacent duplicates from gt_fdata_zm comparing bzirk.

  clear gt_fdata_zm_all[].
  gt_fdata_zm_all[] = gt_fdata_zm[].
****  form printing
  clear fm_name.
  call function 'SSF_FUNCTION_MODULE_NAME'
    exporting
      formname = 'ZSR12C_FRM_SF'
    importing
      fm_name  = fm_name.


  gw_output_opts-tdnoprev = 'X'.
  gw_output_opts-tddest    = 'LOCL'.
  gw_output_opts-tdnoprint = 'X'.

  gw_contrl_para-getotf = 'X'.
  gw_contrl_para-no_dialog = 'X'.
  gw_contrl_para-preview = space.

  loop at gt_fdata_zm_all into gw_fdata_zm_all.
****  pass zonw-wise data from all data - so email can be with required data only
    clear gt_fdata[].
    gt_fdata[] = gt_fdata_all[].
    delete gt_fdata where bzirk <> gw_fdata_zm_all-bzirk.

    clear gt_sr12_total[].
    gt_sr12_total[] = gt_sr12_total_all[].
    delete gt_sr12_total where bzirk <> gw_fdata_zm_all-bzirk.

    clear gt_fdata_zm[].
    gt_fdata_zm[] = gt_fdata_zm_all[].
    delete gt_fdata_zm where bzirk <> gw_fdata_zm_all-bzirk.

    clear gt_otf_data.
    call function fm_name
      exporting
        control_parameters = gw_contrl_para
*       MAIL_APPL_OBJ      =
*       MAIL_RECIPIENT     =
*       MAIL_SENDER        =
        output_options     = gw_output_opts
*       USER_SETTINGS      = 'X'
        gv_title           = gv_title
      importing
*       document_output_info =
        job_output_info    = gt_otf_data
*       job_output_options =
      tables
        gt_fdata           = gt_fdata[]
        gt_sr12_total      = gt_sr12_total[]
        gt_fdata_zm        = gt_fdata_zm[]
      exceptions
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        others             = 5.
    if sy-subrc <> 0.
      message id sy-msgid type sy-msgty number sy-msgno
              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.

    clear :gt_otf[],gt_tline[],gv_bin_filesize,gv_bin_xstr.
    gt_otf[] = gt_otf_data-otfdata[].

    call function 'CONVERT_OTF'
      exporting
        format                = 'PDF'
      importing
        bin_filesize          = gv_bin_filesize
        bin_file              = gv_bin_xstr
      tables
        otf                   = gt_otf[]
        lines                 = gt_tline[]
      exceptions
        err_max_linewidth     = 1
        err_format            = 2
        err_conv_not_possible = 3
        others                = 4.
    if sy-subrc <> 0.
      message id sy-msgid type sy-msgty number sy-msgno
              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.
**** email respective ZM data
    if gt_otf[] is not initial.
      perform send_mail.
    endif.
  endloop.
endform.
*&---------------------------------------------------------------------*
*&      Form  SEND_MAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form send_mail .
  data : lv_att_sub      type so_obj_des,
         lv_sender_email type adr6-smtp_addr,
         lw_usr21        type usr21.
***Xstring to binary
  call function 'SCMS_XSTRING_TO_BINARY'
    exporting
      buffer     = gv_bin_xstr
    tables
      binary_tab = gt_pdf_data.

  try.
*     -------- create persistent send request ------------------------
      lo_bcs = cl_bcs=>create_persistent( ).

****  email body
      concatenate 'This eMail is meant for information only. Please DO NOT REPLY.' cl_abap_char_utilities=>newline into gv_text.
      append gv_text to gt_text.
      clear gv_text.
      clear gv_text.
      concatenate cl_abap_char_utilities=>newline gv_text into gv_text.
      concatenate cl_abap_char_utilities=>newline gv_text into gv_text.
      clear gv_text.
      gv_text = ' BLUE CROSS LABORATORIES PRIVATE LTD.'.
      append gv_text to gt_text.

****Add the email body content to document
      write pdate to wa_d1 dd/mm/yyyy.
      write mdate to wa_d2 dd/mm/yyyy.
      clear : gv_text, gv_subject.
*****      CONCATENATE 'SR-13:MONTH-WISE PRODUCT GROUP SALE TREND - RM WISE' wa_d1 'TO ' wa_d2 gv_text INTO gv_subject SEPARATED BY space.

      gv_subject = 'SR-13:MONTH-WISE PRODUCT GROUP SALE TREND - RM WISE'.
      lo_doc_bcs = cl_document_bcs=>create_document(
                     i_type    = 'RAW'
                     i_text    = gt_text[]
                     i_length  = '12'
                     i_subject = gv_subject ).   "Subject of the Email

***     Add attachment to document and Add document to send request
***The internal table gt_pdf_data[] contains the content of our attachment.
****      attachment name
      clear lv_att_sub.
      concatenate 'SR-13' gw_fdata_zm_all-ename into lv_att_sub separated by '.'.
      call method lo_doc_bcs->add_attachment
        exporting
          i_attachment_type    = 'PDF'
          i_attachment_size    = gv_bin_filesize
          i_attachment_subject = lv_att_sub
          i_att_content_hex    = gt_pdf_data.

*     add document to send request
      call method lo_bcs->set_document( lo_doc_bcs ).

****    Set Sender
      clear lw_usr21.
      select single * from usr21 into lw_usr21 where bname = sy-uname.
      if sy-subrc = 0.
        clear lv_sender_email.
        select single smtp_addr from adr6 into lv_sender_email
          where addrnumber = lw_usr21-addrnumber
          and persnumber = lw_usr21-persnumber.
      endif.
      lo_sender = cl_cam_address_bcs=>create_internet_address( i_address_string = lv_sender_email
                                                               i_address_name = 'Sale Trend' ).

      call method lo_bcs->set_sender
        exporting
          i_sender = lo_sender.

****    Add recipient (e–mail address)
      read table it_tam2 into wa_tam2 with key pernr = gw_fdata_zm_all-pernr.
      if sy-subrc = 0.
        lo_recep = cl_cam_address_bcs=>create_internet_address( wa_tam2-usrid_long ).

        "Add recipient with its respective attributes to send request
        call method lo_bcs->add_recipient
          exporting
            i_recipient = lo_recep
            i_express   = 'X'.
      endif.
****    Set Send Immediately
      call method lo_bcs->set_send_immediately
        exporting
          i_send_immediately = 'X'.

***Send the Email
      call method lo_bcs->send(
        exporting
          i_with_error_screen = 'X'
        receiving
          result              = gv_sent_to_all ).

      if gv_sent_to_all is not initial.
        commit work.
      endif.

    catch cx_bcs into lo_cx_bcx.
      "Appropriate Exception Handling
      write: 'Exception:', lo_cx_bcx->error_type.
  endtry.
endform.
*&---------------------------------------------------------------------*
*&      Form  SEND_TO_EMAILID
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form send_to_emailid .
  data: fm_name type  tdsfname.
  data: gw_output_opts type ssfcompop,
        gw_contrl_para type ssfctrlop.
  data : lv_att_sub        type so_obj_des,
         lv_sender_email   type adr6-smtp_addr,
         lv_receiver_email type adr6-smtp_addr,
         lw_usr21          type usr21.
**** title
  clear gv_title.
  concatenate mtitle mtitle1 mtitle2+0(13) into gv_title.
****  zm-wise data
  clear gt_fdata_zm[].
  gt_fdata_zm[] = gt_fdata[].
  sort gt_fdata_zm by spart.
  delete gt_fdata_zm where spart = '**'.
  sort gt_fdata_zm by bzirk.
  delete adjacent duplicates from gt_fdata_zm comparing bzirk.

****  form OTF data
  clear fm_name.
  call function 'SSF_FUNCTION_MODULE_NAME'
    exporting
      formname = 'ZSR12C_FRM_SF'
    importing
      fm_name  = fm_name.

  gw_output_opts-tdnoprev = 'X'.
  gw_output_opts-tddest    = 'LOCL'.
  gw_output_opts-tdnoprint = 'X'.

  gw_contrl_para-getotf = 'X'.
  gw_contrl_para-no_dialog = 'X'.
  gw_contrl_para-preview = space.

  clear gt_otf_data.
  call function fm_name
    exporting
      control_parameters = gw_contrl_para
*     MAIL_APPL_OBJ      =
*     MAIL_RECIPIENT     =
*     MAIL_SENDER        =
      output_options     = gw_output_opts
*     USER_SETTINGS      = 'X'
      gv_title           = gv_title
    importing
*     document_output_info =
      job_output_info    = gt_otf_data
*     job_output_options =
    tables
      gt_fdata           = gt_fdata[]
      gt_sr12_total      = gt_sr12_total[]
      gt_fdata_zm        = gt_fdata_zm[]
    exceptions
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      others             = 5.
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.

  clear :gt_otf[],gt_tline[],gv_bin_filesize,gv_bin_xstr.
  gt_otf[] = gt_otf_data-otfdata[].

  call function 'CONVERT_OTF'
    exporting
      format                = 'PDF'
    importing
      bin_filesize          = gv_bin_filesize
      bin_file              = gv_bin_xstr
    tables
      otf                   = gt_otf[]
      lines                 = gt_tline[]
    exceptions
      err_max_linewidth     = 1
      err_format            = 2
      err_conv_not_possible = 3
      others                = 4.
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.

************* mail sending process  ******************
***Xstring to binary
  call function 'SCMS_XSTRING_TO_BINARY'
    exporting
      buffer     = gv_bin_xstr
    tables
      binary_tab = gt_pdf_data.

  try.
*     -------- create persistent send request ------------------------
      lo_bcs = cl_bcs=>create_persistent( ).

****  email body
      concatenate 'This eMail is meant for information only. Please DO NOT REPLY.' cl_abap_char_utilities=>newline into gv_text.
      append gv_text to gt_text.
      clear gv_text.
      clear gv_text.
      concatenate cl_abap_char_utilities=>newline gv_text into gv_text.
      concatenate cl_abap_char_utilities=>newline gv_text into gv_text.
      clear gv_text.
      gv_text = ' BLUE CROSS LABORATORIES PRIVATE LTD.'.
      append gv_text to gt_text.

****Add the email body content to document
      write pdate to wa_d1 dd/mm/yyyy.
      write mdate to wa_d2 dd/mm/yyyy.
      clear : gv_text, gv_subject.
*****      CONCATENATE 'SR-12: MONTH/PRODUCT GROUP SALES TREND(VALUE) - ZM WISE' wa_d1 'TO ' wa_d2 gv_text INTO gv_subject SEPARATED BY space.
      gv_subject = 'SR-13:MONTH-WISE PRODUCT GROUP SALE TREND - RM WISE'.
      lo_doc_bcs = cl_document_bcs=>create_document(
                     i_type    = 'RAW'
                     i_text    = gt_text[]
                     i_length  = '12'
                     i_subject = gv_subject ).   "Subject of the Email

***     Add attachment to document and Add document to send request
***The internal table gt_pdf_data[] contains the content of our attachment.
****      attachment name
      clear lv_att_sub.
      lv_att_sub = 'ZSR13'.
      call method lo_doc_bcs->add_attachment
        exporting
          i_attachment_type    = 'PDF'
          i_attachment_size    = gv_bin_filesize
          i_attachment_subject = lv_att_sub
          i_att_content_hex    = gt_pdf_data.

*     add document to send request
      call method lo_bcs->set_document( lo_doc_bcs ).

****    Set Sender
      clear lw_usr21.
      select single * from usr21 into lw_usr21 where bname = sy-uname.
      if sy-subrc = 0.
        clear lv_sender_email.
        select single smtp_addr from adr6 into lv_sender_email
          where addrnumber = lw_usr21-addrnumber
          and persnumber = lw_usr21-persnumber.
      endif.
      lo_sender = cl_cam_address_bcs=>create_internet_address( i_address_string = lv_sender_email
                                                               i_address_name = 'Sale Trend' ).

      call method lo_bcs->set_sender
        exporting
          i_sender = lo_sender.

****    Add recipient (e–mail address) from input
      clear lv_receiver_email.
      lv_receiver_email = uemail.
      lo_recep = cl_cam_address_bcs=>create_internet_address( lv_receiver_email ).

      "Add recipient with its respective attributes to send request
      call method lo_bcs->add_recipient
        exporting
          i_recipient = lo_recep
          i_express   = 'X'.

****    Set Send Immediately
      call method lo_bcs->set_send_immediately
        exporting
          i_send_immediately = 'X'.

***Send the Email
      call method lo_bcs->send(
        exporting
          i_with_error_screen = 'X'
        receiving
          result              = gv_sent_to_all ).

      if gv_sent_to_all is not initial.
        commit work.
      endif.

    catch cx_bcs into lo_cx_bcx.
      "Appropriate Exception Handling
      write: 'Exception:', lo_cx_bcx->error_type.
  endtry.
endform.
