*&---------------------------------------------------------------------*
*& Report  ZNHIIR1
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ZSALECNDNVAL1.
tables : zrt_input,
         vbrk,
         vbrp,
         ZDAILYSALES,
         mara.

******************************* data for HTML email

DATA : lv_obj_len        TYPE so_obj_len,
       lv_graphic_length TYPE tdlength,
       gr_xstr           TYPE xstring,
       lv_offset         TYPE i,
       lv_length         TYPE i,
       lv_diff           TYPE i,
       ls_solix          TYPE solix,
       lt_solix          TYPE solix_tab.

*Attach image to HTML body
DATA: lv_filename    TYPE string,
      lv_content_id  TYPE string,
      lt_soli        TYPE soli_tab,
      ls_soli        TYPE soli.

*Class for cobining HMTL & Image
DATA : lo_mime_helper   TYPE REF TO cl_gbt_multirelated_service.

*BCS class for sending mail
DATA: lo_bcs       TYPE REF TO cl_bcs,
      lo_doc_bcs   TYPE REF TO cl_document_bcs,
      lo_sender    TYPE REF TO if_sender_bcs,
      lo_recipient TYPE REF TO if_recipient_bcs,
      lv_subject    TYPE so_obj_des.

* Data Declaration
DATA: lfd_xstring    TYPE                   xstring,
      lfd_objid      TYPE                   w3objid,
      lv_obkey      TYPE                   wwwdatatab,
      lt_mime_raw   TYPE STANDARD TABLE OF w3mime,
      ls_mime_raw   TYPE                   w3mime.


* Import the Image File, these are maintained in transaction SMW0
lv_obkey-objid = 'ZUCT_ROUND_LOGO'.
lv_obkey-relid = 'MI'.

*********************************************   data for
DATA : S_BUDAT TYPE SY-DATUM.
DATA : MDAY(2)  TYPE C.
types : begin of typ_konv,
  knumv type PRCD_ELEMENTS-knumv,
  kposn type PRCD_ELEMENTS-kposn,
  kschl type PRCD_ELEMENTS-kschl,
  kwert type PRCD_ELEMENTS-kwert,
  kbetr type PRCD_ELEMENTS-kbetr,
  kawrt type PRCD_ELEMENTS-kawrt,
  end of typ_konv.

types : begin of typ_vbrp,
  vbeln type vbrp-vbeln,
  posnr type vbrp-posnr,
  fkimg type vbrp-fkimg,
  matnr type vbrp-matnr,
  arktx type vbrp-arktx,
  charg type vbrp-charg,
  pstyv type vbrp-pstyv,
  werks type vbrp-werks,
  lgort type vbrp-lgort,
  kzwi2 type vbrp-kzwi2,
  netwr type vbrp-netwr,
  mwsbp type vbrp-mwsbp,
  end of typ_vbrp.

data: w_text(80) type c.
data w_text1 type string.

data : it_vbrk type table of vbrk,
       wa_vbrk type vbrk,
       it_vbrp type table of typ_vbrp,
       wa_vbrp type typ_vbrp,
       it_zrt_input type table of zrt_input,
       wa_zrt_input type zrt_input,
       it_konv type table of typ_konv,
       wa_konv type typ_konv,
       it_konv1 type table of typ_konv,
       wa_konv1 type typ_konv,
       it_konv2 type table of typ_konv,
       wa_konv2 type typ_konv.

types : begin of itab1,
  vbeln(12) type c,
  knumv TYPE vbrk-knumv,
  STCD3 TYPE KNA1-STCD3,
  Bed_rate type p decimals 2,
  Xed_rate type p decimals 2,
  ls_ed_rate type p decimals 2,
  Fed_rate type p decimals 2,
  werks type vbrp-werks,
  LAND1 TYPE VBRK-LAND1,
  zped type p decimals 2,
  Bpts type p decimals 2,
  CN_VALUE TYPE P DECIMALS 2,
  DN_VALUE TYPE P DECIMALS 2,
  CN_BC TYPE P DECIMALS 2,
  CN_XL TYPE P DECIMALS 2,
  CN_LS TYPE P DECIMALS 2,
  DN_BC TYPE P DECIMALS 2,
  DN_XL TYPE P DECIMALS 2,
  DN_LS TYPE P DECIMALS 2,
  Xpts type p decimals 2,
  ls_pts type p decimals 2,
  pts type p decimals 2,
  TOTpts type p decimals 2,
  TOTAL type p decimals 2,
   Bzped_rate type p decimals 2,
   Bgrp_rate type p decimals 2,
    BFRG_rate type p decimals 2,
    BFRG_PER type p decimals 2,
  ls_zped_rate type p decimals 2,
   ls_grp_rate type p decimals 2,
    ls_FRG_rate type p decimals 2,
    ls_FRG_PER type p decimals 2,
    XFRG_rate type p decimals 2,
    XFRG_PER type p decimals 2,
   Bjocg type p decimals 2,
   Bjosg type p decimals 2,
   Bjoig type p decimals 2,
   Bjoug type p decimals 2,

  ls_jocg type p decimals 2,
   ls_josg type p decimals 2,
   ls_joig type p decimals 2,
   ls_joug type p decimals 2,

   KUNAG TYPE VBRK-KUNAG,
   btaxable TYPE p DECIMALS 2,
   xtaxable TYPE p DECIMALS 2,
   ls_taxable TYPE p DECIMALS 2,
   taxable TYPE p DECIMALS 2,
  NETWR TYPE P DECIMALS 2,
   Xjocg type p decimals 2,
   Xjosg type p decimals 2,
   Xjoig type p decimals 2,
   Xjoug type p decimals 2,
   jocg type p decimals 2,
   josg type p decimals 2,
   joig type p decimals 2,
   joug type p decimals 2,
   Xzped_rate type p decimals 2,
   Xgrp_rate type p decimals 2,
  jin6 type p decimals 2,
  fkdat type vbrk-fkdat,
  SPART TYPE MARA-SPART,
end of itab1.

data : it_tab1 type table of itab1,
       wa_tab1 type itab1,
       it_tab2 type table of itab1,
       wa_tab2 type itab1,
       it_tab3 type table of itab1,
       wa_tab3 type itab1,
       it_tab4 type table of itab1,
       wa_tab4 type itab1.

DATA : VAL1 TYPE P ,
       VAL2 TYPE P ,
       VAL3 TYPE P ,
       VAL4 TYPE P ,
       MMATNR TYPE MARA-MATNR,
       val11(15) type c,
       val12(15) type c,
       val13(15) type c,
       val14(15) type c,
       Bpts type p decimals 2,
       Xpts type p decimals 2,
       pts type p decimals 2.

DATA : HEAD1(25) TYPE C,
       HEAD2(25) TYPE C,
       HEAD3(25) TYPE C,
       HEAD4(25) TYPE C.

data : ZDAILYSALES_WA TYPE ZDAILYSALES.

data :  options type itcpo,
        l_otf_data like itcoo occurs 10 ,
        l_asc_data like tline occurs 10 ,
        l_docs    like docs  occurs 10 ,
        l_pdf_data like solisti1 occurs 10 ,
        l_pdf_data1 like solisti1 occurs 10 ,
           l_bin_filesize type i.
data :  result      like  itcpp.
data: docdata    like solisti1  occurs  10 ,
      objhead    like solisti1  occurs  1 ,
      objbin1    like solisti1  occurs 10 ,
      objbin    like solisti1  occurs 10 .
data: listobject like abaplist  occurs  1 .
data: doc_chng like sodocchgi1.
data reclist    like somlreci1  occurs  1 with header line.

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
data: ltx like t247-ltx.
data mcount type i.

types: begin of t_usr21,
     bname type usr21-bname,
     persnumber type usr21-persnumber,
     addrnumber type usr21-addrnumber,
    end of t_usr21.

types: begin of t_adr6,
         addrnumber type usr21-addrnumber,
         persnumber type usr21-persnumber,
         smtp_addr type adr6-smtp_addr,
        end of t_adr6.

data: it_usr21 type table of t_usr21,
      wa_usr21 type t_usr21,
      it_adr6 type table of t_adr6,
      wa_adr6 type t_adr6.

DATA : FROM_DT TYPE SY-DATUM.
DATA : TO_DT TYPE SY-DATUM.
data: sender like soextreci1-receiver.
data: reciepient TYPE REF TO if_sender_bcs.
*data: uemail TYPE REF TO if_sender_bcs.

selection-screen begin of block merkmale with frame title text-001.
*SELECT-OPTIONS : MDATE   FOR VBRK-FKDAT OBLIGATORY DEFAULT SY-DATUM.
*PARAMETERS : FROM_DT TYPE vbrk-fkdat obligatory DEFAULT SY-DATUM.
*PARAMETERS : TO_DT TYPE vbrk-fkdat obligatory DEFAULT SY-DATUM.
selection-screen end of block merkmale.

*AT SELECTION-SCREEN OUTPUT.
*
*  FROM_DT = SY-DATUM.
*  TO_DT = SY-DATUM.
*  MDAY = TO_DT+6(2).
*  IF MDAY  > '03'.
*     FROM_DT+6(2) = MDAY - 2.
*  ELSE.
*     FROM_DT+6(2) = '01'.
*  ENDIF.
*
*at selection-screen.
**  perform authorization.

initialization.
*  g_repid = sy-repid.

start-of-selection.

FROM_DT = SY-DATUM.
TO_DT = SY-DATUM.
*MDAY = TO_DT+6(2).
*IF MDAY  > '03'.
*   FROM_DT+6(2) = MDAY - 2.
*ELSE.
   FROM_DT+6(2) = '01'.
*ENDIF.

*WRITE : /1 FROM_DT, TO_DT.

PERFORM SALCNDN.
PERFORM UPDTTABLE.

FORM SALCNDN .

  CLEAR : VAL1 , VAL2, VAL3, VAL4.
  S_BUDAT = FROM_DT.
  WHILE S_BUDAT <= TO_DT.
*    WRITE : /1 S_BUDAT.
  CLEAR : IT_VBRK, WA_VBRK, IT_VBRP, WA_VBRP, IT_TAB1, WA_TAB1,  WA_TAB2, IT_KONV, WA_KONV.
*  WHILE S_BUDAT <= TO_DT.
  SELECT * FROM VBRK INTO TABLE IT_VBRK WHERE FKDAT = S_BUDAT AND FKART IN ('ZBDF', 'ZCDF') AND FKSTO NE 'X' .
  IF SY-SUBRC = 0.
    SELECT VBELN POSNR FKIMG MATNR ARKTX CHARG PSTYV WERKS LGORT KZWI2 NETWR MWSBP FROM VBRP INTO TABLE IT_VBRP
         FOR ALL ENTRIES IN IT_VBRK  WHERE  VBELN = IT_VBRK-VBELN .
    IF SY-SUBRC <> 0.
       EXIT.
    ENDIF.
  ENDIF.
  IF IT_VBRK IS NOT INITIAL.
    SELECT KNUMV KPOSN KSCHL KWERT KBETR KAWRT FROM PRCD_ELEMENTS INTO TABLE IT_KONV FOR ALL ENTRIES IN IT_VBRK WHERE KNUMV = IT_VBRK-KNUMV
      AND KSCHL IN ( 'ZPED','ZEX4','ZGRP','JOCG','JOSG','JOIG','JOUG' ).
  ENDIF.
  SORT IT_KONV BY KNUMV KPOSN KSCHL.

  LOOP AT IT_VBRP INTO WA_VBRP.
    READ TABLE IT_VBRK INTO WA_VBRK WITH KEY VBELN = WA_VBRP-VBELN.
    IF SY-SUBRC = 0.
      WA_TAB1-FKDAT = WA_VBRK-FKDAT.
      WA_TAB1-WERKS = WA_VBRP-WERKS.
      WA_TAB1-LAND1 = WA_VBRK-LAND1.
      SELECT SINGLE * FROM MARA WHERE MATNR = WA_VBRP-MATNR.
      IF SY-SUBRC = 0.
         WA_TAB1-SPART = MARA-SPART.
      ENDIF.
      if wa_vbrp-pstyv eq 'ZAN'.
         read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZEX4' binary search.
         if sy-subrc eq 0.
            wa_tab1-Bed_rate = wa_konv-kwert.
         endif.
         read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZPED' binary search.
         if sy-subrc eq 0.
            wa_tab1-Bzped_rate = wa_konv-kwert.
         endif.
         read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'ZGRP' binary search.
         if sy-subrc eq 0.
            wa_tab1-BGRP_rate = wa_konv-kwert.
         endif.
         read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'JOCG' binary search.
         if sy-subrc eq 0.
            wa_tab1-BJOCG = wa_konv-kwert.
            wa_tab1-Btaxable = wa_konv-kawrt.
         endif.
         read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'JOSG' binary search.
         if sy-subrc eq 0.
            wa_tab1-BJOSG = wa_konv-kwert.
            wa_tab1-Btaxable = wa_konv-kawrt.
         endif.
         read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'JOIG' binary search.
         if sy-subrc eq 0.
            wa_tab1-BJOIG = wa_konv-kwert.
            wa_tab1-Btaxable = wa_konv-kawrt.
         endif.
         read table it_konv into wa_konv with key knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kschl = 'JOUG' binary search.
         if sy-subrc eq 0.
            wa_tab1-BJOUG = wa_konv-kwert.
            wa_tab1-Btaxable = wa_konv-kawrt.
         endif.
      ENDIF.
      COLLECT WA_TAB1 INTO IT_TAB1.
      CLEAR WA_TAB1.
    ENDIF.
  ENDLOOP.

  LOOP AT IT_TAB1 INTO WA_TAB1.
    CLEAR : BPTS, XPTS.
    BPTS = WA_TAB1-BGRP_RATE + WA_TAB1-XGRP_RATE + WA_TAB1-ls_GRP_RATE.
    XPTS = ( WA_TAB1-BZPED_RATE + WA_TAB1-BED_RATE ) + ( WA_TAB1-XZPED_RATE + WA_TAB1-XED_RATE ).

    IF BPTS GT 0.
      WA_TAB2-PTS = WA_TAB1-BGRP_RATE.
      IF WA_TAB1-SPART = '50'.
        WA_TAB2-BPTS = WA_TAB1-BGRP_RATE.
      ELSEIF WA_TAB1-SPART = '60'.
        WA_TAB2-XPTS = WA_TAB1-BGRP_RATE.
      ELSEIF WA_TAB1-SPART = '70'.
        WA_TAB2-ls_PTS = WA_TAB1-BGRP_RATE.
      ENDIF.
    ELSE.
      WA_TAB2-PTS = WA_TAB1-BZPED_RATE + WA_TAB1-BED_RATE.
      IF WA_TAB1-SPART = '50'.
        WA_TAB2-BPTS = WA_TAB1-BZPED_RATE + WA_TAB1-BED_RATE.
      ELSEIF WA_TAB1-SPART = '60'.
        WA_TAB2-XPTS = WA_TAB1-BZPED_RATE + WA_TAB1-BED_RATE.
      ELSEIF WA_TAB1-SPART = '70'.
        WA_TAB2-ls_PTS = WA_TAB1-BZPED_RATE + WA_TAB1-BED_RATE.
      ENDIF.
    ENDIF.
    WA_TAB2-JOUG = WA_TAB1-XJOUG + WA_TAB1-BJOUG + WA_TAB1-ls_JOUG.
    WA_TAB2-JOIG = WA_TAB1-XJOIG + WA_TAB1-BJOIG + WA_TAB1-ls_JOIG.
    WA_TAB2-JOSG = WA_TAB1-XJOSG + WA_TAB1-BJOSG + WA_TAB1-ls_JOSG.
    WA_TAB2-JOCG = WA_TAB1-XJOCG + WA_TAB1-BJOCG + + WA_TAB1-ls_JOCG.
    WA_TAB2-taxable = WA_TAB1-XTAXABLE + WA_TAB1-BTAXABLE + WA_TAB1-ls_TAXABLE.
    WA_TAB2-FKDAT = WA_TAB1-FKDAT.
    WA_TAB2-WERKS = WA_TAB1-WERKS.
    WA_TAB2-LAND1 = WA_TAB1-LAND1.
    COLLECT WA_TAB2 INTO IT_TAB2.
    CLEAR WA_TAB2.
  ENDLOOP.

  CLEAR : IT_VBRK, WA_VBRK, IT_VBRP, WA_VBRP.
  SELECT * FROM VBRK INTO TABLE IT_VBRK WHERE VKORG = '2000' AND VTWEG = '20' AND KALSM IN ( 'ZEXPNP','ZDOMON' ) AND
                             FKDAT = S_BUDAT AND FKSTO <> 'X' AND FKART IN ( 'Z002','Z004' ).
  IF SY-SUBRC = 0.
     if it_vbrk is not initial.
         SELECT VBELN POSNR FKIMG MATNR ARKTX CHARG PSTYV WERKS LGORT KZWI2 NETWR MWSBP FROM VBRP INTO TABLE IT_VBRP
                   FOR ALL ENTRIES IN IT_VBRK  WHERE  VBELN = IT_VBRK-VBELN .
*        select * from vbrp into table it_vbrp for all entries in it_vbrk where vbeln eq it_vbrk-vbeln.
     ENDIF.
  ENDIF.
  CLEAR : WA_TAB2.
  LOOP AT IT_VBRP INTO WA_VBRP.
    MMATNR = WA_VBRP-MATNR+13(5).
    if strlen( Mmatnr ) = 5.
          concatenate  '0000000000000' Mmatnr into mmatnr.
    ENDIF.
*     WRITE : /1 MMATNR, WA_VBRP-MATNR.
     READ TABLE IT_VBRK INTO WA_VBRK WITH KEY VBELN = WA_VBRP-VBELN.
     IF SY-SUBRC = 0.
        IF WA_VBRP-PSTYV = 'TAN'.
           WA_TAB2-PTS = WA_VBRP-NETWR.
           WA_TAB2-LAND1 = WA_VBRK-LAND1.
           SELECT SINGLE * FROM MARA WHERE MATNR = MMATNR.
           IF SY-SUBRC = 0.
              IF MARA-SPART = '50'.
                 WA_TAB2-BPTS = WA_VBRP-NETWR.
              ELSEIF MARA-SPART = '60'.
                 WA_TAB2-XPTS = WA_VBRP-NETWR.
              ELSEIF MARA-SPART = '70'.
                 WA_TAB2-ls_PTS = WA_VBRP-NETWR.
              ENDIF.
           ENDIF.
           WA_TAB2-FKDAT = S_BUDAT.
           WA_TAB2-WERKS = WA_VBRP-WERKS.
           COLLECT WA_TAB2 INTO IT_TAB2.
           CLEAR WA_TAB2.
        ENDIF.
     ENDIF.
  ENDLOOP.

*************CREDIT NOTE DATA AS OF THAT DAY
  CLEAR : IT_TAB1, WA_TAB1 , IT_VBRK, WA_VBRK, IT_VBRP, WA_VBRP, IT_KONV, WA_KONV.
  SELECT * FROM VBRK INTO TABLE IT_VBRK WHERE FKDAT = S_BUDAT AND FKSTO NE 'X' AND
                      FKART IN ('ZG2','ZBD','ZRS','ZG3','RE','ZC04','ZQC','ZRRE','ZRRS','ZC08' ).

  IF SY-SUBRC = 0.
     SELECT VBELN POSNR FKIMG MATNR ARKTX CHARG PSTYV WERKS LGORT KZWI2 NETWR MWSBP FROM VBRP INTO TABLE IT_VBRP
                            FOR ALL ENTRIES IN IT_VBRK WHERE VBELN = IT_VBRK-VBELN .
  ENDIF.

  IF IT_VBRK IS NOT INITIAL.
     SELECT KNUMV KPOSN KSCHL KWERT KBETR KAWRT FROM PRCD_ELEMENTS INTO TABLE IT_KONV FOR ALL ENTRIES IN IT_VBRK
        WHERE KNUMV = IT_VBRK-KNUMV AND KSCHL IN ('JOCG','JOSG','JOIG','JOUG').
  ENDIF.
  SORT IT_KONV BY KNUMV KPOSN KSCHL.

  LOOP AT IT_VBRP INTO WA_VBRP.
    READ TABLE IT_VBRK INTO WA_VBRK WITH KEY VBELN = WA_VBRP-VBELN.
    IF SY-SUBRC = 0.
      WA_TAB1-WERKS = WA_VBRP-WERKS.
      WA_TAB1-VBELN = WA_VBRP-VBELN.
      WA_TAB1-LAND1 = WA_VBRK-LAND1.
      WA_TAB1-FKDAT = WA_VBRK-FKDAT.
      WA_TAB1-NETWR = WA_VBRP-NETWR.
      WA_TAB1-KUNAG = WA_VBRK-KUNAG.
      SELECT SINGLE * FROM MARA WHERE MATNR = WA_VBRP-MATNR.
      IF SY-SUBRC = 0.
         WA_TAB1-SPART = WA_VBRK-SPART.
      ENDIF.
      COLLECT WA_TAB1 INTO IT_TAB1.
      CLEAR WA_TAB1.
    ENDIF.
  ENDLOOP.

  LOOP AT IT_TAB1 INTO WA_TAB1.
     WA_TAB2-CN_VALUE = WA_TAB1-NETWR.
     WA_TAB2-LAND1 = WA_TAB1-LAND1.
     WA_TAB2-FKDAT = S_BUDAT.
     WA_TAB2-WERKS = WA_TAB1-WERKS.
     IF WA_TAB1-SPART = '50'.
        WA_TAB2-CN_BC  = WA_TAB1-NETWR.
     ELSEIF WA_TAB1-SPART = '60'."'XL'.
        WA_TAB2-CN_XL  = WA_TAB1-NETWR.
     ELSEIF WA_TAB1-SPART = '70'.
        WA_TAB2-CN_LS  = WA_TAB1-NETWR.
     ENDIF.
     COLLECT WA_TAB2 INTO IT_TAB2.
     CLEAR WA_TAB2.
  ENDLOOP.

*************DEBIT NOTE DATA AS OF THAT DAY
  CLEAR : IT_TAB1, WA_TAB1 , IT_VBRK, WA_VBRK, IT_VBRP, WA_VBRP, IT_KONV, WA_KONV.
  SELECT * FROM VBRK INTO TABLE IT_VBRK WHERE FKDAT = S_BUDAT AND FKSTO NE 'X' AND
                      FKART IN ( 'ZQD','ZDRA' ).

  IF SY-SUBRC = 0.
     SELECT VBELN POSNR FKIMG MATNR ARKTX CHARG PSTYV WERKS LGORT KZWI2 NETWR MWSBP FROM VBRP INTO TABLE IT_VBRP
                            FOR ALL ENTRIES IN IT_VBRK WHERE VBELN = IT_VBRK-VBELN .
  ENDIF.

  IF IT_VBRK IS NOT INITIAL.
     SELECT KNUMV KPOSN KSCHL KWERT KBETR KAWRT FROM PRCD_ELEMENTS INTO TABLE IT_KONV FOR ALL ENTRIES IN IT_VBRK
        WHERE KNUMV = IT_VBRK-KNUMV AND KSCHL IN ('JOCG','JOSG','JOIG','JOUG').
  ENDIF.
  SORT IT_KONV BY KNUMV KPOSN KSCHL.

  LOOP AT IT_VBRP INTO WA_VBRP.
    READ TABLE IT_VBRK INTO WA_VBRK WITH KEY VBELN = WA_VBRP-VBELN.
    IF SY-SUBRC = 0.
      WA_TAB1-WERKS = WA_VBRP-WERKS.
      WA_TAB1-VBELN = WA_VBRP-VBELN.
      WA_TAB1-FKDAT = WA_VBRK-FKDAT.
      WA_TAB1-LAND1 = WA_VBRK-LAND1.
      WA_TAB1-NETWR = WA_VBRP-NETWR.
      WA_TAB1-KUNAG = WA_VBRK-KUNAG.
      SELECT SINGLE * FROM MARA WHERE MATNR = WA_VBRP-MATNR.
      IF SY-SUBRC = 0.
         WA_TAB1-SPART = WA_VBRK-SPART.
      ENDIF.
      COLLECT WA_TAB1 INTO IT_TAB1.
      CLEAR WA_TAB1.
    ENDIF.
  ENDLOOP.

  LOOP AT IT_TAB1 INTO WA_TAB1.
     WA_TAB2-DN_VALUE = WA_TAB1-NETWR.
     WA_TAB2-LAND1 = WA_TAB1-LAND1.
     WA_TAB2-FKDAT = S_BUDAT.
     WA_TAB2-WERKS = WA_TAB1-WERKS.
     IF WA_TAB1-SPART = '50'.
        WA_TAB2-DN_BC  = WA_TAB1-NETWR.
     ELSEIF WA_TAB1-SPART = '60'.
        WA_TAB2-DN_XL  = WA_TAB1-NETWR.
     ELSEIF WA_TAB1-SPART = '70'.
        WA_TAB2-DN_LS  = WA_TAB1-NETWR.
     ENDIF.
     COLLECT WA_TAB2 INTO IT_TAB2.
     CLEAR WA_TAB2.
  ENDLOOP.
  COMMIT WORK.
  MDAY = S_BUDAT+6(2).
  MDAY = MDAY + 1.
  S_BUDAT+6(2) = MDAY.
ENDWHILE.
  SORT IT_TAB2 BY WERKS.
*  IF IT_TAB2 IS NOT INITIAL.
*    LOOP AT IT_TAB2 INTO WA_TAB2.
*      WRITE : /1 WA_TAB2-WERKS,' ,' ,   WA_TAB2-FKDAT,' ,' , WA_TAB2-PTS, WA_TAB2-BPTS, WA_TAB2-XPTS,' ,' , WA_TAB2-CN_VALUE,WA_TAB2-CN_BC,WA_TAB2-CN_XL,' ,' , WA_TAB2-DN_VALUE, WA_TAB2-DN_BC, WA_TAB2-DN_XL.
*    ENDLOOP.
*  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  UPDTTABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM UPDTTABLE .
    DELETE FROM ZDAILYSALES WHERE ASOF_DT >= FROM_DT AND ASOF_DT <= TO_DT.
    LOOP AT IT_TAB2 INTO WA_TAB2.
      ZDAILYSALES_WA-ASOF_DT  = WA_TAB2-FKDAT.
      ZDAILYSALES_WA-PLANT    = WA_TAB2-WERKS.
      ZDAILYSALES_WA-SALE_VAL = WA_TAB2-PTS.
      ZDAILYSALES_WA-SALE_BC = WA_TAB2-BPTS.
      ZDAILYSALES_WA-SALE_XL = WA_TAB2-XPTS.
      ZDAILYSALES_WA-CN_VAL   = WA_TAB2-CN_VALUE.
      ZDAILYSALES_WA-CN_VAL   = WA_TAB2-CN_BC.
      ZDAILYSALES_WA-CN_BC    = WA_TAB2-CN_XL.
      ZDAILYSALES_WA-DN_XL    = WA_TAB2-DN_VALUE.
      ZDAILYSALES_WA-DN_BC    = WA_TAB2-DN_BC.
      ZDAILYSALES_WA-DN_XL    = WA_TAB2-DN_XL.

      ZDAILYSALES_WA-SALE_Ls = WA_TAB2-ls_PTS.
      ZDAILYSALES_WA-CN_ls    = WA_TAB2-CN_Ls.
       ZDAILYSALES_WA-DN_ls    = WA_TAB2-DN_ls.
      MODIFY ZDAILYSALES FROM ZDAILYSALES_WA.
    ENDLOOP.
ENDFORM.
