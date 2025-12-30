*&---------------------------------------------------------------------*
*& Report  ZIS1
*& DEVELOPED BY JYOTSNA - 1.6.2010
*&---------------------------------------------------------------------*
*& Credit note Summary.
*& TR - BCDK936236 - Add BCLS div
*&---------------------------------------------------------------------*
******** changes done in ZCDS_PRINTING_GST_NEW4 to add email log by sabu
*** PERFORM ACCCHK. ADDED ON 8.6.25 TO CHECK ACCOUNTING DOC
report  zis1 no standard page heading line-size 200.
tables : vbrk,
         vbrp,
         kna1,
         PRCD_ELEMENTS,
         bkpf,
         vbkd,
         t001w,
         adrc,
         j_1imocust,
         makt,
         mvke,
         tvm5t,
         mara,
         t001,
         spell,
         vbak,
         kotn532,
         kondn,
          ibatch ,"mcha,
         tvfkt,
        a602,
         konp,
*         a611,
         marc,
         pa0105,
         adr6,
         zdsmter,
         zemail_log,
         yterrallc,
         zcdnfimm1,
         tvaut.


type-pools:  slis.

data: g_repid     like sy-repid,
      fieldcat    type slis_t_fieldcat_alv,
      wa_fieldcat like line of fieldcat,
      sort        type slis_t_sortinfo_alv,
      wa_sort     like line of sort,
      layout      type slis_layout_alv.
data : it_email  type table of zemail_log,
       it_email1 type table of zemail_log with header line,

       wa_email  type zemail_log.
types : begin of typ_konv,
          knumv type PRCD_ELEMENTS-knumv,
          kposn type PRCD_ELEMENTS-kposn,
          kappl type PRCD_ELEMENTS-kappl,
          kschl type PRCD_ELEMENTS-kschl,
          kawrt type PRCD_ELEMENTS-kawrt,
          kbetr type PRCD_ELEMENTS-kbetr,
          kwert type PRCD_ELEMENTS-kwert,
        end of typ_konv.

data : it_vbrk            type table of vbrk,
       wa_vbrk            type vbrk,
       it_vbrp            type table of vbrp,
       wa_vbrp            type vbrp,
       it_marc            type table of marc,
       wa_marc            type marc,
       it_konv            type table of typ_konv,
       wa_konv            type typ_konv,
       it_konv1           type table of typ_konv,
       wa_konv1           type typ_konv,
       it_vbap            type table of vbap,
       wa_vbap            type vbap,
       it_ysd_cus_div_dis type table of ysd_cus_div_dis,
       wa_ysd_cus_div_dis type ysd_cus_div_dis,
       it_yterrallc       type table of yterrallc,
       wa_yterrallc       type yterrallc,
       it_yterrallc1      type table of yterrallc,
       wa_yterrallc1      type yterrallc,
       it_pa0001          type table of pa0001,
       wa_pa0001          type pa0001,
       it_zdsmter         type table of zdsmter,
       wa_zdsmter         type zdsmter,
       it_konv2           type table of PRCD_ELEMENTS,
       wa_konv2           type PRCD_ELEMENTS.
data : cnt type i.

types : begin of itab1,
          werks     type vbrp-werks,
          vbeln     type vbrk-vbeln,
          fkart     type vbrk-fkart,
          fkdat     type vbrk-fkdat,
          netwr     type vbrk-netwr,
          mwsbp     type vbrp-mwsbp,
*  FmwsbP type vbrP-mwsbp,
          kunag     type vbrk-kunag,
          aubel     type vbrp-aubel,
          matnr     type vbrp-matnr,
          posnr     type vbrp-posnr,
          charg     type vbrp-charg,
          lgort     type vbrp-lgort,
          fkimg_f   type vbrp-fkimg,
         fkimg_c   type vbrp-fkimg,
          "fkimg_c   type string,
          qty       type vbrp-fkimg,
          arktx     type vbrp-arktx,
          z001      type PRCD_ELEMENTS-kwert,
          pts       type PRCD_ELEMENTS-kwert,
          ptsval    type PRCD_ELEMENTS-kwert,
          z099      type PRCD_ELEMENTS-kwert,
          ztot      type PRCD_ELEMENTS-kwert,
          zpst      type PRCD_ELEMENTS-kwert,
          zspd      type PRCD_ELEMENTS-kwert,
          zc09      type PRCD_ELEMENTS-kwert,
          zcus      type PRCD_ELEMENTS-kwert,
          z001val   type PRCD_ELEMENTS-kwert,
          z099val   type PRCD_ELEMENTS-kwert,
          ztotval   type PRCD_ELEMENTS-kwert,
          zpstval   type PRCD_ELEMENTS-kwert,
          zspdval   type PRCD_ELEMENTS-kwert,
          zc09val   type PRCD_ELEMENTS-kwert,
          zcusval   type PRCD_ELEMENTS-kwert,
          disc      type PRCD_ELEMENTS-kwert,
          zgrp      type PRCD_ELEMENTS-kwert,
          zfrg      type PRCD_ELEMENTS-kwert,
          zfrg_rt   type PRCD_ELEMENTS-kwert,

          joig      type PRCD_ELEMENTS-kwert,
          josg      type PRCD_ELEMENTS-kwert,
          jocg      type PRCD_ELEMENTS-kwert,
          joug      type PRCD_ELEMENTS-kwert,

          ttext(10) type c,
          steuc     type marc-steuc,
          taxablev  type PRCD_ELEMENTS-kwert,

        end of itab1.

types : begin of itab2,
          werks      type vbrp-werks,
          kunnr      type t001w-kunnr,
*  vbeln TYPE vbrk-vbeln,
          vbeln(12)  type c,
          fkart      type vbrk-fkart,
          fkdat      type vbrk-fkdat,
          netwr      type vbrk-netwr,
* mwsbk type vbrk-mwsbk,
          mwsbp      type vbrp-mwsbp,
          kunag      type vbrk-kunag,
*   kunag TYPE p,
          "name1      type adrc-name1,
          name1      type  char100,
          name2      type  char100,
          name3      type char100,
          name4      type char100,
          ort01      type adrc-city1,
          gstin2     type kna1-stcd3,
          total      type p decimals 2,
*   belnr TYPE bkpf-belnr,
          belnr(12)  type c,
*    AUBEL TYPE VBRP-AUBEL,
          cldt       type vbkd-fkdat,
          aubel(12)  type c,
          bstkd      type vbkd-bstkd,
          bstdk      type vbkd-bstdk,
          bstkd_e    type vbkd-bstkd_e,
          bstdk_e    type vbkd-bstdk_e,
          matnr      type vbrp-matnr,
          spart      type mara-spart,
          posnr      type vbrp-posnr,
          charg      type vbrp-charg,
          lgort      type vbrp-lgort,
          pstyv      type vbrp-pstyv,
          "fkimg      type vbrp-fkimg,
          fkimg      type P,
          fkimg_f    type p,
          fkimg_c    type p,
          qty        type p,
          qty1       type vbrp-fkimg,
          arktx      type vbrp-arktx,
          cname1     type adrc-name1,
          cname2     type adrc-name2,
          cname3     type adrc-name3,
          cname4     type adrc-name4,
          city1      type adrc-city1,
          cj_1icstno type j_1imocust-j_1icstno,
          cj_1ilstno type j_1imocust-j_1ilstno,
          j_1icstno  type j_1imocust-j_1icstno,
          j_1ilstno  type j_1imocust-j_1ilstno,
          z001(7)    type c,
          ztot       type PRCD_ELEMENTS-kwert,
          ztotval    type PRCD_ELEMENTS-kwert,
          zspdval    type PRCD_ELEMENTS-kwert,
          zcusval    type PRCD_ELEMENTS-kwert,
          rate       type PRCD_ELEMENTS-kwert,
          disc       type PRCD_ELEMENTS-kwert,
          bcnetwr    type PRCD_ELEMENTS-kwert,
          xlnetwr    type PRCD_ELEMENTS-kwert,
          bezei      type tvm5t-bezei,
          bstnk      type vbak-bstnk,
          bstdk1     type vbak-bstdk,
          submi      type vbak-submi,
          mahdt      type vbak-mahdt,
          rej(20),
          expdt(5)   type c,
*  vtext type tvfkt-vtext,
          vtext(30)  type c,
          typ(1)     type c,
          gstin1     type kna1-stcd3,
          ttext(10)  type c,
          steuc      type marc-steuc,
          joig       type PRCD_ELEMENTS-kwert,
          josg       type PRCD_ELEMENTS-kwert,
          jocg       type PRCD_ELEMENTS-kwert,
          joug       type PRCD_ELEMENTS-kwert,
          zfrg(9)    type c,
          ptsval     type PRCD_ELEMENTS-kwert,
          zfrg_rt(6) type c,
          pts(7)     type c,
          taxval     type PRCD_ELEMENTS-kwert,
          taxablev   type PRCD_ELEMENTS-kwert,
          fkdat1(10) type c,
        end of itab2.

data  num(70).
data : mmline  like tline occurs 0 with header line.
data : count type i.
data : count1 type i.
data: c1(1)   type c,
      w4(1)   type c,
      w41     type string,
      w42     type string,
      w40     type string,
      wd1(10) type c,
      wd2(10) type c,
      wd3(10) type c,
      wd4(10) type c.

types: begin of typ_t001w,
         werks type werks_d,
         name1 type name1,
       end of typ_t001w.

data : itab_t001w type table of typ_t001w,
       wa_t001w   type typ_t001w.

types: begin of dis1,
         fkart   type vbrk-fkart,
         vbeln   type vbrk-vbeln,
         netwr   type vbrk-netwr,
         netwr1  type vbrk-netwr,
         mwsbp   type vbrp-mwsbp,
         disc    type PRCD_ELEMENTS-kwert,
         zcusval type PRCD_ELEMENTS-kwert,
       end of dis1.

types : begin of tax1,
          vbeln type vbrk-vbeln,
          mwsbp type vbrp-mwsbp,
        end of tax1.

types : begin of ext1,
          vbeln type vbrk-vbeln,
          aubel type vbrp-aubel,
          knumv type vbak-knumv,
          posnr type vbap-posnr,
        end of ext1.

types : begin of ext2,
          werks type vbrp-werks,
          vbeln type vbrp-vbeln,
          matnr type vbrp-matnr,
          charg type vbap-charg,
          zmeng type vbap-zmeng,
*  vbeln type vbrk-vbeln,
          aubel type vbrp-aubel,
          mrp   type konp-kbetr,
          pts   type konp-kbetr,
          posnr type vbap-posnr,
          knumv type vbak-knumv,
        end of ext2.

types : begin of itab4,
          kunag     type vbrk-kunag,
          vbeln(12) type c,
        end of itab4.
types : begin of itab5,
          vbeln(12) type c,
          spart     type mara-spart,
          kunag     type vbrk-kunag,
        end of itab5.

types : begin of tar1,
          vbeln      type vbrk-vbeln,
          sr(3)      type c,
          steuc      type marc-steuc,
          arktx      type vbrp-arktx,
          bezei      type tvm5t-bezei,
          z001(7)    type c,
          pts(7)     type c,
          qty(12)    type c,
          ptsval     type PRCD_ELEMENTS-kwert,
          zfrg_rt(6) type c,
          zfrg(9)    type c,
          taxablev   type PRCD_ELEMENTS-kwert,
          expdt(5)   type c,
          fkimg      type vbrp-fkimg,
          rate       type PRCD_ELEMENTS-kwert,
          ztotval    type PRCD_ELEMENTS-kwert,
          charg      type vbrp-charg,
        end of tar1.

data : it_tab1 type table of itab1,
       wa_tab1 type itab1,
       it_tab2 type table of itab2,
       wa_tab2 type itab2,
       it_tab3 type table of itab2,
       wa_tab3 type itab2,
       it_tab4 type table of itab4,
       wa_tab4 type itab4,
       it_tab5 type table of itab5,
       wa_tab5 type itab5,
       it_dis1 type table of dis1,
       wa_dis1 type dis1,
       it_tax1 type table of tax1,
       wa_tax1 type tax1,
       it_ext1 type table of ext1,
       wa_ext1 type ext1,
       it_ext2 type table of ext2,
       wa_ext2 type ext2,
       it_tar1 type table of ZCDN1,
       wa_tar1 type ZCDN1.

data : pts1    type p decimals 2,
       zfrg_rt type p decimals 2.

data : mesg(40) type c,
       msg      type string,
       total    type PRCD_ELEMENTS-kwert,
       total1   type PRCD_ELEMENTS-kwert,
       total2   type p,
       tax      type vbrp-mwsbp.

data: txt1(10) type c.

data: ctotal(12) type c.

data : page1       type i,
       page2       type i,
       page3       type i,
       page4(1)    type c,
       rate        type PRCD_ELEMENTS-kwert,
       vrate       type PRCD_ELEMENTS-kwert,
       scheme1(12) type c,
       scheme2(12) type c,
       val1        type PRCD_ELEMENTS-kwert,
       val2        type PRCD_ELEMENTS-kwert.
data: exrate type p decimals 3.

data: cname1     type adrc-name1,
      cname2     type adrc-name1,
      cname3     type adrc-name1,
      cname4     type adrc-name1,
      city1      type adrc-city1,
      cj_1icstno type j_1imocust-j_1icstno,
      cj_1ilstno type j_1imocust-j_1ilstno,
      gstin1     type kna1-stcd3,

      name1      type adrc-NAME1,
      name2      type adrc-NAME1,
      name3      type adrc-NAME1,
      name4      type adrc-NAME1,
      ort01      type adrc-city1,
      gstin2     type kna1-stcd3,
      vtext(30)  type c,
      fkdat1(10) type c,
      naubel     type vbrp-aubel,
      cldt       type vbkd-fkdat,
      bstnk      type vbak-bstnk,
      bstdk1     type vbak-bstdk,
      submi      type vbak-submi,
      mahdt      type vbak-mahdt,
      bstkd      type vbkd-bstkd,
      bstdk      type vbkd-bstdk,
      bstkd_e    type vbkd-bstkd_e,
      bstdk_e    type vbkd-bstdk_e.



data : netwr      type vbrp-netwr,
       mwsbp      type vbrp-mwsbp,
       discount   type vbrp-mwsbp,
       ttext1(10) type c.


data : tot          type p decimals 2,
       tdis         type PRCD_ELEMENTS-kwert,
       ttax         type PRCD_ELEMENTS-kwert,
       igst         type PRCD_ELEMENTS-kwert,
       sgst         type PRCD_ELEMENTS-kwert,
       cgst         type PRCD_ELEMENTS-kwert,
       ugst         type PRCD_ELEMENTS-kwert,
       tval         type PRCD_ELEMENTS-kwert,
       tval1        type p decimals 2,
       xlval        type PRCD_ELEMENTS-kwert,
       bcval        type PRCD_ELEMENTS-kwert,
       lsval        type PRCD_ELEMENTS-kwert,
       totval       type PRCD_ELEMENTS-kwert,
       rtotval2     type p,
*       totval1 type konv-kwert,
       totval1      like pc207-betrg,
       words(200)   type c,
       zcusval      type PRCD_ELEMENTS-kwert,
       zcusval1(10) type c,
       rzcusval     type p,
       text(9)      type c,
       text1(11)    type c,
       text2(15)    type c,
       ttext(11)    type c,
       zspdval      type PRCD_ELEMENTS-kwert,
       rtotval1     type p,
       rtotval      type PRCD_ELEMENTS-kwert,
       ltext        type string,
       fkart        type vbrk-fkart,
       zcusrate     type kbetr,
       zcusrate1    type CHAR6,
       josgrt       type PRCD_ELEMENTS-kwert,
       jocgrt       type PRCD_ELEMENTS-kwert,
       joigrt       type PRCD_ELEMENTS-kwert,
       jougrt       type PRCD_ELEMENTS-kwert.
data irn type j_1ig_irn.
*DATA : joigrt Type String.
types: begin of t_usr05,
         bname type usr05-bname,
         parid type usr05-parid,
         parva type usr05-parva,
       end of t_usr05.

types: begin of mail3,
         kunag      type vbrk-kunag,
         usrid_long type pa0105-usrid_long,
*         SPART TYPE ZDSMTER-SPART,
       end of mail3.


data : it_mail3 type table of mail3,
       wa_mail3 type mail3.

data : wa_usr05 type t_usr05.

data : begin of itab_konv occurs 0.
         include structure PRCD_ELEMENTS.
       data : end of itab_konv.

data : ed    type konp-kbetr,
       mrp   type konp-kbetr,
       pts   type PRCD_ELEMENTS-kwert,
       aubel type vbap-vbeln.
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
data : lv_ref  type vbap-VGBEL.


******************************Varaibles used for PDF mail
*DATA: i_otf       TYPE itcoo OCCURS 0 WITH HEADER LINE,
*      i_tline     TYPE TABLE OF tline WITH HEADER LINE,
*      i_receivers TYPE TABLE OF somlreci1 WITH HEADER LINE,
*      i_record    LIKE solisti1 OCCURS 0 WITH HEADER LINE, "*     Objects to send mail.
*      i_objpack   LIKE sopcklsti1 OCCURS 0 WITH HEADER LINE,
*      i_objtxt    LIKE solisti1 OCCURS 0 WITH HEADER LINE,
**      i_objbin    LIKE solisti1 OCCURS 0 WITH HEADER LINE,
*      i_objbin    LIKE solix OCCURS 0 WITH HEADER LINE,
*      i_reclist   LIKE somlreci1 OCCURS 0 WITH HEADER LINE, "*     Work Area declarations
*           i_xstring   TYPE xstring,
*      wa_objhead  TYPE soli_tab,
*      w_ctrlop    TYPE ssfctrlop,
*      w_compop    TYPE ssfcompop,
**      L_DEVTYPE TYPE RSPOPTYPE,
*      l_devtype   TYPE  i,
*      w_return    TYPE ssfcrescl,
*      wa_doc_chng TYPE sodocchgi1,
*      w_data      TYPE sodocchgi1,
*      wa_buffer   TYPE string, "To convert from 132 to 255
**     Variables declarations
**      v_form_name TYPE rs38l_fnam,
*      v_len_in    LIKE sood-objlen,
*      v_len_out   LIKE sood-objlen,
*      v_len_outn  TYPE i,
*      v_lines_txt TYPE i,
*      v_lines_bin TYPE i.
*DATA: in_mailid TYPE ad_smtpadr.
data :  gd1 type sy-datum.  "new invoice format.
*
data : v_fm type rs38l_fnam.
*data : L_fm type rs38l_fnam,
*      FM TYPE  rs38l_fnam.




*DATA : OPTIONS        TYPE ITCPO,
*       L_OTF_DATA     LIKE ITCOO OCCURS 10,
*       L_ASC_DATA     LIKE TLINE OCCURS 10,
*       L_DOCS         LIKE DOCS  OCCURS 10,
*       L_PDF_DATA     LIKE SOLISTI1 OCCURS 10,
*       L_PDF_DATA1    LIKE SOLISTI1 OCCURS 10,
*       L_BIN_FILESIZE TYPE I.
*DATA :  RESULT      LIKE  ITCPP.
*DATA: DOCDATA LIKE SOLISTI1  OCCURS  10,
*      OBJHEAD LIKE SOLISTI1  OCCURS  1,
*      OBJBIN1 LIKE SOLISTI1  OCCURS 10,
*      OBJBIN  LIKE SOLISTI1  OCCURS 10.
*DATA: LISTOBJECT LIKE ABAPLIST  OCCURS  1 .
*DATA: DOC_CHNG LIKE SODOCCHGI1.
*DATA RECLIST    LIKE SOMLRECI1  OCCURS  1 WITH HEADER LINE.
*DATA MCOUNT TYPE I.
*DATA : V_WERKS TYPE WERKS_D.
*DATA : V_TEXT(70) TYPE C.
*DATA: LTX LIKE T247-LTX.

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

types : begin of itap1,
          kunag type vbrk-kunag,
        end of itap1.

types : begin of itapd1,
          kunag type vbrk-kunag,
          spart type mara-spart,
        end of itapd1.

types : begin of itap2,
          kunag      type vbrk-kunag,
          usrid_long type pa0105-usrid_long,
        end of itap2.

types : begin of itap3,
          kunnr type ysd_cus_div_dis-kunnr,
          bzirk type zdsmter-zdsm,
          plans type yterrallc-plans,
        end of itap3.

data : date1      type sy-datum,
       ldate1     type sy-datum,
       m1(2)      type c,
       y1(4)      type c,
*       GD1        TYPE SY-DATUM,
       invtyp1(3) type c.

data : it_tap1  type table of itap1,
       wa_tap1  type itap1,
       it_tap2  type table of itap2,
       wa_tap2  type itap2,
       it_tap3  type table of itap3,
       wa_tap3  type itap3,
       it_tapd1 type table of itapd1,
       wa_tapd1 type itapd1.

*DATA : V_FM TYPE RS38L_FNAM.
data: format(10) type c.
data: word1 type spell-word.

*************EMAIL **************
types : begin of st_check,
          vbeln type vbrk-vbeln,
        end of st_check.

data : it_check type table of st_check,
       wa_check type          st_check.
data : control  type ssfctrlop.
data : w_ssfcompop type ssfcompop.
data: vbeln type vbrk-vbeln.
data: gjahr type bkpf-gjahr.
data: F(1) type c.
data: it_zexchangerate type table of zexchangerate,
      wa_zexchangerate type zexchangerate.


selection-screen begin of block merkmale with frame title text-001.
select-options : inv for vbrk-vbeln.
select-options : cust for vbrk-kunag.
select-options : p_plant for vbrp-werks .
select-options : p_date for vbrk-fkdat .
*select-options : material for vbrp-matnr,
*                 batch for vbrp-charg.
*                 str_loc FOR vbrp-lgort.
parameters : cr_pr  radiobutton group 57f4,
             dr_pr  radiobutton group 57f4,
             dr_bat radiobutton group 57f4,
             exp_cr radiobutton group 57f4,
             cr_bat RADIOBUTTON GROUP 57f4,
             sto_cr radiobutton group 57f4,
             FI_CR  radiobutton group 57f4,
             FI_DR RADIOBUTTON GROUP 57f4.
parameters : h1 as checkbox.
*parameters: credit radiobutton group 57f4  .
*parameters: debit radiobutton group 57f4  .
*parameters: cred_det radiobutton group 57f4  .
*parameters: deb_det radiobutton group 57f4  .
selection-screen end of block merkmale.

selection-screen begin of block merkmale1 with frame title text-001.
parameters : p1 radiobutton group r1.
parameters : r1 radiobutton group r1,
             r2 radiobutton group r1,
             r3 radiobutton group r1,
             r4 radiobutton group r1,
             r5 radiobutton group r1.
selection-screen end of block merkmale1.

initialization.
  g_repid = sy-repid.

at selection-screen.

  perform authorization.

*  authority-check object '/DSD/SL_WR'
*           id 'WERKS' field p_plant.
*
*  if sy-subrc ne 0.
*    mesg = 'Check your entry'.
*    message mesg type 'E'.
*  endif.

  if p_date is initial and inv is initial.
    message 'ENTER DATE OR NUMBER' type 'E'.
  elseif inv is initial and p_plant is initial.
    message 'ENTER PLANT' type 'E'.
  endif.
  exit.

at selection-screen output.
  select single bname parid parva from usr05 into wa_usr05 where bname = sy-uname
                                                     and parid = 'ZPLANT'.
  p_plant-sign = 'I'.
  p_plant-option = 'BT'.
  p_plant-low = wa_usr05-parva.
  p_plant-high = wa_usr05-parva.
  append p_plant.


start-of-selection.

  gd1+6(2) = '01'.
  gd1+4(2) = '01'.
  gd1+0(4) = '2020'.

*  if cr_pr = 'X'.
*    perform cr_print.
*  elseif dr_pr = 'X'.
*  PERFORM DR_PRINT.
*  endif.

  if p1 = 'X'.
    perform dr_print.
  else.
    perform dr_mail.
  endif.
*&---------------------------------------------------------------------*
*&      Form  top1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form top1.

  data: comment    type slis_t_listheader,
        wa_comment like line of comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'DEBIT NOTE SUMMARY'.
*  WA_COMMENT-INFO = P_FRMDT.
  append wa_comment to comment.

  call function 'REUSE_ALV_COMMENTARY_WRITE'
    exporting
      it_list_commentary = comment.
*     I_LOGO                   = 'ENJOYSAP_LOGO'
*     I_END_OF_LIST_GRID       =
*     I_ALV_FORM               = .


  clear comment.

endform.                                                    "TOP1
*&---------------------------------------------------------------------*
*&      Form  DR_PRINT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form dr_print.
  clear : text2,text1.
  if dr_pr eq 'X' or dr_bat eq 'X' OR FI_DR eq 'X'.
    select single * from zcdnfimm1 where belnr in inv. "26.8.21
    if sy-subrc eq 0.
      text1 = 'TAX INVOICE'.
      text2 = 'TAX INVOICE'.
    else.
      text1 = 'DEBIT NOTE'.
      text2 = 'DEBIT MEMO'.
    endif.
    select * from vbrk into table it_vbrk where vbeln in inv and fkdat in p_date and fksto ne 'X' and fkart in ('ZQD','ZQDO','ZDRA','ZD08')  and kunag in cust.
*     in ('ZG2','ZBD','ZRS','ZG3','RE','ZC04','ZQC','ZRRE','ZRRS','ZC08')
    if sy-subrc ne 0.
      message 'NO DATA FOUND' type 'I'.
      exit.
    endif.
  elseif cr_pr eq 'X' or exp_cr eq 'X'or cr_bat eq 'X' or FI_CR eq 'X'.
    text1 = 'CREDIT NOTE'.
    text2 = 'CREDIT MEMO'.
    select * from vbrk into table it_vbrk where vbeln in inv and fkdat in p_date and fksto ne 'X' and fkart
     in ('ZG2','ZBD','ZRS','ZG3','RE','ZC04','ZQC','ZRRE','ZRRS','ZC08','ZRE','ZD08','ZTDS') and kunag in cust.
    if sy-subrc ne 0.
      message 'NO DATA FOUND' type 'I'.
      exit.
    endif.
  elseif sto_cr eq 'X'.
    text1 = 'CREDIT NOTE'.
    text2 = 'CREDIT MEMO'.
    select * from vbrk into table it_vbrk where vbeln in inv and fkdat in p_date and fksto ne 'X' and fkart
     in ( 'ZSR','ZFC' ) and kunag in cust.
    if sy-subrc ne 0.
      message 'NO DATA FOUND' type 'I'.
      exit.
    endif.
  endif.
  if it_vbrk is not initial.
    select knumv kposn kappl kschl kawrt kbetr kwert  from PRCD_ELEMENTS into table it_konv for all entries in it_vbrk where knumv = it_vbrk-knumv  and
*     KSCHL IN ('ZRM','ZGRP','ZFRG','JOIG','JOSG','JOCG','JOUG','Z001').
       kschl in ('ZRM','ZGRP','ZFRG','JOIG','JOSG','JOCG','JOUG','Z001','ZCIF').
*       and kwert gt 0.
    select knumv kposn kappl kschl kawrt kbetr kwert  from PRCD_ELEMENTS into table it_konv1 for all entries in it_vbrk where knumv = it_vbrk-knumv  and
  kschl eq 'ZSPD'.
    select * from vbrp into table it_vbrp for all entries in it_vbrk where  vbeln = it_vbrk-vbeln and werks in p_plant.
    if sy-subrc eq 0.
      select * from marc into table it_marc for all entries in it_vbrp where matnr eq it_vbrp-matnr and werks eq it_vbrp-werks.
    endif.
  endif.
  sort it_konv by knumv kposn kappl kschl.

  loop at it_vbrk into wa_vbrk.
    read table it_vbrp into wa_vbrp with key vbeln = wa_vbrk-vbeln.
    if sy-subrc eq 0.
      wa_check-vbeln = wa_vbrk-vbeln.
      collect wa_check into it_check.
      clear wa_check.
    endif.
  endloop.



***************************************************************************************************************

  if exp_cr eq 'X'.

    call function 'SSF_FUNCTION_MODULE_NAME'
      exporting
*       FORMNAME           = 'ZCDN7'
*****        FORMNAME           = 'ZCDNPRINTGST11_EXP'
        formname           = 'ZCDNPRINTGST11_EXP'
*       VARIANT            = ' '
*       DIRECT_CALL        = ' '
      importing
        fm_name            = v_fm
      exceptions
        no_form            = 1
        no_function_module = 2
        others             = 3.

    control-no_open   = 'X'.
    control-no_close  = 'X'.

  elseIF FI_CR EQ 'X' OR FI_DR EQ 'X'.
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname                 = 'ZCDNPRINTGST12'
*       VARIANT                  = ' '
*       DIRECT_CALL              = ' '
     IMPORTING
       FM_NAME                  = v_FM
     EXCEPTIONS
       NO_FORM                  = 1
       NO_FUNCTION_MODULE       = 2
       OTHERS                   = 3
              .
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

      control-no_open   = 'X'.
    control-no_close  = 'X'.

 ELSE.
    call function 'SSF_FUNCTION_MODULE_NAME'
      exporting
*       FORMNAME           = 'ZCDN7'
        formname           = 'ZCDNPRINTGST11'
*       VARIANT            = ' '
*       DIRECT_CALL        = ' '
      importing
        fm_name            = v_fm
      exceptions
        no_form            = 1
        no_function_module = 2
        others             = 3.

    control-no_open   = 'X'.
    control-no_close  = 'X'.
  endif.

  call function 'SSF_OPEN'
    exporting
      control_parameters = control.

  loop at it_check into wa_check.
    clear : vbeln.
    vbeln = wa_check-vbeln.
    perform form1.

    perform accchk.

    if c1 eq 'E'.
      clear : tval,rtotval2,totval1,totval,rtotval.
*      BREAK-POINT .
      loop at it_tar1 into wa_tar1.
        tval = tval + wa_tar1-ztotval.
      endloop.
      rtotval2 = tval.
      totval =  tval.
      totval1 = rtotval2 .
      rtotval = rtotval2 .
*      READ TABLE IT_ZEXCHANGERATE INTO WA_ZEXCHANGERATE INDEX 1.
*      IF SY-SUBRC EQ 0.
*        TVAL = TVAL * WA_ZEXCHANGERATE-UKURS.
*        TOTVAL = TOTVAL * WA_ZEXCHANGERATE-UKURS.
*        RTOTVAL2 = TOTVAL.
*        RTOTVAL = RTOTVAL2.
*      ENDIF.
*      CLEAR : TOTVAL1.
*      TOTVAL1 =  RTOTVAL.
      call function 'HR_IN_CHG_INR_WRDS'
        exporting
          amt_in_num         = totval1
        importing
          amt_in_words       = words
        exceptions
          data_type_mismatch = 1
          others             = 2.
      if sy-subrc <> 0.
      endif.
*    CONCATENATE WORDS 'ONLY' INTO SPELL-WORD SEPARATED BY SPACE.
      concatenate words 'ONLY' into word1 separated by space.
    endif.


    call function v_fm
      exporting
        control_parameters = control
        user_settings      = 'X'
        output_options     = w_ssfcompop
        text2              = text2
        fkart              = fkart
        vbeln              = vbeln
        c1                 = c1
        cname1             = cname1
        cname2             = cname2
        cname3             = cname3
        cname4             = cname4
        city1              = city1
        cj_1icstno         = cj_1icstno
        cj_1ilstno         = cj_1ilstno
        gstin1             = gstin1
        name1              = name1
        name2              = name2
        name3              = name3
        name4              = name4
        ort01              = ort01
        gstin2             = gstin2
        vtext              = vtext
        fkdat1             = fkdat1
        naubel             = naubel
        cldt               = cldt
        bstnk              = bstnk
        bstdk1             = bstdk1
        submi              = submi
        mahdt              = mahdt
        text1              = text1
        invtyp1            = invtyp1
        total              = total
        bstkd              = bstkd
        bstdk              = bstdk
        bstkd_e            = bstkd_e
        bstdk_e            = bstdk_e
        w4                 = w4
        ttext              = ttext
        w41                = w41
        w42                = w42
        w40                = w40
        xlval              = xlval
        tval               = tval
        bcval              = bcval
        joigrt             = joigrt
        igst               = igst
        totval             = totval
        rtotval            = rtotval
        ltext              = ltext
        word1              = word1
        josgrt             = josgrt
        sgst               = sgst
        jocgrt             = jocgrt
        cgst               = cgst
        f                  = f
        jougrt             = jougrt
        ugst               = ugst
        txt1               = txt1
        lsval              = lsval
      tables
        it_tar1            = it_tar1
*       itab_division      = itab_division
*       itab_storage       = itab_storage
*       itab_pa0002        = itab_pa0002
      exceptions
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        others             = 5.

  endloop.
  call function 'SSF_CLOSE'.

*****************************************************


endform.                    "CR_PRINT




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
    when 'AUBEL'.
      set parameter id 'AUN' field selfield-value.
      call transaction 'VA03' and skip first screen.
    when 'BELNR'.
      set parameter id 'BLN' field selfield-value.
      call transaction 'FB03' and skip first screen.
    when others.
  endcase.
endform.                    "debit

*&---------------------------------------------------------------------*
*&      Form  AUTHORIZATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form authorization .

  select werks name1 from t001w into table itab_t001w where werks in
      p_plant.

  loop at itab_t001w into wa_t001w.
    authority-check object 'M_BCO_WERK'
           id 'WERKS' field wa_t001w-werks.
    if sy-subrc <> 0.
      concatenate 'No authorization for Plant' wa_t001w-werks into msg
      separated by space.
      message msg type 'E'.
    endif.
  endloop.


endform.                    "AUTHORIZATION
*&---------------------------------------------------------------------*
*&      Form  NEW1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form new1 .
  read table it_tab3 into wa_tab3 with key vbeln = wa_tab4-vbeln.
  if sy-subrc eq 0.

*on CHANGE OF wa_tab3-vbeln.
*    IF WA_TAB3-FKDAT GE '20180101'.



    clear : netwr, mwsbp, discount, total1,total2,total.
*    WRITE : / '**',WA_TAB2-VBELN,WA_TAB2-FKART.
*    if wa_tab2-fkart eq 'ZBD' OR WA_TAB2-FKART EQ 'ZG2'.

*    on change of wa_tab3-vbeln.

    if wa_tab3-fkart eq 'ZRS'.
      ttext = 'salable'.
    elseif wa_tab3-fkart eq 'ZRRS'.
      ttext = 'recalled'.
    elseif wa_tab3-fkart eq 'ZG3'.
      ttext = '  '.
    elseif wa_tab3-fkart eq 'ZC04'.
      ttext = '  '.
    elseif wa_tab3-fkart eq 'ZRE'.
      ttext = '  '.
    endif.


    if wa_tab3-fkart eq 'ZC08'OR  wa_tab3-fkart eq 'ZTDS'.
      read table it_dis1 into wa_dis1 with key vbeln = wa_tab3-vbeln.
      if sy-subrc eq 0.
*          total1 =  wa_dis1-zcusval.
        total1 =  wa_dis1-netwr.
      endif.
    elseif ( wa_tab3-fkart eq 'ZBD' ) or  ( wa_tab3-fkart eq 'ZG2' ).
      read table it_dis1 into wa_dis1 with key vbeln = wa_tab3-vbeln.
      if sy-subrc eq 0.
        total1 =  wa_dis1-netwr1 + wa_dis1-mwsbp.
      endif.
    else.
      if wa_tab3-kunag gt '0000040000' and wa_tab3-kunag le '0000049999'.  "CHANGE FRO EXPORT SAMPLE 24.2.21
        total1 =  wa_tab3-ptsval.
      else.
        read table it_dis1 into wa_dis1 with key vbeln = wa_tab3-vbeln.
        if sy-subrc eq 0.
          total1 =  wa_dis1-netwr +  wa_dis1-mwsbp +  wa_dis1-disc.
        endif.
      endif.
    endif.

    total2 = total1.
    total = total2.



*    IF WA_TAB3-FKART EQ 'ZBD'.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'H3'
*          WINDOW  = 'WINDOW5'.
*    ELSEIF WA_TAB3-FKART EQ 'ZQD'.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'TX6'
*          WINDOW  = 'WINDOW4'.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'HR3'
*          WINDOW  = 'WINDOW5'.
*    ELSEIF WA_TAB3-FKART EQ 'ZG2'.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'TX1'
*          WINDOW  = 'WINDOW4'.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'H3'
*          WINDOW  = 'WINDOW5'.
*    ELSEIF WA_TAB3-FKART EQ 'ZQC' .
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'TX5'
*          WINDOW  = 'WINDOW4'.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'H3'
*          WINDOW  = 'WINDOW5'.
*    ELSEIF WA_TAB3-FKART EQ 'ZFC'.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'TX7'
*          WINDOW  = 'WINDOW4'.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'HR3'
*          WINDOW  = 'WINDOW5'.
*
*    ELSEIF ( WA_TAB3-FKART EQ 'ZG3' ) OR ( WA_TAB3-FKART EQ 'ZC04' ) .
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'TX3'
*          WINDOW  = 'WINDOW4'.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'HR3'
*          WINDOW  = 'WINDOW5'.
*
*    ELSEIF WA_TAB3-FKART EQ 'ZC08'.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'TX4'
*          WINDOW  = 'WINDOW4'.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'HR3'
*          WINDOW  = 'WINDOW5'.
*
*    ELSEIF ( WA_TAB3-FKART EQ 'ZRS')  OR  ( WA_TAB3-FKART EQ 'ZRRS' ) .
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'TX2'
*          WINDOW  = 'WINDOW4'.
*
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'H3'
*          WINDOW  = 'WINDOW5'.
*    ELSE.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'TX2'
*          WINDOW  = 'WINDOW4'.
*      IF DR_BAT EQ 'X'.
*        CALL FUNCTION 'WRITE_FORM'
*          EXPORTING
*            ELEMENT = 'HRB3'
*            WINDOW  = 'WINDOW5'.
*      ELSE.
*
*        CALL FUNCTION 'WRITE_FORM'
*          EXPORTING
*            ELEMENT = 'HR3'
*            WINDOW  = 'WINDOW5'.
*      ENDIF.
*    ENDIF.
*    endon.
    clear : w4,w41,w42,wd1,wd2,wd3,wd4,ctotal,w40.

    write wa_tab3-cldt to wd1 dd/mm/yyyy.
    write wa_tab3-bstdk to wd2 dd/mm/yyyy.
    write wa_tab3-bstdk_e to wd3 dd/mm/yyyy.
    write wa_tab3-bstdk1 to wd4 dd/mm/yyyy.
    ctotal = total.
    condense ctotal.

*    IF EXP_CR EQ 'X'.
*      SELECT * FROM ZEXCHANGERATE INTO TABLE IT_ZEXCHANGERATE WHERE BUDAT LE BSTDK.
*      SORT IT_ZEXCHANGERATE DESCENDING BY BUDAT.
*      READ TABLE IT_ZEXCHANGERATE INTO WA_ZEXCHANGERATE INDEX 1.
*      IF SY-SUBRC EQ 0.
*        CTOTAL = CTOTAL * WA_ZEXCHANGERATE-UKURS.
*      ENDIF.
*    ENDIF.
*    BREAK-POINT .

    if wa_tab3-fkart eq 'ZG2'.
      w4 = '1'.
      concatenate 'REF :  Claim Date :' wd1 into w42 separated by space.
      concatenate 'We credit your account with' ctotal 'being the value of the following expired products returned by you vide  L.R./RPP/RR/AWB/STNo'
 	 wa_tab3-bstkd 'dated' wd2 '/Hand Delivery as per our QIN.No.' wa_tab3-bstkd_e 'to dated' wd3 into w41 separated by space.

    elseif ( wa_tab3-fkart eq 'ZRS')  or  ( wa_tab3-fkart eq 'ZRRS' ) .
      w4 = '2'.
*      CONCATENATE 'REF : ' wa_tab3-bstnk  wa_tab3-bstdk1 INTO w42 SEPARATED BY space.
      concatenate 'REF : ' wa_tab3-bstnk 'dated' wd4  into w42 separated by space.
      if exp_cr eq 'X'.
*        CONCATENATE 'We credit your account with' CTOTAL INTO W41 SEPARATED BY SPACE.
      else.
        concatenate 'We credit your account with' ctotal 'being the value of the following' ttext 'products returned by you vide  L.R./RPP/RR/AWB/STNo'
        wa_tab3-bstkd 'dated' wd2 '/Hand Delivery as per our GIN.No.' wa_tab3-bstkd_e 'to dated' wd3 into w41 separated by space.
      endif.
    elseif ( wa_tab3-fkart eq 'ZG3' ) or ( wa_tab3-fkart eq 'ZC04' ) .
      w4 = '3'.
*      CONCATENATE 'REF : ' wa_tab3-bstnk  wa_tab3-bstdk1 INTO w42 SEPARATED BY space.
      concatenate 'REF : ' wa_tab3-bstnk  'dated' wd4 into w42 separated by space.
      concatenate 'Inv. No.' wa_tab3-vbeln 'Dt.' wd1 'Claim Date:' wd4 'We credit your account with' ctotal into w41 separated by space.

    elseif wa_tab3-fkart eq 'ZC08'.
      w4 = '4'.
*      CONCATENATE 'REF : ' wa_tab3-bstnk  wa_tab3-bstdk1 INTO w42 SEPARATED BY space.
      concatenate 'REF : ' wa_tab3-bstnk 'Dated' wd4 into w42 separated by space.
      concatenate 'Inv. No.' wa_tab3-vbeln 'Dt.' wd1 'Claim Date:' wd4 'We credit your account with' ctotal 'towards Special Supply  Discount '
      into w41 separated by space.

    elseif wa_tab3-fkart eq 'ZQC' .
      if wa_tab5-kunag gt '0000040000' and wa_tab5-kunag le '0000049999'.
        w4 = '5'.
*      CONCATENATE 'REF : ' wa_tab3-bstnk  wa_tab3-bstdk1 INTO w42 SEPARATED BY space.
        concatenate 'REF : ' wa_tab3-bstnk  'dated' wd4 into w42 separated by space.
        concatenate 'We credit your account with' ctotal 'on account of return of goods against Invoice number' wa_tab3-bstnk 'Dated'
        wd4 into w41 separated by space.
      else.
        w4 = '5'.
*      CONCATENATE 'REF : ' wa_tab3-bstnk  wa_tab3-bstdk1 INTO w42 SEPARATED BY space.
        concatenate 'REF : ' wa_tab3-bstnk  'dated' wd4 into w42 separated by space.
        concatenate 'We credit your account with' ctotal into w41 separated by space.
      endif.
    elseif wa_tab3-fkart eq 'ZQD' or wa_tab3-fkart eq 'ZDRA'.
      w4 = '6'.
*      CONCATENATE 'REF : ' wa_tab3-bstnk  wa_tab3-bstdk1 INTO w42 SEPARATED BY space.
      concatenate 'REF : ' wa_tab3-bstnk 'Dated' wd4  into w42 separated by space.
      concatenate 'We debit your account with' ctotal into w41 separated by space.
    elseif wa_tab3-fkart eq 'ZQDO'.
      w4 = '6'.
*      CONCATENATE 'REF : ' wa_tab3-bstnk  wa_tab3-bstdk1 INTO w42 SEPARATED BY space.
      concatenate 'REF : ' wa_tab3-bstnk 'Dated' wd4 into w42 separated by space.
*      CONCATENATE 'We debit your account with' CTOTAL INTO W41 SEPARATED BY SPACE."20.12.20
      concatenate 'We debit your account with' ctotal ' being the value of the following products on account of RATE DIFFERENCE' into w41 separated by space.

*    elseif wa_tab3-fkart eq 'ZFC'.
    elseif wa_tab3-fkart eq 'ZFC' or wa_tab3-fkart eq 'ZSR'.
      w4 = '7'.
*      CONCATENATE 'REF : ' wa_tab3-bstnk  wa_tab3-bstdk1 INTO w42 SEPARATED BY space.
      concatenate 'REF : ' wa_tab3-bstnk  'Dated' wd4  into w42 separated by space.
      concatenate 'We credit your account with' ctotal into w41 separated by space.
*      'being the value of following product charged at wrong MRP Rs.34 insted of Rs. 24. i.e. Rs. 10 per unit.'
      select single * from vbak where vbeln eq wa_tab3-aubel.
      if sy-subrc eq 0.
        select single * from tvaut where spras eq 'EN' and augru eq vbak-augru.
        if sy-subrc eq 0.
          concatenate 'Reason:' tvaut-bezei into w40 separated by space.
        endif.
      endif.
      elseif wa_tab3-fkart eq 'ZTDS'.
      w4 = '8'.
*      CONCATENATE 'REF : ' wa_tab3-bstnk  wa_tab3-bstdk1 INTO w42 SEPARATED BY space.
      concatenate 'REF : ' wa_tab3-bstnk 'Dated' wd4 into w42 separated by space.
      concatenate 'Inv. No.' wa_tab3-vbeln 'Dt.' wd1 'Claim Date:' wd4 'We credit your account with' ctotal 'towards TDS Difference '
      into w41 separated by space.
    else.
      w4 = '2'.
*      CONCATENATE 'REF : ' wa_tab3-bstnk  wa_tab3-bstdk1 INTO w42 SEPARATED BY space.
      concatenate 'REF : ' wa_tab3-bstnk 'Dated' wd4 into w42 separated by space.
      concatenate 'We credit your account with' ctotal 'being the value of the following' ttext 'products returned by you vide  L.R./RPP/RR/AWB/STNo'
      wa_tab3-bstkd 'dated' wd2 '/Hand Delivery as per our GIN.No.' wa_tab3-bstkd_e 'to dated' wd3 into w41 separated by space.
    endif.



    cnt = 1.
    count1 = 1.
    clear : c1.
    clear : txt1.
    select * from zexchangerate into table it_zexchangerate where budat le bstdk.
    sort it_zexchangerate descending by budat.
    if it_vbrk is not initial.
      select * from PRCD_ELEMENTS into table it_konv2 for all entries in it_vbrk where kschl in ('ZCF','ZCIF') and knumv eq it_vbrk-knumv and kbetr gt 0.
    endif.


    loop at it_tab3 into wa_tab3 where vbeln = wa_tab4-vbeln.

      if wa_tab3-steuc eq space.
        select single * from marc where matnr eq  wa_tab3-matnr and werks eq wa_tab3-werks.
        if sy-subrc eq 0.
          wa_tab3-steuc = marc-steuc.
        endif.
      endif.

      wa_tar1-sr = count1.
      wa_tar1-steuc = wa_tab3-steuc.
*      SELECT SINGLE * FROM MAKT WHERE MATNR EQ '000000000000101153'.
*      IF SY-SUBRC EQ 0.
*        WA_TAR1-ARKTX = MAKT-MAKTX.
*      ENDIF.
      wa_tar1-arktx = wa_tab3-arktx.
      wa_tar1-bezei = wa_tab3-bezei.
      wa_tar1-z001 = wa_tab3-z001.
      wa_tar1-pts = wa_tab3-pts.
      select single * from zcdnfimm1 where belnr eq wa_tab3-vbeln.
      if sy-subrc eq 0.
        wa_tar1-qty = wa_tab3-qty1.
        wa_tar1-fkimg = wa_tab3-qty1.
        condense wa_tar1-qty.
      else.
        wa_tar1-qty = wa_tab3-qty.
        wa_tar1-fkimg = wa_tab3-fkimg.
      endif.
      wa_tar1-ptsval = wa_tab3-ptsval.
      wa_tar1-zfrg_rt = wa_tab3-zfrg_rt.
      wa_tar1-zfrg = wa_tab3-zfrg.

      if wa_tab3-fkart eq 'ZBD'.
        txt1 = 'ADJ. BKG.'.
      elseif wa_tab3-fkart eq 'ZG2'.
        txt1 = 'ADJ.EXPIRY'.
      else.
        txt1 = 'TAXABLE'.
      endif.


      if wa_tab3-fkart eq 'ZBD' or wa_tab3-fkart eq 'ZG2'.
        wa_tar1-taxablev = wa_tab3-netwr.
      else.
        wa_tar1-taxablev = wa_tab3-taxablev.
      endif.
      wa_tar1-expdt = wa_tab3-expdt.
      if exp_cr eq 'X'.
*        READ TABLE IT_ZEXCHANGERATE INTO WA_ZEXCHANGERATE INDEX 1.
*        IF SY-SUBRC EQ 0.
*          WA_TAR1-RATE = WA_TAB3-RATE * WA_ZEXCHANGERATE-UKURS.
*          WA_TAR1-ZTOTVAL = WA_TAR1-RATE * WA_TAB3-FKIMG.
*        ENDIF.
        clear : exrate.
        read table it_vbrk into wa_vbrk with key vbeln = wa_tab3-vbeln.
        if sy-subrc eq 0.
          loop at it_vbrp into wa_vbrp where vbeln = wa_tab3-vbeln and matnr = wa_tab3-matnr and fkimg gt 0..
*        READ TABLE it_vbrp1 INTO wa_vbrp1 with KEY vbeln = wa_tab3-vbeln matnr = wa_tab3-matnr.
*        if sy-subrc eq 0.
            read table it_konv2 into wa_konv2 with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr.
            if sy-subrc eq 0.
              exrate = wa_konv2-kbetr / wa_konv2-kpein.
            endif.
            exit.
          endloop.
*        endif.
          rate = exrate * wa_vbrk-kurrf.
*        READ TABLE IT_ZEXCHANGERATE INTO WA_ZEXCHANGERATE INDEX 1.
*        IF SY-SUBRC EQ 0.
*          RATE = EXRATE * WA_ZEXCHANGERATE-UKURS.
*        ENDIF.
          wa_tar1-rate = rate.
          wa_tar1-ztotval = rate * wa_tab3-fkimg.
        endif.

      else.
        wa_tar1-rate = wa_tab3-rate.
        wa_tar1-ztotval = wa_tab3-ztotval.
      endif.
      wa_tar1-charg = wa_tab3-charg.

      collect wa_tar1 into it_tar1.
      clear wa_tar1.
      count1 = count1 + 1.

      if wa_tab3-fkart eq 'ZBD' or wa_tab3-fkart eq 'ZG2' or wa_tab3-fkart eq 'ZRS' or wa_tab3-fkart eq 'ZRRS' or wa_tab3-fkart eq 'ZQC'.
*      IF WA_TAB3-FKART EQ 'ZRRS'.
        c1 = 'A'.

*        CALL FUNCTION 'WRITE_FORM'
*          EXPORTING
*            ELEMENT = 'T1'
*            WINDOW  = 'MAIN'.
*      tdis = tdis + wa_tab3-disc.
        text = 'ADDL.DISC'.

*      WRITE : / 'aaaa',wa_tab3-matnr,wa_tab3-arktx.
      else.
        if dr_bat eq 'X'.
          c1 = 'B'.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'TR2'
*              WINDOW  = 'MAIN'.
        elseif cr_bat eq 'X'.

        c1 = 'D'.


*        elseif FI_CR  eq 'X' OR FI_DR = 'X'.
*          C1 = 'F'.
        elseif exp_cr eq 'X'.
          c1 = 'E'.
       else.
          c1 = 'C'.
*          CALL FUNCTION 'WRITE_FORM'
*            EXPORTING
*              ELEMENT = 'TR1'
*              WINDOW  = 'MAIN'.
        endif.
*      tdis = tdis + wa_tab3-mwsbp.
        text = 'TAX'.
      endif.

*      if exp_cr eq 'X'.
*        c1 = 'E'.
*      endif.
*   ENDLOOP.
*    TDIS = TDIS + WA_TAB3-DISC.
      if wa_tab3-fkart  eq 'ZC08' OR wa_tab3-fkart  eq 'ZTDS'.
        tval = tval + wa_tab3-ztotval.
*      tval = tval + wa_tab3-TAXABLEV.
        if wa_tab3-spart eq '60'.
*        xlval = xlval + wa_tab3-zcusval.
          xlval = xlval + wa_tab3-ztotval.
        elseif wa_tab3-spart eq '50'.
*        bcval = bcval + wa_tab3-zcusval.
          bcval = bcval + wa_tab3-ztotval.
        elseif wa_tab3-spart eq '70'.
          lsval = lsval + wa_tab3-ztotval.
        endif.
      elseif wa_tab3-fkart  eq 'ZCIF'.
        tval = tval + wa_tab3-ztotval.
*      tval = tval + wa_tab3-TAXABLEV.
        if wa_tab3-spart eq '60'.
*        xlval = xlval + wa_tab3-zcusval.
          xlval = xlval + wa_tab3-ztotval.
        elseif wa_tab3-spart eq '50'.
*        bcval = bcval + wa_tab3-zcusval.
          bcval = bcval + wa_tab3-ztotval.
        elseif wa_tab3-spart eq '70'.
          lsval = lsval + wa_tab3-ztotval.
        endif.
      elseif ( wa_tab3-fkart  eq 'ZBD' ) or ( wa_tab3-fkart eq 'ZG2' ) .
*      tval = tval + wa_tab3-netwr.
*      tval = tval + wa_tab3-TAXABLEV.
        tval = tval + wa_tab3-netwr.
        if wa_tab3-spart eq '60'.
          xlval = xlval + wa_tab3-netwr.
        elseif wa_tab3-spart eq '50'.
          bcval = bcval + wa_tab3-netwr.
        elseif wa_tab3-spart eq '70'.
          lsval = lsval + wa_tab3-netwr.
        endif.
      else.
        if wa_tab3-kunag gt '0000040000' and  wa_tab3-kunag le '0000049999'.
          tval = tval + wa_tab3-ptsval.
          if wa_tab3-spart eq '60'.
            xlval = xlval + wa_tab3-ztotval.
          elseif wa_tab3-spart eq '50'.
            bcval = bcval + wa_tab3-ztotval.
          elseif wa_tab3-spart eq '70'.
            lsval = lsval + wa_tab3-ztotval.
          endif.
        else.
*      tval = tval + wa_tab3-ztotval.
*      tval = tval + wa_tab3-TAXABLEV.
          tval = tval + wa_tab3-netwr.
          if wa_tab3-spart eq '60'.
            xlval = xlval + wa_tab3-ztotval.
          elseif wa_tab3-spart eq '50'.
            bcval = bcval + wa_tab3-ztotval.
          elseif wa_tab3-spart eq '70'.
            lsval = lsval + wa_tab3-ztotval.
          endif.
        endif.
      endif.
      tval1 = tval.
      tdis = tdis + wa_tab3-disc.
      zspdval = zspdval + wa_tab3-zspdval.
      ttax = ttax + wa_tab3-mwsbp.
      igst = igst + wa_tab3-joig.
      sgst = sgst + wa_tab3-josg.
      cgst = cgst + wa_tab3-jocg.
      ugst = ugst + wa_tab3-joug.

      zcusval = zcusval + wa_tab3-zcusval.

*    at end of vbeln.
      clear : fkart, zcusrate.
*      totval = tval + zspdval + ttax.
      totval = tval + ttax.
      rtotval1 = totval.
      rtotval = rtotval1.
      read table it_vbrk into wa_vbrk with key vbeln = wa_tab3-vbeln.
      if sy-subrc eq 0.
        fkart = wa_vbrk-fkart.
*        read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kschl = 'ZCUS'.
        clear : zcusrate,zcusrate1.
        select single * from PRCD_ELEMENTS where knumv = wa_vbrk-knumv and kschl = 'ZCUS' and kbetr ne 0.
        if sy-subrc eq 0.
          zcusrate = PRCD_ELEMENTS-kbetr .  "/ 10
          zcusrate1 = zcusrate.
        endif.
      endif.
      clear : ltext.
      if fkart eq 'ZC08'.
        rzcusval = zcusval.
*        rtotval = rzcusval.
        rtotval = totval.
        zcusval1 = rtotval.
        concatenate 'S.S.D., @' zcusrate1 '%  :' zcusval1 into ltext.
*        LTEXT = 'M.E.R.'.
      elseif ( fkart eq 'ZRRE' ) or ( fkart eq 'RE' ) or ( fkart eq 'ZG2' ) or ( fkart eq 'ZBD' ) or ( fkart eq 'ZD08' ).
*        ltext = 'NOTE:Rate is PTS after adjustment of bonus offer.'.
      endif.


      totval1 = rtotval.
      cnt = cnt + 1.
    endloop.
    call function 'HR_IN_CHG_INR_WRDS'
      exporting
        amt_in_num         = totval1
      importing
        amt_in_words       = words
      exceptions
        data_type_mismatch = 1
        others             = 2.
    if sy-subrc <> 0.
    endif.
*    CONCATENATE WORDS 'ONLY' INTO SPELL-WORD SEPARATED BY SPACE.
    concatenate words 'ONLY' into word1 separated by space.
    clear : f.

    if igst gt 0.
      f = '1'.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'F1'
*          WINDOW  = 'WINDOW6'.
    elseif sgst gt 0.
      f = '2'.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'F2'
*          WINDOW  = 'WINDOW6'.

    elseif ugst gt 0.
      f = '3'.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'F3'
*          WINDOW  = 'WINDOW6'.

    else .
      f = '4'.
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'F4'
*          WINDOW  = 'WINDOW6'.
    endif.

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

*    TDIS = 0.
*    TVAL = 0.
*    TVAL1 = 0.
*    TTAX = 0.
*    SGST = 0.
*    CGST = 0.
*    IGST = 0.
*    UGST = 0.
*    XLVAL = 0.
*    BCVAL = 0.
*    TOTVAL  = 0.
*    TOTVAL1 = 0.
*    ZSPDVAL = 0.
*    ZCUSVAL = 0.

  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  FORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form form1 .
  clear :
       fkart ,  vbeln, c1 , cname1 , cname2  , cname3, cname4 , city1  , cj_1icstno, cj_1ilstno, gstin1 , name1, name2, name3 , name4, ort01 ,
        gstin2 , vtext  , fkdat1, naubel , cldt , bstnk  ,  bstdk1 , submi, mahdt,  invtyp1, total , bstkd , bstdk, bstkd_e  , bstdk_e ,
        w4 , ttext,  w41 , w42, xlval,tval  , bcval , lsval,joigrt  , igst, totval , rtotval, ltext  ,  word1  ,josgrt, sgst,  jocgrt,cgst, f ,
        jougrt,  ugst ,txt1,w40.



  tdis = 0.
  tval = 0.
  tval1 = 0.
  ttax = 0.
  sgst = 0.
  cgst = 0.
  igst = 0.
  ugst = 0.
  xlval = 0.
  bcval = 0.
  lsval = 0.
  totval  = 0.
  totval1 = 0.
  zspdval = 0.
  zcusval = 0.
  cnt = 0.

  clear : fkart,vbeln.
  clear : it_tar1,wa_tar1,it_tab1,wa_tab1,it_tab2,wa_tab2,it_tab3,wa_tab3,it_tab4,wa_tab4,it_ext1,wa_ext1,it_ext2,wa_ext2,it_vbap,wa_vbap,it_dis1,wa_dis1,
  it_tap1,wa_tap1,it_tapd1,wa_tapd1.

  clear : cname1,city1.


  loop at it_vbrp into wa_vbrp where vbeln eq wa_check-vbeln.
    read table it_vbrk into wa_vbrk with key vbeln = wa_vbrp-vbeln.
    if sy-subrc eq 0.
      if wa_vbrk-fkart eq 'ZG2' or wa_vbrk-fkart eq 'ZBD' or wa_vbrk-fkart eq 'ZC08' OR wa_vbrk-fkart eq 'ZTDS'.

*        text2 = 'CREDIT MENO'.
      else.

        select single irn from j_1ig_invrefnum into irn where bukrs eq '1000' and docno eq wa_check-vbeln and irn ne space.
        if sy-subrc eq 0.
        else.
          text2 = 'PACKING LIST'.
        endif.
      endif.

      wa_tab1-werks = wa_vbrp-werks.
      wa_tab1-matnr = wa_vbrp-matnr.
      select single * from marc where matnr eq wa_vbrp-matnr and werks eq wa_vbrp-werks.
      if sy-subrc eq 0.
        wa_tab1-steuc = marc-steuc.
      endif.
      wa_tab1-posnr = wa_vbrp-posnr.
      select single * from makt where matnr eq wa_vbrp-matnr and spras eq 'EN'.
      if sy-subrc eq 0.
        wa_tab1-arktx = makt-maktx.
      endif.
      wa_tab1-charg = wa_vbrp-charg.
      if wa_vbrp-lgort ne '   '.
        wa_tab1-lgort = wa_vbrp-lgort.
      else.
        read table it_marc into wa_marc with key matnr = wa_vbrp-matnr werks = wa_vbrp-werks.
        if sy-subrc eq 0.
          wa_tab1-lgort = wa_marc-lgpro.
        endif.
      endif.
*       WRITE : / WA_VBRP-VBELN.
      select single * from PRCD_ELEMENTS where knumv = wa_vbrk-knumv and kschl = 'JOIG'.
      if sy-subrc eq 0.
        ttext1 = 'IGST'.
      else.
        select single * from PRCD_ELEMENTS where knumv = wa_vbrk-knumv and kschl = 'JOUG'.
        if sy-subrc eq 0.
          ttext1 = 'UTGST/CGST'.
        else.
          select single * from PRCD_ELEMENTS where knumv = wa_vbrk-knumv and kschl = 'JOCG'.
          if sy-subrc eq 0.
            ttext1 = 'SGST/CGST'.
          endif.
        endif.
      endif.

      read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'Z001'.
      if sy-subrc eq 0.
        wa_tab1-z001 = wa_konv-kwert / wa_vbrp-fkimg .
        wa_tab1-z001val = wa_konv-kwert .

      endif.

      read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZCIF'.
      if sy-subrc eq 0.
        wa_tab1-z001 = wa_konv-kbetr .
*        / WA_VBRP-FKIMG .
        wa_tab1-z001val = wa_konv-kbetr * wa_vbrp-fkimg.
      endif.

      read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZC09'.
      if sy-subrc eq 0.
        wa_tab1-zc09 = wa_konv-kwert / wa_vbrp-fkimg .
        wa_tab1-zc09val = wa_konv-kwert .
      endif.
      read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZCUS'.
      if sy-subrc eq 0.
        wa_tab1-zcus = wa_konv-kwert / wa_vbrp-fkimg .
        wa_tab1-zcusval = wa_konv-kwert.
      endif.
      read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'Z099'.
      if sy-subrc eq 0.
        wa_tab1-z099 = wa_konv-kwert / wa_vbrp-fkimg .
        wa_tab1-z099val = wa_konv-kwert.
      endif.
      read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZTOT'.
      if sy-subrc eq 0.
        wa_tab1-ztot = wa_konv-kawrt / wa_vbrp-fkimg .
        wa_tab1-ztotval = wa_konv-kawrt.
      endif.
      read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZPST'.
      if sy-subrc eq 0.
        wa_tab1-zpst = wa_konv-kwert / wa_vbrp-fkimg .
        wa_tab1-zpstval = wa_konv-kwert.
      endif.
      read table it_konv1 into wa_konv1 with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZSPD'.
      if sy-subrc eq 0.
        wa_tab1-zspd = wa_konv1-kwert / wa_vbrp-fkimg .
        wa_tab1-zspdval = wa_konv1-kwert.
      endif.
      read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'JIN8' kappl = 'TX'.
      if sy-subrc eq 0.
        wa_tab1-disc = wa_konv-kwert.
      endif.
      if sto_cr eq 'X'.
        read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZRM'.
        if sy-subrc eq 0.
          wa_tab1-zgrp = wa_konv-kwert.
        endif.
      else.
        read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZGRP'.
        if sy-subrc eq 0.
          wa_tab1-zgrp = wa_konv-kwert.
        endif.
      endif.
      read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZFRG'.
      if sy-subrc eq 0 and wa_konv-kawrt gt 0.
        wa_tab1-zfrg = wa_konv-kwert * ( - 1 ).
        wa_tab1-pts = wa_konv-kawrt.
        wa_tab1-ptsval = wa_konv-kawrt.
        wa_tab1-zfrg_rt = wa_konv-kbetr * ( - 1 ).
      else.
        read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZGRP'.
        if sy-subrc eq 0.
          wa_tab1-zfrg = 0.
          wa_tab1-pts = wa_konv-kawrt.
          wa_tab1-ptsval = wa_konv-kawrt.
          wa_tab1-zfrg_rt = 0.
        else.
          read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZCIF'.
          if sy-subrc eq 0.
            wa_tab1-zfrg = 0.
            wa_tab1-pts = wa_konv-kbetr.
            wa_tab1-ptsval =  wa_konv-kbetr * wa_vbrp-fkimg.
            wa_tab1-zfrg_rt = 0.
          endif.

        endif.
      endif.

      read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'JOIG'.
      if sy-subrc eq 0.
        wa_tab1-joig = wa_konv-kwert.
        wa_tab1-taxablev = wa_konv-kawrt.
      endif.
      read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'JOSG'.
      if sy-subrc eq 0.
        wa_tab1-josg = wa_konv-kwert.
        wa_tab1-taxablev = wa_konv-kawrt.
      endif.
      read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'JOCG'.
      if sy-subrc eq 0.
        wa_tab1-jocg = wa_konv-kwert.
      endif.
      read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'JOUG'.
      if sy-subrc eq 0.
        wa_tab1-joug = wa_konv-kwert.
        wa_tab1-taxablev = wa_konv-kawrt.
      endif.

      read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZCIF'.
      if sy-subrc eq 0.
*        WA_TAB1-JOUG = WA_KONV-KWERT.
        wa_tab1-taxablev = wa_konv-kbetr * wa_vbrp-fkimg.
      endif.


      read table it_konv into wa_konv with  key  knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'JOSG' .
      if sy-subrc eq 0.
        josgrt = wa_konv-kbetr." / 10. "COMMENTED BY PS
      endif.
      read table it_konv into wa_konv with  key  knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'JOCG' .
      if sy-subrc eq 0.
        jocgrt = wa_konv-kbetr . "/ 10. "COMMENTED BY PS
      endif.
      read table it_konv into wa_konv with  key  knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'JOIG' .
      if sy-subrc eq 0.
        joigrt = wa_konv-kbetr ."/ 10. COMMENTED PS
*        joigrt = joigrt1.
*        CONDENSE joigrt.
      endif.
      read table it_konv into wa_konv with  key  knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'JOUG' .
      if sy-subrc eq 0.
        jougrt = wa_konv-kbetr . "/ 10. COMMENTED PS
      endif.

      wa_tab1-aubel = wa_vbrp-aubel.
*      wa_tab1-posnr = wa_vbrp-posnr.
      wa_tab1-vbeln = wa_vbrk-vbeln.
      wa_tab1-fkart = wa_vbrk-fkart.
      wa_tab1-fkdat = wa_vbrk-fkdat.
      wa_tab1-qty = wa_vbrp-fkimg.

*      if wa_vbrp-pstyv eq 'REN'.
*        wa_tab1-fkimg_c = wa_vbrp-fkimg.
*      elseif wa_vbrp-pstyv eq 'G2N'.
*        wa_tab1-fkimg_c = wa_vbrp-fkimg.
*      else.
*        wa_tab1-fkimg_f = wa_vbrp-fkimg.
*      endif.

      if wa_vbrp-netwr gt 0.
        wa_tab1-fkimg_c = wa_vbrp-fkimg.
      else.
        wa_tab1-fkimg_f = wa_vbrp-fkimg.
      endif.

*      if wa_vbrp-netwr eq 0.
*        wa_tab1-fkimg_f = wa_vbrp-fkimg.
*      else.
*        wa_tab1-fkimg_c = wa_vbrp-fkimg.
*      endif.

*      wa_tab1-netwr = wa_vbrk-netwr.
      wa_tab1-mwsbp = wa_vbrp-mwsbp.
      wa_tab1-netwr = wa_vbrp-netwr.
*      WRITE : / WA_TAB1-NETWR,wa_vbrp-netwr.

      wa_tab1-kunag = wa_vbrk-kunag.

      collect wa_tab1 into it_tab1.
      clear wa_tab1.
    endif.
  endloop.
*  WRITE : /'DATE', JOSGRT.

  if it_tab1 is not initial.
    loop at it_tab1 into wa_tab1 where vbeln eq wa_check-vbeln and fkart eq 'ZG2'.
      wa_ext1-vbeln = wa_tab1-vbeln.
      wa_ext1-aubel = wa_tab1-aubel.
*      wa_ext1-posnr = wa_tab1-posnr.

      collect wa_ext1 into it_ext1.
      clear wa_ext1.
    endloop.
  endif.

  sort it_ext1 by vbeln aubel.
  delete adjacent duplicates from it_ext1 comparing vbeln aubel posnr.
*  LOOP AT IT_EXT1 INTO WA_EXT1.
*    WRITE : / 'A',WA_EXT1-VBELN,WA_EXT1-AUBEL,wa_ext1-knumv,wa_ext1-posnr.
*  ENDLOOP.

  if it_ext1 is not initial.
    select * from vbap into table it_vbap for all entries in it_ext1 where vbeln eq it_ext1-aubel.
  endif.

  loop at it_vbap into wa_vbap.
    clear : mrp,pts.
    read table it_tab1 into wa_tab1 with key matnr = wa_vbap-matnr charg = wa_vbap-charg.
    if sy-subrc eq 4.
      select single * from vbak where vbeln eq wa_vbap-vbeln.
      if sy-subrc eq 0.
        wa_ext2-knumv = vbak-knumv.
      endif.
      read table it_ext1 into wa_ext1 with key aubel = wa_vbap-vbeln.
      if sy-subrc eq 0.
        wa_ext2-vbeln = wa_ext1-vbeln.
      endif.
      wa_ext2-werks = wa_vbap-werks.
      wa_ext2-aubel = wa_vbap-vbeln.

      wa_ext2-matnr = wa_vbap-matnr.
      wa_ext2-charg = wa_vbap-charg.
      wa_ext2-zmeng = wa_vbap-zmeng.
      wa_ext2-posnr = wa_vbap-posnr.
      select single * from PRCD_ELEMENTS where knumv eq wa_ext2-knumv and kposn eq wa_vbap-posnr and kschl eq 'ZPST'.
      if sy-subrc eq 0.
        pts = PRCD_ELEMENTS-kawrt / wa_vbap-zmeng.
      endif.
      wa_ext2-pts = pts.
      select single * from a602 where kappl eq 'V' and kschl = 'Z001' and vkorg eq '1000' and matnr eq wa_vbap-matnr and charg eq wa_vbap-charg
       and datbi ge sy-datum.
      if sy-subrc eq 0.
        select single * from konp where knumh = a602-knumh and kschl eq 'Z001' and loevm_ko ne 'X'..
        if sy-subrc eq 0.
          wa_ext2-mrp = konp-kbetr.
        endif.
      endif.
      collect wa_ext2 into it_ext2.
      clear wa_ext2.
    endif.
  endloop.

*  LOOP at it_ext2 INTO wa_ext2.
*    WRITE : / 'ss', WA_EXT2-VBELN,WA_EXT2-AUBEL,wa_ext2-knumv,wa_ext2-posnr,wa_ext2-matnr,wa_ext2-charg,wa_ext2-zmeng,wa_ext2-mrp,wa_ext2-PTS.
*  endloop.

  loop at it_tab1 into wa_tab1 where vbeln = wa_check-vbeln.
*    where fkimg_c gt 0.
    clear : rate,scheme1,scheme2,val1,val2.
*    WRITE : / '***',WA_TAB1-VBELN,WA_TAB1-ARKTX,WA_TAB1-Z001.
    wa_tab2-vbeln = wa_tab1-vbeln.
    wa_tab2-werks = wa_tab1-werks.
    wa_tab2-matnr = wa_tab1-matnr.
    wa_tab2-charg = wa_tab1-charg.
    wa_tab2-steuc = wa_tab1-steuc.
    wa_tab2-ttext = wa_tab1-ttext.
    wa_tab2-joig = wa_tab1-joig.
    wa_tab2-josg = wa_tab1-josg.
    wa_tab2-jocg = wa_tab1-jocg.
    wa_tab2-joug = wa_tab1-joug.
    wa_tab2-zfrg = wa_tab1-zfrg.
    wa_tab2-ptsval = wa_tab1-ptsval.
    clear : zfrg_rt.
    zfrg_rt = wa_tab1-zfrg_rt .   "/ 10
    wa_tab2-zfrg_rt = zfrg_rt.
    clear : pts1.
    pts1 = wa_tab1-pts / wa_tab1-qty.
    wa_tab2-pts = pts1.
    wa_tab2-taxablev = wa_tab1-taxablev.

    wa_tab2-typ = 'A'.
*    WA_TAB2-SPART = WA_TAB1-SPART.
*    wa_tab2-posnr = wa_tab1-posnr.
    wa_tab2-arktx = wa_tab1-arktx.
*    IF WA_TAB1-PSTYV NE 'RENN' ) OR ( WA_TAB1-PSTYV NE 'RENN' )
    if wa_tab1-netwr gt 0.

      if wa_tab1-z001 gt 0.
        wa_tab2-z001 = wa_tab1-z001.
      elseif wa_tab1-zc09 gt 0.
        wa_tab2-z001 = wa_tab1-zc09.
      else.
        wa_tab2-z001 = wa_tab1-z099.
      endif.
      if wa_tab1-netwr ne 0.
        if wa_tab1-ztot gt 0.
          wa_tab2-ztot = wa_tab1-ztot .
        elseif wa_tab1-zpst gt 0..
          wa_tab2-ztot = wa_tab1-zpst .
        elseif wa_tab1-zspd gt 0.
          wa_tab2-ztot = wa_tab1-zspd.
        elseif wa_tab1-zc09 gt 0.
          wa_tab2-ztot = wa_tab1-zc09.
        elseif wa_tab1-z099 gt 0.
          wa_tab2-ztot = wa_tab1-z099.
        endif.
        if wa_tab1-fkart eq 'ZQC'.
          if wa_tab1-zpst ne 0.
            wa_tab2-ztotval = wa_tab1-zpstval.
            wa_dis1-netwr = wa_tab1-zpstval.
          else.
            wa_tab2-ztotval = wa_tab1-netwr.
            wa_dis1-netwr = wa_tab1-netwr.
          endif.
          wa_tab2-zspdval = 0.
          wa_dis1-disc = 0.
        else.
*        BREAK-POINT.
          if wa_tab1-ztot gt 0.
            wa_tab2-ztotval = wa_tab1-ztotval.
            wa_dis1-netwr = wa_tab1-ztotval.
          elseif wa_tab1-zpst ne 0.
            wa_tab2-ztotval = wa_tab1-zpstval.
            wa_dis1-netwr = wa_tab1-zpstval.
          elseif wa_tab1-zc09 ne 0.
            wa_tab2-ztotval = wa_tab1-zc09val.
            wa_dis1-netwr = wa_tab1-zc09val.
          elseif wa_tab1-z099 ne 0.
            wa_tab2-ztotval = wa_tab1-z099val.
            wa_dis1-netwr = wa_tab1-z099val.
          endif.
          if wa_tab1-zspd ne 0.
            wa_tab2-zspdval = wa_tab1-zspdval.
          endif.
          wa_dis1-disc = wa_tab1-zspdval.
        endif.
      endif.
    endif.
    rate = wa_tab1-netwr / wa_tab1-qty.
    wa_tab2-zcusval = wa_tab1-zcusval.
    wa_tab2-disc = wa_tab1-disc.
    wa_tab2-mwsbp = wa_tab1-mwsbp.
    wa_tab2-total = wa_tab1-netwr + wa_tab1-mwsbp.


    if wa_dis1-netwr eq 0.
      wa_dis1-netwr = wa_tab1-netwr.
    endif.
*    rate = wa_tab1-netwr / wa_tab1-qty.
    wa_tab2-rate = rate.
*    wa_tab2-zcusval = wa_tab1-zcusval.

*    wa_tab2-disc = wa_tab1-disc.

    wa_tab2-qty1 = wa_tab1-qty.
    wa_tab2-qty = wa_tab1-qty.
    wa_tab2-fkimg_c = wa_tab1-fkimg_c.
    wa_tab2-fkimg_f = wa_tab1-fkimg_f.
    wa_tab2-fkimg = wa_tab1-fkimg_c + wa_tab1-fkimg_f.

    wa_tab2-aubel = wa_tab1-aubel.
*    wa_tab2-vbeln = wa_tab1-vbeln.
    wa_tab2-fkart = wa_tab1-fkart.
    wa_tab2-fkdat = wa_tab1-fkdat.
    wa_tab2-netwr = wa_tab1-netwr.

*    wa_tab2-mwsbp = wa_tab1-mwsbp.
    wa_tab2-kunag = wa_tab1-kunag.
*    wa_tab2-total = wa_tab1-netwr + wa_tab1-mwsbp.

*  *    write : / wa_tab1-werks,wa_tab1-fkdat,wa_tab1-vbeln,wa_tab1-fkart,wa_tab1-kunag,wa_tab1-netwr,wa_tab1-mwsbk.

*    select single * from kna1 where kunnr = wa_tab1-kunag.
*    if sy-subrc eq 0.
**        write : kna1-name1,kna1-ort01.
*      select single * from adrc where addrnumber eq kna1-adrnr.
*      if sy-subrc eq 0.
*        wa_tab2-name1 = adrc-name1.
*        "wa_tab2-name2 = adrc-name2.
*         wa_tab2-name2 = adrc-street.
*        wa_tab2-name3 = adrc-str_suppl1.
*        wa_tab2-name4 = adrc-str_suppl2.
*        wa_tab2-ort01 = adrc-city1.
*      endif.
*      wa_tab2-gstin2 = kna1-stcd3.
*    endif.
 SELECT SINGLE * FROM KNA1 WHERE KUNNR = WA_TAB1-KUNAG.
    IF SY-SUBRC EQ 0.
*        write : kna1-name1,kna1-ort01.
      WA_TAB2-NAME1 = KNA1-NAME1.
      WA_TAB2-NAME2 = KNA1-STRAS.
*      WA_TAB2-NAME3 = KNA1-NAME3.
*      WA_TAB2-NAME4 = KNA1-NAME4.
      WA_TAB2-ORT01 = KNA1-ORT01.
      WA_TAB2-GSTIN2 = KNA1-STCD3.

      Select * from adrc where ADDRNUMBER = KNA1-ADRNR.
      ENDSELECT.
       IF sy-subrc = 0.
       WA_TAB2-NAME3 = adrc-STR_SUPPL1.
       WA_TAB2-NAME4 = adrc-STR_SUPPL2.
       endif.
    ENDIF.
    select single * from bkpf where xblnr = wa_tab1-vbeln.
    if sy-subrc eq 0.
      wa_tab2-belnr = bkpf-belnr.
    endif.
    select single * from vbkd where vbeln eq wa_tab1-aubel.
    if sy-subrc eq 0.
      wa_tab2-cldt = vbkd-fkdat.
      wa_tab2-bstkd = vbkd-bstkd.
      wa_tab2-bstdk = vbkd-bstdk.
      wa_tab2-bstkd_e = vbkd-bstkd_e.
      wa_tab2-bstdk_e = vbkd-bstdk_e.
    endif.
    select single * from t001w where werks eq wa_tab1-werks.
    if sy-subrc eq 0.
      select single * from kna1 where kunnr eq t001w-kunnr.
      if sy-subrc eq 0.
        wa_tab2-gstin1 = kna1-stcd3.
      endif.
      select single * from j_1imocust where kunnr eq t001w-kunnr.
      if sy-subrc eq 0.
        wa_tab2-cj_1icstno = j_1imocust-j_1icstno.
        wa_tab2-cj_1ilstno = j_1imocust-j_1ilstno.
      endif.
      select single * from adrc where addrnumber eq t001w-adrnr.
      if sy-subrc eq 0.
        wa_tab2-cname1 = adrc-name1.
        "wa_tab2-cname2 = adrc-name2.
        wa_tab2-cname2 = adrc-Street.
        wa_tab2-cname3 = adrc-str_suppl1.
        wa_tab2-cname4 = adrc-str_suppl2.
        wa_tab2-city1 = adrc-city1.
      endif.
    endif.

    select single * from j_1imocust where kunnr eq wa_tab1-kunag.
    if sy-subrc eq 0.
      wa_tab2-j_1icstno = j_1imocust-j_1icstno.
      wa_tab2-j_1ilstno = j_1imocust-j_1ilstno.
    endif.
    select single * from mvke where matnr eq wa_tab1-matnr and vkorg eq '1000' and vtweg eq '10'.
    if sy-subrc eq 0.
      select single * from tvm5t where spras eq 'EN' and mvgr5 eq mvke-mvgr5.
      if sy-subrc eq 0.
        wa_tab2-bezei = tvm5t-bezei.
      endif.
    endif.
    select single * from mara where matnr eq wa_tab1-matnr.
    if sy-subrc eq 0.
*      if mara-spart eq '50'.
      wa_tab2-spart = mara-spart.
    endif.
*        wa_tab2-bcnetwr = ( wa_tab2-ZTOTVAL - WA_TAB2-DISC ).
*      elseif mara-spart eq '60'.
*        wa_tab2-xlnetwr = ( wa_tab2-ZTOTVAL - WA_TAB2-DISC ).
*      endif.
*    endif.
    select single * from vbak where vbeln eq wa_tab1-aubel.
    if sy-subrc eq 0.
      wa_tab2-bstnk = vbak-bstnk.
      wa_tab2-bstdk1 = vbak-bstdk.
      wa_tab2-submi = vbak-submi.
      wa_tab2-mahdt = vbak-mahdt.
    endif.
**************** BONUS SCHEME ***********************************
    select single * from kotn532 where kappl eq 'V' and kschl eq 'NA00' and vkorg eq '1000' and vtweg eq '10' and matnr eq wa_tab1-matnr and datab
       le wa_tab1-fkdat and datbi ge wa_tab1-fkdat.
    if sy-subrc eq 0.
      select single * from kondn where knumh eq kotn532-knumh.
      if sy-subrc eq 0.
        case kondn-knrdd.
          when 1.
            scheme1 = kondn-knrnm - kondn-knrzm.
            scheme2 = floor( kondn-knrzm ).
          when 2.
            scheme1 = floor( kondn-knrnm ).
            scheme2 = floor( kondn-knrzm ).
        endcase.
        condense scheme1.
        condense scheme2.
        concatenate scheme1 '+' scheme2 into wa_tab2-rej.
      endif.
    endif.
*    select single * from ibatch where MATERIAL eq wa_tab1-matnr and PLANT eq wa_tab1-werks and BATCH eq wa_tab1-charg.
    select single * from ibatch where MATERIAL eq wa_tab1-matnr and  BATCH eq wa_tab1-charg." addede logic by ps
    if sy-subrc eq 0.
      concatenate ibatch-SHELFLIFEEXPIRATIONDATE+4(2) '/'  ibatch-SHELFLIFEEXPIRATIONDATE+2(2) into wa_tab2-expdt.
    endif.
    select single * from tvfkt where spras eq 'EN' and fkart eq wa_tab1-fkart.
    if sy-subrc eq 0.
      if wa_tab1-fkart eq 'ZC08' OR wa_tab1-fkart eq 'ZTDS'.
        wa_tab2-vtext = 'Special Supply Discount'.
      else.
        wa_tab2-vtext = tvfkt-vtext.
      endif.
    endif.

***************************************************
    collect wa_tab2 into it_tab2.
    clear wa_tab2.
    wa_dis1-fkart = wa_tab1-fkart.
    wa_dis1-vbeln = wa_tab1-vbeln.
    wa_dis1-netwr1 = wa_tab1-netwr.
    wa_dis1-mwsbp = wa_tab1-mwsbp.
*    WA_DIS1-DISC = WA_TAB1-ZSPDVAL.
    wa_dis1-zcusval = wa_tab1-zcusval.
    collect wa_dis1 into it_dis1.
    clear wa_dis1.
  endloop.


  sort it_dis1 by vbeln.
  delete adjacent duplicates from it_dis1 comparing vbeln.

  sort it_tab1 descending by fkimg_f.
*  BREAK-POINT.
  loop at it_tab2 into wa_tab2 where vbeln eq wa_check-vbeln.
    clear : tax.
*    move-corresponding  wa_tab2 to wa_tab3.

    wa_tab3-werks  = wa_tab2-werks.
    wa_tab3-steuc = wa_tab2-steuc.
    wa_tab3-ttext = wa_tab2-ttext.
    wa_tab3-kunnr = wa_tab2-kunnr.
    wa_tab3-gstin1 = wa_tab2-gstin1.
    wa_tab3-gstin2 = wa_tab2-gstin2.

    if wa_tab3-gstin2 ne space.
      invtyp1 = 'B2B'.
    else.
      invtyp1 = 'B2C'.
    endif.

    wa_tab3-joig = wa_tab2-joig.
    wa_tab3-josg = wa_tab2-josg.
    wa_tab3-jocg = wa_tab2-jocg.
    wa_tab3-joug = wa_tab2-joug.

    wa_tab3-zfrg = wa_tab2-zfrg.
    wa_tab3-zfrg_rt = wa_tab2-zfrg_rt.
    wa_tab3-pts = wa_tab2-pts.
    wa_tab3-ptsval = wa_tab2-ptsval.
    wa_tab3-taxval = wa_tab2-ptsval - wa_tab2-zfrg.
    wa_tab3-taxablev = wa_tab2-taxablev.

*  vbeln TYPE vbrk-vbeln,
    wa_tab3-vbeln = wa_tab2-vbeln.
    wa_tab3-fkart = wa_tab2-fkart.
    wa_tab3-fkdat = wa_tab2-fkdat.

    wa_tab3-fkdat1+0(2) = wa_tab2-fkdat+6(2).
    wa_tab3-fkdat1+2(1) = '/'.
    wa_tab3-fkdat1+3(2) = wa_tab2-fkdat+4(2).
    wa_tab3-fkdat1+5(1) = '/'.
    wa_tab3-fkdat1+6(4) = wa_tab2-fkdat+0(4).

    wa_tab3-netwr = wa_tab2-netwr.
* mwsbk type vbrk-mwsbk,
    wa_tab3-mwsbp = wa_tab2-mwsbp.
    wa_tab3-kunag = wa_tab2-kunag.
*   kunag TYPE p,
    if h1 ne 'X'.
      wa_tab3-name1 = wa_tab2-name1.
      wa_tab3-name2 = wa_tab2-name2.
      wa_tab3-name3 = wa_tab2-name3.
      wa_tab3-name4 = wa_tab2-name4.
      wa_tab3-ort01 = wa_tab2-ort01.
    else.

      num = wa_tab2-vbeln.

      call function 'READ_TEXT'
        exporting
          client   = sy-mandt
          id       = '0001'
*         LANGUAGE = SY-LANGU
          language = 'E'
          name     = num          "" YOUR VARIABLE THAT CONTAINS Invoices number
          object   = 'VBBK'
        tables
          lines    = mmline.
      if sy-subrc <> 0.
        message id sy-msgid type sy-msgty number sy-msgno
                with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      endif.
      count = 1.
      loop at mmline.
        if count eq 1.
          wa_tab3-name1 =  mmline-tdline+0(50).
        elseif count eq 2.
          wa_tab3-name2 =  mmline-tdline+0(50).
        elseif count eq 3.
          wa_tab3-name3 =  mmline-tdline+0(50).
        elseif count eq 4.
          wa_tab3-name4 =  mmline-tdline+0(50).
        elseif count eq 5.
          wa_tab3-ort01 =  mmline-tdline+0(50).
        endif.
        count = count + 1.
      endloop.

    endif.
    wa_tab3-total = wa_tab2-total.
*   belnr TYPE bkpf-belnr,
    wa_tab3-belnr = wa_tab2-belnr.
*    AUBEL TYPE VBRP-AUBEL,
    wa_tab3-cldt = wa_tab2-cldt.
    wa_tab3-aubel = wa_tab2-aubel.
    wa_tab3-bstkd = wa_tab2-bstkd.
    wa_tab3-bstdk = wa_tab2-bstdk.
    wa_tab3-bstkd_e = wa_tab2-bstkd_e.
    wa_tab3-bstdk_e = wa_tab2-bstdk_e.
    wa_tab3-matnr = wa_tab2-matnr.
    wa_tab3-spart = wa_tab2-spart.
    wa_tab3-posnr = wa_tab2-posnr.
    wa_tab3-charg = wa_tab2-charg.
    wa_tab3-lgort = wa_tab2-lgort.
    wa_tab3-pstyv = wa_tab2-pstyv.
    wa_tab3-fkimg = wa_tab2-fkimg.
    wa_tab3-fkimg_f = wa_tab2-fkimg_f.
    wa_tab3-fkimg_c = wa_tab2-fkimg_c.
    wa_tab3-fkimg = wa_tab2-fkimg_c + wa_tab3-fkimg_f.
    wa_tab3-qty1 = wa_tab2-qty1.
    wa_tab3-qty = wa_tab2-qty.
    wa_tab3-arktx = wa_tab2-arktx.
    wa_tab3-cname1 = wa_tab2-cname1.
    wa_tab3-cname2 = wa_tab2-cname2.
    wa_tab3-cname3 = wa_tab2-cname3.
    wa_tab3-cname4 = wa_tab2-cname4.
    wa_tab3-city1 = wa_tab2-city1.
    wa_tab3-cj_1icstno = wa_tab2-cj_1icstno.
    wa_tab3-cj_1ilstno = wa_tab2-cj_1ilstno.
    wa_tab3-j_1icstno = wa_tab2-j_1icstno.
    wa_tab3-j_1ilstno = wa_tab2-j_1ilstno.
    wa_tab3-z001 = wa_tab2-z001.
    wa_tab3-ztot = wa_tab2-ztot.
    wa_tab3-ztotval = wa_tab2-ztotval.
    wa_tab3-zspdval = wa_tab2-zspdval.
    wa_tab3-zcusval = wa_tab2-zcusval.
    wa_tab3-rate = wa_tab2-rate.
    wa_tab3-disc = wa_tab2-disc.
    wa_tab3-bcnetwr = wa_tab2-bcnetwr.
    wa_tab3-xlnetwr = wa_tab2-xlnetwr.
    wa_tab3-bezei = wa_tab2-bezei.
    wa_tab3-bstnk = wa_tab2-bstnk.
    wa_tab3-bstdk1 = wa_tab2-bstdk.
    wa_tab3-submi = wa_tab2-submi.
    wa_tab3-mahdt = wa_tab2-mahdt.
    wa_tab3-rej = wa_tab2-rej.
    wa_tab3-expdt = wa_tab2-expdt.
    wa_tab3-vtext = wa_tab2-vtext.
    wa_tab3-typ = wa_tab2-typ.
    collect wa_tab3 into it_tab3.
    clear wa_tab3.
  endloop.


  clear: cname1.

  loop at it_tab3 into wa_tab3 where vbeln eq wa_check-vbeln.
    clear : vrate.
*    if wa_tab3-fkart eq 'ZRRS'.
    vrate = wa_tab3-ztotval / wa_tab3-fkimg_c.
    wa_tab3-ztot = vrate.
    select single * from zcdnfimm1 where belnr eq wa_tab3-vbeln.
    if sy-subrc eq 0.
      wa_tab3-rate = wa_tab3-netwr  / wa_tab3-qty1.
    else.
      if wa_tab3-fkimg_c gt 0. "9.12.20
        rate = wa_tab3-netwr / wa_tab3-fkimg_c.
      else.
        rate = wa_tab3-netwr .
      endif.
      wa_tab3-rate = rate.
    endif.
    if wa_tab3-ztotval eq 0.
      wa_tab3-ztotval = wa_tab3-netwr.
    endif.

    vbeln = wa_tab3-vbeln.

    cname1 = wa_tab3-cname1.
    cname2 = wa_tab3-cname2.
    cname3 = wa_tab3-cname3.
    cname4 = wa_tab3-cname4.
    cj_1icstno = wa_tab3-cj_1icstno.
    cj_1ilstno = wa_tab3-cj_1ilstno.
    gstin1 = wa_tab3-gstin1.
    city1 = wa_tab3-city1.

    name1 = wa_tab3-name1.
    name2 = wa_tab3-name2.
    name3 = wa_tab3-name3.
    name4 = wa_tab3-name4.
    ort01 = wa_tab3-ort01.
    gstin1 = wa_tab3-gstin1.
    ort01 = wa_tab3-ort01.

    gstin2 = wa_tab3-gstin2.
    vtext = wa_tab3-vtext.
    fkdat1 = wa_tab3-fkdat1.
    naubel = wa_tab3-aubel.
    cldt = wa_tab3-cldt.
    bstnk = wa_tab3-bstnk.
    IF FI_CR = 'X' OR FI_DR = 'X'.
      clear :bstnk , wa_tab3-bstnk.
     SELECT vgbel FROM VBAP into lv_ref
       FOR ALL ENTRIES IN it_vbrp where vbeln = it_vbrp-AUBEL.
      ENDSELECT.
    bstnk = lv_ref.
    ENDIF.
    bstdk1 = wa_tab3-bstdk1.
    submi = wa_tab3-submi.
    mahdt = wa_tab3-mahdt.

    bstkd = wa_tab3-bstkd.
    bstdk = wa_tab3-bstdk.
    bstkd_e = wa_tab3-bstkd_e.
    bstdk_e = wa_tab3-bstdk_e.


    modify it_tab3 from wa_tab3 transporting ztot rate ztotval.
    clear wa_tab3.

  endloop.

  sort it_tab3 by vbeln arktx.

  loop at it_tab2 into wa_tab2 where vbeln eq wa_check-vbeln.
    at end of vbeln.
      clear : aubel.
      read table it_tab1 into wa_tab1 with key vbeln = wa_tab2-vbeln.
      if sy-subrc eq 0.
        aubel = wa_tab1-aubel.
      endif.
*      WRITE : / 'HHHH',WA_TAB2-AUBEL.
      loop at it_ext2 into wa_ext2 where vbeln = wa_tab2-vbeln and aubel = aubel.
        wa_tab3-fkart = 'ZG2'.
        wa_tab3-werks = wa_ext2-werks.
        wa_tab3-vbeln = wa_tab2-vbeln.
        read table it_tab2 into wa_tab2 with key vbeln = wa_tab2-vbeln.
        if sy-subrc eq 0.
          wa_tab3-name1 = wa_tab2-name1.
          wa_tab3-name2 = wa_tab2-name2.
          wa_tab3-name3 = wa_tab2-name3.
          wa_tab3-name4 = wa_tab2-name4.
          wa_tab3-ort01 = wa_tab2-ort01.
********************************
          wa_tab3-cname1 = wa_tab2-cname1.
          wa_tab3-cname2 = wa_tab2-cname2.
          wa_tab3-cname3 = wa_tab2-cname3.
          wa_tab3-cname4 = wa_tab2-cname4.
          wa_tab3-city1 = wa_tab2-city1.
          wa_tab3-cj_1icstno = wa_tab2-cj_1icstno.
          wa_tab3-cj_1ilstno = wa_tab2-cj_1ilstno.
          wa_tab3-j_1icstno = wa_tab2-j_1icstno.
          wa_tab3-j_1ilstno = wa_tab2-j_1ilstno.
**********************************
        endif.
        wa_tab3-aubel = aubel.
        wa_tab3-matnr = wa_ext2-matnr.
        wa_tab3-z001 = wa_ext2-mrp.
        wa_tab3-ztot = wa_ext2-pts.
        wa_tab3-qty = wa_ext2-zmeng.
        wa_tab3-rej = 'REJECTED'.
        wa_tab3-typ = 'Z'.

*        select single * from ibatch where MATERIAL eq wa_ext2-matnr and plant eq wa_ext2-werks and batch eq wa_ext2-charg and SHELFLIFEEXPIRATIONDATE ne '          '.
       select single * from ibatch where MATERIAL eq wa_ext2-matnr  and batch eq wa_ext2-charg and SHELFLIFEEXPIRATIONDATE ne '           '. " added by ps
        if sy-subrc eq 0.

*          WRITE : mcha-vfdat+2(2).
          concatenate ibatch-SHELFLIFEEXPIRATIONDATE+4(2) '/' ibatch-SHELFLIFEEXPIRATIONDATE+2(2) into wa_tab3-expdt.
        endif.
        select single * from makt where spras eq 'EN' and matnr eq wa_ext2-matnr.
        if sy-subrc eq 0.
          wa_tab3-arktx = makt-maktx.
        endif.
        select single * from mvke where matnr eq wa_ext2-matnr and vkorg eq '1000' and vtweg eq '10'.
        if sy-subrc eq 0.
          select single * from tvm5t where spras eq 'EN' and mvgr5 eq mvke-mvgr5.
          if sy-subrc eq 0.
            wa_tab3-bezei = tvm5t-bezei.
          endif.
        endif.

*        if wa_tab3-gstin2 ne space.
*          invtyp1 = 'B2B'.
*        else.
*          invtyp1 = 'B2C'.
*        endif.

        collect wa_tab3 into it_tab3.
        clear wa_tab3.
      endloop.
    endat.

*    collect wa_tab3 into it_tab3.
*    clear wa_tab3.
  endloop.

  delete it_tab3 where matnr eq 0.
* SORT IT_TAB3 BY VBELN TYP.

  loop at it_tab3 into wa_tab3 where vbeln eq wa_check-vbeln.
    wa_tab4-vbeln = wa_tab3-vbeln.
    wa_tab4-kunag = wa_tab3-kunag.
    collect wa_tab4 into it_tab4.
    clear wa_tab4.

    wa_tab5-vbeln = wa_tab3-vbeln.
    wa_tab5-spart = wa_tab3-spart.
    wa_tab5-kunag = wa_tab3-kunag.
    collect wa_tab5 into it_tab5.
    clear wa_tab5.
  endloop.

  sort it_tab4 by vbeln.
  delete adjacent duplicates from it_tab4 comparing vbeln.
  refresh it_tap1.
  clear it_tap1.

*  sort it_tab3 by vbeln arktx.
  loop at it_tab4 into wa_tab4 where vbeln eq wa_check-vbeln.
    wa_tap1-kunag = wa_tab4-kunag.
    collect wa_tap1 into it_tap1.
    clear wa_tap1.
  endloop.

  date1 = sy-datum.
  date1+6(2) = '01'.
  call function 'HR_JP_MONTH_BEGIN_END_DATE'
    exporting
      iv_date           = date1
    importing
*     EV_MONTH_BEGIN_DATE       =
      ev_month_end_date = ldate1.
  m1 = date1+4(2).
  y1 = date1+0(4).
  refresh it_tapd1.
  clear it_tapd1.
  loop at it_tab5 into wa_tab5 where vbeln eq wa_check-vbeln.
    wa_tapd1-kunag =  wa_tab5-kunag.
    wa_tapd1-spart =  wa_tab5-spart.
    collect wa_tapd1 into it_tapd1.
    clear wa_tapd1.
  endloop.


*  IF P1 EQ 'X'.




  loop at it_tab4 into wa_tab4 where vbeln eq wa_check-vbeln.
    perform new1.
*      AT END OF VBELN.
*        TDIS = 0.
*        TVAL = 0.
*        TVAL1 = 0.
*        TTAX = 0.
*        SGST = 0.
*        CGST = 0.
*        IGST = 0.
*        UGST = 0.
*        XLVAL = 0.
*        BCVAL = 0.
*        TOTVAL  = 0.
*        TOTVAL1 = 0.
*        ZSPDVAL = 0.
*        ZCUSVAL = 0.
*      ENDAT.
  endloop.


*  ELSE.
*
*
*  ENDIF.

endform.
form dr_mail.
  clear : text2,text1.
  if dr_pr eq 'X' or dr_bat eq 'X' OR FI_DR eq 'X'.
    text1 = 'DEBIT NOTE'.
    text2 = 'DEBIT MEMO'.
    select * from vbrk into table it_vbrk where vbeln in inv and fkdat in p_date and fksto ne 'X' and fkart in ('ZQD','ZQDO','ZDRA','ZD08')  and kunag in cust.
*     in ('ZG2','ZBD','ZRS','ZG3','RE','ZC04','ZQC','ZRRE','ZRRS','ZC08')
    if sy-subrc ne 0.
      message 'NO DATA FOUND' type 'I'.
      exit.
    endif.
  elseif cr_pr eq 'X' or exp_cr eq 'X' or cr_bat eq 'X' OR FI_CR eq 'X' .
    text1 = 'CREDIT NOTE'.
    text2 = 'CREDIT MEMO'.
    select * from vbrk into table it_vbrk where vbeln in inv and fkdat in p_date and fksto ne 'X' and fkart
     in ('ZG2','ZBD','ZRS','ZG3','RE','ZC04','ZQC','ZRRE','ZRRS','ZC08','ZD08','ZTDS') and kunag in cust.
    if sy-subrc ne 0.
      message 'NO DATA FOUND' type 'I'.
      exit.
    endif.
  elseif sto_cr eq 'X'.
    text1 = 'CREDIT NOTE'.
    text2 = 'CREDIT MEMO'.
    select * from vbrk into table it_vbrk where vbeln in inv and fkdat in p_date and fksto ne 'X' and fkart
     in ( 'ZSR','ZFC' ) and kunag in cust.
    if sy-subrc ne 0.
      message 'NO DATA FOUND' type 'I'.
      exit.
    endif.
  endif.
  if it_vbrk is not initial.
    select knumv kposn kappl kschl kawrt kbetr kwert  from prcd_elements into table it_konv for all entries in it_vbrk where knumv = it_vbrk-knumv  and
     kschl in ('ZRM','ZGRP','ZFRG','JOIG','JOSG','JOCG','JOUG','Z001').
*       and kwert gt 0.
    select knumv kposn kappl kschl kawrt kbetr kwert  from prcd_elements into table it_konv1 for all entries in it_vbrk where knumv = it_vbrk-knumv  and
  kschl eq 'ZSPD'.
    select * from vbrp into table it_vbrp for all entries in it_vbrk where  vbeln = it_vbrk-vbeln and werks in p_plant.
    if sy-subrc eq 0.
      select * from marc into table it_marc for all entries in it_vbrp where matnr eq it_vbrp-matnr and werks eq it_vbrp-werks.
    endif.
  endif.
  sort it_konv by knumv kposn kappl kschl.

  loop at it_vbrk into wa_vbrk.
    read table it_vbrp into wa_vbrp with key vbeln = wa_vbrk-vbeln.
    if sy-subrc eq 0.
      wa_check-vbeln = wa_vbrk-vbeln.
      collect wa_check into it_check.
      clear wa_check.
    endif.
  endloop.

***************************************************************************************************************



*  CALL FUNCTION 'SSF_OPEN'
*    EXPORTING
*      CONTROL_PARAMETERS = CONTROL.

  loop at it_check into wa_check.

    call function 'SSF_FUNCTION_MODULE_NAME'
      exporting
        formname           = 'ZCDNPRINTGST11'
*       VARIANT            = ' '
*       DIRECT_CALL        = ' '
      importing
        fm_name            = v_fm
      exceptions
        no_form            = 1
        no_function_module = 2
        others             = 3.

*  CONTROL-NO_OPEN   = 'X'.
*  CONTROL-NO_CLOSE  = 'X'.
    w_ctrlop-getotf = abap_true.
    w_ctrlop-no_dialog = abap_true.
    w_compop-tdnoprev = abap_true.
    w_ctrlop-preview = space.
*    w_compop-tddest = 'LOCL'.





    clear : vbeln.
    vbeln = wa_check-vbeln.

    perform accchk.

    perform form1.
    w_ctrlop-getotf = abap_true.
    w_ctrlop-no_dialog = abap_true.
    w_compop-tdnoprev = abap_true.
    w_ctrlop-preview = space.
*    w_compop-tddest = 'LOCL'.

CALL FUNCTION v_fm "'/1BCDWB/SF00000131'
  EXPORTING
*   ARCHIVE_INDEX              =
*   ARCHIVE_INDEX_TAB          =
*   ARCHIVE_PARAMETERS         =
   CONTROL_PARAMETERS         = w_ctrlop
*   MAIL_APPL_OBJ              =
*   MAIL_RECIPIENT             =
*   MAIL_SENDER                =
   OUTPUT_OPTIONS             = w_compop
   USER_SETTINGS              = 'X'
    text2                      = text2
    fkart                      = fkart
    vbeln                      = vbeln
    c1                         = c1
    cname1                     = cname1
    city1                      = city1
    cname2                     = cname2
    cname3                     = cname3
    cname4                     = cname4
    cj_1icstno                 = cj_1icstno
    cj_1ilstno                 = cj_1ilstno
    gstin1                     = gstin1
    name1                      = name1
    name2                      = name2
    name3                      = name3
    name4                      = name4
    ort01                      = ort01
    gstin2                     = gstin2
    vtext                      = vtext
    fkdat1                     = fkdat1
    naubel                     = naubel
    cldt                       = cldt
    bstnk                      = bstnk
    bstdk1                     = bstdk1
    submi                      = submi
    mahdt                      = mahdt
    text1                      = text1
    invtyp1                    = invtyp1
    w4                         = w4
    TOTAL                      =  TOTAL
    bstkd                      = bstkd
    bstdk                      = bstdk
    bstkd_e                    = bstkd_e
    bstdk_e                    = bstdk_e
    ttext                      = ttext
    w41                        = w41
    w42                        = w42
    w40                        =  w40
    xlval                      =  xlval
    tval                       = tval
    lsval                      = lsval
    joigrt                     = joigrt
    totval                     = totval
    rtotval                    = rtotval
    ltext                      = ltext
    word1                      = word1
    f                          = f
    josgrt                     = josgrt
    sgst                       = sgst
    jocgrt                     = jocgrt
    cgst                       = cgst
    jougrt                     = jougrt
    ugst                       = ugst
    igst                       = igst
    txt1                       = txt1
    bcval                      = bcval
 IMPORTING
*   DOCUMENT_OUTPUT_INFO       =
   JOB_OUTPUT_INFO            = w_return
*   JOB_OUTPUT_OPTIONS         =
  TABLES
    it_tar1                    = it_tar1
* EXCEPTIONS
*   FORMATTING_ERROR           = 1
*   INTERNAL_ERROR             = 2
*   SEND_ERROR                 = 3
*   USER_CANCELED              = 4
*   OTHERS                     = 5
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.


    call function v_fm
      exporting
*       CONTROL_PARAMETERS = CONTROL
*       USER_SETTINGS      = 'X'
*       OUTPUT_OPTIONS     = W_SSFCOMPOP
        control_parameters = w_ctrlop
        output_options     = w_compop
        user_settings      = 'X'
        text2              = text2
        fkart              = fkart
        vbeln              = vbeln
        c1                 = c1
        cname1             = cname1
        cname2             = cname2
        cname3             = cname3
        cname4             = cname4
        city1              = city1
        cj_1icstno         = cj_1icstno
        cj_1ilstno         = cj_1ilstno
        gstin1             = gstin1
        name1              = name1
        name2              = name2
        name3              = name3
        name4              = name4
        ort01              = ort01
        gstin2             = gstin2
        vtext              = vtext
        fkdat1             = fkdat1
        naubel             = naubel
        cldt               = cldt
        bstnk              = bstnk
        bstdk1             = bstdk1
        submi              = submi
        mahdt              = mahdt
        text1              = text1
        invtyp1            = invtyp1
        total              = total
        bstkd              = bstkd
        bstdk              = bstdk
        bstkd_e            = bstkd_e
        bstdk_e            = bstdk_e
        w4                 = w4
        ttext              = ttext
        w41                = w41
        w42                = w42
        w40                = w40
        xlval              = xlval
        tval               = tval
        bcval              = bcval
        joigrt             = joigrt
        igst               = igst
        totval             = totval
        rtotval            = rtotval
        ltext              = ltext
        word1              = word1
        josgrt             = josgrt
        sgst               = sgst
        jocgrt             = jocgrt
        cgst               = cgst
        f                  = f
        jougrt             = jougrt
        ugst               = ugst
        txt1               = txt1
        lsval              = lsval
      importing
        job_output_info    = w_return " This will have all output
      tables
        it_tar1            = it_tar1
*       itab_division      = itab_division
*       itab_storage       = itab_storage
*       itab_pa0002        = itab_pa0002
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
* Sy-subrc check not required.

    clear it_mail3.
    perform rec_list.
    loop at i_reclist.
      wa_mail3-kunag = ''.
      wa_mail3-usrid_long  = i_reclist-receiver.
      append wa_mail3 to it_mail3.
      clear wa_mail3.
    endloop.
*    IN_MAILID = 'sabu@bluecrosslabs.com'.
*    PERFORM SEND_MAIL USING IN_MAILID.
    sort it_mail3 by usrid_long.
    delete adjacent duplicates from it_mail3 comparing usrid_long.
    loop at it_mail3 into wa_mail3 .
      clear in_mailid.
      in_mailid = wa_mail3-usrid_long.
      perform send_mail using in_mailid .
    endloop.




  endloop.

*  CALL FUNCTION 'SSF_CLOSE'.

*****************************************************


endform.                    "CR_PRINT
*FORM send_mail.
*  i_otf[] = w_return-otfdata[].
*
*  CALL FUNCTION 'CONVERT_OTF'
*    EXPORTING
*      format                = 'PDF'
*      max_linewidth         = 132
*    IMPORTING
*      bin_filesize          = v_len_in
*      bin_file              = i_xstring
*    TABLES
*      otf                   = i_otf
*      lines                 = i_tline
*    EXCEPTIONS
*      err_max_linewidth     = 1
*      err_format            = 2
*      err_conv_not_possible = 3
*      OTHERS                = 4.
*  IF sy-subrc <> 0.
*  ENDIF.
*
*          CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
*          EXPORTING
*            buffer     = i_xstring
*          TABLES
*            binary_tab = i_objbin[].
*
*
*
*
*
*
*
*
*
*
*  LOOP AT i_tline.
*    TRANSLATE i_tline USING '~'.
*    CONCATENATE wa_buffer i_tline INTO wa_buffer.
*  ENDLOOP.
*  TRANSLATE wa_buffer USING '~'.
*  DO.
*    i_record = wa_buffer.
*    APPEND i_record.
*    SHIFT wa_buffer LEFT BY 255 PLACES.
*    IF wa_buffer IS INITIAL.
*      EXIT.
*    ENDIF.
*  ENDDO."* Attachment
*  REFRESH:  i_reclist,
*            i_objtxt,
*            i_objbin,
*            i_objpack.
*  CLEAR     wa_objhead.
**  i_objbin[] = i_record[]."* Create Message Body Title and Description
*  i_objtxt = text1.
*  APPEND i_objtxt.
*  DESCRIBE TABLE i_objtxt LINES v_lines_txt.
*  READ TABLE i_objtxt INDEX v_lines_txt.
*  wa_doc_chng-obj_name = text1.
*  wa_doc_chng-expiry_dat = sy-datum + 10.
*  wa_doc_chng-obj_descr = text1.
*  wa_doc_chng-sensitivty = 'F'.
*  wa_doc_chng-doc_size = v_lines_txt * 255.
** Main Text
*  CLEAR i_objpack-transf_bin.
*  i_objpack-head_start = 1.
*  i_objpack-head_num = 0.
*  i_objpack-body_start = 1.
*  i_objpack-body_num = v_lines_txt.
*  i_objpack-doc_type = 'RAW'.
*  APPEND i_objpack."* Attachment (pdf-Attachment)
*  i_objpack-transf_bin = 'X'.
*  i_objpack-head_start = 1.
*  i_objpack-head_num = 0.
*  i_objpack-body_start = 1.
*  DESCRIBE TABLE i_objbin LINES v_lines_bin.
*  READ TABLE i_objbin INDEX v_lines_bin.
*  i_objpack-doc_size = v_lines_bin * 255 .
*  i_objpack-body_num = v_lines_bin.
*  i_objpack-doc_type = 'PDF'.
*  i_objpack-obj_name = 'smart'.
*  i_objpack-obj_descr = text1 .
*  APPEND i_objpack.
*
**  PERFORM rec_list.
*  CLEAR i_reclist.
*i_reclist-receiver = 'SABU@BLUECROSSLABS.COM'.
*i_reclist-rec_type = 'U'.
*APPEND i_reclist.
*  CALL FUNCTION 'SO_NEW_DOCUMENT_ATT_SEND_API1'
*    EXPORTING
*      document_data              = wa_doc_chng
*      put_in_outbox              = 'X'
*      commit_work                = 'X'
*    TABLES
*      packing_list               = i_objpack
*      object_header              = wa_objhead
*      contents_bin               = i_objbin
*      contents_txt               = i_objtxt
*      receivers                  = i_reclist
*    EXCEPTIONS
*      too_many_receivers         = 1
*      document_not_sent          = 2
*      document_type_not_exist    = 3
*      operation_no_authorization = 4
*      parameter_error            = 5
*      x_error                    = 6
*      enqueue_error              = 7
*      OTHERS                     = 8.
*  IF sy-subrc <> 0.
*    WRITE:/ 'Error When Sending the File', sy-subrc.
*  ELSE.
*    WRITE:/ 'Mail sent'.
*    LOOP AT i_reclist.
*      WRITE:/ i_reclist-receiver.
*    ENDLOOP.
*  ENDIF.
*ENDFORM.


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
  if cr_pr eq 'X' or exp_cr eq 'X' or cr_bat eq 'X' or FI_CR eq 'X'.
    body = 'Please find the attached CRDIT NOTE in PDF format.'.
    append body to lt_message_body.
    append initial line to lt_message_body.
  elseif dr_pr eq 'X' or dr_bat eq 'X'OR  FI_DR EQ 'X'.
    body = 'Please find the attached DEBIT NOTE in PDF format.'.
    append body to lt_message_body.
    append initial line to lt_message_body.

  endif.
  footer = 'With Regards,'.
  append footer to lt_message_body.
  footer = 'BLUE CROSS LABORATORIES PVT LTD.'.
  append footer to lt_message_body.
  "put your text into the document

  if dr_pr eq 'X' or dr_bat eq 'X' OR FI_DR eq 'X'.

    lo_document = cl_document_bcs=>create_document(
    i_type = 'RAW'
    i_text = lt_message_body
    i_subject = 'DEBIT NOTE' ).
  elseif cr_pr eq 'X' or exp_cr eq 'X' or cr_bat eq 'X' OR FI_CR eq 'X'.

    lo_document = cl_document_bcs=>create_document(
    i_type = 'RAW'
    i_text = lt_message_body
    i_subject = 'CREDIT NOTE' ).
  endif.
*DATA: l_size TYPE sood-objlen. " Size of Attachment
*l_size = l_lines * 255.


  if dr_pr eq 'X' or dr_bat eq 'X' or FI_DR eq 'X'.

    try.
        lo_document->add_attachment(
        exporting
        i_attachment_type = 'PDF'
        i_attachment_subject = 'DEBIT NOTE'
        i_att_content_hex = i_objbin[] ).
      catch cx_document_bcs into lx_document_bcs.
    endtry.
  elseif cr_pr eq 'X' or exp_cr eq 'X' or cr_bat eq 'X' or FI_CR eq 'X'.
    try.
        lo_document->add_attachment(
        exporting
        i_attachment_type = 'PDF'
        i_attachment_subject = 'CREDIT NOTE'
        i_att_content_hex = i_objbin[] ).
      catch cx_document_bcs into lx_document_bcs.
    endtry.
  endif.
* Add attachment
* Pass the document to send request
  lo_send_request->set_document( lo_document ).

  "Create sender
  lo_sender = cl_sapuser_bcs=>create( sy-uname ).

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
  clear wa_email.
  clear it_email1.
  refresh it_email1.
  wa_email-mandt = sy-mandt.
  wa_email-user_id = sy-uname.
  wa_email-email_time = sy-timlo.
  wa_email-email_date = sy-datum.
  wa_email-email_sent_to = in_mailid.
  wa_email-subject =  sy-tcode.
  append wa_email to it_email1.
  insert  zemail_log from table  it_email1 accepting duplicate keys.
*  SKIP.

* Commit Work to send the email
  commit work.
endform.



form rec_list.

  refresh i_reclist.
  clear i_reclist.
  refresh it_tap3.
  clear it_tap3.
  if r1 = 'X'  or r5 = 'X'.

    refresh i_reclist.
    clear i_reclist.

    clear i_reclist.

    loop at it_tap1 into wa_tap1.
      select single * from kna1 where kunnr eq wa_tap1-kunag.
      if sy-subrc eq 0.
        select single * from adr6 where addrnumber eq kna1-adrnr.
        if sy-subrc eq 0.
*           I_RECLIST-RECEIVER = 'sabu@bluecrosslabs.com'.
          i_reclist-receiver = adr6-smtp_addr.
          i_reclist-rec_type = 'U'.
          append i_reclist.
*
        endif.
      endif.
    endloop.


  endif.
  clear i_reclist.
  if r2 = 'X' or r5 = 'X'.
    if it_tapd1 is not initial.
      select * from ysd_cus_div_dis into table it_ysd_cus_div_dis for all entries in it_tapd1 where kunnr eq it_tapd1-kunag and
        spart eq it_tapd1-spart and endda le ldate1 and begda ge date1.
    endif.
    sort it_ysd_cus_div_dis by kunnr spart bzirk.
    delete adjacent duplicates from it_ysd_cus_div_dis comparing kunnr spart bzirk.
    if it_ysd_cus_div_dis is not initial.
      select * from yterrallc into table it_yterrallc for all entries in it_ysd_cus_div_dis where bzirk = it_ysd_cus_div_dis-bzirk and
        spart eq it_ysd_cus_div_dis-spart and endda ge sy-datum.
    endif.
    if it_yterrallc is not initial.
      select * from pa0001 into table it_pa0001 for all entries in it_yterrallc where plans eq it_yterrallc-plans and endda ge sy-datum.
    endif.

    loop at it_pa0001 into wa_pa0001.
      read table it_yterrallc into wa_yterrallc with key plans = wa_pa0001-plans.
      if sy-subrc eq 0.
        read table it_ysd_cus_div_dis into wa_ysd_cus_div_dis with key bzirk = wa_yterrallc-bzirk.
        if sy-subrc eq 0.
          select single * from pa0105 where pernr eq wa_pa0001-pernr and subty eq '0010'.
          if sy-subrc eq 0.
            i_reclist-receiver = pa0105-usrid_long.
            i_reclist-rec_type = 'U'.
            append i_reclist.
*
          endif.
        endif.
      endif.
    endloop.

  endif.
  if r3 = 'X' or r5 = 'X'.
    clear i_reclist.

    if it_tapd1 is not initial.
      select * from ysd_cus_div_dis into table it_ysd_cus_div_dis for all entries in it_tapd1 where kunnr eq it_tapd1-kunag and
        spart eq it_tapd1-spart and endda le ldate1 and begda ge date1.
    endif.
    sort it_ysd_cus_div_dis by kunnr spart bzirk.
    delete adjacent duplicates from it_ysd_cus_div_dis comparing kunnr spart bzirk.
    if it_ysd_cus_div_dis is not initial.
      select * from yterrallc into table it_yterrallc for all entries in it_ysd_cus_div_dis where bzirk = it_ysd_cus_div_dis-bzirk and
        spart eq it_ysd_cus_div_dis-spart and endda ge sy-datum.
    endif.
    loop at it_ysd_cus_div_dis into wa_ysd_cus_div_dis.
      read table it_yterrallc into wa_yterrallc with key bzirk = wa_ysd_cus_div_dis-bzirk spart = wa_ysd_cus_div_dis-spart.
      if sy-subrc eq 0.
        select single * from zdsmter where zmonth eq m1 and zyear eq y1 and bzirk eq wa_yterrallc-bzirk and spart = wa_yterrallc-spart.
        if sy-subrc eq 0.
          select single * from yterrallc where spart eq wa_yterrallc-spart and bzirk = zdsmter-zdsm and endda ge sy-datum.
          if sy-subrc eq 0.
            wa_tap3-kunnr = wa_ysd_cus_div_dis-kunnr.
            wa_tap3-bzirk = zdsmter-zdsm.
            wa_tap3-plans = yterrallc-plans.
            collect wa_tap3 into it_tap3.
            clear wa_tap3.
          endif.
        endif.
      endif.
    endloop.
    if it_tap3 is not initial.
      select * from pa0001 into table it_pa0001 for all entries in it_tap3 where plans eq it_tap3-plans and endda ge sy-datum.
    endif.
    loop at it_tap3 into wa_tap3.
      read table it_pa0001 into wa_pa0001 with key plans = wa_tap3-plans.
      if sy-subrc eq 0.
        select single * from pa0105 where pernr eq wa_pa0001-pernr and subty eq '0010'.
        if sy-subrc eq 0.
          i_reclist-receiver = pa0105-usrid_long.
          i_reclist-rec_type = 'U'.
          append i_reclist.
        endif.
      endif.
    endloop.

  endif.

  if r4 = 'X' or r5 = 'X'.
    clear i_reclist.

    if it_tapd1 is not initial.
      select * from ysd_cus_div_dis into table it_ysd_cus_div_dis for all entries in it_tapd1 where kunnr eq it_tapd1-kunag and
        spart eq it_tapd1-spart and endda le ldate1 and begda ge date1.
    endif.
    sort it_ysd_cus_div_dis by kunnr spart bzirk.
    delete adjacent duplicates from it_ysd_cus_div_dis comparing kunnr spart bzirk.
    if it_ysd_cus_div_dis is not initial.
      select * from yterrallc into table it_yterrallc for all entries in it_ysd_cus_div_dis where bzirk = it_ysd_cus_div_dis-bzirk and
        spart eq it_ysd_cus_div_dis-spart and endda ge sy-datum.
    endif.
    loop at it_ysd_cus_div_dis into wa_ysd_cus_div_dis.
      read table it_yterrallc into wa_yterrallc with key bzirk = wa_ysd_cus_div_dis-bzirk spart = wa_ysd_cus_div_dis-spart.
      if sy-subrc eq 0.
        select single * from zdsmter where zmonth eq m1 and zyear eq y1 and bzirk eq wa_yterrallc-bzirk and spart = wa_yterrallc-spart.
        if sy-subrc eq 0.
          select single * from zdsmter where zmonth eq m1 and zyear eq y1 and bzirk eq zdsmter-zdsm and spart = zdsmter-spart.
          if sy-subrc eq 0.
            select single * from yterrallc where spart eq wa_yterrallc-spart and bzirk = zdsmter-zdsm and endda ge sy-datum.
            if sy-subrc eq 0.
              wa_tap3-kunnr = wa_ysd_cus_div_dis-kunnr.
              wa_tap3-bzirk = zdsmter-zdsm.
              wa_tap3-plans = yterrallc-plans.
              collect wa_tap3 into it_tap3.
              clear wa_tap3.
            endif.
          endif.
        endif.
      endif.
    endloop.
    if it_tap3 is not initial.
      select * from pa0001 into table it_pa0001 for all entries in it_tap3 where plans eq it_tap3-plans and endda ge sy-datum.
    endif.
    loop at it_tap3 into wa_tap3.
      read table it_pa0001 into wa_pa0001 with key plans = wa_tap3-plans.
      if sy-subrc eq 0.
        select single * from pa0105 where pernr eq wa_pa0001-pernr and subty eq '0010'.
        if sy-subrc eq 0.
          i_reclist-receiver = pa0105-usrid_long.
          i_reclist-rec_type = 'U'.
          append i_reclist.
*

        endif.
      endif.
    endloop.
*
  endif.


*  DATA: IT_ZMPLANT TYPE TABLE OF ZMPLANT.
*  DATA: WA_ZMPLANT TYPE  ZMPLANT.
*  IF CHK1 = 'X'.
*
*
*
*
*
*
*
*
*
*
*    SELECT SINGLE * FROM T001W WHERE  WERKS =   Z_KUNNR.
*    IF SY-SUBRC = 0.
*      SELECT * FROM ZMPLANT INTO TABLE IT_ZMPLANT WHERE WERKS = T001W-WERKS.
*      LOOP AT IT_ZMPLANT INTO WA_ZMPLANT.
*        SELECT SINGLE * FROM YTERRALLC WHERE BZIRK = WA_ZMPLANT-BZIRK AND  ENDDA = '99991231'.
*        IF SY-SUBRC = 0.
*          SELECT SINGLE * FROM PA0001 WHERE PLANS = YTERRALLC-PLANS AND ENDDA = '99991231'.
*          IF SY-SUBRC = 0.
*            SELECT SINGLE * FROM PA0105 WHERE PERNR  = PA0001-PERNR AND SUBTY = '0010'.
*
*              CLEAR i_reclist.
*              i_reclist-receiver = PA0105-USRID_LONG.
*              i_reclist-rec_type = 'U'.
*              APPEND i_reclist.
*
*          ENDIF.
*        ENDIF.
*      ENDLOOP.
*    ENDIF.
*  ENDIF.
*  IF CHK2 = 'X'.
*    SELECT SINGLE * FROM KNA1 WHERE KUNNR = Z_KUNAG.
*    IF SY-SUBRC = 0.
*      SELECT SINGLE * FROM ADR6 WHERE ADDRNUMBER = KNA1-ADRNR.
*      IF SY-SUBRC = 0.
*         CLEAR i_reclist.
*         i_reclist-receiver = ADR6-SMTP_ADDR .
*         i_reclist-rec_type = 'U'.
*         APPEND i_reclist.
*
*        ENDIF.
*    ENDIF.
*  ENDIF.

*  DESCRIBE TABLE RECLIST LINES MCOUNT.
endform.
*&---------------------------------------------------------------------*
*&      Form  ACCCHK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form accchk.

  clear :  gjahr.
  select single * from vbrk where vbeln eq vbeln.
  if sy-subrc eq 0.
    if vbrk-fkdat+4(2) ge '04'.
      gjahr = vbrk-fkdat+0(4).
    else.
      gjahr = vbrk-fkdat+0(4) - 1.
    endif.
  endif.

  select single * from bkpf where bukrs eq '1000' and gjahr eq gjahr and awkey eq vbeln.
  if sy-subrc eq 4.
    if sy-uname eq 'ITBOM01' .
      message 'CHECK ACCOUNTING DOCUMENT' type 'I'.
    else.
      message 'CHECK ACCOUNTING DOCUMENT' type 'E'.
    endif.
  endif.
endform.
