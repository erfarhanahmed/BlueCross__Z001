
*&--------------------------------------------------------------------------------------------------------------------------*
*& Report  ZSR9_PROGRAM
*& developed by Jyotsna
*tHIS PROGRAM WILL UPDATE DATABASE ZCUMPSO FLAF IN TABLE ZDUST_SALE
*&--------------------------------------------------------------------------------------------------------------------------*
*& 30.04.2025 / BCDK936753 - Change date in variable covdt1 and covdt2 to enable expiry CN at 100%
*& 29.05.2025 / BCDK936883 - Added new input date for expiry CN adj.100% to avoid hardcode in varaibale covdt1 and covdt2
*&                           the same was applied for covid period
*&---------------------------------------------------------------------------------------------------------------------------*

report  zsr9_program5 no standard page heading line-size 150.
**report developed by Jyotsna 17.11.2014*****
tables : vbrk,
         ysd_cus_div_dis,
         mara,
         ysd_inv_per,
         ydocdbt,
         yterrallc,
         pa0001,
         pa0302,
         ycusempadj,
         yempval.

types : begin of typ_vbrp,
          vbeln type vbrp-vbeln,
          posnr type vbrp-posnr,
          fkimg type vbrp-fkimg,
*  netwr TYPE vbrp-netwr,
          matnr type vbrp-matnr,
          arktx type vbrp-arktx,
          charg type vbrp-charg,
          pstyv type vbrp-pstyv,
          werks type vbrp-werks,
*  skfbp TYPE vbrp-skfbp,
          lgort type vbrp-lgort,
          kzwi2 type vbrp-kzwi2,
*  kzwi4 TYPE vbrp-kzwi4,
          mwsbp type vbrp-mwsbp,
*  ZPED TYPE P DECIMALS 2,
*  PTS TYPE P DECIMALS 2,
        end of typ_vbrp.

types : begin of typ_konv,
          knumv type prcd_elements-knumv,
          kposn type prcd_elements-kposn,
          kschl type prcd_elements-kschl,
          kwert type prcd_elements-kwert,
        end of typ_konv.

data : it_vbrk            type table of vbrk,
       wa_vbrk            type vbrk,
       it_vbrp            type table of vbrp,
       wa_vbrp            type vbrp,
       it_vbrp1           type table of vbrp,
       wa_vbrp1           type vbrp,
       it_vbrk1           type table of vbrk,
       wa_vbrk1           type vbrk,
       it_konv            type table of typ_konv,
       wa_konv            type typ_konv,
       it_konv1           type table of typ_konv,
       wa_konv1           type typ_konv,
       it_ysd_cus_div_dis type table of ysd_cus_div_dis,
       wa_ysd_cus_div_dis type ysd_cus_div_dis,
       it_ycusempadj      type table of ycusempadj,
       wa_ycusempadj      type ycusempadj,
       it_ycusempadj1     type table of ycusempadj,
       wa_ycusempadj1     type ycusempadj,
       it_empval          type table of yempval,
       wa_empval          type yempval,
       it_yterrallc       type table of yterrallc,
       wa_yterrallc       type yterrallc,
       it_pa0001          type table of pa0001,
       wa_pa0001          type pa0001,
       it_yterrallc1      type table of yterrallc,
       wa_yterrallc1      type yterrallc,
       it_pa0001_1        type table of pa0001,
       wa_pa0001_1        type pa0001,
       it_zlogupd         type table of zlogupd,
       wa_zlogupd         type zlogupd.

types : begin of itab1,
          vbeln      type vbrp-vbeln,
          matnr      type vbrp-matnr,
          charg      type vbrp-charg,
          fkimg_s    type vbrp-fkimg,
          fkimg_b    type vbrp-fkimg,
          arktx      type vbrp-arktx,
          lgort      type vbrp-lgort,
          kzwi2      type vbrp-kzwi2,
          bed_rate   type p decimals 2,
          xed_rate   type p decimals 2,
          led_rate   type p decimals 2,
          werks      type vbrp-werks,
          zped       type p decimals 2,
*  zped type p decimals 2,
          bpts       type p decimals 2,
          xpts       type p decimals 2,
          lpts       type p decimals 2,
          netwr      type vbrp-netwr,
          mwsbp      type vbrp-mwsbp,
          kzwi4      type vbrp-kzwi4,
          skfbp      type vbrp-skfbp,
          bzped_rate type p decimals 2,
          xzped_rate type p decimals 2,
          lzped_rate type p decimals 2,
          bzgrp_rate type p decimals 2,
          xzgrp_rate type p decimals 2,
          lzgrp_rate type p decimals 2,
          fkdat      type vbrk-fkdat,
          kunag      type vbrk-kunag,
          aubel      type vbrp-aubel,
          fkart      type vbrk-fkart,
          bzirk      type ysd_cus_div_dis-bzirk,
          val        type p decimals 2,
          bnetwr     type p decimals 2,
          xnetwr     type p decimals 2,
          lnetwr     type p decimals 2,
          spart      type mara-spart,
          cn_val     type p decimals 2,
          rval       type p decimals 2,
          nval       type p decimals 2,
          plans      type pa0001-plans,
          pernr      type pa0001-pernr,
          join_dt    type sy-datum,
          begda      type pa0001-begda,
          endda      type pa0001-endda,
        end of itab1.

types : begin of othydb1,
          bzirk   type ysd_cus_div_dis-bzirk,
          acn_val type p decimals 2,
        end of othydb1.

types : begin of zg2,
          bzirk   type ysd_cus_div_dis-bzirk,
          acn_val type p decimals 2,
          spart   type yterrallc-spart,
          vbeln   type vbrk-vbeln,
          days    type i,
        end of zg2.

types : begin of zcn,
          bzirk       type ysd_cus_div_dis-bzirk,
          sval        type p decimals 2,
          zg2val      type p decimals 2,
          othval      type p decimals 2,
          zg2netcnval type p decimals 2,
          rval        type p decimals 2,
          nval        type p decimals 2,
          pernr       type pa0001-pernr,
          join_dt     type sy-datum,
        end of zcn.

data : it_tab1    type table of itab1,
       wa_tab1    type itab1,
       it_tab2    type table of itab1,
       wa_tab2    type itab1,
       it_tab3    type table of itab1,
       wa_tab3    type itab1,
       it_tac1    type table of itab1,
       wa_tac1    type itab1,
       it_tag1    type table of itab1,
       wa_tag1    type itab1,
       it_tag2    type table of itab1,
       wa_tag2    type itab1,
       it_othydb1 type table of othydb1,
       wa_othydb1 type othydb1,
       it_othr1   type table of othydb1,
       wa_othr1   type othydb1,
       it_zg2ydb1 type table of othydb1,
       wa_zg2ydb1 type othydb1,
       it_zg2_1   type table of zg2,
       wa_zg2_1   type zg2,
       it_oth1    type table of othydb1,
       wa_oth1    type othydb1,
       it_zg21    type table of zg2,
       wa_zg21    type zg2,
       it_zg22    type table of othydb1,
       wa_zg22    type othydb1,
       it_zg2p1   type table of othydb1,
       wa_zg2p1   type othydb1,
       it_zg2all  type table of othydb1,
       wa_zg2all  type othydb1,
       it_zg2stp  type table of othydb1,
       wa_zg2stp  type othydb1,
       it_zg2     type table of othydb1,
       wa_zg2     type othydb1,
       it_zg2_2   type table of zg2,
       wa_zg2_2   type zg2,
       it_zg2_2n  type table of zg2,
       wa_zg2_2n  type zg2,
       it_zg2_3   type table of zg2,
       wa_zg2_3   type zg2,
       it_zg2_4   type table of zg2,
       wa_zg2_4   type zg2,
       it_zg2_5   type table of zg2,
       wa_zg2_5   type zg2,
       it_zg2_a   type table of zg2,
       wa_zg2_a   type zg2,
       it_cn1     type table of zg2,
       wa_cn1     type zg2,
       it_zcn1    type table of zcn,
       wa_zcn1    type zcn,
       it_rel1    type table of itab1,
       wa_rel1    type itab1,
       it_rela1   type table of itab1,
       wa_rela1   type itab1,
       it_rel2    type table of itab1,
       wa_rel2    type itab1,
       it_nemp1   type table of itab1,
       wa_nemp1   type itab1,
       it_pso1    type table of itab1,
       wa_pso1    type itab1,
       it_pso2    type table of itab1,
       wa_pso2    type itab1,
       it_ter1    type table of itab1,
       wa_ter1    type itab1,
       it_ter2    type table of itab1,
       wa_ter2    type itab1.

data : wa_dat(10) type c,
       gstdt      type sy-datum.

data : zspd type vbrp-netwr,
       zgrp type vbrp-netwr.

types : begin of zcn1,
          bzirk           type ysd_cus_div_dis-bzirk,
          sval(12)        type c,
          zg2val(12)      type c,
          othval(12)      type c,
          zg2netcnval(12) type c,
          rval(12)        type c,
          nval(12)        type c,
          pernr           type pa0001-pernr,
          join_dt         type sy-datum,
          m1(2)           type c,
          y1(2)           type c,
          net1(12)        type c,
          net_val(12)     type c,
          pso             type pa0001-pernr,
        end of zcn1.

types: begin of typ_down,
         field(6000) type c,
       end of typ_down.

types : begin of dtab1,
          m1(2)       type c,
          y1(4)       type c,
          bzirk       type ysd_cus_div_dis-bzirk,
*  val TYPE p DECIMALS 2,
*  CN_VAL TYPE P DECIMALS 2,
          rval(12)    type c,
          nval(12)    type c,
          sval(12)    type c,
          zg2val(12)  type c,
          othval(12)  type c,
          net1(12)    type c,
          net_val(12) type c,
          join_dt     type sy-datum,
        end of dtab1.

data : bval          type p decimals 2,
       xval          type p decimals 2,
       lval          type p decimals 2,
       bcn           type p decimals 2,
       xcn           type p decimals 2,
       lcn           type p decimals 2,
       cn_val        type p decimals 2,
       acn_val       type p decimals 2,
       stp           type p decimals 2,
       sper          type p decimals 2,
       net           type p decimals 2,
       net1          type p decimals 2,
       rval          type p decimals 2,
       nrval(12)     type c,
       nsval(12)     type c,
       nzg2val(12)   type c,
       nothval(12)   type c,
       nnet(12)      type c,
       nnval(12)     type c,
       nnet_val(12)  type c,
       nnet1(12)     type c,
       net_val       type p decimals 2,
       it_dtab1      type table of zcn1,
       wa_dtab1      type zcn1,
       wa_dtab1_down type dtab1,
       it_down       type table of typ_down,
       wa_down       type typ_down.
data: nval1 type p decimals 2,
      nval2 type p decimals 2.

data: stp11 type p decimals 2.

data: njoin_dt   type sy-datum,
      n1join_dt  type sy-datum,
      joindays   type i,
      newjoindt  type sy-datum,
      newjoindt1 type sy-datum.
data : stay      type i,
       stay1     type i,
       stay2     type i,
       stay3     type i,
       stay4(10) type c,
       days      type i,
       d1        type i value 180,
       y1(4)     type c,
       m1(2)     type c,
       y2(4)     type c,
       m2(2)     type c,
       date1     type sy-datum.

data : l_date type sy-datum.
data : a1(2)   type c,
       lday    type sy-datum,
       sday    type sy-datum,
       join_dt type sy-datum.


data : zcumpso_wa type zcumpso,
       zlogupd_wa type zlogupd.
*DATA : L_DATE TYPE SY-DATUM.

data : count type zlogupd-zcount.
data : term     like usr41-terminal,
       zyear(4) type c.

data : bpts type p decimals 2,
       xpts type p decimals 2,
       lpts type p decimals 2,
       val  type p decimals 2.

data : covdt1 type sy-datum,
       covdt2 type sy-datum.
**************************

data : it_zdist_sale type table of zdist_sale,
       wa_zdist_sale type zdist_sale,
       it_zdist_cn   type table of zdist_cn,
       wa_zdist_cn   type zdist_cn.

types : begin of dist1,
          kunag type zdist_sale-kunag,
          matnr type zdist_sale-matnr,
          spart type mara-spart,
          netwr type zdist_sale-netwr,
          fkimg type p,
        end of dist1.

types : begin of dist2,
          bzirk type ysd_cus_div_dis-bzirk,
          matnr type zdist_sale-matnr,
          spart type mara-spart,
          netwr type zdist_sale-netwr,
          fkimg type p,
        end of dist2.

data : it_dist1 type table of dist1,
       wa_dist1 type dist1,
       it_dist2 type table of dist2,
       wa_dist2 type dist2.
data: it_ysd_cus_div_dis1 type table of ysd_cus_div_dis,
      wa_ysd_cus_div_dis1 type ysd_cus_div_dis.

data : distval type p decimals 2,
       distqty type p.

data: zdist_sale_wa type zdist_sale,
      zdist_cn_wa   type zdist_cn.
***********************************************

selection-screen begin of block merkmale1 with frame title text-001.
select-options : s_budat for vbrk-fkdat obligatory,
                 s_covdt for vbrk-fkdat.
parameters : r1 radiobutton group r1,
             r2 radiobutton group r1.
parameters : test as checkbox.
selection-screen end of block merkmale1 .


if s_budat-low+6(2) ne '01'.
  message 'ENTER START DATE OF MONTH' type 'E'.
endif.

call function 'RP_LAST_DAY_OF_MONTHS'
  exporting
    day_in            = s_budat-low
  importing
    last_day_of_month = l_date.

if s_budat-high ne l_date.
  message 'ENTER END DATE OF THE MONTH' type 'E'.
endif.

start-of-selection.

*****  covdt1+6(2) = '01'.
*****  covdt1+4(2) = '04'.
*****  covdt1+0(4) = '2020'.
****** 30.04.2025 - commented above and added below to enable expiry CN at 100%
*****  covdt1+6(2) = '01'.
*****  covdt1+4(2) = '04'.
*****  covdt1+0(4) = '2025'.




*  COVDT2+6(2) = '30'.
*  COVDT2+4(2) = '04'.
*  COVDT2+0(4) = '2020'.
*****  covdt2+6(2) = '30'.  "27.5.2020
*****  covdt2+4(2) = '09'.
*****  covdt2+0(4) = '2020'.
****** 30.04.2025 - commented above and added below to enable expiry CN at 100%
*****  covdt2+6(2) = '30'.
*****  covdt2+4(2) = '04'.
*****  covdt2+0(4) = '2025'.
********29.05.2025 / BCDK936883 - Added new input date for expiry CN adj.100% to avoid hardcode in varaibale covdt1 and covdt2
  if s_covdt[] is not initial.
    if s_covdt-low+6(2) ne '01'.
      message 'ENTER START DATE OF MONTH' type 'E'.
    endif.

    call function 'RP_LAST_DAY_OF_MONTHS'
      exporting
        day_in            = s_covdt-low
      importing
        last_day_of_month = l_date.

    if s_covdt-high ne l_date.
      message 'ENTER END DATE OF THE MONTH' type 'E'.
    endif.

    covdt1 = s_covdt-low.
    covdt2 = s_covdt-high.
  endif.

*  covdt2+6(2) = '31'.  "29.10.2020
*  covdt2+4(2) = '05'.
*  covdt2+0(4) = '2020'.

  call function 'TERMINAL_ID_GET'
    importing
      terminal = term.

*WRITE : / 'FROM DATE',S_BUDAT-LOW ,'TO', S_BUDAT-HIGH.
  perform sale.
  perform cn.
*PERFORM CN_VAL.

  perform reallocation.
  perform nep_sale.
  perform cn_summ.


*&---------------------------------------------------------------------*
*&      Form  SALE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form sale.
  select * from vbrk into table it_vbrk where fkdat in s_budat and fkart in ('ZBDF','ZCDF') and fksto ne 'X'.
  if sy-subrc eq 0.
*  select vbeln posnr fkimg matnr arktx charg pstyv werks lgort kzwi2 from vbrp into table it_vbrp for all entries in it_vbrk
*    where  vbeln = it_vbrk-vbeln and fkimg ne 0 AND pstyv eq 'ZAN'.
    select * from vbrp into table it_vbrp for all entries in it_vbrk where  vbeln = it_vbrk-vbeln and fkimg ne 0
      and pstyv eq 'ZAN'.
    if sy-subrc ne 0.
      exit.
    endif.
  endif.

  select knumv kposn kschl kwert  from prcd_elements into table it_konv for all entries in it_vbrk where knumv = it_vbrk-knumv
    and kschl in ('ZPED', 'ZEX4','ZGRP').
  if sy-subrc eq 0.
  endif.
  sort it_konv by knumv kposn kschl.
  sort it_vbrp by vbeln.
  delete it_vbrp where fkimg eq 0.

  loop at it_vbrp into wa_vbrp from sy-tabix.
    if wa_vbrp-pstyv = 'ZAN'.

      wa_tab1-vbeln = wa_vbrp-vbeln.
      wa_tab1-fkimg_s = wa_vbrp-fkimg.
      wa_tab1-matnr = wa_vbrp-matnr.
      wa_tab1-arktx = wa_vbrp-arktx.
      wa_tab1-charg = wa_vbrp-charg.
      wa_tab1-werks = wa_vbrp-werks.
      wa_tab1-lgort = wa_vbrp-lgort.

      read table it_vbrk into wa_vbrk with key vbeln = wa_vbrp-vbeln.
      if sy-subrc eq 0.
        wa_tab1-fkdat = wa_vbrk-fkdat.
        wa_tab1-kunag = wa_vbrk-kunag.
        select single * from mara where matnr eq wa_vbrp-matnr.
        if mara-spart eq '50'.
          read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZEX4' binary search.
          if sy-subrc eq 0.
            wa_tab1-bed_rate = wa_konv-kwert.
          endif.
          read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZPED' binary search.
          if sy-subrc eq 0.
            wa_tab1-bzped_rate = wa_konv-kwert.
          endif.
          read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZGRP' binary search.
          if sy-subrc eq 0.
            wa_tab1-bzgrp_rate = wa_konv-kwert.
          endif.
        elseif mara-spart eq '60'.
          read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZEX4' binary search.
          if sy-subrc eq 0.
            wa_tab1-xed_rate = wa_konv-kwert.
          endif.
          read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZPED' binary search.
          if sy-subrc eq 0.
            wa_tab1-xzped_rate = wa_konv-kwert.
          endif.
          read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZGRP' binary search.
          if sy-subrc eq 0.
            wa_tab1-xzgrp_rate = wa_konv-kwert.
          endif.
        elseif mara-spart eq '70'.
          read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZEX4' binary search.
          if sy-subrc eq 0.
            wa_tab1-led_rate = wa_konv-kwert.
          endif.
          read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZPED' binary search.
          if sy-subrc eq 0.
            wa_tab1-lzped_rate = wa_konv-kwert.
          endif.
          read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZGRP' binary search.
          if sy-subrc eq 0.
            wa_tab1-lzgrp_rate = wa_konv-kwert.
          endif.
        endif.
      endif.
*      wa_tab1-werks = wa_vbrp-werks.
      collect wa_tab1 into it_tab1.
      clear wa_tab1.

    endif.
  endloop.


  clear : bpts, xpts,lpts,val.
  clear : it_vbrp,wa_vbrp,it_vbrk,wa_vbrk,it_konv,wa_konv.
  loop at it_tab1 into wa_tab1.
    clear : bpts,xpts,val.
    val = wa_tab1-bzgrp_rate + wa_tab1-xzgrp_rate + wa_tab1-lzgrp_rate.
    if val gt 0.
      bpts = wa_tab1-bzgrp_rate.
      xpts = wa_tab1-xzgrp_rate.
      lpts = wa_tab1-lzgrp_rate.
    else.
      bpts = wa_tab1-bzped_rate + wa_tab1-bed_rate.
      xpts = wa_tab1-xzped_rate + wa_tab1-xed_rate.
      lpts = wa_tab1-lzped_rate + wa_tab1-led_rate.
    endif.

*  WRITE : PTS.
*  WA_TAB2-VBELN = WA_TAB1-VBELN.
    wa_tab2-kunag = wa_tab1-kunag.
    wa_tab2-bpts = bpts.
    wa_tab2-xpts = xpts.
    wa_tab2-lpts = lpts.
    collect wa_tab2 into it_tab2.
    clear wa_tab2.
  endloop.
  sort it_tab2 by kunag.
  if it_tab2 is not initial.
    select * from ysd_cus_div_dis into table it_ysd_cus_div_dis for all entries in it_tab2 where kunnr eq it_tab2-kunag
      and begda le s_budat-low and endda ge s_budat-high.
  endif.

  loop at it_tab2 into wa_tab2.
    clear : bval,xval,lval.
*    WRITE : / 'CUSTOMER GROSS SALE- PTS',WA_TAB2-KUNAG,WA_TAB2-bPTS,wa_tab2-xpts.

    loop at it_ysd_cus_div_dis into wa_ysd_cus_div_dis where kunnr eq wa_tab2-kunag and begda le s_budat-low and endda ge s_budat-high.
      clear : bval,xval,lval.
*      WRITE : / WA_YSD_CUS_DIV_DIS-BZIRK,WA_YSD_CUS_DIV_DIS-spart,WA_YSD_CUS_DIV_DIS-PERCNT.
*      wa_tab3-kunag = WA_TAB2-KUNAG.
      wa_tab3-bzirk = wa_ysd_cus_div_dis-bzirk.
      if wa_ysd_cus_div_dis-spart eq '50'.
        bval = ( wa_tab2-bpts * wa_ysd_cus_div_dis-percnt ) / 100.
*        WRITE : BVAL.

      elseif wa_ysd_cus_div_dis-spart eq '60'.
        xval = ( wa_tab2-xpts * wa_ysd_cus_div_dis-percnt ) / 100.
*        WRITE : XVAL.
      elseif wa_ysd_cus_div_dis-spart eq '70'.
        lval = ( wa_tab2-lpts * wa_ysd_cus_div_dis-percnt ) / 100.
      endif.
      wa_tab3-val = bval + xval + lval.
      collect wa_tab3 into it_tab3.
      clear wa_tab3.
    endloop.
  endloop.
  sort it_tab3 by bzirk.
  loop at it_tab3 into wa_tab3.
*    WRITE : / 'GROSS SALE', wa_tab3-bzirk,wa_tab3-val.
    wa_zcn1-bzirk =  wa_tab3-bzirk.
    wa_zcn1-sval = wa_tab3-val.
    collect wa_zcn1 into it_zcn1.
    clear wa_zcn1.
*    ,wa_tab3-kunag.
  endloop.

  clear :it_vbrk,wa_vbrk,it_vbrp,wa_vbrp,it_ysd_cus_div_dis,wa_ysd_cus_div_dis.
endform.                    "SALE

*&---------------------------------------------------------------------*
*&      Form  CN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form cn.
**************TOTAL CREDIT NOTE  *************
  gstdt+0(4) = '2019'.
  gstdt+6(2) = '01'.
  gstdt+4(2) = '04'.
  select * from vbrk into table it_vbrk1 where fkdat in s_budat and fksto ne 'X' and fkart in ('ZG2','ZBD','ZRS','ZG3','RE','ZC04','ZQC','ZRRE','ZRRS','ZC08' ).
  if sy-subrc eq 0.
    select * from vbrp into table it_vbrp1 for all entries in it_vbrk1 where  vbeln = it_vbrk1-vbeln .
  endif.
  if it_vbrk1 is not initial.
    select knumv kposn kschl kwert from prcd_elements into table it_konv1 for all entries in it_vbrk1 where knumv = it_vbrk1-knumv
      and kschl in ('ZPED','ZSPD','ZGRP').
*      'JIN6','ZTOT','JIN1','ZC02','JIN5','ZCST','ZDIT','ZSPD','SKTV','Z004').
  endif.
  sort it_konv1 by knumv kposn kschl.

  loop at it_vbrp1 into wa_vbrp1.
    clear : zspd, zgrp.
    read table it_vbrk1 into wa_vbrk1 with key vbeln = wa_vbrp1-vbeln.
    if sy-subrc eq 0.
      wa_tag1-vbeln = wa_vbrk1-vbeln.
      wa_tag1-fkart = wa_vbrk1-fkart.
      wa_tag1-kunag = wa_vbrk1-kunag.
      select single * from mara where matnr eq wa_vbrp1-matnr.
      if sy-subrc eq 0.
        wa_tag1-spart = mara-spart.
**********************  ZG2 & ZBD ******************************************
        if s_budat-low lt gstdt.
          if mara-spart eq '50'.
            wa_tag1-bnetwr = wa_vbrp1-netwr.
          elseif mara-spart eq '60'.
            wa_tag1-xnetwr = wa_vbrp1-netwr.
          elseif mara-spart eq '70'.
            wa_tag1-lnetwr = wa_vbrp1-netwr.
          endif.
        else.
          if wa_vbrk1-fkart eq 'ZG2' or wa_vbrk1-fkart eq 'ZBD'.
            read table it_konv1 into wa_konv1 with key knumv = wa_vbrk1-knumv kposn = wa_vbrp1-posnr kschl = 'ZSPD' binary search.
            if sy-subrc eq 0.
              zspd = wa_konv1-kwert.
            endif.
            read table it_konv1 into wa_konv1 with key knumv = wa_vbrk1-knumv kposn = wa_vbrp1-posnr kschl = 'ZGRP' binary search.
            if sy-subrc eq 0.
              zgrp = wa_konv1-kwert.
            endif.
            if mara-spart eq '50'.
              wa_tag1-bnetwr = zgrp - zspd.
            elseif mara-spart eq '60'.
              wa_tag1-xnetwr = zgrp - zspd.
            elseif mara-spart eq '70'.
              wa_tag1-lnetwr = zgrp - zspd.
            endif.
          else.
            if mara-spart eq '50'.
              wa_tag1-bnetwr = wa_vbrp1-netwr.
            elseif mara-spart eq '60'.
              wa_tag1-xnetwr = wa_vbrp1-netwr.
            elseif mara-spart eq '70'.
              wa_tag1-lnetwr = wa_vbrp1-netwr.
            endif.
            if wa_vbrk1-fkart eq 'ZC08'.
              wa_tag1-bnetwr = 0.
              wa_tag1-xnetwr = 0.
            endif.
          endif.
        endif.
***************************************************
      endif.

      collect wa_tag1 into it_tag1.
      clear wa_tag1.
    endif.
  endloop.

  sort it_tag1 by kunag.
  loop at it_tag1 into wa_tag1 .
*    WRITE : / WA_TAG1-KUNAG,WA_TAG1-FKART,WA_TAG1-VBELN,WA_TAG1-SPART,WA_TAG1-BNETWR,WA_TAG1-XNETWR.
    select * from ysd_cus_div_dis where kunnr eq wa_tag1-kunag and spart eq wa_tag1-spart and begda le s_budat-low and endda ge s_budat-high.
      if sy-subrc eq 0.
        clear : bcn, xcn,lcn,cn_val.
*        WRITE : / YSD_CUS_DIV_DIS-BZIRK,YSD_CUS_DIV_DIS-PERCNT.
        bcn = wa_tag1-bnetwr * (  ysd_cus_div_dis-percnt / 100 ).
        xcn = wa_tag1-xnetwr * (  ysd_cus_div_dis-percnt / 100 ).
        lcn = wa_tag1-lnetwr * (  ysd_cus_div_dis-percnt / 100 ).
        cn_val = bcn + xcn + lcn.
*        WRITE : BCN,XCN,CN_VAL.
        wa_tag2-kunag = wa_tag1-kunag.
        wa_tag2-vbeln = wa_tag1-vbeln.
        wa_tag2-fkart = wa_tag1-fkart.
        wa_tag2-bzirk = ysd_cus_div_dis-bzirk.
        wa_tag2-spart = ysd_cus_div_dis-spart.
        wa_tag2-cn_val = cn_val.
        collect wa_tag2 into it_tag2 .
        clear wa_tag2.
      endif.
    endselect.
  endloop.

  sort it_tag2 by bzirk.
*****************OTHER CN LOGIC******************
  loop at it_tag2 into wa_tag2 where fkart ne 'ZG2'.
    clear : acn_val.
    select single * from ydocdbt where vbeln = wa_tag2-vbeln.
    if sy-subrc eq 0.
      if ydocdbt-zero eq 'X'.
        acn_val = 0.
      else.
        acn_val = wa_tag2-cn_val.
      endif.
      wa_othydb1-bzirk = wa_tag2-bzirk.
      wa_othydb1-acn_val = acn_val.
      collect wa_othydb1 into it_othydb1.
      clear wa_othydb1.
    else.
      select single * from ysd_inv_per where fkart eq wa_tag2-fkart and begda le s_budat-low and endda ge s_budat-high.
      if sy-subrc eq 0.
*        WRITE : YSD_INV_PER-PERCNT.
        acn_val = wa_tag2-cn_val * ( ysd_inv_per-percnt / 100 ).
*        WRITE : 'OTHR CN VAL',ACN_VAL.
        wa_othr1-bzirk = wa_tag2-bzirk.
        wa_othr1-acn_val = acn_val.
        collect wa_othr1 into it_othr1.
        clear wa_othr1.
      endif.
    endif.
  endloop.

  loop at it_othydb1 into wa_othydb1.
*    WRITE : / 'OTH YDB', WA_OTHYDB1-BZIRK,WA_OTHYDB1-ACN_VAL.
    wa_oth1-bzirk = wa_othydb1-bzirk.
    wa_oth1-acn_val = wa_othydb1-acn_val.
    collect wa_oth1 into it_oth1.
    clear wa_oth1.
  endloop.

  loop at it_othr1 into wa_othr1.
*    WRITE : / 'OTH ALL',WA_OTHR1-BZIRK,WA_OTHR1-ACN_VAL.
    wa_oth1-bzirk = wa_othr1-bzirk.
    wa_oth1-acn_val = wa_othr1-acn_val.
    collect wa_oth1 into it_oth1.
    clear wa_oth1.
  endloop.

  loop at it_oth1 into wa_oth1.
*    WRITE : / 'OTH CN',WA_OTH1-BZIRK,WA_OTH1-ACN_VAL.   "OTHER CREDIT NOTE VALUE INCLUDING YDOCDBT
    wa_zcn1-bzirk =  wa_oth1-bzirk.
    wa_zcn1-othval = wa_oth1-acn_val.
    collect wa_zcn1 into it_zcn1.
    clear wa_zcn1.
  endloop.

******************ZG2 CN LOGIC************
  loop at it_tag2 into wa_tag2 where fkart eq 'ZG2'.
    clear : acn_val.
*    WRITE : / 'CN',WA_TAG2-FKART,WA_TAG2-KUNAG,WA_TAG2-BZIRK,WA_TAG2-VBELN,WA_TAG2-CN_VAL.
    select single * from ydocdbt where vbeln = wa_tag2-vbeln.
    if sy-subrc eq 0.
*      WRITE : 'ydocdbt',ydocdbt-zero.
      if ydocdbt-zero eq 'X'.
        acn_val = 0.
*        WRITE acn_val.
      else.
        acn_val = wa_tag2-cn_val.
*        WRITE acn_val.
      endif.
      wa_zg2ydb1-bzirk = wa_tag2-bzirk.
      wa_zg2ydb1-acn_val = acn_val.
      collect wa_zg2ydb1 into it_zg2ydb1.
      clear wa_zg2ydb1.
    else.
      wa_zg2_1-bzirk = wa_tag2-bzirk.
      wa_zg2_1-acn_val = wa_tag2-cn_val.
      wa_zg2_1-spart = wa_tag2-spart.
      wa_zg2_1-vbeln = wa_tag2-vbeln.
      collect wa_zg2_1 into it_zg2_1.
      clear wa_zg2_1.
    endif.
  endloop.



  loop at it_zg2ydb1 into wa_zg2ydb1.
*    WRITE : / 'ZG2 YDB',WA_ZG2YDB1-BZIRK,WA_ZG2YDB1-ACN_VAL.  "ZG2 YDOCDBT VALUES
    wa_zg21-bzirk = wa_zg2ydb1-bzirk.
    wa_zg21-acn_val = wa_zg2ydb1-acn_val.
    collect wa_zg21 into it_zg21.
    clear wa_zg21.
  endloop.

  loop at it_zg21 into wa_zg21.
*    WRITE : / 'zg2 ydbcnt cn',wa_zg21-bzirk,wa_zg21-acn_val.
    wa_zg2all-bzirk = wa_zg21-bzirk.
    wa_zg2all-acn_val = wa_zg21-acn_val.
    collect wa_zg2all into it_zg2all.
    clear wa_zg2all.

    wa_zg2_a-bzirk = wa_zg21-bzirk.
    wa_zg2_a-acn_val = wa_zg21-acn_val.
    collect wa_zg2_a into it_zg2_a.
    clear wa_zg2_a.

  endloop.
  sort it_zg2_1 by vbeln.
  loop at it_zg2_1 into wa_zg2_1.
    wa_zg2all-bzirk = wa_zg2_1-bzirk.
    wa_zg2all-acn_val = wa_zg2_1-acn_val.
    collect wa_zg2all into it_zg2all.
    clear wa_zg2all.
  endloop.


  sort it_zg2all by bzirk.


  loop at it_zg2all into wa_zg2all .

*    WHERE bzirk = 'FAR-1'..
    clear : stp,sper,acn_val.
*    WRITE : / 'ZG2 ALL',WA_ZG2ALL-BZIRK,WA_ZG2ALL-ACN_VAL.
    wa_zcn1-bzirk =  wa_zg2all-bzirk.
    wa_zcn1-zg2val = wa_zg2all-acn_val.
    collect wa_zcn1 into it_zcn1.
    clear wa_zcn1.

*************new joinee*****************
    clear : njoin_dt,joindays.  "join date from start of the month**********
    clear : newjoindt,newjoindt1.
    select single * from yterrallc where bzirk eq wa_zg2all-bzirk and endda ge s_budat-low. "sy-datum.

    if sy-subrc eq 0.
      select single * from pa0001 where plans eq yterrallc-plans and begda le s_budat-high and endda ge s_budat-high.    "sy-datum.
      if sy-subrc eq 0.
        select single * from pa0302 where pernr eq pa0001-pernr and massn eq '01'.
        if sy-subrc eq 0.

          clear : njoin_dt.
          njoin_dt = pa0302-begda.
*          NJOIN_DT+6(2) = '01'.
*************new logic on 4.10.21
          clear : newjoindt.  "ADDED ON 7.6.22. PARAM TOLD TO CONCIDER UPTO 9 MONTHS AS NEW JOINEE---JYOTSNA
          newjoindt = njoin_dt.
          if njoin_dt+6(2) le '15'.
*            njoin_dt+6(2) = '01'.
            njoin_dt+6(2) = '02'.
            newjoindt+6(2) = '01'.
          else.  "added on 4.10.21
            call function 'RE_ADD_MONTH_TO_DATE'
              exporting
                months  = '1'
                olddate = newjoindt
              importing
                newdate = newjoindt.
            newjoindt+6(2) = '01'.

            clear : n1join_dt.
            call function 'RE_ADD_MONTH_TO_DATE'
              exporting
                months  = '1'
                olddate = njoin_dt
              importing
                newdate = n1join_dt.
*            n1join_dt+6(2) = '01'.
            n1join_dt+6(2) = '02'.
            njoin_dt = n1join_dt.
          endif.

          call function 'RE_ADD_MONTH_TO_DATE'
            exporting
              months  = '9'
              olddate = newjoindt
            importing
              newdate = newjoindt1.
          if newjoindt1 gt s_budat-low.
            write : / 'NEW JOINEE' ,pa0001-pernr,pa0302-begda.
          else.
            write : / 'OLD JOINEE' ,pa0001-pernr,pa0302-begda.
          endif.

*          joindays = sy-datum - njoin_dt.
          joindays = abs( njoin_dt - s_budat-low ).
          if wa_zg2all-bzirk = 'KOR-2'.
            write : /1 wa_zg2all-bzirk , joindays, 'ZG2ALL'.
          endif.
        endif.
      endif.
    endif.
****************************************************

    read table it_tab3 into wa_tab3 with key bzirk = wa_zg2all-bzirk.

    if sy-subrc eq 0 and wa_tab3-val gt 0.
*      WRITE : WA_TAB3-VAL.
      sper = wa_tab3-val * ( 1 / 100 ).
      stp = ( wa_zg2all-acn_val / wa_tab3-val ) * 100.
*      WRITE : STP.
*      IF S_BUDAT-LOW EQ COVDT1 AND S_BUDAT-HIGH EQ COVDT2.
      stp11 = 15 / 10.  "EXPIRY PERCENTAGE

      if s_budat-low ge covdt1 and s_budat-high le covdt2.
*******new join pos-- 100%  02.06.2021



*          call function 'HR_JP_MONTH_BEGIN_END_DATE'
*            exporting
*              iv_date           = njoin_dt
*            importing
**             EV_MONTH_BEGIN_DATE       =
*              ev_month_end_date = lday.
**          WRITE : LDAY.
*          sday = lday + 1.
**          WRITE : SDAY.
*          pa0302-begda = sday.
*        else.
*          pa0302-begda+6(2) = '01'.
*        endif.
***************************************
*      ELSEIF JOINDAYS GT 0 AND JOINDAYS LT 280.  "new joinee"2.6.21
      elseif newjoindt1 gt s_budat-low.  "NEW LOGIC FROM 7.6.22

        acn_val = wa_zg2all-acn_val.
        wa_zg2stp-bzirk = wa_zg2all-bzirk.
        wa_zg2stp-acn_val = acn_val.
        if wa_zg2all-bzirk = 'KOR-2' or wa_zg2all-bzirk = 'MAN-16'.
          write /1 'DATA COLLECTED IN IT_ZG2STP'.
        endif.
        collect wa_zg2stp into it_zg2stp.    "check here
        clear wa_zg2stp.

      elseif s_budat-low ge '20210401'.

        if stp le 1.  "28.4.2020
          acn_val = wa_zg2all-acn_val.
          wa_zg2stp-bzirk = wa_zg2all-bzirk.
          wa_zg2stp-acn_val = acn_val.
          collect wa_zg2stp into it_zg2stp.    "check here
          clear wa_zg2stp.
        elseif stp gt 1 and stp le stp11.  "23.4.21
*          DELETE IT_ZCN1 WHERE BZIRK EQ wa_zg2all-BZIRK.
          read table it_zg2ydb1 into wa_zg2ydb1 with key bzirk = wa_zg2all-bzirk.
          if sy-subrc eq 0.
            clear : nval1,nval2.
            nval1 = wa_zg2all-acn_val - wa_zg2ydb1-acn_val.
            nval2 = wa_zg2all-acn_val - nval1.
            acn_val = nval2 + ( nval1 +  ( nval1 * ( 50 / 100 ) ) ).
          else.
            acn_val = wa_zg2all-acn_val + ( wa_zg2all-acn_val * ( 50 / 100 ) ).
          endif.
          wa_zg2stp-bzirk = wa_zg2all-bzirk.
          wa_zg2stp-acn_val = acn_val.
          collect wa_zg2stp into it_zg2stp.    "check here
          clear wa_zg2stp.


          wa_zcn1-bzirk =  wa_zg2all-bzirk.  "29.10.20
          wa_zcn1-zg2val = acn_val.
          modify it_zcn1 from wa_zcn1 transporting zg2val  where bzirk eq wa_tab3-bzirk.
          clear wa_zcn1.

        elseif stp gt stp11 .
*          AND STP LE 2.  "28.10.20  delimit on 1.10.21
*          DELETE IT_ZCN1 WHERE BZIRK EQ wa_zg2all-BZIRK.
          read table it_zg2ydb1 into wa_zg2ydb1 with key bzirk = wa_zg2all-bzirk.
          if sy-subrc eq 0.
            clear : nval1,nval2.
            nval1 = wa_zg2all-acn_val - wa_zg2ydb1-acn_val.
            nval2 = wa_zg2all-acn_val - nval1.
            acn_val = nval2 + ( nval1 * 3 ).
          else.
            acn_val = wa_zg2all-acn_val * 3.
          endif.

          wa_zg2stp-bzirk = wa_zg2all-bzirk.
          wa_zg2stp-acn_val = acn_val.
          collect wa_zg2stp into it_zg2stp.    "check here
          clear wa_zg2stp.


          wa_zcn1-bzirk =  wa_zg2all-bzirk.  "29.10.20
          wa_zcn1-zg2val = acn_val.
          modify it_zcn1 from wa_zcn1 transporting zg2val  where bzirk eq wa_tab3-bzirk.
          clear wa_zcn1.
        endif.

      else.
        if stp le 1.  "28.4.2020
          acn_val = wa_zg2all-acn_val.
          wa_zg2stp-bzirk = wa_zg2all-bzirk.
          wa_zg2stp-acn_val = acn_val.
          collect wa_zg2stp into it_zg2stp.    "check here
          clear wa_zg2stp.
        elseif stp gt 1 .
*          AND STP LE 2.  "28.10.20
*          DELETE IT_ZCN1 WHERE BZIRK EQ wa_zg2all-BZIRK.
          read table it_zg2ydb1 into wa_zg2ydb1 with key bzirk = wa_zg2all-bzirk.
          if sy-subrc eq 0.
            clear : nval1,nval2.
            nval1 = wa_zg2all-acn_val - wa_zg2ydb1-acn_val.
            nval2 = wa_zg2all-acn_val - nval1.
            acn_val = nval2 + ( nval1 +  ( nval1 * ( 50 / 100 ) ) ).
          else.
            acn_val = wa_zg2all-acn_val + ( wa_zg2all-acn_val * ( 50 / 100 ) ).
          endif.
*            ACN_VAL = WA_ZG2ALL-ACN_VAL + ( WA_ZG2ALL-ACN_VAL * ( 50 / 100 ) ).

          wa_zg2stp-bzirk = wa_zg2all-bzirk.
          wa_zg2stp-acn_val = acn_val.
          collect wa_zg2stp into it_zg2stp.    "check here
          clear wa_zg2stp.


          wa_zcn1-bzirk =  wa_zg2all-bzirk.  "29.10.20
          wa_zcn1-zg2val = acn_val.
          modify it_zcn1 from wa_zcn1 transporting zg2val  where bzirk eq wa_tab3-bzirk.
          clear wa_zcn1.
        endif.

      endif.
*      ELSE.
*
*         wa_zcn1-bzirk =  wa_zg2all-bzirk.
*    wa_zcn1-zg2val = wa_zg2all-acn_val.
*    COLLECT wa_zcn1 INTO it_zcn1.
*    CLEAR wa_zcn1.
    endif.
  endloop.


  sort it_zg2_1 by bzirk.
  loop at it_zg2_1 into wa_zg2_1.
    read table it_zg2stp into wa_zg2stp with key bzirk = wa_zg2_1-bzirk.
    if sy-subrc eq 4.
*      WRITE : / 'ZG2 PSO LOGIC',WA_ZG2_1-BZIRK,WA_ZG2_1-SPART,WA_ZG2_1-ACN_VAL.
      wa_zg2_2-bzirk = wa_zg2_1-bzirk.
      wa_zg2_2-spart = wa_zg2_1-spart.
      wa_zg2_2-acn_val = wa_zg2_1-acn_val.
      collect wa_zg2_2 into it_zg2_2.
      clear wa_zg2_2.
    endif.
  endloop.

  sort it_zg2_2 by bzirk.
  loop at it_zg2_2 into wa_zg2_2.
    wa_zg2_2n-bzirk = wa_zg2_2-bzirk.
    wa_zg2_2n-acn_val = wa_zg2_2-acn_val.
    collect wa_zg2_2n into it_zg2_2n.
    clear wa_zg2_2n.
  endloop.


********************zg2 PSO logic*****************
  m2 = s_budat-low+6(2).
  y2 = s_budat-low+0(4).
  date1 = s_budat-low.
  date1+6(2) = '15'.

*  WRITE : / 'month, year',m2, y2, date1.
  select * from yterrallc into table it_yterrallc for all entries in it_zg2_2 where spart eq it_zg2_2-spart and bzirk eq it_zg2_2-bzirk and
     begda le s_budat-low and endda gt s_budat-high  and plans ne '99999999'..
  if sy-subrc eq 0.
    select * from pa0001 into table it_pa0001 for all entries in it_yterrallc where plans eq it_yterrallc-plans and begda le date1 and
      endda ge s_budat-high.
*      endda gt s_budat-high .
  endif.
  sort it_pa0001.
  loop at it_pa0001 into wa_pa0001.
    if wa_pa0001-plans = 50009110.
      write : /1 wa_pa0001-plans, wa_pa0001-pernr.
    endif.
    read table it_yterrallc into wa_yterrallc with key plans = wa_pa0001-plans.
    if sy-subrc eq 0.
      if wa_yterrallc-bzirk = 'MAN-16'.
        write : /1 wa_yterrallc-bzirk , wa_pa0001-begda.
      endif.
*      WRITE : / 'qty',wa_yterrallc-bzirk,wa_pa0001-plans,wa_pa0001-pernr,wa_pa0001-begda,wa_pa0001-endda.
      wa_ter1-bzirk = wa_yterrallc-bzirk.
*      wa_ter1-spart = wa_yterrallc-spart.
      wa_ter1-plans = wa_pa0001-plans.
      wa_ter1-pernr = wa_pa0001-pernr.
      wa_ter1-begda = wa_pa0001-begda.
      wa_ter1-endda = wa_pa0001-endda.
      collect wa_ter1 into it_ter1.
      clear wa_ter1.
    endif.
  endloop.

  sort it_ter1 by bzirk endda.
*  LOOP at it_ter1 INTO wa_ter1.
*    WRITE : / 'qty',wa_ter1-bzirk,wa_ter1-plans,wa_ter1-pernr,wa_ter1-begda,wa_ter1-endda.
*  ENDLOOP.

  sort it_zg2_2n by bzirk spart.
  loop at it_zg2_2n into wa_zg2_2n .
    clear : acn_val,stay,stay1,stay2,stay3,days,a1,lday,sday,join_dt.
    wa_zg2-bzirk = wa_zg2_2n-bzirk.
    wa_zg2-acn_val = wa_zg2_2n-acn_val.
    collect wa_zg2 into it_zg2.
    clear wa_zg2.
    read table it_ter1 into wa_ter1 with key bzirk = wa_zg2_2n-bzirk .
*    spart = wa_zg2_2-spart.
    if sy-subrc eq 0.
*      WRITE : / 'ZG2 PSO ',WA_ZG2_2-BZIRK,WA_ZG2_2-ACN_VAL,wa_ter1-plans,wa_ter1-pernr,wa_ter1-begda,wa_ter1-endda.
      select single * from pa0302 where pernr eq wa_ter1-pernr and massn eq '01'.
      if sy-subrc eq 0.
        join_dt = pa0302-begda.
        a1 = pa0302-begda+6(2).
        if a1 gt 15.
          call function 'HR_JP_MONTH_BEGIN_END_DATE'
            exporting
              iv_date           = pa0302-begda
            importing
*             EV_MONTH_BEGIN_DATE       =
              ev_month_end_date = lday.
*          WRITE : LDAY.
          sday = lday + 1.
*          WRITE : SDAY.
          pa0302-begda = sday.
        else.
          pa0302-begda+6(2) = '01'.
        endif.

        wa_pso1-bzirk = wa_zg2_2n-bzirk.
        wa_pso1-plans = wa_ter1-plans.
        wa_pso1-pernr = wa_ter1-pernr.
        wa_pso1-join_dt = join_dt.
        collect wa_pso1 into it_pso1.
        clear wa_pso1.

        call function 'HR_SGPBS_YRS_MTHS_DAYS'
          exporting
            beg_da        = pa0302-begda
            end_da        = s_budat-low
          importing
            no_day        = stay
            no_month      = stay1
            no_year       = stay2
            no_cal_day    = stay3
          exceptions
            dateint_error = 1
            others        = 2.
        if sy-subrc <> 0.
        endif.
        days = stay3.
        if wa_zg2_2n-bzirk = 'KOR-2'.
          write : /1 wa_zg2_2n-bzirk, days.
        endif.
        if s_budat-low eq covdt1 and s_budat-high eq covdt2.
          select single * from ysd_inv_per where fkart eq 'ZG2' and begda le s_budat-low and endda ge s_budat-high.
          if sy-subrc eq 0.
            acn_val = wa_zg2_2n-acn_val * ( ysd_inv_per-percnt / 100 ).
*              WRITE :'ZG2 CN GT 180', ACN_VAL.
            wa_zg2_4-bzirk = wa_zg2_2n-bzirk.
            wa_zg2_4-acn_val = acn_val.
*            wa_zg2_4-days = days.
            collect wa_zg2_4 into it_zg2_4.
            clear wa_zg2_4.
          endif.
        else.
**************************
          if s_budat-low ge '20210401'.
            if days le 270.    "28.4.2020
              acn_val = wa_zg2_2n-acn_val.
*            WRITE : 'ZG2 CN LE 180D ', ACN_VAL.
              wa_zg2_3-bzirk = wa_zg2_2n-bzirk.
              wa_zg2_3-acn_val = acn_val.
*          wa_zg2_3-days = days.
              collect wa_zg2_3 into it_zg2_3.
              clear wa_zg2_3.
            else.
              select single * from ysd_inv_per where fkart eq 'ZG2' and begda le s_budat-low and endda ge s_budat-high.
              if sy-subrc eq 0.
                acn_val = wa_zg2_2n-acn_val * ( ysd_inv_per-percnt / 100 ).
*              WRITE :'ZG2 CN GT 180', ACN_VAL.
                wa_zg2_4-bzirk = wa_zg2_2n-bzirk.
                wa_zg2_4-acn_val = acn_val.
*            wa_zg2_4-days = days.
                collect wa_zg2_4 into it_zg2_4.
                clear wa_zg2_4.
              endif.
            endif.
          else.
            if days le 180.    "28.4.2020
              acn_val = wa_zg2_2n-acn_val.
*            WRITE : 'ZG2 CN LE 180D ', ACN_VAL.
              wa_zg2_3-bzirk = wa_zg2_2n-bzirk.
              wa_zg2_3-acn_val = acn_val.
*          wa_zg2_3-days = days.
              collect wa_zg2_3 into it_zg2_3.
              clear wa_zg2_3.
            else.
              select single * from ysd_inv_per where fkart eq 'ZG2' and begda le s_budat-low and endda ge s_budat-high.
              if sy-subrc eq 0.
                acn_val = wa_zg2_2n-acn_val * ( ysd_inv_per-percnt / 100 ).
*              WRITE :'ZG2 CN GT 180', ACN_VAL.
                wa_zg2_4-bzirk = wa_zg2_2n-bzirk.
                wa_zg2_4-acn_val = acn_val.
*            wa_zg2_4-days = days.
                collect wa_zg2_4 into it_zg2_4.
                clear wa_zg2_4.
              endif.
            endif.
          endif.
************************************
        endif.
      endif.
    else.
      select single * from ysd_inv_per where fkart eq 'ZG2' and begda le s_budat-low and endda ge s_budat-high.
      if sy-subrc eq 0.
        acn_val = wa_zg2_2n-acn_val * ( ysd_inv_per-percnt / 100 ).
*          WRITE :'ZG2 NO PSO', ACN_VAL.
        wa_zg2_5-bzirk = wa_zg2_2n-bzirk.
        wa_zg2_5-acn_val = acn_val.
        collect wa_zg2_5 into it_zg2_5.
        clear wa_zg2_5.
      endif.
    endif.

  endloop.

  loop at it_zg2_3 into wa_zg2_3.
*    WRITE : / 'CN VAL BELOW 180 DAYS',WA_ZG2_3-BZIRK,WA_ZG2_3-ACN_VAL.
    wa_cn1-bzirk = wa_zg2_3-bzirk.
    wa_cn1-acn_val = wa_zg2_3-acn_val.
    collect wa_cn1 into it_cn1.
    clear wa_cn1.
  endloop.

  loop at it_zg2_4 into wa_zg2_4.
*    WRITE : / 'CN VAL AFTER 180 DAYS',WA_ZG2_4-BZIRK,WA_ZG2_4-ACN_VAL.
    wa_cn1-bzirk = wa_zg2_4-bzirk.
    wa_cn1-acn_val = wa_zg2_4-acn_val.
    collect wa_cn1 into it_cn1.
    clear wa_cn1.
  endloop.

  loop at it_zg2_5 into wa_zg2_5.
*    WRITE : / 'CN VAL NO PSO',WA_ZG2_5-BZIRK,WA_ZG2_5-ACN_VAL.
    wa_cn1-bzirk = wa_zg2_5-bzirk.
    wa_cn1-acn_val = wa_zg2_5-acn_val.
    collect wa_cn1 into it_cn1.
    clear wa_cn1.
  endloop.

  loop at it_cn1 into wa_cn1.
*    WRITE : / 'NET ZG2 CN VAL', WA_CN1-BZIRK,WA_CN1-ACN_VAL.
    wa_zcn1-bzirk =  wa_cn1-bzirk.
    wa_zcn1-zg2netcnval = wa_cn1-acn_val.
    collect wa_zcn1 into it_zcn1.
    clear wa_zcn1.
  endloop.

*  LOOP AT IT_PSO1 INTO WA_PSO1.
*    WRITE : / 'pso',wa_pso1-bzirk,wa_pso1-pernr,wa_pso1-join_dt.
*    WA_ZCN1-BZIRK = WA_PSO1-BZIRK.
*    WA_ZCN1-PERNR = WA_PSO1-PERNR.
*    WA_ZCN1-JOIN_DT = WA_PSO1-JOIN_DT.
*    COLLECT WA_ZCN1 INTO IT_ZCN1.
*    CLEAR WA_ZCN1.
*  ENDLOOP.



endform.                    "CN_VAL

*&---------------------------------------------------------------------*
*&      Form  CN_SUMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*&      Form  REALC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form reallocation.
*  sort it_tag1 by kunag spart.
  select * from ycusempadj into table it_ycusempadj where begda le s_budat-low and endda ge s_budat-high.
  if it_ycusempadj is not initial.
    loop at it_ycusempadj into wa_ycusempadj.
*    WRITE : / WA_YCUSEMPADJ-KUNNR,WA_YCUSEMPADJ-SPART,WA_YCUSEMPADJ-NETWR.
      wa_rel1-kunag = wa_ycusempadj-kunnr.
      wa_rel1-spart = wa_ycusempadj-spart.
      wa_rel1-netwr = wa_ycusempadj-netwr.
      collect wa_rel1 into it_rel1.
      clear wa_rel1.
    endloop.
  endif.




  sort it_rel1 by kunag spart.

  loop at it_rel1 into wa_rel1 where netwr ne 0..
*    WRITE : / 'REALLOCATION',WA_REL1-KUNAG,WA_REL1-SPART,WA_REL1-NETWR.
    select * from ysd_cus_div_dis where kunnr eq wa_rel1-kunag and spart eq wa_rel1-spart and begda le s_budat-low
      and endda ge s_budat-high.
      if sy-subrc eq 0.
        clear : rval.
*        WRITE : / 'PERCENTAGE',YSD_CUS_DIV_DIS-KUNNR,YSD_CUS_DIV_DIS-SPART,YSD_CUS_DIV_DIS-BEGDA,YSD_CUS_DIV_DIS-ENDDA,
*        YSD_CUS_DIV_DIS-BZIRK, YSD_CUS_DIV_DIS-PERCNT.
        rval = wa_rel1-netwr * ( ysd_cus_div_dis-percnt / 100 ).
*        WRITE : RVAL.
        wa_rel2-bzirk = ysd_cus_div_dis-bzirk.
        wa_rel2-rval = rval.
        collect wa_rel2 into it_rel2.
        clear wa_rel2.
      endif.
    endselect.
  endloop.
  sort it_rel2 by bzirk.
  loop at it_rel2 into wa_rel2.
*    WRITE : / 'REALL. VAL',WA_REL2-BZIRK,WA_REL2-RVAL.
    wa_zcn1-bzirk =  wa_rel2-bzirk.
    wa_zcn1-rval = wa_rel2-rval * ( - 1 ).
    collect wa_zcn1 into it_zcn1.
    clear wa_zcn1.
  endloop.


  select * from ycusempadj into table it_ycusempadj1 where begda le s_budat-low and endda ge s_budat-high.
  if it_ycusempadj1 is not initial.
    loop at it_ycusempadj1 into wa_ycusempadj1.
*    WRITE : / WA_YCUSEMPADJ-KUNNR,WA_YCUSEMPADJ-SPART,WA_YCUSEMPADJ-NETWR.
      wa_rela1-bzirk = wa_ycusempadj1-bzirk.
      wa_rela1-netwr = wa_ycusempadj1-netwr.
      collect wa_rela1 into it_rela1.
      clear wa_rela1.
    endloop.
  endif.

  loop at it_rela1 into wa_rela1.
    wa_zcn1-bzirk =  wa_rela1-bzirk.
    wa_zcn1-rval = wa_rela1-netwr.
    collect wa_zcn1 into it_zcn1.
    clear wa_zcn1.
  endloop.

endform.                    "REALC

*&---------------------------------------------------------------------*
*&      Form  NEP_SALE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form nep_sale.
  y1 = s_budat-low+0(4).
  m1 = s_budat-low+4(2).
*  WRITE : / 'YEAR, MONTH',Y1,M1.
*  SELECT * FROM YEMPVAL INTO TABLE IT_EMPVAL WHERE ZYEAR EQ Y1 AND MONT EQ M1.

  select single * from yempval where zyear eq y1 and mont eq m1 and week eq '4'.
  if sy-subrc eq 0.
    select * from yempval into table it_empval where zyear eq y1 and mont eq m1 and week eq '4'.
  else.
    select single * from yempval where zyear eq y1 and mont eq m1 and week eq '3'.
    if sy-subrc eq 0.
      select * from yempval into table it_empval where zyear eq y1 and mont eq m1 and week eq '3'.
    else.
      select single * from yempval where zyear eq y1 and mont eq m1 and week eq '2'.
      if sy-subrc eq 0.
        select * from yempval into table it_empval where zyear eq y1 and mont eq m1 and week eq '2'.
      else.
        select * from yempval into table it_empval where zyear eq y1 and mont eq m1 and week eq '1'.
      endif.
    endif.
  endif.


  if it_empval is not initial.
    loop at it_empval into wa_empval.
      wa_nemp1-bzirk = wa_empval-bzirk.
      wa_nemp1-nval = wa_empval-value.
      collect wa_nemp1 into it_nemp1.
      clear wa_nemp1.
    endloop.
  endif.
  sort it_nemp1 by bzirk.
  loop at it_nemp1 into wa_nemp1.
*    WRITE : / 'NEPAL SALE',WA_NEMP1-BZIRK,WA_NEMP1-NVAL.
    wa_zcn1-bzirk =  wa_nemp1-bzirk.
    wa_zcn1-nval = wa_nemp1-nval.
    collect wa_zcn1 into it_zcn1.
    clear wa_zcn1.
  endloop.

endform.                    "NEP_SALE

*&---------------------------------------------------------------------*
*&      Form  CN_SUMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form cn_summ.
  y1 = s_budat-low+0(4).
  m1 = s_budat-low+4(2).
*    WRITE : / 'YEAR, MONTH',Y1,M1.


  loop at it_zcn1 into wa_zcn1.
    read table it_pso1 into wa_pso1 with key bzirk = wa_zcn1-bzirk.
    if sy-subrc eq 4.
      wa_pso2-bzirk = wa_zcn1-bzirk.
      collect wa_pso2 into it_pso2.
      clear wa_pso2.
    endif.
  endloop.


  select * from yterrallc into table it_yterrallc1 for all entries in it_pso2 where bzirk eq it_pso2-bzirk and begda le s_budat-low
    and endda gt s_budat-high and plans ne '99999999'.
  if sy-subrc eq 0.
    select * from pa0001 into table it_pa0001_1 for all entries in it_yterrallc1 where plans eq it_yterrallc1-plans and begda le date1 and
      endda ge s_budat-high .
  endif.
  sort it_pa0001_1.
  loop at it_pa0001_1 into wa_pa0001_1.
    read table it_yterrallc1 into wa_yterrallc1 with key plans = wa_pa0001_1-plans.
    if sy-subrc eq 0.
*      WRITE : / 'qty',wa_yterrallc-bzirk,wa_pa0001-plans,wa_pa0001-pernr,wa_pa0001-begda,wa_pa0001-endda.
      wa_ter2-bzirk = wa_yterrallc1-bzirk.
      wa_ter2-pernr = wa_pa0001_1-pernr.
      select single * from pa0302 where pernr eq wa_pa0001_1-pernr and massn eq '01'.
      if sy-subrc eq 0.
        wa_ter2-begda = pa0302-begda.
      endif.
      wa_ter2-endda = wa_pa0001_1-endda.
      collect wa_ter2 into it_ter2.
      clear wa_ter2.
    endif.
  endloop.
  sort it_ter2 by bzirk endda.
*************************

  perform distsale.

  perform distcn.

  if r1 eq 'X'.

    if test eq space.
      delete from zcumpso where zmonth eq m1 and zyear eq y1.
    endif.
    loop at it_zcn1 into wa_zcn1.
      clear : net, net_val,net1.

      write : /1 wa_zcn1-bzirk left-justified,12 wa_zcn1-sval left-justified.
*      29  WA_ZCN1-ZG2VAL LEFT-JUSTIFIED,
*               29 WA_ZCN1-ZG2NETCNVAL LEFT-JUSTIFIED,

*      ,60 WA_ZCN1-ZG2NETCNVAL LEFT-JUSTIFIED.
      if wa_zcn1-zg2netcnval ge wa_zcn1-zg2val.
        net = wa_zcn1-zg2netcnval.
      else.
        net = wa_zcn1-zg2val.
      endif.
      net1 = net + wa_zcn1-othval.
*      NET1 = NET + WA_ZCN1-OTHVAL.
      write : 29 net, 47 wa_zcn1-othval left-justified, 84 wa_zcn1-rval left-justified, 96 wa_zcn1-nval left-justified.
      net_val = wa_zcn1-sval + wa_zcn1-rval - net1 + wa_zcn1-nval.
      write :  108 net_val left-justified.

      zcumpso_wa-zmonth = m1.
      zcumpso_wa-zyear = y1.
      zcumpso_wa-bzirk = wa_zcn1-bzirk.
      zcumpso_wa-grosspts = wa_zcn1-sval.
      zcumpso_wa-rval = wa_zcn1-rval.
*      ZCUMPSO_WA-ZG2CNVAL = WA_ZCN1-ZG2netcnVAL.
      zcumpso_wa-zg2cnval = net.
      zcumpso_wa-othrcnval = wa_zcn1-othval.
      zcumpso_wa-netcnval = net1.
      zcumpso_wa-nepval = wa_zcn1-nval.
      zcumpso_wa-netval = net_val.
      read table it_pso1 into wa_pso1 with key bzirk = wa_zcn1-bzirk.
      if sy-subrc eq 0.
        write : wa_pso1-pernr,wa_pso1-join_dt.
        zcumpso_wa-pso = wa_pso1-pernr.
        zcumpso_wa-join_dt = wa_pso1-join_dt.
      else.
        read table it_ter2 into wa_ter2 with key bzirk = wa_zcn1-bzirk.
        if sy-subrc eq 0.
          zcumpso_wa-pso = wa_ter2-pernr.
          zcumpso_wa-join_dt = wa_ter2-begda.
        else.
          zcumpso_wa-pso = '00000000'.
          zcumpso_wa-join_dt = 0.
        endif.
      endif.
      if test eq space.
        modify zcumpso from zcumpso_wa.
      endif.
    endloop.

************** update flag in zdist_sale.******************

    loop at it_zdist_sale into wa_zdist_sale.
      move-corresponding wa_zdist_sale to zdist_sale_wa.
      zdist_sale_wa-flag = 'X'.
      modify zdist_sale from zdist_sale_wa.
      clear zdist_sale_wa.
    endloop.

    loop at it_zdist_cn into wa_zdist_cn.
      move-corresponding wa_zdist_cn to zdist_cn_wa.
      zdist_cn_wa-flag = 'X'.
      modify zdist_cn from zdist_cn_wa.
      clear zdist_cn_wa.
    endloop.
***********update log in zlog_upd*********
    if sy-datum+4(2) ge '04'.
      zyear = sy-datum+0(4).
    else.
      zyear = sy-datum+0(4) - 1.
    endif.

    clear : count.
    select * from zlogupd into table it_zlogupd where zcyear eq zyear.
    sort it_zlogupd by zcount descending.
    if it_zlogupd is not initial.
      read table it_zlogupd into wa_zlogupd with key zcyear = zyear.
      if sy-subrc eq 0.
        count = wa_zlogupd-zcount.
        count = count + 1.
      else.
        count = 1.
      endif.
    endif.
    zlogupd_wa-zcyear = zyear.
    zlogupd_wa-zcount = count.
    zlogupd_wa-zmonth = s_budat-low+4(2).
    zlogupd_wa-zyear = s_budat-low+0(4).
    zlogupd_wa-tcode =  'ZCUMPSO'.
    zlogupd_wa-ztable =  'ZCUMPSO'.
    zlogupd_wa-entry_date = sy-datum.
    zlogupd_wa-usnam = sy-uname.
    zlogupd_wa-cputm =  sy-uzeit.
    zlogupd_wa-hostaddr = term.
    if test eq space.
      insert into  zlogupd values  zlogupd_wa.
    endif.

***************************************************
  else.

    loop at it_zcn1 into wa_zcn1.
      clear : net, net_val,net1,nrval,nsval,nzg2val, nothval,nnet1,nnval,nnet_val.

      write : /1 wa_zcn1-bzirk left-justified,12 wa_zcn1-sval left-justified,29  wa_zcn1-zg2val left-justified,
       47 wa_zcn1-othval left-justified,60 wa_zcn1-zg2netcnval left-justified.
      if wa_zcn1-zg2netcnval ge wa_zcn1-zg2val.
        net = wa_zcn1-zg2netcnval.
      else.
        net = wa_zcn1-zg2val.
      endif.
      net1 = net + wa_zcn1-othval.
      write : 72 net1 left-justified, 84 wa_zcn1-rval left-justified, 96 wa_zcn1-nval left-justified.
      net_val = wa_zcn1-sval + wa_zcn1-rval - net1 + wa_zcn1-nval.
      write :  108 net_val left-justified.

      wa_dtab1-m1 = m1.
      wa_dtab1-y1 = y1.
      wa_dtab1-bzirk = wa_zcn1-bzirk.
      wa_dtab1-sval = wa_zcn1-sval.
      if wa_zcn1-sval lt 0.
        nsval = wa_zcn1-sval * ( - 1 ).
        concatenate '-' nsval into wa_dtab1-sval.
        condense wa_dtab1-sval no-gaps.
      endif.
      wa_dtab1-rval = wa_zcn1-rval.
      if wa_zcn1-rval lt 0.
        nrval = wa_zcn1-rval * ( - 1 ).
        concatenate '-' nrval into wa_dtab1-rval.
        condense wa_dtab1-rval no-gaps.
*        WRITE : / 'CHECK -VE VAL'.
      endif.

      wa_dtab1-zg2val = wa_zcn1-zg2val.
      if wa_zcn1-zg2val lt 0.
        nzg2val = wa_zcn1-zg2val * ( - 1 ).
        concatenate '-' nzg2val into wa_dtab1-zg2val.
        condense wa_dtab1-zg2val no-gaps.
      endif.
      wa_dtab1-othval = wa_zcn1-othval.
      if wa_zcn1-othval lt 0.
        nothval = wa_zcn1-othval * ( - 1 ).
        concatenate '-' nothval into wa_dtab1-othval.
        condense wa_dtab1-othval no-gaps.
      endif.
      wa_dtab1-net1 = net1.
      if net1 lt 0.
        nnet1 = net1 * ( - 1 ).
        concatenate '-' nnet1 into wa_dtab1-net1.
        condense wa_dtab1-net1 no-gaps.
      endif.
      wa_dtab1-nval = wa_zcn1-nval.
      if wa_zcn1-nval lt 0.
        nnval = wa_zcn1-nval * ( - 1 ).
        concatenate '-' nnval into wa_dtab1-nval.
        condense wa_dtab1-nval no-gaps.
      endif.
      wa_dtab1-net_val = net_val.

      if net_val lt 0.
        nnet_val = net_val * ( - 1 ).
        concatenate '-' nnet_val into wa_dtab1-net_val.
        condense wa_dtab1-net_val no-gaps.
      endif.

      read table it_pso1 into wa_pso1 with key bzirk = wa_zcn1-bzirk.
      if sy-subrc eq 0.
        write : wa_pso1-pernr,wa_pso1-join_dt.
        wa_dtab1-pso = wa_pso1-pernr.
        wa_dtab1-join_dt = wa_pso1-join_dt.
      else.
        read table it_ter2 into wa_ter2 with key bzirk = wa_zcn1-bzirk.
        if sy-subrc eq 0.
          wa_dtab1-pso = wa_ter2-pernr.
          wa_dtab1-join_dt = wa_ter2-begda.
        else.
          wa_dtab1-pso = '00000000'.
          wa_dtab1-join_dt = 0.
        endif.
      endif.

      collect wa_dtab1 into it_dtab1.
      clear wa_dtab1.


    endloop.

**************download program************
    data: filename    type string,
          l_filetable type filetable,
          l_rc        type i,
          l_filename  type string,
          msg         type string.

    types: begin of t_uname,
             uname type yruser_name-username,
             path  type yruser_name-path,
           end of t_uname.

    data: wa_name type t_uname.

    data: l_fname type string,
          l_fdate type sy-datum,
          l_mon   type string,
          l_name  type string.

    l_name = 'ZCUMPSO'.
    l_fdate = sy-datum.

    l_fdate = l_fdate(4).
    l_mon = sy-datum+4(2).
*      l_dat = s_audat-low+6(2).

    select single username path from yruser_name into wa_name where username = sy-uname.

    if sy-subrc = 0.

      concatenate  wa_name-path '/' l_name
*  l_fdate l_mon
      '.TXT' into l_filename.

    else .
      message 'NO DATA' type 'E'.

    endif.
    loop at it_dtab1 into wa_dtab1.
      move-corresponding wa_dtab1 to wa_dtab1_down.
      write wa_dtab1_down-join_dt to wa_dat dd/mm/yyyy.

      concatenate wa_dtab1-m1 wa_dtab1-y1 wa_dtab1-bzirk wa_dtab1-sval wa_dtab1-rval wa_dtab1-zg2val wa_dtab1-othval
      wa_dtab1-net1 wa_dtab1-nval wa_dtab1-net_val wa_dtab1-pso wa_dtab1-join_dt into wa_down-field separated by ','.
      append wa_down to it_down.
      clear wa_down.
    endloop.


    read table l_filetable index 1 into l_filename.
    search l_filename for '.txt'.
    if sy-subrc <> 0.
      concatenate l_filename '.txt' into l_filename.
    endif.

    call function 'GUI_DOWNLOAD'
      exporting
*       BIN_FILESIZE                    =
        filename = l_filename
        filetype = 'ASC'
      tables
        data_tab = it_down.
    if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.


  endif.
endform.                    "CN_SUMM

top-of-page.
  write : / 'SR9 DATA FROM DATE',s_budat-low ,'TO', s_budat-high.
  write : / 'FOLLOWING DATA HAS UPDATED IN SYSTEM'.

  uline.
  write : /1 'TERITTORY',12 'GROSS SALE',29 'ZG2 CREDIT NOTE',47 'OTHR CREDIT NOTE',65 'NET CREDIT NOTE',
  83 'REALLOCATION',100 'NEPAL VALUE', 117 'NET VALUE'.
  uline.
*&---------------------------------------------------------------------*
*&      Form  DISTSALE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form distsale .
  clear :it_zdist_sale,wa_zdist_sale.
  clear : it_dist1,wa_dist1,it_dist2,wa_dist2.

  select * from zdist_sale into table it_zdist_sale where fkdat ge s_budat-low and fkdat le s_budat-high.



*    select * from zdist_sale into table it_zdist_sale where fkdat ge s_budat-low and fkdat le s_budat-high and flag eq space.
*  select * from zdist_sale into table it_zdist_sale where fkdat ge s_budat-low and fkdat le s_budat-high and flag eq space.
  if it_zdist_sale is not initial.
    loop at it_zdist_sale into wa_zdist_sale.
      select single * from mara where matnr eq wa_zdist_sale-matnr and spart in ( '50','60','70' ).
      if sy-subrc eq 0.
*    wa_tab1-kunrg = wa_zdist_sale-kunrg.
        wa_dist1-kunag = wa_zdist_sale-kunag.
*      wa_dist1-matnr = wa_zdist_sale-matnr.
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

  if it_ysd_cus_div_dis1 is not initial.
    loop at it_ysd_cus_div_dis1 into wa_ysd_cus_div_dis1.
      read table it_dist1 into wa_dist1 with key kunag = wa_ysd_cus_div_dis1-kunnr spart = wa_ysd_cus_div_dis1-spart.
      if sy-subrc eq 0.
        clear : distval,distqty.
        wa_dist2-bzirk  = wa_ysd_cus_div_dis1-bzirk.
*      wa_dist2-matnr = wa_dist1-matnr.
        clear : distqty,distval.
        distval = ( wa_dist1-netwr * ( wa_ysd_cus_div_dis1-percnt / 100 ) ).
        distqty = ( wa_dist1-fkimg * ( wa_ysd_cus_div_dis1-percnt / 100 ) ).
        wa_dist2-netwr = distval.
        wa_dist2-fkimg = distqty.
        collect wa_dist2 into it_dist2.
        clear wa_dist2.

      endif.
    endloop.
  endif.
*  loop at it_dist1 into wa_dist1.
*    clear : distval,distqty.
*    select single * from ysd_cus_div_dis where kunnr eq wa_dist1-kunag and spart eq wa_dist1-spart and begda ge s_budat-low and endda ge s_budat-high.
*    if sy-subrc eq 0.
*      wa_dist2-bzirk  = ysd_cus_div_dis-bzirk.
**      wa_dist2-matnr = wa_dist1-matnr.
*      distval = ( wa_dist1-netwr * ( ysd_cus_div_dis-percnt / 100 ) ).
*      distqty = ( wa_dist1-fkimg * ( ysd_cus_div_dis-percnt / 100 ) ).
*      wa_dist2-netwr = distval.
*      wa_dist2-fkimg = distqty.
*      collect wa_dist2 into it_dist2.
*      clear wa_dist2.
*    endif.
*  endloop.

  loop at it_dist2 into wa_dist2.
    wa_zcn1-bzirk =  wa_dist2-bzirk.
*    wa_zcn1-matnr =  wa_dist2-matnr.
    wa_zcn1-sval =  wa_dist2-netwr.
    wa_zcn1-zg2val =  0.
    wa_zcn1-othval =  0.
    wa_zcn1-zg2netcnval =  0.
    wa_zcn1-rval =  0.
    wa_zcn1-nval =  0.

    collect wa_zcn1 into it_zcn1.
    clear wa_zcn1.
  endloop.
endform.
*&---------------------------------------------------------------------*
*&      Form  DISTCN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form distcn .
  clear :it_zdist_cn.
  clear : it_dist1,wa_dist1,it_dist2,wa_dist2.

  select * from zdist_cn into table it_zdist_cn where fkdat ge s_budat-low and fkdat le s_budat-high.



*    select * from zdist_cn into table it_zdist_cn where fkdat ge s_budat-low and fkdat le s_budat-high and flag eq space.
*  select * from zdist_cn into table it_zdist_cn where fkdat ge s_budat-low and fkdat le s_budat-high and flag eq space.
  if it_zdist_cn is not initial.
    loop at it_zdist_cn into wa_zdist_cn.
      select single * from mara where matnr eq wa_zdist_cn-matnr and spart in ( '50','60','70' ).
      if sy-subrc eq 0.
*    wa_tab1-kunrg = wa_zdist_cn-kunrg.
        wa_dist1-kunag = wa_zdist_cn-kunag.
*      wa_dist1-matnr = wa_zdist_cn-matnr.
        wa_dist1-spart = mara-spart.
        wa_dist1-netwr =   wa_zdist_cn-netwr.
        wa_dist1-fkimg =   wa_zdist_cn-fkimg.
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

  if it_ysd_cus_div_dis1 is not initial.
    loop at it_ysd_cus_div_dis1 into wa_ysd_cus_div_dis1.
      read table it_dist1 into wa_dist1 with key kunag = wa_ysd_cus_div_dis1-kunnr spart = wa_ysd_cus_div_dis1-spart.
      if sy-subrc eq 0.
        wa_dist2-bzirk  = wa_ysd_cus_div_dis1-bzirk.
*      wa_dist2-matnr = wa_dist1-matnr.
        clear : distqty,distval.
        distval = ( wa_dist1-netwr * ( wa_ysd_cus_div_dis1-percnt / 100 ) ).
        distqty = ( wa_dist1-fkimg * ( wa_ysd_cus_div_dis1-percnt / 100 ) ).
        wa_dist2-netwr = distval.
        wa_dist2-fkimg = distqty.
        collect wa_dist2 into it_dist2.
        clear wa_dist2.

      endif.
    endloop.
  endif.

  loop at it_dist2 into wa_dist2.
    wa_zcn1-bzirk =  wa_dist2-bzirk.
*    wa_zcn1-matnr =  wa_dist2-matnr.
    wa_zcn1-sval =  0.
    wa_zcn1-zg2val =  0.
    wa_zcn1-othval =  wa_dist2-netwr.
    wa_zcn1-zg2netcnval =  0.
    wa_zcn1-rval =  0.
    wa_zcn1-nval =  0.

    collect wa_zcn1 into it_zcn1.
    clear wa_zcn1.
  endloop.
endform.
