*&---------------------------------------------------------------------*
*& Report  ZSR9_PRG1
*& Report developed by Jyotsna in Dec'14..
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zsr9_prg21_6 NO STANDARD PAGE HEADING LINE-SIZE 500.

TABLES: zcumpso,
        yterrallc,
        zdsmter,
        hrp1001,
        pa0001,
        zthr_heq_des,
        pa0302,
        hrp1000,
        ysd_dist_targt,
        vbrk,
        mara,
        ysd_inv_per,
        zfsdes,
        pa0105,
        zdrphq,
        zoneseq,
        ysd_hbe_targt,
        ysd_cus_div_dis.

TYPE-POOLS:  slis.

DATA: g_repid     LIKE sy-repid,
      fieldcat    TYPE slis_t_fieldcat_alv,
      wa_fieldcat LIKE LINE OF fieldcat,
      sort        TYPE slis_t_sortinfo_alv,
      wa_sort     LIKE LINE OF sort,
      layout      TYPE slis_layout_alv.

TYPES : BEGIN OF typ_konv,
          knumv TYPE prcd_elements-knumv,
          kposn TYPE prcd_elements-kposn,
          kschl TYPE prcd_elements-kschl,
          kwert TYPE prcd_elements-kwert,
        END OF typ_konv.

DATA : it_zdsmter         TYPE TABLE OF zdsmter,
       wa_zdsmter         TYPE zdsmter,
       it_vbrk            TYPE TABLE OF vbrk,
       wa_vbrk            TYPE vbrk,
       it_vbrp            TYPE TABLE OF vbrp,
       wa_vbrp            TYPE vbrp,
       it_vbrk1           TYPE TABLE OF vbrk,
       wa_vbrk1           TYPE vbrk,
       it_vbrp1           TYPE TABLE OF vbrp,
       wa_vbrp1           TYPE vbrp,
       it_konv            TYPE TABLE OF typ_konv,
       wa_konv            TYPE typ_konv,
       it_konv1           TYPE TABLE OF typ_konv,
       wa_konv1           TYPE typ_konv,
       it_ysd_cus_div_dis TYPE TABLE OF ysd_cus_div_dis,
       wa_ysd_cus_div_dis TYPE ysd_cus_div_dis,
       it_yterrallc       TYPE TABLE OF yterrallc,
       wa_yterrallc       TYPE yterrallc,
       it_yterrallc_n     TYPE TABLE OF yterrallc,
       wa_yterrallc_n     TYPE yterrallc,
       it_pa0001          TYPE TABLE OF pa0001,
       wa_pa0001          TYPE pa0001,
       it_pa0001_1        TYPE TABLE OF pa0001,
       wa_pa0001_1        TYPE pa0001,
       it_pa0001_2        TYPE TABLE OF pa0001,
       wa_pa0001_2        TYPE pa0001,
       it_yempval         TYPE TABLE OF yempval,
       wa_yempval         TYPE yempval.

TYPES : BEGIN OF itab1,
          reg       TYPE zdsmter-zdsm,
          spart     TYPE zdsmter-spart,
          zm        TYPE zdsmter-bzirk,
          rm        TYPE zdsmter-bzirk,
          bzirk     TYPE zdsmter-bzirk,
          text(9)   TYPE c,
          sval      TYPE p DECIMALS 2,
          acn_val   TYPE p DECIMALS 2,
          oth_val   TYPE p DECIMALS 2,
          net       TYPE p DECIMALS 2,
          plans     TYPE yterrallc-plans,
          ename     TYPE pa0001-ename,
          zz_hqdesc TYPE zthr_heq_des-zz_hqdesc,
          short     TYPE hrp1000-short,
          begda     TYPE pa0302-begda,
          nepval    TYPE yempval-value,
        END OF itab1.

TYPES : BEGIN OF itac7,
          reg         TYPE zdsmter-zdsm,
          spart       TYPE zdsmter-spart,
          zm          TYPE zdsmter-bzirk,
          rm          TYPE zdsmter-bzirk,
          bzirk       TYPE zdsmter-bzirk,
          text(9)     TYPE c,
          sval        TYPE p DECIMALS 2,
          acn_val     TYPE p DECIMALS 2,
          oth_val     TYPE p DECIMALS 2,
          net         TYPE p DECIMALS 2,
          plans       TYPE yterrallc-plans,
          ename       TYPE pa0001-ename,
          zz_hqdesc   TYPE zthr_heq_des-zz_hqdesc,
          short       TYPE hrp1000-short,
          begda       TYPE pa0302-begda,
          rename      TYPE pa0001-ename,
          rzz_hqdesc  TYPE zthr_heq_des-zz_hqdesc,
          rshort      TYPE hrp1000-short,
          rbegda      TYPE pa0302-begda,
          dzename     TYPE pa0001-ename,
          dzzz_hqdesc TYPE zthr_heq_des-zz_hqdesc,
          dzshort     TYPE hrp1000-short,
          dzbegda     TYPE pa0302-begda,
          zename      TYPE pa0001-ename,
          zzz_hqdesc  TYPE zthr_heq_des-zz_hqdesc,
          zshort      TYPE hrp1000-short,
          zbegda      TYPE pa0302-begda,
          targt       TYPE p,
          rpernr      TYPE pa0001-pernr,
          dzpernr     TYPE pa0001-pernr,
          zpernr      TYPE pa0001-pernr,
        END OF itac7.

TYPES : BEGIN OF itad1,
          reg     TYPE zdsmter-zdsm,
          zm      TYPE zdsmter-bzirk,
          rm      TYPE zdsmter-bzirk,
          bzirk   TYPE zdsmter-bzirk,
          text(9) TYPE c,
          sval    TYPE p DECIMALS 2,
          acn_val TYPE p DECIMALS 2,
          oth_val TYPE p DECIMALS 2,
          net     TYPE p DECIMALS 2,
          plans   TYPE yterrallc-plans,
          zpernr  TYPE pa0001-pernr,
          rpernr  TYPE pa0001-pernr,
          gmpernr TYPE pa0001-pernr,
        END OF itad1.

TYPES : BEGIN OF itad2,
          seq     TYPE zoneseq-seq,
          reg     TYPE zdsmter-zdsm,
          zm      TYPE zdsmter-bzirk,
          rm      TYPE zdsmter-bzirk,
          bzirk   TYPE zdsmter-bzirk,
          text(9) TYPE c,
          sval    TYPE p DECIMALS 2,
          acn_val TYPE p DECIMALS 2,
          oth_val TYPE p DECIMALS 2,
          net     TYPE p,
          plans   TYPE yterrallc-plans,
          div(3)  TYPE c,
          targt   TYPE p,
          targt1  TYPE p,
          count   TYPE i,
          zpernr  TYPE pa0001,
          gmpernr TYPE pa0001-pernr,

        END OF itad2.

TYPES : BEGIN OF itad4,
          reg    TYPE zdsmter-zdsm,
          div(3) TYPE c,
          count  TYPE i,
        END OF itad4.

TYPES : BEGIN OF itab3,
          reg       TYPE zdsmter-zdsm,
          spart     TYPE zdsmter-zdsmspart,
          zm        TYPE zdsmter-bzirk,
          rm        TYPE zdsmter-bzirk,
          bzirk     TYPE zdsmter-bzirk,
          plans     TYPE pa0001-plans,
          pernr     TYPE pa0001-pernr,
          ename     TYPE pa0001-ename,
          zz_hqdesc TYPE zthr_heq_des-zz_hqdesc,
          join_dt   TYPE pa0001-begda,
          short     TYPE hrp1000-short,
          netval    TYPE zcumpso-netval,
          tar       TYPE p,
*  spart TYPE mara-spart,
          kunnr     TYPE vbrk-kunag,
          bval      TYPE p DECIMALS 2,
          xval      TYPE p DECIMALS 2,
        END OF itab3.

TYPES : BEGIN OF itas1,
          vbeln      TYPE vbrp-vbeln,
          matnr      TYPE vbrp-matnr,
          charg      TYPE vbrp-charg,
          fkimg_s    TYPE vbrp-fkimg,
          fkimg_b    TYPE vbrp-fkimg,
          arktx      TYPE vbrp-arktx,
          lgort      TYPE vbrp-lgort,
          kzwi2      TYPE vbrp-kzwi2,
          bed_rate   TYPE p DECIMALS 2,
          xed_rate   TYPE p DECIMALS 2,
          led_rate   TYPE p DECIMALS 2,
          bzped_rate TYPE p DECIMALS 2,
          xzped_rate TYPE p DECIMALS 2,
          lzped_rate TYPE p DECIMALS 2,
          bzgrp_rate TYPE p DECIMALS 2,
          xzgrp_rate TYPE p DECIMALS 2,
          lzgrp_rate TYPE p DECIMALS 2,
          werks      TYPE vbrp-werks,
          zped       TYPE p DECIMALS 2,
          fkdat      TYPE vbrk-fkdat,
          kunag      TYPE vbrk-kunag,
          bpts       TYPE p DECIMALS 2,
          xpts       TYPE p DECIMALS 2,
          lpts       TYPE p DECIMALS 2,
          spart      TYPE mara-spart,
          bzirk      TYPE yterrallc-bzirk,
          kunnr      TYPE vbrk-kunag,
          bval       TYPE p DECIMALS 2,
          xval       TYPE p DECIMALS 2,
          lval       TYPE p DECIMALS 2,
          sval       TYPE p DECIMALS 2,
        END OF itas1.

TYPES : BEGIN OF itag1,
          vbeln      TYPE vbrp-vbeln,
          matnr      TYPE vbrp-matnr,
          charg      TYPE vbrp-charg,
          fkimg_s    TYPE vbrp-fkimg,
          fkimg_b    TYPE vbrp-fkimg,
          arktx      TYPE vbrp-arktx,
          lgort      TYPE vbrp-lgort,
          kzwi2      TYPE vbrp-kzwi2,
          bed_rate   TYPE p DECIMALS 2,
          xed_rate   TYPE p DECIMALS 2,
          bzped_rate TYPE p DECIMALS 2,
          xzped_rate TYPE p DECIMALS 2,
          werks      TYPE vbrp-werks,
          zped       TYPE p DECIMALS 2,
          fkdat      TYPE vbrk-fkdat,
          kunag      TYPE vbrk-kunag,
          bpts       TYPE p DECIMALS 2,
          xpts       TYPE p DECIMALS 2,
          spart      TYPE mara-spart,
          bzirk      TYPE yterrallc-bzirk,
          kunnr      TYPE vbrk-kunag,
          bval       TYPE p DECIMALS 2,
          xval       TYPE p DECIMALS 2,
          fkart      TYPE vbrk-fkart,
          bnetwr     TYPE p DECIMALS 2,
          xnetwr     TYPE p DECIMALS 2,
          lnetwr     TYPE p DECIMALS 2,
          cn_val     TYPE p DECIMALS 2,
        END OF itag1.

TYPES : BEGIN OF itam1,
          zpernr     TYPE pa0001-pernr,
          usrid_long TYPE pa0105-usrid_long,
        END OF itam1.


TYPES : BEGIN OF itac3,
          bzirk  TYPE ysd_cus_div_dis-bzirk,
          kunnr  TYPE ysd_cus_div_dis-kunnr,
          spart  TYPE ysd_cus_div_dis-spart,
          percnt TYPE ysd_cus_div_dis-percnt,
        END OF   itac3.

TYPES : BEGIN OF   ter1,
          bzirk   TYPE ysd_cus_div_dis-bzirk,
          plans   TYPE pa0001-plans,
          pernr   TYPE pa0001-pernr,
          begda   TYPE pa0001-begda,
          endda   TYPE pa0001-endda,
          join_dt TYPE sy-datum,
          spart   TYPE mara-spart,
        END OF ter1.

TYPES : BEGIN OF   zcn1,
          bzirk   TYPE ysd_cus_div_dis-bzirk,
          spart   TYPE mara-spart,
          acn_val TYPE p DECIMALS 2,
          oth_val TYPE p DECIMALS 2,
        END OF zcn1.

TYPES : BEGIN OF itap1,
          pernr      TYPE pa0001-pernr,
          usrid_long TYPE pa0105-usrid_long,
        END OF itap1.

TYPES : BEGIN OF inep1,
          spart TYPE yempval-spart,
          bzirk TYPE yempval-bzirk,
          value TYPE yempval-value,
        END OF inep1.
TYPES : BEGIN OF zmemail,
          reg        TYPE zdsmter-bzirk,
          usrid_long TYPE pa0105-usrid_long,
        END OF zmemail.

TYPES : BEGIN OF smemail,
          sm         TYPE zdsmter-bzirk,
          reg        TYPE zdsmter-bzirk,
          usrid_long TYPE pa0105-usrid_long,
        END OF smemail.

TYPES : BEGIN OF rmemail,
          reg        TYPE zdsmter-bzirk,
          zm         TYPE zdsmter-bzirk,
          rm         TYPE zdsmter-bzirk,
          usrid_long TYPE pa0105-usrid_long,
        END OF rmemail.

TYPES : BEGIN OF dzmemail,
          reg        TYPE zdsmter-bzirk,
          zm         TYPE zdsmter-bzirk,
          rm         TYPE zdsmter-bzirk,
          usrid_long TYPE pa0105-usrid_long,
        END OF dzmemail.

DATA : it_tab1     TYPE TABLE OF itab1,
       wa_tab1     TYPE itab1,
       it_tab2     TYPE TABLE OF itab1,
       wa_tab2     TYPE itab1,
       it_tac1     TYPE TABLE OF itab1,
       wa_tac1     TYPE itab1,
       it_tac2     TYPE TABLE OF itab1,
       wa_tac2     TYPE itab1,
       it_tac3     TYPE TABLE OF itac3,
       wa_tac3     TYPE itac3,
       it_tac4     TYPE TABLE OF itac3,
       wa_tac4     TYPE itac3,
       it_tac5     TYPE TABLE OF itab1,
       wa_tac5     TYPE itab1,
       it_tac6     TYPE TABLE OF itab1,
       wa_tac6     TYPE itab1,
       it_tac7     TYPE TABLE OF itac7,
       wa_tac7     TYPE itac7,
       it_tad1     TYPE TABLE OF itad1,
       wa_tad1     TYPE itad1,
       it_tad2     TYPE TABLE OF itad2,
       wa_tad2     TYPE itad2,
       it_tad21    TYPE TABLE OF itad2,
       wa_tad21    TYPE itad2,
       it_tad3     TYPE TABLE OF itad2,
       wa_tad3     TYPE itad2,
       it_tad4     TYPE TABLE OF itad4,
       wa_tad4     TYPE itad4,
       it_tad5     TYPE TABLE OF itad4,
       wa_tad5     TYPE itad4,
       it_tab3     TYPE TABLE OF itab3,
       wa_tab3     TYPE itab3,
       it_tas1     TYPE TABLE OF itas1,
       wa_tas1     TYPE itas1,
       it_tas2     TYPE TABLE OF itas1,
       wa_tas2     TYPE itas1,
       it_tas3     TYPE TABLE OF itas1,
       wa_tas3     TYPE itas1,
       it_tas4     TYPE TABLE OF itas1,
       wa_tas4     TYPE itas1,
       it_tag1     TYPE TABLE OF itag1,
       wa_tag1     TYPE itag1,
       it_tag2     TYPE TABLE OF itag1,
       wa_tag2     TYPE itag1,
       it_tag3     TYPE TABLE OF itag1,
       wa_tag3     TYPE itag1,
       it_tag4     TYPE TABLE OF itag1,
       wa_tag4     TYPE itag1,
       it_zcn1     TYPE TABLE OF zcn1,
       wa_zcn1     TYPE zcn1,
       it_ter1     TYPE TABLE OF ter1,
       wa_ter1     TYPE ter1,
       it_oth1     TYPE TABLE OF itag1,
       wa_oth1     TYPE itag1,
       it_oth2     TYPE TABLE OF itag1,
       wa_oth2     TYPE itag1,
       it_tam1     TYPE TABLE OF itam1,
       wa_tam1     TYPE itam1,
       it_tam2     TYPE TABLE OF itam1,
       wa_tam2     TYPE itam1,
       it_tap1     TYPE TABLE OF itap1,
       wa_tap1     TYPE itap1,
       it_tap2     TYPE TABLE OF itap1,
       wa_tap2     TYPE itap1,
       it_tae1     TYPE TABLE OF itab1,
       wa_tae1     TYPE itab1,
       it_nep1     TYPE TABLE OF inep1,
       wa_nep1     TYPE inep1,
       it_zmemail  TYPE TABLE OF zmemail,
       wa_zmemail  TYPE zmemail,
       it_smemail  TYPE TABLE OF smemail,
       wa_smemail  TYPE smemail,
       it_rmemail  TYPE TABLE OF rmemail,
       wa_rmemail  TYPE rmemail,
       it_dzmemail TYPE TABLE OF dzmemail,
       wa_dzmemail TYPE dzmemail.

*TYPES: BEGIN OF SF1,
*         ZM         TYPE ZDSMTER-BZIRK,
*         RM         TYPE ZDSMTER-BZIRK,
*         BZIRK      TYPE ZDSMTER-BZIRK,
*         ENAME      TYPE PA0001-ENAME,
*         ZZ_HQDESC  TYPE ZTHR_HEQ_DES-ZZ_HQDESC,
*         SHORT      TYPE HRP1000-SHORT,
*         JOINDT(6)  TYPE C,
*         DIV(3)     TYPE C,
*         NET(15)    TYPE C,
*         TARGT1(15) TYPE C,
*         STP(7)     TYPE C,
*       END OF SF1.
*TYPES: BEGIN OF SF2,
*         ZM TYPE ZDSMTER-BZIRK,
*         RM TYPE ZDSMTER-BZIRK,
*       END OF SF2.
*TYPES: BEGIN OF SF3,
*         ZM TYPE ZDSMTER-BZIRK,
*       END OF SF3.

TYPES: BEGIN OF rm1,
         rm    TYPE zdsmter-bzirk,
         rmtot TYPE p,
         rmtar TYPE p,
       END OF rm1.

TYPES: BEGIN OF zm1,
         zm    TYPE zdsmter-bzirk,
         zmtot TYPE p,
         zmtar TYPE p,
       END OF zm1.

TYPES: BEGIN OF reg1,
         reg    TYPE zdsmter-bzirk,
         regtot TYPE p,
         regtar TYPE p,
       END OF reg1.

TYPES: BEGIN OF sm1,
         sm     TYPE zdsmter-bzirk,
         reg    TYPE zdsmter-bzirk,
         net    TYPE p,
         targt1 TYPE p,
         c_tot  TYPE i,
*         P_TOT  TYPE I,
       END OF sm1.

TYPES: BEGIN OF sm2,
         sm     TYPE zdsmter-bzirk,
*         REG    TYPE ZDSMTER-BZIRK,
         net    TYPE p,
         targt1 TYPE p,
         c_tot  TYPE i,
*         P_TOT  TYPE I,
       END OF sm2.

TYPES: BEGIN OF sm3,
         div(3) TYPE c,

*         REG    TYPE ZDSMTER-BZIRK,
         net    TYPE p,
         targt1 TYPE p,
         c_tot  TYPE i,
*         P_TOT  TYPE I,
       END OF sm3.



DATA: it_sf1   TYPE TABLE OF zsr9_1,
      wa_sf1   TYPE zsr9_1,
      it_sf2   TYPE TABLE OF zsr9_1,
      wa_sf2   TYPE zsr9_1,
      it_sfrm1 TYPE TABLE OF zsr9_1,
      wa_sfrm1 TYPE zsr9_1,
      it_sf3   TYPE TABLE OF zsr9_1,
      wa_sf3   TYPE zsr9_1,
      it_sf11  TYPE TABLE OF zsr9_4,
      wa_sf11  TYPE zsr9_4,
      it_sf12  TYPE TABLE OF zsr9_4,
      wa_sf12  TYPE zsr9_4,
      it_sf13  TYPE TABLE OF zsr9_4,
      wa_sf13  TYPE zsr9_4,
      it_sf14  TYPE TABLE OF zsr9_4,
      wa_sf14  TYPE zsr9_4,
      it_sf15  TYPE TABLE OF zsr9_5,
      wa_sf15  TYPE zsr9_5,
      it_sf16  TYPE TABLE OF zsr9_6,
      wa_sf16  TYPE zsr9_6,
      it_sf17  TYPE TABLE OF zsr9_6,
      wa_sf17  TYPE zsr9_6,
      it_sf18  TYPE TABLE OF zsr9_6,
      wa_sf18  TYPE zsr9_6,
      it_ntab1 TYPE TABLE OF zsr9_7,
      wa_ntab1 TYPE zsr9_7,
      it_ntab2 TYPE TABLE OF zsr9_7,
      wa_ntab2 TYPE zsr9_7,
      it_rm1   TYPE TABLE OF rm1,
      wa_rm1   TYPE rm1,
      it_zm1   TYPE TABLE OF zm1,
      wa_zm1   TYPE zm1,
      it_reg1  TYPE TABLE OF reg1,
      wa_reg1  TYPE reg1,
      it_sm1   TYPE TABLE OF sm1,
      wa_sm1   TYPE sm1,
      it_sm2   TYPE TABLE OF sm2,
      wa_sm2   TYPE sm2,
      it_sm3   TYPE TABLE OF sm3,
      wa_sm3   TYPE sm3.
TYPES: BEGIN OF sum1,
         form1(1) TYPE c,
       END OF sum1.
DATA: nter1 TYPE i.
DATA: nsale1 TYPE p,
      ntar1  TYPE p,
      nter2  TYPE i,
      nter3  TYPE i.
DATA: count2 TYPE i.

DATA: dnter1 TYPE i.
DATA: dnsale1 TYPE p,
      dntar1  TYPE p,
      dnter2  TYPE i,
      dnter3  TYPE i.
DATA: it_sum1 TYPE TABLE OF sum1,
      wa_sum1 TYPE sum1.
DATA: sform1(1) TYPE c.
DATA: bcd1(10) TYPE c,
      bcd2(10) TYPE c,
      xld1(10) TYPE c,
      xld2(10) TYPE c,
      lsd1(10) TYPE c,
      lsd2(10) TYPE c.
DATA: tot1      TYPE p,
      tot2      TYPE p,
      tot3      TYPE p,
      totc1(10) TYPE c,
      totc2(10) TYPE c.
DATA: pbcd2 TYPE p,
      pxld2 TYPE p,
      plsd2 TYPE p.

DATA: bd1(10) TYPE p,
      bd2(10) TYPE p,
      bd3(10) TYPE c,
      xd1(10) TYPE p,
      xd2(10) TYPE p,
      xd3(10) TYPE c,
      ld1(10) TYPE p,
      ld2(10) TYPE p,
      ld3(10) TYPE c,
      ad3(10) TYPE c.
DATA: adiv1      TYPE p,
      acdiv1(10) TYPE c.
DATA: bds4    TYPE p,
      xds4    TYPE p,
      lds4    TYPE p,
      ads4    TYPE p,

      bds5    TYPE p,
      xds5    TYPE p,
      lds5    TYPE p,
      ads5    TYPE p,

      bd4(10) TYPE c,
      xd4(10) TYPE c,
      ld4(10) TYPE c,
      ad4(10) TYPE c,

      bd5(10) TYPE c,
      xd5(10) TYPE c,
      ld5(10) TYPE c,
      ad5(10) TYPE c.
DATA: bd3t TYPE p,
      xd3t TYPE p,
      ld3t TYPE p,
      ad3t TYPE p.

DATA: regnet(15)    TYPE c,
      regtargt1(15) TYPE c,
      regstp        TYPE p,
      regstp1(10)   TYPE c.
DATA: stp1 TYPE p,
      stp2 TYPE p,
      net1 TYPE p,
      tar1 TYPE p.
DATA: t1 TYPE p,
      t2 TYPE p,
      t3 TYPE p,
      t4 TYPE p.
DATA : date1 TYPE sy-datum,
       lday  TYPE sy-datum.
DATA : rm_val   TYPE p,
       zm_val   TYPE p,
       month(2) TYPE c,
       year(4)  TYPE c,
       year1(4) TYPE c,
       m2(2)    TYPE c,
       y2(4)    TYPE c,
       s_val    TYPE p DECIMALS 2,
       week(1)  TYPE c.

DATA: bpts    TYPE p DECIMALS 2,
      xpts    TYPE p DECIMALS 2,
      lpts    TYPE p DECIMALS 2,
      bval    TYPE p DECIMALS 2,
      xval    TYPE p DECIMALS 2,
      lval    TYPE p DECIMALS 2,
      bcn     TYPE p DECIMALS 2,
      xcn     TYPE p DECIMALS 2,
      lcn     TYPE p DECIMALS 2,
      cn_val  TYPE p DECIMALS 2,
      acn_val TYPE p DECIMALS 2,
      val     TYPE p DECIMALS 2.

DATA : stay       TYPE i,
       stay1      TYPE i,
       stay2      TYPE i,
       stay3      TYPE i,
       stay4(10)  TYPE c,
       days       TYPE i,
       d1         TYPE i VALUE 180,
       a1(2)      TYPE c,
       sday       TYPE sy-datum,
       join_dt    TYPE sy-datum,
       net        TYPE p DECIMALS 2,
       rmtot      TYPE p,
       dztot      TYPE p,
       zmtot      TYPE p,
       rmtar      TYPE p,
       dzmtar     TYPE p,
       zmtar      TYPE p,
       jo_dt1(7)  TYPE c,
       rjo_dt(7)  TYPE c,
       dzjo_dt(7) TYPE c,
       zjo_dt(7)  TYPE c,
       stp        TYPE p,
       stpcnt     TYPE p,
       rstp       TYPE p,
       dzmstp     TYPE p,
       zstp       TYPE p,
       count      TYPE i,
       count1     TYPE i.
DATA: stpcnt1     TYPE p,
      stpcnt2(10) TYPE c.
DATA: bcdt1 TYPE p,
      xldt1 TYPE p,
      lsdt1 TYPE p,
      tdiv1 TYPE p.
DATA: bcdiv1(10)  TYPE c,
      xldiv1(10)  TYPE c,
      lsdiv1(10)  TYPE c,
      totdiv1(10) TYPE c.
DATA : bc       TYPE i,
       bcl      TYPE i,
       xl       TYPE i,
       ls       TYPE i,
       page1    TYPE i,
       page2    TYPE i,
       page3    TYPE i,
       page4(1) TYPE c,
       zm_name  TYPE pa0001-ename,
       c_bcl    TYPE i,
       c_bc     TYPE i,
       c_xl     TYPE i,
       c_ls     TYPE i,
       c_tot    TYPE i,
       p_bcl    TYPE i,
       p_bc     TYPE i,
       p_xl     TYPE i,
       p_ls     TYPE i,
       p_tot    TYPE i,
       hqcode   TYPE zthr_heq_des-zz_hqdesc.

DATA:  div(3)  TYPE c.

DATA: bcl1(1) TYPE c,
      bc1(1)  TYPE c,
      xl1(1)  TYPE c,
      ls1(1)  TYPE c.

DATA: c_bcl1(15) TYPE c,
      c_bc1(15)  TYPE c,
      c_xl1(15)  TYPE c,
      c_ls1(15)  TYPE c,
      c_tot1(15) TYPE c,
      p_bcl1(15) TYPE c,
      p_bc1(15)  TYPE c,
      p_xl1(15)  TYPE c,
      p_ls1(15)  TYPE c,
      p_tot1     TYPE i,
      p_tot2(15) TYPE c.

DATA: dcount TYPE i.
DATA: divs(3) TYPE c.
DATA: prdty1 TYPE p,
      sval1  TYPE p,
      tval1  TYPE p.

DATA : zspd TYPE vbrp-netwr,
       zgrp TYPE vbrp-netwr.

DATA : options        TYPE itcpo,
       l_otf_data     LIKE itcoo OCCURS 10,
       l_asc_data     LIKE tline OCCURS 10,
       l_docs         LIKE docs  OCCURS 10,
       l_pdf_data     LIKE solisti1 OCCURS 10,
       l_pdf_data1    LIKE solisti1 OCCURS 10,
       l_bin_filesize TYPE i.
DATA :  result      LIKE  itcpp.
DATA: docdata LIKE solisti1  OCCURS  10,
      objhead LIKE solisti1  OCCURS  1,
      objbin1 LIKE solisti1  OCCURS 10,
      objbin  LIKE solisti1  OCCURS 10.
DATA: listobject LIKE abaplist  OCCURS  1 .
DATA: doc_chng LIKE sodocchgi1.
DATA reclist    LIKE somlreci1  OCCURS  1 WITH HEADER LINE.
DATA mcount TYPE i.
DATA : v_werks TYPE werks_d.
DATA : v_text(70) TYPE c.
DATA: ltx LIKE t247-ltx.

DATA : usrid_long LIKE pa0105-usrid_long.
DATA : w_usrid_long TYPE pa0105-usrid_long.
DATA righe_attachment TYPE i.
DATA righe_testo TYPE i.
DATA tab_lines TYPE i.
DATA  BEGIN OF objpack OCCURS 0 .
        INCLUDE STRUCTURE  sopcklsti1.
DATA END OF objpack.

DATA BEGIN OF objtxt OCCURS 0.
        INCLUDE STRUCTURE solisti1.
DATA END OF objtxt.
DATA: v_msg(125) TYPE c.
DATA : it_zdsmter1 TYPE TABLE OF zdsmter,
       wa_zdsmter1 TYPE zdsmter.
DATA : msg       TYPE string,
       wa_d1(10) TYPE c,
       wa_d2(10) TYPE c.
DATA : p1(2)  TYPE c,
       p2(2)  TYPE c,
       y1(4)  TYPE c,
       y11(4) TYPE c.
DATA : cndt TYPE sy-datum.
***************************************

DATA : it_zdist_sale TYPE TABLE OF zdist_sale,
       wa_zdist_sale TYPE zdist_sale.

TYPES : BEGIN OF dist1,
          kunag TYPE zdist_sale-kunag,
          matnr TYPE zdist_sale-matnr,
          spart TYPE mara-spart,
          netwr TYPE zdist_sale-netwr,
          fkimg TYPE p,
        END OF dist1.

TYPES : BEGIN OF dist2,
          bzirk TYPE ysd_cus_div_dis-bzirk,
          matnr TYPE zdist_sale-matnr,
          spart TYPE mara-spart,
          netwr TYPE zdist_sale-netwr,
          fkimg TYPE p,
        END OF dist2.

DATA : it_dist1 TYPE TABLE OF dist1,
       wa_dist1 TYPE dist1,
       it_dist2 TYPE TABLE OF dist2,
       wa_dist2 TYPE dist2.
DATA: it_ysd_cus_div_dis1 TYPE TABLE OF ysd_cus_div_dis,
      wa_ysd_cus_div_dis1 TYPE ysd_cus_div_dis.
DATA : distval TYPE p DECIMALS 2,
       distqty TYPE p.
***********************************************
DATA: stdate1 TYPE sy-datum.

TYPES : BEGIN OF taz1,
          reg   TYPE zdsmter-zdsm,
          zm    TYPE zdsmter-zdsm,
          rm    TYPE zdsmter-zdsm,
          bzirk TYPE zdsmter-bzirk,
        END OF taz1.

TYPES : BEGIN OF taz2,
          reg   TYPE zdsmter-zdsm,
          zm    TYPE zdsmter-zdsm,
          rm    TYPE zdsmter-zdsm,
          bzirk TYPE zdsmter-bzirk,
          spart TYPE zdsmter-spart,
        END OF taz2.
DATA: it_taz1 TYPE TABLE OF taz1,
      wa_taz1 TYPE taz1,
      it_taz2 TYPE TABLE OF taz2,
      wa_taz2 TYPE taz2.

TYPES: BEGIN OF check,
         reg      TYPE zdsmter-bzirk,
         zm       TYPE zdsmter-bzirk,
         rm       TYPE zdsmter-bzirk,
         zonename TYPE zthr_heq_des-zz_hqdesc,
         seq      TYPE zoneseq-seq,
       END OF check.

TYPES: BEGIN OF check1,
         reg      TYPE zdsmter-bzirk,
         rm       TYPE zdsmter-bzirk,
         zonename TYPE zthr_heq_des-zz_hqdesc,
       END OF check1.

TYPES: BEGIN OF check2,
         reg      TYPE zdsmter-bzirk,
         rm       TYPE zdsmter-bzirk,
         zm       TYPE zdsmter-bzirk,
         zonename TYPE zthr_heq_des-zz_hqdesc,
       END OF check2.

DATA: it_check  TYPE TABLE OF check,
      wa_check  TYPE check,
      it_check1 TYPE TABLE OF check1,
      wa_check1 TYPE check1,
      it_check2 TYPE TABLE OF check2,
      wa_check2 TYPE check2.
TYPES: BEGIN OF gm1,
         gpernr TYPE pa0001-pernr,
         gm     TYPE zdsmter-bzirk,
         reg    TYPE zdsmter-bzirk,
       END OF gm1.

TYPES: BEGIN OF gm2,
         gpernr     TYPE pa0001-pernr,
         gm         TYPE zdsmter-bzirk,
         usrid_long TYPE pa0105-usrid_long,
       END OF gm2.

DATA: it_gm1 TYPE TABLE OF gm1,
      wa_gm1 TYPE gm1,
      it_gm2 TYPE TABLE OF gm2,
      wa_gm2 TYPE gm2.
DATA: zonename TYPE zthr_heq_des-zz_hqdesc.
DATA : v_fm TYPE rs38l_fnam.
DATA: format(10) TYPE c.
DATA : control  TYPE ssfctrlop.
DATA : w_ssfcompop TYPE ssfcompop.
DATA: regename TYPE pa0001-ename.
DATA: reghqdesc TYPE zthr_heq_des-zz_hqdesc.
DATA: regjoindt(7) TYPE c.
DATA: regshort TYPE hrp1000-short.

******************************************

DATA : w_return    TYPE ssfcrescl.
DATA: i_otf       TYPE itcoo    OCCURS 0 WITH HEADER LINE,
      i_tline     LIKE tline    OCCURS 0 WITH HEADER LINE,
      i_record    LIKE solisti1 OCCURS 0 WITH HEADER LINE,
      i_xstring   TYPE xstring,
* Objects to send mail.
      i_objpack   LIKE sopcklsti1 OCCURS 0 WITH HEADER LINE,
      i_objtxt    LIKE solisti1   OCCURS 0 WITH HEADER LINE,
      i_objbin    LIKE solix      OCCURS 0 WITH HEADER LINE,
      i_reclist   LIKE somlreci1  OCCURS 0 WITH HEADER LINE,
* Work Area declarations
      wa_objhead  TYPE soli_tab,
      w_ctrlop    TYPE ssfctrlop,
      w_compop    TYPE ssfcompop,
*      w_return    TYPE ssfcrescl,
      wa_buffer   TYPE string,
* Variables declarations
      v_form_name TYPE rs38l_fnam,
      v_len_in    LIKE sood-objlen.

DATA: in_mailid TYPE ad_smtpadr.
***************************************************

*SELECTION-SCREEN BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-001.
*PARAMETERS : RAD1 RADIOBUTTON GROUP R11 USER-COMMAND R2 DEFAULT 'X',
*             RAD2 RADIOBUTTON GROUP R11.
*SELECTION-SCREEN END OF BLOCK B3.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
*SELECT-OPTIONS : s_budat FOR vbrk-fkdat.
PARAMETERS : s_budat1 LIKE sy-datum,
             s_budat2 LIKE sy-datum.
SELECT-OPTIONS : org FOR zdsmter-zdsm MATCHCODE OBJECT zsr9_1.

PARAMETER : r1 RADIOBUTTON GROUP r1,
            r2 RADIOBUTTON GROUP r1,
            r7 RADIOBUTTON GROUP r1,
            r3 RADIOBUTTON GROUP r1,
            r4 RADIOBUTTON GROUP r1,
            r6 RADIOBUTTON GROUP r1,
              r8 RADIOBUTTON GROUP r1, "Summary layout
            r5 RADIOBUTTON GROUP r1,
            r9 RADIOBUTTON GROUP r1. "Summary email
PARAMETER : uemail(70) TYPE c.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-001.
PARAMETERS : dv1 RADIOBUTTON GROUP r2,
             dv2 RADIOBUTTON GROUP r2,
             dv4 RADIOBUTTON GROUP r2,
             dv3 RADIOBUTTON GROUP r2 DEFAULT 'X'.

*SELECT-OPTIONS : DV FOR MARA-SPART NO INTERVALS.
SELECTION-SCREEN END OF BLOCK b2.

INITIALIZATION.
  g_repid = sy-repid.

* Get the ZM job code


AT SELECTION-SCREEN.



  SELECT * FROM zdsmter INTO TABLE it_zdsmter1 WHERE zdsm IN org.

  LOOP AT it_zdsmter1 INTO wa_zdsmter1.
    AUTHORITY-CHECK OBJECT 'ZON1_1'
           ID 'ZDSM' FIELD wa_zdsmter1-zdsm.
    IF sy-subrc <> 0.
      CONCATENATE 'No authorization for Zone' wa_zdsmter1-zdsm INTO msg
      SEPARATED BY space.
      MESSAGE msg TYPE 'E'.
    ENDIF.
  ENDLOOP.
  IF r5 EQ 'X'.
    IF uemail EQ '                                                                     '.
      MESSAGE 'ENTER EMAIL ID' TYPE 'E'.
    ENDIF.
  ENDIF.




  p1 = s_budat1+4(2).
  p2 = s_budat2+4(2).

  y1 = s_budat1+0(4).
  y11 = s_budat2+0(4).

  IF p1 NE p2.
    MESSAGE ' ENTER DATES FROM SINGLE MONTH' TYPE 'E'.
  ENDIF.

  IF y1 NE y11.
    MESSAGE ' ENTER DATES FROM SINGLE MONTH' TYPE 'E'.
  ENDIF.

AT SELECTION-SCREEN OUTPUT.
  s_budat1 = sy-datum.
  s_budat1+6(2) = '01'.

  s_budat2 = sy-datum.

*  IF RAD1 EQ 'X'.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*R1*'.
*        SCREEN-ACTIVE = 1.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*R2*'.
*        SCREEN-ACTIVE = 1.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*R3*'.
*        SCREEN-ACTIVE = 1.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*R4*'.
*        SCREEN-ACTIVE = 1.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*R5*'.
*        SCREEN-ACTIVE = 1.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*R6*'.
*        SCREEN-ACTIVE = 1.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*R7*'.
*        SCREEN-ACTIVE = 1.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*R8*'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*R9*'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*  ELSE.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*R1*'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*R2*'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*R3*'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*R4*'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*R5*'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*R6*'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*R7*'.
*        SCREEN-ACTIVE = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*R8*'.
*        SCREEN-ACTIVE = 1.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME CP '*R9*'.
*        SCREEN-ACTIVE = 1.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*
*  ENDIF.


START-OF-SELECTION.
*  IF RAD2 EQ 'X'.
*    R1 = SPACE.
*  ENDIF.
* Amended by MN on 27.04.2024 (GE replaced with GT)
  IF r9 EQ 'X'.
    IF s_budat2+6(2) GT '27'.
      EXIT.
    ENDIF.
  ENDIF.

  month = s_budat1+4(2).
  year = s_budat1+0(4).

  IF month LT 4.
    year1 = year - 1.
  ELSE.
    year1 = year.
  ENDIF.

  SELECT * FROM zdsmter INTO TABLE it_zdsmter WHERE zmonth EQ month AND zyear EQ year .
*    AND zdsm in org.
  IF sy-subrc NE 0.
    EXIT.
  ENDIF.

******************old logic ***********
*  loop at it_zdsmter into wa_zdsmter where zdsm+0(2) cs 'D-' and bzirk+0(2) cs 'R-' and zdsm in org.
*    wa_tac1-reg = wa_zdsmter-zdsm.
*    wa_tac1-rm = wa_zdsmter-bzirk.
*    collect wa_tac1 into it_tac1.
*    clear wa_tac1.
*  endloop.
*
*  loop at it_tac1 into wa_tac1.
*    wa_tab1-reg = wa_tac1-reg.
*    wa_tab1-rm = wa_tac1-rm.
*    read table it_zdsmter into wa_zdsmter with key zmonth = month zyear = year bzirk = wa_tac1-rm zdsm+0(2) = 'Z-'.
*    if sy-subrc eq 0.
*      wa_tab1-zm = wa_zdsmter-zdsm.
*    endif.
*    collect wa_tab1 into it_tab1.
*    clear wa_tab1.
*  endloop.
*
*  loop at it_tab1 into wa_tab1.
*    loop at it_zdsmter into wa_zdsmter where zdsm eq wa_tab1-rm.
*      wa_tac2-reg = wa_tab1-reg.
*      wa_tac2-rm = wa_tab1-rm.
*      wa_tac2-zm = wa_tab1-zm.
*      wa_tac2-bzirk = wa_zdsmter-bzirk.
*      wa_tac2-spart = wa_zdsmter-spart.
*      collect wa_tac2 into it_tac2.
*      clear wa_tac2.
*    endloop.
*  endloop.
**  uline.
**************new logic************
  stdate1+6(2) = '01'.
  stdate1+4(2) = s_budat1+4(2).
  stdate1+0(4) = s_budat1+0(4).

  LOOP AT it_zdsmter INTO wa_zdsmter WHERE zdsm+0(2) CS 'D-' AND bzirk+0(2) CS 'Z-' AND zdsm IN org.
    SELECT SINGLE * FROM yterrallc WHERE bzirk EQ wa_zdsmter-zdsm AND endda GE stdate1.
    IF sy-subrc EQ 0.
      wa_tac1-reg = wa_zdsmter-zdsm.
    ENDIF.
    SELECT SINGLE * FROM yterrallc WHERE bzirk EQ wa_zdsmter-bzirk AND endda GE stdate1.
    IF sy-subrc EQ 0.
      wa_tac1-zm = wa_zdsmter-bzirk.
    ENDIF.
    COLLECT wa_tac1 INTO it_tac1.
    CLEAR wa_tac1.
  ENDLOOP.

  LOOP AT it_tac1 INTO wa_tac1.
*    WRITE : / 'A',WA_TAC1-REG,WA_TAC1-ZM.

    LOOP AT it_zdsmter INTO wa_zdsmter WHERE zdsm EQ wa_tac1-zm AND bzirk+0(2) EQ 'R-'.
      SELECT SINGLE * FROM yterrallc WHERE bzirk EQ wa_zdsmter-bzirk AND endda GE stdate1.
      IF sy-subrc EQ 0.
        wa_taz1-reg = wa_tac1-reg.
        wa_taz1-zm = wa_tac1-zm.
        wa_taz1-rm = wa_zdsmter-bzirk.
        COLLECT wa_taz1 INTO it_taz1.
        CLEAR wa_taz1.
      ENDIF.
    ENDLOOP.
  ENDLOOP.

  LOOP AT it_tac1 INTO wa_tac1.
*    WRITE : / 'A',WA_TAC1-REG,WA_TAC1-ZM.

    READ TABLE it_taz1 INTO wa_taz1 WITH KEY zm = wa_tac1-zm.
    IF sy-subrc EQ 4.
      wa_taz1-reg = wa_tac1-reg.
      wa_taz1-zm = wa_tac1-zm.
      wa_taz1-rm = space.
      COLLECT wa_taz1 INTO it_taz1.
      CLEAR wa_taz1.
    ENDIF.
  ENDLOOP.

  LOOP AT it_zdsmter INTO wa_zdsmter WHERE zdsm+0(2) CS 'D-' AND bzirk+0(2) CS 'R-' AND zdsm IN org.
    READ TABLE it_taz1 INTO wa_taz1 WITH KEY rm = wa_zdsmter-bzirk.
    IF sy-subrc EQ 4.
      SELECT SINGLE * FROM yterrallc WHERE bzirk EQ wa_zdsmter-zdsm AND endda GE stdate1.
      IF sy-subrc EQ 0.
        wa_taz1-reg = wa_zdsmter-zdsm.
      ENDIF.
      wa_taz1-zm = space.
      SELECT SINGLE * FROM yterrallc WHERE bzirk EQ wa_zdsmter-bzirk AND endda GE stdate1.
      IF sy-subrc EQ 0.
        wa_taz1-rm = wa_zdsmter-bzirk.
      ENDIF.
      COLLECT wa_taz1 INTO it_taz1.
      CLEAR wa_taz1.
    ENDIF.
  ENDLOOP.
  SORT it_taz1 BY reg zm rm.

*  LOOP AT IT_TAZ1 INTO WA_TAZ1.
*    WRITE : /'1A', WA_TAZ1-REG,WA_TAZ1-ZM,WA_TAZ1-RM.
*  ENDLOOP.


  LOOP AT it_taz1 INTO wa_taz1.
*    WRITE : /'1A', WA_TAC2-REG,WA_TAC2-ZM,WA_TAC2-RM.
    LOOP AT it_zdsmter INTO wa_zdsmter WHERE zdsm EQ wa_taz1-rm.
      SELECT SINGLE * FROM yterrallc WHERE bzirk EQ wa_zdsmter-bzirk AND spart EQ wa_zdsmter-spart AND endda GE stdate1.
      IF sy-subrc EQ 0.
        wa_taz2-reg = wa_taz1-reg.
        wa_taz2-zm = wa_taz1-zm.
        wa_taz2-rm = wa_taz1-rm.
        wa_taz2-bzirk = wa_zdsmter-bzirk.
        wa_taz2-spart = wa_zdsmter-spart.
        COLLECT wa_taz2 INTO it_taz2.
        CLEAR wa_taz2.
      ENDIF.
    ENDLOOP.
  ENDLOOP.

  LOOP AT it_taz1 INTO wa_taz1.
*    WRITE : /'1A', WA_TAC2-REG,WA_TAC2-ZM,WA_TAC2-RM.
    LOOP AT it_zdsmter INTO wa_zdsmter WHERE zdsm EQ wa_taz1-zm.
      IF wa_zdsmter-bzirk+0(2) NE 'R-'.
        SELECT SINGLE * FROM yterrallc WHERE bzirk EQ wa_zdsmter-bzirk AND spart EQ wa_zdsmter-spart AND endda GE stdate1.
        IF sy-subrc EQ 0.
          wa_taz2-reg = wa_taz1-reg.
          wa_taz2-zm = wa_taz1-zm.
          wa_taz2-rm = wa_taz1-rm.
          wa_taz2-bzirk = wa_zdsmter-bzirk.
          wa_taz2-spart = wa_zdsmter-spart.
          COLLECT wa_taz2 INTO it_taz2.
          CLEAR wa_taz2.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDLOOP.


  LOOP AT it_taz2 INTO wa_taz2.
*    WRITE : /'1B', WA_TAZ2-REG,WA_TAZ2-ZM,WA_TAZ2-RM,WA_TAZ2-BZIRK,WA_TAZ2-SPART.
    wa_tac2-reg = wa_taz2-reg.
    wa_tac2-zm = wa_taz2-zm.
    wa_tac2-rm = wa_taz2-rm.
    wa_tac2-bzirk = wa_taz2-bzirk.
    wa_tac2-spart = wa_taz2-spart.
    COLLECT wa_tac2 INTO it_tac2.
    CLEAR wa_tac2.
  ENDLOOP.

****************************************

*  LOOP at it_tac2 INTO wa_tac2.
*    WRITE : / 'reg',wa_tac2-reg,'zm',wa_tac2-zm,'rm',wa_tac2-rm,'bzirk',wa_tac2-bzirk,'div',wa_tac2-spart.
*  ENDLOOP.

  IF it_tac2 IS NOT INITIAL.
    SELECT * FROM ysd_cus_div_dis INTO TABLE it_ysd_cus_div_dis FOR ALL ENTRIES IN it_tac2 WHERE spart EQ it_tac2-spart
    AND bzirk EQ it_tac2-bzirk  AND begda LE s_budat1 AND endda GE s_budat2.
  ENDIF.
  SORT it_ysd_cus_div_dis BY kunnr.
  LOOP AT it_ysd_cus_div_dis INTO wa_ysd_cus_div_dis.
*  WRITE : / 'a',wa_ysd_cus_div_dis-bzirk,wa_ysd_cus_div_dis-kunnr,wa_ysd_cus_div_dis-spart,wa_ysd_cus_div_dis-percnt.
    wa_tac3-bzirk = wa_ysd_cus_div_dis-bzirk.
    wa_tac3-spart = wa_ysd_cus_div_dis-spart.
    wa_tac3-kunnr = wa_ysd_cus_div_dis-kunnr.
    wa_tac3-percnt = wa_ysd_cus_div_dis-percnt.
    COLLECT wa_tac3 INTO it_tac3.
    CLEAR wa_tac3.
  ENDLOOP.
  SORT it_tac3 BY bzirk spart.
  LOOP AT it_tac3 INTO wa_tac3.
*    WRITE : / 'kk',wa_tac3-bzirk,wa_tac3-spart,wa_tac3-kunnr,wa_tac3-percnt.
    wa_tac4-kunnr = wa_tac3-kunnr.
    COLLECT wa_tac4 INTO it_tac4.
    CLEAR wa_tac4.
  ENDLOOP.
  SORT it_tac4 BY  kunnr.
  DELETE ADJACENT DUPLICATES FROM it_tac4.

*******************************
*  SELECT * FROM YTERRALLC INTO TABLE IT_YTERRALLC_N WHERE ENDDA GE SY-DATUM.
  PERFORM sale.
  PERFORM cn.
  PERFORM nep.
  PERFORM summ.





*&---------------------------------------------------------------------*
*&      Form  SALE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM sale.

*  if it_tac4 IS NOT INITIAL.
*    select * from vbrk into table it_vbrk FOR ALL ENTRIES IN it_tac4  where fkdat in s_budat and fkart in ('ZBDF','ZCDF')
*       and kunag eq it_tac4-kunnr AND fksto ne 'X'.
*    if sy-subrc eq 0.
*      select * from vbrp into table it_vbrp for all entries in it_vbrk where  vbeln = it_vbrk-vbeln and fkimg ne 0
*        AND pstyv eq 'ZAN'.
*    endif.
*  endif.

  SELECT * FROM vbrk INTO TABLE it_vbrk WHERE fkdat GE s_budat1 AND fkdat LE s_budat2 AND fkart IN ('ZBDF','ZCDF')
  AND fksto NE 'X'.
  IF sy-subrc EQ 0.
    SELECT * FROM vbrp INTO TABLE it_vbrp FOR ALL ENTRIES IN it_vbrk WHERE  vbeln = it_vbrk-vbeln AND fkimg NE 0
    AND pstyv EQ 'ZAN'.
  ENDIF.


  IF it_vbrk IS NOT INITIAL.
    SELECT knumv kposn kschl kwert  FROM prcd_elements INTO TABLE it_konv FOR ALL ENTRIES IN it_vbrk WHERE knumv = it_vbrk-knumv
    AND kschl IN ('ZPED', 'ZEX4','ZGRP').
  ENDIF.
  SORT it_konv BY knumv kposn kschl.
  SORT it_vbrp BY vbeln.
  DELETE it_vbrp WHERE fkimg EQ 0.

  LOOP AT it_vbrp INTO wa_vbrp FROM sy-tabix.
    READ TABLE it_vbrk INTO wa_vbrk WITH KEY vbeln = wa_vbrp-vbeln.
    IF sy-subrc EQ 0.
      READ TABLE it_tac4 INTO wa_tac4 WITH KEY kunnr = wa_vbrk-kunrg.
      IF sy-subrc EQ 0.
        IF wa_vbrp-pstyv = 'ZAN'.
          wa_tas1-vbeln = wa_vbrp-vbeln.
          wa_tas1-fkimg_s = wa_vbrp-fkimg.
          wa_tas1-matnr = wa_vbrp-matnr.
          wa_tas1-arktx = wa_vbrp-arktx.
          wa_tas1-charg = wa_vbrp-charg.
          wa_tas1-werks = wa_vbrp-werks.
          wa_tas1-lgort = wa_vbrp-lgort.
          wa_tas1-fkdat = wa_vbrk-fkdat.
          wa_tas1-kunag = wa_vbrk-kunag.
          SELECT SINGLE * FROM mara WHERE matnr EQ wa_vbrp-matnr.
          IF sy-subrc EQ 0.
            wa_tas1-spart = mara-spart.
            IF mara-spart EQ '50'.
              READ TABLE it_konv INTO wa_konv WITH KEY knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZEX4' BINARY SEARCH.
              IF sy-subrc EQ 0.
                wa_tas1-bed_rate = wa_konv-kwert.
              ENDIF.
              READ TABLE it_konv INTO wa_konv WITH KEY knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZPED' BINARY SEARCH.
              IF sy-subrc EQ 0.
                wa_tas1-bzped_rate = wa_konv-kwert.
              ENDIF.
              READ TABLE it_konv INTO wa_konv WITH KEY knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZGRP' BINARY SEARCH.
              IF sy-subrc EQ 0.
                wa_tas1-bzgrp_rate = wa_konv-kwert.
              ENDIF.
            ELSEIF mara-spart EQ '60'.
              READ TABLE it_konv INTO wa_konv WITH KEY knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZEX4' BINARY SEARCH.
              IF sy-subrc EQ 0.
                wa_tas1-xed_rate = wa_konv-kwert.
              ENDIF.
              READ TABLE it_konv INTO wa_konv WITH KEY knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZPED' BINARY SEARCH.
              IF sy-subrc EQ 0.
                wa_tas1-xzped_rate = wa_konv-kwert.
              ENDIF.
              READ TABLE it_konv INTO wa_konv WITH KEY knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZGRP' BINARY SEARCH.
              IF sy-subrc EQ 0.
                wa_tas1-xzgrp_rate = wa_konv-kwert.
              ENDIF.

            ELSEIF mara-spart EQ '70'.
              READ TABLE it_konv INTO wa_konv WITH KEY knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZEX4' BINARY SEARCH.
              IF sy-subrc EQ 0.
                wa_tas1-led_rate = wa_konv-kwert.
              ENDIF.
              READ TABLE it_konv INTO wa_konv WITH KEY knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZPED' BINARY SEARCH.
              IF sy-subrc EQ 0.
                wa_tas1-lzped_rate = wa_konv-kwert.
              ENDIF.
              READ TABLE it_konv INTO wa_konv WITH KEY knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZGRP' BINARY SEARCH.
              IF sy-subrc EQ 0.
                wa_tas1-lzgrp_rate = wa_konv-kwert.
              ENDIF.
            ENDIF.
          ENDIF.
          COLLECT wa_tas1 INTO it_tas1.
          CLEAR wa_tas1.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.




  LOOP AT it_tas1 INTO wa_tas1.
    CLEAR : bpts,xpts,lpts,val.
    val = wa_tas1-bzgrp_rate + wa_tas1-xzgrp_rate + wa_tas1-lzgrp_rate.
    IF val GT 0.
      bpts = wa_tas1-bzgrp_rate.
      xpts = wa_tas1-xzgrp_rate.
      lpts = wa_tas1-lzgrp_rate.
    ELSE.
      bpts = wa_tas1-bzped_rate + wa_tas1-bed_rate.
      xpts = wa_tas1-xzped_rate + wa_tas1-xed_rate.
      lpts = wa_tas1-lzped_rate + wa_tas1-led_rate.
    ENDIF.
    wa_tas2-bpts = bpts.
    wa_tas2-xpts = xpts.
    wa_tas2-lpts = lpts.
    wa_tas2-kunag = wa_tas1-kunag.
    wa_tas2-spart = wa_tas1-spart.
    COLLECT wa_tas2 INTO it_tas2.
    CLEAR wa_tas2.
  ENDLOOP.

  SORT it_tas2 BY kunag.


  LOOP AT it_tac3 INTO wa_tac3.
    CLEAR : bval, xval, lval.
*  WRITE : / 'terr', wa_tac3-bzirk,wa_tac3-spart,wa_tac3-kunnr,wa_tac3-percnt.
    wa_tas3-bzirk = wa_tac3-bzirk.
    wa_tas3-spart = wa_tac3-spart.
    wa_tas3-kunnr = wa_tac3-kunnr.
*  wa_tab3-percnt = wa_tac3-percnt.

    READ TABLE it_tas2 INTO wa_tas2 WITH KEY kunag = wa_tac3-kunnr spart = wa_tac3-spart.
    IF sy-subrc EQ 0.
      bval = wa_tas2-bpts * ( wa_tac3-percnt / 100 ).
      xval = wa_tas2-xpts * ( wa_tac3-percnt / 100 ).
      lval = wa_tas2-lpts * ( wa_tac3-percnt / 100 ).
*    WRITE : 'sale',bval,xval.
      wa_tas3-bval = bval.
      wa_tas3-xval = xval.
      wa_tas3-lval = lval.
    ENDIF.
    COLLECT wa_tas3 INTO it_tas3.
    CLEAR wa_tas3.
  ENDLOOP.
  SORT it_tas3 BY bzirk spart kunnr.
  LOOP AT it_tas3 INTO wa_tas3.
    CLEAR : s_val.
*    WRITE : / 'SALE', WA_TAS3-BZIRK,WA_TAS3-SPART,WA_TAS3-KUNNR,WA_TAS3-BVAL,WA_TAS3-XVAL.
    wa_tas4-bzirk = wa_tas3-bzirk.
    wa_tas4-spart = wa_tas3-spart.
    s_val = wa_tas3-bval + wa_tas3-xval +  wa_tas3-lval.
    wa_tas4-sval = s_val.
    COLLECT wa_tas4 INTO it_tas4.
    CLEAR wa_tas4.
  ENDLOOP.


  PERFORM distsale.

ENDFORM.                    "SALE


*&---------------------------------------------------------------------*
*&      Form  CN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM cn.

  cndt+0(4) = '2019'.
  cndt+6(2) = '01'.
  cndt+4(2) = '04'.

**************TOTAL CREDIT NOTE  *************
*  if it_tac4 IS NOT INITIAL.
*    select * from vbrk into table it_vbrk1 FOR ALL ENTRIES IN IT_TAC4 where fkart in
*      ('ZG2','ZBD','ZRS','ZG3','RE','ZC04','ZQC','ZRRE','ZRRS','ZC08' ) AND fkdat IN S_BUDAT and
*      KUNAG EQ IT_TAC4-KUNNR AND fksto ne 'X' .
*    if sy-subrc eq 0.
*      select * from vbrp into table it_vbrp1 for all entries in it_vbrk1 where  vbeln = it_vbrk1-vbeln .
*    endif.
*  ENDIF.

  SELECT * FROM vbrk INTO TABLE it_vbrk1 WHERE fkart IN
  ('ZG2','ZBD','ZRS','ZG3','RE','ZC04','ZQC','ZRRE','ZRRS','ZC08' ) AND fkdat GE s_budat1 AND fkdat LE s_budat2 AND fksto NE 'X' .
  IF sy-subrc EQ 0.
    SELECT * FROM vbrp INTO TABLE it_vbrp1 FOR ALL ENTRIES IN it_vbrk1 WHERE  vbeln = it_vbrk1-vbeln .
  ENDIF.
  IF it_vbrk1 IS NOT INITIAL.
    SELECT knumv kposn kschl kwert FROM prcd_elements INTO TABLE it_konv1 FOR ALL ENTRIES IN it_vbrk1 WHERE knumv = it_vbrk1-knumv
    AND kschl IN ('ZPED','ZSPD','ZGRP').
  ENDIF.
  SORT it_konv1 BY knumv kposn kschl.

  LOOP AT it_vbrp1 INTO wa_vbrp1.
    CLEAR : zspd, zgrp.
    READ TABLE it_vbrk1 INTO wa_vbrk1 WITH KEY vbeln = wa_vbrp1-vbeln.
    IF sy-subrc EQ 0.
      READ TABLE it_tac4 INTO wa_tac4 WITH KEY kunnr = wa_vbrk1-kunag.
      IF sy-subrc EQ 0.
        wa_tag1-vbeln = wa_vbrk1-vbeln.
        wa_tag1-fkdat = wa_vbrk1-fkdat.
        wa_tag1-fkart = wa_vbrk1-fkart.
        wa_tag1-kunag = wa_vbrk1-kunag.
        SELECT SINGLE * FROM mara WHERE matnr EQ wa_vbrp1-matnr.
        IF sy-subrc EQ 0.
          wa_tag1-spart = mara-spart.
****************************************************
          IF s_budat1 LT cndt.
            IF mara-spart EQ '50'.
              wa_tag1-bnetwr = wa_vbrp1-netwr.
            ELSEIF mara-spart EQ '60'.
              wa_tag1-xnetwr = wa_vbrp1-netwr.
            ELSEIF mara-spart EQ '70'.
              wa_tag1-lnetwr = wa_vbrp1-netwr.
            ENDIF.
          ELSE.
            IF wa_vbrk1-fkart EQ 'ZG2' OR wa_vbrk1-fkart EQ 'ZBD'.
              READ TABLE it_konv1 INTO wa_konv1 WITH KEY knumv = wa_vbrk1-knumv kposn = wa_vbrp1-posnr kschl = 'ZSPD' BINARY SEARCH.
              IF sy-subrc EQ 0.
                zspd = wa_konv1-kwert.
              ENDIF.
              READ TABLE it_konv1 INTO wa_konv1 WITH KEY knumv = wa_vbrk1-knumv kposn = wa_vbrp1-posnr kschl = 'ZGRP' BINARY SEARCH.
              IF sy-subrc EQ 0.
                zgrp = wa_konv1-kwert.
              ENDIF.
              IF mara-spart EQ '50'.
                wa_tag1-bnetwr = zgrp - zspd.
              ELSEIF mara-spart EQ '60'.
                wa_tag1-xnetwr = zgrp - zspd.
              ELSEIF mara-spart EQ '70'.
                wa_tag1-lnetwr = zgrp - zspd.
              ENDIF.
            ELSE.
              IF mara-spart EQ '50'.
                wa_tag1-bnetwr = wa_vbrp1-netwr.
              ELSEIF mara-spart EQ '60'.
                wa_tag1-xnetwr = wa_vbrp1-netwr.
              ELSEIF mara-spart EQ '70'.
                wa_tag1-lnetwr = wa_vbrp1-netwr.
              ENDIF.
              IF wa_vbrk1-fkart EQ 'ZC08'.
                wa_tag1-bnetwr = 0.
                wa_tag1-xnetwr = 0.
              ENDIF.
            ENDIF.
          ENDIF.
**************************************
        ENDIF.
        COLLECT wa_tag1 INTO it_tag1.
        CLEAR wa_tag1.
      ENDIF.
    ENDIF.
  ENDLOOP.

  SORT it_tag1 BY kunag.
  LOOP AT it_tag1 INTO wa_tag1 .
    CLEAR : bcn,xcn,lcn,cn_val.
*    READ TABLE IT_TAC3 INTO WA_TAC3 WITH KEY KUNNR = WA_TAG1-KUNAG SPART = WA_TAG1-SPART .
    LOOP AT it_tac3 INTO wa_tac3 WHERE kunnr = wa_tag1-kunag AND spart = wa_tag1-spart .
      CLEAR : bcn,xcn,cn_val.
      bcn = wa_tag1-bnetwr * (  wa_tac3-percnt / 100 ).
      xcn = wa_tag1-xnetwr * (  wa_tac3-percnt / 100 ).
      lcn = wa_tag1-lnetwr * (  wa_tac3-percnt / 100 ).
      cn_val = bcn + xcn + lcn.
      wa_tag2-cn_val = cn_val.
      wa_tag2-kunag = wa_tag1-kunag.
      wa_tag2-fkart = wa_tag1-fkart.
      wa_tag2-bzirk = wa_tac3-bzirk.
      wa_tag2-spart = wa_tac3-spart.
      COLLECT wa_tag2 INTO it_tag2 .
      CLEAR wa_tag2.
    ENDLOOP.
  ENDLOOP.
  SORT it_tag2 BY kunag spart.

  m2 = s_budat1+6(2).
  y2 = s_budat1+0(4).
  date1 = s_budat1.
  date1+6(2) = '15'.

*  WRITE : / 'month, year',m2, y2, date1.
  IF it_tag2 IS NOT INITIAL.
    SELECT * FROM yterrallc INTO TABLE it_yterrallc FOR ALL ENTRIES IN it_tag2 WHERE spart EQ it_tag2-spart AND bzirk EQ it_tag2-bzirk AND
    begda LE s_budat1 AND endda GT s_budat2 AND plans NE '99999999'..
    IF sy-subrc EQ 0.
      SELECT * FROM pa0001 INTO TABLE it_pa0001 FOR ALL ENTRIES IN it_yterrallc WHERE plans EQ it_yterrallc-plans AND begda LE date1 AND
      endda GE s_budat2.
    ENDIF.
  ENDIF.
  SORT it_pa0001.
  LOOP AT it_yterrallc INTO wa_yterrallc.
*  LOOP at it_pa0001 INTO wa_pa0001.
    READ TABLE it_pa0001 INTO wa_pa0001 WITH KEY plans = wa_yterrallc-plans.
    IF sy-subrc EQ 0.
*      WRITE : / 'qty',wa_yterrallc-bzirk,wa_pa0001-plans,wa_pa0001-pernr,wa_pa0001-begda,wa_pa0001-endda.
      wa_ter1-bzirk = wa_yterrallc-bzirk.
      wa_ter1-spart = wa_yterrallc-spart.
      wa_ter1-plans = wa_pa0001-plans.
      wa_ter1-pernr = wa_pa0001-pernr.
      wa_ter1-begda = wa_pa0001-begda.
      wa_ter1-endda = wa_pa0001-endda.
      COLLECT wa_ter1 INTO it_ter1.
      CLEAR wa_ter1.
    ENDIF.
  ENDLOOP.

  LOOP AT it_tag2 INTO wa_tag2 WHERE fkart EQ 'ZG2'.
*    WRITE : / wa_tag2-kunag,wa_tag2-bzirk,wa_tag2-spart,wa_tag2-cn_val1,wa_tag2-cn_val2,wa_tag2-cn_val3,wa_tag2-cn_val4.
    wa_tag3-kunag = wa_tag2-kunag.
    wa_tag3-bzirk = wa_tag2-bzirk.
    wa_tag3-spart = wa_tag2-spart.
    wa_tag3-cn_val = wa_tag2-cn_val.
    COLLECT wa_tag3 INTO it_tag3.
    CLEAR wa_tag3.
  ENDLOOP.

  SORT it_ter1 BY bzirk endda.
*  LOOP at it_ter1 INTO wa_ter1.
*    WRITE : / 'qty',wa_ter1-bzirk,wa_ter1-plans,wa_ter1-pernr,wa_ter1-begda,wa_ter1-endda.
*  ENDLOOP.

  SORT it_tag3 BY bzirk spart.
  LOOP AT it_tag3 INTO wa_tag3.
*    WRITE : / 'cn',wa_tag3-bzirk,wa_tag3-spart,wa_tag3-kunag,wa_tag3-cn_val.
    CLEAR : acn_val,stay,stay1,stay2,stay3,days,a1,lday,sday,join_dt.
    READ TABLE it_ter1 INTO wa_ter1 WITH KEY bzirk = wa_tag3-bzirk spart = wa_tag3-spart.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM pa0302 WHERE pernr EQ wa_ter1-pernr AND massn EQ '01'.
      IF sy-subrc EQ 0.
        join_dt = pa0302-begda.
        a1 = pa0302-begda+6(2).
        IF a1 GE 15.
          CALL FUNCTION 'HR_JP_MONTH_BEGIN_END_DATE'
            EXPORTING
              iv_date           = pa0302-begda
            IMPORTING
*             EV_MONTH_BEGIN_DATE       =
              ev_month_end_date = lday.
*          WRITE : LDAY.
          sday = lday + 1.
*          WRITE : SDAY.
          pa0302-begda = sday.
        ELSE.
          pa0302-begda+6(2) = '01'.
        ENDIF.

        CALL FUNCTION 'HR_SGPBS_YRS_MTHS_DAYS'
          EXPORTING
            beg_da        = pa0302-begda
            end_da        = s_budat1
          IMPORTING
            no_day        = stay
            no_month      = stay1
            no_year       = stay2
            no_cal_day    = stay3
          EXCEPTIONS
            dateint_error = 1
            OTHERS        = 2.
        IF sy-subrc <> 0.
        ENDIF.
        days = stay3.
*********************************************
        IF s_budat1 GE '20210401'.   "27.4.21
          IF days LE 270.
            acn_val = wa_tag3-cn_val.
            wa_tag4-bzirk = wa_tag3-bzirk.
            wa_tag4-spart = wa_tag3-spart.
            wa_tag4-cn_val = acn_val.
            COLLECT wa_tag4 INTO it_tag4.
            CLEAR wa_tag4.
          ELSE.
            SELECT SINGLE * FROM ysd_inv_per WHERE fkart EQ 'ZG2' AND begda LE s_budat1 AND endda GE s_budat2.
            IF sy-subrc EQ 0.
              acn_val = wa_tag3-cn_val * ( ysd_inv_per-percnt / 100 ).
              wa_tag4-bzirk = wa_tag3-bzirk.
              wa_tag4-spart = wa_tag3-spart.
              wa_tag4-cn_val = acn_val.
              COLLECT wa_tag4 INTO it_tag4.
              CLEAR wa_tag4.
            ENDIF.
          ENDIF.
        ELSE.
          IF days LE 180.
            acn_val = wa_tag3-cn_val.
            wa_tag4-bzirk = wa_tag3-bzirk.
            wa_tag4-spart = wa_tag3-spart.
            wa_tag4-cn_val = acn_val.
            COLLECT wa_tag4 INTO it_tag4.
            CLEAR wa_tag4.
          ELSE.
            SELECT SINGLE * FROM ysd_inv_per WHERE fkart EQ 'ZG2' AND begda LE s_budat1 AND endda GE s_budat2.
            IF sy-subrc EQ 0.
              acn_val = wa_tag3-cn_val * ( ysd_inv_per-percnt / 100 ).
              wa_tag4-bzirk = wa_tag3-bzirk.
              wa_tag4-spart = wa_tag3-spart.
              wa_tag4-cn_val = acn_val.
              COLLECT wa_tag4 INTO it_tag4.
              CLEAR wa_tag4.
            ENDIF.
          ENDIF.
        ENDIF.
*************************************
      ENDIF.
    ELSE.
      SELECT SINGLE * FROM ysd_inv_per WHERE fkart EQ 'ZG2' AND begda LE s_budat1 AND endda GE s_budat2.
      IF sy-subrc EQ 0.
        acn_val = wa_tag3-cn_val * ( ysd_inv_per-percnt / 100 ).
        wa_tag4-bzirk = wa_tag3-bzirk.
        wa_tag4-spart = wa_tag3-spart.
        wa_tag4-cn_val = acn_val.
        COLLECT wa_tag4 INTO it_tag4.
        CLEAR wa_tag4.
      ENDIF.
    ENDIF.

  ENDLOOP.

  LOOP AT it_tag4 INTO wa_tag4.
*    WRITE : / 'ZG2 CN VAL ',WA_TAG4-BZIRK,wa_tag4-spart,WA_TAG4-CN_VAL.
    wa_zcn1-bzirk = wa_tag4-bzirk.
    wa_zcn1-spart = wa_tag4-spart.
    wa_zcn1-acn_val = wa_tag4-cn_val.
    COLLECT wa_zcn1 INTO it_zcn1.
    CLEAR wa_zcn1.
  ENDLOOP.

  LOOP AT it_tag2 INTO wa_tag2 WHERE fkart NE 'ZG2'.
*    WRITE : / wa_tag2-kunag,wa_tag2-bzirk,wa_tag2-spart,wa_tag2-cn_val1,wa_tag2-cn_val2,wa_tag2-cn_val3,wa_tag2-cn_val4.
    wa_oth1-kunag = wa_tag2-kunag.
    wa_oth1-fkart = wa_tag2-fkart.
    wa_oth1-bzirk = wa_tag2-bzirk.
    wa_oth1-spart = wa_tag2-spart.
    wa_oth1-cn_val = wa_tag2-cn_val.
    COLLECT wa_oth1 INTO it_oth1.
    CLEAR wa_oth1.
  ENDLOOP.

  LOOP AT it_oth1 INTO wa_oth1.
    CLEAR : acn_val.
    SELECT SINGLE * FROM ysd_inv_per WHERE fkart EQ wa_oth1-fkart AND begda LE s_budat1 AND endda GE s_budat2.
    IF sy-subrc EQ 0.
      acn_val = wa_oth1-cn_val * ( ysd_inv_per-percnt / 100 ).
      wa_oth2-bzirk = wa_oth1-bzirk.
      wa_oth2-spart = wa_oth1-spart.
      wa_oth2-cn_val = acn_val.
      COLLECT wa_oth2 INTO it_oth2.
      CLEAR wa_oth2.
    ENDIF.
  ENDLOOP.

  LOOP AT it_oth2 INTO wa_oth2.
*    WRITE : / 'OTH CN VAL ',WA_OTH2-BZIRK,wa_oth2-spart,WA_OTH2-CN_VAL.
    wa_zcn1-bzirk = wa_oth2-bzirk.
    wa_zcn1-spart = wa_oth2-spart.
    wa_zcn1-oth_val = wa_oth2-cn_val.
    COLLECT wa_zcn1 INTO it_zcn1.
    CLEAR wa_zcn1.
  ENDLOOP.
ENDFORM.                    "CN




*&---------------------------------------------------------------------*
*&      Form  NEP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM nep.
**************TOTAL CREDIT NOTE  *************
  CLEAR : week.
*  WRITE : / 'MONTH& YEAR',MONTH,YEAR,S_BUDAT-HIGH,S_BUDAT-HIGH+6(2).
  IF s_budat2+6(2) LE '07'.
*    WRITE : / 'FIRST WEEK'.
    week = '1'.
  ELSEIF s_budat2+6(2) LE '14'.
*    WRITE : / 'SECOND WEEK'.
    week = '2'.
  ELSEIF s_budat2+6(2) LE '21'.
*    WRITE : / 'THIRD WEEK'.
    week = '3'.
  ELSE.
*    WRITE : / 'FOURTH WEEK'.
    week = '4'.
  ENDIF.

  IF it_tac2 IS NOT INITIAL.
    SELECT * FROM yempval INTO TABLE it_yempval FOR ALL ENTRIES IN it_tac2 WHERE zyear EQ year AND mont EQ month AND week EQ week
    AND spart EQ it_tac2-spart AND bzirk EQ it_tac2-bzirk.
  ENDIF.

  LOOP AT it_yempval INTO wa_yempval.
*    WRITE : / WA_YEMPVAL-BZIRK,WA_YEMPVAL-SPART,WA_YEMPVAL-VALUE.
    wa_nep1-spart = wa_yempval-spart.
    wa_nep1-bzirk = wa_yempval-bzirk.
    wa_nep1-value = wa_yempval-value.
    COLLECT wa_nep1 INTO it_nep1.
    CLEAR wa_nep1.
  ENDLOOP.

  SORT it_nep1 BY bzirk spart.
*  LOOP AT IT_NEP1 INTO WA_NEP1.
**    WRITE : / WA_NEP1-BZIRK,WA_NEP1-SPART,WA_NEP1-VALUE.
*  ENDLOOP.
*  LOOP at it_tac2 INTO wa_tac2.
*    WRITE : /'text', wa_tac2-text,'reg',wa_tac2-reg,'zm',wa_tac2-zm,'rm',wa_tac2-rm,'bzirk',wa_tac2-bzirk,'div',wa_tac2-spart.
*
*  ENDLOOP.


ENDFORM.                    "nep

*&---------------------------------------------------------------------*
*&      Form  SUMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM summ.
*  ULINE .

  LOOP AT it_tac2 INTO wa_tac2.
*    WRITE : / '*', WA_TAC2-TEXT, WA_tac2-REG,WA_tac2-spart,WA_tac2-ZM,WA_tac2-RM,WA_tac2-BZIRK.
    wa_tac5-text = wa_tac2-text.
    wa_tac5-reg = wa_tac2-reg.
    wa_tac5-zm = wa_tac2-zm.
    wa_tac5-rm = wa_tac2-rm.
    wa_tac5-bzirk = wa_tac2-bzirk.
    wa_tac5-spart = wa_tac2-spart.
    READ TABLE it_tas4 INTO wa_tas4 WITH KEY spart = wa_tac2-spart bzirk = wa_tac2-bzirk.
    IF sy-subrc EQ 0.
*      WRITE : 'GROSS SALE',WA_TAS4-sval.
      wa_tac5-sval = wa_tas4-sval.
    ENDIF.
    READ TABLE it_nep1 INTO wa_nep1 WITH KEY spart = wa_tac2-spart bzirk = wa_tac2-bzirk.
    IF sy-subrc EQ 0.
*      WRITE : 'GROSS SALE',WA_TAS4-sval.
      wa_tac5-nepval = wa_nep1-value.
    ENDIF.

    READ TABLE it_zcn1 INTO wa_zcn1 WITH KEY spart = wa_tac2-spart bzirk = wa_tac2-bzirk.
    IF sy-subrc EQ 0.
*      WRITE : 'CN',wa_zcn1-acn_val,WA_ZCN1-OTH_VAL.
      wa_tac5-acn_val = wa_zcn1-acn_val.
      wa_tac5-oth_val = wa_zcn1-oth_val.
    ENDIF.
    COLLECT wa_tac5 INTO it_tac5.
    CLEAR wa_tac5.
  ENDLOOP.

  LOOP AT it_tac5 INTO wa_tac5.
    CLEAR : net.
*    WRITE : / '*', WA_TAC5-TEXT, WA_tac5-REG,WA_tac5-spart,WA_tac5-ZM,WA_tac5-RM,WA_tac5-BZIRK,WA_TAC5-sval,wa_TAC5-acn_val,WA_TAC5-OTH_VAL.
    net = wa_tac5-sval + wa_tac5-nepval - wa_tac5-acn_val - wa_tac5-oth_val.
*    WRITE : NET.
    wa_tac6-text = wa_tac5-text.
    wa_tac6-reg = wa_tac5-reg.
    SELECT SINGLE * FROM yterrallc WHERE bzirk EQ wa_tac5-reg AND begda LE s_budat1 AND endda GE s_budat2.
    IF sy-subrc EQ 0.
      wa_tae1-plans = yterrallc-plans.
      COLLECT wa_tae1 INTO it_tae1.
      CLEAR wa_tae1.
    ENDIF.
    wa_tac6-spart = wa_tac5-spart.
    wa_tac6-zm = wa_tac5-zm.
    wa_tac6-rm = wa_tac5-rm.
    wa_tac6-bzirk = wa_tac5-bzirk.
    wa_tac6-sval = wa_tac5-sval + wa_tac5-nepval.
    wa_tac6-acn_val = wa_tac5-acn_val.
    wa_tac6-oth_val = wa_tac5-oth_val.
    wa_tac6-net = net.

    SELECT SINGLE * FROM yterrallc WHERE spart EQ wa_tac5-spart AND bzirk EQ wa_tac5-bzirk AND begda LE s_budat1 AND endda GE s_budat2.
    IF sy-subrc EQ 0.
*      WRITE : YTERRALLC-PLANS.
      wa_tac6-plans = yterrallc-plans.
      SELECT SINGLE * FROM pa0001 WHERE plans EQ yterrallc-plans AND begda LE date1 AND endda GE s_budat2.
      IF sy-subrc EQ 0.
*        WRITE : PA0001-ENAME.
        wa_tap1-pernr = pa0001-pernr.
        COLLECT wa_tap1 INTO it_tap1.
        CLEAR wa_tap1.
        wa_tac6-ename = pa0001-ename.
        SELECT SINGLE * FROM zthr_heq_des WHERE zz_hqcode EQ pa0001-zz_hqcode.
        IF sy-subrc EQ 0.
*          WRITE : zthr_heq_des-zz_hqdesc.
          wa_tac6-zz_hqdesc = zthr_heq_des-zz_hqdesc.
        ENDIF.
*        select single * from hrp1000 where otype eq 'S' and objid eq PA0001-plans and begda le date1 and endda ge lday and langu eq 'EN'.
*        if sy-subrc eq 0..
**          WRITE : HRP1000-SHORT.
*          wa_tac6-short = HRP1000-SHORT.
*        endif.
        SELECT SINGLE * FROM zfsdes WHERE persk EQ pa0001-persk.
        IF sy-subrc EQ 0..
*          WRITE : HRP1000-SHORT.
          wa_tac6-short = zfsdes-short.
        ENDIF.
        SELECT SINGLE * FROM pa0302 WHERE pernr EQ pa0001-pernr AND massn EQ '01'.
        IF sy-subrc EQ 0.
*          WRITE : 'JOIN DT',PA0302-BEGDA.
          wa_tac6-begda = pa0302-begda.
        ENDIF.
      ELSE.
        SELECT SINGLE * FROM zdrphq WHERE bzirk EQ wa_tac5-bzirk.
        IF sy-subrc EQ 0.
          SELECT SINGLE * FROM zthr_heq_des WHERE zz_hqcode EQ zdrphq-zz_hqcode.
          IF sy-subrc EQ 0.
*          WRITE : zthr_heq_des-zz_hqdesc.
            wa_tac6-zz_hqdesc = zthr_heq_des-zz_hqdesc.
          ENDIF.
        ENDIF.


      ENDIF.
    ENDIF.
    COLLECT wa_tac6 INTO it_tac6.
    CLEAR wa_tac6.
  ENDLOOP.
  SORT it_tae1.
  DELETE ADJACENT DUPLICATES FROM it_tae1 COMPARING plans.
  IF it_tae1 IS NOT INITIAL.
    SELECT * FROM pa0001 INTO TABLE it_pa0001_2 FOR ALL ENTRIES IN it_tae1 WHERE plans = it_tae1-plans.
  ENDIF.
  SORT it_pa0001_2 DESCENDING BY endda.
  LOOP AT it_tac6 INTO wa_tac6 WHERE plans NE '00000000'.
*    WRITE : / WA_TAC6-TEXT, WA_tac6-REG,WA_tac6-spart,WA_tac6-ZM,WA_tac6-RM,WA_tac6-BZIRK,WA_TAC6-sval,wa_TAC6-acn_val,WA_TAC6-OTH_VAL,
*    wa_tac6-net, wa_tac6-PLANS,wa_tac6-ENAME,wa_tac6-zz_hqdesc,wa_tac6-SHORT,wa_tac6-BEGDA.

    wa_tac7-text = wa_tac6-text.
    wa_tac7-reg = wa_tac6-reg.
    wa_tac7-spart = wa_tac6-spart.
    wa_tac7-zm = wa_tac6-zm.
    wa_tac7-rm = wa_tac6-rm.
    wa_tac7-bzirk = wa_tac6-bzirk.
    wa_tac7-spart = wa_tac6-spart.
    wa_tac7-sval = wa_tac6-sval.
    wa_tac7-acn_val = wa_tac6-acn_val.
    wa_tac7-oth_val = wa_tac6-oth_val.
    wa_tac7-net = wa_tac6-net.
    wa_tac7-plans = wa_tac6-plans.
    wa_tac7-ename = wa_tac6-ename.
    wa_tac7-zz_hqdesc = wa_tac6-zz_hqdesc.
    wa_tac7-short = wa_tac6-short.
    wa_tac7-begda = wa_tac6-begda.

    SELECT SINGLE * FROM yterrallc WHERE spart EQ wa_tac6-spart AND bzirk EQ wa_tac6-rm AND begda LE s_budat1 AND endda GE s_budat2.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM pa0001 WHERE plans EQ yterrallc-plans AND begda LE date1 AND endda GE s_budat2.
      IF sy-subrc EQ 0.
*        WRITE : PA0001-ENAME.
        wa_tap1-pernr = pa0001-pernr.
        COLLECT wa_tap1 INTO it_tap1.
        CLEAR wa_tap1.
        wa_tac7-rename = pa0001-ename.
        wa_tac7-rpernr = pa0001-pernr.
        SELECT SINGLE * FROM pa0302 WHERE pernr EQ pa0001-pernr AND massn EQ '01'.
        IF sy-subrc EQ 0.
          wa_tac7-rbegda = pa0302-begda.
        ENDIF.
        SELECT SINGLE * FROM zfsdes WHERE persk EQ pa0001-persk.
        IF sy-subrc EQ 0..
*          WRITE : HRP1000-SHORT.
          wa_tac7-rshort = zfsdes-short.
        ENDIF.
      ELSE.
        wa_tac7-rename = 'VACANT'.
        wa_tac7-rshort = 'RM'.
      ENDIF.
      SELECT SINGLE * FROM zdrphq WHERE bzirk EQ wa_tac6-rm.
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM zthr_heq_des WHERE zz_hqcode EQ zdrphq-zz_hqcode.
        IF sy-subrc EQ 0.
          wa_tac7-rzz_hqdesc = zthr_heq_des-zz_hqdesc.
        ENDIF.
      ENDIF.
    ENDIF.


    SELECT SINGLE * FROM yterrallc WHERE spart EQ wa_tac6-spart AND bzirk EQ wa_tac6-zm AND begda LE s_budat1 AND endda GE s_budat2.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM pa0001 WHERE plans EQ yterrallc-plans AND begda LE date1 AND endda GE s_budat2.
      IF sy-subrc EQ 0.
*        WRITE : PA0001-ENAME.
        wa_tac7-dzename = pa0001-ename.
        wa_tac7-dzpernr = pa0001-pernr.
        wa_tap1-pernr = pa0001-pernr.
        COLLECT wa_tap1 INTO it_tap1.
        CLEAR wa_tap1.
        SELECT SINGLE * FROM pa0302 WHERE pernr EQ pa0001-pernr AND massn EQ '01'.
        IF sy-subrc EQ 0.
          wa_tac7-dzbegda = pa0302-begda.
        ENDIF.
        SELECT SINGLE * FROM zfsdes WHERE persk EQ pa0001-persk.
        IF sy-subrc EQ 0..
*          WRITE : HRP1000-SHORT.
          wa_tac7-dzshort = zfsdes-short.
        ENDIF.
      ELSE.
        wa_tac7-dzename = 'VACANT'.
        wa_tac7-dzshort = 'DZM'.
      ENDIF.
      SELECT SINGLE * FROM zdrphq WHERE bzirk EQ wa_tac6-zm.
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM zthr_heq_des WHERE zz_hqcode EQ zdrphq-zz_hqcode.
        IF sy-subrc EQ 0.
*          WRITE : zthr_heq_des-zz_hqdesc.
          wa_tac7-dzzz_hqdesc = zthr_heq_des-zz_hqdesc.
        ENDIF.
      ENDIF.
    ENDIF.

    SELECT SINGLE * FROM yterrallc WHERE spart EQ wa_tac6-spart AND bzirk EQ wa_tac6-reg AND begda LE s_budat1 AND endda GE s_budat2.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM pa0001 WHERE plans EQ yterrallc-plans AND begda LE date1 AND endda GE s_budat2.
      IF sy-subrc EQ 0.
*        WRITE : PA0001-ENAME.
        wa_tac7-zename = pa0001-ename.
        wa_tac7-zpernr = pa0001-pernr.
        SELECT SINGLE * FROM pa0302 WHERE pernr EQ pa0001-pernr AND massn EQ '01'.
        IF sy-subrc EQ 0.
          wa_tac7-zbegda = pa0302-begda.
        ENDIF.
        SELECT SINGLE * FROM zfsdes WHERE persk EQ pa0001-persk.
        IF sy-subrc EQ 0..
*          WRITE : HRP1000-SHORT.
          wa_tac7-zshort = zfsdes-short.
        ENDIF.
      ENDIF.
      SELECT SINGLE * FROM zdrphq WHERE bzirk EQ wa_tac6-reg.
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM zthr_heq_des WHERE zz_hqcode EQ zdrphq-zz_hqcode.
        IF sy-subrc EQ 0.
*          WRITE : zthr_heq_des-zz_hqdesc.
          wa_tac7-zzz_hqdesc = zthr_heq_des-zz_hqdesc.
        ENDIF.
      ENDIF.
    ENDIF.



    SELECT SINGLE * FROM ysd_dist_targt WHERE bzirk EQ wa_tac6-bzirk AND trgyear EQ year1.
    IF sy-subrc EQ 0.
      IF month EQ '04'.
        wa_tac7-targt = ysd_dist_targt-month01.
      ELSEIF month EQ '05'.
        wa_tac7-targt = ysd_dist_targt-month02.
      ELSEIF month EQ '06'.
        wa_tac7-targt = ysd_dist_targt-month03.
      ELSEIF month EQ '07'.
        wa_tac7-targt = ysd_dist_targt-month04.
      ELSEIF month EQ '08'.
        wa_tac7-targt = ysd_dist_targt-month05.
      ELSEIF month EQ '09'.
        wa_tac7-targt = ysd_dist_targt-month06.
      ELSEIF month EQ '10'.
        wa_tac7-targt = ysd_dist_targt-month07.
      ELSEIF month EQ '11'.
        wa_tac7-targt = ysd_dist_targt-month08.
      ELSEIF month EQ '12'.
        wa_tac7-targt = ysd_dist_targt-month09.
      ELSEIF month EQ '01'.
        wa_tac7-targt = ysd_dist_targt-month10.
      ELSEIF month EQ '02'.
        wa_tac7-targt = ysd_dist_targt-month11.
      ELSEIF month EQ '03'.
        wa_tac7-targt = ysd_dist_targt-month12.
      ENDIF.
    ENDIF.
    COLLECT wa_tac7 INTO it_tac7.
    CLEAR wa_tac7.
  ENDLOOP.

*  LOOP AT IT_TAC7 INTO WA_TAC7.
*    WRITE : / 'A',WA_TAC7-TEXT, WA_TAC7-REG,WA_TAC7-spart,WA_TAC7-ZM,WA_TAC7-RM,WA_TAC7-BZIRK,WA_TAC7-sval,wa_TAC7-acn_val,WA_TAC7-OTH_VAL,
*      wa_TAC7-net, wa_TAC7-PLANS,wa_TAC7-ENAME,wa_TAC7-zz_hqdesc,wa_TAC7-SHORT,wa_TAC7-BEGDA,WA_TAC7-RENAME,WA_TAC7-RZZ_HQDESC, WA_TAC7-RSHORT,
*      WA_TAC7-DZENAME,WA_TAC7-DZZZ_HQDESC, WA_TAC7-DZSHORT,WA_TAC7-ZENAME,WA_TAC7-ZZZ_HQDESC, WA_TAC7-ZSHORT.
*  ENDLOOP.


  IF r1 EQ 'X'.
    PERFORM alv.
  ELSEIF r2 EQ 'X'.
    PERFORM layout.
  ELSEIF r8 EQ 'X'.
    PERFORM layout.
  ELSEIF r3 EQ 'X'.
*****    IF sy-host EQ 'SAPQLT' OR sy-host EQ 'SAPDEV'.
*****    ELSE.
      PERFORM zmemail.
*****    ENDIF.
  ELSEIF r7 EQ 'X'.
*****    IF sy-host EQ 'SAPQLT' OR sy-host EQ 'SAPDEV'.
*****    ELSE.
      PERFORM smemail.
*****    ENDIF.
  ELSEIF r4 EQ 'X'.
*****    IF sy-host EQ 'SAPQLT' OR sy-host EQ 'SAPDEV'.
*****    ELSE.
      PERFORM rmemail.
*****    ENDIF.
  ELSEIF r6 EQ 'X'.
*****    IF sy-host EQ 'SAPQLT' OR sy-host EQ 'SAPDEV'.
*****    ELSE.
      PERFORM dzmemail.
*****    ENDIF.
  ELSEIF r5 EQ 'X'.
*****    IF sy-host EQ 'SAPQLT' OR sy-host EQ 'SAPDEV'.
*****    ELSE.
      PERFORM email.
*****    ENDIF.
  ELSEIF r9 EQ 'X'.
*****    IF sy-host EQ 'SAPQLT' OR sy-host EQ 'SAPDEV'.
******    if sy-host eq 'SAPDEV'.
*****    ELSE.
      PERFORM email.
*****    ENDIF.
  ENDIF.

ENDFORM.                    "summ

*&---------------------------------------------------------------------*
*&      Form  ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM alv.

  wa_fieldcat-fieldname = 'TEXT'.
  wa_fieldcat-seltext_l = 'REPORTING'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'REG'.
  wa_fieldcat-seltext_l = 'ZM REGION CODE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'ZM'.
  wa_fieldcat-seltext_l = 'DZM REG CODE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'RM'.
  wa_fieldcat-seltext_l = 'RM REG CODE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'BZIRK'.
  wa_fieldcat-seltext_l = 'TERRITORY'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'SPART'.
  wa_fieldcat-seltext_l = 'DIVISION'.
  APPEND wa_fieldcat TO fieldcat.

*
  wa_fieldcat-fieldname = 'SVAL'.
  wa_fieldcat-seltext_l = 'GROSS SALE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'ACN_VAL'.
  wa_fieldcat-seltext_l = 'ZG2 CN VAL'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'OTH_VAL'.
  wa_fieldcat-seltext_l = 'OTHER CN VAL'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'NET'.
  wa_fieldcat-seltext_l = 'NET VALUE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'TARGT'.
  wa_fieldcat-seltext_l = 'TARGET VALUE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'PLANS'.
  wa_fieldcat-seltext_l = 'PSO POSITION'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'ENAME'.
  wa_fieldcat-seltext_l = 'PSO NAME'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'ZZ_HQDESC'.
  wa_fieldcat-seltext_l = 'PSO HEADQRT'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'SHORT'.
  wa_fieldcat-seltext_l = 'PSO DESIGNATION'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'BEGDA'.
  wa_fieldcat-seltext_l = 'PSO JOINING DATE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'RENAME'.
  wa_fieldcat-seltext_l = 'RM NAME'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'RZZ_HQDESC'.
  wa_fieldcat-seltext_l = 'RM HEADQRT'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'RSHORT'.
  wa_fieldcat-seltext_l = 'RM DESG.'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'DZENAME'.
  wa_fieldcat-seltext_l = 'DZ NAME'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'DZZZ_HQDESC'.
  wa_fieldcat-seltext_l = 'DZ HEADQRT'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'DZSHORT'.
  wa_fieldcat-seltext_l = 'DZ DESG.'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'ZENAME'.
  wa_fieldcat-seltext_l = 'ZM NAME'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'ZZZ_HQDESC'.
  wa_fieldcat-seltext_l = 'ZM HEADQRT'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'ZSHORT'.
  wa_fieldcat-seltext_l = 'ZM DESG.'.
  APPEND wa_fieldcat TO fieldcat.





  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'SR9 DETAILS'.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
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
    TABLES
      t_outtab                = it_tac7
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.                    "ALV

*&---------------------------------------------------------------------*
*&      Form  LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM layout.
  IF r2 EQ 'X'.
    PERFORM sfformdet.
    PERFORM sfform.

  ELSEIF r8 EQ 'X'.
    PERFORM sfformdet.
    PERFORM r12sfformem.
  ENDIF.
ENDFORM.                    "LAYOUT

*&---------------------------------------------------------------------*
*&      Form  ZMEMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM zmemail.
  PERFORM sfformdet.
*  PERFORM SFFORM1.

  LOOP AT it_tac7 INTO wa_tac7.
    SELECT SINGLE * FROM pa0105 WHERE pernr EQ wa_tac7-zpernr AND subty EQ '0010'.
    IF sy-subrc EQ 0.
      wa_zmemail-reg = wa_tac7-reg.
      wa_zmemail-usrid_long = pa0105-usrid_long.
      COLLECT wa_zmemail INTO it_zmemail.
      CLEAR wa_zmemail.
    ENDIF.
  ENDLOOP.
  SORT it_zmemail BY reg.
  DELETE ADJACENT DUPLICATES FROM it_zmemail COMPARING reg.
  PERFORM sfform2.

**  elseif r3 eq 'X'.
*
*
*
**    WRITE : / 'LAYOUT'.
*
**  sort it_tac7 by reg zm rm bzirk spart.
*  SORT IT_TAC7 BY REG ZM RM.
*
*  LOOP AT IT_TAC7 INTO WA_TAC7.
**      WRITE : / 'ZM',WA_TAC7-ZPERNR,WA_TAC7-TEXT, WA_TAC7-REG,WA_TAC7-spart,WA_TAC7-ZM,WA_TAC7-RM,WA_TAC7-BZIRK,WA_TAC7-sval,wa_TAC7-acn_val,WA_TAC7-OTH_VAL,
**        wa_TAC7-net, wa_TAC7-PLANS,wa_TAC7-ENAME,wa_TAC7-zz_hqdesc,wa_TAC7-SHORT,wa_TAC7-BEGDA,WA_TAC7-RENAME,WA_TAC7-RZZ_HQDESC,
**        WA_TAC7-RSHORT, WA_TAC7-DZENAME,WA_TAC7-DZZZ_HQDESC, WA_TAC7-DZSHORT,WA_TAC7-ZENAME,WA_TAC7-ZZZ_HQDESC, WA_TAC7-ZSHORT.
*    WA_TAD1-REG = WA_TAC7-REG.
*    WA_TAD1-ZM = WA_TAC7-ZM.
*    WA_TAD1-RM = WA_TAC7-RM.
**
*
*
*    WA_TAD1-BZIRK = WA_TAC7-BZIRK.
*    WA_TAD1-PLANS = WA_TAC7-PLANS.
*    WA_TAD1-SVAL = WA_TAC7-SVAL.
*    WA_TAD1-ACN_VAL = WA_TAC7-ACN_VAL.
*    WA_TAD1-OTH_VAL = WA_TAC7-OTH_VAL.
*    WA_TAD1-NET = WA_TAC7-NET.
*    READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY REG = WA_TAD1-REG ZM = WA_TAD1-ZM RM = WA_TAD1-RM.
*    IF SY-SUBRC EQ 0.
*      WA_TAD1-ZPERNR = WA_TAC7-ZPERNR.
*    ENDIF.
*    COLLECT WA_TAD1 INTO IT_TAD1.
*    CLEAR WA_TAD1.
*    WA_TAM1-ZPERNR = WA_TAC7-ZPERNR.
*    COLLECT WA_TAM1 INTO IT_TAM1.
*    CLEAR WA_TAM1.
*  ENDLOOP.
*
*  LOOP AT IT_TAM1 INTO WA_TAM1.
*    SELECT SINGLE * FROM PA0105 WHERE PERNR EQ WA_TAM1-ZPERNR AND SUBTY EQ '0010'.
*    IF SY-SUBRC EQ 0.
*      WA_TAM2-ZPERNR = WA_TAM1-ZPERNR.
*      WA_TAM2-USRID_LONG = PA0105-USRID_LONG.
*      COLLECT WA_TAM2 INTO IT_TAM2.
*      CLEAR WA_TAM2.
*    ENDIF.
*  ENDLOOP.
*
*  LOOP AT IT_TAM2 INTO WA_TAM2.
*    WRITE: / WA_TAM2-ZPERNR,WA_TAM2-USRID_LONG.
*  ENDLOOP.
*  SORT IT_TAM2 BY ZPERNR.
*  DELETE ADJACENT DUPLICATES FROM IT_TAM2 COMPARING ZPERNR.
*
*  LOOP AT IT_TAD1 INTO WA_TAD1.
*    CLEAR : BC,BCL,XL,LS.
**      WRITE : / '*',WA_TAD1-REG, WA_TAD1-ZM, WA_TAD1-RM, WA_TAD1-BZIRK,WA_TAD1-PLANS, WA_TAD1-SVAL,WA_TAD1-ACN_VAL, WA_TAD1-OTH_VAL, WA_TAD1-NET.
*    WA_TAD2-REG = WA_TAD1-REG.
*    WA_TAD2-ZM = WA_TAD1-ZM.
*    WA_TAD2-ZPERNR = WA_TAD1-ZPERNR.
*    WA_TAD2-RM = WA_TAD1-RM.
*    WA_TAD2-BZIRK = WA_TAD1-BZIRK.
*    WA_TAD2-PLANS = WA_TAD1-PLANS.
*    WA_TAD2-SVAL = WA_TAD1-SVAL.
*    WA_TAD2-ACN_VAL = WA_TAD1-ACN_VAL.
*    WA_TAD2-OTH_VAL = WA_TAD1-OTH_VAL.
*    WA_TAD2-NET = WA_TAD1-NET.
**    READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD1-PLANS SPART = '50'.
**    IF SY-SUBRC EQ 0.
***      bc = 1.
**      READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD1-PLANS SPART = '60'.
**      IF SY-SUBRC EQ 0.
**        BCL = 1.
**      ELSE.
**        BC = 1.
**      ENDIF.
**    ELSE.
**      READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD1-PLANS SPART = '60'.
**      IF SY-SUBRC EQ 0.
**        XL = 1.
**      ENDIF.
**    ENDIF.
*    CLEAR : DCOUNT.
*    READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD1-PLANS SPART = '50'.
*    IF SY-SUBRC EQ 0.
*      BC = 1.
*      DCOUNT = DCOUNT + 1.
*    ENDIF.
*    READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD1-PLANS SPART = '60'.
*    IF SY-SUBRC EQ 0.
*      XL = 1.
*      DCOUNT = DCOUNT + 1.
*    ENDIF.
*    READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD1-PLANS SPART = '70'.
*    IF SY-SUBRC EQ 0.
*      LS = 1.
*      DCOUNT = DCOUNT + 1.
*    ENDIF.
*    IF DCOUNT GT 1.
*      BCL = 1.
*    ENDIF.
*
*    IF BC EQ 1.
**        WRITE :  'DIVISION IS BCL'.
*      WA_TAD2-DIV = 'BC'.
*    ELSEIF XL EQ '1'.
**        WRITE :  'DIVISION IS XL'.
*      WA_TAD2-DIV = 'XL'.
*    ELSEIF LS EQ '1'.
**        WRITE :  'DIVISION IS XL'.
*      WA_TAD2-DIV = 'LS'.
*    ELSE.
**        WRITE :  'DIVISION IS BC'.
*      WA_TAD2-DIV = 'BCL'.
*    ENDIF.
*
*
*    SELECT SINGLE * FROM YSD_DIST_TARGT WHERE BZIRK EQ WA_TAD1-BZIRK AND TRGYEAR EQ YEAR1.
*    IF SY-SUBRC EQ 0.
*      IF MONTH EQ '04'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH01.
*      ELSEIF MONTH EQ '05'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH02.
*      ELSEIF MONTH EQ '06'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH03.
*      ELSEIF MONTH EQ '07'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH04.
*      ELSEIF MONTH EQ '08'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH05.
*      ELSEIF MONTH EQ '09'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH06.
*      ELSEIF MONTH EQ '10'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH07.
*      ELSEIF MONTH EQ '11'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH08.
*      ELSEIF MONTH EQ '12'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH09.
*      ELSEIF MONTH EQ '01'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH10.
*      ELSEIF MONTH EQ '02'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH11.
*      ELSEIF MONTH EQ '03'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH12.
*      ENDIF.
*
*      IF MONTH EQ '04'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH01.
*      ELSEIF MONTH EQ '05'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH02.
*      ELSEIF MONTH EQ '06'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH03.
*      ELSEIF MONTH EQ '07'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH04.
*      ELSEIF MONTH EQ '08'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH05.
*      ELSEIF MONTH EQ '09'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH06.
*      ELSEIF MONTH EQ '10'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH07.
*      ELSEIF MONTH EQ '11'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH08.
*      ELSEIF MONTH EQ '12'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH09.
*      ELSEIF MONTH EQ '01'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH10.
*      ELSEIF MONTH EQ '02'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH11.
*      ELSEIF MONTH EQ '03'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH12.
*      ENDIF.
*    ELSE.
*      SELECT SINGLE * FROM YSD_HBE_TARGT WHERE BZIRK EQ WA_TAD1-BZIRK AND TRGYEAR EQ YEAR1.
*      IF SY-SUBRC EQ 0.
*        IF MONTH EQ '04'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH01.
*        ELSEIF MONTH EQ '05'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH02.
*        ELSEIF MONTH EQ '06'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH03.
*        ELSEIF MONTH EQ '07'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH04.
*        ELSEIF MONTH EQ '08'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH05.
*        ELSEIF MONTH EQ '09'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH06.
*        ELSEIF MONTH EQ '10'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH07.
*        ELSEIF MONTH EQ '11'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH08.
*        ELSEIF MONTH EQ '12'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH09.
*        ELSEIF MONTH EQ '01'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH10.
*        ELSEIF MONTH EQ '02'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH11.
*        ELSEIF MONTH EQ '03'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH12.
*        ENDIF.
*      ENDIF.
*    ENDIF.
*
*
*    COLLECT WA_TAD2 INTO IT_TAD2.
*    CLEAR WA_TAD2.
*  ENDLOOP.
*
**  LOOP AT IT_TAD2 INTO WA_TAD2.
**    IF DV1 EQ 'X'.
**      DELETE IT_TAD2 WHERE DIV = 'XL'.
**    ELSEIF DV2 EQ 'X'.
**      DELETE IT_TAD2 WHERE DIV = 'BC'.
**      DELETE IT_TAD2 WHERE DIV = 'BCL'.
**    ENDIF.
**  ENDLOOP.
*  LOOP AT IT_TAD2 INTO WA_TAD2.
*    IF DV1 EQ 'X'.
*      DELETE IT_TAD2 WHERE DIV = 'XL'.
*      DELETE IT_TAD2 WHERE DIV = 'LS'.
*    ELSEIF DV2 EQ 'X'.
*      DELETE IT_TAD2 WHERE DIV = 'BC'.
*      DELETE IT_TAD2 WHERE DIV = 'BCL'.
*      DELETE IT_TAD2 WHERE DIV = 'LS'.
*    ELSEIF DV4 EQ 'X'.
*      DELETE IT_TAD2 WHERE DIV = 'BC'.
*      DELETE IT_TAD2 WHERE DIV = 'XL'.
*      DELETE IT_TAD2 WHERE DIV = 'BCL'.
*    ENDIF.
*  ENDLOOP.
*
*
*  LOOP AT IT_TAD2 INTO WA_TAD2.
**      WRITE : / '**',WA_TAD2-REG,WA_TAD2-BZIRK, WA_TAD2-DIV,wa_tad2-net.
*    WA_TAD3-REG = WA_TAD2-REG.
*    WA_TAD3-BZIRK = WA_TAD2-BZIRK.
*    WA_TAD3-DIV = WA_TAD2-DIV.
*    COLLECT WA_TAD3 INTO IT_TAD3.
*    CLEAR WA_TAD3.
*    WA_TAD21-REG = WA_TAD2-REG.
*    WA_TAD21-DIV = WA_TAD2-DIV.
*    WA_TAD21-NET = WA_TAD2-NET.
*    COLLECT WA_TAD21 INTO IT_TAD21.
*    CLEAR WA_TAD21.
**       WA_TAD2-ZM, WA_TAD2-RM,  WA_TAD2-PLANS, WA_TAD2-SVAL, WA_TAD2-ACN_VAL, WA_TAD2-OTH_VAL, WA_TAD2-NET,,WA_TAD2-TARGT.
*  ENDLOOP.
*  SORT IT_TAD21 BY REG DIV.
**    LOOP at it_tad21 INTO wa_tad21.
***      WRITE : /'**', wa_tad21-reg,wa_tad21-div,wa_tad21-net.
**    ENDLOOP.
*
*  SORT IT_TAD3 BY REG DIV.
*  LOOP AT IT_TAD3 INTO WA_TAD3.
*    ON CHANGE OF WA_TAD3-REG.
*      COUNT1 = 1.
*    ENDON.
*    ON CHANGE OF WA_TAD3-DIV.
*      COUNT1 = 1.
*    ENDON.
**      WRITE : / WA_TAD3-REG,WA_TAD3-BZIRK,WA_TAD3-DIV,COUNT1.
*
*    WA_TAD4-REG = WA_TAD3-REG.
*    WA_TAD4-DIV = WA_TAD3-DIV.
*    WA_TAD4-COUNT = COUNT1.
*    APPEND WA_TAD4 TO IT_TAD4.
*    CLEAR WA_TAD4.
*    COUNT1 = COUNT1 + 1.
*  ENDLOOP.
*  SORT IT_TAD4 DESCENDING BY COUNT.
*
**    ULINE.
**    LOOP AT IT_TAD4 INTO WA_TAD4.
**      WRITE : / 'FINAL', WA_TAD4-REG,WA_TAD4-DIV,WA_TAD4-COUNT.
**    ENDLOOP.
*  OPTIONS-TDGETOTF = 'X'.
*
*  SORT IT_TAD2 BY REG ZM RM BZIRK.
*  IF IT_TAD2 IS INITIAL.
*    MESSAGE 'NO DATA FOUND FOR THIS DIVISION' TYPE 'E'.
*    EXIT.
*  ENDIF.
*
*  LOOP AT IT_TAM1 INTO WA_TAM1.
*    CALL FUNCTION 'OPEN_FORM'
*      EXPORTING
*        DEVICE                      = 'PRINTER'
*        DIALOG                      = ''
**       form                        = 'ZSR9_1'
*        LANGUAGE                    = SY-LANGU
*        OPTIONS                     = OPTIONS
*      EXCEPTIONS
*        CANCELED                    = 1
*        DEVICE                      = 2
*        FORM                        = 3
*        OPTIONS                     = 4
*        UNCLOSED                    = 5
*        MAIL_OPTIONS                = 6
*        ARCHIVE_ERROR               = 7
*        INVALID_FAX_NUMBER          = 8
*        MORE_PARAMS_NEEDED_IN_BATCH = 9
*        SPOOL_ERROR                 = 10
*        CODEPAGE                    = 11
*        OTHERS                      = 12.
*    IF SY-SUBRC <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.
*    CALL FUNCTION 'START_FORM'
*      EXPORTING
*        FORM        = 'ZSR9_1'
*        LANGUAGE    = SY-LANGU
*      EXCEPTIONS
*        FORM        = 1
*        FORMAT      = 2
*        UNENDED     = 3
*        UNOPENED    = 4
*        UNUSED      = 5
*        SPOOL_ERROR = 6
*        CODEPAGE    = 7
*        OTHERS      = 8.
*    IF SY-SUBRC <> 0.
*      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.
*    PAGE1 = 0.
*    PAGE2 = 0.
*
*    SELECT * FROM PA0001 INTO TABLE IT_PA0001_1 FOR ALL ENTRIES IN IT_TAD2 WHERE PLANS = IT_TAD2-PLANS AND ZZ_HQCODE NE '     '.
*    SORT IT_PA0001_1 BY ENDDA DESCENDING.
*
*    LOOP AT IT_TAD2 INTO WA_TAD2 WHERE ZPERNR = WA_TAM1-ZPERNR.
*      CLEAR : JO_DT1,STP,C_BCL,C_BC,C_XL,C_LS, ZJO_DT.
**      WRITE : / WA_TAD2-REG, WA_TAD2-ZM, WA_TAD2-RM, WA_TAD2-BZIRK,WA_TAD2-DIV,WA_TAD2-PLANS, WA_TAD2-SVAL,
**      WA_TAD2-ACN_VAL, WA_TAD2-OTH_VAL, WA_TAD2-NET,wa_tad2-targt.
*      ON CHANGE OF WA_TAD2-REG.
*        STPCNT = 0.
*        NEW-PAGE.
*        PAGE1 = 1.
*        FORMAT COLOR 3.
**        WRITE : /1 'ZM',6 '*'.
*        READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY REG = WA_TAD2-REG.
*        IF SY-SUBRC EQ 0 AND WA_TAC7-ZPERNR NE 0.
**          WRITE : 20 WA_TAC7-ZENAME,35 WA_TAC7-ZZZ_HQDESC.
*          ZM_NAME = WA_TAC7-ZENAME.
*        ELSE.
*          ZM_NAME = 'VACANT'.
*        ENDIF.
*        PAGE3 = PAGE1 + PAGE2.
*        PAGE4 = PAGE3.
*        IF PAGE3 GT 1.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'HEAD1'
*              WINDOW  = 'MAIN'.
*        ELSE.
**          WRITE : /20 'VACANT'.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'HEAD2'
*              WINDOW  = 'MAIN'.
*        ENDIF.
*        PAGE1 = PAGE1 + 1.
*        PAGE2 = PAGE2 + 1.
**        ULINE.
**        WRITE : /1 'NAME',17 'H.Q.',34 'D.O.J.',50 'DIV',57 'SALES',78 'TARGET'.
**        SKIP.
*        CALL FUNCTION 'WRITE_FORM'
*          EXPORTING
*            ELEMENT = 'HEAD3'
*            WINDOW  = 'MAIN'.
*      ENDON.
*      FORMAT COLOR 1.
*      READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD2-PLANS.
*      IF SY-SUBRC EQ 0 AND WA_TAC7-BEGDA NE 0.
*        CONCATENATE WA_TAC7-BEGDA+4(2) '/' WA_TAC7-BEGDA+0(4) INTO JO_DT1.
**        WRITE : /1(15) WA_TAC7-ENAME,17(15) WA_TAC7-ZZ_HQDESC,34 JO_DT1,43(5) WA_TAC7-SHORT.
*
*        CALL FUNCTION 'WRITE_FORM'
*          EXPORTING
*            ELEMENT = 'T1'
*            WINDOW  = 'MAIN'.
*      ELSE.
**        WRITE : /1(15) 'VACANT',wa_tad2-plans.
**          READ TABLE IT_pa0001_1 INTO WA_PA0001_1 WITH KEY plans = wa_tad2-plans.
*        SELECT SINGLE * FROM ZDRPHQ WHERE BZIRK EQ WA_TAD2-BZIRK.
*        IF SY-SUBRC EQ 0.
*          SELECT SINGLE * FROM ZTHR_HEQ_DES WHERE ZZ_HQCODE EQ ZDRPHQ-ZZ_HQCODE.
*          IF SY-SUBRC EQ 0.
*            CLEAR : HQCODE.
**          WRITE : zthr_heq_des-zz_hqdesc.
*            HQCODE = ZTHR_HEQ_DES-ZZ_HQDESC.
*          ENDIF.
*        ENDIF.
*        CALL FUNCTION 'WRITE_FORM'
*          EXPORTING
*            ELEMENT = 'T2'
*            WINDOW  = 'MAIN'.
*      ENDIF.
**      WRITE : 50(3) WA_TAD2-DIV,55(13) WA_TAD2-NET,70(15) wa_tad2-targt.
*      IF WA_TAD2-TARGT NE 0.
*        STP = ( WA_TAD2-NET / WA_TAD2-TARGT ) * 100.
*      ENDIF.
*      IF STP GE 100.
*        STPCNT = STPCNT + 1.
*      ENDIF.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'T3'
*          WINDOW  = 'MAIN'.
*      IF WA_TAD2-RM NE '      '.
*        RMTOT = RMTOT + WA_TAD2-NET.
*        RMTAR = RMTAR + WA_TAD2-TARGT.
*      ENDIF.
*      IF WA_TAD2-REG NE '      '.
*        ZMTOT = ZMTOT + WA_TAD2-NET.
*        ZMTAR = ZMTAR + WA_TAD2-TARGT.
*      ENDIF.
*      IF WA_TAD2-ZM NE '      '.
*        DZTOT = DZTOT + WA_TAD2-NET.
*        DZMTAR = DZMTAR + WA_TAD2-TARGT.
*      ENDIF.
**      RMTOT = RMTOT + WA_TAD2-NET.
**      ZMTOT = ZMTOT + WA_TAD2-NET.
**      RMTAR = RMTAR + WA_TAD2-TARGT.
**      ZMTAR = ZMTAR + WA_TAD2-TARGT.
**      IF WA_TAD2-ZM NE '      '.
**        DZTOT = DZTOT + WA_TAD2-NET.
**        DZMTAR = DZMTAR + WA_TAD2-TARGT.
**      ENDIF.
*      FORMAT COLOR 4.
*      IF WA_TAD2-RM NE '      '.
*        AT END OF RM.
*          CLEAR : RJO_DT.
**        ULINE.
*          READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY RM = WA_TAD2-RM.
*          IF SY-SUBRC EQ 0 AND WA_TAC7-RPERNR NE 0.
**          WRITE : /1(15) WA_TAC7-RENAME,17(15) WA_TAC7-RZZ_HQDESC,43(5) WA_TAC7-RSHORT,wa_tac7-rbegda.
*            CONCATENATE WA_TAC7-RBEGDA+4(2) '/' WA_TAC7-RBEGDA+0(4) INTO RJO_DT.
*          ENDIF.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'R1'
*              WINDOW  = 'MAIN'.
**          else.
***          WRITE : / 'VACANT'.
**            call function 'WRITE_FORM'
**              EXPORTING
**                element = 'R2'
**                window  = 'MAIN'.
**          endif.
**        WRITE : 55(13) rmtot,70(15) rmtar.
*          IF RMTAR NE 0.
*            RSTP = ( RMTOT / RMTAR ) * 100.
*          ENDIF.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'R3'
*              WINDOW  = 'MAIN'.
*          RMTOT = 0.
*          RMTAR = 0.
*          RSTP = 0.
**        ULINE.
*        ENDAT.
*      ENDIF.
****************DZM************************
*      IF WA_TAD2-ZM NE '      '.
*        AT END OF ZM.
*          CLEAR : DZJO_DT.
**        ULINE.
*          READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY ZM = WA_TAD2-ZM.
*          IF SY-SUBRC EQ 0 AND WA_TAC7-DZPERNR NE 0.
**          WRITE : /1(15) WA_TAC7-RENAME,17(15) WA_TAC7-RZZ_HQDESC,43(5) WA_TAC7-RSHORT,wa_tac7-rbegda.
*            CONCATENATE WA_TAC7-DZBEGDA+4(2) '/' WA_TAC7-DZBEGDA+0(4) INTO DZJO_DT.
**          WRITE : / 'rjo_dt',rjo_dt.
*          ENDIF.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'DZM1'
*              WINDOW  = 'MAIN'.
**          else.
***          WRITE : / 'VACANT'.
**            call function 'WRITE_FORM'
**              EXPORTING
**                element = 'DZM2'
**                window  = 'MAIN'.
**          endif.
**        WRITE : 55(13) rmtot,70(15) rmtar.
*          IF DZMTAR NE 0.
*            DZMSTP = ( DZTOT / DZMTAR ) * 100.
*          ENDIF.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'DZM3'
*              WINDOW  = 'MAIN'.
*          DZTOT = 0.
*          DZMTAR = 0.
*          DZMSTP = 0.
**        ULINE.
*        ENDAT.
*      ENDIF.
*******************************************
*      IF WA_TAD2-REG NE '      '.
*        AT END OF REG.
*          CLEAR : C_BCL,C_BC,C_XL,C_LS,ZJO_DT,P_BCL,P_BC,P_XL,P_TOT.
**        ULINE.
*          FORMAT COLOR 3.
**        WRITE : / 'ZONE TOTAL :',55(13) ZMTOT,70(15) zmtar.
*          IF ZMTAR NE 0.
*            ZSTP = ( ZMTOT / ZMTAR ) * 100.
*          ENDIF.
*          READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY REG = WA_TAD2-REG.
*          IF SY-SUBRC EQ 0 AND WA_TAC7-ZPERNR NE 0.
**          WRITE : / wa_tac7-zename,wa_tac7-zbegda.
*            CONCATENATE WA_TAC7-ZBEGDA+4(2) '/' WA_TAC7-ZBEGDA+0(4) INTO ZJO_DT.
*          ENDIF.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'Z1'
*              WINDOW  = 'MAIN'.
*          READ TABLE IT_TAD4 INTO WA_TAD4 WITH  KEY REG = WA_TAD2-REG DIV = 'BCL'.  "Jyotsna check here
*          IF SY-SUBRC EQ 0 AND WA_TAD4-COUNT NE 0.
*            C_BCL = WA_TAD4-COUNT.
*            C_TOT = C_TOT + WA_TAD4-COUNT.
*            READ TABLE IT_TAD21 INTO WA_TAD21 WITH KEY REG = WA_TAD2-REG DIV = 'BCL'.
*            IF SY-SUBRC EQ 0.
*              P_BCL = WA_TAD21-NET / C_BCL.
**            P_TOT = P_TOT + P_BCL.
*            ENDIF.
*            CALL FUNCTION 'WRITE_FORM'
*              EXPORTING
*                ELEMENT = 'Z2'
*                WINDOW  = 'MAIN'.
*          ENDIF.
*          READ TABLE IT_TAD4 INTO WA_TAD4 WITH  KEY REG = WA_TAD2-REG DIV = 'BC'.
*          IF SY-SUBRC EQ 0 AND  WA_TAD4-COUNT NE 0.
*            C_BC = WA_TAD4-COUNT.
*            C_TOT = C_TOT + WA_TAD4-COUNT.
*            READ TABLE IT_TAD21 INTO WA_TAD21 WITH KEY REG = WA_TAD2-REG DIV = 'BC'.
*            IF SY-SUBRC EQ 0.
*              P_BC = WA_TAD21-NET / C_BC.
**            P_TOT = P_TOT + P_BC.
*            ENDIF.
*            CALL FUNCTION 'WRITE_FORM'
*              EXPORTING
*                ELEMENT = 'Z3'
*                WINDOW  = 'MAIN'.
*          ENDIF.
*          READ TABLE IT_TAD4 INTO WA_TAD4 WITH  KEY REG = WA_TAD2-REG DIV = 'XL'.
*          IF SY-SUBRC EQ 0 AND WA_TAD4-COUNT NE 0.
*            C_XL = WA_TAD4-COUNT.
*            C_TOT = C_TOT + WA_TAD4-COUNT.
*            READ TABLE IT_TAD21 INTO WA_TAD21 WITH KEY REG = WA_TAD2-REG DIV = 'XL'.
*            IF SY-SUBRC EQ 0.
*              P_XL = WA_TAD21-NET / C_XL.
**            P_TOT = P_TOT + P_XL.
*            ENDIF.
*            CALL FUNCTION 'WRITE_FORM'
*              EXPORTING
*                ELEMENT = 'Z4'
*                WINDOW  = 'MAIN'.
*          ENDIF.
*
*          READ TABLE IT_TAD4 INTO WA_TAD4 WITH  KEY REG = WA_TAD2-REG DIV = 'LS'.
*          IF SY-SUBRC EQ 0 AND WA_TAD4-COUNT NE 0.
*            C_LS = WA_TAD4-COUNT.
*            C_TOT = C_TOT + WA_TAD4-COUNT.
*            READ TABLE IT_TAD21 INTO WA_TAD21 WITH KEY REG = WA_TAD2-REG DIV = 'LS'.
*            IF SY-SUBRC EQ 0.
*              P_LS = WA_TAD21-NET / C_LS.
**            P_TOT = P_TOT + P_XL.
*            ENDIF.
*            CALL FUNCTION 'WRITE_FORM'
*              EXPORTING
*                ELEMENT = 'Z41'
*                WINDOW  = 'MAIN'.
*          ENDIF.
*
*          P_TOT = ZMTOT / C_TOT.
*
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'Z5'
*              WINDOW  = 'MAIN'.
*          ZMTOT = 0.
*          ZMTAR = 0.
*          C_BCL = 0.
*          C_BC = 0.
*          C_XL = 0.
*          C_LS = 0.
*          C_TOT = 0.
*          P_BCL = 0.
*          P_BC = 0.
*          P_XL = 0.
*          P_TOT = 0.
*          ZSTP = 0.
*          CLEAR : ZM_NAME.
**        ULINE.
*        ENDAT.
*      ENDIF.
*
*    ENDLOOP.
*    CALL FUNCTION 'END_FORM'
*      EXCEPTIONS
*        UNOPENED                 = 1
*        BAD_PAGEFORMAT_FOR_PRINT = 2
*        SPOOL_ERROR              = 3
*        CODEPAGE                 = 4
*        OTHERS                   = 5.
*    IF SY-SUBRC <> 0.
*      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.
*
*    CALL FUNCTION 'CLOSE_FORM'
*      IMPORTING
*        RESULT  = RESULT
*      TABLES
*        OTFDATA = L_OTF_DATA.
*
*    CALL FUNCTION 'CONVERT_OTF'
*      EXPORTING
*        FORMAT       = 'PDF'
*      IMPORTING
*        BIN_FILESIZE = L_BIN_FILESIZE
*      TABLES
*        OTF          = L_OTF_DATA
*        LINES        = L_ASC_DATA.
*
*    CALL FUNCTION 'SX_TABLE_LINE_WIDTH_CHANGE'
*      EXPORTING
*        LINE_WIDTH_DST = '255'
*      TABLES
*        CONTENT_IN     = L_ASC_DATA
*        CONTENT_OUT    = OBJBIN.
*
*    WRITE S_BUDAT1 TO WA_D1 DD/MM/YYYY.
*    WRITE S_BUDAT2 TO WA_D2 DD/MM/YYYY.
*
*    DESCRIBE TABLE OBJBIN LINES RIGHE_ATTACHMENT.
*    OBJTXT = 'This eMail is meant for information only. Please DO NOT REPLY'.APPEND OBJTXT.
*    OBJTXT = '                                 '.APPEND OBJTXT.
*    OBJTXT = 'BLUE CROSS LABORATORIES LTD.'.APPEND OBJTXT.
*    DESCRIBE TABLE OBJTXT LINES RIGHE_TESTO.
*    DOC_CHNG-OBJ_NAME = 'URGENT'.
*    DOC_CHNG-EXPIRY_DAT = SY-DATUM + 10.
*    CONDENSE LTX.
*    CONDENSE OBJTXT.
**      CONCATENATE 'SR9 for the period' ltx '-' INTO doc_chng-obj_descr SEPARATED BY space.
*    CONCATENATE 'SR9 for the period of: ' WA_D1 'to' WA_D2 INTO DOC_CHNG-OBJ_DESCR SEPARATED BY SPACE.
*    DOC_CHNG-SENSITIVTY = 'F'.
*    DOC_CHNG-DOC_SIZE = RIGHE_TESTO * 255 .
*
*    CLEAR OBJPACK-TRANSF_BIN.
*
*    OBJPACK-HEAD_START = 1.
*    OBJPACK-HEAD_NUM = 0.
*    OBJPACK-BODY_START = 1.
*    OBJPACK-BODY_NUM = 4.
*    OBJPACK-DOC_TYPE = 'TXT'.
*    APPEND OBJPACK.
*
*    OBJPACK-TRANSF_BIN = 'X'.
*    OBJPACK-HEAD_START = 1.
*    OBJPACK-HEAD_NUM = 0.
*    OBJPACK-BODY_START = 1.
*    OBJPACK-BODY_NUM = RIGHE_ATTACHMENT.
*    OBJPACK-DOC_TYPE = 'PDF'.
*    OBJPACK-OBJ_NAME = 'TEST'.
*    CONDENSE LTX.
*
*
*
**      CONCATENATE 'SR9 ' ltx  'FOR THE PERIOD' wa_d1 'TO' wa_d2 INTO objpack-obj_descr SEPARATED BY space.
*    CONCATENATE 'SR-9' '.' INTO OBJPACK-OBJ_DESCR SEPARATED BY SPACE.
*    OBJPACK-DOC_SIZE = RIGHE_ATTACHMENT * 255.
*    APPEND OBJPACK.
*    CLEAR OBJPACK.
*
*    LOOP AT IT_TAM2 INTO WA_TAM2 WHERE ZPERNR = WA_TAD2-ZPERNR.
**    READ TABLE it_mail1 INTO wa_mail1 WITH KEY lifnr = wa_tab4-lifnr.
**    IF sy-subrc EQ 0.
**      MESSAGE 'EMAIL SENT' TYPE 'I'.
**  loop at it_mail1 into wa_mail1.
*      RECLIST-RECEIVER =   WA_TAM2-USRID_LONG.
*      RECLIST-EXPRESS = 'X'.
*      RECLIST-REC_TYPE = 'U'.
*      RECLIST-NOTIF_DEL = 'X'. " request delivery notification
*      RECLIST-NOTIF_NDEL = 'X'. " request not delivered notification
*      APPEND RECLIST.
*      CLEAR RECLIST.
**  endif.
*    ENDLOOP.
*
*    DESCRIBE TABLE RECLIST LINES MCOUNT.
*    IF MCOUNT > 0.
*      DATA: SENDER LIKE SOEXTRECI1-RECEIVER.
****ADDED BY SATHISH.B
*      TYPES: BEGIN OF T_USR21,
*               BNAME      TYPE USR21-BNAME,
*               PERSNUMBER TYPE USR21-PERSNUMBER,
*               ADDRNUMBER TYPE USR21-ADDRNUMBER,
*             END OF T_USR21.
*
*      TYPES: BEGIN OF T_ADR6,
*               ADDRNUMBER TYPE USR21-ADDRNUMBER,
*               PERSNUMBER TYPE USR21-PERSNUMBER,
*               SMTP_ADDR  TYPE ADR6-SMTP_ADDR,
*             END OF T_ADR6.
*
*      DATA: IT_USR21 TYPE TABLE OF T_USR21,
*            WA_USR21 TYPE T_USR21,
*            IT_ADR6  TYPE TABLE OF T_ADR6,
*            WA_ADR6  TYPE T_ADR6.
*      SELECT  BNAME PERSNUMBER ADDRNUMBER FROM USR21 INTO TABLE IT_USR21
*      WHERE BNAME = SY-UNAME.
*      IF SY-SUBRC = 0.
*        SELECT ADDRNUMBER PERSNUMBER SMTP_ADDR FROM ADR6 INTO TABLE IT_ADR6
*          FOR ALL ENTRIES IN IT_USR21 WHERE ADDRNUMBER = IT_USR21-ADDRNUMBER
*        AND   PERSNUMBER = IT_USR21-PERSNUMBER.
*      ENDIF.
*
*      LOOP AT IT_USR21 INTO WA_USR21.
*        READ TABLE IT_ADR6 INTO WA_ADR6 WITH KEY ADDRNUMBER = WA_USR21-ADDRNUMBER.
*        IF SY-SUBRC = 0.
*          SENDER = WA_ADR6-SMTP_ADDR.
*        ENDIF.
*      ENDLOOP.
*      CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
*        EXPORTING
*          DOCUMENT_DATA              = DOC_CHNG
*          PUT_IN_OUTBOX              = 'X'
*          SENDER_ADDRESS             = SENDER
*          SENDER_ADDRESS_TYPE        = 'SMTP'
**         COMMIT_WORK                = ' '
** IMPORTING
**         SENT_TO_ALL                =
**         NEW_OBJECT_ID              =
**         SENDER_ID                  =
*        TABLES
*          PACKING_LIST               = OBJPACK
**         OBJECT_HEADER              =
*          CONTENTS_BIN               = OBJBIN
*          CONTENTS_TXT               = OBJTXT
**         CONTENTS_HEX               =
**         OBJECT_PARA                =
**         OBJECT_PARB                =
*          RECEIVERS                  = RECLIST
*        EXCEPTIONS
*          TOO_MANY_RECEIVERS         = 1
*          DOCUMENT_NOT_SENT          = 2
*          DOCUMENT_TYPE_NOT_EXIST    = 3
*          OPERATION_NO_AUTHORIZATION = 4
*          PARAMETER_ERROR            = 5
*          X_ERROR                    = 6
*          ENQUEUE_ERROR              = 7
*          OTHERS                     = 8.
*      IF SY-SUBRC <> 0.
*        MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*      ENDIF.
*
*      COMMIT WORK.
*
***modid ver1.0 starts
*
*      CLEAR   : OBJPACK,
*                OBJHEAD,
*                OBJTXT,
*                OBJBIN,
*                RECLIST.
*
*      REFRESH : OBJPACK,
*                OBJHEAD,
*                OBJTXT,
*                OBJBIN,
*                RECLIST.
*
*    ENDIF.
*
*  ENDLOOP.
*  DATA : A TYPE I VALUE 0.
*  LOOP AT IT_TAM1 INTO WA_TAM1.
*    READ TABLE IT_TAM2 INTO WA_TAM2 WITH KEY ZPERNR = WA_TAM1-ZPERNR.
*    IF SY-SUBRC NE 0.
*      A = 1.
*      FORMAT COLOR 6.
*      WRITE : / 'EMAIL ID IS NOT MAINTAINED FOR',WA_TAM2-ZPERNR.
**      MESSAGE 'EMAIL SENT' TYPE 'I'.
*    ELSEIF SY-SUBRC EQ 0.
*      FORMAT COLOR 5.
*      WRITE : / 'EMAIL HAS BEEN SENT TO : ',WA_TAM2-ZPERNR.
*    ENDIF.
**    WRITE : / 'a',a.
*
*  ENDLOOP.
*****************************EMAIL LAYOUT ENDA HERE******

ENDFORM.                    "ZMEMAIL

*&---------------------------------------------------------------------*
*&      Form  RMEMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM rmemail.

  PERFORM sfformdet.
*  PERFORM SFFORM1.

  LOOP AT it_tac7 INTO wa_tac7.
    SELECT SINGLE * FROM pa0105 WHERE pernr EQ wa_tac7-rpernr AND subty EQ '0010'.
    IF sy-subrc EQ 0.
      wa_rmemail-reg = wa_tac7-reg.
      wa_rmemail-zm = wa_tac7-zm.
      wa_rmemail-rm = wa_tac7-rm.
      wa_rmemail-usrid_long = pa0105-usrid_long.
      COLLECT wa_rmemail INTO it_rmemail.
      CLEAR wa_rmemail.
    ENDIF.
  ENDLOOP.
  SORT it_rmemail BY reg zm rm.
  DELETE ADJACENT DUPLICATES FROM it_rmemail COMPARING reg zm rm.
*  PERFORM SFFORM2.
*  PERFORM DZSFFORM2.
  PERFORM rmsfform2.


*  PERFORM SFFORMDET.
**  PERFORM SFFORM1.
*
*  LOOP AT IT_TAC7 INTO WA_TAC7.
*    WA_CHECK1-RM = WA_TAC7-RM.
*    WA_CHECK1-REG = WA_TAC7-REG.
*    WA_CHECK1-ZONENAME = WA_TAC7-ZZZ_HQDESC.
*    COLLECT WA_CHECK1 INTO IT_CHECK1.
*    CLEAR WA_CHECK.
*  ENDLOOP.
*  SORT IT_CHECK1 BY REG RM.
*  DELETE ADJACENT DUPLICATES FROM IT_CHECK1 COMPARING REG RM.
*
*  LOOP AT IT_TAC7 INTO WA_TAC7 .
**    WHERE RM EQ 'R-KOT2'.
*    SELECT SINGLE * FROM PA0105 WHERE PERNR EQ WA_TAC7-RPERNR AND SUBTY EQ '0010'.
*    IF SY-SUBRC EQ 0.
*      WA_RMEMAIL-REG = WA_TAC7-REG.
*      WA_RMEMAIL-RM = WA_TAC7-RM.
*      WA_RMEMAIL-USRID_LONG = PA0105-USRID_LONG.
*      COLLECT WA_RMEMAIL INTO IT_RMEMAIL.
*      CLEAR WA_RMEMAIL.
*    ENDIF.
*  ENDLOOP.
*  SORT IT_RMEMAIL BY REG RM.
*  DELETE ADJACENT DUPLICATES FROM IT_RMEMAIL COMPARING REG RM.
*  DELETE IT_RMEMAIL WHERE USRID_LONG EQ SPACE.
*  PERFORM SFFORM3.


**  elseif r4 eq 'X'.  "FOR RM EMAIL
*
*
*
**    WRITE : / 'LAYOUT'.
*  SORT IT_TAC7 BY REG ZM RM BZIRK SPART.
*  LOOP AT IT_TAC7 INTO WA_TAC7.
**      WRITE : / 'A',WA_TAC7-TEXT, WA_TAC7-REG,WA_TAC7-spart,WA_TAC7-ZM,WA_TAC7-RM,WA_TAC7-BZIRK,WA_TAC7-sval,wa_TAC7-acn_val,WA_TAC7-OTH_VAL,
**        wa_TAC7-net, wa_TAC7-PLANS,wa_TAC7-ENAME,wa_TAC7-zz_hqdesc,wa_TAC7-SHORT,wa_TAC7-BEGDA,WA_TAC7-RENAME,WA_TAC7-RZZ_HQDESC,
**        WA_TAC7-RSHORT, WA_TAC7-DZENAME,WA_TAC7-DZZZ_HQDESC, WA_TAC7-DZSHORT,WA_TAC7-ZENAME,WA_TAC7-ZZZ_HQDESC, WA_TAC7-ZSHORT.
*    WA_TAD1-REG = WA_TAC7-REG.
*    WA_TAD1-ZM = WA_TAC7-ZM.
*    WA_TAD1-RM = WA_TAC7-RM.
*    WA_TAD1-ZPERNR = WA_TAC7-RPERNR.
*    WA_TAD1-BZIRK = WA_TAC7-BZIRK.
*    WA_TAD1-PLANS = WA_TAC7-PLANS.
*    WA_TAD1-SVAL = WA_TAC7-SVAL.
*    WA_TAD1-ACN_VAL = WA_TAC7-ACN_VAL.
*    WA_TAD1-OTH_VAL = WA_TAC7-OTH_VAL.
*    WA_TAD1-NET = WA_TAC7-NET.
*    COLLECT WA_TAD1 INTO IT_TAD1.
*    CLEAR WA_TAD1.
*
*    WA_TAM1-ZPERNR = WA_TAC7-RPERNR.
*    COLLECT WA_TAM1 INTO IT_TAM1.
*    CLEAR WA_TAM1.
*  ENDLOOP.
**    ULINE.
**************RM EMAIL******
*  LOOP AT IT_TAM1 INTO WA_TAM1.
*    SELECT SINGLE * FROM PA0105 WHERE PERNR EQ WA_TAM1-ZPERNR AND SUBTY EQ '0010'.
*    IF SY-SUBRC EQ 0.
*      WA_TAM2-ZPERNR = WA_TAM1-ZPERNR.
*      WA_TAM2-USRID_LONG = PA0105-USRID_LONG.
*      COLLECT WA_TAM2 INTO IT_TAM2.
*      CLEAR WA_TAM2.
*    ENDIF.
*  ENDLOOP.
*
*  LOOP AT IT_TAM2 INTO WA_TAM2.
*    WRITE: / WA_TAM2-ZPERNR,WA_TAM2-USRID_LONG.
*  ENDLOOP.
*  SORT IT_TAM2 BY ZPERNR.
*  DELETE ADJACENT DUPLICATES FROM IT_TAM2 COMPARING ZPERNR.
*
*  LOOP AT IT_TAD1 INTO WA_TAD1.
*    CLEAR : BC,BCL,XL,LS.
**      WRITE : / '*',WA_TAD1-REG, WA_TAD1-ZM, WA_TAD1-RM, WA_TAD1-BZIRK,WA_TAD1-PLANS, WA_TAD1-SVAL,WA_TAD1-ACN_VAL, WA_TAD1-OTH_VAL, WA_TAD1-NET.
*    WA_TAD2-REG = WA_TAD1-REG.
*    WA_TAD2-ZM = WA_TAD1-ZM.
*    WA_TAD2-RM = WA_TAD1-RM.
*    WA_TAD2-ZPERNR = WA_TAD1-ZPERNR.
*    WA_TAD2-BZIRK = WA_TAD1-BZIRK.
*    WA_TAD2-PLANS = WA_TAD1-PLANS.
*    WA_TAD2-SVAL = WA_TAD1-SVAL.
*    WA_TAD2-ACN_VAL = WA_TAD1-ACN_VAL.
*    WA_TAD2-OTH_VAL = WA_TAD1-OTH_VAL.
*    WA_TAD2-NET = WA_TAD1-NET.
**    READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD1-PLANS SPART = '50'.
**    IF SY-SUBRC EQ 0.
***      bc = 1.
**      READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD1-PLANS SPART = '60'.
**      IF SY-SUBRC EQ 0.
**        BCL = 1.
**      ELSE.
**        BC = 1.
**      ENDIF.
**    ELSE.
**      READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD1-PLANS SPART = '60'.
**      IF SY-SUBRC EQ 0.
**        XL = 1.
**      ENDIF.
**    ENDIF.
*    CLEAR : DCOUNT.
*    READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD1-PLANS SPART = '50'.
*    IF SY-SUBRC EQ 0.
*      BC = 1.
*      DCOUNT = DCOUNT + 1.
*    ENDIF.
*    READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD1-PLANS SPART = '60'.
*    IF SY-SUBRC EQ 0.
*      XL = 1.
*      DCOUNT = DCOUNT + 1.
*    ENDIF.
*    READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD1-PLANS SPART = '70'.
*    IF SY-SUBRC EQ 0.
*      LS = 1.
*      DCOUNT = DCOUNT + 1.
*    ENDIF.
*    IF DCOUNT GT 1.
*      BCL = 1.
*    ENDIF.
*
*    IF BC EQ 1.
**        WRITE :  'DIVISION IS BCL'.
*      WA_TAD2-DIV = 'BC'.
*    ELSEIF XL EQ 1.
**        WRITE :  'DIVISION IS XL'.
*      WA_TAD2-DIV = 'XL'.
*    ELSEIF LS EQ 1.
**        WRITE :  'DIVISION IS XL'.
*      WA_TAD2-DIV = 'LS'.
*    ELSE.
**        WRITE :  'DIVISION IS BC'.
*      WA_TAD2-DIV = 'BCL'.
*    ENDIF.
*    SELECT SINGLE * FROM YSD_DIST_TARGT WHERE BZIRK EQ WA_TAD1-BZIRK AND TRGYEAR EQ YEAR1.
*    IF SY-SUBRC EQ 0.
*      IF MONTH EQ '04'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH01.
*      ELSEIF MONTH EQ '05'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH02.
*      ELSEIF MONTH EQ '06'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH03.
*      ELSEIF MONTH EQ '07'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH04.
*      ELSEIF MONTH EQ '08'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH05.
*      ELSEIF MONTH EQ '09'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH06.
*      ELSEIF MONTH EQ '10'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH07.
*      ELSEIF MONTH EQ '11'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH08.
*      ELSEIF MONTH EQ '12'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH09.
*      ELSEIF MONTH EQ '01'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH10.
*      ELSEIF MONTH EQ '02'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH11.
*      ELSEIF MONTH EQ '03'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH12.
*      ENDIF.
*
*      IF MONTH EQ '04'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH01.
*      ELSEIF MONTH EQ '05'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH02.
*      ELSEIF MONTH EQ '06'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH03.
*      ELSEIF MONTH EQ '07'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH04.
*      ELSEIF MONTH EQ '08'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH05.
*      ELSEIF MONTH EQ '09'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH06.
*      ELSEIF MONTH EQ '10'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH07.
*      ELSEIF MONTH EQ '11'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH08.
*      ELSEIF MONTH EQ '12'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH09.
*      ELSEIF MONTH EQ '01'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH10.
*      ELSEIF MONTH EQ '02'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH11.
*      ELSEIF MONTH EQ '03'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH12.
*      ENDIF.
*    ELSE.
*      SELECT SINGLE * FROM YSD_HBE_TARGT WHERE BZIRK EQ WA_TAD1-BZIRK AND TRGYEAR EQ YEAR1.
*      IF SY-SUBRC EQ 0.
*        IF MONTH EQ '04'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH01.
*        ELSEIF MONTH EQ '05'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH02.
*        ELSEIF MONTH EQ '06'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH03.
*        ELSEIF MONTH EQ '07'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH04.
*        ELSEIF MONTH EQ '08'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH05.
*        ELSEIF MONTH EQ '09'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH06.
*        ELSEIF MONTH EQ '10'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH07.
*        ELSEIF MONTH EQ '11'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH08.
*        ELSEIF MONTH EQ '12'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH09.
*        ELSEIF MONTH EQ '01'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH10.
*        ELSEIF MONTH EQ '02'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH11.
*        ELSEIF MONTH EQ '03'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH12.
*        ENDIF.
*      ENDIF.
*    ENDIF.
*
*
*    COLLECT WA_TAD2 INTO IT_TAD2.
*    CLEAR WA_TAD2.
*  ENDLOOP.
*
*  LOOP AT IT_TAD2 INTO WA_TAD2.
*    IF DV1 EQ 'X'.
*      DELETE IT_TAD2 WHERE DIV = 'XL'.
*      DELETE IT_TAD2 WHERE DIV = 'LS'.
*    ELSEIF DV2 EQ 'X'.
*      DELETE IT_TAD2 WHERE DIV = 'BC'.
*      DELETE IT_TAD2 WHERE DIV = 'BCL'.
*      DELETE IT_TAD2 WHERE DIV = 'LS'.
*    ELSEIF DV4 EQ 'X'.
*      DELETE IT_TAD2 WHERE DIV = 'BC'.
*      DELETE IT_TAD2 WHERE DIV = 'BCL'.
*      DELETE IT_TAD2 WHERE DIV = 'XL'.
*    ENDIF.
*  ENDLOOP.
*
*
*  LOOP AT IT_TAD2 INTO WA_TAD2.
**      WRITE : / '**',WA_TAD2-REG,WA_TAD2-BZIRK, WA_TAD2-DIV,wa_tad2-net.
*    WA_TAD3-REG = WA_TAD2-REG.
*    WA_TAD3-BZIRK = WA_TAD2-BZIRK.
*    WA_TAD3-DIV = WA_TAD2-DIV.
*    COLLECT WA_TAD3 INTO IT_TAD3.
*    CLEAR WA_TAD3.
*    WA_TAD21-REG = WA_TAD2-REG.
*    WA_TAD21-DIV = WA_TAD2-DIV.
*    WA_TAD21-NET = WA_TAD2-NET.
*    COLLECT WA_TAD21 INTO IT_TAD21.
*    CLEAR WA_TAD21.
**       WA_TAD2-ZM, WA_TAD2-RM,  WA_TAD2-PLANS, WA_TAD2-SVAL, WA_TAD2-ACN_VAL, WA_TAD2-OTH_VAL, WA_TAD2-NET,,WA_TAD2-TARGT.
*  ENDLOOP.
*  SORT IT_TAD21 BY REG DIV.
**    LOOP at it_tad21 INTO wa_tad21.
***      WRITE : /'**', wa_tad21-reg,wa_tad21-div,wa_tad21-net.
**    ENDLOOP.
*
*  SORT IT_TAD3 BY REG DIV.
*  LOOP AT IT_TAD3 INTO WA_TAD3.
*    ON CHANGE OF WA_TAD3-REG.
*      COUNT1 = 1.
*    ENDON.
*    ON CHANGE OF WA_TAD3-DIV.
*      COUNT1 = 1.
*    ENDON.
**      WRITE : / WA_TAD3-REG,WA_TAD3-BZIRK,WA_TAD3-DIV,COUNT1.
*
*    WA_TAD4-REG = WA_TAD3-REG.
*    WA_TAD4-DIV = WA_TAD3-DIV.
*    WA_TAD4-COUNT = COUNT1.
*    APPEND WA_TAD4 TO IT_TAD4.
*    CLEAR WA_TAD4.
*    COUNT1 = COUNT1 + 1.
*  ENDLOOP.
*  SORT IT_TAD4 DESCENDING BY COUNT.
*
**    ULINE.
**    LOOP AT IT_TAD4 INTO WA_TAD4.
**      WRITE : / 'FINAL', WA_TAD4-REG,WA_TAD4-DIV,WA_TAD4-COUNT.
**    ENDLOOP.
*  OPTIONS-TDGETOTF = 'X'.
*
*  SORT IT_TAD2 BY REG ZM RM BZIRK.
*  IF IT_TAD2 IS INITIAL.
*    MESSAGE 'NO DATA FOUND FOR THIS DIVISION' TYPE 'E'.
*    EXIT.
*  ENDIF.
*  LOOP AT IT_TAM1 INTO WA_TAM1.
*    CALL FUNCTION 'OPEN_FORM'
*      EXPORTING
*        DEVICE   = 'PRINTER'
*        DIALOG   = ''
**       form     = 'ZSR9_1'
*        LANGUAGE = SY-LANGU
*        OPTIONS  = OPTIONS
*      EXCEPTIONS
*        CANCELED = 1
*        DEVICE   = 2.
*    IF SY-SUBRC <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.
*    CALL FUNCTION 'START_FORM'
*      EXPORTING
*        FORM        = 'ZSR9_1'
*        LANGUAGE    = SY-LANGU
*      EXCEPTIONS
*        FORM        = 1
*        FORMAT      = 2
*        UNENDED     = 3
*        UNOPENED    = 4
*        UNUSED      = 5
*        SPOOL_ERROR = 6
*        CODEPAGE    = 7
*        OTHERS      = 8.
*    IF SY-SUBRC <> 0.
*      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.
*    PAGE1 = 0.
*    PAGE2 = 0.
*
*    SELECT * FROM PA0001 INTO TABLE IT_PA0001_1 FOR ALL ENTRIES IN IT_TAD2 WHERE PLANS EQ IT_TAD2-PLANS AND ZZ_HQCODE NE '     '.
*    SORT IT_PA0001_1 BY ENDDA DESCENDING.
*
*    LOOP AT IT_TAD2 INTO WA_TAD2 WHERE ZPERNR = WA_TAM1-ZPERNR..
*      CLEAR : JO_DT1,STP,C_BCL,C_BC,C_XL,C_LS,ZJO_DT.
**      WRITE : / WA_TAD2-REG, WA_TAD2-ZM, WA_TAD2-RM, WA_TAD2-BZIRK,WA_TAD2-DIV,WA_TAD2-PLANS, WA_TAD2-SVAL,
**      WA_TAD2-ACN_VAL, WA_TAD2-OTH_VAL, WA_TAD2-NET,wa_tad2-targt.
*      ON CHANGE OF WA_TAD2-RM.
*        NEW-PAGE.
*        PAGE1 = 1.
*        FORMAT COLOR 3.
**        WRITE : /1 'ZM',6 '*'.
*        READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY REG = WA_TAD2-REG.
*        IF SY-SUBRC EQ 0 AND WA_TAC7-ZPERNR NE 0.
**          WRITE : 20 WA_TAC7-ZENAME,35 WA_TAC7-ZZZ_HQDESC.
*          ZM_NAME = WA_TAC7-ZENAME.
*        ELSE.
*          ZM_NAME = 'VACANT'.
*        ENDIF.
*        PAGE3 = PAGE1 + PAGE2.
*        PAGE4 = PAGE3.
*        IF PAGE3 GT 1.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'HEAD1'
*              WINDOW  = 'MAIN'.
*        ELSE.
**          WRITE : /20 'VACANT'.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'HEAD2'
*              WINDOW  = 'MAIN'.
*        ENDIF.
*        PAGE1 = PAGE1 + 1.
*        PAGE2 = PAGE2 + 1.
**        ULINE.
**        WRITE : /1 'NAME',17 'H.Q.',34 'D.O.J.',50 'DIV',57 'SALES',78 'TARGET'.
**        SKIP.
*        CALL FUNCTION 'WRITE_FORM'
*          EXPORTING
*            ELEMENT = 'HEAD3'
*            WINDOW  = 'MAIN'.
*      ENDON.
*      FORMAT COLOR 1.
*      READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD2-PLANS.
*      IF SY-SUBRC EQ 0 AND WA_TAC7-BEGDA NE 0.
*        CONCATENATE WA_TAC7-BEGDA+4(2) '/' WA_TAC7-BEGDA+0(4) INTO JO_DT1.
**        WRITE : /1(15) WA_TAC7-ENAME,17(15) WA_TAC7-ZZ_HQDESC,34 JO_DT1,43(5) WA_TAC7-SHORT.
*
*        CALL FUNCTION 'WRITE_FORM'
*          EXPORTING
*            ELEMENT = 'T1'
*            WINDOW  = 'MAIN'.
*      ELSE.
**        WRITE : /1(15) 'VACANT',wa_tad2-plans.
**          READ TABLE IT_pa0001_1 INTO WA_PA0001_1 WITH KEY plans = wa_tad2-plans .
*        SELECT SINGLE * FROM ZDRPHQ WHERE BZIRK EQ WA_TAD2-BZIRK.
*        IF SY-SUBRC EQ 0.
*          SELECT SINGLE * FROM ZTHR_HEQ_DES WHERE ZZ_HQCODE EQ ZDRPHQ-ZZ_HQCODE.
*          IF SY-SUBRC EQ 0.
*            CLEAR : HQCODE.
**          WRITE : zthr_heq_des-zz_hqdesc.
*            HQCODE = ZTHR_HEQ_DES-ZZ_HQDESC.
*          ENDIF.
*        ENDIF.
*        CALL FUNCTION 'WRITE_FORM'
*          EXPORTING
*            ELEMENT = 'T2'
*            WINDOW  = 'MAIN'.
*      ENDIF.
**      WRITE : 50(3) WA_TAD2-DIV,55(13) WA_TAD2-NET,70(15) wa_tad2-targt.
*      IF WA_TAD2-TARGT GT 0.
*        STP = ( WA_TAD2-NET / WA_TAD2-TARGT ) * 100.
*      ENDIF.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'T3'
*          WINDOW  = 'MAIN'.
*      RMTOT = RMTOT + WA_TAD2-NET.
*      ZMTOT = ZMTOT + WA_TAD2-NET.
*      RMTAR = RMTAR + WA_TAD2-TARGT.
*      ZMTAR = ZMTAR + WA_TAD2-TARGT.
*      FORMAT COLOR 4.
*      AT END OF RM.
*        CLEAR : RJO_DT.
**        ULINE.
*        READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY RM = WA_TAD2-RM.
*        IF SY-SUBRC EQ 0 AND WA_TAC7-RPERNR NE 0.
**          WRITE : /1(15) WA_TAC7-RENAME,17(15) WA_TAC7-RZZ_HQDESC,43(5) WA_TAC7-RSHORT,wa_tac7-rbegda.
*          CONCATENATE WA_TAC7-RBEGDA+4(2) '/' WA_TAC7-RBEGDA+0(4) INTO RJO_DT.
**          WRITE : / 'rjo_dt',rjo_dt.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'R1'
*              WINDOW  = 'MAIN'.
*        ELSE.
**          WRITE : / 'VACANT'.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'R2'
*              WINDOW  = 'MAIN'.
*        ENDIF.
**        WRITE : 55(13) rmtot,70(15) rmtar.
*        IF RMTAR NE 0.
*          RSTP = ( RMTOT / RMTAR ) * 100.
*        ENDIF.
*        CALL FUNCTION 'WRITE_FORM'
*          EXPORTING
*            ELEMENT = 'R3'
*            WINDOW  = 'MAIN'.
*        RMTOT = 0.
*        RMTAR = 0.
*        RSTP = 0.
**        ULINE.
*      ENDAT.
*
*    ENDLOOP.
*    CALL FUNCTION 'END_FORM'
*      EXCEPTIONS
*        UNOPENED                 = 1
*        BAD_PAGEFORMAT_FOR_PRINT = 2
*        SPOOL_ERROR              = 3
*        CODEPAGE                 = 4
*        OTHERS                   = 5.
*    IF SY-SUBRC <> 0.
*      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.
*    CALL FUNCTION 'CLOSE_FORM'
*      IMPORTING
*        RESULT  = RESULT
*      TABLES
*        OTFDATA = L_OTF_DATA.
*
*    CALL FUNCTION 'CONVERT_OTF'
*      EXPORTING
*        FORMAT       = 'PDF'
*      IMPORTING
*        BIN_FILESIZE = L_BIN_FILESIZE
*      TABLES
*        OTF          = L_OTF_DATA
*        LINES        = L_ASC_DATA.
*
*    CALL FUNCTION 'SX_TABLE_LINE_WIDTH_CHANGE'
*      EXPORTING
*        LINE_WIDTH_DST = '255'
*      TABLES
*        CONTENT_IN     = L_ASC_DATA
*        CONTENT_OUT    = OBJBIN.
*
*    WRITE S_BUDAT1 TO WA_D1 DD/MM/YYYY.
*    WRITE S_BUDAT2 TO WA_D2 DD/MM/YYYY.
*
*    DESCRIBE TABLE OBJBIN LINES RIGHE_ATTACHMENT.
*    OBJTXT = 'This eMail is meant for information only. Please DO NOT REPLY'.APPEND OBJTXT.
*    OBJTXT = '                                 '.APPEND OBJTXT.
*    OBJTXT = 'BLUE CROSS LABORATORIES LTD.'.APPEND OBJTXT.
*    DESCRIBE TABLE OBJTXT LINES RIGHE_TESTO.
*    DOC_CHNG-OBJ_NAME = 'URGENT'.
*    DOC_CHNG-EXPIRY_DAT = SY-DATUM + 10.
*    CONDENSE LTX.
*    CONDENSE OBJTXT.
**      CONCATENATE 'SR9 for the period' ltx '-' INTO doc_chng-obj_descr SEPARATED BY space.
*    CONCATENATE 'SR9 for the period of: ' WA_D1 'to' WA_D2 INTO DOC_CHNG-OBJ_DESCR SEPARATED BY SPACE.
*    DOC_CHNG-SENSITIVTY = 'F'.
*    DOC_CHNG-DOC_SIZE = RIGHE_TESTO * 255 .
*
*    CLEAR OBJPACK-TRANSF_BIN.
*
*    OBJPACK-HEAD_START = 1.
*    OBJPACK-HEAD_NUM = 0.
*    OBJPACK-BODY_START = 1.
*    OBJPACK-BODY_NUM = 4.
*    OBJPACK-DOC_TYPE = 'TXT'.
*    APPEND OBJPACK.
*
*    OBJPACK-TRANSF_BIN = 'X'.
*    OBJPACK-HEAD_START = 1.
*    OBJPACK-HEAD_NUM = 0.
*    OBJPACK-BODY_START = 1.
*    OBJPACK-BODY_NUM = RIGHE_ATTACHMENT.
*    OBJPACK-DOC_TYPE = 'PDF'.
*    OBJPACK-OBJ_NAME = 'TEST'.
*    CONDENSE LTX.
*
*
*
**      CONCATENATE 'SR9 ' ltx  'FOR THE PERIOD' wa_d1 'TO' wa_d2 INTO objpack-obj_descr SEPARATED BY space.
*    CONCATENATE 'SR-9' '.' INTO OBJPACK-OBJ_DESCR SEPARATED BY SPACE.
*    OBJPACK-DOC_SIZE = RIGHE_ATTACHMENT * 255.
*    APPEND OBJPACK.
*    CLEAR OBJPACK.
*
*    LOOP AT IT_TAM2 INTO WA_TAM2 WHERE ZPERNR = WA_TAD2-ZPERNR.
**    READ TABLE it_mail1 INTO wa_mail1 WITH KEY lifnr = wa_tab4-lifnr.
**    IF sy-subrc EQ 0.
**      MESSAGE 'EMAIL SENT' TYPE 'I'.
**  loop at it_mail1 into wa_mail1.
*      RECLIST-RECEIVER =   WA_TAM2-USRID_LONG.
*      RECLIST-EXPRESS = 'X'.
*      RECLIST-REC_TYPE = 'U'.
*      RECLIST-NOTIF_DEL = 'X'. " request delivery notification
*      RECLIST-NOTIF_NDEL = 'X'. " request not delivered notification
*      APPEND RECLIST.
*      CLEAR RECLIST.
**  endif.
*    ENDLOOP.
*
*    DESCRIBE TABLE RECLIST LINES MCOUNT.
*    IF MCOUNT > 0.
*      DATA: SENDER LIKE SOEXTRECI1-RECEIVER.
***ADDED BY SATHISH.B
*      TYPES: BEGIN OF T_USR21,
*               BNAME      TYPE USR21-BNAME,
*               PERSNUMBER TYPE USR21-PERSNUMBER,
*               ADDRNUMBER TYPE USR21-ADDRNUMBER,
*             END OF T_USR21.
*
*      TYPES: BEGIN OF T_ADR6,
*               ADDRNUMBER TYPE USR21-ADDRNUMBER,
*               PERSNUMBER TYPE USR21-PERSNUMBER,
*               SMTP_ADDR  TYPE ADR6-SMTP_ADDR,
*             END OF T_ADR6.
*
*      DATA: IT_USR21 TYPE TABLE OF T_USR21,
*            WA_USR21 TYPE T_USR21,
*            IT_ADR6  TYPE TABLE OF T_ADR6,
*            WA_ADR6  TYPE T_ADR6.
*      SELECT  BNAME PERSNUMBER ADDRNUMBER FROM USR21 INTO TABLE IT_USR21
*      WHERE BNAME = SY-UNAME.
*      IF SY-SUBRC = 0.
*        SELECT ADDRNUMBER PERSNUMBER SMTP_ADDR FROM ADR6 INTO TABLE IT_ADR6
*          FOR ALL ENTRIES IN IT_USR21 WHERE ADDRNUMBER = IT_USR21-ADDRNUMBER
*        AND   PERSNUMBER = IT_USR21-PERSNUMBER.
*      ENDIF.
*
*      LOOP AT IT_USR21 INTO WA_USR21.
*        READ TABLE IT_ADR6 INTO WA_ADR6 WITH KEY ADDRNUMBER = WA_USR21-ADDRNUMBER.
*        IF SY-SUBRC = 0.
*          SENDER = WA_ADR6-SMTP_ADDR.
*        ENDIF.
*      ENDLOOP.
*      CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
*        EXPORTING
*          DOCUMENT_DATA              = DOC_CHNG
*          PUT_IN_OUTBOX              = 'X'
*          SENDER_ADDRESS             = SENDER
*          SENDER_ADDRESS_TYPE        = 'SMTP'
**         COMMIT_WORK                = ' '
** IMPORTING
**         SENT_TO_ALL                =
**         NEW_OBJECT_ID              =
**         SENDER_ID                  =
*        TABLES
*          PACKING_LIST               = OBJPACK
**         OBJECT_HEADER              =
*          CONTENTS_BIN               = OBJBIN
*          CONTENTS_TXT               = OBJTXT
**         CONTENTS_HEX               =
**         OBJECT_PARA                =
**         OBJECT_PARB                =
*          RECEIVERS                  = RECLIST
*        EXCEPTIONS
*          TOO_MANY_RECEIVERS         = 1
*          DOCUMENT_NOT_SENT          = 2
*          DOCUMENT_TYPE_NOT_EXIST    = 3
*          OPERATION_NO_AUTHORIZATION = 4
*          PARAMETER_ERROR            = 5
*          X_ERROR                    = 6
*          ENQUEUE_ERROR              = 7
*          OTHERS                     = 8.
*      IF SY-SUBRC <> 0.
*        MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*      ENDIF.
*
*      COMMIT WORK.
*
*      IF SY-SUBRC EQ 0.
*        WRITE : / 'EMAIL SENT ON ',WA_TAM2-USRID_LONG.
*      ENDIF.
*
***modid ver1.0 starts
*
*      CLEAR   : OBJPACK,
*                OBJHEAD,
*                OBJTXT,
*                OBJBIN,
*                RECLIST.
*
*      REFRESH : OBJPACK,
*                OBJHEAD,
*                OBJTXT,
*                OBJBIN,
*                RECLIST.
*
*    ENDIF.
*
*  ENDLOOP.
**    DATA : a TYPE i VALUE 0.
*  LOOP AT IT_TAM1 INTO WA_TAM1.
*    READ TABLE IT_TAM2 INTO WA_TAM2 WITH KEY  ZPERNR = WA_TAM1-ZPERNR .
*    IF SY-SUBRC EQ 4.
*      FORMAT COLOR 6.
*      WRITE : / 'EMAIL ID NOT MAINTAINED FOR EMP. CODE :',WA_TAM1-ZPERNR.
*    ENDIF.
*  ENDLOOP.

ENDFORM.                    "RMEMAIL



*&---------------------------------------------------------------------*
*&      Form  DZMEMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM dzmemail.

  PERFORM sfformdet.
*  PERFORM SFFORM1.

  LOOP AT it_tac7 INTO wa_tac7.
    SELECT SINGLE * FROM pa0105 WHERE pernr EQ wa_tac7-dzpernr AND subty EQ '0010'.
    IF sy-subrc EQ 0.
      wa_dzmemail-reg = wa_tac7-reg.
      wa_dzmemail-zm = wa_tac7-zm.
      wa_dzmemail-usrid_long = pa0105-usrid_long.
      COLLECT wa_dzmemail INTO it_dzmemail.
      CLEAR wa_dzmemail.
    ENDIF.
  ENDLOOP.
  SORT it_dzmemail BY reg zm.
  DELETE ADJACENT DUPLICATES FROM it_dzmemail COMPARING reg zm.
  DELETE it_dzmemail WHERE zm EQ space.
*  PERFORM SFFORM2.
  PERFORM dzsfform2.


*  LOOP AT IT_TAC7 INTO WA_TAC7 WHERE ZM NE SPACE.
*    WA_CHECK2-ZM = WA_TAC7-ZM.
*    WA_CHECK2-REG = WA_TAC7-REG.
*    WA_CHECK2-ZONENAME = WA_TAC7-ZZZ_HQDESC.
*    COLLECT WA_CHECK2 INTO IT_CHECK2.
*    CLEAR WA_CHECK2.
*  ENDLOOP.
*
*  PERFORM SFFORMDET.
**  PERFORM SFFORM1.
*
*  LOOP AT IT_TAC7 INTO WA_TAC7 WHERE ZM NE SPACE.
*    SELECT SINGLE * FROM PA0105 WHERE PERNR EQ WA_TAC7-DZPERNR AND SUBTY EQ '0010'.
*    IF SY-SUBRC EQ 0.
*      WA_DZMEMAIL-ZM = WA_TAC7-ZM.
*      WA_DZMEMAIL-REG = WA_TAC7-REG.
*      WA_DZMEMAIL-USRID_LONG = PA0105-USRID_LONG.
*      COLLECT WA_DZMEMAIL INTO IT_DZMEMAIL.
*      CLEAR WA_DZMEMAIL.
*    ENDIF.
*  ENDLOOP.
*  SORT IT_DZMEMAIL BY REG ZM.
*  DELETE ADJACENT DUPLICATES FROM IT_DZMEMAIL COMPARING REG ZM.
**  PERFORM SFFORM2.
*  PERFORM SFFORM5.


**  elseif r4 eq 'X'.  "FOR RM EMAIL
*
*
*
**    WRITE : / 'LAYOUT'.
*  SORT IT_TAC7 BY REG ZM RM BZIRK SPART.
*  LOOP AT IT_TAC7 INTO WA_TAC7 WHERE ZM NE '      '.
**      WRITE : / 'A',WA_TAC7-TEXT, WA_TAC7-REG,WA_TAC7-spart,WA_TAC7-ZM,WA_TAC7-RM,WA_TAC7-BZIRK,WA_TAC7-sval,wa_TAC7-acn_val,WA_TAC7-OTH_VAL,
**        wa_TAC7-net, wa_TAC7-PLANS,wa_TAC7-ENAME,wa_TAC7-zz_hqdesc,wa_TAC7-SHORT,wa_TAC7-BEGDA,WA_TAC7-RENAME,WA_TAC7-RZZ_HQDESC,
**        WA_TAC7-RSHORT, WA_TAC7-DZENAME,WA_TAC7-DZZZ_HQDESC, WA_TAC7-DZSHORT,WA_TAC7-ZENAME,WA_TAC7-ZZZ_HQDESC, WA_TAC7-ZSHORT.
*    WA_TAD1-REG = WA_TAC7-REG.
*    WA_TAD1-ZM = WA_TAC7-ZM.
*    WA_TAD1-RM = WA_TAC7-RM.
*    WA_TAD1-ZPERNR = WA_TAC7-DZPERNR.
*    WA_TAD1-BZIRK = WA_TAC7-BZIRK.
*    WA_TAD1-PLANS = WA_TAC7-PLANS.
*    WA_TAD1-SVAL = WA_TAC7-SVAL.
*    WA_TAD1-ACN_VAL = WA_TAC7-ACN_VAL.
*    WA_TAD1-OTH_VAL = WA_TAC7-OTH_VAL.
*    WA_TAD1-NET = WA_TAC7-NET.
*    COLLECT WA_TAD1 INTO IT_TAD1.
*    CLEAR WA_TAD1.
*
*    WA_TAM1-ZPERNR = WA_TAC7-DZPERNR.
*    COLLECT WA_TAM1 INTO IT_TAM1.
*    CLEAR WA_TAM1.
*  ENDLOOP.
**    ULINE.
**************RM EMAIL******
*  DELETE IT_TAM1 WHERE ZPERNR EQ 0.
*
*  LOOP AT IT_TAM1 INTO WA_TAM1.
*    SELECT SINGLE * FROM PA0105 WHERE PERNR EQ WA_TAM1-ZPERNR AND SUBTY EQ '0010'.
*    IF SY-SUBRC EQ 0.
*      WA_TAM2-ZPERNR = WA_TAM1-ZPERNR.
*      WA_TAM2-USRID_LONG = PA0105-USRID_LONG.
*      COLLECT WA_TAM2 INTO IT_TAM2.
*      CLEAR WA_TAM2.
*    ENDIF.
*  ENDLOOP.
*
*  LOOP AT IT_TAM2 INTO WA_TAM2.
*    WRITE: / WA_TAM2-ZPERNR,WA_TAM2-USRID_LONG.
*  ENDLOOP.
*  SORT IT_TAM2 BY ZPERNR.
*  DELETE ADJACENT DUPLICATES FROM IT_TAM2 COMPARING ZPERNR.
*
*  LOOP AT IT_TAD1 INTO WA_TAD1.
*    CLEAR : BC,BCL,XL,LS.
**      WRITE : / '*',WA_TAD1-REG, WA_TAD1-ZM, WA_TAD1-RM, WA_TAD1-BZIRK,WA_TAD1-PLANS, WA_TAD1-SVAL,WA_TAD1-ACN_VAL, WA_TAD1-OTH_VAL, WA_TAD1-NET.
*    WA_TAD2-REG = WA_TAD1-REG.
*    WA_TAD2-ZM = WA_TAD1-ZM.
*    WA_TAD2-RM = WA_TAD1-RM.
*    WA_TAD2-ZPERNR = WA_TAD1-ZPERNR.
*    WA_TAD2-BZIRK = WA_TAD1-BZIRK.
*    WA_TAD2-PLANS = WA_TAD1-PLANS.
*    WA_TAD2-SVAL = WA_TAD1-SVAL.
*    WA_TAD2-ACN_VAL = WA_TAD1-ACN_VAL.
*    WA_TAD2-OTH_VAL = WA_TAD1-OTH_VAL.
*    WA_TAD2-NET = WA_TAD1-NET.
**    READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD1-PLANS SPART = '50'.
**    IF SY-SUBRC EQ 0.
***      bc = 1.
**      READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD1-PLANS SPART = '60'.
**      IF SY-SUBRC EQ 0.
**        BCL = 1.
**      ELSE.
**        BC = 1.
**      ENDIF.
**    ELSE.
**      READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD1-PLANS SPART = '60'.
**      IF SY-SUBRC EQ 0.
**        XL = 1.
**      ENDIF.
**    ENDIF.
*    CLEAR : DCOUNT.
*    READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD1-PLANS SPART = '50'.
*    IF SY-SUBRC EQ 0.
*      BC = 1.
*      DCOUNT = DCOUNT + 1.
*    ENDIF.
*    READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD1-PLANS SPART = '60'.
*    IF SY-SUBRC EQ 0.
*      XL = 1.
*      DCOUNT = DCOUNT + 1.
*    ENDIF.
*    READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD1-PLANS SPART = '70'.
*    IF SY-SUBRC EQ 0.
*      LS = 1.
*      DCOUNT = DCOUNT + 1.
*    ENDIF.
*    IF DCOUNT GT 1.
*      BCL = 1.
*    ENDIF.
*
*    IF BC EQ 1.
**        WRITE :  'DIVISION IS BCL'.
*      WA_TAD2-DIV = 'BC'.
*    ELSEIF XL EQ 1.
**        WRITE :  'DIVISION IS XL'.
*      WA_TAD2-DIV = 'XL'.
*    ELSEIF LS EQ 1.
**        WRITE :  'DIVISION IS XL'.
*      WA_TAD2-DIV = 'LS'.
*    ELSE.
**        WRITE :  'DIVISION IS BC'.
*      WA_TAD2-DIV = 'BCL'.
*    ENDIF.
*    SELECT SINGLE * FROM YSD_DIST_TARGT WHERE BZIRK EQ WA_TAD1-BZIRK AND TRGYEAR EQ YEAR1.
*    IF SY-SUBRC EQ 0.
*      IF MONTH EQ '04'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH01.
*      ELSEIF MONTH EQ '05'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH02.
*      ELSEIF MONTH EQ '06'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH03.
*      ELSEIF MONTH EQ '07'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH04.
*      ELSEIF MONTH EQ '08'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH05.
*      ELSEIF MONTH EQ '09'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH06.
*      ELSEIF MONTH EQ '10'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH07.
*      ELSEIF MONTH EQ '11'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH08.
*      ELSEIF MONTH EQ '12'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH09.
*      ELSEIF MONTH EQ '01'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH10.
*      ELSEIF MONTH EQ '02'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH11.
*      ELSEIF MONTH EQ '03'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH12.
*      ENDIF.
*
*      IF MONTH EQ '04'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH01.
*      ELSEIF MONTH EQ '05'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH02.
*      ELSEIF MONTH EQ '06'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH03.
*      ELSEIF MONTH EQ '07'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH04.
*      ELSEIF MONTH EQ '08'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH05.
*      ELSEIF MONTH EQ '09'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH06.
*      ELSEIF MONTH EQ '10'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH07.
*      ELSEIF MONTH EQ '11'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH08.
*      ELSEIF MONTH EQ '12'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH09.
*      ELSEIF MONTH EQ '01'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH10.
*      ELSEIF MONTH EQ '02'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH11.
*      ELSEIF MONTH EQ '03'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH12.
*      ENDIF.
*    ELSE.
*      SELECT SINGLE * FROM YSD_HBE_TARGT WHERE BZIRK EQ WA_TAD1-BZIRK AND TRGYEAR EQ YEAR1.
*      IF SY-SUBRC EQ 0.
*        IF MONTH EQ '04'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH01.
*        ELSEIF MONTH EQ '05'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH02.
*        ELSEIF MONTH EQ '06'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH03.
*        ELSEIF MONTH EQ '07'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH04.
*        ELSEIF MONTH EQ '08'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH05.
*        ELSEIF MONTH EQ '09'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH06.
*        ELSEIF MONTH EQ '10'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH07.
*        ELSEIF MONTH EQ '11'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH08.
*        ELSEIF MONTH EQ '12'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH09.
*        ELSEIF MONTH EQ '01'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH10.
*        ELSEIF MONTH EQ '02'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH11.
*        ELSEIF MONTH EQ '03'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH12.
*        ENDIF.
*      ENDIF.
*    ENDIF.
*
**    SELECT SINGLE * FROM ZONESEQ WHERE ZONE_DIST EQ WA_TAD1-REG.
**    IF SY-SUBRC EQ 0.
**      WA_TAD2-SEQ = ZONESEQ-SEQ.
**    ENDIF.
*
*
*    COLLECT WA_TAD2 INTO IT_TAD2.
*    CLEAR WA_TAD2.
*  ENDLOOP.
*
*  LOOP AT IT_TAD2 INTO WA_TAD2.
*    IF DV1 EQ 'X'.
*      DELETE IT_TAD2 WHERE DIV = 'XL'.
*      DELETE IT_TAD2 WHERE DIV = 'LS'.
*    ELSEIF DV2 EQ 'X'.
*      DELETE IT_TAD2 WHERE DIV = 'BC'.
*      DELETE IT_TAD2 WHERE DIV = 'BCL'.
*      DELETE IT_TAD2 WHERE DIV = 'LS'.
*    ELSEIF DV4 EQ 'X'.
*      DELETE IT_TAD2 WHERE DIV = 'BC'.
*      DELETE IT_TAD2 WHERE DIV = 'BCL'.
*      DELETE IT_TAD2 WHERE DIV = 'XL'.
*    ENDIF.
*  ENDLOOP.
*
*
*  LOOP AT IT_TAD2 INTO WA_TAD2.
**      WRITE : / '**',WA_TAD2-REG,WA_TAD2-BZIRK, WA_TAD2-DIV,wa_tad2-net.
*    WA_TAD3-REG = WA_TAD2-REG.
*    WA_TAD3-BZIRK = WA_TAD2-BZIRK.
*    WA_TAD3-DIV = WA_TAD2-DIV.
*    COLLECT WA_TAD3 INTO IT_TAD3.
*    CLEAR WA_TAD3.
*    WA_TAD21-REG = WA_TAD2-REG.
*    WA_TAD21-DIV = WA_TAD2-DIV.
*    WA_TAD21-NET = WA_TAD2-NET.
*    COLLECT WA_TAD21 INTO IT_TAD21.
*    CLEAR WA_TAD21.
**       WA_TAD2-ZM, WA_TAD2-RM,  WA_TAD2-PLANS, WA_TAD2-SVAL, WA_TAD2-ACN_VAL, WA_TAD2-OTH_VAL, WA_TAD2-NET,,WA_TAD2-TARGT.
*  ENDLOOP.
*  SORT IT_TAD21 BY REG DIV.
**    LOOP at it_tad21 INTO wa_tad21.
***      WRITE : /'**', wa_tad21-reg,wa_tad21-div,wa_tad21-net.
**    ENDLOOP.
*
*  SORT IT_TAD3 BY REG DIV.
*  LOOP AT IT_TAD3 INTO WA_TAD3.
*    ON CHANGE OF WA_TAD3-REG.
*      COUNT1 = 1.
*    ENDON.
*    ON CHANGE OF WA_TAD3-DIV.
*      COUNT1 = 1.
*    ENDON.
**      WRITE : / WA_TAD3-REG,WA_TAD3-BZIRK,WA_TAD3-DIV,COUNT1.
*
*    WA_TAD4-REG = WA_TAD3-REG.
*    WA_TAD4-DIV = WA_TAD3-DIV.
*    WA_TAD4-COUNT = COUNT1.
*    APPEND WA_TAD4 TO IT_TAD4.
*    CLEAR WA_TAD4.
*    COUNT1 = COUNT1 + 1.
*  ENDLOOP.
*  SORT IT_TAD4 DESCENDING BY COUNT.
*
**    ULINE.
**    LOOP AT IT_TAD4 INTO WA_TAD4.
**      WRITE : / 'FINAL', WA_TAD4-REG,WA_TAD4-DIV,WA_TAD4-COUNT.
**    ENDLOOP.
*  OPTIONS-TDGETOTF = 'X'.
*
*  SORT IT_TAD2 BY REG ZM RM BZIRK.
*
*  IF IT_TAD2 IS INITIAL.
*    MESSAGE 'NO DATA FOUND FOR THIS DIVISION' TYPE 'E'.
*    EXIT.
*  ENDIF.
*
*  LOOP AT IT_TAM1 INTO WA_TAM1.
*    CALL FUNCTION 'OPEN_FORM'
*      EXPORTING
*        DEVICE   = 'PRINTER'
*        DIALOG   = ''
**       form     = 'ZSR9_1'
*        LANGUAGE = SY-LANGU
*        OPTIONS  = OPTIONS
*      EXCEPTIONS
*        CANCELED = 1
*        DEVICE   = 2.
*    IF SY-SUBRC <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.
*    CALL FUNCTION 'START_FORM'
*      EXPORTING
*        FORM        = 'ZSR9_1'
*        LANGUAGE    = SY-LANGU
*      EXCEPTIONS
*        FORM        = 1
*        FORMAT      = 2
*        UNENDED     = 3
*        UNOPENED    = 4
*        UNUSED      = 5
*        SPOOL_ERROR = 6
*        CODEPAGE    = 7
*        OTHERS      = 8.
*    IF SY-SUBRC <> 0.
*      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.
*    PAGE1 = 0.
*    PAGE2 = 0.
*
*    SELECT * FROM PA0001 INTO TABLE IT_PA0001_1 FOR ALL ENTRIES IN IT_TAD2 WHERE PLANS EQ IT_TAD2-PLANS AND ZZ_HQCODE NE '     '.
*    SORT IT_PA0001_1 BY ENDDA DESCENDING.
*
*    LOOP AT IT_TAD2 INTO WA_TAD2 WHERE ZPERNR = WA_TAM1-ZPERNR..
*      CLEAR : JO_DT1,STP,C_BCL,C_BC,C_XL,C_LS,ZJO_DT.
**      WRITE : / WA_TAD2-REG, WA_TAD2-ZM, WA_TAD2-RM, WA_TAD2-BZIRK,WA_TAD2-DIV,WA_TAD2-PLANS, WA_TAD2-SVAL,
**      WA_TAD2-ACN_VAL, WA_TAD2-OTH_VAL, WA_TAD2-NET,wa_tad2-targt.
*      ON CHANGE OF WA_TAD2-ZM.
*        NEW-PAGE.
*        PAGE1 = 1.
*        FORMAT COLOR 3.
**        WRITE : /1 'ZM',6 '*'.
*        READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY REG = WA_TAD2-REG.
*        IF SY-SUBRC EQ 0 AND WA_TAC7-ZPERNR NE 0.
**          WRITE : 20 WA_TAC7-ZENAME,35 WA_TAC7-ZZZ_HQDESC.
*          ZM_NAME = WA_TAC7-ZENAME.
*        ELSE.
*          ZM_NAME = 'VACANT'.
*        ENDIF.
*        PAGE3 = PAGE1 + PAGE2.
*        PAGE4 = PAGE3.
*        IF PAGE3 GT 1.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'HEAD1'
*              WINDOW  = 'MAIN'.
*        ELSE.
**          WRITE : /20 'VACANT'.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'HEAD2'
*              WINDOW  = 'MAIN'.
*        ENDIF.
*        PAGE1 = PAGE1 + 1.
*        PAGE2 = PAGE2 + 1.
**        ULINE.
**        WRITE : /1 'NAME',17 'H.Q.',34 'D.O.J.',50 'DIV',57 'SALES',78 'TARGET'.
**        SKIP.
*        CALL FUNCTION 'WRITE_FORM'
*          EXPORTING
*            ELEMENT = 'HEAD3'
*            WINDOW  = 'MAIN'.
*      ENDON.
*      FORMAT COLOR 1.
*      READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD2-PLANS.
*      IF SY-SUBRC EQ 0 AND WA_TAC7-BEGDA NE 0.
*        CONCATENATE WA_TAC7-BEGDA+4(2) '/' WA_TAC7-BEGDA+0(4) INTO JO_DT1.
**        WRITE : /1(15) WA_TAC7-ENAME,17(15) WA_TAC7-ZZ_HQDESC,34 JO_DT1,43(5) WA_TAC7-SHORT.
*
*        CALL FUNCTION 'WRITE_FORM'
*          EXPORTING
*            ELEMENT = 'T1'
*            WINDOW  = 'MAIN'.
*      ELSE.
**        WRITE : /1(15) 'VACANT',wa_tad2-plans.
**          READ TABLE IT_pa0001_1 INTO WA_PA0001_1 WITH KEY plans = wa_tad2-plans .
*        SELECT SINGLE * FROM ZDRPHQ WHERE BZIRK EQ WA_TAD2-BZIRK.
*        IF SY-SUBRC EQ 0.
*          SELECT SINGLE * FROM ZTHR_HEQ_DES WHERE ZZ_HQCODE EQ ZDRPHQ-ZZ_HQCODE.
*          IF SY-SUBRC EQ 0.
*            CLEAR : HQCODE.
**          WRITE : zthr_heq_des-zz_hqdesc.
*            HQCODE = ZTHR_HEQ_DES-ZZ_HQDESC.
*          ENDIF.
*        ENDIF.
*        CALL FUNCTION 'WRITE_FORM'
*          EXPORTING
*            ELEMENT = 'T2'
*            WINDOW  = 'MAIN'.
*      ENDIF.
**      WRITE : 50(3) WA_TAD2-DIV,55(13) WA_TAD2-NET,70(15) wa_tad2-targt.
*      IF WA_TAD2-TARGT GT 0.
*        STP = ( WA_TAD2-NET / WA_TAD2-TARGT ) * 100.
*      ENDIF.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'T3'
*          WINDOW  = 'MAIN'.
*      RMTOT = RMTOT + WA_TAD2-NET.
*      ZMTOT = ZMTOT + WA_TAD2-NET.
*      DZTOT = DZTOT + WA_TAD2-NET.
*      RMTAR = RMTAR + WA_TAD2-TARGT.
*      ZMTAR = ZMTAR + WA_TAD2-TARGT.
*      DZMTAR = DZMTAR + WA_TAD2-TARGT.
*************************************
*      IF WA_TAD2-RM NE '      '.
*        AT END OF RM.
*          CLEAR : RJO_DT.
**        ULINE.
*          READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY RM = WA_TAD2-RM.
*          IF SY-SUBRC EQ 0 AND WA_TAC7-RPERNR NE 0.
**          WRITE : /1(15) WA_TAC7-RENAME,17(15) WA_TAC7-RZZ_HQDESC,43(5) WA_TAC7-RSHORT,wa_tac7-rbegda.
*            CONCATENATE WA_TAC7-RBEGDA+4(2) '/' WA_TAC7-RBEGDA+0(4) INTO RJO_DT.
*          ENDIF.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'R1'
*              WINDOW  = 'MAIN'.
**          else.
***          WRITE : / 'VACANT'.
**            call function 'WRITE_FORM'
**              EXPORTING
**                element = 'R2'
**                window  = 'MAIN'.
**          endif.
**        WRITE : 55(13) rmtot,70(15) rmtar.
*          IF RMTAR NE 0.
*            RSTP = ( RMTOT / RMTAR ) * 100.
*          ENDIF.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'R3'
*              WINDOW  = 'MAIN'.
*          RMTOT = 0.
*          RMTAR = 0.
*          RSTP = 0.
**        ULINE.
*        ENDAT.
*      ENDIF.
***********************************
*      FORMAT COLOR 4.
*      AT END OF ZM.
*        CLEAR : DZJO_DT.
**        ULINE.
*        READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY ZM = WA_TAD2-ZM.
*        IF SY-SUBRC EQ 0 AND WA_TAC7-DZPERNR NE 0.
**          WRITE : /1(15) WA_TAC7-RENAME,17(15) WA_TAC7-RZZ_HQDESC,43(5) WA_TAC7-RSHORT,wa_tac7-rbegda.
*          CONCATENATE WA_TAC7-DZBEGDA+4(2) '/' WA_TAC7-DZBEGDA+0(4) INTO DZJO_DT.
**          WRITE : / 'rjo_dt',rjo_dt.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'DZM1'
*              WINDOW  = 'MAIN'.
*        ELSE.
**          WRITE : / 'VACANT'.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'DZM2'
*              WINDOW  = 'MAIN'.
*        ENDIF.
**        WRITE : 55(13) rmtot,70(15) rmtar.
*        IF DZMTAR NE 0.
*          DZMSTP = ( DZTOT / DZMTAR ) * 100.
*        ENDIF.
*        CALL FUNCTION 'WRITE_FORM'
*          EXPORTING
*            ELEMENT = 'DZM3'
*            WINDOW  = 'MAIN'.
*        DZTOT = 0.
*        DZMTAR = 0.
*        DZMSTP = 0.
**        ULINE.
*      ENDAT.
*
*    ENDLOOP.
*    CALL FUNCTION 'END_FORM'
*      EXCEPTIONS
*        UNOPENED                 = 1
*        BAD_PAGEFORMAT_FOR_PRINT = 2
*        SPOOL_ERROR              = 3
*        CODEPAGE                 = 4
*        OTHERS                   = 5.
*    IF SY-SUBRC <> 0.
*      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.
*    CALL FUNCTION 'CLOSE_FORM'
*      IMPORTING
*        RESULT  = RESULT
*      TABLES
*        OTFDATA = L_OTF_DATA.
*
*    CALL FUNCTION 'CONVERT_OTF'
*      EXPORTING
*        FORMAT       = 'PDF'
*      IMPORTING
*        BIN_FILESIZE = L_BIN_FILESIZE
*      TABLES
*        OTF          = L_OTF_DATA
*        LINES        = L_ASC_DATA.
*
*    CALL FUNCTION 'SX_TABLE_LINE_WIDTH_CHANGE'
*      EXPORTING
*        LINE_WIDTH_DST = '255'
*      TABLES
*        CONTENT_IN     = L_ASC_DATA
*        CONTENT_OUT    = OBJBIN.
*
*    WRITE S_BUDAT1 TO WA_D1 DD/MM/YYYY.
*    WRITE S_BUDAT2 TO WA_D2 DD/MM/YYYY.
*
*    DESCRIBE TABLE OBJBIN LINES RIGHE_ATTACHMENT.
*    OBJTXT = 'This eMail is meant for information only. Please DO NOT REPLY'.APPEND OBJTXT.
*    OBJTXT = '                                 '.APPEND OBJTXT.
*    OBJTXT = 'BLUE CROSS LABORATORIES LTD.'.APPEND OBJTXT.
*    DESCRIBE TABLE OBJTXT LINES RIGHE_TESTO.
*    DOC_CHNG-OBJ_NAME = 'URGENT'.
*    DOC_CHNG-EXPIRY_DAT = SY-DATUM + 10.
*    CONDENSE LTX.
*    CONDENSE OBJTXT.
**      CONCATENATE 'SR9 for the period' ltx '-' INTO doc_chng-obj_descr SEPARATED BY space.
*    CONCATENATE 'SR9 for the period of: ' WA_D1 'to' WA_D2 INTO DOC_CHNG-OBJ_DESCR SEPARATED BY SPACE.
*    DOC_CHNG-SENSITIVTY = 'F'.
*    DOC_CHNG-DOC_SIZE = RIGHE_TESTO * 255 .
*
*    CLEAR OBJPACK-TRANSF_BIN.
*
*    OBJPACK-HEAD_START = 1.
*    OBJPACK-HEAD_NUM = 0.
*    OBJPACK-BODY_START = 1.
*    OBJPACK-BODY_NUM = 4.
*    OBJPACK-DOC_TYPE = 'TXT'.
*    APPEND OBJPACK.
*
*    OBJPACK-TRANSF_BIN = 'X'.
*    OBJPACK-HEAD_START = 1.
*    OBJPACK-HEAD_NUM = 0.
*    OBJPACK-BODY_START = 1.
*    OBJPACK-BODY_NUM = RIGHE_ATTACHMENT.
*    OBJPACK-DOC_TYPE = 'PDF'.
*    OBJPACK-OBJ_NAME = 'TEST'.
*    CONDENSE LTX.
*
*
*
**      CONCATENATE 'SR9 ' ltx  'FOR THE PERIOD' wa_d1 'TO' wa_d2 INTO objpack-obj_descr SEPARATED BY space.
*    CONCATENATE 'SR-9' '.' INTO OBJPACK-OBJ_DESCR SEPARATED BY SPACE.
*    OBJPACK-DOC_SIZE = RIGHE_ATTACHMENT * 255.
*    APPEND OBJPACK.
*    CLEAR OBJPACK.
*
*    LOOP AT IT_TAM2 INTO WA_TAM2 WHERE ZPERNR = WA_TAD2-ZPERNR.
**    READ TABLE it_mail1 INTO wa_mail1 WITH KEY lifnr = wa_tab4-lifnr.
**    IF sy-subrc EQ 0.
**      MESSAGE 'EMAIL SENT' TYPE 'I'.
**  loop at it_mail1 into wa_mail1.
*      RECLIST-RECEIVER =   WA_TAM2-USRID_LONG.
*      RECLIST-EXPRESS = 'X'.
*      RECLIST-REC_TYPE = 'U'.
*      RECLIST-NOTIF_DEL = 'X'. " request delivery notification
*      RECLIST-NOTIF_NDEL = 'X'. " request not delivered notification
*      APPEND RECLIST.
*      CLEAR RECLIST.
**  endif.
*    ENDLOOP.
*
*    DESCRIBE TABLE RECLIST LINES MCOUNT.
*    IF MCOUNT > 0.
*      DATA: SENDER LIKE SOEXTRECI1-RECEIVER.
***ADDED BY SATHISH.B
*      TYPES: BEGIN OF T_USR21,
*               BNAME      TYPE USR21-BNAME,
*               PERSNUMBER TYPE USR21-PERSNUMBER,
*               ADDRNUMBER TYPE USR21-ADDRNUMBER,
*             END OF T_USR21.
*
*      TYPES: BEGIN OF T_ADR6,
*               ADDRNUMBER TYPE USR21-ADDRNUMBER,
*               PERSNUMBER TYPE USR21-PERSNUMBER,
*               SMTP_ADDR  TYPE ADR6-SMTP_ADDR,
*             END OF T_ADR6.
*
*      DATA: IT_USR21 TYPE TABLE OF T_USR21,
*            WA_USR21 TYPE T_USR21,
*            IT_ADR6  TYPE TABLE OF T_ADR6,
*            WA_ADR6  TYPE T_ADR6.
*      SELECT  BNAME PERSNUMBER ADDRNUMBER FROM USR21 INTO TABLE IT_USR21
*      WHERE BNAME = SY-UNAME.
*      IF SY-SUBRC = 0.
*        SELECT ADDRNUMBER PERSNUMBER SMTP_ADDR FROM ADR6 INTO TABLE IT_ADR6
*          FOR ALL ENTRIES IN IT_USR21 WHERE ADDRNUMBER = IT_USR21-ADDRNUMBER
*        AND   PERSNUMBER = IT_USR21-PERSNUMBER.
*      ENDIF.
*
*      LOOP AT IT_USR21 INTO WA_USR21.
*        READ TABLE IT_ADR6 INTO WA_ADR6 WITH KEY ADDRNUMBER = WA_USR21-ADDRNUMBER.
*        IF SY-SUBRC = 0.
*          SENDER = WA_ADR6-SMTP_ADDR.
*        ENDIF.
*      ENDLOOP.
*      CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
*        EXPORTING
*          DOCUMENT_DATA              = DOC_CHNG
*          PUT_IN_OUTBOX              = 'X'
*          SENDER_ADDRESS             = SENDER
*          SENDER_ADDRESS_TYPE        = 'SMTP'
**         COMMIT_WORK                = ' '
** IMPORTING
**         SENT_TO_ALL                =
**         NEW_OBJECT_ID              =
**         SENDER_ID                  =
*        TABLES
*          PACKING_LIST               = OBJPACK
**         OBJECT_HEADER              =
*          CONTENTS_BIN               = OBJBIN
*          CONTENTS_TXT               = OBJTXT
**         CONTENTS_HEX               =
**         OBJECT_PARA                =
**         OBJECT_PARB                =
*          RECEIVERS                  = RECLIST
*        EXCEPTIONS
*          TOO_MANY_RECEIVERS         = 1
*          DOCUMENT_NOT_SENT          = 2
*          DOCUMENT_TYPE_NOT_EXIST    = 3
*          OPERATION_NO_AUTHORIZATION = 4
*          PARAMETER_ERROR            = 5
*          X_ERROR                    = 6
*          ENQUEUE_ERROR              = 7
*          OTHERS                     = 8.
*      IF SY-SUBRC <> 0.
*        MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*      ENDIF.
*
*      COMMIT WORK.
*
*      IF SY-SUBRC EQ 0.
*        WRITE : / 'EMAIL SENT ON ',WA_TAM2-USRID_LONG.
*      ENDIF.
*
***modid ver1.0 starts
*
*      CLEAR   : OBJPACK,
*                OBJHEAD,
*                OBJTXT,
*                OBJBIN,
*                RECLIST.
*
*      REFRESH : OBJPACK,
*                OBJHEAD,
*                OBJTXT,
*                OBJBIN,
*                RECLIST.
*
*    ENDIF.
*
*  ENDLOOP.
**    DATA : a TYPE i VALUE 0.
*  LOOP AT IT_TAM1 INTO WA_TAM1.
*    READ TABLE IT_TAM2 INTO WA_TAM2 WITH KEY  ZPERNR = WA_TAM1-ZPERNR .
*    IF SY-SUBRC EQ 4.
*      FORMAT COLOR 6.
*      WRITE : / 'EMAIL ID NOT MAINTAINED FOR EMP. CODE :',WA_TAM1-ZPERNR.
*    ENDIF.
*  ENDLOOP.

ENDFORM.                    "DZMEMAIL
****************************LAYOUT ENDA HERE******
*  elseif r6 eq 'X'.
*****************EMAIL TO ALL*************
*    loop at it_tap1 into wa_tap1.
**      WRITE : / '***',WA_TAP1-PERNR.
*      select single * from pa0105 where pernr eq wa_tap1-pernr and subty eq '0010'.
*      if sy-subrc eq 0.
*        wa_tap2-pernr = wa_tap1-pernr.
*        wa_tap2-usrid_long = pa0105-usrid_long.
*        collect wa_tap2 into it_tap2.
*        clear wa_tap2.
*      endif.
*    endloop.
*
**    WRITE : / 'LAYOUT'.
*    sort it_tac7 by reg zm rm bzirk spart.
*    loop at it_tac7 into wa_tac7.
**      WRITE : / 'A',WA_TAC7-TEXT, WA_TAC7-REG,WA_TAC7-spart,WA_TAC7-ZM,WA_TAC7-RM,WA_TAC7-BZIRK,WA_TAC7-sval,wa_TAC7-acn_val,WA_TAC7-OTH_VAL,
**        wa_TAC7-net, wa_TAC7-PLANS,wa_TAC7-ENAME,wa_TAC7-zz_hqdesc,wa_TAC7-SHORT,wa_TAC7-BEGDA,WA_TAC7-RENAME,WA_TAC7-RZZ_HQDESC,
**        WA_TAC7-RSHORT, WA_TAC7-DZENAME,WA_TAC7-DZZZ_HQDESC, WA_TAC7-DZSHORT,WA_TAC7-ZENAME,WA_TAC7-ZZZ_HQDESC, WA_TAC7-ZSHORT.
*      wa_tad1-reg = wa_tac7-reg.
*      wa_tad1-zm = wa_tac7-zm.
*      wa_tad1-rm = wa_tac7-rm.
*      wa_tad1-bzirk = wa_tac7-bzirk.
*      wa_tad1-plans = wa_tac7-plans.
*      wa_tad1-sval = wa_tac7-sval.
*      wa_tad1-acn_val = wa_tac7-acn_val.
*      wa_tad1-oth_val = wa_tac7-oth_val.
*      wa_tad1-net = wa_tac7-net.
*      collect wa_tad1 into it_tad1.
*      clear wa_tad1.
*    endloop.
**    ULINE.
*
*    loop at it_tad1 into wa_tad1.
*      clear : bc,bcl,xl.
**      WRITE : / '*',WA_TAD1-REG, WA_TAD1-ZM, WA_TAD1-RM, WA_TAD1-BZIRK,WA_TAD1-PLANS, WA_TAD1-SVAL,WA_TAD1-ACN_VAL, WA_TAD1-OTH_VAL, WA_TAD1-NET.
*      wa_tad2-reg = wa_tad1-reg.
*      wa_tad2-zm = wa_tad1-zm.
*      wa_tad2-rm = wa_tad1-rm.
*      wa_tad2-bzirk = wa_tad1-bzirk.
*      wa_tad2-plans = wa_tad1-plans.
*      wa_tad2-sval = wa_tad1-sval.
*      wa_tad2-acn_val = wa_tad1-acn_val.
*      wa_tad2-oth_val = wa_tad1-oth_val.
*      wa_tad2-net = wa_tad1-net.
*      read table it_tac7 into wa_tac7 with key plans = wa_tad1-plans spart = '50'.
*      if sy-subrc eq 0.
*        bc = 1.
*        read table it_tac7 into wa_tac7 with key plans = wa_tad1-plans spart = '60'.
*        if sy-subrc eq 0.
*          bcl = 1.
*        endif.
*      else.
*        read table it_tac7 into wa_tac7 with key plans = wa_tad1-plans spart = '60'.
*        if sy-subrc eq 0.
*          xl = 1.
*        endif.
*      endif.
*
*      if bcl eq 1.
**        WRITE :  'DIVISION IS BCL'.
*        wa_tad2-div = 'BCL'.
*      elseif xl eq '1'.
**        WRITE :  'DIVISION IS XL'.
*        wa_tad2-div = 'XL'.
*      else.
**        WRITE :  'DIVISION IS BC'.
*        wa_tad2-div = 'BC'.
*      endif.
*      select single * from ysd_dist_targt where bzirk eq wa_tad1-bzirk and trgyear eq year1.
*      if sy-subrc eq 0.
*        if month eq '04'.
*          wa_tad2-targt = ysd_dist_targt-month01.
*        elseif month eq '05'.
*          wa_tad2-targt = ysd_dist_targt-month02.
*        elseif month eq '06'.
*          wa_tad2-targt = ysd_dist_targt-month03.
*        elseif month eq '07'.
*          wa_tad2-targt = ysd_dist_targt-month04.
*        elseif month eq '08'.
*          wa_tad2-targt = ysd_dist_targt-month05.
*        elseif month eq '09'.
*          wa_tad2-targt = ysd_dist_targt-month06.
*        elseif month eq '10'.
*          wa_tad2-targt = ysd_dist_targt-month07.
*        elseif month eq '11'.
*          wa_tad2-targt = ysd_dist_targt-month08.
*        elseif month eq '12'.
*          wa_tad2-targt = ysd_dist_targt-month09.
*        elseif month eq '01'.
*          wa_tad2-targt = ysd_dist_targt-month10.
*        elseif month eq '02'.
*          wa_tad2-targt = ysd_dist_targt-month11.
*        elseif month eq '03'.
*          wa_tad2-targt = ysd_dist_targt-month12.
*        endif.
*      endif.
*
*      collect wa_tad2 into it_tad2.
*      clear wa_tad2.
*    endloop.
*
*
*    loop at it_tad2 into wa_tad2.
**      WRITE : / '**',WA_TAD2-REG,WA_TAD2-BZIRK, WA_TAD2-DIV,wa_tad2-net.
*      wa_tad3-reg = wa_tad2-reg.
*      wa_tad3-bzirk = wa_tad2-bzirk.
*      wa_tad3-div = wa_tad2-div.
*      collect wa_tad3 into it_tad3.
*      clear wa_tad3.
*      wa_tad21-reg = wa_tad2-reg.
*      wa_tad21-div = wa_tad2-div.
*      wa_tad21-net = wa_tad2-net.
*      collect wa_tad21 into it_tad21.
*      clear wa_tad21.
**       WA_TAD2-ZM, WA_TAD2-RM,  WA_TAD2-PLANS, WA_TAD2-SVAL, WA_TAD2-ACN_VAL, WA_TAD2-OTH_VAL, WA_TAD2-NET,,WA_TAD2-TARGT.
*    endloop.
*    sort it_tad21 by reg div.
**    LOOP at it_tad21 INTO wa_tad21.
***      WRITE : /'**', wa_tad21-reg,wa_tad21-div,wa_tad21-net.
**    ENDLOOP.
*
*    sort it_tad3 by reg div.
*    loop at it_tad3 into wa_tad3.
*      on change of wa_tad3-reg.
*        count1 = 1.
*      endon.
*      on change of wa_tad3-div.
*        count1 = 1.
*      endon.
**      WRITE : / WA_TAD3-REG,WA_TAD3-BZIRK,WA_TAD3-DIV,COUNT1.
*
*      wa_tad4-reg = wa_tad3-reg.
*      wa_tad4-div = wa_tad3-div.
*      wa_tad4-count = count1.
*      append wa_tad4 to it_tad4.
*      clear wa_tad4.
*      count1 = count1 + 1.
*    endloop.
*    sort it_tad4 descending by count.
*
**    ULINE.
**    LOOP AT IT_TAD4 INTO WA_TAD4.
**      WRITE : / 'FINAL', WA_TAD4-REG,WA_TAD4-DIV,WA_TAD4-COUNT.
**    ENDLOOP.
*
*    sort it_tad2 by reg zm rm bzirk.
*    options-tdgetotf = 'X'.
*    call function 'OPEN_FORM'
*         exporting
*           device   = 'PRINTER'
*           dialog   = ''
**        form     = 'ZSR9_1'
*           language = sy-langu
*                options                           = options
*         exceptions
*           canceled = 1
*           device   = 2.
*    if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    endif.
*    call function 'START_FORM'
*      EXPORTING
*        form        = 'ZSR9'
*        language    = sy-langu
*      EXCEPTIONS
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
*    page1 = 0.
*    page2 = 0.
*
*    select * from pa0001 into table it_pa0001_1 for all entries in it_tad2 where plans eq it_tad2-plans and zz_hqcode ne '     '.
*    sort it_pa0001_1 by endda descending.
*
*    loop at it_tad2 into wa_tad2.
*      clear : jo_dt1,stp,c_bcl,c_bc,c_xl,zjo_dt.
**      WRITE : / WA_TAD2-REG, WA_TAD2-ZM, WA_TAD2-RM, WA_TAD2-BZIRK,WA_TAD2-DIV,WA_TAD2-PLANS, WA_TAD2-SVAL,
**      WA_TAD2-ACN_VAL, WA_TAD2-OTH_VAL, WA_TAD2-NET,wa_tad2-targt.
*      on change of wa_tad2-reg.
*        new-page.
*        page1 = 1.
*        format color 3.
**        WRITE : /1 'ZM',6 '*'.
*        read table it_tac7 into wa_tac7 with key reg = wa_tad2-reg.
*        if sy-subrc eq 0 and wa_tac7-zpernr ne 0.
**          WRITE : 20 WA_TAC7-ZENAME,35 WA_TAC7-ZZZ_HQDESC.
*          zm_name = wa_tac7-zename.
*        else.
*          zm_name = 'VACANT'.
*        endif.
*        page3 = page1 + page2.
*        page4 = page3.
*        if page3 gt 1.
*          call function 'WRITE_FORM'
*            EXPORTING
*              element = 'HEAD1'
*              window  = 'MAIN'.
*        else.
**          WRITE : /20 'VACANT'.
*          call function 'WRITE_FORM'
*            EXPORTING
*              element = 'HEAD2'
*              window  = 'MAIN'.
*        endif.
*        page1 = page1 + 1.
*        page2 = page2 + 1.
**        ULINE.
**        WRITE : /1 'NAME',17 'H.Q.',34 'D.O.J.',50 'DIV',57 'SALES',78 'TARGET'.
**        SKIP.
*        call function 'WRITE_FORM'
*          EXPORTING
*            element = 'HEAD3'
*            window  = 'MAIN'.
*      endon.
*      format color 1.
*      read table it_tac7 into wa_tac7 with key plans = wa_tad2-plans.
*      if sy-subrc eq 0 and wa_tac7-begda ne 0.
*        concatenate wa_tac7-begda+4(2) '/' wa_tac7-begda+0(4) into jo_dt1.
**        WRITE : /1(15) WA_TAC7-ENAME,17(15) WA_TAC7-ZZ_HQDESC,34 JO_DT1,43(5) WA_TAC7-SHORT.
*
*        call function 'WRITE_FORM'
*          EXPORTING
*            element = 'T1'
*            window  = 'MAIN'.
*      else.
**        WRITE : /1(15) 'VACANT',wa_tad2-plans.
**        READ TABLE IT_pa0001_1 INTO WA_PA0001_1 WITH KEY plans = wa_tad2-plans .
*        select single * from zdrphq where bzirk eq wa_tad2-bzirk.
*        if sy-subrc eq 0.
*          select single * from zthr_heq_des where zz_hqcode eq zdrphq-zz_hqcode.
*          if sy-subrc eq 0.
*            clear : hqcode.
**          WRITE : zthr_heq_des-zz_hqdesc.
*            hqcode = zthr_heq_des-zz_hqdesc.
*          endif.
*        endif.
*        call function 'WRITE_FORM'
*          EXPORTING
*            element = 'T2'
*            window  = 'MAIN'.
*      endif.
**      WRITE : 50(3) WA_TAD2-DIV,55(13) WA_TAD2-NET,70(15) wa_tad2-targt.
*      if wa_tad2-targt gt 0.
*        stp = ( wa_tad2-net / wa_tad2-targt ) * 100.
*      endif.
*      call function 'WRITE_FORM'
*        EXPORTING
*          element = 'T3'
*          window  = 'MAIN'.
*      rmtot = rmtot + wa_tad2-net.
*      zmtot = zmtot + wa_tad2-net.
*      rmtar = rmtar + wa_tad2-targt.
*      zmtar = zmtar + wa_tad2-targt.
*      format color 4.
*      at end of rm.
*        clear : rjo_dt.
**        ULINE.
*        read table it_tac7 into wa_tac7 with key rm = wa_tad2-rm.
*        if sy-subrc eq 0 and wa_tac7-rpernr ne 0.
**          WRITE : /1(15) WA_TAC7-RENAME,17(15) WA_TAC7-RZZ_HQDESC,43(5) WA_TAC7-RSHORT,wa_tac7-rbegda.
*          concatenate wa_tac7-rbegda+4(2) '/' wa_tac7-rbegda+0(4) into rjo_dt.
**          WRITE : / 'rjo_dt',rjo_dt.
*          call function 'WRITE_FORM'
*            EXPORTING
*              element = 'R1'
*              window  = 'MAIN'.
*        else.
**          WRITE : / 'VACANT'.
*          call function 'WRITE_FORM'
*            EXPORTING
*              element = 'R2'
*              window  = 'MAIN'.
*        endif.
**        WRITE : 55(13) rmtot,70(15) rmtar.
*        if rmtar ne 0.
*          rstp = ( rmtot / rmtar ) * 100.
*        endif.
*        call function 'WRITE_FORM'
*          EXPORTING
*            element = 'R3'
*            window  = 'MAIN'.
*        rmtot = 0.
*        rmtar = 0.
*        rstp = 0.
**        ULINE.
*      endat.
*      at end of reg.
*        clear : c_bcl,c_bc,c_xl,zjo_dt,p_bcl,p_bc,p_xl,p_tot.
**        ULINE.
*        format color 3.
**        WRITE : / 'ZONE TOTAL :',55(13) ZMTOT,70(15) zmtar.
*        if zmtar ne 0.
*          zstp = ( zmtot / zmtar ) * 100.
*        endif.
*        read table it_tac7 into wa_tac7 with key reg = wa_tad2-reg.
*        if sy-subrc eq 0 and wa_tac7-zpernr ne 0.
**          WRITE : / wa_tac7-zename,wa_tac7-zbegda.
*          concatenate wa_tac7-zbegda+4(2) '/' wa_tac7-zbegda+0(4) into zjo_dt.
*        endif.
*        call function 'WRITE_FORM'
*          EXPORTING
*            element = 'Z1'
*            window  = 'MAIN'.
*        read table it_tad4 into wa_tad4 with  key reg = wa_tac7-reg div = 'BCL'.
*        if sy-subrc eq 0 and wa_tad4-count ne 0.
*          c_bcl = wa_tad4-count.
*          c_tot = c_tot + wa_tad4-count.
*          read table it_tad21 into wa_tad21 with key reg = wa_tac7-reg div = 'BCL'.
*          if sy-subrc eq 0.
*            p_bcl = wa_tad21-net / c_bcl.
**            P_TOT = P_TOT + P_BCL.
*          endif.
*          call function 'WRITE_FORM'
*            EXPORTING
*              element = 'Z2'
*              window  = 'MAIN'.
*        endif.
*        read table it_tad4 into wa_tad4 with  key reg = wa_tac7-reg div = 'BC'.
*        if sy-subrc eq 0 and  wa_tad4-count ne 0.
*          c_bc = wa_tad4-count.
*          c_tot = c_tot + wa_tad4-count.
*          read table it_tad21 into wa_tad21 with key reg = wa_tac7-reg div = 'BC'.
*          if sy-subrc eq 0.
*            p_bc = wa_tad21-net / c_bc.
**            P_TOT = P_TOT + P_BC.
*          endif.
*          call function 'WRITE_FORM'
*            EXPORTING
*              element = 'Z3'
*              window  = 'MAIN'.
*        endif.
*        read table it_tad4 into wa_tad4 with  key reg = wa_tac7-reg div = 'XL'.
*        if sy-subrc eq 0 and wa_tad4-count ne 0.
*          c_xl = wa_tad4-count.
*          c_tot = c_tot + wa_tad4-count.
*          read table it_tad21 into wa_tad21 with key reg = wa_tac7-reg div = 'XL'.
*          if sy-subrc eq 0.
*            p_xl = wa_tad21-net / c_xl.
**            P_TOT = P_TOT + P_XL.
*          endif.
*          call function 'WRITE_FORM'
*            EXPORTING
*              element = 'Z4'
*              window  = 'MAIN'.
*        endif.
*        p_tot = zmtot / c_tot.
*
*        call function 'WRITE_FORM'
*          EXPORTING
*            element = 'Z5'
*            window  = 'MAIN'.
*        zmtot = 0.
*        zmtar = 0.
*        c_bcl = 0.
*        c_bc = 0.
*        c_xl = 0.
*        c_tot = 0.
*        p_bcl = 0.
*        p_bc = 0.
*        p_xl = 0.
*        p_tot = 0.
*        zstp = 0.
*        clear : zm_name.
**        ULINE.
*      endat.
*
*
*    endloop.
*    call function 'END_FORM'
*      EXCEPTIONS
*        unopened                 = 1
*        bad_pageformat_for_print = 2
*        spool_error              = 3
*        codepage                 = 4
*        others                   = 5.
*    if sy-subrc <> 0.
*      message id sy-msgid type sy-msgty number sy-msgno
*              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*    endif.
*    call function 'CLOSE_FORM'
*      IMPORTING
*        result  = result
*      TABLES
*        otfdata = l_otf_data.
*
*    call function 'CONVERT_OTF'
*      EXPORTING
*        format       = 'PDF'
*      IMPORTING
*        bin_filesize = l_bin_filesize
*      TABLES
*        otf          = l_otf_data
*        lines        = l_asc_data.
*
*
*    call function 'SX_TABLE_LINE_WIDTH_CHANGE'
*      EXPORTING
*        line_width_dst = '255'
*      TABLES
*        content_in     = l_asc_data
*        content_out    = objbin.
*
*    write s_budat-low to wa_d1 dd/mm/yyyy.
*    write s_budat-high to wa_d2 dd/mm/yyyy.
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
*    concatenate 'SR9 for the period of: ' wa_d1 'to' wa_d2 into doc_chng-obj_descr separated by space.
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
*
*
**      CONCATENATE 'SR9 ' ltx  'FOR THE PERIOD' wa_d1 'TO' wa_d2 INTO objpack-obj_descr SEPARATED BY space.
*    concatenate 'SR-9' '.' into objpack-obj_descr separated by space.
*    objpack-doc_size = righe_attachment * 255.
*    append objpack.
*    clear objpack.
*
*    loop at it_tap2 into wa_tap2.
**    READ TABLE it_mail1 INTO wa_mail1 WITH KEY lifnr = wa_tab4-lifnr.
**    IF sy-subrc EQ 0.
**      MESSAGE 'EMAIL SENT' TYPE 'I'.
**  loop at it_mail1 into wa_mail1.
*      reclist-receiver =   wa_tap2-usrid_long.
*      reclist-express = 'X'.
*      reclist-rec_type = 'U'.
*      reclist-notif_del = 'X'. " request delivery notification
*      reclist-notif_ndel = 'X'. " request not delivered notification
*      append reclist.
*      clear reclist.
**  endif.
*    endloop.
*
*    describe table reclist lines mcount.
*    if mcount > 0.
**        DATA: sender LIKE soextreci1-receiver.
*****ADDED BY SATHISH.B
**        TYPES: BEGIN OF t_usr21,
**             bname TYPE usr21-bname,
**             persnumber TYPE usr21-persnumber,
**             addrnumber TYPE usr21-addrnumber,
**            END OF t_usr21.
**
**        TYPES: BEGIN OF t_adr6,
**                 addrnumber TYPE usr21-addrnumber,
**                 persnumber TYPE usr21-persnumber,
**                 smtp_addr TYPE adr6-smtp_addr,
**                END OF t_adr6.
*
**        DATA: it_usr21 TYPE TABLE OF t_usr21,
**              wa_usr21 TYPE t_usr21,
**              it_adr6 TYPE TABLE OF t_adr6,
**              wa_adr6 TYPE t_adr6.
*      select  bname persnumber addrnumber from usr21 into table it_usr21
*          where bname = sy-uname.
*      if sy-subrc = 0.
*        select addrnumber persnumber smtp_addr from adr6 into table it_adr6
*          for all entries in it_usr21 where addrnumber = it_usr21-addrnumber
*                                      and   persnumber = it_usr21-persnumber.
*      endif.
*
*      loop at it_usr21 into wa_usr21.
*        read table it_adr6 into wa_adr6 with key addrnumber = wa_usr21-addrnumber.
*        if sy-subrc = 0.
*          sender = wa_adr6-smtp_addr.
*        endif.
*      endloop.
*      call function 'SO_DOCUMENT_SEND_API1'
*          exporting
*           document_data                    = doc_chng
*           put_in_outbox                    = 'X'
*           sender_address                   = sender
*           sender_address_type              = 'SMTP'
**   COMMIT_WORK                      = ' '
** IMPORTING
**   SENT_TO_ALL                      =
**   NEW_OBJECT_ID                    =
**   SENDER_ID                        =
*          tables
*            packing_list                     = objpack
**   OBJECT_HEADER                    =
*           contents_bin                     = objbin
*           contents_txt                     = objtxt
**   CONTENTS_HEX                     =
**   OBJECT_PARA                      =
**   OBJECT_PARB                      =
*            receivers                        = reclist
*         exceptions
*           too_many_receivers               = 1
*           document_not_sent                = 2
*           document_type_not_exist          = 3
*           operation_no_authorization       = 4
*           parameter_error                  = 5
*           x_error                          = 6
*           enqueue_error                    = 7
*           others                           = 8
*                  .
*      if sy-subrc <> 0.
*        message id sy-msgid type sy-msgty number sy-msgno
*                with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*      endif.
*
*      commit work.
**      IF SY-SUBRC EQ 0.
**        WRITE : / 'EMAIL SEND TO ',WA_TAP2-USRID_LONG.
**      ENDIF.
*
*      clear   : objpack,
*                        objhead,
*                        objtxt,
*                        objbin,
*                        reclist.
*
*      refresh : objpack,
*                objhead,
*                objtxt,
*                objbin,
*                reclist.
*
*    endif.
*
*
*    loop at it_tap1 into wa_tap1.
*      read table it_tap2 into wa_tap2 with key pernr = wa_tap1-pernr.
*      if sy-subrc ne 0.
*        a = 1.
*        format color 6.
*        write : / 'EMAIL ID IS NOT MAINTAINED FOR',wa_tap2-pernr.
**      MESSAGE 'EMAIL SENT' TYPE 'I'.
*      elseif sy-subrc eq 0.
*        format color 5.
*        write : / 'EMAIL HAS BEEN SENT TO : ',wa_tap2-pernr.
*      endif.
**    WRITE : / 'a',a.
*
*    endloop.
*****************************LAYOUT ENDA HERE******
FORM email.


  IF r5 EQ 'X'.

    PERFORM sfformdet.

    PERFORM sfformem.
  ELSEIF r9 EQ 'X'.

    PERFORM sfformdet.
*    PERFORM R12SFFORMEM.
    PERFORM r12sfformemem.
  ENDIF.

*  PERFORM SFFORM1.

*  PERFORM SFFORM1N.

*  elseif r5 eq 'X'.
************email to specific**************

*      WRITE : / 'LAYOUT'.
*  SORT IT_TAC7 BY REG ZM RM BZIRK SPART.
*  LOOP AT IT_TAC7 INTO WA_TAC7.
**      WRITE : / 'ZM',WA_TAC7-ZPERNR,WA_TAC7-TEXT, WA_TAC7-REG,WA_TAC7-spart,WA_TAC7-ZM,WA_TAC7-RM,WA_TAC7-BZIRK,WA_TAC7-sval,wa_TAC7-acn_val,WA_TAC7-OTH_VAL,
**        wa_TAC7-net, wa_TAC7-PLANS,wa_TAC7-ENAME,wa_TAC7-zz_hqdesc,wa_TAC7-SHORT,wa_TAC7-BEGDA,WA_TAC7-RENAME,WA_TAC7-RZZ_HQDESC,
**        WA_TAC7-RSHORT, WA_TAC7-DZENAME,WA_TAC7-DZZZ_HQDESC, WA_TAC7-DZSHORT,WA_TAC7-ZENAME,WA_TAC7-ZZZ_HQDESC, WA_TAC7-ZSHORT.
*    WA_TAD1-REG = WA_TAC7-REG.
*    WA_TAD1-ZM = WA_TAC7-ZM.
**    wa_tad1-zpernr = wa_tac7-zpernr.
*    WA_TAD1-RM = WA_TAC7-RM.
*    WA_TAD1-BZIRK = WA_TAC7-BZIRK.
*    WA_TAD1-PLANS = WA_TAC7-PLANS.
*    WA_TAD1-SVAL = WA_TAC7-SVAL.
*    WA_TAD1-ACN_VAL = WA_TAC7-ACN_VAL.
*    WA_TAD1-OTH_VAL = WA_TAC7-OTH_VAL.
*    WA_TAD1-NET = WA_TAC7-NET.
*    COLLECT WA_TAD1 INTO IT_TAD1.
*    CLEAR WA_TAD1.
*    WA_TAM1-ZPERNR = WA_TAC7-ZPERNR.
*    COLLECT WA_TAM1 INTO IT_TAM1.
*    CLEAR WA_TAM1.
*  ENDLOOP.
*
**    LOOP AT IT_TAM1 INTO WA_TAM1.
**      SELECT SINGLE * FROM PA0105 WHERE PERNR EQ WA_TAM1-ZPERNR AND SUBTY EQ '0010'.
**      IF SY-SUBRC EQ 0.
**        WA_TAM2-ZPERNR = WA_TAM1-ZPERNR.
**        WA_TAM2-USRID_LONG = PA0105-USRID_LONG.
**        COLLECT WA_TAM2 INTO IT_TAM2.
**        CLEAR WA_TAM2.
**      ENDIF.
**    ENDLOOP.
**
**    LOOP AT IT_TAM2 INTO WA_TAM2.
**      WRITE: / WA_TAM2-ZPERNR,WA_TAM2-USRID_LONG.
**    ENDLOOP.
**    SORT IT_TAM2 BY ZPERNR.
**    DELETE ADJACENT DUPLICATES FROM IT_TAM2 COMPARING ZPERNR.
*
*  LOOP AT IT_TAD1 INTO WA_TAD1.
*    CLEAR : BC,BCL,XL,LS.
**      WRITE : / '*',WA_TAD1-REG, WA_TAD1-ZM, WA_TAD1-RM, WA_TAD1-BZIRK,WA_TAD1-PLANS, WA_TAD1-SVAL,WA_TAD1-ACN_VAL, WA_TAD1-OTH_VAL, WA_TAD1-NET.
*    WA_TAD2-REG = WA_TAD1-REG.
*    WA_TAD2-ZM = WA_TAD1-ZM.
*    WA_TAD2-ZPERNR = WA_TAD1-ZPERNR.
*    WA_TAD2-RM = WA_TAD1-RM.
*    WA_TAD2-BZIRK = WA_TAD1-BZIRK.
*    WA_TAD2-PLANS = WA_TAD1-PLANS.
*    WA_TAD2-SVAL = WA_TAD1-SVAL.
*    WA_TAD2-ACN_VAL = WA_TAD1-ACN_VAL.
*    WA_TAD2-OTH_VAL = WA_TAD1-OTH_VAL.
*    WA_TAD2-NET = WA_TAD1-NET.
**    READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD1-PLANS SPART = '50'.
**    IF SY-SUBRC EQ 0.
***      bc = 1.
**      READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD1-PLANS SPART = '60'.
**      IF SY-SUBRC EQ 0.
**        BCL = 1.
**      ELSE.
**        BC = 1.
**      ENDIF.
**    ELSE.
**      READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD1-PLANS SPART = '60'.
**      IF SY-SUBRC EQ 0.
**        XL = 1.
**      ENDIF.
**    ENDIF.
*    CLEAR : DCOUNT.
*    READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD1-PLANS SPART = '50'.
*    IF SY-SUBRC EQ 0.
*      BC = 1.
*      DCOUNT = DCOUNT + 1.
*    ENDIF.
*    READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD1-PLANS SPART = '60'.
*    IF SY-SUBRC EQ 0.
*      XL = 1.
*      DCOUNT = DCOUNT + 1.
*    ENDIF.
*    READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD1-PLANS SPART = '70'.
*    IF SY-SUBRC EQ 0.
*      LS = 1.
*      DCOUNT = DCOUNT + 1.
*    ENDIF.
*    IF DCOUNT GT 1.
*      BCL = 1.
*    ENDIF.
*
*    IF BC EQ 1.
**        WRITE :  'DIVISION IS BCL'.
*      WA_TAD2-DIV = 'BC'.
*    ELSEIF XL EQ 1.
**        WRITE :  'DIVISION IS XL'.
*      WA_TAD2-DIV = 'XL'.
*    ELSEIF LS EQ 1.
**        WRITE :  'DIVISION IS XL'.
*      WA_TAD2-DIV = 'LS'.
*    ELSE.
**        WRITE :  'DIVISION IS BC'.
*      WA_TAD2-DIV = 'BCL'.
*    ENDIF.
*
*    SELECT SINGLE * FROM YSD_DIST_TARGT WHERE BZIRK EQ WA_TAD1-BZIRK AND TRGYEAR EQ YEAR1.
*    IF SY-SUBRC EQ 0.
*      IF MONTH EQ '04'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH01.
*      ELSEIF MONTH EQ '05'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH02.
*      ELSEIF MONTH EQ '06'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH03.
*      ELSEIF MONTH EQ '07'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH04.
*      ELSEIF MONTH EQ '08'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH05.
*      ELSEIF MONTH EQ '09'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH06.
*      ELSEIF MONTH EQ '10'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH07.
*      ELSEIF MONTH EQ '11'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH08.
*      ELSEIF MONTH EQ '12'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH09.
*      ELSEIF MONTH EQ '01'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH10.
*      ELSEIF MONTH EQ '02'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH11.
*      ELSEIF MONTH EQ '03'.
*        WA_TAD2-TARGT = YSD_DIST_TARGT-MONTH12.
*      ENDIF.
*
*      IF MONTH EQ '04'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH01.
*      ELSEIF MONTH EQ '05'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH02.
*      ELSEIF MONTH EQ '06'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH03.
*      ELSEIF MONTH EQ '07'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH04.
*      ELSEIF MONTH EQ '08'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH05.
*      ELSEIF MONTH EQ '09'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH06.
*      ELSEIF MONTH EQ '10'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH07.
*      ELSEIF MONTH EQ '11'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH08.
*      ELSEIF MONTH EQ '12'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH09.
*      ELSEIF MONTH EQ '01'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH10.
*      ELSEIF MONTH EQ '02'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH11.
*      ELSEIF MONTH EQ '03'.
*        WA_TAD2-TARGT1 = YSD_DIST_TARGT-MONTH12.
*      ENDIF.
*    ELSE.
*      SELECT SINGLE * FROM YSD_HBE_TARGT WHERE BZIRK EQ WA_TAD1-BZIRK AND TRGYEAR EQ YEAR1.
*      IF SY-SUBRC EQ 0.
*        IF MONTH EQ '04'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH01.
*        ELSEIF MONTH EQ '05'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH02.
*        ELSEIF MONTH EQ '06'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH03.
*        ELSEIF MONTH EQ '07'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH04.
*        ELSEIF MONTH EQ '08'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH05.
*        ELSEIF MONTH EQ '09'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH06.
*        ELSEIF MONTH EQ '10'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH07.
*        ELSEIF MONTH EQ '11'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH08.
*        ELSEIF MONTH EQ '12'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH09.
*        ELSEIF MONTH EQ '01'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH10.
*        ELSEIF MONTH EQ '02'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH11.
*        ELSEIF MONTH EQ '03'.
*          WA_TAD2-TARGT1 = YSD_HBE_TARGT-MONTH12.
*        ENDIF.
*      ENDIF.
*    ENDIF.
*
*    SELECT SINGLE * FROM ZONESEQ WHERE ZONE_DIST EQ WA_TAD1-REG.
*    IF SY-SUBRC EQ 0.
*      WA_TAD2-SEQ = ZONESEQ-SEQ.
*    ENDIF.
*
*    COLLECT WA_TAD2 INTO IT_TAD2.
*    CLEAR WA_TAD2.
*  ENDLOOP.
*
*  LOOP AT IT_TAD2 INTO WA_TAD2.
*    IF DV1 EQ 'X'.
*      DELETE IT_TAD2 WHERE DIV = 'XL'.
*      DELETE IT_TAD2 WHERE DIV = 'LS'.
*    ELSEIF DV2 EQ 'X'.
*      DELETE IT_TAD2 WHERE DIV = 'BC'.
*      DELETE IT_TAD2 WHERE DIV = 'BCL'.
*      DELETE IT_TAD2 WHERE DIV = 'LS'.
*    ELSEIF DV4 EQ 'X'.
*      DELETE IT_TAD2 WHERE DIV = 'BC'.
*      DELETE IT_TAD2 WHERE DIV = 'BCL'.
*      DELETE IT_TAD2 WHERE DIV = 'XL'.
*    ENDIF.
*  ENDLOOP.
*
*
*  LOOP AT IT_TAD2 INTO WA_TAD2.
**      WRITE : / '**',WA_TAD2-REG,WA_TAD2-BZIRK, WA_TAD2-DIV,wa_tad2-net.
*    WA_TAD3-REG = WA_TAD2-REG.
*    WA_TAD3-BZIRK = WA_TAD2-BZIRK.
*    WA_TAD3-DIV = WA_TAD2-DIV.
*    COLLECT WA_TAD3 INTO IT_TAD3.
*    CLEAR WA_TAD3.
*    WA_TAD21-REG = WA_TAD2-REG.
*    WA_TAD21-DIV = WA_TAD2-DIV.
*    WA_TAD21-NET = WA_TAD2-NET.
*    COLLECT WA_TAD21 INTO IT_TAD21.
*    CLEAR WA_TAD21.
**       WA_TAD2-ZM, WA_TAD2-RM,  WA_TAD2-PLANS, WA_TAD2-SVAL, WA_TAD2-ACN_VAL, WA_TAD2-OTH_VAL, WA_TAD2-NET,,WA_TAD2-TARGT.
*  ENDLOOP.
*  SORT IT_TAD21 BY REG DIV.
**    LOOP at it_tad21 INTO wa_tad21.
***      WRITE : /'**', wa_tad21-reg,wa_tad21-div,wa_tad21-net.
**    ENDLOOP.
*
*  SORT IT_TAD3 BY REG DIV.
*  LOOP AT IT_TAD3 INTO WA_TAD3.
*    ON CHANGE OF WA_TAD3-REG.
*      COUNT1 = 1.
*    ENDON.
*    ON CHANGE OF WA_TAD3-DIV.
*      COUNT1 = 1.
*    ENDON.
**      WRITE : / WA_TAD3-REG,WA_TAD3-BZIRK,WA_TAD3-DIV,COUNT1.
*
*    WA_TAD4-REG = WA_TAD3-REG.
*    WA_TAD4-DIV = WA_TAD3-DIV.
*    WA_TAD4-COUNT = COUNT1.
*    APPEND WA_TAD4 TO IT_TAD4.
*    CLEAR WA_TAD4.
*    COUNT1 = COUNT1 + 1.
*  ENDLOOP.
*  SORT IT_TAD4 DESCENDING BY COUNT.
*
**    ULINE.
**    LOOP AT IT_TAD4 INTO WA_TAD4.
**      WRITE : / 'FINAL', WA_TAD4-REG,WA_TAD4-DIV,WA_TAD4-COUNT.
**    ENDLOOP.
*  OPTIONS-TDGETOTF = 'X'.
*
*  SORT IT_TAD2 BY SEQ REG ZM RM BZIRK.
*
*  IF IT_TAD2 IS INITIAL.
*    MESSAGE 'NO DATA FOUND FOR THIS DIVISION' TYPE 'E'.
*    EXIT.
*  ENDIF.
*
**    LOOP AT IT_TAM1 INTO WA_TAM1.
*  CALL FUNCTION 'OPEN_FORM'
*    EXPORTING
*      DEVICE                      = 'PRINTER'
*      DIALOG                      = ''
**     form                        = 'ZSR9_1'
*      LANGUAGE                    = SY-LANGU
*      OPTIONS                     = OPTIONS
*    EXCEPTIONS
*      CANCELED                    = 1
*      DEVICE                      = 2
*      FORM                        = 3
*      OPTIONS                     = 4
*      UNCLOSED                    = 5
*      MAIL_OPTIONS                = 6
*      ARCHIVE_ERROR               = 7
*      INVALID_FAX_NUMBER          = 8
*      MORE_PARAMS_NEEDED_IN_BATCH = 9
*      SPOOL_ERROR                 = 10
*      CODEPAGE                    = 11
*      OTHERS                      = 12.
*  IF SY-SUBRC <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.
*  CALL FUNCTION 'START_FORM'
*    EXPORTING
*      FORM        = 'ZSR9_1'
*      LANGUAGE    = SY-LANGU
*    EXCEPTIONS
*      FORM        = 1
*      FORMAT      = 2
*      UNENDED     = 3
*      UNOPENED    = 4
*      UNUSED      = 5
*      SPOOL_ERROR = 6
*      CODEPAGE    = 7
*      OTHERS      = 8.
*  IF SY-SUBRC <> 0.
*    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.
*  PAGE1 = 0.
*  PAGE2 = 0.
*
*  SELECT * FROM PA0001 INTO TABLE IT_PA0001_1 FOR ALL ENTRIES IN IT_TAD2 WHERE PLANS = IT_TAD2-PLANS AND ZZ_HQCODE NE '     '.
*  SORT IT_PA0001_1 BY ENDDA DESCENDING.
*
*  LOOP AT IT_TAD2 INTO WA_TAD2.
**         WHERE zpernr = wa_tam1-zpernr.
*    CLEAR : JO_DT1,STP,C_BCL,C_BC,C_XL,C_LS,ZJO_DT.
**      WRITE : / WA_TAD2-REG, WA_TAD2-ZM, WA_TAD2-RM, WA_TAD2-BZIRK,WA_TAD2-DIV,WA_TAD2-PLANS, WA_TAD2-SVAL,
**      WA_TAD2-ACN_VAL, WA_TAD2-OTH_VAL, WA_TAD2-NET,wa_tad2-targt.
*    ON CHANGE OF WA_TAD2-REG.
*      STPCNT = 0.
*      NEW-PAGE.
*      PAGE1 = 1.
*      FORMAT COLOR 3.
**        WRITE : /1 'ZM',6 '*'.
*      READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY REG = WA_TAD2-REG.
*      IF SY-SUBRC EQ 0 AND WA_TAC7-ZPERNR NE 0.
**          WRITE : 20 WA_TAC7-ZENAME,35 WA_TAC7-ZZZ_HQDESC.
*        ZM_NAME = WA_TAC7-ZENAME.
*      ELSE.
*        ZM_NAME = 'VACANT'.
*      ENDIF.
*      PAGE3 = PAGE1 + PAGE2.
*      PAGE4 = PAGE3.
*      IF PAGE3 GT 1.
*        CALL FUNCTION 'WRITE_FORM'
*          EXPORTING
*            ELEMENT = 'HEAD1'
*            WINDOW  = 'MAIN'.
*      ELSE.
**          WRITE : /20 'VACANT'.
*        CALL FUNCTION 'WRITE_FORM'
*          EXPORTING
*            ELEMENT = 'HEAD2'
*            WINDOW  = 'MAIN'.
*      ENDIF.
*      PAGE1 = PAGE1 + 1.
*      PAGE2 = PAGE2 + 1.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'HEAD3'
*          WINDOW  = 'MAIN'.
*    ENDON.
*
*    FORMAT COLOR 1.
*    READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD2-PLANS.
*    IF SY-SUBRC EQ 0 AND WA_TAC7-BEGDA NE 0.
*      CONCATENATE WA_TAC7-BEGDA+4(2) '/' WA_TAC7-BEGDA+0(4) INTO JO_DT1.
**        WRITE : /1(15) WA_TAC7-ENAME,17(15) WA_TAC7-ZZ_HQDESC,34 JO_DT1,43(5) WA_TAC7-SHORT.
*
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'T1'
*          WINDOW  = 'MAIN'.
*    ELSE.
**        WRITE : /1(15) 'VACANT',wa_tad2-plans.
**        READ TABLE IT_pa0001_1 INTO WA_PA0001_1 WITH KEY plans = wa_tad2-plans.
*      SELECT SINGLE * FROM ZDRPHQ WHERE BZIRK EQ WA_TAD2-BZIRK.
*      IF SY-SUBRC EQ 0.
*        SELECT SINGLE * FROM ZTHR_HEQ_DES WHERE ZZ_HQCODE EQ ZDRPHQ-ZZ_HQCODE.
*        IF SY-SUBRC EQ 0.
*          CLEAR : HQCODE.
**          WRITE : zthr_heq_des-zz_hqdesc.
*          HQCODE = ZTHR_HEQ_DES-ZZ_HQDESC.
*        ENDIF.
*      ENDIF.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'T2'
*          WINDOW  = 'MAIN'.
*    ENDIF.
**      WRITE : 50(3) WA_TAD2-DIV,55(13) WA_TAD2-NET,70(15) wa_tad2-targt.
*    IF WA_TAD2-TARGT NE 0.
*      STP = ( WA_TAD2-NET / WA_TAD2-TARGT ) * 100.
*    ENDIF.
*    IF STP GE 100.
*      STPCNT = STPCNT + 1.
*    ENDIF.
*    CALL FUNCTION 'WRITE_FORM'
*      EXPORTING
*        ELEMENT = 'T3'
*        WINDOW  = 'MAIN'.
*    IF WA_TAD2-RM NE '      '.
*      RMTOT = RMTOT + WA_TAD2-NET.
*      RMTAR = RMTAR + WA_TAD2-TARGT.
*    ENDIF.
*    IF WA_TAD2-REG NE '      '.
*      ZMTOT = ZMTOT + WA_TAD2-NET.
*      ZMTAR = ZMTAR + WA_TAD2-TARGT.
*    ENDIF.
*    IF WA_TAD2-ZM NE '      '.
*      DZTOT = DZTOT + WA_TAD2-NET.
*      DZMTAR = DZMTAR + WA_TAD2-TARGT.
*    ENDIF.
**    RMTOT = RMTOT + WA_TAD2-NET.
**    ZMTOT = ZMTOT + WA_TAD2-NET.
**    RMTAR = RMTAR + WA_TAD2-TARGT.
**    ZMTAR = ZMTAR + WA_TAD2-TARGT.
***    IF WA_TAD2-ZM NE '      '.
**    DZTOT = DZTOT + WA_TAD2-NET.
**    DZMTAR = DZMTAR + WA_TAD2-TARGT.
***    ENDIF.
*    FORMAT COLOR 4.
*    IF WA_TAD2-RM NE '      '.
*      AT END OF RM.
*        CLEAR : RJO_DT.
**        ULINE.
*        READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY RM = WA_TAD2-RM.
*        IF SY-SUBRC EQ 0 AND WA_TAC7-RPERNR NE 0.
**          WRITE : /1(15) WA_TAC7-RENAME,17(15) WA_TAC7-RZZ_HQDESC,43(5) WA_TAC7-RSHORT,wa_tac7-rbegda.
*          CONCATENATE WA_TAC7-RBEGDA+4(2) '/' WA_TAC7-RBEGDA+0(4) INTO RJO_DT.
**          WRITE : / 'rjo_dt',rjo_dt.
*        ENDIF.
*        CALL FUNCTION 'WRITE_FORM'
*          EXPORTING
*            ELEMENT = 'R1'
*            WINDOW  = 'MAIN'.
**        ELSE.
***          WRITE : / 'VACANT'.
**          CALL FUNCTION 'WRITE_FORM'
**            EXPORTING
**              ELEMENT = 'R2'
**              WINDOW  = 'MAIN'.
**        ENDIF.
**        WRITE : 55(13) rmtot,70(15) rmtar.
*        IF RMTAR NE 0.
*          RSTP = ( RMTOT / RMTAR ) * 100.
*        ENDIF.
*        CALL FUNCTION 'WRITE_FORM'
*          EXPORTING
*            ELEMENT = 'R3'
*            WINDOW  = 'MAIN'.
*        RMTOT = 0.
*        RMTAR = 0.
*        RSTP = 0.
**        ULINE.
*      ENDAT.
*    ENDIF.
***********************************
*    IF WA_TAD2-ZM NE '      '.
*      AT END OF ZM.
*        CLEAR : DZJO_DT.
**        ULINE.
*        READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY ZM = WA_TAD2-ZM.
*        IF SY-SUBRC EQ 0 AND WA_TAC7-DZPERNR NE 0.
**          WRITE : /1(15) WA_TAC7-RENAME,17(15) WA_TAC7-RZZ_HQDESC,43(5) WA_TAC7-RSHORT,wa_tac7-rbegda.
*          CONCATENATE WA_TAC7-DZBEGDA+4(2) '/' WA_TAC7-DZBEGDA+0(4) INTO DZJO_DT.
**          WRITE : / 'rjo_dt',rjo_dt.
*        ENDIF.
*        CALL FUNCTION 'WRITE_FORM'
*          EXPORTING
*            ELEMENT = 'DZM1'
*            WINDOW  = 'MAIN'.
**        ELSE.
***          WRITE : / 'VACANT'.
**          CALL FUNCTION 'WRITE_FORM'
**            EXPORTING
**              ELEMENT = 'DZM2'
**              WINDOW  = 'MAIN'.
**        ENDIF.
***        WRITE : 55(13) rmtot,70(15) rmtar.
*        IF DZMTAR NE 0.
*          DZMSTP = ( DZTOT / DZMTAR ) * 100.
*        ENDIF.
*        CALL FUNCTION 'WRITE_FORM'
*          EXPORTING
*            ELEMENT = 'DZM3'
*            WINDOW  = 'MAIN'.
*        DZTOT = 0.
*        DZMTAR = 0.
*        DZMSTP = 0.
**        ULINE.
*      ENDAT.
*    ENDIF.
***********************************
*    IF WA_TAD2-REG NE '      '.
*      AT END OF REG.
*        CLEAR : C_BCL,C_BC,C_XL,C_LS,ZJO_DT,P_BCL,P_BC,P_XL,P_TOT,P_LS,ZM_NAME.
**        ULINE.
*        FORMAT COLOR 3.
**        WRITE : / 'ZONE TOTAL :',55(13) ZMTOT,70(15) zmtar.
*        IF ZMTAR NE 0.
*          ZSTP = ( ZMTOT / ZMTAR ) * 100.
*        ENDIF.
*        READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY REG = WA_TAD2-REG.
*        IF SY-SUBRC EQ 0 AND WA_TAC7-ZPERNR NE 0.
**          WRITE : / wa_tac7-zename,wa_tac7-zbegda.
*          CONCATENATE WA_TAC7-ZBEGDA+4(2) '/' WA_TAC7-ZBEGDA+0(4) INTO ZJO_DT.
*          ZM_NAME = WA_TAC7-ZENAME.
**        ELSE.
**          ZM_NAME = 'VACANT'.
*        ENDIF.
*
*
**        READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY reg = WA_TAD2-reg.
**        IF SY-SUBRC EQ 0 AND WA_TAC7-ZPERNR NE 0.
***          WRITE : 20 WA_TAC7-ZENAME,35 WA_TAC7-ZZZ_HQDESC.
**          ZM_NAME = WA_TAC7-ZENAME.
**        else.
**          ZM_NAME = 'VACANT'.
**        ENDIF.
*
*        CALL FUNCTION 'WRITE_FORM'
*          EXPORTING
*            ELEMENT = 'Z1'
*            WINDOW  = 'MAIN'.
*        READ TABLE IT_TAD4 INTO WA_TAD4 WITH  KEY REG = WA_TAD2-REG DIV = 'BCL'.  "Jyotsna check here
*        IF SY-SUBRC EQ 0 AND WA_TAD4-COUNT NE 0.
*          C_BCL = WA_TAD4-COUNT.
*          C_TOT = C_TOT + WA_TAD4-COUNT.
*          READ TABLE IT_TAD21 INTO WA_TAD21 WITH KEY REG = WA_TAD2-REG DIV = 'BCL'.
*          IF SY-SUBRC EQ 0.
*            P_BCL = WA_TAD21-NET / C_BCL.
**            P_TOT = P_TOT + P_BCL.
*          ENDIF.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'Z2'
*              WINDOW  = 'MAIN'.
*        ENDIF.
*        READ TABLE IT_TAD4 INTO WA_TAD4 WITH  KEY REG = WA_TAD2-REG DIV = 'BC'.
*        IF SY-SUBRC EQ 0 AND  WA_TAD4-COUNT NE 0.
*          C_BC = WA_TAD4-COUNT.
*          C_TOT = C_TOT + WA_TAD4-COUNT.
*          READ TABLE IT_TAD21 INTO WA_TAD21 WITH KEY REG = WA_TAD2-REG DIV = 'BC'.
*          IF SY-SUBRC EQ 0.
*            P_BC = WA_TAD21-NET / C_BC.
**            P_TOT = P_TOT + P_BC.
*          ENDIF.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'Z3'
*              WINDOW  = 'MAIN'.
*        ENDIF.
*        READ TABLE IT_TAD4 INTO WA_TAD4 WITH  KEY REG = WA_TAD2-REG DIV = 'XL'.
*        IF SY-SUBRC EQ 0 AND WA_TAD4-COUNT NE 0.
*          C_XL = WA_TAD4-COUNT.
*          C_TOT = C_TOT + WA_TAD4-COUNT.
*          READ TABLE IT_TAD21 INTO WA_TAD21 WITH KEY REG = WA_TAD2-REG DIV = 'XL'.
*          IF SY-SUBRC EQ 0.
*            P_XL = WA_TAD21-NET / C_XL.
**            P_TOT = P_TOT + P_XL.
*          ENDIF.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'Z4'
*              WINDOW  = 'MAIN'.
*        ENDIF.
*
*        READ TABLE IT_TAD4 INTO WA_TAD4 WITH  KEY REG = WA_TAD2-REG DIV = 'LS'.
*        IF SY-SUBRC EQ 0 AND WA_TAD4-COUNT NE 0.
*          C_LS = WA_TAD4-COUNT.
*          C_TOT = C_TOT + WA_TAD4-COUNT.
*          READ TABLE IT_TAD21 INTO WA_TAD21 WITH KEY REG = WA_TAD2-REG DIV = 'LS'.
*          IF SY-SUBRC EQ 0.
*            P_LS = WA_TAD21-NET / C_LS.
**            P_TOT = P_TOT + P_XL.
*          ENDIF.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'Z41'
*              WINDOW  = 'MAIN'.
*        ENDIF.
*
*        P_TOT = ZMTOT / C_TOT.
*
*        CALL FUNCTION 'WRITE_FORM'
*          EXPORTING
*            ELEMENT = 'Z5'
*            WINDOW  = 'MAIN'.
*        ZMTOT = 0.
*        ZMTAR = 0.
*        C_BCL = 0.
*        C_BC = 0.
*        C_XL = 0.
*        C_LS = 0.
*        C_TOT = 0.
*        P_BCL = 0.
*        P_BC = 0.
*        P_XL = 0.
*        P_LS = 0.
*        P_TOT = 0.
*        ZSTP = 0.
*        CLEAR : ZM_NAME.
**        ULINE.
*      ENDAT.
*    ENDIF.
*
*  ENDLOOP.
*  CALL FUNCTION 'END_FORM'
*    EXCEPTIONS
*      UNOPENED                 = 1
*      BAD_PAGEFORMAT_FOR_PRINT = 2
*      SPOOL_ERROR              = 3
*      CODEPAGE                 = 4
*      OTHERS                   = 5.
*  IF SY-SUBRC <> 0.
*    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.
*
*  CALL FUNCTION 'CLOSE_FORM'
*    IMPORTING
*      RESULT  = RESULT
*    TABLES
*      OTFDATA = L_OTF_DATA.
*
*  CALL FUNCTION 'CONVERT_OTF'
*    EXPORTING
*      FORMAT       = 'PDF'
*    IMPORTING
*      BIN_FILESIZE = L_BIN_FILESIZE
*    TABLES
*      OTF          = L_OTF_DATA
*      LINES        = L_ASC_DATA.
*
*  CALL FUNCTION 'SX_TABLE_LINE_WIDTH_CHANGE'
*    EXPORTING
*      LINE_WIDTH_DST = '255'
*    TABLES
*      CONTENT_IN     = L_ASC_DATA
*      CONTENT_OUT    = OBJBIN.
*
*  WRITE S_BUDAT1 TO WA_D1 DD/MM/YYYY.
*  WRITE S_BUDAT2 TO WA_D2 DD/MM/YYYY.
*
*  DESCRIBE TABLE OBJBIN LINES RIGHE_ATTACHMENT.
*  OBJTXT = 'This eMail is meant for information only. Please DO NOT REPLY'.APPEND OBJTXT.
*  OBJTXT = '                                 '.APPEND OBJTXT.
*  OBJTXT = 'BLUE CROSS LABORATORIES LTD.'.APPEND OBJTXT.
*  DESCRIBE TABLE OBJTXT LINES RIGHE_TESTO.
*  DOC_CHNG-OBJ_NAME = 'URGENT'.
*  DOC_CHNG-EXPIRY_DAT = SY-DATUM + 10.
*  CONDENSE LTX.
*  CONDENSE OBJTXT.
**      CONCATENATE 'SR9 for the period' ltx '-' INTO doc_chng-obj_descr SEPARATED BY space.
*  CONCATENATE 'SR9 for the period of: ' WA_D1 'to' WA_D2 INTO DOC_CHNG-OBJ_DESCR SEPARATED BY SPACE.
*  DOC_CHNG-SENSITIVTY = 'F'.
*  DOC_CHNG-DOC_SIZE = RIGHE_TESTO * 255 .
*
*  CLEAR OBJPACK-TRANSF_BIN.
*
*  OBJPACK-HEAD_START = 1.
*  OBJPACK-HEAD_NUM = 0.
*  OBJPACK-BODY_START = 1.
*  OBJPACK-BODY_NUM = 4.
*  OBJPACK-DOC_TYPE = 'TXT'.
*  APPEND OBJPACK.
*
*  OBJPACK-TRANSF_BIN = 'X'.
*  OBJPACK-HEAD_START = 1.
*  OBJPACK-HEAD_NUM = 0.
*  OBJPACK-BODY_START = 1.
*  OBJPACK-BODY_NUM = RIGHE_ATTACHMENT.
*  OBJPACK-DOC_TYPE = 'PDF'.
*  OBJPACK-OBJ_NAME = 'TEST'.
*  CONDENSE LTX.
*
*
*
**      CONCATENATE 'SR9 ' ltx  'FOR THE PERIOD' wa_d1 'TO' wa_d2 INTO objpack-obj_descr SEPARATED BY space.
*  CONCATENATE 'SR-9' '.' INTO OBJPACK-OBJ_DESCR SEPARATED BY SPACE.
*  OBJPACK-DOC_SIZE = RIGHE_ATTACHMENT * 255.
*  APPEND OBJPACK.
*  CLEAR OBJPACK.
*
**      LOOP AT it_TAM2 INTO wa_TAM2 WHERE ZPERNR = wa_TAd2-ZPERNR.
**    READ TABLE it_mail1 INTO wa_mail1 WITH KEY lifnr = wa_tab4-lifnr.
**    IF sy-subrc EQ 0.
**      MESSAGE 'EMAIL SENT' TYPE 'I'.
**  loop at it_mail1 into wa_mail1.
*  RECLIST-RECEIVER =   UEMAIL.
*  RECLIST-EXPRESS = 'X'.
*  RECLIST-REC_TYPE = 'U'.
*  RECLIST-NOTIF_DEL = 'X'. " request delivery notification
*  RECLIST-NOTIF_NDEL = 'X'. " request not delivered notification
*  APPEND RECLIST.
*  CLEAR RECLIST.
**  endif.
**      ENDLOOP.
*
*  DESCRIBE TABLE RECLIST LINES MCOUNT.
*  IF MCOUNT > 0.
*    DATA: SENDER LIKE SOEXTRECI1-RECEIVER.
***ADDED BY SATHISH.B
*    TYPES: BEGIN OF T_USR21,
*             BNAME      TYPE USR21-BNAME,
*             PERSNUMBER TYPE USR21-PERSNUMBER,
*             ADDRNUMBER TYPE USR21-ADDRNUMBER,
*           END OF T_USR21.
*
*    TYPES: BEGIN OF T_ADR6,
*             ADDRNUMBER TYPE USR21-ADDRNUMBER,
*             PERSNUMBER TYPE USR21-PERSNUMBER,
*             SMTP_ADDR  TYPE ADR6-SMTP_ADDR,
*           END OF T_ADR6.
*
*    DATA: IT_USR21 TYPE TABLE OF T_USR21,
*          WA_USR21 TYPE T_USR21,
*          IT_ADR6  TYPE TABLE OF T_ADR6,
*          WA_ADR6  TYPE T_ADR6.
*    SELECT  BNAME PERSNUMBER ADDRNUMBER FROM USR21 INTO TABLE IT_USR21
*    WHERE BNAME = SY-UNAME.
*    IF SY-SUBRC = 0.
*      SELECT ADDRNUMBER PERSNUMBER SMTP_ADDR FROM ADR6 INTO TABLE IT_ADR6
*        FOR ALL ENTRIES IN IT_USR21 WHERE ADDRNUMBER = IT_USR21-ADDRNUMBER
*      AND   PERSNUMBER = IT_USR21-PERSNUMBER.
*    ENDIF.
*
*    LOOP AT IT_USR21 INTO WA_USR21.
*      READ TABLE IT_ADR6 INTO WA_ADR6 WITH KEY ADDRNUMBER = WA_USR21-ADDRNUMBER.
*      IF SY-SUBRC = 0.
*        SENDER = WA_ADR6-SMTP_ADDR.
*      ENDIF.
*    ENDLOOP.
*    CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
*      EXPORTING
*        DOCUMENT_DATA              = DOC_CHNG
*        PUT_IN_OUTBOX              = 'X'
*        SENDER_ADDRESS             = SENDER
*        SENDER_ADDRESS_TYPE        = 'SMTP'
**       COMMIT_WORK                = ' '
** IMPORTING
**       SENT_TO_ALL                =
**       NEW_OBJECT_ID              =
**       SENDER_ID                  =
*      TABLES
*        PACKING_LIST               = OBJPACK
**       OBJECT_HEADER              =
*        CONTENTS_BIN               = OBJBIN
*        CONTENTS_TXT               = OBJTXT
**       CONTENTS_HEX               =
**       OBJECT_PARA                =
**       OBJECT_PARB                =
*        RECEIVERS                  = RECLIST
*      EXCEPTIONS
*        TOO_MANY_RECEIVERS         = 1
*        DOCUMENT_NOT_SENT          = 2
*        DOCUMENT_TYPE_NOT_EXIST    = 3
*        OPERATION_NO_AUTHORIZATION = 4
*        PARAMETER_ERROR            = 5
*        X_ERROR                    = 6
*        ENQUEUE_ERROR              = 7
*        OTHERS                     = 8.
*    IF SY-SUBRC <> 0.
*      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.
*
*    COMMIT WORK.
*    IF SY-SUBRC EQ 0.
*      WRITE : / 'email sent on email id: ',UEMAIL.
*    ENDIF.
*
***modid ver1.0 starts
*
*    CLEAR   : OBJPACK,
*              OBJHEAD,
*              OBJTXT,
*              OBJBIN,
*              RECLIST.
*
*    REFRESH : OBJPACK,
*              OBJHEAD,
*              OBJTXT,
*              OBJBIN,
*              RECLIST.
*
*  ENDIF.
ENDFORM.                    "EMAIL
*    ENDLOOP.
*    DATA : a TYPE i VALUE 0.
*    LOOP AT it_TAM1 INTO wa_TAM1.
*      READ TABLE it_TAM2 INTO wa_TAM2 WITH KEY ZPERNR = wa_TAM1-ZPERNR.
*      IF sy-subrc NE 0.
*        a = 1.
*        FORMAT COLOR 6.
*        WRITE : / 'EMAIL ID IS NOT MAINTAINED FOR',wa_TAM2-ZPERNR.
**      MESSAGE 'EMAIL SENT' TYPE 'I'.
*      ELSEIF sy-subrc EQ 0.
*        FORMAT COLOR 5.
*        WRITE : / 'EMAIL HAS BEEN SENT TO : ',wa_TAM2-ZPERNR.
*      ENDIF.
**    WRITE : / 'a',a.
*
*    ENDLOOP.


*  endif.
*endform.                    "SUMMARY

*&---------------------------------------------------------------------*
*&      Form  TOP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM top.

  DATA: comment    TYPE slis_t_listheader,
        wa_comment LIKE LINE OF comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'SR9 DETAILS'.
*  WA_COMMENT-INFO = P_FRMDT.
  APPEND wa_comment TO comment.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = comment
*     I_LOGO             = 'ENJOYSAP_LOGO'
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .

  CLEAR comment.

ENDFORM.                    "TOP



*&---------------------------------------------------------------------*
*&      Form  USER_COMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->UCOMM      text
*      -->SELFIELD   text
*----------------------------------------------------------------------*
FORM user_comm USING ucomm LIKE sy-ucomm
                     selfield TYPE slis_selfield.



  CASE selfield-fieldname.
    WHEN 'VBELN'.
      SET PARAMETER ID 'VF' FIELD selfield-value.
      CALL TRANSACTION 'VF03' AND SKIP FIRST SCREEN.
    WHEN 'VBELN1'.
      SET PARAMETER ID 'BV' FIELD selfield-value.
      CALL TRANSACTION 'VL03N' AND SKIP FIRST SCREEN.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.                    "USER_COMM


*ENDFORM.                    "SUMM

TOP-OF-PAGE.
*&---------------------------------------------------------------------*
*&      Form  SMEMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM smemail .

  PERFORM sfformdet.
*  PERFORM SFFORM.

  LOOP AT it_check INTO wa_check.
    SELECT SINGLE * FROM zdsmter WHERE zmonth EQ month AND zyear EQ year AND bzirk EQ wa_check-reg.
    IF sy-subrc EQ 0.
      IF zdsmter-zdsm+0(2) = 'G-'.
        SELECT SINGLE * FROM yterrallc WHERE bzirk EQ zdsmter-zdsm AND endda GE sy-datum.
        IF sy-subrc EQ 0.
          SELECT SINGLE * FROM pa0001 WHERE endda GE sy-datum AND plans EQ yterrallc-plans.
          IF sy-subrc EQ 0.
            SELECT SINGLE * FROM pa0105 WHERE pernr EQ pa0001-pernr AND subty EQ '0010'.
            IF sy-subrc EQ 0.
              wa_gm1-gpernr = pa0001-pernr.
              wa_gm1-gm = zdsmter-zdsm.
              wa_gm1-reg = wa_check-reg.
              COLLECT wa_gm1 INTO it_gm1.

              wa_gm2-usrid_long = pa0105-usrid_long.
              wa_gm2-gpernr = pa0001-pernr.
              wa_gm2-gm = zdsmter-zdsm.
              COLLECT wa_gm2 INTO it_gm2.
              CLEAR wa_gm2.
              CLEAR wa_gm1.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.
  SORT it_gm1 BY gm reg.
  DELETE ADJACENT DUPLICATES FROM it_gm1 COMPARING reg.

  SORT it_gm2 BY gm .
  DELETE ADJACENT DUPLICATES FROM it_gm2 COMPARING gm.
  DELETE it_gm2 WHERE usrid_long EQ space.

*  PERFORM SFFORMEM.
  LOOP AT it_gm2 INTO wa_gm2.
    PERFORM sfformgm.
  ENDLOOP.

*  SORT it_tac7 BY reg zm rm.
*
*  LOOP AT it_tac7 INTO wa_tac7.
*    SELECT SINGLE * FROM zdsmter WHERE zmonth EQ month AND zyear EQ year AND bzirk EQ wa_tac7-reg.
*    IF sy-subrc EQ 0.
*      IF zdsmter-zdsm+0(2) = 'G-'.
*        SELECT SINGLE * FROM yterrallc WHERE bzirk EQ zdsmter-zdsm AND endda GE sy-datum.
*        IF sy-subrc EQ 0.
*          SELECT SINGLE * FROM pa0001 WHERE endda GE sy-datum AND plans EQ yterrallc-plans.
*          IF sy-subrc EQ 0.
*            wa_tam1-zpernr = pa0001-pernr.
*            COLLECT wa_tam1 INTO it_tam1.
*            CLEAR wa_tam1.
**      WRITE : / 'ZM',WA_TAC7-ZPERNR,WA_TAC7-TEXT, WA_TAC7-REG,WA_TAC7-spart,WA_TAC7-ZM,WA_TAC7-RM,WA_TAC7-BZIRK,WA_TAC7-sval,wa_TAC7-acn_val,WA_TAC7-OTH_VAL,
**        wa_TAC7-net, wa_TAC7-PLANS,wa_TAC7-ENAME,wa_TAC7-zz_hqdesc,wa_TAC7-SHORT,wa_TAC7-BEGDA,WA_TAC7-RENAME,WA_TAC7-RZZ_HQDESC,
**        WA_TAC7-RSHORT, WA_TAC7-DZENAME,WA_TAC7-DZZZ_HQDESC, WA_TAC7-DZSHORT,WA_TAC7-ZENAME,WA_TAC7-ZZZ_HQDESC, WA_TAC7-ZSHORT.
*            wa_tad1-gmpernr = pa0001-pernr.
*            wa_tad1-reg = wa_tac7-reg.
*            wa_tad1-zm = wa_tac7-zm.
*            wa_tad1-rm = wa_tac7-rm.
**
*
*
*            wa_tad1-bzirk = wa_tac7-bzirk.
*            wa_tad1-plans = wa_tac7-plans.
*            wa_tad1-sval = wa_tac7-sval.
*            wa_tad1-acn_val = wa_tac7-acn_val.
*            wa_tad1-oth_val = wa_tac7-oth_val.
*            wa_tad1-net = wa_tac7-net.
*            READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_tad1-reg zm = wa_tad1-zm rm = wa_tad1-rm.
*            IF sy-subrc EQ 0.
*              wa_tad1-zpernr = wa_tac7-zpernr.
*            ENDIF.
*            COLLECT wa_tad1 INTO it_tad1.
*            CLEAR wa_tad1.
*
*
*          ENDIF.
*        ENDIF.
*      ENDIF.
*    ENDIF.
*  ENDLOOP.
*
*  LOOP AT it_tam1 INTO wa_tam1.
*    SELECT SINGLE * FROM pa0105 WHERE pernr EQ wa_tam1-zpernr AND subty EQ '0010'.
*    IF sy-subrc EQ 0.
*      wa_tam2-zpernr = wa_tam1-zpernr.
*      wa_tam2-usrid_long = pa0105-usrid_long.
*      COLLECT wa_tam2 INTO it_tam2.
*      CLEAR wa_tam2.
*    ENDIF.
*  ENDLOOP.
*
*  LOOP AT it_tam2 INTO wa_tam2.
*    WRITE: / wa_tam2-zpernr,wa_tam2-usrid_long.
*  ENDLOOP.
*  SORT it_tam2 BY zpernr.
*  DELETE ADJACENT DUPLICATES FROM it_tam2 COMPARING zpernr.
*
*  LOOP AT it_tad1 INTO wa_tad1.
*    CLEAR : bc,bcl,xl,ls.
**      WRITE : / '*',WA_TAD1-REG, WA_TAD1-ZM, WA_TAD1-RM, WA_TAD1-BZIRK,WA_TAD1-PLANS, WA_TAD1-SVAL,WA_TAD1-ACN_VAL, WA_TAD1-OTH_VAL, WA_TAD1-NET.
*
*
*    wa_tad2-gmpernr = wa_tad1-gmpernr.
*    wa_tad2-reg = wa_tad1-reg.
*    wa_tad2-zm = wa_tad1-zm.
*    wa_tad2-zpernr = wa_tad1-zpernr.
*    wa_tad2-rm = wa_tad1-rm.
*    wa_tad2-bzirk = wa_tad1-bzirk.
*    wa_tad2-plans = wa_tad1-plans.
*    wa_tad2-sval = wa_tad1-sval.
*    wa_tad2-acn_val = wa_tad1-acn_val.
*    wa_tad2-oth_val = wa_tad1-oth_val.
*    wa_tad2-net = wa_tad1-net.
*
**    read table it_tac7 into wa_tac7 with key plans = wa_tad1-plans spart = '50'.
**    if sy-subrc eq 0.
***      bc = 1.
**      read table it_tac7 into wa_tac7 with key plans = wa_tad1-plans spart = '60'.
**      if sy-subrc eq 0.
**        bcl = 1.
**      else.
**        bc = 1.
**      endif.
**    else.
**      read table it_tac7 into wa_tac7 with key plans = wa_tad1-plans spart = '60'.
**      if sy-subrc eq 0.
**        xl = 1.
**      endif.
**    endif.
*
*    CLEAR : dcount.
*
*    READ TABLE it_tac7 INTO wa_tac7 WITH KEY plans = wa_tad1-plans spart = '50'.
*    IF sy-subrc EQ 0.
*      bc = 1.
*      dcount = dcount + 1.
*    ENDIF.
*
*    READ TABLE it_tac7 INTO wa_tac7 WITH KEY plans = wa_tad1-plans spart = '60'.
*    IF sy-subrc EQ 0.
*      xl = 1.
*      dcount = dcount + 1.
*    ENDIF.
*
*    READ TABLE it_tac7 INTO wa_tac7 WITH KEY plans = wa_tad1-plans spart = '70'.
*    IF sy-subrc EQ 0.
*      ls = 1.
*      dcount = dcount + 1.
*    ENDIF.
*    IF dcount GT 1.
*      bcl = 1.
*    ENDIF.
*
*    IF bcl EQ 1.
**        WRITE :  'DIVISION IS BCL'.
*      wa_tad2-div = 'BCL'.
*    ELSEIF xl EQ '1'.
**        WRITE :  'DIVISION IS XL'.
*      wa_tad2-div = 'XL'.
*    ELSEIF ls EQ '1'.
**        WRITE :  'DIVISION IS XL'.
*      wa_tad2-div = 'LS'.
*    ELSEIF bc EQ 1.
**        WRITE :  'DIVISION IS BC'.
*      wa_tad2-div = 'BC'.
*    ENDIF.
*
*
*    SELECT SINGLE * FROM ysd_dist_targt WHERE bzirk EQ wa_tad1-bzirk AND trgyear EQ year1.
*    IF sy-subrc EQ 0.
*      IF month EQ '04'.
*        wa_tad2-targt = ysd_dist_targt-month01.
*      ELSEIF month EQ '05'.
*        wa_tad2-targt = ysd_dist_targt-month02.
*      ELSEIF month EQ '06'.
*        wa_tad2-targt = ysd_dist_targt-month03.
*      ELSEIF month EQ '07'.
*        wa_tad2-targt = ysd_dist_targt-month04.
*      ELSEIF month EQ '08'.
*        wa_tad2-targt = ysd_dist_targt-month05.
*      ELSEIF month EQ '09'.
*        wa_tad2-targt = ysd_dist_targt-month06.
*      ELSEIF month EQ '10'.
*        wa_tad2-targt = ysd_dist_targt-month07.
*      ELSEIF month EQ '11'.
*        wa_tad2-targt = ysd_dist_targt-month08.
*      ELSEIF month EQ '12'.
*        wa_tad2-targt = ysd_dist_targt-month09.
*      ELSEIF month EQ '01'.
*        wa_tad2-targt = ysd_dist_targt-month10.
*      ELSEIF month EQ '02'.
*        wa_tad2-targt = ysd_dist_targt-month11.
*      ELSEIF month EQ '03'.
*        wa_tad2-targt = ysd_dist_targt-month12.
*      ENDIF.
*
*      IF month EQ '04'.
*        wa_tad2-targt1 = ysd_dist_targt-month01.
*      ELSEIF month EQ '05'.
*        wa_tad2-targt1 = ysd_dist_targt-month02.
*      ELSEIF month EQ '06'.
*        wa_tad2-targt1 = ysd_dist_targt-month03.
*      ELSEIF month EQ '07'.
*        wa_tad2-targt1 = ysd_dist_targt-month04.
*      ELSEIF month EQ '08'.
*        wa_tad2-targt1 = ysd_dist_targt-month05.
*      ELSEIF month EQ '09'.
*        wa_tad2-targt1 = ysd_dist_targt-month06.
*      ELSEIF month EQ '10'.
*        wa_tad2-targt1 = ysd_dist_targt-month07.
*      ELSEIF month EQ '11'.
*        wa_tad2-targt1 = ysd_dist_targt-month08.
*      ELSEIF month EQ '12'.
*        wa_tad2-targt1 = ysd_dist_targt-month09.
*      ELSEIF month EQ '01'.
*        wa_tad2-targt1 = ysd_dist_targt-month10.
*      ELSEIF month EQ '02'.
*        wa_tad2-targt1 = ysd_dist_targt-month11.
*      ELSEIF month EQ '03'.
*        wa_tad2-targt1 = ysd_dist_targt-month12.
*      ENDIF.
*    ELSE.
*      SELECT SINGLE * FROM ysd_hbe_targt WHERE bzirk EQ wa_tad1-bzirk AND trgyear EQ year1.
*      IF sy-subrc EQ 0.
*        IF month EQ '04'.
*          wa_tad2-targt1 = ysd_hbe_targt-month01.
*        ELSEIF month EQ '05'.
*          wa_tad2-targt1 = ysd_hbe_targt-month02.
*        ELSEIF month EQ '06'.
*          wa_tad2-targt1 = ysd_hbe_targt-month03.
*        ELSEIF month EQ '07'.
*          wa_tad2-targt1 = ysd_hbe_targt-month04.
*        ELSEIF month EQ '08'.
*          wa_tad2-targt1 = ysd_hbe_targt-month05.
*        ELSEIF month EQ '09'.
*          wa_tad2-targt1 = ysd_hbe_targt-month06.
*        ELSEIF month EQ '10'.
*          wa_tad2-targt1 = ysd_hbe_targt-month07.
*        ELSEIF month EQ '11'.
*          wa_tad2-targt1 = ysd_hbe_targt-month08.
*        ELSEIF month EQ '12'.
*          wa_tad2-targt1 = ysd_hbe_targt-month09.
*        ELSEIF month EQ '01'.
*          wa_tad2-targt1 = ysd_hbe_targt-month10.
*        ELSEIF month EQ '02'.
*          wa_tad2-targt1 = ysd_hbe_targt-month11.
*        ELSEIF month EQ '03'.
*          wa_tad2-targt1 = ysd_hbe_targt-month12.
*        ENDIF.
*      ENDIF.
*    ENDIF.
*
*
*    COLLECT wa_tad2 INTO it_tad2.
*    CLEAR wa_tad2.
*
*  ENDLOOP.
*
**  LOOP AT IT_TAD2 INTO WA_TAD2.
**    IF DV1 EQ 'X'.
**      DELETE IT_TAD2 WHERE DIV = 'XL'.
**    ELSEIF DV2 EQ 'X'.
**      DELETE IT_TAD2 WHERE DIV = 'BC'.
**      DELETE IT_TAD2 WHERE DIV = 'BCL'.
**    ENDIF.
**  ENDLOOP.
*
*  LOOP AT it_tad2 INTO wa_tad2.
*    IF dv1 EQ 'X'.
*      DELETE it_tad2 WHERE div = 'XL'.
*      DELETE it_tad2 WHERE div = 'LS'.
*    ELSEIF dv2 EQ 'X'.
*      DELETE it_tad2 WHERE div = 'BC'.
*      DELETE it_tad2 WHERE div = 'BCL'.
*      DELETE it_tad2 WHERE div = 'LS'.
*    ELSEIF dv4 EQ 'X'.
*      DELETE it_tad2 WHERE div = 'BC'.
*      DELETE it_tad2 WHERE div = 'XL'.
*      DELETE it_tad2 WHERE div = 'BCL'.
*    ENDIF.
*  ENDLOOP.
*
*  IF it_tad2 IS INITIAL.
*    MESSAGE 'NO DATA FOUND' TYPE 'E'.
*  ENDIF.
*
*
*  LOOP AT it_tad2 INTO wa_tad2.
**      WRITE : / '**',WA_TAD2-REG,WA_TAD2-BZIRK, WA_TAD2-DIV,wa_tad2-net.
**    WA_TAD3-GM = WA_TAD2-GM.
*    wa_tad3-reg = wa_tad2-reg.
*    wa_tad3-bzirk = wa_tad2-bzirk.
*    wa_tad3-div = wa_tad2-div.
*    COLLECT wa_tad3 INTO it_tad3.
*    CLEAR wa_tad3.
*    wa_tad21-reg = wa_tad2-reg.
*    wa_tad21-div = wa_tad2-div.
*    wa_tad21-net = wa_tad2-net.
*    COLLECT wa_tad21 INTO it_tad21.
*    CLEAR wa_tad21.
**       WA_TAD2-ZM, WA_TAD2-RM,  WA_TAD2-PLANS, WA_TAD2-SVAL, WA_TAD2-ACN_VAL, WA_TAD2-OTH_VAL, WA_TAD2-NET,,WA_TAD2-TARGT.
*  ENDLOOP.
*  SORT it_tad21 BY reg div.
**    LOOP at it_tad21 INTO wa_tad21.
***      WRITE : /'**', wa_tad21-reg,wa_tad21-div,wa_tad21-net.
**    ENDLOOP.
*
*  SORT it_tad3 BY reg div.
*  LOOP AT it_tad3 INTO wa_tad3.
*    ON CHANGE OF wa_tad3-reg.
*      count1 = 1.
*    ENDON.
*    ON CHANGE OF wa_tad3-div.
*      count1 = 1.
*    ENDON.
**      WRITE : / WA_TAD3-REG,WA_TAD3-BZIRK,WA_TAD3-DIV,COUNT1.
*
*    wa_tad4-reg = wa_tad3-reg.
*    wa_tad4-div = wa_tad3-div.
*    wa_tad4-count = count1.
*    APPEND wa_tad4 TO it_tad4.
*    CLEAR wa_tad4.
*    count1 = count1 + 1.
*  ENDLOOP.
*  SORT it_tad4 DESCENDING BY count.
*
**    ULINE.
**    LOOP AT IT_TAD4 INTO WA_TAD4.
**      WRITE : / 'FINAL', WA_TAD4-REG,WA_TAD4-DIV,WA_TAD4-COUNT.
**    ENDLOOP.
*  options-tdgetotf = 'X'.
*
*  SORT it_tad2 BY gmpernr reg zm rm bzirk.
*  IF it_tad2 IS INITIAL.
*    MESSAGE 'NO DATA FOUND FOR THIS DIVISION' TYPE 'E'.
*    EXIT.
*  ENDIF.
**  EXIT.
*  LOOP AT it_tam1 INTO wa_tam1.
*    CALL FUNCTION 'OPEN_FORM'
*      EXPORTING
*        device                      = 'PRINTER'
*        dialog                      = ''
**       form                        = 'ZSR9_1'
*        language                    = sy-langu
*        options                     = options
*      EXCEPTIONS
*        canceled                    = 1
*        device                      = 2
*        form                        = 3
*        options                     = 4
*        unclosed                    = 5
*        mail_options                = 6
*        archive_error               = 7
*        invalid_fax_number          = 8
*        more_params_needed_in_batch = 9
*        spool_error                 = 10
*        codepage                    = 11
*        OTHERS                      = 12.
*    IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.
*    CALL FUNCTION 'START_FORM'
*      EXPORTING
*        form        = 'ZSR9_1_N1'
*        language    = sy-langu
*      EXCEPTIONS
*        form        = 1
*        format      = 2
*        unended     = 3
*        unopened    = 4
*        unused      = 5
*        spool_error = 6
*        codepage    = 7
*        OTHERS      = 8.
*    IF sy-subrc <> 0.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*    ENDIF.
*    page1 = 0.
*    page2 = 0.
*
*    SELECT * FROM pa0001 INTO TABLE it_pa0001_1 FOR ALL ENTRIES IN it_tad2 WHERE plans = it_tad2-plans AND zz_hqcode NE '     '.
*    SORT it_pa0001_1 BY endda DESCENDING.
*
*    LOOP AT it_tad2 INTO wa_tad2 WHERE gmpernr = wa_tam1-zpernr.
*      CLEAR : jo_dt1,stp,c_bcl,c_ls,c_bc,c_xl,zjo_dt.
**      WRITE : / WA_TAD2-REG, WA_TAD2-ZM, WA_TAD2-RM, WA_TAD2-BZIRK,WA_TAD2-DIV,WA_TAD2-PLANS, WA_TAD2-SVAL,
**      WA_TAD2-ACN_VAL, WA_TAD2-OTH_VAL, WA_TAD2-NET,wa_tad2-targt.
*      ON CHANGE OF wa_tad2-reg.
*        NEW-PAGE.
*        page1 = 1.
*        FORMAT COLOR 3.
**        WRITE : /1 'ZM',6 '*'.
*        READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_tad2-reg.
*        IF sy-subrc EQ 0 AND wa_tac7-zpernr NE 0.
**          WRITE : 20 WA_TAC7-ZENAME,35 WA_TAC7-ZZZ_HQDESC.
*          zm_name = wa_tac7-zename.
*        ELSE.
*          zm_name = 'VACANT'.
*        ENDIF.
*        page3 = page1 + page2.
*        page4 = page3.
*        IF page3 GT 1.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              element = 'HEAD1'
*              window  = 'MAIN'.
*        ELSE.
**          WRITE : /20 'VACANT'.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              element = 'HEAD2'
*              window  = 'MAIN'.
*        ENDIF.
*        page1 = page1 + 1.
*        page2 = page2 + 1.
**        ULINE.
**        WRITE : /1 'NAME',17 'H.Q.',34 'D.O.J.',50 'DIV',57 'SALES',78 'TARGET'.
**        SKIP.
*        CALL FUNCTION 'WRITE_FORM'
*          EXPORTING
*            element = 'HEAD3'
*            window  = 'MAIN'.
*      ENDON.
*      FORMAT COLOR 1.
*      READ TABLE it_tac7 INTO wa_tac7 WITH KEY plans = wa_tad2-plans.
*      IF sy-subrc EQ 0 AND wa_tac7-begda NE 0.
*        CONCATENATE wa_tac7-begda+4(2) '/' wa_tac7-begda+0(4) INTO jo_dt1.
**        WRITE : /1(15) WA_TAC7-ENAME,17(15) WA_TAC7-ZZ_HQDESC,34 JO_DT1,43(5) WA_TAC7-SHORT.
*
*        CALL FUNCTION 'WRITE_FORM'
*          EXPORTING
*            element = 'T1'
*            window  = 'MAIN'.
*      ELSE.
**        WRITE : /1(15) 'VACANT',wa_tad2-plans.
**          READ TABLE IT_pa0001_1 INTO WA_PA0001_1 WITH KEY plans = wa_tad2-plans.
*        SELECT SINGLE * FROM zdrphq WHERE bzirk EQ wa_tad2-bzirk.
*        IF sy-subrc EQ 0.
*          SELECT SINGLE * FROM zthr_heq_des WHERE zz_hqcode EQ zdrphq-zz_hqcode.
*          IF sy-subrc EQ 0.
*            CLEAR : hqcode.
**          WRITE : zthr_heq_des-zz_hqdesc.
*            hqcode = zthr_heq_des-zz_hqdesc.
*          ENDIF.
*        ENDIF.
*        CALL FUNCTION 'WRITE_FORM'
*          EXPORTING
*            element = 'T2'
*            window  = 'MAIN'.
*      ENDIF.
**      WRITE : 50(3) WA_TAD2-DIV,55(13) WA_TAD2-NET,70(15) wa_tad2-targt.
*      IF wa_tad2-targt NE 0.
*        stp = ( wa_tad2-net / wa_tad2-targt ) * 100.
*      ENDIF.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          element = 'T3'
*          window  = 'MAIN'.
*      IF wa_tad2-rm NE '      '.
*        rmtot = rmtot + wa_tad2-net.
*        rmtar = rmtar + wa_tad2-targt.
*      ENDIF.
*      IF wa_tad2-reg NE '      '.
*        zmtot = zmtot + wa_tad2-net.
*        zmtar = zmtar + wa_tad2-targt.
*      ENDIF.
*      IF wa_tad2-zm NE '      '.
*        dztot = dztot + wa_tad2-net.
*        dzmtar = dzmtar + wa_tad2-targt.
*      ENDIF.
**      RMTOT = RMTOT + WA_TAD2-NET.
**      ZMTOT = ZMTOT + WA_TAD2-NET.
**      RMTAR = RMTAR + WA_TAD2-TARGT.
**      ZMTAR = ZMTAR + WA_TAD2-TARGT.
**      IF WA_TAD2-ZM NE '      '.
**        DZTOT = DZTOT + WA_TAD2-NET.
**        DZMTAR = DZMTAR + WA_TAD2-TARGT.
**      ENDIF.
*      FORMAT COLOR 4.
*      IF wa_tad2-rm NE '      '.
*        AT END OF rm.
*          CLEAR : rjo_dt.
**        ULINE.
*          READ TABLE it_tac7 INTO wa_tac7 WITH KEY rm = wa_tad2-rm.
*          IF sy-subrc EQ 0 AND wa_tac7-rpernr NE 0.
**          WRITE : /1(15) WA_TAC7-RENAME,17(15) WA_TAC7-RZZ_HQDESC,43(5) WA_TAC7-RSHORT,wa_tac7-rbegda.
*            CONCATENATE wa_tac7-rbegda+4(2) '/' wa_tac7-rbegda+0(4) INTO rjo_dt.
*          ENDIF.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              element = 'R1'
*              window  = 'MAIN'.
**          else.
***          WRITE : / 'VACANT'.
**            call function 'WRITE_FORM'
**              EXPORTING
**                element = 'R2'
**                window  = 'MAIN'.
**          endif.
**        WRITE : 55(13) rmtot,70(15) rmtar.
*          IF rmtar NE 0.
*            rstp = ( rmtot / rmtar ) * 100.
*          ENDIF.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              element = 'R3'
*              window  = 'MAIN'.
*          rmtot = 0.
*          rmtar = 0.
*          rstp = 0.
**        ULINE.
*        ENDAT.
*      ENDIF.
****************DZM************************
*      IF wa_tad2-zm NE '      '.
*        AT END OF zm.
*          CLEAR : dzjo_dt.
**        ULINE.
*          READ TABLE it_tac7 INTO wa_tac7 WITH KEY zm = wa_tad2-zm.
*          IF sy-subrc EQ 0 AND wa_tac7-dzpernr NE 0.
**          WRITE : /1(15) WA_TAC7-RENAME,17(15) WA_TAC7-RZZ_HQDESC,43(5) WA_TAC7-RSHORT,wa_tac7-rbegda.
*            CONCATENATE wa_tac7-dzbegda+4(2) '/' wa_tac7-dzbegda+0(4) INTO dzjo_dt.
**          WRITE : / 'rjo_dt',rjo_dt.
*          ENDIF.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              element = 'DZM1'
*              window  = 'MAIN'.
**          else.
***          WRITE : / 'VACANT'.
**            call function 'WRITE_FORM'
**              EXPORTING
**                element = 'DZM2'
**                window  = 'MAIN'.
**          endif.
**        WRITE : 55(13) rmtot,70(15) rmtar.
*          IF dzmtar NE 0.
*            dzmstp = ( dztot / dzmtar ) * 100.
*          ENDIF.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              element = 'DZM3'
*              window  = 'MAIN'.
*          dztot = 0.
*          dzmtar = 0.
*          dzmstp = 0.
**        ULINE.
*        ENDAT.
*      ENDIF.
*******************************************
*      IF wa_tad2-reg NE '      '.
*        AT END OF reg.
*          CLEAR : c_bcl,c_bc,c_ls,p_ls,c_xl,zjo_dt,p_bcl,p_bc,p_xl,p_tot.
**        ULINE.
*          FORMAT COLOR 3.
**        WRITE : / 'ZONE TOTAL :',55(13) ZMTOT,70(15) zmtar.
*          IF zmtar NE 0.
*            zstp = ( zmtot / zmtar ) * 100.
*          ENDIF.
*          READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_tad2-reg.
*          IF sy-subrc EQ 0 AND wa_tac7-zpernr NE 0.
**          WRITE : / wa_tac7-zename,wa_tac7-zbegda.
*            CONCATENATE wa_tac7-zbegda+4(2) '/' wa_tac7-zbegda+0(4) INTO zjo_dt.
*          ENDIF.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              element = 'Z1'
*              window  = 'MAIN'.
*          READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_tad2-reg div = 'BCL'.  "Jyotsna check here
*          IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
*            c_bcl = wa_tad4-count.
*            c_tot = c_tot + wa_tad4-count.
*            READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_tad2-reg div = 'BCL'.
*            IF sy-subrc EQ 0.
*              p_bcl = wa_tad21-net / c_bcl.
**            P_TOT = P_TOT + P_BCL.
*            ENDIF.
*            CALL FUNCTION 'WRITE_FORM'
*              EXPORTING
*                element = 'Z2'
*                window  = 'MAIN'.
*          ENDIF.
*          READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_tad2-reg div = 'BC'.
*          IF sy-subrc EQ 0 AND  wa_tad4-count NE 0.
*            c_bc = wa_tad4-count.
*            c_tot = c_tot + wa_tad4-count.
*            READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_tad2-reg div = 'BC'.
*            IF sy-subrc EQ 0.
*              p_bc = wa_tad21-net / c_bc.
**            P_TOT = P_TOT + P_BC.
*            ENDIF.
*            CALL FUNCTION 'WRITE_FORM'
*              EXPORTING
*                element = 'Z3'
*                window  = 'MAIN'.
*          ENDIF.
*          READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_tad2-reg div = 'XL'.
*          IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
*            c_xl = wa_tad4-count.
*            c_tot = c_tot + wa_tad4-count.
*            READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_tad2-reg div = 'XL'.
*            IF sy-subrc EQ 0.
*              p_xl = wa_tad21-net / c_xl.
**            P_TOT = P_TOT + P_XL.
*            ENDIF.
*            CALL FUNCTION 'WRITE_FORM'
*              EXPORTING
*                element = 'Z4'
*                window  = 'MAIN'.
*          ENDIF.
*
*          READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_tad2-reg div = 'LS'.
*          IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
*            c_ls = wa_tad4-count.
*            c_tot = c_tot + wa_tad4-count.
*            READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_tad2-reg div = 'LS'.
*            IF sy-subrc EQ 0.
*              p_ls = wa_tad21-net / c_ls.
**            P_TOT = P_TOT + P_XL.
*            ENDIF.
*            CALL FUNCTION 'WRITE_FORM'
*              EXPORTING
*                element = 'Z41'
*                window  = 'MAIN'.
*          ENDIF.
*
*          p_tot = zmtot / c_tot.
*
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              element = 'Z5'
*              window  = 'MAIN'.
*          zmtot = 0.
*          zmtar = 0.
*          c_bcl = 0.
*          c_bc = 0.
*          c_xl = 0.
*          c_tot = 0.
*          p_bcl = 0.
*          p_bc = 0.
*          p_xl = 0.
*          p_tot = 0.
*          zstp = 0.
*          c_ls = 0.
*          p_ls = 0.
*          CLEAR : zm_name.
**        ULINE.
*        ENDAT.
*      ENDIF.
*
*    ENDLOOP.
*    CALL FUNCTION 'END_FORM'
*      EXCEPTIONS
*        unopened                 = 1
*        bad_pageformat_for_print = 2
*        spool_error              = 3
*        codepage                 = 4
*        OTHERS                   = 5.
*    IF sy-subrc <> 0.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*    ENDIF.
*
*    CALL FUNCTION 'CLOSE_FORM'
*      IMPORTING
*        result  = result
*      TABLES
*        otfdata = l_otf_data.
*
*    CALL FUNCTION 'CONVERT_OTF'
*      EXPORTING
*        format       = 'PDF'
*      IMPORTING
*        bin_filesize = l_bin_filesize
*      TABLES
*        otf          = l_otf_data
*        lines        = l_asc_data.
*
*    CALL FUNCTION 'SX_TABLE_LINE_WIDTH_CHANGE'
*      EXPORTING
*        line_width_dst = '255'
*      TABLES
*        content_in     = l_asc_data
*        content_out    = objbin.
*
*    WRITE s_budat1 TO wa_d1 DD/MM/YYYY.
*    WRITE s_budat2 TO wa_d2 DD/MM/YYYY.
*
*    DESCRIBE TABLE objbin LINES righe_attachment.
*    objtxt = 'This eMail is meant for information only. Please DO NOT REPLY'.APPEND objtxt.
*    objtxt = '                                 '.APPEND objtxt.
*    objtxt = 'BLUE CROSS LABORATORIES LTD.'.APPEND objtxt.
*    DESCRIBE TABLE objtxt LINES righe_testo.
*    doc_chng-obj_name = 'URGENT'.
*    doc_chng-expiry_dat = sy-datum + 10.
*    CONDENSE ltx.
*    CONDENSE objtxt.
**      CONCATENATE 'SR9 for the period' ltx '-' INTO doc_chng-obj_descr SEPARATED BY space.
*    CONCATENATE 'SR9 for the period of: ' wa_d1 'to' wa_d2 INTO doc_chng-obj_descr SEPARATED BY space.
*    doc_chng-sensitivty = 'F'.
*    doc_chng-doc_size = righe_testo * 255 .
*
*    CLEAR objpack-transf_bin.
*
*    objpack-head_start = 1.
*    objpack-head_num = 0.
*    objpack-body_start = 1.
*    objpack-body_num = 4.
*    objpack-doc_type = 'TXT'.
*    APPEND objpack.
*
*    objpack-transf_bin = 'X'.
*    objpack-head_start = 1.
*    objpack-head_num = 0.
*    objpack-body_start = 1.
*    objpack-body_num = righe_attachment.
*    objpack-doc_type = 'PDF'.
*    objpack-obj_name = 'TEST'.
*    CONDENSE ltx.
*
*
*
**      CONCATENATE 'SR9 ' ltx  'FOR THE PERIOD' wa_d1 'TO' wa_d2 INTO objpack-obj_descr SEPARATED BY space.
*    CONCATENATE 'SR-9' '.' INTO objpack-obj_descr SEPARATED BY space.
*    objpack-doc_size = righe_attachment * 255.
*    APPEND objpack.
*    CLEAR objpack.
*
*    LOOP AT it_tam2 INTO wa_tam2 WHERE zpernr = wa_tad2-gmpernr.
**    READ TABLE it_mail1 INTO wa_mail1 WITH KEY lifnr = wa_tab4-lifnr.
**    IF sy-subrc EQ 0.
**      MESSAGE 'EMAIL SENT' TYPE 'I'.
**  loop at it_mail1 into wa_mail1.
*      reclist-receiver =   wa_tam2-usrid_long.
*      reclist-express = 'X'.
*      reclist-rec_type = 'U'.
*      reclist-notif_del = 'X'. " request delivery notification
*      reclist-notif_ndel = 'X'. " request not delivered notification
*      APPEND reclist.
*      CLEAR reclist.
**  endif.
*    ENDLOOP.
*
*    DESCRIBE TABLE reclist LINES mcount.
*    IF mcount > 0.
*      DATA: sender LIKE soextreci1-receiver.
****ADDED BY SATHISH.B
*      TYPES: BEGIN OF t_usr21,
*               bname      TYPE usr21-bname,
*               persnumber TYPE usr21-persnumber,
*               addrnumber TYPE usr21-addrnumber,
*             END OF t_usr21.
*
*      TYPES: BEGIN OF t_adr6,
*               addrnumber TYPE usr21-addrnumber,
*               persnumber TYPE usr21-persnumber,
*               smtp_addr  TYPE adr6-smtp_addr,
*             END OF t_adr6.
*
*      DATA: it_usr21 TYPE TABLE OF t_usr21,
*            wa_usr21 TYPE t_usr21,
*            it_adr6  TYPE TABLE OF t_adr6,
*            wa_adr6  TYPE t_adr6.
*      SELECT  bname persnumber addrnumber FROM usr21 INTO TABLE it_usr21
*      WHERE bname = sy-uname.
*      IF sy-subrc = 0.
*        SELECT addrnumber persnumber smtp_addr FROM adr6 INTO TABLE it_adr6
*          FOR ALL ENTRIES IN it_usr21 WHERE addrnumber = it_usr21-addrnumber
*        AND   persnumber = it_usr21-persnumber.
*      ENDIF.
*
*      LOOP AT it_usr21 INTO wa_usr21.
*        READ TABLE it_adr6 INTO wa_adr6 WITH KEY addrnumber = wa_usr21-addrnumber.
*        IF sy-subrc = 0.
*          sender = wa_adr6-smtp_addr.
*        ENDIF.
*      ENDLOOP.
*      CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
*        EXPORTING
*          document_data              = doc_chng
*          put_in_outbox              = 'X'
*          sender_address             = sender
*          sender_address_type        = 'SMTP'
**         COMMIT_WORK                = ' '
** IMPORTING
**         SENT_TO_ALL                =
**         NEW_OBJECT_ID              =
**         SENDER_ID                  =
*        TABLES
*          packing_list               = objpack
**         OBJECT_HEADER              =
*          contents_bin               = objbin
*          contents_txt               = objtxt
**         CONTENTS_HEX               =
**         OBJECT_PARA                =
**         OBJECT_PARB                =
*          receivers                  = reclist
*        EXCEPTIONS
*          too_many_receivers         = 1
*          document_not_sent          = 2
*          document_type_not_exist    = 3
*          operation_no_authorization = 4
*          parameter_error            = 5
*          x_error                    = 6
*          enqueue_error              = 7
*          OTHERS                     = 8.
*      IF sy-subrc <> 0.
*        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*      ENDIF.
*
*      COMMIT WORK.
*
***modid ver1.0 starts
*
*      CLEAR   : objpack,
*                objhead,
*                objtxt,
*                objbin,
*                reclist.
*
*      REFRESH : objpack,
*                objhead,
*                objtxt,
*                objbin,
*                reclist.
*
*    ENDIF.
*
*  ENDLOOP.
*  DATA : a TYPE i VALUE 0.
*  LOOP AT it_tam1 INTO wa_tam1.
*    READ TABLE it_tam2 INTO wa_tam2 WITH KEY zpernr = wa_tam1-zpernr.
*    IF sy-subrc NE 0.
*      a = 1.
*      FORMAT COLOR 6.
*      WRITE : / 'EMAIL ID IS NOT MAINTAINED FOR',wa_tam2-zpernr.
**      MESSAGE 'EMAIL SENT' TYPE 'I'.
*    ELSEIF sy-subrc EQ 0.
*      FORMAT COLOR 5.
*      WRITE : / 'EMAIL HAS BEEN SENT TO : ',wa_tam2-zpernr.
*    ENDIF.
**    WRITE : / 'a',a.
*
*  ENDLOOP.
*****************************EMAIL LAYOUT ENDA HERE******


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISTSALE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM distsale .  "added on 17.10.22

  CLEAR :it_zdist_sale.
  SELECT * FROM zdist_sale INTO TABLE it_zdist_sale WHERE fkdat GE s_budat1 AND fkdat LE s_budat2.
  IF it_zdist_sale IS NOT INITIAL.
    LOOP AT it_zdist_sale INTO wa_zdist_sale.
      SELECT SINGLE * FROM mara WHERE matnr EQ wa_zdist_sale-matnr AND spart IN ( '50','60','70' ).
      IF sy-subrc EQ 0.
*    wa_tab1-kunrg = wa_zdist_sale-kunrg.
        wa_dist1-kunag = wa_zdist_sale-kunag.
*        wa_dist1-matnr = wa_zdist_sale-matnr.
        wa_dist1-spart = mara-spart.
        wa_dist1-netwr =   wa_zdist_sale-netwr.
        wa_dist1-fkimg =   wa_zdist_sale-fkimg.
        COLLECT wa_dist1 INTO it_dist1.
        CLEAR wa_dist1.
      ENDIF.
    ENDLOOP.
  ENDIF.
  CLEAR : it_ysd_cus_div_dis1.
  IF it_dist1 IS NOT INITIAL.
    SELECT * FROM ysd_cus_div_dis INTO TABLE it_ysd_cus_div_dis1 FOR ALL ENTRIES IN it_dist1 WHERE kunnr EQ it_dist1-kunag AND spart EQ it_dist1-spart
    AND begda GE s_budat1 AND  endda GE s_budat2.
  ENDIF.

  LOOP AT it_ysd_cus_div_dis1 INTO wa_ysd_cus_div_dis1.
    READ TABLE it_dist1 INTO wa_dist1 WITH KEY kunag = wa_ysd_cus_div_dis1-kunnr spart = wa_ysd_cus_div_dis1-spart.
    IF sy-subrc EQ 0.
*    clear : distval,distqty.
*    select single * from ysd_cus_div_dis where kunnr eq wa_dist1-kunag and spart eq wa_dist1-spart and begda ge s_budat-low and endda ge s_budat-high.
*    if sy-subrc eq 0.
      wa_dist2-bzirk  = wa_ysd_cus_div_dis1-bzirk.
      wa_dist2-spart  = wa_ysd_cus_div_dis1-spart.
*      wa_dist2-matnr = wa_dist1-matnr.
      distval = ( wa_dist1-netwr * ( wa_ysd_cus_div_dis1-percnt / 100 ) ).
      distqty = ( wa_dist1-fkimg * ( wa_ysd_cus_div_dis1-percnt / 100 ) ).
      wa_dist2-netwr = distval.
      wa_dist2-fkimg = distqty.
      COLLECT wa_dist2 INTO it_dist2.
      CLEAR wa_dist2.
    ENDIF.
  ENDLOOP.

*  loop at it_dist2 into wa_dist2.
*    wa_zcn1-bzirk =  wa_dist2.
**    wa_zcn1-matnr =  wa_dist2-matnr.
*    wa_zcn1-sval =  wa_dist2-netwr.
*
*    collect wa_zcn1 into it_zcn1.
*    clear wa_zcn1.
*  endloop.
  LOOP AT it_dist2 INTO wa_dist2.
*    WRITE : / 'SALE', WA_TAS3-BZIRK,WA_TAS3-SPART,WA_TAS3-KUNNR,WA_TAS3-BVAL,WA_TAS3-XVAL.
    wa_tas4-bzirk = wa_dist2-bzirk.
    wa_tas4-spart = wa_dist2-spart.
    wa_tas4-sval = wa_dist2-netwr.
    COLLECT wa_tas4 INTO it_tas4.
    CLEAR wa_tas4.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM form1 .
*  BREAK-POINT.
  SORT it_tac7 BY reg zm rm ZZ_HQDESC.
  CLEAR : rmtot,rmtar.
  CLEAR : stpcnt1,stpcnt2.
  LOOP AT it_tad2 INTO wa_tad2 WHERE reg EQ wa_check-reg.
    wa_sf1-zm = wa_tad2-zm.
    wa_sf1-rm = wa_tad2-rm.
    wa_sf1-bzirk = wa_tad2-bzirk.
    wa_sf1-div = wa_tad2-div.
    READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_tad2-reg zm = wa_tad2-zm rm = wa_tad2-rm bzirk = wa_tad2-bzirk.
    IF sy-subrc EQ 0.
      wa_sf1-ename = wa_tac7-ename.
      IF wa_sf1-ename EQ space.
        wa_sf1-ename = 'VACANT'.
      ENDIF.
      wa_sf1-zz_hqdesc = wa_tac7-zz_hqdesc.
      CONCATENATE wa_tac7-begda+4(2) '/ ' wa_tac7-begda+0(4) INTO wa_sf1-joindt.
      wa_sf1-short = wa_tac7-short.
    ENDIF.
***********************************

*    CLEAR : DCOUNT,BC,BCL,LS,XL.
*    READ TABLE IT_TAD2 INTO WA_TAD2 WITH KEY BZIRK = WA_TAD2-BZIRK SPART = '50'.
*    IF SY-SUBRC EQ 0.
*      BC = 1.
*      DCOUNT = DCOUNT + 1.
*    ENDIF.
*    READ TABLE IT_TAD2 INTO WA_TAD2 WITH KEY BZIRK = WA_TAD2-BZIRK  SPART = '60'.
*    IF SY-SUBRC EQ 0.
*      XL = 1.
*      DCOUNT = DCOUNT + 1.
*    ENDIF.
*    READ TABLE IT_TAD2 INTO WA_TAD2 WITH KEY BZIRK = WA_TAD2-BZIRK SPART = '70'.
*    IF SY-SUBRC EQ 0.
*      LS = 1.
*      DCOUNT = DCOUNT + 1.
*    ENDIF.
*
*    IF DCOUNT GT 1.
*      BCL = 1.
*    ENDIF.
*
*    IF BCL EQ 1.
*      DIV = 'BCL'.
*    ELSEIF BC EQ 1.
*      DIV = 'BC'.
*    ELSEIF XL EQ 1.
*      DIV = 'XL'.
*    ELSEIF LS EQ 1.
*      DIV = 'LS'.
*    ENDIF.
*    WA_SF1-DIV = DIV.

*****************************************
*    READ TABLE IT_TAD2 INTO WA_TAD2 WITH KEY REG = WA_TAD2-REG RM = WA_TAD2-RM BZIRK = WA_TAD2-BZIRK DIV = DIV.
*    IF SY-SUBRC EQ 0.
*      WA_SF1-DIV = WA_TAD2-DIV.
    wa_sf1-net = wa_tad2-net.
    wa_sf1-targt1 = wa_tad2-targt1.
    CLEAR : stp.
    IF wa_tad2-targt GT 0.
      stp = ( wa_tad2-net / wa_tad2-targt ) * 100.
    ENDIF.
    wa_sf1-stp = stp.
    IF stp GE 100.
      stpcnt1 = stpcnt1 + 1.
    ENDIF.
    CONDENSE: wa_sf1-net,wa_sf1-targt1,wa_sf1-stp.
    wa_rm1-rm = wa_tad2-rm.
    wa_rm1-rmtot = wa_tad2-net.
    wa_rm1-rmtar = wa_tad2-targt1.
    COLLECT wa_rm1 INTO it_rm1.
    CLEAR wa_rm1.

    wa_zm1-zm = wa_tad2-zm.
    wa_zm1-zmtot = wa_tad2-net.
    wa_zm1-zmtar = wa_tad2-targt1.
    COLLECT wa_zm1 INTO it_zm1.
    CLEAR wa_zm1.

    wa_reg1-reg = wa_tad2-reg.
    wa_reg1-regtot = wa_tad2-net.
    wa_reg1-regtar = wa_tad2-targt1.
    COLLECT wa_reg1 INTO it_reg1.
    CLEAR wa_reg1.

*    ENDIF.
    COLLECT wa_sf1 INTO it_sf1.
    CLEAR wa_sf1.
******************************************rm*****************
    wa_sf2-rm = wa_tad2-rm.
    wa_sf2-zm = wa_tad2-zm.
    READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_tad2-reg zm = wa_tad2-zm rm = wa_tad2-rm bzirk = wa_tad2-bzirk.
    IF sy-subrc EQ 0.
      wa_sf2-ename = wa_tac7-rename.
      IF wa_sf2-ename EQ space.
        wa_sf2-ename = 'VACANT'.
      ENDIF.
      wa_sf2-zz_hqdesc = wa_tac7-rzz_hqdesc.
      CONCATENATE wa_tac7-rbegda+4(2) '/ ' wa_tac7-rbegda+0(4) INTO wa_sf2-joindt.
      wa_sf2-short = wa_tac7-rshort.
    ENDIF.
    COLLECT wa_sf2 INTO it_sf2.
    CLEAR wa_sf2.
**********************Zm rnds*******************************

    wa_sf3-zm = wa_tad2-zm.

    READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_tad2-reg zm = wa_tad2-zm rm = wa_tad2-rm bzirk = wa_tad2-bzirk.
    IF sy-subrc EQ 0.
      wa_sf3-ename = wa_tac7-dzename.
      IF wa_sf3-ename EQ space.
        wa_sf3-ename = 'VACANT'.
      ENDIF.
      wa_sf3-zz_hqdesc = wa_tac7-dzzz_hqdesc.
      CONCATENATE wa_tac7-dzbegda+4(2) '/ ' wa_tac7-dzbegda+0(4) INTO wa_sf3-joindt.
      wa_sf3-short = wa_tac7-dzshort.
    ENDIF.
    COLLECT wa_sf3 INTO it_sf3.
    CLEAR wa_sf3.
  ENDLOOP.

  SORT it_sf1 BY zm rm bzirk ZZ_HQDESC.

  SORT it_sf2 BY zm rm ZZ_HQDESC.
  DELETE ADJACENT DUPLICATES FROM it_sf2 COMPARING zm rm.
  LOOP AT it_sf2 INTO wa_sf2.
    READ TABLE it_rm1 INTO wa_rm1 WITH KEY rm = wa_sf2-rm.
    IF sy-subrc EQ 0.
      wa_sf2-net = wa_rm1-rmtot.
      wa_sf2-targt1 = wa_rm1-rmtar.
      CLEAR: rstp.
      IF  wa_rm1-rmtar GT 0.
        rstp = ( wa_rm1-rmtot / wa_rm1-rmtar ) * 100.
      ENDIF.
      wa_sf2-stp = rstp.
      CONDENSE : wa_sf2-net,wa_sf2-targt1,wa_sf2-stp.
      MODIFY it_sf2 FROM wa_sf2 TRANSPORTING net targt1 stp WHERE rm = wa_sf2-rm.
      CLEAR wa_sf2.
    ENDIF.
  ENDLOOP.

  SORT it_sf3 BY zm ZZ_HQDESC.
  DELETE ADJACENT DUPLICATES FROM it_sf3 COMPARING zm.

  LOOP AT it_sf3 INTO wa_sf3.
    READ TABLE it_zm1 INTO wa_zm1 WITH KEY zm = wa_sf3-zm.
    IF sy-subrc EQ 0.
      wa_sf3-net = wa_zm1-zmtot.
      wa_sf3-targt1 = wa_zm1-zmtar.
      CLEAR: rstp.
      IF wa_zm1-zmtar GT 0.
        rstp = ( wa_zm1-zmtot / wa_zm1-zmtar ) * 100.
      ENDIF.
      wa_sf3-stp = rstp.
      CONDENSE : wa_sf3-net,wa_sf3-targt1,wa_sf3-stp.
      MODIFY it_sf3 FROM wa_sf3 TRANSPORTING net targt1 stp WHERE zm = wa_sf3-zm.
      CLEAR wa_sf3.
    ENDIF.
  ENDLOOP.

*  LOOP AT IT_SF3 INTO WA_SF3.
*    WRITE : / 'ZM',WA_SF3-ZM.
*    LOOP AT IT_SF2 INTO WA_SF2 WHERE ZM EQ WA_SF3-ZM.
*      WRITE : / 'ZM, RM',WA_SF2-ZM,WA_SF2-RM.
*      LOOP AT IT_SF1 INTO WA_SF1 WHERE RM EQ WA_SF2-RM.
*        WRITE : / 'ZM, RM, TERR', WA_SF1-ZM, WA_SF1-RM, WA_SF1-BZIRK.
*      ENDLOOP.
*    ENDLOOP.
*  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SFFORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sfform .


  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZSR9_A1'
*     FORMNAME           = 'ZSR9_9'
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
      fm_name            = v_fm
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.

  control-no_open   = 'X'.
  control-no_close  = 'X'.


  CALL FUNCTION 'SSF_OPEN'
    EXPORTING
      control_parameters = control.
*  SORT IT_CHECK BY REG.

  LOOP AT it_check INTO wa_check.
*    BREAK-POINT .
    CLEAR : zonename.
    zonename = wa_check-zonename.
*    WRITE : / 'ZONE',ZONENAME.
    CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.
    PERFORM form1.
    PERFORM form2.





    CALL FUNCTION v_fm
      EXPORTING
        control_parameters = control
        user_settings      = 'X'
        output_options     = w_ssfcompop
        format             = format
        zonename           = zonename
        regename           = regename
        reghqdesc          = reghqdesc
        regjoindt          = regjoindt
        regshort           = regshort
        regnet             = regnet
        regtargt1          = regtargt1
        regstp1            = regstp1
        s_budat1           = s_budat1
        s_budat2           = s_budat2
        c_bcl1             = c_bcl1
        c_bc1              = c_bc1
        c_xl1              = c_xl1
        c_ls1              = c_ls1
        p_bcl1             = p_bcl1
        p_bc1              = p_bc1
        p_xl1              = p_xl1
        p_ls1              = p_ls1
        stpcnt2            = stpcnt2
        p_tot1             = p_tot2
        c_tot1             = c_tot1
        bcl1               = bcl1
        bc1                = bc1
        xl1                = xl1
        ls1                = ls1
      TABLES
        it_sf1             = it_sf1
        it_sf2             = it_sf2
        it_sf3             = it_sf3
*       itab_division      = itab_division
*       itab_storage       = itab_storage
*       itab_pa0002        = itab_pa0002
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.
    CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.

    CLEAR : zonename,  regename, reghqdesc,regjoindt, regshort, regnet ,regtargt1,regstp1,c_bcl1, c_bc1,c_xl1,
      c_ls1 , p_bcl1 ,p_bc1,p_xl1,p_ls1,stpcnt2,p_tot1, c_tot1 ,bcl1,bc1,xl1,ls1.



  ENDLOOP.
  CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.
  CALL FUNCTION 'SSF_CLOSE'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SFFORMDET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sfformdet .
*  elseif r2 eq 'X'.
*    WRITE : / 'LAYOUT'.
  SORT it_tac7 BY reg zm rm bzirk spart ZZ_HQDESC.
  LOOP AT it_tac7 INTO wa_tac7.
*      WRITE : / 'A',WA_TAC7-TEXT, WA_TAC7-REG,WA_TAC7-spart,WA_TAC7-ZM,WA_TAC7-RM,WA_TAC7-BZIRK,WA_TAC7-sval,wa_TAC7-acn_val,WA_TAC7-OTH_VAL,
*        wa_TAC7-net, wa_TAC7-PLANS,wa_TAC7-ENAME,wa_TAC7-zz_hqdesc,wa_TAC7-SHORT,wa_TAC7-BEGDA,WA_TAC7-RENAME,WA_TAC7-RZZ_HQDESC,
*        WA_TAC7-RSHORT, WA_TAC7-DZENAME,WA_TAC7-DZZZ_HQDESC, WA_TAC7-DZSHORT,WA_TAC7-ZENAME,WA_TAC7-ZZZ_HQDESC, WA_TAC7-ZSHORT.
    wa_tad1-reg = wa_tac7-reg.
    wa_tad1-zm = wa_tac7-zm.
    wa_tad1-rm = wa_tac7-rm.
    wa_tad1-bzirk = wa_tac7-bzirk.
    wa_tad1-plans = wa_tac7-plans.
    wa_tad1-sval = wa_tac7-sval.
    wa_tad1-acn_val = wa_tac7-acn_val.
    wa_tad1-oth_val = wa_tac7-oth_val.
    wa_tad1-net = wa_tac7-net.
    COLLECT wa_tad1 INTO it_tad1.
    CLEAR wa_tad1.
  ENDLOOP.
*    ULINE.

  LOOP AT it_tad1 INTO wa_tad1.
    CLEAR : bc,bcl,xl,ls.
*      WRITE : / '*',WA_TAD1-REG, WA_TAD1-ZM, WA_TAD1-RM, WA_TAD1-BZIRK,WA_TAD1-PLANS, WA_TAD1-SVAL,WA_TAD1-ACN_VAL, WA_TAD1-OTH_VAL, WA_TAD1-NET.
    wa_tad2-reg = wa_tad1-reg.
    wa_tad2-zm = wa_tad1-zm.
    wa_tad2-rm = wa_tad1-rm.
    wa_tad2-bzirk = wa_tad1-bzirk.
    wa_tad2-plans = wa_tad1-plans.
    wa_tad2-sval = wa_tad1-sval.
    wa_tad2-acn_val = wa_tad1-acn_val.
    wa_tad2-oth_val = wa_tad1-oth_val.
    wa_tad2-net = wa_tad1-net.
*    READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD1-PLANS SPART = '50'.
*    IF SY-SUBRC EQ 0.
*      bc = 1.
*      READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD1-PLANS SPART = '60'.
*      IF SY-SUBRC EQ 0.
*        BCL = 1.
*      ELSE.
*        BC = 1.
*      ENDIF.
*    ELSE.
*      READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY PLANS = WA_TAD1-PLANS SPART = '60'.
*      IF SY-SUBRC EQ 0.
*        XL = 1.
*      ENDIF.
*    ENDIF.

    CLEAR : dcount.
    READ TABLE it_tac7 INTO wa_tac7 WITH KEY plans = wa_tad1-plans spart = '50'.
    IF sy-subrc EQ 0.
      bc = 1.
      dcount = dcount + 1.
    ENDIF.
    READ TABLE it_tac7 INTO wa_tac7 WITH KEY plans = wa_tad1-plans spart = '60'.
    IF sy-subrc EQ 0.
      xl = 1.
      dcount = dcount + 1.
    ENDIF.
    READ TABLE it_tac7 INTO wa_tac7 WITH KEY plans = wa_tad1-plans spart = '70'.
    IF sy-subrc EQ 0.
      ls = 1.
      dcount = dcount + 1.
    ENDIF.

    IF dcount GT 1.
      bcl = 1.
    ENDIF.


    IF bcl EQ 1.
*        WRITE :  'DIVISION IS BCL'.
      wa_tad2-div = 'BCL'.
    ELSEIF xl EQ 1.
*        WRITE :  'DIVISION IS XL'.
      wa_tad2-div = 'XL'.
    ELSEIF ls EQ 1.
*        WRITE :  'DIVISION IS XL'.
      wa_tad2-div = 'LS'.
    ELSEIF bc EQ 1.
*        WRITE :  'DIVISION IS BC'.
      wa_tad2-div = 'BC'.
    ENDIF.


    SELECT SINGLE * FROM ysd_dist_targt WHERE bzirk EQ wa_tad1-bzirk AND trgyear EQ year1.
    IF sy-subrc EQ 0.
      IF month EQ '04'.
        wa_tad2-targt = ysd_dist_targt-month01.
      ELSEIF month EQ '05'.
        wa_tad2-targt = ysd_dist_targt-month02.
      ELSEIF month EQ '06'.
        wa_tad2-targt = ysd_dist_targt-month03.
      ELSEIF month EQ '07'.
        wa_tad2-targt = ysd_dist_targt-month04.
      ELSEIF month EQ '08'.
        wa_tad2-targt = ysd_dist_targt-month05.
      ELSEIF month EQ '09'.
        wa_tad2-targt = ysd_dist_targt-month06.
      ELSEIF month EQ '10'.
        wa_tad2-targt = ysd_dist_targt-month07.
      ELSEIF month EQ '11'.
        wa_tad2-targt = ysd_dist_targt-month08.
      ELSEIF month EQ '12'.
        wa_tad2-targt = ysd_dist_targt-month09.
      ELSEIF month EQ '01'.
        wa_tad2-targt = ysd_dist_targt-month10.
      ELSEIF month EQ '02'.
        wa_tad2-targt = ysd_dist_targt-month11.
      ELSEIF month EQ '03'.
        wa_tad2-targt = ysd_dist_targt-month12.
      ENDIF.

      IF month EQ '04'.
        wa_tad2-targt1 = ysd_dist_targt-month01.
      ELSEIF month EQ '05'.
        wa_tad2-targt1 = ysd_dist_targt-month02.
      ELSEIF month EQ '06'.
        wa_tad2-targt1 = ysd_dist_targt-month03.
      ELSEIF month EQ '07'.
        wa_tad2-targt1 = ysd_dist_targt-month04.
      ELSEIF month EQ '08'.
        wa_tad2-targt1 = ysd_dist_targt-month05.
      ELSEIF month EQ '09'.
        wa_tad2-targt1 = ysd_dist_targt-month06.
      ELSEIF month EQ '10'.
        wa_tad2-targt1 = ysd_dist_targt-month07.
      ELSEIF month EQ '11'.
        wa_tad2-targt1 = ysd_dist_targt-month08.
      ELSEIF month EQ '12'.
        wa_tad2-targt1 = ysd_dist_targt-month09.
      ELSEIF month EQ '01'.
        wa_tad2-targt1 = ysd_dist_targt-month10.
      ELSEIF month EQ '02'.
        wa_tad2-targt1 = ysd_dist_targt-month11.
      ELSEIF month EQ '03'.
        wa_tad2-targt1 = ysd_dist_targt-month12.
      ENDIF.
    ELSE.
      SELECT SINGLE * FROM ysd_hbe_targt WHERE bzirk EQ wa_tad1-bzirk AND trgyear EQ year1.
      IF sy-subrc EQ 0.
        IF month EQ '04'.
          wa_tad2-targt1 = ysd_hbe_targt-month01.
        ELSEIF month EQ '05'.
          wa_tad2-targt1 = ysd_hbe_targt-month02.
        ELSEIF month EQ '06'.
          wa_tad2-targt1 = ysd_hbe_targt-month03.
        ELSEIF month EQ '07'.
          wa_tad2-targt1 = ysd_hbe_targt-month04.
        ELSEIF month EQ '08'.
          wa_tad2-targt1 = ysd_hbe_targt-month05.
        ELSEIF month EQ '09'.
          wa_tad2-targt1 = ysd_hbe_targt-month06.
        ELSEIF month EQ '10'.
          wa_tad2-targt1 = ysd_hbe_targt-month07.
        ELSEIF month EQ '11'.
          wa_tad2-targt1 = ysd_hbe_targt-month08.
        ELSEIF month EQ '12'.
          wa_tad2-targt1 = ysd_hbe_targt-month09.
        ELSEIF month EQ '01'.
          wa_tad2-targt1 = ysd_hbe_targt-month10.
        ELSEIF month EQ '02'.
          wa_tad2-targt1 = ysd_hbe_targt-month11.
        ELSEIF month EQ '03'.
          wa_tad2-targt1 = ysd_hbe_targt-month12.
        ENDIF.
      ENDIF.
    ENDIF.


    SELECT SINGLE * FROM zoneseq WHERE zone_dist EQ wa_tad1-reg.
    IF sy-subrc EQ 0.
      wa_tad2-seq = zoneseq-seq.
    ENDIF.
    COLLECT wa_tad2 INTO it_tad2.
    CLEAR wa_tad2.
  ENDLOOP.

*  LOOP AT IT_TAD2 INTO WA_TAD2.
*    IF DV1 EQ 'X'.
*      DELETE IT_TAD2 WHERE DIV = 'XL'.
*    ELSEIF DV2 EQ 'X'.
*      DELETE IT_TAD2 WHERE DIV = 'BC'.
*      DELETE IT_TAD2 WHERE DIV = 'BCL'.
*    ENDIF.
*  ENDLOOP.
*  IF RAD2 NE 'X'.
  IF r8 EQ 'X'.
  ELSEIF r9 EQ 'X'.
  ELSE.
    LOOP AT it_tad2 INTO wa_tad2.
      IF dv1 EQ 'X'.
        DELETE it_tad2 WHERE div = 'XL'.
        DELETE it_tad2 WHERE div = 'LS'.
      ELSEIF dv2 EQ 'X'.
        DELETE it_tad2 WHERE div = 'BC'.
        DELETE it_tad2 WHERE div = 'BCL'.
        DELETE it_tad2 WHERE div = 'LS'.
      ELSEIF dv4 EQ 'X'.
        DELETE it_tad2 WHERE div = 'BC'.
        DELETE it_tad2 WHERE div = 'XL'.
        DELETE it_tad2 WHERE div = 'BCL'.
      ENDIF.
    ENDLOOP.
  ENDIF.
  IF it_tad2 IS INITIAL.
    MESSAGE 'NO DATA FOUND' TYPE 'E'.
  ENDIF.

  LOOP AT it_tad2 INTO wa_tad2.
*      WRITE : / '**',WA_TAD2-REG,WA_TAD2-BZIRK, WA_TAD2-DIV,wa_tad2-net.
    wa_tad3-reg = wa_tad2-reg.
    wa_tad3-bzirk = wa_tad2-bzirk.
    wa_tad3-div = wa_tad2-div.
    COLLECT wa_tad3 INTO it_tad3.
    CLEAR wa_tad3.
    wa_tad21-reg = wa_tad2-reg.
    wa_tad21-div = wa_tad2-div.
    wa_tad21-net = wa_tad2-net.
    COLLECT wa_tad21 INTO it_tad21.
    CLEAR wa_tad21.
*       WA_TAD2-ZM, WA_TAD2-RM,  WA_TAD2-PLANS, WA_TAD2-SVAL, WA_TAD2-ACN_VAL, WA_TAD2-OTH_VAL, WA_TAD2-NET,,WA_TAD2-TARGT.
  ENDLOOP.
  SORT it_tad21 BY reg div.
*    LOOP at it_tad21 INTO wa_tad21.
**      WRITE : /'**', wa_tad21-reg,wa_tad21-div,wa_tad21-net.
*    ENDLOOP.

  SORT it_tad3 BY reg div.
  LOOP AT it_tad3 INTO wa_tad3.
    ON CHANGE OF wa_tad3-reg.
      count1 = 1.
    ENDON.
    ON CHANGE OF wa_tad3-div.
      count1 = 1.
    ENDON.
*      WRITE : / WA_TAD3-REG,WA_TAD3-BZIRK,WA_TAD3-DIV,COUNT1.

    wa_tad4-reg = wa_tad3-reg.
    wa_tad4-div = wa_tad3-div.
    wa_tad4-count = count1.
    APPEND wa_tad4 TO it_tad4.
    CLEAR wa_tad4.
    count1 = count1 + 1.
  ENDLOOP.
  SORT it_tad4 DESCENDING BY count.

*    ULINE.
*    LOOP AT IT_TAD4 INTO WA_TAD4.
*      WRITE : / 'FINAL', WA_TAD4-REG,WA_TAD4-DIV,WA_TAD4-COUNT.
*    ENDLOOP.

  SORT it_tad2 BY seq reg zm rm bzirk.



****************************LAYOUT ENDA HERE******
****************smartform*******************
  IF r6 EQ 'X'.
    LOOP AT it_tac7 INTO wa_tac7.
      wa_check-reg = wa_tac7-reg.
      wa_check-zm = wa_tac7-zm.
      wa_check-zonename = wa_tac7-zzz_hqdesc.
      COLLECT wa_check INTO it_check.
      CLEAR wa_check.
    ENDLOOP.
    SORT it_check BY reg zm.
    DELETE ADJACENT DUPLICATES FROM it_check COMPARING reg zm.
    DELETE it_check WHERE zm EQ space.

  ELSEIF r4 EQ 'X'.
    LOOP AT it_tac7 INTO wa_tac7.
      wa_check-reg = wa_tac7-reg.
      wa_check-zm = wa_tac7-zm.
      wa_check-rm = wa_tac7-rm.
      wa_check-zonename = wa_tac7-zzz_hqdesc.
      COLLECT wa_check INTO it_check.
      CLEAR wa_check.
    ENDLOOP.
    SORT it_check BY reg zm rm.
    DELETE ADJACENT DUPLICATES FROM it_check COMPARING reg zm rm.

  ELSE.

    LOOP AT it_tac7 INTO wa_tac7.
      wa_check-reg = wa_tac7-reg.
      wa_check-zonename = wa_tac7-zzz_hqdesc.
      COLLECT wa_check INTO it_check.
      CLEAR wa_check.
    ENDLOOP.
    SORT it_check BY reg.
    DELETE ADJACENT DUPLICATES FROM it_check COMPARING reg.
  ENDIF.

  LOOP AT it_check INTO wa_check.
    READ TABLE it_tad2 INTO wa_tad2 WITH KEY reg = wa_check-reg.
    IF sy-subrc EQ 4.
      DELETE it_check WHERE reg = wa_check-reg.
    ENDIF.
  ENDLOOP.
  LOOP AT it_check INTO wa_check.
    SELECT SINGLE * FROM zoneseq WHERE zone_dist EQ wa_check-reg.
    IF sy-subrc EQ 0.
      wa_check-seq = zoneseq-seq.
      MODIFY it_check FROM wa_check TRANSPORTING seq.
      CLEAR wa_check.
    ENDIF.
  ENDLOOP.
  SORT it_check BY seq.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SFFORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sfform1 .

  LOOP AT it_check INTO wa_check.
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
*       FORMNAME           = 'ZSR9_9'
        formname           = 'ZSR9_A1'
*       VARIANT            = ' '
*       DIRECT_CALL        = ' '
      IMPORTING
        fm_name            = v_fm
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

*  CONTROL-NO_OPEN   = 'X'.
*  CONTROL-NO_CLOSE  = 'X'.
*  CALL FUNCTION 'SSF_OPEN'
*    EXPORTING
*      CONTROL_PARAMETERS = CONTROL.

*   * Set the control parameter
    w_ctrlop-getotf = abap_true.
    w_ctrlop-no_dialog = abap_true.
    w_compop-tdnoprev = abap_true.
    w_ctrlop-preview = space.
    w_compop-tddest = 'LOCL'.


*  LOOP AT IT_CHECK INTO WA_CHECK.
*    BREAK-POINT .
    CLEAR : zonename.
    zonename = wa_check-zonename.
*    WRITE : / 'ZONE',ZONENAME.
    CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.
    PERFORM form1.



    READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_check-reg.
    IF sy-subrc EQ 0.
      regename = wa_tac7-zename.
      IF regename EQ space.
        regename = 'VACANT'.
      ENDIF.
      reghqdesc = wa_tac7-zzz_hqdesc.
      CONCATENATE wa_tac7-zbegda+4(2) '/ ' wa_tac7-zbegda+0(4) INTO regjoindt.
      regshort = wa_tac7-zshort.
    ENDIF.

    READ TABLE it_reg1 INTO wa_reg1 WITH KEY reg = wa_check-reg.
    IF sy-subrc EQ 0.
      regnet = wa_reg1-regtot.
      regtargt1 = wa_reg1-regtar.
      CLEAR: regstp.
      regstp = ( wa_reg1-regtot / wa_reg1-regtar ) * 100.
      regstp1 = regstp.
      CONDENSE : regnet,regtargt1,regstp1.
    ENDIF.
    CLEAR : c_bcl,c_tot,p_bcl, c_bc,p_bc,c_xl,p_xl,c_ls,p_ls.
    READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_check-reg div = 'BCL'.
    IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
      c_bcl = wa_tad4-count.
      c_tot = c_tot + wa_tad4-count.
      READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_check-reg div = 'BCL'.
      IF sy-subrc EQ 0.
        p_bcl = wa_tad21-net / c_bcl.
*            P_TOT = P_TOT + P_BCL.
      ENDIF.
      bcl1 = 'Y'.
    ENDIF.
    READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_check-reg div = 'BC'.
    IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
      c_bc = wa_tad4-count.
      c_tot = c_tot + wa_tad4-count.
      READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_check-reg div = 'BC'.
      IF sy-subrc EQ 0.
        p_bc = wa_tad21-net / c_bc.
*            P_TOT = P_TOT + P_BCL.
      ENDIF.
      bc1 = 'Y'.
    ENDIF.
    READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_check-reg div = 'XL'.
    IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
      c_xl = wa_tad4-count.
      c_tot = c_tot + wa_tad4-count.
      READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_check-reg div = 'XL'.
      IF sy-subrc EQ 0.
        p_xl = wa_tad21-net / c_xl.
*            P_TOT = P_TOT + P_BCL.
      ENDIF.
      xl1 = 'Y'.
    ENDIF.
    READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_check-reg div = 'LS'.
    IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
      c_ls = wa_tad4-count.
      c_tot = c_tot + wa_tad4-count.
      READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_check-reg div = 'LS'.
      IF sy-subrc EQ 0.
        p_ls = wa_tad21-net / c_ls.
*            P_TOT = P_TOT + P_BCL.
      ENDIF.
      ls1 = 'Y'.
    ENDIF.
    CLEAR : p_tot1,p_tot2.
    READ TABLE it_reg1 INTO wa_reg1 WITH KEY reg = wa_check-reg.
    IF sy-subrc EQ 0.
      p_tot1 = wa_reg1-regtot / c_tot.
    ENDIF.

    c_bcl1              = c_bcl.
    c_bc1               = c_bc.
    c_xl1               = c_xl.
    c_ls1               = c_ls.
    p_bcl1              = p_bcl.
    p_bc1               = p_bc.
    p_xl1               = p_xl.
    p_ls1               = p_ls.
    c_tot1 = c_tot.
    stpcnt2 = stpcnt1.
    p_tot2 = p_tot1.
    CONDENSE : c_bcl1,c_bc1,c_xl1,c_ls1,p_bcl1,p_bc1,p_xl1,p_ls1,stpcnt2,c_tot1,p_tot2.

    CALL FUNCTION v_fm
      EXPORTING
        control_parameters = w_ctrlop
        output_options     = w_compop
        user_settings      = abap_true
        format             = format
        zonename           = zonename
        regename           = regename
        reghqdesc          = reghqdesc
        regjoindt          = regjoindt
        regshort           = regshort
        regnet             = regnet
        regtargt1          = regtargt1
        regstp1            = regstp1
        s_budat1           = s_budat1
        s_budat2           = s_budat2
        c_bcl1             = c_bcl1
        c_bc1              = c_bc1
        c_xl1              = c_xl1
        c_ls1              = c_ls1
        p_bcl1             = p_bcl1
        p_bc1              = p_bc1
        p_xl1              = p_xl1
        p_ls1              = p_ls1
        stpcnt2            = stpcnt2
        p_tot1             = p_tot2
        c_tot1             = c_tot1
        bcl1               = bcl1
        bc1                = bc1
        xl1                = xl1
        ls1                = ls1
      IMPORTING
        job_output_info    = w_return " This will have all output
      TABLES
        it_sf1             = it_sf1
        it_sf2             = it_sf2
        it_sf3             = it_sf3
*       itab_division      = itab_division
*       itab_storage       = itab_storage
*       itab_pa0002        = itab_pa0002
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.
    CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.

    CLEAR : zonename,  regename, reghqdesc,regjoindt, regshort, regnet ,regtargt1,regstp1,c_bcl1, c_bc1,c_xl1,
      c_ls1 , p_bcl1 ,p_bc1,p_xl1,p_ls1,stpcnt2,p_tot1, c_tot1 .
*  ENDLOOP.
    CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.

    i_otf[] = w_return-otfdata[].

* Import Binary file and filesize
    CALL FUNCTION 'CONVERT_OTF'
      EXPORTING
        format                = 'PDF'
        max_linewidth         = 132
      IMPORTING
        bin_filesize          = v_len_in
        bin_file              = i_xstring   " This is NOT Binary. This is Hexa
      TABLES
        otf                   = i_otf
        lines                 = i_tline
      EXCEPTIONS
        err_max_linewidth     = 1
        err_format            = 2
        err_conv_not_possible = 3
        OTHERS                = 4.
* Sy-subrc check not checked



*  * Convert Hexa String to Binary format
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer     = i_xstring
      TABLES
        binary_tab = i_objbin[].
* Sy-subrc check not required.

*    DATA: IN_MAILID TYPE AD_SMTPADR.

* Begin of sending email to multiple users
* If business want email to be sent to all users at one time, it can be done

* For now we do not want to send 1 email to multiple users
* Mail has to be sent one email at a time

*  IF P2 EQ 'X'.
*
*      CLEAR IN_MAILID.
    in_mailid = 'JYOTSNA@BLUECROSSLABS.COM'.
    PERFORM send_mail USING in_mailid .
  ENDLOOP.
*  CALL FUNCTION 'SSF_CLOSE'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SEND_MAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IN_MAILID  text
*----------------------------------------------------------------------*
FORM send_mail  USING    p_in_mailid.

  DATA: salutation TYPE string.
  DATA: body TYPE string.
  DATA: footer TYPE string.

  DATA: lo_send_request TYPE REF TO cl_bcs,
        lo_document     TYPE REF TO cl_document_bcs,
        lo_sender       TYPE REF TO if_sender_bcs,
        lo_recipient    TYPE REF TO if_recipient_bcs VALUE IS INITIAL,lt_message_body TYPE bcsy_text,
        lx_document_bcs TYPE REF TO cx_document_bcs,
        lv_sent_to_all  TYPE os_boolean.

  "create send request
  lo_send_request = cl_bcs=>create_persistent( ).

  "create message body and subject
  salutation ='Dear Sir/Madam,'.
  APPEND salutation TO lt_message_body.
  APPEND INITIAL LINE TO lt_message_body.

  body = 'Please find the attached SR9 REPORT in PDF format.'.

  APPEND body TO lt_message_body.
  APPEND INITIAL LINE TO lt_message_body.

  footer = 'With Regards,'.
  APPEND footer TO lt_message_body.
  footer = 'BLUE CROSS LABORATORIES PVT LTD.'.
  APPEND footer TO lt_message_body.

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
i_subject = 'SR9 REPORT' ).

*DATA: l_size TYPE sood-objlen. " Size of Attachment
*l_size = l_lines * 255.
  TRY.

      lo_document->add_attachment(
      EXPORTING
      i_attachment_type = 'PDF'
      i_attachment_subject = 'SR9 REPORT'
      i_att_content_hex = i_objbin[] ).
    CATCH cx_document_bcs INTO lx_document_bcs.

  ENDTRY.


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
  EXPORTING
  i_recipient = lo_recipient
  i_express = abap_true
  ).

  lo_send_request->add_recipient( lo_recipient ).

* Send email
  lo_send_request->send(
  EXPORTING
  i_with_error_screen = abap_true
  RECEIVING
  result = lv_sent_to_all ).

  CONCATENATE 'Email sent to' in_mailid INTO DATA(lv_msg) SEPARATED BY space.
  WRITE:/ lv_msg COLOR COL_POSITIVE.
  SKIP.
* Commit Work to send the email
  COMMIT WORK.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SFFORM2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sfform2 .


  LOOP AT it_zmemail INTO wa_zmemail .
    LOOP AT it_check INTO wa_check WHERE reg EQ wa_zmemail-reg.
      CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
        EXPORTING
*         FORMNAME           = 'ZSR9_9'
          formname           = 'ZSR9_A1'
*         VARIANT            = ' '
*         DIRECT_CALL        = ' '
        IMPORTING
          fm_name            = v_fm
        EXCEPTIONS
          no_form            = 1
          no_function_module = 2
          OTHERS             = 3.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

*  CONTROL-NO_OPEN   = 'X'.
*  CONTROL-NO_CLOSE  = 'X'.
*  CALL FUNCTION 'SSF_OPEN'
*    EXPORTING
*      CONTROL_PARAMETERS = CONTROL.

*   * Set the control parameter
      w_ctrlop-getotf = abap_true.
      w_ctrlop-no_dialog = abap_true.
      w_compop-tdnoprev = abap_true.
      w_ctrlop-preview = space.
      w_compop-tddest = 'LOCL'.


*  LOOP AT IT_CHECK INTO WA_CHECK.
*    BREAK-POINT .
      CLEAR : zonename.
      zonename = wa_check-zonename.
*    WRITE : / 'ZONE',ZONENAME.
      CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.
      PERFORM form1.
      PERFORM form2.


      CALL FUNCTION v_fm
        EXPORTING
          control_parameters = w_ctrlop
          output_options     = w_compop
          user_settings      = abap_true
          format             = format
          zonename           = zonename
          regename           = regename
          reghqdesc          = reghqdesc
          regjoindt          = regjoindt
          regshort           = regshort
          regnet             = regnet
          regtargt1          = regtargt1
          regstp1            = regstp1
          s_budat1           = s_budat1
          s_budat2           = s_budat2
          c_bcl1             = c_bcl1
          c_bc1              = c_bc1
          c_xl1              = c_xl1
          c_ls1              = c_ls1
          p_bcl1             = p_bcl1
          p_bc1              = p_bc1
          p_xl1              = p_xl1
          p_ls1              = p_ls1
          stpcnt2            = stpcnt2
          p_tot1             = p_tot2
          c_tot1             = c_tot1
          bcl1               = bcl1
          bc1                = bc1
          xl1                = xl1
          ls1                = ls1
        IMPORTING
          job_output_info    = w_return " This will have all output
        TABLES
          it_sf1             = it_sf1
          it_sf2             = it_sf2
          it_sf3             = it_sf3
*         itab_division      = itab_division
*         itab_storage       = itab_storage
*         itab_pa0002        = itab_pa0002
        EXCEPTIONS
          formatting_error   = 1
          internal_error     = 2
          send_error         = 3
          user_canceled      = 4
          OTHERS             = 5.
      CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.

      CLEAR : zonename,  regename, reghqdesc,regjoindt, regshort, regnet ,regtargt1,regstp1,c_bcl1, c_bc1,c_xl1,
        c_ls1 , p_bcl1 ,p_bc1,p_xl1,p_ls1,stpcnt2,p_tot1, c_tot1 ,bcl1,bc1,xl1,ls1.
*  ENDLOOP.
      CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.


      i_otf[] = w_return-otfdata[].

* Import Binary file and filesize
      CALL FUNCTION 'CONVERT_OTF'
        EXPORTING
          format                = 'PDF'
          max_linewidth         = 132
        IMPORTING
          bin_filesize          = v_len_in
          bin_file              = i_xstring   " This is NOT Binary. This is Hexa
        TABLES
          otf                   = i_otf
          lines                 = i_tline
        EXCEPTIONS
          err_max_linewidth     = 1
          err_format            = 2
          err_conv_not_possible = 3
          OTHERS                = 4.
* Sy-subrc check not checked



*  * Convert Hexa String to Binary format
      CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
        EXPORTING
          buffer     = i_xstring
        TABLES
          binary_tab = i_objbin[].
* Sy-subrc check not required.

*    DATA: IN_MAILID TYPE AD_SMTPADR.

* Begin of sending email to multiple users
* If business want email to be sent to all users at one time, it can be done

* For now we do not want to send 1 email to multiple users
* Mail has to be sent one email at a time

*  IF P2 EQ 'X'.
*
*      CLEAR IN_MAILID.
*    IN_MAILID = 'JYOTSNA@BLUECROSSLABS.COM'.
      in_mailid = wa_zmemail-usrid_long.
*      BREAK-POINT .
      PERFORM send_mail USING in_mailid .
*      BREAK-POINT.
*      WRITE : / WA_ZMEMAIL-REG.
    ENDLOOP.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FORM2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM form2 .
*  READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY REG = WA_CHECK-REG.
*  IF SY-SUBRC EQ 0.
*    REGENAME = WA_TAC7-ZENAME.
*    IF REGENAME EQ SPACE.
*      REGENAME = 'VACANT'.
*    ENDIF.
*    REGHQDESC = WA_TAC7-ZZZ_HQDESC.
*    CONCATENATE WA_TAC7-ZBEGDA+4(2) '/ ' WA_TAC7-ZBEGDA+0(4) INTO REGJOINDT.
*    REGSHORT = WA_TAC7-ZSHORT.
*  ENDIF.
*
*  READ TABLE IT_REG1 INTO WA_REG1 WITH KEY REG = WA_CHECK-REG.
*  IF SY-SUBRC EQ 0.
*    REGNET = WA_REG1-REGTOT.
*    REGTARGT1 = WA_REG1-REGTAR.
*    CLEAR: REGSTP.
*    REGSTP = ( WA_REG1-REGTOT / WA_REG1-REGTAR ) * 100.
*    REGSTP1 = REGSTP.
*    CONDENSE : REGNET,REGTARGT1,REGSTP1.
*  ENDIF.
*  CLEAR : C_BCL,C_TOT,P_BCL, C_BC,P_BC,C_XL,P_XL,C_LS,P_LS.
*  READ TABLE IT_TAD4 INTO WA_TAD4 WITH  KEY REG = WA_CHECK-REG DIV = 'BCL'.
*  IF SY-SUBRC EQ 0 AND WA_TAD4-COUNT NE 0.
*    C_BCL = WA_TAD4-COUNT.
*    C_TOT = C_TOT + WA_TAD4-COUNT.
*    READ TABLE IT_TAD21 INTO WA_TAD21 WITH KEY REG = WA_CHECK-REG DIV = 'BCL'.
*    IF SY-SUBRC EQ 0.
*      P_BCL = WA_TAD21-NET / C_BCL.
**            P_TOT = P_TOT + P_BCL.
*    ENDIF.
*    BCL1 = 'Y'.
*  ENDIF.
*  READ TABLE IT_TAD4 INTO WA_TAD4 WITH  KEY REG = WA_CHECK-REG DIV = 'BC'.
*  IF SY-SUBRC EQ 0 AND WA_TAD4-COUNT NE 0.
*    C_BC = WA_TAD4-COUNT.
*    C_TOT = C_TOT + WA_TAD4-COUNT.
*    READ TABLE IT_TAD21 INTO WA_TAD21 WITH KEY REG = WA_CHECK-REG DIV = 'BC'.
*    IF SY-SUBRC EQ 0.
*      P_BC = WA_TAD21-NET / C_BC.
**            P_TOT = P_TOT + P_BCL.
*    ENDIF.
*    BC1 = 'Y'.
*  ENDIF.
*  READ TABLE IT_TAD4 INTO WA_TAD4 WITH  KEY REG = WA_CHECK-REG DIV = 'XL'.
*  IF SY-SUBRC EQ 0 AND WA_TAD4-COUNT NE 0.
*    C_XL = WA_TAD4-COUNT.
*    C_TOT = C_TOT + WA_TAD4-COUNT.
*    READ TABLE IT_TAD21 INTO WA_TAD21 WITH KEY REG = WA_CHECK-REG DIV = 'XL'.
*    IF SY-SUBRC EQ 0.
*      P_XL = WA_TAD21-NET / C_XL.
**            P_TOT = P_TOT + P_BCL.
*    ENDIF.
*    XL1 = 'Y'.
*  ENDIF.
*  READ TABLE IT_TAD4 INTO WA_TAD4 WITH  KEY REG = WA_CHECK-REG DIV = 'LS'.
*  IF SY-SUBRC EQ 0 AND WA_TAD4-COUNT NE 0.
*    C_LS = WA_TAD4-COUNT.
*    C_TOT = C_TOT + WA_TAD4-COUNT.
*    READ TABLE IT_TAD21 INTO WA_TAD21 WITH KEY REG = WA_CHECK-REG DIV = 'LS'.
*    IF SY-SUBRC EQ 0.
*      P_LS = WA_TAD21-NET / C_LS.
**            P_TOT = P_TOT + P_BCL.
*    ENDIF.
*    LS1 = 'Y'.
*  ENDIF.
*  CLEAR : P_TOT1,P_TOT2.
*  READ TABLE IT_REG1 INTO WA_REG1 WITH KEY REG = WA_CHECK-REG.
*  IF SY-SUBRC EQ 0.
*    P_TOT1 = WA_REG1-REGTOT / C_TOT.
*  ENDIF.
*
*  C_BCL1              = C_BCL.
*  C_BC1               = C_BC.
*  C_XL1               = C_XL.
*  C_LS1               = C_LS.
*  P_BCL1              = P_BCL.
*  P_BC1               = P_BC.
*  P_XL1               = P_XL.
*  P_LS1               = P_LS.
*  C_TOT1 = C_TOT.
*  STPCNT2 = STPCNT1.
*  P_TOT2 = P_TOT1.
*  CONDENSE : C_BCL1,C_BC1,C_XL1,C_LS1,P_BCL1,P_BC1,P_XL1,P_LS1,STPCNT2,C_TOT1,P_TOT2.
*

  READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_check-reg.
  IF sy-subrc EQ 0.
    regename = wa_tac7-zename.
    IF regename EQ space.
      regename = 'VACANT'.
    ENDIF.
    reghqdesc = wa_tac7-zzz_hqdesc.
    CONCATENATE wa_tac7-zbegda+4(2) '/ ' wa_tac7-zbegda+0(4) INTO regjoindt.
    regshort = wa_tac7-zshort.
  ENDIF.

  READ TABLE it_reg1 INTO wa_reg1 WITH KEY reg = wa_check-reg.
  IF sy-subrc EQ 0.
    regnet = wa_reg1-regtot.
    regtargt1 = wa_reg1-regtar.
    CLEAR: regstp.
    regstp = ( wa_reg1-regtot / wa_reg1-regtar ) * 100.
    regstp1 = regstp.
    CONDENSE : regnet,regtargt1,regstp1.
  ENDIF.
  CLEAR : c_bcl,c_tot,p_bcl, c_bc,p_bc,c_xl,p_xl,c_ls,p_ls.
  READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_check-reg div = 'BCL'.
  IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
    c_bcl = wa_tad4-count.
    c_tot = c_tot + wa_tad4-count.
    READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_check-reg div = 'BCL'.
    IF sy-subrc EQ 0.
      p_bcl = wa_tad21-net / c_bcl.
*            P_TOT = P_TOT + P_BCL.
    ENDIF.
    bcl1 = 'Y'.
  ENDIF.
  READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_check-reg div = 'BC'.
  IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
    c_bc = wa_tad4-count.
    c_tot = c_tot + wa_tad4-count.
    READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_check-reg div = 'BC'.
    IF sy-subrc EQ 0.
      p_bc = wa_tad21-net / c_bc.
*            P_TOT = P_TOT + P_BCL.
    ENDIF.
    bc1 = 'Y'.
  ENDIF.
  READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_check-reg div = 'XL'.
  IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
    c_xl = wa_tad4-count.
    c_tot = c_tot + wa_tad4-count.
    READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_check-reg div = 'XL'.
    IF sy-subrc EQ 0.
      p_xl = wa_tad21-net / c_xl.
*            P_TOT = P_TOT + P_BCL.
    ENDIF.
    xl1 = 'Y'.
  ENDIF.
  READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_check-reg div = 'LS'.
  IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
    c_ls = wa_tad4-count.
    c_tot = c_tot + wa_tad4-count.
    READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_check-reg div = 'LS'.
    IF sy-subrc EQ 0.
      p_ls = wa_tad21-net / c_ls.
*            P_TOT = P_TOT + P_BCL.
    ENDIF.
    ls1 = 'Y'.
  ENDIF.
  CLEAR : p_tot1,p_tot2.
  READ TABLE it_reg1 INTO wa_reg1 WITH KEY reg = wa_check-reg.
  IF sy-subrc EQ 0.
    p_tot1 = wa_reg1-regtot / c_tot.
  ENDIF.

  c_bcl1              = c_bcl.
  c_bc1               = c_bc.
  c_xl1               = c_xl.
  c_ls1               = c_ls.
  p_bcl1              = p_bcl.
  p_bc1               = p_bc.
  p_xl1               = p_xl.
  p_ls1               = p_ls.
  c_tot1 = c_tot.
  stpcnt2 = stpcnt1.
  p_tot2 = p_tot1.
  CONDENSE : c_bcl1,c_bc1,c_xl1,c_ls1,p_bcl1,p_bc1,p_xl1,p_ls1,stpcnt2,c_tot1,p_tot2.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SFFORM3
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sfform3 .
  LOOP AT it_rmemail INTO wa_rmemail .
    LOOP AT it_check1 INTO wa_check1 WHERE reg EQ wa_rmemail-reg AND rm EQ wa_rmemail-rm.
      CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
        EXPORTING
*         FORMNAME           = 'ZSR9_9'
          formname           = 'ZSR9_A1'
*         VARIANT            = ' '
*         DIRECT_CALL        = ' '
        IMPORTING
          fm_name            = v_fm
        EXCEPTIONS
          no_form            = 1
          no_function_module = 2
          OTHERS             = 3.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

*  CONTROL-NO_OPEN   = 'X'.
*  CONTROL-NO_CLOSE  = 'X'.
*  CALL FUNCTION 'SSF_OPEN'
*    EXPORTING
*      CONTROL_PARAMETERS = CONTROL.

*   * Set the control parameter
      w_ctrlop-getotf = abap_true.
      w_ctrlop-no_dialog = abap_true.
      w_compop-tdnoprev = abap_true.
      w_ctrlop-preview = space.
      w_compop-tddest = 'LOCL'.


*  LOOP AT IT_CHECK INTO WA_CHECK.
*    BREAK-POINT .
      CLEAR : zonename.
      zonename = wa_check1-zonename.
*    WRITE : / 'ZONE',ZONENAME.
      CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.
*      PERFORM FORM1.
      PERFORM rform1.
*      PERFORM FORM2.
      PERFORM rform2.


      CALL FUNCTION v_fm
        EXPORTING
          control_parameters = w_ctrlop
          output_options     = w_compop
          user_settings      = abap_true
          format             = format
          zonename           = zonename
          regename           = regename
          reghqdesc          = reghqdesc
          regjoindt          = regjoindt
          regshort           = regshort
          regnet             = regnet
          regtargt1          = regtargt1
          regstp1            = regstp1
          s_budat1           = s_budat1
          s_budat2           = s_budat2
          c_bcl1             = c_bcl1
          c_bc1              = c_bc1
          c_xl1              = c_xl1
          c_ls1              = c_ls1
          p_bcl1             = p_bcl1
          p_bc1              = p_bc1
          p_xl1              = p_xl1
          p_ls1              = p_ls1
          stpcnt2            = stpcnt2
          p_tot1             = p_tot2
          c_tot1             = c_tot1
          bcl1               = bcl1
          bc1                = bc1
          xl1                = xl1
          ls1                = ls1
        IMPORTING
          job_output_info    = w_return " This will have all output
        TABLES
          it_sf1             = it_sf1
          it_sf2             = it_sf2
          it_sf3             = it_sf3
*         itab_division      = itab_division
*         itab_storage       = itab_storage
*         itab_pa0002        = itab_pa0002
        EXCEPTIONS
          formatting_error   = 1
          internal_error     = 2
          send_error         = 3
          user_canceled      = 4
          OTHERS             = 5.
      CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.

      CLEAR : zonename,  regename, reghqdesc,regjoindt, regshort, regnet ,regtargt1,regstp1,c_bcl1, c_bc1,c_xl1,
        c_ls1 , p_bcl1 ,p_bc1,p_xl1,p_ls1,stpcnt2,p_tot1, c_tot1 .
*  ENDLOOP.
      CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.


      i_otf[] = w_return-otfdata[].

* Import Binary file and filesize
      CALL FUNCTION 'CONVERT_OTF'
        EXPORTING
          format                = 'PDF'
          max_linewidth         = 132
        IMPORTING
          bin_filesize          = v_len_in
          bin_file              = i_xstring   " This is NOT Binary. This is Hexa
        TABLES
          otf                   = i_otf
          lines                 = i_tline
        EXCEPTIONS
          err_max_linewidth     = 1
          err_format            = 2
          err_conv_not_possible = 3
          OTHERS                = 4.
* Sy-subrc check not checked



*  * Convert Hexa String to Binary format
      CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
        EXPORTING
          buffer     = i_xstring
        TABLES
          binary_tab = i_objbin[].
* Sy-subrc check not required.

*    DATA: IN_MAILID TYPE AD_SMTPADR.

* Begin of sending email to multiple users
* If business want email to be sent to all users at one time, it can be done

* For now we do not want to send 1 email to multiple users
* Mail has to be sent one email at a time

*  IF P2 EQ 'X'.
*
*      CLEAR IN_MAILID.
*    IN_MAILID = 'JYOTSNA@BLUECROSSLABS.COM'.
      in_mailid = wa_rmemail-usrid_long.
*      BREAK-POINT .
      PERFORM send_mail USING in_mailid .
*      BREAK-POINT.
      WRITE : / wa_zmemail-reg.
    ENDLOOP.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  RFORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM rform1 .
*  BREAK-POINT.
  SORT it_tac7 BY reg zm rm.
  CLEAR : rmtot,rmtar.
  CLEAR : stpcnt1,stpcnt2.
  LOOP AT it_tac7 INTO wa_tac7 WHERE reg EQ wa_check1-reg AND rm = wa_check1-rm.
    wa_sf1-zm = wa_tac7-zm.
    wa_sf1-rm = wa_tac7-rm.
    wa_sf1-bzirk = wa_tac7-bzirk.
    wa_sf1-ename = wa_tac7-ename.
    IF wa_sf1-ename EQ space.
      wa_sf1-ename = 'VACANT'.
    ENDIF.
    wa_sf1-zz_hqdesc = wa_tac7-zz_hqdesc.

    CONCATENATE wa_tac7-begda+4(2) '/ ' wa_tac7-begda+0(4) INTO wa_sf1-joindt.
    wa_sf1-short = wa_tac7-short.
    READ TABLE it_tad2 INTO wa_tad2 WITH KEY reg = wa_tac7-reg rm = wa_tac7-rm bzirk = wa_tac7-bzirk.
    IF sy-subrc EQ 0.
      wa_sf1-div = wa_tad2-div.
      wa_sf1-net = wa_tad2-net.
      wa_sf1-targt1 = wa_tad2-targt1.
      CLEAR : stp.
      stp = ( wa_tad2-net / wa_tad2-targt ) * 100.
      wa_sf1-stp = stp.
      IF stp GE 100.
        stpcnt1 = stpcnt1 + 1.
      ENDIF.
      CONDENSE: wa_sf1-net,wa_sf1-targt1,wa_sf1-stp.
      wa_rm1-rm = wa_tad2-rm.
      wa_rm1-rmtot = wa_tad2-net.
      wa_rm1-rmtar = wa_tad2-targt1.
      COLLECT wa_rm1 INTO it_rm1.
      CLEAR wa_rm1.

      wa_zm1-zm = wa_tad2-zm.
      wa_zm1-zmtot = wa_tad2-net.
      wa_zm1-zmtar = wa_tad2-targt1.
      COLLECT wa_zm1 INTO it_zm1.
      CLEAR wa_zm1.

      wa_reg1-reg = wa_tad2-reg.
      wa_reg1-regtot = wa_tad2-net.
      wa_reg1-regtar = wa_tad2-targt1.
      COLLECT wa_reg1 INTO it_reg1.
      CLEAR wa_reg1.

    ENDIF.
    COLLECT wa_sf1 INTO it_sf1.
    CLEAR wa_sf1.
******************************************rm*****************
    wa_sf2-rm = wa_tac7-rm.
    wa_sf2-zm = wa_tac7-zm.
    wa_sf2-ename = wa_tac7-rename.
    IF wa_sf2-ename EQ space.
      wa_sf2-ename = 'VACANT'.
    ENDIF.
    wa_sf2-zz_hqdesc = wa_tac7-rzz_hqdesc.
    CONCATENATE wa_tac7-rbegda+4(2) '/ ' wa_tac7-rbegda+0(4) INTO wa_sf2-joindt.
    wa_sf2-short = wa_tac7-rshort.
    COLLECT wa_sf2 INTO it_sf2.
    CLEAR wa_sf2.
**********************Zm rnds*******************************

    wa_sf3-zm = wa_tac7-zm.
    wa_sf3-ename = wa_tac7-dzename.
    IF wa_sf3-ename EQ space.
      wa_sf3-ename = 'VACANT'.
    ENDIF.
    wa_sf3-zz_hqdesc = wa_tac7-dzzz_hqdesc.
    CONCATENATE wa_tac7-dzbegda+4(2) '/ ' wa_tac7-dzbegda+0(4) INTO wa_sf3-joindt.
    wa_sf3-short = wa_tac7-dzshort.
    COLLECT wa_sf3 INTO it_sf3.
    CLEAR wa_sf3.
  ENDLOOP.

  SORT it_sf1 BY zm rm bzirk.

  SORT it_sf2 BY zm rm.
  DELETE ADJACENT DUPLICATES FROM it_sf2 COMPARING zm rm.
  LOOP AT it_sf2 INTO wa_sf2.
    READ TABLE it_rm1 INTO wa_rm1 WITH KEY rm = wa_sf2-rm.
    IF sy-subrc EQ 0.
      wa_sf2-net = wa_rm1-rmtot.
      wa_sf2-targt1 = wa_rm1-rmtar.
      CLEAR: rstp.
      rstp = ( wa_rm1-rmtot / wa_rm1-rmtar ) * 100.
      wa_sf2-stp = rstp.
      CONDENSE : wa_sf2-net,wa_sf2-targt1,wa_sf2-stp.
      MODIFY it_sf2 FROM wa_sf2 TRANSPORTING net targt1 stp WHERE rm = wa_sf2-rm.
      CLEAR wa_sf2.
    ENDIF.
  ENDLOOP.

  SORT it_sf3 BY zm.
  DELETE ADJACENT DUPLICATES FROM it_sf3 COMPARING zm.

  LOOP AT it_sf3 INTO wa_sf3.
    READ TABLE it_zm1 INTO wa_zm1 WITH KEY zm = wa_sf3-zm.
    IF sy-subrc EQ 0.
      wa_sf3-net = wa_zm1-zmtot.
      wa_sf3-targt1 = wa_zm1-zmtar.
      CLEAR: rstp.
      rstp = ( wa_zm1-zmtot / wa_zm1-zmtar ) * 100.
      wa_sf3-stp = rstp.
      CONDENSE : wa_sf3-net,wa_sf3-targt1,wa_sf3-stp.
      MODIFY it_sf3 FROM wa_sf3 TRANSPORTING net targt1 stp WHERE zm = wa_sf3-zm.
      CLEAR wa_sf3.
    ENDIF.
  ENDLOOP.

*  LOOP AT IT_SF3 INTO WA_SF3.
*    WRITE : / 'ZM',WA_SF3-ZM.
*    LOOP AT IT_SF2 INTO WA_SF2 WHERE ZM EQ WA_SF3-ZM.
*      WRITE : / 'ZM, RM',WA_SF2-ZM,WA_SF2-RM.
*      LOOP AT IT_SF1 INTO WA_SF1 WHERE RM EQ WA_SF2-RM.
*        WRITE : / 'ZM, RM, TERR', WA_SF1-ZM, WA_SF1-RM, WA_SF1-BZIRK.
*      ENDLOOP.
*    ENDLOOP.
*  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  RFORM2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM rform2 .
  READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_check1-reg rm = wa_check1-rm.
  IF sy-subrc EQ 0.
    regename = wa_tac7-zename.
    IF regename EQ space.
      regename = 'VACANT'.
    ENDIF.
    reghqdesc = wa_tac7-zzz_hqdesc.
    CONCATENATE wa_tac7-zbegda+4(2) '/ ' wa_tac7-zbegda+0(4) INTO regjoindt.
    regshort = wa_tac7-zshort.
  ENDIF.

  READ TABLE it_reg1 INTO wa_reg1 WITH KEY reg = wa_check-reg.
  IF sy-subrc EQ 0.
    regnet = wa_reg1-regtot.
    regtargt1 = wa_reg1-regtar.
    CLEAR: regstp.
    regstp = ( wa_reg1-regtot / wa_reg1-regtar ) * 100.
    regstp1 = regstp.
    CONDENSE : regnet,regtargt1,regstp1.
  ENDIF.
  CLEAR : c_bcl,c_tot,p_bcl, c_bc,p_bc,c_xl,p_xl,c_ls,p_ls.
  READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_check-reg div = 'BCL'.
  IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
    c_bcl = wa_tad4-count.
    c_tot = c_tot + wa_tad4-count.
    READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_check-reg div = 'BCL'.
    IF sy-subrc EQ 0.
      p_bcl = wa_tad21-net / c_bcl.
*            P_TOT = P_TOT + P_BCL.
    ENDIF.
    bcl1 = 'Y'.
  ENDIF.
  READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_check-reg div = 'BC'.
  IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
    c_bc = wa_tad4-count.
    c_tot = c_tot + wa_tad4-count.
    READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_check-reg div = 'BC'.
    IF sy-subrc EQ 0.
      p_bc = wa_tad21-net / c_bc.
*            P_TOT = P_TOT + P_BCL.
    ENDIF.
    bc1 = 'Y'.
  ENDIF.
  READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_check-reg div = 'XL'.
  IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
    c_xl = wa_tad4-count.
    c_tot = c_tot + wa_tad4-count.
    READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_check-reg div = 'XL'.
    IF sy-subrc EQ 0.
      p_xl = wa_tad21-net / c_xl.
*            P_TOT = P_TOT + P_BCL.
    ENDIF.
    xl1 = 'Y'.
  ENDIF.
  READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_check-reg div = 'LS'.
  IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
    c_ls = wa_tad4-count.
    c_tot = c_tot + wa_tad4-count.
    READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_check-reg div = 'LS'.
    IF sy-subrc EQ 0.
      p_ls = wa_tad21-net / c_ls.
*            P_TOT = P_TOT + P_BCL.
    ENDIF.
    ls1 = 'Y'.
  ENDIF.
  CLEAR : p_tot1,p_tot2.
  READ TABLE it_reg1 INTO wa_reg1 WITH KEY reg = wa_check-reg.
  IF sy-subrc EQ 0.
    p_tot1 = wa_reg1-regtot / c_tot.
  ENDIF.

  c_bcl1              = c_bcl.
  c_bc1               = c_bc.
  c_xl1               = c_xl.
  c_ls1               = c_ls.
  p_bcl1              = p_bcl.
  p_bc1               = p_bc.
  p_xl1               = p_xl.
  p_ls1               = p_ls.
  c_tot1 = c_tot.
  stpcnt2 = stpcnt1.
  p_tot2 = p_tot1.
  CONDENSE : c_bcl1,c_bc1,c_xl1,c_ls1,p_bcl1,p_bc1,p_xl1,p_ls1,stpcnt2,c_tot1,p_tot2.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SFFORM4
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sfform4 .
  LOOP AT it_dzmemail INTO wa_dzmemail .
    LOOP AT it_check2 INTO wa_check2 WHERE reg EQ wa_dzmemail-reg AND zm EQ wa_dzmemail-zm.
      CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
        EXPORTING
*         FORMNAME           = 'ZSR9_9'
          formname           = 'ZSR9_A1'
*         VARIANT            = ' '
*         DIRECT_CALL        = ' '
        IMPORTING
          fm_name            = v_fm
        EXCEPTIONS
          no_form            = 1
          no_function_module = 2
          OTHERS             = 3.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

*  CONTROL-NO_OPEN   = 'X'.
*  CONTROL-NO_CLOSE  = 'X'.
*  CALL FUNCTION 'SSF_OPEN'
*    EXPORTING
*      CONTROL_PARAMETERS = CONTROL.

*   * Set the control parameter
      w_ctrlop-getotf = abap_true.
      w_ctrlop-no_dialog = abap_true.
      w_compop-tdnoprev = abap_true.
      w_ctrlop-preview = space.
      w_compop-tddest = 'LOCL'.


*  LOOP AT IT_CHECK INTO WA_CHECK.
*    BREAK-POINT .
      CLEAR : zonename.
      zonename = wa_check1-zonename.
*    WRITE : / 'ZONE',ZONENAME.
      CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.
*      PERFORM FORM1.
*      PERFORM RFORM1.
      PERFORM dzform1.
*      PERFORM FORM2.
*      PERFORM RFORM2.
      PERFORM dzform2.


      CALL FUNCTION v_fm
        EXPORTING
          control_parameters = w_ctrlop
          output_options     = w_compop
          user_settings      = abap_true
          format             = format
          zonename           = zonename
          regename           = regename
          reghqdesc          = reghqdesc
          regjoindt          = regjoindt
          regshort           = regshort
          regnet             = regnet
          regtargt1          = regtargt1
          regstp1            = regstp1
          s_budat1           = s_budat1
          s_budat2           = s_budat2
          c_bcl1             = c_bcl1
          c_bc1              = c_bc1
          c_xl1              = c_xl1
          c_ls1              = c_ls1
          p_bcl1             = p_bcl1
          p_bc1              = p_bc1
          p_xl1              = p_xl1
          p_ls1              = p_ls1
          stpcnt2            = stpcnt2
          p_tot1             = p_tot2
          c_tot1             = c_tot1
          bcl1               = bcl1
          bc1                = bc1
          xl1                = xl1
          ls1                = ls1
        IMPORTING
          job_output_info    = w_return " This will have all output
        TABLES
          it_sf1             = it_sf1
          it_sf2             = it_sf2
          it_sf3             = it_sf3
*         itab_division      = itab_division
*         itab_storage       = itab_storage
*         itab_pa0002        = itab_pa0002
        EXCEPTIONS
          formatting_error   = 1
          internal_error     = 2
          send_error         = 3
          user_canceled      = 4
          OTHERS             = 5.
      CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.

      CLEAR : zonename,  regename, reghqdesc,regjoindt, regshort, regnet ,regtargt1,regstp1,c_bcl1, c_bc1,c_xl1,
        c_ls1 , p_bcl1 ,p_bc1,p_xl1,p_ls1,stpcnt2,p_tot1, c_tot1 .
*  ENDLOOP.
      CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.


      i_otf[] = w_return-otfdata[].

* Import Binary file and filesize
      CALL FUNCTION 'CONVERT_OTF'
        EXPORTING
          format                = 'PDF'
          max_linewidth         = 132
        IMPORTING
          bin_filesize          = v_len_in
          bin_file              = i_xstring   " This is NOT Binary. This is Hexa
        TABLES
          otf                   = i_otf
          lines                 = i_tline
        EXCEPTIONS
          err_max_linewidth     = 1
          err_format            = 2
          err_conv_not_possible = 3
          OTHERS                = 4.
* Sy-subrc check not checked



*  * Convert Hexa String to Binary format
      CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
        EXPORTING
          buffer     = i_xstring
        TABLES
          binary_tab = i_objbin[].
* Sy-subrc check not required.

*    DATA: IN_MAILID TYPE AD_SMTPADR.

* Begin of sending email to multiple users
* If business want email to be sent to all users at one time, it can be done

* For now we do not want to send 1 email to multiple users
* Mail has to be sent one email at a time

*  IF P2 EQ 'X'.
*
*      CLEAR IN_MAILID.
*    IN_MAILID = 'JYOTSNA@BLUECROSSLABS.COM'.
      in_mailid = wa_dzmemail-usrid_long.
*      BREAK-POINT .
      PERFORM send_mail USING in_mailid .
*      BREAK-POINT.
      WRITE : / wa_dzmemail-usrid_long.
    ENDLOOP.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DZFORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM dzform1 .
* *  BREAK-POINT.
  SORT it_tac7 BY reg zm rm .
  CLEAR : rmtot,rmtar.
  CLEAR : stpcnt1,stpcnt2.
  LOOP AT it_tad2 INTO wa_tad2 WHERE reg EQ wa_check-reg AND zm EQ wa_check-zm.
    wa_sf1-zm = wa_tad2-zm.
    wa_sf1-rm = wa_tad2-rm.
    wa_sf1-bzirk = wa_tad2-bzirk.
    READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_tad2-reg zm = wa_tad2-zm rm = wa_tad2-rm bzirk = wa_tad2-bzirk.
    IF sy-subrc EQ 0.
      wa_sf1-ename = wa_tac7-ename.
      IF wa_sf1-ename EQ space.
        wa_sf1-ename = 'VACANT'.
      ENDIF.
      wa_sf1-zz_hqdesc = wa_tac7-zz_hqdesc.
      CONCATENATE wa_tac7-begda+4(2) '/ ' wa_tac7-begda+0(4) INTO wa_sf1-joindt.
      wa_sf1-short = wa_tac7-short.
    ENDIF.

*    READ TABLE IT_TAD2 INTO WA_TAD2 WITH KEY REG = WA_TAD2-REG RM = WA_TAD2-RM BZIRK = WA_TAD2-BZIRK.
*    IF SY-SUBRC EQ 0.
    wa_sf1-div = wa_tad2-div.
    wa_sf1-net = wa_tad2-net.
    wa_sf1-targt1 = wa_tad2-targt1.
    CLEAR : stp.
    stp = ( wa_tad2-net / wa_tad2-targt ) * 100.
    wa_sf1-stp = stp.
    IF stp GE 100.
      stpcnt1 = stpcnt1 + 1.
    ENDIF.
    CONDENSE: wa_sf1-net,wa_sf1-targt1,wa_sf1-stp.
    wa_rm1-rm = wa_tad2-rm.
    wa_rm1-rmtot = wa_tad2-net.
    wa_rm1-rmtar = wa_tad2-targt1.
    COLLECT wa_rm1 INTO it_rm1.
    CLEAR wa_rm1.

    wa_zm1-zm = wa_tad2-zm.
    wa_zm1-zmtot = wa_tad2-net.
    wa_zm1-zmtar = wa_tad2-targt1.
    COLLECT wa_zm1 INTO it_zm1.
    CLEAR wa_zm1.

    wa_reg1-reg = wa_tad2-reg.
    wa_reg1-regtot = wa_tad2-net.
    wa_reg1-regtar = wa_tad2-targt1.
    COLLECT wa_reg1 INTO it_reg1.
    CLEAR wa_reg1.

*    ENDIF.
    COLLECT wa_sf1 INTO it_sf1.
    CLEAR wa_sf1.
******************************************rm*****************
    wa_sf2-rm = wa_tad2-rm.
    wa_sf2-zm = wa_tad2-zm.
    READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_tad2-reg zm = wa_tad2-zm rm = wa_tad2-rm bzirk = wa_tad2-bzirk.
    IF sy-subrc EQ 0.
      wa_sf2-ename = wa_tac7-rename.
      IF wa_sf2-ename EQ space.
        wa_sf2-ename = 'VACANT'.
      ENDIF.
      wa_sf2-zz_hqdesc = wa_tac7-rzz_hqdesc.
      CONCATENATE wa_tac7-rbegda+4(2) '/ ' wa_tac7-rbegda+0(4) INTO wa_sf2-joindt.
      wa_sf2-short = wa_tac7-rshort.
    ENDIF.
    COLLECT wa_sf2 INTO it_sf2.
    CLEAR wa_sf2.
**********************Zm rnds*******************************

    wa_sf3-zm = wa_tad2-zm.
    READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_tad2-reg zm = wa_tad2-zm rm = wa_tad2-rm bzirk = wa_tad2-bzirk.
    IF sy-subrc EQ 0.
      wa_sf3-ename = wa_tac7-dzename.
      IF wa_sf3-ename EQ space.
        wa_sf3-ename = 'VACANT'.
      ENDIF.
      wa_sf3-zz_hqdesc = wa_tac7-dzzz_hqdesc.
      CONCATENATE wa_tac7-dzbegda+4(2) '/ ' wa_tac7-dzbegda+0(4) INTO wa_sf3-joindt.
      wa_sf3-short = wa_tac7-dzshort.
    ENDIF.
    COLLECT wa_sf3 INTO it_sf3.
    CLEAR wa_sf3.
  ENDLOOP.

  SORT it_sf1 BY zm rm bzirk.

  SORT it_sf2 BY zm rm.
  DELETE ADJACENT DUPLICATES FROM it_sf2 COMPARING zm rm.
  LOOP AT it_sf2 INTO wa_sf2.
    READ TABLE it_rm1 INTO wa_rm1 WITH KEY rm = wa_sf2-rm.
    IF sy-subrc EQ 0.
      wa_sf2-net = wa_rm1-rmtot.
      wa_sf2-targt1 = wa_rm1-rmtar.
      CLEAR: rstp.
      rstp = ( wa_rm1-rmtot / wa_rm1-rmtar ) * 100.
      wa_sf2-stp = rstp.
      CONDENSE : wa_sf2-net,wa_sf2-targt1,wa_sf2-stp.
      MODIFY it_sf2 FROM wa_sf2 TRANSPORTING net targt1 stp WHERE rm = wa_sf2-rm.
      CLEAR wa_sf2.
    ENDIF.
  ENDLOOP.

  SORT it_sf3 BY zm.
  DELETE ADJACENT DUPLICATES FROM it_sf3 COMPARING zm.

  LOOP AT it_sf3 INTO wa_sf3.
    READ TABLE it_zm1 INTO wa_zm1 WITH KEY zm = wa_sf3-zm.
    IF sy-subrc EQ 0.
      wa_sf3-net = wa_zm1-zmtot.
      wa_sf3-targt1 = wa_zm1-zmtar.
      CLEAR: rstp.
      rstp = ( wa_zm1-zmtot / wa_zm1-zmtar ) * 100.
      wa_sf3-stp = rstp.
      CONDENSE : wa_sf3-net,wa_sf3-targt1,wa_sf3-stp.
      MODIFY it_sf3 FROM wa_sf3 TRANSPORTING net targt1 stp WHERE zm = wa_sf3-zm.
      CLEAR wa_sf3.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DZFORM2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM dzform2 .

  READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_check-zm.
  IF sy-subrc EQ 0.
    regename = wa_tac7-zename.
    IF regename EQ space.
      regename = 'VACANT'.
    ENDIF.
    reghqdesc = wa_tac7-zzz_hqdesc.
    CONCATENATE wa_tac7-zbegda+4(2) '/ ' wa_tac7-zbegda+0(4) INTO regjoindt.
    regshort = wa_tac7-zshort.
  ENDIF.

*  READ TABLE IT_REG1 INTO WA_REG1 WITH KEY REG = WA_CHECK-REG.
*  IF SY-SUBRC EQ 0.
*    REGNET = WA_REG1-REGTOT.
*    REGTARGT1 = WA_REG1-REGTAR.
*    CLEAR: REGSTP.
*    REGSTP = ( WA_REG1-REGTOT / WA_REG1-REGTAR ) * 100.
*    REGSTP1 = REGSTP.
*    CONDENSE : REGNET,REGTARGT1,REGSTP1.
*  ENDIF.
  CLEAR : c_bcl,c_tot,p_bcl, c_bc,p_bc,c_xl,p_xl,c_ls,p_ls.
*  READ TABLE IT_TAD4 INTO WA_TAD4 WITH  KEY REG = WA_CHECK-ZM DIV = 'BCL'.
*  IF SY-SUBRC EQ 0 AND WA_TAD4-COUNT NE 0.
*    C_BCL = WA_TAD4-COUNT.
*    C_TOT = C_TOT + WA_TAD4-COUNT.
*    READ TABLE IT_TAD21 INTO WA_TAD21 WITH KEY REG = WA_CHECK-ZM DIV = 'BCL'.
*    IF SY-SUBRC EQ 0.
*      P_BCL = WA_TAD21-NET / C_BCL.
**            P_TOT = P_TOT + P_BCL.
*    ENDIF.
*    BCL1 = 'Y'.
*  ENDIF.
*  READ TABLE IT_TAD4 INTO WA_TAD4 WITH  KEY REG = WA_CHECK-ZM DIV = 'BC'.
*  IF SY-SUBRC EQ 0 AND WA_TAD4-COUNT NE 0.
*    C_BC = WA_TAD4-COUNT.
*    C_TOT = C_TOT + WA_TAD4-COUNT.
*    READ TABLE IT_TAD21 INTO WA_TAD21 WITH KEY REG = WA_CHECK-ZM DIV = 'BC'.
*    IF SY-SUBRC EQ 0.
*      P_BC = WA_TAD21-NET / C_BC.
**            P_TOT = P_TOT + P_BCL.
*    ENDIF.
*    BC1 = 'Y'.
*  ENDIF.
*  READ TABLE IT_TAD4 INTO WA_TAD4 WITH  KEY REG = WA_CHECK-ZM DIV = 'XL'.
*  IF SY-SUBRC EQ 0 AND WA_TAD4-COUNT NE 0.
*    C_XL = WA_TAD4-COUNT.
*    C_TOT = C_TOT + WA_TAD4-COUNT.
*    READ TABLE IT_TAD21 INTO WA_TAD21 WITH KEY REG = WA_CHECK-ZM DIV = 'XL'.
*    IF SY-SUBRC EQ 0.
*      P_XL = WA_TAD21-NET / C_XL.
**            P_TOT = P_TOT + P_BCL.
*    ENDIF.
*    XL1 = 'Y'.
*  ENDIF.
*  READ TABLE IT_TAD4 INTO WA_TAD4 WITH  KEY REG = WA_CHECK-ZM DIV = 'LS'.
*  IF SY-SUBRC EQ 0 AND WA_TAD4-COUNT NE 0.
*    C_LS = WA_TAD4-COUNT.
*    C_TOT = C_TOT + WA_TAD4-COUNT.
*    READ TABLE IT_TAD21 INTO WA_TAD21 WITH KEY REG = WA_CHECK-ZM DIV = 'LS'.
*    IF SY-SUBRC EQ 0.
*      P_LS = WA_TAD21-NET / C_LS.
**            P_TOT = P_TOT + P_BCL.
*    ENDIF.
*    LS1 = 'Y'.
*  ENDIF.
*  CLEAR : P_TOT1,P_TOT2.
*  READ TABLE IT_REG1 INTO WA_REG1 WITH KEY REG = WA_CHECK-ZM.
*  IF SY-SUBRC EQ 0.
*    P_TOT1 = WA_REG1-REGTOT / C_TOT.
*  ENDIF.

  c_bcl1              = c_bcl.
  c_bc1               = c_bc.
  c_xl1               = c_xl.
  c_ls1               = c_ls.
  p_bcl1              = p_bcl.
  p_bc1               = p_bc.
  p_xl1               = p_xl.
  p_ls1               = p_ls.
  c_tot1 = c_tot.
  stpcnt2 = stpcnt1.
  p_tot2 = p_tot1.
  CONDENSE : c_bcl1,c_bc1,c_xl1,c_ls1,p_bcl1,p_bc1,p_xl1,p_ls1,stpcnt2,c_tot1,p_tot2.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SFFORM5
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sfform5 .
  LOOP AT it_dzmemail INTO wa_dzmemail .
    LOOP AT it_check2 INTO wa_check2 WHERE reg EQ wa_dzmemail-reg AND zm = wa_dzmemail-zm.
      CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
        EXPORTING
*         FORMNAME           = 'ZSR9_9'
          formname           = 'ZSR9_11'
*         VARIANT            = ' '
*         DIRECT_CALL        = ' '
        IMPORTING
          fm_name            = v_fm
        EXCEPTIONS
          no_form            = 1
          no_function_module = 2
          OTHERS             = 3.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

*  CONTROL-NO_OPEN   = 'X'.
*  CONTROL-NO_CLOSE  = 'X'.
*  CALL FUNCTION 'SSF_OPEN'
*    EXPORTING
*      CONTROL_PARAMETERS = CONTROL.

*   * Set the control parameter
      w_ctrlop-getotf = abap_true.
      w_ctrlop-no_dialog = abap_true.
      w_compop-tdnoprev = abap_true.
      w_ctrlop-preview = space.
      w_compop-tddest = 'LOCL'.


*  LOOP AT IT_CHECK INTO WA_CHECK.
*    BREAK-POINT .
      CLEAR : zonename.
      zonename = wa_check-zonename.
*    WRITE : / 'ZONE',ZONENAME.
      CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.
*      PERFORM FORM1.
      PERFORM dzform1.
*      PERFORM FORM2.
      PERFORM dzform2.


      CALL FUNCTION v_fm
        EXPORTING
          control_parameters = w_ctrlop
          output_options     = w_compop
          user_settings      = abap_true
          format             = format
          zonename           = zonename
          regename           = regename
          reghqdesc          = reghqdesc
          regjoindt          = regjoindt
          regshort           = regshort
          regnet             = regnet
          regtargt1          = regtargt1
          regstp1            = regstp1
          s_budat1           = s_budat1
          s_budat2           = s_budat2
          c_bcl1             = c_bcl1
          c_bc1              = c_bc1
          c_xl1              = c_xl1
          c_ls1              = c_ls1
          p_bcl1             = p_bcl1
          p_bc1              = p_bc1
          p_xl1              = p_xl1
          p_ls1              = p_ls1
          stpcnt2            = stpcnt2
          p_tot1             = p_tot2
          c_tot1             = c_tot1
          bcl1               = bcl1
          bc1                = bc1
          xl1                = xl1
          ls1                = ls1
        IMPORTING
          job_output_info    = w_return " This will have all output
        TABLES
          it_sf1             = it_sf1
          it_sf2             = it_sf2
          it_sf3             = it_sf3
*         itab_division      = itab_division
*         itab_storage       = itab_storage
*         itab_pa0002        = itab_pa0002
        EXCEPTIONS
          formatting_error   = 1
          internal_error     = 2
          send_error         = 3
          user_canceled      = 4
          OTHERS             = 5.
      CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.

      CLEAR : zonename,  regename, reghqdesc,regjoindt, regshort, regnet ,regtargt1,regstp1,c_bcl1, c_bc1,c_xl1,
        c_ls1 , p_bcl1 ,p_bc1,p_xl1,p_ls1,stpcnt2,p_tot1, c_tot1 .
*  ENDLOOP.
      CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.


      i_otf[] = w_return-otfdata[].

* Import Binary file and filesize
      CALL FUNCTION 'CONVERT_OTF'
        EXPORTING
          format                = 'PDF'
          max_linewidth         = 132
        IMPORTING
          bin_filesize          = v_len_in
          bin_file              = i_xstring   " This is NOT Binary. This is Hexa
        TABLES
          otf                   = i_otf
          lines                 = i_tline
        EXCEPTIONS
          err_max_linewidth     = 1
          err_format            = 2
          err_conv_not_possible = 3
          OTHERS                = 4.
* Sy-subrc check not checked



*  * Convert Hexa String to Binary format
      CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
        EXPORTING
          buffer     = i_xstring
        TABLES
          binary_tab = i_objbin[].
* Sy-subrc check not required.

*    DATA: IN_MAILID TYPE AD_SMTPADR.

* Begin of sending email to multiple users
* If business want email to be sent to all users at one time, it can be done

* For now we do not want to send 1 email to multiple users
* Mail has to be sent one email at a time

*  IF P2 EQ 'X'.
*
*      CLEAR IN_MAILID.
*    IN_MAILID = 'JYOTSNA@BLUECROSSLABS.COM'.
      in_mailid = wa_dzmemail-usrid_long.
*      BREAK-POINT .
      PERFORM send_mail USING in_mailid .
*      BREAK-POINT.
      WRITE : / wa_zmemail-reg.
    ENDLOOP.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DZSFFORM2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM dzsfform2 .
  LOOP AT it_dzmemail INTO wa_dzmemail .
    LOOP AT it_check INTO wa_check WHERE reg EQ wa_dzmemail-reg AND zm = wa_dzmemail-zm.
      CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
        EXPORTING
          formname           = 'ZSR9_11'
*         VARIANT            = ' '
*         DIRECT_CALL        = ' '
        IMPORTING
          fm_name            = v_fm
        EXCEPTIONS
          no_form            = 1
          no_function_module = 2
          OTHERS             = 3.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

*  CONTROL-NO_OPEN   = 'X'.
*  CONTROL-NO_CLOSE  = 'X'.
*  CALL FUNCTION 'SSF_OPEN'
*    EXPORTING
*      CONTROL_PARAMETERS = CONTROL.

*   * Set the control parameter
      w_ctrlop-getotf = abap_true.
      w_ctrlop-no_dialog = abap_true.
      w_compop-tdnoprev = abap_true.
      w_ctrlop-preview = space.
      w_compop-tddest = 'LOCL'.


*  LOOP AT IT_CHECK INTO WA_CHECK.
*    BREAK-POINT .
      CLEAR : zonename.
      zonename = wa_check-zonename.
*    WRITE : / 'ZONE',ZONENAME.
      CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.
*      PERFORM FORM1.
      PERFORM dzform1.
*      PERFORM FORM2.
      PERFORM dzform2.


      CALL FUNCTION v_fm
        EXPORTING
          control_parameters = w_ctrlop
          output_options     = w_compop
          user_settings      = abap_true
          format             = format
          zonename           = zonename
          regename           = regename
          reghqdesc          = reghqdesc
          regjoindt          = regjoindt
          regshort           = regshort
          regnet             = regnet
          regtargt1          = regtargt1
          regstp1            = regstp1
          s_budat1           = s_budat1
          s_budat2           = s_budat2
          c_bcl1             = c_bcl1
          c_bc1              = c_bc1
          c_xl1              = c_xl1
          c_ls1              = c_ls1
          p_bcl1             = p_bcl1
          p_bc1              = p_bc1
          p_xl1              = p_xl1
          p_ls1              = p_ls1
          stpcnt2            = stpcnt2
          p_tot1             = p_tot2
          c_tot1             = c_tot1
          bcl1               = bcl1
          bc1                = bc1
          xl1                = xl1
          ls1                = ls1
        IMPORTING
          job_output_info    = w_return " This will have all output
        TABLES
          it_sf1             = it_sf1
          it_sf2             = it_sf2
          it_sf3             = it_sf3
*         itab_division      = itab_division
*         itab_storage       = itab_storage
*         itab_pa0002        = itab_pa0002
        EXCEPTIONS
          formatting_error   = 1
          internal_error     = 2
          send_error         = 3
          user_canceled      = 4
          OTHERS             = 5.
      CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.

      CLEAR : zonename,  regename, reghqdesc,regjoindt, regshort, regnet ,regtargt1,regstp1,c_bcl1, c_bc1,c_xl1,
        c_ls1 , p_bcl1 ,p_bc1,p_xl1,p_ls1,stpcnt2,p_tot1, c_tot1 ,bcl1,bc1,xl1,ls1.
*  ENDLOOP.
      CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.


      i_otf[] = w_return-otfdata[].

* Import Binary file and filesize
      CALL FUNCTION 'CONVERT_OTF'
        EXPORTING
          format                = 'PDF'
          max_linewidth         = 132
        IMPORTING
          bin_filesize          = v_len_in
          bin_file              = i_xstring   " This is NOT Binary. This is Hexa
        TABLES
          otf                   = i_otf
          lines                 = i_tline
        EXCEPTIONS
          err_max_linewidth     = 1
          err_format            = 2
          err_conv_not_possible = 3
          OTHERS                = 4.
* Sy-subrc check not checked



*  * Convert Hexa String to Binary format
      CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
        EXPORTING
          buffer     = i_xstring
        TABLES
          binary_tab = i_objbin[].
* Sy-subrc check not required.

*    DATA: IN_MAILID TYPE AD_SMTPADR.

* Begin of sending email to multiple users
* If business want email to be sent to all users at one time, it can be done

* For now we do not want to send 1 email to multiple users
* Mail has to be sent one email at a time

*  IF P2 EQ 'X'.
*
*      CLEAR IN_MAILID.
*    IN_MAILID = 'JYOTSNA@BLUECROSSLABS.COM'.
      in_mailid = wa_dzmemail-usrid_long.
*      BREAK-POINT .
      PERFORM send_mail USING in_mailid .
*      BREAK-POINT.
      WRITE : / wa_zmemail-reg.
    ENDLOOP.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  RMSFFORM2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM rmsfform2 .
  LOOP AT it_rmemail INTO wa_rmemail .
    LOOP AT it_check INTO wa_check WHERE reg EQ wa_rmemail-reg AND zm = wa_rmemail-zm AND rm = wa_rmemail-rm.
      CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
        EXPORTING
          formname           = 'ZSR9_11'
*         VARIANT            = ' '
*         DIRECT_CALL        = ' '
        IMPORTING
          fm_name            = v_fm
        EXCEPTIONS
          no_form            = 1
          no_function_module = 2
          OTHERS             = 3.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

*  CONTROL-NO_OPEN   = 'X'.
*  CONTROL-NO_CLOSE  = 'X'.
*  CALL FUNCTION 'SSF_OPEN'
*    EXPORTING
*      CONTROL_PARAMETERS = CONTROL.

*   * Set the control parameter
      w_ctrlop-getotf = abap_true.
      w_ctrlop-no_dialog = abap_true.
      w_compop-tdnoprev = abap_true.
      w_ctrlop-preview = space.
      w_compop-tddest = 'LOCL'.


*  LOOP AT IT_CHECK INTO WA_CHECK.
*    BREAK-POINT .
      CLEAR : zonename.
      zonename = wa_check-zonename.
*    WRITE : / 'ZONE',ZONENAME.
      CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.
*      PERFORM FORM1.
*      PERFORM DZFORM1.
      PERFORM rmform1.
*      PERFORM FORM2.
***      PERFORM DZFORM2.

*      BREAK-POINT .
      CALL FUNCTION v_fm
        EXPORTING
          control_parameters = w_ctrlop
          output_options     = w_compop
          user_settings      = abap_true
          format             = format
          zonename           = zonename
          regename           = regename
          reghqdesc          = reghqdesc
          regjoindt          = regjoindt
          regshort           = regshort
          regnet             = regnet
          regtargt1          = regtargt1
          regstp1            = regstp1
          s_budat1           = s_budat1
          s_budat2           = s_budat2
          c_bcl1             = c_bcl1
          c_bc1              = c_bc1
          c_xl1              = c_xl1
          c_ls1              = c_ls1
          p_bcl1             = p_bcl1
          p_bc1              = p_bc1
          p_xl1              = p_xl1
          p_ls1              = p_ls1
          stpcnt2            = stpcnt2
          p_tot1             = p_tot2
          c_tot1             = c_tot1
          bcl1               = bcl1
          bc1                = bc1
          xl1                = xl1
          ls1                = ls1
        IMPORTING
          job_output_info    = w_return " This will have all output
        TABLES
          it_sf1             = it_sf1
          it_sf2             = it_sf2
          it_sf3             = it_sf3
*         itab_division      = itab_division
*         itab_storage       = itab_storage
*         itab_pa0002        = itab_pa0002
        EXCEPTIONS
          formatting_error   = 1
          internal_error     = 2
          send_error         = 3
          user_canceled      = 4
          OTHERS             = 5.
*      CLEAR : IT_SF1,WA_SF1,IT_SF2,WA_SF2,IT_SF3,WA_SF3.
*
*      CLEAR : ZONENAME,  REGENAME, REGHQDESC,REGJOINDT, REGSHORT, REGNET ,REGTARGT1,REGSTP1,C_BCL1, C_BC1,C_XL1,
*        C_LS1 , P_BCL1 ,P_BC1,P_XL1,P_LS1,STPCNT2,P_TOT1, C_TOT1 .
**  ENDLOOP.
*      CLEAR : IT_SF1,WA_SF1,IT_SF2,WA_SF2,IT_SF3,WA_SF3.


      i_otf[] = w_return-otfdata[].

* Import Binary file and filesize
      CALL FUNCTION 'CONVERT_OTF'
        EXPORTING
          format                = 'PDF'
          max_linewidth         = 132
        IMPORTING
          bin_filesize          = v_len_in
          bin_file              = i_xstring   " This is NOT Binary. This is Hexa
        TABLES
          otf                   = i_otf
          lines                 = i_tline
        EXCEPTIONS
          err_max_linewidth     = 1
          err_format            = 2
          err_conv_not_possible = 3
          OTHERS                = 4.
* Sy-subrc check not checked



*  * Convert Hexa String to Binary format
      CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
        EXPORTING
          buffer     = i_xstring
        TABLES
          binary_tab = i_objbin[].
* Sy-subrc check not required.

*    DATA: IN_MAILID TYPE AD_SMTPADR.

* Begin of sending email to multiple users
* If business want email to be sent to all users at one time, it can be done

* For now we do not want to send 1 email to multiple users
* Mail has to be sent one email at a time

*  IF P2 EQ 'X'.
*
*      CLEAR IN_MAILID.
*    IN_MAILID = 'JYOTSNA@BLUECROSSLABS.COM'.
      in_mailid = wa_rmemail-usrid_long.
*      BREAK-POINT .
      PERFORM send_mail USING in_mailid .
*      BREAK-POINT.
      WRITE : / wa_zmemail-reg.

      CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.

      CLEAR : zonename,  regename, reghqdesc,regjoindt, regshort, regnet ,regtargt1,regstp1,c_bcl1, c_bc1,c_xl1,
        c_ls1 , p_bcl1 ,p_bc1,p_xl1,p_ls1,stpcnt2,p_tot1, c_tot1 ,bcl1,bc1,xl1,ls1.
*  ENDLOOP.
      CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.
    ENDLOOP.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  RMFORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM rmform1 .
* *  BREAK-POINT.
  SORT it_tac7 BY reg zm rm .
  CLEAR : rmtot,rmtar.
  CLEAR : stpcnt1,stpcnt2.
  LOOP AT it_tad2 INTO wa_tad2 WHERE reg EQ wa_check-reg AND zm EQ wa_check-zm AND rm = wa_check-rm.
    wa_sf1-zm = wa_tad2-zm.
    wa_sf1-rm = wa_tad2-rm.
    wa_sf1-bzirk = wa_tad2-bzirk.
    READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_tad2-reg zm = wa_tad2-zm rm = wa_tad2-rm bzirk = wa_tad2-bzirk.
    IF sy-subrc EQ 0.
      wa_sf1-ename = wa_tac7-ename.
      IF wa_sf1-ename EQ space.
        wa_sf1-ename = 'VACANT'.
      ENDIF.
      wa_sf1-zz_hqdesc = wa_tac7-zz_hqdesc.
      CONCATENATE wa_tac7-begda+4(2) '/ ' wa_tac7-begda+0(4) INTO wa_sf1-joindt.
      wa_sf1-short = wa_tac7-short.
    ENDIF.

*    READ TABLE IT_TAD2 INTO WA_TAD2 WITH KEY REG = WA_TAD2-REG RM = WA_TAD2-RM BZIRK = WA_TAD2-BZIRK.
*    IF SY-SUBRC EQ 0.
    wa_sf1-div = wa_tad2-div.
    wa_sf1-net = wa_tad2-net.
    wa_sf1-targt1 = wa_tad2-targt1.
    CLEAR : stp.
    IF wa_tad2-targt GT 0.
      stp = ( wa_tad2-net / wa_tad2-targt ) * 100.
    ENDIF.
    wa_sf1-stp = stp.
    IF stp GE 100.
      stpcnt1 = stpcnt1 + 1.
    ENDIF.
    CONDENSE: wa_sf1-net,wa_sf1-targt1,wa_sf1-stp.
    wa_rm1-rm = wa_tad2-rm.
    wa_rm1-rmtot = wa_tad2-net.
    wa_rm1-rmtar = wa_tad2-targt1.
    COLLECT wa_rm1 INTO it_rm1.
    CLEAR wa_rm1.

    wa_zm1-zm = wa_tad2-zm.
    wa_zm1-zmtot = wa_tad2-net.
    wa_zm1-zmtar = wa_tad2-targt1.
    COLLECT wa_zm1 INTO it_zm1.
    CLEAR wa_zm1.

    wa_reg1-reg = wa_tad2-reg.
    wa_reg1-regtot = wa_tad2-net.
    wa_reg1-regtar = wa_tad2-targt1.
    COLLECT wa_reg1 INTO it_reg1.
    CLEAR wa_reg1.

*    ENDIF.
    COLLECT wa_sf1 INTO it_sf1.
    CLEAR wa_sf1.
******************************************rm*****************
    wa_sf2-rm = wa_tad2-rm.
    wa_sf2-zm = wa_tad2-zm.
    READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_tad2-reg zm = wa_tad2-zm rm = wa_tad2-rm bzirk = wa_tad2-bzirk.
    IF sy-subrc EQ 0.
      wa_sf2-ename = wa_tac7-rename.
      IF wa_sf2-ename EQ space.
        wa_sf2-ename = 'VACANT'.
      ENDIF.
      wa_sf2-zz_hqdesc = wa_tac7-rzz_hqdesc.
      CONCATENATE wa_tac7-rbegda+4(2) '/ ' wa_tac7-rbegda+0(4) INTO wa_sf2-joindt.
      wa_sf2-short = wa_tac7-rshort.
    ENDIF.
    COLLECT wa_sf2 INTO it_sf2.
    CLEAR wa_sf2.
**********************Zm rnds*******************************

    wa_sf3-zm = wa_tad2-zm.
*    WA_SF3-ENAME = WA_TAD2-DZENAME.
*    IF WA_SF3-ENAME EQ SPACE.
*      WA_SF3-ENAME = 'VACANT'.
*    ENDIF.
*    WA_SF3-ZZ_HQDESC = WA_TAD2-DZZZ_HQDESC.
*    CONCATENATE WA_TAD2-DZBEGDA+4(2) '/ ' WA_TAD2-DZBEGDA+0(4) INTO WA_SF3-JOINDT.
*    WA_SF3-SHORT = WA_TAD2-DZSHORT.
    COLLECT wa_sf3 INTO it_sf3.
    CLEAR wa_sf3.
  ENDLOOP.

  SORT it_sf1 BY zm rm bzirk.

  SORT it_sf2 BY zm rm.
  DELETE ADJACENT DUPLICATES FROM it_sf2 COMPARING zm rm.
  LOOP AT it_sf2 INTO wa_sf2 WHERE rm = wa_check-rm.
    READ TABLE it_rm1 INTO wa_rm1 WITH KEY rm = wa_sf2-rm.
    IF sy-subrc EQ 0.
      wa_sf2-net = wa_rm1-rmtot.
      wa_sf2-targt1 = wa_rm1-rmtar.
      CLEAR: rstp.
      IF wa_rm1-rmtar GT 0.
        rstp = ( wa_rm1-rmtot / wa_rm1-rmtar ) * 100.
      ENDIF.
      wa_sf2-stp = rstp.
      CONDENSE : wa_sf2-net,wa_sf2-targt1,wa_sf2-stp.
      MODIFY it_sf2 FROM wa_sf2 TRANSPORTING net targt1 stp WHERE rm = wa_sf2-rm.
      CLEAR wa_sf2.
    ENDIF.
  ENDLOOP.

  SORT it_sf3 BY zm.
  DELETE ADJACENT DUPLICATES FROM it_sf3 COMPARING zm.

*  LOOP AT IT_SF3 INTO WA_SF3.
*    READ TABLE IT_ZM1 INTO WA_ZM1 WITH KEY ZM = WA_SF3-ZM.
*    IF SY-SUBRC EQ 0.
*      WA_SF3-NET = WA_ZM1-ZMTOT.
*      WA_SF3-TARGT1 = WA_ZM1-ZMTAR.
*      CLEAR: RSTP.
*      RSTP = ( WA_ZM1-ZMTOT / WA_ZM1-ZMTAR ) * 100.
*      WA_SF3-STP = RSTP.
*      CONDENSE : WA_SF3-NET,WA_SF3-TARGT1,WA_SF3-STP.
*      MODIFY IT_SF3 FROM WA_SF3 TRANSPORTING NET TARGT1 STP WHERE ZM = WA_SF3-ZM.
*      CLEAR WA_SF3.
*    ENDIF.
*  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SFFORM1N
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sfform1n .
* LOOP AT IT_CHECK INTO WA_CHECK.
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZSR9_A1'
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
      fm_name            = v_fm
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

*  CONTROL-NO_OPEN   = 'X'.
*  CONTROL-NO_CLOSE  = 'X'.
*  CALL FUNCTION 'SSF_OPEN'
*    EXPORTING
*      CONTROL_PARAMETERS = CONTROL.

*   * Set the control parameter
  w_ctrlop-getotf = abap_true.
  w_ctrlop-no_dialog = abap_true.
  w_compop-tdnoprev = abap_true.
  w_ctrlop-preview = space.
  w_compop-tddest = 'LOCL'.


  LOOP AT it_check INTO wa_check.
*    BREAK-POINT .
    CLEAR : zonename.
    zonename = wa_check-zonename.
*    WRITE : / 'ZONE',ZONENAME.
    CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.
    PERFORM form1.



    READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_check-reg.
    IF sy-subrc EQ 0.
      regename = wa_tac7-zename.
      IF regename EQ space.
        regename = 'VACANT'.
      ENDIF.
      reghqdesc = wa_tac7-zzz_hqdesc.
      CONCATENATE wa_tac7-zbegda+4(2) '/ ' wa_tac7-zbegda+0(4) INTO regjoindt.
      regshort = wa_tac7-zshort.
    ENDIF.

    READ TABLE it_reg1 INTO wa_reg1 WITH KEY reg = wa_check-reg.
    IF sy-subrc EQ 0.
      regnet = wa_reg1-regtot.
      regtargt1 = wa_reg1-regtar.
      CLEAR: regstp.
      regstp = ( wa_reg1-regtot / wa_reg1-regtar ) * 100.
      regstp1 = regstp.
      CONDENSE : regnet,regtargt1,regstp1.
    ENDIF.
    CLEAR : c_bcl,c_tot,p_bcl, c_bc,p_bc,c_xl,p_xl,c_ls,p_ls.
    READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_check-reg div = 'BCL'.
    IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
      c_bcl = wa_tad4-count.
      c_tot = c_tot + wa_tad4-count.
      READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_check-reg div = 'BCL'.
      IF sy-subrc EQ 0.
        p_bcl = wa_tad21-net / c_bcl.
*            P_TOT = P_TOT + P_BCL.
      ENDIF.
      bcl1 = 'Y'.
    ENDIF.
    READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_check-reg div = 'BC'.
    IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
      c_bc = wa_tad4-count.
      c_tot = c_tot + wa_tad4-count.
      READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_check-reg div = 'BC'.
      IF sy-subrc EQ 0.
        p_bc = wa_tad21-net / c_bc.
*            P_TOT = P_TOT + P_BCL.
      ENDIF.
      bc1 = 'Y'.
    ENDIF.
    READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_check-reg div = 'XL'.
    IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
      c_xl = wa_tad4-count.
      c_tot = c_tot + wa_tad4-count.
      READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_check-reg div = 'XL'.
      IF sy-subrc EQ 0.
        p_xl = wa_tad21-net / c_xl.
*            P_TOT = P_TOT + P_BCL.
      ENDIF.
      xl1 = 'Y'.
    ENDIF.
    READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_check-reg div = 'LS'.
    IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
      c_ls = wa_tad4-count.
      c_tot = c_tot + wa_tad4-count.
      READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_check-reg div = 'LS'.
      IF sy-subrc EQ 0.
        p_ls = wa_tad21-net / c_ls.
*            P_TOT = P_TOT + P_BCL.
      ENDIF.
      ls1 = 'Y'.
    ENDIF.
    CLEAR : p_tot1,p_tot2.
    READ TABLE it_reg1 INTO wa_reg1 WITH KEY reg = wa_check-reg.
    IF sy-subrc EQ 0.
      p_tot1 = wa_reg1-regtot / c_tot.
    ENDIF.

    c_bcl1              = c_bcl.
    c_bc1               = c_bc.
    c_xl1               = c_xl.
    c_ls1               = c_ls.
    p_bcl1              = p_bcl.
    p_bc1               = p_bc.
    p_xl1               = p_xl.
    p_ls1               = p_ls.
    c_tot1 = c_tot.
    stpcnt2 = stpcnt1.
    p_tot2 = p_tot1.
    CONDENSE : c_bcl1,c_bc1,c_xl1,c_ls1,p_bcl1,p_bc1,p_xl1,p_ls1,stpcnt2,c_tot1,p_tot2.

    CALL FUNCTION v_fm
      EXPORTING
        control_parameters = w_ctrlop
        output_options     = w_compop
        user_settings      = abap_true
        format             = format
        zonename           = zonename
        regename           = regename
        reghqdesc          = reghqdesc
        regjoindt          = regjoindt
        regshort           = regshort
        regnet             = regnet
        regtargt1          = regtargt1
        regstp1            = regstp1
        s_budat1           = s_budat1
        s_budat2           = s_budat2
        c_bcl1             = c_bcl1
        c_bc1              = c_bc1
        c_xl1              = c_xl1
        c_ls1              = c_ls1
        p_bcl1             = p_bcl1
        p_bc1              = p_bc1
        p_xl1              = p_xl1
        p_ls1              = p_ls1
        stpcnt2            = stpcnt2
        p_tot1             = p_tot2
        c_tot1             = c_tot1
        bcl1               = bcl1
        bc1                = bc1
        xl1                = xl1
        ls1                = ls1
      IMPORTING
        job_output_info    = w_return " This will have all output
      TABLES
        it_sf1             = it_sf1
        it_sf2             = it_sf2
        it_sf3             = it_sf3
*       itab_division      = itab_division
*       itab_storage       = itab_storage
*       itab_pa0002        = itab_pa0002
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.
    CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.

    CLEAR : zonename,  regename, reghqdesc,regjoindt, regshort, regnet ,regtargt1,regstp1,c_bcl1, c_bc1,c_xl1,
      c_ls1 , p_bcl1 ,p_bc1,p_xl1,p_ls1,stpcnt2,p_tot1, c_tot1 .
*  ENDLOOP.
    CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.

    i_otf[] = w_return-otfdata[].

* Import Binary file and filesize
    CALL FUNCTION 'CONVERT_OTF'
      EXPORTING
        format                = 'PDF'
        max_linewidth         = 132
      IMPORTING
        bin_filesize          = v_len_in
        bin_file              = i_xstring   " This is NOT Binary. This is Hexa
      TABLES
        otf                   = i_otf
        lines                 = i_tline
      EXCEPTIONS
        err_max_linewidth     = 1
        err_format            = 2
        err_conv_not_possible = 3
        OTHERS                = 4.
* Sy-subrc check not checked



*  * Convert Hexa String to Binary format
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer     = i_xstring
      TABLES
        binary_tab = i_objbin[].
* Sy-subrc check not required.

*    DATA: IN_MAILID TYPE AD_SMTPADR.

* Begin of sending email to multiple users
* If business want email to be sent to all users at one time, it can be done

* For now we do not want to send 1 email to multiple users
* Mail has to be sent one email at a time

*  IF P2 EQ 'X'.
*
*      CLEAR IN_MAILID.
    in_mailid = 'JYOTSNA@BLUECROSSLABS.COM'.
    PERFORM send_mail USING in_mailid .
  ENDLOOP.

*   IN_MAILID = 'JYOTSNA@BLUECROSSLABS.COM'.
*    PERFORM SEND_MAIL USING IN_MAILID .
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SMSFFORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM smsfform .
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZSR9_A1'
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
      fm_name            = v_fm
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.

* *   * Set the control parameter
  w_ctrlop-getotf = abap_true.
  w_ctrlop-no_dialog = abap_true.
  w_compop-tdnoprev = abap_true.
  w_ctrlop-preview = space.
  w_compop-tddest = 'LOCL'.

*  CONTROL-NO_OPEN   = 'X'.
*  CONTROL-NO_CLOSE  = 'X'.


*  CALL FUNCTION 'SSF_OPEN'
*    EXPORTING
*      CONTROL_PARAMETERS = CONTROL.

  LOOP AT it_check INTO wa_check.
*    BREAK-POINT .
    CLEAR : zonename.
    zonename = wa_check-zonename.
*    WRITE : / 'ZONE',ZONENAME.
    CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.
    PERFORM form1.
    PERFORM form2.





    CALL FUNCTION v_fm
      EXPORTING
        control_parameters = w_ctrlop
        output_options     = w_compop
        user_settings      = abap_true
        format             = format
        zonename           = zonename
        regename           = regename
        reghqdesc          = reghqdesc
        regjoindt          = regjoindt
        regshort           = regshort
        regnet             = regnet
        regtargt1          = regtargt1
        regstp1            = regstp1
        s_budat1           = s_budat1
        s_budat2           = s_budat2
        c_bcl1             = c_bcl1
        c_bc1              = c_bc1
        c_xl1              = c_xl1
        c_ls1              = c_ls1
        p_bcl1             = p_bcl1
        p_bc1              = p_bc1
        p_xl1              = p_xl1
        p_ls1              = p_ls1
        stpcnt2            = stpcnt2
        p_tot1             = p_tot2
        c_tot1             = c_tot1
        bcl1               = bcl1
        bc1                = bc1
        xl1                = xl1
        ls1                = ls1
      IMPORTING
        job_output_info    = w_return " This will have all output
      TABLES
        it_sf1             = it_sf1
        it_sf2             = it_sf2
        it_sf3             = it_sf3
*       itab_division      = itab_division
*       itab_storage       = itab_storage
*       itab_pa0002        = itab_pa0002
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.

    i_otf[] = w_return-otfdata[].

* Import Binary file and filesize
    CALL FUNCTION 'CONVERT_OTF'
      EXPORTING
        format                = 'PDF'
        max_linewidth         = 132
      IMPORTING
        bin_filesize          = v_len_in
        bin_file              = i_xstring   " This is NOT Binary. This is Hexa
      TABLES
        otf                   = i_otf
        lines                 = i_tline
      EXCEPTIONS
        err_max_linewidth     = 1
        err_format            = 2
        err_conv_not_possible = 3
        OTHERS                = 4.
* Sy-subrc check not checked



*  * Convert Hexa String to Binary format
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer     = i_xstring
      TABLES
        binary_tab = i_objbin[].
* Sy-subrc check not required.

*    DATA: IN_MAILID TYPE AD_SMTPADR.

* Begin of sending email to multiple users
* If business want email to be sent to all users at one time, it can be done

* For now we do not want to send 1 email to multiple users
* Mail has to be sent one email at a time

*  IF P2 EQ 'X'.
*
*      CLEAR IN_MAILID.

  ENDLOOP.

  in_mailid = 'JYOTSNA@BLUECROSSLABS.COM'.
  PERFORM send_mail USING in_mailid.
  CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.

  CLEAR : zonename,  regename, reghqdesc,regjoindt, regshort, regnet ,regtargt1,regstp1,c_bcl1, c_bc1,c_xl1,
    c_ls1 , p_bcl1 ,p_bc1,p_xl1,p_ls1,stpcnt2,p_tot1, c_tot1 .
  CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.
*  CALL FUNCTION 'SSF_CLOSE'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SMSFFORM2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM smsfform2 .



  LOOP AT it_smemail INTO wa_smemail .
    LOOP AT it_check INTO wa_check WHERE  reg EQ wa_smemail-reg.
      CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
        EXPORTING
          formname           = 'ZSR9_A1'
*         VARIANT            = ' '
*         DIRECT_CALL        = ' '
        IMPORTING
          fm_name            = v_fm
        EXCEPTIONS
          no_form            = 1
          no_function_module = 2
          OTHERS             = 3.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

*  CONTROL-NO_OPEN   = 'X'.
*  CONTROL-NO_CLOSE  = 'X'.
*  CALL FUNCTION 'SSF_OPEN'
*    EXPORTING
*      CONTROL_PARAMETERS = CONTROL.

*   * Set the control parameter
      w_ctrlop-getotf = abap_true.
      w_ctrlop-no_dialog = abap_true.
      w_compop-tdnoprev = abap_true.
      w_ctrlop-preview = space.
      w_compop-tddest = 'LOCL'.


*  LOOP AT IT_CHECK INTO WA_CHECK.
*    BREAK-POINT .
      CLEAR : zonename.
      zonename = wa_check-zonename.
*    WRITE : / 'ZONE',ZONENAME.
      CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.
      PERFORM form1.
      PERFORM form2.


      CALL FUNCTION v_fm
        EXPORTING
          control_parameters = w_ctrlop
          output_options     = w_compop
          user_settings      = abap_true
          format             = format
          zonename           = zonename
          regename           = regename
          reghqdesc          = reghqdesc
          regjoindt          = regjoindt
          regshort           = regshort
          regnet             = regnet
          regtargt1          = regtargt1
          regstp1            = regstp1
          s_budat1           = s_budat1
          s_budat2           = s_budat2
          c_bcl1             = c_bcl1
          c_bc1              = c_bc1
          c_xl1              = c_xl1
          c_ls1              = c_ls1
          p_bcl1             = p_bcl1
          p_bc1              = p_bc1
          p_xl1              = p_xl1
          p_ls1              = p_ls1
          stpcnt2            = stpcnt2
          p_tot1             = p_tot2
          c_tot1             = c_tot1
          bcl1               = bcl1
          bc1                = bc1
          xl1                = xl1
          ls1                = ls1
        IMPORTING
          job_output_info    = w_return " This will have all output
        TABLES
          it_sf1             = it_sf1
          it_sf2             = it_sf2
          it_sf3             = it_sf3
*         itab_division      = itab_division
*         itab_storage       = itab_storage
*         itab_pa0002        = itab_pa0002
        EXCEPTIONS
          formatting_error   = 1
          internal_error     = 2
          send_error         = 3
          user_canceled      = 4
          OTHERS             = 5.
      CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.

      CLEAR : zonename,  regename, reghqdesc,regjoindt, regshort, regnet ,regtargt1,regstp1,c_bcl1, c_bc1,c_xl1,
        c_ls1 , p_bcl1 ,p_bc1,p_xl1,p_ls1,stpcnt2,p_tot1, c_tot1 .
*  ENDLOOP.
      CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.


      i_otf[] = w_return-otfdata[].

* Import Binary file and filesize
      CALL FUNCTION 'CONVERT_OTF'
        EXPORTING
          format                = 'PDF'
          max_linewidth         = 132
        IMPORTING
          bin_filesize          = v_len_in
          bin_file              = i_xstring   " This is NOT Binary. This is Hexa
        TABLES
          otf                   = i_otf
          lines                 = i_tline
        EXCEPTIONS
          err_max_linewidth     = 1
          err_format            = 2
          err_conv_not_possible = 3
          OTHERS                = 4.
* Sy-subrc check not checked



*  * Convert Hexa String to Binary format
      CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
        EXPORTING
          buffer     = i_xstring
        TABLES
          binary_tab = i_objbin[].
* Sy-subrc check not required.

*    DATA: IN_MAILID TYPE AD_SMTPADR.

* Begin of sending email to multiple users
* If business want email to be sent to all users at one time, it can be done

* For now we do not want to send 1 email to multiple users
* Mail has to be sent one email at a time

*  IF P2 EQ 'X'.
*
*      CLEAR IN_MAILID.
*    IN_MAILID = 'JYOTSNA@BLUECROSSLABS.COM'.
      in_mailid = wa_smemail-usrid_long.
*      BREAK-POINT .
      PERFORM send_mail USING in_mailid .
*      BREAK-POINT.
      WRITE : / wa_zmemail-reg.
    ENDLOOP.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PRINTEMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM printemail .
  options-tdgetotf = 'X'.

  SORT it_tad2 BY seq reg zm rm bzirk.

  IF it_tad2 IS INITIAL.
    MESSAGE 'NO DATA FOUND FOR THIS DIVISION' TYPE 'E'.
    EXIT.
  ENDIF.

*    LOOP AT IT_TAM1 INTO WA_TAM1.
  CALL FUNCTION 'OPEN_FORM'
    EXPORTING
      device                      = 'PRINTER'
      dialog                      = ''
*     form                        = 'ZSR9_1'
      language                    = sy-langu
      options                     = options
    EXCEPTIONS
      canceled                    = 1
      device                      = 2
      form                        = 3
      options                     = 4
      unclosed                    = 5
      mail_options                = 6
      archive_error               = 7
      invalid_fax_number          = 8
      more_params_needed_in_batch = 9
      spool_error                 = 10
      codepage                    = 11
      OTHERS                      = 12.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
  CALL FUNCTION 'START_FORM'
    EXPORTING
      form        = 'ZSR9_1_N1'
      language    = sy-langu
    EXCEPTIONS
      form        = 1
      format      = 2
      unended     = 3
      unopened    = 4
      unused      = 5
      spool_error = 6
      codepage    = 7
      OTHERS      = 8.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  page1 = 0.
  page2 = 0.

  SELECT * FROM pa0001 INTO TABLE it_pa0001_1 FOR ALL ENTRIES IN it_tad2 WHERE plans = it_tad2-plans AND zz_hqcode NE '     '.
  SORT it_pa0001_1 BY endda DESCENDING.

  LOOP AT it_tad2 INTO wa_tad2.
*         WHERE zpernr = wa_tam1-zpernr.
    CLEAR : jo_dt1,stp,c_bcl,c_bc,c_xl,zjo_dt,c_ls.
*      WRITE : / WA_TAD2-REG, WA_TAD2-ZM, WA_TAD2-RM, WA_TAD2-BZIRK,WA_TAD2-DIV,WA_TAD2-PLANS, WA_TAD2-SVAL,
*      WA_TAD2-ACN_VAL, WA_TAD2-OTH_VAL, WA_TAD2-NET,wa_tad2-targt.
    ON CHANGE OF wa_tad2-reg.
      stpcnt = 0.
      NEW-PAGE.
      page1 = 1.
      FORMAT COLOR 3.
*        WRITE : /1 'ZM',6 '*'.
      READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_tad2-reg.
      IF sy-subrc EQ 0 AND wa_tac7-zpernr NE 0.
*          WRITE : 20 WA_TAC7-ZENAME,35 WA_TAC7-ZZZ_HQDESC.
        zm_name = wa_tac7-zename.
      ELSE.
        zm_name = 'VACANT'.
      ENDIF.
      page3 = page1 + page2.
      page4 = page3.
      IF page3 GT 1.
        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            element = 'HEAD1'
            window  = 'MAIN'.
      ELSE.
*          WRITE : /20 'VACANT'.
        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            element = 'HEAD2'
            window  = 'MAIN'.
      ENDIF.
      page1 = page1 + 1.
      page2 = page2 + 1.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'HEAD3'
          window  = 'MAIN'.
    ENDON.

    FORMAT COLOR 1.
    READ TABLE it_tac7 INTO wa_tac7 WITH KEY plans = wa_tad2-plans.
    IF sy-subrc EQ 0 AND wa_tac7-begda NE 0.
      CONCATENATE wa_tac7-begda+4(2) '/' wa_tac7-begda+0(4) INTO jo_dt1.
*        WRITE : /1(15) WA_TAC7-ENAME,17(15) WA_TAC7-ZZ_HQDESC,34 JO_DT1,43(5) WA_TAC7-SHORT.

      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'T1'
          window  = 'MAIN'.
    ELSE.
*        WRITE : /1(15) 'VACANT',wa_tad2-plans.
*        READ TABLE IT_pa0001_1 INTO WA_PA0001_1 WITH KEY plans = wa_tad2-plans.
      SELECT SINGLE * FROM zdrphq WHERE bzirk EQ wa_tad2-bzirk.
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM zthr_heq_des WHERE zz_hqcode EQ zdrphq-zz_hqcode.
        IF sy-subrc EQ 0.
          CLEAR : hqcode.
*          WRITE : zthr_heq_des-zz_hqdesc.
          hqcode = zthr_heq_des-zz_hqdesc.
        ENDIF.
      ENDIF.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'T2'
          window  = 'MAIN'.
    ENDIF.
*      WRITE : 50(3) WA_TAD2-DIV,55(13) WA_TAD2-NET,70(15) wa_tad2-targt.
    IF wa_tad2-targt NE 0.
      stp = ( wa_tad2-net / wa_tad2-targt ) * 100.
    ENDIF.
    IF stp GE 100.
      stpcnt = stpcnt + 1.
    ENDIF.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'T3'
        window  = 'MAIN'.
    IF wa_tad2-rm NE '      '.
      rmtot = rmtot + wa_tad2-net.
      rmtar = rmtar + wa_tad2-targt.
    ENDIF.
    IF wa_tad2-reg NE '      '.
      zmtot = zmtot + wa_tad2-net.
      zmtar = zmtar + wa_tad2-targt.
    ENDIF.
    IF wa_tad2-zm NE '      '.
      dztot = dztot + wa_tad2-net.
      dzmtar = dzmtar + wa_tad2-targt.
    ENDIF.
*    RMTOT = RMTOT + WA_TAD2-NET.
*    ZMTOT = ZMTOT + WA_TAD2-NET.
*    RMTAR = RMTAR + WA_TAD2-TARGT.
*    ZMTAR = ZMTAR + WA_TAD2-TARGT.
**    IF WA_TAD2-ZM NE '      '.
*    DZTOT = DZTOT + WA_TAD2-NET.
*    DZMTAR = DZMTAR + WA_TAD2-TARGT.
**    ENDIF.
    FORMAT COLOR 4.
    IF wa_tad2-rm NE '      '.
      AT END OF rm.
        CLEAR : rjo_dt.
*        ULINE.
        READ TABLE it_tac7 INTO wa_tac7 WITH KEY rm = wa_tad2-rm.
        IF sy-subrc EQ 0 AND wa_tac7-rpernr NE 0.
*          WRITE : /1(15) WA_TAC7-RENAME,17(15) WA_TAC7-RZZ_HQDESC,43(5) WA_TAC7-RSHORT,wa_tac7-rbegda.
          CONCATENATE wa_tac7-rbegda+4(2) '/' wa_tac7-rbegda+0(4) INTO rjo_dt.
*          WRITE : / 'rjo_dt',rjo_dt.
        ENDIF.
        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            element = 'R1'
            window  = 'MAIN'.
*        ELSE.
**          WRITE : / 'VACANT'.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'R2'
*              WINDOW  = 'MAIN'.
*        ENDIF.
*        WRITE : 55(13) rmtot,70(15) rmtar.
        IF rmtar NE 0.
          rstp = ( rmtot / rmtar ) * 100.
        ENDIF.
        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            element = 'R3'
            window  = 'MAIN'.
        rmtot = 0.
        rmtar = 0.
        rstp = 0.
*        ULINE.
      ENDAT.
    ENDIF.
**********************************
    IF wa_tad2-zm NE '      '.
      AT END OF zm.
        CLEAR : dzjo_dt.
*        ULINE.
        READ TABLE it_tac7 INTO wa_tac7 WITH KEY zm = wa_tad2-zm.
        IF sy-subrc EQ 0 AND wa_tac7-dzpernr NE 0.
*          WRITE : /1(15) WA_TAC7-RENAME,17(15) WA_TAC7-RZZ_HQDESC,43(5) WA_TAC7-RSHORT,wa_tac7-rbegda.
          CONCATENATE wa_tac7-dzbegda+4(2) '/' wa_tac7-dzbegda+0(4) INTO dzjo_dt.
*          WRITE : / 'rjo_dt',rjo_dt.
        ENDIF.
        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            element = 'DZM1'
            window  = 'MAIN'.
*        ELSE.
**          WRITE : / 'VACANT'.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'DZM2'
*              WINDOW  = 'MAIN'.
*        ENDIF.
**        WRITE : 55(13) rmtot,70(15) rmtar.
        IF dzmtar NE 0.
          dzmstp = ( dztot / dzmtar ) * 100.
        ENDIF.
        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            element = 'DZM3'
            window  = 'MAIN'.
        dztot = 0.
        dzmtar = 0.
        dzmstp = 0.
*        ULINE.
      ENDAT.
    ENDIF.
**********************************
    IF wa_tad2-reg NE '      '.
      AT END OF reg.
        CLEAR : c_bcl,c_ls,p_ls,c_bc,c_xl,zjo_dt,p_bcl,p_bc,p_xl,p_tot,zm_name.
*        ULINE.
        FORMAT COLOR 3.
*        WRITE : / 'ZONE TOTAL :',55(13) ZMTOT,70(15) zmtar.
        IF zmtar NE 0.
          zstp = ( zmtot / zmtar ) * 100.
        ENDIF.
        READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_tad2-reg.
        IF sy-subrc EQ 0 AND wa_tac7-zpernr NE 0.
*          WRITE : / wa_tac7-zename,wa_tac7-zbegda.
          CONCATENATE wa_tac7-zbegda+4(2) '/' wa_tac7-zbegda+0(4) INTO zjo_dt.
          zm_name = wa_tac7-zename.
*        ELSE.
*          ZM_NAME = 'VACANT'.
        ENDIF.


*        READ TABLE IT_TAC7 INTO WA_TAC7 WITH KEY reg = WA_TAD2-reg.
*        IF SY-SUBRC EQ 0 AND WA_TAC7-ZPERNR NE 0.
**          WRITE : 20 WA_TAC7-ZENAME,35 WA_TAC7-ZZZ_HQDESC.
*          ZM_NAME = WA_TAC7-ZENAME.
*        else.
*          ZM_NAME = 'VACANT'.
*        ENDIF.

        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            element = 'Z1'
            window  = 'MAIN'.
        READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_tad2-reg div = 'BCL'.  "Jyotsna check here
        IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
          c_bcl = wa_tad4-count.
          c_tot = c_tot + wa_tad4-count.
          READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_tad2-reg div = 'BCL'.
          IF sy-subrc EQ 0.
            p_bcl = wa_tad21-net / c_bcl.
*            P_TOT = P_TOT + P_BCL.
          ENDIF.
          CALL FUNCTION 'WRITE_FORM'
            EXPORTING
              element = 'Z2'
              window  = 'MAIN'.
        ENDIF.
        READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_tad2-reg div = 'BC'.
        IF sy-subrc EQ 0 AND  wa_tad4-count NE 0.
          c_bc = wa_tad4-count.
          c_tot = c_tot + wa_tad4-count.
          READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_tad2-reg div = 'BC'.
          IF sy-subrc EQ 0.
            p_bc = wa_tad21-net / c_bc.
*            P_TOT = P_TOT + P_BC.
          ENDIF.
          CALL FUNCTION 'WRITE_FORM'
            EXPORTING
              element = 'Z3'
              window  = 'MAIN'.
        ENDIF.
        READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_tad2-reg div = 'XL'.
        IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
          c_xl = wa_tad4-count.
          c_tot = c_tot + wa_tad4-count.
          READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_tad2-reg div = 'XL'.
          IF sy-subrc EQ 0.
            p_xl = wa_tad21-net / c_xl.
*            P_TOT = P_TOT + P_XL.
          ENDIF.
          CALL FUNCTION 'WRITE_FORM'
            EXPORTING
              element = 'Z4'
              window  = 'MAIN'.
        ENDIF.

        READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_tad2-reg div = 'LS'.
        IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
          c_ls = wa_tad4-count.
          c_tot = c_tot + wa_tad4-count.
          READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_tad2-reg div = 'LS'.
          IF sy-subrc EQ 0.
            p_ls = wa_tad21-net / c_ls.
*            P_TOT = P_TOT + P_XL.
          ENDIF.
          CALL FUNCTION 'WRITE_FORM'
            EXPORTING
              element = 'Z41'
              window  = 'MAIN'.
        ENDIF.

        p_tot = zmtot / c_tot.

        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            element = 'Z5'
            window  = 'MAIN'.
        zmtot = 0.
        zmtar = 0.
        c_bcl = 0.
        c_ls = 0.
        c_bc = 0.
        c_xl = 0.
        c_tot = 0.
        p_bcl = 0.
        p_bc = 0.
        p_xl = 0.
        p_ls = 0.
        p_tot = 0.
        zstp = 0.
        CLEAR : zm_name.
*        ULINE.
      ENDAT.
    ENDIF.

  ENDLOOP.
  CALL FUNCTION 'END_FORM'
    EXCEPTIONS
      unopened                 = 1
      bad_pageformat_for_print = 2
      spool_error              = 3
      codepage                 = 4
      OTHERS                   = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CALL FUNCTION 'CLOSE_FORM'
    IMPORTING
      result  = result
    TABLES
      otfdata = l_otf_data.

  CALL FUNCTION 'CONVERT_OTF'
    EXPORTING
      format       = 'PDF'
    IMPORTING
      bin_filesize = l_bin_filesize
    TABLES
      otf          = l_otf_data
      lines        = l_asc_data.

  CALL FUNCTION 'SX_TABLE_LINE_WIDTH_CHANGE'
    EXPORTING
      line_width_dst = '255'
    TABLES
      content_in     = l_asc_data
      content_out    = objbin.

  WRITE s_budat1 TO wa_d1 DD/MM/YYYY.
  WRITE s_budat2 TO wa_d2 DD/MM/YYYY.

  DESCRIBE TABLE objbin LINES righe_attachment.
  objtxt = 'This eMail is meant for information only. Please DO NOT REPLY'.APPEND objtxt.
  objtxt = '                                 '.APPEND objtxt.
  objtxt = 'BLUE CROSS LABORATORIES LTD.'.APPEND objtxt.
  DESCRIBE TABLE objtxt LINES righe_testo.
  doc_chng-obj_name = 'URGENT'.
  doc_chng-expiry_dat = sy-datum + 10.
  CONDENSE ltx.
  CONDENSE objtxt.
*      CONCATENATE 'SR9 for the period' ltx '-' INTO doc_chng-obj_descr SEPARATED BY space.
  CONCATENATE 'SR9 for the period of: ' wa_d1 'to' wa_d2 INTO doc_chng-obj_descr SEPARATED BY space.
  doc_chng-sensitivty = 'F'.
  doc_chng-doc_size = righe_testo * 255 .

  CLEAR objpack-transf_bin.

  objpack-head_start = 1.
  objpack-head_num = 0.
  objpack-body_start = 1.
  objpack-body_num = 4.
  objpack-doc_type = 'TXT'.
  APPEND objpack.

  objpack-transf_bin = 'X'.
  objpack-head_start = 1.
  objpack-head_num = 0.
  objpack-body_start = 1.
  objpack-body_num = righe_attachment.
  objpack-doc_type = 'PDF'.
  objpack-obj_name = 'TEST'.
  CONDENSE ltx.



*      CONCATENATE 'SR9 ' ltx  'FOR THE PERIOD' wa_d1 'TO' wa_d2 INTO objpack-obj_descr SEPARATED BY space.
  CONCATENATE 'SR-9' '.' INTO objpack-obj_descr SEPARATED BY space.
  objpack-doc_size = righe_attachment * 255.
  APPEND objpack.
  CLEAR objpack.

*      LOOP AT it_TAM2 INTO wa_TAM2 WHERE ZPERNR = wa_TAd2-ZPERNR.
*    READ TABLE it_mail1 INTO wa_mail1 WITH KEY lifnr = wa_tab4-lifnr.
*    IF sy-subrc EQ 0.
*      MESSAGE 'EMAIL SENT' TYPE 'I'.
*  loop at it_mail1 into wa_mail1.
  reclist-receiver =   uemail.
  reclist-express = 'X'.
  reclist-rec_type = 'U'.
  reclist-notif_del = 'X'. " request delivery notification
  reclist-notif_ndel = 'X'. " request not delivered notification
  APPEND reclist.
  CLEAR reclist.
*  endif.
*      ENDLOOP.

  DESCRIBE TABLE reclist LINES mcount.
  IF mcount > 0.
    DATA: sender LIKE soextreci1-receiver.
**ADDED BY SATHISH.B
    TYPES: BEGIN OF t_usr21,
             bname      TYPE usr21-bname,
             persnumber TYPE usr21-persnumber,
             addrnumber TYPE usr21-addrnumber,
           END OF t_usr21.

    TYPES: BEGIN OF t_adr6,
             addrnumber TYPE usr21-addrnumber,
             persnumber TYPE usr21-persnumber,
             smtp_addr  TYPE adr6-smtp_addr,
           END OF t_adr6.

    DATA: it_usr21 TYPE TABLE OF t_usr21,
          wa_usr21 TYPE t_usr21,
          it_adr6  TYPE TABLE OF t_adr6,
          wa_adr6  TYPE t_adr6.
    SELECT  bname persnumber addrnumber FROM usr21 INTO TABLE it_usr21
    WHERE bname = sy-uname.
    IF sy-subrc = 0.
      SELECT addrnumber persnumber smtp_addr FROM adr6 INTO TABLE it_adr6
        FOR ALL ENTRIES IN it_usr21 WHERE addrnumber = it_usr21-addrnumber
      AND   persnumber = it_usr21-persnumber.
    ENDIF.

    LOOP AT it_usr21 INTO wa_usr21.
      READ TABLE it_adr6 INTO wa_adr6 WITH KEY addrnumber = wa_usr21-addrnumber.
      IF sy-subrc = 0.
        sender = wa_adr6-smtp_addr.
      ENDIF.
    ENDLOOP.
    CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
      EXPORTING
        document_data              = doc_chng
        put_in_outbox              = 'X'
        sender_address             = sender
        sender_address_type        = 'SMTP'
*       COMMIT_WORK                = ' '
* IMPORTING
*       SENT_TO_ALL                =
*       NEW_OBJECT_ID              =
*       SENDER_ID                  =
      TABLES
        packing_list               = objpack
*       OBJECT_HEADER              =
        contents_bin               = objbin
        contents_txt               = objtxt
*       CONTENTS_HEX               =
*       OBJECT_PARA                =
*       OBJECT_PARB                =
        receivers                  = reclist
      EXCEPTIONS
        too_many_receivers         = 1
        document_not_sent          = 2
        document_type_not_exist    = 3
        operation_no_authorization = 4
        parameter_error            = 5
        x_error                    = 6
        enqueue_error              = 7
        OTHERS                     = 8.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    COMMIT WORK.
    IF sy-subrc EQ 0.
      WRITE : / 'email sent on email id: ',uemail.
    ENDIF.

**modid ver1.0 starts

    CLEAR   : objpack,
              objhead,
              objtxt,
              objbin,
              reclist.

    REFRESH : objpack,
              objhead,
              objtxt,
              objbin,
              reclist.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SMEAMIL1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM smeamil1 .
  options-tdgetotf = 'X'.

  SORT it_tad2 BY gmpernr reg zm rm bzirk.
  IF it_tad2 IS INITIAL.
    MESSAGE 'NO DATA FOUND FOR THIS DIVISION' TYPE 'E'.
    EXIT.
  ENDIF.
*  EXIT.
  LOOP AT it_tam1 INTO wa_tam1 WHERE zpernr GT 0..
    CALL FUNCTION 'OPEN_FORM'
      EXPORTING
        device                      = 'PRINTER'
        dialog                      = ''
*       form                        = 'ZSR9_1'
        language                    = sy-langu
        options                     = options
      EXCEPTIONS
        canceled                    = 1
        device                      = 2
        form                        = 3
        options                     = 4
        unclosed                    = 5
        mail_options                = 6
        archive_error               = 7
        invalid_fax_number          = 8
        more_params_needed_in_batch = 9
        spool_error                 = 10
        codepage                    = 11
        OTHERS                      = 12.
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.
    CALL FUNCTION 'START_FORM'
      EXPORTING
        form        = 'ZSR9_1'
        language    = sy-langu
      EXCEPTIONS
        form        = 1
        format      = 2
        unended     = 3
        unopened    = 4
        unused      = 5
        spool_error = 6
        codepage    = 7
        OTHERS      = 8.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
    page1 = 0.
    page2 = 0.

    SELECT * FROM pa0001 INTO TABLE it_pa0001_1 FOR ALL ENTRIES IN it_tad2 WHERE plans = it_tad2-plans AND zz_hqcode NE '     '.
    SORT it_pa0001_1 BY endda DESCENDING.

    LOOP AT it_tad2 INTO wa_tad2 WHERE gmpernr = wa_tam1-zpernr.
      CLEAR : jo_dt1,stp,c_bcl,c_bc,c_xl,zjo_dt.
*      WRITE : / WA_TAD2-REG, WA_TAD2-ZM, WA_TAD2-RM, WA_TAD2-BZIRK,WA_TAD2-DIV,WA_TAD2-PLANS, WA_TAD2-SVAL,
*      WA_TAD2-ACN_VAL, WA_TAD2-OTH_VAL, WA_TAD2-NET,wa_tad2-targt.
      ON CHANGE OF wa_tad2-reg.
        NEW-PAGE.
        page1 = 1.
        FORMAT COLOR 3.
*        WRITE : /1 'ZM',6 '*'.
        READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_tad2-reg.
        IF sy-subrc EQ 0 AND wa_tac7-zpernr NE 0.
*          WRITE : 20 WA_TAC7-ZENAME,35 WA_TAC7-ZZZ_HQDESC.
          zm_name = wa_tac7-zename.
        ELSE.
          zm_name = 'VACANT'.
        ENDIF.
        page3 = page1 + page2.
        page4 = page3.
        IF page3 GT 1.
          CALL FUNCTION 'WRITE_FORM'
            EXPORTING
              element = 'HEAD1'
              window  = 'MAIN'.
        ELSE.
*          WRITE : /20 'VACANT'.
          CALL FUNCTION 'WRITE_FORM'
            EXPORTING
              element = 'HEAD2'
              window  = 'MAIN'.
        ENDIF.
        page1 = page1 + 1.
        page2 = page2 + 1.
*        ULINE.
*        WRITE : /1 'NAME',17 'H.Q.',34 'D.O.J.',50 'DIV',57 'SALES',78 'TARGET'.
*        SKIP.
        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            element = 'HEAD3'
            window  = 'MAIN'.
      ENDON.
      FORMAT COLOR 1.
      READ TABLE it_tac7 INTO wa_tac7 WITH KEY plans = wa_tad2-plans.
      IF sy-subrc EQ 0 AND wa_tac7-begda NE 0.
        CONCATENATE wa_tac7-begda+4(2) '/' wa_tac7-begda+0(4) INTO jo_dt1.
*        WRITE : /1(15) WA_TAC7-ENAME,17(15) WA_TAC7-ZZ_HQDESC,34 JO_DT1,43(5) WA_TAC7-SHORT.

        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            element = 'T1'
            window  = 'MAIN'.
      ELSE.
*        WRITE : /1(15) 'VACANT',wa_tad2-plans.
*          READ TABLE IT_pa0001_1 INTO WA_PA0001_1 WITH KEY plans = wa_tad2-plans.
        SELECT SINGLE * FROM zdrphq WHERE bzirk EQ wa_tad2-bzirk.
        IF sy-subrc EQ 0.
          SELECT SINGLE * FROM zthr_heq_des WHERE zz_hqcode EQ zdrphq-zz_hqcode.
          IF sy-subrc EQ 0.
            CLEAR : hqcode.
*          WRITE : zthr_heq_des-zz_hqdesc.
            hqcode = zthr_heq_des-zz_hqdesc.
          ENDIF.
        ENDIF.
        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            element = 'T2'
            window  = 'MAIN'.
      ENDIF.
*      WRITE : 50(3) WA_TAD2-DIV,55(13) WA_TAD2-NET,70(15) wa_tad2-targt.
      IF wa_tad2-targt NE 0.
        stp = ( wa_tad2-net / wa_tad2-targt ) * 100.
      ENDIF.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'T3'
          window  = 'MAIN'.
      IF wa_tad2-rm NE '      '.
        rmtot = rmtot + wa_tad2-net.
        rmtar = rmtar + wa_tad2-targt.
      ENDIF.
      IF wa_tad2-reg NE '      '.
        zmtot = zmtot + wa_tad2-net.
        zmtar = zmtar + wa_tad2-targt.
      ENDIF.
      IF wa_tad2-zm NE '      '.
        dztot = dztot + wa_tad2-net.
        dzmtar = dzmtar + wa_tad2-targt.
      ENDIF.
*      RMTOT = RMTOT + WA_TAD2-NET.
*      ZMTOT = ZMTOT + WA_TAD2-NET.
*      RMTAR = RMTAR + WA_TAD2-TARGT.
*      ZMTAR = ZMTAR + WA_TAD2-TARGT.
*      IF WA_TAD2-ZM NE '      '.
*        DZTOT = DZTOT + WA_TAD2-NET.
*        DZMTAR = DZMTAR + WA_TAD2-TARGT.
*      ENDIF.
      FORMAT COLOR 4.
      IF wa_tad2-rm NE '      '.
        AT END OF rm.
          CLEAR : rjo_dt.
*        ULINE.
          READ TABLE it_tac7 INTO wa_tac7 WITH KEY rm = wa_tad2-rm.
          IF sy-subrc EQ 0 AND wa_tac7-rpernr NE 0.
*          WRITE : /1(15) WA_TAC7-RENAME,17(15) WA_TAC7-RZZ_HQDESC,43(5) WA_TAC7-RSHORT,wa_tac7-rbegda.
            CONCATENATE wa_tac7-rbegda+4(2) '/' wa_tac7-rbegda+0(4) INTO rjo_dt.
          ENDIF.
          CALL FUNCTION 'WRITE_FORM'
            EXPORTING
              element = 'R1'
              window  = 'MAIN'.
*          else.
**          WRITE : / 'VACANT'.
*            call function 'WRITE_FORM'
*              EXPORTING
*                element = 'R2'
*                window  = 'MAIN'.
*          endif.
*        WRITE : 55(13) rmtot,70(15) rmtar.
          IF rmtar NE 0.
            rstp = ( rmtot / rmtar ) * 100.
          ENDIF.
          CALL FUNCTION 'WRITE_FORM'
            EXPORTING
              element = 'R3'
              window  = 'MAIN'.
          rmtot = 0.
          rmtar = 0.
          rstp = 0.
*        ULINE.
        ENDAT.
      ENDIF.
***************DZM************************
      IF wa_tad2-zm NE '      '.
        AT END OF zm.
          CLEAR : dzjo_dt.
*        ULINE.
          READ TABLE it_tac7 INTO wa_tac7 WITH KEY zm = wa_tad2-zm.
          IF sy-subrc EQ 0 AND wa_tac7-dzpernr NE 0.
*          WRITE : /1(15) WA_TAC7-RENAME,17(15) WA_TAC7-RZZ_HQDESC,43(5) WA_TAC7-RSHORT,wa_tac7-rbegda.
            CONCATENATE wa_tac7-dzbegda+4(2) '/' wa_tac7-dzbegda+0(4) INTO dzjo_dt.
*          WRITE : / 'rjo_dt',rjo_dt.
          ENDIF.
          CALL FUNCTION 'WRITE_FORM'
            EXPORTING
              element = 'DZM1'
              window  = 'MAIN'.
*          else.
**          WRITE : / 'VACANT'.
*            call function 'WRITE_FORM'
*              EXPORTING
*                element = 'DZM2'
*                window  = 'MAIN'.
*          endif.
*        WRITE : 55(13) rmtot,70(15) rmtar.
          IF dzmtar NE 0.
            dzmstp = ( dztot / dzmtar ) * 100.
          ENDIF.
          CALL FUNCTION 'WRITE_FORM'
            EXPORTING
              element = 'DZM3'
              window  = 'MAIN'.
          dztot = 0.
          dzmtar = 0.
          dzmstp = 0.
*        ULINE.
        ENDAT.
      ENDIF.
******************************************
      IF wa_tad2-reg NE '      '.
        AT END OF reg.
          CLEAR : c_bcl,c_bc,c_xl,zjo_dt,p_bcl,p_bc,p_xl,p_tot.
*        ULINE.
          FORMAT COLOR 3.
*        WRITE : / 'ZONE TOTAL :',55(13) ZMTOT,70(15) zmtar.
          IF zmtar NE 0.
            zstp = ( zmtot / zmtar ) * 100.
          ENDIF.
          READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_tad2-reg.
          IF sy-subrc EQ 0 AND wa_tac7-zpernr NE 0.
*          WRITE : / wa_tac7-zename,wa_tac7-zbegda.
            CONCATENATE wa_tac7-zbegda+4(2) '/' wa_tac7-zbegda+0(4) INTO zjo_dt.
          ENDIF.
          CALL FUNCTION 'WRITE_FORM'
            EXPORTING
              element = 'Z1'
              window  = 'MAIN'.
          READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_tad2-reg div = 'BCL'.  "Jyotsna check here
          IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
            c_bcl = wa_tad4-count.
            c_tot = c_tot + wa_tad4-count.
            READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_tad2-reg div = 'BCL'.
            IF sy-subrc EQ 0.
              p_bcl = wa_tad21-net / c_bcl.
*            P_TOT = P_TOT + P_BCL.
            ENDIF.
            CALL FUNCTION 'WRITE_FORM'
              EXPORTING
                element = 'Z2'
                window  = 'MAIN'.
          ENDIF.
          READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_tad2-reg div = 'BC'.
          IF sy-subrc EQ 0 AND  wa_tad4-count NE 0.
            c_bc = wa_tad4-count.
            c_tot = c_tot + wa_tad4-count.
            READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_tad2-reg div = 'BC'.
            IF sy-subrc EQ 0.
              p_bc = wa_tad21-net / c_bc.
*            P_TOT = P_TOT + P_BC.
            ENDIF.
            CALL FUNCTION 'WRITE_FORM'
              EXPORTING
                element = 'Z3'
                window  = 'MAIN'.
          ENDIF.
          READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_tad2-reg div = 'XL'.
          IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
            c_xl = wa_tad4-count.
            c_tot = c_tot + wa_tad4-count.
            READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_tad2-reg div = 'XL'.
            IF sy-subrc EQ 0.
              p_xl = wa_tad21-net / c_xl.
*            P_TOT = P_TOT + P_XL.
            ENDIF.
            CALL FUNCTION 'WRITE_FORM'
              EXPORTING
                element = 'Z4'
                window  = 'MAIN'.
          ENDIF.
          p_tot = zmtot / c_tot.

          CALL FUNCTION 'WRITE_FORM'
            EXPORTING
              element = 'Z5'
              window  = 'MAIN'.
          zmtot = 0.
          zmtar = 0.
          c_bcl = 0.
          c_bc = 0.
          c_xl = 0.
          c_tot = 0.
          p_bcl = 0.
          p_bc = 0.
          p_xl = 0.
          p_tot = 0.
          zstp = 0.
          CLEAR : zm_name.
*        ULINE.
        ENDAT.
      ENDIF.

    ENDLOOP.
    CALL FUNCTION 'END_FORM'
      EXCEPTIONS
        unopened                 = 1
        bad_pageformat_for_print = 2
        spool_error              = 3
        codepage                 = 4
        OTHERS                   = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CALL FUNCTION 'CLOSE_FORM'
      IMPORTING
        result  = result
      TABLES
        otfdata = l_otf_data.

    CALL FUNCTION 'CONVERT_OTF'
      EXPORTING
        format       = 'PDF'
      IMPORTING
        bin_filesize = l_bin_filesize
      TABLES
        otf          = l_otf_data
        lines        = l_asc_data.

    CALL FUNCTION 'SX_TABLE_LINE_WIDTH_CHANGE'
      EXPORTING
        line_width_dst = '255'
      TABLES
        content_in     = l_asc_data
        content_out    = objbin.

    WRITE s_budat1 TO wa_d1 DD/MM/YYYY.
    WRITE s_budat2 TO wa_d2 DD/MM/YYYY.

    DESCRIBE TABLE objbin LINES righe_attachment.
    objtxt = 'This eMail is meant for information only. Please DO NOT REPLY'.APPEND objtxt.
    objtxt = '                                 '.APPEND objtxt.
    objtxt = 'BLUE CROSS LABORATORIES LTD.'.APPEND objtxt.
    DESCRIBE TABLE objtxt LINES righe_testo.
    doc_chng-obj_name = 'URGENT'.
    doc_chng-expiry_dat = sy-datum + 10.
    CONDENSE ltx.
    CONDENSE objtxt.
*      CONCATENATE 'SR9 for the period' ltx '-' INTO doc_chng-obj_descr SEPARATED BY space.
    CONCATENATE 'SR9 for the period of: ' wa_d1 'to' wa_d2 INTO doc_chng-obj_descr SEPARATED BY space.
    doc_chng-sensitivty = 'F'.
    doc_chng-doc_size = righe_testo * 255 .

    CLEAR objpack-transf_bin.

    objpack-head_start = 1.
    objpack-head_num = 0.
    objpack-body_start = 1.
    objpack-body_num = 4.
    objpack-doc_type = 'TXT'.
    APPEND objpack.

    objpack-transf_bin = 'X'.
    objpack-head_start = 1.
    objpack-head_num = 0.
    objpack-body_start = 1.
    objpack-body_num = righe_attachment.
    objpack-doc_type = 'PDF'.
    objpack-obj_name = 'TEST'.
    CONDENSE ltx.



*      CONCATENATE 'SR9 ' ltx  'FOR THE PERIOD' wa_d1 'TO' wa_d2 INTO objpack-obj_descr SEPARATED BY space.
    CONCATENATE 'SR-9' '.' INTO objpack-obj_descr SEPARATED BY space.
    objpack-doc_size = righe_attachment * 255.
    APPEND objpack.
    CLEAR objpack.

    LOOP AT it_tam2 INTO wa_tam2 WHERE zpernr = wa_tad2-gmpernr.
*    READ TABLE it_mail1 INTO wa_mail1 WITH KEY lifnr = wa_tab4-lifnr.
*    IF sy-subrc EQ 0.
*      MESSAGE 'EMAIL SENT' TYPE 'I'.
*  loop at it_mail1 into wa_mail1.
      reclist-receiver =   wa_tam2-usrid_long.
      reclist-express = 'X'.
      reclist-rec_type = 'U'.
      reclist-notif_del = 'X'. " request delivery notification
      reclist-notif_ndel = 'X'. " request not delivered notification
      APPEND reclist.
      CLEAR reclist.
*  endif.
    ENDLOOP.

    DESCRIBE TABLE reclist LINES mcount.
    IF mcount > 0.
      DATA: sender LIKE soextreci1-receiver.
***ADDED BY SATHISH.B
      TYPES: BEGIN OF t_usr21,
               bname      TYPE usr21-bname,
               persnumber TYPE usr21-persnumber,
               addrnumber TYPE usr21-addrnumber,
             END OF t_usr21.

      TYPES: BEGIN OF t_adr6,
               addrnumber TYPE usr21-addrnumber,
               persnumber TYPE usr21-persnumber,
               smtp_addr  TYPE adr6-smtp_addr,
             END OF t_adr6.

      DATA: it_usr21 TYPE TABLE OF t_usr21,
            wa_usr21 TYPE t_usr21,
            it_adr6  TYPE TABLE OF t_adr6,
            wa_adr6  TYPE t_adr6.
      SELECT  bname persnumber addrnumber FROM usr21 INTO TABLE it_usr21
      WHERE bname = sy-uname.
      IF sy-subrc = 0.
        SELECT addrnumber persnumber smtp_addr FROM adr6 INTO TABLE it_adr6
          FOR ALL ENTRIES IN it_usr21 WHERE addrnumber = it_usr21-addrnumber
        AND   persnumber = it_usr21-persnumber.
      ENDIF.

      LOOP AT it_usr21 INTO wa_usr21.
        READ TABLE it_adr6 INTO wa_adr6 WITH KEY addrnumber = wa_usr21-addrnumber.
        IF sy-subrc = 0.
          sender = wa_adr6-smtp_addr.
        ENDIF.
      ENDLOOP.
      CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
        EXPORTING
          document_data              = doc_chng
          put_in_outbox              = 'X'
          sender_address             = sender
          sender_address_type        = 'SMTP'
*         COMMIT_WORK                = ' '
* IMPORTING
*         SENT_TO_ALL                =
*         NEW_OBJECT_ID              =
*         SENDER_ID                  =
        TABLES
          packing_list               = objpack
*         OBJECT_HEADER              =
          contents_bin               = objbin
          contents_txt               = objtxt
*         CONTENTS_HEX               =
*         OBJECT_PARA                =
*         OBJECT_PARB                =
          receivers                  = reclist
        EXCEPTIONS
          too_many_receivers         = 1
          document_not_sent          = 2
          document_type_not_exist    = 3
          operation_no_authorization = 4
          parameter_error            = 5
          x_error                    = 6
          enqueue_error              = 7
          OTHERS                     = 8.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      COMMIT WORK.

**modid ver1.0 starts

      CLEAR   : objpack,
                objhead,
                objtxt,
                objbin,
                reclist.

      REFRESH : objpack,
                objhead,
                objtxt,
                objbin,
                reclist.

    ENDIF.

  ENDLOOP.
  DATA : a TYPE i VALUE 0.
  LOOP AT it_tam1 INTO wa_tam1.
    READ TABLE it_tam2 INTO wa_tam2 WITH KEY zpernr = wa_tam1-zpernr.
    IF sy-subrc NE 0.
      a = 1.
      FORMAT COLOR 6.
      WRITE : / 'EMAIL ID IS NOT MAINTAINED FOR',wa_tam2-zpernr.
*      MESSAGE 'EMAIL SENT' TYPE 'I'.
    ELSEIF sy-subrc EQ 0.
      FORMAT COLOR 5.
      WRITE : / 'EMAIL HAS BEEN SENT TO : ',wa_tam2-zpernr.
    ENDIF.
*    WRITE : / 'a',a.

  ENDLOOP.
****************************EMAIL LAYOUT ENDA HERE******

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SFFORMEM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sfformem .
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZSR9_A2'
*     FORMNAME           = 'ZSR9_9'
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
      fm_name            = v_fm
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.

*  *   * Set the control parameter
  w_ctrlop-getotf = abap_true.
  w_ctrlop-no_dialog = abap_true.
  w_compop-tdnoprev = abap_true.
  w_ctrlop-preview = space.
  w_compop-tddest = 'LOCL'.

*  CONTROL-NO_OPEN   = 'X'.
*  CONTROL-NO_CLOSE  = 'X'.
*
*
*  CALL FUNCTION 'SSF_OPEN'
*    EXPORTING
*      CONTROL_PARAMETERS = CONTROL.
*  SORT IT_CHECK BY REG.

*  LOOP AT IT_CHECK INTO WA_CHECK.
*    BREAK-POINT .
  CLEAR : zonename.
  zonename = wa_check-zonename.
*    WRITE : / 'ZONE',ZONENAME.
  CLEAR : it_sf11,wa_sf11,it_sf12,wa_sf12,it_sf13,wa_sf13,it_sf14,wa_sf14.
*    PERFORM FORM1.
*    PERFORM FORM2.
  PERFORM form1em.
*  PERFORM FORM2EM.





  CALL FUNCTION v_fm
    EXPORTING
      control_parameters = w_ctrlop
      output_options     = w_compop
      user_settings      = abap_true
      format             = format
      zonename           = zonename
      regename           = regename
      reghqdesc          = reghqdesc
      regjoindt          = regjoindt
      regshort           = regshort
      regnet             = regnet
      regtargt1          = regtargt1
      regstp1            = regstp1
      s_budat1           = s_budat1
      s_budat2           = s_budat2
      c_bcl1             = c_bcl1
      c_bc1              = c_bc1
      c_xl1              = c_xl1
      c_ls1              = c_ls1
      p_bcl1             = p_bcl1
      p_bc1              = p_bc1
      p_xl1              = p_xl1
      p_ls1              = p_ls1
      stpcnt2            = stpcnt2
      p_tot1             = p_tot2
      c_tot1             = c_tot1
      bcl1               = bcl1
      bc1                = bc1
      xl1                = xl1
      ls1                = ls1
    IMPORTING
      job_output_info    = w_return " This will have all output
    TABLES
      it_sf1             = it_sf11
      it_sf2             = it_sf12
      it_sf3             = it_sf13
      it_sf4             = it_sf14
      it_sf5             = it_sf15
*     itab_division      = itab_division
*     itab_storage       = itab_storage
*     itab_pa0002        = itab_pa0002
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.


  i_otf[] = w_return-otfdata[].

* Import Binary file and filesize
  CALL FUNCTION 'CONVERT_OTF'
    EXPORTING
      format                = 'PDF'
      max_linewidth         = 132
    IMPORTING
      bin_filesize          = v_len_in
      bin_file              = i_xstring   " This is NOT Binary. This is Hexa
    TABLES
      otf                   = i_otf
      lines                 = i_tline
    EXCEPTIONS
      err_max_linewidth     = 1
      err_format            = 2
      err_conv_not_possible = 3
      OTHERS                = 4.
* Sy-subrc check not checked



*  * Convert Hexa String to Binary format
  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer     = i_xstring
    TABLES
      binary_tab = i_objbin[].
* Sy-subrc check not required.

*    DATA: IN_MAILID TYPE AD_SMTPADR.

* Begin of sending email to multiple users
* If business want email to be sent to all users at one time, it can be done

* For now we do not want to send 1 email to multiple users
* Mail has to be sent one email at a time

*  IF P2 EQ 'X'.
*
*      CLEAR IN_MAILID.
*  IN_MAILID = 'JYOTSNA@BLUECROSSLABS.COM'.
  in_mailid = uemail.
  PERFORM send_mail USING in_mailid .

  CLEAR : it_sf11,wa_sf11,it_sf12,wa_sf12,it_sf13,wa_sf13,it_sf14,wa_sf14.

  CLEAR : zonename,  regename, reghqdesc,regjoindt, regshort, regnet ,regtargt1,regstp1,c_bcl1, c_bc1,c_xl1,
    c_ls1 , p_bcl1 ,p_bc1,p_xl1,p_ls1,stpcnt2,p_tot1, c_tot1 ,bcl1,bc1,xl1,ls1.



*  ENDLOOP.

  CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.
*  CALL FUNCTION 'SSF_CLOSE'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FORM1EM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM form1em .
*  BREAK-POINT.
  SORT it_tac7 BY reg zm rm ZZ_HQDESC.
  CLEAR : rmtot,rmtar.
  CLEAR : stpcnt1,stpcnt2.
  LOOP AT it_tad2 INTO wa_tad2.
*     WHERE REG EQ WA_CHECK-REG.
    wa_sf11-reg = wa_tad2-reg.
    wa_sf11-zm = wa_tad2-zm.
    wa_sf11-rm = wa_tad2-rm.
    wa_sf11-bzirk = wa_tad2-bzirk.
    wa_sf11-div = wa_tad2-div.
    READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_tad2-reg zm = wa_tad2-zm rm = wa_tad2-rm bzirk = wa_tad2-bzirk.
    IF sy-subrc EQ 0.
      wa_sf11-ename = wa_tac7-ename.
      IF wa_sf11-ename EQ space.
        wa_sf11-ename = 'VACANT'.
      ENDIF.
      wa_sf11-zz_hqdesc = wa_tac7-zz_hqdesc.
      CONCATENATE wa_tac7-begda+4(2) '/ ' wa_tac7-begda+0(4) INTO wa_sf11-joindt.
      wa_sf11-short = wa_tac7-short.
    ENDIF.
***********************************

*    CLEAR : DCOUNT,BC,BCL,LS,XL.
*    READ TABLE IT_TAD2 INTO WA_TAD2 WITH KEY BZIRK = WA_TAD2-BZIRK SPART = '50'.
*    IF SY-SUBRC EQ 0.
*      BC = 1.
*      DCOUNT = DCOUNT + 1.
*    ENDIF.
*    READ TABLE IT_TAD2 INTO WA_TAD2 WITH KEY BZIRK = WA_TAD2-BZIRK  SPART = '60'.
*    IF SY-SUBRC EQ 0.
*      XL = 1.
*      DCOUNT = DCOUNT + 1.
*    ENDIF.
*    READ TABLE IT_TAD2 INTO WA_TAD2 WITH KEY BZIRK = WA_TAD2-BZIRK SPART = '70'.
*    IF SY-SUBRC EQ 0.
*      LS = 1.
*      DCOUNT = DCOUNT + 1.
*    ENDIF.
*
*    IF DCOUNT GT 1.
*      BCL = 1.
*    ENDIF.
*
*    IF BCL EQ 1.
*      DIV = 'BCL'.
*    ELSEIF BC EQ 1.
*      DIV = 'BC'.
*    ELSEIF XL EQ 1.
*      DIV = 'XL'.
*    ELSEIF LS EQ 1.
*      DIV = 'LS'.
*    ENDIF.
*    WA_sf11-DIV = DIV.

*****************************************
*    READ TABLE IT_TAD2 INTO WA_TAD2 WITH KEY REG = WA_TAD2-REG RM = WA_TAD2-RM BZIRK = WA_TAD2-BZIRK DIV = DIV.
*    IF SY-SUBRC EQ 0.
*      WA_sf11-DIV = WA_TAD2-DIV.
    wa_sf11-net = wa_tad2-net.
    wa_sf11-targt1 = wa_tad2-targt1.
    CLEAR : stp.
    IF wa_tad2-targt GT 0.
      stp = ( wa_tad2-net / wa_tad2-targt ) * 100.
    ENDIF.
    wa_sf11-stp = stp.
    IF stp GE 100.
      stpcnt1 = stpcnt1 + 1.
    ENDIF.
    CONDENSE: wa_sf11-net,wa_sf11-targt1,wa_sf11-stp.
    wa_rm1-rm = wa_tad2-rm.
    wa_rm1-rmtot = wa_tad2-net.
    wa_rm1-rmtar = wa_tad2-targt1.
    COLLECT wa_rm1 INTO it_rm1.
    CLEAR wa_rm1.

    wa_zm1-zm = wa_tad2-zm.
    wa_zm1-zmtot = wa_tad2-net.
    wa_zm1-zmtar = wa_tad2-targt1.
    COLLECT wa_zm1 INTO it_zm1.
    CLEAR wa_zm1.

    wa_reg1-reg = wa_tad2-reg.
    wa_reg1-regtot = wa_tad2-net.
    wa_reg1-regtar = wa_tad2-targt1.
    COLLECT wa_reg1 INTO it_reg1.
    CLEAR wa_reg1.

*    ENDIF.
    COLLECT wa_sf11 INTO it_sf11.
    CLEAR wa_sf11.
******************************************rm*****************
    wa_sf12-rm = wa_tad2-rm.
    wa_sf12-zm = wa_tad2-zm.
    wa_sf12-reg = wa_tad2-reg.
    READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_tad2-reg zm = wa_tad2-zm rm = wa_tad2-rm bzirk = wa_tad2-bzirk.
    IF sy-subrc EQ 0.
      wa_sf12-ename = wa_tac7-rename.
      IF wa_sf12-ename EQ space.
        wa_sf12-ename = 'VACANT'.
      ENDIF.
      wa_sf12-zz_hqdesc = wa_tac7-rzz_hqdesc.
      CONCATENATE wa_tac7-rbegda+4(2) '/ ' wa_tac7-rbegda+0(4) INTO wa_sf12-joindt.
      wa_sf12-short = wa_tac7-rshort.
    ENDIF.
    COLLECT wa_sf12 INTO it_sf12.
    CLEAR wa_sf12.
**********************Zm rnds*******************************

    wa_sf13-zm = wa_tad2-zm.
    wa_sf13-reg = wa_tad2-reg.

    READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_tad2-reg zm = wa_tad2-zm rm = wa_tad2-rm bzirk = wa_tad2-bzirk.
    IF sy-subrc EQ 0.
      wa_sf13-ename = wa_tac7-dzename.
      IF wa_sf13-ename EQ space.
        wa_sf13-ename = 'VACANT'.
      ENDIF.
      wa_sf13-zz_hqdesc = wa_tac7-dzzz_hqdesc.
      CONCATENATE wa_tac7-dzbegda+4(2) '/ ' wa_tac7-dzbegda+0(4) INTO wa_sf13-joindt.
      wa_sf13-short = wa_tac7-dzshort.
    ENDIF.
    COLLECT wa_sf13 INTO it_sf13.
    CLEAR wa_sf13.

**********************reg rnds*******************************


    wa_sf14-reg = wa_tad2-reg.

    READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_tad2-reg zm = wa_tad2-zm rm = wa_tad2-rm bzirk = wa_tad2-bzirk.
    IF sy-subrc EQ 0.
      wa_sf14-ename = wa_tac7-zename.
      IF wa_sf14-ename EQ space.
        wa_sf14-ename = 'VACANT'.
      ENDIF.
      wa_sf14-zz_hqdesc = wa_tac7-zzz_hqdesc.
      CONCATENATE wa_tac7-zbegda+4(2) '/ ' wa_tac7-zbegda+0(4) INTO wa_sf14-joindt.
      wa_sf14-short = wa_tac7-zshort.
    ENDIF.
    COLLECT wa_sf14 INTO it_sf14.
    CLEAR wa_sf14.


  ENDLOOP.

  SORT it_sf11 BY reg zm rm bzirk.

  SORT it_sf12 BY reg zm rm.
  DELETE ADJACENT DUPLICATES FROM it_sf12 COMPARING reg zm rm.
  LOOP AT it_sf12 INTO wa_sf12.
    READ TABLE it_rm1 INTO wa_rm1 WITH KEY rm = wa_sf12-rm.
    IF sy-subrc EQ 0.
      wa_sf12-net = wa_rm1-rmtot.
      wa_sf12-targt1 = wa_rm1-rmtar.
      CLEAR: rstp.
      IF wa_rm1-rmtar GT 0.
        rstp = ( wa_rm1-rmtot / wa_rm1-rmtar ) * 100.
      ENDIF.
      wa_sf12-stp = rstp.
      CONDENSE : wa_sf12-net,wa_sf12-targt1,wa_sf12-stp.
      MODIFY it_sf12 FROM wa_sf12 TRANSPORTING net targt1 stp WHERE rm = wa_sf12-rm.
      CLEAR wa_sf12.
    ENDIF.
  ENDLOOP.

  SORT it_sf13 BY reg zm.
  DELETE ADJACENT DUPLICATES FROM it_sf13 COMPARING reg zm.

  LOOP AT it_sf13 INTO wa_sf13.
    READ TABLE it_zm1 INTO wa_zm1 WITH KEY zm = wa_sf13-zm.
    IF sy-subrc EQ 0.
      wa_sf13-net = wa_zm1-zmtot.
      wa_sf13-targt1 = wa_zm1-zmtar.
      CLEAR: rstp.
      rstp = ( wa_zm1-zmtot / wa_zm1-zmtar ) * 100.
      wa_sf13-stp = rstp.
      CONDENSE : wa_sf13-net,wa_sf13-targt1,wa_sf13-stp.
      MODIFY it_sf13 FROM wa_sf13 TRANSPORTING net targt1 stp WHERE zm = wa_sf13-zm.
      CLEAR wa_sf13.
    ENDIF.
  ENDLOOP.

  SORT it_sf14 BY reg.
  DELETE ADJACENT DUPLICATES FROM it_sf14 COMPARING reg.

  LOOP AT it_sf14 INTO wa_sf14.
    READ TABLE it_reg1 INTO wa_reg1 WITH KEY reg = wa_sf14-reg.
    IF sy-subrc EQ 0.
      wa_sf14-net = wa_reg1-regtot.
      wa_sf14-targt1 = wa_reg1-regtar.
      CLEAR: rstp.
      rstp = ( wa_reg1-regtot / wa_reg1-regtar ) * 100.
      wa_sf14-stp = rstp.
      CONDENSE : wa_sf14-net,wa_sf14-targt1,wa_sf14-stp.
      MODIFY it_sf14 FROM wa_sf14 TRANSPORTING net targt1 stp WHERE reg = wa_sf14-reg.
      CLEAR wa_sf14.
    ENDIF.
  ENDLOOP.


  LOOP AT it_sf14 INTO wa_sf14.
    CLEAR : c_bcl,c_tot,p_bcl, c_bc,p_bc,c_xl,p_xl,c_ls,p_ls,bcl1,xl1,ls1,bc1.
    wa_sf15-reg = wa_sf14-reg.

    READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_sf14-reg div = 'BCL'.
    IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
      c_bcl = wa_tad4-count.
      c_tot = c_tot + wa_tad4-count.
      READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_sf14-reg div = 'BCL'.
      IF sy-subrc EQ 0.
        p_bcl = wa_tad21-net / c_bcl.
*            P_TOT = P_TOT + P_BCL.
      ENDIF.
      bcl1 = 'Y'.
    ENDIF.
    wa_sf15-c_bcl = c_bcl.
    wa_sf15-p_bcl = p_bcl.
    wa_sf15-bcl = bcl1.

    READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_sf14-reg div = 'BC'.
    IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
      c_bc = wa_tad4-count.
      c_tot = c_tot + wa_tad4-count.
      READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_sf14-reg div = 'BC'.
      IF sy-subrc EQ 0.
        p_bc = wa_tad21-net / c_bc.
*            P_TOT = P_TOT + P_BCL.
      ENDIF.
      bc1 = 'Y'.
    ENDIF.

    wa_sf15-c_bc = c_bc.
    wa_sf15-p_bc = p_bc.
    wa_sf15-bc = bc1.

    READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_sf14-reg div = 'XL'.
    IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
      c_xl = wa_tad4-count.
      c_tot = c_tot + wa_tad4-count.
      READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_sf14-reg div = 'XL'.
      IF sy-subrc EQ 0.
        p_xl = wa_tad21-net / c_xl.
*            P_TOT = P_TOT + P_BCL.
      ENDIF.
      xl1 = 'Y'.
    ENDIF.
    wa_sf15-c_xl = c_xl.
    wa_sf15-p_xl = p_xl.
    wa_sf15-xl = xl1.

    READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_sf14-reg div = 'LS'.
    IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
      c_ls = wa_tad4-count.
      c_tot = c_tot + wa_tad4-count.
      READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_sf14-reg div = 'LS'.
      IF sy-subrc EQ 0.
        p_ls = wa_tad21-net / c_ls.
*            P_TOT = P_TOT + P_BCL.
      ENDIF.
      ls1 = 'Y'.
    ENDIF.

    wa_sf15-c_ls = c_ls.
    wa_sf15-p_ls = p_ls.
    wa_sf15-ls = ls1.

    CLEAR : p_tot1,p_tot2.
    READ TABLE it_reg1 INTO wa_reg1 WITH KEY reg = wa_sf14-reg.
    IF sy-subrc EQ 0.
      p_tot1 = wa_reg1-regtot / c_tot.
    ENDIF.
    wa_sf15-c_tot = c_tot.
    wa_sf15-p_tot = p_tot1.
    wa_sf15-stpcnt = stpcnt1.
    CONDENSE : wa_sf15-c_bcl,wa_sf15-c_bc,wa_sf15-c_xl,wa_sf15-c_ls,wa_sf15-p_bcl,wa_sf15-p_bc,wa_sf15-p_xl,wa_sf15-p_ls,
    wa_sf15-bcl,wa_sf15-bc,wa_sf15-xl,wa_sf15-ls,wa_sf15-c_tot,wa_sf15-p_tot,wa_sf15-stpcnt.

    COLLECT wa_sf15 INTO it_sf15.
    CLEAR wa_sf15.
    CLEAR :  c_bcl,c_bc,c_xl,c_ls,p_bcl,p_bc,p_xl,p_ls,bcl,bc,xl,ls,c_tot,p_tot,stpcnt1,p_tot1,c_tot,p_tot1,p_tot2.
  ENDLOOP.



  LOOP AT it_sf14 INTO wa_sf14.
    SELECT SINGLE * FROM zoneseq WHERE zone_dist EQ wa_sf14-reg.
    IF sy-subrc EQ 0.
      wa_sf14-seq = zoneseq-seq.
      MODIFY it_sf14 FROM wa_sf14 TRANSPORTING seq.
      CLEAR wa_sf14.
    ENDIF.
  ENDLOOP.
  SORT it_sf14 BY seq.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FORM2EM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM form2em .
  READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_check-reg.
  IF sy-subrc EQ 0.
    regename = wa_tac7-zename.
    IF regename EQ space.
      regename = 'VACANT'.
    ENDIF.
    reghqdesc = wa_tac7-zzz_hqdesc.
    CONCATENATE wa_tac7-zbegda+4(2) '/ ' wa_tac7-zbegda+0(4) INTO regjoindt.
    regshort = wa_tac7-zshort.
  ENDIF.

  READ TABLE it_reg1 INTO wa_reg1 WITH KEY reg = wa_check-reg.
  IF sy-subrc EQ 0.
    regnet = wa_reg1-regtot.
    regtargt1 = wa_reg1-regtar.
    CLEAR: regstp.
    regstp = ( wa_reg1-regtot / wa_reg1-regtar ) * 100.
    regstp1 = regstp.
    CONDENSE : regnet,regtargt1,regstp1.
  ENDIF.
  CLEAR : c_bcl,c_tot,p_bcl, c_bc,p_bc,c_xl,p_xl,c_ls,p_ls.
  READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_check-reg div = 'BCL'.
  IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
    c_bcl = wa_tad4-count.
    c_tot = c_tot + wa_tad4-count.
    READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_check-reg div = 'BCL'.
    IF sy-subrc EQ 0.
      p_bcl = wa_tad21-net / c_bcl.
*            P_TOT = P_TOT + P_BCL.
    ENDIF.
    bcl1 = 'Y'.
  ENDIF.
  READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_check-reg div = 'BC'.
  IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
    c_bc = wa_tad4-count.
    c_tot = c_tot + wa_tad4-count.
    READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_check-reg div = 'BC'.
    IF sy-subrc EQ 0.
      p_bc = wa_tad21-net / c_bc.
*            P_TOT = P_TOT + P_BCL.
    ENDIF.
    bc1 = 'Y'.
  ENDIF.
  READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_check-reg div = 'XL'.
  IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
    c_xl = wa_tad4-count.
    c_tot = c_tot + wa_tad4-count.
    READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_check-reg div = 'XL'.
    IF sy-subrc EQ 0.
      p_xl = wa_tad21-net / c_xl.
*            P_TOT = P_TOT + P_BCL.
    ENDIF.
    xl1 = 'Y'.
  ENDIF.
  READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_check-reg div = 'LS'.
  IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
    c_ls = wa_tad4-count.
    c_tot = c_tot + wa_tad4-count.
    READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_check-reg div = 'LS'.
    IF sy-subrc EQ 0.
      p_ls = wa_tad21-net / c_ls.
*            P_TOT = P_TOT + P_BCL.
    ENDIF.
    ls1 = 'Y'.
  ENDIF.
  CLEAR : p_tot1,p_tot2.
  READ TABLE it_reg1 INTO wa_reg1 WITH KEY reg = wa_check-reg.
  IF sy-subrc EQ 0.
    p_tot1 = wa_reg1-regtot / c_tot.
  ENDIF.

  c_bcl1              = c_bcl.
  c_bc1               = c_bc.
  c_xl1               = c_xl.
  c_ls1               = c_ls.
  p_bcl1              = p_bcl.
  p_bc1               = p_bc.
  p_xl1               = p_xl.
  p_ls1               = p_ls.
  c_tot1 = c_tot.
  stpcnt2 = stpcnt1.
  p_tot2 = p_tot1.
  CONDENSE : c_bcl1,c_bc1,c_xl1,c_ls1,p_bcl1,p_bc1,p_xl1,p_ls1,stpcnt2,c_tot1,p_tot2.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SFFORMGM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sfformgm .


  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZSR9_A2'
*     FORMNAME           = 'ZSR9_9'
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
      fm_name            = v_fm
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.

*  *   * Set the control parameter
  w_ctrlop-getotf = abap_true.
  w_ctrlop-no_dialog = abap_true.
  w_compop-tdnoprev = abap_true.
  w_ctrlop-preview = space.
  w_compop-tddest = 'LOCL'.

*  CONTROL-NO_OPEN   = 'X'.
*  CONTROL-NO_CLOSE  = 'X'.
*
*
*  CALL FUNCTION 'SSF_OPEN'
*    EXPORTING
*      CONTROL_PARAMETERS = CONTROL.
*  SORT IT_CHECK BY REG.

*  LOOP AT IT_CHECK INTO WA_CHECK.
*    BREAK-POINT .
  CLEAR : zonename.
  zonename = wa_check-zonename.
*    WRITE : / 'ZONE',ZONENAME.
  CLEAR : it_sf11,wa_sf11,it_sf12,wa_sf12,it_sf13,wa_sf13,it_sf14,wa_sf14.
*    PERFORM FORM1.
*    PERFORM FORM2.
  PERFORM form1em.
*  PERFORM FORM2EM.



  LOOP AT it_sf14 INTO wa_sf14.
    READ TABLE it_gm1 INTO wa_gm1 WITH KEY reg = wa_sf14-reg gm = wa_gm2-gm.
    IF sy-subrc EQ 4.
      DELETE it_sf14 WHERE reg = wa_sf14-reg.
    ENDIF.
  ENDLOOP.

  CALL FUNCTION v_fm
    EXPORTING
      control_parameters = w_ctrlop
      output_options     = w_compop
      user_settings      = abap_true
      format             = format
      zonename           = zonename
      regename           = regename
      reghqdesc          = reghqdesc
      regjoindt          = regjoindt
      regshort           = regshort
      regnet             = regnet
      regtargt1          = regtargt1
      regstp1            = regstp1
      s_budat1           = s_budat1
      s_budat2           = s_budat2
      c_bcl1             = c_bcl1
      c_bc1              = c_bc1
      c_xl1              = c_xl1
      c_ls1              = c_ls1
      p_bcl1             = p_bcl1
      p_bc1              = p_bc1
      p_xl1              = p_xl1
      p_ls1              = p_ls1
      stpcnt2            = stpcnt2
      p_tot1             = p_tot2
      c_tot1             = c_tot1
      bcl1               = bcl1
      bc1                = bc1
      xl1                = xl1
      ls1                = ls1
    IMPORTING
      job_output_info    = w_return " This will have all output
    TABLES
      it_sf1             = it_sf11
      it_sf2             = it_sf12
      it_sf3             = it_sf13
      it_sf4             = it_sf14
      it_sf5             = it_sf15
*     itab_division      = itab_division
*     itab_storage       = itab_storage
*     itab_pa0002        = itab_pa0002
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.


  i_otf[] = w_return-otfdata[].

* Import Binary file and filesize
  CALL FUNCTION 'CONVERT_OTF'
    EXPORTING
      format                = 'PDF'
      max_linewidth         = 132
    IMPORTING
      bin_filesize          = v_len_in
      bin_file              = i_xstring   " This is NOT Binary. This is Hexa
    TABLES
      otf                   = i_otf
      lines                 = i_tline
    EXCEPTIONS
      err_max_linewidth     = 1
      err_format            = 2
      err_conv_not_possible = 3
      OTHERS                = 4.
* Sy-subrc check not checked



*  * Convert Hexa String to Binary format
  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer     = i_xstring
    TABLES
      binary_tab = i_objbin[].
* Sy-subrc check not required.

*    DATA: IN_MAILID TYPE AD_SMTPADR.

* Begin of sending email to multiple users
* If business want email to be sent to all users at one time, it can be done

* For now we do not want to send 1 email to multiple users
* Mail has to be sent one email at a time

*  IF P2 EQ 'X'.
*
*      CLEAR IN_MAILID.
*  IN_MAILID = 'JYOTSNA@BLUECROSSLABS.COM'.
  in_mailid =  wa_gm2-usrid_long.
*  in_mailid = uemail.
  PERFORM send_mail USING in_mailid .

  CLEAR : it_sf11,wa_sf11,it_sf12,wa_sf12,it_sf13,wa_sf13,it_sf14,wa_sf14.

  CLEAR : zonename,  regename, reghqdesc,regjoindt, regshort, regnet ,regtargt1,regstp1,c_bcl1, c_bc1,c_xl1,
    c_ls1 , p_bcl1 ,p_bc1,p_xl1,p_ls1,stpcnt2,p_tot1, c_tot1 ,bcl1,bc1,xl1,ls1.



*  ENDLOOP.

  CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  R12SFFORMDET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  R12SFFORMEM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM r12sfformem .
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
*     FORMNAME           = 'ZSR9_S5'
*     formname           = 'ZSR9_S51'
*     formname           = 'ZSR9_S52'
      formname           = 'ZSR9_S53'
*     FORMNAME           = 'ZSR9_9'
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
      fm_name            = v_fm
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.

**  *   * Set the control parameter
*  W_CTRLOP-GETOTF = ABAP_TRUE.
*  W_CTRLOP-NO_DIALOG = ABAP_TRUE.
*  W_COMPOP-TDNOPREV = ABAP_TRUE.
*  W_CTRLOP-PREVIEW = SPACE.
*  W_COMPOP-TDDEST = 'LOCL'.

  control-no_open   = 'X'.
  control-no_close  = 'X'.


  CALL FUNCTION 'SSF_OPEN'
    EXPORTING
      control_parameters = control.
*  SORT IT_CHECK BY REG.

*  LOOP AT IT_CHECK INTO WA_CHECK.
*    BREAK-POINT .
  CLEAR : zonename.
  zonename = wa_check-zonename.
*    WRITE : / 'ZONE',ZONENAME.
  CLEAR : it_sf11,wa_sf11,it_sf12,wa_sf12,it_sf13,wa_sf13,it_sf14,wa_sf14.
*    PERFORM FORM1.
*    PERFORM FORM2.
*  PERFORM FORM1EM.
  PERFORM r12form1em.

  PERFORM form1emr12.
*  PERFORM FORM2EM.

  wa_sum1-form1 = 'F'.
  COLLECT wa_sum1 INTO it_sum1.
  CLEAR wa_sum1.
  wa_sum1-form1 = 'S'.
  COLLECT wa_sum1 INTO it_sum1.
  CLEAR wa_sum1.

  SORT it_sum1 BY form1.
  DELETE ADJACENT DUPLICATES FROM it_sum1 COMPARING form1.
*  break-point .
  PERFORM subtot.
  LOOP AT it_sum1 INTO wa_sum1.
    CLEAR :  sform1.
    sform1 = wa_sum1-form1.
    CALL FUNCTION v_fm
      EXPORTING
        control_parameters = control
        user_settings      = 'X'
        output_options     = w_ssfcompop
*       CONTROL_PARAMETERS = W_CTRLOP
*       OUTPUT_OPTIONS     = W_COMPOP
*       USER_SETTINGS      = ABAP_TRUE
        format             = format
        zonename           = zonename
        regename           = regename
        reghqdesc          = reghqdesc
        regjoindt          = regjoindt
        regshort           = regshort
        regnet             = regnet
        regtargt1          = regtargt1
        regstp1            = regstp1
        s_budat1           = s_budat1
        s_budat2           = s_budat2
        c_bcl1             = c_bcl1
        c_bc1              = c_bc1
        c_xl1              = c_xl1
        c_ls1              = c_ls1
        p_bcl1             = p_bcl1
        p_bc1              = p_bc1
        p_xl1              = p_xl1
        p_ls1              = p_ls1
        stpcnt2            = stpcnt2
        p_tot1             = p_tot2
        c_tot1             = c_tot1
        bcl1               = bcl1
        bc1                = bc1
        xl1                = xl1
        ls1                = ls1
        sform1             = sform1
        bcd1               = bcd1
        bcd2               = bcd2
        xld1               = xld1
        xld2               = xld2
        lsd1               = lsd1
        lsd2               = lsd2
        totc1              = totc1
        totc2              = totc2
        acdiv1             = acdiv1
        bcdiv1             = bcdiv1
        xldiv1             = xldiv1
        lsdiv1             = lsdiv1
        totdiv1            = totdiv1
        bd3                = bd3
        xd3                = xd3
        ld3                = ld3
        ad3                = ad3
        bd4                = bd4
        xd4                = xd4
        ld4                = ld4
        ad4                = ad4
        bd5                = bd5
        xd5                = xd5
        ld5                = ld5
        ad5                = ad5
*    IMPORTING
*       JOB_OUTPUT_INFO    = W_RETURN " This will have all output
      TABLES
        it_sf1             = it_sf11
        it_sf2             = it_sf12
        it_sf3             = it_sf13
        it_sf4             = it_sf14
        it_sf5             = it_sf15
*       it_sf6             = it_sf16
        it_sf6             = it_ntab2
        it_sf7             = it_sf17
        it_sf8             = it_sf18
*       itab_division      = itab_division
*       itab_storage       = itab_storage
*       itab_pa0002        = itab_pa0002
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.


*  I_OTF[] = W_RETURN-OTFDATA[].
*
** Import Binary file and filesize
*  CALL FUNCTION 'CONVERT_OTF'
*    EXPORTING
*      FORMAT                = 'PDF'
*      MAX_LINEWIDTH         = 132
*    IMPORTING
*      BIN_FILESIZE          = V_LEN_IN
*      BIN_FILE              = I_XSTRING   " This is NOT Binary. This is Hexa
*    TABLES
*      OTF                   = I_OTF
*      LINES                 = I_TLINE
*    EXCEPTIONS
*      ERR_MAX_LINEWIDTH     = 1
*      ERR_FORMAT            = 2
*      ERR_CONV_NOT_POSSIBLE = 3
*      OTHERS                = 4.
** Sy-subrc check not checked
*
*
*
**  * Convert Hexa String to Binary format
*  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
*    EXPORTING
*      BUFFER     = I_XSTRING
*    TABLES
*      BINARY_TAB = I_OBJBIN[].
** Sy-subrc check not required.
*
**    DATA: IN_MAILID TYPE AD_SMTPADR.
*
** Begin of sending email to multiple users
** If business want email to be sent to all users at one time, it can be done
*
** For now we do not want to send 1 email to multiple users
** Mail has to be sent one email at a time
*
**  IF P2 EQ 'X'.
**
**      CLEAR IN_MAILID.
**  IN_MAILID = 'JYOTSNA@BLUECROSSLABS.COM'.
*  IN_MAILID = UEMAIL.
*  PERFORM SEND_MAIL USING IN_MAILID .

    CLEAR : it_sf11,wa_sf11,it_sf12,wa_sf12,it_sf13,wa_sf13,it_sf14,wa_sf14.

    CLEAR : zonename,  regename, reghqdesc,regjoindt, regshort, regnet ,regtargt1,regstp1,c_bcl1, c_bc1,c_xl1,
      c_ls1 , p_bcl1 ,p_bc1,p_xl1,p_ls1,stpcnt2,p_tot1, c_tot1 ,bcl1,bc1,xl1,ls1.
*  CLEAR:  SFORM1,BCD1,BCD2, XLD1,XLD2,LSD1,LSD2, TOTC1,TOTC2,ACDIV1,BCDIV1,XLDIV1,LSDIV1,TOTDIV1,BD3,XD3,LD3,AD3,BD4, XD4,LD4,AD4,BD5,XD5,LD5,AD5.



  ENDLOOP.

  CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.
  CALL FUNCTION 'SSF_CLOSE'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  R12FORM1EM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM r12form1em .
*  BREAK-POINT.
  SORT it_tac7 BY reg zm rm ZZ_HQDESC.
  CLEAR : rmtot,rmtar.
  CLEAR : stpcnt1,stpcnt2.
  CLEAR :  bcdt1,xldt1,lsdt1.
*  BREAK-POINT.
  LOOP AT it_tad2 INTO wa_tad2.
*     WHERE REG EQ WA_CHECK-REG.
    wa_sf11-reg = wa_tad2-reg.
    wa_sf11-zm = wa_tad2-zm.
    wa_sf11-rm = wa_tad2-rm.
    wa_sf11-bzirk = wa_tad2-bzirk.
    wa_sf11-div = wa_tad2-div.
    READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_tad2-reg zm = wa_tad2-zm rm = wa_tad2-rm bzirk = wa_tad2-bzirk.
    IF sy-subrc EQ 0.
      wa_sf11-ename = wa_tac7-ename.
      IF wa_sf11-ename EQ space.
        wa_sf11-ename = 'VACANT'.
      ENDIF.
      wa_sf11-zz_hqdesc = wa_tac7-zz_hqdesc.
      CONCATENATE wa_tac7-begda+4(2) '/ ' wa_tac7-begda+0(4) INTO wa_sf11-joindt.
      wa_sf11-short = wa_tac7-short.
    ENDIF.
***********************************

*    CLEAR : DCOUNT,BC,BCL,LS,XL.
*    READ TABLE IT_TAD2 INTO WA_TAD2 WITH KEY BZIRK = WA_TAD2-BZIRK SPART = '50'.
*    IF SY-SUBRC EQ 0.
*      BC = 1.
*      DCOUNT = DCOUNT + 1.
*    ENDIF.
*    READ TABLE IT_TAD2 INTO WA_TAD2 WITH KEY BZIRK = WA_TAD2-BZIRK  SPART = '60'.
*    IF SY-SUBRC EQ 0.
*      XL = 1.
*      DCOUNT = DCOUNT + 1.
*    ENDIF.
*    READ TABLE IT_TAD2 INTO WA_TAD2 WITH KEY BZIRK = WA_TAD2-BZIRK SPART = '70'.
*    IF SY-SUBRC EQ 0.
*      LS = 1.
*      DCOUNT = DCOUNT + 1.
*    ENDIF.
*
*    IF DCOUNT GT 1.
*      BCL = 1.
*    ENDIF.
*
*    IF BCL EQ 1.
*      DIV = 'BCL'.
*    ELSEIF BC EQ 1.
*      DIV = 'BC'.
*    ELSEIF XL EQ 1.
*      DIV = 'XL'.
*    ELSEIF LS EQ 1.
*      DIV = 'LS'.
*    ENDIF.
*    WA_sf11-DIV = DIV.

*****************************************
*    READ TABLE IT_TAD2 INTO WA_TAD2 WITH KEY REG = WA_TAD2-REG RM = WA_TAD2-RM BZIRK = WA_TAD2-BZIRK DIV = DIV.
*    IF SY-SUBRC EQ 0.
*      WA_sf11-DIV = WA_TAD2-DIV.
    wa_sf11-net = wa_tad2-net.
    wa_sf11-targt1 = wa_tad2-targt1.

    IF wa_tad2-net GE wa_tad2-targt1.
      IF wa_tad2-div EQ 'BC'.
        bcdt1 = bcdt1 + 1.
      ELSEIF wa_tad2-div EQ 'XL'.
        xldt1 = xldt1 + 1.
      ELSEIF wa_tad2-div EQ 'LS'.
        lsdt1 = lsdt1 + 1.
      ENDIF.
    ENDIF.

    CLEAR : stp.
    IF wa_tad2-targt GT 0.
      stp = ( wa_tad2-net / wa_tad2-targt ) * 100.
    ENDIF.
    wa_sf11-stp = stp.
    IF stp GE 100.
      stpcnt1 = stpcnt1 + 1.
    ENDIF.
    CONDENSE: wa_sf11-net,wa_sf11-targt1,wa_sf11-stp.
    wa_rm1-rm = wa_tad2-rm.
    wa_rm1-rmtot = wa_tad2-net.
    wa_rm1-rmtar = wa_tad2-targt1.
    COLLECT wa_rm1 INTO it_rm1.
    CLEAR wa_rm1.

    wa_zm1-zm = wa_tad2-zm.
    wa_zm1-zmtot = wa_tad2-net.
    wa_zm1-zmtar = wa_tad2-targt1.
    COLLECT wa_zm1 INTO it_zm1.
    CLEAR wa_zm1.

    wa_reg1-reg = wa_tad2-reg.
    wa_reg1-regtot = wa_tad2-net.
    wa_reg1-regtar = wa_tad2-targt1.
    COLLECT wa_reg1 INTO it_reg1.
    CLEAR wa_reg1.

*    ENDIF.
    COLLECT wa_sf11 INTO it_sf11.
    CLEAR wa_sf11.
******************************************rm*****************
    wa_sf12-rm = wa_tad2-rm.
    wa_sf12-zm = wa_tad2-zm.
    wa_sf12-reg = wa_tad2-reg.
    READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_tad2-reg zm = wa_tad2-zm rm = wa_tad2-rm bzirk = wa_tad2-bzirk.
    IF sy-subrc EQ 0.
      wa_sf12-ename = wa_tac7-rename.
      IF wa_sf12-ename EQ space.
        wa_sf12-ename = 'VACANT'.
      ENDIF.
      wa_sf12-zz_hqdesc = wa_tac7-rzz_hqdesc.
      CONCATENATE wa_tac7-rbegda+4(2) '/ ' wa_tac7-rbegda+0(4) INTO wa_sf12-joindt.
      wa_sf12-short = wa_tac7-rshort.
    ENDIF.
    COLLECT wa_sf12 INTO it_sf12.
    CLEAR wa_sf12.
**********************Zm rnds*******************************

    wa_sf13-zm = wa_tad2-zm.
    wa_sf13-reg = wa_tad2-reg.

    READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_tad2-reg zm = wa_tad2-zm rm = wa_tad2-rm bzirk = wa_tad2-bzirk.
    IF sy-subrc EQ 0.
      wa_sf13-ename = wa_tac7-dzename.
      IF wa_sf13-ename EQ space.
        wa_sf13-ename = 'VACANT'.
      ENDIF.
      wa_sf13-zz_hqdesc = wa_tac7-dzzz_hqdesc.
      CONCATENATE wa_tac7-dzbegda+4(2) '/ ' wa_tac7-dzbegda+0(4) INTO wa_sf13-joindt.
      wa_sf13-short = wa_tac7-dzshort.
    ENDIF.
    COLLECT wa_sf13 INTO it_sf13.
    CLEAR wa_sf13.

**********************reg rnds*******************************


    wa_sf14-reg = wa_tad2-reg.

    READ TABLE it_tac7 INTO wa_tac7 WITH KEY reg = wa_tad2-reg zm = wa_tad2-zm rm = wa_tad2-rm bzirk = wa_tad2-bzirk.
    IF sy-subrc EQ 0.
      wa_sf14-ename = wa_tac7-zename.
      IF wa_sf14-ename EQ space.
        wa_sf14-ename = 'VACANT'.
      ENDIF.
      wa_sf14-zz_hqdesc = wa_tac7-zzz_hqdesc.
      CONCATENATE wa_tac7-zbegda+4(2) '/ ' wa_tac7-zbegda+0(4) INTO wa_sf14-joindt.
      wa_sf14-short = wa_tac7-zshort.
    ENDIF.
    COLLECT wa_sf14 INTO it_sf14.
    CLEAR wa_sf14.


  ENDLOOP.

  bcdiv1 = bcdt1.
  xldiv1 = xldt1.
  lsdiv1 = lsdt1.
  tdiv1 = bcdt1 + xldt1 + lsdt1.
  totdiv1 = tdiv1.
  CONDENSE : bcdiv1,xldiv1,lsdiv1,totdiv1.

  SORT it_sf11 BY reg zm rm bzirk.

  SORT it_sf12 BY reg zm rm.
  DELETE ADJACENT DUPLICATES FROM it_sf12 COMPARING reg zm rm.
  LOOP AT it_sf12 INTO wa_sf12.
    READ TABLE it_rm1 INTO wa_rm1 WITH KEY rm = wa_sf12-rm.
    IF sy-subrc EQ 0.
      wa_sf12-net = wa_rm1-rmtot.
      wa_sf12-targt1 = wa_rm1-rmtar.
      CLEAR: rstp.
      IF wa_rm1-rmtar GT 0.
        rstp = ( wa_rm1-rmtot / wa_rm1-rmtar ) * 100.
      ENDIF.
      wa_sf12-stp = rstp.
      CONDENSE : wa_sf12-net,wa_sf12-targt1,wa_sf12-stp.
      MODIFY it_sf12 FROM wa_sf12 TRANSPORTING net targt1 stp WHERE rm = wa_sf12-rm.
      CLEAR wa_sf12.
    ENDIF.
  ENDLOOP.

  SORT it_sf13 BY reg zm.
  DELETE ADJACENT DUPLICATES FROM it_sf13 COMPARING reg zm.

  LOOP AT it_sf13 INTO wa_sf13.
    READ TABLE it_zm1 INTO wa_zm1 WITH KEY zm = wa_sf13-zm.
    IF sy-subrc EQ 0.
      wa_sf13-net = wa_zm1-zmtot.
      wa_sf13-targt1 = wa_zm1-zmtar.
      CLEAR: rstp.
      IF wa_zm1-zmtar GT 0.
        rstp = ( wa_zm1-zmtot / wa_zm1-zmtar ) * 100.
      ENDIF.
      wa_sf13-stp = rstp.
      CONDENSE : wa_sf13-net,wa_sf13-targt1,wa_sf13-stp.
      MODIFY it_sf13 FROM wa_sf13 TRANSPORTING net targt1 stp WHERE zm = wa_sf13-zm.
      CLEAR wa_sf13.
    ENDIF.
  ENDLOOP.

  SORT it_sf14 BY reg.
  DELETE ADJACENT DUPLICATES FROM it_sf14 COMPARING reg.

  LOOP AT it_sf14 INTO wa_sf14.
    READ TABLE it_reg1 INTO wa_reg1 WITH KEY reg = wa_sf14-reg.
    IF sy-subrc EQ 0.
      wa_sf14-net = wa_reg1-regtot.
      wa_sf14-targt1 = wa_reg1-regtar.
      CLEAR: rstp.
      IF wa_reg1-regtar GT 0.
        rstp = ( wa_reg1-regtot / wa_reg1-regtar ) * 100.
      ENDIF.
      wa_sf14-stp = rstp.
      CONDENSE : wa_sf14-net,wa_sf14-targt1,wa_sf14-stp.
      MODIFY it_sf14 FROM wa_sf14 TRANSPORTING net targt1 stp WHERE reg = wa_sf14-reg.
      CLEAR wa_sf14.
    ENDIF.
  ENDLOOP.

*  BREAK-POINT.
  LOOP AT it_sf14 INTO wa_sf14.
    CLEAR : c_bcl,c_tot,p_bcl, c_bc,p_bc,c_xl,p_xl,c_ls,p_ls,bcl1,xl1,ls1,bc1.
    wa_sf15-reg = wa_sf14-reg.

    READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_sf14-reg div = 'BCL'.
    IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
      c_bcl = wa_tad4-count.
      c_tot = c_tot + wa_tad4-count.
      READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_sf14-reg div = 'BCL'.
      IF sy-subrc EQ 0.
        p_bcl = wa_tad21-net / c_bcl.
*            P_TOT = P_TOT + P_BCL.
      ENDIF.
      bcl1 = 'Y'.
    ENDIF.
    wa_sf15-c_bcl = c_bcl.
    wa_sf15-p_bcl = p_bcl.
    wa_sf15-bcl = bcl1.

    READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_sf14-reg div = 'BC'.
    IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
      c_bc = wa_tad4-count.
      c_tot = c_tot + wa_tad4-count.
      READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_sf14-reg div = 'BC'.
      IF sy-subrc EQ 0.
        p_bc = wa_tad21-net / c_bc.
*            P_TOT = P_TOT + P_BCL.
      ENDIF.
      bc1 = 'Y'.
    ENDIF.

    wa_sf15-c_bc = c_bc.
    wa_sf15-p_bc = p_bc.
    wa_sf15-bc = bc1.

    READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_sf14-reg div = 'XL'.
    IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
      c_xl = wa_tad4-count.
      c_tot = c_tot + wa_tad4-count.
      READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_sf14-reg div = 'XL'.
      IF sy-subrc EQ 0.
        p_xl = wa_tad21-net / c_xl.
*            P_TOT = P_TOT + P_BCL.
      ENDIF.
      xl1 = 'Y'.
    ENDIF.
    wa_sf15-c_xl = c_xl.
    wa_sf15-p_xl = p_xl.
    wa_sf15-xl = xl1.

    READ TABLE it_tad4 INTO wa_tad4 WITH  KEY reg = wa_sf14-reg div = 'LS'.
    IF sy-subrc EQ 0 AND wa_tad4-count NE 0.
      c_ls = wa_tad4-count.
      c_tot = c_tot + wa_tad4-count.
      READ TABLE it_tad21 INTO wa_tad21 WITH KEY reg = wa_sf14-reg div = 'LS'.
      IF sy-subrc EQ 0.
        p_ls = wa_tad21-net / c_ls.
*            P_TOT = P_TOT + P_BCL.
      ENDIF.
      ls1 = 'Y'.
    ENDIF.

    wa_sf15-c_ls = c_ls.
    wa_sf15-p_ls = p_ls.
    wa_sf15-ls = ls1.

    CLEAR : p_tot1,p_tot2.
    READ TABLE it_reg1 INTO wa_reg1 WITH KEY reg = wa_sf14-reg.
    IF sy-subrc EQ 0.
      p_tot1 = wa_reg1-regtot / c_tot.
    ENDIF.
    wa_sf15-c_tot = c_tot.
    wa_sf15-p_tot = p_tot1.
    wa_sf15-stpcnt = stpcnt1.
*******************************add sm***********************
    SELECT SINGLE * FROM zdsmter WHERE zmonth EQ month AND zyear EQ year AND bzirk EQ wa_sf14-reg.
    IF sy-subrc EQ 0.
      wa_sm1-sm = zdsmter-zdsm.
      wa_sm1-reg = wa_sf14-reg.
      wa_sm1-c_tot = c_tot.
*      WA_SM1-P_TOT = P_TOT.
      READ TABLE it_reg1 INTO wa_reg1 WITH KEY reg = wa_sf14-reg.
      IF sy-subrc EQ 0.
        wa_sm1-net = wa_reg1-regtot.
        wa_sm1-targt1 = wa_reg1-regtar.
      ENDIF.
      COLLECT wa_sm1 INTO it_sm1.
      CLEAR wa_sm1.
    ENDIF.
********************************************************************
    CONDENSE : wa_sf15-c_bcl,wa_sf15-c_bc,wa_sf15-c_xl,wa_sf15-c_ls,wa_sf15-p_bcl,wa_sf15-p_bc,wa_sf15-p_xl,wa_sf15-p_ls,
    wa_sf15-bcl,wa_sf15-bc,wa_sf15-xl,wa_sf15-ls,wa_sf15-c_tot,wa_sf15-p_tot,wa_sf15-stpcnt.

    COLLECT wa_sf15 INTO it_sf15.
    CLEAR wa_sf15.
    CLEAR :  c_bcl,c_bc,c_xl,c_ls,p_bcl,p_bc,p_xl,p_ls,bcl,bc,xl,ls,c_tot,p_tot,stpcnt1,p_tot1,c_tot,p_tot1,p_tot2.
  ENDLOOP.



  LOOP AT it_sf14 INTO wa_sf14.
    SELECT SINGLE * FROM zoneseq WHERE zone_dist EQ wa_sf14-reg.
    IF sy-subrc EQ 0.
      wa_sf14-seq = zoneseq-seq.
      MODIFY it_sf14 FROM wa_sf14 TRANSPORTING seq.
      CLEAR wa_sf14.
    ENDIF.
  ENDLOOP.
  SORT it_sf14 BY seq.




ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FORM1EMR12
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM form1emr12 .

*  BREAK-POINT.

  CLEAR : it_sf16,wa_sf16.
  LOOP AT it_sf14 INTO wa_sf14.
    SELECT SINGLE * FROM zdsmter WHERE zmonth EQ month AND zyear EQ year AND bzirk EQ wa_sf14-reg.
    IF sy-subrc EQ 0.
      wa_sf16-sm = zdsmter-zdsm.
      wa_sf16-reg = wa_sf14-reg.
      wa_sf16-ename = wa_sf14-ename.
      wa_sf16-zz_hqdesc = wa_sf14-zz_hqdesc.
      wa_sf16-joindt = wa_sf14-joindt.
      wa_sf16-short = wa_sf14-short.
      CLEAR : dcount.
      READ TABLE it_sf11 INTO wa_sf11 WITH KEY reg = wa_sf14-reg div = 'BC'.
      IF sy-subrc EQ 0.
        divs = 'BC'.
        dcount = dcount + 1.
      ENDIF.
      READ TABLE it_sf11 INTO wa_sf11 WITH KEY reg = wa_sf14-reg div = 'XL'.
      IF sy-subrc EQ 0.
        divs = 'XL'.
        dcount = dcount + 1.
      ENDIF.
      READ TABLE it_sf11 INTO wa_sf11 WITH KEY reg = wa_sf14-reg div = 'LS'.
      IF sy-subrc EQ 0.
        divs = 'LS'.
        dcount = dcount + 1.
      ENDIF.
      IF dcount GT 1.
        divs = 'BCL'.
      ENDIF.
      wa_sf16-div = divs.
      CLEAR : prdty1.
      READ TABLE it_sf15 INTO wa_sf15 WITH KEY reg = wa_sf14-reg.
      IF sy-subrc EQ 0.
        wa_sf16-tot = wa_sf15-c_tot.
        prdty1 = wa_sf15-p_tot / 1000.
        wa_sf16-prdty = prdty1.
      ENDIF.
      CLEAR : sval1,tval1.
      sval1 = wa_sf14-net / 1000.
      tval1 = wa_sf14-targt1 / 1000.
      wa_sf16-net = sval1.
      wa_sf16-targt1 = tval1.
      wa_sf16-stp = wa_sf14-stp.
      wa_sf16-seq = wa_sf14-seq.

      CONDENSE : wa_sf16-stp,wa_sf16-targt1,wa_sf16-net,wa_sf16-net,wa_sf16-targt1,wa_sf16-prdty,wa_sf16-tot.
      COLLECT wa_sf16 INTO it_sf16.
      CLEAR wa_sf16.
    ENDIF.
  ENDLOOP.

  SORT it_sf17 BY sm.
  DELETE ADJACENT DUPLICATES FROM it_sf17 COMPARING sm.

*****  SORT it_sf16 BY div sm seq.
  SORT it_sf16 BY div sm ZZ_HQDESC.

  LOOP AT it_sf16 INTO wa_sf16.
    IF dv1 EQ 'X'.
      DELETE it_sf16 WHERE div = 'XL'.
      DELETE it_sf16 WHERE div = 'LS'.
    ELSEIF dv2 EQ 'X'.
      DELETE it_sf16 WHERE div = 'BC'.
      DELETE it_sf16 WHERE div = 'BCL'.
      DELETE it_sf16 WHERE div = 'LS'.
    ELSEIF dv4 EQ 'X'.
      DELETE it_sf16 WHERE div = 'BC'.
      DELETE it_sf16 WHERE div = 'XL'.
      DELETE it_sf16 WHERE div = 'BCL'.
    ENDIF.
  ENDLOOP.

  SORT it_sm1 BY sm reg.
  LOOP AT it_sm1 INTO wa_sm1.
    READ TABLE it_sf16 INTO wa_sf16 WITH KEY reg = wa_sm1-reg.
    IF sy-subrc EQ 4.
      DELETE it_sm1 WHERE reg EQ wa_sm1-reg.
    ENDIF.
*    WRITE : / 'a', WA_SM1-SM,WA_SM1-REG,WA_SM1-NET,WA_SM1-TARGT1,WA_SM1-C_TOT.
**    CLEAR :  stp2.
*    stp2 = ( WA_SM1-NET / 1000 ) / wa_sm1-tot.

  ENDLOOP.

  LOOP AT it_sm1 INTO wa_sm1.
    wa_sm2-sm = wa_sm1-sm.
    wa_sm2-net = wa_sm1-net.
    wa_sm2-targt1 = wa_sm1-targt1.
    wa_sm2-c_tot = wa_sm1-c_tot.
    COLLECT wa_sm2 INTO it_sm2.
    CLEAR wa_sm2.
*    CLEAR :  stp2.
*    stp2 = ( WA_SM1-NET / 1000 ) / wa_sm1-tot.

  ENDLOOP.
*  BREAK-POINT.
  CLEAR : it_sf17,wa_sf17.
  LOOP AT it_sm2 INTO wa_sm2.
    CLEAR: stp1,stp2,net1,tar1.
    wa_sf17-sm = wa_sm2-sm.
    stp1 = ( wa_sm2-net / wa_sm2-targt1 ) * 100.
    wa_sf17-prdty = stp1.
    stp2 = wa_sm2-net / wa_sm2-c_tot.
    stp2 = stp2 / 1000.
    wa_sf17-stp = stp2.
    net1 = wa_sm2-net / 1000.
    wa_sf17-net = net1.
    tar1 = wa_sm2-targt1 / 1000.
    wa_sf17-targt1 = tar1.
    wa_sf17-tot = wa_sm2-c_tot.

    SELECT SINGLE * FROM zdrphq WHERE bzirk EQ wa_sm2-sm.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM zthr_heq_des WHERE zz_hqcode EQ zdrphq-zz_hqcode.
      IF sy-subrc EQ 0.
        CLEAR : hqcode.
*          WRITE : zthr_heq_des-zz_hqdesc.
        wa_sf17-zz_hqdesc = zthr_heq_des-zz_hqdesc.
      ENDIF.
    ENDIF.
    CLEAR : divs,dcount.
    READ TABLE it_sf16 INTO wa_sf16 WITH KEY sm = wa_sm2-sm div = 'BCL'.
    IF sy-subrc EQ 0.
      divs = 'BCL'.
      dcount = dcount + 1.
    ENDIF.

    READ TABLE it_sf16 INTO wa_sf16 WITH KEY sm = wa_sm2-sm div = 'BC'.
    IF sy-subrc EQ 0.
      divs = 'BC'.
      dcount = dcount + 1.
    ENDIF.
    READ TABLE it_sf16 INTO wa_sf16 WITH KEY sm = wa_sm2-sm div = 'XL'.
    IF sy-subrc EQ 0.
      divs = 'XL'.
      dcount = dcount + 1.
    ENDIF.
    READ TABLE it_sf16 INTO wa_sf16 WITH KEY sm = wa_sm2-sm div = 'LS'.
    IF sy-subrc EQ 0.
      divs = 'LS'.
      dcount = dcount + 1.
    ENDIF.
*    IF DCOUNT GT 1.
*      DIVS = 'BCL'.
*    ENDIF.
    wa_sf17-div = divs.

    CONDENSE : wa_sf17-net,wa_sf17-targt1,wa_sf17-tot,wa_sf17-stp,wa_sf17-prdty,wa_sf17-tot.
    COLLECT wa_sf17 INTO it_sf17.
    CLEAR wa_sf17.

    wa_sm3-div = divs.
    wa_sm3-net = wa_sm2-net.
    wa_sm3-targt1 = wa_sm2-targt1.
    wa_sm3-c_tot = wa_sm2-c_tot.
    COLLECT wa_sm3 INTO it_sm3.
    CLEAR wa_sm3.
  ENDLOOP.

  LOOP AT it_sm3 INTO wa_sm3.
    wa_sf18-div = wa_sm3-div.
    CLEAR : t1,t2,t3,t4.

    t3 = ( wa_sm3-net / wa_sm3-targt1 ) * 100.
    wa_sf18-prdty = t3.
    t1 = wa_sm3-net / 1000.
    wa_sf18-net = t1.
    t2 = wa_sm3-targt1 / 1000.
    wa_sf18-targt1 = t2.
    wa_sf18-tot = wa_sm3-c_tot.
    t4 = t1 / wa_sm3-c_tot.
    wa_sf18-stp = t4.
    CONDENSE: wa_sf18-div,wa_sf18-net,wa_sf18-targt1,wa_sf18-tot,wa_sf18-stp,wa_sf18-prdty.
    COLLECT wa_sf18 INTO it_sf18.
    CLEAR wa_sf18.
  ENDLOOP.
*  BREAK-POINT .
  CLEAR : bcd1,bcd2,xld1,xld2,lsd1,lsd2.
  CLEAR : bd1,bd2,xd1,xd2,ld1,ld2,adiv1,acdiv1,bd3t,bd3,ad3t,ad3,bd4,bds4,xd4,xds4,ld4,lds4,ad4,ads4,bds5,xds5,lds5,ads5.
  LOOP AT it_sf11 INTO wa_sf11 WHERE div EQ 'BC' OR div EQ 'BCL'.
    bd1 = bd1 + 1.
    bd2 = bd2 + wa_sf11-stp.
    bd3t =   bd3t + ( wa_sf11-targt1 ).
    bds4 =  bds4 + ( wa_sf11-net ).
  ENDLOOP.

  LOOP AT it_sf11 INTO wa_sf11 WHERE div EQ 'XL'.
    xd1 = xd1 + 1.
    xd2 = xd2 + wa_sf11-stp.
    xd3t =   xd3t + ( wa_sf11-targt1 ).
    xds4 =  xds4 + ( wa_sf11-net ).
  ENDLOOP.
  LOOP AT it_sf11 INTO wa_sf11 WHERE div EQ 'LS'.
    ld1 = ld1 + 1.
    ld2 = ld2 + wa_sf11-stp.
    ld3t = ld3t + ( wa_sf11-targt1 ).
    lds4 = lds4 + ( wa_sf11-net ).
  ENDLOOP.

  pbcd2 = ( bds4 / 1000 ) / bd1.
  bcd2 = pbcd2.

  pxld2 = ( xds4 / 1000 ) / xd1.
  xld2 = pxld2.

  plsd2 = ( lds4 / 1000 ) / ld1.
  lsd2 = plsd2.

  IF bd3t GT 0.
    bd3t = bd3t / 100000.
  ENDIF.
  IF bds4 GT 0.
    bds4 = bds4 / 100000.
  ENDIF.

  IF xd3t GT 0.
    xd3t = xd3t / 100000.
  ENDIF.
  IF xds4 GT 0.
    xds4 = xds4 / 100000.
  ENDIF.

  IF ld3t GT 0.
    ld3t = ld3t / 100000.
  ENDIF.
  IF lds4 GT 0.
    lds4 = lds4 / 100000.
  ENDIF.

*  BREAK-POINT.
*  READ TABLE IT_SF18 INTO WA_SF18 WITH KEY DIV = 'BC'.
*  IF SY-SUBRC EQ 0.
**    BD1 = WA_SF18-TOT.
*    BD2 = WA_SF18-STP.
*    BD3T = WA_SF18-TARGT1 / 100.
*    BDS4 = WA_SF18-NET / 100.
*  ENDIF.

*  READ TABLE IT_SF18 INTO WA_SF18 WITH KEY DIV = 'XL'.
*  IF SY-SUBRC EQ 0.
**    XD1 = WA_SF18-TOT.
*    XD2 = WA_SF18-STP.
*    XD3T = WA_SF18-TARGT1 / 100.
*    XDS4 = WA_SF18-NET / 100.
*  ENDIF.

*  READ TABLE IT_SF18 INTO WA_SF18 WITH KEY DIV = 'LS'.
*  IF SY-SUBRC EQ 0.
**    LD1 = WA_SF18-TOT.
*    LD2 = WA_SF18-STP.
*    LD3T = WA_SF18-TARGT1 / 100.
*    LDS4 = WA_SF18-NET / 100.
*  ENDIF.

  bds5 = ( bds4 / bd3t ) * 100.
  xds5 = ( xds4 / xd3t ) * 100.
  lds5 = ( lds4 / ld3t ) * 100.
  ads5 = ( ( bds4 + xds4 + lds4 ) / ( bd3t + xd3t + ld3t ) ) * 100.
*  ADS5 = BDS5 + XDS5 + LDS5.


  bd4 = bds4.
  xd4 = xds4.
  ld4 = lds4.
  bd3 = bd3t.
  xd3 = xd3t.
  ld3 = ld3t.
  ad3 = bd3 + xd3 + ld3.
  ad4 = bd4 + xd4 + ld4.

  bd5 = bds5.
  xd5 = xds5.
  ld5 = lds5.
  ad5 = ads5.


  CONDENSE : bd3,xd3,ld3,ad3,bd4,xd4,ld4,ad4,bd5,xd5,ld5,ad5.

*  ADIV1 = BD1 + XD1 + LS1.
  adiv1 = bd1 + xd1 + ld1.
  acdiv1 = adiv1.
  bcd1 = bd1.
*  BCD2 = BD2.
  xld1 = xd1.
*  XLD2 = XD2.
  lsd1 = ld1.
*  LSD2 = LD2.
  CONDENSE : bcd1,bcd2,xld1,xld2,lsd1,lsd2,acdiv1.

  CLEAR: tot1,tot2,tot3,totc1,totc2.
  LOOP AT it_sm3 INTO wa_sm3.
    tot1 =  tot1 + wa_sm3-net / 1000.
    tot2 = tot2 + wa_sm3-c_tot.
  ENDLOOP.
  tot3 = tot1 / tot2.
  totc1 = totc1 + tot2.
  totc2 = totc2 + tot3.
  CONDENSE:  totc1,totc2.
*BREAK-POINT .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  R12SFFORMEMEM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM r12sfformemem .
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
*     FORMNAME           = 'ZSR9_S6'
      formname           = 'ZSR9_S64'
*     FORMNAME           = 'ZSR9_9'
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
      fm_name            = v_fm
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.

**  *   * Set the control parameter
  w_ctrlop-getotf = abap_true.
  w_ctrlop-no_dialog = abap_true.
  w_compop-tdnoprev = abap_true.
  w_ctrlop-preview = space.
  w_compop-tddest = 'LOCL'.

*  CONTROL-NO_OPEN   = 'X'.
*  CONTROL-NO_CLOSE  = 'X'.


*  CALL FUNCTION 'SSF_OPEN'
*    EXPORTING
*      CONTROL_PARAMETERS = CONTROL.
*  SORT IT_CHECK BY REG.

*  LOOP AT IT_CHECK INTO WA_CHECK.
*    BREAK-POINT .
  CLEAR : zonename.
  zonename = wa_check-zonename.
*    WRITE : / 'ZONE',ZONENAME.
  CLEAR : it_sf11,wa_sf11,it_sf12,wa_sf12,it_sf13,wa_sf13,it_sf14,wa_sf14.
*    PERFORM FORM1.
*    PERFORM FORM2.
*  PERFORM FORM1EM.
  PERFORM r12form1em.

  PERFORM form1emr12.
*  PERFORM FORM2EM.

  wa_sum1-form1 = 'F'.
  COLLECT wa_sum1 INTO it_sum1.
  CLEAR wa_sum1.
  wa_sum1-form1 = 'S'.
  COLLECT wa_sum1 INTO it_sum1.
  CLEAR wa_sum1.

  SORT it_sum1 BY form1.
  DELETE ADJACENT DUPLICATES FROM it_sum1 COMPARING form1.
  PERFORM subtot.
*  LOOP AT IT_SUM1 INTO WA_SUM1.
  CLEAR :  sform1.
  sform1 = wa_sum1-form1.
  CALL FUNCTION v_fm
    EXPORTING
*     CONTROL_PARAMETERS = CONTROL
*     USER_SETTINGS      = 'X'
*     OUTPUT_OPTIONS     = W_SSFCOMPOP
      control_parameters = w_ctrlop
      output_options     = w_compop
      user_settings      = abap_true
      format             = format
      zonename           = zonename
      regename           = regename
      reghqdesc          = reghqdesc
      regjoindt          = regjoindt
      regshort           = regshort
      regnet             = regnet
      regtargt1          = regtargt1
      regstp1            = regstp1
      s_budat1           = s_budat1
      s_budat2           = s_budat2
      c_bcl1             = c_bcl1
      c_bc1              = c_bc1
      c_xl1              = c_xl1
      c_ls1              = c_ls1
      p_bcl1             = p_bcl1
      p_bc1              = p_bc1
      p_xl1              = p_xl1
      p_ls1              = p_ls1
      stpcnt2            = stpcnt2
      p_tot1             = p_tot2
      c_tot1             = c_tot1
      bcl1               = bcl1
      bc1                = bc1
      xl1                = xl1
      ls1                = ls1
      sform1             = sform1
      bcd1               = bcd1
      bcd2               = bcd2
      xld1               = xld1
      xld2               = xld2
      lsd1               = lsd1
      lsd2               = lsd2
      totc1              = totc1
      totc2              = totc2
      acdiv1             = acdiv1
      bcdiv1             = bcdiv1
      xldiv1             = xldiv1
      lsdiv1             = lsdiv1
      totdiv1            = totdiv1
      bd3                = bd3
      xd3                = xd3
      ld3                = ld3
      ad3                = ad3
      bd4                = bd4
      xd4                = xd4
      ld4                = ld4
      ad4                = ad4
      bd5                = bd5
      xd5                = xd5
      ld5                = ld5
      ad5                = ad5
    IMPORTING
      job_output_info    = w_return " This will have all output
    TABLES
      it_sf1             = it_sf11
      it_sf2             = it_sf12
      it_sf3             = it_sf13
      it_sf4             = it_sf14
      it_sf5             = it_sf15
*     it_sf6             = it_sf16
      it_sf6             = it_ntab2
      it_sf7             = it_sf17
      it_sf8             = it_sf18
*     itab_division      = itab_division
*     itab_storage       = itab_storage
*     itab_pa0002        = itab_pa0002
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.


  i_otf[] = w_return-otfdata[].
*
* Import Binary file and filesize
  CALL FUNCTION 'CONVERT_OTF'
    EXPORTING
      format                = 'PDF'
      max_linewidth         = 132
    IMPORTING
      bin_filesize          = v_len_in
      bin_file              = i_xstring   " This is NOT Binary. This is Hexa
    TABLES
      otf                   = i_otf
      lines                 = i_tline
    EXCEPTIONS
      err_max_linewidth     = 1
      err_format            = 2
      err_conv_not_possible = 3
      OTHERS                = 4.
* Sy-subrc check not checked


*
**  * Convert Hexa String to Binary format
  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer     = i_xstring
    TABLES
      binary_tab = i_objbin[].
** Sy-subrc check not required.
*
**    DATA: IN_MAILID TYPE AD_SMTPADR.
*
** Begin of sending email to multiple users
** If business want email to be sent to all users at one time, it can be done
*
** For now we do not want to send 1 email to multiple users
** Mail has to be sent one email at a time
*
**  IF P2 EQ 'X'.
**
**      CLEAR IN_MAILID.
*  IN_MAILID = 'JYOTSNA@BLUECROSSLABS.COM'.
  in_mailid = uemail.
  PERFORM send_mail USING in_mailid .

  CLEAR : it_sf11,wa_sf11,it_sf12,wa_sf12,it_sf13,wa_sf13,it_sf14,wa_sf14.

  CLEAR : zonename,  regename, reghqdesc,regjoindt, regshort, regnet ,regtargt1,regstp1,c_bcl1, c_bc1,c_xl1,
    c_ls1 , p_bcl1 ,p_bc1,p_xl1,p_ls1,stpcnt2,p_tot1, c_tot1 ,bcl1,bc1,xl1,ls1.
  CLEAR:  sform1,bcd1,bcd2, xld1,xld2,lsd1,lsd2,
*  TOTC1,TOTC2,
  acdiv1,bcdiv1,xldiv1,lsdiv1,totdiv1,bd3,xd3,ld3,ad3,bd4, xd4,ld4,ad4,bd5,xd5,ld5,ad5.

*  ENDLOOP.

  CLEAR : it_sf1,wa_sf1,it_sf2,wa_sf2,it_sf3,wa_sf3.
*  CALL FUNCTION 'SSF_CLOSE'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SUBTOT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM subtot .

  LOOP AT it_sf16 INTO wa_sf16.
    MOVE-CORRESPONDING wa_sf16 TO wa_ntab1.
    IF wa_ntab1-div EQ 'BCL'.
      wa_ntab1-div = 'BC'.
    ENDIF.
    CONDENSE   wa_ntab1-div.
    COLLECT wa_ntab1 INTO it_ntab1.
    CLEAR wa_ntab1.
  ENDLOOP.
  CLEAR :  nter1,nsale1.
*  break-point.

*  SORT IT_NTAB1 BY DIV SM SEQ.
  CLEAR count2.
  LOOP AT it_ntab1 INTO wa_ntab1.

    nter1 = nter1 + wa_ntab1-tot.
    nsale1 = nsale1 + wa_ntab1-net.
    ntar1 = ntar1 + wa_ntab1-targt1.

    dnter1 = dnter1 + wa_ntab1-tot.
    dnsale1 = dnsale1 + wa_ntab1-net.
    dntar1 = dntar1 + wa_ntab1-targt1.

    MOVE-CORRESPONDING wa_ntab1 TO wa_ntab2.
    COLLECT wa_ntab2 INTO it_ntab2.
    AT END OF div.
      wa_ntab2-ename = space.
      wa_ntab2-short = space.
      wa_ntab2-joindt = space.
      wa_ntab2-div = wa_ntab1-div.
      wa_ntab2-zz_hqdesc = 'DIV TOTAL'.
      wa_ntab2-tot = nter1.
      wa_ntab2-net = nsale1.
      wa_ntab2-targt1 = ntar1.
      nter2 = nsale1 / nter1.
      wa_ntab2-prdty = nter2.
      nter3 = ( nsale1 / ntar1 ) * 100.
      wa_ntab2-stp = nter3.
      CONDENSE : wa_ntab2-tot,wa_ntab2-net,wa_ntab2-targt1,wa_ntab2-prdty,wa_ntab2-stp.
      APPEND wa_ntab2 TO it_ntab2.
      IF r9 EQ 'X'.
        wa_ntab2-ename = space.
        wa_ntab2-short = space.
        wa_ntab2-joindt = space.
        wa_ntab2-div = space.
        wa_ntab2-zz_hqdesc = space.
        wa_ntab2-tot = space.
        wa_ntab2-net = space.
        wa_ntab2-targt1 = space.
*        nter2 = nsale1 / nter1.
        wa_ntab2-prdty = space.
*        nter3 = ( nsale1 / ntar1 ) * 100.
        wa_ntab2-stp = space.
        CONDENSE : wa_ntab2-tot,wa_ntab2-net,wa_ntab2-targt1,wa_ntab2-prdty,wa_ntab2-stp.
        APPEND wa_ntab2 TO it_ntab2.
      ENDIF.
      nter1 = 0.
      nsale1 = 0.
      ntar1 = 0.
      nter2 = 0.
      nter3 = 0.
    ENDAT.

*    if count2 gt 1.
*      on change of wa_ntab1-div.
*        wa_ntab2-ename = space.
*        wa_ntab2-short = space.
*        wa_ntab2-joindt = space.
*        wa_ntab2-div = wa_ntab1-div.
*        wa_ntab2-zz_hqdesc = space.
*
**      SELECT SINGLE * FROM yterrallc WHERE bzirk EQ wa_ntab1-sm.
**      IF sy-subrc EQ 0.
**        SELECT SINGLE * FROM pa0001 WHERE plans eq yterrallc-plans AND endda ge sy-datum.
**        IF sy-subrc EQ 0.
**          wa_ntab2-zz_hqdesc = pa0001-ename.
**        ENDIF.
**      ENDIF.
*
*        wa_ntab2-tot = dnter1.
*        wa_ntab2-net = dnsale1.
*        wa_ntab2-targt1 = dntar1.
*        nter2 = dnsale1 / dnter1.
*        wa_ntab2-prdty = dnter2.
*        dnter3 = ( dnsale1 / dntar1 ) * 100.
*        wa_ntab2-stp = dnter3.
*        condense : wa_ntab2-tot,wa_ntab2-net,wa_ntab2-targt1,wa_ntab2-prdty,wa_ntab2-stp.
*        append wa_ntab2 to it_ntab2.
*        nter1 = 0.
*        nsale1 = 0.
*        ntar1 = 0.
*        nter2 = 0.
*        nter3 = 0.
*        dnter1 = 0.
*        dnsale1 = 0.
*        dntar1 = 0.
*        dnter2 = 0.
*        dnter3 = 0.
*      endon.
*    endif.
    CLEAR wa_ntab2.
*    count2  = count2 + 1.
  ENDLOOP.
*  break-point.
ENDFORM.
