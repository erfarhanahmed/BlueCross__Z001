*&-------------------------------------------------------------------------------------------------*
*& Report  ZSR9_HO_AND_SUMMARY
*&-------------------------------------------------------------------------------------------------*
*&DESCRIPTION       : Mergining of ZSR9_HO and ZSR9HO_SUM and layout in smartform
*&                    Used existing t-code ZSR9_HO and made copy of old into ZSR9_HO_OLD
*CREATED BY         : Shraddha Pradhan
*CREATED ON         : 02/05/2024
*Request No         : BCDK934962, BCDK935072, BCDK935074, BCDK935076
*T-code             : ZSR9_HO
*&-------------------------------------------------------------------------------------------------*
*&Modification History
*&---------------------------
*&Changed by/date       : 29.05.2024
*&DESCRIPTION           : add perf.summary in summary print and add DZM total for detail print.
*&Request No.          : BCDK935096,BCDK935173,BCDK935185,BCDK935187, BCDK935189,BCDK935195
*&-------------------------------------------------------------------------------------------------*
*&Changed by/date       : 29.06.2024
*&DESCRIPTION           :Corr in summary target, ZM email send
*&Request No.          : BCDK935385
*&-------------------------------------------------------------------------------------------------*
*&Changed by/date       : 29.10.2024
*&DESCRIPTION           :Corr in summary - ZM/RM count
*&Request No.          : BCDK935986
*&-------------------------------------------------------------------------------------------------*
report zsr9_ho_and_summary.

type-pools slis.
tables : zdsmter,
         yterrallc,
         pa0001,
         zcumpso,
         zrcumpso,
         zthr_heq_des,
         mara,
         ysd_dist_targt,
         zoneseq,
         zfsdes,
         zdrphq.

constants :gc_true         type c value 'X',
           gc_email_sender type adr6-smtp_addr value 'sr9@bluecrosslabs.com',
           gc_fm_name      type  tdsfname value 'ZSR9_HO_DTLS_SF',
           gc_fm_name1     type  tdsfname value 'ZSR9_HO_SUMMRY_SF'.

types : begin of ty_zdsm_link,
          spart     type spart,
          div       type string,
          zdsm      type bzirk,
          gm        type bzirk,
          zm        type bzirk,
          rm        type bzirk,
          bzirk     type bzirk,
          gm_pernr  type persno,
          gm_ename  type emnam,
          gm_hq     type zdehr_hqdesc,
          gm_doj    type begda,
          gm_short  type short_d,
          gm_email  type comm_id_long,

          zm_pernr  type persno,
          zm_ename  type emnam,
          zm_hq     type zdehr_hqdesc,
          zm_doj    type begda,
          zm_short  type short_d,
          zm_email  type comm_id_long,

          rm_pernr  type persno,
          rm_ename  type emnam,
          rm_hq     type zdehr_hqdesc,
          rm_doj    type begda,
          rm_short  type short_d,
          rm_email  type comm_id_long,

          pernr     type persno,
          ename     type emnam,
          hq        type zdehr_hqdesc,
          doj       type begda,
          short     type short_d,
          email     type comm_id_long,
          sale      type p,
          psale     type p,
          target    type p,
          ptarget   type p,
          per       type p,
          zoneseq   type seqnr,
          bzirk_cnt type i,
          zmonth    type fcmnr,
          zyear     type mjahr,
        end of ty_zdsm_link,

        begin of ty_0001,
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

        begin of ty_0105,
          pernr      type persno,
          subty      type subty,
          usrid_long type comm_id_long,
        end of ty_0105.

data : gt_zdsmter     type table of zdsmter,
       gw_zdsmter     type zdsmter,
       gw_zdsmter1    type zdsmter,
       gt_zm          type table of zdsmter,
       gw_zm          type zdsmter,
       gt_rm          type table of zdsmter,
       gw_rm          type zdsmter,
       gt_dzm         type table of zdsmter,
       gw_dzm         type zdsmter,
       gt_gm          type table of zdsmter,
       gw_gm          type zdsmter,
       gt_zdsm_link   type table of zty_sr9_ho_summ, "ty_zdsm_link,
       gw_zdsm_link   type zty_sr9_ho_summ, "ty_zdsm_link,
       gt_sr9_dtls    type table of zty_sr9_ho_summ, "ty_zdsm_link,
       gw_sr9_dtls    type zty_sr9_ho_summ, "ty_zdsm_link,
       gt_sr9_summ    type table of zty_sr9_ho_summ, "ty_zdsm_link,
       gw_sr9_summ    type zty_sr9_ho_summ, "ty_zdsm_link,
       gt_sr9_summ_zm type table of zty_sr9_ho_summ, "ty_zdsm_link,
       gw_sr9_summ_zm type zty_sr9_ho_summ, "ty_zdsm_link,
       gt_sr9_summ_rm type table of zty_sr9_ho_summ, "ty_zdsm_link,
       gw_sr9_summ_rm type zty_sr9_ho_summ, "ty_zdsm_link,
       gt_sr9_prdvty  type table of zty_sr9_ho_summ, "ty_zdsm_link,
       gw_sr9_prdvty  type zty_sr9_ho_summ, "ty_zdsm_link,
       gt_sr9_gm      type table of zty_sr9_ho_summ,
       gw_sr9_gm      type zty_sr9_ho_summ,
       gt_sr9_zm      type table of zty_sr9_ho_summ,
       gw_sr9_zm      type zty_sr9_ho_summ,
       gt_sr9_zm_lp   type table of zty_sr9_ho_summ,
       gw_sr9_zm_lp   type zty_sr9_ho_summ,
       gt_sr9_dzm     type table of zty_sr9_ho_summ,
       gw_sr9_dzm     type zty_sr9_ho_summ,
       gt_sr9_rm      type table of zty_sr9_ho_summ,
       gw_sr9_rm      type zty_sr9_ho_summ,
       gt_zcumpso     type table of zcumpso,
       gw_zcumpso     type zcumpso,
       gt_zrcumpso    type table of zrcumpso,
       gw_zrcumpso    type zrcumpso,
       gt_yterr       type table of yterrallc,
       gw_yterr       type yterrallc,
       gt_hq_des      type table of zthr_heq_des,
       gw_hq_des      type zthr_heq_des,
       gt_zdrphq      type table of zdrphq,
       gw_zdrphq      type zdrphq,
       gt_0001        type table of ty_0001,
       gw_0001        type ty_0001,
       gt_0105        type table of ty_0105,
       gw_0105        type ty_0105,
       gt_zfsdes      type table of zfsdes,
       gw_zfsdes      type zfsdes,
       gt_zoneseq     type table of zoneseq,
       gw_zoneseq     type zoneseq,
       gt_target      type table of ysd_dist_targt,
       gw_target      type  ysd_dist_targt,
       gt_hbe_target  type table of ysd_hbe_targt,
       gw_hbe_target  type ysd_hbe_targt.


data : gv_msg     type string,
       gv_tgt_yr  type mjahr,
       gv_lyr     type mjahr,
       gv_begda   type sy-datum,
       gv_endda   type sy-datum,
       gv_join_dt type sy-datum.

data : gw_output_opts type ssfcompop,
       gw_contrl_para type ssfctrlop,
       gt_otf_data    type ssfcrescl,
       gt_otf         type standard table of itcoo,
       gt_tline       type standard table of tline,
       gt_pdf_data    type solix_tab,
       gt_text        type bcsy_text.

data :gv_bin_filesize type so_obj_len,
      gv_bin_xstr     type xstring,
      gv_text         type string,
      gv_sent_to_all  type os_boolean,
      gv_subject      type so_obj_des.

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

selection-screen begin of block b0 with frame title text-001 no intervals.
****  company-wise growth cards
parameters: r_dtl radiobutton group r1 user-command rb1 default 'X',
            r_sum radiobutton group r1.
selection-screen end of block b0.
selection-screen begin of block b1 with frame title text-002.
selection-screen begin of block b2 with frame title text-003 no intervals.
parameter : r_net radiobutton group r3 user-command rb2 modif id sum default 'X',
            r_gross radiobutton group r3 modif id sum.
selection-screen end of block b2.
parameter : p_mth like zcumpso-zmonth,
            p_yr like zcumpso-zyear.
select-options : s_zone for zdsmter-zdsm matchcode object zsr9_1  modif id dtl.
select-options : s_gm for zdsmter-zdsm matchcode object zsr9_5  modif id sum.

parameters : p_tot as checkbox modif id sum.
selection-screen skip.
parameters :rdb1 radiobutton group r2,
            rdb2 radiobutton group r2 default 'X',
            rdb3 radiobutton group r2 modif id dtl,
*****            rdb4 radiobutton group r2 modif id dtl,
            rdb5 radiobutton group r2.
parameter : p_mailid type ad_smtpadr..
selection-screen end of block b1.


***** set inputs according to radio button/reports selection
at selection-screen output.
  perform set_input_screen.

start-of-selection.
  clear gt_zdsmter[].
  if r_dtl = 'X'.
    if s_zone[] is not initial.
      select * from zdsmter into table gt_zdsmter where zdsm in s_zone and zmonth = p_mth and zyear = p_yr.
    else.
      clear gv_msg.
      gv_msg = 'Pls Enter Zone.'.
      message gv_msg type 'I'.
      exit.
    endif.
  endif.
  if r_sum = 'X'.
    select * from zdsmter into table gt_zdsmter where zdsm in s_gm and zmonth = p_mth and zyear = p_yr.
  endif.

  loop at gt_zdsmter into gw_zdsmter.
    authority-check object 'ZON1_1'
           id 'ZDSM' field gw_zdsmter-zdsm.
    if sy-subrc <> 0.
      concatenate 'No authorization for Zone' gw_zdsmter-zdsm into gv_msg
      separated by space.
      message gv_msg type 'E'.
    endif.
  endloop.
  if rdb5 eq 'X'.
    if p_mailid eq '                                                                     '.
      gv_msg = 'Email id should not be blank.'.
      message gv_msg type 'I'.
      exit.
    endif.
  endif.

  if r_dtl = 'X'.  "for details report
    perform get_data.
  endif.

  if r_sum = 'X'. "for summary report
    perform get_summary_data.
  endif.

  if gt_sr9_dtls[] is not initial or gt_sr9_summ[] is not initial.
    if rdb1 = 'X'.      "ALV
      perform build_fcat.
      perform display_alv.
    elseif rdb2 = 'X'.        "Print
      perform display_sform.
    elseif rdb3 = 'X'.
      clear gt_sr9_zm_lp[].
      gt_sr9_zm_lp[] = gt_sr9_dtls[].
      sort gt_sr9_zm_lp[] by zm.
      delete adjacent duplicates from gt_sr9_zm_lp[] comparing zm.
      loop at gt_sr9_zm_lp into gw_sr9_zm_lp.
        perform send_zm_email using gw_sr9_zm_lp.
      endloop.
****    elseif rdb4 = 'X'.
    else.
      perform send_email using p_mailid.
    endif.
  else.
    clear gv_msg.
    gv_msg = 'No data found.'.
    message gv_msg type 'I'.
  endif.
*&---------------------------------------------------------------------*
*&      Form  SET_INPUT_SCREEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form set_input_screen .
  if r_dtl = 'X'.
    loop at screen.
      if screen-group1 = 'DTL'  or screen-group1 = ''.
        screen-active = 1.
        modify screen.
      else.
        screen-active = 0.
        modify screen.
      endif.
      if screen-name cp '*S_GM*' .
        screen-active = 0.
        modify screen.
      endif.
    endloop.
  endif.

  if r_sum = 'X'.
    loop at screen.
      if screen-group1 = 'SUM'  or screen-group1 = ''.
        screen-active = 1.
        modify screen.
      else.
        screen-active = 0.
        modify screen.
      endif.
      if screen-name cp '*S_ZONE*' .
        screen-active = 0.
        modify screen.
      endif.
    endloop.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form get_data .

  data : lv_bzirk_cnt type i.

**** month begin date.
  gv_begda+6(2) = '01'.
  gv_begda+4(2) = p_mth.
  gv_begda+0(4) = p_yr.
**** date to check if anyone joined after 15th of selected month
  clear gv_join_dt.
  gv_join_dt = gv_begda.
  gv_join_dt+6(2) = '15'.
  clear gv_endda.
  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date           = gv_begda
    importing
      ev_month_end_date = gv_endda.

****target year
  clear gv_tgt_yr.
  if p_mth le '03'.
    gv_tgt_yr = p_yr - 1.
  else.
    gv_tgt_yr = p_yr.
  endif.

****** prepare for zm/rm/dzm/gm/terr link.
  clear gt_zdsmter[].
  select * from zdsmter into table gt_zdsmter where zmonth = p_mth and zyear = p_yr.
  sort gt_zdsmter by zdsm.
  clear gt_zm[].
  gt_zm[] = gt_zdsmter[].
  sort gt_zm by zdsm.
  delete gt_zm where zdsm+0(2) <> 'D-'.

  clear gt_rm[].
  gt_rm[] = gt_zdsmter[].
  sort gt_rm by zdsm.
  delete gt_rm where zdsm+0(2) <> 'R-'.

  clear gt_gm[].
  gt_gm[] = gt_zdsmter[].
  sort gt_gm by zdsm.
  delete gt_gm where zdsm+0(2) <> 'G-'.

  clear gt_dzm[].
  gt_dzm[] = gt_zdsmter[].
  sort gt_dzm by zdsm.
  delete gt_dzm where zdsm+0(2) <> 'Z-'.


  clear gt_yterr[].
  select *
    into table gt_yterr
    from yterrallc
    where begda le gv_begda and endda ge gv_endda.

  clear gt_0001[].
  select a~pernr a~begda
         b~pernr b~begda b~endda b~abkrs b~ansvh b~persk b~plans b~ename b~zz_hqcode into table gt_0001
    from pa0000 as a inner join pa0001 as b
    on a~pernr = b~pernr
    where a~massn = '01'
    and b~endda = '99991231'.
  if sy-subrc = 0.
    clear gt_0105[].
    select pernr subty usrid_long from pa0105 into table gt_0105
      where subty = '0010'.
    if sy-subrc = 0.
      sort gt_0105 by pernr.
      delete adjacent duplicates from gt_0105 comparing pernr.
    endif.
  endif.


***** HQ des
  clear gt_hq_des[].
  select * from zthr_heq_des into table gt_hq_des.

***** HQ des
  clear gt_zdrphq[].
  select * from zdrphq into table gt_zdrphq.

*****  short/postion name
  clear gt_zfsdes[].
  select * from zfsdes into table gt_zfsdes.

**** zone-wise sequence for printing
  clear gt_zoneseq[].
  select * from zoneseq into table gt_zoneseq.

****** sales details curr.yr
  clear gt_zcumpso[].
  select * from zcumpso into table gt_zcumpso
    where zmonth = p_mth
    and zyear = p_yr.
***** sales details prev.yr
  clear gt_zrcumpso[].
  gv_lyr = p_yr - 1.
  select * from zrcumpso into table gt_zrcumpso
    where zmonth = p_mth
    and zyear = gv_lyr.

******* target details
  clear gt_target[].
  select * from ysd_dist_targt into table gt_target
    where trgyear = gv_tgt_yr.

  clear gt_hbe_target[].
  select * from ysd_hbe_targt into table gt_hbe_target
    where trgyear =   gv_tgt_yr.

  sort gt_gm by zdsm.
  sort gt_zm by zdsm.
  sort gt_rm by zdsm bzirk.
  sort gt_dzm by zdsm.

  sort gt_zdsmter[] by zdsm bzirk.
  sort gt_yterr[] by bzirk.
  sort gt_0001[] by pernr00.
  sort gt_0105[] by pernr.
  sort gt_hq_des[] by zz_hqcode.
  sort gt_zfsdes[] by persk.
  sort gt_zcumpso[] by bzirk.
  sort gt_zrcumpso[] by bzirk.
  sort gt_target[] by bzirk.
  sort gt_hbe_target[] by bzirk.


******* get GM/ZM/DZM/RM/PSO link wirh sales/target- details
  clear gt_zdsm_link[].
  loop at gt_gm into gw_gm.
    clear gw_zm.
    loop at  gt_zm into gw_zm where zdsm = gw_gm-bzirk.
      clear gw_rm.
      loop at gt_rm into gw_rm where zdsm = gw_zm-bzirk.
****** GM name/hq/doj/short position details
        gw_zdsm_link-zdsm = gw_gm-zdsm.
        gw_zdsm_link-gm = gw_gm-zdsm.
*****        GW_ZDSM_LINK-SPART = GW_GM-SPART.
        gw_zdsm_link-zmonth = gw_gm-zmonth.
        gw_zdsm_link-zyear = gw_gm-zyear.


        clear gw_yterr.
        read table gt_yterr into gw_yterr with key bzirk = gw_zdsm_link-gm.
        if sy-subrc = 0.
          clear gw_0001.
          read table gt_0001 into gw_0001 with key plans = gw_yterr-plans.
          if sy-subrc = 0 and gw_0001-begda <= gv_join_dt and gw_0001-endda >= gv_endda..
            gw_zdsm_link-gm_pernr = gw_0001-pernr00.
            gw_zdsm_link-gm_ename = gw_0001-ename.
            gw_zdsm_link-gm_doj = gw_0001-dtjoin.
            clear gw_0105.
            read table gt_0105 into gw_0105 with key pernr = gw_zdsm_link-gm_pernr.
            if sy-subrc = 0.
              gw_zdsm_link-gm_email = gw_0105-usrid_long.
            endif.

            clear gw_zfsdes.
            read table gt_zfsdes into gw_zfsdes with key persk = gw_0001-persk.
            if sy-subrc = 0.
              gw_zdsm_link-gm_short = gw_zfsdes-short.
            endif.
            clear gw_hq_des.
            read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_0001-zz_hqcode.
            if sy-subrc = 0.
              gw_zdsm_link-gm_hq = gw_hq_des-zz_hqdesc.
            endif.
          else.
            gw_zdsm_link-gm_ename = 'VACANT'.
            clear gw_zdrphq.
            read table gt_zdrphq into gw_zdrphq with key bzirk = gw_zdsm_link-gm.
            if sy-subrc = 0.
              clear gw_hq_des.
              read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_zdrphq-zz_hqcode.
              if sy-subrc = 0.
                gw_zdsm_link-gm_hq = gw_hq_des-zz_hqdesc.
              endif.
            endif.
          endif.
        endif.

****** ZM name/hq/doj details
        gw_zdsm_link-zdsm = gw_zm-zdsm.
        gw_zdsm_link-zm = gw_zm-zdsm.
*****        GW_ZDSM_LINK-SPART = GW_ZM-SPART.
        gw_zdsm_link-zmonth = gw_zm-zmonth.
        gw_zdsm_link-zyear = gw_zm-zyear.

        clear gw_yterr.
        read table gt_yterr into gw_yterr with key bzirk = gw_zdsm_link-zm.
        if sy-subrc = 0.
          clear gw_0001.
          read table gt_0001 into gw_0001 with key plans = gw_yterr-plans.
          if sy-subrc = 0 and gw_0001-begda <= gv_join_dt and gw_0001-endda >= gv_endda..
            gw_zdsm_link-zm_pernr = gw_0001-pernr00.
            gw_zdsm_link-zm_ename = gw_0001-ename.
            gw_zdsm_link-zm_doj = gw_0001-dtjoin.
            clear gw_0105.
            read table gt_0105 into gw_0105 with key pernr = gw_zdsm_link-zm_pernr.
            if sy-subrc = 0.
              gw_zdsm_link-zm_email = gw_0105-usrid_long.
            endif.
            clear gw_zfsdes.
            read table gt_zfsdes into gw_zfsdes with key persk = gw_0001-persk.
            if sy-subrc = 0.
              gw_zdsm_link-zm_short = gw_zfsdes-short.
            endif.
            clear gw_hq_des.
            read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_0001-zz_hqcode.
            if sy-subrc = 0.
              gw_zdsm_link-zm_hq = gw_hq_des-zz_hqdesc.
            endif.
          else.
            gw_zdsm_link-zm_ename = 'VACANT'.
            clear gw_zdrphq.
            read table gt_zdrphq into gw_zdrphq with key bzirk = gw_zdsm_link-zm.
            if sy-subrc = 0.
              clear gw_hq_des.
              read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_zdrphq-zz_hqcode.
              if sy-subrc = 0.
                gw_zdsm_link-zm_hq = gw_hq_des-zz_hqdesc.
              endif.
            endif.
          endif.
        endif.

*******  zone-wise sequence for printing
        clear gw_zoneseq.
        read table gt_zoneseq into gw_zoneseq with key zone_dist = gw_zdsm_link-zm.
        if sy-subrc = 0.
          gw_zdsm_link-zoneseq = gw_zoneseq-seq.
        endif.

****** RM name/hq/doj details
        gw_zdsm_link-zdsm = gw_rm-zdsm.

****** check for DZM
        clear gw_dzm.
        read table gt_dzm into gw_dzm with key bzirk = gw_rm-zdsm.
        if sy-subrc = 0.
          gw_zdsm_link-zdsm = gw_dzm-zdsm.
        endif.

        gw_zdsm_link-rm = gw_rm-zdsm.
        gw_zdsm_link-bzirk = gw_rm-bzirk.
        gw_zdsm_link-spart = gw_rm-spart.
        gw_zdsm_link-zmonth = gw_rm-zmonth.
        gw_zdsm_link-zyear = gw_rm-zyear.

        clear gw_yterr.
        read table gt_yterr into gw_yterr with key bzirk = gw_zdsm_link-rm.
        if sy-subrc = 0.
          clear gw_0001.
          read table gt_0001 into gw_0001 with key plans = gw_yterr-plans.
          if sy-subrc = 0 and gw_0001-begda <= gv_join_dt and gw_0001-endda >= gv_endda..
            gw_zdsm_link-rm_pernr = gw_0001-pernr00.
            gw_zdsm_link-rm_ename = gw_0001-ename.
            gw_zdsm_link-rm_doj = gw_0001-dtjoin.
            clear gw_0105.
            read table gt_0105 into gw_0105 with key pernr = gw_zdsm_link-rm_pernr.
            if sy-subrc = 0.
              gw_zdsm_link-rm_email = gw_0105-usrid_long.
            endif.
            clear gw_zfsdes.
            read table gt_zfsdes into gw_zfsdes with key persk = gw_0001-persk.
            if sy-subrc = 0.
              gw_zdsm_link-rm_short = gw_zfsdes-short.
            endif.
            clear gw_hq_des.
            read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_0001-zz_hqcode.
            if sy-subrc = 0.
              gw_zdsm_link-rm_hq = gw_hq_des-zz_hqdesc.
            endif.
          else.
            gw_zdsm_link-rm_ename = 'VACANT'.
            clear gw_zdrphq.
            read table gt_zdrphq into gw_zdrphq with key bzirk = gw_zdsm_link-rm.
            if sy-subrc = 0.
              clear gw_hq_des.
              read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_zdrphq-zz_hqcode.
              if sy-subrc = 0.
                gw_zdsm_link-rm_hq = gw_hq_des-zz_hqdesc.
              endif.
            endif.
          endif.
        endif.

****** PSO name/hq/doj details
        clear gw_yterr.
        read table gt_yterr into gw_yterr with key bzirk = gw_zdsm_link-bzirk.
        if sy-subrc = 0.
          clear gw_0001.
          read table gt_0001 into gw_0001 with key plans = gw_yterr-plans.
          if sy-subrc = 0 and gw_0001-begda <= gv_join_dt and gw_0001-endda >= gv_endda..
            gw_zdsm_link-pernr = gw_0001-pernr00.
            gw_zdsm_link-ename = gw_0001-ename.
            gw_zdsm_link-doj = gw_0001-dtjoin.
            clear gw_0105.
            read table gt_0105 into gw_0105 with key pernr = gw_zdsm_link-pernr.
            if sy-subrc = 0.
              gw_zdsm_link-email = gw_0105-usrid_long.
            endif.
            clear gw_zfsdes.
            read table gt_zfsdes into gw_zfsdes with key persk = gw_0001-persk.
            if sy-subrc = 0.
              gw_zdsm_link-short = gw_zfsdes-short.
            endif.
            clear gw_hq_des.
            read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_0001-zz_hqcode.
            if sy-subrc = 0.
              gw_zdsm_link-hq = gw_hq_des-zz_hqdesc.
            endif.
          else.
            gw_zdsm_link-ename = 'VACANT'.
            clear gw_zdrphq.
            read table gt_zdrphq into gw_zdrphq with key bzirk = gw_zdsm_link-bzirk.
            if sy-subrc = 0.
              clear gw_hq_des.
              read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_zdrphq-zz_hqcode.
              if sy-subrc = 0.
                gw_zdsm_link-hq = gw_hq_des-zz_hqdesc.
              endif.
            endif.
          endif.
*****        endif.
******  sales curr.yr
          clear gw_zcumpso.
          read table gt_zcumpso into gw_zcumpso with key bzirk =  gw_zdsm_link-bzirk.
          if sy-subrc = 0.
            gw_zdsm_link-sale = gw_zcumpso-netval.
          endif.
******  sales prev.yr
          clear gw_zrcumpso.
          read table gt_zrcumpso into gw_zrcumpso with key bzirk =  gw_zdsm_link-bzirk.
          if sy-subrc = 0.
            gw_zdsm_link-psale = gw_zrcumpso-netval.
          endif.
******   target details
          clear gw_target.
          read table gt_target into gw_target with key bzirk = gw_zdsm_link-bzirk spart = gw_zdsm_link-spart.
          if sy-subrc = 0.
            case p_mth.
              when '04'.
                gw_zdsm_link-target = gw_target-month01.
              when '05'.
                gw_zdsm_link-target = gw_target-month02.
              when '06'.
                gw_zdsm_link-target = gw_target-month03.
              when '07'.
                gw_zdsm_link-target = gw_target-month04.
              when '08'.
                gw_zdsm_link-target = gw_target-month05.
              when '09'.
                gw_zdsm_link-target = gw_target-month06.
              when '10'.
                gw_zdsm_link-target = gw_target-month07.
              when '11'.
                gw_zdsm_link-target = gw_target-month08.
              when '12'.
                gw_zdsm_link-target = gw_target-month09.
              when '01'.
                gw_zdsm_link-target = gw_target-month10.
              when '02'.
                gw_zdsm_link-target = gw_target-month11.
              when '03'.
                gw_zdsm_link-target = gw_target-month12.
            endcase.

********if target is zero then take target bfrom hosital pack - YSD_HBE_TARGT*************
            if gt_hbe_target[] is not initial.
              clear gw_hbe_target.
              read table gt_hbe_target into gw_hbe_target with key bzirk = gw_zdsm_link-bzirk spart = gw_zdsm_link-spart.
              if sy-subrc = 0.
                case p_mth.
                  when '04'.
                    gw_zdsm_link-target = gw_hbe_target-month01.
                  when '05'.
                    gw_zdsm_link-target = gw_hbe_target-month02.
                  when '06'.
                    gw_zdsm_link-target = gw_hbe_target-month03.
                  when '07'.
                    gw_zdsm_link-target = gw_hbe_target-month04.
                  when '08'.
                    gw_zdsm_link-target = gw_hbe_target-month05.
                  when '09'.
                    gw_zdsm_link-target = gw_hbe_target-month06.
                  when '10'.
                    gw_zdsm_link-target = gw_hbe_target-month07.
                  when '11'.
                    gw_zdsm_link-target = gw_hbe_target-month08.
                  when '12'.
                    gw_zdsm_link-target = gw_hbe_target-month09.
                  when '01'.
                    gw_zdsm_link-target = gw_hbe_target-month10.
                  when '02'.
                    gw_zdsm_link-target = gw_hbe_target-month11.
                  when '03'.
                    gw_zdsm_link-target = gw_hbe_target-month12.
                endcase.
              endif.
            endif.
********  set division name
            if gw_zdsm_link-spart = '50'.
              clear gw_zdsmter.
              read table gt_zdsmter into gw_zdsmter with key bzirk = gw_zdsm_link-bzirk spart = '60'.
              if sy-subrc = 0.
                gw_zdsm_link-spart = '50'.
                gw_zdsm_link-div = 'BC'.
              else.
                gw_zdsm_link-div = 'BC'.
              endif.
            elseif gw_zdsm_link-spart = '70'.
              gw_zdsm_link-div = 'LS'.
            else.
              gw_zdsm_link-div = 'XL'.
            endif.

            collect gw_zdsm_link into gt_zdsm_link.
            clear gw_zdsm_link.
          endif.
        endif.
      endloop.
    endloop.
  endloop.

******* prepare SR9 Detail data
  if gt_zdsm_link[] is not initial.
    if r_dtl = 'X'.
      sort gt_zdsm_link by zoneseq zdsm zm rm bzirk.
      if s_zone[] is not initial.
        delete gt_zdsm_link where zm not in s_zone[].
      endif.

      clear gt_sr9_dtls[].
      clear gt_sr9_prdvty[].
      loop at gt_zdsm_link into gw_zdsm_link.
        move-corresponding gw_zdsm_link to gw_sr9_dtls.
        catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
          gw_sr9_dtls-per = ( gw_sr9_dtls-sale /  gw_sr9_dtls-target ) * 100.
        endcatch.

        gw_sr9_prdvty-div = gw_sr9_dtls-div.
        gw_sr9_prdvty-zm = gw_sr9_dtls-zm.
        gw_sr9_prdvty-sale = gw_sr9_dtls-sale.
        gw_sr9_prdvty-target = gw_sr9_dtls-target.
        gw_sr9_prdvty-bzirk_cnt = gw_sr9_prdvty-bzirk_cnt + 1.
        if gw_sr9_dtls-per >= 100.
          gw_sr9_prdvty-per_cnt = gw_sr9_prdvty-per_cnt + 1.
        endif.
        collect gw_sr9_prdvty into gt_sr9_prdvty.
        clear gw_sr9_prdvty.
        append gw_sr9_dtls to gt_sr9_dtls.
        clear gw_sr9_dtls.
      endloop.
    endif.

************** for summary report **********************
*****    IF R_SUM = 'X'.
*****      IF S_GM[] IS NOT INITIAL.
*****        SORT GT_ZDSM_LINK[] BY ZONESEQ GM ZM RM BZIRK.
*****        DELETE GT_ZDSM_LINK[] WHERE GM NOT IN S_GM[].
*****        SORT GT_ZDSM_LINK[] BY SPART GM ZM RM BZIRK PERNR.
*****        DELETE ADJACENT DUPLICATES FROM GT_ZDSM_LINK[] COMPARING GM ZM RM BZIRK PERNR.
*****      ENDIF.
*****
*****
*****      CLEAR GT_SR9_SUMM[].
*****      CLEAR GT_SR9_PRDVTY[].
*****      LOOP AT GT_ZDSM_LINK INTO GW_ZDSM_LINK.
*****
*****        GW_SR9_SUMM-ZMONTH =  GW_ZDSM_LINK-ZMONTH.
*****        GW_SR9_SUMM-ZYEAR =  GW_ZDSM_LINK-ZYEAR.
*****        GW_SR9_SUMM-ZONESEQ =  GW_ZDSM_LINK-ZONESEQ.
*****
*****        GW_SR9_SUMM-SPART =  GW_ZDSM_LINK-SPART.
*****        GW_SR9_SUMM-DIV =  GW_ZDSM_LINK-DIV.
*****
*****        GW_SR9_SUMM-GM =  GW_ZDSM_LINK-GM.
*****        GW_SR9_SUMM-GM_PERNR =  GW_ZDSM_LINK-GM_PERNR.
*****        GW_SR9_SUMM-GM_ENAME =  GW_ZDSM_LINK-GM_ENAME.
*****        GW_SR9_SUMM-GM_DOJ =  GW_ZDSM_LINK-GM_DOJ.
*****        GW_SR9_SUMM-GM_HQ =  GW_ZDSM_LINK-GM_HQ.
*****        GW_SR9_SUMM-GM_SHORT =  GW_ZDSM_LINK-GM_SHORT.
*****        GW_SR9_SUMM-GM_EMAIL =  GW_ZDSM_LINK-GM_EMAIL.
*****
*****        GW_SR9_SUMM-ZM =  GW_ZDSM_LINK-ZM.
*****        GW_SR9_SUMM-ZM_PERNR =  GW_ZDSM_LINK-ZM_PERNR.
*****        GW_SR9_SUMM-ZM_ENAME =  GW_ZDSM_LINK-ZM_ENAME.
*****        GW_SR9_SUMM-ZM_DOJ =  GW_ZDSM_LINK-ZM_DOJ.
*****        GW_SR9_SUMM-ZM_HQ =  GW_ZDSM_LINK-ZM_HQ.
*****        GW_SR9_SUMM-ZM_SHORT =  GW_ZDSM_LINK-ZM_SHORT.
*****        GW_SR9_SUMM-ZM_EMAIL =  GW_ZDSM_LINK-ZM_EMAIL.
*****
*****        GW_SR9_SUMM-SALE =  GW_ZDSM_LINK-SALE / 1000.
*****        GW_SR9_SUMM-PSALE =  GW_ZDSM_LINK-PSALE / 1000.
*****        GW_SR9_SUMM-TARGET =  GW_ZDSM_LINK-TARGET / 1000.
*****        GW_SR9_SUMM-PTARGET =  GW_ZDSM_LINK-PTARGET / 1000.
*****        GW_SR9_SUMM-BZIRK_CNT = GW_SR9_SUMM-BZIRK_CNT + 1.
*****
*****        CATCH SYSTEM-EXCEPTIONS CONVERSION_ERRORS = 1 ARITHMETIC_ERRORS = 5.
*****          GW_SR9_SUMM-PER = ( GW_SR9_SUMM-SALE /  GW_SR9_SUMM-TARGET ) * 100.
*****        ENDCATCH.
*****
*****        GW_SR9_PRDVTY-ZMONTH = GW_SR9_SUMM-ZMONTH.
*****        GW_SR9_PRDVTY-ZYEAR = GW_SR9_SUMM-ZYEAR.
*****        GW_SR9_PRDVTY-DIV = GW_SR9_SUMM-DIV.
*****        GW_SR9_PRDVTY-GM = GW_SR9_SUMM-GM.
*****        GW_SR9_PRDVTY-SALE = GW_SR9_SUMM-SALE.
*****        GW_SR9_PRDVTY-PSALE = GW_SR9_SUMM-PSALE.
*****        GW_SR9_PRDVTY-TARGET = GW_SR9_SUMM-TARGET.
*****        GW_SR9_PRDVTY-PTARGET = GW_SR9_SUMM-PTARGET.
*****        GW_SR9_PRDVTY-BZIRK_CNT = GW_SR9_SUMM-BZIRK_CNT.
*****        IF GW_SR9_SUMM-PER >= 100.
*****          GW_SR9_PRDVTY-PER_CNT = GW_SR9_PRDVTY-PER_CNT + 1.
*****          GW_SR9_SUMM-PER_CNT = GW_SR9_SUMM-PER_CNT + 1.
*****        ENDIF.
*****        COLLECT GW_SR9_PRDVTY INTO GT_SR9_PRDVTY.
*****        CLEAR GW_SR9_PRDVTY.
*****        COLLECT GW_SR9_SUMM INTO GT_SR9_SUMM.
*****        CLEAR GW_SR9_SUMM.
*****      ENDLOOP.
*****    ENDIF.
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

  if r_dtl = 'X'.  "for SR9 Detail rep

    lv_pos = 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'BZIRK'.
    gw_fcat-seltext_l = 'TERRITORY'.
    gw_fcat-col_pos = lv_pos.
    gw_fcat-outputlen = '5'.
    gw_fcat-key = 'X'.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'ENAME'.
    gw_fcat-seltext_l = 'PSO NAME'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'HQ'.
    gw_fcat-seltext_l = 'PSO HQ'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'SHORT'.
    gw_fcat-seltext_l = 'PSO DESIGNATION'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'DOJ'.
    gw_fcat-seltext_l = 'PSO JOIN DT.'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'SALE'.
    gw_fcat-seltext_l = 'NET SALE'.
    gw_fcat-col_pos = lv_pos.
    gw_fcat-key = 'X'.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'TARGET'.
    gw_fcat-seltext_l = 'TARGET'.
    gw_fcat-col_pos = lv_pos.
    gw_fcat-key = 'X'.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'PER'.
    gw_fcat-seltext_l = '% BGT'.
    gw_fcat-col_pos = lv_pos.
    gw_fcat-key = 'X'.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'ZM'.
    gw_fcat-seltext_l = 'ZONE'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'ZM_ENAME'.
    gw_fcat-seltext_l = 'ZM NAME'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'ZM_HQ'.
    gw_fcat-seltext_l = 'ZM HQ'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'RM'.
    gw_fcat-seltext_l = 'REGION'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'RM_ENAME'.
    gw_fcat-seltext_l = 'RM NAME'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'RM_HQ'.
    gw_fcat-seltext_l = 'RM HQ'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.
  endif.

  if r_sum = 'X'.  "for SR9 Summary rep

    lv_pos = 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'BZIRK'.
    gw_fcat-seltext_l = 'TERRITORY'.
    gw_fcat-col_pos = lv_pos.
    gw_fcat-outputlen = '5'.
    gw_fcat-key = 'X'.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'ENAME'.
    gw_fcat-seltext_l = 'PSO NAME'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'HQ'.
    gw_fcat-seltext_l = 'PSO HQ'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'SHORT'.
    gw_fcat-seltext_l = 'PSO DESIGNATION'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'DOJ'.
    gw_fcat-seltext_l = 'PSO JOIN DT.'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'SALE'.
    if r_net = 'X'.
      gw_fcat-seltext_l = 'NET SALE'.
    endif.
    if r_gross = 'X'.
      gw_fcat-seltext_l = 'GROSS SALE'.
    endif.
    gw_fcat-col_pos = lv_pos.
    gw_fcat-key = 'X'.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'PSALE'.
    gw_fcat-seltext_l = 'PREV.YR.NET SALE'.
    gw_fcat-col_pos = lv_pos.
    gw_fcat-key = 'X'.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'TARGET'.
    gw_fcat-seltext_l = 'TARGET'.
    gw_fcat-col_pos = lv_pos.
    gw_fcat-key = 'X'.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'PER'.
    gw_fcat-seltext_l = '% BGT'.
    gw_fcat-col_pos = lv_pos.
    gw_fcat-key = 'X'.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'GM'.
    gw_fcat-seltext_l = 'GM REGION'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'GM_ENAME'.
    gw_fcat-seltext_l = 'GM NAME'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'GM_HQ'.
    gw_fcat-seltext_l = 'GM HQ'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'ZM'.
    gw_fcat-seltext_l = 'ZONE'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'ZM_ENAME'.
    gw_fcat-seltext_l = 'ZM NAME'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'ZM_HQ'.
    gw_fcat-seltext_l = 'ZM HQ'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'RM'.
    gw_fcat-seltext_l = 'RM'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'RM_ENAME'.
    gw_fcat-seltext_l = 'RM NAME'.
    gw_fcat-col_pos = lv_pos.
    append gw_fcat to gt_fcat.

    lv_pos = lv_pos + 1.
    clear gw_fcat.
    gw_fcat-fieldname = 'RM_HQ'.
    gw_fcat-seltext_l = 'RM HQ'.
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
         lv_str     type string,
         lv_dt_str1 type string.


  if r_dtl = 'X'.
    clear lv_str.

    concatenate 'SR9 Detail Report For ' p_mth '/' p_yr into  lv_str.
    lv_gtitle = lv_str.

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
*       I_DEFAULT          = 'X'
        i_save             = 'A'
      tables
        t_outtab           = gt_sr9_dtls[]
      exceptions
        program_error      = 1
        others             = 2.
    if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_SFORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form display_sform .
  data: fm_name type  tdsfname.


  if r_dtl = 'X'.    "for detail print
******* for print
    sort gt_sr9_dtls[] by zoneseq zdsm zm.
    clear gt_sr9_zm[].
    gt_sr9_zm[] = gt_sr9_dtls[].
    sort gt_sr9_zm by zm.
    delete adjacent duplicates from gt_sr9_zm[] comparing zm.

    clear gt_sr9_dzm[].
    gt_sr9_dzm[] = gt_sr9_dtls[].
    sort gt_sr9_dzm by zdsm zm rm.
    delete adjacent duplicates from gt_sr9_dzm comparing zdsm zm.
    if gt_sr9_dzm[] is not initial.
      loop at gt_sr9_dzm into gw_sr9_dzm.
        clear gw_yterr.
        read table gt_yterr into gw_yterr with key bzirk = gw_sr9_dzm-zdsm.
        if sy-subrc = 0.
          clear gw_0001.
          read table gt_0001 into gw_0001 with key plans = gw_yterr-plans.
          if sy-subrc = 0 and gw_0001-begda <= gv_join_dt and gw_0001-endda >= gv_endda..
            gw_sr9_dzm-rm_pernr = gw_0001-pernr00.
            gw_sr9_dzm-rm_ename = gw_0001-ename.
            gw_sr9_dzm-rm_doj = gw_0001-dtjoin.
            clear gw_0105.
            read table gt_0105 into gw_0105 with key pernr = gw_sr9_dzm-rm_pernr.
            if sy-subrc = 0.
              gw_sr9_dzm-rm_email = gw_0105-usrid_long.
            endif.
            clear gw_zfsdes.
            read table gt_zfsdes into gw_zfsdes with key persk = gw_0001-persk.
            if sy-subrc = 0.
              gw_sr9_dzm-rm_short = gw_zfsdes-short.
            endif.
            clear gw_hq_des.
            read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_0001-zz_hqcode.
            if sy-subrc = 0.
              gw_sr9_dzm-rm_hq = gw_hq_des-zz_hqdesc.
            endif.
          else.
            gw_zdsm_link-rm_ename = 'VACANT'.
            clear gw_zdrphq.
            read table gt_zdrphq into gw_zdrphq with key bzirk = gw_sr9_dzm-rm.
            if sy-subrc = 0.
              clear gw_hq_des.
              read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_zdrphq-zz_hqcode.
              if sy-subrc = 0.
                gw_sr9_dzm-rm_hq = gw_hq_des-zz_hqdesc.
              endif.
            endif.
          endif.
          modify gt_sr9_dzm from gw_sr9_dzm transporting rm_pernr rm_ename rm_doj rm_email rm_short rm_hq.
          clear gw_sr9_dzm.
        endif.
      endloop.
    endif.

    clear gt_sr9_rm[].
    gt_sr9_rm[] = gt_sr9_dtls[].
    sort gt_sr9_rm by zm rm.
    delete adjacent duplicates from gt_sr9_rm[] comparing zm rm.

    sort gt_sr9_zm by zoneseq zdsm zm.
    sort gt_sr9_dzm by zoneseq zdsm.
    sort gt_sr9_rm by zoneseq zdsm rm bzirk.
    sort gt_sr9_dtls[] by zoneseq zm rm bzirk.

    clear fm_name.
    call function 'SSF_FUNCTION_MODULE_NAME'
      exporting
        formname = gc_fm_name
      importing
        fm_name  = fm_name.

    gw_output_opts-tdnoprev = space."gc_true.
    gw_output_opts-tddest    = 'LOCL'.
    gw_output_opts-tdnoprint = space."gc_true.

    gw_contrl_para-getotf = space."gc_true.
    gw_contrl_para-no_dialog = space."gc_true.
    gw_contrl_para-preview = space.

    call function fm_name
      exporting
        control_parameters = gw_contrl_para
        output_options     = gw_output_opts
*       USER_SETTINGS      = 'X'
        gv_begda           = gv_begda
        gv_endda           = gv_endda
*    importing
*       document_output_info =
*       job_output_info    = gt_otf_data
*       job_output_options =
      tables
        gt_sr9_dtls        = gt_sr9_dtls[]
        gt_sr9_zm          = gt_sr9_zm[]
        gt_sr9_rm          = gt_sr9_rm[]
        gt_sr9_prdvty      = gt_sr9_prdvty[]
        gt_sr9_dzm         = gt_sr9_dzm[]
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

***********"for summary print *******************
  if r_sum = 'X'.
    sort gt_sr9_summ[] by zoneseq.
******* for GM wise print
    clear gt_sr9_gm[].
    gt_sr9_gm[] = gt_sr9_summ[].
    sort gt_sr9_gm by gm.
    delete adjacent duplicates from gt_sr9_gm[] comparing gm.
    sort gt_sr9_gm by zoneseq gm.

    clear fm_name.
    call function 'SSF_FUNCTION_MODULE_NAME'
      exporting
        formname = gc_fm_name1
      importing
        fm_name  = fm_name.

    gw_output_opts-tdnoprev = space."gc_true.
    gw_output_opts-tddest    = 'LOCL'.
    gw_output_opts-tdnoprint = space."gc_true.

    gw_contrl_para-getotf = space."gc_true.
    gw_contrl_para-no_dialog = space."gc_true.
    gw_contrl_para-preview = space.

    call function fm_name
      exporting
        control_parameters = gw_contrl_para
        output_options     = gw_output_opts
*       USER_SETTINGS      = 'X'
        r_net              = r_net
        r_gross            = r_gross
        p_tot              = p_tot
*    importing
*       document_output_info =
*       job_output_info    = gt_otf_data
*       job_output_options =
      tables
        gt_sr9_summ        = gt_sr9_summ[]
        gt_sr9_gm          = gt_sr9_gm[]
        gt_sr9_prdvty      = gt_sr9_prdvty[]
        gt_zdsmter         = gt_zdsmter[]
        gt_sr9_summ_rm     = gt_sr9_summ_rm[]
        gt_sr9_summ_zm     = gt_sr9_summ_zm[]
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
endform.
*&---------------------------------------------------------------------*
*&      Form  SEND_ZM_EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form send_zm_email using gw_sr9_zm_lp type zty_sr9_ho_summ .
  data: fm_name     type  tdsfname,
        lv_atta_sub type so_obj_des.

  if r_dtl = 'X'.    "for detail print
******* for print
    sort gt_sr9_dtls[] by zoneseq zdsm zm.
    clear gt_sr9_zm[].
    gt_sr9_zm[] = gt_sr9_dtls[].
    sort gt_sr9_zm by zm.
    delete adjacent duplicates from gt_sr9_zm[] comparing zm.
    delete gt_sr9_zm[] where zm <> gw_sr9_zm_lp-zm.

    clear gt_sr9_dzm[].
    gt_sr9_dzm[] = gt_sr9_dtls[].
    sort gt_sr9_dzm by zdsm zm rm.
    delete adjacent duplicates from gt_sr9_dzm comparing zdsm zm.
    delete gt_sr9_dzm[] where zm <> gw_sr9_zm_lp-zm.
    if gt_sr9_dzm[] is not initial.
      loop at gt_sr9_dzm into gw_sr9_dzm.
        clear gw_yterr.
        read table gt_yterr into gw_yterr with key bzirk = gw_sr9_dzm-zdsm.
        if sy-subrc = 0.
          clear gw_0001.
          read table gt_0001 into gw_0001 with key plans = gw_yterr-plans.
          if sy-subrc = 0 and gw_0001-begda <= gv_join_dt and gw_0001-endda >= gv_endda..
            gw_sr9_dzm-rm_pernr = gw_0001-pernr00.
            gw_sr9_dzm-rm_ename = gw_0001-ename.
            gw_sr9_dzm-rm_doj = gw_0001-dtjoin.
            clear gw_0105.
            read table gt_0105 into gw_0105 with key pernr = gw_sr9_dzm-rm_pernr.
            if sy-subrc = 0.
              gw_sr9_dzm-rm_email = gw_0105-usrid_long.
            endif.
            clear gw_zfsdes.
            read table gt_zfsdes into gw_zfsdes with key persk = gw_0001-persk.
            if sy-subrc = 0.
              gw_sr9_dzm-rm_short = gw_zfsdes-short.
            endif.
            clear gw_hq_des.
            read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_0001-zz_hqcode.
            if sy-subrc = 0.
              gw_sr9_dzm-rm_hq = gw_hq_des-zz_hqdesc.
            endif.
          else.
            gw_zdsm_link-rm_ename = 'VACANT'.
            clear gw_zdrphq.
            read table gt_zdrphq into gw_zdrphq with key bzirk = gw_sr9_dzm-rm.
            if sy-subrc = 0.
              clear gw_hq_des.
              read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_zdrphq-zz_hqcode.
              if sy-subrc = 0.
                gw_sr9_dzm-rm_hq = gw_hq_des-zz_hqdesc.
              endif.
            endif.
          endif.
          modify gt_sr9_dzm from gw_sr9_dzm transporting rm_pernr rm_ename rm_doj rm_email rm_short rm_hq.
          clear gw_sr9_dzm.
        endif.
      endloop.
    endif.

    clear gt_sr9_rm[].
    gt_sr9_rm[] = gt_sr9_dtls[].
    sort gt_sr9_rm by zm rm.
    delete adjacent duplicates from gt_sr9_rm[] comparing zm rm.
    delete gt_sr9_rm where zm <> gw_sr9_zm_lp-zm.

    sort gt_sr9_zm by zoneseq zdsm zm.
    sort gt_sr9_dzm by zoneseq zdsm.
    sort gt_sr9_rm by zoneseq zdsm rm bzirk.
    sort gt_sr9_dtls[] by zoneseq zm rm bzirk.
    sort gt_sr9_prdvty[] by zm.

    clear fm_name.
    call function 'SSF_FUNCTION_MODULE_NAME'
      exporting
        formname = gc_fm_name
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
        control_parameters = gw_contrl_para
        output_options     = gw_output_opts
*       USER_SETTINGS      = 'X'
        gv_begda           = gv_begda
        gv_endda           = gv_endda
      importing
*       document_output_info =
        job_output_info    = gt_otf_data
*       job_output_options =
      tables
        gt_sr9_dtls        = gt_sr9_dtls[]
        gt_sr9_zm          = gt_sr9_zm[]
        gt_sr9_rm          = gt_sr9_rm[]
        gt_sr9_prdvty      = gt_sr9_prdvty[]
        gt_sr9_dzm         = gt_sr9_dzm[]
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

********************** for e-mail sending ***********************
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
        clear gt_text.
        clear gv_text.
        concatenate 'This eMail is meant for information only. Please DO NOT REPLY.' cl_abap_char_utilities=>newline into gv_text.
        append gv_text to gt_text.
        clear gv_text.
        clear gv_text.
        concatenate cl_abap_char_utilities=>newline gv_text into gv_text.
        concatenate cl_abap_char_utilities=>newline gv_text into gv_text.
        append ' BLUE CROSS LABORATORIES PRIVATE LTD.' to gt_text.

****Add the email body content to document
        clear : gv_text, gv_subject.
        concatenate 'SR9: Sales flash for: ' gw_sr9_zm_lp-zmonth '/' gw_sr9_zm_lp-zyear into gv_subject separated by space.
        lo_doc_bcs = cl_document_bcs=>create_document(
                       i_type    = 'RAW'
                       i_text    = gt_text[]
                       i_length  = '12'
                       i_subject = gv_subject ).   "Subject of the Email

***     Add attachment to document and Add document to send request
***The internal table gt_pdf_data[] contains the content of our attachment.
        clear: gv_text ,lv_atta_sub.
        concatenate 'SR-9' gw_sr9_zm_lp-zm_ename into gv_text.
        lv_atta_sub = gv_text.

        call method lo_doc_bcs->add_attachment
          exporting
            i_attachment_type    = 'PDF'
            i_attachment_size    = gv_bin_filesize
            i_attachment_subject = lv_atta_sub
            i_att_content_hex    = gt_pdf_data.

*     add document to send request
        call method lo_bcs->set_document( lo_doc_bcs ).

****    Set Sender
        lo_sender = cl_cam_address_bcs=>create_internet_address( i_address_string = gc_email_sender
                                                                 i_address_name = 'SR-9' ).
        call method lo_bcs->set_sender
          exporting
            i_sender = lo_sender.

****    Add recipient (e–mail address)
        lo_recep = cl_cam_address_bcs=>create_internet_address( gw_sr9_zm_lp-zm_email ).
        "Add recipient with its respective attributes to send request
        call method lo_bcs->add_recipient
          exporting
            i_recipient = lo_recep
            i_express   = gc_true.
******** Requested status of email notification on READ and ERROR
        call method lo_bcs->set_status_attributes
          exporting
            i_requested_status = 'R'
            i_status_mail      = 'E'.

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
          clear gv_msg.
          concatenate 'Email sent successfully to :' gw_sr9_zm_lp-zm_email into gv_msg separated by space.
          message gv_msg  type 'S'.
        endif.



      catch cx_bcs into lo_cx_bcx.
        "Appropriate Exception Handling
*****        write: 'Exception:', lo_cx_bcx->error_type.
        write: 'Exception:', lo_cx_bcx->error_text.
    endtry.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  SEND_EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_MAILID  text
*----------------------------------------------------------------------*
form send_email  using  p_mailid type ad_smtpadr.

  data: fm_name     type  tdsfname,
        lv_atta_sub type so_obj_des.

**************** "for detail print ********************
  if r_dtl = 'X'.    "for detail print
******* for print
    sort gt_sr9_dtls[] by zoneseq zdsm zm.
    clear gt_sr9_zm[].
    gt_sr9_zm[] = gt_sr9_dtls[].
    sort gt_sr9_zm by zm.
    delete adjacent duplicates from gt_sr9_zm[] comparing zm.


    clear gt_sr9_dzm[].
    gt_sr9_dzm[] = gt_sr9_dtls[].
    sort gt_sr9_dzm by zdsm zm rm.
    delete adjacent duplicates from gt_sr9_dzm comparing zdsm zm.

    if gt_sr9_dzm[] is not initial.
      loop at gt_sr9_dzm into gw_sr9_dzm.
        clear gw_yterr.
        read table gt_yterr into gw_yterr with key bzirk = gw_sr9_dzm-zdsm.
        if sy-subrc = 0.
          clear gw_0001.
          read table gt_0001 into gw_0001 with key plans = gw_yterr-plans.
          if sy-subrc = 0 and gw_0001-begda <= gv_join_dt and gw_0001-endda >= gv_endda..
            gw_sr9_dzm-rm_pernr = gw_0001-pernr00.
            gw_sr9_dzm-rm_ename = gw_0001-ename.
            gw_sr9_dzm-rm_doj = gw_0001-dtjoin.
            clear gw_0105.
            read table gt_0105 into gw_0105 with key pernr = gw_sr9_dzm-rm_pernr.
            if sy-subrc = 0.
              gw_sr9_dzm-rm_email = gw_0105-usrid_long.
            endif.
            clear gw_zfsdes.
            read table gt_zfsdes into gw_zfsdes with key persk = gw_0001-persk.
            if sy-subrc = 0.
              gw_sr9_dzm-rm_short = gw_zfsdes-short.
            endif.
            clear gw_hq_des.
            read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_0001-zz_hqcode.
            if sy-subrc = 0.
              gw_sr9_dzm-rm_hq = gw_hq_des-zz_hqdesc.
            endif.
          else.
            gw_zdsm_link-rm_ename = 'VACANT'.
            clear gw_zdrphq.
            read table gt_zdrphq into gw_zdrphq with key bzirk = gw_sr9_dzm-rm.
            if sy-subrc = 0.
              clear gw_hq_des.
              read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_zdrphq-zz_hqcode.
              if sy-subrc = 0.
                gw_sr9_dzm-rm_hq = gw_hq_des-zz_hqdesc.
              endif.
            endif.
          endif.
          modify gt_sr9_dzm from gw_sr9_dzm transporting rm_pernr rm_ename rm_doj rm_email rm_short rm_hq.
          clear gw_sr9_dzm.
        endif.
      endloop.
    endif.

    clear gt_sr9_rm[].
    gt_sr9_rm[] = gt_sr9_dtls[].
    sort gt_sr9_rm by zm rm.
    delete adjacent duplicates from gt_sr9_rm[] comparing zm rm.


    sort gt_sr9_zm by zoneseq zdsm zm.
    sort gt_sr9_dzm by zoneseq zdsm.
    sort gt_sr9_rm by zoneseq zdsm rm bzirk.
    sort gt_sr9_dtls[] by zoneseq zm rm bzirk.
    sort gt_sr9_prdvty[] by zm.

    clear fm_name.
    call function 'SSF_FUNCTION_MODULE_NAME'
      exporting
        formname = gc_fm_name
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
        control_parameters = gw_contrl_para
        output_options     = gw_output_opts
*       USER_SETTINGS      = 'X'
        gv_begda           = gv_begda
        gv_endda           = gv_endda
      importing
*       document_output_info =
        job_output_info    = gt_otf_data
*       job_output_options =
      tables
        gt_sr9_dtls        = gt_sr9_dtls[]
        gt_sr9_zm          = gt_sr9_zm[]
        gt_sr9_rm          = gt_sr9_rm[]
        gt_sr9_prdvty      = gt_sr9_prdvty[]
        gt_sr9_dzm         = gt_sr9_dzm[]
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

***********"for summary print *******************
  if r_sum = 'X'.
    sort gt_sr9_summ[] by zoneseq.
******* for GM wise print
    clear gt_sr9_gm[].
    gt_sr9_gm[] = gt_sr9_summ[].
    sort gt_sr9_gm by gm.
    delete adjacent duplicates from gt_sr9_gm[] comparing gm.
    sort gt_sr9_gm by zoneseq gm.

    clear fm_name.
    call function 'SSF_FUNCTION_MODULE_NAME'
      exporting
        formname = gc_fm_name1
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
        control_parameters = gw_contrl_para
        output_options     = gw_output_opts
*       USER_SETTINGS      = 'X'
        r_net              = r_net
        r_gross            = r_gross
        p_tot              = p_tot
      importing
*       document_output_info =
        job_output_info    = gt_otf_data
*       job_output_options =
      tables
        gt_sr9_summ        = gt_sr9_summ[]
        gt_sr9_gm          = gt_sr9_gm[]
        gt_sr9_prdvty      = gt_sr9_prdvty[]
        gt_zdsmter         = gt_zdsmter[]
        gt_sr9_summ_rm     = gt_sr9_summ_rm[]
        gt_sr9_summ_zm     = gt_sr9_summ_zm[]
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

********************** for e-mail sending ***********************
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
        clear gt_text.
        clear gv_text.
        concatenate 'This eMail is meant for information only. Please DO NOT REPLY.' cl_abap_char_utilities=>newline into gv_text.
        append gv_text to gt_text.
        clear gv_text.
        clear gv_text.
        concatenate cl_abap_char_utilities=>newline gv_text into gv_text.
        concatenate cl_abap_char_utilities=>newline gv_text into gv_text.
        append ' BLUE CROSS LABORATORIES PRIVATE LTD.' to gt_text.

****Add the email body content to document
        clear : gv_text, gv_subject.
        if r_dtl = 'X'.
          concatenate 'SR9: Sales flash for: ' p_mth '/' p_yr into gv_subject separated by space.
        endif.
        if r_sum = 'X'.
          concatenate 'SR9: COMPANY SUMMARY: ' p_mth '/' p_yr into gv_subject separated by space.
        endif.
        lo_doc_bcs = cl_document_bcs=>create_document(
                       i_type    = 'RAW'
                       i_text    = gt_text[]
                       i_length  = '12'
                       i_subject = gv_subject ).   "Subject of the Email

***     Add attachment to document and Add document to send request
***The internal table gt_pdf_data[] contains the content of our attachment.
        clear: gv_text ,lv_atta_sub.
        if r_dtl = 'X'.
          concatenate 'SR-9' p_mth '/' p_yr into gv_text.
        endif.
        if r_sum = 'X'.
          concatenate 'SR-9-Summary' p_mth '/' p_yr into gv_text.
        endif.
        lv_atta_sub = gv_text.

        call method lo_doc_bcs->add_attachment
          exporting
            i_attachment_type    = 'PDF'
            i_attachment_size    = gv_bin_filesize
            i_attachment_subject = lv_atta_sub
            i_att_content_hex    = gt_pdf_data.

*     add document to send request
        call method lo_bcs->set_document( lo_doc_bcs ).

****    Set Sender
        lo_sender = cl_cam_address_bcs=>create_internet_address( i_address_string = gc_email_sender
                                                                 i_address_name = 'SR-9' ).
        call method lo_bcs->set_sender
          exporting
            i_sender = lo_sender.

****    Add recipient (e–mail address)
        lo_recep = cl_cam_address_bcs=>create_internet_address( p_mailid ).
        "Add recipient with its respective attributes to send request
        call method lo_bcs->add_recipient
          exporting
            i_recipient = lo_recep
            i_express   = gc_true.
******** Requested status of email notification on READ and ERROR
        call method lo_bcs->set_status_attributes
          exporting
            i_requested_status = 'R'
            i_status_mail      = 'E'.

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
          clear gv_msg.
          concatenate 'Email sent successfully to :' p_mailid into gv_msg separated by space.
          message gv_msg  type 'S'.
        endif.

      catch cx_bcs into lo_cx_bcx.
        "Appropriate Exception Handling
*****        write: 'Exception:', lo_cx_bcx->error_type.
        write: 'Exception:', lo_cx_bcx->error_text.
    endtry.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  GET_SUMMARY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form get_summary_data .
  data : lv_bzirk_cnt type i.
**** month begin date.
  gv_begda+6(2) = '01'.
  gv_begda+4(2) = p_mth.
  gv_begda+0(4) = p_yr.
**** date to check if anyone joined after 15th of selected month
  clear gv_join_dt.
  gv_join_dt = gv_begda.
  gv_join_dt+6(2) = '15'.
  clear gv_endda.
  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date           = gv_begda
    importing
      ev_month_end_date = gv_endda.

****target year
  clear gv_tgt_yr.
  if p_mth le '03'.
    gv_tgt_yr = p_yr - 1.
  else.
    gv_tgt_yr = p_yr.
  endif.

****** prepare for zm/rm/dzm/gm/terr link.
  clear gt_zdsmter[].
  select * from zdsmter into table gt_zdsmter where zmonth = p_mth and zyear = p_yr.
  sort gt_zdsmter by zdsm.
  clear gt_zm[].
  gt_zm[] = gt_zdsmter[].
  sort gt_zm by zdsm.
  delete gt_zm where zdsm+0(2) <> 'D-'.

  clear gt_rm[].
  gt_rm[] = gt_zdsmter[].
  sort gt_rm by zdsm.
  delete gt_rm where zdsm+0(2) <> 'R-'.

  clear gt_gm[].
  gt_gm[] = gt_zdsmter[].
  sort gt_gm by zdsm.
  delete gt_gm where zdsm+0(2) <> 'G-'.

  clear gt_dzm[].
  gt_dzm[] = gt_zdsmter[].
  sort gt_dzm by zdsm.
  delete gt_dzm where zdsm+0(2) <> 'Z-'.


  clear gt_yterr[].
  select *
    into table gt_yterr
    from yterrallc
    where begda le gv_begda and endda ge gv_endda.

  clear gt_0001[].
  select a~pernr a~begda
         b~pernr b~begda b~endda b~abkrs b~ansvh b~persk b~plans b~ename b~zz_hqcode into table gt_0001
    from pa0000 as a inner join pa0001 as b
    on a~pernr = b~pernr
    where a~massn = '01'
    and b~endda = '99991231'.
  if sy-subrc = 0.
    clear gt_0105[].
    select pernr subty usrid_long from pa0105 into table gt_0105
      where subty = '0010'.
    if sy-subrc = 0.
      sort gt_0105 by pernr.
      delete adjacent duplicates from gt_0105 comparing pernr.
    endif.
  endif.


***** HQ des
  clear gt_hq_des[].
  select * from zthr_heq_des into table gt_hq_des.

***** HQ des
  clear gt_zdrphq[].
  select * from zdrphq into table gt_zdrphq.

*****  short/postion name
  clear gt_zfsdes[].
  select * from zfsdes into table gt_zfsdes.

**** zone-wise sequence for printing
  clear gt_zoneseq[].
  select * from zoneseq into table gt_zoneseq.

****** sales details curr.yr
  clear gt_zcumpso[].
  select * from zcumpso into table gt_zcumpso
    where zmonth = p_mth
    and zyear = p_yr.
***** sales details prev.yr
  clear gt_zrcumpso[].
  gv_lyr = p_yr - 1.
  select * from zrcumpso into table gt_zrcumpso
    where zmonth = p_mth
    and zyear = gv_lyr.

******* target details
  clear gt_target[].
  select * from ysd_dist_targt into table gt_target
    where trgyear = gv_tgt_yr.

  clear gt_hbe_target[].
  select * from ysd_hbe_targt into table gt_hbe_target
    where trgyear =   gv_tgt_yr.

  sort gt_gm by zdsm.
  sort gt_zm by zdsm.
  sort gt_rm by zdsm bzirk.
  sort gt_dzm by zdsm.

  sort gt_zdsmter[] by zdsm bzirk.
  sort gt_yterr[] by bzirk.
  sort gt_0001[] by pernr00.
  sort gt_0105[] by pernr.
  sort gt_hq_des[] by zz_hqcode.
  sort gt_zfsdes[] by persk.
  sort gt_zcumpso[] by bzirk.
  sort gt_zrcumpso[] by bzirk.
  sort gt_target[] by bzirk.
  sort gt_hbe_target[] by bzirk.

****** get GM/ZM/DZM/RM/PSO link wirh sales/target- details
  clear gt_zdsm_link[].
  loop at gt_gm into gw_gm.
    clear gw_zm.
    loop at  gt_zm into gw_zm where zdsm = gw_gm-bzirk.
      clear gw_rm.
      loop at gt_rm into gw_rm where zdsm = gw_zm-bzirk.
****** GM name/hq/doj/short position details
        gw_zdsm_link-zdsm = gw_gm-zdsm.
        gw_zdsm_link-gm = gw_gm-zdsm.
        gw_zdsm_link-zmonth = gw_gm-zmonth.
        gw_zdsm_link-zyear = gw_gm-zyear.


        clear gw_yterr.
        read table gt_yterr into gw_yterr with key bzirk = gw_zdsm_link-gm.
        if sy-subrc = 0.
          clear gw_0001.
          read table gt_0001 into gw_0001 with key plans = gw_yterr-plans.
          if sy-subrc = 0 and gw_0001-begda <= gv_join_dt and gw_0001-endda >= gv_endda..
            gw_zdsm_link-gm_pernr = gw_0001-pernr00.
            gw_zdsm_link-gm_ename = gw_0001-ename.
            gw_zdsm_link-gm_doj = gw_0001-dtjoin.
            clear gw_0105.
            read table gt_0105 into gw_0105 with key pernr = gw_zdsm_link-gm_pernr.
            if sy-subrc = 0.
              gw_zdsm_link-gm_email = gw_0105-usrid_long.
            endif.

            clear gw_zfsdes.
            read table gt_zfsdes into gw_zfsdes with key persk = gw_0001-persk.
            if sy-subrc = 0.
              gw_zdsm_link-gm_short = gw_zfsdes-short.
            endif.
            clear gw_hq_des.
            read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_0001-zz_hqcode.
            if sy-subrc = 0.
              gw_zdsm_link-gm_hq = gw_hq_des-zz_hqdesc.
            endif.
          else.
            gw_zdsm_link-gm_ename = 'VACANT'.
            clear gw_zdrphq.
            read table gt_zdrphq into gw_zdrphq with key bzirk = gw_zdsm_link-gm.
            if sy-subrc = 0.
              clear gw_hq_des.
              read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_zdrphq-zz_hqcode.
              if sy-subrc = 0.
                gw_zdsm_link-gm_hq = gw_hq_des-zz_hqdesc.
              endif.
            endif.
          endif.
        endif.

****** ZM name/hq/doj details
        gw_zdsm_link-zdsm = gw_zm-zdsm.
        gw_zdsm_link-zm = gw_zm-zdsm.

        clear gw_yterr.
        read table gt_yterr into gw_yterr with key bzirk = gw_zdsm_link-zm.
        if sy-subrc = 0.
          clear gw_0001.
          read table gt_0001 into gw_0001 with key plans = gw_yterr-plans.
          if sy-subrc = 0 and gw_0001-begda <= gv_join_dt and gw_0001-endda >= gv_endda..
            gw_zdsm_link-zm_pernr = gw_0001-pernr00.
            gw_zdsm_link-zm_ename = gw_0001-ename.
            gw_zdsm_link-zm_doj = gw_0001-dtjoin.
            clear gw_0105.
            read table gt_0105 into gw_0105 with key pernr = gw_zdsm_link-zm_pernr.
            if sy-subrc = 0.
              gw_zdsm_link-zm_email = gw_0105-usrid_long.
            endif.
            clear gw_zfsdes.
            read table gt_zfsdes into gw_zfsdes with key persk = gw_0001-persk.
            if sy-subrc = 0.
              gw_zdsm_link-zm_short = gw_zfsdes-short.
            endif.
            clear gw_hq_des.
            read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_0001-zz_hqcode.
            if sy-subrc = 0.
              gw_zdsm_link-zm_hq = gw_hq_des-zz_hqdesc.
            endif.
          else.
            gw_zdsm_link-zm_ename = 'VACANT'.
            clear gw_zdrphq.
            read table gt_zdrphq into gw_zdrphq with key bzirk = gw_zdsm_link-zm.
            if sy-subrc = 0.
              clear gw_hq_des.
              read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_zdrphq-zz_hqcode.
              if sy-subrc = 0.
                gw_zdsm_link-zm_hq = gw_hq_des-zz_hqdesc.
              endif.
            endif.
          endif.
        endif.

*******  zone-wise sequence for printing
        clear gw_zoneseq.
        read table gt_zoneseq into gw_zoneseq with key zone_dist = gw_zdsm_link-zm.
        if sy-subrc = 0.
          gw_zdsm_link-zoneseq = gw_zoneseq-seq.
        endif.

****** RM name/hq/doj details
        gw_zdsm_link-zdsm = gw_rm-zdsm.
        gw_zdsm_link-rm = gw_rm-zdsm.
        gw_zdsm_link-bzirk = gw_rm-bzirk.
*****        GW_ZDSM_LINK-SPART = GW_RM-SPART.

        clear gw_yterr.
        read table gt_yterr into gw_yterr with key bzirk = gw_zdsm_link-rm.
        if sy-subrc = 0.
          clear gw_0001.
          read table gt_0001 into gw_0001 with key plans = gw_yterr-plans.
          if sy-subrc = 0 and gw_0001-begda <= gv_join_dt and gw_0001-endda >= gv_endda..
            gw_zdsm_link-rm_pernr = gw_0001-pernr00.
            gw_zdsm_link-rm_ename = gw_0001-ename.
            gw_zdsm_link-rm_doj = gw_0001-dtjoin.
            clear gw_0105.
            read table gt_0105 into gw_0105 with key pernr = gw_zdsm_link-rm_pernr.
            if sy-subrc = 0.
              gw_zdsm_link-rm_email = gw_0105-usrid_long.
            endif.
            clear gw_zfsdes.
            read table gt_zfsdes into gw_zfsdes with key persk = gw_0001-persk.
            if sy-subrc = 0.
              gw_zdsm_link-rm_short = gw_zfsdes-short.
            endif.
            clear gw_hq_des.
            read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_0001-zz_hqcode.
            if sy-subrc = 0.
              gw_zdsm_link-rm_hq = gw_hq_des-zz_hqdesc.
            endif.
          else.
            gw_zdsm_link-rm_ename = 'VACANT'.
            clear gw_zdrphq.
            read table gt_zdrphq into gw_zdrphq with key bzirk = gw_zdsm_link-rm.
            if sy-subrc = 0.
              clear gw_hq_des.
              read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_zdrphq-zz_hqcode.
              if sy-subrc = 0.
                gw_zdsm_link-rm_hq = gw_hq_des-zz_hqdesc.
              endif.
            endif.
          endif.
        endif.

******* set division
        clear gw_zdsmter.
        read table gt_zdsmter into gw_zdsmter with key bzirk = gw_rm-bzirk spart = '50'.
        if sy-subrc = 0.
          clear gw_zdsmter1.
          read table gt_zdsmter into gw_zdsmter1 with key bzirk = gw_zdsmter-bzirk spart = '60'.
          if sy-subrc = 0.
            gw_zdsm_link-div = 'BC'.
          else.
            gw_zdsm_link-div = 'BC'.
          endif.
        else.
          clear gw_zdsmter.
          read table gt_zdsmter into gw_zdsmter with key bzirk = gw_rm-bzirk spart = '60'.
          if sy-subrc = 0.
            gw_zdsm_link-div = 'XL'.
          else.
            clear gw_zdsmter.
            read table gt_zdsmter into gw_zdsmter with key bzirk = gw_rm-bzirk spart = '70'.
            if sy-subrc = 0.
              gw_zdsm_link-div = 'LS'.
            endif.
          endif.
        endif.

******  sales curr.yr
        clear gw_zcumpso.
        read table gt_zcumpso into gw_zcumpso with key bzirk =  gw_zdsm_link-bzirk.
        if sy-subrc = 0.
          if r_net = 'X'.
            gw_zdsm_link-sale = gw_zcumpso-netval.
          endif.
          if r_gross = 'X'.
            gw_zdsm_link-sale = gw_zcumpso-grosspts + gw_zcumpso-rval + gw_zcumpso-nepval.
          endif.
        endif.

******  sales prev.yr
        clear gw_zrcumpso.
        read table gt_zrcumpso into gw_zrcumpso with key bzirk =  gw_zdsm_link-bzirk.
        if sy-subrc = 0.
          if r_net = 'X'.
            gw_zdsm_link-psale = gw_zrcumpso-netval.
          endif.
          if r_gross = 'X'.
            gw_zdsm_link-psale = gw_zrcumpso-grosspts + gw_zrcumpso-rval + gw_zrcumpso-nepval.
          endif.
        endif.

****** PSO name/hq/doj details
        clear gw_yterr.
        read table gt_yterr into gw_yterr with key bzirk = gw_zdsm_link-bzirk.
        if sy-subrc = 0.
          clear gw_0001.
          read table gt_0001 into gw_0001 with key plans = gw_yterr-plans.
          if sy-subrc = 0 and gw_0001-begda <= gv_join_dt and gw_0001-endda >= gv_endda..
            gw_zdsm_link-pernr = gw_0001-pernr00.
            gw_zdsm_link-ename = gw_0001-ename.
            gw_zdsm_link-doj = gw_0001-dtjoin.
            clear gw_0105.
            read table gt_0105 into gw_0105 with key pernr = gw_zdsm_link-pernr.
            if sy-subrc = 0.
              gw_zdsm_link-email = gw_0105-usrid_long.
            endif.
            clear gw_zfsdes.
            read table gt_zfsdes into gw_zfsdes with key persk = gw_0001-persk.
            if sy-subrc = 0.
              gw_zdsm_link-short = gw_zfsdes-short.
            endif.
            clear gw_hq_des.
            read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_0001-zz_hqcode.
            if sy-subrc = 0.
              gw_zdsm_link-hq = gw_hq_des-zz_hqdesc.
            endif.
          else.
            gw_zdsm_link-ename = 'VACANT'.
            clear gw_zdrphq.
            read table gt_zdrphq into gw_zdrphq with key bzirk = gw_zdsm_link-bzirk.
            if sy-subrc = 0.
              clear gw_hq_des.
              read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_zdrphq-zz_hqcode.
              if sy-subrc = 0.
                gw_zdsm_link-hq = gw_hq_des-zz_hqdesc.
              endif.
            endif.
          endif.
*****        endif.

******   target details
          clear gw_target.
          read table gt_target into gw_target with key bzirk = gw_zdsm_link-bzirk spart = gw_rm-spart.
          if sy-subrc = 0.
            case p_mth.
              when '04'.
                gw_zdsm_link-target = gw_target-month01.
              when '05'.
                gw_zdsm_link-target = gw_target-month02.
              when '06'.
                gw_zdsm_link-target = gw_target-month03.
              when '07'.
                gw_zdsm_link-target = gw_target-month04.
              when '08'.
                gw_zdsm_link-target = gw_target-month05.
              when '09'.
                gw_zdsm_link-target = gw_target-month06.
              when '10'.
                gw_zdsm_link-target = gw_target-month07.
              when '11'.
                gw_zdsm_link-target = gw_target-month08.
              when '12'.
                gw_zdsm_link-target = gw_target-month09.
              when '01'.
                gw_zdsm_link-target = gw_target-month10.
              when '02'.
                gw_zdsm_link-target = gw_target-month11.
              when '03'.
                gw_zdsm_link-target = gw_target-month12.
            endcase.

********if target is zero then take target bfrom hosital pack - YSD_HBE_TARGT*************
            if gt_hbe_target[] is not initial.
              clear gw_hbe_target.
              read table gt_hbe_target into gw_hbe_target with key bzirk = gw_zdsm_link-bzirk spart = gw_rm-spart.
              if sy-subrc = 0.
                case p_mth.
                  when '04'.
                    gw_zdsm_link-target = gw_hbe_target-month01.
                  when '05'.
                    gw_zdsm_link-target = gw_hbe_target-month02.
                  when '06'.
                    gw_zdsm_link-target = gw_hbe_target-month03.
                  when '07'.
                    gw_zdsm_link-target = gw_hbe_target-month04.
                  when '08'.
                    gw_zdsm_link-target = gw_hbe_target-month05.
                  when '09'.
                    gw_zdsm_link-target = gw_hbe_target-month06.
                  when '10'.
                    gw_zdsm_link-target = gw_hbe_target-month07.
                  when '11'.
                    gw_zdsm_link-target = gw_hbe_target-month08.
                  when '12'.
                    gw_zdsm_link-target = gw_hbe_target-month09.
                  when '01'.
                    gw_zdsm_link-target = gw_hbe_target-month10.
                  when '02'.
                    gw_zdsm_link-target = gw_hbe_target-month11.
                  when '03'.
                    gw_zdsm_link-target = gw_hbe_target-month12.
                endcase.
              endif.
            endif.

            collect gw_zdsm_link into gt_zdsm_link.
            clear gw_zdsm_link.
          endif.
        endif.
      endloop.
    endloop.
  endloop.

  if gt_zdsm_link[] is not initial.
    clear gt_sr9_summ[].
    clear gt_sr9_summ_zm[].
    clear gt_sr9_summ_rm[].
    clear gt_sr9_prdvty[].
    if s_gm[] is not initial.
      sort gt_zdsm_link[] by zoneseq gm zm rm bzirk.
      delete gt_zdsm_link[] where gm not in s_gm[].
      sort gt_zdsm_link[] by spart gm zm rm bzirk pernr.
      delete adjacent duplicates from gt_zdsm_link[] comparing gm zm rm bzirk pernr.
    endif.
    loop at gt_zdsm_link into gw_zdsm_link.
      gw_sr9_summ-zmonth = gw_zdsm_link-zmonth.
      gw_sr9_summ-zyear = gw_zdsm_link-zyear.
      gw_sr9_summ-zoneseq =  gw_zdsm_link-zoneseq.
      gw_sr9_summ-div =  gw_zdsm_link-div.

      gw_sr9_summ-gm =  gw_zdsm_link-gm.
      gw_sr9_summ-gm_pernr =  gw_zdsm_link-gm_pernr.
      gw_sr9_summ-gm_ename =  gw_zdsm_link-gm_ename.
      gw_sr9_summ-gm_doj =  gw_zdsm_link-gm_doj.
      gw_sr9_summ-gm_hq =  gw_zdsm_link-gm_hq.
      gw_sr9_summ-gm_short =  gw_zdsm_link-gm_short.
      gw_sr9_summ-gm_email =  gw_zdsm_link-gm_email.

      gw_sr9_summ-zm = gw_zdsm_link-zm.
      gw_sr9_summ-zm_pernr = gw_zdsm_link-zm_pernr.
      gw_sr9_summ-zm_ename = gw_zdsm_link-zm_ename.
      gw_sr9_summ-zm_doj = gw_zdsm_link-zm_doj.
      gw_sr9_summ-zm_hq = gw_zdsm_link-zm_hq.
      gw_sr9_summ-zm_short = gw_zdsm_link-zm_short.

      gw_sr9_summ-sale =  gw_zdsm_link-sale / 1000.
      gw_sr9_summ-psale =  gw_zdsm_link-psale / 1000.
      gw_sr9_summ-target =  gw_zdsm_link-target / 1000.
      gw_sr9_summ-ptarget =  gw_zdsm_link-ptarget / 1000.

      gw_sr9_summ-bzirk_cnt = gw_sr9_summ-bzirk_cnt + 1 .

      catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
        gw_sr9_summ-per = ( gw_sr9_summ-sale /  gw_sr9_summ-target ) * 100.
      endcatch.

      gw_sr9_prdvty-zmonth = gw_sr9_summ-zmonth.
      gw_sr9_prdvty-zyear = gw_sr9_summ-zyear.
      gw_sr9_prdvty-div = gw_sr9_summ-div.
      gw_sr9_prdvty-gm = gw_sr9_summ-gm.
      gw_sr9_prdvty-sale = gw_sr9_summ-sale.
      gw_sr9_prdvty-psale = gw_sr9_summ-psale.
      gw_sr9_prdvty-target = gw_sr9_summ-target.
      gw_sr9_prdvty-ptarget = gw_sr9_summ-ptarget.
      gw_sr9_prdvty-bzirk_cnt = gw_sr9_summ-bzirk_cnt.
      if gw_sr9_summ-per >= 100.
        gw_sr9_prdvty-per_cnt = 1.
        gw_sr9_summ-per_cnt = 1.
      endif.
****** for div-wise total ZM on target
      gw_sr9_summ_zm-zm = gw_zdsm_link-zm.
      gw_sr9_summ_zm-div = gw_zdsm_link-div.
      gw_sr9_summ_zm-sale =  gw_sr9_summ-sale.
      gw_sr9_summ_zm-psale =  gw_sr9_summ-psale.
      gw_sr9_summ_zm-target =  gw_sr9_summ-target.
      gw_sr9_summ_zm-ptarget =  gw_sr9_summ-ptarget.

      collect gw_sr9_summ_zm into gt_sr9_summ_zm.
      clear gw_sr9_summ_zm.


****** for div-wise total RM on target
      gw_sr9_summ_rm-rm = gw_zdsm_link-rm.
      gw_sr9_summ_rm-div = gw_zdsm_link-div.
      gw_sr9_summ_rm-sale =  gw_sr9_summ-sale.
      gw_sr9_summ_rm-psale =  gw_sr9_summ-psale.
      gw_sr9_summ_rm-target =  gw_sr9_summ-target.
      gw_sr9_summ_rm-ptarget =  gw_sr9_summ-ptarget.

      collect gw_sr9_summ_rm into gt_sr9_summ_rm.
      clear gw_sr9_summ_rm.

      collect gw_sr9_prdvty into gt_sr9_prdvty.
      clear gw_sr9_prdvty.

      collect gw_sr9_summ into gt_sr9_summ.
      clear gw_sr9_summ.


    endloop.
  endif.

****** for div-wise total ZM/RM on target
  if gt_sr9_summ_rm[] is not initial and gt_sr9_summ_zm[] is not initial.
    loop at gt_sr9_summ_rm into gw_sr9_summ_rm.
      catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
        gw_sr9_summ_rm-per = ( gw_sr9_summ_rm-sale /  gw_sr9_summ_rm-target ) * 100.
      endcatch.

      if gw_sr9_summ_rm-per >= 100.
        gw_sr9_summ_rm-per_cnt = 1.
      endif.

      modify gt_sr9_summ_rm from gw_sr9_summ_rm transporting per per_cnt.
      clear gw_sr9_summ_rm.
    endloop.

    loop at gt_sr9_summ_zm into gw_sr9_summ_zm.
      catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
        gw_sr9_summ_zm-per = ( gw_sr9_summ_zm-sale /  gw_sr9_summ_zm-target ) * 100.
      endcatch.

      if gw_sr9_summ_zm-per >= 100.
        gw_sr9_summ_zm-per_cnt = 1.
      endif.

      modify gt_sr9_summ_zm from gw_sr9_summ_zm transporting per per_cnt.
      clear gw_sr9_summ_zm.
    endloop.
  endif.
endform.
