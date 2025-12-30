*&---------------------------------------------------------------------*
*& Report  ZTOP_BY_PRODUCT_VALUE
*&---------------------------------------------------------------------*
*&DESCRIPTION       : Mergining of all ZTOP* tocdes/prog
*CREATED BY         : Shraddha Pradhan
*CREATED ON         : 06/07/2022
*Request No         : BCDK933274, BCDK933280,BCDK933288,BCDK933294
*T-code             : ZTOP_SELLERS
*&---------------------------------------------------------------------*
*&Modification History
*&---------------------------
*&Changed by/date       : 01.08.2023
*&DESCRIPTION           : Add mtpt/tot.sales in prd.grp and corr of target/no.of.pso/productivity in value-wise
*&Request No.          : BCDK933346
*&---------------------------------------------------------------------*
*&Changed by/date       : 31.08.2023
*&DESCRIPTION           : Corr in mtpt/tot.sales in prd.grp-wise and corr of target/no.of.pso/productivity in value-wise for RM
*&                        Corr.done for missing PSO data for PRD-GRP wise as compared to old t-code
*&Request No.          : BCDK933494,BCDK933500
*&---------------------------------------------------------------------*
*&Changed by/date       : 10.10.2023
*&DESCRIPTION           : data selection problem when month in date range at input is lower
*&                        i.e.financial year date is not working when using between in select query
*&Request No.          : BCDK933666
*&---------------------------------------------------------------------*
*&Changed by/date       : 01.12.2023
*&DESCRIPTION           : PSOs/RMs/ZMs value-wise report designation correction
*&Request No.          : BCDK933853
*&---------------------------------------------------------------------*
*&Changed by/date       : 01.12.2023
*&DESCRIPTION           : Corr.in Hq desc. and layout font size
*&Request No.          : BCDK933883 , BCDK933919
*&---------------------------------------------------------------------*
*&Changed by/date       : 28.12.2023
*&DESCRIPTION           : Remove zero value records.
*&Request No.          : BCDK933989
*&---------------------------------------------------------------------------------------------*
*&Changed by/date       : 16.01.2024
*&DESCRIPTION           : Corr.in prod.grp - email sending - parameter name mismatched
*&Request No.          : BCDK934095
*&----------------------------------------------------------------------------------------------*
*&Changed by/date       : 16.01.2024
*&DESCRIPTION           : Restore zero value records for prod.pack & group
*&Request No.          : BCDK934427
*&-----------------------------------------------------------------------------------------------*
*&Changed by/date       : 29.06.2024
*&DESCRIPTION           : In value-wise - current yr data select frm ZCUMPSO instead of ZRCUMPSO
*&                        to make target correct
*&Request No.          : BCDK935383,BCDK935387
*&----------------------------------------------------------------------------------------------*
*&Changed by/date       : 20.01.2025
*&DESCRIPTION           : Ranking Bulletin layout option for Field i.e.PSO/RM/ZM
*&Request No.          : BCDK936330, BCDK936384,BCDK936875,BCDK936900
*&----------------------------------------------------------------------------------------------*
report ztop_by_product_value.

tables : zdsmter,zrpqv,zcumpso,yterrallc,pa0001,pa0000,zthr_heq_des,ysd_dist_targt,mara.

type-pools slis.

constants :gc_true         type c value 'X',
           gc_email_sender type adr6-smtp_addr value 'sales@bluecrosslabs.com'.

types :begin of ty_0001,
         pernr00   type persno,
         dtjoin    type begda,
         pernr01   type persno,
         begda     type begda,
         endda     type endda,
         abkrs     type abkrs,
         ansvh     type ansvh,
         persk     type persk,
         plans     type plans,
         ename     type emnam,
         zz_hqcode type zdehr_hqcode,
       end of ty_0001,

       begin of ty_fdata,     "for prod.pack-wise and prod.group-wise
         srno      type i,
         zdsm      type bzirk,
         zrsm      type bzirk,
         zmname    type emnam,
         rmname    type emnam,
         bzirk     type bzirk,
         pernr     type persno,
         ename     type emnam,
         zz_hqcode type   zdehr_hqcode,
         zz_hqdesc type zdehr_hqdesc,
         des       type hr_mcshort, "plstx,
         div(5)    type c,
         doj       type begda,
         sales     type p,
         avgsales  type p,
         psales    type p,
         qty       type p,
         avgqty    type p,
         pqty      type p,
         grth_p    type p,
         grth      type p,
         totpso    type p,
         ypm       type p,
       end of ty_fdata,

       begin of ty_vfdata,   "for value-wise
         srno      type i,
         pernr     type persno,
         ename     type emnam,
         bzirk     type bzirk,
         zz_hqcode type zdehr_hqcode,
         zz_hqdesc type zdehr_hqdesc,
         des       type hr_mcshort,
         div(5)    type c,
         doj       type begda,
         sales     type p,
         target    type p,
         pertgt    type p decimals 2,
         psales    type p,
         pqty      type p,
         grth      type p,
         d_bzirk   type bzirk,
         z_bzirk   type bzirk,
         r_bzirk   type bzirk,
         rmname    type emnam,
         zmname    type emnam,
         totpso    type p,
         ypm       type p,
       end of ty_vfdata,

       begin of ty_pso_sale,
         bzirk  type bzirk,
         sales  type p,
         psales type p,
         qty    type p,
         pqty   type p,
       end of ty_pso_sale,

       begin of ty_rm_sale,
         zdsm   type bzirk,
         zrsm   type bzirk,
         sales  type p,
         psales type p,
         qty    type p,
         pqty   type p,
         target type p,
       end of ty_rm_sale,

       begin of ty_zm_sale,
         zdsm   type bzirk,
         sales  type p,
         psales type p,
         qty    type p,
         pqty   type p,
         target type p,
         totpso type p,
       end of ty_zm_sale,

       begin of ty_yterr,
         spart type spart,
         bzirk type bzirk,
         endda type endda,
         begda type begda,
         plans type plans,
         bztxt type bztxt,
       end of ty_yterr,

       begin of ty_bulletin,
         srno    type i,
         pernr   type persno,
         ename   type emnam,
         bzirk   type bzirk,
         div(5)  type c,
         sales   type p,
         pertgt  type p decimals 2,
         ypm     type p,

         srno1   type i,
         pernr1  type persno,
         ename1  type emnam,
         bzirk1  type bzirk,
         div1(5) type c,
         sales1  type p,
         pertgt1 type p decimals 2,
         ypm1    type p,
       end of ty_bulletin.
*****types begin of ty_top_qty_val.
*****        include structure zty_top_qty_val.
*****types : mtpt      type p,
*****        tot_sales type p.
*****types end of   ty_top_qty_val.


data : gt_zrpqv           type table of zrpqv,
       gw_zrpqv           type zrpqv,
       gt_zrpqv_py        type table of zrpqv,
       gw_zrpqv_py        type zrpqv,
       gt_zrpqv_add       type table of zrpqv,
       gw_zrpqv_add       type zrpqv,
       gt_zrpqv_py_add    type table of zrpqv,
       gw_zrpqv_py_add    type zrpqv,
       gt_zrcumpso        type table of zrcumpso,
       gw_zrcumpso        type zrcumpso,
       gt_zrcumpso_py     type table of zrcumpso,
       gw_zrcumpso_py     type zrcumpso,
       gt_zrcumpso_add    type table of zrcumpso,
       gw_zrcumpso_add    type zrcumpso,
       gt_zrcumpso_py_add type table of zrcumpso,
       gw_zrcumpso_py_add type zrcumpso,
       gt_zdsmter         type table of zdsmter,
       gw_zdsmter         type zdsmter,
       gt_pso             type table of zdsmter,
       gw_pso             type zdsmter,
       gt_pso1            type table of zdsmter,
       gw_pso1            type zdsmter,
       gt_zm              type table of zdsmter,
       gw_zm              type zdsmter,
       gt_rm              type table of zdsmter,
       gw_rm              type zdsmter,
       gt_yterr           type table of ty_yterr, "yterrallc,
       gw_yterr           type ty_yterr, "yterrallc,
       gt_hq_des          type table of zthr_heq_des,
       gw_hq_des          type zthr_heq_des,
       gt_target          type table of ysd_dist_targt,
       gw_target          type ysd_dist_targt,
       gt_0001            type table of ty_0001,
       gw_0001            type ty_0001,
       gt_prdgrp          type table of zprdgroup,
       gw_prdgrp          type zprdgroup,
       gt_fdata           type table of zty_top_qty_val, "ty_fdata,
       gw_fdata           type zty_top_qty_val, "ty_fdata,
       gt_fdata_tmp       type table of zty_top_qty_val, "ty_fdata,
       gw_fdata_tmp       type zty_top_qty_val, "ty_fdata,
       gt_fdata_tmp1      type table of zty_top_qty_val, "ty_fdata,
       gw_fdata_tmp1      type zty_top_qty_val, "ty_fdata,
       gt_vfdata          type table of zty_top_qty_val, "ty_vfdata,
       gw_vfdata          type zty_top_qty_val, "ty_vfdata,
       gt_vfdata_tmp      type table of zty_top_qty_val, "ty_vfdata,
       gw_vfdata_tmp      type zty_top_qty_val, "ty_vfdata,
       gt_pso_sale        type table of ty_pso_sale,
       gw_pso_sale        type ty_pso_sale,
       gt_rm_sale         type table of ty_rm_sale,
       gw_rm_sale         type ty_rm_sale,
       gt_zm_sale         type table of ty_zm_sale,
       gw_zm_sale         type ty_zm_sale,
       gt_ztotpso         type table of ztotpso,
       gw_ztotpso         type ztotpso,
       gt_ztotpso_add     type table of ztotpso,
       gw_output_opts     type ssfcompop,
       gw_contrl_para     type ssfctrlop,
       gt_otf             type standard table of itcoo,
       gt_otf_data        type ssfcrescl,
       gt_tline           type standard table of tline,
       gt_pdf_data        type solix_tab,
       gt_text            type bcsy_text,
       gt_s_mat           type table of zsr37_ser,
       gw_s_mat           type zsr37_ser,
       gt_s_grp           type table of zsr121314_help,
       gw_s_grp           type  zsr121314_help,
       gt_bulletin        type table of zty_bulletin, "TY_BULLETIN,
       gt_bulletin_dc     type table of zty_bulletin, "TY_BULLETIN,
       gt_bulletin_gc     type table of zty_bulletin, "TY_BULLETIN,
       gt_bulletin_sc     type table of zty_bulletin, "TY_BULLETIN,
       gt_bulletin_bc     type table of zty_bulletin, "TY_BULLETIN,
       gw_bulletin        type zty_bulletin. "TY_BULLETIN.
.

"Object References
data: lo_bcs     type ref to cl_bcs,
      lo_doc_bcs type ref to cl_document_bcs,
      lo_recep   type ref to if_recipient_bcs,
      lo_sender  type ref to if_sender_bcs,  "cl_sapuser_bcs,
      lo_cx_bcx  type ref to cx_bcs.


data : gt_fcat    type slis_t_fieldcat_alv,
       gw_fcat    like line of gt_fcat,
       gw_layout  type slis_layout_alv,
       gt_comment type slis_t_listheader,
       gw_comment like line of gt_comment,
       gt_sort    type slis_t_sortinfo_alv,
       gw_sort    like line of gt_sort.

data :gv_py_dt1       type sy-datum,
      gv_py_dt2       type sy-datum,
      gv_rep_hdr      type string,
      gv_bin_filesize type so_obj_len,
      gv_bin_xstr     type xstring,
      gv_text         type string,
      gv_sent_to_all  type os_boolean,
      gv_subject      type so_obj_des,
      gv_dclub_low    type zval_dec2,
      gv_dclub_high   type zval_dec2,
      gv_sclub_low    type zval_dec2,
      gv_sclub_high   type zval_dec2,
      gv_gclub_low    type zval_dec2,
      gv_gclub_high   type zval_dec2,
      gv_bclub_low    type zval_dec2,
      gv_bclub_high   type zval_dec2.


selection-screen begin of block b0 with frame title text-001.
*****parameters: p_prod radiobutton group r0 user-command rb0,
*****            p_group radiobutton group r0,
*****            p_value radiobutton group r0.
selection-screen begin of line.
parameters p_prod radiobutton group r0 user-command rb0.
selection-screen comment 10(20) for field p_prod.

parameters p_group radiobutton group r0.
selection-screen comment 35(20) for field p_group.

parameters p_value radiobutton group r0 .
selection-screen comment 79(20) for field p_value.
selection-screen end of line.

selection-screen skip.
selection-screen begin of block b1 with frame title text-006 no intervals.
parameters: p_qty  radiobutton group r1 user-command rb1 modif id prd,
            p_val  radiobutton group r1 modif id prd,
            p_per  radiobutton group r1 modif id val,
            p_sale radiobutton group r1 modif id val.
selection-screen end of block b1.

selection-screen begin of block b2 with frame title text-002 no intervals.
parameters: p_pso radiobutton group r2,
            p_rm  radiobutton group r2,
            p_zm  radiobutton group r2.
selection-screen end of block b2.

selection-screen end of block b0.

selection-screen begin of block b3 with frame title text-005.
parameters : p_adate type sy-datum default sy-datum." obligatory,
select-options: s_date for sy-datum no-extension," obligatory,
                s_mat for zrpqv-matnr matchcode object zsr37_ser,
                s_grp for mara-matkl matchcode object zsr121314_help."zsr2_help."
parameters  : p_zone like  zdsmter-zdsm matchcode object zsr9_1,
              p_cnt  type i.


selection-screen begin of block b4 with frame title text-003 no intervals.

selection-screen begin of line.
parameters cb_bc as checkbox user-command cbox.
selection-screen comment 5(5) for field cb_bc.

parameters cb_xl as checkbox user-command cbox.
selection-screen comment 15(5) for field cb_xl.

parameters cb_bcl as checkbox user-command cbox .
selection-screen comment 25(5) for field cb_bcl.

parameters cb_ls as checkbox user-command cbox .
selection-screen comment 35(5) for field cb_ls.
selection-screen end of line.

selection-screen end of block b4.

selection-screen begin of block b5 with frame title text-004.
parameters: p_rad1 radiobutton group r3  user-command rb4,
            p_rad2 radiobutton group r3,
            p_rad3 radiobutton group r3.
parameter: p_email type ad_smtpadr .
selection-screen skip.
parameter: p_rad4 radiobutton group r3.

******" this sel.screen is only enable for value-wise option p_value = X
selection-screen begin of block b6 with frame title text-005.
parameters :p_bno type string modif id blt.
select-options : s_dclub for zcumpso-netval modif id blt,               "diamond club sale range
                 s_gclub for zcumpso-netval modif id blt,               "gold club sale range
                 s_sclub for zcumpso-netval modif id blt,               "Silver club sale range
                 s_bclub for zcumpso-netval modif id blt.               "bronze club sale range

parameters : p_ypm type zval_dec0 modif id blt.       "min.YPM / productivity
selection-screen end of block b6.
selection-screen end of block b5.
selection-screen end of block b3.

at selection-screen output.
  if p_prod = 'X'.
    if p_per = 'X' .
      clear p_per.
    endif.
    if p_sale = 'X'.
      clear p_sale.
    endif.
    loop at screen.
      if screen-group1 = 'PRD' .
        screen-input = 1.
        screen-active = 1.
        modify screen.
      endif.
      if screen-group1 = 'VAL'.
        screen-input = 0.
        screen-active = 0.
        modify screen.
      endif.

      if screen-name = 'S_GRP-LOW' or screen-name = 'S_GRP-HIGH'.
        screen-input = 0.
        modify screen.
      endif.
      if screen-name = 'S_MAT-LOW' or screen-name = 'S_MAT-HIGH'.
        screen-input = 1.
        modify screen.
      endif.
    endloop.
  elseif p_group = 'X'.
    if p_per = 'X' .
      clear p_per.
    endif.
    if p_sale = 'X'.
      clear p_sale.
    endif.
    clear p_prod.
    loop at screen.
      if screen-group1 = 'PRD' .
        screen-input = 1.
        screen-active = 1.
        modify screen.
      endif.
      if screen-group1 = 'VAL' .
        screen-input = 0.
        screen-active = 0.
        modify screen.
      endif.

      if screen-name = 'S_GRP-LOW' or screen-name = 'S_GRP-HIGH'.
        screen-input = 1.
        modify screen.
      endif.
      if screen-name = 'S_MAT-LOW' or screen-name = 'S_MAT-HIGH'.
        screen-input = 0.

        modify screen.
      endif.
    endloop.
  elseif p_value = 'X'.
    clear p_qty.
    loop at screen.
      if screen-group1 = 'VAL'.
        screen-input = 1.
        screen-active = 1.
        modify screen.
      endif.
      if screen-group1 = 'PRD'.
        screen-input = 0.
        screen-active = 0.
        modify screen.
      endif.
      if screen-name = 'S_GRP-LOW' or screen-name = 'S_GRP-HIGH' or
         screen-name = 'S_MAT-LOW' or screen-name = 'S_MAT-HIGH' or
         screen-name = 'P_ZONE'.
        screen-input = 0.
        modify screen.
      endif.
    endloop.
  else.
    loop at screen.
      if screen-group1 = 'VAL' .
        screen-input = 0.
        screen-active = 0.
        modify screen.
      endif.
      if screen-group1 = 'PRD' .
        screen-input = 1.
        screen-active = 1.
        modify screen.
      endif.

      if  screen-name = 'S_GRP-LOW' or screen-name = 'S_GRP-HIGH'.
        screen-input = 0.
        modify screen.
      endif.
      if  screen-name = 'S_MAT-LOW' or screen-name = 'S_MAT-HIGH'.
        screen-input = 1.
        modify screen.
      endif.
    endloop.
  endif.


  if p_rad4 = abap_true.
    loop at screen.
      if screen-group1 = 'BLT' .
        screen-input = 1.
        screen-active = 1.
        modify screen.
      endif.
    endloop.
  else.
    loop at screen.
      if screen-group1 = 'BLT' .
        screen-input = 0.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
  endif.




start-of-selection.

***** for ranking criteria
  if p_prod = abap_true .             " prod.pack-wise
    if p_pso = abap_true.           " for PSO's
      if s_date[] is not initial.
        perform get_pso_data.
      else.
        message 'Please enter date' type 'I'.
      endif.
    elseif p_rm = abap_true.        " for RM's
      if s_date[] is not initial.
        perform get_rm_data.
      else.
        message 'Please enter date' type 'I'.
      endif.
    else.                     " for ZM's
      if s_date[] is not initial.
        perform get_zm_data.
      else.
        message 'Please enter date' type 'I'.
      endif.
    endif.

  elseif  p_group = abap_true.     "prod.group-wise
    if p_pso = abap_true.           " for PSO's
      if s_date[] is not initial.
        perform get_pso_data.
      else.
        message 'Please enter date' type 'I'.
      endif.
    elseif p_rm = abap_true.        " for RM's
      if s_date[] is not initial.
        perform get_rm_data.
      else.
        message 'Please enter date' type 'I'.
      endif.
    else.                     " for ZM's
      if s_date[] is not initial.
        perform get_zm_data.
      else.
        message 'Please enter date' type 'I'.
      endif.
    endif.

  else.       "(Rs.)Value-wise
    if p_pso = abap_true.           " for PSO's
      if s_date[] is not initial.
        perform get_pso_value_data.
      else.
        message 'Please enter date' type 'I'.
      endif.
    elseif p_rm = abap_true.        " for RM's
      if s_date[] is not initial.
        perform get_rm_value_data.
      else.
        message 'Please enter date' type 'I'.
      endif.
    else.                     " for ZM's
      if s_date[] is not initial.
        perform get_zm_value_data.
      else.
        message 'Please enter date' type 'I'.
      endif.
    endif.
  endif.

****** As per output options
  if p_rad1 = abap_true.          "for ALV display
    if gt_fdata[] is not initial.
      perform build_fcat.
      perform display_alv.
    endif.

    if gt_vfdata[] is not initial.
      perform build_fcat_val.
      perform display_alv_val.
    endif.

  elseif p_rad2 = abap_true.      "for Layout print
    if gt_fdata[] is not initial or gt_vfdata[] is not initial.
      perform display_layout.
    endif.
  elseif p_rad4 = abap_true.      "for Bulletin layout print
    if gt_fdata[] is not initial or gt_vfdata[] is not initial.
      perform prepare_bulletin.
      perform display_bulletin.
    endif.
  else.                     "for email sending
    if gt_fdata[] is not initial or gt_vfdata[] is not initial.
      perform email_form.
    endif.
  endif.
*&---------------------------------------------------------------------*
*&      Form  GET_PSO_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form get_pso_data .
  data : lv_srno      type i,
         lw_yterr     type ty_yterr,
         lw_zdrphq    type zdrphq,
         lv_month_cnt type i,
         lv_trgt_yr   type i,
         lv_trgt_val  type p,
         lv_date      type sy-datum,
         lv_mnth      type i,
         lw_mtpt      type zmtpt,
         lw_rm        type zdsmter,
         lv_sdate     type sy-datum,
         lv_edate     type sy-datum.

**** get prev.year dates from entered s_date
  clear  gv_py_dt1.
  call function 'RP_CALC_DATE_IN_INTERVAL'
    exporting
      date      = s_date-low
      days      = 0
      months    = 0
      signum    = '-'
      years     = 1
    importing
      calc_date = gv_py_dt1.

  clear gv_py_dt2.
  call function 'RP_CALC_DATE_IN_INTERVAL'
    exporting
      date      = s_date-high
      days      = 0
      months    = 0
      signum    = '-'
      years     = 1
    importing
      calc_date = gv_py_dt2.

***** months difference between entered dates
  clear lv_month_cnt.
  if s_date-low+4(2) = s_date-high+4(2).
    lv_month_cnt = 1.
  elseif s_date-low+4(2) <> s_date-high+4(2) and s_date-low+0(4) = s_date-high+0(4).
    lv_month_cnt = s_date-high+4(2) -  s_date-low+4(2) + 1.
  elseif s_date-low+4(2) <> s_date-high+4(2) and s_date-low+0(4) <> s_date-high+0(4).
    lv_month_cnt = 12 -  s_date-low+4(2) + 1.
    lv_month_cnt = lv_month_cnt + s_date-high+4(2).
  endif.

****  target year
  clear lv_trgt_yr.
  if s_date-high+4(2) < 4.
    lv_trgt_yr = s_date-high+0(4) - 1.
  else.
    lv_trgt_yr = s_date-low+0(4).
  endif.

*****  IF p_zone IS NOT INITIAL.
*****    CLEAR :gt_zdsmter[].
*****    SELECT * FROM zdsmter INTO TABLE gt_zdsmter
*****      WHERE zdsm = p_zone
*****      AND zmonth EQ s_date-high+4(2)
*****      AND zyear EQ s_date-high(4).
*****  ELSE.
  clear :gt_zdsmter[].
  select * from zdsmter into table gt_zdsmter
    where zmonth eq p_adate+4(2)"s_date-high+4(2)
    and zyear eq p_adate+0(4)."s_date-high(4).
*****  ENDIF.

  if gt_zdsmter[] is not initial.

    sort gt_zdsmter[] by zdsm.
**** get ZMs
    clear gt_zm[].
    gt_zm[] = gt_zdsmter[].
    delete gt_zm where zdsm+0(2) = 'R-'.
    sort gt_zm by zdsm bzirk.
    delete adjacent duplicates from gt_zm comparing zdsm bzirk.
**** get RMs
    clear gt_rm[].
    gt_rm[] = gt_zdsmter[].
    delete gt_rm where zdsm+0(2) = 'D-'.
    sort gt_rm by zdsm bzirk.
    delete adjacent duplicates from gt_rm comparing zdsm bzirk.
    sort gt_rm by zdsm zmonth zyear bzirk.
    delete adjacent duplicates from gt_rm comparing zdsm zmonth zyear bzirk .

    clear gt_yterr[].
    select a~spart a~bzirk a~endda a~begda a~plans
           b~bztxt into table gt_yterr
      from yterrallc as a inner join t171t as b
      on a~bzirk = b~bzirk
      where a~endda = '99991231'
      and b~spras = sy-langu.

    clear gt_0001[].
    select a~pernr a~begda
           b~pernr b~begda b~endda b~abkrs b~ansvh b~persk b~plans b~ename b~zz_hqcode into table gt_0001
      from pa0000 as a inner join pa0001 as b
      on a~pernr = b~pernr
      where a~massn = '01'
      and b~endda eq '99991231'.

***** HQ des
    clear gt_hq_des[].
    select * from zthr_heq_des into table gt_hq_des.


  endif.
  if p_group = 'X' .
***** get materials from prd.group.
    clear gt_prdgrp[].
    select * from zprdgroup into table gt_prdgrp
      where rep_type = 'SR121314'
      and grp_code in s_grp.
    if gt_prdgrp[] is not initial.
      sort gt_prdgrp[] by prd_code.
***** get sales current date - product Group-wise
      clear gt_zrpqv[].
      clear lv_sdate.
      lv_sdate = s_date-low.
      while lv_sdate <= s_date-high.
        select * from zrpqv appending table gt_zrpqv
          for all entries in gt_prdgrp
          where zmonth = lv_sdate+4(2)
          and zyear = lv_sdate+0(4)
          and matnr = gt_prdgrp-prd_code.

        call function 'RE_ADD_MONTH_TO_DATE'
          exporting
            months  = '1'
            olddate = lv_sdate
          importing
            newdate = lv_sdate.

      endwhile.
***** get sales previous year dates - product Group-wise
      clear gt_zrpqv_py[].
      clear lv_sdate.
      lv_sdate = gv_py_dt1.
      while lv_sdate <= gv_py_dt2.
        select * from zrpqv appending table gt_zrpqv_py
          for all entries in gt_prdgrp
          where zmonth = lv_sdate+4(2)
          and zyear = lv_sdate+0(4)
          and matnr = gt_prdgrp-prd_code.

        call function 'RE_ADD_MONTH_TO_DATE'
          exporting
            months  = '1'
            olddate = lv_sdate
          importing
            newdate = lv_sdate.

      endwhile.
    endif.

    clear gt_target[].
    select * from ysd_dist_targt into table gt_target
      where trgyear = lv_trgt_yr.
  endif.
  if p_prod = 'X'.
***** get sales current date - product-wise
    clear gt_zrpqv[].
    clear lv_sdate.
    lv_sdate = s_date-low.
    while lv_sdate <= s_date-high.
      select * from zrpqv appending table gt_zrpqv
        where zmonth = lv_sdate+4(2)
        and zyear = lv_sdate+0(4)
       and matnr in s_mat.

      call function 'RE_ADD_MONTH_TO_DATE'
        exporting
          months  = '1'
          olddate = lv_sdate
        importing
          newdate = lv_sdate.

    endwhile.
***** get sales previous year dates - product-wise
    clear gt_zrpqv_py[].
    clear lv_sdate.
    lv_sdate = gv_py_dt1.
    while lv_sdate <= gv_py_dt2.
      select * from zrpqv appending table gt_zrpqv_py
        where zmonth = lv_sdate+4(2)
        and zyear = lv_sdate+0(4)
        and matnr in s_mat.

      call function 'RE_ADD_MONTH_TO_DATE'
        exporting
          months  = '1'
          olddate = lv_sdate
        importing
          newdate = lv_sdate.

    endwhile.
  endif.


  if gt_zrpqv[] is not initial.
    clear gt_zrpqv_add[].
    loop at gt_zrpqv into gw_zrpqv.
      gw_zrpqv_add-bzirk = gw_zrpqv-bzirk.
      gw_zrpqv_add-grosspts = gw_zrpqv-grosspts .
      gw_zrpqv_add-grossqty = gw_zrpqv-grossqty .
      gw_zrpqv_add-rval = gw_zrpqv-rval.
      gw_zrpqv_add-rqty = gw_zrpqv-rqty.
      gw_zrpqv_add-nepval = gw_zrpqv-nepval.
      gw_zrpqv_add-nepqty = gw_zrpqv-nepqty.
      collect gw_zrpqv_add into gt_zrpqv_add.
      clear  gw_zrpqv_add.
    endloop.
  endif.
  clear gt_zrpqv_py_add[].
  loop at gt_zrpqv_py into gw_zrpqv_py.
    gw_zrpqv_py_add-bzirk = gw_zrpqv_py-bzirk.
    gw_zrpqv_py_add-grosspts = gw_zrpqv_py-grosspts .
    gw_zrpqv_py_add-grossqty = gw_zrpqv_py-grossqty .
    gw_zrpqv_py_add-rval = gw_zrpqv_py-rval.
    gw_zrpqv_py_add-rqty = gw_zrpqv_py-rqty.
    gw_zrpqv_py_add-nepval = gw_zrpqv_py-nepval.
    gw_zrpqv_py_add-nepqty = gw_zrpqv_py-nepqty.
    collect gw_zrpqv_py_add into gt_zrpqv_py_add.
    clear  gw_zrpqv_py_add.
  endloop.

  if gt_zrpqv_add[] is not initial.
    clear gt_pso_sale[].
    loop at gt_zrpqv_add into gw_zrpqv_add.
      gw_pso_sale-bzirk = gw_zrpqv_add-bzirk.
      gw_pso_sale-sales = gw_zrpqv_add-grosspts .
      gw_pso_sale-qty = gw_zrpqv_add-grossqty .
      collect gw_pso_sale into gt_pso_sale.
      clear  gw_pso_sale.
    endloop.
  endif.
  if gt_zrpqv_py_add[] is not initial.
    loop at gt_zrpqv_py_add into gw_zrpqv_py_add.
      gw_pso_sale-bzirk = gw_zrpqv_py_add-bzirk.
      gw_pso_sale-psales = gw_zrpqv_py_add-grosspts .
      gw_pso_sale-pqty = gw_zrpqv_py_add-grossqty .
      collect gw_pso_sale into gt_pso_sale.
      clear  gw_pso_sale.
    endloop.
  endif.

***** PSO-wise data
  if gt_pso_sale[] is not initial.
    clear gt_fdata[].
    loop at gt_rm into gw_rm.       "LOOP - added 01.09.2023 to correct/add missing data...shr
      gw_fdata-bzirk = gw_rm-bzirk.
*****    loop at gt_pso_sale into gw_pso_sale.
*****      gw_fdata-bzirk = gw_pso_sale-bzirk.
      read table gt_pso_sale into gw_pso_sale with key bzirk = gw_rm-bzirk.
      if sy-subrc = 0.

        gw_fdata-sales = gw_pso_sale-sales.
        gw_fdata-qty = gw_pso_sale-qty.
        gw_fdata-psales = gw_pso_sale-psales.
        gw_fdata-pqty = gw_pso_sale-pqty.
        gw_fdata-avgsales = gw_pso_sale-sales / lv_month_cnt.
        gw_fdata-avgqty = gw_pso_sale-qty / lv_month_cnt.

**** growth value
        if gw_fdata-psales ne 0 .
          gw_fdata-grth = ( gw_fdata-sales - gw_fdata-psales ) /  gw_fdata-psales * 100.
        else.
          gw_fdata-grth = 100 .
        endif.

***** growth Qty.
        if gw_fdata-pqty ne 0 .
          gw_fdata-grth_p = ( gw_fdata-qty - gw_fdata-pqty ) /  gw_fdata-pqty * 100.
        else.
          gw_fdata-grth_p = 100 .
        endif.
      endif.
*****      read table gt_yterr into gw_yterr with key bzirk = gw_pso_sale-bzirk.
      read table gt_yterr into gw_yterr with key bzirk = gw_rm-bzirk.
      if sy-subrc = 0.
        case gw_yterr-spart.
          when '50'.
            clear lw_yterr.
            read table gt_yterr into lw_yterr with key bzirk = gw_rm-bzirk spart = '60'.
            if sy-subrc = 0.
              gw_fdata-div = 'BCL'.
            else.
              gw_fdata-div = 'BC'.
            endif.
          when '60'.
            clear lw_yterr.
            read table gt_yterr into lw_yterr with key bzirk = gw_rm-bzirk spart = '50'.
            if sy-subrc = 0.
              gw_fdata-div = 'BCL'.
            else.
              gw_fdata-div = 'XL'.
            endif.
          when '70'.
            gw_fdata-div = 'BCLS'.
        endcase.
        read table gt_0001 into gw_0001 with key plans  =  gw_yterr-plans .
        if sy-subrc = 0.
          gw_fdata-pernr = gw_0001-pernr01.
          gw_fdata-ename = gw_0001-ename.
          gw_fdata-doj = gw_0001-dtjoin.

**** designation
          select single mc_short from hrp1000 into gw_fdata-des
            where plvar = '01'
            and otype  = 'S'
            and objid =  gw_yterr-plans
            and endda eq '99991231'
            and langu = sy-langu.

          gw_fdata-zz_hqcode = gw_0001-zz_hqcode.
          read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_0001-zz_hqcode.
          if sy-subrc = 0.
            gw_fdata-zz_hqdesc = gw_hq_des-zz_hqdesc.
          endif.
        else.
          gw_fdata-ename = 'VACANT'.
          clear lw_zdrphq.
          select single * from zdrphq into lw_zdrphq where bzirk eq gw_rm-bzirk.
          if sy-subrc = 0.
            read table gt_hq_des into gw_hq_des with key zz_hqcode = lw_zdrphq-zz_hqcode.
            if sy-subrc = 0.
              gw_fdata-zz_hqdesc = gw_hq_des-zz_hqdesc.
            endif.
          endif.
*****          gw_fdata-zz_hqdesc = gw_yterr-bztxt.
        endif.
      endif.
***** get zm/rm of pso's
      read table gt_rm into lw_rm with key bzirk =  gw_fdata-bzirk.
      if sy-subrc = 0.
        gw_fdata-zrsm = lw_rm-zdsm.
        read table gt_zm into gw_zm with key bzirk = lw_rm-zdsm.
        if sy-subrc = 0.
          gw_fdata-zdsm = gw_zm-zdsm.
        endif.
      endif.

**** zm name
      read table gt_yterr into gw_yterr with key bzirk = gw_fdata-zdsm.
      if sy-subrc = 0.
        read table gt_0001 into gw_0001 with key plans  =  gw_yterr-plans .
        if sy-subrc = 0.
          gw_fdata-zmname = gw_0001-ename.
        else.
          gw_fdata-zmname =  'VACANT'.
        endif.
      endif.

****  rm name
      read table gt_yterr into gw_yterr with key bzirk = gw_fdata-zrsm.
      if sy-subrc = 0.
        read table gt_0001 into gw_0001 with key plans  =  gw_yterr-plans .
        if sy-subrc = 0.
          gw_fdata-rmname = gw_0001-ename.
        else.
          gw_fdata-rmname =  'VACANT'.
        endif.
      endif.
      if gw_fdata-bzirk+0(2) <> 'R-'.  "IF - added 01.09.2023 to correct/add missing data...shr
        append gw_fdata to gt_fdata.
      endif.
      clear gw_fdata.
    endloop.
*****    endloop.
  endif.


**** check if division is selected at input.
  if gt_fdata[] is not initial.

*********   delete blank zone data
    sort  gt_fdata by zdsm zrsm.
    delete gt_fdata where zdsm is initial.
    delete gt_fdata where zrsm is initial.
******    delete gt_fdata WHERE PSALES is INITIAL AND pqty is INITIAL.
******    delete gt_fdata WHERE AVGSALES is INITIAL AND AVGQTY is INITIAL.

**********  Filter data as per division selection at input
    sort gt_fdata by div.
    clear gt_fdata_tmp[].
    if cb_bc = 'X'.
      loop at gt_fdata into gw_fdata where div = 'BC'.
        append gw_fdata to gt_fdata_tmp.
        clear gw_fdata.
      endloop.
    endif.
    if cb_xl = 'X'.
      loop at gt_fdata into gw_fdata where div = 'XL'.
        append gw_fdata to gt_fdata_tmp.
        clear gw_fdata.
      endloop.
    endif.
    if cb_bcl = 'X'.
      loop at gt_fdata into gw_fdata where div = 'BCL'.
        append  gw_fdata to gt_fdata_tmp.
        clear gw_fdata.
      endloop.
    endif.

    if cb_ls = 'X'.
      loop at gt_fdata into gw_fdata where div = 'BCLS'.
        append  gw_fdata to gt_fdata_tmp.
        clear gw_fdata.
      endloop.
    endif.
**** for zone-wise as per input zone
    if p_zone is not initial.
      clear gt_fdata_tmp1[].
      loop at gt_fdata_tmp into gw_fdata_tmp where zdsm = p_zone.
        append  gw_fdata_tmp to gt_fdata_tmp1.
        clear gw_fdata.
      endloop.

      sort gt_fdata_tmp1[] by zdsm zrsm bzirk.
      delete adjacent duplicates from gt_fdata_tmp1[] comparing zdsm zrsm bzirk.
    else.  "....if no zone is entered at input
      clear gt_fdata_tmp1[].
      gt_fdata_tmp1[] = gt_fdata_tmp[].

      sort gt_fdata_tmp1[] by zdsm zrsm bzirk.
      delete adjacent duplicates from gt_fdata_tmp1[] comparing zdsm zrsm bzirk.
    endif.

***** get final data into GT_FINAL[] - for display
    clear gt_fdata[].
    gt_fdata[] = gt_fdata_tmp1[].

****** update sr.no
    if gt_fdata[] is not initial.

***** mtpt
      if gt_fdata[] is not initial and p_group = 'X' and p_rad1 = 'X'.
        loop at gt_fdata into gw_fdata .
*****  target
          clear lv_trgt_val.
          read table gt_target into gw_target with key bzirk = gw_fdata-bzirk.
          if sy-subrc = 0.
*****            lv_date = s_date-low.
*****            lv_mnth = s_date-low+4(2).
*****            while lv_date <= s_date-high.
*****              if lv_mnth = 4.
*****                lv_trgt_val = lv_trgt_val + gw_target-month01.
*****              elseif lv_mnth = 5.
*****                lv_trgt_val = lv_trgt_val + gw_target-month02.
*****              elseif lv_mnth = 6.
*****                lv_trgt_val = lv_trgt_val + gw_target-month03.
*****              elseif lv_mnth = 7.
*****                lv_trgt_val = lv_trgt_val + gw_target-month04.
*****              elseif lv_mnth = 8.
*****                lv_trgt_val = lv_trgt_val + gw_target-month05.
*****              elseif lv_mnth = 9.
*****                lv_trgt_val = lv_trgt_val + gw_target-month06.
*****              elseif lv_mnth = 10.
*****                lv_trgt_val = lv_trgt_val + gw_target-month07.
*****              elseif lv_mnth = 11.
*****                lv_trgt_val = lv_trgt_val + gw_target-month08.
*****              elseif lv_mnth = 12.
*****                lv_trgt_val = lv_trgt_val + gw_target-month09.
*****              elseif lv_mnth = 1.
*****                lv_trgt_val = lv_trgt_val + gw_target-month10.
*****              elseif lv_mnth = 2.
*****                lv_trgt_val = lv_trgt_val + gw_target-month11.
*****              elseif lv_mnth = 3.
*****                lv_trgt_val = lv_trgt_val + gw_target-month12.
*****              endif.
*****
*****              call function 'RE_ADD_MONTH_TO_DATE'
*****                exporting
*****                  months  = '1'
*****                  olddate = lv_date
*****                importing
*****                  newdate = lv_date.
*****
*****              lv_mnth = lv_date+4(2).
*****            endwhile.
*****
*****            gw_fdata-target = lv_trgt_val.
*****            modify gt_fdata from gw_fdata transporting target.

*************************  Commented above and added below to consider month-wise MTPT based on month-wise target   ******************
            lv_mnth = s_date-high+4(2).
            case lv_mnth.
              when '4'.
                gw_fdata-target = gw_target-month01.
              when '5'.
                gw_fdata-target = gw_target-month02.
              when '6'.
                gw_fdata-target = gw_target-month03.
              when '7'.
                gw_fdata-target = gw_target-month04.
              when '8'.
                gw_fdata-target = gw_target-month05.
              when '9'.
                gw_fdata-target = gw_target-month06.
              when '10'.
                gw_fdata-target = gw_target-month07.
              when '11'.
                gw_fdata-target = gw_target-month08.
              when '12'.
                gw_fdata-target = gw_target-month09.
              when '1'.
                gw_fdata-target = gw_target-month10.
              when '2'.
                gw_fdata-target = gw_target-month11.
              when '3'.
                gw_fdata-target = gw_target-month12.
            endcase.

            modify gt_fdata from gw_fdata transporting target.
            clear gw_fdata.
          endif.
        endloop.

        loop at gt_fdata into gw_fdata.
          if gw_fdata-target > 0.
            if s_grp[] is not initial.
              clear lw_mtpt.
              select single * from zmtpt into lw_mtpt
                where matkl in s_grp
                and  zmtpt~begda le s_date-high and zmtpt~endda ge s_date-high
                and from_amt le gw_fdata-target and to_amt ge gw_fdata-target.
            else.
              clear lw_mtpt.
              select single * from zmtpt into lw_mtpt
                where zmtpt~begda le s_date-high and zmtpt~endda ge s_date-high
                and from_amt le gw_fdata-target and to_amt ge gw_fdata-target.
            endif.
            if sy-subrc = 0.
*****              gw_fdata-mtpt = lw_mtpt-target * lv_month_cnt.
*************************  Commented above and added below to consider month-wise MTPT based on month-wise target   ******************
              gw_fdata-mtpt = lw_mtpt-target.
              modify gt_fdata index sy-tabix from gw_fdata transporting mtpt.
            endif.
          endif.
        endloop.
      endif.

**** for Qty.wise ranking
      if p_qty = 'X'.
        sort  gt_fdata by qty descending.
      endif.
**** for Val.wise ranking
      if p_val = 'X'.
        sort  gt_fdata by sales descending.
      endif.

***** Update ranking/sr.no as per selected criteria
      clear lv_srno.
      lv_srno = 1.
      loop at gt_fdata into gw_fdata.
        gw_fdata-srno = lv_srno.    "get rank
        lv_srno = lv_srno + 1.
        modify gt_fdata from gw_fdata transporting srno.
        clear gw_fdata.
      endloop.
***** check if max.top count is entered.
      if p_cnt is not initial.
        sort gt_fdata by srno.
        delete gt_fdata where srno > p_cnt.
      endif.
    else.
      message 'No data found.' type 'I'.

    endif.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  BUILD_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form build_fcat .
  data lv_pos type i.

  clear gt_fcat[].

  lv_pos = 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'SRNO'.
  gw_fcat-seltext_l = 'RANK'.
  gw_fcat-col_pos = lv_pos.
  gw_fcat-outputlen = '5'.
  gw_fcat-key = 'X'.
  append gw_fcat to gt_fcat.

*****  lv_pos = lv_pos + 1.
*****  clear gw_fcat.
*****  gw_fcat-fieldname = 'PRNAME'.
*****  gw_fcat-seltext_l = 'PR.NAME'.
*****  gw_fcat-col_pos = lv_pos.
*****  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'ZDSM'.
  gw_fcat-seltext_l = 'ZDSM'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'ZMNAME'.
  gw_fcat-seltext_l = 'ZM NAME'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'ZRSM'.
  gw_fcat-seltext_l = 'ZRSM'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  if p_pso = 'X'.
    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'RMNAME'.
    gw_fcat-seltext_l = 'RM NAME'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.
  endif.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'PERNR'.
  gw_fcat-seltext_l = 'EMP.CODE'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'ENAME'.
  gw_fcat-seltext_l = 'EMP.NAME'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  if p_pso = 'X'.
    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'BZIRK'.
    gw_fcat-seltext_l = 'TERR.'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.
  endif.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'DIV'.
  gw_fcat-seltext_l = 'DIVISION'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'DES'.
  gw_fcat-seltext_l = 'DESIGNATION'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'DOJ'.
  gw_fcat-seltext_l = 'DT.OF.JOINING'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'ZZ_HQDESC'.
  gw_fcat-seltext_l = 'HQ'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'SALES'.
  gw_fcat-seltext_l = 'SALES'.
  gw_fcat-col_pos = lv_pos.
  gw_fcat-key = 'X'.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'AVGSALES'.
  gw_fcat-seltext_l = 'AVG.SALES'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'QTY'.
  gw_fcat-seltext_l = 'QTY'.
  gw_fcat-col_pos = lv_pos.
  gw_fcat-key = 'X'.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'AVGQTY'.
  gw_fcat-seltext_l = 'AVG.QTY'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'PQTY'.
  gw_fcat-seltext_l = 'PREV.YR.QTY'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'PSALES'.
  gw_fcat-seltext_l = 'PREV.YR.SALES'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'GRTH'.
  gw_fcat-seltext_l = 'VALUE GRTH'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'GRTH_P'.
  gw_fcat-seltext_l = 'QTY.GRTH'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  if p_rm = 'X'.
    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'TOTPSO'.
    gw_fcat-seltext_l = 'NO.OF.PSOs'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'YPM'.
    gw_fcat-seltext_l = 'YPM'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.
  endif.
  if p_group = 'X'.
    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'MTPT'.
    gw_fcat-seltext_l = 'MTPT'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form display_alv .

  data : lv_gtitle  type lvc_title,
         lt_tp      type sorted table of textpool with unique key id key,
         lw_tp      type textpool,
         lv_dt_str  type string,
         lv_dt_str1 type string.


  read textpool sy-repid : into lt_tp language sy-langu.

  clear gv_rep_hdr.
  if p_prod = 'X'.
    read table lt_tp into lw_tp with key key = 'P_PROD'.
    if sy-subrc = 0.
      condense lw_tp-entry.
      gv_rep_hdr = lw_tp-entry.
    endif.
  elseif p_group = 'X'.
    read table lt_tp into lw_tp with key key = 'P_GROUP'.
    if sy-subrc = 0.
      condense lw_tp-entry.
      gv_rep_hdr = lw_tp-entry.
    endif.
  else.
*****    READ TABLE lt_tp INTO lw_tp WITH KEY key = 'P_VALUE'.
*****    IF sy-subrc = 0.
*****      CONDENSE lw_tp-entry.
*****      gv_rep_hdr = lw_tp-entry.
*****    ENDIF.
  endif.

  if p_pso = 'X'.
    read table lt_tp into lw_tp with key key = 'P_PSO'.
    if sy-subrc = 0.
      condense lw_tp-entry.
      concatenate gv_rep_hdr 'TOP' lw_tp-entry into gv_rep_hdr separated by space.
    endif.
  elseif p_rm = 'X'.
    read table lt_tp into lw_tp with key key = 'P_RM'.
    if sy-subrc = 0.
      condense lw_tp-entry.
      concatenate gv_rep_hdr 'TOP' lw_tp-entry into gv_rep_hdr separated by space.
    endif.
  else.
    read table lt_tp into lw_tp with key key = 'P_ZM'.
    if sy-subrc = 0.
      condense lw_tp-entry.
      concatenate gv_rep_hdr 'TOP' lw_tp-entry into gv_rep_hdr separated by space.
    endif.
  endif.


  if p_qty = 'X'.    "**** for qty.
*****    READ TABLE lt_tp INTO lw_tp WITH KEY key = 'P_QTY'.
*****    IF sy-subrc = 0.
*****      CONDENSE lw_tp-entry.
    concatenate gv_rep_hdr '(UNITS WISE)' into gv_rep_hdr separated by space.
*****    ENDIF.
  elseif p_val = 'X'.     "**** for val
*****    read table lt_tp into lw_tp with key key = 'P_VAL'.
*****    if sy-subrc = 0.
*****      condense lw_tp-entry.
*****      translate lw_tp-entry to upper case.
    concatenate gv_rep_hdr '(VALUE WISE)' into gv_rep_hdr separated by space.
*****    endif.
  elseif p_per = 'X'.       "**** for target %
*****    read table lt_tp into lw_tp with key key = 'P_PER'.
*****    if sy-subrc = 0.
*****      condense lw_tp-entry.
*****      translate lw_tp-entry to upper case.
    concatenate gv_rep_hdr '(PERCENTAGE WISE)' into gv_rep_hdr separated by space.
*****    endif.
  else.             "**** for sale
*****    READ TABLE lt_tp INTO lw_tp WITH KEY key = 'P_SALE'.
*****    IF sy-subrc = 0.
*****      CONDENSE lw_tp-entry.
    concatenate gv_rep_hdr '(RUPEE WISE)' into gv_rep_hdr separated by space.
*****    ENDIF.
  endif.

  clear lv_dt_str.
  concatenate s_date-low+6(2) s_date-low+4(2) s_date-low+0(4) into lv_dt_str separated by '.'.
  clear lv_dt_str1.
  concatenate s_date-high+6(2) s_date-high+4(2) s_date-high+0(4) into lv_dt_str1 separated by '.'.

  concatenate gv_rep_hdr '-' lv_dt_str into gv_rep_hdr separated by space.
  concatenate gv_rep_hdr 'TO' lv_dt_str1 into gv_rep_hdr separated by space.

  lv_gtitle = gv_rep_hdr.

  gw_layout-zebra = 'X'.
  gw_layout-colwidth_optimize = 'X'.

  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
      i_callback_program = sy-repid
****      I_CALLBACK_USER_COMMAND = 'USER_COMMAND'
*****      i_callback_top_of_page = 'TOP_OF_PAGE'
      i_grid_title       = lv_gtitle
      is_layout          = gw_layout
      it_fieldcat        = gt_fcat[]
*     I_DEFAULT          = 'X'
      i_save             = 'A'
    tables
      t_outtab           = gt_fdata[]
    exceptions
      program_error      = 1
      others             = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  GET_PSO_VALUE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form get_pso_value_data .

  data : lv_trgt_yr  type i,
         lv_srno     type i,
         lw_yterr    type ty_yterr,
         lw_zdrphq   type zdrphq,
         lw_pso1     type zdsmter,
         lv_date     type sy-datum,
         lv_sdate    type sy-datum,
         lv_mnth     type i,
         lv_trgt_val type p.

**** get prev.year dates from entered s_date
  clear  gv_py_dt1.
  call function 'RP_CALC_DATE_IN_INTERVAL'
    exporting
      date      = s_date-low
      days      = 0
      months    = 0
      signum    = '-'
      years     = 1
    importing
      calc_date = gv_py_dt1.

  clear gv_py_dt2.
  call function 'RP_CALC_DATE_IN_INTERVAL'
    exporting
      date      = s_date-high
      days      = 0
      months    = 0
      signum    = '-'
      years     = 1
    importing
      calc_date = gv_py_dt2.

  clear lv_trgt_yr.
  if s_date-high+4(2) < 4.
    lv_trgt_yr = s_date-high+0(4) - 1.
  else.
    lv_trgt_yr = s_date-low+0(4).
  endif.

  clear :gt_zdsmter[].
  select * from zdsmter into table gt_zdsmter
    where zmonth eq p_adate+4(2)"s_date-high+4(2)
    and zyear eq p_adate+0(4)."s_date-high+0(4).

  if gt_zdsmter[] is not initial.

    sort gt_zdsmter[] by zdsm.
****  get PSOs
    clear gt_pso[].
    gt_pso[] = gt_zdsmter[].
    sort  gt_pso by bzirk.
    delete  gt_pso where bzirk+0(2) = 'D-' or bzirk+0(2) = 'Z-' or bzirk+0(2) = 'G-' or bzirk+0(2) = 'R-'.
    sort gt_pso by bzirk.
    delete adjacent duplicates from gt_pso comparing bzirk.

    clear gt_pso1[].
    gt_pso1[] = gt_zdsmter[].
    sort  gt_pso1 by bzirk.
    delete  gt_pso1 where bzirk+0(2) = 'D-' or bzirk+0(2) = 'Z-' or bzirk+0(2) = 'G-' or bzirk+0(2) = 'R-'.


**** get ZMs
    clear gt_zm[].
    gt_zm[] = gt_zdsmter[].
    delete gt_zm where zdsm+0(2) = 'R-'.
    sort gt_zm by zdsm bzirk.
    delete adjacent duplicates from gt_zm comparing zdsm bzirk.
**** get RMs
    clear gt_rm[].
    gt_rm[] = gt_zdsmter[].
    delete gt_rm where zdsm+0(2) = 'D-'.
    sort gt_rm by zdsm bzirk.
    delete adjacent duplicates from gt_rm comparing zdsm bzirk.

    clear gt_yterr[].
    select a~spart a~bzirk a~endda a~begda a~plans
           b~bztxt into table gt_yterr
      from yterrallc as a inner join t171t as b
      on a~bzirk = b~bzirk
      where a~endda = '99991231'
      and b~spras = sy-langu.

    clear gt_0001[].
    select a~pernr a~begda
           b~pernr b~begda b~endda b~abkrs b~ansvh b~persk b~plans b~ename b~zz_hqcode into table gt_0001
      from pa0000 as a inner join pa0001 as b
      on a~pernr = b~pernr
      where a~massn = '01'
      and b~endda eq '99991231'.

***** HQ des
    clear gt_hq_des[].
    select * from zthr_heq_des into table gt_hq_des.
  endif.

  clear: gt_zrcumpso[], gt_pso_sale[].
  clear lv_sdate.
  lv_sdate = s_date-low.
  while lv_sdate <= s_date-high.
*****    select * from zrcumpso appending table gt_zrcumpso
    select * from zcumpso appending table gt_zrcumpso
      where zyear = lv_sdate+0(4)
      and zmonth = lv_sdate+4(2).

    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = lv_sdate
      importing
        newdate = lv_sdate.
  endwhile.

  if gt_zrcumpso[] is not initial.
    clear gt_zrcumpso_add[].
    loop at gt_zrcumpso into gw_zrcumpso.
      gw_zrcumpso_add-bzirk = gw_zrcumpso-bzirk.
      gw_zrcumpso_add-netval = gw_zrcumpso-netval.
      collect gw_zrcumpso_add into gt_zrcumpso_add.
      clear gw_zrcumpso_add.
    endloop.

    loop at gt_zrcumpso_add into gw_zrcumpso_add.
      gw_pso_sale-bzirk = gw_zrcumpso_add-bzirk.
      gw_pso_sale-sales = gw_zrcumpso_add-netval .
      collect gw_pso_sale into gt_pso_sale.
      clear  gw_pso_sale.
    endloop.
  endif.

  clear gt_zrcumpso_py[].
  clear lv_sdate.
  lv_sdate = gv_py_dt1.
  while lv_sdate <= gv_py_dt2.
    select * from zrcumpso appending table gt_zrcumpso_py
    where zyear = lv_sdate+0(4)
    and zmonth = lv_sdate+4(2) .

    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = lv_sdate
      importing
        newdate = lv_sdate.
  endwhile.
  if gt_zrcumpso_py[] is   not initial.
    clear gt_zrcumpso_py_add[].
    loop at gt_zrcumpso_py into gw_zrcumpso_py.
      gw_zrcumpso_py_add-bzirk = gw_zrcumpso_py-bzirk.
      gw_zrcumpso_py_add-netval = gw_zrcumpso_py-netval.
      collect gw_zrcumpso_py_add into gt_zrcumpso_py_add.
      clear gw_zrcumpso_py_add.
    endloop.

    loop at gt_zrcumpso_py_add into gw_zrcumpso_py_add.
      gw_pso_sale-bzirk = gw_zrcumpso_py_add-bzirk.
      gw_pso_sale-psales = gw_zrcumpso_py_add-netval .
      collect gw_pso_sale into gt_pso_sale.
      clear  gw_pso_sale.
    endloop.
  endif.

  clear gt_target[].
  select * from ysd_dist_targt into table gt_target
    where trgyear = lv_trgt_yr.

  if gt_pso[] is not initial.
    clear gt_vfdata[].

    loop at gt_pso into gw_pso.

      gw_vfdata-bzirk = gw_pso-bzirk.
      read table gt_pso_sale into gw_pso_sale with key bzirk = gw_pso-bzirk.
      if sy-subrc = 0.
        gw_vfdata-sales = gw_pso_sale-sales.
        gw_vfdata-psales = gw_pso_sale-psales.
      endif.


      read table gt_yterr into gw_yterr with key bzirk = gw_pso-bzirk.
      if sy-subrc = 0.
        read table gt_pso1 into gw_pso1 with key bzirk = gw_pso-bzirk.
        if sy-subrc = 0.
          case gw_pso1-spart.
            when '50'.
              clear lw_pso1.
              read table gt_pso1 into lw_pso1 with key bzirk = gw_pso-bzirk spart = '60'.
              if sy-subrc = 0.
                gw_vfdata-div = 'BCL'.
              else.
                gw_vfdata-div = 'BC'.
              endif.
            when '60'.
              clear lw_pso1.
              read table gt_pso1 into lw_pso1 with key bzirk = gw_pso-bzirk spart = '50'.
              if sy-subrc = 0.
                gw_vfdata-div = 'BCL'.
              else.
                gw_vfdata-div = 'XL'.
              endif.
            when '70'.
              gw_vfdata-div = 'BCLS'.
          endcase.
        endif.
        read table gt_0001 into gw_0001 with key plans  =  gw_yterr-plans .
        if sy-subrc = 0.
          gw_vfdata-pernr = gw_0001-pernr01.
          gw_vfdata-ename = gw_0001-ename.
          gw_vfdata-doj = gw_0001-dtjoin.

**** designation
*****          select single mc_short from hrp1000 into gw_vfdata-des
*****           where plvar = '01'
*****            and otype  = 'S'
*****            and objid =  gw_yterr-plans
*****            and endda eq '99991231'
*****            and langu = sy-langu.
          if gw_0001-persk = 25.
            gw_vfdata-des =  'SZM'.
          elseif gw_0001-persk = 26.
            gw_vfdata-des =  'ZM'.
          elseif gw_0001-persk = 53.
            gw_vfdata-des =  'SE'.
          elseif gw_0001-persk = 51.
            gw_vfdata-des =  'TM'.
          elseif gw_0001-persk = 54.
            gw_vfdata-des =  'SABM'.
          elseif gw_0001-persk = 43.
            gw_vfdata-des =  'DZM'.
          elseif gw_0001-persk = 44.
            gw_vfdata-des =  'SRM'.
          elseif gw_0001-persk = 45.
            gw_vfdata-des =  'RM'.
          elseif gw_0001-persk = 50.
            gw_vfdata-des =  'ABM'.
          endif.

          gw_vfdata-zz_hqcode = gw_0001-zz_hqcode.
          read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_0001-zz_hqcode.
          if sy-subrc = 0.
            gw_vfdata-zz_hqdesc = gw_hq_des-zz_hqdesc.
          endif.
        else.
          gw_vfdata-ename = 'VACANT'.
          clear lw_zdrphq.
          select single * from zdrphq into lw_zdrphq where bzirk eq gw_pso-bzirk.
          if sy-subrc = 0.
            read table gt_hq_des into gw_hq_des with key zz_hqcode = lw_zdrphq-zz_hqcode.
            if sy-subrc = 0.
              gw_vfdata-zz_hqdesc = gw_hq_des-zz_hqdesc.
            endif.
          endif.
*****          gw_vfdata-zz_hqdesc = gw_yterr-bztxt.
        endif.
      endif.
***** get zm/rm of pso's
      read table gt_rm into gw_rm with key bzirk =  gw_vfdata-bzirk.
      if sy-subrc = 0.
        gw_vfdata-r_bzirk = gw_rm-zdsm.
        read table gt_zm into gw_zm with key bzirk = gw_rm-zdsm.
        if sy-subrc = 0.
          gw_vfdata-d_bzirk = gw_zm-zdsm.
        endif.
      endif.

**** zm name
      read table gt_yterr into gw_yterr with key bzirk = gw_vfdata-d_bzirk.
      if sy-subrc = 0.
        read table gt_0001 into gw_0001 with key plans  =  gw_yterr-plans .
        if sy-subrc = 0.
          gw_vfdata-zmname = gw_0001-ename.
        else.
          gw_vfdata-zmname =  'VACANT'.
        endif.
      endif.

****  rm name
      read table gt_yterr into gw_yterr with key bzirk = gw_vfdata-r_bzirk.
      if sy-subrc = 0.
        read table gt_0001 into gw_0001 with key plans  =  gw_yterr-plans .
        if sy-subrc = 0.
          gw_vfdata-rmname = gw_0001-ename.
        else.
          gw_vfdata-rmname =  'VACANT'.
        endif.
      endif.

*****  target
      clear lv_trgt_val.
      read table gt_target into gw_target with key bzirk = gw_vfdata-bzirk.
      if sy-subrc = 0.
        lv_date = s_date-low.
        lv_mnth = s_date-low+4(2).

        while lv_date <= s_date-high.
          if lv_mnth = 4.
            lv_trgt_val = lv_trgt_val + gw_target-month01.
          elseif lv_mnth = 5.
            lv_trgt_val = lv_trgt_val + gw_target-month02.
          elseif lv_mnth = 6.
            lv_trgt_val = lv_trgt_val + gw_target-month03.
          elseif lv_mnth = 7.
            lv_trgt_val = lv_trgt_val + gw_target-month04.
          elseif lv_mnth = 8.
            lv_trgt_val = lv_trgt_val + gw_target-month05.
          elseif lv_mnth = 9.
            lv_trgt_val = lv_trgt_val + gw_target-month06.
          elseif lv_mnth = 10.
            lv_trgt_val = lv_trgt_val + gw_target-month07.
          elseif lv_mnth = 11.
            lv_trgt_val = lv_trgt_val + gw_target-month08.
          elseif lv_mnth = 12.
            lv_trgt_val = lv_trgt_val + gw_target-month09.
          elseif lv_mnth = 1.
            lv_trgt_val = lv_trgt_val + gw_target-month10.
          elseif lv_mnth = 2.
            lv_trgt_val = lv_trgt_val + gw_target-month11.
          elseif lv_mnth = 3.
            lv_trgt_val = lv_trgt_val + gw_target-month12.
          endif.

          call function 'RE_ADD_MONTH_TO_DATE'
            exporting
              months  = '1'
              olddate = lv_date
            importing
              newdate = lv_date.

          lv_mnth = lv_date+4(2).
        endwhile.


        gw_vfdata-target = lv_trgt_val.

        if lv_trgt_val is not initial.
          gw_vfdata-pertgt = gw_vfdata-sales / lv_trgt_val * 100.
        else.
          gw_vfdata-pertgt = 0.
        endif.

        if gw_vfdata-psales ne 0 .
          gw_vfdata-grth = ( gw_vfdata-sales - gw_vfdata-psales ) /  gw_vfdata-psales * 100.
        else.
          gw_vfdata-grth = 100 .
        endif.

        append gw_vfdata to gt_vfdata.
        clear gw_vfdata.
      endif.
    endloop.
  endif.

  if gt_vfdata[] is not initial.
    sort gt_vfdata by div.
**** check if division is selected at input.
    clear gt_vfdata_tmp[].
    if cb_bc = 'X'.
      loop at gt_vfdata into gw_vfdata where div = 'BC'.
        append gw_vfdata to gt_vfdata_tmp.
        clear gw_vfdata.
      endloop.
    endif.
    if cb_xl = 'X'.
      loop at gt_vfdata into gw_vfdata where div = 'XL'.
        append gw_vfdata to gt_vfdata_tmp.
        clear gw_vfdata.
      endloop.
    endif.
    if cb_bcl = 'X'.
      loop at gt_vfdata into gw_vfdata where div = 'BCL'.
        append  gw_vfdata to gt_vfdata_tmp.
        clear gw_vfdata.
      endloop.
    endif.

    if cb_ls = 'X'.
      loop at gt_vfdata into gw_vfdata where div = 'BCLS'.
        append  gw_vfdata to gt_vfdata_tmp.
        clear gw_vfdata.
      endloop.
    endif.

    if gt_vfdata_tmp[] is not initial.
*******  if for bulletin then delete vacant and %tgt >=100
      if p_rad4 = abap_true.
        sort gt_vfdata_tmp[] by pernr.
        delete gt_vfdata_tmp[] where pernr = '00000000'.
        if p_per = abap_true.
          sort gt_vfdata_tmp[] by pertgt.
          delete gt_vfdata_tmp[] where pertgt < 100.
        endif.
      endif.
      clear gt_vfdata[].
      gt_vfdata[] = gt_vfdata_tmp[].
    else.
*******  if for bulletin then delete vacant and %tgt < 100
      if gt_vfdata[] is not initial.
        if p_rad4 = abap_true.
          sort gt_vfdata[] by pernr.
          delete gt_vfdata[] where pernr = '00000000'.
          if p_per = abap_true.
            sort gt_vfdata[] by pertgt.
            delete gt_vfdata[] where pertgt < 100.
          endif.
        endif.
      endif.
    endif.


    if gt_vfdata[] is not initial.
**** for target % wise ranking
      if p_per = abap_true.
        sort  gt_vfdata by pertgt descending.
      endif.
**** for sale wise ranking
      if p_sale = abap_true.
        sort  gt_vfdata by sales descending.
      endif.
      clear lv_srno.
      lv_srno = 1.
      loop at gt_vfdata into gw_vfdata.
***** Update ranking/sr.no as per selected criteria
        gw_vfdata-srno = lv_srno.
        lv_srno = lv_srno + 1.
        modify gt_vfdata from gw_vfdata transporting srno.
        clear gw_vfdata.
      endloop.
***** check if max.top count is entered.
      if p_cnt is not initial.
        sort gt_vfdata by srno.
        delete gt_vfdata where srno > p_cnt.
      endif.
    else.
      message 'No data found.' type 'I'.
    endif.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  BUILD_FCAT_VAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form build_fcat_val .
  data lv_pos type i.

  clear gt_fcat[].

  lv_pos = 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'SRNO'.
  gw_fcat-seltext_l = 'RANK'.
  gw_fcat-col_pos = lv_pos.
  gw_fcat-outputlen = '5'.
  gw_fcat-key = 'X'.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  gw_fcat-fieldname = 'PERNR'.
  gw_fcat-seltext_l = 'EMP.CODE'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'BZIRK'.
  if p_pso = 'X'.
    gw_fcat-seltext_l = 'TERR.'.
  endif.
  if p_rm = 'X'.
    gw_fcat-seltext_l = 'REGION'.
  endif.
  if p_zm = 'X'.
    gw_fcat-seltext_l = 'ZONE'.
  endif.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'ENAME'.
  gw_fcat-seltext_l = 'EMP.NAME'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.


  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'ZZ_HQDESC'.
  gw_fcat-seltext_l = 'HQ'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'DIV'.
  gw_fcat-seltext_l = 'DIVISION'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'DES'.
  gw_fcat-seltext_l = 'DESIGNATION'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'DOJ'.
  gw_fcat-seltext_l = 'DT.OF.JOINING'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'SALES'.
  gw_fcat-seltext_l = 'SALES'.
  gw_fcat-col_pos = lv_pos.
  gw_fcat-key = 'X'.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'TARGET'.
  gw_fcat-seltext_l = 'TARGET'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'PERTGT'.
  gw_fcat-seltext_l = 'PER. TO TGT'.
  gw_fcat-col_pos = lv_pos.
  gw_fcat-key = 'X'.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'PSALES'.
  gw_fcat-seltext_l = 'PREV.YR.SALES'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'GRTH'.
  gw_fcat-seltext_l = 'VALUE GRTH'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  if p_rm = 'X' or p_zm = 'X'.
    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'TOTPSO'.
    gw_fcat-seltext_l = 'NO.OF.PSOs'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'YPM'.
    gw_fcat-seltext_l = 'PRODUCTIVITY'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.
  endif.

  if p_pso = 'X'.
    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'R_BZIRK'.
    gw_fcat-seltext_l = 'RM TERR.'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'RMNAME'.
    gw_fcat-seltext_l = 'RM NAME'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.
  endif.

  if p_pso = 'X' or p_rm = 'X'.
    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'D_BZIRK'.
    gw_fcat-seltext_l = 'ZM TERR.'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.


    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'ZMNAME'.
    gw_fcat-seltext_l = 'ZM NAME'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.
  endif.

endform.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV_VAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form display_alv_val .

  data : lv_gtitle  type lvc_title,
         lt_tp      type sorted table of textpool with unique key id key,
         lw_tp      type textpool,
         lv_dt_str  type string,
         lv_dt_str1 type string.


  read textpool sy-repid : into lt_tp language sy-langu.

  clear gv_rep_hdr.
  if p_prod = 'X'.
    read table lt_tp into lw_tp with key key = 'P_PROD'.
    if sy-subrc = 0.
      condense lw_tp-entry.
      gv_rep_hdr = lw_tp-entry.
    endif.
  elseif p_group = 'X'.
    read table lt_tp into lw_tp with key key = 'P_GROUP'.
    if sy-subrc = 0.
      condense lw_tp-entry.
      gv_rep_hdr = lw_tp-entry.
    endif.
  else.
*****    READ TABLE lt_tp INTO lw_tp WITH KEY key = 'P_VALUE'.
*****    IF sy-subrc = 0.
*****      CONDENSE lw_tp-entry.
*****      gv_rep_hdr = lw_tp-entry.
*****    ENDIF.
  endif.

  if p_pso = 'X'.
    read table lt_tp into lw_tp with key key = 'P_PSO'.
    if sy-subrc = 0.
      condense lw_tp-entry.
      concatenate gv_rep_hdr 'TOP' lw_tp-entry into gv_rep_hdr separated by space.
    endif.
  elseif p_rm = 'X'.
    read table lt_tp into lw_tp with key key = 'P_RM'.
    if sy-subrc = 0.
      condense lw_tp-entry.
      concatenate gv_rep_hdr 'TOP' lw_tp-entry into gv_rep_hdr separated by space.
    endif.
  else.
    read table lt_tp into lw_tp with key key = 'P_ZM'.
    if sy-subrc = 0.
      condense lw_tp-entry.
      concatenate gv_rep_hdr 'TOP' lw_tp-entry into gv_rep_hdr separated by space.
    endif.
  endif.


  if p_qty = 'X'.    "**** for qty.
*****    READ TABLE lt_tp INTO lw_tp WITH KEY key = 'P_QTY'.
*****    IF sy-subrc = 0.
*****      CONDENSE lw_tp-entry.
    concatenate gv_rep_hdr '(UNITS WISE)' into gv_rep_hdr separated by space.
*****    ENDIF.
  elseif p_val = 'X'.     "**** for val
*****    read table lt_tp into lw_tp with key key = 'P_VAL'.
*****    if sy-subrc = 0.
*****      condense lw_tp-entry.
*****      translate lw_tp-entry to upper case.
    concatenate gv_rep_hdr '(VALUE WISE)' into gv_rep_hdr separated by space.
*****    endif.
  elseif p_per = 'X'.       "**** for target %
*****    read table lt_tp into lw_tp with key key = 'P_PER'.
*****    if sy-subrc = 0.
*****      condense lw_tp-entry.
*****      translate lw_tp-entry to upper case.
    concatenate gv_rep_hdr '(PERCENTAGE WISE)' into gv_rep_hdr separated by space.
*****    endif.
  else.             "**** for sale
*****    READ TABLE lt_tp INTO lw_tp WITH KEY key = 'P_SALE'.
*****    IF sy-subrc = 0.
*****      CONDENSE lw_tp-entry.
    concatenate gv_rep_hdr '(RUPEE WISE)' into gv_rep_hdr separated by space.
*****    ENDIF.
  endif.

  clear lv_dt_str.
  concatenate s_date-low+6(2) s_date-low+4(2) s_date-low+0(4) into lv_dt_str separated by '.'.
  clear lv_dt_str1.
  concatenate s_date-high+6(2) s_date-high+4(2) s_date-high+0(4) into lv_dt_str1 separated by '.'.

  concatenate gv_rep_hdr '-' lv_dt_str into gv_rep_hdr separated by space.
  concatenate gv_rep_hdr 'TO' lv_dt_str1 into gv_rep_hdr separated by space.

  lv_gtitle = gv_rep_hdr.

  gw_layout-zebra = 'X'.
  gw_layout-colwidth_optimize = 'X'.

  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
      i_callback_program = sy-repid
****      I_CALLBACK_USER_COMMAND = 'USER_COMMAND'
*****      i_callback_top_of_page = 'TOP_OF_PAGE'
      i_grid_title       = lv_gtitle
      is_layout          = gw_layout
      it_fieldcat        = gt_fcat[]
*     I_DEFAULT          = 'X'
      i_save             = 'A'
    tables
      t_outtab           = gt_vfdata[]
    exceptions
      program_error      = 1
      others             = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  GET_RM_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form get_rm_data .
  data : lv_srno      type i,
         lw_yterr     type ty_yterr,
         lw_zdrphq    type zdrphq,
         lv_month_cnt type i,
         lv_date      type sy-datum,
         lv_sdate     type sy-datum,
         lv_edate     type sy-datum,
         lv_mnth      type i,
         lw_mtpt      type zmtpt,
         lv_trgt_yr   type i,
         lv_trgt_val  type p.

**** get prev.year dates from entered s_date
  clear  gv_py_dt1.
  call function 'RP_CALC_DATE_IN_INTERVAL'
    exporting
      date      = s_date-low
      days      = 0
      months    = 0
      signum    = '-'
      years     = 1
    importing
      calc_date = gv_py_dt1.

  clear gv_py_dt2.
  call function 'RP_CALC_DATE_IN_INTERVAL'
    exporting
      date      = s_date-high
      days      = 0
      months    = 0
      signum    = '-'
      years     = 1
    importing
      calc_date = gv_py_dt2.

***** months difference between entered dates
  clear lv_month_cnt.
  if s_date-low+4(2) = s_date-high+4(2).
    lv_month_cnt = 1.
  elseif s_date-low+4(2) <> s_date-high+4(2) and s_date-low+0(4) = s_date-high+0(4).
    lv_month_cnt = s_date-high+4(2) -  s_date-low+4(2) + 1.
  elseif s_date-low+4(2) <> s_date-high+4(2) and s_date-low+0(4) <> s_date-high+0(4).
    lv_month_cnt = 12 -  s_date-low+4(2) + 1.
    lv_month_cnt = lv_month_cnt + s_date-high+4(2).
  endif.

****  target year
  clear lv_trgt_yr.
  if s_date-high+4(2) < 4.
    lv_trgt_yr = s_date-high+0(4) - 1.
  else.
    lv_trgt_yr = s_date-low+0(4).
  endif.

*****  IF p_zone IS NOT INITIAL.
*****    CLEAR :gt_zdsmter[].
*****    SELECT * FROM zdsmter INTO TABLE gt_zdsmter
*****      WHERE zdsm = p_zone
*****      AND zmonth EQ s_date-high+4(2)
*****      AND zyear EQ s_date-high(4).
*****  ELSE.
  clear :gt_zdsmter[].
  select * from zdsmter into table gt_zdsmter
    where zmonth eq p_adate+4(2) "s_date-high+4(2)
    and zyear eq p_adate+0(4)."s_date-high(4).
*****  ENDIF.

  if gt_zdsmter[] is not initial.

    sort gt_zdsmter[] by zdsm.
**** get ZMs
    clear gt_zm[].
    gt_zm[] = gt_zdsmter[].
    delete gt_zm where zdsm+0(2) = 'R-'.
    sort gt_zm by zdsm bzirk.
    delete adjacent duplicates from gt_zm comparing zdsm bzirk.
**** get RMs
    clear gt_rm[].
    gt_rm[] = gt_zdsmter[].
    delete gt_rm where zdsm+0(2) = 'D-'.
    sort gt_rm by zdsm bzirk.
    delete adjacent duplicates from gt_rm comparing zdsm bzirk.

    clear gt_yterr[].
    select a~spart a~bzirk a~endda a~begda a~plans
           b~bztxt into table gt_yterr
      from yterrallc as a inner join t171t as b
      on a~bzirk = b~bzirk
      where a~endda = '99991231'
      and b~spras = sy-langu.

    clear gt_0001[].
    select a~pernr a~begda
           b~pernr b~begda b~endda b~abkrs b~ansvh b~persk b~plans b~ename b~zz_hqcode into table gt_0001
      from pa0000 as a inner join pa0001 as b
      on a~pernr = b~pernr
      where a~massn = '01'
      and b~endda eq '99991231'.

***** HQ des
    clear gt_hq_des[].
    select * from zthr_heq_des into table gt_hq_des.
  endif.

***** total PSO's
  clear gt_ztotpso[].
  select * from ztotpso into table gt_ztotpso
    where begda between s_date-low and s_date-high
    and bzirk like 'R-%'.
  if sy-subrc = 0.
    loop at gt_ztotpso into gw_ztotpso.
      clear: gw_ztotpso-begda,
             gw_ztotpso-endda.
      collect gw_ztotpso into gt_ztotpso_add.
      clear gw_ztotpso.
    endloop.
  endif.

  if p_group = 'X' .
***** get materials from prd.group.
    clear gt_prdgrp[].
    select * from zprdgroup into table gt_prdgrp
      where rep_type = 'SR121314'
      and grp_code in s_grp.
    if gt_prdgrp[] is not initial.
      sort gt_prdgrp[] by prd_code.
***** get sales current date - product Group-wise
      clear gt_zrpqv[].
      clear lv_sdate.
      lv_sdate = s_date-low.
      while lv_sdate <= s_date-high.
        select * from zrpqv appending table gt_zrpqv
          for all entries in gt_prdgrp
          where zmonth = lv_sdate+4(2)
          and zyear = lv_sdate+0(4)
          and matnr = gt_prdgrp-prd_code.

        call function 'RE_ADD_MONTH_TO_DATE'
          exporting
            months  = '1'
            olddate = lv_sdate
          importing
            newdate = lv_sdate.
      endwhile.
***** get sales previous year dates - product Group-wise
      clear gt_zrpqv_py[].
      clear lv_sdate.
      lv_sdate = gv_py_dt1.
      while lv_sdate <= gv_py_dt2.
        select * from zrpqv appending table gt_zrpqv_py
          for all entries in gt_prdgrp
          where zmonth = lv_sdate+4(2)
          and zyear = lv_sdate+0(4)
          and matnr = gt_prdgrp-prd_code.

        call function 'RE_ADD_MONTH_TO_DATE'
          exporting
            months  = '1'
            olddate = lv_sdate
          importing
            newdate = lv_sdate.
      endwhile.
    endif.
    clear gt_target[].
    select * from ysd_dist_targt into table gt_target
      where trgyear = lv_trgt_yr.
  endif.
  if p_prod = 'X'.
***** get sales current date - product-wise
    clear gt_zrpqv[].
    clear lv_sdate.
    lv_sdate = s_date-low.
    while lv_sdate <= s_date-high.
      select * from zrpqv appending table gt_zrpqv
        where zmonth = lv_sdate+4(2)
        and zyear = lv_sdate+0(4)
        and matnr in s_mat.
      call function 'RE_ADD_MONTH_TO_DATE'
        exporting
          months  = '1'
          olddate = lv_sdate
        importing
          newdate = lv_sdate.

    endwhile.
***** get sales previous year dates - product-wise
    clear gt_zrpqv_py[].
    clear lv_sdate.
    lv_sdate = gv_py_dt1.
    while lv_sdate <= gv_py_dt2.
      select * from zrpqv appending table gt_zrpqv_py
        where zmonth = lv_sdate+4(2)
        and zyear = lv_sdate+0(4)
        and matnr in s_mat.
      call function 'RE_ADD_MONTH_TO_DATE'
        exporting
          months  = '1'
          olddate = lv_sdate
        importing
          newdate = lv_sdate.
    endwhile.
  endif.


  if gt_zrpqv[] is not initial.
    clear gt_zrpqv_add[].
    loop at gt_zrpqv into gw_zrpqv.
      gw_zrpqv_add-bzirk = gw_zrpqv-bzirk.
      gw_zrpqv_add-grosspts = gw_zrpqv-grosspts .
      gw_zrpqv_add-grossqty = gw_zrpqv-grossqty .
      gw_zrpqv_add-rval = gw_zrpqv-rval.
      gw_zrpqv_add-rqty = gw_zrpqv-rqty.
      gw_zrpqv_add-nepval = gw_zrpqv-nepval.
      gw_zrpqv_add-nepqty = gw_zrpqv-nepqty.
      collect gw_zrpqv_add into gt_zrpqv_add.
      clear  gw_zrpqv_add.
    endloop.
  endif.
  clear gt_zrpqv_py_add[].
  loop at gt_zrpqv_py into gw_zrpqv_py.
    gw_zrpqv_py_add-bzirk = gw_zrpqv_py-bzirk.
    gw_zrpqv_py_add-grosspts = gw_zrpqv_py-grosspts .
    gw_zrpqv_py_add-grossqty = gw_zrpqv_py-grossqty .
    gw_zrpqv_py_add-rval = gw_zrpqv_py-rval.
    gw_zrpqv_py_add-rqty = gw_zrpqv_py-rqty.
    gw_zrpqv_py_add-nepval = gw_zrpqv_py-nepval.
    gw_zrpqv_py_add-nepqty = gw_zrpqv_py-nepqty.
    collect gw_zrpqv_py_add into gt_zrpqv_py_add.
    clear  gw_zrpqv_py_add.
  endloop.

  if gt_zrpqv_add[] is not initial.
    clear gt_rm_sale[].
    loop at gt_zrpqv_add into gw_zrpqv_add.
      clear gw_rm.
      read table gt_rm into gw_rm with key bzirk = gw_zrpqv_add-bzirk.
      if sy-subrc = 0.
        gw_rm_sale-zrsm = gw_rm-zdsm.
        clear gw_zm.
        read table gt_zm into gw_zm with key bzirk = gw_rm-zdsm.
        if sy-subrc = 0.
          gw_rm_sale-zdsm = gw_zm-zdsm.
        endif.

      endif.

      gw_rm_sale-sales = gw_zrpqv_add-grosspts .
      gw_rm_sale-qty = gw_zrpqv_add-grossqty .

**** target
      clear lv_trgt_val.
      read table gt_target into gw_target with key bzirk = gw_zrpqv_add-bzirk.
      if sy-subrc = 0.
*****        lv_date = s_date-low.
*****        lv_mnth = s_date-low+4(2).
*****
*****        while lv_date <= s_date-high.
*****          if lv_mnth = 4.
*****            lv_trgt_val = lv_trgt_val + gw_target-month01.
*****          elseif lv_mnth = 5.
*****            lv_trgt_val = lv_trgt_val + gw_target-month02.
*****          elseif lv_mnth = 6.
*****            lv_trgt_val = lv_trgt_val + gw_target-month03.
*****          elseif lv_mnth = 7.
*****            lv_trgt_val = lv_trgt_val + gw_target-month04.
*****          elseif lv_mnth = 8.
*****            lv_trgt_val = lv_trgt_val + gw_target-month05.
*****          elseif lv_mnth = 9.
*****            lv_trgt_val = lv_trgt_val + gw_target-month06.
*****          elseif lv_mnth = 10.
*****            lv_trgt_val = lv_trgt_val + gw_target-month07.
*****          elseif lv_mnth = 11.
*****            lv_trgt_val = lv_trgt_val + gw_target-month08.
*****          elseif lv_mnth = 12.
*****            lv_trgt_val = lv_trgt_val + gw_target-month09.
*****          elseif lv_mnth = 1.
*****            lv_trgt_val = lv_trgt_val + gw_target-month10.
*****          elseif lv_mnth = 2.
*****            lv_trgt_val = lv_trgt_val + gw_target-month11.
*****          elseif lv_mnth = 3.
*****            lv_trgt_val = lv_trgt_val + gw_target-month12.
*****          endif.
*****
*****          call function 'RE_ADD_MONTH_TO_DATE'
*****            exporting
*****              months  = '1'
*****              olddate = lv_date
*****            importing
*****              newdate = lv_date.
*****
*****          lv_mnth = lv_date+4(2).
*****        endwhile.
*****        gw_rm_sale-target = lv_trgt_val.

*************************  Commented above and added below to consider month-wise MTPT based on month-wise target   ******************
        lv_mnth = s_date-high+4(2).
        case lv_mnth.
          when '4'.
            gw_rm_sale-target = gw_target-month01.
          when '5'.
            gw_rm_sale-target = gw_target-month02.
          when '6'.
            gw_rm_sale-target = gw_target-month03.
          when '7'.
            gw_rm_sale-target = gw_target-month04.
          when '8'.
            gw_rm_sale-target = gw_target-month05.
          when '9'.
            gw_rm_sale-target = gw_target-month06.
          when '10'.
            gw_rm_sale-target = gw_target-month07.
          when '11'.
            gw_rm_sale-target = gw_target-month08.
          when '12'.
            gw_rm_sale-target = gw_target-month09.
          when '1'.
            gw_rm_sale-target = gw_target-month10.
          when '2'.
            gw_rm_sale-target = gw_target-month11.
          when '3'.
            gw_rm_sale-target = gw_target-month12.
        endcase.
      endif.
      collect gw_rm_sale into gt_rm_sale.
      clear  gw_rm_sale.

    endloop.
  endif.

  if gt_zrpqv_py_add[] is not initial.
    loop at gt_zrpqv_py_add into gw_zrpqv_py_add.

      clear gw_rm.
      read table gt_rm into gw_rm with key bzirk = gw_zrpqv_py_add-bzirk.
      if sy-subrc = 0.
        gw_rm_sale-zrsm = gw_rm-zdsm.
        clear gw_zm.
        read table gt_zm into gw_zm with key bzirk = gw_rm-zdsm.
        if sy-subrc = 0.
          gw_rm_sale-zdsm = gw_zm-zdsm.
        endif.
      endif.

      gw_rm_sale-psales = gw_zrpqv_py_add-grosspts .
      gw_rm_sale-pqty = gw_zrpqv_py_add-grossqty .
      collect gw_rm_sale into gt_rm_sale.
      clear  gw_rm_sale.
    endloop.
  endif.


  if gt_rm_sale[] is not initial.
    loop at gt_rm_sale into gw_rm_sale.

      gw_fdata-sales = gw_rm_sale-sales.
      gw_fdata-qty = gw_rm_sale-qty.
      gw_fdata-psales = gw_rm_sale-psales.
      gw_fdata-pqty = gw_rm_sale-pqty.
      gw_fdata-bzirk = gw_rm_sale-zrsm.
      gw_fdata-zrsm = gw_rm_sale-zrsm.
      gw_fdata-zdsm = gw_rm_sale-zdsm.

      gw_fdata-avgsales = gw_rm_sale-sales / lv_month_cnt.
      gw_fdata-avgqty = gw_rm_sale-qty / lv_month_cnt.

***** target
      gw_fdata-target = gw_rm_sale-target.

**** growth value
      if gw_fdata-psales ne 0 .
        gw_fdata-grth = ( gw_fdata-sales - gw_fdata-psales ) /  gw_fdata-psales * 100.
      else.
        gw_fdata-grth = 100 .
      endif.

***** growth Qty.
      if gw_fdata-pqty ne 0 .
        gw_fdata-grth_p = ( gw_fdata-qty - gw_fdata-pqty ) /  gw_fdata-pqty * 100.
      else.
        gw_fdata-grth_p = 100 .
      endif.

      read table gt_yterr into gw_yterr with key bzirk = gw_rm_sale-zrsm.
      if sy-subrc = 0.
        case gw_yterr-spart.
          when '50'.
            clear lw_yterr.
            read table gt_yterr into lw_yterr with key bzirk = gw_rm_sale-zrsm spart = '60'.
            if sy-subrc = 0.
              gw_fdata-div = 'BCL'.
            else.
              gw_fdata-div = 'BC'.
            endif.
          when '60'.
            clear lw_yterr.
            read table gt_yterr into lw_yterr with key bzirk = gw_rm_sale-zrsm spart = '50'.
            if sy-subrc = 0.
              gw_fdata-div = 'BCL'.
            else.
              gw_fdata-div = 'XL'.
            endif.
          when '70'.
            gw_fdata-div = 'BCLS'.
        endcase.
        read table gt_0001 into gw_0001 with key plans  =  gw_yterr-plans .
        if sy-subrc = 0.
          gw_fdata-pernr = gw_0001-pernr01.
          gw_fdata-ename = gw_0001-ename.
          gw_fdata-doj = gw_0001-dtjoin.

**** designation
          select single mc_short from hrp1000 into gw_fdata-des
            where plvar = '01'
            and otype  = 'S'
            and objid =  gw_yterr-plans
            and endda eq '99991231'
            and langu = sy-langu.

          gw_fdata-zz_hqcode = gw_0001-zz_hqcode.
          read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_0001-zz_hqcode.
          if sy-subrc = 0.
            gw_fdata-zz_hqdesc = gw_hq_des-zz_hqdesc.
          endif.
        else.
          gw_fdata-ename = 'VACANT'.
          clear lw_zdrphq.
          select single * from zdrphq into lw_zdrphq where bzirk eq gw_rm_sale-zrsm.
          if sy-subrc = 0.
            read table gt_hq_des into gw_hq_des with key zz_hqcode = lw_zdrphq-zz_hqcode.
            if sy-subrc = 0.
              gw_fdata-zz_hqdesc = gw_hq_des-zz_hqdesc.
            endif.
          endif.
*****          gw_fdata-zz_hqdesc = gw_yterr-bztxt.
        endif.
      endif.

**** zm name
      read table gt_yterr into gw_yterr with key bzirk = gw_fdata-zdsm.
      if sy-subrc = 0.
        read table gt_0001 into gw_0001 with key plans  =  gw_yterr-plans .
        if sy-subrc = 0.
          gw_fdata-zmname = gw_0001-ename.
        else.
          gw_fdata-zmname =  'VACANT'.
        endif.
      endif.

*****no of pso's
      read table gt_ztotpso_add into gw_ztotpso with key bzirk = gw_fdata-zrsm.
      if sy-subrc = 0.
        if gw_fdata-div = 'BC' and gw_ztotpso-spart = '50'.
          gw_fdata-totpso =  gw_ztotpso-bcl + gw_ztotpso-bc - gw_ztotpso-hbe.
        elseif  gw_fdata-div = 'XL' and gw_ztotpso-spart = '60'.
          gw_fdata-totpso = gw_ztotpso-bcl + gw_ztotpso-xl - gw_ztotpso-hbe. .
        elseif  gw_fdata-div = 'BC' and gw_ztotpso-spart = '99'.
          gw_fdata-totpso =   gw_ztotpso-bcl + gw_ztotpso-bc   - gw_ztotpso-hbe. .
        elseif   gw_fdata-div = 'XL' and gw_ztotpso-spart = '99'.
          gw_fdata-totpso =   gw_ztotpso-xl + gw_ztotpso-bcl   - gw_ztotpso-hbe. .
        elseif  gw_fdata-div = 'BCL' and gw_ztotpso-spart = '99'.
          gw_fdata-totpso =  gw_ztotpso-bc + gw_ztotpso-xl + gw_ztotpso-bcl   - gw_ztotpso-hbe.
        elseif  gw_fdata-div = 'BCLS' and gw_ztotpso-spart = '70' or gw_ztotpso-spart = '99'.
          gw_fdata-totpso =  gw_ztotpso-ls - gw_ztotpso-hbe.
        endif.
      endif.

      if gw_fdata-totpso ne 0 .
        gw_fdata-ypm =  gw_fdata-sales   /  gw_fdata-totpso.
      else.
        gw_fdata-ypm = 100 .
      endif.

      append gw_fdata to gt_fdata.
      clear gw_fdata.
    endloop.
  endif.



****** update sr.no
  if gt_fdata[] is not initial.
    sort gt_fdata by div.
**** check if division is selected at input.
    clear gt_fdata_tmp[].
    if cb_bc = 'X'.
      loop at gt_fdata into gw_fdata where div = 'BC'.
        append gw_fdata to gt_fdata_tmp.
        clear gw_fdata.
      endloop.
    endif.
    if cb_xl = 'X'.
      loop at gt_fdata into gw_fdata where div = 'XL'.
        append gw_fdata to gt_fdata_tmp.
        clear gw_fdata.
      endloop.
    endif.
    if cb_bcl = 'X'.
      loop at gt_fdata into gw_fdata where div = 'BCL'.
        append  gw_fdata to gt_fdata_tmp.
        clear gw_fdata.
      endloop.
    endif.

    if cb_ls = 'X'.
      loop at gt_fdata into gw_fdata where div = 'BCLS'.
        append  gw_fdata to gt_fdata_tmp.
        clear gw_fdata.
      endloop.
    endif.

**** for zone-wise as per input zone
    if p_zone is not initial.
      clear gt_fdata_tmp1[].
      loop at gt_fdata_tmp into gw_fdata_tmp where zdsm = p_zone.
        append  gw_fdata_tmp to gt_fdata_tmp1.
        clear gw_fdata.
      endloop.

      sort gt_fdata_tmp1[] by zdsm zrsm bzirk.
      delete adjacent duplicates from gt_fdata_tmp1[] comparing zdsm zrsm bzirk.
    else.  "....if no zone is entered at input
      clear gt_fdata_tmp1[].
      gt_fdata_tmp1[] = gt_fdata_tmp[].

      sort gt_fdata_tmp1[] by zdsm zrsm bzirk.
      delete adjacent duplicates from gt_fdata_tmp1[] comparing zdsm zrsm bzirk.
    endif.

***** get final data into GT_FINAL[] - for display
    clear gt_fdata[].
    gt_fdata[] = gt_fdata_tmp1[].
    if gt_fdata[] is not initial.

***** mtpt
      if gt_fdata[] is not initial and p_group = 'X' and p_rad1 = 'X'.
        loop at gt_fdata into gw_fdata.
          if gw_fdata-target > 0.
            if s_grp[] is not initial.
              clear lw_mtpt.
              select single * from zmtpt into lw_mtpt
                where matkl in s_grp
                and  zmtpt~begda le s_date-high and zmtpt~endda ge s_date-low
                and from_amt le gw_fdata-target and to_amt ge gw_fdata-target.
            else.
              clear lw_mtpt.
              select single * from zmtpt into lw_mtpt
                where zmtpt~begda le s_date-high and zmtpt~endda ge s_date-low
                and from_amt le gw_fdata-target and to_amt ge gw_fdata-target.
            endif.
            if sy-subrc = 0.
*****              gw_fdata-mtpt = lw_mtpt-target * lv_month_cnt.
*************************  Commented above and added below to consider month-wise MTPT based on month-wise target   ******************
              gw_fdata-mtpt = lw_mtpt-target.
              modify gt_fdata index sy-tabix from gw_fdata transporting mtpt.
            endif.
          endif.
        endloop.
      endif.

**** for Qty.wise ranking
      if p_qty = 'X'.
        sort  gt_fdata by qty descending.
      endif.
**** for Val.wise ranking
      if p_val = 'X'.
        sort  gt_fdata by sales descending.
      endif.
      clear lv_srno.
      lv_srno = 1.
      loop at gt_fdata into gw_fdata.
***** Update ranking/sr.no as per selected criteria
        gw_fdata-srno = lv_srno.
        lv_srno = lv_srno + 1.
        modify gt_fdata from gw_fdata transporting srno.
        clear gw_fdata.
      endloop.
***** check if max.top count is entered.
      if p_cnt is not initial.
        sort gt_fdata by srno.
        delete gt_fdata where srno > p_cnt.
      endif.
    else.
      message 'No data found.' type 'I'.
    endif.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  GET_RM_VALUE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form get_rm_value_data .
  data : lv_trgt_yr  type i,
         lv_srno     type i,
         lw_zdsmter  type zdsmter,
         lw_zdrphq   type zdrphq,
         lw_pso1     type zdsmter,
         lv_date     type sy-datum,
         lv_sdate    type sy-datum,
         lv_mnth     type i,
         lv_trgt_val type p.

**** get prev.year dates from entered s_date
  clear  gv_py_dt1.
  call function 'RP_CALC_DATE_IN_INTERVAL'
    exporting
      date      = s_date-low
      days      = 0
      months    = 0
      signum    = '-'
      years     = 1
    importing
      calc_date = gv_py_dt1.

  clear gv_py_dt2.
  call function 'RP_CALC_DATE_IN_INTERVAL'
    exporting
      date      = s_date-high
      days      = 0
      months    = 0
      signum    = '-'
      years     = 1
    importing
      calc_date = gv_py_dt2.

  clear lv_trgt_yr.
  if s_date-high+4(2) < 4.
    lv_trgt_yr = s_date-high+0(4) - 1.
  else.
    lv_trgt_yr = s_date-low+0(4).
  endif.

  clear :gt_zdsmter[].
  select * from zdsmter into table gt_zdsmter
    where zmonth eq p_adate+4(2)"s_date-high+4(2)
    and zyear eq p_adate+0(4)."s_date-high+0(4).

  if gt_zdsmter[] is not initial.

    sort gt_zdsmter[] by zdsm.

**** get ZMs
    clear gt_zm[].
    gt_zm[] = gt_zdsmter[].
    delete gt_zm where zdsm+0(2) = 'R-'.
    sort gt_zm by zdsm bzirk.
    delete adjacent duplicates from gt_zm comparing zdsm bzirk.
**** get RMs
    clear gt_rm[].
    gt_rm[] = gt_zdsmter[].
    delete gt_rm where zdsm+0(2) = 'D-'.
    sort gt_rm by zdsm bzirk.
    delete adjacent duplicates from gt_rm comparing zdsm bzirk.

    clear gt_yterr[].
    select a~spart a~bzirk a~endda a~begda a~plans
           b~bztxt into table gt_yterr
      from yterrallc as a inner join t171t as b
      on a~bzirk = b~bzirk
      where a~endda = '99991231'
      and b~spras = sy-langu.

    clear gt_0001[].
    select a~pernr a~begda
           b~pernr b~begda b~endda b~abkrs b~ansvh b~persk b~plans b~ename b~zz_hqcode into table gt_0001
      from pa0000 as a inner join pa0001 as b
      on a~pernr = b~pernr
      where a~massn = '01'
      and b~endda eq '99991231'.

***** HQ des
    clear gt_hq_des[].
    select * from zthr_heq_des into table gt_hq_des.
  endif.

***** total PSO's
  clear gt_ztotpso[].
  select * from ztotpso into table gt_ztotpso
    where begda between s_date-low and s_date-high
    and bzirk like 'R-%'.
  if sy-subrc = 0.
    loop at gt_ztotpso into gw_ztotpso.
*****      clear: gw_ztotpso-begda,
*****             gw_ztotpso-endda.
      clear gw_ztotpso-spart.
      collect gw_ztotpso into gt_ztotpso_add.
      clear gw_ztotpso.
    endloop.
  endif.

**** target based on financial year
  clear gt_target[].
  select * from ysd_dist_targt into table gt_target
    where trgyear = lv_trgt_yr.

**** net sale value in Rs. for current date
  clear: gt_zrcumpso[], gt_rm_sale[].
  clear lv_sdate.
  lv_sdate = s_date-low.
  while lv_sdate <= s_date-high.
*****    select * from zrcumpso appending table gt_zrcumpso
    select * from zcumpso appending table gt_zrcumpso
      where zyear = lv_sdate+0(4)
      and zmonth = lv_sdate+4(2).

    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = lv_sdate
      importing
        newdate = lv_sdate.

  endwhile.
  if gt_zrcumpso[] is not initial.
    clear gt_zrcumpso_add[].
    loop at gt_zrcumpso into gw_zrcumpso.
      gw_zrcumpso_add-bzirk = gw_zrcumpso-bzirk.
      gw_zrcumpso_add-netval = gw_zrcumpso-netval.
      collect gw_zrcumpso_add into gt_zrcumpso_add.
      clear gw_zrcumpso_add.
    endloop.

    loop at gt_zrcumpso_add into gw_zrcumpso_add.
      clear gw_rm.
      read table gt_rm into gw_rm with key bzirk = gw_zrcumpso_add-bzirk.
      if sy-subrc = 0.
        gw_rm_sale-zrsm = gw_rm-zdsm.
        clear gw_zm.
        read table gt_zm into gw_zm with key bzirk = gw_rm-zdsm.
        if sy-subrc = 0.
          gw_rm_sale-zdsm = gw_zm-zdsm.
        endif.
      endif.

      gw_rm_sale-sales = gw_zrcumpso_add-netval .

***  get target value
      clear lv_trgt_val.
      read table gt_target into gw_target with key bzirk =  gw_zrcumpso_add-bzirk.
      if sy-subrc = 0.
        lv_date = s_date-low.
        lv_mnth = s_date-low+4(2).

        while lv_date <= s_date-high.
          if lv_mnth = 4.
            lv_trgt_val = lv_trgt_val + gw_target-month01.
          elseif lv_mnth = 5.
            lv_trgt_val = lv_trgt_val + gw_target-month02.
          elseif lv_mnth = 6.
            lv_trgt_val = lv_trgt_val + gw_target-month03.
          elseif lv_mnth = 7.
            lv_trgt_val = lv_trgt_val + gw_target-month04.
          elseif lv_mnth = 8.
            lv_trgt_val = lv_trgt_val + gw_target-month05.
          elseif lv_mnth = 9.
            lv_trgt_val = lv_trgt_val + gw_target-month06.
          elseif lv_mnth = 10.
            lv_trgt_val = lv_trgt_val + gw_target-month07.
          elseif lv_mnth = 11.
            lv_trgt_val = lv_trgt_val + gw_target-month08.
          elseif lv_mnth = 12.
            lv_trgt_val = lv_trgt_val + gw_target-month09.
          elseif lv_mnth = 1.
            lv_trgt_val = lv_trgt_val + gw_target-month10.
          elseif lv_mnth = 2.
            lv_trgt_val = lv_trgt_val + gw_target-month11.
          elseif lv_mnth = 3.
            lv_trgt_val = lv_trgt_val + gw_target-month12.
          endif.

          call function 'RE_ADD_MONTH_TO_DATE'
            exporting
              months  = '1'
              olddate = lv_date
            importing
              newdate = lv_date.

          lv_mnth = lv_date+4(2).
        endwhile.
      endif.
      clear gw_yterr.
      read table gt_yterr into gw_yterr with key bzirk = gw_zrcumpso_add-bzirk.
      if sy-subrc = 0.
        gw_rm_sale-target = lv_trgt_val.
      else.
        clear lv_trgt_val.
      endif.

      collect gw_rm_sale into gt_rm_sale.
      clear  gw_rm_sale.
    endloop.
  endif.


**** net sale value in Rs. for prev.year date
  clear gt_zrcumpso_py[].
  clear lv_sdate.
  lv_sdate = gv_py_dt1.
  while lv_sdate <= gv_py_dt2.
    select * from zrcumpso appending table gt_zrcumpso_py
    where zyear = lv_sdate+0(4)
    and zmonth = lv_sdate+4(2) .

    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = lv_sdate
      importing
        newdate = lv_sdate.

  endwhile.
  if gt_zrcumpso_py[] is not initial.
    clear gt_zrcumpso_py_add[].
    loop at gt_zrcumpso_py into gw_zrcumpso_py.
      gw_zrcumpso_py_add-bzirk = gw_zrcumpso_py-bzirk.
      gw_zrcumpso_py_add-netval = gw_zrcumpso_py-netval.
      collect gw_zrcumpso_py_add into gt_zrcumpso_py_add.
      clear gw_zrcumpso_py_add.
    endloop.

    loop at gt_zrcumpso_py_add into gw_zrcumpso_py_add.
      clear gw_rm.
      read table gt_rm into gw_rm with key bzirk = gw_zrcumpso_py_add-bzirk.
      if sy-subrc = 0.
        gw_rm_sale-zrsm = gw_rm-zdsm.
        clear gw_zm.
        read table gt_zm into gw_zm with key bzirk = gw_rm-zdsm.
        if sy-subrc = 0.
          gw_rm_sale-zdsm = gw_zm-zdsm.
        endif.
      endif.
      gw_rm_sale-psales = gw_zrcumpso_py_add-netval .

      collect gw_rm_sale into gt_rm_sale.
      clear  gw_rm_sale.
    endloop.
  endif.

  if gt_rm_sale[] is not initial.
    loop at gt_rm_sale into gw_rm_sale.

      gw_vfdata-r_bzirk =   gw_rm_sale-zrsm.
      gw_vfdata-bzirk =   gw_rm_sale-zrsm.
      gw_vfdata-d_bzirk =   gw_rm_sale-zdsm.
      gw_vfdata-sales =   gw_rm_sale-sales.
      gw_vfdata-psales =   gw_rm_sale-psales.
      gw_vfdata-target =   gw_rm_sale-target.

******      read table gt_ztotpso_add into gw_ztotpso with key bzirk = gw_rm_sale-zrsm.
******      if sy-subrc = 0.
******        gw_vfdata-totpso =  gw_ztotpso-bcl + gw_ztotpso-bc + gw_ztotpso-xl .
************        gw_rm_sale-totpso = gw_rm_sale-totpso +  gw_ztotpso-bcl + gw_ztotpso-bc + gw_ztotpso-xl .
******      endif.

*************** Commented above and added below to correct total PSO's ***********************************
      loop at   gt_ztotpso_add into gw_ztotpso where bzirk = gw_rm_sale-zrsm.
        gw_vfdata-totpso = gw_vfdata-totpso +  gw_ztotpso-bcl + gw_ztotpso-bc + gw_ztotpso-xl + gw_ztotpso-ls .
      endloop.

      if gw_vfdata-target > 0.
        gw_vfdata-pertgt =  gw_vfdata-sales / gw_vfdata-target * 100  .
      else.
        gw_vfdata-pertgt = 0.
      endif.
      if gw_vfdata-totpso > 0.
        gw_vfdata-ypm =  gw_vfdata-sales / gw_vfdata-totpso.
      else.
        gw_vfdata-ypm = 0.
      endif.

      clear gw_zdsmter.
      read table gt_zdsmter into gw_zdsmter with key bzirk = gw_rm_sale-zrsm.
      if sy-subrc = 0.
        case gw_zdsmter-spart.
          when '50'.
            clear lw_zdsmter.
            read table gt_zdsmter into lw_zdsmter with key bzirk = gw_rm_sale-zrsm spart = '60'.
            if sy-subrc = 0.
              gw_vfdata-div = 'BCL'.
            else.
              gw_vfdata-div = 'BC'.
            endif.
          when '60'.
            clear lw_zdsmter.
            read table gt_zdsmter into lw_zdsmter with key bzirk = gw_rm_sale-zrsm spart = '50'.
            if sy-subrc = 0.
              gw_vfdata-div = 'BCL'.
            else.
              gw_vfdata-div = 'XL'.
            endif.
          when '70'.
            gw_vfdata-div = 'BCLS'.
        endcase.
      endif.
      read table gt_yterr into gw_yterr with key bzirk = gw_rm_sale-zrsm.
      if sy-subrc = 0.
        read table gt_0001 into gw_0001 with key plans  =  gw_yterr-plans .
        if sy-subrc = 0.
          gw_vfdata-pernr = gw_0001-pernr01.
          gw_vfdata-ename = gw_0001-ename.
          gw_vfdata-doj = gw_0001-dtjoin.

**** designation
*****          SELECT SINGLE mc_short FROM hrp1000 INTO gw_vfdata-des
*****            WHERE plvar = '01'
*****            AND otype  = 'S'
*****            AND objid =  gw_yterr-plans
*****            AND endda EQ '99991231'
*****            AND langu = sy-langu.

          if gw_0001-persk = 25.
            gw_vfdata-des =  'SZM'.
          elseif gw_0001-persk = 26.
            gw_vfdata-des =  'ZM'.
          elseif gw_0001-persk = 53.
            gw_vfdata-des =  'SE'.
          elseif gw_0001-persk = 51.
            gw_vfdata-des =  'TM'.
          elseif gw_0001-persk = 54.
            gw_vfdata-des =  'SABM'.
          elseif gw_0001-persk = 43.
            gw_vfdata-des =  'DZM'.
          elseif gw_0001-persk = 44.
            gw_vfdata-des =  'SRM'.
          elseif gw_0001-persk = 45.
            gw_vfdata-des =  'RM'.
          elseif gw_0001-persk = 50.
            gw_vfdata-des =  'ABM'.
          endif.

          gw_vfdata-zz_hqcode = gw_0001-zz_hqcode.
          read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_0001-zz_hqcode.
          if sy-subrc = 0.
            gw_vfdata-zz_hqdesc = gw_hq_des-zz_hqdesc.
          endif.
        else.
          gw_vfdata-ename = 'VACANT'.
          clear lw_zdrphq.
          select single * from zdrphq into lw_zdrphq where bzirk eq gw_rm_sale-zrsm.
          if sy-subrc = 0.
            read table gt_hq_des into gw_hq_des with key zz_hqcode = lw_zdrphq-zz_hqcode.
            if sy-subrc = 0.
              gw_vfdata-zz_hqdesc = gw_hq_des-zz_hqdesc.
            endif.
          endif.
*****          gw_vfdata-zz_hqdesc = gw_yterr-bztxt.
        endif.
      endif.


**** zm name
      read table gt_yterr into gw_yterr with key bzirk = gw_vfdata-d_bzirk.
      if sy-subrc = 0.
        read table gt_0001 into gw_0001 with key plans  =  gw_yterr-plans .
        if sy-subrc = 0.
          gw_vfdata-zmname = gw_0001-ename.
        else.
          gw_vfdata-zmname =  'VACANT'.
        endif.
      endif.

****  rm name
      read table gt_yterr into gw_yterr with key bzirk = gw_vfdata-r_bzirk.
      if sy-subrc = 0.
        read table gt_0001 into gw_0001 with key plans  =  gw_yterr-plans .
        if sy-subrc = 0.
          gw_vfdata-rmname = gw_0001-ename.
        else.
          gw_vfdata-rmname =  'VACANT'.
        endif.
      endif.
*****   growth
      if gw_vfdata-psales ne 0 .
        gw_vfdata-grth = ( gw_vfdata-sales - gw_vfdata-psales ) /  gw_vfdata-psales * 100.
      else.
        gw_vfdata-grth = 100 .
      endif.

      append gw_vfdata to gt_vfdata.
      clear gw_vfdata.
    endloop.
  endif.

  if gt_vfdata[] is not initial.
    sort gt_vfdata by div.
**** check if division is selected at input.
    clear gt_vfdata_tmp[].
    if cb_bc = 'X'.
      loop at gt_vfdata into gw_vfdata where div = 'BC'.
        append gw_vfdata to gt_vfdata_tmp.
        clear gw_vfdata.
      endloop.
    endif.
    if cb_xl = 'X'.
      loop at gt_vfdata into gw_vfdata where div = 'XL'.
        append gw_vfdata to gt_vfdata_tmp.
        clear gw_vfdata.
      endloop.
    endif.
    if cb_bcl = 'X'.
      loop at gt_vfdata into gw_vfdata where div = 'BCL'.
        append  gw_vfdata to gt_vfdata_tmp.
        clear gw_vfdata.
      endloop.
    endif.

    if cb_ls = 'X'.
      loop at gt_vfdata into gw_vfdata where div = 'BCLS'.
        append  gw_vfdata to gt_vfdata_tmp.
        clear gw_vfdata.
      endloop.
    endif.

    if gt_vfdata_tmp[] is not initial.
      clear gt_vfdata[].
****** for bulletin - delete vacant and %TGT < 100
      if p_rad4 = abap_true.
        sort gt_vfdata_tmp[] by pernr.
        delete gt_vfdata_tmp[] where pernr = '00000000'.
        if p_per = abap_true.
          sort gt_vfdata_tmp[] by pertgt.
          delete gt_vfdata_tmp[] where pertgt < 100.
        endif.
****** for bulletin - delete ypm/productivity < 4 lacs when RMs of BC/XL and < 3 lacs for LS
        if p_sale = abap_true.
          if p_ypm is not initial.
            sort gt_vfdata_tmp[] by div ypm.
            if cb_ls = abap_true.
              delete gt_vfdata_tmp[] where ypm < p_ypm.
            else.
              delete gt_vfdata_tmp[] where ypm < p_ypm.
            endif.
          else.
            message 'Pls menntion Min.YPM value for RMs' type 'I'.
          endif.
        endif.
      endif.

      gt_vfdata[] = gt_vfdata_tmp[].

*****    else.
*****      if gt_vfdata[] is not initial.
*********** for bulletin - delete vacant and %TGT < 100
*****        if p_rad4 = abap_true.
*****          sort gt_vfdata[] by pernr.
*****          delete gt_vfdata[] where pernr = '00000000'.
*****          if p_per = abap_true.
*****            sort gt_vfdata[] by pertgt.
*****            delete gt_vfdata[] where pertgt < 100.
*****          endif.
*****        endif.
*****      endif.
    endif.
    if gt_vfdata[] is not initial.
**** for target % wise ranking
      if p_per = abap_true.
        sort  gt_vfdata by pertgt descending.
      endif.
**** for sale wise ranking
      if p_sale = abap_true.
        sort  gt_vfdata by sales descending.
      endif.
      clear lv_srno.
      lv_srno = 1.
      loop at gt_vfdata into gw_vfdata.
***** Update ranking/sr.no as per selected criteria
        gw_vfdata-srno = lv_srno.
        lv_srno = lv_srno + 1.
        modify gt_vfdata from gw_vfdata transporting srno.
        clear gw_vfdata.
      endloop.
***** check if max.top count is entered.
      if p_cnt is not initial.
        sort gt_vfdata by srno.
        delete gt_vfdata where srno > p_cnt.
      endif.
    else.
      message 'No data found.' type 'I'.
    endif.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  GET_ZM_VALUE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form get_zm_value_data .

  data : lv_trgt_yr  type i,
         lv_srno     type i,
         lw_zdsmter  type zdsmter,
         lw_zdrphq   type zdrphq,
         lw_pso1     type zdsmter,
         lv_date     type sy-datum,
         lv_sdate    type sy-datum,
         lv_mnth     type i,
         lv_trgt_val type p,
         lw_zm       type zdsmter.

**** get prev.year dates from entered s_date
  clear  gv_py_dt1.
  call function 'RP_CALC_DATE_IN_INTERVAL'
    exporting
      date      = s_date-low
      days      = 0
      months    = 0
      signum    = '-'
      years     = 1
    importing
      calc_date = gv_py_dt1.

  clear gv_py_dt2.
  call function 'RP_CALC_DATE_IN_INTERVAL'
    exporting
      date      = s_date-high
      days      = 0
      months    = 0
      signum    = '-'
      years     = 1
    importing
      calc_date = gv_py_dt2.

  clear lv_trgt_yr.
  if s_date-high+4(2) < 4.
    lv_trgt_yr = s_date-high+0(4) - 1.
  else.
    lv_trgt_yr = s_date-low+0(4).
  endif.

  clear :gt_zdsmter[].
  select * from zdsmter into table gt_zdsmter
    where zmonth eq p_adate+4(2)"s_date-high+4(2)
    and zyear eq p_adate+0(4)."s_date-high+0(4).

  if gt_zdsmter[] is not initial.

    sort gt_zdsmter[] by zdsm.

**** get ZMs
    clear gt_zm[].
    gt_zm[] = gt_zdsmter[].
    delete gt_zm where zdsm+0(2) = 'R-'.
    sort gt_zm by zdsm bzirk.
    delete adjacent duplicates from gt_zm comparing zdsm bzirk.
**** get RMs
    clear gt_rm[].
    gt_rm[] = gt_zdsmter[].
    delete gt_rm where zdsm+0(2) = 'D-'.
    sort gt_rm by zdsm bzirk.
    delete adjacent duplicates from gt_rm comparing zdsm bzirk.

    clear gt_yterr[].
    select a~spart a~bzirk a~endda a~begda a~plans
           b~bztxt into table gt_yterr
      from yterrallc as a inner join t171t as b
      on a~bzirk = b~bzirk
      where a~endda = '99991231'
      and b~spras = sy-langu.

    clear gt_0001[].
    select a~pernr a~begda
           b~pernr b~begda b~endda b~abkrs b~ansvh b~persk b~plans b~ename b~zz_hqcode into table gt_0001
      from pa0000 as a inner join pa0001 as b
      on a~pernr = b~pernr
      where a~massn = '01'
      and b~endda eq '99991231'.

***** HQ des
    clear gt_hq_des[].
    select * from zthr_heq_des into table gt_hq_des.
  endif.

***** total PSO's
  clear gt_ztotpso[].
  select * from ztotpso into table gt_ztotpso
    where begda between s_date-low and s_date-high
    and bzirk like 'D-%'.
  if sy-subrc = 0.
    loop at gt_ztotpso into gw_ztotpso.
*****      clear: gw_ztotpso-begda,
*****             gw_ztotpso-endda.
      clear:gw_ztotpso-spart.
      collect gw_ztotpso into gt_ztotpso_add.
      clear gw_ztotpso.
    endloop.
  endif.

*

**** target based on financial year
  clear gt_target[].
  select * from ysd_dist_targt into table gt_target
    where trgyear = lv_trgt_yr.

**** net sale value in Rs. for current date
  clear: gt_zrcumpso[], gt_zm_sale[].
  clear lv_sdate.
  lv_sdate = s_date-low.
  while lv_sdate <= s_date-high.
*****    select * from zrcumpso appending table gt_zrcumpso
    select * from zcumpso appending table gt_zrcumpso
      where zyear = lv_sdate+0(4)
      and zmonth = lv_sdate+4(2) .

    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = lv_sdate
      importing
        newdate = lv_sdate.

  endwhile.
  if gt_zrcumpso[] is not initial.
    clear gt_zrcumpso_add[].
    loop at gt_zrcumpso into gw_zrcumpso.
      clear : gw_zrcumpso-pso , gw_zrcumpso-join_dt,gw_zrcumpso-zmonth, gw_zrcumpso-zyear.
      collect gw_zrcumpso into gt_zrcumpso_add.
      clear gw_zrcumpso.
    endloop.

    loop at gt_zrcumpso_add into gw_zrcumpso_add.

      gw_zm_sale-sales = gw_zrcumpso_add-netval .

***  get target value
      clear lv_trgt_val.
      read table gt_target into gw_target with key bzirk =  gw_zrcumpso_add-bzirk.
      if sy-subrc = 0.
        lv_date = s_date-low.
        lv_mnth = s_date-low+4(2).

        while lv_date <= s_date-high.
          if lv_mnth = 4.
            lv_trgt_val = lv_trgt_val + gw_target-month01.
          elseif lv_mnth = 5.
            lv_trgt_val = lv_trgt_val + gw_target-month02.
          elseif lv_mnth = 6.
            lv_trgt_val = lv_trgt_val + gw_target-month03.
          elseif lv_mnth = 7.
            lv_trgt_val = lv_trgt_val + gw_target-month04.
          elseif lv_mnth = 8.
            lv_trgt_val = lv_trgt_val + gw_target-month05.
          elseif lv_mnth = 9.
            lv_trgt_val = lv_trgt_val + gw_target-month06.
          elseif lv_mnth = 10.
            lv_trgt_val = lv_trgt_val + gw_target-month07.
          elseif lv_mnth = 11.
            lv_trgt_val = lv_trgt_val + gw_target-month08.
          elseif lv_mnth = 12.
            lv_trgt_val = lv_trgt_val + gw_target-month09.
          elseif lv_mnth = 1.
            lv_trgt_val = lv_trgt_val + gw_target-month10.
          elseif lv_mnth = 2.
            lv_trgt_val = lv_trgt_val + gw_target-month11.
          elseif lv_mnth = 3.
            lv_trgt_val = lv_trgt_val + gw_target-month12.
          endif.

          call function 'RE_ADD_MONTH_TO_DATE'
            exporting
              months  = '1'
              olddate = lv_date
            importing
              newdate = lv_date.

          lv_mnth = lv_date+4(2).
        endwhile.
      endif.

      clear gw_yterr.
      read table gt_yterr into gw_yterr with key bzirk = gw_zrcumpso_add-bzirk.
      if sy-subrc = 0.
        gw_zm_sale-target = lv_trgt_val.
      else.
        clear lv_trgt_val.
      endif.

      clear gw_rm.
      read table gt_rm into gw_rm with key bzirk = gw_zrcumpso_add-bzirk.
      if sy-subrc = 0.
        clear gw_zm.
        read table gt_zm into gw_zm with key bzirk = gw_rm-zdsm.
        if sy-subrc = 0.
          if gw_zm-zdsm+0(2) = 'D-'.
            gw_zm_sale-zdsm = gw_zm-zdsm.
          else.
            clear lw_zm.
            read table gt_zm into lw_zm with key bzirk = gw_zm-zdsm.
            if sy-subrc = 0.
              gw_zm_sale-zdsm = lw_zm-zdsm.
            endif.
          endif.
        endif.
      endif.

      collect gw_zm_sale into gt_zm_sale.
      clear  gw_zm_sale.
    endloop.
  endif.

*** net sale value in Rs. for prev.year date
  clear gt_zrcumpso_py[].
  clear lv_sdate.
  lv_sdate = gv_py_dt1.
  while lv_sdate <= gv_py_dt2.
    select * from zrcumpso appending table gt_zrcumpso_py
       where zyear = lv_sdate+0(4)
       and zmonth = lv_sdate+4(2).

    call function 'RE_ADD_MONTH_TO_DATE'
      exporting
        months  = '1'
        olddate = lv_sdate
      importing
        newdate = lv_sdate.

  endwhile.
  if gt_zrcumpso_py[] is not initial.
    clear gt_zrcumpso_py_add[].
    loop at gt_zrcumpso_py into gw_zrcumpso_py.
      clear : gw_zrcumpso_py-pso , gw_zrcumpso_py-join_dt,gw_zrcumpso_py-zmonth, gw_zrcumpso_py-zyear.
      collect gw_zrcumpso_py into gt_zrcumpso_py_add.
      clear gw_zrcumpso_py.
    endloop.

    loop at gt_zrcumpso_py_add into gw_zrcumpso_py_add.
      clear gw_rm.
      read table gt_rm into gw_rm with key bzirk = gw_zrcumpso_py_add-bzirk.
      if sy-subrc = 0.
        clear gw_zm.
        read table gt_zm into gw_zm with key bzirk = gw_rm-zdsm.
        if gw_zm-zdsm+0(2) = 'D-'.
          gw_zm_sale-zdsm = gw_zm-zdsm.
        else.
          clear lw_zm.
          read table gt_zm into lw_zm with key bzirk = gw_zm-zdsm.
          if sy-subrc = 0.
            gw_zm_sale-zdsm = lw_zm-zdsm.
          endif.
        endif.
      endif.
      gw_zm_sale-psales = gw_zrcumpso_py_add-netval .

      collect gw_zm_sale into gt_zm_sale.
      clear  gw_zm_sale.
    endloop.
  endif.



  if gt_zm_sale[] is not initial.

    loop at gt_zm_sale into gw_zm_sale.

      gw_vfdata-bzirk =   gw_zm_sale-zdsm.
      gw_vfdata-d_bzirk =   gw_zm_sale-zdsm.
      gw_vfdata-sales =   gw_zm_sale-sales.
      gw_vfdata-psales =   gw_zm_sale-psales.
      gw_vfdata-target =   gw_zm_sale-target.

*****      read table gt_ztotpso_add into gw_ztotpso with key bzirk = gw_zm_sale-zdsm.
      loop at gt_ztotpso_add into gw_ztotpso where bzirk = gw_zm_sale-zdsm.
*****        if sy-subrc = 0.
        gw_vfdata-totpso =   gw_vfdata-totpso + gw_ztotpso-bcl + gw_ztotpso-bc + gw_ztotpso-xl + gw_ztotpso-ls .
******        gw_rm_sale-totpso = gw_rm_sale-totpso +  gw_ztotpso-bcl + gw_ztotpso-bc + gw_ztotpso-xl .
*****        endif.
      endloop.


      if gw_vfdata-target > 0.
        gw_vfdata-pertgt =  gw_vfdata-sales / gw_vfdata-target * 100  .
      else.
        gw_vfdata-pertgt = 0.
      endif.
      if gw_vfdata-totpso > 0.
        gw_vfdata-ypm =  gw_vfdata-sales / gw_vfdata-totpso.
      else.
        gw_vfdata-ypm = 0.
      endif.

      clear gw_zdsmter.
      read table gt_zdsmter into gw_zdsmter with key bzirk = gw_zm_sale-zdsm.
      if sy-subrc = 0.
        case gw_zdsmter-spart.
          when '50'.
            clear lw_zdsmter.
            read table gt_zdsmter into lw_zdsmter with key bzirk = gw_zm_sale-zdsm spart = '60'.
            if sy-subrc = 0.
              gw_vfdata-div = 'BCL'.
            else.
              gw_vfdata-div = 'BC'.
            endif.
          when '60'.
            clear lw_zdsmter.
            read table gt_zdsmter into lw_zdsmter with key bzirk = gw_zm_sale-zdsm spart = '50'.
            if sy-subrc = 0.
              gw_vfdata-div = 'BCL'.
            else.
              gw_vfdata-div = 'XL'.
            endif.
          when '70'.
            gw_vfdata-div = 'BCLS'.
        endcase.
      endif.
      read table gt_yterr into gw_yterr with key bzirk = gw_zm_sale-zdsm.
      if sy-subrc = 0.
        read table gt_0001 into gw_0001 with key plans  =  gw_yterr-plans .
        if sy-subrc = 0.
          gw_vfdata-pernr = gw_0001-pernr01.
          gw_vfdata-ename = gw_0001-ename.
          gw_vfdata-doj = gw_0001-dtjoin.

**** designation
*****          SELECT SINGLE mc_short FROM hrp1000 INTO gw_vfdata-des
*****            WHERE plvar = '01'
*****            AND otype  = 'S'
*****            AND objid =  gw_yterr-plans
*****            AND endda EQ '99991231'
*****            AND langu = sy-langu.

          if gw_0001-persk = 25.
            gw_vfdata-des =  'SZM'.
          elseif gw_0001-persk = 26.
            gw_vfdata-des =  'ZM'.
          elseif gw_0001-persk = 53.
            gw_vfdata-des =  'SE'.
          elseif gw_0001-persk = 51.
            gw_vfdata-des =  'TM'.
          elseif gw_0001-persk = 54.
            gw_vfdata-des =  'SABM'.
          elseif gw_0001-persk = 43.
            gw_vfdata-des =  'DZM'.
          elseif gw_0001-persk = 44.
            gw_vfdata-des =  'SRM'.
          elseif gw_0001-persk = 45.
            gw_vfdata-des =  'RM'.
          elseif gw_0001-persk = 50.
            gw_vfdata-des =  'ABM'.
          endif.

          gw_vfdata-zz_hqcode = gw_0001-zz_hqcode.
          read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_0001-zz_hqcode.
          if sy-subrc = 0.
            gw_vfdata-zz_hqdesc = gw_hq_des-zz_hqdesc.
          endif.
        else.
          gw_vfdata-ename = 'VACANT'.
          clear lw_zdrphq.
          select single * from zdrphq into lw_zdrphq where bzirk = gw_zm_sale-zdsm.
          if sy-subrc = 0.
            read table gt_hq_des into gw_hq_des with key zz_hqcode = lw_zdrphq-zz_hqcode.
            if sy-subrc = 0.
              gw_vfdata-zz_hqdesc = gw_hq_des-zz_hqdesc.
            endif.
          endif.
*****          gw_vfdata-zz_hqdesc = gw_yterr-bztxt.
        endif.
      endif.


**** zm name
      read table gt_yterr into gw_yterr with key bzirk = gw_vfdata-d_bzirk.
      if sy-subrc = 0.
        read table gt_0001 into gw_0001 with key plans  =  gw_yterr-plans .
        if sy-subrc = 0.
          gw_vfdata-zmname = gw_0001-ename.
        else.
          gw_vfdata-zmname =  'VACANT'.
        endif.
      endif.

*****   growth
      if gw_vfdata-psales ne 0 .
        gw_vfdata-grth = ( gw_vfdata-sales - gw_vfdata-psales ) /  gw_vfdata-psales * 100.
      else.
        gw_vfdata-grth = 100 .
      endif.

      append gw_vfdata to gt_vfdata.
      clear gw_vfdata.
    endloop.
  endif.

  if gt_vfdata[] is not initial.
    sort gt_vfdata by div.
**** check if division is selected at input.
    clear gt_vfdata_tmp[].
    if cb_bc = 'X'.
      loop at gt_vfdata into gw_vfdata where div = 'BC'.
        append gw_vfdata to gt_vfdata_tmp.
        clear gw_vfdata.
      endloop.
    endif.
    if cb_xl = 'X'.
      loop at gt_vfdata into gw_vfdata where div = 'XL'.
        append gw_vfdata to gt_vfdata_tmp.
        clear gw_vfdata.
      endloop.
    endif.
    if cb_bcl = 'X'.
      loop at gt_vfdata into gw_vfdata where div = 'BCL'.
        append  gw_vfdata to gt_vfdata_tmp.
        clear gw_vfdata.
      endloop.
    endif.

    if cb_ls = 'X'.
      loop at gt_vfdata into gw_vfdata where div = 'BCLS'.
        append  gw_vfdata to gt_vfdata_tmp.
        clear gw_vfdata.
      endloop.
    endif.

    if gt_vfdata_tmp[] is not initial.
      clear gt_vfdata[].
****** for bulletin - delete vacant and %TGT < 100
      if p_rad4 = abap_true.
        sort gt_vfdata_tmp[] by pernr.
        delete gt_vfdata_tmp[] where pernr = '00000000'.
****** for bulletin - delete pertgt < 100
        if p_per = abap_true.
          sort gt_vfdata_tmp[] by pertgt.
          delete gt_vfdata_tmp[] where pertgt < 100.
        endif.
****** for bulletin - delete ypm/productivity < 5 lacs when ZMs
        if p_sale = abap_true.
          if p_ypm is not initial.
            sort gt_vfdata_tmp[] by div ypm.
            if cb_ls = abap_true.
              delete gt_vfdata_tmp[] where ypm < p_ypm.
            else.
              delete gt_vfdata_tmp[] where ypm < p_ypm.
            endif.
          else.
            message 'Pls mention Min.YPM value for ZMs' type 'I'.
          endif.
        endif.
      endif.
      gt_vfdata[] = gt_vfdata_tmp[].
*****    else.
*****      if gt_vfdata[] is not initial.
*********** for bulletin - delete vacant and %TGT < 100
*****        if p_rad4 = abap_true.
*****          sort gt_vfdata[] by pernr.
*****          delete gt_vfdata[] where pernr = '00000000'.
*********** for bulletin - delete pertgt < 100
*****          if p_per = abap_true.
*****            sort gt_vfdata[] by pertgt.
*****            delete gt_vfdata[] where pertgt < 100.
*****          endif.
*****        endif.
*****      endif.
    endif.
    if gt_vfdata[] is not initial.
**** for target% wise ranking
      if p_per = abap_true.
        sort  gt_vfdata by pertgt descending.
      endif.
**** for sale wise ranking
      if p_sale = abap_true.
        sort  gt_vfdata by sales descending.
      endif.
      clear lv_srno.
      lv_srno = 1.
      loop at gt_vfdata into gw_vfdata.
***** Update ranking/sr.no as per selected criteria
        gw_vfdata-srno = lv_srno.
        lv_srno = lv_srno + 1.
        modify gt_vfdata from gw_vfdata transporting srno.
        clear gw_vfdata.
      endloop.
***** check if max.top count is entered.
      if p_cnt is not initial.
        sort gt_vfdata by srno.
        delete gt_vfdata where srno > p_cnt.
      endif.
    else.
      message 'No data found.' type 'I'.
    endif.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  GET_ZM_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form get_zm_data .
  data : lv_srno      type i,
         lw_yterr     type ty_yterr,
         lw_zdrphq    type zdrphq,
         lv_month_cnt type i,
         lv_date      type sy-datum,
         lv_sdate     type sy-datum,
         lv_edate     type sy-datum,
         lv_mnth      type i,
         lw_mtpt      type zmtpt,
         lv_trgt_yr   type i,
         lv_trgt_val  type p.

**** get prev.year dates from entered s_date
  clear  gv_py_dt1.
  call function 'RP_CALC_DATE_IN_INTERVAL'
    exporting
      date      = s_date-low
      days      = 0
      months    = 0
      signum    = '-'
      years     = 1
    importing
      calc_date = gv_py_dt1.

  clear gv_py_dt2.
  call function 'RP_CALC_DATE_IN_INTERVAL'
    exporting
      date      = s_date-high
      days      = 0
      months    = 0
      signum    = '-'
      years     = 1
    importing
      calc_date = gv_py_dt2.

***** months difference between entered dates
  clear lv_month_cnt.
  if s_date-low+4(2) = s_date-high+4(2).
    lv_month_cnt = 1.
  elseif s_date-low+4(2) <> s_date-high+4(2) and s_date-low+0(4) = s_date-high+0(4).
    lv_month_cnt = s_date-high+4(2) -  s_date-low+4(2) + 1.
  elseif s_date-low+4(2) <> s_date-high+4(2) and s_date-low+0(4) <> s_date-high+0(4).
    lv_month_cnt = 12 -  s_date-low+4(2) + 1.
    lv_month_cnt = lv_month_cnt + s_date-high+4(2).
  endif.

****  target year
  clear lv_trgt_yr.
  if s_date-high+4(2) < 4.
    lv_trgt_yr = s_date-high+0(4) - 1.
  else.
    lv_trgt_yr = s_date-low+0(4).
  endif.

*****  IF p_zone IS NOT INITIAL.
*****    CLEAR :gt_zdsmter[].
*****    SELECT * FROM zdsmter INTO TABLE gt_zdsmter
*****      WHERE zdsm = p_zone
*****      AND zmonth EQ s_date-high+4(2)
*****      AND zyear EQ s_date-high(4).
*****  ELSE.
  clear :gt_zdsmter[].
  select * from zdsmter into table gt_zdsmter
    where zmonth eq p_adate+4(2)"s_date-high+4(2)
    and zyear eq p_adate+0(4)."s_date-high(4).
*****  ENDIF.

  if gt_zdsmter[] is not initial.

    sort gt_zdsmter[] by zdsm.
**** get ZMs
    clear gt_zm[].
    gt_zm[] = gt_zdsmter[].
    delete gt_zm where zdsm+0(2) = 'R-'.
    sort gt_zm by zdsm bzirk.
    delete adjacent duplicates from gt_zm comparing zdsm bzirk.
**** get RMs
    clear gt_rm[].
    gt_rm[] = gt_zdsmter[].
    delete gt_rm where zdsm+0(2) = 'D-'.
    sort gt_rm by zdsm bzirk.
    delete adjacent duplicates from gt_rm comparing zdsm bzirk.

    clear gt_yterr[].
    select a~spart a~bzirk a~endda a~begda a~plans
           b~bztxt into table gt_yterr
      from yterrallc as a inner join t171t as b
      on a~bzirk = b~bzirk
      where a~endda = '99991231'
      and b~spras = sy-langu.

    clear gt_0001[].
    select a~pernr a~begda
           b~pernr b~begda b~endda b~abkrs b~ansvh b~persk b~plans b~ename b~zz_hqcode into table gt_0001
      from pa0000 as a inner join pa0001 as b
      on a~pernr = b~pernr
      where a~massn = '01'
      and b~endda eq '99991231'.

***** HQ des
    clear gt_hq_des[].
    select * from zthr_heq_des into table gt_hq_des.
  endif.

***** total PSO's
  clear gt_ztotpso[].
  select * from ztotpso into table gt_ztotpso
    where begda between s_date-low and s_date-high
    and bzirk like 'D-%'.
  if sy-subrc = 0.
    loop at gt_ztotpso into gw_ztotpso.
      clear: gw_ztotpso-begda,
             gw_ztotpso-endda.
      collect gw_ztotpso into gt_ztotpso_add.
      clear gw_ztotpso.
    endloop.
  endif.

  if p_group = 'X' .
***** get materials from prd.group.
    clear gt_prdgrp[].
    select * from zprdgroup into table gt_prdgrp
      where rep_type = 'SR121314'
      and grp_code in s_grp.
    if gt_prdgrp[] is not initial.
      sort gt_prdgrp[] by prd_code.
***** get sales current date - product Group-wise
      clear gt_zrpqv[].
      clear lv_sdate.
      lv_sdate = s_date-low.
      while lv_sdate <= s_date-high.
        select * from zrpqv appending table gt_zrpqv
          for all entries in gt_prdgrp
          where zmonth = lv_sdate+4(2)
          and zyear = lv_sdate+0(4)
          and matnr = gt_prdgrp-prd_code.

        call function 'RE_ADD_MONTH_TO_DATE'
          exporting
            months  = '1'
            olddate = lv_sdate
          importing
            newdate = lv_sdate.

      endwhile.
***** get sales previous year dates - product Group-wise
      clear gt_zrpqv_py[].
      clear lv_sdate.
      lv_sdate = gv_py_dt1.
      while lv_sdate <= gv_py_dt2.
        select * from zrpqv appending table gt_zrpqv_py
          for all entries in gt_prdgrp
          where zmonth = lv_sdate+4(2)
          and zyear = lv_sdate+0(4)
          and matnr = gt_prdgrp-prd_code.

        call function 'RE_ADD_MONTH_TO_DATE'
          exporting
            months  = '1'
            olddate = lv_sdate
          importing
            newdate = lv_sdate.

      endwhile.
    endif.
***** get target data as per target year
    clear gt_target[].
    select * from ysd_dist_targt into table gt_target
      where trgyear = lv_trgt_yr.
  endif.
  if p_prod = 'X'.
***** get sales current date - product-wise
    clear gt_zrpqv[].
    clear lv_sdate.
    lv_sdate = s_date-low.
    while lv_sdate <= s_date-high.
      select * from zrpqv appending table gt_zrpqv
        where zmonth = lv_sdate+4(2)
        and zyear = lv_sdate+0(4)
        and matnr in s_mat.
      call function 'RE_ADD_MONTH_TO_DATE'
        exporting
          months  = '1'
          olddate = lv_sdate
        importing
          newdate = lv_sdate.

    endwhile.
***** get sales previous year dates - product-wise
    clear gt_zrpqv_py[].
    clear lv_sdate.
    lv_sdate = gv_py_dt1.
    while lv_sdate <= gv_py_dt2.
      select * from zrpqv appending table gt_zrpqv_py
        where zmonth = lv_sdate+4(2)
        and zyear = lv_sdate+0(4)
        and matnr in s_mat.
      call function 'RE_ADD_MONTH_TO_DATE'
        exporting
          months  = '1'
          olddate = lv_sdate
        importing
          newdate = lv_sdate.

    endwhile.
  endif.


  if gt_zrpqv[] is not initial.
    clear gt_zrpqv_add[].
    loop at gt_zrpqv into gw_zrpqv.
      gw_zrpqv_add-bzirk = gw_zrpqv-bzirk.
      gw_zrpqv_add-grosspts = gw_zrpqv-grosspts .
      gw_zrpqv_add-grossqty = gw_zrpqv-grossqty .
      gw_zrpqv_add-rval = gw_zrpqv-rval.
      gw_zrpqv_add-rqty = gw_zrpqv-rqty.
      gw_zrpqv_add-nepval = gw_zrpqv-nepval.
      gw_zrpqv_add-nepqty = gw_zrpqv-nepqty.
      collect gw_zrpqv_add into gt_zrpqv_add.
      clear  gw_zrpqv_add.
    endloop.
  endif.
  clear gt_zrpqv_py_add[].
  loop at gt_zrpqv_py into gw_zrpqv_py.
    gw_zrpqv_py_add-bzirk = gw_zrpqv_py-bzirk.
    gw_zrpqv_py_add-grosspts = gw_zrpqv_py-grosspts .
    gw_zrpqv_py_add-grossqty = gw_zrpqv_py-grossqty .
    gw_zrpqv_py_add-rval = gw_zrpqv_py-rval.
    gw_zrpqv_py_add-rqty = gw_zrpqv_py-rqty.
    gw_zrpqv_py_add-nepval = gw_zrpqv_py-nepval.
    gw_zrpqv_py_add-nepqty = gw_zrpqv_py-nepqty.
    collect gw_zrpqv_py_add into gt_zrpqv_py_add.
    clear  gw_zrpqv_py_add.
  endloop.

  if gt_zrpqv_add[] is not initial.
    clear gt_zm_sale[].
    loop at gt_zrpqv_add into gw_zrpqv_add.
      clear gw_rm.
      read table gt_rm into gw_rm with key bzirk = gw_zrpqv_add-bzirk.
      if sy-subrc = 0.
        clear gw_zm.
        read table gt_zm into gw_zm with key bzirk = gw_rm-zdsm.
        if sy-subrc = 0.
          gw_zm_sale-zdsm = gw_zm-zdsm.
        endif.
      endif.

      gw_zm_sale-sales = gw_zrpqv_add-grosspts .
      gw_zm_sale-qty = gw_zrpqv_add-grossqty .

**** target
      clear lv_trgt_val.
      read table gt_target into gw_target with key bzirk = gw_zrpqv_add-bzirk.
      if sy-subrc = 0.
*****        lv_date = s_date-low.
*****        lv_mnth = s_date-low+4(2).
*****
*****        while lv_date <= s_date-high.
*****          if lv_mnth = 4.
*****            lv_trgt_val = lv_trgt_val + gw_target-month01.
*****          elseif lv_mnth = 5.
*****            lv_trgt_val = lv_trgt_val + gw_target-month02.
*****          elseif lv_mnth = 6.
*****            lv_trgt_val = lv_trgt_val + gw_target-month03.
*****          elseif lv_mnth = 7.
*****            lv_trgt_val = lv_trgt_val + gw_target-month04.
*****          elseif lv_mnth = 8.
*****            lv_trgt_val = lv_trgt_val + gw_target-month05.
*****          elseif lv_mnth = 9.
*****            lv_trgt_val = lv_trgt_val + gw_target-month06.
*****          elseif lv_mnth = 10.
*****            lv_trgt_val = lv_trgt_val + gw_target-month07.
*****          elseif lv_mnth = 11.
*****            lv_trgt_val = lv_trgt_val + gw_target-month08.
*****          elseif lv_mnth = 12.
*****            lv_trgt_val = lv_trgt_val + gw_target-month09.
*****          elseif lv_mnth = 1.
*****            lv_trgt_val = lv_trgt_val + gw_target-month10.
*****          elseif lv_mnth = 2.
*****            lv_trgt_val = lv_trgt_val + gw_target-month11.
*****          elseif lv_mnth = 3.
*****            lv_trgt_val = lv_trgt_val + gw_target-month12.
*****          endif.
*****
*****          call function 'RE_ADD_MONTH_TO_DATE'
*****            exporting
*****              months  = '1'
*****              olddate = lv_date
*****            importing
*****              newdate = lv_date.
*****
*****          lv_mnth = lv_date+4(2).
*****        endwhile.
*****        gw_zm_sale-target = lv_trgt_val.
*************************  Commented above and added below to consider month-wise MTPT based on month-wise target   ******************
        lv_mnth = s_date-high+4(2).
        case lv_mnth.
          when '4'.
            gw_zm_sale-target = gw_target-month01.
          when '5'.
            gw_zm_sale-target = gw_target-month02.
          when '6'.
            gw_zm_sale-target = gw_target-month03.
          when '7'.
            gw_zm_sale-target = gw_target-month04.
          when '8'.
            gw_zm_sale-target = gw_target-month05.
          when '9'.
            gw_zm_sale-target = gw_target-month06.
          when '10'.
            gw_zm_sale-target = gw_target-month07.
          when '11'.
            gw_zm_sale-target = gw_target-month08.
          when '12'.
            gw_zm_sale-target = gw_target-month09.
          when '1'.
            gw_zm_sale-target = gw_target-month10.
          when '2'.
            gw_zm_sale-target = gw_target-month11.
          when '3'.
            gw_zm_sale-target = gw_target-month12.
        endcase.
      endif.

      collect gw_zm_sale into gt_zm_sale.
      clear  gw_zm_sale.
    endloop.
  endif.

  if gt_zrpqv_py_add[] is not initial.
    loop at gt_zrpqv_py_add into gw_zrpqv_py_add.

      clear gw_rm.
      read table gt_rm into gw_rm with key bzirk = gw_zrpqv_py_add-bzirk.
      if sy-subrc = 0.
        clear gw_zm.
        read table gt_zm into gw_zm with key bzirk = gw_rm-zdsm.
        if sy-subrc = 0.
          gw_zm_sale-zdsm = gw_zm-zdsm.
        endif.
      endif.

      gw_zm_sale-psales = gw_zrpqv_py_add-grosspts .
      gw_zm_sale-pqty = gw_zrpqv_py_add-grossqty .
      collect gw_zm_sale into gt_zm_sale.
      clear  gw_zm_sale.
    endloop.
  endif.

  if gt_zm_sale[] is not initial.
    loop at gt_zm_sale into gw_zm_sale.


      gw_fdata-sales = gw_zm_sale-sales.
      gw_fdata-qty = gw_zm_sale-qty.
      gw_fdata-psales = gw_zm_sale-psales.
      gw_fdata-pqty = gw_zm_sale-pqty.
      gw_fdata-bzirk = gw_zm_sale-zdsm.
      gw_fdata-zdsm = gw_zm_sale-zdsm.

      gw_fdata-avgsales = gw_zm_sale-sales / lv_month_cnt.
      gw_fdata-avgqty = gw_zm_sale-qty / lv_month_cnt.

***** target
      gw_fdata-target = gw_zm_sale-target.

**** growth value
      if gw_fdata-psales ne 0 .
        gw_fdata-grth = ( gw_fdata-sales - gw_fdata-psales ) /  gw_fdata-psales * 100.
      else.
        gw_fdata-grth = 100 .
      endif.

***** growth Qty.
      if gw_fdata-pqty ne 0 .
        gw_fdata-grth_p = ( gw_fdata-qty - gw_fdata-pqty ) /  gw_fdata-pqty * 100.
      else.
        gw_fdata-grth_p = 100 .
      endif.

      read table gt_yterr into gw_yterr with key bzirk = gw_zm_sale-zdsm.
      if sy-subrc = 0.
        case gw_yterr-spart.
          when '50'.
            clear lw_yterr.
            read table gt_yterr into lw_yterr with key bzirk = gw_zm_sale-zdsm spart = '60'.
            if sy-subrc = 0.
              gw_fdata-div = 'BCL'.
            else.
              gw_fdata-div = 'BC'.
            endif.
          when '60'.
            clear lw_yterr.
            read table gt_yterr into lw_yterr with key bzirk = gw_zm_sale-zdsm spart = '50'.
            if sy-subrc = 0.
              gw_fdata-div = 'BCL'.
            else.
              gw_fdata-div = 'XL'.
            endif.
          when '70'.
            gw_fdata-div = 'BCLS'.
        endcase.
        read table gt_0001 into gw_0001 with key plans  =  gw_yterr-plans .
        if sy-subrc = 0.
          gw_fdata-pernr = gw_0001-pernr01.
          gw_fdata-ename = gw_0001-ename.
          gw_fdata-doj = gw_0001-dtjoin.

**** designation
          select single mc_short from hrp1000 into gw_fdata-des
            where plvar = '01'
            and otype  = 'S'
            and objid =  gw_yterr-plans
            and endda eq '99991231'
            and langu = sy-langu.

          gw_fdata-zz_hqcode = gw_0001-zz_hqcode.
          read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_0001-zz_hqcode.
          if sy-subrc = 0.
            gw_fdata-zz_hqdesc = gw_hq_des-zz_hqdesc.
          endif.
        else.
          gw_fdata-ename = 'VACANT'.
          clear lw_zdrphq.
          select single * from zdrphq into lw_zdrphq where bzirk = gw_zm_sale-zdsm.
          if sy-subrc = 0.
            read table gt_hq_des into gw_hq_des with key zz_hqcode = lw_zdrphq-zz_hqcode.
            if sy-subrc = 0.
              gw_fdata-zz_hqdesc = gw_hq_des-zz_hqdesc.
            endif.
          endif.
*****          gw_fdata-zz_hqdesc = gw_yterr-bztxt.
        endif.
      endif.

**** zm name
      read table gt_yterr into gw_yterr with key bzirk = gw_fdata-zdsm.
      if sy-subrc = 0.
        read table gt_0001 into gw_0001 with key plans  =  gw_yterr-plans .
        if sy-subrc = 0.
          gw_fdata-zmname = gw_0001-ename.
        else.
          gw_fdata-zmname =  'VACANT'.
        endif.
      endif.

*****no of pso's
      read table gt_ztotpso_add into gw_ztotpso with key bzirk = gw_fdata-zrsm.
      if sy-subrc = 0.
        if gw_fdata-div = 'BC' and gw_ztotpso-spart = '50'.
          gw_fdata-totpso =  gw_ztotpso-bcl + gw_ztotpso-bc - gw_ztotpso-hbe.
        elseif  gw_fdata-div = 'XL' and gw_ztotpso-spart = '60'.
          gw_fdata-totpso = gw_ztotpso-bcl + gw_ztotpso-xl - gw_ztotpso-hbe. .
        elseif  gw_fdata-div = 'BC' and gw_ztotpso-spart = '99'.
          gw_fdata-totpso =   gw_ztotpso-bcl + gw_ztotpso-bc   - gw_ztotpso-hbe. .
        elseif   gw_fdata-div = 'XL' and gw_ztotpso-spart = '99'.
          gw_fdata-totpso =   gw_ztotpso-xl + gw_ztotpso-bcl   - gw_ztotpso-hbe. .
        elseif  gw_fdata-div = 'BCL' and gw_ztotpso-spart = '99'.
          gw_fdata-totpso =  gw_ztotpso-bc + gw_ztotpso-xl + gw_ztotpso-bcl   - gw_ztotpso-hbe.
        endif.
      endif.

      if gw_fdata-totpso ne 0 .
        gw_fdata-ypm =  gw_fdata-sales   /  gw_fdata-totpso.
      else.
        gw_fdata-ypm = 100 .
      endif.

      append gw_fdata to gt_fdata.
      clear gw_fdata.
    endloop.
  endif.

****** update sr.no
  if gt_fdata[] is not initial.
    sort gt_fdata by div.
**** check if division is selected at input.
    clear gt_fdata_tmp[].
    if cb_bc = 'X'.
      loop at gt_fdata into gw_fdata where div = 'BC'.
        append gw_fdata to gt_fdata_tmp.
        clear gw_fdata.
      endloop.
    endif.
    if cb_xl = 'X'.
      loop at gt_fdata into gw_fdata where div = 'XL'.
        append gw_fdata to gt_fdata_tmp.
        clear gw_fdata.
      endloop.
    endif.
    if cb_bcl = 'X'.
      loop at gt_fdata into gw_fdata where div = 'BCL'.
        append  gw_fdata to gt_fdata_tmp.
        clear gw_fdata.
      endloop.
    endif.

    if cb_ls = 'X'.
      loop at gt_fdata into gw_fdata where div = 'BCLS'.
        append  gw_fdata to gt_fdata_tmp.
        clear gw_fdata.
      endloop.
    endif.

**** for zone-wise as per input zone
    if p_zone is not initial.
      clear gt_fdata_tmp1[].
      loop at gt_fdata_tmp into gw_fdata_tmp where zdsm = p_zone.
        append  gw_fdata_tmp to gt_fdata_tmp1.
        clear gw_fdata.
      endloop.

      sort gt_fdata_tmp1[] by zdsm zrsm bzirk.
      delete adjacent duplicates from gt_fdata_tmp1[] comparing zdsm zrsm bzirk.
    else.  "....if no zone is entered at input
      clear gt_fdata_tmp1[].
      gt_fdata_tmp1[] = gt_fdata_tmp[].

      sort gt_fdata_tmp1[] by zdsm zrsm bzirk.
      delete adjacent duplicates from gt_fdata_tmp1[] comparing zdsm zrsm bzirk.
    endif.

***** get final data into GT_FINAL[] - for display
    clear gt_fdata[].
    gt_fdata[] = gt_fdata_tmp1[].
    if gt_fdata[] is not initial.

***** mtpt
      if gt_fdata[] is not initial and p_group = 'X' and p_rad1 = 'X'.
        loop at gt_fdata into gw_fdata.
          if gw_fdata-target > 0.
            if s_grp[] is not initial.
              clear lw_mtpt.
              select single * from zmtpt into lw_mtpt
                where matkl in s_grp
                and  zmtpt~begda le s_date-high and zmtpt~endda ge s_date-low
                and from_amt le gw_fdata-target and to_amt ge gw_fdata-target.
            else.
              clear lw_mtpt.
              select single * from zmtpt into lw_mtpt
                where zmtpt~begda le s_date-high and zmtpt~endda ge s_date-low
                and from_amt le gw_fdata-target and to_amt ge gw_fdata-target.
            endif.
            if sy-subrc = 0.
*****              gw_fdata-mtpt = lw_mtpt-target * lv_month_cnt.
*************************  Commented above and added below to consider month-wise MTPT based on month-wise target   ******************
              gw_fdata-mtpt = lw_mtpt-target .
              modify gt_fdata index sy-tabix from gw_fdata transporting mtpt.
            endif.
          endif.
        endloop.
      endif.


**** for Qty.wise ranking
      if p_qty = 'X'.
        sort  gt_fdata by qty descending.
      endif.
**** for Val.wise ranking
      if p_val = 'X'.
        sort  gt_fdata by sales descending.
      endif.
      clear lv_srno.
      lv_srno = 1.
      loop at gt_fdata into gw_fdata.
***** Update ranking/sr.no as per selected criteria
        gw_fdata-srno = lv_srno.
        lv_srno = lv_srno + 1.
        modify gt_fdata from gw_fdata transporting srno.
        clear gw_fdata.
      endloop.
***** check if max.top count is entered.
      if p_cnt is not initial.
        sort gt_fdata by srno.
        delete gt_fdata where srno > p_cnt.
      endif.
    else.
      message 'No data found.' type 'I'.
    endif.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form display_layout .
  data: fm_name    type  tdsfname,
        lv_date    type string,
        lt_tp      type sorted table of textpool with unique key id key,
        lw_tp      type textpool,
        lv_dt_str  type string,
        lv_dt_str1 type string.


***** get title/header of layout as per input selections considering selection-texts
  read textpool sy-repid : into lt_tp language sy-langu.
  clear gv_rep_hdr.
  if p_prod = 'X'.
    read table lt_tp into lw_tp with key key = 'P_PROD'.
    if sy-subrc = 0.
      condense lw_tp-entry.
      gv_rep_hdr = lw_tp-entry.
    endif.
  elseif p_group = 'X'.
    read table lt_tp into lw_tp with key key = 'P_GROUP'.
    if sy-subrc = 0.
      condense lw_tp-entry.
      gv_rep_hdr = lw_tp-entry.
    endif.
  else.
*****    READ TABLE lt_tp INTO lw_tp WITH KEY key = 'P_VALUE'.
*****    IF sy-subrc = 0.
*****      CONDENSE lw_tp-entry.
*****      gv_rep_hdr = lw_tp-entry.
*****    ENDIF.
  endif.

  if p_pso = 'X'.
    read table lt_tp into lw_tp with key key = 'P_PSO'.
    if sy-subrc = 0.
      condense lw_tp-entry.
      concatenate gv_rep_hdr 'TOP' lw_tp-entry into gv_rep_hdr separated by space.
    endif.
  elseif p_rm = 'X'.
    read table lt_tp into lw_tp with key key = 'P_RM'.
    if sy-subrc = 0.
      condense lw_tp-entry.
      concatenate gv_rep_hdr 'TOP' lw_tp-entry into gv_rep_hdr separated by space.
    endif.
  else.
    read table lt_tp into lw_tp with key key = 'P_ZM'.
    if sy-subrc = 0.
      condense lw_tp-entry.
      concatenate gv_rep_hdr 'TOP' lw_tp-entry into gv_rep_hdr separated by space.
    endif.
  endif.


  if p_qty = 'X'.    "**** for qty.
*****    READ TABLE lt_tp INTO lw_tp WITH KEY key = 'P_QTY'.
*****    IF sy-subrc = 0.
*****      CONDENSE lw_tp-entry.
    concatenate gv_rep_hdr '(UNITS WISE)' into gv_rep_hdr separated by space.
*****    ENDIF.
  elseif p_val = 'X'.     "**** for val
******    read table lt_tp into lw_tp with key key = 'P_VAL'.
******    if sy-subrc = 0.
******      condense lw_tp-entry.
******      translate lw_tp-entry to upper case.
    concatenate gv_rep_hdr '(VALUE WISE)' into gv_rep_hdr separated by space.
*****    endif.
  elseif p_per = 'X'.       "**** for target %
*****    read table lt_tp into lw_tp with key key = 'P_PER'.
*****    if sy-subrc = 0.
*****      condense lw_tp-entry.
*****      translate lw_tp-entry to upper case.
    concatenate gv_rep_hdr '(PERCENTAGE WISE)' into gv_rep_hdr separated by space.
*****    endif.
  else.             "**** for sale
*****    READ TABLE lt_tp INTO lw_tp WITH KEY key = 'P_SALE'.
*****    IF sy-subrc = 0.
*****      CONDENSE lw_tp-entry.
    concatenate gv_rep_hdr '(RUPEE WISE)' into gv_rep_hdr separated by space.
*****    ENDIF.
  endif.

  clear lv_dt_str.
  concatenate s_date-low+6(2) s_date-low+4(2) s_date-low+0(4) into lv_dt_str separated by '.'.
  clear lv_dt_str1.
  concatenate s_date-high+6(2) s_date-high+4(2) s_date-high+0(4) into lv_dt_str1 separated by '.'.

  concatenate gv_rep_hdr '-' lv_dt_str into gv_rep_hdr separated by space.
  concatenate gv_rep_hdr 'TO' lv_dt_str1 into gv_rep_hdr separated by space.

****** get material/material group details if entered at input
  if s_mat[] is not initial.
    clear gt_s_mat[].
    select * from zsr37_ser into table gt_s_mat
      where matnr in s_mat[].
  endif.
  if s_grp[] is not initial.
    clear gt_s_grp[].
    select * from zsr121314_help into table gt_s_grp
      where grp_code in s_grp[].
  endif.

  clear fm_name.
  call function 'SSF_FUNCTION_MODULE_NAME'
    exporting
      formname = 'ZTOP_PROD_QTY_VAL_SF'
    importing
      fm_name  = fm_name.

*****  gw_output_opts-tdnoprev = gc_true.
*****  gw_output_opts-tddest    = 'LOCL'.
*****  gw_output_opts-tdnoprint = gc_true.
*****
*****  gw_contrl_para-getotf = gc_true.
*****  gw_contrl_para-no_dialog = gc_true.
*****  gw_contrl_para-preview = space.

  gw_output_opts-tdnoprev = space.
  gw_output_opts-tddest    = 'LOCL'.
  gw_output_opts-tdnoprint = space.

  gw_contrl_para-no_dialog = space.
  gw_contrl_para-preview = space.


  call function fm_name
    exporting
*     ARCHIVE_INDEX      =
*     ARCHIVE_INDEX_TAB  =
*     ARCHIVE_PARAMETERS =
      control_parameters = gw_contrl_para
*     MAIL_APPL_OBJ      =
*     MAIL_RECIPIENT     =
*     MAIL_SENDER        =
      output_options     = gw_output_opts
*     USER_SETTINGS      = 'X'
      gv_rep_hdr         = gv_rep_hdr
      p_qty              = p_qty
      p_val              = p_val
      p_per              = p_per
      p_sale             = p_sale
    importing
*     document_output_info =
      job_output_info    = gt_otf_data
*     job_output_options =
    tables
      gt_fdata           = gt_fdata[]
      gt_vfdata          = gt_vfdata[]
      gt_s_mat           = gt_s_mat[]
      gt_s_grp           = gt_s_grp[]
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
  data: fm_name    type  tdsfname,
        lv_date    type string,
        lt_tp      type sorted table of textpool with unique key id key,
        lw_tp      type textpool,
        lv_dt_str  type string,
        lv_dt_str1 type string.


  read textpool sy-repid : into lt_tp language sy-langu.

  clear gv_rep_hdr.
  if p_prod = 'X'.
    read table lt_tp into lw_tp with key key = 'P_PROD'.
    if sy-subrc = 0.
      condense lw_tp-entry.
      gv_rep_hdr = lw_tp-entry.
    endif.
  elseif p_group = 'X'.
    read table lt_tp into lw_tp with key key = 'P_GROUP'.
    if sy-subrc = 0.
      condense lw_tp-entry.
      gv_rep_hdr = lw_tp-entry.
    endif.
  else.
*****    READ TABLE lt_tp INTO lw_tp WITH KEY key = 'P_VALUE'.
*****    IF sy-subrc = 0.
*****      CONDENSE lw_tp-entry.
*****      gv_rep_hdr = lw_tp-entry.
*****    ENDIF.
  endif.

  if p_pso = 'X'.
    read table lt_tp into lw_tp with key key = 'P_PSO'.
    if sy-subrc = 0.
      condense lw_tp-entry.
      concatenate gv_rep_hdr 'TOP' lw_tp-entry into gv_rep_hdr separated by space.
    endif.
  elseif p_rm = 'X'.
    read table lt_tp into lw_tp with key key = 'P_RM'.
    if sy-subrc = 0.
      condense lw_tp-entry.
      concatenate gv_rep_hdr 'TOP' lw_tp-entry into gv_rep_hdr separated by space.
    endif.
  else.
    read table lt_tp into lw_tp with key key = 'P_ZM'.
    if sy-subrc = 0.
      condense lw_tp-entry.
      concatenate gv_rep_hdr 'TOP' lw_tp-entry into gv_rep_hdr separated by space.
    endif.
  endif.


  if p_qty = 'X'.    "**** for qty.
*****    READ TABLE lt_tp INTO lw_tp WITH KEY key = 'P_QTY'.
*****    IF sy-subrc = 0.
*****      CONDENSE lw_tp-entry.
    concatenate gv_rep_hdr '(UNITS WISE)' into gv_rep_hdr separated by space.
*****    ENDIF.
  elseif p_val = 'X'.     "**** for val
*****    read table lt_tp into lw_tp with key key = 'P_VAL'.
*****    if sy-subrc = 0.
*****      condense lw_tp-entry.
*****      translate lw_tp-entry to upper case.
    concatenate gv_rep_hdr '(VALUE WISE)' into gv_rep_hdr separated by space.
*****    endif.
  elseif p_per = 'X'.       "**** for target %
*****    read table lt_tp into lw_tp with key key = 'P_PER'.
*****    if sy-subrc = 0.
*****      condense lw_tp-entry.
*****      translate lw_tp-entry to upper case.
    concatenate gv_rep_hdr '(PERCENTAGE WISE)' into gv_rep_hdr separated by space.
*****    endif.
  else.             "**** for sale
*****    READ TABLE lt_tp INTO lw_tp WITH KEY key = 'P_SALE'.
*****    IF sy-subrc = 0.
*****      CONDENSE lw_tp-entry.
    concatenate gv_rep_hdr '(RUPEE WISE)' into gv_rep_hdr separated by space.
*****    ENDIF.
  endif.

  clear lv_dt_str.
  concatenate s_date-low+6(2) s_date-low+4(2) s_date-low+0(4) into lv_dt_str separated by '.'.
  clear lv_dt_str1.
  concatenate s_date-high+6(2) s_date-high+4(2) s_date-high+0(4) into lv_dt_str1 separated by '.'.

  concatenate gv_rep_hdr '-' lv_dt_str into gv_rep_hdr separated by space.
  concatenate gv_rep_hdr 'TO' lv_dt_str1 into gv_rep_hdr separated by space.

****** get material/material group details if entered at input
  if s_mat[] is not initial.
    clear gt_s_mat[].
    select * from zsr37_ser into table gt_s_mat
      where matnr in s_mat[].
  endif.
  if s_grp[] is not initial.
    clear gt_s_grp[].
    select * from zsr121314_help into table gt_s_grp
      where grp_code in s_grp[].
  endif.

  clear fm_name.
  call function 'SSF_FUNCTION_MODULE_NAME'
    exporting
      formname = 'ZTOP_PROD_QTY_VAL_SF'
    importing
      fm_name  = fm_name.

  gw_output_opts-tdnoprev = gc_true.
  gw_output_opts-tddest    = 'LOCL'.
  gw_output_opts-tdnoprint = gc_true.

  gw_contrl_para-getotf = gc_true.
  gw_contrl_para-no_dialog = gc_true.
  gw_contrl_para-preview = space.



  call function fm_name
    exporting
*     ARCHIVE_INDEX      =
*     ARCHIVE_INDEX_TAB  =
*     ARCHIVE_PARAMETERS =
      control_parameters = gw_contrl_para
*     MAIL_APPL_OBJ      =
*     MAIL_RECIPIENT     =
*     MAIL_SENDER        =
      output_options     = gw_output_opts
*     USER_SETTINGS      = 'X'
      gv_rep_hdr         = gv_rep_hdr
      p_qty              = p_qty
      p_val              = p_val
      p_per              = p_per
      p_sale             = p_sale
    importing
*     document_output_info =
      job_output_info    = gt_otf_data
*     job_output_options =
    tables
      gt_fdata           = gt_fdata[]
      gt_vfdata          = gt_vfdata[]
      gt_s_mat           = gt_s_mat[]
      gt_s_grp           = gt_s_grp[]
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

  if gt_otf[] is not initial.
***xstring to binary
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
        append ' BLUE CROSS LABORATORIES PRIVATE LTD.' to gt_text.

****Add the email body content to document
        clear : gv_text, gv_subject.
*****        CONCATENATE sy-datum+6(2) sy-datum+4(2) sy-datum+0(4) INTO gv_text SEPARATED BY '.'.
*****        CONCATENATE 'CFA excess/shortage stock status as of date' gv_text INTO gv_subject SEPARATED BY space.
        gv_subject = gv_rep_hdr.
        lo_doc_bcs = cl_document_bcs=>create_document(
                       i_type    = 'RAW'
                       i_text    = gt_text[]
                       i_length  = '12'
                       i_subject = gv_subject ).   "Subject of the Email

***     Add attachment to document and Add document to send request
***The internal table gt_pdf_data[] contains the content of our attachment.

        call method lo_doc_bcs->add_attachment
          exporting
            i_attachment_type    = 'PDF'
            i_attachment_size    = gv_bin_filesize
            i_attachment_subject = 'TOPLIST'
            i_att_content_hex    = gt_pdf_data.

*     add document to send request
        call method lo_bcs->set_document( lo_doc_bcs ).

****    Set Sender
        lo_sender = cl_cam_address_bcs=>create_internet_address( i_address_string = gc_email_sender
                                                                 i_address_name = 'TOP PSO/RM/ZM' ).

        call method lo_bcs->set_sender
          exporting
            i_sender = lo_sender.

****    Add recipient (e–mail address)
        lo_recep = cl_cam_address_bcs=>create_internet_address( p_email ).

        "Add recipient with its respective attributes to send request
        call method lo_bcs->add_recipient
          exporting
            i_recipient = lo_recep
            i_express   = gc_true.

****    Set Send Immediately
        call method lo_bcs->set_send_immediately
          exporting
            i_send_immediately = gc_true.

***Send the Email
        call method lo_bcs->send(
          exporting
            i_with_error_screen = gc_true
          receiving
            result              = gv_sent_to_all ).

        if gv_sent_to_all is not initial.
          commit work.
          message 'Email sent successfully' type 'S'.
        endif.

      catch cx_bcs into lo_cx_bcx.
        "Appropriate Exception Handling
        write: 'Exception:', lo_cx_bcx->error_type.
    endtry.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  PREPARE_BULLETIN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form prepare_bulletin .

  types: begin of ty_0002,
           pernr type persno,
           anred type anrde,
         end of ty_0002.

  data : lv_row_cnt  type i,
         lv_row_cnt1 type i,
         lv_cnt_25   type i,
         lv_cnt_1    type i,
         lv_cnt      type i,
         lv_srno     type i.


  data : lw_vfdata    type zty_top_qty_val,
         lt_vfdata_dc type table of zty_top_qty_val,
         lw_vfdata_dc type zty_top_qty_val,
         lt_vfdata_gc type table of zty_top_qty_val,
         lw_vfdata_gc type zty_top_qty_val,
         lt_vfdata_sc type table of zty_top_qty_val,
         lw_vfdata_sc type zty_top_qty_val,
         lt_vfdata_bc type table of zty_top_qty_val,
         lw_vfdata_bc type zty_top_qty_val,
         lt_t522t     type table of t522t,
         lw_t522t     type t522t,
         lt_0002      type table of ty_0002,
         lw_0002      type ty_0002.

  clear lt_0002[].
  select pernr anred from pa0002 into table lt_0002[] where endda = '99991231'.
  if sy-subrc = 0.
    clear lt_t522t[].
    select * from t522t into table lt_t522t where sprsl = sy-langu.

  endif.
  if p_value = abap_true and p_sale = abap_true.
    if s_dclub[] is not initial.
      clear lt_vfdata_dc[].
      lt_vfdata_dc[] = gt_vfdata[].
      delete lt_vfdata_dc[] where sales not between s_dclub-low and s_dclub-high.
      clear : gv_dclub_low, gv_dclub_high.
      catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
        gv_dclub_low = s_dclub-low / 100000.
      endcatch.
      catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
        gv_dclub_high = s_dclub-high / 100000.
      endcatch.
    else.
      message 'Enter sales range' type 'I'.
    endif.

    if s_gclub[] is not initial.
      clear lt_vfdata_gc[].
      lt_vfdata_gc[] = gt_vfdata[].
      delete lt_vfdata_gc[] where sales not between s_gclub-low and s_gclub-high.
      clear : gv_gclub_low, gv_gclub_high.
      catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
        gv_gclub_low = s_gclub-low / 100000.
      endcatch.
      catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
        gv_gclub_high = s_gclub-high / 100000.
      endcatch.
*******  re-initiate SRno.
      if lt_vfdata_gc[] is not initial.
        clear lv_srno.
        lv_srno = 1.
        loop at lt_vfdata_gc into lw_vfdata_gc.
          lw_vfdata_gc-srno = lv_srno.
          lv_srno = lv_srno + 1.
          modify lt_vfdata_gc from lw_vfdata_gc transporting srno.
          clear lw_vfdata_gc.
        endloop.
      endif.
    else.
      message 'Enter sales range' type 'I'.
    endif.

    if s_sclub[] is not initial.
      clear lt_vfdata_sc[].
      lt_vfdata_sc[] = gt_vfdata[].
      delete lt_vfdata_sc[] where sales not between s_sclub-low and s_sclub-high.
      clear : gv_sclub_low, gv_sclub_high.
      catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
        gv_sclub_low = s_sclub-low / 100000.
      endcatch.
      catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
        gv_sclub_high = s_sclub-high / 100000.
      endcatch.
*******  re-initiate SRno.
      if lt_vfdata_gc[] is not initial.
        clear lv_srno.
        lv_srno = 1.
        loop at lt_vfdata_sc into lw_vfdata_sc.
          lw_vfdata_sc-srno = lv_srno.
          lv_srno = lv_srno + 1.
          modify lt_vfdata_sc from lw_vfdata_sc transporting srno.
          clear lw_vfdata_sc.
        endloop.
      endif.
    else.
      message 'Enter sales range' type 'I'.
    endif.

    if s_bclub[] is not initial.
      clear lt_vfdata_bc[].
      lt_vfdata_bc[] = gt_vfdata[].
      delete lt_vfdata_bc[] where sales not between s_dclub-low and s_dclub-high.
      clear : gv_bclub_low, gv_bclub_high.
      catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
        gv_bclub_low = s_bclub-low / 100000.
      endcatch.
      catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
        gv_bclub_high = s_bclub-high / 100000.
      endcatch.
*******  re-initiate SRno.
      if lt_vfdata_bc[] is not initial.
        clear lv_srno.
        lv_srno = 1.
        loop at lt_vfdata_bc into lw_vfdata_bc.
          lw_vfdata_bc-srno = lv_srno.
          lv_srno = lv_srno + 1.
          modify lt_vfdata_bc from lw_vfdata_bc transporting srno.
          clear lw_vfdata_bc.
        endloop.
      endif.
    else.
      message 'Enter sales range' type 'I'.
    endif.
    if p_pso = abap_true.
      if lt_vfdata_dc[] is not initial or lt_vfdata_gc[] is not initial or lt_vfdata_sc[] is not initial or lt_vfdata_bc[] is not initial.
        clear gt_vfdata[].
*****      gt_vfdata[] = lt_vfdata_dc[].
*****      append lines of lt_vfdata_gc[] to gt_vfdata[].
*****      append lines of lt_vfdata_sc[] to gt_vfdata[].
********************** for DIAMOND CLUB
        if lt_vfdata_dc[] is not initial.
          clear:lv_cnt_25.
          lv_cnt_25 = 25.
          clear lv_cnt_1.


          clear lv_row_cnt.
          describe table lt_vfdata_dc[] lines lv_row_cnt.
          if sy-subrc = 0.
            clear lv_row_cnt1.
            lv_row_cnt1 = lv_row_cnt.
          endif.
          clear gt_bulletin_dc[].

          do.
            if lv_row_cnt < 0.
              exit.
            else.
              lv_cnt = lv_cnt + 1.
              lv_cnt_25 = lv_cnt_25 + 1.
              lv_cnt_1 = lv_cnt_1 + 1.
              if lv_cnt < 26.
                if lv_cnt_1 <= lv_row_cnt1.
                  read table lt_vfdata_dc into lw_vfdata_dc index lv_cnt_1.
                  if sy-subrc = 0.
                    gw_bulletin-srno = lw_vfdata_dc-srno.
                    gw_bulletin-pernr = lw_vfdata_dc-pernr.
                    clear lw_0002.
                    read table lt_0002 into lw_0002 with key pernr = gw_bulletin-pernr.
                    if sy-subrc = 0.
                      clear lw_t522t.
                      read table lt_t522t into lw_t522t with key anred = lw_0002-anred.
                      if sy-subrc = 0.
                        concatenate lw_t522t-atext lw_vfdata_dc-ename into gw_bulletin-ename.
                      endif.
                    endif.
                    gw_bulletin-bzirk = lw_vfdata_dc-bzirk.
                    gw_bulletin-div = lw_vfdata_dc-div.
                    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
                      gw_bulletin-sales = lw_vfdata_dc-sales / 100000.
                    endcatch.
                    gw_bulletin-pertgt = lw_vfdata_dc-pertgt.
                    if gw_vfdata-totpso > 0.
                      gw_bulletin-ypm = lw_vfdata_dc-sales / lw_vfdata_dc-totpso.
                      gw_bulletin-ypm = gw_bulletin-ypm / 100000.
                    else.
                      gw_bulletin-ypm = 0.
                    endif.
                    read table lt_vfdata_dc into lw_vfdata index lv_cnt_25.
                    if sy-subrc = 0.
                      gw_bulletin-srno1 = lw_vfdata-srno.
                      gw_bulletin-pernr1 = lw_vfdata-pernr.
                      clear lw_0002.
                      read table lt_0002 into lw_0002 with key pernr = gw_bulletin-pernr1.
                      if sy-subrc = 0.
                        clear lw_t522t.
                        read table lt_t522t into lw_t522t with key anred = lw_0002-anred.
                        if sy-subrc = 0.
                          concatenate lw_t522t-atext lw_vfdata-ename into gw_bulletin-ename1.
                        endif.
                      endif.
                      gw_bulletin-bzirk1 = lw_vfdata-bzirk.
                      gw_bulletin-div1 = lw_vfdata-div.
                      catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
                        gw_bulletin-sales1 = lw_vfdata-sales / 100000.
                      endcatch.
                      gw_bulletin-pertgt1 = lw_vfdata-pertgt.
                      if lw_vfdata-totpso > 0.
                        gw_bulletin-ypm1 = lw_vfdata-sales / lw_vfdata-totpso.
                        gw_bulletin-ypm1 = gw_bulletin-ypm1 / 100000.
                      else.
                        gw_bulletin-ypm1 = 0.
                      endif.
                    endif.
                    append gw_bulletin to gt_bulletin_dc.
                    clear gw_bulletin.
                  endif.
                endif.
              else.
*****          IF LV_ROW_CNT >= 50.
                lv_row_cnt = lv_row_cnt - 50.
                lv_cnt_1 = lv_cnt_25 - 1.
                lv_cnt_25 = lv_cnt_25 + 24.
                clear lv_cnt.
*****          ELSE.
*****            CLEAR LV_CNT.
*****          ENDIF.
              endif.
            endif.
          enddo.
        endif.
********************** for GOLD CLUB
        if lt_vfdata_gc[] is not initial.
          clear:lv_cnt_25.
          lv_cnt_25 = 25.
          clear lv_cnt_1.


          clear lv_row_cnt.
          describe table lt_vfdata_gc[] lines lv_row_cnt.
          if sy-subrc = 0.
            clear lv_row_cnt1.
            lv_row_cnt1 = lv_row_cnt.
          endif.
          clear gt_bulletin_gc[].

          do.
            if lv_row_cnt < 0.
              exit.
            else.
              lv_cnt = lv_cnt + 1.
              lv_cnt_25 = lv_cnt_25 + 1.
              lv_cnt_1 = lv_cnt_1 + 1.
              if lv_cnt < 26.
                if lv_cnt_1 <= lv_row_cnt1.
                  read table lt_vfdata_gc into lw_vfdata_gc index lv_cnt_1.
                  if sy-subrc = 0.
                    gw_bulletin-srno = lw_vfdata_gc-srno.
                    gw_bulletin-pernr = lw_vfdata_gc-pernr.
                    clear lw_0002.
                    read table lt_0002 into lw_0002 with key pernr = gw_bulletin-pernr.
                    if sy-subrc = 0.
                      clear lw_t522t.
                      read table lt_t522t into lw_t522t with key anred = lw_0002-anred.
                      if sy-subrc = 0.
                        concatenate lw_t522t-atext lw_vfdata_gc-ename into gw_bulletin-ename.
                      endif.
                    endif.
                    gw_bulletin-bzirk = lw_vfdata_gc-bzirk.
                    gw_bulletin-div = lw_vfdata_gc-div.
                    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
                      gw_bulletin-sales = lw_vfdata_gc-sales / 100000.
                    endcatch.
                    gw_bulletin-pertgt = lw_vfdata_gc-pertgt.
                    if gw_vfdata-totpso > 0.
                      gw_bulletin-ypm = lw_vfdata_gc-sales / lw_vfdata_gc-totpso.
                      gw_bulletin-ypm = gw_bulletin-ypm / 100000.
                    else.
                      gw_bulletin-ypm = 0.
                    endif.
                    read table lt_vfdata_gc into lw_vfdata index lv_cnt_25.
                    if sy-subrc = 0.
                      gw_bulletin-srno1 = lw_vfdata-srno.
                      gw_bulletin-pernr1 = lw_vfdata-pernr.
                      clear lw_0002.
                      read table lt_0002 into lw_0002 with key pernr = gw_bulletin-pernr1.
                      if sy-subrc = 0.
                        clear lw_t522t.
                        read table lt_t522t into lw_t522t with key anred = lw_0002-anred.
                        if sy-subrc = 0.
                          concatenate lw_t522t-atext lw_vfdata-ename into gw_bulletin-ename1.
                        endif.
                      endif.

                      gw_bulletin-bzirk1 = lw_vfdata-bzirk.
                      gw_bulletin-div1 = lw_vfdata-div.
                      catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
                        gw_bulletin-sales1 = lw_vfdata-sales / 100000.
                      endcatch.
                      gw_bulletin-pertgt1 = lw_vfdata-pertgt.
                      if lw_vfdata-totpso > 0.
                        gw_bulletin-ypm1 = lw_vfdata-sales / lw_vfdata-totpso.
                        gw_bulletin-ypm1 = gw_bulletin-ypm1 / 100000.
                      else.
                        gw_bulletin-ypm1 = 0.
                      endif.
                    endif.
                    append gw_bulletin to gt_bulletin_gc.
                    clear gw_bulletin.
                  endif.
                endif.
              else.
*****          IF LV_ROW_CNT >= 50.
                lv_row_cnt = lv_row_cnt - 50.
                lv_cnt_1 = lv_cnt_25 - 1.
                lv_cnt_25 = lv_cnt_25 + 24.
                clear lv_cnt.
*****          ELSE.
*****            CLEAR LV_CNT.
*****          ENDIF.
              endif.
            endif.
          enddo.
        endif.

********************** for SILVER CLUB
        if lt_vfdata_sc[] is not initial.
          clear:lv_cnt_25.
          lv_cnt_25 = 25.
          clear lv_cnt_1.


          clear lv_row_cnt.
          describe table lt_vfdata_sc[] lines lv_row_cnt.
          if sy-subrc = 0.
            clear lv_row_cnt1.
            lv_row_cnt1 = lv_row_cnt.
          endif.
          clear gt_bulletin_sc[].

          do.
            if lv_row_cnt < 0.
              exit.
            else.
              lv_cnt = lv_cnt + 1.
              lv_cnt_25 = lv_cnt_25 + 1.
              lv_cnt_1 = lv_cnt_1 + 1.
              if lv_cnt < 26.
                if lv_cnt_1 <= lv_row_cnt1.
                  read table lt_vfdata_sc into lw_vfdata_sc index lv_cnt_1.
                  if sy-subrc = 0.
                    gw_bulletin-srno = lw_vfdata_sc-srno.
                    gw_bulletin-pernr = lw_vfdata_sc-pernr.
                    clear lw_0002.
                    read table lt_0002 into lw_0002 with key pernr = gw_bulletin-pernr.
                    if sy-subrc = 0.
                      clear lw_t522t.
                      read table lt_t522t into lw_t522t with key anred = lw_0002-anred.
                      if sy-subrc = 0.
                        concatenate lw_t522t-atext lw_vfdata_sc-ename into gw_bulletin-ename.
                      endif.
                    endif.

                    gw_bulletin-bzirk = lw_vfdata_sc-bzirk.
                    gw_bulletin-div = lw_vfdata_sc-div.
                    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
                      gw_bulletin-sales = lw_vfdata_sc-sales / 100000.
                    endcatch.
                    gw_bulletin-pertgt = lw_vfdata_sc-pertgt.
                    if gw_vfdata-totpso > 0.
                      gw_bulletin-ypm = lw_vfdata_sc-sales / lw_vfdata_sc-totpso.
                      gw_bulletin-ypm = gw_bulletin-ypm / 100000.
                    else.
                      gw_bulletin-ypm = 0.
                    endif.
                    read table lt_vfdata_sc into lw_vfdata index lv_cnt_25.
                    if sy-subrc = 0.
                      gw_bulletin-srno1 = lw_vfdata-srno.
                      gw_bulletin-pernr1 = lw_vfdata-pernr.
                      clear lw_0002.
                      read table lt_0002 into lw_0002 with key pernr = gw_bulletin-pernr1.
                      if sy-subrc = 0.
                        clear lw_t522t.
                        read table lt_t522t into lw_t522t with key anred = lw_0002-anred.
                        if sy-subrc = 0.
                          concatenate lw_t522t-atext lw_vfdata-ename into gw_bulletin-ename1.
                        endif.
                      endif.
                      gw_bulletin-bzirk1 = lw_vfdata-bzirk.
                      gw_bulletin-div1 = lw_vfdata-div.
                      catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
                        gw_bulletin-sales1 = lw_vfdata-sales / 100000.
                      endcatch.
                      gw_bulletin-pertgt1 = lw_vfdata-pertgt.
                      if lw_vfdata-totpso > 0.
                        gw_bulletin-ypm1 = lw_vfdata-sales / lw_vfdata-totpso.
                        gw_bulletin-ypm1 = gw_bulletin-ypm1 / 100000.
                      else.
                        gw_bulletin-ypm1 = 0.
                      endif.
                    endif.
                    append gw_bulletin to gt_bulletin_sc.
                    clear gw_bulletin.
                  endif.
                endif.
              else.
*****          IF LV_ROW_CNT >= 50.
                lv_row_cnt = lv_row_cnt - 50.
                lv_cnt_1 = lv_cnt_25 - 1.
                lv_cnt_25 = lv_cnt_25 + 24.
                clear lv_cnt.
*****          ELSE.
*****            CLEAR LV_CNT.
*****          ENDIF.
              endif.
            endif.
          enddo.
        endif.

      endif.
    endif.
  endif.

********************** for BRONZE CLUB
  if lt_vfdata_bc[] is not initial.
    clear:lv_cnt_25.
    lv_cnt_25 = 25.
    clear lv_cnt_1.


    clear lv_row_cnt.
    describe table lt_vfdata_bc[] lines lv_row_cnt.
    if sy-subrc = 0.
      clear lv_row_cnt1.
      lv_row_cnt1 = lv_row_cnt.
    endif.
    clear gt_bulletin_bc[].

    do.
      if lv_row_cnt < 0.
        exit.
      else.
        lv_cnt = lv_cnt + 1.
        lv_cnt_25 = lv_cnt_25 + 1.
        lv_cnt_1 = lv_cnt_1 + 1.
        if lv_cnt < 26.
          if lv_cnt_1 <= lv_row_cnt1.
            read table lt_vfdata_bc into lw_vfdata_bc index lv_cnt_1.
            if sy-subrc = 0.
              gw_bulletin-srno = lw_vfdata_bc-srno.
              gw_bulletin-pernr = lw_vfdata_bc-pernr.
              clear lw_0002.
              read table lt_0002 into lw_0002 with key pernr = gw_bulletin-pernr.
              if sy-subrc = 0.
                clear lw_t522t.
                read table lt_t522t into lw_t522t with key anred = lw_0002-anred.
                if sy-subrc = 0.
                  concatenate lw_t522t-atext lw_vfdata_bc-ename into gw_bulletin-ename.
                endif.
              endif.
              gw_bulletin-bzirk = lw_vfdata_bc-bzirk.
              gw_bulletin-div = lw_vfdata_bc-div.
              catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
                gw_bulletin-sales = lw_vfdata_dc-sales / 100000.
              endcatch.
              gw_bulletin-pertgt = lw_vfdata_bc-pertgt.
              if gw_vfdata-totpso > 0.
                gw_bulletin-ypm = lw_vfdata_bc-sales / lw_vfdata_bc-totpso.
                gw_bulletin-ypm = gw_bulletin-ypm / 100000.
              else.
                gw_bulletin-ypm = 0.
              endif.
              read table lt_vfdata_bc into lw_vfdata index lv_cnt_25.
              if sy-subrc = 0.
                gw_bulletin-srno1 = lw_vfdata-srno.
                gw_bulletin-pernr1 = lw_vfdata-pernr.
                clear lw_0002.
                read table lt_0002 into lw_0002 with key pernr = gw_bulletin-pernr1.
                if sy-subrc = 0.
                  clear lw_t522t.
                  read table lt_t522t into lw_t522t with key anred = lw_0002-anred.
                  if sy-subrc = 0.
                    concatenate lw_t522t-atext lw_vfdata-ename into gw_bulletin-ename1.
                  endif.
                endif.
                gw_bulletin-bzirk1 = lw_vfdata-bzirk.
                gw_bulletin-div1 = lw_vfdata-div.
                catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
                  gw_bulletin-sales1 = lw_vfdata-sales / 100000.
                endcatch.
                gw_bulletin-pertgt1 = lw_vfdata-pertgt.
                if lw_vfdata-totpso > 0.
                  gw_bulletin-ypm1 = lw_vfdata-sales / lw_vfdata-totpso.
                  gw_bulletin-ypm1 = gw_bulletin-ypm1 / 100000.
                else.
                  gw_bulletin-ypm1 = 0.
                endif.
              endif.
              append gw_bulletin to gt_bulletin_bc.
              clear gw_bulletin.
            endif.
          endif.
        else.
*****          IF LV_ROW_CNT >= 50.
          lv_row_cnt = lv_row_cnt - 50.
          lv_cnt_1 = lv_cnt_25 - 1.
          lv_cnt_25 = lv_cnt_25 + 24.
          clear lv_cnt.
*****          ELSE.
*****            CLEAR LV_CNT.
*****          ENDIF.
        endif.
      endif.
    enddo.
  endif.

  if gt_vfdata[] is not initial.
    clear:lv_cnt_25.
    lv_cnt_25 = 25.
    clear lv_cnt_1.

    clear lv_row_cnt.
    describe table gt_vfdata[] lines lv_row_cnt.
    if sy-subrc = 0.
      clear lv_row_cnt1.
      lv_row_cnt1 = lv_row_cnt.
    endif.
    clear gt_bulletin[].

    do.
      if lv_row_cnt < 0.
        exit.
      else.
        lv_cnt = lv_cnt + 1.
        lv_cnt_25 = lv_cnt_25 + 1.
        lv_cnt_1 = lv_cnt_1 + 1.
        if lv_cnt < 26.
          if lv_cnt_1 <= lv_row_cnt1.
            read table gt_vfdata into gw_vfdata index lv_cnt_1.
            if sy-subrc = 0.
              gw_bulletin-srno = gw_vfdata-srno.
              gw_bulletin-pernr = gw_vfdata-pernr.
              clear lw_0002.
              read table lt_0002 into lw_0002 with key pernr = gw_bulletin-pernr.
              if sy-subrc = 0.
                clear lw_t522t.
                read table lt_t522t into lw_t522t with key anred = lw_0002-anred.
                if sy-subrc = 0.
                  concatenate lw_t522t-atext gw_vfdata-ename into gw_bulletin-ename.
                endif.
              endif.

              gw_bulletin-bzirk = gw_vfdata-bzirk.
              gw_bulletin-div = gw_vfdata-div.
              catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
                gw_bulletin-sales = gw_vfdata-sales / 100000.
              endcatch.
              gw_bulletin-pertgt = gw_vfdata-pertgt.
              if gw_vfdata-totpso > 0.
                gw_bulletin-ypm = gw_vfdata-sales / gw_vfdata-totpso.
                gw_bulletin-ypm = gw_bulletin-ypm / 100000.
              else.
                gw_bulletin-ypm = 0.
              endif.
              read table gt_vfdata into lw_vfdata index lv_cnt_25.
              if sy-subrc = 0.
                gw_bulletin-srno1 = lw_vfdata-srno.
                gw_bulletin-pernr1 = lw_vfdata-pernr.
                clear lw_0002.
                read table lt_0002 into lw_0002 with key pernr = gw_bulletin-pernr1.
                if sy-subrc = 0.
                  clear lw_t522t.
                  read table lt_t522t into lw_t522t with key anred = lw_0002-anred.
                  if sy-subrc = 0.
                    concatenate lw_t522t-atext lw_vfdata-ename into gw_bulletin-ename1.
                  endif.
                endif.
                gw_bulletin-bzirk1 = lw_vfdata-bzirk.
                gw_bulletin-div1 = lw_vfdata-div.
                catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
                  gw_bulletin-sales1 = lw_vfdata-sales / 100000.
                endcatch.
                gw_bulletin-pertgt1 = lw_vfdata-pertgt.
                if lw_vfdata-totpso > 0.
                  gw_bulletin-ypm1 = lw_vfdata-sales / lw_vfdata-totpso.
                  gw_bulletin-ypm1 = gw_bulletin-ypm1 / 100000.
                else.
                  gw_bulletin-ypm1 = 0.
                endif.
              endif.
              append gw_bulletin to gt_bulletin.
              clear gw_bulletin.
            endif.
          endif.
        else.
*****          IF LV_ROW_CNT >= 50.
          lv_row_cnt = lv_row_cnt - 50.
          lv_cnt_1 = lv_cnt_25 - 1.
          lv_cnt_25 = lv_cnt_25 + 24.
          clear lv_cnt.
*****          ELSE.
*****            CLEAR LV_CNT.
*****          ENDIF.
        endif.
      endif.
    enddo.
  endif.
  if gt_bulletin[] is not initial.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_BULLETIN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form display_bulletin .
  data: fm_name type  tdsfname,
        lv_mnth type string.

  if p_value = abap_true.
    clear lv_mnth.
    select single ltx into lv_mnth from t247
      where spras = sy-langu and mnr = s_date-low+4(2).
    clear gv_rep_hdr.
    concatenate lv_mnth s_date-low+0(4) 'Performance' into gv_rep_hdr separated by space.
    translate gv_rep_hdr to upper case.

********* for PSO's - sales layout
    if p_pso = abap_true and   p_sale = abap_true.

      clear fm_name.
      call function 'SSF_FUNCTION_MODULE_NAME'
        exporting
          formname = 'ZPSO_RANKING_BULLTIN_SF'
        importing
          fm_name  = fm_name.

      gw_output_opts-tdnoprev = space.
      gw_output_opts-tddest    = 'LOCL'.
      gw_output_opts-tdnoprint = space.

      gw_contrl_para-no_dialog = space.
      gw_contrl_para-preview = space.


      call function fm_name
        exporting
*         ARCHIVE_INDEX      =
*         ARCHIVE_INDEX_TAB  =
*         ARCHIVE_PARAMETERS =
          control_parameters = gw_contrl_para
*         MAIL_APPL_OBJ      =
*         MAIL_RECIPIENT     =
*         MAIL_SENDER        =
          output_options     = gw_output_opts
*         USER_SETTINGS      = 'X'
          gv_rep_hdr         = gv_rep_hdr
          p_qty              = p_qty
          p_val              = p_val
          p_per              = p_per
          p_sale             = p_sale
          p_bno              = p_bno
          p_pso              = p_pso
          p_rm               = p_rm
          p_zm               = p_zm
          gv_dclub_low       = gv_dclub_low
          gv_dclub_high      = gv_dclub_high
          gv_gclub_low       = gv_gclub_low
          gv_gclub_high      = gv_gclub_high
          gv_sclub_low       = gv_sclub_low
          gv_sclub_high      = gv_sclub_high
          gv_bclub_low       = gv_bclub_low
          gv_bclub_high      = gv_bclub_high
        importing
*         document_output_info =
          job_output_info    = gt_otf_data
*         job_output_options =
        tables
          gt_fdata           = gt_fdata[]
          gt_vfdata          = gt_vfdata[]
          gt_bulletin        = gt_bulletin[]
          gt_bulletin_dc     = gt_bulletin_dc[]
          gt_bulletin_gc     = gt_bulletin_gc[]
          gt_bulletin_sc     = gt_bulletin_sc[]
          gt_bulletin_bc     = gt_bulletin_bc[]
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
    else.       "*********** for PSOs - percentage layout + RM/ZM all layouts
      clear fm_name.
      call function 'SSF_FUNCTION_MODULE_NAME'
        exporting
          formname = 'ZRANKING_BULLTIN_SF'
        importing
          fm_name  = fm_name.

      gw_output_opts-tdnoprev = space.
      gw_output_opts-tddest    = 'LOCL'.
      gw_output_opts-tdnoprint = space.

      gw_contrl_para-no_dialog = space.
      gw_contrl_para-preview = space.


      call function fm_name
        exporting
*         ARCHIVE_INDEX      =
*         ARCHIVE_INDEX_TAB  =
*         ARCHIVE_PARAMETERS =
          control_parameters = gw_contrl_para
*         MAIL_APPL_OBJ      =
*         MAIL_RECIPIENT     =
*         MAIL_SENDER        =
          output_options     = gw_output_opts
*         USER_SETTINGS      = 'X'
          gv_rep_hdr         = gv_rep_hdr
          p_qty              = p_qty
          p_val              = p_val
          p_per              = p_per
          p_sale             = p_sale
          p_bno              = p_bno
          p_pso              = p_pso
          p_rm               = p_rm
          p_zm               = p_zm
          p_ypm              = p_ypm
*****          gv_dclub_low       = gv_dclub_low
*****          gv_dclub_high      = gv_dclub_high
*****          gv_gclub_low       = gv_gclub_low
*****          gv_gclub_high      = gv_gclub_high
*****          gv_sclub_low       = gv_sclub_low
*****          gv_sclub_high      = gv_sclub_high
        importing
*         document_output_info =
          job_output_info    = gt_otf_data
*         job_output_options =
        tables
          gt_fdata           = gt_fdata[]
          gt_vfdata          = gt_vfdata[]
          gt_bulletin        = gt_bulletin[]
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
    endif.
  endif.
endform.
