*&---------------------------------------------------------------------*
*& Report  ZSR1_1
*&developed by Jyotsna.
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

report  zsr1_16 no standard page heading line-size 500.
tables : zbudget_tab1,
         zsales_tab1,
         zcredit_tab1,
         zdebit_tab1,
         vbrk,
         vbrp,
         makt,
         mvke,
         tvm5t,
         mara,
         t023,
         tvm4t,
         t247,
         t023t,
         zprdgroup,
         zexpestsale.
*         zprdgroup.

type-pools:  slis.

data: g_repid     like sy-repid,
      fieldcat    type slis_t_fieldcat_alv,
      wa_fieldcat like line of fieldcat,
      sort        type slis_t_sortinfo_alv,
      wa_sort     like line of sort,
      layout      type slis_layout_alv.

data : it_zsales_tab1  type table of zsales_tab1,
       wa_zsales_tab1  type zsales_tab1,
       it_zbudget_tab1 type table of zbudget_tab1,
       wa_zbudget_tab1 type zbudget_tab1,
       it_zsales_tab2  type table of zsales_tab1,
       wa_zsales_tab2  type zsales_tab1,
       it_zsales_tab3  type table of zsales_tab1,
       wa_zsales_tab3  type zsales_tab1,
       it_zbudget_tab2 type table of zbudget_tab1,
       wa_zbudget_tab2 type zbudget_tab1,
       it_zcredit_tab1 type table of zcredit_tab1,
       wa_zcredit_tab1 type zcredit_tab1,
       it_zdebit_tab1  type table of zdebit_tab1,
       wa_zdebit_tab1  type zdebit_tab1,
       it_zcredit_tab2 type table of zcredit_tab1,
       wa_zcredit_tab2 type zcredit_tab1,
       it_zdebit_tab2  type table of zdebit_tab1,
       wa_zdebit_tab2  type zdebit_tab1,
       it_zcredit_tab3 type table of zcredit_tab1,
       wa_zcredit_tab3 type zcredit_tab1,
       it_zdebit_tab3  type table of zdebit_tab1,
       wa_zdebit_tab3  type zdebit_tab1,
       it_mvke         type table of mvke,
       wa_mvke         type mvke,
       it_mvke1        type table of mvke,
       wa_mvke1        type mvke.


types : begin of itab1,
          matnr type vbrp-matnr,
          pts   type p,
          qty   type p,
          f_qty type p,
          mvgr4 type mvke-mvgr4,
          mvgr5 type mvke-mvgr5,
        end of itab1.

types : begin of itab999,
          mvgr4 type mvke-mvgr4,
          mvgr5 type mvke-mvgr5,
        end of itab999.


types : begin of litab1,

          pts   type p,
          qty   type p,
          matnr type vbrp-matnr,
        end of litab1.

types : begin of itab4,
          matnr  type vbrp-matnr,
          s_pts  type p,
          s_qty  type p,
          b_pts  type p,
          b_qty  type p,
          cs_pts type p,
          cs_qty type p,
          cb_pts type p,
          cb_qty type p,
        end of itab4.

types : begin of lcitab4,
          matnr    type vbrp-matnr,
          s_pts    type p,
          s_qty    type p,
          f_qty    type p,
          c_pts    type p,
          c_qty    type p,
          d_pts    type p,
          d_qty    type p,
          net_sale type p,
          net_qty  type p,
          mvgr4    type mvke-mvgr4,
          bezei    type tvm5t-bezei,

        end of lcitab4.

types : begin of itab5,
          matnr   type vbrp-matnr,
          s_pts   type p,
          s_qty   type p,
          b_pts   type p,
          b_qty   type p,
          cs_pts  type p,
          cs_qty  type p,
          lcs_pts type p,
          lcs_qty type p,
          cb_pts  type p,
          cb_qty  type p,
          maktx   type makt-maktx,
          bezei   type tvm5t-bezei,
          matkl   type mara-matkl,
          spart   type mara-spart,
          ach1    type p,
          ach2    type p,
          grq     type p,
          grv     type p,
          mvgr4   type mvke-mvgr4,

        end of itab5.


types : begin of itab6,
*  matnr TYPE vbrp-matnr,
          s_pts    type p,
          s_qty    type p,
          b_pts    type p,
          b_qty    type p,
          cs_pts   type p,
          cs_qty   type p,
          lcs_pts  type p,
          lcs_qty  type p,
          cb_pts   type p,
          cb_qty   type p,
*  MAKTX TYPE MAKT-MAKTX,
          bezei    type tvm5t-bezei,
          matkl    type mara-matkl,
          spart    type mara-spart,
          ach1     type p,
          ach2     type p,
          grq      type p,
          grv      type p,
          mvgr4    type mvke-mvgr4,
          matnr    type mara-matnr,
          grp_code type zprdgroup-grp_code,
          prn_seq  type  int4,
        end of itab6.


types : begin of itab7,
          matnr    type vbrp-matnr,
          s_pts    type p,
          s_qty    type p,
          b_pts    type p,
          b_qty    type p,
          cs_pts   type p,
          cs_qty   type p,
          lcs_pts  type p,
          lcs_qty  type p,
          cb_pts   type p,
          cb_qty   type p,
          maktx    type makt-maktx,
          bezei    type tvm5t-bezei,
          matkl    type mara-matkl,
          spart    type mara-spart,
          ach1     type p,
          ach2     type p,
          grq      type p,
          grv      type p,
          mvgr4    type mvke-mvgr4,
          begru    type t023-begru,
          grp_code type zprdgroup-grp_code,
          prn_seq  type  int4,
        end of itab7.

types : begin of itab8,
          spart    type mara-spart,
          prn_seq  type int4,
          grp_code type  zprdgroup-grp_code,
          matnr    type vbrp-matnr,
          s_pts    type p,
          s_qty    type p,
          b_pts    type p,
          b_qty    type p,
          cs_pts   type p,
          cs_qty   type p,
          lcs_pts  type p,
          lcs_qty  type p,
          cb_pts   type p,
          cb_qty   type p,
          maktx    type makt-maktx,
          bezei    type tvm5t-bezei,
          matkl    type mara-matkl,

          ach1     type p,
          ach2     type p,
          grq      type p,
          grv      type p,
          mvgr4    type mvke-mvgr4,
          begru    type t023-begru,
          wgbez    type t023t-wgbez,

        end of itab8.

types : begin of itab3,
          matnr type vbrp-matnr,
        end of itab3.

types : begin of dtab1,
          mnet type p,
        end of dtab1.

types : begin of btab1,
          net type p,
        end of btab1.
types : begin of it,
          matnr type vbrp-matnr,
        end of it.

data : it_tab999 type table of itab999,
       wa_tab999 type itab999.
data : it_tab1   type table of itab1,
       wa_tab1   type itab1,
       it_tab2   type table of itab1,
       wa_tab2   type itab1,
       it_ctab1  type table of itab1,
       wa_ctab1  type itab1,
       it_ta     type table of it,
       wa_ta     type it,
       it_lctab1 type table of itab1,
       wa_lctab1 type itab1,
       it_lctab2 type table of itab1,
       wa_lctab2 type itab1,
       it_lctab3 type table of litab1,
       wa_lctab3 type litab1,
       it_lctab4 type table of lcitab4,
       wa_lctab4 type lcitab4,
       it_lctab5 type table of lcitab4,
       wa_lctab5 type lcitab4,
       it_lctab6 type table of lcitab4,
       wa_lctab6 type lcitab4,
       it_ctab2  type table of itab1,
       wa_ctab2  type itab1,
       it_ctab3  type table of itab1,
       wa_ctab3  type itab1,
       it_ctab4  type table of itab1,
       wa_ctab4  type itab1,

       it_tab3   type table of itab3,
       wa_tab3   type itab3,
       it_tab4   type table of itab4,
       wa_tab4   type itab4,
       it_tab5   type table of itab5,
       wa_tab5   type itab5,
       it_tab6   type table of itab6,
       wa_tab6   type itab6,
       it_tab7   type table of itab7,
       wa_tab7   type itab7,
       it_tab8   type table of itab8,
       wa_tab8   type itab8,
       it_dtab1  type table of dtab1,
       wa_dtab1  type dtab1,
       it_crtab1 type table of dtab1,
       wa_crtab1 type dtab1,
       it_dtab2  type table of dtab1,
       wa_dtab2  type dtab1,
       it_crtab2 type table of dtab1,
       wa_crtab2 type dtab1,
       it_btab1  type table of btab1,
       wa_btab1  type btab1.


types : begin of itab,
          matnr type vbrp-matnr,
        end of itab.


types : begin of itab14,
          spart    type mara-spart,
          prn_seq  type int4,
          grp_code type zprdgroup-grp_code,
          matnr    type vbrp-matnr,
          mvgr5    type mvgr5,
          b_pts    type p,
          b_qty    type p,
          s_pts    type p,
          s_qty    type p,
          f_qty    type p,
          c_pts    type p,
          c_qty    type p,
          d_pts    type p,
          d_qty    type p,
          mvgr4    type mvke-mvgr4,
          net_sale type p,
          net_qty  type p,
          bezei    type tvm4t-bezei,
          matkl    type mara-matkl,
          begru    type t023-begru,
        end of itab14.

types : begin of itab18,
          spart       type mara-spart,
          prn_seq(5)  type n,
          grp_code    type zprdgroup-grp_code,
          maktx       type makt-maktx,
          matnr       type vbrp-matnr,
          b_pts       type p,
          b_qty       type p,
          cb_pts      type p,
          cb_qty      type p,
          s_pts       type p,
          s_qty       type p,
          c_pts       type p,
          c_qty       type p,
          d_pts       type p,
          d_qty       type p,
          mvgr4       type mvke-mvgr4,
          net_sale    type p,
          net_qty     type p,
          cnet_sale   type p,
          cnet_qty    type p,
          lcnet_sale  type p,
          lcnet_qty   type p,
          bezei       type tvm4t-bezei,
          bezei1      type tvm5t-bezei,
          ach1        type p,
          ach2        type p,
          grq         type p,
          grv         type p,
*  spart type mara-spart,
          matkl       type mara-matkl,
          begru       type t023-begru,

          wgbez       type t023t-wgbez,
          grp_name    type zprdgroup-grp_name,

          cnet        type p,
          mvgr5       type mvgr5,
          kondm       type mvke-kondm,

          subgrp_code type  zprdgroup-subgrp_code,
          subgrp_name type zprdgroup-subgrp_name,
        end of itab18.

types : begin of itab118,
          mvgr4      type mvke-mvgr4,
          mvgr5      type mvgr5,
          spart      type mara-spart,
          prn_seq    type int4,
          grp_code   type zprdgroup-grp_code,
          maktx      type makt-maktx,
*matnr type vbrp-matnr,
          b_pts      type p,
          b_qty      type p,
          cb_pts     type p,
          cb_qty     type p,
          s_pts      type p,
          s_qty      type p,
          c_pts      type p,
          c_qty      type p,
          d_pts      type p,
          d_qty      type p,

          net_sale   type p,
          net_qty    type p,
          cnet_sale  type p,
          cnet_qty   type p,
          lcnet_sale type p,
          lcnet_qty  type p,
          bezei      type tvm4t-bezei,
          bezei1     type tvm5t-bezei,
          ach1       type p,
          ach2       type p,
          grq        type p,
          grv        type p,
*  spart type mara-spart,
          matkl      type mara-matkl,
          begru      type t023-begru,

          wgbez      type t023t-wgbez,
          grp_name   type zprdgroup-grp_name,
        end of itab118.

types : begin of citab5,
          matnr     type vbrp-matnr,
          b_pts     type p,
          b_qty     type p,
          s_pts     type p,
          s_qty     type p,
          f_qty     type p,
          c_pts     type p,
          c_qty     type p,
          d_pts     type p,
          d_qty     type p,
          mvgr4     type mvke-mvgr4,
          net_sale  type p,
          net_qty   type p,
          cnet_sale type p,
          cnet_qty  type p,
          bezei     type tvm4t-bezei,
        end of citab5.

types: begin of sf1,
         spart       type mara-spart,
         prn_seq(5)  type n,
         grp_code    type zprdgroup-grp_code,
         subgrp_code type  zprdgroup-subgrp_code,
         subgrp_name type zprdgroup-subgrp_name,
         maktx       type makt-maktx,
         bezei       type tvm4t-bezei,
         net_qty     type p,
         b_qty       type p,
         net_sale    type p,    "curr.sale
         b_pts       type p,
         ach1        type p,
         cnet_qty    type p,
         cb_qty      type p,
         cnet_sale   type p,    "sale YTD
         cb_pts      type p,
         ach2        type p,
         grq         type p,
         grv         type p,    "growth
         lcnet_qty   type p,
         lcnet_sale  type p,

         grp_cnt     type i,
       end of sf1.

data : it_tab    type table of itab,
       wa_tab    type itab,
       it_mat1   type table of itab,
       wa_mat1   type itab,
       it_tab11  type table of itab1,
       wa_tab11  type itab1,
       it_tab12  type table of itab1,
       wa_tab12  type itab1,
       it_tab13  type table of itab1,
       wa_tab13  type itab1,
       it_tab14  type table of itab1,
       wa_tab14  type itab1,
       it_tab15  type table of itab14,
       wa_tab15  type itab14,
       it_tab16  type table of itab14,
       wa_tab16  type itab14,
       it_tab17  type table of itab14,
       wa_tab17  type itab14,
       it_tab18  type table of itab18,
       wa_tab18  type itab18,
       it_tab183 type table of itab118,
       wa_tab183 type itab118,
       it_tab181 type table of itab18,
       wa_tab181 type itab18,
       it_tab182 type table of itab18,
       wa_tab182 type itab18,
       it_ctab5  type table of citab5,
       wa_ctab5  type citab5,
       it_ctab6  type table of citab5,
       wa_ctab6  type citab5,
       it_ctab7  type table of citab5,
       wa_ctab7  type citab5,
       it_t      type table of itab,
       wa_t      type itab,
       it_sf1    type table of sf1,
       wa_sf1    type sf1,
       it_sf2    type table of zsr2,
       wa_sf2    type zsr2.
data: count type i.
data : month(3)  type c,
       month1(8) type c.
data : year(4)  type c,
       year1(4) type c,
       m1(2)    type c,
       m2(2)    type c,
       fyear(4) type c.

data : bud_net type p.

data : grp_name(40)  type c,
       grp_name1(40) type c,
       div_name(40)  type c,
       grp_code      type zprdgroup-grp_code.

data : l_date      type sy-datum,
       c_date      type sy-datum,
       ll_date     type sy-datum,
       lc_date     type sy-datum,
       ach1        type p,
       ach2        type p,
       grq         type p,
       grv         type p,
       t_sqty      type p,
       t_bqty      type p,
       t_spts      type p,
       t_bpts      type p,
       t_csqty     type p,
       t_cbqty     type p,
       t_cspts     type p,
       t_cbpts     type p,
       t_lcspts    type p,
       t_lcsqty    type p,

       dt_sqty     type p,
       dt_bqty     type p,
       dt_spts     type p,
       dt_bpts     type p,
       dt_csqty    type p,
       dt_cbqty    type p,
       dt_cspts    type p,
       dt_cbpts    type p,
       dt_lcspts   type p,
       dt_lcsqty   type p,

       t_ach1      type p,
       t_ach2      type p,
       lgrv        type p,
       lgrq        type p,

       dt_ach1     type p,
       dt_ach2     type p,
       dlgrv       type p,
       dlgrq       type p,

       t_total     type p,
       tot_lcpts   type p,
       tot_lcqty   type p,
       lv_new_date type sy-datum.

data: ndt1 type sy-datum,
      ndt2 type sy-datum.

data :  tot_lcpts1 type p.

data : tot_sqty  type p,
       tot_bqty  type p,
       tot_spts  type p,
       tot_bpts  type p,
       tot_csqty type p,
       tot_cbqty type p,
       tot_cspts type p,
       tot_cbpts type p,
       cspts     type p.

data : tot_sqty1  type p,
       tot_bqty1  type p,
       tot_spts1  type p,
       tot_bpts1  type p,
       tot_csqty1 type p,
       tot_cbqty1 type p,
       tot_cspts1 type p,
       tot_cbpts1 type p,
       cspts1     type p.

data : tot_ach1 type p,
       tot_ach2 type p,
       tot_gr1  type p,
       tot_gr2  type p,
       t1       type p,
       t2       type p.

data : b1 type p,
       b2 type p,
       d1 type p,
       d2 type p,
       c1 type p,
       c2 type p,
       a1 type p,
       a2 type p,
       a3 type p,
       a4 type p.

data : pts        type p,
       net_sale   type p,
       net_qty    type p,
       cnet_sale  type p,
       cnet_qty   type p,
       lcnet_sale type p,
       lcnet_qty  type p,
       oth_grp_45 type zprdgroup-grp_name,
       oth_grp    type zprdgroup-grp_name,
       oth_grp_53 type zprdgroup-grp_name.
data : d11 type sy-datum,
       d12 type sy-datum,
       tot type p.
data: nlem(5) type c.
data: cumqty type p.
data: sft1net_qty    type p,
      sft1b_qty      type p,
      sft1net_sale   type p,
      sft1b_pts      type p,
      sft1ach1       type p,
      sft1cnet_qty   type p,
      sft1cb_qty     type p,
      sft1cnet_sale  type p,
      sft1cb_pts     type p,
      sft1ach2       type p,
      sft1grq        type p,
      sft1grv        type p,
      sft1lcnet_qty  type p,
      sft1lcnet_sale type p.

data: dsft1net_qty    type p,
      dsft1b_qty      type p,
      dsft1net_sale   type p,
      dsft1b_pts      type p,
      dsft1ach1       type p,
      dsft1cnet_qty   type p,
      dsft1cb_qty     type p,
      dsft1cnet_sale  type p,
      dsft1cb_pts     type p,
      dsft1ach2       type p,
      dsft1grq        type p,
      dsft1grv        type p,
      dsft1lcnet_qty  type p,
      dsft1lcnet_sale type p.

data: tdsft1net_qty    type p,
      tdsft1b_qty      type p,
      tdsft1net_sale   type p,
      tdsft1b_pts      type p,
      tdsft1ach1       type p,
      tdsft1cnet_qty   type p,
      tdsft1cb_qty     type p,
      tdsft1cnet_sale  type p,
      tdsft1cb_pts     type p,
      tdsft1ach2       type p,
      tdsft1grq        type p,
      tdsft1grv        type p,
      tdsft1lcnet_qty  type p,
      tdsft1lcnet_sale type p.

data: ngrq(10) type c,
      ngrv(10) type c.
data: headtxt1(100) type c.
data: typ1(2) type c.
data: typ2(1) type c.
data:
  gnet_qty    type p,
  gb_qty      type p,
  gnet_sale   type p,
  gb_pts      type p,
  gach1       type p,
  gcnet_qty   type p,
  glcnet_qty  type p,
  gcb_qty     type p,
  gcnet_sale  type p,
  glcnet_sale type p,
  gcb_pts     type p.
*select-options : s_budat for vbrk-fkdat.
*************************************************************************************

data : w_return    type ssfcrescl.
data: i_otf       type itcoo    occurs 0 with header line,
      i_tline     like tline    occurs 0 with header line,
      i_record    like solisti1 occurs 0 with header line,
      i_xstring   type xstring,
* Objects to send mail.
      i_objpack   like sopcklsti1 occurs 0 with header line,
      i_objtxt    like solisti1   occurs 0 with header line,
      i_objbin    like solix      occurs 0 with header line,
      i_reclist   like somlreci1  occurs 0 with header line,
* Work Area declarations
      wa_objhead  type soli_tab,
      w_ctrlop    type ssfctrlop,
      w_compop    type ssfcompop,
*      w_return    TYPE ssfcrescl,
      wa_buffer   type string,
* Variables declarations
      v_form_name type rs38l_fnam,
      v_len_in    like sood-objlen.
data: in_mailid type ad_smtpadr.
data:  lmyr(4)     type c.
data: mm(2)       type c,
      myr(4)      type c,
      efyear(4)   type c,
      efyear1(4)  type c,
      lefyear(4)  type c,
      lefyear1(4) type c.
data: expestsale(1) type c.
data: expdt1 type sy-datum,
      expdt2 type sy-datum.

types: begin of exp1,
         qty   type p,
         val   type p decimals 2,
         bqty  type p,
         bval  type p decimals 2,
         ybqty type p,
         ybval type p decimals 2,
         yqty  type p,
         yval  type p decimals 2,
         lyqty type p,
         lyval type p decimals 2,
       end of exp1.

types: begin of exp2,
         qty   type p,
         val   type p,
         bqty  type p,
         bval  type p,
         ach1  type p,
         ybqty type p,
         ybval type p,
         yqty  type p,
         yval  type p,
         lyqty type p,
         lyval type p,
         ach2  type p,
       end of exp2.

data: exp2qty   type p,
      exp2val   type p,
      exp2bqty  type p,
      exp2bval  type p,
      exp2ach1  type p,
      exp2ybqty type p,
      exp2ybval type p,
      exp2yqty  type p,
      exp2yval  type p,
      exp2ach2  type p,
      exp2lyqty type p,
      exp2lyval type p.

data: it_exp1 type table of exp1,
      wa_exp1 type exp1,
      it_exp2 type table of exp2,
      wa_exp2 type exp2.
data: expach1 type p .
data: ybqty1   type p,
      ybval1   type p decimals 2,
      ybqty2   type p,
      ybval2   type p decimals 2,
      ybqty    type p,
      ybval    type p decimals 2,

      lybqty1  type p,
      lybval1  type p decimals 2,
      lybqty2  type p,
      lybval2  type p decimals 2,
      lybqty   type p,
      lybval   type p decimals 2,

      expybqty type p,
      expybval type p,
      expyqty  type p,
      expyval  type p,
      explyqty type p,
      explyval type p,

      yqty1    type p,
      yval1    type p decimals 2,
      yqty2    type p,
      yval2    type p decimals 2,
      yqty     type p,
      yval     type p decimals 2.

data: it_zexpdata type table of zexpdata,
      wa_zexpdata type zexpdata.
data: it_zexpbudget type table of zexpbudget,
      wa_zexpbudget type zexpbudget.
data: from_dt type sy-datum,
      to_dt   type sy-datum.
******************************************************
types:
  t_document_data type  sodocchgi1,
  t_packing_list  type  sopcklsti1,
  t_attachment    type  solisti1,
  t_body_msg      type  solisti1,
  t_receivers     type  somlreci1.

data : w_attachment  type  t_attachment,
       w_attachment1 type  t_attachment,
       w_body_msg    type  t_body_msg,
       w_receivers   type  t_receivers.

data : g_sent_to_all      type sonv-flag,
       g_tab_lines        type i,
       g_attachment_lines type i.

data : w_document_data type  t_document_data,
       w_packing_list  type  t_packing_list,
       i_body_msg      type standard table of t_body_msg,
       i_document_data type standard table of t_document_data,
       i_packing_list  type standard table of t_packing_list,
       i_attachment    type standard table of t_attachment,
       i_receivers     type standard table of t_receivers.
constants: con_tab     type c value cl_abap_char_utilities=>horizontal_tab,
           con_cret(2) type c value cl_abap_char_utilities=>cr_lf.
*************************************************************************************

selection-screen begin of block merkmale1 with frame title text-001.
*parameter : from_dt type sy-datum,
*            to_dt type sy-datum.

parameter : dmon(2) type c,
            dyear(4) type c.
parameters : net   radiobutton group r2,
             gross radiobutton group r2.
selection-screen end of block merkmale1.

selection-screen begin of block merkmale2 with frame title text-001.

parameters : r10 radiobutton group r1,
*             r13 radiobutton group r1,
             r11 radiobutton group r1,
             r14 radiobutton group r1,
*             r1  radiobutton group r1,
*             r2  radiobutton group r1,
*             r21 radiobutton group r1,
*             r8  radiobutton group r1,
*             r5  radiobutton group r1,
*             r9  radiobutton group r1,
*             r12 radiobutton group r1,
*             r6  radiobutton group r1,
             r7  radiobutton group r1,
             r15 radiobutton group r1,
             r16 radiobutton group r1.

*             r3 radiobutton group r1,
*             r4 radiobutton group r1,
parameter : email(70) type c.
*parameter : z1 as checkbox.
*parameter : g1 as checkbox.
selection-screen end of block merkmale2.


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
data : wa_d1(10) type c,
       wa_d2(10) type c.
data : usrid_long like pa0105-usrid_long.
data : w_usrid_long type pa0105-usrid_long.
data righe_attachment type i.
data righe_testo type i.
data tab_lines type i.
data : r3(1) type c,
       r4(1) type c.

data  begin of objpack occurs 0 .
        include structure  sopcklsti1.
data end of objpack.

data begin of objtxt occurs 0.
        include structure solisti1.
data end of objtxt.
data: v_msg(125) type c.
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

data : v_fm type rs38l_fnam.
data : format(10) type c.

initialization.
  g_repid = sy-repid.

at selection-screen.

*  if from_dt+6(2) ne '01'.
*    message 'ENTER START DATE OF MONTH' type 'E'.
*  endif.
*  call function 'RP_LAST_DAY_OF_MONTHS'
*    exporting
*      day_in            = from_dt
*    importing
*      last_day_of_month = TO_DT.
*
*  if to_dt ne l_date.
*    message 'ENTER END DATE OF THE MONTH' type 'E'.
*  endif.


  if r7 eq 'X' or r15 eq 'X'.
    if email eq '                                                                     '.
      message 'ENTER EMAIL ID' type 'E'.
    endif.
  endif.

at selection-screen output.
  d11 = sy-datum.
  d11+6(2) = 01.

*  from_dt = d11.

  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date           = d11
    importing
*     EV_MONTH_BEGIN_DATE       =
      ev_month_end_date = d12.

*  to_dt = d12.



start-of-selection.

  from_dt+6(2) = '01'.
  from_dt+4(2) = dmon.
  from_dt+0(4) = dyear.

  call function 'RP_LAST_DAY_OF_MONTHS'
    exporting
      day_in            = from_dt
    importing
      last_day_of_month = to_dt.

*  call function 'HR_JP_MONTH_BEGIN_END_DATE'
*    exporting
*      iv_date           = from_dt
*    importing
**     EV_MONTH_BEGIN_DATE       =
*      ev_month_end_date = to_dt.

*  write : / 'date', from_dt,to_dt.

  select single * from t247 where spras eq 'EN' and mnr eq from_dt+4(2).
  if sy-subrc eq 0.
*    write : t247-ktx.
    month = t247-ktx.
    concatenate month '.' from_dt+0(4) into month1.
  endif.

  if r14 eq 'X'.
    typ1 = 'LY'.
  endif.

**  if r1 eq 'X' or r21 eq 'X' or r6 eq 'X'.
**  if r1 eq 'X' or r6 eq 'X'.
*  if r6 eq 'X'.
*    perform gross_form.
***  elseif r2 eq 'X'.
***    perform gross_alv.
****  elseif r3 eq 'X' or r8 eq 'X' or r9 eq 'X'  or r10 eq 'X' or r13 eq 'X' or r12 = 'X' or r7 eq 'X'.
*  else
  if r10 eq 'X' or r14 eq 'X' or r16 eq 'X'.
    if net eq 'X'.
      perform net_form.
    elseif gross eq 'X'.
      perform gross_form.
    endif.

  elseif r3 eq 'X'.
    perform net_form.
  elseif r7 eq 'X' or r15 eq 'X'.
    if net eq 'X'.
      perform net_form.
    elseif gross eq 'X'.
      perform gross_form.
    endif.
  elseif r4 eq 'X' .
    perform net_alv.
  elseif r11 eq 'X'.
    if net eq 'X'.
      perform net_alv.
    elseif gross eq 'X'.
      perform gross_alv.
    endif.
*  elseif r5 eq 'X'.
*    perform dis_net_alv.
*  elseif r6 eq 'X'.
*    perform gross_mail.
*  ELSEIF R7 EQ 'X'.
*    PERFORM NET_EMAIL.
  endif.


*&---------------------------------------------------------------------*
*&      Form  GROSS_MAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form gross_mail.

  select * from zsales_tab1 into table it_zsales_tab1 where datab ge from_dt and datbi le to_dt.
*  select * from zcredit_tab1 into table it_zcredit_tab1 where datab ge from_dt and datbi le to_dt.
*  select * from zdebit_tab1 into table it_zdebit_tab1 where datab ge from_dt and datbi le to_dt.
  select * from zbudget_tab1 into table it_zbudget_tab1 where datab ge from_dt and datbi le to_dt and tag eq 'G'.

  loop at it_zsales_tab1 into wa_zsales_tab1.

    pts = wa_zsales_tab1-net + wa_zsales_tab1-ed.
    wa_tab11-matnr = wa_zsales_tab1-matnr.
    wa_tab11-pts = pts.
    wa_tab11-qty = wa_zsales_tab1-c_qty.
*    WA_TAB11-MVGR5 = WA_ZSALES_TAB1-MVGR5.  "29.11.20
    select single * from mvke where matnr eq wa_zsales_tab1-matnr and vkorg eq '1000' and vtweg eq '10'.
    if sy-subrc eq 0.
      wa_tab11-mvgr5 = mvke-mvgr5.
    endif.

    wa_tab-matnr = wa_zsales_tab1-matnr.
    collect wa_tab into it_tab.
    clear wa_tab.
    collect wa_tab11 into it_tab11.
    clear wa_tab11.
    clear pts.
  endloop.

*LOOP AT IT_TAB1 INTO WA_TAB1.
*  WRITE : /'SALE', WA_TAB1-MATNR,WA_TAB1-PTS,WA_TAB1-ED,WA_TAB1-C_QTY,WA_TAB1-F_QTY.
*ENDLOOP.

  loop at it_zcredit_tab1 into wa_zcredit_tab1.
    wa_tab12-matnr = wa_zcredit_tab1-matnr.
    wa_tab12-pts = wa_zcredit_tab1-net.
    wa_tab12-qty = wa_zcredit_tab1-qty_c.
    wa_tab-matnr = wa_zcredit_tab1-matnr.
    collect wa_tab into it_tab.
    clear wa_tab.
    collect wa_tab12 into it_tab12.
    clear wa_tab12.
  endloop.


  loop at it_zdebit_tab1 into wa_zdebit_tab1.
    wa_tab13-matnr = wa_zdebit_tab1-matnr.
    wa_tab13-pts = wa_zdebit_tab1-net.
    wa_tab13-qty = wa_zdebit_tab1-qty_c.
    wa_tab-matnr = wa_zdebit_tab1-matnr.
    collect wa_tab into it_tab.
    clear wa_tab.
    collect wa_tab13 into it_tab13.
    clear wa_tab13.

  endloop.

  loop at it_zbudget_tab1 into wa_zbudget_tab1.
    wa_tab14-matnr = wa_zbudget_tab1-matnr.
    wa_tab14-pts = wa_zbudget_tab1-val.
    wa_tab14-qty = wa_zbudget_tab1-qty.
    wa_tab-matnr = wa_zbudget_tab1-matnr.
    collect wa_tab into it_tab.
    clear wa_tab.
    collect wa_tab14 into it_tab14.
    clear wa_tab14.
  endloop.

  loop at it_tab into wa_tab.
    read table it_tab11 into wa_tab11 with key matnr = wa_tab-matnr.  "sale
    if sy-subrc eq 0.
      wa_tab15-matnr = wa_tab11-matnr.
      wa_tab15-s_pts = wa_tab11-pts.
      wa_tab15-s_qty = wa_tab11-qty.
    endif.
    read table it_tab12 into wa_tab12 with key matnr = wa_tab-matnr.  "cn
    if sy-subrc eq 0.
      wa_tab15-matnr = wa_tab12-matnr.
      wa_tab15-c_pts = wa_tab12-pts.
      wa_tab15-c_qty = wa_tab12-qty.
    endif.
    read table it_tab13 into wa_tab13 with key matnr = wa_tab-matnr.  "dn
    if sy-subrc eq 0.
      wa_tab15-matnr = wa_tab13-matnr.
      wa_tab15-d_pts = wa_tab13-pts.
      wa_tab15-d_qty = wa_tab13-qty.
    endif.
    read table it_tab14 into wa_tab14 with key matnr = wa_tab-matnr.  "budget
    if sy-subrc eq 0.
      wa_tab15-matnr = wa_tab14-matnr.
      wa_tab15-b_pts = wa_tab14-pts.
      wa_tab15-b_qty = wa_tab14-qty.
    endif.
    collect wa_tab15 into it_tab15.
    clear wa_tab15.
  endloop.

  loop at it_tab15 into wa_tab15.
    clear : net_sale,net_qty.
*    WRITE : / 'a',wa_TAB15-matnr,WA_TAB15-B_PTS,WA_TAB15-B_QTY,wa_TAB15-s_pts,wa_TAB15-s_qty,wa_TAB15-c_pts,wa_TAB15-c_qty,wa_TAB15-d_pts,
*    wa_TAB15-d_qty.
    net_sale = wa_tab15-s_pts - wa_tab15-c_pts + wa_tab15-d_pts.
    net_qty = wa_tab15-s_qty - wa_tab15-c_qty + wa_tab15-d_qty.
    wa_tab16-matnr = wa_tab15-matnr.
    wa_tab16-b_pts = wa_tab15-b_pts.
    wa_tab16-b_qty = wa_tab15-b_qty.
    wa_tab16-s_pts = wa_tab15-s_pts.
    wa_tab16-s_qty = wa_tab15-s_qty.
    wa_tab16-c_pts = wa_tab15-c_pts.
    wa_tab16-c_qty = wa_tab15-c_qty.
    wa_tab16-d_pts = wa_tab15-d_pts.
    wa_tab16-d_qty = wa_tab15-d_qty.
    wa_tab16-net_sale = net_sale.
    wa_tab16-net_qty = net_qty.
    collect wa_tab16 into it_tab16.
    clear wa_tab16.
  endloop.

  loop at it_tab16 into wa_tab16.
    wa_tab17-matnr = wa_tab16-matnr.
    wa_tab17-b_pts = wa_tab16-b_pts.
    wa_tab17-b_qty = wa_tab16-b_qty.
    wa_tab17-s_pts = wa_tab16-s_pts.
    wa_tab17-s_qty = wa_tab16-s_qty.
    wa_tab17-c_pts = wa_tab16-c_pts.
    wa_tab17-c_qty = wa_tab16-c_qty.
    wa_tab17-d_pts = wa_tab16-d_pts.
    wa_tab17-d_qty = wa_tab16-d_qty.
    wa_tab17-net_sale = wa_tab16-net_sale.
    wa_tab17-net_qty = wa_tab16-net_qty.
    collect wa_tab17 into it_tab17.
    clear wa_tab17.
  endloop.


***************CURRENT MOTH SALE ENDS HERE **********************

*************CUMMULATIVE SALE STARTS HERE***************************
  c_date+6(2) = '01'.
  c_date+4(2) = '04'.

  if from_dt+4(2) lt '04'.
    c_date+0(4) = from_dt+0(4) - 1.
  else.
    c_date+0(4) = from_dt+0(4).
  endif.
*  write : / 'cummulative date',c_date.

  select * from zsales_tab1 into table it_zsales_tab2 where datab ge c_date and datbi le to_dt.
  if it_zsales_tab2 is not initial.
    loop at it_zsales_tab2 into wa_zsales_tab2.
      wa_ctab1-matnr = wa_zsales_tab2-matnr.
      wa_ctab1-pts = wa_zsales_tab2-net + wa_zsales_tab2-ed.
      wa_ctab1-qty = wa_zsales_tab2-c_qty.
      collect wa_ctab1 into it_ctab1.
      clear wa_ctab1.
      wa_ta-matnr = wa_zsales_tab2-matnr.
      collect wa_ta into it_ta.
      clear wa_ta.
    endloop.
  endif.

*  select * from zcredit_tab1 into table it_zcredit_tab2 where datab ge c_date and datbi le to_dt.
  if it_zcredit_tab2 is not initial.
    loop at it_zcredit_tab2 into wa_zcredit_tab2.
      wa_ctab2-matnr = wa_zcredit_tab2-matnr.
      wa_ctab2-pts = wa_zcredit_tab2-net.
      wa_ctab2-qty = wa_zcredit_tab2-qty_c.
      collect wa_ctab2 into it_ctab2.
      clear wa_ctab2.
      wa_ta-matnr = wa_zcredit_tab2-matnr.
      collect wa_ta into it_ta.
      clear wa_ta.
    endloop.
  endif.

*  select * from zdebit_tab1 into table it_zdebit_tab2 where datab ge c_date and datbi le to_dt.
  if it_zdebit_tab2 is not initial.
    loop at it_zdebit_tab2 into wa_zdebit_tab2.
      wa_ctab3-matnr = wa_zdebit_tab2-matnr.
      wa_ctab3-pts = wa_zdebit_tab2-net.
      wa_ctab3-qty = wa_zdebit_tab2-qty_c.
      collect wa_ctab3 into it_ctab3.
      clear wa_ctab3.
      wa_ta-matnr = wa_zdebit_tab2-matnr.
      collect wa_ta into it_ta.
      clear wa_ta.
    endloop.
  endif.

  select * from zbudget_tab1 into table it_zbudget_tab2 where datab ge c_date and datbi le to_dt and tag eq 'G'.
  if it_zbudget_tab2 is not initial.
    loop at it_zbudget_tab2 into wa_zbudget_tab2.
*      WRITE : / 'budget',c_date,TO_DT,wa_zBUDGET_tab2-matnr,wa_zBUDGET_tab2-qty.
      wa_ctab4-matnr = wa_zbudget_tab2-matnr.
      wa_ctab4-pts = wa_zbudget_tab2-val.
      wa_ctab4-qty = wa_zbudget_tab2-qty.
      collect wa_ctab4 into it_ctab4.
      clear wa_ctab4.
      wa_ta-matnr = wa_zbudget_tab2-matnr.
      collect wa_ta into it_ta.
      clear wa_ta.
    endloop.
  endif.

  sort it_ta.
  delete adjacent duplicates from it_ta.

  loop at it_ta into wa_ta.
    read table it_ctab1 into wa_ctab1 with key matnr = wa_ta-matnr.
    if sy-subrc eq 0.
      wa_ctab5-matnr = wa_ctab1-matnr.
      wa_ctab5-s_pts = wa_ctab1-pts.
      wa_ctab5-s_qty = wa_ctab1-qty.
    endif.
    read table it_ctab2 into wa_ctab2 with key matnr = wa_ta-matnr.
    if sy-subrc eq 0.
      wa_ctab5-matnr = wa_ctab2-matnr.
      wa_ctab5-c_pts = wa_ctab2-pts.
      wa_ctab5-c_qty = wa_ctab2-qty.
    endif.
    read table it_ctab3 into wa_ctab3 with key matnr = wa_ta-matnr.
    if sy-subrc eq 0.
      wa_ctab5-matnr = wa_ctab3-matnr.
      wa_ctab5-d_pts = wa_ctab3-pts.
      wa_ctab5-d_qty = wa_ctab3-qty.
    endif.
    read table it_ctab4 into wa_ctab4 with key matnr = wa_ta-matnr.
    if sy-subrc eq 0.
      wa_ctab5-matnr = wa_ctab4-matnr.
      wa_ctab5-b_pts = wa_ctab4-pts.
      wa_ctab5-b_qty = wa_ctab4-qty.
    endif.
    collect wa_ctab5 into it_ctab5.
    clear wa_ctab5.
  endloop.

  loop at it_ctab5 into wa_ctab5.
    clear : cnet_sale,cnet_qty.
    wa_ctab6-matnr = wa_ctab5-matnr.
    wa_ctab6-s_pts = wa_ctab5-s_pts.
    wa_ctab6-s_qty = wa_ctab5-s_qty.
    wa_ctab6-c_pts = wa_ctab5-c_pts.
    wa_ctab6-c_qty = wa_ctab5-c_qty.
    wa_ctab6-d_pts = wa_ctab5-d_pts.
    wa_ctab6-d_qty = wa_ctab5-d_qty.
    wa_ctab6-b_pts = wa_ctab5-b_pts.
    wa_ctab6-b_qty = wa_ctab5-b_qty.
    cnet_sale = wa_ctab5-s_pts - wa_ctab5-c_pts + wa_ctab5-d_pts.
    cnet_qty = wa_ctab5-s_qty - wa_ctab5-c_qty + wa_ctab5-d_qty.
    wa_ctab6-net_sale = cnet_sale.
    wa_ctab6-net_qty = cnet_qty.
    collect wa_ctab6 into it_ctab6.
    clear wa_ctab6.
  endloop.
  sort it_ctab6 by bezei.

  loop at it_ctab6 into wa_ctab6.
    wa_ctab7-matnr = wa_ctab6-matnr.
    wa_ctab7-s_pts = wa_ctab6-s_pts.
    wa_ctab7-s_qty = wa_ctab6-s_qty.
    wa_ctab7-c_pts = wa_ctab6-c_pts.
    wa_ctab7-c_qty = wa_ctab6-c_qty.
    wa_ctab7-d_pts = wa_ctab6-d_pts.
    wa_ctab7-d_qty = wa_ctab6-d_qty.
    wa_ctab7-b_pts = wa_ctab6-b_pts.
    wa_ctab7-b_qty = wa_ctab6-b_qty.
    wa_ctab7-net_sale = wa_ctab6-net_sale.
    wa_ctab7-net_qty = wa_ctab6-net_qty.
    collect wa_ctab7 into it_ctab7.
    clear wa_ctab7.
  endloop.

*  LOOP AT IT_CTAB7 INTO WA_CTAB7.
*    WRITE : /'a1',wa_tab7-mvgr4,wa_ctab7-bezei,'net',wa_ctab7-net_qty,'sale',WA_CTAB7-S_QTY,'credit',wa_ctab7-c_qty,'debit',wa_ctab7-d_qty,'bud',wa_ctab7-b_qty,wa_ctab7-net_sale,wa_ctab7-b_pts.
*  ENDLOOP.

**************CUMMULATIVE DATA ENDS HERE********************

******************LAST YEAR CUMMULATIVE DATA STARTS*****************

  ll_date = c_date.
  ll_date+0(4) = c_date+0(4) - 1.
  lc_date = to_dt.
  lc_date+0(4) = to_dt+0(4) - 1.
*  write : / 'last fiscal year',ll_date,'last year same date',lc_date.
*  ******************************************************
  clear : ndt1,ndt2.
  ndt1 = lc_date.
  ndt1+6(2) = '01'.
  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date           = ndt1
    importing
*     EV_MONTH_BEGIN_DATE       =
      ev_month_end_date = ndt2.
  lc_date = ndt2.
*************************************************************************

*  WRITE : / 'date',lc_date.
  if lc_date = '20160228'.
    lc_date = '20160229'.
*  ELSEIF LC_DATE = '20200228'.
*    LC_DATE = '20200229'.
  endif.
*WRITE : / 'date',lc_date.


  select * from zsales_tab1 into table it_zsales_tab3 where datab ge ll_date and datbi le lc_date.
  if it_zsales_tab3 is not initial.
    loop at it_zsales_tab3 into wa_zsales_tab3.
      wa_lctab1-matnr = wa_zsales_tab3-matnr.
      wa_lctab1-pts = wa_zsales_tab3-net + wa_zsales_tab3-ed.
      wa_lctab1-qty = wa_zsales_tab3-c_qty.
      collect wa_lctab1 into it_lctab1.
      clear wa_lctab1.
      wa_t-matnr = wa_zsales_tab3-matnr.
      collect wa_t into it_t.
      clear wa_t.
    endloop.
  endif.

*  select * from zcredit_tab1 into table it_zcredit_tab3 where datab ge ll_date and datbi le lc_date.
  if it_zcredit_tab3 is not initial.
    loop at it_zcredit_tab3 into wa_zcredit_tab3.
      wa_lctab2-matnr = wa_zcredit_tab3-matnr.
      wa_lctab2-pts = wa_zcredit_tab3-net.
      wa_lctab2-qty = wa_zcredit_tab3-qty_c.
      collect wa_lctab2 into it_lctab2.
      clear wa_lctab2.
      wa_t-matnr = wa_zcredit_tab3-matnr.
      collect wa_t into it_t.
      clear wa_t.
    endloop.
  endif.

*  select * from zdebit_tab1 into table it_zdebit_tab3 where datab ge ll_date and datbi le lc_date.
  if it_zdebit_tab3 is not initial.
    loop at it_zdebit_tab3 into wa_zdebit_tab3.
      wa_lctab3-matnr = wa_zdebit_tab3-matnr.
      wa_lctab3-pts = wa_zdebit_tab3-net.
      wa_lctab3-qty = wa_zdebit_tab3-qty_c.
      collect wa_lctab3 into it_lctab3.
      clear wa_lctab3.
      wa_t-matnr = wa_zdebit_tab3-matnr.
      collect wa_t into it_t.
      clear wa_t.
    endloop.
  endif.


  loop at it_t into wa_t.
    read table it_lctab1 into wa_lctab1 with key matnr = wa_t-matnr.
    if sy-subrc eq 0.
      wa_lctab4-matnr = wa_lctab1-matnr.
      wa_lctab4-s_pts = wa_lctab1-pts.
      wa_lctab4-s_qty = wa_lctab1-qty.
    endif.
    read table it_lctab2 into wa_lctab2 with key matnr = wa_t-matnr.
    if sy-subrc eq 0.
      wa_lctab4-matnr = wa_lctab2-matnr.
      wa_lctab4-c_pts = wa_lctab2-pts.
      wa_lctab4-c_qty = wa_lctab2-qty.
    endif.
    read table it_lctab3 into wa_lctab3 with key matnr = wa_t-matnr.
    if sy-subrc eq 0.
      wa_lctab4-matnr = wa_lctab3-matnr.
      wa_lctab4-d_pts = wa_lctab3-pts.
      wa_lctab4-d_qty = wa_lctab3-qty.
    endif.
    collect wa_lctab4 into it_lctab4.
    clear wa_lctab4.
  endloop.

  loop at it_lctab4 into wa_lctab4.
    clear : lcnet_sale,lcnet_qty.
    wa_lctab5-matnr = wa_lctab4-matnr.
    wa_lctab5-s_pts = wa_lctab4-s_pts.
    wa_lctab5-s_qty = wa_lctab4-s_qty.
    wa_lctab5-c_pts = wa_lctab4-c_pts.
    wa_lctab5-c_qty = wa_lctab4-c_qty.
    wa_lctab5-d_pts = wa_lctab4-d_pts.
    wa_lctab5-d_qty = wa_lctab4-d_qty.
    lcnet_sale = wa_lctab4-s_pts - wa_lctab4-c_pts + wa_lctab4-d_pts.
    lcnet_qty = wa_lctab4-s_qty - wa_lctab4-c_qty + wa_lctab4-d_qty.
    wa_lctab5-net_sale = lcnet_sale.
    wa_lctab5-net_qty = lcnet_qty.
    collect wa_lctab5 into it_lctab5.
    clear wa_lctab5.
  endloop.

  loop at it_lctab5 into wa_lctab5.
*    WRITE : / 'last yeat net sale',wa_lctab5-matnr,wa_lctab5-net_sale.
    wa_lctab6-matnr = wa_lctab5-matnr.
    wa_lctab6-s_pts = wa_lctab5-s_pts.
    wa_lctab6-s_qty = wa_lctab5-s_qty.
    wa_lctab6-c_pts = wa_lctab5-c_pts.
    wa_lctab6-c_qty = wa_lctab5-c_qty.
    wa_lctab6-d_pts = wa_lctab5-d_pts.
    wa_lctab6-d_qty = wa_lctab5-d_qty.
    wa_lctab6-net_sale = wa_lctab5-net_sale.
    wa_lctab6-net_qty = wa_lctab5-net_qty.
    collect wa_lctab6 into it_lctab6.
    clear wa_lctab6.
  endloop.


  sort it_tab17 by matnr .
  loop at it_tab into wa_tab.
    wa_mat1-matnr = wa_tab-matnr.
    collect wa_mat1 into it_mat1.
    clear wa_mat1.
  endloop.
  loop at it_ta into wa_ta.
    wa_mat1-matnr = wa_ta-matnr.
    collect wa_mat1 into it_mat1.
    clear wa_mat1.
  endloop.
  loop at it_t into wa_t.
    wa_mat1-matnr = wa_t-matnr.
    collect wa_mat1 into it_mat1.
    clear wa_mat1.
  endloop.

  sort it_mat1 by matnr.
  delete adjacent duplicates from it_mat1 comparing matnr.
  if it_mat1 is not initial.
    select * from mvke into table it_mvke for all entries in it_mat1 where matnr eq it_mat1-matnr and vkorg eq '1000' and vtweg eq '10'.
  endif.
  sort it_mvke by matnr descending.
  sort it_tab17 by matnr.
  sort it_ctab6 by matnr.
  sort it_lctab6 by matnr.

  loop at it_mat1 into wa_mat1.
*    WRITE : / 'material',wa_mat1-matnr.
    clear : ach1,ach2,grq,grv.
*  loop at it_tab17 into wa_tab17.
    read table it_tab17 into wa_tab17 with key matnr = wa_mat1-matnr.
    if sy-subrc eq 0.
      wa_tab181-matnr = wa_tab17-matnr.
      wa_tab181-net_qty = wa_tab17-net_qty.
      wa_tab181-net_sale = wa_tab17-net_sale.
      wa_tab181-b_qty = wa_tab17-b_qty.
      wa_tab181-b_pts = wa_tab17-b_pts.
    endif.

    read table it_ctab7 into wa_ctab7 with key matnr = wa_mat1-matnr.
    if sy-subrc eq 0.
      wa_tab181-matnr = wa_ctab7-matnr.
      wa_tab181-cnet_qty = wa_ctab7-net_qty.
      wa_tab181-cnet_sale = wa_ctab7-net_sale.
      wa_tab181-cb_qty = wa_ctab7-b_qty.
      wa_tab181-cb_pts = wa_ctab7-b_pts.
    endif.

    read table it_lctab6 into wa_lctab6 with key matnr = wa_mat1-matnr.
    if sy-subrc eq 0.
*      WRITE : / 'found',wa_lctab6-matnr,wa_lctab6-mvgr4,wa_lctab6-net_sale.
      wa_tab181-matnr = wa_lctab6-matnr.
      wa_tab181-lcnet_sale = wa_lctab6-net_sale.
      wa_tab181-lcnet_qty = wa_lctab6-net_qty.
    endif.

    collect wa_tab181 into it_tab181.
    clear wa_tab181.
  endloop.

  loop at it_tab181 into wa_tab181 where matnr ne '                  '.

*    wa_tab182-matnr = wa_tab181-matnr.
    wa_tab182-net_qty = wa_tab181-net_qty.
    wa_tab182-net_sale = wa_tab181-net_sale.
    wa_tab182-b_qty = wa_tab181-b_qty.
    wa_tab182-b_pts = wa_tab181-b_pts.
    wa_tab182-cnet_qty = wa_tab181-cnet_qty.
    wa_tab182-cb_qty = wa_tab181-cb_qty.
    wa_tab182-cnet_sale = wa_tab181-cnet_sale.
    wa_tab182-cb_pts = wa_tab181-cb_pts.
    wa_tab182-lcnet_sale = wa_tab181-lcnet_sale.
    wa_tab182-lcnet_qty = wa_tab181-lcnet_qty.


    select single * from mara where matnr eq wa_tab181-matnr.
    if sy-subrc eq 0.
      wa_tab182-spart = mara-spart.
    endif.

    select single * from zprdgroup where rep_type eq 'SR2' and prd_code eq mara-matnr.
    if sy-subrc eq 0.
      wa_tab182-prn_seq = zprdgroup-prn_seq.
      wa_tab182-grp_code = zprdgroup-grp_code.
*      WRITE : / 'material',wa_tab181-matnr,ZPRDGROUP-PRN_SEQ,ZPRDGROUP-GRP_CODE, WA_TAB182-PRN_SEQ,WA_TAB182-GRP_CODE .
    else.
      format color 6.
      write :  'MATERIL CODE NOT MAINTAINED IN ZPRDGROUP',wa_tab181-matnr.
    endif.

*    select single * from mvke where matnr eq wa_tab181-matnr and vkorg eq '1000' and vtweg eq '10' .
*    if sy-subrc eq 0.
*      select single * from tvm5t where spras eq 'EN' and mvgr5 eq mvke-mvgr5.
*      if sy-subrc eq 0.
*        wa_tab182-bezei = tvm5t-bezei.
*      endif.
*    endif.

    select single * from mvke where matnr eq wa_tab181-matnr and vkorg eq '1000' and vtweg eq '10' .
    if sy-subrc eq 0.
      wa_tab182-mvgr4 = mvke-mvgr4.
    endif.

    select single * from tvm4t where spras eq 'EN' and mvgr4 eq wa_tab182-mvgr4.
    if sy-subrc eq 0.
      wa_tab182-maktx = tvm4t-bezei.
    else.
      format color 6.
      write : / 'PRODUCT DESCRIPTIO NOT FOUND FOR ',wa_tab181-matnr.
    endif.

    collect wa_tab182 into it_tab182.
    clear wa_tab182.
  endloop.

  sort it_tab182 by spart prn_seq grp_code.
  loop at it_tab182 into wa_tab182.
    clear : ach1,ach2,grq,grv.
*    FORMAT COLOR 1.
*    WRITE : / '182',WA_TAB182-mvgr4,WA_TAB182-spart,WA_TAB182-prn_seq,WA_TAB182-grp_code,wa_tab182-bezei,wa_tab182-maktx.
    wa_tab18-mvgr4 = wa_tab182-mvgr4.
*    wa_tab18-bezei = wa_tab182-bezei.
    read table it_mvke into wa_mvke with key mvgr4 = wa_tab182-mvgr4.
    if sy-subrc eq 0.
      select single * from tvm5t where spras eq 'EN' and mvgr5 eq wa_mvke-mvgr5.
      if sy-subrc eq 0.
        wa_tab18-bezei = tvm5t-bezei.
      endif.
    endif.

    wa_tab18-maktx = wa_tab182-maktx.
    wa_tab18-spart = wa_tab182-spart.
    wa_tab18-prn_seq = wa_tab182-prn_seq.
    wa_tab18-grp_code = wa_tab182-grp_code.
    wa_tab18-net_qty = wa_tab182-net_qty.
    wa_tab18-net_sale = wa_tab182-net_sale.
    wa_tab18-b_qty = wa_tab182-b_qty.
    wa_tab18-b_pts = wa_tab182-b_pts.
    wa_tab18-cnet_qty = wa_tab182-cnet_qty.
    wa_tab18-cb_qty = wa_tab182-cb_qty.
    wa_tab18-cnet_sale = wa_tab182-cnet_sale.
    wa_tab18-cb_pts = wa_tab182-cb_pts.
    wa_tab18-lcnet_sale = wa_tab182-lcnet_sale.
    wa_tab18-lcnet_qty = wa_tab182-lcnet_qty.


    if wa_tab18-b_pts ne 0.
      ach1 = ( wa_tab18-net_sale / wa_tab18-b_pts ) * 100.
    endif.
    wa_tab18-ach1 = ach1.
    if wa_tab18-cb_pts ne 0.
      ach2 = ( wa_tab18-cnet_sale / wa_tab18-cb_pts ) * 100.
    endif.
    wa_tab18-ach2 = ach2.
    if wa_tab18-lcnet_qty ne 0.
      grq = ( wa_tab18-cnet_qty / wa_tab18-lcnet_qty ) * 100 - 100.
    endif.
    wa_tab18-grq = grq.
    if wa_tab18-lcnet_sale ne 0.
      grv = ( wa_tab18-cnet_sale / wa_tab18-lcnet_sale ) * 100 - 100.
    endif.
    wa_tab18-grv = grv.

    collect wa_tab18 into it_tab18.
    clear wa_tab18.
  endloop.

  sort it_tab18 by spart prn_seq grp_code maktx.
  options-tdgetotf = 'X'.
  call function 'OPEN_FORM'
    exporting
      device   = 'PRINTER'
      dialog   = ''
*     form     = 'ZSR1'
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
      form        = 'ZSR41G'
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

*  ENDIF.
  select single * from t247 where spras eq 'EN' and mnr eq from_dt+4(2).
  if sy-subrc eq 0.
*    write : t247-ktx.
    month = t247-ktx.
    concatenate month '.' from_dt+0(4) into month1.
  endif.

*  sort it_tab18 by begru matkl.
  sort it_tab18 by spart prn_seq grp_code maktx.
  loop at it_tab18 into wa_tab18.

*    call function 'WRITE_FORM'
*      exporting
*        element = 'HEADD'
*        window  = 'WINDOW1'.

*    if wa_tab18-spart eq '50'.
*      on change of wa_tab18-spart.
**        write : / 'BLUE CROSS'.
*        call function 'WRITE_FORM'
*          exporting
*            element = 'HEAD'
*            window  = 'MAIN'.
**        uline.
*      endon.
*    endif.

*    if wa_tab18-spart eq '60'.
*      on change of wa_tab18-spart.
**        write : / 'EXCEL'.
*        call function 'WRITE_FORM'
*          exporting
*            element = 'HEAD1'
*            window  = 'MAIN'.
**        uline.
*      endon.
*    endif.
*    if wa_tab18-spart eq '70'.
*      on change of wa_tab18-spart.
**        write : / 'EXCEL'.
*        call function 'WRITE_FORM'
*          exporting
*            element = 'HEAD2'
*            window  = 'MAIN'.
**        uline.
*      endon.
*    endif.
*    if ( z1 eq 'X' ) and ( wa_tab18-net_qty le 0 ).
    clear bud_net.
    bud_net = wa_tab18-cnet_qty + wa_tab18-cb_pts.
*    if ( z1 eq 'X' ) and ( bud_net le 0 ).
*    else.
*      call function 'WRITE_FORM'
*        exporting
*          element = 'DET1'
*          window  = 'MAIN'.
*    endif.

    t_sqty = t_sqty + wa_tab18-net_qty.
    t_bqty = t_bqty + wa_tab18-b_qty.
    t_spts = t_spts + wa_tab18-net_sale.
    t_bpts = t_bpts + wa_tab18-b_pts.
    t_csqty = t_csqty + wa_tab18-cnet_qty.
    t_cbqty = t_cbqty + wa_tab18-cb_qty.
    t_cspts = t_cspts + wa_tab18-cnet_sale.
    t_cbpts = t_cbpts + wa_tab18-cb_pts.
    t_lcspts = t_lcspts + wa_tab18-lcnet_sale.
    t_lcsqty = t_lcsqty + wa_tab18-lcnet_qty.

*    on change of wa_tab18-matkl.
    at end of grp_code.


      if wa_tab18-grp_code ne 0.
        if t_total ne 0.
          if t_bpts ne 0.
            t_ach1 = ( t_spts / t_bpts ) * 100.
          else.
            t_ach1 = 0.
          endif.
          if t_cbpts ne 0.
            t_ach2 = ( t_cspts / t_cbpts ) * 100.
          else.
            t_cbpts = 0.
          endif.
          if t_lcsqty ne 0.
            lgrq = ( t_csqty / t_lcsqty ) * 100 - 100.
          else.
            lgrq = 0.
          endif.
          if t_lcspts ne 0.
            lgrv = ( t_cspts / t_lcspts ) * 100 - 100.
          else.
            lgrv = 0.
          endif.
          clear : grp_name,grp_code.
          if wa_tab18-grp_code = 53.
            grp_name = 'OTHERS EXL'.
          elseif wa_tab18-grp_code = 45.
            grp_name = 'OTHERS BC'.
          else.
            grp_name = 'GROUP TOTAL'.
          endif.

          call function 'WRITE_FORM'
            exporting
              element = 'GR1'
              window  = 'MAIN'.

          t_sqty = 0.
          t_bqty = 0.
          t_spts = 0.
          t_bpts = 0.
          t_csqty = 0.
          t_cspts = 0.
          t_cbqty = 0.
          t_cbpts = 0.
          t_ach1 = 0.
          t_ach2 = 0.
          t_lcspts = 0.
          t_lcsqty = 0.
          lgrv = 0.
          lgrq = 0.
          t_total = 0.
        else.
          call function 'WRITE_FORM'
            exporting
              element = 'GR2'
              window  = 'MAIN'.
          t_sqty = 0.
          t_bqty = 0.
          t_spts = 0.
          t_bpts = 0.
          t_csqty = 0.
          t_cspts = 0.
          t_cbqty = 0.
          t_cbpts = 0.
          t_ach1 = 0.
          t_ach2 = 0.
          t_lcspts = 0.
          t_lcsqty = 0.
          lgrv = 0.
          lgrq = 0.
          t_total = 0.

        endif.
      endif.
    endat.



*    write : /'j', wa_tab18-mvgr4,wa_tab18-bezei,wa_tab18-bezei1,wa_tab18-net_qty,wa_tab18-b_qty,wa_tab18-net_sale,wa_tab18-b_pts.
*    write : wa_tab18-ach1,wa_tab18-cnet_qty,wa_tab18-cb_qty,wa_tab18-cnet_sale,wa_tab18-cb_pts.
*    write : wa_tab18-ach2,wa_tab18-grq,wa_tab18-grv.



    t_total = t_sqty + t_bqty + t_spts + t_bpts + t_csqty + t_cbqty + t_cspts + t_cbpts + t_lcspts + t_lcsqty.

    tot_sqty = tot_sqty + wa_tab18-net_qty.
    tot_bqty = tot_bqty + wa_tab18-b_qty.
    tot_spts = tot_spts + wa_tab18-net_sale.
    tot_bpts = tot_bpts + wa_tab18-b_pts.
    tot_csqty = tot_csqty + wa_tab18-cnet_qty.
    tot_cbqty = tot_cbqty + wa_tab18-cb_qty.
    tot_cspts = tot_cspts + wa_tab18-cnet_sale.
    tot_cbpts = tot_cbpts + wa_tab18-cb_pts.

    tot_lcpts = tot_lcpts + wa_tab18-lcnet_sale.
*    tot_lcbpts = tot_lcbpts + wa_tab18-lcb_pts.

  endloop.
*WRITE : / 'total pts',tot_spts.
  if tot_bpts ne 0.
    tot_ach1 = ( tot_spts / tot_bpts ) * 100.
  endif.
  if tot_cbpts ne 0.
    tot_ach2 = ( tot_cspts / tot_cbpts ) * 100.
  endif.
  if tot_lcqty ne 0.
    tot_gr1 = ( ( tot_csqty / tot_lcqty ) * 100 ) - 100.
  endif.
*  WRITE : / 'a',tot_cspts,tot_lcpts.
  if tot_lcpts ne 0.
    tot_gr2 = ( ( tot_cspts / tot_lcpts ) * 100 ) - 100.
  endif.

*  WRITE : / tot_gr1,tot_gr2.
  call function 'WRITE_FORM'
    exporting
      element = 'TOT1'
      window  = 'MAIN'.
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

  write from_dt to wa_d1 dd/mm/yyyy.
  write to_dt to wa_d2 dd/mm/yyyy.

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
  concatenate 'SR-2 GROSS FROM:' wa_d1 'TO ' wa_d2  into doc_chng-obj_descr separated by space.
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

  concatenate 'SR-2 GROSS' '.' into objpack-obj_descr separated by space.
  objpack-doc_size = righe_attachment * 255.
  append objpack.
  clear objpack.

*    loop at it_tam2 into wa_tam2 where pernr = wa_tam1-pernr.
  reclist-receiver =   email.
  reclist-express = 'X'.
  reclist-rec_type = 'U'.
  reclist-notif_del = 'X'. " request delivery notification
  reclist-notif_ndel = 'X'. " request not delivered notification
  append reclist.
  clear reclist.
*    endloop.
  describe table reclist lines mcount.
  if mcount > 0.

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

      write : / 'EMAIL SENT ON ',email.
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


  clear : a1,a2,a3,a4,b1,b2,c1,c2,d1,d2.
endform.                    "GROSS_FORM



*&---------------------------------------------------------------------*
*&      Form  NET_EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form net_email.


  select * from zsales_tab1 into table it_zsales_tab1 where datab ge from_dt and datbi le to_dt.
  select * from zcredit_tab1 into table it_zcredit_tab1 where datab ge from_dt and datbi le to_dt.
  select * from zdebit_tab1 into table it_zdebit_tab1 where datab ge from_dt and datbi le to_dt.
  select * from zbudget_tab1 into table it_zbudget_tab1 where datab ge from_dt and datbi le to_dt and tag eq 'N'.

  loop at it_zsales_tab1 into wa_zsales_tab1.

    pts = wa_zsales_tab1-net + wa_zsales_tab1-ed.
    wa_tab11-matnr = wa_zsales_tab1-matnr.
    wa_tab11-pts = pts.
    wa_tab11-qty = wa_zsales_tab1-c_qty.

    wa_tab-matnr = wa_zsales_tab1-matnr.
    collect wa_tab into it_tab.
    clear wa_tab.
    collect wa_tab11 into it_tab11.
    clear wa_tab11.
    clear pts.
  endloop.

*LOOP AT IT_TAB1 INTO WA_TAB1.
*  WRITE : /'SALE', WA_TAB1-MATNR,WA_TAB1-PTS,WA_TAB1-ED,WA_TAB1-C_QTY,WA_TAB1-F_QTY.
*ENDLOOP.

  loop at it_zcredit_tab1 into wa_zcredit_tab1.
    wa_tab12-matnr = wa_zcredit_tab1-matnr.
    wa_tab12-pts = wa_zcredit_tab1-net.
    wa_tab12-qty = wa_zcredit_tab1-qty_c.
    wa_tab-matnr = wa_zcredit_tab1-matnr.
    collect wa_tab into it_tab.
    clear wa_tab.
    collect wa_tab12 into it_tab12.
    clear wa_tab12.
  endloop.


  loop at it_zdebit_tab1 into wa_zdebit_tab1.
    wa_tab13-matnr = wa_zdebit_tab1-matnr.
    wa_tab13-pts = wa_zdebit_tab1-net.
    wa_tab13-qty = wa_zdebit_tab1-qty_c.
    wa_tab-matnr = wa_zdebit_tab1-matnr.
    collect wa_tab into it_tab.
    clear wa_tab.
    collect wa_tab13 into it_tab13.
    clear wa_tab13.

  endloop.

  loop at it_zbudget_tab1 into wa_zbudget_tab1.
    wa_tab14-matnr = wa_zbudget_tab1-matnr.
    wa_tab14-pts = wa_zbudget_tab1-val.
    wa_tab14-qty = wa_zbudget_tab1-qty.
    wa_tab-matnr = wa_zbudget_tab1-matnr.
    collect wa_tab into it_tab.
    clear wa_tab.
    collect wa_tab14 into it_tab14.
    clear wa_tab14.
  endloop.

  loop at it_tab into wa_tab.
    read table it_tab11 into wa_tab11 with key matnr = wa_tab-matnr.  "sale
    if sy-subrc eq 0.
      wa_tab15-matnr = wa_tab11-matnr.
      wa_tab15-s_pts = wa_tab11-pts.
      wa_tab15-s_qty = wa_tab11-qty.
    endif.
    read table it_tab12 into wa_tab12 with key matnr = wa_tab-matnr.  "cn
    if sy-subrc eq 0.
      wa_tab15-matnr = wa_tab12-matnr.
      wa_tab15-c_pts = wa_tab12-pts.
      wa_tab15-c_qty = wa_tab12-qty.
    endif.
    read table it_tab13 into wa_tab13 with key matnr = wa_tab-matnr.  "dn
    if sy-subrc eq 0.
      wa_tab15-matnr = wa_tab13-matnr.
      wa_tab15-d_pts = wa_tab13-pts.
      wa_tab15-d_qty = wa_tab13-qty.
    endif.
    read table it_tab14 into wa_tab14 with key matnr = wa_tab-matnr.  "budget
    if sy-subrc eq 0.
      wa_tab15-matnr = wa_tab14-matnr.
      wa_tab15-b_pts = wa_tab14-pts.
      wa_tab15-b_qty = wa_tab14-qty.
    endif.
    collect wa_tab15 into it_tab15.
    clear wa_tab15.
  endloop.

  loop at it_tab15 into wa_tab15.
    clear : net_sale,net_qty.
*    WRITE : / 'a',wa_TAB15-matnr,WA_TAB15-B_PTS,WA_TAB15-B_QTY,wa_TAB15-s_pts,wa_TAB15-s_qty,wa_TAB15-c_pts,wa_TAB15-c_qty,wa_TAB15-d_pts,
*    wa_TAB15-d_qty.
    net_sale = wa_tab15-s_pts - wa_tab15-c_pts + wa_tab15-d_pts.
    net_qty = wa_tab15-s_qty - wa_tab15-c_qty + wa_tab15-d_qty.
    wa_tab16-matnr = wa_tab15-matnr.
    wa_tab16-b_pts = wa_tab15-b_pts.
    wa_tab16-b_qty = wa_tab15-b_qty.
    wa_tab16-s_pts = wa_tab15-s_pts.
    wa_tab16-s_qty = wa_tab15-s_qty.
    wa_tab16-c_pts = wa_tab15-c_pts.
    wa_tab16-c_qty = wa_tab15-c_qty.
    wa_tab16-d_pts = wa_tab15-d_pts.
    wa_tab16-d_qty = wa_tab15-d_qty.
    wa_tab16-net_sale = net_sale.
    wa_tab16-net_qty = net_qty.
    collect wa_tab16 into it_tab16.
    clear wa_tab16.
  endloop.

  loop at it_tab16 into wa_tab16.
    wa_tab17-matnr = wa_tab16-matnr.
    wa_tab17-b_pts = wa_tab16-b_pts.
    wa_tab17-b_qty = wa_tab16-b_qty.
    wa_tab17-s_pts = wa_tab16-s_pts.
    wa_tab17-s_qty = wa_tab16-s_qty.
    wa_tab17-c_pts = wa_tab16-c_pts.
    wa_tab17-c_qty = wa_tab16-c_qty.
    wa_tab17-d_pts = wa_tab16-d_pts.
    wa_tab17-d_qty = wa_tab16-d_qty.
    wa_tab17-net_sale = wa_tab16-net_sale.
    wa_tab17-net_qty = wa_tab16-net_qty.
    collect wa_tab17 into it_tab17.
    clear wa_tab17.
  endloop.


***************CURRENT MOTH SALE ENDS HERE **********************

*************CUMMULATIVE SALE STARTS HERE***************************
  c_date+6(2) = '01'.
  c_date+4(2) = '04'.

  if from_dt+4(2) lt '04'.
    c_date+0(4) = from_dt+0(4) - 1.
  else.
    c_date+0(4) = from_dt+0(4).
  endif.
*  write : / 'cummulative date',c_date.

  select * from zsales_tab1 into table it_zsales_tab2 where datab ge c_date and datbi le to_dt.
  if it_zsales_tab2 is not initial.
    loop at it_zsales_tab2 into wa_zsales_tab2.
      wa_ctab1-matnr = wa_zsales_tab2-matnr.
      wa_ctab1-pts = wa_zsales_tab2-net + wa_zsales_tab2-ed.
      wa_ctab1-qty = wa_zsales_tab2-c_qty.
      collect wa_ctab1 into it_ctab1.
      clear wa_ctab1.
      wa_ta-matnr = wa_zsales_tab2-matnr.
      collect wa_ta into it_ta.
      clear wa_ta.
    endloop.
  endif.

  select * from zcredit_tab1 into table it_zcredit_tab2 where datab ge c_date and datbi le to_dt.
  if it_zcredit_tab2 is not initial.
    loop at it_zcredit_tab2 into wa_zcredit_tab2.
      wa_ctab2-matnr = wa_zcredit_tab2-matnr.
      wa_ctab2-pts = wa_zcredit_tab2-net.
      wa_ctab2-qty = wa_zcredit_tab2-qty_c.
      collect wa_ctab2 into it_ctab2.
      clear wa_ctab2.
      wa_ta-matnr = wa_zcredit_tab2-matnr.
      collect wa_ta into it_ta.
      clear wa_ta.
    endloop.
  endif.

  select * from zdebit_tab1 into table it_zdebit_tab2 where datab ge c_date and datbi le to_dt.
  if it_zdebit_tab2 is not initial.
    loop at it_zdebit_tab2 into wa_zdebit_tab2.
      wa_ctab3-matnr = wa_zdebit_tab2-matnr.
      wa_ctab3-pts = wa_zdebit_tab2-net.
      wa_ctab3-qty = wa_zdebit_tab2-qty_c.
      collect wa_ctab3 into it_ctab3.
      clear wa_ctab3.
      wa_ta-matnr = wa_zdebit_tab2-matnr.
      collect wa_ta into it_ta.
      clear wa_ta.
    endloop.
  endif.

  select * from zbudget_tab1 into table it_zbudget_tab2 where datab ge c_date and datbi le to_dt and tag eq 'N'.
  if it_zbudget_tab2 is not initial.
    loop at it_zbudget_tab2 into wa_zbudget_tab2.
*      WRITE : / 'budget',c_date,TO_DT,wa_zBUDGET_tab2-matnr,wa_zBUDGET_tab2-qty.
      wa_ctab4-matnr = wa_zbudget_tab2-matnr.
      wa_ctab4-pts = wa_zbudget_tab2-val.
      wa_ctab4-qty = wa_zbudget_tab2-qty.
      collect wa_ctab4 into it_ctab4.
      clear wa_ctab4.
      wa_ta-matnr = wa_zbudget_tab2-matnr.
      collect wa_ta into it_ta.
      clear wa_ta.
    endloop.
  endif.

  sort it_ta.
  delete adjacent duplicates from it_ta.

  loop at it_ta into wa_ta.
    read table it_ctab1 into wa_ctab1 with key matnr = wa_ta-matnr.
    if sy-subrc eq 0.
      wa_ctab5-matnr = wa_ctab1-matnr.
      wa_ctab5-s_pts = wa_ctab1-pts.
      wa_ctab5-s_qty = wa_ctab1-qty.
    endif.
    read table it_ctab2 into wa_ctab2 with key matnr = wa_ta-matnr.
    if sy-subrc eq 0.
      wa_ctab5-matnr = wa_ctab2-matnr.
      wa_ctab5-c_pts = wa_ctab2-pts.
      wa_ctab5-c_qty = wa_ctab2-qty.
    endif.
    read table it_ctab3 into wa_ctab3 with key matnr = wa_ta-matnr.
    if sy-subrc eq 0.
      wa_ctab5-matnr = wa_ctab3-matnr.
      wa_ctab5-d_pts = wa_ctab3-pts.
      wa_ctab5-d_qty = wa_ctab3-qty.
    endif.
    read table it_ctab4 into wa_ctab4 with key matnr = wa_ta-matnr.
    if sy-subrc eq 0.
      wa_ctab5-matnr = wa_ctab4-matnr.
      wa_ctab5-b_pts = wa_ctab4-pts.
      wa_ctab5-b_qty = wa_ctab4-qty.
    endif.
    collect wa_ctab5 into it_ctab5.
    clear wa_ctab5.
  endloop.

  loop at it_ctab5 into wa_ctab5.
    clear : cnet_sale,cnet_qty.
    wa_ctab6-matnr = wa_ctab5-matnr.
    wa_ctab6-s_pts = wa_ctab5-s_pts.
    wa_ctab6-s_qty = wa_ctab5-s_qty.
    wa_ctab6-c_pts = wa_ctab5-c_pts.
    wa_ctab6-c_qty = wa_ctab5-c_qty.
    wa_ctab6-d_pts = wa_ctab5-d_pts.
    wa_ctab6-d_qty = wa_ctab5-d_qty.
    wa_ctab6-b_pts = wa_ctab5-b_pts.
    wa_ctab6-b_qty = wa_ctab5-b_qty.
    cnet_sale = wa_ctab5-s_pts - wa_ctab5-c_pts + wa_ctab5-d_pts.
    cnet_qty = wa_ctab5-s_qty - wa_ctab5-c_qty + wa_ctab5-d_qty.
    wa_ctab6-net_sale = cnet_sale.
    wa_ctab6-net_qty = cnet_qty.
    collect wa_ctab6 into it_ctab6.
    clear wa_ctab6.
  endloop.
  sort it_ctab6 by bezei.

  loop at it_ctab6 into wa_ctab6.
    wa_ctab7-matnr = wa_ctab6-matnr.
    wa_ctab7-s_pts = wa_ctab6-s_pts.
    wa_ctab7-s_qty = wa_ctab6-s_qty.
    wa_ctab7-c_pts = wa_ctab6-c_pts.
    wa_ctab7-c_qty = wa_ctab6-c_qty.
    wa_ctab7-d_pts = wa_ctab6-d_pts.
    wa_ctab7-d_qty = wa_ctab6-d_qty.
    wa_ctab7-b_pts = wa_ctab6-b_pts.
    wa_ctab7-b_qty = wa_ctab6-b_qty.
    wa_ctab7-net_sale = wa_ctab6-net_sale.
    wa_ctab7-net_qty = wa_ctab6-net_qty.
    collect wa_ctab7 into it_ctab7.
    clear wa_ctab7.
  endloop.

*  LOOP AT IT_CTAB7 INTO WA_CTAB7.
*    WRITE : /'a1',wa_tab7-mvgr4,wa_ctab7-bezei,'net',wa_ctab7-net_qty,'sale',WA_CTAB7-S_QTY,'credit',wa_ctab7-c_qty,'debit',wa_ctab7-d_qty,'bud',wa_ctab7-b_qty,wa_ctab7-net_sale,wa_ctab7-b_pts.
*  ENDLOOP.

**************CUMMULATIVE DATA ENDS HERE********************

******************LAST YEAR CUMMULATIVE DATA STARTS*****************

  ll_date = c_date.
  ll_date+0(4) = c_date+0(4) - 1.
  lc_date = to_dt.
  lc_date+0(4) = to_dt+0(4) - 1.
*  write : / 'last fiscal year',ll_date,'last year same date',lc_date.
*WRITE : / 'date',lc_date.

*******************************************************
  clear : ndt1,ndt2.
  ndt1 = lc_date.
  ndt1+6(2) = '01'.
  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date           = ndt1
    importing
*     EV_MONTH_BEGIN_DATE       =
      ev_month_end_date = ndt2.
  lc_date = ndt2.
*************************************************************************

  if lc_date = '20160228'.
    lc_date = '20160229'.
  endif.
*WRITE : / 'date',lc_date.

  select * from zsales_tab1 into table it_zsales_tab3 where datab ge ll_date and datbi le lc_date.
  if it_zsales_tab3 is not initial.
    loop at it_zsales_tab3 into wa_zsales_tab3.
      wa_lctab1-matnr = wa_zsales_tab3-matnr.
      wa_lctab1-pts = wa_zsales_tab3-net + wa_zsales_tab3-ed.
      wa_lctab1-qty = wa_zsales_tab3-c_qty.
      collect wa_lctab1 into it_lctab1.
      clear wa_lctab1.
      wa_t-matnr = wa_zsales_tab3-matnr.
      collect wa_t into it_t.
      clear wa_t.
    endloop.
  endif.

  select * from zcredit_tab1 into table it_zcredit_tab3 where datab ge ll_date and datbi le lc_date.
  if it_zcredit_tab3 is not initial.
    loop at it_zcredit_tab3 into wa_zcredit_tab3.
      wa_lctab2-matnr = wa_zcredit_tab3-matnr.
      wa_lctab2-pts = wa_zcredit_tab3-net.
      wa_lctab2-qty = wa_zcredit_tab3-qty_c.
      collect wa_lctab2 into it_lctab2.
      clear wa_lctab2.
      wa_t-matnr = wa_zcredit_tab3-matnr.
      collect wa_t into it_t.
      clear wa_t.
    endloop.
  endif.

  select * from zdebit_tab1 into table it_zdebit_tab3 where datab ge ll_date and datbi le lc_date.
  if it_zdebit_tab3 is not initial.
    loop at it_zdebit_tab3 into wa_zdebit_tab3.
      wa_lctab3-matnr = wa_zdebit_tab3-matnr.
      wa_lctab3-pts = wa_zdebit_tab3-net.
      wa_lctab3-qty = wa_zdebit_tab3-qty_c.
      collect wa_lctab3 into it_lctab3.
      clear wa_lctab3.
      wa_t-matnr = wa_zdebit_tab3-matnr.
      collect wa_t into it_t.
      clear wa_t.
    endloop.
  endif.


  loop at it_t into wa_t.
    read table it_lctab1 into wa_lctab1 with key matnr = wa_t-matnr.
    if sy-subrc eq 0.
      wa_lctab4-matnr = wa_lctab1-matnr.
      wa_lctab4-s_pts = wa_lctab1-pts.
      wa_lctab4-s_qty = wa_lctab1-qty.
    endif.
    read table it_lctab2 into wa_lctab2 with key matnr = wa_t-matnr.
    if sy-subrc eq 0.
      wa_lctab4-matnr = wa_lctab2-matnr.
      wa_lctab4-c_pts = wa_lctab2-pts.
      wa_lctab4-c_qty = wa_lctab2-qty.
    endif.
    read table it_lctab3 into wa_lctab3 with key matnr = wa_t-matnr.
    if sy-subrc eq 0.
      wa_lctab4-matnr = wa_lctab3-matnr.
      wa_lctab4-d_pts = wa_lctab3-pts.
      wa_lctab4-d_qty = wa_lctab3-qty.
    endif.
    collect wa_lctab4 into it_lctab4.
    clear wa_lctab4.
  endloop.

  loop at it_lctab4 into wa_lctab4.
    clear : lcnet_sale,lcnet_qty.
    wa_lctab5-matnr = wa_lctab4-matnr.
    wa_lctab5-s_pts = wa_lctab4-s_pts.
    wa_lctab5-s_qty = wa_lctab4-s_qty.
    wa_lctab5-c_pts = wa_lctab4-c_pts.
    wa_lctab5-c_qty = wa_lctab4-c_qty.
    wa_lctab5-d_pts = wa_lctab4-d_pts.
    wa_lctab5-d_qty = wa_lctab4-d_qty.
    lcnet_sale = wa_lctab4-s_pts - wa_lctab4-c_pts + wa_lctab4-d_pts.
    lcnet_qty = wa_lctab4-s_qty - wa_lctab4-c_qty + wa_lctab4-d_qty.
    wa_lctab5-net_sale = lcnet_sale.
    wa_lctab5-net_qty = lcnet_qty.
    collect wa_lctab5 into it_lctab5.
    clear wa_lctab5.
  endloop.

  loop at it_lctab5 into wa_lctab5.
*    WRITE : / 'last yeat net sale',wa_lctab5-matnr,wa_lctab5-net_sale.
    wa_lctab6-matnr = wa_lctab5-matnr.
    wa_lctab6-s_pts = wa_lctab5-s_pts.
    wa_lctab6-s_qty = wa_lctab5-s_qty.
    wa_lctab6-c_pts = wa_lctab5-c_pts.
    wa_lctab6-c_qty = wa_lctab5-c_qty.
    wa_lctab6-d_pts = wa_lctab5-d_pts.
    wa_lctab6-d_qty = wa_lctab5-d_qty.
    wa_lctab6-net_sale = wa_lctab5-net_sale.
    wa_lctab6-net_qty = wa_lctab5-net_qty.
    collect wa_lctab6 into it_lctab6.
    clear wa_lctab6.
  endloop.


  sort it_tab17 by matnr .
  loop at it_tab into wa_tab.
    wa_mat1-matnr = wa_tab-matnr.
    collect wa_mat1 into it_mat1.
    clear wa_mat1.
  endloop.
  loop at it_ta into wa_ta.
    wa_mat1-matnr = wa_ta-matnr.
    collect wa_mat1 into it_mat1.
    clear wa_mat1.
  endloop.
  loop at it_t into wa_t.
    wa_mat1-matnr = wa_t-matnr.
    collect wa_mat1 into it_mat1.
    clear wa_mat1.
  endloop.

  sort it_mat1 by matnr.
  delete adjacent duplicates from it_mat1 comparing matnr.
  if it_mat1 is not initial.
    select * from mvke into table it_mvke for all entries in it_mat1 where matnr eq it_mat1-matnr and vkorg eq '1000' and vtweg eq '10'.
  endif.
  sort it_mvke by matnr descending.

  sort it_tab17 by matnr.
  sort it_ctab6 by matnr.
  sort it_lctab6 by matnr.

  loop at it_mat1 into wa_mat1.
*    WRITE : / 'material',wa_mat1-matnr.
    clear : ach1,ach2,grq,grv.
*  loop at it_tab17 into wa_tab17.
    read table it_tab17 into wa_tab17 with key matnr = wa_mat1-matnr.
    if sy-subrc eq 0.
      wa_tab181-matnr = wa_tab17-matnr.
      wa_tab181-net_qty = wa_tab17-net_qty.
      wa_tab181-net_sale = wa_tab17-net_sale.
      wa_tab181-b_qty = wa_tab17-b_qty.
      wa_tab181-b_pts = wa_tab17-b_pts.
    endif.

    read table it_ctab7 into wa_ctab7 with key matnr = wa_mat1-matnr.
    if sy-subrc eq 0.
      wa_tab181-matnr = wa_ctab7-matnr.
      wa_tab181-cnet_qty = wa_ctab7-net_qty.
      wa_tab181-cnet_sale = wa_ctab7-net_sale.
      wa_tab181-cb_qty = wa_ctab7-b_qty.
      wa_tab181-cb_pts = wa_ctab7-b_pts.
    endif.

    read table it_lctab6 into wa_lctab6 with key matnr = wa_mat1-matnr.
    if sy-subrc eq 0.
*      WRITE : / 'found',wa_lctab6-matnr,wa_lctab6-mvgr4,wa_lctab6-net_sale.
      wa_tab181-matnr = wa_lctab6-matnr.
      wa_tab181-lcnet_sale = wa_lctab6-net_sale.
      wa_tab181-lcnet_qty = wa_lctab6-net_qty.
    endif.

    collect wa_tab181 into it_tab181.
    clear wa_tab181.
  endloop.

  loop at it_tab181 into wa_tab181 where matnr ne '                  '.

*    wa_tab182-matnr = wa_tab181-matnr.
    wa_tab182-net_qty = wa_tab181-net_qty.
    wa_tab182-net_sale = wa_tab181-net_sale.
    wa_tab182-b_qty = wa_tab181-b_qty.
    wa_tab182-b_pts = wa_tab181-b_pts.
    wa_tab182-cnet_qty = wa_tab181-cnet_qty.
    wa_tab182-cb_qty = wa_tab181-cb_qty.
    wa_tab182-cnet_sale = wa_tab181-cnet_sale.
    wa_tab182-cb_pts = wa_tab181-cb_pts.
    wa_tab182-lcnet_sale = wa_tab181-lcnet_sale.
    wa_tab182-lcnet_qty = wa_tab181-lcnet_qty.


    select single * from mara where matnr eq wa_tab181-matnr.
    if sy-subrc eq 0.
      wa_tab182-spart = mara-spart.
    endif.

    select single * from zprdgroup where rep_type eq 'SR2' and prd_code eq mara-matnr.
    if sy-subrc eq 0.
      wa_tab182-prn_seq = zprdgroup-prn_seq.
      wa_tab182-grp_code = zprdgroup-grp_code.
*      WRITE : / 'material',wa_tab181-matnr,ZPRDGROUP-PRN_SEQ,ZPRDGROUP-GRP_CODE, WA_TAB182-PRN_SEQ,WA_TAB182-GRP_CODE .
    else.
      format color 6.
      write :  'MATERIL CODE NOT MAINTAINED IN ZPRDGROUP',wa_tab181-matnr.
    endif.

*    select single * from mvke where matnr eq wa_tab181-matnr and vkorg eq '1000' and vtweg eq '10' .
*    if sy-subrc eq 0.
*      select single * from tvm5t where spras eq 'EN' and mvgr5 eq mvke-mvgr5.
*      if sy-subrc eq 0.
*        wa_tab182-bezei = tvm5t-bezei.
*      endif.
*    endif.

    select single * from mvke where matnr eq wa_tab181-matnr and vkorg eq '1000' and vtweg eq '10' .
    if sy-subrc eq 0.
      wa_tab182-mvgr4 = mvke-mvgr4.
    endif.

    select single * from tvm4t where spras eq 'EN' and mvgr4 eq wa_tab182-mvgr4.
    if sy-subrc eq 0.
      wa_tab182-maktx = tvm4t-bezei.
    else.
      format color 6.
      write : / 'PRODUCT DESCRIPTIO NOT FOUND FOR ',wa_tab181-matnr.
    endif.

    collect wa_tab182 into it_tab182.
    clear wa_tab182.
  endloop.

  sort it_tab182 by spart prn_seq grp_code.
  loop at it_tab182 into wa_tab182.
    clear : ach1,ach2,grq,grv.
*    FORMAT COLOR 1.
*    WRITE : / '182',WA_TAB182-mvgr4,WA_TAB182-spart,WA_TAB182-prn_seq,WA_TAB182-grp_code,wa_tab182-bezei,wa_tab182-maktx.
    wa_tab18-mvgr4 = wa_tab182-mvgr4.
*    wa_tab18-bezei = wa_tab182-bezei.
    read table it_mvke into wa_mvke with key mvgr4 = wa_tab182-mvgr4.
    if sy-subrc eq 0.
      select single * from tvm5t where spras eq 'EN' and mvgr5 eq wa_mvke-mvgr5.
      if sy-subrc eq 0.
        wa_tab18-bezei = tvm5t-bezei.
      endif.
    endif.
    wa_tab18-maktx = wa_tab182-maktx.
    wa_tab18-spart = wa_tab182-spart.
    wa_tab18-prn_seq = wa_tab182-prn_seq.
    wa_tab18-grp_code = wa_tab182-grp_code.
    wa_tab18-net_qty = wa_tab182-net_qty.
    wa_tab18-net_sale = wa_tab182-net_sale.
    wa_tab18-b_qty = wa_tab182-b_qty.
    wa_tab18-b_pts = wa_tab182-b_pts.
    wa_tab18-cnet_qty = wa_tab182-cnet_qty.
    wa_tab18-cb_qty = wa_tab182-cb_qty.
    wa_tab18-cnet_sale = wa_tab182-cnet_sale.
    wa_tab18-cb_pts = wa_tab182-cb_pts.
    wa_tab18-lcnet_sale = wa_tab182-lcnet_sale.
    wa_tab18-lcnet_qty = wa_tab182-lcnet_qty.


    if wa_tab18-b_pts ne 0.
      ach1 = ( wa_tab18-net_sale / wa_tab18-b_pts ) * 100.
    endif.
    wa_tab18-ach1 = ach1.
    if wa_tab18-cb_pts ne 0.
      ach2 = ( wa_tab18-cnet_sale / wa_tab18-cb_pts ) * 100.
    endif.
    wa_tab18-ach2 = ach2.
    if wa_tab18-lcnet_qty ne 0.
      grq = ( wa_tab18-cnet_qty / wa_tab18-lcnet_qty ) * 100 - 100.
    endif.
    wa_tab18-grq = grq.
    if wa_tab18-lcnet_sale ne 0.
      grv = ( wa_tab18-cnet_sale / wa_tab18-lcnet_sale ) * 100 - 100.
    endif.
    wa_tab18-grv = grv.

    collect wa_tab18 into it_tab18.
    clear wa_tab18.
  endloop.

  sort it_tab18 by spart prn_seq grp_code maktx.
  options-tdgetotf = 'X'.
  call function 'OPEN_FORM'
    exporting
      device   = 'PRINTER'
      dialog   = ''
*     form     = 'ZSR1'
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
      form        = 'ZSR41'
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

*  ENDIF.
  select single * from t247 where spras eq 'EN' and mnr eq from_dt+4(2).
  if sy-subrc eq 0.
*    write : t247-ktx.
    month = t247-ktx.
    concatenate month '.' from_dt+0(4) into month1.
  endif.

*  sort it_tab18 by begru matkl.
  sort it_tab18 by spart prn_seq grp_code maktx.
  loop at it_tab18 into wa_tab18.

    call function 'WRITE_FORM'
      exporting
        element = 'HEADD'
        window  = 'WINDOW1'.

    if wa_tab18-spart eq '50'.
      on change of wa_tab18-spart.
*        write : / 'BLUE CROSS'.
        call function 'WRITE_FORM'
          exporting
            element = 'HEAD'
            window  = 'MAIN'.
*        uline.
      endon.
    endif.

    if wa_tab18-spart eq '60'.
      on change of wa_tab18-spart.
*        write : / 'EXCEL'.
        call function 'WRITE_FORM'
          exporting
            element = 'HEAD1'
            window  = 'MAIN'.
*        uline.
      endon.
    endif.
    if wa_tab18-spart eq '70'.
      on change of wa_tab18-spart.
*        write : / 'EXCEL'.
        call function 'WRITE_FORM'
          exporting
            element = 'HEAD2'
            window  = 'MAIN'.
*        uline.
      endon.
    endif.
    clear : bud_net.
    bud_net = wa_tab18-cnet_sale + wa_tab18-cb_pts.
*    if ( z1 eq 'X' ) and ( bud_net le 0 ).
*    else.
*      call function 'WRITE_FORM'
*        exporting
*          element = 'DET1'
*          window  = 'MAIN'.
*    endif.

    t_sqty = t_sqty + wa_tab18-net_qty.
    t_bqty = t_bqty + wa_tab18-b_qty.
    t_spts = t_spts + wa_tab18-net_sale.
    t_bpts = t_bpts + wa_tab18-b_pts.
    t_csqty = t_csqty + wa_tab18-cnet_qty.
    t_cbqty = t_cbqty + wa_tab18-cb_qty.
    t_cspts = t_cspts + wa_tab18-cnet_sale.
    t_cbpts = t_cbpts + wa_tab18-cb_pts.
    t_lcspts = t_lcspts + wa_tab18-lcnet_sale.
    t_lcsqty = t_lcsqty + wa_tab18-lcnet_qty.

*    on change of wa_tab18-matkl.
    at end of grp_code.


      if wa_tab18-grp_code ne 0.
        if t_total ne 0.
          if t_bpts ne 0.
            t_ach1 = ( t_spts / t_bpts ) * 100.
          else.
            t_ach1 = 0.
          endif.
          if t_cbpts ne 0.
            t_ach2 = ( t_cspts / t_cbpts ) * 100.
          else.
            t_cbpts = 0.
          endif.
          if t_lcsqty ne 0.
            lgrq = ( t_csqty / t_lcsqty ) * 100 - 100.
          else.
            lgrq = 0.
          endif.
          if t_lcspts ne 0.
            lgrv = ( t_cspts / t_lcspts ) * 100 - 100.
          else.
            lgrv = 0.
          endif.
          clear : grp_name,grp_code.
          if wa_tab18-grp_code = 53.
            grp_name = 'OTHERS EXL'.
          elseif wa_tab18-grp_code = 45.
            grp_name = 'OTHERS BC'.
          else.
            grp_name = 'GROUP TOTAL'.
          endif.

          call function 'WRITE_FORM'
            exporting
              element = 'GR1'
              window  = 'MAIN'.

          t_sqty = 0.
          t_bqty = 0.
          t_spts = 0.
          t_bpts = 0.
          t_csqty = 0.
          t_cspts = 0.
          t_cbqty = 0.
          t_cbpts = 0.
          t_ach1 = 0.
          t_ach2 = 0.
          t_lcspts = 0.
          t_lcsqty = 0.
          lgrv = 0.
          lgrq = 0.
          t_total = 0.
        else.
          call function 'WRITE_FORM'
            exporting
              element = 'GR2'
              window  = 'MAIN'.
          t_sqty = 0.
          t_bqty = 0.
          t_spts = 0.
          t_bpts = 0.
          t_csqty = 0.
          t_cspts = 0.
          t_cbqty = 0.
          t_cbpts = 0.
          t_ach1 = 0.
          t_ach2 = 0.
          t_lcspts = 0.
          t_lcsqty = 0.
          lgrv = 0.
          lgrq = 0.
          t_total = 0.

        endif.
      endif.
    endat.



*    write : /'j', wa_tab18-mvgr4,wa_tab18-bezei,wa_tab18-bezei1,wa_tab18-net_qty,wa_tab18-b_qty,wa_tab18-net_sale,wa_tab18-b_pts.
*    write : wa_tab18-ach1,wa_tab18-cnet_qty,wa_tab18-cb_qty,wa_tab18-cnet_sale,wa_tab18-cb_pts.
*    write : wa_tab18-ach2,wa_tab18-grq,wa_tab18-grv.



    t_total = t_sqty + t_bqty + t_spts + t_bpts + t_csqty + t_cbqty + t_cspts + t_cbpts + t_lcspts + t_lcsqty.

    tot_sqty = tot_sqty + wa_tab18-net_qty.
    tot_bqty = tot_bqty + wa_tab18-b_qty.
    tot_spts = tot_spts + wa_tab18-net_sale.
    tot_bpts = tot_bpts + wa_tab18-b_pts.
    tot_csqty = tot_csqty + wa_tab18-cnet_qty.
    tot_cbqty = tot_cbqty + wa_tab18-cb_qty.
    tot_cspts = tot_cspts + wa_tab18-cnet_sale.
    tot_cbpts = tot_cbpts + wa_tab18-cb_pts.

    tot_lcpts = tot_lcpts + wa_tab18-lcnet_sale.
*    tot_lcbpts = tot_lcbpts + wa_tab18-lcb_pts.

  endloop.
*WRITE : / 'total pts',tot_spts.
  if tot_bpts ne 0.
    tot_ach1 = ( tot_spts / tot_bpts ) * 100.
  endif.
  if tot_cbpts ne 0.
    tot_ach2 = ( tot_cspts / tot_cbpts ) * 100.
  endif.
  if tot_lcqty ne 0.
    tot_gr1 = ( ( tot_csqty / tot_lcqty ) * 100 ) - 100.
  endif.
*  WRITE : / 'a',tot_cspts,tot_lcpts.
  if tot_lcpts ne 0.
    tot_gr2 = ( ( tot_cspts / tot_lcpts ) * 100 ) - 100.
  endif.

*  WRITE : / tot_gr1,tot_gr2.
  call function 'WRITE_FORM'
    exporting
      element = 'TOT1'
      window  = 'MAIN'.
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

  write from_dt to wa_d1 dd/mm/yyyy.
  write to_dt to wa_d2 dd/mm/yyyy.

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
  concatenate 'SR-2 NET FROM:' wa_d1 'TO ' wa_d2  into doc_chng-obj_descr separated by space.
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

  concatenate 'SR-2 NET' '.' into objpack-obj_descr separated by space.
  objpack-doc_size = righe_attachment * 255.
  append objpack.
  clear objpack.

*    loop at it_tam2 into wa_tam2 where pernr = wa_tam1-pernr.
  reclist-receiver =   email.
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

      write : / 'EMAIL SENT ON ',email.
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


endform.                    "NET_EMAIL
*&---------------------------------------------------------------------*
*&      Form  dis_net_alv
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form dis_net_alv.
  select * from zsales_tab1 into table it_zsales_tab1 where datab ge from_dt and datbi le to_dt.
  select * from zcredit_tab2 into table it_zcredit_tab1 where datab ge from_dt and datbi le to_dt.
  select * from zdebit_tab2 into table it_zdebit_tab1 where datab ge from_dt and datbi le to_dt.
  select * from zbudget_tab1 into table it_zbudget_tab1 where datab ge from_dt and datbi le to_dt and tag eq 'N'.

  loop at it_zsales_tab1 into wa_zsales_tab1.

    pts = wa_zsales_tab1-net + wa_zsales_tab1-ed.
    wa_tab11-matnr = wa_zsales_tab1-matnr.
    wa_tab11-pts = pts.
    wa_tab11-qty = wa_zsales_tab1-c_qty.

    wa_tab-matnr = wa_zsales_tab1-matnr.
    collect wa_tab into it_tab.
    clear wa_tab.
    collect wa_tab11 into it_tab11.
    clear wa_tab11.
    clear pts.
  endloop.

*LOOP AT IT_TAB1 INTO WA_TAB1.
*  WRITE : /'SALE', WA_TAB1-MATNR,WA_TAB1-PTS,WA_TAB1-ED,WA_TAB1-C_QTY,WA_TAB1-F_QTY.
*ENDLOOP.

  loop at it_zcredit_tab1 into wa_zcredit_tab1.
    wa_tab12-matnr = wa_zcredit_tab1-matnr.
    wa_tab12-pts = wa_zcredit_tab1-net.
    wa_tab12-qty = wa_zcredit_tab1-qty_c.
    wa_tab-matnr = wa_zcredit_tab1-matnr.
    collect wa_tab into it_tab.
    clear wa_tab.
    collect wa_tab12 into it_tab12.
    clear wa_tab12.
  endloop.


  loop at it_zdebit_tab1 into wa_zdebit_tab1.
    wa_tab13-matnr = wa_zdebit_tab1-matnr.
    wa_tab13-pts = wa_zdebit_tab1-net.
    wa_tab13-qty = wa_zdebit_tab1-qty_c.
    wa_tab-matnr = wa_zdebit_tab1-matnr.
    collect wa_tab into it_tab.
    clear wa_tab.
    collect wa_tab13 into it_tab13.
    clear wa_tab13.

  endloop.

  loop at it_zbudget_tab1 into wa_zbudget_tab1.
    wa_tab14-matnr = wa_zbudget_tab1-matnr.
    wa_tab14-pts = wa_zbudget_tab1-val.
    wa_tab14-qty = wa_zbudget_tab1-qty.
    wa_tab-matnr = wa_zbudget_tab1-matnr.
    collect wa_tab into it_tab.
    clear wa_tab.
    collect wa_tab14 into it_tab14.
    clear wa_tab14.
  endloop.

  loop at it_tab into wa_tab.
    read table it_tab11 into wa_tab11 with key matnr = wa_tab-matnr.  "sale
    if sy-subrc eq 0.
      wa_tab15-matnr = wa_tab11-matnr.
      wa_tab15-s_pts = wa_tab11-pts.
      wa_tab15-s_qty = wa_tab11-qty.
    endif.
    read table it_tab12 into wa_tab12 with key matnr = wa_tab-matnr.  "cn
    if sy-subrc eq 0.
      wa_tab15-matnr = wa_tab12-matnr.
      wa_tab15-c_pts = wa_tab12-pts.
      wa_tab15-c_qty = wa_tab12-qty.
    endif.
    read table it_tab13 into wa_tab13 with key matnr = wa_tab-matnr.  "dn
    if sy-subrc eq 0.
      wa_tab15-matnr = wa_tab13-matnr.
      wa_tab15-d_pts = wa_tab13-pts.
      wa_tab15-d_qty = wa_tab13-qty.
    endif.
    read table it_tab14 into wa_tab14 with key matnr = wa_tab-matnr.  "budget
    if sy-subrc eq 0.
      wa_tab15-matnr = wa_tab14-matnr.
      wa_tab15-b_pts = wa_tab14-pts.
      wa_tab15-b_qty = wa_tab14-qty.
    endif.
    collect wa_tab15 into it_tab15.
    clear wa_tab15.
  endloop.

  loop at it_tab15 into wa_tab15.
    clear : net_sale,net_qty.
*    WRITE : / 'a',wa_TAB15-matnr,WA_TAB15-B_PTS,WA_TAB15-B_QTY,wa_TAB15-s_pts,wa_TAB15-s_qty,wa_TAB15-c_pts,wa_TAB15-c_qty,wa_TAB15-d_pts,
*    wa_TAB15-d_qty.
    net_sale = wa_tab15-s_pts - wa_tab15-c_pts + wa_tab15-d_pts.
    net_qty = wa_tab15-s_qty - wa_tab15-c_qty + wa_tab15-d_qty.
    wa_tab16-matnr = wa_tab15-matnr.
    wa_tab16-b_pts = wa_tab15-b_pts.
    wa_tab16-b_qty = wa_tab15-b_qty.
    wa_tab16-s_pts = wa_tab15-s_pts.
    wa_tab16-s_qty = wa_tab15-s_qty.
    wa_tab16-c_pts = wa_tab15-c_pts.
    wa_tab16-c_qty = wa_tab15-c_qty.
    wa_tab16-d_pts = wa_tab15-d_pts.
    wa_tab16-d_qty = wa_tab15-d_qty.
    wa_tab16-net_sale = net_sale.
    wa_tab16-net_qty = net_qty.
    collect wa_tab16 into it_tab16.
    clear wa_tab16.
  endloop.

  loop at it_tab16 into wa_tab16.
    wa_tab17-matnr = wa_tab16-matnr.
    wa_tab17-b_pts = wa_tab16-b_pts.
    wa_tab17-b_qty = wa_tab16-b_qty.
    wa_tab17-s_pts = wa_tab16-s_pts.
    wa_tab17-s_qty = wa_tab16-s_qty.
    wa_tab17-c_pts = wa_tab16-c_pts.
    wa_tab17-c_qty = wa_tab16-c_qty.
    wa_tab17-d_pts = wa_tab16-d_pts.
    wa_tab17-d_qty = wa_tab16-d_qty.
    wa_tab17-net_sale = wa_tab16-net_sale.
    wa_tab17-net_qty = wa_tab16-net_qty.
    collect wa_tab17 into it_tab17.
    clear wa_tab17.
  endloop.


***************CURRENT MOTH SALE ENDS HERE **********************

*************CUMMULATIVE SALE STARTS HERE***************************
  c_date+6(2) = '01'.
  c_date+4(2) = '04'.

  if from_dt+4(2) lt '04'.
    c_date+0(4) = from_dt+0(4) - 1.
  else.
    c_date+0(4) = from_dt+0(4).
  endif.
*  write : / 'cummulative date',c_date.

  select * from zsales_tab1 into table it_zsales_tab2 where datab ge c_date and datbi le to_dt.
  if it_zsales_tab2 is not initial.
    loop at it_zsales_tab2 into wa_zsales_tab2.
      wa_ctab1-matnr = wa_zsales_tab2-matnr.
      wa_ctab1-pts = wa_zsales_tab2-net + wa_zsales_tab2-ed.
      wa_ctab1-qty = wa_zsales_tab2-c_qty.
      collect wa_ctab1 into it_ctab1.
      clear wa_ctab1.
      wa_ta-matnr = wa_zsales_tab2-matnr.
      collect wa_ta into it_ta.
      clear wa_ta.
    endloop.
  endif.

  select * from zcredit_tab2 into table it_zcredit_tab2 where datab ge c_date and datbi le to_dt.
  if it_zcredit_tab2 is not initial.
    loop at it_zcredit_tab2 into wa_zcredit_tab2.
      wa_ctab2-matnr = wa_zcredit_tab2-matnr.
      wa_ctab2-pts = wa_zcredit_tab2-net.
      wa_ctab2-qty = wa_zcredit_tab2-qty_c.
      collect wa_ctab2 into it_ctab2.
      clear wa_ctab2.
      wa_ta-matnr = wa_zcredit_tab2-matnr.
      collect wa_ta into it_ta.
      clear wa_ta.
    endloop.
  endif.

  select * from zdebit_tab2 into table it_zdebit_tab2 where datab ge c_date and datbi le to_dt.
  if it_zdebit_tab2 is not initial.
    loop at it_zdebit_tab2 into wa_zdebit_tab2.
      wa_ctab3-matnr = wa_zdebit_tab2-matnr.
      wa_ctab3-pts = wa_zdebit_tab2-net.
      wa_ctab3-qty = wa_zdebit_tab2-qty_c.
      collect wa_ctab3 into it_ctab3.
      clear wa_ctab3.
      wa_ta-matnr = wa_zdebit_tab2-matnr.
      collect wa_ta into it_ta.
      clear wa_ta.
    endloop.
  endif.

  select * from zbudget_tab1 into table it_zbudget_tab2 where datab ge c_date and datbi le to_dt and tag eq 'N'.
  if it_zbudget_tab2 is not initial.
    loop at it_zbudget_tab2 into wa_zbudget_tab2.
*      WRITE : / 'budget',c_date,TO_DT,wa_zBUDGET_tab2-matnr,wa_zBUDGET_tab2-qty.
      wa_ctab4-matnr = wa_zbudget_tab2-matnr.
      wa_ctab4-pts = wa_zbudget_tab2-val.
      wa_ctab4-qty = wa_zbudget_tab2-qty.
      collect wa_ctab4 into it_ctab4.
      clear wa_ctab4.
      wa_ta-matnr = wa_zbudget_tab2-matnr.
      collect wa_ta into it_ta.
      clear wa_ta.
    endloop.
  endif.

  sort it_ta.
  delete adjacent duplicates from it_ta.

  loop at it_ta into wa_ta.
    read table it_ctab1 into wa_ctab1 with key matnr = wa_ta-matnr.
    if sy-subrc eq 0.
      wa_ctab5-matnr = wa_ctab1-matnr.
      wa_ctab5-s_pts = wa_ctab1-pts.
      wa_ctab5-s_qty = wa_ctab1-qty.
    endif.
    read table it_ctab2 into wa_ctab2 with key matnr = wa_ta-matnr.
    if sy-subrc eq 0.
      wa_ctab5-matnr = wa_ctab2-matnr.
      wa_ctab5-c_pts = wa_ctab2-pts.
      wa_ctab5-c_qty = wa_ctab2-qty.
    endif.
    read table it_ctab3 into wa_ctab3 with key matnr = wa_ta-matnr.
    if sy-subrc eq 0.
      wa_ctab5-matnr = wa_ctab3-matnr.
      wa_ctab5-d_pts = wa_ctab3-pts.
      wa_ctab5-d_qty = wa_ctab3-qty.
    endif.
    read table it_ctab4 into wa_ctab4 with key matnr = wa_ta-matnr.
    if sy-subrc eq 0.
      wa_ctab5-matnr = wa_ctab4-matnr.
      wa_ctab5-b_pts = wa_ctab4-pts.
      wa_ctab5-b_qty = wa_ctab4-qty.
    endif.
    collect wa_ctab5 into it_ctab5.
    clear wa_ctab5.
  endloop.

  loop at it_ctab5 into wa_ctab5.
    clear : cnet_sale,cnet_qty.
    wa_ctab6-matnr = wa_ctab5-matnr.
    wa_ctab6-s_pts = wa_ctab5-s_pts.
    wa_ctab6-s_qty = wa_ctab5-s_qty.
    wa_ctab6-c_pts = wa_ctab5-c_pts.
    wa_ctab6-c_qty = wa_ctab5-c_qty.
    wa_ctab6-d_pts = wa_ctab5-d_pts.
    wa_ctab6-d_qty = wa_ctab5-d_qty.
    wa_ctab6-b_pts = wa_ctab5-b_pts.
    wa_ctab6-b_qty = wa_ctab5-b_qty.
    cnet_sale = wa_ctab5-s_pts - wa_ctab5-c_pts + wa_ctab5-d_pts.
    cnet_qty = wa_ctab5-s_qty - wa_ctab5-c_qty + wa_ctab5-d_qty.
    wa_ctab6-net_sale = cnet_sale.
    wa_ctab6-net_qty = cnet_qty.
    collect wa_ctab6 into it_ctab6.
    clear wa_ctab6.
  endloop.
  sort it_ctab6 by bezei.

  loop at it_ctab6 into wa_ctab6.
    wa_ctab7-matnr = wa_ctab6-matnr.
    wa_ctab7-s_pts = wa_ctab6-s_pts.
    wa_ctab7-s_qty = wa_ctab6-s_qty.
    wa_ctab7-c_pts = wa_ctab6-c_pts.
    wa_ctab7-c_qty = wa_ctab6-c_qty.
    wa_ctab7-d_pts = wa_ctab6-d_pts.
    wa_ctab7-d_qty = wa_ctab6-d_qty.
    wa_ctab7-b_pts = wa_ctab6-b_pts.
    wa_ctab7-b_qty = wa_ctab6-b_qty.
    wa_ctab7-net_sale = wa_ctab6-net_sale.
    wa_ctab7-net_qty = wa_ctab6-net_qty.
    collect wa_ctab7 into it_ctab7.
    clear wa_ctab7.
  endloop.

*  LOOP AT IT_CTAB7 INTO WA_CTAB7.
*    WRITE : /'a1',wa_tab7-mvgr4,wa_ctab7-bezei,'net',wa_ctab7-net_qty,'sale',WA_CTAB7-S_QTY,'credit',wa_ctab7-c_qty,'debit',wa_ctab7-d_qty,'bud',wa_ctab7-b_qty,wa_ctab7-net_sale,wa_ctab7-b_pts.
*  ENDLOOP.

**************CUMMULATIVE DATA ENDS HERE********************

******************LAST YEAR CUMMULATIVE DATA STARTS*****************

  ll_date = c_date.
  ll_date+0(4) = c_date+0(4) - 1.
  lc_date = to_dt.
  lc_date+0(4) = to_dt+0(4) - 1.
*  write : / 'last fiscal year',ll_date,'last year same date',lc_date.
*WRITE : / 'date',lc_date.

*******************************************************
  clear : ndt1,ndt2.
  ndt1 = lc_date.
  ndt1+6(2) = '01'.
  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date           = ndt1
    importing
*     EV_MONTH_BEGIN_DATE       =
      ev_month_end_date = ndt2.
  lc_date = ndt2.
*************************************************************************

  if lc_date = '20160228'.
    lc_date = '20160229'.
  endif.
*WRITE : / 'date',lc_date.

  select * from zsales_tab1 into table it_zsales_tab3 where datab ge ll_date and datbi le lc_date.
  if it_zsales_tab3 is not initial.
    loop at it_zsales_tab3 into wa_zsales_tab3.
      wa_lctab1-matnr = wa_zsales_tab3-matnr.
      wa_lctab1-pts = wa_zsales_tab3-net + wa_zsales_tab3-ed.
      wa_lctab1-qty = wa_zsales_tab3-c_qty.
      collect wa_lctab1 into it_lctab1.
      clear wa_lctab1.
      wa_t-matnr = wa_zsales_tab3-matnr.
      collect wa_t into it_t.
      clear wa_t.
    endloop.
  endif.

  select * from zcredit_tab2 into table it_zcredit_tab3 where datab ge ll_date and datbi le lc_date.
  if it_zcredit_tab3 is not initial.
    loop at it_zcredit_tab3 into wa_zcredit_tab3.
      wa_lctab2-matnr = wa_zcredit_tab3-matnr.
      wa_lctab2-pts = wa_zcredit_tab3-net.
      wa_lctab2-qty = wa_zcredit_tab3-qty_c.
      collect wa_lctab2 into it_lctab2.
      clear wa_lctab2.
      wa_t-matnr = wa_zcredit_tab3-matnr.
      collect wa_t into it_t.
      clear wa_t.
    endloop.
  endif.

  select * from zdebit_tab2 into table it_zdebit_tab3 where datab ge ll_date and datbi le lc_date.
  if it_zdebit_tab3 is not initial.
    loop at it_zdebit_tab3 into wa_zdebit_tab3.
      wa_lctab3-matnr = wa_zdebit_tab3-matnr.
      wa_lctab3-pts = wa_zdebit_tab3-net.
      wa_lctab3-qty = wa_zdebit_tab3-qty_c.
      collect wa_lctab3 into it_lctab3.
      clear wa_lctab3.
      wa_t-matnr = wa_zdebit_tab3-matnr.
      collect wa_t into it_t.
      clear wa_t.
    endloop.
  endif.


  loop at it_t into wa_t.
    read table it_lctab1 into wa_lctab1 with key matnr = wa_t-matnr.
    if sy-subrc eq 0.
      wa_lctab4-matnr = wa_lctab1-matnr.
      wa_lctab4-s_pts = wa_lctab1-pts.
      wa_lctab4-s_qty = wa_lctab1-qty.
    endif.
    read table it_lctab2 into wa_lctab2 with key matnr = wa_t-matnr.
    if sy-subrc eq 0.
      wa_lctab4-matnr = wa_lctab2-matnr.
      wa_lctab4-c_pts = wa_lctab2-pts.
      wa_lctab4-c_qty = wa_lctab2-qty.
    endif.
    read table it_lctab3 into wa_lctab3 with key matnr = wa_t-matnr.
    if sy-subrc eq 0.
      wa_lctab4-matnr = wa_lctab3-matnr.
      wa_lctab4-d_pts = wa_lctab3-pts.
      wa_lctab4-d_qty = wa_lctab3-qty.
    endif.
    collect wa_lctab4 into it_lctab4.
    clear wa_lctab4.
  endloop.

  loop at it_lctab4 into wa_lctab4.
    clear : lcnet_sale,lcnet_qty.
    wa_lctab5-matnr = wa_lctab4-matnr.
    wa_lctab5-s_pts = wa_lctab4-s_pts.
    wa_lctab5-s_qty = wa_lctab4-s_qty.
    wa_lctab5-c_pts = wa_lctab4-c_pts.
    wa_lctab5-c_qty = wa_lctab4-c_qty.
    wa_lctab5-d_pts = wa_lctab4-d_pts.
    wa_lctab5-d_qty = wa_lctab4-d_qty.
    lcnet_sale = wa_lctab4-s_pts - wa_lctab4-c_pts + wa_lctab4-d_pts.
    lcnet_qty = wa_lctab4-s_qty - wa_lctab4-c_qty + wa_lctab4-d_qty.
    wa_lctab5-net_sale = lcnet_sale.
    wa_lctab5-net_qty = lcnet_qty.
    collect wa_lctab5 into it_lctab5.
    clear wa_lctab5.
  endloop.

  loop at it_lctab5 into wa_lctab5.
*    WRITE : / 'last yeat net sale',wa_lctab5-matnr,wa_lctab5-net_sale.
    wa_lctab6-matnr = wa_lctab5-matnr.
    wa_lctab6-s_pts = wa_lctab5-s_pts.
    wa_lctab6-s_qty = wa_lctab5-s_qty.
    wa_lctab6-c_pts = wa_lctab5-c_pts.
    wa_lctab6-c_qty = wa_lctab5-c_qty.
    wa_lctab6-d_pts = wa_lctab5-d_pts.
    wa_lctab6-d_qty = wa_lctab5-d_qty.
    wa_lctab6-net_sale = wa_lctab5-net_sale.
    wa_lctab6-net_qty = wa_lctab5-net_qty.
    collect wa_lctab6 into it_lctab6.
    clear wa_lctab6.
  endloop.


  sort it_tab17 by matnr .
  loop at it_tab into wa_tab.
    wa_mat1-matnr = wa_tab-matnr.
    collect wa_mat1 into it_mat1.
    clear wa_mat1.
  endloop.
  loop at it_ta into wa_ta.
    wa_mat1-matnr = wa_ta-matnr.
    collect wa_mat1 into it_mat1.
    clear wa_mat1.
  endloop.
  loop at it_t into wa_t.
    wa_mat1-matnr = wa_t-matnr.
    collect wa_mat1 into it_mat1.
    clear wa_mat1.
  endloop.

  sort it_mat1 by matnr.
  delete adjacent duplicates from it_mat1 comparing matnr.

  sort it_tab17 by matnr.
  sort it_ctab6 by matnr.
  sort it_lctab6 by matnr.

  loop at it_mat1 into wa_mat1.
*    WRITE : / 'material',wa_mat1-matnr.
    clear : ach1,ach2,grq,grv.
*  loop at it_tab17 into wa_tab17.
    read table it_tab17 into wa_tab17 with key matnr = wa_mat1-matnr.
    if sy-subrc eq 0.
      wa_tab181-matnr = wa_tab17-matnr.
      wa_tab181-net_qty = wa_tab17-net_qty.
      wa_tab181-net_sale = wa_tab17-net_sale.
      wa_tab181-b_qty = wa_tab17-b_qty.
      wa_tab181-b_pts = wa_tab17-b_pts.
    endif.

    read table it_ctab7 into wa_ctab7 with key matnr = wa_mat1-matnr.
    if sy-subrc eq 0.
      wa_tab181-matnr = wa_ctab7-matnr.
      wa_tab181-cnet_qty = wa_ctab7-net_qty.
      wa_tab181-cnet_sale = wa_ctab7-net_sale.
      wa_tab181-cb_qty = wa_ctab7-b_qty.
      wa_tab181-cb_pts = wa_ctab7-b_pts.
    endif.

    read table it_lctab6 into wa_lctab6 with key matnr = wa_mat1-matnr.
    if sy-subrc eq 0.
*      WRITE : / 'found',wa_lctab6-matnr,wa_lctab6-mvgr4,wa_lctab6-net_sale.
      wa_tab181-matnr = wa_lctab6-matnr.
      wa_tab181-lcnet_sale = wa_lctab6-net_sale.
      wa_tab181-lcnet_qty = wa_lctab6-net_qty.
    endif.

    collect wa_tab181 into it_tab181.
    clear wa_tab181.
  endloop.

  loop at it_tab181 into wa_tab181 where matnr ne '                  '.

    wa_tab182-matnr = wa_tab181-matnr.
    wa_tab182-net_qty = wa_tab181-net_qty.
    wa_tab182-net_sale = wa_tab181-net_sale.
    wa_tab182-b_qty = wa_tab181-b_qty.
    wa_tab182-b_pts = wa_tab181-b_pts.
    wa_tab182-cnet_qty = wa_tab181-cnet_qty.
    wa_tab182-cb_qty = wa_tab181-cb_qty.
    wa_tab182-cnet_sale = wa_tab181-cnet_sale.
    wa_tab182-cb_pts = wa_tab181-cb_pts.
    wa_tab182-lcnet_sale = wa_tab181-lcnet_sale.
    wa_tab182-lcnet_qty = wa_tab181-lcnet_qty.

    select single * from mara where matnr eq wa_tab181-matnr.
    if sy-subrc eq 0.
      wa_tab182-spart = mara-spart.
    endif.

    select single * from zprdgroup where rep_type eq 'SR2' and prd_code eq mara-matnr.
    if sy-subrc eq 0.
      wa_tab182-prn_seq = zprdgroup-prn_seq.
      wa_tab182-grp_code = zprdgroup-grp_code.
*      WRITE : / 'material',wa_tab181-matnr,ZPRDGROUP-PRN_SEQ,ZPRDGROUP-GRP_CODE, WA_TAB182-PRN_SEQ,WA_TAB182-GRP_CODE .
    else.
      format color 6.
      write :  'MATERIL CODE NOT MAINTAINED IN ZPRDGROUP',wa_tab181-matnr.
    endif.

    select single * from mvke where matnr eq wa_tab181-matnr and vkorg eq '1000' and vtweg eq '10' .
    if sy-subrc eq 0.
      select single * from tvm5t where spras eq 'EN' and mvgr5 eq mvke-mvgr5.
      if sy-subrc eq 0.
        wa_tab182-bezei = tvm5t-bezei.
      endif.
    endif.

    select single * from mvke where matnr eq wa_tab181-matnr and vkorg eq '1000' and vtweg eq '10' .
    if sy-subrc eq 0.
      wa_tab182-mvgr4 = mvke-mvgr4.
    endif.

    select single * from tvm4t where spras eq 'EN' and mvgr4 eq wa_tab182-mvgr4.
    if sy-subrc eq 0.
      wa_tab182-maktx = tvm4t-bezei.
    else.
      format color 6.
      write : / 'PRODUCT DESCRIPTIO NOT FOUND FOR ',wa_tab181-matnr.
    endif.

    collect wa_tab182 into it_tab182.
    clear wa_tab182.
  endloop.

  sort it_tab182 by spart prn_seq grp_code.
  loop at it_tab182 into wa_tab182.
    clear : ach1,ach2,grq,grv.
*    FORMAT COLOR 1.
*    WRITE : / '182',WA_TAB182-mvgr4,WA_TAB182-spart,WA_TAB182-prn_seq,WA_TAB182-grp_code,wa_tab182-bezei,wa_tab182-maktx.
    wa_tab18-matnr = wa_tab182-matnr.
    wa_tab18-mvgr4 = wa_tab182-mvgr4.
    wa_tab18-bezei = wa_tab182-bezei.
    wa_tab18-maktx = wa_tab182-maktx.
    wa_tab18-spart = wa_tab182-spart.
    wa_tab18-prn_seq = wa_tab182-prn_seq.
    wa_tab18-grp_code = wa_tab182-grp_code.
    wa_tab18-net_qty = wa_tab182-net_qty.
    wa_tab18-net_sale = wa_tab182-net_sale.
    wa_tab18-b_qty = wa_tab182-b_qty.
    wa_tab18-b_pts = wa_tab182-b_pts.
    wa_tab18-cnet_qty = wa_tab182-cnet_qty.
    wa_tab18-cb_qty = wa_tab182-cb_qty.
    wa_tab18-cnet_sale = wa_tab182-cnet_sale.
    wa_tab18-cb_pts = wa_tab182-cb_pts.
    wa_tab18-lcnet_sale = wa_tab182-lcnet_sale.
    wa_tab18-lcnet_qty = wa_tab182-lcnet_qty.

    if wa_tab18-b_pts ne 0.
      ach1 = ( wa_tab18-net_sale / wa_tab18-b_pts ) * 100.
    endif.
    wa_tab18-ach1 = ach1.
    if wa_tab18-cb_pts ne 0.
      ach2 = ( wa_tab18-cnet_sale / wa_tab18-cb_pts ) * 100.
    endif.
    wa_tab18-ach2 = ach2.
    if wa_tab18-lcnet_qty ne 0.
      grq = ( wa_tab18-cnet_qty / wa_tab18-lcnet_qty ) * 100 - 100.
    endif.
    wa_tab18-grq = grq.
    if wa_tab18-lcnet_sale ne 0.
      grv = ( wa_tab18-cnet_sale / wa_tab18-lcnet_sale ) * 100 - 100.
    endif.
    wa_tab18-grv = grv.

    collect wa_tab18 into it_tab18.
    clear wa_tab18.
  endloop.

  sort it_tab18 by spart prn_seq grp_code maktx.


  sort it_tab8 by prn_seq.
  loop at it_tab18 into wa_tab18.
    pack wa_tab18-matnr to wa_tab18-matnr.
    condense wa_tab18-matnr.
    modify it_tab18 from wa_tab18 transporting matnr.
*    WRITE : /'j', WA_tab18-MVGR4,WA_tab18-BEZEI,wa_tab18-bezei1,WA_tab18-net_qty,wa_tab18-b_qty,wa_tab18-net_sale,wa_tab18-b_pts.
*    WRITE : wa_tab18-ach1,wa_tab18-cnet_qty,wa_tab18-cb_qty,wa_tab18-cnet_sale,wa_tab18-cb_pts.
*    WRITE : wa_tab18-ach2,wa_tab18-grq,wa_tab18-grv.
  endloop.

  wa_fieldcat-fieldname = 'MVGR4'.
  wa_fieldcat-seltext_l = 'GROUP4'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_l = 'CODE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MAKTX'.
  wa_fieldcat-seltext_l = 'DESCRIPTION'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'BEZEI'.
  wa_fieldcat-seltext_l = 'PACK SIZE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'GRP_CODE'.
  wa_fieldcat-seltext_l = 'GROUP CODE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'PRN_SEQ'.
  wa_fieldcat-seltext_l = 'PRN SEQUENCE'.
  append wa_fieldcat to fieldcat.
*
  wa_fieldcat-fieldname = 'NET_QTY'.
  wa_fieldcat-seltext_l = 'UNIT SALE THIS MTH'.
  append wa_fieldcat to fieldcat.
**
  wa_fieldcat-fieldname = 'B_QTY'.
  wa_fieldcat-seltext_l = 'UNIT BUDGET THIS MONTH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'NET_SALE'.
  wa_fieldcat-seltext_l = 'VALUE SALE THIS MONTH'.
  append wa_fieldcat to fieldcat.
*
  wa_fieldcat-fieldname = 'B_PTS'.
  wa_fieldcat-seltext_l = 'VALUE BUDGET THIS MONTH'.
  append wa_fieldcat to fieldcat.
*
  wa_fieldcat-fieldname = 'ACH1'.
  wa_fieldcat-seltext_l = '% ACH1.'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CNET_QTY'.
  wa_fieldcat-seltext_l = 'UNIT SALE THIS YTD.'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CB_QTY'.
  wa_fieldcat-seltext_l = 'UNIT BUDGET THIS YTD.'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CNET_SALE'.
  wa_fieldcat-seltext_l = 'VALUE SALE THIS YTD.'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CB_PTS'.
  wa_fieldcat-seltext_l = 'VALUE BUDGET THIS YTD.'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'ACH2'.
  wa_fieldcat-seltext_l = '& ACH2.'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LCNET_SALE'.
  wa_fieldcat-seltext_l = 'LY CUMM SALE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LCNET_QTY'.
  wa_fieldcat-seltext_l = 'LY CUMM QTY'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'GRQ'.
  wa_fieldcat-seltext_l = 'UNIT GR THIS YTD.'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'GRV'.
  wa_fieldcat-seltext_l = 'VALUE GR THIS YTD.'.
  append wa_fieldcat to fieldcat.


  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'SR-2 : COMPANY SALES (NET-GL) - PRODUCTWISE'..


  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = g_repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
      i_callback_user_command = 'USER_COMM'
      i_callback_top_of_page  = 'TOP1'
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
      t_outtab                = it_tab18
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.







endform.                    "dis_net_alv

*&---------------------------------------------------------------------*
*&      Form  NET_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form net_alv.

  select * from zsales_tab1 into table it_zsales_tab1 where datab ge from_dt and datbi le to_dt.
  select * from zcredit_tab1 into table it_zcredit_tab1 where datab ge from_dt and datbi le to_dt.
  select * from zdebit_tab1 into table it_zdebit_tab1 where datab ge from_dt and datbi le to_dt.
  select * from zbudget_tab1 into table it_zbudget_tab1 where datab ge from_dt and datbi le to_dt and tag eq 'N'.

  loop at it_zsales_tab1 into wa_zsales_tab1.

    pts = wa_zsales_tab1-net + wa_zsales_tab1-ed.
    wa_tab11-matnr = wa_zsales_tab1-matnr.
    wa_tab11-pts = pts.
    wa_tab11-qty = wa_zsales_tab1-c_qty.
    wa_tab11-f_qty = wa_zsales_tab1-f_qty.
    wa_tab-matnr = wa_zsales_tab1-matnr.
    collect wa_tab into it_tab.
    clear wa_tab.
    collect wa_tab11 into it_tab11.
    clear wa_tab11.
    clear pts.
  endloop.

*LOOP AT IT_TAB1 INTO WA_TAB1.
*  WRITE : /'SALE', WA_TAB1-MATNR,WA_TAB1-PTS,WA_TAB1-ED,WA_TAB1-C_QTY,WA_TAB1-F_QTY.
*ENDLOOP.

  loop at it_zcredit_tab1 into wa_zcredit_tab1.
    wa_tab12-matnr = wa_zcredit_tab1-matnr.
    wa_tab12-pts = wa_zcredit_tab1-net.
    wa_tab12-qty = wa_zcredit_tab1-qty_c.
    wa_tab-matnr = wa_zcredit_tab1-matnr.
    collect wa_tab into it_tab.
    clear wa_tab.
    collect wa_tab12 into it_tab12.
    clear wa_tab12.
  endloop.


  loop at it_zdebit_tab1 into wa_zdebit_tab1.
    wa_tab13-matnr = wa_zdebit_tab1-matnr.
    wa_tab13-pts = wa_zdebit_tab1-net.
    wa_tab13-qty = wa_zdebit_tab1-qty_c.
    wa_tab-matnr = wa_zdebit_tab1-matnr.
    collect wa_tab into it_tab.
    clear wa_tab.
    collect wa_tab13 into it_tab13.
    clear wa_tab13.

  endloop.

  loop at it_zbudget_tab1 into wa_zbudget_tab1.
    wa_tab14-matnr = wa_zbudget_tab1-matnr.
    wa_tab14-pts = wa_zbudget_tab1-val.
    wa_tab14-qty = wa_zbudget_tab1-qty.
    wa_tab-matnr = wa_zbudget_tab1-matnr.
    collect wa_tab into it_tab.
    clear wa_tab.
    collect wa_tab14 into it_tab14.
    clear wa_tab14.
  endloop.

  loop at it_tab into wa_tab.
    read table it_tab11 into wa_tab11 with key matnr = wa_tab-matnr.  "sale
    if sy-subrc eq 0.
      wa_tab15-matnr = wa_tab11-matnr.
      wa_tab15-s_pts = wa_tab11-pts.
      wa_tab15-s_qty = wa_tab11-qty.
      wa_tab15-f_qty = wa_tab11-f_qty.
    endif.
    read table it_tab12 into wa_tab12 with key matnr = wa_tab-matnr.  "cn
    if sy-subrc eq 0.
      wa_tab15-matnr = wa_tab12-matnr.
      wa_tab15-c_pts = wa_tab12-pts.
      wa_tab15-c_qty = wa_tab12-qty.
    endif.
    read table it_tab13 into wa_tab13 with key matnr = wa_tab-matnr.  "dn
    if sy-subrc eq 0.
      wa_tab15-matnr = wa_tab13-matnr.
      wa_tab15-d_pts = wa_tab13-pts.
      wa_tab15-d_qty = wa_tab13-qty.
    endif.
    read table it_tab14 into wa_tab14 with key matnr = wa_tab-matnr.  "budget
    if sy-subrc eq 0.
      wa_tab15-matnr = wa_tab14-matnr.
      wa_tab15-b_pts = wa_tab14-pts.
      wa_tab15-b_qty = wa_tab14-qty.
    endif.
    collect wa_tab15 into it_tab15.
    clear wa_tab15.
  endloop.

  loop at it_tab15 into wa_tab15.
    clear : net_sale,net_qty.
*    WRITE : / 'a',wa_TAB15-matnr,WA_TAB15-B_PTS,WA_TAB15-B_QTY,wa_TAB15-s_pts,wa_TAB15-s_qty,wa_TAB15-c_pts,wa_TAB15-c_qty,wa_TAB15-d_pts,
*    wa_TAB15-d_qty.
    net_sale = wa_tab15-s_pts - wa_tab15-c_pts + wa_tab15-d_pts.
    net_qty = wa_tab15-s_qty - wa_tab15-c_qty + wa_tab15-d_qty.
    wa_tab16-matnr = wa_tab15-matnr.
    wa_tab16-b_pts = wa_tab15-b_pts.
    wa_tab16-b_qty = wa_tab15-b_qty.
    wa_tab16-s_pts = wa_tab15-s_pts.
    wa_tab16-s_qty = wa_tab15-s_qty.
    wa_tab16-f_qty = wa_tab15-f_qty.
    wa_tab16-c_pts = wa_tab15-c_pts.
    wa_tab16-c_qty = wa_tab15-c_qty.
    wa_tab16-d_pts = wa_tab15-d_pts.
    wa_tab16-d_qty = wa_tab15-d_qty.
    wa_tab16-net_sale = net_sale.
    wa_tab16-net_qty = net_qty.
    collect wa_tab16 into it_tab16.
    clear wa_tab16.
  endloop.

  loop at it_tab16 into wa_tab16.
    wa_tab17-matnr = wa_tab16-matnr.
    wa_tab17-b_pts = wa_tab16-b_pts.
    wa_tab17-b_qty = wa_tab16-b_qty.
    wa_tab17-s_pts = wa_tab16-s_pts.
    wa_tab17-s_qty = wa_tab16-s_qty.
    wa_tab17-f_qty = wa_tab16-f_qty.
    wa_tab17-c_pts = wa_tab16-c_pts.
    wa_tab17-c_qty = wa_tab16-c_qty.
    wa_tab17-d_pts = wa_tab16-d_pts.
    wa_tab17-d_qty = wa_tab16-d_qty.
    wa_tab17-net_sale = wa_tab16-net_sale.
    wa_tab17-net_qty = wa_tab16-net_qty.
    collect wa_tab17 into it_tab17.
    clear wa_tab17.
  endloop.


***************CURRENT MOTH SALE ENDS HERE **********************

*************CUMMULATIVE SALE STARTS HERE***************************
  c_date+6(2) = '01'.
  c_date+4(2) = '04'.

  if from_dt+4(2) lt '04'.
    c_date+0(4) = from_dt+0(4) - 1.
  else.
    c_date+0(4) = from_dt+0(4).
  endif.
*  write : / 'cummulative date',c_date.

  select * from zsales_tab1 into table it_zsales_tab2 where datab ge c_date and datbi le to_dt.
  if it_zsales_tab2 is not initial.
    loop at it_zsales_tab2 into wa_zsales_tab2.
      wa_ctab1-matnr = wa_zsales_tab2-matnr.
      wa_ctab1-pts = wa_zsales_tab2-net + wa_zsales_tab2-ed.
      wa_ctab1-qty = wa_zsales_tab2-c_qty.
      wa_ctab1-f_qty = wa_zsales_tab2-f_qty.
      collect wa_ctab1 into it_ctab1.
      clear wa_ctab1.
      wa_ta-matnr = wa_zsales_tab2-matnr.
      collect wa_ta into it_ta.
      clear wa_ta.
    endloop.
  endif.

  select * from zcredit_tab1 into table it_zcredit_tab2 where datab ge c_date and datbi le to_dt.
  if it_zcredit_tab2 is not initial.
    loop at it_zcredit_tab2 into wa_zcredit_tab2.
      wa_ctab2-matnr = wa_zcredit_tab2-matnr.
      wa_ctab2-pts = wa_zcredit_tab2-net.
      wa_ctab2-qty = wa_zcredit_tab2-qty_c.
      collect wa_ctab2 into it_ctab2.
      clear wa_ctab2.
      wa_ta-matnr = wa_zcredit_tab2-matnr.
      collect wa_ta into it_ta.
      clear wa_ta.
    endloop.
  endif.

  select * from zdebit_tab1 into table it_zdebit_tab2 where datab ge c_date and datbi le to_dt.
  if it_zdebit_tab2 is not initial.
    loop at it_zdebit_tab2 into wa_zdebit_tab2.
      wa_ctab3-matnr = wa_zdebit_tab2-matnr.
      wa_ctab3-pts = wa_zdebit_tab2-net.
      wa_ctab3-qty = wa_zdebit_tab2-qty_c.
      collect wa_ctab3 into it_ctab3.
      clear wa_ctab3.
      wa_ta-matnr = wa_zdebit_tab2-matnr.
      collect wa_ta into it_ta.
      clear wa_ta.
    endloop.
  endif.

  select * from zbudget_tab1 into table it_zbudget_tab2 where datab ge c_date and datbi le to_dt and tag eq 'N'.
  if it_zbudget_tab2 is not initial.
    loop at it_zbudget_tab2 into wa_zbudget_tab2.
*      WRITE : / 'budget',c_date,TO_DT,wa_zBUDGET_tab2-matnr,wa_zBUDGET_tab2-qty.
      wa_ctab4-matnr = wa_zbudget_tab2-matnr.
      wa_ctab4-pts = wa_zbudget_tab2-val.
      wa_ctab4-qty = wa_zbudget_tab2-qty.
      collect wa_ctab4 into it_ctab4.
      clear wa_ctab4.
      wa_ta-matnr = wa_zbudget_tab2-matnr.
      collect wa_ta into it_ta.
      clear wa_ta.
    endloop.
  endif.

  sort it_ta.
  delete adjacent duplicates from it_ta.

  loop at it_ta into wa_ta.
    read table it_ctab1 into wa_ctab1 with key matnr = wa_ta-matnr.
    if sy-subrc eq 0.
      wa_ctab5-matnr = wa_ctab1-matnr.
      wa_ctab5-s_pts = wa_ctab1-pts.
      wa_ctab5-s_qty = wa_ctab1-qty.
      wa_ctab5-f_qty = wa_ctab1-f_qty.
    endif.
    read table it_ctab2 into wa_ctab2 with key matnr = wa_ta-matnr.
    if sy-subrc eq 0.
      wa_ctab5-matnr = wa_ctab2-matnr.
      wa_ctab5-c_pts = wa_ctab2-pts.
      wa_ctab5-c_qty = wa_ctab2-qty.
    endif.
    read table it_ctab3 into wa_ctab3 with key matnr = wa_ta-matnr.
    if sy-subrc eq 0.
      wa_ctab5-matnr = wa_ctab3-matnr.
      wa_ctab5-d_pts = wa_ctab3-pts.
      wa_ctab5-d_qty = wa_ctab3-qty.
    endif.
    read table it_ctab4 into wa_ctab4 with key matnr = wa_ta-matnr.
    if sy-subrc eq 0.
      wa_ctab5-matnr = wa_ctab4-matnr.
      wa_ctab5-b_pts = wa_ctab4-pts.
      wa_ctab5-b_qty = wa_ctab4-qty.
    endif.
    collect wa_ctab5 into it_ctab5.
    clear wa_ctab5.
  endloop.

  loop at it_ctab5 into wa_ctab5.
    clear : cnet_sale,cnet_qty.
    wa_ctab6-matnr = wa_ctab5-matnr.
    wa_ctab6-s_pts = wa_ctab5-s_pts.
    wa_ctab6-s_qty = wa_ctab5-s_qty.
    wa_ctab6-f_qty = wa_ctab5-f_qty.
    wa_ctab6-c_pts = wa_ctab5-c_pts.
    wa_ctab6-c_qty = wa_ctab5-c_qty.
    wa_ctab6-d_pts = wa_ctab5-d_pts.
    wa_ctab6-d_qty = wa_ctab5-d_qty.
    wa_ctab6-b_pts = wa_ctab5-b_pts.
    wa_ctab6-b_qty = wa_ctab5-b_qty.
    cnet_sale = wa_ctab5-s_pts - wa_ctab5-c_pts + wa_ctab5-d_pts.
    cnet_qty = wa_ctab5-s_qty - wa_ctab5-c_qty + wa_ctab5-d_qty.
    wa_ctab6-net_sale = cnet_sale.
    wa_ctab6-net_qty = cnet_qty.
    collect wa_ctab6 into it_ctab6.
    clear wa_ctab6.
  endloop.
  sort it_ctab6 by bezei.

  loop at it_ctab6 into wa_ctab6.
    wa_ctab7-matnr = wa_ctab6-matnr.
    wa_ctab7-s_pts = wa_ctab6-s_pts.
    wa_ctab7-s_qty = wa_ctab6-s_qty.
    wa_ctab7-f_qty = wa_ctab6-f_qty.
    wa_ctab7-c_pts = wa_ctab6-c_pts.
    wa_ctab7-c_qty = wa_ctab6-c_qty.
    wa_ctab7-d_pts = wa_ctab6-d_pts.
    wa_ctab7-d_qty = wa_ctab6-d_qty.
    wa_ctab7-b_pts = wa_ctab6-b_pts.
    wa_ctab7-b_qty = wa_ctab6-b_qty.
    wa_ctab7-net_sale = wa_ctab6-net_sale.
    wa_ctab7-net_qty = wa_ctab6-net_qty.
    collect wa_ctab7 into it_ctab7.
    clear wa_ctab7.
  endloop.

*  LOOP AT IT_CTAB7 INTO WA_CTAB7.
*    WRITE : /'a1',wa_tab7-mvgr4,wa_ctab7-bezei,'net',wa_ctab7-net_qty,'sale',WA_CTAB7-S_QTY,'credit',wa_ctab7-c_qty,'debit',wa_ctab7-d_qty,'bud',wa_ctab7-b_qty,wa_ctab7-net_sale,wa_ctab7-b_pts.
*  ENDLOOP.

**************CUMMULATIVE DATA ENDS HERE********************

******************LAST YEAR CUMMULATIVE DATA STARTS*****************

  ll_date = c_date.
  ll_date+0(4) = c_date+0(4) - 1.
  lc_date = to_dt.
  lc_date+0(4) = to_dt+0(4) - 1.
*  write : / 'last fiscal year',ll_date,'last year same date',lc_date.

*******************************************************
  clear : ndt1,ndt2.
  ndt1 = lc_date.
  ndt1+6(2) = '01'.
  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date           = ndt1
    importing
*     EV_MONTH_BEGIN_DATE       =
      ev_month_end_date = ndt2.
  lc_date = ndt2.
*************************************************************************

*WRITE : / 'date',lc_date.
  if lc_date = '20160228'.
    lc_date = '20160229'.
  endif.
*WRITE : / 'date',lc_date.

  select * from zsales_tab1 into table it_zsales_tab3 where datab ge ll_date and datbi le lc_date.
  if it_zsales_tab3 is not initial.
    loop at it_zsales_tab3 into wa_zsales_tab3.
      wa_lctab1-matnr = wa_zsales_tab3-matnr.
      wa_lctab1-pts = wa_zsales_tab3-net + wa_zsales_tab3-ed.
      wa_lctab1-qty = wa_zsales_tab3-c_qty.
      wa_lctab1-f_qty = wa_zsales_tab3-f_qty.
      collect wa_lctab1 into it_lctab1.
      clear wa_lctab1.
      wa_t-matnr = wa_zsales_tab3-matnr.
      collect wa_t into it_t.
      clear wa_t.
    endloop.
  endif.

  select * from zcredit_tab1 into table it_zcredit_tab3 where datab ge ll_date and datbi le lc_date.
  if it_zcredit_tab3 is not initial.
    loop at it_zcredit_tab3 into wa_zcredit_tab3.
      wa_lctab2-matnr = wa_zcredit_tab3-matnr.
      wa_lctab2-pts = wa_zcredit_tab3-net.
      wa_lctab2-qty = wa_zcredit_tab3-qty_c.
      collect wa_lctab2 into it_lctab2.
      clear wa_lctab2.
      wa_t-matnr = wa_zcredit_tab3-matnr.
      collect wa_t into it_t.
      clear wa_t.
    endloop.
  endif.

  select * from zdebit_tab1 into table it_zdebit_tab3 where datab ge ll_date and datbi le lc_date.
  if it_zdebit_tab3 is not initial.
    loop at it_zdebit_tab3 into wa_zdebit_tab3.
      wa_lctab3-matnr = wa_zdebit_tab3-matnr.
      wa_lctab3-pts = wa_zdebit_tab3-net.
      wa_lctab3-qty = wa_zdebit_tab3-qty_c.
      collect wa_lctab3 into it_lctab3.
      clear wa_lctab3.
      wa_t-matnr = wa_zdebit_tab3-matnr.
      collect wa_t into it_t.
      clear wa_t.
    endloop.
  endif.


  loop at it_t into wa_t.
    read table it_lctab1 into wa_lctab1 with key matnr = wa_t-matnr.
    if sy-subrc eq 0.
      wa_lctab4-matnr = wa_lctab1-matnr.
      wa_lctab4-s_pts = wa_lctab1-pts.
      wa_lctab4-s_qty = wa_lctab1-qty.
      wa_lctab4-f_qty = wa_lctab1-f_qty.
    endif.
    read table it_lctab2 into wa_lctab2 with key matnr = wa_t-matnr.
    if sy-subrc eq 0.
      wa_lctab4-matnr = wa_lctab2-matnr.
      wa_lctab4-c_pts = wa_lctab2-pts.
      wa_lctab4-c_qty = wa_lctab2-qty.
    endif.
    read table it_lctab3 into wa_lctab3 with key matnr = wa_t-matnr.
    if sy-subrc eq 0.
      wa_lctab4-matnr = wa_lctab3-matnr.
      wa_lctab4-d_pts = wa_lctab3-pts.
      wa_lctab4-d_qty = wa_lctab3-qty.
    endif.
    collect wa_lctab4 into it_lctab4.
    clear wa_lctab4.
  endloop.

  loop at it_lctab4 into wa_lctab4.
    clear : lcnet_sale,lcnet_qty.
    wa_lctab5-matnr = wa_lctab4-matnr.
    wa_lctab5-s_pts = wa_lctab4-s_pts.
    wa_lctab5-s_qty = wa_lctab4-s_qty.
    wa_lctab5-f_qty = wa_lctab4-f_qty.
    wa_lctab5-c_pts = wa_lctab4-c_pts.
    wa_lctab5-c_qty = wa_lctab4-c_qty.
    wa_lctab5-d_pts = wa_lctab4-d_pts.
    wa_lctab5-d_qty = wa_lctab4-d_qty.
    lcnet_sale = wa_lctab4-s_pts - wa_lctab4-c_pts + wa_lctab4-d_pts.
    if r11 = 'X'.
      lcnet_qty = wa_lctab4-s_qty - wa_lctab4-c_qty + wa_lctab4-d_qty + wa_lctab4-f_qty.
    else.
      lcnet_qty = wa_lctab4-s_qty - wa_lctab4-c_qty + wa_lctab4-d_qty.
    endif.
    wa_lctab5-net_sale = lcnet_sale.
    wa_lctab5-net_qty = lcnet_qty.
    collect wa_lctab5 into it_lctab5.
    clear wa_lctab5.
  endloop.

  loop at it_lctab5 into wa_lctab5.
*    WRITE : / 'last yeat net sale',wa_lctab5-matnr,wa_lctab5-net_sale.
    wa_lctab6-matnr = wa_lctab5-matnr.
    wa_lctab6-s_pts = wa_lctab5-s_pts.
    wa_lctab6-s_qty = wa_lctab5-s_qty.
    wa_lctab6-f_qty = wa_lctab5-f_qty.
    wa_lctab6-c_pts = wa_lctab5-c_pts.
    wa_lctab6-c_qty = wa_lctab5-c_qty.
    wa_lctab6-d_pts = wa_lctab5-d_pts.
    wa_lctab6-d_qty = wa_lctab5-d_qty.
    wa_lctab6-net_sale = wa_lctab5-net_sale.
    wa_lctab6-net_qty = wa_lctab5-net_qty.
    collect wa_lctab6 into it_lctab6.
    clear wa_lctab6.
  endloop.


  sort it_tab17 by matnr .
  loop at it_tab into wa_tab.
    wa_mat1-matnr = wa_tab-matnr.
    collect wa_mat1 into it_mat1.
    clear wa_mat1.
  endloop.
  loop at it_ta into wa_ta.
    wa_mat1-matnr = wa_ta-matnr.
    collect wa_mat1 into it_mat1.
    clear wa_mat1.
  endloop.
  loop at it_t into wa_t.
    wa_mat1-matnr = wa_t-matnr.
    collect wa_mat1 into it_mat1.
    clear wa_mat1.
  endloop.

  sort it_mat1 by matnr.
  delete adjacent duplicates from it_mat1 comparing matnr.

  sort it_tab17 by matnr.
  sort it_ctab6 by matnr.
  sort it_lctab6 by matnr.

  loop at it_mat1 into wa_mat1.
*    WRITE : / 'material',wa_mat1-matnr.
    clear : ach1,ach2,grq,grv.
*  loop at it_tab17 into wa_tab17.
    read table it_tab17 into wa_tab17 with key matnr = wa_mat1-matnr.
    if sy-subrc eq 0.
      wa_tab181-matnr = wa_tab17-matnr.
      wa_tab181-net_qty = wa_tab17-net_qty.
      wa_tab181-net_sale = wa_tab17-net_sale.
      wa_tab181-b_qty = wa_tab17-b_qty.
      wa_tab181-b_pts = wa_tab17-b_pts.
    endif.

    read table it_ctab7 into wa_ctab7 with key matnr = wa_mat1-matnr.
    if sy-subrc eq 0.
      wa_tab181-matnr = wa_ctab7-matnr.
      wa_tab181-cnet_qty = wa_ctab7-net_qty.
      wa_tab181-cnet_sale = wa_ctab7-net_sale.
      wa_tab181-cb_qty = wa_ctab7-b_qty.
      wa_tab181-cb_pts = wa_ctab7-b_pts.
    endif.

    read table it_lctab6 into wa_lctab6 with key matnr = wa_mat1-matnr.
    if sy-subrc eq 0.
*      WRITE : / 'found',wa_lctab6-matnr,wa_lctab6-mvgr4,wa_lctab6-net_sale.
      wa_tab181-matnr = wa_lctab6-matnr.
      wa_tab181-lcnet_sale = wa_lctab6-net_sale.
      wa_tab181-lcnet_qty = wa_lctab6-net_qty.
    endif.

    collect wa_tab181 into it_tab181.
    clear wa_tab181.
  endloop.

  loop at it_tab181 into wa_tab181 where matnr ne '                  '.

*    WA_TAB182-MATNR = WA_TAB181-MATNR.
    wa_tab182-net_qty = wa_tab181-net_qty.
    wa_tab182-net_sale = wa_tab181-net_sale.
    wa_tab182-b_qty = wa_tab181-b_qty.
    wa_tab182-b_pts = wa_tab181-b_pts.
    wa_tab182-cnet_qty = wa_tab181-cnet_qty.
    wa_tab182-cb_qty = wa_tab181-cb_qty.
    wa_tab182-cnet_sale = wa_tab181-cnet_sale.
    wa_tab182-cb_pts = wa_tab181-cb_pts.
    wa_tab182-lcnet_sale = wa_tab181-lcnet_sale.
    wa_tab182-lcnet_qty = wa_tab181-lcnet_qty.

    select single * from mara where matnr eq wa_tab181-matnr.
    if sy-subrc eq 0.
      wa_tab182-spart = mara-spart.
      wa_tab182-matkl = mara-matkl.
    endif.

    select single * from zprdgroup where rep_type eq 'SR2' and prd_code eq mara-matnr.
    if sy-subrc eq 0.
      wa_tab182-prn_seq = zprdgroup-prn_seq.
      wa_tab182-grp_code = zprdgroup-grp_code.
      wa_tab182-subgrp_name = zprdgroup-subgrp_name.
*      WRITE : / 'material',wa_tab181-matnr,ZPRDGROUP-PRN_SEQ,ZPRDGROUP-GRP_CODE, WA_TAB182-PRN_SEQ,WA_TAB182-GRP_CODE .
    else.
      format color 6.
      write :  'MATERIL CODE NOT MAINTAINED IN ZPRDGROUP',wa_tab181-matnr.
    endif.

*    SELECT SINGLE * FROM MVKE WHERE MATNR EQ WA_TAB181-MATNR AND VKORG EQ '1000' AND VTWEG EQ '10' .
*    IF SY-SUBRC EQ 0.
*      SELECT SINGLE * FROM TVM5T WHERE SPRAS EQ 'EN' AND MVGR5 EQ MVKE-MVGR5.
*      IF SY-SUBRC EQ 0.
*        WA_TAB182-BEZEI = TVM5T-BEZEI.
*      ENDIF.
*    ENDIF.

*    SELECT SINGLE * FROM MVKE WHERE MATNR EQ WA_TAB181-MATNR AND VKORG EQ '1000' AND VTWEG EQ '10' .
*    IF SY-SUBRC EQ 0.
*      WA_TAB182-MVGR4 = MVKE-MVGR4.
*    ENDIF.
*    IF  WA_TAB182-MVGR4 EQ SPACE.
*      SELECT SINGLE * FROM MVKE WHERE MATNR EQ WA_TAB181-MATNR AND VKORG EQ '1000' AND MVGR4 NE SPACE.
*      IF SY-SUBRC EQ 0.
*        WA_TAB182-MVGR4 = MVKE-MVGR4.
*      ENDIF.
*    ENDIF.

*    SELECT SINGLE * FROM TVM4T WHERE SPRAS EQ 'EN' AND MVGR4 EQ WA_TAB182-MVGR4.
*    IF SY-SUBRC EQ 0.
*      WA_TAB182-MAKTX = TVM4T-BEZEI.
*    ELSE.
*      FORMAT COLOR 6.
*      WRITE : / 'PRODUCT DESCRIPTIO NOT FOUND FOR ',WA_TAB181-MATNR.
*    ENDIF.

    collect wa_tab182 into it_tab182.
    clear wa_tab182.
  endloop.

  sort it_tab182 by spart prn_seq grp_code.
  loop at it_tab182 into wa_tab182.
    clear : ach1,ach2,grv,grq.
*    FORMAT COLOR 1.
*    WRITE : / '182',WA_TAB182-mvgr4,WA_TAB182-spart,WA_TAB182-prn_seq,WA_TAB182-grp_code,wa_tab182-bezei,wa_tab182-maktx.
*    WA_TAB18-MATNR = WA_TAB182-MATNR.
*****    wa_tab18-matkl = wa_tab182-matkl.
*****    select single * from t023t where spras eq 'EN' and matkl eq wa_tab182-matkl.
*****    if sy-subrc eq 0.
*****      wa_tab18-maktx = t023t-wgbez.
*****    endif.
*    WA_TAB18-BEZEI = WA_TAB182-BEZEI.
*    WA_TAB18-MAKTX = WA_TAB182-MAKTX.
    wa_tab18-spart = wa_tab182-spart.
    wa_tab18-prn_seq = wa_tab182-prn_seq.
    wa_tab18-grp_code = wa_tab182-grp_code.
    wa_tab18-subgrp_name = wa_tab182-subgrp_name.
    select single * from zprdgroup where rep_type = 'SR2' and grp_code = wa_tab182-grp_code.
    if sy-subrc = 0.
      wa_tab18-maktx = zprdgroup-grp_name.
    endif.
    wa_tab18-net_qty = wa_tab182-net_qty.
    wa_tab18-net_sale = wa_tab182-net_sale.
    wa_tab18-b_qty = wa_tab182-b_qty.
    wa_tab18-b_pts = wa_tab182-b_pts.

    wa_tab18-cnet_qty = wa_tab182-cnet_qty.
    wa_tab18-cb_qty = wa_tab182-cb_qty.
    wa_tab18-cnet_sale = wa_tab182-cnet_sale.
    wa_tab18-cb_pts = wa_tab182-cb_pts.
    wa_tab18-lcnet_sale = wa_tab182-lcnet_sale.
    wa_tab18-lcnet_qty = wa_tab182-lcnet_qty.


    if wa_tab18-b_pts ne 0.
      ach1 = ( wa_tab18-net_sale / wa_tab18-b_pts ) * 100.
    endif.
    wa_tab18-ach1 = ach1.
    if wa_tab18-cb_pts ne 0.
      ach2 = ( wa_tab18-cnet_sale / wa_tab18-cb_pts ) * 100.
    endif.
    wa_tab18-ach2 = ach2.
    if wa_tab18-lcnet_qty ne 0.
      grq = ( wa_tab18-cnet_qty / wa_tab18-lcnet_qty ) * 100 - 100.
    endif.
    wa_tab18-grq = grq.
    if wa_tab18-lcnet_sale ne 0.
      grv = ( wa_tab18-cnet_sale / wa_tab18-lcnet_sale ) * 100 - 100.
    endif.
    wa_tab18-grv = grv.
*    SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_TAB18-MATNR.
*    IF SY-SUBRC EQ 0.
*      WA_TAB18-SPART = MARA-SPART.
*    ENDIF.

    collect wa_tab18 into it_tab18.
    clear wa_tab18.
  endloop.

  sort it_tab18 by spart prn_seq grp_code maktx.


  sort it_tab8 by prn_seq.
  loop at it_tab18 into wa_tab18.
    pack wa_tab18-matnr to wa_tab18-matnr.
    condense wa_tab18-matnr.
    modify it_tab18 from wa_tab18 transporting matnr.
*    WRITE : /'j', WA_tab18-MVGR4,WA_tab18-BEZEI,wa_tab18-bezei1,WA_tab18-net_qty,wa_tab18-b_qty,wa_tab18-net_sale,wa_tab18-b_pts.
*    WRITE : wa_tab18-ach1,wa_tab18-cnet_qty,wa_tab18-cb_qty,wa_tab18-cnet_sale,wa_tab18-cb_pts.
*    WRITE : wa_tab18-ach2,wa_tab18-grq,wa_tab18-grv.
  endloop.

*****  wa_fieldcat-fieldname = 'MATKL'.
*****  wa_fieldcat-seltext_l = 'MATERIAL GROUP'.
*****  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'SPART'.
  wa_fieldcat-seltext_l = 'DIVISION'.
  append wa_fieldcat to fieldcat.

*  WA_FIELDCAT-FIELDNAME = 'MATNR'.
*  WA_FIELDCAT-SELTEXT_L = 'CODE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.

  wa_fieldcat-fieldname = 'MAKTX'.
  wa_fieldcat-seltext_l = 'GROUP NAME'.
  append wa_fieldcat to fieldcat.

*  WA_FIELDCAT-FIELDNAME = 'BEZEI'.
*  WA_FIELDCAT-SELTEXT_L = 'PACK SIZE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.

  wa_fieldcat-fieldname = 'GRP_CODE'.
  wa_fieldcat-seltext_l = 'GROUP CODE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'SUBGRP_NAME'.
  wa_fieldcat-seltext_l = 'SUB GROUP NAME'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'PRN_SEQ'.
  wa_fieldcat-seltext_l = 'PRN SEQUENCE'.
  append wa_fieldcat to fieldcat.
*
  wa_fieldcat-fieldname = 'NET_QTY'.
  wa_fieldcat-seltext_l = 'UNIT SALE THIS MTH'.
  append wa_fieldcat to fieldcat.
**
  wa_fieldcat-fieldname = 'B_QTY'.
  wa_fieldcat-seltext_l = 'UNIT BUDGET THIS MONTH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'NET_SALE'.
  wa_fieldcat-seltext_l = 'VALUE SALE THIS MONTH'.
  append wa_fieldcat to fieldcat.
*
  wa_fieldcat-fieldname = 'B_PTS'.
  wa_fieldcat-seltext_l = 'VALUE BUDGET THIS MONTH'.
  append wa_fieldcat to fieldcat.
*
  wa_fieldcat-fieldname = 'ACH1'.
  wa_fieldcat-seltext_l = '% ACH1.'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CNET_QTY'.
  wa_fieldcat-seltext_l = 'UNIT SALE THIS YTD.'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CB_QTY'.
  wa_fieldcat-seltext_l = 'UNIT BUDGET THIS YTD.'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CNET_SALE'.
  wa_fieldcat-seltext_l = 'VALUE SALE THIS YTD.'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CB_PTS'.
  wa_fieldcat-seltext_l = 'VALUE BUDGET THIS YTD.'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'ACH2'.
  wa_fieldcat-seltext_l = '& ACH2.'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LCNET_SALE'.
  wa_fieldcat-seltext_l = 'LY CUMM SALE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LCNET_QTY'.
  wa_fieldcat-seltext_l = 'LY CUMM QTY'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'GRQ'.
  wa_fieldcat-seltext_l = 'UNIT GR THIS YTD.'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'GRV'.
  wa_fieldcat-seltext_l = 'VALUE GR THIS YTD.'.
  append wa_fieldcat to fieldcat.


  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'SR-2 : COMPANY SALES (NET) - PRODUCT GROUP WISE'.


  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = g_repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
      i_callback_user_command = 'USER_COMM'
      i_callback_top_of_page  = 'TOP1'
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
      t_outtab                = it_tab18
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.







***********************************************************

endform.                    "NET_ALV

*&---------------------------------------------------------------------*
*&      Form  NET_FORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form net_form.

  select * from zsales_tab1 into table it_zsales_tab1 where datab ge from_dt and datbi le to_dt.
*  if r13 ne 'X'.
  select * from zcredit_tab1 into table it_zcredit_tab1 where datab ge from_dt and datbi le to_dt.
  select * from zdebit_tab1 into table it_zdebit_tab1 where datab ge from_dt and datbi le to_dt.
  select * from zbudget_tab1 into table it_zbudget_tab1 where datab ge from_dt and datbi le to_dt and tag eq 'N'.
*  endif.

  if it_zsales_tab1 is not initial.
    loop at it_zsales_tab1 into wa_zsales_tab1.
*      if r13 eq 'X'.
*        pts = wa_zsales_tab1-nep_pts.
*        wa_tab11-matnr = wa_zsales_tab1-matnr.
*        wa_tab11-pts = pts.
*        wa_tab11-qty = wa_zsales_tab1-nep_c_qty.
*        wa_tab11-f_qty = wa_zsales_tab1-nep_f_qty.
**    wa_tab11-mvgr5 = wa_zsales_tab1-mvgr5. 29.11.20
*        select single * from mvke where matnr eq wa_zsales_tab1-matnr and vkorg eq '1000' and vtweg eq '10'.
*        if sy-subrc eq 0.
*          wa_tab11-mvgr5 = mvke-mvgr5.
*        endif.
*        wa_tab-matnr = wa_zsales_tab1-matnr.
*        collect wa_tab into it_tab.
*        clear wa_tab.
*        collect wa_tab11 into it_tab11.
*        clear wa_tab11.
*        clear pts.
*      else.

      pts = wa_zsales_tab1-net + wa_zsales_tab1-ed.
      wa_tab11-matnr = wa_zsales_tab1-matnr.
      wa_tab11-pts = pts.
      wa_tab11-qty = wa_zsales_tab1-c_qty.
      wa_tab11-f_qty = wa_zsales_tab1-f_qty.
*    wa_tab11-mvgr5 = wa_zsales_tab1-mvgr5. 29.11.20
      select single * from mvke where matnr eq wa_zsales_tab1-matnr and vkorg eq '1000' and vtweg eq '10'.
      if sy-subrc eq 0.
        wa_tab11-mvgr5 = mvke-mvgr5.
      endif.
      wa_tab-matnr = wa_zsales_tab1-matnr.
      collect wa_tab into it_tab.
      clear wa_tab.
      collect wa_tab11 into it_tab11.
      clear wa_tab11.
      clear pts.

*      endif.
    endloop.
  endif.

*LOOP AT IT_TAB1 INTO WA_TAB1.
*  WRITE : /'SALE', WA_TAB1-MATNR,WA_TAB1-PTS,WA_TAB1-ED,WA_TAB1-C_QTY,WA_TAB1-F_QTY.
*ENDLOOP.
  if it_zcredit_tab1 is not initial.
    loop at it_zcredit_tab1 into wa_zcredit_tab1.
      wa_tab12-matnr = wa_zcredit_tab1-matnr.
      wa_tab12-pts = wa_zcredit_tab1-net.
      wa_tab12-qty = wa_zcredit_tab1-qty_c.
      wa_tab-matnr = wa_zcredit_tab1-matnr.
      collect wa_tab into it_tab.
      clear wa_tab.
      collect wa_tab12 into it_tab12.
      clear wa_tab12.
    endloop.
  endif.

  if it_zdebit_tab1 is not initial.
    loop at it_zdebit_tab1 into wa_zdebit_tab1.
      wa_tab13-matnr = wa_zdebit_tab1-matnr.
      wa_tab13-pts = wa_zdebit_tab1-net.
      wa_tab13-qty = wa_zdebit_tab1-qty_c.
      wa_tab-matnr = wa_zdebit_tab1-matnr.
      collect wa_tab into it_tab.
      clear wa_tab.
      collect wa_tab13 into it_tab13.
      clear wa_tab13.
    endloop.
  endif.

  if it_zbudget_tab1 is not initial.
    loop at it_zbudget_tab1 into wa_zbudget_tab1.
      wa_tab14-matnr = wa_zbudget_tab1-matnr.
      wa_tab14-pts = wa_zbudget_tab1-val.
      wa_tab14-qty = wa_zbudget_tab1-qty.
      wa_tab-matnr = wa_zbudget_tab1-matnr.
      collect wa_tab into it_tab.
      clear wa_tab.
      collect wa_tab14 into it_tab14.
      clear wa_tab14.
    endloop.
  endif.

  if it_tab is not initial.
    loop at it_tab into wa_tab.
      read table it_tab11 into wa_tab11 with key matnr = wa_tab-matnr.  "sale
      if sy-subrc eq 0.
        wa_tab15-matnr = wa_tab11-matnr.
        wa_tab15-s_pts = wa_tab11-pts.
        wa_tab15-s_qty = wa_tab11-qty.
        wa_tab15-f_qty = wa_tab11-f_qty.
        wa_tab15-mvgr5 = wa_tab11-mvgr5.
      endif.
      read table it_tab12 into wa_tab12 with key matnr = wa_tab-matnr.  "cn
      if sy-subrc eq 0.
        wa_tab15-matnr = wa_tab12-matnr.
        wa_tab15-c_pts = wa_tab12-pts.
        wa_tab15-c_qty = wa_tab12-qty.
      endif.
      read table it_tab13 into wa_tab13 with key matnr = wa_tab-matnr.  "dn
      if sy-subrc eq 0.
        wa_tab15-matnr = wa_tab13-matnr.
        wa_tab15-d_pts = wa_tab13-pts.
        wa_tab15-d_qty = wa_tab13-qty.
      endif.
      read table it_tab14 into wa_tab14 with key matnr = wa_tab-matnr.  "budget
      if sy-subrc eq 0.
        wa_tab15-matnr = wa_tab14-matnr.
        wa_tab15-b_pts = wa_tab14-pts.
        wa_tab15-b_qty = wa_tab14-qty.
      endif.
      collect wa_tab15 into it_tab15.
      clear wa_tab15.
    endloop.
  endif.

  if it_tab15 is  not initial.
    loop at it_tab15 into wa_tab15.
      clear : net_sale,net_qty.
*    WRITE : / 'a',wa_TAB15-matnr,WA_TAB15-B_PTS,WA_TAB15-B_QTY,wa_TAB15-s_pts,wa_TAB15-s_qty,wa_TAB15-c_pts,wa_TAB15-c_qty,wa_TAB15-d_pts,
*    wa_TAB15-d_qty.
      net_sale = wa_tab15-s_pts - wa_tab15-c_pts + wa_tab15-d_pts.
      net_qty = wa_tab15-s_qty - wa_tab15-c_qty + wa_tab15-d_qty.
      wa_tab16-matnr = wa_tab15-matnr.
      wa_tab16-mvgr5 = wa_tab15-mvgr5.
      wa_tab16-b_pts = wa_tab15-b_pts.
      wa_tab16-b_qty = wa_tab15-b_qty.
      wa_tab16-s_pts = wa_tab15-s_pts.
      wa_tab16-s_qty = wa_tab15-s_qty.
      wa_tab16-f_qty = wa_tab15-f_qty.
      wa_tab16-c_pts = wa_tab15-c_pts.
      wa_tab16-c_qty = wa_tab15-c_qty.
      wa_tab16-d_pts = wa_tab15-d_pts.
      wa_tab16-d_qty = wa_tab15-d_qty.
      wa_tab16-net_sale = net_sale.
      wa_tab16-net_qty = net_qty.
      collect wa_tab16 into it_tab16.
      clear wa_tab16.
    endloop.
  endif.
  if it_tab16 is   not initial.
    loop at it_tab16 into wa_tab16.
      wa_tab17-matnr = wa_tab16-matnr.
      wa_tab17-mvgr5 = wa_tab16-mvgr5.
      wa_tab17-b_pts = wa_tab16-b_pts.
      wa_tab17-b_qty = wa_tab16-b_qty.
      wa_tab17-s_pts = wa_tab16-s_pts.
      wa_tab17-s_qty = wa_tab16-s_qty.
      wa_tab17-f_qty = wa_tab16-f_qty.
      wa_tab17-c_pts = wa_tab16-c_pts.
      wa_tab17-c_qty = wa_tab16-c_qty.
      wa_tab17-d_pts = wa_tab16-d_pts.
      wa_tab17-d_qty = wa_tab16-d_qty.
      wa_tab17-net_sale = wa_tab16-net_sale.
      wa_tab17-net_qty = wa_tab16-net_qty.
      collect wa_tab17 into it_tab17.
      clear wa_tab17.
    endloop.
  endif.

***************CURRENT MOTH SALE ENDS HERE **********************

*************CUMMULATIVE SALE STARTS HERE***************************
  c_date+6(2) = '01'.
  c_date+4(2) = '04'.

  if from_dt+4(2) lt '04'.
    c_date+0(4) = from_dt+0(4) - 1.
  else.
    c_date+0(4) = from_dt+0(4).
  endif.
*  write : / 'cummulative date',c_date.

  select * from zsales_tab1 into table it_zsales_tab2 where datab ge c_date and datbi le to_dt.
  if it_zsales_tab2 is not initial.
    loop at it_zsales_tab2 into wa_zsales_tab2.
*      if r13 eq 'X'.
*        wa_ctab1-matnr = wa_zsales_tab2-matnr.
*        wa_ctab1-pts = wa_zsales_tab2-nep_pts.
*        wa_ctab1-qty = wa_zsales_tab2-nep_c_qty.
*        wa_ctab1-f_qty = wa_zsales_tab2-nep_f_qty.
*        collect wa_ctab1 into it_ctab1.
*        clear wa_ctab1.
*        wa_ta-matnr = wa_zsales_tab2-matnr.
*        collect wa_ta into it_ta.
*        clear wa_ta.
*      else.
      wa_ctab1-matnr = wa_zsales_tab2-matnr.
      wa_ctab1-pts = wa_zsales_tab2-net + wa_zsales_tab2-ed.
      wa_ctab1-qty = wa_zsales_tab2-c_qty.
      wa_ctab1-f_qty = wa_zsales_tab2-f_qty.
      collect wa_ctab1 into it_ctab1.
      clear wa_ctab1.
      wa_ta-matnr = wa_zsales_tab2-matnr.
      collect wa_ta into it_ta.
      clear wa_ta.
*      endif.
    endloop.
  endif.
*  if r13 ne 'X'.
  select * from zcredit_tab1 into table it_zcredit_tab2 where datab ge c_date and datbi le to_dt.
  if it_zcredit_tab2 is not initial.
    loop at it_zcredit_tab2 into wa_zcredit_tab2.
      wa_ctab2-matnr = wa_zcredit_tab2-matnr.
      wa_ctab2-pts = wa_zcredit_tab2-net.
      wa_ctab2-qty = wa_zcredit_tab2-qty_c.
      collect wa_ctab2 into it_ctab2.
      clear wa_ctab2.
      wa_ta-matnr = wa_zcredit_tab2-matnr.
      collect wa_ta into it_ta.
      clear wa_ta.
    endloop.
  endif.

  select * from zdebit_tab1 into table it_zdebit_tab2 where datab ge c_date and datbi le to_dt.
  if it_zdebit_tab2 is not initial.
    loop at it_zdebit_tab2 into wa_zdebit_tab2.
      wa_ctab3-matnr = wa_zdebit_tab2-matnr.
      wa_ctab3-pts = wa_zdebit_tab2-net.
      wa_ctab3-qty = wa_zdebit_tab2-qty_c.
      collect wa_ctab3 into it_ctab3.
      clear wa_ctab3.
      wa_ta-matnr = wa_zdebit_tab2-matnr.
      collect wa_ta into it_ta.
      clear wa_ta.
    endloop.
  endif.

  select * from zbudget_tab1 into table it_zbudget_tab2 where datab ge c_date and datbi le to_dt and tag eq 'N'.
  if it_zbudget_tab2 is not initial.
    loop at it_zbudget_tab2 into wa_zbudget_tab2.
*      WRITE : / 'budget',c_date,TO_DT,wa_zBUDGET_tab2-matnr,wa_zBUDGET_tab2-qty.
      wa_ctab4-matnr = wa_zbudget_tab2-matnr.
      wa_ctab4-pts = wa_zbudget_tab2-val.
      wa_ctab4-qty = wa_zbudget_tab2-qty.
      collect wa_ctab4 into it_ctab4.
      clear wa_ctab4.
      wa_ta-matnr = wa_zbudget_tab2-matnr.
      collect wa_ta into it_ta.
      clear wa_ta.
    endloop.
  endif.
*  endif.
  sort it_ta.
  delete adjacent duplicates from it_ta.

  if it_ta is not initial.
    loop at it_ta into wa_ta.
      read table it_ctab1 into wa_ctab1 with key matnr = wa_ta-matnr.
      if sy-subrc eq 0.
        wa_ctab5-matnr = wa_ctab1-matnr.
        wa_ctab5-s_pts = wa_ctab1-pts.
        wa_ctab5-s_qty = wa_ctab1-qty.
        wa_ctab5-f_qty = wa_ctab1-f_qty.
      endif.
      read table it_ctab2 into wa_ctab2 with key matnr = wa_ta-matnr.
      if sy-subrc eq 0.
        wa_ctab5-matnr = wa_ctab2-matnr.
        wa_ctab5-c_pts = wa_ctab2-pts.
        wa_ctab5-c_qty = wa_ctab2-qty.
      endif.
      read table it_ctab3 into wa_ctab3 with key matnr = wa_ta-matnr.
      if sy-subrc eq 0.
        wa_ctab5-matnr = wa_ctab3-matnr.
        wa_ctab5-d_pts = wa_ctab3-pts.
        wa_ctab5-d_qty = wa_ctab3-qty.
      endif.
      read table it_ctab4 into wa_ctab4 with key matnr = wa_ta-matnr.
      if sy-subrc eq 0.
        wa_ctab5-matnr = wa_ctab4-matnr.
        wa_ctab5-b_pts = wa_ctab4-pts.
        wa_ctab5-b_qty = wa_ctab4-qty.
      endif.
      collect wa_ctab5 into it_ctab5.
      clear wa_ctab5.
    endloop.
  endif.

  if it_ctab5 is not initial.
    loop at it_ctab5 into wa_ctab5.
      clear : cnet_sale,cnet_qty.
      wa_ctab6-matnr = wa_ctab5-matnr.
      wa_ctab6-s_pts = wa_ctab5-s_pts.
      wa_ctab6-s_qty = wa_ctab5-s_qty.
      wa_ctab6-f_qty = wa_ctab5-f_qty.
      wa_ctab6-c_pts = wa_ctab5-c_pts.
      wa_ctab6-c_qty = wa_ctab5-c_qty.
      wa_ctab6-d_pts = wa_ctab5-d_pts.
      wa_ctab6-d_qty = wa_ctab5-d_qty.
      wa_ctab6-b_pts = wa_ctab5-b_pts.
      wa_ctab6-b_qty = wa_ctab5-b_qty.
      cnet_sale = wa_ctab5-s_pts - wa_ctab5-c_pts + wa_ctab5-d_pts.
      cnet_qty = wa_ctab5-s_qty - wa_ctab5-c_qty + wa_ctab5-d_qty.
      wa_ctab6-net_sale = cnet_sale.
      wa_ctab6-net_qty = cnet_qty.
      collect wa_ctab6 into it_ctab6.
      clear wa_ctab6.
    endloop.
  endif.
  sort it_ctab6 by bezei.
  if it_ctab6 is not initial.
    loop at it_ctab6 into wa_ctab6.
      wa_ctab7-matnr = wa_ctab6-matnr.
      wa_ctab7-s_pts = wa_ctab6-s_pts.
      wa_ctab7-s_qty = wa_ctab6-s_qty.
      wa_ctab7-f_qty = wa_ctab6-f_qty.
      wa_ctab7-c_pts = wa_ctab6-c_pts.
      wa_ctab7-c_qty = wa_ctab6-c_qty.
      wa_ctab7-d_pts = wa_ctab6-d_pts.
      wa_ctab7-d_qty = wa_ctab6-d_qty.
      wa_ctab7-b_pts = wa_ctab6-b_pts.
      wa_ctab7-b_qty = wa_ctab6-b_qty.
      wa_ctab7-net_sale = wa_ctab6-net_sale.
      wa_ctab7-net_qty = wa_ctab6-net_qty.
      collect wa_ctab7 into it_ctab7.
      clear wa_ctab7.
    endloop.
  endif.
*  LOOP AT IT_CTAB7 INTO WA_CTAB7.
*    WRITE : /'a1',wa_tab7-mvgr4,wa_ctab7-bezei,'net',wa_ctab7-net_qty,'sale',WA_CTAB7-S_QTY,'credit',wa_ctab7-c_qty,'debit',wa_ctab7-d_qty,'bud',wa_ctab7-b_qty,wa_ctab7-net_sale,wa_ctab7-b_pts.
*  ENDLOOP.

**************CUMMULATIVE DATA ENDS HERE********************

******************LAST YEAR CUMMULATIVE DATA STARTS*****************

  ll_date = c_date.
  ll_date+0(4) = c_date+0(4) - 1.
  lc_date = to_dt.
  lc_date+0(4) = to_dt+0(4) - 1.


*******************************************************
  clear : ndt1,ndt2.
  ndt1 = lc_date.
  ndt1+6(2) = '01'.
  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date           = ndt1
    importing
*     EV_MONTH_BEGIN_DATE       =
      ev_month_end_date = ndt2.
  lc_date = ndt2.
*************************************************************************

*  write : / 'last fiscal year',ll_date,'last year same date',lc_date.
*WRITE : / 'date',lc_date.
  if lc_date = '20160228'.
    lc_date = '20160229'.
  endif.
*WRITE : / 'date',lc_date.

  select * from zsales_tab1 into table it_zsales_tab3 where datab ge ll_date and datbi le lc_date.
  if it_zsales_tab3 is not initial.
    loop at it_zsales_tab3 into wa_zsales_tab3.
*      if r13 eq 'X'.
*        wa_lctab1-matnr = wa_zsales_tab3-matnr.
*        wa_lctab1-pts = wa_zsales_tab3-nep_pts.
*        wa_lctab1-qty = wa_zsales_tab3-nep_c_qty.
*        wa_lctab1-f_qty = wa_zsales_tab3-nep_f_qty.
*        collect wa_lctab1 into it_lctab1.
*        clear wa_lctab1.
*        wa_t-matnr = wa_zsales_tab3-matnr.
*        collect wa_t into it_t.
*        clear wa_t.
*      else.
      wa_lctab1-matnr = wa_zsales_tab3-matnr.
      wa_lctab1-pts = wa_zsales_tab3-net + wa_zsales_tab3-ed.
      wa_lctab1-qty = wa_zsales_tab3-c_qty.
      wa_lctab1-f_qty = wa_zsales_tab3-f_qty.
      collect wa_lctab1 into it_lctab1.
      clear wa_lctab1.
      wa_t-matnr = wa_zsales_tab3-matnr.
      collect wa_t into it_t.
      clear wa_t.
*      endif.
    endloop.
  endif.

*  if r13 ne 'X'.
  select * from zcredit_tab1 into table it_zcredit_tab3 where datab ge ll_date and datbi le lc_date.
  if it_zcredit_tab3 is not initial.
    loop at it_zcredit_tab3 into wa_zcredit_tab3.
      wa_lctab2-matnr = wa_zcredit_tab3-matnr.
      wa_lctab2-pts = wa_zcredit_tab3-net.
      wa_lctab2-qty = wa_zcredit_tab3-qty_c.
      collect wa_lctab2 into it_lctab2.
      clear wa_lctab2.
      wa_t-matnr = wa_zcredit_tab3-matnr.
      collect wa_t into it_t.
      clear wa_t.
    endloop.
  endif.

  select * from zdebit_tab1 into table it_zdebit_tab3 where datab ge ll_date and datbi le lc_date.
  if it_zdebit_tab3 is not initial.
    loop at it_zdebit_tab3 into wa_zdebit_tab3.
      wa_lctab3-matnr = wa_zdebit_tab3-matnr.
      wa_lctab3-pts = wa_zdebit_tab3-net.
      wa_lctab3-qty = wa_zdebit_tab3-qty_c.
      collect wa_lctab3 into it_lctab3.
      clear wa_lctab3.
      wa_t-matnr = wa_zdebit_tab3-matnr.
      collect wa_t into it_t.
      clear wa_t.
    endloop.
  endif.
*  endif.
  if it_t is not initial.
    loop at it_t into wa_t.
      read table it_lctab1 into wa_lctab1 with key matnr = wa_t-matnr.
      if sy-subrc eq 0.
        wa_lctab4-matnr = wa_lctab1-matnr.
        wa_lctab4-s_pts = wa_lctab1-pts.
        wa_lctab4-s_qty = wa_lctab1-qty.
        wa_lctab4-f_qty = wa_lctab1-f_qty.
      endif.
      read table it_lctab2 into wa_lctab2 with key matnr = wa_t-matnr.
      if sy-subrc eq 0.
        wa_lctab4-matnr = wa_lctab2-matnr.
        wa_lctab4-c_pts = wa_lctab2-pts.
        wa_lctab4-c_qty = wa_lctab2-qty.
      endif.
      read table it_lctab3 into wa_lctab3 with key matnr = wa_t-matnr.
      if sy-subrc eq 0.
        wa_lctab4-matnr = wa_lctab3-matnr.
        wa_lctab4-d_pts = wa_lctab3-pts.
        wa_lctab4-d_qty = wa_lctab3-qty.
      endif.
      collect wa_lctab4 into it_lctab4.
      clear wa_lctab4.
    endloop.
  endif.

  if it_lctab4 is not initial.
    loop at it_lctab4 into wa_lctab4.
      clear : lcnet_sale,lcnet_qty.
      wa_lctab5-matnr = wa_lctab4-matnr.
      wa_lctab5-s_pts = wa_lctab4-s_pts.
      wa_lctab5-s_qty = wa_lctab4-s_qty.
      wa_lctab5-f_qty = wa_lctab4-f_qty.
      wa_lctab5-c_pts = wa_lctab4-c_pts.
      wa_lctab5-c_qty = wa_lctab4-c_qty.
      wa_lctab5-d_pts = wa_lctab4-d_pts.
      wa_lctab5-d_qty = wa_lctab4-d_qty.
      lcnet_sale = wa_lctab4-s_pts - wa_lctab4-c_pts + wa_lctab4-d_pts.
*      if r10 = 'X' or r11 = 'X' or r7 eq 'X' or r13 eq 'X'.
      if r10 = 'X' or r14 eq 'X' or r11 = 'X' or r7 eq 'X'.
        lcnet_qty = wa_lctab4-s_qty - wa_lctab4-c_qty + wa_lctab4-d_qty + wa_lctab4-f_qty.
      else.
        lcnet_qty = wa_lctab4-s_qty - wa_lctab4-c_qty + wa_lctab4-d_qty.
      endif.
      wa_lctab5-net_sale = lcnet_sale.
      wa_lctab5-net_qty = lcnet_qty.
      collect wa_lctab5 into it_lctab5.
      clear wa_lctab5.
    endloop.
  endif.

  if it_lctab5 is not initial.
    loop at it_lctab5 into wa_lctab5.
*    WRITE : / 'last yeat net sale',wa_lctab5-matnr,wa_lctab5-net_sale.
      wa_lctab6-matnr = wa_lctab5-matnr.
      wa_lctab6-s_pts = wa_lctab5-s_pts.
      wa_lctab6-s_qty = wa_lctab5-s_qty.
      wa_lctab6-f_qty = wa_lctab5-f_qty.
      wa_lctab6-c_pts = wa_lctab5-c_pts.
      wa_lctab6-c_qty = wa_lctab5-c_qty.
      wa_lctab6-d_pts = wa_lctab5-d_pts.
      wa_lctab6-d_qty = wa_lctab5-d_qty.
      wa_lctab6-net_sale = wa_lctab5-net_sale.
      wa_lctab6-net_qty = wa_lctab5-net_qty.
      collect wa_lctab6 into it_lctab6.
      clear wa_lctab6.
    endloop.
  endif.

  sort it_tab17 by matnr.
  if it_tab is not initial.
    loop at it_tab into wa_tab.
      wa_mat1-matnr = wa_tab-matnr.
      collect wa_mat1 into it_mat1.
      clear wa_mat1.
    endloop.
  endif.
  if it_ta is not initial.
    loop at it_ta into wa_ta.
      wa_mat1-matnr = wa_ta-matnr.
      collect wa_mat1 into it_mat1.
      clear wa_mat1.
    endloop.
  endif.
  if it_t is not initial.
    loop at it_t into wa_t.
      wa_mat1-matnr = wa_t-matnr.
      collect wa_mat1 into it_mat1.
      clear wa_mat1.
    endloop.
  endif.
  sort it_mat1 by matnr.
  delete adjacent duplicates from it_mat1 comparing matnr.
  if it_mat1 is not initial.
    select * from mvke into table it_mvke for all entries in it_mat1 where matnr eq it_mat1-matnr and vkorg eq '1000' and vtweg eq '10'.
  endif.
  sort it_mvke by matnr descending.
  sort it_tab17 by matnr.
  sort it_ctab6 by matnr.
  sort it_lctab6 by matnr.

  loop at it_mat1 into wa_mat1.
*    WRITE : / 'material',wa_mat1-matnr.
    clear : ach1,ach2,grq,grv.
*  loop at it_tab17 into wa_tab17.
    read table it_tab17 into wa_tab17 with key matnr = wa_mat1-matnr.
    if sy-subrc eq 0.
      wa_tab181-matnr = wa_tab17-matnr.
      wa_tab181-mvgr5 = wa_tab17-mvgr5.
      wa_tab181-net_qty = wa_tab17-net_qty.
      wa_tab181-net_sale = wa_tab17-net_sale.
      wa_tab181-b_qty = wa_tab17-b_qty.
      wa_tab181-b_pts = wa_tab17-b_pts.
*      if wa_tab17-b_pts ne 0.
*        ach1 = ( wa_tab17-net_sale / wa_tab17-b_pts ) * 100.
*      endif.
*      wa_tab181-ach1 = ach1.
    endif.

    read table it_ctab7 into wa_ctab7 with key matnr = wa_mat1-matnr.
    if sy-subrc eq 0.
      wa_tab181-matnr = wa_ctab7-matnr.
      wa_tab181-cnet_qty = wa_ctab7-net_qty.
      wa_tab181-cnet_sale = wa_ctab7-net_sale.
      wa_tab181-cb_qty = wa_ctab7-b_qty.
      wa_tab181-cb_pts = wa_ctab7-b_pts.
*      if wa_ctab7-b_pts ne 0.
*        ach2 = ( wa_ctab7-net_sale / wa_ctab7-b_pts ) * 100.
*      endif.
*      wa_tab181-ach2 = ach2.
    endif.

    read table it_lctab6 into wa_lctab6 with key matnr = wa_mat1-matnr.
    if sy-subrc eq 0.
*      WRITE : / 'found',wa_lctab6-matnr,wa_lctab6-mvgr4,wa_lctab6-net_sale.
      wa_tab181-matnr = wa_lctab6-matnr.
      wa_tab181-lcnet_sale = wa_lctab6-net_sale.
      wa_tab181-lcnet_qty = wa_lctab6-net_qty.
*      if wa_lctab6-net_qty ne 0.
*        grq = ( wa_ctab7-net_qty / wa_lctab6-net_qty ) * 100 - 100.
*      endif.
*      wa_tab181-grq = grq.
*      if wa_lctab6-net_sale ne 0.
*        grv = ( wa_ctab7-net_sale / wa_lctab6-net_sale ) * 100 - 100.
*      endif.
*      wa_tab181-grv = grv.
    endif.

    collect wa_tab181 into it_tab181.
    clear wa_tab181.
  endloop.

  if it_tab181 is not initial.
    loop at it_tab181 into wa_tab181 where matnr ne '                  '.

*    wa_tab182-matnr = wa_tab181-matnr.
      wa_tab182-net_qty = wa_tab181-net_qty.
      wa_tab182-net_sale = wa_tab181-net_sale.
      wa_tab182-b_qty = wa_tab181-b_qty.
      wa_tab182-b_pts = wa_tab181-b_pts.
*    wa_tab182-ach1 = wa_tab181-ach1.
      wa_tab182-cnet_qty = wa_tab181-cnet_qty.
      wa_tab182-cb_qty = wa_tab181-cb_qty.
      wa_tab182-cnet_sale = wa_tab181-cnet_sale.
      wa_tab182-cb_pts = wa_tab181-cb_pts.
*    wa_tab182-ach2 = wa_tab181-ach2.
      wa_tab182-lcnet_sale = wa_tab181-lcnet_sale.
      wa_tab182-lcnet_qty = wa_tab181-lcnet_qty.
*    WA_TAB182-MVGR5 = WA_TAB181-MVGR5.
*    wa_tab182-grq = wa_tab181-grq.
*    wa_tab182-grv = wa_tab181-grv.

      select single * from mara where matnr eq wa_tab181-matnr.
      if sy-subrc eq 0.
        wa_tab182-spart = mara-spart.
      endif.

      select single * from zprdgroup where rep_type eq 'SR2' and prd_code eq mara-matnr.
      if sy-subrc eq 0.
        wa_tab182-prn_seq = zprdgroup-prn_seq.
        wa_tab182-grp_code = zprdgroup-grp_code.
        wa_tab182-subgrp_code = zprdgroup-subgrp_code.
        wa_tab182-subgrp_name = zprdgroup-subgrp_name.

*      WRITE : / 'material',wa_tab181-matnr,ZPRDGROUP-PRN_SEQ,ZPRDGROUP-GRP_CODE, WA_TAB182-PRN_SEQ,WA_TAB182-GRP_CODE .
      else.
        format color 6.
        write :  'MATERIL CODE NOT MAINTAINED IN ZPRDGROUP',wa_tab181-matnr.
      endif.

*    select single * from mvke where matnr eq wa_tab181-matnr and vkorg eq '1000' and vtweg eq '10' .
*    if sy-subrc eq 0.
*      select single * from tvm5t where spras eq 'EN' and mvgr5 eq mvke-mvgr5.
*      if sy-subrc eq 0.
*        wa_tab182-bezei = tvm5t-bezei.
*      endif.
*    endif.

      select single * from mvke where matnr eq wa_tab181-matnr and vkorg eq '1000' and vtweg eq '10' .
      if sy-subrc eq 0.
        wa_tab182-mvgr4 = mvke-mvgr4.
        wa_tab999-mvgr4 = mvke-mvgr4.
      endif.
      wa_tab999-mvgr5 = wa_tab181-mvgr5.
      if wa_tab181-matnr = 41066.
*        WRITE : /1 ,WA_TAB999-MVGR4, WA_TAB999-MVGR5.  "22.12.21
      endif.
      if   wa_tab181-mvgr5 <> ' '.
        collect wa_tab999 into it_tab999.
      endif.
      clear wa_tab999.
      select single * from tvm4t where spras eq 'EN' and mvgr4 eq wa_tab182-mvgr4.
      if sy-subrc eq 0.
        wa_tab182-maktx = tvm4t-bezei.
      else.
        format color 6.
        write : / 'PRODUCT DESCRIPTIO NOT FOUND FOR ',wa_tab181-matnr.
      endif.

      collect wa_tab182 into it_tab182.
      clear wa_tab182.
    endloop.
  endif.

  sort it_tab182 by spart prn_seq grp_code.
  if it_tab182 is not initial.
    loop at it_tab182 into wa_tab182.
      clear : ach1, ach2,grv,grq.
*    FORMAT COLOR 1.
*    WRITE : / '182',WA_TAB182-mvgr4,WA_TAB182-spart,WA_TAB182-prn_seq,WA_TAB182-grp_code,wa_tab182-bezei,wa_tab182-maktx.
      wa_tab18-mvgr4 = wa_tab182-mvgr4.
*    WA_TAB18-MVGR5 = WA_TAB182-MVGR5.
*    wa_tab18-bezei = wa_tab182-bezei.
*****************pack size**************

      read table it_mvke into wa_mvke with key mvgr4 = wa_tab182-mvgr4.
      if sy-subrc eq 0.
        read table it_tab999 into wa_tab999 with key mvgr4 = wa_tab182-mvgr4.
        if sy-subrc = 0.
          select single * from tvm5t where spras eq 'EN' and mvgr5 eq wa_tab999-mvgr5. "       WA_MVKE-MVGR5.
          if sy-subrc eq 0.
            wa_tab18-bezei = tvm5t-bezei.
          else.
            select single * from tvm5t where spras eq 'EN' and mvgr5 eq wa_mvke-mvgr5.
            if sy-subrc eq 0.
              wa_tab18-bezei = tvm5t-bezei.
            endif.
          endif.
        else.  "17.8.22
          select single * from tvm5t where spras eq 'EN' and mvgr5 eq wa_mvke-mvgr5.
          if sy-subrc eq 0.
            wa_tab18-bezei = tvm5t-bezei.
          endif.
        endif.
      endif.
      wa_tab18-maktx = wa_tab182-maktx.
      wa_tab18-spart = wa_tab182-spart.
      wa_tab18-prn_seq = wa_tab182-prn_seq.
      wa_tab18-grp_code = wa_tab182-grp_code.
      wa_tab18-subgrp_code = wa_tab182-subgrp_code.
      wa_tab18-subgrp_name = wa_tab182-subgrp_name.
      wa_tab18-net_qty = wa_tab182-net_qty.
      wa_tab18-net_sale = wa_tab182-net_sale.
      wa_tab18-b_qty = wa_tab182-b_qty.
      wa_tab18-b_pts = wa_tab182-b_pts.
      wa_tab18-cnet_qty = wa_tab182-cnet_qty.
      wa_tab18-cb_qty = wa_tab182-cb_qty.
      wa_tab18-cnet_sale = wa_tab182-cnet_sale.
      wa_tab18-cnet = wa_tab182-cnet_sale / 100000.
      wa_tab18-cb_pts = wa_tab182-cb_pts.
      wa_tab18-lcnet_sale = wa_tab182-lcnet_sale.
      wa_tab18-lcnet_qty = wa_tab182-lcnet_qty.

      if wa_tab18-b_pts ne 0.
        ach1 = ( wa_tab18-net_sale / wa_tab18-b_pts ) * 100.
      endif.
      wa_tab18-ach1 = ach1.
      if wa_tab18-cb_pts ne 0.
        ach2 = ( wa_tab18-cnet_sale / wa_tab18-cb_pts ) * 100.
      endif.
      wa_tab18-ach2 = ach2.
      if wa_tab18-lcnet_qty ne 0.
        grq = ( wa_tab18-cnet_qty / wa_tab18-lcnet_qty ) * 100 - 100.
      endif.
      wa_tab18-grq = grq.
      if wa_tab18-lcnet_sale ne 0.
        grv = ( wa_tab18-cnet_sale / wa_tab18-lcnet_sale ) * 100 - 100.
      endif.
      wa_tab18-grv = grv.
      collect wa_tab18 into it_tab18.
      clear wa_tab18.
    endloop.
  endif.

  sort it_tab18 by spart prn_seq grp_code subgrp_code.

  perform sfform.
*  if r7 eq 'X'.
*    options-tdgetotf = 'X'.
*    call function 'OPEN_FORM'
*      exporting
*        device   = 'PRINTER'
*        dialog   = ''
**       form     = 'ZSR1'
*        language = sy-langu
*        options  = options
*      exceptions
*        canceled = 1
*        device   = 2.
*    if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    endif.
*  else.
*    call function 'OPEN_FORM'
*      exporting
*        device   = 'PRINTER'
*        dialog   = 'X'
**       form     = 'ZSR1'
*        language = sy-langu
*      exceptions
*        canceled = 1
*        device   = 2.
*    if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    endif.
*  endif.
*  if r3 eq 'X' or r9 eq 'X'  or r10 eq 'X' or r12 = 'X' or r7 eq 'X'.
*    call function 'START_FORM'
*      exporting
*        form        = 'ZSR41_N1'
*        language    = sy-langu
*      exceptions
*        form        = 1
*        format      = 2
*        unended     = 3
*        unopened    = 4
*        unused      = 5
*        spool_error = 6
*        codepage    = 7
*        others      = 8.
*    if sy-subrc <> 0.
*      message id sy-msgid type sy-msgty number sy-msgno
*              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*    endif.
*  elseif r13 eq 'X'.
*
*    call function 'START_FORM'
*      exporting
*        form        = 'ZSR1_NEP'
*        language    = sy-langu
*      exceptions
*        form        = 1
*        format      = 2
*        unended     = 3
*        unopened    = 4
*        unused      = 5
*        spool_error = 6
*        codepage    = 7
*        others      = 8.
*    if sy-subrc <> 0.
*      message id sy-msgid type sy-msgty number sy-msgno
*              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*    endif.
*
*  elseif r8 eq 'X'.
*    call function 'START_FORM'
*      exporting
*        form        = 'ZSR41_1'
*        language    = sy-langu
*      exceptions
*        form        = 1
*        format      = 2
*        unended     = 3
*        unopened    = 4
*        unused      = 5
*        spool_error = 6
*        codepage    = 7
*        others      = 8.
*    if sy-subrc <> 0.
*      message id sy-msgid type sy-msgty number sy-msgno
*              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*    endif.
*  endif.
**  ENDIF.
*  select single * from t247 where spras eq 'EN' and mnr eq from_dt+4(2).
*  if sy-subrc eq 0.
**    write : t247-ktx.
*    month = t247-ktx.
*    concatenate month '.' from_dt+0(4) into month1.
*  endif.
*  year = from_dt+0(4).
*  m1 = from_dt+4(2).
*  if m1 ge '04'.
*    fyear = year.
*  else.
*    fyear = year - 1.
*  endif.
*  if year = fyear.
*    year1 = year + 1.
*  else.
*    year1 = fyear.
*  endif.
*  m2 = year+2(2).
**  WRITE : / 'year',year1,year,m2.
*
**  sort it_tab18 by begru matkl.
*  if r9 eq 'X' or r12 = 'X'. .
*    sort it_tab18 by spart maktx.
*  else.
*    sort it_tab18 by spart prn_seq grp_code maktx.
*  endif.
*  loop at it_tab18 into wa_tab18.
*    if r9 eq 'X' or r12 = 'X'.
*      call function 'WRITE_FORM'
*        exporting
*          element = 'HEADD1'
*          window  = 'WINDOW1'.
*    else.
*      call function 'WRITE_FORM'
*        exporting
*          element = 'HEADD'
*          window  = 'WINDOW1'.
*    endif.
**if r9 NE 'X'.
*    if wa_tab18-spart eq '50'.
*      on change of wa_tab18-spart.
**        write : / 'BLUE CROSS'.
*        call function 'WRITE_FORM'
*          exporting
*            element = 'HEAD'
*            window  = 'MAIN'.
**        uline.
*      endon.
*    endif.
*
*    if wa_tab18-spart eq '60'.
*      on change of wa_tab18-spart.
**        write : / 'EXCEL'.
*        call function 'WRITE_FORM'
*          exporting
*            element = 'HEAD1'
*            window  = 'MAIN'.
**        uline.
*      endon.
*    endif.
*    if wa_tab18-spart eq '70'.
*      on change of wa_tab18-spart.
**        write : / 'EXCEL'.
*        call function 'WRITE_FORM'
*          exporting
*            element = 'HEAD2'
*            window  = 'MAIN'.
**        uline.
*      endon.
*    endif.
*
*    on change of wa_tab18-spart.
*      if r9 eq 'X' and wa_tab18-spart eq '60'.
*        call function 'WRITE_FORM'
*          exporting
*            element = 'GR2'
*            window  = 'MAIN'.
*      endif.
*      if r12 eq 'X' and wa_tab18-spart eq '60'.
*        call function 'WRITE_FORM'
*          exporting
*            element = 'GR2'
*            window  = 'MAIN'.
*      endif.
*      if r9 eq 'X' and wa_tab18-spart eq '70'.
*        call function 'WRITE_FORM'
*          exporting
*            element = 'GR2'
*            window  = 'MAIN'.
*      endif.
*      if r12 eq 'X' and wa_tab18-spart eq '70'.
*        call function 'WRITE_FORM'
*          exporting
*            element = 'GR2'
*            window  = 'MAIN'.
*      endif.
*    endon.
*
**    IF WA_TAB18-SPART EQ '60'.
**      ON CHANGE OF WA_TAB18-SPART.
***        write : / 'EXCEL'.
**        CALL FUNCTION 'WRITE_FORM'
**          EXPORTING
**            ELEMENT = 'HEAD1'
**            WINDOW  = 'MAIN'.
***        uline.
**      ENDON.
**    ENDIF.
**    IF WA_TAB18-SPART EQ '70'.
**      ON CHANGE OF WA_TAB18-SPART.
***        write : / 'EXCEL'.
**        CALL FUNCTION 'WRITE_FORM'
**          EXPORTING
**            ELEMENT = 'HEAD2'
**            WINDOW  = 'MAIN'.
***        uline.
**      ENDON.
**    ENDIF.
** ENDIF.
*
**    if ( z1 eq 'X' ) and ( wa_tab18-net_qty le 0 ).
*    if r9 eq 'X' .
*      clear bud_net.
**    bud_net = wa_tab18-cnet_qty + wa_tab18-cb_pts.
*      bud_net = wa_tab18-net_sale.
**    if ( z1 eq 'X' ) and ( wa_tab18-b_pts gt 0 ).
**    if ( z1 eq 'X' ) and ( bud_net le 0 ).
**    else.
*      if ( wa_tab18-grp_code = 53 ) or ( wa_tab18-grp_code = 45 ).
*        if wa_tab18-net_sale ne 0 .
*          call function 'WRITE_FORM'
*            exporting
*              element = 'DET11'
*              window  = 'MAIN'.
*          tot_sqty1 = tot_sqty1 + wa_tab18-net_qty.
*          tot_bqty1 = tot_bqty1 + wa_tab18-b_qty.
*          tot_spts1 = tot_spts1 + wa_tab18-net_sale.
*          tot_bpts1 = tot_bpts1 + wa_tab18-b_pts.
*          tot_csqty1 = tot_csqty1 + wa_tab18-cnet_qty.
*          tot_cbqty1 = tot_cbqty1 + wa_tab18-cb_qty.
*          tot_cspts1 = tot_cspts1 + wa_tab18-cnet_sale.
*          cspts1 = cspts1 + wa_tab18-cnet_sale.
*          tot_cbpts1 = tot_cbpts1 + wa_tab18-cb_pts.
*          tot_lcpts1 = tot_lcpts1 + wa_tab18-lcnet_sale.
*        endif.
*      else.
*        if wa_tab18-net_sale lt 0 .
*          call function 'WRITE_FORM'
*            exporting
*              element = 'DET11'
*              window  = 'MAIN'.
*          tot_sqty1 = tot_sqty1 + wa_tab18-net_qty.
*          tot_bqty1 = tot_bqty1 + wa_tab18-b_qty.
*          tot_spts1 = tot_spts1 + wa_tab18-net_sale.
*          tot_bpts1 = tot_bpts1 + wa_tab18-b_pts.
*          tot_csqty1 = tot_csqty1 + wa_tab18-cnet_qty.
*          tot_cbqty1 = tot_cbqty1 + wa_tab18-cb_qty.
*          tot_cspts1 = tot_cspts1 + wa_tab18-cnet_sale.
*          cspts1 = cspts1 + wa_tab18-cnet_sale.
*          tot_cbpts1 = tot_cbpts1 + wa_tab18-cb_pts.
*          tot_lcpts1 = tot_lcpts1 + wa_tab18-lcnet_sale.
*        endif.
*
*      endif.
*
*    endif.
*
*    if r12 eq 'X' .
*      clear bud_net.
**    bud_net = wa_tab18-cnet_qty + wa_tab18-cb_pts.
*      bud_net = wa_tab18-net_sale.
**    if ( z1 eq 'X' ) and ( wa_tab18-b_pts gt 0 ).
**    if ( z1 eq 'X' ) and ( bud_net le 0 ).
**    else.
*      if ( wa_tab18-grp_code = 53 ) or ( wa_tab18-grp_code = 45 ).
*        if wa_tab18-net_sale ne 0 .
*          call function 'WRITE_FORM'
*            exporting
*              element = 'DET11'
*              window  = 'MAIN'.
*          tot_sqty1 = tot_sqty1 + wa_tab18-net_qty.
*          tot_bqty1 = tot_bqty1 + wa_tab18-b_qty.
*          tot_spts1 = tot_spts1 + wa_tab18-net_sale.
*          tot_bpts1 = tot_bpts1 + wa_tab18-b_pts.
*          tot_csqty1 = tot_csqty1 + wa_tab18-cnet_qty.
*          tot_cbqty1 = tot_cbqty1 + wa_tab18-cb_qty.
*          tot_cspts1 = tot_cspts1 + wa_tab18-cnet_sale.
*          cspts1 = cspts1 + wa_tab18-cnet_sale.
*          tot_cbpts1 = tot_cbpts1 + wa_tab18-cb_pts.
*          tot_lcpts1 = tot_lcpts1 + wa_tab18-lcnet_sale.
*          t_sqty = t_sqty + wa_tab18-net_qty.
*          t_bqty = t_bqty + wa_tab18-b_qty.
*          t_spts = t_spts + wa_tab18-net_sale.
*          t_bpts = t_bpts + wa_tab18-b_pts.
*          t_csqty = t_csqty + wa_tab18-cnet_qty.
*          t_cbqty = t_cbqty + wa_tab18-cb_qty.
*          t_cspts = t_cspts + wa_tab18-cnet_sale.
**    t_cspts = t_cspts + wa_tab18-cnet.
*          t_cbpts = t_cbpts + wa_tab18-cb_pts.
*          t_lcspts = t_lcspts + wa_tab18-lcnet_sale.
*          t_lcsqty = t_lcsqty + wa_tab18-lcnet_qty.
*
*
*          dt_sqty = dt_sqty + wa_tab18-net_qty.
*          dt_bqty = dt_bqty + wa_tab18-b_qty.
*          dt_spts = dt_spts + wa_tab18-net_sale.
*          dt_bpts = dt_bpts + wa_tab18-b_pts.
*          dt_csqty = dt_csqty + wa_tab18-cnet_qty.
*          dt_cbqty = dt_cbqty + wa_tab18-cb_qty.
*          dt_cspts = dt_cspts + wa_tab18-cnet_sale.
**    t_cspts = t_cspts + wa_tab18-cnet.
*          dt_cbpts = dt_cbpts + wa_tab18-cb_pts.
*          dt_lcspts = dt_lcspts + wa_tab18-lcnet_sale.
*          dt_lcsqty = dt_lcsqty + wa_tab18-lcnet_qty.
*        endif.
*
*      endif.
**    endif.
*    else.
*      clear bud_net.
**    bud_net = wa_tab18-cnet_qty + wa_tab18-cb_pts.
*      bud_net = wa_tab18-net_sale.
**    if ( z1 eq 'X' ) and ( wa_tab18-b_pts gt 0 ).
*      if ( z1 eq 'X' ) and ( bud_net le 0 ).
*      else.
*        if r13 eq 'X'.
*          clear :  cumqty.
*          cumqty  = wa_tab18-net_sale + wa_tab18-cnet_sale.
*          if cumqty gt 0.
*            call function 'WRITE_FORM'
*              exporting
*                element = 'DET1'
*                window  = 'MAIN'.
*          endif.
*        else.
*          if wa_tab18-net_sale gt 0 or wa_tab18-b_pts > 0.
*            call function 'WRITE_FORM'
*              exporting
*                element = 'DET1'
*                window  = 'MAIN'.
*          endif.
*        endif.
*      endif.
*    endif.
*    if r12 <> 'X'.
*      t_sqty = t_sqty + wa_tab18-net_qty.
*      t_bqty = t_bqty + wa_tab18-b_qty.
*      t_spts = t_spts + wa_tab18-net_sale.
*      t_bpts = t_bpts + wa_tab18-b_pts.
*      t_csqty = t_csqty + wa_tab18-cnet_qty.
*      t_cbqty = t_cbqty + wa_tab18-cb_qty.
*      t_cspts = t_cspts + wa_tab18-cnet_sale.
**    t_cspts = t_cspts + wa_tab18-cnet.
*      t_cbpts = t_cbpts + wa_tab18-cb_pts.
*      t_lcspts = t_lcspts + wa_tab18-lcnet_sale.
*      t_lcsqty = t_lcsqty + wa_tab18-lcnet_qty.
*
*
*      dt_sqty = dt_sqty + wa_tab18-net_qty.
*      dt_bqty = dt_bqty + wa_tab18-b_qty.
*      dt_spts = dt_spts + wa_tab18-net_sale.
*      dt_bpts = dt_bpts + wa_tab18-b_pts.
*      dt_csqty = dt_csqty + wa_tab18-cnet_qty.
*      dt_cbqty = dt_cbqty + wa_tab18-cb_qty.
*      dt_cspts = dt_cspts + wa_tab18-cnet_sale.
**    t_cspts = t_cspts + wa_tab18-cnet.
*      dt_cbpts = dt_cbpts + wa_tab18-cb_pts.
*      dt_lcspts = dt_lcspts + wa_tab18-lcnet_sale.
*      dt_lcsqty = dt_lcsqty + wa_tab18-lcnet_qty.
*    endif.
*
*
*
*
*
**    on change of wa_tab18-matkl.
*    at end of grp_code.
*
**      WRITE : / 'b',T_CBQTY.
*      if r8 eq 'X'.
*        t_cspts = t_cspts / 100000.
*      endif.
*
*      if wa_tab18-grp_code ne 0.
*        if ( r3 eq 'X' and t_total ne 0 ) or ( r8 eq 'X' and g1 eq 'X' ) or ( r10 eq 'X' and t_total ne 0 ) or ( r7 eq 'X' and t_total ne 0 ).
*          if t_bpts ne 0.
*            t_ach1 = ( t_spts / t_bpts ) * 100.
*          else.
*            t_ach1 = 0.
*          endif.
*          if t_cbpts ne 0.
*            t_ach2 = ( t_cspts / t_cbpts ) * 100.
*          else.
*            t_cbpts = 0.
*          endif.
*          if t_lcsqty ne 0.
*            lgrq = ( t_csqty / t_lcsqty ) * 100 - 100.
*          else.
*            lgrq = 0.
*          endif.
*          if t_lcspts ne 0.
*            lgrv = ( t_cspts / t_lcspts ) * 100 - 100.
*          else.
*            lgrv = 0.
*          endif.
*          clear : grp_name,grp_code.
*          if wa_tab18-grp_code = 53.
*            grp_name = 'OTHERS EXL'.
*          elseif wa_tab18-grp_code = 45.
*            grp_name = 'OTHERS BC'.
*          else.
*            grp_name = 'GROUP TOTAL'.
*          endif.
*          if r9 ne 'X'.
*            call function 'WRITE_FORM'
*              exporting
*                element = 'GR1'
*                window  = 'MAIN'.
*          endif.
*
*          t_sqty = 0.
*          t_bqty = 0.
*          t_spts = 0.
*          t_bpts = 0.
*          t_csqty = 0.
*          t_cspts = 0.
*          t_cbqty = 0.
*          t_cbpts = 0.
*          t_ach1 = 0.
*          t_ach2 = 0.
*          t_lcspts = 0.
*          t_lcsqty = 0.
*          lgrv = 0.
*          lgrq = 0.
*          t_total = 0.
*        elseif r12 = 'X'.
*          t_sqty = 0.
*          t_bqty = 0.
*          t_spts = 0.
*          t_bpts = 0.
*          t_csqty = 0.
*          t_cspts = 0.
*          t_cbqty = 0.
*          t_cbpts = 0.
*          t_ach1 = 0.
*          t_ach2 = 0.
*          t_lcspts = 0.
*          t_lcsqty = 0.
*          lgrv = 0.
*          lgrq = 0.
*          t_total = 0.
*        else.
*          if r9 ne 'X'.
*            call function 'WRITE_FORM'
*              exporting
*                element = 'GR2'
*                window  = 'MAIN'.
*          endif.
*          t_sqty = 0.
*          t_bqty = 0.
*          t_spts = 0.
*          t_bpts = 0.
*          t_csqty = 0.
*          t_cspts = 0.
*          t_cbqty = 0.
*          t_cbpts = 0.
*          t_ach1 = 0.
*          t_ach2 = 0.
*          t_lcspts = 0.
*          t_lcsqty = 0.
*          lgrv = 0.
*          lgrq = 0.
*          t_total = 0.
*
*        endif.
*      endif.
*    endat.
*
************************************** DIVISION TOTAL******************************
*    at end of spart.
*      if r12 = 'X'.
*        if wa_tab18-spart eq '50'.
*          div_name = 'BC OTHER`S'.
*        elseif wa_tab18-spart eq '60'.
*          div_name = 'EXCEL OTHER`S'.
*        elseif wa_tab18-spart eq '70'.
*          div_name = 'BCLS OTHER`S'.
*        endif.
*      else.
*        if wa_tab18-spart eq '50'.
*          div_name = 'BLUECROSS DIV. TOTAL'.
*        elseif wa_tab18-spart eq '60'.
*          div_name = 'EXCEL DIV. TOTAL'.
*        elseif wa_tab18-spart eq '70'.
*          div_name = 'BCLS DIV. TOTAL'.
*        endif.
*      endif.
**********************************************************
*      if dt_bpts ne 0.
*        dt_ach1 = ( dt_spts / dt_bpts ) * 100.
*      else.
*        dt_ach1 = 0.
*      endif.
*      if dt_cbpts ne 0.
*        dt_ach2 = ( dt_cspts / dt_cbpts ) * 100.
*      else.
*        dt_cbpts = 0.
*      endif.
*      if dt_lcsqty ne 0.
*        dlgrq = ( dt_csqty / dt_lcsqty ) * 100 - 100.
*      else.
*        dlgrq = 0.
*      endif.
*      if dt_lcspts ne 0.
*        dlgrv = ( dt_cspts / dt_lcspts ) * 100 - 100.
*      else.
*        dlgrv = 0.
*      endif.
*********************************************************
**      WRITE : / 'a',DT_CBQTY.
*      call function 'WRITE_FORM'
*        exporting
*          element = 'DIV1'
*          window  = 'MAIN'.
*
*      dt_sqty = 0.
*      dt_bqty = 0.
*      dt_spts = 0.
*      dt_bpts = 0.
*      dt_csqty = 0.
*      dt_cspts = 0.
*      dt_cbqty = 0.
*      dt_cbpts = 0.
*      dt_ach1 = 0.
*      dt_ach2 = 0.
*      dt_lcspts = 0.
*      dt_lcsqty = 0.
*      dlgrv = 0.
*      dlgrq = 0.
*    endat.
*
*
*
*
**    write : /'j', wa_tab18-mvgr4,wa_tab18-bezei,wa_tab18-bezei1,wa_tab18-net_qty,wa_tab18-b_qty,wa_tab18-net_sale,wa_tab18-b_pts.
**    write : wa_tab18-ach1,wa_tab18-cnet_qty,wa_tab18-cb_qty,wa_tab18-cnet_sale,wa_tab18-cb_pts.
**    write : wa_tab18-ach2,wa_tab18-grq,wa_tab18-grv.
*
*
*
*    t_total = t_sqty + t_bqty + t_spts + t_bpts + t_csqty + t_cbqty + t_cspts + t_cbpts + t_lcspts + t_lcsqty.
*
*    tot_sqty = tot_sqty + wa_tab18-net_qty.
*    tot_bqty = tot_bqty + wa_tab18-b_qty.
*    tot_spts = tot_spts + wa_tab18-net_sale.
*    tot_bpts = tot_bpts + wa_tab18-b_pts.
*    tot_csqty = tot_csqty + wa_tab18-cnet_qty.
*    tot_lcqty = tot_lcqty + wa_tab18-lcnet_qty.
*    tot_cbqty = tot_cbqty + wa_tab18-cb_qty.
*    tot_cspts = tot_cspts + wa_tab18-cnet_sale.
*    cspts = cspts + wa_tab18-cnet_sale.
*    tot_cbpts = tot_cbpts + wa_tab18-cb_pts.
*
*    tot_lcpts = tot_lcpts + wa_tab18-lcnet_sale.
**    tot_lcbpts = tot_lcbpts + wa_tab18-lcb_pts.
*
*  endloop.
*
*
*  cspts = cspts / 100000.
**WRITE : / 'total pts',tot_spts.
*  if r9 eq 'X' or r12 = 'X'.
*    if tot_bpts1 ne 0.
*      tot_ach1 = ( tot_spts1 / tot_bpts1 ) * 100.
*    endif.
*  else.
*    if tot_bpts ne 0.
*      tot_ach1 = ( tot_spts / tot_bpts ) * 100.
*    endif.
*  endif.
*  if r9 eq 'X' or r12 = 'X'.
*    if tot_cbpts1 ne 0.
*      tot_ach2 = ( tot_cspts1 / tot_cbpts1 ) * 100.
*    endif.
*  else.
*    if tot_cbpts ne 0.
*      tot_ach2 = ( tot_cspts / tot_cbpts ) * 100.
*    endif.
*  endif.
*
*  if tot_lcqty ne 0.
*    tot_gr1 = ( ( tot_csqty / tot_lcqty ) * 100 ) - 100.
*  endif.
**  WRITE : / 'a',tot_cspts,tot_lcpts.
*  if r9 eq 'X' or r12 = 'X'.
*    if tot_lcpts1 ne 0.
*      tot_gr2 = ( ( tot_cspts1 / tot_lcpts1 ) * 100 ) - 100.
*    endif.
*  else.
*    if tot_lcpts ne 0.
*      tot_gr2 = ( ( tot_cspts / tot_lcpts ) * 100 ) - 100.
*    endif.
*  endif.
*
*  if r9 eq 'X' or r12 = 'X'.
*    call function 'WRITE_FORM'
*      exporting
*        element = 'GR2'
*        window  = 'MAIN'.
*  endif.
*
**  WRITE : / tot_gr1,tot_gr2.
*  if r9 eq 'X' or r12 = 'X'.
**    CALL FUNCTION 'WRITE_FORM'
**      EXPORTING
**        ELEMENT = 'TOT11'
**        WINDOW  = 'MAIN'.
*  else.
*    call function 'WRITE_FORM'
*      exporting
*        element = 'TOT1'
*        window  = 'MAIN'.
*  endif.
*  call function 'END_FORM'
*    exceptions
*      unopened                 = 1
*      bad_pageformat_for_print = 2
*      spool_error              = 3
*      codepage                 = 4
*      others                   = 5.
*  if sy-subrc <> 0.
*    message id sy-msgid type sy-msgty number sy-msgno
*            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*  endif.
*  if r7 ne 'X'.
*    call function 'CLOSE_FORM'
** IMPORTING
**   RESULT                         =
**   RDI_RESULT                     =
** TABLES
**   OTFDATA                        =
*      exceptions
*        unopened                 = 1
*        bad_pageformat_for_print = 2
*        send_error               = 3
*        spool_error              = 4
*        codepage                 = 5
*        others                   = 6.
*    if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    endif.
*
*  else.
*    call function 'CLOSE_FORM'
*      importing
*        result  = result
*      tables
*        otfdata = l_otf_data.
*
*    call function 'CONVERT_OTF'
*      exporting
*        format       = 'PDF'
*      importing
*        bin_filesize = l_bin_filesize
*      tables
*        otf          = l_otf_data
*        lines        = l_asc_data.
*
*    call function 'SX_TABLE_LINE_WIDTH_CHANGE'
*      exporting
*        line_width_dst = '255'
*      tables
*        content_in     = l_asc_data
*        content_out    = objbin.
*
*    write from_dt to wa_d1 dd/mm/yyyy.
*    write to_dt to wa_d2 dd/mm/yyyy.
*
*    describe table objbin lines righe_attachment.
*    objtxt = 'This eMail is meant for information only. Please DO NOT REPLY'.append objtxt.
*    objtxt = '                                 '.append objtxt.
*    objtxt = 'BLUE CROSS LABORATORIES LTD.'.append objtxt.
*    describe table objtxt lines righe_testo.
*    doc_chng-obj_name = 'URGENT'.
*    doc_chng-expiry_dat = sy-datum + 10.
*    condense ltx.
*    condense objtxt.
**      CONCATENATE 'SR9 for the period' ltx '-' INTO doc_chng-obj_descr SEPARATED BY space.
*    concatenate 'SR-1 NET FROM:' wa_d1 'TO ' wa_d2  into doc_chng-obj_descr separated by space.
*    doc_chng-sensitivty = 'F'.
*    doc_chng-doc_size = righe_testo * 255 .
*
*    clear objpack-transf_bin.
*
*    objpack-head_start = 1.
*    objpack-head_num = 0.
*    objpack-body_start = 1.
*    objpack-body_num = 4.
*    objpack-doc_type = 'TXT'.
*    append objpack.
*
*    objpack-transf_bin = 'X'.
*    objpack-head_start = 1.
*    objpack-head_num = 0.
*    objpack-body_start = 1.
*    objpack-body_num = righe_attachment.
*    objpack-doc_type = 'PDF'.
*    objpack-obj_name = 'TEST'.
*    condense ltx.
*
*    concatenate 'SR-1 NET' '.' into objpack-obj_descr separated by space.
*    objpack-doc_size = righe_attachment * 255.
*    append objpack.
*    clear objpack.
*
**    loop at it_tam2 into wa_tam2 where pernr = wa_tam1-pernr.
*    reclist-receiver =   email.
*    reclist-express = 'X'.
*    reclist-rec_type = 'U'.
*    reclist-notif_del = 'X'. " request delivery notification
*    reclist-notif_ndel = 'X'. " request not delivered notification
*    append reclist.
*    clear reclist.
**    endloop.
*    describe table reclist lines mcount.
*    if mcount > 0.
**        data: sender like soextreci1-receiver.
****ADDED BY SATHISH.B
**        types: begin of t_usr21,
**             bname type usr21-bname,
**             persnumber type usr21-persnumber,
**             addrnumber type usr21-addrnumber,
**            end of t_usr21.
**
**        types: begin of t_adr6,
**                 addrnumber type usr21-addrnumber,
**                 persnumber type usr21-persnumber,
**                 smtp_addr type adr6-smtp_addr,
**                end of t_adr6.
**
**        data: it_usr21 type table of t_usr21,
**              wa_usr21 type t_usr21,
**              it_adr6 type table of t_adr6,
**              wa_adr6 type t_adr6.
*      select  bname persnumber addrnumber from usr21 into table it_usr21
*          where bname = sy-uname.
*      if sy-subrc = 0.
*        select addrnumber persnumber smtp_addr from adr6 into table it_adr6
*          for all entries in it_usr21 where addrnumber = it_usr21-addrnumber
*                                      and   persnumber = it_usr21-persnumber.
*      endif.
*      loop at it_usr21 into wa_usr21.
*        read table it_adr6 into wa_adr6 with key addrnumber = wa_usr21-addrnumber.
*        if sy-subrc = 0.
*          sender = wa_adr6-smtp_addr.
*        endif.
*      endloop.
*      call function 'SO_DOCUMENT_SEND_API1'
*        exporting
*          document_data              = doc_chng
*          put_in_outbox              = 'X'
*          sender_address             = sender
*          sender_address_type        = 'SMTP'
**         COMMIT_WORK                = ' '
** IMPORTING
**         SENT_TO_ALL                =
**         NEW_OBJECT_ID              =
**         SENDER_ID                  =
*        tables
*          packing_list               = objpack
**         OBJECT_HEADER              =
*          contents_bin               = objbin
*          contents_txt               = objtxt
**         CONTENTS_HEX               =
**         OBJECT_PARA                =
**         OBJECT_PARB                =
*          receivers                  = reclist
*        exceptions
*          too_many_receivers         = 1
*          document_not_sent          = 2
*          document_type_not_exist    = 3
*          operation_no_authorization = 4
*          parameter_error            = 5
*          x_error                    = 6
*          enqueue_error              = 7
*          others                     = 8.
*      if sy-subrc <> 0.
*        message id sy-msgid type sy-msgty number sy-msgno
*                with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*      endif.
*
*      commit work.
*
*
*      if sy-subrc eq 0.
*
*        write : / 'EMAIL SENT ON ',email.
*      endif.
*
*
*
*      clear   : objpack,
*               objhead,
*               objtxt,
*               objbin,
*               reclist.
*
*      refresh : objpack,
*                objhead,
*                objtxt,
*                objbin,
*                reclist.
*
*    endif.
*
*  endif.
*
*
*
*  break-point .

*  perform sfform.






endform.                    "NET_FORM
*&---------------------------------------------------------------------*
*&      Form  GROSS_FORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form gross_form.
*  if r21 eq 'X'.
*    nlem = '-NLEM'.
*  endif.
  select * from zsales_tab1 into table it_zsales_tab1 where datab ge from_dt and datbi le to_dt.
*  select * from zcredit_tab1 into table it_zcredit_tab1 where datab ge from_dt and datbi le to_dt.
*  select * from zdebit_tab1 into table it_zdebit_tab1 where datab ge from_dt and datbi le to_dt.
  select * from zbudget_tab1 into table it_zbudget_tab1 where datab ge from_dt and datbi le to_dt and tag eq 'G'.

  loop at it_zsales_tab1 into wa_zsales_tab1.
    pts = wa_zsales_tab1-net + wa_zsales_tab1-ed.
    wa_tab11-matnr = wa_zsales_tab1-matnr.
    wa_tab11-pts = pts.
    wa_tab11-qty = wa_zsales_tab1-c_qty.

    wa_tab-matnr = wa_zsales_tab1-matnr.
    collect wa_tab into it_tab.
    clear wa_tab.
    collect wa_tab11 into it_tab11.
    clear wa_tab11.
    clear pts.
  endloop.

*LOOP AT IT_TAB1 INTO WA_TAB1.
*  WRITE : /'SALE', WA_TAB1-MATNR,WA_TAB1-PTS,WA_TAB1-ED,WA_TAB1-C_QTY,WA_TAB1-F_QTY.
*ENDLOOP.

  loop at it_zcredit_tab1 into wa_zcredit_tab1.
    wa_tab12-matnr = wa_zcredit_tab1-matnr.
    wa_tab12-pts = wa_zcredit_tab1-net.
    wa_tab12-qty = wa_zcredit_tab1-qty_c.
    wa_tab-matnr = wa_zcredit_tab1-matnr.
    collect wa_tab into it_tab.
    clear wa_tab.
    collect wa_tab12 into it_tab12.
    clear wa_tab12.
  endloop.


  loop at it_zdebit_tab1 into wa_zdebit_tab1.
    wa_tab13-matnr = wa_zdebit_tab1-matnr.
    wa_tab13-pts = wa_zdebit_tab1-net.
    wa_tab13-qty = wa_zdebit_tab1-qty_c.
    wa_tab-matnr = wa_zdebit_tab1-matnr.
    collect wa_tab into it_tab.
    clear wa_tab.
    collect wa_tab13 into it_tab13.
    clear wa_tab13.

  endloop.

  loop at it_zbudget_tab1 into wa_zbudget_tab1.
    wa_tab14-matnr = wa_zbudget_tab1-matnr.
    wa_tab14-pts = wa_zbudget_tab1-val.
    wa_tab14-qty = wa_zbudget_tab1-qty.
    wa_tab-matnr = wa_zbudget_tab1-matnr.
    collect wa_tab into it_tab.
    clear wa_tab.
    collect wa_tab14 into it_tab14.
    clear wa_tab14.
  endloop.


  loop at it_tab into wa_tab.
    read table it_tab11 into wa_tab11 with key matnr = wa_tab-matnr.  "sale
    if sy-subrc eq 0.
      wa_tab15-matnr = wa_tab11-matnr.
      wa_tab15-s_pts = wa_tab11-pts.
      wa_tab15-s_qty = wa_tab11-qty.
    endif.
    read table it_tab12 into wa_tab12 with key matnr = wa_tab-matnr.  "cn
    if sy-subrc eq 0.
      wa_tab15-matnr = wa_tab12-matnr.
      wa_tab15-c_pts = wa_tab12-pts.
      wa_tab15-c_qty = wa_tab12-qty.
    endif.
    read table it_tab13 into wa_tab13 with key matnr = wa_tab-matnr.  "dn
    if sy-subrc eq 0.
      wa_tab15-matnr = wa_tab13-matnr.
      wa_tab15-d_pts = wa_tab13-pts.
      wa_tab15-d_qty = wa_tab13-qty.
    endif.
    read table it_tab14 into wa_tab14 with key matnr = wa_tab-matnr.  "budget
    if sy-subrc eq 0.
      wa_tab15-matnr = wa_tab14-matnr.
      wa_tab15-b_pts = wa_tab14-pts.
      wa_tab15-b_qty = wa_tab14-qty.
    endif.
    collect wa_tab15 into it_tab15.
    clear wa_tab15.
  endloop.

  loop at it_tab15 into wa_tab15.
    clear : net_sale,net_qty.
*    WRITE : / 'a',wa_TAB15-matnr,WA_TAB15-B_PTS,WA_TAB15-B_QTY,wa_TAB15-s_pts,wa_TAB15-s_qty,wa_TAB15-c_pts,wa_TAB15-c_qty,wa_TAB15-d_pts,
*    wa_TAB15-d_qty.
    net_sale = wa_tab15-s_pts - wa_tab15-c_pts + wa_tab15-d_pts.
    net_qty = wa_tab15-s_qty - wa_tab15-c_qty + wa_tab15-d_qty.
    wa_tab16-matnr = wa_tab15-matnr.
    wa_tab16-b_pts = wa_tab15-b_pts.
    wa_tab16-b_qty = wa_tab15-b_qty.
    wa_tab16-s_pts = wa_tab15-s_pts.
    wa_tab16-s_qty = wa_tab15-s_qty.
    wa_tab16-c_pts = wa_tab15-c_pts.
    wa_tab16-c_qty = wa_tab15-c_qty.
    wa_tab16-d_pts = wa_tab15-d_pts.
    wa_tab16-d_qty = wa_tab15-d_qty.
    wa_tab16-net_sale = net_sale.
    wa_tab16-net_qty = net_qty.
    collect wa_tab16 into it_tab16.
    clear wa_tab16.
  endloop.

  loop at it_tab16 into wa_tab16.
    wa_tab17-matnr = wa_tab16-matnr.
    wa_tab17-b_pts = wa_tab16-b_pts.
    wa_tab17-b_qty = wa_tab16-b_qty.
    wa_tab17-s_pts = wa_tab16-s_pts.
    wa_tab17-s_qty = wa_tab16-s_qty.
    wa_tab17-c_pts = wa_tab16-c_pts.
    wa_tab17-c_qty = wa_tab16-c_qty.
    wa_tab17-d_pts = wa_tab16-d_pts.
    wa_tab17-d_qty = wa_tab16-d_qty.
    wa_tab17-net_sale = wa_tab16-net_sale.
    wa_tab17-net_qty = wa_tab16-net_qty.
    collect wa_tab17 into it_tab17.
    clear wa_tab17.
  endloop.


***************CURRENT MOTH SALE ENDS HERE **********************

*************CUMMULATIVE SALE STARTS HERE***************************
  c_date+6(2) = '01'.
  c_date+4(2) = '04'.

  if from_dt+4(2) lt '04'.
    c_date+0(4) = from_dt+0(4) - 1.
  else.
    c_date+0(4) = from_dt+0(4).
  endif.
*  write : / 'cummulative date',c_date.

  select * from zsales_tab1 into table it_zsales_tab2 where datab ge c_date and datbi le to_dt.
  if it_zsales_tab2 is not initial.
    loop at it_zsales_tab2 into wa_zsales_tab2.
      wa_ctab1-matnr = wa_zsales_tab2-matnr.
      wa_ctab1-pts = wa_zsales_tab2-net + wa_zsales_tab2-ed.
      wa_ctab1-qty = wa_zsales_tab2-c_qty.
      collect wa_ctab1 into it_ctab1.
      clear wa_ctab1.
      wa_ta-matnr = wa_zsales_tab2-matnr.
      collect wa_ta into it_ta.
      clear wa_ta.
    endloop.
  endif.

*  select * from zcredit_tab1 into table it_zcredit_tab2 where datab ge c_date and datbi le to_dt.
  if it_zcredit_tab2 is not initial.
    loop at it_zcredit_tab2 into wa_zcredit_tab2.
      wa_ctab2-matnr = wa_zcredit_tab2-matnr.
      wa_ctab2-pts = wa_zcredit_tab2-net.
      wa_ctab2-qty = wa_zcredit_tab2-qty_c.
      collect wa_ctab2 into it_ctab2.
      clear wa_ctab2.
      wa_ta-matnr = wa_zcredit_tab2-matnr.
      collect wa_ta into it_ta.
      clear wa_ta.
    endloop.
  endif.

*  select * from zdebit_tab1 into table it_zdebit_tab2 where datab ge c_date and datbi le to_dt.
  if it_zdebit_tab2 is not initial.
    loop at it_zdebit_tab2 into wa_zdebit_tab2.
      wa_ctab3-matnr = wa_zdebit_tab2-matnr.
      wa_ctab3-pts = wa_zdebit_tab2-net.
      wa_ctab3-qty = wa_zdebit_tab2-qty_c.
      collect wa_ctab3 into it_ctab3.
      clear wa_ctab3.
      wa_ta-matnr = wa_zdebit_tab2-matnr.
      collect wa_ta into it_ta.
      clear wa_ta.
    endloop.
  endif.

  select * from zbudget_tab1 into table it_zbudget_tab2 where datab ge c_date and datbi le to_dt and tag eq 'G'.
  if it_zbudget_tab2 is not initial.
    loop at it_zbudget_tab2 into wa_zbudget_tab2.
*      WRITE : / 'budget',c_date,TO_DT,wa_zBUDGET_tab2-matnr,wa_zBUDGET_tab2-qty.
      wa_ctab4-matnr = wa_zbudget_tab2-matnr.
      wa_ctab4-pts = wa_zbudget_tab2-val.
      wa_ctab4-qty = wa_zbudget_tab2-qty.
      collect wa_ctab4 into it_ctab4.
      clear wa_ctab4.
      wa_ta-matnr = wa_zbudget_tab2-matnr.
      collect wa_ta into it_ta.
      clear wa_ta.
    endloop.
  endif.

  sort it_ta.
  delete adjacent duplicates from it_ta.

  loop at it_ta into wa_ta.
    read table it_ctab1 into wa_ctab1 with key matnr = wa_ta-matnr.
    if sy-subrc eq 0.
      wa_ctab5-matnr = wa_ctab1-matnr.
      wa_ctab5-s_pts = wa_ctab1-pts.
      wa_ctab5-s_qty = wa_ctab1-qty.
    endif.
    read table it_ctab2 into wa_ctab2 with key matnr = wa_ta-matnr.
    if sy-subrc eq 0.
      wa_ctab5-matnr = wa_ctab2-matnr.
      wa_ctab5-c_pts = wa_ctab2-pts.
      wa_ctab5-c_qty = wa_ctab2-qty.
    endif.
    read table it_ctab3 into wa_ctab3 with key matnr = wa_ta-matnr.
    if sy-subrc eq 0.
      wa_ctab5-matnr = wa_ctab3-matnr.
      wa_ctab5-d_pts = wa_ctab3-pts.
      wa_ctab5-d_qty = wa_ctab3-qty.
    endif.
    read table it_ctab4 into wa_ctab4 with key matnr = wa_ta-matnr.
    if sy-subrc eq 0.
      wa_ctab5-matnr = wa_ctab4-matnr.
      wa_ctab5-b_pts = wa_ctab4-pts.
      wa_ctab5-b_qty = wa_ctab4-qty.
    endif.
    collect wa_ctab5 into it_ctab5.
    clear wa_ctab5.
  endloop.

  loop at it_ctab5 into wa_ctab5.
    clear : cnet_sale,cnet_qty.
    wa_ctab6-matnr = wa_ctab5-matnr.
    wa_ctab6-s_pts = wa_ctab5-s_pts.
    wa_ctab6-s_qty = wa_ctab5-s_qty.
    wa_ctab6-c_pts = wa_ctab5-c_pts.
    wa_ctab6-c_qty = wa_ctab5-c_qty.
    wa_ctab6-d_pts = wa_ctab5-d_pts.
    wa_ctab6-d_qty = wa_ctab5-d_qty.
    wa_ctab6-b_pts = wa_ctab5-b_pts.
    wa_ctab6-b_qty = wa_ctab5-b_qty.
    cnet_sale = wa_ctab5-s_pts - wa_ctab5-c_pts + wa_ctab5-d_pts.
    cnet_qty = wa_ctab5-s_qty - wa_ctab5-c_qty + wa_ctab5-d_qty.
    wa_ctab6-net_sale = cnet_sale.
    wa_ctab6-net_qty = cnet_qty.
    collect wa_ctab6 into it_ctab6.
    clear wa_ctab6.
  endloop.
  sort it_ctab6 by bezei.

  loop at it_ctab6 into wa_ctab6.
    wa_ctab7-matnr = wa_ctab6-matnr.
    wa_ctab7-s_pts = wa_ctab6-s_pts.
    wa_ctab7-s_qty = wa_ctab6-s_qty.
    wa_ctab7-c_pts = wa_ctab6-c_pts.
    wa_ctab7-c_qty = wa_ctab6-c_qty.
    wa_ctab7-d_pts = wa_ctab6-d_pts.
    wa_ctab7-d_qty = wa_ctab6-d_qty.
    wa_ctab7-b_pts = wa_ctab6-b_pts.
    wa_ctab7-b_qty = wa_ctab6-b_qty.
    wa_ctab7-net_sale = wa_ctab6-net_sale.
    wa_ctab7-net_qty = wa_ctab6-net_qty.
    collect wa_ctab7 into it_ctab7.
    clear wa_ctab7.
  endloop.

*  LOOP AT IT_CTAB7 INTO WA_CTAB7.
*    WRITE : /'a1',wa_tab7-mvgr4,wa_ctab7-bezei,'net',wa_ctab7-net_qty,'sale',WA_CTAB7-S_QTY,'credit',wa_ctab7-c_qty,'debit',wa_ctab7-d_qty,'bud',wa_ctab7-b_qty,wa_ctab7-net_sale,wa_ctab7-b_pts.
*  ENDLOOP.

**************CUMMULATIVE DATA ENDS HERE********************

******************LAST YEAR CUMMULATIVE DATA STARTS*****************

  ll_date = c_date.
  ll_date+0(4) = c_date+0(4) - 1.
  lc_date = to_dt.
  lc_date+0(4) = to_dt+0(4) - 1.
*  write : / 'last fiscal year',ll_date,'last year same date',lc_date.

*******************************************************
  clear : ndt1,ndt2.
  ndt1 = lc_date.
  ndt1+6(2) = '01'.
  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date           = ndt1
    importing
*     EV_MONTH_BEGIN_DATE       =
      ev_month_end_date = ndt2.
  lc_date = ndt2.
*************************************************************************

*WRITE : / 'date',lc_date.
  if lc_date = '20160228'.
    lc_date = '20160229'.
  endif.
*WRITE : / 'date',lc_date.

  select * from zsales_tab1 into table it_zsales_tab3 where datab ge ll_date and datbi le lc_date.
  if it_zsales_tab3 is not initial.
    loop at it_zsales_tab3 into wa_zsales_tab3.
      wa_lctab1-matnr = wa_zsales_tab3-matnr.
      wa_lctab1-pts = wa_zsales_tab3-net + wa_zsales_tab3-ed.
      wa_lctab1-qty = wa_zsales_tab3-c_qty.
      collect wa_lctab1 into it_lctab1.
      clear wa_lctab1.
      wa_t-matnr = wa_zsales_tab3-matnr.
      collect wa_t into it_t.
      clear wa_t.
    endloop.
  endif.

*  select * from zcredit_tab1 into table it_zcredit_tab3 where datab ge ll_date and datbi le lc_date.
  if it_zcredit_tab3 is not initial.
    loop at it_zcredit_tab3 into wa_zcredit_tab3.
      wa_lctab2-matnr = wa_zcredit_tab3-matnr.
      wa_lctab2-pts = wa_zcredit_tab3-net.
      wa_lctab2-qty = wa_zcredit_tab3-qty_c.
      collect wa_lctab2 into it_lctab2.
      clear wa_lctab2.
      wa_t-matnr = wa_zcredit_tab3-matnr.
      collect wa_t into it_t.
      clear wa_t.
    endloop.
  endif.

*  select * from zdebit_tab1 into table it_zdebit_tab3 where datab ge ll_date and datbi le lc_date.
  if it_zdebit_tab3 is not initial.
    loop at it_zdebit_tab3 into wa_zdebit_tab3.
      wa_lctab3-matnr = wa_zdebit_tab3-matnr.
      wa_lctab3-pts = wa_zdebit_tab3-net.
      wa_lctab3-qty = wa_zdebit_tab3-qty_c.
      collect wa_lctab3 into it_lctab3.
      clear wa_lctab3.
      wa_t-matnr = wa_zdebit_tab3-matnr.
      collect wa_t into it_t.
      clear wa_t.
    endloop.
  endif.


  loop at it_t into wa_t.
    read table it_lctab1 into wa_lctab1 with key matnr = wa_t-matnr.
    if sy-subrc eq 0.
      wa_lctab4-matnr = wa_lctab1-matnr.
      wa_lctab4-s_pts = wa_lctab1-pts.
      wa_lctab4-s_qty = wa_lctab1-qty.
    endif.
    read table it_lctab2 into wa_lctab2 with key matnr = wa_t-matnr.
    if sy-subrc eq 0.
      wa_lctab4-matnr = wa_lctab2-matnr.
      wa_lctab4-c_pts = wa_lctab2-pts.
      wa_lctab4-c_qty = wa_lctab2-qty.
    endif.
    read table it_lctab3 into wa_lctab3 with key matnr = wa_t-matnr.
    if sy-subrc eq 0.
      wa_lctab4-matnr = wa_lctab3-matnr.
      wa_lctab4-d_pts = wa_lctab3-pts.
      wa_lctab4-d_qty = wa_lctab3-qty.
    endif.
    collect wa_lctab4 into it_lctab4.
    clear wa_lctab4.
  endloop.

  loop at it_lctab4 into wa_lctab4.
    clear : lcnet_sale,lcnet_qty.
    wa_lctab5-matnr = wa_lctab4-matnr.
    wa_lctab5-s_pts = wa_lctab4-s_pts.
    wa_lctab5-s_qty = wa_lctab4-s_qty.
    wa_lctab5-c_pts = wa_lctab4-c_pts.
    wa_lctab5-c_qty = wa_lctab4-c_qty.
    wa_lctab5-d_pts = wa_lctab4-d_pts.
    wa_lctab5-d_qty = wa_lctab4-d_qty.
    lcnet_sale = wa_lctab4-s_pts - wa_lctab4-c_pts + wa_lctab4-d_pts.
    lcnet_qty = wa_lctab4-s_qty - wa_lctab4-c_qty + wa_lctab4-d_qty.
    wa_lctab5-net_sale = lcnet_sale.
    wa_lctab5-net_qty = lcnet_qty.
    collect wa_lctab5 into it_lctab5.
    clear wa_lctab5.
  endloop.

  loop at it_lctab5 into wa_lctab5.
*    WRITE : / 'last yeat net sale',wa_lctab5-matnr,wa_lctab5-net_sale.
    wa_lctab6-matnr = wa_lctab5-matnr.
    wa_lctab6-s_pts = wa_lctab5-s_pts.
    wa_lctab6-s_qty = wa_lctab5-s_qty.
    wa_lctab6-c_pts = wa_lctab5-c_pts.
    wa_lctab6-c_qty = wa_lctab5-c_qty.
    wa_lctab6-d_pts = wa_lctab5-d_pts.
    wa_lctab6-d_qty = wa_lctab5-d_qty.
    wa_lctab6-net_sale = wa_lctab5-net_sale.
    wa_lctab6-net_qty = wa_lctab5-net_qty.
    collect wa_lctab6 into it_lctab6.
    clear wa_lctab6.
  endloop.


  sort it_tab17 by matnr .
  loop at it_tab into wa_tab.
    wa_mat1-matnr = wa_tab-matnr.
    collect wa_mat1 into it_mat1.
    clear wa_mat1.
  endloop.
  loop at it_ta into wa_ta.
    wa_mat1-matnr = wa_ta-matnr.
    collect wa_mat1 into it_mat1.
    clear wa_mat1.
  endloop.
  loop at it_t into wa_t.
    wa_mat1-matnr = wa_t-matnr.
    collect wa_mat1 into it_mat1.
    clear wa_mat1.
  endloop.

  sort it_mat1 by matnr.
  delete adjacent duplicates from it_mat1 comparing matnr.

  if it_mat1 is not initial.
    select * from mvke into table it_mvke for all entries in it_mat1 where matnr eq it_mat1-matnr and vkorg eq '1000' and vtweg eq '10'.
  endif.
  if it_mat1 is not initial.
    select * from mvke into table it_mvke1 for all entries in it_mat1 where matnr eq it_mat1-matnr and vkorg eq '1000' and vtweg eq '10'
      and kondm in ('03','04').
  endif.
  sort it_mvke by matnr descending.
  sort it_tab17 by matnr.
  sort it_ctab6 by matnr.
  sort it_lctab6 by matnr.

*  if r21 eq 'X'.
*
*    loop at it_mat1 into wa_mat1.
*      read table it_mvke1 into wa_mvke1 with key matnr = wa_mat1-matnr.
*      if sy-subrc eq 0.
**    WRITE : / 'material',wa_mat1-matnr.
*        clear : ach1,ach2,grq,grv.
**  loop at it_tab17 into wa_tab17.
*        read table it_tab17 into wa_tab17 with key matnr = wa_mat1-matnr.
*        if sy-subrc eq 0.
*          wa_tab181-matnr = wa_tab17-matnr.
*          wa_tab181-net_qty = wa_tab17-net_qty.
*          wa_tab181-net_sale = wa_tab17-net_sale.
*          wa_tab181-b_qty = wa_tab17-b_qty.
*          wa_tab181-b_pts = wa_tab17-b_pts.
*        endif.
*        read table it_ctab7 into wa_ctab7 with key matnr = wa_mat1-matnr.
*        if sy-subrc eq 0.
*          wa_tab181-matnr = wa_ctab7-matnr.
*          wa_tab181-cnet_qty = wa_ctab7-net_qty.
*          wa_tab181-cnet_sale = wa_ctab7-net_sale.
*          wa_tab181-cb_qty = wa_ctab7-b_qty.
*          wa_tab181-cb_pts = wa_ctab7-b_pts.
*        endif.
*        read table it_lctab6 into wa_lctab6 with key matnr = wa_mat1-matnr.
*        if sy-subrc eq 0.
**      WRITE : / 'found',wa_lctab6-matnr,wa_lctab6-mvgr4,wa_lctab6-net_sale.
*          wa_tab181-matnr = wa_lctab6-matnr.
*          wa_tab181-lcnet_sale = wa_lctab6-net_sale.
*          wa_tab181-lcnet_qty = wa_lctab6-net_qty.
*        endif.
*        collect wa_tab181 into it_tab181.
*        clear wa_tab181.
*      endif.
*    endloop.
*
*  else.
  loop at it_mat1 into wa_mat1.
*    WRITE : / 'material',wa_mat1-matnr.
    clear : ach1,ach2,grq,grv.
*  loop at it_tab17 into wa_tab17.
    read table it_tab17 into wa_tab17 with key matnr = wa_mat1-matnr.
    if sy-subrc eq 0.
      wa_tab181-matnr = wa_tab17-matnr.
      wa_tab181-net_qty = wa_tab17-net_qty.
      wa_tab181-net_sale = wa_tab17-net_sale.
      wa_tab181-b_qty = wa_tab17-b_qty.
      wa_tab181-b_pts = wa_tab17-b_pts.
    endif.
    read table it_ctab7 into wa_ctab7 with key matnr = wa_mat1-matnr.
    if sy-subrc eq 0.
      wa_tab181-matnr = wa_ctab7-matnr.
      wa_tab181-cnet_qty = wa_ctab7-net_qty.
      wa_tab181-cnet_sale = wa_ctab7-net_sale.
      wa_tab181-cb_qty = wa_ctab7-b_qty.
      wa_tab181-cb_pts = wa_ctab7-b_pts.
    endif.
    read table it_lctab6 into wa_lctab6 with key matnr = wa_mat1-matnr.
    if sy-subrc eq 0.
*      WRITE : / 'found',wa_lctab6-matnr,wa_lctab6-mvgr4,wa_lctab6-net_sale.
      wa_tab181-matnr = wa_lctab6-matnr.
      wa_tab181-lcnet_sale = wa_lctab6-net_sale.
      wa_tab181-lcnet_qty = wa_lctab6-net_qty.
    endif.
    collect wa_tab181 into it_tab181.
    clear wa_tab181.
  endloop.

*  endif.

  loop at it_tab181 into wa_tab181 where matnr ne '                  '.

*    wa_tab182-matnr = wa_tab181-matnr.
    wa_tab182-net_qty = wa_tab181-net_qty.
    wa_tab182-net_sale = wa_tab181-net_sale.
    wa_tab182-b_qty = wa_tab181-b_qty.
    wa_tab182-b_pts = wa_tab181-b_pts.
    wa_tab182-cnet_qty = wa_tab181-cnet_qty.
    wa_tab182-cb_qty = wa_tab181-cb_qty.
    wa_tab182-cnet_sale = wa_tab181-cnet_sale.
    wa_tab182-cb_pts = wa_tab181-cb_pts.
    wa_tab182-lcnet_sale = wa_tab181-lcnet_sale.
    wa_tab182-lcnet_qty = wa_tab181-lcnet_qty.

    select single * from mara where matnr eq wa_tab181-matnr.
    if sy-subrc eq 0.
      wa_tab182-spart = mara-spart.
    endif.

    select single * from zprdgroup where rep_type eq 'SR2' and prd_code eq mara-matnr.
    if sy-subrc eq 0.
      wa_tab182-prn_seq = zprdgroup-prn_seq.
      wa_tab182-grp_code = zprdgroup-grp_code.
      wa_tab182-subgrp_code = zprdgroup-subgrp_code.
      wa_tab182-subgrp_name = zprdgroup-subgrp_name.
*      WRITE : / 'material',wa_tab181-matnr,ZPRDGROUP-PRN_SEQ,ZPRDGROUP-GRP_CODE, WA_TAB182-PRN_SEQ,WA_TAB182-GRP_CODE .
    else.
      format color 6.
      write :  'MATERIL CODE NOT MAINTAINED IN ZPRDGROUP',wa_tab181-matnr.
    endif.

*    select single * from mvke where matnr eq wa_tab181-matnr and vkorg eq '1000' and vtweg eq '10' .
*    if sy-subrc eq 0.
*      select single * from tvm5t where spras eq 'EN' and mvgr5 eq mvke-mvgr5.
*      if sy-subrc eq 0.
*        wa_tab182-bezei = tvm5t-bezei.
*      endif.
*    endif.

    select single * from mvke where matnr eq wa_tab181-matnr and vkorg eq '1000' and vtweg eq '10' .
    if sy-subrc eq 0.
      wa_tab182-mvgr4 = mvke-mvgr4.
    endif.

    select single * from tvm4t where spras eq 'EN' and mvgr4 eq wa_tab182-mvgr4.
    if sy-subrc eq 0.
      wa_tab182-maktx = tvm4t-bezei.
    else.
      format color 6.
      write : / 'PRODUCT DESCRIPTIO NOT FOUND FOR ',wa_tab181-matnr.
    endif.

    collect wa_tab182 into it_tab182.
    clear wa_tab182.
  endloop.

  sort it_tab182 by spart prn_seq grp_code.
  loop at it_tab182 into wa_tab182.
    clear : ach1,ach2,grq,grv.
*    FORMAT COLOR 1.
*    WRITE : / '182',WA_TAB182-mvgr4,WA_TAB182-spart,WA_TAB182-prn_seq,WA_TAB182-grp_code,wa_tab182-bezei,wa_tab182-maktx.
    wa_tab18-mvgr4 = wa_tab182-mvgr4.
***************pack size*************
*    wa_tab18-bezei = wa_tab182-bezei.
*    select single * from mvke where matnr eq wa_tab181-matnr and vkorg eq '1000' and vtweg eq '10' .
*    if sy-subrc eq 0.
*      select single * from tvm5t where spras eq 'EN' and mvgr5 eq mvke-mvgr5.
*      if sy-subrc eq 0.
*        wa_tab182-bezei = tvm5t-bezei.
*      endif.
*    endif.
    read table it_mvke into wa_mvke with key mvgr4 = wa_tab182-mvgr4.
    if sy-subrc eq 0.
      select single * from tvm5t where spras eq 'EN' and mvgr5 eq wa_mvke-mvgr5.
      if sy-subrc eq 0.
        wa_tab18-bezei = tvm5t-bezei.
      endif.
    endif.
***********************************
    wa_tab18-maktx = wa_tab182-maktx.
    wa_tab18-spart = wa_tab182-spart.
    wa_tab18-prn_seq = wa_tab182-prn_seq.
    wa_tab18-grp_code = wa_tab182-grp_code.
    wa_tab18-subgrp_code = wa_tab182-subgrp_code.
    wa_tab18-subgrp_name = wa_tab182-subgrp_name.
    wa_tab18-net_qty = wa_tab182-net_qty.
    wa_tab18-net_sale = wa_tab182-net_sale.
    wa_tab18-b_qty = wa_tab182-b_qty.
    wa_tab18-b_pts = wa_tab182-b_pts.
    wa_tab18-cnet_qty = wa_tab182-cnet_qty.
    wa_tab18-cb_qty = wa_tab182-cb_qty.
    wa_tab18-cnet_sale = wa_tab182-cnet_sale.
    wa_tab18-cb_pts = wa_tab182-cb_pts.
    wa_tab18-lcnet_sale = wa_tab182-lcnet_sale.
    wa_tab18-lcnet_qty = wa_tab182-lcnet_qty.

    if wa_tab18-b_pts ne 0.
      ach1 = ( wa_tab18-net_sale / wa_tab18-b_pts ) * 100.
    endif.
    wa_tab18-ach1 = ach1.
    if wa_tab18-cb_pts ne 0.
      ach2 = ( wa_tab18-cnet_sale / wa_tab18-cb_pts ) * 100.
    endif.
    wa_tab18-ach2 = ach2.
    if wa_tab18-lcnet_qty ne 0.
      grq = ( wa_tab18-cnet_qty / wa_tab18-lcnet_qty ) * 100 - 100.
    endif.
    wa_tab18-grq = grq.
    if wa_tab18-lcnet_sale ne 0.
      grv = ( wa_tab18-cnet_sale / wa_tab18-lcnet_sale ) * 100 - 100.
    endif.
    wa_tab18-grv = grv.

    collect wa_tab18 into it_tab18.
    clear wa_tab18.
  endloop.

  sort it_tab18 by spart prn_seq grp_code subgrp_code.

  perform sfform.

*  call function 'OPEN_FORM'
*    exporting
*      device   = 'PRINTER'
*      dialog   = 'X'
**     form     = 'ZSR1'
*      language = sy-langu
*    exceptions
*      canceled = 1
*      device   = 2.
*  if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  endif.
*
*  call function 'START_FORM'
*    exporting
*      form        = 'ZSR41G'
*      language    = sy-langu
*    exceptions
*      form        = 1
*      format      = 2
*      unended     = 3
*      unopened    = 4
*      unused      = 5
*      spool_error = 6
*      codepage    = 7
*      others      = 8.
*  if sy-subrc <> 0.
*    message id sy-msgid type sy-msgty number sy-msgno
*            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*  endif.
*
**  ENDIF.
*  select single * from t247 where spras eq 'EN' and mnr eq from_dt+4(2).
*  if sy-subrc eq 0.
**    write : t247-ktx.
*    month = t247-ktx.
*    concatenate month '.' from_dt+0(4) into month1.
*  endif.
*
**  sort it_tab18 by begru matkl.
*  sort it_tab18 by spart prn_seq grp_code maktx.
*  loop at it_tab18 into wa_tab18.
*
*    call function 'WRITE_FORM'
*      exporting
*        element = 'HEADD'
*        window  = 'WINDOW1'.
*
*    if wa_tab18-spart eq '50'.
*      on change of wa_tab18-spart.
**        write : / 'BLUE CROSS'.
*        call function 'WRITE_FORM'
*          exporting
*            element = 'HEAD'
*            window  = 'MAIN'.
**        uline.
*      endon.
*    endif.
*
*    if wa_tab18-spart eq '60'.
*      on change of wa_tab18-spart.
**        write : / 'EXCEL'.
*        call function 'WRITE_FORM'
*          exporting
*            element = 'HEAD1'
*            window  = 'MAIN'.
**        uline.
*      endon.
*    endif.
*
*    if wa_tab18-spart eq '70'.
*      on change of wa_tab18-spart.
**        write : / 'EXCEL'.
*        call function 'WRITE_FORM'
*          exporting
*            element = 'HEAD2'
*            window  = 'MAIN'.
**        uline.
*      endon.
*    endif.
**    if ( z1 eq 'X' ) and ( wa_tab18-net_qty le 0 ).
*    clear bud_net.
*    bud_net = wa_tab18-cnet_qty + wa_tab18-cb_pts.
*    if ( z1 eq 'X' ) and ( bud_net le 0 ).
*    else.
*      call function 'WRITE_FORM'
*        exporting
*          element = 'DET1'
*          window  = 'MAIN'.
*    endif.
*
*    t_sqty = t_sqty + wa_tab18-net_qty.
*    t_bqty = t_bqty + wa_tab18-b_qty.
*    t_spts = t_spts + wa_tab18-net_sale.
*    t_bpts = t_bpts + wa_tab18-b_pts.
*    t_csqty = t_csqty + wa_tab18-cnet_qty.
*    t_cbqty = t_cbqty + wa_tab18-cb_qty.
*    t_cspts = t_cspts + wa_tab18-cnet_sale.
*    t_cbpts = t_cbpts + wa_tab18-cb_pts.
*    t_lcspts = t_lcspts + wa_tab18-lcnet_sale.
*    t_lcsqty = t_lcsqty + wa_tab18-lcnet_qty.
*
**    on change of wa_tab18-matkl.
*    at end of grp_code.
*
*
*      if wa_tab18-grp_code ne 0.
*        if t_total ne 0.
*          if t_bpts ne 0.
*            t_ach1 = ( t_spts / t_bpts ) * 100.
*          else.
*            t_ach1 = 0.
*          endif.
*          if t_cbpts ne 0.
*            t_ach2 = ( t_cspts / t_cbpts ) * 100.
*          else.
*            t_cbpts = 0.
*          endif.
*          if t_lcsqty ne 0.
*            lgrq = ( t_csqty / t_lcsqty ) * 100 - 100.
*          else.
*            lgrq = 0.
*          endif.
*          if t_lcspts ne 0.
*            lgrv = ( t_cspts / t_lcspts ) * 100 - 100.
*          else.
*            lgrv = 0.
*          endif.
*          clear : grp_name,grp_code.
*          if wa_tab18-grp_code = 53.
*            grp_name = 'OTHERS EXL'.
*          elseif wa_tab18-grp_code = 45.
*            grp_name = 'OTHERS BC'.
*          else.
*            grp_name = 'GROUP TOTAL'.
*          endif.
*
*          call function 'WRITE_FORM'
*            exporting
*              element = 'GR1'
*              window  = 'MAIN'.
*
*          t_sqty = 0.
*          t_bqty = 0.
*          t_spts = 0.
*          t_bpts = 0.
*          t_csqty = 0.
*          t_cspts = 0.
*          t_cbqty = 0.
*          t_cbpts = 0.
*          t_ach1 = 0.
*          t_ach2 = 0.
*          t_lcspts = 0.
*          t_lcsqty = 0.
*          lgrv = 0.
*          lgrq = 0.
*          t_total = 0.
*        else.
*          call function 'WRITE_FORM'
*            exporting
*              element = 'GR2'
*              window  = 'MAIN'.
*          t_sqty = 0.
*          t_bqty = 0.
*          t_spts = 0.
*          t_bpts = 0.
*          t_csqty = 0.
*          t_cspts = 0.
*          t_cbqty = 0.
*          t_cbpts = 0.
*          t_ach1 = 0.
*          t_ach2 = 0.
*          t_lcspts = 0.
*          t_lcsqty = 0.
*          lgrv = 0.
*          lgrq = 0.
*          t_total = 0.
*
*        endif.
*      endif.
*    endat.
*
*
*
**    write : /'j', wa_tab18-mvgr4,wa_tab18-bezei,wa_tab18-bezei1,wa_tab18-net_qty,wa_tab18-b_qty,wa_tab18-net_sale,wa_tab18-b_pts.
**    write : wa_tab18-ach1,wa_tab18-cnet_qty,wa_tab18-cb_qty,wa_tab18-cnet_sale,wa_tab18-cb_pts.
**    write : wa_tab18-ach2,wa_tab18-grq,wa_tab18-grv.
*
*
*
*    t_total = t_sqty + t_bqty + t_spts + t_bpts + t_csqty + t_cbqty + t_cspts + t_cbpts + t_lcspts + t_lcsqty.
*
*    tot_sqty = tot_sqty + wa_tab18-net_qty.
*    tot_bqty = tot_bqty + wa_tab18-b_qty.
*    tot_spts = tot_spts + wa_tab18-net_sale.
*    tot_bpts = tot_bpts + wa_tab18-b_pts.
*    tot_csqty = tot_csqty + wa_tab18-cnet_qty.
*    tot_cbqty = tot_cbqty + wa_tab18-cb_qty.
*    tot_cspts = tot_cspts + wa_tab18-cnet_sale.
*    tot_cbpts = tot_cbpts + wa_tab18-cb_pts.
*
*    tot_lcpts = tot_lcpts + wa_tab18-lcnet_sale.
**    tot_lcbpts = tot_lcbpts + wa_tab18-lcb_pts.
*
*  endloop.
**WRITE : / 'total pts',tot_spts.
*  if tot_bpts ne 0.
*    tot_ach1 = ( tot_spts / tot_bpts ) * 100.
*  endif.
*  if tot_cbpts ne 0.
*    tot_ach2 = ( tot_cspts / tot_cbpts ) * 100.
*  endif.
*  if tot_lcqty ne 0.
*    tot_gr1 = ( ( tot_csqty / tot_lcqty ) * 100 ) - 100.
*  endif.
**  WRITE : / 'a',tot_cspts,tot_lcpts.
*  if tot_lcpts ne 0.
*    tot_gr2 = ( ( tot_cspts / tot_lcpts ) * 100 ) - 100.
*  endif.
*
**  WRITE : / tot_gr1,tot_gr2.
*  call function 'WRITE_FORM'
*    exporting
*      element = 'TOT1'
*      window  = 'MAIN'.
*  call function 'END_FORM'
*    exceptions
*      unopened                 = 1
*      bad_pageformat_for_print = 2
*      spool_error              = 3
*      codepage                 = 4
*      others                   = 5.
*  if sy-subrc <> 0.
*    message id sy-msgid type sy-msgty number sy-msgno
*            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*  endif.
*
*  call function 'CLOSE_FORM'
** IMPORTING
**   RESULT                         =
**   RDI_RESULT                     =
** TABLES
**   OTFDATA                        =
*    exceptions
*      unopened                 = 1
*      bad_pageformat_for_print = 2
*      send_error               = 3
*      spool_error              = 4
*      codepage                 = 5
*      others                   = 6.
*  if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  endif.



endform.                    "GROSS_FORM

*&---------------------------------------------------------------------*
*&      Form  GROSS_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form gross_alv.

  select * from zsales_tab1 into table it_zsales_tab1 where datab ge from_dt and datbi le to_dt.
*  select * from zcredit_tab1 into table it_zcredit_tab1 where datab ge from_dt and datbi le to_dt.
*  select * from zdebit_tab1 into table it_zdebit_tab1 where datab ge from_dt and datbi le to_dt.
  select * from zbudget_tab1 into table it_zbudget_tab1 where datab ge from_dt and datbi le to_dt and tag eq 'G'.

  loop at it_zsales_tab1 into wa_zsales_tab1.

    pts = wa_zsales_tab1-net + wa_zsales_tab1-ed.
    wa_tab11-matnr = wa_zsales_tab1-matnr.
    wa_tab11-pts = pts.
    wa_tab11-qty = wa_zsales_tab1-c_qty.

    wa_tab-matnr = wa_zsales_tab1-matnr.
    collect wa_tab into it_tab.
    clear wa_tab.
    collect wa_tab11 into it_tab11.
    clear wa_tab11.
    clear pts.
  endloop.

*LOOP AT IT_TAB1 INTO WA_TAB1.
*  WRITE : /'SALE', WA_TAB1-MATNR,WA_TAB1-PTS,WA_TAB1-ED,WA_TAB1-C_QTY,WA_TAB1-F_QTY.
*ENDLOOP.

  loop at it_zcredit_tab1 into wa_zcredit_tab1.
    wa_tab12-matnr = wa_zcredit_tab1-matnr.
    wa_tab12-pts = wa_zcredit_tab1-net.
    wa_tab12-qty = wa_zcredit_tab1-qty_c.
    wa_tab-matnr = wa_zcredit_tab1-matnr.
    collect wa_tab into it_tab.
    clear wa_tab.
    collect wa_tab12 into it_tab12.
    clear wa_tab12.
  endloop.


  loop at it_zdebit_tab1 into wa_zdebit_tab1.
    wa_tab13-matnr = wa_zdebit_tab1-matnr.
    wa_tab13-pts = wa_zdebit_tab1-net.
    wa_tab13-qty = wa_zdebit_tab1-qty_c.
    wa_tab-matnr = wa_zdebit_tab1-matnr.
    collect wa_tab into it_tab.
    clear wa_tab.
    collect wa_tab13 into it_tab13.
    clear wa_tab13.

  endloop.

  loop at it_zbudget_tab1 into wa_zbudget_tab1.
    wa_tab14-matnr = wa_zbudget_tab1-matnr.
    wa_tab14-pts = wa_zbudget_tab1-val.
    wa_tab14-qty = wa_zbudget_tab1-qty.
    wa_tab-matnr = wa_zbudget_tab1-matnr.
    collect wa_tab into it_tab.
    clear wa_tab.
    collect wa_tab14 into it_tab14.
    clear wa_tab14.
  endloop.

  loop at it_tab into wa_tab.
    read table it_tab11 into wa_tab11 with key matnr = wa_tab-matnr.  "sale
    if sy-subrc eq 0.
      wa_tab15-matnr = wa_tab11-matnr.
      wa_tab15-s_pts = wa_tab11-pts.
      wa_tab15-s_qty = wa_tab11-qty.
    endif.
    read table it_tab12 into wa_tab12 with key matnr = wa_tab-matnr.  "cn
    if sy-subrc eq 0.
      wa_tab15-matnr = wa_tab12-matnr.
      wa_tab15-c_pts = wa_tab12-pts.
      wa_tab15-c_qty = wa_tab12-qty.
    endif.
    read table it_tab13 into wa_tab13 with key matnr = wa_tab-matnr.  "dn
    if sy-subrc eq 0.
      wa_tab15-matnr = wa_tab13-matnr.
      wa_tab15-d_pts = wa_tab13-pts.
      wa_tab15-d_qty = wa_tab13-qty.
    endif.
    read table it_tab14 into wa_tab14 with key matnr = wa_tab-matnr.  "budget
    if sy-subrc eq 0.
      wa_tab15-matnr = wa_tab14-matnr.
      wa_tab15-b_pts = wa_tab14-pts.
      wa_tab15-b_qty = wa_tab14-qty.
    endif.
    collect wa_tab15 into it_tab15.
    clear wa_tab15.
  endloop.

  loop at it_tab15 into wa_tab15.
    clear : net_sale,net_qty.
*    WRITE : / 'a',wa_TAB15-matnr,WA_TAB15-B_PTS,WA_TAB15-B_QTY,wa_TAB15-s_pts,wa_TAB15-s_qty,wa_TAB15-c_pts,wa_TAB15-c_qty,wa_TAB15-d_pts,
*    wa_TAB15-d_qty.
    net_sale = wa_tab15-s_pts - wa_tab15-c_pts + wa_tab15-d_pts.
    net_qty = wa_tab15-s_qty - wa_tab15-c_qty + wa_tab15-d_qty.
    wa_tab16-matnr = wa_tab15-matnr.
    wa_tab16-b_pts = wa_tab15-b_pts.
    wa_tab16-b_qty = wa_tab15-b_qty.
    wa_tab16-s_pts = wa_tab15-s_pts.
    wa_tab16-s_qty = wa_tab15-s_qty.
    wa_tab16-c_pts = wa_tab15-c_pts.
    wa_tab16-c_qty = wa_tab15-c_qty.
    wa_tab16-d_pts = wa_tab15-d_pts.
    wa_tab16-d_qty = wa_tab15-d_qty.
    wa_tab16-net_sale = net_sale.
    wa_tab16-net_qty = net_qty.
    collect wa_tab16 into it_tab16.
    clear wa_tab16.
  endloop.

  loop at it_tab16 into wa_tab16.
    wa_tab17-matnr = wa_tab16-matnr.
    wa_tab17-b_pts = wa_tab16-b_pts.
    wa_tab17-b_qty = wa_tab16-b_qty.
    wa_tab17-s_pts = wa_tab16-s_pts.
    wa_tab17-s_qty = wa_tab16-s_qty.
    wa_tab17-c_pts = wa_tab16-c_pts.
    wa_tab17-c_qty = wa_tab16-c_qty.
    wa_tab17-d_pts = wa_tab16-d_pts.
    wa_tab17-d_qty = wa_tab16-d_qty.
    wa_tab17-net_sale = wa_tab16-net_sale.
    wa_tab17-net_qty = wa_tab16-net_qty.
    collect wa_tab17 into it_tab17.
    clear wa_tab17.
  endloop.


***************CURRENT MOTH SALE ENDS HERE **********************

*************CUMMULATIVE SALE STARTS HERE***************************
  c_date+6(2) = '01'.
  c_date+4(2) = '04'.

  if from_dt+4(2) lt '04'.
    c_date+0(4) = from_dt+0(4) - 1.
  else.
    c_date+0(4) = from_dt+0(4).
  endif.
*  write : / 'cummulative date',c_date.

  select * from zsales_tab1 into table it_zsales_tab2 where datab ge c_date and datbi le to_dt.
  if it_zsales_tab2 is not initial.
    loop at it_zsales_tab2 into wa_zsales_tab2.
      wa_ctab1-matnr = wa_zsales_tab2-matnr.
      wa_ctab1-pts = wa_zsales_tab2-net + wa_zsales_tab2-ed.
      wa_ctab1-qty = wa_zsales_tab2-c_qty.
      collect wa_ctab1 into it_ctab1.
      clear wa_ctab1.
      wa_ta-matnr = wa_zsales_tab2-matnr.
      collect wa_ta into it_ta.
      clear wa_ta.
    endloop.
  endif.

*  select * from zcredit_tab1 into table it_zcredit_tab2 where datab ge c_date and datbi le to_dt.
  if it_zcredit_tab2 is not initial.
    loop at it_zcredit_tab2 into wa_zcredit_tab2.
      wa_ctab2-matnr = wa_zcredit_tab2-matnr.
      wa_ctab2-pts = wa_zcredit_tab2-net.
      wa_ctab2-qty = wa_zcredit_tab2-qty_c.
      collect wa_ctab2 into it_ctab2.
      clear wa_ctab2.
      wa_ta-matnr = wa_zcredit_tab2-matnr.
      collect wa_ta into it_ta.
      clear wa_ta.
    endloop.
  endif.

*  select * from zdebit_tab1 into table it_zdebit_tab2 where datab ge c_date and datbi le to_dt.
  if it_zdebit_tab2 is not initial.
    loop at it_zdebit_tab2 into wa_zdebit_tab2.
      wa_ctab3-matnr = wa_zdebit_tab2-matnr.
      wa_ctab3-pts = wa_zdebit_tab2-net.
      wa_ctab3-qty = wa_zdebit_tab2-qty_c.
      collect wa_ctab3 into it_ctab3.
      clear wa_ctab3.
      wa_ta-matnr = wa_zdebit_tab2-matnr.
      collect wa_ta into it_ta.
      clear wa_ta.
    endloop.
  endif.

  select * from zbudget_tab1 into table it_zbudget_tab2 where datab ge c_date and datbi le to_dt and tag eq 'G'.
  if it_zbudget_tab2 is not initial.
    loop at it_zbudget_tab2 into wa_zbudget_tab2.
*      WRITE : / 'budget',c_date,TO_DT,wa_zBUDGET_tab2-matnr,wa_zBUDGET_tab2-qty.
      wa_ctab4-matnr = wa_zbudget_tab2-matnr.
      wa_ctab4-pts = wa_zbudget_tab2-val.
      wa_ctab4-qty = wa_zbudget_tab2-qty.
      collect wa_ctab4 into it_ctab4.
      clear wa_ctab4.
      wa_ta-matnr = wa_zbudget_tab2-matnr.
      collect wa_ta into it_ta.
      clear wa_ta.
    endloop.
  endif.

  sort it_ta.
  delete adjacent duplicates from it_ta.

  loop at it_ta into wa_ta.
    read table it_ctab1 into wa_ctab1 with key matnr = wa_ta-matnr.
    if sy-subrc eq 0.
      wa_ctab5-matnr = wa_ctab1-matnr.
      wa_ctab5-s_pts = wa_ctab1-pts.
      wa_ctab5-s_qty = wa_ctab1-qty.
    endif.
    read table it_ctab2 into wa_ctab2 with key matnr = wa_ta-matnr.
    if sy-subrc eq 0.
      wa_ctab5-matnr = wa_ctab2-matnr.
      wa_ctab5-c_pts = wa_ctab2-pts.
      wa_ctab5-c_qty = wa_ctab2-qty.
    endif.
    read table it_ctab3 into wa_ctab3 with key matnr = wa_ta-matnr.
    if sy-subrc eq 0.
      wa_ctab5-matnr = wa_ctab3-matnr.
      wa_ctab5-d_pts = wa_ctab3-pts.
      wa_ctab5-d_qty = wa_ctab3-qty.
    endif.
    read table it_ctab4 into wa_ctab4 with key matnr = wa_ta-matnr.
    if sy-subrc eq 0.
      wa_ctab5-matnr = wa_ctab4-matnr.
      wa_ctab5-b_pts = wa_ctab4-pts.
      wa_ctab5-b_qty = wa_ctab4-qty.
    endif.
    collect wa_ctab5 into it_ctab5.
    clear wa_ctab5.
  endloop.

  loop at it_ctab5 into wa_ctab5.
    clear : cnet_sale,cnet_qty.
    wa_ctab6-matnr = wa_ctab5-matnr.
    wa_ctab6-s_pts = wa_ctab5-s_pts.
    wa_ctab6-s_qty = wa_ctab5-s_qty.
    wa_ctab6-c_pts = wa_ctab5-c_pts.
    wa_ctab6-c_qty = wa_ctab5-c_qty.
    wa_ctab6-d_pts = wa_ctab5-d_pts.
    wa_ctab6-d_qty = wa_ctab5-d_qty.
    wa_ctab6-b_pts = wa_ctab5-b_pts.
    wa_ctab6-b_qty = wa_ctab5-b_qty.
    cnet_sale = wa_ctab5-s_pts - wa_ctab5-c_pts + wa_ctab5-d_pts.
    cnet_qty = wa_ctab5-s_qty - wa_ctab5-c_qty + wa_ctab5-d_qty.
    wa_ctab6-net_sale = cnet_sale.
    wa_ctab6-net_qty = cnet_qty.
    collect wa_ctab6 into it_ctab6.
    clear wa_ctab6.
  endloop.
  sort it_ctab6 by bezei.

  loop at it_ctab6 into wa_ctab6.
    wa_ctab7-matnr = wa_ctab6-matnr.
    wa_ctab7-s_pts = wa_ctab6-s_pts.
    wa_ctab7-s_qty = wa_ctab6-s_qty.
    wa_ctab7-c_pts = wa_ctab6-c_pts.
    wa_ctab7-c_qty = wa_ctab6-c_qty.
    wa_ctab7-d_pts = wa_ctab6-d_pts.
    wa_ctab7-d_qty = wa_ctab6-d_qty.
    wa_ctab7-b_pts = wa_ctab6-b_pts.
    wa_ctab7-b_qty = wa_ctab6-b_qty.
    wa_ctab7-net_sale = wa_ctab6-net_sale.
    wa_ctab7-net_qty = wa_ctab6-net_qty.
    collect wa_ctab7 into it_ctab7.
    clear wa_ctab7.
  endloop.

*  LOOP AT IT_CTAB7 INTO WA_CTAB7.
*    WRITE : /'a1',wa_tab7-mvgr4,wa_ctab7-bezei,'net',wa_ctab7-net_qty,'sale',WA_CTAB7-S_QTY,'credit',wa_ctab7-c_qty,'debit',wa_ctab7-d_qty,'bud',wa_ctab7-b_qty,wa_ctab7-net_sale,wa_ctab7-b_pts.
*  ENDLOOP.

**************CUMMULATIVE DATA ENDS HERE********************

******************LAST YEAR CUMMULATIVE DATA STARTS*****************

  ll_date = c_date.
  ll_date+0(4) = c_date+0(4) - 1.
  lc_date = to_dt.
  lc_date+0(4) = to_dt+0(4) - 1.
*  write : / 'last fiscal year',ll_date,'last year same date',lc_date.
*WRITE : / 'date',lc_date.

*******************************************************
  clear : ndt1,ndt2.
  ndt1 = lc_date.
  ndt1+6(2) = '01'.
  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date           = ndt1
    importing
*     EV_MONTH_BEGIN_DATE       =
      ev_month_end_date = ndt2.
  lc_date = ndt2.
*************************************************************************

  if lc_date = '20160228'.
    lc_date = '20160229'.
  endif.
*WRITE : / 'date',lc_date.
  select * from zsales_tab1 into table it_zsales_tab3 where datab ge ll_date and datbi le lc_date.
  if it_zsales_tab3 is not initial.
    loop at it_zsales_tab3 into wa_zsales_tab3.
      wa_lctab1-matnr = wa_zsales_tab3-matnr.
      wa_lctab1-pts = wa_zsales_tab3-net + wa_zsales_tab3-ed.
      wa_lctab1-qty = wa_zsales_tab3-c_qty.
      collect wa_lctab1 into it_lctab1.
      clear wa_lctab1.
      wa_t-matnr = wa_zsales_tab3-matnr.
      collect wa_t into it_t.
      clear wa_t.
    endloop.
  endif.

*  select * from zcredit_tab1 into table it_zcredit_tab3 where datab ge ll_date and datbi le lc_date.
  if it_zcredit_tab3 is not initial.
    loop at it_zcredit_tab3 into wa_zcredit_tab3.
      wa_lctab2-matnr = wa_zcredit_tab3-matnr.
      wa_lctab2-pts = wa_zcredit_tab3-net.
      wa_lctab2-qty = wa_zcredit_tab3-qty_c.
      collect wa_lctab2 into it_lctab2.
      clear wa_lctab2.
      wa_t-matnr = wa_zcredit_tab3-matnr.
      collect wa_t into it_t.
      clear wa_t.
    endloop.
  endif.

*  select * from zdebit_tab1 into table it_zdebit_tab3 where datab ge ll_date and datbi le lc_date.
  if it_zdebit_tab3 is not initial.
    loop at it_zdebit_tab3 into wa_zdebit_tab3.
      wa_lctab3-matnr = wa_zdebit_tab3-matnr.
      wa_lctab3-pts = wa_zdebit_tab3-net.
      wa_lctab3-qty = wa_zdebit_tab3-qty_c.
      collect wa_lctab3 into it_lctab3.
      clear wa_lctab3.
      wa_t-matnr = wa_zdebit_tab3-matnr.
      collect wa_t into it_t.
      clear wa_t.
    endloop.
  endif.


  loop at it_t into wa_t.
    read table it_lctab1 into wa_lctab1 with key matnr = wa_t-matnr.
    if sy-subrc eq 0.
      wa_lctab4-matnr = wa_lctab1-matnr.
      wa_lctab4-s_pts = wa_lctab1-pts.
      wa_lctab4-s_qty = wa_lctab1-qty.
    endif.
    read table it_lctab2 into wa_lctab2 with key matnr = wa_t-matnr.
    if sy-subrc eq 0.
      wa_lctab4-matnr = wa_lctab2-matnr.
      wa_lctab4-c_pts = wa_lctab2-pts.
      wa_lctab4-c_qty = wa_lctab2-qty.
    endif.
    read table it_lctab3 into wa_lctab3 with key matnr = wa_t-matnr.
    if sy-subrc eq 0.
      wa_lctab4-matnr = wa_lctab3-matnr.
      wa_lctab4-d_pts = wa_lctab3-pts.
      wa_lctab4-d_qty = wa_lctab3-qty.
    endif.
    collect wa_lctab4 into it_lctab4.
    clear wa_lctab4.
  endloop.

  loop at it_lctab4 into wa_lctab4.
    clear : lcnet_sale,lcnet_qty.
    wa_lctab5-matnr = wa_lctab4-matnr.
    wa_lctab5-s_pts = wa_lctab4-s_pts.
    wa_lctab5-s_qty = wa_lctab4-s_qty.
    wa_lctab5-c_pts = wa_lctab4-c_pts.
    wa_lctab5-c_qty = wa_lctab4-c_qty.
    wa_lctab5-d_pts = wa_lctab4-d_pts.
    wa_lctab5-d_qty = wa_lctab4-d_qty.
    lcnet_sale = wa_lctab4-s_pts - wa_lctab4-c_pts + wa_lctab4-d_pts.
    lcnet_qty = wa_lctab4-s_qty - wa_lctab4-c_qty + wa_lctab4-d_qty.
    wa_lctab5-net_sale = lcnet_sale.
    wa_lctab5-net_qty = lcnet_qty.
    collect wa_lctab5 into it_lctab5.
    clear wa_lctab5.
  endloop.

  loop at it_lctab5 into wa_lctab5.
*    WRITE : / 'last yeat net sale',wa_lctab5-matnr,wa_lctab5-net_sale.
    wa_lctab6-matnr = wa_lctab5-matnr.
    wa_lctab6-s_pts = wa_lctab5-s_pts.
    wa_lctab6-s_qty = wa_lctab5-s_qty.
    wa_lctab6-c_pts = wa_lctab5-c_pts.
    wa_lctab6-c_qty = wa_lctab5-c_qty.
    wa_lctab6-d_pts = wa_lctab5-d_pts.
    wa_lctab6-d_qty = wa_lctab5-d_qty.
    wa_lctab6-net_sale = wa_lctab5-net_sale.
    wa_lctab6-net_qty = wa_lctab5-net_qty.
    collect wa_lctab6 into it_lctab6.
    clear wa_lctab6.
  endloop.


  sort it_tab17 by matnr .
  loop at it_tab into wa_tab.
    wa_mat1-matnr = wa_tab-matnr.
    collect wa_mat1 into it_mat1.
    clear wa_mat1.
  endloop.
  loop at it_ta into wa_ta.
    wa_mat1-matnr = wa_ta-matnr.
    collect wa_mat1 into it_mat1.
    clear wa_mat1.
  endloop.
  loop at it_t into wa_t.
    wa_mat1-matnr = wa_t-matnr.
    collect wa_mat1 into it_mat1.
    clear wa_mat1.
  endloop.

  sort it_mat1 by matnr.
  delete adjacent duplicates from it_mat1 comparing matnr.

  sort it_tab17 by matnr.
  sort it_ctab6 by matnr.
  sort it_lctab6 by matnr.

  loop at it_mat1 into wa_mat1.
*    WRITE : / 'material',wa_mat1-matnr.
    clear : ach1,ach2,grq,grv.
*  loop at it_tab17 into wa_tab17.
    read table it_tab17 into wa_tab17 with key matnr = wa_mat1-matnr.
    if sy-subrc eq 0.
      wa_tab181-matnr = wa_tab17-matnr.
      wa_tab181-net_qty = wa_tab17-net_qty.
      wa_tab181-net_sale = wa_tab17-net_sale.
      wa_tab181-b_qty = wa_tab17-b_qty.
      wa_tab181-b_pts = wa_tab17-b_pts.
    endif.

    read table it_ctab7 into wa_ctab7 with key matnr = wa_mat1-matnr.
    if sy-subrc eq 0.
      wa_tab181-matnr = wa_ctab7-matnr.
      wa_tab181-cnet_qty = wa_ctab7-net_qty.
      wa_tab181-cnet_sale = wa_ctab7-net_sale.
      wa_tab181-cb_qty = wa_ctab7-b_qty.
      wa_tab181-cb_pts = wa_ctab7-b_pts.
    endif.

    read table it_lctab6 into wa_lctab6 with key matnr = wa_mat1-matnr.
    if sy-subrc eq 0.
*      WRITE : / 'found',wa_lctab6-matnr,wa_lctab6-mvgr4,wa_lctab6-net_sale.
      wa_tab181-matnr = wa_lctab6-matnr.
      wa_tab181-lcnet_sale = wa_lctab6-net_sale.
      wa_tab181-lcnet_qty = wa_lctab6-net_qty.
    endif.

    collect wa_tab181 into it_tab181.
    clear wa_tab181.
  endloop.

  loop at it_tab181 into wa_tab181 where matnr ne '                  '.

*    WA_TAB182-MATNR = WA_TAB181-MATNR.
    wa_tab182-net_qty = wa_tab181-net_qty.
    wa_tab182-net_sale = wa_tab181-net_sale.
    wa_tab182-b_qty = wa_tab181-b_qty.
    wa_tab182-b_pts = wa_tab181-b_pts.
    wa_tab182-cnet_qty = wa_tab181-cnet_qty.
    wa_tab182-cb_qty = wa_tab181-cb_qty.
    wa_tab182-cnet_sale = wa_tab181-cnet_sale.
    wa_tab182-cb_pts = wa_tab181-cb_pts.
    wa_tab182-lcnet_sale = wa_tab181-lcnet_sale.
    wa_tab182-lcnet_qty = wa_tab181-lcnet_qty.

    select single * from mara where matnr eq wa_tab181-matnr.
    if sy-subrc eq 0.
      wa_tab182-spart = mara-spart.
      wa_tab182-matkl = mara-matkl.
    endif.

    select single * from zprdgroup where rep_type eq 'SR2' and prd_code eq mara-matnr.
    if sy-subrc eq 0.
      wa_tab182-prn_seq = zprdgroup-prn_seq.
      wa_tab182-grp_code = zprdgroup-grp_code.
*      WRITE : / 'material',wa_tab181-matnr,ZPRDGROUP-PRN_SEQ,ZPRDGROUP-GRP_CODE, WA_TAB182-PRN_SEQ,WA_TAB182-GRP_CODE .
    else.
      format color 6.
      write :  'MATERIL CODE NOT MAINTAINED IN ZPRDGROUP',wa_tab181-matnr.
    endif.

*    SELECT SINGLE * FROM MVKE WHERE MATNR EQ WA_TAB181-MATNR AND VKORG EQ '1000' AND VTWEG EQ '10' .
*    IF SY-SUBRC EQ 0.
*      SELECT SINGLE * FROM TVM5T WHERE SPRAS EQ 'EN' AND MVGR5 EQ MVKE-MVGR5.
*      IF SY-SUBRC EQ 0.
*        WA_TAB182-BEZEI = TVM5T-BEZEI.
*      ENDIF.
*    ENDIF.

    select single * from mvke where matnr eq wa_tab181-matnr and vkorg eq '1000' and vtweg eq '10'.
    if sy-subrc eq 0.
      wa_tab182-kondm = mvke-kondm.
    endif.

*    SELECT SINGLE * FROM MVKE WHERE MATNR EQ WA_TAB181-MATNR AND VKORG EQ '1000' AND VTWEG EQ '10' .
*    IF SY-SUBRC EQ 0.
*      WA_TAB182-MVGR4 = MVKE-MVGR4.
*    ENDIF.
*    IF  WA_TAB182-MVGR4 EQ SPACE.
*      SELECT SINGLE * FROM MVKE WHERE MATNR EQ WA_TAB181-MATNR AND VKORG EQ '1000' AND MVGR4 NE SPACE .
*      IF SY-SUBRC EQ 0.
*        WA_TAB182-MVGR4 = MVKE-MVGR4.
*      ENDIF.
*    ENDIF.

*    SELECT SINGLE * FROM TVM4T WHERE SPRAS EQ 'EN' AND MVGR4 EQ WA_TAB182-MVGR4.
*    IF SY-SUBRC EQ 0.
*      WA_TAB182-MAKTX = TVM4T-BEZEI.
*    ELSE.
*      FORMAT COLOR 6.
*      WRITE : / 'PRODUCT DESCRIPTIO NOT FOUND FOR ',WA_TAB181-MATNR.
*    ENDIF.

    collect wa_tab182 into it_tab182.
    clear wa_tab182.
  endloop.

  sort it_tab182 by spart prn_seq grp_code.
  loop at it_tab182 into wa_tab182.
    clear : ach1,ach2,grq,grv.
*    FORMAT COLOR 1.
*    WRITE : / '182',WA_TAB182-mvgr4,WA_TAB182-spart,WA_TAB182-prn_seq,WA_TAB182-grp_code,wa_tab182-bezei,wa_tab182-maktx.
*    WA_TAB18-MATNR = WA_TAB182-MATNR.
*****    wa_tab18-matkl = wa_tab182-matkl.
*****    select single * from t023t where spras eq 'EN' and matkl eq  wa_tab18-matkl.
*****    if sy-subrc eq 0.
*****      wa_tab18-maktx = t023t-wgbez.
*****    endif.

    wa_tab18-kondm =  wa_tab182-kondm.
*    WA_TAB18-BEZEI = WA_TAB182-BEZEI.
*    WA_TAB18-MAKTX = WA_TAB182-MAKTX.
    wa_tab18-spart = wa_tab182-spart.
    wa_tab18-prn_seq = wa_tab182-prn_seq.
    wa_tab18-grp_code = wa_tab182-grp_code.
    select single * from zprdgroup where rep_type = 'SR2' and grp_code = wa_tab182-grp_code.
    if sy-subrc = 0.
      wa_tab18-maktx = zprdgroup-grp_name.
    endif.
    wa_tab18-net_qty = wa_tab182-net_qty.
    wa_tab18-net_sale = wa_tab182-net_sale.
    wa_tab18-b_qty = wa_tab182-b_qty.
    wa_tab18-b_pts = wa_tab182-b_pts.
    wa_tab18-cnet_qty = wa_tab182-cnet_qty.
    wa_tab18-cb_qty = wa_tab182-cb_qty.
    wa_tab18-cnet_sale = wa_tab182-cnet_sale.
    wa_tab18-cb_pts = wa_tab182-cb_pts.
    wa_tab18-lcnet_sale = wa_tab182-lcnet_sale.
    wa_tab18-lcnet_qty = wa_tab182-lcnet_qty.

    if wa_tab18-b_pts ne 0.
      ach1 = ( wa_tab18-net_sale / wa_tab18-b_pts ) * 100.
    endif.
    wa_tab18-ach1 = ach1.
    if wa_tab18-cb_pts ne 0.
      ach2 = ( wa_tab18-cnet_sale / wa_tab18-cb_pts ) * 100.
    endif.
    wa_tab18-ach2 = ach2.
    if wa_tab18-lcnet_qty ne 0.
      grq = ( wa_tab18-cnet_qty / wa_tab18-lcnet_qty ) * 100 - 100.
    endif.
    wa_tab18-grq = grq.
    if wa_tab18-lcnet_sale ne 0.
      grv = ( wa_tab18-cnet_sale / wa_tab18-lcnet_sale ) * 100 - 100.
    endif.
    wa_tab18-grv = grv.

*    SELECT SINGLE * FROM MVKE WHERE MATNR EQ WA_TAB18-MATNR AND VKORG EQ '1000' AND VTWEG EQ '10'.
*    IF SY-SUBRC EQ 0.
*      WA_TAB18-KONDM = MVKE-KONDM.
*    ENDIF.

    collect wa_tab18 into it_tab18.
    clear wa_tab18.
  endloop.

  sort it_tab18 by spart prn_seq grp_code maktx.

  loop at it_tab18 into wa_tab18.
    pack wa_tab18-matnr to wa_tab18-matnr.
    condense wa_tab18-matnr.
    modify it_tab18 from wa_tab18 transporting matnr.
  endloop.

  wa_fieldcat-fieldname = 'SPART'.
  wa_fieldcat-seltext_l = 'DIVISION'.
  append wa_fieldcat to fieldcat.

*****  wa_fieldcat-fieldname = 'MATKL'.
*****  wa_fieldcat-seltext_l = 'MATERIAL GROUP'.
*****  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'KONDM'.
  wa_fieldcat-seltext_l = 'CONTR/DECONTR'.
  append wa_fieldcat to fieldcat.

*  WA_FIELDCAT-FIELDNAME = 'MATNR'.
*  WA_FIELDCAT-SELTEXT_L = 'CODE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
  wa_fieldcat-fieldname = 'MAKTX'.
  wa_fieldcat-seltext_l = 'MATERIAL GROUP NAME'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'GRP_CODE'.
  wa_fieldcat-seltext_l = 'SR2 GROUP CODE'.
  append wa_fieldcat to fieldcat.
**
*  WA_FIELDCAT-FIELDNAME = 'BEZEI'.
*  WA_FIELDCAT-SELTEXT_L = 'PACK'.
*  APPEND WA_FIELDCAT TO FIELDCAT.

  wa_fieldcat-fieldname = 'NET_QTY'.
  wa_fieldcat-seltext_l = 'UNIT SALE THIS MONTH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'B_QTY'.
  wa_fieldcat-seltext_l = 'UNIT BUDGET THIS MONTH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'NET_SALE'.
  wa_fieldcat-seltext_l = 'VALUE SALE THIS MONTH'.
  append wa_fieldcat to fieldcat.
*
  wa_fieldcat-fieldname = 'B_PTS'.
  wa_fieldcat-seltext_l = 'VALUE BUDGET THIS MONTH'.
  append wa_fieldcat to fieldcat.
*
  wa_fieldcat-fieldname = 'ACH1'.
  wa_fieldcat-seltext_l = '% ACH1.'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CNET_QTY'.
  wa_fieldcat-seltext_l = 'UNIT SALE THIS YTD.'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CB_QTY'.
  wa_fieldcat-seltext_l = 'UNIT BUDGET THIS YTD.'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CNET_SALE'.
  wa_fieldcat-seltext_l = 'VALUE SALE THIS YTD.'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CB_PTS'.
  wa_fieldcat-seltext_l = 'VALUE BUDGET THIS YTD.'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'ACH2'.
  wa_fieldcat-seltext_l = '& ACH2.'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LCNET_QTY'.
  wa_fieldcat-seltext_l = 'LY UNIT SALE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LCNET_SALE'.
  wa_fieldcat-seltext_l = 'LY UNIT SALE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'GRQ'.
  wa_fieldcat-seltext_l = 'UNIT GR THIS YTD.'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'GRV'.
  wa_fieldcat-seltext_l = 'VALUE GR THIS YTD.'.
  append wa_fieldcat to fieldcat.


  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'SR-2 : COMPANY SALES (GROSS) - PRODUCT GROUP WISE'.


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
      t_outtab                = it_tab18
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.



endform.                    "GROSS_ALV


*&---------------------------------------------------------------------*
*&      Form  TOP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form top.

  data: comment    type slis_t_listheader,
        wa_comment like line of comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'SR-2 : COMPANY SALES (GROSS) PRODUCTWISE'.
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
*&      Form  top1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form top1.

  data: comment    type slis_t_listheader,
        wa_comment like line of comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'SR-2 : COMPANY SALES (NET) PRODUCTWISE'.
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


*top-of-page.
*  write : / 'SR-1: COMPANY SALES (GROSS) - PRODUCTWISE'.
*  uline.
*  write : /1 'CODE', 12 'PRODUCT NAME', 43 'PACK',54 'UNIT.SALE',72 'UNIT BUD',87 'VALUE SALE',105 'VALUE BUD',118 '%',
*  129 'UNIT SALE',147 'UNIT BUD',163 'VALUE SALE',180 'VALUE BUD',193 '%',200 'UNT GR',210 'VALUE GR'.
*  write : /54 'THIS MTS',72 'THIS MTH',87 'THIS MONTH',105 'THIS MONTH',118 'ACH.',130 'THIS YTD',147 'THIS YTD',
*           164 'THIS YTD',180 'THIS YTD',193 'ACH.',200 'THIS YTD',210 'THIS YTD'.
*  uline.
*WRITE : / 'SALE QTY', T_SQTY,T_BQTY,T_SPTS,T_BPTS,T_SPTS,T_BPTS,T_CSQTY,T_CBQTY,T_CSPTS,T_CBPTS.
*&---------------------------------------------------------------------*
*&      Form  SFFORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form sfform .
  if r7 eq 'X' .
    if net eq 'X'.
      concatenate 'SR-2 : COMPANY SALES (NET) - PRODUCT GROUP WISE' month1 '& CUM.' into headtxt1 separated by space.
    elseif gross eq 'X'.
      concatenate 'SR-2 : COMPANY SALES (GROSS) - PRODUCT GROUP WISE' month1 '& CUM.' into headtxt1 separated by space.
    endif.
  elseif r15 eq 'X'.
    if net eq 'X'.
      concatenate 'SR-2 : COMPANY SALES (NET) - PRODUCT GROUP WISE' month1 '& CUM.' '(All Value & Unit in ''000)' into headtxt1 separated by space.
    elseif gross eq 'X'.
      concatenate 'SR-2 : COMPANY SALES (GROSS) - PRODUCT GROUP WISE' month1 '& CUM.' '(All Value & Unit in ''000)' into headtxt1 separated by space.
    endif.

  elseif r10 eq 'X' .
    if gross eq 'X'.
      concatenate 'SR-2 : COMPANY SALES (GROSS) - PRODUCT GROUP WISE' month1 '& CUM.' into headtxt1 separated by space.
    else.
      concatenate 'SR-2 : COMPANY SALES (NET) - PRODUCT GROUP WISE' month1 '& CUM.' into headtxt1 separated by space.
    endif.
  elseif r14 eq 'X' .
    if gross eq 'X'.
      concatenate 'SR-2 : COMPANY SALES (GROSS) - PRODUCT GROUP WISE' month1 '& CUM.' '(All Value & Unit in ''000)' into headtxt1 separated by space.
    else.
      concatenate 'SR-2 : COMPANY SALES (NET) - PRODUCT GROUP WISE' month1 '& CUM.' '(All Value & Unit in ''000)' into headtxt1 separated by space.
    endif.
*  elseif r1 eq 'X' or r6 eq 'X'.
*  elseif r6 eq 'X'.
*    concatenate 'SR-2 : COMPANY SALES (GROSS) - PRODUCT GROUP WISE' month1 '& CUM.' into headtxt1 separated by space.
*  elseif r13 eq 'X'.
*    concatenate 'SR-1 : NEPAL SALES (GROSS) - PRODUCTWISE' month1 '& CUM.' into headtxt1 separated by space.
*  elseif r21 eq 'X'.
*    concatenate 'SR-1 NLEM : COMPANY SALES (GROSS) - PRODUCTWISE' month1 '& CUM.' into headtxt1 separated by space.
*  elseif r8 eq 'X'.
*    concatenate 'SR-1 A (NET) ' year1 '-' m2 'PRODUCT PACK SALE' into headtxt1 separated by space.
  endif.
  sort it_tab18 by spart prn_seq grp_code subgrp_code.
  clear : count.
  loop at it_tab18 into wa_tab18.
*    if r12 eq 'X'.
*      on change of wa_tab18-spart.
*        count = 0.
*      endon.
*      on change of wa_tab18-grp_code.
*        count = 0.
*      endon.
*      count = count + 1.
*      if ( wa_tab18-grp_code = 53 ) or ( wa_tab18-grp_code = 45 ).
*        if wa_tab18-net_sale ne 0 .
*
*          wa_sf1-spart = wa_tab18-spart.
*          wa_sf1-prn_seq = wa_tab18-prn_seq.
*          wa_sf1-grp_code = wa_tab18-grp_code.
**          wa_sf1-grp_cnt = count.
*          wa_sf1-subgrp_code = wa_tab18-subgrp_code.
*          wa_sf1-subgrp_name = wa_tab18-subgrp_name.
**          wa_sf1-maktx = wa_tab18-maktx.
**          wa_sf1-bezei = wa_tab18-bezei.
*          wa_sf1-net_qty = wa_tab18-net_qty.
*          wa_sf1-b_qty = wa_tab18-b_qty.
*          wa_sf1-net_sale = wa_tab18-net_sale.
*          wa_sf1-b_pts = wa_tab18-b_pts.
*          wa_sf1-ach1 = wa_tab18-ach1.
*          wa_sf1-cnet_qty = wa_tab18-cnet_qty.
*          wa_sf1-cb_qty = wa_tab18-cb_qty.
*          if r8 eq 'X'.
*            wa_sf1-cnet_sale = wa_tab18-cnet_sale / 100000.
*          else.
*            wa_sf1-cnet_sale = wa_tab18-cnet_sale.
*          endif.
*          wa_sf1-cb_pts = wa_tab18-cb_pts.
*          wa_sf1-ach2 = wa_tab18-ach2.
*          wa_sf1-grq = wa_tab18-grq.
*          wa_sf1-grv = wa_tab18-grv.
*          wa_sf1-lcnet_qty = wa_tab18-lcnet_qty.
*          wa_sf1-lcnet_sale = wa_tab18-lcnet_sale.
*
**    condense:   wa_sf1-prn_seq ,wa_sf1-net_qty, wa_sf1-b_qty, wa_sf1-net_sale,wa_sf1-b_pts,wa_sf1-ach1,wa_sf1-cnet_qty,wa_sf1-cb_qty,
**    wa_sf1-cnet_sale,wa_sf1-cb_pts,wa_sf1-ach2,wa_sf1-grq,wa_sf1-grv.
*          collect wa_sf1 into it_sf1.
*          clear wa_sf1.
*        endif.
*      endif.
*
*    else.
    on change of wa_tab18-spart.
      count = 0.
    endon.
    on change of wa_tab18-grp_code.
      count = 0.
    endon.
    count = count + 1.

    wa_sf1-spart = wa_tab18-spart.
    wa_sf1-prn_seq = wa_tab18-prn_seq.
    wa_sf1-grp_code = wa_tab18-grp_code.
*      wa_sf1-grp_cnt = count.
    wa_sf1-subgrp_code = wa_tab18-subgrp_code.
    wa_sf1-subgrp_name = wa_tab18-subgrp_name.
*      wa_sf1-maktx = wa_tab18-maktx.
*      wa_sf1-bezei = wa_tab18-bezei.
    wa_sf1-net_qty = wa_tab18-net_qty.
    wa_sf1-b_qty = wa_tab18-b_qty.
    wa_sf1-net_sale = wa_tab18-net_sale.
    wa_sf1-b_pts = wa_tab18-b_pts.
    wa_sf1-ach1 = wa_tab18-ach1.
    wa_sf1-cnet_qty = wa_tab18-cnet_qty.
    wa_sf1-lcnet_qty = wa_tab18-lcnet_qty.
    wa_sf1-cb_qty = wa_tab18-cb_qty.
*      if r8 eq 'X'.
*        wa_sf1-cnet_sale = wa_tab18-cnet_sale / 100000.
*      else.
    wa_sf1-cnet_sale = wa_tab18-cnet_sale.
    wa_sf1-lcnet_sale = wa_tab18-lcnet_sale.
*      endif.
    wa_sf1-cb_pts = wa_tab18-cb_pts.
    wa_sf1-ach2 = wa_tab18-ach2.
    wa_sf1-grq = wa_tab18-grq.
    wa_sf1-grv = wa_tab18-grv.
    wa_sf1-lcnet_qty = wa_tab18-lcnet_qty.
    wa_sf1-lcnet_sale = wa_tab18-lcnet_sale.

*    condense:   wa_sf1-prn_seq ,wa_sf1-net_qty, wa_sf1-b_qty, wa_sf1-net_sale,wa_sf1-b_pts,wa_sf1-ach1,wa_sf1-cnet_qty,wa_sf1-cb_qty,
*    wa_sf1-cnet_sale,wa_sf1-cb_pts,wa_sf1-ach2,wa_sf1-grq,wa_sf1-grv.
    collect wa_sf1 into it_sf1.
    clear wa_sf1.

*    endif.
  endloop.

  sort it_sf1 by spart prn_seq grp_code subgrp_code.

  perform exportdata.





  clear : count.
  loop at it_sf1 into wa_sf1.

    on change of wa_sf1-spart.
      count = 0.
    endon.
    on change of wa_sf1-grp_code.
      count = 0.
    endon.
    count = count + 1.

    on change of wa_sf1-spart.
      if wa_sf1-spart eq '50'.
        wa_sf2-gr = 'DIV'.
      else.
        wa_sf2-gr = 'NIV'.
      endif.
      if wa_sf1-spart eq '50'.
        wa_sf2-maktx = 'BLUE CROSS'.
      elseif wa_sf1-spart eq '60'.
        wa_sf2-maktx = 'EXCEL'.
      elseif wa_sf1-spart eq '70'.
        wa_sf2-maktx = 'BLUE CROSS LIFE SCIENCE'.
      endif.
      append wa_sf2 to it_sf2.
      clear wa_sf2.
    endon.
    wa_sf2-spart = wa_sf1-spart.
    wa_sf2-prn_seq = wa_sf1-prn_seq.
    wa_sf2-grp_code = wa_sf1-grp_code.
*    wa_sf2-maktx = wa_sf1-maktx.
*    wa_sf2-bezei = wa_sf1-bezei.
    if wa_sf1-subgrp_name ne space.
      wa_sf2-maktx = wa_sf1-subgrp_name.
    else.
      select single * from zprdgroup where rep_type eq 'SR2' and grp_code eq wa_sf1-grp_code.
      if sy-subrc eq 0.
        wa_sf2-maktx = zprdgroup-grp_name.
      endif.
    endif.

    if typ1 eq 'LY'.
      clear :
        gnet_qty,gb_qty,gnet_sale,gb_pts,gach1,gcnet_qty,glcnet_qty,gcb_qty,gcnet_sale,glcnet_sale,gcb_pts.
      gnet_qty = wa_sf1-net_qty / 1000.
      gb_qty = wa_sf1-b_qty / 1000.
      gnet_sale = wa_sf1-net_sale / 1000.
      gb_pts = wa_sf1-b_pts / 1000.
      gach1 = wa_sf1-ach1.
      gcnet_qty = wa_sf1-cnet_qty / 1000.
      glcnet_qty = wa_sf1-lcnet_qty / 1000.
      gcb_qty = wa_sf1-cb_qty / 1000.
      gcnet_sale = wa_sf1-cnet_sale / 1000.
      glcnet_sale = wa_sf1-lcnet_sale / 1000.
      gcb_pts = wa_sf1-cb_pts / 1000.

      wa_sf2-net_qty = gnet_qty.
      wa_sf2-b_qty = gb_qty.
      wa_sf2-net_sale = gnet_sale.
      wa_sf2-b_pts = gb_pts.
*      WA_SF2-ACH1 = GACH1.
      wa_sf2-cnet_qty = gcnet_qty.
      wa_sf2-lcnet_qty = glcnet_qty.
      wa_sf2-cb_qty = gcb_qty.
      wa_sf2-cnet_sale = gcnet_sale.
      wa_sf2-lcnet_sale = glcnet_sale.
      wa_sf2-cb_pts = gcb_pts.
    else.
      wa_sf2-net_qty = wa_sf1-net_qty.
      wa_sf2-b_qty = wa_sf1-b_qty.
      wa_sf2-net_sale = wa_sf1-net_sale.
      wa_sf2-b_pts = wa_sf1-b_pts.
*      WA_SF2-ACH1 = WA_SF1-ACH1.
      wa_sf2-cnet_qty = wa_sf1-cnet_qty.
      wa_sf2-lcnet_qty = wa_sf1-lcnet_qty.
      wa_sf2-cb_qty = wa_sf1-cb_qty.
      wa_sf2-cnet_sale = wa_sf1-cnet_sale.
      wa_sf2-lcnet_sale = wa_sf1-lcnet_sale.
      wa_sf2-cb_pts = wa_sf1-cb_pts.
    endif.
    clear : ach1.
    if wa_sf1-b_pts gt 0.
      ach1 = ( wa_sf1-net_sale / wa_sf1-b_pts ) * 100.
    endif.
    wa_sf2-ach1 = ach1.
    clear : ach2.
    if wa_sf1-cb_pts gt 0.
      ach2 = ( wa_sf1-cnet_sale / wa_sf1-cb_pts ) * 100.
    endif.
    wa_sf2-ach2 = ach2.
**************************************
*    if count gt 1.
    on change of wa_sf1-grp_code.
      sft1net_qty = 0.
      sft1b_qty = 0.
      sft1net_sale = 0.
      sft1b_pts = 0.
      sft1cnet_qty = 0.
      sft1cb_qty = 0.
      sft1cnet_sale = 0.
      sft1cb_pts = 0.
      sft1lcnet_sale = 0.
      sft1lcnet_qty = 0.
    endon.

    sft1net_qty = sft1net_qty + wa_sf1-net_qty.
    sft1b_qty = sft1b_qty + wa_sf1-b_qty.
    sft1net_sale = sft1net_sale + wa_sf1-net_sale.
    sft1b_pts = sft1b_pts + wa_sf1-b_pts.
    sft1cnet_qty = sft1cnet_qty + wa_sf1-cnet_qty.
    sft1cb_qty = sft1cb_qty + wa_sf1-cb_qty.
    sft1cnet_sale = sft1cnet_sale + wa_sf1-cnet_sale.
    sft1cb_pts = sft1cb_pts + wa_sf1-cb_pts.
    sft1lcnet_sale = sft1lcnet_sale + wa_sf1-lcnet_sale.
    sft1lcnet_qty = sft1lcnet_qty + wa_sf1-lcnet_qty.

    dsft1net_qty = dsft1net_qty + wa_sf1-net_qty.
    dsft1b_qty = dsft1b_qty + wa_sf1-b_qty.
    dsft1net_sale = dsft1net_sale + wa_sf1-net_sale.
    dsft1b_pts = dsft1b_pts + wa_sf1-b_pts.
    dsft1cnet_qty = dsft1cnet_qty + wa_sf1-cnet_qty.
    dsft1cb_qty = dsft1cb_qty + wa_sf1-cb_qty.
    dsft1cnet_sale = dsft1cnet_sale + wa_sf1-cnet_sale.
    dsft1cb_pts = dsft1cb_pts + wa_sf1-cb_pts.
    dsft1lcnet_sale = dsft1lcnet_sale + wa_sf1-lcnet_sale.
    dsft1lcnet_qty = dsft1lcnet_qty + wa_sf1-lcnet_qty.

    tdsft1net_qty = tdsft1net_qty + wa_sf1-net_qty.
    tdsft1b_qty = tdsft1b_qty + wa_sf1-b_qty.
    tdsft1net_sale = tdsft1net_sale + wa_sf1-net_sale.
    tdsft1b_pts = tdsft1b_pts + wa_sf1-b_pts.
    tdsft1cnet_qty = tdsft1cnet_qty + wa_sf1-cnet_qty.
    tdsft1cb_qty = tdsft1cb_qty + wa_sf1-cb_qty.
    tdsft1cnet_sale = tdsft1cnet_sale + wa_sf1-cnet_sale.
    tdsft1cb_pts = tdsft1cb_pts + wa_sf1-cb_pts.
    tdsft1lcnet_sale = tdsft1lcnet_sale + wa_sf1-lcnet_sale.
    tdsft1lcnet_qty = tdsft1lcnet_qty + wa_sf1-lcnet_qty.

**************************************
*    WA_SF2-ACH2 = WA_SF1-ACH2.
    sft1ach2 = sft1ach2 + wa_sf1-ach2.
    clear : ach1.
*    IF WA_SF2-LCNET_QTY GT 0.
*      ACH1 = ( WA_SF2-CNET_QTY / WA_SF2-LCNET_QTY ) * 100 - 100.
*    ENDIF.
    if wa_sf1-lcnet_qty gt 0.
      ach1 = ( wa_sf1-cnet_qty / wa_sf1-lcnet_qty ) * 100 - 100.
    endif.
    wa_sf2-grq = ach1.
    condense wa_sf2-grq.

    clear : ach2.
*    IF WA_SF2-LCNET_SALE GT 0.
*      ACH2 = ( WA_SF2-CNET_SALE / WA_SF2-LCNET_SALE ) * 100 - 100.
*    ENDIF.
    if wa_sf1-lcnet_sale gt 0.
      ach2 = ( wa_sf1-cnet_sale / wa_sf1-lcnet_sale ) * 100 - 100.
    endif.
    wa_sf2-grv = ach2.
    condense   wa_sf2-grv.

*    wa_sf2-grq = wa_sf1-grq.
*    sft1grq = sft1grq + wa_sf1-ach2.
*    wa_sf2-grv = wa_sf1-grv.
***    sft1grv = sft1grv + wa_sf1-grv.
***    dsft1grv = dsft1grv + wa_sf1-grv.
***    tdsft1grv = tdsft1grv + wa_sf1-grv.
*    sft1lcnet_qty = sft1lcnet_qty + wa_sf1-lcnet_qty.
*    dsft1lcnet_qty = dsft1lcnet_qty + wa_sf1-lcnet_qty.
*    tdsft1lcnet_qty = tdsft1lcnet_qty + wa_sf1-lcnet_qty.
*    sft1lcnet_sale = sft1lcnet_sale + wa_sf1-lcnet_sale.
*    dsft1lcnet_sale = dsft1lcnet_sale + wa_sf1-lcnet_sale.
*    tdsft1lcnet_sale = tdsft1lcnet_sale + wa_sf1-lcnet_sale.
    clear : ngrq,ngrv..
    if wa_sf2-grq cs '-'.
      ngrq = wa_sf2-grq.
      replace '-' with space into ngrq.
      concatenate '-' ngrq into ngrq.
      condense ngrq no-gaps.
      wa_sf2-grq = ngrq.
    endif.
    if wa_sf2-grv cs '-'.
      ngrv = wa_sf2-grv.
      replace '-' with space into ngrv.
      concatenate '-' ngrv into ngrv.
      condense ngrv no-gaps.
      wa_sf2-grv = ngrv.
    endif.
    if wa_sf1-subgrp_code eq space.
      wa_sf2-gr = 'ALL'.
    endif.
*    if count gt 1.
*    else.
*      wa_sf2-gr = 'ALL'.
*    endif.
    condense:   wa_sf2-prn_seq ,wa_sf2-net_qty, wa_sf2-b_qty, wa_sf2-net_sale,wa_sf2-b_pts,wa_sf2-ach1,wa_sf2-cnet_qty,wa_sf2-cb_qty,
    wa_sf2-cnet_sale,wa_sf2-cb_pts,wa_sf2-ach2,wa_sf2-grq,wa_sf2-grv.
    if wa_sf2-net_sale gt 0 or wa_sf2-b_pts gt 0.
      collect wa_sf2 into it_sf2.
    endif.
    clear : grp_name.
    if wa_sf1-grp_code = 53.
      grp_name = 'OTHERS EXL'.
    elseif wa_sf1-grp_code = 45.
      grp_name = 'OTHERS BC'.
    else.
*      select single * from zprdgroup where rep_type eq 'SR2' and grp_code eq wa_sf1-grp_code.
*      if sy-subrc eq 0.
*        grp_name = zprdgroup-grp_name.
*      endif.
      grp_name = wa_sf1-maktx.
*      SELECT s
    endif.
    if count gt 1.
      at end of grp_code.
        select single * from zprdgroup where rep_type eq 'SR2' and grp_code eq wa_sf1-grp_code.
        if sy-subrc eq 0.
          grp_name = zprdgroup-grp_name.
        endif.
        wa_sf2-maktx = grp_name.
        wa_sf2-bezei = space.

        if typ1 eq 'LY'.
          clear : gnet_qty,gb_qty,gnet_sale,gb_pts,gach1,gcnet_qty,glcnet_qty,gcb_qty,gcnet_sale,glcnet_sale,gcb_pts.

          gnet_qty = sft1net_qty / 1000.
          wa_sf2-net_qty = gnet_qty.

          gb_qty = sft1b_qty / 1000.
          wa_sf2-b_qty = gb_qty.

          gnet_sale = sft1net_sale / 1000.
          wa_sf2-net_sale = gnet_sale.

          gb_pts = sft1b_pts / 1000.
          wa_sf2-b_pts = gb_pts .

          gcnet_qty = sft1cnet_qty / 1000.
          wa_sf2-cnet_qty = gcnet_qty.

          gcb_qty = sft1cb_qty / 1000.
          wa_sf2-cb_qty = gcb_qty.

          gcnet_sale = sft1cnet_sale / 1000.
          wa_sf2-cnet_sale = gcnet_sale.

          gcb_pts = sft1cb_pts / 1000.
          wa_sf2-cb_pts = gcb_pts.

          glcnet_qty = sft1lcnet_qty / 1000.
          wa_sf2-lcnet_qty = glcnet_qty.

          glcnet_sale = sft1lcnet_sale / 1000.
          wa_sf2-lcnet_sale = glcnet_sale.
        else.
          wa_sf2-net_qty = sft1net_qty.
          wa_sf2-b_qty = sft1b_qty.
          wa_sf2-net_sale = sft1net_sale.
          wa_sf2-b_pts = sft1b_pts.
          wa_sf2-cnet_qty = sft1cnet_qty.
          wa_sf2-cb_qty = sft1cb_qty.
          wa_sf2-cnet_sale = sft1cnet_sale.
          wa_sf2-cb_pts = sft1cb_pts.
          wa_sf2-lcnet_qty = sft1lcnet_qty.
          wa_sf2-lcnet_sale = sft1lcnet_sale.
        endif.
        if sft1b_pts gt 0.
          sft1ach1 = ( sft1net_sale / sft1b_pts ) * 100.
        endif.
        wa_sf2-ach1 = sft1ach1.

        if sft1cb_pts gt 0.
          sft1ach2 =  ( sft1cnet_sale / sft1cb_pts ) * 100.
        endif.
        wa_sf2-ach2 = sft1ach2.
        if sft1lcnet_qty gt 0.
          sft1grq = ( sft1cnet_qty / sft1lcnet_qty ) * 100 - 100.
        endif.
        wa_sf2-grq = sft1grq.
        condense   wa_sf2-grq.
        if sft1lcnet_sale gt 0.
          sft1grv  = ( sft1cnet_sale / sft1lcnet_sale ) * 100 - 100.
        endif.
        wa_sf2-grv = sft1grv.
        condense    wa_sf2-grv.
        wa_sf2-gr = 'GRP'.

        clear : ngrq,ngrv..
        if wa_sf2-grq cs '-'.
          ngrq = wa_sf2-grq.
          replace '-' with space into ngrq.
          concatenate '-' ngrq into ngrq.
          condense ngrq no-gaps.
          wa_sf2-grq = ngrq.
        endif.
        if wa_sf2-grv cs '-'.
          ngrv = wa_sf2-grv.
          replace '-' with space into ngrv.
          concatenate '-' ngrv into ngrv.
          condense ngrv no-gaps.
          wa_sf2-grv = ngrv.
        endif.

        condense:   wa_sf2-prn_seq ,wa_sf2-net_qty, wa_sf2-b_qty, wa_sf2-net_sale,wa_sf2-b_pts,wa_sf2-ach1,wa_sf2-cnet_qty,wa_sf2-cb_qty,
        wa_sf2-cnet_sale,wa_sf2-cb_pts,wa_sf2-ach2,wa_sf2-grq,wa_sf2-grv, wa_sf2-lcnet_sale,wa_sf2-lcnet_qty.
        if wa_sf2-net_qty gt 0 or wa_sf2-b_qty gt 0.
          append wa_sf2 to it_sf2.
        endif.
        clear wa_sf2.
        sft1net_qty = 0.
        sft1b_qty = 0.
        sft1net_sale = 0.
        sft1b_pts = 0.
        sft1ach1 = 0.
        sft1cnet_qty = 0.
        sft1cb_qty = 0.
        sft1cnet_sale = 0.
        sft1cb_pts = 0.
        sft1ach2 = 0.
        sft1grq = 0.
        sft1grv = 0.
        sft1lcnet_sale = 0.
        sft1lcnet_qty = 0.

*        if wa_sf2-net_qty gt 0 or wa_sf2-b_qty gt 0.
        wa_sf2-gr = 'GR1'.
        append wa_sf2 to it_sf2.
*        endif.
        clear wa_sf2.
      endat.
    endif.
*************DIVISION TOT*************

    clear : grp_name.
    if wa_sf1-spart = 50.
      grp_name = 'SUB-TOTAL B.C.'.
    elseif wa_sf1-spart = 60.
      grp_name = 'SUB-TOTAL XL'.
    elseif wa_sf1-spart eq '70'.
      grp_name = 'SUB-TOTAL BCLS'.
    endif.

    at end of spart.
      concatenate grp_name ':' into wa_sf2-maktx separated by space.
      wa_sf2-bezei = space.
      if typ1 eq 'LY'.
        clear : gnet_qty,gb_qty,gnet_sale,gb_pts,gach1,gcnet_qty,glcnet_qty,gcb_qty,gcnet_sale,glcnet_sale,gcb_pts.

        gnet_qty = dsft1net_qty / 1000.
        wa_sf2-net_qty =  gnet_qty.
        gb_qty = dsft1b_qty / 1000.
        wa_sf2-b_qty = gb_qty.
        gnet_sale = dsft1net_sale / 1000.
        wa_sf2-net_sale =  gnet_sale.
        gb_pts = dsft1b_pts / 1000.
        wa_sf2-b_pts =  gb_pts .
        gcnet_qty = dsft1cnet_qty / 1000.
        wa_sf2-cnet_qty =  gcnet_qty .
        gcb_qty = dsft1cb_qty / 1000.
        wa_sf2-cb_qty =  gcb_qty.
        gcnet_sale = dsft1cnet_sale / 1000.
        wa_sf2-cnet_sale = gcnet_sale.
        gcb_pts = dsft1cb_pts / 1000.
        wa_sf2-cb_pts =  gcb_pts.
        glcnet_qty = dsft1lcnet_qty / 1000.
        wa_sf2-lcnet_qty = glcnet_qty.
        glcnet_sale = dsft1lcnet_sale / 1000.
        wa_sf2-lcnet_sale =  glcnet_sale.

      else.
        wa_sf2-net_qty = dsft1net_qty.
        wa_sf2-b_qty = dsft1b_qty.
        wa_sf2-net_sale = dsft1net_sale.
        wa_sf2-b_pts = dsft1b_pts.
        wa_sf2-cnet_qty = dsft1cnet_qty.
        wa_sf2-cb_qty = dsft1cb_qty.
        wa_sf2-cnet_sale = dsft1cnet_sale.
        wa_sf2-cb_pts = dsft1cb_pts.
        wa_sf2-lcnet_qty = dsft1lcnet_qty.
        wa_sf2-lcnet_sale = dsft1lcnet_sale.

      endif.

      if dsft1b_pts gt 0.
        dsft1ach1 = ( dsft1net_sale / dsft1b_pts ) * 100.
      endif.
      wa_sf2-ach1 = dsft1ach1.
      if dsft1cb_pts gt 0.
        dsft1ach2 =  ( dsft1cnet_sale / dsft1cb_pts ) * 100.
      endif.
      wa_sf2-ach2 = dsft1ach2.
      if dsft1lcnet_qty gt 0.
        dsft1grq = ( dsft1cnet_qty / dsft1lcnet_qty ) * 100 - 100.
      endif.
      wa_sf2-grq = dsft1grq.
      condense wa_sf2-grq.
      if dsft1lcnet_sale gt 0.
        dsft1grv  = ( dsft1cnet_sale / dsft1lcnet_sale ) * 100 - 100.
      endif.
      wa_sf2-grv = dsft1grv.
      condense    wa_sf2-grv.
      wa_sf2-gr = 'DTO'.

      clear : ngrq,ngrv..
      if wa_sf2-grq cs '-'.
        ngrq = wa_sf2-grq.
        replace '-' with space into ngrq.
        concatenate '-' ngrq into ngrq.
        condense ngrq no-gaps.
        wa_sf2-grq = ngrq.
      endif.
      if wa_sf2-grv cs '-'.
        ngrv = wa_sf2-grv.
        replace '-' with space into ngrv.
        concatenate '-' ngrv into ngrv.
        condense ngrv no-gaps.
        wa_sf2-grv = ngrv.
      endif.

      condense:   wa_sf2-prn_seq ,wa_sf2-net_qty, wa_sf2-b_qty, wa_sf2-net_sale,wa_sf2-b_pts,wa_sf2-ach1,wa_sf2-cnet_qty,wa_sf2-cb_qty,
      wa_sf2-cnet_sale,wa_sf2-cb_pts,wa_sf2-ach2,wa_sf2-grq,wa_sf2-grv,wa_sf2-lcnet_sale,wa_sf2-lcnet_qty.
      if wa_sf2-net_qty gt 0 or wa_sf2-b_qty gt 0.
        append wa_sf2 to it_sf2.
      endif.

      dsft1net_qty = 0.
      dsft1b_qty = 0.
      dsft1net_sale = 0.
      dsft1b_pts = 0.
      dsft1ach1 = 0.
      dsft1cnet_qty = 0.
      dsft1cb_qty = 0.
      dsft1cnet_sale = 0.
      dsft1cb_pts = 0.
      dsft1ach2 = 0.
      dsft1grq = 0.
      dsft1grv = 0.
      dsft1lcnet_sale = 0.
      dsft1lcnet_qty = 0.
    endat.
****************************************

    at last.

*      ************************ DOMESTIC TOTAL**********
*      if r11 eq 'X'.
*        concatenate 'DOM.TOTAL(NET)' ':' into wa_sf2-maktx.
*      else.
*        concatenate 'DOM.TOTAL(GROSS)' ':' into wa_sf2-maktx .
*      endif.
      if net eq 'X'.
        concatenate 'A. DOM.TOTAL(NET)' ':' into wa_sf2-maktx.
      else.
        concatenate 'A. DOM.TOTAL(GROSS)' ':' into wa_sf2-maktx .
      endif.
      wa_sf2-bezei = space.

      if typ1 eq 'LY'.
        clear : gnet_qty,gb_qty,gnet_sale,gb_pts,gach1,gcnet_qty,glcnet_qty,gcb_qty,gcnet_sale,glcnet_sale,gcb_pts.

        gnet_qty = tdsft1net_qty / 1000.
        wa_sf2-net_qty =  gnet_qty.
        gb_qty = tdsft1b_qty / 1000.
        wa_sf2-b_qty = gb_qty.
        gnet_sale = tdsft1net_sale / 1000.
        wa_sf2-net_sale =  gnet_sale.
        gb_pts = tdsft1b_pts / 1000.
        wa_sf2-b_pts =  gb_pts .
        gcnet_qty = tdsft1cnet_qty / 1000.
        wa_sf2-cnet_qty =  gcnet_qty .
        gcb_qty = tdsft1cb_qty / 1000.
        wa_sf2-cb_qty =  gcb_qty.
        gcnet_sale = tdsft1cnet_sale / 1000.
        wa_sf2-cnet_sale = gcnet_sale.
        gcb_pts = tdsft1cb_pts / 1000.
        wa_sf2-cb_pts =  gcb_pts.
        glcnet_qty = tdsft1lcnet_qty / 1000.
        wa_sf2-lcnet_qty = glcnet_qty.
        glcnet_sale = tdsft1lcnet_sale / 1000.
        wa_sf2-lcnet_sale =  glcnet_sale.

      else.
        wa_sf2-net_qty = tdsft1net_qty.
        wa_sf2-b_qty = tdsft1b_qty.
        wa_sf2-net_sale = tdsft1net_sale.
        wa_sf2-b_pts = tdsft1b_pts.
        wa_sf2-cnet_qty = tdsft1cnet_qty.
        wa_sf2-cb_qty = tdsft1cb_qty.
        wa_sf2-cnet_sale = tdsft1cnet_sale.
        wa_sf2-cb_pts = tdsft1cb_pts.
        wa_sf2-lcnet_sale = tdsft1lcnet_sale.
        wa_sf2-lcnet_qty = tdsft1lcnet_qty.
      endif.


      if tdsft1b_pts gt 0.
        tdsft1ach1 = ( tdsft1net_sale / tdsft1b_pts ) * 100.
      endif.
      wa_sf2-ach1 = tdsft1ach1.

      if tdsft1cb_pts gt 0.
        tdsft1ach2 =  ( tdsft1cnet_sale / tdsft1cb_pts ) * 100.
      endif.
      wa_sf2-ach2 = tdsft1ach2.
      if tdsft1lcnet_qty gt 0.
        tdsft1grq = ( tdsft1cnet_qty / tdsft1lcnet_qty ) * 100 - 100.
      endif.
      wa_sf2-grq = tdsft1grq.
      condense  wa_sf2-grq.
      if tdsft1lcnet_sale gt 0.
        tdsft1grv  = ( tdsft1cnet_sale / tdsft1lcnet_sale ) * 100 - 100.
      endif.
      wa_sf2-grv = tdsft1grv.
      condense  wa_sf2-grv.
      wa_sf2-gr = 'TO1'.

      clear : ngrq,ngrv..
      if wa_sf2-grq cs '-'.
        ngrq = wa_sf2-grq.
        replace '-' with space into ngrq.
        concatenate '-' ngrq into ngrq.
        condense ngrq no-gaps.
        wa_sf2-grq = ngrq.
      endif.
      if wa_sf2-grv cs '-'.
        ngrv = wa_sf2-grv.
        replace '-' with space into ngrv.
        concatenate '-' ngrv into ngrv.
        condense ngrv no-gaps.
        wa_sf2-grv = ngrv.
      endif.

      condense:   wa_sf2-prn_seq ,wa_sf2-net_qty, wa_sf2-b_qty, wa_sf2-net_sale,wa_sf2-b_pts,wa_sf2-ach1,wa_sf2-cnet_qty,wa_sf2-cb_qty,
      wa_sf2-cnet_sale,wa_sf2-cb_pts,wa_sf2-ach2,wa_sf2-grq,wa_sf2-grv,wa_sf2-lcnet_sale,wa_sf2-lcnet_qty.
      if wa_sf2-net_qty gt 0 or wa_sf2-b_qty gt 0.
        append wa_sf2 to it_sf2.
      endif.

***************export data*******
*      break-point.
      concatenate 'B. BCL-EXPORT' ':' into wa_sf2-maktx.
      read table it_exp2 into wa_exp2 index 1.
      if sy-subrc eq 0.
        wa_sf2-bezei = space.

        if typ1 eq 'LY'.
          clear : gnet_qty,gb_qty,gnet_sale,gb_pts,gach1,gcnet_qty,glcnet_qty,gcb_qty,gcnet_sale,glcnet_sale,gcb_pts.

          gnet_qty = wa_exp2-qty / 1000.
          wa_sf2-net_qty =  gnet_qty.
          gb_qty = wa_exp2-bqty / 1000.
          wa_sf2-b_qty =  gb_qty.
          gnet_sale = wa_exp2-val / 1000.
          wa_sf2-net_sale =  gnet_sale.
          gb_pts = wa_exp2-bval / 1000.
          wa_sf2-b_pts =   gb_pts.
          gcnet_qty =  wa_exp2-yqty / 1000.
          wa_sf2-cnet_qty =   gcnet_qty.
          gcb_qty =  wa_exp2-ybqty / 1000.
          wa_sf2-cb_qty =   gcb_qty.
          gcnet_sale =  wa_exp2-yval / 1000.
          wa_sf2-cnet_sale =   gcnet_sale.
          gcb_pts =  wa_exp2-ybval / 1000.
          wa_sf2-cb_pts =    gcb_pts .
          glcnet_qty =  wa_exp2-lyqty / 1000.
          wa_sf2-lcnet_qty =   glcnet_qty.
          glcnet_sale =  wa_exp2-lyval / 1000.
          wa_sf2-lcnet_sale =   glcnet_sale.

        else.
          wa_sf2-net_qty = wa_exp2-qty.
          wa_sf2-b_qty = wa_exp2-bqty.
          wa_sf2-net_sale = wa_exp2-val.
          wa_sf2-b_pts = wa_exp2-bval.
          wa_sf2-cnet_qty =  wa_exp2-yqty.
          wa_sf2-cb_qty =  wa_exp2-ybqty.
          wa_sf2-cnet_sale =  wa_exp2-yval.
          wa_sf2-cb_pts =  wa_exp2-ybval.
          wa_sf2-lcnet_qty =  wa_exp2-lyqty.
          wa_sf2-lcnet_sale =  wa_exp2-lyval.
        endif.


        wa_sf2-ach1 =  wa_exp2-ach1.
        wa_sf2-ach2 =  wa_exp2-ach2.

        clear : ach1.
*        if wa_sf2-cnet_qty gt 0.
*          ach1 = ( wa_sf2-cnet_qty / wa_sf2-cnet_qty ) * 100 - 100.
*        endif.
*        wa_sf2-grq = ach1.
*        clear : ach2.
*        if wa_sf2-cnet_sale gt 0.
*          ach2  = ( wa_sf2-cnet_sale / wa_sf2-cnet_sale ) * 100 - 100.
*        endif.
        if wa_exp2-lyqty gt 0.
          ach1  = ( wa_exp2-yqty / wa_exp2-lyqty ) * 100 - 100.
        endif.
        wa_sf2-grq = ach1.
        condense  wa_sf2-grq.

        clear : ach2.
        if wa_exp2-lyval gt 0.
          ach2  = ( wa_exp2-yval / wa_exp2-lyval ) * 100 - 100.
        endif.
        wa_sf2-grv = ach2.
        condense wa_sf2-grv.

        wa_sf2-gr = 'DTO'.

        clear : ngrq,ngrv..
        if wa_sf2-grq cs '-'.
          ngrq = wa_sf2-grq.
          replace '-' with space into ngrq.
          concatenate '-' ngrq into ngrq.
          condense ngrq no-gaps.
          wa_sf2-grq = ngrq.
        endif.
        if wa_sf2-grv cs '-'.
          ngrv = wa_sf2-grv.
          replace '-' with space into ngrv.
          concatenate '-' ngrv into ngrv.
          condense ngrv no-gaps.
          wa_sf2-grv = ngrv.
        endif.

        condense:   wa_sf2-prn_seq ,wa_sf2-net_qty, wa_sf2-b_qty, wa_sf2-net_sale,wa_sf2-b_pts,wa_sf2-ach1,wa_sf2-cnet_qty,wa_sf2-cb_qty,
        wa_sf2-cnet_sale,wa_sf2-cb_pts,wa_sf2-ach2,wa_sf2-grq,wa_sf2-grv,wa_sf2-lcnet_sale,wa_sf2-lcnet_qty.
*        if wa_sf2-net_qty gt 0 or wa_sf2-b_qty gt 0.
        append wa_sf2 to it_sf2.
*        endif.
      endif.
*************************************

      read table it_exp2 into wa_exp2 index 1.
      if sy-subrc eq 0.
        exp2qty  = wa_exp2-qty.
        exp2val = wa_exp2-val.
        exp2bqty = wa_exp2-bqty.
        exp2bval  = wa_exp2-bval.
        exp2ach1  = wa_exp2-ach1.
        exp2ybqty = wa_exp2-ybqty.
        exp2ybval = wa_exp2-ybval.
        exp2yqty  = wa_exp2-yqty.
        exp2yval  = wa_exp2-yval.
        exp2ach2  = wa_exp2-ach2.
        exp2lyqty  = wa_exp2-lyqty.
        exp2lyval = wa_exp2-lyval.

*        if typ1 eq 'LY'.
*          exp2qty  =   exp2qty / 1000.
*          exp2val =    exp2val / 1000.
*          exp2bqty =   exp2bqty / 1000.
*          exp2bval  =   exp2bval / 1000.
*          exp2ach1  =   exp2ach1 / 1000.
*          exp2ybqty =    exp2ybqty / 1000.
*          exp2ybval =  exp2ybval / 1000.
*          exp2yqty  =    exp2yqty / 1000.
*          exp2yval  =   exp2yval / 1000.
*          exp2ach2  =   exp2ach2 / 1000.
*          exp2lyqty  =  exp2lyqty / 1000.
*          exp2lyval =  exp2lyval / 1000.
*        endif.
      endif.

      concatenate 'C. COMPANY TOTAL' ':' into wa_sf2-maktx.
      wa_sf2-bezei = space.

      if typ1 eq 'LY'.
        clear : gnet_qty,gb_qty,gnet_sale,gb_pts,gach1,gcnet_qty,glcnet_qty,gcb_qty,gcnet_sale,glcnet_sale,gcb_pts.

        gnet_qty = ( tdsft1net_qty + exp2qty ) / 1000.
        wa_sf2-net_qty =   gnet_qty.

        gb_qty = ( tdsft1b_qty + exp2bqty ) / 1000.
        wa_sf2-b_qty =   gb_qty.

        gnet_sale = ( tdsft1net_sale + exp2val ) / 1000.
        wa_sf2-net_sale = gnet_sale.

        gb_pts = ( tdsft1b_pts + exp2bval ) / 1000.
        wa_sf2-b_pts =   gb_pts .

        gcnet_qty = ( tdsft1cnet_qty + exp2yqty ) / 1000.
        wa_sf2-cnet_qty =  gcnet_qty.

        gcb_qty = ( tdsft1cb_qty + exp2ybqty ) / 1000.
        wa_sf2-cb_qty = gcb_qty.

        gcnet_sale = ( tdsft1cnet_sale + exp2yval ) / 1000.
        wa_sf2-cnet_sale =  gcnet_sale.

        glcnet_sale = ( tdsft1lcnet_sale + exp2lyval ) / 1000.
        wa_sf2-lcnet_sale = glcnet_sale.

        gcnet_qty = ( tdsft1cnet_qty + exp2yqty ) / 1000.
        wa_sf2-cnet_qty = gcnet_qty.

        glcnet_qty = ( tdsft1lcnet_qty + exp2lyqty ) / 1000.
        wa_sf2-lcnet_qty =  glcnet_qty.

        gcb_pts = ( tdsft1cb_pts + exp2ybval ) / 1000.
        wa_sf2-cb_pts =  gcb_pts.

      else.
        wa_sf2-net_qty = tdsft1net_qty + exp2qty.
        wa_sf2-b_qty = tdsft1b_qty + exp2bqty.
        wa_sf2-net_sale = tdsft1net_sale + exp2val.
        wa_sf2-b_pts = tdsft1b_pts + exp2bval.
        wa_sf2-cnet_qty = tdsft1cnet_qty + exp2yqty.
        wa_sf2-cb_qty = tdsft1cb_qty + exp2ybqty.
        wa_sf2-cnet_sale = tdsft1cnet_sale + exp2yval.
        wa_sf2-lcnet_sale = tdsft1lcnet_sale + exp2lyval.
        wa_sf2-cnet_qty = tdsft1cnet_qty + exp2yqty.
        wa_sf2-lcnet_qty = tdsft1lcnet_qty + exp2lyqty.
        wa_sf2-cb_pts = tdsft1cb_pts + exp2ybval.
      endif.


      clear : ach1.
      if wa_sf2-b_pts gt 0.
        ach1 = (   wa_sf2-net_sale / wa_sf2-b_pts ) * 100.
      endif.
      wa_sf2-ach1 = ach1.
      condense  wa_sf2-ach1.

      clear : ach2.
      if  wa_sf2-cb_pts gt 0.
        ach2 =  ( wa_sf2-cnet_sale /  wa_sf2-cb_pts ) * 100.
      endif.
      wa_sf2-ach2 = ach2.
      condense   wa_sf2-ach2 .

      clear : ach1.
      if wa_sf2-lcnet_qty gt 0.
        ach1 = (  wa_sf2-cnet_qty  /  wa_sf2-lcnet_qty ) * 100 - 100.
      endif.
      wa_sf2-grq = ach1.
      condense  wa_sf2-grq.

      clear : ach2.
      if wa_sf2-lcnet_sale gt 0.
        ach2 = (  wa_sf2-cnet_sale  /  wa_sf2-lcnet_sale ) * 100 - 100.
      endif.
      wa_sf2-grv = ach2.
      condense  wa_sf2-grv.

*      if tdsft1lcnet_sale gt 0.
*        tdsft1grv  = ( tdsft1cnet_sale / tdsft1lcnet_sale ) * 100 - 100.
*      endif.
*      wa_sf2-grv = tdsft1grv.
      wa_sf2-gr = 'TO1'.

      clear : ngrq,ngrv..
      if wa_sf2-grq cs '-'.
        ngrq = wa_sf2-grq.
        replace '-' with space into ngrq.
        concatenate '-' ngrq into ngrq.
        condense ngrq no-gaps.
        wa_sf2-grq = ngrq.
      endif.
      if wa_sf2-grv cs '-'.
        ngrv = wa_sf2-grv.
        replace '-' with space into ngrv.
        concatenate '-' ngrv into ngrv.
        condense ngrv no-gaps.
        wa_sf2-grv = ngrv.
      endif.

      condense:   wa_sf2-prn_seq ,wa_sf2-net_qty, wa_sf2-b_qty, wa_sf2-net_sale,wa_sf2-b_pts,wa_sf2-ach1,wa_sf2-cnet_qty,wa_sf2-cb_qty,
      wa_sf2-cnet_sale,wa_sf2-cb_pts,wa_sf2-ach2,wa_sf2-grq,wa_sf2-grv,wa_sf2-lcnet_sale,wa_sf2-lcnet_qty.
      if wa_sf2-net_qty gt 0 or wa_sf2-b_qty gt 0.
        append wa_sf2 to it_sf2.
      endif.

      tdsft1net_qty = 0.
      tdsft1b_qty = 0.
      tdsft1net_sale = 0.
      tdsft1b_pts = 0.
      tdsft1ach1 = 0.
      tdsft1cnet_qty = 0.
      tdsft1cb_qty = 0.
      tdsft1cnet_sale = 0.
      tdsft1cb_pts = 0.
      tdsft1ach2 = 0.
      tdsft1grq = 0.
      tdsft1grv = 0.
      tdsft1lcnet_sale = 0.
      tdsft1lcnet_qty = 0.
    endat.

    clear wa_sf2.
  endloop.
  clear : typ2.
*  if r13 eq 'X'.
*    typ1 = 'NG'. "NEPAL GROSS
*  elseif r8 eq 'X'.
*    typ1 = 'AN'.  "SR1-A NEW
*  elseif r12 eq 'X'.
*    typ2 = 'O'.  "OTHER
*  endif.
  if r16 eq 'X'.
    perform exceldata.
  else.
    call function 'SSF_FUNCTION_MODULE_NAME'
      exporting
        formname           = 'ZSR2'
*       VARIANT            = ' '
*       DIRECT_CALL        = ' '
      importing
        fm_name            = v_fm
      exceptions
        no_form            = 1
        no_function_module = 2
        others             = 3.

*  if r6 eq 'X' or r7 eq 'X'.
    if r7 eq 'X' or r15 eq 'X'.
      perform formemail.

    else.
      call function v_fm
        exporting
          from_dt          = from_dt
          to_dt            = to_dt
          format           = format
          month1           = month1
          headtxt1         = headtxt1
          typ1             = typ1
          typ2             = typ2
        tables
          it_tab1          = it_sf2
        exceptions
          formatting_error = 1
          internal_error   = 2
          send_error       = 3
          user_canceled    = 4
          others           = 5.

    endif.
  endif.


endform.
*&---------------------------------------------------------------------*
*&      Form  SEND_MAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IN_MAILID  text
*----------------------------------------------------------------------*
form send_mail  using    p_in_mailid.
  data: salutation type string.
  data: body type string.
  data: footer type string.

  data: lo_send_request type ref to cl_bcs,
        lo_document     type ref to cl_document_bcs,
        lo_sender       type ref to if_sender_bcs,
        lo_recipient    type ref to if_recipient_bcs value is initial,lt_message_body type bcsy_text,
        lx_document_bcs type ref to cx_document_bcs,
        lv_sent_to_all  type os_boolean.

  "create send request
  lo_send_request = cl_bcs=>create_persistent( ).

  "create message body and subject
  salutation ='Dear Sir/Madam,'.
  append salutation to lt_message_body.
  append initial line to lt_message_body.

  body = 'Please find the attached SR2 REPORT in PDF format.'.

  append body to lt_message_body.
  append initial line to lt_message_body.

  footer = 'With Regards,'.
  append footer to lt_message_body.
  footer = 'BLUE CROSS LABORATORIES PVT LTD.'.
  append footer to lt_message_body.

*  IF r4 EQ 'X'.
*    ntext1 = 'HALB LYING FOR MORE THAN 20 DAYS'.
*  ELSEIF r6 EQ 'X'.
*    ntext1 = 'REJECTION DONE BY QUALITY CONTROL'.
*  ELSE.
*    ntext1 = 'INSPECTION PLAN NOT ATTACHED'.
*  ENDIF.
*  "put your text into the document


  lo_document = cl_document_bcs=>create_document(
i_type = 'RAW'
i_text = lt_message_body
i_subject = 'SR2 REPORT' ).

*DATA: l_size TYPE sood-objlen. " Size of Attachment
*l_size = l_lines * 255.
  try.

      lo_document->add_attachment(
      exporting
      i_attachment_type = 'PDF'
      i_attachment_subject = 'SR2 REPORT'
      i_att_content_hex = i_objbin[] ).
    catch cx_document_bcs into lx_document_bcs.

  endtry.


* Add attachment
* Pass the document to send request
  lo_send_request->set_document( lo_document ).

  "Create sender
  lo_sender = cl_sapuser_bcs=>create( sy-uname ).

  lo_sender     = cl_cam_address_bcs=>create_internet_address(

        i_address_string = 'sales@bluecrosslabs.com'

        i_address_name   = 'sales@bluecrosslabs.com' ).


  "Set sender
  lo_send_request->set_sender( lo_sender ).

  "Create recipient
  lo_recipient = cl_cam_address_bcs=>create_internet_address( in_mailid ).

*Set recipient
  lo_send_request->add_recipient(
  exporting
  i_recipient = lo_recipient
  i_express = abap_true
  ).

  lo_send_request->add_recipient( lo_recipient ).

* Send email
  lo_send_request->send(
  exporting
  i_with_error_screen = abap_true
  receiving
  result = lv_sent_to_all ).

  concatenate 'Email sent to' in_mailid into data(lv_msg) separated by space.
  write:/ lv_msg color col_positive.
  skip.
* Commit Work to send the email
  commit work.

endform.
*&---------------------------------------------------------------------*
*&      Form  FORMEMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form formemail .

*    *  *   * Set the control parameter
  w_ctrlop-getotf = abap_true.
  w_ctrlop-no_dialog = abap_true.
  w_compop-tdnoprev = abap_true.
  w_ctrlop-preview = space.
  w_compop-tddest = 'LOCL'.




  call function v_fm
    exporting
      control_parameters = w_ctrlop
      output_options     = w_compop
      user_settings      = abap_true
      from_dt            = from_dt
      to_dt              = to_dt
      format             = format
      month1             = month1
      headtxt1           = headtxt1
      typ1               = typ1
      typ2               = typ2
    importing
      job_output_info    = w_return " This will have all output
    tables
      it_tab1            = it_sf2
    exceptions
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      others             = 5.

  i_otf[] = w_return-otfdata[].

* Import Binary file and filesize
  call function 'CONVERT_OTF'
    exporting
      format                = 'PDF'
      max_linewidth         = 132
    importing
      bin_filesize          = v_len_in
      bin_file              = i_xstring   " This is NOT Binary. This is Hexa
    tables
      otf                   = i_otf
      lines                 = i_tline
    exceptions
      err_max_linewidth     = 1
      err_format            = 2
      err_conv_not_possible = 3
      others                = 4.
* Sy-subrc check not checked



*  * Convert Hexa String to Binary format
  call function 'SCMS_XSTRING_TO_BINARY'
    exporting
      buffer     = i_xstring
    tables
      binary_tab = i_objbin[].
  in_mailid = email.
  perform send_mail using in_mailid .

endform.
*&---------------------------------------------------------------------*
*&      Form  EXPORTDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form exportdata .
************* EXPORT CURRENT MONTH DATA
  mm = from_dt+4(2).
  myr = from_dt+0(4).

  clear:  efyear, efyear1.

  if mm ge '04'.
    efyear = myr.
    efyear1 =  efyear + 1.
  else.
    efyear = myr - 1.
    efyear1 =  efyear + 1.
  endif.

  expestsale = 'N'.
  select single * from zexpestsale  where zmonth = mm and zyear = myr.
  if sy-subrc = 0.
    if zexpestsale-sr2_pick = 'Y'.
******      EXPESTSALE = 'Y'.    "25.03.2025 - commented this for cummulative sale corr
**        READ TABLE IT_ZEXPDATA INTO WA_ZEXPDATA WITH KEY zmonth = mm zyear = myr.
*      wa_exp1-land1 = 'EXP'.
*      wa_exp1-tag = 'G'.
**        wa_exp1-matnr = wa_zexpdata-matnr.
      wa_exp1-qty = zexpestsale-netqty .
      wa_exp1-val = zexpestsale-netval.
      collect wa_exp1 into  it_exp1 .
      clear wa_exp1.
    endif.
  endif.
  if  expestsale = 'N'.
*    write : /1 'EXPORT ESTIMATED SALE NOT ENTERED'.
  endif.
*  *write : /1 expestsale, 'not found/found'.
  if expestsale = 'N'.
    select * from zexpdata into table it_zexpdata where zmonth = mm and zyear = myr.
    loop at it_zexpdata into wa_zexpdata.
*      wa_exp1-matnr = wa_zexpdata-matnr.
*      wa_exp1-land1 = 'EXP'.
*      wa_exp1-tag = 'G'.
      wa_exp1-qty = wa_zexpdata-c_qty * wa_zexpdata-conv .
      wa_exp1-val = wa_zexpdata-val + wa_zexpdata-freight.
      collect wa_exp1 into it_exp1.
      clear wa_exp1.
*    write : /1 'data collected from expdata file'.
    endloop.
  endif.
  select * from zexpbudget into table it_zexpbudget where zmonth = mm and zyear = myr.
  loop at it_zexpbudget into wa_zexpbudget.
*    wa_tab_b1-matnr = wa_zexpbudget-matnr.
*    wa_tab_b1-land1 = 'EXP'.
*    wa_tab_b1-tag = 'G'.
    wa_exp1-bqty = wa_zexpbudget-c_qty.
    wa_exp1-bval = wa_zexpbudget-net_val.
    collect wa_exp1 into it_exp1.
    clear wa_exp1.
  endloop.

  perform expcummbud.

  perform expcummsale.

  perform exppresale.

  wa_exp1-ybqty = expybqty.
  wa_exp1-ybval = expybval.
  wa_exp1-yqty = expyqty.
  wa_exp1-yval = expyval.
  wa_exp1-lyqty = explyqty.
  wa_exp1-lyval = explyval.
  collect wa_exp1 into it_exp1.
  clear wa_exp1.

*  loop at it_exp1 into wa_exp1.
*    write : / 'export',wa_exp1-qty,wa_exp1-val,wa_exp1-bqty,wa_exp1-bval.
*    clear : expach1.
*    expach1 = ( wa_exp1-val / wa_exp1-bval ) * 100.
*    write : expach1,wa_exp1-ybqty,wa_exp1-ybval,'cumm sale',wa_exp1-yqty,wa_exp1-yval.
*      clear : expach1.
*    expach1 = ( wa_exp1-yval / wa_exp1-ybval ) * 100.
*    WRITE :  expach1.
*  endloop.
*
*  break-point.
  loop at it_exp1 into wa_exp1.

    wa_exp2-qty = wa_exp1-qty.
    wa_exp2-val = wa_exp1-val.
    wa_exp2-bqty = wa_exp1-bqty.
    wa_exp2-bval = wa_exp1-bval.
    clear : expach1.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      expach1 = ( wa_exp1-val / wa_exp1-bval ) * 100.
    endcatch.
    wa_exp2-ach1 = expach1.
    wa_exp2-ybqty = wa_exp1-ybqty.
    wa_exp2-ybval = wa_exp1-ybval.
    wa_exp2-yqty = wa_exp1-yqty.
    wa_exp2-yval = wa_exp1-yval.
    clear : expach1.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
    expach1 = ( wa_exp1-yval / wa_exp1-ybval ) * 100.
    endcatch.
    wa_exp2-ach2 = expach1.
    wa_exp2-lyqty = wa_exp1-lyqty.
    wa_exp2-lyval = wa_exp1-lyval.
    collect wa_exp2 into it_exp2.
    clear wa_exp2.
  endloop.


endform.
*&---------------------------------------------------------------------*
*&      Form  EXPCUMMSALE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form expcummsale .
  data : lt_zexpestsale type table of zexpestsale,
         lw_zexpestsale type zexpestsale,
         ybqty_exp      type p,
         ybval_exp      type p decimals 2.

  clear :        expdt1,expdt2.
  expdt1+6(2) = '01'.
  expdt1+4(2) = mm.
  expdt1+0(4) = myr.
  clear: it_zexpdata,wa_zexpdata.
  select * from zexpdata into table it_zexpdata where zmonth ge '04' and zyear ge efyear .
*    and zmonth le MM and zyear = MYR.
  clear : ybqty1,ybval1,ybqty2,ybval2.
  loop at it_zexpdata into wa_zexpdata.
    clear : expdt2.
    expdt2+6(2) = '01'.
    expdt2+4(2) = wa_zexpdata-zmonth.
    expdt2+0(4) = wa_zexpdata-zyear.
    if expdt2 le expdt1.
*      wa_tab_b1-matnr = wa_ZEXPDATA-matnr.
*    wa_tab_b1-land1 = 'EXP'.
*    wa_tab_b1-tag = 'G'.
      ybqty1 = ybqty1 + wa_zexpdata-c_qty.
      ybval1 = ybval1 +  ( wa_zexpdata-val + wa_zexpdata-freight ).
    endif.
  endloop.

  clear: it_zexpdata,wa_zexpdata.
  select * from zexpdata into table it_zexpdata where zmonth le '03' and zyear = efyear1.
  clear : ybqty2,ybval2.
  loop at it_zexpdata into wa_zexpdata.
    clear : expdt2.
    expdt2+6(2) = '01'.
    expdt2+4(2) = wa_zexpdata-zmonth.
    expdt2+0(4) = wa_zexpdata-zyear.
    if expdt2 le expdt1.
*    wa_tab_b1-matnr = wa_ZEXPDATA-matnr.
*    wa_tab_b1-land1 = 'EXP'.
*    wa_tab_b1-tag = 'G'.
      ybqty2 = ybqty2 + wa_zexpdata-c_qty.
      ybval2 = ybval2 +  ( wa_zexpdata-val + wa_zexpdata-freight ).
    endif.
  endloop.

******* START - added 25.03.2025 - check for any expected sale/provisional sales to be added into cummulative sales
  clear lt_zexpestsale[].
  select * from zexpestsale into table lt_zexpestsale
     where zyear in ( efyear , efyear1 ) .
  if sy-subrc = 0.
    clear : ybqty_exp,ybval_exp.
    loop at lt_zexpestsale into lw_zexpestsale where sr2_pick = 'Y'.
      ybqty_exp = ybqty_exp + lw_zexpestsale-netqty.
      ybval_exp = ybval_exp + lw_zexpestsale-netval.
    endloop.
  endif.
******* END - added 25.03.2025 - check for any expected sale/provisional sales to be added into cummulative sales
  clear : expyqty,expyval.
  expyqty = ybqty1 + ybqty2 + ybqty_exp.
  expyval = ybval1 + ybval2 + ybval_exp.




endform.
*&---------------------------------------------------------------------*
*&      Form  EXPCUMMBUD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form expcummbud .
  clear : expdt1,expdt2.
  expdt1+6(2) = '01'.
  expdt1+4(2) = mm.
  expdt1+0(4) = myr.
  clear: it_zexpbudget,wa_zexpbudget.
  select * from zexpbudget into table it_zexpbudget where zmonth ge '04' and zyear ge efyear .
*    and zmonth le MM and zyear = MYR.
  clear : ybqty1,ybval1,ybqty2,ybval2.
  loop at it_zexpbudget into wa_zexpbudget.
    clear : expdt2.
    expdt2+6(2) = '01'.
    expdt2+4(2) = wa_zexpbudget-zmonth.
    expdt2+0(4) = wa_zexpbudget-zyear.
    if expdt2 le expdt1.
*      wa_tab_b1-matnr = wa_zexpbudget-matnr.
*    wa_tab_b1-land1 = 'EXP'.
*    wa_tab_b1-tag = 'G'.
      ybqty1 = ybqty1 + wa_zexpbudget-c_qty.
      ybval1 = ybval1 + wa_zexpbudget-net_val.
    endif.
  endloop.

  clear: it_zexpbudget,wa_zexpbudget.
  select * from zexpbudget into table it_zexpbudget where zmonth le '03' and zyear = efyear1.
  clear : ybqty2,ybval2.
  loop at it_zexpbudget into wa_zexpbudget.
    clear : expdt2.
    expdt2+6(2) = '01'.
    expdt2+4(2) = wa_zexpbudget-zmonth.
    expdt2+0(4) = wa_zexpbudget-zyear.
    if expdt2 le expdt1.
*    wa_tab_b1-matnr = wa_zexpbudget-matnr.
*    wa_tab_b1-land1 = 'EXP'.
*    wa_tab_b1-tag = 'G'.
      ybqty2 = ybqty2 + wa_zexpbudget-c_qty.
      ybval2 = ybval2 + wa_zexpbudget-net_val.
    endif.
  endloop.
  clear : expybqty,expybval.
  expybqty = ybqty1 + ybqty2.
  expybval = ybval1 + ybval2.


endform.
*&---------------------------------------------------------------------*
*&      Form  EXPPRESALE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form exppresale .
*  break-point .
  lefyear = efyear - 1.
  lefyear1 = efyear1 - 1.
  lmyr = myr - 1.

  clear : expdt1,expdt2.
  expdt1+6(2) = '01'.
  expdt1+4(2) = mm.
  expdt1+0(4) = lmyr.
  clear: it_zexpdata,wa_zexpdata.
  select * from zexpdata into table it_zexpdata where zmonth ge '04' and zyear ge lefyear .
*    and zmonth le MM and zyear = MYR.
  clear : lybqty1,lybval1,lybqty2,lybval2.
  loop at it_zexpdata into wa_zexpdata.
    clear : expdt2.
    expdt2+6(2) = '01'.
    expdt2+4(2) = wa_zexpdata-zmonth.
    expdt2+0(4) = wa_zexpdata-zyear.
    if expdt2 le expdt1.
*      wa_tab_b1-matnr = wa_ZEXPDATA-matnr.
*    wa_tab_b1-land1 = 'EXP'.
*    wa_tab_b1-tag = 'G'.
      lybqty1 = lybqty1 + wa_zexpdata-c_qty.
      lybval1 = lybval1 +  ( wa_zexpdata-val + wa_zexpdata-freight ).
    endif.
  endloop.

  clear: it_zexpdata,wa_zexpdata.
  select * from zexpdata into table it_zexpdata where zmonth le '03' and zyear = lefyear1.
  clear : lybqty2,lybval2.
  loop at it_zexpdata into wa_zexpdata.
    clear : expdt2.
    expdt2+6(2) = '01'.
    expdt2+4(2) = wa_zexpdata-zmonth.
    expdt2+0(4) = wa_zexpdata-zyear.
    if expdt2 le expdt1.
*    wa_tab_b1-matnr = wa_ZEXPDATA-matnr.
*    wa_tab_b1-land1 = 'EXP'.
*    wa_tab_b1-tag = 'G'.
      lybqty2 = lybqty2 + wa_zexpdata-c_qty.
      lybval2 = lybval2 +  ( wa_zexpdata-val + wa_zexpdata-freight ).
    endif.
  endloop.
*  break-point.
  clear : explyqty,explyval.
  explyqty = lybqty1 + lybqty2.
  explyval = lybval1 + lybval2.


*  break-point.
endform.
*&---------------------------------------------------------------------*
*&      Form  EXCELDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form exceldata .


  concatenate 'GROUP NAME' 'UNIT SALE' 'UNIT-BUD' 'VALUE-SALE' 'VALUE-BUD' '%' 'UNIT-SALE' 'UNIT-BUD'  'VALUE-SALE' 'VALUE-BUD' ' %'  'UNT.GR' 'VL.GR'  into  w_attachment separated by  con_tab.
  concatenate con_cret w_attachment into w_attachment.
  append w_attachment to i_attachment.
  clear  w_attachment.
  concatenate ' ' 'THIS-MTH' 'THIS-MTH' 'THIS-MTH'   'THIS-MTH' 'ACH' 'THIS-YTD' 'THIS-YTD'   'THIS-YTD'   'THIS-YTD' 'ACH' 'TH.YD' 'TH.YD'   into  w_attachment separated by  con_tab.
  concatenate con_cret w_attachment into w_attachment.
  append w_attachment to i_attachment.
  clear  w_attachment.

  loop at it_sf2 into wa_sf2.
*      WRITE wa_tab5-qndat TO wa_dat DD/MM/YYYY.
*      WRITE wa_tab5-hsdat TO wa_dat1 DD/MM/YYYY.
*      WRITE wa_tab5-vfdat TO wa_dat2 DD/MM/YYYY.
    concatenate wa_sf2-maktx wa_sf2-net_qty wa_sf2-b_qty wa_sf2-net_sale wa_sf2-b_pts wa_sf2-ach1
    wa_sf2-cnet_qty wa_sf2-cb_qty wa_sf2-cnet_sale wa_sf2-cb_pts wa_sf2-ach2 wa_sf2-grq wa_sf2-grv
           into w_attachment separated by con_tab.
    concatenate con_cret w_attachment into w_attachment.
    append w_attachment to i_attachment.
    clear  w_attachment.
  endloop.


  w_document_data-obj_name  = 'SR2 REPORT'.
  w_document_data-obj_descr = 'SR2 REPORT'.
  w_body_msg = 'Dear Sir / Madam'.
  append w_body_msg to i_body_msg.
  clear  w_body_msg.
  if net eq 'X'.
    w_body_msg+0(50) = 'Plz. find attached SR2-Net Report  for the period'.
  elseif gross eq 'X'.
    w_body_msg+0(50) = 'Plz. find attached ZSR2-Gross Report  for the period'.
  endif.
  w_body_msg+52(10) = month1.
*  wa_d1.
*  w_body_msg+64(3) = 'To'.
*  w_body_msg+69(10) = wa_d2.
  append w_body_msg to i_body_msg.
  clear  w_body_msg.
  w_body_msg = '   '.
  append w_body_msg to i_body_msg.
  clear  w_body_msg.
  w_body_msg = '   '.
  append w_body_msg to i_body_msg.
  clear  w_body_msg.
  w_body_msg = 'This eMail is meant for information only. Please DO NOT REPLY.'.
  append w_body_msg to i_body_msg.
  clear  w_body_msg.
  describe table i_body_msg lines g_tab_lines.
  w_packing_list-head_start = 1.
  w_packing_list-head_num   = 1.
  w_packing_list-body_start = 1.
  w_packing_list-body_num   = g_tab_lines.
  w_packing_list-doc_type   = 'RAW'.
  append w_packing_list to i_packing_list.
  clear  w_packing_list.
  append lines of i_attachment to i_body_msg.
  w_packing_list-head_start = 2.
  w_packing_list-head_num   = 1.
  w_packing_list-body_start = g_tab_lines + 1.
  data lines type i.

  describe table i_attachment lines lines.
  w_packing_list-body_num = lines.
  w_packing_list-doc_type   = 'XLS'.
  w_packing_list-obj_descr  = 'BLUECROSS'.
  w_packing_list-obj_name   = 'TXT_ATTACHMENT'.
  w_packing_list-doc_size   = w_packing_list-body_num * 255.
  append w_packing_list to i_packing_list.
  clear  w_packing_list.

  "Fill the document data and get size of attachment
  w_document_data-obj_langu  = sy-langu.
  read table i_body_msg into w_body_msg index g_attachment_lines.
  w_document_data-doc_size = ( g_attachment_lines - 1 ) * 255 + strlen( w_body_msg ).
  "Receivers List.
  w_receivers-rec_type   = 'U'.  "Internet address
  w_receivers-receiver   = email.
  w_receivers-com_type   = 'INT'.
  w_receivers-notif_del  = 'X'.
  w_receivers-notif_ndel = 'X'.
  append w_receivers to i_receivers .
  clear:w_receivers.

  "Function module to send MAI to Recipients
  call function 'SO_NEW_DOCUMENT_ATT_SEND_API1'
    exporting
      document_data              = w_document_data
      put_in_outbox              = 'X'
      commit_work                = 'X'
    importing
      sent_to_all                = g_sent_to_all
    tables
      packing_list               = i_packing_list
      contents_txt               = i_body_msg
      receivers                  = i_receivers
    exceptions
      too_many_receivers         = 1
      document_not_sent          = 2
      document_type_not_exist    = 3
      operation_no_authorization = 4
      parameter_error            = 5
      x_error                    = 6
      enqueue_error              = 7
      others                     = 8.
  format  color 1.
  if sy-subrc = 0 .
    write : / 'Mail has been Successfully Sent on:',email.
  else.
    wait up to 2 seconds.
    "This program starts the SAPconnect send process.
    submit rsconn01 with mode = 'INT' with output = 'X' and return.
  endif.
  clear : i_attachment,i_body_msg,i_packing_list,i_receivers .
endform.
