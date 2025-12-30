*&---------------------------------------------------------------------*
*& Report  ZSR7_PSO1
*& Developed by Jyotsna. MODIFIED BY MASUMA
*&---------------------------------------------------------------------*
*&Modification History
*&---------------------------
*&Changed by/date      : 08.06.2023
*&DESCRIPTION          : Performance improvement done
*&Request No.          :  BCDK933098
*&---------------------------------------------------------------------*
*&Changed by/date      : 30.10.2023
*&DESCRIPTION          : remove error in email send even after entering email id.
*&Request No.          :  BCDK933744
*&---------------------------------------------------------------------*

report  zsr7_pso21_1 no standard page heading line-size 500.
tables : zdsmter,
         zprdgroup,  " (SR7Z),
         zrpqv,
         zsampdata,
         pa0001,
         yterrallc,
         makt,
         mvke,
         tvm5t,
         zthr_heq_des,
         t247,
*****         ZSR7Z_HELP,
         tvm4t,
         pa0105.


type-pools:  slis.

types:begin of ty_pa0001,
        pernr type persno,
        endda type endda,
        begda type begda,
        plans type plans,
        ename type emnam,
      end of ty_pa0001,

      begin of ty_mara,
        matnr type matnr,
        mtart type mtart,
        spart type spart,
      end of ty_mara.

data: g_repid     like sy-repid,
      fieldcat    type slis_t_fieldcat_alv,
      wa_fieldcat like line of fieldcat,
      sort        type slis_t_sortinfo_alv,
      wa_sort     like line of sort,
      layout      type slis_layout_alv.

data : it_zdsmter1   type table of zdsmter,
       wa_zdsmter1   type zdsmter,
       it_zdsmter11  type table of zdsmter,
       wa_zdsmter11  type zdsmter,
       it_zdsmter    type table of zdsmter,
       wa_zdsmter    type zdsmter,
       it_zrpqv_lapr type table of zrpqv,
       wa_zrpqv_lapr type zrpqv,
       it_zrpqv_lmay type table of zrpqv,
       wa_zrpqv_lmay type zrpqv,
       it_zrpqv_ljun type table of zrpqv,
       wa_zrpqv_ljun type zrpqv,
       it_zrpqv_ljul type table of zrpqv,
       wa_zrpqv_ljul type zrpqv,
       it_zrpqv_laug type table of zrpqv,
       wa_zrpqv_laug type zrpqv,
       it_zrpqv_lsep type table of zrpqv,
       wa_zrpqv_lsep type zrpqv,
       it_zrpqv_loct type table of zrpqv,
       wa_zrpqv_loct type zrpqv,
       it_zrpqv_lnov type table of zrpqv,
       wa_zrpqv_lnov type zrpqv,
       it_zrpqv_ldec type table of zrpqv,
       wa_zrpqv_ldec type zrpqv,
       it_zrpqv_ljan type table of zrpqv,
       wa_zrpqv_ljan type zrpqv,
       it_zrpqv_lfeb type table of zrpqv,
       wa_zrpqv_lfeb type zrpqv,
       it_zrpqv_lmar type table of zrpqv,
       wa_zrpqv_lmar type zrpqv.


data : it_zrpqv_capr type table of zrpqv,
       wa_zrpqv_capr type zrpqv,
       it_zrpqv_cmay type table of zrpqv,
       wa_zrpqv_cmay type zrpqv,
       it_zrpqv_cjun type table of zrpqv,
       wa_zrpqv_cjun type zrpqv,
       it_zrpqv_cjul type table of zrpqv,
       wa_zrpqv_cjul type zrpqv,
       it_zrpqv_caug type table of zrpqv,
       wa_zrpqv_caug type zrpqv,
       it_zrpqv_csep type table of zrpqv,
       wa_zrpqv_csep type zrpqv,
       it_zrpqv_coct type table of zrpqv,
       wa_zrpqv_coct type zrpqv,
       it_zrpqv_cnov type table of zrpqv,
       wa_zrpqv_cnov type zrpqv,
       it_zrpqv_cdec type table of zrpqv,
       wa_zrpqv_cdec type zrpqv,
       it_zrpqv_cjan type table of zrpqv,
       wa_zrpqv_cjan type zrpqv,
       it_zrpqv_cfeb type table of zrpqv,
       wa_zrpqv_cfeb type zrpqv,
       it_zrpqv_cmar type table of zrpqv,
       wa_zrpqv_cmar type zrpqv.


data : it_zsampdata_apr type table of zsampdata,
       wa_zsampdata_apr type zsampdata,
       it_zsampdata_may type table of zsampdata,
       wa_zsampdata_may type zsampdata,
       it_zsampdata_jun type table of zsampdata,
       wa_zsampdata_jun type zsampdata,
       it_zsampdata_jul type table of zsampdata,
       wa_zsampdata_jul type zsampdata,
       it_zsampdata_aug type table of zsampdata,
       wa_zsampdata_aug type zsampdata,
       it_zsampdata_sep type table of zsampdata,
       wa_zsampdata_sep type zsampdata,
       it_zsampdata_oct type table of zsampdata,
       wa_zsampdata_oct type zsampdata,
       it_zsampdata_nov type table of zsampdata,
       wa_zsampdata_nov type zsampdata,
       it_zsampdata_dec type table of zsampdata,
       wa_zsampdata_dec type zsampdata,
       it_zsampdata_jan type table of zsampdata,
       wa_zsampdata_jan type zsampdata,
       it_zsampdata_feb type table of zsampdata,
       wa_zsampdata_feb type zsampdata,
       it_zsampdata_mar type table of zsampdata,
       wa_zsampdata_mar type zsampdata,
       it_yterrallc1    type table of yterrallc,
       wa_yterrallc1    type yterrallc,
       it_pa0001_1      type table of ty_pa0001,            "pa0001,
       wa_pa0001_1      type ty_pa0001,                     "pa0001,
       it_zdsmter2      type table of zdsmter,
       wa_zdsmter2      type zdsmter,
       it_mara          type table of ty_mara, "mara,
       wa_mara          type ty_mara, "mara,
       it_zprdgroup     type table of zprdgroup,
       wa_zprdgroup     type zprdgroup.


data: mm(2)       type n,
      ctr(10)     type n,
      mtitle(150) type c,
      p_sale(1)   type c,
      tag(8)      type c,
      elname(10)  type c,
      avgqty(9)   type p,
      prdname(25) type c,
      formnm(10)  type c,
      w_month(30) type c,
      grcalc      type p decimals 0,
      w_year(4)   type c.

types : begin of itab1,
          reg      type zdsmter-zdsm,
          zm       type zdsmter-zdsm,
          rm       type zdsmter-zdsm,
          text(10) type c,
          spart    type zdsmter-spart,
          rm_pernr type pa0001-pernr,
        end of itab1.

types : begin of itab3,
          reg   type zdsmter-zdsm,
          zm    type zdsmter-zdsm,
          rm    type zdsmter-zdsm,
          bzirk type zdsmter-bzirk,
*  spart type zdsmter-spart,
        end of itab3.

types : begin of itab4,
          reg    type zdsmter-zdsm,
          zm     type zdsmter-zdsm,
          rm     type zdsmter-zdsm,
          bzirk  type zdsmter-bzirk,
          pernr  type pa0001-pernr,
          ename  type pa0001-ename,
          div(3) type c,
          matnr  type mara-matnr,
*  spart type zdsmter-spart,
        end of itab4.

types : begin of itas1,
          reg    type zdsmter-zdsm,
          zm     type zdsmter-zdsm,
          rm     type zdsmter-zdsm,
          bzirk  type zdsmter-bzirk,
          pernr  type pa0001-pernr,
          ename  type pa0001-ename,
          matnr  type zrpqv-matnr,
          aprqty type p,
          mayqty type p,
          junqty type p,
          julqty type p,
          augqty type p,
          sepqty type p,
          octqty type p,
          novqty type p,
          decqty type p,
          janqty type p,
          febqty type p,
          marqty type p,
          aprpts type zrpqv-grosspts,
          maypts type zrpqv-grosspts,
          junpts type zrpqv-grosspts,
          julpts type zrpqv-grosspts,
          augpts type zrpqv-grosspts,
          seppts type zrpqv-grosspts,
          octpts type zrpqv-grosspts,
          novpts type zrpqv-grosspts,
          decpts type zrpqv-grosspts,
          janpts type zrpqv-grosspts,
          febpts type zrpqv-grosspts,
          marpts type zrpqv-grosspts,
        end of itas1.

types : begin of itas3,
          reg     type zdsmter-zdsm,
          zm      type zdsmter-zdsm,
          rm      type zdsmter-zdsm,
          bzirk   type zdsmter-bzirk,
          pernr   type pa0001-pernr,
          ename   type pa0001-ename,
          matnr   type zrpqv-matnr,
          caprqty type p,
          cmayqty type p,
          cjunqty type p,
          cjulqty type p,
          caugqty type p,
          csepqty type p,
          coctqty type p,
          cnovqty type p,
          cdecqty type p,
          cjanqty type p,
          cfebqty type p,
          cmarqty type p,

          laprqty type p,
          lmayqty type p,
          ljunqty type p,
          ljulqty type p,
          laugqty type p,
          lsepqty type p,
          loctqty type p,
          lnovqty type p,
          ldecqty type p,
          ljanqty type p,
          lfebqty type p,
          lmarqty type p,

          caprpts type zrpqv-grosspts,
          cmaypts type zrpqv-grosspts,
          cjunpts type zrpqv-grosspts,
          cjulpts type zrpqv-grosspts,
          caugpts type zrpqv-grosspts,
          cseppts type zrpqv-grosspts,
          coctpts type zrpqv-grosspts,
          cnovpts type zrpqv-grosspts,
          cdecpts type zrpqv-grosspts,
          cjanpts type zrpqv-grosspts,
          cfebpts type zrpqv-grosspts,
          cmarpts type zrpqv-grosspts,
          laprpts type zrpqv-grosspts,
          lmaypts type zrpqv-grosspts,
          ljunpts type zrpqv-grosspts,
          ljulpts type zrpqv-grosspts,
          laugpts type zrpqv-grosspts,
          lseppts type zrpqv-grosspts,
          loctpts type zrpqv-grosspts,
          lnovpts type zrpqv-grosspts,
          ldecpts type zrpqv-grosspts,
          ljanpts type zrpqv-grosspts,
          lfebpts type zrpqv-grosspts,
          lmarpts type zrpqv-grosspts,
        end of itas3.

types : begin of itas4,
          reg     type zdsmter-zdsm,
          zm      type zdsmter-zdsm,
          rm      type zdsmter-zdsm,
          bzirk   type zdsmter-bzirk,
          pernr   type pa0001-pernr,
          ename   type pa0001-ename,
          matnr   type zrpqv-matnr,
          maktx   type makt-maktx,
          caprqty type p decimals 0,
          cmayqty type p decimals 0,
          cjunqty type p decimals 0,
          cjulqty type p decimals 0,
          caugqty type p decimals 0,
          csepqty type p decimals 0,
          coctqty type p decimals 0,
          cnovqty type p decimals 0,
          cdecqty type p decimals 0,
          cjanqty type p decimals 0,
          cfebqty type p decimals 0,
          cmarqty type p decimals 0,

          laprqty type p decimals 0,
          lmayqty type p decimals 0,
          ljunqty type p decimals 0,
          ljulqty type p decimals 0,
          laugqty type p decimals 0,
          lsepqty type p decimals 0,
          loctqty type p decimals 0,
          lnovqty type p decimals 0,
          ldecqty type p decimals 0,
          ljanqty type p decimals 0,
          lfebqty type p decimals 0,
          lmarqty type p decimals 0,
          caprpts type p,
          cmaypts type p,
          cjunpts type p,
          cjulpts type p,
          caugpts type p,
          cseppts type p,
          coctpts type p,
          cnovpts type p,
          cdecpts type p,
          cjanpts type p,
          cfebpts type p,
          cmarpts type p,
          laprpts type p,
          lmaypts type p,
          ljunpts type p,
          ljulpts type p,
          laugpts type p,
          lseppts type p,
          loctpts type p,
          lnovpts type p,
          ldecpts type p,
          ljanpts type p,
          lfebpts type p,
          lmarpts type p,
          aprgr   type p,
          maygr   type p,
          jungr   type p,
          julgr   type p,
          auggr   type p,
          sepgr   type p,
          octgr   type p,
          novgr   type p,
          decgr   type p,
          jangr   type p,
          febgr   type p,
          margr   type p,
          vaprgr  type p,
          vmaygr  type p,
          vjungr  type p,
          vjulgr  type p,
          vauggr  type p,
          vsepgr  type p,
          voctgr  type p,
          vnovgr  type p,
          vdecgr  type p,
          vjangr  type p,
          vfebgr  type p,
          vmargr  type p,
        end of itas4.

types : begin of itab6,
          reg       type zdsmter-zdsm,
          zm        type zdsmter-zdsm,
          rm        type zdsmter-zdsm,
          bzirk     type zdsmter-bzirk,
          pernr     type pa0001-pernr,
          ename     type pa0001-ename,
*matnr type zrpqv-matnr,
          mvgr4     type zprdgroup-mvgr4,
          maktx     type makt-maktx,
          caprqty   type p,
          cmayqty   type p,
          cjunqty   type p,
          cjulqty   type p,
          caugqty   type p,
          csepqty   type p,
          coctqty   type p,
          cnovqty   type p,
          cdecqty   type p,
          cjanqty   type p,
          cfebqty   type p,
          cmarqty   type p,

          laprqty   type p,
          lmayqty   type p,
          ljunqty   type p,
          ljulqty   type p,
          laugqty   type p,
          lsepqty   type p,
          loctqty   type p,
          lnovqty   type p,
          ldecqty   type p,
          ljanqty   type p,
          lfebqty   type p,
          lmarqty   type p,

          caprpts   type zrpqv-grosspts,
          cmaypts   type zrpqv-grosspts,
          cjunpts   type zrpqv-grosspts,
          cjulpts   type zrpqv-grosspts,
          caugpts   type zrpqv-grosspts,
          cseppts   type zrpqv-grosspts,
          coctpts   type zrpqv-grosspts,
          cnovpts   type zrpqv-grosspts,
          cdecpts   type zrpqv-grosspts,
          cjanpts   type zrpqv-grosspts,
          cfebpts   type zrpqv-grosspts,
          cmarpts   type zrpqv-grosspts,
          laprpts   type zrpqv-grosspts,
          lmaypts   type zrpqv-grosspts,
          ljunpts   type zrpqv-grosspts,
          ljulpts   type zrpqv-grosspts,
          laugpts   type zrpqv-grosspts,
          lseppts   type zrpqv-grosspts,
          loctpts   type zrpqv-grosspts,
          lnovpts   type zrpqv-grosspts,
          ldecpts   type zrpqv-grosspts,
          ljanpts   type zrpqv-grosspts,
          lfebpts   type zrpqv-grosspts,
          lmarpts   type zrpqv-grosspts,
          aprgr     type p,
          maygr     type p,
          jungr     type p,
          julgr     type p,
          auggr     type p,
          sepgr     type p,
          octgr     type p,
          novgr     type p,
          decgr     type p,
          jangr     type p,
          febgr     type p,
          margr     type p,
          vaprgr    type p,
          vmaygr    type p,
          vjungr    type p,
          vjulgr    type p,
          vauggr    type p,
          vsepgr    type p,
          voctgr    type p,
          vnovgr    type p,
          vdecgr    type p,
          vjangr    type p,
          vfebgr    type p,
          vmargr    type p,

          smpaprqty type p,
          smpmayqty type p,
          smpjunqty type p,
          smpjulqty type p,
          smpaugqty type p,
          smpsepqty type p,
          smpoctqty type p,
          smpnovqty type p,
          smpdecqty type p,
          smpjanqty type p,
          smpfebqty type p,
          smpmarqty type p,

*  spart type zdsmter-spart,
        end of itab6.

types : begin of itab7,
          reg          type zdsmter-zdsm,
          zm           type zdsmter-zdsm,
          rm           type zdsmter-zdsm,
          bzirk        type zdsmter-bzirk,
          pernr        type pa0001-pernr,
          ename        type pa0001-ename,
*matnr TYPE zrpqv-matnr,
          mvgr4        type mvke-mvgr4,
          bezei        type tvm5t-bezei,
          maktx        type makt-maktx,
*  prn_seq type zsr7z_help-prn_seq,
          prn_seq      type int4,
          grp_code     type zprdgroup-grp_code,
          caprqty(6)   type c,
          cmayqty(6)   type c,
          cjunqty(6)   type c,
          cjulqty(6)   type c,
          caugqty(6)   type c,
          csepqty(6)   type c,
          coctqty(6)   type c,
          cnovqty(6)   type c,
          cdecqty(6)   type c,
          cjanqty(6)   type c,
          cfebqty(6)   type c,
          cmarqty(6)   type c,

          laprqty(6)   type c,
          lmayqty(6)   type c,
          ljunqty(6)   type c,
          ljulqty(6)   type c,
          laugqty(6)   type c,
          lsepqty(6)   type c,
          loctqty(6)   type c,
          lnovqty(6)   type c,
          ldecqty(6)   type c,
          ljanqty(6)   type c,
          lfebqty(6)   type c,
          lmarqty(6)   type c,

          caprpts      type zrpqv-grosspts,
          cmaypts      type zrpqv-grosspts,
          cjunpts      type zrpqv-grosspts,
          cjulpts      type zrpqv-grosspts,
          caugpts      type zrpqv-grosspts,
          cseppts      type zrpqv-grosspts,
          coctpts      type zrpqv-grosspts,
          cnovpts      type zrpqv-grosspts,
          cdecpts      type zrpqv-grosspts,
          cjanpts      type zrpqv-grosspts,
          cfebpts      type zrpqv-grosspts,
          cmarpts      type zrpqv-grosspts,
          laprpts      type zrpqv-grosspts,
          lmaypts      type zrpqv-grosspts,
          ljunpts      type zrpqv-grosspts,
          ljulpts      type zrpqv-grosspts,
          laugpts      type zrpqv-grosspts,
          lseppts      type zrpqv-grosspts,
          loctpts      type zrpqv-grosspts,
          lnovpts      type zrpqv-grosspts,
          ldecpts      type zrpqv-grosspts,
          ljanpts      type zrpqv-grosspts,
          lfebpts      type zrpqv-grosspts,
          lmarpts      type zrpqv-grosspts,
          aprgr        type p,
          maygr        type p,
          jungr        type p,
          julgr        type p,
          auggr        type p,
          sepgr        type p,
          octgr        type p,
          novgr        type p,
          decgr        type p,
          jangr        type p,
          febgr        type p,
          margr        type p,
          vaprgr       type p,
          vmaygr       type p,
          vjungr       type p,
          vjulgr       type p,
          vauggr       type p,
          vsepgr       type p,
          voctgr       type p,
          vnovgr       type p,
          vdecgr       type p,
          vjangr       type p,
          vfebgr       type p,
          vmargr       type p,

          smpaprqty(6) type c,
          smpmayqty(6) type c,
          smpjunqty(6) type c,
          smpjulqty(6) type c,
          smpaugqty(6) type c,
          smpsepqty(6) type c,
          smpoctqty(6) type c,
          smpnovqty(6) type c,
          smpdecqty(6) type c,
          smpjanqty(6) type c,
          smpfebqty(6) type c,
          smpmarqty(6) type c,

          rapr(6)      type c,
          rmay(6)      type c,
          rjun(6)      type c,
          rjul(6)      type c,
          raug(6)      type c,
          rsep(6)      type c,
          roct(6)      type c,
          rnov(6)      type c,
          rdec(6)      type c,
          rjan(6)      type c,
          rfeb(6)      type c,
          rmar(6)      type c,

          smptot       type p,

*  spart type zdsmter-spart,
        end of itab7.



types : begin of itab8,
          reg          type zdsmter-zdsm,
          zm           type zdsmter-zdsm,
          rm           type zdsmter-zdsm,
          bzirk        type zdsmter-bzirk,
          grp_code     type zprdgroup-grp_code,
          prn_seq      type int4,
          pernr        type pa0001-pernr,
          ename        type pa0001-ename,
*matnr TYPE zrpqv-matnr,
          mvgr4        type mvke-mvgr4,
          bezei        type tvm5t-bezei,
          maktx        type makt-maktx,


          caprqty(6)   type c,
          cmayqty(6)   type c,
          cjunqty(6)   type c,
          cjulqty(6)   type c,
          caugqty(6)   type c,
          csepqty(6)   type c,
          coctqty(6)   type c,
          cnovqty(6)   type c,
          cdecqty(6)   type c,
          cjanqty(6)   type c,
          cfebqty(6)   type c,
          cmarqty(6)   type c,

          laprqty(6)   type c,
          lmayqty(6)   type c,
          ljunqty(6)   type c,
          ljulqty(6)   type c,
          laugqty(6)   type c,
          lsepqty(6)   type c,
          loctqty(6)   type c,
          lnovqty(6)   type c,
          ldecqty(6)   type c,
          ljanqty(6)   type c,
          lfebqty(6)   type c,
          lmarqty(6)   type c,

          caprpts      type p,
          cmaypts      type p,
          cjunpts      type p,
          cjulpts      type p,
          caugpts      type p,
          cseppts      type p,
          coctpts      type p,
          cnovpts      type p,
          cdecpts      type p,
          cjanpts      type p,
          cfebpts      type p,
          cmarpts      type p,
          laprpts      type p,
          lmaypts      type p,
          ljunpts      type p,
          ljulpts      type p,
          laugpts      type p,
          lseppts      type p,
          loctpts      type p,
          lnovpts      type p,
          ldecpts      type p,
          ljanpts      type p,
          lfebpts      type p,
          lmarpts      type p,
          aprgr(6)     type c,
          maygr(6)     type c,
          jungr(6)     type c,
          julgr(6)     type c,
          auggr(6)     type c,
          sepgr(6)     type c,
          octgr(6)     type c,
          novgr(6)     type c,
          decgr(6)     type c,
          jangr(6)     type c,
          febgr(6)     type c,
          margr(6)     type c,
          vaprgr(6)    type c,
          vmaygr(6)    type c,
          vjungr(6)    type c,
          vjulgr(6)    type c,
          vauggr(6)    type c,
          vsepgr(6)    type c,
          voctgr(6)    type c,
          vnovgr(6)    type c,
          vdecgr(6)    type c,
          vjangr(6)    type c,
          vfebgr(6)    type c,
          vmargr(6)    type c,

          mgrapr(6)    type c,
          mgrmay(6)    type c,
          mgrjun(6)    type c,
          mgrjul(6)    type c,
          mgraug(6)    type c,
          mgrsep(6)    type c,
          mgroct(6)    type c,
          mgrnov(6)    type c,
          mgrdec(6)    type c,
          mgrjan(6)    type c,
          mgrfeb(6)    type c,
          mgrmar(6)    type c,

          vmgrapr(6)   type c,
          vmgrmay(6)   type c,
          vmgrjun(6)   type c,
          vmgrjul(6)   type c,
          vmgraug(6)   type c,
          vmgrsep(6)   type c,
          vmgroct(6)   type c,
          vmgrnov(6)   type c,
          vmgrdec(6)   type c,
          vmgrjan(6)   type c,
          vmgrfeb(6)   type c,
          vmgrmar(6)   type c,

          smpaprqty(6) type c,
          smpmayqty(6) type c,
          smpjunqty(6) type c,
          smpjulqty(6) type c,
          smpaugqty(6) type c,
          smpsepqty(6) type c,
          smpoctqty(6) type c,
          smpnovqty(6) type c,
          smpdecqty(6) type c,
          smpjanqty(6) type c,
          smpfebqty(6) type c,
          smpmarqty(6) type c,

          rapr(6)      type c,
          rmay(6)      type c,
          rjun(6)      type c,
          rjul(6)      type c,
          raug(6)      type c,
          rsep(6)      type c,
          roct(6)      type c,
          rnov(6)      type c,
          rdec(6)      type c,
          rjan(6)      type c,
          rfeb(6)      type c,
          rmar(6)      type c,

          smptot       type p,

*  spart type zdsmter-spart,
        end of itab8.


types : begin of itab71,
          reg       type zdsmter-zdsm,
          zm        type zdsmter-zdsm,
          rm        type zdsmter-zdsm,
          bzirk     type zdsmter-bzirk,
          pernr     type pa0001-pernr,
          ename     type pa0001-ename,
*matnr TYPE zrpqv-matnr,
          mvgr4     type mvke-mvgr4,
          bezei     type tvm5t-bezei,
          maktx     type makt-maktx,
          prn_seq   type int4,
          grp_code  type zprdgroup-grp_code,
          caprqty   type p,
          cmayqty   type p,
          cjunqty   type p,
          cjulqty   type p,
          caugqty   type p,
          csepqty   type p,
          coctqty   type p,
          cnovqty   type p,
          cdecqty   type p,
          cjanqty   type p,
          cfebqty   type p,
          cmarqty   type p,

          laprqty   type p,
          lmayqty   type p,
          ljunqty   type p,
          ljulqty   type p,
          laugqty   type p,
          lsepqty   type p,
          loctqty   type p,
          lnovqty   type p,
          ldecqty   type p,
          ljanqty   type p,
          lfebqty   type p,
          lmarqty   type p,

          caprpts   type zrpqv-grosspts,
          cmaypts   type zrpqv-grosspts,
          cjunpts   type zrpqv-grosspts,
          cjulpts   type zrpqv-grosspts,
          caugpts   type zrpqv-grosspts,
          cseppts   type zrpqv-grosspts,
          coctpts   type zrpqv-grosspts,
          cnovpts   type zrpqv-grosspts,
          cdecpts   type zrpqv-grosspts,
          cjanpts   type zrpqv-grosspts,
          cfebpts   type zrpqv-grosspts,
          cmarpts   type zrpqv-grosspts,
          laprpts   type zrpqv-grosspts,
          lmaypts   type zrpqv-grosspts,
          ljunpts   type zrpqv-grosspts,
          ljulpts   type zrpqv-grosspts,
          laugpts   type zrpqv-grosspts,
          lseppts   type zrpqv-grosspts,
          loctpts   type zrpqv-grosspts,
          lnovpts   type zrpqv-grosspts,
          ldecpts   type zrpqv-grosspts,
          ljanpts   type zrpqv-grosspts,
          lfebpts   type zrpqv-grosspts,
          lmarpts   type zrpqv-grosspts,
          aprgr     type p,
          maygr     type p,
          jungr     type p,
          julgr     type p,
          auggr     type p,
          sepgr     type p,
          octgr     type p,
          novgr     type p,
          decgr     type p,
          jangr     type p,
          febgr     type p,
          margr     type p,
          vaprgr    type p,
          vmaygr    type p,
          vjungr    type p,
          vjulgr    type p,
          vauggr    type p,
          vsepgr    type p,
          voctgr    type p,
          vnovgr    type p,
          vdecgr    type p,
          vjangr    type p,
          vfebgr    type p,
          vmargr    type p,

          smpaprqty type p,
          smpmayqty type p,
          smpjunqty type p,
          smpjulqty type p,
          smpaugqty type p,
          smpsepqty type p,
          smpoctqty type p,
          smpnovqty type p,
          smpdecqty type p,
          smpjanqty type p,
          smpfebqty type p,
          smpmarqty type p,

          rapr      type p,
          rmay      type p,
          rjun      type p,
          rjul      type p,
          raug      type p,
          rsep      type p,
          roct      type p,
          rnov      type p,
          rdec      type p,
          rjan      type p,
          rfeb      type p,
          rmar      type p,

          smptot    type p,

*  spart type zdsmter-spart,
        end of itab71.

types : begin of itab9,
          reg       type zdsmter-zdsm,
          zm        type zdsmter-zdsm,
          rm        type zdsmter-zdsm,
          bzirk     type zdsmter-bzirk,
          pernr     type pa0001-pernr,
          ename     type pa0001-ename,
*matnr TYPE zrpqv-matnr,
          mvgr4     type mvke-mvgr4,
          bezei     type tvm5t-bezei,
          maktx     type makt-maktx,
          prn_seq   type int4,


          caprqty   type p,
          cmayqty   type p,
          cjunqty   type p,
          cjulqty   type p,
          caugqty   type p,
          csepqty   type p,
          coctqty   type p,
          cnovqty   type p,
          cdecqty   type p,
          cjanqty   type p,
          cfebqty   type p,
          cmarqty   type p,

          laprqty   type p,
          lmayqty   type p,
          ljunqty   type p,
          ljulqty   type p,
          laugqty   type p,
          lsepqty   type p,
          loctqty   type p,
          lnovqty   type p,
          ldecqty   type p,
          ljanqty   type p,
          lfebqty   type p,
          lmarqty   type p,

          caprpts   type zrpqv-grosspts,
          cmaypts   type zrpqv-grosspts,
          cjunpts   type zrpqv-grosspts,
          cjulpts   type zrpqv-grosspts,
          caugpts   type zrpqv-grosspts,
          cseppts   type zrpqv-grosspts,
          coctpts   type zrpqv-grosspts,
          cnovpts   type zrpqv-grosspts,
          cdecpts   type zrpqv-grosspts,
          cjanpts   type zrpqv-grosspts,
          cfebpts   type zrpqv-grosspts,
          cmarpts   type zrpqv-grosspts,
          laprpts   type zrpqv-grosspts,
          lmaypts   type zrpqv-grosspts,
          ljunpts   type zrpqv-grosspts,
          ljulpts   type zrpqv-grosspts,
          laugpts   type zrpqv-grosspts,
          lseppts   type zrpqv-grosspts,
          loctpts   type zrpqv-grosspts,
          lnovpts   type zrpqv-grosspts,
          ldecpts   type zrpqv-grosspts,
          ljanpts   type zrpqv-grosspts,
          lfebpts   type zrpqv-grosspts,
          lmarpts   type zrpqv-grosspts,
          aprgr     type p,
          maygr     type p,
          jungr     type p,
          julgr     type p,
          auggr     type p,
          sepgr     type p,
          octgr     type p,
          novgr     type p,
          decgr     type p,
          jangr     type p,
          febgr     type p,
          margr     type p,
          vaprgr    type p,
          vmaygr    type p,
          vjungr    type p,
          vjulgr    type p,
          vauggr    type p,
          vsepgr    type p,
          voctgr    type p,
          vnovgr    type p,
          vdecgr    type p,
          vjangr    type p,
          vfebgr    type p,
          vmargr    type p,

          smpaprqty type p,
          smpmayqty type p,
          smpjunqty type p,
          smpjulqty type p,
          smpaugqty type p,
          smpsepqty type p,
          smpoctqty type p,
          smpnovqty type p,
          smpdecqty type p,
          smpjanqty type p,
          smpfebqty type p,
          smpmarqty type p,

          rapr      type p,
          rmay      type p,
          rjun      type p,
          rjul      type p,
          raug      type p,
          rsep      type p,
          roct      type p,
          rnov      type p,
          rdec      type p,
          rjan      type p,
          rfeb      type p,
          rmar      type p,
          smptot    type p,
        end of itab9.

data : it_tab1  type table of itab1,
       wa_tab1  type itab1,
       it_tab2  type table of itab1,
       wa_tab2  type itab1,
       it_tac1  type table of itab1,
       wa_tac1  type itab1,
       it_tab3  type table of itab3,
       wa_tab3  type itab3,
       it_tab4  type table of itab4,
       wa_tab4  type itab4,
       it_tab5  type table of itab4,
       wa_tab5  type itab4,
       it_tas1  type table of itas1,
       wa_tas1  type itas1,
       it_tas2  type table of itas1,
       wa_tas2  type itas1,
       it_tas3  type table of itas3,
       wa_tas3  type itas3,
       it_tas4  type table of itas4,
       wa_tas4  type itas4,
       it_tab6  type table of itab6,
       wa_tab6  type itab6,
       it_tab7  type table of itab7,
       wa_tab7  type itab7,
       it_tab71 type table of itab71,
       wa_tab71 type itab71,
       it_tab8  type table of itab8,
       wa_tab8  type itab8,
       it_tab9  type table of itab9,
       wa_tab9  type itab9,
       it_samp1 type table of itas1,
       wa_samp1 type itas1.

data : grpnm(11) type c.

data : it_yterrallc type table of yterrallc,
       wa_yterrallc type yterrallc,
       it_pa0001    type table of ty_pa0001,                "pa0001,
       wa_pa0001    type ty_pa0001.                         "pa0001.

types : begin of itaq1,
          bzirk type yterrallc-bzirk,
        end of itaq1.

types : begin of itaq2,
          bzirk      type yterrallc-bzirk,
          usrid_long type pa0105-usrid_long,

        end of itaq2.

data : it_taq1 type table of itaq1,
       wa_taq1 type itaq1,
       it_taq2 type table of itaq2,
       wa_taq2 type itaq2,
       it_taz1 type table of itaq1,
       wa_taz1 type itaq1,
       it_taz2 type table of itaq2,
       wa_taz2 type itaq2.

data : it_tar1 type table of itaq1,
       wa_tar1 type itaq1,
       it_tar2 type table of itaq2,
       wa_tar2 type itaq2.


types : begin of itap1,
          pernr type pa0001-pernr,
        end of itap1.

types : begin of itap2,
          pernr      type pa0001-pernr,
          usrid_long type pa0105-usrid_long,
        end of itap2.

data : it_tap1 type table of itap1,
       wa_tap1 type itap1,
       it_tap2 type table of itap2,
       wa_tap2 type itap2.

data : msg      type string,
       sdate    type sy-datum,
       month(2) type c,
       year(4)  type c,
       date1    type sy-datum,
       ldate    type sy-datum,
       fdate    type sy-datum,
       date2    type sy-datum,
       text(12) type c.

data : cyear(4) type c,
       lyear(4) type c,
       nyear(4) type c.

data : aprgr type p,
       maygr type p,
       jungr type p,
       julgr type p,
       auggr type p,
       sepgr type p,
       octgr type p,
       novgr type p,
       decgr type p,
       jangr type p,
       febgr type p,
       margr type p.

data : aprdt  type sy-datum,
       maydt  type sy-datum,
       jundt  type sy-datum,
       juldt  type sy-datum,
       augdt  type sy-datum,
       sepdt  type sy-datum,
       octdt  type sy-datum,
       novdt  type sy-datum,
       decdt  type sy-datum,
       jandt  type sy-datum,
       febdt  type sy-datum,
       mardt  type sy-datum,


       caprdt type sy-datum,
       cmaydt type sy-datum,
       cjundt type sy-datum,
       cjuldt type sy-datum,
       caugdt type sy-datum,
       csepdt type sy-datum,
       coctdt type sy-datum,
       cnovdt type sy-datum,
       cdecdt type sy-datum,
       cjandt type sy-datum,
       cfebdt type sy-datum,
       cmardt type sy-datum.

data : xmonth(2) type c,
       xyear(4)  type c,
       mname     type t247-ktx.


data : rapr type p,
       rmay type i,
       rjun type i,
       rjul type i,
       raug type i,
       rsep type i,
       roct type i,
       rnov type i,
       rdec type i,
       rjan type i,
       rfeb type i,
       rmar type i.

data :
  cumcmay type p,
  cumcjun type p,
  cumcjul type p,
  cumcaug type p,
  cumcsep type p,
  cumcoct type p,
  cumcnov type p,
  cumcdec type p,
  cumcjan type p,
  cumcfeb type p,
  cumcmar type p,

  cumlmay type p,
  cumljun type p,
  cumljul type p,
  cumlaug type p,
  cumlsep type p,
  cumloct type p,
  cumlnov type p,
  cumldec type p,
  cumljan type p,
  cumlfeb type p,
  cumlmar type p.

data : c1  type p,
       c2  type p,
       c3  type p,
       c4  type p,
       c5  type p,
       c6  type p,
       c7  type p,
       c8  type p,
       c9  type p,
       c10 type p,
       c11 type p,
       c12 type p.

data : vc1  type p,
       vc2  type p,
       vc3  type p,
       vc4  type p,
       vc5  type p,
       vc6  type p,
       vc7  type p,
       vc8  type p,
       vc9  type p,
       vc10 type p,
       vc11 type p,
       vc12 type p.


data : page1       type i value 1,
       page2       type i,
       page3       type i,
       pso_name    type pa0001-ename,
       pso_hq_code type zdehr_hqcode,
       pso_hq      type zthr_heq_des-zz_hqdesc,
       zm_name     type pa0001-ename.

data : lcum_tot    type p,
       cum_tot     type p,
       lcumvtot    type p,
       cumvtot     type p,
       smpcum_tot  type p,
       ltot        type p,
       ctot        type p,
       vltot       type p,
       vctot       type p,
       smptot      type p,
       smp_tot     type p,
       pcsale      type p,
       grplcum_tot type p,
       grpltot     type p,
       grpcum_tot  type p,
       p           type p,
       mgrapr      type p,
       mgrmay      type p,
       mgrjun      type p,
       mgrjul      type p,
       mgraug      type p,
       mgrsep      type p,
       mgroct      type p,
       mgrnov      type p,
       mgrdec      type p,
       mgrjan      type p,
       mgrfeb      type p,
       mgrmar      type p.


data : nupdt type sy-datum,
       supdt type sy-datum.

data : ljun type p.

data : laprgrp        type p,
       lmaygrp        type p,
       ljungrp        type p,
       ljulgrp        type p,
       lauggrp        type p,
       lsepgrp        type p,
       loctgrp        type p,
       lnovgrp        type p,
       ldecgrp        type p,
       ljangrp        type p,
       lfebgrp        type p,
       lmargrp        type p,

       n1             type p,

       caprgrp(6)     type c,
       cmaygrp(6)     type c,
       cjungrp(6)     type c,
       cjulgrp(6)     type c,
       cauggrp(6)     type c,
       csepgrp(6)     type c,
       coctgrp(6)     type c,
       cnovgrp(6)     type c,
       cdecgrp(6)     type c,
       cjangrp(6)     type c,
       cfebgrp(6)     type c,
       cmargrp(6)     type c,

       gcumaprgr(6)   type c,
       gcummaygr(6)   type c,
       gcumjungr(6)   type c,
       gcumjulgr(6)   type c,
       gcumauggr(6)   type c,
       gcumsepgr(6)   type c,
       gcumoctgr(6)   type c,
       gcumnovgr(6)   type c,
       gcumdecgr(6)   type c,
       gcumjangr(6)   type c,
       gcumfebgr(6)   type c,
       gcummargr(6)   type c,

       gcumaprgr1     type p,
       gcummaygr1     type p,
       gcumjungr1     type p,
       gcumjulgr1     type p,
       gcumauggr1     type p,
       gcumsepgr1     type p,
       gcumoctgr1     type p,
       gcumnovgr1     type p,
       gcumdecgr1     type p,
       gcumjangr1     type p,
       gcumfebgr1     type p,
       gcummargr1     type p,



       smpaprgrp(6)   type c,
       smpmaygrp(6)   type c,
       smpjungrp(6)   type c,
       smpjulgrp(6)   type c,
       smpauggrp(6)   type c,
       smpsepgrp(6)   type c,
       smpoctgrp(6)   type c,
       smpnovgrp(6)   type c,
       smpdecgrp(6)   type c,
       smpjangrp(6)   type c,
       smpfebgrp(6)   type c,
       smpmargrp(6)   type c,

       ratioaprgrp1   type p,
       ratiomaygrp1   type p,
       ratiojungrp1   type p,
       ratiojulgrp1   type p,
       ratioauggrp1   type p,
       ratiosepgrp1   type p,
       ratiooctgrp1   type p,
       rationovgrp1   type p,
       ratiodecgrp1   type p,
       ratiojangrp1   type p,
       ratiofebgrp1   type p,
       ratiomargrp1   type p,

       ratioaprgrp(6) type c,
       ratiomaygrp(6) type c,
       ratiojungrp(6) type c,
       ratiojulgrp(6) type c,
       ratioauggrp(6) type c,
       ratiosepgrp(6) type c,
       ratiooctgrp(6) type c,
       rationovgrp(6) type c,
       ratiodecgrp(6) type c,
       ratiojangrp(6) type c,
       ratiofebgrp(6) type c,
       ratiomargrp(6) type c.
data : smptotal type p.
data : tlaprqty(7)    type c,
       tlmayqty(7)    type c,
       tljunqty(7)    type c,
       tljulqty(7)    type c,
       tlaugqty(7)    type c,
       tlsepqty(7)    type c,
       tloctqty(7)    type c,
       tlnovqty(7)    type c,
       tldecqty(7)    type c,
       tljanqty(7)    type c,
       tlfebqty(7)    type c,
       tlmarqty(7)    type c,


       tcaprqty(7)    type c,
       tcmayqty(7)    type c,
       tcjunqty(7)    type c,
       tcjulqty(7)    type c,
       tcaugqty(7)    type c,
       tcsepqty(7)    type c,
       tcoctqty(7)    type c,
       tcnovqty(7)    type c,
       tcdecqty(7)    type c,
       tcjanqty(7)    type c,
       tcfebqty(7)    type c,
       tcmarqty(7)    type c,


       tsmpaprqty(7)  type c,
       tsmpmayqty(7)  type c,
       tsmpjunqty(7)  type c,
       tsmpjulqty(7)  type c,
       tsmpaugqty(7)  type c,
       tsmpsepqty(7)  type c,
       tsmpoctqty(7)  type c,
       tsmpnovqty(7)  type c,
       tsmpdecqty(7)  type c,
       tsmpjanqty(7)  type c,
       tsmpfebqty(7)  type c,
       tsmpmarqty(7)  type c,

       t1smpaprqty(7) type c,
       t1smpmayqty(7) type c,
       t1smpjunqty(7) type c,
       t1smpjulqty(7) type c,
       t1smpaugqty(7) type c,
       t1smpsepqty(7) type c,
       t1smpoctqty(7) type c,
       t1smpnovqty(7) type c,
       t1smpdecqty(7) type c,
       t1smpjanqty(7) type c,
       t1smpfebqty(7) type c,
       t1smpmarqty(7) type c,

       tcumapr(7)     type c,
       tcummay(7)     type c,
       tcumjun(7)     type c,
       tcumjul(7)     type c,
       tcumaug(7)     type c,
       tcumsep(7)     type c,
       tcumoct(7)     type c,
       tcumnov(7)     type c,
       tcumdec(7)     type c,
       tcumjan(7)     type c,
       tcumfeb(7)     type c,
       tcummar(7)     type c,

       ttcumapr       type p,
       ttcummay       type p,
       ttcumjun       type p,
       ttcumjul       type p,
       ttcumaug       type p,
       ttcumsep       type p,
       ttcumoct       type p,
       ttcumnov       type p,
       ttcumdec       type p,
       ttcumjan       type p,
       ttcumfeb       type p,
       ttcummar       type p,

       trapr(6)       type c,
       trmay(6)       type c,
       trjun(6)       type c,
       trjul(6)       type c,
       traug(6)       type c,
       trsep(6)       type c,
       troct(6)       type c,
       trnov(6)       type c,
       trdec(6)       type c,
       trjan(6)       type c,
       trfeb(6)       type c,
       trmar(6)       type c,

       ttrapr         type p,
       ttrmay         type p,
       ttrjun         type p,
       ttrjul         type p,
       ttraug         type p,
       ttrsep         type p,
       ttroct         type p,
       ttrnov         type p,
       ttrdec         type p,
       ttrjan         type p,
       ttrfeb         type p,
       ttrmar         type p.

data : t1  type p,
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
       t12 type p.

data : tt1 type p.


data : tcumtot(7) type c,
       tyrtot(7)  type c,
       tcycum(7)  type c.


data : nnupdt type sy-datum,
       div(3) type c.

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
data : wa_d1(10) type c.

selection-screen begin of block b1 with frame title text-001.
select-options : zone for zdsmter-zdsm matchcode object zsr9_1.
select-options : ter for zdsmter-bzirk  matchcode object zsr7p1 no intervals.
parameter : updt like sy-datum obligatory.

parameter : r1 radiobutton group r1,
            r2 radiobutton group r1,
            r3 radiobutton group r1,
            r4 radiobutton group r1,
            r7 radiobutton group r1,
            r5 radiobutton group r1,
            r6 radiobutton group r1.
parameter : email(70) type c.
selection-screen end of block b1.

"Perf.Improvement......shr......commented as not required
******initialization.
******  g_repid = sy-repid.

"Perf.Improvement......shr commented as event is incorrect...added under start of selection event
*****at selection-screen output.
*****  SELECT * FROM ZDSMTER INTO TABLE IT_ZDSMTER11 WHERE ZDSM IN ZONE.
*****
*****  LOOP AT IT_ZDSMTER11 INTO WA_ZDSMTER11.
*****    AUTHORITY-CHECK OBJECT 'ZON1_1'
*****           ID 'ZDSM' FIELD WA_ZDSMTER11-ZDSM.
*****    IF SY-SUBRC <> 0.
*****      CONCATENATE 'No authorization for Zone' WA_ZDSMTER11-ZDSM INTO MSG
*****      SEPARATED BY SPACE.
*****      MESSAGE MSG TYPE 'E'.
*****    ENDIF.
*****  ENDLOOP.

*** commented and added under start of selection event - 30.10.2023 BCDK933744
*****at selection-screen on radiobutton group r1.
*****  if r6 eq 'X'.
*****    if email eq '                                                                     '.
*****      message 'ENTER EMAIL ID' type 'E'.
*****    endif.
*****  endif.

*  WRITE : / 'MONTH,YEAR',MONTH,YEAR,sdate.
start-of-selection.
*** added below - 30.10.2023 BCDK933744
  if r6 eq 'X'.
    if email is INITIAL.
      message 'ENTER EMAIL ID' type 'E'.
    endif.
  endif.

  "Perf.Improvement......shr....added here - start
  clear it_zdsmter11[].
  select * from zdsmter into table it_zdsmter11
    where zdsm in zone
    and zmonth = updt+4(2)
    and zyear = updt+0(4).
  if sy-subrc = 0.
    sort  it_zdsmter11[] by zdsm.

    loop at it_zdsmter11 into wa_zdsmter11 where zdsm+0(2) cs 'D-'.
      authority-check object 'ZON1_1'
             id 'ZDSM' field wa_zdsmter11-zdsm.
      if sy-subrc <> 0.
        concatenate 'No authorization for Zone' wa_zdsmter11-zdsm into msg
        separated by space.
        message msg type 'E'.
      endif.
    endloop.
  endif.
  "Perf.Improvement......shr....added here - end
  p_sale = ' '.


*************** data logic change *****************

  fdate+6(2) = '01'.
  fdate+4(2) = updt+4(2).
  fdate+0(4) = updt+0(4).

  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date           = fdate
    importing
*     EV_MONTH_BEGIN_DATE       =
      ev_month_end_date = ldate.


  sdate =  updt.
  sdate+6(2) = '15'.

  month = updt+4(2).
  year = updt+0(4).

  date1 = updt.
  date1+6(2) = '01'.

  select * from zdsmter into table it_zdsmter where zmonth eq month and zyear eq year.
******  select * from zdsmter into table it_zdsmter1 where zmonth eq month and zyear eq year and zdsm in zone.    "Perf.Improvement...commented as unused.

  if month ge '04'.
    cyear = year.
  else.
    cyear = year - 1.
  endif.
  lyear = cyear - 1.
  nyear = cyear + 1.

  perform nameupdt.
  perform pyear.
  perform cyear.
  perform cumm_gr.
  perform samp_data.
  perform mergedata.

  if it_tab8[] is not initial.
    select * from yterrallc into table it_yterrallc for all entries in it_tab8 where bzirk eq it_tab8-bzirk and endda ge sy-datum.
    if sy-subrc eq 0.
      select pernr endda  begda plans ename from pa0001 into table it_pa0001 for all entries in it_yterrallc where plans eq it_yterrallc-plans.
    endif.
  endif.
  sort it_pa0001 descending by endda.

  formnm = 'ZSR7P1'.
  if r1 eq 'X'.
    perform alv.
  elseif r2 eq 'X'.
    perform open_form.
    perform layout.
    perform close_form1.
  elseif r3 eq 'X'.
    perform email.
  elseif r4 eq 'X'.
    perform rm_email.
  elseif r7 eq 'X'.
    perform dzm_email.
  elseif r5 eq 'X'.
    perform zm_email.
  elseif r6 eq 'X'.
    perform email_to.
  endif.


*&---------------------------------------------------------------------*
*&      Form  EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form email.


  sort it_tab8 by reg rm bzirk grp_code prn_seq .
*  sort it_tab8 by reg rm bzirk prn_seq.

  options-tdgetotf = 'X'.
  loop at it_tap1 into wa_tap1.
    perform open_form1.
    perform start_form.

    loop at it_tab8 into wa_tab8 where pernr eq wa_tap1-pernr.
      perform form1.




      at end of grp_code.

***************************
        clear : grpnm,smptotal.
        smptotal = smpaprgrp + smpmaygrp + smpjungrp + smpjulgrp + smpauggrp + smpsepgrp + smpoctgrp + smpnovgrp + smpdecgrp + smpjangrp
        + smpfebgrp + smpmargrp.

        if wa_tab8-grp_code eq '7777'.
          grpnm = 'BC OTHER'.
        elseif wa_tab8-grp_code eq '8888'.
          grpnm = 'XL OTHER'.
        else.
          grpnm = 'GROUP TOTAL'.
        endif.

        if smptotal eq 0 and grplcum_tot eq 0 and grpltot eq 0 and grpcum_tot eq 0."19.11.2019
        else.
****************************

          call function 'WRITE_FORM'
            exporting
              element = 'GRP1'
              window  = 'MAIN'.
        endif.
        grplcum_tot = 0.
        grpcum_tot = 0.
        grpltot = 0.
        laprgrp = 0.
        caprgrp = 0.
        gcumaprgr = 0.
        smpaprgrp = 0.
        ratioaprgrp = 0.

        lmaygrp = 0.
        cmaygrp = 0.
        gcummaygr = 0.
        smpmaygrp = 0.
        ratiomaygrp = 0.

        ljungrp = 0.
        cjungrp = 0.
        gcumjungr = 0.
        smpjungrp = 0.
        ratiojungrp = 0.

        ljulgrp = 0.
        cjulgrp = 0.
        gcumjulgr = 0.
        smpjulgrp = 0.
        ratiojulgrp = 0.

        lauggrp = 0.
        cauggrp = 0.
        gcumauggr = 0.
        smpauggrp = 0.
        ratioauggrp = 0.

        lsepgrp = 0.
        csepgrp = 0.
        gcumsepgr = 0.
        smpsepgrp = 0.
        ratiosepgrp = 0.

        loctgrp = 0.
        coctgrp = 0.
        gcumoctgr = 0.
        smpoctgrp = 0.
        ratiooctgrp = 0.

        lnovgrp = 0.
        cnovgrp = 0.
        gcumnovgr = 0.
        smpnovgrp = 0.
        rationovgrp = 0.

        ldecgrp = 0.
        cdecgrp = 0.
        gcumdecgr = 0.
        smpdecgrp = 0.
        ratiodecgrp = 0.

        ljangrp = 0.
        cjangrp = 0.
        gcumjangr = 0.
        smpjangrp = 0.
        ratiojangrp = 0.

        lfebgrp = 0.
        cfebgrp = 0.
        gcumfebgr = 0.
        smpfebgrp = 0.
        ratiofebgrp = 0.

        lmargrp = 0.
        cmargrp = 0.
        gcummargr = 0.
        smpmargrp = 0.
        ratiomargrp = 0.
      endat.
**************TERRITORY TOTAL****************

      perform ter_total.
      at end of bzirk.
        call function 'WRITE_FORM'
          exporting
            element = 'H3'
            window  = 'MAIN'.

        t1smpaprqty = 0.
        t1smpmayqty = 0.
        t1smpjunqty = 0.
        t1smpjulqty = 0.
        t1smpaugqty = 0.
        t1smpsepqty = 0.
        t1smpoctqty = 0.
        t1smpnovqty = 0.
        t1smpdecqty = 0.
        t1smpjanqty = 0.
        t1smpfebqty = 0.
        t1smpmarqty = 0.

        tlaprqty = 0.
        tcaprqty = 0.
        tsmpaprqty = 0.
        tcumapr = 0.
        trapr = 0.

        tlmayqty = 0.
        tcmayqty = 0.
        tsmpmayqty = 0.
        tcummay = 0.
        trmay = 0.

        tljunqty = 0.
        tcjunqty = 0.
        tsmpjunqty = 0.
        tcumjun = 0.
        trjun = 0.

        tljulqty = 0.
        tcjulqty = 0.
        tsmpjulqty = 0.
        tcumjul = 0.
        trjul = 0.

        tlaugqty = 0.
        tcaugqty = 0.
        tsmpaugqty = 0.
        tcumaug = 0.
        traug = 0.

        tlsepqty = 0.
        tcsepqty = 0.
        tsmpsepqty = 0.
        tcumsep = 0.
        trsep = 0.

        tloctqty = 0.
        tcoctqty = 0.
        tsmpoctqty = 0.
        tcumoct = 0.
        troct = 0.

        tlnovqty = 0.
        tcnovqty = 0.
        tsmpnovqty = 0.
        tcumnov = 0.
        trnov = 0.

        tldecqty = 0.
        tcdecqty = 0.
        tsmpdecqty = 0.
        tcumdec = 0.
        trdec = 0.

        tljanqty = 0.
        tcjanqty = 0.
        tsmpjanqty = 0.
        tcumjan = 0.
        trjan = 0.

        tlfebqty = 0.
        tcfebqty = 0.
        tsmpfebqty = 0.
        tcumfeb = 0.
        trfeb = 0.

        tlmarqty = 0.
        tcmarqty = 0.
        tsmpmarqty = 0.
        tcummar = 0.
        trmar = 0.

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

    write updt to wa_d1 dd/mm/yyyy.


    describe table objbin lines righe_attachment.
    objtxt = 'This eMail is meant for information only. Please DO NOT REPLY'.append objtxt.
    objtxt = '                                 '.append objtxt.
    objtxt = 'BLUE CROSS LABORATORIES LTD.'.append objtxt.
    describe table objtxt lines righe_testo.
    doc_chng-obj_name = 'URGENT'.
    doc_chng-expiry_dat = sy-datum + 10.
    condense ltx.
    condense objtxt.

    concatenate 'SR-7-P SAMPLE V/S SALE as of ' wa_d1 into doc_chng-obj_descr separated by space.
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

    concatenate 'SR-7P' '-PSO' into objpack-obj_descr separated by space.
    objpack-doc_size = righe_attachment * 255.
    append objpack.
    clear objpack.

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

        write : / 'EMAIL SENT ON ',wa_tap2-usrid_long.
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
*&      Form  RM_email
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form rm_email.

  sort it_taq1 by bzirk.
  delete adjacent duplicates from it_taq1 comparing bzirk.

  loop at it_taq1 into wa_taq1.
    select single * from yterrallc where bzirk eq wa_taq1-bzirk and begda le updt and endda ge updt.
    if sy-subrc eq 0.
      select single * from pa0001 where plans eq yterrallc-plans and begda le updt and endda ge updt.
      if sy-subrc eq 0.
        select single * from pa0105 where pernr eq pa0001-pernr and subty eq '0010'.
        if sy-subrc eq 0.
          wa_taq2-bzirk = wa_taq1-bzirk.
          wa_taq2-usrid_long = pa0105-usrid_long.
          collect wa_taq2 into it_taq2.
          clear wa_taq2.
        endif.
      endif.
    endif.
  endloop.

*  sort it_tab8 by reg rm bzirk prn_seq.
  sort it_tab8 by reg rm bzirk grp_code prn_seq .
  options-tdgetotf = 'X'.
  loop at it_taq1 into wa_taq1.
    perform open_form1.
    perform start_form.

    loop at it_tab8 into wa_tab8 where rm eq wa_taq1-bzirk.
      perform form1.
      at end of grp_code.

        clear : grpnm,smptotal.
        smptotal = smpaprgrp + smpmaygrp + smpjungrp + smpjulgrp + smpauggrp + smpsepgrp + smpoctgrp + smpnovgrp + smpdecgrp + smpjangrp
        + smpfebgrp + smpmargrp.
*      WRITE : / '**',WA_TAB8-GRP_CODE.
        if wa_tab8-grp_code eq '7777'.
          grpnm = 'BC OTHER'.
        elseif wa_tab8-grp_code eq '8888'.
          grpnm = 'XL OTHER'.
        else.
          grpnm = 'GROUP TOTAL'.
        endif.

        if smptotal eq 0 and grplcum_tot eq 0 and grpltot eq 0 and grpcum_tot eq 0."19.11.2019
        else.
*******************

          call function 'WRITE_FORM'
            exporting
              element = 'GRP1'
              window  = 'MAIN'.
        endif.

        laprgrp = 0.
        caprgrp = 0.
        gcumaprgr = 0.
        smpaprgrp = 0.
        ratioaprgrp = 0.

        lmaygrp = 0.
        cmaygrp = 0.
        gcummaygr = 0.
        smpmaygrp = 0.
        ratiomaygrp = 0.

        ljungrp = 0.
        cjungrp = 0.
        gcumjungr = 0.
        smpjungrp = 0.
        ratiojungrp = 0.

        ljulgrp = 0.
        cjulgrp = 0.
        gcumjulgr = 0.
        smpjulgrp = 0.
        ratiojulgrp = 0.

        lauggrp = 0.
        cauggrp = 0.
        gcumauggr = 0.
        smpauggrp = 0.
        ratioauggrp = 0.

        lsepgrp = 0.
        csepgrp = 0.
        gcumsepgr = 0.
        smpsepgrp = 0.
        ratiosepgrp = 0.

        loctgrp = 0.
        coctgrp = 0.
        gcumoctgr = 0.
        smpoctgrp = 0.
        ratiooctgrp = 0.

        lnovgrp = 0.
        cnovgrp = 0.
        gcumnovgr = 0.
        smpnovgrp = 0.
        rationovgrp = 0.

        ldecgrp = 0.
        cdecgrp = 0.
        gcumdecgr = 0.
        smpdecgrp = 0.
        ratiodecgrp = 0.

        ljangrp = 0.
        cjangrp = 0.
        gcumjangr = 0.
        smpjangrp = 0.
        ratiojangrp = 0.

        lfebgrp = 0.
        cfebgrp = 0.
        gcumfebgr = 0.
        smpfebgrp = 0.
        ratiofebgrp = 0.

        lmargrp = 0.
        cmargrp = 0.
        gcummargr = 0.
        smpmargrp = 0.
        ratiomargrp = 0.
      endat.
**************TERRITORY TOTAL****************
      perform ter_total.
      at end of bzirk.

        call function 'WRITE_FORM'
          exporting
            element = 'H3'
            window  = 'MAIN'.

        t1smpaprqty = 0.
        t1smpmayqty = 0.
        t1smpjunqty = 0.
        t1smpjulqty = 0.
        t1smpaugqty = 0.
        t1smpsepqty = 0.
        t1smpoctqty = 0.
        t1smpnovqty = 0.
        t1smpdecqty = 0.
        t1smpjanqty = 0.
        t1smpfebqty = 0.
        t1smpmarqty = 0.

        tlaprqty = 0.
        tcaprqty = 0.
        tsmpaprqty = 0.
        tcumapr = 0.
        trapr = 0.

        tlmayqty = 0.
        tcmayqty = 0.
        tsmpmayqty = 0.
        tcummay = 0.
        trmay = 0.

        tljunqty = 0.
        tcjunqty = 0.
        tsmpjunqty = 0.
        tcumjun = 0.
        trjun = 0.

        tljulqty = 0.
        tcjulqty = 0.
        tsmpjulqty = 0.
        tcumjul = 0.
        trjul = 0.

        tlaugqty = 0.
        tcaugqty = 0.
        tsmpaugqty = 0.
        tcumaug = 0.
        traug = 0.

        tlsepqty = 0.
        tcsepqty = 0.
        tsmpsepqty = 0.
        tcumsep = 0.
        trsep = 0.

        tloctqty = 0.
        tcoctqty = 0.
        tsmpoctqty = 0.
        tcumoct = 0.
        troct = 0.

        tlnovqty = 0.
        tcnovqty = 0.
        tsmpnovqty = 0.
        tcumnov = 0.
        trnov = 0.

        tldecqty = 0.
        tcdecqty = 0.
        tsmpdecqty = 0.
        tcumdec = 0.
        trdec = 0.

        tljanqty = 0.
        tcjanqty = 0.
        tsmpjanqty = 0.
        tcumjan = 0.
        trjan = 0.

        tlfebqty = 0.
        tcfebqty = 0.
        tsmpfebqty = 0.
        tcumfeb = 0.
        trfeb = 0.

        tlmarqty = 0.
        tcmarqty = 0.
        tsmpmarqty = 0.
        tcummar = 0.
        trmar = 0.

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

    write updt to wa_d1 dd/mm/yyyy.
*      write s_budat-high to wa_d2 dd/mm/yyyy.

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
    concatenate 'SR-7-P SAMPLE V/S SALE as of ' wa_d1 into doc_chng-obj_descr separated by space.
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

    concatenate 'SR-7P' '-RM' into objpack-obj_descr separated by space.
    objpack-doc_size = righe_attachment * 255.
    append objpack.
    clear objpack.

    loop at it_taq2 into wa_taq2 where bzirk = wa_taq1-bzirk.
      reclist-receiver =   wa_taq2-usrid_long.
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

*        write : / 'EMAIL SENT ON ',wa_taq2-usrid_long.
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

  loop at it_taq2 into wa_taq2.
    write : / 'EMAIL SENT ON ',wa_taq2-usrid_long.
  endloop.
endform.                    "EMAIL




*&---------------------------------------------------------------------*
*&      Form  ZM_email
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form zm_email.

  sort it_tar1 by bzirk.
  delete adjacent duplicates from it_tar1 comparing bzirk.

  loop at it_tar1 into wa_tar1.
    select single * from yterrallc where bzirk eq wa_tar1-bzirk and begda le updt and endda ge updt.
    if sy-subrc eq 0.
      select single * from pa0001 where plans eq yterrallc-plans and begda le updt and endda ge updt.
      if sy-subrc eq 0.
        select single * from pa0105 where pernr eq pa0001-pernr and subty eq '0010'.
        if sy-subrc eq 0.
          wa_tar2-bzirk = wa_tar1-bzirk.
          wa_tar2-usrid_long = pa0105-usrid_long.
          collect wa_tar2 into it_tar2.
          clear wa_tar2.
        endif.
      endif.
    endif.
  endloop.

*  sort it_tab8 by reg rm bzirk prn_seq.
  sort it_tab8 by reg rm bzirk grp_code prn_seq .

  options-tdgetotf = 'X'.
  loop at it_tar1 into wa_tar1.
    perform open_form1.
    perform start_form.

    loop at it_tab8 into wa_tab8 where reg eq wa_tar1-bzirk.
      perform form1.
      at end of grp_code.
*        clear : grpnm.
**      WRITE : / '**',WA_TAB8-GRP_CODE.
*        if wa_tab8-grp_code eq '7777'.
*          grpnm = 'BC OTHER'.
*        elseif wa_tab8-grp_code eq '8888'.
*          grpnm = 'XL OTHER'.
*        else.
*          grpnm = 'GROUP TOTAL'.
*        endif.

***************************************
        clear : grpnm,smptotal.
        smptotal = smpaprgrp + smpmaygrp + smpjungrp + smpjulgrp + smpauggrp + smpsepgrp + smpoctgrp + smpnovgrp + smpdecgrp + smpjangrp
        + smpfebgrp + smpmargrp.
*      WRITE : / '**',WA_TAB8-GRP_CODE.
        if wa_tab8-grp_code eq '7777'.
          grpnm = 'BC OTHER'.
        elseif wa_tab8-grp_code eq '8888'.
          grpnm = 'XL OTHER'.
        else.
          grpnm = 'GROUP TOTAL'.
        endif.

        if smptotal eq 0 and grplcum_tot eq 0 and grpltot eq 0 and grpcum_tot eq 0."19.11.2019
        else.
************************************

          call function 'WRITE_FORM'
            exporting
              element = 'GRP1'
              window  = 'MAIN'.
        endif.

        laprgrp = 0.
        caprgrp = 0.
        gcumaprgr = 0.
        smpaprgrp = 0.
        ratioaprgrp = 0.

        lmaygrp = 0.
        cmaygrp = 0.
        gcummaygr = 0.
        smpmaygrp = 0.
        ratiomaygrp = 0.

        ljungrp = 0.
        cjungrp = 0.
        gcumjungr = 0.
        smpjungrp = 0.
        ratiojungrp = 0.

        ljulgrp = 0.
        cjulgrp = 0.
        gcumjulgr = 0.
        smpjulgrp = 0.
        ratiojulgrp = 0.

        lauggrp = 0.
        cauggrp = 0.
        gcumauggr = 0.
        smpauggrp = 0.
        ratioauggrp = 0.

        lsepgrp = 0.
        csepgrp = 0.
        gcumsepgr = 0.
        smpsepgrp = 0.
        ratiosepgrp = 0.

        loctgrp = 0.
        coctgrp = 0.
        gcumoctgr = 0.
        smpoctgrp = 0.
        ratiooctgrp = 0.

        lnovgrp = 0.
        cnovgrp = 0.
        gcumnovgr = 0.
        smpnovgrp = 0.
        rationovgrp = 0.

        ldecgrp = 0.
        cdecgrp = 0.
        gcumdecgr = 0.
        smpdecgrp = 0.
        ratiodecgrp = 0.

        ljangrp = 0.
        cjangrp = 0.
        gcumjangr = 0.
        smpjangrp = 0.
        ratiojangrp = 0.

        lfebgrp = 0.
        cfebgrp = 0.
        gcumfebgr = 0.
        smpfebgrp = 0.
        ratiofebgrp = 0.

        lmargrp = 0.
        cmargrp = 0.
        gcummargr = 0.
        smpmargrp = 0.
        ratiomargrp = 0.
      endat.
**************TERRITORY TOTAL****************
      perform ter_total.

      at end of bzirk.

        call function 'WRITE_FORM'
          exporting
            element = 'H3'
            window  = 'MAIN'.

        t1smpaprqty = 0.
        t1smpmayqty = 0.
        t1smpjunqty = 0.
        t1smpjulqty = 0.
        t1smpaugqty = 0.
        t1smpsepqty = 0.
        t1smpoctqty = 0.
        t1smpnovqty = 0.
        t1smpdecqty = 0.
        t1smpjanqty = 0.
        t1smpfebqty = 0.
        t1smpmarqty = 0.

        tlaprqty = 0.
        tcaprqty = 0.
        tsmpaprqty = 0.
        tcumapr = 0.
        trapr = 0.

        tlmayqty = 0.
        tcmayqty = 0.
        tsmpmayqty = 0.
        tcummay = 0.
        trmay = 0.

        tljunqty = 0.
        tcjunqty = 0.
        tsmpjunqty = 0.
        tcumjun = 0.
        trjun = 0.

        tljulqty = 0.
        tcjulqty = 0.
        tsmpjulqty = 0.
        tcumjul = 0.
        trjul = 0.

        tlaugqty = 0.
        tcaugqty = 0.
        tsmpaugqty = 0.
        tcumaug = 0.
        traug = 0.

        tlsepqty = 0.
        tcsepqty = 0.
        tsmpsepqty = 0.
        tcumsep = 0.
        trsep = 0.

        tloctqty = 0.
        tcoctqty = 0.
        tsmpoctqty = 0.
        tcumoct = 0.
        troct = 0.

        tlnovqty = 0.
        tcnovqty = 0.
        tsmpnovqty = 0.
        tcumnov = 0.
        trnov = 0.

        tldecqty = 0.
        tcdecqty = 0.
        tsmpdecqty = 0.
        tcumdec = 0.
        trdec = 0.

        tljanqty = 0.
        tcjanqty = 0.
        tsmpjanqty = 0.
        tcumjan = 0.
        trjan = 0.

        tlfebqty = 0.
        tcfebqty = 0.
        tsmpfebqty = 0.
        tcumfeb = 0.
        trfeb = 0.

        tlmarqty = 0.
        tcmarqty = 0.
        tsmpmarqty = 0.
        tcummar = 0.
        trmar = 0.

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

    write updt to wa_d1 dd/mm/yyyy.
*      write s_budat-high to wa_d2 dd/mm/yyyy.

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
    concatenate 'SR-7-P SAMPLE V/S SALE as of ' wa_d1 into doc_chng-obj_descr separated by space.
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

    concatenate 'SR-7P' '-ZM' into objpack-obj_descr separated by space.
    objpack-doc_size = righe_attachment * 255.
    append objpack.
    clear objpack.

    loop at it_tar2 into wa_tar2 where bzirk = wa_tar1-bzirk.
      reclist-receiver =   wa_tar2-usrid_long.
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

*        write : / 'EMAIL SENT ON ',wa_taq2-usrid_long.
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

  loop at it_tar2 into wa_tar2.
    write : / 'EMAIL SENT ON ',wa_tar2-usrid_long.
  endloop.
endform.                    "EMAIL


*&---------------------------------------------------------------------*
*&      Form  ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form alv.
  wa_fieldcat-fieldname = 'REG'.
  wa_fieldcat-seltext_l = 'REGION'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'RM'.
  wa_fieldcat-seltext_l = 'RM REGION'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'BZIRK'.
  wa_fieldcat-seltext_l = 'TERRITORRY'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'PERNR'.
  wa_fieldcat-seltext_l = 'PSO CODE'.
  append wa_fieldcat to fieldcat.

*  WA_FIELDCAT-fieldname = 'ENAME'.
*  WA_FIELDCAT-seltext_l = 'PSO NAME'.
*  APPEND WA_FIELDCAT TO FIELDCAT.

  wa_fieldcat-fieldname = 'PRN_SEQ'.
  wa_fieldcat-seltext_l = 'SEQUENCE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MAKTX'.
  wa_fieldcat-seltext_l = 'PRODUCT NAME'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'BEZEI'.
  wa_fieldcat-seltext_l = 'PACK SIZE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LAPRQTY'.
  wa_fieldcat-seltext_l = 'LY APR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LMAYQTY'.
  wa_fieldcat-seltext_l = 'LY MAY'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LJUNQTY'.
  wa_fieldcat-seltext_l = 'LY JUN'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LJULQTY'.
  wa_fieldcat-seltext_l = 'LY JUL'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LAUGQTY'.
  wa_fieldcat-seltext_l = 'LY AUG'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LSEPQTY'.
  wa_fieldcat-seltext_l = 'LY SEP'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LOCTQTY'.
  wa_fieldcat-seltext_l = 'LY OCT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LNOVQTY'.
  wa_fieldcat-seltext_l = 'LY NOV'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LDECQTY'.
  wa_fieldcat-seltext_l = 'LY DEC'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LJANQTY'.
  wa_fieldcat-seltext_l = 'LY JAN'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LFEBQTY'.
  wa_fieldcat-seltext_l = 'LY FEB'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LMARQTY'.
  wa_fieldcat-seltext_l = 'LY MAR'.
  append wa_fieldcat to fieldcat.

****************

  wa_fieldcat-fieldname = 'CAPRQTY'.
  wa_fieldcat-seltext_l = 'CY APR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CMAYQTY'.
  wa_fieldcat-seltext_l = 'CY MAY'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CJUNQTY'.
  wa_fieldcat-seltext_l = 'CY JUN'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CJULQTY'.
  wa_fieldcat-seltext_l = 'CY JUL'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CAUGQTY'.
  wa_fieldcat-seltext_l = 'CY AUG'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CSEPQTY'.
  wa_fieldcat-seltext_l = 'CY SEP'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'COCTQTY'.
  wa_fieldcat-seltext_l = 'CY OCT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CNOVQTY'.
  wa_fieldcat-seltext_l = 'CY NOV'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CDECQTY'.
  wa_fieldcat-seltext_l = 'CY DEC'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CJANQTY'.
  wa_fieldcat-seltext_l = 'CY JAN'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CFEBQTY'.
  wa_fieldcat-seltext_l = 'CY FEB'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CMARQTY'.
  wa_fieldcat-seltext_l = 'CY MAR'.
  append wa_fieldcat to fieldcat.
*****************


  wa_fieldcat-fieldname = 'SMPAPRQTY'.
  wa_fieldcat-seltext_l = 'SMPY APR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'SMPMAYQTY'.
  wa_fieldcat-seltext_l = 'SMPY MAY'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'SMPJUNQTY'.
  wa_fieldcat-seltext_l = 'SMPY JUN'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'SMPJULQTY'.
  wa_fieldcat-seltext_l = 'SMPY JUL'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'SMPAUGQTY'.
  wa_fieldcat-seltext_l = 'SMPY AUG'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'SMPSEPQTY'.
  wa_fieldcat-seltext_l = 'SMPY SEP'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'SMPOCTQTY'.
  wa_fieldcat-seltext_l = 'SMPY OCT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'SMPNOVQTY'.
  wa_fieldcat-seltext_l = 'SMPY NOV'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'SMPDECQTY'.
  wa_fieldcat-seltext_l = 'SMPY DEC'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'SMPJANQTY'.
  wa_fieldcat-seltext_l = 'SMPY JAN'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'SMPFEBQTY'.
  wa_fieldcat-seltext_l = 'SMPY FEB'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'SMPMARQTY'.
  wa_fieldcat-seltext_l = 'SMPY MAR'.
  append wa_fieldcat to fieldcat.
*****************************

  wa_fieldcat-fieldname = 'APRGR'.
  wa_fieldcat-seltext_l = 'APR GR%'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MAYGR'.
  wa_fieldcat-seltext_l = 'MAY GR%'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'JUNGR'.
  wa_fieldcat-seltext_l = 'JUN GR%'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'JULGR'.
  wa_fieldcat-seltext_l = 'JUL GR%'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'AUGGR'.
  wa_fieldcat-seltext_l = 'AUG GR%'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'SEPGR'.
  wa_fieldcat-seltext_l = 'SEP GR%'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'OCTGR'.
  wa_fieldcat-seltext_l = 'OCT GR%'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'NOVGR'.
  wa_fieldcat-seltext_l = 'NOV GR%'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'DECGR'.
  wa_fieldcat-seltext_l = 'DEC GR%'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'JANGR'.
  wa_fieldcat-seltext_l = 'JAN GR%'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'FEBGR'.
  wa_fieldcat-seltext_l = 'FEB GR%'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MARGR'.
  wa_fieldcat-seltext_l = 'MAR GR%'.
  append wa_fieldcat to fieldcat.

******************

  wa_fieldcat-fieldname = 'RAPR'.
  wa_fieldcat-seltext_l = 'RATIO APR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'RMAY'.
  wa_fieldcat-seltext_l = 'RATIO MAY '.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'RJUN'.
  wa_fieldcat-seltext_l = 'RATIO JUN '.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'RJUL'.
  wa_fieldcat-seltext_l = 'RATIO JUL '.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'RAUG'.
  wa_fieldcat-seltext_l = 'RATIO AUG '.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'RSEP'.
  wa_fieldcat-seltext_l = 'RATIO SEP '.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'ROCT'.
  wa_fieldcat-seltext_l = 'RATIO OCT '.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'RNOV'.
  wa_fieldcat-seltext_l = 'RATIO NOV '.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'RDEC'.
  wa_fieldcat-seltext_l = 'RATIO DEC '.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'RJAN'.
  wa_fieldcat-seltext_l = 'RATIO JAN '.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'RFEB'.
  wa_fieldcat-seltext_l = 'RATIO FEB '.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'RMAR'.
  wa_fieldcat-seltext_l = 'RATIO MAR '.
  append wa_fieldcat to fieldcat.


  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'PSO WISE QUANTITATIVE GROWTH DETAIL'.


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
      t_outtab                = it_tab8
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

  sort it_tab8 by reg rm bzirk grp_code prn_seq .
  loop at it_tab8 into wa_tab8.
    perform form1.
    perform start_form.
    at end of grp_code.

      clear : grpnm,smptotal.
      smptotal = smpaprgrp + smpmaygrp + smpjungrp + smpjulgrp + smpauggrp + smpsepgrp + smpoctgrp + smpnovgrp + smpdecgrp + smpjangrp
      + smpfebgrp + smpmargrp.
*      WRITE : / '**',WA_TAB8-GRP_CODE.
      if wa_tab8-grp_code eq '7777'.
        grpnm = 'BC OTHER'.
      elseif wa_tab8-grp_code eq '8888'.
        grpnm = 'XL OTHER'.
      else.
        grpnm = 'GROUP TOTAL'.
      endif.

      if smptotal eq 0 and grplcum_tot eq 0 and grpltot eq 0 and grpcum_tot eq 0."19.11.2019
      else.

        call function 'WRITE_FORM'
          exporting
            element = 'GRP1'
            window  = 'MAIN'.
      endif.
      grplcum_tot = 0.
      grpcum_tot = 0.
      grpltot = 0.
      laprgrp = 0.
      caprgrp = 0.
      gcumaprgr = 0.
      smpaprgrp = 0.
      ratioaprgrp = 0.

      lmaygrp = 0.
      cmaygrp = 0.
      gcummaygr = 0.
      smpmaygrp = 0.
      ratiomaygrp = 0.

      ljungrp = 0.
      cjungrp = 0.
      gcumjungr = 0.
      smpjungrp = 0.
      ratiojungrp = 0.

      ljulgrp = 0.
      cjulgrp = 0.
      gcumjulgr = 0.
      smpjulgrp = 0.
      ratiojulgrp = 0.

      lauggrp = 0.
      cauggrp = 0.
      gcumauggr = 0.
      smpauggrp = 0.
      ratioauggrp = 0.

      lsepgrp = 0.
      csepgrp = 0.
      gcumsepgr = 0.
      smpsepgrp = 0.
      ratiosepgrp = 0.

      loctgrp = 0.
      coctgrp = 0.
      gcumoctgr = 0.
      smpoctgrp = 0.
      ratiooctgrp = 0.

      lnovgrp = 0.
      cnovgrp = 0.
      gcumnovgr = 0.
      smpnovgrp = 0.
      rationovgrp = 0.

      ldecgrp = 0.
      cdecgrp = 0.
      gcumdecgr = 0.
      smpdecgrp = 0.
      ratiodecgrp = 0.

      ljangrp = 0.
      cjangrp = 0.
      gcumjangr = 0.
      smpjangrp = 0.
      ratiojangrp = 0.

      lfebgrp = 0.
      cfebgrp = 0.
      gcumfebgr = 0.
      smpfebgrp = 0.
      ratiofebgrp = 0.

      lmargrp = 0.
      cmargrp = 0.
      gcummargr = 0.
      smpmargrp = 0.
      ratiomargrp = 0.
    endat.
**************TERRITORY TOTAL****************
    perform ter_total.
    at end of bzirk.

      call function 'WRITE_FORM'
        exporting
          element = 'H3'
          window  = 'MAIN'.

      t1smpaprqty = 0.
      t1smpmayqty = 0.
      t1smpjunqty = 0.
      t1smpjulqty = 0.
      t1smpaugqty = 0.
      t1smpsepqty = 0.
      t1smpoctqty = 0.
      t1smpnovqty = 0.
      t1smpdecqty = 0.
      t1smpjanqty = 0.
      t1smpfebqty = 0.
      t1smpmarqty = 0.

      tlaprqty = 0.
      tcaprqty = 0.
      tsmpaprqty = 0.
      tcumapr = 0.
      trapr = 0.

      tlmayqty = 0.
      tcmayqty = 0.
      tsmpmayqty = 0.
      tcummay = 0.
      trmay = 0.

      tljunqty = 0.
      tcjunqty = 0.
      tsmpjunqty = 0.
      tcumjun = 0.
      trjun = 0.

      tljulqty = 0.
      tcjulqty = 0.
      tsmpjulqty = 0.
      tcumjul = 0.
      trjul = 0.

      tlaugqty = 0.
      tcaugqty = 0.
      tsmpaugqty = 0.
      tcumaug = 0.
      traug = 0.

      tlsepqty = 0.
      tcsepqty = 0.
      tsmpsepqty = 0.
      tcumsep = 0.
      trsep = 0.

      tloctqty = 0.
      tcoctqty = 0.
      tsmpoctqty = 0.
      tcumoct = 0.
      troct = 0.

      tlnovqty = 0.
      tcnovqty = 0.
      tsmpnovqty = 0.
      tcumnov = 0.
      trnov = 0.

      tldecqty = 0.
      tcdecqty = 0.
      tsmpdecqty = 0.
      tcumdec = 0.
      trdec = 0.

      tljanqty = 0.
      tcjanqty = 0.
      tsmpjanqty = 0.
      tcumjan = 0.
      trjan = 0.

      tlfebqty = 0.
      tcfebqty = 0.
      tsmpfebqty = 0.
      tcumfeb = 0.
      trfeb = 0.

      tlmarqty = 0.
      tcmarqty = 0.
      tsmpmarqty = 0.
      tcummar = 0.
      trmar = 0.

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
endform.                    "LAYOUT



*&---------------------------------------------------------------------*
*&      Form  EMAIL_TO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form email_to.
  sort it_tab8 by reg rm bzirk grp_code prn_seq .
  options-tdgetotf = 'X'.
  perform open_form1.
  perform start_form.

  loop at it_tab8 into wa_tab8.
    perform form1.

    at end of grp_code.
      clear : grpnm,smptotal.
      smptotal = smpaprgrp + smpmaygrp + smpjungrp + smpjulgrp + smpauggrp + smpsepgrp + smpoctgrp + smpnovgrp + smpdecgrp + smpjangrp
      + smpfebgrp + smpmargrp.
*      WRITE : / '**',WA_TAB8-GRP_CODE.
      if wa_tab8-grp_code eq '7777'.
        grpnm = 'BC OTHER'.
      elseif wa_tab8-grp_code eq '8888'.
        grpnm = 'XL OTHER'.
      else.
        grpnm = 'GROUP TOTAL'.
      endif.
      if smptotal eq 0 and grplcum_tot eq 0 and grpltot eq 0 and grpcum_tot eq 0."19.11.2019
      else.

        call function 'WRITE_FORM'
          exporting
            element = 'GRP1'
            window  = 'MAIN'.
      endif.

      grplcum_tot = 0.
      grpcum_tot = 0.
      grpltot = 0.
      laprgrp = 0.
      caprgrp = 0.
      gcumaprgr = 0.
      smpaprgrp = 0.
      ratioaprgrp = 0.

      lmaygrp = 0.
      cmaygrp = 0.
      gcummaygr = 0.
      smpmaygrp = 0.
      ratiomaygrp = 0.

      ljungrp = 0.
      cjungrp = 0.
      gcumjungr = 0.
      smpjungrp = 0.
      ratiojungrp = 0.

      ljulgrp = 0.
      cjulgrp = 0.
      gcumjulgr = 0.
      smpjulgrp = 0.
      ratiojulgrp = 0.

      lauggrp = 0.
      cauggrp = 0.
      gcumauggr = 0.
      smpauggrp = 0.
      ratioauggrp = 0.

      lsepgrp = 0.
      csepgrp = 0.
      gcumsepgr = 0.
      smpsepgrp = 0.
      ratiosepgrp = 0.

      loctgrp = 0.
      coctgrp = 0.
      gcumoctgr = 0.
      smpoctgrp = 0.
      ratiooctgrp = 0.

      lnovgrp = 0.
      cnovgrp = 0.
      gcumnovgr = 0.
      smpnovgrp = 0.
      rationovgrp = 0.

      ldecgrp = 0.
      cdecgrp = 0.
      gcumdecgr = 0.
      smpdecgrp = 0.
      ratiodecgrp = 0.

      ljangrp = 0.
      cjangrp = 0.
      gcumjangr = 0.
      smpjangrp = 0.
      ratiojangrp = 0.

      lfebgrp = 0.
      cfebgrp = 0.
      gcumfebgr = 0.
      smpfebgrp = 0.
      ratiofebgrp = 0.

      lmargrp = 0.
      cmargrp = 0.
      gcummargr = 0.
      smpmargrp = 0.
      ratiomargrp = 0.
    endat.
**************TERRITORY TOTAL****************

    perform ter_total.

    at end of bzirk.
      call function 'WRITE_FORM'
        exporting
          element = 'H3'
          window  = 'MAIN'.

      t1smpaprqty = 0.
      t1smpmayqty = 0.
      t1smpjunqty = 0.
      t1smpjulqty = 0.
      t1smpaugqty = 0.
      t1smpsepqty = 0.
      t1smpoctqty = 0.
      t1smpnovqty = 0.
      t1smpdecqty = 0.
      t1smpjanqty = 0.
      t1smpfebqty = 0.
      t1smpmarqty = 0.

      tlaprqty = 0.
      tcaprqty = 0.
      tsmpaprqty = 0.
      tcumapr = 0.
      trapr = 0.

      tlmayqty = 0.
      tcmayqty = 0.
      tsmpmayqty = 0.
      tcummay = 0.
      trmay = 0.

      tljunqty = 0.
      tcjunqty = 0.
      tsmpjunqty = 0.
      tcumjun = 0.
      trjun = 0.

      tljulqty = 0.
      tcjulqty = 0.
      tsmpjulqty = 0.
      tcumjul = 0.
      trjul = 0.

      tlaugqty = 0.
      tcaugqty = 0.
      tsmpaugqty = 0.
      tcumaug = 0.
      traug = 0.

      tlsepqty = 0.
      tcsepqty = 0.
      tsmpsepqty = 0.
      tcumsep = 0.
      trsep = 0.

      tloctqty = 0.
      tcoctqty = 0.
      tsmpoctqty = 0.
      tcumoct = 0.
      troct = 0.

      tlnovqty = 0.
      tcnovqty = 0.
      tsmpnovqty = 0.
      tcumnov = 0.
      trnov = 0.

      tldecqty = 0.
      tcdecqty = 0.
      tsmpdecqty = 0.
      tcumdec = 0.
      trdec = 0.

      tljanqty = 0.
      tcjanqty = 0.
      tsmpjanqty = 0.
      tcumjan = 0.
      trjan = 0.

      tlfebqty = 0.
      tcfebqty = 0.
      tsmpfebqty = 0.
      tcumfeb = 0.
      trfeb = 0.

      tlmarqty = 0.
      tcmarqty = 0.
      tsmpmarqty = 0.
      tcummar = 0.
      trmar = 0.

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

  write updt to wa_d1 dd/mm/yyyy.
*      write s_budat-high to wa_d2 dd/mm/yyyy.

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
  concatenate 'SR-7-P SAMPLE V/S SALE as of ' wa_d1 into doc_chng-obj_descr separated by space.
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

  concatenate 'SR-7P' '.' into objpack-obj_descr separated by space.
  objpack-doc_size = righe_attachment * 255.
  append objpack.
  clear objpack.

*    loop at it_tar2 into wa_tar2 where bzirk = wa_tar1-bzirk.
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





endform.                    "EMAIL_TO
*&---------------------------------------------------------------------*
*&      Form  SAMP_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form samp_data.

  if it_tab5 is not initial.
    if caprdt le supdt.
      select * from zsampdata into table it_zsampdata_apr
*****        for all entries in it_tab5
        where zmonth eq caprdt+4(2)
        and   zyear eq caprdt+0(4).
*****        and bzirk eq it_tab5-bzirk .
      if sy-subrc = 0.
        sort it_zsampdata_apr by bzirk.
      endif.
    endif.

    if cmaydt le supdt.
      select * from zsampdata into table it_zsampdata_may
*****        for all entries in it_tab5
        where zmonth eq cmaydt+4(2)
        and   zyear eq cmaydt+0(4).
*****        and bzirk eq it_tab5-bzirk .
      if sy-subrc = 0.
        sort it_zsampdata_may[] by bzirk.
      endif.
    endif.

    if cjundt le supdt.
      select * from zsampdata into table it_zsampdata_jun
*****        for all entries in it_tab5
        where zmonth eq cjundt+4(2)
        and   zyear eq cjundt+0(4) .
*****        and bzirk eq it_tab5-bzirk .
      if sy-subrc = 0.
        sort it_zsampdata_jun by bzirk.
      endif.
    endif.

    if cjuldt le supdt.
      select * from zsampdata into table it_zsampdata_jul
*****        for all entries in it_tab5
        where zmonth eq cjuldt+4(2)
        and        zyear eq cjuldt+0(4).
*****        and bzirk eq it_tab5-bzirk .
      if sy-subrc = 0.
        sort it_zsampdata_jul by bzirk.
      endif.
    endif.

    if caugdt le supdt.
      select * from zsampdata into table it_zsampdata_aug
*****        for all entries in it_tab5
        where zmonth eq caugdt+4(2)
         and        zyear eq caugdt+0(4).
*****        and bzirk eq it_tab5-bzirk .
      if sy-subrc = 0.
        sort it_zsampdata_aug by bzirk.
      endif.
    endif.

    if csepdt le supdt.
      select * from zsampdata into table it_zsampdata_sep
*****        for all entries in it_tab5
        where zmonth eq csepdt+4(2)
        and        zyear eq csepdt+0(4) .
*****        and bzirk eq it_tab5-bzirk .
      if sy-subrc = 0.
        sort it_zsampdata_sep by bzirk.
      endif.
    endif.

    if coctdt le supdt.
      select * from zsampdata into table it_zsampdata_oct
*****        for all entries in it_tab5
        where zmonth eq coctdt+4(2)
        and  zyear eq coctdt+0(4) .
*****        and bzirk eq it_tab5-bzirk .
      if sy-subrc = 0.
        sort it_zsampdata_oct by bzirk.
      endif.
    endif.

    if cnovdt le supdt.
      select * from zsampdata into table it_zsampdata_nov
*****        for all entries in it_tab5
        where zmonth eq cnovdt+4(2)
        and        zyear eq cnovdt+0(4) .
*****        and  bzirk eq it_tab5-bzirk .
      if sy-subrc = 0.
        sort it_zsampdata_nov by bzirk.
      endif.
    endif.

    if cdecdt le supdt.
      select * from zsampdata into table it_zsampdata_dec
*****        for all entries in it_tab5
        where zmonth eq cdecdt+4(2)
        and zyear eq cdecdt+0(4) .
*****        and bzirk eq it_tab5-bzirk .
      if sy-subrc = 0.
        sort it_zsampdata_dec by bzirk.
      endif.
    endif.

    if cjandt le supdt.
      select * from zsampdata into table it_zsampdata_jan
*****        for all entries in it_tab5
        where zmonth eq cjandt+4(2)
        and  zyear eq cjandt+0(4) .
*****        and bzirk eq it_tab5-bzirk .
      if sy-subrc = 0.
        sort it_zsampdata_jan by bzirk.
      endif.
    endif.

    if cfebdt le supdt.
      select * from zsampdata into table it_zsampdata_feb
*****        for all entries in it_tab5
        where zmonth eq cfebdt+4(2)
        and  zyear eq cfebdt+0(4) .
*****        and bzirk eq it_tab5-bzirk.
      if sy-subrc = 0.
        sort it_zsampdata_feb by bzirk.
      endif.
    endif.

    select * from zsampdata into table it_zsampdata_mar
*****      for all entries in it_tab5
      where zmonth eq '03'
      and  zyear eq nyear .
*****      and bzirk eq it_tab5-bzirk .
    if sy-subrc = 0.
      sort it_zsampdata_mar by bzirk.
    endif.
  endif.

  loop at it_zsampdata_apr into wa_zsampdata_apr.
    read table it_tab5 into wa_tab5 with key bzirk = wa_zsampdata_apr-bzirk BINARY SEARCH.
    if sy-subrc eq 0.
      wa_samp1-reg = wa_tab5-reg.
      wa_samp1-rm = wa_tab5-rm.
      wa_samp1-pernr = wa_tab5-pernr.
      wa_samp1-ename = wa_tab5-ename.
      wa_samp1-bzirk = wa_zsampdata_apr-bzirk.
      wa_samp1-matnr = wa_zsampdata_apr-matnr.
      wa_samp1-aprqty = wa_zsampdata_apr-qty.
      collect wa_samp1 into it_samp1.
      clear wa_samp1.
    endif.
  endloop.

  loop at it_zsampdata_may into wa_zsampdata_may.
    read table it_tab5 into wa_tab5 with key bzirk = wa_zsampdata_may-bzirk BINARY SEARCH.
    if sy-subrc eq 0.
      wa_samp1-reg = wa_tab5-reg.
      wa_samp1-rm = wa_tab5-rm.
      wa_samp1-pernr = wa_tab5-pernr.
      wa_samp1-ename = wa_tab5-ename.
      wa_samp1-bzirk = wa_zsampdata_may-bzirk.
      wa_samp1-matnr = wa_zsampdata_may-matnr.
      wa_samp1-mayqty = wa_zsampdata_may-qty.
      collect wa_samp1 into it_samp1.
      clear wa_samp1.
    endif.
  endloop.

  loop at it_zsampdata_jun into wa_zsampdata_jun.
    read table it_tab5 into wa_tab5 with key bzirk = wa_zsampdata_jun-bzirk BINARY SEARCH.
    if sy-subrc eq 0.
      wa_samp1-reg = wa_tab5-reg.
      wa_samp1-rm = wa_tab5-rm.
      wa_samp1-pernr = wa_tab5-pernr.
      wa_samp1-ename = wa_tab5-ename.
      wa_samp1-bzirk = wa_zsampdata_jun-bzirk.
      wa_samp1-matnr = wa_zsampdata_jun-matnr.
      wa_samp1-junqty = wa_zsampdata_jun-qty.
      collect wa_samp1 into it_samp1.
      clear wa_samp1.
    endif.
  endloop.

  loop at it_zsampdata_jul into wa_zsampdata_jul.
    read table it_tab5 into wa_tab5 with key bzirk = wa_zsampdata_jul-bzirk binary search.
    if sy-subrc eq 0.
      wa_samp1-reg = wa_tab5-reg.
      wa_samp1-rm = wa_tab5-rm.
      wa_samp1-pernr = wa_tab5-pernr.
      wa_samp1-ename = wa_tab5-ename.
      wa_samp1-bzirk = wa_zsampdata_jul-bzirk.
      wa_samp1-matnr = wa_zsampdata_jul-matnr.
      wa_samp1-julqty = wa_zsampdata_jul-qty.
      collect wa_samp1 into it_samp1.
      clear wa_samp1.
    endif.
  endloop.

  loop at it_zsampdata_aug into wa_zsampdata_aug.
    read table it_tab5 into wa_tab5 with key bzirk = wa_zsampdata_aug-bzirk binary search.
    if sy-subrc eq 0.
      wa_samp1-reg = wa_tab5-reg.
      wa_samp1-rm = wa_tab5-rm.
      wa_samp1-pernr = wa_tab5-pernr.
      wa_samp1-ename = wa_tab5-ename.
      wa_samp1-bzirk = wa_zsampdata_aug-bzirk.
      wa_samp1-matnr = wa_zsampdata_aug-matnr.
      wa_samp1-augqty = wa_zsampdata_aug-qty.
      collect wa_samp1 into it_samp1.
      clear wa_samp1.
    endif.
  endloop.

  loop at it_zsampdata_sep into wa_zsampdata_sep.
    read table it_tab5 into wa_tab5 with key bzirk = wa_zsampdata_sep-bzirk binary search.
    if sy-subrc eq 0.
      wa_samp1-reg = wa_tab5-reg.
      wa_samp1-rm = wa_tab5-rm.
      wa_samp1-pernr = wa_tab5-pernr.
      wa_samp1-ename = wa_tab5-ename.
      wa_samp1-bzirk = wa_zsampdata_sep-bzirk.
      wa_samp1-matnr = wa_zsampdata_sep-matnr.
      wa_samp1-sepqty = wa_zsampdata_sep-qty.
      collect wa_samp1 into it_samp1.
      clear wa_samp1.
    endif.
  endloop.

  loop at it_zsampdata_oct into wa_zsampdata_oct.
    read table it_tab5 into wa_tab5 with key bzirk = wa_zsampdata_oct-bzirk binary search.
    if sy-subrc eq 0.
      wa_samp1-reg = wa_tab5-reg.
      wa_samp1-rm = wa_tab5-rm.
      wa_samp1-pernr = wa_tab5-pernr.
      wa_samp1-ename = wa_tab5-ename.
      wa_samp1-bzirk = wa_zsampdata_oct-bzirk.
      wa_samp1-matnr = wa_zsampdata_oct-matnr.
      wa_samp1-octqty = wa_zsampdata_oct-qty.
      collect wa_samp1 into it_samp1.
      clear wa_samp1.
    endif.
  endloop.

  loop at it_zsampdata_nov into wa_zsampdata_nov.
    read table it_tab5 into wa_tab5 with key bzirk = wa_zsampdata_nov-bzirk binary search.
    if sy-subrc eq 0.
      wa_samp1-reg = wa_tab5-reg.
      wa_samp1-rm = wa_tab5-rm.
      wa_samp1-pernr = wa_tab5-pernr.
      wa_samp1-ename = wa_tab5-ename.
      wa_samp1-bzirk = wa_zsampdata_nov-bzirk.
      wa_samp1-matnr = wa_zsampdata_nov-matnr.
      wa_samp1-novqty = wa_zsampdata_nov-qty.
      collect wa_samp1 into it_samp1.
      clear wa_samp1.
    endif.
  endloop.

  loop at it_zsampdata_dec into wa_zsampdata_dec.
    read table it_tab5 into wa_tab5 with key bzirk = wa_zsampdata_dec-bzirk binary search.
    if sy-subrc eq 0.
      wa_samp1-reg = wa_tab5-reg.
      wa_samp1-rm = wa_tab5-rm.
      wa_samp1-pernr = wa_tab5-pernr.
      wa_samp1-ename = wa_tab5-ename.
      wa_samp1-bzirk = wa_zsampdata_dec-bzirk.
      wa_samp1-matnr = wa_zsampdata_dec-matnr.
      wa_samp1-decqty = wa_zsampdata_dec-qty.
      collect wa_samp1 into it_samp1.
      clear wa_samp1.
    endif.
  endloop.

  loop at it_zsampdata_jan into wa_zsampdata_jan.
    read table it_tab5 into wa_tab5 with key bzirk = wa_zsampdata_jan-bzirk binary search.
    if sy-subrc eq 0.
      wa_samp1-reg = wa_tab5-reg.
      wa_samp1-rm = wa_tab5-rm.
      wa_samp1-pernr = wa_tab5-pernr.
      wa_samp1-ename = wa_tab5-ename.
      wa_samp1-bzirk = wa_zsampdata_jan-bzirk.
      wa_samp1-matnr = wa_zsampdata_jan-matnr.
      wa_samp1-janqty = wa_zsampdata_jan-qty.
      collect wa_samp1 into it_samp1.
      clear wa_samp1.
    endif.
  endloop.

  loop at it_zsampdata_feb into wa_zsampdata_feb.
    read table it_tab5 into wa_tab5 with key bzirk = wa_zsampdata_feb-bzirk binary search.
    if sy-subrc eq 0.
      wa_samp1-reg = wa_tab5-reg.
      wa_samp1-rm = wa_tab5-rm.
      wa_samp1-pernr = wa_tab5-pernr.
      wa_samp1-ename = wa_tab5-ename.
      wa_samp1-bzirk = wa_zsampdata_feb-bzirk.
      wa_samp1-matnr = wa_zsampdata_feb-matnr.
      wa_samp1-febqty = wa_zsampdata_feb-qty.
      collect wa_samp1 into it_samp1.
      clear wa_samp1.
    endif.
  endloop.

  loop at it_zsampdata_mar into wa_zsampdata_mar.
    read table it_tab5 into wa_tab5 with key bzirk = wa_zsampdata_mar-bzirk binary search.
    if sy-subrc eq 0.
      wa_samp1-reg = wa_tab5-reg.
      wa_samp1-rm = wa_tab5-rm.
      wa_samp1-pernr = wa_tab5-pernr.
      wa_samp1-ename = wa_tab5-ename.
      wa_samp1-bzirk = wa_zsampdata_mar-bzirk.
      wa_samp1-matnr = wa_zsampdata_mar-matnr.
      wa_samp1-marqty = wa_zsampdata_mar-qty.
      collect wa_samp1 into it_samp1.
      clear wa_samp1.
    endif.
  endloop.

endform.                    "SAMP_DATA
*&---------------------------------------------------------------------*
*&      Form  CUMM_GR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form cumm_gr.

  loop at it_tas1 into wa_tas1.

    wa_tas3-reg = wa_tas1-reg.
    wa_tas3-rm = wa_tas1-rm.
    wa_tas3-pernr = wa_tas1-pernr.
    wa_tas3-ename = wa_tas1-ename.
    wa_tas3-bzirk = wa_tas1-bzirk.
    wa_tas3-matnr = wa_tas1-matnr.
    wa_tas3-laprqty = wa_tas1-aprqty.
    wa_tas3-lmayqty = wa_tas1-mayqty.
    wa_tas3-ljunqty = wa_tas1-junqty.
    wa_tas3-ljulqty = wa_tas1-julqty.
    wa_tas3-laugqty = wa_tas1-augqty.
    wa_tas3-lsepqty = wa_tas1-sepqty.
    wa_tas3-loctqty = wa_tas1-octqty.
    wa_tas3-lnovqty = wa_tas1-novqty.
    wa_tas3-ldecqty = wa_tas1-decqty.
    wa_tas3-ljanqty = wa_tas1-janqty.
    wa_tas3-lfebqty = wa_tas1-febqty.
    wa_tas3-lmarqty = wa_tas1-marqty.
    wa_tas3-laprpts = wa_tas1-aprpts.
    wa_tas3-lmaypts = wa_tas1-maypts.
    wa_tas3-ljunpts = wa_tas1-junpts.
    wa_tas3-ljulpts = wa_tas1-julpts.
    wa_tas3-laugpts = wa_tas1-augpts.
    wa_tas3-lseppts = wa_tas1-seppts.
    wa_tas3-loctpts = wa_tas1-octpts.
    wa_tas3-lnovpts = wa_tas1-novpts.
    wa_tas3-ldecpts = wa_tas1-decpts.
    wa_tas3-ljanpts = wa_tas1-janpts.
    wa_tas3-lfebpts = wa_tas1-febpts.
    wa_tas3-lmarpts = wa_tas1-marpts.
    collect wa_tas3 into it_tas3.
    clear wa_tas3.
  endloop.

  loop at it_tas2 into wa_tas2.

    wa_tas3-reg = wa_tas2-reg.
    wa_tas3-rm = wa_tas2-rm.
    wa_tas3-pernr = wa_tas2-pernr.
    wa_tas3-ename = wa_tas2-ename.
    wa_tas3-bzirk = wa_tas2-bzirk.
    wa_tas3-matnr = wa_tas2-matnr.
    wa_tas3-caprqty = wa_tas2-aprqty.
    wa_tas3-cmayqty = wa_tas2-mayqty.
    wa_tas3-cjunqty = wa_tas2-junqty.
    wa_tas3-cjulqty = wa_tas2-julqty.
    wa_tas3-caugqty = wa_tas2-augqty.
    wa_tas3-csepqty = wa_tas2-sepqty.
    wa_tas3-coctqty = wa_tas2-octqty.
    wa_tas3-cnovqty = wa_tas2-novqty.
    wa_tas3-cdecqty = wa_tas2-decqty.
    wa_tas3-cjanqty = wa_tas2-janqty.
    wa_tas3-cfebqty = wa_tas2-febqty.
    wa_tas3-cmarqty = wa_tas2-marqty.
    wa_tas3-caprpts = wa_tas2-aprpts.
    wa_tas3-cmaypts = wa_tas2-maypts.
    wa_tas3-cjunpts = wa_tas2-junpts.
    wa_tas3-cjulpts = wa_tas2-julpts.
    wa_tas3-caugpts = wa_tas2-augpts.
    wa_tas3-cseppts = wa_tas2-seppts.
    wa_tas3-coctpts = wa_tas2-octpts.
    wa_tas3-cnovpts = wa_tas2-novpts.
    wa_tas3-cdecpts = wa_tas2-decpts.
    wa_tas3-cjanpts = wa_tas2-janpts.
    wa_tas3-cfebpts = wa_tas2-febpts.
    wa_tas3-cmarpts = wa_tas2-marpts.
    collect wa_tas3 into it_tas3.
    clear wa_tas3.

  endloop.
  sort it_tas3 by reg rm bzirk matnr.
  loop at it_tas3 into wa_tas3.
    clear : aprgr,maygr,jungr,julgr,auggr,sepgr,octgr,novgr,decgr,jangr,febgr,margr.
    clear : cumcmay,cumcjun,cumcjul,cumcaug,cumcsep,cumcoct,cumcnov,cumcdec,cumcjan,cumcfeb,cumcmar.
    clear : cumlmay,cumljun,cumljul,cumlaug,cumlsep,cumloct,cumlnov,cumldec,cumljan,cumlfeb,cumlmar.

    wa_tas4-reg = wa_tas3-reg.
    wa_tas4-rm = wa_tas3-rm.
    wa_tas4-bzirk = wa_tas3-bzirk.
    wa_tas4-matnr = wa_tas3-matnr.
    wa_tas4-pernr = wa_tas3-pernr.

    wa_tas4-laprqty = wa_tas3-laprqty.
    wa_tas4-lmayqty = wa_tas3-lmayqty.
    wa_tas4-ljunqty = wa_tas3-ljunqty.
    wa_tas4-ljulqty = wa_tas3-ljulqty.
    wa_tas4-laugqty = wa_tas3-laugqty.
    wa_tas4-lsepqty = wa_tas3-lsepqty.
    wa_tas4-loctqty = wa_tas3-loctqty.
    wa_tas4-lnovqty = wa_tas3-lnovqty.
    wa_tas4-ldecqty = wa_tas3-ldecqty.
    wa_tas4-ljanqty = wa_tas3-ljanqty.
    wa_tas4-lfebqty = wa_tas3-lfebqty.
    wa_tas4-lmarqty = wa_tas3-lmarqty.

    wa_tas4-caprqty = wa_tas3-caprqty.
    wa_tas4-cmayqty = wa_tas3-cmayqty.
    wa_tas4-cjunqty = wa_tas3-cjunqty.
    wa_tas4-cjulqty = wa_tas3-cjulqty.
    wa_tas4-caugqty = wa_tas3-caugqty.
    wa_tas4-csepqty = wa_tas3-csepqty.
    wa_tas4-coctqty = wa_tas3-coctqty.
    wa_tas4-cnovqty = wa_tas3-cnovqty.
    wa_tas4-cdecqty = wa_tas3-cdecqty.
    wa_tas4-cjanqty = wa_tas3-cjanqty.
    wa_tas4-cfebqty = wa_tas3-cfebqty.
    wa_tas4-cmarqty = wa_tas3-cmarqty.
    wa_tas4-laprpts = wa_tas3-laprpts.
    wa_tas4-lmaypts = wa_tas3-lmaypts.
    wa_tas4-ljunpts = wa_tas3-ljunpts.
    wa_tas4-ljulpts = wa_tas3-ljulpts.
    wa_tas4-laugpts = wa_tas3-laugpts.
    wa_tas4-lseppts = wa_tas3-lseppts.
    wa_tas4-loctpts = wa_tas3-loctpts.
    wa_tas4-lnovpts = wa_tas3-lnovpts.
    wa_tas4-ldecpts = wa_tas3-ldecpts.
    wa_tas4-ljanpts = wa_tas3-ljanpts.
    wa_tas4-lfebpts = wa_tas3-lfebpts.
    wa_tas4-lmarpts = wa_tas3-lmarpts.

    wa_tas4-caprpts = wa_tas3-caprpts.
    wa_tas4-cmaypts = wa_tas3-cmaypts.
    wa_tas4-cjunpts = wa_tas3-cjunpts.
    wa_tas4-cjulpts = wa_tas3-cjulpts.
    wa_tas4-caugpts = wa_tas3-caugpts.
    wa_tas4-cseppts = wa_tas3-cseppts.
    wa_tas4-coctpts = wa_tas3-coctpts.
    wa_tas4-cnovpts = wa_tas3-cnovpts.
    wa_tas4-cdecpts = wa_tas3-cdecpts.
    wa_tas4-cjanpts = wa_tas3-cjanpts.
    wa_tas4-cfebpts = wa_tas3-cfebpts.
    wa_tas4-cmarpts = wa_tas3-cmarpts.
    collect wa_tas4 into it_tas4.
    clear wa_tas4.
  endloop.
endform.                    "CUMM_GR

*&---------------------------------------------------------------------*
*&      Form  TOP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form top.

  data: comment    type slis_t_listheader,
        wa_comment like line of comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'PSO SALE QUANTITY DETAILS'.
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
*&      Form  PYEAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form pyear.
  if it_tab5 is not initial.
    sort it_tab5 by bzirk matnr.
    clear it_zrpqv_lapr[].
    select * from zrpqv into table it_zrpqv_lapr
*****      for all entries in it_tab5
      where zmonth eq '04'
      and zyear eq lyear.
*****      and bzirk eq it_tab5-bzirk.
    if sy-subrc = 0.
      sort it_zrpqv_lapr by bzirk matnr.
    endif.


    clear it_zrpqv_lmay[].
    select * from zrpqv into table it_zrpqv_lmay
*****      for all entries in it_tab5
      where zmonth eq '05'
      and zyear eq lyear.
*****      and bzirk eq it_tab5-bzirk.
    if sy-subrc = 0.
      sort it_zrpqv_lmay by bzirk matnr.
    endif.


    clear it_zrpqv_ljun[].
    select * from zrpqv into table it_zrpqv_ljun
*****      for all entries in it_tab5
      where zmonth eq '06'
      and zyear eq lyear.
*****      and bzirk eq it_tab5-bzirk.
    if sy-subrc = 0.
      sort it_zrpqv_ljun by bzirk matnr.
    endif.


    clear it_zrpqv_ljul[].
    select * from zrpqv into table it_zrpqv_ljul
*****      for all entries in it_tab5
      where zmonth eq '07'
      and zyear eq lyear.
*****      and bzirk eq it_tab5-bzirk.
    if sy-subrc = 0.
      sort it_zrpqv_ljul by bzirk matnr.
    endif.


    clear it_zrpqv_laug[].
    select * from zrpqv into table it_zrpqv_laug
*****      for all entries in it_tab5
      where zmonth eq '08'
      and zyear eq lyear.
*****      and bzirk eq it_tab5-bzirk.
    if sy-subrc = 0.
      sort it_zrpqv_laug by bzirk matnr.
    endif.


    clear it_zrpqv_lsep[].
    select * from zrpqv into table it_zrpqv_lsep
*****      for all entries in it_tab5
      where zmonth eq '09'
      and zyear eq lyear.
*****      and bzirk eq it_tab5-bzirk.
    if sy-subrc = 0.
      sort it_zrpqv_lsep by bzirk matnr.
    endif.


    clear it_zrpqv_loct[].
    select * from zrpqv into table it_zrpqv_loct
*****      for all entries in it_tab5
      where zmonth eq '10'
      and zyear eq lyear.
*****      and bzirk eq it_tab5-bzirk.
    if sy-subrc = 0.
      sort it_zrpqv_loct by bzirk matnr.
    endif.


    clear it_zrpqv_lnov[].
    select * from zrpqv into table it_zrpqv_lnov
*****      for all entries in it_tab5
      where zmonth eq '11'
      and zyear eq lyear.
*****      and bzirk eq it_tab5-bzirk.
    if sy-subrc = 0.
      sort it_zrpqv_lnov by bzirk matnr.
    endif.


    clear it_zrpqv_ldec[].
    select * from zrpqv into table it_zrpqv_ldec
*****      for all entries in it_tab5
      where zmonth eq '12'
      and zyear eq lyear.
*****      and bzirk eq it_tab5-bzirk.
    if sy-subrc = 0.
      sort it_zrpqv_ldec by bzirk matnr.
    endif.

    clear it_zrpqv_ljan[].
    select * from zrpqv into table it_zrpqv_ljan
*****      for all entries in it_tab5
      where zmonth eq '01'
      and zyear eq cyear.
*****      and bzirk eq it_tab5-bzirk.
    if sy-subrc = 0.
      sort it_zrpqv_ljan by bzirk matnr.
    endif.

    clear it_zrpqv_lfeb[].
    select * from zrpqv into table it_zrpqv_lfeb
*****       for all entries in it_tab5
      where zmonth eq '02'
      and zyear eq cyear.
*****      and bzirk eq it_tab5-bzirk.
    if sy-subrc = 0.
      sort it_zrpqv_lfeb by bzirk matnr.
    endif.

    clear it_zrpqv_lmar[].
    select * from zrpqv into table it_zrpqv_lmar
*****      for all entries in it_tab5
      where zmonth eq '03'
      and zyear eq cyear.
*****      and bzirk eq it_tab5-bzirk.
    if sy-subrc = 0.
      sort it_zrpqv_lmar by bzirk matnr.
    endif.
  endif.

  loop at it_tab5 into wa_tab5.
    wa_tas1-reg = wa_tab5-reg.
    wa_tas1-rm = wa_tab5-rm.
    wa_tas1-pernr = wa_tab5-pernr.
    wa_tas1-ename = wa_tab5-ename.
    wa_tas1-bzirk = wa_tab5-bzirk.
    wa_tas1-matnr = wa_tab5-matnr.
    read table it_zrpqv_lapr into wa_zrpqv_lapr with key bzirk = wa_tab5-bzirk matnr = wa_tab5-matnr binary search.
    if sy-subrc eq 0.
      wa_tas1-aprqty = wa_zrpqv_lapr-grossqty + wa_zrpqv_lapr-nepqty.
      wa_tas1-aprpts = wa_zrpqv_lapr-grosspts.
    endif.
    read table it_zrpqv_lmay into wa_zrpqv_lmay with key bzirk = wa_tab5-bzirk matnr = wa_tab5-matnr binary search.
    if sy-subrc eq 0.
      wa_tas1-mayqty = wa_zrpqv_lmay-grossqty + wa_zrpqv_lmay-nepqty.
      wa_tas1-maypts = wa_zrpqv_lmay-grosspts.
    endif.
    read table it_zrpqv_ljun into wa_zrpqv_ljun with key bzirk = wa_tab5-bzirk matnr = wa_tab5-matnr binary search.
    if sy-subrc eq 0.
      wa_tas1-junqty = wa_zrpqv_ljun-grossqty + wa_zrpqv_ljun-nepqty.
      wa_tas1-junpts = wa_zrpqv_ljun-grosspts.
    endif.
    read table it_zrpqv_ljul into wa_zrpqv_ljul with key bzirk = wa_tab5-bzirk matnr = wa_tab5-matnr binary search.
    if sy-subrc eq 0.
      wa_tas1-julqty = wa_zrpqv_ljul-grossqty + wa_zrpqv_ljul-nepqty.
      wa_tas1-julpts = wa_zrpqv_ljul-grosspts.
    endif.
    read table it_zrpqv_laug into wa_zrpqv_laug with key bzirk = wa_tab5-bzirk matnr = wa_tab5-matnr binary search.
    if sy-subrc eq 0.
      wa_tas1-augqty = wa_zrpqv_laug-grossqty + wa_zrpqv_laug-nepqty.
      wa_tas1-augpts = wa_zrpqv_laug-grosspts.
    endif.
    read table it_zrpqv_lsep into wa_zrpqv_lsep with key bzirk = wa_tab5-bzirk matnr = wa_tab5-matnr binary search.
    if sy-subrc eq 0.
      wa_tas1-sepqty = wa_zrpqv_lsep-grossqty + wa_zrpqv_lsep-nepqty.
      wa_tas1-seppts = wa_zrpqv_lsep-grosspts.
    endif.
    read table it_zrpqv_loct into wa_zrpqv_loct with key bzirk = wa_tab5-bzirk matnr = wa_tab5-matnr binary search.
    if sy-subrc eq 0.
      wa_tas1-octqty = wa_zrpqv_loct-grossqty + wa_zrpqv_loct-nepqty.
      wa_tas1-octpts = wa_zrpqv_loct-grosspts.
    endif.
    read table it_zrpqv_lnov into wa_zrpqv_lnov with key bzirk = wa_tab5-bzirk matnr = wa_tab5-matnr binary search.
    if sy-subrc eq 0.
      wa_tas1-novqty = wa_zrpqv_lnov-grossqty + wa_zrpqv_lnov-nepqty.
      wa_tas1-novpts = wa_zrpqv_lnov-grosspts.
    endif.
    read table it_zrpqv_ldec into wa_zrpqv_ldec with key bzirk = wa_tab5-bzirk matnr = wa_tab5-matnr binary search.
    if sy-subrc eq 0.
      wa_tas1-decqty = wa_zrpqv_ldec-grossqty + wa_zrpqv_ldec-nepqty.
      wa_tas1-decpts = wa_zrpqv_ldec-grosspts.
    endif.
    read table it_zrpqv_ljan into wa_zrpqv_ljan with key bzirk = wa_tab5-bzirk matnr = wa_tab5-matnr binary search.
    if sy-subrc eq 0.
      wa_tas1-janqty = wa_zrpqv_ljan-grossqty + wa_zrpqv_ljan-nepqty.
      wa_tas1-janpts = wa_zrpqv_ljan-grosspts.
    endif.
    read table it_zrpqv_lfeb into wa_zrpqv_lfeb with key bzirk = wa_tab5-bzirk matnr = wa_tab5-matnr binary search.
    if sy-subrc eq 0.
      wa_tas1-febqty = wa_zrpqv_lfeb-grossqty + wa_zrpqv_lfeb-nepqty.
      wa_tas1-febpts = wa_zrpqv_lfeb-grosspts.
    endif.
    read table it_zrpqv_lmar into wa_zrpqv_lmar with key bzirk = wa_tab5-bzirk matnr = wa_tab5-matnr binary search.
    if sy-subrc eq 0.
      wa_tas1-marqty = wa_zrpqv_lmar-grossqty + wa_zrpqv_lmar-nepqty.
      wa_tas1-marpts = wa_zrpqv_lmar-grosspts.
    endif.
    collect wa_tas1 into it_tas1.
    clear wa_tas1.
  endloop.
endform.                    "PYEAR

*&---------------------------------------------------------------------*
*&      Form  CYEAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form cyear.
  if it_tab5 is not initial.
    sort it_tab5 by bzirk matnr.
    if caprdt le updt.
      select * from zrpqv into table it_zrpqv_capr
*****        for all entries in it_tab5
        where zmonth eq caprdt+4(2)
        and zyear eq caprdt+0(4).
*****        and bzirk eq it_tab5-bzirk.
      if sy-subrc = 0.
        sort it_zrpqv_capr by bzirk matnr.
      endif.
    endif.

    if cmaydt le updt.
      select * from zrpqv into table it_zrpqv_cmay
*****        for all entries in it_tab5
        where zmonth eq cmaydt+4(2)
        and zyear eq cmaydt+0(4).
*****        and bzirk eq it_tab5-bzirk.
      if sy-subrc = 0.
        sort it_zrpqv_cmay by bzirk matnr.
      endif.
    endif.


    if cjundt le updt.
      select * from zrpqv into table it_zrpqv_cjun
*****        for all entries in it_tab5
        where zmonth eq cjundt+4(2)
        and zyear eq cjundt+0(4).
*****        and bzirk eq it_tab5-bzirk.
      if sy-subrc = 0.
        sort it_zrpqv_cjun by bzirk matnr.
      endif.
    endif.


    if cjuldt le updt.
      select * from zrpqv into table it_zrpqv_cjul
*****        for all entries in it_tab5
        where zmonth eq cjuldt+4(2)
        and zyear eq cjuldt+0(4).
*****        and bzirk eq it_tab5-bzirk.
      if sy-subrc = 0.
        sort it_zrpqv_cjul by bzirk matnr.
      endif.
    endif.


    if caugdt le updt.
      select * from zrpqv into table it_zrpqv_caug
*****        for all entries in it_tab5
        where zmonth eq caugdt+4(2)
        and zyear eq caugdt+0(4) .
*****        and bzirk eq it_tab5-bzirk.
      if sy-subrc = 0.
        sort it_zrpqv_caug by bzirk matnr.
      endif.
    endif.


    if csepdt le updt.
      select * from zrpqv into table it_zrpqv_csep
*****        for all entries in it_tab5
        where zmonth eq csepdt+4(2)
        and zyear eq csepdt+0(4) .
*****        and bzirk eq it_tab5-bzirk.
      if sy-subrc = 0.
        sort it_zrpqv_csep by bzirk matnr.
      endif.
    endif.


    if coctdt le updt.
      select * from zrpqv into table it_zrpqv_coct
*****        for all entries in it_tab5
        where zmonth eq coctdt+4(2)
        and zyear eq coctdt+0(4) .
*****        and bzirk eq it_tab5-bzirk.
      if sy-subrc = 0.
        sort it_zrpqv_coct by bzirk matnr.
      endif.
    endif.


    if cnovdt le updt.
      select * from zrpqv into table it_zrpqv_cnov
*****        for all entries in it_tab5
        where zmonth eq cnovdt+4(2)
        and zyear eq cnovdt+0(4) .
*****        and bzirk eq it_tab5-bzirk.
      if sy-subrc = 0.
        sort it_zrpqv_cnov by bzirk matnr.
      endif.
    endif.


    if cdecdt le updt.
      select * from zrpqv into table it_zrpqv_cdec
*****        for all entries in it_tab5
        where zmonth eq cdecdt+4(2)
        and zyear eq cdecdt+0(4) .
*****        and bzirk eq it_tab5-bzirk.
      if sy-subrc = 0.
        sort it_zrpqv_cdec by bzirk matnr.
      endif.
    endif.


    if cjandt le updt.
      select * from zrpqv into table it_zrpqv_cjan
*****        for all entries in it_tab5
        where zmonth eq  cjandt+4(2)
        and zyear eq cjandt+0(4) .
*****        and bzirk eq it_tab5-bzirk.
      if sy-subrc = 0.
        sort it_zrpqv_cjan by bzirk matnr.
      endif.
    endif.


    if cfebdt le updt.
      select * from zrpqv into table it_zrpqv_cfeb
*****        for all entries in it_tab5
        where zmonth eq cfebdt+4(2)
        and zyear eq cfebdt+0(4) .
*****        and bzirk eq it_tab5-bzirk.
      if sy-subrc = 0.
        sort it_zrpqv_cfeb by bzirk matnr.
      endif.
    endif.


    if cmardt le updt.
      select * from zrpqv into table it_zrpqv_cmar
*****        for all entries in it_tab5
        where zmonth eq cmardt+4(2)
        and zyear eq cmardt+0(4) .
*****        and bzirk eq it_tab5-bzirk.
      if sy-subrc = 0.
        sort it_zrpqv_cmar by bzirk matnr.
      endif.
    endif.
  endif.

  loop at it_tab5 into wa_tab5.
    wa_tas2-reg = wa_tab5-reg.
    wa_tas2-rm = wa_tab5-rm.
    wa_tas2-pernr = wa_tab5-pernr.
    wa_tas2-ename = wa_tab5-ename.
    wa_tas2-bzirk = wa_tab5-bzirk.
    wa_tas2-matnr = wa_tab5-matnr.
    read table it_zrpqv_capr into wa_zrpqv_capr with key bzirk = wa_tab5-bzirk matnr = wa_tab5-matnr binary search .
    if sy-subrc eq 0.
      wa_tas2-aprqty = wa_zrpqv_capr-grossqty + wa_zrpqv_capr-nepqty.
      wa_tas2-aprpts = wa_zrpqv_capr-grosspts.
    endif.
    read table it_zrpqv_cmay into wa_zrpqv_cmay with key bzirk = wa_tab5-bzirk matnr = wa_tab5-matnr binary search .
    if sy-subrc eq 0.
      wa_tas2-mayqty = wa_zrpqv_cmay-grossqty + wa_zrpqv_cmay-nepqty.
      wa_tas2-maypts = wa_zrpqv_cmay-grosspts.
    endif.
    read table it_zrpqv_cjun into wa_zrpqv_cjun with key bzirk = wa_tab5-bzirk matnr = wa_tab5-matnr binary search.
    if sy-subrc eq 0.
      wa_tas2-junqty = wa_zrpqv_cjun-grossqty + wa_zrpqv_cjun-nepqty.
      wa_tas2-junpts = wa_zrpqv_cjun-grosspts.
    endif.
    read table it_zrpqv_cjul into wa_zrpqv_cjul with key bzirk = wa_tab5-bzirk matnr = wa_tab5-matnr binary search.
    if sy-subrc eq 0.
      wa_tas2-julqty = wa_zrpqv_cjul-grossqty + wa_zrpqv_cjul-nepqty.
      wa_tas2-julpts = wa_zrpqv_cjul-grosspts.
    endif.
    read table it_zrpqv_caug into wa_zrpqv_caug with key bzirk = wa_tab5-bzirk matnr = wa_tab5-matnr binary search.
    if sy-subrc eq 0.
      wa_tas2-augqty = wa_zrpqv_caug-grossqty + wa_zrpqv_caug-nepqty.
      wa_tas2-augpts = wa_zrpqv_caug-grosspts.
    endif.
    read table it_zrpqv_csep into wa_zrpqv_csep with key bzirk = wa_tab5-bzirk matnr = wa_tab5-matnr binary search .
    if sy-subrc eq 0.
      wa_tas2-sepqty = wa_zrpqv_csep-grossqty + wa_zrpqv_csep-nepqty.
      wa_tas2-seppts = wa_zrpqv_csep-grosspts.
    endif.
    read table it_zrpqv_coct into wa_zrpqv_coct with key bzirk = wa_tab5-bzirk matnr = wa_tab5-matnr binary search.
    if sy-subrc eq 0.
      wa_tas2-octqty = wa_zrpqv_coct-grossqty + wa_zrpqv_coct-nepqty.
      wa_tas2-octpts = wa_zrpqv_coct-grosspts.
    endif.
    read table it_zrpqv_cnov into wa_zrpqv_cnov with key bzirk = wa_tab5-bzirk matnr = wa_tab5-matnr binary search.
    if sy-subrc eq 0.
      wa_tas2-novqty = wa_zrpqv_cnov-grossqty + wa_zrpqv_cnov-nepqty.
      wa_tas2-novpts = wa_zrpqv_cnov-grosspts.
    endif.
    read table it_zrpqv_cdec into wa_zrpqv_cdec with key bzirk = wa_tab5-bzirk matnr = wa_tab5-matnr binary search.
    if sy-subrc eq 0.
      wa_tas2-decqty = wa_zrpqv_cdec-grossqty + wa_zrpqv_cdec-nepqty.
      wa_tas2-decpts = wa_zrpqv_cdec-grosspts.
    endif.
    read table it_zrpqv_cjan into wa_zrpqv_cjan with key bzirk = wa_tab5-bzirk matnr = wa_tab5-matnr binary search.
    if sy-subrc eq 0.
      wa_tas2-janqty = wa_zrpqv_cjan-grossqty + wa_zrpqv_cjan-nepqty.
      wa_tas2-janpts = wa_zrpqv_cjan-grosspts.
    endif.
    read table it_zrpqv_cfeb into wa_zrpqv_cfeb with key bzirk = wa_tab5-bzirk matnr = wa_tab5-matnr binary search.
    if sy-subrc eq 0.
      wa_tas2-febqty = wa_zrpqv_cfeb-grossqty + wa_zrpqv_cfeb-nepqty.
      wa_tas2-febpts = wa_zrpqv_cfeb-grosspts.
    endif.
    read table it_zrpqv_cmar into wa_zrpqv_cmar with key bzirk = wa_tab5-bzirk matnr = wa_tab5-matnr binary search.
    if sy-subrc eq 0.
      wa_tas2-marqty = wa_zrpqv_cmar-grossqty + wa_zrpqv_cmar-nepqty.
      wa_tas2-marpts = wa_zrpqv_cmar-grosspts.
    endif.
    collect wa_tas2 into it_tas2.
    clear wa_tas2.
  endloop.

endform.                    "CYEAR

*&---------------------------------------------------------------------*
*&      Form  form1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form ter_total.
  tlaprqty = tlaprqty + wa_tab8-laprqty.
  if caprdt le updt.
    t1 = t1 + wa_tab8-laprqty.
    tcaprqty = tcaprqty + wa_tab8-caprqty.
    if tlaprqty ne 0.
      ttcumapr = ( tcaprqty / tlaprqty ) * 100 - 100.
      tcumapr = ttcumapr.
    endif.
    tsmpaprqty = tsmpaprqty + wa_tab8-smpaprqty.
    if tsmpaprqty ne 0.
      ttrapr = tcaprqty / tsmpaprqty.
      trapr = ttrapr.
    endif.
  else.
*      TLAPRQTY = ' '.
    tcaprqty = ' '.
    tcumapr = ' '.
    tsmpaprqty = ' '.
    trapr = ' '.
  endif.
  if caprdt le nupdt.
    t1smpaprqty = t1smpaprqty + wa_tab8-smpaprqty.
  else.
    t1smpaprqty = ' '.
  endif.

  tlmayqty = tlmayqty + wa_tab8-lmayqty.
  if cmaydt le updt.
    t2 = t2 + wa_tab8-lmayqty.
    tcmayqty = tcmayqty + wa_tab8-cmayqty.
    if tlmayqty ne 0.
      ttcummay = ( ( tcaprqty + tcmayqty ) / ( tlaprqty + tlmayqty ) ) * 100 - 100.
      tcummay  = ttcummay .
    endif.
    tsmpmayqty = tsmpmayqty + wa_tab8-smpmayqty.
    if tsmpmayqty ne 0.
      ttrmay = tcmayqty / tsmpmayqty.
      trmay  = ttrmay .
    endif.
  else.
*      TLMAYQTY = ' '.
    tcmayqty = ' '.
    tcummay = ' '.
    tsmpmayqty = ' '.
    trmay = ' '.
  endif.
  if cmaydt le nupdt.
    t1smpmayqty = t1smpmayqty + wa_tab8-smpmayqty.
  else.
    t1smpmayqty = ' '.
  endif.

  tljunqty = tljunqty + wa_tab8-ljunqty.
  if cjundt le updt.
    t3 = t3 + wa_tab8-ljunqty.
    tcjunqty = tcjunqty + wa_tab8-cjunqty.
*    IF TLJUNQTY NE 0.
    clear : tt1.
    tt1 = tlaprqty + tlmayqty + tljunqty.
    if tt1 gt 0.
      ttcumjun = ( ( tcaprqty + tcmayqty + tcjunqty )  / ( tlaprqty + tlmayqty + tljunqty ) ) * 100 - 100.
      tcumjun = ttcumjun.
    endif.
*    ENDIF.
    tsmpjunqty = tsmpjunqty + wa_tab8-smpjunqty.
    if tsmpjunqty ne 0.
      ttrjun = tcjunqty / tsmpjunqty.
      trjun = ttrjun.
    endif.
  else.
*      TLJUNQTY = ' '.
    tcjunqty = ' '.
    tcumjun = ' '.
    tsmpjunqty = ' '.
    trjun = ' '.
  endif.
  if cjundt le nupdt.
    t1smpjunqty = t1smpjunqty + wa_tab8-smpjunqty.
  else.
    t1smpjunqty = ' '.
  endif.

  tljulqty = tljulqty + wa_tab8-ljulqty.
  if cjuldt le updt.
    t4 = t4  + wa_tab8-ljulqty.
    tcjulqty = tcjulqty + wa_tab8-cjulqty.
*    IF TLJULQTY NE 0.
    clear : tt1.
    tt1 = tlaprqty + tlmayqty + tljunqty + tljulqty.
    if tt1 ne 0.
      ttcumjul = ( ( tcaprqty + tcmayqty + tcjunqty + tcjulqty ) / ( tlaprqty + tlmayqty + tljunqty + tljulqty ) ) * 100 - 100.
      tcumjul = ttcumjul.
    endif.
    tsmpjulqty = tsmpjulqty + wa_tab8-smpjulqty.
    if tsmpjulqty ne 0.
      ttrjul = tcjulqty / tsmpjulqty.
      trjul = ttrjul.
    endif.
  else.
*      TLJULQTY = ' '.
    tcjulqty = ' '.
    tcumjul = ' '.
    tsmpjulqty = ' '.
    trjul = ' '.
  endif.
  if cjuldt le nupdt.
    t1smpjulqty = t1smpjulqty + wa_tab8-smpjulqty.
  else.
    t1smpjulqty = ' '.
  endif.

  tlaugqty = tlaugqty + wa_tab8-laugqty.
  if caugdt le updt.
    t5 = t5 + wa_tab8-laugqty.
    tcaugqty = tcaugqty + wa_tab8-caugqty.
*    IF TLAUGQTY NE 0.
    clear : tt1.
    tt1 = tlaprqty + tlmayqty + tljunqty + tljulqty  + tlaugqty.
    if tt1 ne 0.
      ttcumaug = ( ( tcaprqty + tcmayqty + tcjunqty + tcjulqty  + tcaugqty ) / ( tlaprqty + tlmayqty + tljunqty + tljulqty  + tlaugqty ) ) * 100 - 100.
      tcumaug = ttcumaug .
    endif.
    tsmpaugqty = tsmpaugqty + wa_tab8-smpaugqty.
    if tsmpaugqty ne 0.
      ttraug = tcaugqty / tsmpaugqty.
      traug = ttraug.
    endif.
  else.
*      TLAUGQTY = ' '.
    tcaugqty = ' '.
    tcumaug = ' '.
    tsmpaugqty = ' '.
    traug = ' '.
  endif.
  if caugdt le nupdt.
    t1smpaugqty = t1smpaugqty + wa_tab8-smpaugqty.
  else.
    t1smpaugqty = ' '.
  endif.

  tlsepqty = tlsepqty + wa_tab8-lsepqty.
  if csepdt le updt.
    t6 = t6 + wa_tab8-lsepqty.
    tcsepqty = tcsepqty + wa_tab8-csepqty.
*    IF TLSEPQTY NE 0.
    clear : tt1.
    tt1 = tlaprqty + tlmayqty + tljunqty + tljulqty  + tlaugqty + tlsepqty.
    if tt1 ne 0.
      ttcumsep = ( ( tcaprqty + tcmayqty + tcjunqty + tcjulqty  + tcaugqty + tcsepqty ) / ( tlaprqty + tlmayqty + tljunqty + tljulqty  + tlaugqty + tlsepqty ) ) * 100 - 100.
      tcumsep = ttcumsep.
    endif.
    tsmpsepqty = tsmpsepqty + wa_tab8-smpsepqty.
    if tsmpsepqty ne 0.
      ttrsep = tcsepqty / tsmpsepqty.
      trsep = ttrsep.
    endif.
  else.
*      TLSEPQTY = ' '.
    tcsepqty = ' '.
    tcumsep = ' '.
    tsmpsepqty = ' '.
    trsep = ' '.
  endif.
  if csepdt le nupdt.
    t1smpsepqty = t1smpsepqty + wa_tab8-smpsepqty.
  else.
    t1smpsepqty = ' '.
  endif.

  tloctqty = tloctqty + wa_tab8-loctqty.
  if coctdt le updt.
    t7 = t7 + wa_tab8-loctqty.
    tcoctqty = tcoctqty + wa_tab8-coctqty.
*    IF TLOCTQTY NE 0.
    clear : tt1.
    tt1 = tlaprqty + tlmayqty + tljunqty + tljulqty  + tlaugqty + tlsepqty + tloctqty.
    if tt1 ne 0.
      ttcumoct = ( ( tcaprqty + tcmayqty + tcjunqty + tcjulqty  + tcaugqty + tcsepqty + tcoctqty ) / ( tlaprqty + tlmayqty + tljunqty + tljulqty  + tlaugqty + tlsepqty + tloctqty ) ) * 100 - 100.
      tcumoct = ttcumoct.
    endif.
    tsmpoctqty = tsmpoctqty + wa_tab8-smpoctqty.
    if tsmpoctqty ne 0.
      ttroct = tcoctqty / tsmpoctqty.
      troct = ttroct.
    endif.
  else.
*      TLOCTQTY = ' '.
    tcoctqty = ' '.
    tcumoct = ' '.
    tsmpoctqty = ' '.
    troct = ' '.
  endif.
  if coctdt le nupdt.
    t1smpoctqty = t1smpoctqty + wa_tab8-smpoctqty.
  else.
    t1smpoctqty = ' '.
  endif.

  tlnovqty = tlnovqty + wa_tab8-lnovqty.
  if cnovdt le updt.
    t8 = t8 + wa_tab8-lnovqty.
    tcnovqty = tcnovqty + wa_tab8-cnovqty.
*    IF TLNOVQTY NE 0.
    clear : tt1.
    tt1 = tlaprqty + tlmayqty + tljunqty + tljulqty  + tlaugqty + tlsepqty + tloctqty + tlnovqty.
    if tt1 ne 0.
      ttcumnov = ( ( tcaprqty + tcmayqty + tcjunqty + tcjulqty  + tcaugqty + tcsepqty + tcoctqty + tcnovqty ) / ( tlaprqty + tlmayqty + tljunqty + tljulqty  + tlaugqty + tlsepqty + tloctqty + tlnovqty ) ) * 100 - 100.
      tcumnov = ttcumnov.
    endif.
    tsmpnovqty = tsmpnovqty + wa_tab8-smpnovqty.
    if tsmpnovqty ne 0.
      ttrnov = tcnovqty / tsmpnovqty.
      trnov = ttrnov.
    endif.
  else.
*      TLNOVQTY = ' '.
    tcnovqty = ' '.
    tcumnov = ' '.
    tsmpnovqty = ' '.
    trnov = ' '.
  endif.
  if cnovdt le nupdt.
    t1smpnovqty = t1smpnovqty + wa_tab8-smpnovqty.
  else.
    t1smpnovqty = ' '.
  endif.

  tldecqty = tldecqty + wa_tab8-ldecqty.
  if cdecdt le updt.
    t9 = t9 + wa_tab8-ldecqty.
    tcdecqty = tcdecqty + wa_tab8-cdecqty.
*    IF TLDECQTY NE 0.
    clear  : tt1.
    tt1 = tlaprqty + tlmayqty + tljunqty + tljulqty  + tlaugqty + tlsepqty + tloctqty + tlnovqty + tldecqty.
    if tt1 ne 0.
      ttcumdec = ( ( tcaprqty + tcmayqty + tcjunqty + tcjulqty  + tcaugqty + tcsepqty + tcoctqty + tcnovqty + tcdecqty ) / ( tlaprqty + tlmayqty + tljunqty + tljulqty  + tlaugqty + tlsepqty + tloctqty + tlnovqty + tldecqty ) ) * 100 - 100.
      tcumdec = ttcumdec.
    endif.
    tsmpdecqty = tsmpdecqty + wa_tab8-smpdecqty.
    if tsmpdecqty ne 0.
      ttrdec = tcdecqty / tsmpdecqty.
      trdec = ttrdec.
    endif.
  else.
*      TLDECQTY = ' '.
    tcdecqty = ' '.
    tcumdec = ' '.
    tsmpdecqty = ' '.
    trdec = ' '.
  endif.
  if cdecdt le nupdt.
    t1smpdecqty = t1smpdecqty + wa_tab8-smpdecqty.
  else.
    t1smpdecqty = ' '.
  endif.

  tljanqty = tljanqty + wa_tab8-ljanqty.
  if cjandt le updt.
    t10 = t10 + wa_tab8-ljanqty.
    tcjanqty = tcjanqty + wa_tab8-cjanqty.
*    IF TLJANQTY NE 0.
    clear : tt1.
    tt1 = tlaprqty + tlmayqty + tljunqty + tljulqty  + tlaugqty + tlsepqty + tloctqty + tlnovqty + tldecqty + tljanqty.
    if tt1 ne 0.
      ttcumjan = ( ( tcaprqty + tcmayqty + tcjunqty + tcjulqty  + tcaugqty + tcsepqty + tcoctqty + tcnovqty + tcdecqty + tcjanqty ) / ( tlaprqty + tlmayqty + tljunqty + tljulqty  + tlaugqty + tlsepqty + tloctqty + tlnovqty + tldecqty + tljanqty ) ) *
100 - 100.
      tcumjan = ttcumjan.
    endif.
    tsmpjanqty = tsmpjanqty + wa_tab8-smpjanqty.
    if tsmpjanqty ne 0.
      ttrjan = tcjanqty / tsmpjanqty.
      trjan = ttrjan.
    endif.
  else.
*      TLJANQTY = ' '.
    tcjanqty = ' '.
    tcumjan = ' '.
    tsmpjanqty = ' '.
    trjan = ' '.
  endif.
  if cjandt le nupdt.
    t1smpjanqty = t1smpjanqty + wa_tab8-smpjanqty.
  else.
    t1smpjanqty = ' '.
  endif.

  tlfebqty = tlfebqty + wa_tab8-lfebqty.
  if cfebdt le updt.
    t11 = t11 + wa_tab8-lfebqty.
    tcfebqty = tcfebqty + wa_tab8-cfebqty.
*    IF TLFEBQTY NE 0.
    clear : tt1.
    tt1 = tlaprqty + tlmayqty + tljunqty + tljulqty  + tlaugqty + tlsepqty + tloctqty + tlnovqty + tldecqty + tljanqty + tlfebqty.
    if tt1 ne 0.
      ttcumfeb = (  ( tcaprqty + tcmayqty + tcjunqty + tcjulqty  + tcaugqty + tcsepqty + tcoctqty + tcnovqty + tcdecqty + tcjanqty + tcfebqty ) /
       ( tlaprqty + tlmayqty + tljunqty + tljulqty  + tlaugqty + tlsepqty + tloctqty + tlnovqty + tldecqty + tljanqty + tlfebqty ) ) * 100 - 100.
      tcumfeb = ttcumfeb.
    endif.
    tsmpfebqty = tsmpfebqty + wa_tab8-smpfebqty.
    if tsmpfebqty ne 0.
      ttrfeb = tcfebqty / tsmpfebqty.
      trfeb =  ttrfeb .
    endif.
  else.
*      TLFEBQTY = ' '.
    tcfebqty = ' '.
    tcumfeb = ' '.
    tsmpfebqty = ' '.
    trfeb = ' '.
  endif.
  if cfebdt le nupdt.
    t1smpfebqty = t1smpfebqty + wa_tab8-smpfebqty.
  else.
    t1smpfebqty = ' '.
  endif.

  tlmarqty = tlmarqty + wa_tab8-lmarqty.
  if cmardt le updt.
    t12 = t12 + wa_tab8-lmarqty.
    tcmarqty = tcmarqty + wa_tab8-cmarqty.
*    IF TLMARQTY NE 0.
    clear : tt1.
    tt1 = tlaprqty + tlmayqty + tljunqty + tljulqty  + tlaugqty + tlsepqty + tloctqty + tlnovqty + tldecqty + tljanqty + tlfebqty + tlmarqty.
    if tt1 ne 0.
      ttcummar = ( ( tcaprqty + tcmayqty + tcjunqty + tcjulqty  + tcaugqty + tcsepqty + tcoctqty + tcnovqty + tcdecqty + tcjanqty + tcfebqty + tcmarqty ) /
      ( tlaprqty + tlmayqty + tljunqty + tljulqty  + tlaugqty + tlsepqty + tloctqty + tlnovqty + tldecqty + tljanqty + tlfebqty + tlmarqty ) ) * 100 - 100.
      tcummar = ttcummar.
    endif.
    tsmpmarqty = tsmpmarqty + wa_tab8-smpmarqty.
    if tsmpmarqty ne 0.
      ttrmar = tcmarqty / tsmpmarqty.
      trmar = ttrmar.
    endif.
  else.
*      TLMARQTY = ' '.
    tcmarqty = ' '.
    tcummar = ' '.
    tsmpmarqty = ' '.
    trmar = ' '.
  endif.
  if cmardt le nupdt.
    t1smpmarqty = t1smpmarqty + wa_tab8-smpmarqty.
  else.
    t1smpmarqty = ' '.
  endif.

  tcumtot = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12.
  tyrtot = tlaprqty + tlmayqty + tljunqty + tljulqty + tlaugqty + tlsepqty + tloctqty + tlnovqty
  + tldecqty + tljanqty + tlfebqty + tlmarqty.
  tcycum = tcaprqty + tcmayqty + tcjunqty + tcjulqty + tcaugqty + tcsepqty + tcoctqty + tcnovqty
           + tcdecqty + tcjanqty + tcfebqty + tcmarqty.
endform.                    "ter_total
*&---------------------------------------------------------------------*
*&      Form  form1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form form1.

  clear : pso_name,pso_hq, lcum_tot,smp_tot, pcsale ,mgrapr, mgrmay,mgrjun,mgrjul,mgraug,mgrsep,mgroct,mgrnov,mgrdec,mgrjan,mgrfeb,mgrmar.
  clear : c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12.
  clear : vc1,vc2,vc3,vc4,vc5,vc6,vc7,vc8,vc9,vc10,vc11,vc12.
  clear : vltot, vctot, lcumvtot, cumvtot.


************PY CUMM*************

  if caprdt le updt.
    c1 = c1 + wa_tab8-laprqty.
    vc1 = vc1 + wa_tab8-laprpts.
  endif.
  if cmaydt le updt.
    c2 = c2 + wa_tab8-lmayqty.
    vc2 = vc2 + wa_tab8-lmaypts.
  endif.
  if cjundt le updt.
    c3 = c3 + wa_tab8-ljunqty.
    vc3 = vc3 + wa_tab8-ljunpts.
  endif.
  if cjuldt le updt.
    c4 = c4 + wa_tab8-ljulqty.
    vc4 = vc4 + wa_tab8-ljulpts.
  endif.
  if caugdt le updt.
    c5 = c5 + wa_tab8-laugqty.
    vc5 = vc5 + wa_tab8-laugpts.
  endif.
  if csepdt le updt.
    c6 = c6 + wa_tab8-lsepqty.
    vc6 = vc6 + wa_tab8-lseppts.
  endif.
  if coctdt le updt.
    c7 = c7 + wa_tab8-loctqty.
    vc7 = vc7 + wa_tab8-loctpts.
  endif.
  if cnovdt le updt.
    c8 = c8 + wa_tab8-lnovqty.
    vc8 = vc8 + wa_tab8-lnovpts.
  endif.
  if cdecdt le updt.
    c9 = c9 + wa_tab8-ldecqty.
    vc9 = vc9 + wa_tab8-ldecpts.
  endif.
  if cjandt le updt.
    c10 = c10 + wa_tab8-ljanqty.
    vc10 = vc10 + wa_tab8-ljanpts.
  endif.
  if cfebdt le updt.
    c11 = c11 + wa_tab8-lfebqty.
    vc11 = vc11 + wa_tab8-lfebpts.
  endif.
  if cmardt le updt.
    c12 = c12 + wa_tab8-lmarqty.
    vc12 = vc12 + wa_tab8-lmarpts.
  endif.

  lcum_tot = c1 + c2 + c3 + c4 + c5 + c6 + c7 + c8 + c9 + c10 + c11 + c12.
  lcumvtot = vc1 + vc2 + vc3 + vc4 + vc5 + vc6 + vc7 + vc8 + vc9 + vc10 + vc11 + vc12.
  grplcum_tot = grplcum_tot + lcum_tot.
  clear : c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12.
  clear : vc1,vc2,vc3,vc4,vc5,vc6,vc7,vc8,vc9,vc10,vc11,vc12.

  c1 = c1 + wa_tab8-laprqty.
  c2 = c2 + wa_tab8-lmayqty.
  c3 = c3 + wa_tab8-ljunqty.
  c4 = c4 + wa_tab8-ljulqty.
  c5 = c5 + wa_tab8-laugqty.
  c6 = c6 + wa_tab8-lsepqty.
  c7 = c7 + wa_tab8-loctqty.
  c8 = c8 + wa_tab8-lnovqty.
  c9 = c9 + wa_tab8-ldecqty.
  c10 = c10 + wa_tab8-ljanqty.
  c11 = c11 + wa_tab8-lfebqty.
  c12 = c12 + wa_tab8-lmarqty.
  vc1 = vc1 + wa_tab8-laprpts.
  vc2 = vc2 + wa_tab8-lmaypts.
  vc3 = vc3 + wa_tab8-ljunpts.
  vc4 = vc4 + wa_tab8-ljulpts.
  vc5 = vc5 + wa_tab8-laugpts.
  vc6 = vc6 + wa_tab8-lseppts.
  vc7 = vc7 + wa_tab8-loctpts.
  vc8 = vc8 + wa_tab8-lnovpts.
  vc9 = vc9 + wa_tab8-ldecpts.
  vc10 = vc10 + wa_tab8-ljanpts.
  vc11 = vc11 + wa_tab8-lfebpts.
  vc12 = vc12 + wa_tab8-lmarpts.

  ltot = c1 + c2 + c3 + c4 + c5 + c6 + c7 + c8 + c9 + c10 + c11 + c12.
  vltot = vc1 + vc2 + vc3 + vc4 + vc5 + vc6 + vc7 + vc8 + vc9 + vc10 + vc11 + vc12.
  grpltot = grpltot + ltot.
************CY CUMM********
  clear : c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12.
  clear : vc1,vc2,vc3,vc4,vc5,vc6,vc7,vc8,vc9,vc10,vc11,vc12.

  if caprdt le ldate.
    c1 = c1 + wa_tab8-caprqty.
    vc1 = vc1 + wa_tab8-caprpts.
  endif.
  if cmaydt le ldate.
    c2 = c2 + wa_tab8-cmayqty.
    vc2 = vc2 + wa_tab8-cmaypts.
  endif.
  if cjundt le ldate.
    c3 = c3 + wa_tab8-cjunqty.
    vc3 = vc3 + wa_tab8-cjunpts.
  endif.
  if cjuldt le ldate.
    c4 = c4 + wa_tab8-cjulqty.
    vc4 = vc4 + wa_tab8-cjulpts.
  endif.
  if caugdt le ldate.
    c5 = c5 + wa_tab8-caugqty.
    vc5 = vc5 + wa_tab8-caugpts.
  endif.
  if csepdt le ldate.
    c6 = c6 + wa_tab8-csepqty.
    vc6 = vc6 + wa_tab8-cseppts.
  endif.
  if coctdt le ldate.
    c7 = c7 + wa_tab8-coctqty.
    vc7 = vc7 + wa_tab8-coctpts.
  endif.
  if cnovdt le ldate.
    c8 = c8 + wa_tab8-cnovqty.
    vc8 = vc8 + wa_tab8-cnovpts.
  endif.
  if cdecdt le ldate.
    c9 = c9 + wa_tab8-cdecqty.
    vc9 = vc9 + wa_tab8-cdecpts.
  endif.
  if cjandt le ldate.
    c10 = c10 + wa_tab8-cjanqty.
    vc10 = vc10 + wa_tab8-cjanpts.
  endif.
  if cfebdt le ldate.
    c11 = c11 + wa_tab8-cfebqty.
    vc11 = vc11 + wa_tab8-cfebpts.
  endif.
  if cmardt le ldate.
    c12 = c12 + wa_tab8-cmarqty.
    vc12 = vc12 + wa_tab8-cmarpts.
  endif.

  cum_tot = c1 + c2 + c3 + c4 + c5 + c6 + c7 + c8 + c9 + c10 + c11 + c12.
  cumvtot = vc1 + vc2 + vc3 + vc4 + vc5 + vc6 + vc7 + vc8 + vc9 + vc10 + vc11 + vc12.
  grpcum_tot = grpcum_tot + cum_tot.
  pcsale =  wa_tab8-laprqty + wa_tab8-lmayqty + wa_tab8-ljunqty + wa_tab8-ljulqty + wa_tab8-laugqty + wa_tab8-lsepqty + wa_tab8-loctqty +
            wa_tab8-lnovqty + wa_tab8-ldecqty + wa_tab8-ljanqty + wa_tab8-lfebqty + wa_tab8-lmarqty
            +
            wa_tab8-caprqty + wa_tab8-cmayqty + wa_tab8-cjunqty + wa_tab8-cjulqty + wa_tab8-caugqty + wa_tab8-csepqty + wa_tab8-coctqty +
            wa_tab8-cnovqty + wa_tab8-cdecqty + wa_tab8-cjanqty + wa_tab8-cfebqty + wa_tab8-cmarqty.


************SMP CUMM********
  clear : c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12.
  clear : vc1,vc2,vc3,vc4,vc5,vc6,vc7,vc8,vc9,vc10,vc11,vc12.

  if caprdt le ldate.
    c1 = c1 + wa_tab8-smpaprqty.
  endif.
  if cmaydt le ldate.
    c2 = c2 + wa_tab8-smpmayqty.
  endif.
  if cjundt le ldate.
    c3 = c3 + wa_tab8-smpjunqty.
  endif.
  if cjuldt le ldate.
    c4 = c4 + wa_tab8-smpjulqty.
  endif.
  if caugdt le ldate.
    c5 = c5 + wa_tab8-smpaugqty.
  endif.
  if csepdt le ldate.
    c6 = c6 + wa_tab8-smpsepqty.
  endif.
  if coctdt le ldate.
    c7 = c7 + wa_tab8-smpoctqty.
  endif.
  if cnovdt le ldate.
    c8 = c8 + wa_tab8-smpnovqty.
  endif.
  if cdecdt le ldate.
    c9 = c9 + wa_tab8-smpdecqty.
  endif.
  if cjandt le ldate.
    c10 = c10 + wa_tab8-smpjanqty.
  endif.
  if cfebdt le ldate.
    c11 = c11 + wa_tab8-smpfebqty.
  endif.
  if cmardt le ldate.
    c12 = c12 + wa_tab8-smpmarqty.
  endif.

  smpcum_tot = c1 + c2 + c3 + c4 + c5 + c6 + c7 + c8 + c9 + c10 + c11 + c12.
  smp_tot = c1 + c2 + c3 + c4 + c5 + c6 + c7 + c8 + c9 + c10 + c11 + c12.

  clear :pso_name,pso_hq_code.
  select single ename zz_hqcode  from pa0001 into ( pso_name , pso_hq_code )
    where pernr eq wa_tab8-pernr and endda gt sy-datum.
  if sy-subrc eq 0.
*****    pso_name = pa0001-ename.
    select single * from zthr_heq_des where zz_hqcode eq pso_hq_code."pa0001-zz_hqcode.
    if sy-subrc eq 0.
      pso_hq = zthr_heq_des-zz_hqdesc.
    endif.
  else.
    select single * from yterrallc where bzirk eq wa_tab8-bzirk and endda ge sy-datum.
    if sy-subrc eq 0.
      read table it_pa0001 into wa_pa0001 with key plans = yterrallc-plans.
      if sy-subrc eq 0.
        select single * from zthr_heq_des where zz_hqcode eq pso_hq_code."pa0001-zz_hqcode.
        if sy-subrc eq 0.
          pso_hq = zthr_heq_des-zz_hqdesc.
        endif.
      endif.
    endif.
  endif.
  select single * from yterrallc where bzirk eq wa_tab8-reg and begda le sy-datum and endda ge sy-datum.
  if sy-subrc eq 0.
    select single * from pa0001 where plans eq yterrallc-plans and endda ge sy-datum.
    if sy-subrc eq 0.
      select single * from zthr_heq_des where zz_hqcode eq pa0001-zz_hqcode.
      if sy-subrc eq 0.
        zm_name =  zthr_heq_des-zz_hqdesc.
      endif.
    endif.
  endif.

****************PACK CUMMULATIVE TOT*******************
  clear : cumlmay, cumljun,cumljul,cumlaug,cumlsep,cumloct,cumlnov,cumldec,cumljan,cumlfeb,cumlmar.
  clear : cumcmay, cumcjun,cumcjul,cumcaug,cumcsep,cumcoct,cumcnov,cumcdec,cumcjan,cumcfeb,cumcmar.

  cumlmay =  wa_tab8-laprqty + wa_tab8-lmayqty.
  cumljun =  wa_tab8-laprqty + wa_tab8-lmayqty + wa_tab8-ljunqty.
  cumljul =  wa_tab8-laprqty + wa_tab8-lmayqty + wa_tab8-ljunqty + wa_tab8-ljulqty.
  cumlaug =  wa_tab8-laprqty + wa_tab8-lmayqty + wa_tab8-ljunqty + wa_tab8-ljulqty + wa_tab8-laugqty.
  cumlsep =  wa_tab8-laprqty + wa_tab8-lmayqty + wa_tab8-ljunqty + wa_tab8-ljulqty + wa_tab8-laugqty + wa_tab8-lsepqty.
  cumloct =  wa_tab8-laprqty + wa_tab8-lmayqty + wa_tab8-ljunqty + wa_tab8-ljulqty + wa_tab8-laugqty + wa_tab8-lsepqty
             + wa_tab8-loctqty.
  cumlnov =  wa_tab8-laprqty + wa_tab8-lmayqty + wa_tab8-ljunqty + wa_tab8-ljulqty + wa_tab8-laugqty + wa_tab8-lsepqty
            + wa_tab8-loctqty + wa_tab8-lnovqty.
  cumldec =  wa_tab8-laprqty + wa_tab8-lmayqty + wa_tab8-ljunqty + wa_tab8-ljulqty + wa_tab8-laugqty + wa_tab8-lsepqty
            + wa_tab8-loctqty + wa_tab8-lnovqty + wa_tab8-ldecqty.
  cumljan =  wa_tab8-laprqty + wa_tab8-lmayqty + wa_tab8-ljunqty + wa_tab8-ljulqty + wa_tab8-laugqty + wa_tab8-lsepqty
            + wa_tab8-loctqty + wa_tab8-lnovqty + wa_tab8-ldecqty + wa_tab8-ljanqty.
  cumlfeb =  wa_tab8-laprqty + wa_tab8-lmayqty + wa_tab8-ljunqty + wa_tab8-ljulqty + wa_tab8-laugqty + wa_tab8-lsepqty
            + wa_tab8-loctqty + wa_tab8-lnovqty + wa_tab8-ldecqty + wa_tab8-ljanqty + wa_tab8-lfebqty.
  cumlmar =  wa_tab8-laprqty + wa_tab8-lmayqty + wa_tab8-ljunqty + wa_tab8-ljulqty + wa_tab8-laugqty + wa_tab8-lsepqty
            + wa_tab8-loctqty + wa_tab8-lnovqty + wa_tab8-ldecqty + wa_tab8-ljanqty + wa_tab8-lfebqty + wa_tab8-lmarqty.


  cumcmay =  wa_tab8-caprqty + wa_tab8-cmayqty.
  cumcjun =  wa_tab8-caprqty + wa_tab8-cmayqty + wa_tab8-cjunqty.
  cumcjul =  wa_tab8-caprqty + wa_tab8-cmayqty + wa_tab8-cjunqty + wa_tab8-cjulqty.
  cumcaug =  wa_tab8-caprqty + wa_tab8-cmayqty + wa_tab8-cjunqty + wa_tab8-cjulqty + wa_tab8-caugqty.
  cumcsep =  wa_tab8-caprqty + wa_tab8-cmayqty + wa_tab8-cjunqty + wa_tab8-cjulqty + wa_tab8-caugqty + wa_tab8-csepqty.
  cumcoct =  wa_tab8-caprqty + wa_tab8-cmayqty + wa_tab8-cjunqty + wa_tab8-cjulqty + wa_tab8-caugqty + wa_tab8-csepqty
             + wa_tab8-coctqty.
  cumcnov =  wa_tab8-caprqty + wa_tab8-cmayqty + wa_tab8-cjunqty + wa_tab8-cjulqty + wa_tab8-caugqty + wa_tab8-csepqty
            + wa_tab8-coctqty + wa_tab8-cnovqty.
  cumcdec =  wa_tab8-caprqty + wa_tab8-cmayqty + wa_tab8-cjunqty + wa_tab8-cjulqty + wa_tab8-caugqty + wa_tab8-csepqty
            + wa_tab8-coctqty + wa_tab8-cnovqty + wa_tab8-cdecqty.
  cumcjan =  wa_tab8-caprqty + wa_tab8-cmayqty + wa_tab8-cjunqty + wa_tab8-cjulqty + wa_tab8-caugqty + wa_tab8-csepqty
            + wa_tab8-coctqty + wa_tab8-cnovqty + wa_tab8-cdecqty + wa_tab8-cjanqty.
  cumcfeb =  wa_tab8-caprqty + wa_tab8-cmayqty + wa_tab8-cjunqty + wa_tab8-cjulqty + wa_tab8-caugqty + wa_tab8-csepqty
            + wa_tab8-coctqty + wa_tab8-cnovqty + wa_tab8-cdecqty + wa_tab8-cjanqty + wa_tab8-cfebqty.
  cumcmar =  wa_tab8-caprqty + wa_tab8-cmayqty + wa_tab8-cjunqty + wa_tab8-cjulqty + wa_tab8-caugqty + wa_tab8-csepqty
            + wa_tab8-coctqty + wa_tab8-cnovqty + wa_tab8-cdecqty + wa_tab8-cjanqty + wa_tab8-cfebqty + wa_tab8-cmarqty.


***  IF CAPRDT LE UPDT.
***    IF WA_TAB8-LAPRQTY GT 0.
***      APRGR = ( WA_TAB8-CAPRQTY / WA_TAB8-LAPRQTY ) * 100 - 100.
***      WA_TAB8-APRGR  = APRGR.
***    ENDIF.
***    IF APRGR EQ 0.
***      WA_TAB8-APRGR = '    0'.
***    ELSEIF APRGR EQ -100.
***      WA_TAB8-APRGR = '  100-'.
***    ENDIF.
***    IF WA_TAB8-CAPRQTY EQ 0 AND WA_TAB8-LAPRQTY EQ 0.
***      WA_TAB8-APRGR = '    0'.
***    ENDIF.
***    IF WA_TAB8-CAPRQTY GT 0 AND WA_TAB8-LAPRQTY EQ 0.
***      WA_TAB8-APRGR = '  100'.
***    ENDIF.
***  ENDIF.
***  IF CMAYDT LE UPDT.
***    IF CUMLMAY GT 0.
***      MAYGR = ( CUMCMAY / CUMLMAY ) * 100 - 100.
***      WA_TAB8-MAYGR = MAYGR.
***    ENDIF.
***    IF MAYGR EQ 0.
***      WA_TAB8-MAYGR = '    0'.
***    ELSEIF MAYGR EQ -100.
***      WA_TAB8-MAYGR = '  100-'.
***    ENDIF.
***    IF CUMCMAY EQ 0 AND CUMLMAY EQ 0.
***      WA_TAB8-MAYGR = '    0'.
***    ENDIF.
***    IF CUMCMAY GT 0 AND CUMLMAY LE 0.
***      WA_TAB8-MAYGR = '  100'.
***    ENDIF.
***  ENDIF.
***  IF CJUNDT LE UPDT.
***    IF CUMLJUN GT 0.
***      JUNGR = ( CUMCJUN / CUMLJUN ) * 100 - 100.
***      WA_TAB8-JUNGR = JUNGR.
***    ENDIF.
***    IF JUNGR EQ 0.
***      WA_TAB8-JUNGR = '    0'.
***    ELSEIF JUNGR EQ -100.
***      WA_TAB8-JUNGR = '  100-'.
***    ENDIF.
***    IF CUMCJUN EQ 0 AND CUMLJUN EQ 0.
***      WA_TAB8-JUNGR = '    0'.
***    ENDIF.
***    IF CUMCJUN GT 0 AND CUMLJUN LE 0.
***      WA_TAB8-JUNGR = '  100'.
***    ENDIF.
***
***  ENDIF.
***  IF CJULDT LE UPDT.
***    IF CUMLJUL GT 0.
***      JULGR = ( CUMCJUL / CUMLJUL ) * 100 - 100.
***      WA_TAB8-JULGR = JULGR.
***    ENDIF.
***    IF JULGR EQ 0.
***      WA_TAB8-JULGR = '    0'.
***    ELSEIF JULGR EQ -100.
***      WA_TAB8-JULGR = '  100-'.
***    ENDIF.
***    IF CUMCJUL EQ 0 AND CUMLJUL EQ 0.
***      WA_TAB8-JULGR = '    0'.
***    ENDIF.
***    IF CUMCJUL GT 0 AND CUMLJUL LE 0.
***      WA_TAB8-JULGR = '  100'.
***    ENDIF.
***  ENDIF.
***  IF CAUGDT LE UPDT.
***    IF CUMLAUG GT 0.
***      AUGGR = ( CUMCAUG / CUMLAUG ) * 100 - 100.
***      WA_TAB8-AUGGR = AUGGR.
***    ENDIF.
***
***    IF AUGGR EQ 0.
***      WA_TAB8-AUGGR = '    0'.
***    ELSEIF AUGGR EQ -100.
***      WA_TAB8-AUGGR = '  100-'.
***    ENDIF.
***    IF CUMCAUG EQ 0 AND CUMLAUG EQ 0.
***      WA_TAB8-AUGGR = '    0'.
***    ENDIF.
***    IF CUMCAUG GT 0 AND CUMLAUG LE 0.
***      WA_TAB8-AUGGR = '  100'.
***    ENDIF.
***
***  ENDIF.
***  IF CSEPDT LE UPDT.
***    IF CUMLSEP GT 0.
***      SEPGR = ( CUMCSEP / CUMLSEP ) * 100 - 100.
***      WA_TAB8-SEPGR = SEPGR.
***    ENDIF.
***
***    IF SEPGR EQ 0.
***      WA_TAB8-SEPGR = '    0'.
***    ELSEIF SEPGR EQ -100.
***      WA_TAB8-SEPGR = '  100-'.
***    ENDIF.
***    IF CUMCSEP EQ 0 AND CUMLSEP EQ 0.
***      WA_TAB8-SEPGR = '    0'.
***    ENDIF.
***    IF CUMCSEP GT 0 AND CUMLSEP LE 0.
***      WA_TAB8-SEPGR = '  100'.
***    ENDIF.
***
***  ENDIF.
***  IF COCTDT LE UPDT.
***    IF CUMLOCT GT 0.
***      OCTGR = ( CUMCOCT / CUMLOCT ) * 100 - 100.
***      WA_TAB8-OCTGR = OCTGR.
***    ENDIF.
***
***    IF OCTGR EQ 0.
***      WA_TAB8-OCTGR = '    0'.
***    ELSEIF OCTGR EQ -100.
***      WA_TAB8-OCTGR = '  100-'.
***    ENDIF.
***    IF CUMCOCT EQ 0 AND CUMLOCT EQ 0.
***      WA_TAB8-OCTGR = '    0'.
***    ENDIF.
***    IF CUMCOCT GT 0 AND CUMLOCT LE 0.
***      WA_TAB8-OCTGR = '  100'.
***    ENDIF.
***
***  ENDIF.
***  IF CNOVDT LE UPDT.
***    IF CUMLNOV GT 0.
***      NOVGR = ( CUMCNOV / CUMLNOV ) * 100 - 100.
***      WA_TAB8-NOVGR = NOVGR.
***    ENDIF.
***
***    IF NOVGR EQ 0.
***      WA_TAB8-NOVGR = '    0'.
***    ELSEIF NOVGR EQ -100.
***      WA_TAB8-NOVGR = '  100-'.
***    ENDIF.
***    IF CUMCNOV EQ 0 AND CUMLNOV EQ 0.
***      WA_TAB8-NOVGR = '    0'.
***    ENDIF.
***    IF CUMCNOV GT 0 AND CUMLNOV LE 0.
***      WA_TAB8-NOVGR = '  100'.
***    ENDIF.
***
***
***  ENDIF.
***  IF CDECDT LE UPDT.
***    IF CUMLDEC GT 0.
***      DECGR = ( CUMCDEC / CUMLDEC ) * 100 - 100.
***      WA_TAB8-DECGR = DECGR.
***    ENDIF.
***
***    IF DECGR EQ 0.
***      WA_TAB8-DECGR = '    0'.
***    ELSEIF DECGR EQ -100.
***      WA_TAB8-DECGR = '  100-'.
***    ENDIF.
***    IF CUMCDEC EQ 0 AND CUMLDEC EQ 0.
***      WA_TAB8-DECGR = '    0'.
***    ENDIF.
***    IF CUMCDEC GT 0 AND CUMLDEC LE 0.
***      WA_TAB8-DECGR = '  100'.
***    ENDIF.
***
***  ENDIF.
***  IF CJANDT LE UPDT.
***    IF CUMLJAN GT 0.
***      JANGR = ( CUMCJAN / CUMLJAN ) * 100 - 100.
***      WA_TAB8-JANGR = JANGR.
***    ENDIF.
***
***    IF JANGR EQ 0.
***      WA_TAB8-JANGR = '    0'.
***    ELSEIF JANGR EQ -100.
***      WA_TAB8-JANGR = '  100-'.
***    ENDIF.
***    IF CUMCJAN EQ 0 AND CUMLJAN EQ 0.
***      WA_TAB8-JANGR = '    0'.
***    ENDIF.
***    IF CUMCJAN GT 0 AND CUMLJAN LE 0.
***      WA_TAB8-JANGR = '  100'.
***    ENDIF.
***
***
***  ENDIF.
***  IF CFEBDT LE UPDT.
***    IF CUMLFEB GT 0.
***      FEBGR = ( CUMCFEB / CUMLFEB ) * 100 - 100.
***      WA_TAB8-FEBGR = FEBGR.
***    ENDIF.
***
***    IF FEBGR EQ 0.
***      WA_TAB8-FEBGR = '    0'.
***    ELSEIF FEBGR EQ -100.
***      WA_TAB8-FEBGR = '  100-'.
***    ENDIF.
***    IF CUMCFEB EQ 0 AND CUMLFEB EQ 0.
***      WA_TAB8-FEBGR = '    0'.
***    ENDIF.
***    IF CUMCFEB GT 0 AND CUMLFEB LE 0.
***      WA_TAB8-FEBGR = '  100'.
***    ENDIF.
***
***  ENDIF.
***  IF CMARDT LE UPDT.
***    IF CUMLMAR GT 0.
***      MARGR = ( CUMCMAR / CUMLMAR ) * 100 - 100.
***      WA_TAB8-MARGR = MARGR.
***    ENDIF.
***
***    IF MARGR EQ 0.
***      WA_TAB8-MARGR = '    0'.
***    ELSEIF MARGR EQ -100.
***      WA_TAB8-MARGR = '  100-'.
***    ENDIF.
***    IF CUMCMAR EQ 0 AND CUMLMAR EQ 0.
***      WA_TAB8-MARGR = '    0'.
***    ENDIF.
***    IF CUMCMAR GT 0 AND CUMLMAR LE 0.
***      WA_TAB8-MARGR = '  100'.
***    ENDIF.
***  ENDIF.



  call function 'WRITE_FORM'
    exporting
      element = 'H1'
      window  = 'WINDOW1'.

*    select single * from zprdgroup where rep_type eq 'SR7Z' and grp_code eq wa_tab8-grp_code and prn_prd eq 'N'.
*    if sy-subrc ne 0.

*    select single * from zprdgroup where rep_type eq 'SR7Z' and grp_code eq wa_tab8-grp_code AND MVGR4 = WA_TAB8-MVGR4 and prn_prd eq 'Y'.
*    if sy-subrc EQ 0.
*        WRITE : / '******',WA_TAB8-GRP_CODE,WA_TAB8-MAKTX.
*      ENDIF.

  clear : p.
  p = ltot + cum_tot + smpcum_tot.
  if p gt 0.
********************do not display zero *************

    select single * from zprdgroup where rep_type eq 'SR7Z' and mvgr4 = wa_tab8-mvgr4 and grp_code ne '7777' and grp_code ne '8888'.
    if sy-subrc eq 0.

      if wa_tab8-laprqty gt 0.
        mgrapr = ( wa_tab8-caprqty / wa_tab8-laprqty ) * 100 - 100.
      else.
        if wa_tab8-caprqty gt 0.
          mgrapr = 100.
        endif.
      endif.

      if wa_tab8-lmayqty gt 0.
        mgrmay = ( wa_tab8-cmayqty / wa_tab8-lmayqty ) * 100 - 100.
      else.
        if wa_tab8-cmayqty gt 0.
          mgrmay = 100.
        endif.
      endif.

      if wa_tab8-ljunqty gt 0.
        mgrjun = ( wa_tab8-cjunqty / wa_tab8-ljunqty ) * 100 - 100.
      else.
        if wa_tab8-cjunqty gt 0.
          mgrjun = 100.
        endif.
      endif.

      if wa_tab8-ljulqty gt 0.
        mgrjul = ( wa_tab8-cjulqty / wa_tab8-ljulqty ) * 100 - 100.
      else.
        if wa_tab8-cjulqty gt 0.
          mgrjul = 100.
        endif.
      endif.

      if wa_tab8-laugqty gt 0.
        mgraug = ( wa_tab8-caugqty / wa_tab8-laugqty ) * 100 - 100.
      else.
        if wa_tab8-caugqty gt 0.
          mgraug = 100.
        endif.
      endif.

      if wa_tab8-lsepqty gt 0.
        mgrsep = ( wa_tab8-csepqty / wa_tab8-lsepqty ) * 100 - 100.
      else.
        if wa_tab8-csepqty gt 0.
          mgrsep = 100.
        endif.
      endif.

      if wa_tab8-loctqty gt 0.
        mgroct = ( wa_tab8-coctqty / wa_tab8-loctqty ) * 100 - 100.
      else.
        if wa_tab8-coctqty gt 0.
          mgroct = 100.
        endif.
      endif.

      if wa_tab8-lnovqty gt 0.
        mgrnov = ( wa_tab8-cnovqty / wa_tab8-lnovqty ) * 100 - 100.
      else.
        if wa_tab8-cnovqty gt 0.
          mgrnov = 100.
        endif.
      endif.

      if wa_tab8-ldecqty gt 0.
        mgrdec = ( wa_tab8-cdecqty / wa_tab8-ldecqty ) * 100 - 100.
      else.
        if wa_tab8-cdecqty gt 0.
          mgrdec = 100.
        endif.
      endif.

      if wa_tab8-ljanqty gt 0.
        mgrjan = ( wa_tab8-cjanqty / wa_tab8-ljanqty ) * 100 - 100.
      else.
        if wa_tab8-cjanqty gt 0.
          mgrjan = 100.
        endif.
      endif.

      if wa_tab8-lfebqty gt 0.
        mgrfeb = ( wa_tab8-cfebqty / wa_tab8-lfebqty ) * 100 - 100.
      else.
        if wa_tab8-cfebqty gt 0.
          mgrfeb = 100.
        endif.
      endif.

      if wa_tab8-lmarqty gt 0.
        mgrmar = ( wa_tab8-cmarqty / wa_tab8-lmarqty ) * 100 - 100.
      else.
        if wa_tab8-cmarqty gt 0.
          mgrmar = 100.
        endif.
      endif.


**************************************************************
      if caprdt le updt.
        wa_tab8-mgrapr  = mgrapr .
      endif.
      if cmaydt le updt.
        wa_tab8-mgrmay  = mgrmay .
      endif.
      if cjundt le updt.
        wa_tab8-mgrjun  = mgrjun .
      endif.
      if cjuldt le updt.
        wa_tab8-mgrjul  = mgrjul .
      endif.
      if caugdt le updt.
        wa_tab8-mgraug  = mgraug .
      endif.
      if csepdt le updt.
        wa_tab8-mgrsep  = mgrsep .
      endif.
      if coctdt le updt.
        wa_tab8-mgroct  = mgroct .
      endif.
      if cnovdt le updt.
        wa_tab8-mgrnov  = mgrnov .
      endif.
      if cdecdt le updt.
        wa_tab8-mgrdec  = mgrdec .
      endif.
      if cjandt le updt.
        wa_tab8-mgrjan  = mgrjan .
      endif.
      if cfebdt le updt.
        wa_tab8-mgrfeb  = mgrfeb .
      endif.
      if cmardt le updt.
        wa_tab8-mgrmar  = mgrmar .
      endif.
******************************************************************


*      if pcsale gt 0.
      call function 'WRITE_FORM'
        exporting
          element = 'DET1'
          window  = 'MAIN'.
      if smp_tot gt 0.
        call function 'WRITE_FORM'
          exporting
            element = 'DET2'
            window  = 'MAIN'.
      endif.
      call function 'WRITE_FORM'
        exporting
          element = 'DET22'
          window  = 'MAIN'.


*      elseif smp_tot gt 0.
*        call function 'WRITE_FORM'
*          EXPORTING
*            element = 'DET21'
*            window  = 'MAIN'.
*      endif.
*    endif.
    endif.
  endif.
*************GROUP TOTAL*********************

  laprgrp = laprgrp + wa_tab8-laprqty.
  if caprdt le updt.
    caprgrp = caprgrp + wa_tab8-caprqty.
    if laprgrp gt 0.
      gcumaprgr1 = ( caprgrp / laprgrp ) * 100 - 100.
      gcumaprgr =  gcumaprgr1.
    endif.
    if laprgrp eq 0 and caprgrp gt 0.
      gcumaprgr = '  100'.
    endif.
  else.
    caprgrp = ' '.
    gcumaprgr = ' '.
  endif.
  if caprdt le nupdt.
    smpaprgrp = smpaprgrp + wa_tab8-smpaprqty.
    if smpaprgrp ne 0.
      ratioaprgrp1 = caprgrp / smpaprgrp.
      ratioaprgrp = ratioaprgrp1.
    else.
      ratioaprgrp = ' '.
    endif.
  else.
    smpaprgrp = ' '.
    ratioaprgrp = ' '.
  endif.



  lmaygrp = lmaygrp + wa_tab8-lmayqty.
  if cmaydt le updt.
    cmaygrp = cmaygrp + wa_tab8-cmayqty.
    if lmaygrp gt 0.
      clear n1.
      n1 = laprgrp + lmaygrp.
      if n1 gt 0.
        gcummaygr1 = ( ( caprgrp + cmaygrp ) / ( laprgrp + lmaygrp ) ) * 100 - 100.
      endif.
      gcummaygr = gcummaygr1.
    endif.
  else.
    cmaygrp = ' '.
    gcummaygr = ' '.
  endif.
  if cmaydt le nupdt.
    smpmaygrp = smpmaygrp + wa_tab8-smpmayqty.
    if smpmaygrp ne 0.
      ratiomaygrp1 = cmaygrp / smpmaygrp.
      ratiomaygrp =  ratiomaygrp1.
    else.
      ratiomaygrp = ' '.
    endif.
  else.
    smpmaygrp = ' '.
    ratiomaygrp = ' '.
  endif.




  ljungrp = ljungrp + wa_tab8-ljunqty.
  if cjundt le updt.
    cjungrp = cjungrp + wa_tab8-cjunqty.
    clear : ljun.
    ljun = laprgrp + lmaygrp + ljungrp.
    if ljun gt 0.
      gcumjungr1 = ( ( caprgrp + cmaygrp + cjungrp ) / ( laprgrp + lmaygrp + ljungrp ) ) * 100 - 100.
      gcumjungr = gcumjungr1.
    endif.
  else.
    cjungrp = ' '.
    gcumjungr = ' '.
  endif.
  if cjundt le nupdt.
    smpjungrp = smpjungrp + wa_tab8-smpjunqty.
    if smpjungrp ne 0.
      ratiojungrp1 = cjungrp / smpjungrp.
      ratiojungrp =  ratiojungrp1.
    else.
      ratiojungrp = ' '.
    endif.
  else.
    smpjungrp = ' '.
    ratiojungrp = ' '.
  endif.


  ljulgrp = ljulgrp + wa_tab8-ljulqty.
  if cjuldt le updt.
    cjulgrp = cjulgrp + wa_tab8-cjulqty.
    if ljulgrp gt 0.
      gcumjulgr1 = ( ( caprgrp + cmaygrp + cjungrp + cjulgrp )  / ( laprgrp + lmaygrp + ljungrp + ljulgrp ) ) * 100 - 100.
      gcumjulgr = gcumjulgr1.
    endif.
  else.
    cjulgrp = ' '.
    gcumjulgr = ' '.
  endif.
  if cjuldt le nupdt.
    smpjulgrp = smpjulgrp + wa_tab8-smpjulqty.
    if smpjulgrp ne 0.
      ratiojulgrp1 = cjulgrp / smpjulgrp.
      ratiojulgrp =  ratiojulgrp1.
    else.
      ratiojulgrp = ' '.
    endif.
  else.
    smpjulgrp = ' '.
    ratiojulgrp = ' '.
  endif.



  lauggrp = lauggrp + wa_tab8-laugqty.
  if caugdt le updt.
    cauggrp = cauggrp + wa_tab8-caugqty.
    if lauggrp gt 0.
      gcumauggr1 = ( ( caprgrp + cmaygrp + cjungrp + cjulgrp + cauggrp ) / ( laprgrp + lmaygrp + ljungrp + ljulgrp + lauggrp ) ) * 100 - 100.
      gcumauggr = gcumauggr1.
    endif.
  else.
    cauggrp = ' '.
    gcumauggr = ' '.
  endif.
  if caugdt le nupdt.
    smpauggrp = smpauggrp + wa_tab8-smpaugqty.
    if smpauggrp ne 0.
      ratioauggrp1 = cauggrp / smpauggrp.
      ratioauggrp = ratioauggrp1.
    else.
      ratioauggrp = ' '.
    endif.
  else.
    smpauggrp = ' '.
    ratioauggrp = ' '.
  endif.



  lsepgrp = lsepgrp + wa_tab8-lsepqty.
  if csepdt le updt.
    csepgrp = csepgrp + wa_tab8-csepqty.
    if lsepgrp gt 0.
      gcumsepgr1 = ( ( caprgrp + cmaygrp + cjungrp + cjulgrp + cauggrp + csepgrp ) / ( laprgrp + lmaygrp + ljungrp + ljulgrp + lauggrp + lsepgrp ) ) * 100 - 100.
      gcumsepgr = gcumsepgr1.
    endif.
  else.
    csepgrp = ' '.
    gcumsepgr = ' '.
  endif.
  if csepdt le nupdt.
    smpsepgrp = smpsepgrp + wa_tab8-smpsepqty.
    if smpsepgrp ne 0.
      ratiosepgrp = csepgrp / smpsepgrp.
      ratiosepgrp = ratiosepgrp1.
    else.
      ratiosepgrp = ' '.
    endif.
  else.
    smpsepgrp = ' '.
    ratiosepgrp = ' '.
  endif.



  loctgrp = loctgrp + wa_tab8-loctqty.
  if coctdt le updt.
    coctgrp = coctgrp + wa_tab8-coctqty.
    if loctgrp gt 0.
      gcumoctgr1 = ( ( caprgrp + cmaygrp + cjungrp + cjulgrp + cauggrp + csepgrp  + coctgrp ) /
      ( laprgrp + lmaygrp + ljungrp + ljulgrp + lauggrp + lsepgrp + loctgrp ) ) * 100 - 100.
      gcumoctgr = gcumoctgr1.
    endif.
  else.
    coctgrp = ' '.
    gcumoctgr = ' '.
  endif.
  if coctdt le nupdt.
    smpoctgrp = smpoctgrp + wa_tab8-smpoctqty.
    if smpoctgrp ne 0.
      ratiooctgrp = coctgrp / smpoctgrp.
      ratiooctgrp = ratiooctgrp1.
    else.
      ratiooctgrp = ' '.
    endif.
  else.
    smpoctgrp = ' '.
    ratiooctgrp = ' '.
  endif.


  lnovgrp = lnovgrp + wa_tab8-lnovqty.
  if cnovdt le updt.
    cnovgrp = cnovgrp + wa_tab8-cnovqty.
    if lnovgrp gt 0.
      gcumnovgr1 = ( ( caprgrp + cmaygrp + cjungrp + cjulgrp + cauggrp + csepgrp  + coctgrp + cnovgrp )
      / ( laprgrp + lmaygrp + ljungrp + ljulgrp + lauggrp + lsepgrp + loctgrp + lnovgrp ) ) * 100 - 100.
      gcumnovgr = gcumnovgr1.
    endif.
  else.
    cnovgrp = ' '.
    gcumnovgr = ' '.
  endif.
  if cnovdt le nupdt.
    smpnovgrp = smpnovgrp + wa_tab8-smpnovqty.
    if smpnovgrp ne 0.
      rationovgrp1 = cnovgrp / smpnovgrp.
      rationovgrp =  rationovgrp1.
    else.
      rationovgrp = ' '.
    endif.
  else.
    smpnovgrp = ' '.
    rationovgrp = ' '.
  endif.


  ldecgrp = ldecgrp + wa_tab8-ldecqty.
  if cdecdt le updt.
    cdecgrp = cdecgrp + wa_tab8-cdecqty.
    if ldecgrp gt 0.
      gcumdecgr1 = ( ( caprgrp + cmaygrp + cjungrp + cjulgrp + cauggrp + csepgrp  + coctgrp + cnovgrp + cdecgrp ) /
      ( laprgrp + lmaygrp + ljungrp + ljulgrp + lauggrp + lsepgrp + loctgrp + lnovgrp + ldecgrp ) ) * 100 - 100.
      gcumdecgr = gcumdecgr1.
    endif.
  else.
    cdecgrp = ' '.
    gcumdecgr = ' '.
  endif.
  if cdecdt le nupdt.
    smpdecgrp = smpdecgrp + wa_tab8-smpdecqty.
    if smpdecgrp ne 0.
      ratiodecgrp1 = cdecgrp / smpdecgrp.
      ratiodecgrp = ratiodecgrp1.
    else.
      ratiodecgrp = ' '.
    endif.
  else.
    smpdecgrp = ' '.
    ratiodecgrp = ' '.
  endif.



  ljangrp = ljangrp + wa_tab8-ljanqty.
  if cjandt le updt.
    cjangrp = cjangrp + wa_tab8-cjanqty.
    if ljangrp gt 0.
      gcumjangr1 = ( ( caprgrp + cmaygrp + cjungrp + cjulgrp + cauggrp + csepgrp  + coctgrp + cnovgrp + cdecgrp + cjangrp ) /
       ( laprgrp + lmaygrp + ljungrp + ljulgrp + lauggrp + lsepgrp + loctgrp + lnovgrp + ldecgrp + ljangrp ) ) * 100 - 100.
      gcumjangr =  gcumjangr1.
    endif.
  else.
    cjangrp = ' '.
    gcumjangr = ' '.
  endif.
  if cjandt le nupdt.
    smpjangrp = smpjangrp + wa_tab8-smpjanqty.
    if smpjangrp ne 0.
      ratiojangrp1 = cjangrp / smpjangrp.
      ratiojangrp = ratiojangrp1.
    else.
      ratiojangrp = ' '.
    endif.
  else.
    smpjangrp = ' '.
    ratiojangrp = ' '.
  endif.



  lfebgrp = lfebgrp + wa_tab8-lfebqty.
  if cfebdt le updt.
    cfebgrp = cfebgrp + wa_tab8-cfebqty.
    if lfebgrp gt 0.
      gcumfebgr1 = ( ( caprgrp + cmaygrp + cjungrp + cjulgrp + cauggrp + csepgrp  + coctgrp + cnovgrp + cdecgrp + cjangrp + cfebgrp ) /
      ( laprgrp + lmaygrp + ljungrp + ljulgrp + lauggrp + lsepgrp + loctgrp + lnovgrp + ldecgrp + ljangrp + lfebgrp ) ) * 100 - 100.
      gcumfebgr = gcumfebgr1.
    endif.
  else.
    cfebgrp = ' '.
    gcumfebgr = ' '.
  endif.
  if cfebdt le nupdt.
    smpfebgrp = smpfebgrp + wa_tab8-smpfebqty.
    if smpfebgrp ne 0.
      ratiofebgrp1 = cfebgrp / smpfebgrp.
      ratiofebgrp = ratiofebgrp1.
    else.
      ratiofebgrp = ' '.
    endif.
  else.
    smpfebgrp = ' '.
    ratiofebgrp = ' '.
  endif.



  lmargrp = lmargrp + wa_tab8-lmarqty.
  if cmardt le updt.
    cmargrp = cmargrp + wa_tab8-cmarqty.
    if lmargrp gt 0.
      gcummargr1 = ( ( caprgrp + cmaygrp + cjungrp + cjulgrp + cauggrp + csepgrp  + coctgrp + cnovgrp + cdecgrp + cjangrp + cfebgrp + cmargrp ) /
      ( laprgrp + lmaygrp + ljungrp + ljulgrp + lauggrp + lsepgrp + loctgrp + lnovgrp + ldecgrp + ljangrp + lfebgrp + lmargrp ) ) * 100 - 100.
      gcummargr = gcummargr1.
    endif.
  else.
    cmargrp = ' '.
    gcummargr = ' '.
  endif.
  if cmardt le nupdt.
    smpmargrp = smpmargrp + wa_tab8-smpmarqty.
    if smpmargrp ne 0.
      ratiomargrp1 = cmargrp / smpmargrp.
      ratiomargrp = ratiomargrp1.
    else.
      ratiomargrp = ' '.
    endif.
  else.
    smpmargrp = ' '.
    ratiomargrp = ' '.
  endif.


endform.                    "form1
*&---------------------------------------------------------------------*
*&      Form  DZM_EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form dzm_email .


  sort it_taq1 by bzirk.
  delete adjacent duplicates from it_taq1 comparing bzirk.

  loop at it_taq1 into wa_taq1.
    read table it_tab1 into wa_tab1 with key rm = wa_taq1-bzirk.
    if sy-subrc eq 0.
      wa_taz1-bzirk = wa_tab1-zm.
      collect wa_taz1 into it_taz1.
      clear wa_taz1.
    endif.
  endloop.
  sort it_taz1 by bzirk.
  delete adjacent duplicates from it_taz1 comparing bzirk.

  loop at it_taz1 into wa_taz1.
    select single * from yterrallc where bzirk eq wa_taz1-bzirk and begda le updt and endda ge updt.
    if sy-subrc eq 0.
      select single * from pa0001 where plans eq yterrallc-plans and begda le updt and endda ge updt.
      if sy-subrc eq 0.
        select single * from pa0105 where pernr eq pa0001-pernr and subty eq '0010'.
        if sy-subrc eq 0.
          wa_taz2-bzirk = wa_taz1-bzirk.
          wa_taz2-usrid_long = pa0105-usrid_long.
          collect wa_taz2 into it_taz2.
          clear wa_taz2.
        endif.
      endif.
    endif.
  endloop.

*  sort it_tab8 by reg rm bzirk prn_seq.
  sort it_tab8 by reg zm rm bzirk grp_code prn_seq .
  options-tdgetotf = 'X'.
  loop at it_taz1 into wa_taz1.
    perform open_form1.
    perform start_form.

    loop at it_tab8 into wa_tab8 .
*      WHERE RM EQ WA_TAQ1-BZIRK.
      read table it_tab1 into wa_tab1 with key zm = wa_taz1-bzirk rm = wa_tab8-rm.
      if sy-subrc eq 0.
        perform form1.
        at end of grp_code.

          clear : grpnm,smptotal.
          smptotal = smpaprgrp + smpmaygrp + smpjungrp + smpjulgrp + smpauggrp + smpsepgrp + smpoctgrp + smpnovgrp + smpdecgrp + smpjangrp
          + smpfebgrp + smpmargrp.
*      WRITE : / '**',WA_TAB8-GRP_CODE.
          if wa_tab8-grp_code eq '7777'.
            grpnm = 'BC OTHER'.
          elseif wa_tab8-grp_code eq '8888'.
            grpnm = 'XL OTHER'.
          else.
            grpnm = 'GROUP TOTAL'.
          endif.

          if smptotal eq 0 and grplcum_tot eq 0 and grpltot eq 0 and grpcum_tot eq 0."19.11.2019
          else.
*******************

            call function 'WRITE_FORM'
              exporting
                element = 'GRP1'
                window  = 'MAIN'.
          endif.

          laprgrp = 0.
          caprgrp = 0.
          gcumaprgr = 0.
          smpaprgrp = 0.
          ratioaprgrp = 0.

          lmaygrp = 0.
          cmaygrp = 0.
          gcummaygr = 0.
          smpmaygrp = 0.
          ratiomaygrp = 0.

          ljungrp = 0.
          cjungrp = 0.
          gcumjungr = 0.
          smpjungrp = 0.
          ratiojungrp = 0.

          ljulgrp = 0.
          cjulgrp = 0.
          gcumjulgr = 0.
          smpjulgrp = 0.
          ratiojulgrp = 0.

          lauggrp = 0.
          cauggrp = 0.
          gcumauggr = 0.
          smpauggrp = 0.
          ratioauggrp = 0.

          lsepgrp = 0.
          csepgrp = 0.
          gcumsepgr = 0.
          smpsepgrp = 0.
          ratiosepgrp = 0.

          loctgrp = 0.
          coctgrp = 0.
          gcumoctgr = 0.
          smpoctgrp = 0.
          ratiooctgrp = 0.

          lnovgrp = 0.
          cnovgrp = 0.
          gcumnovgr = 0.
          smpnovgrp = 0.
          rationovgrp = 0.

          ldecgrp = 0.
          cdecgrp = 0.
          gcumdecgr = 0.
          smpdecgrp = 0.
          ratiodecgrp = 0.

          ljangrp = 0.
          cjangrp = 0.
          gcumjangr = 0.
          smpjangrp = 0.
          ratiojangrp = 0.

          lfebgrp = 0.
          cfebgrp = 0.
          gcumfebgr = 0.
          smpfebgrp = 0.
          ratiofebgrp = 0.

          lmargrp = 0.
          cmargrp = 0.
          gcummargr = 0.
          smpmargrp = 0.
          ratiomargrp = 0.
        endat.
**************TERRITORY TOTAL****************
        perform ter_total.
        at end of bzirk.

          call function 'WRITE_FORM'
            exporting
              element = 'H3'
              window  = 'MAIN'.

          t1smpaprqty = 0.
          t1smpmayqty = 0.
          t1smpjunqty = 0.
          t1smpjulqty = 0.
          t1smpaugqty = 0.
          t1smpsepqty = 0.
          t1smpoctqty = 0.
          t1smpnovqty = 0.
          t1smpdecqty = 0.
          t1smpjanqty = 0.
          t1smpfebqty = 0.
          t1smpmarqty = 0.

          tlaprqty = 0.
          tcaprqty = 0.
          tsmpaprqty = 0.
          tcumapr = 0.
          trapr = 0.

          tlmayqty = 0.
          tcmayqty = 0.
          tsmpmayqty = 0.
          tcummay = 0.
          trmay = 0.

          tljunqty = 0.
          tcjunqty = 0.
          tsmpjunqty = 0.
          tcumjun = 0.
          trjun = 0.

          tljulqty = 0.
          tcjulqty = 0.
          tsmpjulqty = 0.
          tcumjul = 0.
          trjul = 0.

          tlaugqty = 0.
          tcaugqty = 0.
          tsmpaugqty = 0.
          tcumaug = 0.
          traug = 0.

          tlsepqty = 0.
          tcsepqty = 0.
          tsmpsepqty = 0.
          tcumsep = 0.
          trsep = 0.

          tloctqty = 0.
          tcoctqty = 0.
          tsmpoctqty = 0.
          tcumoct = 0.
          troct = 0.

          tlnovqty = 0.
          tcnovqty = 0.
          tsmpnovqty = 0.
          tcumnov = 0.
          trnov = 0.

          tldecqty = 0.
          tcdecqty = 0.
          tsmpdecqty = 0.
          tcumdec = 0.
          trdec = 0.

          tljanqty = 0.
          tcjanqty = 0.
          tsmpjanqty = 0.
          tcumjan = 0.
          trjan = 0.

          tlfebqty = 0.
          tcfebqty = 0.
          tsmpfebqty = 0.
          tcumfeb = 0.
          trfeb = 0.

          tlmarqty = 0.
          tcmarqty = 0.
          tsmpmarqty = 0.
          tcummar = 0.
          trmar = 0.

        endat.
      endif.
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

    write updt to wa_d1 dd/mm/yyyy.


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
    concatenate 'SR-7-P SAMPLE V/S SALE as of ' wa_d1 into doc_chng-obj_descr separated by space.
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

    concatenate 'SR-7P' '-DZM' into objpack-obj_descr separated by space.
    objpack-doc_size = righe_attachment * 255.
    append objpack.
    clear objpack.

    loop at it_taz2 into wa_taz2 where bzirk = wa_taz1-bzirk.
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

*        write : / 'EMAIL SENT ON ',wa_taq2-usrid_long.
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

  loop at it_taq2 into wa_taq2.
    write : / 'EMAIL SENT ON ',wa_taq2-usrid_long.
  endloop.

endform.


INCLUDE zsr7_pson_open_formf01.


INCLUDE zsr7_pson_nameupdtf01.
