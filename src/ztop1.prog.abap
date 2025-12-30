*&---------------------------------------------------------------------*
*& Include          ZTOP1
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include  ZTOP1
*&---------------------------------------------------------------------*
*PROGRAM SAPFM06P MESSAGE-ID ME..
tables: "nast,
        ekko,
        ekpa,
        lfa1,
        mara,
        zqspecification,
        zpms_art_table,
        PRCD_ELEMENTS,   "konv,
        t001w,
*        a792,  """""""" Cmt by PS
        konp,
        a003,
*       a796,  """""""" Cmt by PS
        adrc,
        kna1,
        makt,
        zpo_matnr,
        ekpo,
        eket,
        t052u,
        t001,
        taxcom,komk,komv,komp, tvzbt.

data
  :  xscreen.
data: xdruvo.
data:
*types: zform1 type xxxxxx.
  xlpet,                           "Lieferplaneinteilung
  xfz,                             "Fortschrittszahlendarstellung
  xoffen,                          "offene WE-Menge
  xlmahn,                           "Lieferplaneinteilungsmahnung
  fzflag,                          "KZ. Abstimmdatum erreicht
  xnoaend,                       "keine Änderungsbelege da  LPET
  xetdrk,                        "Druckrelevante Positionen da LPET
  xetefz  like eket-menge,          "Einteilungsfortschrittszahl
  xwemfz  like eket-menge,          "Lieferfortschrittszahl
  xabruf  like ekek-abruf,          "Alter Abruf
  p_abart like ekek-abart.         "Abrufart
data:  retco         like sy-subrc.             "Returncode Druck
data: mfgr   type adrc-name1,
      mfg(1) type c.
data : v_fm       type rs38l_fnam,
       format(10) type c.
data: it_ekpo type table of ekpo,
      wa_ekpo type ekpo.
types: begin of itab1,
         ebelp      type ekpo-ebelp,
         txz01(100) type c,
         menge(15)  type c,
         meins      type ekpo-meins,
         netpr      type ekpo-netpr,
         waers      type ekko-waers,
         peinh(5)   type c,
         netwr      type ekpo-netwr,
         matnr      type ekpo-matnr,
         j_1bnbm    type ekpo-j_1bnbm,
         hsntxt(10) type c,
         prms(20)   type c,
         art(20)    type c,
         prmsno(40) type c,
         artno(40)  type c,
         gross      type ekpo-netpr,
         grossval   type ekpo-netwr,
         jiigrt(7)  type c,
         jisgrt(7)  type c,
         jicgrt(7)  type c,
         jcisrt(7)  type c,
         jiig       type ekpo-netpr,
         jisg       type ekpo-netpr,
         jicg       type ekpo-netpr,
         jcis       type ekpo-netpr,
         retpo      type ekpo-retpo,
         licha      TYPE eket-licha,
         NAME1      Type LFA1-NAME1,
       end of itab1.
data: it_tab1 type table of itab1,
      wa_tab1 type itab1.
*data: qty type p.
data: qty TYPE mseg-menge.
data: bsart type ekko-bsart.
data:  knumv type ekko-knumv.
data: waers type ekko-waers.
data: prms(20)   type c,
      mtart      type mara-mtart,
      aedat      type ekko-aedat,
      prmsno(40) type c,
      artno(40)  type c,
      art(1)     type c,
      lifnr      type ekko-lifnr,
      ser(1)     type c,
      matkl      type ekpo-matkl,
      ven_reg    type   lfa1-regio,
      plt_reg    type t001w-regio,
      jiig_rate  type konp-kbetr,
      jisg_rate  type konp-kbetr,
      jicg_rate  type konp-kbetr,
      jcis_rate  type konp-kbetr,
      jiig_val   type p decimals 2,
      jisg_val   type p decimals 2,
      jicg_val   type p decimals 2,
      jcis_val   type p decimals 2,
      tot        type p decimals 2,
      tax        type p decimals 2,
      potot      type ekpo-netwr,
      werks      type t001w-werks,
      pms(1)     type c,
      ji(1)      type c,
      jc(1)      type c,
      jci(1)     type c.

data: imp(1) type c.

data wor    like spell.
data totword like spell.
data totword1(300) type c.
data: name1      type adrc-name1,
      name2(200) type c,
      ort01(50)  type c,
      stcd3      type lfa1-stcd3,
      sc(2)      type c,
      addr2      type adrc-name2,
      addr3      type adrc-name3,
      addr4      type CHAR60,
      astcd3     type kna1-stcd3,
      asc(2)     type c.
data: isd(1) type c.

data : begin of t_lines occurs 0.
         include structure tline.
       data : end of t_lines.

data: l_name   type thead-tdname,
*      t_lines  type table of tline,
      l_line   type tline,
      l_id     type thead-tdid,
      l_object type thead-tdobject,
      l_lang   type thead-tdspras.
data: text1(135) type c,
      text2      type string,
      text       type string.
*PERFORM form11.
types: begin of txt1,
         count(3)  type c,
         ebelp     type ekpo-ebelp,
         text(300) type c,
       end of txt1.
types: begin of txt2,
         count(3)  type c,
         text(300) type c,
       end of txt2.
data: it_txt1 type table of txt1,
      wa_txt1 type txt1,
      it_txt2 type table of txt2,
      wa_txt2 type txt2.
data: count type i.
data: txt2(1) type c.
data: gross    type p decimals 2,
      grossval type p decimals 2.
data: it_eket type table of eket,
      wa_eket type eket.

data: maktx(100) type c,
      maktx1(40) type c,
      maktx2(40) type c,
      normt      type mara-normt,
      hsntxt(10) type c,
      deldt      type  eket-eindt,
      popayterm  type t052u-text1,
      muldel(1)  type c.

data : ls_taxcom   type taxcom,
       ls_e_taxcom type taxcom,
       lt_komv     type table of komv,
       lw_komv     type komv.

data: t_ztext type table of ttext,
      w_ztext type ttext.


*data: t_ztext1 type table of T052,
*      w_ztext1 type T052.
*
*DATA: T_ZTEXT2 LIKE T052-ZTERM.
*DATA: W_ZTEXT2 TYPE TZTERM.


types: begin of pterm1,
         text1(50) type c,
       end of pterm1.
data: it_pterm1 type table of pterm1,
      wa_pterm1 type pterm1.
data: tax1(1) type c.
data: mat(1) type c.
types: begin of del1,
         ebeln type eket-ebeln,
         ebelp type eket-ebelp,
         qty   type eket-menge,
         meins type ekpo-meins,
         deldt type eket-eindt,
         etenr type eket-etenr,
       end of del1.
data: it_del1 type table of del1,
      wa_del1 type del1.
