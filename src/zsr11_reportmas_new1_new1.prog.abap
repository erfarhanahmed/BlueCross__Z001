*&---------------------------------------------------------------------*
*& Report  ZSR9_PRG1
*& Report developed by Jyotsna in Feb'15.
*&---------------------------------------------------------------------*
*&for growth concider data from ZRCUMPSO - 17.7.2018 - as per MN & PARAM
*&for pso growth concider data from current year sale from ZCUMPSO & last year sale from ZRCUMPSO - 2.9.24 as per PARAM : -Jyotsna
*&---------------------------------------------------------------------*

report  zsr11_reportmas_2 no standard page heading line-size 500.

tables: zcumpso,
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
        t542t,
        t247,
        t529t,
        zdrphq,
        zoneseq,
        zrcumpso,
        ztotpso.


type-pools:  slis.

data: g_repid     like sy-repid,
      fieldcat    type slis_t_fieldcat_alv,
      wa_fieldcat like line of fieldcat,
      sort        type slis_t_sortinfo_alv,
      wa_sort     like line of sort,
      layout      type slis_layout_alv.

types : begin of typ_konv,
          knumv type PRCD_ELEMENTS-knumv,
          kposn type PRCD_ELEMENTS-kposn,
          kschl type PRCD_ELEMENTS-kschl,
          kwert type PRCD_ELEMENTS-kwert,
        end of typ_konv.

data : it_zdsmter         type table of zdsmter,
       wa_zdsmter         type zdsmter,
       it_vbrk            type table of vbrk,
       wa_vbrk            type vbrk,
       it_vbrp            type table of vbrp,
       wa_vbrp            type vbrp,
       it_vbrk1           type table of vbrk,
       wa_vbrk1           type vbrk,
       it_vbrp1           type table of vbrp,
       wa_vbrp1           type vbrp,
       it_konv            type table of typ_konv,
       wa_konv            type typ_konv,
       it_ysd_cus_div_dis type table of ysd_cus_div_dis,
       wa_ysd_cus_div_dis type ysd_cus_div_dis,
       it_yterrallc       type table of yterrallc,
       wa_yterrallc       type yterrallc,
       it_yterrallc_z     type table of yterrallc,
       wa_yterrallc_z     type yterrallc,
       it_yterrallc_r     type table of yterrallc,
       wa_yterrallc_r     type yterrallc,
       it_pa0001          type table of pa0001,
       wa_pa0001          type pa0001,
       it_pa0001a1        type table of pa0001,
       wa_pa0001a1        type pa0001,
       it_pa0001_1        type table of pa0001,
       wa_pa0001_1        type pa0001,
       it_pa0001_z        type table of pa0001,
       wa_pa0001_z        type pa0001,
       it_pa0001_r        type table of pa0001,
       wa_pa0001_r        type pa0001,
       it_pa0001_2        type table of pa0001,
       wa_pa0001_2        type pa0001,
       it_yempval         type table of yempval,
       wa_yempval         type yempval,
       it_pa0015          type table of pa0015,
       wa_pa0015          type pa0015,
       it_pa0008          type table of pa0008,
       wa_pa0008          type pa0008,
       it_pa0008_1        type table of pa0008,
       wa_pa0008_1        type pa0008,
       it_pa0008_2        type table of pa0008,
       wa_pa0008_2        type pa0008,
       it_pa0000          type table of pa0000,
       wa_pa0000          type pa0000,
       it_pa0019          type table of pa0019,
       wa_pa0019          type pa0019,
       it_pa0000_zm       type table of pa0000,
       wa_pa0000_zm       type pa0000,
       it_pa0000_dzm      type table of pa0000,
       wa_pa0000_dzm      type pa0000,
       it_pa0000_rm       type table of pa0000,
       wa_pa0000_rm       type pa0000,
       it_pa0000_pso      type table of pa0000,
       wa_pa0000_pso      type pa0000,
       it_zdsmter_l1      type table of zdsmter,
       wa_zdsmter_l1      type zdsmter,
       it_zdsmter_l2      type table of zdsmter,
       wa_zdsmter_l2      type zdsmter.


types : begin of itab1,
          sm        type zdsmter-zdsm,
          reg       type zdsmter-zdsm,
          spart     type zdsmter-spart,
          zm        type zdsmter-bzirk,
          rm        type zdsmter-bzirk,
          bzirk     type zdsmter-bzirk,
          sval      type p decimals 2,
          plans     type yterrallc-plans,
          ename     type pa0001-ename,
          join_dt   type pa0001-begda,
          zz_hqdesc type zthr_heq_des-zz_hqdesc,
          div(3)    type c,
          pernr     type pa0001-pernr,
        end of itab1.


types : begin of itab6,
          reg           type zdsmter-zdsm,
          spart         type zdsmter-spart,
          zm            type zdsmter-bzirk,
          rm            type zdsmter-bzirk,
          bzirk         type zdsmter-bzirk,
          sval          type p decimals 2,
          plans         type yterrallc-plans,
          ename         type pa0001-ename,
          join_dt       type pa0001-begda,
          zz_hqdesc     type zthr_heq_des-zz_hqdesc,
          div(3)        type c,
          pernr         type pa0001-pernr,
          rmpernr       type pa0001-pernr,
          zmpernr       type pa0001-pernr,
          dzmpernr      type pa0001-pernr,
          rconf_prob(1) type c,
          zconf_prob(1) type c,
          dconf_prob(1) type c,
          typ(1)        type c,
          join_date     type sy-datum,
          rmjoin_date   type sy-datum,
          dzmjoin_date  type sy-datum,
          zmjoin_date   type sy-datum,
        end of itab6.

types : begin of itab61,
          reg     type zdsmter-zdsm,
          zmpernr type pa0001-pernr,
        end of itab61.


types : begin of itab7,
          reg           type zdsmter-zdsm,
          zm            type zdsmter-zdsm,
*spart type zdsmter-spart,
*zm type zdsmter-bzirk,
          rm            type zdsmter-bzirk,
          bzirk         type zdsmter-bzirk,
          sval          type p decimals 2,
          plans         type yterrallc-plans,
          ename         type pa0001-ename,
          join_dt       type pa0001-begda,
          zz_hqdesc     type zthr_heq_des-zz_hqdesc,
          div(3)        type c,
          zmpernr       type pa0001-pernr,
          dzmpernr      type pa0001-pernr,
          rmpernr       type pa0001-pernr,
          pernr         type pa0001-pernr,
          conf_prob(1)  type c,
          rconf_prob(1) type c,
          zconf_prob(1) type c,
          dconf_prob(1) type c,
          c1sale        type p,
          c2sale        type p,
          c3sale        type p,

          t1            type p,
          t2            type p,
          t3            type p,

          llsqrt1       type p,
          llsqrt2       type p,
          llsqrt3       type p,
          llsqrt4       type p,

          lsqrt1        type p,
          lsqrt2        type p,
          lsqrt3        type p,
          lsqrt4        type p,
          lsqrt5        type p,

          lsqrtc1       type p,
          lsqrtc2       type p,
          lsqrtc3       type p,
          lsqrtc4       type p,
          lsqrtc        type p,

          ltqrt1        type p,
          ltqrt2        type p,
          ltqrt3        type p,
          ltqrt4        type p,

          csqrt1        type p,
          csqrt2        type p,
          csqrt3        type p,
          csqrt4        type p,

          cqtr1         type p,
          cqtr2         type p,
          cqtr3         type p,
          cqtr4         type p,

          ctqrt1        type p,
          ctqrt2        type p,
          ctqrt3        type p,
          ctqrt4        type p,

          lcumms        type p,
          cumms         type p,
          cummt         type p,

          cqtr          type p,
          lcummsr       type p,
          cummsr        type p,

          typ(1)        type c,
          lyt           type p,
          lys           type p,
          lls           type p,
          lgrw          type p,
          lcumm         type p,
          inct          type p,
          ctar          type p,
          ccumm         type p,
          lygrw         type p,
          join_date     type sy-datum,
          qt1           type p,
          qt2           type p,
          qt3           type p,
          qt4           type p,
          cms           type p,
          lms           type p,
          llms          type p,
          incrdt(7)     type c,
*  incrdt TYPE sy-datum,
          csal          type p,
          incr          type p,
          short         type zfsdes-short,
          inc_r(2)      type c,
          increment_dt  type sy-datum,
        end of itab7.


types : begin of smitab7,
          sm            type zdsmter-zdsm,
          reg           type zdsmter-zdsm,
          zm            type zdsmter-zdsm,
*spart type zdsmter-spart,
*zm type zdsmter-bzirk,
          rm            type zdsmter-bzirk,
          bzirk         type zdsmter-bzirk,
          sval          type p decimals 2,
          plans         type yterrallc-plans,
          ename         type pa0001-ename,
          join_dt       type pa0001-begda,
          zz_hqdesc     type zthr_heq_des-zz_hqdesc,
          div(3)        type c,
          zmpernr       type pa0001-pernr,
          dzmpernr      type pa0001-pernr,
          rmpernr       type pa0001-pernr,
          pernr         type pa0001-pernr,
          conf_prob(1)  type c,
          rconf_prob(1) type c,
          zconf_prob(1) type c,
          dconf_prob(1) type c,
          c1sale        type p,
          c2sale        type p,
          c3sale        type p,

          t1            type p,
          t2            type p,
          t3            type p,

          llsqrt1       type p,
          llsqrt2       type p,
          llsqrt3       type p,
          llsqrt4       type p,

          lsqrt1        type p,
          lsqrt2        type p,
          lsqrt3        type p,
          lsqrt4        type p,
          lsqrt5        type p,

          lsqrtc1       type p,
          lsqrtc2       type p,
          lsqrtc3       type p,
          lsqrtc4       type p,
          lsqrtc        type p,

          ltqrt1        type p,
          ltqrt2        type p,
          ltqrt3        type p,
          ltqrt4        type p,

          csqrt1        type p,
          csqrt2        type p,
          csqrt3        type p,
          csqrt4        type p,

          cqtr1         type p,
          cqtr2         type p,
          cqtr3         type p,
          cqtr4         type p,

          ctqrt1        type p,
          ctqrt2        type p,
          ctqrt3        type p,
          ctqrt4        type p,

          lcumms        type p,
          cumms         type p,
          cummt         type p,

          cqtr          type p,
          lcummsr       type p,
          cummsr        type p,

          typ(1)        type c,
          lyt           type p,
          lys           type p,
          lls           type p,
          lgrw          type p,
          lcumm         type p,
          inct          type p,
          ctar          type p,
          ccumm         type p,
          lygrw         type p,
          join_date     type sy-datum,
          qt1           type p,
          qt2           type p,
          qt3           type p,
          qt4           type p,
          cms           type p,
          lms           type p,
          llms          type p,
          incrdt(7)     type c,
*  incrdt TYPE sy-datum,
          csal          type p,
          incr          type p,
          short         type zfsdes-short,
          inc_r(2)      type c,
          increment_dt  type sy-datum,
        end of smitab7.

types : begin of itab8,
          seq           type i,
          reg           type zdsmter-zdsm,
          spart         type zdsmter-spart,
          zm            type zdsmter-bzirk,
          rm            type zdsmter-bzirk,
          bzirk         type zdsmter-bzirk,
          sval          type p decimals 2,
          plans         type yterrallc-plans,
          ename         type pa0001-ename,
          conf_prob(1)  type c,
          rconf_prob(1) type c,
          zconf_prob(1) type c,
          dconf_prob(1) type c,
          join_dt(7)    type c,
          zz_hqdesc     type zthr_heq_des-zz_hqdesc,
          div(3)        type c,
*pernr type pa0001-pernr,
          zmpernr       type pa0001-pernr,
          dzmpernr      type pa0001-pernr,
          rmpernr       type pa0001-pernr,
          pernr         type pa0001-pernr,
          incr_dt       type sy-datum,

          cp1           type p,
          cp2           type p,
          cp3           type p,

          lpqrt1        type p,
          lpqrt2        type p,
          lpqrt3        type p,
          lpqrt4        type p,
          lpqrt         type p,

          cpqrt1        type p,
          cpqrt2        type p,
          cpqrt3        type p,
          cpqrt4        type p,

          lsqrt1        type p,
          lsqrt2        type p,
          lsqrt3        type p,
          lsqrt4        type p,
          lsqrtc        type p,

          lysale1(7)    type c,
          lysale2(7)    type c,
          lysale3(7)    type c,
          lysale4(7)    type c,
          lysale(7)     type c,

          lysalec1(7)   type c,
          lysalec2(7)   type c,
          lysalec3(7)   type c,
          lysalec4(7)   type c,
          lysalec(7)    type c,

          cysale1(7)    type c,
          cysale2(7)    type c,
          cysale3(7)    type c,
          cysale4(7)    type c,
          cysale(7)     type c,

          c1sale(6)     type c,
          c2sale(6)     type c,
          c3sale(6)     type c,

          ltqrt1        type p,
          ltqrt2        type p,
          ltqrt3        type p,
          ltqrt4        type p,

          csqrt1        type p,
          csqrt2        type p,
          csqrt3        type p,
          csqrt4        type p,

          ctqrt1        type p,
          ctqrt2        type p,
          ctqrt3        type p,
          ctqrt4        type p,

          typ(1)        type c,
          lyt           type p,
          lys           type p,
          lls           type p,
          lgrw          type p,
          cgrw          type p,
          lcumm         type p,
          inct          type p,
          ctar(6)       type c,
          ccumm         type p,
          lygrw         type p,
          join_date     type sy-datum,
          qt1           type p,
          qt2           type p,
          qt3           type p,
          qt4           type p,
          cms           type p,
          lms           type p,
          llms          type p,
          short         type zfsdes-short,
*  incrdt(7) type c,
**  incrdt TYPE sy-datum,
*  csal type p,
*  incr type p,

*  inc_r(2) type c,
*  increment_dt type sy-datum,
          prom(7)       type c,
          prom1(6)      type c,
          noofpso       type ztotpso-bc,
        end of itab8.


types : begin of smitab8,
          seq           type i,
          sm            type zdsmter-zdsm,
          spart         type zdsmter-spart,
          zm            type zdsmter-bzirk,
          rm            type zdsmter-bzirk,
          bzirk         type zdsmter-bzirk,
          sval          type p decimals 2,
          plans         type yterrallc-plans,
          ename         type pa0001-ename,
          conf_prob(1)  type c,
          rconf_prob(1) type c,
          zconf_prob(1) type c,
          dconf_prob(1) type c,
          join_dt(7)    type c,
          zz_hqdesc     type zthr_heq_des-zz_hqdesc,
          div(3)        type c,
*pernr type pa0001-pernr,
          smpernr       type pa0001-pernr,
          dzmpernr      type pa0001-pernr,
          rmpernr       type pa0001-pernr,
          pernr         type pa0001-pernr,
          incr_dt       type sy-datum,

          cp1           type p,
          cp2           type p,
          cp3           type p,

          lpqrt1        type p,
          lpqrt2        type p,
          lpqrt3        type p,
          lpqrt4        type p,
          lpqrt         type p,

          cpqrt1        type p,
          cpqrt2        type p,
          cpqrt3        type p,
          cpqrt4        type p,

          lsqrt1        type p,
          lsqrt2        type p,
          lsqrt3        type p,
          lsqrt4        type p,
          lsqrtc        type p,

          lysale1(7)    type c,
          lysale2(7)    type c,
          lysale3(7)    type c,
          lysale4(7)    type c,
          lysale(7)     type c,

          lysalec1(7)   type c,
          lysalec2(7)   type c,
          lysalec3(7)   type c,
          lysalec4(7)   type c,
          lysalec(7)    type c,

          cysale1(7)    type c,
          cysale2(7)    type c,
          cysale3(7)    type c,
          cysale4(7)    type c,
          cysale(7)     type c,

          c1sale(6)     type c,
          c2sale(6)     type c,
          c3sale(6)     type c,

          ltqrt1        type p,
          ltqrt2        type p,
          ltqrt3        type p,
          ltqrt4        type p,

          csqrt1        type p,
          csqrt2        type p,
          csqrt3        type p,
          csqrt4        type p,

          ctqrt1        type p,
          ctqrt2        type p,
          ctqrt3        type p,
          ctqrt4        type p,

          typ(1)        type c,
          lyt           type p,
          lys           type p,
          lls           type p,
          lgrw          type p,
          cgrw          type p,
          lcumm         type p,
          inct          type p,
          ctar(6)       type c,
          ccumm         type p,
          lygrw         type p,
          join_date     type sy-datum,
          qt1           type p,
          qt2           type p,
          qt3           type p,
          qt4           type p,
          cms           type p,
          lms           type p,
          llms          type p,
          short         type zfsdes-short,
*  incrdt(7) type c,
**  incrdt TYPE sy-datum,
*  csal type p,
*  incr type p,

*  inc_r(2) type c,
*  increment_dt type sy-datum,
          prom(7)       type c,
          prom1(6)      type c,
          noofpso       type ztotpso-bc,
        end of smitab8.




types : begin of itab9,
          seq(3)        type c,
          reg           type zdsmter-zdsm,
          spart         type zdsmter-spart,
          zm            type zdsmter-bzirk,
          rm            type zdsmter-bzirk,
          bzirk         type zdsmter-bzirk,
          sval          type p decimals 2,
          plans         type yterrallc-plans,
          ename         type pa0001-ename,
          conf_prob(1)  type c,
          rconf_prob(1) type c,
          zconf_prob(1) type c,
          dconf_prob(1) type c,
          join_dt(7)    type c,
          zz_hqdesc     type zthr_heq_des-zz_hqdesc,
          div(3)        type c,
*pernr type pa0001-pernr,
          zmpernr       type pa0001-pernr,
          dzmpernr      type pa0001-pernr,
          rmpernr       type pa0001-pernr,
          pernr         type pa0001-pernr,
          incr_dt       type sy-datum,

          cp1           type p,
          cp2           type p,
          cp3           type p,

          lpqrt1        type p,
          lpqrt2        type p,
          lpqrt3        type p,
          lpqrt4        type p,
          lpqrt         type p,

          cpqrt1        type p,
          cpqrt2        type p,
          cpqrt3        type p,
          cpqrt4        type p,

          lsqrt1        type p,
          lsqrt2        type p,
          lsqrt3        type p,
          lsqrt4        type p,
          lsqrtc        type p,

          lysale1       type p,
          lysale2       type p,
          lysale3       type p,
          lysale4       type p,
          lysale        type p,

          lysalec1      type p,
          lysalec2      type p,
          lysalec3      type p,
          lysalec4      type p,
          lysalec       type p,

          cysale1       type p,
          cysale2       type p,
          cysale3       type p,
          cysale4       type p,
          cysale        type p,

          c1sale        type p,
          c2sale        type p,
          c3sale        type p,

          ltqrt1        type p,
          ltqrt2        type p,
          ltqrt3        type p,
          ltqrt4        type p,

          csqrt1        type p,
          csqrt2        type p,
          csqrt3        type p,
          csqrt4        type p,

          ctqrt1        type p,
          ctqrt2        type p,
          ctqrt3        type p,
          ctqrt4        type p,

          typ(1)        type c,
          lyt           type p,
          lys           type p,
          lls           type p,
          lgrw          type p,
          cgrw          type p,
          lcumm         type p,
          inct          type p,
*  ctar(6) type c,
          ctar          type p,
          ccumm         type p,
          lygrw         type p,
          join_date     type sy-datum,
          qt1           type p,
          qt2           type p,
          qt3           type p,
          qt4           type p,
          cms           type p,
          lms           type p,
          llms          type p,
          short         type zfsdes-short,
*  incrdt(7) type c,
**  incrdt TYPE sy-datum,
*  csal type p,
*  incr type p,

*  inc_r(2) type c,
*  increment_dt type sy-datum,
          prom(7)       type c,
          prom1(6)      type c,
        end of itab9.

types : begin of smitab9,
          seq(3)        type c,
          sm            type zdsmter-zdsm,
          spart         type zdsmter-spart,
          zm            type zdsmter-bzirk,
          rm            type zdsmter-bzirk,
          bzirk         type zdsmter-bzirk,
          sval          type p decimals 2,
          plans         type yterrallc-plans,
          ename         type pa0001-ename,
          conf_prob(1)  type c,
          rconf_prob(1) type c,
          zconf_prob(1) type c,
          dconf_prob(1) type c,
          join_dt(7)    type c,
          zz_hqdesc     type zthr_heq_des-zz_hqdesc,
          div(3)        type c,
*pernr type pa0001-pernr,
          smpernr       type pa0001-pernr,
          dzmpernr      type pa0001-pernr,
          rmpernr       type pa0001-pernr,
          pernr         type pa0001-pernr,
          incr_dt       type sy-datum,

          cp1           type p,
          cp2           type p,
          cp3           type p,

          lpqrt1        type p,
          lpqrt2        type p,
          lpqrt3        type p,
          lpqrt4        type p,
          lpqrt         type p,

          cpqrt1        type p,
          cpqrt2        type p,
          cpqrt3        type p,
          cpqrt4        type p,

          lsqrt1        type p,
          lsqrt2        type p,
          lsqrt3        type p,
          lsqrt4        type p,
          lsqrtc        type p,

          lysale1       type p,
          lysale2       type p,
          lysale3       type p,
          lysale4       type p,
          lysale        type p,

          lysalec1      type p,
          lysalec2      type p,
          lysalec3      type p,
          lysalec4      type p,
          lysalec       type p,

          cysale1       type p,
          cysale2       type p,
          cysale3       type p,
          cysale4       type p,
          cysale        type p,

          c1sale        type p,
          c2sale        type p,
          c3sale        type p,

          ltqrt1        type p,
          ltqrt2        type p,
          ltqrt3        type p,
          ltqrt4        type p,

          csqrt1        type p,
          csqrt2        type p,
          csqrt3        type p,
          csqrt4        type p,

          ctqrt1        type p,
          ctqrt2        type p,
          ctqrt3        type p,
          ctqrt4        type p,

          typ(1)        type c,
          lyt           type p,
          lys           type p,
          lls           type p,
          lgrw          type p,
          cgrw          type p,
          lcumm         type p,
          inct          type p,
*  ctar(6) type c,
          ctar          type p,
          ccumm         type p,
          lygrw         type p,
          join_date     type sy-datum,
          qt1           type p,
          qt2           type p,
          qt3           type p,
          qt4           type p,
          cms           type p,
          lms           type p,
          llms          type p,
          short         type zfsdes-short,
*  incrdt(7) type c,
**  incrdt TYPE sy-datum,
*  csal type p,
*  incr type p,

*  inc_r(2) type c,
*  increment_dt type sy-datum,
          prom(7)       type c,
          prom1(6)      type c,
        end of smitab9.

types : begin of alv1,
          seq           type i,
          reg           type zdsmter-zdsm,
          spart         type zdsmter-spart,
          zm            type zdsmter-bzirk,
          rm            type zdsmter-bzirk,
          bzirk         type zdsmter-bzirk,
          sval          type p decimals 2,
          plans         type yterrallc-plans,
          ename         type pa0001-ename,
          conf_prob(1)  type c,
          rconf_prob(1) type c,
          zconf_prob(1) type c,
          dconf_prob(1) type c,
          join_dt(7)    type c,
          zz_hqdesc     type zthr_heq_des-zz_hqdesc,
          div(3)        type c,
*pernr type pa0001-pernr,
          zmpernr       type pa0001-pernr,
          dzmpernr      type pa0001-pernr,
          rmpernr       type pa0001-pernr,
          pernr         type pa0001-pernr,
          incr_dt       type sy-datum,
          zmname        type pa0001-ename,
          rmname        type pa0001-ename,
          dzmname       type pa0001-ename,

          cp1           type p,
          cp2           type p,
          cp3           type p,

          lpqrt1        type p,
          lpqrt2        type p,
          lpqrt3        type p,
          lpqrt4        type p,
          lpqrt         type p,

          cpqrt1        type p,
          cpqrt2        type p,
          cpqrt3        type p,
          cpqrt4        type p,

          lsqrt1        type p,
          lsqrt2        type p,
          lsqrt3        type p,
          lsqrt4        type p,
          lsqrtc        type p,

          lysale1       type p,
          lysale2       type p,
          lysale3       type p,
          lysale4       type p,
          lysale        type p,

          lysalec1      type p,
          lysalec2      type p,
          lysalec3      type p,
          lysalec4      type p,
          lysalec       type p,

          cysale1       type p,
          cysale2       type p,
          cysale3       type p,
          cysale4       type p,
          cysale        type p,

          c1sale        type p,
          c2sale        type p,
          c3sale        type p,

          ltqrt1        type p,
          ltqrt2        type p,
          ltqrt3        type p,
          ltqrt4        type p,

          csqrt1        type p,
          csqrt2        type p,
          csqrt3        type p,
          csqrt4        type p,

          ctqrt1        type p,
          ctqrt2        type p,
          ctqrt3        type p,
          ctqrt4        type p,

          typ(1)        type c,
          lyt           type p,
          lys           type p,
          lls           type p,
          lgrw          type p,
          cgrw          type p,
          lcumm         type p,
          inct          type p,
*  ctar(6) type c,
          ctar          type p,
          ccumm         type p,
          lygrw         type p,
          join_date     type sy-datum,
          qt1           type p,
          qt2           type p,
          qt3           type p,
          qt4           type p,
          cms           type p,
          lms           type p,
          llms          type p,
          short         type zfsdes-short,
*  incrdt(7) type c,
**  incrdt TYPE sy-datum,
*  csal type p,
*  incr type p,

*  inc_r(2) type c,
*  increment_dt type sy-datum,
          prom(7)       type c,
          prom1(6)      type c,
        end of alv1.

types : begin of itac3,
          bzirk  type ysd_cus_div_dis-bzirk,
          kunnr  type ysd_cus_div_dis-kunnr,
          spart  type ysd_cus_div_dis-spart,
          percnt type ysd_cus_div_dis-percnt,
          plans  type yterrallc-plans,
        end of   itac3.

types : begin of illy1,
          bzirk type zdsmter-bzirk,
          rm    type zdsmter-bzirk,
          zm    type zdsmter-bzirk,
          m1    type p,
          m2    type p,
          m3    type p,
          m4    type p,
          m5    type p,
          m6    type p,
          m7    type p,
          m8    type p,
          m9    type p,
          m10   type p,
          m11   type p,
          m12   type p,
        end of illy1.

types : begin of cilly1,
          zm    type zdsmter-zdsm,
          dzm   type zdsmter-zdsm,
          rm    type zdsmter-zdsm,
          bzirk type zdsmter-zdsm,
          m1    type p,
          m2    type p,
          m3    type p,
          m4    type p,
          m5    type p,
          m6    type p,
          m7    type p,
          m8    type p,
          m9    type p,
          m10   type p,
          m11   type p,
          m12   type p,
        end of cilly1.

types : begin of illy2,
          bzirk type zdsmter-bzirk,
          lls   type p,
          lys   type p,
          cys   type p,
        end of illy2.

types : begin of ilqt1,
          bzirk type zdsmter-bzirk,
          qt1   type p,
          qt2   type p,
          qt3   type p,
          qt4   type p,
        end of ilqt1.

types : begin of ilyt1,
          bzirk type zdsmter-bzirk,
          rm    type zdsmter-bzirk,
          lyt   type p,
          cyt   type p,
          qrt1  type p,
          qrt2  type p,
          qrt3  type p,
          qrt4  type p,
        end of ilyt1.

types : begin of rmt1,
*          bzirk TYPE zdsmter-bzirk,
          rm  type zdsmter-bzirk,
          zm  type zdsmter-bzirk,
          t1  type p,
          t2  type p,
          t3  type p,
          t4  type p,
          t5  type p,
          t6  type p,
          t7  type p,
          t8  type p,
          t9  type p,
          t10 type p,
          t11 type p,
          t12 type p,
        end of rmt1.

types : begin of icys1,
          bzirk          type zdsmter-bzirk,
          qt1            type p,
          qt2            type p,
          qt3            type p,
          qt4            type p,
          cms            type p,
          lms            type p,
          llms           type p,

          llsg           type p,
          ccumm_sale     type p,
          zcumccumm_sale type p,
          lcumm_sale     type p,
        end of icys1.

types : begin of inct1,
          pernr type pa0015-pernr,
          betrg type pa0015-betrg,
        end of inct1.

types : begin of inc1,
          bzirk        type zdsmter-zdsm,
          pernr        type pa0015-pernr,
          osal         type p,
          csal         type p,
          incr         type p,
          incr_dt      type sy-datum,
          increment_dt type sy-datum,
        end of inc1.

types : begin of icmtar,
          bzirk type zdsmter-bzirk,
          ctar  type p,
        end of icmtar.

types : begin of ics,
          bzirk  type zdsmter-bzirk,
          c1sale type p,
          c2sale type p,
          c3sale type p,
          t2     type p,
        end of ics.

types : begin of icptar1,
          bzirk type zdsmter-bzirk,
          t1    type p,
          t2    type p,
          t3    type p,
        end of icptar1.

types : begin of itap1,
          pernr type pa0001-pernr,
        end of itap1.
types : begin of itaz1,
          bzirk type zdsmter-bzirk,
          pernr type pa0001-pernr,
        end of itaz1.

types : begin of itap2,
          pernr      type pa0001-pernr,
          usrid_long type pa0105-usrid_long,
        end of itap2.

types : begin of itaz2,
          bzirk      type zdsmter-bzirk,
          pernr      type pa0001-pernr,
          usrid_long type pa0105-usrid_long,
        end of itaz2.
types : begin of itad1,
          zm    type zdsmter-zdsm,
          dzm   type zdsmter-zdsm,
          rm    type zdsmter-zdsm,
          bzirk type zdsmter-zdsm,
        end of itad1.

types : begin of ctar,
          apr type p,
          may type p,
          jun type p,
          jul type p,
          aug type p,
          sep type p,
          oct type p,
          nov type p,
          dec type p,
          jan type p,
          feb type p,
          mar type p,
        end of ctar.
types : begin of iapr,
          sm     type zdsmter-zdsm,
          zm     type zdsmter-zdsm,
          dzm    type zdsmter-zdsm,
          rm     type zdsmter-zdsm,
          bzirk  type zdsmter-zdsm,
          netval type p,
          tar    type p,
        end of iapr.

types : begin of dlapr,
          bzirk   type zdsmter-bzirk,
          aprsale type p,
          maysale type p,
          junsale type p,
          julsale type p,
          augsale type p,
          sepsale type p,
          octsale type p,
          novsale type p,
          decsale type p,
          jansale type p,
          febsale type p,
          marsale type p,

          aprtar  type p,
          maytar  type p,
          juntar  type p,
          jultar  type p,
          augtar  type p,
          septar  type p,
          octtar  type p,
          novtar  type p,
          dectar  type p,
          jantar  type p,
          febtar  type p,
          martar  type p,

        end of dlapr.

data : it_tab1         type table of itab1,
       wa_tab1         type itab1,
       it_tab2         type table of itab1,
       wa_tab2         type itab1,
       it_tab3         type table of itab1,
       wa_tab3         type itab1,
       it_tab4         type table of itab1,
       wa_tab4         type itab1,
       it_tab5         type table of itab1,
       wa_tab5         type itab1,
       it_tab6         type table of itab6,
       wa_tab6         type itab6,
       it_tab61        type table of itab61,
       wa_tab61        type itab61,
       it_tab7         type table of itab7,
       wa_tab7         type itab7,

       it_smtab7       type table of smitab7,
       wa_smtab7       type smitab7,
       it_smtab71      type table of smitab7,
       wa_smtab71      type smitab7,
       it_tab71        type table of itab7,
       wa_tab71        type itab7,
       it_tab8         type table of itab8,
       wa_tab8         type itab8,

       it_smtab8       type table of smitab8,
       wa_smtab8       type smitab8,

       it_tazm1        type table of itab8,
       wa_tazm1        type itab8,

       it_tab9         type table of itab9,
       wa_tab9         type itab9,

       it_smtab9       type table of smitab9,
       wa_smtab9       type smitab9,

       it_zm3          type table of itab9,
       wa_zm3          type itab9,
       it_rm3          type table of itab9,
       wa_rm3          type itab9,
       it_pso3         type table of itab9,
       wa_pso3         type itab9,

       it_zm1          type table of itab7,
       wa_zm1          type itab7,
       it_zm2          type table of itab8,
       wa_zm2          type itab8,

       it_alv1         type table of alv1,
       wa_alv1         type alv1,
       it_rm1          type table of itab7,
       wa_rm1          type itab7,

       it_tarm1        type table of itab8,
       wa_tarm1        type itab8,

       it_rm2          type table of itab8,
       wa_rm2          type itab8,
       it_pso1         type table of itab7,
       wa_pso1         type itab7,
       it_pso2         type table of itab8,
       wa_pso2         type itab8,

       it_com1         type table of itab7,
       wa_com1         type itab7,
       it_com2         type table of itab8,
       wa_com2         type itab8,

       it_comp1        type table of itab7,
       wa_comp1        type itab7,
       it_comp2        type table of itab8,
       wa_comp2        type itab8,


       it_tac1         type table of itab1,
       wa_tac1         type itab1,
       it_tac2         type table of itab1,
       wa_tac2         type itab1,
       it_tac3         type table of itac3,
       wa_tac3         type itac3,
       it_lly1         type table of illy1,
       wa_lly1         type illy1,
       it_lly2         type table of illy2,
       wa_lly2         type illy2,
       it_ly1          type table of illy1,
       wa_ly1          type illy1,
       it_lyc1         type table of illy1,
       wa_lyc1         type illy1,
       it_llyc1        type table of illy1,
       wa_llyc1        type illy1,
       it_cy1          type table of illy1,
       wa_cy1          type illy1,
       it_rm11         type table of illy1,
       wa_rm11         type illy1,
       it_zm11         type table of illy1,
       wa_zm11         type illy1,
       it_lrm11        type table of illy1,
       wa_lrm11        type illy1,
       it_lzm11        type table of illy1,
       wa_lzm11        type illy1,
       it_llrm11       type table of illy1,
       wa_llrm11       type illy1,
       it_llzm11       type table of illy1,
       wa_llzm11       type illy1,
       it_cy1_pso      type table of illy1,
       wa_cy1_pso      type illy1,
       it_chy1         type table of cilly1,
       wa_chy1         type cilly1,
       it_cyr1         type table of illy1,
       wa_cyr1         type illy1,
       it_cys1         type table of icys1,
       wa_cys1         type icys1,
       it_ly2          type table of illy2,
       wa_ly2          type illy2,
       it_lyc2         type table of illy2,
       wa_lyc2         type illy2,
       it_cy2          type table of illy2,
       wa_cy2          type illy2,
       it_cyr2         type table of illy2,
       wa_cyr2         type illy2,
       it_lqt1         type table of ilqt1,
       wa_lqt1         type ilqt1,
       it_lqtc1        type table of ilqt1,
       wa_lqtc1        type ilqt1,
       it_cqt1         type table of ilqt1,
       wa_cqt1         type ilqt1,
       it_cqtr1        type table of ilqt1,
       wa_cqtr1        type ilqt1,
       it_lyt1         type table of ilyt1,
       wa_lyt1         type ilyt1,
       it_lytq1        type table of ilyt1,
       wa_lytq1        type ilyt1,
       it_cyt1         type table of ilyt1,
       wa_cyt1         type ilyt1,
       it_ccyt1        type table of ilyt1,
       wa_ccyt1        type ilyt1,
       it_ccyt1_pso    type table of ilyt1,
       wa_ccyt1_pso    type ilyt1,
       it_ccyt1_rm     type table of ilyt1,
       wa_ccyt1_rm     type ilyt1,
       it_ccyt1_zm     type table of ilyt1,
       wa_ccyt1_zm     type ilyt1,
       it_ccyt1_dzm    type table of ilyt1,
       wa_ccyt1_dzm    type ilyt1,
       it_cmtar        type table of icmtar,
       wa_cmtar        type icmtar,
       it_cyqt1        type table of ilyt1,
       wa_cyqt1        type ilyt1,
       it_rmt1         type table of rmt1,
       wa_rmt1         type rmt1,
       it_zmt1         type table of rmt1,
       wa_zmt1         type rmt1,
       it_lrmt1        type table of rmt1,
       wa_lrmt1        type rmt1,
       it_lzmt1        type table of rmt1,
       wa_lzmt1        type rmt1,
       it_inct1        type table of inct1,
       wa_inct1        type inct1,
       it_cms          type table of icys1,
       wa_cms          type icys1,
       it_llsg         type table of icys1,
       wa_llsg         type icys1,
       it_cumms1       type table of icys1,
       wa_cumms1       type icys1,
       it_cumms2       type table of icys1,
       wa_cumms2       type icys1,
       it_cumms2_pso   type table of icys1,
       wa_cumms2_pso   type icys1,
       it_cumms2_rm    type table of icys1,
       wa_cumms2_rm    type icys1,
       it_cumms2_zm    type table of icys1,
       wa_cumms2_zm    type icys1,
       it_cumms2_dzm   type table of icys1,
       wa_cumms2_dzm   type icys1,
       it_cummsr2      type table of icys1,
       wa_cummsr2      type icys1,
       it_cummsr2_pso  type table of icys1,
       wa_cummsr2_pso  type icys1,
       it_cummsr2_rm   type table of icys1,
       wa_cummsr2_rm   type icys1,
       it_cummsr2_zm   type table of icys1,
       wa_cummsr2_zm   type icys1,
       it_cummsr2_dzm  type table of icys1,
       wa_cummsr2_dzm  type icys1,
       it_lcumms1      type table of icys1,
       wa_lcumms1      type icys1,
       it_lcummsr1     type table of icys1,
       wa_lcummsr1     type icys1,
       it_lcummsr1_pso type table of icys1,
       wa_lcummsr1_pso type icys1,
       it_lcummsr1_rm  type table of icys1,
       wa_lcummsr1_rm  type icys1,
       it_lcummsr1_zm  type table of icys1,
       wa_lcummsr1_zm  type icys1,
       it_lcummsr1_dzm type table of icys1,
       wa_lcummsr1_dzm type icys1,
       it_lcumms2      type table of icys1,
       wa_lcumms2      type icys1,
       it_inc1         type table of inc1,
       wa_inc1         type inc1,
       it_cs           type table of ics,
       wa_cs           type ics,
       it_cptar1       type table of icptar1,
       wa_cptar1       type icptar1,

       it_tad1         type table of itad1,
       wa_tad1         type itad1,
       it_tad2         type table of itad1,
       wa_tad2         type itad1,
       it_ctar         type table of ctar,
       wa_ctar         type ctar,
       it_apr          type table of iapr,
       wa_apr          type iapr,
       it_may          type table of iapr,
       wa_may          type iapr,
       it_jun          type table of iapr,
       wa_jun          type iapr,
       it_jul          type table of iapr,
       wa_jul          type iapr,
       it_aug          type table of iapr,
       wa_aug          type iapr,
       it_sep          type table of iapr,
       wa_sep          type iapr,
       it_oct          type table of iapr,
       wa_oct          type iapr,
       it_nov          type table of iapr,
       wa_nov          type iapr,
       it_dec          type table of iapr,
       wa_dec          type iapr,
       it_jan          type table of iapr,
       wa_jan          type iapr,
       it_feb          type table of iapr,
       wa_feb          type iapr,
       it_mar          type table of iapr,
       wa_mar          type iapr,

       it_lapr         type table of iapr,
       wa_lapr         type iapr,
       it_lmay         type table of iapr,
       wa_lmay         type iapr,
       it_ljun         type table of iapr,
       wa_ljun         type iapr,
       it_ljul         type table of iapr,
       wa_ljul         type iapr,
       it_laug         type table of iapr,
       wa_laug         type iapr,
       it_lsep         type table of iapr,
       wa_lsep         type iapr,
       it_loct         type table of iapr,
       wa_loct         type iapr,
       it_lnov         type table of iapr,
       wa_lnov         type iapr,
       it_ldec         type table of iapr,
       wa_ldec         type iapr,
       it_ljan         type table of iapr,
       wa_ljan         type iapr,
       it_lfeb         type table of iapr,
       wa_lfeb         type iapr,
       it_lmar         type table of iapr,
       wa_lmar         type iapr,

       it_lcs          type table of ics,
       wa_lcs          type ics,
       it_smlcs        type table of ics,
       wa_smlcs        type ics,

       it_l1cs         type table of ics,
       wa_l1cs         type ics,

       it_sml1cs       type table of ics,
       wa_sml1cs       type ics,

       it_rlcs         type table of ics,
       wa_rlcs         type ics,
       it_zlcs         type table of ics,
       wa_zlcs         type ics,
       it_rl1cs        type table of ics,
       wa_rl1cs        type ics,
       it_zl1cs        type table of ics,
       wa_zl1cs        type ics,
       it_plcs         type table of ics,
       wa_plcs         type ics,
       it_pl1cs        type table of ics,
       wa_pl1cs        type ics,
       it_dlapr        type table of dlapr,
       wa_dlapr        type dlapr,
       it_rdlapr       type table of dlapr,
       wa_rdlapr       type dlapr,
       it_zdlapr       type table of dlapr,
       wa_zdlapr       type dlapr.
types : begin of sm1,
          reg type zdsmter-bzirk,
          sm  type zdsmter-bzirk,
        end of sm1.
types : begin of sm2,
          sm type zdsmter-bzirk,
        end of sm2.

data: it_sm1 type table of sm1,
      wa_sm1 type sm1,
      it_sm2 type table of sm2,
      wa_sm2 type sm2.

types : begin of l1,
          zmonth     type zdsmter-zmonth,
          zyear      type zdsmter-zyear,
          bzirk      type zdsmter-bzirk,
          rm         type zdsmter-bzirk,
          zm         type zdsmter-bzirk,
          zdsm       type zdsmter-zdsm,
          zjoin_date type pa0302-begda,
          rjoin_date type pa0302-begda,
          join_date  type pa0302-begda,
        end of l1.

types : begin of aprcs1,
          zdsm    type zdsmter-bzirk,
          rm      type zdsmter-bzirk,
          zm      type zdsmter-bzirk,
          bzirk   type zdsmter-bzirk,
          aprsale type zrcumpso-netval,
          aprtar  type p,
          maysale type zrcumpso-netval,
          maytar  type p,
          junsale type zrcumpso-netval,
          juntar  type p,
          julsale type zrcumpso-netval,
          jultar  type p,
          augsale type zrcumpso-netval,
          augtar  type p,
          sepsale type zrcumpso-netval,
          septar  type p,
          octsale type zrcumpso-netval,
          octtar  type p,
          novsale type zrcumpso-netval,
          novtar  type p,
          decsale type zrcumpso-netval,
          dectar  type p,
          jansale type zrcumpso-netval,
          jantar  type p,
          febsale type zrcumpso-netval,
          febtar  type p,
          marsale type zrcumpso-netval,
          martar  type p,

        end of aprcs1.

types : begin of cums,
          bzirk type zdsmter-bzirk,
          sale  type p,
        end of cums.

types : begin of dums,
          bzirk   type zdsmter-bzirk,
          aprsale type zrcumpso-netval,
          maysale type zrcumpso-netval,
          junsale type zrcumpso-netval,
          julsale type zrcumpso-netval,
          augsale type zrcumpso-netval,
          sepsale type zrcumpso-netval,
          octsale type zrcumpso-netval,
          novsale type zrcumpso-netval,
          decsale type zrcumpso-netval,
          jansale type zrcumpso-netval,
          febsale type zrcumpso-netval,
          marsale type zrcumpso-netval,
        end of dums.

data : it_l1          type table of l1,
       wa_l1          type l1,
       it_l2          type table of l1,
       wa_l2          type l1,
       it_aprcs1      type table of aprcs1,
       wa_aprcs1      type aprcs1,
       it_laprcs1     type table of aprcs1,
       wa_laprcs1     type aprcs1,
       it_llaprcs1    type table of aprcs1,
       wa_llaprcs1    type aprcs1,
       it_lylaprcs1   type table of aprcs1,
       wa_lylaprcs1   type aprcs1,
       it_l1aprcs1    type table of aprcs1,
       wa_l1aprcs1    type aprcs1,
       it_nl1aprcs1   type table of aprcs1,  "ADDED ON 20.6.24
       wa_nl1aprcs1   type aprcs1,
       it_ll1aprcs1   type table of aprcs1,
       wa_ll1aprcs1   type aprcs1,
       it_lyl1aprcs1  type table of aprcs1,
       wa_lyl1aprcs1  type aprcs1,
       it_caprcs1     type table of aprcs1,
       wa_caprcs1     type aprcs1,
       it_taprcs1     type table of aprcs1,
       wa_taprcs1     type aprcs1,
       it_rrtaprcs1   type table of aprcs1,
       wa_rrtaprcs1   type aprcs1,
       it_ltaprcs1    type table of aprcs1,
       wa_ltaprcs1    type aprcs1,
       it_lltaprcs1   type table of aprcs1,
       wa_lltaprcs1   type aprcs1,
       it_lyltaprcs1  type table of aprcs1,
       wa_lyltaprcs1  type aprcs1,
       it_l1taprcs1   type table of aprcs1,
       wa_l1taprcs1   type aprcs1,
       it_ll1taprcs1  type table of aprcs1,
       wa_ll1taprcs1  type aprcs1,
       it_lyl1taprcs1 type table of aprcs1,
       wa_lyl1taprcs1 type aprcs1,

       it_raprcs1     type table of aprcs1,
       wa_raprcs1     type aprcs1,
       it_rlaprcs1    type table of aprcs1,
       wa_rlaprcs1    type aprcs1,
       it_rcaprcs1    type table of aprcs1,
       wa_rcaprcs1    type aprcs1,
       it_rtaprcs1    type table of aprcs1,
       wa_rtaprcs1    type aprcs1,

       it_paprcs1     type table of aprcs1,
       wa_paprcs1     type aprcs1,
       it_plaprcs1    type table of aprcs1,
       wa_plaprcs1    type aprcs1,
       it_pcaprcs1    type table of aprcs1,
       wa_pcaprcs1    type aprcs1,
       it_ptaprcs1    type table of aprcs1,
       wa_ptaprcs1    type aprcs1,

       it_cums        type table of cums,
       wa_cums        type cums,
       it_smcums      type table of cums,
       wa_smcums      type cums,
       it_rrcums      type table of dums,
       wa_rrcums      type dums,
       it_zzcums      type table of dums,
       wa_zzcums      type dums,
       it_ccums       type table of cums,
       wa_ccums       type cums,
       it_lcums       type table of cums,
       wa_lcums       type cums,
       it_smlcums     type table of cums,
       wa_smlcums     type cums,
       it_rrlcums     type table of dums,
       wa_rrlcums     type dums,
       it_llcums      type table of cums,
       wa_llcums      type cums,
       it_yllcums     type table of cums,
       wa_yllcums     type cums,
*       it_l1cums   TYPE TABLE OF cums,
*       wa_l1cums   TYPE cums,
       it_tcums       type table of cums,
       wa_tcums       type cums,
       it_smtcums     type table of cums,
       wa_smtcums     type cums,
       it_rrtcums     type table of dums,
       wa_rrtcums     type dums,
       it_zztcums     type table of dums,
       wa_zztcums     type dums,
       it_ltcums      type table of cums,
       wa_ltcums      type cums,
       it_lltcums     type table of cums,
       wa_lltcums     type cums,
       it_ylltcums    type table of cums,
       wa_ylltcums    type cums,
       it_rcums       type table of cums,
       wa_rcums       type cums,
       it_rccums      type table of cums,
       wa_rccums      type cums,
       it_rlcums      type table of cums,
       wa_rlcums      type cums,
       it_rtcums      type table of cums,
       wa_rtcums      type cums,
       it_pcums       type table of cums,
       wa_pcums       type cums,
       it_pccums      type table of cums,
       wa_pccums      type cums,
       it_plcums      type table of cums,
       wa_plcums      type cums,
       it_ptcums      type table of cums,
       wa_ptcums      type cums,
       it_dums        type table of dums,
       wa_dums        type dums,
       it_ldums       type table of dums,
       wa_ldums       type dums,
       it_lldums      type table of dums,
       wa_lldums      type dums,
       it_ylldums     type table of dums,
       wa_ylldums     type dums,
       it_l1dums      type table of dums,
       wa_l1dums      type dums,
       it_n1l1aprcs1  type table of dums,
       wa_n1l1aprcs1  type dums,
       it_r1l1aprcs1  type table of dums,
       wa_r1l1aprcs1  type dums,
       it_z1l1aprcs1  type table of dums,
       wa_z1l1aprcs1  type dums,
       it_sml1dums    type table of dums,
       wa_sml1dums    type dums,
       it_rl1dums     type table of dums,
       wa_rl1dums     type dums,
       it_zl1dums     type table of dums,
       wa_zl1dums     type dums,
       it_ll1dums     type table of dums,
       wa_ll1dums     type dums,
       it_smll1dums   type table of dums,
       wa_smll1dums   type dums,
       it_rll1dums    type table of dums,
       wa_rll1dums    type dums,
       it_zll1dums    type table of dums,
       wa_zll1dums    type dums,
       it_yll1dums    type table of dums,
       wa_yll1dums    type dums,
       it_smyll1dums  type table of dums,
       wa_smyll1dums  type dums,
       it_ryll1dums   type table of dums,
       wa_ryll1dums   type dums,
       it_zyll1dums   type table of dums,
       wa_zyll1dums   type dums,
       it_dcums       type table of dums,
       wa_dcums       type dums,
       it_smdcums     type table of dums,
       wa_smdcums     type dums,
       it_rdcums      type table of dums,
       wa_rdcums      type dums,
       it_zdcums      type table of dums,
       wa_zdcums      type dums,
       it_tdums       type table of dums,
       wa_tdums       type dums,
       it_smtdums     type table of dums,
       wa_smtdums     type dums,
       it_rtdums      type table of dums,
       wa_rtdums      type dums,
       it_ztdums      type table of dums,
       wa_ztdums      type dums,
       it_ltdums      type table of dums,
       wa_ltdums      type dums,
       it_lltdums     type table of dums,
       wa_lltdums     type dums,
*       it_Rlltdums     TYPE TABLE OF dums,
*       wa_Rlltdums     TYPE dums,
       it_ylltdums    type table of dums,
       wa_ylltdums    type dums,
       it_l1tdums     type table of dums,
       wa_l1tdums     type dums,
       it_ll1tdums    type table of dums,
       wa_ll1tdums    type dums,
       it_smll1tdums  type table of dums,
       wa_smll1tdums  type dums,
       it_rll1tdums   type table of dums,
       wa_rll1tdums   type dums,
       it_zll1tdums   type table of dums,
       wa_zll1tdums   type dums,
       it_yll1tdums   type table of dums,
       wa_yll1tdums   type dums.

data : aprsale type p,
       aprtar  type p,
       maysale type p,
       maytar  type p,
       junsale type p,
       juntar  type p,
       julsale type p,
       jultar  type p,
       augsale type p,
       augtar  type p,
       sepsale type p,
       septar  type p,
       octsale type p,
       octtar  type p,
       novsale type p,
       novtar  type p,
       decsale type p,
       dectar  type p,
       jansale type p,
       jantar  type p,
       febsale type p,
       febtar  type p,
       marsale type p,
       martar  type p.

data : cs13 type p,
       cs12 type p,
       cs11 type p.

data : v1  type p,
       v2  type p,
       v3  type p,
       v4  type p,
       v5  type p,
       v6  type p,
       v7  type p,
       v8  type p,
       v9  type p,
       v10 type p,
       v11 type p,
       v12 type p.

data : it_tap1 type table of itap1,
       wa_tap1 type itap1,
       it_tap2 type table of itap2,
       wa_tap2 type itap2,
       it_taz1 type table of itaz1,
       wa_taz1 type itaz1,
       it_taz2 type table of itaz2,
       wa_taz2 type itaz2.

data : lysale   type p,
       cysale   type p,
       lysalec  type p,
       prom(7)  type c,
       prom1(6) type c,
       l1       type p.

data : lsqrt5  type p,
       lsqrtc5 type p,
       cqtr    type p,
       lcummsr.

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
data : it_zdsmter1  type table of zdsmter,
       wa_zdsmter1  type zdsmter,
       it_zdsmter_1 type table of zdsmter,
       wa_zdsmter_1 type zdsmter,
       it_zdsmter_2 type table of zdsmter,
       wa_zdsmter_2 type zdsmter.

data : msg       type string,
       wa_d1(10) type c,
       wa_d2(10) type c.
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

data : p1(2)      type c,
       p2(2)      type c,
       y1(4)      type c,
       y11(4)     type c,
       s1         type sy-datum,
       date1      type sy-datum,
       date2      type sy-datum,
       date4      type sy-datum,
       date5      type sy-datum,
       p1date     type sy-datum,
       p2date     type sy-datum,
       p1month(2) type c,
       p1year(4)  type c,
       p2month(2) type c,
       p2year(4)  type c,
       csale      type p,
       ctarget    type p,
       lsale      type p,
       ltarget    type p,
       llsale     type p,
       lltarget   type p,
       cm         type p,
       lm         type p,
       llm        type p,
       ldt1       type sy-datum,
       ldt2       type sy-datum,
       c1sale     type p,
       c2sale     type p,
       c3sale     type p.

data : csl1 type p,
       cst1 type p,
       csl2 type p,
       cst2 type p,
       csl3 type p,
       cst3 type p,
       csl4 type p,
       cst4 type p,
       c1   type p,
       c2   type p,
       c3   type p,
       c4   type p,
       c5   type p.

data : m1 type p,
       m2 type p,
       m3 type p.

data : lpqrt1 type p,
       lpqrt2 type p,
       lpqrt3 type p,
       lpqrt4 type p,
       lpqrt  type p,

       cpqrt1 type p,
       cpqrt2 type p,
       cpqrt3 type p,
       cpqrt4 type p,

       csqrt1 type p,
       csqrt2 type p,
       csqrt3 type p,
       csqrt4 type p,

       ctqrt1 type p,
       ctqrt2 type p,
       ctqrt3 type p,
       ctqrt4 type p.


data : f1(2)         type c,
       cyear(4)      type c,
       ccyear(4)     type c,
       lyear(4)      type c,
       llyear(4)     type c,
       qrt1          type sy-datum,
       lqrt1         type sy-datum,
       fmonth(2)     type c,
       fdate         type sy-datum,
       f1date        type sy-datum,
       f2date        type sy-datum,
       f3date        type sy-datum,
       f4date        type sy-datum,
       f5date        type sy-datum,
       f6date        type sy-datum,
       f7date        type sy-datum,
       f8date        type sy-datum,
       f9date        type sy-datum,
       f10date       type sy-datum,
       f11date       type sy-datum,
       f12date       type sy-datum,

       s1date        type sy-datum,
       s2date        type sy-datum,
       s3date        type sy-datum,
       s4date        type sy-datum,
       s5date        type sy-datum,
       s6date        type sy-datum,
       s7date        type sy-datum,
       s8date        type sy-datum,
       s9date        type sy-datum,
       s10date       type sy-datum,
       s11date       type sy-datum,
       s12date       type sy-datum,

*       YEAR(4) TYPE C,
       lls           type p,
       sale          type p,
       qt1           type p,
       qt2           type p,
       qt3           type p,
       qt4           type p,
       lyt           type p,
       t_sale        type p,
       cumm          type p decimals 2,
       lys           type p,
       lgrw          type p decimals 2,
       cgrw          type p decimals 2,
       cyt           type p,
       tar           type p,
       t1            type p,
       t2            type p,
       t3            type p,
       t4            type p,
       t5            type p,
       t6            type p,
       t7            type p,
       t8            type p,
       t9            type p,
       t10           type p,
       t11           type p,
       t12           type p,

       zcumt1        type p,
       zcumt2        type p,
       zcumt3        type p,
       zcumt4        type p,
       zcumt5        type p,
       zcumt6        type p,
       zcumt7        type p,
       zcumt8        type p,
       zcumt9        type p,
       zcumt10       type p,
       zcumt11       type p,
       zcumt12       type p,

       q1            type p,
       q2            type p,
       q3            type p,
       q4            type p,
       inct          type p,
       lls1          type p,
       lls2          type p,
       lls3          type p,
       lls4          type p,
       lls5          type p,
       lls6          type p,
       lls7          type p,
       lls8          type p,
       lls9          type p,
       lls10         type p,
       lls11         type p,
       lls12         type p,
       llsg          type p,
       cumm_sale     type p,
       zcumcumm_sale type p,
       cumm_tar      type p,
       lcumm_sale    type p,
       lygrw         type p,
       lcumm         type p,
       ccumm         type p,
       cumms         type p,
       ly(5)         type c,
       cy(5)         type c,
       div(3)        type c,
       ltqrt         type p,
       llsqrt        type p,
       csqrt         type p,
       lsqrt         type p,
       cp1           type p,
       cp2           type p,
       cp3           type p,
       join_date     type sy-datum,
       ctar          type p,
       sl1           type p,
       sl2           type p,
       sl3           type p,
       cums          type p,
       lcums         type p,
       cum1          type p,
       cum2          type p,
       lycs          type p,
       lyct          type p.

data : tyear(4) type c.

data : ldate  type sy-datum,
       lldate type sy-datum,
       yr(4)  type c.

data : join_dt  type sy-datum,
       join_dtn type sy-datum,
       join_dts type sy-datum.

data : lchk_dt1   type sy-datum,
       lchk_dt2   type sy-datum,
       lchk_dt3   type sy-datum,
       lchk_dt4   type sy-datum,
       lchk_dt5   type sy-datum,
       lchk_dt6   type sy-datum,
       lchk_dt7   type sy-datum,
       lchk_dt8   type sy-datum,
       lchk_dt9   type sy-datum,
       lchk_dt10  type sy-datum,
       lchk_dt11  type sy-datum,
       lchk_dt12  type sy-datum,

       llchk_dt1  type sy-datum,
       llchk_dt2  type sy-datum,
       llchk_dt3  type sy-datum,
       llchk_dt4  type sy-datum,
       llchk_dt5  type sy-datum,
       llchk_dt6  type sy-datum,
       llchk_dt7  type sy-datum,
       llchk_dt8  type sy-datum,
       llchk_dt9  type sy-datum,
       llchk_dt10 type sy-datum,
       llchk_dt11 type sy-datum,
       llchk_dt12 type sy-datum,

       chk_dt1    type sy-datum,
       chk_dt2    type sy-datum,
       chk_dt3    type sy-datum,
       chk_dt4    type sy-datum,
       chk_dt5    type sy-datum,
       chk_dt6    type sy-datum,
       chk_dt7    type sy-datum,
       chk_dt8    type sy-datum,
       chk_dt9    type sy-datum,
       chk_dt10   type sy-datum,
       chk_dt11   type sy-datum,
       chk_dt12   type sy-datum,

       ly_dt1     type sy-datum,
       ly_dt2     type sy-datum,
       ly_dt3     type sy-datum,
       ly_dt4     type sy-datum,
       ly_dt5     type sy-datum,
       ly_dt6     type sy-datum,
       ly_dt7     type sy-datum,
       ly_dt8     type sy-datum,
       ly_dt9     type sy-datum,
       ly_dt10    type sy-datum,
       ly_dt11    type sy-datum,
       ly_dt12    type sy-datum.

data : g_sal1       type p,
       g_sal2       type p,
       g_sal3       type p,
       incr         type p,
       ndate        type sy-datum,
       incr_dt      type sy-datum,
       incrdt(7)    type c,
       date3        type sy-datum,
       increment_dt type sy-datum.

data : nmonth1(3) type c,
       nmonth2(3) type c,
       nmonth3(3) type c.
data: nmon3(8) type c,
      nmon2(8) type c,
      nmon1(8) type c.

data : page1       type i value 1,
       page2       type i,
       page3       type i,
       rm_name     type pa0001-ename,
       zm_name     type pa0001-ename,
       rm_short    type zfsdes-short,
       pjoin_dt(7) type c,
       zone        type zthr_heq_des-zz_hqdesc,
       rm_zone     type zthr_heq_des-zz_hqdesc,
       zdiff       type p,
       dzmdiff     type p,
       rdiff       type p,
       pdiff       type p.

data : ls1  type p,
       lt1  type p,
       ls2  type p,
       lt2  type p,
       ls3  type p,
       lt3  type p,
       ls4  type p,
       lt4  type p,
       lsc1 type p,
       lsc2 type p,
       lsc3 type p,
       lsc4 type p,
       cs1  type p,
       cs2  type p,
       cs3  type p,
       cs4  type p.

data : ddiv(3) type c,
       a       type i,
       b       type i,
       grw1    type i,
       grw2    type i,
       per1    type i,
       per2    type i.

data : w1(8)    type c,
       w2(4)    type c,
       w3(3)    type c,
       w4(24)   type c,
       w5       type i,
       w6(6)    type c,
       w7(6)    type c,
       nyear(4) type c.
data : yr1(4) type c.

data : zsr11_wa type zsr11.
data : divtxt(3) type c,
       pdiv(9)   type c,
       pdiv1(4)  type c.
data : totpsodt type sy-datum.

data : confprob(1) type c.
data : rconfprob(1) type c.
data : zconfprob(1) type c.
data : dconfprob(1) type c.
data: smname type pa0001-ename.


selection-screen begin of block b1 with frame title text-005.
select-options : org for zdsmter-zdsm matchcode object zsr9_1 .
parameters : month   type zcumpsow-zmonth obligatory,
             year(4) type c.
parameters : z1 radiobutton group r3,
             z2 radiobutton group r3,
             z3 radiobutton group r3.
selection-screen end of block b1.

selection-screen begin of block b2 with frame title text-004.
parameters : r1  radiobutton group r1,
             r2  radiobutton group r1 default 'X',
             r21 radiobutton group r1,
             r22 radiobutton group r1,
             r4  radiobutton group r1,
             r6  radiobutton group r1,
             r5  radiobutton group r1,
             r3  radiobutton group r1.
parameter : uemail(70) type c.
parameters : sm like zdsmter-zdsm matchcode object zsr9_5.
*matchcode object zsr9_4 .
parameters :
  r7  radiobutton group r1,
  r7p radiobutton group r1.

parameters : ctot as checkbox.
selection-screen end of block b2.

selection-screen begin of block b3 with frame title text-001.
parameters : d1 radiobutton group d1,
*             D2 RADIOBUTTON GROUP D1,
*             D3 RADIOBUTTON GROUP D1,
             d4 radiobutton group d1,
             d6 radiobutton group d1,  "BC-LS DIV
             d5 radiobutton group d1.
selection-screen end of block b3.

selection-screen begin of block b4 with frame title text-002.
parameters : gr1 radiobutton group gr1 default 'X',
             gr2 radiobutton group gr1,
             gr3 radiobutton group gr1.
selection-screen end of block b4.

selection-screen begin of block b5 with frame title text-003.
parameters : pr1 radiobutton group pr1 default 'X',
             pr2 radiobutton group pr1,
             pr3 radiobutton group pr1.
parameters : upd as checkbox.
selection-screen end of block b5.

initialization.
  g_repid = sy-repid.

at selection-screen.

***************************
  if r7 eq 'X' or r7p eq 'X'.
    if sm is initial.
      message 'ENTER SM ' type 'E'.
    endif.
    select * from zdsmter into table it_zdsmter_2 where zmonth eq month and zyear eq year and zdsm eq sm.
    if sy-subrc eq 0.
      select * from zdsmter into table it_zdsmter1 for all entries in it_zdsmter_2 where zmonth eq month and zyear eq year and zdsm eq it_zdsmter_2-bzirk.
      if sy-subrc ne 0.
        exit.
      endif.
    endif.
  else.
    if org is initial.
      message 'ENTER ZONE' type 'E'.
    endif.
    select * from zdsmter into table it_zdsmter1 where zmonth eq month and zyear eq year and zdsm in org.
    if sy-subrc ne 0.
      exit.
    endif.
  endif.
***************************

*  select * from zdsmter into table it_zdsmter1 where zdsm in org.

  loop at it_zdsmter1 into wa_zdsmter1.
    authority-check object 'ZON1_1'
           id 'ZDSM' field wa_zdsmter1-zdsm.
    if sy-subrc <> 0.
      concatenate 'No authorization for Zone' wa_zdsmter1-zdsm into msg
      separated by space.
      message msg type 'E'.
    endif.
  endloop.
  if r3 eq 'X'.
    if uemail eq '                                                                     '.
      message 'ENTER EMAIL ID' type 'E'.
    endif.
  endif.

  if upd eq 'X' and r2 ne 'X'.
    message 'TO UPDATE DATA SELECT LAYOUT VIEW' type 'E'.
  endif.

  s1+6(2) = '15'.
  s1+4(2) = month.
  s1+0(4) = year.

  date1+6(2) = '01'.
  date1+4(2) = month.
  date1+0(4) = year.

  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date           = date1
    importing
*     EV_MONTH_BEGIN_DATE       =
      ev_month_end_date = date2.

at selection-screen output.
*  MONTH = SY-DATUM+4(2).
*  year = sy-datum+0(4).

start-of-selection.

  totpsodt = sy-datum.
  totpsodt+0(4) = year.
  totpsodt+4(2) = month.
  totpsodt+6(2) = '01'.

  yr1 = year.
*  WRITE : / 's1',s1.

  nyear = year.
*WRITE : 'YEAR',NYEAR,YEAR.



  if r7 eq 'X' or r7p eq 'X'.
    select * from zdsmter into table it_zdsmter_2 where zmonth eq month and zyear eq year and zdsm eq sm.
    if sy-subrc eq 0.
      select * from zdsmter into table it_zdsmter for all entries in it_zdsmter_2 where zmonth eq month and zyear eq year and zdsm eq it_zdsmter_2-bzirk.
      if sy-subrc ne 0.
        exit.
      endif.
    endif.

  else.
    select * from zdsmter into table it_zdsmter where zmonth eq month and zyear eq year and zdsm in org.
    if sy-subrc ne 0.
      exit.
    endif.
  endif.


*  break-point.
  if r7 eq 'X' or r7p eq 'X'.
    loop at it_zdsmter_2 into wa_zdsmter_2.
      org-sign = 'I'.
      org-option = 'EQ'.
      org-low = wa_zdsmter_2-bzirk.
      append org.
      clear org.
    endloop.
  endif.
*  break-point.
*  select * from zdsmter into table it_zdsmter where zmonth eq month and zyear eq year and zdsm in org.
*  if sy-subrc ne 0.
*    exit.
*  endif.

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
*    wa_tab2-text = 'INDIRECT'.
    wa_tab2-reg = wa_tab1-reg.
    wa_tab2-spart = wa_tab1-spart.
    wa_tab2-zm = wa_tab1-zm.
    wa_tab2-rm = wa_tab1-rm.
    collect wa_tab2 into it_tab2.
    clear wa_tab2.
  endloop.

*****************************
  loop at it_zdsmter into wa_zdsmter where bzirk+0(2) cs 'R-'.
    wa_tac1-reg = wa_zdsmter-zdsm.
    wa_tac1-rm = wa_zdsmter-bzirk.
    collect wa_tac1 into it_tac1.
    clear wa_tac1.
  endloop.

  loop at it_tac1 into wa_tac1.
*    wa_tab2-TEXT = 'DIRECT'.
    wa_tab2-reg = wa_tac1-reg.
    wa_tab2-rm = wa_tac1-rm.
    collect wa_tab2 into it_tab2.
    clear wa_tab2.
  endloop.

  loop at it_tab2 into wa_tab2.
    select * from zdsmter where zdsm eq wa_tab2-rm and zmonth eq month and zyear eq year.
      if sy-subrc eq 0.
        select single * from yterrallc where spart eq zdsmter-spart and bzirk eq zdsmter-bzirk and begda le date1 and endda ge date2.
        if sy-subrc eq 0.

*         WRITE : / '**',WA_TAb2-TEXT, 'reg',WA_tab2-REG,'zm',WA_tab2-ZM,'rm',WA_tab2-RM.
*        WRITE :  zdsmter-bzirk,zdsmter-spart.
*        wa_tac2-text = WA_TAb2-TEXT.
          wa_tac2-reg = wa_tab2-reg.
*        wa_tac2-zm = wa_tab2-zm.
          wa_tac2-rm = wa_tab2-rm.
          wa_tac2-bzirk = zdsmter-bzirk.
          wa_tac2-spart = zdsmter-spart.
          collect wa_tac2 into it_tac2.
          clear wa_tac2.
        endif.
      endif.
    endselect.
  endloop.
*  uline.

*  LOOP at it_tac2 INTO wa_tac2.
*    WRITE : /'reg',wa_tac2-reg,'zm',wa_tac2-zm,'rm',wa_tac2-rm,'bzirk',wa_tac2-bzirk,'div',wa_tac2-spart.
*  ENDLOOP.

  if it_tac2 is not initial.
    select * from yterrallc into table it_yterrallc for all entries in it_tac2 where spart eq it_tac2-spart and bzirk eq it_tac2-bzirk
      and begda le date1 and endda ge date2.
  endif.
  sort it_yterrallc.
  loop at it_tac2 into wa_tac2.
*    WRITE : /'reg',wa_tac2-reg,'zm',wa_tac2-zm,'rm',wa_tac2-rm,'bzirk',wa_tac2-bzirk.
*    READ TABLE it_yterrallc INTO wa_yterrallc WITH KEY bzirk = wa_tac2-bzirk.
*    SELECT SINGLE * FROM yterrallc WHERE bzirk eq wa_tac2-bzirk AND endda ge date2.
*    IF sy-subrc EQ 0.
*      WRITE : wa_yterrallc-plans.
    wa_tab3-reg = wa_tac2-reg.
    wa_tab3-rm = wa_tac2-rm.
    read table it_tab1 into wa_tab1 with key rm = wa_tac2-rm.
    if sy-subrc eq 0.
      wa_tab3-zm = wa_tab1-zm.
    endif.
*      select single * from zdsmter where zmonth eq month and zyear eq year and bzirk eq wa_tac2-rm.
*      if sy-subrc eq 0 and zdsmter-zdsm+0(2) cs 'Z-'.
*        wa_tab3-zm = zdsmter-zdsm.
*      endif.
    wa_tab3-bzirk = wa_tac2-bzirk.
    select single * from yterrallc where bzirk eq wa_tac2-bzirk and endda ge date2.
    if sy-subrc eq 0.
      wa_tab3-plans = yterrallc-plans.
    endif.
    collect wa_tab3 into it_tab3.
    clear wa_tab3.
*    ENDIF.
  endloop.
  sort it_tab3.

  loop at it_tab3 into wa_tab3.
*    WRITE : / wa_tab3-reg,wa_tab3-zm,wa_tab3-rm,wa_tab3-bzirk,wa_tab3-plans.

*      WRITE : pa0001-ename.
    wa_tab4-reg = wa_tab3-reg.
    wa_tab4-zm = wa_tab3-zm.
    wa_tab4-rm = wa_tab3-rm.
    wa_tab4-bzirk = wa_tab3-bzirk.
    wa_tab4-plans = wa_tab3-plans.
    select single * from zdrphq where bzirk eq wa_tab3-bzirk.
    if sy-subrc eq 0.
      select single * from  zthr_heq_des where zz_hqcode eq zdrphq-zz_hqcode.
      if sy-subrc eq 0.
        wa_tab4-zz_hqdesc =  zthr_heq_des-zz_hqdesc.
      endif.
    endif.
    select single * from pa0001 where plans eq wa_tab3-plans and begda le s1 and endda ge date2.
    if sy-subrc eq 0.
      wa_tab4-ename = pa0001-ename.
      wa_tab4-pernr = pa0001-pernr.
      select single * from pa0302 where pernr eq pa0001-pernr.
      if sy-subrc eq 0.
        wa_tab4-join_dt = pa0302-begda.
      endif.
    else.
      wa_tab4-ename = 'VACANT (Since)'.
    endif.
    collect wa_tab4 into it_tab4.
    clear wa_tab4.
  endloop.

  loop at it_tab4 into wa_tab4.
*    WRITE : / wa_tab4-reg,wa_tab4-rm,wa_tab4-bzirk,wa_tab4-plans,wa_tab4-ename,wa_tab4-zz_hqdesc,wa_tab4-join_dt.
    wa_tab5-reg = wa_tab4-reg.
    select single * from zdsmter where zmonth eq month and zyear eq year and bzirk eq wa_tab4-reg.
    if sy-subrc eq 0.
      wa_tab5-sm = zdsmter-zdsm.
    endif.
    wa_tab5-zm = wa_tab4-zm.
    wa_tab5-rm = wa_tab4-rm.
    wa_tab5-bzirk = wa_tab4-bzirk.
    wa_tab5-plans = wa_tab4-plans.
    wa_tab5-ename = wa_tab4-ename.
    wa_tab5-pernr = wa_tab4-pernr.
    wa_tab5-zz_hqdesc = wa_tab4-zz_hqdesc.
    wa_tab5-join_dt = wa_tab4-join_dt.

*****************************DIVISION*********************************
    select single * from zdsmter where zmonth eq month and zyear eq year and bzirk eq wa_tab4-bzirk and spart eq '50'.
    if sy-subrc eq 0.
      select single * from zdsmter where zmonth eq month and zyear eq year and bzirk eq wa_tab4-bzirk and spart eq '60'.
      if sy-subrc eq 0.
*        WRITE : 'BCL'.
        wa_tab5-div = 'BCL'.
      else.
*        WRITE : 'BC'.
        wa_tab5-div = 'BC'.
      endif.
    else.
      select single * from zdsmter where zmonth eq month and zyear eq year and bzirk eq wa_tab4-bzirk and spart eq '70'.
      if sy-subrc = 0.
        wa_tab5-div = 'LS'.
      else.
*      WRITE : 'XL'.
        wa_tab5-div = 'XL'.
      endif.
    endif.
***********************************************************************
    collect wa_tab5 into it_tab5.
    clear wa_tab5.
  endloop.
*  if it_tab5 is not initial.
*    select * from pa0001 into table it_pa0001 for all entries in it_tab5 where pernr eq it_tab5-pernr.
*  endif.
*  sort it_pa0001 descending by begda.

  loop at it_tab5 into wa_tab5.
    clear : join_dt, join_dtn.
*    WRITE : / wa_tab5-reg,wa_tab5-rm,wa_tab5-bzirk,wa_tab5-plans,wa_tab5-pernr,wa_tab5-ename,wa_tab5-zz_hqdesc,wa_tab5-join_dt,wa_tab5-div.
    wa_tab6-reg = wa_tab5-reg.
    wa_tab6-zm = wa_tab5-zm.
    wa_tab6-rm = wa_tab5-rm.
    wa_tab6-bzirk = wa_tab5-bzirk.
    wa_tab6-plans = wa_tab5-plans.
    wa_tab6-ename = wa_tab5-ename.
    wa_tab6-pernr = wa_tab5-pernr.
    wa_tab6-zz_hqdesc = wa_tab5-zz_hqdesc.
    wa_tab6-join_dt = wa_tab5-join_dt.

    select single * from yterrallc where bzirk eq wa_tab5-zm and endda ge sy-datum.
    if sy-subrc eq 0.
      select single * from pa0001 where plans eq yterrallc-plans and endda ge sy-datum.
      if sy-subrc eq 0.
        wa_tab6-dzmpernr = pa0001-pernr.
        if pa0001-ansvh = '02'.
          wa_tab6-zconf_prob = 'P'.
        elseif pa0001-ansvh = '03'.
          wa_tab6-zconf_prob = 'T'.
        endif.
        select single * from pa0302 where pernr eq pa0001-pernr and massn eq '01'.
        if sy-subrc eq 0.
          wa_tab6-dzmjoin_date = pa0302-begda.
        endif.
      endif.
    endif.

    select single * from yterrallc where bzirk eq wa_tab5-rm and endda ge sy-datum.
    if sy-subrc eq 0.
      select single * from pa0001 where plans eq yterrallc-plans and endda ge sy-datum.
      if sy-subrc eq 0.
        wa_tab6-rmpernr = pa0001-pernr.
        if pa0001-ansvh = '02'.
          wa_tab6-rconf_prob = 'P'.
        elseif pa0001-ansvh = '03'.
          wa_tab6-rconf_prob = 'T'.
        endif.
        select single * from pa0302 where pernr eq pa0001-pernr and massn eq '01'.
        if sy-subrc eq 0.
          wa_tab6-rmjoin_date = pa0302-begda.
        endif.
      endif.
    endif.

    select single * from yterrallc where bzirk eq wa_tab5-reg and endda ge sy-datum.
    if sy-subrc eq 0.
      select single * from pa0001 where plans eq yterrallc-plans and endda ge sy-datum.
      if sy-subrc eq 0.
        wa_tab6-zmpernr = pa0001-pernr.
        if pa0001-ansvh = '02'.
          wa_tab6-dconf_prob = 'P'.
        elseif pa0001-ansvh = '03'.
          wa_tab6-dconf_prob = 'T'.
        endif.
        select single * from pa0302 where pernr eq pa0001-pernr and massn eq '01'.
        if sy-subrc eq 0.
          wa_tab6-zmjoin_date = pa0302-begda.
        endif.
      endif.
    endif.

    if wa_tab5-join_dt+6(2) le '15'.
      join_dts = wa_tab5-join_dt.
      join_dts+6(2) = '01'.
      wa_tab6-join_date = join_dts.
    else.
      join_dt = wa_tab5-join_dt.
      join_dt+6(2) = '01'.
      call function 'RE_ADD_MONTH_TO_DATE'
        exporting
          months  = '1'
          olddate = join_dt
        importing
          newdate = join_dtn.
      wa_tab6-join_date = join_dtn.
    endif.
    wa_tab6-div = wa_tab5-div.
*    read table it_pa0001 into wa_pa0001 with key pernr = wa_tab5-pernr.
*    if sy-subrc eq 0.
*      if wa_pa0001-ansvh eq '02'.
**        WRITE : 'P'.
*        wa_tab6-typ = 'P'.
*      elseif wa_pa0001-ansvh eq '03'.
**        WRITE : 'T'.
*        wa_tab6-typ = 'T'.
*      endif.
*
**      WRITE : '**',wa_pa0001-ansvh.
**      select SINGLE * FROM t542t WHERE spras eq 'EN' AND MOLGA EQ '40' AND ANSVH EQ wa_pa0001-ansvh.
**      IF SY-SUBRC EQ 0.
**        WRITE : T542T-ATX.
**      ENDIF.
*    endif.
    collect wa_tab6 into it_tab6.
    clear wa_tab6.
  endloop.




  if month lt '04'.
    cyear = year - 1.
  else.
    cyear = year.
  endif.
  ccyear = cyear + 1.
  lyear = cyear - 1.
  llyear = lyear - 1.
*  WRITE : / MONTH,YEAR,DATE1,DATE2,CYEAR,LYEAR,LLYEAR.
  qrt1+6(2) = '01'.
  qrt1+4(2) = '04'.
  qrt1+0(4) = lyear.


  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date           = qrt1
    importing
*     EV_MONTH_BEGIN_DATE       =
      ev_month_end_date = lqrt1.
*  WRITE : 'QRT1',QRT1,LQRT1.



  llchk_dt1+6(2) = '01'.
  llchk_dt1+4(2) = '04'.
  llchk_dt1+0(4) = llyear.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '1'
      olddate = llchk_dt1
    importing
      newdate = llchk_dt2.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '2'
      olddate = llchk_dt1
    importing
      newdate = llchk_dt3.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '3'
      olddate = llchk_dt1
    importing
      newdate = llchk_dt4.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '4'
      olddate = llchk_dt1
    importing
      newdate = llchk_dt5.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '5'
      olddate = llchk_dt1
    importing
      newdate = llchk_dt6.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '6'
      olddate = llchk_dt1
    importing
      newdate = llchk_dt7.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '7'
      olddate = llchk_dt1
    importing
      newdate = llchk_dt8.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '8'
      olddate = llchk_dt1
    importing
      newdate = llchk_dt9.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '9'
      olddate = llchk_dt1
    importing
      newdate = llchk_dt10.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '10'
      olddate = llchk_dt1
    importing
      newdate = llchk_dt11.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '11'
      olddate = llchk_dt1
    importing
      newdate = llchk_dt12.

*  WRITE : / 'last to last financial year date',llchk_dt1,llchk_dt2,llchk_dt3,llchk_dt4,llchk_dt5,llchk_dt6,llchk_dt7,llchk_dt8,llchk_dt9,
*  llchk_dt10,llchk_dt11,llchk_dt12.
**********************************************************
  lchk_dt1+6(2) = '01'.
  lchk_dt1+4(2) = '04'.
  lchk_dt1+0(4) = lyear.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '1'
      olddate = lchk_dt1
    importing
      newdate = lchk_dt2.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '2'
      olddate = lchk_dt1
    importing
      newdate = lchk_dt3.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '3'
      olddate = lchk_dt1
    importing
      newdate = lchk_dt4.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '4'
      olddate = lchk_dt1
    importing
      newdate = lchk_dt5.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '5'
      olddate = lchk_dt1
    importing
      newdate = lchk_dt6.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '6'
      olddate = lchk_dt1
    importing
      newdate = lchk_dt7.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '7'
      olddate = lchk_dt1
    importing
      newdate = lchk_dt8.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '8'
      olddate = lchk_dt1
    importing
      newdate = lchk_dt9.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '9'
      olddate = lchk_dt1
    importing
      newdate = lchk_dt10.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '10'
      olddate = lchk_dt1
    importing
      newdate = lchk_dt11.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '11'
      olddate = lchk_dt1
    importing
      newdate = lchk_dt12.

*  WRITE : / 'last financial year date',lchk_dt1,lchk_dt2,lchk_dt3,lchk_dt4,lchk_dt5,lchk_dt6,lchk_dt7,lchk_dt8,lchk_dt9,
*  lchk_dt10,lchk_dt11,lchk_dt12.


*****************current start & end date********

  fmonth = '04'.
*  WRITE : / 'FINANCIAL YESR START FORM',FMONTH,CYEAR,DATE2.
  fdate+06(2) = '01'.
  fdate+4(2) = fmonth.
  fdate+0(4) = cyear.


  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date           = fdate
    importing
*     EV_MONTH_BEGIN_DATE       =
      ev_month_end_date = f1date.

********* start date of month/*********
  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '1'
      olddate = fdate
    importing
      newdate = s2date.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '2'
      olddate = fdate
    importing
      newdate = s3date.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '3'
      olddate = fdate
    importing
      newdate = s4date.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '4'
      olddate = fdate
    importing
      newdate = s5date.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '5'
      olddate = fdate
    importing
      newdate = s6date.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '6'
      olddate = fdate
    importing
      newdate = s7date.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '7'
      olddate = fdate
    importing
      newdate = s8date.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '8'
      olddate = fdate
    importing
      newdate = s9date.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '9'
      olddate = fdate
    importing
      newdate = s10date.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '10'
      olddate = fdate
    importing
      newdate = s11date.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '11'
      olddate = fdate
    importing
      newdate = s12date.

**************** end of month***********

  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date           = s2date
    importing
*     EV_MONTH_BEGIN_DATE       =
      ev_month_end_date = f2date.

  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date           = s3date
    importing
*     EV_MONTH_BEGIN_DATE       =
      ev_month_end_date = f3date.

  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date           = s4date
    importing
*     EV_MONTH_BEGIN_DATE       =
      ev_month_end_date = f4date.

  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date           = s5date
    importing
*     EV_MONTH_BEGIN_DATE       =
      ev_month_end_date = f5date.

  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date           = s6date
    importing
*     EV_MONTH_BEGIN_DATE       =
      ev_month_end_date = f6date.

  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date           = s7date
    importing
*     EV_MONTH_BEGIN_DATE       =
      ev_month_end_date = f7date.

  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date           = s8date
    importing
*     EV_MONTH_BEGIN_DATE       =
      ev_month_end_date = f8date.

  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date           = s9date
    importing
*     EV_MONTH_BEGIN_DATE       =
      ev_month_end_date = f9date.

  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date           = s10date
    importing
*     EV_MONTH_BEGIN_DATE       =
      ev_month_end_date = f10date.

  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date           = s11date
    importing
*     EV_MONTH_BEGIN_DATE       =
      ev_month_end_date = f11date.

  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date           = s12date
    importing
*     EV_MONTH_BEGIN_DATE       =
      ev_month_end_date = f12date.

*  WRITE : / 'CURRENT CUMMULATIVE',MONTH,YEAR,fdate,f1date.

*  WRITE : /'a',fdate,f1date,s2date,f2date,s3date,f3date,s4date,f4date,s5date,f5date,s6date,f6date,s7date,f7date,s8date,f8date,s9date,f9date,
*  s10date,f10date,s11date,f11date,s12date,f12date.


******************************************************

  perform llsale.
  perform lsale.  "last year sale from zrcumpso  "NOT IN USE
  perform lsale_cumpso.
  perform lsale_cumpso_qrt.
  perform ltarget.
  perform inct.  "incentive- check here
  perform ctarget.
  perform csale.
  perform csale_pso.
  perform csale_qrt.  "concider actual terr for zm/rm/dzm
*  perform csale_zrcumpso.  "NOT IN USE
*  perform llys.  "not required
*  perform ccumm.  "not required
  perform ccumm_tar. " CURRENT CUMMULATIVE TARGET
  perform ccumm_tar_pso. " CURRENT CUMMULATIVE TARGET
  perform ccumm_tar_rm. " CURRENT CUMMULATIVE TARGET
  perform ccumm_tar_zm. " CURRENT CUMMULATIVE TARGET
  perform ccumm_tar_dzm. " CURRENT CUMMULATIVE TARGET
  perform cmtar. "CURRENT MONTHTARGET
  perform lcumm.  " ly cummulative sale
  perform lcumm_zrcumpso.  " ly cummulative sale FROM ZRCUMPSO
  perform lcumm_zrcumpso_pso.  " ly cummulative sale FROM ZRCUMPSO
  perform lcumm_zrcumpso_rm.  " ly cummulative sale FROM ZRCUMPSO
  perform lcumm_zrcumpso_zm.  " ly cummulative sale FROM ZRCUMPSO
  perform lcumm_zrcumpso_dzm.  " ly cummulative sale FROM ZRCUMPSO
*  perform lccumm.  "LYS FOR CURRENT JOININGS
  perform ccumms. " current cummulative sale
  perform ccumms_pso. " current cummulative sale
  perform ccumms_rm. " current cummulative sale
  perform ccumms_zm. " current cummulative sale
  perform ccumms_dzm. " current cummulative sale
  perform ccumms_zrcumpso. " current cummulative sale FROM ZRCUMPSO
  perform ccumms_zrcumpso_pso. " current cummulative sale FROM ZRCUMPSO
  perform ccumms_zrcumpso_rm. " current cummulative sale FROM ZRCUMPSO
  perform ccumms_zrcumpso_zm. " current cummulative sale FROM ZRCUMPSO
  perform ccumms_zrcumpso_dzm. " current cummulative sale FROM ZRCUMPSO
*  perform lincr.   "increment- change TO RM code
  perform cmper.  "current month performanve.
  perform prm_zm.
  perform prm_dzm.
  perform prm_rm.
  perform prm_pso.
  format color 4.
*  uline.
  perform sm.
  perform reg.
  perform zm.
  perform rm.
  perform pso.
  perform comdiv_tot.
  perform com_tot.

*  IF D2 EQ 'X'.
*    DDIV = 'BCL'.
*  ELSEIF D3 EQ 'X'.
*    DDIV = 'BC'.
*  ELSEIF D5 EQ 'X'.
  if d5 eq 'X'.
*    PDIV = 'BC/BCL'.
    pdiv = 'BC'.
  elseif d4 eq 'X'.
    ddiv = 'XL'.
    pdiv = 'XL'.
  elseif d6 eq 'X'.
    ddiv = 'LS'.
    pdiv = 'LS'.
  endif.

  if gr1 eq 'X'.
    grw1 = -100000.
    grw2 = 100000.
  elseif gr2 eq 'X'.
    grw1 = 0.
    grw2 = 100000.
  elseif gr3 eq 'X'.
    grw1 = -100000.
    grw2 = -1.
  endif.

  if pr1 eq 'X'.
    per1 = -10000.
    per2 = 10000.
  elseif pr2 eq 'X'.
    per1 = 100.
    per2 = 100000.
  elseif pr3 eq 'X'.
    per1 = -1000.
    per2 = 99.
  endif.

  w1 = 'EMP NAME'.
  w2 = 'H.Q.'.
  w3 = 'DES'.
  w6 = 'L-PROM'.
  w7 = 'D.O.J./'.

  if z3 eq 'X'.

  else.
    pdiv1 = 'DIV:'.
    if d1 eq 'X'.
      pdiv = 'BC/BCL/XL/LS'.
*****      PDIV = 'BC/BCL/XL'.
*    ELSEIF D2 EQ 'X'.
*      PDIV = 'BCL'.
*    ELSEIF D3 EQ 'X'.
*      PDIV = 'BC'.
    elseif d4 eq 'X'.
      pdiv = 'XL'.
    elseif d6 eq 'X'.
      pdiv = 'LS'.
    endif.

  endif.

  if z3 eq 'X'.
    divtxt = 'DIV'.
  else.
    divtxt = '   '.
  endif.

  if r1 eq 'X'.
    perform alv.
  elseif r2 eq 'X' or r21 eq 'X' or r22 eq 'X'.
    perform layout.
  elseif r3 eq 'X'.
    perform email.
  elseif r4 eq 'X'.
    if d1 eq 'X'.
      perform email_zm.
    elseif d5 eq 'X'.
      delete it_tab8 where div eq 'XL'.
      delete it_rm2 where div eq 'XL'.
      delete it_zm2 where div eq 'XL'.

      delete it_tab8 where div eq 'LS'.
      delete it_rm2 where div eq 'LS'.
      delete it_zm2 where div eq 'LS'.
      perform email_zm.
    else.
      perform email_zm1.
    endif.
  elseif r7 eq 'X' or r7p eq 'X'.
    if d1 eq 'X'.
      perform email_sm.
    elseif d5 eq 'X'.
      delete it_tab8 where div eq 'XL'.
      delete it_rm2 where div eq 'XL'.
      delete it_zm2 where div eq 'XL'.

      delete it_tab8 where div eq 'LS'.
      delete it_rm2 where div eq 'LS'.
      delete it_zm2 where div eq 'LS'.

      perform email_sm.
    else.
      perform email_sm1.
    endif.
  elseif r5 eq 'X'.
    if d1 eq 'X'.
      perform email_rm.
    elseif d5 eq 'X'.
      delete it_tab8 where div eq 'XL'.
      delete it_rm2 where div eq 'XL'.
      delete it_zm2 where div eq 'XL'.

      delete it_tab8 where div eq 'LS'.
      delete it_rm2 where div eq 'LS'.
      delete it_zm2 where div eq 'LS'.

      perform email_rm.
    else.
      perform email_rm1.
    endif.
  elseif r6 eq 'X'.
    if d1 eq 'X'.
      perform email_dzm.
    elseif d5 eq 'X'.
      delete it_tab8 where div eq 'XL'.
      delete it_rm2 where div eq 'XL'.
      delete it_zm2 where div eq 'XL'.

      delete it_tab8 where div eq 'LS'.
      delete it_rm2 where div eq 'LS'.
      delete it_zm2 where div eq 'LS'.

      perform email_dzm.
    else.
      perform email_dzm1.
    endif.
  endif.




*&---------------------------------------------------------------------*
*&      Form  alv
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form alv.
  loop at it_pso3 into wa_pso3.
    wa_alv1-reg = wa_pso3-reg.
    wa_alv1-zm = wa_pso3-zm.
    wa_alv1-rm = wa_pso3-rm.
    wa_alv1-zmpernr = wa_pso3-zmpernr.
    wa_alv1-dzmpernr = wa_pso3-dzmpernr.
    wa_alv1-rmpernr = wa_pso3-rmpernr.
    wa_alv1-bzirk = wa_pso3-bzirk.
    wa_alv1-pernr = wa_pso3-pernr.
    wa_alv1-ename = wa_pso3-ename.
    wa_alv1-conf_prob = wa_pso3-conf_prob.
    wa_alv1-rconf_prob = wa_pso3-rconf_prob.
    wa_alv1-zconf_prob = wa_pso3-zconf_prob.
    wa_alv1-dconf_prob = wa_pso3-dconf_prob.
    wa_alv1-zz_hqdesc = wa_pso3-zz_hqdesc.
    wa_alv1-short = wa_pso3-short.
    wa_alv1-join_dt = wa_pso3-join_dt.
    wa_alv1-div = wa_pso3-div.
    wa_alv1-lpqrt1 = wa_pso3-lpqrt1.
    wa_alv1-lpqrt2 = wa_pso3-lpqrt2.
    wa_alv1-lpqrt3 = wa_pso3-lpqrt3.
    wa_alv1-lpqrt4 = wa_pso3-lpqrt4.
    wa_alv1-lysale1 = wa_pso3-lysale1.
    wa_alv1-lysale2 = wa_pso3-lysale2.
    wa_alv1-lysale3 = wa_pso3-lysale3.
    wa_alv1-lysale4 = wa_pso3-lysale4.
    wa_alv1-lcumm = wa_pso3-lcumm.
    wa_alv1-lgrw = wa_pso3-lgrw.
    wa_alv1-ctar = wa_pso3-ctar.
    wa_alv1-cpqrt1 = wa_pso3-cpqrt1.
    wa_alv1-cpqrt2 = wa_pso3-cpqrt2.
    wa_alv1-cpqrt3 = wa_pso3-cpqrt3.
    wa_alv1-cpqrt4 = wa_pso3-cpqrt4.
    wa_alv1-cysale1 = wa_pso3-cysale1.
    wa_alv1-cysale2 = wa_pso3-cysale2.
    wa_alv1-cysale3 = wa_pso3-cysale3.
    wa_alv1-cysale4 = wa_pso3-cysale4.
    wa_alv1-ccumm = wa_pso3-ccumm.
    wa_alv1-cgrw = wa_pso3-cgrw.
    wa_alv1-cp1 = wa_pso3-cp1.
    wa_alv1-cp2 = wa_pso3-cp2.
    wa_alv1-cp3 = wa_pso3-cp3.
    wa_alv1-c1sale = wa_pso3-c1sale.
    wa_alv1-c2sale = wa_pso3-c2sale.
    wa_alv1-c3sale = wa_pso3-c3sale.

    read table it_tab8 into wa_tab8 with key reg = wa_pso3-reg.
    if sy-subrc eq 0.
      wa_alv1-zmname = wa_tab8-ename.
    endif.
    read table it_rm2 into wa_rm2 with key reg = wa_pso3-reg rm = wa_pso3-rm.
    if sy-subrc eq 0.
      wa_alv1-rmname = wa_rm2-ename.
    endif.
    read table it_zm2 into wa_zm2 with key reg = wa_pso3-reg zm = wa_pso3-zm.
    if sy-subrc eq 0.
      wa_alv1-dzmname = wa_zm2-ename.
    endif.

    collect wa_alv1 into it_alv1.
    clear wa_alv1.
  endloop.
  sort it_alv1 by seq reg zm rm bzirk.

  wa_fieldcat-fieldname = 'REG'.
  wa_fieldcat-seltext_l = 'REG'.
  append wa_fieldcat to fieldcat.


  wa_fieldcat-fieldname = 'ZMPERNR'.
  wa_fieldcat-seltext_l = 'ZM CODE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'ZMNAME'.
  wa_fieldcat-seltext_l = 'ZM NAME'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'DCONF_PROB'.
  wa_fieldcat-seltext_l = 'ZM PROB/TRAINEE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'ZM'.
  wa_fieldcat-seltext_l = 'DZM'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'DZMPERNR'.
  wa_fieldcat-seltext_l = 'DZM CODE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'DZMNAME'.
  wa_fieldcat-seltext_l = 'DZM NAME'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'ZCONF_PROB'.
  wa_fieldcat-seltext_l = 'DZM PROB/TRAINEE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'RM'.
  wa_fieldcat-seltext_l = 'RM'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'RMPERNR'.
  wa_fieldcat-seltext_l = 'RM CODE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'RMNAME'.
  wa_fieldcat-seltext_l = 'RM NAME'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'RCONF_PROB'.
  wa_fieldcat-seltext_l = 'RM PROB/TRAINEE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'BZIRK'.
  wa_fieldcat-seltext_l = 'TERRITORY'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'PERNR'.
  wa_fieldcat-seltext_l = 'PSO CODE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'ENAME'.
  wa_fieldcat-seltext_l = 'PSO NAME'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'SHORT'.
  wa_fieldcat-seltext_l = 'PSO DESIGNATION'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CONF_PROB'.
  wa_fieldcat-seltext_l = 'PROB/TRAINEE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'ZZ_HQDESC'.
  wa_fieldcat-seltext_l = 'PSO HQRT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'JOIN_DT'.
  wa_fieldcat-seltext_l = 'PSO JOINING DATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'DIV'.
  wa_fieldcat-seltext_l = 'PSO DIV'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LPQRT1'.
  wa_fieldcat-seltext_l = 'LAST YR QRT1'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LPQRT2'.
  wa_fieldcat-seltext_l = 'LAST YR QRT2'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LPQRT3'.
  wa_fieldcat-seltext_l = 'LAST YR QRT3'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LPQRT4'.
  wa_fieldcat-seltext_l = 'LAST YR QRT4'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LCUMM'.
  wa_fieldcat-seltext_l = 'LAST CUMM'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LGRW'.
  wa_fieldcat-seltext_l = 'LAST YR GROWTH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CTAR'.
  wa_fieldcat-seltext_l = 'CURR TGT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'C3SALE'.
  wa_fieldcat-seltext_l = 'CURR MTH1 SALE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CP3'.
  wa_fieldcat-seltext_l = 'CURR MTH1 PERF'.
  append wa_fieldcat to fieldcat.


  wa_fieldcat-fieldname = 'C2SALE'.
  wa_fieldcat-seltext_l = 'CURR MTH2 SALE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CP2'.
  wa_fieldcat-seltext_l = 'CURR MTH2 PERF'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'C1SALE'.
  wa_fieldcat-seltext_l = 'CURR MTH3 SALE' .
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CP1'.
  wa_fieldcat-seltext_l = 'CURR MTH3 PERF '.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CPQRT1'.
  wa_fieldcat-seltext_l = 'CURR YR QRT1'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CPQRT2'.
  wa_fieldcat-seltext_l = 'CURR YR QRT2'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CPQRT3'.
  wa_fieldcat-seltext_l = 'CURR YR QRT3'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CPQRT4'.
  wa_fieldcat-seltext_l = 'CURR YR QRT4'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CCUMM'.
  wa_fieldcat-seltext_l = 'CURR CUMM'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CGRW'.
  wa_fieldcat-seltext_l = 'CURR YR GROWTH'.
  append wa_fieldcat to fieldcat.

  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'SR-11'.

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
      t_outtab                = it_alv1
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

endform.                    "ALV

*&---------------------------------------------------------------------*
*&      Form  LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form layout.

  call function 'OPEN_FORM'
    exporting
      device   = 'PRINTER'
      dialog   = 'X'
*     form     = 'ZSR24_1'
      language = sy-langu
    exceptions
      canceled = 1
      device   = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.
  if z3 eq 'X'.
    call function 'START_FORM'
      exporting
        form        = 'ZSR11_N1_3N'
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
  else.
****** CHANGE FORMS AS PER QUARTER**************

    if date2 lt f3date.
      call function 'START_FORM'
        exporting
          form        = 'ZSR11M_5_1_1N'
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

    elseif date2 ge f3date and date2 lt f6date.
      call function 'START_FORM'
        exporting
          form        = 'ZSR11M_1_1N'
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

    elseif date2 ge f6date and date2 lt f9date.

      call function 'START_FORM'
        exporting
          form        = 'ZSR11M_2_1N'
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

    elseif date2 ge f9date and date2 lt f12date.
      call function 'START_FORM'
        exporting
          form        = 'ZSR11M_3_2_1N'
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

    else.
      call function 'START_FORM'
        exporting
          form        = 'ZSR11M_4_1N'
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
    endif.
  endif.

  sort it_tab8 by seq.
  sort it_zm2 by zm.
  sort it_rm2 by reg rm.
  sort it_pso2 by reg zm rm bzirk.
  concatenate lyear+2(2) '-' cyear+2(2) into ly.
  concatenate cyear+2(2) '-' ccyear+2(2) into cy.
  select single * from t247 where spras eq 'EN' and mnr eq date1+4(2).
  if sy-subrc eq 0.
    nmonth1 = t247-ktx.
  endif.
  select single * from t247 where spras eq 'EN' and mnr eq date4+4(2).
  if sy-subrc eq 0.
    nmonth2 = t247-ktx.
  endif.
  select single * from t247 where spras eq 'EN' and mnr eq date5+4(2).
  if sy-subrc eq 0.
    nmonth3 = t247-ktx.
  endif.
  if d4 eq 'X'.
    loop at it_com2 into wa_com2.
      if wa_com2-div ne 'XL'.
        delete it_com2 where div = wa_com2-div.
      endif.
    endloop.
  elseif d6 eq 'X'.
    loop at it_com2 into wa_com2.
      if wa_com2-div ne 'LS'.
        delete it_com2 where div = wa_com2-div.
      endif.
    endloop.
  elseif d5 eq 'X'.
    loop at it_com2 into wa_com2.
      if wa_com2-div eq 'XL' or wa_com2-div eq 'LS'.
        delete it_com2 where div = wa_com2-div.
      endif.
    endloop.

*  ELSEIF D3 EQ 'X'.
*    LOOP AT IT_COM2 INTO WA_COM2.
*      IF WA_COM2-DIV NE 'BC'.
*        DELETE IT_COM2 WHERE DIV = WA_COM2-DIV.
*      ENDIF.
*    ENDLOOP.
  endif.

  if d1 eq 'X'.
    perform div1.
  elseif d5 eq 'X'.
    delete it_tab8 where div eq 'XL'.
    delete it_zm2 where div eq 'XL'.
    delete it_rm2 where div eq 'XL'.
    perform div1.
  else.
    perform div2.
  endif.

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

endform.                    "LAYOUT

*&---------------------------------------------------------------------*
*&      Form  DIV2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form div2.

  loop at it_tab8 into wa_tab8 where reg ne '      '  .
    clear : rm_name,rm_short,pjoin_dt,zm_name,zone,rm_zone,zdiff,a.
    confprob = wa_tab8-conf_prob.
    rconfprob = wa_tab8-rconf_prob.
    zconfprob = wa_tab8-zconf_prob.
    dconfprob = wa_tab8-dconf_prob.

    on change of wa_tab8-reg.
      a = 0.
    endon.

    if ( wa_tab8-div = ddiv ) and ( wa_tab8-cgrw ge grw1 and wa_tab8-cgrw le grw2 ) and  ( wa_tab8-ccumm ge per1 and wa_tab8-ccumm le per2 ).
      a = 1.
    endif.
    loop at it_zm2 into wa_zm2 where reg = wa_tab8-reg and div eq ddiv and cgrw ge grw1 and cgrw le grw2 and ccumm ge per1 and ccumm le per2.
      a = 1.
    endloop.
    loop at it_rm2 into wa_rm2 where reg = wa_tab8-reg and div eq ddiv and cgrw ge grw1 and cgrw le grw2 and ccumm ge per1 and ccumm le per2.
      a = 1.
    endloop.
    loop at it_pso2 into wa_pso2 where reg = wa_tab8-reg and div eq ddiv and cgrw ge grw1 and cgrw le grw2 and ccumm ge per1 and ccumm le per2.
*      CONFPROB = WA_TAB8-CONF_PROB.
*      rconfprob = WA_TAB8-RCONF_PROB.
*      Zconfprob = WA_TAB8-ZCONF_PROB.
*      Dconfprob = WA_TAB8-DCONF_PROB.
      a = 1.
    endloop.

    if a eq 1.
      on change of wa_tab8-reg.
        if z1 ne 'X'.
          call function 'WRITE_FORM'
            exporting
              element = 'V2'
              window  = 'MAIN'.
        endif.
        call function 'WRITE_FORM'
          exporting
            element = 'VL'
            window  = 'MAIN'.
      endon.
    endif.


    on change of wa_tab8-reg.
      if a eq 1.
        zdiff = wa_tab8-lysale - wa_tab8-lysalec.
        if wa_tab8-div eq ddiv.
          if wa_tab8-cgrw ge grw1 and wa_tab8-cgrw le grw2.
            if wa_tab8-ccumm ge per1 and wa_tab8-ccumm le per2.

              read table it_pso2 into wa_pso2 with key reg = wa_tab8-reg.
              if sy-subrc = 0.
                dconfprob = wa_pso2-dconf_prob.
              endif.

              call function 'WRITE_FORM'
                exporting
                  element = 'DET1'
                  window  = 'MAIN'.
              if zdiff gt 1 or zdiff lt -1.
                if wa_tab8-lysalec gt 0.
                  call function 'WRITE_FORM'
                    exporting
                      element = 'DET2'
                      window  = 'MAIN'.
                endif.
              endif.
              call function 'WRITE_FORM'
                exporting
                  element = 'DET3'
                  window  = 'MAIN'.
            endif.
          endif.
        endif.
      endif.
    endon.
    if z1 ne 'X'.
      loop at it_zm2 into wa_zm2 where reg = wa_tab8-reg and ctar gt 0 .
        if wa_zm2-zm ne '      '.
          if wa_zm2-div = ddiv.
            if wa_zm2-cgrw ge grw1 and wa_zm2-cgrw le grw2.
              if wa_zm2-ccumm ge per1 and wa_zm2-ccumm le per2.
                call function 'WRITE_FORM'
                  exporting
                    element = 'VL'
                    window  = 'MAIN'.
                clear : rdiff.
                dzmdiff = wa_zm2-lysale - wa_zm2-lysalec.
                call function 'WRITE_FORM'
                  exporting
                    element = 'DZM1'
                    window  = 'MAIN'.
                if dzmdiff gt 1 or dzmdiff lt -1.
                  if wa_zm2-lysalec gt 0.
                    call function 'WRITE_FORM'
                      exporting
                        element = 'DZM2'
                        window  = 'MAIN'.
                  endif.
                endif.
                call function 'WRITE_FORM'
                  exporting
                    element = 'DZM3'
                    window  = 'MAIN'.
              endif.
            endif.
          endif.
        endif.
        loop at it_rm2 into wa_rm2 where reg = wa_tab8-reg and zm = wa_zm2-zm and ctar gt 0 .
          read table it_pso2 into wa_pso2 with key rm = wa_rm2-rm.
          if sy-subrc = 0.
            rconfprob = wa_pso2-rconf_prob.
          endif.
          if wa_rm2-cgrw ge grw1 and wa_rm2-cgrw le grw2.
            if wa_rm2-ccumm ge per1 and wa_rm2-ccumm le per2.
              if wa_rm2-div eq ddiv.
                call function 'WRITE_FORM'
                  exporting
                    element = 'VL'
                    window  = 'MAIN'.
                clear : rdiff.
                rdiff = wa_rm2-lysale - wa_rm2-lysalec.
                call function 'WRITE_FORM'
                  exporting
                    element = 'RM1'
                    window  = 'MAIN'.
                if rdiff gt 1 or rdiff lt -1.
                  if wa_rm2-lysalec gt 0.
                    call function 'WRITE_FORM'
                      exporting
                        element = 'RM2'
                        window  = 'MAIN'.
                  endif.
                endif.
                call function 'WRITE_FORM'
                  exporting
                    element = 'RM3'
                    window  = 'MAIN'.
              endif.
            endif.
          endif.
          if z3 eq 'X'.
            loop at it_pso2 into wa_pso2 where rm = wa_rm2-rm and ctar gt 0 and div = ddiv.
              confprob = wa_pso2-conf_prob.
              if wa_pso2-cgrw ge grw1 and wa_pso2-cgrw le grw2.
                if wa_pso2-ccumm ge per1 and wa_pso2-ccumm le per2.
                  call function 'WRITE_FORM'
                    exporting
                      element = 'VL'
                      window  = 'MAIN'.
                  clear : pdiff.
                  pdiff = wa_pso2-lysale - wa_pso2-lysalec.

                  call function 'WRITE_FORM'
                    exporting
                      element = 'P1'
                      window  = 'MAIN'.

                  call function 'WRITE_FORM'
                    exporting
                      element = 'PSO1'
                      window  = 'MAIN'.
                  if pdiff gt 1 or pdiff lt -1.
                    if wa_pso2-lysalec gt 0.
                      call function 'WRITE_FORM'
                        exporting
                          element = 'PSO2'
                          window  = 'MAIN'.
                    endif.
                  endif.
                  call function 'WRITE_FORM'
                    exporting
                      element = 'PSO3'
                      window  = 'MAIN'.
                endif.
              endif.
            endloop.
          endif.
        endloop.
      endloop.
    endif.
    at last.
      b = 1.
    endat.

    if a eq 1.
      at end of reg.
        call function 'WRITE_FORM'
          exporting
            element = 'L2'
            window  = 'MAIN'.
      endat.
    endif.

    if b ne 1 and a eq 1.
      at end of reg.
        if z3 eq 'X'.
          call function 'WRITE_FORM'
            exporting
              element = 'L1'
              window  = 'MAIN'.
        endif.
      endat.
    endif.


*    AT LAST.
*      IF CTOT EQ 'X'.
*        LOOP AT IT_COM2 INTO WA_COM2.
*          call function 'WRITE_FORM'
*            EXPORTING
*              element = 'COM1'
*              window  = 'MAIN'.
*        ENDLOOP.
*        call function 'WRITE_FORM'
*          EXPORTING
*            element = 'COM2'
*            window  = 'MAIN'.
*      ENDIF.
*    ENDAT.


  endloop.

*  IF CTOT EQ 'X'.
  w5 = 0.
  call function 'WRITE_FORM'
    exporting
      element = 'L1'
      window  = 'MAIN'.
  call function 'WRITE_FORM'
    exporting
      element = 'VL'
      window  = 'MAIN'.
  w1 = '        '.
  w2 = '    '.
  w3 = '   '.
  w6 = '      '.
  w7 = '      '.
*  IF D1 EQ 'X'.
  loop at it_com2 into wa_com2.
    if w5 eq 0.
      w4 = 'COMPANY DIVISION TOTAL :'.
    else.
      w4 = '                       :'.
    endif.
    call function 'WRITE_FORM'
      exporting
        element = 'COM1'
        window  = 'MAIN'.
    w5 = w5 + 1.
  endloop.
  call function 'WRITE_FORM'
    exporting
      element = 'COM2'
      window  = 'MAIN'.
*  ENDIF.
  if d1 eq 'X'.
    if ctot eq 'X'.
      loop at it_comp2 into wa_comp2.
        call function 'WRITE_FORM'
          exporting
            element = 'COMP1'
            window  = 'MAIN'.
      endloop.
      call function 'WRITE_FORM'
        exporting
          element = 'COMP2'
          window  = 'MAIN'.
    endif.
  endif.
endform.                    "DIV2


*&---------------------------------------------------------------------*
*&      Form  zm_DIV2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form zm_div2.

  loop at it_tab8 into wa_tab8 where reg ne '      ' .
*     AND ZMPERNR EQ WA_TAP1-PERNR.
    select single * from zdsmter where zmonth eq month and zyear eq year and zdsm eq wa_taz1-bzirk and bzirk eq wa_tab8-reg.
    if sy-subrc eq 0.
      clear : rm_name,rm_short,pjoin_dt,zm_name,zone,rm_zone,zdiff,a.

      on change of wa_tab8-reg.
        call function 'WRITE_FORM'
          exporting
            element = 'V2'
            window  = 'MAIN'.
        call function 'WRITE_FORM'
          exporting
            element = 'VL'
            window  = 'MAIN'.
      endon.

      on change of wa_tab8-reg.
        zdiff = wa_tab8-lysale - wa_tab8-lysalec.
        call function 'WRITE_FORM'
          exporting
            element = 'DET1'
            window  = 'MAIN'.
        if zdiff gt 1 or zdiff lt -1.
          if wa_tab8-lysalec gt 0.
            call function 'WRITE_FORM'
              exporting
                element = 'DET2'
                window  = 'MAIN'.
          endif.
        endif.
      endon.

      loop at it_zm2 into wa_zm2 where reg = wa_tab8-reg and ctar gt 0.
        if wa_zm2-zm ne '      '.
          if wa_zm2-div eq ddiv.
            if wa_zm2-cgrw ge grw1 and wa_zm2-cgrw le grw2.
              if wa_zm2-ccumm ge per1 and wa_zm2-ccumm le per2.
                call function 'WRITE_FORM'
                  exporting
                    element = 'VL'
                    window  = 'MAIN'.
                clear : rdiff.
                dzmdiff = wa_zm2-lysale - wa_zm2-lysalec.
                call function 'WRITE_FORM'
                  exporting
                    element = 'DZM1'
                    window  = 'MAIN'.
                if dzmdiff gt 1 or dzmdiff lt -1.
                  if wa_zm2-lysalec gt 0.
                    call function 'WRITE_FORM'
                      exporting
                        element = 'DZM2'
                        window  = 'MAIN'.
                  endif.
                endif.
                call function 'WRITE_FORM'
                  exporting
                    element = 'DZM3'
                    window  = 'MAIN'.
              endif.
            endif.
          endif.
        endif.
        loop at it_rm2 into wa_rm2 where reg = wa_tab8-reg and zm = wa_zm2-zm and ctar gt 0.
          if wa_rm2-cgrw ge grw1 and wa_rm2-cgrw le grw2.
            if wa_rm2-ccumm ge per1 and wa_rm2-ccumm le per2.
              if wa_rm2-div eq ddiv.
                call function 'WRITE_FORM'
                  exporting
                    element = 'VL'
                    window  = 'MAIN'.
                clear : rdiff.
                rdiff = wa_rm2-lysale - wa_rm2-lysalec.
                call function 'WRITE_FORM'
                  exporting
                    element = 'RM1'
                    window  = 'MAIN'.
                if rdiff gt 1 or rdiff lt -1.
                  if wa_rm2-lysalec gt 0.
                    call function 'WRITE_FORM'
                      exporting
                        element = 'RM2'
                        window  = 'MAIN'.
                  endif.
                endif.
                call function 'WRITE_FORM'
                  exporting
                    element = 'RM3'
                    window  = 'MAIN'.
              endif.
            endif.
          endif.
          loop at it_pso2 into wa_pso2 where rm = wa_rm2-rm and ctar gt 0 and div eq ddiv.
            if wa_pso2-cgrw ge grw1 and wa_pso2-cgrw le grw2.
              if wa_pso2-ccumm ge per1 and wa_pso2-ccumm le per2.
                call function 'WRITE_FORM'
                  exporting
                    element = 'VL'
                    window  = 'MAIN'.
                clear : pdiff.
                pdiff = wa_pso2-lysale - wa_pso2-lysalec.
                call function 'WRITE_FORM'
                  exporting
                    element = 'PSO1'
                    window  = 'MAIN'.
                if pdiff gt 1 or pdiff lt -1.
                  if wa_pso2-lysalec gt 0.
                    call function 'WRITE_FORM'
                      exporting
                        element = 'PSO2'
                        window  = 'MAIN'.
                  endif.
                endif.
                call function 'WRITE_FORM'
                  exporting
                    element = 'PSO3'
                    window  = 'MAIN'.
              endif.
            endif.
          endloop.
        endloop.
      endloop.
      at last.
        b = 1.
      endat.
      at end of reg.
        call function 'WRITE_FORM'
          exporting
            element = 'L2'
            window  = 'MAIN'.
      endat.
      if b ne 1 .
        at end of reg.
          call function 'WRITE_FORM'
            exporting
              element = 'L1'
              window  = 'MAIN'.
        endat.
      endif.
    endif.
  endloop.

endform.                    "DIV2


*&---------------------------------------------------------------------*
*&      Form  Dzm_DIV2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form dzm_div2.

  loop at it_zm2 into wa_zm2 where zm ne '      '  and dzmpernr eq wa_tap1-pernr.
    clear : rm_name,rm_short,pjoin_dt,zm_name,zone,rm_zone,zdiff,a.
    on change of wa_zm2-zm.
      a = 0.
    endon.
    if ( wa_zm2-div eq ddiv ) and ( wa_zm2-cgrw ge grw1 and wa_zm2-cgrw le grw2 ) and  ( wa_zm2-ccumm ge per1 and wa_zm2-ccumm le per2 ).
      a = 1.
    endif.
    loop at it_rm2 into wa_rm2 where zm = wa_zm2-zm and div eq ddiv and cgrw ge grw1 and cgrw le grw2 and ccumm ge per1 and ccumm le per2.
      a = 1.
    endloop.
    loop at it_pso2 into wa_pso2 where zm = wa_zm2-zm and div eq ddiv and cgrw ge grw1 and cgrw le grw2 and ccumm ge per1 and ccumm le per2.
      a = 1.
    endloop.
    if a eq 1.
      on change of wa_zm2-zm.
        call function 'WRITE_FORM'
          exporting
            element = 'V2'
            window  = 'MAIN'.
        call function 'WRITE_FORM'
          exporting
            element = 'VL'
            window  = 'MAIN'.
      endon.
    endif.
    if wa_zm2-zm ne '      '.
      if wa_zm2-div = ddiv.
        if wa_zm2-cgrw ge grw1 and wa_zm2-cgrw le grw2.
          if wa_zm2-ccumm ge per1 and wa_zm2-ccumm le per2.
            call function 'WRITE_FORM'
              exporting
                element = 'VL'
                window  = 'MAIN'.
            clear : rdiff.
            dzmdiff = wa_zm2-lysale - wa_zm2-lysalec.
            call function 'WRITE_FORM'
              exporting
                element = 'DZM1'
                window  = 'MAIN'.
            if dzmdiff gt 100 or dzmdiff lt -100.
              if wa_zm2-lysalec gt 0.
                call function 'WRITE_FORM'
                  exporting
                    element = 'DZM2'
                    window  = 'MAIN'.
              endif.
            endif.
            call function 'WRITE_FORM'
              exporting
                element = 'DZM3'
                window  = 'MAIN'.
          endif.
        endif.
      endif.
    endif.
    loop at it_rm2 into wa_rm2 where zm = wa_zm2-zm and ctar gt 0 and div eq ddiv.
      if wa_rm2-cgrw ge grw1 and wa_rm2-cgrw le grw2.
        if wa_rm2-ccumm ge per1 and wa_rm2-ccumm le per2.
          call function 'WRITE_FORM'
            exporting
              element = 'VL'
              window  = 'MAIN'.
          clear : rdiff.
          rdiff = wa_rm2-lysale - wa_rm2-lysalec.
          call function 'WRITE_FORM'
            exporting
              element = 'RM1'
              window  = 'MAIN'.
          if rdiff gt 100 or rdiff lt -100.
            if wa_rm2-lysalec gt 0.
              call function 'WRITE_FORM'
                exporting
                  element = 'RM2'
                  window  = 'MAIN'.
            endif.
          endif.
          call function 'WRITE_FORM'
            exporting
              element = 'RM3'
              window  = 'MAIN'.
        endif.
      endif.
      loop at it_pso2 into wa_pso2 where rm = wa_rm2-rm and ctar gt 0 and div eq ddiv.
        if wa_pso2-cgrw ge grw1 and wa_pso2-cgrw le grw2.
          if wa_pso2-ccumm ge per1 and wa_pso2-ccumm le per2.
            call function 'WRITE_FORM'
              exporting
                element = 'VL'
                window  = 'MAIN'.
            clear : pdiff.
            pdiff = wa_pso2-lysale - wa_pso2-lysalec.
            call function 'WRITE_FORM'
              exporting
                element = 'PSO1'
                window  = 'MAIN'.
            if pdiff gt 100 or pdiff lt -100.
              if wa_pso2-lysalec gt 0.
                call function 'WRITE_FORM'
                  exporting
                    element = 'PSO2'
                    window  = 'MAIN'.
              endif.
            endif.
            call function 'WRITE_FORM'
              exporting
                element = 'PSO3'
                window  = 'MAIN'.
          endif.
        endif.
      endloop.
    endloop.
    at last.
      b = 1.
    endat.
    if a eq 1.
      at end of zm.
        call function 'WRITE_FORM'
          exporting
            element = 'L2'
            window  = 'MAIN'.
      endat.
    endif.
    if b ne 1 and a eq 1.
      at end of zm.
        call function 'WRITE_FORM'
          exporting
            element = 'L1'
            window  = 'MAIN'.
      endat.
    endif.
  endloop.


endform.                    "DIV2

*&---------------------------------------------------------------------*
*&      Form  RM_DIV2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form rm_div2.

  loop at it_rm2 into wa_rm2 where rm ne '      '  and rmpernr eq wa_tap1-pernr.
    clear : rm_name,rm_short,pjoin_dt,zm_name,zone,rm_zone,zdiff,a.

    on change of wa_rm2-rm.
      call function 'WRITE_FORM'
        exporting
          element = 'V2'
          window  = 'MAIN'.
      call function 'WRITE_FORM'
        exporting
          element = 'VL'
          window  = 'MAIN'.
    endon.
    call function 'WRITE_FORM'
      exporting
        element = 'VL'
        window  = 'MAIN'.

    clear : rdiff.
    rdiff = wa_rm2-lysale - wa_rm2-lysalec.
    call function 'WRITE_FORM'
      exporting
        element = 'RM1'
        window  = 'MAIN'.
    if rdiff gt 1 or rdiff lt -1.
      if wa_rm2-lysalec gt 0.
        call function 'WRITE_FORM'
          exporting
            element = 'RM2'
            window  = 'MAIN'.
      endif.
    endif.
    call function 'WRITE_FORM'
      exporting
        element = 'RM3'
        window  = 'MAIN'.
*      ENDIF.
*    ENDIF.
    loop at it_pso2 into wa_pso2 where rm = wa_rm2-rm and ctar gt 0 and div eq ddiv.
      if wa_pso2-cgrw ge grw1 and wa_pso2-cgrw le grw2.
        if wa_pso2-ccumm ge per1 and wa_pso2-ccumm le per2.
          call function 'WRITE_FORM'
            exporting
              element = 'VL'
              window  = 'MAIN'.
          clear : pdiff.
          pdiff = wa_pso2-lysale - wa_pso2-lysalec.
          call function 'WRITE_FORM'
            exporting
              element = 'PSO1'
              window  = 'MAIN'.
          if pdiff gt 1 or pdiff lt -1.
            if wa_pso2-lysalec gt 0.
              call function 'WRITE_FORM'
                exporting
                  element = 'PSO2'
                  window  = 'MAIN'.
            endif.
          endif.
          call function 'WRITE_FORM'
            exporting
              element = 'PSO3'
              window  = 'MAIN'.
        endif.
      endif.
    endloop.
    at last.
      b = 1.
    endat.
    if a eq 1.
      at end of rm.
        call function 'WRITE_FORM'
          exporting
            element = 'L2'
            window  = 'MAIN'.
      endat.
    endif.
    if b ne 1 and a eq 1.
      at end of rm.
        call function 'WRITE_FORM'
          exporting
            element = 'L1'
            window  = 'MAIN'.
      endat.
    endif.
  endloop.


endform.                    "DIV2

*&---------------------------------------------------------------------*
*&      Form  DIV1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form div1.
  loop at it_tab8 into wa_tab8 where reg ne '      '  .
    clear : rm_name,rm_short,pjoin_dt,zm_name,zone,rm_zone,zdiff,a.

    on change of wa_tab8-reg.
      a = 0.
    endon.

    if ( wa_tab8-cgrw ge grw1 and wa_tab8-cgrw le grw2 ) and  ( wa_tab8-ccumm ge per1 and wa_tab8-ccumm le per2 ).
      a = 1.
    endif.
    loop at it_zm2 into wa_zm2 where reg = wa_tab8-reg and cgrw ge grw1 and cgrw le grw2 and ccumm ge per1 and ccumm le per2.
      a = 1.
    endloop.
    loop at it_rm2 into wa_rm2 where reg = wa_tab8-reg and cgrw ge grw1 and cgrw le grw2 and ccumm ge per1 and ccumm le per2.
      a = 1.
    endloop.
    loop at it_pso2 into wa_pso2 where reg = wa_tab8-reg and cgrw ge grw1 and cgrw le grw2 and ccumm ge per1 and ccumm le per2.
      a = 1.
    endloop.

    if a eq 1.
      on change of wa_tab8-reg.
        if z1 ne 'X'.
          call function 'WRITE_FORM'
            exporting
              element = 'V2'
              window  = 'MAIN'.
        endif.
        call function 'WRITE_FORM'
          exporting
            element = 'VL'
            window  = 'MAIN'.
      endon.
    endif.

    on change of wa_tab8-reg.
      if a eq 1.
        zdiff = wa_tab8-lysale - wa_tab8-lysalec.
        if wa_tab8-cgrw ge grw1 and wa_tab8-cgrw le grw2.
          if wa_tab8-ccumm ge per1 and wa_tab8-ccumm le per2.
***************************UPDATE DATA IN TABLE ZSR11*****************
            zsr11_wa-bzirk = wa_tab8-reg.
            zsr11_wa-gjahr = cyear.
            zsr11_wa-qtr1 = wa_tab8-cpqrt1.
            zsr11_wa-qtr2 = wa_tab8-cpqrt2.
            zsr11_wa-qtr3 = wa_tab8-cpqrt3.
            zsr11_wa-qtr4 = wa_tab8-cpqrt4.
            zsr11_wa-growth = wa_tab8-cgrw.
            modify zsr11 from zsr11_wa.
            clear zsr11_wa.

            read table it_pso2 into wa_pso2 with key reg = wa_tab8-reg.
            if sy-subrc = 0.
              dconfprob = wa_pso2-dconf_prob.
            endif.

            if z3 eq 'X'.
            else.
              wa_tab8-div = space.
            endif.

*********************************************************************
            call function 'WRITE_FORM'
              exporting
                element = 'DET1'
                window  = 'MAIN'.
            wa_tazm1-ename = wa_tab8-ename.
            wa_tazm1-zz_hqdesc = wa_tab8-zz_hqdesc.
            wa_tazm1-short = wa_tab8-short.
            wa_tazm1-join_dt = wa_tab8-join_dt.
            wa_tazm1-lpqrt1 = wa_tab8-lpqrt1.
            wa_tazm1-lpqrt2 = wa_tab8-lpqrt2.
            wa_tazm1-lpqrt3 = wa_tab8-lpqrt3.
            wa_tazm1-lpqrt4 = wa_tab8-lpqrt4.
            wa_tazm1-lcumm = wa_tab8-lcumm.
            wa_tazm1-lgrw = wa_tab8-lgrw.
            wa_tazm1-cp3 = wa_tab8-cp3.
            wa_tazm1-cp2 = wa_tab8-cp2.
            wa_tazm1-cp1 = wa_tab8-cp1.
            wa_tazm1-cpqrt1 = wa_tab8-cpqrt1.
            wa_tazm1-cpqrt2 = wa_tab8-cpqrt2.
            wa_tazm1-cpqrt3 = wa_tab8-cpqrt3.
            wa_tazm1-cpqrt4 = wa_tab8-cpqrt4.
            wa_tazm1-ccumm = wa_tab8-ccumm.
            wa_tazm1-cgrw = wa_tab8-cgrw.
            wa_tazm1-noofpso = wa_tab8-noofpso.
            wa_tazm1-prom = wa_tab8-prom.
            wa_tazm1-lysale1 = wa_tab8-lysale1.
            wa_tazm1-lysale2 = wa_tab8-lysale2.
            wa_tazm1-lysale3 = wa_tab8-lysale3.
            wa_tazm1-lysale4 = wa_tab8-lysale4.
            wa_tazm1-lysale = wa_tab8-lysale.
            wa_tazm1-ctar = wa_tab8-ctar.
            wa_tazm1-c3sale = wa_tab8-c3sale.
            wa_tazm1-c2sale = wa_tab8-c2sale.
            wa_tazm1-c1sale = wa_tab8-c1sale.
            wa_tazm1-cysale1 = wa_tab8-cysale1.
            wa_tazm1-cysale2 = wa_tab8-cysale2.
            wa_tazm1-cysale3 = wa_tab8-cysale3.
            wa_tazm1-cysale4 = wa_tab8-cysale4.
            wa_tazm1-cysale = wa_tab8-cysale.

*            IF ZDIFF GT 100 OR ZDIFF LT -100.
            if zdiff gt 1 or zdiff lt -1.
              if wa_tab8-lysalec gt 0.
                call function 'WRITE_FORM'
                  exporting
                    element = 'DET2'
                    window  = 'MAIN'.
                wa_tazm1-lysalec1 = wa_tab8-lysalec1.
                wa_tazm1-lysalec2 = wa_tab8-lysalec2.
                wa_tazm1-lysalec3 = wa_tab8-lysalec3.
                wa_tazm1-lysalec4 = wa_tab8-lysalec4.
                wa_tazm1-lysalec = wa_tab8-lysalec.
              endif.
            endif.
            collect wa_tazm1 into it_tazm1.
            clear wa_tazm1.
            call function 'WRITE_FORM'
              exporting
                element = 'DET3'
                window  = 'MAIN'.
          endif.
        endif.
      endif.
    endon.
    if z1 ne 'X'.
      loop at it_zm2 into wa_zm2 where reg = wa_tab8-reg and ctar gt 0 .
*      READ TABLE IT_PSO2 INTO WA_PSO2 WITH KEY ZM = WA_ZM2-ZM.
*        IF SY-SUBRC = 0.
*          Zconfprob = WA_PSO2-ZCONF_PROB.
*        ENDIF.

        if wa_zm2-zm ne '      '.
          if wa_zm2-cgrw ge grw1 and wa_zm2-cgrw le grw2.
            if wa_zm2-ccumm ge per1 and wa_zm2-ccumm le per2.
              call function 'WRITE_FORM'
                exporting
                  element = 'VL'
                  window  = 'MAIN'.
              clear : rdiff.
              dzmdiff = wa_zm2-lysale - wa_zm2-lysalec.
*****************update data in zsr11 **************
              zsr11_wa-bzirk = wa_zm2-zm.
              zsr11_wa-gjahr = cyear.
              zsr11_wa-qtr1 = wa_zm2-cpqrt1.
              zsr11_wa-qtr2 = wa_zm2-cpqrt2.
              zsr11_wa-qtr3 = wa_zm2-cpqrt3.
              zsr11_wa-qtr4 = wa_zm2-cpqrt4.
              zsr11_wa-growth = wa_zm2-cgrw.
              modify zsr11 from zsr11_wa.
              clear zsr11_wa.
************************************
              if z3 eq 'X'.
              else.
                wa_zm2-div = space.
              endif.
              call function 'WRITE_FORM'
                exporting
                  element = 'DZM1'
                  window  = 'MAIN'.
*            IF DZMDIFF GT 100 OR DZMDIFF LT -100.
              if dzmdiff gt 1 or dzmdiff lt -1.
                if wa_zm2-lysalec gt 0.
                  call function 'WRITE_FORM'
                    exporting
                      element = 'DZM2'
                      window  = 'MAIN'.
                endif.
              endif.
              call function 'WRITE_FORM'
                exporting
                  element = 'DZM3'
                  window  = 'MAIN'.
            endif.
          endif.
        endif.
        loop at it_rm2 into wa_rm2 where reg = wa_tab8-reg and zm = wa_zm2-zm and ctar gt 0.
          read table it_pso2 into wa_pso2 with key rm = wa_rm2-rm.
          if sy-subrc = 0.
            rconfprob = wa_pso2-rconf_prob.
          endif.
          if wa_rm2-cgrw ge grw1 and wa_rm2-cgrw le grw2.
            if wa_rm2-ccumm ge per1 and wa_rm2-ccumm le per2.
              call function 'WRITE_FORM'
                exporting
                  element = 'VL'
                  window  = 'MAIN'.
              clear : rdiff.
              rdiff = wa_rm2-lysale - wa_rm2-lysalec.
*********************UPDATE DATA IN ZSR11***************
              zsr11_wa-bzirk = wa_rm2-rm.
              zsr11_wa-gjahr = cyear.
              zsr11_wa-qtr1 = wa_rm2-cpqrt1.
              zsr11_wa-qtr2 = wa_rm2-cpqrt2.
              zsr11_wa-qtr3 = wa_rm2-cpqrt3.
              zsr11_wa-qtr4 = wa_rm2-cpqrt4.
              zsr11_wa-growth = wa_rm2-cgrw.
              modify zsr11 from zsr11_wa.
              clear zsr11_wa.
**************************************************
              if z3 eq 'X'.
              else.
                wa_rm2-div = space.
              endif.
              call function 'WRITE_FORM'
                exporting
                  element = 'RM1'
                  window  = 'MAIN'.

              wa_tarm1-ename = wa_rm2-ename.
              wa_tarm1-zz_hqdesc = wa_rm2-zz_hqdesc.
              wa_tarm1-short = wa_rm2-short.
              wa_tarm1-join_dt = wa_rm2-join_dt.
              wa_tarm1-lpqrt1 = wa_rm2-lpqrt1.
              wa_tarm1-lpqrt2 = wa_rm2-lpqrt2.
              wa_tarm1-lpqrt3 = wa_rm2-lpqrt3.
              wa_tarm1-lpqrt4 = wa_rm2-lpqrt4.
              wa_tarm1-lcumm = wa_rm2-lcumm.
              wa_tarm1-lgrw = wa_rm2-lgrw.
              wa_tarm1-cp3 = wa_rm2-cp3.
              wa_tarm1-cp2 = wa_rm2-cp2.
              wa_tarm1-cp1 = wa_rm2-cp1.
              wa_tarm1-cpqrt1 = wa_rm2-cpqrt1.
              wa_tarm1-cpqrt2 = wa_rm2-cpqrt2.
              wa_tarm1-cpqrt3 = wa_rm2-cpqrt3.
              wa_tarm1-cpqrt4 = wa_rm2-cpqrt4.
              wa_tarm1-ccumm = wa_rm2-ccumm.
              wa_tarm1-cgrw = wa_rm2-cgrw.
              wa_tarm1-noofpso = wa_rm2-noofpso.
              wa_tarm1-prom = wa_rm2-prom.
              wa_tarm1-lysale1 = wa_rm2-lysale1.
              wa_tarm1-lysale2 = wa_rm2-lysale2.
              wa_tarm1-lysale3 = wa_rm2-lysale3.
              wa_tarm1-lysale4 = wa_rm2-lysale4.
              wa_tarm1-lysale = wa_rm2-lysale.
              wa_tarm1-ctar = wa_rm2-ctar.
              wa_tarm1-c3sale = wa_rm2-c3sale.
              wa_tarm1-c2sale = wa_rm2-c2sale.
              wa_tarm1-c1sale = wa_rm2-c1sale.
              wa_tarm1-cysale1 = wa_rm2-cysale1.
              wa_tarm1-cysale2 = wa_rm2-cysale2.
              wa_tarm1-cysale3 = wa_rm2-cysale3.
              wa_tarm1-cysale4 = wa_rm2-cysale4.
              wa_tarm1-cysale = wa_rm2-cysale.

*            IF RDIFF GT 100 OR RDIFF LT -100.
              if rdiff gt 1 or rdiff lt -1.
                if wa_rm2-lysalec gt 0.
                  call function 'WRITE_FORM'
                    exporting
                      element = 'RM2'
                      window  = 'MAIN'.
                  wa_tarm1-lysalec1 = wa_tab8-lysalec1.
                  wa_tarm1-lysalec2 = wa_tab8-lysalec2.
                  wa_tarm1-lysalec3 = wa_tab8-lysalec3.
                  wa_tarm1-lysalec4 = wa_tab8-lysalec4.
                  wa_tarm1-lysalec = wa_tab8-lysalec.
                endif.
              endif.
              collect wa_tarm1 into it_tarm1.
              clear wa_tarm1.
              call function 'WRITE_FORM'
                exporting
                  element = 'RM3'
                  window  = 'MAIN'.
            endif.
          endif.
          if z3 eq 'X'.
            loop at it_pso2 into wa_pso2 where rm = wa_rm2-rm and ctar gt 0.
              confprob = wa_pso2-conf_prob.
              if wa_pso2-cgrw ge grw1 and wa_pso2-cgrw le grw2.
                if wa_pso2-ccumm ge per1 and wa_pso2-ccumm le per2.
***************division total********************************************
*************************************************************************

                  call function 'WRITE_FORM'
                    exporting
                      element = 'VL'
                      window  = 'MAIN'.
                  clear : pdiff.
                  pdiff = wa_pso2-lysale - wa_pso2-lysalec.
*******************UPDATE DATA IN ZSR11************************
                  zsr11_wa-bzirk = wa_pso2-bzirk.
                  zsr11_wa-gjahr = cyear.
                  zsr11_wa-qtr1 = wa_pso2-cpqrt1.
                  zsr11_wa-qtr2 = wa_pso2-cpqrt2.
                  zsr11_wa-qtr3 = wa_pso2-cpqrt3.
                  zsr11_wa-qtr4 = wa_pso2-cpqrt4.
                  zsr11_wa-growth = wa_pso2-cgrw.
                  modify zsr11 from zsr11_wa.
                  clear zsr11_wa.
*****************************************
                  call function 'WRITE_FORM'
                    exporting
                      element = 'P1'
                      window  = 'MAIN'.

                  call function 'WRITE_FORM'
                    exporting
                      element = 'PSO1'
                      window  = 'MAIN'.
*              IF PDIFF GT 100 OR PDIFF LT -100.
                  if pdiff gt 1 or pdiff lt -1.
                    if wa_pso2-lysalec gt 0.
                      call function 'WRITE_FORM'
                        exporting
                          element = 'PSO2'
                          window  = 'MAIN'.
                    endif.
                  endif.
                  call function 'WRITE_FORM'
                    exporting
                      element = 'PSO3'
                      window  = 'MAIN'.
                endif.
              endif.
            endloop.
          endif.
        endloop.
      endloop.
    endif.
    at last.
      b = 1.
    endat.

    if a eq 1.
      at end of reg.
        call function 'WRITE_FORM'
          exporting
            element = 'L2'
            window  = 'MAIN'.
      endat.
    endif.

    if b ne 1 and a eq 1.
      at end of reg.
        if z3 eq 'X'.
          call function 'WRITE_FORM'
            exporting
              element = 'L1'
              window  = 'MAIN'.
        endif.
      endat.
    endif.
  endloop.

*  AT LAST.
*  IF CTOT EQ 'X'.
  w5 = 0.
*  call function 'WRITE_FORM'
*    exporting
*      element = 'L1'
*      window  = 'MAIN'.
*  call function 'WRITE_FORM'
*    exporting
*      element = 'VL'
*      window  = 'MAIN'.
*  w1 = '        '.
*  w2 = '    '.
*  w3 = '   '.
*  w6 = '      '.
*  w7 = '      '.
*  if d1 eq 'X'.
  if ctot eq 'X'.

    call function 'WRITE_FORM'
      exporting
        element = 'L1'
        window  = 'MAIN'.
    call function 'WRITE_FORM'
      exporting
        element = 'VL'
        window  = 'MAIN'.
    w1 = '        '.
    w2 = '    '.
    w3 = '   '.
    w6 = '      '.
    w7 = '      '.

    loop at it_com2 into wa_com2.
      if w5 eq 0.
        w4 = 'COMPANY DIVISION TOTAL :'.
      else.
        w4 = '                       :'.
      endif.
      call function 'WRITE_FORM'
        exporting
          element = 'COM1'
          window  = 'MAIN'.
      w5 = w5 + 1.
    endloop.
    call function 'WRITE_FORM'
      exporting
        element = 'COM2'
        window  = 'MAIN'.
*  ENDIF.
    if d1 eq 'X'.
*    if ctot eq 'X'.
      loop at it_comp2 into wa_comp2.
        call function 'WRITE_FORM'
          exporting
            element = 'COMP1'
            window  = 'MAIN'.
      endloop.
      call function 'WRITE_FORM'
        exporting
          element = 'COMP2'
          window  = 'MAIN'.
    endif.
  endif.

*  ENDAT.


*  LOOP AT IT_TAZM1 INTO WA_TAZM1.
*    WRITE : / WA_TAZM1-ENAME,WA_TAZM1-ZZ_HQDESC,WA_TAZM1-SHORT,WA_TAZM1-JOIN_DT,WA_TAZM1-LPQRT1,WA_TAZM1-LPQRT2,WA_TAZM1-LPQRT3,WA_TAZM1-LPQRT4,
*    WA_TAZM1-LCUMM,WA_TAZM1-LGRW,WA_TAZM1-CP3,WA_TAZM1-CP2,WA_TAZM1-CP1,WA_TAZM1-CPQRT1,WA_TAZM1-CPQRT2,WA_TAZM1-CPQRT3,WA_TAZM1-CPQRT4,
*    WA_TAZM1-CCUMM,WA_TAZM1-CGRW,
*    WA_TAZM1-NOOFPSO,WA_TAZM1-PROM,WA_TAZM1-LYSALE1,WA_TAZM1-LYSALE2,WA_TAZM1-LYSALE3,WA_TAZM1-LYSALE4,WA_TAZM1-LYSALE,WA_TAZM1-CTAR,WA_TAZM1-C3SALE,
*    WA_TAZM1-C2SALE,WA_TAZM1-C1SALE,WA_TAZM1-CYSALE1,WA_TAZM1-CYSALE2,WA_TAZM1-CYSALE3,WA_TAZM1-CYSALE4,WA_TAZM1-CYSALE,
*    WA_TAZM1-LYSALEC1, WA_TAZM1-LYSALEC2,WA_TAZM1-LYSALEC3,WA_TAZM1-LYSALEC4, WA_TAZM1-LYSALEC.
*  ENDLOOP.
  if r21 eq 'X'.

    wa_fieldcat-fieldname = 'ENAME'.
    wa_fieldcat-seltext_l = 'ZM NAME'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'ZZ_HQDESC'.
    wa_fieldcat-seltext_l = 'ZM HQ'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'SHORT'.
    wa_fieldcat-seltext_l = 'DESIG.'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'JOIN_DT'.
    wa_fieldcat-seltext_l = 'JOIN DATE'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'LPQRT1'.
    wa_fieldcat-seltext_l = 'LY QRT1'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'LPQRT2'.
    wa_fieldcat-seltext_l = 'LY QRT12'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'LPQRT3'.
    wa_fieldcat-seltext_l = 'LY QRT3'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'LPQRT4'.
    wa_fieldcat-seltext_l = 'LY QRT4'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'LCUMM'.
    wa_fieldcat-seltext_l = 'LY CUMM'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'LGRW'.
    wa_fieldcat-seltext_l = 'LY GROWTH'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'CP3'.
    wa_fieldcat-seltext_l = nmonth3.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'CP2'.
    wa_fieldcat-seltext_l = nmonth2.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'CP1'.
    wa_fieldcat-seltext_l = nmonth1.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'CPQRT1'.
    wa_fieldcat-seltext_l = 'Q-1'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'CPQRT2'.
    wa_fieldcat-seltext_l = 'Q-2'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'CPQRT3'.
    wa_fieldcat-seltext_l = 'Q-3'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'CPQRT4'.
    wa_fieldcat-seltext_l = 'Q-4'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'CCUMM'.
    wa_fieldcat-seltext_l = 'CY'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'CGRW'.
    wa_fieldcat-seltext_l = 'CY GROWTH'.
    append wa_fieldcat to fieldcat.

*   WA_TAZM1-NOOFPSO,WA_TAZM1-PROM,WA_TAZM1-LYSALE1,WA_TAZM1-LYSALE2,WA_TAZM1-LYSALE3,WA_TAZM1-LYSALE4,WA_TAZM1-LYSALE,


    wa_fieldcat-fieldname = 'NOOFPSO'.
    wa_fieldcat-seltext_l = 'NO. OF PSO'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'PROM'.
    wa_fieldcat-seltext_l = 'PROMOTION'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'LYSALE1'.
    wa_fieldcat-seltext_l = 'LY QTR1 SALE'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'LYSALE2'.
    wa_fieldcat-seltext_l = 'LY QTR2 SALE'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'LYSALE3'.
    wa_fieldcat-seltext_l = 'LY QTR3 SALE'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'LYSALE4'.
    wa_fieldcat-seltext_l = 'LY QTR4 SALE'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'LYSALE'.
    wa_fieldcat-seltext_l = 'LY CUMM SALE'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'CTAR'.
    wa_fieldcat-seltext_l = 'CY TARGET'.
    append wa_fieldcat to fieldcat.
*  WA_TAZM1-CTAR,WA_TAZM1-C3SALE,
*    WA_TAZM1-C2SALE,WA_TAZM1-C1SALE,WA_TAZM1-CYSALE1,WA_TAZM1-CYSALE2,WA_TAZM1-CYSALE3,WA_TAZM1-CYSALE4,WA_TAZM1-CYSALE,
*    WA_TAZM1-LYSALEC1, WA_TAZM1-LYSALEC2,WA_TAZM1-LYSALEC3,WA_TAZM1-LYSALEC4, WA_TAZM1-LYSALEC.

    concatenate nmonth3 'SALE' into nmon3 separated by space.
    concatenate nmonth2 'SALE' into nmon2 separated by space.
    concatenate nmonth1 'SALE' into nmon1 separated by space.

    wa_fieldcat-fieldname = 'C3SALE'.
    wa_fieldcat-seltext_l = nmon3.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

    wa_fieldcat-fieldname = 'C2SALE'.
    wa_fieldcat-seltext_l = nmon2.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

    wa_fieldcat-fieldname = 'C1SALE'.
    wa_fieldcat-seltext_l = nmon1.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

    wa_fieldcat-fieldname = 'CYSALE1'.
    wa_fieldcat-seltext_l = 'CY Q-1 SALE'.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

    wa_fieldcat-fieldname = 'CYSALE2'.
    wa_fieldcat-seltext_l = 'CY Q-2 SALE'.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

    wa_fieldcat-fieldname = 'CYSALE3'.
    wa_fieldcat-seltext_l = 'CY Q-3 SALE'.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

    wa_fieldcat-fieldname = 'CYSALE4'.
    wa_fieldcat-seltext_l = 'CY Q-4 SALE'.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

    wa_fieldcat-fieldname = 'CYSALE'.
    wa_fieldcat-seltext_l = 'CY CUMM SALE'.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

    wa_fieldcat-fieldname = 'LYSALEC1'.
    wa_fieldcat-seltext_l = 'LY THIRD LINE SALE1'.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

    wa_fieldcat-fieldname = 'LYSALEC2'.
    wa_fieldcat-seltext_l = 'LY THIRD LINE SALE2'.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

    wa_fieldcat-fieldname = 'LYSALEC3'.
    wa_fieldcat-seltext_l = 'LY THIRD LINE SALE3'.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

    wa_fieldcat-fieldname = 'LYSALEC4'.
    wa_fieldcat-seltext_l = 'LY THIRD LINE SALE4'.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

    wa_fieldcat-fieldname = 'LYSALEC'.
    wa_fieldcat-seltext_l = 'LY THIRD LINE CUMM SALE'.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.


    layout-zebra = 'X'.
    layout-colwidth_optimize = 'X'.
    layout-window_titlebar  = 'STOCK RECEIPT DETAIL'.


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
        t_outtab                = it_tazm1
      exceptions
        program_error           = 1
        others                  = 2.
    if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.



  elseif r22 eq 'X'.

    wa_fieldcat-fieldname = 'ENAME'.
    wa_fieldcat-seltext_l = 'ZM NAME'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'ZZ_HQDESC'.
    wa_fieldcat-seltext_l = 'ZM HQ'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'SHORT'.
    wa_fieldcat-seltext_l = 'DESIG.'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'JOIN_DT'.
    wa_fieldcat-seltext_l = 'JOIN DATE'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'LPQRT1'.
    wa_fieldcat-seltext_l = 'LY QRT1'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'LPQRT2'.
    wa_fieldcat-seltext_l = 'LY QRT12'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'LPQRT3'.
    wa_fieldcat-seltext_l = 'LY QRT3'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'LPQRT4'.
    wa_fieldcat-seltext_l = 'LY QRT4'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'LCUMM'.
    wa_fieldcat-seltext_l = 'LY CUMM'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'LGRW'.
    wa_fieldcat-seltext_l = 'LY GROWTH'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'CP3'.
    wa_fieldcat-seltext_l = nmonth3.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'CP2'.
    wa_fieldcat-seltext_l = nmonth2.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'CP1'.
    wa_fieldcat-seltext_l = nmonth1.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'CPQRT1'.
    wa_fieldcat-seltext_l = 'Q-1'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'CPQRT2'.
    wa_fieldcat-seltext_l = 'Q-2'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'CPQRT3'.
    wa_fieldcat-seltext_l = 'Q-3'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'CPQRT4'.
    wa_fieldcat-seltext_l = 'Q-4'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'CCUMM'.
    wa_fieldcat-seltext_l = 'CY'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'CGRW'.
    wa_fieldcat-seltext_l = 'CY GROWTH'.
    append wa_fieldcat to fieldcat.

*   WA_TAZM1-NOOFPSO,WA_TAZM1-PROM,WA_TAZM1-LYSALE1,WA_TAZM1-LYSALE2,WA_TAZM1-LYSALE3,WA_TAZM1-LYSALE4,WA_TAZM1-LYSALE,


    wa_fieldcat-fieldname = 'NOOFPSO'.
    wa_fieldcat-seltext_l = 'NO. OF PSO'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'PROM'.
    wa_fieldcat-seltext_l = 'PROMOTION'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'LYSALE1'.
    wa_fieldcat-seltext_l = 'LY QTR1 SALE'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'LYSALE2'.
    wa_fieldcat-seltext_l = 'LY QTR2 SALE'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'LYSALE3'.
    wa_fieldcat-seltext_l = 'LY QTR3 SALE'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'LYSALE4'.
    wa_fieldcat-seltext_l = 'LY QTR4 SALE'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'LYSALE'.
    wa_fieldcat-seltext_l = 'LY CUMM SALE'.
    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'CTAR'.
    wa_fieldcat-seltext_l = 'CY TARGET'.
    append wa_fieldcat to fieldcat.
*  WA_TAZM1-CTAR,WA_TAZM1-C3SALE,
*    WA_TAZM1-C2SALE,WA_TAZM1-C1SALE,WA_TAZM1-CYSALE1,WA_TAZM1-CYSALE2,WA_TAZM1-CYSALE3,WA_TAZM1-CYSALE4,WA_TAZM1-CYSALE,
*    WA_TAZM1-LYSALEC1, WA_TAZM1-LYSALEC2,WA_TAZM1-LYSALEC3,WA_TAZM1-LYSALEC4, WA_TAZM1-LYSALEC.

    concatenate nmonth3 'SALE' into nmon3 separated by space.
    concatenate nmonth2 'SALE' into nmon2 separated by space.
    concatenate nmonth1 'SALE' into nmon1 separated by space.

    wa_fieldcat-fieldname = 'C3SALE'.
    wa_fieldcat-seltext_l = nmon3.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

    wa_fieldcat-fieldname = 'C2SALE'.
    wa_fieldcat-seltext_l = nmon2.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

    wa_fieldcat-fieldname = 'C1SALE'.
    wa_fieldcat-seltext_l = nmon1.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

    wa_fieldcat-fieldname = 'CYSALE1'.
    wa_fieldcat-seltext_l = 'CY Q-1 SALE'.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

    wa_fieldcat-fieldname = 'CYSALE2'.
    wa_fieldcat-seltext_l = 'CY Q-2 SALE'.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

    wa_fieldcat-fieldname = 'CYSALE3'.
    wa_fieldcat-seltext_l = 'CY Q-3 SALE'.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

    wa_fieldcat-fieldname = 'CYSALE4'.
    wa_fieldcat-seltext_l = 'CY Q-4 SALE'.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

    wa_fieldcat-fieldname = 'CYSALE'.
    wa_fieldcat-seltext_l = 'CY CUMM SALE'.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

    wa_fieldcat-fieldname = 'LYSALEC1'.
    wa_fieldcat-seltext_l = 'LY THIRD LINE SALE1'.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

    wa_fieldcat-fieldname = 'LYSALEC2'.
    wa_fieldcat-seltext_l = 'LY THIRD LINE SALE2'.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

    wa_fieldcat-fieldname = 'LYSALEC3'.
    wa_fieldcat-seltext_l = 'LY THIRD LINE SALE3'.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

    wa_fieldcat-fieldname = 'LYSALEC4'.
    wa_fieldcat-seltext_l = 'LY THIRD LINE SALE4'.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

    wa_fieldcat-fieldname = 'LYSALEC'.
    wa_fieldcat-seltext_l = 'LY THIRD LINE CUMM SALE'.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.


    layout-zebra = 'X'.
    layout-colwidth_optimize = 'X'.
    layout-window_titlebar  = 'STOCK RECEIPT DETAIL'.


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
        t_outtab                = it_tarm1
      exceptions
        program_error           = 1
        others                  = 2.
    if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.


  endif.
endform.                    "DIV1


*&---------------------------------------------------------------------*
*&      Form  zm_DIV1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form zm_div1.
  loop at it_tab8 into wa_tab8.
    select single * from zdsmter where zmonth eq month and zyear eq year and bzirk eq wa_tab8-reg.
    if sy-subrc eq 0.
      wa_sm1-sm = zdsmter-zdsm.
      wa_sm1-reg = wa_tab8-reg.
      collect wa_sm1 into it_sm1.
      clear wa_sm1.
      wa_sm2-sm = zdsmter-zdsm.
      collect wa_sm2 into it_sm2.
      clear wa_sm2.
    endif.
  endloop.
  sort it_sm1 by sm reg.
  delete adjacent duplicates from it_sm1 comparing sm reg.
  sort it_sm2 by sm.
  delete adjacent duplicates from it_sm2 comparing sm.

  loop at it_sm2 into wa_sm2.
    clear : smname.
    loop at it_smtab8 into wa_smtab8 where sm = wa_sm2-sm.
      select single * from yterrallc where bzirk eq wa_sm2-sm and endda ge sy-datum.
      if sy-subrc eq 0.
        select single * from pa0001 where plans eq yterrallc-plans and endda ge sy-datum.
        if sy-subrc eq 0.
          smname = pa0001-ename.
        endif.
      endif.
      clear : zdiff.
      zdiff = wa_smtab8-lysale - wa_smtab8-lysalec.
      call function 'WRITE_FORM'
        exporting
          element = 'SM1'
          window  = 'MAIN'.

      call function 'WRITE_FORM'
        exporting
          element = 'SMDET1'
          window  = 'MAIN'.

      if zdiff gt 1 or zdiff lt -1.
        if wa_smtab8-lysalec gt 0.
          call function 'WRITE_FORM'
            exporting
              element = 'SMDET2'
              window  = 'MAIN'.
        endif.
      endif.
      call function 'WRITE_FORM'
        exporting
          element = 'SMDET3'
          window  = 'MAIN'.

      loop at it_sm1 into wa_sm1 where sm = wa_sm2-sm.
        loop at it_tab8 into wa_tab8 where reg eq wa_sm1-reg.
*     AND ZMPERNR EQ WA_TAP1-PERNR.
          select single * from zdsmter where zmonth eq month and zyear eq year and zdsm eq wa_taz1-bzirk and bzirk eq wa_tab8-reg.
          if sy-subrc eq 0.
            clear : rm_name,rm_short,pjoin_dt,zm_name,zone,rm_zone,zdiff,a.

            on change of wa_tab8-reg.
              call function 'WRITE_FORM'
                exporting
                  element = 'V2'
                  window  = 'MAIN'.
              call function 'WRITE_FORM'
                exporting
                  element = 'VL'
                  window  = 'MAIN'.
            endon.

            on change of wa_tab8-reg.
              zdiff = wa_tab8-lysale - wa_tab8-lysalec.
              call function 'WRITE_FORM'
                exporting
                  element = 'DET1'
                  window  = 'MAIN'.
              if zdiff gt 1 or zdiff lt -1.
                if wa_tab8-lysalec gt 0.
                  call function 'WRITE_FORM'
                    exporting
                      element = 'DET2'
                      window  = 'MAIN'.
                endif.
              endif.
            endon.

            loop at it_zm2 into wa_zm2 where reg = wa_tab8-reg and ctar gt 0 .
              if wa_zm2-zm ne '      '.
                if wa_zm2-cgrw ge grw1 and wa_zm2-cgrw le grw2.
                  if wa_zm2-ccumm ge per1 and wa_zm2-ccumm le per2.
                    call function 'WRITE_FORM'
                      exporting
                        element = 'VL'
                        window  = 'MAIN'.
                    clear : rdiff.
                    dzmdiff = wa_zm2-lysale - wa_zm2-lysalec.
                    call function 'WRITE_FORM'
                      exporting
                        element = 'DZM1'
                        window  = 'MAIN'.
                    if dzmdiff gt 1 or dzmdiff lt -1.
                      if wa_zm2-lysalec gt 0.
                        call function 'WRITE_FORM'
                          exporting
                            element = 'DZM2'
                            window  = 'MAIN'.
                      endif.
                    endif.
                    call function 'WRITE_FORM'
                      exporting
                        element = 'DZM3'
                        window  = 'MAIN'.
                  endif.
                endif.
              endif.
              loop at it_rm2 into wa_rm2 where reg = wa_tab8-reg and zm = wa_zm2-zm and ctar gt 0.
                clear: rconfprob.
                read table it_pso2 into wa_pso2 with key rm = wa_rm2-rm.
                if sy-subrc = 0.
                  rconfprob = wa_pso2-rconf_prob.
                endif.

                if wa_rm2-cgrw ge grw1 and wa_rm2-cgrw le grw2.
                  if wa_rm2-ccumm ge per1 and wa_rm2-ccumm le per2.
                    call function 'WRITE_FORM'
                      exporting
                        element = 'VL'
                        window  = 'MAIN'.
                    clear : rdiff.
                    rdiff = wa_rm2-lysale - wa_rm2-lysalec.
                    call function 'WRITE_FORM'
                      exporting
                        element = 'RM1'
                        window  = 'MAIN'.
                    if rdiff gt 1 or rdiff lt -1.
                      if wa_rm2-lysalec gt 0.
                        call function 'WRITE_FORM'
                          exporting
                            element = 'RM2'
                            window  = 'MAIN'.
                      endif.
                    endif.
                    call function 'WRITE_FORM'
                      exporting
                        element = 'RM3'
                        window  = 'MAIN'.
                  endif.
                endif.
                loop at it_pso2 into wa_pso2 where rm = wa_rm2-rm and ctar gt 0.
                  clear confprob.
                  confprob = wa_pso2-conf_prob.
                  if wa_pso2-cgrw ge grw1 and wa_pso2-cgrw le grw2.
                    if wa_pso2-ccumm ge per1 and wa_pso2-ccumm le per2.
                      call function 'WRITE_FORM'
                        exporting
                          element = 'VL'
                          window  = 'MAIN'.
                      clear : pdiff.
                      pdiff = wa_pso2-lysale - wa_pso2-lysalec.
                      call function 'WRITE_FORM'
                        exporting
                          element = 'PSO1'
                          window  = 'MAIN'.
                      if pdiff gt 1 or pdiff lt -1.
                        if wa_pso2-lysalec gt 0.
                          call function 'WRITE_FORM'
                            exporting
                              element = 'PSO2'
                              window  = 'MAIN'.
                        endif.
                      endif.
                      call function 'WRITE_FORM'
                        exporting
                          element = 'PSO3'
                          window  = 'MAIN'.
                    endif.
                  endif.
                endloop.
              endloop.
            endloop.
            at last.
              b = 1.
            endat.
            at end of reg.
              call function 'WRITE_FORM'
                exporting
                  element = 'L2'
                  window  = 'MAIN'.
            endat.
            if b ne 1 .
              at end of reg.
                call function 'WRITE_FORM'
                  exporting
                    element = 'L1'
                    window  = 'MAIN'.
              endat.
            endif.
          endif.
        endloop.
      endloop.
    endloop.
  endloop.
endform.                    "DIV1

*&---------------------------------------------------------------------*
*&      Form  Dzm_DIV1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form dzm_div1.
  loop at it_zm2 into wa_zm2 where zm ne '      '  and dzmpernr eq wa_tap1-pernr.
    clear : rm_name,rm_short,pjoin_dt,zm_name,zone,rm_zone,zdiff,a.

    on change of wa_zm2-zm.
      call function 'WRITE_FORM'
        exporting
          element = 'V2'
          window  = 'MAIN'.
      call function 'WRITE_FORM'
        exporting
          element = 'VL'
          window  = 'MAIN'.
    endon.


    if wa_zm2-zm ne '      '.
*      IF WA_ZM2-CGRW GE GRW1 AND WA_ZM2-CGRW LE GRW2.
*        IF WA_ZM2-CCUMM GE PER1 AND WA_ZM2-CCUMM LE PER2.
      call function 'WRITE_FORM'
        exporting
          element = 'VL'
          window  = 'MAIN'.
      clear : rdiff.
      dzmdiff = wa_zm2-lysale - wa_zm2-lysalec.
      call function 'WRITE_FORM'
        exporting
          element = 'DZM1'
          window  = 'MAIN'.
      if dzmdiff gt 1 or dzmdiff lt -1.
        if wa_zm2-lysalec gt 0.
          call function 'WRITE_FORM'
            exporting
              element = 'DZM2'
              window  = 'MAIN'.
        endif.
      endif.
      call function 'WRITE_FORM'
        exporting
          element = 'DZM3'
          window  = 'MAIN'.
*        ENDIF.
*      ENDIF.
    endif.
    loop at it_rm2 into wa_rm2 where zm = wa_zm2-zm and ctar gt 0.
      if wa_rm2-cgrw ge grw1 and wa_rm2-cgrw le grw2.
        if wa_rm2-ccumm ge per1 and wa_rm2-ccumm le per2.
          if wa_rm2-div eq ddiv.
            call function 'WRITE_FORM'
              exporting
                element = 'VL'
                window  = 'MAIN'.
            clear : rdiff.
            rdiff = wa_rm2-lysale - wa_rm2-lysalec.
            call function 'WRITE_FORM'
              exporting
                element = 'RM1'
                window  = 'MAIN'.
            if rdiff gt 1 or rdiff lt -1.
              if wa_rm2-lysalec gt 0.
                call function 'WRITE_FORM'
                  exporting
                    element = 'RM2'
                    window  = 'MAIN'.
              endif.
            endif.
            call function 'WRITE_FORM'
              exporting
                element = 'RM3'
                window  = 'MAIN'.
          endif.
        endif.
      endif.
      loop at it_pso2 into wa_pso2 where rm = wa_rm2-rm and ctar gt 0 and div eq ddiv.
        if wa_pso2-cgrw ge grw1 and wa_pso2-cgrw le grw2.
          if wa_pso2-ccumm ge per1 and wa_pso2-ccumm le per2.
            call function 'WRITE_FORM'
              exporting
                element = 'VL'
                window  = 'MAIN'.
            clear : pdiff.
            pdiff = wa_pso2-lysale - wa_pso2-lysalec.
            call function 'WRITE_FORM'
              exporting
                element = 'PSO1'
                window  = 'MAIN'.
            if pdiff gt 1 or pdiff lt -1.
              if wa_pso2-lysalec gt 0.
                call function 'WRITE_FORM'
                  exporting
                    element = 'PSO2'
                    window  = 'MAIN'.
              endif.
            endif.
            call function 'WRITE_FORM'
              exporting
                element = 'PSO3'
                window  = 'MAIN'.
          endif.
        endif.
      endloop.
    endloop.

    at last.
      b = 1.
    endat.
    at end of zm.
      call function 'WRITE_FORM'
        exporting
          element = 'L2'
          window  = 'MAIN'.
    endat.
    if b ne 1 .
      at end of zm.
        call function 'WRITE_FORM'
          exporting
            element = 'L1'
            window  = 'MAIN'.
      endat.
    endif.
  endloop.

endform.                    "DIV1


*&---------------------------------------------------------------------*
*&      Form  RM_DIV1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form rm_div1.
  loop at it_rm2 into wa_rm2 where rm ne '      '  and rmpernr eq wa_tap1-pernr.
    clear : rm_name,rm_short,pjoin_dt,zm_name,zone,rm_zone,zdiff,a.

    on change of wa_rm2-rm.
      call function 'WRITE_FORM'
        exporting
          element = 'V2'
          window  = 'MAIN'.
      call function 'WRITE_FORM'
        exporting
          element = 'VL'
          window  = 'MAIN'.
    endon.

*    IF WA_RM2-CGRW GE GRW1 AND WA_RM2-CGRW LE GRW2.
*      IF WA_RM2-CCUMM GE PER1 AND WA_RM2-CCUMM LE PER2.
    call function 'WRITE_FORM'
      exporting
        element = 'VL'
        window  = 'MAIN'.
    clear : rdiff.
    rdiff = wa_rm2-lysale - wa_rm2-lysalec.
    call function 'WRITE_FORM'
      exporting
        element = 'RM1'
        window  = 'MAIN'.
    if rdiff gt 1 or rdiff lt -1.
      if wa_rm2-lysalec gt 0.
        call function 'WRITE_FORM'
          exporting
            element = 'RM2'
            window  = 'MAIN'.
      endif.
    endif.
    call function 'WRITE_FORM'
      exporting
        element = 'RM3'
        window  = 'MAIN'.
*      ENDIF.
*    ENDIF.
    loop at it_pso2 into wa_pso2 where rm = wa_rm2-rm and ctar gt 0.
      if wa_pso2-cgrw ge grw1 and wa_pso2-cgrw le grw2.
        if wa_pso2-ccumm ge per1 and wa_pso2-ccumm le per2.
          call function 'WRITE_FORM'
            exporting
              element = 'VL'
              window  = 'MAIN'.
          clear : pdiff.
          pdiff = wa_pso2-lysale - wa_pso2-lysalec.
          call function 'WRITE_FORM'
            exporting
              element = 'PSO1'
              window  = 'MAIN'.
          if pdiff gt 1 or pdiff lt -1.
            if wa_pso2-lysalec gt 0.
              call function 'WRITE_FORM'
                exporting
                  element = 'PSO2'
                  window  = 'MAIN'.
            endif.
          endif.
          call function 'WRITE_FORM'
            exporting
              element = 'PSO3'
              window  = 'MAIN'.
        endif.
      endif.
    endloop.
    at last.
      b = 1.
    endat.
    if a eq 1.
      at end of rm.
        call function 'WRITE_FORM'
          exporting
            element = 'L2'
            window  = 'MAIN'.
      endat.
    endif.
    if b ne 1 and a eq 1.
      at end of rm.
        call function 'WRITE_FORM'
          exporting
            element = 'L1'
            window  = 'MAIN'.
      endat.
    endif.
  endloop.

endform.                    "DIV1



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
*     form     = 'ZSR24_1'
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
      form        = 'ZSR11_N1_3N'
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


  sort it_tab8 by seq.
  sort it_zm2 by zm.
  sort it_rm2 by reg rm.
  sort it_pso2 by reg zm rm bzirk.


  sort it_tab8 by seq.
  sort it_zm2 by zm.
  sort it_rm2 by reg rm.
  sort it_pso2 by reg zm rm bzirk.
  concatenate lyear+2(2) '-' cyear+2(2) into ly.
  concatenate cyear+2(2) '-' ccyear+2(2) into cy.
  select single * from t247 where spras eq 'EN' and mnr eq date1+4(2).
  if sy-subrc eq 0.
    nmonth1 = t247-ktx.
  endif.
  select single * from t247 where spras eq 'EN' and mnr eq date4+4(2).
  if sy-subrc eq 0.
    nmonth2 = t247-ktx.
  endif.
  select single * from t247 where spras eq 'EN' and mnr eq date5+4(2).
  if sy-subrc eq 0.
    nmonth3 = t247-ktx.
  endif.
  if d1 eq 'X'.
    perform div1.
  elseif d5 eq 'X'.
    delete it_tab8 where div eq 'XL'.
    delete it_rm2 where div eq 'XL'.
    delete it_zm2 where div eq 'XL'.

    delete it_tab8 where div eq 'LS'.
    delete it_rm2 where div eq 'LS'.
    delete it_zm2 where div eq 'LS'.
    perform div1.
  else.
    perform div2.
  endif.

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

*  write s_budat-low to wa_d1 dd/mm/yyyy.
*  write s_budat-high to wa_d2 dd/mm/yyyy.

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
  concatenate 'SR-11' '.'  into doc_chng-obj_descr separated by space.
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

  concatenate 'SR-11' '.' sy-datum into objpack-obj_descr separated by space.
  objpack-doc_size = righe_attachment * 255.
  append objpack.
  clear objpack.

*  LOOP at it_tac4 INTO wa_tac4.
*    WRITE : / wa_tac4-bzirk,wa_tac4-usrid_long.
*    loop at it_tam2 into wa_tam2 where pernr = wa_tam1-pernr.
  reclist-receiver =   uemail.
  reclist-express = 'X'.
  reclist-rec_type = 'U'.
  reclist-notif_del = 'X'. " request delivery notification
  reclist-notif_ndel = 'X'. " request not delivered notification
  append reclist.
  clear reclist.
*  endloop.
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

endform.                    "LAYOUT




*&---------------------------------------------------------------------*
*&      Form  EMAIL_zm
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form email_zm.
  loop at it_tab8 into wa_tab8.
    wa_tap1-pernr = wa_tab8-zmpernr.
    collect wa_tap1 into it_tap1.
    clear wa_tap1.
  endloop.
  sort it_tap1 by pernr.
  delete adjacent duplicates from it_tap1 comparing pernr.

  loop at it_tap1 into wa_tap1.
    select single * from pa0105 where pernr eq wa_tap1-pernr and subty eq '0010'.
    if sy-subrc eq 0.
      wa_tap2-pernr = wa_tap1-pernr.
      wa_tap2-usrid_long = pa0105-usrid_long.
      collect wa_tap2 into it_tap2.
      clear wa_tap2.
    endif.
  endloop.

  sort it_tab8 by seq.
  sort it_zm2 by zm.
  sort it_rm2 by reg rm.
  sort it_pso2 by reg zm rm bzirk.
  concatenate lyear+2(2) '-' cyear+2(2) into ly.
  concatenate cyear+2(2) '-' ccyear+2(2) into cy.
  select single * from t247 where spras eq 'EN' and mnr eq date1+4(2).
  if sy-subrc eq 0.
    nmonth1 = t247-ktx.
  endif.
  select single * from t247 where spras eq 'EN' and mnr eq date4+4(2).
  if sy-subrc eq 0.
    nmonth2 = t247-ktx.
  endif.
  select single * from t247 where spras eq 'EN' and mnr eq date5+4(2).
  if sy-subrc eq 0.
    nmonth3 = t247-ktx.
  endif.

  options-tdgetotf = 'X'.
  loop at it_tap1 into wa_tap1 where pernr ne '00000000'.
    on change of wa_tab8-reg.
      a = 0.
    endon.
    loop at it_tab8 into wa_tab8 where zmpernr = wa_tap1-pernr.
      loop at it_zm2 into wa_zm2 where reg = wa_tab8-reg and cgrw ge grw1 and cgrw le grw2 and ccumm ge per1 and ccumm le per2.
        a = 1.
      endloop.
      loop at it_rm2 into wa_rm2 where reg = wa_tab8-reg and cgrw ge grw1 and cgrw le grw2 and ccumm ge per1 and ccumm le per2.
        a = 1.
      endloop.
      loop at it_pso2 into wa_pso2 where reg = wa_tab8-reg and cgrw ge grw1 and cgrw le grw2 and ccumm ge per1 and ccumm le per2.
        a = 1.
      endloop.
    endloop.
    if a eq 1.
      call function 'OPEN_FORM'
        exporting
          device   = 'PRINTER'
          dialog   = ''
*         form     = 'ZSR24_1'
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
          form        = 'ZSR11_N1_3N'
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

*      PERFORM ZM_DIV1.
      perform zm_div1_1.

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

*  write s_budat-low to wa_d1 dd/mm/yyyy.
*  write s_budat-high to wa_d2 dd/mm/yyyy.

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
      concatenate 'SR-11' 'ZM'  into doc_chng-obj_descr separated by space.
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

      concatenate 'SR-11' '.' sy-datum into objpack-obj_descr separated by space.
      objpack-doc_size = righe_attachment * 255.
      append objpack.
      clear objpack.

*  LOOP at it_tac4 INTO wa_tac4.
*    WRITE : / wa_tac4-bzirk,wa_tac4-usrid_long.
      loop at it_tap2 into wa_tap2 where pernr = wa_tap1-pernr.
        reclist-receiver =   wa_tap2-usrid_long.
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


*      if sy-subrc eq 0.
*
*        write : / 'EMAIL SENT ON ',uemail.
*      endif.



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
      loop at it_tap2 into wa_tap2 where pernr eq wa_tap1-pernr.
        format color 5.
        write : / 'EMAIL HAS BEEN SENT ON',wa_tap2-usrid_long.
      endloop.
    else.
      loop at it_tap2 into wa_tap2 where pernr eq wa_tap1-pernr.
        format color 6.
        write : / 'NO DATA FOUND FOR : ',wa_tap2-usrid_long.
      endloop.

    endif.
  endloop.

*  loop at it_tap2 into wa_tap2.
*    write : / 'EMAIL HAS BEEN SENT ON',wa_tap2-usrid_long.
*  endloop.

endform.                    "LAYOUT


*&---------------------------------------------------------------------*
*&      Form  email_zm1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form email_zm1.
**************ONLY SELECTED DIVISION***********
  loop at it_tab8 into wa_tab8.
    wa_tap1-pernr = wa_tab8-zmpernr.
    collect wa_tap1 into it_tap1.
    clear wa_tap1.
  endloop.
  sort it_tap1 by pernr.
  delete adjacent duplicates from it_tap1 comparing pernr.

  loop at it_tap1 into wa_tap1.
    select single * from pa0105 where pernr eq wa_tap1-pernr and subty eq '0010'.
    if sy-subrc eq 0.
      wa_tap2-pernr = wa_tap1-pernr.
      wa_tap2-usrid_long = pa0105-usrid_long.
      collect wa_tap2 into it_tap2.
      clear wa_tap2.
    endif.
  endloop.

  sort it_tab8 by seq.
  sort it_zm2 by zm.
  sort it_rm2 by reg rm.
  sort it_pso2 by reg zm rm bzirk.
  concatenate lyear+2(2) '-' cyear+2(2) into ly.
  concatenate cyear+2(2) '-' ccyear+2(2) into cy.
  select single * from t247 where spras eq 'EN' and mnr eq date1+4(2).
  if sy-subrc eq 0.
    nmonth1 = t247-ktx.
  endif.
  select single * from t247 where spras eq 'EN' and mnr eq date4+4(2).
  if sy-subrc eq 0.
    nmonth2 = t247-ktx.
  endif.
  select single * from t247 where spras eq 'EN' and mnr eq date5+4(2).
  if sy-subrc eq 0.
    nmonth3 = t247-ktx.
  endif.

  options-tdgetotf = 'X'.
  loop at it_tap1 into wa_tap1 where pernr ne '00000000'.
    on change of wa_tab8-reg.
      a = 0.
    endon.
    loop at it_tab8 into wa_tab8 where zmpernr = wa_tap1-pernr.
      loop at it_zm2 into wa_zm2 where reg = wa_tab8-reg and div eq ddiv and cgrw ge grw1 and cgrw le grw2 and ccumm ge per1 and ccumm le per2.
        a = 1.
      endloop.
      loop at it_rm2 into wa_rm2 where reg = wa_tab8-reg and div eq ddiv and cgrw ge grw1 and cgrw le grw2 and ccumm ge per1 and ccumm le per2.
        a = 1.
      endloop.
      loop at it_pso2 into wa_pso2 where reg = wa_tab8-reg and div eq ddiv and cgrw ge grw1 and cgrw le grw2 and ccumm ge per1 and ccumm le per2.
        a = 1.
      endloop.
    endloop.
    if a eq 1.
      call function 'OPEN_FORM'
        exporting
          device   = 'PRINTER'
          dialog   = ''
*         form     = 'ZSR24_1'
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
          form        = 'ZSR11_N1_3N'
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
*      PERFORM ZM_DIV2.
      perform zm_div2_1.

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

*  write s_budat-low to wa_d1 dd/mm/yyyy.
*  write s_budat-high to wa_d2 dd/mm/yyyy.

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
      concatenate 'SR-11' 'ZM'  into doc_chng-obj_descr separated by space.
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

      concatenate 'SR-11' '.' sy-datum into objpack-obj_descr separated by space.
      objpack-doc_size = righe_attachment * 255.
      append objpack.
      clear objpack.

*  LOOP at it_tac4 INTO wa_tac4.
*    WRITE : / wa_tac4-bzirk,wa_tac4-usrid_long.
      loop at it_tap2 into wa_tap2 where pernr = wa_tap1-pernr.
        reclist-receiver =   wa_tap2-usrid_long.
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


*      if sy-subrc eq 0.
*
*        write : / 'EMAIL SENT ON ',uemail.
*      endif.



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
      loop at it_tap2 into wa_tap2 where pernr eq wa_tap1-pernr.
        format color 5.
        write : / 'EMAIL HAS BEEN SENT ON',wa_tap2-usrid_long.
      endloop.
    else.
      loop at it_tap2 into wa_tap2 where pernr eq wa_tap1-pernr.
        format color 6.
        write : / 'NO DATA FOUND FOR : ',wa_tap2-usrid_long.
      endloop.

    endif.
  endloop.

*  loop at it_tap2 into wa_tap2.
*    write : / 'EMAIL HAS BEEN SENT ON',wa_tap2-usrid_long.
*  endloop.

endform.                    "LAYOUT


*&---------------------------------------------------------------------*
*&      Form  email_Dzm
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form email_dzm.
  loop at it_zm2 into wa_zm2.
    wa_tap1-pernr = wa_zm2-dzmpernr.
    collect wa_tap1 into it_tap1.
    clear wa_tap1.
  endloop.
  sort it_tap1 by pernr.
  delete adjacent duplicates from it_tap1 comparing pernr.

  loop at it_tap1 into wa_tap1.
    select single * from pa0105 where pernr eq wa_tap1-pernr and subty eq '0010'.
    if sy-subrc eq 0.
      wa_tap2-pernr = wa_tap1-pernr.
      wa_tap2-usrid_long = pa0105-usrid_long.
      collect wa_tap2 into it_tap2.
      clear wa_tap2.
    endif.
  endloop.

  sort it_tab8 by seq.
  sort it_zm2 by zm.
  sort it_rm2 by reg rm.
  sort it_pso2 by reg zm rm bzirk.
  concatenate lyear+2(2) '-' cyear+2(2) into ly.
  concatenate cyear+2(2) '-' ccyear+2(2) into cy.
  select single * from t247 where spras eq 'EN' and mnr eq date1+4(2).
  if sy-subrc eq 0.
    nmonth1 = t247-ktx.
  endif.
  select single * from t247 where spras eq 'EN' and mnr eq date4+4(2).
  if sy-subrc eq 0.
    nmonth2 = t247-ktx.
  endif.
  select single * from t247 where spras eq 'EN' and mnr eq date5+4(2).
  if sy-subrc eq 0.
    nmonth3 = t247-ktx.
  endif.

  options-tdgetotf = 'X'.
  loop at it_tap1 into wa_tap1 where pernr ne '00000000'.
    on change of wa_zm2-zm.
      a = 0.
    endon.

    loop at it_zm2 into wa_zm2 where dzmpernr eq wa_tap1-pernr.
      loop at it_rm2 into wa_rm2 where zm = wa_zm2-zm and cgrw ge grw1 and cgrw le grw2 and ccumm ge per1 and ccumm le per2.
        a = 1.
      endloop.
      loop at it_pso2 into wa_pso2 where zm = wa_zm2-zm and cgrw ge grw1 and cgrw le grw2 and ccumm ge per1 and ccumm le per2.
        a = 1.
      endloop.
    endloop.

    if a eq 1.
      call function 'OPEN_FORM'
        exporting
          device   = 'PRINTER'
          dialog   = ''
*         form     = 'ZSR24_1'
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
          form        = 'ZSR11_N1_3N'
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
      perform dzm_div1.

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

*  write s_budat-low to wa_d1 dd/mm/yyyy.
*  write s_budat-high to wa_d2 dd/mm/yyyy.

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
      concatenate 'SR-11' 'ZM'  into doc_chng-obj_descr separated by space.
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

      concatenate 'SR-11' '.' sy-datum into objpack-obj_descr separated by space.
      objpack-doc_size = righe_attachment * 255.
      append objpack.
      clear objpack.

*  LOOP at it_tac4 INTO wa_tac4.
*    WRITE : / wa_tac4-bzirk,wa_tac4-usrid_long.
      loop at it_tap2 into wa_tap2 where pernr = wa_tap1-pernr.
        reclist-receiver =   wa_tap2-usrid_long.
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


*      if sy-subrc eq 0.
*
*        write : / 'EMAIL SENT ON ',uemail.
*      endif.



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
      loop at it_tap2 into wa_tap2 where pernr eq wa_tap1-pernr.
        format color 5.
        write : / 'EMAIL HAS BEEN SENT ON',wa_tap2-usrid_long.
      endloop.
    else.
      loop at it_tap2 into wa_tap2 where pernr eq wa_tap1-pernr.
        format color 6.
        write : / 'NO DATA FOUND FOR : ',wa_tap2-usrid_long.
      endloop.

    endif.
  endloop.

*  loop at it_tap2 into wa_tap2.
*    write : / 'EMAIL HAS BEEN SENT ON',wa_tap2-usrid_long.
*  endloop.

endform.                    "LAYOUT


*&---------------------------------------------------------------------*
*&      Form  email_dzm1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form email_dzm1.
  loop at it_zm2 into wa_zm2.
    wa_tap1-pernr = wa_zm2-dzmpernr.
    collect wa_tap1 into it_tap1.
    clear wa_tap1.
  endloop.
  sort it_tap1 by pernr.
  delete adjacent duplicates from it_tap1 comparing pernr.

  loop at it_tap1 into wa_tap1.
    select single * from pa0105 where pernr eq wa_tap1-pernr and subty eq '0010'.
    if sy-subrc eq 0.
      wa_tap2-pernr = wa_tap1-pernr.
      wa_tap2-usrid_long = pa0105-usrid_long.
      collect wa_tap2 into it_tap2.
      clear wa_tap2.
    endif.
  endloop.

  sort it_tab8 by seq.
  sort it_zm2 by zm.
  sort it_rm2 by reg rm.
  sort it_pso2 by reg zm rm bzirk.
  concatenate lyear+2(2) '-' cyear+2(2) into ly.
  concatenate cyear+2(2) '-' ccyear+2(2) into cy.
  select single * from t247 where spras eq 'EN' and mnr eq date1+4(2).
  if sy-subrc eq 0.
    nmonth1 = t247-ktx.
  endif.
  select single * from t247 where spras eq 'EN' and mnr eq date4+4(2).
  if sy-subrc eq 0.
    nmonth2 = t247-ktx.
  endif.
  select single * from t247 where spras eq 'EN' and mnr eq date5+4(2).
  if sy-subrc eq 0.
    nmonth3 = t247-ktx.
  endif.

  options-tdgetotf = 'X'.
  loop at it_tap1 into wa_tap1 where pernr ne '00000000'.
    on change of wa_zm2-zm.
      a = 0.
    endon.

    loop at it_zm2 into wa_zm2 where dzmpernr eq wa_tap1-pernr.
      loop at it_rm2 into wa_rm2 where zm = wa_zm2-zm and div eq ddiv and cgrw ge grw1 and cgrw le grw2 and ccumm ge per1 and ccumm le per2.
        a = 1.
      endloop.
      loop at it_pso2 into wa_pso2 where zm = wa_zm2-zm and div eq ddiv and cgrw ge grw1 and cgrw le grw2 and ccumm ge per1 and ccumm le per2.
        a = 1.
      endloop.
    endloop.

    if a eq 1.
      call function 'OPEN_FORM'
        exporting
          device   = 'PRINTER'
          dialog   = ''
*         form     = 'ZSR24_1'
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
          form        = 'ZSR11_N1_3N'
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
      perform dzm_div1.

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

*  write s_budat-low to wa_d1 dd/mm/yyyy.
*  write s_budat-high to wa_d2 dd/mm/yyyy.

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
      concatenate 'SR-11' 'ZM'  into doc_chng-obj_descr separated by space.
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

      concatenate 'SR-11' '.' sy-datum into objpack-obj_descr separated by space.
      objpack-doc_size = righe_attachment * 255.
      append objpack.
      clear objpack.

*  LOOP at it_tac4 INTO wa_tac4.
*    WRITE : / wa_tac4-bzirk,wa_tac4-usrid_long.
      loop at it_tap2 into wa_tap2 where pernr = wa_tap1-pernr.
        reclist-receiver =   wa_tap2-usrid_long.
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


*      if sy-subrc eq 0.
*
*        write : / 'EMAIL SENT ON ',uemail.
*      endif.



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
      loop at it_tap2 into wa_tap2 where pernr eq wa_tap1-pernr.
        format color 5.
        write : / 'EMAIL HAS BEEN SENT ON',wa_tap2-usrid_long.
      endloop.
    else.
      loop at it_tap2 into wa_tap2 where pernr eq wa_tap1-pernr.
        format color 6.
        write : / 'NO DATA FOUND FOR : ',wa_tap2-usrid_long.
      endloop.

    endif.
  endloop.

*  loop at it_tap2 into wa_tap2.
*    write : / 'EMAIL HAS BEEN SENT ON',wa_tap2-usrid_long.
*  endloop.

endform.                    "LAYOUT

*&---------------------------------------------------------------------*
*&      Form  EMAIL_Rm
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form email_rm.
**************CONCIDER ALL DIVISION***********************
  loop at it_rm2 into wa_rm2.
    wa_tap1-pernr = wa_rm2-rmpernr.
    collect wa_tap1 into it_tap1.
    clear wa_tap1.
  endloop.
  sort it_tap1 by pernr.
  delete adjacent duplicates from it_tap1 comparing pernr.
  delete it_tap1 where pernr eq '00000000'.
  loop at it_tap1 into wa_tap1.
    select single * from pa0105 where pernr eq wa_tap1-pernr and subty eq '0010'.
    if sy-subrc eq 0.
      wa_tap2-pernr = wa_tap1-pernr.
      wa_tap2-usrid_long = pa0105-usrid_long.
      collect wa_tap2 into it_tap2.
      clear wa_tap2.
    endif.
  endloop.

  sort it_rm2 by reg rm.
  sort it_pso2 by reg zm rm bzirk.
  concatenate lyear+2(2) '-' cyear+2(2) into ly.
  concatenate cyear+2(2) '-' ccyear+2(2) into cy.
  select single * from t247 where spras eq 'EN' and mnr eq date1+4(2).
  if sy-subrc eq 0.
    nmonth1 = t247-ktx.
  endif.
  select single * from t247 where spras eq 'EN' and mnr eq date4+4(2).
  if sy-subrc eq 0.
    nmonth2 = t247-ktx.
  endif.
  select single * from t247 where spras eq 'EN' and mnr eq date5+4(2).
  if sy-subrc eq 0.
    nmonth3 = t247-ktx.
  endif.
  options-tdgetotf = 'X'.

  loop at it_tap1 into wa_tap1 where pernr ne '00000000'.
    on change of wa_tap1-pernr.
      a = 0.
    endon.
    loop at it_rm2 into wa_rm2 where rmpernr = wa_tap1-pernr.
      loop at it_pso2 into wa_pso2 where rm = wa_rm2-rm and cgrw ge grw1 and cgrw le grw2 and ccumm ge per1 and ccumm le per2.
        a = 1.
      endloop.
    endloop.

    if a eq 1.
      call function 'OPEN_FORM'
        exporting
          device   = 'PRINTER'
          dialog   = ''
*         form     = 'ZSR24_1'
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
          form        = 'ZSR11_N1_3N'
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



      perform rm_div1.

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

*  write s_budat-low to wa_d1 dd/mm/yyyy.
*  write s_budat-high to wa_d2 dd/mm/yyyy.

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
      concatenate 'SR-11.' 'RM'  into doc_chng-obj_descr separated by space.
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

      concatenate 'SR-11' 'RM' sy-datum into objpack-obj_descr separated by space.
      objpack-doc_size = righe_attachment * 255.
      append objpack.
      clear objpack.

*  LOOP at it_tac4 INTO wa_tac4.
*    WRITE : / wa_tac4-bzirk,wa_tac4-usrid_long.
      loop at it_tap2 into wa_tap2 where pernr = wa_tap1-pernr.
        reclist-receiver =   wa_tap2-usrid_long.
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


*      if sy-subrc eq 0.
*
*        write : / 'EMAIL SENT ON ',uemail.
*      endif.



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
      loop at it_tap2 into wa_tap2 where pernr eq wa_tap1-pernr.
        format color 5.
        write : / 'EMAIL HAS BEEN SENT ON',wa_tap2-usrid_long.
      endloop.
    else.
      loop at it_tap2 into wa_tap2 where pernr eq wa_tap1-pernr.
        format color 6.
        write : / 'NO DATA FOUND FOR : ',wa_tap2-usrid_long.
      endloop.
*      MESSAGE 'NO DATA FOUND' TYPE 'I'.
    endif.
  endloop.

*  loop at it_tap2 into wa_tap2.
*    write : / 'EMAIL HAS BEEN SENT ON',wa_tap2-usrid_long.
*  endloop.

endform.                    "LAYOUT



*&---------------------------------------------------------------------*
*&      Form  email_rm1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form email_rm1.
************ONLY SELECTED DIV************
  loop at it_rm2 into wa_rm2.
    wa_tap1-pernr = wa_rm2-rmpernr.
    collect wa_tap1 into it_tap1.
    clear wa_tap1.
  endloop.
  sort it_tap1 by pernr.
  delete adjacent duplicates from it_tap1 comparing pernr.
  delete it_tap1 where pernr eq '00000000'.
  loop at it_tap1 into wa_tap1.
    select single * from pa0105 where pernr eq wa_tap1-pernr and subty eq '0010'.
    if sy-subrc eq 0.
      wa_tap2-pernr = wa_tap1-pernr.
      wa_tap2-usrid_long = pa0105-usrid_long.
      collect wa_tap2 into it_tap2.
      clear wa_tap2.
    endif.
  endloop.

  sort it_rm2 by reg rm.
  sort it_pso2 by reg zm rm bzirk.
  concatenate lyear+2(2) '-' cyear+2(2) into ly.
  concatenate cyear+2(2) '-' ccyear+2(2) into cy.
  select single * from t247 where spras eq 'EN' and mnr eq date1+4(2).
  if sy-subrc eq 0.
    nmonth1 = t247-ktx.
  endif.
  select single * from t247 where spras eq 'EN' and mnr eq date4+4(2).
  if sy-subrc eq 0.
    nmonth2 = t247-ktx.
  endif.
  select single * from t247 where spras eq 'EN' and mnr eq date5+4(2).
  if sy-subrc eq 0.
    nmonth3 = t247-ktx.
  endif.
  options-tdgetotf = 'X'.

  loop at it_tap1 into wa_tap1 where pernr ne '00000000'.
    on change of wa_tap1-pernr.
      a = 0.
    endon.
    loop at it_rm2 into wa_rm2 where rmpernr = wa_tap1-pernr .
      loop at it_pso2 into wa_pso2 where rm = wa_rm2-rm and div eq ddiv and cgrw ge grw1 and cgrw le grw2 and ccumm ge per1 and ccumm le per2.
        a = 1.
      endloop.
    endloop.

    if a eq 1.

      call function 'OPEN_FORM'
        exporting
          device   = 'PRINTER'
          dialog   = ''
*         form     = 'ZSR24_1'
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
          form        = 'ZSR11_N1_3N'
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

      perform rm_div2.

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

*  write s_budat-low to wa_d1 dd/mm/yyyy.
*  write s_budat-high to wa_d2 dd/mm/yyyy.

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
      concatenate 'SR-11.' 'RM'  into doc_chng-obj_descr separated by space.
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

      concatenate 'SR-11' 'RM' sy-datum into objpack-obj_descr separated by space.
      objpack-doc_size = righe_attachment * 255.
      append objpack.
      clear objpack.

*  LOOP at it_tac4 INTO wa_tac4.
*    WRITE : / wa_tac4-bzirk,wa_tac4-usrid_long.
      loop at it_tap2 into wa_tap2 where pernr = wa_tap1-pernr.
        reclist-receiver =   wa_tap2-usrid_long.
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


*      if sy-subrc eq 0.
*
*        write : / 'EMAIL SENT ON ',uemail.
*      endif.



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
      loop at it_tap2 into wa_tap2 where pernr eq wa_tap1-pernr.
        format color 5.
        write : / 'EMAIL HAS BEEN SENT ON',wa_tap2-usrid_long.
      endloop.
    else.
      loop at it_tap2 into wa_tap2 where pernr eq wa_tap1-pernr.
        format color 6.
        write : / 'NO DATA FOUND FOR : ',wa_tap2-usrid_long.
      endloop.
*      MESSAGE 'NO DATA FOUND' TYPE 'I'.
    endif.
  endloop.

*  loop at it_tap2 into wa_tap2.
*    write : / 'EMAIL HAS BEEN SENT ON',wa_tap2-usrid_long.
*  endloop.

endform.                    "LAYOUT



*&---------------------------------------------------------------------*
*&      Form  TOP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form top.

  data: comment    type slis_t_listheader,
        wa_comment like line of comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'SR-11'.
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
*&      Form  LSALE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form lsale.

  loop at it_tab6 into wa_tab6.
    clear : lls.
*    WRITE : / 'LAST TO LAST YEAR', wa_TAB6-bzirk.
    wa_lyc1-bzirk = wa_tab6-bzirk.
    wa_lyc1-rm = wa_tab6-rm.
    wa_lyc1-zm = wa_tab6-zm.
    select single * from zrcumpso where zmonth eq '04' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_lyc1-m1 = zrcumpso-netval.
    endif.
    select single * from zrcumpso where zmonth eq '05' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
*      WRITE : ZRCUMPSO-NETVAL.
      wa_lyc1-m2 = zrcumpso-netval.
    endif.
    select single * from zrcumpso where zmonth eq '06' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_lyc1-m3 = zrcumpso-netval.
    endif.
    select single * from zrcumpso where zmonth eq '07' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_lyc1-m4 = zrcumpso-netval.
    endif.
    select single * from zrcumpso where zmonth eq '08' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_lyc1-m5 = zrcumpso-netval.
    endif.
    select single * from zrcumpso where zmonth eq '09' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_lyc1-m6 = zrcumpso-netval.
    endif.
    select single * from zrcumpso where zmonth eq '10' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_lyc1-m7 = zrcumpso-netval.
    endif.
    select single * from zrcumpso where zmonth eq '11' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_lyc1-m8 = zrcumpso-netval.
    endif.
    select single * from zrcumpso where zmonth eq '12' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_lyc1-m9 = zrcumpso-netval.
    endif.
    select single * from zrcumpso where zmonth eq '01' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_lyc1-m10 = zrcumpso-netval.
    endif.
    select single * from zrcumpso where zmonth eq '02' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_lyc1-m11 = zrcumpso-netval.
    endif.
    select single * from zrcumpso where zmonth eq '03' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_lyc1-m12 = zrcumpso-netval.
    endif.

    collect wa_lyc1 into it_lyc1.
    clear wa_lyc1.

*****************LAST TO LAST YEAR GROWTH***********************

    wa_llyc1-bzirk = wa_tab6-bzirk.
    wa_llyc1-rm = wa_tab6-rm.
    wa_llyc1-zm = wa_tab6-zm.
    select single * from zrcumpso where zmonth eq '04' and zyear eq llyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_llyc1-m1 = zrcumpso-netval.
    endif.
    select single * from zrcumpso where zmonth eq '05' and zyear eq llyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
*      WRITE : ZRCUMPSO-NETVAL.
      wa_llyc1-m2 = zrcumpso-netval.
    endif.
    select single * from zrcumpso where zmonth eq '06' and zyear eq llyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_llyc1-m3 = zrcumpso-netval.
    endif.
    select single * from zrcumpso where zmonth eq '07' and zyear eq llyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_llyc1-m4 = zrcumpso-netval.
    endif.
    select single * from zrcumpso where zmonth eq '08' and zyear eq llyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_llyc1-m5 = zrcumpso-netval.
    endif.
    select single * from zrcumpso where zmonth eq '09' and zyear eq llyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_llyc1-m6 = zrcumpso-netval.
    endif.
    select single * from zrcumpso where zmonth eq '10' and zyear eq llyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_llyc1-m7 = zrcumpso-netval.
    endif.
    select single * from zrcumpso where zmonth eq '11' and zyear eq llyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_llyc1-m8 = zrcumpso-netval.
    endif.
    select single * from zrcumpso where zmonth eq '12' and zyear eq llyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_llyc1-m9 = zrcumpso-netval.
    endif.
    select single * from zrcumpso where zmonth eq '01' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_llyc1-m10 = zrcumpso-netval.
    endif.
    select single * from zrcumpso where zmonth eq '02' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_llyc1-m11 = zrcumpso-netval.
    endif.
    select single * from zrcumpso where zmonth eq '03' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_llyc1-m12 = zrcumpso-netval.
    endif.

    collect wa_llyc1 into it_llyc1.
    clear wa_llyc1.
****************************************************************
  endloop.

  loop at it_lyc1 into wa_lyc1.
    clear : sale,qt1,qt2,qt3,qt4.
    wa_lrm11-rm = wa_lyc1-rm.
    wa_lrm11-m1 = wa_lyc1-m1.
    wa_lrm11-m2 = wa_lyc1-m2.
    wa_lrm11-m3 = wa_lyc1-m3.
    wa_lrm11-m4 = wa_lyc1-m4.
    wa_lrm11-m5 = wa_lyc1-m5.
    wa_lrm11-m6 = wa_lyc1-m6.
    wa_lrm11-m7 = wa_lyc1-m7.
    wa_lrm11-m8 = wa_lyc1-m8.
    wa_lrm11-m9 = wa_lyc1-m9.
    wa_lrm11-m10 = wa_lyc1-m10.
    wa_lrm11-m11 = wa_lyc1-m11.
    wa_lrm11-m12 = wa_lyc1-m12.
    collect wa_lrm11 into it_lrm11.
    clear wa_lrm11.
  endloop.

  loop at it_lyc1 into wa_lyc1.
    clear : sale,qt1,qt2,qt3,qt4.
    wa_lzm11-zm = wa_lyc1-zm.
    wa_lzm11-m1 = wa_lyc1-m1.
    wa_lzm11-m2 = wa_lyc1-m2.
    wa_lzm11-m3 = wa_lyc1-m3.
    wa_lzm11-m4 = wa_lyc1-m4.
    wa_lzm11-m5 = wa_lyc1-m5.
    wa_lzm11-m6 = wa_lyc1-m6.
    wa_lzm11-m7 = wa_lyc1-m7.
    wa_lzm11-m8 = wa_lyc1-m8.
    wa_lzm11-m9 = wa_lyc1-m9.
    wa_lzm11-m10 = wa_lyc1-m10.
    wa_lzm11-m11 = wa_lyc1-m11.
    wa_lzm11-m12 = wa_lyc1-m12.
    collect wa_lzm11 into it_lzm11.
    clear wa_lzm11.
  endloop.

  loop at it_lyc1 into wa_lyc1.
    clear : sale,qt1,qt2,qt3,qt4.
    wa_lyc2-bzirk = wa_lyc1-bzirk.
    sale = wa_lyc1-m1 + wa_lyc1-m2 + wa_lyc1-m3 + wa_lyc1-m4 + wa_lyc1-m5 + wa_lyc1-m6 + wa_lyc1-m7 + wa_lyc1-m8 + wa_lyc1-m9 + wa_lyc1-m10
               + wa_lyc1-m11 + wa_lyc1-m12.
    wa_lyc2-lys = sale.
    collect wa_lyc2 into it_lyc2.
    clear wa_lyc2.
******************************************QUARTER*******
    wa_lqtc1-bzirk = wa_lyc1-bzirk.
    qt1 = wa_lyc1-m1 + wa_lyc1-m2 + wa_lyc1-m3.
    qt2 = wa_lyc1-m4 + wa_lyc1-m5 + wa_lyc1-m6.
    qt3 = wa_lyc1-m7 + wa_lyc1-m8 + wa_lyc1-m9.
    qt4 = wa_lyc1-m10 + wa_lyc1-m11 + wa_lyc1-m12.
    wa_lqtc1-qt1 = qt1.
    wa_lqtc1-qt2 = qt2.
    wa_lqtc1-qt3 = qt3.
    wa_lqtc1-qt4 = qt4.
    collect wa_lqtc1 into it_lqtc1.
    clear wa_lqtc1.
  endloop.
*  LOOP AT IT_LY2 INTO wa_lyc2.
*    WRITE : / 'LAST YEAR SALE',wa_lyc2-BZIRK,wa_lyc2-LYS.
*  ENDLOOP.

*  LOOP AT IT_LQT1 INTO WA_LQT1.  "QUARTER SALE
*    WRITE : / 'LAST QRT SALE',WA_LQT1-BZIRK,WA_LQT1-QT1,WA_LQT1-QT2,WA_LQT1-QT3,WA_LQT1-QT4.
*  ENDLOOP.

endform.                    "LSALE

*&---------------------------------------------------------------------*
*&      Form  lsale_cumpso
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form lsale_cumpso.

  loop at it_tab6 into wa_tab6.
    clear : lls.
*    WRITE : / 'LAST TO LAST YEAR', wa_TAB6-bzirk.
    wa_ly1-bzirk = wa_tab6-bzirk.
    select single * from zcumpso where zmonth eq '04' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_ly1-m1 = zcumpso-netval.
    endif.
    select single * from zcumpso where zmonth eq '05' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
*      WRITE : ZCUMPSO-NETVAL.
      wa_ly1-m2 = zcumpso-netval.
    endif.
    select single * from zcumpso where zmonth eq '06' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_ly1-m3 = zcumpso-netval.
    endif.
    select single * from zcumpso where zmonth eq '07' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_ly1-m4 = zcumpso-netval.
    endif.
    select single * from zcumpso where zmonth eq '08' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_ly1-m5 = zcumpso-netval.
    endif.
    select single * from zcumpso where zmonth eq '09' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_ly1-m6 = zcumpso-netval.
    endif.
    select single * from zcumpso where zmonth eq '10' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_ly1-m7 = zcumpso-netval.
    endif.
    select single * from zcumpso where zmonth eq '11' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_ly1-m8 = zcumpso-netval.
    endif.
    select single * from zcumpso where zmonth eq '12' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_ly1-m9 = zcumpso-netval.
    endif.
    select single * from zcumpso where zmonth eq '01' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_ly1-m10 = zcumpso-netval.
    endif.
    select single * from zcumpso where zmonth eq '02' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_ly1-m11 = zcumpso-netval.
    endif.
    select single * from zcumpso where zmonth eq '03' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_ly1-m12 = zcumpso-netval.
    endif.

    collect wa_ly1 into it_ly1.
    clear wa_ly1.
  endloop.

  loop at it_ly1 into wa_ly1.
    clear : sale,qt1,qt2,qt3,qt4.
    wa_ly2-bzirk = wa_ly1-bzirk.
    sale = wa_ly1-m1 + wa_ly1-m2 + wa_ly1-m3 + wa_ly1-m4 + wa_ly1-m5 + wa_ly1-m6 + wa_ly1-m7 + wa_ly1-m8 + wa_ly1-m9 + wa_ly1-m10
               + wa_ly1-m11 + wa_ly1-m12.
    wa_ly2-lys = sale.
    collect wa_ly2 into it_ly2.
    clear wa_ly2.
******************************************QUARTER*******
    wa_lqt1-bzirk = wa_ly1-bzirk.
    qt1 = wa_ly1-m1 + wa_ly1-m2 + wa_ly1-m3.
    qt2 = wa_ly1-m4 + wa_ly1-m5 + wa_ly1-m6.
    qt3 = wa_ly1-m7 + wa_ly1-m8 + wa_ly1-m9.
    qt4 = wa_ly1-m10 + wa_ly1-m11 + wa_ly1-m12.
    wa_lqt1-qt1 = qt1.
    wa_lqt1-qt2 = qt2.
    wa_lqt1-qt3 = qt3.
    wa_lqt1-qt4 = qt4.
    collect wa_lqt1 into it_lqt1.
    clear wa_lqt1.
  endloop.
*  LOOP AT IT_LY2 INTO WA_LY2.
*    WRITE : / 'LAST YEAR SALE',WA_LY2-BZIRK,WA_LY2-LYS.
*  ENDLOOP.

*  LOOP AT IT_LQT1 INTO WA_LQT1.  "QUARTER SALE
*    WRITE : / 'LAST QRT SALE',WA_LQT1-BZIRK,WA_LQT1-QT1,WA_LQT1-QT2,WA_LQT1-QT3,WA_LQT1-QT4.
*  ENDLOOP.

endform.                    "LSALE

*&---------------------------------------------------------------------*
*&      Form  PRVSALE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form llsale.
  loop at it_tab6 into wa_tab6.
    clear : lls.
*    WRITE : / 'LAST TO LAST YEAR', wa_TAB6-bzirk,wa_tab6-pernr,wa_tab6-join_date,lchk_dt1.
    wa_lly1-bzirk = wa_tab6-bzirk.
    wa_lly1-rm = wa_tab6-rm.
*    if wa_tab6-join_date le lchk_dt1.
    select single * from zcumpso where zmonth eq '04' and zyear eq llyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_lly1-m1 = zcumpso-netval.
    endif.
*    endif.
*    if wa_tab6-join_date le lchk_dt2.
    select single * from zcumpso where zmonth eq '05' and zyear eq llyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
*      WRITE : ZCUMPSO-NETVAL.
      wa_lly1-m2 = zcumpso-netval.
    endif.
*    endif.
*    if wa_tab6-join_date le lchk_dt3.
    select single * from zcumpso where zmonth eq '06' and zyear eq llyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_lly1-m3 = zcumpso-netval.
    endif.
*    endif.
*    if wa_tab6-join_date le lchk_dt4.
    select single * from zcumpso where zmonth eq '07' and zyear eq llyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_lly1-m4 = zcumpso-netval.
    endif.
*    endif.
*    if wa_tab6-join_date le lchk_dt5.
    select single * from zcumpso where zmonth eq '08' and zyear eq llyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_lly1-m5 = zcumpso-netval.
    endif.
*    endif.
*    if wa_tab6-join_date le lchk_dt6.
    select single * from zcumpso where zmonth eq '09' and zyear eq llyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_lly1-m6 = zcumpso-netval.
    endif.
*    endif.
*    if wa_tab6-join_date le lchk_dt7.
    select single * from zcumpso where zmonth eq '10' and zyear eq llyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_lly1-m7 = zcumpso-netval.
    endif.
*    endif.
*    if wa_tab6-join_date le lchk_dt8.
    select single * from zcumpso where zmonth eq '11' and zyear eq llyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_lly1-m8 = zcumpso-netval.
    endif.
*    endif.
*    if wa_tab6-join_date le lchk_dt9.
    select single * from zcumpso where zmonth eq '12' and zyear eq llyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_lly1-m9 = zcumpso-netval.
    endif.
*    endif.
*    if wa_tab6-join_date le lchk_dt10.
    select single * from zcumpso where zmonth eq '01' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_lly1-m10 = zcumpso-netval.
    endif.
*    endif.
*    if wa_tab6-join_date le lchk_dt11.
    select single * from zcumpso where zmonth eq '02' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_lly1-m11 = zcumpso-netval.
    endif.
*    endif.
*    if wa_tab6-join_date le lchk_dt12.
    select single * from zcumpso where zmonth eq '03' and zyear eq lyear and bzirk eq wa_tab6-bzirk .
    if sy-subrc eq 0.
      wa_lly1-m12 = zcumpso-netval.
    endif.
*    endif.


*    WA_LLY1-LLS = LLS.
    collect wa_lly1 into it_lly1.
    clear wa_lly1.
  endloop.

  loop at it_lly1 into wa_lly1.
    clear : sale,qt1,qt2,qt3,qt4.
    wa_llrm11-rm = wa_lly1-rm.
    wa_llrm11-m1 = wa_lly1-m1.
    wa_llrm11-m2 = wa_lly1-m2.
    wa_llrm11-m3 = wa_lly1-m3.
    wa_llrm11-m4 = wa_lly1-m4.
    wa_llrm11-m5 = wa_lly1-m5.
    wa_llrm11-m6 = wa_lly1-m6.
    wa_llrm11-m7 = wa_lly1-m7.
    wa_llrm11-m8 = wa_lly1-m8.
    wa_llrm11-m9 = wa_lly1-m9.
    wa_llrm11-m10 = wa_lly1-m10.
    wa_llrm11-m11 = wa_lly1-m11.
    wa_llrm11-m12 = wa_lly1-m12.
    collect wa_llrm11 into it_llrm11.
    clear wa_llrm11.
  endloop.

  loop at it_lly1 into wa_lly1.
    clear : sale,qt1,qt2,qt3,qt4.
    wa_llrm11-zm = wa_lly1-zm.
    wa_llrm11-m1 = wa_lly1-m1.
    wa_llrm11-m2 = wa_lly1-m2.
    wa_llrm11-m3 = wa_lly1-m3.
    wa_llrm11-m4 = wa_lly1-m4.
    wa_llrm11-m5 = wa_lly1-m5.
    wa_llrm11-m6 = wa_lly1-m6.
    wa_llrm11-m7 = wa_lly1-m7.
    wa_llrm11-m8 = wa_lly1-m8.
    wa_llrm11-m9 = wa_lly1-m9.
    wa_llrm11-m10 = wa_lly1-m10.
    wa_llrm11-m11 = wa_lly1-m11.
    wa_llrm11-m12 = wa_lly1-m12.
    collect wa_llrm11 into it_llrm11.
    clear wa_llrm11.
  endloop.



  loop at it_lly1 into wa_lly1.
    clear : sale.
    sale = wa_lly1-m1 + wa_lly1-m2 + wa_lly1-m3 + wa_lly1-m4 + wa_lly1-m5 + wa_lly1-m6 + wa_lly1-m7 + wa_lly1-m8 + wa_lly1-m9 + wa_lly1-m10
               + wa_lly1-m11 + wa_lly1-m12.
    wa_lly2-bzirk = wa_lly1-bzirk.
    wa_lly2-lls = sale.
    collect wa_lly2 into it_lly2.
    clear wa_lly2.
  endloop.
*  LOOP AT IT_LLY2 INTO WA_LLY2.
*    WRITE : / 'LAST TO LAST YEAR SALE',WA_LLY2-BZIRK,WA_LLY2-LLS.
*  ENDLOOP.

endform.                    "PRVSALE

*&---------------------------------------------------------------------*
*&      Form  LTARGET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form ltarget.
********last year target**********
  loop at it_tab6 into wa_tab6.
    clear : lyt,qt1,qt2,qt3,qt4,t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12.
*    WRITE : / 'LAST TO LAST YEAR', wa_TAB6-bzirk.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq lyear .
    if sy-subrc eq 0.
*      if lchk_dt1 ge wa_tab6-join_date.
      t1 = ysd_dist_targt-month01.
*      endif.
*      if lchk_dt2 ge wa_tab6-join_date.
      t2 = ysd_dist_targt-month02.
*      endif.
*      if lchk_dt3 ge wa_tab6-join_date.
      t3 = ysd_dist_targt-month03.
*      endif.
*      if lchk_dt4 ge wa_tab6-join_date.
      t4 = ysd_dist_targt-month04.
*      endif.
*      if lchk_dt5 ge wa_tab6-join_date.
      t5 = ysd_dist_targt-month05.
*      endif.
*      if lchk_dt6 ge wa_tab6-join_date.
      t6 = ysd_dist_targt-month06.
*      endif.
*      if lchk_dt7 ge wa_tab6-join_date.
      t7 = ysd_dist_targt-month07.
*      endif.
*      if lchk_dt8 ge wa_tab6-join_date.
      t8 = ysd_dist_targt-month08.
*      endif.
*      if lchk_dt9 ge wa_tab6-join_date.
      t9 = ysd_dist_targt-month09.
*      endif.
*      if lchk_dt10 ge wa_tab6-join_date.
      t10 = ysd_dist_targt-month10.
*      endif.
*      if lchk_dt11 ge wa_tab6-join_date.
      t11 = ysd_dist_targt-month11.
*      endif.
*      if lchk_dt12 ge wa_tab6-join_date.
      t12 = ysd_dist_targt-month12.
*      endif.

      lyt = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12.

*      LYT = YSD_DIST_TARGT-MONTH01 + YSD_DIST_TARGT-MONTH02 + YSD_DIST_TARGT-MONTH03 + YSD_DIST_TARGT-MONTH04 + YSD_DIST_TARGT-MONTH05 +
*      YSD_DIST_TARGT-MONTH06 + YSD_DIST_TARGT-MONTH07 + YSD_DIST_TARGT-MONTH08 + YSD_DIST_TARGT-MONTH09 + YSD_DIST_TARGT-MONTH10 +
*      YSD_DIST_TARGT-MONTH11 + YSD_DIST_TARGT-MONTH12.
      wa_lyt1-lyt = lyt.
      wa_lyt1-bzirk = wa_tab6-bzirk.
      collect wa_lyt1 into it_lyt1.
      clear wa_lyt1.

      qt1 = t1 + t2 + t3.
      qt2 = t4 + t5 + t6.
      qt3 = t7 + t8 + t9.
      qt4 = t10 + t11 + t12.
*      QT1 = YSD_DIST_TARGT-MONTH01 + YSD_DIST_TARGT-MONTH02 + YSD_DIST_TARGT-MONTH03.
*      QT2 = YSD_DIST_TARGT-MONTH04 + YSD_DIST_TARGT-MONTH05 + YSD_DIST_TARGT-MONTH06.
*      QT3 = YSD_DIST_TARGT-MONTH07 + YSD_DIST_TARGT-MONTH08 + YSD_DIST_TARGT-MONTH09.
*      QT4 = YSD_DIST_TARGT-MONTH10 + YSD_DIST_TARGT-MONTH11 + YSD_DIST_TARGT-MONTH12.
      wa_lytq1-bzirk = wa_tab6-bzirk.
      wa_lytq1-qrt1 = qt1.
      wa_lytq1-qrt2 = qt2.
      wa_lytq1-qrt3 = qt3.
      wa_lytq1-qrt4 = qt4.
      collect wa_lytq1 into it_lytq1.
      clear wa_lytq1.

      wa_lrmt1-rm = wa_tab6-rm.
      wa_lrmt1-t1 = t1.
      wa_lrmt1-t2 = t2.
      wa_lrmt1-t3 = t3.
      wa_lrmt1-t4 = t4.
      wa_lrmt1-t5 = t5.
      wa_lrmt1-t6 = t6.
      wa_lrmt1-t7 = t7.
      wa_lrmt1-t8 = t8.
      wa_lrmt1-t9 = t9.
      wa_lrmt1-t10 = t10.
      wa_lrmt1-t11 = t11.
      wa_lrmt1-t12 = t12.
      collect wa_lrmt1 into it_lrmt1.
      clear wa_lrmt1.

      wa_lzmt1-zm = wa_tab6-zm.
      wa_lzmt1-t1 = t1.
      wa_lzmt1-t2 = t2.
      wa_lzmt1-t3 = t3.
      wa_lzmt1-t4 = t4.
      wa_lzmt1-t5 = t5.
      wa_lzmt1-t6 = t6.
      wa_lzmt1-t7 = t7.
      wa_lzmt1-t8 = t8.
      wa_lzmt1-t9 = t9.
      wa_lzmt1-t10 = t10.
      wa_lzmt1-t11 = t11.
      wa_lzmt1-t12 = t12.
      collect wa_lzmt1 into it_lzmt1.
      clear wa_lzmt1.

    endif.
  endloop.

*  LOOP AT IT_LYT1 INTO WA_LYT1.  "QUARTER SALE
*    WRITE : / 'LAST YEAR TARGET',WA_LYT1-BZIRK,WA_LYT1-LYT.
*  ENDLOOP.


endform.                    "LTARGET

*&---------------------------------------------------------------------*
*&      Form  INCT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form inct.
*  WRITE : / 'DATE FOR INCENTIVE',date1,date2.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '-11'
      olddate = date1
    importing
      newdate = lldate.
  ldate = date2.
*  WRITE : / 'lldate',lldate,ldate.
****NO INCENTATIV*
*  if inc eq 'X'.
*    if it_tab6 is not initial.
*      select * from pa0015 into table it_pa0015 for all entries in it_tab6 where pernr eq it_tab6-ZMpernr and subty eq '1INC'  and begda ge inc_dt-low
*         and begda le inc_dt-high.
*    endif.
*  else.
*    if it_tab6 is not initial.
*      select * from pa0015 into table it_pa0015 for all entries in it_tab6 where pernr eq it_tab6-ZMpernr and subty eq '1INC'  and begda ge lldate and
*        begda le ldate.
*    endif.
*  endif.


  loop at it_pa0015 into wa_pa0015.
    wa_inct1-pernr = wa_pa0015-pernr.
    wa_inct1-betrg = wa_pa0015-betrg.
    collect wa_inct1 into it_inct1.
    clear wa_inct1.
  endloop.

*  LOOP AT IT_INCT1 INTO WA_INCT1.
*    WRITE : / 'INCENTIVE',WA_INCT1-pernr,wa_inct1-betrg.
*    ENDLOOP.


endform.                    "INCT


*&---------------------------------------------------------------------*
*&      Form  CTARGET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form ctarget.



  chk_dt1+6(2) = '01'.
  chk_dt1+4(2) = '04'.
  chk_dt1+0(4) = cyear.

*  WRITE : / 'CURRENT YEAR TARGET',CHK_DT1.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '1'
      olddate = chk_dt1
    importing
      newdate = chk_dt2.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '2'
      olddate = chk_dt1
    importing
      newdate = chk_dt3.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '3'
      olddate = chk_dt1
    importing
      newdate = chk_dt4.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '4'
      olddate = chk_dt1
    importing
      newdate = chk_dt5.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '5'
      olddate = chk_dt1
    importing
      newdate = chk_dt6.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '6'
      olddate = chk_dt1
    importing
      newdate = chk_dt7.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '7'
      olddate = chk_dt1
    importing
      newdate = chk_dt8.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '8'
      olddate = chk_dt1
    importing
      newdate = chk_dt9.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '9'
      olddate = chk_dt1
    importing
      newdate = chk_dt10.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '10'
      olddate = chk_dt1
    importing
      newdate = chk_dt11.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '11'
      olddate = chk_dt1
    importing
      newdate = chk_dt12.

  loop at it_tab6 into wa_tab6.
    clear : cyt,t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12.
*    WRITE : / 'LAST TO LAST YEAR', wa_TAB6-bzirk.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
*      if chk_dt1 ge wa_tab6-join_date.
      t1 = ysd_dist_targt-month01.
*      endif.
*      if chk_dt2 ge wa_tab6-join_date.
      t2 = ysd_dist_targt-month02.
*      endif.
*      if chk_dt3 ge wa_tab6-join_date.
      t3 = ysd_dist_targt-month03.
*      endif.
*      if chk_dt4 ge wa_tab6-join_date.
      t4 = ysd_dist_targt-month04.
*      endif.
*      if chk_dt5 ge wa_tab6-join_date.
      t5 = ysd_dist_targt-month05.
*      endif.
*      if chk_dt6 ge wa_tab6-join_date.
      t6 = ysd_dist_targt-month06.
*      endif.
*      if chk_dt7 ge wa_tab6-join_date.
      t7 = ysd_dist_targt-month07.
*      endif.
*      if chk_dt8 ge wa_tab6-join_date.
      t8 = ysd_dist_targt-month08.
*      endif.
*      if chk_dt9 ge wa_tab6-join_date.
      t9 = ysd_dist_targt-month09.
*      endif.
*      if chk_dt10 ge wa_tab6-join_date.
      t10 = ysd_dist_targt-month10.
*      endif.
*      if chk_dt11 ge wa_tab6-join_date.
      t11 = ysd_dist_targt-month11.
*      endif.
*      if chk_dt12 ge wa_tab6-join_date.
      t12 = ysd_dist_targt-month12.


      cyt = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12.

*      CYT = YSD_DIST_TARGT-MONTH01 + YSD_DIST_TARGT-MONTH02 + YSD_DIST_TARGT-MONTH03 + YSD_DIST_TARGT-MONTH04 + YSD_DIST_TARGT-MONTH05 +
*      YSD_DIST_TARGT-MONTH06 + YSD_DIST_TARGT-MONTH07 + YSD_DIST_TARGT-MONTH08 + YSD_DIST_TARGT-MONTH09 + YSD_DIST_TARGT-MONTH10 +
*      YSD_DIST_TARGT-MONTH11 + YSD_DIST_TARGT-MONTH12.
      wa_cyt1-cyt = cyt.
      wa_cyt1-bzirk = wa_tab6-bzirk.
      collect wa_cyt1 into it_cyt1.
      clear wa_cyt1.

      wa_cyqt1-bzirk = wa_tab6-bzirk.
*      WA_CYQT1-QRT1 = YSD_DIST_TARGT-MONTH01 + YSD_DIST_TARGT-MONTH02 + YSD_DIST_TARGT-MONTH03.
      wa_cyqt1-qrt1 = t1 + t2 + t3.
      wa_cyqt1-qrt2 = t4 + t5 + t6.
      wa_cyqt1-qrt3 = t7 + t8 + t9.
      wa_cyqt1-qrt4 = t10 + t11 + t12.

      collect wa_cyqt1 into it_cyqt1.
      clear wa_cyqt1.

      wa_rmt1-rm = wa_tab6-rm.
*      WA_CYQT1-QRT1 = YSD_DIST_TARGT-MONTH01 + YSD_DIST_TARGT-MONTH02 + YSD_DIST_TARGT-MONTH03.
      if f1date le date2.
        wa_rmt1-t1 = t1.
      endif.
      if f2date le date2.
        wa_rmt1-t2 = t2.
      endif.
      if f3date le date2.
        wa_rmt1-t3 = t3.
      endif.
      if f4date le date2.
        wa_rmt1-t4 = t4.
      endif.
      if f5date le date2.
        wa_rmt1-t5 = t5.
      endif.
      if f6date le date2.
        wa_rmt1-t6 = t6.
      endif.
      if f7date le date2.
        wa_rmt1-t7 = t7.
      endif.
      if f8date le date2.
        wa_rmt1-t8 = t8.
      endif.
      if f9date le date2.
        wa_rmt1-t9 = t9.
      endif.
      if f10date le date2.
        wa_rmt1-t10 = t10.
      endif.
      if f11date le date2.
        wa_rmt1-t11 = t11.
      endif.
      if f12date le date2.
        wa_rmt1-t12 = t12.
      endif.

      collect wa_rmt1 into it_rmt1.
      clear wa_rmt1.


      wa_zmt1-zm = wa_tab6-zm.
*      WA_CYQT1-QRT1 = YSD_DIST_TARGT-MONTH01 + YSD_DIST_TARGT-MONTH02 + YSD_DIST_TARGT-MONTH03.
      if f1date le date2.
        wa_zmt1-t1 = t1.
      endif.
      if f2date le date2.
        wa_zmt1-t2 = t2.
      endif.
      if f3date le date2.
        wa_zmt1-t3 = t3.
      endif.
      if f4date le date2.
        wa_zmt1-t4 = t4.
      endif.
      if f5date le date2.
        wa_zmt1-t5 = t5.
      endif.
      if f6date le date2.
        wa_zmt1-t6 = t6.
      endif.
      if f7date le date2.
        wa_zmt1-t7 = t7.
      endif.
      if f8date le date2.
        wa_zmt1-t8 = t8.
      endif.
      if f9date le date2.
        wa_zmt1-t9 = t9.
      endif.
      if f10date le date2.
        wa_zmt1-t10 = t10.
      endif.
      if f11date le date2.
        wa_zmt1-t11 = t11.
      endif.
      if f12date le date2.
        wa_zmt1-t12 = t12.
      endif.

      collect wa_zmt1 into it_zmt1.
      clear wa_zmt1.


    endif.
  endloop.

*  LOOP AT IT_CYQT1 INTO WA_CYQT1.  "QUARTER SALE
*    WRITE : / 'CURRENT YEAR QUARTERLY TARGET',WA_CYQT1-BZIRK,WA_CYQT1-QRT1,WA_CYQT1-QRT2,WA_CYQT1-QRT3,WA_CYQT1-QRT4.
*  ENDLOOP.


endform.                    "CTARGET

*&---------------------------------------------------------------------*
*&      Form  csale
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form csale.


*  WRITE : / 'CURRENT YEAR',CYEAR.

  loop at it_tab6 into wa_tab6.
    clear : lls.
*    WRITE : / 'LAST TO LAST YEAR', wa_TAB6-bzirk.
*    WRITE : / 'chk_dt1',date1,date2,chk_dt1,chk_dt2,chk_dt3,chk_dt4,chk_dt5,chk_dt6,chk_dt7,chk_dt8,chk_dt9,chk_dt10,chk_dt11,chk_dt12.
    wa_cy1-bzirk = wa_tab6-bzirk.
    wa_cy1-rm = wa_tab6-rm.
    wa_cy1-zm = wa_tab6-zm.

    if chk_dt1 le date2.
      select single * from zrcumpso where zmonth eq '04' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        wa_cy1-m1 = zrcumpso-netval.
      endif.
    endif.
    if chk_dt2 le date2.
      select single * from zrcumpso where zmonth eq '05' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
*      WRITE : ZCUMPSO-NETVAL.
        wa_cy1-m2 = zrcumpso-netval.
      endif.
    endif.
    if chk_dt3 le date2.
      select single * from zrcumpso where zmonth eq '06' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        wa_cy1-m3 = zrcumpso-netval.
      endif.
    endif.
    if chk_dt4 le date2.
      select single * from zrcumpso where zmonth eq '07' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        wa_cy1-m4 = zrcumpso-netval.
      endif.
    endif.
    if chk_dt5 le date2.
      select single * from zrcumpso where zmonth eq '08' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        wa_cy1-m5 = zrcumpso-netval.
      endif.
    endif.
    if chk_dt6 le date2.
      select single * from zrcumpso where zmonth eq '09' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        wa_cy1-m6 = zrcumpso-netval.
      endif.
    endif.
    if chk_dt7 le date2.
      select single * from zrcumpso where zmonth eq '10' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        wa_cy1-m7 = zrcumpso-netval.
      endif.
    endif.
    if chk_dt8 le date2.
      select single * from zrcumpso where zmonth eq '11' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        wa_cy1-m8 = zrcumpso-netval.
      endif.
    endif.
    if chk_dt9 le date2.
      select single * from zrcumpso where zmonth eq '12' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        wa_cy1-m9 = zrcumpso-netval.
      endif.
    endif.
    if chk_dt10 le date2.
      select single * from zrcumpso where zmonth eq '01' and zyear eq ccyear and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        wa_cy1-m10 = zrcumpso-netval.
      endif.
    endif.
    if chk_dt11 le date2.
      select single * from zrcumpso where zmonth eq '02' and zyear eq ccyear and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        wa_cy1-m11 = zrcumpso-netval.
      endif.
    endif.
    if chk_dt12 le date2.
      select single * from zrcumpso where zmonth eq '03' and zyear eq ccyear and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        wa_cy1-m12 = zrcumpso-netval.
      endif.
    endif.
    collect wa_cy1 into it_cy1.
    clear wa_cy1.
  endloop.

  loop at it_cy1 into wa_cy1.
    clear : sale,qt1,qt2,qt3,qt4.
    wa_rm11-rm = wa_cy1-rm.
    wa_rm11-m1 = wa_cy1-m1.
    wa_rm11-m2 = wa_cy1-m2.
    wa_rm11-m3 = wa_cy1-m3.
    wa_rm11-m4 = wa_cy1-m4.
    wa_rm11-m5 = wa_cy1-m5.
    wa_rm11-m6 = wa_cy1-m6.
    wa_rm11-m7 = wa_cy1-m7.
    wa_rm11-m8 = wa_cy1-m8.
    wa_rm11-m9 = wa_cy1-m9.
    wa_rm11-m10 = wa_cy1-m10.
    wa_rm11-m11 = wa_cy1-m11.
    wa_rm11-m12 = wa_cy1-m12.
    collect wa_rm11 into it_rm11.
    clear wa_rm11.
  endloop.

  loop at it_cy1 into wa_cy1.
    clear : sale,qt1,qt2,qt3,qt4.
    wa_zm11-zm = wa_cy1-zm.
    wa_zm11-m1 = wa_cy1-m1.
    wa_zm11-m2 = wa_cy1-m2.
    wa_zm11-m3 = wa_cy1-m3.
    wa_zm11-m4 = wa_cy1-m4.
    wa_zm11-m5 = wa_cy1-m5.
    wa_zm11-m6 = wa_cy1-m6.
    wa_zm11-m7 = wa_cy1-m7.
    wa_zm11-m8 = wa_cy1-m8.
    wa_zm11-m9 = wa_cy1-m9.
    wa_zm11-m10 = wa_cy1-m10.
    wa_zm11-m11 = wa_cy1-m11.
    wa_zm11-m12 = wa_cy1-m12.
    collect wa_zm11 into it_zm11.
    clear wa_zm11.
  endloop.

  loop at it_cy1 into wa_cy1.
    clear : sale,qt1,qt2,qt3,qt4.
    wa_cy2-bzirk = wa_cy1-bzirk.
    sale = wa_cy1-m1 + wa_cy1-m2 + wa_cy1-m3 + wa_cy1-m4 + wa_cy1-m5 + wa_cy1-m6 + wa_cy1-m7 + wa_cy1-m8 + wa_cy1-m9 + wa_cy1-m10 + wa_cy1-m11 +
            wa_cy1-m12.
    wa_cy2-cys = sale.
    collect wa_cy2 into it_cy2.
    clear wa_cy2.
******************************************QUARTER*******
    wa_cqt1-bzirk = wa_cy1-bzirk.
    qt1 = wa_cy1-m1 + wa_cy1-m2 + wa_cy1-m3.
    qt2 = wa_cy1-m4 + wa_cy1-m5 + wa_cy1-m6.
    qt3 = wa_cy1-m7 + wa_cy1-m8 + wa_cy1-m9.
    qt4 = wa_cy1-m10 + wa_cy1-m11 + wa_cy1-m12.
    wa_cqt1-qt1 = qt1.
    wa_cqt1-qt2 = qt2.
    wa_cqt1-qt3 = qt3.
    wa_cqt1-qt4 = qt4.
    collect wa_cqt1 into it_cqt1.
    clear wa_cqt1.
  endloop.
*  LOOP AT IT_CY2 INTO WA_CY2.
*    WRITE : / 'CURRENT YEAR SALE',WA_CY2-BZIRK,WA_CY2-CYS.
*  ENDLOOP.

  loop at it_cqt1 into wa_cqt1.  "QUARTER SALE
    clear : qt1,qt2,qt3,qt4.
*    WRITE : / 'CURRENT QRT SALE',WA_CQT1-BZIRK,WA_CQT1-QT1,WA_CQT1-QT2,WA_CQT1-QT3,WA_CQT1-QT4.
    read table it_cyqt1 into wa_cyqt1 with key bzirk = wa_cqt1-bzirk.
    if sy-subrc eq 0.
      if wa_cyqt1-qrt1 ne 0.
        qt1 = ( wa_cqt1-qt1 / wa_cyqt1-qrt1 ) * 100.
      endif.
      if wa_cyqt1-qrt2 ne 0.
        qt2 = ( wa_cqt1-qt2 / wa_cyqt1-qrt2 ) * 100.
      endif.
      if wa_cyqt1-qrt3 ne 0.
        qt3 = ( wa_cqt1-qt3 / wa_cyqt1-qrt3 ) * 100.
      endif.
      if wa_cyqt1-qrt4 ne 0.
        qt4 = ( wa_cqt1-qt4 / wa_cyqt1-qrt4 ) * 100.
      endif.
      wa_cys1-bzirk = wa_cqt1-bzirk.
      wa_cys1-qt1 = qt1.
      wa_cys1-qt2 = qt2.
      wa_cys1-qt3 = qt3.
      wa_cys1-qt4 = qt4.
      collect wa_cys1 into it_cys1.
      clear wa_cys1.
    endif.
  endloop.

*  LOOP AT IT_CYS1 INTO WA_CYS1.  "QUARTER SALE
*    WRITE : / 'CURRENT YEAR QUARTERLY SALE %',WA_CYS1-BZIRK,WA_CYS1-QT1,WA_CYS1-QT2,WA_CYS1-QT3,WA_CYS1-QT4.
*  ENDLOOP.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '-1'
      olddate = date1
    importing
      newdate = p1date.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '-2'
      olddate = date1
    importing
      newdate = p2date.

*  WRITE : / 'DATE1',DATE1,P1DATE,P2DATE.
  p1month = p1date+4(2).
  p1year = p1date+0(4).
  p2month = p2date+4(2).
  p2year = p2date+0(4).

*  WRITE : / 'LAST MONTH',P1MONTH,P1YEAR,P2MONTH,P2YEAR.

  loop at it_tab6 into wa_tab6.
    clear : csale,ctarget,cm,lsale,ltarget,lm,llsale,lltarget,llm.
    select single * from zcumpso where zmonth eq month and zyear eq year and bzirk eq wa_tab6-bzirk and pso eq wa_tab6-pernr.
    if sy-subrc eq 0.
      csale = zcumpso-netval.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tab6-bzirk and trgyear eq cyear.
    if month eq '04'.
      ctarget = ysd_dist_targt-month01.
    elseif month eq '05'.
      ctarget = ysd_dist_targt-month02.
    elseif month eq '06'.
      ctarget = ysd_dist_targt-month03.
    elseif month eq '07'.
      ctarget = ysd_dist_targt-month04.
    elseif month eq '08'.
      ctarget = ysd_dist_targt-month05.
    elseif month eq '09'.
      ctarget = ysd_dist_targt-month06.
    elseif month eq '10'.
      ctarget = ysd_dist_targt-month07.
    elseif month eq '11'.
      ctarget = ysd_dist_targt-month08.
    elseif month eq '12'.
      ctarget = ysd_dist_targt-month09.
    elseif month eq '01'.
      ctarget = ysd_dist_targt-month10.
    elseif month eq '02'.
      ctarget = ysd_dist_targt-month11.
    elseif month eq '03'.
      ctarget = ysd_dist_targt-month12.
    endif.

*****************LAST MONTH*************************

    select single * from zcumpso where zmonth eq p1month and zyear eq p1year and bzirk eq wa_tab6-bzirk and pso eq wa_tab6-pernr.
    if sy-subrc eq 0.
      lsale = zcumpso-netval.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tab6-bzirk and trgyear eq p1year.
    if p1month eq '04'.
      ltarget = ysd_dist_targt-month01.
    elseif p1month eq '05'.
      ltarget = ysd_dist_targt-month02.
    elseif p1month eq '06'.
      ltarget = ysd_dist_targt-month03.
    elseif p1month eq '07'.
      ltarget = ysd_dist_targt-month04.
    elseif p1month eq '08'.
      ltarget = ysd_dist_targt-month05.
    elseif p1month eq '09'.
      ltarget = ysd_dist_targt-month06.
    elseif p1month eq '10'.
      ltarget = ysd_dist_targt-month07.
    elseif p1month eq '11'.
      ltarget = ysd_dist_targt-month08.
    elseif p1month eq '12'.
      ltarget = ysd_dist_targt-month09.
    elseif p1month eq '01'.
      ltarget = ysd_dist_targt-month10.
    elseif p1month eq '02'.
      ltarget = ysd_dist_targt-month11.
    elseif p1month eq '03'.
      ltarget = ysd_dist_targt-month12.
    endif.

*********************LAST TO LAST MONTH ********************************
    select single * from zcumpso where zmonth eq p2month and zyear eq p2year and bzirk eq wa_tab6-bzirk and pso eq wa_tab6-pernr.
    if sy-subrc eq 0.
      llsale = zcumpso-netval.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tab6-bzirk and trgyear eq p2year .
    if p2month eq '04'.
      lltarget = ysd_dist_targt-month01.
    elseif p2month eq '05'.
      lltarget = ysd_dist_targt-month02.
    elseif p2month eq '06'.
      lltarget = ysd_dist_targt-month03.
    elseif p2month eq '07'.
      lltarget = ysd_dist_targt-month04.
    elseif p2month eq '08'.
      lltarget = ysd_dist_targt-month05.
    elseif p2month eq '09'.
      lltarget = ysd_dist_targt-month06.
    elseif p2month eq '10'.
      lltarget = ysd_dist_targt-month07.
    elseif p2month eq '11'.
      lltarget = ysd_dist_targt-month08.
    elseif p2month eq '12'.
      lltarget = ysd_dist_targt-month09.
    elseif p2month eq '01'.
      lltarget = ysd_dist_targt-month10.
    elseif p2month eq '02'.
      lltarget = ysd_dist_targt-month11.
    elseif p2month eq '03'.
      lltarget = ysd_dist_targt-month12.
    endif.
***************************************************************************
    if ctarget ne 0.
      cm = ( csale / ctarget ) * 100.  "CURRENT MONTH SALE PERCENTAGE.
    endif.
    if ltarget ne 0.
      lm = ( lsale / ltarget ) * 100.  "LAST MONTH SALE PERCENTAGE.
    endif.
    if lltarget ne 0.
      llm = ( llsale / lltarget ) * 100.  "LAST TO LAST MONTH SALE PERCENTAGE.
    endif.
    wa_cms-bzirk = wa_tab6-bzirk.
    wa_cms-cms = cm.
    wa_cms-lms = lm.
    wa_cms-llms = llm.
    collect wa_cms into it_cms.
    clear wa_cms.
  endloop.
endform.                    "csale


*&---------------------------------------------------------------------*
*&      Form  csale_pso
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form csale_pso.


*  WRITE : / 'CURRENT YEAR',CYEAR.

  loop at it_tab6 into wa_tab6.
    clear : lls.
*    WRITE : / 'LAST TO LAST YEAR', wa_TAB6-bzirk.
*    WRITE : / 'chk_dt1',date1,date2,chk_dt1,chk_dt2,chk_dt3,chk_dt4,chk_dt5,chk_dt6,chk_dt7,chk_dt8,chk_dt9,chk_dt10,chk_dt11,chk_dt12.
    wa_cy1_pso-bzirk = wa_tab6-bzirk.
    if wa_tab6-join_date le chk_dt1.
      if chk_dt1 le date2.
        select single * from zcumpso where zmonth eq '04' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          wa_cy1_pso-m1 = zcumpso-netval.
        endif.
      endif.
    endif.
    if wa_tab6-join_date le chk_dt2.
      if chk_dt2 le date2.
        select single * from zcumpso where zmonth eq '05' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
*      WRITE : ZCUMPSO-NETVAL.
          wa_cy1_pso-m2 = zcumpso-netval.
        endif.
      endif.
    endif.
    if wa_tab6-join_date le chk_dt3.
      if chk_dt3 le date2.
        select single * from zcumpso where zmonth eq '06' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          wa_cy1_pso-m3 = zcumpso-netval.
        endif.
      endif.
    endif.
    if wa_tab6-join_date le chk_dt4.
      if chk_dt4 le date2.
        select single * from zcumpso where zmonth eq '07' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          wa_cy1_pso-m4 = zcumpso-netval.
        endif.
      endif.
    endif.
    if wa_tab6-join_date le chk_dt5.
      if chk_dt5 le date2.
        select single * from zcumpso where zmonth eq '08' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          wa_cy1_pso-m5 = zcumpso-netval.
        endif.
      endif.
    endif.
    if wa_tab6-join_date le chk_dt6.
      if chk_dt6 le date2.
        select single * from zcumpso where zmonth eq '09' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          wa_cy1_pso-m6 = zcumpso-netval.
        endif.
      endif.
    endif.
    if wa_tab6-join_date le chk_dt7.
      if chk_dt7 le date2.
        select single * from zcumpso where zmonth eq '10' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          wa_cy1_pso-m7 = zcumpso-netval.
        endif.
      endif.
    endif.
    if wa_tab6-join_date le chk_dt8.
      if chk_dt8 le date2.
        select single * from zcumpso where zmonth eq '11' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          wa_cy1_pso-m8 = zcumpso-netval.
        endif.
      endif.
    endif.
    if wa_tab6-join_date le chk_dt9.
      if chk_dt9 le date2.
        select single * from zcumpso where zmonth eq '12' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          wa_cy1_pso-m9 = zcumpso-netval.
        endif.
      endif.
    endif.
    if wa_tab6-join_date le chk_dt10.
      if chk_dt10 le date2.
        select single * from zcumpso where zmonth eq '01' and zyear eq ccyear and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          wa_cy1_pso-m10 = zcumpso-netval.
        endif.
      endif.
    endif.
    if wa_tab6-join_date le chk_dt11.
      if chk_dt11 le date2.
        select single * from zcumpso where zmonth eq '02' and zyear eq ccyear and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          wa_cy1_pso-m11 = zcumpso-netval.
        endif.
      endif.
    endif.
    if wa_tab6-join_date le chk_dt12.
      if chk_dt12 le date2.
        select single * from zcumpso where zmonth eq '03' and zyear eq ccyear and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          wa_cy1_pso-m12 = zcumpso-netval.
        endif.
      endif.
    endif.
    collect wa_cy1_pso into it_cy1_pso.
    clear wa_cy1_pso.
  endloop.

*  loop at it_cy1 into wa_cy1.
*    clear : sale,qt1,qt2,qt3,qt4.
*    wa_cy2-bzirk = wa_cy1-bzirk.
*    sale = wa_cy1-m1 + wa_cy1-m2 + wa_cy1-m3 + wa_cy1-m4 + wa_cy1-m5 + wa_cy1-m6 + wa_cy1-m7 + wa_cy1-m8 + wa_cy1-m9 + wa_cy1-m10 + wa_cy1-m11 +
*            wa_cy1-m12.
*    wa_cy2-cys = sale.
*    collect wa_cy2 into it_cy2.
*    clear wa_cy2.
*******************************************QUARTER*******
*    wa_cqt1-bzirk = wa_cy1-bzirk.
*    qt1 = wa_cy1-m1 + wa_cy1-m2 + wa_cy1-m3.
*    qt2 = wa_cy1-m4 + wa_cy1-m5 + wa_cy1-m6.
*    qt3 = wa_cy1-m7 + wa_cy1-m8 + wa_cy1-m9.
*    qt4 = wa_cy1-m10 + wa_cy1-m11 + wa_cy1-m12.
*    wa_cqt1-qt1 = qt1.
*    wa_cqt1-qt2 = qt2.
*    wa_cqt1-qt3 = qt3.
*    wa_cqt1-qt4 = qt4.
*    collect wa_cqt1 into it_cqt1.
*    clear wa_cqt1.
*  endloop.
**  LOOP AT IT_CY2 INTO WA_CY2.
**    WRITE : / 'CURRENT YEAR SALE',WA_CY2-BZIRK,WA_CY2-CYS.
**  ENDLOOP.
*
*  loop at it_cqt1 into wa_cqt1.  "QUARTER SALE
*    clear : qt1,qt2,qt3,qt4.
**    WRITE : / 'CURRENT QRT SALE',WA_CQT1-BZIRK,WA_CQT1-QT1,WA_CQT1-QT2,WA_CQT1-QT3,WA_CQT1-QT4.
*    read table it_cyqt1 into wa_cyqt1 with key bzirk = wa_cqt1-bzirk.
*    if sy-subrc eq 0.
*      if wa_cyqt1-qrt1 ne 0.
*        qt1 = ( wa_cqt1-qt1 / wa_cyqt1-qrt1 ) * 100.
*      endif.
*      if wa_cyqt1-qrt2 ne 0.
*        qt2 = ( wa_cqt1-qt2 / wa_cyqt1-qrt2 ) * 100.
*      endif.
*      if wa_cyqt1-qrt3 ne 0.
*        qt3 = ( wa_cqt1-qt3 / wa_cyqt1-qrt3 ) * 100.
*      endif.
*      if wa_cyqt1-qrt4 ne 0.
*        qt4 = ( wa_cqt1-qt4 / wa_cyqt1-qrt4 ) * 100.
*      endif.
*      wa_cys1-bzirk = wa_cqt1-bzirk.
*      wa_cys1-qt1 = qt1.
*      wa_cys1-qt2 = qt2.
*      wa_cys1-qt3 = qt3.
*      wa_cys1-qt4 = qt4.
*      collect wa_cys1 into it_cys1.
*      clear wa_cys1.
*    endif.
*  endloop.
*
**  LOOP AT IT_CYS1 INTO WA_CYS1.  "QUARTER SALE
**    WRITE : / 'CURRENT YEAR QUARTERLY SALE %',WA_CYS1-BZIRK,WA_CYS1-QT1,WA_CYS1-QT2,WA_CYS1-QT3,WA_CYS1-QT4.
**  ENDLOOP.
*
*  call function 'RE_ADD_MONTH_TO_DATE'
*    EXPORTING
*      months  = '-1'
*      olddate = date1
*    IMPORTING
*      newdate = p1date.
*
*  call function 'RE_ADD_MONTH_TO_DATE'
*    EXPORTING
*      months  = '-2'
*      olddate = date1
*    IMPORTING
*      newdate = p2date.
*
**  WRITE : / 'DATE1',DATE1,P1DATE,P2DATE.
*  p1month = p1date+4(2).
*  p1year = p1date+0(4).
*  p2month = p2date+4(2).
*  p2year = p2date+0(4).
*
**  WRITE : / 'LAST MONTH',P1MONTH,P1YEAR,P2MONTH,P2YEAR.
*
*  loop at it_tab6 into wa_tab6.
*    clear : csale,ctarget,cm,lsale,ltarget,lm,llsale,lltarget,llm.
*    select single * from zcumpso where zmonth eq month and zyear eq year and bzirk eq wa_tab6-bzirk and pso eq wa_tab6-pernr.
*    if sy-subrc eq 0.
*      csale = zcumpso-netval.
*    endif.
*    select single * from ysd_dist_targt where bzirk eq wa_tab6-bzirk and trgyear eq cyear.
*    if month eq '04'.
*      ctarget = ysd_dist_targt-month01.
*    elseif month eq '05'.
*      ctarget = ysd_dist_targt-month02.
*    elseif month eq '06'.
*      ctarget = ysd_dist_targt-month03.
*    elseif month eq '07'.
*      ctarget = ysd_dist_targt-month04.
*    elseif month eq '08'.
*      ctarget = ysd_dist_targt-month05.
*    elseif month eq '09'.
*      ctarget = ysd_dist_targt-month06.
*    elseif month eq '10'.
*      ctarget = ysd_dist_targt-month07.
*    elseif month eq '11'.
*      ctarget = ysd_dist_targt-month08.
*    elseif month eq '12'.
*      ctarget = ysd_dist_targt-month09.
*    elseif month eq '01'.
*      ctarget = ysd_dist_targt-month10.
*    elseif month eq '02'.
*      ctarget = ysd_dist_targt-month11.
*    elseif month eq '03'.
*      ctarget = ysd_dist_targt-month12.
*    endif.
*
******************LAST MONTH*************************
*
*    select single * from zcumpso where zmonth eq p1month and zyear eq p1year and bzirk eq wa_tab6-bzirk and pso eq wa_tab6-pernr.
*    if sy-subrc eq 0.
*      lsale = zcumpso-netval.
*    endif.
*    select single * from ysd_dist_targt where bzirk eq wa_tab6-bzirk and trgyear eq p1year.
*    if p1month eq '04'.
*      ltarget = ysd_dist_targt-month01.
*    elseif p1month eq '05'.
*      ltarget = ysd_dist_targt-month02.
*    elseif p1month eq '06'.
*      ltarget = ysd_dist_targt-month03.
*    elseif p1month eq '07'.
*      ltarget = ysd_dist_targt-month04.
*    elseif p1month eq '08'.
*      ltarget = ysd_dist_targt-month05.
*    elseif p1month eq '09'.
*      ltarget = ysd_dist_targt-month06.
*    elseif p1month eq '10'.
*      ltarget = ysd_dist_targt-month07.
*    elseif p1month eq '11'.
*      ltarget = ysd_dist_targt-month08.
*    elseif p1month eq '12'.
*      ltarget = ysd_dist_targt-month09.
*    elseif p1month eq '01'.
*      ltarget = ysd_dist_targt-month10.
*    elseif p1month eq '02'.
*      ltarget = ysd_dist_targt-month11.
*    elseif p1month eq '03'.
*      ltarget = ysd_dist_targt-month12.
*    endif.
*
**********************LAST TO LAST MONTH ********************************
*    select single * from zcumpso where zmonth eq p2month and zyear eq p2year and bzirk eq wa_tab6-bzirk and pso eq wa_tab6-pernr.
*    if sy-subrc eq 0.
*      llsale = zcumpso-netval.
*    endif.
*    select single * from ysd_dist_targt where bzirk eq wa_tab6-bzirk and trgyear eq p2year .
*    if p2month eq '04'.
*      lltarget = ysd_dist_targt-month01.
*    elseif p2month eq '05'.
*      lltarget = ysd_dist_targt-month02.
*    elseif p2month eq '06'.
*      lltarget = ysd_dist_targt-month03.
*    elseif p2month eq '07'.
*      lltarget = ysd_dist_targt-month04.
*    elseif p2month eq '08'.
*      lltarget = ysd_dist_targt-month05.
*    elseif p2month eq '09'.
*      lltarget = ysd_dist_targt-month06.
*    elseif p2month eq '10'.
*      lltarget = ysd_dist_targt-month07.
*    elseif p2month eq '11'.
*      lltarget = ysd_dist_targt-month08.
*    elseif p2month eq '12'.
*      lltarget = ysd_dist_targt-month09.
*    elseif p2month eq '01'.
*      lltarget = ysd_dist_targt-month10.
*    elseif p2month eq '02'.
*      lltarget = ysd_dist_targt-month11.
*    elseif p2month eq '03'.
*      lltarget = ysd_dist_targt-month12.
*    endif.
****************************************************************************
*    if ctarget ne 0.
*      cm = ( csale / ctarget ) * 100.  "CURRENT MONTH SALE PERCENTAGE.
*    ENDIF.
*    if ltarget ne 0.
*      lm = ( lsale / ltarget ) * 100.  "LAST MONTH SALE PERCENTAGE.
*    ENDIF.
*    if lltarget ne 0.
*      llm = ( llsale / lltarget ) * 100.  "LAST TO LAST MONTH SALE PERCENTAGE.
*    ENDIF.
*    wa_cms-bzirk = wa_tab6-bzirk.
*    wa_cms-cms = cm.
*    wa_cms-lms = lm.
*    wa_cms-llms = llm.
*    collect wa_cms into it_cms.
*    clear wa_cms.
*  endloop.
endform.                    "csale



*&---------------------------------------------------------------------*
*&      Form  csale_qrt
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form csale_qrt.
********APR********************
  select * from zdsmter into table it_zdsmter_1 where zmonth eq '04' and zyear eq cyear.
  loop at it_zdsmter_1 into wa_zdsmter_1  where bzirk+0(2) cs 'R-'.
    wa_tad1-rm = wa_zdsmter_1-bzirk.
    wa_tad1-zm = wa_zdsmter_1-zdsm.
    read table it_zdsmter_1 into wa_zdsmter_1 with key bzirk = wa_zdsmter_1-bzirk zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_tad1-dzm = wa_zdsmter_1-zdsm.
    endif.
    collect wa_tad1 into it_tad1.
    clear wa_tad1.
  endloop.
  clear : it_zdsmter_1.
  if it_tad1 is not initial.
    select * from zdsmter into table it_zdsmter_1 for all entries in it_tad1 where zmonth eq '04' and zyear eq cyear
      and zdsm eq it_tad1-rm.
  endif.
  loop at it_zdsmter_1 into wa_zdsmter_1.
    wa_tad2-bzirk = wa_zdsmter_1-bzirk.
    read table it_tad1 into wa_tad1 with key rm = wa_zdsmter_1-zdsm.
    if sy-subrc eq 0.
      wa_tad2-rm = wa_tad1-rm.
      wa_tad2-zm = wa_tad1-zm.
      wa_tad2-dzm = wa_tad1-dzm.
    endif.
    collect wa_tad2 into it_tad2.
    clear wa_tad2.
  endloop.
  sort it_tad2 by zm rm bzirk.
  delete adjacent duplicates from it_tad2 comparing bzirk.
  loop at it_tad2 into wa_tad2.
    wa_apr-bzirk = wa_tad2-bzirk.
    wa_apr-rm = wa_tad2-rm.
    wa_apr-zm = wa_tad2-zm.
    wa_apr-dzm = wa_tad2-dzm.
    select single * from zcumpso where zmonth eq '04' and zyear eq cyear and bzirk eq wa_tad2-bzirk.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_apr-netval = zcumpso-netval.
      endif.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tad2-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_apr-tar = ysd_dist_targt-month01.
      endif.
    endif.
    collect wa_apr into it_apr.
    clear wa_apr.
*  endif.
  endloop.
  clear : it_tad1,it_tad2,it_zdsmter_1.

********MAY********************
  select * from zdsmter into table it_zdsmter_1 where zmonth eq '05' and zyear eq cyear.
  loop at it_zdsmter_1 into wa_zdsmter_1  where bzirk+0(2) cs 'R-' and zdsm in org.
    wa_tad1-rm = wa_zdsmter_1-bzirk.
    wa_tad1-zm = wa_zdsmter_1-zdsm.
    read table it_zdsmter_1 into wa_zdsmter_1 with key bzirk = wa_zdsmter_1-bzirk zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_tad1-dzm = wa_zdsmter_1-zdsm.
    endif.
    collect wa_tad1 into it_tad1.
    clear wa_tad1.
  endloop.
  clear : it_zdsmter_1.
  if it_tad1 is not initial.
    select * from zdsmter into table it_zdsmter_1 for all entries in it_tad1 where zmonth eq '05' and zyear eq cyear
      and zdsm eq it_tad1-rm.
  endif.
  loop at it_zdsmter_1 into wa_zdsmter_1.
    wa_tad2-bzirk = wa_zdsmter_1-bzirk.
    read table it_tad1 into wa_tad1 with key rm = wa_zdsmter_1-zdsm.
    if sy-subrc eq 0.
      wa_tad2-rm = wa_tad1-rm.
      wa_tad2-zm = wa_tad1-zm.
      wa_tad2-dzm = wa_tad1-dzm.
    endif.
    collect wa_tad2 into it_tad2.
    clear wa_tad2.
  endloop.
  sort it_tad2 by zm rm bzirk.
  delete adjacent duplicates from it_tad2 comparing bzirk.
  loop at it_tad2 into wa_tad2.
    wa_may-bzirk = wa_tad2-bzirk.
    wa_may-rm = wa_tad2-rm.
    wa_may-zm = wa_tad2-zm.
    wa_may-dzm = wa_tad2-dzm.
    select single * from zcumpso where zmonth eq '05' and zyear eq cyear and bzirk eq wa_tad2-bzirk.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_may-netval = zcumpso-netval.
      endif.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tad2-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_may-tar = ysd_dist_targt-month02.
      endif.
    endif.
    collect wa_may into it_may.
    clear wa_may.
*  endif.
  endloop.
  clear : it_tad1,it_tad2,it_zdsmter_1.
************JUN*******
  select * from zdsmter into table it_zdsmter_1 where zmonth eq '06' and zyear eq cyear.
  loop at it_zdsmter_1 into wa_zdsmter_1  where bzirk+0(2) cs 'R-' and zdsm in org.
    wa_tad1-rm = wa_zdsmter_1-bzirk.
    wa_tad1-zm = wa_zdsmter_1-zdsm.
    read table it_zdsmter_1 into wa_zdsmter_1 with key bzirk = wa_zdsmter_1-bzirk zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_tad1-dzm = wa_zdsmter_1-zdsm.
    endif.
    collect wa_tad1 into it_tad1.
    clear wa_tad1.
  endloop.
  clear : it_zdsmter_1.
  if it_tad1 is not initial.
    select * from zdsmter into table it_zdsmter_1 for all entries in it_tad1 where zmonth eq '06' and zyear eq cyear
      and zdsm eq it_tad1-rm.
  endif.
  loop at it_zdsmter_1 into wa_zdsmter_1.
    wa_tad2-bzirk = wa_zdsmter_1-bzirk.
    read table it_tad1 into wa_tad1 with key rm = wa_zdsmter_1-zdsm.
    if sy-subrc eq 0.
      wa_tad2-rm = wa_tad1-rm.
      wa_tad2-zm = wa_tad1-zm.
      wa_tad2-dzm = wa_tad1-dzm.
    endif.
    collect wa_tad2 into it_tad2.
    clear wa_tad2.
  endloop.
  sort it_tad2 by zm rm bzirk.
  delete adjacent duplicates from it_tad2 comparing bzirk.
  loop at it_tad2 into wa_tad2.
    wa_jun-bzirk = wa_tad2-bzirk.
    wa_jun-rm = wa_tad2-rm.
    wa_jun-zm = wa_tad2-zm.
    wa_jun-dzm = wa_tad2-dzm.
    select single * from zcumpso where zmonth eq '06' and zyear eq cyear and bzirk eq wa_tad2-bzirk.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_jun-netval = zcumpso-netval.
      endif.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tad2-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_jun-tar = ysd_dist_targt-month03.
      endif.
    endif.
    collect wa_jun into it_jun.
    clear wa_jun.
*    endif.
  endloop.
  clear : it_tad1,it_tad2,it_zdsmter_1.
******JUL****************

  select * from zdsmter into table it_zdsmter_1 where zmonth eq '07' and zyear eq cyear.
  loop at it_zdsmter_1 into wa_zdsmter_1  where bzirk+0(2) cs 'R-' and zdsm in org.
    wa_tad1-rm = wa_zdsmter_1-bzirk.
    wa_tad1-zm = wa_zdsmter_1-zdsm.
    read table it_zdsmter_1 into wa_zdsmter_1 with key bzirk = wa_zdsmter_1-bzirk zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_tad1-dzm = wa_zdsmter_1-zdsm.
    endif.
    collect wa_tad1 into it_tad1.
    clear wa_tad1.
  endloop.
  clear : it_zdsmter_1.
  if it_tad1 is not initial.
    select * from zdsmter into table it_zdsmter_1 for all entries in it_tad1 where zmonth eq '07' and zyear eq cyear
      and zdsm eq it_tad1-rm.
  endif.
  loop at it_zdsmter_1 into wa_zdsmter_1.
    wa_tad2-bzirk = wa_zdsmter_1-bzirk.
    read table it_tad1 into wa_tad1 with key rm = wa_zdsmter_1-zdsm.
    if sy-subrc eq 0.
      wa_tad2-rm = wa_tad1-rm.
      wa_tad2-zm = wa_tad1-zm.
      wa_tad2-dzm = wa_tad1-dzm.
    endif.
    collect wa_tad2 into it_tad2.
    clear wa_tad2.
  endloop.
  sort it_tad2 by zm rm bzirk.
  delete adjacent duplicates from it_tad2 comparing bzirk.
  loop at it_tad2 into wa_tad2.
    wa_jul-bzirk = wa_tad2-bzirk.
    wa_jul-rm = wa_tad2-rm.
    wa_jul-zm = wa_tad2-zm.
    wa_jul-dzm = wa_tad2-dzm.
    select single * from zcumpso where zmonth eq '07' and zyear eq cyear and bzirk eq wa_tad2-bzirk.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_jul-netval = zcumpso-netval.
      endif.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tad2-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_jul-tar = ysd_dist_targt-month04.
      endif.
    endif.
    collect wa_jul into it_jul.
    clear wa_jul.
*    endif.
  endloop.
  clear : it_tad1,it_tad2,it_zdsmter_1.

*****************AUG******************
  select * from zdsmter into table it_zdsmter_1 where zmonth eq '08' and zyear eq cyear.
  loop at it_zdsmter_1 into wa_zdsmter_1  where bzirk+0(2) cs 'R-' and zdsm in org.
    wa_tad1-rm = wa_zdsmter_1-bzirk.
    wa_tad1-zm = wa_zdsmter_1-zdsm.
    read table it_zdsmter_1 into wa_zdsmter_1 with key bzirk = wa_zdsmter_1-bzirk zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_tad1-dzm = wa_zdsmter_1-zdsm.
    endif.
    collect wa_tad1 into it_tad1.
    clear wa_tad1.
  endloop.
  clear : it_zdsmter_1.
  if it_tad1 is not initial.
    select * from zdsmter into table it_zdsmter_1 for all entries in it_tad1 where zmonth eq '08' and zyear eq cyear
      and zdsm eq it_tad1-rm.
  endif.
  loop at it_zdsmter_1 into wa_zdsmter_1.
    wa_tad2-bzirk = wa_zdsmter_1-bzirk.
    read table it_tad1 into wa_tad1 with key rm = wa_zdsmter_1-zdsm.
    if sy-subrc eq 0.
      wa_tad2-rm = wa_tad1-rm.
      wa_tad2-zm = wa_tad1-zm.
      wa_tad2-dzm = wa_tad1-dzm.
    endif.
    collect wa_tad2 into it_tad2.
    clear wa_tad2.
  endloop.
  sort it_tad2 by zm rm bzirk.
  delete adjacent duplicates from it_tad2 comparing bzirk.
  loop at it_tad2 into wa_tad2.
    wa_aug-bzirk = wa_tad2-bzirk.
    wa_aug-rm = wa_tad2-rm.
    wa_aug-zm = wa_tad2-zm.
    wa_aug-dzm = wa_tad2-dzm.
    select single * from zcumpso where zmonth eq '08' and zyear eq cyear and bzirk eq wa_tad2-bzirk.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_aug-netval = zcumpso-netval.
      endif.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tad2-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_aug-tar = ysd_dist_targt-month05.
      endif.
    endif.
    collect wa_aug into it_aug.
    clear wa_aug.
*    endif.
  endloop.
  clear : it_tad1,it_tad2,it_zdsmter_1.

****************SEP******************
  select * from zdsmter into table it_zdsmter_1 where zmonth eq '09' and zyear eq cyear.
  loop at it_zdsmter_1 into wa_zdsmter_1  where bzirk+0(2) cs 'R-' and zdsm in org.
    wa_tad1-rm = wa_zdsmter_1-bzirk.
    wa_tad1-zm = wa_zdsmter_1-zdsm.
    read table it_zdsmter_1 into wa_zdsmter_1 with key bzirk = wa_zdsmter_1-bzirk zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_tad1-dzm = wa_zdsmter_1-zdsm.
    endif.
    collect wa_tad1 into it_tad1.
    clear wa_tad1.
  endloop.
  clear : it_zdsmter_1.
  if it_tad1 is not initial.
    select * from zdsmter into table it_zdsmter_1 for all entries in it_tad1 where zmonth eq '09' and zyear eq cyear
      and zdsm eq it_tad1-rm.
  endif.
  loop at it_zdsmter_1 into wa_zdsmter_1.
    wa_tad2-bzirk = wa_zdsmter_1-bzirk.
    read table it_tad1 into wa_tad1 with key rm = wa_zdsmter_1-zdsm.
    if sy-subrc eq 0.
      wa_tad2-rm = wa_tad1-rm.
      wa_tad2-zm = wa_tad1-zm.
      wa_tad2-dzm = wa_tad1-dzm.
    endif.
    collect wa_tad2 into it_tad2.
    clear wa_tad2.
  endloop.
  sort it_tad2 by zm rm bzirk.
  delete adjacent duplicates from it_tad2 comparing bzirk.
  loop at it_tad2 into wa_tad2.
    wa_sep-bzirk = wa_tad2-bzirk.
    wa_sep-rm = wa_tad2-rm.
    wa_sep-zm = wa_tad2-zm.
    wa_sep-dzm = wa_tad2-dzm.
    select single * from zcumpso where zmonth eq '09' and zyear eq cyear and bzirk eq wa_tad2-bzirk.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_sep-netval = zcumpso-netval.
      endif.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tad2-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_sep-tar = ysd_dist_targt-month06.
      endif.
    endif.
    collect wa_sep into it_sep.
    clear wa_sep.
*    endif.
  endloop.
  clear : it_tad1,it_tad2,it_zdsmter_1.

*****************OCT******************
  select * from zdsmter into table it_zdsmter_1 where zmonth eq '10' and zyear eq cyear.
  loop at it_zdsmter_1 into wa_zdsmter_1  where bzirk+0(2) cs 'R-' and zdsm in org.
    wa_tad1-rm = wa_zdsmter_1-bzirk.
    wa_tad1-zm = wa_zdsmter_1-zdsm.
    read table it_zdsmter_1 into wa_zdsmter_1 with key bzirk = wa_zdsmter_1-bzirk zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_tad1-dzm = wa_zdsmter_1-zdsm.
    endif.
    collect wa_tad1 into it_tad1.
    clear wa_tad1.
  endloop.
  clear : it_zdsmter_1.
  if it_tad1 is not initial.
    select * from zdsmter into table it_zdsmter_1 for all entries in it_tad1 where zmonth eq '10' and zyear eq cyear
      and zdsm eq it_tad1-rm.
  endif.
  loop at it_zdsmter_1 into wa_zdsmter_1.
    wa_tad2-bzirk = wa_zdsmter_1-bzirk.
    read table it_tad1 into wa_tad1 with key rm = wa_zdsmter_1-zdsm.
    if sy-subrc eq 0.
      wa_tad2-rm = wa_tad1-rm.
      wa_tad2-zm = wa_tad1-zm.
      wa_tad2-dzm = wa_tad1-dzm.
    endif.
    collect wa_tad2 into it_tad2.
    clear wa_tad2.
  endloop.
  sort it_tad2 by zm rm bzirk.
  delete adjacent duplicates from it_tad2 comparing bzirk.
  loop at it_tad2 into wa_tad2.
    wa_oct-bzirk = wa_tad2-bzirk.
    wa_oct-rm = wa_tad2-rm.
    wa_oct-zm = wa_tad2-zm.
    wa_oct-dzm = wa_tad2-dzm.
    select single * from zcumpso where zmonth eq '10' and zyear eq cyear and bzirk eq wa_tad2-bzirk.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_oct-netval = zcumpso-netval.
      endif.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tad2-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_oct-tar = ysd_dist_targt-month07.
      endif.
    endif.
    collect wa_oct into it_oct.
    clear wa_oct.
*    endif.
  endloop.
  clear : it_tad1,it_tad2,it_zdsmter_1.
**************NOV******************
  select * from zdsmter into table it_zdsmter_1 where zmonth eq '11' and zyear eq cyear.
  loop at it_zdsmter_1 into wa_zdsmter_1  where bzirk+0(2) cs 'R-' and zdsm in org.
    wa_tad1-rm = wa_zdsmter_1-bzirk.
    wa_tad1-zm = wa_zdsmter_1-zdsm.
    read table it_zdsmter_1 into wa_zdsmter_1 with key bzirk = wa_zdsmter_1-bzirk zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_tad1-dzm = wa_zdsmter_1-zdsm.
    endif.
    collect wa_tad1 into it_tad1.
    clear wa_tad1.
  endloop.
  clear : it_zdsmter_1.
  if it_tad1 is not initial.
    select * from zdsmter into table it_zdsmter_1 for all entries in it_tad1 where zmonth eq '11' and zyear eq cyear
      and zdsm eq it_tad1-rm.
  endif.
  loop at it_zdsmter_1 into wa_zdsmter_1.
    wa_tad2-bzirk = wa_zdsmter_1-bzirk.
    read table it_tad1 into wa_tad1 with key rm = wa_zdsmter_1-zdsm.
    if sy-subrc eq 0.
      wa_tad2-rm = wa_tad1-rm.
      wa_tad2-zm = wa_tad1-zm.
      wa_tad2-dzm = wa_tad1-dzm.
    endif.
    collect wa_tad2 into it_tad2.
    clear wa_tad2.
  endloop.
  sort it_tad2 by zm rm bzirk.
  delete adjacent duplicates from it_tad2 comparing bzirk.
  loop at it_tad2 into wa_tad2.
    wa_nov-bzirk = wa_tad2-bzirk.
    wa_nov-rm = wa_tad2-rm.
    wa_nov-zm = wa_tad2-zm.
    wa_nov-dzm = wa_tad2-dzm.
    select single * from zcumpso where zmonth eq '11' and zyear eq cyear and bzirk eq wa_tad2-bzirk.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_nov-netval = zcumpso-netval.
      endif.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tad2-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_nov-tar = ysd_dist_targt-month08.
      endif.
    endif.
    collect wa_nov into it_nov.
    clear wa_nov.
*      endif.
  endloop.
  clear : it_tad1,it_tad2,it_zdsmter_1.

****************DEC************************
  select * from zdsmter into table it_zdsmter_1 where zmonth eq '12' and zyear eq cyear.
  loop at it_zdsmter_1 into wa_zdsmter_1  where bzirk+0(2) cs 'R-' and zdsm in org.
    wa_tad1-rm = wa_zdsmter_1-bzirk.
    wa_tad1-zm = wa_zdsmter_1-zdsm.
    read table it_zdsmter_1 into wa_zdsmter_1 with key bzirk = wa_zdsmter_1-bzirk zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_tad1-dzm = wa_zdsmter_1-zdsm.
    endif.
    collect wa_tad1 into it_tad1.
    clear wa_tad1.
  endloop.
  clear : it_zdsmter_1.
  if it_tad1 is not initial.
    select * from zdsmter into table it_zdsmter_1 for all entries in it_tad1 where zmonth eq '12' and zyear eq cyear
      and zdsm eq it_tad1-rm.
  endif.
  loop at it_zdsmter_1 into wa_zdsmter_1.
    wa_tad2-bzirk = wa_zdsmter_1-bzirk.
    read table it_tad1 into wa_tad1 with key rm = wa_zdsmter_1-zdsm.
    if sy-subrc eq 0.
      wa_tad2-rm = wa_tad1-rm.
      wa_tad2-zm = wa_tad1-zm.
      wa_tad2-dzm = wa_tad1-dzm.
    endif.
    collect wa_tad2 into it_tad2.
    clear wa_tad2.
  endloop.
  sort it_tad2 by zm rm bzirk.
  delete adjacent duplicates from it_tad2 comparing bzirk.
  loop at it_tad2 into wa_tad2.
    wa_dec-bzirk = wa_tad2-bzirk.
    wa_dec-rm = wa_tad2-rm.
    wa_dec-zm = wa_tad2-zm.
    wa_dec-dzm = wa_tad2-dzm.
    select single * from zcumpso where zmonth eq '12' and zyear eq cyear and bzirk eq wa_tad2-bzirk.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_dec-netval = zcumpso-netval.
      endif.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tad2-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_dec-tar = ysd_dist_targt-month09.
      endif.
    endif.
    collect wa_dec into it_dec.
    clear wa_dec.
*    endif.
  endloop.
  clear : it_tad1,it_tad2,it_zdsmter_1.

******************JAN****************
  select * from zdsmter into table it_zdsmter_1 where zmonth eq '01' and zyear eq ccyear.
  loop at it_zdsmter_1 into wa_zdsmter_1  where bzirk+0(2) cs 'R-' and zdsm in org.
    wa_tad1-rm = wa_zdsmter_1-bzirk.
    wa_tad1-zm = wa_zdsmter_1-zdsm.
    read table it_zdsmter_1 into wa_zdsmter_1 with key bzirk = wa_zdsmter_1-bzirk zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_tad1-dzm = wa_zdsmter_1-zdsm.
    endif.
    collect wa_tad1 into it_tad1.
    clear wa_tad1.
  endloop.
  clear : it_zdsmter_1.
  if it_tad1 is not initial.
    select * from zdsmter into table it_zdsmter_1 for all entries in it_tad1 where zmonth eq '01' and zyear eq ccyear
      and zdsm eq it_tad1-rm.
  endif.
  loop at it_zdsmter_1 into wa_zdsmter_1.
    wa_tad2-bzirk = wa_zdsmter_1-bzirk.
    read table it_tad1 into wa_tad1 with key rm = wa_zdsmter_1-zdsm.
    if sy-subrc eq 0.
      wa_tad2-rm = wa_tad1-rm.
      wa_tad2-zm = wa_tad1-zm.
      wa_tad2-dzm = wa_tad1-dzm.
    endif.
    collect wa_tad2 into it_tad2.
    clear wa_tad2.
  endloop.
  sort it_tad2 by zm rm bzirk.
  delete adjacent duplicates from it_tad2 comparing bzirk.
  loop at it_tad2 into wa_tad2.
    wa_jan-bzirk = wa_tad2-bzirk.
    wa_jan-rm = wa_tad2-rm.
    wa_jan-zm = wa_tad2-zm.
    wa_jan-dzm = wa_tad2-dzm.
    select single * from zcumpso where zmonth eq '01' and zyear eq ccyear and bzirk eq wa_tad2-bzirk.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_jan-netval = zcumpso-netval.
      endif.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tad2-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_jan-tar = ysd_dist_targt-month10.
      endif.
    endif.
    collect wa_jan into it_jan.
    clear wa_jan.
*    endif.
  endloop.
  clear : it_tad1,it_tad2,it_zdsmter_1.

****************FEB**************
  select * from zdsmter into table it_zdsmter_1 where zmonth eq '02' and zyear eq ccyear.
  loop at it_zdsmter_1 into wa_zdsmter_1  where bzirk+0(2) cs 'R-' and zdsm in org.
    wa_tad1-rm = wa_zdsmter_1-bzirk.
    wa_tad1-zm = wa_zdsmter_1-zdsm.
    read table it_zdsmter_1 into wa_zdsmter_1 with key bzirk = wa_zdsmter_1-bzirk zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_tad1-dzm = wa_zdsmter_1-zdsm.
    endif.
    collect wa_tad1 into it_tad1.
    clear wa_tad1.
  endloop.
  clear : it_zdsmter_1.
  if it_tad1 is not initial.
    select * from zdsmter into table it_zdsmter_1 for all entries in it_tad1 where zmonth eq '02' and zyear eq ccyear
      and zdsm eq it_tad1-rm.
  endif.
  loop at it_zdsmter_1 into wa_zdsmter_1.
    wa_tad2-bzirk = wa_zdsmter_1-bzirk.
    read table it_tad1 into wa_tad1 with key rm = wa_zdsmter_1-zdsm.
    if sy-subrc eq 0.
      wa_tad2-rm = wa_tad1-rm.
      wa_tad2-zm = wa_tad1-zm.
      wa_tad2-dzm = wa_tad1-dzm.
    endif.
    collect wa_tad2 into it_tad2.
    clear wa_tad2.
  endloop.
  sort it_tad2 by zm rm bzirk.
  delete adjacent duplicates from it_tad2 comparing bzirk.
  loop at it_tad2 into wa_tad2.
    wa_feb-bzirk = wa_tad2-bzirk.
    wa_feb-rm = wa_tad2-rm.
    wa_feb-zm = wa_tad2-zm.
    wa_feb-dzm = wa_tad2-dzm.
    select single * from zcumpso where zmonth eq '02' and zyear eq ccyear and bzirk eq wa_tad2-bzirk.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_feb-netval = zcumpso-netval.
      endif.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tad2-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_feb-tar = ysd_dist_targt-month11.
      endif.
    endif.
    collect wa_feb into it_feb.
    clear wa_feb.
*    endif.
  endloop.
  clear : it_tad1,it_tad2,it_zdsmter_1.
*********************MAR************
  select * from zdsmter into table it_zdsmter_1 where zmonth eq '03' and zyear eq ccyear.
  loop at it_zdsmter_1 into wa_zdsmter_1  where bzirk+0(2) cs 'R-' and zdsm in org.
    wa_tad1-rm = wa_zdsmter_1-bzirk.
    wa_tad1-zm = wa_zdsmter_1-zdsm.
    read table it_zdsmter_1 into wa_zdsmter_1 with key bzirk = wa_zdsmter_1-bzirk zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_tad1-dzm = wa_zdsmter_1-zdsm.
    endif.
    collect wa_tad1 into it_tad1.
    clear wa_tad1.
  endloop.
  clear : it_zdsmter_1.
  if it_tad1 is not initial.
    select * from zdsmter into table it_zdsmter_1 for all entries in it_tad1 where zmonth eq '03' and zyear eq ccyear
      and zdsm eq it_tad1-rm.
  endif.
  loop at it_zdsmter_1 into wa_zdsmter_1.
    wa_tad2-bzirk = wa_zdsmter_1-bzirk.
    read table it_tad1 into wa_tad1 with key rm = wa_zdsmter_1-zdsm.
    if sy-subrc eq 0.
      wa_tad2-rm = wa_tad1-rm.
      wa_tad2-zm = wa_tad1-zm.
      wa_tad2-dzm = wa_tad1-dzm.
    endif.
    collect wa_tad2 into it_tad2.
    clear wa_tad2.
  endloop.
  sort it_tad2 by zm rm bzirk.
  delete adjacent duplicates from it_tad2 comparing bzirk.
  loop at it_tad2 into wa_tad2.
    wa_mar-bzirk = wa_tad2-bzirk.
    wa_mar-rm = wa_tad2-rm.
    wa_mar-zm = wa_tad2-zm.
    wa_mar-dzm = wa_tad2-dzm.
    select single * from zcumpso where zmonth eq '03' and zyear eq ccyear and bzirk eq wa_tad2-bzirk.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_mar-netval = zcumpso-netval.
      endif.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tad2-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_mar-tar = ysd_dist_targt-month12.
      endif.
    endif.
    collect wa_mar into it_mar.
    clear wa_mar.
*    endif.
  endloop.
  clear : it_tad1,it_tad2,it_zdsmter_1.
*************************************


endform.                    "csale


*&---------------------------------------------------------------------*
*&      Form  lsale_cumpso_qrt
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form lsale_cumpso_qrt.
********APR********************
  select * from zdsmter into table it_zdsmter_1 where zmonth eq '04' and zyear eq lyear.
  loop at it_zdsmter_1 into wa_zdsmter_1  where bzirk+0(2) cs 'R-'.
    wa_tad1-rm = wa_zdsmter_1-bzirk.
    wa_tad1-zm = wa_zdsmter_1-zdsm.
    read table it_zdsmter_1 into wa_zdsmter_1 with key bzirk = wa_zdsmter_1-bzirk zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_tad1-dzm = wa_zdsmter_1-zdsm.
    endif.
    collect wa_tad1 into it_tad1.
    clear wa_tad1.
  endloop.
  clear : it_zdsmter_1.
  if it_tad1 is not initial.
    select * from zdsmter into table it_zdsmter_1 for all entries in it_tad1 where zmonth eq '04' and zyear eq lyear
      and zdsm eq it_tad1-rm.
  endif.
  loop at it_zdsmter_1 into wa_zdsmter_1.
    wa_tad2-bzirk = wa_zdsmter_1-bzirk.
    read table it_tad1 into wa_tad1 with key rm = wa_zdsmter_1-zdsm.
    if sy-subrc eq 0.
      wa_tad2-rm = wa_tad1-rm.
      wa_tad2-zm = wa_tad1-zm.
      wa_tad2-dzm = wa_tad1-dzm.
    endif.
    collect wa_tad2 into it_tad2.
    clear wa_tad2.
  endloop.
  sort it_tad2 by zm rm bzirk.
  delete adjacent duplicates from it_tad2 comparing bzirk.
  loop at it_tab6 into wa_tab6.
    wa_lapr-bzirk = wa_tab6-bzirk.
    wa_lapr-rm = wa_tab6-rm.
    wa_lapr-zm = wa_tab6-reg.
    select single * from zdsmter where zmonth eq month and zyear eq year and bzirk eq wa_tab6-reg.
    if sy-subrc eq 0.
      wa_lapr-sm = zdsmter-zdsm.
    endif.
*    wa_lapr-dzm = wa_TAB6-dzm.
    select single * from zcumpso where zmonth eq '04' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_lapr-netval = zcumpso-netval.
      endif.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tab6-bzirk and trgyear eq lyear.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_lapr-tar = ysd_dist_targt-month01.
      endif.
    endif.
    collect wa_lapr into it_lapr.
    clear wa_lapr.
*    endif.
  endloop.
  clear : it_tad1,it_tad2,it_zdsmter_1.

********MAY********************
  select * from zdsmter into table it_zdsmter_1 where zmonth eq '05' and zyear eq lyear.
  loop at it_zdsmter_1 into wa_zdsmter_1  where bzirk+0(2) cs 'R-' and zdsm in org.
    wa_tad1-rm = wa_zdsmter_1-bzirk.
    wa_tad1-zm = wa_zdsmter_1-zdsm.
    read table it_zdsmter_1 into wa_zdsmter_1 with key bzirk = wa_zdsmter_1-bzirk zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_tad1-dzm = wa_zdsmter_1-zdsm.
    endif.
    collect wa_tad1 into it_tad1.
    clear wa_tad1.
  endloop.
  clear : it_zdsmter_1.
  if it_tad1 is not initial.
    select * from zdsmter into table it_zdsmter_1 for all entries in it_tad1 where zmonth eq '05' and zyear eq lyear
      and zdsm eq it_tad1-rm.
  endif.
  loop at it_zdsmter_1 into wa_zdsmter_1.
    wa_tad2-bzirk = wa_zdsmter_1-bzirk.
    read table it_tad1 into wa_tad1 with key rm = wa_zdsmter_1-zdsm.
    if sy-subrc eq 0.
      wa_tad2-rm = wa_tad1-rm.
      wa_tad2-zm = wa_tad1-zm.
      wa_tad2-dzm = wa_tad1-dzm.
    endif.
    collect wa_tad2 into it_tad2.
    clear wa_tad2.
  endloop.
  sort it_tad2 by zm rm bzirk.
  delete adjacent duplicates from it_tad2 comparing bzirk.
  loop at it_tab6 into wa_tab6.
    wa_lmay-bzirk = wa_tab6-bzirk.
    wa_lmay-rm = wa_tab6-rm.
    wa_lmay-zm = wa_tab6-reg.
*    wa_lmay-dzm = wa_TAB6-dzm.
    select single * from zcumpso where zmonth eq '05' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_lmay-netval = zcumpso-netval.
      endif.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tab6-bzirk and trgyear eq lyear.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_lmay-tar = ysd_dist_targt-month02.
      endif.
    endif.
    collect wa_lmay into it_lmay.
    clear wa_lmay.
*    endif.
  endloop.
  clear : it_tad1,it_tad2,it_zdsmter_1.
************JUN*******
  select * from zdsmter into table it_zdsmter_1 where zmonth eq '06' and zyear eq lyear.
  loop at it_zdsmter_1 into wa_zdsmter_1  where bzirk+0(2) cs 'R-' and zdsm in org.
    wa_tad1-rm = wa_zdsmter_1-bzirk.
    wa_tad1-zm = wa_zdsmter_1-zdsm.
    read table it_zdsmter_1 into wa_zdsmter_1 with key bzirk = wa_zdsmter_1-bzirk zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_tad1-dzm = wa_zdsmter_1-zdsm.
    endif.
    collect wa_tad1 into it_tad1.
    clear wa_tad1.
  endloop.
  clear : it_zdsmter_1.
  if it_tad1 is not initial.
    select * from zdsmter into table it_zdsmter_1 for all entries in it_tad1 where zmonth eq '06' and zyear eq lyear
      and zdsm eq it_tad1-rm.
  endif.
  loop at it_zdsmter_1 into wa_zdsmter_1.
    wa_tad2-bzirk = wa_zdsmter_1-bzirk.
    read table it_tad1 into wa_tad1 with key rm = wa_zdsmter_1-zdsm.
    if sy-subrc eq 0.
      wa_tad2-rm = wa_tad1-rm.
      wa_tad2-zm = wa_tad1-zm.
      wa_tad2-dzm = wa_tad1-dzm.
    endif.
    collect wa_tad2 into it_tad2.
    clear wa_tad2.
  endloop.
  sort it_tad2 by zm rm bzirk.
  delete adjacent duplicates from it_tad2 comparing bzirk.
  loop at it_tab6 into wa_tab6.
    wa_ljun-bzirk = wa_tab6-bzirk.
    wa_ljun-rm = wa_tab6-rm.
    wa_ljun-zm = wa_tab6-reg.
*    wa_ljun-dzm = wa_TAB6-dzm.
    select single * from zcumpso where zmonth eq '06' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_ljun-netval = zcumpso-netval.
      endif.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tab6-bzirk and trgyear eq lyear.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_ljun-tar = ysd_dist_targt-month03.
      endif.
    endif.
    collect wa_ljun into it_ljun.
    clear wa_ljun.
*    endif.
  endloop.
  clear : it_tad1,it_tad2,it_zdsmter_1.
******JUL****************

  select * from zdsmter into table it_zdsmter_1 where zmonth eq '07' and zyear eq lyear.
  loop at it_zdsmter_1 into wa_zdsmter_1  where bzirk+0(2) cs 'R-' and zdsm in org.
    wa_tad1-rm = wa_zdsmter_1-bzirk.
    wa_tad1-zm = wa_zdsmter_1-zdsm.
    read table it_zdsmter_1 into wa_zdsmter_1 with key bzirk = wa_zdsmter_1-bzirk zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_tad1-dzm = wa_zdsmter_1-zdsm.
    endif.
    collect wa_tad1 into it_tad1.
    clear wa_tad1.
  endloop.
  clear : it_zdsmter_1.
  if it_tad1 is not initial.
    select * from zdsmter into table it_zdsmter_1 for all entries in it_tad1 where zmonth eq '07' and zyear eq lyear
      and zdsm eq it_tad1-rm.
  endif.
  loop at it_zdsmter_1 into wa_zdsmter_1.
    wa_tad2-bzirk = wa_zdsmter_1-bzirk.
    read table it_tad1 into wa_tad1 with key rm = wa_zdsmter_1-zdsm.
    if sy-subrc eq 0.
      wa_tad2-rm = wa_tad1-rm.
      wa_tad2-zm = wa_tad1-zm.
      wa_tad2-dzm = wa_tad1-dzm.
    endif.
    collect wa_tad2 into it_tad2.
    clear wa_tad2.
  endloop.
  sort it_tad2 by zm rm bzirk.
  delete adjacent duplicates from it_tad2 comparing bzirk.
  loop at it_tab6 into wa_tab6.
    wa_ljul-bzirk = wa_tab6-bzirk.
    wa_ljul-rm = wa_tab6-rm.
    wa_ljul-zm = wa_tab6-reg.
*    wa_ljul-dzm = wa_TAB6-dzm.
    select single * from zcumpso where zmonth eq '07' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_ljul-netval = zcumpso-netval.
      endif.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tab6-bzirk and trgyear eq lyear.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_ljul-tar = ysd_dist_targt-month04.
      endif.
    endif.
    collect wa_ljul into it_ljul.
    clear wa_ljul.
*    endif.
  endloop.
  clear : it_tad1,it_tad2,it_zdsmter_1.

*****************AUG******************
  select * from zdsmter into table it_zdsmter_1 where zmonth eq '08' and zyear eq lyear.
  loop at it_zdsmter_1 into wa_zdsmter_1  where bzirk+0(2) cs 'R-' and zdsm in org.
    wa_tad1-rm = wa_zdsmter_1-bzirk.
    wa_tad1-zm = wa_zdsmter_1-zdsm.
    read table it_zdsmter_1 into wa_zdsmter_1 with key bzirk = wa_zdsmter_1-bzirk zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_tad1-dzm = wa_zdsmter_1-zdsm.
    endif.
    collect wa_tad1 into it_tad1.
    clear wa_tad1.
  endloop.
  clear : it_zdsmter_1.
  if it_tad1 is not initial.
    select * from zdsmter into table it_zdsmter_1 for all entries in it_tad1 where zmonth eq '08' and zyear eq lyear
      and zdsm eq it_tad1-rm.
  endif.
  loop at it_zdsmter_1 into wa_zdsmter_1.
    wa_tad2-bzirk = wa_zdsmter_1-bzirk.
    read table it_tad1 into wa_tad1 with key rm = wa_zdsmter_1-zdsm.
    if sy-subrc eq 0.
      wa_tad2-rm = wa_tad1-rm.
      wa_tad2-zm = wa_tad1-zm.
      wa_tad2-dzm = wa_tad1-dzm.
    endif.
    collect wa_tad2 into it_tad2.
    clear wa_tad2.
  endloop.
  sort it_tad2 by zm rm bzirk.
  delete adjacent duplicates from it_tad2 comparing bzirk.
  loop at it_tab6 into wa_tab6.
    wa_laug-bzirk = wa_tab6-bzirk.
    wa_laug-rm = wa_tab6-rm.
    wa_laug-zm = wa_tab6-reg.
*    wa_laug-dzm = wa_TAB6-dzm.
    select single * from zcumpso where zmonth eq '08' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_laug-netval = zcumpso-netval.
      endif.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tab6-bzirk and trgyear eq lyear.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_laug-tar = ysd_dist_targt-month05.
      endif.
    endif.
    collect wa_laug into it_laug.
    clear wa_laug.
*    endif.
  endloop.
  clear : it_tad1,it_tad2,it_zdsmter_1.

****************SEP******************
  select * from zdsmter into table it_zdsmter_1 where zmonth eq '09' and zyear eq lyear.
  loop at it_zdsmter_1 into wa_zdsmter_1  where bzirk+0(2) cs 'R-' and zdsm in org.
    wa_tad1-rm = wa_zdsmter_1-bzirk.
    wa_tad1-zm = wa_zdsmter_1-zdsm.
    read table it_zdsmter_1 into wa_zdsmter_1 with key bzirk = wa_zdsmter_1-bzirk zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_tad1-dzm = wa_zdsmter_1-zdsm.
    endif.
    collect wa_tad1 into it_tad1.
    clear wa_tad1.
  endloop.
  clear : it_zdsmter_1.
  if it_tad1 is not initial.
    select * from zdsmter into table it_zdsmter_1 for all entries in it_tad1 where zmonth eq '09' and zyear eq lyear
      and zdsm eq it_tad1-rm.
  endif.
  loop at it_zdsmter_1 into wa_zdsmter_1.
    wa_tad2-bzirk = wa_zdsmter_1-bzirk.
    read table it_tad1 into wa_tad1 with key rm = wa_zdsmter_1-zdsm.
    if sy-subrc eq 0.
      wa_tad2-rm = wa_tad1-rm.
      wa_tad2-zm = wa_tad1-zm.
      wa_tad2-dzm = wa_tad1-dzm.
    endif.
    collect wa_tad2 into it_tad2.
    clear wa_tad2.
  endloop.
  sort it_tad2 by zm rm bzirk.
  delete adjacent duplicates from it_tad2 comparing bzirk.
  loop at it_tab6 into wa_tab6.
    wa_lsep-bzirk = wa_tab6-bzirk.
    wa_lsep-rm = wa_tab6-rm.
    wa_lsep-zm = wa_tab6-reg.
*    wa_lsep-dzm = wa_TAB6-dzm.
    select single * from zcumpso where zmonth eq '09' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_lsep-netval = zcumpso-netval.
      endif.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tab6-bzirk and trgyear eq lyear.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_lsep-tar = ysd_dist_targt-month06.
      endif.
    endif.
    collect wa_lsep into it_lsep.
    clear wa_lsep.
*    endif.
  endloop.
  clear : it_tad1,it_tad2,it_zdsmter_1.

*****************OCT******************
  select * from zdsmter into table it_zdsmter_1 where zmonth eq '10' and zyear eq lyear.
  loop at it_zdsmter_1 into wa_zdsmter_1  where bzirk+0(2) cs 'R-' and zdsm in org.
    wa_tad1-rm = wa_zdsmter_1-bzirk.
    wa_tad1-zm = wa_zdsmter_1-zdsm.
    read table it_zdsmter_1 into wa_zdsmter_1 with key bzirk = wa_zdsmter_1-bzirk zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_tad1-dzm = wa_zdsmter_1-zdsm.
    endif.
    collect wa_tad1 into it_tad1.
    clear wa_tad1.
  endloop.
  clear : it_zdsmter_1.
  if it_tad1 is not initial.
    select * from zdsmter into table it_zdsmter_1 for all entries in it_tad1 where zmonth eq '10' and zyear eq lyear
      and zdsm eq it_tad1-rm.
  endif.
  loop at it_zdsmter_1 into wa_zdsmter_1.
    wa_tad2-bzirk = wa_zdsmter_1-bzirk.
    read table it_tad1 into wa_tad1 with key rm = wa_zdsmter_1-zdsm.
    if sy-subrc eq 0.
      wa_tad2-rm = wa_tad1-rm.
      wa_tad2-zm = wa_tad1-zm.
      wa_tad2-dzm = wa_tad1-dzm.
    endif.
    collect wa_tad2 into it_tad2.
    clear wa_tad2.
  endloop.
  sort it_tad2 by zm rm bzirk.
  delete adjacent duplicates from it_tad2 comparing bzirk.
  loop at it_tab6 into wa_tab6.
    wa_loct-bzirk = wa_tab6-bzirk.
    wa_loct-rm = wa_tab6-rm.
    wa_loct-zm = wa_tab6-reg.
*    wa_loct-dzm = wa_TAB6-dzm.
    select single * from zcumpso where zmonth eq '10' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_loct-netval = zcumpso-netval.
      endif.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tab6-bzirk and trgyear eq lyear.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_loct-tar = ysd_dist_targt-month07.
      endif.
    endif.
    collect wa_loct into it_loct.
    clear wa_loct.
*    endif.
  endloop.
  clear : it_tad1,it_tad2,it_zdsmter_1.
**************NOV******************
  select * from zdsmter into table it_zdsmter_1 where zmonth eq '11' and zyear eq lyear.
  loop at it_zdsmter_1 into wa_zdsmter_1  where bzirk+0(2) cs 'R-' and zdsm in org.
    wa_tad1-rm = wa_zdsmter_1-bzirk.
    wa_tad1-zm = wa_zdsmter_1-zdsm.
    read table it_zdsmter_1 into wa_zdsmter_1 with key bzirk = wa_zdsmter_1-bzirk zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_tad1-dzm = wa_zdsmter_1-zdsm.
    endif.
    collect wa_tad1 into it_tad1.
    clear wa_tad1.
  endloop.
  clear : it_zdsmter_1.
  if it_tad1 is not initial.
    select * from zdsmter into table it_zdsmter_1 for all entries in it_tad1 where zmonth eq '11' and zyear eq lyear
      and zdsm eq it_tad1-rm.
  endif.
  loop at it_zdsmter_1 into wa_zdsmter_1.
    wa_tad2-bzirk = wa_zdsmter_1-bzirk.
    read table it_tad1 into wa_tad1 with key rm = wa_zdsmter_1-zdsm.
    if sy-subrc eq 0.
      wa_tad2-rm = wa_tad1-rm.
      wa_tad2-zm = wa_tad1-zm.
      wa_tad2-dzm = wa_tad1-dzm.
    endif.
    collect wa_tad2 into it_tad2.
    clear wa_tad2.
  endloop.
  sort it_tad2 by zm rm bzirk.
  delete adjacent duplicates from it_tad2 comparing bzirk.
  loop at it_tab6 into wa_tab6.
    wa_lnov-bzirk = wa_tab6-bzirk.
    wa_lnov-rm = wa_tab6-rm.
    wa_lnov-zm = wa_tab6-reg.
*    wa_lnov-dzm = wa_TAB6-dzm.
    select single * from zcumpso where zmonth eq '11' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_lnov-netval = zcumpso-netval.
      endif.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tab6-bzirk and trgyear eq lyear.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_lnov-tar = ysd_dist_targt-month08.
      endif.
    endif.
    collect wa_lnov into it_lnov.
    clear wa_lnov.
*    endif.
  endloop.
  clear : it_tad1,it_tad2,it_zdsmter_1.

****************DEC************************
  select * from zdsmter into table it_zdsmter_1 where zmonth eq '12' and zyear eq lyear.
  loop at it_zdsmter_1 into wa_zdsmter_1  where bzirk+0(2) cs 'R-' and zdsm in org.
    wa_tad1-rm = wa_zdsmter_1-bzirk.
    wa_tad1-zm = wa_zdsmter_1-zdsm.
    read table it_zdsmter_1 into wa_zdsmter_1 with key bzirk = wa_zdsmter_1-bzirk zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_tad1-dzm = wa_zdsmter_1-zdsm.
    endif.
    collect wa_tad1 into it_tad1.
    clear wa_tad1.
  endloop.
  clear : it_zdsmter_1.
  if it_tad1 is not initial.
    select * from zdsmter into table it_zdsmter_1 for all entries in it_tad1 where zmonth eq '12' and zyear eq lyear
      and zdsm eq it_tad1-rm.
  endif.
  loop at it_zdsmter_1 into wa_zdsmter_1.
    wa_tad2-bzirk = wa_zdsmter_1-bzirk.
    read table it_tad1 into wa_tad1 with key rm = wa_zdsmter_1-zdsm.
    if sy-subrc eq 0.
      wa_tad2-rm = wa_tad1-rm.
      wa_tad2-zm = wa_tad1-zm.
      wa_tad2-dzm = wa_tad1-dzm.
    endif.
    collect wa_tad2 into it_tad2.
    clear wa_tad2.
  endloop.
  sort it_tad2 by zm rm bzirk.
  delete adjacent duplicates from it_tad2 comparing bzirk.
  loop at it_tab6 into wa_tab6.
    wa_ldec-bzirk = wa_tab6-bzirk.
    wa_ldec-rm = wa_tab6-rm.
    wa_ldec-zm = wa_tab6-reg.
*    wa_ldec-dzm = wa_TAB6-dzm.
    select single * from zcumpso where zmonth eq '12' and zyear eq lyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_ldec-netval = zcumpso-netval.
      endif.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tab6-bzirk and trgyear eq lyear.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_ldec-tar = ysd_dist_targt-month09.
      endif.
    endif.
    collect wa_ldec into it_ldec.
    clear wa_ldec.
*    endif.
  endloop.
  clear : it_tad1,it_tad2,it_zdsmter_1.

******************JAN****************
  select * from zdsmter into table it_zdsmter_1 where zmonth eq '01' and zyear eq cyear.
  loop at it_zdsmter_1 into wa_zdsmter_1  where bzirk+0(2) cs 'R-' and zdsm in org.
    wa_tad1-rm = wa_zdsmter_1-bzirk.
    wa_tad1-zm = wa_zdsmter_1-zdsm.
    read table it_zdsmter_1 into wa_zdsmter_1 with key bzirk = wa_zdsmter_1-bzirk zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_tad1-dzm = wa_zdsmter_1-zdsm.
    endif.
    collect wa_tad1 into it_tad1.
    clear wa_tad1.
  endloop.
  clear : it_zdsmter_1.
  if it_tad1 is not initial.
    select * from zdsmter into table it_zdsmter_1 for all entries in it_tad1 where zmonth eq '01' and zyear eq cyear
      and zdsm eq it_tad1-rm.
  endif.
  loop at it_zdsmter_1 into wa_zdsmter_1.
    wa_tad2-bzirk = wa_zdsmter_1-bzirk.
    read table it_tad1 into wa_tad1 with key rm = wa_zdsmter_1-zdsm.
    if sy-subrc eq 0.
      wa_tad2-rm = wa_tad1-rm.
      wa_tad2-zm = wa_tad1-zm.
      wa_tad2-dzm = wa_tad1-dzm.
    endif.
    collect wa_tad2 into it_tad2.
    clear wa_tad2.
  endloop.
  sort it_tad2 by zm rm bzirk.
  delete adjacent duplicates from it_tad2 comparing bzirk.
  loop at it_tab6 into wa_tab6.
    wa_ljan-bzirk = wa_tab6-bzirk.
    wa_ljan-rm = wa_tab6-rm.
    wa_ljan-zm = wa_tab6-reg.
*    wa_ljan-dzm = wa_TAB6-dzm.
    select single * from zcumpso where zmonth eq '01' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_ljan-netval = zcumpso-netval.
      endif.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tab6-bzirk and trgyear eq lyear.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_ljan-tar = ysd_dist_targt-month10.
      endif.
    endif.
    collect wa_ljan into it_ljan.
    clear wa_ljan.
*    endif.
  endloop.
  clear : it_tad1,it_tad2,it_zdsmter_1.

****************FEB**************
  select * from zdsmter into table it_zdsmter_1 where zmonth eq '02' and zyear eq cyear.
  loop at it_zdsmter_1 into wa_zdsmter_1  where bzirk+0(2) cs 'R-' and zdsm in org.
    wa_tad1-rm = wa_zdsmter_1-bzirk.
    wa_tad1-zm = wa_zdsmter_1-zdsm.
    read table it_zdsmter_1 into wa_zdsmter_1 with key bzirk = wa_zdsmter_1-bzirk zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_tad1-dzm = wa_zdsmter_1-zdsm.
    endif.
    collect wa_tad1 into it_tad1.
    clear wa_tad1.
  endloop.
  clear : it_zdsmter_1.
  if it_tad1 is not initial.
    select * from zdsmter into table it_zdsmter_1 for all entries in it_tad1 where zmonth eq '02' and zyear eq cyear
      and zdsm eq it_tad1-rm.
  endif.
  loop at it_zdsmter_1 into wa_zdsmter_1.
    wa_tad2-bzirk = wa_zdsmter_1-bzirk.
    read table it_tad1 into wa_tad1 with key rm = wa_zdsmter_1-zdsm.
    if sy-subrc eq 0.
      wa_tad2-rm = wa_tad1-rm.
      wa_tad2-zm = wa_tad1-zm.
      wa_tad2-dzm = wa_tad1-dzm.
    endif.
    collect wa_tad2 into it_tad2.
    clear wa_tad2.
  endloop.
  sort it_tad2 by zm rm bzirk.
  delete adjacent duplicates from it_tad2 comparing bzirk.
  loop at it_tab6 into wa_tab6.
    wa_lfeb-bzirk = wa_tab6-bzirk.
    wa_lfeb-rm = wa_tab6-rm.
    wa_lfeb-zm = wa_tab6-reg.
*    wa_lfeb-dzm = wa_TAB6-dzm.
    select single * from zcumpso where zmonth eq '02' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_lfeb-netval = zcumpso-netval.
      endif.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tab6-bzirk and trgyear eq lyear.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_lfeb-tar = ysd_dist_targt-month11.
      endif.
    endif.
    collect wa_lfeb into it_lfeb.
    clear wa_lfeb.
*    endif.
  endloop.
  clear : it_tad1,it_tad2,it_zdsmter_1.
*********************MAR************
  select * from zdsmter into table it_zdsmter_1 where zmonth eq '03' and zyear eq cyear.
  loop at it_zdsmter_1 into wa_zdsmter_1  where bzirk+0(2) cs 'R-' and zdsm in org.
    wa_tad1-rm = wa_zdsmter_1-bzirk.
    wa_tad1-zm = wa_zdsmter_1-zdsm.
    read table it_zdsmter_1 into wa_zdsmter_1 with key bzirk = wa_zdsmter_1-bzirk zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_tad1-dzm = wa_zdsmter_1-zdsm.
    endif.
    collect wa_tad1 into it_tad1.
    clear wa_tad1.
  endloop.
  clear : it_zdsmter_1.
  if it_tad1 is not initial.
    select * from zdsmter into table it_zdsmter_1 for all entries in it_tad1 where zmonth eq '03' and zyear eq cyear
      and zdsm eq it_tad1-rm.
  endif.
  loop at it_zdsmter_1 into wa_zdsmter_1.
    wa_tad2-bzirk = wa_zdsmter_1-bzirk.
    read table it_tad1 into wa_tad1 with key rm = wa_zdsmter_1-zdsm.
    if sy-subrc eq 0.
      wa_tad2-rm = wa_tad1-rm.
      wa_tad2-zm = wa_tad1-zm.
      wa_tad2-dzm = wa_tad1-dzm.
    endif.
    collect wa_tad2 into it_tad2.
    clear wa_tad2.
  endloop.
  sort it_tad2 by zm rm bzirk.
  delete adjacent duplicates from it_tad2 comparing bzirk.
  loop at it_tab6 into wa_tab6.
    wa_lmar-bzirk = wa_tab6-bzirk.
    wa_lmar-rm = wa_tab6-rm.
    wa_lmar-zm = wa_tab6-reg.
*    wa_lmar-dzm = wa_TAB6-dzm.
    select single * from zcumpso where zmonth eq '03' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_lmar-netval = zcumpso-netval.
      endif.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tab6-bzirk and trgyear eq lyear.
    if sy-subrc eq 0.
      if chk_dt1 le date2.
        wa_lmar-tar = ysd_dist_targt-month12.
      endif.
    endif.
    collect wa_lmar into it_lmar.
    clear wa_lmar.
*    endif.
  endloop.
  clear : it_tad1,it_tad2,it_zdsmter_1.
*************************************


endform.                    "lsale

*&---------------------------------------------------------------------*
*&      Form  csale_zrcumpso
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form csale_zrcumpso.


*  WRITE : / 'CURRENT YEAR',CYEAR.

  loop at it_tab6 into wa_tab6.
    clear : lls.
*    WRITE : / 'LAST TO LAST YEAR', wa_TAB6-bzirk.
*    WRITE : / 'chk_dt1',date1,date2,chk_dt1,chk_dt2,chk_dt3,chk_dt4,chk_dt5,chk_dt6,chk_dt7,chk_dt8,chk_dt9,chk_dt10,chk_dt11,chk_dt12.
    wa_cyr1-bzirk = wa_tab6-bzirk.
    if chk_dt1 le date2.
      select single * from zrcumpso where zmonth eq '04' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        wa_cyr1-m1 = zrcumpso-netval.
      endif.
    endif.
    if chk_dt2 le date2.
      select single * from zrcumpso where zmonth eq '05' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
*      WRITE : zrcumpso-NETVAL.
        wa_cyr1-m2 = zrcumpso-netval.
      endif.
    endif.
    if chk_dt3 le date2.
      select single * from zrcumpso where zmonth eq '06' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        wa_cyr1-m3 = zrcumpso-netval.
      endif.
    endif.
    if chk_dt4 le date2.
      select single * from zrcumpso where zmonth eq '07' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        wa_cyr1-m4 = zrcumpso-netval.
      endif.
    endif.
    if chk_dt5 le date2.
      select single * from zrcumpso where zmonth eq '08' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        wa_cyr1-m5 = zrcumpso-netval.
      endif.
    endif.
    if chk_dt6 le date2.
      select single * from zrcumpso where zmonth eq '09' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        wa_cyr1-m6 = zrcumpso-netval.
      endif.
    endif.
    if chk_dt7 le date2.
      select single * from zrcumpso where zmonth eq '10' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        wa_cyr1-m7 = zrcumpso-netval.
      endif.
    endif.
    if chk_dt8 le date2.
      select single * from zrcumpso where zmonth eq '11' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        wa_cyr1-m8 = zrcumpso-netval.
      endif.
    endif.
    if chk_dt9 le date2.
      select single * from zrcumpso where zmonth eq '12' and zyear eq cyear and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        wa_cyr1-m9 = zrcumpso-netval.
      endif.
    endif.
    if chk_dt10 le date2.
      select single * from zrcumpso where zmonth eq '01' and zyear eq ccyear and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        wa_cyr1-m10 = zrcumpso-netval.
      endif.
    endif.
    if chk_dt11 le date2.
      select single * from zrcumpso where zmonth eq '02' and zyear eq ccyear and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        wa_cyr1-m11 = zrcumpso-netval.
      endif.
    endif.
    if chk_dt12 le date2.
      select single * from zrcumpso where zmonth eq '03' and zyear eq ccyear and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        wa_cyr1-m12 = zrcumpso-netval.
      endif.
    endif.
    collect wa_cyr1 into it_cyr1.
    clear wa_cyr1.
  endloop.

  loop at it_cyr1 into wa_cyr1.
    clear : sale,qt1,qt2,qt3,qt4.
    wa_cyr2-bzirk = wa_cyr1-bzirk.
    sale = wa_cyr1-m1 + wa_cyr1-m2 + wa_cyr1-m3 + wa_cyr1-m4 + wa_cyr1-m5 + wa_cyr1-m6 + wa_cyr1-m7 + wa_cyr1-m8 + wa_cyr1-m9 + wa_cyr1-m10 + wa_cyr1-m11 +
            wa_cyr1-m12.
    wa_cyr2-cys = sale.
    collect wa_cyr2 into it_cyr2.
    clear wa_cyr2.
******************************************QUARTER*******
    wa_cqtr1-bzirk = wa_cyr1-bzirk.
    qt1 = wa_cyr1-m1 + wa_cyr1-m2 + wa_cyr1-m3.
    qt2 = wa_cyr1-m4 + wa_cyr1-m5 + wa_cyr1-m6.
    qt3 = wa_cyr1-m7 + wa_cyr1-m8 + wa_cyr1-m9.
    qt4 = wa_cyr1-m10 + wa_cyr1-m11 + wa_cyr1-m12.
    wa_cqtr1-qt1 = qt1.
    wa_cqtr1-qt2 = qt2.
    wa_cqtr1-qt3 = qt3.
    wa_cqtr1-qt4 = qt4.
    collect wa_cqtr1 into it_cqtr1.
    clear wa_cqtr1.
  endloop.
*  LOOP AT IT_CY2 INTO WA_CY2.
*    WRITE : / 'CURRENT YEAR SALE',WA_CY2-BZIRK,WA_CY2-CYS.
*  ENDLOOP.

  loop at it_cqt1 into wa_cqt1.  "QUARTER SALE
    clear : qt1,qt2,qt3,qt4.
*    WRITE : / 'CURRENT QRT SALE',WA_CQT1-BZIRK,WA_CQT1-QT1,WA_CQT1-QT2,WA_CQT1-QT3,WA_CQT1-QT4.
    read table it_cyqt1 into wa_cyqt1 with key bzirk = wa_cqt1-bzirk.
    if sy-subrc eq 0.
      if wa_cyqt1-qrt1 gt 0.
        qt1 = ( wa_cqt1-qt1 / wa_cyqt1-qrt1 ) * 100.
      endif.
      if wa_cyqt1-qrt2 gt 0.
        qt2 = ( wa_cqt1-qt2 / wa_cyqt1-qrt2 ) * 100.
      endif.
      if wa_cyqt1-qrt3 gt 0.
        qt3 = ( wa_cqt1-qt3 / wa_cyqt1-qrt3 ) * 100.
      endif.
      if wa_cyqt1-qrt4 gt 0.
        qt4 = ( wa_cqt1-qt4 / wa_cyqt1-qrt4 ) * 100.
      endif.
      wa_cys1-bzirk = wa_cqt1-bzirk.
      wa_cys1-qt1 = qt1.
      wa_cys1-qt2 = qt2.
      wa_cys1-qt3 = qt3.
      wa_cys1-qt4 = qt4.
      collect wa_cys1 into it_cys1.
      clear wa_cys1.
    endif.
  endloop.

*  LOOP AT IT_CYS1 INTO WA_CYS1.  "QUARTER SALE
*    WRITE : / 'CURRENT YEAR QUARTERLY SALE %',WA_CYS1-BZIRK,WA_CYS1-QT1,WA_CYS1-QT2,WA_CYS1-QT3,WA_CYS1-QT4.
*  ENDLOOP.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '-1'
      olddate = date1
    importing
      newdate = p1date.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '-2'
      olddate = date1
    importing
      newdate = p2date.

*  WRITE : / 'DATE1',DATE1,P1DATE,P2DATE.
  p1month = p1date+4(2).
  p1year = p1date+0(4).
  p2month = p2date+4(2).
  p2year = p2date+0(4).

*  WRITE : / 'LAST MONTH',P1MONTH,P1YEAR,P2MONTH,P2YEAR.

  loop at it_tab6 into wa_tab6.
    clear : csale,ctarget,cm,lsale,ltarget,lm,llsale,lltarget,llm.
    select single * from zrcumpso where zmonth eq month and zyear eq year and bzirk eq wa_tab6-bzirk and pso eq wa_tab6-pernr.
    if sy-subrc eq 0.
      csale = zrcumpso-netval.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tab6-bzirk and trgyear eq cyear.
    if month eq '04'.
      ctarget = ysd_dist_targt-month01.
    elseif month eq '05'.
      ctarget = ysd_dist_targt-month02.
    elseif month eq '06'.
      ctarget = ysd_dist_targt-month03.
    elseif month eq '07'.
      ctarget = ysd_dist_targt-month04.
    elseif month eq '08'.
      ctarget = ysd_dist_targt-month05.
    elseif month eq '09'.
      ctarget = ysd_dist_targt-month06.
    elseif month eq '10'.
      ctarget = ysd_dist_targt-month07.
    elseif month eq '11'.
      ctarget = ysd_dist_targt-month08.
    elseif month eq '12'.
      ctarget = ysd_dist_targt-month09.
    elseif month eq '01'.
      ctarget = ysd_dist_targt-month10.
    elseif month eq '02'.
      ctarget = ysd_dist_targt-month11.
    elseif month eq '03'.
      ctarget = ysd_dist_targt-month12.
    endif.

*****************LAST MONTH*************************

    select single * from zrcumpso where zmonth eq p1month and zyear eq p1year and bzirk eq wa_tab6-bzirk and pso eq wa_tab6-pernr.
    if sy-subrc eq 0.
      lsale = zrcumpso-netval.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tab6-bzirk and trgyear eq p1year.
    if p1month eq '04'.
      ltarget = ysd_dist_targt-month01.
    elseif p1month eq '05'.
      ltarget = ysd_dist_targt-month02.
    elseif p1month eq '06'.
      ltarget = ysd_dist_targt-month03.
    elseif p1month eq '07'.
      ltarget = ysd_dist_targt-month04.
    elseif p1month eq '08'.
      ltarget = ysd_dist_targt-month05.
    elseif p1month eq '09'.
      ltarget = ysd_dist_targt-month06.
    elseif p1month eq '10'.
      ltarget = ysd_dist_targt-month07.
    elseif p1month eq '11'.
      ltarget = ysd_dist_targt-month08.
    elseif p1month eq '12'.
      ltarget = ysd_dist_targt-month09.
    elseif p1month eq '01'.
      ltarget = ysd_dist_targt-month10.
    elseif p1month eq '02'.
      ltarget = ysd_dist_targt-month11.
    elseif p1month eq '03'.
      ltarget = ysd_dist_targt-month12.
    endif.

*********************LAST TO LAST MONTH ********************************
    select single * from zrcumpso where zmonth eq p2month and zyear eq p2year and bzirk eq wa_tab6-bzirk and pso eq wa_tab6-pernr.
    if sy-subrc eq 0.
      llsale = zrcumpso-netval.
    endif.
    select single * from ysd_dist_targt where bzirk eq wa_tab6-bzirk and trgyear eq p2year .
    if p2month eq '04'.
      lltarget = ysd_dist_targt-month01.
    elseif p2month eq '05'.
      lltarget = ysd_dist_targt-month02.
    elseif p2month eq '06'.
      lltarget = ysd_dist_targt-month03.
    elseif p2month eq '07'.
      lltarget = ysd_dist_targt-month04.
    elseif p2month eq '08'.
      lltarget = ysd_dist_targt-month05.
    elseif p2month eq '09'.
      lltarget = ysd_dist_targt-month06.
    elseif p2month eq '10'.
      lltarget = ysd_dist_targt-month07.
    elseif p2month eq '11'.
      lltarget = ysd_dist_targt-month08.
    elseif p2month eq '12'.
      lltarget = ysd_dist_targt-month09.
    elseif p2month eq '01'.
      lltarget = ysd_dist_targt-month10.
    elseif p2month eq '02'.
      lltarget = ysd_dist_targt-month11.
    elseif p2month eq '03'.
      lltarget = ysd_dist_targt-month12.
    endif.
***************************************************************************
    if ctarget gt 0.
      cm = ( csale / ctarget ) * 100.  "CURRENT MONTH SALE PERCENTAGE.
    endif.
    if ltarget gt 0.
      lm = ( lsale / ltarget ) * 100.  "LAST MONTH SALE PERCENTAGE.
    endif.
    if lltarget gt 0.
      llm = ( llsale / lltarget ) * 100.  "LAST TO LAST MONTH SALE PERCENTAGE.
    endif.
    wa_cms-bzirk = wa_tab6-bzirk.
    wa_cms-cms = cm.
    wa_cms-lms = lm.
    wa_cms-llms = llm.
    collect wa_cms into it_cms.
    clear wa_cms.
  endloop.
endform.                    "csale


*&---------------------------------------------------------------------*
*&      Form  CCUMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form ccumm.
*  WRITE : / 'CURRENT CUMMULATIVE',MONTH,YEAR,chk_dt1.
*  fmonth = '04'.
**  WRITE : / 'FINANCIAL YESR START FORM',FMONTH,CYEAR,DATE2.
*  fdate+06(2) = '01'.
*  fdate+4(2) = fmonth.
*  fdate+0(4) = cyear.
*
*
*  call function 'HR_JP_MONTH_BEGIN_END_DATE'
*               exporting
*               iv_date                   = fdate
*                importing
**                     EV_MONTH_BEGIN_DATE       =
*                   ev_month_end_date         = f1date.
*
********** start date of month/*********
*  call function 'RE_ADD_MONTH_TO_DATE'
*    EXPORTING
*      months  = '1'
*      olddate = fdate
*    IMPORTING
*      newdate = s2date.
*
*  call function 'RE_ADD_MONTH_TO_DATE'
*    EXPORTING
*      months  = '2'
*      olddate = fdate
*    IMPORTING
*      newdate = s3date.
*
*  call function 'RE_ADD_MONTH_TO_DATE'
*    EXPORTING
*      months  = '3'
*      olddate = fdate
*    IMPORTING
*      newdate = s4date.
*
*  call function 'RE_ADD_MONTH_TO_DATE'
*    EXPORTING
*      months  = '4'
*      olddate = fdate
*    IMPORTING
*      newdate = s5date.
*
*  call function 'RE_ADD_MONTH_TO_DATE'
*    EXPORTING
*      months  = '5'
*      olddate = fdate
*    IMPORTING
*      newdate = s6date.
*
*  call function 'RE_ADD_MONTH_TO_DATE'
*    EXPORTING
*      months  = '6'
*      olddate = fdate
*    IMPORTING
*      newdate = s7date.
*
*  call function 'RE_ADD_MONTH_TO_DATE'
*    EXPORTING
*      months  = '7'
*      olddate = fdate
*    IMPORTING
*      newdate = s8date.
*
*  call function 'RE_ADD_MONTH_TO_DATE'
*    EXPORTING
*      months  = '8'
*      olddate = fdate
*    IMPORTING
*      newdate = s9date.
*
*  call function 'RE_ADD_MONTH_TO_DATE'
*    EXPORTING
*      months  = '9'
*      olddate = fdate
*    IMPORTING
*      newdate = s10date.
*
*  call function 'RE_ADD_MONTH_TO_DATE'
*    EXPORTING
*      months  = '10'
*      olddate = fdate
*    IMPORTING
*      newdate = s11date.
*
*  call function 'RE_ADD_MONTH_TO_DATE'
*    EXPORTING
*      months  = '11'
*      olddate = fdate
*    IMPORTING
*      newdate = s12date.
*
***************** end of month***********
*
*  call function 'HR_JP_MONTH_BEGIN_END_DATE'
*              exporting
*              iv_date                   = s2date
*               importing
**                     EV_MONTH_BEGIN_DATE       =
*                  ev_month_end_date         = f2date.
*
*  call function 'HR_JP_MONTH_BEGIN_END_DATE'
*              exporting
*              iv_date                   = s3date
*               importing
**                     EV_MONTH_BEGIN_DATE       =
*                  ev_month_end_date         = f3date.
*
*  call function 'HR_JP_MONTH_BEGIN_END_DATE'
*             exporting
*             iv_date                   = s4date
*              importing
**                     EV_MONTH_BEGIN_DATE       =
*                 ev_month_end_date         = f4date.
*
*  call function 'HR_JP_MONTH_BEGIN_END_DATE'
*             exporting
*             iv_date                   = s5date
*              importing
**                     EV_MONTH_BEGIN_DATE       =
*                 ev_month_end_date         = f5date.
*
*  call function 'HR_JP_MONTH_BEGIN_END_DATE'
*             exporting
*             iv_date                   = s6date
*              importing
**                     EV_MONTH_BEGIN_DATE       =
*                 ev_month_end_date         = f6date.
*
*  call function 'HR_JP_MONTH_BEGIN_END_DATE'
*             exporting
*             iv_date                   = s7date
*              importing
**                     EV_MONTH_BEGIN_DATE       =
*                 ev_month_end_date         = f7date.
*
*  call function 'HR_JP_MONTH_BEGIN_END_DATE'
*             exporting
*             iv_date                   = s8date
*              importing
**                     EV_MONTH_BEGIN_DATE       =
*                 ev_month_end_date         = f8date.
*
*  call function 'HR_JP_MONTH_BEGIN_END_DATE'
*             exporting
*             iv_date                   = s9date
*              importing
**                     EV_MONTH_BEGIN_DATE       =
*                 ev_month_end_date         = f9date.
*
*  call function 'HR_JP_MONTH_BEGIN_END_DATE'
*             exporting
*             iv_date                   = s10date
*              importing
**                     EV_MONTH_BEGIN_DATE       =
*                 ev_month_end_date         = f10date.
*
*  call function 'HR_JP_MONTH_BEGIN_END_DATE'
*             exporting
*             iv_date                   = s11date
*              importing
**                     EV_MONTH_BEGIN_DATE       =
*                 ev_month_end_date         = f11date.
*
*  call function 'HR_JP_MONTH_BEGIN_END_DATE'
*             exporting
*             iv_date                   = s12date
*              importing
**                     EV_MONTH_BEGIN_DATE       =
*                 ev_month_end_date         = f12date.
*
**  WRITE : / 'CURRENT CUMMULATIVE',MONTH,YEAR,fdate,f1date.
*
*  WRITE : /'a',fdate,f1date,s2date,f2date,s3date,f3date.


*  WRITE : 'FI DATES',F1DATE, F2DATE, F3DATE,F4DATE,F5DATE, F6DATE, F7DATE, F8DATE, F9DATE, F10DATE, F11DATE, F12DATE.
  loop  at it_tab6 into wa_tab6.
    clear  : t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,cumm_sale.
*    WRITE : / f1date,date2.
    if f1date le date2.
      select single * from zcumpso where zmonth eq f1date+4(2) and zyear eq f1date+0(4) and bzirk eq wa_tab6-bzirk and pso eq wa_tab6-pernr.
*         AND pso eq wa_tab6-pernr.
      if sy-subrc eq 0.
        t1 = zcumpso-netval.
      endif.
    endif.
    if f2date le date2.
      select single * from zcumpso where zmonth eq f2date+4(2) and zyear eq f2date+0(4) and bzirk eq wa_tab6-bzirk and pso eq wa_tab6-pernr.
      if sy-subrc eq 0.
        t2 = zcumpso-netval.
      endif.
    endif.
    if f3date le date2.
      select single * from zcumpso where zmonth eq f3date+4(2) and zyear eq f3date+0(4) and bzirk eq wa_tab6-bzirk and pso eq wa_tab6-pernr.
      if sy-subrc eq 0.
        t3 = zcumpso-netval.
      endif.
    endif.

    if f4date le date2.
      select single * from zcumpso where zmonth eq f4date+4(2) and zyear eq f4date+0(4) and bzirk eq wa_tab6-bzirk and pso eq wa_tab6-pernr.
      if sy-subrc eq 0.
        t4 = zcumpso-netval.
      endif.
    endif.

    if f5date le date2.
      select single * from zcumpso where zmonth eq f5date+4(2) and zyear eq f5date+0(4) and bzirk eq wa_tab6-bzirk and pso eq wa_tab6-pernr.
      if sy-subrc eq 0.
        t5 = zcumpso-netval.
      endif.
    endif.

    if f6date le date2.
      select single * from zcumpso where zmonth eq f6date+4(2) and zyear eq f6date+0(4) and bzirk eq wa_tab6-bzirk and pso eq wa_tab6-pernr.
      if sy-subrc eq 0.
        t6 = zcumpso-netval.
      endif.
    endif.

    if f7date le date2.
      select single * from zcumpso where zmonth eq f7date+4(2) and zyear eq f7date+0(4) and bzirk eq wa_tab6-bzirk and pso eq wa_tab6-pernr.
      if sy-subrc eq 0.
        t7 = zcumpso-netval.
      endif.
    endif.

    if f8date le date2.
      select single * from zcumpso where zmonth eq f8date+4(2) and zyear eq f8date+0(4) and bzirk eq wa_tab6-bzirk and pso eq wa_tab6-pernr.
      if sy-subrc eq 0.
        t8 = zcumpso-netval.
      endif.
    endif.

    if f9date le date2.
      select single * from zcumpso where zmonth eq f9date+4(2) and zyear eq f9date+0(4) and bzirk eq wa_tab6-bzirk and pso eq wa_tab6-pernr.
      if sy-subrc eq 0.
        t9 = zcumpso-netval.
      endif.
    endif.

    if f10date le date2.
      select single * from zcumpso where zmonth eq f10date+4(2) and zyear eq f10date+0(4) and bzirk eq wa_tab6-bzirk and pso eq wa_tab6-pernr.
      if sy-subrc eq 0.
        t10 = zcumpso-netval.
      endif.
    endif.

    if f11date le date2.
      select single * from zcumpso where zmonth eq f11date+4(2) and zyear eq f11date+0(4) and bzirk eq wa_tab6-bzirk and pso eq wa_tab6-pernr.
      if sy-subrc eq 0.
        t11 = zcumpso-netval.
      endif.
    endif.

    if f12date le date2.
      select single * from zcumpso where zmonth eq f12date+4(2) and zyear eq f12date+0(4) and bzirk eq wa_tab6-bzirk and pso eq wa_tab6-pernr.
      if sy-subrc eq 0.
        t12 = zcumpso-netval.
      endif.
    endif.
    cumm_sale = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12.
    wa_cumms1-bzirk = wa_tab6-bzirk.
    wa_cumms1-ccumm_sale = cumm_sale.
    collect wa_cumms1 into it_cumms1.
    clear wa_cumms1.
  endloop.
*  LOOP at it_cumms1 INTO wa_cumms1.
*    WRITE : / 'current cummulative sale',wa_cumms1-bzirk,wa_cumms1-ccumm_sale.
*  ENDLOOP.

endform.                    "CCUMM



*&---------------------------------------------------------------------*
*&      Form  ccumms
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form ccumms.

  loop  at it_tab6 into wa_tab6.
    clear  : t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,cumm_sale.
*    WRITE : / f1date,date2.
    if f1date le date2.
      if wa_tab6-zmjoin_date le f1date.
        select single * from zcumpso where zmonth eq f1date+4(2) and zyear eq f1date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t1 = zcumpso-netval.
        endif.
      endif.
    endif.
    if f2date le date2.
      if wa_tab6-zmjoin_date le f2date.
        select single * from zcumpso where zmonth eq f2date+4(2) and zyear eq f2date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t2 = zcumpso-netval.
        endif.
      endif.
    endif.
    if f3date le date2.
      if wa_tab6-zmjoin_date le f3date.
        select single * from zcumpso where zmonth eq f3date+4(2) and zyear eq f3date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t3 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f4date le date2.
      if wa_tab6-zmjoin_date le f4date.
        select single * from zcumpso where zmonth eq f4date+4(2) and zyear eq f4date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t4 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f5date le date2.
      if wa_tab6-zmjoin_date le f5date.
        select single * from zcumpso where zmonth eq f5date+4(2) and zyear eq f5date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t5 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f6date le date2.
      if wa_tab6-zmjoin_date le f6date.
        select single * from zcumpso where zmonth eq f6date+4(2) and zyear eq f6date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t6 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f7date le date2.
      if wa_tab6-zmjoin_date le f7date.
        select single * from zcumpso where zmonth eq f7date+4(2) and zyear eq f7date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t7 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f8date le date2.
      if wa_tab6-zmjoin_date le f8date.
        select single * from zcumpso where zmonth eq f8date+4(2) and zyear eq f8date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t8 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f9date le date2.
      if wa_tab6-zmjoin_date le f9date.
        select single * from zcumpso where zmonth eq f9date+4(2) and zyear eq f9date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t9 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f10date le date2.
      if wa_tab6-zmjoin_date le f10date.
        select single * from zcumpso where zmonth eq f10date+4(2) and zyear eq f10date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t10 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f11date le date2.
      if wa_tab6-zmjoin_date le f11date.
        select single * from zcumpso where zmonth eq f11date+4(2) and zyear eq f11date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t11 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f12date le date2.
      if wa_tab6-zmjoin_date le f12date.
        select single * from zcumpso where zmonth eq f12date+4(2) and zyear eq f12date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t12 = zcumpso-netval.
        endif.
      endif.
    endif.
    cumm_sale = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12.
    wa_cumms2-bzirk = wa_tab6-bzirk.
    wa_cumms2-ccumm_sale = cumm_sale.
    collect wa_cumms2 into it_cumms2.
    clear wa_cumms2.
  endloop.
*  LOOP at it_cumms2 INTO wa_cumms2.
*    WRITE : / 'current cummulative sale',wa_cumms2-bzirk,wa_cumms2-ccumm_sale.
*  ENDLOOP.

endform.                    "CCUMMs


*&---------------------------------------------------------------------*
*&      Form  ccumms_zm
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form ccumms_zm.

  loop  at it_tab6 into wa_tab6.
    clear  : t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,cumm_sale.
*    WRITE : / f1date,date2.
    clear : join_date.
    select single * from pa0302 where pernr eq wa_tab6-zmpernr and massn eq '01'.
    if sy-subrc eq 0.
      join_date = pa0302-begda.
    endif.

    if f1date le date2.
      if wa_tab6-zmjoin_date le f1date.
        select single * from zcumpso where zmonth eq f1date+4(2) and zyear eq f1date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t1 = zcumpso-netval.
        endif.
      endif.
    endif.
    if f2date le date2.
      if wa_tab6-zmjoin_date le f2date.
        select single * from zcumpso where zmonth eq f2date+4(2) and zyear eq f2date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t2 = zcumpso-netval.
        endif.
      endif.
    endif.
    if f3date le date2.
      if wa_tab6-zmjoin_date le f3date.
        select single * from zcumpso where zmonth eq f3date+4(2) and zyear eq f3date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t3 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f4date le date2.
      if wa_tab6-zmjoin_date le f4date.
        select single * from zcumpso where zmonth eq f4date+4(2) and zyear eq f4date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t4 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f5date le date2.
      if wa_tab6-zmjoin_date le f5date.
        select single * from zcumpso where zmonth eq f5date+4(2) and zyear eq f5date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t5 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f6date le date2.
      if wa_tab6-zmjoin_date le f6date.
        select single * from zcumpso where zmonth eq f6date+4(2) and zyear eq f6date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t6 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f7date le date2.
      if wa_tab6-zmjoin_date le f7date.
        select single * from zcumpso where zmonth eq f7date+4(2) and zyear eq f7date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t7 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f8date le date2.
      if wa_tab6-zmjoin_date le f8date.
        select single * from zcumpso where zmonth eq f8date+4(2) and zyear eq f8date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t8 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f9date le date2.
      if wa_tab6-zmjoin_date le f9date.
        select single * from zcumpso where zmonth eq f9date+4(2) and zyear eq f9date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t9 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f10date le date2.
      if wa_tab6-zmjoin_date le f10date.
        select single * from zcumpso where zmonth eq f10date+4(2) and zyear eq f10date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t10 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f11date le date2.
      if wa_tab6-zmjoin_date le f11date.
        select single * from zcumpso where zmonth eq f11date+4(2) and zyear eq f11date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t11 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f12date le date2.
      if wa_tab6-zmjoin_date le f12date.
        select single * from zcumpso where zmonth eq f12date+4(2) and zyear eq f12date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t12 = zcumpso-netval.
        endif.
      endif.
    endif.
    cumm_sale = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12.
    wa_cumms2_zm-bzirk = wa_tab6-bzirk.
    wa_cumms2_zm-ccumm_sale = cumm_sale.
    collect wa_cumms2_zm into it_cumms2_zm.
    clear wa_cumms2_zm.
  endloop.
*  LOOP at it_cumms2 INTO wa_cumms2.
*    WRITE : / 'current cummulative sale',wa_cumms2-bzirk,wa_cumms2-ccumm_sale.
*  ENDLOOP.

endform.                    "CCUMMs




*&---------------------------------------------------------------------*
*&      Form  ccumms_dzm
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form ccumms_dzm.

  loop  at it_tab6 into wa_tab6.
    clear  : t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,cumm_sale.
*    WRITE : / f1date,date2.
    clear : join_date.
    select single * from pa0302 where pernr eq wa_tab6-dzmpernr and massn eq '01'.
    if sy-subrc eq 0.
      join_date = pa0302-begda.
    endif.

    if f1date le date2.
      if wa_tab6-zmjoin_date le f1date.
        select single * from zcumpso where zmonth eq f1date+4(2) and zyear eq f1date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t1 = zcumpso-netval.
        endif.
      endif.
    endif.
    if f2date le date2.
      if wa_tab6-zmjoin_date le f2date.
        select single * from zcumpso where zmonth eq f2date+4(2) and zyear eq f2date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t2 = zcumpso-netval.
        endif.
      endif.
    endif.
    if f3date le date2.
      if wa_tab6-zmjoin_date le f3date.
        select single * from zcumpso where zmonth eq f3date+4(2) and zyear eq f3date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t3 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f4date le date2.
      if wa_tab6-zmjoin_date le f4date.
        select single * from zcumpso where zmonth eq f4date+4(2) and zyear eq f4date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t4 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f5date le date2.
      if wa_tab6-zmjoin_date le f5date.
        select single * from zcumpso where zmonth eq f5date+4(2) and zyear eq f5date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t5 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f6date le date2.
      if wa_tab6-zmjoin_date le f6date.
        select single * from zcumpso where zmonth eq f6date+4(2) and zyear eq f6date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t6 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f7date le date2.
      if wa_tab6-zmjoin_date le f7date.
        select single * from zcumpso where zmonth eq f7date+4(2) and zyear eq f7date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t7 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f8date le date2.
      if wa_tab6-zmjoin_date le f8date.
        select single * from zcumpso where zmonth eq f8date+4(2) and zyear eq f8date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t8 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f9date le date2.
      if wa_tab6-zmjoin_date le f9date.
        select single * from zcumpso where zmonth eq f9date+4(2) and zyear eq f9date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t9 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f10date le date2.
      if wa_tab6-zmjoin_date le f10date.
        select single * from zcumpso where zmonth eq f10date+4(2) and zyear eq f10date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t10 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f11date le date2.
      if wa_tab6-zmjoin_date le f11date.
        select single * from zcumpso where zmonth eq f11date+4(2) and zyear eq f11date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t11 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f12date le date2.
      if wa_tab6-zmjoin_date le f12date.
        select single * from zcumpso where zmonth eq f12date+4(2) and zyear eq f12date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t12 = zcumpso-netval.
        endif.
      endif.
    endif.
    cumm_sale = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12.
    wa_cumms2_dzm-bzirk = wa_tab6-bzirk.
    wa_cumms2_dzm-ccumm_sale = cumm_sale.
    collect wa_cumms2_dzm into it_cumms2_dzm.
    clear wa_cumms2_dzm.
  endloop.
*  LOOP at it_cumms2 INTO wa_cumms2.
*    WRITE : / 'current cummulative sale',wa_cumms2-bzirk,wa_cumms2-ccumm_sale.
*  ENDLOOP.

endform.                    "CCUMMs
*&---------------------------------------------------------------------*
*&      Form  ccumms_rm
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form ccumms_rm.

  loop  at it_tab6 into wa_tab6.
    clear  : t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,cumm_sale.
*    WRITE : / f1date,date2.
    clear : join_date.
    select single * from pa0302 where pernr eq wa_tab6-rmpernr and massn eq '01'.
    if sy-subrc eq 0.
      join_date = pa0302-begda.
    endif.

    if f1date le date2.
      if join_date le f1date.
        select single * from zcumpso where zmonth eq f1date+4(2) and zyear eq f1date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t1 = zcumpso-netval.
        endif.
      endif.
    endif.
    if f2date le date2.
      if join_date le f2date.
        select single * from zcumpso where zmonth eq f2date+4(2) and zyear eq f2date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t2 = zcumpso-netval.
        endif.
      endif.
    endif.
    if f3date le date2.
      if join_date le f3date.
        select single * from zcumpso where zmonth eq f3date+4(2) and zyear eq f3date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t3 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f4date le date2.
      if join_date le f4date.
        select single * from zcumpso where zmonth eq f4date+4(2) and zyear eq f4date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t4 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f5date le date2.
      if join_date le f5date.
        select single * from zcumpso where zmonth eq f5date+4(2) and zyear eq f5date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t5 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f6date le date2.
      if join_date le f6date.
        select single * from zcumpso where zmonth eq f6date+4(2) and zyear eq f6date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t6 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f7date le date2.
      if join_date le f7date.
        select single * from zcumpso where zmonth eq f7date+4(2) and zyear eq f7date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t7 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f8date le date2.
      if join_date le f8date.
        select single * from zcumpso where zmonth eq f8date+4(2) and zyear eq f8date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t8 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f9date le date2.
      if join_date le f9date.
        select single * from zcumpso where zmonth eq f9date+4(2) and zyear eq f9date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t9 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f10date le date2.
      if join_date le f10date.
        select single * from zcumpso where zmonth eq f10date+4(2) and zyear eq f10date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t10 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f11date le date2.
      if join_date le f11date.
        select single * from zcumpso where zmonth eq f11date+4(2) and zyear eq f11date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t11 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f12date le date2.
      if join_date le f12date.
        select single * from zcumpso where zmonth eq f12date+4(2) and zyear eq f12date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t12 = zcumpso-netval.
        endif.
      endif.
    endif.
    cumm_sale = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12.
    wa_cumms2_rm-bzirk = wa_tab6-bzirk.
    wa_cumms2_rm-ccumm_sale = cumm_sale.
    collect wa_cumms2_rm into it_cumms2_rm.
    clear wa_cumms2_rm.
  endloop.
*  LOOP at it_cumms2 INTO wa_cumms2.
*    WRITE : / 'current cummulative sale RM',wa_cumms2-bzirk,wa_cumms2-ccumm_sale.
*  ENDLOOP.

endform.                    "CCUMMs

*&---------------------------------------------------------------------*
*&      Form  ccumms_pso
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form ccumms_pso.

  loop  at it_tab6 into wa_tab6.
    clear  : t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,cumm_sale.
*    WRITE : / f1date,date2.
    if f1date le date2.
      if wa_tab6-join_date le f1date.
        select single * from zcumpso where zmonth eq f1date+4(2) and zyear eq f1date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t1 = zcumpso-netval.
        endif.
      endif.
    endif.
    if f2date le date2.
      if wa_tab6-join_date le f2date.
        select single * from zcumpso where zmonth eq f2date+4(2) and zyear eq f2date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t2 = zcumpso-netval.
        endif.
      endif.
    endif.
    if f3date le date2.
      if wa_tab6-join_date le f3date.
        select single * from zcumpso where zmonth eq f3date+4(2) and zyear eq f3date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t3 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f4date le date2.
      if wa_tab6-join_date le f4date.
        select single * from zcumpso where zmonth eq f4date+4(2) and zyear eq f4date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t4 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f5date le date2.
      if wa_tab6-join_date le f5date.
        select single * from zcumpso where zmonth eq f5date+4(2) and zyear eq f5date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t5 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f6date le date2.
      if wa_tab6-join_date le f6date.
        select single * from zcumpso where zmonth eq f6date+4(2) and zyear eq f6date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t6 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f7date le date2.
      if wa_tab6-join_date le f7date.
        select single * from zcumpso where zmonth eq f7date+4(2) and zyear eq f7date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t7 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f8date le date2.
      if wa_tab6-join_date le f8date.
        select single * from zcumpso where zmonth eq f8date+4(2) and zyear eq f8date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t8 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f9date le date2.
      if wa_tab6-join_date le f9date.
        select single * from zcumpso where zmonth eq f9date+4(2) and zyear eq f9date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t9 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f10date le date2.
      if wa_tab6-join_date le f10date.
        select single * from zcumpso where zmonth eq f10date+4(2) and zyear eq f10date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t10 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f11date le date2.
      if wa_tab6-join_date le f11date.
        select single * from zcumpso where zmonth eq f11date+4(2) and zyear eq f11date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t11 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f12date le date2.
      if wa_tab6-join_date le f12date.
        select single * from zcumpso where zmonth eq f12date+4(2) and zyear eq f12date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t12 = zcumpso-netval.
        endif.
      endif.
    endif.
    cumm_sale = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12.
    wa_cumms2_pso-bzirk = wa_tab6-bzirk.
    wa_cumms2_pso-ccumm_sale = cumm_sale.
    collect wa_cumms2_pso into it_cumms2_pso.
    clear wa_cumms2_pso.
  endloop.
*  LOOP at it_cumms2 INTO wa_cumms2.
*    WRITE : / 'current cummulative sale',wa_cumms2-bzirk,wa_cumms2-ccumm_sale.
*  ENDLOOP.

endform.                    "CCUMMs



*&---------------------------------------------------------------------*
*&      Form  ccumms_ZRCUMPSO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form ccumms_zrcumpso.

  loop  at it_tab6 into wa_tab6.
    clear  : t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,cumm_sale.
*    WRITE : / f1date,date2.
    if f1date le date2.
      if wa_tab6-zmjoin_date le f1date.
        select single * from zrcumpso where zmonth eq f1date+4(2) and zyear eq f1date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t1 = zrcumpso-netval.
        endif.
      endif.
    endif.
    if f2date le date2.
      if wa_tab6-zmjoin_date le f2date.
        select single * from zrcumpso where zmonth eq f2date+4(2) and zyear eq f2date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t2 = zrcumpso-netval.
        endif.
      endif.
    endif.
    if f3date le date2.
      if wa_tab6-zmjoin_date le f3date.
        select single * from zrcumpso where zmonth eq f3date+4(2) and zyear eq f3date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t3 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f4date le date2.
      if wa_tab6-zmjoin_date le f4date.
        select single * from zrcumpso where zmonth eq f4date+4(2) and zyear eq f4date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t4 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f5date le date2.
      if wa_tab6-zmjoin_date le f5date.
        select single * from zrcumpso where zmonth eq f5date+4(2) and zyear eq f5date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t5 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f6date le date2.
      if wa_tab6-zmjoin_date le f6date.
        select single * from zrcumpso where zmonth eq f6date+4(2) and zyear eq f6date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t6 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f7date le date2.
      if wa_tab6-zmjoin_date le f7date.
        select single * from zrcumpso where zmonth eq f7date+4(2) and zyear eq f7date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t7 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f8date le date2.
      if wa_tab6-zmjoin_date le f8date.
        select single * from zrcumpso where zmonth eq f8date+4(2) and zyear eq f8date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t8 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f9date le date2.
      if wa_tab6-zmjoin_date le f9date.
        select single * from zrcumpso where zmonth eq f9date+4(2) and zyear eq f9date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t9 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f10date le date2.
      if wa_tab6-zmjoin_date le f10date.
        select single * from zrcumpso where zmonth eq f10date+4(2) and zyear eq f10date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t10 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f11date le date2.
      if wa_tab6-zmjoin_date le f11date.
        select single * from zrcumpso where zmonth eq f11date+4(2) and zyear eq f11date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t11 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f12date le date2.
      if wa_tab6-zmjoin_date le f12date.
        select single * from zrcumpso where zmonth eq f12date+4(2) and zyear eq f12date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t12 = zrcumpso-netval.
        endif.
      endif.
    endif.
    cumm_sale = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12.
    wa_cummsr2-bzirk = wa_tab6-bzirk.
    wa_cummsr2-ccumm_sale = cumm_sale.
    collect wa_cummsr2 into it_cummsr2.
    clear wa_cummsr2.
  endloop.
*  LOOP at it_cumms2 INTO wa_cumms2.
*    WRITE : / 'current cummulative sale',wa_cumms2-bzirk,wa_cumms2-ccumm_sale.
*  ENDLOOP.

endform.                    "CCUMMs_ZRCUMPSO


*&---------------------------------------------------------------------*
*&      Form  ccumms_zrcumpso_zm
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form ccumms_zrcumpso_zm.

  loop  at it_tab6 into wa_tab6.
    clear  : t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,cumm_sale.
*    WRITE : / f1date,date2.

    clear : join_date.
    select single * from pa0302 where pernr eq wa_tab6-zmpernr and massn eq '01'.
    if sy-subrc eq 0.
      join_date = pa0302-begda.
    endif.

    if f1date le date2.
      if join_date le f1date.
        select single * from zrcumpso where zmonth eq f1date+4(2) and zyear eq f1date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t1 = zrcumpso-netval.
        endif.
      endif.
    endif.
    if f2date le date2.
      if join_date le f2date.
        select single * from zrcumpso where zmonth eq f2date+4(2) and zyear eq f2date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t2 = zrcumpso-netval.
        endif.
      endif.
    endif.
    if f3date le date2.
      if join_date le f3date.
        select single * from zrcumpso where zmonth eq f3date+4(2) and zyear eq f3date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t3 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f4date le date2.
      if join_date le f4date.
        select single * from zrcumpso where zmonth eq f4date+4(2) and zyear eq f4date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t4 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f5date le date2.
      if join_date le f5date.
        select single * from zrcumpso where zmonth eq f5date+4(2) and zyear eq f5date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t5 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f6date le date2.
      if join_date le f6date.
        select single * from zrcumpso where zmonth eq f6date+4(2) and zyear eq f6date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t6 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f7date le date2.
      if join_date le f7date.
        select single * from zrcumpso where zmonth eq f7date+4(2) and zyear eq f7date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t7 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f8date le date2.
      if join_date le f8date.
        select single * from zrcumpso where zmonth eq f8date+4(2) and zyear eq f8date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t8 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f9date le date2.
      if join_date le f9date.
        select single * from zrcumpso where zmonth eq f9date+4(2) and zyear eq f9date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t9 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f10date le date2.
      if join_date le f10date.
        select single * from zrcumpso where zmonth eq f10date+4(2) and zyear eq f10date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t10 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f11date le date2.
      if join_date le f11date.
        select single * from zrcumpso where zmonth eq f11date+4(2) and zyear eq f11date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t11 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f12date le date2.
      if join_date le f12date.
        select single * from zrcumpso where zmonth eq f12date+4(2) and zyear eq f12date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t12 = zrcumpso-netval.
        endif.
      endif.
    endif.
    cumm_sale = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12.
    wa_cummsr2_zm-bzirk = wa_tab6-bzirk.
    wa_cummsr2_zm-ccumm_sale = cumm_sale.
    collect wa_cummsr2_zm into it_cummsr2_zm.
    clear wa_cummsr2_zm.
  endloop.
*  LOOP at it_cumms2 INTO wa_cumms2.
*    WRITE : / 'current cummulative sale',wa_cumms2-bzirk,wa_cumms2-ccumm_sale.
*  ENDLOOP.

*************************  new logic for cummulative*****************

************APR*************************
*  CLEAR : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1,it_l2,wa_l2.
*  SELECT * FROM zdsmter INTO TABLE it_zdsmter_l1 WHERE zdsm IN org AND zmonth EQ f1date+4(2) AND zyear EQ f1date+0(4).
*  IF sy-subrc EQ 0.
*    SELECT * FROM zdsmter INTO TABLE it_zdsmter_l2 FOR ALL ENTRIES IN it_zdsmter_l1 WHERE zdsm EQ it_zdsmter_l1-bzirk AND
*      zmonth EQ f1date+4(2) AND zyear EQ f1date+0(4).
*  ENDIF.
*  LOOP AT it_zdsmter_l2 INTO wa_zdsmter_l2.
*    wa_l1-zmonth = wa_zdsmter_l2-zmonth.
*    wa_l2-zyear = wa_zdsmter_l2-zyear.
*    wa_l2-bzirk = wa_zdsmter_l2-bzirk.
*    wa_l2-rm = wa_zdsmter_l2-zdsm.
*    READ TABLE it_zdsmter_l1 INTO wa_zdsmter_l1 WITH KEY bzirk = wa_zdsmter_l2-zdsm.
*    IF sy-subrc EQ 0.
*      wa_l2-zdsm = wa_zdsmter_l1-zdsm.
*      SELECT SINGLE * FROM yterrallc WHERE bzirk EQ wa_l2-zdsm AND endda GE date2.
*    ENDIF.
*    SELECT SINGLE * FROM yterrallc WHERE bzirk EQ wa_l2-bzirk AND endda GE date2.
*    IF sy-subrc EQ 0.
*      SELECT SINGLE * FROM pa0001 WHERE plans EQ yterrallc-plans AND endda GE date2.
*      IF sy-subrc EQ 0.
*        SELECT SINGLE * FROM pa0302 WHERE pernr EQ pa0001-pernr AND massn EQ '01'.
*        IF sy-subrc EQ 0.
*          wa_l2-join_date = pa0302-begda.
*        ENDIF.
*      ENDIF.
*    ENDIF.
*
*    COLLECT wa_l2 INTO it_l2.
*    CLEAR wa_l2.
*  ENDLOOP.


  clear : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1,it_l2,wa_l2.
  select * from zdsmter into table it_zdsmter_l1 where zdsm in org and zmonth eq f1date+4(2) and zyear eq f1date+0(4).
  if sy-subrc eq 0.
    select * from zdsmter into table it_zdsmter_l2 for all entries in it_zdsmter_l1 where zdsm eq it_zdsmter_l1-bzirk and
      zmonth eq f1date+4(2) and zyear eq f1date+0(4).
  endif.
  loop at it_zdsmter_l2 into wa_zdsmter_l2 where zdsm+0(2) eq 'R-'.
    wa_l2-zmonth = wa_zdsmter_l2-zmonth.
    wa_l2-zyear = wa_zdsmter_l2-zyear.
    wa_l2-bzirk = wa_zdsmter_l2-bzirk.
    wa_l2-rm = wa_zdsmter_l2-zdsm.
    read table it_zdsmter_l2 into wa_zdsmter_l2 with key bzirk = wa_zdsmter_l2-zdsm zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_l2-zm = wa_zdsmter_l2-zdsm.
    endif.
    read table it_zdsmter_l1 into wa_zdsmter_l1 with key bzirk = wa_zdsmter_l2-zdsm.
    if sy-subrc eq 0.
      wa_l2-zdsm = wa_zdsmter_l1-zdsm.
    endif.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge date2.
    if sy-subrc eq 0.
      select single * from pa0001 where plans eq yterrallc-plans and endda ge date2.
      if sy-subrc eq 0.
        select single * from pa0302 where pernr eq pa0001-pernr and massn eq '01'.
        if sy-subrc eq 0.
          wa_l2-join_date = pa0302-begda.
        endif.
      endif.
    endif.
    collect wa_l2 into it_l2.
    clear wa_l2.
  endloop.

  loop at it_l2 into wa_l2.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge f1date.
    if sy-subrc eq 0.
      select single * from zrcumpso where zmonth eq ly_dt1+4(2) and zyear eq ly_dt1+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_l1aprcs1-bzirk =  wa_l2-bzirk.
        wa_l1aprcs1-aprsale =  zrcumpso-netval.
        wa_l1aprcs1-zdsm = wa_l2-zdsm.
        wa_l1aprcs1-rm = wa_l2-rm.
        wa_l1aprcs1-zm = wa_l2-zm.
        collect wa_l1aprcs1 into it_l1aprcs1.
        clear wa_l1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
      if sy-subrc eq 0.
        wa_l1taprcs1-bzirk =  wa_l2-bzirk.
        wa_l1taprcs1-aprsale =  ysd_dist_targt-month01.
        wa_l1taprcs1-zdsm = wa_l2-zdsm.
        wa_l1taprcs1-rm = wa_l2-rm.
        wa_l1taprcs1-zm = wa_l2-zm.
        collect wa_l1taprcs1 into it_l1taprcs1.
        clear wa_l1taprcs1.
      endif.


      if f1date le date2.
*      IF wa_l2-zjoin_date LE f1date.
*        SELECT SINGLE * FROM ZRCUMPSO WHERE ZMONTH EQ F1DATE+4(2) AND ZYEAR EQ F1DATE+0(4) AND BZIRK EQ WA_L2-BZIRK.  "30.5.2019
*        IF SY-SUBRC EQ 0.
*          WA_APRCS1-BZIRK =  WA_L2-BZIRK.
*          WA_APRCS1-APRSALE =  ZRCUMPSO-NETVAL.
*          WA_APRCS1-ZDSM = WA_L2-ZDSM.
*          WA_APRCS1-RM = WA_L2-RM.
*          WA_APRCS1-ZM = WA_L2-ZM.
*          COLLECT WA_APRCS1 INTO IT_APRCS1.
*          CLEAR WA_APRCS1.
*        ENDIF.
        select single * from zcumpso where zmonth eq f1date+4(2) and zyear eq f1date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_aprcs1-bzirk =  wa_l2-bzirk.
          wa_aprcs1-aprsale =  zcumpso-netval.
          wa_aprcs1-zdsm = wa_l2-zdsm.
          wa_aprcs1-rm = wa_l2-rm.
          wa_aprcs1-zm = wa_l2-zm.
          collect wa_aprcs1 into it_aprcs1.
          clear wa_aprcs1.
        endif.
        select single * from zrcumpso where zmonth eq ly_dt1+4(2) and zyear eq ly_dt1+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_laprcs1-bzirk =  wa_l2-bzirk.
          wa_laprcs1-aprsale =  zrcumpso-netval.
          wa_laprcs1-zdsm = wa_l2-zdsm.
          wa_laprcs1-rm = wa_l2-rm.
          wa_laprcs1-zm = wa_l2-zm.
          collect wa_laprcs1 into it_laprcs1.
          clear wa_laprcs1.
        endif.
        select single * from zcumpso where zmonth eq f1date+4(2) and zyear eq f1date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_caprcs1-bzirk =  wa_l2-bzirk.
          wa_caprcs1-aprsale =  zcumpso-netval.
          wa_caprcs1-zdsm = wa_l2-zdsm.
          wa_caprcs1-rm = wa_l2-rm.
          wa_caprcs1-zm = wa_l2-zm.
          collect wa_caprcs1 into it_caprcs1.
          clear wa_caprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
        if sy-subrc eq 0.
          wa_taprcs1-bzirk =  wa_l2-bzirk.
          wa_taprcs1-aprsale =  ysd_dist_targt-month01.
          wa_taprcs1-zdsm = wa_l2-zdsm.
          wa_taprcs1-rm = wa_l2-rm.
          wa_taprcs1-zm = wa_l2-zm.
          collect wa_taprcs1 into it_taprcs1.
          clear wa_taprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
        if sy-subrc eq 0.
          wa_ltaprcs1-bzirk =  wa_l2-bzirk.
          wa_ltaprcs1-aprsale =  ysd_dist_targt-month01.
          wa_ltaprcs1-zdsm = wa_l2-zdsm.
          wa_ltaprcs1-rm = wa_l2-rm.
          wa_ltaprcs1-zm = wa_l2-zm.
          collect wa_ltaprcs1 into it_ltaprcs1.
          clear wa_ltaprcs1.
        endif.

*      ENDIF.
      endif.

      if f1date le date2.
*      IF wa_l2-rjoin_date LE f1date.
        select single * from zrcumpso where zmonth eq f1date+4(2) and zyear eq f1date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_raprcs1-bzirk =  wa_l2-bzirk.
          wa_raprcs1-aprsale =  zrcumpso-netval.
          wa_raprcs1-zdsm = wa_l2-zdsm.
          wa_raprcs1-rm = wa_l2-rm.
          wa_raprcs1-zm = wa_l2-zm.
          collect wa_raprcs1 into it_raprcs1.
          clear wa_raprcs1.
        endif.
        select single * from zrcumpso where zmonth eq ly_dt1+4(2) and zyear eq ly_dt1+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_rlaprcs1-bzirk =  wa_l2-bzirk.
          wa_rlaprcs1-aprsale =  zrcumpso-netval.
          wa_rlaprcs1-zdsm = wa_l2-zdsm.
          wa_rlaprcs1-rm = wa_l2-rm.
          wa_rlaprcs1-zm = wa_l2-zm.
          collect wa_rlaprcs1 into it_rlaprcs1.
          clear wa_rlaprcs1.
        endif.
        select single * from zcumpso where zmonth eq f1date+4(2) and zyear eq f1date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_rcaprcs1-bzirk =  wa_l2-bzirk.
          wa_rcaprcs1-aprsale =  zcumpso-netval.
          wa_rcaprcs1-zdsm = wa_l2-zdsm.
          wa_rcaprcs1-rm = wa_l2-rm.
          wa_rcaprcs1-zm = wa_l2-zm.
          collect wa_rcaprcs1 into it_rcaprcs1.
          clear wa_rcaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
        if sy-subrc eq 0.
          wa_rtaprcs1-bzirk =  wa_l2-bzirk.
          wa_rtaprcs1-aprsale =  ysd_dist_targt-month01.
          wa_rtaprcs1-zdsm = wa_l2-zdsm.
          wa_rtaprcs1-rm = wa_l2-rm.
          wa_rtaprcs1-zm = wa_l2-zm.
          collect wa_rtaprcs1 into it_rtaprcs1.
          clear wa_rtaprcs1.
        endif.

*      ENDIF.
      endif.

      if f1date le date2.
        if wa_l2-join_date le f1date.
          select single * from zrcumpso where zmonth eq f1date+4(2) and zyear eq f1date+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_paprcs1-bzirk =  wa_l2-bzirk.
            wa_paprcs1-aprsale =  zrcumpso-netval.
            wa_paprcs1-zdsm = wa_l2-zdsm.
            wa_paprcs1-rm = wa_l2-rm.
            wa_paprcs1-zm = wa_l2-zm.
            collect wa_paprcs1 into it_paprcs1.
            clear wa_paprcs1.
          endif.
          select single * from zrcumpso where zmonth eq ly_dt1+4(2) and zyear eq ly_dt1+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_plaprcs1-bzirk =  wa_l2-bzirk.
            wa_plaprcs1-aprsale =  zrcumpso-netval.
            wa_plaprcs1-zdsm = wa_l2-zdsm.
            wa_plaprcs1-rm = wa_l2-rm.
            wa_plaprcs1-zm = wa_l2-zm.
            collect wa_plaprcs1 into it_plaprcs1.
            clear wa_plaprcs1.
          endif.
          select single * from zcumpso where zmonth eq f1date+4(2) and zyear eq f1date+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_pcaprcs1-bzirk =  wa_l2-bzirk.
            wa_pcaprcs1-aprsale =  zcumpso-netval.
            wa_pcaprcs1-zdsm = wa_l2-zdsm.
            wa_pcaprcs1-rm = wa_l2-rm.
            wa_pcaprcs1-zm = wa_l2-zm.
            collect wa_pcaprcs1 into it_pcaprcs1.
            clear wa_pcaprcs1.
          endif.
          select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
          if sy-subrc eq 0.
            wa_ptaprcs1-bzirk =  wa_l2-bzirk.
            wa_ptaprcs1-aprsale =  ysd_dist_targt-month01.
            wa_ptaprcs1-zdsm = wa_l2-zdsm.
            wa_ptaprcs1-rm = wa_l2-rm.
            wa_ptaprcs1-zm = wa_l2-zm.
            collect wa_ptaprcs1 into it_ptaprcs1.
            clear wa_ptaprcs1.
          endif.

        endif.
      endif.
    endif.
  endloop.

************ MAY *************************
*  CLEAR : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1,it_l2,wa_l2.
*  SELECT * FROM zdsmter INTO TABLE it_zdsmter_l1 WHERE zdsm IN org AND zmonth EQ f2date+4(2) AND zyear EQ f2date+0(4).
*  IF sy-subrc EQ 0.
*    SELECT * FROM zdsmter INTO TABLE it_zdsmter_l2 FOR ALL ENTRIES IN it_zdsmter_l1 WHERE zdsm EQ it_zdsmter_l1-bzirk AND
*      zmonth EQ f2date+4(2) AND zyear EQ f2date+0(4).
*  ENDIF.
*  LOOP AT it_zdsmter_l2 INTO wa_zdsmter_l2.
*    wa_l1-zmonth = wa_zdsmter_l2-zmonth.
*    wa_l2-zyear = wa_zdsmter_l2-zyear.
*    wa_l2-bzirk = wa_zdsmter_l2-bzirk.
*    wa_l2-rm = wa_zdsmter_l2-zdsm.
*    READ TABLE it_zdsmter_l1 INTO wa_zdsmter_l1 WITH KEY bzirk = wa_zdsmter_l2-zdsm.
*    IF sy-subrc EQ 0.
*      wa_l2-zdsm = wa_zdsmter_l1-zdsm.
*    ENDIF.
*    SELECT SINGLE * FROM yterrallc WHERE bzirk EQ wa_l2-bzirk AND endda GE date2.
*    IF sy-subrc EQ 0.
*      SELECT SINGLE * FROM pa0001 WHERE plans EQ yterrallc-plans AND endda GE date2.
*      IF sy-subrc EQ 0.
*        SELECT SINGLE * FROM pa0302 WHERE pernr EQ pa0001-pernr AND massn EQ '01'.
*        IF sy-subrc EQ 0.
*          wa_l2-join_date = pa0302-begda.
*        ENDIF.
*      ENDIF.
*    ENDIF.
*    COLLECT wa_l2 INTO it_l2.
*    CLEAR wa_l2.
*  ENDLOOP.

  clear : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1,it_l2,wa_l2.
  select * from zdsmter into table it_zdsmter_l1 where zdsm in org and zmonth eq f2date+4(2) and zyear eq f2date+0(4).
  if sy-subrc eq 0.
    select * from zdsmter into table it_zdsmter_l2 for all entries in it_zdsmter_l1 where zdsm eq it_zdsmter_l1-bzirk and
      zmonth eq f2date+4(2) and zyear eq f2date+0(4).
  endif.
  loop at it_zdsmter_l2 into wa_zdsmter_l2 where zdsm+0(2) eq 'R-'.
    wa_l2-zmonth = wa_zdsmter_l2-zmonth.
    wa_l2-zyear = wa_zdsmter_l2-zyear.
    wa_l2-bzirk = wa_zdsmter_l2-bzirk.
    wa_l2-rm = wa_zdsmter_l2-zdsm.
    read table it_zdsmter_l2 into wa_zdsmter_l2 with key bzirk = wa_zdsmter_l2-zdsm zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_l2-zm = wa_zdsmter_l2-zdsm.
    endif.
    read table it_zdsmter_l1 into wa_zdsmter_l1 with key bzirk = wa_zdsmter_l2-zdsm.
    if sy-subrc eq 0.
      wa_l2-zdsm = wa_zdsmter_l1-zdsm.
    endif.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge date2.
    if sy-subrc eq 0.
      select single * from pa0001 where plans eq yterrallc-plans and endda ge date2.
      if sy-subrc eq 0.
        select single * from pa0302 where pernr eq pa0001-pernr and massn eq '01'.
        if sy-subrc eq 0.
          wa_l2-join_date = pa0302-begda.
        endif.
      endif.
    endif.
    collect wa_l2 into it_l2.
    clear wa_l2.
  endloop.

  loop at it_l2 into wa_l2.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge f2date.
    if sy-subrc eq 0.
      select single * from zrcumpso where zmonth eq ly_dt2+4(2) and zyear eq ly_dt2+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_l1aprcs1-bzirk =  wa_l2-bzirk.
        wa_l1aprcs1-maysale =  zrcumpso-netval.
        wa_l1aprcs1-zdsm = wa_l2-zdsm.
        wa_l1aprcs1-rm = wa_l2-rm.
        wa_l1aprcs1-zm = wa_l2-zm.
        collect wa_l1aprcs1 into it_l1aprcs1.
        clear wa_l1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
      if sy-subrc eq 0.
        wa_l1taprcs1-bzirk =  wa_l2-bzirk.
        wa_l1taprcs1-maysale =  ysd_dist_targt-month02.
        wa_l1taprcs1-zdsm = wa_l2-zdsm.
        wa_l1taprcs1-rm = wa_l2-rm.
        wa_l1taprcs1-zm = wa_l2-zm.
        collect wa_l1taprcs1 into it_l1taprcs1.
        clear wa_l1taprcs1.
      endif.

      if f2date le date2.
*      IF wa_l2-zjoin_date LE f2date.
        select single * from zcumpso where zmonth eq f2date+4(2) and zyear eq f2date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_aprcs1-bzirk =  wa_l2-bzirk.
          wa_aprcs1-maysale =  zcumpso-netval.
          wa_aprcs1-zdsm = wa_l2-zdsm.
          wa_aprcs1-rm = wa_l2-rm.
          wa_aprcs1-zm = wa_l2-zm.
          collect wa_aprcs1 into it_aprcs1.
          clear wa_aprcs1.
        endif.
        select single * from zrcumpso where zmonth eq ly_dt2+4(2) and zyear eq ly_dt2+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_laprcs1-bzirk =  wa_l2-bzirk.
          wa_laprcs1-maysale =  zrcumpso-netval.
          wa_laprcs1-zdsm = wa_l2-zdsm.
          wa_laprcs1-rm = wa_l2-rm.
          wa_laprcs1-zm = wa_l2-zm.
          collect wa_laprcs1 into it_laprcs1.
          clear wa_laprcs1.
        endif.

        select single * from zcumpso where zmonth eq f2date+4(2) and zyear eq f2date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_caprcs1-bzirk =  wa_l2-bzirk.
          wa_caprcs1-maysale =  zcumpso-netval.
          wa_caprcs1-zdsm = wa_l2-zdsm.
          wa_caprcs1-rm = wa_l2-rm.
          wa_caprcs1-zm = wa_l2-zm.
          collect wa_caprcs1 into it_caprcs1.
          clear wa_caprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
        if sy-subrc eq 0.
          wa_taprcs1-bzirk =  wa_l2-bzirk.
          wa_taprcs1-maysale =  ysd_dist_targt-month02.
          wa_taprcs1-zdsm = wa_l2-zdsm.
          wa_taprcs1-rm = wa_l2-rm.
          wa_taprcs1-zm = wa_l2-zm.
          collect wa_taprcs1 into it_taprcs1.
          clear wa_taprcs1.
        endif.

*      ENDIF.
      endif.

      if f2date le date2.
*      IF wa_l2-rjoin_date LE f2date.
        select single * from zrcumpso where zmonth eq f2date+4(2) and zyear eq f2date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_raprcs1-bzirk =  wa_l2-bzirk.
          wa_raprcs1-maysale =  zrcumpso-netval.
          wa_raprcs1-zdsm = wa_l2-zdsm.
          wa_raprcs1-rm = wa_l2-rm.
          wa_raprcs1-zm = wa_l2-zm.
          collect wa_raprcs1 into it_raprcs1.
          clear wa_raprcs1.
        endif.
        select single * from zrcumpso where zmonth eq ly_dt2+4(2) and zyear eq ly_dt2+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_rlaprcs1-bzirk =  wa_l2-bzirk.
          wa_rlaprcs1-maysale =  zrcumpso-netval.
          wa_rlaprcs1-zdsm = wa_l2-zdsm.
          wa_rlaprcs1-rm = wa_l2-rm.
          wa_rlaprcs1-zm = wa_l2-zm.
          collect wa_rlaprcs1 into it_rlaprcs1.
          clear wa_rlaprcs1.
        endif.
        select single * from zcumpso where zmonth eq f2date+4(2) and zyear eq f2date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_rcaprcs1-bzirk =  wa_l2-bzirk.
          wa_rcaprcs1-maysale =  zcumpso-netval.
          wa_rcaprcs1-zdsm = wa_l2-zdsm.
          wa_rcaprcs1-rm = wa_l2-rm.
          wa_rcaprcs1-zm = wa_l2-zm.
          collect wa_rcaprcs1 into it_rcaprcs1.
          clear wa_rcaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
        if sy-subrc eq 0.
          wa_rtaprcs1-bzirk =  wa_l2-bzirk.
          wa_rtaprcs1-maysale =  ysd_dist_targt-month02.
          wa_rtaprcs1-zdsm = wa_l2-zdsm.
          wa_rtaprcs1-rm = wa_l2-rm.
          wa_rtaprcs1-zm = wa_l2-zm.
          collect wa_rtaprcs1 into it_rtaprcs1.
          clear wa_rtaprcs1.
        endif.
*      ENDIF.
      endif.

      if f2date le date2.
        if wa_l2-join_date le f2date.
          select single * from zrcumpso where zmonth eq f2date+4(2) and zyear eq f2date+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_paprcs1-bzirk =  wa_l2-bzirk.
            wa_paprcs1-maysale =  zrcumpso-netval.
            wa_paprcs1-zdsm = wa_l2-zdsm.
            wa_paprcs1-rm = wa_l2-rm.
            wa_paprcs1-zm = wa_l2-zm.
            collect wa_paprcs1 into it_paprcs1.
            clear wa_paprcs1.
          endif.
          select single * from zrcumpso where zmonth eq ly_dt2+4(2) and zyear eq ly_dt2+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_plaprcs1-bzirk =  wa_l2-bzirk.
            wa_plaprcs1-maysale =  zrcumpso-netval.
            wa_plaprcs1-zdsm = wa_l2-zdsm.
            wa_plaprcs1-rm = wa_l2-rm.
            wa_plaprcs1-zm = wa_l2-zm.
            collect wa_plaprcs1 into it_plaprcs1.
            clear wa_plaprcs1.
          endif.
          select single * from zcumpso where zmonth eq f2date+4(2) and zyear eq f2date+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_pcaprcs1-bzirk =  wa_l2-bzirk.
            wa_pcaprcs1-maysale =  zcumpso-netval.
            wa_pcaprcs1-zdsm = wa_l2-zdsm.
            wa_pcaprcs1-rm = wa_l2-rm.
            wa_pcaprcs1-zm = wa_l2-zm.
            collect wa_pcaprcs1 into it_pcaprcs1.
            clear wa_pcaprcs1.
          endif.
          select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
          if sy-subrc eq 0.
            wa_ptaprcs1-bzirk =  wa_l2-bzirk.
            wa_ptaprcs1-maysale =  ysd_dist_targt-month02.
            wa_ptaprcs1-zdsm = wa_l2-zdsm.
            wa_ptaprcs1-rm = wa_l2-rm.
            wa_ptaprcs1-zm = wa_l2-zm.
            collect wa_ptaprcs1 into it_ptaprcs1.
            clear wa_ptaprcs1.
          endif.
        endif.
      endif.
    endif.
  endloop.


************ JUN *************************
  clear : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1,it_l2,wa_l2.
  select * from zdsmter into table it_zdsmter_l1 where zdsm in org and zmonth eq f3date+4(2) and zyear eq f3date+0(4).
  if sy-subrc eq 0.
    select * from zdsmter into table it_zdsmter_l2 for all entries in it_zdsmter_l1 where zdsm eq it_zdsmter_l1-bzirk and
      zmonth eq f3date+4(2) and zyear eq f3date+0(4).
  endif.
  loop at it_zdsmter_l2 into wa_zdsmter_l2 where zdsm+0(2) eq 'R-'.
    wa_l2-zmonth = wa_zdsmter_l2-zmonth.
    wa_l2-zyear = wa_zdsmter_l2-zyear.
    wa_l2-bzirk = wa_zdsmter_l2-bzirk.
    wa_l2-rm = wa_zdsmter_l2-zdsm.
    read table it_zdsmter_l2 into wa_zdsmter_l2 with key bzirk = wa_zdsmter_l2-zdsm zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_l2-zm = wa_zdsmter_l2-zdsm.
    endif.
    read table it_zdsmter_l1 into wa_zdsmter_l1 with key bzirk = wa_zdsmter_l2-zdsm.
    if sy-subrc eq 0.
      wa_l2-zdsm = wa_zdsmter_l1-zdsm.
    endif.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge date2.
    if sy-subrc eq 0.
      select single * from pa0001 where plans eq yterrallc-plans and endda ge date2.
      if sy-subrc eq 0.
        select single * from pa0302 where pernr eq pa0001-pernr and massn eq '01'.
        if sy-subrc eq 0.
          wa_l2-join_date = pa0302-begda.
        endif.
      endif.
    endif.
    collect wa_l2 into it_l2.
    clear wa_l2.
  endloop.

  loop at it_l2 into wa_l2.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge f3date.
    if sy-subrc eq 0.
      select single * from zrcumpso where zmonth eq ly_dt3+4(2) and zyear eq ly_dt3+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_l1aprcs1-bzirk =  wa_l2-bzirk.
        wa_l1aprcs1-junsale =  zrcumpso-netval.
        wa_l1aprcs1-zdsm = wa_l2-zdsm.
        wa_l1aprcs1-rm = wa_l2-rm.
        wa_l1aprcs1-zm = wa_l2-zm.
        collect wa_l1aprcs1 into it_l1aprcs1.
        clear wa_l1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
      if sy-subrc eq 0.
        wa_l1taprcs1-bzirk =  wa_l2-bzirk.
        wa_l1taprcs1-junsale =  ysd_dist_targt-month03.
        wa_l1taprcs1-zdsm = wa_l2-zdsm.
        wa_l1taprcs1-rm = wa_l2-rm.
        wa_l1taprcs1-zm = wa_l2-zm.
        collect wa_l1taprcs1 into it_l1taprcs1.
        clear wa_l1taprcs1.
      endif.
      if f3date le date2.
*      IF wa_l2-zjoin_date LE f3date.
        select single * from zcumpso where zmonth eq f3date+4(2) and zyear eq f3date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_aprcs1-bzirk =  wa_l2-bzirk.
          wa_aprcs1-junsale =  zcumpso-netval.
          wa_aprcs1-zdsm = wa_l2-zdsm.
          wa_aprcs1-rm = wa_l2-rm.
          wa_aprcs1-zm = wa_l2-zm.
          collect wa_aprcs1 into it_aprcs1.
          clear wa_aprcs1.
        endif.
        select single * from zrcumpso where zmonth eq ly_dt3+4(2) and zyear eq ly_dt3+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_laprcs1-bzirk =  wa_l2-bzirk.
          wa_laprcs1-junsale =  zrcumpso-netval.
          wa_laprcs1-zdsm = wa_l2-zdsm.
          wa_laprcs1-rm = wa_l2-rm.
          wa_laprcs1-zm = wa_l2-zm.
          collect wa_laprcs1 into it_laprcs1.
          clear wa_laprcs1.
        endif.

        select single * from zcumpso where zmonth eq f3date+4(2) and zyear eq f3date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_caprcs1-bzirk =  wa_l2-bzirk.
          wa_caprcs1-junsale =  zcumpso-netval.
          wa_caprcs1-zdsm = wa_l2-zdsm.
          wa_caprcs1-rm = wa_l2-rm.
          wa_caprcs1-zm = wa_l2-zm.
          collect wa_caprcs1 into it_caprcs1.
          clear wa_caprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
        if sy-subrc eq 0.
          wa_taprcs1-bzirk =  wa_l2-bzirk.
          wa_taprcs1-junsale =  ysd_dist_targt-month03.
          wa_taprcs1-zdsm = wa_l2-zdsm.
          wa_taprcs1-rm = wa_l2-rm.
          wa_taprcs1-zm = wa_l2-zm.
          collect wa_taprcs1 into it_taprcs1.
          clear wa_taprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
        if sy-subrc eq 0.
          wa_ltaprcs1-bzirk =  wa_l2-bzirk.
          wa_ltaprcs1-junsale =  ysd_dist_targt-month03.
          wa_ltaprcs1-zdsm = wa_l2-zdsm.
          wa_ltaprcs1-rm = wa_l2-rm.
          wa_ltaprcs1-zm = wa_l2-zm.
          collect wa_ltaprcs1 into it_ltaprcs1.
          clear wa_ltaprcs1.
        endif.
*      ENDIF.
      endif.

      if f3date le date2.
*      IF wa_l2-rjoin_date LE f3date.
        select single * from zrcumpso where zmonth eq f3date+4(2) and zyear eq f3date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_raprcs1-bzirk =  wa_l2-bzirk.
          wa_raprcs1-junsale =  zrcumpso-netval.
          wa_raprcs1-zdsm = wa_l2-zdsm.
          wa_raprcs1-rm = wa_l2-rm.
          wa_raprcs1-zm = wa_l2-zm.
          collect wa_raprcs1 into it_raprcs1.
          clear wa_raprcs1.
        endif.
        select single * from zrcumpso where zmonth eq ly_dt3+4(2) and zyear eq ly_dt3+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_rlaprcs1-bzirk =  wa_l2-bzirk.
          wa_rlaprcs1-junsale =  zrcumpso-netval.
          wa_rlaprcs1-zdsm = wa_l2-zdsm.
          wa_rlaprcs1-rm = wa_l2-rm.
          wa_rlaprcs1-zm = wa_l2-zm.
          collect wa_rlaprcs1 into it_rlaprcs1.
          clear wa_rlaprcs1.
        endif.
        select single * from zcumpso where zmonth eq f3date+4(2) and zyear eq f3date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_rcaprcs1-bzirk =  wa_l2-bzirk.
          wa_rcaprcs1-junsale =  zcumpso-netval.
          wa_rcaprcs1-zdsm = wa_l2-zdsm.
          wa_rcaprcs1-rm = wa_l2-rm.
          wa_rcaprcs1-zm = wa_l2-zm.
          collect wa_rcaprcs1 into it_rcaprcs1.
          clear wa_rcaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
        if sy-subrc eq 0.
          wa_rtaprcs1-bzirk =  wa_l2-bzirk.
          wa_rtaprcs1-junsale =  ysd_dist_targt-month03.
          wa_rtaprcs1-zdsm = wa_l2-zdsm.
          wa_rtaprcs1-rm = wa_l2-rm.
          wa_rtaprcs1-zm = wa_l2-zm.
          collect wa_rtaprcs1 into it_rtaprcs1.
          clear wa_rtaprcs1.
        endif.
*      ENDIF.
      endif.

      if f3date le date2.
        if wa_l2-join_date le f3date.
          select single * from zrcumpso where zmonth eq f3date+4(2) and zyear eq f3date+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_paprcs1-bzirk =  wa_l2-bzirk.
            wa_paprcs1-junsale =  zrcumpso-netval.
            wa_paprcs1-zdsm = wa_l2-zdsm.
            wa_paprcs1-rm = wa_l2-rm.
            wa_paprcs1-zm = wa_l2-zm.
            collect wa_paprcs1 into it_paprcs1.
            clear wa_paprcs1.
          endif.
          select single * from zrcumpso where zmonth eq ly_dt3+4(2) and zyear eq ly_dt3+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_plaprcs1-bzirk =  wa_l2-bzirk.
            wa_plaprcs1-junsale =  zrcumpso-netval.
            wa_plaprcs1-zdsm = wa_l2-zdsm.
            wa_plaprcs1-rm = wa_l2-rm.
            wa_plaprcs1-zm = wa_l2-zm.
            collect wa_plaprcs1 into it_plaprcs1.
            clear wa_plaprcs1.
          endif.
          select single * from zcumpso where zmonth eq f3date+4(2) and zyear eq f3date+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_pcaprcs1-bzirk =  wa_l2-bzirk.
            wa_pcaprcs1-junsale =  zcumpso-netval.
            wa_pcaprcs1-zdsm = wa_l2-zdsm.
            wa_pcaprcs1-rm = wa_l2-rm.
            wa_pcaprcs1-zm = wa_l2-zm.
            collect wa_pcaprcs1 into it_pcaprcs1.
            clear wa_pcaprcs1.
          endif.
          select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
          if sy-subrc eq 0.
            wa_ptaprcs1-bzirk =  wa_l2-bzirk.
            wa_ptaprcs1-junsale =  ysd_dist_targt-month03.
            wa_ptaprcs1-zdsm = wa_l2-zdsm.
            wa_ptaprcs1-rm = wa_l2-rm.
            wa_ptaprcs1-zm = wa_l2-zm.
            collect wa_ptaprcs1 into it_ptaprcs1.
            clear wa_ptaprcs1.
          endif.
        endif.
      endif.
    endif.
  endloop.


************ JUL *************************
  clear : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1,it_l2,wa_l2.
  select * from zdsmter into table it_zdsmter_l1 where zdsm in org and zmonth eq f4date+4(2) and zyear eq f4date+0(4).
  if sy-subrc eq 0.
    select * from zdsmter into table it_zdsmter_l2 for all entries in it_zdsmter_l1 where zdsm eq it_zdsmter_l1-bzirk and
      zmonth eq f4date+4(2) and zyear eq f4date+0(4).
  endif.
  loop at it_zdsmter_l2 into wa_zdsmter_l2 where zdsm+0(2) eq 'R-'.
    wa_l2-zmonth = wa_zdsmter_l2-zmonth.
    wa_l2-zyear = wa_zdsmter_l2-zyear.
    wa_l2-bzirk = wa_zdsmter_l2-bzirk.
    wa_l2-rm = wa_zdsmter_l2-zdsm.
    read table it_zdsmter_l2 into wa_zdsmter_l2 with key bzirk = wa_zdsmter_l2-zdsm zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_l2-zm = wa_zdsmter_l2-zdsm.
    endif.
    read table it_zdsmter_l1 into wa_zdsmter_l1 with key bzirk = wa_zdsmter_l2-zdsm.
    if sy-subrc eq 0.
      wa_l2-zdsm = wa_zdsmter_l1-zdsm.
    endif.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge date2.
    if sy-subrc eq 0.
      select single * from pa0001 where plans eq yterrallc-plans and endda ge date2.
      if sy-subrc eq 0.
        select single * from pa0302 where pernr eq pa0001-pernr and massn eq '01'.
        if sy-subrc eq 0.
          wa_l2-join_date = pa0302-begda.
        endif.
      endif.
    endif.
    collect wa_l2 into it_l2.
    clear wa_l2.
  endloop.

  loop at it_l2 into wa_l2.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge f4date.
    if sy-subrc eq 0.

      select single * from zrcumpso where zmonth eq ly_dt4+4(2) and zyear eq ly_dt4+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_l1aprcs1-bzirk =  wa_l2-bzirk.
        wa_l1aprcs1-julsale =  zrcumpso-netval.
        wa_l1aprcs1-zdsm = wa_l2-zdsm.
        wa_l1aprcs1-rm = wa_l2-rm.
        wa_l1aprcs1-zm = wa_l2-zm.
        collect wa_l1aprcs1 into it_l1aprcs1.
        clear wa_l1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
      if sy-subrc eq 0.
        wa_l1taprcs1-bzirk =  wa_l2-bzirk.
        wa_l1taprcs1-julsale =  ysd_dist_targt-month04.
        wa_l1taprcs1-zdsm = wa_l2-zdsm.
        wa_l1taprcs1-rm = wa_l2-rm.
        wa_l1taprcs1-zm = wa_l2-zm.
        collect wa_l1taprcs1 into it_l1taprcs1.
        clear wa_l1taprcs1.
      endif.

      if f4date le date2.
*      IF wa_l2-zjoin_date LE f4date.
        select single * from zcumpso where zmonth eq f4date+4(2) and zyear eq f4date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_aprcs1-bzirk =  wa_l2-bzirk.
          wa_aprcs1-julsale =  zcumpso-netval.
          wa_aprcs1-zdsm = wa_l2-zdsm.
          wa_aprcs1-rm = wa_l2-rm.
          wa_aprcs1-zm = wa_l2-zm.
          collect wa_aprcs1 into it_aprcs1.
          clear wa_aprcs1.
        endif.
        select single * from zrcumpso where zmonth eq ly_dt4+4(2) and zyear eq ly_dt4+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_laprcs1-bzirk =  wa_l2-bzirk.
          wa_laprcs1-julsale =  zrcumpso-netval.
          wa_laprcs1-zdsm = wa_l2-zdsm.
          wa_laprcs1-rm = wa_l2-rm.
          wa_laprcs1-zm = wa_l2-zm.
          collect wa_laprcs1 into it_laprcs1.
          clear wa_laprcs1.
        endif.

        select single * from zcumpso where zmonth eq f4date+4(2) and zyear eq f4date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_caprcs1-bzirk =  wa_l2-bzirk.
          wa_caprcs1-julsale =  zcumpso-netval.
          wa_caprcs1-zdsm = wa_l2-zdsm.
          wa_caprcs1-rm = wa_l2-rm.
          wa_caprcs1-zm = wa_l2-zm.
          collect wa_caprcs1 into it_caprcs1.
          clear wa_caprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
        if sy-subrc eq 0.
          wa_taprcs1-bzirk =  wa_l2-bzirk.
          wa_taprcs1-julsale =  ysd_dist_targt-month04.
          wa_taprcs1-zdsm = wa_l2-zdsm.
          wa_taprcs1-rm = wa_l2-rm.
          wa_taprcs1-zm = wa_l2-zm.
          collect wa_taprcs1 into it_taprcs1.
          clear wa_taprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
        if sy-subrc eq 0.
          wa_ltaprcs1-bzirk =  wa_l2-bzirk.
          wa_ltaprcs1-julsale =  ysd_dist_targt-month04.
          wa_ltaprcs1-zdsm = wa_l2-zdsm.
          wa_ltaprcs1-rm = wa_l2-rm.
          wa_ltaprcs1-zm = wa_l2-zm.
          collect wa_ltaprcs1 into it_ltaprcs1.
          clear wa_ltaprcs1.
        endif.
*      ENDIF.
      endif.

      if f4date le date2.
*      IF wa_l2-rjoin_date LE f4date.
        select single * from zrcumpso where zmonth eq f4date+4(2) and zyear eq f4date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_raprcs1-bzirk =  wa_l2-bzirk.
          wa_raprcs1-julsale =  zrcumpso-netval.
          wa_raprcs1-zdsm = wa_l2-zdsm.
          wa_raprcs1-rm = wa_l2-rm.
          wa_raprcs1-zm = wa_l2-zm.
          collect wa_raprcs1 into it_raprcs1.
          clear wa_raprcs1.
        endif.
        select single * from zrcumpso where zmonth eq ly_dt4+4(2) and zyear eq ly_dt4+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_rlaprcs1-bzirk =  wa_l2-bzirk.
          wa_rlaprcs1-julsale =  zrcumpso-netval.
          wa_rlaprcs1-zdsm = wa_l2-zdsm.
          wa_rlaprcs1-rm = wa_l2-rm.
          wa_rlaprcs1-zm = wa_l2-zm.
          collect wa_rlaprcs1 into it_rlaprcs1.
          clear wa_rlaprcs1.
        endif.
        select single * from zcumpso where zmonth eq f4date+4(2) and zyear eq f4date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_rcaprcs1-bzirk =  wa_l2-bzirk.
          wa_rcaprcs1-julsale =  zcumpso-netval.
          wa_rcaprcs1-zdsm = wa_l2-zdsm.
          wa_rcaprcs1-rm = wa_l2-rm.
          wa_rcaprcs1-zm = wa_l2-zm.
          collect wa_rcaprcs1 into it_rcaprcs1.
          clear wa_rcaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
        if sy-subrc eq 0.
          wa_rtaprcs1-bzirk =  wa_l2-bzirk.
          wa_rtaprcs1-julsale =  ysd_dist_targt-month04.
          wa_rtaprcs1-zdsm = wa_l2-zdsm.
          wa_rtaprcs1-rm = wa_l2-rm.
          wa_rtaprcs1-zm = wa_l2-zm.
          collect wa_rtaprcs1 into it_rtaprcs1.
          clear wa_rtaprcs1.
        endif.
*      ENDIF.
      endif.

      if f4date le date2.
        if wa_l2-join_date le f4date.
          select single * from zrcumpso where zmonth eq f4date+4(2) and zyear eq f4date+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_paprcs1-bzirk =  wa_l2-bzirk.
            wa_paprcs1-julsale =  zrcumpso-netval.
            wa_paprcs1-zdsm = wa_l2-zdsm.
            wa_paprcs1-rm = wa_l2-rm.
            wa_paprcs1-zm = wa_l2-zm.
            collect wa_paprcs1 into it_paprcs1.
            clear wa_paprcs1.
          endif.
          select single * from zrcumpso where zmonth eq ly_dt4+4(2) and zyear eq ly_dt4+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_plaprcs1-bzirk =  wa_l2-bzirk.
            wa_plaprcs1-julsale =  zrcumpso-netval.
            wa_plaprcs1-zdsm = wa_l2-zdsm.
            wa_plaprcs1-rm = wa_l2-rm.
            wa_plaprcs1-zm = wa_l2-zm.
            collect wa_plaprcs1 into it_plaprcs1.
            clear wa_plaprcs1.
          endif.
          select single * from zcumpso where zmonth eq f4date+4(2) and zyear eq f4date+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_pcaprcs1-bzirk =  wa_l2-bzirk.
            wa_pcaprcs1-julsale =  zcumpso-netval.
            wa_pcaprcs1-zdsm = wa_l2-zdsm.
            wa_pcaprcs1-rm = wa_l2-rm.
            wa_pcaprcs1-zm = wa_l2-zm.
            collect wa_pcaprcs1 into it_pcaprcs1.
            clear wa_pcaprcs1.
          endif.
          select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
          if sy-subrc eq 0.
            wa_ptaprcs1-bzirk =  wa_l2-bzirk.
            wa_ptaprcs1-julsale =  ysd_dist_targt-month04.
            wa_ptaprcs1-zdsm = wa_l2-zdsm.
            wa_ptaprcs1-rm = wa_l2-rm.
            wa_ptaprcs1-zm = wa_l2-zm.
            collect wa_ptaprcs1 into it_ptaprcs1.
            clear wa_ptaprcs1.
          endif.
        endif.
      endif.
    endif.
  endloop.

************ AUG *************************
  clear : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1,it_l2,wa_l2.
  select * from zdsmter into table it_zdsmter_l1 where zdsm in org and zmonth eq f5date+4(2) and zyear eq f5date+0(4).
  if sy-subrc eq 0.
    select * from zdsmter into table it_zdsmter_l2 for all entries in it_zdsmter_l1 where zdsm eq it_zdsmter_l1-bzirk and
      zmonth eq f5date+4(2) and zyear eq f5date+0(4).
  endif.
  loop at it_zdsmter_l2 into wa_zdsmter_l2 where zdsm+0(2) eq 'R-'.
    wa_l2-zmonth = wa_zdsmter_l2-zmonth.
    wa_l2-zyear = wa_zdsmter_l2-zyear.
    wa_l2-bzirk = wa_zdsmter_l2-bzirk.
    wa_l2-rm = wa_zdsmter_l2-zdsm.
    read table it_zdsmter_l2 into wa_zdsmter_l2 with key bzirk = wa_zdsmter_l2-zdsm zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_l2-zm = wa_zdsmter_l2-zdsm.
    endif.
    read table it_zdsmter_l1 into wa_zdsmter_l1 with key bzirk = wa_zdsmter_l2-zdsm.
    if sy-subrc eq 0.
      wa_l2-zdsm = wa_zdsmter_l1-zdsm.
    endif.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge date2.
    if sy-subrc eq 0.
      select single * from pa0001 where plans eq yterrallc-plans and endda ge date2.
      if sy-subrc eq 0.
        select single * from pa0302 where pernr eq pa0001-pernr and massn eq '01'.
        if sy-subrc eq 0.
          wa_l2-join_date = pa0302-begda.
        endif.
      endif.
    endif.
    collect wa_l2 into it_l2.
    clear wa_l2.
  endloop.


  loop at it_l2 into wa_l2.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge f5date.
    if sy-subrc eq 0.
      select single * from zrcumpso where zmonth eq ly_dt5+4(2) and zyear eq ly_dt5+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_l1aprcs1-bzirk =  wa_l2-bzirk.
        wa_l1aprcs1-augsale =  zrcumpso-netval.
        wa_l1aprcs1-zdsm = wa_l2-zdsm.
        wa_l1aprcs1-rm = wa_l2-rm.
        wa_l1aprcs1-zm = wa_l2-zm.
        collect wa_l1aprcs1 into it_l1aprcs1.
        clear wa_l1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
      if sy-subrc eq 0.
        wa_l1taprcs1-bzirk =  wa_l2-bzirk.
        wa_l1taprcs1-augsale =  ysd_dist_targt-month05.
        wa_l1taprcs1-zdsm = wa_l2-zdsm.
        wa_l1taprcs1-rm = wa_l2-rm.
        wa_l1taprcs1-zm = wa_l2-zm.
        collect wa_l1taprcs1 into it_l1taprcs1.
        clear wa_l1taprcs1.
      endif.

      if f5date le date2.
*      IF wa_l2-zjoin_date LE f5date.
        select single * from zcumpso where zmonth eq f5date+4(2) and zyear eq f5date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_aprcs1-bzirk =  wa_l2-bzirk.
          wa_aprcs1-augsale =  zcumpso-netval.
          wa_aprcs1-zdsm = wa_l2-zdsm.
          wa_aprcs1-rm = wa_l2-rm.
          wa_aprcs1-zm = wa_l2-zm.
          collect wa_aprcs1 into it_aprcs1.
          clear wa_aprcs1.
        endif.
        select single * from zrcumpso where zmonth eq ly_dt5+4(2) and zyear eq ly_dt5+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_laprcs1-bzirk =  wa_l2-bzirk.
          wa_laprcs1-augsale =  zrcumpso-netval.
          wa_laprcs1-zdsm = wa_l2-zdsm.
          wa_laprcs1-rm = wa_l2-rm.
          wa_laprcs1-zm = wa_l2-zm.
          collect wa_laprcs1 into it_laprcs1.
          clear wa_laprcs1.
        endif.

        select single * from zcumpso where zmonth eq f5date+4(2) and zyear eq f5date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_caprcs1-bzirk =  wa_l2-bzirk.
          wa_caprcs1-augsale =  zcumpso-netval.
          wa_caprcs1-zdsm = wa_l2-zdsm.
          wa_caprcs1-rm = wa_l2-rm.
          wa_caprcs1-zm = wa_l2-zm.
          collect wa_caprcs1 into it_caprcs1.
          clear wa_caprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
        if sy-subrc eq 0.
          wa_taprcs1-bzirk =  wa_l2-bzirk.
          wa_taprcs1-augsale =  ysd_dist_targt-month05.
          wa_taprcs1-zdsm = wa_l2-zdsm.
          wa_taprcs1-rm = wa_l2-rm.
          wa_taprcs1-zm = wa_l2-zm.
          collect wa_taprcs1 into it_taprcs1.
          clear wa_taprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
        if sy-subrc eq 0.
          wa_ltaprcs1-bzirk =  wa_l2-bzirk.
          wa_ltaprcs1-augsale =  ysd_dist_targt-month05.
          wa_ltaprcs1-zdsm = wa_l2-zdsm.
          wa_ltaprcs1-rm = wa_l2-rm.
          wa_ltaprcs1-zm = wa_l2-zm.
          collect wa_ltaprcs1 into it_ltaprcs1.
          clear wa_ltaprcs1.
        endif.
*      ENDIF.
      endif.

      if f5date le date2.
*      IF wa_l2-rjoin_date LE f5date.
        select single * from zrcumpso where zmonth eq f5date+4(2) and zyear eq f5date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_raprcs1-bzirk =  wa_l2-bzirk.
          wa_raprcs1-augsale =  zrcumpso-netval.
          wa_raprcs1-zdsm = wa_l2-zdsm.
          wa_raprcs1-rm = wa_l2-rm.
          wa_raprcs1-zm = wa_l2-zm.
          collect wa_raprcs1 into it_raprcs1.
          clear wa_raprcs1.
        endif.
        select single * from zrcumpso where zmonth eq ly_dt5+4(2) and zyear eq ly_dt5+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_rlaprcs1-bzirk =  wa_l2-bzirk.
          wa_rlaprcs1-augsale =  zrcumpso-netval.
          wa_rlaprcs1-zdsm = wa_l2-zdsm.
          wa_rlaprcs1-rm = wa_l2-rm.
          wa_rlaprcs1-zm = wa_l2-zm.
          collect wa_rlaprcs1 into it_rlaprcs1.
          clear wa_rlaprcs1.
        endif.
        select single * from zcumpso where zmonth eq f5date+4(2) and zyear eq f5date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_rcaprcs1-bzirk =  wa_l2-bzirk.
          wa_rcaprcs1-augsale =  zcumpso-netval.
          wa_rcaprcs1-zdsm = wa_l2-zdsm.
          wa_rcaprcs1-rm = wa_l2-rm.
          wa_rcaprcs1-zm = wa_l2-zm.
          collect wa_rcaprcs1 into it_rcaprcs1.
          clear wa_rcaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
        if sy-subrc eq 0.
          wa_rtaprcs1-bzirk =  wa_l2-bzirk.
          wa_rtaprcs1-augsale =  ysd_dist_targt-month05.
          wa_rtaprcs1-zdsm = wa_l2-zdsm.
          wa_rtaprcs1-rm = wa_l2-rm.
          wa_rtaprcs1-zm = wa_l2-zm.
          collect wa_rtaprcs1 into it_rtaprcs1.
          clear wa_rtaprcs1.
        endif.
*      ENDIF.
      endif.

      if f5date le date2.
        if wa_l2-join_date le f5date.
          select single * from zrcumpso where zmonth eq f5date+4(2) and zyear eq f5date+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_paprcs1-bzirk =  wa_l2-bzirk.
            wa_paprcs1-augsale =  zrcumpso-netval.
            wa_paprcs1-zdsm = wa_l2-zdsm.
            wa_paprcs1-rm = wa_l2-rm.
            wa_paprcs1-zm = wa_l2-zm.
            collect wa_paprcs1 into it_paprcs1.
            clear wa_paprcs1.
          endif.
          select single * from zrcumpso where zmonth eq ly_dt5+4(2) and zyear eq ly_dt5+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_plaprcs1-bzirk =  wa_l2-bzirk.
            wa_plaprcs1-augsale =  zrcumpso-netval.
            wa_plaprcs1-zdsm = wa_l2-zdsm.
            wa_plaprcs1-rm = wa_l2-rm.
            wa_plaprcs1-zm = wa_l2-zm.
            collect wa_plaprcs1 into it_plaprcs1.
            clear wa_plaprcs1.
          endif.
          select single * from zcumpso where zmonth eq f5date+4(2) and zyear eq f5date+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_pcaprcs1-bzirk =  wa_l2-bzirk.
            wa_pcaprcs1-augsale =  zcumpso-netval.
            wa_pcaprcs1-zdsm = wa_l2-zdsm.
            wa_pcaprcs1-rm = wa_l2-rm.
            wa_pcaprcs1-zm = wa_l2-zm.
            collect wa_pcaprcs1 into it_pcaprcs1.
            clear wa_pcaprcs1.
          endif.
          select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
          if sy-subrc eq 0.
            wa_ptaprcs1-bzirk =  wa_l2-bzirk.
            wa_ptaprcs1-augsale =  ysd_dist_targt-month05.
            wa_ptaprcs1-zdsm = wa_l2-zdsm.
            wa_ptaprcs1-rm = wa_l2-rm.
            wa_ptaprcs1-zm = wa_l2-zm.
            collect wa_ptaprcs1 into it_ptaprcs1.
            clear wa_ptaprcs1.
          endif.
        endif.
      endif.
    endif.
  endloop.


************ SEP *************************
  clear : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1,it_l2,wa_l2.
  select * from zdsmter into table it_zdsmter_l1 where zdsm in org and zmonth eq f6date+4(2) and zyear eq f6date+0(4).
  if sy-subrc eq 0.
    select * from zdsmter into table it_zdsmter_l2 for all entries in it_zdsmter_l1 where zdsm eq it_zdsmter_l1-bzirk and
      zmonth eq f6date+4(2) and zyear eq f6date+0(4).
  endif.
  loop at it_zdsmter_l2 into wa_zdsmter_l2 where zdsm+0(2) eq 'R-'.
    wa_l2-zmonth = wa_zdsmter_l2-zmonth.
    wa_l2-zyear = wa_zdsmter_l2-zyear.
    wa_l2-bzirk = wa_zdsmter_l2-bzirk.
    wa_l2-rm = wa_zdsmter_l2-zdsm.
    read table it_zdsmter_l2 into wa_zdsmter_l2 with key bzirk = wa_zdsmter_l2-zdsm zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_l2-zm = wa_zdsmter_l2-zdsm.
    endif.
    read table it_zdsmter_l1 into wa_zdsmter_l1 with key bzirk = wa_zdsmter_l2-zdsm.
    if sy-subrc eq 0.
      wa_l2-zdsm = wa_zdsmter_l1-zdsm.
    endif.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge date2.
    if sy-subrc eq 0.
      select single * from pa0001 where plans eq yterrallc-plans and endda ge date2.
      if sy-subrc eq 0.
        select single * from pa0302 where pernr eq pa0001-pernr and massn eq '01'.
        if sy-subrc eq 0.
          wa_l2-join_date = pa0302-begda.
        endif.
      endif.
    endif.
    collect wa_l2 into it_l2.
    clear wa_l2.
  endloop.


  loop at it_l2 into wa_l2.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge f6date.
    if sy-subrc eq 0.

      select single * from zrcumpso where zmonth eq ly_dt6+4(2) and zyear eq ly_dt6+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_l1aprcs1-bzirk =  wa_l2-bzirk.
        wa_l1aprcs1-sepsale =  zrcumpso-netval.
        wa_l1aprcs1-zdsm = wa_l2-zdsm.
        wa_l1aprcs1-rm = wa_l2-rm.
        wa_l1aprcs1-zm = wa_l2-zm.
        collect wa_l1aprcs1 into it_l1aprcs1.
        clear wa_l1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
      if sy-subrc eq 0.
        wa_l1taprcs1-bzirk =  wa_l2-bzirk.
        wa_l1taprcs1-sepsale =  ysd_dist_targt-month06.
        wa_l1taprcs1-zdsm = wa_l2-zdsm.
        wa_l1taprcs1-zm = wa_l2-zm.
        wa_l1taprcs1-rm = wa_l2-rm.
        collect wa_l1taprcs1 into it_l1taprcs1.
        clear wa_l1taprcs1.
      endif.

      if f6date le date2.
*      IF wa_l2-zjoin_date LE f6date.
        select single * from zcumpso where zmonth eq f6date+4(2) and zyear eq f6date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_aprcs1-bzirk =  wa_l2-bzirk.
          wa_aprcs1-sepsale =  zcumpso-netval.
          wa_aprcs1-zdsm = wa_l2-zdsm.
          wa_aprcs1-rm = wa_l2-rm.
          wa_aprcs1-zm = wa_l2-zm.
          collect wa_aprcs1 into it_aprcs1.
          clear wa_aprcs1.
        endif.
        select single * from zrcumpso where zmonth eq ly_dt6+4(2) and zyear eq ly_dt6+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_laprcs1-bzirk =  wa_l2-bzirk.
          wa_laprcs1-sepsale =  zrcumpso-netval.
          wa_laprcs1-zdsm = wa_l2-zdsm.
          wa_laprcs1-rm = wa_l2-rm.
          wa_laprcs1-zm = wa_l2-zm.
          collect wa_laprcs1 into it_laprcs1.
          clear wa_laprcs1.
        endif.

        select single * from zcumpso where zmonth eq f6date+4(2) and zyear eq f6date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_caprcs1-bzirk =  wa_l2-bzirk.
          wa_caprcs1-sepsale =  zcumpso-netval.
          wa_caprcs1-zdsm = wa_l2-zdsm.
          wa_caprcs1-rm = wa_l2-rm.
          wa_caprcs1-zm = wa_l2-zm.
          collect wa_caprcs1 into it_caprcs1.
          clear wa_caprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
        if sy-subrc eq 0.
          wa_taprcs1-bzirk =  wa_l2-bzirk.
          wa_taprcs1-sepsale =  ysd_dist_targt-month06.
          wa_taprcs1-zdsm = wa_l2-zdsm.
          wa_taprcs1-rm = wa_l2-rm.
          wa_taprcs1-zm = wa_l2-zm.
          collect wa_taprcs1 into it_taprcs1.
          clear wa_taprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
        if sy-subrc eq 0.
          wa_ltaprcs1-bzirk =  wa_l2-bzirk.
          wa_ltaprcs1-sepsale =  ysd_dist_targt-month06.
          wa_ltaprcs1-zdsm = wa_l2-zdsm.
          wa_ltaprcs1-rm = wa_l2-rm.
          wa_ltaprcs1-zm = wa_l2-zm.
          collect wa_ltaprcs1 into it_ltaprcs1.
          clear wa_ltaprcs1.
        endif.
*      ENDIF.
      endif.

      if f6date le date2.
*      IF wa_l2-rjoin_date LE f6date.
        select single * from zrcumpso where zmonth eq f6date+4(2) and zyear eq f6date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_raprcs1-bzirk =  wa_l2-bzirk.
          wa_raprcs1-sepsale =  zrcumpso-netval.
          wa_raprcs1-zdsm = wa_l2-zdsm.
          wa_raprcs1-rm = wa_l2-rm.
          wa_raprcs1-zm = wa_l2-zm.
          collect wa_raprcs1 into it_raprcs1.
          clear wa_raprcs1.
        endif.
        select single * from zrcumpso where zmonth eq ly_dt6+4(2) and zyear eq ly_dt6+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_rlaprcs1-bzirk =  wa_l2-bzirk.
          wa_rlaprcs1-sepsale =  zrcumpso-netval.
          wa_rlaprcs1-zdsm = wa_l2-zdsm.
          wa_rlaprcs1-rm = wa_l2-rm.
          wa_rlaprcs1-zm = wa_l2-zm.
          collect wa_rlaprcs1 into it_rlaprcs1.
          clear wa_rlaprcs1.
        endif.
        select single * from zcumpso where zmonth eq f6date+4(2) and zyear eq f6date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_rcaprcs1-bzirk =  wa_l2-bzirk.
          wa_rcaprcs1-sepsale =  zcumpso-netval.
          wa_rcaprcs1-zdsm = wa_l2-zdsm.
          wa_rcaprcs1-rm = wa_l2-rm.
          wa_rcaprcs1-zm = wa_l2-zm.
          collect wa_rcaprcs1 into it_rcaprcs1.
          clear wa_rcaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
        if sy-subrc eq 0.
          wa_rtaprcs1-bzirk =  wa_l2-bzirk.
          wa_rtaprcs1-sepsale =  ysd_dist_targt-month06.
          wa_rtaprcs1-zdsm = wa_l2-zdsm.
          wa_rtaprcs1-rm = wa_l2-rm.
          wa_rtaprcs1-zm = wa_l2-zm.
          collect wa_rtaprcs1 into it_rtaprcs1.
          clear wa_rtaprcs1.
        endif.
*      ENDIF.
      endif.

      if f6date le date2.
        if wa_l2-join_date le f6date.
          select single * from zrcumpso where zmonth eq f6date+4(2) and zyear eq f6date+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_paprcs1-bzirk =  wa_l2-bzirk.
            wa_paprcs1-sepsale =  zrcumpso-netval.
            wa_paprcs1-zdsm = wa_l2-zdsm.
            wa_paprcs1-rm = wa_l2-rm.
            wa_paprcs1-zm = wa_l2-zm.
            collect wa_paprcs1 into it_paprcs1.
            clear wa_paprcs1.
          endif.
          select single * from zrcumpso where zmonth eq ly_dt6+4(2) and zyear eq ly_dt6+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_plaprcs1-bzirk =  wa_l2-bzirk.
            wa_plaprcs1-sepsale =  zrcumpso-netval.
            wa_plaprcs1-zdsm = wa_l2-zdsm.
            wa_plaprcs1-rm = wa_l2-rm.
            wa_plaprcs1-zm = wa_l2-zm.
            collect wa_plaprcs1 into it_plaprcs1.
            clear wa_plaprcs1.
          endif.
          select single * from zcumpso where zmonth eq f6date+4(2) and zyear eq f6date+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_pcaprcs1-bzirk =  wa_l2-bzirk.
            wa_pcaprcs1-sepsale =  zcumpso-netval.
            wa_pcaprcs1-zdsm = wa_l2-zdsm.
            wa_pcaprcs1-rm = wa_l2-rm.
            wa_pcaprcs1-zm = wa_l2-zm.
            collect wa_pcaprcs1 into it_pcaprcs1.
            clear wa_pcaprcs1.
          endif.
          select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
          if sy-subrc eq 0.
            wa_ptaprcs1-bzirk =  wa_l2-bzirk.
            wa_ptaprcs1-sepsale =  ysd_dist_targt-month06.
            wa_ptaprcs1-zdsm = wa_l2-zdsm.
            wa_ptaprcs1-rm = wa_l2-rm.
            wa_ptaprcs1-zm = wa_l2-zm.
            collect wa_ptaprcs1 into it_ptaprcs1.
            clear wa_ptaprcs1.
          endif.
        endif.
      endif.
    endif.

  endloop.


************ OCT *************************
  clear : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1,it_l2,wa_l2.
  select * from zdsmter into table it_zdsmter_l1 where zdsm in org and zmonth eq f7date+4(2) and zyear eq f7date+0(4).
  if sy-subrc eq 0.
    select * from zdsmter into table it_zdsmter_l2 for all entries in it_zdsmter_l1 where zdsm eq it_zdsmter_l1-bzirk and
      zmonth eq f7date+4(2) and zyear eq f7date+0(4).
  endif.
  loop at it_zdsmter_l2 into wa_zdsmter_l2 where zdsm+0(2) eq 'R-'.
    wa_l2-zmonth = wa_zdsmter_l2-zmonth.
    wa_l2-zyear = wa_zdsmter_l2-zyear.
    wa_l2-bzirk = wa_zdsmter_l2-bzirk.
    wa_l2-rm = wa_zdsmter_l2-zdsm.
    read table it_zdsmter_l2 into wa_zdsmter_l2 with key bzirk = wa_zdsmter_l2-zdsm zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_l2-zm = wa_zdsmter_l2-zdsm.
    endif.
    read table it_zdsmter_l1 into wa_zdsmter_l1 with key bzirk = wa_zdsmter_l2-zdsm.
    if sy-subrc eq 0.
      wa_l2-zdsm = wa_zdsmter_l1-zdsm.
    endif.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge date2.
    if sy-subrc eq 0.
      select single * from pa0001 where plans eq yterrallc-plans and endda ge date2.
      if sy-subrc eq 0.
        select single * from pa0302 where pernr eq pa0001-pernr and massn eq '01'.
        if sy-subrc eq 0.
          wa_l2-join_date = pa0302-begda.
        endif.
      endif.
    endif.
    collect wa_l2 into it_l2.
    clear wa_l2.
  endloop.

  loop at it_l2 into wa_l2.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge f7date.
    if sy-subrc eq 0.
      select single * from zrcumpso where zmonth eq ly_dt7+4(2) and zyear eq ly_dt7+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_l1aprcs1-bzirk =  wa_l2-bzirk.
        wa_l1aprcs1-octsale =  zrcumpso-netval.
        wa_l1aprcs1-zdsm = wa_l2-zdsm.
        wa_l1aprcs1-rm = wa_l2-rm.
        wa_l1aprcs1-zm = wa_l2-zm.
        collect wa_l1aprcs1 into it_l1aprcs1.
        clear wa_l1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
      if sy-subrc eq 0.
        wa_l1taprcs1-bzirk =  wa_l2-bzirk.
        wa_l1taprcs1-octsale =  ysd_dist_targt-month07.
        wa_l1taprcs1-zdsm = wa_l2-zdsm.
        wa_l1taprcs1-rm = wa_l2-rm.
        wa_l1taprcs1-zm = wa_l2-zm.
        collect wa_l1taprcs1 into it_l1taprcs1.
        clear wa_l1taprcs1.
      endif.

      if f7date le date2.
*      IF wa_l2-zjoin_date LE f7date.
        select single * from zcumpso where zmonth eq f7date+4(2) and zyear eq f7date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_aprcs1-bzirk =  wa_l2-bzirk.
          wa_aprcs1-octsale =  zcumpso-netval.
          wa_aprcs1-zdsm = wa_l2-zdsm.
          wa_aprcs1-rm = wa_l2-rm.
          wa_aprcs1-zm = wa_l2-zm.
          collect wa_aprcs1 into it_aprcs1.
          clear wa_aprcs1.
        endif.
        select single * from zrcumpso where zmonth eq ly_dt7+4(2) and zyear eq ly_dt7+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_laprcs1-bzirk =  wa_l2-bzirk.
          wa_laprcs1-octsale =  zrcumpso-netval.
          wa_laprcs1-zdsm = wa_l2-zdsm.
          wa_laprcs1-rm = wa_l2-rm.
          wa_laprcs1-zm = wa_l2-zm.
          collect wa_laprcs1 into it_laprcs1.
          clear wa_laprcs1.
        endif.

        select single * from zcumpso where zmonth eq f7date+4(2) and zyear eq f7date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_caprcs1-bzirk =  wa_l2-bzirk.
          wa_caprcs1-octsale =  zcumpso-netval.
          wa_caprcs1-zdsm = wa_l2-zdsm.
          wa_caprcs1-rm = wa_l2-rm.
          wa_caprcs1-zm = wa_l2-zm.
          collect wa_caprcs1 into it_caprcs1.
          clear wa_caprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
        if sy-subrc eq 0.
          wa_taprcs1-bzirk =  wa_l2-bzirk.
          wa_taprcs1-octsale =  ysd_dist_targt-month07.
          wa_taprcs1-zdsm = wa_l2-zdsm.
          wa_taprcs1-rm = wa_l2-rm.
          wa_taprcs1-zm = wa_l2-zm.
          collect wa_taprcs1 into it_taprcs1.
          clear wa_taprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
        if sy-subrc eq 0.
          wa_ltaprcs1-bzirk =  wa_l2-bzirk.
          wa_ltaprcs1-octsale =  ysd_dist_targt-month07.
          wa_ltaprcs1-zdsm = wa_l2-zdsm.
          wa_ltaprcs1-rm = wa_l2-rm.
          wa_ltaprcs1-zm = wa_l2-zm.
          collect wa_ltaprcs1 into it_ltaprcs1.
          clear wa_ltaprcs1.
        endif.
*      ENDIF.
      endif.

      if f7date le date2.
*      IF wa_l2-rjoin_date LE f7date.
        select single * from zrcumpso where zmonth eq f7date+4(2) and zyear eq f7date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_raprcs1-bzirk =  wa_l2-bzirk.
          wa_raprcs1-octsale =  zrcumpso-netval.
          wa_raprcs1-zdsm = wa_l2-zdsm.
          wa_raprcs1-rm = wa_l2-rm.
          wa_raprcs1-zm = wa_l2-zm.
          collect wa_raprcs1 into it_raprcs1.
          clear wa_raprcs1.
        endif.
        select single * from zrcumpso where zmonth eq ly_dt7+4(2) and zyear eq ly_dt7+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_rlaprcs1-bzirk =  wa_l2-bzirk.
          wa_rlaprcs1-octsale =  zrcumpso-netval.
          wa_rlaprcs1-zdsm = wa_l2-zdsm.
          wa_rlaprcs1-rm = wa_l2-rm.
          wa_rlaprcs1-zm = wa_l2-zm.
          collect wa_rlaprcs1 into it_rlaprcs1.
          clear wa_rlaprcs1.
        endif.
        select single * from zcumpso where zmonth eq f7date+4(2) and zyear eq f7date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_rcaprcs1-bzirk =  wa_l2-bzirk.
          wa_rcaprcs1-octsale =  zcumpso-netval.
          wa_rcaprcs1-zdsm = wa_l2-zdsm.
          wa_rcaprcs1-rm = wa_l2-rm.
          wa_rcaprcs1-zm = wa_l2-zm.
          collect wa_rcaprcs1 into it_rcaprcs1.
          clear wa_rcaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
        if sy-subrc eq 0.
          wa_rtaprcs1-bzirk =  wa_l2-bzirk.
          wa_rtaprcs1-octsale =  ysd_dist_targt-month07.
          wa_rtaprcs1-zdsm = wa_l2-zdsm.
          wa_rtaprcs1-rm = wa_l2-rm.
          wa_rtaprcs1-zm = wa_l2-zm.
          collect wa_rtaprcs1 into it_rtaprcs1.
          clear wa_rtaprcs1.
        endif.
*      ENDIF.
      endif.

      if f7date le date2.
        if wa_l2-join_date le f7date.
          select single * from zrcumpso where zmonth eq f7date+4(2) and zyear eq f7date+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_paprcs1-bzirk =  wa_l2-bzirk.
            wa_paprcs1-octsale =  zrcumpso-netval.
            wa_paprcs1-zdsm = wa_l2-zdsm.
            wa_paprcs1-rm = wa_l2-rm.
            wa_paprcs1-zm = wa_l2-zm.
            collect wa_paprcs1 into it_paprcs1.
            clear wa_paprcs1.
          endif.
          select single * from zrcumpso where zmonth eq ly_dt7+4(2) and zyear eq ly_dt7+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_plaprcs1-bzirk =  wa_l2-bzirk.
            wa_plaprcs1-octsale =  zrcumpso-netval.
            wa_plaprcs1-zdsm = wa_l2-zdsm.
            wa_plaprcs1-rm = wa_l2-rm.
            wa_plaprcs1-zm = wa_l2-zm.
            collect wa_plaprcs1 into it_plaprcs1.
            clear wa_plaprcs1.
          endif.
          select single * from zcumpso where zmonth eq f7date+4(2) and zyear eq f7date+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_pcaprcs1-bzirk =  wa_l2-bzirk.
            wa_pcaprcs1-octsale =  zcumpso-netval.
            wa_pcaprcs1-zdsm = wa_l2-zdsm.
            wa_pcaprcs1-rm = wa_l2-rm.
            wa_pcaprcs1-zm = wa_l2-zm.
            collect wa_pcaprcs1 into it_pcaprcs1.
            clear wa_pcaprcs1.
          endif.
          select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
          if sy-subrc eq 0.
            wa_ptaprcs1-bzirk =  wa_l2-bzirk.
            wa_ptaprcs1-octsale =  ysd_dist_targt-month07.
            wa_ptaprcs1-zdsm = wa_l2-zdsm.
            wa_ptaprcs1-rm = wa_l2-rm.
            wa_ptaprcs1-zm = wa_l2-zm.
            collect wa_ptaprcs1 into it_ptaprcs1.
            clear wa_ptaprcs1.
          endif.
        endif.
      endif.
    endif.
  endloop.


************ NOV *************************
  clear : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1,it_l2,wa_l2.
  select * from zdsmter into table it_zdsmter_l1 where zdsm in org and zmonth eq f8date+4(2) and zyear eq f8date+0(4).
  if sy-subrc eq 0.
    select * from zdsmter into table it_zdsmter_l2 for all entries in it_zdsmter_l1 where zdsm eq it_zdsmter_l1-bzirk and
      zmonth eq f8date+4(2) and zyear eq f8date+0(4).
  endif.
  loop at it_zdsmter_l2 into wa_zdsmter_l2 where zdsm+0(2) eq 'R-'.
    wa_l2-zmonth = wa_zdsmter_l2-zmonth.
    wa_l2-zyear = wa_zdsmter_l2-zyear.
    wa_l2-bzirk = wa_zdsmter_l2-bzirk.
    wa_l2-rm = wa_zdsmter_l2-zdsm.
    read table it_zdsmter_l2 into wa_zdsmter_l2 with key bzirk = wa_zdsmter_l2-zdsm zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_l2-zm = wa_zdsmter_l2-zdsm.
    endif.
    read table it_zdsmter_l1 into wa_zdsmter_l1 with key bzirk = wa_zdsmter_l2-zdsm.
    if sy-subrc eq 0.
      wa_l2-zdsm = wa_zdsmter_l1-zdsm.
    endif.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge date2.
    if sy-subrc eq 0.
      select single * from pa0001 where plans eq yterrallc-plans and endda ge date2.
      if sy-subrc eq 0.
        select single * from pa0302 where pernr eq pa0001-pernr and massn eq '01'.
        if sy-subrc eq 0.
          wa_l2-join_date = pa0302-begda.
        endif.
      endif.
    endif.
    collect wa_l2 into it_l2.
    clear wa_l2.
  endloop.

  loop at it_l2 into wa_l2.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge f8date.
    if sy-subrc eq 0.
      select single * from zrcumpso where zmonth eq ly_dt8+4(2) and zyear eq ly_dt8+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_l1aprcs1-bzirk =  wa_l2-bzirk.
        wa_l1aprcs1-novsale =  zrcumpso-netval.
        wa_l1aprcs1-zdsm = wa_l2-zdsm.
        wa_l1aprcs1-rm = wa_l2-rm.
        wa_l1aprcs1-zm = wa_l2-zm.
        collect wa_l1aprcs1 into it_l1aprcs1.
        clear wa_l1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
      if sy-subrc eq 0.
        wa_l1taprcs1-bzirk =  wa_l2-bzirk.
        wa_l1taprcs1-novsale =  ysd_dist_targt-month08.
        wa_l1taprcs1-zdsm = wa_l2-zdsm.
        wa_l1taprcs1-rm = wa_l2-rm.
        wa_l1taprcs1-zm = wa_l2-zm.
        collect wa_l1taprcs1 into it_l1taprcs1.
        clear wa_l1taprcs1.
      endif.

      if f8date le date2.
*      IF wa_l2-zjoin_date LE f8date.
        select single * from zcumpso where zmonth eq f8date+4(2) and zyear eq f8date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_aprcs1-bzirk =  wa_l2-bzirk.
          wa_aprcs1-novsale =  zcumpso-netval.
          wa_aprcs1-zdsm = wa_l2-zdsm.
          wa_aprcs1-rm = wa_l2-rm.
          wa_aprcs1-zm = wa_l2-zm.
          collect wa_aprcs1 into it_aprcs1.
          clear wa_aprcs1.
        endif.
        select single * from zrcumpso where zmonth eq ly_dt8+4(2) and zyear eq ly_dt8+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_laprcs1-bzirk =  wa_l2-bzirk.
          wa_laprcs1-novsale =  zrcumpso-netval.
          wa_laprcs1-zdsm = wa_l2-zdsm.
          wa_laprcs1-rm = wa_l2-rm.
          wa_laprcs1-zm = wa_l2-zm.
          collect wa_laprcs1 into it_laprcs1.
          clear wa_laprcs1.
        endif.

        select single * from zcumpso where zmonth eq f8date+4(2) and zyear eq f8date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_caprcs1-bzirk =  wa_l2-bzirk.
          wa_caprcs1-novsale =  zcumpso-netval.
          wa_caprcs1-zdsm = wa_l2-zdsm.
          wa_caprcs1-rm = wa_l2-rm.
          wa_caprcs1-zm = wa_l2-zm.
          collect wa_caprcs1 into it_caprcs1.
          clear wa_caprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
        if sy-subrc eq 0.
          wa_taprcs1-bzirk =  wa_l2-bzirk.
          wa_taprcs1-novsale =  ysd_dist_targt-month08.
          wa_taprcs1-zdsm = wa_l2-zdsm.
          wa_taprcs1-rm = wa_l2-rm.
          wa_taprcs1-zm = wa_l2-zm.
          collect wa_taprcs1 into it_taprcs1.
          clear wa_taprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
        if sy-subrc eq 0.
          wa_ltaprcs1-bzirk =  wa_l2-bzirk.
          wa_ltaprcs1-novsale =  ysd_dist_targt-month08.
          wa_ltaprcs1-zdsm = wa_l2-zdsm.
          wa_ltaprcs1-rm = wa_l2-rm.
          wa_ltaprcs1-zm = wa_l2-zm.
          collect wa_ltaprcs1 into it_ltaprcs1.
          clear wa_ltaprcs1.
        endif.
*      ENDIF.
      endif.

      if f8date le date2.
*      IF wa_l2-rjoin_date LE f8date.
        select single * from zrcumpso where zmonth eq f8date+4(2) and zyear eq f8date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_raprcs1-bzirk =  wa_l2-bzirk.
          wa_raprcs1-novsale =  zrcumpso-netval.
          wa_raprcs1-zdsm = wa_l2-zdsm.
          wa_raprcs1-rm = wa_l2-rm.
          wa_raprcs1-zm = wa_l2-zm.
          collect wa_raprcs1 into it_raprcs1.
          clear wa_raprcs1.
        endif.
        select single * from zrcumpso where zmonth eq ly_dt8+4(2) and zyear eq ly_dt8+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_rlaprcs1-bzirk =  wa_l2-bzirk.
          wa_rlaprcs1-novsale =  zrcumpso-netval.
          wa_rlaprcs1-zdsm = wa_l2-zdsm.
          wa_rlaprcs1-rm = wa_l2-rm.
          wa_rlaprcs1-zm = wa_l2-zm.
          collect wa_rlaprcs1 into it_rlaprcs1.
          clear wa_rlaprcs1.
        endif.
        select single * from zcumpso where zmonth eq f8date+4(2) and zyear eq f8date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_rcaprcs1-bzirk =  wa_l2-bzirk.
          wa_rcaprcs1-novsale =  zcumpso-netval.
          wa_rcaprcs1-zdsm = wa_l2-zdsm.
          wa_rcaprcs1-rm = wa_l2-rm.
          wa_rcaprcs1-zm = wa_l2-zm.
          collect wa_rcaprcs1 into it_rcaprcs1.
          clear wa_rcaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
        if sy-subrc eq 0.
          wa_rtaprcs1-bzirk =  wa_l2-bzirk.
          wa_rtaprcs1-novsale =  ysd_dist_targt-month08.
          wa_rtaprcs1-zdsm = wa_l2-zdsm.
          wa_rtaprcs1-rm = wa_l2-rm.
          wa_rtaprcs1-zm = wa_l2-zm.
          collect wa_rtaprcs1 into it_rtaprcs1.
          clear wa_rtaprcs1.
        endif.
*      ENDIF.
      endif.

      if f8date le date2.
        if wa_l2-join_date le f8date.
          select single * from zrcumpso where zmonth eq f8date+4(2) and zyear eq f8date+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_paprcs1-bzirk =  wa_l2-bzirk.
            wa_paprcs1-novsale =  zrcumpso-netval.
            wa_paprcs1-zdsm = wa_l2-zdsm.
            wa_paprcs1-rm = wa_l2-rm.
            wa_paprcs1-zm = wa_l2-zm.
            collect wa_paprcs1 into it_paprcs1.
            clear wa_paprcs1.
          endif.
          select single * from zrcumpso where zmonth eq ly_dt8+4(2) and zyear eq ly_dt8+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_plaprcs1-bzirk =  wa_l2-bzirk.
            wa_plaprcs1-novsale =  zrcumpso-netval.
            wa_plaprcs1-zdsm = wa_l2-zdsm.
            wa_plaprcs1-rm = wa_l2-rm.
            wa_plaprcs1-zm = wa_l2-zm.
            collect wa_plaprcs1 into it_plaprcs1.
            clear wa_plaprcs1.
          endif.
          select single * from zcumpso where zmonth eq f8date+4(2) and zyear eq f8date+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_pcaprcs1-bzirk =  wa_l2-bzirk.
            wa_pcaprcs1-novsale =  zcumpso-netval.
            wa_pcaprcs1-zdsm = wa_l2-zdsm.
            wa_pcaprcs1-rm = wa_l2-rm.
            wa_pcaprcs1-zm = wa_l2-zm.
            collect wa_pcaprcs1 into it_pcaprcs1.
            clear wa_pcaprcs1.
          endif.
          select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
          if sy-subrc eq 0.
            wa_ptaprcs1-bzirk =  wa_l2-bzirk.
            wa_ptaprcs1-novsale =  ysd_dist_targt-month08.
            wa_ptaprcs1-zdsm = wa_l2-zdsm.
            wa_ptaprcs1-rm = wa_l2-rm.
            wa_ptaprcs1-zm = wa_l2-zm.
            collect wa_ptaprcs1 into it_ptaprcs1.
            clear wa_ptaprcs1.
          endif.
        endif.
      endif.
    endif.
  endloop.


************ DEC *************************
  clear : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1,it_l2,wa_l2.
  select * from zdsmter into table it_zdsmter_l1 where zdsm in org and zmonth eq f9date+4(2) and zyear eq f9date+0(4).
  if sy-subrc eq 0.
    select * from zdsmter into table it_zdsmter_l2 for all entries in it_zdsmter_l1 where zdsm eq it_zdsmter_l1-bzirk and
      zmonth eq f9date+4(2) and zyear eq f9date+0(4).
  endif.
  loop at it_zdsmter_l2 into wa_zdsmter_l2 where zdsm+0(2) eq 'R-'.
    wa_l2-zmonth = wa_zdsmter_l2-zmonth.
    wa_l2-zyear = wa_zdsmter_l2-zyear.
    wa_l2-bzirk = wa_zdsmter_l2-bzirk.
    wa_l2-rm = wa_zdsmter_l2-zdsm.
    read table it_zdsmter_l2 into wa_zdsmter_l2 with key bzirk = wa_zdsmter_l2-zdsm zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_l2-zm = wa_zdsmter_l2-zdsm.
    endif.
    read table it_zdsmter_l1 into wa_zdsmter_l1 with key bzirk = wa_zdsmter_l2-zdsm.
    if sy-subrc eq 0.
      wa_l2-zdsm = wa_zdsmter_l1-zdsm.
    endif.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge date2.
    if sy-subrc eq 0.
      select single * from pa0001 where plans eq yterrallc-plans and endda ge date2.
      if sy-subrc eq 0.
        select single * from pa0302 where pernr eq pa0001-pernr and massn eq '01'.
        if sy-subrc eq 0.
          wa_l2-join_date = pa0302-begda.
        endif.
      endif.
    endif.
    collect wa_l2 into it_l2.
    clear wa_l2.
  endloop.

  loop at it_l2 into wa_l2.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge f9date.
    if sy-subrc eq 0.
      select single * from zrcumpso where zmonth eq ly_dt9+4(2) and zyear eq ly_dt9+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_l1aprcs1-bzirk =  wa_l2-bzirk.
        wa_l1aprcs1-decsale =  zrcumpso-netval.
        wa_l1aprcs1-zdsm = wa_l2-zdsm.
        wa_l1aprcs1-rm = wa_l2-rm.
        wa_l1aprcs1-zm = wa_l2-zm.
        collect wa_l1aprcs1 into it_l1aprcs1.
        clear wa_l1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
      if sy-subrc eq 0.
        wa_l1taprcs1-bzirk =  wa_l2-bzirk.
        wa_l1taprcs1-decsale =  ysd_dist_targt-month09.
        wa_l1taprcs1-zdsm = wa_l2-zdsm.
        wa_l1taprcs1-rm = wa_l2-rm.
        wa_l1taprcs1-zm = wa_l2-zm.
        collect wa_l1taprcs1 into it_l1taprcs1.
        clear wa_l1taprcs1.
      endif.

      if f9date le date2.
*      IF wa_l2-zjoin_date LE f9date.
        select single * from zcumpso where zmonth eq f9date+4(2) and zyear eq f9date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_aprcs1-bzirk =  wa_l2-bzirk.
          wa_aprcs1-decsale =  zcumpso-netval.
          wa_aprcs1-zdsm = wa_l2-zdsm.
          wa_aprcs1-rm = wa_l2-rm.
          wa_aprcs1-zm = wa_l2-zm.
          collect wa_aprcs1 into it_aprcs1.
          clear wa_aprcs1.
        endif.
        select single * from zrcumpso where zmonth eq ly_dt9+4(2) and zyear eq ly_dt9+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_laprcs1-bzirk =  wa_l2-bzirk.
          wa_laprcs1-decsale =  zrcumpso-netval.
          wa_laprcs1-zdsm = wa_l2-zdsm.
          wa_laprcs1-rm = wa_l2-rm.
          wa_laprcs1-zm = wa_l2-zm.
          collect wa_laprcs1 into it_laprcs1.
          clear wa_laprcs1.
        endif.

        select single * from zcumpso where zmonth eq f9date+4(2) and zyear eq f9date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_caprcs1-bzirk =  wa_l2-bzirk.
          wa_caprcs1-decsale =  zcumpso-netval.
          wa_caprcs1-zdsm = wa_l2-zdsm.
          wa_caprcs1-rm = wa_l2-rm.
          wa_caprcs1-zm = wa_l2-zm.
          collect wa_caprcs1 into it_caprcs1.
          clear wa_caprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
        if sy-subrc eq 0.
          wa_taprcs1-bzirk =  wa_l2-bzirk.
          wa_taprcs1-decsale =  ysd_dist_targt-month09.
          wa_taprcs1-zdsm = wa_l2-zdsm.
          wa_taprcs1-rm = wa_l2-rm.
          wa_taprcs1-zm = wa_l2-zm.
          collect wa_taprcs1 into it_taprcs1.
          clear wa_taprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
        if sy-subrc eq 0.
          wa_ltaprcs1-bzirk =  wa_l2-bzirk.
          wa_ltaprcs1-decsale =  ysd_dist_targt-month09.
          wa_ltaprcs1-zdsm = wa_l2-zdsm.
          wa_ltaprcs1-rm = wa_l2-rm.
          wa_ltaprcs1-zm = wa_l2-zm.
          collect wa_ltaprcs1 into it_ltaprcs1.
          clear wa_ltaprcs1.
        endif.
*      ENDIF.
      endif.

      if f9date le date2.
*      IF wa_l2-rjoin_date LE f9date.
        select single * from zrcumpso where zmonth eq f9date+4(2) and zyear eq f9date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_raprcs1-bzirk =  wa_l2-bzirk.
          wa_raprcs1-decsale =  zrcumpso-netval.
          wa_raprcs1-zdsm = wa_l2-zdsm.
          wa_raprcs1-rm = wa_l2-rm.
          wa_raprcs1-zm = wa_l2-zm.
          collect wa_raprcs1 into it_raprcs1.
          clear wa_raprcs1.
        endif.
        select single * from zrcumpso where zmonth eq ly_dt9+4(2) and zyear eq ly_dt9+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_rlaprcs1-bzirk =  wa_l2-bzirk.
          wa_rlaprcs1-decsale =  zrcumpso-netval.
          wa_rlaprcs1-zdsm = wa_l2-zdsm.
          wa_rlaprcs1-rm = wa_l2-rm.
          wa_rlaprcs1-zm = wa_l2-zm.
          collect wa_rlaprcs1 into it_rlaprcs1.
          clear wa_rlaprcs1.
        endif.
        select single * from zcumpso where zmonth eq f9date+4(2) and zyear eq f9date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_rcaprcs1-bzirk =  wa_l2-bzirk.
          wa_rcaprcs1-decsale =  zcumpso-netval.
          wa_rcaprcs1-zdsm = wa_l2-zdsm.
          wa_rcaprcs1-rm = wa_l2-rm.
          wa_rcaprcs1-zm = wa_l2-zm.
          collect wa_rcaprcs1 into it_rcaprcs1.
          clear wa_rcaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
        if sy-subrc eq 0.
          wa_rtaprcs1-bzirk =  wa_l2-bzirk.
          wa_rtaprcs1-decsale =  ysd_dist_targt-month09.
          wa_rtaprcs1-zdsm = wa_l2-zdsm.
          wa_rtaprcs1-rm = wa_l2-rm.
          wa_rtaprcs1-zm = wa_l2-zm.
          collect wa_rtaprcs1 into it_rtaprcs1.
          clear wa_rtaprcs1.
        endif.
*      ENDIF.
      endif.

      if f9date le date2.
        if wa_l2-join_date le f9date.
          select single * from zrcumpso where zmonth eq f9date+4(2) and zyear eq f9date+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_paprcs1-bzirk =  wa_l2-bzirk.
            wa_paprcs1-decsale =  zrcumpso-netval.
            wa_paprcs1-zdsm = wa_l2-zdsm.
            wa_paprcs1-rm = wa_l2-rm.
            wa_paprcs1-zm = wa_l2-zm.
            collect wa_paprcs1 into it_paprcs1.
            clear wa_paprcs1.
          endif.
          select single * from zrcumpso where zmonth eq ly_dt9+4(2) and zyear eq ly_dt9+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_plaprcs1-bzirk =  wa_l2-bzirk.
            wa_plaprcs1-decsale =  zrcumpso-netval.
            wa_plaprcs1-zdsm = wa_l2-zdsm.
            wa_plaprcs1-rm = wa_l2-rm.
            wa_plaprcs1-zm = wa_l2-zm.
            collect wa_plaprcs1 into it_plaprcs1.
            clear wa_plaprcs1.
          endif.
          select single * from zcumpso where zmonth eq f9date+4(2) and zyear eq f9date+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_pcaprcs1-bzirk =  wa_l2-bzirk.
            wa_pcaprcs1-decsale =  zcumpso-netval.
            wa_pcaprcs1-zdsm = wa_l2-zdsm.
            wa_pcaprcs1-rm = wa_l2-rm.
            wa_pcaprcs1-zm = wa_l2-zm.
            collect wa_pcaprcs1 into it_pcaprcs1.
            clear wa_pcaprcs1.
          endif.
          select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
          if sy-subrc eq 0.
            wa_ptaprcs1-bzirk =  wa_l2-bzirk.
            wa_ptaprcs1-decsale =  ysd_dist_targt-month09.
            wa_ptaprcs1-zdsm = wa_l2-zdsm.
            wa_ptaprcs1-rm = wa_l2-rm.
            wa_ptaprcs1-zm = wa_l2-zm.
            collect wa_ptaprcs1 into it_ptaprcs1.
            clear wa_ptaprcs1.
          endif.
        endif.
      endif.
    endif.

  endloop.



************ JAN *************************
  clear : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1,it_l2,wa_l2.
  select * from zdsmter into table it_zdsmter_l1 where zdsm in org and zmonth eq f10date+4(2) and zyear eq f10date+0(4).
  if sy-subrc eq 0.
    select * from zdsmter into table it_zdsmter_l2 for all entries in it_zdsmter_l1 where zdsm eq it_zdsmter_l1-bzirk and
      zmonth eq f10date+4(2) and zyear eq f10date+0(4).
  endif.
  loop at it_zdsmter_l2 into wa_zdsmter_l2 where zdsm+0(2) eq 'R-'.
    wa_l2-zmonth = wa_zdsmter_l2-zmonth.
    wa_l2-zyear = wa_zdsmter_l2-zyear.
    wa_l2-bzirk = wa_zdsmter_l2-bzirk.
    wa_l2-rm = wa_zdsmter_l2-zdsm.
    read table it_zdsmter_l2 into wa_zdsmter_l2 with key bzirk = wa_zdsmter_l2-zdsm zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_l2-zm = wa_zdsmter_l2-zdsm.
    endif.
    read table it_zdsmter_l1 into wa_zdsmter_l1 with key bzirk = wa_zdsmter_l2-zdsm.
    if sy-subrc eq 0.
      wa_l2-zdsm = wa_zdsmter_l1-zdsm.
    endif.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge date2.
    if sy-subrc eq 0.
      select single * from pa0001 where plans eq yterrallc-plans and endda ge date2.
      if sy-subrc eq 0.
        select single * from pa0302 where pernr eq pa0001-pernr and massn eq '01'.
        if sy-subrc eq 0.
          wa_l2-join_date = pa0302-begda.
        endif.
      endif.
    endif.
    collect wa_l2 into it_l2.
    clear wa_l2.
  endloop.

  loop at it_l2 into wa_l2.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge f10date.
    if sy-subrc eq 0.
      select single * from zrcumpso where zmonth eq ly_dt10+4(2) and zyear eq ly_dt10+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_l1aprcs1-bzirk =  wa_l2-bzirk.
        wa_l1aprcs1-jansale =  zrcumpso-netval.
        wa_l1aprcs1-zdsm = wa_l2-zdsm.
        wa_l1aprcs1-rm = wa_l2-rm.
        wa_l1aprcs1-zm = wa_l2-zm.
        collect wa_l1aprcs1 into it_l1aprcs1.
        clear wa_l1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
      if sy-subrc eq 0.
        wa_l1taprcs1-bzirk =  wa_l2-bzirk.
        wa_l1taprcs1-jansale =  ysd_dist_targt-month10.
        wa_l1taprcs1-zdsm = wa_l2-zdsm.
        wa_l1taprcs1-rm = wa_l2-rm.
        wa_l1taprcs1-zm = wa_l2-zm.
        collect wa_l1taprcs1 into it_l1taprcs1.
        clear wa_l1taprcs1.
      endif.

      if f10date le date2.
*      IF wa_l2-zjoin_date LE f10date.
        select single * from zcumpso where zmonth eq f10date+4(2) and zyear eq f10date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_aprcs1-bzirk =  wa_l2-bzirk.
          wa_aprcs1-jansale =  zcumpso-netval.
          wa_aprcs1-zdsm = wa_l2-zdsm.
          wa_aprcs1-rm = wa_l2-rm.
          wa_aprcs1-zm = wa_l2-zm.
          collect wa_aprcs1 into it_aprcs1.
          clear wa_aprcs1.
        endif.
        select single * from zrcumpso where zmonth eq ly_dt10+4(2) and zyear eq ly_dt10+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_laprcs1-bzirk =  wa_l2-bzirk.
          wa_laprcs1-jansale =  zrcumpso-netval.
          wa_laprcs1-zdsm = wa_l2-zdsm.
          wa_laprcs1-rm = wa_l2-rm.
          wa_laprcs1-zm = wa_l2-zm.
          collect wa_laprcs1 into it_laprcs1.
          clear wa_laprcs1.
        endif.

        select single * from zcumpso where zmonth eq f10date+4(2) and zyear eq f10date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_caprcs1-bzirk =  wa_l2-bzirk.
          wa_caprcs1-jansale =  zcumpso-netval.
          wa_caprcs1-zdsm = wa_l2-zdsm.
          wa_caprcs1-rm = wa_l2-rm.
          wa_caprcs1-zm = wa_l2-zm.
          collect wa_caprcs1 into it_caprcs1.
          clear wa_caprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
        if sy-subrc eq 0.
          wa_taprcs1-bzirk =  wa_l2-bzirk.
          wa_taprcs1-jansale =  ysd_dist_targt-month10.
          wa_taprcs1-zdsm = wa_l2-zdsm.
          wa_taprcs1-rm = wa_l2-rm.
          wa_taprcs1-zm = wa_l2-zm.
          collect wa_taprcs1 into it_taprcs1.
          clear wa_taprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
        if sy-subrc eq 0.
          wa_ltaprcs1-bzirk =  wa_l2-bzirk.
          wa_ltaprcs1-jansale =  ysd_dist_targt-month10.
          wa_ltaprcs1-zdsm = wa_l2-zdsm.
          wa_ltaprcs1-rm = wa_l2-rm.
          wa_ltaprcs1-zm = wa_l2-zm.
          collect wa_ltaprcs1 into it_ltaprcs1.
          clear wa_ltaprcs1.
        endif.
*      ENDIF.
      endif.

      if f10date le date2.
*      IF wa_l2-rjoin_date LE f10date.
        select single * from zrcumpso where zmonth eq f10date+4(2) and zyear eq f10date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_raprcs1-bzirk =  wa_l2-bzirk.
          wa_raprcs1-jansale =  zrcumpso-netval.
          wa_raprcs1-zdsm = wa_l2-zdsm.
          wa_raprcs1-rm = wa_l2-rm.
          wa_raprcs1-zm = wa_l2-zm.
          collect wa_raprcs1 into it_raprcs1.
          clear wa_raprcs1.
        endif.
        select single * from zrcumpso where zmonth eq ly_dt10+4(2) and zyear eq ly_dt10+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_rlaprcs1-bzirk =  wa_l2-bzirk.
          wa_rlaprcs1-jansale =  zrcumpso-netval.
          wa_rlaprcs1-zdsm = wa_l2-zdsm.
          wa_rlaprcs1-rm = wa_l2-rm.
          wa_rlaprcs1-zm = wa_l2-zm.
          collect wa_rlaprcs1 into it_rlaprcs1.
          clear wa_rlaprcs1.
        endif.
        select single * from zcumpso where zmonth eq f10date+4(2) and zyear eq f10date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_rcaprcs1-bzirk =  wa_l2-bzirk.
          wa_rcaprcs1-jansale =  zcumpso-netval.
          wa_rcaprcs1-zdsm = wa_l2-zdsm.
          wa_rcaprcs1-rm = wa_l2-rm.
          wa_rcaprcs1-zm = wa_l2-zm.
          collect wa_rcaprcs1 into it_rcaprcs1.
          clear wa_rcaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
        if sy-subrc eq 0.
          wa_rtaprcs1-bzirk =  wa_l2-bzirk.
          wa_rtaprcs1-jansale =  ysd_dist_targt-month10.
          wa_rtaprcs1-zdsm = wa_l2-zdsm.
          wa_rtaprcs1-rm = wa_l2-rm.
          wa_rtaprcs1-zm = wa_l2-zm.
          collect wa_rtaprcs1 into it_rtaprcs1.
          clear wa_rtaprcs1.
        endif.
*      ENDIF.
      endif.

      if f10date le date2.
        if wa_l2-join_date le f10date.
          select single * from zrcumpso where zmonth eq f10date+4(2) and zyear eq f10date+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_paprcs1-bzirk =  wa_l2-bzirk.
            wa_paprcs1-jansale =  zrcumpso-netval.
            wa_paprcs1-zdsm = wa_l2-zdsm.
            wa_paprcs1-rm = wa_l2-rm.
            wa_paprcs1-zm = wa_l2-zm.
            collect wa_paprcs1 into it_paprcs1.
            clear wa_paprcs1.
          endif.
          select single * from zrcumpso where zmonth eq ly_dt10+4(2) and zyear eq ly_dt10+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_plaprcs1-bzirk =  wa_l2-bzirk.
            wa_plaprcs1-jansale =  zrcumpso-netval.
            wa_plaprcs1-zdsm = wa_l2-zdsm.
            wa_plaprcs1-rm = wa_l2-rm.
            wa_plaprcs1-zm = wa_l2-zm.
            collect wa_plaprcs1 into it_plaprcs1.
            clear wa_plaprcs1.
          endif.
          select single * from zcumpso where zmonth eq f10date+4(2) and zyear eq f10date+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_pcaprcs1-bzirk =  wa_l2-bzirk.
            wa_pcaprcs1-jansale =  zcumpso-netval.
            wa_pcaprcs1-zdsm = wa_l2-zdsm.
            wa_pcaprcs1-rm = wa_l2-rm.
            wa_pcaprcs1-zm = wa_l2-zm.
            collect wa_pcaprcs1 into it_pcaprcs1.
            clear wa_pcaprcs1.
          endif.
          select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
          if sy-subrc eq 0.
            wa_ptaprcs1-bzirk =  wa_l2-bzirk.
            wa_ptaprcs1-jansale =  ysd_dist_targt-month10.
            wa_ptaprcs1-zdsm = wa_l2-zdsm.
            wa_ptaprcs1-rm = wa_l2-rm.
            wa_ptaprcs1-zm = wa_l2-zm.
            collect wa_ptaprcs1 into it_ptaprcs1.
            clear wa_ptaprcs1.
          endif.
        endif.
      endif.
    endif.
  endloop.



************ FEB *************************
  clear : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1,it_l2,wa_l2.
  select * from zdsmter into table it_zdsmter_l1 where zdsm in org and zmonth eq f11date+4(2) and zyear eq f11date+0(4).
  if sy-subrc eq 0.
    select * from zdsmter into table it_zdsmter_l2 for all entries in it_zdsmter_l1 where zdsm eq it_zdsmter_l1-bzirk and
      zmonth eq f11date+4(2) and zyear eq f11date+0(4).
  endif.
  loop at it_zdsmter_l2 into wa_zdsmter_l2 where zdsm+0(2) eq 'R-'.
    wa_l2-zmonth = wa_zdsmter_l2-zmonth.
    wa_l2-zyear = wa_zdsmter_l2-zyear.
    wa_l2-bzirk = wa_zdsmter_l2-bzirk.
    wa_l2-rm = wa_zdsmter_l2-zdsm.
    read table it_zdsmter_l2 into wa_zdsmter_l2 with key bzirk = wa_zdsmter_l2-zdsm zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_l2-zm = wa_zdsmter_l2-zdsm.
    endif.
    read table it_zdsmter_l1 into wa_zdsmter_l1 with key bzirk = wa_zdsmter_l2-zdsm.
    if sy-subrc eq 0.
      wa_l2-zdsm = wa_zdsmter_l1-zdsm.
    endif.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge date2.
    if sy-subrc eq 0.
      select single * from pa0001 where plans eq yterrallc-plans and endda ge date2.
      if sy-subrc eq 0.
        select single * from pa0302 where pernr eq pa0001-pernr and massn eq '01'.
        if sy-subrc eq 0.
          wa_l2-join_date = pa0302-begda.
        endif.
      endif.
    endif.
    collect wa_l2 into it_l2.
    clear wa_l2.
  endloop.

  loop at it_l2 into wa_l2.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge f11date.
    if sy-subrc eq 0.
      select single * from zrcumpso where zmonth eq ly_dt11+4(2) and zyear eq ly_dt11+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_l1aprcs1-bzirk =  wa_l2-bzirk.
        wa_l1aprcs1-febsale =  zrcumpso-netval.
        wa_l1aprcs1-zdsm = wa_l2-zdsm.
        wa_l1aprcs1-rm = wa_l2-rm.
        wa_l1aprcs1-zm = wa_l2-zm.
        collect wa_l1aprcs1 into it_l1aprcs1.
        clear wa_l1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
      if sy-subrc eq 0.
        wa_l1taprcs1-bzirk =  wa_l2-bzirk.
        wa_l1taprcs1-febsale =  ysd_dist_targt-month11.
        wa_l1taprcs1-zdsm = wa_l2-zdsm.
        wa_l1taprcs1-rm = wa_l2-rm.
        wa_l1taprcs1-zm = wa_l2-zm.
        collect wa_l1taprcs1 into it_l1taprcs1.
        clear wa_l1taprcs1.
      endif.

      if f11date le date2.
*      IF wa_l2-zjoin_date LE f11date.
        select single * from zcumpso where zmonth eq f11date+4(2) and zyear eq f11date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_aprcs1-bzirk =  wa_l2-bzirk.
          wa_aprcs1-febsale =  zcumpso-netval.
          wa_aprcs1-zdsm = wa_l2-zdsm.
          wa_aprcs1-rm = wa_l2-rm.
          wa_aprcs1-zm = wa_l2-zm.
          collect wa_aprcs1 into it_aprcs1.
          clear wa_aprcs1.
        endif.
        select single * from zrcumpso where zmonth eq ly_dt11+4(2) and zyear eq ly_dt11+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_laprcs1-bzirk =  wa_l2-bzirk.
          wa_laprcs1-febsale =  zrcumpso-netval.
          wa_laprcs1-zdsm = wa_l2-zdsm.
          wa_laprcs1-rm = wa_l2-rm.
          wa_laprcs1-zm = wa_l2-zm.
          collect wa_laprcs1 into it_laprcs1.
          clear wa_laprcs1.
        endif.

        select single * from zcumpso where zmonth eq f11date+4(2) and zyear eq f11date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_caprcs1-bzirk =  wa_l2-bzirk.
          wa_caprcs1-febsale =  zcumpso-netval.
          wa_caprcs1-zdsm = wa_l2-zdsm.
          wa_caprcs1-rm = wa_l2-rm.
          wa_caprcs1-zm = wa_l2-zm.
          collect wa_caprcs1 into it_caprcs1.
          clear wa_caprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
        if sy-subrc eq 0.
          wa_taprcs1-bzirk =  wa_l2-bzirk.
          wa_taprcs1-febsale =  ysd_dist_targt-month11.
          wa_taprcs1-zdsm = wa_l2-zdsm.
          wa_taprcs1-rm = wa_l2-rm.
          wa_taprcs1-zm = wa_l2-zm.
          collect wa_taprcs1 into it_taprcs1.
          clear wa_taprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
        if sy-subrc eq 0.
          wa_ltaprcs1-bzirk =  wa_l2-bzirk.
          wa_ltaprcs1-febsale =  ysd_dist_targt-month11.
          wa_ltaprcs1-zdsm = wa_l2-zdsm.
          wa_ltaprcs1-rm = wa_l2-rm.
          wa_ltaprcs1-zm = wa_l2-zm.
          collect wa_ltaprcs1 into it_ltaprcs1.
          clear wa_ltaprcs1.
        endif.
*      ENDIF.
      endif.

      if f11date le date2.
*      IF wa_l2-rjoin_date LE f11date.
        select single * from zrcumpso where zmonth eq f11date+4(2) and zyear eq f11date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_raprcs1-bzirk =  wa_l2-bzirk.
          wa_raprcs1-febsale =  zrcumpso-netval.
          wa_raprcs1-zdsm = wa_l2-zdsm.
          wa_raprcs1-rm = wa_l2-rm.
          wa_raprcs1-zm = wa_l2-zm.
          collect wa_raprcs1 into it_raprcs1.
          clear wa_raprcs1.
        endif.
        select single * from zrcumpso where zmonth eq ly_dt11+4(2) and zyear eq ly_dt11+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_rlaprcs1-bzirk =  wa_l2-bzirk.
          wa_rlaprcs1-febsale =  zrcumpso-netval.
          wa_rlaprcs1-zdsm = wa_l2-zdsm.
          wa_rlaprcs1-rm = wa_l2-rm.
          wa_rlaprcs1-zm = wa_l2-zm.
          collect wa_rlaprcs1 into it_rlaprcs1.
          clear wa_rlaprcs1.
        endif.
        select single * from zcumpso where zmonth eq f11date+4(2) and zyear eq f11date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_rcaprcs1-bzirk =  wa_l2-bzirk.
          wa_rcaprcs1-febsale =  zcumpso-netval.
          wa_rcaprcs1-zdsm = wa_l2-zdsm.
          wa_rcaprcs1-rm = wa_l2-rm.
          wa_rcaprcs1-zm = wa_l2-zm.
          collect wa_rcaprcs1 into it_rcaprcs1.
          clear wa_rcaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
        if sy-subrc eq 0.
          wa_rtaprcs1-bzirk =  wa_l2-bzirk.
          wa_rtaprcs1-febsale =  ysd_dist_targt-month11.
          wa_rtaprcs1-zdsm = wa_l2-zdsm.
          wa_rtaprcs1-rm = wa_l2-rm.
          wa_rtaprcs1-zm = wa_l2-zm.
          collect wa_rtaprcs1 into it_rtaprcs1.
          clear wa_rtaprcs1.
        endif.
*      ENDIF.
      endif.

      if f11date le date2.
        if wa_l2-join_date le f11date.
          select single * from zrcumpso where zmonth eq f11date+4(2) and zyear eq f11date+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_paprcs1-bzirk =  wa_l2-bzirk.
            wa_paprcs1-febsale =  zrcumpso-netval.
            wa_paprcs1-zdsm = wa_l2-zdsm.
            wa_paprcs1-rm = wa_l2-rm.
            wa_paprcs1-zm = wa_l2-zm.
            collect wa_paprcs1 into it_paprcs1.
            clear wa_paprcs1.
          endif.
          select single * from zrcumpso where zmonth eq ly_dt11+4(2) and zyear eq ly_dt11+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_plaprcs1-bzirk =  wa_l2-bzirk.
            wa_plaprcs1-febsale =  zrcumpso-netval.
            wa_plaprcs1-zdsm = wa_l2-zdsm.
            wa_plaprcs1-rm = wa_l2-rm.
            wa_plaprcs1-zm = wa_l2-zm.
            collect wa_plaprcs1 into it_plaprcs1.
            clear wa_plaprcs1.
          endif.
          select single * from zcumpso where zmonth eq f11date+4(2) and zyear eq f11date+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_pcaprcs1-bzirk =  wa_l2-bzirk.
            wa_pcaprcs1-febsale =  zcumpso-netval.
            wa_pcaprcs1-zdsm = wa_l2-zdsm.
            wa_pcaprcs1-rm = wa_l2-rm.
            wa_pcaprcs1-zm = wa_l2-zm.
            collect wa_pcaprcs1 into it_pcaprcs1.
            clear wa_pcaprcs1.
          endif.
          select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
          if sy-subrc eq 0.
            wa_ptaprcs1-bzirk =  wa_l2-bzirk.
            wa_ptaprcs1-febsale =  ysd_dist_targt-month11.
            wa_ptaprcs1-zdsm = wa_l2-zdsm.
            wa_ptaprcs1-rm = wa_l2-rm.
            wa_ptaprcs1-zm = wa_l2-zm.
            collect wa_ptaprcs1 into it_ptaprcs1.
            clear wa_ptaprcs1.
          endif.
        endif.
      endif.
    endif.

  endloop.


************ MAR *************************
  clear : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1,it_l2,wa_l2.
  select * from zdsmter into table it_zdsmter_l1 where zdsm in org and zmonth eq f12date+4(2) and zyear eq f12date+0(4).
  if sy-subrc eq 0.
    select * from zdsmter into table it_zdsmter_l2 for all entries in it_zdsmter_l1 where zdsm eq it_zdsmter_l1-bzirk and
      zmonth eq f12date+4(2) and zyear eq f12date+0(4).
  endif.
  loop at it_zdsmter_l2 into wa_zdsmter_l2 where zdsm+0(2) eq 'R-'.
    wa_l2-zmonth = wa_zdsmter_l2-zmonth.
    wa_l2-zyear = wa_zdsmter_l2-zyear.
    wa_l2-bzirk = wa_zdsmter_l2-bzirk.
    wa_l2-rm = wa_zdsmter_l2-zdsm.
    read table it_zdsmter_l2 into wa_zdsmter_l2 with key bzirk = wa_zdsmter_l2-zdsm zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_l2-zm = wa_zdsmter_l2-zdsm.
    endif.
    read table it_zdsmter_l1 into wa_zdsmter_l1 with key bzirk = wa_zdsmter_l2-zdsm.
    if sy-subrc eq 0.
      wa_l2-zdsm = wa_zdsmter_l1-zdsm.
    endif.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge date2.
    if sy-subrc eq 0.
      select single * from pa0001 where plans eq yterrallc-plans and endda ge date2.
      if sy-subrc eq 0.
        select single * from pa0302 where pernr eq pa0001-pernr and massn eq '01'.
        if sy-subrc eq 0.
          wa_l2-join_date = pa0302-begda.
        endif.
      endif.
    endif.
    collect wa_l2 into it_l2.
    clear wa_l2.
  endloop.

  loop at it_l2 into wa_l2.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge f12date.
    if sy-subrc eq 0.
      select single * from zrcumpso where zmonth eq ly_dt12+4(2) and zyear eq ly_dt12+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_l1aprcs1-bzirk =  wa_l2-bzirk.
        wa_l1aprcs1-marsale =  zrcumpso-netval.
        wa_l1aprcs1-zdsm = wa_l2-zdsm.
        wa_l1aprcs1-rm = wa_l2-rm.
        wa_l1aprcs1-zm = wa_l2-zm.
        collect wa_l1aprcs1 into it_l1aprcs1.
        clear wa_l1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
      if sy-subrc eq 0.
        wa_l1taprcs1-bzirk =  wa_l2-bzirk.
        wa_l1taprcs1-marsale =  ysd_dist_targt-month12.
        wa_l1taprcs1-zdsm = wa_l2-zdsm.
        wa_l1taprcs1-rm = wa_l2-rm.
        wa_l1taprcs1-zm = wa_l2-zm.
        collect wa_l1taprcs1 into it_l1taprcs1.
        clear wa_l1taprcs1.
      endif.

      if f12date le date2.
*      IF wa_l2-zjoin_date LE f12date.
        select single * from zcumpso where zmonth eq f12date+4(2) and zyear eq f12date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_aprcs1-bzirk =  wa_l2-bzirk.
          wa_aprcs1-marsale =  zcumpso-netval.
          wa_aprcs1-zdsm = wa_l2-zdsm.
          wa_aprcs1-rm = wa_l2-rm.
          wa_aprcs1-zm = wa_l2-zm.
          collect wa_aprcs1 into it_aprcs1.
          clear wa_aprcs1.
        endif.
        select single * from zrcumpso where zmonth eq ly_dt12+4(2) and zyear eq ly_dt12+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_laprcs1-bzirk =  wa_l2-bzirk.
          wa_laprcs1-marsale =  zrcumpso-netval.
          wa_laprcs1-zdsm = wa_l2-zdsm.
          wa_laprcs1-rm = wa_l2-rm.
          wa_laprcs1-zm = wa_l2-zm.
          collect wa_laprcs1 into it_laprcs1.
          clear wa_laprcs1.
        endif.

        select single * from zcumpso where zmonth eq f12date+4(2) and zyear eq f12date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_caprcs1-bzirk =  wa_l2-bzirk.
          wa_caprcs1-marsale =  zcumpso-netval.
          wa_caprcs1-zdsm = wa_l2-zdsm.
          wa_caprcs1-rm = wa_l2-rm.
          wa_caprcs1-zm = wa_l2-zm.
          collect wa_caprcs1 into it_caprcs1.
          clear wa_caprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
        if sy-subrc eq 0.
          wa_taprcs1-bzirk =  wa_l2-bzirk.
          wa_taprcs1-marsale =  ysd_dist_targt-month12.
          wa_taprcs1-zdsm = wa_l2-zdsm.
          wa_taprcs1-rm = wa_l2-rm.
          wa_taprcs1-zm = wa_l2-zm.
          collect wa_taprcs1 into it_taprcs1.
          clear wa_taprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
        if sy-subrc eq 0.
          wa_ltaprcs1-bzirk =  wa_l2-bzirk.
          wa_ltaprcs1-marsale =  ysd_dist_targt-month12.
          wa_ltaprcs1-zdsm = wa_l2-zdsm.
          wa_ltaprcs1-rm = wa_l2-rm.
          wa_ltaprcs1-zm = wa_l2-zm.
          collect wa_ltaprcs1 into it_ltaprcs1.
          clear wa_ltaprcs1.
        endif.
*      ENDIF.
      endif.

      if f12date le date2.
*      IF wa_l2-rjoin_date LE f12date.
        select single * from zrcumpso where zmonth eq f12date+4(2) and zyear eq f12date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_raprcs1-bzirk =  wa_l2-bzirk.
          wa_raprcs1-marsale =  zrcumpso-netval.
          wa_raprcs1-zdsm = wa_l2-zdsm.
          wa_raprcs1-rm = wa_l2-rm.
          wa_raprcs1-zm = wa_l2-zm.
          collect wa_raprcs1 into it_raprcs1.
          clear wa_raprcs1.
        endif.
        select single * from zrcumpso where zmonth eq ly_dt12+4(2) and zyear eq ly_dt12+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_rlaprcs1-bzirk =  wa_l2-bzirk.
          wa_rlaprcs1-marsale =  zrcumpso-netval.
          wa_rlaprcs1-zdsm = wa_l2-zdsm.
          wa_rlaprcs1-rm = wa_l2-rm.
          wa_rlaprcs1-zm = wa_l2-zm.
          collect wa_rlaprcs1 into it_rlaprcs1.
          clear wa_rlaprcs1.
        endif.
        select single * from zcumpso where zmonth eq f12date+4(2) and zyear eq f12date+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_rcaprcs1-bzirk =  wa_l2-bzirk.
          wa_rcaprcs1-marsale =  zcumpso-netval.
          wa_rcaprcs1-zdsm = wa_l2-zdsm.
          wa_rcaprcs1-rm = wa_l2-rm.
          wa_rcaprcs1-zm = wa_l2-zm.
          collect wa_rcaprcs1 into it_rcaprcs1.
          clear wa_rcaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
        if sy-subrc eq 0.
          wa_rtaprcs1-bzirk =  wa_l2-bzirk.
          wa_rtaprcs1-marsale =  ysd_dist_targt-month12.
          wa_rtaprcs1-zdsm = wa_l2-zdsm.
          wa_rtaprcs1-rm = wa_l2-rm.
          wa_rtaprcs1-zm = wa_l2-zm.
          collect wa_rtaprcs1 into it_rtaprcs1.
          clear wa_rtaprcs1.
        endif.
*      ENDIF.
      endif.

      if f12date le date2.
        if wa_l2-join_date le f12date.
          select single * from zrcumpso where zmonth eq f12date+4(2) and zyear eq f12date+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_paprcs1-bzirk =  wa_l2-bzirk.
            wa_paprcs1-marsale =  zrcumpso-netval.
            wa_paprcs1-zdsm = wa_l2-zdsm.
            wa_paprcs1-rm = wa_l2-rm.
            wa_paprcs1-zm = wa_l2-zm.
            collect wa_paprcs1 into it_paprcs1.
            clear wa_paprcs1.
          endif.
          select single * from zrcumpso where zmonth eq ly_dt12+4(2) and zyear eq ly_dt12+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_plaprcs1-bzirk =  wa_l2-bzirk.
            wa_plaprcs1-marsale =  zrcumpso-netval.
            wa_plaprcs1-zdsm = wa_l2-zdsm.
            wa_plaprcs1-rm = wa_l2-rm.
            wa_plaprcs1-zm = wa_l2-zm.
            collect wa_plaprcs1 into it_plaprcs1.
            clear wa_plaprcs1.
          endif.
          select single * from zcumpso where zmonth eq f12date+4(2) and zyear eq f12date+0(4) and bzirk eq wa_l2-bzirk.
          if sy-subrc eq 0.
            wa_pcaprcs1-bzirk =  wa_l2-bzirk.
            wa_pcaprcs1-marsale =  zcumpso-netval.
            wa_pcaprcs1-zdsm = wa_l2-zdsm.
            wa_pcaprcs1-rm = wa_l2-rm.
            wa_pcaprcs1-zm = wa_l2-zm.
            collect wa_pcaprcs1 into it_pcaprcs1.
            clear wa_pcaprcs1.
          endif.
          select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq cyear.
          if sy-subrc eq 0.
            wa_ptaprcs1-bzirk =  wa_l2-bzirk.
            wa_ptaprcs1-marsale =  ysd_dist_targt-month12.
            wa_ptaprcs1-zdsm = wa_l2-zdsm.
            wa_ptaprcs1-rm = wa_l2-rm.
            wa_ptaprcs1-zm = wa_l2-zm.
            collect wa_ptaprcs1 into it_ptaprcs1.
            clear wa_ptaprcs1.
          endif.
        endif.
      endif.
    endif.

  endloop.



************************************** CALCULATE LAST YEAR SALE FROM ZRCUMPSO " 20.6.24

  clear : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1,it_l2,wa_l2.
  select * from zdsmter into table it_zdsmter_l1 where zdsm in org and zmonth eq sy-datum+4(2) and zyear eq sy-datum+0(4).
  if sy-subrc eq 0.
    select * from zdsmter into table it_zdsmter_l2 for all entries in it_zdsmter_l1 where zdsm eq it_zdsmter_l1-bzirk and
      zmonth eq sy-datum+4(2) and zyear eq sy-datum+0(4).
  endif.
  loop at it_zdsmter_l2 into wa_zdsmter_l2 where zdsm+0(2) eq 'R-'.
    wa_l2-zmonth = wa_zdsmter_l2-zmonth.
    wa_l2-zyear = wa_zdsmter_l2-zyear.
    wa_l2-bzirk = wa_zdsmter_l2-bzirk.
    wa_l2-rm = wa_zdsmter_l2-zdsm.
    read table it_zdsmter_l2 into wa_zdsmter_l2 with key bzirk = wa_zdsmter_l2-zdsm zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_l2-zm = wa_zdsmter_l2-zdsm.
    endif.
    read table it_zdsmter_l1 into wa_zdsmter_l1 with key bzirk = wa_zdsmter_l2-zdsm.
    if sy-subrc eq 0.
      wa_l2-zdsm = wa_zdsmter_l1-zdsm.
    endif.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge date2.
    if sy-subrc eq 0.
      select single * from pa0001 where plans eq yterrallc-plans and endda ge date2.
      if sy-subrc eq 0.
        select single * from pa0302 where pernr eq pa0001-pernr and massn eq '01'.
        if sy-subrc eq 0.
          wa_l2-join_date = pa0302-begda.
        endif.
      endif.
    endif.
    collect wa_l2 into it_l2.
    clear wa_l2.
  endloop.

  loop at it_l2 into wa_l2.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge sy-datum.
    if sy-subrc eq 0.
      select single * from zrcumpso where zmonth eq ly_dt1+4(2) and zyear eq ly_dt1+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_nl1aprcs1-bzirk =  wa_l2-bzirk.
        wa_nl1aprcs1-aprsale =  zrcumpso-netval.
        wa_nl1aprcs1-zdsm = wa_l2-zdsm.
        wa_nl1aprcs1-rm = wa_l2-rm.
        wa_nl1aprcs1-zm = wa_l2-zm.
        collect wa_nl1aprcs1 into it_nl1aprcs1.
        clear wa_nl1aprcs1.
      endif.
      select single * from zrcumpso where zmonth eq ly_dt2+4(2) and zyear eq ly_dt2+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_nl1aprcs1-bzirk =  wa_l2-bzirk.
        wa_nl1aprcs1-maysale =  zrcumpso-netval.
        wa_nl1aprcs1-zdsm = wa_l2-zdsm.
        wa_nl1aprcs1-rm = wa_l2-rm.
        wa_nl1aprcs1-zm = wa_l2-zm.
        collect wa_nl1aprcs1 into it_nl1aprcs1.
        clear wa_nl1aprcs1.
      endif.
      select single * from zrcumpso where zmonth eq ly_dt3+4(2) and zyear eq ly_dt3+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_nl1aprcs1-bzirk =  wa_l2-bzirk.
        wa_nl1aprcs1-junsale =  zrcumpso-netval.
        wa_nl1aprcs1-zdsm = wa_l2-zdsm.
        wa_nl1aprcs1-rm = wa_l2-rm.
        wa_nl1aprcs1-zm = wa_l2-zm.
        collect wa_nl1aprcs1 into it_nl1aprcs1.
        clear wa_nl1aprcs1.
      endif.

      select single * from zrcumpso where zmonth eq ly_dt4+4(2) and zyear eq ly_dt4+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_nl1aprcs1-bzirk =  wa_l2-bzirk.
        wa_nl1aprcs1-julsale =  zrcumpso-netval.
        wa_nl1aprcs1-zdsm = wa_l2-zdsm.
        wa_nl1aprcs1-rm = wa_l2-rm.
        wa_nl1aprcs1-zm = wa_l2-zm.
        collect wa_nl1aprcs1 into it_nl1aprcs1.
        clear wa_nl1aprcs1.
      endif.

      select single * from zrcumpso where zmonth eq ly_dt5+4(2) and zyear eq ly_dt5+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_nl1aprcs1-bzirk =  wa_l2-bzirk.
        wa_nl1aprcs1-augsale =  zrcumpso-netval.
        wa_nl1aprcs1-zdsm = wa_l2-zdsm.
        wa_nl1aprcs1-rm = wa_l2-rm.
        wa_nl1aprcs1-zm = wa_l2-zm.
        collect wa_nl1aprcs1 into it_nl1aprcs1.
        clear wa_nl1aprcs1.
      endif.

      select single * from zrcumpso where zmonth eq ly_dt6+4(2) and zyear eq ly_dt6+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_nl1aprcs1-bzirk =  wa_l2-bzirk.
        wa_nl1aprcs1-sepsale =  zrcumpso-netval.
        wa_nl1aprcs1-zdsm = wa_l2-zdsm.
        wa_nl1aprcs1-rm = wa_l2-rm.
        wa_nl1aprcs1-zm = wa_l2-zm.
        collect wa_nl1aprcs1 into it_nl1aprcs1.
        clear wa_nl1aprcs1.
      endif.

      select single * from zrcumpso where zmonth eq ly_dt7+4(2) and zyear eq ly_dt7+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_nl1aprcs1-bzirk =  wa_l2-bzirk.
        wa_nl1aprcs1-octsale =  zrcumpso-netval.
        wa_nl1aprcs1-zdsm = wa_l2-zdsm.
        wa_nl1aprcs1-rm = wa_l2-rm.
        wa_nl1aprcs1-zm = wa_l2-zm.
        collect wa_nl1aprcs1 into it_nl1aprcs1.
        clear wa_nl1aprcs1.
      endif.

      select single * from zrcumpso where zmonth eq ly_dt8+4(2) and zyear eq ly_dt8+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_nl1aprcs1-bzirk =  wa_l2-bzirk.
        wa_nl1aprcs1-novsale =  zrcumpso-netval.
        wa_nl1aprcs1-zdsm = wa_l2-zdsm.
        wa_nl1aprcs1-rm = wa_l2-rm.
        wa_nl1aprcs1-zm = wa_l2-zm.
        collect wa_nl1aprcs1 into it_nl1aprcs1.
        clear wa_nl1aprcs1.
      endif.

      select single * from zrcumpso where zmonth eq ly_dt9+4(2) and zyear eq ly_dt9+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_nl1aprcs1-bzirk =  wa_l2-bzirk.
        wa_nl1aprcs1-decsale =  zrcumpso-netval.
        wa_nl1aprcs1-zdsm = wa_l2-zdsm.
        wa_nl1aprcs1-rm = wa_l2-rm.
        wa_nl1aprcs1-zm = wa_l2-zm.
        collect wa_nl1aprcs1 into it_nl1aprcs1.
        clear wa_nl1aprcs1.
      endif.

      select single * from zrcumpso where zmonth eq ly_dt10+4(2) and zyear eq ly_dt10+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_nl1aprcs1-bzirk =  wa_l2-bzirk.
        wa_nl1aprcs1-jansale =  zrcumpso-netval.
        wa_nl1aprcs1-zdsm = wa_l2-zdsm.
        wa_nl1aprcs1-rm = wa_l2-rm.
        wa_nl1aprcs1-zm = wa_l2-zm.
        collect wa_nl1aprcs1 into it_nl1aprcs1.
        clear wa_nl1aprcs1.
      endif.
      select single * from zrcumpso where zmonth eq ly_dt11+4(2) and zyear eq ly_dt11+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_nl1aprcs1-bzirk =  wa_l2-bzirk.
        wa_nl1aprcs1-febsale =  zrcumpso-netval.
        wa_nl1aprcs1-zdsm = wa_l2-zdsm.
        wa_nl1aprcs1-rm = wa_l2-rm.
        wa_nl1aprcs1-zm = wa_l2-zm.
        collect wa_nl1aprcs1 into it_nl1aprcs1.
        clear wa_nl1aprcs1.
      endif.

      select single * from zrcumpso where zmonth eq ly_dt12+4(2) and zyear eq ly_dt12+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_nl1aprcs1-bzirk =  wa_l2-bzirk.
        wa_nl1aprcs1-marsale =  zrcumpso-netval.
        wa_nl1aprcs1-zdsm = wa_l2-zdsm.
        wa_nl1aprcs1-rm = wa_l2-rm.
        wa_nl1aprcs1-zm = wa_l2-zm.
        collect wa_nl1aprcs1 into it_nl1aprcs1.
        clear wa_nl1aprcs1.
      endif.


    endif.

  endloop.

  loop at it_nl1aprcs1 into wa_nl1aprcs1.
    wa_n1l1aprcs1-bzirk = wa_nl1aprcs1-zdsm.
    wa_n1l1aprcs1-aprsale = wa_nl1aprcs1-aprsale.
    wa_n1l1aprcs1-maysale = wa_nl1aprcs1-maysale.
    wa_n1l1aprcs1-junsale = wa_nl1aprcs1-junsale.
    wa_n1l1aprcs1-julsale = wa_nl1aprcs1-julsale.
    wa_n1l1aprcs1-augsale = wa_nl1aprcs1-augsale.
    wa_n1l1aprcs1-sepsale = wa_nl1aprcs1-sepsale.
    wa_n1l1aprcs1-octsale = wa_nl1aprcs1-octsale.
    wa_n1l1aprcs1-novsale = wa_nl1aprcs1-novsale.
    wa_n1l1aprcs1-decsale = wa_nl1aprcs1-decsale.
    wa_n1l1aprcs1-jansale = wa_nl1aprcs1-jansale.
    wa_n1l1aprcs1-febsale = wa_nl1aprcs1-febsale.
    wa_n1l1aprcs1-marsale = wa_nl1aprcs1-marsale.
    collect  wa_n1l1aprcs1 into  it_n1l1aprcs1.
    clear : wa_n1l1aprcs1.
  endloop.

  loop at it_nl1aprcs1 into wa_nl1aprcs1.
    wa_r1l1aprcs1-bzirk = wa_nl1aprcs1-rm.
    wa_r1l1aprcs1-aprsale = wa_nl1aprcs1-aprsale.
    wa_r1l1aprcs1-maysale = wa_nl1aprcs1-maysale.
    wa_r1l1aprcs1-junsale = wa_nl1aprcs1-junsale.
    wa_r1l1aprcs1-julsale = wa_nl1aprcs1-julsale.
    wa_r1l1aprcs1-augsale = wa_nl1aprcs1-augsale.
    wa_r1l1aprcs1-sepsale = wa_nl1aprcs1-sepsale.
    wa_r1l1aprcs1-octsale = wa_nl1aprcs1-octsale.
    wa_r1l1aprcs1-novsale = wa_nl1aprcs1-novsale.
    wa_r1l1aprcs1-decsale = wa_nl1aprcs1-decsale.
    wa_r1l1aprcs1-jansale = wa_nl1aprcs1-jansale.
    wa_r1l1aprcs1-febsale = wa_nl1aprcs1-febsale.
    wa_r1l1aprcs1-marsale = wa_nl1aprcs1-marsale.
    collect  wa_r1l1aprcs1 into  it_r1l1aprcs1.
    clear : wa_r1l1aprcs1.
  endloop.


  loop at it_nl1aprcs1 into wa_nl1aprcs1.
    wa_z1l1aprcs1-bzirk = wa_nl1aprcs1-zm.
    wa_z1l1aprcs1-aprsale = wa_nl1aprcs1-aprsale.
    wa_z1l1aprcs1-maysale = wa_nl1aprcs1-maysale.
    wa_z1l1aprcs1-junsale = wa_nl1aprcs1-junsale.
    wa_z1l1aprcs1-julsale = wa_nl1aprcs1-julsale.
    wa_z1l1aprcs1-augsale = wa_nl1aprcs1-augsale.
    wa_z1l1aprcs1-sepsale = wa_nl1aprcs1-sepsale.
    wa_z1l1aprcs1-octsale = wa_nl1aprcs1-octsale.
    wa_z1l1aprcs1-novsale = wa_nl1aprcs1-novsale.
    wa_z1l1aprcs1-decsale = wa_nl1aprcs1-decsale.
    wa_z1l1aprcs1-jansale = wa_nl1aprcs1-jansale.
    wa_z1l1aprcs1-febsale = wa_nl1aprcs1-febsale.
    wa_z1l1aprcs1-marsale = wa_nl1aprcs1-marsale.
    collect  wa_z1l1aprcs1 into  it_z1l1aprcs1.
    clear : wa_z1l1aprcs1.
  endloop.






***************************************************************************

  loop at it_aprcs1 into wa_aprcs1.
    wa_cums-bzirk = wa_aprcs1-zdsm.
    wa_cums-sale = wa_aprcs1-aprsale + wa_aprcs1-maysale + wa_aprcs1-junsale + wa_aprcs1-julsale + wa_aprcs1-augsale + wa_aprcs1-sepsale +
    wa_aprcs1-octsale + wa_aprcs1-novsale + wa_aprcs1-decsale + wa_aprcs1-jansale + wa_aprcs1-febsale + wa_aprcs1-marsale.
    collect wa_cums into it_cums.
    clear wa_cums.
  endloop.

  loop at it_aprcs1 into wa_aprcs1.
    select single * from zdsmter where zmonth eq month and zyear eq year and bzirk eq wa_aprcs1-zdsm.
    if sy-subrc eq 0.
      wa_smcums-bzirk = zdsmter-zdsm.
    endif.
    wa_smcums-sale = wa_aprcs1-aprsale + wa_aprcs1-maysale + wa_aprcs1-junsale + wa_aprcs1-julsale + wa_aprcs1-augsale + wa_aprcs1-sepsale +
    wa_aprcs1-octsale + wa_aprcs1-novsale + wa_aprcs1-decsale + wa_aprcs1-jansale + wa_aprcs1-febsale + wa_aprcs1-marsale.
    collect wa_smcums into it_smcums.
    clear wa_smcums.
  endloop.


  loop at it_aprcs1 into wa_aprcs1.
    wa_rrcums-bzirk = wa_aprcs1-rm.
    wa_rrcums-aprsale = wa_aprcs1-aprsale.
    wa_rrcums-maysale = wa_aprcs1-maysale.
    wa_rrcums-junsale = wa_aprcs1-junsale.
    wa_rrcums-julsale = wa_aprcs1-julsale.
    wa_rrcums-augsale = wa_aprcs1-augsale.
    wa_rrcums-sepsale = wa_aprcs1-sepsale.
    wa_rrcums-octsale = wa_aprcs1-octsale.
    wa_rrcums-novsale = wa_aprcs1-novsale.
    wa_rrcums-decsale = wa_aprcs1-decsale.
    wa_rrcums-jansale = wa_aprcs1-jansale.
    wa_rrcums-febsale = wa_aprcs1-febsale.
    wa_rrcums-marsale = wa_aprcs1-marsale.
    collect wa_rrcums into it_rrcums.
    clear wa_rrcums.
  endloop.

  loop at it_aprcs1 into wa_aprcs1.
    wa_zzcums-bzirk = wa_aprcs1-zm.
    wa_zzcums-aprsale = wa_aprcs1-aprsale.
    wa_zzcums-maysale = wa_aprcs1-maysale.
    wa_zzcums-junsale = wa_aprcs1-junsale.
    wa_zzcums-julsale = wa_aprcs1-julsale.
    wa_zzcums-augsale = wa_aprcs1-augsale.
    wa_zzcums-sepsale = wa_aprcs1-sepsale.
    wa_zzcums-octsale = wa_aprcs1-octsale.
    wa_zzcums-novsale = wa_aprcs1-novsale.
    wa_zzcums-decsale = wa_aprcs1-decsale.
    wa_zzcums-jansale = wa_aprcs1-jansale.
    wa_zzcums-febsale = wa_aprcs1-febsale.
    wa_zzcums-marsale = wa_aprcs1-marsale.
    collect wa_zzcums into it_zzcums.
    clear wa_zzcums.
  endloop.

  loop at it_aprcs1 into wa_aprcs1.
    wa_dums-bzirk = wa_aprcs1-zdsm.
    wa_dums-aprsale = wa_aprcs1-aprsale.
    wa_dums-maysale = wa_aprcs1-maysale.
    wa_dums-junsale = wa_aprcs1-junsale.
    wa_dums-julsale = wa_aprcs1-julsale.
    wa_dums-augsale = wa_aprcs1-augsale.
    wa_dums-sepsale = wa_aprcs1-sepsale.
    wa_dums-octsale = wa_aprcs1-octsale.
    wa_dums-novsale = wa_aprcs1-novsale.
    wa_dums-decsale = wa_aprcs1-decsale.
    wa_dums-jansale = wa_aprcs1-jansale.
    wa_dums-febsale = wa_aprcs1-febsale.
    wa_dums-marsale = wa_aprcs1-marsale.
    collect wa_dums into it_dums.
    clear wa_dums.
  endloop.

*LOOP AT IT_CUMS INTO WA_CUMS.
*  WRITE : /'A',WA_CUMS-BZIRK,WA_CUMS-SALE.
*ENDLOOP.

  loop at it_caprcs1 into wa_caprcs1.
    wa_ccums-bzirk = wa_caprcs1-zdsm.
    wa_ccums-sale = wa_caprcs1-aprsale + wa_caprcs1-maysale + wa_caprcs1-junsale + wa_caprcs1-julsale + wa_caprcs1-augsale + wa_caprcs1-sepsale +
    wa_caprcs1-octsale + wa_caprcs1-novsale + wa_caprcs1-decsale + wa_caprcs1-jansale + wa_caprcs1-febsale + wa_caprcs1-marsale.
    collect wa_ccums into it_ccums.
    clear wa_ccums.
  endloop.
  loop at it_caprcs1 into wa_caprcs1.
    wa_dcums-bzirk = wa_caprcs1-zdsm.
    wa_dcums-aprsale = wa_caprcs1-aprsale.
    wa_dcums-maysale = wa_caprcs1-maysale.
    wa_dcums-junsale = wa_caprcs1-junsale.
    wa_dcums-julsale = wa_caprcs1-julsale.
    wa_dcums-augsale = wa_caprcs1-augsale.
    wa_dcums-sepsale = wa_caprcs1-sepsale.
    wa_dcums-octsale = wa_caprcs1-octsale.
    wa_dcums-novsale = wa_caprcs1-novsale.
    wa_dcums-decsale = wa_caprcs1-decsale.
    wa_dcums-jansale = wa_caprcs1-jansale.
    wa_dcums-febsale = wa_caprcs1-febsale.
    wa_dcums-marsale = wa_caprcs1-marsale.
    collect wa_dcums into it_dcums.
    clear wa_dcums.
  endloop.

  loop at it_caprcs1 into wa_caprcs1.
    select single * from zdsmter where zmonth eq month and zyear eq year and bzirk eq wa_caprcs1-zdsm.
    if sy-subrc eq 0.
      wa_smdcums-bzirk = zdsmter-zdsm.
    endif.
    wa_smdcums-aprsale = wa_caprcs1-aprsale.
    wa_smdcums-maysale = wa_caprcs1-maysale.
    wa_smdcums-junsale = wa_caprcs1-junsale.
    wa_smdcums-julsale = wa_caprcs1-julsale.
    wa_smdcums-augsale = wa_caprcs1-augsale.
    wa_smdcums-sepsale = wa_caprcs1-sepsale.
    wa_smdcums-octsale = wa_caprcs1-octsale.
    wa_smdcums-novsale = wa_caprcs1-novsale.
    wa_smdcums-decsale = wa_caprcs1-decsale.
    wa_smdcums-jansale = wa_caprcs1-jansale.
    wa_smdcums-febsale = wa_caprcs1-febsale.
    wa_smdcums-marsale = wa_caprcs1-marsale.
    collect wa_smdcums into it_smdcums.
    clear wa_smdcums.
  endloop.

  loop at it_caprcs1 into wa_caprcs1.
    wa_rdcums-bzirk = wa_caprcs1-rm.
    wa_rdcums-aprsale = wa_caprcs1-aprsale.
    wa_rdcums-maysale = wa_caprcs1-maysale.
    wa_rdcums-junsale = wa_caprcs1-junsale.
    wa_rdcums-julsale = wa_caprcs1-julsale.
    wa_rdcums-augsale = wa_caprcs1-augsale.
    wa_rdcums-sepsale = wa_caprcs1-sepsale.
    wa_rdcums-octsale = wa_caprcs1-octsale.
    wa_rdcums-novsale = wa_caprcs1-novsale.
    wa_rdcums-decsale = wa_caprcs1-decsale.
    wa_rdcums-jansale = wa_caprcs1-jansale.
    wa_rdcums-febsale = wa_caprcs1-febsale.
    wa_rdcums-marsale = wa_caprcs1-marsale.
    collect wa_rdcums into it_rdcums.
    clear wa_rdcums.
  endloop.
  loop at it_caprcs1 into wa_caprcs1.
    wa_zdcums-bzirk = wa_caprcs1-zm.
    wa_zdcums-aprsale = wa_caprcs1-aprsale.
    wa_zdcums-maysale = wa_caprcs1-maysale.
    wa_zdcums-junsale = wa_caprcs1-junsale.
    wa_zdcums-julsale = wa_caprcs1-julsale.
    wa_zdcums-augsale = wa_caprcs1-augsale.
    wa_zdcums-sepsale = wa_caprcs1-sepsale.
    wa_zdcums-octsale = wa_caprcs1-octsale.
    wa_zdcums-novsale = wa_caprcs1-novsale.
    wa_zdcums-decsale = wa_caprcs1-decsale.
    wa_zdcums-jansale = wa_caprcs1-jansale.
    wa_zdcums-febsale = wa_caprcs1-febsale.
    wa_zdcums-marsale = wa_caprcs1-marsale.
    collect wa_zdcums into it_zdcums.
    clear wa_zdcums.
  endloop.

  loop at it_taprcs1 into wa_taprcs1.
    wa_tcums-bzirk = wa_taprcs1-zdsm.
    wa_tcums-sale = wa_taprcs1-aprsale + wa_taprcs1-maysale + wa_taprcs1-junsale + wa_taprcs1-julsale + wa_taprcs1-augsale + wa_taprcs1-sepsale +
    wa_taprcs1-octsale + wa_taprcs1-novsale + wa_taprcs1-decsale + wa_taprcs1-jansale + wa_taprcs1-febsale + wa_taprcs1-marsale.
    collect wa_tcums into it_tcums.
    clear wa_tcums.
  endloop.

  loop at it_taprcs1 into wa_taprcs1.
    select single * from zdsmter where zmonth eq month and zyear eq year and bzirk eq wa_taprcs1-zdsm.
    if sy-subrc eq 0.
      wa_smtcums-bzirk = zdsmter-zdsm.
    endif.
    wa_smtcums-sale = wa_taprcs1-aprsale + wa_taprcs1-maysale + wa_taprcs1-junsale + wa_taprcs1-julsale + wa_taprcs1-augsale + wa_taprcs1-sepsale +
    wa_taprcs1-octsale + wa_taprcs1-novsale + wa_taprcs1-decsale + wa_taprcs1-jansale + wa_taprcs1-febsale + wa_taprcs1-marsale.
    collect wa_smtcums into it_smtcums.
    clear wa_smtcums.
  endloop.

  loop at it_taprcs1 into wa_taprcs1.
    wa_rrtcums-bzirk = wa_taprcs1-rm.
    wa_rrtcums-aprsale = wa_taprcs1-aprsale.
    wa_rrtcums-maysale = wa_taprcs1-maysale.
    wa_rrtcums-junsale = wa_taprcs1-junsale.
    wa_rrtcums-julsale = wa_taprcs1-julsale.
    wa_rrtcums-augsale = wa_taprcs1-augsale.
    wa_rrtcums-sepsale = wa_taprcs1-sepsale.
    wa_rrtcums-octsale = wa_taprcs1-octsale.
    wa_rrtcums-novsale = wa_taprcs1-novsale.
    wa_rrtcums-decsale = wa_taprcs1-decsale.
    wa_rrtcums-jansale = wa_taprcs1-jansale.
    wa_rrtcums-febsale = wa_taprcs1-febsale.
    wa_rrtcums-marsale = wa_taprcs1-marsale.
    collect wa_rrtcums into it_rrtcums.
    clear wa_rrtcums.
  endloop.
  loop at it_taprcs1 into wa_taprcs1.
    wa_zztcums-bzirk = wa_taprcs1-zm.
    wa_zztcums-aprsale = wa_taprcs1-aprsale.
    wa_zztcums-maysale = wa_taprcs1-maysale.
    wa_zztcums-junsale = wa_taprcs1-junsale.
    wa_zztcums-julsale = wa_taprcs1-julsale.
    wa_zztcums-augsale = wa_taprcs1-augsale.
    wa_zztcums-sepsale = wa_taprcs1-sepsale.
    wa_zztcums-octsale = wa_taprcs1-octsale.
    wa_zztcums-novsale = wa_taprcs1-novsale.
    wa_zztcums-decsale = wa_taprcs1-decsale.
    wa_zztcums-jansale = wa_taprcs1-jansale.
    wa_zztcums-febsale = wa_taprcs1-febsale.
    wa_zztcums-marsale = wa_taprcs1-marsale.
    collect wa_zztcums into it_zztcums.
    clear wa_zztcums.
  endloop.

  loop at it_taprcs1 into wa_taprcs1.
    wa_tdums-bzirk = wa_taprcs1-zdsm.
    wa_tdums-aprsale = wa_taprcs1-aprsale.
    wa_tdums-maysale = wa_taprcs1-maysale.
    wa_tdums-junsale = wa_taprcs1-junsale.
    wa_tdums-julsale = wa_taprcs1-julsale.
    wa_tdums-augsale = wa_taprcs1-augsale.
    wa_tdums-sepsale = wa_taprcs1-sepsale.
    wa_tdums-octsale = wa_taprcs1-octsale.
    wa_tdums-novsale = wa_taprcs1-novsale.
    wa_tdums-decsale = wa_taprcs1-decsale.
    wa_tdums-jansale = wa_taprcs1-jansale.
    wa_tdums-febsale = wa_taprcs1-febsale.
    wa_tdums-marsale = wa_taprcs1-marsale.
    collect wa_tdums into it_tdums.
    clear wa_tdums.
  endloop.

  loop at it_taprcs1 into wa_taprcs1.
    select single * from zdsmter where zmonth eq month and zyear eq year and bzirk eq wa_taprcs1-zdsm.
    if sy-subrc eq 0.
      wa_smtdums-bzirk = zdsmter-zdsm.
    endif.
    wa_smtdums-aprsale = wa_taprcs1-aprsale.
    wa_smtdums-maysale = wa_taprcs1-maysale.
    wa_smtdums-junsale = wa_taprcs1-junsale.
    wa_smtdums-julsale = wa_taprcs1-julsale.
    wa_smtdums-augsale = wa_taprcs1-augsale.
    wa_smtdums-sepsale = wa_taprcs1-sepsale.
    wa_smtdums-octsale = wa_taprcs1-octsale.
    wa_smtdums-novsale = wa_taprcs1-novsale.
    wa_smtdums-decsale = wa_taprcs1-decsale.
    wa_smtdums-jansale = wa_taprcs1-jansale.
    wa_smtdums-febsale = wa_taprcs1-febsale.
    wa_smtdums-marsale = wa_taprcs1-marsale.
    collect wa_smtdums into it_smtdums.
    clear wa_smtdums.
  endloop.


  loop at it_taprcs1 into wa_taprcs1.
    wa_rtdums-bzirk = wa_taprcs1-rm.
    wa_rtdums-aprsale = wa_taprcs1-aprsale.
    wa_rtdums-maysale = wa_taprcs1-maysale.
    wa_rtdums-junsale = wa_taprcs1-junsale.
    wa_rtdums-julsale = wa_taprcs1-julsale.
    wa_rtdums-augsale = wa_taprcs1-augsale.
    wa_rtdums-sepsale = wa_taprcs1-sepsale.
    wa_rtdums-octsale = wa_taprcs1-octsale.
    wa_rtdums-novsale = wa_taprcs1-novsale.
    wa_rtdums-decsale = wa_taprcs1-decsale.
    wa_rtdums-jansale = wa_taprcs1-jansale.
    wa_rtdums-febsale = wa_taprcs1-febsale.
    wa_rtdums-marsale = wa_taprcs1-marsale.
    collect wa_rtdums into it_rtdums.
    clear wa_rtdums.
  endloop.
  loop at it_taprcs1 into wa_taprcs1.
    wa_ztdums-bzirk = wa_taprcs1-zm.
    wa_ztdums-aprsale = wa_taprcs1-aprsale.
    wa_ztdums-maysale = wa_taprcs1-maysale.
    wa_ztdums-junsale = wa_taprcs1-junsale.
    wa_ztdums-julsale = wa_taprcs1-julsale.
    wa_ztdums-augsale = wa_taprcs1-augsale.
    wa_ztdums-sepsale = wa_taprcs1-sepsale.
    wa_ztdums-octsale = wa_taprcs1-octsale.
    wa_ztdums-novsale = wa_taprcs1-novsale.
    wa_ztdums-decsale = wa_taprcs1-decsale.
    wa_ztdums-jansale = wa_taprcs1-jansale.
    wa_ztdums-febsale = wa_taprcs1-febsale.
    wa_ztdums-marsale = wa_taprcs1-marsale.
    collect wa_ztdums into it_ztdums.
    clear wa_ztdums.
  endloop.


  loop at it_laprcs1 into wa_laprcs1.
    wa_lcums-bzirk = wa_laprcs1-zdsm.
    wa_lcums-sale = wa_laprcs1-aprsale + wa_laprcs1-maysale + wa_laprcs1-junsale + wa_laprcs1-julsale + wa_laprcs1-augsale + wa_laprcs1-sepsale +
    wa_laprcs1-octsale + wa_laprcs1-novsale + wa_laprcs1-decsale + wa_laprcs1-jansale + wa_laprcs1-febsale + wa_laprcs1-marsale.
    collect wa_lcums into it_lcums.
    clear wa_lcums.
  endloop.

  loop at it_laprcs1 into wa_laprcs1.
    select single * from zdsmter where zmonth eq month and zyear eq year and bzirk eq wa_laprcs1-zdsm.
    if sy-subrc eq 0.
      wa_smlcums-bzirk = zdsmter-zdsm.
    endif.
    wa_smlcums-sale = wa_laprcs1-aprsale + wa_laprcs1-maysale + wa_laprcs1-junsale + wa_laprcs1-julsale + wa_laprcs1-augsale + wa_laprcs1-sepsale +
    wa_laprcs1-octsale + wa_laprcs1-novsale + wa_laprcs1-decsale + wa_laprcs1-jansale + wa_laprcs1-febsale + wa_laprcs1-marsale.
    collect wa_smlcums into it_smlcums.
    clear wa_smlcums.
  endloop.

  loop at it_laprcs1 into wa_laprcs1.
    wa_rrlcums-bzirk = wa_laprcs1-rm.
    wa_rrlcums-aprsale = wa_laprcs1-aprsale.
    wa_rrlcums-maysale = wa_laprcs1-maysale.
    wa_rrlcums-junsale = wa_laprcs1-junsale.
    wa_rrlcums-julsale = wa_laprcs1-julsale.
    wa_rrlcums-augsale = wa_laprcs1-augsale.
    wa_rrlcums-sepsale = wa_laprcs1-sepsale.
    wa_rrlcums-octsale = wa_laprcs1-octsale.
    wa_rrlcums-novsale = wa_laprcs1-novsale.
    wa_rrlcums-decsale = wa_laprcs1-decsale.
    wa_rrlcums-jansale = wa_laprcs1-jansale.
    wa_rrlcums-febsale = wa_laprcs1-febsale.
    wa_rrlcums-marsale = wa_laprcs1-marsale.
    collect wa_rrlcums into it_rrlcums.
    clear wa_rrlcums.
  endloop.

  loop at it_laprcs1 into wa_laprcs1.
    wa_ldums-bzirk = wa_laprcs1-zdsm.
    wa_ldums-aprsale = wa_laprcs1-aprsale.
    wa_ldums-maysale = wa_laprcs1-maysale.
    wa_ldums-junsale = wa_laprcs1-junsale.
    wa_ldums-julsale = wa_laprcs1-julsale.
    wa_ldums-augsale = wa_laprcs1-augsale.
    wa_ldums-sepsale = wa_laprcs1-sepsale.
    wa_ldums-octsale = wa_laprcs1-octsale.
    wa_ldums-novsale = wa_laprcs1-novsale.
    wa_ldums-decsale = wa_laprcs1-decsale.
    wa_ldums-jansale = wa_laprcs1-jansale.
    wa_ldums-febsale = wa_laprcs1-febsale.
    wa_ldums-marsale = wa_laprcs1-marsale.
    collect wa_ldums into it_ldums.
    clear wa_ldums.
  endloop.

  loop at it_l1aprcs1 into wa_l1aprcs1.
    wa_l1dums-bzirk = wa_l1aprcs1-zdsm.
    wa_l1dums-aprsale = wa_l1aprcs1-aprsale.
    wa_l1dums-maysale = wa_l1aprcs1-maysale.
    wa_l1dums-junsale = wa_l1aprcs1-junsale.
    wa_l1dums-julsale = wa_l1aprcs1-julsale.
    wa_l1dums-augsale = wa_l1aprcs1-augsale.
    wa_l1dums-sepsale = wa_l1aprcs1-sepsale.
    wa_l1dums-octsale = wa_l1aprcs1-octsale.
    wa_l1dums-novsale = wa_l1aprcs1-novsale.
    wa_l1dums-decsale = wa_l1aprcs1-decsale.
    wa_l1dums-jansale = wa_l1aprcs1-jansale.
    wa_l1dums-febsale = wa_l1aprcs1-febsale.
    wa_l1dums-marsale = wa_l1aprcs1-marsale.
    collect wa_l1dums into it_l1dums.
    clear wa_l1dums.
  endloop.

  loop at it_l1aprcs1 into wa_l1aprcs1.
    select single * from zdsmter where zmonth eq month and zyear eq year and bzirk eq wa_l1aprcs1-zdsm.
    if sy-subrc eq 0.
      wa_sml1dums-bzirk = zdsmter-zdsm.
    endif.
    wa_sml1dums-aprsale = wa_l1aprcs1-aprsale.
    wa_sml1dums-maysale = wa_l1aprcs1-maysale.
    wa_sml1dums-junsale = wa_l1aprcs1-junsale.
    wa_sml1dums-julsale = wa_l1aprcs1-julsale.
    wa_sml1dums-augsale = wa_l1aprcs1-augsale.
    wa_sml1dums-sepsale = wa_l1aprcs1-sepsale.
    wa_sml1dums-octsale = wa_l1aprcs1-octsale.
    wa_sml1dums-novsale = wa_l1aprcs1-novsale.
    wa_sml1dums-decsale = wa_l1aprcs1-decsale.
    wa_sml1dums-jansale = wa_l1aprcs1-jansale.
    wa_sml1dums-febsale = wa_l1aprcs1-febsale.
    wa_sml1dums-marsale = wa_l1aprcs1-marsale.
    collect wa_sml1dums into it_sml1dums.
    clear wa_sml1dums.
  endloop.

  loop at it_l1aprcs1 into wa_l1aprcs1.
    wa_rl1dums-bzirk = wa_l1aprcs1-rm.
    wa_rl1dums-aprsale = wa_l1aprcs1-aprsale.
    wa_rl1dums-maysale = wa_l1aprcs1-maysale.
    wa_rl1dums-junsale = wa_l1aprcs1-junsale.
    wa_rl1dums-julsale = wa_l1aprcs1-julsale.
    wa_rl1dums-augsale = wa_l1aprcs1-augsale.
    wa_rl1dums-sepsale = wa_l1aprcs1-sepsale.
    wa_rl1dums-octsale = wa_l1aprcs1-octsale.
    wa_rl1dums-novsale = wa_l1aprcs1-novsale.
    wa_rl1dums-decsale = wa_l1aprcs1-decsale.
    wa_rl1dums-jansale = wa_l1aprcs1-jansale.
    wa_rl1dums-febsale = wa_l1aprcs1-febsale.
    wa_rl1dums-marsale = wa_l1aprcs1-marsale.
    collect wa_rl1dums into it_rl1dums.
    clear wa_rl1dums.
  endloop.


  loop at it_l1aprcs1 into wa_l1aprcs1.
    wa_zl1dums-bzirk = wa_l1aprcs1-zm.
    wa_zl1dums-aprsale = wa_l1aprcs1-aprsale.
    wa_zl1dums-maysale = wa_l1aprcs1-maysale.
    wa_zl1dums-junsale = wa_l1aprcs1-junsale.
    wa_zl1dums-julsale = wa_l1aprcs1-julsale.
    wa_zl1dums-augsale = wa_l1aprcs1-augsale.
    wa_zl1dums-sepsale = wa_l1aprcs1-sepsale.
    wa_zl1dums-octsale = wa_l1aprcs1-octsale.
    wa_zl1dums-novsale = wa_l1aprcs1-novsale.
    wa_zl1dums-decsale = wa_l1aprcs1-decsale.
    wa_zl1dums-jansale = wa_l1aprcs1-jansale.
    wa_zl1dums-febsale = wa_l1aprcs1-febsale.
    wa_zl1dums-marsale = wa_l1aprcs1-marsale.
    collect wa_zl1dums into it_zl1dums.
    clear wa_zl1dums.
  endloop.

  loop at it_ltaprcs1 into wa_ltaprcs1.
    wa_ltcums-bzirk = wa_ltaprcs1-zdsm.
    wa_ltcums-sale = wa_ltaprcs1-aprsale + wa_ltaprcs1-maysale + wa_ltaprcs1-junsale + wa_ltaprcs1-julsale + wa_ltaprcs1-augsale + wa_ltaprcs1-sepsale +
    wa_ltaprcs1-octsale + wa_ltaprcs1-novsale + wa_ltaprcs1-decsale + wa_ltaprcs1-jansale + wa_ltaprcs1-febsale + wa_ltaprcs1-marsale.
    collect wa_ltcums into it_ltcums.
    clear wa_ltcums.
  endloop.
  loop at it_ltaprcs1 into wa_ltaprcs1.
    wa_ltdums-bzirk = wa_ltaprcs1-zdsm.
    wa_ltdums-aprsale = wa_ltaprcs1-aprsale.
    wa_ltdums-maysale = wa_ltaprcs1-maysale.
    wa_ltdums-junsale = wa_ltaprcs1-junsale.
    wa_ltdums-julsale = wa_ltaprcs1-julsale.
    wa_ltdums-augsale = wa_ltaprcs1-augsale.
    wa_ltdums-sepsale = wa_ltaprcs1-sepsale.
    wa_ltdums-octsale = wa_ltaprcs1-octsale.
    wa_ltdums-novsale = wa_ltaprcs1-novsale.
    wa_ltdums-decsale = wa_ltaprcs1-decsale.
    wa_ltdums-jansale = wa_ltaprcs1-jansale.
    wa_ltdums-febsale = wa_ltaprcs1-febsale.
    wa_ltdums-marsale = wa_ltaprcs1-marsale.
    collect wa_ltdums into it_ltdums.
    clear wa_ltdums.
  endloop.

  loop at it_l1taprcs1 into wa_l1taprcs1.
    wa_l1tdums-bzirk = wa_l1taprcs1-zdsm.
    wa_l1tdums-aprsale = wa_l1taprcs1-aprsale.
    wa_l1tdums-maysale = wa_l1taprcs1-maysale.
    wa_l1tdums-junsale = wa_l1taprcs1-junsale.
    wa_l1tdums-julsale = wa_l1taprcs1-julsale.
    wa_l1tdums-augsale = wa_l1taprcs1-augsale.
    wa_l1tdums-sepsale = wa_l1taprcs1-sepsale.
    wa_l1tdums-octsale = wa_l1taprcs1-octsale.
    wa_l1tdums-novsale = wa_l1taprcs1-novsale.
    wa_l1tdums-decsale = wa_l1taprcs1-decsale.
    wa_l1tdums-jansale = wa_l1taprcs1-jansale.
    wa_l1tdums-febsale = wa_l1taprcs1-febsale.
    wa_l1tdums-marsale = wa_l1taprcs1-marsale.
    collect wa_l1tdums into it_l1tdums.
    clear wa_l1tdums.
  endloop.

*LOOP AT IT_TCUMS INTO WA_TCUMS.
*  WRITE : /'CUMM TARGET',WA_TCUMS-BZIRK,WA_TCUMS-SALE.
*ENDLOOP.

****RM*****


  loop at it_raprcs1 into wa_raprcs1.
    wa_rcums-bzirk = wa_raprcs1-rm.
    wa_rcums-sale = wa_raprcs1-aprsale + wa_raprcs1-maysale + wa_raprcs1-junsale + wa_raprcs1-julsale + wa_raprcs1-augsale + wa_raprcs1-sepsale +
    wa_raprcs1-octsale + wa_raprcs1-novsale + wa_raprcs1-decsale + wa_raprcs1-jansale + wa_raprcs1-febsale + wa_raprcs1-marsale.
    collect wa_rcums into it_rcums.
    clear wa_rcums.
  endloop.

*LOOP AT IT_CUMS INTO WA_CUMS.
*  WRITE : /'A',WA_CUMS-BZIRK,WA_CUMS-SALE.
*ENDLOOP.

  loop at it_rlaprcs1 into wa_rlaprcs1.
    wa_rlcums-bzirk = wa_rlaprcs1-rm.
    wa_rlcums-sale = wa_rlaprcs1-aprsale + wa_rlaprcs1-maysale + wa_rlaprcs1-junsale + wa_rlaprcs1-julsale + wa_rlaprcs1-augsale + wa_rlaprcs1-sepsale +
    wa_rlaprcs1-octsale + wa_rlaprcs1-novsale + wa_rlaprcs1-decsale + wa_rlaprcs1-jansale + wa_rlaprcs1-febsale + wa_rlaprcs1-marsale.
    collect wa_rlcums into it_rlcums.
    clear wa_rlcums.
  endloop.

*LOOP AT IT_LCUMS INTO WA_LCUMS.
*  WRITE : /'LA',WA_LCUMS-BZIRK,WA_LCUMS-SALE.
*ENDLOOP.

  loop at it_rcaprcs1 into wa_rcaprcs1.
    wa_rccums-bzirk = wa_rcaprcs1-rm.
    wa_rccums-sale = wa_rcaprcs1-aprsale + wa_rcaprcs1-maysale + wa_rcaprcs1-junsale + wa_rcaprcs1-julsale + wa_rcaprcs1-augsale + wa_rcaprcs1-sepsale +
    wa_rcaprcs1-octsale + wa_rcaprcs1-novsale + wa_rcaprcs1-decsale + wa_rcaprcs1-jansale + wa_rcaprcs1-febsale + wa_rcaprcs1-marsale.
    collect wa_rccums into it_rccums.
    clear wa_rccums.
  endloop.

  loop at it_rtaprcs1 into wa_rtaprcs1.
    wa_rtcums-bzirk = wa_rtaprcs1-rm.
    wa_rtcums-sale = wa_rtaprcs1-aprsale + wa_rtaprcs1-maysale + wa_rtaprcs1-junsale + wa_rtaprcs1-julsale + wa_rtaprcs1-augsale + wa_rtaprcs1-sepsale +
    wa_rtaprcs1-octsale + wa_rtaprcs1-novsale + wa_rtaprcs1-decsale + wa_rtaprcs1-jansale + wa_rtaprcs1-febsale + wa_rtaprcs1-marsale.
    collect wa_rtcums into it_rtcums.
    clear wa_rtcums.
  endloop.

************PSO**************

  loop at it_paprcs1 into wa_paprcs1.
    wa_pcums-bzirk = wa_paprcs1-bzirk.
    wa_pcums-sale = wa_paprcs1-aprsale + wa_paprcs1-maysale + wa_paprcs1-junsale + wa_paprcs1-julsale + wa_paprcs1-augsale + wa_paprcs1-sepsale +
    wa_paprcs1-octsale + wa_paprcs1-novsale + wa_paprcs1-decsale + wa_paprcs1-jansale + wa_paprcs1-febsale + wa_paprcs1-marsale.
    collect wa_pcums into it_pcums.
    clear wa_pcums.
  endloop.

*LOOP AT IT_CUMS INTO WA_CUMS.
*  WRITE : /'A',WA_CUMS-BZIRK,WA_CUMS-SALE.
*ENDLOOP.

  loop at it_plaprcs1 into wa_plaprcs1.
    wa_plcums-bzirk = wa_plaprcs1-bzirk.
    wa_plcums-sale = wa_plaprcs1-aprsale + wa_plaprcs1-maysale + wa_plaprcs1-junsale + wa_plaprcs1-julsale + wa_plaprcs1-augsale + wa_plaprcs1-sepsale +
    wa_plaprcs1-octsale + wa_plaprcs1-novsale + wa_plaprcs1-decsale + wa_plaprcs1-jansale + wa_plaprcs1-febsale + wa_plaprcs1-marsale.
    collect wa_plcums into it_plcums.
    clear wa_plcums.
  endloop.

*LOOP AT IT_LCUMS INTO WA_LCUMS.
*  WRITE : /'LA',WA_LCUMS-BZIRK,WA_LCUMS-SALE.
*ENDLOOP.

  loop at it_pcaprcs1 into wa_pcaprcs1.
    wa_pccums-bzirk = wa_pcaprcs1-bzirk.
    wa_pccums-sale = wa_pcaprcs1-aprsale + wa_pcaprcs1-maysale + wa_pcaprcs1-junsale + wa_pcaprcs1-julsale + wa_pcaprcs1-augsale + wa_pcaprcs1-sepsale +
    wa_pcaprcs1-octsale + wa_pcaprcs1-novsale + wa_pcaprcs1-decsale + wa_pcaprcs1-jansale + wa_pcaprcs1-febsale + wa_pcaprcs1-marsale.
    collect wa_pccums into it_pccums.
    clear wa_pccums.
  endloop.

  loop at it_ptaprcs1 into wa_ptaprcs1.
    wa_ptcums-bzirk = wa_ptaprcs1-bzirk.
    wa_ptcums-sale = wa_ptaprcs1-aprsale + wa_ptaprcs1-maysale + wa_ptaprcs1-junsale + wa_ptaprcs1-julsale + wa_ptaprcs1-augsale + wa_ptaprcs1-sepsale +
    wa_ptaprcs1-octsale + wa_ptaprcs1-novsale + wa_ptaprcs1-decsale + wa_ptaprcs1-jansale + wa_ptaprcs1-febsale + wa_ptaprcs1-marsale.
    collect wa_ptcums into it_ptcums.
    clear wa_ptcums.
  endloop.

***************** lasT year hierarchy for second line***********************************


************APR*************************
*  CLEAR : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1,it_l2,wa_l2.
*  SELECT * FROM zdsmter INTO TABLE it_zdsmter_l1 WHERE zdsm IN org AND zmonth EQ ly_dt1+4(2) AND zyear EQ ly_dt1+0(4).
*  IF sy-subrc EQ 0.
*    SELECT * FROM zdsmter INTO TABLE it_zdsmter_l2 FOR ALL ENTRIES IN it_zdsmter_l1 WHERE zdsm EQ it_zdsmter_l1-bzirk AND
*      zmonth EQ ly_dt1+4(2)  AND zyear EQ ly_dt1+0(4).
*  ENDIF.
*  LOOP AT it_zdsmter_l2 INTO wa_zdsmter_l2.
*    wa_l1-zmonth = wa_zdsmter_l2-zmonth.
*    wa_l2-zyear = wa_zdsmter_l2-zyear.
*    wa_l2-bzirk = wa_zdsmter_l2-bzirk.
*    wa_l2-rm = wa_zdsmter_l2-zdsm.
*    READ TABLE it_zdsmter_l1 INTO wa_zdsmter_l1 WITH KEY bzirk = wa_zdsmter_l2-zdsm.
*    IF sy-subrc EQ 0.
*      wa_l2-zdsm = wa_zdsmter_l1-zdsm.
*    ENDIF.
*    COLLECT wa_l2 INTO it_l2.
*    CLEAR wa_l2.
*  ENDLOOP.

*************************** APR **********
  clear : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1,it_l2,wa_l2.
  select * from zdsmter into table it_zdsmter_l1 where zdsm in org and zmonth eq ly_dt1+4(2) and zyear eq ly_dt1+0(4).
  if sy-subrc eq 0.
    select * from zdsmter into table it_zdsmter_l2 for all entries in it_zdsmter_l1 where zdsm eq it_zdsmter_l1-bzirk and
      zmonth eq ly_dt1+4(2)  and zyear eq ly_dt1+0(4).
  endif.
  loop at it_zdsmter_l2 into wa_zdsmter_l2 where zdsm+0(2) eq 'R-'.
    wa_l2-zmonth = wa_zdsmter_l2-zmonth.
    wa_l2-zyear = wa_zdsmter_l2-zyear.
    wa_l2-bzirk = wa_zdsmter_l2-bzirk.
    wa_l2-rm = wa_zdsmter_l2-zdsm.
    read table it_zdsmter_l2 into wa_zdsmter_l2 with key bzirk = wa_zdsmter_l2-zdsm zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_l2-zm = wa_zdsmter_l2-zdsm.
    endif.
    read table it_zdsmter_l1 into wa_zdsmter_l1 with key bzirk = wa_zdsmter_l2-zdsm.
    if sy-subrc eq 0.
      wa_l2-zdsm = wa_zdsmter_l1-zdsm.
    endif.
    collect wa_l2 into it_l2.
    clear wa_l2.
  endloop.
*******************

  loop at it_l2 into wa_l2.
*    *****  new condition enter on 29.5.2019.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge f1date.
*    SELECT SINGLE * FROM YTERRALLC WHERE BZIRK EQ WA_L2-BZIRK AND ENDDA GE ly_dt1.
    if sy-subrc eq 0.
************************ ends here*******************
*      SELECT SINGLE * FROM ZRCUMPSO WHERE ZMONTH EQ LY_DT1+4(2) AND ZYEAR EQ LY_DT1+0(4) AND BZIRK EQ WA_L2-BZIRK.
*      IF SY-SUBRC EQ 0.
*        WA_LL1APRCS1-BZIRK =  WA_L2-BZIRK.
*        WA_LL1APRCS1-APRSALE =  ZRCUMPSO-NETVAL.
*        WA_LL1APRCS1-ZDSM = WA_L2-ZDSM.
*        WA_LL1APRCS1-RM = WA_L2-RM.
*        WA_LL1APRCS1-ZM = WA_L2-ZM.
*        COLLECT WA_LL1APRCS1 INTO IT_LL1APRCS1.
*        CLEAR WA_LL1APRCS1.
*      ENDIF.
      select single * from zcumpso where zmonth eq ly_dt1+4(2) and zyear eq ly_dt1+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_ll1aprcs1-bzirk =  wa_l2-bzirk.
        wa_ll1aprcs1-aprsale =  zcumpso-netval.
        wa_ll1aprcs1-zdsm = wa_l2-zdsm.
        wa_ll1aprcs1-rm = wa_l2-rm.
        wa_ll1aprcs1-zm = wa_l2-zm.
        collect wa_ll1aprcs1 into it_ll1aprcs1.
        clear wa_ll1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
      if sy-subrc eq 0.
        wa_ll1taprcs1-bzirk =  wa_l2-bzirk.
        wa_ll1taprcs1-aprsale =  ysd_dist_targt-month01.
        wa_ll1taprcs1-zdsm = wa_l2-zdsm.
        wa_ll1taprcs1-rm = wa_l2-rm.
        wa_ll1taprcs1-zm = wa_l2-zm.
        collect wa_ll1taprcs1 into it_ll1taprcs1.
        clear wa_ll1taprcs1.
      endif.

      select single * from zrcumpso where zmonth eq ly_dt1+4(2) and zyear eq llyear and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_lyl1aprcs1-bzirk =  wa_l2-bzirk.
        wa_lyl1aprcs1-aprsale =  zrcumpso-netval.
        wa_lyl1aprcs1-zdsm = wa_l2-zdsm.
        wa_lyl1aprcs1-rm = wa_l2-rm.
        wa_lyl1aprcs1-zm = wa_l2-zm.
        collect wa_lyl1aprcs1 into it_lyl1aprcs1.
        clear wa_lyl1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq llyear.
      if sy-subrc eq 0.
        wa_lyl1taprcs1-bzirk =  wa_l2-bzirk.
        wa_lyl1taprcs1-aprsale =  ysd_dist_targt-month01.
        wa_lyl1taprcs1-zdsm = wa_l2-zdsm.
        wa_lyl1taprcs1-rm = wa_l2-rm.
        wa_lyl1taprcs1-zm = wa_l2-zm.
        collect wa_lyl1taprcs1 into it_lyl1taprcs1.
        clear wa_lyl1taprcs1.
      endif.

      if f1date le date2.
        select single * from zrcumpso where zmonth eq ly_dt1+4(2) and zyear eq ly_dt1+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_llaprcs1-bzirk =  wa_l2-bzirk.
          wa_llaprcs1-aprsale =  zrcumpso-netval.
          wa_llaprcs1-zdsm = wa_l2-zdsm.
          wa_llaprcs1-rm = wa_l2-rm.
          wa_llaprcs1-zm = wa_l2-zm.
          collect wa_llaprcs1 into it_llaprcs1.
          clear wa_llaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
        if sy-subrc eq 0.
          wa_lltaprcs1-bzirk =  wa_l2-bzirk.
          wa_lltaprcs1-aprsale =  ysd_dist_targt-month01.
          wa_lltaprcs1-zdsm = wa_l2-zdsm.
          wa_lltaprcs1-rm = wa_l2-rm.
          wa_lltaprcs1-zm = wa_l2-zm.
          collect wa_lltaprcs1 into it_lltaprcs1.
          clear wa_lltaprcs1.
        endif.

        select single * from zrcumpso where zmonth eq ly_dt1+4(2) and zyear eq llyear and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_lylaprcs1-bzirk =  wa_l2-bzirk.
          wa_lylaprcs1-aprsale =  zrcumpso-netval.
          wa_lylaprcs1-zdsm = wa_l2-zdsm.
          wa_lylaprcs1-rm = wa_l2-rm.
          wa_lylaprcs1-zm = wa_l2-zm.
          collect wa_lylaprcs1 into it_lylaprcs1.
          clear wa_lylaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq llyear.
        if sy-subrc eq 0.
          wa_lyltaprcs1-bzirk =  wa_l2-bzirk.
          wa_lyltaprcs1-aprsale =  ysd_dist_targt-month01.
          wa_lyltaprcs1-zdsm = wa_l2-zdsm.
          wa_lyltaprcs1-rm = wa_l2-rm.
          wa_lyltaprcs1-zm = wa_l2-zm.
          collect wa_lyltaprcs1 into it_lyltaprcs1.
          clear wa_lyltaprcs1.
        endif.
      endif.

    endif.
  endloop.

************MAY*************************
  clear : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1,it_l2,wa_l2.
  select * from zdsmter into table it_zdsmter_l1 where zdsm in org and zmonth eq ly_dt2+4(2) and zyear eq ly_dt2+0(4).
  if sy-subrc eq 0.
    select * from zdsmter into table it_zdsmter_l2 for all entries in it_zdsmter_l1 where zdsm eq it_zdsmter_l1-bzirk and
      zmonth eq ly_dt2+4(2)  and zyear eq ly_dt2+0(4).
  endif.
  loop at it_zdsmter_l2 into wa_zdsmter_l2 where zdsm+0(2) eq 'R-'.
    wa_l2-zmonth = wa_zdsmter_l2-zmonth.
    wa_l2-zyear = wa_zdsmter_l2-zyear.
    wa_l2-bzirk = wa_zdsmter_l2-bzirk.
    wa_l2-rm = wa_zdsmter_l2-zdsm.
    read table it_zdsmter_l2 into wa_zdsmter_l2 with key bzirk = wa_zdsmter_l2-zdsm zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_l2-zm = wa_zdsmter_l2-zdsm.
    endif.
    read table it_zdsmter_l1 into wa_zdsmter_l1 with key bzirk = wa_zdsmter_l2-zdsm.
    if sy-subrc eq 0.
      wa_l2-zdsm = wa_zdsmter_l1-zdsm.
    endif.
    collect wa_l2 into it_l2.
    clear wa_l2.
  endloop.

  loop at it_l2 into wa_l2.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge f1date.
*    SELECT SINGLE * FROM YTERRALLC WHERE BZIRK EQ WA_L2-BZIRK AND ENDDA GE ly_dt1.
    if sy-subrc eq 0.
      select single * from zcumpso where zmonth eq ly_dt2+4(2) and zyear eq ly_dt2+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_ll1aprcs1-bzirk =  wa_l2-bzirk.
        wa_ll1aprcs1-maysale =  zcumpso-netval.
        wa_ll1aprcs1-zdsm = wa_l2-zdsm.
        wa_ll1aprcs1-rm = wa_l2-rm.
        wa_ll1aprcs1-zm = wa_l2-zm.
        collect wa_ll1aprcs1 into it_ll1aprcs1.
        clear wa_ll1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
      if sy-subrc eq 0.
        wa_ll1taprcs1-bzirk =  wa_l2-bzirk.
        wa_ll1taprcs1-maysale =  ysd_dist_targt-month02.
        wa_ll1taprcs1-zdsm = wa_l2-zdsm.
        wa_ll1taprcs1-rm = wa_l2-rm.
        wa_ll1taprcs1-zm = wa_l2-zm.
        collect wa_ll1taprcs1 into it_ll1taprcs1.
        clear wa_ll1taprcs1.
      endif.

      select single * from zrcumpso where zmonth eq ly_dt2+4(2) and zyear eq llyear and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_lyl1aprcs1-bzirk =  wa_l2-bzirk.
        wa_lyl1aprcs1-maysale =  zrcumpso-netval.
        wa_lyl1aprcs1-zdsm = wa_l2-zdsm.
        wa_lyl1aprcs1-rm = wa_l2-rm.
        wa_lyl1aprcs1-zm = wa_l2-zm.
        collect wa_lyl1aprcs1 into it_lyl1aprcs1.
        clear wa_lyl1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq llyear.
      if sy-subrc eq 0.
        wa_lyl1taprcs1-bzirk =  wa_l2-bzirk.
        wa_lyl1taprcs1-maysale =  ysd_dist_targt-month02.
        wa_lyl1taprcs1-zdsm = wa_l2-zdsm.
        wa_lyl1taprcs1-rm = wa_l2-rm.
        wa_lyl1taprcs1-zm = wa_l2-zm.
        collect wa_lyl1taprcs1 into it_lyl1taprcs1.
        clear wa_lyl1taprcs1.
      endif.

      if f2date le date2.
        select single * from zrcumpso where zmonth eq ly_dt2+4(2) and zyear eq ly_dt2+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_llaprcs1-bzirk =  wa_l2-bzirk.
          wa_llaprcs1-maysale =  zrcumpso-netval.
          wa_llaprcs1-zdsm = wa_l2-zdsm.
          wa_llaprcs1-rm = wa_l2-rm.
          wa_llaprcs1-zm = wa_l2-zm.
          collect wa_llaprcs1 into it_llaprcs1.
          clear wa_llaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
        if sy-subrc eq 0.
          wa_lltaprcs1-bzirk =  wa_l2-bzirk.
          wa_lltaprcs1-maysale =  ysd_dist_targt-month02.
          wa_lltaprcs1-zdsm = wa_l2-zdsm.
          wa_lltaprcs1-rm = wa_l2-rm.
          wa_lltaprcs1-zm = wa_l2-zm.
          collect wa_lltaprcs1 into it_lltaprcs1.
          clear wa_lltaprcs1.
        endif.

        select single * from zrcumpso where zmonth eq ly_dt2+4(2) and zyear eq llyear and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_lylaprcs1-bzirk =  wa_l2-bzirk.
          wa_lylaprcs1-maysale =  zrcumpso-netval.
          wa_lylaprcs1-zdsm = wa_l2-zdsm.
          wa_lylaprcs1-rm = wa_l2-rm.
          wa_lylaprcs1-zm = wa_l2-zm.
          collect wa_lylaprcs1 into it_lylaprcs1.
          clear wa_lylaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq llyear.
        if sy-subrc eq 0.
          wa_lyltaprcs1-bzirk =  wa_l2-bzirk.
          wa_lyltaprcs1-maysale =  ysd_dist_targt-month02.
          wa_lyltaprcs1-zdsm = wa_l2-zdsm.
          wa_lyltaprcs1-rm = wa_l2-rm.
          wa_lyltaprcs1-zm = wa_l2-zm.
          collect wa_lyltaprcs1 into it_lyltaprcs1.
          clear wa_lyltaprcs1.
        endif.

      endif.
    endif.
  endloop.


************JUN*************************
  clear : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1,it_l2,wa_l2.
  select * from zdsmter into table it_zdsmter_l1 where zdsm in org and zmonth eq ly_dt3+4(2) and zyear eq ly_dt3+0(4).
  if sy-subrc eq 0.
    select * from zdsmter into table it_zdsmter_l2 for all entries in it_zdsmter_l1 where zdsm eq it_zdsmter_l1-bzirk and
      zmonth eq ly_dt3+4(2)  and zyear eq ly_dt3+0(4).
  endif.
  loop at it_zdsmter_l2 into wa_zdsmter_l2 where zdsm+0(2) eq 'R-'.
    wa_l2-zmonth = wa_zdsmter_l2-zmonth.
    wa_l2-zyear = wa_zdsmter_l2-zyear.
    wa_l2-bzirk = wa_zdsmter_l2-bzirk.
    wa_l2-rm = wa_zdsmter_l2-zdsm.
    read table it_zdsmter_l2 into wa_zdsmter_l2 with key bzirk = wa_zdsmter_l2-zdsm zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_l2-zm = wa_zdsmter_l2-zdsm.
    endif.
    read table it_zdsmter_l1 into wa_zdsmter_l1 with key bzirk = wa_zdsmter_l2-zdsm.
    if sy-subrc eq 0.
      wa_l2-zdsm = wa_zdsmter_l1-zdsm.
    endif.
    collect wa_l2 into it_l2.
    clear wa_l2.
  endloop.


  loop at it_l2 into wa_l2.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge f1date.
*    SELECT SINGLE * FROM YTERRALLC WHERE BZIRK EQ WA_L2-BZIRK AND ENDDA GE ly_dt1.
    if sy-subrc eq 0.
      select single * from zcumpso where zmonth eq ly_dt3+4(2) and zyear eq ly_dt3+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_ll1aprcs1-bzirk =  wa_l2-bzirk.
        wa_ll1aprcs1-junsale =  zcumpso-netval.
        wa_ll1aprcs1-zdsm = wa_l2-zdsm.
        wa_ll1aprcs1-rm = wa_l2-rm.
        wa_ll1aprcs1-zm = wa_l2-zm.
        collect wa_ll1aprcs1 into it_ll1aprcs1.
        clear wa_ll1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
      if sy-subrc eq 0.
        wa_ll1taprcs1-bzirk =  wa_l2-bzirk.
        wa_ll1taprcs1-junsale =  ysd_dist_targt-month03.
        wa_ll1taprcs1-zdsm = wa_l2-zdsm.
        wa_ll1taprcs1-rm = wa_l2-rm.
        wa_ll1taprcs1-zm = wa_l2-zm.
        collect wa_ll1taprcs1 into it_ll1taprcs1.
        clear wa_ll1taprcs1.
      endif.

      select single * from zrcumpso where zmonth eq ly_dt3+4(2) and zyear eq llyear and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_lyl1aprcs1-bzirk =  wa_l2-bzirk.
        wa_lyl1aprcs1-junsale =  zrcumpso-netval.
        wa_lyl1aprcs1-zdsm = wa_l2-zdsm.
        wa_lyl1aprcs1-rm = wa_l2-rm.
        wa_lyl1aprcs1-zm = wa_l2-zm.
        collect wa_lyl1aprcs1 into it_lyl1aprcs1.
        clear wa_lyl1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq llyear.
      if sy-subrc eq 0.
        wa_lyl1taprcs1-bzirk =  wa_l2-bzirk.
        wa_lyl1taprcs1-junsale =  ysd_dist_targt-month03.
        wa_lyl1taprcs1-zdsm = wa_l2-zdsm.
        wa_lyl1taprcs1-rm = wa_l2-rm.
        wa_lyl1taprcs1-zm = wa_l2-zm.
        collect wa_lyl1taprcs1 into it_lyl1taprcs1.
        clear wa_lyl1taprcs1.
      endif.


      if f3date le date2.
        select single * from zrcumpso where zmonth eq ly_dt3+4(2) and zyear eq ly_dt3+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_llaprcs1-bzirk =  wa_l2-bzirk.
          wa_llaprcs1-junsale =  zrcumpso-netval.
          wa_llaprcs1-zdsm = wa_l2-zdsm.
          wa_llaprcs1-rm = wa_l2-rm.
          wa_llaprcs1-zm = wa_l2-zm.
          collect wa_llaprcs1 into it_llaprcs1.
          clear wa_llaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
        if sy-subrc eq 0.
          wa_lltaprcs1-bzirk =  wa_l2-bzirk.
          wa_lltaprcs1-junsale =  ysd_dist_targt-month01.
          wa_lltaprcs1-zdsm = wa_l2-zdsm.
          wa_lltaprcs1-rm = wa_l2-rm.
          wa_lltaprcs1-zm = wa_l2-zm.
          collect wa_lltaprcs1 into it_lltaprcs1.
          clear wa_lltaprcs1.
        endif.

        select single * from zrcumpso where zmonth eq ly_dt3+4(2) and zyear eq llyear and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_lylaprcs1-bzirk =  wa_l2-bzirk.
          wa_lylaprcs1-junsale =  zrcumpso-netval.
          wa_lylaprcs1-zdsm = wa_l2-zdsm.
          wa_lylaprcs1-rm = wa_l2-rm.
          wa_lylaprcs1-zm = wa_l2-zm.
          collect wa_lylaprcs1 into it_lylaprcs1.
          clear wa_lylaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq llyear.
        if sy-subrc eq 0.
          wa_lyltaprcs1-bzirk =  wa_l2-bzirk.
          wa_lyltaprcs1-junsale =  ysd_dist_targt-month01.
          wa_lyltaprcs1-zdsm = wa_l2-zdsm.
          wa_lyltaprcs1-rm = wa_l2-rm.
          wa_lyltaprcs1-zm = wa_l2-zm.
          collect wa_lyltaprcs1 into it_lyltaprcs1.
          clear wa_lyltaprcs1.
        endif.


      endif.
    endif.
  endloop.

************JUL*************************
  clear : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1,it_l2,wa_l2.
  select * from zdsmter into table it_zdsmter_l1 where zdsm in org and zmonth eq ly_dt4+4(2) and zyear eq ly_dt4+0(4).
  if sy-subrc eq 0.
    select * from zdsmter into table it_zdsmter_l2 for all entries in it_zdsmter_l1 where zdsm eq it_zdsmter_l1-bzirk and
      zmonth eq ly_dt4+4(2)  and zyear eq ly_dt4+0(4).
  endif.
  loop at it_zdsmter_l2 into wa_zdsmter_l2 where zdsm+0(2) eq 'R-'.
    wa_l2-zmonth = wa_zdsmter_l2-zmonth.
    wa_l2-zyear = wa_zdsmter_l2-zyear.
    wa_l2-bzirk = wa_zdsmter_l2-bzirk.
    wa_l2-rm = wa_zdsmter_l2-zdsm.
    read table it_zdsmter_l2 into wa_zdsmter_l2 with key bzirk = wa_zdsmter_l2-zdsm zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_l2-zm = wa_zdsmter_l2-zdsm.
    endif.
    read table it_zdsmter_l1 into wa_zdsmter_l1 with key bzirk = wa_zdsmter_l2-zdsm.
    if sy-subrc eq 0.
      wa_l2-zdsm = wa_zdsmter_l1-zdsm.
    endif.
    collect wa_l2 into it_l2.
    clear wa_l2.
  endloop.

  loop at it_l2 into wa_l2.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge f1date.
*    SELECT SINGLE * FROM YTERRALLC WHERE BZIRK EQ WA_L2-BZIRK AND ENDDA GE ly_dt1.
    if sy-subrc eq 0.
      select single * from zcumpso where zmonth eq ly_dt4+4(2) and zyear eq ly_dt4+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_ll1aprcs1-bzirk =  wa_l2-bzirk.
        wa_ll1aprcs1-julsale =  zcumpso-netval.
        wa_ll1aprcs1-zdsm = wa_l2-zdsm.
        wa_ll1aprcs1-rm = wa_l2-rm.
        wa_ll1aprcs1-zm = wa_l2-zm.
        collect wa_ll1aprcs1 into it_ll1aprcs1.
        clear wa_ll1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
      if sy-subrc eq 0.
        wa_ll1taprcs1-bzirk =  wa_l2-bzirk.
        wa_ll1taprcs1-julsale =  ysd_dist_targt-month04.
        wa_ll1taprcs1-zdsm = wa_l2-zdsm.
        wa_ll1taprcs1-rm = wa_l2-rm.
        wa_ll1taprcs1-zm = wa_l2-zm.
        collect wa_ll1taprcs1 into it_ll1taprcs1.
        clear wa_ll1taprcs1.
      endif.

      select single * from zrcumpso where zmonth eq ly_dt4+4(2) and zyear eq llyear and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_lyl1aprcs1-bzirk =  wa_l2-bzirk.
        wa_lyl1aprcs1-julsale =  zrcumpso-netval.
        wa_lyl1aprcs1-zdsm = wa_l2-zdsm.
        wa_lyl1aprcs1-rm = wa_l2-rm.
        wa_lyl1aprcs1-zm = wa_l2-zm.
        collect wa_lyl1aprcs1 into it_lyl1aprcs1.
        clear wa_lyl1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq llyear.
      if sy-subrc eq 0.
        wa_lyl1taprcs1-bzirk =  wa_l2-bzirk.
        wa_lyl1taprcs1-julsale =  ysd_dist_targt-month04.
        wa_lyl1taprcs1-zdsm = wa_l2-zdsm.
        wa_lyl1taprcs1-rm = wa_l2-rm.
        wa_lyl1taprcs1-zm = wa_l2-zm.
        collect wa_lyl1taprcs1 into it_lyl1taprcs1.
        clear wa_lyl1taprcs1.
      endif.


      if f4date le date2.
        select single * from zrcumpso where zmonth eq ly_dt4+4(2) and zyear eq ly_dt4+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_llaprcs1-bzirk =  wa_l2-bzirk.
          wa_llaprcs1-julsale =  zrcumpso-netval.
          wa_llaprcs1-zdsm = wa_l2-zdsm.
          wa_llaprcs1-rm = wa_l2-rm.
          wa_llaprcs1-zm = wa_l2-zm.
          collect wa_llaprcs1 into it_llaprcs1.
          clear wa_llaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
        if sy-subrc eq 0.
          wa_lltaprcs1-bzirk =  wa_l2-bzirk.
          wa_lltaprcs1-julsale =  ysd_dist_targt-month04.
          wa_lltaprcs1-zdsm = wa_l2-zdsm.
          wa_lltaprcs1-rm = wa_l2-rm.
          wa_lltaprcs1-zm = wa_l2-zm.
          collect wa_lltaprcs1 into it_lltaprcs1.
          clear wa_lltaprcs1.
        endif.

        select single * from zrcumpso where zmonth eq ly_dt4+4(2) and zyear eq llyear and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_lylaprcs1-bzirk =  wa_l2-bzirk.
          wa_lylaprcs1-julsale =  zrcumpso-netval.
          wa_lylaprcs1-zdsm = wa_l2-zdsm.
          wa_lylaprcs1-rm = wa_l2-rm.
          wa_lylaprcs1-zm = wa_l2-zm.
          collect wa_lylaprcs1 into it_lylaprcs1.
          clear wa_lylaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq llyear.
        if sy-subrc eq 0.
          wa_lyltaprcs1-bzirk =  wa_l2-bzirk.
          wa_lyltaprcs1-julsale =  ysd_dist_targt-month04.
          wa_lyltaprcs1-zdsm = wa_l2-zdsm.
          wa_lyltaprcs1-rm = wa_l2-rm.
          wa_lyltaprcs1-zm = wa_l2-zm.
          collect wa_lyltaprcs1 into it_lyltaprcs1.
          clear wa_lyltaprcs1.
        endif.


      endif.
    endif.
  endloop.

************AUG*************************
  clear : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1,it_l2,wa_l2.
  select * from zdsmter into table it_zdsmter_l1 where zdsm in org and zmonth eq ly_dt5+4(2) and zyear eq ly_dt5+0(4).
  if sy-subrc eq 0.
    select * from zdsmter into table it_zdsmter_l2 for all entries in it_zdsmter_l1 where zdsm eq it_zdsmter_l1-bzirk and
      zmonth eq ly_dt5+4(2)  and zyear eq ly_dt5+0(4).
  endif.
  loop at it_zdsmter_l2 into wa_zdsmter_l2 where zdsm+0(2) eq 'R-'.
    wa_l2-zmonth = wa_zdsmter_l2-zmonth.
    wa_l2-zyear = wa_zdsmter_l2-zyear.
    wa_l2-bzirk = wa_zdsmter_l2-bzirk.
    wa_l2-rm = wa_zdsmter_l2-zdsm.
    read table it_zdsmter_l2 into wa_zdsmter_l2 with key bzirk = wa_zdsmter_l2-zdsm zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_l2-zm = wa_zdsmter_l2-zdsm.
    endif.
    read table it_zdsmter_l1 into wa_zdsmter_l1 with key bzirk = wa_zdsmter_l2-zdsm.
    if sy-subrc eq 0.
      wa_l2-zdsm = wa_zdsmter_l1-zdsm.
    endif.
    collect wa_l2 into it_l2.
    clear wa_l2.
  endloop.

  loop at it_l2 into wa_l2.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge f1date.
*    SELECT SINGLE * FROM YTERRALLC WHERE BZIRK EQ WA_L2-BZIRK AND ENDDA GE ly_dt1.
    if sy-subrc eq 0.
      select single * from zcumpso where zmonth eq ly_dt5+4(2) and zyear eq ly_dt5+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_ll1aprcs1-bzirk =  wa_l2-bzirk.
        wa_ll1aprcs1-augsale =  zcumpso-netval.
        wa_ll1aprcs1-zdsm = wa_l2-zdsm.
        wa_ll1aprcs1-rm = wa_l2-rm.
        wa_ll1aprcs1-zm = wa_l2-zm.
        collect wa_ll1aprcs1 into it_ll1aprcs1.
        clear wa_ll1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
      if sy-subrc eq 0.
        wa_ll1taprcs1-bzirk =  wa_l2-bzirk.
        wa_ll1taprcs1-augsale =  ysd_dist_targt-month05.
        wa_ll1taprcs1-zdsm = wa_l2-zdsm.
        wa_ll1taprcs1-rm = wa_l2-rm.
        wa_ll1taprcs1-zm = wa_l2-zm.
        collect wa_ll1taprcs1 into it_ll1taprcs1.
        clear wa_ll1taprcs1.
      endif.

      select single * from zrcumpso where zmonth eq ly_dt5+4(2) and zyear eq llyear and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_lyl1aprcs1-bzirk =  wa_l2-bzirk.
        wa_lyl1aprcs1-augsale =  zrcumpso-netval.
        wa_lyl1aprcs1-zdsm = wa_l2-zdsm.
        wa_lyl1aprcs1-rm = wa_l2-rm.
        wa_lyl1aprcs1-zm = wa_l2-zm.
        collect wa_lyl1aprcs1 into it_lyl1aprcs1.
        clear wa_lyl1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq llyear.
      if sy-subrc eq 0.
        wa_lyl1taprcs1-bzirk =  wa_l2-bzirk.
        wa_lyl1taprcs1-augsale =  ysd_dist_targt-month05.
        wa_lyl1taprcs1-zdsm = wa_l2-zdsm.
        wa_lyl1taprcs1-rm = wa_l2-rm.
        wa_lyl1taprcs1-zm = wa_l2-zm.
        collect wa_lyl1taprcs1 into it_lyl1taprcs1.
        clear wa_lyl1taprcs1.
      endif.


      if f5date le date2.
        select single * from zrcumpso where zmonth eq ly_dt5+4(2) and zyear eq ly_dt5+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_llaprcs1-bzirk =  wa_l2-bzirk.
          wa_llaprcs1-augsale =  zrcumpso-netval.
          wa_llaprcs1-zdsm = wa_l2-zdsm.
          wa_llaprcs1-rm = wa_l2-rm.
          wa_llaprcs1-zm = wa_l2-zm.
          collect wa_llaprcs1 into it_llaprcs1.
          clear wa_llaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
        if sy-subrc eq 0.
          wa_lltaprcs1-bzirk =  wa_l2-bzirk.
          wa_lltaprcs1-augsale =  ysd_dist_targt-month05.
          wa_lltaprcs1-zdsm = wa_l2-zdsm.
          wa_lltaprcs1-rm = wa_l2-rm.
          wa_lltaprcs1-zm = wa_l2-zm.
          collect wa_lltaprcs1 into it_lltaprcs1.
          clear wa_lltaprcs1.
        endif.

        select single * from zrcumpso where zmonth eq ly_dt5+4(2) and zyear eq llyear and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_lylaprcs1-bzirk =  wa_l2-bzirk.
          wa_lylaprcs1-augsale =  zrcumpso-netval.
          wa_lylaprcs1-zdsm = wa_l2-zdsm.
          wa_lylaprcs1-rm = wa_l2-rm.
          wa_lylaprcs1-zm = wa_l2-zm.
          collect wa_lylaprcs1 into it_lylaprcs1.
          clear wa_lylaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq llyear.
        if sy-subrc eq 0.
          wa_lyltaprcs1-bzirk =  wa_l2-bzirk.
          wa_lyltaprcs1-augsale =  ysd_dist_targt-month05.
          wa_lyltaprcs1-zdsm = wa_l2-zdsm.
          wa_lyltaprcs1-rm = wa_l2-rm.
          wa_lyltaprcs1-zm = wa_l2-zm.
          collect wa_lyltaprcs1 into it_lyltaprcs1.
          clear wa_lyltaprcs1.
        endif.


      endif.
    endif.
  endloop.

*************SEP*************************
  clear : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1,it_l2,wa_l2.
  select * from zdsmter into table it_zdsmter_l1 where zdsm in org and zmonth eq ly_dt6+4(2) and zyear eq ly_dt6+0(4).
  if sy-subrc eq 0.
    select * from zdsmter into table it_zdsmter_l2 for all entries in it_zdsmter_l1 where zdsm eq it_zdsmter_l1-bzirk and
      zmonth eq ly_dt6+4(2)  and zyear eq ly_dt6+0(4).
  endif.
  loop at it_zdsmter_l2 into wa_zdsmter_l2 where zdsm+0(2) eq 'R-'.
    wa_l2-zmonth = wa_zdsmter_l2-zmonth.
    wa_l2-zyear = wa_zdsmter_l2-zyear.
    wa_l2-bzirk = wa_zdsmter_l2-bzirk.
    wa_l2-rm = wa_zdsmter_l2-zdsm.
    read table it_zdsmter_l2 into wa_zdsmter_l2 with key bzirk = wa_zdsmter_l2-zdsm zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_l2-zm = wa_zdsmter_l2-zdsm.
    endif.
    read table it_zdsmter_l1 into wa_zdsmter_l1 with key bzirk = wa_zdsmter_l2-zdsm.
    if sy-subrc eq 0.
      wa_l2-zdsm = wa_zdsmter_l1-zdsm.
    endif.
    collect wa_l2 into it_l2.
    clear wa_l2.
  endloop.

  loop at it_l2 into wa_l2.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge f1date.
*    SELECT SINGLE * FROM YTERRALLC WHERE BZIRK EQ WA_L2-BZIRK AND ENDDA GE ly_dt1.
    if sy-subrc eq 0.

      select single * from zcumpso where zmonth eq ly_dt6+4(2) and zyear eq ly_dt6+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_ll1aprcs1-bzirk =  wa_l2-bzirk.
        wa_ll1aprcs1-sepsale =  zcumpso-netval.
        wa_ll1aprcs1-zdsm = wa_l2-zdsm.
        wa_ll1aprcs1-rm = wa_l2-rm.
        wa_ll1aprcs1-zm = wa_l2-zm.
        collect wa_ll1aprcs1 into it_ll1aprcs1.
        clear wa_ll1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
      if sy-subrc eq 0.
        wa_ll1taprcs1-bzirk =  wa_l2-bzirk.
        wa_ll1taprcs1-sepsale =  ysd_dist_targt-month06.
        wa_ll1taprcs1-zdsm = wa_l2-zdsm.
        wa_ll1taprcs1-rm = wa_l2-rm.
        wa_ll1taprcs1-zm = wa_l2-zm.
        collect wa_ll1taprcs1 into it_ll1taprcs1.
        clear wa_ll1taprcs1.
      endif.

      select single * from zrcumpso where zmonth eq ly_dt6+4(2) and zyear eq llyear and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_lyl1aprcs1-bzirk =  wa_l2-bzirk.
        wa_lyl1aprcs1-sepsale =  zrcumpso-netval.
        wa_lyl1aprcs1-zdsm = wa_l2-zdsm.
        wa_lyl1aprcs1-rm = wa_l2-rm.
        wa_lyl1aprcs1-zm = wa_l2-zm.
        collect wa_lyl1aprcs1 into it_lyl1aprcs1.
        clear wa_lyl1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq llyear.
      if sy-subrc eq 0.
        wa_lyl1taprcs1-bzirk =  wa_l2-bzirk.
        wa_lyl1taprcs1-sepsale =  ysd_dist_targt-month06.
        wa_lyl1taprcs1-zdsm = wa_l2-zdsm.
        wa_lyl1taprcs1-rm = wa_l2-rm.
        wa_lyl1taprcs1-zm = wa_l2-zm.
        collect wa_lyl1taprcs1 into it_lyl1taprcs1.
        clear wa_lyl1taprcs1.
      endif.


      if f6date le date2.
        select single * from zrcumpso where zmonth eq ly_dt6+4(2) and zyear eq ly_dt6+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_llaprcs1-bzirk =  wa_l2-bzirk.
          wa_llaprcs1-sepsale =  zrcumpso-netval.
          wa_llaprcs1-zdsm = wa_l2-zdsm.
          wa_llaprcs1-rm = wa_l2-rm.
          wa_llaprcs1-zm = wa_l2-zm.
          collect wa_llaprcs1 into it_llaprcs1.
          clear wa_llaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
        if sy-subrc eq 0.
          wa_lltaprcs1-bzirk =  wa_l2-bzirk.
          wa_lltaprcs1-sepsale =  ysd_dist_targt-month06.
          wa_lltaprcs1-zdsm = wa_l2-zdsm.
          wa_lltaprcs1-rm = wa_l2-rm.
          wa_lltaprcs1-zm = wa_l2-zm.
          collect wa_lltaprcs1 into it_lltaprcs1.
          clear wa_lltaprcs1.
        endif.

        select single * from zrcumpso where zmonth eq ly_dt6+4(2) and zyear eq llyear and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_lylaprcs1-bzirk =  wa_l2-bzirk.
          wa_lylaprcs1-sepsale =  zrcumpso-netval.
          wa_lylaprcs1-zdsm = wa_l2-zdsm.
          wa_lylaprcs1-rm = wa_l2-rm.
          wa_lylaprcs1-zm = wa_l2-zm.
          collect wa_lylaprcs1 into it_lylaprcs1.
          clear wa_lylaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq llyear.
        if sy-subrc eq 0.
          wa_lyltaprcs1-bzirk =  wa_l2-bzirk.
          wa_lyltaprcs1-sepsale =  ysd_dist_targt-month06.
          wa_lyltaprcs1-zdsm = wa_l2-zdsm.
          wa_lyltaprcs1-rm = wa_l2-rm.
          wa_lyltaprcs1-zm = wa_l2-zm.
          collect wa_lyltaprcs1 into it_lyltaprcs1.
          clear wa_lyltaprcs1.
        endif.

      endif.
    endif.
  endloop.

*  *  ************OCT*************************
  clear : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1,it_l2,wa_l2.
  select * from zdsmter into table it_zdsmter_l1 where zdsm in org and zmonth eq ly_dt7+4(2) and zyear eq ly_dt7+0(4).
  if sy-subrc eq 0.
    select * from zdsmter into table it_zdsmter_l2 for all entries in it_zdsmter_l1 where zdsm eq it_zdsmter_l1-bzirk and
      zmonth eq ly_dt7+4(2)  and zyear eq ly_dt7+0(4).
  endif.
  loop at it_zdsmter_l2 into wa_zdsmter_l2 where zdsm+0(2) eq 'R-'.
    wa_l2-zmonth = wa_zdsmter_l2-zmonth.
    wa_l2-zyear = wa_zdsmter_l2-zyear.
    wa_l2-bzirk = wa_zdsmter_l2-bzirk.
    wa_l2-rm = wa_zdsmter_l2-zdsm.
    read table it_zdsmter_l2 into wa_zdsmter_l2 with key bzirk = wa_zdsmter_l2-zdsm zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_l2-zm = wa_zdsmter_l2-zdsm.
    endif.
    read table it_zdsmter_l1 into wa_zdsmter_l1 with key bzirk = wa_zdsmter_l2-zdsm.
    if sy-subrc eq 0.
      wa_l2-zdsm = wa_zdsmter_l1-zdsm.
    endif.
    collect wa_l2 into it_l2.
    clear wa_l2.
  endloop.

  loop at it_l2 into wa_l2.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge f1date.
*    SELECT SINGLE * FROM YTERRALLC WHERE BZIRK EQ WA_L2-BZIRK AND ENDDA GE ly_dt1.
    if sy-subrc eq 0.
      select single * from zcumpso where zmonth eq ly_dt7+4(2) and zyear eq ly_dt7+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_ll1aprcs1-bzirk =  wa_l2-bzirk.
        wa_ll1aprcs1-octsale =  zcumpso-netval.
        wa_ll1aprcs1-zdsm = wa_l2-zdsm.
        wa_ll1aprcs1-rm = wa_l2-rm.
        wa_ll1aprcs1-zm = wa_l2-zm.
        collect wa_ll1aprcs1 into it_ll1aprcs1.
        clear wa_ll1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
      if sy-subrc eq 0.
        wa_ll1taprcs1-bzirk =  wa_l2-bzirk.
        wa_ll1taprcs1-octsale =  ysd_dist_targt-month07.
        wa_ll1taprcs1-zdsm = wa_l2-zdsm.
        wa_ll1taprcs1-rm = wa_l2-rm.
        wa_ll1taprcs1-zm = wa_l2-zm.
        collect wa_ll1taprcs1 into it_ll1taprcs1.
        clear wa_ll1taprcs1.
      endif.

      select single * from zrcumpso where zmonth eq ly_dt7+4(2) and zyear eq llyear and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_lyl1aprcs1-bzirk =  wa_l2-bzirk.
        wa_lyl1aprcs1-octsale =  zrcumpso-netval.
        wa_lyl1aprcs1-zdsm = wa_l2-zdsm.
        wa_lyl1aprcs1-rm = wa_l2-rm.
        wa_lyl1aprcs1-zm = wa_l2-zm.
        collect wa_lyl1aprcs1 into it_lyl1aprcs1.
        clear wa_lyl1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq llyear.
      if sy-subrc eq 0.
        wa_lyl1taprcs1-bzirk =  wa_l2-bzirk.
        wa_lyl1taprcs1-octsale =  ysd_dist_targt-month07.
        wa_lyl1taprcs1-zdsm = wa_l2-zdsm.
        wa_lyl1taprcs1-rm = wa_l2-rm.
        wa_lyl1taprcs1-zm = wa_l2-zm.
        collect wa_lyl1taprcs1 into it_lyl1taprcs1.
        clear wa_lyl1taprcs1.
      endif.



      if f7date le date2.
        select single * from zrcumpso where zmonth eq ly_dt7+4(2) and zyear eq ly_dt7+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_llaprcs1-bzirk =  wa_l2-bzirk.
          wa_llaprcs1-octsale =  zrcumpso-netval.
          wa_llaprcs1-zdsm = wa_l2-zdsm.
          wa_llaprcs1-rm = wa_l2-rm.
          wa_llaprcs1-zm = wa_l2-zm.
          collect wa_llaprcs1 into it_llaprcs1.
          clear wa_llaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
        if sy-subrc eq 0.
          wa_lltaprcs1-bzirk =  wa_l2-bzirk.
          wa_lltaprcs1-octsale =  ysd_dist_targt-month07.
          wa_lltaprcs1-zdsm = wa_l2-zdsm.
          wa_lltaprcs1-rm = wa_l2-rm.
          wa_lltaprcs1-zm = wa_l2-zm.
          collect wa_lltaprcs1 into it_lltaprcs1.
          clear wa_lltaprcs1.
        endif.

        select single * from zrcumpso where zmonth eq ly_dt7+4(2) and zyear eq llyear and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_lylaprcs1-bzirk =  wa_l2-bzirk.
          wa_lylaprcs1-octsale =  zrcumpso-netval.
          wa_lylaprcs1-zdsm = wa_l2-zdsm.
          wa_lylaprcs1-rm = wa_l2-rm.
          wa_lylaprcs1-zm = wa_l2-zm.
          collect wa_lylaprcs1 into it_lylaprcs1.
          clear wa_lylaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq llyear.
        if sy-subrc eq 0.
          wa_lyltaprcs1-bzirk =  wa_l2-bzirk.
          wa_lyltaprcs1-octsale =  ysd_dist_targt-month07.
          wa_lyltaprcs1-zdsm = wa_l2-zdsm.
          wa_lyltaprcs1-rm = wa_l2-rm.
          wa_lyltaprcs1-zm = wa_l2-zm.
          collect wa_lyltaprcs1 into it_lyltaprcs1.
          clear wa_lyltaprcs1.
        endif.

      endif.
    endif.
  endloop.

*  ************NOV*************************
  clear : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1,it_l2,wa_l2.
  select * from zdsmter into table it_zdsmter_l1 where zdsm in org and zmonth eq ly_dt8+4(2) and zyear eq ly_dt8+0(4).
  if sy-subrc eq 0.
    select * from zdsmter into table it_zdsmter_l2 for all entries in it_zdsmter_l1 where zdsm eq it_zdsmter_l1-bzirk and
      zmonth eq ly_dt8+4(2)  and zyear eq ly_dt8+0(4).
  endif.
  loop at it_zdsmter_l2 into wa_zdsmter_l2 where zdsm+0(2) eq 'R-'.
    wa_l2-zmonth = wa_zdsmter_l2-zmonth.
    wa_l2-zyear = wa_zdsmter_l2-zyear.
    wa_l2-bzirk = wa_zdsmter_l2-bzirk.
    wa_l2-rm = wa_zdsmter_l2-zdsm.
    read table it_zdsmter_l2 into wa_zdsmter_l2 with key bzirk = wa_zdsmter_l2-zdsm zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_l2-zm = wa_zdsmter_l2-zdsm.
    endif.
    read table it_zdsmter_l1 into wa_zdsmter_l1 with key bzirk = wa_zdsmter_l2-zdsm.
    if sy-subrc eq 0.
      wa_l2-zdsm = wa_zdsmter_l1-zdsm.
    endif.
    collect wa_l2 into it_l2.
    clear wa_l2.
  endloop.

  loop at it_l2 into wa_l2.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge f1date.
*    SELECT SINGLE * FROM YTERRALLC WHERE BZIRK EQ WA_L2-BZIRK AND ENDDA GE ly_dt1.
    if sy-subrc eq 0.
      select single * from zcumpso where zmonth eq ly_dt8+4(2) and zyear eq ly_dt8+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_ll1aprcs1-bzirk =  wa_l2-bzirk.
        wa_ll1aprcs1-novsale =  zcumpso-netval.
        wa_ll1aprcs1-zdsm = wa_l2-zdsm.
        wa_ll1aprcs1-rm = wa_l2-rm.
        wa_ll1aprcs1-zm = wa_l2-zm.
        collect wa_ll1aprcs1 into it_ll1aprcs1.
        clear wa_ll1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
      if sy-subrc eq 0.
        wa_ll1taprcs1-bzirk =  wa_l2-bzirk.
        wa_ll1taprcs1-novsale =  ysd_dist_targt-month08.
        wa_ll1taprcs1-zdsm = wa_l2-zdsm.
        wa_ll1taprcs1-rm = wa_l2-rm.
        wa_ll1taprcs1-zm = wa_l2-zm.
        collect wa_ll1taprcs1 into it_ll1taprcs1.
        clear wa_ll1taprcs1.
      endif.

      select single * from zrcumpso where zmonth eq ly_dt8+4(2) and zyear eq llyear and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_lyl1aprcs1-bzirk =  wa_l2-bzirk.
        wa_lyl1aprcs1-novsale =  zrcumpso-netval.
        wa_lyl1aprcs1-zdsm = wa_l2-zdsm.
        wa_lyl1aprcs1-rm = wa_l2-rm.
        wa_lyl1aprcs1-zm = wa_l2-zm.
        collect wa_lyl1aprcs1 into it_lyl1aprcs1.
        clear wa_lyl1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq llyear.
      if sy-subrc eq 0.
        wa_lyl1taprcs1-bzirk =  wa_l2-bzirk.
        wa_lyl1taprcs1-novsale =  ysd_dist_targt-month08.
        wa_lyl1taprcs1-zdsm = wa_l2-zdsm.
        wa_lyl1taprcs1-rm = wa_l2-rm.
        wa_lyl1taprcs1-zm = wa_l2-zm.
        collect wa_lyl1taprcs1 into it_lyl1taprcs1.
        clear wa_lyl1taprcs1.
      endif.


      if f8date le date2.
        select single * from zrcumpso where zmonth eq ly_dt8+4(2) and zyear eq ly_dt8+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_llaprcs1-bzirk =  wa_l2-bzirk.
          wa_llaprcs1-novsale =  zrcumpso-netval.
          wa_llaprcs1-zdsm = wa_l2-zdsm.
          wa_llaprcs1-rm = wa_l2-rm.
          wa_llaprcs1-zm = wa_l2-zm.
          collect wa_llaprcs1 into it_llaprcs1.
          clear wa_llaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
        if sy-subrc eq 0.
          wa_lltaprcs1-bzirk =  wa_l2-bzirk.
          wa_lltaprcs1-novsale =  ysd_dist_targt-month08.
          wa_lltaprcs1-zdsm = wa_l2-zdsm.
          wa_lltaprcs1-rm = wa_l2-rm.
          wa_lltaprcs1-zm = wa_l2-zm.
          collect wa_lltaprcs1 into it_lltaprcs1.
          clear wa_lltaprcs1.
        endif.

        select single * from zrcumpso where zmonth eq ly_dt8+4(2) and zyear eq llyear and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_lylaprcs1-bzirk =  wa_l2-bzirk.
          wa_lylaprcs1-novsale =  zrcumpso-netval.
          wa_lylaprcs1-zdsm = wa_l2-zdsm.
          wa_lylaprcs1-rm = wa_l2-rm.
          wa_lylaprcs1-zm = wa_l2-zm.
          collect wa_lylaprcs1 into it_lylaprcs1.
          clear wa_lylaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq llyear.
        if sy-subrc eq 0.
          wa_lyltaprcs1-bzirk =  wa_l2-bzirk.
          wa_lyltaprcs1-novsale =  ysd_dist_targt-month08.
          wa_lyltaprcs1-zdsm = wa_l2-zdsm.
          wa_lyltaprcs1-rm = wa_l2-rm.
          wa_lyltaprcs1-zm = wa_l2-zm.
          collect wa_lyltaprcs1 into it_lyltaprcs1.
          clear wa_lyltaprcs1.
        endif.


      endif.
    endif.
  endloop.

*  ************DEC*************************
  clear : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1,it_l2,wa_l2.
  select * from zdsmter into table it_zdsmter_l1 where zdsm in org and zmonth eq ly_dt9+4(2) and zyear eq ly_dt9+0(4).
  if sy-subrc eq 0.
    select * from zdsmter into table it_zdsmter_l2 for all entries in it_zdsmter_l1 where zdsm eq it_zdsmter_l1-bzirk and
      zmonth eq ly_dt9+4(2)  and zyear eq ly_dt9+0(4).
  endif.
  loop at it_zdsmter_l2 into wa_zdsmter_l2 where zdsm+0(2) eq 'R-'.
    wa_l2-zmonth = wa_zdsmter_l2-zmonth.
    wa_l2-zyear = wa_zdsmter_l2-zyear.
    wa_l2-bzirk = wa_zdsmter_l2-bzirk.
    wa_l2-rm = wa_zdsmter_l2-zdsm.
    read table it_zdsmter_l2 into wa_zdsmter_l2 with key bzirk = wa_zdsmter_l2-zdsm zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_l2-zm = wa_zdsmter_l2-zdsm.
    endif.
    read table it_zdsmter_l1 into wa_zdsmter_l1 with key bzirk = wa_zdsmter_l2-zdsm.
    if sy-subrc eq 0.
      wa_l2-zdsm = wa_zdsmter_l1-zdsm.
    endif.
    collect wa_l2 into it_l2.
    clear wa_l2.
  endloop.

  loop at it_l2 into wa_l2.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge f1date.
*    SELECT SINGLE * FROM YTERRALLC WHERE BZIRK EQ WA_L2-BZIRK AND ENDDA GE ly_dt1.
    if sy-subrc eq 0.
      select single * from zcumpso where zmonth eq ly_dt9+4(2) and zyear eq ly_dt9+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_ll1aprcs1-bzirk =  wa_l2-bzirk.
        wa_ll1aprcs1-decsale =  zcumpso-netval.
        wa_ll1aprcs1-zdsm = wa_l2-zdsm.
        wa_ll1aprcs1-rm = wa_l2-rm.
        wa_ll1aprcs1-zm = wa_l2-zm.
        collect wa_ll1aprcs1 into it_ll1aprcs1.
        clear wa_ll1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
      if sy-subrc eq 0.
        wa_ll1taprcs1-bzirk =  wa_l2-bzirk.
        wa_ll1taprcs1-decsale =  ysd_dist_targt-month09.
        wa_ll1taprcs1-zdsm = wa_l2-zdsm.
        wa_ll1taprcs1-rm = wa_l2-rm.
        wa_ll1taprcs1-zm = wa_l2-zm.
        collect wa_ll1taprcs1 into it_ll1taprcs1.
        clear wa_ll1taprcs1.
      endif.

      select single * from zrcumpso where zmonth eq ly_dt9+4(2) and zyear eq llyear and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_lyl1aprcs1-bzirk =  wa_l2-bzirk.
        wa_lyl1aprcs1-decsale =  zrcumpso-netval.
        wa_lyl1aprcs1-zdsm = wa_l2-zdsm.
        wa_lyl1aprcs1-rm = wa_l2-rm.
        wa_lyl1aprcs1-zm = wa_l2-zm.
        collect wa_lyl1aprcs1 into it_lyl1aprcs1.
        clear wa_lyl1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq llyear.
      if sy-subrc eq 0.
        wa_lyl1taprcs1-bzirk =  wa_l2-bzirk.
        wa_lyl1taprcs1-decsale =  ysd_dist_targt-month09.
        wa_lyl1taprcs1-zdsm = wa_l2-zdsm.
        wa_lyl1taprcs1-rm = wa_l2-rm.
        wa_lyl1taprcs1-zm = wa_l2-zm.
        collect wa_lyl1taprcs1 into it_lyl1taprcs1.
        clear wa_lyl1taprcs1.
      endif.



      if f9date le date2.
        select single * from zrcumpso where zmonth eq ly_dt9+4(2) and zyear eq ly_dt9+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_llaprcs1-bzirk =  wa_l2-bzirk.
          wa_llaprcs1-decsale =  zrcumpso-netval.
          wa_llaprcs1-zdsm = wa_l2-zdsm.
          wa_llaprcs1-rm = wa_l2-rm.
          wa_llaprcs1-zm = wa_l2-zm.
          collect wa_llaprcs1 into it_llaprcs1.
          clear wa_llaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
        if sy-subrc eq 0.
          wa_lltaprcs1-bzirk =  wa_l2-bzirk.
          wa_lltaprcs1-decsale =  ysd_dist_targt-month09.
          wa_lltaprcs1-zdsm = wa_l2-zdsm.
          wa_lltaprcs1-rm = wa_l2-rm.
          wa_lltaprcs1-zm = wa_l2-zm.
          collect wa_lltaprcs1 into it_lltaprcs1.
          clear wa_lltaprcs1.
        endif.

        select single * from zrcumpso where zmonth eq ly_dt9+4(2) and zyear eq llyear and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_lylaprcs1-bzirk =  wa_l2-bzirk.
          wa_lylaprcs1-decsale =  zrcumpso-netval.
          wa_lylaprcs1-zdsm = wa_l2-zdsm.
          wa_lylaprcs1-rm = wa_l2-rm.
          wa_lylaprcs1-zm = wa_l2-zm.
          collect wa_lylaprcs1 into it_lylaprcs1.
          clear wa_lylaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq llyear.
        if sy-subrc eq 0.
          wa_lyltaprcs1-bzirk =  wa_l2-bzirk.
          wa_lyltaprcs1-decsale =  ysd_dist_targt-month09.
          wa_lyltaprcs1-zdsm = wa_l2-zdsm.
          wa_lyltaprcs1-rm = wa_l2-rm.
          wa_lyltaprcs1-zm = wa_l2-zm.
          collect wa_lyltaprcs1 into it_lyltaprcs1.
          clear wa_lyltaprcs1.
        endif.


      endif.
    endif.
  endloop.

* ************JAN*************************
  clear : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1,it_l2,wa_l2.
  select * from zdsmter into table it_zdsmter_l1 where zdsm in org and zmonth eq ly_dt10+4(2) and zyear eq ly_dt10+0(4).
  if sy-subrc eq 0.
    select * from zdsmter into table it_zdsmter_l2 for all entries in it_zdsmter_l1 where zdsm eq it_zdsmter_l1-bzirk and
      zmonth eq ly_dt10+4(2)  and zyear eq ly_dt10+0(4).
  endif.
  loop at it_zdsmter_l2 into wa_zdsmter_l2 where zdsm+0(2) eq 'R-'.
    wa_l2-zmonth = wa_zdsmter_l2-zmonth.
    wa_l2-zyear = wa_zdsmter_l2-zyear.
    wa_l2-bzirk = wa_zdsmter_l2-bzirk.
    wa_l2-rm = wa_zdsmter_l2-zdsm.
    read table it_zdsmter_l2 into wa_zdsmter_l2 with key bzirk = wa_zdsmter_l2-zdsm zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_l2-zm = wa_zdsmter_l2-zdsm.
    endif.
    read table it_zdsmter_l1 into wa_zdsmter_l1 with key bzirk = wa_zdsmter_l2-zdsm.
    if sy-subrc eq 0.
      wa_l2-zdsm = wa_zdsmter_l1-zdsm.
    endif.
    collect wa_l2 into it_l2.
    clear wa_l2.
  endloop.

  loop at it_l2 into wa_l2.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge f1date.
*    SELECT SINGLE * FROM YTERRALLC WHERE BZIRK EQ WA_L2-BZIRK AND ENDDA GE ly_dt1.
    if sy-subrc eq 0.

      select single * from zcumpso where zmonth eq ly_dt10+4(2) and zyear eq ly_dt10+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_ll1aprcs1-bzirk =  wa_l2-bzirk.
        wa_ll1aprcs1-jansale =  zcumpso-netval.
        wa_ll1aprcs1-zdsm = wa_l2-zdsm.
        wa_ll1aprcs1-rm = wa_l2-rm.
        wa_ll1aprcs1-zm = wa_l2-zm.
        collect wa_ll1aprcs1 into it_ll1aprcs1.
        clear wa_ll1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
      if sy-subrc eq 0.
        wa_ll1taprcs1-bzirk =  wa_l2-bzirk.
        wa_ll1taprcs1-jansale =  ysd_dist_targt-month10.
        wa_ll1taprcs1-zdsm = wa_l2-zdsm.
        wa_ll1taprcs1-rm = wa_l2-rm.
        wa_ll1taprcs1-zm = wa_l2-zm.
        collect wa_ll1taprcs1 into it_ll1taprcs1.
        clear wa_ll1taprcs1.
      endif.

      select single * from zrcumpso where zmonth eq ly_dt10+4(2) and zyear eq lyear and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_lyl1aprcs1-bzirk =  wa_l2-bzirk.
        wa_lyl1aprcs1-jansale =  zrcumpso-netval.
        wa_lyl1aprcs1-zdsm = wa_l2-zdsm.
        wa_lyl1aprcs1-rm = wa_l2-rm.
        wa_lyl1aprcs1-zm = wa_l2-zm.
        collect wa_lyl1aprcs1 into it_lyl1aprcs1.
        clear wa_lyl1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq llyear.
      if sy-subrc eq 0.
        wa_lyl1taprcs1-bzirk =  wa_l2-bzirk.
        wa_lyl1taprcs1-jansale =  ysd_dist_targt-month10.
        wa_lyl1taprcs1-zdsm = wa_l2-zdsm.
        wa_lyl1taprcs1-rm = wa_l2-rm.
        wa_lyl1taprcs1-zm = wa_l2-zm.
        collect wa_lyl1taprcs1 into it_lyl1taprcs1.
        clear wa_lyl1taprcs1.
      endif.





      if f10date le date2.
        select single * from zrcumpso where zmonth eq ly_dt10+4(2) and zyear eq ly_dt10+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_llaprcs1-bzirk =  wa_l2-bzirk.
          wa_llaprcs1-jansale =  zrcumpso-netval.
          wa_llaprcs1-zdsm = wa_l2-zdsm.
          wa_llaprcs1-rm = wa_l2-rm.
          wa_llaprcs1-zm = wa_l2-zm.
          collect wa_llaprcs1 into it_llaprcs1.
          clear wa_llaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
        if sy-subrc eq 0.
          wa_lltaprcs1-bzirk =  wa_l2-bzirk.
          wa_lltaprcs1-jansale =  ysd_dist_targt-month10.
          wa_lltaprcs1-zdsm = wa_l2-zdsm.
          wa_lltaprcs1-rm = wa_l2-rm.
          wa_lltaprcs1-zm = wa_l2-zm.
          collect wa_lltaprcs1 into it_lltaprcs1.
          clear wa_lltaprcs1.
        endif.

        select single * from zrcumpso where zmonth eq ly_dt10+4(2) and zyear eq lyear and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_lylaprcs1-bzirk =  wa_l2-bzirk.
          wa_lylaprcs1-jansale =  zrcumpso-netval.
          wa_lylaprcs1-zdsm = wa_l2-zdsm.
          wa_lylaprcs1-rm = wa_l2-rm.
          wa_lylaprcs1-zm = wa_l2-zm.
          collect wa_lylaprcs1 into it_lylaprcs1.
          clear wa_lylaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq llyear.
        if sy-subrc eq 0.
          wa_lyltaprcs1-bzirk =  wa_l2-bzirk.
          wa_lyltaprcs1-jansale =  ysd_dist_targt-month10.
          wa_lyltaprcs1-zdsm = wa_l2-zdsm.
          wa_lyltaprcs1-rm = wa_l2-rm.
          wa_lyltaprcs1-zm = wa_l2-zm.
          collect wa_lyltaprcs1 into it_lyltaprcs1.
          clear wa_lyltaprcs1.
        endif.



      endif.
    endif.
  endloop.



*  ************FEB*************************
  clear : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1,it_l2,wa_l2.
  select * from zdsmter into table it_zdsmter_l1 where zdsm in org and zmonth eq ly_dt11+4(2) and zyear eq ly_dt11+0(4).
  if sy-subrc eq 0.
    select * from zdsmter into table it_zdsmter_l2 for all entries in it_zdsmter_l1 where zdsm eq it_zdsmter_l1-bzirk and
      zmonth eq ly_dt11+4(2)  and zyear eq ly_dt11+0(4).
  endif.
  loop at it_zdsmter_l2 into wa_zdsmter_l2 where zdsm+0(2) eq 'R-'.
    wa_l2-zmonth = wa_zdsmter_l2-zmonth.
    wa_l2-zyear = wa_zdsmter_l2-zyear.
    wa_l2-bzirk = wa_zdsmter_l2-bzirk.
    wa_l2-rm = wa_zdsmter_l2-zdsm.
    read table it_zdsmter_l2 into wa_zdsmter_l2 with key bzirk = wa_zdsmter_l2-zdsm zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_l2-zm = wa_zdsmter_l2-zdsm.
    endif.
    read table it_zdsmter_l1 into wa_zdsmter_l1 with key bzirk = wa_zdsmter_l2-zdsm.
    if sy-subrc eq 0.
      wa_l2-zdsm = wa_zdsmter_l1-zdsm.
    endif.
    collect wa_l2 into it_l2.
    clear wa_l2.
  endloop.

  loop at it_l2 into wa_l2.

    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge f1date.
*    SELECT SINGLE * FROM YTERRALLC WHERE BZIRK EQ WA_L2-BZIRK AND ENDDA GE ly_dt1.
    if sy-subrc eq 0.
      select single * from zcumpso where zmonth eq ly_dt11+4(2) and zyear eq ly_dt11+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_ll1aprcs1-bzirk =  wa_l2-bzirk.
        wa_ll1aprcs1-febsale =  zcumpso-netval.
        wa_ll1aprcs1-zdsm = wa_l2-zdsm.
        wa_ll1aprcs1-rm = wa_l2-rm.
        wa_ll1aprcs1-zm = wa_l2-zm.
        collect wa_ll1aprcs1 into it_ll1aprcs1.
        clear wa_ll1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
      if sy-subrc eq 0.
        wa_ll1taprcs1-bzirk =  wa_l2-bzirk.
        wa_ll1taprcs1-febsale =  ysd_dist_targt-month11.
        wa_ll1taprcs1-zdsm = wa_l2-zdsm.
        wa_ll1taprcs1-rm = wa_l2-rm.
        wa_ll1taprcs1-zm = wa_l2-zm.
        collect wa_ll1taprcs1 into it_ll1taprcs1.
        clear wa_ll1taprcs1.
      endif.

      select single * from zrcumpso where zmonth eq ly_dt11+4(2) and zyear eq lyear and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_lyl1aprcs1-bzirk =  wa_l2-bzirk.
        wa_lyl1aprcs1-febsale =  zrcumpso-netval.
        wa_lyl1aprcs1-zdsm = wa_l2-zdsm.
        wa_lyl1aprcs1-rm = wa_l2-rm.
        wa_lyl1aprcs1-zm = wa_l2-zm.
        collect wa_lyl1aprcs1 into it_lyl1aprcs1.
        clear wa_lyl1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq llyear.
      if sy-subrc eq 0.
        wa_lyl1taprcs1-bzirk =  wa_l2-bzirk.
        wa_lyl1taprcs1-febsale =  ysd_dist_targt-month11.
        wa_lyl1taprcs1-zdsm = wa_l2-zdsm.
        wa_lyl1taprcs1-rm = wa_l2-rm.
        wa_lyl1taprcs1-zm = wa_l2-zm.
        collect wa_lyl1taprcs1 into it_lyl1taprcs1.
        clear wa_lyl1taprcs1.
      endif.



      if f11date le date2.
        select single * from zrcumpso where zmonth eq ly_dt11+4(2) and zyear eq ly_dt11+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_llaprcs1-bzirk =  wa_l2-bzirk.
          wa_llaprcs1-febsale =  zrcumpso-netval.
          wa_llaprcs1-zdsm = wa_l2-zdsm.
          wa_llaprcs1-rm = wa_l2-rm.
          wa_llaprcs1-zm = wa_l2-zm.
          collect wa_llaprcs1 into it_llaprcs1.
          clear wa_llaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
        if sy-subrc eq 0.
          wa_lltaprcs1-bzirk =  wa_l2-bzirk.
          wa_lltaprcs1-febsale =  ysd_dist_targt-month11.
          wa_lltaprcs1-zdsm = wa_l2-zdsm.
          wa_lltaprcs1-rm = wa_l2-rm.
          wa_lltaprcs1-zm = wa_l2-zm.
          collect wa_lltaprcs1 into it_lltaprcs1.
          clear wa_lltaprcs1.
        endif.

        select single * from zrcumpso where zmonth eq ly_dt11+4(2) and zyear eq lyear and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_lylaprcs1-bzirk =  wa_l2-bzirk.
          wa_lylaprcs1-febsale =  zrcumpso-netval.
          wa_lylaprcs1-zdsm = wa_l2-zdsm.
          wa_lylaprcs1-rm = wa_l2-rm.
          wa_lylaprcs1-zm = wa_l2-zm.
          collect wa_lylaprcs1 into it_lylaprcs1.
          clear wa_lylaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq llyear.
        if sy-subrc eq 0.
          wa_lyltaprcs1-bzirk =  wa_l2-bzirk.
          wa_lyltaprcs1-febsale =  ysd_dist_targt-month11.
          wa_lyltaprcs1-zdsm = wa_l2-zdsm.
          wa_lyltaprcs1-rm = wa_l2-rm.
          wa_lyltaprcs1-zm = wa_l2-zm.
          collect wa_lyltaprcs1 into it_lyltaprcs1.
          clear wa_lyltaprcs1.
        endif.



      endif.
    endif.
  endloop.

************MAR*************************
  clear : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1,it_l2,wa_l2.
  select * from zdsmter into table it_zdsmter_l1 where zdsm in org and zmonth eq ly_dt12+4(2) and zyear eq ly_dt12+0(4).
  if sy-subrc eq 0.
    select * from zdsmter into table it_zdsmter_l2 for all entries in it_zdsmter_l1 where zdsm eq it_zdsmter_l1-bzirk and
      zmonth eq ly_dt12+4(2)  and zyear eq ly_dt12+0(4).
  endif.
  loop at it_zdsmter_l2 into wa_zdsmter_l2 where zdsm+0(2) eq 'R-'.
    wa_l2-zmonth = wa_zdsmter_l2-zmonth.
    wa_l2-zyear = wa_zdsmter_l2-zyear.
    wa_l2-bzirk = wa_zdsmter_l2-bzirk.
    wa_l2-rm = wa_zdsmter_l2-zdsm.
    read table it_zdsmter_l2 into wa_zdsmter_l2 with key bzirk = wa_zdsmter_l2-zdsm zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_l2-zm = wa_zdsmter_l2-zdsm.
    endif.
    read table it_zdsmter_l1 into wa_zdsmter_l1 with key bzirk = wa_zdsmter_l2-zdsm.
    if sy-subrc eq 0.
      wa_l2-zdsm = wa_zdsmter_l1-zdsm.
    endif.
    collect wa_l2 into it_l2.
    clear wa_l2.
  endloop.

  loop at it_l2 into wa_l2.
    select single * from yterrallc where bzirk eq wa_l2-bzirk and endda ge f1date.
*    SELECT SINGLE * FROM YTERRALLC WHERE BZIRK EQ WA_L2-BZIRK AND ENDDA GE ly_dt1.
    if sy-subrc eq 0.
      select single * from zcumpso where zmonth eq ly_dt12+4(2) and zyear eq ly_dt12+0(4) and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_ll1aprcs1-bzirk =  wa_l2-bzirk.
        wa_ll1aprcs1-marsale =  zcumpso-netval.
        wa_ll1aprcs1-zdsm = wa_l2-zdsm.
        wa_ll1aprcs1-rm = wa_l2-rm.
        wa_ll1aprcs1-zm = wa_l2-zm.
        collect wa_ll1aprcs1 into it_ll1aprcs1.
        clear wa_ll1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
      if sy-subrc eq 0.
        wa_ll1taprcs1-bzirk =  wa_l2-bzirk.
        wa_ll1taprcs1-marsale =  ysd_dist_targt-month12.
        wa_ll1taprcs1-zdsm = wa_l2-zdsm.
        wa_ll1taprcs1-rm = wa_l2-rm.
        wa_ll1taprcs1-zm = wa_l2-zm.
        collect wa_ll1taprcs1 into it_ll1taprcs1.
        clear wa_ll1taprcs1.
      endif.

      select single * from zrcumpso where zmonth eq ly_dt12+4(2) and zyear eq lyear and bzirk eq wa_l2-bzirk.
      if sy-subrc eq 0.
        wa_lyl1aprcs1-bzirk =  wa_l2-bzirk.
        wa_lyl1aprcs1-marsale =  zrcumpso-netval.
        wa_lyl1aprcs1-zdsm = wa_l2-zdsm.
        wa_lyl1aprcs1-rm = wa_l2-rm.
        wa_lyl1aprcs1-zm = wa_l2-zm.
        collect wa_lyl1aprcs1 into it_lyl1aprcs1.
        clear wa_lyl1aprcs1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq llyear.
      if sy-subrc eq 0.
        wa_lyl1taprcs1-bzirk =  wa_l2-bzirk.
        wa_lyl1taprcs1-marsale =  ysd_dist_targt-month12.
        wa_lyl1taprcs1-zdsm = wa_l2-zdsm.
        wa_lyl1taprcs1-rm = wa_l2-rm.
        wa_lyl1taprcs1-zm = wa_l2-zm.
        collect wa_lyl1taprcs1 into it_lyl1taprcs1.
        clear wa_lyl1taprcs1.
      endif.




      if f12date le date2.
        select single * from zrcumpso where zmonth eq ly_dt12+4(2) and zyear eq ly_dt12+0(4) and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_llaprcs1-bzirk =  wa_l2-bzirk.
          wa_llaprcs1-marsale =  zrcumpso-netval.
          wa_llaprcs1-zdsm = wa_l2-zdsm.
          wa_llaprcs1-rm = wa_l2-rm.
          wa_llaprcs1-zm = wa_l2-zm.
          collect wa_llaprcs1 into it_llaprcs1.
          clear wa_llaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq lyear.
        if sy-subrc eq 0.
          wa_lltaprcs1-bzirk =  wa_l2-bzirk.
          wa_lltaprcs1-marsale =  ysd_dist_targt-month12.
          wa_lltaprcs1-zdsm = wa_l2-zdsm.
          wa_lltaprcs1-rm = wa_l2-rm.
          wa_lltaprcs1-zm = wa_l2-zm.
          collect wa_lltaprcs1 into it_lltaprcs1.
          clear wa_lltaprcs1.
        endif.

        select single * from zrcumpso where zmonth eq ly_dt12+4(2) and zyear eq lyear and bzirk eq wa_l2-bzirk.
        if sy-subrc eq 0.
          wa_lylaprcs1-bzirk =  wa_l2-bzirk.
          wa_lylaprcs1-marsale =  zrcumpso-netval.
          wa_lylaprcs1-zdsm = wa_l2-zdsm.
          wa_lylaprcs1-rm = wa_l2-rm.
          wa_lylaprcs1-zm = wa_l2-zm.
          collect wa_lylaprcs1 into it_lylaprcs1.
          clear wa_lylaprcs1.
        endif.
        select single * from ysd_dist_targt where bzirk = wa_l2-bzirk and trgyear eq llyear.
        if sy-subrc eq 0.
          wa_lyltaprcs1-bzirk =  wa_l2-bzirk.
          wa_lyltaprcs1-marsale =  ysd_dist_targt-month12.
          wa_lyltaprcs1-zdsm = wa_l2-zdsm.
          wa_lyltaprcs1-rm = wa_l2-rm.
          wa_lyltaprcs1-zm = wa_l2-zm.
          collect wa_lyltaprcs1 into it_lyltaprcs1.
          clear wa_lyltaprcs1.
        endif.



      endif.
    endif.
  endloop.

*************************************

  loop at it_llaprcs1 into wa_llaprcs1.
    wa_llcums-bzirk = wa_llaprcs1-zdsm.
    wa_llcums-sale = wa_llaprcs1-aprsale + wa_llaprcs1-maysale + wa_llaprcs1-junsale + wa_llaprcs1-julsale + wa_llaprcs1-augsale + wa_llaprcs1-sepsale +
    wa_llaprcs1-octsale + wa_llaprcs1-novsale + wa_llaprcs1-decsale + wa_llaprcs1-jansale + wa_llaprcs1-febsale + wa_llaprcs1-marsale.
    collect wa_llcums into it_llcums.
    clear wa_llcums.
  endloop.
  loop at it_llaprcs1 into wa_llaprcs1.
    wa_lldums-bzirk = wa_llaprcs1-zdsm.
    wa_lldums-aprsale = wa_llaprcs1-aprsale.
    wa_lldums-maysale = wa_llaprcs1-maysale.
    wa_lldums-junsale = wa_llaprcs1-junsale.
    wa_lldums-julsale = wa_llaprcs1-julsale.
    wa_lldums-augsale = wa_llaprcs1-augsale.
    wa_lldums-sepsale = wa_llaprcs1-sepsale.
    wa_lldums-octsale = wa_llaprcs1-octsale.
    wa_lldums-novsale = wa_llaprcs1-novsale.
    wa_lldums-decsale = wa_llaprcs1-decsale.
    wa_lldums-jansale = wa_llaprcs1-jansale.
    wa_lldums-febsale = wa_llaprcs1-febsale.
    wa_lldums-marsale = wa_llaprcs1-marsale.
    collect wa_lldums into it_lldums.
    clear wa_lldums.
  endloop.


  loop at it_ll1aprcs1 into wa_ll1aprcs1.
    wa_ll1dums-bzirk = wa_ll1aprcs1-zdsm.
    wa_ll1dums-aprsale = wa_ll1aprcs1-aprsale.
    wa_ll1dums-maysale = wa_ll1aprcs1-maysale.
    wa_ll1dums-junsale = wa_ll1aprcs1-junsale.
    wa_ll1dums-julsale = wa_ll1aprcs1-julsale.
    wa_ll1dums-augsale = wa_ll1aprcs1-augsale.
    wa_ll1dums-sepsale = wa_ll1aprcs1-sepsale.
    wa_ll1dums-octsale = wa_ll1aprcs1-octsale.
    wa_ll1dums-novsale = wa_ll1aprcs1-novsale.
    wa_ll1dums-decsale = wa_ll1aprcs1-decsale.
    wa_ll1dums-jansale = wa_ll1aprcs1-jansale.
    wa_ll1dums-febsale = wa_ll1aprcs1-febsale.
    wa_ll1dums-marsale = wa_ll1aprcs1-marsale.
    collect wa_ll1dums into it_ll1dums.
    clear wa_ll1dums.
  endloop.

*  loop at it_ll1aprcs1 into wa_ll1aprcs1.
*    select single * from zdsmter where zmonth eq month and zyear eq year and bzirk eq wa_ll1aprcs1-zdsm.
*    if sy-subrc eq 0.
*      wa_smll1dums-bzirk = zdsmter-zdsm.
*    endif.
*    wa_smll1dums-aprsale = wa_ll1aprcs1-aprsale.
*    wa_smll1dums-maysale = wa_ll1aprcs1-maysale.
*    wa_smll1dums-junsale = wa_ll1aprcs1-junsale.
*    wa_smll1dums-julsale = wa_ll1aprcs1-julsale.
*    wa_smll1dums-augsale = wa_ll1aprcs1-augsale.
*    wa_smll1dums-sepsale = wa_ll1aprcs1-sepsale.
*    wa_smll1dums-octsale = wa_ll1aprcs1-octsale.
*    wa_smll1dums-novsale = wa_ll1aprcs1-novsale.
*    wa_smll1dums-decsale = wa_ll1aprcs1-decsale.
*    wa_smll1dums-jansale = wa_ll1aprcs1-jansale.
*    wa_smll1dums-febsale = wa_ll1aprcs1-febsale.
*    wa_smll1dums-marsale = wa_ll1aprcs1-marsale.
*    collect wa_smll1dums into it_smll1dums.
*    clear wa_smll1dums.
*  endloop.

  loop at it_ll1aprcs1 into wa_ll1aprcs1.
    select single * from zdsmter where zmonth eq month and zyear eq year and bzirk eq wa_ll1aprcs1-zdsm.
    if sy-subrc eq 0.
      wa_smll1dums-bzirk = zdsmter-zdsm.
    endif.
    wa_smll1dums-aprsale = wa_ll1aprcs1-aprsale.
    wa_smll1dums-maysale = wa_ll1aprcs1-maysale.
    wa_smll1dums-junsale = wa_ll1aprcs1-junsale.
    wa_smll1dums-julsale = wa_ll1aprcs1-julsale.
    wa_smll1dums-augsale = wa_ll1aprcs1-augsale.
    wa_smll1dums-sepsale = wa_ll1aprcs1-sepsale.
    wa_smll1dums-octsale = wa_ll1aprcs1-octsale.
    wa_smll1dums-novsale = wa_ll1aprcs1-novsale.
    wa_smll1dums-decsale = wa_ll1aprcs1-decsale.
    wa_smll1dums-jansale = wa_ll1aprcs1-jansale.
    wa_smll1dums-febsale = wa_ll1aprcs1-febsale.
    wa_smll1dums-marsale = wa_ll1aprcs1-marsale.
    collect wa_smll1dums into it_smll1dums.
    clear wa_smll1dums.
  endloop.

  loop at it_ll1aprcs1 into wa_ll1aprcs1.
    wa_rll1dums-bzirk = wa_ll1aprcs1-rm.
    wa_rll1dums-aprsale = wa_ll1aprcs1-aprsale.
    wa_rll1dums-maysale = wa_ll1aprcs1-maysale.
    wa_rll1dums-junsale = wa_ll1aprcs1-junsale.
    wa_rll1dums-julsale = wa_ll1aprcs1-julsale.
    wa_rll1dums-augsale = wa_ll1aprcs1-augsale.
    wa_rll1dums-sepsale = wa_ll1aprcs1-sepsale.
    wa_rll1dums-octsale = wa_ll1aprcs1-octsale.
    wa_rll1dums-novsale = wa_ll1aprcs1-novsale.
    wa_rll1dums-decsale = wa_ll1aprcs1-decsale.
    wa_rll1dums-jansale = wa_ll1aprcs1-jansale.
    wa_rll1dums-febsale = wa_ll1aprcs1-febsale.
    wa_rll1dums-marsale = wa_ll1aprcs1-marsale.

    collect wa_rll1dums into it_rll1dums.
    clear wa_rll1dums.
  endloop.

  loop at it_ll1aprcs1 into wa_ll1aprcs1.
    wa_zll1dums-bzirk = wa_ll1aprcs1-zm.
    wa_zll1dums-aprsale = wa_ll1aprcs1-aprsale.
    wa_zll1dums-maysale = wa_ll1aprcs1-maysale.
    wa_zll1dums-junsale = wa_ll1aprcs1-junsale.
    wa_zll1dums-julsale = wa_ll1aprcs1-julsale.
    wa_zll1dums-augsale = wa_ll1aprcs1-augsale.
    wa_zll1dums-sepsale = wa_ll1aprcs1-sepsale.
    wa_zll1dums-octsale = wa_ll1aprcs1-octsale.
    wa_zll1dums-novsale = wa_ll1aprcs1-novsale.
    wa_zll1dums-decsale = wa_ll1aprcs1-decsale.
    wa_zll1dums-jansale = wa_ll1aprcs1-jansale.
    wa_zll1dums-febsale = wa_ll1aprcs1-febsale.
    wa_zll1dums-marsale = wa_ll1aprcs1-marsale.

    collect wa_zll1dums into it_zll1dums.
    clear wa_zll1dums.
  endloop.

  loop at it_lltaprcs1 into wa_lltaprcs1.
    wa_lltcums-bzirk = wa_lltaprcs1-zdsm.
    wa_lltcums-sale = wa_lltaprcs1-aprsale + wa_lltaprcs1-maysale + wa_lltaprcs1-junsale + wa_lltaprcs1-julsale + wa_lltaprcs1-augsale + wa_lltaprcs1-sepsale +
    wa_lltaprcs1-octsale + wa_lltaprcs1-novsale + wa_lltaprcs1-decsale + wa_lltaprcs1-jansale + wa_lltaprcs1-febsale + wa_lltaprcs1-marsale.
    collect wa_lltcums into it_lltcums.
    clear wa_lltcums.
  endloop.

  loop at it_lltaprcs1 into wa_lltaprcs1.
    wa_lltdums-bzirk = wa_lltaprcs1-zdsm.
    wa_lltdums-aprsale = wa_lltaprcs1-aprsale.
    wa_lltdums-maysale = wa_lltaprcs1-maysale.
    wa_lltdums-junsale = wa_lltaprcs1-junsale.
    wa_lltdums-julsale = wa_lltaprcs1-julsale.
    wa_lltdums-augsale = wa_lltaprcs1-augsale.
    wa_lltdums-sepsale = wa_lltaprcs1-sepsale.
    wa_lltdums-octsale = wa_lltaprcs1-octsale.
    wa_lltdums-novsale = wa_lltaprcs1-novsale.
    wa_lltdums-decsale = wa_lltaprcs1-decsale.
    wa_lltdums-jansale = wa_lltaprcs1-jansale.
    wa_lltdums-febsale = wa_lltaprcs1-febsale.
    wa_lltdums-marsale = wa_lltaprcs1-marsale.
    collect wa_lltdums into it_lltdums.
    clear wa_lltdums.
  endloop.

  loop at it_ll1taprcs1 into wa_ll1taprcs1.
    wa_ll1tdums-bzirk = wa_ll1taprcs1-zdsm.
    wa_ll1tdums-aprsale = wa_ll1taprcs1-aprsale.
    wa_ll1tdums-maysale = wa_ll1taprcs1-maysale.
    wa_ll1tdums-junsale = wa_ll1taprcs1-junsale.
    wa_ll1tdums-julsale = wa_ll1taprcs1-julsale.
    wa_ll1tdums-augsale = wa_ll1taprcs1-augsale.
    wa_ll1tdums-sepsale = wa_ll1taprcs1-sepsale.
    wa_ll1tdums-octsale = wa_ll1taprcs1-octsale.
    wa_ll1tdums-novsale = wa_ll1taprcs1-novsale.
    wa_ll1tdums-decsale = wa_ll1taprcs1-decsale.
    wa_ll1tdums-jansale = wa_ll1taprcs1-jansale.
    wa_ll1tdums-febsale = wa_ll1taprcs1-febsale.
    wa_ll1tdums-marsale = wa_ll1taprcs1-marsale.
    collect wa_ll1tdums into it_ll1tdums.
    clear wa_ll1tdums.
  endloop.

  loop at it_ll1taprcs1 into wa_ll1taprcs1.
    select single * from zdsmter where zmonth eq month and zyear eq year and bzirk eq wa_ll1taprcs1-zdsm.
    if sy-subrc eq 0.
      wa_smll1tdums-bzirk = zdsmter-zdsm.
    endif.
    wa_smll1tdums-aprsale = wa_ll1taprcs1-aprsale.
    wa_smll1tdums-maysale = wa_ll1taprcs1-maysale.
    wa_smll1tdums-junsale = wa_ll1taprcs1-junsale.
    wa_smll1tdums-julsale = wa_ll1taprcs1-julsale.
    wa_smll1tdums-augsale = wa_ll1taprcs1-augsale.
    wa_smll1tdums-sepsale = wa_ll1taprcs1-sepsale.
    wa_smll1tdums-octsale = wa_ll1taprcs1-octsale.
    wa_smll1tdums-novsale = wa_ll1taprcs1-novsale.
    wa_smll1tdums-decsale = wa_ll1taprcs1-decsale.
    wa_smll1tdums-jansale = wa_ll1taprcs1-jansale.
    wa_smll1tdums-febsale = wa_ll1taprcs1-febsale.
    wa_smll1tdums-marsale = wa_ll1taprcs1-marsale.
    collect wa_smll1tdums into it_smll1tdums.
    clear wa_smll1tdums.
  endloop.

  loop at it_ll1taprcs1 into wa_ll1taprcs1.
    wa_rll1tdums-bzirk = wa_ll1taprcs1-rm.
    wa_rll1tdums-aprsale = wa_ll1taprcs1-aprsale.
    wa_rll1tdums-maysale = wa_ll1taprcs1-maysale.
    wa_rll1tdums-junsale = wa_ll1taprcs1-junsale.
    wa_rll1tdums-julsale = wa_ll1taprcs1-julsale.
    wa_rll1tdums-augsale = wa_ll1taprcs1-augsale.
    wa_rll1tdums-sepsale = wa_ll1taprcs1-sepsale.
    wa_rll1tdums-octsale = wa_ll1taprcs1-octsale.
    wa_rll1tdums-novsale = wa_ll1taprcs1-novsale.
    wa_rll1tdums-decsale = wa_ll1taprcs1-decsale.
    wa_rll1tdums-jansale = wa_ll1taprcs1-jansale.
    wa_rll1tdums-febsale = wa_ll1taprcs1-febsale.
    wa_rll1tdums-marsale = wa_ll1taprcs1-marsale.
    collect wa_rll1tdums into it_rll1tdums.
    clear wa_rll1tdums.
  endloop.

  loop at it_ll1taprcs1 into wa_ll1taprcs1.
    wa_zll1tdums-bzirk = wa_ll1taprcs1-zm.
    wa_zll1tdums-aprsale = wa_ll1taprcs1-aprsale.
    wa_zll1tdums-maysale = wa_ll1taprcs1-maysale.
    wa_zll1tdums-junsale = wa_ll1taprcs1-junsale.
    wa_zll1tdums-julsale = wa_ll1taprcs1-julsale.
    wa_zll1tdums-augsale = wa_ll1taprcs1-augsale.
    wa_zll1tdums-sepsale = wa_ll1taprcs1-sepsale.
    wa_zll1tdums-octsale = wa_ll1taprcs1-octsale.
    wa_zll1tdums-novsale = wa_ll1taprcs1-novsale.
    wa_zll1tdums-decsale = wa_ll1taprcs1-decsale.
    wa_zll1tdums-jansale = wa_ll1taprcs1-jansale.
    wa_zll1tdums-febsale = wa_ll1taprcs1-febsale.
    wa_zll1tdums-marsale = wa_ll1taprcs1-marsale.
    collect wa_zll1tdums into it_zll1tdums.
    clear wa_zll1tdums.
  endloop.

****************************************************

  loop at it_lylaprcs1 into wa_lylaprcs1.
    wa_yllcums-bzirk = wa_lylaprcs1-zdsm.
    wa_yllcums-sale = wa_lylaprcs1-aprsale + wa_lylaprcs1-maysale + wa_lylaprcs1-junsale + wa_lylaprcs1-julsale + wa_lylaprcs1-augsale + wa_lylaprcs1-sepsale +
    wa_lylaprcs1-octsale + wa_lylaprcs1-novsale + wa_lylaprcs1-decsale + wa_lylaprcs1-jansale + wa_lylaprcs1-febsale + wa_lylaprcs1-marsale.
    collect wa_yllcums into it_yllcums.
    clear wa_yllcums.
  endloop.
  loop at it_lylaprcs1 into wa_lylaprcs1.
    wa_ylldums-bzirk = wa_lylaprcs1-zdsm.
    wa_ylldums-aprsale = wa_lylaprcs1-aprsale.
    wa_ylldums-maysale = wa_lylaprcs1-maysale.
    wa_ylldums-junsale = wa_lylaprcs1-junsale.
    wa_ylldums-julsale = wa_lylaprcs1-julsale.
    wa_ylldums-augsale = wa_lylaprcs1-augsale.
    wa_ylldums-sepsale = wa_lylaprcs1-sepsale.
    wa_ylldums-octsale = wa_lylaprcs1-octsale.
    wa_ylldums-novsale = wa_lylaprcs1-novsale.
    wa_ylldums-decsale = wa_lylaprcs1-decsale.
    wa_ylldums-jansale = wa_lylaprcs1-jansale.
    wa_ylldums-febsale = wa_lylaprcs1-febsale.
    wa_ylldums-marsale = wa_lylaprcs1-marsale.
    collect wa_ylldums into it_ylldums.
    clear wa_ylldums.
  endloop.


  loop at it_lyl1aprcs1 into wa_lyl1aprcs1.
    wa_yll1dums-bzirk = wa_lyl1aprcs1-zdsm.
    wa_yll1dums-aprsale = wa_lyl1aprcs1-aprsale.
    wa_yll1dums-maysale = wa_lyl1aprcs1-maysale.
    wa_yll1dums-junsale = wa_lyl1aprcs1-junsale.
    wa_yll1dums-julsale = wa_lyl1aprcs1-julsale.
    wa_yll1dums-augsale = wa_lyl1aprcs1-augsale.
    wa_yll1dums-sepsale = wa_lyl1aprcs1-sepsale.
    wa_yll1dums-octsale = wa_lyl1aprcs1-octsale.
    wa_yll1dums-novsale = wa_lyl1aprcs1-novsale.
    wa_yll1dums-decsale = wa_lyl1aprcs1-decsale.
    wa_yll1dums-jansale = wa_lyl1aprcs1-jansale.
    wa_yll1dums-febsale = wa_lyl1aprcs1-febsale.
    wa_yll1dums-marsale = wa_lyl1aprcs1-marsale.
    collect wa_yll1dums into it_yll1dums.
    clear wa_yll1dums.
  endloop.

  loop at it_lyl1aprcs1 into wa_lyl1aprcs1.
    select single * from zdsmter where zmonth eq month and zyear eq year and bzirk eq wa_lyl1aprcs1-zdsm.
    if sy-subrc eq 0.
      wa_smyll1dums-bzirk = zdsmter-zdsm.
    endif.
    wa_smyll1dums-aprsale = wa_lyl1aprcs1-aprsale.
    wa_smyll1dums-maysale = wa_lyl1aprcs1-maysale.
    wa_smyll1dums-junsale = wa_lyl1aprcs1-junsale.
    wa_smyll1dums-julsale = wa_lyl1aprcs1-julsale.
    wa_smyll1dums-augsale = wa_lyl1aprcs1-augsale.
    wa_smyll1dums-sepsale = wa_lyl1aprcs1-sepsale.
    wa_smyll1dums-octsale = wa_lyl1aprcs1-octsale.
    wa_smyll1dums-novsale = wa_lyl1aprcs1-novsale.
    wa_smyll1dums-decsale = wa_lyl1aprcs1-decsale.
    wa_smyll1dums-jansale = wa_lyl1aprcs1-jansale.
    wa_smyll1dums-febsale = wa_lyl1aprcs1-febsale.
    wa_smyll1dums-marsale = wa_lyl1aprcs1-marsale.
    collect wa_smyll1dums into it_smyll1dums.
    clear wa_smyll1dums.
  endloop.

  loop at it_lyl1aprcs1 into wa_lyl1aprcs1.
    wa_ryll1dums-bzirk = wa_lyl1aprcs1-rm.
    wa_ryll1dums-aprsale = wa_lyl1aprcs1-aprsale.
    wa_ryll1dums-maysale = wa_lyl1aprcs1-maysale.
    wa_ryll1dums-junsale = wa_lyl1aprcs1-junsale.
    wa_ryll1dums-julsale = wa_lyl1aprcs1-julsale.
    wa_ryll1dums-augsale = wa_lyl1aprcs1-augsale.
    wa_ryll1dums-sepsale = wa_lyl1aprcs1-sepsale.
    wa_ryll1dums-octsale = wa_lyl1aprcs1-octsale.
    wa_ryll1dums-novsale = wa_lyl1aprcs1-novsale.
    wa_ryll1dums-decsale = wa_lyl1aprcs1-decsale.
    wa_ryll1dums-jansale = wa_lyl1aprcs1-jansale.
    wa_ryll1dums-febsale = wa_lyl1aprcs1-febsale.
    wa_ryll1dums-marsale = wa_lyl1aprcs1-marsale.
    collect wa_ryll1dums into it_ryll1dums.
    clear wa_ryll1dums.
  endloop.

  loop at it_lyl1aprcs1 into wa_lyl1aprcs1.
    wa_zyll1dums-bzirk = wa_lyl1aprcs1-zm.
    wa_zyll1dums-aprsale = wa_lyl1aprcs1-aprsale.
    wa_zyll1dums-maysale = wa_lyl1aprcs1-maysale.
    wa_zyll1dums-junsale = wa_lyl1aprcs1-junsale.
    wa_zyll1dums-julsale = wa_lyl1aprcs1-julsale.
    wa_zyll1dums-augsale = wa_lyl1aprcs1-augsale.
    wa_zyll1dums-sepsale = wa_lyl1aprcs1-sepsale.
    wa_zyll1dums-octsale = wa_lyl1aprcs1-octsale.
    wa_zyll1dums-novsale = wa_lyl1aprcs1-novsale.
    wa_zyll1dums-decsale = wa_lyl1aprcs1-decsale.
    wa_zyll1dums-jansale = wa_lyl1aprcs1-jansale.
    wa_zyll1dums-febsale = wa_lyl1aprcs1-febsale.
    wa_zyll1dums-marsale = wa_lyl1aprcs1-marsale.
    collect wa_zyll1dums into it_zyll1dums.
    clear wa_zyll1dums.
  endloop.

  loop at it_lyltaprcs1 into wa_lyltaprcs1.
    wa_ylltcums-bzirk = wa_lyltaprcs1-zdsm.
    wa_ylltcums-sale = wa_lyltaprcs1-aprsale + wa_lyltaprcs1-maysale + wa_lyltaprcs1-junsale + wa_lyltaprcs1-julsale + wa_lyltaprcs1-augsale + wa_lyltaprcs1-sepsale +
    wa_lyltaprcs1-octsale + wa_lyltaprcs1-novsale + wa_lyltaprcs1-decsale + wa_lyltaprcs1-jansale + wa_lyltaprcs1-febsale + wa_lyltaprcs1-marsale.
    collect wa_ylltcums into it_ylltcums.
    clear wa_ylltcums.
  endloop.

  loop at it_lyltaprcs1 into wa_lyltaprcs1.
    wa_ylltdums-bzirk = wa_lyltaprcs1-zdsm.
    wa_ylltdums-aprsale = wa_lyltaprcs1-aprsale.
    wa_ylltdums-maysale = wa_lyltaprcs1-maysale.
    wa_ylltdums-junsale = wa_lyltaprcs1-junsale.
    wa_ylltdums-julsale = wa_lyltaprcs1-julsale.
    wa_ylltdums-augsale = wa_lyltaprcs1-augsale.
    wa_ylltdums-sepsale = wa_lyltaprcs1-sepsale.
    wa_ylltdums-octsale = wa_lyltaprcs1-octsale.
    wa_ylltdums-novsale = wa_lyltaprcs1-novsale.
    wa_ylltdums-decsale = wa_lyltaprcs1-decsale.
    wa_ylltdums-jansale = wa_lyltaprcs1-jansale.
    wa_ylltdums-febsale = wa_lyltaprcs1-febsale.
    wa_ylltdums-marsale = wa_lyltaprcs1-marsale.
    collect wa_ylltdums into it_ylltdums.
    clear wa_ylltdums.
  endloop.

  loop at it_lyl1taprcs1 into wa_lyl1taprcs1.
    wa_yll1tdums-bzirk = wa_lyl1taprcs1-zdsm.
    wa_yll1tdums-aprsale = wa_lyl1taprcs1-aprsale.
    wa_yll1tdums-maysale = wa_lyl1taprcs1-maysale.
    wa_yll1tdums-junsale = wa_lyl1taprcs1-junsale.
    wa_yll1tdums-julsale = wa_lyl1taprcs1-julsale.
    wa_yll1tdums-augsale = wa_lyl1taprcs1-augsale.
    wa_yll1tdums-sepsale = wa_lyl1taprcs1-sepsale.
    wa_yll1tdums-octsale = wa_lyl1taprcs1-octsale.
    wa_yll1tdums-novsale = wa_lyl1taprcs1-novsale.
    wa_yll1tdums-decsale = wa_lyl1taprcs1-decsale.
    wa_yll1tdums-jansale = wa_lyl1taprcs1-jansale.
    wa_yll1tdums-febsale = wa_lyl1taprcs1-febsale.
    wa_yll1tdums-marsale = wa_lyl1taprcs1-marsale.
    collect wa_yll1tdums into it_yll1tdums.
    clear wa_yll1tdums.
  endloop.


*****************************




endform.                    "CCUMMs_ZRCUMPSO



*&---------------------------------------------------------------------*
*&      Form  ccumms_zrcumpso_dzm
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form ccumms_zrcumpso_dzm.

  loop  at it_tab6 into wa_tab6.
    clear  : t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,cumm_sale.
*    WRITE : / f1date,date2.

    clear : join_date.
    select single * from pa0302 where pernr eq wa_tab6-dzmpernr and massn eq '01'.
    if sy-subrc eq 0.
      join_date = pa0302-begda.
    endif.

    if f1date le date2.
      if join_date le f1date.
        select single * from zrcumpso where zmonth eq f1date+4(2) and zyear eq f1date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t1 = zrcumpso-netval.
        endif.
      endif.
    endif.
    if f2date le date2.
      if join_date le f2date.
        select single * from zrcumpso where zmonth eq f2date+4(2) and zyear eq f2date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t2 = zrcumpso-netval.
        endif.
      endif.
    endif.
    if f3date le date2.
      if join_date le f3date.
        select single * from zrcumpso where zmonth eq f3date+4(2) and zyear eq f3date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t3 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f4date le date2.
      if join_date le f4date.
        select single * from zrcumpso where zmonth eq f4date+4(2) and zyear eq f4date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t4 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f5date le date2.
      if join_date le f5date.
        select single * from zrcumpso where zmonth eq f5date+4(2) and zyear eq f5date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t5 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f6date le date2.
      if join_date le f6date.
        select single * from zrcumpso where zmonth eq f6date+4(2) and zyear eq f6date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t6 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f7date le date2.
      if join_date le f7date.
        select single * from zrcumpso where zmonth eq f7date+4(2) and zyear eq f7date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t7 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f8date le date2.
      if join_date le f8date.
        select single * from zrcumpso where zmonth eq f8date+4(2) and zyear eq f8date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t8 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f9date le date2.
      if join_date le f9date.
        select single * from zrcumpso where zmonth eq f9date+4(2) and zyear eq f9date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t9 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f10date le date2.
      if join_date le f10date.
        select single * from zrcumpso where zmonth eq f10date+4(2) and zyear eq f10date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t10 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f11date le date2.
      if join_date le f11date.
        select single * from zrcumpso where zmonth eq f11date+4(2) and zyear eq f11date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t11 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f12date le date2.
      if join_date le f12date.
        select single * from zrcumpso where zmonth eq f12date+4(2) and zyear eq f12date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t12 = zrcumpso-netval.
        endif.
      endif.
    endif.
    cumm_sale = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12.
    wa_cummsr2_dzm-bzirk = wa_tab6-bzirk.
    wa_cummsr2_dzm-ccumm_sale = cumm_sale.
    collect wa_cummsr2_dzm into it_cummsr2_dzm.
    clear wa_cummsr2_dzm.
  endloop.
*  LOOP at it_cumms2 INTO wa_cumms2.
*    WRITE : / 'current cummulative sale',wa_cumms2-bzirk,wa_cumms2-ccumm_sale.
*  ENDLOOP.

endform.                    "CCUMMs_ZRCUMPSO
*&---------------------------------------------------------------------*
*&      Form  ccumms_zrcumpso_rm
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form ccumms_zrcumpso_rm.

  loop  at it_tab6 into wa_tab6.
    clear  : t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,cumm_sale.
*    WRITE : / f1date,date2.
    clear : join_date.
    select single * from pa0302 where pernr eq wa_tab6-rmpernr and massn eq '01'.
    if sy-subrc eq 0.
      join_date = pa0302-begda.
    endif.

    if f1date le date2.
      if join_date le f1date.
        select single * from zrcumpso where zmonth eq f1date+4(2) and zyear eq f1date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t1 = zrcumpso-netval.
        endif.
      endif.
    endif.
    if f2date le date2.
      if join_date le f2date.
        select single * from zrcumpso where zmonth eq f2date+4(2) and zyear eq f2date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t2 = zrcumpso-netval.
        endif.
      endif.
    endif.
    if f3date le date2.
      if join_date le f3date.
        select single * from zrcumpso where zmonth eq f3date+4(2) and zyear eq f3date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t3 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f4date le date2.
      if join_date le f4date.
        select single * from zrcumpso where zmonth eq f4date+4(2) and zyear eq f4date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t4 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f5date le date2.
      if join_date le f5date.
        select single * from zrcumpso where zmonth eq f5date+4(2) and zyear eq f5date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t5 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f6date le date2.
      if join_date le f6date.
        select single * from zrcumpso where zmonth eq f6date+4(2) and zyear eq f6date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t6 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f7date le date2.
      if join_date le f7date.
        select single * from zrcumpso where zmonth eq f7date+4(2) and zyear eq f7date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t7 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f8date le date2.
      if join_date le f8date.
        select single * from zrcumpso where zmonth eq f8date+4(2) and zyear eq f8date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t8 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f9date le date2.
      if join_date le f9date.
        select single * from zrcumpso where zmonth eq f9date+4(2) and zyear eq f9date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t9 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f10date le date2.
      if join_date le f10date.
        select single * from zrcumpso where zmonth eq f10date+4(2) and zyear eq f10date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t10 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f11date le date2.
      if join_date le f11date.
        select single * from zrcumpso where zmonth eq f11date+4(2) and zyear eq f11date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t11 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f12date le date2.
      if join_date le f12date.
        select single * from zrcumpso where zmonth eq f12date+4(2) and zyear eq f12date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t12 = zrcumpso-netval.
        endif.
      endif.
    endif.
    cumm_sale = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12.
    wa_cummsr2_rm-bzirk = wa_tab6-bzirk.
    wa_cummsr2_rm-ccumm_sale = cumm_sale.
    collect wa_cummsr2_rm into it_cummsr2_rm.
    clear wa_cummsr2_rm.
  endloop.
*  LOOP at it_cumms2 INTO wa_cumms2.
*    WRITE : / 'current cummulative sale',wa_cumms2-bzirk,wa_cumms2-ccumm_sale.
*  ENDLOOP.

endform.                    "CCUMMs_ZRCUMPSO

*&---------------------------------------------------------------------*
*&      Form  ccumms_zrcumpso_pso
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form ccumms_zrcumpso_pso.

  loop  at it_tab6 into wa_tab6.
    clear  : t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,cumm_sale.
    clear  : zcumt1,zcumt2,zcumt3,zcumt4,zcumt5,zcumt6,zcumt7,zcumt8,zcumt9,zcumt10,zcumt11,zcumt12,zcumcumm_sale.
*    WRITE : / f1date,date2.
    if f1date le date2.
      if wa_tab6-join_date le f1date.
        select single * from zrcumpso where zmonth eq f1date+4(2) and zyear eq f1date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t1 = zrcumpso-netval.
        endif.
        select single * from zcumpso where zmonth eq f1date+4(2) and zyear eq f1date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          zcumt1 = zcumpso-netval.
        endif.
      endif.
    endif.
    if f2date le date2.
      if wa_tab6-join_date le f2date.
        select single * from zrcumpso where zmonth eq f2date+4(2) and zyear eq f2date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t2 = zrcumpso-netval.
        endif.
        select single * from zcumpso where zmonth eq f2date+4(2) and zyear eq f2date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          zcumt2 = zcumpso-netval.
        endif.
      endif.
    endif.
    if f3date le date2.
      if wa_tab6-join_date le f3date.
        select single * from zrcumpso where zmonth eq f3date+4(2) and zyear eq f3date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t3 = zrcumpso-netval.
        endif.
        select single * from zcumpso where zmonth eq f3date+4(2) and zyear eq f3date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          zcumt3 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f4date le date2.
      if wa_tab6-join_date le f4date.
        select single * from zrcumpso where zmonth eq f4date+4(2) and zyear eq f4date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t4 = zrcumpso-netval.
        endif.
        select single * from zcumpso where zmonth eq f4date+4(2) and zyear eq f4date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          zcumt4 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f5date le date2.
      if wa_tab6-join_date le f5date.
        select single * from zrcumpso where zmonth eq f5date+4(2) and zyear eq f5date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t5 = zrcumpso-netval.
        endif.
        select single * from zcumpso where zmonth eq f5date+4(2) and zyear eq f5date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          zcumt5 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f6date le date2.
      if wa_tab6-join_date le f6date.
        select single * from zrcumpso where zmonth eq f6date+4(2) and zyear eq f6date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t6 = zrcumpso-netval.
        endif.
        select single * from zcumpso where zmonth eq f6date+4(2) and zyear eq f6date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          zcumt6 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f7date le date2.
      if wa_tab6-join_date le f7date.
        select single * from zrcumpso where zmonth eq f7date+4(2) and zyear eq f7date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t7 = zrcumpso-netval.
        endif.
        select single * from zcumpso where zmonth eq f7date+4(2) and zyear eq f7date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          zcumt7 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f8date le date2.
      if wa_tab6-join_date le f8date.
        select single * from zrcumpso where zmonth eq f8date+4(2) and zyear eq f8date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t8 = zrcumpso-netval.
        endif.
        select single * from zcumpso where zmonth eq f8date+4(2) and zyear eq f8date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          zcumt8 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f9date le date2.
      if wa_tab6-join_date le f9date.
        select single * from zrcumpso where zmonth eq f9date+4(2) and zyear eq f9date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t9 = zrcumpso-netval.
        endif.
        select single * from zcumpso where zmonth eq f9date+4(2) and zyear eq f9date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          zcumt9 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f10date le date2.
      if wa_tab6-join_date le f10date.
        select single * from zrcumpso where zmonth eq f10date+4(2) and zyear eq f10date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t10 = zrcumpso-netval.
        endif.
        select single * from zcumpso where zmonth eq f10date+4(2) and zyear eq f10date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          zcumt10 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f11date le date2.
      if wa_tab6-join_date le f11date.
        select single * from zrcumpso where zmonth eq f11date+4(2) and zyear eq f11date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t11 = zrcumpso-netval.
        endif.
        select single * from zcumpso where zmonth eq f11date+4(2) and zyear eq f11date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          zcumt11 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f12date le date2.
      if wa_tab6-join_date le f12date.
        select single * from zrcumpso where zmonth eq f12date+4(2) and zyear eq f12date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          t12 = zrcumpso-netval.
        endif.
        select single * from zcumpso where zmonth eq f12date+4(2) and zyear eq f12date+0(4) and bzirk eq wa_tab6-bzirk.
        if sy-subrc eq 0.
          zcumt12 = zcumpso-netval.
        endif.
      endif.
    endif.
    cumm_sale = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12.
    zcumcumm_sale = zcumt1 + zcumt2 + zcumt3 + zcumt4 + zcumt5 + zcumt6 + zcumt7 + zcumt8 + zcumt9 + zcumt10 + zcumt11 + zcumt12.
    wa_cummsr2_pso-bzirk = wa_tab6-bzirk.
    wa_cummsr2_pso-ccumm_sale = cumm_sale.
    wa_cummsr2_pso-zcumccumm_sale = zcumcumm_sale.
    collect wa_cummsr2_pso into it_cummsr2_pso.
    clear wa_cummsr2_pso.
  endloop.
*  LOOP at it_cumms2 INTO wa_cumms2.
*    WRITE : / 'current cummulative sale',wa_cumms2-bzirk,wa_cumms2-ccumm_sale.
*  ENDLOOP.

endform.                    "CCUMMs_ZRCUMPSO


*&---------------------------------------------------------------------*
*&      Form  cmper
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form cmper.


  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '-1'
      olddate = date1
    importing
      newdate = date4.
  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '-2'
      olddate = date1
    importing
      newdate = date5.

***************************

  select * from zdsmter into table it_zdsmter_l1 where zdsm in org and zmonth eq date5+4(2) and zyear eq date5+0(4).
  if sy-subrc eq 0.
    select * from zdsmter into table it_zdsmter_l2 for all entries in it_zdsmter_l1 where zdsm eq it_zdsmter_l1-bzirk and
      zmonth eq date5+4(2) and zyear eq date5+0(4).
  endif.
  loop at it_zdsmter_l2 into wa_zdsmter_l2 where zdsm+0(2) eq 'R-'.
*WRITE : / 'D',DATE5,  WA_ZDSMTER_L2-ZDSM,WA_ZDSMTER_L2-BZIRK.
    wa_l1-zmonth = wa_zdsmter_l2-zmonth.
    wa_l1-zyear = wa_zdsmter_l2-zyear.
    wa_l1-bzirk = wa_zdsmter_l2-bzirk.
    wa_l1-rm = wa_zdsmter_l2-zdsm.
    read table it_zdsmter_l2 into wa_zdsmter_l2 with key bzirk = wa_zdsmter_l2-zdsm zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_l1-zm = wa_zdsmter_l2-zdsm.
    endif.
    read table it_zdsmter_l1 into wa_zdsmter_l1 with key bzirk = wa_zdsmter_l2-zdsm.
    if sy-subrc eq 0.
      wa_l1-zdsm = wa_zdsmter_l1-zdsm.
    endif.
    collect wa_l1 into it_l1.
    clear wa_l1.
  endloop.

  loop at it_l1 into wa_l1.
    clear : t2.
    select single * from yterrallc where bzirk eq wa_l1-bzirk and endda ge date5.
    if sy-subrc eq 0.

      select single * from zcumpso where zmonth eq date5+4(2) and zyear eq date5+0(4) and bzirk eq wa_l1-bzirk.
      if sy-subrc eq 0.
        wa_lcs-c3sale  = zcumpso-netval.
        wa_lcs-bzirk = wa_l1-zdsm.
        collect wa_lcs into it_lcs.
        clear wa_lcs.
      endif.

      select single * from zcumpso where zmonth eq date5+4(2) and zyear eq date5+0(4) and bzirk eq wa_l1-bzirk.
      if sy-subrc eq 0.
        wa_smlcs-c3sale  = zcumpso-netval.
        select single * from zdsmter where zmonth eq month and zyear eq year and bzirk eq wa_l1-zdsm.
        if sy-subrc eq 0.
          wa_smlcs-bzirk = zdsmter-zdsm.
        endif.
        collect wa_smlcs into it_smlcs.
        clear wa_smlcs.
      endif.

      select single * from zcumpso where zmonth eq date5+4(2) and zyear eq date5+0(4) and bzirk eq wa_l1-bzirk.
      if sy-subrc eq 0.
        wa_rlcs-c3sale  = zcumpso-netval.
        wa_rlcs-bzirk = wa_l1-rm.
        collect wa_rlcs into it_rlcs.
        clear wa_rlcs.
      endif.
      select single * from zcumpso where zmonth eq date5+4(2) and zyear eq date5+0(4) and bzirk eq wa_l1-bzirk.
      if sy-subrc eq 0.
        wa_zlcs-c3sale  = zcumpso-netval.
        wa_zlcs-bzirk = wa_l1-zm.
        collect wa_zlcs into it_zlcs.
        clear wa_zlcs.
      endif.

      select single * from zcumpso where zmonth eq date5+4(2) and zyear eq date5+0(4) and bzirk eq wa_l1-bzirk.
      if sy-subrc eq 0.
        wa_plcs-c3sale  = zcumpso-netval.
        wa_plcs-bzirk = wa_l1-bzirk.
        collect wa_plcs into it_plcs.
        clear wa_plcs.
      endif.
*************************************************************

      clear : tyear.
      if date5+4(2) ge '04'.
        tyear = date5+0(4).
      else.
        tyear = date5+0(4) - 1.
      endif.

      select single * from ysd_dist_targt where bzirk = wa_l1-bzirk and trgyear eq tyear.
      if sy-subrc eq 0.
        if date5+4(2) eq '04'.
          t2 = ysd_dist_targt-month01.
        elseif date5+4(2) eq '05'.
          t2 = ysd_dist_targt-month02.
        elseif date5+4(2) eq '06'.
          t2 = ysd_dist_targt-month03.
        elseif date5+4(2) eq '07'.
          t2 = ysd_dist_targt-month04.
        elseif date5+4(2) eq '08'.
          t2 = ysd_dist_targt-month05.
        elseif date5+4(2) eq '09'.
          t2 = ysd_dist_targt-month06.
        elseif date5+4(2) eq '10'.
          t2 = ysd_dist_targt-month07.
        elseif date5+4(2) eq '11'.
          t2 = ysd_dist_targt-month08.
        elseif date5+4(2) eq '12'.
          t2 = ysd_dist_targt-month09.
        elseif date5+4(2) eq '01'.
          t2 = ysd_dist_targt-month10.
        elseif date5+4(2) eq '02'.
          t2 = ysd_dist_targt-month11.
        elseif date5+4(2) eq '03'.
          t2 = ysd_dist_targt-month12.
        endif.

********************************************************************

*      select single * from ysd_dist_targt where bzirk = wa_l1-bzirk and trgyear eq cyear.
*      if sy-subrc eq 0.
*        if date5+4(2) eq '04'.
*          t2 = ysd_dist_targt-month01.
*        elseif date5+4(2) eq '05'.
*          t2 = ysd_dist_targt-month02.
*        elseif date5+4(2) eq '06'.
*          t2 = ysd_dist_targt-month03.
*        elseif date5+4(2) eq '07'.
*          t2 = ysd_dist_targt-month04.
*        elseif date5+4(2) eq '08'.
*          t2 = ysd_dist_targt-month05.
*        elseif date5+4(2) eq '09'.
*          t2 = ysd_dist_targt-month06.
*        elseif date5+4(2) eq '10'.
*          t2 = ysd_dist_targt-month07.
*        elseif date5+4(2) eq '11'.
*          t2 = ysd_dist_targt-month08.
*        elseif date5+4(2) eq '12'.
*          t2 = ysd_dist_targt-month09.
*        elseif date5+4(2) eq '01'.
*          t2 = ysd_dist_targt-month10.
*        elseif date5+4(2) eq '02'.
*          t2 = ysd_dist_targt-month11.
*        elseif date5+4(2) eq '03'.
*          t2 = ysd_dist_targt-month12.
*        endif.
        wa_lcs-t2  = t2.
        wa_lcs-bzirk = wa_l1-zdsm.
        collect wa_lcs into it_lcs.
        clear wa_lcs.

        wa_smlcs-t2  = t2.
        select single * from zdsmter where zmonth eq month and zyear eq year and bzirk eq wa_l1-zdsm.
        if sy-subrc eq 0.
          wa_smlcs-bzirk = zdsmter-zdsm.
        endif.
        collect wa_smlcs into it_smlcs.
        clear wa_smlcs.

        wa_rlcs-t2  = t2.
        wa_rlcs-bzirk = wa_l1-rm.
        collect wa_rlcs into it_rlcs.
        clear wa_rlcs.

        wa_zlcs-t2  = t2.
        wa_zlcs-bzirk = wa_l1-zm.
        collect wa_zlcs into it_zlcs.
        clear wa_zlcs.

        wa_plcs-t2  = t2.
        wa_plcs-bzirk = wa_l1-bzirk.
        collect wa_plcs into it_plcs.
        clear wa_plcs.
      endif.
    endif.
  endloop.

********************************
  clear : it_zdsmter_l1,wa_zdsmter_l1,it_zdsmter_l2,wa_zdsmter_l2, it_l1, wa_l1.

  select * from zdsmter into table it_zdsmter_l1 where zdsm in org and zmonth eq date4+4(2) and zyear eq date4+0(4).
  if sy-subrc eq 0.
    select * from zdsmter into table it_zdsmter_l2 for all entries in it_zdsmter_l1 where zdsm eq it_zdsmter_l1-bzirk and
      zmonth eq date4+4(2) and zyear eq date4+0(4).
  endif.
  loop at it_zdsmter_l2 into wa_zdsmter_l2  where zdsm+0(2) eq 'R-'.
*WRITE : / 'D',date4,  WA_ZDSMTER_L2-ZDSM,WA_ZDSMTER_L2-BZIRK.
    wa_l1-zmonth = wa_zdsmter_l2-zmonth.
    wa_l1-zyear = wa_zdsmter_l2-zyear.
    wa_l1-bzirk = wa_zdsmter_l2-bzirk.
    wa_l1-rm = wa_zdsmter_l2-zdsm.
    read table it_zdsmter_l2 into wa_zdsmter_l2 with key bzirk = wa_zdsmter_l2-zdsm zdsm+0(2) = 'Z-'.
    if sy-subrc eq 0.
      wa_l1-zm = wa_zdsmter_l2-zdsm.
    endif.
    read table it_zdsmter_l1 into wa_zdsmter_l1 with key bzirk = wa_zdsmter_l2-zdsm.
    if sy-subrc eq 0.
      wa_l1-zdsm = wa_zdsmter_l1-zdsm.
    endif.
    collect wa_l1 into it_l1.
    clear wa_l1.
  endloop.

  loop at it_l1 into wa_l1.
    clear : t2.
*  WRITE : / 'a',WA_L1-ZMONTH,WA_L1-ZYEAR,WA_L1-BZIRK,WA_L1-RM,WA_L1-ZDSM.
    select single * from yterrallc where bzirk eq wa_l1-bzirk and endda ge date4.
    if sy-subrc eq 0.

      select single * from zcumpso where zmonth eq date4+4(2) and zyear eq date4+0(4) and bzirk eq wa_l1-bzirk.
      if sy-subrc eq 0.
        wa_l1cs-c3sale  = zcumpso-netval.
        wa_l1cs-bzirk = wa_l1-zdsm.
        collect wa_l1cs into it_l1cs.
        clear wa_l1cs.
      endif.

      select single * from zcumpso where zmonth eq date4+4(2) and zyear eq date4+0(4) and bzirk eq wa_l1-bzirk.
      if sy-subrc eq 0.
        wa_sml1cs-c3sale  = zcumpso-netval.
        select single * from zdsmter where zmonth eq month and zyear eq year and bzirk eq wa_l1-zdsm.
        if sy-subrc eq 0.
          wa_sml1cs-bzirk = zdsmter-zdsm.
        endif.
        collect wa_sml1cs into it_sml1cs.
        clear wa_sml1cs.
      endif.

      select single * from zcumpso where zmonth eq date4+4(2) and zyear eq date4+0(4) and bzirk eq wa_l1-bzirk.
      if sy-subrc eq 0.
        wa_rl1cs-c3sale  = zcumpso-netval.
        wa_rl1cs-bzirk = wa_l1-rm.
        collect wa_rl1cs into it_rl1cs.
        clear wa_rl1cs.
      endif.
      select single * from zcumpso where zmonth eq date4+4(2) and zyear eq date4+0(4) and bzirk eq wa_l1-bzirk.
      if sy-subrc eq 0.
        wa_zl1cs-c3sale  = zcumpso-netval.
        wa_zl1cs-bzirk = wa_l1-zm.
        collect wa_zl1cs into it_zl1cs.
        clear wa_zl1cs.
      endif.
      select single * from zcumpso where zmonth eq date4+4(2) and zyear eq date4+0(4) and bzirk eq wa_l1-bzirk.
      if sy-subrc eq 0.
        wa_pl1cs-c3sale  = zcumpso-netval.
        wa_pl1cs-bzirk = wa_l1-bzirk.
        collect wa_pl1cs into it_pl1cs.
        clear wa_pl1cs.
      endif.

*****************************17.5.2020--************************

      clear : tyear.
      if date4+4(2) ge '04'.
        tyear = date4+0(4).
      else.
        tyear = date4+0(4) - 1.
      endif.

      select single * from ysd_dist_targt where bzirk = wa_l1-bzirk and trgyear eq tyear.
      if sy-subrc eq 0.
        if date4+4(2) eq '04'.
          t2 = ysd_dist_targt-month01.
        elseif date4+4(2) eq '05'.
          t2 = ysd_dist_targt-month02.
        elseif date4+4(2) eq '06'.
          t2 = ysd_dist_targt-month03.
        elseif date4+4(2) eq '07'.
          t2 = ysd_dist_targt-month04.
        elseif date4+4(2) eq '08'.
          t2 = ysd_dist_targt-month05.
        elseif date4+4(2) eq '09'.
          t2 = ysd_dist_targt-month06.
        elseif date4+4(2) eq '10'.
          t2 = ysd_dist_targt-month07.
        elseif date4+4(2) eq '11'.
          t2 = ysd_dist_targt-month08.
        elseif date4+4(2) eq '12'.
          t2 = ysd_dist_targt-month09.
        elseif date4+4(2) eq '01'.
          t2 = ysd_dist_targt-month10.
        elseif date4+4(2) eq '02'.
          t2 = ysd_dist_targt-month11.
        elseif date4+4(2) eq '03'.
          t2 = ysd_dist_targt-month12.
        endif.

************************************************************

*      select single * from ysd_dist_targt where bzirk = wa_l1-bzirk and trgyear eq cyear.
*      if sy-subrc eq 0.
*        if date4+4(2) eq '04'.
*          t2 = ysd_dist_targt-month01.
*        elseif date4+4(2) eq '05'.
*          t2 = ysd_dist_targt-month02.
*        elseif date4+4(2) eq '06'.
*          t2 = ysd_dist_targt-month03.
*        elseif date4+4(2) eq '07'.
*          t2 = ysd_dist_targt-month04.
*        elseif date4+4(2) eq '08'.
*          t2 = ysd_dist_targt-month05.
*        elseif date4+4(2) eq '09'.
*          t2 = ysd_dist_targt-month06.
*        elseif date4+4(2) eq '10'.
*          t2 = ysd_dist_targt-month07.
*        elseif date4+4(2) eq '11'.
*          t2 = ysd_dist_targt-month08.
*        elseif date4+4(2) eq '12'.
*          t2 = ysd_dist_targt-month09.
*        elseif date4+4(2) eq '01'.
*          t2 = ysd_dist_targt-month10.
*        elseif date4+4(2) eq '02'.
*          t2 = ysd_dist_targt-month11.
*        elseif date4+4(2) eq '03'.
*          t2 = ysd_dist_targt-month12.
*        endif.
        wa_l1cs-bzirk = wa_l1-zdsm.
        wa_l1cs-t2  = t2.
        collect wa_l1cs into it_l1cs.
        clear wa_l1cs.
        select single * from zdsmter where zmonth eq month and zyear eq year and bzirk eq wa_l1-zdsm.
        if sy-subrc eq 0.
          wa_sml1cs-bzirk = zdsmter-zdsm.
        endif.
        wa_sml1cs-t2  = t2.
        collect wa_sml1cs into it_sml1cs.
        clear wa_sml1cs.

        wa_rl1cs-bzirk = wa_l1-rm.
        wa_rl1cs-t2  = t2.
        collect wa_rl1cs into it_rl1cs.
        clear wa_rl1cs.

        wa_zl1cs-bzirk = wa_l1-zm.
        wa_zl1cs-t2  = t2.
        collect wa_zl1cs into it_zl1cs.
        clear wa_zl1cs.

        wa_pl1cs-bzirk = wa_l1-bzirk.
        wa_pl1cs-t2  = t2.
        collect wa_pl1cs into it_pl1cs.
        clear wa_pl1cs.
      endif.
    endif.
  endloop.

***********************************


*  WRITE : / 'date11,date2',date1,date2,date4,date5,M1.
  loop at it_tab6 into wa_tab6.
    clear : c1sale,c2sale,c3sale,t1,t2,t3.
    select single * from yterrallc where bzirk eq wa_tab6-bzirk and endda ge date2.
    if sy-subrc eq 0.

      select single * from zcumpso where zmonth eq date1+4(2) and zyear eq date1+0(4) and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        c1sale = zcumpso-netval.
        wa_cs-c1sale  = c1sale.
      endif.
      select single * from zcumpso where zmonth eq date4+4(2) and zyear eq date4+0(4) and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        c2sale = zcumpso-netval.
        wa_cs-c2sale  = c2sale.
      endif.
      select single * from zcumpso where zmonth eq date5+4(2) and zyear eq date5+0(4) and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        c3sale = zcumpso-netval.
        wa_cs-c3sale  = c3sale.
      endif.
      wa_cs-bzirk = wa_tab6-bzirk.
      collect wa_cs into it_cs.
      clear wa_cs.
*    WRITE : / '*',C1SALE,C2SALE,C3SALE.
******************************************* 15.5.2020 *******************************
      clear : tyear.
      if date1+4(2) ge '04'.
        tyear = date1+0(4).
      else.
        tyear = date1+0(4) - 1.
      endif.

      select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq tyear.
      if sy-subrc eq 0.
        if date1+4(2) eq '04'.
          t1 = ysd_dist_targt-month01.
        elseif date1+4(2) eq '05'.
          t1 = ysd_dist_targt-month02.
        elseif date1+4(2) eq '06'.
          t1 = ysd_dist_targt-month03.
        elseif date1+4(2) eq '07'.
          t1 = ysd_dist_targt-month04.
        elseif date1+4(2) eq '08'.
          t1 = ysd_dist_targt-month05.
        elseif date1+4(2) eq '09'.
          t1 = ysd_dist_targt-month06.
        elseif date1+4(2) eq '10'.
          t1 = ysd_dist_targt-month07.
        elseif date1+4(2) eq '11'.
          t1 = ysd_dist_targt-month08.
        elseif date1+4(2) eq '12'.
          t1 = ysd_dist_targt-month09.
        elseif date1+4(2) eq '01'.
          t1 = ysd_dist_targt-month10.
        elseif date1+4(2) eq '02'.
          t1 = ysd_dist_targt-month11.
        elseif date1+4(2) eq '03'.
          t1 = ysd_dist_targt-month12.
        endif.
      endif.

      clear : tyear.
      if date4+4(2) ge '04'.
        tyear = date4+0(4).
      else.
        tyear = date4+0(4) - 1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq tyear.
      if sy-subrc eq 0.
        if date4+4(2) eq '04'.
          t2 = ysd_dist_targt-month01.
        elseif date4+4(2) eq '05'.
          t2 = ysd_dist_targt-month02.
        elseif date4+4(2) eq '06'.
          t2 = ysd_dist_targt-month03.
        elseif date4+4(2) eq '07'.
          t2 = ysd_dist_targt-month04.
        elseif date4+4(2) eq '08'.
          t2 = ysd_dist_targt-month05.
        elseif date4+4(2) eq '09'.
          t2 = ysd_dist_targt-month06.
        elseif date4+4(2) eq '10'.
          t2 = ysd_dist_targt-month07.
        elseif date4+4(2) eq '11'.
          t2 = ysd_dist_targt-month08.
        elseif date4+4(2) eq '12'.
          t2 = ysd_dist_targt-month09.
        elseif date4+4(2) eq '01'.
          t2 = ysd_dist_targt-month10.
        elseif date4+4(2) eq '02'.
          t2 = ysd_dist_targt-month11.
        elseif date4+4(2) eq '03'.
          t2 = ysd_dist_targt-month12.
        endif.
      endif.

      clear : tyear.
      if date5+4(2) ge '04'.
        tyear = date5+0(4).
      else.
        tyear = date5+0(4) - 1.
      endif.
      select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq tyear.
      if sy-subrc eq 0.

        if date5+4(2) eq '04'.
          t3 = ysd_dist_targt-month01.
        elseif date5+4(2) eq '05'.
          t3 = ysd_dist_targt-month02.
        elseif date5+4(2) eq '06'.
          t3 = ysd_dist_targt-month03.
        elseif date5+4(2) eq '07'.
          t3 = ysd_dist_targt-month04.
        elseif date5+4(2) eq '08'.
          t3 = ysd_dist_targt-month05.
        elseif date5+4(2) eq '09'.
          t3 = ysd_dist_targt-month06.
        elseif date5+4(2) eq '10'.
          t3 = ysd_dist_targt-month07.
        elseif date5+4(2) eq '11'.
          t3 = ysd_dist_targt-month08.
        elseif date5+4(2) eq '12'.
          t3 = ysd_dist_targt-month09.
        elseif date5+4(2) eq '01'.
          t3 = ysd_dist_targt-month10.
        elseif date5+4(2) eq '02'.
          t3 = ysd_dist_targt-month11.
        elseif date5+4(2) eq '03'.
          t3 = ysd_dist_targt-month12.
        endif.
      endif.

*******************************************************************************
*      SELECT SINGLE * FROM YSD_DIST_TARGT WHERE BZIRK = WA_TAB6-BZIRK AND TRGYEAR EQ CYEAR.
*      IF SY-SUBRC EQ 0.
*        IF DATE1+4(2) EQ '04'.
*          T1 = YSD_DIST_TARGT-MONTH01.
*        ELSEIF DATE1+4(2) EQ '05'.
*          T1 = YSD_DIST_TARGT-MONTH02.
*        ELSEIF DATE1+4(2) EQ '06'.
*          T1 = YSD_DIST_TARGT-MONTH03.
*        ELSEIF DATE1+4(2) EQ '07'.
*          T1 = YSD_DIST_TARGT-MONTH04.
*        ELSEIF DATE1+4(2) EQ '08'.
*          T1 = YSD_DIST_TARGT-MONTH05.
*        ELSEIF DATE1+4(2) EQ '09'.
*          T1 = YSD_DIST_TARGT-MONTH06.
*        ELSEIF DATE1+4(2) EQ '10'.
*          T1 = YSD_DIST_TARGT-MONTH07.
*        ELSEIF DATE1+4(2) EQ '11'.
*          T1 = YSD_DIST_TARGT-MONTH08.
*        ELSEIF DATE1+4(2) EQ '12'.
*          T1 = YSD_DIST_TARGT-MONTH09.
*        ELSEIF DATE1+4(2) EQ '01'.
*          T1 = YSD_DIST_TARGT-MONTH10.
*        ELSEIF DATE1+4(2) EQ '02'.
*          T1 = YSD_DIST_TARGT-MONTH11.
*        ELSEIF DATE1+4(2) EQ '03'.
*          T1 = YSD_DIST_TARGT-MONTH12.
*        ENDIF.
*
*        IF DATE4+4(2) EQ '04'.
*          T2 = YSD_DIST_TARGT-MONTH01.
*        ELSEIF DATE4+4(2) EQ '05'.
*          T2 = YSD_DIST_TARGT-MONTH02.
*        ELSEIF DATE4+4(2) EQ '06'.
*          T2 = YSD_DIST_TARGT-MONTH03.
*        ELSEIF DATE4+4(2) EQ '07'.
*          T2 = YSD_DIST_TARGT-MONTH04.
*        ELSEIF DATE4+4(2) EQ '08'.
*          T2 = YSD_DIST_TARGT-MONTH05.
*        ELSEIF DATE4+4(2) EQ '09'.
*          T2 = YSD_DIST_TARGT-MONTH06.
*        ELSEIF DATE4+4(2) EQ '10'.
*          T2 = YSD_DIST_TARGT-MONTH07.
*        ELSEIF DATE4+4(2) EQ '11'.
*          T2 = YSD_DIST_TARGT-MONTH08.
*        ELSEIF DATE4+4(2) EQ '12'.
*          T2 = YSD_DIST_TARGT-MONTH09.
*        ELSEIF DATE4+4(2) EQ '01'.
*          T2 = YSD_DIST_TARGT-MONTH10.
*        ELSEIF DATE4+4(2) EQ '02'.
*          T2 = YSD_DIST_TARGT-MONTH11.
*        ELSEIF DATE4+4(2) EQ '03'.
*          T2 = YSD_DIST_TARGT-MONTH12.
*        ENDIF.
*
*        IF DATE5+4(2) EQ '04'.
*          T3 = YSD_DIST_TARGT-MONTH01.
*        ELSEIF DATE5+4(2) EQ '05'.
*          T3 = YSD_DIST_TARGT-MONTH02.
*        ELSEIF DATE5+4(2) EQ '06'.
*          T3 = YSD_DIST_TARGT-MONTH03.
*        ELSEIF DATE5+4(2) EQ '07'.
*          T3 = YSD_DIST_TARGT-MONTH04.
*        ELSEIF DATE5+4(2) EQ '08'.
*          T3 = YSD_DIST_TARGT-MONTH05.
*        ELSEIF DATE5+4(2) EQ '09'.
*          T3 = YSD_DIST_TARGT-MONTH06.
*        ELSEIF DATE5+4(2) EQ '10'.
*          T3 = YSD_DIST_TARGT-MONTH07.
*        ELSEIF DATE5+4(2) EQ '11'.
*          T3 = YSD_DIST_TARGT-MONTH08.
*        ELSEIF DATE5+4(2) EQ '12'.
*          T3 = YSD_DIST_TARGT-MONTH09.
*        ELSEIF DATE5+4(2) EQ '01'.
*          T3 = YSD_DIST_TARGT-MONTH10.
*        ELSEIF DATE5+4(2) EQ '02'.
*          T3 = YSD_DIST_TARGT-MONTH11.
*        ELSEIF DATE5+4(2) EQ '03'.
*          T3 = YSD_DIST_TARGT-MONTH12.
*        ENDIF.

********************************************************

      wa_cptar1-bzirk = wa_tab6-bzirk.
      wa_cptar1-t1 = t1.
      wa_cptar1-t2 = t2.
      wa_cptar1-t3 = t3.
      collect wa_cptar1 into it_cptar1.
      clear wa_cptar1.
*    endif.
    endif.
  endloop.



endform.                    "ccumms
*&---------------------------------------------------------------------*
*&      Form  LCCUMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form lccumm.      "LAST YEAR CUMM. SALE FOR CURRENT JOINING


*  WRITE : 'FI DATES',F1DATE, F2DATE, F3DATE,F4DATE,F5DATE, F6DATE, F7DATE, F8DATE, F9DATE, F10DATE, F11DATE, F12DATE,'LY_DT1',LY_DT1.
*  WRITE : / 'fi start date',lchk_dt1,lchk_dt2,f1date,f2date,date2.
  loop  at it_tab6 into wa_tab6.
    clear  : t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,cumm_sale.
*    WRITE : / 'date',f1date,chk_dt1,wa_tab6-join_date.

    if ( chk_dt1 ge wa_tab6-join_date ) and ( f1date le date2 ).
      select single * from zcumpso where zmonth eq lchk_dt1+4(2) and zyear eq lchk_dt1+0(4) and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        t1 = zcumpso-netval.
      endif.
    endif.
    if ( chk_dt2 ge wa_tab6-join_date ) and ( f2date le date2 )..
      select single * from zcumpso where zmonth eq lchk_dt2+4(2) and zyear eq lchk_dt2+0(4) and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        t2 = zcumpso-netval.
      endif.
    endif.
    if ( chk_dt3 ge wa_tab6-join_date ) and ( f3date le date2 )..
      select single * from zcumpso where zmonth eq lchk_dt3+4(2) and zyear eq lchk_dt3+0(4) and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        t3 = zcumpso-netval.
      endif.
    endif.
    if ( chk_dt4 ge wa_tab6-join_date ) and ( f4date le date2 )..
      select single * from zcumpso where zmonth eq lchk_dt4+4(2) and zyear eq lchk_dt4+0(4) and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        t4 = zcumpso-netval.
      endif.
    endif.
    if ( chk_dt5 ge wa_tab6-join_date ) and ( f5date le date2 )..
      select single * from zcumpso where zmonth eq lchk_dt5+4(2) and zyear eq lchk_dt5+0(4) and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        t5 = zcumpso-netval.
      endif.
    endif.
    if ( chk_dt6 ge wa_tab6-join_date ) and ( f6date le date2 )..
      select single * from zcumpso where zmonth eq lchk_dt6+4(2) and zyear eq lchk_dt6+0(4) and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        t6 = zcumpso-netval.
      endif.
    endif.
    if ( chk_dt7 ge wa_tab6-join_date ) and ( f7date le date2 )..
      select single * from zcumpso where zmonth eq lchk_dt7+4(2) and zyear eq lchk_dt7+0(4) and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        t7 = zcumpso-netval.
      endif.
    endif.
    if ( chk_dt8 ge wa_tab6-join_date ) and ( f8date le date2 )..
      select single * from zcumpso where zmonth eq lchk_dt8+4(2) and zyear eq lchk_dt8+0(4) and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        t8 = zcumpso-netval.
      endif.
    endif.
    if ( chk_dt9 ge wa_tab6-join_date ) and ( f9date le date2 )..
      select single * from zcumpso where zmonth eq lchk_dt9+4(2) and zyear eq lchk_dt9+0(4) and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        t9 = zcumpso-netval.
      endif.
    endif.
    if ( chk_dt10 ge wa_tab6-join_date ) and ( f10date le date2 )..
      select single * from zcumpso where zmonth eq lchk_dt10+4(2) and zyear eq lchk_dt10+0(4) and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        t10 = zcumpso-netval.
      endif.
    endif.
    if ( chk_dt11 ge wa_tab6-join_date ) and ( f11date le date2 ).
      select single * from zcumpso where zmonth eq lchk_dt11+4(2) and zyear eq lchk_dt11+0(4) and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        t11 = zcumpso-netval.
      endif.
    endif.
    if ( chk_dt12 ge wa_tab6-join_date ) and ( f12date le date2 ).
      select single * from zcumpso where zmonth eq lchk_dt12+4(2) and zyear eq lchk_dt12+0(4) and bzirk eq wa_tab6-bzirk.
      if sy-subrc eq 0.
        t12 = zcumpso-netval.
      endif.
    endif.


    cumm_sale = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12.
    wa_lcumms2-bzirk = wa_tab6-bzirk.
    wa_lcumms2-ccumm_sale = cumm_sale.
    collect wa_lcumms2 into it_lcumms2.
    clear wa_lcumms2.
  endloop.
*  LOOP at it_lcumms2 INTO wa_lcumms2.
*    WRITE : / 'last cummulative sale',wa_lcumms2-bzirk,wa_lcumms2-ccumm_sale.
*  ENDLOOP.

endform.                    "current joining LCUMM


*&---------------------------------------------------------------------*
*&      Form  LCUMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form lcumm_zrcumpso.

*  call function 'HR_JP_MONTH_BEGIN_END_DATE'
*                 exporting
*                 iv_date                   = lchk_dt1
*                  importing
**                     EV_MONTH_BEGIN_DATE       =
*                     ev_month_end_date         = ly_dt1.
*
*
*  call function 'RE_ADD_MONTH_TO_DATE'
*    EXPORTING
*      months  = '1'
*      olddate = ly_dt1
*    IMPORTING
*      newdate = ly_dt2.
*
*  call function 'RE_ADD_MONTH_TO_DATE'
*    EXPORTING
*      months  = '2'
*      olddate = ly_dt1
*    IMPORTING
*      newdate = ly_dt3.
*
*  call function 'RE_ADD_MONTH_TO_DATE'
*    EXPORTING
*      months  = '3'
*      olddate = ly_dt1
*    IMPORTING
*      newdate = ly_dt4.
*
*  call function 'RE_ADD_MONTH_TO_DATE'
*    EXPORTING
*      months  = '4'
*      olddate = ly_dt1
*    IMPORTING
*      newdate = ly_dt5.
*
*  call function 'RE_ADD_MONTH_TO_DATE'
*    EXPORTING
*      months  = '5'
*      olddate = ly_dt1
*    IMPORTING
*      newdate = ly_dt6.
*
*  call function 'RE_ADD_MONTH_TO_DATE'
*    EXPORTING
*      months  = '6'
*      olddate = ly_dt1
*    IMPORTING
*      newdate = ly_dt7.
*
*  call function 'RE_ADD_MONTH_TO_DATE'
*    EXPORTING
*      months  = '7'
*      olddate = ly_dt1
*    IMPORTING
*      newdate = ly_dt8.
*
*  call function 'RE_ADD_MONTH_TO_DATE'
*    EXPORTING
*      months  = '8'
*      olddate = ly_dt1
*    IMPORTING
*      newdate = ly_dt9.
*
*  call function 'RE_ADD_MONTH_TO_DATE'
*    EXPORTING
*      months  = '9'
*      olddate = ly_dt1
*    IMPORTING
*      newdate = ly_dt10.
*
*  call function 'RE_ADD_MONTH_TO_DATE'
*    EXPORTING
*      months  = '10'
*      olddate = ly_dt1
*    IMPORTING
*      newdate = ly_dt11.
*
*  call function 'RE_ADD_MONTH_TO_DATE'
*    EXPORTING
*      months  = '11'
*      olddate = ly_dt1
*    IMPORTING
*      newdate = ly_dt12.

*  WRITE : / 'LAST CUMMULATIVE SALE',LCHK_DT1,LY_DT1,LY_DT2,LY_DT3,LY_DT4,LY_DT5,LY_DT6,LY_DT7,LY_DT8,LY_DT9,LY_DT10,LY_DT11,LY_DT12.
*  WRITE : / 'CHECK F1DATE;',F1DATE,DATE2.

**  WRITE : 'FI DATES',F1DATE, F2DATE, F3DATE,F4DATE,F5DATE, F6DATE, F7DATE, F8DATE, F9DATE, F10DATE, F11DATE, F12DATE.
  loop  at it_tab6 into wa_tab6.
    clear  : t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,cumm_sale,join_date.
**    WRITE : / f1date,date2.
*    if f1date le date2.

    join_date = wa_tab6-zmjoin_date.
    join_date+0(4) = join_date+0(4) - 1.


    if join_date le ly_dt1.
      select single * from zrcumpso where zmonth eq ly_dt1+4(2) and zyear eq ly_dt1+0(4) and bzirk eq wa_tab6-bzirk .
*      AND pso eq wa_tab6-pernr.
      if sy-subrc eq 0.
        t1 = zrcumpso-netval.
      endif.
    endif.

    if f2date le date2.
      if join_date le ly_dt2.
        select single * from zrcumpso where zmonth eq ly_dt2+4(2) and zyear eq ly_dt2+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t2 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f3date le date2.
      if join_date le ly_dt3.
        select single * from zrcumpso where zmonth eq ly_dt3+4(2) and zyear eq ly_dt3+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t3 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f4date le date2.
      if join_date le ly_dt4.
        select single * from zrcumpso where zmonth eq ly_dt4+4(2) and zyear eq ly_dt4+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t4 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f5date le date2.
      if join_date le ly_dt5.
        select single * from zrcumpso where zmonth eq ly_dt5+4(2) and zyear eq ly_dt5+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t5 = zrcumpso-netval.
        endif.
      endif.
    endif.


    if f6date le date2.
      if join_date le ly_dt6.
        select single * from zrcumpso where zmonth eq ly_dt6+4(2) and zyear eq ly_dt6+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t6 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f7date le date2.
      if join_date le ly_dt7.
        select single * from zrcumpso where zmonth eq ly_dt7+4(2) and zyear eq ly_dt7+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t7 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f8date le date2.
      if join_date le ly_dt8.
        select single * from zrcumpso where zmonth eq ly_dt8+4(2) and zyear eq ly_dt8+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t8 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f9date le date2.
      if join_date le ly_dt9.
        select single * from zrcumpso where zmonth eq ly_dt9+4(2) and zyear eq ly_dt9+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t9 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f10date le date2.
      if join_date le ly_dt10.
        select single * from zrcumpso where zmonth eq ly_dt10+4(2) and zyear eq ly_dt10+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t10 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f11date le date2.
      if join_date le ly_dt11.
        select single * from zrcumpso where zmonth eq ly_dt11+4(2) and zyear eq ly_dt11+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t11 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f12date le date2.
      if join_date le ly_dt12.
        select single * from zrcumpso where zmonth eq ly_dt12+4(2) and zyear eq ly_dt12+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t12 = zrcumpso-netval.
        endif.
      endif.
    endif.

    cumm_sale = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12.
    wa_lcummsr1-bzirk = wa_tab6-bzirk.
    wa_lcummsr1-lcumm_sale = cumm_sale.
    collect wa_lcummsr1 into it_lcummsr1.
    clear wa_lcummsr1.
  endloop.
*
*  LOOP at it_Lcumms1 INTO wa_Lcumms1.
*    WRITE : / 'LAST YEAR cummulative sale',wa_Lcumms1-bzirk,wa_Lcumms1-Lcumm_sale.
*  ENDLOOP.

endform.                    "LCUMM

*&---------------------------------------------------------------------*
*&      Form  lcumm_zrcumpso_rm
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form lcumm_zrcumpso_rm.


  loop  at it_tab6 into wa_tab6.
    clear  : t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,cumm_sale,join_date.
**    WRITE : / f1date,date2.
*    if f1date le date2.

    clear : join_date.
    select single * from pa0302 where pernr eq wa_tab6-rmpernr and massn eq '01'.
    if sy-subrc eq 0.
      join_date = pa0302-begda.
    endif.
    join_date+0(4) = join_date+0(4) - 1.


    if join_date le ly_dt1.
      select single * from zrcumpso where zmonth eq ly_dt1+4(2) and zyear eq ly_dt1+0(4) and bzirk eq wa_tab6-bzirk .
*      AND pso eq wa_tab6-pernr.
      if sy-subrc eq 0.
        t1 = zrcumpso-netval.
      endif.
    endif.

    if f2date le date2.
      if join_date le ly_dt2.
        select single * from zrcumpso where zmonth eq ly_dt2+4(2) and zyear eq ly_dt2+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t2 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f3date le date2.
      if join_date le ly_dt3.
        select single * from zrcumpso where zmonth eq ly_dt3+4(2) and zyear eq ly_dt3+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t3 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f4date le date2.
      if join_date le ly_dt4.
        select single * from zrcumpso where zmonth eq ly_dt4+4(2) and zyear eq ly_dt4+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t4 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f5date le date2.
      if join_date le ly_dt5.
        select single * from zrcumpso where zmonth eq ly_dt5+4(2) and zyear eq ly_dt5+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t5 = zrcumpso-netval.
        endif.
      endif.
    endif.


    if f6date le date2.
      if join_date le ly_dt6.
        select single * from zrcumpso where zmonth eq ly_dt6+4(2) and zyear eq ly_dt6+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t6 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f7date le date2.
      if join_date le ly_dt7.
        select single * from zrcumpso where zmonth eq ly_dt7+4(2) and zyear eq ly_dt7+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t7 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f8date le date2.
      if join_date le ly_dt8.
        select single * from zrcumpso where zmonth eq ly_dt8+4(2) and zyear eq ly_dt8+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t8 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f9date le date2.
      if join_date le ly_dt9.
        select single * from zrcumpso where zmonth eq ly_dt9+4(2) and zyear eq ly_dt9+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t9 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f10date le date2.
      if join_date le ly_dt10.
        select single * from zrcumpso where zmonth eq ly_dt10+4(2) and zyear eq ly_dt10+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t10 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f11date le date2.
      if join_date le ly_dt11.
        select single * from zrcumpso where zmonth eq ly_dt11+4(2) and zyear eq ly_dt11+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t11 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f12date le date2.
      if join_date le ly_dt12.
        select single * from zrcumpso where zmonth eq ly_dt12+4(2) and zyear eq ly_dt12+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t12 = zrcumpso-netval.
        endif.
      endif.
    endif.

    cumm_sale = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12.
    wa_lcummsr1_rm-bzirk = wa_tab6-bzirk.
    wa_lcummsr1_rm-lcumm_sale = cumm_sale.
    collect wa_lcummsr1_rm into it_lcummsr1_rm.
    clear wa_lcummsr1_rm.
  endloop.
*
*  LOOP at it_Lcumms1 INTO wa_Lcumms1.
*    WRITE : / 'LAST YEAR cummulative sale',wa_Lcumms1-bzirk,wa_Lcumms1-Lcumm_sale.
*  ENDLOOP.

endform.                    "LCUMM

*&---------------------------------------------------------------------*
*&      Form  lcumm_zrcumpso_zm
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form lcumm_zrcumpso_zm.


  loop  at it_tab6 into wa_tab6.
    clear  : t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,cumm_sale,join_date.
**    WRITE : / f1date,date2.
*    if f1date le date2.

    clear : join_date.
    select single * from pa0302 where pernr eq wa_tab6-zmpernr and massn eq '01'.
    if sy-subrc eq 0.
      join_date = pa0302-begda.
    endif.
    join_date+0(4) = join_date+0(4) - 1.


    if join_date le ly_dt1.
      select single * from zrcumpso where zmonth eq ly_dt1+4(2) and zyear eq ly_dt1+0(4) and bzirk eq wa_tab6-bzirk .
*      AND pso eq wa_tab6-pernr.
      if sy-subrc eq 0.
        t1 = zrcumpso-netval.
      endif.
    endif.

    if f2date le date2.
      if join_date le ly_dt2.
        select single * from zrcumpso where zmonth eq ly_dt2+4(2) and zyear eq ly_dt2+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t2 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f3date le date2.
      if join_date le ly_dt3.
        select single * from zrcumpso where zmonth eq ly_dt3+4(2) and zyear eq ly_dt3+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t3 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f4date le date2.
      if join_date le ly_dt4.
        select single * from zrcumpso where zmonth eq ly_dt4+4(2) and zyear eq ly_dt4+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t4 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f5date le date2.
      if join_date le ly_dt5.
        select single * from zrcumpso where zmonth eq ly_dt5+4(2) and zyear eq ly_dt5+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t5 = zrcumpso-netval.
        endif.
      endif.
    endif.


    if f6date le date2.
      if join_date le ly_dt6.
        select single * from zrcumpso where zmonth eq ly_dt6+4(2) and zyear eq ly_dt6+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t6 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f7date le date2.
      if join_date le ly_dt7.
        select single * from zrcumpso where zmonth eq ly_dt7+4(2) and zyear eq ly_dt7+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t7 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f8date le date2.
      if join_date le ly_dt8.
        select single * from zrcumpso where zmonth eq ly_dt8+4(2) and zyear eq ly_dt8+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t8 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f9date le date2.
      if join_date le ly_dt9.
        select single * from zrcumpso where zmonth eq ly_dt9+4(2) and zyear eq ly_dt9+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t9 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f10date le date2.
      if join_date le ly_dt10.
        select single * from zrcumpso where zmonth eq ly_dt10+4(2) and zyear eq ly_dt10+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t10 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f11date le date2.
      if join_date le ly_dt11.
        select single * from zrcumpso where zmonth eq ly_dt11+4(2) and zyear eq ly_dt11+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t11 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f12date le date2.
      if join_date le ly_dt12.
        select single * from zrcumpso where zmonth eq ly_dt12+4(2) and zyear eq ly_dt12+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t12 = zrcumpso-netval.
        endif.
      endif.
    endif.

    cumm_sale = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12.
    wa_lcummsr1_zm-bzirk = wa_tab6-bzirk.
    wa_lcummsr1_zm-lcumm_sale = cumm_sale.
    collect wa_lcummsr1_zm into it_lcummsr1_zm.
    clear wa_lcummsr1_zm.
  endloop.
*
*  LOOP at it_Lcumms1 INTO wa_Lcumms1.
*    WRITE : / 'LAST YEAR cummulative sale',wa_Lcumms1-bzirk,wa_Lcumms1-Lcumm_sale.
*  ENDLOOP.

endform.                    "LCUMM


*&---------------------------------------------------------------------*
*&      Form  lcumm_zrcumpso_dzm
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form lcumm_zrcumpso_dzm.


  loop  at it_tab6 into wa_tab6.
    clear  : t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,cumm_sale,join_date.
**    WRITE : / f1date,date2.
*    if f1date le date2.

    clear : join_date.
    select single * from pa0302 where pernr eq wa_tab6-dzmpernr and massn eq '01'.
    if sy-subrc eq 0.
      join_date = pa0302-begda.
    endif.
    join_date+0(4) = join_date+0(4) - 1.


    if join_date le ly_dt1.
      select single * from zrcumpso where zmonth eq ly_dt1+4(2) and zyear eq ly_dt1+0(4) and bzirk eq wa_tab6-bzirk .
*      AND pso eq wa_tab6-pernr.
      if sy-subrc eq 0.
        t1 = zrcumpso-netval.
      endif.
    endif.

    if f2date le date2.
      if join_date le ly_dt2.
        select single * from zrcumpso where zmonth eq ly_dt2+4(2) and zyear eq ly_dt2+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t2 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f3date le date2.
      if join_date le ly_dt3.
        select single * from zrcumpso where zmonth eq ly_dt3+4(2) and zyear eq ly_dt3+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t3 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f4date le date2.
      if join_date le ly_dt4.
        select single * from zrcumpso where zmonth eq ly_dt4+4(2) and zyear eq ly_dt4+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t4 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f5date le date2.
      if join_date le ly_dt5.
        select single * from zrcumpso where zmonth eq ly_dt5+4(2) and zyear eq ly_dt5+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t5 = zrcumpso-netval.
        endif.
      endif.
    endif.


    if f6date le date2.
      if join_date le ly_dt6.
        select single * from zrcumpso where zmonth eq ly_dt6+4(2) and zyear eq ly_dt6+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t6 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f7date le date2.
      if join_date le ly_dt7.
        select single * from zrcumpso where zmonth eq ly_dt7+4(2) and zyear eq ly_dt7+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t7 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f8date le date2.
      if join_date le ly_dt8.
        select single * from zrcumpso where zmonth eq ly_dt8+4(2) and zyear eq ly_dt8+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t8 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f9date le date2.
      if join_date le ly_dt9.
        select single * from zrcumpso where zmonth eq ly_dt9+4(2) and zyear eq ly_dt9+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t9 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f10date le date2.
      if join_date le ly_dt10.
        select single * from zrcumpso where zmonth eq ly_dt10+4(2) and zyear eq ly_dt10+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t10 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f11date le date2.
      if join_date le ly_dt11.
        select single * from zrcumpso where zmonth eq ly_dt11+4(2) and zyear eq ly_dt11+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t11 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f12date le date2.
      if join_date le ly_dt12.
        select single * from zrcumpso where zmonth eq ly_dt12+4(2) and zyear eq ly_dt12+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t12 = zrcumpso-netval.
        endif.
      endif.
    endif.

    cumm_sale = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12.
    wa_lcummsr1_dzm-bzirk = wa_tab6-bzirk.
    wa_lcummsr1_dzm-lcumm_sale = cumm_sale.
    collect wa_lcummsr1_dzm into it_lcummsr1_dzm.
    clear wa_lcummsr1_dzm.
  endloop.
*
*  LOOP at it_Lcumms1 INTO wa_Lcumms1.
*    WRITE : / 'LAST YEAR cummulative sale',wa_Lcumms1-bzirk,wa_Lcumms1-Lcumm_sale.
*  ENDLOOP.

endform.                    "LCUMM
*&---------------------------------------------------------------------*
*&      Form  lcumm_zrcumpso_pso
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form lcumm_zrcumpso_pso.


  loop  at it_tab6 into wa_tab6.
    clear  : t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,cumm_sale,join_date.
**    WRITE : / f1date,date2.
*    if f1date le date2.

    join_date = wa_tab6-join_date.
    join_date+0(4) = join_date+0(4) - 1.


    if join_date le ly_dt1.
      select single * from zrcumpso where zmonth eq ly_dt1+4(2) and zyear eq ly_dt1+0(4) and bzirk eq wa_tab6-bzirk .
*      AND pso eq wa_tab6-pernr.
      if sy-subrc eq 0.
        t1 = zrcumpso-netval.
      endif.
    endif.

    if f2date le date2.
      if join_date le ly_dt2.
        select single * from zrcumpso where zmonth eq ly_dt2+4(2) and zyear eq ly_dt2+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t2 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f3date le date2.
      if join_date le ly_dt3.
        select single * from zrcumpso where zmonth eq ly_dt3+4(2) and zyear eq ly_dt3+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t3 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f4date le date2.
      if join_date le ly_dt4.
        select single * from zrcumpso where zmonth eq ly_dt4+4(2) and zyear eq ly_dt4+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t4 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f5date le date2.
      if join_date le ly_dt5.
        select single * from zrcumpso where zmonth eq ly_dt5+4(2) and zyear eq ly_dt5+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t5 = zrcumpso-netval.
        endif.
      endif.
    endif.


    if f6date le date2.
      if join_date le ly_dt6.
        select single * from zrcumpso where zmonth eq ly_dt6+4(2) and zyear eq ly_dt6+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t6 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f7date le date2.
      if join_date le ly_dt7.
        select single * from zrcumpso where zmonth eq ly_dt7+4(2) and zyear eq ly_dt7+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t7 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f8date le date2.
      if join_date le ly_dt8.
        select single * from zrcumpso where zmonth eq ly_dt8+4(2) and zyear eq ly_dt8+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t8 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f9date le date2.
      if join_date le ly_dt9.
        select single * from zrcumpso where zmonth eq ly_dt9+4(2) and zyear eq ly_dt9+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t9 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f10date le date2.
      if join_date le ly_dt10.
        select single * from zrcumpso where zmonth eq ly_dt10+4(2) and zyear eq ly_dt10+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t10 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f11date le date2.
      if join_date le ly_dt11.
        select single * from zrcumpso where zmonth eq ly_dt11+4(2) and zyear eq ly_dt11+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t11 = zrcumpso-netval.
        endif.
      endif.
    endif.

    if f12date le date2.
      if join_date le ly_dt12.
        select single * from zrcumpso where zmonth eq ly_dt12+4(2) and zyear eq ly_dt12+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t12 = zrcumpso-netval.
        endif.
      endif.
    endif.

    cumm_sale = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12.
    wa_lcummsr1_pso-bzirk = wa_tab6-bzirk.
    wa_lcummsr1_pso-lcumm_sale = cumm_sale.
    collect wa_lcummsr1_pso into it_lcummsr1_pso.
    clear wa_lcummsr1_pso.
  endloop.
*
*  LOOP at it_Lcumms1 INTO wa_Lcumms1.
*    WRITE : / 'LAST YEAR cummulative sale',wa_Lcumms1-bzirk,wa_Lcumms1-Lcumm_sale.
*  ENDLOOP.

endform.                    "LCUMM

*&---------------------------------------------------------------------*
*&      Form  lcumm
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form lcumm.

  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date           = lchk_dt1
    importing
*     EV_MONTH_BEGIN_DATE       =
      ev_month_end_date = ly_dt1.


  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '1'
      olddate = ly_dt1
    importing
      newdate = ly_dt2.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '2'
      olddate = ly_dt1
    importing
      newdate = ly_dt3.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '3'
      olddate = ly_dt1
    importing
      newdate = ly_dt4.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '4'
      olddate = ly_dt1
    importing
      newdate = ly_dt5.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '5'
      olddate = ly_dt1
    importing
      newdate = ly_dt6.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '6'
      olddate = ly_dt1
    importing
      newdate = ly_dt7.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '7'
      olddate = ly_dt1
    importing
      newdate = ly_dt8.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '8'
      olddate = ly_dt1
    importing
      newdate = ly_dt9.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '9'
      olddate = ly_dt1
    importing
      newdate = ly_dt10.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '10'
      olddate = ly_dt1
    importing
      newdate = ly_dt11.

  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '11'
      olddate = ly_dt1
    importing
      newdate = ly_dt12.

*  WRITE : / 'LAST CUMMULATIVE SALE',LCHK_DT1,LY_DT1,LY_DT2,LY_DT3,LY_DT4,LY_DT5,LY_DT6,LY_DT7,LY_DT8,LY_DT9,LY_DT10,LY_DT11,LY_DT12.
*  WRITE : / 'CHECK F1DATE;',F1DATE,DATE2.

**  WRITE : 'FI DATES',F1DATE, F2DATE, F3DATE,F4DATE,F5DATE, F6DATE, F7DATE, F8DATE, F9DATE, F10DATE, F11DATE, F12DATE.
  loop  at it_tab6 into wa_tab6.
    clear  : t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,cumm_sale,join_date.
**    WRITE : / f1date,date2.
*    if f1date le date2.
    wa_lcumms1-bzirk = wa_tab6-bzirk.
    join_date = wa_tab6-zmjoin_date.
    join_date+0(4) = join_date+0(4) - 1.


    if join_date le ly_dt1.
      select single * from zcumpso where zmonth eq ly_dt1+4(2) and zyear eq ly_dt1+0(4) and bzirk eq wa_tab6-bzirk .
*      AND pso eq wa_tab6-pernr.
      if sy-subrc eq 0.
        t1 = zcumpso-netval.
      endif.
    endif.

    if f2date le date2.
      if join_date le ly_dt2.
        select single * from zcumpso where zmonth eq ly_dt2+4(2) and zyear eq ly_dt2+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t2 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f3date le date2.
      if join_date le ly_dt3.
        select single * from zcumpso where zmonth eq ly_dt3+4(2) and zyear eq ly_dt3+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t3 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f4date le date2.
      if join_date le ly_dt4.
        select single * from zcumpso where zmonth eq ly_dt4+4(2) and zyear eq ly_dt4+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t4 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f5date le date2.
      if join_date le ly_dt5.
        select single * from zcumpso where zmonth eq ly_dt5+4(2) and zyear eq ly_dt5+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t5 = zcumpso-netval.
        endif.
      endif.
    endif.


    if f6date le date2.
      if join_date le ly_dt6.
        select single * from zcumpso where zmonth eq ly_dt6+4(2) and zyear eq ly_dt6+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t6 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f7date le date2.
      if join_date le ly_dt7.
        select single * from zcumpso where zmonth eq ly_dt7+4(2) and zyear eq ly_dt7+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t7 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f8date le date2.
      if join_date le ly_dt8.
        select single * from zcumpso where zmonth eq ly_dt8+4(2) and zyear eq ly_dt8+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t8 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f9date le date2.
      if join_date le ly_dt9.
        select single * from zcumpso where zmonth eq ly_dt9+4(2) and zyear eq ly_dt9+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t9 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f10date le date2.
      if join_date le ly_dt10.
        select single * from zcumpso where zmonth eq ly_dt10+4(2) and zyear eq ly_dt10+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t10 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f11date le date2.
      if join_date le ly_dt11.
        select single * from zcumpso where zmonth eq ly_dt11+4(2) and zyear eq ly_dt11+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t11 = zcumpso-netval.
        endif.
      endif.
    endif.

    if f12date le date2.
      if join_date le ly_dt12.
        select single * from zcumpso where zmonth eq ly_dt12+4(2) and zyear eq ly_dt12+0(4) and bzirk eq wa_tab6-bzirk.
*         AND pso eq wa_tab6-pernr.
        if sy-subrc eq 0.
          t12 = zcumpso-netval.
        endif.
      endif.
    endif.

    cumm_sale = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12.

    wa_lcumms1-lcumm_sale = cumm_sale.
    collect wa_lcumms1 into it_lcumms1.
    clear wa_lcumms1.
  endloop.
*
*  LOOP at it_Lcumms1 INTO wa_Lcumms1.
*    WRITE : / 'LAST YEAR cummulative sale',wa_Lcumms1-bzirk,wa_Lcumms1-Lcumm_sale.
*  ENDLOOP.

endform.                    "LCUMM_ZRCUMPSO


*&---------------------------------------------------------------------*
*&      Form  CCUMM_tar
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

form cmtar.
  loop at it_tab6 into wa_tab6.
    clear t1.
*    WRITE : 'MONTH',MONTH,YEAR.
    select single * from ysd_dist_targt where bzirk eq wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if month eq '04'.
        t1 =  ysd_dist_targt-month01 / 1000.
      elseif month eq '05'.
        t1 = ysd_dist_targt-month02 / 1000.
      elseif month eq '06'.
        t1 =  ysd_dist_targt-month03 / 1000.
      elseif month eq '07'.
        t1 =  ysd_dist_targt-month04 / 1000.
      elseif month eq '08'.
        t1 = ysd_dist_targt-month05 / 1000.
      elseif month eq '09'.
        t1 = ysd_dist_targt-month06 / 1000.
      elseif month eq '10'.
        t1 = ysd_dist_targt-month07 / 1000.
      elseif month eq '11'.
        t1 = ysd_dist_targt-month08 / 1000.
      elseif month eq '12'.
        t1 = ysd_dist_targt-month09 / 1000.
      elseif month eq '01'.
        t1 =  ysd_dist_targt-month10 / 1000.
      elseif month eq '02'.
        t1 = ysd_dist_targt-month11 / 1000.
      elseif month eq '03'.
        t1 =  ysd_dist_targt-month12 / 1000.
      endif.
    endif.
    wa_cmtar-bzirk = wa_tab6-bzirk.
    wa_cmtar-ctar = t1.
    collect wa_cmtar into it_cmtar.
    clear wa_cmtar.
  endloop.
endform.                    "CMTAR

*&---------------------------------------------------------------------*
*&      Form  ccumm_tar
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form ccumm_tar.

  loop at it_tab6 into wa_tab6.
    clear : cyt,t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12.
*    WRITE : / 'current cummulative target date', chk_dt1,f1date,date2,wa_tab6-bzirk,wa_tab6-ename,wa_tab6-join_date.
*    if chk_dt1 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if f1date le date2.
        if wa_tab6-zmjoin_date le f1date.
          t1 = ysd_dist_targt-month01.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt2 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if f2date le date2.
        if wa_tab6-zmjoin_date le f2date.
          t2 = ysd_dist_targt-month02.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt3 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f3date le date2.
        if wa_tab6-zmjoin_date le f3date.
          t3 = ysd_dist_targt-month03.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt4 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if f4date le date2.
        if wa_tab6-zmjoin_date le f4date.
          t4 = ysd_dist_targt-month04.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt5 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f5date le date2.
        if wa_tab6-zmjoin_date le f5date.
          t5 = ysd_dist_targt-month05.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt6 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f6date le date2.
        if wa_tab6-zmjoin_date le f6date.
          t6 = ysd_dist_targt-month06.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt7 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f7date le date2.
        if wa_tab6-zmjoin_date le f7date.
          t7 = ysd_dist_targt-month07.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt8 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f8date le date2.
        if wa_tab6-zmjoin_date le f8date.
          t8 = ysd_dist_targt-month08.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt9 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f9date le date2.
        if wa_tab6-zmjoin_date le f9date.
          t9 = ysd_dist_targt-month09.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt10 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if f10date le date2.
        if wa_tab6-zmjoin_date le f10date.
          t10 = ysd_dist_targt-month10.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt11 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f11date le date2.
        if wa_tab6-zmjoin_date le f11date.
          t11 = ysd_dist_targt-month11.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt12 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if f12date le date2.
        if wa_tab6-zmjoin_date le f12date.
          t12 = ysd_dist_targt-month12.
        endif.
      endif.
    endif.
*    endif.
*    WRITE : / 'target',t1.

    cyt = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12.

*      CYT = YSD_DIST_TARGT-MONTH01 + YSD_DIST_TARGT-MONTH02 + YSD_DIST_TARGT-MONTH03 + YSD_DIST_TARGT-MONTH04 + YSD_DIST_TARGT-MONTH05 +
*      YSD_DIST_TARGT-MONTH06 + YSD_DIST_TARGT-MONTH07 + YSD_DIST_TARGT-MONTH08 + YSD_DIST_TARGT-MONTH09 + YSD_DIST_TARGT-MONTH10 +
*      YSD_DIST_TARGT-MONTH11 + YSD_DIST_TARGT-MONTH12.
    wa_ccyt1-cyt = cyt.
    wa_ccyt1-bzirk = wa_tab6-bzirk.
    collect wa_ccyt1 into it_ccyt1.
    clear wa_ccyt1.
*
*      WA_CYQT1-BZIRK = wa_TAB6-bzirk.
*      WA_CYQT1-QRT1 = YSD_DIST_TARGT-MONTH01 + YSD_DIST_TARGT-MONTH02 + YSD_DIST_TARGT-MONTH03.
*      WA_CYQT1-QRT2 = YSD_DIST_TARGT-MONTH04 + YSD_DIST_TARGT-MONTH05 + YSD_DIST_TARGT-MONTH06.
*      WA_CYQT1-QRT3 = YSD_DIST_TARGT-MONTH07 + YSD_DIST_TARGT-MONTH08 + YSD_DIST_TARGT-MONTH09.
*      WA_CYQT1-QRT4 = YSD_DIST_TARGT-MONTH10 + YSD_DIST_TARGT-MONTH11 + YSD_DIST_TARGT-MONTH12.
*      COLLECT WA_CYQT1 INTO IT_CYQT1.
*      CLEAR WA_CYQT1.

  endloop.

*  LOOP AT IT_CCYT1 INTO WA_CCYT1.
*    WRITE : /'CURRENT YEAR TARGET', WA_CCYT1-BZIRK,WA_CCYT1-CYT.
*  ENDLOOP.


endform.                    "CCUM_tar

*&---------------------------------------------------------------------*
*&      Form  ccumm_tar_zm
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form ccumm_tar_zm.

  loop at it_tab6 into wa_tab6.
    clear : cyt,t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12.
*    WRITE : / 'current cummulative target date', chk_dt1,f1date,date2,wa_tab6-bzirk,wa_tab6-ename,wa_tab6-join_date.
*    if chk_dt1 ge wa_tab6-join_dt.
    clear : join_date.
    select single * from pa0302 where pernr eq wa_tab6-zmpernr and massn eq '01'.
    if sy-subrc eq 0.
      join_date = pa0302-begda.
    endif.

    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if f1date le date2.
        if join_date le f1date.
          t1 = ysd_dist_targt-month01.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt2 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if f2date le date2.
        if join_date le f2date.
          t2 = ysd_dist_targt-month02.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt3 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f3date le date2.
        if join_date le f3date.
          t3 = ysd_dist_targt-month03.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt4 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if f4date le date2.
        if join_date le f4date.
          t4 = ysd_dist_targt-month04.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt5 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f5date le date2.
        if join_date le f5date.
          t5 = ysd_dist_targt-month05.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt6 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f6date le date2.
        if join_date le f6date.
          t6 = ysd_dist_targt-month06.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt7 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f7date le date2.
        if join_date le f7date.
          t7 = ysd_dist_targt-month07.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt8 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f8date le date2.
        if join_date le f8date.
          t8 = ysd_dist_targt-month08.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt9 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f9date le date2.
        if join_date le f9date.
          t9 = ysd_dist_targt-month09.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt10 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if f10date le date2.
        if join_date le f10date.
          t10 = ysd_dist_targt-month10.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt11 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f11date le date2.
        if join_date le f11date.
          t11 = ysd_dist_targt-month11.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt12 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if f12date le date2.
        if join_date le f12date.
          t12 = ysd_dist_targt-month12.
        endif.
      endif.
    endif.
*    endif.
*    WRITE : / 'target',t1.

    cyt = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12.

*      CYT = YSD_DIST_TARGT-MONTH01 + YSD_DIST_TARGT-MONTH02 + YSD_DIST_TARGT-MONTH03 + YSD_DIST_TARGT-MONTH04 + YSD_DIST_TARGT-MONTH05 +
*      YSD_DIST_TARGT-MONTH06 + YSD_DIST_TARGT-MONTH07 + YSD_DIST_TARGT-MONTH08 + YSD_DIST_TARGT-MONTH09 + YSD_DIST_TARGT-MONTH10 +
*      YSD_DIST_TARGT-MONTH11 + YSD_DIST_TARGT-MONTH12.
    wa_ccyt1_zm-cyt = cyt.
    wa_ccyt1_zm-bzirk = wa_tab6-bzirk.
    collect wa_ccyt1_zm into it_ccyt1_zm.
    clear wa_ccyt1_zm.
*
*      WA_CYQT1-BZIRK = wa_TAB6-bzirk.
*      WA_CYQT1-QRT1 = YSD_DIST_TARGT-MONTH01 + YSD_DIST_TARGT-MONTH02 + YSD_DIST_TARGT-MONTH03.
*      WA_CYQT1-QRT2 = YSD_DIST_TARGT-MONTH04 + YSD_DIST_TARGT-MONTH05 + YSD_DIST_TARGT-MONTH06.
*      WA_CYQT1-QRT3 = YSD_DIST_TARGT-MONTH07 + YSD_DIST_TARGT-MONTH08 + YSD_DIST_TARGT-MONTH09.
*      WA_CYQT1-QRT4 = YSD_DIST_TARGT-MONTH10 + YSD_DIST_TARGT-MONTH11 + YSD_DIST_TARGT-MONTH12.
*      COLLECT WA_CYQT1 INTO IT_CYQT1.
*      CLEAR WA_CYQT1.

  endloop.

*  LOOP AT IT_CCYT1 INTO WA_CCYT1.
*    WRITE : /'CURRENT YEAR TARGET', WA_CCYT1-BZIRK,WA_CCYT1-CYT.
*  ENDLOOP.


endform.                    "CCUM_tar


*&---------------------------------------------------------------------*
*&      Form  ccumm_tar_dzm
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form ccumm_tar_dzm.

  loop at it_tab6 into wa_tab6.
    clear : cyt,t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12.
*    WRITE : / 'current cummulative target date', chk_dt1,f1date,date2,wa_tab6-bzirk,wa_tab6-ename,wa_tab6-join_date.
*    if chk_dt1 ge wa_tab6-join_dt.
    clear : join_date.
    select single * from pa0302 where pernr eq wa_tab6-dzmpernr and massn eq '01'.
    if sy-subrc eq 0.
      join_date = pa0302-begda.
    endif.

    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if f1date le date2.
        if join_date le f1date.
          t1 = ysd_dist_targt-month01.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt2 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if f2date le date2.
        if join_date le f2date.
          t2 = ysd_dist_targt-month02.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt3 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f3date le date2.
        if join_date le f3date.
          t3 = ysd_dist_targt-month03.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt4 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if f4date le date2.
        if join_date le f4date.
          t4 = ysd_dist_targt-month04.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt5 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f5date le date2.
        if join_date le f5date.
          t5 = ysd_dist_targt-month05.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt6 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f6date le date2.
        if join_date le f6date.
          t6 = ysd_dist_targt-month06.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt7 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f7date le date2.
        if join_date le f7date.
          t7 = ysd_dist_targt-month07.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt8 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f8date le date2.
        if join_date le f8date.
          t8 = ysd_dist_targt-month08.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt9 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f9date le date2.
        if join_date le f9date.
          t9 = ysd_dist_targt-month09.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt10 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if f10date le date2.
        if join_date le f10date.
          t10 = ysd_dist_targt-month10.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt11 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f11date le date2.
        if join_date le f11date.
          t11 = ysd_dist_targt-month11.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt12 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if f12date le date2.
        if join_date le f12date.
          t12 = ysd_dist_targt-month12.
        endif.
      endif.
    endif.
*    endif.
*    WRITE : / 'target',t1.

    cyt = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12.

*      CYT = YSD_DIST_TARGT-MONTH01 + YSD_DIST_TARGT-MONTH02 + YSD_DIST_TARGT-MONTH03 + YSD_DIST_TARGT-MONTH04 + YSD_DIST_TARGT-MONTH05 +
*      YSD_DIST_TARGT-MONTH06 + YSD_DIST_TARGT-MONTH07 + YSD_DIST_TARGT-MONTH08 + YSD_DIST_TARGT-MONTH09 + YSD_DIST_TARGT-MONTH10 +
*      YSD_DIST_TARGT-MONTH11 + YSD_DIST_TARGT-MONTH12.
    wa_ccyt1_dzm-cyt = cyt.
    wa_ccyt1_dzm-bzirk = wa_tab6-bzirk.
    collect wa_ccyt1_dzm into it_ccyt1_dzm.
    clear wa_ccyt1_dzm.
*
*      WA_CYQT1-BZIRK = wa_TAB6-bzirk.
*      WA_CYQT1-QRT1 = YSD_DIST_TARGT-MONTH01 + YSD_DIST_TARGT-MONTH02 + YSD_DIST_TARGT-MONTH03.
*      WA_CYQT1-QRT2 = YSD_DIST_TARGT-MONTH04 + YSD_DIST_TARGT-MONTH05 + YSD_DIST_TARGT-MONTH06.
*      WA_CYQT1-QRT3 = YSD_DIST_TARGT-MONTH07 + YSD_DIST_TARGT-MONTH08 + YSD_DIST_TARGT-MONTH09.
*      WA_CYQT1-QRT4 = YSD_DIST_TARGT-MONTH10 + YSD_DIST_TARGT-MONTH11 + YSD_DIST_TARGT-MONTH12.
*      COLLECT WA_CYQT1 INTO IT_CYQT1.
*      CLEAR WA_CYQT1.

  endloop.

*  LOOP AT IT_CCYT1 INTO WA_CCYT1.
*    WRITE : /'CURRENT YEAR TARGET', WA_CCYT1-BZIRK,WA_CCYT1-CYT.
*  ENDLOOP.


endform.                    "CCUM_tar
*&---------------------------------------------------------------------*
*&      Form  ccumm_tar_Pso
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form ccumm_tar_pso.

  loop at it_tab6 into wa_tab6.
    clear : cyt,t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12.
*    WRITE : / 'current cummulative target date', chk_dt1,f1date,date2,wa_tab6-bzirk,wa_tab6-ename,wa_tab6-join_date.
*    if chk_dt1 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if f1date le date2.
        if wa_tab6-join_date le f1date.
          t1 = ysd_dist_targt-month01.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt2 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if f2date le date2.
        if wa_tab6-join_date le f2date.
          t2 = ysd_dist_targt-month02.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt3 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f3date le date2.
        if wa_tab6-join_date le f3date.
          t3 = ysd_dist_targt-month03.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt4 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if f4date le date2.
        if wa_tab6-join_date le f4date.
          t4 = ysd_dist_targt-month04.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt5 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f5date le date2.
        if wa_tab6-join_date le f5date.
          t5 = ysd_dist_targt-month05.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt6 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f6date le date2.
        if wa_tab6-join_date le f6date.
          t6 = ysd_dist_targt-month06.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt7 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f7date le date2.
        if wa_tab6-join_date le f7date.
          t7 = ysd_dist_targt-month07.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt8 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f8date le date2.
        if wa_tab6-join_date le f8date.
          t8 = ysd_dist_targt-month08.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt9 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f9date le date2.
        if wa_tab6-join_date le f9date.
          t9 = ysd_dist_targt-month09.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt10 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if f10date le date2.
        if wa_tab6-join_date le f10date.
          t10 = ysd_dist_targt-month10.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt11 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f11date le date2.
        if wa_tab6-join_date le f11date.
          t11 = ysd_dist_targt-month11.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt12 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if f12date le date2.
        if wa_tab6-join_date le f12date.
          t12 = ysd_dist_targt-month12.
        endif.
      endif.
    endif.
*    endif.
*    WRITE : / 'target',t1.

    cyt = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12.

*      CYT = YSD_DIST_TARGT-MONTH01 + YSD_DIST_TARGT-MONTH02 + YSD_DIST_TARGT-MONTH03 + YSD_DIST_TARGT-MONTH04 + YSD_DIST_TARGT-MONTH05 +
*      YSD_DIST_TARGT-MONTH06 + YSD_DIST_TARGT-MONTH07 + YSD_DIST_TARGT-MONTH08 + YSD_DIST_TARGT-MONTH09 + YSD_DIST_TARGT-MONTH10 +
*      YSD_DIST_TARGT-MONTH11 + YSD_DIST_TARGT-MONTH12.
    wa_ccyt1_pso-cyt = cyt.
    wa_ccyt1_pso-bzirk = wa_tab6-bzirk.
    collect wa_ccyt1_pso into it_ccyt1_pso.
    clear wa_ccyt1_pso.
*
*      WA_CYQT1-BZIRK = wa_TAB6-bzirk.
*      WA_CYQT1-QRT1 = YSD_DIST_TARGT-MONTH01 + YSD_DIST_TARGT-MONTH02 + YSD_DIST_TARGT-MONTH03.
*      WA_CYQT1-QRT2 = YSD_DIST_TARGT-MONTH04 + YSD_DIST_TARGT-MONTH05 + YSD_DIST_TARGT-MONTH06.
*      WA_CYQT1-QRT3 = YSD_DIST_TARGT-MONTH07 + YSD_DIST_TARGT-MONTH08 + YSD_DIST_TARGT-MONTH09.
*      WA_CYQT1-QRT4 = YSD_DIST_TARGT-MONTH10 + YSD_DIST_TARGT-MONTH11 + YSD_DIST_TARGT-MONTH12.
*      COLLECT WA_CYQT1 INTO IT_CYQT1.
*      CLEAR WA_CYQT1.

  endloop.

*  LOOP AT IT_CCYT1 INTO WA_CCYT1.
*    WRITE : /'CURRENT YEAR TARGET', WA_CCYT1-BZIRK,WA_CCYT1-CYT.
*  ENDLOOP.


endform.                    "CCUM_tar

*&---------------------------------------------------------------------*
*&      Form  ccumm_tar_rm
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form ccumm_tar_rm.

  loop at it_tab6 into wa_tab6.
    clear : cyt,t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12.
*    WRITE : / 'current cummulative target date', chk_dt1,f1date,date2,wa_tab6-bzirk,wa_tab6-ename,wa_tab6-join_date.
*    if chk_dt1 ge wa_tab6-join_dt.
    clear : join_date.
    select single * from pa0302 where pernr eq wa_tab6-rmpernr and massn eq '01'.
    if sy-subrc eq 0.
      join_date = pa0302-begda.
    endif.


    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if f1date le date2.
        if join_date le f1date.
          t1 = ysd_dist_targt-month01.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt2 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if f2date le date2.
        if join_date le f2date.
          t2 = ysd_dist_targt-month02.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt3 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f3date le date2.
        if join_date le f3date.
          t3 = ysd_dist_targt-month03.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt4 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if f4date le date2.
        if join_date le f4date.
          t4 = ysd_dist_targt-month04.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt5 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f5date le date2.
        if join_date le f5date.
          t5 = ysd_dist_targt-month05.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt6 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f6date le date2.
        if join_date le f6date.
          t6 = ysd_dist_targt-month06.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt7 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f7date le date2.
        if join_date le f7date.
          t7 = ysd_dist_targt-month07.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt8 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f8date le date2.
        if join_date le f8date.
          t8 = ysd_dist_targt-month08.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt9 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f9date le date2.
        if join_date le f9date.
          t9 = ysd_dist_targt-month09.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt10 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if f10date le date2.
        if join_date le f10date.
          t10 = ysd_dist_targt-month10.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt11 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear .
    if sy-subrc eq 0.
      if f11date le date2.
        if join_date le f11date.
          t11 = ysd_dist_targt-month11.
        endif.
      endif.
    endif.
*    endif.
*    if chk_dt12 ge wa_tab6-join_dt.
    select single * from ysd_dist_targt where bzirk = wa_tab6-bzirk and trgyear eq cyear.
    if sy-subrc eq 0.
      if f12date le date2.
        if join_date le f12date.
          t12 = ysd_dist_targt-month12.
        endif.
      endif.
    endif.
*    endif.
*    WRITE : / 'target',t1.

    cyt = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12.

*      CYT = YSD_DIST_TARGT-MONTH01 + YSD_DIST_TARGT-MONTH02 + YSD_DIST_TARGT-MONTH03 + YSD_DIST_TARGT-MONTH04 + YSD_DIST_TARGT-MONTH05 +
*      YSD_DIST_TARGT-MONTH06 + YSD_DIST_TARGT-MONTH07 + YSD_DIST_TARGT-MONTH08 + YSD_DIST_TARGT-MONTH09 + YSD_DIST_TARGT-MONTH10 +
*      YSD_DIST_TARGT-MONTH11 + YSD_DIST_TARGT-MONTH12.
    wa_ccyt1_rm-cyt = cyt.
    wa_ccyt1_rm-bzirk = wa_tab6-bzirk.
    collect wa_ccyt1_rm into it_ccyt1_rm.
    clear wa_ccyt1_rm.
*
*      WA_CYQT1-BZIRK = wa_TAB6-bzirk.
*      WA_CYQT1-QRT1 = YSD_DIST_TARGT-MONTH01 + YSD_DIST_TARGT-MONTH02 + YSD_DIST_TARGT-MONTH03.
*      WA_CYQT1-QRT2 = YSD_DIST_TARGT-MONTH04 + YSD_DIST_TARGT-MONTH05 + YSD_DIST_TARGT-MONTH06.
*      WA_CYQT1-QRT3 = YSD_DIST_TARGT-MONTH07 + YSD_DIST_TARGT-MONTH08 + YSD_DIST_TARGT-MONTH09.
*      WA_CYQT1-QRT4 = YSD_DIST_TARGT-MONTH10 + YSD_DIST_TARGT-MONTH11 + YSD_DIST_TARGT-MONTH12.
*      COLLECT WA_CYQT1 INTO IT_CYQT1.
*      CLEAR WA_CYQT1.

  endloop.

*  LOOP AT IT_CCYT1 INTO WA_CCYT1.
*    WRITE : /'CURRENT YEAR TARGET', WA_CCYT1-BZIRK,WA_CCYT1-CYT.
*  ENDLOOP.


endform.                    "CCUM_tar

*&---------------------------------------------------------------------*
*&      Form  llys
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form llys.


*  WRITE : / wa_tab6-bzirk,wa_tab6-pernr, wa_tab6-join_date.
*  WRITE : lchk_dt1.
  loop at it_tab6 into wa_tab6.
    clear : llsg,lls1,lls2,lls3,lls4,lls5,lls6,lls7,lls8,lls9,lls10,lls11,lls12.
    if lchk_dt1 ge wa_tab6-join_date.
      select single * from zcumpso where zmonth eq llchk_dt1+4(2) and zyear eq llchk_dt1+0(4) and bzirk eq wa_tab6-bzirk .
      if sy-subrc eq 0.
        lls1 = zcumpso-netval.
      endif.
    endif.
    if lchk_dt2 ge wa_tab6-join_date.

      select single * from zcumpso where zmonth eq llchk_dt2+4(2) and zyear eq llchk_dt2+0(4) and bzirk eq wa_tab6-bzirk .
      if sy-subrc eq 0.
        lls2 = zcumpso-netval.
      endif.
    endif.
    if lchk_dt3 ge wa_tab6-join_date.

      select single * from zcumpso where zmonth eq llchk_dt3+4(2) and zyear eq llchk_dt3+0(4) and bzirk eq wa_tab6-bzirk .
      if sy-subrc eq 0.
        lls3 = zcumpso-netval.
      endif.
    endif.
    if lchk_dt4 ge wa_tab6-join_date.

      select single * from zcumpso where zmonth eq llchk_dt4+4(2) and zyear eq llchk_dt4+0(4) and bzirk eq wa_tab6-bzirk .
      if sy-subrc eq 0.
        lls4 = zcumpso-netval.
      endif.
    endif.
    if lchk_dt5 ge wa_tab6-join_date.

      select single * from zcumpso where zmonth eq llchk_dt5+4(2) and zyear eq llchk_dt5+0(4) and bzirk eq wa_tab6-bzirk .
      if sy-subrc eq 0.
        lls5 = zcumpso-netval.
      endif.
    endif.
    if lchk_dt6 ge wa_tab6-join_date.

      select single * from zcumpso where zmonth eq llchk_dt6+4(2) and zyear eq llchk_dt6+0(4) and bzirk eq wa_tab6-bzirk .
      if sy-subrc eq 0.
        lls6 = zcumpso-netval.
      endif.
    endif.
    if lchk_dt7 ge wa_tab6-join_date.

      select single * from zcumpso where zmonth eq llchk_dt7+4(2) and zyear eq llchk_dt7+0(4) and bzirk eq wa_tab6-bzirk .
      if sy-subrc eq 0.
        lls7 = zcumpso-netval.
      endif.
    endif.
    if lchk_dt8 ge wa_tab6-join_date.

      select single * from zcumpso where zmonth eq llchk_dt8+4(2) and zyear eq llchk_dt8+0(4) and bzirk eq wa_tab6-bzirk .
      if sy-subrc eq 0.
        lls8 = zcumpso-netval.
      endif.
    endif.
    if lchk_dt9 ge wa_tab6-join_date.

      select single * from zcumpso where zmonth eq llchk_dt9+4(2) and zyear eq llchk_dt9+0(4) and bzirk eq wa_tab6-bzirk .
      if sy-subrc eq 0.
        lls9 = zcumpso-netval.
      endif.
    endif.
    if lchk_dt10 ge wa_tab6-join_date.

      select single * from zcumpso where zmonth eq llchk_dt10+4(2) and zyear eq llchk_dt10+0(4) and bzirk eq wa_tab6-bzirk .
      if sy-subrc eq 0.
        lls10 = zcumpso-netval.
      endif.
    endif.
    if lchk_dt11 ge wa_tab6-join_date.

      select single * from zcumpso where zmonth eq llchk_dt11+4(2) and zyear eq llchk_dt11+0(4) and bzirk eq wa_tab6-bzirk .
      if sy-subrc eq 0.
*        WRITE : 't11',ZCUMPSO-NETVAL.
        lls11 = zcumpso-netval.
      endif.
    endif.
    if lchk_dt12 ge wa_tab6-join_date.

      select single * from zcumpso where zmonth eq llchk_dt12+4(2) and zyear eq llchk_dt12+0(4) and bzirk eq wa_tab6-bzirk .
      if sy-subrc eq 0.
*        WRITE : 't12',ZCUMPSO-NETVAL.
        lls12 = zcumpso-netval.
      endif.
    endif.
    llsg = lls1 + lls2 + lls3 + lls4 + lls5 + lls6 + lls7 + lls8 + lls9 + lls10 + lls11 + lls12.
    wa_llsg-bzirk = wa_tab6-bzirk.
    wa_llsg-llsg = llsg.
    collect wa_llsg into it_llsg.
    clear wa_llsg.
  endloop.

*  LOOP AT IT_LLSG INTO WA_LLSG.
*    WRITE : / 'LLS SALE FOR GR',WA_LLSG-BZIRK,WA_LLSG-LLSG.
*  ENDLOOP.
endform.                    "llys

*&---------------------------------------------------------------------*
*&      Form  LINCR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form lincr.

  loop at it_tab6 into wa_tab6.
    wa_tab61-reg = wa_tab6-reg.
    wa_tab61-zmpernr = wa_tab6-zmpernr.
    collect wa_tab61 into it_tab61.
    clear wa_tab61.
  endloop.
  sort it_tab61 by zmpernr.
  delete adjacent duplicates from it_tab61 comparing zmpernr.

  if it_tab61 is not initial.
    select * from pa0008 into table it_pa0008 for all entries in it_tab61 where pernr eq it_tab61-zmpernr and endda ge date2.
  endif.

  if it_tab61 is not initial.
    select * from pa0008 into table it_pa0008_1 for all entries in it_tab61 where pernr eq it_tab61-zmpernr and endda lt date2.
  endif.

  sort it_pa0008 descending by begda.
  sort it_pa0008_1 descending by begda.

  loop at it_tab61 into wa_tab61.
    clear : g_sal1,g_sal2,g_sal3,incr,ndate,incr_dt,increment_dt.
*    WRITE : /1(7) WA_TAB6-BZIRK,9(8) WA_TAB6-PERNR,19(20) WA_TAB6-ENAME.
    read table it_pa0008 into wa_pa0008 with key pernr = wa_tab61-zmpernr.
    if sy-subrc eq 0.
      if wa_pa0008-lga01 eq '1CLA'.
        wa_pa0008-bet01 = 0.
      elseif wa_pa0008-lga02 eq '1CLA'.
        wa_pa0008-bet02 = 0.
      elseif wa_pa0008-lga03 eq '1CLA'.
        wa_pa0008-bet03 = 0.
      elseif wa_pa0008-lga04 eq '1CLA'.
        wa_pa0008-bet04 = 0.
      elseif wa_pa0008-lga05 eq '1CLA'.
        wa_pa0008-bet05 = 0.
      elseif wa_pa0008-lga06 eq '1CLA'.
        wa_pa0008-bet06 = 0.
      elseif wa_pa0008-lga07 eq '1CLA'.
        wa_pa0008-bet07 = 0.
      elseif wa_pa0008-lga08 eq '1CLA'.
        wa_pa0008-bet08 = 0.
      elseif wa_pa0008-lga09 eq '1CLA'.
        wa_pa0008-bet09 = 0.
      elseif wa_pa0008-lga10 eq '1CLA'.
        wa_pa0008-bet10 = 0.
      elseif wa_pa0008-lga11 eq '1CLA'.
        wa_pa0008-bet11 = 0.
      elseif wa_pa0008-lga12 eq '1CLA'.
        wa_pa0008-bet12 = 0.
      elseif wa_pa0008-lga13 eq '1CLA'.
        wa_pa0008-bet13 = 0.
      elseif wa_pa0008-lga14 eq '1CLA'.
        wa_pa0008-bet14 = 0.
      elseif wa_pa0008-lga15 eq '1CLA'.
        wa_pa0008-bet15 = 0.
      elseif wa_pa0008-lga16 eq '1CLA'.
        wa_pa0008-bet16 = 0.
      elseif wa_pa0008-lga17 eq '1CLA'.
        wa_pa0008-bet17 = 0.
      elseif wa_pa0008-lga18 eq '1CLA'.
        wa_pa0008-bet18 = 0.
      elseif wa_pa0008-lga19 eq '1CLA'.
        wa_pa0008-bet19 = 0.
      elseif wa_pa0008-lga20 eq '1CLA'.
        wa_pa0008-bet20 = 0.
      elseif wa_pa0008-lga21 eq '1CLA'.
        wa_pa0008-bet21 = 0.
      elseif wa_pa0008-lga22 eq '1CLA'.
        wa_pa0008-bet22 = 0.
      elseif wa_pa0008-lga23 eq '1CLA'.
        wa_pa0008-bet23 = 0.
      elseif wa_pa0008-lga24 eq '1CLA'.
        wa_pa0008-bet24 = 0.
      elseif wa_pa0008-lga25 eq '1CLA'.
        wa_pa0008-bet25 = 0.
      elseif wa_pa0008-lga26 eq '1CLA'.
        wa_pa0008-bet26 = 0.
      elseif wa_pa0008-lga27 eq '1CLA'.
        wa_pa0008-bet27 = 0.
      elseif wa_pa0008-lga28 eq '1CLA'.
        wa_pa0008-bet28 = 0.
      elseif wa_pa0008-lga29 eq '1CLA'.
        wa_pa0008-bet29 = 0.
      elseif wa_pa0008-lga30 eq '1CLA'.
        wa_pa0008-bet30 = 0.
      elseif wa_pa0008-lga31 eq '1CLA'.
        wa_pa0008-bet31 = 0.
      elseif wa_pa0008-lga32 eq '1CLA'.
        wa_pa0008-bet32 = 0.
      elseif wa_pa0008-lga33 eq '1CLA'.
        wa_pa0008-bet33 = 0.
      elseif wa_pa0008-lga34 eq '1CLA'.
        wa_pa0008-bet34 = 0.
      elseif wa_pa0008-lga35 eq '1CLA'.
        wa_pa0008-bet35 = 0.
      elseif wa_pa0008-lga36 eq '1CLA'.
        wa_pa0008-bet36 = 0.
      elseif wa_pa0008-lga37 eq '1CLA'.
        wa_pa0008-bet37 = 0.
      elseif wa_pa0008-lga38 eq '1CLA'.
        wa_pa0008-bet38 = 0.
      elseif wa_pa0008-lga39 eq '1CLA'.
        wa_pa0008-bet39 = 0.
      elseif wa_pa0008-lga40 eq '1CLA'.
        wa_pa0008-bet40 = 0.
      endif.
      g_sal1 =  wa_pa0008-bet01 + wa_pa0008-bet02 + wa_pa0008-bet03 + wa_pa0008-bet04 + wa_pa0008-bet05 + wa_pa0008-bet06 + wa_pa0008-bet07 +
                 wa_pa0008-bet08 + wa_pa0008-bet09 + wa_pa0008-bet10 + wa_pa0008-bet11 + wa_pa0008-bet12 + wa_pa0008-bet13 + wa_pa0008-bet14 +
                 wa_pa0008-bet15 + wa_pa0008-bet16 + wa_pa0008-bet17 + wa_pa0008-bet18 + wa_pa0008-bet19 + wa_pa0008-bet20 + wa_pa0008-bet21 +
                 wa_pa0008-bet22 + wa_pa0008-bet23 + wa_pa0008-bet24 + wa_pa0008-bet25 + wa_pa0008-bet26 + wa_pa0008-bet27 + wa_pa0008-bet28 +
                 wa_pa0008-bet29 + wa_pa0008-bet30 + wa_pa0008-bet31 + wa_pa0008-bet32 + wa_pa0008-bet33 + wa_pa0008-bet34 + wa_pa0008-bet35 +
                 wa_pa0008-bet36 + wa_pa0008-bet37 + wa_pa0008-bet38 + wa_pa0008-bet39 + wa_pa0008-bet40.

*      WRITE : 42(10) g_sal1, wa_pa0008-begda.  "current sal.
*      incr_dt = wa_pa0008-begda.
    endif.
**********last salary******


    read table it_pa0008_1 into wa_pa0008_1 with key pernr = wa_tab61-zmpernr.
    if sy-subrc eq 0.
      if wa_pa0008_1-lga01 eq '1CLA'.
        wa_pa0008_1-bet01 = 0.
      elseif wa_pa0008_1-lga02 eq '1CLA'.
        wa_pa0008_1-bet02 = 0.
      elseif wa_pa0008_1-lga03 eq '1CLA'.
        wa_pa0008_1-bet03 = 0.
      elseif wa_pa0008_1-lga04 eq '1CLA'.
        wa_pa0008_1-bet04 = 0.
      elseif wa_pa0008_1-lga05 eq '1CLA'.
        wa_pa0008_1-bet05 = 0.
      elseif wa_pa0008_1-lga06 eq '1CLA'.
        wa_pa0008_1-bet06 = 0.
      elseif wa_pa0008_1-lga07 eq '1CLA'.
        wa_pa0008_1-bet07 = 0.
      elseif wa_pa0008_1-lga08 eq '1CLA'.
        wa_pa0008_1-bet08 = 0.
      elseif wa_pa0008_1-lga09 eq '1CLA'.
        wa_pa0008_1-bet09 = 0.
      elseif wa_pa0008_1-lga10 eq '1CLA'.
        wa_pa0008_1-bet10 = 0.
      elseif wa_pa0008_1-lga11 eq '1CLA'.
        wa_pa0008_1-bet11 = 0.
      elseif wa_pa0008_1-lga12 eq '1CLA'.
        wa_pa0008_1-bet12 = 0.
      elseif wa_pa0008_1-lga13 eq '1CLA'.
        wa_pa0008_1-bet13 = 0.
      elseif wa_pa0008_1-lga14 eq '1CLA'.
        wa_pa0008_1-bet14 = 0.
      elseif wa_pa0008_1-lga15 eq '1CLA'.
        wa_pa0008_1-bet15 = 0.
      elseif wa_pa0008_1-lga16 eq '1CLA'.
        wa_pa0008_1-bet16 = 0.
      elseif wa_pa0008_1-lga17 eq '1CLA'.
        wa_pa0008_1-bet17 = 0.
      elseif wa_pa0008_1-lga18 eq '1CLA'.
        wa_pa0008_1-bet18 = 0.
      elseif wa_pa0008_1-lga19 eq '1CLA'.
        wa_pa0008_1-bet19 = 0.
      elseif wa_pa0008_1-lga20 eq '1CLA'.
        wa_pa0008_1-bet20 = 0.
      elseif wa_pa0008_1-lga21 eq '1CLA'.
        wa_pa0008_1-bet21 = 0.
      elseif wa_pa0008_1-lga22 eq '1CLA'.
        wa_pa0008_1-bet22 = 0.
      elseif wa_pa0008_1-lga23 eq '1CLA'.
        wa_pa0008_1-bet23 = 0.
      elseif wa_pa0008_1-lga24 eq '1CLA'.
        wa_pa0008_1-bet24 = 0.
      elseif wa_pa0008_1-lga25 eq '1CLA'.
        wa_pa0008_1-bet25 = 0.
      elseif wa_pa0008_1-lga26 eq '1CLA'.
        wa_pa0008_1-bet26 = 0.
      elseif wa_pa0008_1-lga27 eq '1CLA'.
        wa_pa0008_1-bet27 = 0.
      elseif wa_pa0008_1-lga28 eq '1CLA'.
        wa_pa0008_1-bet28 = 0.
      elseif wa_pa0008_1-lga29 eq '1CLA'.
        wa_pa0008_1-bet29 = 0.
      elseif wa_pa0008_1-lga30 eq '1CLA'.
        wa_pa0008_1-bet30 = 0.
      elseif wa_pa0008_1-lga31 eq '1CLA'.
        wa_pa0008_1-bet31 = 0.
      elseif wa_pa0008_1-lga32 eq '1CLA'.
        wa_pa0008_1-bet32 = 0.
      elseif wa_pa0008_1-lga33 eq '1CLA'.
        wa_pa0008_1-bet33 = 0.
      elseif wa_pa0008_1-lga34 eq '1CLA'.
        wa_pa0008_1-bet34 = 0.
      elseif wa_pa0008_1-lga35 eq '1CLA'.
        wa_pa0008_1-bet35 = 0.
      elseif wa_pa0008_1-lga36 eq '1CLA'.
        wa_pa0008_1-bet36 = 0.
      elseif wa_pa0008_1-lga37 eq '1CLA'.
        wa_pa0008_1-bet37 = 0.
      elseif wa_pa0008_1-lga38 eq '1CLA'.
        wa_pa0008_1-bet38 = 0.
      elseif wa_pa0008_1-lga39 eq '1CLA'.
        wa_pa0008_1-bet39 = 0.
      elseif wa_pa0008_1-lga40 eq '1CLA'.
        wa_pa0008_1-bet40 = 0.
      endif.
      g_sal2 =  wa_pa0008_1-bet01 + wa_pa0008_1-bet02 + wa_pa0008_1-bet03 + wa_pa0008_1-bet04 + wa_pa0008_1-bet05 + wa_pa0008_1-bet06 + wa_pa0008_1-bet07 +
                 wa_pa0008_1-bet08 + wa_pa0008_1-bet09 + wa_pa0008_1-bet10 + wa_pa0008_1-bet11 + wa_pa0008_1-bet12 + wa_pa0008_1-bet13 + wa_pa0008_1-bet14 +
                 wa_pa0008_1-bet15 + wa_pa0008_1-bet16 + wa_pa0008_1-bet17 + wa_pa0008_1-bet18 + wa_pa0008_1-bet19 + wa_pa0008_1-bet20 + wa_pa0008_1-bet21 +
                 wa_pa0008_1-bet22 + wa_pa0008_1-bet23 + wa_pa0008_1-bet24 + wa_pa0008_1-bet25 + wa_pa0008_1-bet26 + wa_pa0008_1-bet27 + wa_pa0008_1-bet28 +
                 wa_pa0008_1-bet29 + wa_pa0008_1-bet30 + wa_pa0008_1-bet31 + wa_pa0008_1-bet32 + wa_pa0008_1-bet33 + wa_pa0008_1-bet34 + wa_pa0008_1-bet35 +
                 wa_pa0008_1-bet36 + wa_pa0008_1-bet37 + wa_pa0008_1-bet38 + wa_pa0008_1-bet39 + wa_pa0008_1-bet40.
      date3 = wa_pa0008_1-begda.
*      WRITE : g_sal2, wa_pa0008_1-begda.  "last incr sal.
    endif.
*    WRITE : g_sal2,incr_dt, g_sal1.
    if g_sal2 gt 0.
      incr = g_sal1 - g_sal2.
*      WRITE : 'incement',incr.
      if incr eq 0.
        perform incr1.
        if g_sal3 gt 0.
          incr = g_sal1 - g_sal3.
          increment_dt = date3.
        endif.
      else.
        increment_dt = date2.
      endif.
    endif.
    wa_inc1-bzirk = wa_tab61-reg.
    wa_inc1-pernr = wa_tab61-zmpernr.
    wa_inc1-osal = g_sal2.
    wa_inc1-csal = g_sal1.
    wa_inc1-incr = incr.
    wa_inc1-increment_dt = increment_dt .
    if g_sal2 gt 0.
*      wa_inc1-incr_dt = incr_dt.
    endif.
    read table it_pa0019 into wa_pa0019 with key pernr = wa_tab61-zmpernr.
    if sy-subrc eq 0.
      wa_inc1-incr_dt = wa_pa0019-termn.
    endif.
    collect wa_inc1 into it_inc1.
    clear wa_inc1.
  endloop.

*  LOOP at it_inc1 INTO wa_inc1.
*    WRITE : / wa_inc1-bzirk,wa_inc1-pernr,wa_inc1-osal,wa_inc1-incr_dt,wa_inc1-csal,wa_inc1-incr.
*  ENDLOOP.
endform.                    "LINCR

*&---------------------------------------------------------------------*
*&      Form  incr1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form incr1.
  if it_tab61 is not initial.
    select * from pa0008 into table it_pa0008_2 for all entries in it_tab61 where pernr eq it_tab61-zmpernr and endda lt date3.
  endif.
  sort it_pa0008_2 descending by begda.


  read table it_pa0008_2 into wa_pa0008_2 with key pernr = wa_tab61-zmpernr.
  if sy-subrc eq 0.
    if wa_pa0008_2-lga01 eq '1CLA'.
      wa_pa0008_2-bet01 = 0.
    elseif wa_pa0008_2-lga02 eq '1CLA'.
      wa_pa0008_2-bet02 = 0.
    elseif wa_pa0008_2-lga03 eq '1CLA'.
      wa_pa0008_2-bet03 = 0.
    elseif wa_pa0008_2-lga04 eq '1CLA'.
      wa_pa0008_2-bet04 = 0.
    elseif wa_pa0008_2-lga05 eq '1CLA'.
      wa_pa0008_2-bet05 = 0.
    elseif wa_pa0008_2-lga06 eq '1CLA'.
      wa_pa0008_2-bet06 = 0.
    elseif wa_pa0008_2-lga07 eq '1CLA'.
      wa_pa0008_2-bet07 = 0.
    elseif wa_pa0008_2-lga08 eq '1CLA'.
      wa_pa0008_2-bet08 = 0.
    elseif wa_pa0008_2-lga09 eq '1CLA'.
      wa_pa0008_2-bet09 = 0.
    elseif wa_pa0008_2-lga10 eq '1CLA'.
      wa_pa0008_2-bet10 = 0.
    elseif wa_pa0008_2-lga11 eq '1CLA'.
      wa_pa0008_2-bet11 = 0.
    elseif wa_pa0008_2-lga12 eq '1CLA'.
      wa_pa0008_2-bet12 = 0.
    elseif wa_pa0008_2-lga13 eq '1CLA'.
      wa_pa0008_2-bet13 = 0.
    elseif wa_pa0008_2-lga14 eq '1CLA'.
      wa_pa0008_2-bet14 = 0.
    elseif wa_pa0008_2-lga15 eq '1CLA'.
      wa_pa0008_2-bet15 = 0.
    elseif wa_pa0008_2-lga16 eq '1CLA'.
      wa_pa0008_2-bet16 = 0.
    elseif wa_pa0008_2-lga17 eq '1CLA'.
      wa_pa0008_2-bet17 = 0.
    elseif wa_pa0008_2-lga18 eq '1CLA'.
      wa_pa0008_2-bet18 = 0.
    elseif wa_pa0008_2-lga19 eq '1CLA'.
      wa_pa0008_2-bet19 = 0.
    elseif wa_pa0008_2-lga20 eq '1CLA'.
      wa_pa0008_2-bet20 = 0.
    elseif wa_pa0008_2-lga21 eq '1CLA'.
      wa_pa0008_2-bet21 = 0.
    elseif wa_pa0008_2-lga22 eq '1CLA'.
      wa_pa0008_2-bet22 = 0.
    elseif wa_pa0008_2-lga23 eq '1CLA'.
      wa_pa0008_2-bet23 = 0.
    elseif wa_pa0008_2-lga24 eq '1CLA'.
      wa_pa0008_2-bet24 = 0.
    elseif wa_pa0008_2-lga25 eq '1CLA'.
      wa_pa0008_2-bet25 = 0.
    elseif wa_pa0008_2-lga26 eq '1CLA'.
      wa_pa0008_2-bet26 = 0.
    elseif wa_pa0008_2-lga27 eq '1CLA'.
      wa_pa0008_2-bet27 = 0.
    elseif wa_pa0008_2-lga28 eq '1CLA'.
      wa_pa0008_2-bet28 = 0.
    elseif wa_pa0008_2-lga29 eq '1CLA'.
      wa_pa0008_2-bet29 = 0.
    elseif wa_pa0008_2-lga30 eq '1CLA'.
      wa_pa0008_2-bet30 = 0.
    elseif wa_pa0008_2-lga31 eq '1CLA'.
      wa_pa0008_2-bet31 = 0.
    elseif wa_pa0008_2-lga32 eq '1CLA'.
      wa_pa0008_2-bet32 = 0.
    elseif wa_pa0008_2-lga33 eq '1CLA'.
      wa_pa0008_2-bet33 = 0.
    elseif wa_pa0008_2-lga34 eq '1CLA'.
      wa_pa0008_2-bet34 = 0.
    elseif wa_pa0008_2-lga35 eq '1CLA'.
      wa_pa0008_2-bet35 = 0.
    elseif wa_pa0008_2-lga36 eq '1CLA'.
      wa_pa0008_2-bet36 = 0.
    elseif wa_pa0008_2-lga37 eq '1CLA'.
      wa_pa0008_2-bet37 = 0.
    elseif wa_pa0008_2-lga38 eq '1CLA'.
      wa_pa0008_2-bet38 = 0.
    elseif wa_pa0008_2-lga39 eq '1CLA'.
      wa_pa0008_2-bet39 = 0.
    elseif wa_pa0008_2-lga40 eq '1CLA'.
      wa_pa0008_2-bet40 = 0.
    endif.
    g_sal3 =  wa_pa0008_2-bet01 + wa_pa0008_2-bet02 + wa_pa0008_2-bet03 + wa_pa0008_2-bet04 + wa_pa0008_2-bet05 + wa_pa0008_2-bet06 + wa_pa0008_2-bet07 +
               wa_pa0008_2-bet08 + wa_pa0008_2-bet09 + wa_pa0008_2-bet10 + wa_pa0008_2-bet11 + wa_pa0008_2-bet12 + wa_pa0008_2-bet13 + wa_pa0008_2-bet14 +
               wa_pa0008_2-bet15 + wa_pa0008_2-bet16 + wa_pa0008_2-bet17 + wa_pa0008_2-bet18 + wa_pa0008_2-bet19 + wa_pa0008_2-bet20 + wa_pa0008_2-bet21 +
               wa_pa0008_2-bet22 + wa_pa0008_2-bet23 + wa_pa0008_2-bet24 + wa_pa0008_2-bet25 + wa_pa0008_2-bet26 + wa_pa0008_2-bet27 + wa_pa0008_2-bet28 +
               wa_pa0008_2-bet29 + wa_pa0008_2-bet30 + wa_pa0008_2-bet31 + wa_pa0008_2-bet32 + wa_pa0008_2-bet33 + wa_pa0008_2-bet34 + wa_pa0008_2-bet35 +
               wa_pa0008_2-bet36 + wa_pa0008_2-bet37 + wa_pa0008_2-bet38 + wa_pa0008_2-bet39 + wa_pa0008_2-bet40.
*    date3 = wa_pa0008_2-begda.
*      WRITE : g_sal2, wa_pa0008_2-begda.  "last incr sal.
  endif.

endform.                    "incr1

*&---------------------------------------------------------------------*
*&      Form  zm
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form zm.
  loop at it_tab6 into wa_tab6.
    clear : t_sale,lyt,lls,lys,lgrw,qt1,qt2,qt3,qt4,t1,t2,t3,t4,q1,q2,q3,q4, lsqrt5,lsqrtc5,cqtr,lcummsr.
*    WRITE : / wa_TAB6-reg,wa_TAB6-rm,wa_TAB6-bzirk,wa_TAB6-plans,wa_TAB6-pernr,wa_TAB6-ename,wa_TAB6-zz_hqdesc,wa_TAB6-join_dt,wa_TAB6-div,WA_TAB6-TYP.
    wa_zm1-reg = wa_tab6-reg.
    wa_zm1-zm = wa_tab6-zm.
    wa_zm1-zmpernr = wa_tab6-zmpernr.
    wa_zm1-dzmpernr = wa_tab6-dzmpernr.
    read table it_cs into wa_cs with key bzirk = wa_tab6-bzirk.  "current , last & last to last month sale.
    if sy-subrc eq 0.
      wa_zm1-c1sale = wa_cs-c1sale.
      wa_zm1-c2sale = wa_cs-c2sale.
      wa_zm1-c3sale = wa_cs-c3sale.
    endif.

    read table it_cptar1 into wa_cptar1 with key bzirk = wa_tab6-bzirk.  "current , last & last to last month TARGET.
    if sy-subrc eq 0.
      wa_zm1-t1 = wa_cptar1-t1.
      wa_zm1-t2 = wa_cptar1-t2.
      wa_zm1-t3 = wa_cptar1-t3.
    endif.

    read table it_lly1 into wa_lly1 with key bzirk = wa_tab6-bzirk.  "LAST TO LAST YEAR SALE.
    if sy-subrc eq 0.
      clear : qt1,qt2,qt3,qt4.
      qt1 = wa_lly1-m1 + wa_lly1-m2 + wa_lly1-m3.
      qt2 = wa_lly1-m4 + wa_lly1-m5 + wa_lly1-m6.
      qt3 = wa_lly1-m7 + wa_lly1-m8 + wa_lly1-m9.
      qt4 = wa_lly1-m10 + wa_lly1-m11 + wa_lly1-m12.
      wa_zm1-llsqrt1 = qt1.
      wa_zm1-llsqrt2 = qt2.
      wa_zm1-llsqrt3 = qt3.
      wa_zm1-llsqrt4 = qt4.
    endif.

*    read table it_lqt1 into wa_lqt1 with key bzirk = wa_tab6-bzirk.  "LAST  YEAR SALE.
*    if sy-subrc eq 0.
*      wa_zm1-lsqrt1 = wa_lqt1-qt1.
*      wa_zm1-lsqrt2 = wa_lqt1-qt2.
*      wa_zm1-lsqrt3 = wa_lqt1-qt3.
*      wa_zm1-lsqrt4 = wa_lqt1-qt4.
*      lsqrt5 = wa_lqt1-qt1 + wa_lqt1-qt2 + wa_lqt1-qt3 + wa_lqt1-qt4.
*      wa_zm1-lsqrt5 = lsqrt5.
*    endif.

    read table it_lqtc1 into wa_lqtc1 with key bzirk = wa_tab6-bzirk.  "LAST  YEAR SALE from .
    if sy-subrc eq 0.
      wa_zm1-lsqrtc1 = wa_lqtc1-qt1.
      wa_zm1-lsqrtc2 = wa_lqtc1-qt2.
      wa_zm1-lsqrtc3 = wa_lqtc1-qt3.
      wa_zm1-lsqrtc4 = wa_lqtc1-qt4.
      lsqrtc5 = wa_lqtc1-qt1 + wa_lqtc1-qt2 + wa_lqtc1-qt3 + wa_lqtc1-qt4.
      wa_zm1-lsqrtc = lsqrtc5.
    endif.

    read table it_lcummsr1_dzm into wa_lcummsr1_dzm with key bzirk = wa_tab6-bzirk.  "LAST  YEAR CUMMULATIVE SALE from ZRCUMPSO.
    if sy-subrc eq 0.
      wa_zm1-lcummsr = wa_lcummsr1_dzm-lcumm_sale.
    endif.

*    read table it_lytq1 into wa_lytq1 with key bzirk = wa_tab6-bzirk.  "LAST YEAR Target.
*    if sy-subrc eq 0.
*      wa_zm1-ltqrt1 = wa_lytq1-qrt1.
*      wa_zm1-ltqrt2 = wa_lytq1-qrt2.
*      wa_zm1-ltqrt3 = wa_lytq1-qrt3.
*      wa_zm1-ltqrt4 = wa_lytq1-qrt4.
*    endif.

*    read table it_cqt1 into wa_cqt1 with key bzirk = wa_tab6-bzirk.  "CURRENT  YEAR SALE.
*    if sy-subrc eq 0.
*      wa_zm1-csqrt1 = wa_cqt1-qt1.
*      wa_zm1-csqrt2 = wa_cqt1-qt2.
*      wa_zm1-csqrt3 = wa_cqt1-qt3.
*      wa_zm1-csqrt4 = wa_cqt1-qt4.
*    endif.
*
*    read table it_cyqt1 into wa_cyqt1 with key bzirk = wa_tab6-bzirk.  "CURRENT  YEAR TARGET.
*    if sy-subrc eq 0.
*      wa_zm1-ctqrt1 = wa_cyqt1-qrt1.
*      wa_zm1-ctqrt2 = wa_cyqt1-qrt2.
*      wa_zm1-ctqrt3 = wa_cyqt1-qrt3.
*      wa_zm1-ctqrt4 = wa_cyqt1-qrt4.
*    endif.

    read table it_cummsr2_dzm into wa_cummsr2_dzm with key bzirk = wa_tab6-bzirk.  "CURRENT  YEAR CUMMULATIVE SALE FROM ZRCUMPSO.
    if sy-subrc eq 0.
      wa_zm1-cummsr = wa_cummsr2_dzm-ccumm_sale.
    endif.


************ CURRENT MONTH TARGET*************
    read table it_cmtar into wa_cmtar with key bzirk = wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_zm1-ctar = wa_cmtar-ctar.
    endif.

    read table it_lcumms1 into wa_lcumms1 with key bzirk = wa_tab6-bzirk.  "last year cummulative sale.
    if sy-subrc eq 0.
      wa_zm1-lcumms = wa_lcumms1-lcumm_sale.
    endif.

    read table it_cumms2_dzm into wa_cumms2_dzm with key bzirk = wa_tab6-bzirk.  "CURRENT year cummulative sale.
    if sy-subrc eq 0.
      wa_zm1-cumms = wa_cumms2_dzm-ccumm_sale.
    endif.

    read table it_ccyt1_dzm into wa_ccyt1_dzm with key bzirk = wa_tab6-bzirk.  "CURRENT year cummulative TARGET.
    if sy-subrc eq 0.
      wa_zm1-cummt = wa_ccyt1_dzm-cyt.
    endif.

    collect wa_zm1 into it_zm1.
    clear wa_zm1.
  endloop.
****************************************************************************************************************************
  clear: it_pa0001a1,wa_pa0001a1.
  if it_zm1 is not initial.
    select * from pa0001 into table it_pa0001a1 for all entries in it_zm1 where plans eq it_zm1-plans.
  endif.
  sort it_pa0001a1 descending by endda.

  loop at it_zm1 into wa_zm1 .
    clear : lpqrt1,lpqrt2,lpqrt1,lpqrt3,lpqrt4,lcumm,lgrw,pjoin_dt,incrdt,ltqrt,llsqrt,lsqrt,
            cpqrt1,cpqrt2,cpqrt1,cpqrt3,cpqrt4,ccumm,cgrw, cp1,cp2,cp3,
            ls1,ls2,ls3,ls4, lsc1,lsc2,lsc3,lsc4,cs1,cs2,cs3,cs4, lysale,cysale,lysalec, prom, sl1, sl2, sl3.

    wa_zm3-reg = wa_zm1-reg.
    wa_zm3-zm = wa_zm1-zm.
    wa_zm3-zmpernr = wa_zm1-zmpernr.
    wa_zm3-dzmpernr = wa_zm1-dzmpernr.

    select single * from pa0302 where pernr eq wa_zm1-dzmpernr and massn eq '01'.
    if sy-subrc eq 0.
      concatenate pa0302-begda+4(2) '/' pa0302-begda+0(4) into pjoin_dt.
      wa_zm3-join_dt = pjoin_dt.
      wa_zm3-join_date = pa0302-begda.
    endif.

    if  wa_zm3-join_dt eq space.  "added on 16.7.24
      clear : pjoin_dt.
      read table it_pa0001a1 into wa_pa0001a1 with key plans = wa_zm3-plans.
      if sy-subrc eq 0.
        select single * from pa0302 where pernr eq wa_pa0001a1-pernr and massn eq '10'.
        if sy-subrc eq 0.
          concatenate pa0302-begda+4(2) '/' pa0302-begda+0(4) into pjoin_dt.
          wa_zm3-join_dt = pjoin_dt.
        endif.
*      BREAK-POINT .
        if  wa_zm3-join_dt eq space.
          concatenate wa_pa0001a1-endda+4(2) '/' wa_pa0001a1-endda+0(4) into pjoin_dt.
          wa_zm3-join_dt = pjoin_dt.
        endif.
      endif.
    endif.
    if  wa_zm3-join_dt eq space or wa_zm3-join_dt+3(4) ge '2999'.
      concatenate '04' '/' '2024' into wa_zm3-join_dt .  "added on 16.7.24
    endif.

*    WRITE : /1 wa_ZM1-reg,8 wa_ZM1-rm,16(8) wa_ZM1-llsqrt1,27(8) wa_ZM1-llsqrt2,37(8) wa_ZM1-llsqrt3,47(8) wa_ZM1-llsqrt4.
*    WRITE : 55(8) wa_ZM1-lsqrt1,65(8) wa_ZM1-lsqrt2,75(8) wa_ZM1-lsqrt3,85(8) wa_ZM1-lsqrt4.
*    WRITE : 95(8) wa_ZM1-ltqrt1,105(8) wa_ZM1-ltqrt2,115(8) wa_ZM1-ltqrt3,125(8) wa_ZM1-ltqrt4.
*    WRITE : 135(8) wa_ZM1-csqrt1,145(8) wa_ZM1-csqrt2,155(8) wa_ZM1-csqrt3,165(8) wa_ZM1-csqrt4.
*    WRITE : 175(8) wa_ZM1-ctqrt1,185(8) wa_ZM1-ctqrt2,195(8) wa_ZM1-ctqrt3,205(8) wa_ZM1-ctqrt4.
**************** LAST YEAR SALE PERFORMANVE ***********
***************** 1ST QRT *****************
    clear : aprsale,maysale,junsale,julsale,augsale,sepsale,octsale,novsale,decsale,jansale,febsale,marsale.
    clear : aprtar,maytar,juntar,jultar,augtar,septar,octtar,novtar,dectar,jantar,febtar,martar.

    loop at it_lapr into wa_lapr where zm = wa_zm1-reg and dzm = wa_zm1-zm.
      aprsale = aprsale +  wa_lapr-netval.
      aprtar = aprtar + wa_lapr-tar.
    endloop.
    loop at it_lmay into wa_lmay where zm = wa_zm1-reg and dzm = wa_zm1-zm.
      maysale = maysale +  wa_lmay-netval.
      maytar = maytar + wa_lmay-tar.
    endloop.
    loop at it_ljun into wa_ljun where zm = wa_zm1-reg and dzm = wa_zm1-zm.
      junsale = junsale +  wa_ljun-netval.
      juntar = juntar + wa_ljun-tar.
    endloop.
    wa_zm1-lsqrt1 = aprsale + maysale + junsale.
    wa_zm1-ltqrt1 = aprtar + maytar + juntar.
****************2ND QRT *******************
    loop at it_ljul into wa_ljul where zm = wa_zm1-reg and dzm = wa_zm1-zm.
      julsale = julsale +  wa_ljul-netval.
      jultar = jultar + wa_ljul-tar.
    endloop.
    loop at it_laug into wa_laug where zm = wa_zm1-reg and dzm = wa_zm1-zm.
      augsale = augsale +  wa_laug-netval.
      augtar = augtar + wa_laug-tar.
    endloop.
    loop at it_lsep into wa_lsep where zm = wa_zm1-reg and dzm = wa_zm1-zm.
      sepsale = sepsale +  wa_lsep-netval.
      septar = septar + wa_lsep-tar.
    endloop.
    wa_zm1-lsqrt2 = julsale + augsale + sepsale.
    wa_zm1-ltqrt2 = jultar + augtar + septar.
****************3rd QRT *******************
    loop at it_loct into wa_loct where zm = wa_zm1-reg and dzm = wa_zm1-zm.
      octsale = octsale +  wa_loct-netval.
      octtar = octtar + wa_loct-tar.
    endloop.
    loop at it_lnov into wa_lnov where zm = wa_zm1-reg and dzm = wa_zm1-zm.
      novsale = novsale +  wa_lnov-netval.
      novtar = novtar + wa_lnov-tar.
    endloop.
    loop at it_ldec into wa_ldec where zm = wa_zm1-reg and dzm = wa_zm1-zm.
      decsale = decsale +  wa_ldec-netval.
      dectar = dectar + wa_ldec-tar.
    endloop.
    wa_zm1-lsqrt3 = octsale + novsale + decsale.
    wa_zm1-ltqrt3 = octtar + novtar + dectar.

****************4TH QRT *******************
    loop at it_ljan into wa_ljan where zm = wa_zm1-reg and dzm = wa_zm1-zm.
      jansale = jansale +  wa_ljan-netval.
      jantar = jantar + wa_ljan-tar.
    endloop.
    loop at it_lfeb into wa_lfeb where zm = wa_zm1-reg and dzm = wa_zm1-zm.
      febsale = febsale +  wa_lfeb-netval.
      febtar = febtar + wa_lfeb-tar.
    endloop.
    loop at it_lmar into wa_lmar where zm = wa_zm1-reg and dzm = wa_zm1-zm.
      marsale = marsale +  wa_lmar-netval.
      martar = martar + wa_lmar-tar.
    endloop.
    wa_zm1-lsqrt4 = jansale + febsale + marsale.
    wa_zm1-ltqrt4 = jantar + febtar + martar.

*******************************************************
    if wa_zm1-ltqrt1 gt 0.
      lpqrt1 = ( wa_zm1-lsqrt1 / wa_zm1-ltqrt1 ) * 100.
    endif.
    if wa_zm1-ltqrt2 gt 0.
      lpqrt2 = ( wa_zm1-lsqrt2 / wa_zm1-ltqrt2 ) * 100.
    endif.
    if wa_zm1-ltqrt3 gt 0.
      lpqrt3 = ( wa_zm1-lsqrt3 / wa_zm1-ltqrt3 ) * 100.
    endif.
    if wa_zm1-ltqrt4 gt 0.
      lpqrt4 = ( wa_zm1-lsqrt4 / wa_zm1-ltqrt4 ) * 100.
    endif.
    wa_zm3-lpqrt1 = lpqrt1.
    wa_zm3-lpqrt2 = lpqrt2.
    wa_zm3-lpqrt3 = lpqrt3.
    wa_zm3-lpqrt4 = lpqrt4.


    ls1 = wa_zm1-lsqrt1 / 1000.
    ls2 = wa_zm1-lsqrt2 / 1000.
    ls3 = wa_zm1-lsqrt3 / 1000.
    ls4 = wa_zm1-lsqrt4 / 1000.
    wa_zm3-lysale1 = ls1.
    wa_zm3-lysale2 = ls2.
    wa_zm3-lysale3 = ls3.
    wa_zm3-lysale4 = ls4.
    lysale = ls1 + ls2 + ls3 + ls4.
    wa_zm3-lysale = lysale.

    lsc1 = wa_zm1-lsqrtc1 / 1000.
    lsc2 = wa_zm1-lsqrtc2 / 1000.
    lsc3 = wa_zm1-lsqrtc3 / 1000.
    lsc4 = wa_zm1-lsqrtc4 / 1000.
    wa_zm3-lysalec1 = lsc1.
    wa_zm3-lysalec2 = lsc2.
    wa_zm3-lysalec3 = lsc3.
    wa_zm3-lysalec4 = lsc4.
    lysalec = lsc1 + lsc2 + lsc3 + lsc4.
    wa_zm3-lysalec = lysalec.

************ LAST YEAR CUMMULATIVE***********


*********************************************
    ltqrt = wa_zm1-ltqrt1 + wa_zm1-ltqrt2 + wa_zm1-ltqrt3 + wa_zm1-ltqrt4 .
    if ltqrt gt 0.
      lcumm = ( ( wa_zm1-lsqrt1 + wa_zm1-lsqrt2 + wa_zm1-lsqrt3 + wa_zm1-lsqrt4 ) / ltqrt ) * 100.
    endif.
    wa_zm3-lcumm = lcumm.
********************** LAST YEAR GROWTH ******************
    llsqrt = wa_zm1-llsqrt1 + wa_zm1-llsqrt2 + wa_zm1-llsqrt3 + wa_zm1-llsqrt4.
    if llsqrt gt 0.
      lgrw = ( ( wa_zm1-lsqrt1 + wa_zm1-lsqrt2 + wa_zm1-lsqrt3 + wa_zm1-lsqrt4 ) / llsqrt ) * 100 - 100.
    else.
      lgrw = 100.
    endif.
    wa_zm3-lgrw = lgrw.
************* CURRENT MONTH TARGET************
    wa_zm3-ctar = wa_zm1-ctar .

**************** CURRENT YEAR SALE PERFORMANVE ***********
***************** 1ST QRT *****************
    clear : aprsale,maysale,junsale,julsale,augsale,sepsale,octsale,novsale,decsale,jansale,febsale,marsale.
    clear : aprtar,maytar,juntar,jultar,augtar,septar,octtar,novtar,dectar,jantar,febtar,martar.

    loop at it_apr into wa_apr where zm = wa_zm1-reg and dzm = wa_zm1-zm.
      aprsale = aprsale +  wa_apr-netval.
      aprtar = aprtar + wa_apr-tar.
    endloop.
    loop at it_may into wa_may where zm = wa_zm1-reg and dzm = wa_zm1-zm.
      maysale = maysale +  wa_may-netval.
      maytar = maytar + wa_may-tar.
    endloop.
    loop at it_jun into wa_jun where zm = wa_zm1-reg and dzm = wa_zm1-zm.
      junsale = junsale +  wa_jun-netval.
      juntar = juntar + wa_jun-tar.
    endloop.
    wa_zm1-csqrt1 = aprsale + maysale + junsale.
    wa_zm1-ctqrt1 = aprtar + maytar + juntar.
****************2ND QRT *******************
    loop at it_jul into wa_jul where zm = wa_zm1-reg and dzm = wa_zm1-zm.
      julsale = julsale +  wa_jul-netval.
      jultar = jultar + wa_jul-tar.
    endloop.
    loop at it_aug into wa_aug where zm = wa_zm1-reg and dzm = wa_zm1-zm.
      augsale = augsale +  wa_aug-netval.
      augtar = augtar + wa_aug-tar.
    endloop.
    loop at it_sep into wa_sep where zm = wa_zm1-reg and dzm = wa_zm1-zm.
      sepsale = sepsale +  wa_sep-netval.
      septar = septar + wa_sep-tar.
    endloop.
    wa_zm1-csqrt2 = julsale + augsale + sepsale.
    wa_zm1-ctqrt2 = jultar + augtar + septar.
****************3rd QRT *******************
    loop at it_oct into wa_oct where zm = wa_zm1-reg and dzm = wa_zm1-zm.
      octsale = octsale +  wa_oct-netval.
      octtar = octtar + wa_oct-tar.
    endloop.
    loop at it_nov into wa_nov where zm = wa_zm1-reg and dzm = wa_zm1-zm.
      novsale = novsale +  wa_nov-netval.
      novtar = novtar + wa_nov-tar.
    endloop.
    loop at it_dec into wa_dec where zm = wa_zm1-reg and dzm = wa_zm1-zm.
      decsale = decsale +  wa_dec-netval.
      dectar = dectar + wa_dec-tar.
    endloop.
    wa_zm1-csqrt3 = octsale + novsale + decsale.
    wa_zm1-ctqrt3 = octtar + novtar + dectar.

****************4TH QRT *******************
    loop at it_jan into wa_jan where zm = wa_zm1-reg and dzm = wa_zm1-zm.
      jansale = jansale +  wa_jan-netval.
      jantar = jantar + wa_jan-tar.
    endloop.
    loop at it_feb into wa_feb where zm = wa_zm1-reg and dzm = wa_zm1-zm.
      febsale = febsale +  wa_feb-netval.
      febtar = febtar + wa_feb-tar.
    endloop.
    loop at it_mar into wa_mar where zm = wa_zm1-reg and dzm = wa_zm1-zm.
      marsale = marsale +  wa_mar-netval.
      martar = martar + wa_mar-tar.
    endloop.
    wa_zm1-csqrt4 = jansale + febsale + marsale.
    wa_zm1-ctqrt4 = jantar + febtar + martar.
**********************************************************
    if date2 ge f3date.
      if wa_zm1-ctqrt1 gt 0.
        cpqrt1 = ( wa_zm1-csqrt1 / wa_zm1-ctqrt1 ) * 100.
      endif.
    endif.
    if date2 ge f6date.
      if wa_zm1-ctqrt2 gt 0.
        cpqrt2 = ( wa_zm1-csqrt2 / wa_zm1-ctqrt2 ) * 100.
      endif.
    endif.
    if date2 ge f9date.
      if wa_zm1-ctqrt3 gt 0.
        cpqrt3 = ( wa_zm1-csqrt3 / wa_zm1-ctqrt3 ) * 100.
      endif.
    endif.
    if date2 ge f12date.
      if wa_zm1-ctqrt4 gt 0.
        cpqrt4 = ( wa_zm1-csqrt4 / wa_zm1-ctqrt4 ) * 100.
      endif.
    endif.

    wa_zm3-cpqrt1 = cpqrt1.
    wa_zm3-cpqrt2 = cpqrt2.
    wa_zm3-cpqrt3 = cpqrt3.
    wa_zm3-cpqrt4 = cpqrt4.

    if date2 ge f3date.
      cs1 = wa_zm1-csqrt1 / 1000.
    endif.
    if date2 ge f6date.
      cs2 = wa_zm1-csqrt2 / 1000.
    endif.
    if date2 ge f9date.
      cs3 = wa_zm1-csqrt3 / 1000.
    endif.
    if date2 ge f12date.
      cs4 = wa_zm1-csqrt4 / 1000.
    endif.

    wa_zm3-cysale1 = cs1.
    wa_zm3-cysale2 = cs2.
    wa_zm3-cysale3 = cs3.
    wa_zm3-cysale4 = cs4.
*    cysale = cs1 + cs2 + cs3 + cs4.
*    cysale = ( wa_zm1-csqrt1 + wa_zm1-csqrt2 + wa_zm1-csqrt3 + wa_zm1-csqrt4 ) / 1000.

*************logic for cummulative************************
    clear : v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12.
    if wa_zm3-join_date le f1date.
      if date2 ge f1date.
        v1 = aprsale.
      endif.
    endif.
    if wa_zm3-join_date le f2date.
      if date2 ge f2date.
        v2 = maysale.
      endif.
    endif.
    if wa_zm3-join_date le f3date.
      if date2 ge f3date.
        v3 = junsale.
      endif.
    endif.
    if wa_zm3-join_date le f4date.
      if date2 ge f4date.
        v4 = julsale.
      endif.
    endif.
    if wa_zm3-join_date le f5date.
      if date2 ge f5date.
        v5 = augsale.
      endif.
    endif.
    if wa_zm3-join_date le f6date.
      if date2 ge f6date.
        v6 = sepsale.
      endif.
    endif.
    if wa_zm3-join_date le f7date.
      if date2 ge f7date.
        v7 = octsale.
      endif.
    endif.
    if wa_zm3-join_date le f8date.
      if date2 ge f8date.
        v8 = novsale.
      endif.
    endif.
    if wa_zm3-join_date le f9date.
      if date2 ge f9date.
        v9 = decsale.
      endif.
    endif.
    if wa_zm3-join_date le f10date.
      if date2 ge f10date.
        v10 = jansale.
      endif.
    endif.
    if wa_zm3-join_date le f11date.
      if date2 ge f11date.
        v11 = febsale.
      endif.
    endif.
    if wa_zm3-join_date le f12date.
      if date2 ge f12date.
        v12 = marsale.
      endif.
    endif.
    cysale = ( v1 + v2 + v3 + v4 + v5 + v6 + v7 + v8 + v9 + v10 + v11 + v12 ) / 1000.
**************************************************************
    wa_zm3-cysale = cysale.

************ CURRENT YEAR CUMMULATIVE***********
    if wa_zm1-cummt gt 0.
      ccumm = ( wa_zm1-cumms / wa_zm1-cummt ) * 100.
    endif.
    wa_zm3-ccumm = ccumm.

********************** CURRENT YEAR GROWTH ******************
*    IF WA_ZM1-LCUMMS GT 0.
*      CGRW = ( wa_ZM1-CUMMS / WA_ZM1-LCUMMS ) * 100 - 100.
*    ENDIF.
*    WA_ZM3-CGRW = CGRW.
***************CURRENT YEAR CUMMULATIVE GROWTH FROM ZRCUMPSO********
    if wa_zm1-lcummsr gt 0.
      cgrw = ( wa_zm1-cummsr / wa_zm1-lcummsr ) * 100 - 100.
    else.
      cgrw = 100.
    endif.
    wa_zm3-cgrw = cgrw.

***********************RM INCENTIVE********************************************
*    READ TABLE IT_INCT1 INTO WA_INCT1 WITH KEY PERNR = WA_ZM1-ZMPERNR.
*    IF SY-SUBRC EQ 0.
*      WA_ZM3-INCT = wa_inct1-betrg.
*    ENDIF.
**********CURRENT MONTH, LAST MONTH & LAST TO LAST MONTH PERFORMANCE******
    if wa_zm1-t1 gt 0.
      cp1 = ( wa_zm1-c1sale / wa_zm1-t1 ) * 100.
    endif.
    if wa_zm1-t2 gt 0.
      cp2 = ( wa_zm1-c2sale / wa_zm1-t2 ) * 100.
    endif.
    if wa_zm1-t3 gt 0.
      cp3 = ( wa_zm1-c3sale / wa_zm1-t3 ) * 100.
    endif.
    wa_zm3-cp1 = cp1.
    wa_zm3-cp2 = cp2.
    wa_zm3-cp3 = cp3.
    sl1 = wa_zm1-c1sale / 1000.
    sl2 = wa_zm1-c2sale / 1000.
    sl3 = wa_zm1-c3sale / 1000.
    wa_zm3-c1sale = sl1.
    wa_zm3-c2sale = sl2.
    wa_zm3-c3sale = sl3.
**************** INCREMENT**************
*    READ TABLE it_inc1 INTO wa_inc1 WITH KEY PERNR = WA_ZM1-ZMPERNR.
*    IF SY-SUBRC EQ 0.
*      WA_ZM3-INCR = wa_inc1-INCR.
*      WA_ZM3-INCREMENT_DT = wa_inc1-INCREMENT_DT.
*      if wa_inc1-INCREMENT_DT ne 0.
*        CONCATENATE wa_inc1-INCREMENT_DT+4(2) '/' wa_inc1-INCREMENT_DT+0(4) INTO INCRDT.
*        WA_ZM3-INCRDT = INCRDT.
*      endif.
*      WA_ZM3-CSAL = WA_INC1-CSAL.
*      WA_ZM3-INCR_DT = wa_inc1-incr_dt.
*    ENDIF.
**********************************************************
    select single * from zdrphq where bzirk eq wa_zm1-zm.
    if sy-subrc eq 0.
      select single * from  zthr_heq_des where zz_hqcode eq zdrphq-zz_hqcode.
      if sy-subrc eq 0.
        wa_zm3-zz_hqdesc =  zthr_heq_des-zz_hqdesc.
      endif.
    endif.
    select single * from pa0001 where pernr eq wa_zm1-dzmpernr and endda ge date2.
    if sy-subrc eq 0.
      wa_zm3-ename = pa0001-ename.
      select single * from zfsdes where persk eq pa0001-persk.
      if sy-subrc eq 0.
*        wa_ZM3-short = zfsdes-short.
        wa_zm3-short = 'DZM'.
      endif.
    else.
      wa_zm3-ename = 'VACANT (Since)'.
      wa_zm3-short = 'ZM'.
    endif.


    read table it_tab5 into wa_tab5 with key reg = wa_zm1-reg zm = wa_zm1-zm div = 'BCL'.
    if sy-subrc eq 0.
      div = 'BCL'.
    else.
      read table it_tab5 into wa_tab5 with key reg = wa_zm1-reg zm = wa_zm1-zm div = 'BC'.
      if sy-subrc eq 0.
        read table it_tab5 into wa_tab5 with key reg = wa_zm1-reg zm = wa_zm1-zm div = 'XL'.
        if sy-subrc eq 0.
          div = 'BCL'.
        else.
          div = 'BC'.
        endif.
      else.
        read table it_tab5 into wa_tab5 with key reg = wa_zm1-reg zm = wa_zm1-zm div = 'LS'.
        if sy-subrc = 0.
          div = 'LS'.
        else.
          div = 'XL'.
        endif.
      endif.
    endif.
    wa_zm3-div = div.
*    select single * from zoneseq where zone_dist eq wa_ZM1-reg.
*    if sy-subrc eq 0.
*      wa_ZM3-seq = zoneseq-seq.
*    endif.
    read table it_pa0000_dzm into wa_pa0000_dzm with key pernr = wa_zm1-dzmpernr. "ZM PROMOTION
    if sy-subrc eq 0.
      concatenate wa_pa0000_dzm-begda+4(2) '/' wa_pa0000_dzm-begda+0(4) into prom.
      wa_zm3-prom = prom.
*      WA_ZM3-PROM1 = 'L-PROM'.
    endif.

***********************************************************
    collect wa_zm3 into it_zm3.
    clear wa_zm3.
  endloop.




  loop at it_zm3 into wa_zm3 .

    clear : sl2,sl3,cp3,cp2,cum1,cum2,ccumm, cums, lcums, cgrw.

    clear : cp2,cp3, cums,lcums,cgrw,cum1,cum2,ccumm.
    clear : lpqrt1,ls1,lt1, lpqrt2,ls2,lt2, lpqrt3,ls3,lt3, lpqrt4,ls4,lt4.
    clear : lls1,lls2,lls3,lls4.
    clear : lycs,lyct,lcumm, csl1,cst1,cpqrt1, csl2,cst2,cpqrt2, csl3,cst3,cpqrt3, csl4,cst4,cpqrt4.
    clear : c1,c2,c3,c4, c5.
    clear : lsale,llsale, lgrw, l1.


    wa_zm2-reg = wa_zm3-reg.
    wa_zm2-zm = wa_zm3-zm.
    wa_zm2-zmpernr = wa_zm3-zmpernr.
    wa_zm2-dzmpernr = wa_zm3-dzmpernr.
**************** LAST YEAR SALE PERFORMANVE ***********
*    wa_zm2-lpqrt1 = wa_zm3-lpqrt1.
*    wa_zm2-lpqrt2 = wa_zm3-lpqrt2.
*    wa_zm2-lpqrt3 = wa_zm3-lpqrt3.
*    wa_zm2-lpqrt4 = wa_zm3-lpqrt4.
*******************lpqrt1-4**************************
    read table it_zll1dums into wa_zll1dums with key bzirk = wa_zm3-zm.
    if sy-subrc eq 0.
      read table it_lzm11 into wa_lzm11 with key zm = wa_zm3-zm.
      if sy-subrc eq 0.
        if wa_zll1dums-aprsale eq 0.
          wa_zll1dums-aprsale = wa_lzm11-m1.
        endif.
        if wa_zll1dums-maysale eq 0.
          wa_zll1dums-maysale = wa_lzm11-m2.
        endif.
        if wa_zll1dums-junsale eq 0.
          wa_zll1dums-junsale = wa_lzm11-m3.
        endif.
        if wa_zll1dums-julsale eq 0.
          wa_zll1dums-julsale = wa_lzm11-m4.
        endif.
        if wa_zll1dums-augsale eq 0.
          wa_zll1dums-augsale = wa_lzm11-m5.
        endif.
        if wa_zll1dums-sepsale eq 0.
          wa_zll1dums-sepsale = wa_lzm11-m6.
        endif.
        if wa_zll1dums-octsale eq 0.
          wa_zll1dums-octsale = wa_lzm11-m7.
        endif.
        if wa_zll1dums-novsale eq 0.
          wa_zll1dums-novsale = wa_lzm11-m8.
        endif.
        if wa_zll1dums-decsale eq 0.
          wa_zll1dums-decsale = wa_lzm11-m9.
        endif.
        if wa_zll1dums-jansale eq 0.
          wa_zll1dums-jansale = wa_lzm11-m10.
        endif.
        if wa_zll1dums-febsale eq 0.
          wa_zll1dums-febsale = wa_lzm11-m11.
        endif.
        if wa_zll1dums-marsale eq 0.
          wa_zll1dums-marsale = wa_lzm11-m12.
        endif.
      endif.
    else.

      read table it_lzm11 into wa_lzm11 with key zm = wa_zm3-zm.
      if sy-subrc eq 0.
        wa_zll1dums-aprsale = wa_lzm11-m1.
        wa_zll1dums-maysale = wa_lzm11-m2.
        wa_zll1dums-junsale = wa_lzm11-m3.
        wa_zll1dums-julsale = wa_lzm11-m4.
        wa_zll1dums-augsale = wa_lzm11-m5.
        wa_zll1dums-sepsale = wa_lzm11-m6.
        wa_zll1dums-octsale = wa_lzm11-m7.
        wa_zll1dums-novsale = wa_lzm11-m8.
        wa_zll1dums-decsale = wa_lzm11-m9.
        wa_zll1dums-jansale = wa_lzm11-m10.
        wa_zll1dums-febsale = wa_lzm11-m11.
        wa_zll1dums-marsale = wa_lzm11-m12.
      endif.
    endif.

*    ENDIF.
    lycs = wa_zll1dums-aprsale + wa_zll1dums-maysale + wa_zll1dums-junsale + wa_zll1dums-julsale + wa_zll1dums-augsale + wa_zll1dums-sepsale +
           wa_zll1dums-octsale + wa_zll1dums-novsale + wa_zll1dums-decsale + wa_zll1dums-jansale + wa_zll1dums-febsale + wa_zll1dums-marsale.

    lsale = wa_zll1dums-aprsale + wa_zll1dums-maysale + wa_zll1dums-junsale + wa_zll1dums-julsale + wa_zll1dums-augsale + wa_zll1dums-sepsale +
           wa_zll1dums-octsale + wa_zll1dums-novsale + wa_zll1dums-decsale + wa_zll1dums-jansale + wa_zll1dums-febsale + wa_zll1dums-marsale.

    ls1 = ( wa_zll1dums-aprsale + wa_zll1dums-maysale + wa_zll1dums-junsale ) / 1000.
    wa_zm2-lysale1 = ls1.
    ls2 = ( wa_zll1dums-julsale + wa_zll1dums-augsale + wa_zll1dums-sepsale ) / 1000.
    wa_zm2-lysale2 = ls2.
    ls3 = ( wa_zll1dums-octsale + wa_zll1dums-novsale + wa_zll1dums-decsale ) / 1000.
    wa_zm2-lysale3 = ls3.
    ls4 = ( wa_zll1dums-jansale + wa_zll1dums-febsale + wa_zll1dums-marsale ) / 1000.
    wa_zm2-lysale4 = ls4.
    wa_zm2-lysale = wa_zm2-lysale1 + wa_zm2-lysale2 + wa_zm2-lysale3 + wa_zm2-lysale4.


    read table it_zll1tdums into wa_zll1tdums with key bzirk = wa_zm3-zm.
    if sy-subrc eq 0.
      read table it_lzmt1 into wa_lzmt1 with key zm = wa_zm3-zm.
      if sy-subrc eq 0.
        if wa_zll1tdums-aprsale eq 0.
          wa_zll1tdums-aprsale = wa_lzmt1-t1.
        endif.
        if wa_zll1tdums-maysale eq 0.
          wa_zll1tdums-maysale = wa_lzmt1-t2.
        endif.
        if wa_zll1tdums-junsale eq 0.
          wa_zll1tdums-junsale = wa_lzmt1-t3.
        endif.
        if wa_zll1tdums-julsale eq 0.
          wa_zll1tdums-julsale = wa_lzmt1-t4.
        endif.
        if wa_zll1tdums-augsale eq 0.
          wa_zll1tdums-augsale = wa_lzmt1-t5.
        endif.
        if wa_zll1tdums-sepsale eq 0.
          wa_zll1tdums-sepsale = wa_lzmt1-t6.
        endif.
        if wa_zll1tdums-octsale eq 0.
          wa_zll1tdums-octsale = wa_lzmt1-t7.
        endif.
        if wa_zll1tdums-novsale eq 0.
          wa_zll1tdums-novsale = wa_lzmt1-t8.
        endif.
        if wa_zll1tdums-decsale eq 0.
          wa_zll1tdums-decsale = wa_lzmt1-t9.
        endif.
        if wa_zll1tdums-jansale eq 0.
          wa_zll1tdums-jansale = wa_lzmt1-t10.
        endif.
        if wa_zll1tdums-febsale eq 0.
          wa_zll1tdums-febsale = wa_lzmt1-t11.
        endif.
        if wa_zll1tdums-marsale eq 0.
          wa_zll1tdums-marsale = wa_lzmt1-t12.
        endif.
      endif.
    else.

      read table it_lzmt1 into wa_lzmt1 with key zm = wa_zm3-zm.
      if sy-subrc eq 0.
        wa_zll1tdums-aprsale = wa_lzmt1-t1.
        wa_zll1tdums-maysale = wa_lzmt1-t2.
        wa_zll1tdums-junsale = wa_lzmt1-t3.
        wa_zll1tdums-julsale = wa_lzmt1-t4.
        wa_zll1tdums-augsale = wa_lzmt1-t5.
        wa_zll1tdums-sepsale = wa_lzmt1-t6.
        wa_zll1tdums-octsale = wa_lzmt1-t7.
        wa_zll1tdums-novsale = wa_lzmt1-t8.
        wa_zll1tdums-decsale = wa_lzmt1-t9.
        wa_zll1tdums-jansale = wa_lzmt1-t10.
        wa_zll1tdums-febsale = wa_lzmt1-t11.
        wa_zll1tdums-marsale = wa_lzmt1-t12.
      endif.
    endif.
    lyct = wa_zll1tdums-aprsale + wa_zll1tdums-maysale + wa_zll1tdums-junsale + wa_zll1tdums-julsale + wa_zll1tdums-augsale + wa_zll1tdums-sepsale +
           wa_zll1tdums-octsale + wa_zll1tdums-novsale + wa_zll1tdums-decsale + wa_zll1tdums-jansale + wa_zll1tdums-febsale + wa_zll1tdums-marsale.

    lt1 = ( wa_zll1tdums-aprsale + wa_zll1tdums-maysale + wa_zll1tdums-junsale ) / 1000.
    lt2 = ( wa_zll1tdums-julsale + wa_zll1tdums-augsale + wa_zll1tdums-sepsale ) / 1000.
    lt3 = ( wa_zll1tdums-octsale + wa_zll1tdums-novsale + wa_zll1tdums-decsale ) / 1000.
    lt4 = ( wa_zll1tdums-jansale + wa_zll1tdums-febsale + wa_zll1tdums-marsale ) / 1000.


    if lt1 gt 0.
      lpqrt1 = ( ls1 / lt1 ) * 100.
    endif.
    wa_zm2-lpqrt1 = lpqrt1.
    if lt2 gt 0.
      lpqrt2 = ( ls2 / lt2 ) * 100.
    endif.
    wa_zm2-lpqrt2 = lpqrt2.
    if lt3 gt 0.
      lpqrt3 = ( ls3 / lt3 ) * 100.
    endif.
    wa_zm2-lpqrt3 = lpqrt3.
    if lt4 gt 0.
      lpqrt4 = ( ls4 / lt4 ) * 100.
    endif.
    wa_zm2-lpqrt4 = lpqrt4.

    if lyct gt 0.
      lcumm = ( lycs / lyct ) * 100.
    endif.
    wa_zm2-lcumm = lcumm.

*****************************************************

*    wa_zm2-lysale1 = wa_zm3-lysale1.
*    wa_zm2-lysale2 = wa_zm3-lysale2.
*    wa_zm2-lysale3 = wa_zm3-lysale3.
*    wa_zm2-lysale4 = wa_zm3-lysale4.
*    wa_zm2-lysale = wa_zm3-lysale.


*    wa_zm2-lysalec1 = wa_zm3-lysalec1.
*    wa_zm2-lysalec2 = wa_zm3-lysalec2.
*    wa_zm2-lysalec3 = wa_zm3-lysalec3.
*    wa_zm2-lysalec4 = wa_zm3-lysalec4.
*    wa_zm2-lysalec = wa_zm3-lysalec.
*************************
    read table it_zl1dums into wa_zl1dums with key bzirk = wa_zm3-zm.
    if sy-subrc eq 0.
      read table it_zdlapr into wa_zdlapr with key bzirk = wa_zm3-zm.
      if sy-subrc eq 0.
*        IF DATE2 LT F1DATE.
*          WA_ZL1DUMS-APRSALE = WA_ZDLAPR-APRSALE.
*        ENDIF.
*        IF DATE2 LT F2DATE.
*          WA_ZL1DUMS-MAYSALE = WA_ZDLAPR-MAYSALE.
*        ENDIF.
*        IF DATE2 LT F3DATE.
*          WA_ZL1DUMS-JUNSALE = WA_ZDLAPR-JUNSALE.
*        ENDIF.
*        IF DATE2 LT F4DATE.
*          WA_ZL1DUMS-JULSALE = WA_ZDLAPR-JULSALE.
*        ENDIF.
*        IF DATE2 LT F5DATE.
*          WA_ZL1DUMS-AUGSALE = WA_ZDLAPR-AUGSALE.
*        ENDIF.
*        IF DATE2 LT F6DATE.
*          WA_ZL1DUMS-SEPSALE = WA_ZDLAPR-SEPSALE.
*        ENDIF.
*        IF DATE2 LT F7DATE.
*          WA_ZL1DUMS-OCTSALE = WA_ZDLAPR-OCTSALE.
*        ENDIF.
*        IF DATE2 LT F8DATE.
*          WA_ZL1DUMS-NOVSALE = WA_ZDLAPR-NOVSALE.
*        ENDIF.
*        IF DATE2 LT F9DATE.
*          WA_ZL1DUMS-DECSALE = WA_ZDLAPR-DECSALE.
*        ENDIF.
*        IF DATE2 LT F10DATE.
*          WA_ZL1DUMS-JANSALE = WA_ZDLAPR-JANSALE.
*        ENDIF.
*        IF DATE2 LT F11DATE.
*          WA_ZL1DUMS-FEBSALE = WA_ZDLAPR-FEBSALE.
*        ENDIF.
*        IF DATE2 LT F12DATE.
*          WA_ZL1DUMS-MARSALE = WA_ZDLAPR-MARSALE.
*        ENDIF.

        read table it_z1l1aprcs1 into wa_z1l1aprcs1 with key bzirk = wa_zm3-zm.
        if sy-subrc eq 0.
          wa_zl1dums-aprsale = wa_z1l1aprcs1-aprsale.
          wa_zl1dums-maysale = wa_z1l1aprcs1-maysale.
          wa_zl1dums-junsale = wa_z1l1aprcs1-junsale.
          wa_zl1dums-julsale = wa_z1l1aprcs1-julsale.
          wa_zl1dums-augsale = wa_z1l1aprcs1-augsale.
          wa_zl1dums-sepsale = wa_z1l1aprcs1-sepsale.
          wa_zl1dums-octsale = wa_z1l1aprcs1-octsale.
          wa_zl1dums-novsale = wa_z1l1aprcs1-novsale.
          wa_zl1dums-decsale = wa_z1l1aprcs1-decsale.
          wa_zl1dums-jansale = wa_z1l1aprcs1-jansale.
          wa_zl1dums-febsale = wa_z1l1aprcs1-febsale.
          wa_zl1dums-marsale = wa_z1l1aprcs1-marsale.
        endif.

        lls1 = ( wa_zl1dums-aprsale + wa_zl1dums-maysale + wa_zl1dums-junsale ) / 1000.
        wa_zm2-lysalec1 = lls1.
*        IF WA_ZM2-lysalec1 LE 0.
*          WA_ZM2-lysalec1 = wa_rm3-lysalec1.
*        ENDIF.
        lls2 = ( wa_zl1dums-julsale + wa_zl1dums-augsale + wa_zl1dums-sepsale ) / 1000.
        wa_zm2-lysalec2 = lls2.
        if wa_zm2-lysalec2 le 0.
          wa_zm2-lysalec2 = wa_rm3-lysalec2.
        endif.
        lls3 = ( wa_zl1dums-octsale + wa_zl1dums-novsale + wa_zl1dums-decsale ) / 1000.
        wa_zm2-lysalec3 = lls3.
        if wa_zm2-lysalec3 le 0.
          wa_zm2-lysalec3 = wa_rm3-lysalec3.
        endif.
        lls4 = ( wa_zl1dums-jansale + wa_zl1dums-febsale + wa_zl1dums-marsale ) / 1000.
        wa_zm2-lysalec4 = lls4.
        if wa_zm2-lysalec4 le 0.
          wa_zm2-lysalec4 = wa_rm3-lysalec4.
        endif.
        wa_zm2-lysalec = wa_zm2-lysalec1 + wa_zm2-lysalec2 + wa_zm2-lysalec3 + wa_zm2-lysalec4.
      endif.
    endif.

********************************
************ LAST YEAR CUMMULATIVE***********

    read table it_zyll1dums into wa_zyll1dums with key bzirk = wa_zm3-zm.
    if sy-subrc eq 0.
      read table it_llzm11 into wa_llzm11 with key bzirk = wa_zm3-zm.
      if sy-subrc eq 0.
        if wa_zyll1dums-aprsale eq 0.
          wa_zyll1dums-aprsale = wa_llzm11-m1.
        endif.
        if wa_zyll1dums-maysale eq 0.
          wa_zyll1dums-maysale = wa_llzm11-m2.
        endif.
        if wa_zyll1dums-junsale eq 0.
          wa_zyll1dums-junsale = wa_llzm11-m3.
        endif.
        if wa_zyll1dums-julsale eq 0.
          wa_zyll1dums-julsale = wa_llzm11-m4.
        endif.
        if wa_zyll1dums-augsale eq 0.
          wa_zyll1dums-augsale = wa_llzm11-m5.
        endif.
        if wa_zyll1dums-sepsale eq 0.
          wa_zyll1dums-sepsale = wa_llzm11-m6.
        endif.
        if wa_zyll1dums-octsale eq 0.
          wa_zyll1dums-octsale = wa_llzm11-m7.
        endif.
        if wa_zyll1dums-novsale eq 0.
          wa_zyll1dums-novsale = wa_llzm11-m8.
        endif.
        if wa_zyll1dums-decsale eq 0.
          wa_zyll1dums-decsale = wa_llzm11-m9.
        endif.
        if wa_zyll1dums-jansale eq 0.
          wa_zyll1dums-jansale = wa_llzm11-m10.
        endif.
        if wa_zyll1dums-febsale eq 0.
          wa_zyll1dums-febsale = wa_llzm11-m11.
        endif.
        if wa_zyll1dums-marsale eq 0.
          wa_zyll1dums-marsale = wa_llzm11-m12.
        endif.
      endif.
    else.
      read table it_llzm11 into wa_llzm11 with key zm = wa_zm3-zm.
      if sy-subrc eq 0.
        wa_zyll1dums-aprsale = wa_llzm11-m1.
        wa_zyll1dums-maysale = wa_llzm11-m2.
        wa_zyll1dums-junsale = wa_llzm11-m3.
        wa_zyll1dums-julsale = wa_llzm11-m4.
        wa_zyll1dums-augsale = wa_llzm11-m5.
        wa_zyll1dums-sepsale = wa_llzm11-m6.
        wa_zyll1dums-octsale = wa_llzm11-m7.
        wa_zyll1dums-novsale = wa_llzm11-m8.
        wa_zyll1dums-decsale = wa_llzm11-m9.
        wa_zyll1dums-jansale = wa_llzm11-m10.
        wa_zyll1dums-febsale = wa_llzm11-m11.
        wa_zyll1dums-marsale = wa_llzm11-m12.
      endif.
    endif.
    llsale = wa_zyll1dums-aprsale + wa_zyll1dums-maysale + wa_zyll1dums-junsale + wa_zyll1dums-julsale + wa_zyll1dums-augsale + wa_zyll1dums-sepsale
    + wa_zyll1dums-octsale + wa_zyll1dums-novsale + wa_zyll1dums-decsale + wa_zyll1dums-jansale + wa_zyll1dums-febsale + wa_zyll1dums-marsale.

    if llsale gt 0.
      lgrw =  ( lsale / llsale ) * 100 - 100 .
    endif.
    wa_zm2-lgrw = lgrw.

*    wa_zm2-lcumm = wa_zm3-lcumm.
********************** LAST YEAR GROWTH ******************
*    wa_zm2-lgrw = wa_zm3-lgrw.
************* CURRENT MONTH TARGET************
    wa_zm2-ctar = wa_zm3-ctar .
**************** CURRENT YEAR SALE PERFORMANVE ***********
*    wa_zm2-cpqrt1 = wa_zm3-cpqrt1.

    read table it_zdcums into wa_zdcums with key bzirk = wa_zm3-zm.
    if sy-subrc eq 0.
      read table it_zm11 into wa_zm11 with key zm = wa_zm3-zm.
      if sy-subrc eq 0.
        if wa_zdcums-aprsale eq 0.
          wa_zdcums-aprsale = wa_zm11-m1.
        endif.
        if wa_zdcums-maysale eq 0.
          wa_zdcums-maysale = wa_zm11-m2.
        endif.
        if wa_zdcums-junsale eq 0.
          wa_zdcums-junsale = wa_zm11-m3.
        endif.
      endif.
    else.
      read table it_zm11 into wa_zm11 with key zm = wa_zm3-zm.
      if sy-subrc eq 0.
        wa_zdcums-aprsale = wa_zm11-m1.
        wa_zdcums-maysale = wa_zm11-m2.
        wa_zdcums-junsale = wa_zm11-m3.
      endif.
    endif.
    csl1 = wa_zdcums-aprsale + wa_zdcums-maysale + wa_zdcums-junsale.
    if date2 ge f3date.
      c1 = csl1 / 1000.
    endif.
    wa_zm2-cysale1 = c1.
    read table it_ztdums into wa_ztdums with key bzirk = wa_zm3-zm.
    if sy-subrc eq 0.
      read table it_zmt1 into wa_zmt1 with key zm = wa_zm3-zm.
      if sy-subrc eq 0.
        if wa_ztdums-aprsale eq 0.
          wa_ztdums-aprsale = wa_zmt1-t1.
        endif.
        if wa_ztdums-maysale eq 0.
          wa_ztdums-maysale = wa_zmt1-t2.
        endif.
        if wa_ztdums-junsale eq 0.
          wa_ztdums-junsale = wa_zmt1-t3.
        endif.
      endif.
    else.
      read table it_zmt1 into wa_zmt1 with key zm = wa_zm3-zm.
      if sy-subrc eq 0.
        wa_ztdums-aprsale = wa_zmt1-t1.
        wa_ztdums-maysale = wa_zmt1-t2.
        wa_ztdums-junsale = wa_zmt1-t3.
      endif.
    endif.
    cst1 = wa_ztdums-aprsale + wa_ztdums-maysale + wa_ztdums-junsale.

    cpqrt1 = ( csl1 / cst1 ) * 100.
    if date2 ge f3date.
      wa_zm2-cpqrt1 = cpqrt1.
      if  wa_zm2-cpqrt1 eq 0.
        wa_zm2-cpqrt1 =  wa_rm3-cpqrt1.
      endif.
    endif.

***************************************************
*    wa_zm2-cpqrt2 = wa_zm3-cpqrt2.

    read table it_zdcums into wa_zdcums with key bzirk = wa_zm3-zm.
    if sy-subrc eq 0.
      read table it_zm11 into wa_zm11 with key zm = wa_zm3-zm.
      if sy-subrc eq 0.
        if wa_zdcums-julsale eq 0.
          wa_zdcums-julsale = wa_zm11-m4.
        endif.
        if wa_zdcums-augsale eq 0.
          wa_zdcums-augsale = wa_zm11-m5.
        endif.
        if wa_zdcums-sepsale eq 0.
          wa_zdcums-sepsale = wa_zm11-m6.
        endif.
      endif.
    else.
      read table it_zm11 into wa_zm11 with key zm = wa_zm3-zm.
      if sy-subrc eq 0.
        wa_zdcums-julsale = wa_zm11-m4.
        wa_zdcums-augsale = wa_zm11-m5.
        wa_zdcums-sepsale = wa_zm11-m6.
      endif.
    endif.
    csl2 = wa_zdcums-julsale + wa_zdcums-augsale + wa_zdcums-sepsale.
    if date2 ge f6date.
      c2 = csl2 / 1000.
    endif.
    wa_zm2-cysale2 = c2.


    read table it_ztdums into wa_ztdums with key bzirk = wa_zm3-zm.
    if sy-subrc eq 0.
      read table it_zmt1 into wa_zmt1 with key zm = wa_zm3-zm.
      if sy-subrc eq 0.
        if wa_ztdums-julsale eq 0.
          wa_ztdums-julsale = wa_zmt1-t4.
        endif.
        if wa_ztdums-augsale eq 0.
          wa_ztdums-augsale = wa_zmt1-t5.
        endif.
        if wa_ztdums-sepsale eq 0.
          wa_ztdums-sepsale = wa_zmt1-t6.
        endif.
      endif.
    else.
      read table it_zmt1 into wa_zmt1 with key zm = wa_zm3-zm.
      if sy-subrc eq 0.
        wa_ztdums-julsale = wa_zmt1-t4.
        wa_ztdums-augsale = wa_zmt1-t5.
        wa_ztdums-sepsale = wa_zmt1-t6.
      endif.
    endif.
    cst2 = wa_ztdums-julsale + wa_ztdums-augsale + wa_ztdums-sepsale.

    cpqrt2 = ( csl2 / cst2 ) * 100.
    if date2 ge f6date.
      wa_zm2-cpqrt2 = cpqrt2.
      if  wa_zm2-cpqrt2 eq 0.
        wa_zm2-cpqrt2 =  wa_zm3-cpqrt2.
      endif.
    endif.

***********************************************
*    wa_zm2-cpqrt3 = wa_zm3-cpqrt3.


    read table it_zdcums into wa_zdcums with key bzirk = wa_zm3-zm.
    if sy-subrc eq 0.
      read table it_zm11 into wa_zm11 with key zm = wa_zm3-zm.
      if sy-subrc eq 0.
        if wa_zdcums-octsale eq 0.
          wa_zdcums-octsale = wa_zm11-m7.
        endif.
        if wa_zdcums-novsale eq 0.
          wa_zdcums-novsale = wa_zm11-m8.
        endif.
        if wa_zdcums-decsale eq 0.
          wa_zdcums-decsale = wa_zm11-m9.
        endif.
      endif.
    else.
      read table it_zm11 into wa_zm11 with key zm = wa_zm3-zm.
      if sy-subrc eq 0.
        wa_zdcums-octsale = wa_zm11-m7.
        wa_zdcums-novsale = wa_zm11-m8.
        wa_zdcums-decsale = wa_zm11-m9.
      endif.
    endif.
    csl3 = wa_zdcums-octsale + wa_zdcums-novsale + wa_zdcums-decsale.
    if date2 ge f9date.
      c3 = csl3 / 1000.
    endif.
    wa_zm2-cysale3 = c3.
    read table it_ztdums into wa_ztdums with key bzirk = wa_zm3-zm.
    if sy-subrc eq 0.
      read table it_zmt1 into wa_zmt1 with key zm = wa_zm3-zm.
      if sy-subrc eq 0.
        if wa_ztdums-octsale eq 0.
          wa_ztdums-octsale = wa_zmt1-t7.
        endif.
        if wa_ztdums-novsale eq 0.
          wa_ztdums-novsale = wa_zmt1-t8.
        endif.
        if wa_ztdums-decsale eq 0.
          wa_ztdums-decsale = wa_zmt1-t9.
        endif.
      endif.
    else.
      read table it_zmt1 into wa_zmt1 with key zm = wa_zm2-zm.
      if sy-subrc eq 0.
        wa_ztdums-octsale = wa_zmt1-t7.
        wa_ztdums-novsale = wa_zmt1-t8.
        wa_ztdums-decsale = wa_zmt1-t9.
      endif.
    endif.
    cst3 = wa_ztdums-octsale + wa_ztdums-novsale + wa_ztdums-decsale.

    cpqrt3 = ( csl3 / cst3 ) * 100.
    if date2 ge f9date.
      wa_zm2-cpqrt3 = cpqrt3.
      if  wa_zm2-cpqrt3 eq 0.
        wa_zm2-cpqrt3 =  wa_rm3-cpqrt3.
      endif.
    endif.

**********************************************
*    wa_zm2-cpqrt4 = wa_zm3-cpqrt4.

    read table it_zdcums into wa_zdcums with key bzirk = wa_zm3-zm.
    if sy-subrc eq 0.
      read table it_zm11 into wa_zm11 with key zm = wa_zm3-zm.
      if sy-subrc eq 0.
        if wa_zdcums-jansale eq 0.
          wa_zdcums-jansale = wa_zm11-m10.
        endif.
        if wa_zdcums-febsale eq 0.
          wa_zdcums-febsale = wa_zm11-m11.
        endif.
        if wa_zdcums-marsale eq 0.
          wa_zdcums-marsale = wa_zm11-m12.
        endif.
      endif.
    else.
      read table it_zm11 into wa_zm11 with key zm = wa_zm3-zm.
      if sy-subrc eq 0.
        wa_zdcums-jansale = wa_zm11-m10.
        wa_zdcums-febsale = wa_zm11-m11.
        wa_zdcums-marsale = wa_zm11-m12.
      endif.
    endif.
    csl4 = wa_zdcums-jansale + wa_zdcums-febsale + wa_zdcums-marsale.
    if date2 ge f12date.
      c4 = csl4 / 1000.
    endif.
    wa_zm2-cysale4 = c4.


    read table it_ztdums into wa_ztdums with key bzirk = wa_zm3-zm.
    if sy-subrc eq 0.
      read table it_zmt1 into wa_zmt1 with key zm = wa_zm3-zm.
      if sy-subrc eq 0.
        if wa_ztdums-jansale eq 0.
          wa_ztdums-jansale = wa_zmt1-t10.
        endif.
        if wa_ztdums-febsale eq 0.
          wa_ztdums-febsale = wa_zmt1-t11.
        endif.
        if wa_ztdums-marsale eq 0.
          wa_ztdums-marsale = wa_zmt1-t12.
        endif.
      endif.
    else.
      read table it_zmt1 into wa_zmt1 with key zm = wa_zm3-zm.
      if sy-subrc eq 0.
        wa_ztdums-jansale = wa_zmt1-t10.
        wa_ztdums-febsale = wa_zmt1-t11.
        wa_ztdums-marsale = wa_zmt1-t12.
      endif.
    endif.
    cst4 = wa_ztdums-jansale + wa_ztdums-febsale + wa_ztdums-marsale.

    cpqrt4 = ( csl4 / cst4 ) * 100.
    if date2 ge f12date.
      wa_zm2-cpqrt4 = cpqrt4.
      if  wa_zm2-cpqrt4 eq 0.
        wa_zm2-cpqrt4 =  wa_rm3-cpqrt4.
      endif.
    endif.
*******************************

*    wa_zm2-cysale1 = wa_zm3-cysale1.
*    wa_zm2-cysale2 = wa_zm3-cysale2.
*    wa_zm2-cysale3 = wa_zm3-cysale3.
*    wa_zm2-cysale4 = wa_zm3-cysale4.
*    wa_zm2-cysale = wa_zm3-cysale.

************ CURRENT YEAR CUMMULATIVE***********
*    wa_zm2-ccumm = wa_zm3-ccumm.

    read table it_zzcums into wa_zzcums with key bzirk = wa_zm3-zm.
    if sy-subrc eq 0.
      read table it_zm11 into wa_zm11 with key zm = wa_zm3-zm.
      if sy-subrc eq 0.
        if wa_zzcums-aprsale eq 0.
          wa_zzcums-aprsale = wa_zm11-m1.
        endif.
        if wa_zzcums-maysale eq 0.
          wa_zzcums-maysale = wa_zm11-m2.
        endif.
        if wa_zzcums-junsale eq 0.
          wa_zzcums-junsale = wa_zm11-m3.
        endif.
        if wa_zzcums-julsale eq 0.
          wa_zzcums-julsale = wa_zm11-m4.
        endif.
        if wa_zzcums-augsale eq 0.
          wa_zzcums-augsale = wa_zm11-m5.
        endif.
        if wa_zzcums-sepsale eq 0.
          wa_zzcums-sepsale = wa_zm11-m6.
        endif.
        if wa_zzcums-octsale eq 0.
          wa_zzcums-octsale = wa_zm11-m7.
        endif.
        if wa_zzcums-novsale eq 0.
          wa_zzcums-novsale = wa_zm11-m8.
        endif.
        if wa_zzcums-decsale eq 0.
          wa_zzcums-decsale = wa_zm11-m9.
        endif.
        if wa_zzcums-jansale eq 0.
          wa_zzcums-jansale = wa_zm11-m10.
        endif.
        if wa_zzcums-febsale eq 0.
          wa_zzcums-febsale = wa_zm11-m11.
        endif.
        if wa_zzcums-marsale eq 0.
          wa_zzcums-marsale = wa_zm11-m12.
        endif.
      endif.
    else.

      read table it_zm11 into wa_zm11 with key zm = wa_zm3-zm.
      if sy-subrc eq 0.
        wa_zzcums-aprsale = wa_zm11-m1.
        wa_zzcums-maysale = wa_zm11-m2.
        wa_zzcums-junsale = wa_zm11-m3.
        wa_zzcums-julsale = wa_zm11-m4.
        wa_zzcums-augsale = wa_zm11-m5.
        wa_zzcums-sepsale = wa_zm11-m6.
        wa_zzcums-octsale = wa_zm11-m7.
        wa_zzcums-novsale = wa_zm11-m8.
        wa_zzcums-decsale = wa_zm11-m9.
        wa_zzcums-jansale = wa_zm11-m10.
        wa_zzcums-febsale = wa_zm11-m11.
        wa_zzcums-marsale = wa_zm11-m12.
      endif.
    endif.

    cum1 = wa_zzcums-aprsale + wa_zzcums-maysale + wa_zzcums-junsale + wa_zzcums-julsale + wa_zzcums-augsale + wa_zzcums-sepsale
            + wa_zzcums-octsale + wa_zzcums-novsale + wa_zzcums-decsale + wa_zzcums-jansale + wa_zzcums-febsale + wa_zzcums-marsale.

    read table it_zztcums into wa_zztcums with key bzirk = wa_zm3-zm.
    if sy-subrc eq 0.
      read table it_zmt1 into wa_zmt1 with key zm = wa_zm3-zm.
      if sy-subrc eq 0.
        if wa_zztcums-aprsale eq 0.
          wa_zztcums-aprsale = wa_zmt1-t1.
        endif.
        if wa_zztcums-maysale eq 0.
          wa_zztcums-maysale = wa_zmt1-t2.
        endif.
        if wa_zztcums-junsale eq 0.
          wa_zztcums-junsale = wa_zmt1-t3.
        endif.
        if wa_zztcums-julsale eq 0.
          wa_zztcums-julsale = wa_zmt1-t4.
        endif.
        if wa_zztcums-augsale eq 0.
          wa_zztcums-augsale = wa_zmt1-t5.
        endif.
        if wa_zztcums-sepsale eq 0.
          wa_zztcums-sepsale = wa_zmt1-t6.
        endif.
        if wa_zztcums-octsale eq 0.
          wa_zztcums-octsale = wa_zmt1-t7.
        endif.
        if wa_zztcums-novsale eq 0.
          wa_zztcums-novsale = wa_zmt1-t8.
        endif.
        if wa_zztcums-decsale eq 0.
          wa_zztcums-decsale = wa_zmt1-t9.
        endif.
        if wa_zztcums-jansale eq 0.
          wa_zztcums-jansale = wa_zmt1-t10.
        endif.
        if wa_zztcums-febsale eq 0.
          wa_zztcums-febsale = wa_zmt1-t11.
        endif.
        if wa_zztcums-marsale eq 0.
          wa_zztcums-marsale = wa_zmt1-t12.
        endif.
      endif.
    else.
      read table it_zmt1 into wa_zmt1 with key zm = wa_zm3-zm.
      if sy-subrc eq 0.
        wa_zztcums-aprsale = wa_zmt1-t1.
        wa_zztcums-maysale = wa_zmt1-t2.
        wa_zztcums-junsale = wa_zmt1-t3.
        wa_zztcums-julsale = wa_zmt1-t4.
        wa_zztcums-augsale = wa_zmt1-t5.
        wa_zztcums-sepsale = wa_zmt1-t6.
        wa_zztcums-octsale = wa_zmt1-t7.
        wa_zztcums-novsale = wa_zmt1-t8.
        wa_zztcums-decsale = wa_zmt1-t9.
        wa_zztcums-jansale = wa_zmt1-t10.
        wa_zztcums-febsale = wa_zmt1-t11.
        wa_zztcums-marsale = wa_zmt1-t12.
      endif.
    endif.
    cum2 = wa_zztcums-aprsale + wa_zztcums-maysale + wa_zztcums-junsale + wa_zztcums-julsale + wa_zztcums-augsale + wa_zztcums-sepsale +
    wa_zztcums-octsale + wa_zztcums-novsale + wa_zztcums-decsale + wa_zztcums-jansale + wa_zztcums-febsale + wa_zztcums-marsale.

    if cum2 gt 0.
      ccumm = ( cum1 / cum2 ) * 100.
    endif.
    wa_zm2-ccumm = ccumm.


********************** CURRENT YEAR GROWTH ******************
***************CURRENT YEAR CUMMULATIVE GROWTH FROM ZRCUMPSO********
*    wa_zm2-cgrw = wa_zm3-cgrw.

    read table it_zzcums into wa_rcums with key bzirk = wa_zm3-zm.
    if sy-subrc eq 0.
      read table it_zm11 into wa_zm11 with key zm = wa_zm3-zm..
      if sy-subrc eq 0.
        if wa_zzcums-aprsale eq 0.
          wa_zzcums-aprsale = wa_zm11-m1.
        endif.
        if wa_zzcums-maysale eq 0.
          wa_zzcums-maysale = wa_zm11-m2.
        endif.
        if wa_zzcums-junsale eq 0.
          wa_zzcums-junsale = wa_zm11-m3.
        endif.
        if wa_zzcums-julsale eq 0.
          wa_zzcums-julsale = wa_zm11-m4.
        endif.
        if wa_zzcums-augsale eq 0.
          wa_zzcums-augsale = wa_zm11-m5.
        endif.
        if wa_zzcums-sepsale eq 0.
          wa_zzcums-sepsale = wa_zm11-m6.
        endif.
        if wa_zzcums-octsale eq 0.
          wa_zzcums-octsale = wa_zm11-m7.
        endif.
        if wa_zzcums-novsale eq 0.
          wa_zzcums-novsale = wa_zm11-m8.
        endif.
        if wa_zzcums-decsale eq 0.
          wa_zzcums-decsale = wa_zm11-m9.
        endif.
        if wa_zzcums-jansale eq 0.
          wa_zzcums-jansale = wa_zm11-m10.
        endif.
        if wa_zzcums-febsale eq 0.
          wa_zzcums-febsale = wa_zm11-m11.
        endif.
        if wa_zzcums-marsale eq 0.
          wa_zzcums-marsale = wa_zm11-m12.
        endif.
      endif.
    else.
      read table it_zm11 into wa_zm11 with key zm = wa_zm3-zm..
      if sy-subrc eq 0.
        wa_zzcums-aprsale = wa_zm11-m1.
        wa_zzcums-maysale = wa_zm11-m2.
        wa_zzcums-junsale = wa_zm11-m3.
        wa_zzcums-julsale = wa_zm11-m4.
        wa_zzcums-augsale = wa_zm11-m5.
        wa_zzcums-sepsale = wa_zm11-m6.
        wa_zzcums-octsale = wa_zm11-m7.
        wa_zzcums-novsale = wa_zm11-m8.
        wa_zzcums-decsale = wa_zm11-m9.
        wa_zzcums-jansale = wa_zm11-m10.
        wa_zzcums-febsale = wa_zm11-m11.
        wa_zzcums-marsale = wa_zm11-m12.
      endif.
    endif.

    cums = wa_zzcums-aprsale + wa_zzcums-maysale + wa_zzcums-junsale + wa_zzcums-julsale + wa_zzcums-augsale + wa_zzcums-sepsale
            + wa_zzcums-octsale + wa_zzcums-novsale + wa_zzcums-decsale + wa_zzcums-jansale + wa_zzcums-febsale + wa_zzcums-marsale.
    c5 = cums / 1000.
    wa_zm2-cysale = c5.


    read table it_rrlcums into wa_rrlcums with key bzirk = wa_zm3-zm.
    if sy-subrc eq 0.
      read table it_lzm11 into wa_lzm11 with key zm = wa_zm3-zm..
      if sy-subrc eq 0.
*        F1DATE LE DATE2.
        if wa_rrlcums-aprsale eq 0.
          wa_rrlcums-aprsale = wa_lzm11-m1.
        endif.
*        ENDIF.
        if f2date le date2.
          if wa_rrlcums-maysale eq 0.
            wa_rrlcums-maysale = wa_lzm11-m2.
          endif.
        endif.
        if f3date le date2.
          if wa_rrlcums-junsale eq 0.
            wa_rrlcums-junsale = wa_lzm11-m3.
          endif.
        endif.
        if f4date le date2.
          if wa_rrlcums-julsale eq 0.
            wa_rrlcums-julsale = wa_lzm11-m4.
          endif.
        endif.
        if f5date le date2.
          if wa_rrlcums-augsale eq 0.
            wa_rrlcums-augsale = wa_lzm11-m5.
          endif.
        endif.
        if f6date le date2.
          if wa_rrlcums-sepsale eq 0.
            wa_rrlcums-sepsale = wa_lzm11-m6.
          endif.
        endif.
        if f7date le date2.
          if wa_rrlcums-octsale eq 0.
            wa_rrlcums-octsale = wa_lzm11-m7.
          endif.
        endif.
        if f8date le date2.
          if wa_rrlcums-novsale eq 0.
            wa_rrlcums-novsale = wa_lzm11-m8.
          endif.
        endif.
        if f9date le date2.
          if wa_rrlcums-decsale eq 0.
            wa_rrlcums-decsale = wa_lzm11-m9.
          endif.
        endif.
        if f10date le date2.
          if wa_rrlcums-jansale eq 0.
            wa_rrlcums-jansale = wa_lzm11-m10.
          endif.
        endif.
        if f11date le date2.
          if wa_rrlcums-febsale eq 0.
            wa_rrlcums-febsale = wa_lzm11-m11.
          endif.
        endif.
        if f12date le date2.
          if wa_rrlcums-marsale eq 0.
            wa_rrlcums-marsale = wa_lzm11-m12.
          endif.
        endif.
      endif.
    else.
      read table it_lzm11 into wa_lzm11 with key zm = wa_zm3-zm.
      if sy-subrc eq 0.
        if f1date le date2.
          wa_rrlcums-aprsale = wa_lzm11-m1.
        endif.
        if f2date le date2.
          wa_rrlcums-maysale = wa_lzm11-m2.
        endif.
        if f3date le date2.
          wa_rrlcums-junsale = wa_lzm11-m3.
        endif.
        if f4date le date2.
          wa_rrlcums-julsale = wa_lzm11-m4.
        endif.
        if f5date le date2.
          wa_rrlcums-augsale = wa_lzm11-m5.
        endif.
        if f6date le date2.
          wa_rrlcums-sepsale = wa_lzm11-m6.
        endif.
        if f7date le date2.
          wa_rrlcums-octsale = wa_lzm11-m7.
        endif.
        if f8date le date2.
          wa_rrlcums-novsale = wa_lzm11-m8.
        endif.
        if f9date le date2.
          wa_rrlcums-decsale = wa_lzm11-m9.
        endif.
        if f10date le date2.
          wa_rrlcums-jansale = wa_lzm11-m10.
        endif.
        if f11date le date2.
          wa_rrlcums-febsale = wa_lzm11-m11.
        endif.
        if f12date le date2.
          wa_rrlcums-marsale = wa_lzm11-m12.
        endif.
      endif.
    endif.
    lcums = wa_rrlcums-aprsale + wa_rrlcums-maysale + wa_rrlcums-junsale + wa_rrlcums-julsale + wa_rrlcums-augsale + wa_rrlcums-sepsale
            + wa_rrlcums-octsale + wa_rrlcums-novsale + wa_rrlcums-decsale + wa_rrlcums-jansale + wa_rrlcums-febsale + wa_rrlcums-marsale.

    cgrw = ( cums / lcums ) * 100 - 100.
    wa_zm2-cgrw = cgrw.

**********CURRENT MONTH, LAST MONTH & LAST TO LAST MONTH PERFORMANCE******
    wa_zm2-cp1 = wa_zm3-cp1.
*    wa_zm2-cp2 = wa_zm3-cp2.
*    wa_zm2-cp3 = wa_zm3-cp3.
    wa_zm2-c1sale = wa_zm3-c1sale.
*    wa_zm2-c2sale = wa_zm3-c2sale.
*    wa_zm2-c3sale = wa_zm3-c3sale.

    read table it_zlcs into wa_zlcs with key bzirk = wa_zm3-zm.
    if sy-subrc eq 0.
      sl3 = wa_zlcs-c3sale / 1000.
      wa_zm2-c3sale = sl3.
      cp3 = ( wa_zlcs-c3sale / wa_zlcs-t2 ) * 100.
      wa_zm2-cp3 = cp3.
*    ELSE.
*      READ TABLE IT_ZM11 INTO WA_ZM11 WITH KEY BZIRK = wa_zm3-zm.
*      IF SY-SUBRC EQ 0.
**        S13 =
*      ENDIF.
    endif.

    read table it_zl1cs into wa_zl1cs with key bzirk = wa_zm3-zm.
    if sy-subrc eq 0.
      sl2 = wa_zl1cs-c3sale / 1000.
      wa_zm2-c2sale = sl2.
      if wa_zl1cs-t2 gt 0.
        cp2 = ( wa_zl1cs-c3sale / wa_zl1cs-t2 ) * 100.
      endif.
      wa_zm2-cp2 = cp2.
    endif.
    if wa_zm2-cp3 le 0.
      wa_zm2-cp3 = wa_rm3-cp3.
    endif.
    if wa_zm2-cp2 le 0.
      wa_zm2-cp2 = wa_rm3-cp2.
    endif.
    if wa_zm2-c3sale le 0.
      wa_zm2-c3sale = wa_rm3-c3sale.
    endif.
    if wa_zm2-c2sale le 0.
      wa_zm2-c2sale = wa_rm3-c2sale.
    endif.

**********************************************************
    wa_zm2-zz_hqdesc =  wa_zm3-zz_hqdesc.
    wa_zm2-ename = wa_zm3-ename.
    wa_zm2-short = wa_zm3-short.
    wa_zm2-join_dt = wa_zm3-join_dt.
    wa_zm2-div = wa_zm3-div.
    wa_zm2-prom = wa_zm3-prom.

    select single * from ztotpso where begda = totpsodt and bzirk = wa_zm3-zm.
    if sy-subrc = 0.
      wa_zm2-noofpso = ( ztotpso-bc + ztotpso-bcl + ztotpso-xl ) - ztotpso-hbe.
    endif.

    collect wa_zm2 into it_zm2.
    clear wa_zm2.
  endloop.

endform.                    "zm

*&---------------------------------------------------------------------*
*&      Form  REG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form reg.
  loop at it_tab6 into wa_tab6.
    select single * from yterrallc where bzirk eq wa_tab6-bzirk and endda ge date2.
    if sy-subrc eq 0.
*    WRITE : / 'date2',date2.
      clear : t_sale,lyt,lls,lys,lgrw,qt1,qt2,qt3,qt4,t1,t2,t3,t4,q1,q2,q3,q4, lsqrt5,lsqrtc5,cqtr,lcummsr.
*    WRITE : / wa_TAB6-reg,wa_TAB6-rm,wa_TAB6-bzirk,wa_TAB6-plans,wa_TAB6-pernr,wa_TAB6-ename,wa_TAB6-zz_hqdesc,wa_TAB6-join_dt,wa_TAB6-div,WA_TAB6-TYP.
      wa_tab7-reg = wa_tab6-reg.
*      SELECT SINGLE * FROM ZDSMTER WHERE ZMONTH EQ MONTH AND ZYEAR EQ YEAR AND BZIRK EQ wa_tab6-reg.
*        IF SY-SUBRC EQ 0.
*          WA_TAB71-
      wa_tab71-reg = wa_tab6-reg.
      wa_tab7-rm = wa_tab6-rm.
      wa_tab7-zmpernr = wa_tab6-zmpernr.
      read table it_cs into wa_cs with key bzirk = wa_tab6-bzirk.  "current , last & last to last month sale.
      if sy-subrc eq 0.
        wa_tab7-c1sale = wa_cs-c1sale.
        wa_tab71-c1sale = wa_cs-c1sale.
        wa_tab7-c2sale = wa_cs-c2sale.
        wa_tab7-c3sale = wa_cs-c3sale.
      endif.

      read table it_cptar1 into wa_cptar1 with key bzirk = wa_tab6-bzirk.  "current , last & last to last month TARGET.
      if sy-subrc eq 0.
        wa_tab7-t1 = wa_cptar1-t1.
        wa_tab71-t1 = wa_cptar1-t1.
        wa_tab7-t2 = wa_cptar1-t2.
        wa_tab7-t3 = wa_cptar1-t3.
      endif.

      read table it_lly1 into wa_lly1 with key bzirk = wa_tab6-bzirk.  "LAST TO LAST YEAR SALE.
      if sy-subrc eq 0.
        clear : qt1,qt2,qt3,qt4.
        qt1 = wa_lly1-m1 + wa_lly1-m2 + wa_lly1-m3.
        qt2 = wa_lly1-m4 + wa_lly1-m5 + wa_lly1-m6.
        qt3 = wa_lly1-m7 + wa_lly1-m8 + wa_lly1-m9.
        qt4 = wa_lly1-m10 + wa_lly1-m11 + wa_lly1-m12.
        wa_tab7-llsqrt1 = qt1.
        wa_tab7-llsqrt2 = qt2.
        wa_tab7-llsqrt3 = qt3.
        wa_tab7-llsqrt4 = qt4.
      endif.

*    read table it_lqt1 into wa_lqt1 with key bzirk = wa_tab6-bzirk.  "LAST  YEAR SALE.
*    if sy-subrc eq 0.
*      wa_tab7-lsqrt1 = wa_lqt1-qt1.
*      wa_tab7-lsqrt2 = wa_lqt1-qt2.
*      wa_tab7-lsqrt3 = wa_lqt1-qt3.
*      wa_tab7-lsqrt4 = wa_lqt1-qt4.
*      lsqrt5 = wa_lqt1-qt1 + wa_lqt1-qt2 + wa_lqt1-qt3 + wa_lqt1-qt4.
*      wa_tab7-lsqrt5 = lsqrt5.
*    endif.

      read table it_lqtc1 into wa_lqtc1 with key bzirk = wa_tab6-bzirk.  "LAST  YEAR SALE from .
      if sy-subrc eq 0.
        wa_tab7-lsqrtc1 = wa_lqtc1-qt1.
        wa_tab7-lsqrtc2 = wa_lqtc1-qt2.
        wa_tab7-lsqrtc3 = wa_lqtc1-qt3.
        wa_tab7-lsqrtc4 = wa_lqtc1-qt4.
        lsqrtc5 = wa_lqtc1-qt1 + wa_lqtc1-qt2 + wa_lqtc1-qt3 + wa_lqtc1-qt4.
        wa_tab7-lsqrtc = lsqrtc5.
      endif.

      read table it_lcummsr1_zm into wa_lcummsr1_zm with key bzirk = wa_tab6-bzirk.  "LAST  YEAR CUMMULATIVE SALE from ZRCUMPSO.
      if sy-subrc eq 0.
        wa_tab7-lcummsr = wa_lcummsr1_zm-lcumm_sale.
      endif.

*    read table it_lytq1 into wa_lytq1 with key bzirk = wa_tab6-bzirk.  "LAST YEAR Target.
*    if sy-subrc eq 0.
*      wa_tab7-ltqrt1 = wa_lytq1-qrt1.
*      wa_tab7-ltqrt2 = wa_lytq1-qrt2.
*      wa_tab7-ltqrt3 = wa_lytq1-qrt3.
*      wa_tab7-ltqrt4 = wa_lytq1-qrt4.
*    endif.

*    read table it_cqt1 into wa_cqt1 with key bzirk = wa_tab6-bzirk.  "CURRENT  YEAR SALE.
*    if sy-subrc eq 0.
*      wa_tab7-csqrt1 = wa_cqt1-qt1.
*      wa_tab7-csqrt2 = wa_cqt1-qt2.
*      wa_tab7-csqrt3 = wa_cqt1-qt3.
*      wa_tab7-csqrt4 = wa_cqt1-qt4.
*    endif.
*
*    read table it_cyqt1 into wa_cyqt1 with key bzirk = wa_tab6-bzirk.  "CURRENT  YEAR TARGET.
*    if sy-subrc eq 0.
*      wa_tab7-ctqrt1 = wa_cyqt1-qrt1.
*      wa_tab7-ctqrt2 = wa_cyqt1-qrt2.
*      wa_tab7-ctqrt3 = wa_cyqt1-qrt3.
*      wa_tab7-ctqrt4 = wa_cyqt1-qrt4.
*    endif.
****************TERR*************
*    READ TABLE IT_APR INTO WA_APR WITH KEY ZM = WA_TAB6-REG RM = WA_TAB6-RM BZIRK = WA_TAB6-BZIRK.
*    IF SY-SUBRC EQ 0.
*      APRSALE = WA_APR-NETVAL.
*      APRTAR = WA_APR-TAR.
*    ENDIF.
*    READ TABLE IT_MAY INTO WA_MAY WITH KEY ZM = WA_TAB6-REG RM = WA_TAB6-RM BZIRK = WA_TAB6-BZIRK.
*    IF SY-SUBRC EQ 0.
*      MAYSALE = WA_MAY-NETVAL.
*      MAYTAR = WA_MAY-TAR.
*    ENDIF.
*    READ TABLE IT_JUN INTO WA_JUN WITH KEY ZM = WA_TAB6-REG RM = WA_TAB6-RM BZIRK = WA_TAB6-BZIRK.
*    IF SY-SUBRC EQ 0.
*      JUNSALE = WA_JUN-NETVAL.
*      JUNTAR = WA_JUN-TAR.
*    ENDIF.
*wa_tab7-csqrt1 = APRSALE + MAYSALE + JUNSALE.
*    wa_tab7-ctqrt1 = APRTAR + MAYTAR + JUNTAR.
*************************************
      read table it_cummsr2_zm into wa_cummsr2_zm with key bzirk = wa_tab6-bzirk.  "CURRENT  YEAR CUMMULATIVE SALE FROM ZRCUMPSO.
      if sy-subrc eq 0.
        wa_tab7-cummsr = wa_cummsr2_zm-ccumm_sale.
      endif.


************ CURRENT MONTH TARGET*************
      read table it_cmtar into wa_cmtar with key bzirk = wa_tab6-bzirk.
      if sy-subrc eq 0.
        wa_tab7-ctar = wa_cmtar-ctar.
      endif.

      read table it_lcumms1 into wa_lcumms1 with key bzirk = wa_tab6-bzirk.  "last year cummulative sale.
      if sy-subrc eq 0.
        wa_tab7-lcumms = wa_lcumms1-lcumm_sale.
      endif.

      read table it_cumms2_zm into wa_cumms2_zm with key bzirk = wa_tab6-bzirk.  "CURRENT year cummulative sale.
      if sy-subrc eq 0.
        wa_tab7-cumms = wa_cumms2_zm-ccumm_sale.
      endif.

      read table it_ccyt1_zm into wa_ccyt1_zm with key bzirk = wa_tab6-bzirk.  "CURRENT year cummulative TARGET.
      if sy-subrc eq 0.
        wa_tab7-cummt = wa_ccyt1_zm-cyt.
      endif.

      collect wa_tab7 into it_tab7.
      clear wa_tab7.

      collect wa_tab71 into it_tab71.
      clear wa_tab71.
    endif.
  endloop.
****************************************************************************************************************************
  clear: it_pa0001a1,wa_pa0001a1.
  if it_tab7 is not initial.
    select * from pa0001 into table it_pa0001a1 for all entries in it_tab7 where plans eq it_tab7-plans.
  endif.
  sort it_pa0001a1 descending by endda.

  sort it_tab7 by reg.
  loop at it_tab7 into wa_tab7 .
    clear : lpqrt1,lpqrt2,lpqrt1,lpqrt3,lpqrt4,lcumm,lgrw,pjoin_dt,incrdt,ltqrt,llsqrt,lsqrt,
            cpqrt1,cpqrt2,cpqrt1,cpqrt3,cpqrt4,ccumm,cgrw, cp1,cp2,cp3,
            ls1,ls2,ls3,ls4, lsc1,lsc2,lsc3,lsc4,cs1,cs2,cs3,cs4, lysale,cysale,lysalec, prom, sl1, sl2, sl3.

    wa_tab9-reg = wa_tab7-reg.
*    wa_tab9-rm = wa_tab7-rm.
    wa_tab9-zmpernr = wa_tab7-zmpernr.

    select single * from pa0302 where pernr eq wa_tab7-zmpernr and massn eq '01'.
    if sy-subrc eq 0.
      concatenate pa0302-begda+4(2) '/' pa0302-begda+0(4) into pjoin_dt.
      wa_tab9-join_dt = pjoin_dt.
      wa_tab9-join_date = pa0302-begda.
    endif.

    if  wa_tab9-join_dt eq space.  "added on 16.7.24
      clear : pjoin_dt.
      read table it_pa0001a1 into wa_pa0001a1 with key plans = wa_tab9-plans.
      if sy-subrc eq 0.
        select single * from pa0302 where pernr eq wa_pa0001a1-pernr and massn eq '10'.
        if sy-subrc eq 0.
          concatenate pa0302-begda+4(2) '/' pa0302-begda+0(4) into pjoin_dt.
          wa_tab9-join_dt = pjoin_dt.
        endif.
*      BREAK-POINT .
        if  wa_tab9-join_dt eq space.
          concatenate wa_pa0001a1-endda+4(2) '/' wa_pa0001a1-endda+0(4) into pjoin_dt.
          wa_tab9-join_dt = pjoin_dt.
        endif.
      endif.
    endif.

    if  wa_tab9-join_dt eq space or wa_tab9-join_dt+3(4) ge '2999'.
      concatenate '04' '/' '2024' into wa_tab9-join_dt .  "added on 16.7.24
    endif.

*    WRITE : /1 wa_TAB7-reg,8 wa_tab7-rm,16(8) wa_tab7-llsqrt1,27(8) wa_tab7-llsqrt2,37(8) wa_tab7-llsqrt3,47(8) wa_tab7-llsqrt4.
*    WRITE : 55(8) wa_tab7-lsqrt1,65(8) wa_tab7-lsqrt2,75(8) wa_tab7-lsqrt3,85(8) wa_tab7-lsqrt4.
*    WRITE : 95(8) wa_tab7-ltqrt1,105(8) wa_tab7-ltqrt2,115(8) wa_tab7-ltqrt3,125(8) wa_tab7-ltqrt4.
*    WRITE : 135(8) wa_tab7-csqrt1,145(8) wa_tab7-csqrt2,155(8) wa_tab7-csqrt3,165(8) wa_tab7-csqrt4.
*    WRITE : 175(8) wa_tab7-ctqrt1,185(8) wa_tab7-ctqrt2,195(8) wa_tab7-ctqrt3,205(8) wa_tab7-ctqrt4.
**************** LAST YEAR SALE PERFORMANVE ***********
***************** 1ST QRT *****************
    clear : aprsale,maysale,junsale,julsale,augsale,sepsale,octsale,novsale,decsale,jansale,febsale,marsale.
    clear : aprtar,maytar,juntar,jultar,augtar,septar,octtar,novtar,dectar,jantar,febtar,martar.
*BREAK-POINT.
    on change of wa_tab7-reg.
      loop at it_lapr into wa_lapr where zm = wa_tab7-reg.
        aprsale = aprsale +  wa_lapr-netval.
        aprtar = aprtar + wa_lapr-tar.
*        wa_dlapr-aprsale = wa_lapr-netval.
*        wa_dlapr-aprtar = wa_lapr-tar.
*        wa_dlapr-bzirk = wa_lapr-zm.
*        WRITE : / 'a', wa_lapr-zm,wa_lapr-netval, wa_dlapr-aprsale.
*        collect wa_dlapr into it_dlapr.
*        clear wa_dlapr.
      endloop.
    endon.
*    BREAK-POINT.
*    loop at it_lapr into wa_lapr where rm = wa_tab7-rm.
*      wa_rdlapr-aprsale = wa_lapr-netval.
*      wa_rdlapr-aprtar = wa_lapr-tar.
*      wa_rdlapr-bzirk = wa_lapr-rm.
*      collect wa_rdlapr into it_rdlapr.
*      clear wa_rdlapr.
*    endloop.
*    loop at it_lapr into wa_lapr where dzm = wa_tab7-zm.
*      wa_zdlapr-aprsale = wa_lapr-netval.
*      wa_zdlapr-aprtar = wa_lapr-tar.
*      wa_zdlapr-bzirk = wa_lapr-rm.
*      collect wa_zdlapr into it_zdlapr.
*      clear wa_zdlapr.
*    endloop.
    on change of wa_tab7-reg.
      loop at it_lmay into wa_lmay where zm = wa_tab7-reg.
        maysale = maysale +  wa_lmay-netval.
        maytar = maytar + wa_lmay-tar.
*        wa_dlapr-maysale = wa_lmay-netval.
*        wa_dlapr-maytar = wa_lmay-tar.
*        wa_dlapr-bzirk = wa_lmay-zm.
*        collect wa_dlapr into it_dlapr.
*        clear wa_dlapr.
      endloop.
    endon.
*    loop at it_lmay into wa_lmay where rm = wa_tab7-rm.
*      wa_rdlapr-maysale = wa_lmay-netval.
*      wa_rdlapr-maytar = wa_lmay-tar.
*      wa_rdlapr-bzirk = wa_lmay-rm.
*      collect wa_rdlapr into it_rdlapr.
*      clear wa_rdlapr.
*    endloop.
*    loop at it_lmay into wa_lmay where dzm = wa_tab7-zm.
*      wa_zdlapr-maysale = wa_lmay-netval.
*      wa_zdlapr-maytar = wa_lmay-tar.
*      wa_zdlapr-bzirk = wa_lmay-rm.
*      collect wa_zdlapr into it_zdlapr.
*      clear wa_zdlapr.
*    endloop.

    on change of wa_tab7-reg.
      loop at it_ljun into wa_ljun where zm = wa_tab7-reg.
        junsale = junsale +  wa_ljun-netval.
        juntar = juntar + wa_ljun-tar.
*        wa_dlapr-junsale = wa_ljun-netval.
*        wa_dlapr-juntar = wa_ljun-tar.
*        wa_dlapr-bzirk = wa_ljun-zm.
*        collect wa_dlapr into it_dlapr.
*        clear wa_dlapr.
      endloop.
    endon.
*    loop at it_ljun into wa_ljun where rm = wa_tab7-rm.
*      wa_rdlapr-junsale = wa_ljun-netval.
*      wa_rdlapr-juntar = wa_ljun-tar.
*      wa_rdlapr-bzirk = wa_ljun-rm.
*      collect wa_rdlapr into it_rdlapr.
*      clear wa_rdlapr.
*    endloop.
*    loop at it_ljun into wa_ljun where dzm = wa_tab7-zm.
*      wa_zdlapr-junsale = wa_ljun-netval.
*      wa_zdlapr-juntar = wa_ljun-tar.
*      wa_zdlapr-bzirk = wa_ljun-rm.
*      collect wa_zdlapr into it_zdlapr.
*      clear wa_zdlapr.
*    endloop.

    wa_tab7-lsqrt1 = aprsale + maysale + junsale.
    wa_tab7-ltqrt1 = aprtar + maytar + juntar.
****************2ND QRT *******************
    on change of wa_tab7-reg.
      loop at it_ljul into wa_ljul where zm = wa_tab7-reg.
        julsale = julsale +  wa_ljul-netval.
        jultar = jultar + wa_ljul-tar.
*        wa_dlapr-julsale = wa_ljul-netval.
*        wa_dlapr-jultar = wa_ljul-tar.
*        wa_dlapr-bzirk = wa_ljul-zm.
*        collect wa_dlapr into it_dlapr.
*        clear wa_dlapr.
      endloop.
    endon.
*    loop at it_ljul into wa_ljul where rm = wa_tab7-rm.
*      wa_rdlapr-julsale = wa_ljul-netval.
*      wa_rdlapr-jultar = wa_ljul-tar.
*      wa_rdlapr-bzirk = wa_ljul-rm.
*      collect wa_rdlapr into it_rdlapr.
*      clear wa_rdlapr.
*    endloop.
*    loop at it_ljul into wa_ljul where dzm = wa_tab7-zm.
*      wa_zdlapr-julsale = wa_ljul-netval.
*      wa_zdlapr-jultar = wa_ljul-tar.
*      wa_zdlapr-bzirk = wa_ljul-rm.
*      collect wa_zdlapr into it_zdlapr.
*      clear wa_zdlapr.
*    endloop.

    on change of wa_tab7-reg.
      loop at it_laug into wa_laug where zm = wa_tab7-reg.
        augsale = augsale +  wa_laug-netval.
        augtar = augtar + wa_laug-tar.
*        wa_dlapr-augsale = wa_laug-netval.
*        wa_dlapr-augtar = wa_laug-tar.
*        wa_dlapr-bzirk = wa_laug-zm.
*        collect wa_dlapr into it_dlapr.
*        clear wa_dlapr.
      endloop.
    endon.
*    loop at it_laug into wa_laug where rm = wa_tab7-rm.
*      wa_rdlapr-augsale = wa_laug-netval.
*      wa_rdlapr-augtar = wa_laug-tar.
*      wa_rdlapr-bzirk = wa_laug-rm.
*      collect wa_rdlapr into it_rdlapr.
*      clear wa_rdlapr.
*    endloop.
*    loop at it_laug into wa_laug where dzm = wa_tab7-zm.
*      wa_zdlapr-augsale = wa_laug-netval.
*      wa_zdlapr-augtar = wa_laug-tar.
*      wa_zdlapr-bzirk = wa_laug-rm.
*      collect wa_zdlapr into it_zdlapr.
*      clear wa_zdlapr.
*    endloop.
    on change of wa_tab7-reg.
      loop at it_lsep into wa_lsep where zm = wa_tab7-reg.
        sepsale = sepsale +  wa_lsep-netval.
        septar = septar + wa_lsep-tar.
*        wa_dlapr-sepsale = wa_lsep-netval.
*        wa_dlapr-septar = wa_lsep-tar.
*        wa_dlapr-bzirk = wa_lsep-zm.
*        collect wa_dlapr into it_dlapr.
*        clear wa_dlapr.
      endloop.
    endon.
*    loop at it_lsep into wa_lsep where rm = wa_tab7-rm.
*      wa_rdlapr-sepsale = wa_lsep-netval.
*      wa_rdlapr-septar = wa_lsep-tar.
*      wa_rdlapr-bzirk = wa_lsep-rm.
*      collect wa_rdlapr into it_rdlapr.
*      clear wa_rdlapr.
*    endloop.
*    loop at it_lsep into wa_lsep where dzm = wa_tab7-zm.
*      wa_zdlapr-sepsale = wa_lsep-netval.
*      wa_zdlapr-septar = wa_lsep-tar.
*      wa_zdlapr-bzirk = wa_lsep-rm.
*      collect wa_zdlapr into it_zdlapr.
*      clear wa_zdlapr.
*    endloop.

    wa_tab7-lsqrt2 = julsale + augsale + sepsale.
    wa_tab7-ltqrt2 = jultar + augtar + septar.
****************3rd QRT *******************
    on change of wa_tab7-reg.
      loop at it_loct into wa_loct where zm = wa_tab7-reg.
        octsale = octsale +  wa_loct-netval.
        octtar = octtar + wa_loct-tar.
*        wa_dlapr-octsale = wa_loct-netval.
*        wa_dlapr-octtar = wa_loct-tar.
*        wa_dlapr-bzirk = wa_loct-zm.
*        collect wa_dlapr into it_dlapr.
*        clear wa_dlapr.
      endloop.
    endon.
*    loop at it_loct into wa_loct where rm = wa_tab7-rm.
*      wa_rdlapr-octsale = wa_loct-netval.
*      wa_rdlapr-octtar = wa_loct-tar.
*      wa_rdlapr-bzirk = wa_loct-rm.
*      collect wa_rdlapr into it_rdlapr.
*      clear wa_rdlapr.
*    endloop.
*    loop at it_loct into wa_loct where dzm = wa_tab7-zm.
*      wa_zdlapr-octsale = wa_loct-netval.
*      wa_zdlapr-octtar = wa_loct-tar.
*      wa_zdlapr-bzirk = wa_loct-rm.
*      collect wa_zdlapr into it_zdlapr.
*      clear wa_zdlapr.
*    endloop.
    on change of wa_tab7-reg.
      loop at it_lnov into wa_lnov where zm = wa_tab7-reg.
        novsale = novsale +  wa_lnov-netval.
        novtar = novtar + wa_lnov-tar.
*        wa_dlapr-novsale = wa_lnov-netval.
*        wa_dlapr-novtar = wa_lnov-tar.
*        wa_dlapr-bzirk = wa_lnov-zm.
*        collect wa_dlapr into it_dlapr.
*        clear wa_dlapr.
      endloop.
    endon.
*    loop at it_lnov into wa_lnov where rm = wa_tab7-rm.
*      wa_rdlapr-novsale = wa_lnov-netval.
*      wa_rdlapr-novtar = wa_lnov-tar.
*      wa_rdlapr-bzirk = wa_lnov-rm.
*      collect wa_rdlapr into it_rdlapr.
*      clear wa_rdlapr.
*    endloop.
*    loop at it_lnov into wa_lnov where dzm = wa_tab7-zm.
*      wa_zdlapr-novsale = wa_lnov-netval.
*      wa_zdlapr-novtar = wa_lnov-tar.
*      wa_zdlapr-bzirk = wa_lnov-rm.
*      collect wa_zdlapr into it_zdlapr.
*      clear wa_zdlapr.
*    endloop.
    on change of wa_tab7-reg.
      loop at it_ldec into wa_ldec where zm = wa_tab7-reg.
        decsale = decsale +  wa_ldec-netval.
        dectar = dectar + wa_ldec-tar.
*        wa_dlapr-decsale = wa_ldec-netval.
*        wa_dlapr-dectar = wa_ldec-tar.
*        wa_dlapr-bzirk = wa_ldec-zm.
*        collect wa_dlapr into it_dlapr.
*        clear wa_dlapr.
      endloop.
    endon.
*    loop at it_ldec into wa_ldec where rm = wa_tab7-rm.
*      wa_rdlapr-decsale = wa_ldec-netval.
*      wa_rdlapr-dectar = wa_ldec-tar.
*      wa_rdlapr-bzirk = wa_ldec-rm.
*      collect wa_rdlapr into it_rdlapr.
*      clear wa_rdlapr.
*    endloop.
*    loop at it_ldec into wa_ldec where dzm = wa_tab7-zm.
*      wa_zdlapr-decsale = wa_ldec-netval.
*      wa_zdlapr-dectar = wa_ldec-tar.
*      wa_zdlapr-bzirk = wa_ldec-rm.
*      collect wa_zdlapr into it_zdlapr.
*      clear wa_zdlapr.
*    endloop.

    wa_tab7-lsqrt3 = octsale + novsale + decsale.
    wa_tab7-ltqrt3 = octtar + novtar + dectar.

****************4TH QRT *******************
    on change of wa_tab7-reg.
      loop at it_ljan into wa_ljan where zm = wa_tab7-reg.
        jansale = jansale +  wa_ljan-netval.
        jantar = jantar + wa_ljan-tar.
*        wa_dlapr-jansale = wa_ljan-netval.
*        wa_dlapr-jantar = wa_ljan-tar.
*        wa_dlapr-bzirk = wa_ljan-zm.
*        collect wa_dlapr into it_dlapr.
*        clear wa_dlapr.
      endloop.
    endon.
*    loop at it_ljan into wa_ljan where rm = wa_tab7-rm.
*      wa_rdlapr-jansale = wa_ljan-netval.
*      wa_rdlapr-jantar = wa_ljan-tar.
*      wa_rdlapr-bzirk = wa_ljan-rm.
*      collect wa_rdlapr into it_rdlapr.
*      clear wa_rdlapr.
*    endloop.
*    loop at it_ljan into wa_ljan where dzm = wa_tab7-zm.
*      wa_zdlapr-jansale = wa_ljan-netval.
*      wa_zdlapr-jantar = wa_ljan-tar.
*      wa_zdlapr-bzirk = wa_ljan-rm.
*      collect wa_zdlapr into it_zdlapr.
*      clear wa_zdlapr.
*    endloop.
    on change of wa_tab7-reg.
      loop at it_lfeb into wa_lfeb where zm = wa_tab7-reg.
        febsale = febsale +  wa_lfeb-netval.
        febtar = febtar + wa_lfeb-tar.
*        wa_dlapr-febsale = wa_lfeb-netval.
*        wa_dlapr-febtar = wa_lfeb-tar.
*        wa_dlapr-bzirk = wa_lfeb-zm.
*        collect wa_dlapr into it_dlapr.
*        clear wa_dlapr.
      endloop.
    endon.
*    loop at it_lfeb into wa_lfeb where rm = wa_tab7-rm.
*      wa_rdlapr-febsale = wa_lfeb-netval.
*      wa_rdlapr-febtar = wa_lfeb-tar.
*      wa_rdlapr-bzirk = wa_lfeb-rm.
*      collect wa_rdlapr into it_rdlapr.
*      clear wa_rdlapr.
*    endloop.
*    loop at it_lfeb into wa_lfeb where dzm = wa_tab7-zm.
*      wa_zdlapr-febsale = wa_lfeb-netval.
*      wa_zdlapr-febtar = wa_lfeb-tar.
*      wa_zdlapr-bzirk = wa_lfeb-rm.
*      collect wa_zdlapr into it_zdlapr.
*      clear wa_zdlapr.
*    endloop.

    on change of wa_tab7-reg.
      loop at it_lmar into wa_lmar where zm = wa_tab7-reg.
        marsale = marsale +  wa_lmar-netval.
        martar = martar + wa_lmar-tar.
*        wa_dlapr-marsale = wa_lmar-netval.
*        wa_dlapr-martar = wa_lmar-tar.
*        wa_dlapr-bzirk = wa_lmar-zm.
*        collect wa_dlapr into it_dlapr.
*        clear wa_dlapr.
      endloop.
    endon.
*    loop at it_lmar into wa_lmar where rm = wa_tab7-rm.
*      wa_rdlapr-marsale = wa_lmar-netval.
*      wa_rdlapr-martar = wa_lmar-tar.
*      wa_rdlapr-bzirk = wa_lmar-rm.
*      collect wa_rdlapr into it_rdlapr.
*      clear wa_rdlapr.
*    endloop.
*    loop at it_lmar into wa_lmar where dzm = wa_tab7-zm.
*      wa_zdlapr-marsale = wa_lmar-netval.
*      wa_zdlapr-martar = wa_lmar-tar.
*      wa_zdlapr-bzirk = wa_lmar-rm.
*      collect wa_zdlapr into it_zdlapr.
*      clear wa_zdlapr.
*    endloop.

    wa_tab7-lsqrt4 = jansale + febsale + marsale.
    wa_tab7-ltqrt4 = jantar + febtar + martar.
************************************************************
    if wa_tab7-ltqrt1 gt 0.
      lpqrt1 = ( wa_tab7-lsqrt1 / wa_tab7-ltqrt1 ) * 100.
    endif.
    if wa_tab7-ltqrt2 gt 0.
      lpqrt2 = ( wa_tab7-lsqrt2 / wa_tab7-ltqrt2 ) * 100.
    endif.
    if wa_tab7-ltqrt3 gt 0.
      lpqrt3 = ( wa_tab7-lsqrt3 / wa_tab7-ltqrt3 ) * 100.
    endif.
    if wa_tab7-ltqrt4 gt 0.
      lpqrt4 = ( wa_tab7-lsqrt4 / wa_tab7-ltqrt4 ) * 100.
    endif.
    wa_tab9-lpqrt1 = lpqrt1.
    wa_tab9-lpqrt2 = lpqrt2.
    wa_tab9-lpqrt3 = lpqrt3.
    wa_tab9-lpqrt4 = lpqrt4.


    ls1 = wa_tab7-lsqrt1 / 1000.
    ls2 = wa_tab7-lsqrt2 / 1000.
    ls3 = wa_tab7-lsqrt3 / 1000.
    ls4 = wa_tab7-lsqrt4 / 1000.
    wa_tab9-lysale1 = ls1.
    wa_tab9-lysale2 = ls2.
    wa_tab9-lysale3 = ls3.
    wa_tab9-lysale4 = ls4.
    lysale = ls1 + ls2 + ls3 + ls4.
    wa_tab9-lysale = lysale.

    lsc1 = wa_tab7-lsqrtc1 / 1000.
    lsc2 = wa_tab7-lsqrtc2 / 1000.
    lsc3 = wa_tab7-lsqrtc3 / 1000.
    lsc4 = wa_tab7-lsqrtc4 / 1000.
    wa_tab9-lysalec1 = lsc1.
    wa_tab9-lysalec2 = lsc2.
    wa_tab9-lysalec3 = lsc3.
    wa_tab9-lysalec4 = lsc4.
    lysalec = lsc1 + lsc2 + lsc3 + lsc4.
    wa_tab9-lysalec = lysalec.

************ LAST YEAR CUMMULATIVE***********
    ltqrt = wa_tab7-ltqrt1 + wa_tab7-ltqrt2 + wa_tab7-ltqrt3 + wa_tab7-ltqrt4 .
    if ltqrt gt 0.
      lcumm = ( ( wa_tab7-lsqrt1 + wa_tab7-lsqrt2 + wa_tab7-lsqrt3 + wa_tab7-lsqrt4 ) / ltqrt ) * 100.
    endif.
    wa_tab9-lcumm = lcumm.
********************** LAST YEAR GROWTH ******************
    llsqrt = wa_tab7-llsqrt1 + wa_tab7-llsqrt2 + wa_tab7-llsqrt3 + wa_tab7-llsqrt4.
    if llsqrt gt 0.
      lgrw = ( ( wa_tab7-lsqrt1 + wa_tab7-lsqrt2 + wa_tab7-lsqrt3 + wa_tab7-lsqrt4 ) / llsqrt ) * 100 - 100.
    else.
      lgrw = 100.
    endif.
    wa_tab9-lgrw = lgrw.
************* CURRENT MONTH TARGET************
    wa_tab9-ctar = wa_tab7-ctar .

**************** CURRENT YEAR SALE PERFORMANVE ***********
***************** 1ST QRT *****************
    clear : aprsale,maysale,junsale,julsale,augsale,sepsale,octsale,novsale,decsale,jansale,febsale,marsale.
    clear : aprtar,maytar,juntar,jultar,augtar,septar,octtar,novtar,dectar,jantar,febtar,martar.

    loop at it_apr into wa_apr where zm = wa_tab7-reg.
      aprsale = aprsale +  wa_apr-netval.
      aprtar = aprtar + wa_apr-tar.
    endloop.
    loop at it_may into wa_may where zm = wa_tab7-reg.
      maysale = maysale +  wa_may-netval.
      maytar = maytar + wa_may-tar.
    endloop.
    loop at it_jun into wa_jun where zm = wa_tab7-reg.
      junsale = junsale +  wa_jun-netval.
      juntar = juntar + wa_jun-tar.
    endloop.
    wa_tab7-csqrt1 = aprsale + maysale + junsale.
    wa_tab7-ctqrt1 = aprtar + maytar + juntar.
****************2ND QRT *******************
    loop at it_jul into wa_jul where zm = wa_tab7-reg.
      julsale = julsale +  wa_jul-netval.
      jultar = jultar + wa_jul-tar.
    endloop.
    loop at it_aug into wa_aug where zm = wa_tab7-reg.
      augsale = augsale +  wa_aug-netval.
      augtar = augtar + wa_aug-tar.
    endloop.
    loop at it_sep into wa_sep where zm = wa_tab7-reg.
      sepsale = sepsale +  wa_sep-netval.
      septar = septar + wa_sep-tar.
    endloop.
    wa_tab7-csqrt2 = julsale + augsale + sepsale.
    wa_tab7-ctqrt2 = jultar + augtar + septar.
****************3rd QRT *******************
    loop at it_oct into wa_oct where zm = wa_tab7-reg.
      octsale = octsale +  wa_oct-netval.
      octtar = octtar + wa_oct-tar.
    endloop.
    loop at it_nov into wa_nov where zm = wa_tab7-reg.
      novsale = novsale +  wa_nov-netval.
      novtar = novtar + wa_nov-tar.
    endloop.
    loop at it_dec into wa_dec where zm = wa_tab7-reg.
      decsale = decsale +  wa_dec-netval.
      dectar = dectar + wa_dec-tar.
    endloop.
    wa_tab7-csqrt3 = octsale + novsale + decsale.
    wa_tab7-ctqrt3 = octtar + novtar + dectar.

****************4TH QRT *******************
    loop at it_jan into wa_jan where zm = wa_tab7-reg.
      jansale = jansale +  wa_jan-netval.
      jantar = jantar + wa_jan-tar.
    endloop.
    loop at it_feb into wa_feb where zm = wa_tab7-reg.
      febsale = febsale +  wa_feb-netval.
      febtar = febtar + wa_feb-tar.
    endloop.
    loop at it_mar into wa_mar where zm = wa_tab7-reg.
      marsale = marsale +  wa_mar-netval.
      martar = martar + wa_mar-tar.
    endloop.
    wa_tab7-csqrt4 = jansale + febsale + marsale.
    wa_tab7-ctqrt4 = jantar + febtar + martar.

*************************************************
    if date2 ge f3date.
      if wa_tab7-ctqrt1 gt 0.
        cpqrt1 = ( wa_tab7-csqrt1 / wa_tab7-ctqrt1 ) * 100.
      endif.
    endif.
    if date2 ge f6date.
      if wa_tab7-ctqrt2 gt 0.
        cpqrt2 = ( wa_tab7-csqrt2 / wa_tab7-ctqrt2 ) * 100.
      endif.
    endif.
    if date2 ge f9date.
      if wa_tab7-ctqrt3 gt 0.
        cpqrt3 = ( wa_tab7-csqrt3 / wa_tab7-ctqrt3 ) * 100.
      endif.
    endif.
    if date2 ge f12date.
      if wa_tab7-ctqrt4 gt 0.
        cpqrt4 = ( wa_tab7-csqrt4 / wa_tab7-ctqrt4 ) * 100.
      endif.
    endif.

    wa_tab9-cpqrt1 = cpqrt1.
    wa_tab9-cpqrt2 = cpqrt2.
    wa_tab9-cpqrt3 = cpqrt3.
    wa_tab9-cpqrt4 = cpqrt4.

    if date2 ge f3date.
      cs1 = wa_tab7-csqrt1 / 1000.
    endif.
    if date2 ge f6date.
      cs2 = wa_tab7-csqrt2 / 1000.
    endif.
    if date2 ge f9date.
      cs3 = wa_tab7-csqrt3 / 1000.
    endif.
    if date2 ge f12date.
      cs4 = wa_tab7-csqrt4 / 1000.
    endif.

    wa_tab9-cysale1 = cs1.
    wa_tab9-cysale2 = cs2.
    wa_tab9-cysale3 = cs3.
    wa_tab9-cysale4 = cs4.

*    cysale = cs1 + cs2 + cs3 + cs4.
*    cysale = ( wa_tab7-csqrt1 + wa_tab7-csqrt2 + wa_tab7-csqrt3 + wa_tab7-csqrt4 ) / 1000.
*************logic for cummulative************************
    clear : v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12.
    if wa_tab9-join_date le f1date.
      if date2 ge f1date.
        v1 = aprsale.
      endif.
    endif.
    if wa_tab9-join_date le f2date.
      if date2 ge f2date.
        v2 = maysale.
      endif.
    endif.
    if wa_tab9-join_date le f3date.
      if date2 ge f3date.
        v3 = junsale.
      endif.
    endif.
    if wa_tab9-join_date le f4date.
      if date2 ge f4date.
        v4 = julsale.
      endif.
    endif.
    if wa_tab9-join_date le f5date.
      if date2 ge f5date.
        v5 = augsale.
      endif.
    endif.
    if wa_tab9-join_date le f6date.
      if date2 ge f6date.
        v6 = sepsale.
      endif.
    endif.
    if wa_tab9-join_date le f7date.
      if date2 ge f7date.
        v7 = octsale.
      endif.
    endif.
    if wa_tab9-join_date le f8date.
      if date2 ge f8date.
        v8 = novsale.
      endif.
    endif.
    if wa_tab9-join_date le f9date.
      if date2 ge f9date.
        v9 = decsale.
      endif.
    endif.
    if wa_tab9-join_date le f10date.
      if date2 ge f10date.
        v10 = jansale.
      endif.
    endif.
    if wa_tab9-join_date le f11date.
      if date2 ge f11date.
        v11 = febsale.
      endif.
    endif.
    if wa_tab9-join_date le f12date.
      if date2 ge f12date.
        v12 = marsale.
      endif.
    endif.
    cysale = ( v1 + v2 + v3 + v4 + v5 + v6 + v7 + v8 + v9 + v10 + v11 + v12 ) / 1000.
**************************************************************

    wa_tab9-cysale = cysale.

************ CURRENT YEAR CUMMULATIVE***********
    if wa_tab7-cummt gt 0.
      ccumm = ( wa_tab7-cumms / wa_tab7-cummt ) * 100.
    endif.
    wa_tab9-ccumm = ccumm.

********************** CURRENT YEAR GROWTH ******************
*    IF WA_TAB7-LCUMMS GT 0.
*      CGRW = ( wa_tab7-CUMMS / WA_TAB7-LCUMMS ) * 100 - 100.
*    ENDIF.
*    WA_tab9-CGRW = CGRW.
***************CURRENT YEAR CUMMULATIVE GROWTH FROM ZRCUMPSO********
    if wa_tab7-lcummsr gt 0.
      cgrw = ( wa_tab7-cummsr / wa_tab7-lcummsr ) * 100 - 100.
    else.
      cgrw = 100.
    endif.
    wa_tab9-cgrw = cgrw.

***********************RM INCENTIVE********************************************
*    READ TABLE IT_INCT1 INTO WA_INCT1 WITH KEY PERNR = WA_TAB7-ZMPERNR.
*    IF SY-SUBRC EQ 0.
*      WA_tab9-INCT = wa_inct1-betrg.
*    ENDIF.
**********CURRENT MONTH, LAST MONTH & LAST TO LAST MONTH PERFORMANCE******
    if wa_tab7-t1 gt 0.
      cp1 = ( wa_tab7-c1sale / wa_tab7-t1 ) * 100.
    endif.
    if wa_tab7-t2 gt 0.
      cp2 = ( wa_tab7-c2sale / wa_tab7-t2 ) * 100.
    endif.
    if wa_tab7-t3 gt 0.
      cp3 = ( wa_tab7-c3sale / wa_tab7-t3 ) * 100.
    endif.
    wa_tab9-cp1 = cp1.
    wa_tab9-cp2 = cp2.
    wa_tab9-cp3 = cp3.
    sl1 = wa_tab7-c1sale / 1000.
    sl2 = wa_tab7-c2sale / 1000.
    sl3 = wa_tab7-c3sale / 1000.
    wa_tab9-c1sale = sl1.
    wa_tab9-c2sale = sl2.
    wa_tab9-c3sale = sl3.
**************** INCREMENT**************
*    READ TABLE it_inc1 INTO wa_inc1 WITH KEY PERNR = WA_TAB7-ZMPERNR.
*    IF SY-SUBRC EQ 0.
*      WA_tab9-INCR = wa_inc1-INCR.
*      WA_tab9-INCREMENT_DT = wa_inc1-INCREMENT_DT.
*      if wa_inc1-INCREMENT_DT ne 0.
*        CONCATENATE wa_inc1-INCREMENT_DT+4(2) '/' wa_inc1-INCREMENT_DT+0(4) INTO INCRDT.
*        WA_tab9-INCRDT = INCRDT.
*      endif.
*      WA_tab9-CSAL = WA_INC1-CSAL.
*      WA_tab9-INCR_DT = wa_inc1-incr_dt.
*    ENDIF.
**********************************************************
    select single * from zdrphq where bzirk eq wa_tab7-reg.
    if sy-subrc eq 0.
      select single * from  zthr_heq_des where zz_hqcode eq zdrphq-zz_hqcode.
      if sy-subrc eq 0.
        wa_tab9-zz_hqdesc =  zthr_heq_des-zz_hqdesc.
      endif.
    endif.
    select single * from pa0001 where pernr eq wa_tab7-zmpernr and endda ge date2.
    if sy-subrc eq 0.
      wa_tab9-ename = pa0001-ename.
      select single * from zfsdes where persk eq pa0001-persk.
      if sy-subrc eq 0.
        wa_tab9-short = zfsdes-short.
      endif.
    else.
      wa_tab9-ename = 'VACANT (Since)'.
      wa_tab9-short = 'ZM'.
    endif.


    read table it_tab5 into wa_tab5 with key reg = wa_tab7-reg div = 'BCL'.
    if sy-subrc eq 0.
      div = 'BCL'.
    else.
      read table it_tab5 into wa_tab5 with key reg = wa_tab7-reg div = 'BC'.
      if sy-subrc eq 0.
        read table it_tab5 into wa_tab5 with key reg = wa_tab7-reg div = 'XL'.
        if sy-subrc eq 0.
          div = 'BCL'.
        else.
          div = 'BC'.
        endif.
      else.
        read table it_tab5 into wa_tab5 with key reg = wa_tab7-reg div = 'LS'.
        if sy-subrc eq 0.
          div = 'LS'.
        else.
          div = 'XL'.
        endif.
      endif.
    endif.
    wa_tab9-div = div.
    select single * from zoneseq where zone_dist eq wa_tab7-reg.
    if sy-subrc eq 0.
      wa_tab9-seq = zoneseq-seq.
    endif.
    read table it_pa0000_zm into wa_pa0000_zm with key pernr = wa_tab7-zmpernr. "ZM PROMOTION
    if sy-subrc eq 0.
      concatenate wa_pa0000_zm-begda+4(2) '/' wa_pa0000_zm-begda+0(4) into prom.
      wa_tab9-prom = prom.
*      WA_tab9-PROM1 = 'L-PROM'.
    endif.

***********************************************************
    collect wa_tab9 into it_tab9.
    clear wa_tab9.
  endloop.



  loop at it_tab9 into wa_tab9 .
    clear : cp1,cp2,cp3, cums,lcums,cgrw,cum1,cum2,ccumm.
    clear : lpqrt1,ls1,lt1, lpqrt2,ls2,lt2, lpqrt3,ls3,lt3, lpqrt4,ls4,lt4.
    clear : lls1,lls2,lls3,lls4.
    clear : lycs,lyct,lcumm, csl1,cst1,cpqrt1, csl2,cst2,cpqrt2, csl3,cst3,cpqrt3, csl4,cst4,cpqrt4.
    clear : c1,c2,c3,c4, c5.
    clear : lsale,llsale, lgrw, l1.


    wa_tab8-reg = wa_tab9-reg.
    wa_tab8-zmpernr = wa_tab9-zmpernr.
**************** LAST YEAR SALE PERFORMANVE ***********
    read table it_ll1dums into wa_ll1dums with key bzirk = wa_tab8-reg.
    if sy-subrc eq 0.
      ls1 = ( wa_ll1dums-aprsale + wa_ll1dums-maysale + wa_ll1dums-junsale ) / 1000.
      wa_tab8-lysale1 = ls1.
      ls2 = ( wa_ll1dums-julsale + wa_ll1dums-augsale + wa_ll1dums-sepsale ) / 1000.
      wa_tab8-lysale2 = ls2.
      ls3 = ( wa_ll1dums-octsale + wa_ll1dums-novsale + wa_ll1dums-decsale ) / 1000.
      wa_tab8-lysale3 = ls3.
      ls4 = ( wa_ll1dums-jansale + wa_ll1dums-febsale + wa_ll1dums-marsale ) / 1000.
      wa_tab8-lysale4 = ls4.
      wa_tab8-lysale = wa_tab8-lysale1 + wa_tab8-lysale2 + wa_tab8-lysale3 + wa_tab8-lysale4.
    endif.
    read table it_ll1tdums into wa_ll1tdums with key bzirk = wa_tab8-reg.
    if sy-subrc eq 0.
      lt1 = ( wa_ll1tdums-aprsale + wa_ll1tdums-maysale + wa_ll1tdums-junsale ) / 1000.
      lt2 = ( wa_ll1tdums-julsale + wa_ll1tdums-augsale + wa_ll1tdums-sepsale ) / 1000.
      lt3 = ( wa_ll1tdums-octsale + wa_ll1tdums-novsale + wa_ll1tdums-decsale ) / 1000.
      lt4 = ( wa_ll1tdums-jansale + wa_ll1tdums-febsale + wa_ll1tdums-marsale ) / 1000.
    endif.

    lpqrt1 = ( ls1 / lt1 ) * 100.
    wa_tab8-lpqrt1 = lpqrt1.
    lpqrt2 = ( ls2 / lt2 ) * 100.
    wa_tab8-lpqrt2 = lpqrt2.
    lpqrt3 = ( ls3 / lt3 ) * 100.
    wa_tab8-lpqrt3 = lpqrt3.
    lpqrt4 = ( ls4 / lt4 ) * 100.
    wa_tab8-lpqrt4 = lpqrt4.

******************************
    read table it_l1dums into wa_l1dums with key bzirk = wa_tab8-reg.
    if sy-subrc eq 0.
      read table it_dlapr into wa_dlapr with key bzirk = wa_tab8-reg.
      if sy-subrc eq 0.

        read table it_n1l1aprcs1 into wa_n1l1aprcs1 with key bzirk = wa_tab8-reg.
        if sy-subrc eq 0.
          wa_l1dums-aprsale = wa_n1l1aprcs1-aprsale.
          wa_l1dums-maysale = wa_n1l1aprcs1-maysale.
          wa_l1dums-junsale = wa_n1l1aprcs1-junsale.
          wa_l1dums-julsale = wa_n1l1aprcs1-julsale.
          wa_l1dums-augsale = wa_n1l1aprcs1-augsale.
          wa_l1dums-sepsale = wa_n1l1aprcs1-sepsale.
          wa_l1dums-octsale = wa_n1l1aprcs1-octsale.
          wa_l1dums-novsale = wa_n1l1aprcs1-novsale.
          wa_l1dums-decsale = wa_n1l1aprcs1-decsale.
          wa_l1dums-jansale = wa_n1l1aprcs1-jansale.
          wa_l1dums-febsale = wa_n1l1aprcs1-febsale.
          wa_l1dums-marsale = wa_n1l1aprcs1-marsale.
        endif.

*        IF DATE2 LT F1DATE.
*          WA_L1DUMS-APRSALE = WA_DLAPR-APRSALE.
*        ENDIF.
*        IF DATE2 LT F2DATE.
*          WA_L1DUMS-MAYSALE = WA_DLAPR-MAYSALE.
*        ENDIF.
*        IF DATE2 LT F3DATE.
*          WA_L1DUMS-JUNSALE = WA_DLAPR-JUNSALE.
*        ENDIF.
*        IF DATE2 LT F4DATE.
*          WA_L1DUMS-JULSALE = WA_DLAPR-JULSALE.
*        ENDIF.
*        IF DATE2 LT F5DATE.
*          WA_L1DUMS-AUGSALE = WA_DLAPR-AUGSALE.
*        ENDIF.
*        IF DATE2 LT F6DATE.
*          WA_L1DUMS-SEPSALE = WA_DLAPR-SEPSALE.
*        ENDIF.
*        IF DATE2 LT F7DATE.
*          WA_L1DUMS-OCTSALE = WA_DLAPR-OCTSALE.
*        ENDIF.
*        IF DATE2 LT F8DATE.
*          WA_L1DUMS-NOVSALE = WA_DLAPR-NOVSALE.
*        ENDIF.
*        IF DATE2 LT F9DATE.
*          WA_L1DUMS-DECSALE = WA_DLAPR-DECSALE.
*        ENDIF.
*        IF DATE2 LT F10DATE.
*          WA_L1DUMS-JANSALE = WA_DLAPR-JANSALE.
*        ENDIF.
*        IF DATE2 LT F11DATE.
*          WA_L1DUMS-FEBSALE = WA_DLAPR-FEBSALE.
*        ENDIF.
*        IF DATE2 LT F12DATE.
*          WA_L1DUMS-MARSALE = WA_DLAPR-MARSALE.
*        ENDIF.

        lls1 = ( wa_l1dums-aprsale + wa_l1dums-maysale + wa_l1dums-junsale ) / 1000.
        wa_tab8-lysalec1 = lls1.
        lls2 = ( wa_l1dums-julsale + wa_l1dums-augsale + wa_l1dums-sepsale ) / 1000.
        wa_tab8-lysalec2 = lls2.
        lls3 = ( wa_l1dums-octsale + wa_l1dums-novsale + wa_l1dums-decsale ) / 1000.
        wa_tab8-lysalec3 = lls3.
        lls4 = ( wa_l1dums-jansale + wa_l1dums-febsale + wa_l1dums-marsale ) / 1000.
        wa_tab8-lysalec4 = lls4.
        wa_tab8-lysalec = wa_tab8-lysalec1 + wa_tab8-lysalec2 + wa_tab8-lysalec3 + wa_tab8-lysalec4.
      endif.
    endif.
*******************************
************ LAST YEAR CUMMULATIVE***********
*    wa_tab8-lcumm = wa_tab9-lcumm.
    read table it_ll1dums into wa_ll1dums with key bzirk = wa_tab8-reg.
    if sy-subrc eq 0.
      lycs = wa_ll1dums-aprsale + wa_ll1dums-maysale + wa_ll1dums-junsale + wa_ll1dums-julsale + wa_ll1dums-augsale + wa_ll1dums-sepsale +
      wa_ll1dums-octsale + wa_ll1dums-novsale + wa_ll1dums-decsale + wa_ll1dums-jansale + wa_ll1dums-febsale + wa_ll1dums-marsale.
    endif.
    read table it_ll1tdums into wa_ll1dums with key bzirk = wa_tab8-reg.
    if sy-subrc eq 0.
      lyct = wa_ll1tdums-aprsale + wa_ll1tdums-maysale + wa_ll1tdums-junsale + wa_ll1tdums-julsale + wa_ll1tdums-augsale + wa_ll1tdums-sepsale +
      wa_ll1tdums-octsale + wa_ll1tdums-novsale + wa_ll1tdums-decsale + wa_ll1tdums-jansale + wa_ll1tdums-febsale + wa_ll1tdums-marsale.
    endif.

    lcumm = ( lycs / lyct ) * 100.
    wa_tab8-lcumm = lcumm.

********************** LAST YEAR GROWTH ******************
*    wa_tab8-lgrw = wa_tab9-lgrw.
*BREAK-POINT.
    read table it_ll1dums into wa_ll1dums with key bzirk = wa_tab8-reg.
    if sy-subrc eq 0.
      lsale = wa_ll1dums-aprsale + wa_ll1dums-maysale + wa_ll1dums-junsale + wa_ll1dums-julsale + wa_ll1dums-augsale + wa_ll1dums-sepsale
      + wa_ll1dums-octsale + wa_ll1dums-novsale + wa_ll1dums-decsale + wa_ll1dums-jansale + wa_ll1dums-febsale + wa_ll1dums-marsale.
    endif.
    read table it_yll1dums into wa_yll1dums with key bzirk = wa_tab8-reg.
    if sy-subrc eq 0.
      llsale = wa_yll1dums-aprsale + wa_yll1dums-maysale + wa_yll1dums-junsale + wa_yll1dums-julsale + wa_yll1dums-augsale + wa_yll1dums-sepsale
      + wa_yll1dums-octsale + wa_yll1dums-novsale + wa_yll1dums-decsale + wa_yll1dums-jansale + wa_yll1dums-febsale + wa_yll1dums-marsale.
    endif.
    lgrw =  ( lsale / llsale ) * 100 - 100 .
    wa_tab8-lgrw = lgrw.

************* CURRENT MONTH TARGET************
    wa_tab8-ctar = wa_tab9-ctar .
**************** CURRENT YEAR SALE PERFORMANVE ***********
*    wa_tab8-cpqrt1 = wa_tab9-cpqrt1.
*    BREAK-POINT.
    read table it_dcums into wa_dcums with key bzirk = wa_tab8-reg.
    if sy-subrc eq 0.
      csl1 = wa_dcums-aprsale + wa_dcums-maysale + wa_dcums-junsale.
      if date2 ge f3date.
        c1 = csl1 / 1000.
      endif.
      wa_tab8-cysale1 = c1.
    endif.
    read table it_tdums into wa_tdums with key bzirk = wa_tab8-reg.
    if sy-subrc eq 0.
      cst1 = wa_tdums-aprsale + wa_tdums-maysale + wa_tdums-junsale.
    endif.
    if cst1 gt 0.
      cpqrt1 = ( csl1 / cst1 ) * 100.
    endif.
    if date2 ge f3date.
      wa_tab8-cpqrt1 = cpqrt1.
    endif.

*    wa_tab8-cpqrt2 = wa_tab9-cpqrt2.
    read table it_dcums into wa_dcums with key bzirk = wa_tab8-reg.
    if sy-subrc eq 0.
      csl2 = wa_dcums-julsale + wa_dcums-augsale + wa_dcums-sepsale.
      if date2 ge f6date.
        c2 = csl2 / 1000.
      endif.
      wa_tab8-cysale2 = c2.
    endif.
    read table it_tdums into wa_tdums with key bzirk = wa_tab8-reg.
    if sy-subrc eq 0.
      cst2 = wa_tdums-julsale + wa_tdums-augsale + wa_tdums-sepsale.
    endif.
    if cst2 gt 0.
      cpqrt2 = ( csl2 / cst2 ) * 100.
    endif.
    if date2 ge f6date.
      wa_tab8-cpqrt2 = cpqrt2.
    endif.

*    wa_tab8-cpqrt3 = wa_tab9-cpqrt3.
    read table it_dcums into wa_dcums with key bzirk = wa_tab8-reg.
    if sy-subrc eq 0.
      csl3 = wa_dcums-octsale + wa_dcums-novsale + wa_dcums-decsale.
      if date2 ge f9date.
        c3 = csl3 / 1000.
      endif.
      wa_tab8-cysale3 = c3.
    endif.
    read table it_tdums into wa_tdums with key bzirk = wa_tab8-reg.
    if sy-subrc eq 0.
      cst3 = wa_tdums-octsale + wa_tdums-novsale + wa_tdums-decsale.
    endif.
    if cst3 gt 0.
      cpqrt3 = ( csl3 / cst3 ) * 100.
    endif.
    if date2 ge f9date.
      wa_tab8-cpqrt3 = cpqrt3.
    endif.

*    wa_tab8-cpqrt4 = wa_tab9-cpqrt4.
    read table it_dcums into wa_dcums with key bzirk = wa_tab8-reg.
    if sy-subrc eq 0.
      csl4 = wa_dcums-jansale + wa_dcums-febsale + wa_dcums-marsale.
      if date2 ge f12date.
        c4 = csl4 / 1000.
      endif.
      wa_tab8-cysale4 = c4.
    endif.
    read table it_tdums into wa_tdums with key bzirk = wa_tab8-reg.
    if sy-subrc eq 0.
      cst4 = wa_tdums-jansale + wa_tdums-febsale + wa_tdums-marsale.
    endif.
    if cst4 gt 0.
      cpqrt4 = ( csl4 / cst4 ) * 100.
    endif.
    if date2 ge f12date.
      wa_tab8-cpqrt4 = cpqrt4.
    endif.
*    wa_tab8-cysale1 = wa_tab9-cysale1.
*    wa_tab8-cysale2 = wa_tab9-cysale2.
*    wa_tab8-cysale3 = wa_tab9-cysale3.
*    wa_tab8-cysale4 = wa_tab9-cysale4.
*    wa_tab8-cysale = wa_tab9-cysale.
************ CURRENT YEAR CUMMULATIVE***********
*    wa_tab8-ccumm = wa_tab9-ccumm.
    read table it_cums into wa_cums with key bzirk = wa_tab8-reg.
    if sy-subrc eq 0.
      cum1 = wa_cums-sale.
    endif.
    read table it_tcums into wa_tcums with key bzirk = wa_tab8-reg.
    if sy-subrc eq 0.
      cum2 = wa_tcums-sale.
    endif.
    if cum2 gt 0.
      ccumm = ( cum1 / cum2 ) * 100.
    endif.
    wa_tab8-ccumm = ccumm.
***************CURRENT YEAR CUMMULATIVE GROWTH FROM ZRCUMPSO********
    read table it_cums into wa_cums with key bzirk = wa_tab8-reg.
    if sy-subrc eq 0.
      cums = wa_cums-sale.
      c5 = wa_cums-sale / 1000.
      wa_tab8-cysale = c5.  "30.5.2019
*      WA_TAB8-CYSALE = C1 + C2 + C3 + C4.
    endif.
    read table it_lcums into wa_lcums with key bzirk = wa_tab8-reg.
    if sy-subrc eq 0.
      lcums = wa_lcums-sale.
*      wa_tab8-lysale = wa_lcums-sale / 1000.
    endif.
    if lcums gt 0.
      cgrw = ( cums / lcums ) * 100 - 100.
    endif.
    wa_tab8-cgrw = cgrw.

*    wa_tab8-cgrw = wa_tab9-cgrw.
**********CURRENT MONTH, LAST MONTH & LAST TO LAST MONTH PERFORMANCE******
    read table it_tab71 into wa_tab71 with key reg = wa_tab8-reg.
    if sy-subrc eq 0.
      cs11 = wa_tab71-c1sale / 1000.
      wa_tab8-c1sale = cs11.
      if wa_tab71-t1 gt 0.
        cp1 = ( wa_tab71-c1sale / wa_tab71-t1 ) * 100.
      endif.
      wa_tab8-cp1 = cp1.
    endif.


*    wa_tab8-cp1 = wa_tab9-cp1.
*    wa_tab8-cp2 = wa_tab9-cp2.
*    wa_tab8-cp3 = wa_tab9-cp3.
*    wa_tab8-c1sale = wa_tab9-c1sale.
*    wa_tab8-c2sale = wa_tab9-c2sale.
*     wa_tab8-c3sale = wa_tab9-c3sale.
    read table it_lcs into wa_lcs with key bzirk = wa_tab8-reg.
    if sy-subrc eq 0.
      cs13 = wa_lcs-c3sale / 1000.
      wa_tab8-c3sale = cs13.
      if wa_lcs-t2 gt 0.
        cp3 = ( wa_lcs-c3sale / wa_lcs-t2 ) * 100.
      endif.
      wa_tab8-cp3 = cp3.
    endif.
    read table it_l1cs into wa_l1cs with key bzirk = wa_tab8-reg.
    if sy-subrc eq 0.
      cs12 = wa_l1cs-c3sale / 1000.
      wa_tab8-c2sale = cs12.
      if wa_l1cs-t2 gt 0.
        cp2 = ( wa_l1cs-c3sale / wa_l1cs-t2 ) * 100.
      endif.
      wa_tab8-cp2 = cp2.
    endif.
**********************************************************

    wa_tab8-zz_hqdesc =  wa_tab9-zz_hqdesc.
    wa_tab8-ename = wa_tab9-ename.
    wa_tab8-short = wa_tab9-short.
    wa_tab8-join_dt = wa_tab9-join_dt.
    wa_tab8-div = wa_tab9-div.
    wa_tab8-seq = wa_tab9-seq.
    wa_tab8-prom = wa_tab9-prom.

    select single * from ztotpso where begda = totpsodt and bzirk = wa_tab9-reg.
    if sy-subrc = 0.
      wa_tab8-noofpso = ( ztotpso-bc + ztotpso-bcl + ztotpso-xl ) - ztotpso-hbe.
    endif.

    collect wa_tab8 into it_tab8.
    clear wa_tab8.
  endloop.

endform.                    "zm


*&---------------------------------------------------------------------*
*&      Form  rm
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form rm.
  loop at it_tab6 into wa_tab6.
    wa_rm1-reg = wa_tab6-reg.
    wa_rm1-zm = wa_tab6-zm.
    wa_rm1-rm = wa_tab6-rm.
    wa_rm1-zmpernr = wa_tab6-zmpernr.
    wa_rm1-dzmpernr = wa_tab6-dzmpernr.
    wa_rm1-rmpernr = wa_tab6-rmpernr.
    read table it_cs into wa_cs with key bzirk = wa_tab6-bzirk.  "current , last & last to last month sale.
    if sy-subrc eq 0.
      wa_rm1-c1sale = wa_cs-c1sale.
      wa_rm1-c2sale = wa_cs-c2sale.
      wa_rm1-c3sale = wa_cs-c3sale.
    endif.

    read table it_cptar1 into wa_cptar1 with key bzirk = wa_tab6-bzirk.  "current , last & last to last month TARGET.
    if sy-subrc eq 0.
      wa_rm1-t1 = wa_cptar1-t1.
      wa_rm1-t2 = wa_cptar1-t2.
      wa_rm1-t3 = wa_cptar1-t3.
    endif.

    read table it_lly1 into wa_lly1 with key bzirk = wa_tab6-bzirk.  "LAST TO LAST YEAR SALE.
    if sy-subrc eq 0.
      clear : qt1,qt2,qt3,qt4.
      qt1 = wa_lly1-m1 + wa_lly1-m2 + wa_lly1-m3.
      qt2 = wa_lly1-m4 + wa_lly1-m5 + wa_lly1-m6.
      qt3 = wa_lly1-m7 + wa_lly1-m8 + wa_lly1-m9.
      qt4 = wa_lly1-m10 + wa_lly1-m11 + wa_lly1-m12.
      wa_rm1-llsqrt1 = qt1.
      wa_rm1-llsqrt2 = qt2.
      wa_rm1-llsqrt3 = qt3.
      wa_rm1-llsqrt4 = qt4.
    endif.

*    read table it_lqt1 into wa_lqt1 with key bzirk = wa_tab6-bzirk.  "LAST  YEAR SALE.
*    if sy-subrc eq 0.
*      wa_rm1-lsqrt1 = wa_lqt1-qt1.
*      wa_rm1-lsqrt2 = wa_lqt1-qt2.
*      wa_rm1-lsqrt3 = wa_lqt1-qt3.
*      wa_rm1-lsqrt4 = wa_lqt1-qt4.
*    endif.
*
*    read table it_lqtc1 into wa_lqtc1 with key bzirk = wa_tab6-bzirk.  "LAST  YEAR SALE from ZCUMPSO.
*    if sy-subrc eq 0.
*      wa_rm1-lsqrtc1 = wa_lqtc1-qt1.
*      wa_rm1-lsqrtc2 = wa_lqtc1-qt2.
*      wa_rm1-lsqrtc3 = wa_lqtc1-qt3.
*      wa_rm1-lsqrtc4 = wa_lqtc1-qt4.
*    endif.

    read table it_lcummsr1_rm into wa_lcummsr1_rm with key bzirk = wa_tab6-bzirk.  "LAST  YEAR CUMMULATIVE SALE from ZRCUMPSO.
    if sy-subrc eq 0.
      wa_rm1-lcummsr = wa_lcummsr1_rm-lcumm_sale.
    endif.

    read table it_lytq1 into wa_lytq1 with key bzirk = wa_tab6-bzirk.  "LAST YEAR Target.
    if sy-subrc eq 0.
      wa_rm1-ltqrt1 = wa_lytq1-qrt1.
      wa_rm1-ltqrt2 = wa_lytq1-qrt2.
      wa_rm1-ltqrt3 = wa_lytq1-qrt3.
      wa_rm1-ltqrt4 = wa_lytq1-qrt4.
    endif.
*******************************************
*    read table it_cqt1 into wa_cqt1 with key bzirk = wa_tab6-bzirk.  "CURRENT  YEAR SALE.
*    if sy-subrc eq 0.
*      wa_rm1-csqrt1 = wa_cqt1-qt1.
*      wa_rm1-csqrt2 = wa_cqt1-qt2.
*      wa_rm1-csqrt3 = wa_cqt1-qt3.
*      wa_rm1-csqrt4 = wa_cqt1-qt4.
*    endif.
*
*    read table it_cyqt1 into wa_cyqt1 with key bzirk = wa_tab6-bzirk.  "CURRENT  YEAR TARGET.
*    if sy-subrc eq 0.
*      wa_rm1-ctqrt1 = wa_cyqt1-qrt1.
*      wa_rm1-ctqrt2 = wa_cyqt1-qrt2.
*      wa_rm1-ctqrt3 = wa_cyqt1-qrt3.
*      wa_rm1-ctqrt4 = wa_cyqt1-qrt4.
*    endif.

*******************terr***************
*    READ TABLE IT_APR INTO WA_APR WITH KEY ZM = WA_TAB6-REG RM = WA_TAB6-RM BZIRK = WA_TAB6-BZIRK.
*    IF SY-SUBRC EQ 0.
*      APRSALE = WA_APR-NETVAL.
*      APRTAR = WA_APR-TAR.
*    ENDIF.
*    READ TABLE IT_MAY INTO WA_MAY WITH KEY ZM = WA_TAB6-REG RM = WA_TAB6-RM BZIRK = WA_TAB6-BZIRK.
*    IF SY-SUBRC EQ 0.
*      MAYSALE = WA_MAY-NETVAL.
*      MAYTAR = WA_MAY-TAR.
*    ENDIF.
*    READ TABLE IT_JUN INTO WA_JUN WITH KEY ZM = WA_TAB6-REG RM = WA_TAB6-RM BZIRK = WA_TAB6-BZIRK.
*    IF SY-SUBRC EQ 0.
*      JUNSALE = WA_JUN-NETVAL.
*      JUNTAR = WA_JUN-TAR.
*    ENDIF.
*    wa_rm1-csqrt1 = aprsale + maysale + junsale.
*    wa_rm1-ctqrt1 = aprtar + maytar + juntar.
*************************************
    read table it_cummsr2_rm into wa_cummsr2_rm with key bzirk = wa_tab6-bzirk.  "CURRENT  YEAR CUMMULATIVE SALE FROM ZRCUMPSO.
    if sy-subrc eq 0.
      wa_rm1-cummsr = wa_cummsr2_rm-ccumm_sale.
    endif.

************ CURRENT MONTH TARGET*************
    read table it_cmtar into wa_cmtar with key bzirk = wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_rm1-ctar = wa_cmtar-ctar.
    endif.

    read table it_lcumms1 into wa_lcumms1 with key bzirk = wa_tab6-bzirk.  "last year cummulative sale.
    if sy-subrc eq 0.
      wa_rm1-lcumms = wa_lcumms1-lcumm_sale.
    endif.

    read table it_cumms2_rm into wa_cumms2_rm with key bzirk = wa_tab6-bzirk.  "CURRENT year cummulative sale.
    if sy-subrc eq 0.
      wa_rm1-cumms = wa_cumms2_rm-ccumm_sale.
    endif.

    read table it_ccyt1_rm into wa_ccyt1_rm with key bzirk = wa_tab6-bzirk.  "CURRENT year cummulative TARGET.
    if sy-subrc eq 0.
      wa_rm1-cummt = wa_ccyt1_rm-cyt.
    endif.

    collect wa_rm1 into it_rm1.
    clear wa_rm1.
  endloop.
****************************************************************************************************************************
  clear: it_pa0001a1,wa_pa0001a1.
  if it_rm1 is not initial.
    select * from pa0001 into table it_pa0001a1 for all entries in it_rm1 where plans eq it_rm1-plans.
  endif.
  sort it_pa0001a1 descending by endda.

  loop at it_rm1 into wa_rm1 .
    clear : lpqrt1,lpqrt2,lpqrt1,lpqrt3,lpqrt4,lcumm,lgrw,pjoin_dt,incrdt,ltqrt,llsqrt,lsqrt,
            cpqrt1,cpqrt2,cpqrt1,cpqrt3,cpqrt4,ccumm,cgrw, cp1,cp2,cp3,csqrt1,ctqrt1,csqrt2,ctqrt2,csqrt3,ctqrt3,csqrt4,ctqrt4,
            ls1,ls2,ls3,ls4,lsc1,lsc2,lsc3,lsc4, cs1,cs2,cs3,cs4,lysale, cysale,lysalec,prom, sl1,sl2,sl3.

    wa_rm3-reg = wa_rm1-reg.
    wa_rm3-zm = wa_rm1-zm.
    wa_rm3-zmpernr = wa_rm1-zmpernr.
    wa_rm3-rm = wa_rm1-rm.
    wa_rm3-rmpernr = wa_rm1-rmpernr.

    select single * from pa0302 where pernr eq wa_rm1-rmpernr and massn eq '01'.
    if sy-subrc eq 0.
      concatenate pa0302-begda+4(2) '/' pa0302-begda+0(4) into pjoin_dt.
      wa_rm3-join_dt = pjoin_dt.
      wa_rm3-join_date = pa0302-begda.
    endif.

    if  wa_rm3-join_dt eq space.  "added on 16.7.24
      clear : pjoin_dt.
      read table it_pa0001a1 into wa_pa0001a1 with key plans = wa_rm3-plans.
      if sy-subrc eq 0.
        select single * from pa0302 where pernr eq wa_pa0001a1-pernr and massn eq '10'.
        if sy-subrc eq 0.
          concatenate pa0302-begda+4(2) '/' pa0302-begda+0(4) into pjoin_dt.
          wa_rm3-join_dt = pjoin_dt.
        endif.

*      BREAK-POINT .
        if  wa_rm3-join_dt eq space.
          concatenate wa_pa0001a1-endda+4(2) '/' wa_pa0001a1-endda+0(4) into pjoin_dt.
          wa_rm3-join_dt = pjoin_dt.
        endif.
      endif.
    endif.

    if  wa_rm3-join_dt eq space or wa_rm3-join_dt+3(4) ge '2999'.
      concatenate '04' '/' '2024' into wa_rm3-join_dt .  "added on 16.7.24
    endif.


**************** LAST YEAR SALE PERFORMANVE ***********
***************** 1ST QRT *****************
    clear : aprsale,maysale,junsale,julsale,augsale,sepsale,octsale,novsale,decsale,jansale,febsale,marsale.
    clear : aprtar,maytar,juntar,jultar,augtar,septar,octtar,novtar,dectar,jantar,febtar,martar.

    loop at it_lapr into wa_lapr where zm = wa_rm1-reg and rm = wa_rm1-rm.
      aprsale = aprsale +  wa_lapr-netval.
      aprtar = aprtar + wa_lapr-tar.
    endloop.
    loop at it_lmay into wa_lmay where zm = wa_rm1-reg and rm = wa_rm1-rm.
      maysale = maysale +  wa_lmay-netval.
      maytar = maytar + wa_lmay-tar.
    endloop.
    loop at it_ljun into wa_ljun where zm = wa_rm1-reg and rm = wa_rm1-rm.
      junsale = junsale +  wa_ljun-netval.
      juntar = juntar + wa_ljun-tar.
    endloop.
    wa_rm1-lsqrt1 = aprsale + maysale + junsale.
    wa_rm1-ltqrt1 = aprtar + maytar + juntar.
****************2ND QRT *******************
    loop at it_ljul into wa_ljul where zm = wa_rm1-reg and rm = wa_rm1-rm.
      julsale = julsale +  wa_ljul-netval.
      jultar = jultar + wa_ljul-tar.
    endloop.
    loop at it_laug into wa_laug where zm = wa_rm1-reg and rm = wa_rm1-rm.
      augsale = augsale +  wa_laug-netval.
      augtar = augtar + wa_laug-tar.
    endloop.
    loop at it_lsep into wa_lsep where zm = wa_rm1-reg and rm = wa_rm1-rm.
      sepsale = sepsale +  wa_lsep-netval.
      septar = septar + wa_lsep-tar.
    endloop.
    wa_rm1-lsqrt2 = julsale + augsale + sepsale.
    wa_rm1-ltqrt2 = jultar + augtar + septar.
****************3rd QRT *******************
    loop at it_loct into wa_loct where zm = wa_rm1-reg and rm = wa_rm1-rm.
      octsale = octsale +  wa_loct-netval.
      octtar = octtar + wa_loct-tar.
    endloop.
    loop at it_lnov into wa_lnov where zm = wa_rm1-reg and rm = wa_rm1-rm.
      novsale = novsale +  wa_lnov-netval.
      novtar = novtar + wa_lnov-tar.
    endloop.
    loop at it_ldec into wa_ldec where zm = wa_rm1-reg and rm = wa_rm1-rm.
      decsale = decsale +  wa_ldec-netval.
      dectar = dectar + wa_ldec-tar.
    endloop.
    wa_rm1-lsqrt3 = octsale + novsale + decsale.
    wa_rm1-ltqrt3 = octtar + novtar + dectar.

****************4TH QRT *******************
    loop at it_ljan into wa_ljan where zm = wa_rm1-reg and rm = wa_rm1-rm.
      jansale = jansale +  wa_ljan-netval.
      jantar = jantar + wa_ljan-tar.
    endloop.
    loop at it_lfeb into wa_lfeb where zm = wa_rm1-reg and rm = wa_rm1-rm.
      febsale = febsale +  wa_lfeb-netval.
      febtar = febtar + wa_lfeb-tar.
    endloop.
    loop at it_lmar into wa_lmar where zm = wa_rm1-reg and rm = wa_rm1-rm.
      marsale = marsale +  wa_lmar-netval.
      martar = martar + wa_lmar-tar.
    endloop.
    wa_rm1-lsqrt4 = jansale + febsale + marsale.
    wa_rm1-ltqrt4 = jantar + febtar + martar.

**************************************************
    if wa_rm1-ltqrt1 gt 0.
      lpqrt1 = ( wa_rm1-lsqrt1 / wa_rm1-ltqrt1 ) * 100.
    endif.
    if wa_rm1-ltqrt2 gt 0.
      lpqrt2 = ( wa_rm1-lsqrt2 / wa_rm1-ltqrt2 ) * 100.
    endif.
    if wa_rm1-ltqrt3 gt 0.
      lpqrt3 = ( wa_rm1-lsqrt3 / wa_rm1-ltqrt3 ) * 100.
    endif.
    if wa_rm1-ltqrt4 gt 0.
      lpqrt4 = ( wa_rm1-lsqrt4 / wa_rm1-ltqrt4 ) * 100.
    endif.
    wa_rm3-lpqrt1 = lpqrt1.
    wa_rm3-lpqrt2 = lpqrt2.
    wa_rm3-lpqrt3 = lpqrt3.
    wa_rm3-lpqrt4 = lpqrt4.

    ls1 = wa_rm1-lsqrt1 / 1000.
    ls2 = wa_rm1-lsqrt2 / 1000.
    ls3 = wa_rm1-lsqrt3 / 1000.
    ls4 = wa_rm1-lsqrt4 / 1000.

    wa_rm3-lysale1 = ls1.
    wa_rm3-lysale2 = ls2.
    wa_rm3-lysale3 = ls3.
    wa_rm3-lysale4 = ls4.
    lysale = ls1 + ls2 + ls3 + ls4.
    wa_rm3-lysale = lysale.

    lsc1 = wa_rm1-lsqrtc1 / 1000.
    lsc2 = wa_rm1-lsqrtc2 / 1000.
    lsc3 = wa_rm1-lsqrtc3 / 1000.
    lsc4 = wa_rm1-lsqrtc4 / 1000.
    wa_rm3-lysalec1 = lsc1.
    wa_rm3-lysalec2 = lsc2.
    wa_rm3-lysalec3 = lsc3.
    wa_rm3-lysalec4 = lsc4.
    lysalec = lsc1 + lsc2 + lsc3 + lsc4.
    wa_rm3-lysalec = lysalec.
************ LAST YEAR CUMMULATIVE***********
    ltqrt = wa_rm1-ltqrt1 + wa_rm1-ltqrt2 + wa_rm1-ltqrt3 + wa_rm1-ltqrt4 .
    if ltqrt gt 0.
      lcumm = ( ( wa_rm1-lsqrt1 + wa_rm1-lsqrt2 + wa_rm1-lsqrt3 + wa_rm1-lsqrt4 ) / ltqrt ) * 100.
    endif.
    wa_rm3-lcumm = lcumm.
********************** LAST YEAR GROWTH ******************
    llsqrt = wa_rm1-llsqrt1 + wa_rm1-llsqrt2 + wa_rm1-llsqrt3 + wa_rm1-llsqrt4.
    if llsqrt gt 0.
      lgrw = ( ( wa_rm1-lsqrt1 + wa_rm1-lsqrt2 + wa_rm1-lsqrt3 + wa_rm1-lsqrt4 ) / llsqrt ) * 100 - 100.
    else.
      lgrw = 100.
    endif.
    wa_rm3-lgrw = lgrw.
***************** 1ST QRT *****************
    clear : aprsale,maysale,junsale,julsale,augsale,sepsale,octsale,novsale,decsale,jansale,febsale,marsale.
    clear : aprtar,maytar,juntar,jultar,augtar,septar,octtar,novtar,dectar,jantar,febtar,martar.

*    LOOP AT it_apr INTO wa_apr WHERE zm = wa_rm1-reg AND rm = wa_rm1-rm.
*      aprsale = aprsale +  wa_apr-netval.
*      aprtar = aprtar + wa_apr-tar.
*    ENDLOOP.
*    LOOP AT it_may INTO wa_may WHERE zm = wa_rm1-reg AND rm = wa_rm1-rm.
*      maysale = maysale +  wa_may-netval.
*      maytar = maytar + wa_may-tar.
*    ENDLOOP.
*    LOOP AT it_jun INTO wa_jun WHERE zm = wa_rm1-reg AND rm = wa_rm1-rm.
*      junsale = junsale +  wa_jun-netval.
*      juntar = juntar + wa_jun-tar.
*    ENDLOOP.
*    wa_rm1-csqrt1 = aprsale + maysale + junsale.
*    wa_rm1-ctqrt1 = aprtar + maytar + juntar.
****************2ND QRT *******************
*    LOOP AT it_jul INTO wa_jul WHERE zm = wa_rm1-reg AND rm = wa_rm1-rm.
*      julsale = julsale +  wa_jul-netval.
*      jultar = jultar + wa_jul-tar.
*    ENDLOOP.
*    LOOP AT it_aug INTO wa_aug WHERE zm = wa_rm1-reg AND rm = wa_rm1-rm.
*      augsale = augsale +  wa_aug-netval.
*      augtar = augtar + wa_aug-tar.
*    ENDLOOP.
*    LOOP AT it_sep INTO wa_sep WHERE zm = wa_rm1-reg AND rm = wa_rm1-rm.
*      sepsale = sepsale +  wa_sep-netval.
*      septar = septar + wa_sep-tar.
*    ENDLOOP.
*    wa_rm1-csqrt2 = julsale + augsale + sepsale.
*    wa_rm1-ctqrt2 = jultar + augtar + septar.
****************3rd QRT *******************
*    LOOP AT it_oct INTO wa_oct WHERE zm = wa_rm1-reg AND rm = wa_rm1-rm.
*      octsale = octsale +  wa_oct-netval.
*      octtar = octtar + wa_oct-tar.
*    ENDLOOP.
*    LOOP AT it_nov INTO wa_nov WHERE zm = wa_rm1-reg AND rm = wa_rm1-rm.
*      novsale = novsale +  wa_nov-netval.
*      novtar = novtar + wa_nov-tar.
*    ENDLOOP.
*    LOOP AT it_dec INTO wa_dec WHERE zm = wa_rm1-reg AND rm = wa_rm1-rm.
*      decsale = decsale +  wa_dec-netval.
*      dectar = dectar + wa_dec-tar.
*    ENDLOOP.
*    wa_rm1-csqrt3 = octsale + novsale + decsale.
*    wa_rm1-ctqrt3 = octtar + novtar + dectar.

****************4TH QRT *******************
*    LOOP AT it_jan INTO wa_jan WHERE zm = wa_rm1-reg AND rm = wa_rm1-rm.
*      jansale = jansale +  wa_jan-netval.
*      jantar = jantar + wa_jan-tar.
*    ENDLOOP.
*    LOOP AT it_feb INTO wa_feb WHERE zm = wa_rm1-reg AND rm = wa_rm1-rm.
*      febsale = febsale +  wa_feb-netval.
*      febtar = febtar + wa_feb-tar.
*    ENDLOOP.
*    LOOP AT it_mar INTO wa_mar WHERE zm = wa_rm1-reg AND rm = wa_rm1-rm.
*      marsale = marsale +  wa_mar-netval.
*      martar = martar + wa_mar-tar.
*    ENDLOOP.
*    wa_rm1-csqrt4 = jansale + febsale + marsale.
*    wa_rm1-ctqrt4 = jantar + febtar + martar.

************* CURRENT MONTH TARGET************

    wa_rm3-ctar = wa_rm1-ctar .

**************** CURRENT YEAR SALE PERFORMANVE ***********

    if date2 ge f3date.
      read table it_rm11 into wa_rm11 with key rm = wa_rm1-rm.
      if sy-subrc eq 0.
        wa_rm3-csqrt1 = wa_rm11-m1 + wa_rm11-m2 + wa_rm11-m3.
        wa_rm3-cysale1 = wa_rm3-csqrt1 / 1000.
      endif.
      read table it_rmt1 into wa_rmt1 with key rm = wa_rm1-rm.
      if sy-subrc eq 0.
        wa_rm3-ctqrt1 = wa_rmt1-t1 .
      endif.
      if  wa_rm3-ctqrt1 >  0.
        cpqrt1 = ( wa_rm3-csqrt1 / wa_rm3-ctqrt1 ) * 100.
      else.
        cpqrt1 = 0.
      endif.
    endif.

    if date2 ge f6date.
      read table it_rm11 into wa_rm11 with key rm = wa_rm1-rm.
      if sy-subrc eq 0.
        wa_rm3-csqrt2 = wa_rm11-m4 + wa_rm11-m5 + wa_rm11-m6.
        wa_rm3-cysale2 = wa_rm3-csqrt2 / 1000.
      endif.
      read table it_rmt1 into wa_rmt1 with key rm = wa_rm1-rm.
      if sy-subrc eq 0.
        wa_rm3-ctqrt2 = wa_rmt1-t2.
      endif.
      if wa_rm3-ctqrt2 > 0.
        cpqrt2 = ( wa_rm3-csqrt2 / wa_rm3-ctqrt2 ) * 100.
      else.
        cpqrt2 =  0.
      endif.
    endif.
    if date2 ge f9date.
      read table it_rm11 into wa_rm11 with key rm = wa_rm1-rm.
      if sy-subrc eq 0.
        wa_rm3-csqrt3 = wa_rm11-m7 + wa_rm11-m8 + wa_rm11-m9.
        wa_rm3-cysale3 = wa_rm3-csqrt3 / 1000.
      endif.
      read table it_rmt1 into wa_rmt1 with key rm = wa_rm1-rm.
      if sy-subrc eq 0.
        wa_rm3-ctqrt3 = wa_rmt1-t1.
      endif.
      if wa_rm3-ctqrt3 > 0.
        cpqrt3 = ( wa_rm3-csqrt3 / wa_rm3-ctqrt3 ) * 100.
      else.
        cpqrt3 = 0.
      endif.
    endif.
    if date2 ge f12date.
      read table it_rm11 into wa_rm11 with key rm = wa_rm1-rm.
      if sy-subrc eq 0.
        wa_rm3-csqrt4 = wa_rm11-m10 + wa_rm11-m11 + wa_rm11-m12.
        wa_rm3-cysale4 = wa_rm3-csqrt4 / 1000.
      endif.
      read table it_rmt1 into wa_rmt1 with key rm = wa_rm1-rm.
      if sy-subrc eq 0.
        wa_rm3-ctqrt4 = wa_rmt1-t4.
      endif.
      if wa_rm3-ctqrt4  > 0.
        cpqrt4 = ( wa_rm3-csqrt4 / wa_rm3-ctqrt4 ) * 100.
      else.
        cpqrt4 =  0.
      endif.
    endif.

    wa_rm3-cpqrt1 = cpqrt1.
    wa_rm3-cpqrt2 = cpqrt2.
    wa_rm3-cpqrt3 = cpqrt3.
    wa_rm3-cpqrt4 = cpqrt4.


*    IF date2 GE f3date.
*      cs1 = wa_rm1-csqrt1 / 1000.
*    ENDIF.
*    IF date2 GE f6date.
*      cs2 = wa_rm1-csqrt2 / 1000.
*    ENDIF.
*    IF date2 GE f9date.
*      cs3 = wa_rm1-csqrt3 / 1000.
*    ENDIF.
*    IF date2 GE f12date.
*      cs4 = wa_rm1-csqrt4 / 1000.
*    ENDIF.

*    wa_rm3-cysale1 = cs1.
*    wa_rm3-cysale2 = cs2.
*    wa_rm3-cysale3 = cs3.
*    wa_rm3-cysale4 = cs4.
*    cysale = cs1 + cs2 + cs3 + cs4.
*    cysale = ( wa_rm1-csqrt1 + wa_rm1-csqrt2 + wa_rm1-csqrt3 + wa_rm1-csqrt4 ) / 1000.
*    cysale = ( cs1 + cs2 + cs3 + cs4 ).

*************logic for cummulative************************
    clear : v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12.
    if wa_rm3-join_date le f1date.
      if date2 ge f1date.
        v1 = aprsale.
      endif.
    endif.
    if wa_rm3-join_date le f2date.
      if date2 ge f2date.
        v2 = maysale.
      endif.
    endif.
    if wa_rm3-join_date le f3date.
      if date2 ge f3date.
        v3 = junsale.
      endif.
    endif.
    if wa_rm3-join_date le f4date.
      if date2 ge f4date.
        v4 = julsale.
      endif.
    endif.
    if wa_rm3-join_date le f5date.
      if date2 ge f5date.
        v5 = augsale.
      endif.
    endif.
    if wa_rm3-join_date le f6date.
      if date2 ge f6date.
        v6 = sepsale.
      endif.
    endif.
    if wa_rm3-join_date le f7date.
      if date2 ge f7date.
        v7 = octsale.
      endif.
    endif.
    if wa_rm3-join_date le f8date.
      if date2 ge f8date.
        v8 = novsale.
      endif.
    endif.
    if wa_rm3-join_date le f9date.
      if date2 ge f9date.
        v9 = decsale.
      endif.
    endif.
    if wa_rm3-join_date le f10date.
      if date2 ge f10date.
        v10 = jansale.
      endif.
    endif.
    if wa_rm3-join_date le f11date.
      if date2 ge f11date.
        v11 = febsale.
      endif.
    endif.
    if wa_rm3-join_date le f12date.
      if date2 ge f12date.
        v12 = marsale.
      endif.
    endif.
    cysale = ( v1 + v2 + v3 + v4 + v5 + v6 + v7 + v8 + v9 + v10 + v11 + v12 ) / 1000.
**************************************************************
    wa_rm3-cysale = cysale.

************ CURRENT YEAR CUMMULATIVE***********
    if wa_rm1-cummt gt 0.
      ccumm = ( wa_rm1-cumms / wa_rm1-cummt ) * 100.
    endif.
    wa_rm3-ccumm = ccumm.
********************** CURRENT YEAR GROWTH ******************
*    IF WA_RM1-LCUMMS GT 0.
*      CGRW = ( wa_RM1-CUMMS / WA_RM1-LCUMMS ) * 100 - 100.
*    ENDIF.
*    WA_RM3-CGRW = CGRW.
    if wa_rm1-lcummsr gt 0.
      cgrw = ( wa_rm1-cummsr / wa_rm1-lcummsr ) * 100 - 100.
    else.
      cgrw = 100.
    endif.
    wa_rm3-cgrw = cgrw.

**********CURRENT MONTH, LAST MONTH & LAST TO LAST MONTH PERFORMANCE******
    if wa_rm1-t1 gt 0.
      cp1 = ( wa_rm1-c1sale / wa_rm1-t1 ) * 100.
    endif.
    if wa_rm1-t2 gt 0.
      cp2 = ( wa_rm1-c2sale / wa_rm1-t2 ) * 100.
    endif.
    if wa_rm1-t3 gt 0.
      cp3 = ( wa_rm1-c3sale / wa_rm1-t3 ) * 100.
    endif.
    wa_rm3-cp1 = cp1.
    wa_rm3-cp2 = cp2.
    wa_rm3-cp3 = cp3.

    sl1 = wa_rm1-c1sale / 1000.
    sl2 = wa_rm1-c2sale / 1000.
    sl3 = wa_rm1-c3sale / 1000.
    wa_rm3-c1sale = sl1.
    wa_rm3-c2sale = sl2.
    wa_rm3-c3sale = sl3.
**********************************************************
    select single * from zdrphq where bzirk eq wa_rm1-rm.
    if sy-subrc eq 0.
      select single * from  zthr_heq_des where zz_hqcode eq zdrphq-zz_hqcode.
      if sy-subrc eq 0.
        wa_rm3-zz_hqdesc =  zthr_heq_des-zz_hqdesc.
      endif.
    endif.
    select single * from pa0001 where pernr eq wa_rm1-rmpernr and endda ge date2.
    if sy-subrc eq 0.
      wa_rm3-ename = pa0001-ename.
      select single * from zfsdes where persk eq pa0001-persk.
      if sy-subrc eq 0.
        wa_rm3-short = zfsdes-short.
      endif.
    else.
      wa_rm3-ename = 'VACANT (Since)'.
      wa_rm3-short = 'RM'.
    endif.


    read table it_tab5 into wa_tab5 with key reg = wa_rm1-reg rm = wa_rm1-rm div = 'BCL'.
    if sy-subrc eq 0.
      div = 'BCL'.
    else.
      read table it_tab5 into wa_tab5 with key reg = wa_rm1-reg rm = wa_rm1-rm div = 'BC'.
      if sy-subrc eq 0.
        read table it_tab5 into wa_tab5 with key reg = wa_rm1-reg rm = wa_rm1-rm div = 'XL'.
        if sy-subrc eq 0.
          div = 'BCL'.
        else.
          div = 'BC'.
        endif.
      else.
        read table it_tab5 into wa_tab5 with key reg = wa_rm1-reg rm = wa_rm1-rm div = 'LS'.
        if sy-subrc eq 0.
          div = 'LS'.
        else.
          div = 'XL'.
        endif.
      endif.
    endif.
    wa_rm3-div = div.
    read table it_pa0000_rm into wa_pa0000_rm with key pernr = wa_rm1-rmpernr. "RM PROMOTION
    if sy-subrc eq 0.
      concatenate wa_pa0000_rm-begda+4(2) '/' wa_pa0000_rm-begda+0(4) into prom.
      wa_rm3-prom = prom.
*      wa_RM3-prom1 = 'L-PROM'.
    endif.

***********************************************************
    collect wa_rm3 into it_rm3.
    clear wa_rm3.
  endloop.



  loop at it_rm3 into wa_rm3 .
    clear : sl2,sl3,cp3,cp2,cum1,cum2,ccumm, cums, lcums, cgrw.

    clear : cp2,cp3, cums,lcums,cgrw,cum1,cum2,ccumm.
    clear : lpqrt1,ls1,lt1, lpqrt2,ls2,lt2, lpqrt3,ls3,lt3, lpqrt4,ls4,lt4.
    clear : lls1,lls2,lls3,lls4.
    clear : lycs,lyct,lcumm, csl1,cst1,cpqrt1, csl2,cst2,cpqrt2, csl3,cst3,cpqrt3, csl4,cst4,cpqrt4.
    clear : c1,c2,c3,c4, c5.
    clear : lsale,llsale, lgrw, l1.

    wa_rm2-reg = wa_rm3-reg.
    wa_rm2-zm = wa_rm3-zm.
    wa_rm2-zmpernr = wa_rm3-zmpernr.
    wa_rm2-rm = wa_rm3-rm.
    wa_rm2-rmpernr = wa_rm3-rmpernr.

*    **************** LAST YEAR SALE PERFORMANVE ***********
    read table it_rll1dums into wa_rll1dums with key bzirk = wa_rm3-rm.
    if sy-subrc eq 0.
      read table it_lrm11 into wa_lrm11 with key rm = wa_rm3-rm.
      if sy-subrc eq 0.
        if wa_rll1dums-aprsale eq 0.
          wa_rll1dums-aprsale = wa_lrm11-m1.
        endif.
        if wa_rll1dums-maysale eq 0.
          wa_rll1dums-maysale = wa_lrm11-m2.
        endif.
        if wa_rll1dums-junsale eq 0.
          wa_rll1dums-junsale = wa_lrm11-m3.
        endif.
        if wa_rll1dums-julsale eq 0.
          wa_rll1dums-julsale = wa_lrm11-m4.
        endif.
        if wa_rll1dums-augsale eq 0.
          wa_rll1dums-augsale = wa_lrm11-m5.
        endif.
        if wa_rll1dums-sepsale eq 0.
          wa_rll1dums-sepsale = wa_lrm11-m6.
        endif.
        if wa_rll1dums-octsale eq 0.
          wa_rll1dums-octsale = wa_lrm11-m7.
        endif.
        if wa_rll1dums-novsale eq 0.
          wa_rll1dums-novsale = wa_lrm11-m8.
        endif.
        if wa_rll1dums-decsale eq 0.
          wa_rll1dums-decsale = wa_lrm11-m9.
        endif.
        if wa_rll1dums-jansale eq 0.
          wa_rll1dums-jansale = wa_lrm11-m10.
        endif.
        if wa_rll1dums-febsale eq 0.
          wa_rll1dums-febsale = wa_lrm11-m11.
        endif.
        if wa_rll1dums-marsale eq 0.
          wa_rll1dums-marsale = wa_lrm11-m12.
        endif.
      endif.
    else.

      read table it_lrm11 into wa_lrm11 with key rm = wa_rm3-rm.
      if sy-subrc eq 0.
        wa_rll1dums-aprsale = wa_lrm11-m1.
        wa_rll1dums-maysale = wa_lrm11-m2.
        wa_rll1dums-junsale = wa_lrm11-m3.
        wa_rll1dums-julsale = wa_lrm11-m4.
        wa_rll1dums-augsale = wa_lrm11-m5.
        wa_rll1dums-sepsale = wa_lrm11-m6.
        wa_rll1dums-octsale = wa_lrm11-m7.
        wa_rll1dums-novsale = wa_lrm11-m8.
        wa_rll1dums-decsale = wa_lrm11-m9.
        wa_rll1dums-jansale = wa_lrm11-m10.
        wa_rll1dums-febsale = wa_lrm11-m11.
        wa_rll1dums-marsale = wa_lrm11-m12.
      endif.
    endif.

*    ENDIF.
    lycs = wa_rll1dums-aprsale + wa_rll1dums-maysale + wa_rll1dums-junsale + wa_rll1dums-julsale + wa_rll1dums-augsale + wa_rll1dums-sepsale +
           wa_rll1dums-octsale + wa_rll1dums-novsale + wa_rll1dums-decsale + wa_rll1dums-jansale + wa_rll1dums-febsale + wa_rll1dums-marsale.

    lsale = wa_rll1dums-aprsale + wa_rll1dums-maysale + wa_rll1dums-junsale + wa_rll1dums-julsale + wa_rll1dums-augsale + wa_rll1dums-sepsale +
           wa_rll1dums-octsale + wa_rll1dums-novsale + wa_rll1dums-decsale + wa_rll1dums-jansale + wa_rll1dums-febsale + wa_rll1dums-marsale.

    ls1 = ( wa_rll1dums-aprsale + wa_rll1dums-maysale + wa_rll1dums-junsale ) / 1000.
    wa_rm2-lysale1 = ls1.
    ls2 = ( wa_rll1dums-julsale + wa_rll1dums-augsale + wa_rll1dums-sepsale ) / 1000.
    wa_rm2-lysale2 = ls2.
    ls3 = ( wa_rll1dums-octsale + wa_rll1dums-novsale + wa_rll1dums-decsale ) / 1000.
    wa_rm2-lysale3 = ls3.
    ls4 = ( wa_rll1dums-jansale + wa_rll1dums-febsale + wa_rll1dums-marsale ) / 1000.
    wa_rm2-lysale4 = ls4.
    wa_rm2-lysale = wa_rm2-lysale1 + wa_rm2-lysale2 + wa_rm2-lysale3 + wa_rm2-lysale4.


    read table it_rll1tdums into wa_rll1tdums with key bzirk = wa_rm3-rm.
    if sy-subrc eq 0.
      read table it_lrmt1 into wa_lrmt1 with key rm = wa_rm3-rm.
      if sy-subrc eq 0.
        if wa_rll1tdums-aprsale eq 0.
          wa_rll1tdums-aprsale = wa_lrmt1-t1.
        endif.
        if wa_rll1tdums-maysale eq 0.
          wa_rll1tdums-maysale = wa_lrmt1-t2.
        endif.
        if wa_rll1tdums-junsale eq 0.
          wa_rll1tdums-junsale = wa_lrmt1-t3.
        endif.
        if wa_rll1tdums-julsale eq 0.
          wa_rll1tdums-julsale = wa_lrmt1-t4.
        endif.
        if wa_rll1tdums-augsale eq 0.
          wa_rll1tdums-augsale = wa_lrmt1-t5.
        endif.
        if wa_rll1tdums-sepsale eq 0.
          wa_rll1tdums-sepsale = wa_lrmt1-t6.
        endif.
        if wa_rll1tdums-octsale eq 0.
          wa_rll1tdums-octsale = wa_lrmt1-t7.
        endif.
        if wa_rll1tdums-novsale eq 0.
          wa_rll1tdums-novsale = wa_lrmt1-t8.
        endif.
        if wa_rll1tdums-decsale eq 0.
          wa_rll1tdums-decsale = wa_lrmt1-t9.
        endif.
        if wa_rll1tdums-jansale eq 0.
          wa_rll1tdums-jansale = wa_lrmt1-t10.
        endif.
        if wa_rll1tdums-febsale eq 0.
          wa_rll1tdums-febsale = wa_lrmt1-t11.
        endif.
        if wa_rll1tdums-marsale eq 0.
          wa_rll1tdums-marsale = wa_lrmt1-t12.
        endif.
      endif.
    else.

      read table it_lrmt1 into wa_lrmt1 with key rm = wa_rm3-rm.
      if sy-subrc eq 0.
        wa_rll1tdums-aprsale = wa_lrmt1-t1.
        wa_rll1tdums-maysale = wa_lrmt1-t2.
        wa_rll1tdums-junsale = wa_lrmt1-t3.
        wa_rll1tdums-julsale = wa_lrmt1-t4.
        wa_rll1tdums-augsale = wa_lrmt1-t5.
        wa_rll1tdums-sepsale = wa_lrmt1-t6.
        wa_rll1tdums-octsale = wa_lrmt1-t7.
        wa_rll1tdums-novsale = wa_lrmt1-t8.
        wa_rll1tdums-decsale = wa_lrmt1-t9.
        wa_rll1tdums-jansale = wa_lrmt1-t10.
        wa_rll1tdums-febsale = wa_lrmt1-t11.
        wa_rll1tdums-marsale = wa_lrmt1-t12.
      endif.
    endif.
    lyct = wa_rll1tdums-aprsale + wa_rll1tdums-maysale + wa_rll1tdums-junsale + wa_rll1tdums-julsale + wa_rll1tdums-augsale + wa_rll1tdums-sepsale +
           wa_rll1tdums-octsale + wa_rll1tdums-novsale + wa_rll1tdums-decsale + wa_rll1tdums-jansale + wa_rll1tdums-febsale + wa_rll1tdums-marsale.

    lt1 = ( wa_rll1tdums-aprsale + wa_rll1tdums-maysale + wa_rll1tdums-junsale ) / 1000.
    lt2 = ( wa_rll1tdums-julsale + wa_rll1tdums-augsale + wa_rll1tdums-sepsale ) / 1000.
    lt3 = ( wa_rll1tdums-octsale + wa_rll1tdums-novsale + wa_rll1tdums-decsale ) / 1000.
    lt4 = ( wa_rll1tdums-jansale + wa_rll1tdums-febsale + wa_rll1tdums-marsale ) / 1000.


    if lt1 gt 0.
      lpqrt1 = ( ls1 / lt1 ) * 100.
    endif.
    wa_rm2-lpqrt1 = lpqrt1.
    if lt2 gt 0.
      lpqrt2 = ( ls2 / lt2 ) * 100.
    endif.
    wa_rm2-lpqrt2 = lpqrt2.
    if lt3 gt 0.
      lpqrt3 = ( ls3 / lt3 ) * 100.
    endif.
    wa_rm2-lpqrt3 = lpqrt3.
    if lt4 gt 0.
      lpqrt4 = ( ls4 / lt4 ) * 100.
    endif.
    wa_rm2-lpqrt4 = lpqrt4.

    if lyct gt 0.
      lcumm = ( lycs / lyct ) * 100.
    endif.
    wa_rm2-lcumm = lcumm.


******************* check follow***


    read table it_rl1dums into wa_rl1dums with key bzirk = wa_rm3-rm.
    if sy-subrc eq 0.
      read table it_rdlapr into wa_rdlapr with key bzirk = wa_rm3-rm.
      if sy-subrc eq 0.

        read table it_r1l1aprcs1 into wa_r1l1aprcs1 with key bzirk = wa_rm3-rm.
        if sy-subrc eq 0.
          wa_rl1dums-aprsale = wa_r1l1aprcs1-aprsale.
          wa_rl1dums-maysale = wa_r1l1aprcs1-maysale.
          wa_rl1dums-junsale = wa_r1l1aprcs1-junsale.
          wa_rl1dums-julsale = wa_r1l1aprcs1-julsale.
          wa_rl1dums-augsale = wa_r1l1aprcs1-augsale.
          wa_rl1dums-sepsale = wa_r1l1aprcs1-sepsale.
          wa_rl1dums-octsale = wa_r1l1aprcs1-octsale.
          wa_rl1dums-novsale = wa_r1l1aprcs1-novsale.
          wa_rl1dums-decsale = wa_r1l1aprcs1-decsale.
          wa_rl1dums-jansale = wa_r1l1aprcs1-jansale.
          wa_rl1dums-febsale = wa_r1l1aprcs1-febsale.
          wa_rl1dums-marsale = wa_r1l1aprcs1-marsale.
        endif.
*        IF DATE2 LT F1DATE.
*          WA_RL1DUMS-APRSALE = WA_RDLAPR-APRSALE.
*        ENDIF.
*        IF DATE2 LT F2DATE.
*          WA_RL1DUMS-MAYSALE = WA_RDLAPR-MAYSALE.
*        ENDIF.
*        IF DATE2 LT F3DATE.
*          WA_RL1DUMS-JUNSALE = WA_RDLAPR-JUNSALE.
*        ENDIF.
*        IF DATE2 LT F4DATE.
*          WA_RL1DUMS-JULSALE = WA_RDLAPR-JULSALE.
*        ENDIF.
*        IF DATE2 LT F5DATE.
*          WA_RL1DUMS-AUGSALE = WA_RDLAPR-AUGSALE.
*        ENDIF.
*        IF DATE2 LT F6DATE.
*          WA_RL1DUMS-SEPSALE = WA_RDLAPR-SEPSALE.
*        ENDIF.
*        IF DATE2 LT F7DATE.
*          WA_RL1DUMS-OCTSALE = WA_RDLAPR-OCTSALE.
*        ENDIF.
*        IF DATE2 LT F8DATE.
*          WA_RL1DUMS-NOVSALE = WA_RDLAPR-NOVSALE.
*        ENDIF.
*        IF DATE2 LT F9DATE.
*          WA_RL1DUMS-DECSALE = WA_RDLAPR-DECSALE.
*        ENDIF.
*        IF DATE2 LT F10DATE.
*          WA_RL1DUMS-JANSALE = WA_RDLAPR-JANSALE.
*        ENDIF.
*        IF DATE2 LT F11DATE.
*          WA_RL1DUMS-FEBSALE = WA_RDLAPR-FEBSALE.
*        ENDIF.
*        IF DATE2 LT F12DATE.
*          WA_RL1DUMS-MARSALE = WA_RDLAPR-MARSALE.
*        ENDIF.

        lls1 = ( wa_rl1dums-aprsale + wa_rl1dums-maysale + wa_rl1dums-junsale ) / 1000.
        wa_rm2-lysalec1 = lls1.
*        IF wa_rm2-lysalec1 LE 0.
*          wa_rm2-lysalec1 = wa_rm3-lysalec1.
*        ENDIF.
        lls2 = ( wa_rl1dums-julsale + wa_rl1dums-augsale + wa_rl1dums-sepsale ) / 1000.
        wa_rm2-lysalec2 = lls2.
        if wa_rm2-lysalec2 le 0.
          wa_rm2-lysalec2 = wa_rm3-lysalec2.
        endif.
        lls3 = ( wa_rl1dums-octsale + wa_rl1dums-novsale + wa_rl1dums-decsale ) / 1000.
        wa_rm2-lysalec3 = lls3.
        if wa_rm2-lysalec3 le 0.
          wa_rm2-lysalec3 = wa_rm3-lysalec3.
        endif.
        lls4 = ( wa_rl1dums-jansale + wa_rl1dums-febsale + wa_rl1dums-marsale ) / 1000.
        wa_rm2-lysalec4 = lls4.
        if wa_rm2-lysalec4 le 0.
          wa_rm2-lysalec4 = wa_rm3-lysalec4.
        endif.
        wa_rm2-lysalec = wa_rm2-lysalec1 + wa_rm2-lysalec2 + wa_rm2-lysalec3 + wa_rm2-lysalec4.
      endif.
    endif.
************** check above**********



    read table it_ryll1dums into wa_ryll1dums with key bzirk = wa_rm3-rm.
    if sy-subrc eq 0.
      read table it_llrm11 into wa_llrm11 with key bzirk = wa_rm3-rm.
      if sy-subrc eq 0.
        if wa_ryll1dums-aprsale eq 0.
          wa_ryll1dums-aprsale = wa_llrm11-m1.
        endif.
        if wa_ryll1dums-maysale eq 0.
          wa_ryll1dums-maysale = wa_llrm11-m2.
        endif.
        if wa_ryll1dums-junsale eq 0.
          wa_ryll1dums-junsale = wa_llrm11-m3.
        endif.
        if wa_ryll1dums-julsale eq 0.
          wa_ryll1dums-julsale = wa_llrm11-m4.
        endif.
        if wa_ryll1dums-augsale eq 0.
          wa_ryll1dums-augsale = wa_llrm11-m5.
        endif.
        if wa_ryll1dums-sepsale eq 0.
          wa_ryll1dums-sepsale = wa_llrm11-m6.
        endif.
        if wa_ryll1dums-octsale eq 0.
          wa_ryll1dums-octsale = wa_llrm11-m7.
        endif.
        if wa_ryll1dums-novsale eq 0.
          wa_ryll1dums-novsale = wa_llrm11-m8.
        endif.
        if wa_ryll1dums-decsale eq 0.
          wa_ryll1dums-decsale = wa_llrm11-m9.
        endif.
        if wa_ryll1dums-jansale eq 0.
          wa_ryll1dums-jansale = wa_llrm11-m10.
        endif.
        if wa_ryll1dums-febsale eq 0.
          wa_ryll1dums-febsale = wa_llrm11-m11.
        endif.
        if wa_ryll1dums-marsale eq 0.
          wa_ryll1dums-marsale = wa_llrm11-m12.
        endif.
      endif.
    else.
      read table it_llrm11 into wa_llrm11 with key rm = wa_rm3-rm.
      if sy-subrc eq 0.
        wa_ryll1dums-aprsale = wa_llrm11-m1.
        wa_ryll1dums-maysale = wa_llrm11-m2.
        wa_ryll1dums-junsale = wa_llrm11-m3.
        wa_ryll1dums-julsale = wa_llrm11-m4.
        wa_ryll1dums-augsale = wa_llrm11-m5.
        wa_ryll1dums-sepsale = wa_llrm11-m6.
        wa_ryll1dums-octsale = wa_llrm11-m7.
        wa_ryll1dums-novsale = wa_llrm11-m8.
        wa_ryll1dums-decsale = wa_llrm11-m9.
        wa_ryll1dums-jansale = wa_llrm11-m10.
        wa_ryll1dums-febsale = wa_llrm11-m11.
        wa_ryll1dums-marsale = wa_llrm11-m12.
      endif.
    endif.
    llsale = wa_ryll1dums-aprsale + wa_ryll1dums-maysale + wa_ryll1dums-junsale + wa_ryll1dums-julsale + wa_ryll1dums-augsale + wa_ryll1dums-sepsale
    + wa_ryll1dums-octsale + wa_ryll1dums-novsale + wa_ryll1dums-decsale + wa_ryll1dums-jansale + wa_ryll1dums-febsale + wa_ryll1dums-marsale.


    if llsale gt 0.
      lgrw =  ( lsale / llsale ) * 100 - 100 .
    endif.
    wa_rm2-lgrw = lgrw.

************* CURRENT MONTH TARGET************
    wa_rm2-ctar = wa_rm3-ctar .
**************** CURRENT YEAR SALE PERFORMANVE ***********
*    wa_rm2-cpqrt1 = wa_rm3-cpqrt1.
*    wa_rm2-cpqrt2 = wa_rm3-cpqrt2.
*    wa_rm2-cpqrt3 = wa_rm3-cpqrt3.
*    wa_rm2-cpqrt4 = wa_rm3-cpqrt4.
*
*    wa_rm2-cysale1 = wa_rm3-cysale1.
*    wa_rm2-cysale2 = wa_rm3-cysale2.
*    wa_rm2-cysale3 = wa_rm3-cysale3.
*    wa_rm2-cysale4 = wa_rm3-cysale4.
*    wa_rm2-cysale = wa_rm3-cysale.

***********************************************************************************
    read table it_rdcums into wa_rdcums with key bzirk = wa_rm3-rm.
    if sy-subrc eq 0.
      read table it_rm11 into wa_rm11 with key rm = wa_rm3-rm.
      if sy-subrc eq 0.
        if wa_rdcums-aprsale eq 0.
          wa_rdcums-aprsale = wa_rm11-m1.
        endif.
        if wa_rdcums-maysale eq 0.
          wa_rdcums-maysale = wa_rm11-m2.
        endif.
        if wa_rdcums-junsale eq 0.
          wa_rdcums-junsale = wa_rm11-m3.
        endif.
      endif.
    else.
      read table it_rm11 into wa_rm11 with key rm = wa_rm3-rm.
      if sy-subrc eq 0.
        wa_rdcums-aprsale = wa_rm11-m1.
        wa_rdcums-maysale = wa_rm11-m2.
        wa_rdcums-junsale = wa_rm11-m3.
      endif.
    endif.
    csl1 = wa_rdcums-aprsale + wa_rdcums-maysale + wa_rdcums-junsale.
    if date2 ge f3date.
      c1 = csl1 / 1000.
    endif.
    wa_rm2-cysale1 = c1.


    read table it_rtdums into wa_rtdums with key bzirk = wa_rm2-rm.
    if sy-subrc eq 0.
      read table it_rmt1 into wa_rmt1 with key rm = wa_rm2-rm.
      if sy-subrc eq 0.
        if wa_rtdums-aprsale eq 0.
          wa_rtdums-aprsale = wa_rmt1-t1.
        endif.
        if wa_rtdums-maysale eq 0.
          wa_rtdums-maysale = wa_rmt1-t2.
        endif.
        if wa_rtdums-junsale eq 0.
          wa_rtdums-junsale = wa_rmt1-t3.
        endif.
      endif.
    else.
      read table it_rmt1 into wa_rmt1 with key rm = wa_rm2-rm.
      if sy-subrc eq 0.
        wa_rtdums-aprsale = wa_rmt1-t1.
        wa_rtdums-maysale = wa_rmt1-t2.
        wa_rtdums-junsale = wa_rmt1-t3.
      endif.
    endif.
    cst1 = wa_rtdums-aprsale + wa_rtdums-maysale + wa_rtdums-junsale.
    if cst1 ne 0.
      cpqrt1 = ( csl1 / cst1 ) * 100.
    endif.
    if date2 ge f3date.
      wa_rm2-cpqrt1 = cpqrt1.
      if  wa_rm2-cpqrt1 eq 0.
        wa_rm2-cpqrt1 =  wa_rm3-cpqrt1.
      endif.
    endif.

********************************
    read table it_rdcums into wa_rdcums with key bzirk = wa_rm3-rm.
    if sy-subrc eq 0.
      read table it_rm11 into wa_rm11 with key rm = wa_rm3-rm.
      if sy-subrc eq 0.
        if wa_rdcums-julsale eq 0.
          wa_rdcums-julsale = wa_rm11-m4.
        endif.
        if wa_rdcums-augsale eq 0.
          wa_rdcums-augsale = wa_rm11-m5.
        endif.
        if wa_rdcums-sepsale eq 0.
          wa_rdcums-sepsale = wa_rm11-m6.
        endif.
      endif.
    else.
      read table it_rm11 into wa_rm11 with key rm = wa_rm3-rm.
      if sy-subrc eq 0.
        wa_rdcums-julsale = wa_rm11-m4.
        wa_rdcums-augsale = wa_rm11-m5.
        wa_rdcums-sepsale = wa_rm11-m6.
      endif.
    endif.
    csl2 = wa_rdcums-julsale + wa_rdcums-augsale + wa_rdcums-sepsale.
    if date2 ge f6date.
      c2 = csl2 / 1000.
    endif.
    wa_rm2-cysale2 = c2.


    read table it_rtdums into wa_rtdums with key bzirk = wa_rm2-rm.
    if sy-subrc eq 0.
      read table it_rmt1 into wa_rmt1 with key rm = wa_rm2-rm.
      if sy-subrc eq 0.
        if wa_rtdums-julsale eq 0.
          wa_rtdums-julsale = wa_rmt1-t4.
        endif.
        if wa_rtdums-augsale eq 0.
          wa_rtdums-augsale = wa_rmt1-t5.
        endif.
        if wa_rtdums-sepsale eq 0.
          wa_rtdums-sepsale = wa_rmt1-t6.
        endif.
      endif.
    else.
      read table it_rmt1 into wa_rmt1 with key rm = wa_rm2-rm.
      if sy-subrc eq 0.
        wa_rtdums-julsale = wa_rmt1-t4.
        wa_rtdums-augsale = wa_rmt1-t5.
        wa_rtdums-sepsale = wa_rmt1-t6.
      endif.
    endif.
    cst2 = wa_rtdums-julsale + wa_rtdums-augsale + wa_rtdums-sepsale.
    if cst2 ne 0.
      cpqrt2 = ( csl2 / cst2 ) * 100.
    endif.
    if date2 ge f6date.
      wa_rm2-cpqrt2 = cpqrt2.
      if  wa_rm2-cpqrt2 eq 0.
        wa_rm2-cpqrt2 =  wa_rm3-cpqrt2.
      endif.
    endif.

**************************3**************************************
    read table it_rdcums into wa_rdcums with key bzirk = wa_rm3-rm.
    if sy-subrc eq 0.
      read table it_rm11 into wa_rm11 with key rm = wa_rm3-rm.
      if sy-subrc eq 0.
        if wa_rdcums-octsale eq 0.
          wa_rdcums-octsale = wa_rm11-m7.
        endif.
        if wa_rdcums-novsale eq 0.
          wa_rdcums-novsale = wa_rm11-m8.
        endif.
        if wa_rdcums-decsale eq 0.
          wa_rdcums-decsale = wa_rm11-m9.
        endif.
      endif.
    else.
      read table it_rm11 into wa_rm11 with key rm = wa_rm3-rm.
      if sy-subrc eq 0.
        wa_rdcums-octsale = wa_rm11-m7.
        wa_rdcums-novsale = wa_rm11-m8.
        wa_rdcums-decsale = wa_rm11-m9.
      endif.
    endif.
    csl3 = wa_rdcums-octsale + wa_rdcums-novsale + wa_rdcums-decsale.
    if date2 ge f9date.
      c3 = csl3 / 1000.
    endif.
    wa_rm2-cysale3 = c3.


    read table it_rtdums into wa_rtdums with key bzirk = wa_rm2-rm.
    if sy-subrc eq 0.
      read table it_rmt1 into wa_rmt1 with key rm = wa_rm2-rm.
      if sy-subrc eq 0.
        if wa_rtdums-octsale eq 0.
          wa_rtdums-octsale = wa_rmt1-t7.
        endif.
        if wa_rtdums-novsale eq 0.
          wa_rtdums-novsale = wa_rmt1-t8.
        endif.
        if wa_rtdums-decsale eq 0.
          wa_rtdums-decsale = wa_rmt1-t9.
        endif.
      endif.
    else.
      read table it_rmt1 into wa_rmt1 with key rm = wa_rm2-rm.
      if sy-subrc eq 0.
        wa_rtdums-octsale = wa_rmt1-t7.
        wa_rtdums-novsale = wa_rmt1-t8.
        wa_rtdums-decsale = wa_rmt1-t9.
      endif.
    endif.
    cst3 = wa_rtdums-octsale + wa_rtdums-novsale + wa_rtdums-decsale.
    if cst3 ne 0.
      cpqrt3 = ( csl3 / cst3 ) * 100.
    endif.
    if date2 ge f9date.
      wa_rm2-cpqrt3 = cpqrt3.
      if  wa_rm2-cpqrt3 eq 0.
        wa_rm2-cpqrt3 =  wa_rm3-cpqrt3.
      endif.
    endif.
*******************4*********************

    read table it_rdcums into wa_rdcums with key bzirk = wa_rm3-rm.
    if sy-subrc eq 0.
      read table it_rm11 into wa_rm11 with key rm = wa_rm3-rm.
      if sy-subrc eq 0.
        if wa_rdcums-jansale eq 0.
          wa_rdcums-jansale = wa_rm11-m10.
        endif.
        if wa_rdcums-febsale eq 0.
          wa_rdcums-febsale = wa_rm11-m11.
        endif.
        if wa_rdcums-marsale eq 0.
          wa_rdcums-marsale = wa_rm11-m12.
        endif.
      endif.
    else.
      read table it_rm11 into wa_rm11 with key rm = wa_rm3-rm.
      if sy-subrc eq 0.
        wa_rdcums-jansale = wa_rm11-m10.
        wa_rdcums-febsale = wa_rm11-m11.
        wa_rdcums-marsale = wa_rm11-m12.
      endif.
    endif.
    csl4 = wa_rdcums-jansale + wa_rdcums-febsale + wa_rdcums-marsale.
    if date2 ge f12date.
      c4 = csl4 / 1000.
    endif.
    wa_rm2-cysale4 = c4.


    read table it_rtdums into wa_rtdums with key bzirk = wa_rm2-rm.
    if sy-subrc eq 0.
      read table it_rmt1 into wa_rmt1 with key rm = wa_rm2-rm.
      if sy-subrc eq 0.
        if wa_rtdums-jansale eq 0.
          wa_rtdums-jansale = wa_rmt1-t10.
        endif.
        if wa_rtdums-febsale eq 0.
          wa_rtdums-febsale = wa_rmt1-t11.
        endif.
        if wa_rtdums-marsale eq 0.
          wa_rtdums-marsale = wa_rmt1-t12.
        endif.
      endif.
    else.
      read table it_rmt1 into wa_rmt1 with key rm = wa_rm2-rm.
      if sy-subrc eq 0.
        wa_rtdums-jansale = wa_rmt1-t10.
        wa_rtdums-febsale = wa_rmt1-t11.
        wa_rtdums-marsale = wa_rmt1-t12.
      endif.
    endif.
    cst4 = wa_rtdums-jansale + wa_rtdums-febsale + wa_rtdums-marsale.
    if cst4 gt 0.
      if cst4 ne 0.
        cpqrt4 = ( csl4 / cst4 ) * 100.
      endif.
    endif.
    if date2 ge f12date.
      wa_rm2-cpqrt4 = cpqrt4.
      if  wa_rm2-cpqrt4 eq 0.
        wa_rm2-cpqrt4 =  wa_rm3-cpqrt4.
      endif.
    endif.

***************************************************
**    wa_tab8-cpqrt4 = wa_tab9-cpqrt4.

************ CURRENT YEAR CUMMULATIVE***********
*    wa_rm2-ccumm = wa_rm3-ccumm.
*     if wa_rm1-cummt gt 0.
*      ccumm = ( wa_rm1-cumms / wa_rm1-cummt ) * 100.
*    endif.
*    wa_rm3-ccumm = ccumm.
    read table it_rrcums into wa_rrcums with key bzirk = wa_rm3-rm.
    if sy-subrc eq 0.
      read table it_rm11 into wa_rm11 with key rm = wa_rm3-rm.
      if sy-subrc eq 0.
        if wa_rrcums-aprsale eq 0.
          wa_rrcums-aprsale = wa_rm11-m1.
        endif.
        if wa_rrcums-maysale eq 0.
          wa_rrcums-maysale = wa_rm11-m2.
        endif.
        if wa_rrcums-junsale eq 0.
          wa_rrcums-junsale = wa_rm11-m3.
        endif.
        if wa_rrcums-julsale eq 0.
          wa_rrcums-julsale = wa_rm11-m4.
        endif.
        if wa_rrcums-augsale eq 0.
          wa_rrcums-augsale = wa_rm11-m5.
        endif.
        if wa_rrcums-sepsale eq 0.
          wa_rrcums-sepsale = wa_rm11-m6.
        endif.
        if wa_rrcums-octsale eq 0.
          wa_rrcums-octsale = wa_rm11-m7.
        endif.
        if wa_rrcums-novsale eq 0.
          wa_rrcums-novsale = wa_rm11-m8.
        endif.
        if wa_rrcums-decsale eq 0.
          wa_rrcums-decsale = wa_rm11-m9.
        endif.
        if wa_rrcums-jansale eq 0.
          wa_rrcums-jansale = wa_rm11-m10.
        endif.
        if wa_rrcums-febsale eq 0.
          wa_rrcums-febsale = wa_rm11-m11.
        endif.
        if wa_rrcums-marsale eq 0.
          wa_rrcums-marsale = wa_rm11-m12.
        endif.
      endif.
    else.

      read table it_rm11 into wa_rm11 with key rm = wa_rm3-rm.
      if sy-subrc eq 0.
        wa_rrcums-aprsale = wa_rm11-m1.
        wa_rrcums-maysale = wa_rm11-m2.
        wa_rrcums-junsale = wa_rm11-m3.
        wa_rrcums-julsale = wa_rm11-m4.
        wa_rrcums-augsale = wa_rm11-m5.
        wa_rrcums-sepsale = wa_rm11-m6.
        wa_rrcums-octsale = wa_rm11-m7.
        wa_rrcums-novsale = wa_rm11-m8.
        wa_rrcums-decsale = wa_rm11-m9.
        wa_rrcums-jansale = wa_rm11-m10.
        wa_rrcums-febsale = wa_rm11-m11.
        wa_rrcums-marsale = wa_rm11-m12.
      endif.
    endif.

    cum1 = wa_rrcums-aprsale + wa_rrcums-maysale + wa_rrcums-junsale + wa_rrcums-julsale + wa_rrcums-augsale + wa_rrcums-sepsale
            + wa_rrcums-octsale + wa_rrcums-novsale + wa_rrcums-decsale + wa_rrcums-jansale + wa_rrcums-febsale + wa_rrcums-marsale.

    read table it_rrtcums into wa_rrtcums with key bzirk = wa_rm3-rm.
    if sy-subrc eq 0.
      read table it_rmt1 into wa_rmt1 with key rm = wa_rm3-rm.
      if sy-subrc eq 0.
        if wa_rrtcums-aprsale eq 0.
          wa_rrtcums-aprsale = wa_rmt1-t1.
        endif.
        if wa_rrtcums-maysale eq 0.
          wa_rrtcums-maysale = wa_rmt1-t2.
        endif.
        if wa_rrtcums-junsale eq 0.
          wa_rrtcums-junsale = wa_rmt1-t3.
        endif.
        if wa_rrtcums-julsale eq 0.
          wa_rrtcums-julsale = wa_rmt1-t4.
        endif.
        if wa_rrtcums-augsale eq 0.
          wa_rrtcums-augsale = wa_rmt1-t5.
        endif.
        if wa_rrtcums-sepsale eq 0.
          wa_rrtcums-sepsale = wa_rmt1-t6.
        endif.
        if wa_rrtcums-octsale eq 0.
          wa_rrtcums-octsale = wa_rmt1-t7.
        endif.
        if wa_rrtcums-novsale eq 0.
          wa_rrtcums-novsale = wa_rmt1-t8.
        endif.
        if wa_rrtcums-decsale eq 0.
          wa_rrtcums-decsale = wa_rmt1-t9.
        endif.
        if wa_rrtcums-jansale eq 0.
          wa_rrtcums-jansale = wa_rmt1-t10.
        endif.
        if wa_rrtcums-febsale eq 0.
          wa_rrtcums-febsale = wa_rmt1-t11.
        endif.
        if wa_rrtcums-marsale eq 0.
          wa_rrtcums-marsale = wa_rmt1-t12.
        endif.
      endif.
    else.
      read table it_rmt1 into wa_rmt1 with key rm = wa_rm3-rm.
      if sy-subrc eq 0.
        wa_rrtcums-aprsale = wa_rmt1-t1.
        wa_rrtcums-maysale = wa_rmt1-t2.
        wa_rrtcums-junsale = wa_rmt1-t3.
        wa_rrtcums-julsale = wa_rmt1-t4.
        wa_rrtcums-augsale = wa_rmt1-t5.
        wa_rrtcums-sepsale = wa_rmt1-t6.
        wa_rrtcums-octsale = wa_rmt1-t7.
        wa_rrtcums-novsale = wa_rmt1-t8.
        wa_rrtcums-decsale = wa_rmt1-t9.
        wa_rrtcums-jansale = wa_rmt1-t10.
        wa_rrtcums-febsale = wa_rmt1-t11.
        wa_rrtcums-marsale = wa_rmt1-t12.
      endif.
    endif.
    cum2 = wa_rrtcums-aprsale + wa_rrtcums-maysale + wa_rrtcums-junsale + wa_rrtcums-julsale + wa_rrtcums-augsale + wa_rrtcums-sepsale +
    wa_rrtcums-octsale + wa_rrtcums-novsale + wa_rrtcums-decsale + wa_rrtcums-jansale + wa_rrtcums-febsale + wa_rrtcums-marsale.

    if cum2 gt 0.
      ccumm = ( cum1 / cum2 ) * 100.
    endif.
    wa_rm2-ccumm = ccumm.

********************** CURRENT YEAR GROWTH ******************
*    wa_rm2-cgrw = wa_rm3-cgrw.
    read table it_rrcums into wa_rcums with key bzirk = wa_rm3-rm.
    if sy-subrc eq 0.
      read table it_rm11 into wa_rm11 with key rm = wa_rm3-rm..
      if sy-subrc eq 0.
        if wa_rrcums-aprsale eq 0.
          wa_rrcums-aprsale = wa_rm11-m1.
        endif.
        if wa_rrcums-maysale eq 0.
          wa_rrcums-maysale = wa_rm11-m2.
        endif.
        if wa_rrcums-junsale eq 0.
          wa_rrcums-junsale = wa_rm11-m3.
        endif.
        if wa_rrcums-julsale eq 0.
          wa_rrcums-julsale = wa_rm11-m4.
        endif.
        if wa_rrcums-augsale eq 0.
          wa_rrcums-augsale = wa_rm11-m5.
        endif.
        if wa_rrcums-sepsale eq 0.
          wa_rrcums-sepsale = wa_rm11-m6.
        endif.
        if wa_rrcums-octsale eq 0.
          wa_rrcums-octsale = wa_rm11-m7.
        endif.
        if wa_rrcums-novsale eq 0.
          wa_rrcums-novsale = wa_rm11-m8.
        endif.
        if wa_rrcums-decsale eq 0.
          wa_rrcums-decsale = wa_rm11-m9.
        endif.
        if wa_rrcums-jansale eq 0.
          wa_rrcums-jansale = wa_rm11-m10.
        endif.
        if wa_rrcums-febsale eq 0.
          wa_rrcums-febsale = wa_rm11-m11.
        endif.
        if wa_rrcums-marsale eq 0.
          wa_rrcums-marsale = wa_rm11-m12.
        endif.
      endif.
    else.
      read table it_rm11 into wa_rm11 with key rm = wa_rm3-rm..
      if sy-subrc eq 0.
        wa_rrcums-aprsale = wa_rm11-m1.
        wa_rrcums-maysale = wa_rm11-m2.
        wa_rrcums-junsale = wa_rm11-m3.
        wa_rrcums-julsale = wa_rm11-m4.
        wa_rrcums-augsale = wa_rm11-m5.
        wa_rrcums-sepsale = wa_rm11-m6.
        wa_rrcums-octsale = wa_rm11-m7.
        wa_rrcums-novsale = wa_rm11-m8.
        wa_rrcums-decsale = wa_rm11-m9.
        wa_rrcums-jansale = wa_rm11-m10.
        wa_rrcums-febsale = wa_rm11-m11.
        wa_rrcums-marsale = wa_rm11-m12.
      endif.
    endif.

    cums = wa_rrcums-aprsale + wa_rrcums-maysale + wa_rrcums-junsale + wa_rrcums-julsale + wa_rrcums-augsale + wa_rrcums-sepsale
            + wa_rrcums-octsale + wa_rrcums-novsale + wa_rrcums-decsale + wa_rrcums-jansale + wa_rrcums-febsale + wa_rrcums-marsale.
    c5 = cums / 1000.
    wa_rm2-cysale = c5.


    read table it_rrlcums into wa_rrlcums with key bzirk = wa_rm3-rm.
    if sy-subrc eq 0.
      read table it_lrm11 into wa_lrm11 with key rm = wa_rm3-rm..
      if sy-subrc eq 0.
*        F1DATE LE DATE2.
        if wa_rrlcums-aprsale eq 0.
          wa_rrlcums-aprsale = wa_lrm11-m1.
        endif.
*        ENDIF.
        if f2date le date2.
          if wa_rrlcums-maysale eq 0.
            wa_rrlcums-maysale = wa_lrm11-m2.
          endif.
        endif.
        if f3date le date2.
          if wa_rrlcums-junsale eq 0.
            wa_rrlcums-junsale = wa_lrm11-m3.
          endif.
        endif.
        if f4date le date2.
          if wa_rrlcums-julsale eq 0.
            wa_rrlcums-julsale = wa_lrm11-m4.
          endif.
        endif.
        if f5date le date2.
          if wa_rrlcums-augsale eq 0.
            wa_rrlcums-augsale = wa_lrm11-m5.
          endif.
        endif.
        if f6date le date2.
          if wa_rrlcums-sepsale eq 0.
            wa_rrlcums-sepsale = wa_lrm11-m6.
          endif.
        endif.
        if f7date le date2.
          if wa_rrlcums-octsale eq 0.
            wa_rrlcums-octsale = wa_lrm11-m7.
          endif.
        endif.
        if f8date le date2.
          if wa_rrlcums-novsale eq 0.
            wa_rrlcums-novsale = wa_lrm11-m8.
          endif.
        endif.
        if f9date le date2.
          if wa_rrlcums-decsale eq 0.
            wa_rrlcums-decsale = wa_lrm11-m9.
          endif.
        endif.
        if f10date le date2.
          if wa_rrlcums-jansale eq 0.
            wa_rrlcums-jansale = wa_lrm11-m10.
          endif.
        endif.
        if f11date le date2.
          if wa_rrlcums-febsale eq 0.
            wa_rrlcums-febsale = wa_lrm11-m11.
          endif.
        endif.
        if f12date le date2.
          if wa_rrlcums-marsale eq 0.
            wa_rrlcums-marsale = wa_lrm11-m12.
          endif.
        endif.
      endif.
    else.
      read table it_lrm11 into wa_lrm11 with key rm = wa_rm3-rm..
      if sy-subrc eq 0.
        if f1date le date2.
          wa_rrlcums-aprsale = wa_lrm11-m1.
        endif.
        if f2date le date2.
          wa_rrlcums-maysale = wa_lrm11-m2.
        endif.
        if f3date le date2.
          wa_rrlcums-junsale = wa_lrm11-m3.
        endif.
        if f4date le date2.
          wa_rrlcums-julsale = wa_lrm11-m4.
        endif.
        if f5date le date2.
          wa_rrlcums-augsale = wa_lrm11-m5.
        endif.
        if f6date le date2.
          wa_rrlcums-sepsale = wa_lrm11-m6.
        endif.
        if f7date le date2.
          wa_rrlcums-octsale = wa_lrm11-m7.
        endif.
        if f8date le date2.
          wa_rrlcums-novsale = wa_lrm11-m8.
        endif.
        if f9date le date2.
          wa_rrlcums-decsale = wa_lrm11-m9.
        endif.
        if f10date le date2.
          wa_rrlcums-jansale = wa_lrm11-m10.
        endif.
        if f11date le date2.
          wa_rrlcums-febsale = wa_lrm11-m11.
        endif.
        if f12date le date2.
          wa_rrlcums-marsale = wa_lrm11-m12.
        endif.
      endif.
    endif.
    lcums = wa_rrlcums-aprsale + wa_rrlcums-maysale + wa_rrlcums-junsale + wa_rrlcums-julsale + wa_rrlcums-augsale + wa_rrlcums-sepsale
            + wa_rrlcums-octsale + wa_rrlcums-novsale + wa_rrlcums-decsale + wa_rrlcums-jansale + wa_rrlcums-febsale + wa_rrlcums-marsale.
    if cums <> 0 and  lcums <> 0.
      cgrw = ( cums / lcums ) * 100 - 100.
    elseif cums = 0 and lcums > 0.
      cgrw = 100.
    else.
      cgrw = -100.
    endif.
    wa_rm2-cgrw = cgrw.

**********CURRENT MONTH, LAST MONTH & LAST TO LAST MONTH PERFORMANCE******
    wa_rm2-cp1 = wa_rm3-cp1.
*    wa_rm2-cp2 = wa_rm3-cp2.
*    wa_rm2-cp3 = wa_rm3-cp3.

    wa_rm2-c1sale = wa_rm3-c1sale.
*    wa_rm2-c2sale = wa_rm3-c2sale.
*    wa_rm2-c3sale = wa_rm3-c3sale.

    read table it_rlcs into wa_rlcs with key bzirk = wa_rm3-rm.
    if sy-subrc eq 0.
      sl3 = wa_rlcs-c3sale / 1000.
      wa_rm2-c3sale = sl3.
      if wa_rlcs-t2 gt 0.
        cp3 = ( wa_rlcs-c3sale / wa_rlcs-t2 ) * 100.
      endif.
      wa_rm2-cp3 = cp3.
    endif.
    read table it_rl1cs into wa_rl1cs with key bzirk = wa_rm3-rm.
    if sy-subrc eq 0.
      sl2 = wa_rl1cs-c3sale / 1000.
      wa_rm2-c2sale = sl2.
      if wa_rl1cs-t2 gt 0.
        cp2 = ( wa_rl1cs-c3sale / wa_rl1cs-t2 ) * 100.
      endif.
      wa_rm2-cp2 = cp2.
    endif.
    if wa_rm2-cp3 le 0.
      wa_rm2-cp3 = wa_rm3-cp3.
    endif.
    if wa_rm2-cp2 le 0.
      wa_rm2-cp2 = wa_rm3-cp2.
    endif.
    if wa_rm2-c3sale le 0.
      wa_rm2-c3sale = wa_rm3-c3sale.
    endif.
    if wa_rm2-c2sale le 0.
      wa_rm2-c2sale = wa_rm3-c2sale.
    endif.



**********************************************************

    wa_rm2-zz_hqdesc =  wa_rm3-zz_hqdesc.
    wa_rm2-ename = wa_rm3-ename.
    wa_rm2-short = wa_rm3-short.

    wa_rm2-join_dt = wa_rm3-join_dt.
    wa_rm2-div = wa_rm3-div.
    wa_rm2-prom = wa_rm3-prom.

    select single * from ztotpso where begda = totpsodt and bzirk = wa_rm3-rm.
    if sy-subrc = 0.
      wa_rm2-noofpso = ( ztotpso-bc + ztotpso-bcl + ztotpso-xl ) - ztotpso-hbe.
    endif.
***********************************************************
    collect wa_rm2 into it_rm2.
    clear wa_rm2.
  endloop.

endform.                    "rm

*&---------------------------------------------------------------------*
*&      Form  pso
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form pso.
  loop at it_tab6 into wa_tab6.
    wa_pso1-reg = wa_tab6-reg.
    wa_pso1-zm = wa_tab6-zm.
    wa_pso1-rm = wa_tab6-rm.
    wa_pso1-zmpernr = wa_tab6-zmpernr.
    wa_pso1-dzmpernr = wa_tab6-dzmpernr.
    wa_pso1-rmpernr = wa_tab6-rmpernr.
    wa_pso1-rconf_prob = wa_tab6-rconf_prob.
    wa_pso1-zconf_prob = wa_tab6-zconf_prob.
    wa_pso1-dconf_prob = wa_tab6-dconf_prob.
    wa_pso1-bzirk = wa_tab6-bzirk.
    wa_pso1-plans = wa_tab6-plans.
    wa_pso1-pernr = wa_tab6-pernr.
    wa_pso1-ename = wa_tab6-ename.
    wa_pso1-zz_hqdesc = wa_tab6-zz_hqdesc.
*    wa_tab7-join_dt = wa_tab6-join_dt.
*    wa_tab7-join_date = wa_tab6-join_date.
    wa_pso1-div = wa_tab6-div.
*    wa_tab7-typ = wa_tab6-typ.

    read table it_cs into wa_cs with key bzirk = wa_tab6-bzirk.  "current , last & last to last month sale.
    if sy-subrc eq 0.
      wa_pso1-c1sale = wa_cs-c1sale.
      wa_pso1-c2sale = wa_cs-c2sale.
      wa_pso1-c3sale = wa_cs-c3sale.
    endif.

    read table it_cptar1 into wa_cptar1 with key bzirk = wa_tab6-bzirk.  "current , last & last to last month TARGET.
    if sy-subrc eq 0.
      wa_pso1-t1 = wa_cptar1-t1.
      wa_pso1-t2 = wa_cptar1-t2.
      wa_pso1-t3 = wa_cptar1-t3.
    endif.

    read table it_lly1 into wa_lly1 with key bzirk = wa_tab6-bzirk.  "LAST TO LAST YEAR SALE.
    if sy-subrc eq 0.
      clear : qt1,qt2,qt3,qt4.
      qt1 = wa_lly1-m1 + wa_lly1-m2 + wa_lly1-m3.
      qt2 = wa_lly1-m4 + wa_lly1-m5 + wa_lly1-m6.
      qt3 = wa_lly1-m7 + wa_lly1-m8 + wa_lly1-m9.
      qt4 = wa_lly1-m10 + wa_lly1-m11 + wa_lly1-m12.
      wa_pso1-llsqrt1 = qt1.
      wa_pso1-llsqrt2 = qt2.
      wa_pso1-llsqrt3 = qt3.
      wa_pso1-llsqrt4 = qt4.
    endif.

    read table it_lqt1 into wa_lqt1 with key bzirk = wa_tab6-bzirk.  "LAST  YEAR SALE.
    if sy-subrc eq 0.
      wa_pso1-lsqrt1 = wa_lqt1-qt1.
      wa_pso1-lsqrt2 = wa_lqt1-qt2.
      wa_pso1-lsqrt3 = wa_lqt1-qt3.
      wa_pso1-lsqrt4 = wa_lqt1-qt4.
    endif.

    read table it_lqtc1 into wa_lqtc1 with key bzirk = wa_tab6-bzirk.  "LAST  YEAR SALE from ZCUMPSO.
    if sy-subrc eq 0.
      wa_pso1-lsqrtc1 = wa_lqtc1-qt1.
      wa_pso1-lsqrtc2 = wa_lqtc1-qt2.
      wa_pso1-lsqrtc3 = wa_lqtc1-qt3.
      wa_pso1-lsqrtc4 = wa_lqtc1-qt4.
    endif.

    read table it_lcummsr1_pso into wa_lcummsr1_pso with key bzirk = wa_tab6-bzirk.  "LAST  YEAR CUMMULATIVE SALE from ZRCUMPSO.
    if sy-subrc eq 0.
      wa_pso1-lcummsr = wa_lcummsr1_pso-lcumm_sale.
    endif.

    read table it_lytq1 into wa_lytq1 with key bzirk = wa_tab6-bzirk.  "LAST YEAR Target.
    if sy-subrc eq 0.
      wa_pso1-ltqrt1 = wa_lytq1-qrt1.
      wa_pso1-ltqrt2 = wa_lytq1-qrt2.
      wa_pso1-ltqrt3 = wa_lytq1-qrt3.
      wa_pso1-ltqrt4 = wa_lytq1-qrt4.
    endif.

    read table it_cqt1 into wa_cqt1 with key bzirk = wa_tab6-bzirk.  "CURRENT  YEAR SALE.
    if sy-subrc eq 0.
      wa_pso1-csqrt1 = wa_cqt1-qt1.
      wa_pso1-csqrt2 = wa_cqt1-qt2.
      wa_pso1-csqrt3 = wa_cqt1-qt3.
      wa_pso1-csqrt4 = wa_cqt1-qt4.
    endif.

    read table it_cyqt1 into wa_cyqt1 with key bzirk = wa_tab6-bzirk.  "CURRENT  YEAR TARGET.
    if sy-subrc eq 0.
      wa_pso1-ctqrt1 = wa_cyqt1-qrt1.
      wa_pso1-ctqrt2 = wa_cyqt1-qrt2.
      wa_pso1-ctqrt3 = wa_cyqt1-qrt3.
      wa_pso1-ctqrt4 = wa_cyqt1-qrt4.
    endif.

    read table it_cummsr2_pso into wa_cummsr2_pso with key bzirk = wa_tab6-bzirk.  "CURRENT  YEAR CUMMULATIVE SALE FROM ZRCUMPSO.
    if sy-subrc eq 0.
*      WA_PSO1-CUMMSR = WA_CUMMSR2_PSO-CCUMM_SALE.
      wa_pso1-cummsr = wa_cummsr2_pso-zcumccumm_sale.  "take current year sale from ZCUMPSO - 1.9.24 Jyotsna as per Param
    endif.

************ CURRENT MONTH TARGET*************
    read table it_cmtar into wa_cmtar with key bzirk = wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_pso1-ctar = wa_cmtar-ctar.
    endif.

    read table it_lcumms1 into wa_lcumms1 with key bzirk = wa_tab6-bzirk.  "last year cummulative sale.
    if sy-subrc eq 0.
      wa_pso1-lcumms = wa_lcumms1-lcumm_sale.
    endif.

    read table it_cumms2_pso into wa_cumms2_pso with key bzirk = wa_tab6-bzirk.  "CURRENT year cummulative sale.
    if sy-subrc eq 0.
      wa_pso1-cumms = wa_cumms2_pso-ccumm_sale.
    endif.

    read table it_ccyt1_pso into wa_ccyt1_pso with key bzirk = wa_tab6-bzirk.  "CURRENT year cummulative TARGET.
    if sy-subrc eq 0.
      wa_pso1-cummt = wa_ccyt1_pso-cyt.
    endif.

    collect wa_pso1 into it_pso1.
    clear wa_pso1.
  endloop.
****************************************************************************************************************************
  clear: it_pa0001a1,wa_pa0001a1.
  if it_pso1 is not initial.
    select * from pa0001 into table it_pa0001a1 for all entries in it_pso1 where plans eq it_pso1-plans.
  endif.
  sort it_pa0001a1 descending by endda.

  loop at it_pso1 into wa_pso1 .
    clear : lpqrt1,lpqrt2,lpqrt1,lpqrt3,lpqrt4,lcumm,lgrw,pjoin_dt,incrdt,ltqrt,llsqrt,lsqrt,
            cpqrt1,cpqrt2,cpqrt1,cpqrt3,cpqrt4,ccumm,cgrw, cp1,cp2,cp3,
            ls1,ls2,ls3,ls4,lsc1,lsc2,lsc3,lsc4, cs1,cs2,cs3,cs4, lysale, cysale,lysalec,prom, sl1,sl2,sl3.

    wa_pso3-reg = wa_pso1-reg.
    wa_pso3-zm = wa_pso1-zm.
    wa_pso3-rm = wa_pso1-rm.
    wa_pso3-zmpernr = wa_pso1-zmpernr.
    wa_pso3-dzmpernr = wa_pso1-dzmpernr.
    wa_pso3-rmpernr = wa_pso1-rmpernr.
    wa_pso3-rconf_prob = wa_pso1-rconf_prob.
    wa_pso3-zconf_prob = wa_pso1-zconf_prob.
    wa_pso3-dconf_prob = wa_pso1-dconf_prob.
    wa_pso3-bzirk = wa_pso1-bzirk.
    wa_pso3-plans = wa_pso1-plans.
    wa_pso3-pernr = wa_pso1-pernr.
    wa_pso3-ename = wa_pso1-ename.
    wa_pso3-zz_hqdesc = wa_pso1-zz_hqdesc.
*    wa_tab7-join_dt = wa_tab6-join_dt.
*    wa_tab7-join_date = wa_tab6-join_date.
    wa_pso3-div = wa_pso1-div.

**************** LAST YEAR SALE PERFORMANVE ***********
****changed by masuma


*    IF WA_PSO1-LTQRT1 GT 0.
*      LPQRT1 = ( WA_PSO1-LSQRTC1 / WA_PSO1-LTQRT1 ) * 100.
*    ENDIF.
*    IF WA_PSO1-LTQRT2 GT 0.
*      LPQRT2 = ( WA_PSO1-LSQRTC2 / WA_PSO1-LTQRT2 ) * 100.
*    ENDIF.
*    IF WA_PSO1-LTQRT3 GT 0.
*      LPQRT3 = ( WA_PSO1-LSQRTC3 / WA_PSO1-LTQRT3 ) * 100.
*    ENDIF.
*    IF WA_PSO1-LTQRT4 GT 0.
*      LPQRT4 = ( WA_PSO1-LSQRTC4 / WA_PSO1-LTQRT4 ) * 100.
*    ENDIF.
********changed on 27.6.22 as per Param
    if wa_pso1-ltqrt1 gt 0.
      lpqrt1 = ( wa_pso1-lsqrt1 / wa_pso1-ltqrt1 ) * 100.
    endif.
    if wa_pso1-ltqrt2 gt 0.
      lpqrt2 = ( wa_pso1-lsqrt2 / wa_pso1-ltqrt2 ) * 100.
    endif.
    if wa_pso1-ltqrt3 gt 0.
      lpqrt3 = ( wa_pso1-lsqrt3 / wa_pso1-ltqrt3 ) * 100.
    endif.
    if wa_pso1-ltqrt4 gt 0.
      lpqrt4 = ( wa_pso1-lsqrt4 / wa_pso1-ltqrt4 ) * 100.
    endif.

    wa_pso3-lpqrt1 = lpqrt1.
    wa_pso3-lpqrt2 = lpqrt2.
    wa_pso3-lpqrt3 = lpqrt3.
    wa_pso3-lpqrt4 = lpqrt4.

    ls1 = wa_pso1-lsqrt1 / 1000.
    ls2 = wa_pso1-lsqrt2 / 1000.
    ls3 = wa_pso1-lsqrt3 / 1000.
    ls4 = wa_pso1-lsqrt4 / 1000.

    wa_pso3-lysale1 = ls1.
    wa_pso3-lysale2 = ls2.
    wa_pso3-lysale3 = ls3.
    wa_pso3-lysale4 = ls4.
    lysale = ls1 + ls2 + ls3 + ls4.
    wa_pso3-lysale = lysale.

    lsc1 = wa_pso1-lsqrtc1 / 1000.
    lsc2 = wa_pso1-lsqrtc2 / 1000.
    lsc3 = wa_pso1-lsqrtc3 / 1000.
    lsc4 = wa_pso1-lsqrtc4 / 1000.
    wa_pso3-lysalec1 = lsc1.
    wa_pso3-lysalec2 = lsc2.
    wa_pso3-lysalec3 = lsc3.
    wa_pso3-lysalec4 = lsc4.
    lysalec = lsc1 + lsc2 + lsc3 + lsc4.
    wa_pso3-lysalec = lysalec.
************ LAST YEAR CUMMULATIVE***********
    ltqrt = wa_pso1-ltqrt1 + wa_pso1-ltqrt2 + wa_pso1-ltqrt3 + wa_pso1-ltqrt4 .
    if ltqrt gt 0.
*      LCUMM = ( ( WA_PSO1-LSQRTC1 + WA_PSO1-LSQRTC2 + WA_PSO1-LSQRTC3 + WA_PSO1-LSQRTC4 ) / LTQRT ) * 100.
      lcumm = ( ( wa_pso1-lsqrt1 + wa_pso1-lsqrt2 + wa_pso1-lsqrt3 + wa_pso1-lsqrt4 ) / ltqrt ) * 100. "change on 27.6.22 as per Param
    endif.
    wa_pso3-lcumm = lcumm.
********************** LAST YEAR GROWTH ******************
    read table it_lyc1 into wa_lyc1 with key bzirk = wa_pso1-bzirk.
    if sy-subrc eq 0.
      lsqrt = wa_lyc1-m1 + wa_lyc1-m2 + wa_lyc1-m3 + wa_lyc1-m4 + wa_lyc1-m5 + wa_lyc1-m6 + wa_lyc1-m7 + wa_lyc1-m8 + wa_lyc1-m9 + wa_lyc1-m10
              + wa_lyc1-m11 + wa_lyc1-m12.
    endif.
    read table it_llyc1 into wa_llyc1 with key bzirk = wa_pso1-bzirk.
    if sy-subrc eq 0.
      llsqrt = wa_llyc1-m1 + wa_llyc1-m2 + wa_llyc1-m3 + wa_llyc1-m4 + wa_llyc1-m5 + wa_llyc1-m6 + wa_llyc1-m7 + wa_llyc1-m8 + wa_llyc1-m9
       + wa_llyc1-m10 + wa_llyc1-m11 + wa_llyc1-m12."data from zrcumpso
    endif.
*    llsqrt = wa_pso1-llsqrt1 + wa_pso1-llsqrt2 + wa_pso1-llsqrt3 + wa_pso1-llsqrt4.  "data from cumspo. 25.7.24
    if llsqrt gt 0.
*****  LAST YEAR GROWTH CHANGED BY MASUMA
*      lgrw = ( ( wa_pso1-lsqrtc1 + wa_pso1-lsqrtc2 + wa_pso1-lsqrtc3 + wa_pso1-lsqrtc4 ) / llsqrt ) * 100 - 100.
      lgrw = ( ( wa_pso1-lsqrt1 + wa_pso1-lsqrt2 + wa_pso1-lsqrt3 + wa_pso1-lsqrt4 ) / llsqrt ) * 100 - 100.  "changed on 27.6.22 as per Param
    else.
*      LGRW = 100.
      lgrw = 0.  "28.6.22 as per Param
    endif.
*    if llsqrt gt 0.
*      lgrw = ( lsqrt / llsqrt ) * 100 - 100.
*    endif.
    wa_pso3-lgrw = lgrw.
************* CURRENT MONTH TARGET************
    wa_pso3-ctar = wa_pso1-ctar .

**************** CURRENT YEAR SALE PERFORMANVE ***********

    if date2 ge f3date.
      if wa_pso1-ctqrt1 gt 0.
        cpqrt1 = ( wa_pso1-csqrt1 / wa_pso1-ctqrt1 ) * 100.
      endif.
    endif.
    if date2 ge f6date.
      if wa_pso1-ctqrt2 gt 0.
        cpqrt2 = ( wa_pso1-csqrt2 / wa_pso1-ctqrt2 ) * 100.
      endif.
    endif.
    if date2 ge f9date.
      if wa_pso1-ctqrt3 gt 0.
        cpqrt3 = ( wa_pso1-csqrt3 / wa_pso1-ctqrt3 ) * 100.
      endif.
    endif.
    if date2 ge f12date.
      if wa_pso1-ctqrt4 gt 0.
        cpqrt4 = ( wa_pso1-csqrt4 / wa_pso1-ctqrt4 ) * 100.
      endif.
    endif.

    wa_pso3-cpqrt1 = cpqrt1.
    wa_pso3-cpqrt2 = cpqrt2.
    wa_pso3-cpqrt3 = cpqrt3.
    wa_pso3-cpqrt4 = cpqrt4.


    if date2 ge f3date.
      cs1 = wa_pso1-csqrt1 / 1000.
    endif.
    if date2 ge f6date.
      cs2 = wa_pso1-csqrt2 / 1000.
    endif.
    if date2 ge f9date.
      cs3 = wa_pso1-csqrt3 / 1000.
    endif.
    if date2 ge f12date.
      cs4 = wa_pso1-csqrt4 / 1000.
    endif.

    wa_pso3-cysale1 = cs1.
    wa_pso3-cysale2 = cs2.
    wa_pso3-cysale3 = cs3.
    wa_pso3-cysale4 = cs4.
*    cysale = cs1 + cs2 + cs3 + cs4.
*    cysale = ( wa_pso1-csqrt1 + wa_pso1-csqrt2 + wa_pso1-csqrt3 + wa_pso1-csqrt4 ) / 1000.
************************************
    clear cysale.
    read table it_cy1_pso into wa_cy1_pso with key bzirk = wa_pso1-bzirk.
    if sy-subrc eq 0.
      cysale = ( wa_cy1_pso-m1 + wa_cy1_pso-m2 + wa_cy1_pso-m3 + wa_cy1_pso-m4 + wa_cy1_pso-m5 + wa_cy1_pso-m6 + wa_cy1_pso-m7 + wa_cy1_pso-m8 +
      wa_cy1_pso-m9 + wa_cy1_pso-m10 + wa_cy1_pso-m11 + wa_cy1_pso-m12 ) / 1000.
    endif.
************************************
    wa_pso3-cysale = cysale.

************ CURRENT YEAR CUMMULATIVE***********
    if wa_pso1-cummt gt 0.
      ccumm = ( wa_pso1-cumms / wa_pso1-cummt ) * 100.
    endif.
    wa_pso3-ccumm = ccumm.
********************** CURRENT YEAR GROWTH ******************
*    IF WA_PSO1-LCUMMS GT 0.
*      CGRW = ( wa_PSO1-CUMMS / WA_PSO1-LCUMMS ) * 100 - 100.
*    ENDIF.
*    WA_PSO3-CGRW = CGRW.

    if wa_pso1-lcummsr gt 0.
      cgrw = ( wa_pso1-cummsr / wa_pso1-lcummsr ) * 100 - 100.
    else.
      cgrw = 100.
    endif.
    wa_pso3-cgrw = cgrw.

**********CURRENT MONTH, LAST MONTH & LAST TO LAST MONTH PERFORMANCE******
    if wa_pso1-t1 gt 0.
      cp1 = ( wa_pso1-c1sale / wa_pso1-t1 ) * 100.
    endif.
    if wa_pso1-t2 gt 0.
      cp2 = ( wa_pso1-c2sale / wa_pso1-t2 ) * 100.
    endif.
    if wa_pso1-t3 gt 0.
      cp3 = ( wa_pso1-c3sale / wa_pso1-t3 ) * 100.
    endif.
    wa_pso3-cp1 = cp1.
    wa_pso3-cp2 = cp2.
    wa_pso3-cp3 = cp3.

    sl1 = wa_pso1-c1sale / 1000.
    sl2 = wa_pso1-c2sale / 1000.
    sl3 = wa_pso1-c3sale / 1000.
    wa_pso3-c1sale = sl1.
    wa_pso3-c2sale = sl2.
    wa_pso3-c3sale = sl3.

**********************************************************
    select single * from pa0001 where pernr eq wa_pso1-pernr and endda ge date2.
    if sy-subrc eq 0.
      if pa0001-ansvh = '02'.
        wa_pso3-conf_prob = 'P'.
      elseif pa0001-ansvh = '03'.
        wa_pso3-conf_prob = 'T'.
      endif.
      select single * from zfsdes where persk eq pa0001-persk.
      if sy-subrc eq 0.
        wa_pso3-short = zfsdes-short.
      endif.
    else.
      wa_pso3-short = 'SE'.
    endif.
    select single * from pa0302 where pernr eq wa_pso1-pernr and massn eq '01'.
    if sy-subrc eq 0.
      concatenate pa0302-begda+4(2) '/' pa0302-begda+0(4) into pjoin_dt.
      wa_pso3-join_dt = pjoin_dt.
    endif.
    if  wa_pso3-join_dt eq space.  "added on 16.7.24
      clear : pjoin_dt.
      read table it_pa0001a1 into wa_pa0001a1 with key plans = wa_pso3-plans.
      if sy-subrc eq 0.
        select single * from pa0302 where pernr eq wa_pa0001a1-pernr and massn eq '10'.
        if sy-subrc eq 0.
          concatenate pa0302-begda+4(2) '/' pa0302-begda+0(4) into pjoin_dt.
          wa_pso3-join_dt = pjoin_dt.
        endif.

*      BREAK-POINT .
        if  wa_pso3-join_dt eq space.
          concatenate wa_pa0001a1-endda+4(2) '/' wa_pa0001a1-endda+0(4) into pjoin_dt.
          wa_pso3-join_dt = pjoin_dt.
        endif.
      endif.
    endif.
    if  wa_pso3-join_dt eq space or wa_pso3-join_dt+3(4) ge '2999'.
      concatenate '04' '/' '2024' into wa_pso3-join_dt .  "added on 16.7.24
    endif.


    read table it_pa0000_pso into wa_pa0000_pso with key pernr = wa_pso1-pernr. "ZM PROMOTION
    if sy-subrc eq 0.
      concatenate wa_pa0000_pso-begda+4(2) '/' wa_pa0000_pso-begda+0(4) into prom.
      wa_pso3-prom = prom.
*      WA_PSO3-PROM1 = 'L-PROM'.
    endif.
***********************************************************
    collect wa_pso3 into it_pso3.
    clear wa_pso3.
  endloop.



  loop at it_pso3 into wa_pso3 .
    clear : cums,lcums,cgrw,cum1,cum2,ccumm,sl2,sl3,cp2,cp3.
    wa_pso2-reg = wa_pso3-reg.
    wa_pso2-zm = wa_pso3-zm.
    wa_pso2-rm = wa_pso3-rm.
    wa_pso2-rconf_prob = wa_pso3-rconf_prob.
    wa_pso2-zconf_prob = wa_pso3-zconf_prob.
    wa_pso2-dconf_prob = wa_pso3-dconf_prob.
    wa_pso2-conf_prob = wa_pso3-conf_prob.
    wa_pso2-zmpernr = wa_pso3-zmpernr.
    wa_pso2-dzmpernr = wa_pso3-dzmpernr.
    wa_pso2-rmpernr = wa_pso3-rmpernr.
    wa_pso2-bzirk = wa_pso3-bzirk.
    wa_pso2-plans = wa_pso3-plans.
    wa_pso2-pernr = wa_pso3-pernr.
    wa_pso2-ename = wa_pso3-ename.
    wa_pso2-conf_prob = wa_pso3-conf_prob.
    wa_pso2-zz_hqdesc = wa_pso3-zz_hqdesc.
    wa_pso2-div = wa_pso3-div.

**************** LAST YEAR SALE PERFORMANVE ***********

    wa_pso2-lpqrt1 = wa_pso3-lpqrt1.
    wa_pso2-lpqrt2 = wa_pso3-lpqrt2.
    wa_pso2-lpqrt3 = wa_pso3-lpqrt3.
    wa_pso2-lpqrt4 = wa_pso3-lpqrt4.

    wa_pso2-lysale1 = wa_pso3-lysale1.
    wa_pso2-lysale2 = wa_pso3-lysale2.
    wa_pso2-lysale3 = wa_pso3-lysale3.
    wa_pso2-lysale4 = wa_pso3-lysale4.
    wa_pso2-lysale = wa_pso3-lysale.

    wa_pso2-lysalec1 = wa_pso3-lysalec1.
    wa_pso2-lysalec2 = wa_pso3-lysalec2.
    wa_pso2-lysalec3 = wa_pso3-lysalec3.
    wa_pso2-lysalec4 = wa_pso3-lysalec4.
    wa_pso2-lysalec = wa_pso3-lysalec.
************ LAST YEAR CUMMULATIVE***********
    wa_pso2-lcumm = wa_pso3-lcumm.
********************** LAST YEAR GROWTH ******************
    wa_pso2-lgrw = wa_pso3-lgrw.
************* CURRENT MONTH TARGET************
    wa_pso2-ctar = wa_pso3-ctar .
**************** CURRENT YEAR SALE PERFORMANVE ***********

    wa_pso2-cpqrt1 = wa_pso3-cpqrt1.
    wa_pso2-cpqrt2 = wa_pso3-cpqrt2.
    wa_pso2-cpqrt3 = wa_pso3-cpqrt3.
    wa_pso2-cpqrt4 = wa_pso3-cpqrt4.

    wa_pso2-cysale1 = wa_pso3-cysale1.
    wa_pso2-cysale2 = wa_pso3-cysale2.
    wa_pso2-cysale3 = wa_pso3-cysale3.
    wa_pso2-cysale4 = wa_pso3-cysale4.
    wa_pso2-cysale = wa_pso3-cysale.

************ CURRENT YEAR CUMMULATIVE***********
    wa_pso2-ccumm = wa_pso3-ccumm.
*    READ TABLE it_pccums INTO wa_pccums WITH KEY bzirk = wa_pso3-bzirk.
*    IF sy-subrc EQ 0.
*      cum1 = wa_pccums-sale.
*    ENDIF.
*    READ TABLE it_ptcums INTO wa_ptcums WITH KEY bzirk = wa_pso3-bzirk.
*    IF sy-subrc EQ 0.
*      cum2 = wa_ptcums-sale.
*    ENDIF.
*    IF cum2 GT 0.
*      ccumm = ( cum1 / cum2 ) * 100.
*    ENDIF.
*    wa_pso2-ccumm = ccumm.
********************** CURRENT YEAR GROWTH ******************
    wa_pso2-cgrw = wa_pso3-cgrw.
*    READ TABLE it_pcums INTO wa_pcums WITH KEY bzirk = wa_pso3-bzirk.
*    IF sy-subrc EQ 0.
*      cums = wa_pcums-sale.
*    ENDIF.
*    READ TABLE it_plcums INTO wa_plcums WITH KEY bzirk = wa_pso3-bzirk.
*    IF sy-subrc EQ 0.
*      lcums = wa_plcums-sale.
*    ENDIF.
*    cgrw = ( cums / lcums ) * 100 - 100.
*    wa_pso2-cgrw = cgrw.

*    if wa_pso1-lcummsr gt 0.
*      cgrw = ( wa_pso1-cummsr / wa_pso1-lcummsr ) * 100 - 100.
*    ELSE.
*      CGRW = 100.
*    endif.
*    wa_pso3-cgrw = cgrw.
**********CURRENT MONTH, LAST MONTH & LAST TO LAST MONTH PERFORMANCE******

    wa_pso2-cp1 = wa_pso3-cp1.
    wa_pso2-cp2 = wa_pso3-cp2.
    wa_pso2-cp3 = wa_pso3-cp3.
    wa_pso2-c1sale = wa_pso3-c1sale.
    wa_pso2-c2sale = wa_pso3-c2sale.
    wa_pso2-c3sale = wa_pso3-c3sale.

*    READ TABLE it_plcs INTO wa_plcs WITH KEY bzirk = wa_pso3-bzirk.
*    IF sy-subrc EQ 0.
*      sl3 = wa_plcs-c3sale / 1000.
*      wa_pso2-c3sale = sl3.
*      cp3 = ( wa_plcs-c3sale / wa_plcs-t2 ) * 100.
*      wa_pso2-cp3 = cp3.
*    ENDIF.
*    READ TABLE it_pl1cs INTO wa_pl1cs WITH KEY bzirk = wa_pso3-bzirk.
*    IF sy-subrc EQ 0.
*      sl2 = wa_pl1cs-c3sale / 1000.
*      wa_pso2-c2sale = sl2.
*      IF wa_pl1cs-t2 GT 0.
*        cp2 = ( wa_pl1cs-c3sale / wa_pl1cs-t2 ) * 100.
*      ENDIF.
*      wa_pso2-cp2 = cp2.
*    ENDIF.
*    IF wa_pso2-cp3 LE 0.
*      wa_pso2-cp3 = wa_pso3-cp3.
*    ENDIF.
*    IF wa_pso2-cp2 LE 0.
*      wa_pso2-cp2 = wa_pso3-cp2.
*    ENDIF.
*    IF wa_pso2-c3sale LE 0.
*      wa_pso2-c3sale = wa_pso3-c3sale.
*    ENDIF.
*    IF wa_pso2-c2sale LE 0.
*      wa_pso2-c2sale = wa_pso3-c2sale.
*    ENDIF.

**********************************************************
    wa_pso2-short = wa_pso3-short.
    wa_pso2-short = wa_pso3-short.
    wa_pso2-join_dt = wa_pso3-join_dt.
    wa_pso2-prom = wa_pso3-prom.

***********************************************************

    if wa_pso2-bzirk = 'ALL-11'.
      write : /1 wa_pso2-bzirk, '=' , wa_pso2-conf_prob.
    endif.
    collect wa_pso2 into it_pso2.
    clear wa_pso2.
  endloop.
endform.                    "pso



*&---------------------------------------------------------------------*
*&      Form  com_tot
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form comdiv_tot.
  loop at it_tab6 into wa_tab6.
    if d5 eq 'X'.
      if wa_tab6-div eq 'BCL'.
        wa_com1-div = 'BC'.
      else.
        wa_com1-div = wa_tab6-div.
      endif.
    else.
      wa_com1-div = wa_tab6-div.
    endif.
    read table it_cs into wa_cs with key bzirk = wa_tab6-bzirk.  "current , last & last to last month sale.
    if sy-subrc eq 0.
      wa_com1-c1sale = wa_cs-c1sale.
      wa_com1-c2sale = wa_cs-c2sale.
      wa_com1-c3sale = wa_cs-c3sale.
    endif.
    read table it_cptar1 into wa_cptar1 with key bzirk = wa_tab6-bzirk.  "current , last & last to last month TARGET.
    if sy-subrc eq 0.
      wa_com1-t1 = wa_cptar1-t1.
      wa_com1-t2 = wa_cptar1-t2.
      wa_com1-t3 = wa_cptar1-t3.
    endif.
    read table it_lly1 into wa_lly1 with key bzirk = wa_tab6-bzirk.  "LAST TO LAST YEAR SALE.
    if sy-subrc eq 0.
      clear : qt1,qt2,qt3,qt4.
      qt1 = wa_lly1-m1 + wa_lly1-m2 + wa_lly1-m3.
      qt2 = wa_lly1-m4 + wa_lly1-m5 + wa_lly1-m6.
      qt3 = wa_lly1-m7 + wa_lly1-m8 + wa_lly1-m9.
      qt4 = wa_lly1-m10 + wa_lly1-m11 + wa_lly1-m12.
      wa_com1-llsqrt1 = qt1.
      wa_com1-llsqrt2 = qt2.
      wa_com1-llsqrt3 = qt3.
      wa_com1-llsqrt4 = qt4.
    endif.
    read table it_lqt1 into wa_lqt1 with key bzirk = wa_tab6-bzirk.  "LAST  YEAR SALE.
    if sy-subrc eq 0.
      wa_com1-lsqrt1 = wa_lqt1-qt1.
      wa_com1-lsqrt2 = wa_lqt1-qt2.
      wa_com1-lsqrt3 = wa_lqt1-qt3.
      wa_com1-lsqrt4 = wa_lqt1-qt4.
    endif.
    read table it_lqtc1 into wa_lqtc1 with key bzirk = wa_tab6-bzirk.  "LAST  YEAR SALE from ZCUMPSO.
    if sy-subrc eq 0.
      wa_com1-lsqrtc1 = wa_lqtc1-qt1.
      wa_com1-lsqrtc2 = wa_lqtc1-qt2.
      wa_com1-lsqrtc3 = wa_lqtc1-qt3.
      wa_com1-lsqrtc4 = wa_lqtc1-qt4.
    endif.
    read table it_lcummsr1 into wa_lcummsr1 with key bzirk = wa_tab6-bzirk.  "LAST  YEAR CUMMULATIVE SALE from ZRCUMPSO.
    if sy-subrc eq 0.
      wa_com1-lcummsr = wa_lcummsr1-lcumm_sale.
    endif.
    read table it_lytq1 into wa_lytq1 with key bzirk = wa_tab6-bzirk.  "LAST YEAR Target.
    if sy-subrc eq 0.
      wa_com1-ltqrt1 = wa_lytq1-qrt1.
      wa_com1-ltqrt2 = wa_lytq1-qrt2.
      wa_com1-ltqrt3 = wa_lytq1-qrt3.
      wa_com1-ltqrt4 = wa_lytq1-qrt4.
    endif.
    read table it_cqt1 into wa_cqt1 with key bzirk = wa_tab6-bzirk.  "CURRENT  YEAR SALE.
    if sy-subrc eq 0.
      wa_com1-csqrt1 = wa_cqt1-qt1.
      wa_com1-csqrt2 = wa_cqt1-qt2.
      wa_com1-csqrt3 = wa_cqt1-qt3.
      wa_com1-csqrt4 = wa_cqt1-qt4.
    endif.
    read table it_cyqt1 into wa_cyqt1 with key bzirk = wa_tab6-bzirk.  "CURRENT  YEAR TARGET.
    if sy-subrc eq 0.
      wa_com1-ctqrt1 = wa_cyqt1-qrt1.
      wa_com1-ctqrt2 = wa_cyqt1-qrt2.
      wa_com1-ctqrt3 = wa_cyqt1-qrt3.
      wa_com1-ctqrt4 = wa_cyqt1-qrt4.
    endif.
    read table it_cummsr2 into wa_cummsr2 with key bzirk = wa_tab6-bzirk.  "CURRENT  YEAR CUMMULATIVE SALE FROM ZRCUMPSO.
    if sy-subrc eq 0.
      wa_com1-cummsr = wa_cummsr2-ccumm_sale.
    endif.
************ CURRENT MONTH TARGET*************
    read table it_cmtar into wa_cmtar with key bzirk = wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_com1-ctar = wa_cmtar-ctar.
    endif.
    read table it_lcumms1 into wa_lcumms1 with key bzirk = wa_tab6-bzirk.  "last year cummulative sale.
    if sy-subrc eq 0.
      wa_com1-lcumms = wa_lcumms1-lcumm_sale.
    endif.
    read table it_cumms2 into wa_cumms2 with key bzirk = wa_tab6-bzirk.  "CURRENT year cummulative sale.
    if sy-subrc eq 0.
      wa_com1-cumms = wa_cumms2-ccumm_sale.
    endif.
    read table it_ccyt1 into wa_ccyt1 with key bzirk = wa_tab6-bzirk.  "CURRENT year cummulative TARGET.
    if sy-subrc eq 0.
      wa_com1-cummt = wa_ccyt1-cyt.
    endif.
    collect wa_com1 into it_com1.
    clear wa_com1.
  endloop.
*  BREAK-POINT.
****************************************************************************************************************************

  if d5 eq 'X'.
    loop at it_com1 into wa_com1.
*****      IF WA_COM1-DIV EQ 'XL'.
      if wa_com1-div eq 'XL' or wa_com1-div eq 'LS'.
        delete it_com1 where div eq wa_com1-div.
      endif.
    endloop.
  elseif d4 eq 'X'.
    loop at it_com1 into wa_com1.
      if wa_com1-div ne 'XL'.
        delete it_com1 where div eq wa_com1-div.
      endif.
    endloop.
  elseif d6 eq 'X'.
    loop at it_com1 into wa_com1.
      if wa_com1-div ne 'LS'.
        delete it_com1 where div eq wa_com1-div.
      endif.
    endloop.
  endif.



  loop at it_com1 into wa_com1 .
    clear : lpqrt1,lpqrt2,lpqrt1,lpqrt3,lpqrt4,lcumm,lgrw,pjoin_dt,incrdt,ltqrt,llsqrt,lsqrt,
            cpqrt1,cpqrt2,cpqrt1,cpqrt3,cpqrt4,ccumm,cgrw, cp1,cp2,cp3,
            ls1,ls2,ls3,ls4,lsc1,lsc2,lsc3,lsc4, cs1,cs2,cs3,cs4, lysale, cysale,lysalec,prom, sl1,sl2,sl3.
**************** MERGE BC & BCL IN ONE 11.7.2019.................
    if d1 eq 'X'.
      if wa_com1-div eq 'BCL'.
        wa_com2-div = 'BCL'.
      endif.
      if wa_com1-div eq 'BC'.
        wa_com2-div = 'BC'.
      endif.
      if wa_com1-div eq 'XL'.
        wa_com2-div = 'XL'.
      endif.
      if wa_com1-div eq 'LS'.
        wa_com2-div = 'LS'.
      endif.
    elseif d5 eq 'X'.
      if wa_com1-div eq 'BCL'.
        wa_com2-div = 'BC'.
      endif.
      if wa_com1-div eq 'BC'.
        wa_com2-div = 'BC'.
      endif.
    else.
      wa_com2-div = wa_com1-div.
    endif.

**************** LAST YEAR SALE PERFORMANVE ***********
    if wa_com1-ltqrt1 gt 0.
      lpqrt1 = ( wa_com1-lsqrt1 / wa_com1-ltqrt1 ) * 100.
    endif.
    if wa_com1-ltqrt2 gt 0.
      lpqrt2 = ( wa_com1-lsqrt2 / wa_com1-ltqrt2 ) * 100.
    endif.
    if wa_com1-ltqrt3 gt 0.
      lpqrt3 = ( wa_com1-lsqrt3 / wa_com1-ltqrt3 ) * 100.
    endif.
    if wa_com1-ltqrt4 gt 0.
      lpqrt4 = ( wa_com1-lsqrt4 / wa_com1-ltqrt4 ) * 100.
    endif.
    wa_com2-lpqrt1 = lpqrt1.
    wa_com2-lpqrt2 = lpqrt2.
    wa_com2-lpqrt3 = lpqrt3.
    wa_com2-lpqrt4 = lpqrt4.

    ls1 = wa_com1-lsqrt1 / 1000.
    ls2 = wa_com1-lsqrt2 / 1000.
    ls3 = wa_com1-lsqrt3 / 1000.
    ls4 = wa_com1-lsqrt4 / 1000.

    wa_com2-lysale1 = ls1.
    wa_com2-lysale2 = ls2.
    wa_com2-lysale3 = ls3.
    wa_com2-lysale4 = ls4.
    lysale = ls1 + ls2 + ls3 + ls4.
    wa_com2-lysale = lysale.

    lsc1 = wa_com1-lsqrtc1 / 1000.
    lsc2 = wa_com1-lsqrtc2 / 1000.
    lsc3 = wa_com1-lsqrtc3 / 1000.
    lsc4 = wa_com1-lsqrtc4 / 1000.
    wa_com2-lysalec1 = lsc1.
    wa_com2-lysalec2 = lsc2.
    wa_com2-lysalec3 = lsc3.
    wa_com2-lysalec4 = lsc4.
    lysalec = lsc1 + lsc2 + lsc3 + lsc4.
    wa_com2-lysalec = lysalec.
************ LAST YEAR CUMMULATIVE***********
    ltqrt = wa_com1-ltqrt1 + wa_com1-ltqrt2 + wa_com1-ltqrt3 + wa_com1-ltqrt4 .
    if ltqrt gt 0.
      lcumm = ( ( wa_com1-lsqrt1 + wa_com1-lsqrt2 + wa_com1-lsqrt3 + wa_com1-lsqrt4 ) / ltqrt ) * 100.
    endif.
    wa_com2-lcumm = lcumm.
********************** LAST YEAR GROWTH ******************
    llsqrt = wa_com1-llsqrt1 + wa_com1-llsqrt2 + wa_com1-llsqrt3 + wa_com1-llsqrt4.
    if llsqrt gt 0.
      lgrw = ( ( wa_com1-lsqrt1 + wa_com1-lsqrt2 + wa_com1-lsqrt3 + wa_com1-lsqrt4 ) / llsqrt ) * 100 - 100.
    else.
      lgrw = 100.
    endif.
    wa_com2-lgrw = lgrw.
************* CURRENT MONTH TARGET************
    wa_com2-ctar = wa_com1-ctar .

**************** CURRENT YEAR SALE PERFORMANVE ***********

    if date2 ge f3date.
      if wa_com1-ctqrt1 gt 0.
        cpqrt1 = ( wa_com1-csqrt1 / wa_com1-ctqrt1 ) * 100.
      endif.
    endif.
    if date2 ge f6date.
      if wa_com1-ctqrt2 gt 0.
        cpqrt2 = ( wa_com1-csqrt2 / wa_com1-ctqrt2 ) * 100.
      endif.
    endif.
    if date2 ge f9date.
      if wa_com1-ctqrt3 gt 0.
        cpqrt3 = ( wa_com1-csqrt3 / wa_com1-ctqrt3 ) * 100.
      endif.
    endif.
    if date2 ge f12date.
      if wa_com1-ctqrt4 gt 0.
        cpqrt4 = ( wa_com1-csqrt4 / wa_com1-ctqrt4 ) * 100.
      endif.
    endif.

    wa_com2-cpqrt1 = cpqrt1.
    wa_com2-cpqrt2 = cpqrt2.
    wa_com2-cpqrt3 = cpqrt3.
    wa_com2-cpqrt4 = cpqrt4.


    if date2 ge f3date.
      cs1 = wa_com1-csqrt1 / 1000.
    endif.
    if date2 ge f6date.
      cs2 = wa_com1-csqrt2 / 1000.
    endif.
    if date2 ge f9date.
      cs3 = wa_com1-csqrt3 / 1000.
    endif.
    if date2 ge f12date.
      cs4 = wa_com1-csqrt4 / 1000.
    endif.

    wa_com2-cysale1 = cs1.
    wa_com2-cysale2 = cs2.
    wa_com2-cysale3 = cs3.
    wa_com2-cysale4 = cs4.
*    cysale = cs1 + cs2 + cs3 + cs4.
    cysale = ( wa_com1-csqrt1 + wa_com1-csqrt2 + wa_com1-csqrt3 + wa_com1-csqrt4 ) / 1000.
    wa_com2-cysale = cysale.

************ CURRENT YEAR CUMMULATIVE***********
    if wa_com1-cummt gt 0.
      ccumm = ( wa_com1-cumms / wa_com1-cummt ) * 100.
    endif.
    wa_com2-ccumm = ccumm.
********************** CURRENT YEAR GROWTH ******************

    if wa_com1-lcummsr gt 0.
      cgrw = ( wa_com1-cummsr / wa_com1-lcummsr ) * 100 - 100.
    else.
      cgrw = 100.
    endif.
    wa_com2-cgrw = cgrw.

**********CURRENT MONTH, LAST MONTH & LAST TO LAST MONTH PERFORMANCE******
    if wa_com1-t1 gt 0.
      cp1 = ( wa_com1-c1sale / wa_com1-t1 ) * 100.
    endif.
    if wa_com1-t2 gt 0.
      cp2 = ( wa_com1-c2sale / wa_com1-t2 ) * 100.
    endif.
    if wa_com1-t3 gt 0.
      cp3 = ( wa_com1-c3sale / wa_com1-t3 ) * 100.
    endif.
    wa_com2-cp1 = cp1.
    wa_com2-cp2 = cp2.
    wa_com2-cp3 = cp3.

    sl1 = wa_com1-c1sale / 1000.
    sl2 = wa_com1-c2sale / 1000.
    sl3 = wa_com1-c3sale / 1000.
    wa_com2-c1sale = sl1.
    wa_com2-c2sale = sl2.
    wa_com2-c3sale = sl3.

***********************************************************
    collect wa_com2 into it_com2.
    clear wa_com2.
  endloop.
endform.                    "pso



*&---------------------------------------------------------------------*
*&      Form  com_tot
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form com_tot.
  loop at it_tab6 into wa_tab6.
*    wa_comp1-div = wa_tab6-div.
    read table it_cs into wa_cs with key bzirk = wa_tab6-bzirk.  "current , last & last to last month sale.
    if sy-subrc eq 0.
      wa_comp1-c1sale = wa_cs-c1sale.
      wa_comp1-c2sale = wa_cs-c2sale.
      wa_comp1-c3sale = wa_cs-c3sale.
    endif.
    read table it_cptar1 into wa_cptar1 with key bzirk = wa_tab6-bzirk.  "current , last & last to last month TARGET.
    if sy-subrc eq 0.
      wa_comp1-t1 = wa_cptar1-t1.
      wa_comp1-t2 = wa_cptar1-t2.
      wa_comp1-t3 = wa_cptar1-t3.
    endif.
    read table it_lly1 into wa_lly1 with key bzirk = wa_tab6-bzirk.  "LAST TO LAST YEAR SALE.
    if sy-subrc eq 0.
      clear : qt1,qt2,qt3,qt4.
      qt1 = wa_lly1-m1 + wa_lly1-m2 + wa_lly1-m3.
      qt2 = wa_lly1-m4 + wa_lly1-m5 + wa_lly1-m6.
      qt3 = wa_lly1-m7 + wa_lly1-m8 + wa_lly1-m9.
      qt4 = wa_lly1-m10 + wa_lly1-m11 + wa_lly1-m12.
      wa_comp1-llsqrt1 = qt1.
      wa_comp1-llsqrt2 = qt2.
      wa_comp1-llsqrt3 = qt3.
      wa_comp1-llsqrt4 = qt4.
    endif.
    read table it_lqt1 into wa_lqt1 with key bzirk = wa_tab6-bzirk.  "LAST  YEAR SALE.
    if sy-subrc eq 0.
      wa_comp1-lsqrt1 = wa_lqt1-qt1.
      wa_comp1-lsqrt2 = wa_lqt1-qt2.
      wa_comp1-lsqrt3 = wa_lqt1-qt3.
      wa_comp1-lsqrt4 = wa_lqt1-qt4.
    endif.
    read table it_lqtc1 into wa_lqtc1 with key bzirk = wa_tab6-bzirk.  "LAST  YEAR SALE from ZCUMPSO.
    if sy-subrc eq 0.
      wa_comp1-lsqrtc1 = wa_lqtc1-qt1.
      wa_comp1-lsqrtc2 = wa_lqtc1-qt2.
      wa_comp1-lsqrtc3 = wa_lqtc1-qt3.
      wa_comp1-lsqrtc4 = wa_lqtc1-qt4.
    endif.
    read table it_lcummsr1 into wa_lcummsr1 with key bzirk = wa_tab6-bzirk.  "LAST  YEAR CUMMULATIVE SALE from ZRCUMPSO.
    if sy-subrc eq 0.
      wa_comp1-lcummsr = wa_lcummsr1-lcumm_sale.
    endif.
    read table it_lytq1 into wa_lytq1 with key bzirk = wa_tab6-bzirk.  "LAST YEAR Target.
    if sy-subrc eq 0.
      wa_comp1-ltqrt1 = wa_lytq1-qrt1.
      wa_comp1-ltqrt2 = wa_lytq1-qrt2.
      wa_comp1-ltqrt3 = wa_lytq1-qrt3.
      wa_comp1-ltqrt4 = wa_lytq1-qrt4.
    endif.
    read table it_cqt1 into wa_cqt1 with key bzirk = wa_tab6-bzirk.  "CURRENT  YEAR SALE.
    if sy-subrc eq 0.
      wa_comp1-csqrt1 = wa_cqt1-qt1.
      wa_comp1-csqrt2 = wa_cqt1-qt2.
      wa_comp1-csqrt3 = wa_cqt1-qt3.
      wa_comp1-csqrt4 = wa_cqt1-qt4.
    endif.
    read table it_cyqt1 into wa_cyqt1 with key bzirk = wa_tab6-bzirk.  "CURRENT  YEAR TARGET.
    if sy-subrc eq 0.
      wa_comp1-ctqrt1 = wa_cyqt1-qrt1.
      wa_comp1-ctqrt2 = wa_cyqt1-qrt2.
      wa_comp1-ctqrt3 = wa_cyqt1-qrt3.
      wa_comp1-ctqrt4 = wa_cyqt1-qrt4.
    endif.
    read table it_cummsr2 into wa_cummsr2 with key bzirk = wa_tab6-bzirk.  "CURRENT  YEAR CUMMULATIVE SALE FROM ZRCUMPSO.
    if sy-subrc eq 0.
      wa_comp1-cummsr = wa_cummsr2-ccumm_sale.
    endif.
************ CURRENT MONTH TARGET*************
    read table it_cmtar into wa_cmtar with key bzirk = wa_tab6-bzirk.
    if sy-subrc eq 0.
      wa_comp1-ctar = wa_cmtar-ctar.
    endif.
    read table it_lcumms1 into wa_lcumms1 with key bzirk = wa_tab6-bzirk.  "last year cummulative sale.
    if sy-subrc eq 0.
      wa_comp1-lcumms = wa_lcumms1-lcumm_sale.
    endif.
    read table it_cumms2 into wa_cumms2 with key bzirk = wa_tab6-bzirk.  "CURRENT year cummulative sale.
    if sy-subrc eq 0.
      wa_comp1-cumms = wa_cumms2-ccumm_sale.
    endif.
    read table it_ccyt1 into wa_ccyt1 with key bzirk = wa_tab6-bzirk.  "CURRENT year cummulative TARGET.
    if sy-subrc eq 0.
      wa_comp1-cummt = wa_ccyt1-cyt.
    endif.
    collect wa_comp1 into it_comp1.
    clear wa_comp1.
  endloop.
****************************************************************************************************************************

  loop at it_comp1 into wa_comp1 .
    clear : lpqrt1,lpqrt2,lpqrt1,lpqrt3,lpqrt4,lcumm,lgrw,pjoin_dt,incrdt,ltqrt,llsqrt,lsqrt,
            cpqrt1,cpqrt2,cpqrt1,cpqrt3,cpqrt4,ccumm,cgrw, cp1,cp2,cp3,
            ls1,ls2,ls3,ls4,lsc1,lsc2,lsc3,lsc4, cs1,cs2,cs3,cs4, lysale, cysale,lysalec,prom, sl1,sl2,sl3.


*    wa_comp2-div = wa_comp1-div.

**************** LAST YEAR SALE PERFORMANVE ***********
    if wa_comp1-ltqrt1 gt 0.
      lpqrt1 = ( wa_comp1-lsqrt1 / wa_comp1-ltqrt1 ) * 100.
    endif.
    if wa_comp1-ltqrt2 gt 0.
      lpqrt2 = ( wa_comp1-lsqrt2 / wa_comp1-ltqrt2 ) * 100.
    endif.
    if wa_comp1-ltqrt3 gt 0.
      lpqrt3 = ( wa_comp1-lsqrt3 / wa_comp1-ltqrt3 ) * 100.
    endif.
    if wa_comp1-ltqrt4 gt 0.
      lpqrt4 = ( wa_comp1-lsqrt4 / wa_comp1-ltqrt4 ) * 100.
    endif.
    wa_comp2-lpqrt1 = lpqrt1.
    wa_comp2-lpqrt2 = lpqrt2.
    wa_comp2-lpqrt3 = lpqrt3.
    wa_comp2-lpqrt4 = lpqrt4.

    ls1 = wa_comp1-lsqrt1 / 1000.
    ls2 = wa_comp1-lsqrt2 / 1000.
    ls3 = wa_comp1-lsqrt3 / 1000.
    ls4 = wa_comp1-lsqrt4 / 1000.

    wa_comp2-lysale1 = ls1.
    wa_comp2-lysale2 = ls2.
    wa_comp2-lysale3 = ls3.
    wa_comp2-lysale4 = ls4.
    lysale = ls1 + ls2 + ls3 + ls4.
    wa_comp2-lysale = lysale.

    lsc1 = wa_comp1-lsqrtc1 / 1000.
    lsc2 = wa_comp1-lsqrtc2 / 1000.
    lsc3 = wa_comp1-lsqrtc3 / 1000.
    lsc4 = wa_comp1-lsqrtc4 / 1000.
    wa_comp2-lysalec1 = lsc1.
    wa_comp2-lysalec2 = lsc2.
    wa_comp2-lysalec3 = lsc3.
    wa_comp2-lysalec4 = lsc4.
    lysalec = lsc1 + lsc2 + lsc3 + lsc4.
    wa_comp2-lysalec = lysalec.
************ LAST YEAR CUMMULATIVE***********
    ltqrt = wa_comp1-ltqrt1 + wa_comp1-ltqrt2 + wa_comp1-ltqrt3 + wa_comp1-ltqrt4 .
    if ltqrt gt 0.
      lcumm = ( ( wa_comp1-lsqrt1 + wa_comp1-lsqrt2 + wa_comp1-lsqrt3 + wa_comp1-lsqrt4 ) / ltqrt ) * 100.
    endif.
    wa_comp2-lcumm = lcumm.
********************** LAST YEAR GROWTH ******************
    llsqrt = wa_comp1-llsqrt1 + wa_comp1-llsqrt2 + wa_comp1-llsqrt3 + wa_comp1-llsqrt4.
    if llsqrt gt 0.
      lgrw = ( ( wa_comp1-lsqrt1 + wa_comp1-lsqrt2 + wa_comp1-lsqrt3 + wa_comp1-lsqrt4 ) / llsqrt ) * 100 - 100.
    else.
      lgrw = 100.
    endif.
    wa_comp2-lgrw = lgrw.
************* CURRENT MONTH TARGET************
    wa_comp2-ctar = wa_comp1-ctar .

**************** CURRENT YEAR SALE PERFORMANVE ***********

    if date2 ge f3date.
      if wa_comp1-ctqrt1 gt 0.
        cpqrt1 = ( wa_comp1-csqrt1 / wa_comp1-ctqrt1 ) * 100.
      endif.
    endif.
    if date2 ge f6date.
      if wa_comp1-ctqrt2 gt 0.
        cpqrt2 = ( wa_comp1-csqrt2 / wa_comp1-ctqrt2 ) * 100.
      endif.
    endif.
    if date2 ge f9date.
      if wa_comp1-ctqrt3 gt 0.
        cpqrt3 = ( wa_comp1-csqrt3 / wa_comp1-ctqrt3 ) * 100.
      endif.
    endif.
    if date2 ge f12date.
      if wa_comp1-ctqrt4 gt 0.
        cpqrt4 = ( wa_comp1-csqrt4 / wa_comp1-ctqrt4 ) * 100.
      endif.
    endif.

    wa_comp2-cpqrt1 = cpqrt1.
    wa_comp2-cpqrt2 = cpqrt2.
    wa_comp2-cpqrt3 = cpqrt3.
    wa_comp2-cpqrt4 = cpqrt4.


    if date2 ge f3date.
      cs1 = wa_comp1-csqrt1 / 1000.
    endif.
    if date2 ge f6date.
      cs2 = wa_comp1-csqrt2 / 1000.
    endif.
    if date2 ge f9date.
      cs3 = wa_comp1-csqrt3 / 1000.
    endif.
    if date2 ge f12date.
      cs4 = wa_comp1-csqrt4 / 1000.
    endif.

    wa_comp2-cysale1 = cs1.
    wa_comp2-cysale2 = cs2.
    wa_comp2-cysale3 = cs3.
    wa_comp2-cysale4 = cs4.
*    cysale = cs1 + cs2 + cs3 + cs4.
    cysale = ( wa_comp1-csqrt1 + wa_comp1-csqrt2 + wa_comp1-csqrt3 + wa_comp1-csqrt4 ) / 1000.
    wa_comp2-cysale = cysale.

************ CURRENT YEAR CUMMULATIVE***********
    if wa_comp1-cummt gt 0.
      ccumm = ( wa_comp1-cumms / wa_comp1-cummt ) * 100.
    endif.
    wa_comp2-ccumm = ccumm.
********************** CURRENT YEAR GROWTH ******************

    if wa_comp1-lcummsr gt 0.
      cgrw = ( wa_comp1-cummsr / wa_comp1-lcummsr ) * 100 - 100.
    else.
      cgrw = 100.
    endif.
    wa_comp2-cgrw = cgrw.

**********CURRENT MONTH, LAST MONTH & LAST TO LAST MONTH PERFORMANCE******
    if wa_comp1-t1 gt 0.
      cp1 = ( wa_comp1-c1sale / wa_comp1-t1 ) * 100.
    endif.
    if wa_comp1-t2 gt 0.
      cp2 = ( wa_comp1-c2sale / wa_comp1-t2 ) * 100.
    endif.
    if wa_comp1-t3 gt 0.
      cp3 = ( wa_comp1-c3sale / wa_comp1-t3 ) * 100.
    endif.
    wa_comp2-cp1 = cp1.
    wa_comp2-cp2 = cp2.
    wa_comp2-cp3 = cp3.

    sl1 = wa_comp1-c1sale / 1000.
    sl2 = wa_comp1-c2sale / 1000.
    sl3 = wa_comp1-c3sale / 1000.
    wa_comp2-c1sale = sl1.
    wa_comp2-c2sale = sl2.
    wa_comp2-c3sale = sl3.

***********************************************************
    collect wa_comp2 into it_comp2.
    clear wa_comp2.
  endloop.
endform.                    "pso



*&---------------------------------------------------------------------*
*&      Form  PRM_ZM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form prm_zm.
  if it_tab6 is not initial.
    select * from pa0000 into table it_pa0000_zm for all entries in it_tab6 where pernr eq it_tab6-zmpernr and begda le sy-datum and massn eq '08'.
  endif.
  sort it_pa0000_zm descending by begda.
endform.                    "PRM_ZM

*&---------------------------------------------------------------------*
*&      Form  PRM_RM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form prm_dzm.
  if it_tab6 is not initial.
    select * from pa0000 into table it_pa0000_dzm for all entries in it_tab6 where pernr eq it_tab6-dzmpernr and begda le sy-datum and massn eq '08'.
  endif.
  sort it_pa0000_dzm descending by begda.
endform.                    "PRM_RM

*&---------------------------------------------------------------------*
*&      Form  prm_rm
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form prm_rm.
  if it_tab6 is not initial.
    select * from pa0000 into table it_pa0000_rm for all entries in it_tab6 where pernr eq it_tab6-rmpernr and begda le sy-datum and massn eq '08'.
  endif.
  sort it_pa0000_rm descending by begda.
endform.                    "PRM_RM

*&---------------------------------------------------------------------*
*&      Form  PRM_PSO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form prm_pso.
  if it_tab6 is not initial.
    select * from pa0000 into table it_pa0000_pso for all entries in it_tab6 where pernr eq it_tab6-pernr and begda le sy-datum and massn eq '08'.
  endif.
  sort it_pa0000_pso descending by begda.
endform.                    "PRM_PSO
*&---------------------------------------------------------------------*
*&      Form  EMAIL_SM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form email_sm .


  loop at it_tab8 into wa_tab8.
    select single * from zdsmter where zmonth eq month and zyear eq year and bzirk eq wa_tab8-reg.
    if sy-subrc eq 0.
      select single * from yterrallc where bzirk eq zdsmter-zdsm and endda ge sy-datum.
      if sy-subrc eq 0.
        select single * from pa0001 where plans eq yterrallc-plans  and endda ge sy-datum.
        if sy-subrc eq 0.
*               WA_TAP1-PERNR = WA_TAB8-ZMPERNR.
          wa_taz1-pernr = pa0001-pernr.
          wa_taz1-bzirk = yterrallc-bzirk.
        endif.
      endif.
    endif.
    collect wa_taz1 into it_taz1.
    clear wa_taz1.
  endloop.

  sort it_taz1 by pernr.
  delete adjacent duplicates from it_taz1 comparing pernr.

  loop at it_taz1 into wa_taz1.
    select single * from pa0105 where pernr eq wa_taz1-pernr and subty eq '0010'.
    if sy-subrc eq 0.
      wa_taz2-pernr = wa_taz1-pernr.
      wa_taz2-bzirk = wa_taz1-bzirk.
      wa_taz2-usrid_long = pa0105-usrid_long.
      collect wa_taz2 into it_taz2.
      clear wa_taz2.
    endif.
  endloop.

  sort it_tab8 by seq.
  sort it_zm2 by zm.
  sort it_rm2 by reg rm.
  sort it_pso2 by reg zm rm bzirk.
  concatenate lyear+2(2) '-' cyear+2(2) into ly.
  concatenate cyear+2(2) '-' ccyear+2(2) into cy.
  select single * from t247 where spras eq 'EN' and mnr eq date1+4(2).
  if sy-subrc eq 0.
    nmonth1 = t247-ktx.
  endif.
  select single * from t247 where spras eq 'EN' and mnr eq date4+4(2).
  if sy-subrc eq 0.
    nmonth2 = t247-ktx.
  endif.
  select single * from t247 where spras eq 'EN' and mnr eq date5+4(2).
  if sy-subrc eq 0.
    nmonth3 = t247-ktx.
  endif.
  if r7 eq 'X'.
    options-tdgetotf = 'X'.
  endif.

*  if r7p eq 'X'.
*    call function 'OPEN_FORM'
*      exporting
*        device   = 'PRINTER'
*        dialog   = 'X'
**       form     = 'ZSR24_1'
*        language = sy-langu
*        options  = options
*      exceptions
*        canceled = 1
*        device   = 2.
*    if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    endif.
*    ELSEIF r7 eq 'X'.
*      call function 'OPEN_FORM'
*      exporting
*        device   = 'PRINTER'
*        dialog   = ''
**       form     = 'ZSR24_1'
*        language = sy-langu
*        options  = options
*      exceptions
*        canceled = 1
*        device   = 2.
*    if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    endif.
*    ENDIF.
*
*    call function 'START_FORM'
*      exporting
*        form        = 'ZSR11_N1_3N_2'
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
*    perform zm_div1.
*
*    call function 'END_FORM'
*      exceptions
*        unopened                 = 1
*        bad_pageformat_for_print = 2
*        spool_error              = 3
*        codepage                 = 4
*        others                   = 5.
*    if sy-subrc <> 0.
*      message id sy-msgid type sy-msgty number sy-msgno
*              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*    endif.
**      endif.
*    IF R7 EQ 'X'.
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
*    exit.
*
*  endif.
*



  loop at it_taz1 into wa_taz1 where pernr ne '00000000'.
    on change of wa_tab8-reg.
      a = 0.
    endon.
    loop at it_tab8 into wa_tab8 .
*      WHERE ZMPERNR = WA_TAP1-PERNR.
      select single * from zdsmter where zmonth eq month and zyear eq year and zdsm eq wa_taz1-bzirk and bzirk eq wa_tab8-reg.
      if sy-subrc eq 0.
        loop at it_zm2 into wa_zm2 where reg = wa_tab8-reg and cgrw ge grw1 and cgrw le grw2 and ccumm ge per1 and ccumm le per2.
          a = 1.
        endloop.
        loop at it_rm2 into wa_rm2 where reg = wa_tab8-reg and cgrw ge grw1 and cgrw le grw2 and ccumm ge per1 and ccumm le per2.
          a = 1.
        endloop.
        loop at it_pso2 into wa_pso2 where reg = wa_tab8-reg and cgrw ge grw1 and cgrw le grw2 and ccumm ge per1 and ccumm le per2.
          a = 1.
        endloop.
      endif.
    endloop.
    if a eq 1.

*      if r7p eq 'X'.
*        call function 'OPEN_FORM'
*          exporting
*            device   = 'PRINTER'
*            dialog   = ''
**           form     = 'ZSR24_1'
*            language = sy-langu
*            options  = options
*          exceptions
*            canceled = 1
*            device   = 2.
*        if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*        endif.
*        call function 'START_FORM'
*          exporting
*            form        = 'ZSR11_N1_3N'
*            language    = sy-langu
*          exceptions
*            form        = 1
*            format      = 2
*            unended     = 3
*            unopened    = 4
*            unused      = 5
*            spool_error = 6
*            codepage    = 7
*            others      = 8.
*        if sy-subrc <> 0.
*          message id sy-msgid type sy-msgty number sy-msgno
*                  with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*        endif.
*
*        perform zm_div1.
*
*        call function 'END_FORM'
*          exceptions
*            unopened                 = 1
*            bad_pageformat_for_print = 2
*            spool_error              = 3
*            codepage                 = 4
*            others                   = 5.
*        if sy-subrc <> 0.
*          message id sy-msgid type sy-msgty number sy-msgno
*                  with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*        endif.
*
*      else.
      if r7p eq 'X'.
        call function 'OPEN_FORM'
          exporting
            device   = 'PRINTER'
            dialog   = 'X'
*           form     = 'ZSR24_1'
            language = sy-langu
            options  = options
          exceptions
            canceled = 1
            device   = 2.
        if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        endif.
      elseif r7 eq 'X'.
        call function 'OPEN_FORM'
          exporting
            device   = 'PRINTER'
            dialog   = ''
*           form     = 'ZSR24_1'
            language = sy-langu
            options  = options
          exceptions
            canceled = 1
            device   = 2.
        if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        endif.
      endif.


      call function 'START_FORM'
        exporting
*         form        = 'ZSR11_N1_3N'
          form        = 'ZSR11_N1_3N_2'
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

      perform zm_div1.

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
*      endif.
      if r7p eq 'X'.

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

      else.
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

*  write s_budat-low to wa_d1 dd/mm/yyyy.
*  write s_budat-high to wa_d2 dd/mm/yyyy.

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
        concatenate 'SR-11' 'SM'  into doc_chng-obj_descr separated by space.
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

        concatenate 'SR-11' '.' sy-datum into objpack-obj_descr separated by space.
        objpack-doc_size = righe_attachment * 255.
        append objpack.
        clear objpack.

*  LOOP at it_tac4 INTO wa_tac4.
*    WRITE : / wa_tac4-bzirk,wa_tac4-usrid_long.
        loop at it_taz2 into wa_taz2 where pernr = wa_taz1-pernr.
          reclist-receiver =   wa_taz2-usrid_long.
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
*             COMMIT_WORK                = ' '
* IMPORTING
*             SENT_TO_ALL                =
*             NEW_OBJECT_ID              =
*             SENDER_ID                  =
            tables
              packing_list               = objpack
*             OBJECT_HEADER              =
              contents_bin               = objbin
              contents_txt               = objtxt
*             CONTENTS_HEX               =
*             OBJECT_PARA                =
*             OBJECT_PARB                =
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


*      if sy-subrc eq 0.
*
*        write : / 'EMAIL SENT ON ',uemail.
*      endif.



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
        loop at it_taz2 into wa_taz2 where pernr eq wa_taz1-pernr.
          format color 5.
          write : / 'EMAIL HAS BEEN SENT ON',wa_taz2-usrid_long.
        endloop.
      endif.
    else.
      loop at it_taz2 into wa_taz2 where pernr eq wa_taz1-pernr.
        format color 6.
        write : / 'NO DATA FOUND FOR : ',wa_taz2-usrid_long.
      endloop.

    endif.
  endloop.

endform.
*&---------------------------------------------------------------------*
*&      Form  EMAIL_SM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form email_sm1 .
**************ONLY SELECTED DIVISION***********
  loop at it_tab8 into wa_tab8.
    select single * from zdsmter where zmonth eq month and zyear eq year and bzirk eq wa_tab8-reg.
    if sy-subrc eq 0.
      select single * from yterrallc where bzirk eq zdsmter-zdsm and endda ge sy-datum.
      if sy-subrc eq 0.
        select single * from pa0001 where plans eq yterrallc-plans  and endda ge sy-datum.
        if sy-subrc eq 0.
          wa_taz1-pernr = pa0001-pernr.
          wa_taz1-bzirk = yterrallc-bzirk.
        endif.
      endif.
    endif.
    collect wa_taz1 into it_taz1.
    clear wa_taz1.
  endloop.

  sort it_taz1 by pernr.
  delete adjacent duplicates from it_taz1 comparing pernr.

  loop at it_taz1 into wa_taz1.
    select single * from pa0105 where pernr eq wa_taz1-pernr and subty eq '0010'.
    if sy-subrc eq 0.
      wa_taz2-pernr = wa_taz1-pernr.
      wa_taz2-bzirk = wa_taz1-bzirk.
      wa_taz2-usrid_long = pa0105-usrid_long.
      collect wa_taz2 into it_taz2.
      clear wa_taz2.
    endif.
  endloop.

  sort it_tab8 by seq.
  sort it_zm2 by zm.
  sort it_rm2 by reg rm.
  sort it_pso2 by reg zm rm bzirk.
  concatenate lyear+2(2) '-' cyear+2(2) into ly.
  concatenate cyear+2(2) '-' ccyear+2(2) into cy.
  select single * from t247 where spras eq 'EN' and mnr eq date1+4(2).
  if sy-subrc eq 0.
    nmonth1 = t247-ktx.
  endif.
  select single * from t247 where spras eq 'EN' and mnr eq date4+4(2).
  if sy-subrc eq 0.
    nmonth2 = t247-ktx.
  endif.
  select single * from t247 where spras eq 'EN' and mnr eq date5+4(2).
  if sy-subrc eq 0.
    nmonth3 = t247-ktx.
  endif.

  options-tdgetotf = 'X'.
  loop at it_taz1 into wa_taz1 where pernr ne '00000000'.
    on change of wa_tab8-reg.
      a = 0.
    endon.
    loop at it_tab8 into wa_tab8 .
*      WHERE ZMPERNR = WA_TAP1-PERNR.
      select single * from zdsmter where zmonth eq month and zyear eq year and zdsm eq wa_taz1-bzirk and bzirk eq wa_tab8-reg.
      if sy-subrc eq 0.
        loop at it_zm2 into wa_zm2 where reg = wa_tab8-reg and div eq ddiv and cgrw ge grw1 and cgrw le grw2 and ccumm ge per1 and ccumm le per2.
          a = 1.
        endloop.
        loop at it_rm2 into wa_rm2 where reg = wa_tab8-reg and div eq ddiv and cgrw ge grw1 and cgrw le grw2 and ccumm ge per1 and ccumm le per2.
          a = 1.
        endloop.
        loop at it_pso2 into wa_pso2 where reg = wa_tab8-reg and div eq ddiv and cgrw ge grw1 and cgrw le grw2 and ccumm ge per1 and ccumm le per2.
          a = 1.
        endloop.
      endif.
    endloop.
    if a eq 1.
      call function 'OPEN_FORM'
        exporting
          device   = 'PRINTER'
          dialog   = ''
*         form     = 'ZSR24_1'
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
          form        = 'ZSR11_N1_3N'
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
      perform zm_div2.

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

*  write s_budat-low to wa_d1 dd/mm/yyyy.
*  write s_budat-high to wa_d2 dd/mm/yyyy.

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
      concatenate 'SR-11' 'SM'  into doc_chng-obj_descr separated by space.
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

      concatenate 'SR-11' '.' sy-datum into objpack-obj_descr separated by space.
      objpack-doc_size = righe_attachment * 255.
      append objpack.
      clear objpack.

*  LOOP at it_tac4 INTO wa_tac4.
*    WRITE : / wa_tac4-bzirk,wa_tac4-usrid_long.
      loop at it_taz2 into wa_taz2 where pernr = wa_taz1-pernr.
        reclist-receiver =   wa_taz2-usrid_long.
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


*      if sy-subrc eq 0.
*
*        write : / 'EMAIL SENT ON ',uemail.
*      endif.



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
      loop at it_taz2 into wa_taz2 where pernr eq wa_taz1-pernr.
        format color 5.
        write : / 'EMAIL HAS BEEN SENT ON',wa_taz2-usrid_long.
      endloop.
    else.
      loop at it_taz2 into wa_taz2 where pernr eq wa_taz1-pernr.
        format color 6.
        write : / 'NO DATA FOUND FOR : ',wa_taz2-usrid_long.
      endloop.

    endif.
  endloop.

endform.
*&---------------------------------------------------------------------*
*&      Form  ZM_DIV1_1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form zm_div1_1 .


  loop at it_tab8 into wa_tab8 where reg ne space and zmpernr eq wa_tap1-pernr.
*    SELECT SINGLE * FROM ZDSMTER WHERE ZMONTH EQ MONTH AND ZYEAR EQ YEAR AND ZDSM EQ WA_TAZ1-BZIRK AND BZIRK EQ WA_TAB8-REG.
*    IF SY-SUBRC EQ 0.
    clear : rm_name,rm_short,pjoin_dt,zm_name,zone,rm_zone,zdiff,a.

    on change of wa_tab8-reg.
      call function 'WRITE_FORM'
        exporting
          element = 'V2'
          window  = 'MAIN'.
      call function 'WRITE_FORM'
        exporting
          element = 'VL'
          window  = 'MAIN'.
    endon.

    on change of wa_tab8-reg.
      zdiff = wa_tab8-lysale - wa_tab8-lysalec.
      call function 'WRITE_FORM'
        exporting
          element = 'DET1'
          window  = 'MAIN'.
      if zdiff gt 1 or zdiff lt -1.
        if wa_tab8-lysalec gt 0.
          call function 'WRITE_FORM'
            exporting
              element = 'DET2'
              window  = 'MAIN'.
        endif.
      endif.
    endon.

    loop at it_zm2 into wa_zm2 where reg = wa_tab8-reg and ctar gt 0 .
      if wa_zm2-zm ne '      '.
        if wa_zm2-cgrw ge grw1 and wa_zm2-cgrw le grw2.
          if wa_zm2-ccumm ge per1 and wa_zm2-ccumm le per2.
            call function 'WRITE_FORM'
              exporting
                element = 'VL'
                window  = 'MAIN'.
            clear : rdiff.
            dzmdiff = wa_zm2-lysale - wa_zm2-lysalec.
            call function 'WRITE_FORM'
              exporting
                element = 'DZM1'
                window  = 'MAIN'.
            if dzmdiff gt 1 or dzmdiff lt -1.
              if wa_zm2-lysalec gt 0.
                call function 'WRITE_FORM'
                  exporting
                    element = 'DZM2'
                    window  = 'MAIN'.
              endif.
            endif.
            call function 'WRITE_FORM'
              exporting
                element = 'DZM3'
                window  = 'MAIN'.
          endif.
        endif.
      endif.
      loop at it_rm2 into wa_rm2 where reg = wa_tab8-reg and zm = wa_zm2-zm and ctar gt 0.
        if wa_rm2-cgrw ge grw1 and wa_rm2-cgrw le grw2.
          if wa_rm2-ccumm ge per1 and wa_rm2-ccumm le per2.
            call function 'WRITE_FORM'
              exporting
                element = 'VL'
                window  = 'MAIN'.
            clear : rdiff.
            rdiff = wa_rm2-lysale - wa_rm2-lysalec.
            call function 'WRITE_FORM'
              exporting
                element = 'RM1'
                window  = 'MAIN'.
            if rdiff gt 1 or rdiff lt -1.
              if wa_rm2-lysalec gt 0.
                call function 'WRITE_FORM'
                  exporting
                    element = 'RM2'
                    window  = 'MAIN'.
              endif.
            endif.
            call function 'WRITE_FORM'
              exporting
                element = 'RM3'
                window  = 'MAIN'.
          endif.
        endif.
        loop at it_pso2 into wa_pso2 where rm = wa_rm2-rm and ctar gt 0.
          if wa_pso2-cgrw ge grw1 and wa_pso2-cgrw le grw2.
            if wa_pso2-ccumm ge per1 and wa_pso2-ccumm le per2.
              call function 'WRITE_FORM'
                exporting
                  element = 'VL'
                  window  = 'MAIN'.
              clear : pdiff.
              pdiff = wa_pso2-lysale - wa_pso2-lysalec.
              call function 'WRITE_FORM'
                exporting
                  element = 'PSO1'
                  window  = 'MAIN'.
              if pdiff gt 1 or pdiff lt -1.
                if wa_pso2-lysalec gt 0.
                  call function 'WRITE_FORM'
                    exporting
                      element = 'PSO2'
                      window  = 'MAIN'.
                endif.
              endif.
              call function 'WRITE_FORM'
                exporting
                  element = 'PSO3'
                  window  = 'MAIN'.
            endif.
          endif.
        endloop.
      endloop.
    endloop.
    at last.
      b = 1.
    endat.
    at end of reg.
      call function 'WRITE_FORM'
        exporting
          element = 'L2'
          window  = 'MAIN'.
    endat.
    if b ne 1 .
      at end of reg.
        call function 'WRITE_FORM'
          exporting
            element = 'L1'
            window  = 'MAIN'.
      endat.
    endif.
*    ENDIF.
  endloop.

endform.
*&---------------------------------------------------------------------*
*&      Form  ZM_DIV2_1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form zm_div2_1 .

  loop at it_tab8 into wa_tab8 where reg ne space and zmpernr eq wa_tap1-pernr.
*    SELECT SINGLE * FROM ZDSMTER WHERE ZMONTH EQ MONTH AND ZYEAR EQ YEAR AND ZDSM EQ WA_TAZ1-BZIRK AND BZIRK EQ WA_TAB8-REG.
*    IF SY-SUBRC EQ 0.
    clear : rm_name,rm_short,pjoin_dt,zm_name,zone,rm_zone,zdiff,a.

    on change of wa_tab8-reg.
      call function 'WRITE_FORM'
        exporting
          element = 'V2'
          window  = 'MAIN'.
      call function 'WRITE_FORM'
        exporting
          element = 'VL'
          window  = 'MAIN'.
    endon.

    on change of wa_tab8-reg.
      zdiff = wa_tab8-lysale - wa_tab8-lysalec.
      call function 'WRITE_FORM'
        exporting
          element = 'DET1'
          window  = 'MAIN'.
      if zdiff gt 1 or zdiff lt -1.
        if wa_tab8-lysalec gt 0.
          call function 'WRITE_FORM'
            exporting
              element = 'DET2'
              window  = 'MAIN'.
        endif.
      endif.
    endon.

    loop at it_zm2 into wa_zm2 where reg = wa_tab8-reg and ctar gt 0.
      if wa_zm2-zm ne '      '.
        if wa_zm2-div eq ddiv.
          if wa_zm2-cgrw ge grw1 and wa_zm2-cgrw le grw2.
            if wa_zm2-ccumm ge per1 and wa_zm2-ccumm le per2.
              call function 'WRITE_FORM'
                exporting
                  element = 'VL'
                  window  = 'MAIN'.
              clear : rdiff.
              dzmdiff = wa_zm2-lysale - wa_zm2-lysalec.
              call function 'WRITE_FORM'
                exporting
                  element = 'DZM1'
                  window  = 'MAIN'.
              if dzmdiff gt 1 or dzmdiff lt -1.
                if wa_zm2-lysalec gt 0.
                  call function 'WRITE_FORM'
                    exporting
                      element = 'DZM2'
                      window  = 'MAIN'.
                endif.
              endif.
              call function 'WRITE_FORM'
                exporting
                  element = 'DZM3'
                  window  = 'MAIN'.
            endif.
          endif.
        endif.
      endif.
      loop at it_rm2 into wa_rm2 where reg = wa_tab8-reg and zm = wa_zm2-zm and ctar gt 0.
        if wa_rm2-cgrw ge grw1 and wa_rm2-cgrw le grw2.
          if wa_rm2-ccumm ge per1 and wa_rm2-ccumm le per2.
            if wa_rm2-div eq ddiv.
              call function 'WRITE_FORM'
                exporting
                  element = 'VL'
                  window  = 'MAIN'.
              clear : rdiff.
              rdiff = wa_rm2-lysale - wa_rm2-lysalec.
              call function 'WRITE_FORM'
                exporting
                  element = 'RM1'
                  window  = 'MAIN'.
              if rdiff gt 1 or rdiff lt -1.
                if wa_rm2-lysalec gt 0.
                  call function 'WRITE_FORM'
                    exporting
                      element = 'RM2'
                      window  = 'MAIN'.
                endif.
              endif.
              call function 'WRITE_FORM'
                exporting
                  element = 'RM3'
                  window  = 'MAIN'.
            endif.
          endif.
        endif.
        loop at it_pso2 into wa_pso2 where rm = wa_rm2-rm and ctar gt 0 and div eq ddiv.
          if wa_pso2-cgrw ge grw1 and wa_pso2-cgrw le grw2.
            if wa_pso2-ccumm ge per1 and wa_pso2-ccumm le per2.
              call function 'WRITE_FORM'
                exporting
                  element = 'VL'
                  window  = 'MAIN'.
              clear : pdiff.
              pdiff = wa_pso2-lysale - wa_pso2-lysalec.
              call function 'WRITE_FORM'
                exporting
                  element = 'PSO1'
                  window  = 'MAIN'.
              if pdiff gt 1 or pdiff lt -1.
                if wa_pso2-lysalec gt 0.
                  call function 'WRITE_FORM'
                    exporting
                      element = 'PSO2'
                      window  = 'MAIN'.
                endif.
              endif.
              call function 'WRITE_FORM'
                exporting
                  element = 'PSO3'
                  window  = 'MAIN'.
            endif.
          endif.
        endloop.
      endloop.
    endloop.
    at last.
      b = 1.
    endat.
    at end of reg.
      call function 'WRITE_FORM'
        exporting
          element = 'L2'
          window  = 'MAIN'.
    endat.
    if b ne 1 .
      at end of reg.
        call function 'WRITE_FORM'
          exporting
            element = 'L1'
            window  = 'MAIN'.
      endat.
    endif.
*    ENDIF.
  endloop.

endform.
*&---------------------------------------------------------------------*
*&      Form  SM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form sm .


  loop at it_tab6 into wa_tab6.
    select single * from yterrallc where bzirk eq wa_tab6-bzirk and endda ge date2.
    if sy-subrc eq 0.
*    WRITE : / 'date2',date2.
      clear : t_sale,lyt,lls,lys,lgrw,qt1,qt2,qt3,qt4,t1,t2,t3,t4,q1,q2,q3,q4, lsqrt5,lsqrtc5,cqtr,lcummsr.
*    WRITE : / wa_TAB6-reg,wa_TAB6-rm,wa_TAB6-bzirk,wa_TAB6-plans,wa_TAB6-pernr,wa_TAB6-ename,wa_TAB6-zz_hqdesc,wa_TAB6-join_dt,wa_TAB6-div,WA_TAB6-TYP.
      select single * from zdsmter where zmonth eq month and zyear eq year and bzirk eq wa_tab6-reg.
      if sy-subrc eq 0.
        wa_smtab7-sm = zdsmter-zdsm.
        wa_smtab71-sm = zdsmter-zdsm.
      endif.
      wa_smtab7-reg = wa_tab6-reg.
*      wa_smtab71-reg = wa_tab6-reg.
      wa_smtab7-rm = wa_tab6-rm.
      wa_smtab7-zmpernr = wa_tab6-zmpernr.
      read table it_cs into wa_cs with key bzirk = wa_tab6-bzirk.  "current , last & last to last month sale.
      if sy-subrc eq 0.
        wa_smtab7-c1sale = wa_cs-c1sale.
        wa_smtab71-c1sale = wa_cs-c1sale.
        wa_smtab7-c2sale = wa_cs-c2sale.
        wa_smtab7-c3sale = wa_cs-c3sale.
      endif.

      read table it_cptar1 into wa_cptar1 with key bzirk = wa_tab6-bzirk.  "current , last & last to last month TARGET.
      if sy-subrc eq 0.
        wa_smtab7-t1 = wa_cptar1-t1.
        wa_smtab71-t1 = wa_cptar1-t1.
        wa_smtab7-t2 = wa_cptar1-t2.
        wa_smtab7-t3 = wa_cptar1-t3.
      endif.

      read table it_lly1 into wa_lly1 with key bzirk = wa_tab6-bzirk.  "LAST TO LAST YEAR SALE.
      if sy-subrc eq 0.
        clear : qt1,qt2,qt3,qt4.
        qt1 = wa_lly1-m1 + wa_lly1-m2 + wa_lly1-m3.
        qt2 = wa_lly1-m4 + wa_lly1-m5 + wa_lly1-m6.
        qt3 = wa_lly1-m7 + wa_lly1-m8 + wa_lly1-m9.
        qt4 = wa_lly1-m10 + wa_lly1-m11 + wa_lly1-m12.
        wa_smtab7-llsqrt1 = qt1.
        wa_smtab7-llsqrt2 = qt2.
        wa_smtab7-llsqrt3 = qt3.
        wa_smtab7-llsqrt4 = qt4.
      endif.

*    read table it_lqt1 into wa_lqt1 with key bzirk = wa_tab6-bzirk.  "LAST  YEAR SALE.
*    if sy-subrc eq 0.
*      wa_smtab7-lsqrt1 = wa_lqt1-qt1.
*      wa_smtab7-lsqrt2 = wa_lqt1-qt2.
*      wa_smtab7-lsqrt3 = wa_lqt1-qt3.
*      wa_smtab7-lsqrt4 = wa_lqt1-qt4.
*      lsqrt5 = wa_lqt1-qt1 + wa_lqt1-qt2 + wa_lqt1-qt3 + wa_lqt1-qt4.
*      wa_smtab7-lsqrt5 = lsqrt5.
*    endif.

      read table it_lqtc1 into wa_lqtc1 with key bzirk = wa_tab6-bzirk.  "LAST  YEAR SALE from .
      if sy-subrc eq 0.
        wa_smtab7-lsqrtc1 = wa_lqtc1-qt1.
        wa_smtab7-lsqrtc2 = wa_lqtc1-qt2.
        wa_smtab7-lsqrtc3 = wa_lqtc1-qt3.
        wa_smtab7-lsqrtc4 = wa_lqtc1-qt4.
        lsqrtc5 = wa_lqtc1-qt1 + wa_lqtc1-qt2 + wa_lqtc1-qt3 + wa_lqtc1-qt4.
        wa_smtab7-lsqrtc = lsqrtc5.
      endif.

      read table it_lcummsr1_zm into wa_lcummsr1_zm with key bzirk = wa_tab6-bzirk.  "LAST  YEAR CUMMULATIVE SALE from ZRCUMPSO.
      if sy-subrc eq 0.
        wa_smtab7-lcummsr = wa_lcummsr1_zm-lcumm_sale.
      endif.

*    read table it_lytq1 into wa_lytq1 with key bzirk = wa_tab6-bzirk.  "LAST YEAR Target.
*    if sy-subrc eq 0.
*      wa_smtab7-ltqrt1 = wa_lytq1-qrt1.
*      wa_smtab7-ltqrt2 = wa_lytq1-qrt2.
*      wa_smtab7-ltqrt3 = wa_lytq1-qrt3.
*      wa_smtab7-ltqrt4 = wa_lytq1-qrt4.
*    endif.

*    read table it_cqt1 into wa_cqt1 with key bzirk = wa_tab6-bzirk.  "CURRENT  YEAR SALE.
*    if sy-subrc eq 0.
*      wa_smtab7-csqrt1 = wa_cqt1-qt1.
*      wa_smtab7-csqrt2 = wa_cqt1-qt2.
*      wa_smtab7-csqrt3 = wa_cqt1-qt3.
*      wa_smtab7-csqrt4 = wa_cqt1-qt4.
*    endif.
*
*    read table it_cyqt1 into wa_cyqt1 with key bzirk = wa_tab6-bzirk.  "CURRENT  YEAR TARGET.
*    if sy-subrc eq 0.
*      wa_smtab7-ctqrt1 = wa_cyqt1-qrt1.
*      wa_smtab7-ctqrt2 = wa_cyqt1-qrt2.
*      wa_smtab7-ctqrt3 = wa_cyqt1-qrt3.
*      wa_smtab7-ctqrt4 = wa_cyqt1-qrt4.
*    endif.
****************TERR*************
*    READ TABLE IT_APR INTO WA_APR WITH KEY ZM = WA_TAB6-REG RM = WA_TAB6-RM BZIRK = WA_TAB6-BZIRK.
*    IF SY-SUBRC EQ 0.
*      APRSALE = WA_APR-NETVAL.
*      APRTAR = WA_APR-TAR.
*    ENDIF.
*    READ TABLE IT_MAY INTO WA_MAY WITH KEY ZM = WA_TAB6-REG RM = WA_TAB6-RM BZIRK = WA_TAB6-BZIRK.
*    IF SY-SUBRC EQ 0.
*      MAYSALE = WA_MAY-NETVAL.
*      MAYTAR = WA_MAY-TAR.
*    ENDIF.
*    READ TABLE IT_JUN INTO WA_JUN WITH KEY ZM = WA_TAB6-REG RM = WA_TAB6-RM BZIRK = WA_TAB6-BZIRK.
*    IF SY-SUBRC EQ 0.
*      JUNSALE = WA_JUN-NETVAL.
*      JUNTAR = WA_JUN-TAR.
*    ENDIF.
*wa_smtab7-csqrt1 = APRSALE + MAYSALE + JUNSALE.
*    wa_smtab7-ctqrt1 = APRTAR + MAYTAR + JUNTAR.
*************************************
      read table it_cummsr2_zm into wa_cummsr2_zm with key bzirk = wa_tab6-bzirk.  "CURRENT  YEAR CUMMULATIVE SALE FROM ZRCUMPSO.
      if sy-subrc eq 0.
        wa_smtab7-cummsr = wa_cummsr2_zm-ccumm_sale.
      endif.


************ CURRENT MONTH TARGET*************
      read table it_cmtar into wa_cmtar with key bzirk = wa_tab6-bzirk.
      if sy-subrc eq 0.
        wa_smtab7-ctar = wa_cmtar-ctar.
      endif.

      read table it_lcumms1 into wa_lcumms1 with key bzirk = wa_tab6-bzirk.  "last year cummulative sale.
      if sy-subrc eq 0.
        wa_smtab7-lcumms = wa_lcumms1-lcumm_sale.
      endif.

      read table it_cumms2_zm into wa_cumms2_zm with key bzirk = wa_tab6-bzirk.  "CURRENT year cummulative sale.
      if sy-subrc eq 0.
        wa_smtab7-cumms = wa_cumms2_zm-ccumm_sale.
      endif.

      read table it_ccyt1_zm into wa_ccyt1_zm with key bzirk = wa_tab6-bzirk.  "CURRENT year cummulative TARGET.
      if sy-subrc eq 0.
        wa_smtab7-cummt = wa_ccyt1_zm-cyt.
      endif.

      collect wa_smtab7 into it_smtab7.
      clear wa_smtab7.

      collect wa_smtab71 into it_smtab71.
      clear wa_smtab71.
    endif.
  endloop.
****************************************************************************************************************************

  sort it_smtab7 by sm reg rm.
  loop at it_smtab7 into wa_smtab7 .
    clear : lpqrt1,lpqrt2,lpqrt1,lpqrt3,lpqrt4,lcumm,lgrw,pjoin_dt,incrdt,ltqrt,llsqrt,lsqrt,
            cpqrt1,cpqrt2,cpqrt1,cpqrt3,cpqrt4,ccumm,cgrw, cp1,cp2,cp3,
            ls1,ls2,ls3,ls4, lsc1,lsc2,lsc3,lsc4,cs1,cs2,cs3,cs4, lysale,cysale,lysalec, prom, sl1, sl2, sl3.

    wa_smtab9-sm = wa_smtab7-sm.
*    wa_smtab9-rm = wa_smtab7-rm.

    select single * from yterrallc where bzirk eq wa_smtab7-sm and endda ge sy-datum.
    if sy-subrc eq 0.
      select single * from pa0001 where plans eq yterrallc-plans and endda ge sy-datum.
      if sy-subrc eq 0.
        wa_smtab9-smpernr = pa0001-pernr.
      endif.
    endif.

*    wa_smtab9-smpernr = wa_smtab7-smpernr.

    select single * from pa0302 where pernr eq wa_smtab9-smpernr and massn eq '01'.
    if sy-subrc eq 0.
      concatenate pa0302-begda+4(2) '/' pa0302-begda+0(4) into pjoin_dt.
      wa_smtab9-join_dt = pjoin_dt.
      wa_smtab9-join_date = pa0302-begda.
    endif.

*    WRITE : /1 wa_smtab7-reg,8 wa_smtab7-rm,16(8) wa_smtab7-llsqrt1,27(8) wa_smtab7-llsqrt2,37(8) wa_smtab7-llsqrt3,47(8) wa_smtab7-llsqrt4.
*    WRITE : 55(8) wa_smtab7-lsqrt1,65(8) wa_smtab7-lsqrt2,75(8) wa_smtab7-lsqrt3,85(8) wa_smtab7-lsqrt4.
*    WRITE : 95(8) wa_smtab7-ltqrt1,105(8) wa_smtab7-ltqrt2,115(8) wa_smtab7-ltqrt3,125(8) wa_smtab7-ltqrt4.
*    WRITE : 135(8) wa_smtab7-csqrt1,145(8) wa_smtab7-csqrt2,155(8) wa_smtab7-csqrt3,165(8) wa_smtab7-csqrt4.
*    WRITE : 175(8) wa_smtab7-ctqrt1,185(8) wa_smtab7-ctqrt2,195(8) wa_smtab7-ctqrt3,205(8) wa_smtab7-ctqrt4.
**************** LAST YEAR SALE PERFORMANVE ***********
***************** 1ST QRT *****************
    clear : aprsale,maysale,junsale,julsale,augsale,sepsale,octsale,novsale,decsale,jansale,febsale,marsale.
    clear : aprtar,maytar,juntar,jultar,augtar,septar,octtar,novtar,dectar,jantar,febtar,martar.

    on change of wa_smtab7-sm.
      loop at it_lapr into wa_lapr where sm = wa_smtab7-sm.
        aprsale = aprsale +  wa_lapr-netval.
        aprtar = aprtar + wa_lapr-tar.
        wa_dlapr-aprsale = wa_lapr-netval.
        wa_dlapr-aprtar = wa_lapr-tar.
        wa_dlapr-bzirk = wa_lapr-sm.
        collect wa_dlapr into it_dlapr.
        clear wa_dlapr.
      endloop.
    endon.

    on change of wa_smtab7-reg.
      loop at it_lapr into wa_lapr where zm = wa_smtab7-reg.
*        aprsale = aprsale +  wa_lapr-netval.
*        aprtar = aprtar + wa_lapr-tar.
        wa_dlapr-aprsale = wa_lapr-netval.
        wa_dlapr-aprtar = wa_lapr-tar.
        wa_dlapr-bzirk = wa_lapr-zm.
        collect wa_dlapr into it_dlapr.
        clear wa_dlapr.
      endloop.
    endon.

    loop at it_lapr into wa_lapr where rm = wa_smtab7-rm.
      wa_rdlapr-aprsale = wa_lapr-netval.
      wa_rdlapr-aprtar = wa_lapr-tar.
      wa_rdlapr-bzirk = wa_lapr-rm.
      collect wa_rdlapr into it_rdlapr.
      clear wa_rdlapr.
    endloop.
    loop at it_lapr into wa_lapr where dzm = wa_smtab7-zm.
      wa_zdlapr-aprsale = wa_lapr-netval.
      wa_zdlapr-aprtar = wa_lapr-tar.
      wa_zdlapr-bzirk = wa_lapr-rm.
      collect wa_zdlapr into it_zdlapr.
      clear wa_zdlapr.
    endloop.

    on change of wa_smtab7-sm.
      loop at it_lmay into wa_lmay where sm = wa_smtab7-sm.
        maysale = maysale +  wa_lmay-netval.
        maytar = maytar + wa_lmay-tar.
        wa_dlapr-maysale = wa_lmay-netval.
        wa_dlapr-maytar = wa_lmay-tar.
        wa_dlapr-bzirk = wa_lmay-sm.
        collect wa_dlapr into it_dlapr.
        clear wa_dlapr.
      endloop.
    endon.

    on change of wa_smtab7-reg.
      loop at it_lmay into wa_lmay where zm = wa_smtab7-reg.
*        maysale = maysale +  wa_lmay-netval.
*        maytar = maytar + wa_lmay-tar.
        wa_dlapr-maysale = wa_lmay-netval.
        wa_dlapr-maytar = wa_lmay-tar.
        wa_dlapr-bzirk = wa_lmay-zm.
        collect wa_dlapr into it_dlapr.
        clear wa_dlapr.
      endloop.
    endon.
    loop at it_lmay into wa_lmay where rm = wa_smtab7-rm.
      wa_rdlapr-maysale = wa_lmay-netval.
      wa_rdlapr-maytar = wa_lmay-tar.
      wa_rdlapr-bzirk = wa_lmay-rm.
      collect wa_rdlapr into it_rdlapr.
      clear wa_rdlapr.
    endloop.
    loop at it_lmay into wa_lmay where dzm = wa_smtab7-zm.
      wa_zdlapr-maysale = wa_lmay-netval.
      wa_zdlapr-maytar = wa_lmay-tar.
      wa_zdlapr-bzirk = wa_lmay-rm.
      collect wa_zdlapr into it_zdlapr.
      clear wa_zdlapr.
    endloop.

    on change of wa_smtab7-sm.
      loop at it_ljun into wa_ljun where sm = wa_smtab7-sm.
        junsale = junsale +  wa_ljun-netval.
        juntar = juntar + wa_ljun-tar.
        wa_dlapr-junsale = wa_ljun-netval.
        wa_dlapr-juntar = wa_ljun-tar.
        wa_dlapr-bzirk = wa_ljun-sm.
        collect wa_dlapr into it_dlapr.
        clear wa_dlapr.
      endloop.
    endon.

    on change of wa_smtab7-reg.
      loop at it_ljun into wa_ljun where zm = wa_smtab7-reg.
*        junsale = junsale +  wa_ljun-netval.
*        juntar = juntar + wa_ljun-tar.
        wa_dlapr-junsale = wa_ljun-netval.
        wa_dlapr-juntar = wa_ljun-tar.
        wa_dlapr-bzirk = wa_ljun-zm.
        collect wa_dlapr into it_dlapr.
        clear wa_dlapr.
      endloop.
    endon.
    loop at it_ljun into wa_ljun where rm = wa_smtab7-rm.
      wa_rdlapr-junsale = wa_ljun-netval.
      wa_rdlapr-juntar = wa_ljun-tar.
      wa_rdlapr-bzirk = wa_ljun-rm.
      collect wa_rdlapr into it_rdlapr.
      clear wa_rdlapr.
    endloop.
    loop at it_ljun into wa_ljun where dzm = wa_smtab7-zm.
      wa_zdlapr-junsale = wa_ljun-netval.
      wa_zdlapr-juntar = wa_ljun-tar.
      wa_zdlapr-bzirk = wa_ljun-rm.
      collect wa_zdlapr into it_zdlapr.
      clear wa_zdlapr.
    endloop.

    wa_smtab7-lsqrt1 = aprsale + maysale + junsale.
    wa_smtab7-ltqrt1 = aprtar + maytar + juntar.
****************2ND QRT *******************
    on change of wa_smtab7-sm.
      loop at it_ljul into wa_ljul where sm = wa_smtab7-sm.
        julsale = julsale +  wa_ljul-netval.
        jultar = jultar + wa_ljul-tar.
        wa_dlapr-julsale = wa_ljul-netval.
        wa_dlapr-jultar = wa_ljul-tar.
        wa_dlapr-bzirk = wa_ljul-sm.
        collect wa_dlapr into it_dlapr.
        clear wa_dlapr.
      endloop.
    endon.

    on change of wa_smtab7-reg.
      loop at it_ljul into wa_ljul where zm = wa_smtab7-reg.
*        julsale = julsale +  wa_ljul-netval.
*        jultar = jultar + wa_ljul-tar.
        wa_dlapr-julsale = wa_ljul-netval.
        wa_dlapr-jultar = wa_ljul-tar.
        wa_dlapr-bzirk = wa_ljul-zm.
        collect wa_dlapr into it_dlapr.
        clear wa_dlapr.
      endloop.
    endon.

    loop at it_ljul into wa_ljul where rm = wa_smtab7-rm.
      wa_rdlapr-julsale = wa_ljul-netval.
      wa_rdlapr-jultar = wa_ljul-tar.
      wa_rdlapr-bzirk = wa_ljul-rm.
      collect wa_rdlapr into it_rdlapr.
      clear wa_rdlapr.
    endloop.
    loop at it_ljul into wa_ljul where dzm = wa_smtab7-zm.
      wa_zdlapr-julsale = wa_ljul-netval.
      wa_zdlapr-jultar = wa_ljul-tar.
      wa_zdlapr-bzirk = wa_ljul-rm.
      collect wa_zdlapr into it_zdlapr.
      clear wa_zdlapr.
    endloop.

    on change of wa_smtab7-sm.
      loop at it_laug into wa_laug where sm = wa_smtab7-sm.
        augsale = augsale +  wa_laug-netval.
        augtar = augtar + wa_laug-tar.
        wa_dlapr-augsale = wa_laug-netval.
        wa_dlapr-augtar = wa_laug-tar.
        wa_dlapr-bzirk = wa_laug-sm.
        collect wa_dlapr into it_dlapr.
        clear wa_dlapr.
      endloop.
    endon.

    on change of wa_smtab7-reg.
      loop at it_laug into wa_laug where zm = wa_smtab7-reg.
*        augsale = augsale +  wa_laug-netval.
*        augtar = augtar + wa_laug-tar.
        wa_dlapr-augsale = wa_laug-netval.
        wa_dlapr-augtar = wa_laug-tar.
        wa_dlapr-bzirk = wa_laug-zm.
        collect wa_dlapr into it_dlapr.
        clear wa_dlapr.
      endloop.
    endon.

    loop at it_laug into wa_laug where rm = wa_smtab7-rm.
      wa_rdlapr-augsale = wa_laug-netval.
      wa_rdlapr-augtar = wa_laug-tar.
      wa_rdlapr-bzirk = wa_laug-rm.
      collect wa_rdlapr into it_rdlapr.
      clear wa_rdlapr.
    endloop.
    loop at it_laug into wa_laug where dzm = wa_smtab7-zm.
      wa_zdlapr-augsale = wa_laug-netval.
      wa_zdlapr-augtar = wa_laug-tar.
      wa_zdlapr-bzirk = wa_laug-rm.
      collect wa_zdlapr into it_zdlapr.
      clear wa_zdlapr.
    endloop.

    on change of wa_smtab7-sm.
      loop at it_lsep into wa_lsep where sm = wa_smtab7-sm.
        sepsale = sepsale +  wa_lsep-netval.
        septar = septar + wa_lsep-tar.
        wa_dlapr-sepsale = wa_lsep-netval.
        wa_dlapr-septar = wa_lsep-tar.
        wa_dlapr-bzirk = wa_lsep-sm.
        collect wa_dlapr into it_dlapr.
        clear wa_dlapr.
      endloop.
    endon.
    on change of wa_smtab7-reg.
      loop at it_lsep into wa_lsep where zm = wa_smtab7-reg.
*        sepsale = sepsale +  wa_lsep-netval.
*        septar = septar + wa_lsep-tar.
        wa_dlapr-sepsale = wa_lsep-netval.
        wa_dlapr-septar = wa_lsep-tar.
        wa_dlapr-bzirk = wa_lsep-zm.
        collect wa_dlapr into it_dlapr.
        clear wa_dlapr.
      endloop.
    endon.
    loop at it_lsep into wa_lsep where rm = wa_smtab7-rm.
      wa_rdlapr-sepsale = wa_lsep-netval.
      wa_rdlapr-septar = wa_lsep-tar.
      wa_rdlapr-bzirk = wa_lsep-rm.
      collect wa_rdlapr into it_rdlapr.
      clear wa_rdlapr.
    endloop.
    loop at it_lsep into wa_lsep where dzm = wa_smtab7-zm.
      wa_zdlapr-sepsale = wa_lsep-netval.
      wa_zdlapr-septar = wa_lsep-tar.
      wa_zdlapr-bzirk = wa_lsep-rm.
      collect wa_zdlapr into it_zdlapr.
      clear wa_zdlapr.
    endloop.

    wa_smtab7-lsqrt2 = julsale + augsale + sepsale.
    wa_smtab7-ltqrt2 = jultar + augtar + septar.
****************3rd QRT *******************
    on change of wa_smtab7-sm.
      loop at it_loct into wa_loct where sm = wa_smtab7-sm.
        octsale = octsale +  wa_loct-netval.
        octtar = octtar + wa_loct-tar.
        wa_dlapr-octsale = wa_loct-netval.
        wa_dlapr-octtar = wa_loct-tar.
        wa_dlapr-bzirk = wa_loct-sm.
        collect wa_dlapr into it_dlapr.
        clear wa_dlapr.
      endloop.
    endon.

    on change of wa_smtab7-reg.
      loop at it_loct into wa_loct where zm = wa_smtab7-reg.
*        octsale = octsale +  wa_loct-netval.
*        octtar = octtar + wa_loct-tar.
        wa_dlapr-octsale = wa_loct-netval.
        wa_dlapr-octtar = wa_loct-tar.
        wa_dlapr-bzirk = wa_loct-zm.
        collect wa_dlapr into it_dlapr.
        clear wa_dlapr.
      endloop.
    endon.

    loop at it_loct into wa_loct where rm = wa_smtab7-rm.
      wa_rdlapr-octsale = wa_loct-netval.
      wa_rdlapr-octtar = wa_loct-tar.
      wa_rdlapr-bzirk = wa_loct-rm.
      collect wa_rdlapr into it_rdlapr.
      clear wa_rdlapr.
    endloop.
    loop at it_loct into wa_loct where dzm = wa_smtab7-zm.
      wa_zdlapr-octsale = wa_loct-netval.
      wa_zdlapr-octtar = wa_loct-tar.
      wa_zdlapr-bzirk = wa_loct-rm.
      collect wa_zdlapr into it_zdlapr.
      clear wa_zdlapr.
    endloop.
    on change of wa_smtab7-sm.
      loop at it_lnov into wa_lnov where sm = wa_smtab7-sm.
        novsale = novsale +  wa_lnov-netval.
        novtar = novtar + wa_lnov-tar.
        wa_dlapr-novsale = wa_lnov-netval.
        wa_dlapr-novtar = wa_lnov-tar.
        wa_dlapr-bzirk = wa_lnov-sm.
        collect wa_dlapr into it_dlapr.
        clear wa_dlapr.
      endloop.
    endon.

    on change of wa_smtab7-reg.
      loop at it_lnov into wa_lnov where zm = wa_smtab7-reg.
*        novsale = novsale +  wa_lnov-netval.
*        novtar = novtar + wa_lnov-tar.
        wa_dlapr-novsale = wa_lnov-netval.
        wa_dlapr-novtar = wa_lnov-tar.
        wa_dlapr-bzirk = wa_lnov-zm.
        collect wa_dlapr into it_dlapr.
        clear wa_dlapr.
      endloop.
    endon.

    loop at it_lnov into wa_lnov where rm = wa_smtab7-rm.
      wa_rdlapr-novsale = wa_lnov-netval.
      wa_rdlapr-novtar = wa_lnov-tar.
      wa_rdlapr-bzirk = wa_lnov-rm.
      collect wa_rdlapr into it_rdlapr.
      clear wa_rdlapr.
    endloop.
    loop at it_lnov into wa_lnov where dzm = wa_smtab7-zm.
      wa_zdlapr-novsale = wa_lnov-netval.
      wa_zdlapr-novtar = wa_lnov-tar.
      wa_zdlapr-bzirk = wa_lnov-rm.
      collect wa_zdlapr into it_zdlapr.
      clear wa_zdlapr.
    endloop.

    on change of wa_smtab7-sm.
      loop at it_ldec into wa_ldec where sm = wa_smtab7-sm.
        decsale = decsale +  wa_ldec-netval.
        dectar = dectar + wa_ldec-tar.
        wa_dlapr-decsale = wa_ldec-netval.
        wa_dlapr-dectar = wa_ldec-tar.
        wa_dlapr-bzirk = wa_ldec-sm.
        collect wa_dlapr into it_dlapr.
        clear wa_dlapr.
      endloop.
    endon.

    on change of wa_smtab7-reg.
      loop at it_ldec into wa_ldec where zm = wa_smtab7-reg.
*        decsale = decsale +  wa_ldec-netval.
*        dectar = dectar + wa_ldec-tar.
        wa_dlapr-decsale = wa_ldec-netval.
        wa_dlapr-dectar = wa_ldec-tar.
        wa_dlapr-bzirk = wa_ldec-zm.
        collect wa_dlapr into it_dlapr.
        clear wa_dlapr.
      endloop.
    endon.

    loop at it_ldec into wa_ldec where rm = wa_smtab7-rm.
      wa_rdlapr-decsale = wa_ldec-netval.
      wa_rdlapr-dectar = wa_ldec-tar.
      wa_rdlapr-bzirk = wa_ldec-rm.
      collect wa_rdlapr into it_rdlapr.
      clear wa_rdlapr.
    endloop.
    loop at it_ldec into wa_ldec where dzm = wa_smtab7-zm.
      wa_zdlapr-decsale = wa_ldec-netval.
      wa_zdlapr-dectar = wa_ldec-tar.
      wa_zdlapr-bzirk = wa_ldec-rm.
      collect wa_zdlapr into it_zdlapr.
      clear wa_zdlapr.
    endloop.

    wa_smtab7-lsqrt3 = octsale + novsale + decsale.
    wa_smtab7-ltqrt3 = octtar + novtar + dectar.

****************4TH QRT *******************
    on change of wa_smtab7-sm.
      loop at it_ljan into wa_ljan where sm = wa_smtab7-sm.
        jansale = jansale +  wa_ljan-netval.
        jantar = jantar + wa_ljan-tar.
        wa_dlapr-jansale = wa_ljan-netval.
        wa_dlapr-jantar = wa_ljan-tar.
        wa_dlapr-bzirk = wa_ljan-sm.
        collect wa_dlapr into it_dlapr.
        clear wa_dlapr.
      endloop.
    endon.
    on change of wa_smtab7-reg.
      loop at it_ljan into wa_ljan where zm = wa_smtab7-reg.
*        jansale = jansale +  wa_ljan-netval.
*        jantar = jantar + wa_ljan-tar.
        wa_dlapr-jansale = wa_ljan-netval.
        wa_dlapr-jantar = wa_ljan-tar.
        wa_dlapr-bzirk = wa_ljan-zm.
        collect wa_dlapr into it_dlapr.
        clear wa_dlapr.
      endloop.
    endon.

    loop at it_ljan into wa_ljan where rm = wa_smtab7-rm.
      wa_rdlapr-jansale = wa_ljan-netval.
      wa_rdlapr-jantar = wa_ljan-tar.
      wa_rdlapr-bzirk = wa_ljan-rm.
      collect wa_rdlapr into it_rdlapr.
      clear wa_rdlapr.
    endloop.
    loop at it_ljan into wa_ljan where dzm = wa_smtab7-zm.
      wa_zdlapr-jansale = wa_ljan-netval.
      wa_zdlapr-jantar = wa_ljan-tar.
      wa_zdlapr-bzirk = wa_ljan-rm.
      collect wa_zdlapr into it_zdlapr.
      clear wa_zdlapr.
    endloop.
    on change of wa_smtab7-sm.
      loop at it_lfeb into wa_lfeb where sm = wa_smtab7-sm.
        febsale = febsale +  wa_lfeb-netval.
        febtar = febtar + wa_lfeb-tar.
        wa_dlapr-febsale = wa_lfeb-netval.
        wa_dlapr-febtar = wa_lfeb-tar.
        wa_dlapr-bzirk = wa_lfeb-sm.
        collect wa_dlapr into it_dlapr.
        clear wa_dlapr.
      endloop.
    endon.
    on change of wa_smtab7-reg.
      loop at it_lfeb into wa_lfeb where zm = wa_smtab7-reg.
*      febsale = febsale +  wa_lfeb-netval.
*      febtar = febtar + wa_lfeb-tar.
        wa_dlapr-febsale = wa_lfeb-netval.
        wa_dlapr-febtar = wa_lfeb-tar.
        wa_dlapr-bzirk = wa_lfeb-zm.
        collect wa_dlapr into it_dlapr.
        clear wa_dlapr.
      endloop.
    endon.

    loop at it_lfeb into wa_lfeb where rm = wa_smtab7-rm.
      wa_rdlapr-febsale = wa_lfeb-netval.
      wa_rdlapr-febtar = wa_lfeb-tar.
      wa_rdlapr-bzirk = wa_lfeb-rm.
      collect wa_rdlapr into it_rdlapr.
      clear wa_rdlapr.
    endloop.
    loop at it_lfeb into wa_lfeb where dzm = wa_smtab7-zm.
      wa_zdlapr-febsale = wa_lfeb-netval.
      wa_zdlapr-febtar = wa_lfeb-tar.
      wa_zdlapr-bzirk = wa_lfeb-rm.
      collect wa_zdlapr into it_zdlapr.
      clear wa_zdlapr.
    endloop.

    on change of wa_smtab7-sm.
      loop at it_lmar into wa_lmar where sm = wa_smtab7-sm.
        marsale = marsale +  wa_lmar-netval.
        martar = martar + wa_lmar-tar.
        wa_dlapr-marsale = wa_lmar-netval.
        wa_dlapr-martar = wa_lmar-tar.
        wa_dlapr-bzirk = wa_lmar-sm.
        collect wa_dlapr into it_dlapr.
        clear wa_dlapr.
      endloop.
    endon.

    on change of wa_smtab7-reg.
      loop at it_lmar into wa_lmar where zm = wa_smtab7-reg.
*      marsale = marsale +  wa_lmar-netval.
*      martar = martar + wa_lmar-tar.
        wa_dlapr-marsale = wa_lmar-netval.
        wa_dlapr-martar = wa_lmar-tar.
        wa_dlapr-bzirk = wa_lmar-zm.
        collect wa_dlapr into it_dlapr.
        clear wa_dlapr.
      endloop.
    endon.

    loop at it_lmar into wa_lmar where rm = wa_smtab7-rm.
      wa_rdlapr-marsale = wa_lmar-netval.
      wa_rdlapr-martar = wa_lmar-tar.
      wa_rdlapr-bzirk = wa_lmar-rm.
      collect wa_rdlapr into it_rdlapr.
      clear wa_rdlapr.
    endloop.
    loop at it_lmar into wa_lmar where dzm = wa_smtab7-zm.
      wa_zdlapr-marsale = wa_lmar-netval.
      wa_zdlapr-martar = wa_lmar-tar.
      wa_zdlapr-bzirk = wa_lmar-rm.
      collect wa_zdlapr into it_zdlapr.
      clear wa_zdlapr.
    endloop.

    wa_smtab7-lsqrt4 = jansale + febsale + marsale.
    wa_smtab7-ltqrt4 = jantar + febtar + martar.
************************************************************
    if wa_smtab7-ltqrt1 gt 0.
      lpqrt1 = ( wa_smtab7-lsqrt1 / wa_smtab7-ltqrt1 ) * 100.
    endif.
    if wa_smtab7-ltqrt2 gt 0.
      lpqrt2 = ( wa_smtab7-lsqrt2 / wa_smtab7-ltqrt2 ) * 100.
    endif.
    if wa_smtab7-ltqrt3 gt 0.
      lpqrt3 = ( wa_smtab7-lsqrt3 / wa_smtab7-ltqrt3 ) * 100.
    endif.
    if wa_smtab7-ltqrt4 gt 0.
      lpqrt4 = ( wa_smtab7-lsqrt4 / wa_smtab7-ltqrt4 ) * 100.
    endif.
    wa_smtab9-lpqrt1 = lpqrt1.
    wa_smtab9-lpqrt2 = lpqrt2.
    wa_smtab9-lpqrt3 = lpqrt3.
    wa_smtab9-lpqrt4 = lpqrt4.


    ls1 = wa_smtab7-lsqrt1 / 1000.
    ls2 = wa_smtab7-lsqrt2 / 1000.
    ls3 = wa_smtab7-lsqrt3 / 1000.
    ls4 = wa_smtab7-lsqrt4 / 1000.
    wa_smtab9-lysale1 = ls1.
    wa_smtab9-lysale2 = ls2.
    wa_smtab9-lysale3 = ls3.
    wa_smtab9-lysale4 = ls4.
    lysale = ls1 + ls2 + ls3 + ls4.
    wa_smtab9-lysale = lysale.

    lsc1 = wa_smtab7-lsqrtc1 / 1000.
    lsc2 = wa_smtab7-lsqrtc2 / 1000.
    lsc3 = wa_smtab7-lsqrtc3 / 1000.
    lsc4 = wa_smtab7-lsqrtc4 / 1000.
    wa_smtab9-lysalec1 = lsc1.
    wa_smtab9-lysalec2 = lsc2.
    wa_smtab9-lysalec3 = lsc3.
    wa_smtab9-lysalec4 = lsc4.
    lysalec = lsc1 + lsc2 + lsc3 + lsc4.
    wa_smtab9-lysalec = lysalec.

************ LAST YEAR CUMMULATIVE***********
    ltqrt = wa_smtab7-ltqrt1 + wa_smtab7-ltqrt2 + wa_smtab7-ltqrt3 + wa_smtab7-ltqrt4 .
    if ltqrt gt 0.
      lcumm = ( ( wa_smtab7-lsqrt1 + wa_smtab7-lsqrt2 + wa_smtab7-lsqrt3 + wa_smtab7-lsqrt4 ) / ltqrt ) * 100.
    endif.
    wa_smtab9-lcumm = lcumm.
********************** LAST YEAR GROWTH ******************
    llsqrt = wa_smtab7-llsqrt1 + wa_smtab7-llsqrt2 + wa_smtab7-llsqrt3 + wa_smtab7-llsqrt4.
    if llsqrt gt 0.
      lgrw = ( ( wa_smtab7-lsqrt1 + wa_smtab7-lsqrt2 + wa_smtab7-lsqrt3 + wa_smtab7-lsqrt4 ) / llsqrt ) * 100 - 100.
    else.
      lgrw = 100.
    endif.
    wa_smtab9-lgrw = lgrw.
************* CURRENT MONTH TARGET************
    wa_smtab9-ctar = wa_smtab7-ctar .

**************** CURRENT YEAR SALE PERFORMANVE ***********
***************** 1ST QRT *****************
    clear : aprsale,maysale,junsale,julsale,augsale,sepsale,octsale,novsale,decsale,jansale,febsale,marsale.
    clear : aprtar,maytar,juntar,jultar,augtar,septar,octtar,novtar,dectar,jantar,febtar,martar.

    loop at it_apr into wa_apr where sm = wa_smtab7-sm.
      aprsale = aprsale +  wa_apr-netval.
      aprtar = aprtar + wa_apr-tar.
    endloop.
    loop at it_may into wa_may where sm = wa_smtab7-sm.
      maysale = maysale +  wa_may-netval.
      maytar = maytar + wa_may-tar.
    endloop.
    loop at it_jun into wa_jun where sm = wa_smtab7-sm.
      junsale = junsale +  wa_jun-netval.
      juntar = juntar + wa_jun-tar.
    endloop.
    wa_smtab7-csqrt1 = aprsale + maysale + junsale.
    wa_smtab7-ctqrt1 = aprtar + maytar + juntar.
****************2ND QRT *******************
    loop at it_jul into wa_jul where sm = wa_smtab7-sm.
      julsale = julsale +  wa_jul-netval.
      jultar = jultar + wa_jul-tar.
    endloop.
    loop at it_aug into wa_aug where sm = wa_smtab7-sm.
      augsale = augsale +  wa_aug-netval.
      augtar = augtar + wa_aug-tar.
    endloop.
    loop at it_sep into wa_sep where sm = wa_smtab7-sm.
      sepsale = sepsale +  wa_sep-netval.
      septar = septar + wa_sep-tar.
    endloop.
    wa_smtab7-csqrt2 = julsale + augsale + sepsale.
    wa_smtab7-ctqrt2 = jultar + augtar + septar.
****************3rd QRT *******************
    loop at it_oct into wa_oct where sm = wa_smtab7-sm.
      octsale = octsale +  wa_oct-netval.
      octtar = octtar + wa_oct-tar.
    endloop.
    loop at it_nov into wa_nov where sm = wa_smtab7-sm.
      novsale = novsale +  wa_nov-netval.
      novtar = novtar + wa_nov-tar.
    endloop.
    loop at it_dec into wa_dec where sm = wa_smtab7-sm.
      decsale = decsale +  wa_dec-netval.
      dectar = dectar + wa_dec-tar.
    endloop.
    wa_smtab7-csqrt3 = octsale + novsale + decsale.
    wa_smtab7-ctqrt3 = octtar + novtar + dectar.

****************4TH QRT *******************
    loop at it_jan into wa_jan where sm = wa_smtab7-sm.
      jansale = jansale +  wa_jan-netval.
      jantar = jantar + wa_jan-tar.
    endloop.
    loop at it_feb into wa_feb where sm = wa_smtab7-sm.
      febsale = febsale +  wa_feb-netval.
      febtar = febtar + wa_feb-tar.
    endloop.
    loop at it_mar into wa_mar where sm = wa_smtab7-sm.
      marsale = marsale +  wa_mar-netval.
      martar = martar + wa_mar-tar.
    endloop.
    wa_smtab7-csqrt4 = jansale + febsale + marsale.
    wa_smtab7-ctqrt4 = jantar + febtar + martar.

*************************************************
    if date2 ge f3date.
      if wa_smtab7-ctqrt1 gt 0.
        cpqrt1 = ( wa_smtab7-csqrt1 / wa_smtab7-ctqrt1 ) * 100.
      endif.
    endif.
    if date2 ge f6date.
      if wa_smtab7-ctqrt2 gt 0.
        cpqrt2 = ( wa_smtab7-csqrt2 / wa_smtab7-ctqrt2 ) * 100.
      endif.
    endif.
    if date2 ge f9date.
      if wa_smtab7-ctqrt3 gt 0.
        cpqrt3 = ( wa_smtab7-csqrt3 / wa_smtab7-ctqrt3 ) * 100.
      endif.
    endif.
    if date2 ge f12date.
      if wa_smtab7-ctqrt4 gt 0.
        cpqrt4 = ( wa_smtab7-csqrt4 / wa_smtab7-ctqrt4 ) * 100.
      endif.
    endif.

    wa_smtab9-cpqrt1 = cpqrt1.
    wa_smtab9-cpqrt2 = cpqrt2.
    wa_smtab9-cpqrt3 = cpqrt3.
    wa_smtab9-cpqrt4 = cpqrt4.

    if date2 ge f3date.
      cs1 = wa_smtab7-csqrt1 / 1000.
    endif.
    if date2 ge f6date.
      cs2 = wa_smtab7-csqrt2 / 1000.
    endif.
    if date2 ge f9date.
      cs3 = wa_smtab7-csqrt3 / 1000.
    endif.
    if date2 ge f12date.
      cs4 = wa_smtab7-csqrt4 / 1000.
    endif.

    wa_smtab9-cysale1 = cs1.
    wa_smtab9-cysale2 = cs2.
    wa_smtab9-cysale3 = cs3.
    wa_smtab9-cysale4 = cs4.

*    cysale = cs1 + cs2 + cs3 + cs4.
*    cysale = ( wa_smtab7-csqrt1 + wa_smtab7-csqrt2 + wa_smtab7-csqrt3 + wa_smtab7-csqrt4 ) / 1000.
*************logic for cummulative************************
    clear : v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12.
    if wa_smtab9-join_date le f1date.
      if date2 ge f1date.
        v1 = aprsale.
      endif.
    endif.
    if wa_smtab9-join_date le f2date.
      if date2 ge f2date.
        v2 = maysale.
      endif.
    endif.
    if wa_smtab9-join_date le f3date.
      if date2 ge f3date.
        v3 = junsale.
      endif.
    endif.
    if wa_smtab9-join_date le f4date.
      if date2 ge f4date.
        v4 = julsale.
      endif.
    endif.
    if wa_smtab9-join_date le f5date.
      if date2 ge f5date.
        v5 = augsale.
      endif.
    endif.
    if wa_smtab9-join_date le f6date.
      if date2 ge f6date.
        v6 = sepsale.
      endif.
    endif.
    if wa_smtab9-join_date le f7date.
      if date2 ge f7date.
        v7 = octsale.
      endif.
    endif.
    if wa_smtab9-join_date le f8date.
      if date2 ge f8date.
        v8 = novsale.
      endif.
    endif.
    if wa_smtab9-join_date le f9date.
      if date2 ge f9date.
        v9 = decsale.
      endif.
    endif.
    if wa_smtab9-join_date le f10date.
      if date2 ge f10date.
        v10 = jansale.
      endif.
    endif.
    if wa_smtab9-join_date le f11date.
      if date2 ge f11date.
        v11 = febsale.
      endif.
    endif.
    if wa_smtab9-join_date le f12date.
      if date2 ge f12date.
        v12 = marsale.
      endif.
    endif.
    cysale = ( v1 + v2 + v3 + v4 + v5 + v6 + v7 + v8 + v9 + v10 + v11 + v12 ) / 1000.
**************************************************************

    wa_smtab9-cysale = cysale.

************ CURRENT YEAR CUMMULATIVE***********
    if wa_smtab7-cummt gt 0.
      ccumm = ( wa_smtab7-cumms / wa_smtab7-cummt ) * 100.
    endif.
    wa_smtab9-ccumm = ccumm.

********************** CURRENT YEAR GROWTH ******************
*    IF WA_smtab7-LCUMMS GT 0.
*      CGRW = ( wa_smtab7-CUMMS / WA_smtab7-LCUMMS ) * 100 - 100.
*    ENDIF.
*    WA_smtab9-CGRW = CGRW.
***************CURRENT YEAR CUMMULATIVE GROWTH FROM ZRCUMPSO********
    if wa_smtab7-lcummsr gt 0.
      cgrw = ( wa_smtab7-cummsr / wa_smtab7-lcummsr ) * 100 - 100.
    else.
      cgrw = 100.
    endif.
    wa_smtab9-cgrw = cgrw.

***********************RM INCENTIVE********************************************
*    READ TABLE IT_INCT1 INTO WA_INCT1 WITH KEY PERNR = WA_smtab7-ZMPERNR.
*    IF SY-SUBRC EQ 0.
*      WA_smtab9-INCT = wa_inct1-betrg.
*    ENDIF.
**********CURRENT MONTH, LAST MONTH & LAST TO LAST MONTH PERFORMANCE******
    if wa_smtab7-t1 gt 0.
      cp1 = ( wa_smtab7-c1sale / wa_smtab7-t1 ) * 100.
    endif.
    if wa_smtab7-t2 gt 0.
      cp2 = ( wa_smtab7-c2sale / wa_smtab7-t2 ) * 100.
    endif.
    if wa_smtab7-t3 gt 0.
      cp3 = ( wa_smtab7-c3sale / wa_smtab7-t3 ) * 100.
    endif.
    wa_smtab9-cp1 = cp1.
    wa_smtab9-cp2 = cp2.
    wa_smtab9-cp3 = cp3.
    sl1 = wa_smtab7-c1sale / 1000.
    sl2 = wa_smtab7-c2sale / 1000.
    sl3 = wa_smtab7-c3sale / 1000.
    wa_smtab9-c1sale = sl1.
    wa_smtab9-c2sale = sl2.
    wa_smtab9-c3sale = sl3.
**************** INCREMENT**************
*    READ TABLE it_inc1 INTO wa_inc1 WITH KEY PERNR = WA_smtab7-ZMPERNR.
*    IF SY-SUBRC EQ 0.
*      WA_smtab9-INCR = wa_inc1-INCR.
*      WA_smtab9-INCREMENT_DT = wa_inc1-INCREMENT_DT.
*      if wa_inc1-INCREMENT_DT ne 0.
*        CONCATENATE wa_inc1-INCREMENT_DT+4(2) '/' wa_inc1-INCREMENT_DT+0(4) INTO INCRDT.
*        WA_smtab9-INCRDT = INCRDT.
*      endif.
*      WA_smtab9-CSAL = WA_INC1-CSAL.
*      WA_smtab9-INCR_DT = wa_inc1-incr_dt.
*    ENDIF.
**********************************************************
    select single * from zdrphq where bzirk eq wa_smtab7-sm.
    if sy-subrc eq 0.
      select single * from  zthr_heq_des where zz_hqcode eq zdrphq-zz_hqcode.
      if sy-subrc eq 0.
        wa_smtab9-zz_hqdesc =  zthr_heq_des-zz_hqdesc.
      endif.
    endif.
    select single * from pa0001 where pernr eq wa_smtab9-smpernr and endda ge date2.
    if sy-subrc eq 0.
      wa_smtab9-ename = pa0001-ename.
      select single * from zfsdes where persk eq pa0001-persk.
      if sy-subrc eq 0.
        wa_smtab9-short = zfsdes-short.
      endif.
    else.
      wa_smtab9-ename = 'VACANT (Since)'.
      wa_smtab9-short = 'ZM'.
    endif.


*    read table it_tab5 into wa_tab5 with key reg = wa_smtab7-reg div = 'BCL'.
*    if sy-subrc eq 0.
*      div = 'BCL'.
*    else.
*      read table it_tab5 into wa_tab5 with key reg = wa_smtab7-reg div = 'BC'.
*      if sy-subrc eq 0.
*        read table it_tab5 into wa_tab5 with key reg = wa_smtab7-reg div = 'XL'.
*        if sy-subrc eq 0.
*          div = 'BCL'.
*        else.
*          div = 'BC'.
*        endif.
*      else.
*        div = 'XL'.
*      endif.
*    endif.

    read table it_tab5 into wa_tab5 with key sm = wa_smtab7-sm div = 'BCL'.
    if sy-subrc eq 0.
      div = 'BCL'.
    else.
      read table it_tab5 into wa_tab5 with key sm = wa_smtab7-sm div = 'BC'.
      if sy-subrc eq 0.
        read table it_tab5 into wa_tab5 with key sm = wa_smtab7-sm div = 'XL'.
        if sy-subrc eq 0.
          div = 'BCL'.
        else.
          div = 'BC'.
        endif.
      else.
        read table it_tab5 into wa_tab5 with key sm = wa_smtab7-sm div = 'LS'.
        if sy-subrc eq 0.
          div = 'LS'.
        else.
          div = 'XL'.
        endif.
      endif.
    endif.


    wa_smtab9-div = div.
    select single * from zoneseq where zone_dist eq wa_smtab7-sm.
    if sy-subrc eq 0.
      wa_smtab9-seq = zoneseq-seq.
    endif.
    read table it_pa0000_zm into wa_pa0000_zm with key pernr = wa_smtab9-smpernr. "ZM PROMOTION
    if sy-subrc eq 0.
      concatenate wa_pa0000_zm-begda+4(2) '/' wa_pa0000_zm-begda+0(4) into prom.
      wa_smtab9-prom = prom.
*      WA_smtab9-PROM1 = 'L-PROM'.
    endif.

***********************************************************
    collect wa_smtab9 into it_smtab9.
    clear wa_smtab9.
  endloop.



  loop at it_smtab9 into wa_smtab9 .
    clear : cp1,cp2,cp3, cums,lcums,cgrw,cum1,cum2,ccumm.
    clear : lpqrt1,ls1,lt1, lpqrt2,ls2,lt2, lpqrt3,ls3,lt3, lpqrt4,ls4,lt4.
    clear : lls1,lls2,lls3,lls4.
    clear : lycs,lyct,lcumm, csl1,cst1,cpqrt1, csl2,cst2,cpqrt2, csl3,cst3,cpqrt3, csl4,cst4,cpqrt4.
    clear : c1,c2,c3,c4, c5.
    clear : lsale,llsale, lgrw, l1.


    wa_smtab8-sm = wa_smtab9-sm.
    wa_smtab8-smpernr = wa_smtab9-smpernr.
**************** LAST YEAR SALE PERFORMANVE ***********
    read table it_smll1dums into wa_smll1dums with key bzirk = wa_smtab8-sm.
    if sy-subrc eq 0.
      ls1 = ( wa_smll1dums-aprsale + wa_smll1dums-maysale + wa_smll1dums-junsale ) / 1000.
      wa_smtab8-lysale1 = ls1.
      ls2 = ( wa_smll1dums-julsale + wa_smll1dums-augsale + wa_smll1dums-sepsale ) / 1000.
      wa_smtab8-lysale2 = ls2.
      ls3 = ( wa_smll1dums-octsale + wa_smll1dums-novsale + wa_smll1dums-decsale ) / 1000.
      wa_smtab8-lysale3 = ls3.
      ls4 = ( wa_smll1dums-jansale + wa_smll1dums-febsale + wa_smll1dums-marsale ) / 1000.
      wa_smtab8-lysale4 = ls4.
      wa_smtab8-lysale = wa_smtab8-lysale1 + wa_smtab8-lysale2 + wa_smtab8-lysale3 + wa_smtab8-lysale4.
    endif.
    read table it_smll1tdums into wa_smll1tdums with key bzirk = wa_smtab8-sm.
    if sy-subrc eq 0.
      lt1 = ( wa_smll1tdums-aprsale + wa_smll1tdums-maysale + wa_smll1tdums-junsale ) / 1000.
      lt2 = ( wa_smll1tdums-julsale + wa_smll1tdums-augsale + wa_smll1tdums-sepsale ) / 1000.
      lt3 = ( wa_smll1tdums-octsale + wa_smll1tdums-novsale + wa_smll1tdums-decsale ) / 1000.
      lt4 = ( wa_smll1tdums-jansale + wa_smll1tdums-febsale + wa_smll1tdums-marsale ) / 1000.
    endif.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      lpqrt1 = ( ls1 / lt1 ) * 100.
    endcatch.
    wa_smtab8-lpqrt1 = lpqrt1.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      lpqrt2 = ( ls2 / lt2 ) * 100.
    endcatch.
    wa_smtab8-lpqrt2 = lpqrt2.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      lpqrt3 = ( ls3 / lt3 ) * 100.
    endcatch.
    wa_smtab8-lpqrt3 = lpqrt3.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      lpqrt4 = ( ls4 / lt4 ) * 100.
    endcatch.
    wa_smtab8-lpqrt4 = lpqrt4.

******************************
    read table it_sml1dums into wa_sml1dums with key bzirk = wa_smtab8-sm.
    if sy-subrc eq 0.
      read table it_dlapr into wa_dlapr with key bzirk = wa_smtab8-sm.
      if sy-subrc eq 0.
        if date2 lt f1date.
          wa_l1dums-aprsale = wa_dlapr-aprsale.
        endif.
        if date2 lt f2date.
          wa_l1dums-maysale = wa_dlapr-maysale.
        endif.
        if date2 lt f3date.
          wa_l1dums-junsale = wa_dlapr-junsale.
        endif.
        if date2 lt f4date.
          wa_l1dums-julsale = wa_dlapr-julsale.
        endif.
        if date2 lt f5date.
          wa_l1dums-augsale = wa_dlapr-augsale.
        endif.
        if date2 lt f6date.
          wa_l1dums-sepsale = wa_dlapr-sepsale.
        endif.
        if date2 lt f7date.
          wa_l1dums-octsale = wa_dlapr-octsale.
        endif.
        if date2 lt f8date.
          wa_l1dums-novsale = wa_dlapr-novsale.
        endif.
        if date2 lt f9date.
          wa_l1dums-decsale = wa_dlapr-decsale.
        endif.
        if date2 lt f10date.
          wa_l1dums-jansale = wa_dlapr-jansale.
        endif.
        if date2 lt f11date.
          wa_l1dums-febsale = wa_dlapr-febsale.
        endif.
        if date2 lt f12date.
          wa_l1dums-marsale = wa_dlapr-marsale.
        endif.

        lls1 = ( wa_l1dums-aprsale + wa_l1dums-maysale + wa_l1dums-junsale ) / 1000.
        wa_smtab8-lysalec1 = lls1.
        lls2 = ( wa_l1dums-julsale + wa_l1dums-augsale + wa_l1dums-sepsale ) / 1000.
        wa_smtab8-lysalec2 = lls2.
        lls3 = ( wa_l1dums-octsale + wa_l1dums-novsale + wa_l1dums-decsale ) / 1000.
        wa_smtab8-lysalec3 = lls3.
        lls4 = ( wa_l1dums-jansale + wa_l1dums-febsale + wa_l1dums-marsale ) / 1000.
        wa_smtab8-lysalec4 = lls4.
        wa_smtab8-lysalec = wa_smtab8-lysalec1 + wa_smtab8-lysalec2 + wa_smtab8-lysalec3 + wa_smtab8-lysalec4.
      endif.
    endif.
*******************************
************ LAST YEAR CUMMULATIVE***********
*    wa_smtab8-lcumm = wa_smtab9-lcumm.
    read table it_smll1dums into wa_smll1dums with key bzirk = wa_smtab8-sm.
    if sy-subrc eq 0.
      lycs = wa_smll1dums-aprsale + wa_smll1dums-maysale + wa_smll1dums-junsale + wa_smll1dums-julsale + wa_smll1dums-augsale + wa_smll1dums-sepsale +
      wa_smll1dums-octsale + wa_smll1dums-novsale + wa_smll1dums-decsale + wa_smll1dums-jansale + wa_smll1dums-febsale + wa_smll1dums-marsale.
    endif.
    read table it_smll1tdums into wa_smll1dums with key bzirk = wa_smtab8-sm.
    if sy-subrc eq 0.
      lyct = wa_smll1tdums-aprsale + wa_smll1tdums-maysale + wa_smll1tdums-junsale + wa_smll1tdums-julsale + wa_smll1tdums-augsale + wa_smll1tdums-sepsale +
      wa_smll1tdums-octsale + wa_smll1tdums-novsale + wa_smll1tdums-decsale + wa_smll1tdums-jansale + wa_smll1tdums-febsale + wa_smll1tdums-marsale.
    endif.

    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      lcumm = ( lycs / lyct ) * 100.
    endcatch.
    wa_smtab8-lcumm = lcumm.

********************** LAST YEAR GROWTH ******************
*    wa_smtab8-lgrw = wa_smtab9-lgrw.
*BREAK-POINT.
    read table it_smll1dums into wa_smll1dums with key bzirk = wa_smtab8-sm.
    if sy-subrc eq 0.
      lsale = wa_smll1dums-aprsale + wa_smll1dums-maysale + wa_smll1dums-junsale + wa_smll1dums-julsale + wa_smll1dums-augsale + wa_smll1dums-sepsale
      + wa_smll1dums-octsale + wa_smll1dums-novsale + wa_smll1dums-decsale + wa_smll1dums-jansale + wa_smll1dums-febsale + wa_smll1dums-marsale.
    endif.
    read table it_smyll1dums into wa_smyll1dums with key bzirk = wa_smtab8-sm.
    if sy-subrc eq 0.
      llsale = wa_smyll1dums-aprsale + wa_smyll1dums-maysale + wa_smyll1dums-junsale + wa_smyll1dums-julsale + wa_smyll1dums-augsale + wa_smyll1dums-sepsale
      + wa_smyll1dums-octsale + wa_smyll1dums-novsale + wa_smyll1dums-decsale + wa_smyll1dums-jansale + wa_smyll1dums-febsale + wa_smyll1dums-marsale.
    endif.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      lgrw =  ( lsale / llsale ) * 100 - 100 .
    endcatch.
    wa_smtab8-lgrw = lgrw.

************* CURRENT MONTH TARGET************
    wa_smtab8-ctar = wa_smtab9-ctar .
**************** CURRENT YEAR SALE PERFORMANVE ***********
*    wa_smtab8-cpqrt1 = wa_smtab9-cpqrt1.
*    BREAK-POINT.
    read table it_smdcums into wa_smdcums with key bzirk = wa_smtab8-sm.
    if sy-subrc eq 0.
      csl1 = wa_smdcums-aprsale + wa_smdcums-maysale + wa_smdcums-junsale.
      if date2 ge f3date.
        c1 = csl1 / 1000.
      endif.
      wa_smtab8-cysale1 = c1.
    endif.
    read table it_smtdums into wa_smtdums with key bzirk = wa_smtab8-sm.
    if sy-subrc eq 0.
      cst1 = wa_smtdums-aprsale + wa_smtdums-maysale + wa_smtdums-junsale.
    endif.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      cpqrt1 = ( csl1 / cst1 ) * 100.
    endcatch.
    if date2 ge f3date.
      wa_smtab8-cpqrt1 = cpqrt1.
    endif.

*    wa_smtab8-cpqrt2 = wa_smtab9-cpqrt2.
    read table it_smdcums into wa_smdcums with key bzirk = wa_smtab8-sm.
    if sy-subrc eq 0.
      csl2 = wa_smdcums-julsale + wa_smdcums-augsale + wa_smdcums-sepsale.
      if date2 ge f6date.
        c2 = csl2 / 1000.
      endif.
      wa_smtab8-cysale2 = c2.
    endif.
    read table it_smtdums into wa_smtdums with key bzirk = wa_smtab8-sm.
    if sy-subrc eq 0.
      cst2 = wa_smtdums-julsale + wa_smtdums-augsale + wa_smtdums-sepsale.
    endif.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      cpqrt2 = ( csl2 / cst2 ) * 100.
    endcatch.
    if date2 ge f6date.
      wa_smtab8-cpqrt2 = cpqrt2.
    endif.

*    wa_smtab8-cpqrt3 = wa_smtab9-cpqrt3.
    read table it_smdcums into wa_smdcums with key bzirk = wa_smtab8-sm.
    if sy-subrc eq 0.
      csl3 = wa_smdcums-octsale + wa_smdcums-novsale + wa_smdcums-decsale.
      if date2 ge f9date.
        c3 = csl3 / 1000.
      endif.
      wa_smtab8-cysale3 = c3.
    endif.
    read table it_smtdums into wa_smtdums with key bzirk = wa_smtab8-sm.
    if sy-subrc eq 0.
      cst3 = wa_smtdums-octsale + wa_smtdums-novsale + wa_smtdums-decsale.
    endif.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      cpqrt3 = ( csl3 / cst3 ) * 100.
    endcatch.
    if date2 ge f9date.
      wa_smtab8-cpqrt3 = cpqrt3.
    endif.

*    wa_smtab8-cpqrt4 = wa_smtab9-cpqrt4.
    read table it_smdcums into wa_smdcums with key bzirk = wa_smtab8-sm.
    if sy-subrc eq 0.
      csl4 = wa_smdcums-jansale + wa_smdcums-febsale + wa_smdcums-marsale.
      if date2 ge f12date.
        c4 = csl4 / 1000.
      endif.
      wa_smtab8-cysale4 = c4.
    endif.
    read table it_smtdums into wa_smtdums with key bzirk = wa_smtab8-sm.
    if sy-subrc eq 0.
      cst4 = wa_smtdums-jansale + wa_smtdums-febsale + wa_smtdums-marsale.
    endif.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
      cpqrt4 = ( csl4 / cst4 ) * 100.
    endcatch.
    if date2 ge f12date.
      wa_smtab8-cpqrt4 = cpqrt4.
    endif.
*    wa_smtab8-cysale1 = wa_smtab9-cysale1.
*    wa_smtab8-cysale2 = wa_smtab9-cysale2.
*    wa_smtab8-cysale3 = wa_smtab9-cysale3.
*    wa_smtab8-cysale4 = wa_smtab9-cysale4.
*    wa_smtab8-cysale = wa_smtab9-cysale.
************ CURRENT YEAR CUMMULATIVE***********
*    wa_smtab8-ccumm = wa_smtab9-ccumm.
    read table it_smcums into wa_smcums with key bzirk = wa_smtab8-sm.
    if sy-subrc eq 0.
      cum1 = wa_smcums-sale.
    endif.
    read table it_smtcums into wa_smtcums with key bzirk = wa_smtab8-sm.
    if sy-subrc eq 0.
      cum2 = wa_smtcums-sale.
    endif.
    if cum2 gt 0.
      ccumm = ( cum1 / cum2 ) * 100.
    endif.
    wa_smtab8-ccumm = ccumm.
***************CURRENT YEAR CUMMULATIVE GROWTH FROM ZRCUMPSO********
    read table it_smcums into wa_smcums with key bzirk = wa_smtab8-sm.
    if sy-subrc eq 0.
      cums = wa_smcums-sale.
      c5 = wa_smcums-sale / 1000.
      wa_smtab8-cysale = c5.  "30.5.2019
*      WA_smtab8-CYSALE = C1 + C2 + C3 + C4.
    endif.
    read table it_smlcums into wa_smlcums with key bzirk = wa_smtab8-sm.
    if sy-subrc eq 0.
      lcums = wa_smlcums-sale.
*      wa_smtab8-lysale = wa_lcums-sale / 1000.
    endif.
    catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
    cgrw = ( cums / lcums ) * 100 - 100.
    endcatch.
    wa_smtab8-cgrw = cgrw.

*    wa_smtab8-cgrw = wa_smtab9-cgrw.
**********CURRENT MONTH, LAST MONTH & LAST TO LAST MONTH PERFORMANCE******
*    READ TABLE IT_SMTAB71 INTO WA_SMTAB71 WITH KEY REG = WA_SMTAB8-SM.
*    IF SY-SUBRC EQ 0.
*      CS11 = WA_SMTAB71-C1SALE / 1000.
*      WA_SMTAB8-C1SALE = CS11.
*      CP1 = ( WA_SMTAB71-C1SALE / WA_SMTAB71-T1 ) * 100.
*      WA_SMTAB8-CP1 = CP1.
*    ENDIF.

    read table it_smtab71 into wa_smtab71 with key sm = wa_smtab8-sm.  "Jyotsna 29.11.22
    if sy-subrc eq 0.
      cs11 = wa_smtab71-c1sale / 1000.
      wa_smtab8-c1sale = cs11.
      catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
        cp1 = ( wa_smtab71-c1sale / wa_smtab71-t1 ) * 100.
      endcatch.

      wa_smtab8-cp1 = cp1.
    endif.


*    wa_smtab8-cp1 = wa_smtab9-cp1.
*    wa_smtab8-cp2 = wa_smtab9-cp2.
*    wa_smtab8-cp3 = wa_smtab9-cp3.
*    wa_smtab8-c1sale = wa_smtab9-c1sale.
*    wa_smtab8-c2sale = wa_smtab9-c2sale.
*     wa_smtab8-c3sale = wa_smtab9-c3sale.
    read table it_smlcs into wa_smlcs with key bzirk = wa_smtab8-sm.
    if sy-subrc eq 0.
      cs13 = wa_smlcs-c3sale / 1000.
      wa_smtab8-c3sale = cs13.
      catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
        cp3 = ( wa_smlcs-c3sale / wa_smlcs-t2 ) * 100.
      endcatch.
      wa_smtab8-cp3 = cp3.
    endif.
    read table it_sml1cs into wa_sml1cs with key bzirk = wa_smtab8-sm.
    if sy-subrc eq 0.
      cs12 = wa_sml1cs-c3sale / 1000.
      wa_smtab8-c2sale = cs12.
      catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
        cp2 = ( wa_sml1cs-c3sale / wa_sml1cs-t2 ) * 100.
      endcatch.
      wa_smtab8-cp2 = cp2.
    endif.
**********************************************************

    wa_smtab8-zz_hqdesc =  wa_smtab9-zz_hqdesc.
    wa_smtab8-ename = wa_smtab9-ename.
    wa_smtab8-short = wa_smtab9-short.
    wa_smtab8-join_dt = wa_smtab9-join_dt.
    wa_smtab8-div = wa_smtab9-div.
    wa_smtab8-seq = wa_smtab9-seq.
    wa_smtab8-prom = wa_smtab9-prom.

    select single * from ztotpso where begda = totpsodt and bzirk = wa_smtab9-sm.
    if sy-subrc = 0.
      wa_smtab8-noofpso = ( ztotpso-bc + ztotpso-bcl + ztotpso-xl ) - ztotpso-hbe.
    endif.

    collect wa_smtab8 into it_smtab8.
    clear wa_smtab8.
  endloop.


endform.
