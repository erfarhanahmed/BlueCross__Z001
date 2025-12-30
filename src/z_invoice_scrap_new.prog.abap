*&---------------------------------------------------------------------*
*& Report Z_INVOICE_SCRAP_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*REPORT Z_INVOICE_SCRAP_NEW.
*&---------------------------------------------------------------------*
*& Report  Z_J_1IEXCP5_N_GST42
*& DEVELOPED BY JYOTSNA.
*MAINTAIN OLD ADDRESS IF ADDRESS IS CHANGED - ZT001W - 5.6.25 JYOTSNA
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  z_j_1iexcp7 NO STANDARD PAGE HEADING LINE-SIZE 500.
TABLES : vbrk,
         j_1imtchid,
         mch1,
         thead,
         nast,
         vbdkr,
         vbrp,
         vbfa,
         likp,
         t001,
         spell,
         j_1iexcdtl,
         stxh,
         mara,
         marc,
         j_1ig_ewaybill,
         bkpf,
         zt001w,
         t001w,
         adrc,
         vbpa,
         lfa1,
         ztransport.



DATA : it_vbrk TYPE TABLE OF vbrk,
       wa_vbrk TYPE vbrk,
       it_vbrp TYPE TABLE OF vbrp,
       wa_vbrp TYPE vbrp,
       it_mseg TYPE TABLE OF mseg,
       wa_mseg TYPE mseg,
       it_ekko TYPE TABLE OF ekko,
       wa_ekko TYPE ekko,
       it_mcha TYPE TABLE OF mch1,
       wa_mcha TYPE mch1,
       it_mkpf TYPE TABLE OF mkpf,
       wa_mkpf TYPE mkpf.
DATA:  fkart TYPE vbrk-fkart.
TYPES : BEGIN OF imat1,
          mattext(25),
          matnr       LIKE vbrp-matnr,
        END OF imat1.

DATA : it_mat1 TYPE TABLE OF imat1,
       wa_mat1 TYPE imat1.

DATA :
*      z_j_1ichid like j_1imtchid-j_1ichid,
  z_j_1ichid   LIKE marc-steuc,
  z_mvgr5      LIKE mvke-mvgr5,
  z_kondm      LIKE mvke-kondm,
  kondm(4)     TYPE c,
  z_bezei      LIKE tvm5t-bezei,
  exp          LIKE mch1-vfdat,
  exp1(7)      TYPE c,
  z_knumv      LIKE vbrk-knumv,
  mknumv       LIKE vbrk-vbeln,
  z60          LIKE prcd_elements-kwert,
  totmrpv      LIKE j_1iexcdtl-exbas,
  z40          LIKE prcd_elements-kwert,
  z15          LIKE prcd_elements-kwert,
*       ZGRP like konv-kwert,
  zscp         LIKE prcd_elements-kwert,
  zrms         LIKE prcd_elements-kwert,
  zrms_val     LIKE prcd_elements-kwert,
  zpms         LIKE prcd_elements-kwert,
  zpms_val     LIKE prcd_elements-kwert,
  ztcs         LIKE prcd_elements-kwert,
  ztc1         LIKE prcd_elements-kwert,
  ztcs_rt      LIKE prcd_elements-kawrt,
  z20          LIKE prcd_elements-kawrt,
  joig_rt      LIKE prcd_elements-kawrt,
  joig_amt     LIKE prcd_elements-kawrt,
  josg_rt      LIKE prcd_elements-kawrt,
  josg_amt     LIKE prcd_elements-kawrt,
  jocg_rt      LIKE prcd_elements-kawrt,
  jocg_amt     LIKE prcd_elements-kawrt,
  tottax       LIKE prcd_elements-kwert,
  invtyp1(3)   TYPE c,
  invtyp2(7)   TYPE c,
  ttax         TYPE kwert,
  zjmod        LIKE prcd_elements-kwert,
  qty          TYPE vbrp-fkimg,
  pqty         TYPE i,
  pqty_l       TYPE i,
  totcase(5)   TYPE n,
  totalnocase  TYPE i,
  totalnocase1 TYPE i,
  totcase1(10) TYPE c,
  looseqty(5)  TYPE n,
  qty_l(5)     TYPE n,
  mumrez       LIKE marm-umrez,
  value        LIKE vbrp-netwr,
  tax          TYPE i,
  simple1      LIKE stxh-tdname,
  text1(50),
  cases        TYPE p,
  text(18)     TYPE c,
  text2(18)    TYPE c,
  p_text2(100) TYPE c,
  cnt          TYPE i.
DATA irn TYPE j_1ig_irn.

DATA  totalpts TYPE p DECIMALS 2.
DATA  toted16 TYPE i.
DATA  toted161 TYPE i.
DATA : toted162   LIKE pc207-betrg,
       words(200) TYPE c.
DATA  toted163 TYPE i.
DATA  edvalue LIKE j_1iexcdtl-exbas.
DATA  edvalue1 LIKE j_1iexcdtl-exbas.
DATA  edvalue2 LIKE j_1iexcdtl-exbas.
DATA  totqty(12) TYPE c.
DATA  toted  LIKE j_1iexcdtl-exbas.
DATA:
*      totval type i,
  totval     LIKE vbrp-netwr,
  ztotval    TYPE i,
  ztotrtamt  TYPE i,
  ztotaxval  TYPE i,
  ztottcs    TYPE vbrp-netwr,
  ttval      TYPE vbrp-netwr,
  diff       TYPE vbrp-netwr,
  t1tval     TYPE i,
  t2tval     TYPE vbrp-netwr,
  ztotrtamt1 TYPE p DECIMALS 2,
  ztotaxval1 TYPE p DECIMALS 2,
  ztotval1   TYPE p DECIMALS 2,
  ztottcs1   TYPE p DECIMALS 2,
  bcval      TYPE i,
  xlval      TYPE i,
  v_name1    TYPE adrc-name1.

DATA total_1 LIKE prcd_elements-kwert.
DATA wor    LIKE spell.
DATA netword1 LIKE spell.
DATA netword2 LIKE spell.
DATA netword3 LIKE spell.

DATA  totalval TYPE i.
DATA  plant LIKE ausp-atwrt.
DATA  m_cuobj LIKE inob-cuobj.
DATA  n_cuobj(50) TYPE c.
DATA  inv LIKE vbrk-vbeln.
DATA  party1 LIKE ekko-ekorg.
DATA  rnd TYPE i.
DATA  w_chapid LIKE j_1imtchid-j_1ichid.
DATA : mchar(50) TYPE c VALUE '  '.
DATA : linecount(2) TYPE n.
DATA : totalquantity LIKE j_1iexcdtl-menge.
DATA : z_exnum LIKE j_1iexcdtl-exnum.
DATA : z_cputm LIKE j_1iexcdtl-cputm.
DATA : z_rdoc1 LIKE j_1iexcdtl-rdoc1.
DATA : simple  LIKE stxh-tdname.
DATA : z_btgew LIKE likp-btgew.
DATA: z_btgew1(10) TYPE c.
DATA: t_date1 TYPE sy-datum.
DATA : z_bolnr LIKE likp-bolnr.
DATA: z_gewei TYPE likp-gewei.
DATA : z_vbeln LIKE likp-vbeln.
DATA : werks       LIKE vbrp-werks,
       p_text1(80) TYPE c.
DATA : z_kunag LIKE vbrk-kunag.
DATA : z_fkdat      LIKE vbrk-fkdat,
       z_fkdat1(10) TYPE c.
DATA : z_kunnr LIKE t001w-kunnr.
DATA : z_adrnr LIKE t001w-adrnr,
       z_ort01 LIKE t001w-ort01,
       z_regio LIKE t001w-regio.
DATA : z_adrnr1 LIKE kna1-adrnr,
       stcd3    LIKE kna1-stcd3.
DATA: gjahr TYPE bkpf-gjahr.
DATA: t_name   TYPE zteway_transport-t_name,
      t_doc_no TYPE zteway_transport-t_doc_no,
      t_date   TYPE zteway_transport-t_date.

DATA : itline LIKE tline OCCURS 0 WITH HEADER LINE.
DATA : itline1 LIKE tline OCCURS 0 WITH HEADER LINE.
DATA : nocase(5).

DATA : mmline2 LIKE tline OCCURS 0 WITH HEADER LINE.
DATA : mmline3 LIKE tline OCCURS 0 WITH HEADER LINE.
DATA : mmline4 LIKE tline OCCURS 0 WITH HEADER LINE.
DATA : count      TYPE i,
       name1(100) TYPE c,
       name2(100) TYPE c,
       name3(100) TYPE c,
       name4(100) TYPE c,
       name5(100) TYPE c.
*DATA LRNO LIKE  TLINE-TDLINE.
DATA eway LIKE  tline-tdline.
DATA ewaydt LIKE  tline-tdline.
DATA: ed1(2) TYPE c,
      em1(2) TYPE c,
      ey1(4) TYPE c.

DATA : tname1(100) TYPE c,
       tname2(100) TYPE c,
       tname3(100) TYPE c,
       tname4(100) TYPE c,
       tname5(100) TYPE c.


DATA : v_belnr LIKE bkpf-belnr,
       z_zfbdt LIKE bsid-zfbdt.
DATA : v_gjahr LIKE bkpf-gjahr.

DATA : p_kunnr LIKE t001w-kunnr.
DATA : p_adrnr LIKE t001w-adrnr,
       p_regio LIKE t001w-regio.
DATA : p_adrnr1 LIKE kna1-adrnr,
       p_stcd3  LIKE kna1-stcd3.

DATA : z_name1 LIKE adrc-name1,
       z_name2 LIKE adrc-name2,
       z_name3 LIKE adrc-name3,
       z_city1 TYPE adrc-city1,
       z_name4 LIKE adrc-name4,
       z_pstlz LIKE kna1-pstlz.
DATA : p_name1      LIKE adrc-name1,
       p_name2      LIKE adrc-name2,
       p_name3      LIKE adrc-name3,
       p_name4      LIKE adrc-name4,
       p_city1      TYPE adrc-city1,
       p_extension1 TYPE adrc-extension1,
       p_pstlz      TYPE t001w-pstlz.

DATA : z_extension1(40) TYPE c.
DATA : extension_a TYPE bu_id_number,
       extension_b TYPE bu_id_number.
DATA : z_transpzone LIKE adrc-transpzone.
DATA : z_j_1icstno LIKE j_1imocust-j_1icstno,
       z_j_1ilstno LIKE j_1imocust-j_1ilstno.
DATA : z_lifnr LIKE vbpa-lifnr,
       w_name1 LIKE lfa1-name1,
       w_ort01 LIKE lfa1-ort01.
DATA  num(70).
DATA : mmline  LIKE tline OCCURS 0 WITH HEADER LINE.
DATA : mmline1 LIKE tline OCCURS 0 WITH HEADER LINE.
DATA lrno LIKE  tline-tdline.
DATA vehicleno LIKE  tline-tdline.
DATA: retcode   LIKE sy-subrc.         "Returncode
DATA trp LIKE lfa1-lifnr.
DATA trpname LIKE lfa1-name1.
DATA: xscreen(1) TYPE c.
DATA : total LIKE j_1iexcdtl-exbas.
*DATA : totcase(5) TYPE n.
*DATA : totalnocase(4) TYPE c.
*DATA : looseqty(5) TYPE n.
*DATA : linecount(2) TYPE n.
DATA  tot_ed1 LIKE j_1iexcdtl-exbas.
DATA  tot_ed2 LIKE j_1iexcdtl-exbas.
DATA  tot_ed LIKE j_1iexcdtl-exbas.
DATA  t_total LIKE j_1iexcdtl-exbas.
*DATA : dt1 TYPE sy-datum.

TYPES : BEGIN OF itab1,
          charg        TYPE vbrp-charg,
          plant        LIKE ausp-atwrt,
          vrkme        LIKE vbrp-vrkme,
          j_1ichid     LIKE j_1imtchid-j_1ichid,
          bezei        LIKE tvm5t-bezei,
          exp1(7)      TYPE c,
          z60          LIKE prcd_elements-kwert,
          fkimg        TYPE vbrp-fkimg,
          rmfkimg      TYPE vbrp-fkimg,
          totmrpv      LIKE j_1iexcdtl-exbas,
          z40          LIKE prcd_elements-kwert,
          z15          LIKE prcd_elements-kwert,
          zscp         LIKE prcd_elements-kwert,
          ztcs         LIKE prcd_elements-kwert,
          ztcs_rt      LIKE prcd_elements-kwert,
          z20          TYPE p DECIMALS 2,
          joig_rt      LIKE prcd_elements-kwert,
          joig_amt     LIKE prcd_elements-kwert,
          josg_rt      LIKE prcd_elements-kwert,
          josg_amt     LIKE prcd_elements-kwert,
          jocg_rt      LIKE prcd_elements-kwert,
          jocg_amt     LIKE prcd_elements-kwert,
          tottax       TYPE prcd_elements-kwert,
          zrms         TYPE prcd_elements-kwert,
*       JOIG_RT(7) TYPE C,
*       JOIG_AMT(10) TYPE C,

          zjmod        LIKE prcd_elements-kwert,
          qty          TYPE i,
          pqty         TYPE i,
          pqty_l       TYPE i,
          totcase(5)   TYPE n,
          totalnocase  TYPE i,
          totalnocase1 TYPE i,
          totcase1     TYPE i,
          looseqty(5)  TYPE n,
          qty_l(5)     TYPE n,
          mumrez       LIKE marm-umrez,
          value        TYPE p DECIMALS 2,
          totva        TYPE p DECIMALS 2,
          tval         TYPE p DECIMALS 2,
          totalpts     LIKE j_1iexcdtl-exbas,
          toted16      LIKE j_1iexcdtl-exbas,
          toted161     LIKE j_1iexcdtl-exbas,
          toted162     LIKE j_1iexcdtl-exbas,
          toted163     LIKE j_1iexcdtl-exbas,
          edvalue      LIKE j_1iexcdtl-exbas,
          edvalue1     LIKE j_1iexcdtl-exbas,
          edvalue2     LIKE j_1iexcdtl-exbas,
          totqty       LIKE j_1iexcdtl-menge,
          toted        LIKE j_1iexcdtl-exbas,
          totval       LIKE j_1iexcdtl-exbas,
          totalval     LIKE j_1iexcdtl-exbas,
          tot_ed       LIKE j_1iexcdtl-exbas,
          tot_ed1      LIKE j_1iexcdtl-exbas,
          tot_ed2      LIKE j_1iexcdtl-exbas,
*       tot_ed like j_1iexcdtl-exbas,
          t_total      LIKE j_1iexcdtl-exbas,
          posnr        TYPE vbrp-posnr,
          arktx        TYPE vbrp-arktx,
          mfg_by(10)   TYPE c,
          kondm(4)     TYPE c,
          licha        TYPE mch1-licha,
          sgtxt        TYPE mseg-sgtxt,
          sr           TYPE i,
        END OF itab1.
TYPES : BEGIN OF itap1,
          charg TYPE mseg-charg,
          sgtxt TYPE mseg-sgtxt,
        END OF itap1.

DATA : mesg(40) TYPE c.
DATA: gd1 TYPE sy-datum.

TYPES : BEGIN OF itab2,
          vbeln       TYPE vbrk-vbeln,
          sr(3)       TYPE c,
          j_1ichid    LIKE j_1imtchid-j_1ichid,
          arktx       TYPE vbrp-arktx,
          fkimg       TYPE vbrp-fkimg,
          zscp        LIKE prcd_elements-kwert,
          value       TYPE vbrp-netwr,
          joig_rt     LIKE prcd_elements-kwert,
          joig_amt    LIKE prcd_elements-kwert,
          josg_rt     LIKE prcd_elements-kwert,
          josg_amt    LIKE prcd_elements-kwert,
          jocg_rt     LIKE prcd_elements-kwert,
          jocg_amt    LIKE prcd_elements-kwert,
          tottax      TYPE prcd_elements-kwert,
          totva       TYPE vbrp-netwr,
          ztcs_rt     LIKE prcd_elements-kwert,
          ztcs        LIKE prcd_elements-kwert,
          tval        TYPE vbrp-netwr,
          z20         TYPE vbrp-netwr,
          looseqty(5) TYPE c,
          pqty_l(5)   TYPE c,
          qty_l(5)    TYPE c,
        END OF itab2.

TYPES : BEGIN OF rm1,
          vbeln        TYPE vbrk-vbeln,
          sr(3)        TYPE c,
          j_1ichid     LIKE j_1imtchid-j_1ichid,
          arktx        TYPE vbrp-arktx,
          licha        TYPE mch1-licha,
          rmfkimg      TYPE vbrp-fkimg,
          vrkme        TYPE vbrp-vrkme,
          zrms         LIKE prcd_elements-kwert,
          value        TYPE vbrp-netwr,
          joig_rt(7)   TYPE c,
          joig_amt(10) TYPE c,
          josg_rt(7)   TYPE c,
          josg_amt(10) TYPE c,
          jocg_rt(7)   TYPE c,
          jocg_amt(10) TYPE c,
          tottax       TYPE prcd_elements-kwert,
          totva        TYPE vbrp-netwr,
        END OF rm1.

DATA : it_tab1 TYPE TABLE OF itab1,
       wa_tab1 TYPE itab1,
       it_tab2 TYPE TABLE OF itab2,
       wa_tab2 TYPE itab2,
       it_rm1  TYPE TABLE OF ZINVRMSALE1,
       wa_rm1  TYPE ZINVRMSALE1,
       it_tap1 TYPE TABLE OF itap1,
       wa_tap1 TYPE itap1.

TYPES: BEGIN OF t_usr05,
         bname TYPE usr05-bname,
         parid TYPE usr05-parid,
         parva TYPE usr05-parva,
       END OF t_usr05.

DATA : wa_usr05 TYPE t_usr05.

TYPES: BEGIN OF typ_t001w,
         werks TYPE werks_d,
         name1 TYPE name1,
       END OF typ_t001w.

DATA : itab_t001w TYPE TABLE OF typ_t001w,
       wa_t001w   TYPE typ_t001w.
DATA : msg TYPE string.

 DATA : BATCH_DETAILS TYPE TABLE OF CLBATCH,
          WA_BATCH_DETAILS TYPE CLBATCH.

TYPES : BEGIN OF st_check,
          vbeln TYPE vbrk-vbeln,
        END OF st_check.
DATA : vbeln TYPE vbrk-vbeln.

DATA : it_check TYPE TABLE OF st_check,
       wa_check TYPE          st_check.
DATA : control  TYPE ssfctrlop.
DATA : w_ssfcompop TYPE ssfcompop.

DATA : v_fm TYPE rs38l_fnam.
***Start.Yash.Gokulan.07.01.2021
DATA:ttblv    TYPE prcd_elements-kwert,
     lv_b2cqr TYPE string.
***End.Yash.Gokulan.07.01.2021
SELECTION-SCREEN BEGIN OF BLOCK merkmale WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS : inv_no FOR vbrk-vbeln OBLIGATORY.
  SELECT-OPTIONS : p_plant FOR vbrp-werks.
SELECTION-SCREEN END OF BLOCK merkmale.

SELECTION-SCREEN BEGIN OF BLOCK merkmale1 WITH FRAME TITLE TEXT-001.
  PARAMETERS : r1 RADIOBUTTON GROUP r1,
               r2 RADIOBUTTON GROUP r1.
SELECTION-SCREEN END OF BLOCK merkmale1.

*at selection-screen.
*  select SINGLE * from vbrk  where vbeln eq inv_no AND fkart EQ 'ZSCP'.
*  if sy-subrc eq 0.
*     IF VBRK-FKSTO EQ 'X'.
*        message 'INVOICE  IS CANCELLED' type 'E'.
*     ENDIF.
*  ELSE.
*    message 'ENTER VALID INVOICE NO' type 'E'.
*  endif.



AT SELECTION-SCREEN OUTPUT.
  SELECT SINGLE bname parid parva FROM usr05 INTO wa_usr05 WHERE bname = sy-uname
                                                     AND parid = 'ZPLANT'.
  p_plant-sign = 'I'.
  p_plant-option = 'BT'.
  p_plant-low = wa_usr05-parva.
  p_plant-high = wa_usr05-parva.
  APPEND p_plant.

START-OF-SELECTION.

  PERFORM authorization.



*  dt1+6(2) = '01'.
*  dt1+4(2) = '02'.
*  dt1+0(4) = '2018'.

  gd1+6(2) = '01'.
  gd1+4(2) = '01'.
  gd1+0(4) = '2020'.

  IF r1 EQ 'X'.
    PERFORM scrap.
  ELSEIF r2 EQ 'X'.
*    MESSAGE 'IN PROCESS' TYPE 'E'.
*    EXIT.
    PERFORM rmsale.
  ENDIF.

FORM scrap.
  SELECT * FROM vbrk INTO TABLE it_vbrk WHERE vbeln IN inv_no AND fkart IN ( 'ZSCP','ZSCR','ZSCA' ) AND fksto NE 'X'.
  IF sy-subrc NE 0.
    MESSAGE 'ENTER VALID INVOICE NO.' TYPE 'I'.
  ENDIF.

  SELECT * FROM vbrk INTO TABLE it_vbrk WHERE vbeln IN inv_no AND fkart IN ( 'ZSCP','ZSCR','ZSCA' )  AND fksto NE 'X'.
  IF sy-subrc EQ 0.
    SELECT * FROM vbrp INTO TABLE it_vbrp FOR ALL ENTRIES IN it_vbrk WHERE vbeln EQ it_vbrk-vbeln AND werks IN p_plant.
  ENDIF.

  LOOP AT it_vbrk INTO wa_vbrk.

    READ TABLE it_vbrp INTO wa_vbrp WITH KEY vbeln = wa_vbrk-vbeln.
    IF sy-subrc EQ 0.
      wa_check-vbeln = wa_vbrk-vbeln.
      COLLECT wa_check INTO it_check.
      CLEAR wa_check.
    ENDIF.
  ENDLOOP.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
*     FORMNAME           = 'ZINVSCR'
*     formname           = 'ZINVSCR2'
*     FORMNAME           = 'ZINVSCR4'
      formname           = 'ZINVSCR5'
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

  LOOP AT it_check INTO wa_check.

    CLEAR : vbeln,fkart.
    vbeln = wa_check-vbeln.
    READ TABLE it_vbrk INTO wa_vbrk WITH KEY vbeln = wa_check-vbeln.
    IF sy-subrc EQ 0.
      fkart = wa_vbrk-fkart.
    ENDIF.


    PERFORM scraprmsale.
*********check accounting doc*******************
    CLEAR : gjahr.
    IF z_fkdat+4(2) GE '04'.
      gjahr = z_fkdat+0(4).
    ELSE.
      gjahr = z_fkdat+0(4) - 1.
    ENDIF.
    SELECT SINGLE * FROM bkpf WHERE bukrs EQ '1000' AND gjahr EQ gjahr AND awkey EQ vbeln.
    IF sy-subrc EQ 4.
      IF sy-uname EQ 'ITBOM01'.
        MESSAGE 'CHECK ACCOUNTING DOCUMENT' TYPE 'I'.
      ELSE.
        MESSAGE 'CHECK ACCOUNTING DOCUMENT' TYPE 'E'.
      ENDIF.
    ENDIF.
    CLEAR : t_name,t_doc_no,t_date,z_btgew1. "TRANSPORTER DETAILS ADDED FOR MERCHANT EXPORT ON 24.2.25 - JYOTSNA
    SELECT SINGLE t_name t_doc_no t_date  FROM zteway_transport INTO ( t_name, t_doc_no, t_date ) WHERE bukrs EQ '1000' AND docno EQ wa_check-vbeln AND t_id NE space.
    z_btgew1 = z_btgew.
    CONDENSE : z_btgew1, z_gewei.

    t_date1+6(2) = t_date+6(2).
    t_date1+4(2) = t_date+4(2).
    t_date1+0(4) = t_date+0(4).

    CALL FUNCTION v_fm
      EXPORTING
        control_parameters = control
        user_settings      = 'X'
        output_options     = w_ssfcompop
*       FORMAT             = FORMAT
        p_name1            = p_name1
        p_name2            = p_name2
        p_name3            = p_name3
        p_name4            = p_name4
        p_stcd3            = p_stcd3
        p_extension1       = p_extension1
        p_city1            = p_city1
        z_name1            = z_name1
        z_name2            = z_name2
        z_name3            = z_name3
        z_name4            = z_name4
        stcd3              = stcd3
        z_extension1       = z_extension1
        z_city1            = z_city1
        text               = text
        vbeln              = vbeln
        z_fkdat1           = z_fkdat1
        z_cputm            = z_cputm
        invtyp1            = invtyp1
        invtyp2            = invtyp2
        name1              = name1
        name2              = name2
        name3              = name3
        name4              = name4
        name5              = name5
        netword2word       = netword2-word
        netword1word       = netword1-word
        totqty             = totqty
        totcase1           = totcase1
        ttax               = ttax
        ztottcs            = ztottcs
        ttval              = ttval
        diff               = diff
        t2tval             = t2tval
*       TOTZGRP            = TOTZGRP
*       TOTXVA             = TOTXVA
*       TOTVA              = TOTVA
*       DIFF1              = DIFF1
*       TOTVA2             = TOTVA2
        z_rdoc1            = z_rdoc1
        p_text1            = p_text1
        text2              = text2
        p_text2            = p_text2
        w_name1            = w_name1
        z_ort01            = z_ort01
        z_bolnr            = z_bolnr
        z_zfbdt            = z_zfbdt
        z_btgew            = z_btgew
        eway               = eway
        ewaydt             = ewaydt
        ztc1               = ztc1
        lv_b2cqr           = lv_b2cqr
        fkart              = fkart
        t_name             = t_name
        t_doc_no           = t_doc_no
        t_date             = t_date
        z_btgew1           = z_btgew1
        t_date1            = t_date1
        z_gewei            = z_gewei
        z_pstlz            = z_pstlz
        p_pstlz            = p_pstlz
*        v_name1            = v_name1
      TABLES
        it_tab2            = it_tab2
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.

  ENDLOOP.
  DATA : job_out TYPE  ssfcrescl.
  CALL FUNCTION 'SSF_CLOSE'
    IMPORTING
      job_output_info  = job_out
    EXCEPTIONS
      formatting_error = 1
      internal_error   = 2
      send_error       = 3
      OTHERS           = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
*  call function 'SSF_CLOSE'.

***************************************************




ENDFORM.

FORM rmsale.


  SELECT * FROM vbrk INTO TABLE it_vbrk WHERE vbeln IN inv_no AND  fkart IN ( 'ZRMS','ZPMS' )  AND fksto NE 'X'.
  IF sy-subrc NE 0.
    MESSAGE 'ENTER VALID INVOICE NO.' TYPE 'I'.
  ENDIF.

  SELECT * FROM vbrk INTO TABLE it_vbrk WHERE vbeln IN inv_no AND  fkart IN ( 'ZRMS','ZPMS' )  AND fksto NE 'X'.
  IF sy-subrc EQ 0.
    SELECT * FROM vbrp INTO TABLE it_vbrp FOR ALL ENTRIES IN it_vbrk WHERE vbeln EQ it_vbrk-vbeln AND werks IN p_plant.
  ENDIF.

  LOOP AT it_vbrk INTO wa_vbrk.
    READ TABLE it_vbrp INTO wa_vbrp WITH KEY vbeln = wa_vbrk-vbeln.
    IF sy-subrc EQ 0.
      wa_check-vbeln = wa_vbrk-vbeln.
      COLLECT wa_check INTO it_check.
      CLEAR wa_check.
    ENDIF.
  ENDLOOP.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
*     formname           = 'ZINVRMSALE'
      formname           = 'ZINVRMSALE1'
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

  LOOP AT it_check INTO wa_check.
    CLEAR : vbeln.
    vbeln = wa_check-vbeln.

    PERFORM rmpmsale.

*********check accounting doc*******************
    CLEAR : gjahr.
    IF z_fkdat+4(2) GE '04'.
      gjahr = z_fkdat+0(4).
    ELSE.
      gjahr = z_fkdat+0(4) - 1.
    ENDIF.
    SELECT SINGLE * FROM bkpf WHERE bukrs EQ '1000' AND gjahr EQ gjahr AND awkey EQ vbeln.
    IF sy-subrc EQ 4.
      IF sy-uname EQ 'ITBOM01'.
      ELSE.
        MESSAGE 'CHECK ACCOUNTING DOCUMENT' TYPE 'E'.
      ENDIF.
    ENDIF.


    CALL FUNCTION v_fm
      EXPORTING
        control_parameters = control
        user_settings      = 'X'
        output_options     = w_ssfcompop
*       FORMAT             = FORMAT
        p_name1            = p_name1
        p_name2            = p_name2
        p_name3            = p_name3
        p_name4            = p_name4
        p_stcd3            = p_stcd3
        p_extension1       = p_extension1
        p_city1            = p_city1
        z_name1            = z_name1
        z_name2            = z_name2
        z_name3            = z_name3
        z_name4            = z_name4
        stcd3              = stcd3
        z_extension1       = z_extension1
        z_city1            = z_city1
        text               = text
        vbeln              = vbeln
        z_fkdat1           = z_fkdat1
        z_cputm            = z_cputm
        invtyp1            = invtyp1
        invtyp2            = invtyp2
        name1              = name1
        name2              = name2
        name3              = name3
        name4              = name4
        name5              = name5
        netword2word       = netword2-word
        netword1word       = netword1-word
        totqty             = totqty
        totcase1           = totcase1
        ttax               = ttax
        ztottcs            = ztottcs
        ttval              = ttval
        diff               = diff
        t2tval             = t2tval
*       TOTZGRP            = TOTZGRP
*       TOTXVA             = TOTXVA
*       TOTVA              = TOTVA
*       DIFF1              = DIFF1
*       TOTVA2             = TOTVA2
        z_rdoc1            = z_rdoc1
        p_text1            = p_text1
        text2              = text2
        p_text2            = p_text2
        w_name1            = w_name1
        z_ort01            = z_ort01
        z_bolnr            = z_bolnr
        z_zfbdt            = z_zfbdt
        z_btgew            = z_btgew
        eway               = eway
        ewaydt             = ewaydt
        z_pstlz            = z_pstlz
        p_pstlz           = P_pstlz
*       MATNR              = MATNR
*       MAKTX              = MAKTX
*       ZTEXT              = ZTEXT
*       BQTY               = BQTY
*       MEINS              = MEINS
*       MAST               = MAST
*       KUNNR              = KUNNR
*       STLAN              = WA_CHECK-STLAN
*       STLAL              = WA_CHECK-STLAL
*       j_1imocust         = j_1imocust
*       g_lstno            = g_lstno
*       wa_adrc            = wa_adrc
*       vbkd               = vbkd
*       vbak               = vbak
*       total              = total
*       total1             = total1
*       vbrk               = vbrk
*       w_tax              = w_tax
*       w_value            = w_value
*       spell              = spell
*       w_diff             = w_diff
*       emname             = emname
*       rmname             = rmname
*       clmdt              = clmdt
      TABLES
        it_rm1             = it_rm1
*       itab_division      = itab_division
*       itab_storage       = itab_storage
*       itab_pa0002        = itab_pa0002
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.

  ENDLOOP.
  CALL FUNCTION 'SSF_CLOSE'.

***************************************************



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  AUTHORIZATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM authorization .
  SELECT werks name1 FROM t001w INTO TABLE itab_t001w WHERE werks IN p_plant.

  LOOP AT itab_t001w INTO wa_t001w.
    AUTHORITY-CHECK OBJECT 'M_BCO_WERK'
           ID 'WERKS' FIELD wa_t001w-werks.
    IF sy-subrc <> 0.
      CONCATENATE 'No authorization for Plant' wa_t001w-werks INTO msg
      SEPARATED BY space.
      MESSAGE msg TYPE 'E'.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SCRAPRMSALE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM scraprmsale .
  CLEAR : tax,text,text2,invtyp1,p_text2.
  CLEAR :
*  TOTVA2,
*  TOTVA,
*  DIFF1,
*  TOTXVA,
*  TOTZGRP,
  totcase1,totqty.
  CLEAR : totcase1,totalnocase, totalnocase1.
  CLEAR : it_tab1,wa_tab1,it_tab2,wa_tab2.
  CLEAR : ztc1,
*  FORMAT,
  p_name1,p_name2, p_name3, p_name4,p_stcd3,p_extension1,p_city1,z_name1, z_name2, z_name3,z_name4,stcd3 ,z_extension1,z_city1,
  text,z_fkdat1,z_cputm,invtyp1,invtyp2,name1,name2,name3,name4,name5 ,netword2-word,netword1-word ,totqty,totcase1 ,
*  TOTZGRP,TOTXVA ,
*  TOTVA,DIFF1, TOTVA2,
z_rdoc1, p_text1,text2, p_text2,w_name1,z_ort01,z_bolnr,z_zfbdt,z_btgew , eway,ewaydt,ttax,ztottcs,ttval,diff,t1tval,z_gewei.

  READ TABLE it_vbrk INTO wa_vbrk WITH KEY vbeln = wa_check-vbeln.
  IF sy-subrc EQ 0.
*    IF wa_vbrk-mwsbk GT 0.

    IF wa_vbrk-fkdat GE '20201005'.

      SELECT SINGLE irn FROM j_1ig_invrefnum INTO irn WHERE bukrs EQ '1000' AND docno EQ vbeln AND irn NE space.
      IF sy-subrc EQ 0.
        tax = 1.
        text = 'TAX INVOICE NO.'.
        text2 = 'TAX INVOICE'.
        p_text2 = '(Issued under sec. 31 of CGST act, 2017 read with rule 48 of CGST Rules, 2017)'.
      ELSE.

        text = 'PACKING LIST NO.'.
        text2 = 'PACKING LIST'.
        p_text2 = space.
      ENDIF.

    ELSE.
      tax = 1.
      text = 'TAX INVOICE NO.'.
      text2 = 'TAX INVOICE'.
      p_text2 = '(Issued under sec. 31 of CGST act, 2017 read with rule 48 of CGST Rules, 2017)'.
    ENDIF.
*    ELSE.
*      tax = 0.
*      text = 'BILL OF SUPPLY NO.'.
*      text2 = 'BILL OF SUPPLY'.
*      p_text2 = '(Issued under sec. 31 of CGST act, 2017 read with rule 49 of CGST Rules, 2017)'.
*    ENDIF.
*      MESSAGE 'PLEASE REFER TAX INVOICE' TYPE 'E'.
*    ENDIF.
  ENDIF.
  DELETE it_vbrp WHERE fkimg EQ 0.



  SELECT SINGLE gstin INTO p_stcd3 FROM j_1bbranch WHERE branch = wa_vbrk-bupla.
  READ TABLE it_vbrp INTO wa_vbrp WITH KEY vbeln = wa_check-vbeln.
  IF sy-subrc EQ 0.
    werks = wa_vbrp-werks.
  ENDIF.

  READ TABLE it_vbrp INTO wa_vbrp WITH KEY vbeln = wa_check-vbeln.
  IF sy-subrc EQ 0.
    z_rdoc1 = wa_vbrp-vgbel.
  ENDIF.
  SELECT SINGLE zfbdt INTO z_zfbdt FROM bsid WHERE bukrs EQ '1000' AND zuonr EQ wa_check-vbeln.
  SELECT SINGLE vbeln btgew bolnr gewei FROM likp INTO (z_vbeln,z_btgew,z_bolnr,z_gewei) WHERE vbeln EQ z_rdoc1.
  SELECT SINGLE kunag fkdat erzet FROM vbrk INTO (z_kunag,z_fkdat,z_cputm) WHERE vbeln EQ wa_check-vbeln.
  z_fkdat1+0(2) = z_fkdat+6(2).
  z_fkdat1+2(1) = '/'.
  z_fkdat1+3(2) = z_fkdat+4(2).
  z_fkdat1+5(1) = '/'.
  z_fkdat1+6(4) = z_fkdat+0(4).


*  * ***********************************         "Added by Varsha 9-10-2025
   IF wa_vbrk-fkdat GE '20240401'.
     CLEAR v_name1.
        SELECT SINGLE * FROM vbpa WHERE vbeln EQ wa_vbrk-vbeln AND parvw EQ 'ZT'.
        IF sy-subrc EQ 0.
*        adrnr into (v_adrnr) from vbpa where vbeln eq v_vgbel and parvw eq 'SP'.
          SELECT SINGLE * FROM lfa1 WHERE lifnr EQ vbpa-lifnr.
          IF sy-subrc EQ 0.
            v_name1 = lfa1-name1.
          ENDIF.
        ENDIF.

      ELSE.

        CLEAR v_name1.
        SELECT SINGLE t_name FROM zteway_transport INTO v_name1 WHERE bukrs EQ '1000' AND docno EQ wa_vbrk-vbeln.
        IF v_name1 IS INITIAL.
          SELECT SINGLE * FROM ztransport WHERE kunnr EQ z_kunag.
          IF sy-subrc EQ 0.
            v_name1 = ztransport-trpname.
          ENDIF.
        ENDIF.
      ENDIF.
* *******************************



  SELECT SINGLE werks ort01 regio  FROM t001w INTO (z_kunnr,z_ort01,z_regio) WHERE kunnr EQ z_kunag.
  SELECT SINGLE adrnr stcd3 name1 ort01 pstlz FROM kna1 INTO ( z_adrnr,stcd3,z_name1,z_city1,z_pstlz ) WHERE kunnr EQ z_kunag.
  SELECT SINGLE street str_suppl1 str_suppl2 FROM adrc INTO (z_name2,z_name3,z_name4) WHERE addrnumber EQ z_adrnr.
  SELECT idnumber , type FROM but0id INTO TABLE @DATA(it_ids)
         WHERE partner = @z_kunag AND type IN ('ZDL20B' , 'ZDL21B' ).

  LOOP AT it_ids INTO DATA(ls_ids).
    CASE ls_ids-type.
      WHEN 'ZDL20B'.
        extension_a = ls_ids-idnumber.
      WHEN 'ZDL21B'.
        extension_b = ls_ids-idnumber.
    ENDCASE.
  ENDLOOP.

  CONCATENATE extension_a extension_b INTO z_extension1 SEPARATED BY ','.

**********INVOICED AT*****************************
  SELECT SINGLE kunnr adrnr regio FROM t001w INTO (p_kunnr,p_adrnr,p_regio) WHERE werks EQ werks.

**************MAINTAIN OLD ADDRESS CHANGE 5.6.25***
*  SELECT SINGLE NAME1 NAME2 NAME3 NAME4 CITY1 FROM ADRC INTO (P_NAME1,P_NAME2,P_NAME3,P_NAME4,P_CITY1) WHERE ADDRNUMBER EQ P_ADRNR.
  SELECT SINGLE adrnr FROM kna1 INTO (p_adrnr1) WHERE kunnr EQ p_kunnr.
*  SELECT SINGLE EXTENSION1 FROM ADRC INTO (P_EXTENSION1) WHERE ADDRNUMBER EQ P_ADRNR1.

*************************************** Commented and Added by Varsha 20-09-2025 ***********
  SELECT SINGLE * FROM t001w WHERE werks = werks.
  p_adrnr = t001w-adrnr.
  p_name1 = t001w-name1.
  p_name2 = t001w-stras.
  p_city1 = t001w-ort01.
  p_pstlz = t001w-pstlz.
  SELECT SINGLE * FROM adrc WHERE addrnumber = p_adrnr.
  p_name3 = adrc-str_suppl1.
  p_name4 = adrc-str_suppl2.
  p_extension1 = adrc-name4.

*  SELECT SINGLE * FROM ZT001W WHERE WERKS EQ WERKS AND FROM_DT LE Z_FKDAT AND TO_DT GE Z_FKDAT.
*  IF SY-SUBRC EQ 0.
*    P_NAME1 = ZT001W-NAME1.
*    P_NAME2 = ZT001W-NAME2.
*    P_NAME3 = ZT001W-NAME3.
*    P_NAME4 = ZT001W-NAME4.
*    P_EXTENSION1 = ZT001W-EXTENSION1.
*    P_CITY1 = ZT001W-ORT01.
*  ELSE.
*    SELECT SINGLE NAME1 NAME2 NAME3 NAME4 CITY1 FROM ADRC INTO (P_NAME1,P_NAME2,P_NAME3,P_NAME4,P_CITY1) WHERE ADDRNUMBER EQ P_ADRNR.
*    SELECT SINGLE ADRNR FROM KNA1 INTO P_ADRNR1 WHERE KUNNR EQ P_KUNNR.
*    SELECT SINGLE EXTENSION1 FROM ADRC INTO (P_EXTENSION1) WHERE ADDRNUMBER EQ P_ADRNR1.
*  ENDIF.
***********************************************************************************************

  IF werks EQ '1000'.
    IF z_fkdat GT '20200504'.
      p_text1 = 'Wholesale Licence No- 20B/366610, 21B/366611'.
    ELSE.
      p_text1 = 'Wholesale Licence No- 20B/MH/NZ-1/1399, 21B/MH/NZ-1/1329'.
    ENDIF.
  ELSEIF werks EQ '1001'.
    IF z_fkdat GE '2020320'.
      p_text1 = space.
    ELSE.
      p_text1 = 'Goa factory wholesale Licence No- GA-SGO-5287,  GA-SGO-5288 dated 22.04.2016'.
    ENDIF.
  ENDIF.
***********************************************************************************

  SELECT SINGLE lifnr FROM vbpa INTO z_lifnr WHERE vbeln EQ inv_no AND parvw EQ 'SP'.
  SELECT SINGLE name1 ort01 FROM lfa1 INTO (w_name1,w_ort01) WHERE lifnr EQ z_lifnr.


********************************************-----
  CLEAR thead.

  thead-tdobject = 'J1II'.
  CONCATENATE sy-mandt nast-objky(10) INTO thead-tdname.
  thead-tdspras  = sy-langu.

*  vbdkr-land1 = 'IN'.
  CLEAR : vbrk, vbrp, vbfa, likp.
* read refrence document header type
  SELECT SINGLE vbeln vbtyp fkdat kurrf  FROM vbrk  INTO (vbrk-vbeln,vbrk-vbtyp, vbrk-fkdat, vbrk-kurrf) WHERE vbeln  = nast-objky(10).

*     num = vbrk-vbeln.
  num = wa_check-vbeln.

******************* eway bill *******************
  CLEAR : eway,ewaydt,ed1,em1,ey1.
  SELECT SINGLE * FROM j_1ig_ewaybill WHERE bukrs EQ '1000' AND docno EQ  wa_check-vbeln AND status EQ 'A'.
  IF sy-subrc EQ 0.
    eway = j_1ig_ewaybill-ebillno.
    CONDENSE eway.
    ed1 = j_1ig_ewaybill-erdat+6(2).
    em1 = j_1ig_ewaybill-erdat+4(2).
    ey1 = j_1ig_ewaybill-erdat+0(4).
    CONCATENATE ed1 em1 ey1 INTO ewaydt SEPARATED BY '.'.
    CONDENSE ewaydt.

*    EWAYDT = J_1IG_EWAYBILL-ERDAT.
  ELSE.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
*       CLIENT                  = SY-MANDT
        id                      = 'YWAY'
        language                = 'E'
        name                    = num
        object                  = 'VBBK'
*       ARCHIVE_HANDLE          = 0
*                  IMPORTING
*       HEADER                  =
      TABLES
        lines                   = mmline2
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

    LOOP AT mmline2.
      eway =  mmline2-tdline+0(20).
*    WRITE :  / 'LR',LRNO.
      EXIT.
    ENDLOOP.

*    WRITE : / 'DATE', Z_FKDAT.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
*       CLIENT                  = SY-MANDT
        id                      = 'YWAD'
        language                = 'E'
        name                    = num
        object                  = 'VBBK'
*       ARCHIVE_HANDLE          = 0
*                  IMPORTING
*       HEADER                  =
      TABLES
        lines                   = mmline3
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

    LOOP AT mmline3.
      ewaydt =  mmline3-tdline+0(20).
*    WRITE :  / 'LR',LRNO.
      EXIT.
    ENDLOOP.
  ENDIF.

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
*     CLIENT                  = SY-MANDT
      id                      = '0001'
      language                = 'E'
      name                    = num
      object                  = 'VBBK'
*     ARCHIVE_HANDLE          = 0
*                  IMPORTING
*     HEADER                  =
    TABLES
      lines                   = mmline4
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
  count = 1.
  LOOP AT mmline4.
    IF count EQ 1.
      name1 =  mmline4-tdline+0(50).
    ELSEIF count EQ 2.
      name2 =  mmline4-tdline+0(50).
    ELSEIF count EQ 3.
      name3 =  mmline4-tdline+0(50).
    ELSEIF count EQ 4.
      name4 =  mmline4-tdline+0(50).
    ELSE.
*      IF COUNT EQ 5.
      name5 =  mmline4-tdline+0(50).
    ENDIF.
    count = count + 1.
  ENDLOOP.

************************************************************************************


  READ TABLE it_vbrk INTO wa_vbrk WITH KEY vbeln = wa_check-vbeln .
*  fkart = 'ZSCP'.
  IF sy-subrc EQ 0.
    CLEAR: mknumv,z_bezei,exp,z_j_1ichid,z_mvgr5,z_kondm.
    cnt = 1.

    LOOP AT it_vbrp INTO wa_vbrp WHERE vbeln EQ wa_vbrk-vbeln.
      CLEAR : qty, tottax, joig_amt,joig_rt, jocg_amt,jocg_rt, josg_amt,josg_rt.
      READ TABLE it_vbrk INTO wa_vbrk WITH KEY vbeln = wa_vbrk-vbeln.
*       fkart = 'ZSCP'.
      IF sy-subrc EQ 0.
        wa_tab1-charg = wa_vbrp-charg.
*        SELECT SINGLE steuc FROM marc INTO z_j_1ichid  WHERE matnr EQ wa_vbrp-matnr AND steuc NE '    '.
        SELECT SINGLE steuc FROM marc INTO z_j_1ichid  WHERE matnr EQ wa_vbrp-matnr AND werks EQ wa_vbrp-werks.
        SELECT SINGLE mvgr5 kondm FROM mvke INTO (z_mvgr5, z_kondm) WHERE matnr EQ wa_vbrp-matnr.
        IF z_kondm EQ '02'.
          wa_tab1-kondm = '    '.
        ELSE.
          wa_tab1-kondm = 'NLEM'.
        ENDIF.
        SELECT SINGLE bezei FROM tvm5t INTO z_bezei WHERE  mvgr5 EQ z_mvgr5.
        SELECT SINGLE vfdat FROM mch1 INTO exp WHERE matnr = wa_vbrp-matnr AND charg = wa_vbrp-charg.

*    OVERLAY exp1 WITH MCHA-VFDAT+4(2).
        exp1 = exp+4(2).
        OVERLAY exp1+2(1) WITH '/'.
        OVERLAY exp1+3(4) WITH exp+0(4).
        SELECT SINGLE knumv FROM vbrk INTO mknumv WHERE vbeln = wa_vbrp-vbeln.

*    select single kwert from konv into z60
*   where knumv = mknumv and kposn = wa_vbrp-posnr and kschl = 'Z001'.
*    totmrpv = totmrpv + z60.
*
*    select single kwert from konv into z40
*    where knumv = mknumv and kposn = wa_vbrp-posnr and kschl = 'Z040'.
*
*    SELECT SINGLE kwert FROM konv INTO z15
*    WHERE knumv = mknumv AND kposn = WA_vbrp-posnr AND kschl = 'Z015'.
*
*    SELECT SINGLE kwert FROM konv INTO zGRP
*    WHERE knumv = mknumv AND kposn = WA_vbrp-posnr AND kschl = 'ZGRP'.
        CLEAR : ztcs,ztcs_rt,joig_amt,joig_rt,jocg_amt,josg_rt,josg_amt,jocg_rt,zscp,ztc1.
        SELECT SINGLE kwert FROM prcd_elements INTO zscp WHERE knumv = mknumv AND kposn = wa_vbrp-posnr AND kschl IN ( 'ZSCP','ZSCR' ).

        SELECT SINGLE kwert kbetr FROM prcd_elements INTO (joig_amt,joig_rt) WHERE knumv = mknumv AND kposn = wa_vbrp-posnr AND kschl = 'JOIG'.
        SELECT SINGLE kwert kbetr FROM prcd_elements INTO (josg_amt,josg_rt) WHERE knumv = mknumv AND kposn = wa_vbrp-posnr AND kschl = 'JOSG'.
        SELECT SINGLE kwert kbetr FROM prcd_elements INTO (jocg_amt,jocg_rt) WHERE knumv = mknumv AND kposn = wa_vbrp-posnr AND kschl = 'JOCG'.
        SELECT SINGLE kwert kbetr FROM prcd_elements INTO (ztcs,ztcs_rt) WHERE knumv = mknumv AND kposn = wa_vbrp-posnr AND kschl = 'JTC2' AND kwert GT 0.
        SELECT SINGLE kwert FROM prcd_elements INTO ztc1 WHERE knumv = mknumv AND kposn = wa_vbrp-posnr AND kschl = 'ZTC1' AND kwert GT 0.

        qty = wa_vbrp-fkimg .

        IF zscp NE 0.
          DIVIDE zscp BY  qty.
        ELSE.
          zscp = 0.
        ENDIF.

*    READ TABLE IT_VBRK INTO WA_VBRK WITH KEY VBELN = WA_VBRK-VBELN FKART = 'ZSCP'.
*    IF SY-SUBRC EQ 0.
*       ZSCP = ZSCP.
*    ENDIF.

        value = zscp * qty.
*     if ZGRP ne 0.
*      divide ZGRP by  qty.
*    else.
*      ZGRP = 0.
*    endif.
        wa_tab1-josg_rt = josg_rt .  "/ 10
        wa_tab1-josg_amt = josg_amt.
        wa_tab1-jocg_rt = jocg_rt .  "/ 10
        wa_tab1-jocg_amt = jocg_amt.
        wa_tab1-joig_rt = joig_rt.  "/ 10
        wa_tab1-joig_amt = joig_amt.
        tottax = josg_amt + jocg_amt + joig_amt.
        IF tottax GT 0 AND stcd3 NE space.
          invtyp1 = 'B2B'.
        ELSE.
          invtyp1 = 'B2C'.
************18.6.21***************
          IF z_fkdat GE '20210601'.
            tax = 1.
            text = 'TAX INVOICE NO.'.
            text2 = 'TAX INVOICE'.
            p_text2 = '(Issued under sec. 31 of CGST act, 2017 read with rule 48 of CGST Rules, 2017)'.
          ENDIF.
        ENDIF.
        invtyp2 = 'Regular'.
        wa_tab1-tottax = tottax.
        ttax = ttax +  wa_tab1-tottax.
        IF ztc1 NE 0 AND ztcs NE 0.
          MESSAGE 'TCS & TDS BOTH ARE APPLICABLE - PLEASE CHECK ' TYPE 'E'.  "RESTRICT
        ENDIF.
        IF ztc1 NE 0.
          wa_tab1-ztcs = ztc1.
        ELSE.
          wa_tab1-ztcs = ztcs.
        ENDIF.

        wa_tab1-ztcs_rt = ztcs_rt / 10.
*    IF JOIG_AMT LE 0.
*     wa_tab1-JOIG_RT = '  -'.
*     wa_tab1-JOIG_AMT = '     -'.
*    ENDIF.
        totqty = totqty + wa_vbrp-fkimg.
        wa_tab1-totqty = totqty.
        totval = totval + value.
        wa_tab1-totval = totval.

        mchar = wa_vbrp-matnr.
        OVERLAY mchar+18(4) WITH wa_vbrp-werks.
        OVERLAY mchar+22(10) WITH wa_vbrp-charg+0(10).
        wa_tab1-plant = plant.
        wa_tab1-j_1ichid = z_j_1ichid.
        wa_tab1-arktx = wa_vbrp-arktx.
        wa_tab1-bezei = z_bezei.
        wa_tab1-exp1 = exp1.
        wa_tab1-z60 = z60.
        wa_tab1-z15 = z15.
        READ TABLE it_vbrk INTO wa_vbrk WITH KEY vbeln = wa_vbrk-vbeln fkart = 'ZSAM'.
        IF sy-subrc EQ 0.
          wa_tab1-zscp = zscp.
        ELSE.
          wa_tab1-zscp = zscp.
        ENDIF.
        wa_tab1-z40 = z40.
        wa_tab1-zjmod = zjmod.
        wa_tab1-pqty = pqty.
        wa_tab1-mumrez = mumrez.
        wa_tab1-fkimg = wa_vbrp-fkimg.
        wa_tab1-value = value.
        wa_tab1-totva =  wa_tab1-value + tottax.
        wa_tab1-tval = wa_tab1-totva + wa_tab1-ztcs.
        ztotval = ztotval + wa_tab1-value.
        ztotrtamt = ztotrtamt + tottax.
        ztotaxval = ztotaxval + wa_tab1-tval.
        ttval = ttval + wa_tab1-tval.
        ztottcs = ztottcs + wa_tab1-ztcs.

        SELECT SINGLE * FROM mara WHERE matnr EQ wa_vbrp-matnr.
        IF sy-subrc EQ 0.
          IF mara-spart EQ '50'.
            bcval = bcval + wa_tab1-value.
          ELSEIF mara-spart EQ '60'.
            xlval = xlval + wa_tab1-value.
          ENDIF.
        ENDIF.
        wa_tab1-z20  = z20.
        wa_tab1-posnr = wa_vbrp-posnr.
        total = total + z20.
        totalnocase = totalnocase + pqty.
        wa_tab1-looseqty = looseqty.
        IF looseqty GT 0.
          pqty_l = 1.
          qty_l = looseqty.
          wa_tab1-pqty_l = pqty_l.
          wa_tab1-qty_l = qty_l.
          totalnocase1 = totalnocase1 + pqty_l.
        ENDIF.
        wa_tab1-sr = cnt.
        cnt = cnt + 1.
        COLLECT wa_tab1 INTO it_tab1.
        CLEAR wa_tab1.
      ENDIF.
    ENDLOOP.

    t1tval = ttval.
    t2tval = t1tval.
    diff = t2tval - ttval.

    ztotval1 = ztotval.
    ztotrtamt1 = ztotrtamt.
    ztotaxval1 = ztotaxval.
    ztottcs1 = ztottcs.
    total_1 = ztotaxval1.

*    *  ****************************MAKE E-WAY BIL  NO. & DATE CUMPULSORY*************************
*    IF z_fkdat GE dt1.
*      IF ztotaxval1 GE 50000.
*        IF eway IS INITIAL.
*          MESSAGE 'ENTER WAY BILL NUMBER & DATE' TYPE 'E'.
*        ENDIF.
*      ENDIF.
*    ENDIF.

    CALL FUNCTION 'Z_SPELL_AMOUNT_INDIA'
      EXPORTING
*       AMOUNT   = ZTOTAXVAL1
        amount   = t2tval
        language = sy-langu
      IMPORTING
        in_words = wor.

    WRITE wor-word TO netword1-word.
    SHIFT netword1-word LEFT DELETING LEADING space.
    SHIFT netword1-word LEFT DELETING LEADING '0'.
    SHIFT netword1-word LEFT DELETING LEADING '#'.
    SHIFT netword1-word LEFT DELETING LEADING space(1).

    IF ztotrtamt1 GT 0.
      CALL FUNCTION 'Z_SPELL_AMOUNT_INDIA'
        EXPORTING
*         AMOUNT   = ZTOTRTAMT1
          amount   = ttax
          language = sy-langu
        IMPORTING
          in_words = wor.
      WRITE wor-word TO netword2-word.
      SHIFT netword2-word LEFT DELETING LEADING space.
      SHIFT netword2-word LEFT DELETING LEADING '0'.
      SHIFT netword2-word LEFT DELETING LEADING '#'.
      SHIFT netword2-word LEFT DELETING LEADING space(1).

    ELSE.
      WRITE 'ZERO' TO netword2-word.
    ENDIF.

    IF ztottcs GT 0.
      CALL FUNCTION 'Z_SPELL_AMOUNT_INDIA'
        EXPORTING
          amount   = ztottcs1
          language = sy-langu
        IMPORTING
          in_words = wor.
      WRITE wor-word TO netword3-word.
      SHIFT netword3-word LEFT DELETING LEADING space.
      SHIFT netword3-word LEFT DELETING LEADING '0'.
      SHIFT netword3-word LEFT DELETING LEADING '#'.
      SHIFT netword3-word LEFT DELETING LEADING space(1).

    ELSE.
      WRITE 'ZERO' TO netword3-word.
    ENDIF.

  ENDIF.

  LOOP AT it_tab1 INTO wa_tab1.
    wa_tab2-sr =  wa_tab1-sr.
    wa_tab2-j_1ichid =  wa_tab1-j_1ichid.
    wa_tab2-arktx =   wa_tab1-arktx.
    wa_tab2-fkimg = wa_tab1-fkimg.
    wa_tab2-zscp =  wa_tab1-zscp.
    wa_tab2-value = wa_tab1-value.
    wa_tab2-josg_rt = wa_tab1-josg_rt.
    wa_tab2-josg_amt = wa_tab1-josg_amt.
    wa_tab2-jocg_rt = wa_tab1-jocg_rt.
    wa_tab2-jocg_amt = wa_tab1-jocg_amt.
    wa_tab2-joig_rt = wa_tab1-joig_rt.
    wa_tab2-joig_amt = wa_tab1-joig_amt.
    wa_tab2-tottax = wa_tab1-tottax.
    wa_tab2-totva = wa_tab1-totva.
    wa_tab2-ztcs_rt = wa_tab1-ztcs_rt.
    wa_tab2-ztcs = wa_tab1-ztcs.
    wa_tab2-tval =  wa_tab1-tval.
    wa_tab2-z20 =  wa_tab1-z20.
    wa_tab2-looseqty = wa_tab1-looseqty.
    wa_tab2-pqty_l =  wa_tab1-pqty_l.
    wa_tab2-qty_l = wa_tab1-qty_l.
    COLLECT wa_tab2 INTO it_tab2.
    CLEAR wa_tab2.
  ENDLOOP.

*  LOOP AT IT_TAB1 INTO WA_TAB1.
*    CALL FUNCTION 'WRITE_FORM'
*      EXPORTING
*        WINDOW = 'HEADER'.
*    CALL FUNCTION 'WRITE_FORM'
*      EXPORTING
*        ELEMENT = 'ITEM_VALUES'
*      EXCEPTIONS
*        OTHERS  = 1.
*    IF SY-SUBRC NE 0.
**          PERFORM protocol_update.
*    ENDIF.
*  ENDLOOP.

  DATA : z_toted16 TYPE p DECIMALS 2.
  DATA : z_toted161 TYPE p DECIMALS 2.
  DATA : z_toted163 TYPE p DECIMALS 2.
  DATA : z_totval TYPE p DECIMALS 2.
  DATA : z_totalpts TYPE p DECIMALS 2.
  DATA : z_totalpts_1 TYPE i.
  DATA : z_totalval TYPE p DECIMALS 2.


  toted162 = toted16 + toted161 + toted163.
  z_toted16 = toted16.
  z_toted161 = toted161.
  z_toted163 = toted163.
  t_total = totval + tot_ed + tot_ed1 + tot_ed2.
*write : / t_total.

  totcase1 =   totalnocase +   totalnocase1.

*write : / toted162,'werght',z_btgew,'CASE',totcase1,totqty,totalval.

  toted162 = toted162.

*call function 'SPELL_AMOUNT'
*       exporting
*            language  = sy-langu
*            currency  = t001-waers
*            amount    = toted162
*            filler    = space
*       importing
*            in_words  = spell
*       exceptions
*            not_found = 1
*            too_large = 2.

  CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
    EXPORTING
      amt_in_num         = toted162
    IMPORTING
      amt_in_words       = words
    EXCEPTIONS
      data_type_mismatch = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
  ENDIF.
  CONCATENATE words 'ONLY' INTO spell-word SEPARATED BY space.


  z_totval = totval.
  z_totalpts_1 = totalpts.
  z_totalpts = z_totalpts_1.
  z_totalval = totalval.


*  CALL FUNCTION 'WRITE_FORM'
*    EXPORTING
*      ELEMENT = 'PAGE_NO'
*      WINDOW  = 'FOOTER'
*    EXCEPTIONS
*      OTHERS  = 1.
*  CALL FUNCTION 'WRITE_FORM'
*    EXPORTING
*      ELEMENT = 'PAGE_NO'
*      WINDOW  = 'WINDOW4'
*    EXCEPTIONS
*      OTHERS  = 1.
*  CALL FUNCTION 'WRITE_FORM'
*    EXPORTING
*      ELEMENT = 'PAGE_NO'
*      WINDOW  = 'TRP'
*    EXCEPTIONS
*      OTHERS  = 1.
*  IF SY-SUBRC NE 0.
**    perform protocol_update.
*  ENDIF.



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

*CALL FUNCTION 'START_FORM'
*    EXPORTING
*      FORM        = 'Z_TRF_INVOICE_1'
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

*LOOP at it_tab1 INTO wa_tab1.
*CALL FUNCTION 'WRITE_FORM'
*    EXPORTING
*      WINDOW = 'TRP'.
*ENDLOOP.

*  CALL FUNCTION 'CLOSE_FORM'
** IMPORTING
**   RESULT                         =
**   RDI_RESULT                     =
** TABLES
**   OTFDATA                        =
*    EXCEPTIONS
*      UNOPENED                 = 1
*      BAD_PAGEFORMAT_FOR_PRINT = 2
*      SEND_ERROR               = 3
*      SPOOL_ERROR              = 4
*      CODEPAGE                 = 5
*      OTHERS                   = 6.
*  IF SY-SUBRC <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.

***Start..Yash.Gokulan.07.01.2021
  DATA:ttaxvt(15),
       ttblvt(15),
       ttamtt(15).
*BREAK-POINT.
  LOOP AT it_tab2 INTO wa_tab2.
    ttblv = ttblv + wa_tab2-value.
    CLEAR:wa_tab2.
  ENDLOOP.
  ttaxvt = ttax.
  ttblvt = ttblv.
  ttamtt = t2tval.
  CONDENSE:ttaxvt,ttblvt,ttamtt.
  CONCATENATE 'Company-BLUE CROSS LABORATORIES PVT LTD;GST No-27AAACB1549G1ZX;Invoice number-'
              vbeln ';Invoice Date-' z_fkdat1 ';Taxable Value-' ttblvt ';Tax Value-' ttaxvt
              ';Total Amount-' ttamtt '.' INTO lv_b2cqr.
***End.Yash.Gokulan.07.01.2021
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  RMPMSALE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM rmpmsale .

  CLEAR : tax,text,text2,invtyp1,p_text2.
  CLEAR :
*  TOTVA2,
*  TOTVA,
*  DIFF1,
*  TOTXVA,
*  TOTZGRP,
  totcase1,totqty.
  CLEAR : totcase1,totalnocase, totalnocase1.
  CLEAR : it_tab1,wa_tab1,it_tab2,wa_tab2,it_rm1,wa_rm1.
  CLEAR :
*  FORMAT,
  p_name1,p_name2, p_name3, p_name4,p_stcd3,p_extension1,p_city1,z_name1, z_name2, z_name3,z_name4,stcd3 ,z_extension1,z_city1,
  text,z_fkdat1,z_cputm,invtyp1,invtyp2,name1,name2,name3,name4,name5 ,netword2-word,netword1-word ,totqty,totcase1 ,
*  TOTZGRP,TOTXVA ,
*  TOTVA,DIFF1, TOTVA2,
z_rdoc1, p_text1,text2, p_text2,w_name1,z_ort01,z_bolnr,z_zfbdt,z_btgew , eway,ewaydt,ttax,ztottcs,ttval,diff,t1tval.
  CLEAR : zrms,zrms_val,zpms,zpms_val,joig_amt,joig_rt,josg_amt,josg_rt,jocg_amt,jocg_rt.



  READ TABLE it_vbrk INTO wa_vbrk WITH KEY vbeln = wa_check-vbeln.
  IF sy-subrc EQ 0.
*    IF wa_vbrk-mwsbk GT 0.

    IF wa_vbrk-fkdat GE '20201005'.

      SELECT SINGLE irn FROM j_1ig_invrefnum INTO irn WHERE bukrs EQ '1000' AND docno EQ wa_check-vbeln AND irn NE space.
      IF sy-subrc EQ 0.
        tax = 1.
        text = 'TAX INVOICE NO.'.
        text2 = 'TAX INVOICE'.
        p_text2 = '(Issued under sec. 31 of CGST act, 2017 read with rule 48 of CGST Rules, 2017)'.
      ELSE.
        text = 'PACKING LIST NO'.
        text2 = 'PACKING LIST'.
        p_text2 = space.
      ENDIF.

    ELSE.
      tax = 1.
      text = 'TAX INVOICE NO.'.
      text2 = 'TAX INVOICE'.
      p_text2 = '(Issued under sec. 31 of CGST act, 2017 read with rule 48 of CGST Rules, 2017)'.

    ENDIF.
  ENDIF.
  DELETE it_vbrp WHERE fkimg EQ 0.
  SELECT SINGLE gstin INTO p_stcd3 FROM j_1bbranch WHERE branch = wa_vbrk-bupla.
  READ TABLE it_vbrp INTO wa_vbrp WITH KEY vbeln = wa_check-vbeln.
  IF sy-subrc EQ 0.
    werks = wa_vbrp-werks.
  ENDIF.

  READ TABLE it_vbrp INTO wa_vbrp WITH KEY vbeln = wa_check-vbeln.
  IF sy-subrc EQ 0.
    z_rdoc1 = wa_vbrp-vgbel.
  ENDIF.
  SELECT SINGLE zfbdt INTO z_zfbdt FROM bsid WHERE bukrs EQ '1000' AND zuonr EQ wa_check-vbeln.
  SELECT SINGLE vbeln btgew bolnr gewei FROM likp INTO (z_vbeln,z_btgew,z_bolnr, z_gewei) WHERE vbeln EQ z_rdoc1.
  SELECT SINGLE kunag fkdat erzet FROM vbrk INTO (z_kunag,z_fkdat,z_cputm) WHERE vbeln EQ wa_check-vbeln.
  SELECT SINGLE werks ort01 regio  FROM t001w INTO (z_kunnr,z_ort01,z_regio) WHERE kunnr EQ z_kunag.
  SELECT SINGLE adrnr stcd3 name1 ort01 pstlz FROM kna1 INTO ( z_adrnr,stcd3,z_name1,z_city1,z_pstlz ) WHERE kunnr EQ z_kunag.
  SELECT SINGLE street str_suppl1 str_suppl2 FROM adrc INTO (z_name2,z_name3,z_name4) WHERE addrnumber EQ z_adrnr.
*  select single STCD3 from kna1 into (z_adrnr1,STCD3) where kunnr eq z_kunag.
  SELECT idnumber , type FROM but0id INTO TABLE @DATA(it_ids)
           WHERE partner = @z_kunag AND type IN ('ZDL20B' , 'ZDL21B' ).

  LOOP AT it_ids INTO DATA(ls_ids).
    CASE ls_ids-type.
      WHEN 'ZDL20B'.
        extension_a = ls_ids-idnumber.
      WHEN 'ZDL21B'.
        extension_b = ls_ids-idnumber.
    ENDCASE.
  ENDLOOP.

  CONCATENATE extension_a extension_b INTO z_extension1 SEPARATED BY ','.
**********INVOICED AT*****************************
  SELECT SINGLE kunnr adrnr regio FROM t001w INTO (p_kunnr,p_adrnr,p_regio) WHERE werks EQ werks.
*  select single name1 name2 name3 name4 city1 from adrc into (p_name1,p_name2,p_name3,p_name4,p_city1) where addrnumber eq p_adrnr.
  SELECT SINGLE adrnr FROM kna1 INTO (p_adrnr1) WHERE kunnr EQ p_kunnr.

  SELECT SINGLE * FROM t001w WHERE werks = werks.
  p_adrnr = t001w-adrnr.
  p_name1 = t001w-name1.
  p_name2 = t001w-stras.
  p_city1 = t001w-ort01.
  p_pstlz = t001w-pstlz.
  SELECT SINGLE * FROM adrc WHERE addrnumber = p_adrnr.
  p_name3 = adrc-str_suppl1.
  p_name4 = adrc-str_suppl2.
  p_extension1 = adrc-name4.

*  IF werks EQ '1000' OR werks EQ '1001'.  "removed on 20.8.21
*
*  ELSE.
*    SELECT SINGLE extension1 FROM adrc INTO (p_extension1) WHERE addrnumber EQ p_adrnr1.
*  ENDIF.
  IF werks EQ '1000'.
    IF z_fkdat GT '20200504'.
      p_text1 = 'Wholesale Licence No- 20B/366610, 21B/366611'.
    ELSE.
      p_text1 = 'Wholesale Licence No- 20B/MH/NZ-1/1399, 21B/MH/NZ-1/1329'.
    ENDIF.

  ELSEIF werks EQ '1001'.
    IF z_fkdat GE '20240320'.
      p_text1 = space.
    ELSE.
      p_text1 = 'Wholesale Licence No- GA-SGO-5287,  GA-SGO-5288 dated 22.04.2016'.
    ENDIF.
  ENDIF.
***********************************************************************************
*  SELECT SINGLE extension1 FROM adrc INTO z_extension1 WHERE addrnumber EQ z_adrnr1.
  SELECT SINGLE lifnr FROM vbpa INTO z_lifnr WHERE vbeln EQ inv_no AND parvw EQ 'SP'.
  SELECT SINGLE name1 ort01 FROM lfa1 INTO (w_name1,w_ort01) WHERE lifnr EQ z_lifnr.
  IF stcd3 NE space.
    invtyp1 = 'B2B'.
  ELSE.
    invtyp1 = 'DC'.
  ENDIF.
  invtyp2 = 'Regular'.

  CLEAR thead.

  thead-tdobject = 'J1II'.
  CONCATENATE sy-mandt nast-objky(10) INTO thead-tdname.
  thead-tdspras  = sy-langu.

*  vbdkr-land1 = 'IN'.
  CLEAR : vbrk, vbrp, vbfa, likp.
* read refrence document header type
  SELECT SINGLE vbeln vbtyp fkdat kurrf  FROM vbrk  INTO (vbrk-vbeln,vbrk-vbtyp, vbrk-fkdat, vbrk-kurrf) WHERE vbeln  = nast-objky(10).

*     num = vbrk-vbeln.
  num = wa_check-vbeln.

  CLEAR : eway,ewaydt,ed1,em1,ey1.
  SELECT SINGLE * FROM j_1ig_ewaybill WHERE bukrs EQ '1000' AND docno EQ  wa_check-vbeln AND status EQ 'A'.
  IF sy-subrc EQ 0.
    eway = j_1ig_ewaybill-ebillno.
    CONDENSE eway.

    ed1 = j_1ig_ewaybill-erdat+6(2).
    em1 = j_1ig_ewaybill-erdat+4(2).
    ey1 = j_1ig_ewaybill-erdat+0(4).
    CONCATENATE ed1 em1 ey1 INTO ewaydt SEPARATED BY '.'.
    CONDENSE ewaydt.

*    EWAYDT = J_1IG_EWAYBILL-ERDAT.
  ELSE.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
*       CLIENT                  = SY-MANDT
        id                      = 'YWAY'
        language                = 'E'
        name                    = num
        object                  = 'VBBK'
*       ARCHIVE_HANDLE          = 0
*                  IMPORTING
*       HEADER                  =
      TABLES
        lines                   = mmline2
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

    LOOP AT mmline2.
      eway =  mmline2-tdline+0(20).
*    WRITE :  / 'LR',LRNO.
      EXIT.
    ENDLOOP.

*    WRITE : / 'DATE', Z_FKDAT.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
*       CLIENT                  = SY-MANDT
        id                      = 'YWAD'
        language                = 'E'
        name                    = num
        object                  = 'VBBK'
*       ARCHIVE_HANDLE          = 0
*                  IMPORTING
*       HEADER                  =
      TABLES
        lines                   = mmline3
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

    LOOP AT mmline3.
      ewaydt =  mmline3-tdline+0(20).
*    WRITE :  / 'LR',LRNO.
      EXIT.
    ENDLOOP.
  ENDIF.


  CLEAR : z_fkdat1.
  z_fkdat1+0(2) = z_fkdat+6(2).
  z_fkdat1+2(1) = '/'.
  z_fkdat1+3(2) = z_fkdat+4(2).
  z_fkdat1+5(1) = '/'.
  z_fkdat1+6(4) = z_fkdat+0(4).

  CLEAR : ttval,t1tval,t2tval,t1tval,diff,ttax.
  cnt = 1.
  LOOP AT it_vbrp INTO wa_vbrp WHERE vbeln EQ wa_check-vbeln.
    CLEAR : qty, tottax,value,joig_amt,joig_rt, jocg_amt,jocg_rt, josg_amt,josg_rt.
*   READ TABLE IT_VBRK INTO WA_VBRK WITH KEY VBELN = WA_VBRK-VBELN FKART = 'ZRMS'.
*    IF SY-SUBRC EQ 0.
    wa_tab1-charg = wa_vbrp-charg.
*    SELECT SINGLE steuc FROM marc INTO z_j_1ichid  WHERE matnr EQ wa_vbrp-matnr AND steuc NE '    '.
    SELECT SINGLE steuc FROM marc INTO z_j_1ichid  WHERE matnr EQ wa_vbrp-matnr AND werks EQ wa_vbrp-werks.
    SELECT SINGLE mvgr5 kondm FROM mvke INTO (z_mvgr5, z_kondm) WHERE matnr EQ wa_vbrp-matnr.
    IF z_kondm EQ '02'.
      wa_tab1-kondm = '    '.
    ELSE.
      wa_tab1-kondm = 'NLEM'.
    ENDIF.
    SELECT SINGLE bezei FROM tvm5t INTO z_bezei WHERE  mvgr5 EQ z_mvgr5.
    SELECT SINGLE vfdat FROM mch1 INTO exp WHERE matnr = wa_vbrp-matnr AND charg = wa_vbrp-charg.

*    OVERLAY exp1 WITH MCHA-VFDAT+4(2).
    exp1 = exp+4(2).
    OVERLAY exp1+2(1) WITH '/'.
    OVERLAY exp1+3(4) WITH exp+0(4).
    SELECT SINGLE knumv FROM vbrk INTO mknumv WHERE vbeln = wa_vbrp-vbeln.
    SELECT SINGLE kbetr kwert FROM prcd_elements INTO (zrms,zrms_val) WHERE knumv = mknumv AND kposn = wa_vbrp-posnr AND kschl = 'ZRM'.
    SELECT SINGLE kbetr kwert FROM prcd_elements INTO (zpms,zpms_val) WHERE knumv = mknumv AND kposn = wa_vbrp-posnr AND kschl = 'ZPM'.
    SELECT SINGLE kwert kbetr FROM prcd_elements INTO (joig_amt,joig_rt) WHERE knumv = mknumv AND kposn = wa_vbrp-posnr AND kschl = 'JOIG'.
    SELECT SINGLE kwert kbetr FROM prcd_elements INTO (josg_amt,josg_rt) WHERE knumv = mknumv AND kposn = wa_vbrp-posnr AND kschl = 'JOSG'.
    SELECT SINGLE kwert kbetr FROM prcd_elements INTO (jocg_amt,jocg_rt) WHERE knumv = mknumv AND kposn = wa_vbrp-posnr AND kschl = 'JOCG'.
*    select single KWERT KBETR from konv into (ZTCS,ZTCS_RT) where knumv = mknumv and kposn = wa_vbrp-posnr and kschl = 'ZTCS'.

    qty = wa_vbrp-fkimg .
*    if ZRMS ne 0.
*      divide ZRMS by  qty.
*    else.
*      ZRMS = 0.
*    endif.
    IF zrms GT 0.
      wa_tab1-zrms = zrms.
      value = zrms_val.
    ELSE.
      wa_tab1-zrms = zpms.
      value = zpms_val.
    ENDIF.
    wa_tab1-vrkme = wa_vbrp-vrkme.
*     value = ZRMS * QTY.

    wa_tab1-josg_rt = josg_rt .  "/ 10
    wa_tab1-josg_amt = josg_amt.
    wa_tab1-jocg_rt = jocg_rt .  "/ 10
    wa_tab1-jocg_amt = jocg_amt.
    wa_tab1-joig_rt = joig_rt .  "/ 10
    wa_tab1-joig_amt = joig_amt.
    tottax = josg_amt + jocg_amt + joig_amt.
    IF wa_vbrp-vbeln EQ '0100031706'.
      wa_tab1-josg_rt = 0.
      wa_tab1-josg_amt = 0.
      wa_tab1-jocg_rt = 0.
      wa_tab1-jocg_amt = 0.
      wa_tab1-joig_rt = '18'.
      wa_tab1-joig_amt = '1058.40'.
      tottax = '1058.40'.
    ENDIF.

    wa_tab1-tottax = tottax.
    ttax = ttax +  wa_tab1-tottax.
    wa_tab1-ztcs = ztcs.
    wa_tab1-ztcs_rt = ztcs_rt / 10.
    totqty = totqty + wa_vbrp-fkimg.
    wa_tab1-totqty = totqty.
    totval = totval + value.
    wa_tab1-totval = totval.

    mchar = wa_vbrp-matnr.
    OVERLAY mchar+18(4) WITH wa_vbrp-werks.
    OVERLAY mchar+22(10) WITH wa_vbrp-charg+0(10).
    wa_tab1-plant = plant.
    wa_tab1-j_1ichid = z_j_1ichid.
    wa_tab1-arktx = wa_vbrp-arktx.
    wa_tab1-bezei = z_bezei.
    wa_tab1-exp1 = exp1.
    wa_tab1-z60 = z60.
    wa_tab1-z15 = z15.
    wa_tab1-z40 = z40.
    wa_tab1-zjmod = zjmod.
    wa_tab1-pqty = pqty.
    wa_tab1-mumrez = mumrez.
    wa_tab1-rmfkimg = wa_vbrp-fkimg.
    wa_tab1-value = value.
    wa_tab1-totva =  wa_tab1-value + tottax.
    wa_tab1-tval = wa_tab1-totva + wa_tab1-ztcs.
    ttval = ttval + wa_tab1-totva.
    ztotval = ztotval + wa_tab1-value.
    ztotrtamt = ztotrtamt + tottax.
    ztotaxval = ztotaxval + wa_tab1-tval.
    ztottcs = ztottcs + wa_tab1-ztcs.

    SELECT SINGLE * FROM mara WHERE matnr EQ wa_vbrp-matnr.
    IF sy-subrc EQ 0.
      IF mara-spart EQ '50'.
        bcval = bcval + wa_tab1-value.
      ELSEIF mara-spart EQ '60'.
        xlval = xlval + wa_tab1-value.
      ENDIF.
    ENDIF.
    wa_tab1-z20  = z20.
    wa_tab1-posnr = wa_vbrp-posnr.
    total = total + z20.
    totalnocase = totalnocase + pqty.
    wa_tab1-looseqty = looseqty.
    IF looseqty GT 0.
      pqty_l = 1.
      qty_l = looseqty.
      wa_tab1-pqty_l = pqty_l.
      wa_tab1-qty_l = qty_l.
      totalnocase1 = totalnocase1 + pqty_l.
    ENDIF.
*    SELECT SINGLE * FROM mch1 WHERE matnr EQ wa_vbrp-matnr  AND charg EQ wa_vbrp-charg AND LICHA NE space. "werks EQ wa_vbrp-werks
*    IF sy-subrc EQ 0.
*      wa_tab1-licha = mch1-LICHA.
*    ENDIF.



    CALL FUNCTION 'VB_BATCH_GET_DETAIL'
        EXPORTING
          MATNR              = wa_vbrp-matnr
          CHARG              = wa_vbrp-charg
          WERKS              = wa_vbrp-werks
          GET_CLASSIFICATION = 'X'
*         EXISTENCE_CHECK    =
*         READ_FROM_BUFFER   =
*         NO_CLASS_INIT      = ' '
*         LOCK_BATCH         = ' '
*       IMPORTING
*         YMCHA              =
*         CLASSNAME          =
*         BATCH_DEL_FLG      = BATCH_DETAILS
        TABLES
          CHAR_OF_BATCH      = BATCH_DETAILS
        EXCEPTIONS
          NO_MATERIAL        = 1
          NO_BATCH           = 2
          NO_PLANT           = 3
          MATERIAL_NOT_FOUND = 4
          PLANT_NOT_FOUND    = 5
          NO_AUTHORITY       = 6
          BATCH_NOT_EXIST    = 7
          LOCK_ON_BATCH      = 8
          OTHERS             = 9.
      IF SY-SUBRC <> 0.
* Implement suitable error handling here
      ENDIF.
      READ TABLE BATCH_DETAILS INTO WA_BATCH_DETAILS WITH KEY ATNAM = 'ZVENDOR_BATCH'.
      IF SY-SUBRC = 0 .
        wa_tab1-licha  = WA_BATCH_DETAILS-ATWTB.
      ENDIF.


    wa_tab1-sr = cnt.
    cnt = cnt + 1.
    COLLECT wa_tab1 INTO it_tab1.
    CLEAR wa_tab1.
*    ENDIF.

    t1tval = ttval.
    t2tval = t1tval.
    diff = t2tval - ttval.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = '0001'
*       LANGUAGE                = SY-LANGU
        language                = 'E'
        name                    = num          "" YOUR VARIABLE THAT CONTAINS Invoices number
        object                  = 'VBBK'
      TABLES
        lines                   = mmline
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
*      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.

    ENDIF.
    count = 1.
    LOOP AT mmline.
      IF count EQ 1.
        tname1 =  mmline-tdline+0(50).
      ELSEIF count EQ 2.
        tname2 =  mmline-tdline+0(50).
      ELSEIF count EQ 3.
        tname3 =  mmline-tdline+0(50).
      ELSEIF count EQ 4.
        tname4 =  mmline-tdline+0(50).
      ELSEIF count EQ 5.
        tname5 =  mmline-tdline+0(50).
      ENDIF.
      count = count + 1.
    ENDLOOP.

*  ENDLOOP.
***************ship to:  24.6.21
    CLEAR : mmline4,name1,name2,name3,name4,name5.
    REFRESH mmline4.
    CLEAR : mmline4.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
*       CLIENT                  = SY-MANDT
        id                      = '0001'
        language                = 'E'
        name                    = num
        object                  = 'VBBK'
*       ARCHIVE_HANDLE          = 0
*                  IMPORTING
*       HEADER                  =
      TABLES
        lines                   = mmline4
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.
    count = 1.
    LOOP AT mmline4.
      IF count EQ 1.
        name1 =  mmline4-tdline+0(50).
      ELSEIF count EQ 2.
        name2 =  mmline4-tdline+0(50).
      ELSEIF count EQ 3.
        name3 =  mmline4-tdline+0(50).
      ELSEIF count EQ 4.
        name4 =  mmline4-tdline+0(50).
      ELSE.
*      IF COUNT EQ 5.
        name5 =  mmline4-tdline+0(50).
      ENDIF.
      count = count + 1.
    ENDLOOP.
**************************************************

  ENDLOOP.

  ztotval1 = ztotval.
  ztotrtamt1 = ztotrtamt.
  ztotaxval1 = ztotaxval.
  ztottcs1 = ztottcs.
  total_1 = ztotaxval1.

*  ****************************MAKE E-WAY BIL  NO. & DATE CUMPULSORY*************************
*  IF z_fkdat GE dt1.
*    IF ztotaxval1 GE 50000.
*      IF eway IS INITIAL.
*        MESSAGE 'ENTER WAY BILL NUMBER & DATE' TYPE 'E'.
*      ENDIF.
*    ENDIF.
*  ENDIF.

  CALL FUNCTION 'Z_SPELL_AMOUNT_INDIA'
    EXPORTING
*     AMOUNT   = ZTOTAXVAL1
      amount   = t2tval
      language = sy-langu
    IMPORTING
      in_words = wor.

  WRITE wor-word TO netword1-word.
  SHIFT netword1-word LEFT DELETING LEADING space.
  SHIFT netword1-word LEFT DELETING LEADING '0'.
  SHIFT netword1-word LEFT DELETING LEADING '#'.
  SHIFT netword1-word LEFT DELETING LEADING space(1).

  IF ztotrtamt1 GT 0.
    CALL FUNCTION 'Z_SPELL_AMOUNT_INDIA'
      EXPORTING
*       AMOUNT   = ZTOTRTAMT1
        amount   = ttax
        language = sy-langu
      IMPORTING
        in_words = wor.
    WRITE wor-word TO netword2-word.
    SHIFT netword2-word LEFT DELETING LEADING space.
    SHIFT netword2-word LEFT DELETING LEADING '0'.
    SHIFT netword2-word LEFT DELETING LEADING '#'.
    SHIFT netword2-word LEFT DELETING LEADING space(1).

  ELSE.
    WRITE 'ZERO' TO netword2-word.
  ENDIF.

  IF ztottcs GT 0.
    CALL FUNCTION 'Z_SPELL_AMOUNT_INDIA'
      EXPORTING
        amount   = ztottcs1
        language = sy-langu
      IMPORTING
        in_words = wor.
    WRITE wor-word TO netword3-word.
    SHIFT netword3-word LEFT DELETING LEADING space.
    SHIFT netword3-word LEFT DELETING LEADING '0'.
    SHIFT netword3-word LEFT DELETING LEADING '#'.
    SHIFT netword3-word LEFT DELETING LEADING space(1).

  ELSE.
    WRITE 'ZERO' TO netword3-word.
  ENDIF.

******* manufacturer*************
  IF it_tab1 IS NOT INITIAL.
    SELECT * FROM mch1 INTO TABLE it_mcha FOR ALL ENTRIES IN it_tab1 WHERE charg EQ it_tab1-charg.
    SELECT * FROM mkpf INTO TABLE it_mkpf FOR ALL ENTRIES IN it_mcha WHERE budat EQ it_mcha-lwedt.
    IF sy-subrc EQ 0.
      SELECT * FROM mseg INTO TABLE it_mseg FOR ALL ENTRIES IN it_mkpf WHERE mblnr EQ it_mkpf-mblnr AND mjahr EQ it_mkpf-mjahr.
*            charg eq it_tab1-charg and bwart eq '101' and lifnr ne space and sgtxt ne space..
      IF sy-subrc EQ 0.
        SELECT * FROM ekko INTO TABLE it_ekko FOR ALL ENTRIES IN it_mseg WHERE ebeln = it_mseg-ebeln AND bsart NE 'ZUB'.
      ENDIF.
    ENDIF.
  ENDIF.
  LOOP AT it_tab1 INTO wa_tab1.
    LOOP AT it_ekko INTO wa_ekko.
      READ TABLE it_mseg INTO wa_mseg WITH KEY charg = wa_tab1-charg ebeln = wa_ekko-ebeln.
      IF sy-subrc EQ 0.
        wa_tap1-charg = wa_mseg-charg.
        wa_tap1-sgtxt = wa_mseg-sgtxt.
        COLLECT wa_tap1 INTO it_tap1.
        CLEAR wa_tap1.
        EXIT.
      ENDIF.
    ENDLOOP.
  ENDLOOP.
***********************************

  LOOP AT it_tab1 INTO wa_tab1.
*    write : / 'a',wa_tab1-charg.
    READ TABLE it_tap1 INTO wa_tap1 WITH KEY charg = wa_tab1-charg.
    IF sy-subrc EQ 0.
      wa_tab1-sgtxt = wa_tap1-sgtxt.
    ENDIF.


    wa_rm1-sr =  wa_tab1-sr.
    wa_rm1-j_1ichid =  wa_tab1-j_1ichid.
    wa_rm1-arktx =   wa_tab1-arktx.
    wa_rm1-licha =   wa_tab1-licha.
    wa_rm1-rmfkimg = wa_tab1-rmfkimg.
    wa_rm1-vrkme =   wa_tab1-vrkme.
    wa_rm1-zrms =  wa_tab1-zrms.
    wa_rm1-value = wa_tab1-value.
    wa_rm1-josg_rt = wa_tab1-josg_rt.
    wa_rm1-josg_amt = wa_tab1-josg_amt.
    wa_rm1-jocg_rt = wa_tab1-jocg_rt.
    wa_rm1-jocg_amt = wa_tab1-jocg_amt.
    wa_rm1-joig_rt = wa_tab1-joig_rt.
    wa_rm1-joig_amt = wa_tab1-joig_amt.
    wa_rm1-tottax = wa_tab1-tottax.
    wa_rm1-totva = wa_tab1-totva.
    COLLECT wa_rm1 INTO it_rm1.

    IF wa_tab1-sgtxt NE space.
      wa_rm1-sr =  space.
      wa_rm1-j_1ichid =  space.
      wa_rm1-arktx = wa_tab1-sgtxt.
      wa_rm1-licha =   space.
      wa_rm1-rmfkimg = space.
      wa_rm1-vrkme =   space.
      wa_rm1-zrms =  space.
      wa_rm1-value = space.
      wa_rm1-josg_rt = space.
      wa_rm1-josg_amt = space.
      wa_rm1-jocg_rt = space.
      wa_rm1-jocg_amt = space.
      wa_rm1-joig_rt = space.
      wa_rm1-joig_amt = space.
      wa_rm1-tottax = space.
      wa_rm1-totva = space.
      APPEND wa_rm1 TO it_rm1.
    ENDIF.
    CLEAR wa_rm1.
  ENDLOOP.

  DATA : z_toted16 TYPE p DECIMALS 2.
  DATA : z_toted161 TYPE p DECIMALS 2.
  DATA : z_toted163 TYPE p DECIMALS 2.
  DATA : z_totval TYPE p DECIMALS 2.
  DATA : z_totalpts TYPE p DECIMALS 2.
  DATA : z_totalpts_1 TYPE i.
  DATA : z_totalval TYPE p DECIMALS 2.

  toted162 = toted16 + toted161 + toted163.
  z_toted16 = toted16.
  z_toted161 = toted161.
  z_toted163 = toted163.
  t_total = totval + tot_ed + tot_ed1 + tot_ed2.
*write : / t_total.

  totcase1 =   totalnocase +   totalnocase1.

*write : / toted162,'werght',z_btgew,'CASE',totcase1,totqty,totalval.

  toted162 = toted162.
  CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
    EXPORTING
      amt_in_num         = toted162
    IMPORTING
      amt_in_words       = words
    EXCEPTIONS
      data_type_mismatch = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
  ENDIF.
  CONCATENATE words 'ONLY' INTO spell-word SEPARATED BY space.

  z_totval = totval.
  z_totalpts_1 = totalpts.
  z_totalpts = z_totalpts_1.
  z_totalval = totalval.







ENDFORM.
