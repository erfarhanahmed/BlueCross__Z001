**&---------------------------------------------------------------------*
*& Report  ZMRP1
*&.DEVELOPED BY JYOTSNA
*&---------------------------------------------------------------------*
*&System will not consider BOM which is marked for deletion.
*2. System will not consider Material codes which are marked for deletion.
*3. By default system will consider BOM1 in MRP run if BOM selection is not done.
*4. In case of multiple BOM, provision is made to select BOM as per requirement for FG & SFG products.
*5.  Select BOM1 or BOM2 or BOM3.
*6. In case if more than 3 BOMs are present, then at the time of BOM selection, enter required BOM number in OTHR BOM & select it.
*7. Detail BOM can be viewed in tcode CS03 or in report ZBOM.
*8. Latest PO date is applicable for RM/PM to consider latest PO purchase rate for the material.

*&
*&---------------------------------------------------------------------*
REPORT ZMRP_PROGRAM_NEW no standard page heading line-size 400.

tables : pbim,
         pbhi,
         mast,
         stpo,
         makt,
         mara,
         stko,
         mvke,
         tvm5t,
         marm,
         mard,
         resb,
         ekpo,
         eket,
         marc,
         mbew,
         ekko,
         zmrp_data.

type-pools:  slis.

data: g_repid     like sy-repid,
      fieldcat    type slis_t_fieldcat_alv,
      t_eventcat  type slis_t_event,
      w_eventcat  like line of t_eventcat,
      wa_fieldcat like line of fieldcat,
      sort        type slis_t_sortinfo_alv,
      wa_sort     like line of sort,
      layout      type slis_layout_alv.

data : date1(2) type c,
       date2(2) type c,
       date3(4) type c.
data  : date4    type sy-datum,
        date5(2) type c,
        date6    type sy-datum,
        date7    type sy-datum,
        date8    type sy-datum,
        date9    type sy-datum,
        date10   type sy-datum,
        date11   type sy-datum.

data : it_pbed  type table of pbed,
       wa_pbed  type pbed,
       it_pbim  type table of pbim,
       wa_pbim  type pbim,
       it_pbim1 type table of pbim,
       wa_pbim1 type pbim,
       it_pbim2 type table of pbim,
       wa_pbim2 type pbim,
       it_pbed1 type table of pbed,
       wa_pbed1 type pbed,
       it_pbed2 type table of pbed,
       wa_pbed2 type pbed.

data: it_mast type table of mast,
      wa_mast type mast.

data: it_mast1  type table of mast,
      wa_mast1  type mast,
      it_stpo1  type table of stpo,
      wa_stpo1  type stpo,
      it_stas1  type table of stas,
      wa_stas1  type stas,
      it_mast2  type table of mast,
      wa_mast2  type mast,
      it_mast_p type table of mast,
      wa_mast_p type mast,
      it_stpo_p type table of stpo,
      wa_stpo_p type stpo,
      it_stas_p type table of stas,
      wa_stas_p type stas,
      it_mast_r type table of mast,
      wa_mast_r type mast,
      it_stpo_r type table of stpo,
      wa_stpo_r type stpo,
      it_stas_r type table of stas,
      wa_stas_r type stas.



types : begin of itab1,
          matnr  type pbim-matnr,
          werks  type pbim-werks,
          val    type p decimals 3,
          bmeng  type stko-bmeng,
          b1     type p decimals 3,
          plnmg  type pbed-plnmg,
          plnmg1 type pbed-plnmg,
          plnmg2 type pbed-plnmg,
        end of itab1.

types : begin of itab2,
          matnr  type pbim-matnr,
          werks  type pbim-werks,
          val    type p decimals 3,
          bmeng  type stko-bmeng,
          b1     type p decimals 3,
          idnrk  type stpo-idnrk,
          menge  type stpo-menge,
          mtart  type mara-mtart,
          meins  type stpo-meins,
          plnmg  type pbed-plnmg,
          plnmg1 type pbed-plnmg,
          plnmg2 type pbed-plnmg,
          stlal  type mast-stlal,
        end of itab2.

types : begin of itab3,
          matnr  type pbim-matnr,
          werks  type pbim-werks,
          val    type p decimals 3,
          bmeng  type stko-bmeng,
          b1     type p decimals 3,
          idnrk  type stpo-idnrk,
          menge  type stpo-menge,
          mtart  type mara-mtart,
          meins  type stpo-meins,
          plnmg  type pbed-plnmg,
          plnmg1 type pbed-plnmg,
          plnmg2 type pbed-plnmg,
        end of itab3.

types : begin of itab4,
          matnr   type pbim-matnr,

          werks   type pbim-werks,
*  val type p decimals 3,
*   bmeng type stko-bmeng,
*  b1 type p decimals 3,
          idnrk   type stpo-idnrk,
          menge   type stpo-menge,
          mtart   type mara-mtart,
          meins   type stpo-meins,
          req_b1  type p decimals 3,
          req1_b1 type p decimals 3,
          req2_b1 type p decimals 3,
          req3_b1 type p decimals 3,
          req_b2  type p decimals 3,
        end of itab4.

types : begin of itab5,
          matnr   type pbim-matnr,
          werks   type pbim-werks,
          idnrk   type stpo-idnrk,
          menge   type stpo-menge,
          mtart   type mara-mtart,
          meins   type stpo-meins,
          req_b1  type p decimals 3,
          req1_b1 type p decimals 3,
          req2_b1 type p decimals 3,
          req3_b1 type p decimals 3,
          req_b2  type p decimals 3,
          labst   type mard-labst,
          insme   type mard-insme,
          speme   type mard-speme,
          bdmng   type resb-bdmng,
          stock   type mard-labst,
          all_po  type eket-menge,
          plt_po  type eket-menge,
          eisbe   type marc-eisbe,

        end of itab5.

types : begin of itab6,
          matnr      type pbim-matnr,
          werks      type pbim-werks,
          idnrk      type stpo-idnrk,
          menge      type stpo-menge,
          mtart      type mara-mtart,
          meins      type stpo-meins,
          req_b1     type p decimals 3,
          req1_b1    type p decimals 3,
          req2_b1    type p decimals 3,
          req3_b1    type p decimals 3,
          req_b2     type p decimals 3,
          labst      type mard-labst,
          insme      type mard-insme,
          speme      type mard-speme,
          bdmng      type resb-bdmng,
          stock      type mard-labst,
          all_po     type eket-menge,
          plt_po     type eket-menge,
          tot_plan   type p decimals 3,
          net_req1   type p decimals 3,
          net_req1_1 type p decimals 3,
          net_req1_2 type p decimals 3,
          net_req1_3 type p decimals 3,
          net_req2   type p decimals 3,
*          MAKTX      TYPE MAKT-MAKTX,
          maktx(60)  type c,
          eisbe      type marc-eisbe,
          verpr      type mbew-verpr,
          stprs      type mbew-stprs,
          netpr      type ekpo-netpr,
        end of itab6.

types : begin of itab7,
          matnr type pbim-matnr,
          werks type pbim-werks,
          bmeng type stko-bmeng,
          val   type p,
          b1    type p decimals 3,
          mat1  type pbim-matnr,
          stlal type mast-stlal,
        end of itab7.

types : begin of itab8,
          mat1   type pbim-matnr,
          werks  type pbim-werks,
          bmeng  type stko-bmeng,
          bmeng1 type stko-bmeng,
          val    type p,
          b1     type p decimals 3,
          matnr  type mast-matnr,

        end of itab8.

types : begin of itab9,
          mat1   type pbim-matnr,
          werks  type pbim-werks,
          bmeng  type stko-bmeng,
          bmeng1 type stko-bmeng,
          val    type p,
          batch  type p decimals 3,
          b1     type p decimals 3,
          matnr  type mast-matnr,
          hstlal type mast-stlal,
        end of itab9.


types : begin of itab10,
          mat1   type pbim-matnr,
          werks  type pbim-werks,
          bmeng  type stko-bmeng,
          bmeng1 type stko-bmeng,
          val    type p,
          batch  type p decimals 3,
          idnrk  type stpo-idnrk,
          menge  type stpo-menge,
          meins  type stpo-meins,
          mtart  type mara-mtart,
          b1     type p decimals 3,
          matnr  type mast-matnr,
        end of itab10.

types : begin of itab11,
          mat1   type pbim-matnr,
          werks  type pbim-werks,
          bmeng  type stko-bmeng,
          val    type p,
          batch  type p decimals 3,
          idnrk  type stpo-idnrk,
          menge  type stpo-menge,
          meins  type stpo-meins,
          mtart  type mara-mtart,
          req_b1 type p decimals 3,
          req_b2 type p decimals 3,
          b1     type p decimals 3,
        end of itab11.




types : begin of itab12,
          mat1   type pbim-matnr,
          werks  type pbim-werks,
          bmeng  type stko-bmeng,
          val    type p,
          batch  type p decimals 3,
          idnrk  type stpo-idnrk,
          menge  type stpo-menge,
          meins  type stpo-meins,
          mtart  type mara-mtart,
          req_b1 type p decimals 3,
          req_b2 type p decimals 3,
          labst  type mard-labst,
          insme  type mard-insme,
          speme  type mard-speme,
          bdmng  type resb-bdmng,
          stock  type p decimals 3,
          all_po type p decimals 3,
          plt_po type p decimals 2,
          b1     type p decimals 3,
          eisbe  type marc-eisbe,
        end of itab12.


types : begin of itab13,
          mat1     type pbim-matnr,
          werks    type pbim-werks,
          bmeng    type stko-bmeng,
          val      type p,
          batch    type p decimals 3,
          idnrk    type stpo-idnrk,
          menge    type stpo-menge,
          meins    type stpo-meins,
          mtart    type mara-mtart,
          req_b1   type p decimals 3,
          req_b2   type p decimals 3,
          labst    type mard-labst,
          insme    type mard-insme,
          speme    type mard-speme,
          bdmng    type resb-bdmng,
          stock    type p decimals 3,
          all_po   type p decimals 3,
          plt_po   type p decimals 2,
          tot_plan type p decimals 3,
          net_req1 type p decimals 3,
          net_req2 type p   decimals 3,
          maktx    type makt-maktx,
          eisbe    type marc-eisbe,
          verpr    type mbew-verpr,
          stprs    type mbew-stprs,
        end of itab13.

types : begin of itab14,
          werks  type pbim-werks,
          idnrk  type stpo-idnrk,
          menge  type stpo-menge,
          meins1 type stpo-meins,
          bezei  type tvm5t-bezei,
          req_bt type p decimals 3,
*  labst type mard-labst,
          labst  type p decimals 3,
          insme  type mard-insme,
          speme  type mard-speme,
          bdmng  type resb-bdmng,
*  stock type mard-labst,
          stock  type p decimals 3,
          menge1 type mard-labst,
          menge3 type mard-labst,
          tot1   type p decimals 3,
          tot2   type p decimals 3,
          maktx  type makt-maktx,
*   eisbe TYPE marc-eisbe,
        end of itab14.

types : begin of itab15,
          mat1     type pbim-matnr,
          werks    type pbim-werks,
          bmeng    type stko-bmeng,
          val      type p,
          batch    type p decimals 3,
          idnrk    type stpo-idnrk,
          menge    type stpo-menge,
          meins    type stpo-meins,
          mtart    type mara-mtart,
          req_b1   type p decimals 3,
          req_b2   type p decimals 3,
          labst    type mard-labst,
          insme    type mard-insme,
          speme    type mard-speme,
          bdmng    type resb-bdmng,
          stock    type p decimals 3,
          all_po   type p decimals 3,
          plt_po   type p decimals 2,
          tot_plan type p decimals 3,
          net_req1 type p decimals 3,
          net_req2 type p   decimals 3,
          maktx    type makt-maktx,
          eisbe    type marc-eisbe,
          verpr    type mbew-verpr,
          stprs    type mbew-stprs,
*  mov1_val TYPE p DECIMALS 2,
*  mov2_val TYPE p DECIMALS 2,
*  std1_val TYPE p DECIMALS 2,
*  std2_val TYPE p DECIMALS 2,
          meinh    type marm-meinh,
          umrez    type marm-umrez,
        end of itab15.

types : begin of itab16,
          mat1      type pbim-matnr,
          werks     type pbim-werks,
          bmeng     type stko-bmeng,
          val       type p,
          batch     type p decimals 3,
          idnrk     type stpo-idnrk,
          menge     type stpo-menge,
          meins     type stpo-meins,
          mtart     type mara-mtart,
          req_b1    type p decimals 3,
          req_b2    type p decimals 3,
          labst     type mard-labst,
          insme     type mard-insme,
          speme     type mard-speme,
          bdmng     type resb-bdmng,
          stock     type p decimals 3,
          all_po    type p decimals 3,
          plt_po    type p decimals 2,
          tot_plan  type p decimals 3,
          net_req1  type p decimals 3,
          net_req2  type p   decimals 3,
*          MAKTX    TYPE MAKT-MAKTX,
          maktx(60) type c,  "13.6.22
          eisbe     type marc-eisbe,
          verpr     type mbew-verpr,
          stprs     type mbew-stprs,
*  mov1_val TYPE p DECIMALS 2,
*  mov2_val TYPE p DECIMALS 2,
*  std1_val TYPE p DECIMALS 2,
*  std2_val TYPE p DECIMALS 2,
          meinh     type marm-meinh,
          umrez     type marm-umrez,
          pack3     type i,
          pack4     type i,
          mov_val   type p decimals 2,
          std_val   type p decimals 2,
          req2      type p,
          netpr     type ekpo-netpr,
        end of itab16.

types : begin of it1,
          matnr  type pbim-matnr,
          matnr1 type pbim-matnr,
          val    type p,
          bezei  type tvm5t-bezei,
          mvgr5  type mvke-mvgr5,
          umren  type marm-umren,
        end of it1.

types : begin of it2,
          matnr  type pbim-matnr,
          werks  type pbim-werks,
          plnmg  type pbed-plnmg,
*  meins type pbed-meins,
          plnmg1 type pbed-plnmg,
*  meins1 type pbed-meins,
          plnmg2 type pbed-plnmg,
*  meins2 type pbed-meins,
          val    type p decimals 3,
          val1   type p decimals 3,
          val2   type p decimals 3,
          bezei  type tvm5t-bezei,
* bedae type pbim-bedae,
          umren  type marm-umren,
*  d1(10) type c,
*  d2(10) type c,
*  d3(10) type c,
        end of it2.

types : begin of it3,
          matnr  type pbim-matnr,
          werks  type pbim-werks,
          plnmg  type pbed-plnmg,
*  meins type pbed-meins,
          plnmg1 type pbed-plnmg,
*  meins1 type pbed-meins,
          plnmg2 type pbed-plnmg,
*  meins2 type pbed-meins,
          val    type p decimals 3,
          bezei  type tvm5t-bezei,
* bedae type pbim-bedae,
          umren  type marm-umren,
*  d1(10) type c,
*  d2(10) type c,
*  d3(10) type c,
          bmeng  type stko-bmeng,
        end of it3.

types : begin of it4,
          maktx  type makt-maktx,
          matnr  type pbim-matnr,
          werks  type pbim-werks,
          plnmg  type pbed-plnmg,
*  mei,ns type pbed-meins,
          plnmg1 type pbed-plnmg,
*  meins1 type pbed-meins,
          plnmg2 type pbed-plnmg,
*  meins2 type pbed-meins,
          val    type p decimals 3,
          bezei  type tvm5t-bezei,
* bedae type pbim-bedae,
          umren  type marm-umren,
*  d1(10) type c,
*  d2(10) type c,
*  d3(10) type c,
          bmeng  type stko-bmeng,
          b1     type p decimals 3,
          b2     type i,
        end of it4.

types : begin of it5,
          maktx  type makt-maktx,
          matnr  type pbim-matnr,
          werks  type pbim-werks,
          plnmg  type pbed-plnmg,
*  meins type pbed-meins,
          plnmg1 type pbed-plnmg,
*  meins1 type pbed-meins,
          plnmg2 type pbed-plnmg,
*  meins2 type pbed-meins,
          val    type p decimals 3,
          bezei  type tvm5t-bezei,
* bedae type pbim-bedae,
          umren  type marm-umren,
*  d1(10) type c,
*  d2(10) type c,
*  d3(10) type c,
          bmeng  type stko-bmeng,
          b1     type p decimals 3,
          b2     type i,
        end of it5.

types : begin of it6,
          maktx  type makt-maktx,
          matnr  type pbim-matnr,
          werks  type pbim-werks,
          plnmg  type pbed-plnmg,
*  meins type pbed-meins,
          plnmg1 type pbed-plnmg,
*  meins1 type pbed-meins,
          plnmg2 type pbed-plnmg,
*  meins2 type pbed-meins,
          val    type p decimals 3,
          bezei  type tvm5t-bezei,
* bedae type pbim-bedae,
          umren  type marm-umren,
*  d1(10) type c,
*  d2(10) type c,
*  d3(10) type c,
          bmeng  type stko-bmeng,
          b1     type p decimals 3,
          b2     type i,
          bom1   type mast-stlal,
          bom2   type mast-stlal,
          bom3   type mast-stlal,
          bom4   type mast-stlal,

          chk1   type c,
          chk2   type c,
          chk3   type c,
          chk4   type c,

*  bezei TYPE tvm5t-bezei,
        end of it6.

types : begin of it7,
          maktx  type makt-maktx,
          matnr  type pbim-matnr,
          werks  type pbim-werks,
          plnmg  type pbed-plnmg,
*  meins type pbed-meins,
          plnmg1 type pbed-plnmg,
*  meins1 type pbed-meins,
          plnmg2 type pbed-plnmg,
*  meins2 type pbed-meins,
          val    type p decimals 3,
          bezei  type tvm5t-bezei,
* bedae type pbim-bedae,
          umren  type marm-umren,
*  d1(10) type c,
*  d2(10) type c,
*  d3(10) type c,
          bmeng  type stko-bmeng,
          b1     type p decimals 3,
          b2     type i,
*          BOM1   TYPE MAST-STLAL,
*          BOM2   TYPE MAST-STLAL,
*          CHK1   TYPE C,
*          CHK2   TYPE C,
          idnrk  type stpo-idnrk,
          bom    type mast-stlal,

*          BOM1   TYPE MAST-STLAL,
*          BOM2   TYPE MAST-STLAL,
*          BOM3   TYPE MAST-STLAL,
*          BOM4   TYPE MAST-STLAL,
*          BOM5   TYPE MAST-STLAL,
*          BOM6   TYPE MAST-STLAL,
*          CHK1   TYPE C,
*          CHK2   TYPE C,
*          CHK3   TYPE C,
*          CHK4   TYPE C,
*          CHK5   TYPE C,
*          CHK6   TYPE C,
*  bezei TYPE tvm5t-bezei,
        end of it7.

types : begin of it8,
          maktx  type makt-maktx,
          matnr  type pbim-matnr,
          werks  type pbim-werks,
          plnmg  type pbed-plnmg,
*  meins type pbed-meins,
          plnmg1 type pbed-plnmg,
*  meins1 type pbed-meins,
          plnmg2 type pbed-plnmg,
*  meins2 type pbed-meins,
          val    type p decimals 3,
          bezei  type tvm5t-bezei,
* bedae type pbim-bedae,
          umren  type marm-umren,
*  d1(10) type c,
*  d2(10) type c,
*  d3(10) type c,
          bmeng  type stko-bmeng,
          b1     type p decimals 3,
          b2     type i,
*          BOM1   TYPE MAST-STLAL,
*          BOM2   TYPE MAST-STLAL,
*          CHK1   TYPE C,
*          CHK2   TYPE C,

          bom    type mast-stlal,


          hbom1  type mast-stlal,
          hbom2  type mast-stlal,
          hbom3  type mast-stlal,
          hbom4  type mast-stlal,
*          HBOM5  TYPE MAST-STLAL,
*          HBOM6  TYPE MAST-STLAL,
          hchk1  type c,
          hchk2  type c,
          hchk3  type c,
          hchk4  type c,
*          HCHK5  TYPE C,
*          HCHK6  TYPE C,
          idnrk  type stpo-idnrk,
*  bezei TYPE tvm5t-bezei,
        end of it8.

types : begin of bom1,
          matnr type mast-matnr,
          werks type mast-werks,
          stlal type mast-stlal,
        end of bom1.

types : begin of pmbom1,
          matnr  type pbim-matnr,
          werks  type pbim-werks,
          val    type p decimals 3,
          bmeng  type stko-bmeng,
          b1     type p decimals 3,
          plnmg  type pbed-plnmg,
          plnmg1 type pbed-plnmg,
          plnmg2 type pbed-plnmg,
          stlal  type mast-stlal,
        end of pmbom1.

types : begin of pmbom2,
          matnr type pbim-matnr,
          werks type pbim-werks,
          val   type p decimals 3,
          bmeng type stko-bmeng,
          b1    type p decimals 3,
          stlal type mast-stlal,
          idnrk type stpo-idnrk,
        end of pmbom2.

data : it_tab1  type table of itab1,
       wa_tab1  type itab1,
       it_ta1   type table of it1,
       wa_ta1   type it1,
       it_ta2   type table of it2,
       wa_ta2   type it2,
       it_ta3   type table of it3,
       wa_ta3   type it3,
       it_ta4   type table of it4,
       wa_ta4   type it4,
       it_ta5   type table of it5,
       wa_ta5   type it5,
       it_ta6   type table of it6,
       wa_ta6   type it6,
       it_ta7   type table of it7,
       wa_ta7   type it7,
       it_ta8   type table of it8,
       wa_ta8   type it8,
       it_bom1  type table of bom1,
       wa_bom1  type bom1,

       it_tab2  type table of itab2,
       wa_tab2  type itab2,
       it_tab3  type table of itab3,
       wa_tab3  type itab3,
       it_tab4  type table of itab4,
       wa_tab4  type itab4,
       it_tab5  type table of itab5,
       wa_tab5  type itab5,
       it_tab6  type table of itab6,
       wa_tab6  type itab6,
       it_tab7  type table of itab7,
       wa_tab7  type itab7,
       it_tab8  type table of itab8,
       wa_tab8  type itab8,
       it_tab9  type table of itab9,
       wa_tab9  type itab9,
       it_tab10 type table of itab10,
       wa_tab10 type itab10,
       it_tab11 type table of itab11,
       wa_tab11 type itab11,
       it_tab12 type table of itab12,
       wa_tab12 type itab12,
       it_tab13 type table of itab13,
       wa_tab13 type itab13,
       it_tab14 type table of itab14,
       wa_tab14 type itab14,
       it_tab15 type table of itab15,
       wa_tab15 type itab15,
       it_tab16 type table of itab16,
       wa_tab16 type itab16,
       it_marm  type table of marm,
       wa_marm  type marm,
       it_ekpo  type table of ekpo,
       wa_ekpo  type ekpo.

data: maktx1    type makt-maktx,
      maktx2    type makt-maktx,
      normt     type mara-normt,
      maktx(60) type c.

data: it_pmbom1 type table of pmbom1,
      wa_pmbom1 type pmbom1,
      it_pmbom2 type table of pmbom2,
      wa_pmbom2 type pmbom2.

data : val1 type p decimals 2,
       val2 type p decimals 2,
       val3 type p decimals 2,
       val4 type p decimals 2.

data: it_zmrp_data type table of zmrp_data,
      wa_zmrp_data type zmrp_data.


data : w_stlnr  type mast-stlnr,
       w_bmeng  type stko-bmeng,
       w_mat1   type pbim-matnr,
       req_bt   type p decimals 3,
       w_labst  type mard-labst,
       w_insme  type mard-insme,
       w_speme  type mard-speme,
       w_bdmng  type resb-bdmng,
       w_stock  type mard-labst,
       w_menge  type ekpo-menge,
       w_menge1 type ekpo-menge,
       w_menge2 type ekpo-menge,
       w_menge3 type ekpo-menge,
       w_tot1   type p decimals 3,
       w_tot2   type p decimals 3,
       pack1    type stko-bmeng,
       pack2    type i,
       pack3    type i,
       pack4    type p decimals 3,
       mov_val  type p decimals 2,
       std_val  type p decimals 2.



data : d1(10)     type c,
       d2(10)     type c,
       d3(10)     type c,
       batch1     type p decimals 3,
       batch2     type p decimals 3,
       batch3     type p decimals 3,
       batch4     type p decimals 3,
       batch5     type i,
       req_b1     type p decimals 3,
       req1_b1    type p decimals 3,
       req2_b1    type p decimals 3,
       req3_b1    type p decimals 3,
       req_b2     type p decimals 3,
       tot_plan   type p decimals 3,
       net_req1   type p decimals 3,
       net_req1_1 type p decimals 3,
       net_req1_2 type p decimals 3,
       net_req1_3 type p decimals 3,
       net_req2   type p decimals 3,
       a1         type p decimals 3,
       a2         type p decimals 3,
       w_idnrk    type stpo-idnrk.

types: begin of typ_t001w,
         werks type werks_d,
         name1 type name1,
       end of typ_t001w.

data : itab_t001w type table of typ_t001w,
       wa_t001w   type typ_t001w.
data : msg type string.
data: a  type i,
      p1 type i.

data: stlal type mast-stlal.

data: t_ekpo  like standard table of ekpo,
      fs_ekpo like line of t_ekpo.
data: zmrp_data_wa type zmrp_data.
selection-screen begin of block merkmale1 with frame title text-001.
*select-options : material for pbim-matnr NO DISPLAY.
select-options : plant for mard-werks obligatory.
parameters : r1  radiobutton group r1,
             r11 radiobutton group r1.
select-options : splant for mard-werks.
parameters : r2 radiobutton group r1,
             r3 radiobutton group r1,
             r4 radiobutton group r1.
selection-screen end of block merkmale1 .
selection-screen begin of block merkmale2 with frame title text-002.
*SELECT-OPTIONS : R_DATE FOR EKPO-AEDAT.
parameters: r_date1 type sy-datum.
parameters r_date2 type sy-datum default sy-datum.
selection-screen end of block merkmale2 .
*R_DATE-HIGH = SY-DATUM.
at selection-screen .

  perform authorization.

at selection-screen output.
  r_date1 = sy-datum - 360.
*  IF R2 EQ 'X' OR R3 EQ 'X' OR R4 EQ 'X'.
*     R_DATE-HIGH = SY-DATUM.
*     ENDIF.

*  LOOP AT SCREEN.
*    IF SCREEN-NAME = 'R_DATE-LOW'.
*      SCREEN-INPUT = '0'.
*      MODIFY SCREEN.
*    ENDIF.
*    IF SCREEN-NAME = 'R_DATE-HIGH'.
*      SCREEN-INPUT = '0'.
*      MODIFY SCREEN.
*    ENDIF.
*  ENDLOOP.
*
*  IF R2 EQ 'X'.
*
*

*    LOOP AT SCREEN.
*      IF SCREEN-NAME = 'R_DATE-LOW'.
*        SCREEN-INPUT = '1'.
*        MODIFY SCREEN.
*      ENDIF.
*      IF SCREEN-NAME = 'R_DATE-HIGH'.
*        SCREEN-INPUT = '1'.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*  ELSEIF R3 EQ 'X'.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME = 'R_DATE-LOW'.
*        SCREEN-INPUT = '1'.
*        MODIFY SCREEN.
*      ENDIF.
*      IF SCREEN-NAME = 'R_DATE-HIGH'.
*        SCREEN-INPUT = '1'.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*  ELSEIF R4 EQ 'X'.
*    LOOP AT SCREEN.
*      IF SCREEN-NAME = 'R_DATE-LOW'.
*        SCREEN-INPUT = '1'.
*        MODIFY SCREEN.
*      ENDIF.
*      IF SCREEN-NAME = 'R_DATE-HIGH'.
*        SCREEN-INPUT = '1'.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*  ENDIF.


initialization.
  g_repid = sy-repid.



*  AT SELECTION-SCREEN.
*  AUTHORITY-CHECK OBJECT '/DSD/SL_WR'
*           ID 'WERKS' FIELD PLANT.
*
*  If sy-subrc ne 0.
*    MeSG = 'Check your entry'.
*    MESSAGE MESG TYPE 'E'.
*  endif.
start-of-selection.

  if r2 eq 'X' or r3 eq 'X' or r4 eq 'X'.
    if r_date2 lt sy-datum.
      message 'TO DATE IS TILL TODAY''S DATE' type 'E'.
    endif.
    if r_date1 is initial.
      message 'ENTER - FROM  LATEST PO DATE' type 'E'.
    endif.
    if r_date2 is initial.
      message 'ENTER - TO  LATEST PO DATE' type 'E'.
    endif.
  endif.

  clear :it_ekpo,wa_ekpo.

*date1 = sy-datum+6(2).
  date1 = '01'.
  date2 = sy-datum+4(2).
  date3 = sy-datum+0(4).

*WRITE :  / date1,date2,date3.
  date4+6(2) = date1.
  date4+4(2) = date2.
  date4+0(4) = date3.

  date5 = '02'.

  date6+6(2) = date5.
  date6+4(2) = date4+4(2).
  date6+0(4) = date4+0(4).

  date7 = date4 + 31.
  date7+6(2) = date1.
  date8 = date7.
  date8+6(2) = date5.

  date9 = date8 + 31.
  date9+6(2) = date1.

  date10 = date9.
  date10+6(2) = date5.

*  write : / 'MRP FOR CURRENT MONTH + COMING TWO MONTHS'.

*  write : / 'start date of current month: ',date4,'next',date6,date7,date8,date9,date10.

  select * from pbed into table it_pbed where ( pdatu eq date4 or pdatu eq date6 ).
  select * from pbed into table it_pbed1 where ( pdatu eq date7 or pdatu eq date8 ).
  select * from pbed into table it_pbed2 where ( pdatu eq date9 or pdatu eq date10 ).

*select * FROM pbed INto TABLE it_pbed WHERE ( pdatu+4(2) eq date4+4(2) ).
*  if sy-subrc eq 0.
  select * from pbim into table it_pbim for all entries in it_pbed where bdzei eq it_pbed-bdzei and werks in plant.
  select * from pbim into table it_pbim1 for all entries in it_pbed1 where bdzei eq it_pbed1-bdzei and werks in plant.
  select * from pbim into table it_pbim2 for all entries in it_pbed2 where bdzei eq it_pbed2-bdzei and werks in plant.

  sort it_pbed.
  sort it_pbim.

  loop at it_pbim into wa_pbim.

    read table it_pbed into wa_pbed with key bdzei = wa_pbim-bdzei.
    if sy-subrc eq 0.

      wa_ta2-matnr = wa_pbim-matnr.
      wa_ta2-werks = wa_pbim-werks.
*      wa_ta2-bedae = wa_pbim-bedae.
*      clear : d1,d2,d3.
*      write : 'b', wa_pbed-plnmg,wa_pbed-meins,wa_pbed-pdatu.

      wa_ta2-plnmg = wa_pbed-plnmg.
*      wa_ta2-meins = wa_pbed-meins.
*      wa_ta2-pdatu = wa_pbed-pdatu.
      wa_ta2-val = wa_ta2-val + wa_pbed-plnmg.

*      d1 = wa_pbed-pdatu+4(2).
*      d2 = wa_pbed-pdatu+0(4).
*      concatenate d1 ',' d2 into d3.
**      write : d3.
*      wa_ta2-d1 = d3.

    endif.
    collect wa_ta2 into it_ta2.
    clear wa_ta2.

  endloop.


  loop at it_pbim1 into wa_pbim1.

    read table it_pbed1 into wa_pbed1 with key bdzei = wa_pbim1-bdzei.
    if sy-subrc eq 0.
*      clear : d1,d2,d3.

      wa_ta2-matnr = wa_pbim1-matnr.
      wa_ta2-werks = wa_pbim1-werks.
*      wa_ta2-bedae = wa_pbim1-bedae.
*      write : 'c', wa_pbed1-plnmg,wa_pbed1-meins,wa_pbed1-pdatu.

      wa_ta2-plnmg1 = wa_pbed1-plnmg.
*      wa_ta2-meins1 = wa_pbed1-meins.
*      wa_ta2-pdatu1 = wa_pbed1-pdatu.
      wa_ta2-val = wa_ta2-val + wa_pbed1-plnmg.


*      d1 = wa_pbed1-pdatu+4(2).
*      d2 = wa_pbed1-pdatu+0(4).
*      concatenate d1 ',' d2 into d3.
**      write : d3.
*      wa_ta2-d2 = d3.
    endif.

    collect wa_ta2 into it_ta2.
    clear wa_ta2.

  endloop.

  loop at it_pbim2 into wa_pbim2.
    read table it_pbed2 into wa_pbed2 with key bdzei = wa_pbim2-bdzei.
    if sy-subrc eq 0.
*      clear : d1,d2,d3.

      wa_ta2-matnr = wa_pbim2-matnr.
      wa_ta2-werks = wa_pbim2-werks.
*      wa_ta2-bedae = wa_pbim2-bedae.
*      write : 'd', wa_pbed2-plnmg,wa_pbed2-meins,wa_pbed2-pdatu.

      wa_ta2-plnmg2 = wa_pbed2-plnmg.
*      wa_ta2-meins2 = wa_pbed2-meins.
*      wa_ta2-pdatu2 = wa_pbed2-pdatu.
      wa_ta2-val = wa_ta2-val + wa_pbed2-plnmg.


*      d1 = wa_pbed2-pdatu+4(2).
*      d2 = wa_pbed2-pdatu+0(4).
*      concatenate d1 ',' d2 into d3.
**      write : d3.
*      wa_ta2-d3 = d3.

    endif.

    collect wa_ta2 into it_ta2.
    clear wa_ta2.

  endloop.
*  skip.

  if it_ta2 is not initial.
    select * from zmrp_data into table it_zmrp_data for all entries in it_ta2 where matnr eq it_ta2-matnr and werks eq it_ta2-werks.
    sort it_zmrp_data descending by cpudt.
  endif.

  loop at it_ta2 into wa_ta2.
*    write : / 'check',wa_ta2-matnr,wa_ta2-werks,wa_ta2-bedae,wa_ta2-plnmg,wa_ta2-meins,wa_ta2-d1,wa_ta2-plnmg1,wa_ta2-meins1,wa_ta2-d2,
*    wa_ta2-plnmg2,wa_ta2-meins2,wa_ta2-d3,wa_ta2-val.
    wa_ta3-matnr = wa_ta2-matnr.
    wa_ta3-werks = wa_ta2-werks.
*    wa_ta3-bedae = wa_ta2-bedae.
    wa_ta3-plnmg = wa_ta2-plnmg.
*    wa_ta3-meins = wa_ta2-meins.
*    wa_ta3-d1 = wa_ta2-d1.
    wa_ta3-plnmg1 = wa_ta2-plnmg1.
*    wa_ta3-meins1 = wa_ta2-meins1.
*    wa_ta3-d2 = wa_ta2-d2.
    wa_ta3-plnmg2 = wa_ta2-plnmg2.
*    wa_ta3-meins2 = wa_ta2-meins2.
*    wa_ta3-d3 = wa_ta2-d3.
    wa_ta3-val = wa_ta2-val .
*     + wa_ta2-val1 + wa_ta2-val2.

    select single * from mast where matnr eq wa_ta2-matnr and werks eq wa_ta2-werks.
    if sy-subrc eq 0.
      select single * from stko where stlnr eq mast-stlnr
        and stlal eq mast-stlal.  "added on 27.4.23
      if sy-subrc eq 0.
*        write : stko-bmeng.
        wa_ta3-bmeng = stko-bmeng.
*        wa_tab7-val1 =  stko-bmeng.
*        wa_tab7-men1 =  stko-bmein.
      endif.
    endif.

    read table it_zmrp_data into wa_zmrp_data with key matnr = wa_ta2-matnr werks = wa_ta2-werks.
    if sy-subrc eq 0.
      select single * from mast where matnr eq wa_ta2-matnr and werks eq wa_ta2-werks and stlal eq wa_zmrp_data-stlal.
      if sy-subrc eq 0.
        select single * from stko where stlnr eq mast-stlnr  and stlal eq mast-stlal.  "added on 27.4.23
        if sy-subrc eq 0.
*        write : stko-bmeng.
          wa_ta3-bmeng = stko-bmeng.
*        wa_tab7-val1 =  stko-bmeng.
*        wa_tab7-men1 =  stko-bmein.
        endif.
      endif.
    endif.





    collect wa_ta3 into it_ta3.
    clear wa_ta3.
  endloop.


  loop at it_ta3 into wa_ta3.
    clear : batch1,batch2,batch3,batch4,batch5.
*  write : / 'ch',wa_ta3-matnr,wa_ta3-werks,wa_ta3-bedae,wa_ta3-plnmg,wa_ta3-meins,wa_ta3-d1,wa_ta3-plnmg1,wa_ta3-meins1,wa_ta3-d2,
*    wa_ta3-plnmg2,wa_ta3-meins2,wa_ta3-d3,wa_ta3-val,wa_ta3-bmeng.

    select single * from makt where matnr eq wa_ta3-matnr.
    if sy-subrc eq 0.
      wa_ta4-maktx = makt-maktx.
    endif.

    wa_ta4-matnr = wa_ta3-matnr.
    wa_ta4-werks = wa_ta3-werks.
*    wa_ta4-bedae = wa_ta3-bedae.
    wa_ta4-plnmg = wa_ta3-plnmg.
*    wa_ta4-meins = wa_ta3-meins.
*    wa_ta4-d1 = wa_ta3-d1.
    wa_ta4-plnmg1 = wa_ta3-plnmg1.
*    wa_ta4-meins1 = wa_ta3-meins1.
*    wa_ta4-d2 = wa_ta3-d2.
    wa_ta4-plnmg2 = wa_ta3-plnmg2.
*    wa_ta4-meins2 = wa_ta3-meins2.
*    wa_ta4-d3 = wa_ta3-d3.
    wa_ta4-val = wa_ta3-val.
    wa_ta4-bmeng = wa_ta3-bmeng.

    batch1 = wa_ta3-val / wa_ta3-bmeng.
    batch2 = wa_ta3-val mod wa_ta3-bmeng.

    if batch2 gt 0.
      batch3 = wa_ta3-bmeng - batch2.
      batch4 = wa_ta3-val + batch3.
    else.
      batch3 = 0.
      batch4 = wa_ta3-val.
    endif.

    batch5 = batch4 / wa_ta3-bmeng.
*  if batch2 gt 0.
*    batch3 = batch1 + 1.
*  else.
*    batch3 = batch1.
*  endif.
*  WRITE : batch1,batch2,batch3,batch4,batch5.
    wa_ta4-b1 = batch4.
    wa_ta4-b2 = batch5.

    collect wa_ta4 into it_ta4.
    clear wa_ta4.
  endloop.

  loop at it_ta4 into wa_ta4.
*WRITE : / 'check',wa_ta4-plnmg,wa_ta4-plnmg1,wa_ta4-plnmg2.
*    WRITE : / 'a',wa_ta4-matnr.
    wa_tab1-matnr = wa_ta4-matnr.
    wa_tab1-werks = wa_ta4-werks.
    wa_tab1-val = wa_ta4-val.
    wa_tab1-plnmg = wa_ta4-plnmg.
    wa_tab1-plnmg1 = wa_ta4-plnmg1.
    wa_tab1-plnmg2 = wa_ta4-plnmg2.
    wa_tab1-bmeng = wa_ta4-bmeng.
    wa_tab1-b1 = wa_ta4-b1.
    collect wa_tab1 into it_tab1.
    clear wa_tab1.

    wa_ta5-maktx = wa_ta4-maktx.
    wa_ta5-matnr = wa_ta4-matnr.
    wa_ta5-werks = wa_ta4-werks.
*    wa_ta5-bedae = wa_ta4-bedae.
    wa_ta5-plnmg = wa_ta4-plnmg.
*    wa_ta5-meins = wa_ta4-meins.
*    wa_ta5-d1 = wa_ta4-d1.
    wa_ta5-plnmg1 = wa_ta4-plnmg1.
*    wa_ta5-meins1 = wa_ta4-meins1.
*    wa_ta5-d2 = wa_ta4-d2.
    wa_ta5-plnmg2 = wa_ta4-plnmg2.
*    wa_ta5-meins2 = wa_ta4-meins2.
*    wa_ta5-d3 = wa_ta4-d3.
    wa_ta5-val = wa_ta4-val.
    wa_ta5-bmeng = wa_ta4-bmeng.
    wa_ta5-b1 = wa_ta4-b1.
    wa_ta5-b2 = wa_ta4-b2.
    collect wa_ta5 into it_ta5.
    clear wa_ta5.
  endloop.



  if r1 eq 'X'.
    perform fg.
    perform form1.
  elseif r11 eq 'X'.
    perform fg.
    perform sfgbom.
  elseif r2 eq 'X'.
    perform raw.
  elseif r3 eq 'X'.
    perform pack.
  elseif r4 eq 'X'.
    perform pack1.
  endif.


*&---------------------------------------------------------------------*
*&      Form  FORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form form1.

  loop at it_ta6 into wa_ta6.
    pack wa_ta6-matnr to wa_ta6-matnr.
    condense : wa_ta6-matnr.
    modify it_ta6 from wa_ta6 transporting matnr.
  endloop.


  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_s = 'MATERIAL'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'MAKTX'.
  wa_fieldcat-seltext_s = 'PRODUCT'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'BEZEI'.
  wa_fieldcat-seltext_s = 'PACK SIZE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'WERKS'.
  wa_fieldcat-seltext_s = 'PLANT'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

*  wa_fieldcat-fieldname = 'BEDAE'.
*  wa_fieldcat-seltext_s = 'TYPE'.
*  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'PLNMG'.
  wa_fieldcat-seltext_s = 'QTY1'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

*  wa_fieldcat-fieldname = 'MEINS'.
*  wa_fieldcat-seltext_s = 'UNIT'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'D1'.
*  wa_fieldcat-seltext_s = 'MONTH1'.
*  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'PLNMG1'.
  wa_fieldcat-seltext_s = 'QTY2'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

*  wa_fieldcat-fieldname = 'MEINS1'.
*  wa_fieldcat-seltext_s = 'UNIT2'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'D2'.
*  wa_fieldcat-seltext_s = 'MONTH2'.
*  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'PLNMG2'.
  wa_fieldcat-seltext_s = 'QTY3'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

*  wa_fieldcat-fieldname = 'MEINS2'.
*  wa_fieldcat-seltext_s = 'UNIT3'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'D3'.
*  wa_fieldcat-seltext_s = 'MONTH3'.
*  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'VAL'.
  wa_fieldcat-seltext_s = 'REQ. QTY'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'BMENG'.
  wa_fieldcat-seltext_s = 'STD. BATCH SIZE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'B1'.
  wa_fieldcat-seltext_s = 'MOD. REQ QTY'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'B2'.
  wa_fieldcat-seltext_s = 'NO. OF BATCHES'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'BOM1'.
  wa_fieldcat-seltext_s = 'BOM1'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'CHK1'.
  wa_fieldcat-seltext_l = 'SELECT BOM1'.
  wa_fieldcat-checkbox = 'X'.
  if ( r1 eq 'X' or r11 eq 'X' ) and sy-uname eq 'ITBOM01' or sy-uname eq 'MMPURNSK01'.
    wa_fieldcat-edit = 'X'.
  elseif ( r1 eq 'X' or r11 eq 'X' ) and sy-uname eq 'ITBOM01' or sy-uname eq 'MMPURGOA01'.
    wa_fieldcat-edit = 'X'.
  endif.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.


  wa_fieldcat-fieldname = 'BOM2'.
  wa_fieldcat-seltext_s = 'BOM2'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'CHK2'.
  wa_fieldcat-seltext_l = 'SELECT BOM2'.
  wa_fieldcat-checkbox = 'X'.
  if ( r1 eq 'X' or r11 eq 'X' ) and sy-uname eq 'ITBOM01' or sy-uname eq 'MMPURNSK01'.
    wa_fieldcat-edit = 'X'.
  elseif ( r1 eq 'X' or r11 eq 'X' )  and sy-uname eq 'ITBOM01' or sy-uname eq 'MMPURGOA01'.
    wa_fieldcat-edit = 'X'.
  endif.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'BOM3'.
  wa_fieldcat-seltext_s = 'BOM3'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'CHK3'.
  wa_fieldcat-seltext_l = 'SELECT BOM3'.
  wa_fieldcat-checkbox = 'X'.
  if ( r1 eq 'X' or r11 eq 'X' ) and sy-uname eq 'ITBOM01' or sy-uname eq 'MMPURNSK01'.
    wa_fieldcat-edit = 'X'.
  elseif ( r1 eq 'X' or r11 eq 'X' )  and sy-uname eq 'ITBOM01' or sy-uname eq 'MMPURGOA01'.
    wa_fieldcat-edit = 'X'.
  endif.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'BOM4'.
  wa_fieldcat-seltext_s = 'OTHR BOM'.
  if ( r1 eq 'X' or r11 eq 'X' ) and sy-uname eq 'ITBOM01' or sy-uname eq 'MMPURNSK01'.
    wa_fieldcat-edit = 'X'.
  elseif ( r1 eq 'X' or r11 eq 'X' )  and sy-uname eq 'ITBOM01' or sy-uname eq 'MMPURGOA01'.
    wa_fieldcat-edit = 'X'.
  endif.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'CHK4'.
  wa_fieldcat-seltext_l = 'SELECT'.
  wa_fieldcat-checkbox = 'X'.
  if ( r1 eq 'X' or r11 eq 'X' ) and sy-uname eq 'ITBOM01' or sy-uname eq 'MMPURNSK01'.
    wa_fieldcat-edit = 'X'.
  elseif ( r1 eq 'X' or r11 eq 'X' )  and sy-uname eq 'ITBOM01' or sy-uname eq 'MMPURGOA01'.
    wa_fieldcat-edit = 'X'.
  endif.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.


  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'MRP FOR CURRENT MONTH + COMING 2 MONTHS'.


  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = g_repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
      i_callback_user_command = 'USER_COMM1'
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
      t_outtab                = it_ta6
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.



endform.                                                    "FORM1


*&---------------------------------------------------------------------*
*&      Form  PACK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form pack.

  loop at it_tab1 into wa_tab1.
    wa_pmbom1-matnr = wa_tab1-matnr.
    wa_pmbom1-werks = wa_tab1-werks.
    wa_pmbom1-val = wa_tab1-val.
    wa_pmbom1-bmeng = wa_tab1-bmeng.
    wa_pmbom1-b1 = wa_tab1-b1.
    clear stlal.
    select single * from zmrp_data where matnr eq wa_tab1-matnr and werks eq wa_tab1-werks and zmonth eq sy-datum+4(2) and zyear eq sy-datum+0(4).
    if sy-subrc eq 0.
      stlal = zmrp_data-stlal.
    endif.
    if stlal eq space .
      stlal = '01'.
    endif.
    select single * from mast where matnr eq wa_tab1-matnr and werks eq wa_tab1-werks and stlal eq stlal.
    if sy-subrc eq 0.
      select single * from stko where stlnr eq mast-stlnr and stlal = mast-stlal and loekz eq space.
      if sy-subrc eq 0.
        wa_pmbom1-stlal = stlal.
        collect wa_pmbom1 into it_pmbom1.
        clear wa_pmbom1.
      endif.
    endif.

  endloop.

  if it_pmbom1 is not initial.
    select * from mast into table it_mast_p for all entries in it_pmbom1 where matnr eq it_pmbom1-matnr and werks eq it_pmbom1-werks and stlan eq 1
    and stlal eq it_pmbom1-stlal.
    if sy-subrc eq 0.
      select * from stas into table it_stas_p for all entries in it_mast_p where stlnr eq it_mast_p-stlnr and stlal eq it_mast_p-stlal.
      if sy-subrc eq 0.
        select * from stpo into table it_stpo_p for all entries in it_stas_p where stlnr eq it_stas_p-stlnr and stlkn eq it_stas_p-stlkn.
      endif.
    endif.
  endif.

*  LOOP AT IT_PMBOM1 INTO WA_PMBOM1.
*    WA_PMBOM2-MATNR = WA_PMBOM1-MATNR.
*    WA_PMBOM2-WERKS = WA_PMBOM1-WERKS.
*    WA_PMBOM2-STLAL = WA_PMBOM1-STLAL.
*    WA_PMBOM2-VAL = WA_PMBOM1-VAL.
*    WA_PMBOM2-BMENG = WA_PMBOM1-BMENG.
*    WA_PMBOM2-B1 = WA_PMBOM1-B1.
*    READ TABLE IT_MAST_P INTO WA_MAST_P WITH KEY MATNR = WA_PMBOM1-MATNR WERKS = WA_PMBOM1-WERKS STLAN = 1 STLAL = WA_PMBOM1-STLAL.
*    IF SY-SUBRC EQ 0.
*      LOOP AT IT_STAS_P INTO WA_STAS_P WHERE STLNR = WA_MAST_P-STLNR AND STLAL = WA_MAST_P-STLAL.
*        LOOP AT IT_STPO_P INTO WA_STPO_P WHERE STLNR = WA_STAS_P-STLNR AND STLKN = WA_STAS_P-STLKN.
*          WA_PMBOM2-IDNRK = WA_STPO_P-IDNRK.
*          COLLECT WA_PMBOM2 INTO IT_PMBOM2.
*          CLEAR WA_PMBOM2.
*        ENDLOOP.
*      ENDLOOP.
*    ENDIF.
*  ENDLOOP.

  loop at it_pmbom1 into wa_pmbom1.

    read table it_mast_p into wa_mast_p with key matnr = wa_pmbom1-matnr werks = wa_pmbom1-werks stlan = 1 stlal = wa_pmbom1-stlal.
    if sy-subrc eq 0.
      loop at it_stas_p into wa_stas_p where stlnr = wa_mast_p-stlnr and stlal = wa_mast_p-stlal.
        loop at it_stpo_p into wa_stpo_p where stlnr = wa_stas_p-stlnr and stlkn = wa_stas_p-stlkn.
          select single * from marc where matnr eq wa_stpo_p-idnrk and werks eq wa_mast_p-werks and lvorm eq space.
          if sy-subrc eq 0.
            wa_tab2-matnr = wa_pmbom1-matnr.
            wa_tab2-werks = wa_pmbom1-werks.
            wa_tab2-stlal = wa_pmbom1-stlal.
            wa_tab2-val = wa_pmbom1-val.
            wa_tab2-bmeng = wa_pmbom1-bmeng.
            wa_tab2-b1 = wa_pmbom1-b1.
            wa_tab2-idnrk = wa_stpo_p-idnrk.
            wa_tab2-menge = wa_stpo_p-menge.
            wa_tab2-meins = wa_stpo_p-meins.
            select single * from mara where matnr eq wa_stpo_p-idnrk.
            if sy-subrc eq 0.
              wa_tab2-mtart = mara-mtart.
            endif.
            collect wa_tab2 into it_tab2.
            clear wa_tab2.
          else.
            format color 6.
            write : / 'DELETEION INDICATOR FOR ',wa_stpo_p-idnrk.
            skip.
            skip.
          endif.

        endloop.
      endloop.
    endif.
  endloop.

*  LOOP AT IT_PMBOM2 INTO WA_PM

*  LOOP AT IT_TAB1 INTO WA_TAB1.
*
*    WRITE : / WA_TAB1-MATNR, WA_TAB1-WERKS,WA_TAB1-VAL,WA_TAB1-BMENG, WA_TAB1-B1.
*
*    CLEAR STLAL.
*    SELECT SINGLE * FROM ZMRP_DATA WHERE MATNR EQ WA_TAB1-MATNR AND WERKS EQ WA_TAB1-WERKS AND ZMONTH EQ SY-DATUM+4(2) AND ZYEAR EQ SY-DATUM+0(4).
*    IF SY-SUBRC EQ 0.
*      STLAL = ZMRP_DATA-STLAL.
*    ENDIF.
*    IF STLAL EQ SPACE .
*      STLAL = '01'.
*    ENDIF.
*    SELECT SINGLE * FROM MAST WHERE MATNR EQ WA_TAB1-MATNR AND WERKS EQ WA_TAB1-WERKS AND STLAN EQ 1 AND STLAL EQ STLAL.
*    IF SY-SUBRC EQ 0.  " 7.10.20
*
**      SELECT SINGLE * FROM MAST WHERE MATNR EQ WA_TAB1-MATNR AND WERKS EQ WA_TAB1-WERKS..
**      IF SY-SUBRC EQ 0.
*      SELECT * FROM STPO WHERE STLNR EQ MAST-STLNR.
*        IF SY-SUBRC EQ 0.
**          write : / stpo-idnrk,stpo-menge.
*
*          WA_TAB2-MATNR = WA_TAB1-MATNR.
*          WA_TAB2-WERKS = WA_TAB1-WERKS.
*          WA_TAB2-VAL = WA_TAB1-VAL.
*          WA_TAB2-BMENG = WA_TAB1-BMENG.
*          WA_TAB2-B1 = WA_TAB1-B1.
*
*          WA_TAB2-IDNRK = STPO-IDNRK.
*          WA_TAB2-MENGE = STPO-MENGE.
*          WA_TAB2-MEINS = STPO-MEINS.
*
*          SELECT SINGLE * FROM MARA WHERE MATNR EQ STPO-IDNRK.
*          IF SY-SUBRC EQ 0.
**            write : mara-mtart.
*            WA_TAB2-MTART = MARA-MTART.
*
*          ENDIF.
*          COLLECT WA_TAB2 INTO IT_TAB2.
*          CLEAR WA_TAB2.
*        ENDIF.
*      ENDSELECT.
*    ENDIF.
*
*  ENDLOOP.

*  LOOP AT IT_TAB2 INTO WA_TAB2.
*    WRITE:/ 'A',WA_TAB2-MATNR,WA_TAB2-WERKS,WA_TAB2-VAL,WA_TAB2-BMENG,WA_TAB2-B1,WA_TAB2-IDNRK,WA_TAB2-MENGE,WA_TAB2-MEINS,WA_TAB2-MTART.
*  ENDLOOP.
*  uline.
************************************************************************************
  loop at it_tab2 into wa_tab2.
*    write : / wa_tab2-matnr, wa_tab2-werks,wa_tab2-val,wa_tab2-bmeng, wa_tab2-b1.
*    write :  wa_tab2-idnrk,wa_tab2-menge,wa_tab2-meins,wa_tab2-mtart.
    if wa_tab2-mtart ne 'ZHLB'.
      wa_tab3-matnr = wa_tab2-matnr.
      wa_tab3-werks = wa_tab2-werks.
      wa_tab3-val = wa_tab2-val.
      wa_tab3-bmeng = wa_tab2-bmeng.
      wa_tab3-b1 = wa_tab2-b1.
      wa_tab3-idnrk = wa_tab2-idnrk.
      wa_tab3-menge = wa_tab2-menge.
      wa_tab3-meins = wa_tab2-meins.
      wa_tab3-mtart = wa_tab2-mtart.
      collect wa_tab3 into it_tab3.
      clear wa_tab3.
    endif.

  endloop.

  loop at it_tab3 into wa_tab3.
*    write : /'A', wa_tab3-matnr, wa_tab3-werks,wa_tab3-val,wa_tab3-bmeng, wa_tab3-b1.
*    write :  wa_tab3-idnrk,wa_tab3-menge,wa_tab3-meins,wa_tab3-mtart.
    req_b1 = ( wa_tab3-val * wa_tab3-menge ) / wa_tab3-bmeng.
    req_b2 = ( wa_tab3-b1 * wa_tab3-menge ) / wa_tab3-bmeng.
*    write : req_b1,req_b2.

*      WA_TAB4-matnr = WA_TAB3-matnr.
    wa_tab4-werks = wa_tab3-werks.
*      WA_TAB4-val = WA_TAB3-val.
*      WA_TAB4-bmeng = WA_TAB3-bmeng.
*      WA_TAB4-b1 = WA_TAB3-b1.
    wa_tab4-idnrk = wa_tab3-idnrk.
    wa_tab4-menge = wa_tab3-menge.
    wa_tab4-meins = wa_tab3-meins.
    wa_tab4-mtart = wa_tab3-mtart.
    wa_tab4-req_b1 = req_b1.
    wa_tab4-req_b2 = req_b2.

    collect wa_tab4 into it_tab4.
    clear wa_tab4.
  endloop.
*uline.
  sort it_tab4 by idnrk werks.

  loop at it_tab4 into wa_tab4.
    clear : w_menge,w_menge1,w_menge2,w_menge3.
    clear : w_labst,w_insme,w_speme,w_bdmng,w_stock.

*    write : /'f', wa_tab4-werks,wa_tab4-idnrk,wa_tab4-menge,wa_tab4-meins,wa_tab4-mtart,wa_tab4-req_b1,wa_tab4-req_b2..

    wa_tab5-werks = wa_tab4-werks.
    wa_tab5-idnrk = wa_tab4-idnrk.
    wa_tab5-menge = wa_tab4-menge.
    wa_tab5-meins = wa_tab4-meins.
    wa_tab5-mtart = wa_tab4-mtart.
    wa_tab5-req_b1 = wa_tab4-req_b1.
    wa_tab5-req_b2 = wa_tab4-req_b2.

****************SAFETY STOCK*************************

    select single * from marc where matnr eq wa_tab5-idnrk and werks eq wa_tab5-werks.
    if sy-subrc eq 0.
      wa_tab5-eisbe = marc-eisbe.
    endif.

***************for stock************
    if splant is initial.
      select * from mard where matnr eq wa_tab4-idnrk and werks eq wa_tab4-werks.
        if sy-subrc eq 0.
*        write : / 'b',mard-labst.
          w_labst = w_labst + mard-labst.
          w_insme = w_insme + mard-insme.
          w_speme = w_speme + mard-speme.
        endif.
      endselect.
    else.
      select * from mard where matnr eq wa_tab4-idnrk and werks in splant.  "stock merging for Goa 1001 & 2024 plant 8.4.21
        if sy-subrc eq 0.
*        write : / 'b',mard-labst.
          w_labst = w_labst + mard-labst.
          w_insme = w_insme + mard-insme.
          w_speme = w_speme + mard-speme.
        endif.
      endselect.
    endif.

*    write :  w_labst,w_insme,w_speme.
    wa_tab5-labst = w_labst.
    wa_tab5-insme = w_insme.
    wa_tab5-speme = w_speme.

    select *  from resb  where matnr = wa_tab4-idnrk and werks = wa_tab4-werks and kzear ne 'X'  and xloek ne 'X' and bdart  = 'AR'
        and charg  ne '         '.
      if sy-subrc eq 0.
*        WRITE : / resb-bdmng.
        w_bdmng =  w_bdmng + resb-bdmng.
      else.
        w_bdmng = 0.
      endif.
    endselect.

*    write : w_bdmng.
    wa_tab5-bdmng = w_bdmng.

    w_stock = w_labst - w_bdmng.
*    write : w_stock.
    wa_tab5-stock = w_stock.
*************pending po*************

    select * from ekpo where matnr eq wa_tab4-idnrk and elikz ne 'X' and loekz eq ' ' and statu ne 'A'..
      if sy-subrc eq 0.
*        write : / ekpo-ebeln,EKPO-EBELP,ekpo-matnr,ekpo-menge.
        select * from eket where ebeln eq ekpo-ebeln and ebelp eq ekpo-ebelp.
          if sy-subrc eq 0.
*            WRITE : / 'AA', EKET-EBELN,EKET-MENGE,EKET-WEMNG.
            w_menge = eket-menge - eket-wemng.
            w_menge1 = w_menge + w_menge1.
          endif.
        endselect.
      endif.
    endselect.

*    write :  w_menge1.

    wa_tab5-all_po = w_menge1.


    select * from ekpo where matnr eq wa_tab4-idnrk and elikz ne 'X' and werks eq wa_tab4-werks and loekz eq ' ' and statu ne 'A'.
      if sy-subrc eq 0.
*        write : / ekpo-ebeln,EKPO-EBELP,ekpo-matnr,ekpo-menge.
        select * from eket where ebeln eq ekpo-ebeln and ebelp eq ekpo-ebelp.
          if sy-subrc eq 0.
*            WRITE : EKET-MENGE,EKET-WEMNG.
            w_menge2 = eket-menge - eket-wemng.
            w_menge3 = w_menge2 + w_menge3.
          endif.
        endselect.
      endif.
    endselect.
*    write : w_menge3.
    wa_tab5-plt_po = w_menge3.

    collect wa_tab5 into it_tab5.
    clear wa_tab5.
  endloop.
*uline.
  clear :it_ekpo,wa_ekpo.
  select * from ekpo into table it_ekpo for all entries in it_tab5 where matnr eq it_tab5-idnrk and aedat ge r_date1 and aedat le r_date2
  and werks eq it_tab5-werks and statu eq ' ' and loekz ne 'L'.
  sort it_ekpo descending.

  loop at it_tab5 into wa_tab5.
    clear : tot_plan,net_req1,net_req2.
*    write : / wa_tab5-werks,wa_tab5-idnrk,wa_tab5-menge,wa_tab5-meins,wa_tab5-mtart,wa_tab5-req_b1,wa_tab5-req_b2..
*    write :  wa_tab5-labst,wa_tab5-insme,wa_tab5-speme,wa_tab5-bdmng,wa_tab5-stock.
*    write :  wa_tab5-all_po,wa_tab5-plt_po.

    tot_plan = wa_tab5-stock + wa_tab5-eisbe + wa_tab5-insme + wa_tab5-plt_po.
    net_req1 = wa_tab5-req_b1 - tot_plan.
    net_req2 = wa_tab5-req_b2 - tot_plan.

*WRITE : TOT_PLAN,NET_REQ1,NET_REQ2.

    wa_tab6-werks = wa_tab5-werks.
    wa_tab6-idnrk = wa_tab5-idnrk.
    wa_tab6-menge = wa_tab5-menge.
    wa_tab6-meins = wa_tab5-meins.
    wa_tab6-mtart = wa_tab5-mtart.
    wa_tab6-req_b1 = wa_tab5-req_b1.
    wa_tab6-req_b2 = wa_tab5-req_b2.
    wa_tab6-labst = wa_tab5-labst.
    wa_tab6-insme = wa_tab5-insme.
    wa_tab6-speme = wa_tab5-speme.
    wa_tab6-bdmng = wa_tab5-bdmng.
    wa_tab6-stock = wa_tab5-stock.
    wa_tab6-eisbe = wa_tab5-eisbe.

*    SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_TAB5-IDNRK.
*    IF SY-SUBRC EQ 0.
**        WRITE : MAKT-MAKTX.
*      WA_TAB6-MAKTX = MAKT-MAKTX.
*    ENDIF.
    clear : maktx1,maktx2,normt,maktx.

    select single * from makt where matnr eq wa_tab5-idnrk and spras = sy-langu.
    if sy-subrc eq 0.
      maktx1 = makt-maktx.
    endif.
    select single * from makt where matnr eq wa_tab5-idnrk and spras eq 'Z1'.
    if sy-subrc eq 0.
      maktx2 = makt-maktx.
    endif.
    select single * from mara where matnr eq wa_tab5-idnrk.
    if sy-subrc eq 0.
      normt = mara-normt.
    endif.
    concatenate maktx1 maktx2 normt into maktx separated by space.
    wa_tab6-maktx = maktx.

    select single * from mbew where matnr eq wa_tab5-idnrk and bwkey eq wa_tab5-werks.
    if sy-subrc eq 0.
      wa_tab6-verpr = mbew-verpr.
      wa_tab6-stprs = mbew-stprs.
    endif.

*      write :  wa_tab5-labst,wa_tab5-insme,wa_tab5-speme,wa_tab5-bdmng,wa_tab5-stock.

    wa_tab6-all_po = wa_tab5-all_po.
    wa_tab6-plt_po = wa_tab5-plt_po.
    wa_tab6-tot_plan = tot_plan.
    wa_tab6-net_req1 = net_req1.
    wa_tab6-net_req2 = net_req2.

*LOOP at it_ekpo INTO wa_ekpo.
*  WRITE : / 'new',wa_ekpo-matnr,wa_ekpo-netpr.
*endloop.
    read table it_ekpo into wa_ekpo with key matnr = wa_tab5-idnrk werks = wa_tab5-werks .
    if sy-subrc eq 0.
*    WRITE : / 'chek here',wa_tab5-idnrk,wa_ekpo-netpr.
      wa_tab6-netpr = wa_ekpo-netpr.
    endif.

    collect wa_tab6 into it_tab6.
    clear wa_tab6.
  endloop.

  loop at it_tab6 into wa_tab6.
    format color 2.
*    WRITE : /1(40) WA_TAB6-MAKTX,42(10) WA_TAB6-IDNRK,54(3) WA_TAB6-MEINS,59(12) WA_TAB6-LABST,73(12) WA_TAB6-INSME,
*    87(12) WA_TAB6-PLT_PO, 102(12) WA_TAB6-REQ_B1,116(12) WA_TAB6-NET_REQ1, 130(12) WA_TAB6-NETPR,144(12) WA_TAB6-VERPR,
*    158(12) WA_TAB6-MENGE,172(12) WA_TAB6-TOT_PLAN,184(12) WA_TAB6-EISBE,198(12) WA_TAB6-STOCK,212(12) WA_TAB6-BDMNG,
*    226(12) WA_TAB6-SPEME,238(12) WA_TAB6-NET_REQ2.
    write : /1(55) wa_tab6-maktx,57(10) wa_tab6-idnrk,69(3) wa_tab6-meins,74(12) wa_tab6-labst,88(12) wa_tab6-insme,
   102(12) wa_tab6-plt_po, 117(12) wa_tab6-req_b1,131(12) wa_tab6-net_req1, 145(12) wa_tab6-netpr,159(12) wa_tab6-verpr,
   173(12) wa_tab6-menge,187(12) wa_tab6-tot_plan,199(12) wa_tab6-eisbe,213(12) wa_tab6-stock,227(12) wa_tab6-bdmng,
   241(12) wa_tab6-speme,253(12) wa_tab6-net_req2.

  endloop.
  clear : it_ekpo,wa_ekpo.

endform.                    "PACK

*&---------------------------------------------------------------------*
*&      Form  pack1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form pack1.

*  LOOP AT IT_TAB1 INTO WA_TAB1.
*
**    write : /'b', wa_tab1-matnr, wa_tab1-werks,wa_tab1-plnmg,wa_tab1-plnmg1,wa_tab1-plnmg2,wa_tab1-val,wa_tab1-bmeng, wa_tab1-b1.
*    SELECT SINGLE * FROM MAST WHERE MATNR EQ WA_TAB1-MATNR AND WERKS EQ WA_TAB1-WERKS.
*    IF SY-SUBRC EQ 0.
*      SELECT * FROM STPO WHERE STLNR EQ MAST-STLNR.
*        IF SY-SUBRC EQ 0.
**          write : / stpo-idnrk,stpo-menge.
*
*          WA_TAB2-MATNR = WA_TAB1-MATNR.
*          WA_TAB2-WERKS = WA_TAB1-WERKS.
*          WA_TAB2-VAL = WA_TAB1-VAL.
*          WA_TAB2-PLNMG = WA_TAB1-PLNMG.
*          WA_TAB2-PLNMG1 = WA_TAB1-PLNMG1.
*          WA_TAB2-PLNMG2 = WA_TAB1-PLNMG2.
*          WA_TAB2-BMENG = WA_TAB1-BMENG.
*          WA_TAB2-B1 = WA_TAB1-B1.
*          WA_TAB2-IDNRK = STPO-IDNRK.
*          WA_TAB2-MENGE = STPO-MENGE.
*          WA_TAB2-MEINS = STPO-MEINS.
*
*          SELECT SINGLE * FROM MARA WHERE MATNR EQ STPO-IDNRK.
*          IF SY-SUBRC EQ 0.
**            write : mara-mtart.
*            WA_TAB2-MTART = MARA-MTART.
*
*          ENDIF.
*          COLLECT WA_TAB2 INTO IT_TAB2.
*          CLEAR WA_TAB2.
*        ENDIF.
*      ENDSELECT.
*    ENDIF.
*
*  ENDLOOP.
**  uline.




  loop at it_tab1 into wa_tab1.
    wa_pmbom1-matnr = wa_tab1-matnr.
    wa_pmbom1-werks = wa_tab1-werks.
    wa_pmbom1-val = wa_tab1-val.
    wa_pmbom1-plnmg = wa_tab1-plnmg.
    wa_pmbom1-plnmg1 = wa_tab1-plnmg1.
    wa_pmbom1-plnmg2 = wa_tab1-plnmg2.
    wa_pmbom1-bmeng = wa_tab1-bmeng.
    wa_pmbom1-b1 = wa_tab1-b1.
    clear stlal.
    select single * from zmrp_data where matnr eq wa_tab1-matnr and werks eq wa_tab1-werks and zmonth eq sy-datum+4(2) and zyear eq sy-datum+0(4).
    if sy-subrc eq 0.
      stlal = zmrp_data-stlal.
    endif.
    if stlal eq space .
      stlal = '01'.
    endif.

    select single * from mast where matnr eq wa_tab1-matnr and werks eq wa_tab1-werks and stlal eq stlal.
    if sy-subrc eq 0.
      select single * from stko where stlnr eq mast-stlnr and stlal = mast-stlal and loekz eq space.
      if sy-subrc eq 0.
        wa_pmbom1-stlal = stlal.
        collect wa_pmbom1 into it_pmbom1.
        clear wa_pmbom1.
      endif.
    endif.
  endloop.


  if it_pmbom1 is not initial.
    select * from mast into table it_mast_p for all entries in it_pmbom1 where matnr eq it_pmbom1-matnr and werks eq it_pmbom1-werks and stlan eq 1
    and stlal eq it_pmbom1-stlal.
    if sy-subrc eq 0.
      select * from stas into table it_stas_p for all entries in it_mast_p where stlnr eq it_mast_p-stlnr and stlal eq it_mast_p-stlal.
      if sy-subrc eq 0.
        select * from stpo into table it_stpo_p for all entries in it_stas_p where stlnr eq it_stas_p-stlnr and stlkn eq it_stas_p-stlkn.
      endif.
    endif.
  endif.

  loop at it_pmbom1 into wa_pmbom1.

    read table it_mast_p into wa_mast_p with key matnr = wa_pmbom1-matnr werks = wa_pmbom1-werks stlan = 1 stlal = wa_pmbom1-stlal.
    if sy-subrc eq 0.
      loop at it_stas_p into wa_stas_p where stlnr = wa_mast_p-stlnr and stlal = wa_mast_p-stlal.
        loop at it_stpo_p into wa_stpo_p where stlnr = wa_stas_p-stlnr and stlkn = wa_stas_p-stlkn.
          select single * from marc where matnr eq wa_stpo_p-idnrk and werks eq wa_mast_p-werks and lvorm eq space.
          if sy-subrc eq 0.
            wa_tab2-matnr = wa_pmbom1-matnr.
            wa_tab2-werks = wa_pmbom1-werks.
            wa_tab2-stlal = wa_pmbom1-stlal.
            wa_tab2-val = wa_pmbom1-val.
            wa_tab2-bmeng = wa_pmbom1-bmeng.
            wa_tab2-b1 = wa_pmbom1-b1.
            wa_tab2-plnmg = wa_pmbom1-plnmg.
            wa_tab2-plnmg1 = wa_pmbom1-plnmg1.
            wa_tab2-plnmg2 = wa_pmbom1-plnmg2.
            wa_tab2-idnrk = wa_stpo_p-idnrk.
            wa_tab2-menge = wa_stpo_p-menge.
            wa_tab2-meins = wa_stpo_p-meins.
            select single * from mara where matnr eq wa_stpo_p-idnrk.
            if sy-subrc eq 0.
              wa_tab2-mtart = mara-mtart.
            endif.
            collect wa_tab2 into it_tab2.
            clear wa_tab2.
          else.
            format color 6.
            write : / 'DELETION INDICATOR FOR',wa_stpo_p-idnrk.
            skip.
            skip.
          endif.
        endloop.
      endloop.
    endif.
  endloop.

***********************************


  loop at it_tab2 into wa_tab2.
**    write : /'b', wa_tab2-matnr, wa_tab2-werks,wa_tab2-val,wa_tab2-plnmg,wa_tab2-plnmg1,wa_tab2-plnmg2,wa_tab2-bmeng, wa_tab2-b1.
**    write :  wa_tab2-idnrk,wa_tab2-menge,wa_tab2-meins,wa_tab2-mtart.
    if wa_tab2-mtart ne 'ZHLB'.
      wa_tab3-matnr = wa_tab2-matnr.
      wa_tab3-werks = wa_tab2-werks.
      wa_tab3-val = wa_tab2-val.
      wa_tab3-plnmg = wa_tab2-plnmg.
      wa_tab3-plnmg1 = wa_tab2-plnmg1.
      wa_tab3-plnmg2 = wa_tab2-plnmg2.
      wa_tab3-bmeng = wa_tab2-bmeng.
      wa_tab3-b1 = wa_tab2-b1.
      wa_tab3-idnrk = wa_tab2-idnrk.
      wa_tab3-menge = wa_tab2-menge.
      wa_tab3-meins = wa_tab2-meins.
      wa_tab3-mtart = wa_tab2-mtart.
      collect wa_tab3 into it_tab3.
      clear wa_tab3.
    endif.

  endloop.

  loop at it_tab3 into wa_tab3.
*    write : /'A', wa_tab3-matnr, wa_tab3-werks,wa_tab3-val,wa_tab3-plnmg,wa_tab3-plnmg1,wa_tab3-plnmg2,wa_tab3-bmeng,'g', wa_tab3-b1.
*    write :  wa_tab3-idnrk,wa_tab3-menge,wa_tab3-meins,wa_tab3-mtart.
    req_b1 = ( wa_tab3-val * wa_tab3-menge ) / wa_tab3-bmeng.
    req1_b1 = ( wa_tab3-plnmg * wa_tab3-menge ) / wa_tab3-bmeng.
    req2_b1 = ( wa_tab3-plnmg1 * wa_tab3-menge ) / wa_tab3-bmeng.
    req3_b1 = ( wa_tab3-plnmg2 * wa_tab3-menge ) / wa_tab3-bmeng.
    req_b2 = ( wa_tab3-b1 * wa_tab3-menge ) / wa_tab3-bmeng.
*    write : 'aaaa',req_b1,req1_b1,req2_b1,req3_b1,req_b2.

    wa_tab4-matnr = wa_tab3-matnr.
    wa_tab4-werks = wa_tab3-werks.
*      WA_TAB4-val = WA_TAB3-val.
*      WA_TAB4-bmeng = WA_TAB3-bmeng.
*      WA_TAB4-b1 = WA_TAB3-b1.
    wa_tab4-idnrk = wa_tab3-idnrk.
    wa_tab4-menge = wa_tab3-menge.
    wa_tab4-meins = wa_tab3-meins.
    wa_tab4-mtart = wa_tab3-mtart.
    wa_tab4-req_b1 = req_b1.
    wa_tab4-req1_b1 = req1_b1.
    wa_tab4-req2_b1 = req2_b1.
    wa_tab4-req3_b1 = req3_b1.
    wa_tab4-req_b2 = req_b2.

    collect wa_tab4 into it_tab4.
    clear wa_tab4.
  endloop.
*uline.
  sort it_tab4 by idnrk werks.

  loop at it_tab4 into wa_tab4.
    clear : w_menge,w_menge1,w_menge2,w_menge3.
    clear : w_labst,w_insme,w_speme,w_bdmng,w_stock.
*    write : /'f', wa_tab4-werks,wa_tab4-idnrk,wa_tab4-menge,wa_tab4-meins,wa_tab4-mtart,wa_tab4-req_b1,wa_tab4-req_b2..
    wa_tab5-matnr = wa_tab4-matnr.
    wa_tab5-werks = wa_tab4-werks.
    wa_tab5-idnrk = wa_tab4-idnrk.
    wa_tab5-menge = wa_tab4-menge.
    wa_tab5-meins = wa_tab4-meins.
    wa_tab5-mtart = wa_tab4-mtart.
    wa_tab5-req_b1 = wa_tab4-req_b1.
    wa_tab5-req1_b1 = wa_tab4-req1_b1.
    wa_tab5-req2_b1 = wa_tab4-req2_b1.
    wa_tab5-req3_b1 = wa_tab4-req3_b1.
    wa_tab5-req_b2 = wa_tab4-req_b2.

****************SAFETY STOCK*************************

    select single * from marc where matnr eq wa_tab5-idnrk and werks eq wa_tab5-werks.
    if sy-subrc eq 0.
      wa_tab5-eisbe = marc-eisbe.
    endif.

***************for stock************

    if splant is initial.
      select * from mard where matnr eq wa_tab4-idnrk and werks eq wa_tab4-werks.
        if sy-subrc eq 0.
*        write : / 'b',mard-labst.
          w_labst = w_labst + mard-labst.
          w_insme = w_insme + mard-insme.
          w_speme = w_speme + mard-speme.
        endif.
      endselect.
    else.
      select * from mard where matnr eq wa_tab4-idnrk and werks in splant.  "stock merging 8.4.21
        if sy-subrc eq 0.
*        write : / 'b',mard-labst.
          w_labst = w_labst + mard-labst.
          w_insme = w_insme + mard-insme.
          w_speme = w_speme + mard-speme.
        endif.
      endselect.
    endif.

*    write :  w_labst,w_insme,w_speme.
    wa_tab5-labst = w_labst.
    wa_tab5-insme = w_insme.
    wa_tab5-speme = w_speme.

    select *  from resb  where matnr = wa_tab4-idnrk and werks = wa_tab4-werks and kzear ne 'X'  and xloek ne 'X' and bdart  = 'AR'
        and charg  ne '         '.
      if sy-subrc eq 0.
*        WRITE : / resb-bdmng.
        w_bdmng =  w_bdmng + resb-bdmng.
      else.
        w_bdmng = 0.
      endif.
    endselect.

*    write : w_bdmng.
    wa_tab5-bdmng = w_bdmng.

    w_stock = w_labst - w_bdmng.
*    write : w_stock.
    wa_tab5-stock = w_stock.
*************pending po*************

    select * from ekpo where matnr eq wa_tab4-idnrk and elikz ne 'X' and loekz eq ' ' and statu ne 'A'..
      if sy-subrc eq 0.
*        write : / ekpo-ebeln,EKPO-EBELP,ekpo-matnr,ekpo-menge.
        select * from eket where ebeln eq ekpo-ebeln and ebelp eq ekpo-ebelp.
          if sy-subrc eq 0.
*            WRITE : / 'AA', EKET-EBELN,EKET-MENGE,EKET-WEMNG.
            w_menge = eket-menge - eket-wemng.
            w_menge1 = w_menge + w_menge1.
          endif.
        endselect.
      endif.
    endselect.

*    write :  w_menge1.

    wa_tab5-all_po = w_menge1.


    select * from ekpo where matnr eq wa_tab4-idnrk and elikz ne 'X' and werks eq wa_tab4-werks and loekz eq ' ' and statu ne 'A'.
      if sy-subrc eq 0.
*        write : / ekpo-ebeln,EKPO-EBELP,ekpo-matnr,ekpo-menge.
        select * from eket where ebeln eq ekpo-ebeln and ebelp eq ekpo-ebelp.
          if sy-subrc eq 0.
*            WRITE : EKET-MENGE,EKET-WEMNG.
            w_menge2 = eket-menge - eket-wemng.
            w_menge3 = w_menge2 + w_menge3.
          endif.
        endselect.
      endif.
    endselect.
*    write : w_menge3.
    wa_tab5-plt_po = w_menge3.

    collect wa_tab5 into it_tab5.
    clear wa_tab5.
  endloop.
*uline.
  clear :it_ekpo,wa_ekpo.
  select * from ekpo into table it_ekpo for all entries in it_tab5 where matnr eq it_tab5-idnrk and aedat ge r_date1
  and werks eq it_tab5-werks and statu eq ' ' and loekz ne 'L'.
  sort it_ekpo descending.

  loop at it_tab5 into wa_tab5.
    clear : tot_plan,net_req1,net_req2.
*    write : / '5',wa_tab5-werks,wa_tab5-idnrk,wa_tab5-menge,wa_tab5-meins,wa_tab5-mtart,wa_tab5-req_b1,
*    wa_tab5-req1_b1,wa_tab5-req2_b1,wa_tab5-req3_b1,wa_tab5-req_b2..
*    write :  wa_tab5-labst,wa_tab5-insme,wa_tab5-speme,wa_tab5-bdmng,wa_tab5-stock.
*    write :  wa_tab5-all_po,wa_tab5-plt_po.

    tot_plan = wa_tab5-stock + wa_tab5-eisbe + wa_tab5-insme + wa_tab5-plt_po.
    net_req1 = wa_tab5-req_b1 - tot_plan.
    net_req1_1 = wa_tab5-req1_b1 - tot_plan.
    net_req1_2 = wa_tab5-req2_b1 - tot_plan.
    net_req1_3 = wa_tab5-req3_b1 - tot_plan.
    net_req2 = wa_tab5-req_b2 - tot_plan.

*WRITE : TOT_PLAN,NET_REQ1,NET_REQ2.
    wa_tab6-matnr = wa_tab5-matnr.
    wa_tab6-werks = wa_tab5-werks.
    wa_tab6-idnrk = wa_tab5-idnrk.
    wa_tab6-menge = wa_tab5-menge.
    wa_tab6-meins = wa_tab5-meins.
    wa_tab6-mtart = wa_tab5-mtart.
    wa_tab6-req_b1 = wa_tab5-req_b1.
    wa_tab6-req1_b1 = wa_tab5-req1_b1.
    wa_tab6-req2_b1 = wa_tab5-req2_b1.
    wa_tab6-req3_b1 = wa_tab5-req3_b1.
    wa_tab6-req_b2 = wa_tab5-req_b2.
    wa_tab6-labst = wa_tab5-labst.
    wa_tab6-insme = wa_tab5-insme.
    wa_tab6-speme = wa_tab5-speme.
    wa_tab6-bdmng = wa_tab5-bdmng.
    wa_tab6-stock = wa_tab5-stock.
    wa_tab6-eisbe = wa_tab5-eisbe.

    clear : maktx1,maktx2,normt,maktx.
    select single * from makt where matnr eq wa_tab5-idnrk and spras = sy-langu.
    if sy-subrc eq 0.
      maktx1 = makt-maktx.
    endif.
    select single * from makt where matnr eq wa_tab5-idnrk and spras eq 'Z1'.
    if sy-subrc eq 0.
      maktx2 = makt-maktx.
    endif.
    select single * from mara where matnr eq wa_tab5-idnrk.
    if sy-subrc eq 0.
      normt = mara-normt.
    endif.
    concatenate maktx1 maktx2 normt into maktx separated by space.
    wa_tab6-maktx = maktx.


*    SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_TAB5-IDNRK.
*    IF SY-SUBRC EQ 0.
**        WRITE : MAKT-MAKTX.
*      WA_TAB6-MAKTX = MAKT-MAKTX.
*    ENDIF.
    select single * from mbew where matnr eq wa_tab5-idnrk and bwkey eq wa_tab5-werks.
    if sy-subrc eq 0.
      wa_tab6-verpr = mbew-verpr.
      wa_tab6-stprs = mbew-stprs.
    endif.

*      write :  wa_tab5-labst,wa_tab5-insme,wa_tab5-speme,wa_tab5-bdmng,wa_tab5-stock.

    wa_tab6-all_po = wa_tab5-all_po.
    wa_tab6-plt_po = wa_tab5-plt_po.
    wa_tab6-tot_plan = tot_plan.
    wa_tab6-net_req1 = net_req1.
    wa_tab6-net_req1_1 = net_req1_1.
    wa_tab6-net_req1_2 = net_req1_2.
    wa_tab6-net_req1_3 = net_req1_3.
    wa_tab6-net_req2 = net_req2.

*LOOP at it_ekpo INTO wa_ekpo.
*  WRITE : / 'new',wa_ekpo-matnr,wa_ekpo-netpr.
*endloop.
    read table it_ekpo into wa_ekpo with key matnr = wa_tab5-idnrk werks = wa_tab5-werks .
    if sy-subrc eq 0.
*    WRITE : / 'chek here',wa_tab5-idnrk,wa_ekpo-netpr.
      wa_tab6-netpr = wa_ekpo-netpr.
    endif.

    collect wa_tab6 into it_tab6.
    clear wa_tab6.
  endloop.
*  uline.
*  uline.
  sort it_tab6 by idnrk.
  loop at it_tab6 into wa_tab6.

    on change of wa_tab6-idnrk.

      if val4 ne 0.
        format color 1.
        write : /90 'SUBTOTAL',102(12) val1,116(12) val2,130(12) val3.
        val1 = 0.
        val2 = 0.
        val3 = 0.
      endif.
      format color 2.
      write : /1(40) wa_tab6-maktx,42(10) wa_tab6-idnrk,54(3) wa_tab6-meins,59(12) wa_tab6-labst,73(12) wa_tab6-insme,
      87(12) wa_tab6-plt_po,102(12) wa_tab6-req1_b1,116(12) wa_tab6-req2_b1,130(12) wa_tab6-req3_b1,
**    144(12) wa_tab6-net_req1,
*    102(12) wa_tab6-req_b1, 159 'a',160(12) wa_tab6-net_req1_1,174(12) wa_tab6-net_req1_2,188(12) wa_tab6-net_req1_3,
      158(12) wa_tab6-netpr,172(12) wa_tab6-verpr,186(12) wa_tab6-menge,200(12) wa_tab6-tot_plan,214(12) wa_tab6-eisbe,228(12) wa_tab6-stock,
      242(12) wa_tab6-bdmng,256(12) wa_tab6-speme,
*    270(12) wa_tab6-net_req2,
     wa_tab6-matnr.
    else.
      format color 2.
*    write : /1(40) wa_tab6-maktx,42(10) wa_tab6-idnrk,54(3) wa_tab6-meins,59(12) wa_tab6-labst,73(12) wa_tab6-insme,
*    87(12) wa_tab6-plt_po,
      write : /102(12) wa_tab6-req1_b1,116(12) wa_tab6-req2_b1,130(12) wa_tab6-req3_b1,
**    144(12) wa_tab6-net_req1,
*    102(12) wa_tab6-req_b1, 159 'a',160(12) wa_tab6-net_req1_1,174(12) wa_tab6-net_req1_2,188(12) wa_tab6-net_req1_3,
      158(12) wa_tab6-netpr,172(12) wa_tab6-verpr, 186(12) wa_tab6-menge,
*     200(12) wa_tab6-tot_plan,214(12) wa_tab6-eisbe,228(12) wa_tab6-stock,
*    242(12) wa_tab6-bdmng,256(12) wa_tab6-speme,
*    270(12) wa_tab6-net_req2,
      wa_tab6-matnr.
    endon.
    val1 = wa_tab6-req1_b1 + val1.
    val2 = wa_tab6-req2_b1 + val2.
    val3 = wa_tab6-req3_b1 + val3.
    val4 = val1 + val2 + val3.
    at last.
      if val4 ne 0.
        format color 1.
        write : /90 'SUBTOTAL',102(12) val1,116(12) val2,130(12) val3.
        val1 = 0.
        val2 = 0.
        val3 = 0.
      endif.
    endat.


  endloop.
*uline.
*  loop at it_tab6 into wa_tab6.
*    format color 2.
*    write : /1(40) wa_tab6-maktx,42(10) wa_tab6-idnrk,54(3) wa_tab6-meins,59(12) wa_tab6-labst,73(12) wa_tab6-insme,
*    87(12) wa_tab6-plt_po, 102(12) wa_tab6-req_b1,116(12) wa_tab6-net_req1, 130(12) wa_tab6-netpr,144(12) wa_tab6-verpr,
*    158(12) wa_tab6-menge,172(12) wa_tab6-tot_plan,184(12) wa_tab6-eisbe,198(12) wa_tab6-stock,212(12) wa_tab6-bdmng,
*    226(12) wa_tab6-speme,238(12) wa_tab6-net_req2.
*
*  endloop.
  clear : it_ekpo,wa_ekpo.






endform.                                                    "pack1

*&---------------------------------------------------------------------*
*&      Form  RAW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form raw.

  loop at it_tab1 into wa_tab1.
    wa_pmbom1-matnr = wa_tab1-matnr.
    wa_pmbom1-werks = wa_tab1-werks.
    wa_pmbom1-val = wa_tab1-val.
    wa_pmbom1-bmeng = wa_tab1-bmeng.
    wa_pmbom1-b1 = wa_tab1-b1.
    clear stlal.
    select single * from zmrp_data where matnr eq wa_tab1-matnr and werks eq wa_tab1-werks and zmonth eq sy-datum+4(2) and zyear eq sy-datum+0(4).
    if sy-subrc eq 0.
      stlal = zmrp_data-stlal.
    endif.
    if stlal eq space .
      stlal = '01'.
    endif.


    select single * from mast where matnr eq wa_tab1-matnr and werks eq wa_tab1-werks and stlal eq stlal.
    if sy-subrc eq 0.
      select single * from stko where stlnr eq mast-stlnr and stlal = mast-stlal and loekz eq space.
      if sy-subrc eq 0.
        wa_pmbom1-stlal = stlal.
        collect wa_pmbom1 into it_pmbom1.
        clear wa_pmbom1.
      endif.
    endif.

  endloop.

  if it_pmbom1 is not initial.
    select * from mast into table it_mast_p for all entries in it_pmbom1 where matnr eq it_pmbom1-matnr and werks eq it_pmbom1-werks and stlan eq 1
    and stlal eq it_pmbom1-stlal.
    if sy-subrc eq 0.
      select * from stas into table it_stas_p for all entries in it_mast_p where stlnr eq it_mast_p-stlnr and stlal eq it_mast_p-stlal.
      if sy-subrc eq 0.
        select * from stpo into table it_stpo_p for all entries in it_stas_p where stlnr eq it_stas_p-stlnr and stlkn eq it_stas_p-stlkn.
      endif.
    endif.
  endif.

*  LOOP AT IT_PMBOM1 INTO WA_PMBOM1.
*    WA_PMBOM2-MATNR = WA_PMBOM1-MATNR.
*    WA_PMBOM2-WERKS = WA_PMBOM1-WERKS.
*    WA_PMBOM2-STLAL = WA_PMBOM1-STLAL.
*    WA_PMBOM2-VAL = WA_PMBOM1-VAL.
*    WA_PMBOM2-BMENG = WA_PMBOM1-BMENG.
*    WA_PMBOM2-B1 = WA_PMBOM1-B1.
*    READ TABLE IT_MAST_P INTO WA_MAST_P WITH KEY MATNR = WA_PMBOM1-MATNR WERKS = WA_PMBOM1-WERKS STLAN = 1 STLAL = WA_PMBOM1-STLAL.
*    IF SY-SUBRC EQ 0.
*      LOOP AT IT_STAS_P INTO WA_STAS_P WHERE STLNR = WA_MAST_P-STLNR AND STLAL = WA_MAST_P-STLAL.
*        LOOP AT IT_STPO_P INTO WA_STPO_P WHERE STLNR = WA_STAS_P-STLNR AND STLKN = WA_STAS_P-STLKN.
*          WA_PMBOM2-IDNRK = WA_STPO_P-IDNRK.
*          COLLECT WA_PMBOM2 INTO IT_PMBOM2.
*          CLEAR WA_PMBOM2.
*        ENDLOOP.
*      ENDLOOP.
*    ENDIF.
*  ENDLOOP.

  loop at it_pmbom1 into wa_pmbom1.

    read table it_mast_p into wa_mast_p with key matnr = wa_pmbom1-matnr werks = wa_pmbom1-werks stlan = 1 stlal = wa_pmbom1-stlal.
    if sy-subrc eq 0.
      loop at it_stas_p into wa_stas_p where stlnr = wa_mast_p-stlnr and stlal = wa_mast_p-stlal.
        loop at it_stpo_p into wa_stpo_p where stlnr = wa_stas_p-stlnr and stlkn = wa_stas_p-stlkn and idnrk cs 'H'.
          wa_tab7-matnr = wa_pmbom1-matnr.
          wa_tab7-werks = wa_pmbom1-werks.
          wa_tab7-stlal = wa_pmbom1-stlal.
          wa_tab7-val = wa_pmbom1-val.
          wa_tab7-bmeng = wa_pmbom1-bmeng.
          wa_tab7-b1 = wa_pmbom1-b1.
          wa_tab7-mat1 = wa_stpo_p-idnrk.
*          WA_TAB7-MENGE = WA_STPO_P-MENGE.
*          WA_TAB7-MEINS = WA_STPO_P-MEINS.
*          SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_STPO_P-IDNRK.
*          IF SY-SUBRC EQ 0.
*            WA_TAB7-MTART = MARA-MTART.
*          ENDIF.
          collect wa_tab7 into it_tab7.
          clear wa_tab7.
        endloop.
      endloop.
    endif.
  endloop.


*  LOOP AT IT_TAB1 INTO WA_TAB1.
**    write : / wa_tab1-matnr, wa_tab1-werks,wa_tab1-bmeng, wa_tab1-val,wa_tab1-b1.
*    WA_TAB7-MATNR = WA_TAB1-MATNR.
*    WA_TAB7-WERKS = WA_TAB1-WERKS.
*    WA_TAB7-BMENG = WA_TAB1-BMENG.
*    WA_TAB7-VAL = WA_TAB1-VAL.
*    WA_TAB7-B1 = WA_TAB1-B1.
*    CLEAR STLAL.
*    SELECT SINGLE * FROM ZMRP_DATA WHERE MATNR EQ WA_TAB1-MATNR AND WERKS EQ WA_TAB1-WERKS AND ZMONTH EQ SY-DATUM+4(2) AND ZYEAR EQ SY-DATUM+0(4).
*    IF SY-SUBRC EQ 0.
*      STLAL = ZMRP_DATA-STLAL.
*    ENDIF.
*    IF STLAL EQ SPACE .
*      STLAL = '01'.
*    ENDIF.
**    WA_RM
**    SELECT SINGLE * FROM MAST WHERE MATNR EQ WA_TAB1-MATNR AND WERKS EQ WA_TAB1-WERKS AND STLAN EQ 1 AND STLAL EQ STLAL.
**    IF SY-SUBRC EQ 0.
***      write : / mast-matnr.
***      select single * from stpo where stlnr eq mast-stlnr and stlty eq 'M'.
**      SELECT IDNRK INTO W_IDNRK FROM STPO WHERE STLNR EQ MAST-STLNR AND STLTY EQ 'M' .
**        IF SY-SUBRC EQ 0.
***        if stpo-idnrk ca 'H'.
**          IF W_IDNRK CS 'H'.
***          write : /'CHECK', stpo-idnrk.
***          wa_tab7-mat1 = stpo-idnrk.
**            WA_TAB7-MAT1 = W_IDNRK.
***            write : / w_idnrk.
**          ENDIF.
**        ENDIF.
**      ENDSELECT.
**    ENDIF.
**
***      pack wa_tab1-matnr to w_mat1.
***      condense w_mat1.
***      concatenate 'H' w_mat1 into w_mat1.
****     WRITE W_MAT1.
***
***      wa_tab7-mat1 = w_mat1.
**    COLLECT WA_TAB7 INTO IT_TAB7.
**    CLEAR WA_TAB7.
*  ENDLOOP.

*************************************************************************************************************************
  loop at it_tab7 into wa_tab7.

*    write : / 'a',wa_tab7-matnr, wa_tab7-werks,wa_tab7-bmeng, wa_tab7-val,wa_tab7-b1,wa_tab7-mat1.

    wa_tab8-mat1 = wa_tab7-mat1.
    wa_tab8-werks = wa_tab7-werks.
    wa_tab8-bmeng = wa_tab7-bmeng.
    wa_tab8-val = wa_tab7-val.
    wa_tab8-b1 = wa_tab7-b1.
    wa_tab8-matnr = wa_tab7-matnr.
    select single * from mast where matnr eq wa_tab7-mat1 and werks eq wa_tab7-werks and stlan eq 1 and stlal eq wa_tab7-stlal.
    if sy-subrc eq 0.
      select single * from stko where stlnr eq mast-stlnr and stlal eq mast-stlal.
      if sy-subrc eq 0.
*        write : / 'a1',stko-bmeng.
        wa_tab8-bmeng1 = stko-bmeng.
      endif.
    endif.
    collect wa_tab8 into it_tab8.
    clear wa_tab8.
  endloop.

  loop at it_tab8 into wa_tab8.
    clear : batch1,batch2,batch3,batch4,batch5.

*    write : / wa_tab8-mat1,wa_tab8-werks,wa_tab8-bmeng,wa_tab8-val.

    wa_tab9-mat1 = wa_tab8-mat1.
    wa_tab9-matnr = wa_tab8-matnr.
    wa_tab9-werks = wa_tab8-werks.
    wa_tab9-bmeng = wa_tab8-bmeng.
    wa_tab9-bmeng1 = wa_tab8-bmeng1.
    wa_tab9-val = wa_tab8-val.
    wa_tab9-b1 = wa_tab8-b1.
    batch1 = wa_tab8-val / wa_tab8-bmeng.
    batch2 = wa_tab8-val mod wa_tab8-bmeng.
    if batch2 gt 0.
      batch3 = wa_tab8-bmeng - batch2.
      batch4 = wa_tab8-val + batch3.
    else.
      batch3 = 0.
      batch4 = wa_tab8-val.
    endif.
    batch5 = batch4 / wa_tab8-bmeng.
*  if batch2 gt 0.
*    batch3 = batch1 + 1.
*  else.
*    batch3 = batch1.
*  endif.
*  WRITE : batch1,batch2,batch3,batch4,batch5.
*    write : batch4.
    wa_tab9-batch = batch4.

    clear stlal.
    select single * from zmrp_data where matnr eq wa_tab8-mat1 and werks eq wa_tab8-werks and zmonth eq sy-datum+4(2) and zyear eq sy-datum+0(4).
    if sy-subrc eq 0.
      stlal = zmrp_data-stlal.
    endif.
    if stlal eq space .
      stlal = '01'.
    endif.

    select single * from mast where matnr eq wa_tab8-mat1 and werks eq wa_tab8-werks and stlal eq stlal.
    if sy-subrc eq 0.
      select single * from stko where stlnr eq mast-stlnr and stlal = mast-stlal and loekz eq space.
      if sy-subrc eq 0.
        wa_tab9-hstlal = stlal.
        collect wa_tab9 into it_tab9.
        clear wa_tab9.
      endif.
    endif.
  endloop.
******************* HALB BOM*********************
  if it_tab9 is not initial.
    select * from mast into table it_mast_r for all entries in it_tab9 where matnr eq it_tab9-mat1 and werks eq it_tab9-werks and stlan eq 1
    and stlal eq it_tab9-hstlal.
    if sy-subrc eq 0.
      select * from stas into table it_stas_r for all entries in it_mast_r where stlnr eq it_mast_r-stlnr and stlal eq it_mast_r-stlal.
      if sy-subrc eq 0.
        select * from stpo into table it_stpo_r for all entries in it_stas_r where stlnr eq it_stas_r-stlnr and stlkn eq it_stas_r-stlkn.
      endif.
    endif.
  endif.
**************************************************************
*   LOOP AT IT_TAB9 INTO WA_TAB9.
*
*    READ TABLE IT_MAST_R INTO WA_MAST_R WITH KEY MATNR = WA_TAB9-MAT1 WERKS = WA_TAB9-WERKS STLAN = 1 STLAL = WA_TAB9-HSTLAL.
*    IF SY-SUBRC EQ 0.
*      LOOP AT IT_STAS_R INTO WA_STAS_R WHERE STLNR = WA_MAST_R-STLNR AND STLAL = WA_MAST_R-STLAL.
*        LOOP AT IT_STPO_R INTO WA_STPO_R WHERE STLNR = WA_STAS_R-STLNR AND STLKN = WA_STAS_R-STLKN.
*          WA_TAB2-MATNR = WA_PMBOM1-MATNR.
*          WA_TAB2-WERKS = WA_PMBOM1-WERKS.
*          WA_TAB2-STLAL = WA_PMBOM1-STLAL.
*          WA_TAB2-VAL = WA_PMBOM1-VAL.
*          WA_TAB2-BMENG = WA_PMBOM1-BMENG.
*          WA_TAB2-B1 = WA_PMBOM1-B1.
*          WA_TAB2-IDNRK = WA_STPO_P-IDNRK.
*          WA_TAB2-MENGE = WA_STPO_P-MENGE.
*          WA_TAB2-MEINS = WA_STPO_P-MEINS.
*          SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_STPO_P-IDNRK.
*          IF SY-SUBRC EQ 0.
*            WA_TAB2-MTART = MARA-MTART.
*          ENDIF.
*          COLLECT WA_TAB2 INTO IT_TAB2.
*          CLEAR WA_TAB2.
*        ENDLOOP.
*      ENDLOOP.
*    ENDIF.
*  ENDLOOP.

  loop at it_tab9 into wa_tab9.
    read table it_mast_r into wa_mast_r with key matnr = wa_tab9-mat1 werks = wa_tab9-werks stlan = 1 stlal = wa_tab9-hstlal.
    if sy-subrc eq 0.
      loop at it_stas_r into wa_stas_r where stlnr = wa_mast_r-stlnr and stlal = wa_mast_r-stlal.
        loop at it_stpo_r into wa_stpo_r where stlnr = wa_stas_r-stlnr and stlkn = wa_stas_r-stlkn.
          select single * from marc where matnr eq wa_stpo_r-idnrk and werks eq wa_mast_r-werks and lvorm eq space.
          if sy-subrc eq 0.
            wa_tab10-mat1 = wa_tab9-mat1.
            wa_tab10-matnr = wa_tab9-matnr.
            wa_tab10-werks = wa_tab9-werks.
            wa_tab10-bmeng = wa_tab9-bmeng.
            wa_tab10-bmeng1 = wa_tab9-bmeng1.
            wa_tab10-val = wa_tab9-val.
            wa_tab10-b1 = wa_tab9-b1.
            wa_tab10-batch = wa_tab9-batch.
            wa_tab10-idnrk = wa_stpo_r-idnrk.
            wa_tab10-menge = wa_stpo_r-menge.
            wa_tab10-meins = wa_stpo_r-meins.
            select single * from mara where matnr eq wa_stpo_r-idnrk.
            if sy-subrc eq 0.
              wa_tab10-mtart = mara-mtart.
            endif.
            append wa_tab10 to it_tab10.
          else.
            format color 6.
            write : / 'DELETION INDICATOR FOR',wa_stpo_r-idnrk.
            skip.
            skip.
          endif.
        endloop.
      endloop.
    endif.
  endloop.
*  uline.

  loop at it_tab10 into wa_tab10.
    clear : req_b1,req_b2.
    if wa_tab10-mtart eq 'ZROH'.
*      write : /'rr', wa_tab10-mat1,wa_tab10-werks,wa_tab10-bmeng1,wa_tab10-bmeng,wa_tab10-val,wa_tab10-b1,wa_tab10-batch,wa_tab10-idnrk,wa_tab10-menge,
*      wa_tab10-meins, wa_tab10-mtart.

*      wa_tab11-mat1 = wa_tab10-mat1.
      wa_tab11-werks = wa_tab10-werks.
*      wa_tab11-bmeng = wa_tab10-bmeng.
*      wa_tab11-val = wa_tab10-val.
*      wa_tab11-batch = wa_tab10-batch.
      wa_tab11-idnrk = wa_tab10-idnrk.
      wa_tab11-menge = wa_tab10-menge.
      wa_tab11-meins = wa_tab10-meins.
      wa_tab11-mtart = wa_tab10-mtart.

      req_b1 = ( wa_tab10-val * wa_tab10-menge ) / wa_tab10-bmeng.
      req_b2 = ( wa_tab10-batch * wa_tab10-menge ) / wa_tab10-bmeng.
*      write : req_b1,req_b2.
      wa_tab11-req_b1 = req_b1.
      wa_tab11-req_b2 = req_b2.

      collect wa_tab11 into it_tab11.
      clear wa_tab11.
    endif.
  endloop.
*uline.

  sort it_tab11 by idnrk werks.

  loop at it_tab11 into wa_tab11.
    clear : w_menge,w_menge1,w_menge2,w_menge3.
    clear : w_labst,w_insme,w_speme,w_bdmng,w_stock.

*    write : /'aa', wa_tab11-werks,wa_tab11-idnrk,wa_tab11-menge,wa_tab11-meins,wa_tab11-mtart,wa_tab11-req_b1,wa_tab11-req_b2.

    wa_tab12-werks = wa_tab11-werks.
    wa_tab12-idnrk = wa_tab11-idnrk.
    wa_tab12-menge = wa_tab11-menge.
    wa_tab12-meins = wa_tab11-meins.
    wa_tab12-mtart = wa_tab11-mtart.
    wa_tab12-req_b1 = wa_tab11-req_b1.
    wa_tab12-req_b2 = wa_tab11-req_b2.

*********** SAFETY STOCK******************
    select single * from marc where matnr eq wa_tab11-idnrk and werks eq wa_tab11-werks.
    if sy-subrc eq 0.
      wa_tab12-eisbe = marc-eisbe.
    endif.


************stock******************

*    SELECT * FROM MARD WHERE MATNR EQ WA_TAB11-IDNRK AND WERKS EQ WA_TAB11-WERKS.
    if splant is not initial.
      select * from mard where matnr eq wa_tab11-idnrk and werks in splant.  "stock merge 8.4.21
        if sy-subrc eq 0.
*         WRITE : / MARD-LABST.
          w_labst = w_labst + mard-labst.
          w_insme = w_insme + mard-insme.
          w_speme = w_speme + mard-speme.
        endif.
      endselect.
    else.
      select * from mard where matnr eq wa_tab11-idnrk and werks eq wa_tab11-werks.
        if sy-subrc eq 0.
*         WRITE : / MARD-LABST.
          w_labst = w_labst + mard-labst.
          w_insme = w_insme + mard-insme.
          w_speme = w_speme + mard-speme.
        endif.
      endselect.
    endif.
*    write :  w_labst,w_insme,w_speme.

    wa_tab12-labst = w_labst.
    wa_tab12-insme = w_insme.
    wa_tab12-speme = w_speme.

    select *  from resb  where matnr = wa_tab11-idnrk and werks = wa_tab11-werks and kzear ne 'X'  and xloek ne 'X' and bdart  = 'AR'
        and charg  ne '         '.
      if sy-subrc eq 0.
        w_bdmng =  w_bdmng + resb-bdmng.
      else.
        w_bdmng = 0.
      endif.
    endselect.
    w_stock = w_labst - w_bdmng.
*    write : w_bdmng,w_stock.
    wa_tab12-bdmng = w_bdmng.
    wa_tab12-stock = w_stock.
******************pending po************

    select * from ekpo where matnr eq wa_tab11-idnrk and elikz ne 'X' and loekz eq ' ' and statu ne 'A'..
      if sy-subrc eq 0.
*        write : / ekpo-ebeln,EKPO-EBELP,ekpo-matnr,ekpo-menge.
        select * from eket where ebeln eq ekpo-ebeln and ebelp eq ekpo-ebelp.
          if sy-subrc eq 0.
*            WRITE : / 'AA', EKET-EBELN,EKET-MENGE,EKET-WEMNG.
            w_menge = eket-menge - eket-wemng.
            w_menge1 = w_menge + w_menge1.
          endif.
        endselect.
      endif.
    endselect.

*    write :  w_menge1.

    wa_tab12-all_po = w_menge1.

    select * from ekpo where matnr eq wa_tab11-idnrk and elikz ne 'X' and werks eq wa_tab11-werks and loekz eq ' ' and statu ne 'A'.
      if sy-subrc eq 0.
*        write : / ekpo-ebeln,EKPO-EBELP,ekpo-matnr,ekpo-menge.
        select * from eket where ebeln eq ekpo-ebeln and ebelp eq ekpo-ebelp.
          if sy-subrc eq 0.
*            WRITE : EKET-MENGE,EKET-WEMNG.
            w_menge2 = eket-menge - eket-wemng.
            w_menge3 = w_menge2 + w_menge3.
          endif.
        endselect.
      endif.
    endselect.
*    write : w_menge3.
    wa_tab12-plt_po = w_menge3.

    collect wa_tab12 into it_tab12.
    clear wa_tab12.
  endloop.

*  uline.
  loop at it_tab12 into wa_tab12.
    clear : tot_plan,net_req1,net_req2.

*    write : /'aa', wa_tab12-werks,wa_tab12-idnrk,wa_tab12-menge,wa_tab12-meins,wa_tab12-mtart,wa_tab12-req_b1,wa_tab12-req_b2.
*    write :  wa_tab12-labst,wa_tab12-insme,wa_tab12-speme,wa_tab12-bdmng,wa_tab12-stock,wa_tab12-all_po,wa_tab12-plt_po.

    wa_tab13-werks = wa_tab12-werks.
    wa_tab13-idnrk = wa_tab12-idnrk.
    wa_tab13-menge = wa_tab12-menge.
    wa_tab13-meins = wa_tab12-meins.
    wa_tab13-mtart = wa_tab12-mtart.
    wa_tab13-req_b1 = wa_tab12-req_b1.
    wa_tab13-req_b2 = wa_tab12-req_b2.
    wa_tab13-labst = wa_tab12-labst.
    wa_tab13-insme = wa_tab12-insme.
    wa_tab13-speme = wa_tab12-speme.
    wa_tab13-bdmng = wa_tab12-bdmng.
    wa_tab13-stock = wa_tab12-stock.
    wa_tab13-all_po = wa_tab12-all_po.
    wa_tab13-plt_po = wa_tab12-plt_po.
    wa_tab13-eisbe = wa_tab12-eisbe.

    select single * from makt where matnr eq wa_tab12-idnrk.
    if sy-subrc eq 0.
      wa_tab13-maktx = makt-maktx.
    endif.
    select single * from mbew where matnr eq wa_tab12-idnrk and bwkey eq wa_tab12-werks.
    if sy-subrc eq 0.
      wa_tab13-verpr = mbew-verpr.
      wa_tab13-stprs = mbew-stprs.
    endif.

    tot_plan = wa_tab12-stock + wa_tab12-eisbe + wa_tab12-insme + wa_tab12-plt_po.
    net_req1 = wa_tab12-req_b1 - tot_plan.
    net_req2 = wa_tab12-req_b2 - tot_plan.

    wa_tab13-tot_plan = tot_plan.
    wa_tab13-net_req1 = net_req1.
    wa_tab13-net_req2 = net_req2.

    collect wa_tab13 into it_tab13.
    clear wa_tab13.

  endloop.
*DATA : COUNT TYPE I VALUE 1.
*SELECT * FROM marM INTO TABLE it_marm FOR ALL ENTRIES IN it_tab13 WHERE matnr eq it_tab13-idnrk.
*
*  LOOP at it_marm INTO wa_marm.
*ON CHANGE OF WA_MARM-MATNR.
*COUNT = 0.
*ENDON.
*    WRITE : / WA_MARM-MATNR,WA_MARM-MEINH,WA_MARM-UMREZ,SY-INDEX,SY-TABIX,COUNT.
*    COUNT = COUNT + 1.
*ENDLOOP.
**COUNT = 0.
  loop at it_tab13 into wa_tab13.
    select single * from marm where matnr eq wa_tab13-idnrk and umren eq '2'.
    if sy-subrc eq 0.
*      write : / wa_tab13-idnrk,marm-meinh,marm-umrez.
      wa_tab15-meinh = marm-meinh.
      wa_tab15-umrez = marm-umrez.
    endif.
*      ENDSELECT.
    wa_tab15-werks = wa_tab13-werks.
    wa_tab15-idnrk = wa_tab13-idnrk.
    wa_tab15-maktx = wa_tab13-maktx.
    wa_tab15-menge = wa_tab13-menge.
    wa_tab15-meins = wa_tab13-meins.
    wa_tab15-mtart = wa_tab13-mtart.
    wa_tab15-req_b1 = wa_tab13-req_b1.
    wa_tab15-req_b2 = wa_tab13-req_b2.
    wa_tab15-labst = wa_tab13-labst.
    wa_tab15-insme = wa_tab13-insme.
    wa_tab15-speme = wa_tab13-speme.
    wa_tab15-bdmng = wa_tab13-bdmng.
    wa_tab15-stock = wa_tab13-stock.
    wa_tab15-eisbe = wa_tab13-eisbe.
    wa_tab15-all_po = wa_tab13-all_po.
    wa_tab15-plt_po = wa_tab13-plt_po.
    wa_tab15-tot_plan = wa_tab13-tot_plan.
    wa_tab15-net_req1 = wa_tab13-net_req1.
    wa_tab15-net_req2 = wa_tab13-net_req2.
    wa_tab15-verpr = wa_tab13-verpr.
    wa_tab15-stprs = wa_tab13-stprs.

*    if wa_tab13-net_req1 gt 0.
*    wa_tab15-mov1_val = wa_tab13-NET_REQ1 * wa_tab13-verpr.
*    wa_tab15-std1_val = wa_tab13-NET_REQ1 * wa_tab13-stprs.
**    WRITE : / 'A',wa_tab15-mov1_val,wa_tab15-STD1_val.
*    ELSE.
*      wa_tab15-mov1_val = 0.
*      wa_tab15-std1_val = 0.
*    ENDIF.
*
*    if wa_tab13-net_req2 gt 0.
*    wa_tab15-mov2_val = wa_tab13-NET_REQ2 * wa_tab13-verpr.
*    wa_tab15-std2_val = wa_tab13-NET_REQ2 * wa_tab13-stprs.
*    ELSE.
*      wa_tab15-mov2_val = 0.
*      wa_tab15-std2_val = 0.
*    ENDIF.
    collect wa_tab15 into it_tab15.
    clear wa_tab15.

*    pack wa_tab13-idnrk to wa_tab13-idnrk.
*    condense wa_tab13-idnrk.
*    modify it_tab13 from wa_tab13 transporting idnrk.
  endloop.


  clear :it_ekpo,wa_ekpo.
  select * from ekpo into table it_ekpo for all entries in it_tab15 where matnr eq it_tab15-idnrk and aedat ge r_date1
  and werks eq it_tab15-werks and statu eq ' ' and loekz ne 'L'.
  sort it_ekpo descending.

  loop at it_tab15 into wa_tab15.

    wa_tab16-werks = wa_tab15-werks.
    wa_tab16-idnrk = wa_tab15-idnrk.
*    wa_tab16-maktx = wa_tab15-maktx.
    clear : maktx1,maktx2,normt,maktx.
    select single * from makt where matnr eq wa_tab15-idnrk and spras = sy-langu.
    if sy-subrc eq 0.
      maktx1 = makt-maktx.
    endif.
    select single * from makt where matnr eq wa_tab15-idnrk and spras eq 'Z1'.
    if sy-subrc eq 0.
      maktx2 = makt-maktx.
    endif.
    select single * from mara where matnr eq wa_tab15-idnrk.
    if sy-subrc eq 0.
      normt = mara-normt.
    endif.
    concatenate maktx1 maktx2 normt into maktx separated by space.
    wa_tab16-maktx = maktx.

    wa_tab16-menge = wa_tab15-menge.
    wa_tab16-meins = wa_tab15-meins.
    wa_tab16-mtart = wa_tab15-mtart.
    wa_tab16-req_b1 = wa_tab15-req_b1.
    wa_tab16-req_b2 = wa_tab15-req_b2.
    wa_tab16-labst = wa_tab15-labst.
    wa_tab16-insme = wa_tab15-insme.
    wa_tab16-speme = wa_tab15-speme.
    wa_tab16-bdmng = wa_tab15-bdmng.
    wa_tab16-stock = wa_tab15-stock.
    wa_tab16-eisbe = wa_tab15-eisbe.
    wa_tab16-all_po = wa_tab15-all_po.
    wa_tab16-plt_po = wa_tab15-plt_po.
    wa_tab16-tot_plan = wa_tab15-tot_plan.
    wa_tab16-verpr = wa_tab15-verpr.
    wa_tab16-stprs = wa_tab15-stprs.
    wa_tab16-meinh = wa_tab15-meinh.
    wa_tab16-umrez = wa_tab15-umrez.
    wa_tab16-net_req1 = wa_tab15-net_req1.
    wa_tab16-net_req2 = wa_tab15-net_req2.

    read table it_ekpo into wa_ekpo with key matnr = wa_tab15-idnrk werks = wa_tab15-werks .
    if sy-subrc eq 0.
*    WRITE : / 'chek here',wa_tab5-idnrk,wa_ekpo-netpr.
      wa_tab16-netpr = wa_ekpo-netpr.
    endif.

    if wa_tab15-net_req2 gt 0.
      wa_tab16-req2 = wa_tab15-net_req2.
    else.
      wa_tab16-req2 = 0.
    endif.

    if wa_tab15-net_req2 gt 0.
      if wa_tab15-umrez ne 0.
        pack1 = wa_tab15-net_req2 mod wa_tab15-umrez.
        pack2 = wa_tab15-net_req2 div wa_tab15-umrez.
        if pack1 gt 0.
          pack3 = pack2 + 1.
        else.
          pack3 = pack2.
        endif.

        pack4 = pack3 * wa_tab15-umrez.
        mov_val = pack4 * wa_tab15-verpr.
        std_val = pack4 * wa_tab15-stprs.
*        write : / wa_tab15-idnrk,wa_tab15-net_req2,wa_tab15-umrez,pack1,pack2,pack3,PACK4.

        wa_tab16-pack3 = pack3.
        wa_tab16-pack4 = pack4.
        wa_tab16-mov_val = mov_val.
        wa_tab16-std_val = std_val.
      endif.
    endif.

    collect wa_tab16 into it_tab16.
    clear wa_tab16.
*     pack wa_tab15-idnrk to wa_tab15-idnrk.
*     condense wa_tab15-idnrk.
*     modify it_tab15 from wa_tab15 transporting idnrk.
  endloop.


  loop at it_tab16 into wa_tab16.
    format color 2.
*    write : /1(40) wa_tab16-maktx,42(10) wa_tab16-idnrk,54(3) wa_tab16-meins,59(12) wa_tab16-labst,
*     73(12) wa_tab16-plt_po,87(12) wa_tab16-tot_plan,103(12) wa_tab16-req_b2,117(12) wa_tab16-net_req2,131(12) wa_tab16-req2,
*    145(12) wa_tab16-netpr,159(12) wa_tab16-verpr,173(12) wa_tab16-stock,187(12) wa_tab16-eisbe,201(12) wa_tab16-insme,
*    213(12) wa_tab16-bdmng,228(12) wa_tab16-speme.
*    write : 242(13) wa_tab16-net_req1,256(13) wa_tab16-req_b1.
    write : /1(55) wa_tab16-maktx,57(10) wa_tab16-idnrk,69(3) wa_tab16-meins,74(12) wa_tab16-labst,
     88(12) wa_tab16-plt_po,102(12) wa_tab16-tot_plan,118(12) wa_tab16-req_b2,132(12) wa_tab16-net_req2,146(12) wa_tab16-req2,
    160(12) wa_tab16-netpr,174(12) wa_tab16-verpr,188(12) wa_tab16-stock,202(12) wa_tab16-eisbe,216(12) wa_tab16-insme,
    228(12) wa_tab16-bdmng,243(12) wa_tab16-speme.
    write : 257(13) wa_tab16-net_req1,271(13) wa_tab16-req_b1.

  endloop.

endform.                    "TOP

top-of-page.
  format color 1.
  write : / 'MRP PROGRAM FOR PLANT'.
  skip.

  if r2 eq 'X'.

*      write : /1 'DESCRIPTION', 42 'ITEM.CODE',54 'UNIT',59 'UNRESTRICTED',73 '   PENDING',87 '   TOTAL',103 'PROPOSED',117 'NET',
*    131 '  ROUND OFF',145 '  LAST_PO',159 '     MOVING',173 '  AVAILABLE',187 '    SAFETY',201 '    QUALITY',213 '     RESERV',
*    228 '     BLOCK',244 'Actual',264 'ACTUAL'.
*
*    write : /59 'STOCK',73 '   PO QTY',87 '   PLANNING',103 'CONSUMPTION',117 'REQUIREMENT',131 '  BATCH QTY',145 ' NET PRICE',
*    159 '     PRICE',173 '  STOCK',187 '    STOCK',201 '    STOCK',213 '     STOCK',228 '     STOCK',241 'Net requirement',
*    258 'PROPOSED CONSUMPTION'.


    write : /1 'DESCRIPTION', 57 'ITEM.CODE',69 'UNIT',74 'UNRESTRICTED',88 '   PENDING',102 '   TOTAL',118 'PROPOSED',132 'NET',
    146 '  ROUND OFF',160 '  LAST_PO',174 '     MOVING',188 '  AVAILABLE',202 '    SAFETY',216 '    QUALITY',228 '     RESERV',
    243 '     BLOCK',259 'Actual',279 'ACTUAL'.

    write : /74 'STOCK',88 '   PO QTY',102 '   PLANNING',118 'CONSUMPTION',132 'REQUIREMENT',146 '  BATCH QTY',160 ' NET PRICE',
    174 '     PRICE',188 '  STOCK',202 '    STOCK',216 '    STOCK',228 '     STOCK',243 '     STOCK',256 'Net requirement',
    273 'PROPOSED CONSUMPTION'.

    skip.
    uline.
    skip.
  elseif r3 eq 'X'.

*    WRITE : /1 'DESCRIPTION',42 'ITEM CODE',54 'UNIT',59 'UNRESTRICTED',73 'QUALITY',87'   PENDING',102 'ACTUAL',
*   115 '  ACTUAL',130 '  LAST_PO',144 '   MOVING',157 'REQUIRED',172'  TOTAL',184 '    SAFETY',198 ' AVAILABLE',
*   212 '    RESERVE',226 '     BLOCK',238 '   MODIFIED'.
*
*    WRITE : /59 'STOCK',87 '   PO QTY',102 'CONSUMPTION',115 '  NET REQD',130'  NET_RATE',144 '   PRICE',157 'FOR 1 BATCH',
*    172 '  PLANNING',184 '   STOCK',198 '    STOCK',212 '  STOCK',226 '    STOCK',238 '     STOCK'.

    write : /1 'DESCRIPTION',57 'ITEM CODE',69 'UNIT',74 'UNRESTRICTED',88 'QUALITY',102'   PENDING',117 'ACTUAL',
      130 '  ACTUAL',145 '  LAST_PO',159 '   MOVING',172 'REQUIRED',187'  TOTAL',199 '    SAFETY',213 ' AVAILABLE',
      227 '    RESERVE',241 '     BLOCK',253 '   MODIFIED'.

    write : /74 'STOCK',102 '   PO QTY',117 'CONSUMPTION',130 '  NET REQD',145'  NET_RATE',159 '   PRICE',172 'FOR 1 BATCH',
    187 '  PLANNING',199 '   STOCK',213 '    STOCK',227 '  STOCK',241 '    STOCK',253'     STOCK'.

    skip.
    uline.
    skip.
  elseif r4 eq 'X'.

*write : /1(40) wa_tab6-maktx,42(10) wa_tab6-idnrk,54(3) wa_tab6-meins,59(12) wa_tab6-labst,73(12) wa_tab6-insme,
*    87(12) wa_tab6-plt_po, 102(12) wa_tab6-req1_b1,116(12) wa_tab6-req2_b1,130(12) wa_tab6-req3_b1, 144(12) wa_tab6-net_req1,
**    102(12) wa_tab6-req_b1, 159 'a',160(12) wa_tab6-net_req1_1,174(12) wa_tab6-net_req1_2,188(12) wa_tab6-net_req1_3,
*    158(12) wa_tab6-netpr,172(12) wa_tab6-verpr,186(12) wa_tab6-menge,200(12) wa_tab6-tot_plan,214(12) wa_tab6-eisbe,228(12) wa_tab6-stock,
*    242(12) wa_tab6-bdmng,256(12) wa_tab6-speme,270(12) wa_tab6-net_req2.

    write : /1 'DESCRIPTION',42 'ITEM CODE',54 'UNIT',59 'UNRESTRICTED',73 'QUALITY',87'   PENDING',102 'CURRENT MONTH',
    116 '   2ND MONTH',130 '   3RD MONTH',
*   144 '  ACTUAL',
   158'  LAST_PO',172 '   MOVING',186 'REQUIRED',200'  TOTAL',214 '    SAFETY',228 ' AVAILABLE',242 '    RESERVE',
   256 '     BLOCK',270 'FINISHED '.

    write : /59 'STOCK',87 '   PO QTY',102 'ACT.CONSUMP.',116 'ACT.CONSUMP.',130 'ACT.CONSUMP.',
*    144 '  NET REQD',
    158'  NET_RATE',172 '   PRICE',
    186 'FOR 1 BATCH',200 '  PLANNING',214 '   STOCK',228 '    STOCK',242 '  STOCK',256 '    STOCK',270 ' PRODUCT'.
    skip.
    uline.
    skip.
  endif.

*&---------------------------------------------------------------------*
*&      Form  USER_COMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->UCOMM      text
*      -->SELFIELD   text
*----------------------------------------------------------------------*


form top.

  data: comment    type slis_t_listheader,
        wa_comment like line of comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'MRP RUNNING FOR PLANT'.
  wa_comment-info+30(4) = wa_tab16-werks.
*  WA_COMMENT-INFO = plant.
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
*&      Form  user_comm
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
endform.                    "user_comm

form user_comm1 using ucomm1 like sy-ucomm selfield type slis_selfield.
*  IF R1 EQ 'X'.
  case sy-ucomm. "SELFIELD-FIELDNAME.
*      loop at it_tab5 into wa_tab5 WHERE nsampqty ne 0 AND chk ne 'X'.
*        MESSAGE 'TICK THE CHECKBOX TO SAVE DATA' TYPE 'E'.
*      ENDLOOP.
*      BREAK-POINT.
    when '&DATA_SAVE'(001).
      perform update.
*      BREAK-POINT.
*      LEAVE TO SCREEN 0.
*      stop.
      leave to transaction 'ZMRP'.  "JYOTSNA
      exit.

*      SET SCREEN 0.

*      PERFORM BDC.

    when others.
  endcase.

endform.                    "USER_COMM

form user_comm2 using ucomm1 like sy-ucomm selfield type slis_selfield.
*  IF R1 EQ 'X'.
  case sy-ucomm. "SELFIELD-FIELDNAME.
*      loop at it_tab5 into wa_tab5 WHERE nsampqty ne 0 AND chk ne 'X'.
*        MESSAGE 'TICK THE CHECKBOX TO SAVE DATA' TYPE 'E'.
*      ENDLOOP.
*      BREAK-POINT.
    when '&DATA_SAVE'(001).
      perform sfupdate.
*      BREAK-POINT.
*      LEAVE TO SCREEN 0.
*      stop.
      leave to transaction 'ZMRP'.  "JYOTSNA
      exit.

*      SET SCREEN 0.

*      PERFORM BDC.

    when others.
  endcase.

endform.                    "USER_COMM


*&---------------------------------------------------------------------*
*&      Form  pick
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->COMMAND    text
*      -->SELFIELD   text
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  UPDATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form update .

  clear : a,p1.
  loop at it_ta6 into wa_ta6 where bom2 eq '02'.
    unpack wa_ta6-matnr to wa_ta6-matnr.
    p1 = 1.
    if wa_ta6-chk1 eq 'X' .
      p1 = p1 + 1.

      select single * from mast where matnr = wa_ta6-matnr and werks = wa_ta6-werks  and stlan eq 1 and stlal =  '01'.
      if sy-subrc eq 0.
        select single * from stko where stlnr eq mast-stlnr and stlal = mast-stlal and loekz eq 'X'.
        if sy-subrc eq 0.
          message ' THIS BOM IS MARKED FOR DELETION' type 'E'.
        endif.
      endif.

    endif.
    if wa_ta6-chk2 eq 'X' .
      p1 = p1 + 1.

      select single * from mast where matnr = wa_ta6-matnr and werks = wa_ta6-werks  and stlan eq 1 and stlal =  '02'.
      if sy-subrc eq 0.
        select single * from stko where stlnr eq mast-stlnr and stlal = mast-stlal and loekz eq 'X'.
        if sy-subrc eq 0.
          message ' THIS BOM IS MARKED FOR DELETION' type 'E'.
        endif.
      endif.

    endif.
    if wa_ta6-chk3 eq 'X' .
      p1 = p1 + 1.

      select single * from mast where matnr = wa_ta6-matnr and werks = wa_ta6-werks  and stlan eq 1 and stlal =  '03'.
      if sy-subrc eq 0.
        select single * from stko where stlnr eq mast-stlnr and stlal = mast-stlal and loekz eq 'X'.
        if sy-subrc eq 0.
          message ' THIS BOM IS MARKED FOR DELETION' type 'E'.
        endif.
      endif.

    endif.
    if wa_ta6-chk4 eq 'X' .
      p1 = p1 + 1.

      select single * from mast where matnr = wa_ta6-matnr and werks = wa_ta6-werks  and stlan eq 1 and stlal =  wa_ta6-bom4.
      if sy-subrc eq 0.
        select single * from stko where stlnr eq mast-stlnr and stlal = mast-stlal and loekz eq 'X'.
        if sy-subrc eq 0.
          message ' THIS BOM IS MARKED FOR DELETION' type 'E'.
        endif.
      endif.
    endif.

    if p1 gt 2.
      message ' SELECT SINGLE BOM' type 'E'.
    endif.
    if p1 lt 2.
      message ' SELECT ANY BOM' type 'E'.
    endif.

    if wa_ta6-chk2 eq 'X' and wa_ta6-bom2 eq space.
      message 'BOM2 DOES NOT EXITS' type 'E'.
    endif.
    if wa_ta6-chk3 eq 'X' and wa_ta6-bom3 eq space.
      message 'BOM3 DOES NOT EXITS' type 'E'.
    endif.
    if wa_ta6-chk4 eq 'X'.
      if wa_ta6-bom4 gt '03'.
        select single * from mast where matnr eq wa_ta6-matnr and werks eq wa_ta6-werks and stlan eq 1 and stlal eq wa_ta6-bom4.
        if sy-subrc eq 4.
          message 'THIS BOM DOES NOT EXITS' type 'E'.
        endif.
      else.
        message 'SELECT OTHER CHECKBOX' type 'E'.
      endif.

    endif.

    if wa_ta6-chk1 eq space and wa_ta6-chk2 eq space and wa_ta6-chk3 eq space and wa_ta6-chk4 eq space.
      message 'SELECT BOM' type 'E'.
    endif.

  endloop.

  loop at it_ta6 into wa_ta6 where bom2 eq space.
    unpack wa_ta6-matnr to wa_ta6-matnr.
    if wa_ta6-chk1 eq 'X'.
      select single * from mast where matnr = wa_ta6-matnr and werks = wa_ta6-werks  and stlan eq 1 and stlal =  '01'.
      if sy-subrc eq 0.
        select single * from stko where stlnr eq mast-stlnr and stlal = mast-stlal and loekz eq 'X'.
        if sy-subrc eq 0.
          message ' THIS BOM IS MARKED FOR DELETION' type 'E'.
        endif.
      endif.
    endif.

    if wa_ta6-chk2 eq 'X'.
      message 'ALTERNATE BOM DOES NOT EXIST' type 'E'.
    elseif wa_ta6-chk3 eq 'X'.
      message 'ALTERNATE BOM DOES NOT EXIST' type 'E'.
    elseif wa_ta6-chk4 eq 'X'.
      message 'ALTERNATE BOM DOES NOT EXIST' type 'E'.
    endif.
    if wa_ta6-chk1 eq space and wa_ta6-chk2 eq space and wa_ta6-chk3 eq space and wa_ta6-chk4 eq space.
      message 'SELECT ANY ONE BOM' type 'E'.
    endif.
  endloop.

  loop at it_ta6 into wa_ta6 where bom2 eq '02'.
    unpack wa_ta6-matnr to wa_ta6-matnr.

    zmrp_data_wa-matnr = wa_ta6-matnr.
    zmrp_data_wa-werks = wa_ta6-werks.
    zmrp_data_wa-zmonth = sy-datum+4(2).
    zmrp_data_wa-zyear = sy-datum+0(4).
    if wa_ta6-chk1 eq 'X'.
      zmrp_data_wa-stlal = wa_ta6-bom1.
    elseif wa_ta6-chk2 eq 'X'.
      zmrp_data_wa-stlal = wa_ta6-bom2.
    elseif wa_ta6-chk3 eq 'X'.
      zmrp_data_wa-stlal = wa_ta6-bom3.
    elseif wa_ta6-chk4 eq 'X'.
      zmrp_data_wa-stlal = wa_ta6-bom4.
    endif.
    zmrp_data_wa-usnam = sy-uname.
    zmrp_data_wa-cpudt = sy-datum.
    modify zmrp_data from zmrp_data_wa.
    clear zmrp_data_wa.
    a = 1.
  endloop.
  if a eq 1.
    message 'DATA SAVED' type 'I'.
  endif.


endform.
*&---------------------------------------------------------------------*
*&      Form  SFGBOM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form sfgbom .
  loop at it_ta6 into wa_ta6.
    wa_bom1-matnr = wa_ta6-matnr.
    wa_bom1-werks = wa_ta6-werks.

    clear : stlal.
    if wa_ta6-chk2 eq 'X'.
      stlal = '02'.
    elseif wa_ta6-chk3 eq 'X'.
      stlal = '03'.
    elseif wa_ta6-chk4 eq 'X'.
      stlal = '04'.
    else.
      stlal = '01'.
    endif.

    select single * from mast where matnr = wa_ta6-matnr and werks = wa_ta6-werks and stlal =  stlal.
    if sy-subrc eq 0.
      select single * from stko where stlnr eq mast-stlnr and stlal = mast-stlal and loekz eq space.
      if sy-subrc eq 0.

        wa_bom1-stlal = stlal.
      endif.
    endif.

    collect wa_bom1 into it_bom1.
    clear wa_bom1.
**    SELECT SINGLE * FROM MAST WHERE MATNR EQ WA_TA6-MATNR AND WERKS EQ WA_TA6-WERKS AND STLAN EQ 1 AND STLAL EQ STLAL.
**      if sy-subrc eq 0.
**        SELECT * FROM stas WHERE stlnr eq mast-stlnr AND stlal eq mast-stlal.
**          if sy-subrc eq 0.
**            SELECT SINGLE * FROM stpo WHERE stlnr eq stas-stlnr AND stlkn eq stas-stlkn AND idnrk
*    PACK WA_TA6-MATNR TO WA_TA6-MATNR.
*    CONDENSE : WA_TA6-MATNR.
*    MODIFY IT_TA6 FROM WA_TA6 TRANSPORTING MATNR.
  endloop.

  if it_bom1 is not initial.
    select * from mast into table it_mast1 for all entries in it_bom1 where matnr eq it_bom1-matnr and werks eq it_bom1-werks and stlan eq 1
    and stlal eq it_bom1-stlal.
    if sy-subrc eq 0.
      select * from stas into table it_stas1 for all entries in it_mast1 where stlnr eq it_mast1-stlnr and stlal eq it_mast1-stlal.
      if sy-subrc eq 0.
        select * from stpo into table it_stpo1 for all entries in it_stas1 where stlnr eq it_stas1-stlnr and stlkn eq it_stas1-stlkn.
      endif.
    endif.
  endif.

  loop at it_ta6 into wa_ta6.
    wa_ta7-matnr = wa_ta6-matnr.
    wa_ta7-maktx = wa_ta6-maktx.
    wa_ta7-bezei = wa_ta6-bezei.
    wa_ta7-werks = wa_ta6-werks.
    wa_ta7-plnmg = wa_ta6-plnmg.
    wa_ta7-plnmg1 = wa_ta6-plnmg1.
    wa_ta7-plnmg2 = wa_ta6-plnmg2.
    wa_ta7-val = wa_ta6-val.
    wa_ta7-bmeng = wa_ta6-bmeng.
    wa_ta7-b1 = wa_ta6-b1.
    wa_ta7-b2 = wa_ta6-b2.


    if wa_ta6-chk2 eq 'X'.
      wa_ta7-bom = wa_ta6-bom2.
    elseif wa_ta6-chk3 eq 'X'.
      wa_ta7-bom = wa_ta6-bom3.
    elseif wa_ta6-chk4 eq 'X'.
      wa_ta7-bom = wa_ta6-bom4.
    else.
      wa_ta7-bom = wa_ta6-bom1.
    endif.



*    WRITE : / 'A',WA_TA6-MATNR,WA_TA6-MAKTX,WA_TA6-BEZEI,WA_TA6-WERKS,WA_TA6-PLNMG,WA_TA6-PLNMG1,WA_TA6-PLNMG2,WA_TA6-VAL,WA_TA6-BMENG,
*    WA_TA6-B1,WA_TA6-B2,WA_TA6-BOM1,WA_TA6-CHK1,WA_TA6-BOM2,WA_TA6-CHK2.
    clear : stlal.
    stlal = wa_ta7-bom.
*    IF WA_TA6-CHK2 EQ 'X'.
*      STLAL = '02'.
*    ELSEIF WA_TA6-CHK3 EQ 'X'.
*      STLAL = '03'.
*    ELSEIF WA_TA6-CHK4 EQ 'X'.
*      STLAL = '04'.
*    ELSEIF WA_TA6-CHK5 EQ 'X'.
*      STLAL = '05'.
*    ELSEIF WA_TA6-CHK6 EQ 'X'.
*      STLAL = WA_TA6-BOM6.
*    ELSE.
*      STLAL = '01'.
*    ENDIF.
    read table it_mast1 into wa_mast1 with key matnr = wa_ta6-matnr werks = wa_ta6-werks stlan = 1 stlal = stlal.
    if sy-subrc eq 0.
      select single * from stko where stlnr eq wa_mast1-stlnr and stlal = wa_mast1-stlal and loekz eq space.
      if sy-subrc eq 0.
        loop at it_stas1 into wa_stas1 where stlnr = wa_mast1-stlnr and stlal = wa_mast1-stlal.
          loop at it_stpo1 into wa_stpo1 where stlnr = wa_stas1-stlnr and stlkn = wa_stas1-stlkn and idnrk cs 'H'.
            wa_ta7-idnrk = wa_stpo1-idnrk.
            collect wa_ta7 into it_ta7.
            clear wa_ta7.
          endloop.
        endloop.
      endif.
    endif.
  endloop.

  if it_ta7 is not initial.
    select * from mast into table it_mast2 for all entries in it_ta7 where matnr eq it_ta7-idnrk  and werks eq it_ta7-werks and stlan eq 1.
  endif.

  loop at it_ta7 into wa_ta7.
    wa_ta8-matnr = wa_ta7-matnr.
    wa_ta8-maktx = wa_ta7-maktx.
    wa_ta8-bezei = wa_ta7-bezei.
    wa_ta8-werks = wa_ta7-werks.
    wa_ta8-plnmg = wa_ta7-plnmg.
    wa_ta8-plnmg1 = wa_ta7-plnmg1.
    wa_ta8-plnmg2 = wa_ta7-plnmg2.
    wa_ta8-val = wa_ta7-val.
    wa_ta8-bmeng = wa_ta7-bmeng.
    wa_ta8-b1 = wa_ta7-b1.
    wa_ta8-b2 = wa_ta7-b2.
    wa_ta8-idnrk = wa_ta7-idnrk.
    wa_ta8-bom = wa_ta7-bom.




**************ALTERNARE BOM**************
    read table it_mast2 into wa_mast2 with key matnr = wa_ta7-idnrk werks = wa_ta7-werks stlal =  '01'.
    if sy-subrc eq 0.
      select single * from stko where stlnr eq wa_mast2-stlnr and stlal = wa_mast2-stlal and loekz eq space.
      if sy-subrc eq 0.
        wa_ta8-hbom1 = '01'.
      endif.
    endif.
    read table it_mast2 into wa_mast2 with key matnr = wa_ta7-idnrk werks = wa_ta7-werks stlal =  '02'.
    if sy-subrc eq 0.
      select single * from stko where stlnr eq wa_mast2-stlnr and stlal = wa_mast2-stlal and loekz eq space.
      if sy-subrc eq 0.
        wa_ta8-hbom2 = '02'.
      endif.
    endif.
    read table it_mast2 into wa_mast2 with key matnr = wa_ta7-idnrk werks = wa_ta7-werks stlal =  '03'.
    if sy-subrc eq 0.
      select single * from stko where stlnr eq wa_mast2-stlnr and stlal = wa_mast2-stlal and loekz eq space.
      if sy-subrc eq 0.
        wa_ta8-hbom3 = '03'.
      endif.
    endif.


    select single * from zmrp_data where matnr eq wa_ta7-idnrk and werks eq wa_ta7-werks and zmonth eq sy-datum+4(2) and zyear eq sy-datum+0(4).
    if sy-subrc eq 0.
      select single * from mast where matnr eq zmrp_data-matnr and werks eq zmrp_data-werks and stlal eq zmrp_data-stlal.
      if sy-subrc eq 0.
        select single * from stko where stlnr eq mast-stlnr and stlal = mast-stlal and loekz eq space.
        if sy-subrc eq 0.
          if zmrp_data-stlal eq '01'.
            wa_ta8-hchk1 = 'X'.
            wa_ta8-hbom1 = '01'.
          elseif zmrp_data-stlal eq '02'.
            wa_ta8-hchk2 = 'X'.
            wa_ta8-hbom2 = '02'.
          elseif zmrp_data-stlal eq '03'.
            wa_ta8-hchk3 = 'X'.
            wa_ta8-hbom3 = '03'.
          else.
            wa_ta8-hchk4 = 'X'.
            wa_ta8-hbom4 = zmrp_data-stlal.
          endif.
        endif.
      endif.
    else.

      select single * from mast where matnr eq wa_ta7-idnrk and werks eq wa_ta7-werks and stlal eq '01'.
      if sy-subrc eq 0.
        select single * from stko where stlnr eq mast-stlnr and stlal = mast-stlal and loekz eq space.
        if sy-subrc eq 0.
          wa_ta8-hchk1 = 'X'.
        endif.
      endif.
    endif.
    collect wa_ta8 into it_ta8.
    clear wa_ta8.
  endloop.




  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_s = 'MATERIAL'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'MAKTX'.
  wa_fieldcat-seltext_s = 'PRODUCT'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'BEZEI'.
  wa_fieldcat-seltext_s = 'PACK SIZE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'WERKS'.
  wa_fieldcat-seltext_s = 'PLANT'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

*  wa_fieldcat-fieldname = 'BEDAE'.
*  wa_fieldcat-seltext_s = 'TYPE'.
*  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'PLNMG'.
  wa_fieldcat-seltext_s = 'QTY1'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

*  wa_fieldcat-fieldname = 'MEINS'.
*  wa_fieldcat-seltext_s = 'UNIT'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'D1'.
*  wa_fieldcat-seltext_s = 'MONTH1'.
*  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'PLNMG1'.
  wa_fieldcat-seltext_s = 'QTY2'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

*  wa_fieldcat-fieldname = 'MEINS1'.
*  wa_fieldcat-seltext_s = 'UNIT2'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'D2'.
*  wa_fieldcat-seltext_s = 'MONTH2'.
*  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'PLNMG2'.
  wa_fieldcat-seltext_s = 'QTY3'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

*  wa_fieldcat-fieldname = 'MEINS2'.
*  wa_fieldcat-seltext_s = 'UNIT3'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'D3'.
*  wa_fieldcat-seltext_s = 'MONTH3'.
*  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'VAL'.
  wa_fieldcat-seltext_s = 'REQ. QTY'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'BMENG'.
  wa_fieldcat-seltext_s = 'STD. BATCH SIZE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'B1'.
  wa_fieldcat-seltext_s = 'MOD. REQ QTY'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'B2'.
  wa_fieldcat-seltext_s = 'NO. OF BATCHES'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'BOM'.
  wa_fieldcat-seltext_s = 'FG BOM'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'IDNRK'.
  wa_fieldcat-seltext_l = 'HALB CODE'.
*  WA_FIELDCAT-CHECKBOX = 'X'.
*  WA_FIELDCAT-EDIT = 'X'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'HBOM1'.
  wa_fieldcat-seltext_s = 'HBOM1'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'HCHK1'.
  wa_fieldcat-seltext_l = 'SELECT HBOM1'.
  wa_fieldcat-checkbox = 'X'.
  if ( r1 eq 'X' or r11 eq 'X' ) and sy-uname eq 'ITBOM01' or sy-uname eq 'MMPURNSK01'.
    wa_fieldcat-edit = 'X'.
  elseif ( r1 eq 'X' or r11 eq 'X' )  and sy-uname eq 'ITBOM01' or sy-uname eq 'MMPURGOA01'.
    wa_fieldcat-edit = 'X'.
  endif.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.


  wa_fieldcat-fieldname = 'HBOM2'.
  wa_fieldcat-seltext_s = 'HBOM2'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'HCHK2'.
  wa_fieldcat-seltext_l = 'SELECT HBOM2'.
  wa_fieldcat-checkbox = 'X'.
  if ( r1 eq 'X' or r11 eq 'X' ) and sy-uname eq 'ITBOM01' or sy-uname eq 'MMPURNSK01'.
    wa_fieldcat-edit = 'X'.
  elseif ( r1 eq 'X' or r11 eq 'X' ) and sy-uname eq 'ITBOM01' or sy-uname eq 'MMPURGOA01'.
    wa_fieldcat-edit = 'X'.
  endif.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'HBOM3'.
  wa_fieldcat-seltext_s = 'HBOM3'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'HCHK3'.
  wa_fieldcat-seltext_l = 'SELECT HBOM3'.
  wa_fieldcat-checkbox = 'X'.
  if ( r1 eq 'X' or r11 eq 'X' ) and sy-uname eq 'ITBOM01' or sy-uname eq 'MMPURNSK01'.
    wa_fieldcat-edit = 'X'.
  elseif ( r1 eq 'X' or r11 eq 'X' )  and sy-uname eq 'ITBOM01' or sy-uname eq 'MMPURGOA01'.
    wa_fieldcat-edit = 'X'.
  endif.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.


  wa_fieldcat-fieldname = 'HBOM4'.
  wa_fieldcat-seltext_s = 'OTHR HBOM'.
  if ( r1 eq 'X' or r11 eq 'X' ) and sy-uname eq 'ITBOM01' or sy-uname eq 'MMPURNSK01'.
    wa_fieldcat-edit = 'X'.
  elseif ( r1 eq 'X' or r11 eq 'X' ) and sy-uname eq 'ITBOM01' or sy-uname eq 'MMPURGOA01'.
    wa_fieldcat-edit = 'X'.
  endif.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'HCHK4'.
  wa_fieldcat-seltext_l = 'SELECT'.
  wa_fieldcat-checkbox = 'X'.
  if ( r1 eq 'X' or r11 eq 'X' ) and sy-uname eq 'ITBOM01' or sy-uname eq 'MMPURNSK01'.
    wa_fieldcat-edit = 'X'.
  elseif ( r1 eq 'X' or r11 eq 'X' )  and sy-uname eq 'ITBOM01' or sy-uname eq 'MMPURGOA01'.
    wa_fieldcat-edit = 'X'.
  endif.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'MRP FOR CURRENT MONTH + COMING 2 MONTHS'.


  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = g_repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
      i_callback_user_command = 'USER_COMM2'
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
      t_outtab                = it_ta8
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

endform.
*&---------------------------------------------------------------------*
*&      Form  FG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form fg .
  if it_ta5 is not initial.
    select * from mast into table it_mast for all entries in it_ta5 where matnr eq it_ta5-matnr and werks eq it_ta5-werks and stlan eq '1'.
  endif.
  loop at it_ta5 into wa_ta5.
*  write : / 'c',wa_ta4-matnr,wa_ta4-werks.
*  wa_ta4-bedae,wa_ta4-plnmg,wa_ta4-meins,wa_ta4-d1,wa_ta4-plnmg1,wa_ta4-meins1,wa_ta4-d2,
*    wa_ta4-plnmg2,wa_ta4-meins2,wa_ta4-d3,wa_ta4-val,wa_ta4-bmeng,wa_ta4-b1,wa_ta4-b2.
**    pack wa_ta5-matnr to wa_ta5-matnr.
**    condense : wa_ta5-matnr.
**    modify it_ta5 from wa_ta5 transporting matnr.

    wa_ta6-matnr = wa_ta5-matnr.
    wa_ta6-maktx = wa_ta5-maktx.
    wa_ta6-werks = wa_ta5-werks.
    wa_ta6-plnmg = wa_ta5-plnmg.
    wa_ta6-plnmg1 = wa_ta5-plnmg1.
    wa_ta6-plnmg2 = wa_ta5-plnmg2.
    wa_ta6-val = wa_ta5-val.
    wa_ta6-bmeng = wa_ta5-bmeng.
    wa_ta6-b1 = wa_ta5-b1.
    wa_ta6-b2 = wa_ta5-b2.



    select single * from mvke where matnr eq wa_ta5-matnr.
    if sy-subrc eq 0.
*      write : / mvke-mvgr5.
*    endif.
*    wa_ta6-mvgr5 = mvke-mvgr5.
      select single * from tvm5t where mvgr5 eq mvke-mvgr5.
      if sy-subrc eq 0.
*        wa_ta6-bezei = tvm5t-bezei.
*        write :  / tvm5t-bezei,wa_ta5-matnr.
        wa_ta6-bezei = tvm5t-bezei.
      endif.
      read table it_mast into wa_mast with key matnr = wa_ta5-matnr werks = wa_ta5-werks stlal =  '01'.
      if sy-subrc eq 0.
        select single * from stko where stlnr eq wa_mast-stlnr and stlal = wa_mast-stlal and loekz eq space.
        if sy-subrc eq 0.
          wa_ta6-bom1 = '01'.
        endif.
*************ALTERNARE BOM**************


*        WA_TA6-BOM1 = '01'.
      endif.
    endif.

    read table it_mast into wa_mast with key matnr = wa_ta5-matnr werks = wa_ta5-werks stlal =  '02'.
    if sy-subrc eq 0.
      select single * from stko where stlnr eq wa_mast-stlnr and stlal = wa_mast-stlal and loekz eq space.
      if sy-subrc eq 0.
        wa_ta6-bom2 = '02'.
      endif.
    endif.
    read table it_mast into wa_mast with key matnr = wa_ta5-matnr werks = wa_ta5-werks stlal =  '03'.
    if sy-subrc eq 0.
      select single * from stko where stlnr eq wa_mast-stlnr and stlal = wa_mast-stlal and loekz eq space.
      if sy-subrc eq 0.
        wa_ta6-bom3 = '03'.
      endif.
    endif.

    select single * from zmrp_data where matnr eq wa_ta5-matnr and werks eq wa_ta5-werks and zmonth eq sy-datum+4(2) and zyear eq sy-datum+0(4).
    if sy-subrc eq 0.
      read table it_mast into wa_mast with key matnr = wa_ta5-matnr werks = wa_ta5-werks stlal =  zmrp_data-stlal.
      if sy-subrc eq 0.
        select single * from stko where stlnr eq wa_mast-stlnr and stlal = zmrp_data-stlal and loekz eq space.
        if sy-subrc eq 0.
          if zmrp_data-stlal eq '01'.
            wa_ta6-chk1 = 'X'.
          elseif zmrp_data-stlal eq '02'.
            wa_ta6-chk2 = 'X'.
          elseif zmrp_data-stlal eq '03'.
            wa_ta6-chk3 = 'X'.
          else.
            wa_ta6-chk4 = 'X'.
            wa_ta6-bom4 = zmrp_data-stlal.
          endif.
        else.
          wa_ta6-chk1 = 'X'.
*      WA_TA6-CHK2 = SPACE.
        endif.
      endif.
    else.
      wa_ta6-chk1 = 'X'.
    endif.
*    READ TABLE IT_MAST INTO WA_MAST WITH KEY MATNR = WA_TA5-MATNR WERKS = WA_TA5-WERKS STLAL =  '03'.
*    IF SY-SUBRC EQ 0.
*      WA_TA6-STLAL = '03'.
*    ENDIF.
    collect wa_ta6 into it_ta6.
    clear wa_ta6.
  endloop.

endform.
*&---------------------------------------------------------------------*
*&      Form  SFUPDATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form sfupdate .
  clear : a,p1.

  loop at it_ta8 into wa_ta8 where hbom2 eq '02'.

    p1 = 1.
    if wa_ta8-hchk1 eq 'X' .
      p1 = p1 + 1.
    endif.
    if wa_ta8-hchk2 eq 'X' .
      p1 = p1 + 1.
    endif.
    if wa_ta8-hchk3 eq 'X' .
      p1 = p1 + 1.
    endif.
    if wa_ta8-hchk4 eq 'X' .
      p1 = p1 + 1.
    endif.

    if p1 gt 2.
      message ' SELECT SINGLE BOM' type 'E'.
    endif.
    if p1 lt 2.
      message ' SELECT ANY BOM' type 'E'.
    endif.

    if wa_ta8-hbom2 eq space and wa_ta8-hchk2 eq 'X'.
      message 'BOM2 DOES NOT EXIST' type 'E'.
    endif.
    if wa_ta8-hbom3 eq space and wa_ta8-hchk3 eq 'X'.
      message 'BOM3 DOES NOT EXIST' type 'E'.
    endif.
    if wa_ta8-hbom4 eq space and wa_ta8-hchk4 eq 'X'.
      message 'BOM4 DOES NOT EXIST' type 'E'.
    endif.
    if wa_ta8-hchk4 eq 'X'.
      if wa_ta8-hbom4 gt '03'.
        select single * from mast where matnr eq wa_ta8-idnrk and werks eq wa_ta8-werks and stlal eq wa_ta8-hbom4.
        if sy-subrc eq 4.
          message 'THIS BOM DOES NOT EXIST' type 'E'.
        endif.
      else.
        message 'SELECT OTHER CHECK BOX' type 'E'.
      endif.
    endif.


    if wa_ta8-hchk1 eq 'X' and wa_ta8-hchk2 eq 'X'.
      message 'SELECT EITHER BOM1 OR BOM 2' type 'E'.
    endif.
    if wa_ta8-hchk1 eq space and wa_ta8-hchk2 eq space and wa_ta8-hchk3 eq space and wa_ta8-hchk4 eq space.
      message 'SELECT ANY ONE FROM AVAILABLE BOM' type 'E'.
    endif.


  endloop.

  loop at it_ta8 into wa_ta8 where hbom2 eq space.
    if wa_ta8-hchk2 eq 'X' or wa_ta8-hchk3 eq 'X' or wa_ta8-hchk4 eq 'X'.
      message 'ALTERNATE BOM DOES NOT EXIST FOR THIS PRODUCT' type 'E'.
    endif.
    if wa_ta8-hchk1 eq space and wa_ta8-hchk2 eq space.
      message 'SELECT EITHER HBOM1 OR HBOM2' type 'E'.
    endif.
  endloop.



  loop at it_ta8 into wa_ta8 where hbom2 eq '02'.
*    UNPACK WA_ta8-MATNR TO WA_ta8-MATNR.

    zmrp_data_wa-matnr = wa_ta8-idnrk.
    zmrp_data_wa-werks = wa_ta8-werks.
    zmrp_data_wa-zmonth = sy-datum+4(2).
    zmrp_data_wa-zyear = sy-datum+0(4).
    if wa_ta8-hchk1 eq 'X'.
      zmrp_data_wa-stlal = wa_ta8-hbom1.
    elseif wa_ta8-hchk2 eq 'X'.
      zmrp_data_wa-stlal = wa_ta8-hbom2.
    elseif wa_ta8-hchk3 eq 'X'.
      zmrp_data_wa-stlal = wa_ta8-hbom3.
    elseif wa_ta8-hchk4 eq 'X'.
      zmrp_data_wa-stlal = wa_ta8-hbom4.
    endif.
    zmrp_data_wa-usnam = sy-uname.
    zmrp_data_wa-cpudt = sy-datum.
    modify zmrp_data from zmrp_data_wa.
    clear zmrp_data_wa.
    a = 1.
  endloop.
  if a eq 1.
    message'HALB BOM SAVED' type 'I'.
  endif.

endform.
*&---------------------------------------------------------------------*
*&      Form  AUTHORIZATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form authorization .
  select werks name1 from t001w into table itab_t001w where werks in plant.

  loop at itab_t001w into wa_t001w.
    authority-check object 'M_BCO_WERK'
           id 'WERKS' field wa_t001w-werks.
    if sy-subrc <> 0.
      concatenate 'No authorization for Plant' wa_t001w-werks into msg
      separated by space.
      message msg type 'E'.
    endif.
  endloop.
endform.
