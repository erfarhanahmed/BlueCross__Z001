
REPORT zsd_sales_reg.
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&   Developer Name       :  Madhavi Wadekar                                           *
*&   Date of Development  :  05/09/25                                         *
*&   Program Type         :  Excutable                                 *
*&   Program Name         :  ZSD_SALES_REG                             *
*&   Transaction Code     :                                            *
*&   Technical Lead       :                                            *
*&   Functional Consultant :                                           *
*&   Description          :  Sales Register Report                     *
*&   Transport Request    :  DS4K900183                                         *
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*

TABLES : vbrk,vbrp.
TYPE-POOLS : slis.
DATA : lv_unit TYPE fkimg.
DATA : lv_unit1 TYPE fkimg.
TYPES : BEGIN OF ts_vbrk,
          vbeln     TYPE vbrk-vbeln,
          fkart     TYPE vbrk-fkart,
          fktyp     TYPE vbrk-fktyp,
          waerk     TYPE vbrk-waerk,
          vkorg     TYPE vbrk-vkorg,
          vtweg     TYPE vbrk-vtweg,
          knumv     TYPE vbrk-knumv,
          fkdat     TYPE vbrk-fkdat,
          gjahr     TYPE vbrk-gjahr,
          inco1     TYPE vbrk-inco1,
          regio     TYPE vbrk-regio,
          bukrs     TYPE vbrk-bukrs,
          netwr     TYPE vbrk-netwr,
          erdat     TYPE vbrk-erdat,
          kunag     TYPE vbrk-kunag,
          sfakn     TYPE vbrk-sfakn,
          spart     TYPE vbrk-spart,
          xblnr     TYPE vbrk-xblnr,
          mwsbk     TYPE vbrk-mwsbk,
          fksto     TYPE vbrk-fksto,
          bupla     TYPE vbrk-bupla,
          vf_status TYPE vbrk-vf_status,
          buchk     TYPE vbrk-buchk,
          vbtyp     TYPE vbrk-vbtyp,
          zterm     TYPE vbrk-zterm,
          zuonr     TYPE ordnr_v,
          kurrf     TYPE vbrk-kurrf,
          belnr     TYPE vbrk-belnr,
          rfbsk     TYPE vbrk-rfbsk,
        END OF ts_vbrk.
TYPES : BEGIN OF ts_vbrp,
          vbeln      TYPE vbrp-vbeln,
          posnr      TYPE vbrp-posnr,
          fkimg      TYPE vbrp-fkimg,
          ntgew      TYPE vbrp-ntgew,
          netwr      TYPE vbrp-netwr,
          vgbel      TYPE vbrp-vgbel,
          vgpos      TYPE vbrp-vgpos,
          aubel      TYPE vbrp-aubel,
          aupos      TYPE vbrp-aupos,
          matnr      TYPE vbrp-matnr,
          charg      TYPE vbrp-charg,
          pstyv      TYPE vbrp-pstyv,
          spart      TYPE vbrp-spart,
          werks      TYPE vbrp-werks,
          vkgrp      TYPE vbrp-vkgrp,
          vkbur      TYPE vbrp-vkbur,
          kzwi1      TYPE vbrp-kzwi1,
          kzwi2      TYPE vbrp-kzwi2,
          kzwi3      TYPE vbrp-kzwi3,
          kzwi4      TYPE vbrp-kzwi4,
          prctr      TYPE vbrp-prctr,
          vkorg_auft TYPE vbrp-vkorg_auft,
          vtweg_auft TYPE vbrp-vtweg_auft,
          bzirk_auft TYPE vbrp-bzirk_auft,
          meins      TYPE meins,
          fklmg      TYPE vbrp-fklmg,
          prodh      TYPE vbrp-prodh,
          ernam      TYPE vbrp-ernam,
          arktx      TYPE vbrp-arktx,
          vrkme      TYPE vbrp-vrkme,
          umvkz      TYPE vbrp-umvkz,
          umvkn      TYPE vbrp-umvkn,
          mvgr1      TYPE vbrp-mvgr1,
        END OF ts_vbrp.

TYPES : BEGIN OF ts_kna1,
          kunnr  TYPE kna1-kunnr,
          land1  TYPE kna1-land1,
          name1  TYPE kna1-name1,
          name2  TYPE kna1-name2,
          name3  TYPE kna1-name3,
          name4  TYPE kna1-name4,
          regio  TYPE kna1-regio,
          stcd3  TYPE kna1-stcd3,
          pan_no TYPE kna1-j_1ipanno,
        END OF ts_kna1.

TYPES : BEGIN OF ts_prcd_elements,
          knumv TYPE prcd_elements-knumv,
          kposn TYPE prcd_elements-kposn,
          kschl TYPE prcd_elements-kschl,
          krech TYPE prcd_elements-krech,
          kawrt TYPE prcd_elements-kawrt,
          kbetr TYPE prcd_elements-kbetr,
          waers TYPE prcd_elements-waers,
          knumh TYPE prcd_elements-knumh,
          mwsk2 TYPE prcd_elements-mwsk2,
          kwert TYPE prcd_elements-kwert,
        END OF ts_prcd_elements.
TYPES : BEGIN OF ts_prcd_elements1,
          knumv TYPE prcd_elements-knumv,
          kposn TYPE prcd_elements-kposn,
          kschl TYPE prcd_elements-kschl,
          kwert TYPE prcd_elements-kwert,
        END OF ts_prcd_elements1.


TYPES : BEGIN OF ty_vbfa,
          vbeln   TYPE vbfa-vbeln,
          vbtyp_v TYPE vbfa-vbtyp_v,
          vbelv   TYPE vbfa-vbelv,
        END OF ty_vbfa.

TYPES : BEGIN OF ty_vbkd,
          vbeln TYPE vbkd-vbeln,
          bstkd TYPE vbkd-bstkd,
          bstdk TYPE vbkd-bstdk,
        END OF ty_vbkd.

TYPES : BEGIN OF ty_mch1,
          matnr TYPE mch1-matnr,
          charg TYPE mch1-charg,
          hsdat TYPE mch1-hsdat,
          vfdat TYPE mch1-vfdat,
        END OF ty_mch1.

TYPES : BEGIN OF ty_vbpa,
          vbeln TYPE vbpa-vbeln,
          parvw TYPE vbpa-parvw,
          kunnr TYPE vbpa-kunnr,
          lifnr TYPE vbpa-lifnr,
        END OF ty_vbpa.

TYPES : BEGIN OF ty_adrc,
          name1 TYPE adrc-name1,
          adrnr TYPE adrc-addrnumber,
        END OF ty_adrc.

TYPES : BEGIN OF ty_prd,
          knumv TYPE prcd_elements-knumv,
          kposn TYPE kposn,
          kschl TYPE prcd_elements-kschl,
          kbetr TYPE prcd_elements-kbetr,
          kwert TYPE prcd_elements-kwert,
        END OF ty_prd.
TYPES : BEGIN OF ty_kna1,
          kunnr TYPE kna1-kunnr,
          name1 TYPE kna1-name1,
        END OF ty_kna1.

"START OF ADDITION ABAP01

TYPES : BEGIN OF ty_knvp,
          kunnr TYPE knvp-kunnr,
          parvw TYPE knvp-parvw,
          pernr TYPE knvp-pernr,
        END OF ty_knvp.

"END OF ADDITON ABAP01

TYPES : BEGIN OF ty_lfa1,
          lifnr TYPE lfa1-lifnr,
          name1 TYPE lfa1-name1,
        END OF ty_lfa1.

TYPES : BEGIN OF ty_vbak_d,
          vbeln TYPE vbeln_va,
          bstnk TYPE bstnk,
          bstdk	TYPE datum,
        END OF ty_vbak_d.

TYPES : BEGIN OF ty_bkpf,
          belnr TYPE belnr_d,
          kursf TYPE kursf,
        END OF ty_bkpf.

DATA : lt_bkpf TYPE STANDARD TABLE OF ty_bkpf,
       la_bkpf TYPE ty_bkpf.
DATA : it_vbak_d TYPE STANDARD TABLE OF ty_vbak_d,
       wa_vbak_d TYPE ty_vbak_d.

DATA : it_lfa1 TYPE STANDARD TABLE OF ty_lfa1,
       wa_lfa1 TYPE ty_lfa1.
DATA : it_kna1_d TYPE STANDARD TABLE OF ty_kna1,
       wa_kna1_d TYPE ty_kna1.

"START OF ABAP01 ADDITION
DATA : it_knvp TYPE STANDARD TABLE OF ty_knvp,
       wa_knvp TYPE ty_knvp.
"END OF ABAP01 ADDITION
DATA : it_prd
       TYPE STANDARD TABLE OF ty_prd,
       wa_prd TYPE ty_prd.
DATA : it_adrc TYPE STANDARD TABLE OF ty_adrc,
       wa_adrc TYPE ty_adrc.

DATA : it_vbpa     TYPE STANDARD TABLE OF ty_vbpa,
       it_vbpa_tmp TYPE STANDARD TABLE OF ty_vbpa,
       wa_vbpa     TYPE ty_vbpa,
       it_vbfa     TYPE STANDARD TABLE OF ty_vbfa,
       it_vbkd     TYPE STANDARD TABLE OF ty_vbkd,
       wa_vbfa     TYPE ty_vbfa,
       wa_vbkd     TYPE ty_vbkd,
       it_mch1     TYPE STANDARD TABLE OF ty_mch1,
       wa_mch1     TYPE ty_mch1,
       it_line_d   TYPE STANDARD TABLE OF tline.

DATA obj TYPE REF TO zcl_get_einvoice_details.
CREATE OBJECT obj.
DATA im_inv_num  TYPE edocument-source_key.
DATA : e_edoineinv  TYPE  edoineinv.
DATA : e_edoinewb  TYPE  edoinewb.


TYPES:BEGIN OF ty_ekko,
        ebeln TYPE ekko-ebeln,
        knumv TYPE ekko-knumv,
      END OF ty_ekko.


TYPES : BEGIN OF ts_final,
          vbeln         TYPE vbrk-vbeln,
          irn           TYPE j_1ig_irn,
          erdat         TYPE erdat,
          ewbno         TYPE string,
          ewbdt         TYPE datum, "ZEWBDT,
          fkart         TYPE vbrk-fkart,
          fktyp         TYPE vbrk-fktyp,
          waerk         TYPE vbrk-waerk,
          vkorg         TYPE vbrk-vkorg,
          vtweg         TYPE vbrk-vtweg,
          knumv         TYPE vbrk-knumv,
          fkdat         TYPE vbrk-fkdat,
          bukrs         TYPE vbrk-bukrs,
          netwr         TYPE vbrk-netwr,
          netwr1        TYPE vbrk-netwr,
          kunag         TYPE vbrk-kunag,
          spart         TYPE vbrk-spart,
          xblnr         TYPE vbrk-xblnr,
          mwsbk         TYPE vbrk-mwsbk,
          bupla         TYPE vbrk-bupla,
          posnr         TYPE vbrp-posnr,
          fkimg         TYPE vbrp-fkimg,
          ntgew         TYPE vbrp-ntgew,
          vgbel         TYPE vbrp-vgbel,
          matnr         TYPE vbrp-matnr,
          matkl         TYPE mara-matkl,
          matkl_d       TYPE t023t-wgbez,
          extwg         TYPE mara-extwg,
          ewbez         TYPE twewt-ewbez,
          maktx         TYPE makt-maktx,
          charg         TYPE vbrp-charg,
          pstyv         TYPE vbrp-pstyv,
          werks         TYPE vbrp-werks,
          vkgrp         TYPE vbrp-vkgrp,
          vkbur         TYPE vbrp-vkbur,
          kzwi3         TYPE vbrp-kzwi3,
          kzwi4         TYPE vbrp-kzwi4,
          bzirk_auft    TYPE vbrp-bzirk_auft,
          kunnr         TYPE kna1-kunnr,
          name1(70)     TYPE c,  "kna1-name1,   "Customer Name
          regio         TYPE kna1-regio,
          stcd3         TYPE kna1-stcd3,
          gstin         TYPE j_1bbranch-gstin,
          bztxt         TYPE t171t-bztxt,
          invvalue      TYPE vbrp-netwr,
          steuc         TYPE marc-steuc,
          prsfd         TYPE tvap-prsfd,
          billqty       TYPE vbrp-fkimg,
          freeqty       TYPE vbrp-fkimg,
          prdctrate     TYPE prcd_elements-kbetr,
          ptr           TYPE prcd_elements-kbetr,
          mrp           TYPE string,
          " PTS           TYPE PRCD_ELEMENTS-KBETR,
          pts           TYPE string,
          grossamt      TYPE vbrp-netwr, "prcd_elements-kbetr,
          strdiscnt     TYPE prcd_elements-kbetr,
          strdiscnt1    TYPE prcd_elements-kbetr,
          cashdiscnt    TYPE vbrp-netwr, "prcd_elements-kbetr,
          cashdiscnt_d  TYPE prcd_elements-kbetr,
          cgstrate      TYPE prcd_elements-kbetr,
          sgstrate      TYPE prcd_elements-kbetr,
          igstrate      TYPE prcd_elements-kbetr,
          cgstvalue     TYPE prcd_elements-kbetr,
          sgstvalue     TYPE prcd_elements-kbetr,
          igstvalue     TYPE prcd_elements-kbetr,
          tdsvalue      TYPE  prcd_elements-kbetr,
          roundoff      TYPE vbrp-kzwi3,
          bstkd         TYPE vbkd-bstkd,      "Buyer's Order No.
          bstdk1        TYPE vbkd-bstdk,      "Buyer's Order Date
          stp_gstno     TYPE kna1-stcd3,      "Shipt to Party GST No.
          stp_code      TYPE kunnr,
          stp_name(70)  TYPE c,
          btp_code      TYPE kunnr,
          btp_name(70)  TYPE c,
          btp_gstno     TYPE kna1-stcd3,      "Bill to Party GST No.
          trns_name     TYPE lfa1-name1,       "Transporter Name
          lia_name      TYPE lfa1-name1,       "Liasoning Agent Name "
          lir_name      TYPE prcd_elements-kwert, "Liasoner Commision "
          lrno          TYPE tdline,           "LR No.
          lrdate        TYPE sy-datum,           "LR Date
          vtext         TYPE tvkot-vtext,
          vtext1        TYPE tvtwt-vtext,
          vtext2        TYPE tspat-vtext,
          locname       TYPE t001w-name1,
          vtext3        TYPE tvfkt-vtext,
          aubel         TYPE vbrp-aubel,        "Sales Order No.
          audat         TYPE vbak-audat,        "Sales Order Date
          wadat_ist     TYPE likp-wadat_ist,    "Delivery Note Date*

          sfakn         TYPE vbrk-sfakn,         "REVERSE IINVOICE
          reverse_date  TYPE vbrk-fkdat,      ""REVERSE DATE
          ktgrm         TYPE mvke-ktgrm,        "ACCNT ASSIGNMENT GRP
          mvgr1         TYPE mvke-mvgr1,      "" Added by pavan 19.12.2023
          vtext4        TYPE tvkmt-vtext,
          vtext5        TYPE tvkbt-bezei,
          vtext6        TYPE tvgrt-bezei,
          targetrate    TYPE prcd_elements-kbetr,
          targetvalue   TYPE prcd_elements-kbetr,
          targetamount  TYPE prcd_elements-kbetr,
          kwert         TYPE prcd_elements-kwert,
          prctr         TYPE vbrp-prctr,
          pan_no        TYPE kna1-j_1ipanno,
*          zgstr         TYPE zgst_region_map-zgstr,
          zgstr         TYPE regio,
          bezei         TYPE zgst_region_map-bezei,
          landx         TYPE t005t-landx,            "Country
          vf_status     TYPE dd07d-ddtext,           "Invoicing Status
          buchk         TYPE dd07d-ddtext,           "Posting Status
          inco1         TYPE vbrk-inco1,
          inco1_d       TYPE  tinct-bezei,
          kdgrp         TYPE knvv-kdgrp,
          ktext         TYPE t151t-ktext,             "Customer Group
          bstnk         TYPE vbak-bstnk,             "Customer Reference No.
          bstdk         TYPE vbak-bstdk,             "Customer Reference Date
          trv_rate      TYPE prcd_elements-kbetr,    "TRV Rate
          quotation     TYPE vbfa-vbelv,             "Quotation
          contract      TYPE vbfa-vbelv,             "Contract
          genmtxt       TYPE string,                 "Generic Material Text
          pgroup        TYPE bezei20,            "Price Group
          cgrp1         TYPE bezei20,            "Customer Group 1
          kvgr1         TYPE vbak-kvgr1,
          lir_com       TYPE prcd_elements-kbetr, "Liasoner Commission %
          zterm         TYPE tvzbt-vtext,          "Payment Terms
          duedt         TYPE vbrk-fkdat,           "Due Date
          vfdat         TYPE mcha-vfdat,         "Expiry Date for Batch
          zuonr         TYPE ordnr_v,
          inv_r         TYPE bkpf-xblnr,        "Reference Invoice no.
          gl_no         TYPE prcd_elements-sakn1, "BSEG-HKONT,             "G/L NO
          gl_descp      TYPE skat-txt50,           "G/L Description
          ref_invd      TYPE bkpf-bldat,           " Reference Invoice Date
          rfbsk         TYPE vbrk-rfbsk,
          bstnk_d       TYPE bstnk,
          bstdk_d	      TYPE datum,
          hsdat         TYPE mch1-hsdat,                  "MFG date.
          vfdat1        TYPE mch1-vfdat,                  "EXP date
          mat_text      TYPE char100,
          port_code     TYPE adrc-name1,
          trns_name1    TYPE adrc-name1,
          veh_no        TYPE char100,
          gst_rate      TYPE prcd_elements-kwert, "p DECIMALS 2,
          rate          TYPE prcd_elements-kwert,
          rate1         TYPE prcd_elements-kwert,
          "FREIGHT_AMT   TYPE PRCD_ELEMENTS-KWERT,  "Freight amount.
          freight_amt   TYPE string,  "Freight amount.
          "INSURANCE_AMT TYPE PRCD_ELEMENTS-KWERT,  "Freight amount.
          insurance_amt TYPE string,  "Freight amount.
          ship_bil_no   TYPE char20,
          ship_bil_date TYPE datum,
          manufracturer TYPE char100,
          amount        TYPE kwert,
          meins         TYPE meins,      " Base Unit of Measure
          con_fact      TYPE netwr,
          sales_inr     TYPE netwr,
          igst_inr      TYPE vfprc_element_amount,
          tcs_base      TYPE vfprc_element_value,
          tcs_rate      TYPE vfprc_element_amount,
          tcs_amount    TYPE vfprc_element_value,
          state         TYPE char6,
          ename         TYPE pa0001-ename,
          sales_agent   TYPE kna1-name1,   "added by surabhi 05.02.2023
          kurrf         TYPE vbrk-kurrf,
          prodh         TYPE vbrp-prodh,
          prodh_d1      TYPE t179t-vtext,
          prodh_d2      TYPE t179t-vtext,
          prodh_d3      TYPE t179t-vtext,
          lfmng         TYPE string,
          pcip          TYPE netwr,
          pcip_v        TYPE netwr,
          cogs          TYPE netwr,
          cogs_v        TYPE netwr,
          ernam         TYPE vbrk-ernam,
          vrkme         TYPE vbrp-vrkme,
          cogspr        TYPE p DECIMALS 2,
          ppcip         TYPE netwr,
          std_val       TYPE netwr,
          abc_ind       TYPE marc-maabc,
          abc_dind      TYPE string,
          zpr0          TYPE netwr,
          zdip          TYPE netwr,
          zrdf          TYPE netwr,
*          PACK_SIZE     TYPE MVKE-SCMNG,
          item_sale     TYPE netwr,
          item_sale1    TYPE netwr,
          base_qty      TYPE netwr,
          base_umo      TYPE vbrp-meins,
          city          TYPE adrc-city1,                    "Added By MayurB 12/07/23  <DS4K905313>
          industry_cd   TYPE but0is-ind_sector,             "Added By MayurB 12/07/23  <DS4K905313>
          industry_dscr TYPE char20,                        "Added By MayurB 12/07/23  <DS4K905313>
*          MVGR11         TYPE vbrp-MVGR1,
          bezei1        TYPE tvm1t-bezei,
          miro(20)      TYPE c,
          uename        TYPE pa0001-sname, "ADDTION OF ABAP01
          z022          TYPE char10, "ADDTION OF ABAP01 01-09-2025
          z023          TYPE char10, "ADDTION OF ABAP01 01-09-2025
          zjt           TYPE string,
          special       TYPE string,
          hospi         TYPE string,
          ret           TYPE string,
          stock         TYPE string,
          belnr         TYPE vbrk-belnr,
          batch         TYPE vbrp-charg,
          ref_doc       TYPE vbrp-vgbel,
        END OF ts_final.
DATA :
  locname TYPE t001w-name1,
  steuc   TYPE marc-steuc,
  maabc   TYPE marc-maabc,
  prsfd   TYPE tvap-prsfd.
DATA : it_vbrk            TYPE TABLE OF ts_vbrk,
       it_vbrk1           TYPE TABLE OF ts_vbrk,
       wa_vbrk            TYPE ts_vbrk,
       it_vbrp            TYPE TABLE OF ts_vbrp,
       wa_vbrp            TYPE ts_vbrp,
       it_kna1            TYPE TABLE OF ts_kna1,
       wa_kna1            TYPE ts_kna1,
       it_konv            TYPE TABLE OF ts_prcd_elements,
       wa_konv            TYPE ts_prcd_elements,
       it_final           TYPE TABLE OF ts_final,
       wa_final           TYPE ts_final,
       it_ekko            TYPE TABLE OF ty_ekko,
       wa_ekko            TYPE ty_ekko,
       it_prcd            TYPE TABLE OF  ts_prcd_elements1,
       wa_prcd            TYPE  ts_prcd_elements1,
*       it_zgst_region_map TYPE TABLE OF zgst_region_map,
*       wa_zgst_region_map TYPE zgst_region_map,
       it_zgst_region_map TYPE TABLE OF j_1istatecdm,
       wa_zgst_region_map TYPE j_1istatecdm,
       it_lines           TYPE /osp/tt_tline,
       wa_lines           TYPE tline,
       it_taba            TYPE STANDARD TABLE OF dd07v,
       it_tabb            TYPE STANDARD TABLE OF dd07v,
       wa_bseg            TYPE bseg,
       it_bseg            TYPE TABLE OF bseg,
       wa_bkpf            TYPE bkpf,
       it_bkpf            TYPE TABLE OF bkpf,
       wa_skat            TYPE skat,
       it_skat            TYPE TABLE OF skat.

DATA :e_j_1ig_invrefnum TYPE  j_1ig_invrefnum.
DATA :wa_ztransp_d  TYPE  ztransp_d.


DATA: it_fieldcat TYPE slis_t_fieldcat_alv,
      wa_fieldcat TYPE slis_fieldcat_alv.
DATA : wa_layout TYPE slis_layout_alv .
DATA : lv_lrno          TYPE tdline,       "Local Variable for LR No.
       lv_lrdt          TYPE tdline,       "Local Variable for LR Date
       veh_no           TYPE tdline,       "Local Variable for LR Date
       lv_genmtxt(255)  TYPE c,    "Local Variable for Generic Material Text
       lv_cust_name(70) TYPE c,
       lv_awkey         TYPE tdobname,    "Local Variable for TDNAME
       lv_time          TYPE dlydy,   "Local Variable for time in days
       lv_fkdat         TYPE sy-datum,       "Local Variable for billing date
       tknum            TYPE vttp-tknum.

DATA: lv_repid TYPE sy-repid.

DATA:wa_vbap  TYPE vbap,
     it_vbap  TYPE TABLE OF vbap,
     wa_bkpf1 TYPE bkpf,
     it_bkpf1 TYPE TABLE OF bkpf.

DATA:it_glc TYPE TABLE OF prcd_elements,
     wa_glc TYPE prcd_elements,
     it_gld TYPE TABLE OF skat,
     wa_gld TYPE skat.

DATA : lv_werks TYPE werks_d.
DATA : lv_parva TYPE usr05-parva.
DATA : lv_plant TYPE string.
DATA: repname    LIKE sy-repid,
      g_save(1)  TYPE c,
      g_exit(1)  TYPE c,
      g_variant  LIKE disvariant,
      gx_variant LIKE disvariant.

DATA: bdcdata       LIKE bdcdata OCCURS 0 WITH HEADER LINE,
      wa_ctu_params TYPE ctu_params,
      it_msg        TYPE TABLE OF bdcmsgcoll,
      wa_msg        TYPE bdcmsgcoll,
      w_msg         TYPE bdcmsgcoll.
TYPES : BEGIN OF ty_prcd,
          knumv TYPE prcd_elements-knumv,
          kschl TYPE prcd_elements-kschl,
          kbetr TYPE kbetr,
          kwert TYPE prcd_elements-kwert,
          waers TYPE prcd_elements-waers,
          kawrt TYPE kawrt,
        END OF ty_prcd,
        tt_prcd TYPE  STANDARD TABLE OF ty_prcd.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-054.
  SELECT-OPTIONS: s_vkorg FOR vbrk-vkorg OBLIGATORY ,
                  s_vtweg FOR vbrk-vtweg ,"OBLIGATORY, "commented by surabhi 02.06.2023
                  s_spart FOR vbrk-spart,
                  s_fkart FOR vbrk-fkart," OBLIGATORY,
                  s_werks FOR vbrp-werks ,
                  s_vbeln FOR vbrk-vbeln,
                  s_xblnr FOR vbrk-belnr,
                  s_fkdat FOR vbrk-fkdat , "OBLIGATORY,
                  s_matnr FOR vbrp-matnr,
                  s_vkbur FOR vbrp-vkbur,
                  s_kunag FOR vbrk-kunag,
                  s_erdat FOR vbrk-erdat.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-004.
  PARAMETERS: r1 RADIOBUTTON GROUP abc,
              r2 RADIOBUTTON GROUP abc,
              r3 RADIOBUTTON GROUP abc.   ""Added by Sanjay Func-Tejas 20.07.2023
SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-120.
  PARAMETERS:
         p_vari LIKE disvariant-variant . "User Layout
SELECTION-SCREEN END OF BLOCK b2.

INITIALIZATION.
  repname = sy-repid.
  PERFORM initialize_variant.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_vari.
  PERFORM f4_for_variant.

AT SELECTION-SCREEN.
  IF sy-tcode = 'ZFI005N'.
    sy-title = 'Sales Register Report_Actual COGS'.
  ENDIF.
  PERFORM pai_of_selection_screen.

  SELECT SINGLE parva INTO lv_parva FROM usr05
    WHERE bname = sy-uname
  AND  parid = 'ZSD_CNF'.
  IF lv_parva = 'X'.
    IF lv_werks NE s_werks-low.
      CONCATENATE  TEXT-060 s_werks-low TEXT-061  INTO lv_plant SEPARATED BY space.
      MESSAGE lv_plant TYPE 'E'.
      STOP.
    ENDIF.
  ENDIF.

START-OF-SELECTION.

  PERFORM fetch_data.
  PERFORM loop_data1.
  PERFORM fieldcat1.
  PERFORM display.

*&---------------------------------------------------------------------*
*& Form FETCH_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM fetch_data .
  IF r3 NE 'X'. "" Added By sanjay func-bhim 29.06.2023

    LOOP AT s_fkart ASSIGNING FIELD-SYMBOL(<lfs_fkart>).
      IF <lfs_fkart>-low EQ 'ZS1' OR
         <lfs_fkart>-low EQ 'ZS2' OR
         <lfs_fkart>-low EQ 'S1' OR
         <lfs_fkart>-low EQ 'S2'.
        CLEAR:<lfs_fkart>-low.
      ELSEIF <lfs_fkart>-high EQ 'ZS1' OR
             <lfs_fkart>-high EQ 'ZS2' OR
             <lfs_fkart>-high EQ 'S1' OR
             <lfs_fkart>-high EQ 'S2'.
        CLEAR:<lfs_fkart>-high.
      ENDIF.
    ENDLOOP.

  ENDIF.
  SELECT  vbeln
          fkart
          fktyp
          waerk
          vkorg
          vtweg
          knumv
          fkdat
          gjahr
          inco1
          regio
          bukrs
          netwr
          erdat
          kunag
          sfakn
          spart
          xblnr
          mwsbk
          fksto
          bupla
          vf_status
          buchk
          vbtyp
          zterm
          zuonr
          kurrf
          belnr
          rfbsk
  FROM vbrk INTO TABLE it_vbrk
    WHERE vbeln IN s_vbeln
       "AND XBLNR IN S_XBLNR
       AND belnr IN s_xblnr
       AND fkart IN s_fkart    "  billing type
       AND vkorg IN s_vkorg    "  sales org
       AND vtweg IN s_vtweg    "  distribution channel
       AND fkdat IN s_fkdat
       AND spart IN s_spart
       AND kunag IN s_kunag
*       AND RFBSK NE ' '
  AND erdat IN s_erdat.
  it_vbrk1[] = it_vbrk[].
  IF r1 = 'X'. ""Display Only Completed Invoices
    DELETE it_vbrk WHERE rfbsk = 'E'.
    DELETE it_vbrk WHERE fksto = 'X'.
  ELSEIF r2 = 'X'. "" Display Only Cancelled Invoices
    DELETE it_vbrk1 WHERE fksto NE 'X'.
    DELETE it_vbrk WHERE rfbsk NE 'E'.
    APPEND LINES OF it_vbrk1 TO it_vbrk.
    DELETE ADJACENT DUPLICATES FROM it_vbrk COMPARING vbeln.
  ELSEIF r3 = 'X'.""Added by Sanjay Func-Tejas 20.07.2023
***** Display All invoices.
    DELETE it_vbrk WHERE vbtyp = 'U'.
*    ENDIF.
  ENDIF.

  IF it_vbrk IS NOT INITIAL.
    IF r3 NE 'X'.
      DELETE it_vbrk WHERE fkart = 'ZS1' OR fkart = 'ZS2' OR fkart = 'S1' OR fkart = 'S2 ' OR fkart = 'S3' OR fkart = 'ZPF'.
    ENDIF.


    IF it_vbrk IS NOT INITIAL.
      SELECT   vbeln
               posnr
               fkimg
               ntgew
               netwr
               vgbel
               vgpos
               aubel
               aupos
               matnr
               charg
               pstyv
               spart
               werks
               vkgrp
               vkbur
               kzwi1
               kzwi2
               kzwi3
               kzwi4
               prctr
               vkorg_auft
               vtweg_auft
               bzirk_auft
               meins
               fklmg
               prodh
               ernam
               arktx
               vrkme
               umvkz
               umvkn
        FROM vbrp
        INTO TABLE it_vbrp
        FOR ALL ENTRIES IN it_vbrk
        WHERE vbeln = it_vbrk-vbeln
      AND fkimg NE 0
      AND  matnr IN s_matnr
      AND werks IN s_werks
      AND  vkbur IN s_vkbur.
    ENDIF.
  ENDIF.

  SORT it_vbrp BY vbeln.
  IF it_vbrp IS NOT INITIAL.



    SELECT ebeln
           knumv
           FROM ekko
           INTO TABLE it_ekko
           FOR ALL ENTRIES IN it_vbrp
    WHERE ebeln = it_vbrp-aubel.
    SELECT vbeln
           posnr
           vgbel
       FROM vbap INTO CORRESPONDING FIELDS OF TABLE it_vbap
      FOR ALL ENTRIES IN it_vbrp
      WHERE vbeln = it_vbrp-aubel AND
    posnr = it_vbrp-aupos.

    SELECT * FROM  bkpf INTO TABLE it_bkpf1
     FOR ALL ENTRIES IN it_vbap
    WHERE belnr = it_vbap-vgbel.
********************   EOC ***********

  ENDIF.
  SORT it_ekko BY ebeln."ck

  IF it_ekko IS NOT INITIAL.
    SELECT knumv
           kposn
           kschl
           kwert
           FROM prcd_elements
           INTO TABLE it_prcd
           FOR ALL ENTRIES IN it_ekko
           WHERE knumv = it_ekko-knumv
           AND kposn = '0'
    AND kschl = 'ZSF2'.

  ENDIF.

  IF it_vbrk IS NOT INITIAL.
    SELECT  kunnr
            land1
            name1
            name2
            name3
            name4
            regio
            stcd3
            j_1ipanno
    FROM kna1 INTO TABLE it_kna1
      FOR ALL ENTRIES IN it_vbrk
    WHERE kunnr = it_vbrk-kunag.

    IF it_kna1 IS NOT INITIAL.
      SELECT * FROM j_1istatecdm
        INTO TABLE it_zgst_region_map
        FOR ALL ENTRIES IN it_kna1
        WHERE land1 = it_kna1-land1
      AND std_state_code = it_kna1-regio.
    ENDIF.
  ENDIF.

  "START OF ADDTION ABAP01
  SELECT kunnr
       parvw
       pernr
       FROM knvp
       INTO TABLE it_knvp
    FOR ALL ENTRIES IN it_vbrk
    WHERE kunnr = it_vbrk-kunag
    AND vkorg = it_vbrk-vkorg
    AND vtweg = it_vbrk-vtweg
    AND spart = it_vbrk-spart
    AND parvw = 'VE'.

  IF sy-subrc = 0.
    DELETE ADJACENT DUPLICATES FROM it_knvp COMPARING ALL FIELDS.
    SORT it_knvp.
  ENDIF.
  "END OF ADDTION ABAP01.

  IF it_vbrk IS NOT INITIAL.
    SELECT knumv
           kposn
           kschl
           krech
           kawrt
           kbetr
           waers
           knumh
           mwsk2
           kwert
   FROM prcd_elements INTO TABLE it_konv
   FOR ALL ENTRIES IN it_vbrk
    WHERE knumv = it_vbrk-knumv.
  ENDIF.

  IF it_vbrk[] IS NOT INITIAL.

    SELECT belnr
           buzid
           hkont
      FROM bseg INTO CORRESPONDING FIELDS OF TABLE it_bseg
      FOR ALL ENTRIES IN it_vbrk
      WHERE belnr = it_vbrk-belnr AND
    buzid = 'R'.

    IF it_bseg[] IS NOT INITIAL.

      SELECT * FROM skat INTO TABLE it_skat
        FOR ALL ENTRIES IN it_bseg
        WHERE saknr = it_bseg-hkont AND
              ktopl = '1000' AND
      spras = 'EN'.

    ENDIF.

    SELECT belnr
           bldat
      FROM bkpf INTO CORRESPONDING FIELDS OF TABLE it_bkpf
      FOR ALL ENTRIES IN it_vbrk
    WHERE belnr = it_vbrk-belnr.

  ENDIF.
  IF it_vbrk[] IS NOT INITIAL.

    SELECT * FROM prcd_elements INTO TABLE it_glc
       FOR ALL ENTRIES IN it_vbrk
      WHERE knumv = it_vbrk-knumv AND
    kvsl1 = 'ERL'.
    DELETE it_glc WHERE sakn1 IS INITIAL. " added by surabhi 03.05.2023
    SELECT * FROM skat INTO TABLE it_gld
      FOR ALL ENTRIES IN it_glc
      WHERE saknr = it_glc-sakn1 AND
           ktopl = '1000' AND
    spras = 'EN'.
  ENDIF.

  IF it_vbrp IS NOT INITIAL.
    SELECT vbeln
           bstnk
           bstdk
      FROM vbak
      INTO TABLE it_vbak_d
      FOR ALL ENTRIES IN it_vbrp
    WHERE vbeln = it_vbrp-aubel.
  ENDIF.

  IF it_vbrp IS NOT INITIAL.
    SELECT matnr
           charg
           hsdat
           vfdat
      FROM mch1
      INTO TABLE it_mch1
      FOR ALL ENTRIES IN it_vbrp
      WHERE matnr = it_vbrp-matnr
    AND   charg = it_vbrp-charg.
  ENDIF.
  IF it_vbrp IS NOT INITIAL.
    SELECT vbeln
           parvw
           kunnr
      FROM vbpa
      INTO TABLE it_vbpa
      FOR ALL ENTRIES IN it_vbrp
      WHERE vbeln = it_vbrp-vbeln
    AND   ( parvw = 'ZP' OR  parvw = 'ZT' ).
    IF sy-subrc = 0 AND it_vbpa IS NOT INITIAL.
      it_vbpa_tmp = it_vbpa.
      SELECT  kunnr
              name1
        FROM kna1
        INTO TABLE it_kna1_d
        FOR ALL ENTRIES IN it_vbpa
      WHERE kunnr = it_vbpa-kunnr.

      "START OF ADDTION ABAP01
*       SELECT KUNNR
*       PARVW
*       PERNR
*       FROM KNVP
*       INTO TABLE IT_KNVP
*    FOR ALL ENTRIES IN IT_VBRK
*    WHERE KUNNR = IT_VBRK-KUNAG
*    AND VKORG = IT_VBRK-VKORG
*    AND SPART = IT_VBRK-SPART
*    AND PARVW = 'VE'.
      "END OF ADDTION ABAP01.

      SELECT lifnr
             name1
        FROM lfa1
        INTO TABLE it_lfa1
        FOR ALL ENTRIES IN it_vbpa
      WHERE lifnr = it_vbpa-lifnr.
    ENDIF.
  ENDIF.
  IF it_vbrk IS NOT INITIAL.
    SELECT knumv kposn kschl kbetr kwert
       FROM prcd_elements
       INTO TABLE it_prd
       FOR ALL ENTRIES IN it_vbrk
       WHERE knumv = it_vbrk-knumv.
*      AND kschl IN ( 'ZH00' , 'ZH01' , 'JOIG' , 'JOCG' , 'JOSG' , 'ZNET' , 'ZPAM' , 'PTS1' ,
*                     'ZSL1' , 'ZPLL' , 'ZCSP' , 'ZEXP' , 'ZDIS' , 'ZMRP' , 'ZDIM' , 'PTR1' ,
*                     'JTCB' , 'JTC1' , 'ZTCS' , 'ZPTS' , 'ZPAM' , 'ZRPM' , 'ZDOM' , 'ZAST' ,
*    'ZPVD' , 'ZPRD' , 'ZPLL' , 'ZDSP' , 'ZFRA' , 'ZINS' ).

  ENDIF.

  IF it_vbrp IS NOT INITIAL.

    SELECT belnr
           kursf
      FROM bkpf
      INTO TABLE lt_bkpf
      FOR ALL ENTRIES IN it_vbrp
    WHERE belnr = it_vbrp-vbeln.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form LOOP_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM loop_data .
  DATA: lv_prcd TYPE prcd_elements.
  DATA : lv_mrp TYPE string.
  IF it_vbrk IS NOT INITIAL.
    SELECT bukrs,branch,bupla_type,adrnr FROM j_1bbranch INTO TABLE @DATA(it_state)
    FOR ALL ENTRIES IN @it_vbrk WHERE bukrs = @it_vbrk-bukrs AND branch = @it_vbrk-bupla.
    IF sy-subrc  = 0.
      SELECT addrnumber,date_from,nation,region FROM adrc INTO TABLE @DATA(it_adr) FOR ALL ENTRIES IN
      @it_state WHERE addrnumber = @it_state-adrnr.
    ENDIF.

*    SELECT bukrs,docno,doc_year,doc_type,irn,erdat,ewbno,ewbdt FROM j_1ig_invrefnum INTO TABLE @DATA(it_irn) FOR ALL ENTRIES IN " commented by naga on 16-12-2022
    SELECT bukrs,docno,doc_year,doc_type,irn,erdat FROM j_1ig_invrefnum INTO TABLE @DATA(it_irn) FOR ALL ENTRIES IN
    @it_vbrk WHERE bukrs = @it_vbrk-bukrs AND docno =  @it_vbrk-vbeln AND doc_year =  @it_vbrk-gjahr AND doc_type =  @it_vbrk-fkart.
  ENDIF.

  LOOP AT it_vbrk INTO wa_vbrk.


    wa_final-vbeln  = wa_vbrk-vbeln.
    wa_final-kurrf  = wa_vbrk-kurrf.

    READ TABLE it_irn INTO DATA(wa_irn) WITH KEY bukrs = wa_vbrk-bukrs docno = wa_vbrk-vbeln doc_year = wa_vbrk-gjahr doc_type = wa_vbrk-fkart.
    IF sy-subrc = 0.
      wa_final-irn = wa_irn-irn.
      wa_final-erdat = wa_irn-erdat.
*      wa_final-ewbno = wa_irn-ewbno.
*      wa_final-ewbdt = wa_irn-ewbdt.
      CLEAR : wa_irn.
    ENDIF.

    wa_final-fkart = wa_vbrk-fkart.
    wa_final-fktyp = wa_vbrk-fktyp.
    wa_final-waerk = wa_vbrk-waerk.
    wa_final-vkorg = wa_vbrk-vkorg.
    wa_final-vtweg = wa_vbrk-vtweg.
    wa_final-fkdat = wa_vbrk-fkdat.
    IF wa_vbrk-vbtyp = 'N' OR wa_vbrk-vbtyp = 'O'.
      wa_final-netwr = wa_vbrk-netwr * -1.
      wa_final-netwr1 = wa_vbrk-netwr * -1.
    ELSE.
      wa_final-netwr = wa_vbrk-netwr.
      wa_final-netwr1 = wa_vbrk-netwr.
    ENDIF.
    IF wa_vbrk-waerk NE 'INR'.
      wa_final-netwr1 = wa_final-netwr1 * wa_vbrk-kurrf.
    ENDIF.
*    IF WA_VBRK-VBTYP = 'P' OR WA_VBRK-VBTYP = 'O' OR  WA_VBRK-VBTYP = 'ZCRM' OR  WA_VBRK-VBTYP = 'ZDRM'.
*      WA_FINAL-ZUONR = WA_VBRK-ZUONR.
*    ENDIF.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = wa_vbrk-kunag
      IMPORTING
        output = wa_final-kunag.

    wa_final-spart = wa_vbrk-spart.
    "WA_FINAL-XBLNR = WA_VBRK-XBLNR.
    wa_final-belnr = wa_vbrk-belnr.
    LOOP AT it_prd INTO wa_prd WHERE knumv = wa_vbrk-knumv.
      CASE wa_prd-kschl.
        WHEN 'JOIG' OR 'JOCG' OR 'JOSG'.
          wa_final-mwsbk = wa_final-mwsbk + wa_prd-kwert.
      ENDCASE.

    ENDLOOP.
    wa_final-bupla = wa_vbrk-bupla.
    wa_final-bukrs = wa_vbrk-bukrs.
    wa_final-sfakn = wa_vbrk-sfakn.
    IF wa_final-sfakn IS NOT INITIAL.
      SELECT SINGLE fkdat INTO  wa_final-reverse_date FROM vbrk WHERE vbeln = wa_vbrk-sfakn.
    ENDIF.
    SELECT SINGLE vtext FROM tvkot INTO wa_final-vtext WHERE spras = sy-langu
    AND vkorg = wa_final-vkorg.
    SELECT SINGLE vtext FROM tvtwt INTO wa_final-vtext1 WHERE spras = sy-langu
    AND vtweg = wa_final-vtweg.
    SELECT SINGLE vtext FROM tspat INTO wa_final-vtext2 WHERE spras = sy-langu
    AND spart = wa_final-spart.
    SELECT SINGLE vtext FROM tvfkt INTO wa_final-vtext3 WHERE spras = sy-langu
    AND fkart = wa_final-fkart.

    SELECT SINGLE gstin FROM  j_1bbranch INTO wa_final-gstin
                      WHERE bukrs = wa_final-bukrs
    AND  branch = wa_final-bupla.
    IF wa_vbrk-vbtyp = 'N' OR wa_vbrk-vbtyp = 'O'.
      wa_final-invvalue = abs( wa_final-netwr ) + abs( wa_final-mwsbk ).
      wa_final-invvalue = wa_final-invvalue * -1.
    ELSE.
      wa_final-invvalue = wa_final-netwr + wa_final-mwsbk.
    ENDIF.

    IF wa_vbrk-waerk NE 'INR'.
      wa_final-invvalue = wa_final-invvalue * wa_vbrk-kurrf.
    ENDIF.

    READ TABLE it_vbrp INTO wa_vbrp WITH KEY vbeln = wa_vbrk-vbeln.
    IF sy-subrc = 0.
      wa_final-posnr  = wa_vbrp-posnr.
      wa_final-ntgew  = wa_vbrp-ntgew.
      wa_final-matnr  = wa_vbrp-matnr.

      wa_final-charg  = wa_vbrp-charg.
      wa_final-pstyv  = wa_vbrp-pstyv.
*      if wa_vbrk-FKART = 'ZEXP'.
      wa_final-spart  = wa_vbrp-spart.
*      endif.
      wa_final-werks  = wa_vbrp-werks.
      wa_final-vkgrp = wa_vbrp-vkgrp.
      wa_final-vkbur  = wa_vbrp-vkbur.
      wa_final-bzirk_auft = wa_vbrp-bzirk_auft.
      wa_final-vrkme = wa_vbrp-vrkme.
      wa_final-mvgr1 = wa_vbrp-mvgr1.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = wa_vbrp-prctr
        IMPORTING
          output = wa_final-prctr.
      READ TABLE it_ekko INTO wa_ekko WITH KEY ebeln = wa_vbrp-aubel.
      IF sy-subrc = 0.

        READ TABLE it_prcd INTO wa_prcd WITH KEY knumv = wa_ekko-knumv.
        IF sy-subrc = 0.
          wa_final-kwert = wa_prcd-kwert.
        ENDIF.

      ENDIF.

*      "START OF ADDITION ABAP01
*      READ TABLE IT_KNVP INTO WA_KNVP WITH KEY KUNNR = WA_VBPA-KUNNR PARVW = 'VE' BINARY SEARCH.
*      IF SY-SUBRC = 0.
*        SELECT SINGLE ENAME FROM PA0001 INTO WA_FINAL-UENAME WHERE PERNR = WA_KNVP-PERNR.
*      ENDIF.
*      "END OF ADDITION ABAP01


      SELECT SINGLE bezei INTO wa_final-vtext5 FROM tvkbt WHERE spras = 'EN'
      AND vkbur = wa_final-vkbur.
      SELECT SINGLE bezei INTO wa_final-vtext6 FROM tvgrt WHERE spras = 'EN'
      AND vkgrp = wa_final-vkgrp.
      SELECT SINGLE name1 FROM t001w INTO wa_final-locname WHERE werks = wa_final-werks
      AND spras = sy-langu.
      IF wa_final-bzirk_auft IS NOT INITIAL.
        SELECT SINGLE bztxt FROM t171t INTO wa_final-bztxt
                         WHERE spras = 'EN'
                         AND  bzirk =  wa_final-bzirk_auft.
      ENDIF.

*      PERFORM READ_TEXT USING  'VBBK'
*                               WA_VBRK-VBELN
*                               'Z003'
*                               CHANGING WA_FINAL-LRNO.
*      TRANSLATE WA_FINAL-LRNO TO UPPER CASE.
************* LR_DATE
*      PERFORM READ_TEXT USING 'VBBK'
*                               WA_VBRK-VBELN
*                               'Z000'
*
      "CHANGING WA_FINAL-LRDATE.
      DATA : lv_lr TYPE zupload.
      SELECT * FROM zupload INTO lv_lr WHERE vbeln = wa_vbrk-vbeln.
      ENDSELECT.
      IF sy-subrc = 0.
        wa_final-lrno = lv_lr-bolnr.
        wa_final-lrdate = lv_lr-lrdate.
      ENDIF.
************* Vehical NO
*      PERFORM READ_TEXT USING 'VBBK'
*                               WA_VBRK-VBELN
*                               'Z004'
*                               CHANGING WA_FINAL-VEH_NO.
      DATA: lv_veh TYPE zteway_transport-v_number .
      SELECT v_number FROM zteway_transport INTO lv_veh WHERE bukrs = wa_vbrk-bukrs AND docno =  wa_vbrk-vbeln  AND doctyp =  wa_vbrk-fkart.
      ENDSELECT.
      IF sy-subrc = 0.
        wa_final-veh_no = lv_veh.
      ENDIF.
      TRANSLATE wa_final-veh_no TO UPPER CASE.
      SELECT * FROM vbpa
               INTO TABLE @DATA(it_vbpa)
      WHERE vbeln = @wa_vbrp-vbeln.


      LOOP AT it_vbpa INTO DATA(wa_vbpa).
        CASE wa_vbpa-parvw.
          WHEN 'RE'.
            SELECT SINGLE * FROM kna1
                   INTO @DATA(st_kna1)
            WHERE kunnr = @wa_vbpa-kunnr.
            wa_final-btp_code = wa_vbpa-kunnr.
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
              EXPORTING
                input  = wa_final-btp_code
              IMPORTING
                output = wa_final-btp_code.
            CONCATENATE st_kna1-name1 st_kna1-name2 INTO wa_final-btp_name SEPARATED BY space.
            wa_final-btp_gstno = st_kna1-stcd3.                               "Add on 04.06.2020 Kaustubh
          WHEN 'WE' OR 'ZH'.
            SELECT SINGLE * FROM kna1
                   INTO st_kna1
            WHERE kunnr = wa_vbpa-kunnr.
            wa_final-stp_code = wa_vbpa-kunnr.
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
              EXPORTING
                input  = wa_final-stp_code
              IMPORTING
                output = wa_final-stp_code.
            CONCATENATE st_kna1-name1 st_kna1-name2 INTO wa_final-stp_name SEPARATED BY space.
            wa_final-stp_gstno = st_kna1-stcd3.

            SELECT SINGLE ktext
                   FROM t151t
                   INTO @DATA(lv_ktext)
                   WHERE kdgrp = ( SELECT DISTINCT kdgrp
                                          FROM knvv
                                          WHERE kunnr = @wa_vbpa-kunnr
                                            AND vkorg = @wa_vbrk-vkorg
                                            AND vtweg = @wa_vbrk-vtweg
                                            AND spart = @wa_vbrk-spart ) AND
            spras = @sy-langu.
            wa_final-ktext = lv_ktext.
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.

      SELECT SINGLE landx
             FROM t005t
             INTO @DATA(lv_landx)
             WHERE spras = @sy-langu
      AND  land1 = @st_kna1-land1.

      wa_final-landx = lv_landx.


      CLEAR: wa_vbpa, st_kna1.

*      SELECT SINGLE NAME1
*           FROM LFA1
*           INTO @DATA(LV_TRNS_NME)
*           WHERE LIFNR EQ ( SELECT DISTINCT LIFNR
*                                   FROM VBPA
*                                   WHERE VBELN EQ @WA_VBRP-VBELN AND
*      PARVW EQ 'ZT' ).
*      TRANSLATE LV_TRNS_NME TO UPPER CASE.
*      WA_FINAL-TRNS_NAME = LV_TRNS_NME.
*      CLEAR: LV_TRNS_NME.
      DATA : lv_transname TYPE ztransport.
      SELECT * FROM ztransport INTO  lv_transname WHERE kunnr = wa_vbrk-kunag.
      ENDSELECT.
      IF sy-subrc = 0.
        TRANSLATE lv_transname TO UPPER CASE.
        wa_final-trns_name = lv_transname-trpname.
        CLEAR lv_transname.
      ENDIF.

      SELECT SINGLE name1
            FROM lfa1
            INTO @DATA(lv_lia_nme)
            WHERE lifnr EQ ( SELECT DISTINCT lifnr
                                    FROM vbpa
                                    WHERE vbeln EQ @wa_vbrp-vbeln AND
      parvw EQ 'ZL' ).
      wa_final-lia_name = lv_lia_nme.
      CLEAR: lv_lia_nme.

      wa_final-aubel = wa_vbrp-aubel.
      SELECT SINGLE audat
             FROM vbak
             INTO @DATA(lv_audat)
      WHERE vbeln = @wa_vbrp-aubel.
      wa_final-audat = lv_audat.
      wa_final-vgbel = wa_vbrp-vgbel.

      SELECT SINGLE kvgr1 FROM vbak INTO wa_final-kvgr1
      WHERE vbeln = wa_vbrp-aubel.

      IF wa_final-kvgr1 IS NOT INITIAL.
        SELECT SINGLE bezei
                   FROM tvv1t
                   INTO @DATA(lv_cgrp1)
                   WHERE spras = 'E'
        AND  kvgr1 = @wa_final-kvgr1.
        wa_final-cgrp1 = lv_cgrp1.
      ENDIF.


      SELECT SINGLE wadat_ist
             FROM likp
             INTO @DATA(lv_wadat_ist)
      WHERE vbeln = @wa_vbrp-vgbel.
      wa_final-wadat_ist = lv_wadat_ist.

      CALL FUNCTION 'DD_DOMA_GET'
        EXPORTING
          domain_name   = 'VF_STATUS'
*         GET_STATE     = 'M  '
          langu         = sy-langu
*         PRID          = 0
          withtext      = 'X'
        TABLES
          dd07v_tab_a   = it_taba
          dd07v_tab_n   = it_tabb
        EXCEPTIONS
          illegal_value = 1
          op_failure    = 2
          OTHERS        = 3.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
      READ TABLE it_taba INTO DATA(wa_vfstatus) WITH KEY domvalue_l = wa_vbrk-vf_status.
      wa_final-vf_status = wa_vfstatus-ddtext.
      CLEAR: wa_vfstatus.
      REFRESH: it_taba, it_tabb.
      CALL FUNCTION 'DD_DOMA_GET'
        EXPORTING
          domain_name   = 'BUCHK'
*         GET_STATE     = 'M  '
          langu         = sy-langu
*         PRID          = 0
          withtext      = 'X'
        TABLES
          dd07v_tab_a   = it_taba
          dd07v_tab_n   = it_tabb
        EXCEPTIONS
          illegal_value = 1
          op_failure    = 2
          OTHERS        = 3.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
      READ TABLE it_taba INTO DATA(wa_buchk) WITH KEY domvalue_l = wa_vbrk-buchk.
      wa_final-buchk = wa_buchk-ddtext.
      CLEAR: wa_buchk.
      REFRESH: it_taba, it_tabb.


      SELECT SINGLE vgbel
        FROM vbrp
        INTO @DATA(lv_vgbel)
      WHERE vbeln EQ @wa_vbrk-vbeln.
      IF sy-subrc = 0.
        SELECT SINGLE bstnk, bstdk
               FROM vbak
               INTO @DATA(st_vbak)
        WHERE vbeln EQ @lv_vgbel.
      ENDIF.

      wa_final-bstnk = st_vbak-bstnk.
      wa_final-bstdk = st_vbak-bstdk.

      SELECT SINGLE aubel
             FROM vbrp
             INTO @DATA(lv_aubel)
      WHERE vbeln EQ @wa_vbrk-vbeln .

      SELECT SINGLE vbelv
             FROM vbfa
             INTO @DATA(lv_quotation)
             WHERE vbtyp_v EQ 'B'
      AND  vbeln EQ @lv_aubel.

      wa_final-quotation = lv_quotation.

      SELECT SINGLE aubel
             FROM vbrp
             INTO @DATA(ls_aubel)
      WHERE vbeln EQ @wa_vbrk-vbeln .

      SELECT SINGLE vbelv
             FROM vbfa
             INTO @DATA(lv_contract)
             WHERE vbtyp_v EQ 'G'
      AND  vbeln EQ @ls_aubel.

      wa_final-contract = lv_contract.

      SELECT SINGLE vtext
             FROM t188t
             INTO @DATA(lv_vtext)
             WHERE spras = 'E'
              AND  konda = ( SELECT DISTINCT konda_auft
                                    FROM vbrp
                                    WHERE vbeln = @wa_vbrp-vbeln
      AND posnr = @wa_vbrp-posnr ).
      wa_final-pgroup = lv_vtext.

    ENDIF.
    SELECT SINGLE vtext
           FROM tvzbt
           INTO @DATA(lv_zterm_txt)
           WHERE spras EQ 'E'
    AND  zterm EQ @wa_vbrk-zterm.
    wa_final-zterm = lv_zterm_txt.
    IF wa_final-zterm IS INITIAL.
      SELECT SINGLE text1
                           FROM t052u
                           INTO  wa_final-zterm
                           WHERE spras = 'E'
      AND zterm = wa_vbrk-zterm.
    ENDIF.


    SELECT SINGLE *
                   FROM t052
                   INTO @DATA(lv_payment_term)
    WHERE zterm = @wa_vbrk-zterm.
    wa_final-duedt = wa_vbrk-fkdat + lv_payment_term-ztag1.



    LOOP AT  it_konv INTO wa_konv WHERE knumv = wa_vbrk-knumv
                                        AND kposn = ''.

      IF  wa_konv-kschl = 'ZL00'.
        wa_final-lir_name = wa_konv-kwert.
        wa_final-lir_com  = wa_konv-kbetr.
      ENDIF.

      CLEAR: wa_konv.
    ENDLOOP.

    READ TABLE it_kna1 INTO wa_kna1 WITH KEY kunnr = wa_vbrk-kunag.
    IF sy-subrc = 0.
      wa_final-kunnr = wa_kna1-kunnr.
      CONCATENATE wa_kna1-name1 wa_kna1-name2 wa_kna1-name3 wa_kna1-name4  INTO lv_cust_name SEPARATED BY space.
      wa_final-name1 = lv_cust_name.
      CLEAR: lv_cust_name.
      wa_final-regio = wa_kna1-regio.
      wa_final-stcd3 = wa_kna1-stcd3.
      wa_final-pan_no = wa_kna1-pan_no.
    ENDIF.

    IF wa_final-kunnr IS NOT INITIAL.
*      READ TABLE it_zgst_region_map INTO wa_zgst_region_map WITH KEY land1 = wa_kna1-land1 regio = wa_kna1-regio.
      READ TABLE it_zgst_region_map INTO wa_zgst_region_map WITH KEY land1 = wa_kna1-land1 std_state_code = wa_kna1-regio.
      IF sy-subrc = 0.
*        wa_final-zgstr = wa_zgst_region_map-zgstr.
        wa_final-zgstr = wa_zgst_region_map-std_state_code.
        wa_final-bezei = wa_zgst_region_map-bezei.

      ENDIF.

    ENDIF.

    DATA: gt_lines TYPE TABLE OF tline,
          ls_line  LIKE tline.
    SELECT SINGLE * FROM stxh
      INTO @DATA(ls_stxh)
      WHERE  tdobject = 'VBBK'
      AND    tdname = @wa_vbrk-vbeln
      AND    tdid  = 'ZSHB'
    AND    tdspras = @sy-langu.

    IF sy-subrc = 0.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
*         CLIENT   = LV_MANDT
          id       = ls_stxh-tdid
          language = ls_stxh-tdspras
          name     = ls_stxh-tdname
          object   = ls_stxh-tdobject
        TABLES
          lines    = gt_lines.
      LOOP AT gt_lines INTO ls_line.
        wa_final-ship_bil_no = ls_line-tdline.
      ENDLOOP.
    ENDIF.

    CLEAR : ls_line, ls_stxh.
    REFRESH : gt_lines.

    SELECT SINGLE * FROM stxh
      INTO @ls_stxh
      WHERE  tdobject = 'VBBK'
      AND    tdname = @wa_vbrk-vbeln
      AND    tdid  = 'ZSHD'
    AND    tdspras = @sy-langu.

    IF sy-subrc = 0.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
*         CLIENT   = LV_MANDT
          id       = ls_stxh-tdid
          language = ls_stxh-tdspras
          name     = ls_stxh-tdname
          object   = ls_stxh-tdobject
        TABLES
          lines    = gt_lines.
      LOOP AT gt_lines INTO ls_line.
        wa_final-ship_bil_date = ls_line-tdline.
      ENDLOOP.
    ENDIF.

***********************************************SOC ABAP01 01.09.2025 ADDITION OF HEADER TEXT*************************************************
    SELECT SINGLE * FROM stxh
  INTO @ls_stxh
  WHERE  tdobject = 'VBBK'
  AND    tdname = @wa_vbrk-vbeln
  AND    tdid  = 'Z022'
AND    tdspras = @sy-langu.

    IF sy-subrc = 0.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
*         CLIENT   = LV_MANDT
          id       = ls_stxh-tdid
          language = ls_stxh-tdspras
          name     = ls_stxh-tdname
          object   = ls_stxh-tdobject
        TABLES
          lines    = gt_lines.
      LOOP AT gt_lines INTO ls_line.
        wa_final-z022 = ls_line-tdline.
      ENDLOOP.
    ENDIF.


    SELECT SINGLE * FROM stxh
    INTO @ls_stxh
    WHERE  tdobject = 'VBBK'
    AND    tdname = @wa_vbrk-vbeln
    AND    tdid  = 'Z023'
  AND    tdspras = @sy-langu.

    IF sy-subrc = 0.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
*         CLIENT   = LV_MANDT
          id       = ls_stxh-tdid
          language = ls_stxh-tdspras
          name     = ls_stxh-tdname
          object   = ls_stxh-tdobject
        TABLES
          lines    = gt_lines.
      LOOP AT gt_lines INTO ls_line.
        wa_final-z023 = ls_line-tdline.
      ENDLOOP.
    ENDIF.

***********************************************EOC ABAP01 01.09.2025 ADDITION OF HEADER TEXT*************************************************




    READ TABLE it_vbpa_tmp INTO  DATA(wa_cust) WITH KEY vbeln = wa_vbrk-vbeln
                                         parvw = 'ZP'.
    IF sy-subrc = 0.
      wa_final-port_code = wa_cust-kunnr.
    ENDIF.

    READ TABLE it_vbak_d INTO wa_vbak_d WITH KEY vbeln = wa_vbrp-aubel.
    IF sy-subrc = 0.
      wa_final-bstnk_d = wa_vbak_d-bstnk.
      wa_final-bstdk_d = wa_vbak_d-bstdk.
    ENDIF.


    IF wa_final-fkart = 'ZLU1' OR
       wa_final-fkart = 'ZLUT'  .
      CLEAR : wa_final-mwsbk.
    ENDIF.
    SELECT SINGLE regio FROM kna1 INTO @DATA(v_regio) WHERE kunnr = @wa_vbrk-kunag.
    READ TABLE it_state INTO DATA(wa_state) WITH KEY bukrs = wa_vbrk-bukrs branch = wa_vbrk-bupla.
    IF sy-subrc  = 0 .
      READ TABLE it_adr INTO DATA(wa_adr) WITH KEY addrnumber = wa_state-adrnr.
      IF sy-subrc = 0.
        IF wa_adr-region = v_regio."VBRK-REGIO.
          wa_final-state = 'INTRA STATE'.
        ELSE.
          wa_final-state = 'INTER STATE'.
        ENDIF.
      ENDIF.
    ENDIF.

    IF wa_vbrk-waerk NE 'INR'. " commented by naga on 15-12-2022
*    IF wa_vbrk-waerk EQ 'INR'. " added by naga on 15-12-2022
*      wa_final-netwr = wa_final-netwr.
      wa_final-mwsbk = wa_final-mwsbk * wa_vbrk-kurrf.
    ENDIF.
    "" soc by naga on 17-07-2024
    DATA : lv_eway TYPE j_1ig_ewaybill.
    SELECT * FROM j_1ig_ewaybill INTO lv_eway WHERE bukrs = wa_vbrk-bukrs AND docno =  wa_vbrk-vbeln  AND doctyp =  wa_vbrk-fkart.
    ENDSELECT.
    IF sy-subrc = 0.
      wa_final-ewbno = lv_eway-ebillno.
      wa_final-ewbdt = lv_eway-egen_dat.
    ENDIF.
    APPEND wa_final TO it_final.
    CLEAR : wa_final,wa_vbrk,wa_vbrp,wa_kna1.
  ENDLOOP.
  DELETE it_final WHERE werks = ''.
ENDFORM.

**************end of changes  by vyshnavi.v 18/07/2022*************************************


*&---------------------------------------------------------------------*
*& Form FIELDCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM fieldcat .
*  wa_fieldcat-col_pos = 1.
  wa_fieldcat-fieldname  = 'VBELN'.
  wa_fieldcat-seltext_m  = TEXT-000."'Billing Doc. No.'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'IRN'.
  wa_fieldcat-seltext_m  = 'IRN No.'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'ERDAT'.
  wa_fieldcat-seltext_m  = 'IRN Date'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
*  CLEAR wa_fieldcat.
*
*  wa_fieldcat-fieldname  = 'EWBNO'.
*  wa_fieldcat-seltext_m  = 'Ewaybill No'.
*  wa_fieldcat-tabname    = 'IT_FINAL'.
*  APPEND wa_fieldcat TO it_fieldcat.             " commented by naga on 6-12-2022
*  CLEAR wa_fieldcat.
*
*  wa_fieldcat-fieldname  = 'EWBDT'.
*  wa_fieldcat-seltext_m  = 'Ewaybill Date'.
*  wa_fieldcat-tabname    = 'IT_FINAL'.
*  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'BELNR'."'XBLNR'.
  wa_fieldcat-seltext_m  = TEXT-051."'Billing Doc. No.'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  wa_fieldcat-col_pos = 2.
  wa_fieldcat-fieldname  = 'VKORG'.
  wa_fieldcat-seltext_m  = TEXT-001."'Sales Organization'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  wa_fieldcat-col_pos = 2.
  wa_fieldcat-fieldname  = 'VTEXT'.
  wa_fieldcat-seltext_l  = TEXT-002."'Sales Org. Description'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  wa_fieldcat-col_pos = 3.
  wa_fieldcat-fieldname  = 'VTWEG'.
  wa_fieldcat-seltext_m  = TEXT-003."'Distribution Channel'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  wa_fieldcat-col_pos = 2.
  wa_fieldcat-fieldname  = 'VTEXT1'.
  wa_fieldcat-seltext_l  = TEXT-004."'Dist. Channel Desc.'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  wa_fieldcat-col_pos = 4.
  wa_fieldcat-fieldname  = 'SPART'.
  wa_fieldcat-seltext_m  = TEXT-005."'Division'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  wa_fieldcat-col_pos = 4.
  wa_fieldcat-fieldname  = 'VTEXT2'.
  wa_fieldcat-seltext_m  = TEXT-006."'Division Desc.'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  wa_fieldcat-col_pos = 4.
  wa_fieldcat-fieldname  = 'VKBUR'.
  wa_fieldcat-seltext_m  = TEXT-052."'Sales Office.'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
*  CLEAR wa_fieldcat.
*
**  *  wa_fieldcat-col_pos = 4.
*  wa_fieldcat-fieldname  = 'VTEXT5'.
*  wa_fieldcat-seltext_l  = TEXT-053."'Sales Office Desc.'. " ommented by naga on 15-12-2022.
*  wa_fieldcat-tabname    = 'IT_FINAL'.
*  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


*  wa_fieldcat-col_pos = 9.
  wa_fieldcat-fieldname  = 'BZIRK_AUFT'.
  wa_fieldcat-seltext_m  = 'Customer Zone'."'Headquarter Code'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  wa_fieldcat-col_pos = 10.
  wa_fieldcat-fieldname  = 'BZTXT'.
  wa_fieldcat-seltext_m  = 'Customer Zone Description'."'Headquarter Name'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.
*  wa_fieldcat-col_pos = 5.
  wa_fieldcat-fieldname  = 'WERKS'.
  wa_fieldcat-seltext_m  = TEXT-007."'Location'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  wa_fieldcat-col_pos = 5.
  wa_fieldcat-fieldname  = 'LOCNAME'.
  wa_fieldcat-seltext_m  = TEXT-008."'Location Description'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  wa_fieldcat-col_pos = 6.
  wa_fieldcat-fieldname  = 'GSTIN'.
  wa_fieldcat-seltext_m  = TEXT-009."'Location GSTIN No'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  wa_fieldcat-col_pos = 7.
  wa_fieldcat-fieldname  = 'FKDAT'.
  wa_fieldcat-seltext_m  = TEXT-010."'Billing Date'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  wa_fieldcat-col_pos = 8.
  wa_fieldcat-fieldname  = 'FKART'.
  wa_fieldcat-seltext_m  = TEXT-011."'Billing Type'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  wa_fieldcat-col_pos = 8.
  wa_fieldcat-fieldname  = 'VTEXT3'.
  wa_fieldcat-seltext_l  = TEXT-012."'Billing Description'.
  wa_fieldcat-outputlen  = 40."'Billing Description'.
  wa_fieldcat-lowercase  = 'X'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'BSTNK_D'.
  wa_fieldcat-seltext_l  = TEXT-107."'Customer Reference No.'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'BSTDK_D'.
  wa_fieldcat-seltext_l  = TEXT-108."'Customer Reference Date'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'AUBEL'.
  wa_fieldcat-seltext_m  = TEXT-093."'Sales Order No'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'AUDAT'.
  wa_fieldcat-seltext_m  = TEXT-094."'Sales Order Date'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'KUNAG'.
  wa_fieldcat-seltext_m  = TEXT-015."'Customer Code'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'NAME1'.
  wa_fieldcat-seltext_m  = TEXT-016."'Customer Name'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'REGIO'.
  wa_fieldcat-seltext_m  = TEXT-017."'Customer State'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  WA_FIELDCAT-FIELDNAME  = 'ZGSTR'.
*  WA_FIELDCAT-SELTEXT_M  = TEXT-018."'GST State Code'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.

*  wa_fieldcat-col_pos = 13.
*  WA_FIELDCAT-FIELDNAME  = 'BEZEI'.
*  WA_FIELDCAT-SELTEXT_M  = TEXT-019."'Customer State Name'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.

  wa_fieldcat-fieldname  = 'LANDX'.
  wa_fieldcat-seltext_m  = TEXT-099."'Country'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  wa_fieldcat-col_pos = 14.
  wa_fieldcat-fieldname  = 'STCD3'.
  wa_fieldcat-seltext_m  = TEXT-020."'Customer GSTIN No.'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'NETWR'.
  wa_fieldcat-seltext_l = TEXT-021."'Sales Value in forex'.
  wa_fieldcat-outputlen  = 30.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'NETWR1'.
  wa_fieldcat-seltext_l = 'Taxable Value'.
  wa_fieldcat-outputlen  = 30.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'WAERK'.
  wa_fieldcat-seltext_m  = TEXT-098."'Document Currency'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'MWSBK'.
  wa_fieldcat-seltext_m  = 'Tax Value in INR'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'INVVALUE'.
  wa_fieldcat-seltext_m  = 'Gross Value'."'Invoice Value in INR'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'STP_CODE'.
  wa_fieldcat-seltext_m  = TEXT-088."'Ship-to-Party Code'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'STP_NAME'.
  wa_fieldcat-seltext_m  = TEXT-089."'Ship-to-Party Name'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'STP_GSTNO'.
  wa_fieldcat-seltext_m  = TEXT-103."'GSTN No.'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'KTEXT'.
  wa_fieldcat-seltext_m  = TEXT-104."'Customer Group'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'BTP_CODE'.
  wa_fieldcat-seltext_m  = TEXT-090."'Bill-to-Party Code'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'BTP_NAME'.
  wa_fieldcat-seltext_m  = TEXT-091."'Bill-to-Party Name'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'BTP_GSTNO'.                          "Add on 04-06-2020   Kaustubh
  wa_fieldcat-seltext_m  = 'GSTN No.'."'GSTN No.'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'TRNS_NAME'.
  wa_fieldcat-seltext_m  = TEXT-092."'Transporter Name'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'LRNO'.
  wa_fieldcat-seltext_m  = TEXT-026."'LR Number'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'LRDATE'.
  wa_fieldcat-seltext_m  = TEXT-027."'LR Date'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'KWERT'.
  wa_fieldcat-seltext_m  = TEXT-062."'Fright Amount'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'VF_STATUS'.
  wa_fieldcat-seltext_m  = TEXT-101."'Invoicing Status'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.



  wa_fieldcat-fieldname  = 'ZTERM'.
  wa_fieldcat-seltext_m  = TEXT-116."'Payment Terms'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'DUEDT'.
  wa_fieldcat-seltext_m  = TEXT-117."'Due Date'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  WA_FIELDCAT-FIELDNAME  = 'MVGR1'.                """"""""""" Added by pavan 18.12.2023
*  WA_FIELDCAT-SELTEXT_M  = TEXT-120."'Material Group 1'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.

  wa_fieldcat-fieldname  = 'STATE'.
  wa_fieldcat-seltext_l  = 'Form Desc'."'Inter/Intra State'.
  wa_fieldcat-outputlen  = 20.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'SHIP_BIL_NO'.
  wa_fieldcat-seltext_l  = 'Shipping Bill No'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  WA_FIELDCAT-FIELDNAME  = 'SHIP_BIL_DATE'.
*  WA_FIELDCAT-SELTEXT_L  = 'Shipping Bill Date'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.

  wa_fieldcat-fieldname  = 'PORT_CODE'.
  wa_fieldcat-seltext_l  = 'Port code'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'KURRF'.
  wa_fieldcat-seltext_l  = 'Exchange Rate'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'VRKME'.
  wa_fieldcat-seltext_l  = 'Sales UOM'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  WA_FIELDCAT-FIELDNAME  = 'MIRO'.
*  WA_FIELDCAT-SELTEXT_L  = 'Miro Invoice No'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display .
  DATA: variant TYPE disvariant.
  variant-report = sy-repid.
  variant-username  = sy-uname.
  wa_layout-zebra = 'X' .
  wa_layout-colwidth_optimize = 'X' .
  lv_repid = sy-repid.
*DATA: lv_repid TYPE sy-rep
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = lv_repid "'ZSD_SALES_REG' "SY-REPID
      is_layout               = wa_layout
      it_fieldcat             = it_fieldcat
      i_callback_user_command = 'UCOMM'
*     IT_EXCLUDING            =
*     IT_SPECIAL_GROUPS       =
*     IT_SORT                 =
*     IT_FILTER               =
*     IS_SEL_HIDE             =
*     I_DEFAULT               = 'X'
      i_save                  = 'A'
      is_variant              = variant
    TABLES
      t_outtab                = it_final
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
* Implement suitable error handling here
  ENDIF.

ENDFORM.

FORM ucomm USING ok_code TYPE sy-ucomm
                 selfield TYPE slis_selfield.
  .
  CASE ok_code.
    WHEN '&IC1'.
      IF selfield-tabname = 'IT_FINAL'.
        IF selfield-fieldname = 'VBELN'.
          READ TABLE it_final INTO wa_final INDEX selfield-tabindex.
          IF sy-subrc = 0.
*            SET PARAMETER ID 'VF' FIELD WA_FINAL-VBELN.
*            CALL TRANSACTION 'VF03'." AND SKIP FIRST SCREEN.
            CLEAR:bdcdata,bdcdata[].
            PERFORM bdc_dynpro      USING 'SAPMV60A' '0101'.
            PERFORM bdc_field       USING 'VBRK-VBELN'
                                               wa_final-vbeln.
            CALL TRANSACTION 'VF03' USING bdcdata
                                OPTIONS FROM wa_ctu_params
                                MESSAGES INTO it_msg.
          ENDIF.
          CLEAR : wa_final.
        ENDIF.
      ENDIF.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form LOOP_DATA1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM loop_data1.

  SELECT a~vbeln,a~vgbel,a~vgpos,SUM( CASE WHEN b~bwart EQ '602'  THEN dmbtr * -1  ELSE dmbtr END ) AS amt,"c~belnr,C~gjahr,c~rbukrs,c~hsl
  SUM( CASE WHEN b~bwart EQ '602' THEN menge * -1 ELSE menge END ) AS menge
     FROM @it_vbrp AS a INNER JOIN vbrk AS f ON a~vbeln = f~vbeln
     INNER JOIN lips AS c ON CASE WHEN f~fkart EQ 'ZBV' THEN c~vgbel ELSE c~vbeln END  = a~vgbel AND
     CASE WHEN c~uecha IS INITIAL THEN c~posnr ELSE c~uecha END  = a~vgpos
     INNER JOIN mseg AS b ON c~vbeln = b~vbeln_im AND c~posnr = b~vbelp_im
*                 LEFT JOIN acdoca as c on b~mblnr = c~awref and B~zeile = C~awitem
    GROUP BY a~vbeln ,a~vgbel,a~vgpos
    INTO TABLE @DATA(tpcip) .



  SELECT FROM @it_vbrp AS a LEFT OUTER JOIN bseg AS b ON a~aubel = b~vbel2 AND a~aupos = b~posn2
    FIELDS
    a~vbeln,a~aubel,a~aupos,b~hkont,SUM( CASE WHEN shkzg EQ 'H' THEN CAST( b~dmbtr * -1 AS CURR( 15 , 2 ) ) ELSE b~dmbtr END )  AS dmbtr,
    SUM( CASE WHEN shkzg EQ 'H' THEN CAST( b~menge * -1 AS CURR( 15 , 2 ) ) ELSE b~menge END )  AS menge
    WHERE b~hkont IN ( SELECT valfrom FROM setleaf WHERE setname = 'ZDTPGL' )
    GROUP BY a~vbeln,a~aubel,a~aupos,hkont
    INTO TABLE @DATA(tpcip2) .

  SELECT valfrom FROM setleaf INTO TABLE @DATA(set) WHERE setname = 'DTPFKART'.
*  IF IT_VBRP IS NOT INITIAL.
*    SELECT * FROM MARM INTO TABLE @DATA(IT_MARM) FOR ALL ENTRIES IN @IT_VBRP WHERE MATNR = @IT_VBRP-MATNR AND MEINH = @IT_VBRP-VRKME.
*  ENDIF.
  IF it_vbrk IS NOT INITIAL.
    SELECT * FROM tinct INTO TABLE @DATA(it_tinct) FOR ALL ENTRIES IN @it_vbrk WHERE inco1 = @it_vbrk-inco1 AND spras = 'E'.
  ENDIF.
  DATA :v_lfmng TYPE mvke-lfmng.
  DATA :v_scmng TYPE mvke-scmng.
  DATA :v_mvgr1 TYPE mvke-mvgr1. """"""""""""""" Added by pavan 18.12.2023
  DATA :v_bezei1 TYPE tvm1t-bezei. """""""''""""" Added by Pavan 20.12.2023
  DATA : lv_prcd TYPE ty_prcd.
  DATA : lv_mrp TYPE string.
  DATA: lv_mrp1 TYPE string.
  LOOP AT it_vbrp INTO wa_vbrp.
    wa_final-vbeln  = wa_vbrp-vbeln.
    wa_final-posnr  = wa_vbrp-posnr.
    wa_final-ntgew  = wa_vbrp-ntgew.
    wa_final-meins  = wa_vbrp-meins.
    wa_final-prodh  = wa_vbrp-prodh.
    wa_final-vrkme = wa_vbrp-vrkme.
*    WA_FINAL-MVGR1 = WA_VBRP-MVGR1.   """"""""""""""" Added by pavan 18.12.2023




*************Start ofAddition By MayurB 12/07/23  <DS4K905313>***************************
    PERFORM read_text USING 'VBBK'
                       wa_final-vbeln
                       'Z015'
                       CHANGING wa_final-city.
    IF wa_final-city IS INITIAL.
      SELECT SINGLE adrnr
                  FROM vbpa
                  INTO @DATA(v_adrnr)
                  WHERE vbeln = @wa_final-vbeln
                  AND ( parvw = 'WE' OR parvw = 'ZH' )
                  AND posnr = ''.
      SELECT SINGLE city1
                    FROM adrc
                    INTO wa_final-city
                    WHERE addrnumber = v_adrnr.
    ENDIF.
***************End of Addition <DS4K905313>***************************

    IF wa_final-prodh IS NOT INITIAL.
      SELECT SINGLE vtext FROM t179t INTO wa_final-prodh_d1 WHERE prodh = wa_final-prodh+0(5) AND spras = 'E'.
      SELECT SINGLE vtext FROM t179t INTO wa_final-prodh_d2 WHERE prodh = wa_final-prodh+0(10) AND spras = 'E'.
      SELECT SINGLE vtext FROM t179t INTO wa_final-prodh_d3 WHERE prodh = wa_final-prodh AND spras = 'E'.
    ENDIF.

    READ TABLE it_vbrk INTO wa_vbrk WITH KEY vbeln = wa_vbrp-vbeln.
    READ TABLE it_vbak_d INTO wa_vbak_d WITH KEY vbeln = wa_vbrp-aubel.
    IF sy-subrc = 0.
      wa_final-bstnk_d = wa_vbak_d-bstnk.
      wa_final-bstdk_d = wa_vbak_d-bstdk.
    ENDIF.
*    ENDIF.
    wa_final-kurrf = wa_vbrk-kurrf.
    READ TABLE it_mch1 INTO wa_mch1 WITH KEY matnr = wa_vbrp-matnr
                                             charg = wa_vbrp-charg.
    IF sy-subrc = 0.
      wa_final-hsdat = wa_mch1-hsdat.
      wa_final-vfdat1 = wa_mch1-vfdat.
    ENDIF.

    DATA: gt_lines TYPE TABLE OF tline,
          ls_line  LIKE tline.

    SELECT SINGLE * FROM stxh
      INTO @DATA(ls_stxh)
      WHERE  tdobject = 'MATERIAL'
      AND    tdname = @wa_vbrp-matnr
      AND    tdid  = 'GRUN'
    AND    tdspras = @sy-langu.

    IF sy-subrc = 0.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
*         CLIENT   = LV_MANDT
          id       = ls_stxh-tdid
          language = ls_stxh-tdspras
          name     = ls_stxh-tdname
          object   = ls_stxh-tdobject
        TABLES
          lines    = gt_lines.
      LOOP AT gt_lines INTO ls_line.
        wa_final-mat_text = ls_line-tdline.
      ENDLOOP.
    ENDIF.

    REFRESH : gt_lines.


**************VEHICLE NO
    PERFORM read_text USING 'VBBK'
                             wa_vbrk-vbeln
                             'Z004'
                             CHANGING wa_final-veh_no.

    SELECT * FROM vbpa
               INTO TABLE @DATA(it_vbpa)
        WHERE vbeln = @wa_vbrp-vbeln.

    SELECT SINGLE kunnr FROM vbpa INTO @DATA(v_kunnr) WHERE vbeln = @wa_vbrp-vgbel AND parvw = 'PT'.
    IF sy-subrc = 0.
      SELECT SINGLE name1 FROM kna1 INTO wa_final-port_code WHERE kunnr = v_kunnr .
    ENDIF.

    DATA: lwa_mcha TYPE mcha,
          it_tab   TYPE STANDARD TABLE OF clbatch.
    CALL FUNCTION 'VB_BATCH_GET_DETAIL'
      EXPORTING
        matnr              = wa_vbrp-matnr
        charg              = wa_vbrp-charg
        werks              = wa_vbrp-werks
        get_classification = 'X'
*       EXISTENCE_CHECK    =
*       READ_FROM_BUFFER   =
*       NO_CLASS_INIT      = ' '
*       LOCK_BATCH         = ' '
      IMPORTING
        ymcha              = lwa_mcha
*       CLASSNAME          =
      TABLES
        char_of_batch      = it_tab
      EXCEPTIONS
        no_material        = 1
        no_batch           = 2
        no_plant           = 3
        material_not_found = 4
        plant_not_found    = 5
        no_authority       = 6
        batch_not_exist    = 7
        lock_on_batch      = 8
        OTHERS             = 9.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ELSE.
      READ TABLE it_tab INTO DATA(lwa_tab) WITH KEY atnam = 'ZMFG_BY'.
      IF sy-subrc = 0.
        wa_final-manufracturer = lwa_tab-atwtb.
      ENDIF.
    ENDIF.
    DATA : lv_freight  TYPE string,
           lv_ins      TYPE string,
           lv_pts      TYPE string,
           lv_fri      TYPE string,
           lv_ins1     TYPE string,
           lv_fr1      TYPE string,
           lt_prcd     TYPE tt_prcd,
           lv_pts1     TYPE string,
           lv_zjt      TYPE string,
           lv_zjt1     TYPE string,
           lv_ret      TYPE string,
           lv_retailer TYPE string,
           lv_stock    TYPE string,
           lv_stoc     TYPE string,
           lv_hospital TYPE string,
           lv_special  TYPE string,
           lv_spe      TYPE string,
           lv_hos      TYPE string.


    "" EOC by naga on 17-07-2024

    SELECT knumv
        kschl
        kbetr
        kwert
        waers
        kawrt
      FROM prcd_elements INTO TABLE lt_prcd WHERE knumv = wa_vbrk-knumv .


    IF sy-subrc = 0.
      LOOP AT lt_prcd INTO lv_prcd WHERE knumv =  wa_vbrk-knumv.
        CASE lv_prcd-kschl .
          WHEN 'Z001'.
            lv_mrp1 = lv_prcd-kbetr .
*CONCATENATE LV_MRP1 LV_PRCD-WAERS into LV_MRP SEPARATED BY SPACE.   "Commented & added by VARSHA 'To remove INR' 31-10-2025
            IF wa_vbrk-fkart = 'ZRE' OR wa_vbrk-fkart = 'ZRRE' OR wa_vbrk-fkart = 'ZRRsS' OR wa_vbrk-fkart = 'ZRS' OR wa_vbrk-fkart = 'ZSR'.
              wa_final-mrp = lv_mrp1 * -1.
            ELSE.
              wa_final-mrp = lv_mrp1.
            ENDIF.
            CLEAR lv_mrp.
          WHEN 'ZFOB'.
            lv_freight = lv_prcd-kbetr.
            CONCATENATE lv_freight lv_prcd-waers INTO lv_fri SEPARATED BY space.
            wa_final-freight_amt = lv_fri.
            CLEAR lv_fri.
          WHEN 'ZINS'.
            lv_ins = lv_prcd-kbetr.
            CONCATENATE lv_ins lv_prcd-waers INTO lv_ins1 SEPARATED BY space.
            wa_final-insurance_amt = lv_ins1.
          WHEN 'ZPTS'.
            lv_pts = lv_prcd-kbetr.
            CONCATENATE lv_pts lv_prcd-waers INTO lv_pts1 SEPARATED BY space.
            wa_final-pts = lv_pts1..
          WHEN 'JTC2'.
            lv_zjt = lv_prcd-kwert.
            CONCATENATE lv_zjt lv_prcd-waers INTO lv_zjt1 SEPARATED BY space.
            wa_final-zjt = lv_zjt1..
          WHEN 'Z010'.
            lv_ret = lv_prcd-kwert.
            CONCATENATE lv_ret lv_prcd-waers INTO lv_retailer SEPARATED BY space.
            wa_final-ret = lv_retailer .
          WHEN 'Z015'.
            lv_stoc = lv_prcd-kwert.
            CONCATENATE  lv_stoc lv_prcd-waers INTO lv_stock SEPARATED BY space.
            wa_final-stock = lv_stock.
          WHEN 'ZSPD'.
            lv_spe = lv_prcd-kwert.
            CONCATENATE  lv_spe lv_prcd-waers INTO lv_special SEPARATED BY space.
            wa_final-special = lv_special.
          WHEN 'ZHOS'.
            lv_hos = lv_prcd-kwert.
            CONCATENATE  lv_hos lv_prcd-waers INTO lv_hospital SEPARATED BY space.
            wa_final-hospi = lv_hospital.
        ENDCASE.
      ENDLOOP.
    ENDIF.
    READ TABLE it_vbrk INTO wa_vbrk WITH KEY vbeln = wa_vbrp-vbeln.  "freight amount
    IF sy-subrc = 0.
      LOOP AT it_prd INTO wa_prd WHERE knumv = wa_vbrk-knumv
                                 AND   kposn = wa_vbrp-posnr.



        CASE wa_prd-kschl.
          WHEN 'ZPR0' OR 'PMP0' OR 'ZSTO' OR 'ZDSM'..
            wa_final-item_sale = wa_prd-kwert.
            wa_final-item_sale1 = wa_prd-kwert.
*          WHEN 'ZFRA'.
*            WA_FINAL-FREIGHT_AMT = WA_PRD-KWERT.
          WHEN 'JOIG' OR 'JOCG' OR 'JOSG'.
            wa_final-gst_rate = wa_prd-kbetr + wa_final-gst_rate .
          WHEN 'ZNET' OR 'ZPAM'  OR 'ZSL1'  OR
               'ZPLL'  OR 'ZCSP' OR 'ZEXP'.
            wa_final-amount = wa_prd-kwert.
          WHEN 'ZDSP'.
            wa_final-strdiscnt1 = wa_final-strdiscnt1 +  wa_prd-kwert  .
          WHEN 'ZDIS'.
            SELECT SINGLE * FROM tcurx INTO @DATA(w_tcurx) WHERE currkey = @wa_vbrk-waerk.
            IF w_tcurx IS NOT INITIAL.
              wa_final-strdiscnt =  wa_prd-kbetr * 100.
            ELSE.
              wa_final-strdiscnt =  wa_prd-kbetr.
            ENDIF.

*          WHEN 'ZMRP'.
*            WA_FINAL-MRP = WA_PRD-KWERT.
          WHEN 'PTR1'.
            wa_final-ptr = wa_prd-kwert.
*          WHEN 'PTS1'.
*            WA_FINAL-PTS = WA_PRD-KWERT.
*          WHEN 'ZINS' ."OR 'ZINR'.
*            WA_FINAL-INSURANCE_AMT = WA_PRD-KWERT.
          WHEN 'ZDIM'."'ZCAS'.
            wa_final-cashdiscnt_d =  wa_prd-kwert.
          WHEN 'JTCB'.
            wa_final-tcs_base = wa_prd-kwert.
          WHEN 'ZTCS' OR 'JTC1'.
            wa_final-tcs_rate = wa_prd-kbetr.
            wa_final-tcs_amount = wa_prd-kwert.
          WHEN 'COGS'.
            wa_final-cogs = wa_prd-kbetr.
            wa_final-cogs_v = wa_prd-kwert.
          WHEN 'PCIP'.
            wa_final-ppcip = wa_prd-kbetr.
          WHEN 'ZPR0'.
            wa_final-zpr0 = wa_prd-kwert.
          WHEN 'ZDIP'.
            wa_final-zdip = wa_prd-kwert.
          WHEN 'ZRDF'.
            wa_final-zrdf = wa_prd-kwert.
        ENDCASE.
      ENDLOOP.
    ENDIF.


    READ TABLE tpcip ASSIGNING FIELD-SYMBOL(<pc>) WITH KEY vgbel = wa_vbrp-vgbel vgpos = wa_vbrp-vgpos.
    IF sy-subrc EQ 0.
      wa_final-pcip_v = <pc>-amt..
      IF wa_final-pcip IS INITIAL.
        wa_final-pcip = <pc>-amt / <pc>-menge.
      ENDIF.
    ENDIF.

*    IF WA_VBRK-FKART = 'JSTO'.
*
*      SELECT * FROM MSEG INTO TABLE @DATA(IT_JPCIP) WHERE VBELN_IM =  @WA_VBRP-VGBEL AND EBELP = @WA_VBRP-VGPOS+4 AND SHKZG = 'H'.
*
*      IF SY-SUBRC = 0.
*        CLEAR WA_FINAL-PCIP_V.
*        LOOP  AT IT_JPCIP  INTO DATA(WA_JPCIP).
*
*          WA_FINAL-PCIP_V = WA_FINAL-PCIP_V + WA_JPCIP-DMBTR.
*
*        ENDLOOP.
*
*
*      ENDIF.
*
*    ENDIF.

    READ TABLE set TRANSPORTING NO FIELDS WITH KEY valfrom = wa_vbrk-fkart.
    IF sy-subrc EQ 0.
      READ TABLE tpcip2 ASSIGNING FIELD-SYMBOL(<ip2>) WITH KEY aubel = wa_vbrp-aubel aupos = wa_vbrp-aupos.
      IF sy-subrc EQ 0.
        IF wa_vbrk-fkart = 'ZDTP'.
          DATA client           TYPE sy-mandt.
          DATA id               TYPE thead-tdid.
          DATA language         TYPE thead-tdspras.
          DATA name             TYPE thead-tdname.
          DATA object           TYPE thead-tdobject.
          DATA archive_handle   TYPE sy-tabix.
          DATA header           TYPE thead.
          DATA old_line_counter TYPE thead-tdtxtlines.
          DATA lines            TYPE STANDARD TABLE OF tline.
          DATA: lv_belnr TYPE belnr_d.


          CONCATENATE wa_vbrp-vbeln wa_vbrp-posnr  INTO name.
          id = 'TX18'.
          object = 'VBBP'.


          SELECT SINGLE * FROM stxl
                          INTO @DATA(wa_stxl)
                          WHERE tdobject EQ 'VBBP' AND
                                tdname   EQ @name   AND
                                tdid     EQ 'TX18'.

          IF sy-subrc = 0.
            CALL FUNCTION 'READ_TEXT'
              EXPORTING
                client           = sy-mandt
                id               = id
                language         = sy-langu
                name             = name
                object           = object
                archive_handle   = 0
              IMPORTING
                header           = header
                old_line_counter = old_line_counter
              TABLES
                lines            = lines.

            IF sy-subrc = 0.
              READ TABLE lines INTO DATA(wa_lines) INDEX 1.
              CONDENSE wa_lines-tdline.
              lv_belnr = wa_lines-tdline.
            ENDIF.
          ENDIF.


          CLEAR: wa_stxl.
          IF lv_belnr IS NOT INITIAL.
            SELECT SINGLE wrbtr FROM rseg
                                INTO @DATA(lv_wrbtr)
                                WHERE belnr = @lv_belnr.
            IF sy-subrc = 0.

              wa_final-pcip_v = lv_wrbtr.
              wa_final-pcip = wa_final-pcip_v / wa_vbrp-fkimg.
            ENDIF.

          ELSE.

            wa_final-pcip_v = <ip2>-dmbtr.
            TRY.
                wa_final-pcip = wa_final-pcip_v / <ip2>-menge.
              CATCH cx_sy_zerodivide.
            ENDTRY.

          ENDIF.

        ELSE.
          wa_final-pcip_v = <ip2>-dmbtr.

          TRY.
              wa_final-pcip = wa_final-pcip_v / <ip2>-menge.
            CATCH cx_sy_zerodivide.
          ENDTRY.
        ENDIF.
      ENDIF.
    ENDIF.

    CLEAR: lv_wrbtr,lv_belnr.

    IF 'ZLUT' IN s_fkart[].
      wa_final-amount = wa_vbrp-netwr.
    ENDIF.


    READ TABLE it_vbrk INTO wa_vbrk WITH KEY vbeln = wa_vbrp-vbeln.
    IF sy-subrc = 0.
      SELECT SINGLE vtext
                 FROM tvzbt
                 INTO @DATA(lv_zterm_txt)
                 WHERE spras EQ 'E'
      AND  zterm EQ @wa_vbrk-zterm.
      wa_final-zterm = lv_zterm_txt.

    ENDIF.

    READ TABLE it_vbrk INTO wa_vbrk WITH KEY vbeln = wa_vbrp-vbeln.
    wa_final-rfbsk = wa_vbrk-rfbsk.

    IF wa_vbrk-vbtyp = 'N' OR wa_vbrk-vbtyp = 'O'.
      wa_final-netwr  = wa_vbrp-netwr * -1. " commented by naga on 15-12-2022 "uncommented by surabhi 20.01.2023
*      wa_final-netwr  = wa_vbrk-netwr * -1. " added by naga on 15-12-2022
    ELSE.
      wa_final-netwr  = wa_vbrp-netwr. " commented by naga on 15-12-2022 "uncommented by surabhi 20.01.2023
*      wa_final-netwr  = wa_vbrk-netwr. " added by naga on 15-12-2022
    ENDIF.


    IF  wa_vbrk-waerk NE 'INR'.
      wa_final-item_sale = ( wa_final-item_sale * wa_vbrk-kurrf ).
      wa_final-netwr = wa_final-netwr.
      wa_final-sales_inr = ( wa_final-netwr * wa_vbrk-kurrf ).
    ELSE.
      wa_final-sales_inr = wa_final-netwr .
    ENDIF.


*    IF WA_VBRK-VBTYP = 'P' OR WA_VBRK-VBTYP = 'O'.
*      WA_FINAL-ZUONR   = WA_VBRK-ZUONR.
*    ENDIF.


    SELECT SINGLE vbelv        "Added by VArsha
                   FROM vbfa
                   INTO wa_final-inv_r
                   WHERE vbeln EQ wa_vbrp-aubel AND vbtyp_v EQ 'M'.

    IF wa_vbrk-vbtyp = 'P' OR wa_vbrk-vbtyp = 'O'.
      READ TABLE it_vbap INTO wa_vbap WITH KEY
      vbeln = wa_vbrp-aubel posnr = wa_vbrp-aupos.
      IF sy-subrc EQ 0.

        READ TABLE it_bkpf1 INTO wa_bkpf1
          WITH KEY belnr = wa_vbap-vgbel.
        IF sy-subrc EQ 0.
          "WA_FINAL-INV_R   = WA_BKPF1-XBLNR.      "Commented by VARSHA
          "wa_final-inv_r   = wa_bkpf1-belnr.
          wa_final-ref_invd = wa_bkpf1-bldat.
        ENDIF.
      ENDIF.
    ENDIF.


    wa_final-matnr  = wa_vbrp-matnr.
    SELECT SINGLE matkl,extwg
             FROM mara
             INTO ( @wa_final-matkl,@wa_final-extwg ) WHERE matnr =  @wa_vbrp-matnr.
    IF sy-subrc = 0.
      SELECT SINGLE wgbez FROM t023t INTO wa_final-matkl_d WHERE matkl =  wa_final-matkl AND spras = 'E'.
      SELECT SINGLE ewbez FROM twewt INTO wa_final-ewbez WHERE spras = 'E' AND extwg = wa_final-extwg.
    ENDIF.


    READ TABLE it_glc INTO wa_glc
    WITH KEY knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr kvsl1 = 'ERL' .
    IF sy-subrc = '0'.
      wa_final-gl_no = wa_glc-sakn1.
    ENDIF.
    READ TABLE it_gld INTO wa_gld
    WITH KEY saknr = wa_glc-sakn1.
    IF sy-subrc = '0'.
      wa_final-gl_descp = wa_gld-txt50.
    ENDIF.
    CLEAR:wa_glc,wa_gld.

*    SELECT SINGLE maktx INTO wa_final-maktx FROM makt
*                   WHERE matnr = wa_final-matnr
*    AND   spras = 'EN'.
    wa_final-maktx = wa_vbrp-arktx.
    wa_final-charg  = wa_vbrp-charg.
    wa_final-pstyv  = wa_vbrp-pstyv.
    wa_final-spart  = wa_vbrp-spart.
    wa_final-werks  = wa_vbrp-werks.
    wa_final-vkgrp = wa_vbrp-vkgrp.
    wa_final-vkbur  = wa_vbrp-vkbur.
    wa_final-bzirk_auft = wa_vbrp-bzirk_auft.
    IF wa_vbrk-vbtyp = 'N' OR wa_vbrk-vbtyp = 'O'.
      wa_final-kzwi3 =  wa_vbrp-kzwi3 + wa_final-zjt * -1.
    ELSE.
      wa_final-kzwi3 =  wa_vbrp-kzwi3 + wa_final-zjt.
    ENDIF.

    IF ( wa_vbrk-fkart = 'YINF' OR wa_vbrk-fkart = 'YMIF' OR wa_vbrk-fkart = 'YPMF' OR
         wa_vbrk-fkart = 'YSAF' OR wa_vbrk-fkart = 'YTDF' OR wa_vbrk-fkart = 'YTRF' ) AND
         wa_vbrk-waerk NE 'INR'.
      IF wa_vbrk-vkorg = '1100'.
        CLEAR:wa_final-kzwi3.
        wa_final-kzwi3 = wa_vbrp-kzwi4.
        wa_final-kzwi3 =  ( wa_final-kzwi3 * wa_vbrk-kurrf ) + wa_final-zjt.
      ENDIF.
    ELSEIF
       ( wa_vbrk-fkart = 'YINF' OR wa_vbrk-fkart = 'YMIF' OR wa_vbrk-fkart = 'YPMF' OR
        wa_vbrk-fkart = 'YSAF' OR wa_vbrk-fkart = 'YTDF' OR wa_vbrk-fkart = 'YTRF' ) AND
        wa_vbrk-waerk = 'INR'.
      IF wa_vbrk-vkorg = '1100'.
        CLEAR:wa_final-kzwi3.
        wa_final-kzwi3 = wa_vbrp-kzwi4.
      ENDIF.
    ENDIF.
***************EOC*************

    IF ( wa_vbrk-fkart = 'YINF' OR wa_vbrk-fkart = 'YMIF' OR wa_vbrk-fkart = 'YPMF' OR
         wa_vbrk-fkart = 'YSAF' OR wa_vbrk-fkart = 'YTDF' OR wa_vbrk-fkart = 'YTRF' ) AND
       wa_vbrk-waerk NE 'INR'.

      wa_final-grossamt = ( wa_vbrp-kzwi1 * wa_vbrk-kurrf ).
    ELSE.
      wa_final-grossamt = wa_vbrp-kzwi1.
    ENDIF.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = wa_vbrp-prctr
      IMPORTING
        output = wa_final-prctr.

    SELECT SINGLE bezei INTO wa_final-vtext5 FROM tvkbt WHERE spras = 'EN'
    AND vkbur = wa_final-vkbur.
    SELECT SINGLE bezei INTO wa_final-vtext6 FROM tvgrt WHERE spras = 'EN'
    AND vkgrp = wa_final-vkgrp.
    CLEAR : locname.
    IF wa_final-werks IS NOT INITIAL.
      SELECT name1 FROM t001w INTO locname WHERE werks = wa_final-werks
                                                             AND spras = sy-langu.
        wa_final-locname = locname.
      ENDSELECT.
    ENDIF.



************* LR_NO
    SELECT SINGLE * FROM ztransp_d INTO wa_ztransp_d WHERE zbill_no = wa_vbrk-vbeln.
*    PERFORM READ_TEXT USING 'VBBK'
*                             WA_VBRK-VBELN
*                             'Z003'
*                             CHANGING WA_FINAL-LRNO.
*    TRANSLATE  WA_FINAL-LRNO TO UPPER CASE.
*    IF WA_FINAL-LRNO IS INITIAL.
*      WA_FINAL-LRNO = WA_ZTRANSP_D-ZLR_NO.
*    ENDIF.
************** LR_DATE
*    PERFORM READ_TEXT USING 'VBBK'
*                             WA_VBRK-VBELN
*                             'Z000'
*                             CHANGING WA_FINAL-LRDATE.
*    CONCATENATE WA_VBRP-VBELN WA_VBRP-POSNR INTO DATA(V_NAME).
*    IF WA_FINAL-LRDATE IS INITIAL.
*      WA_FINAL-LRDATE = WA_ZTRANSP_D-ZLR_DATE.
*    ENDIF.
    DATA : lv_lr TYPE zupload.
    SELECT * FROM zupload INTO lv_lr WHERE vbeln = wa_vbrk-vbeln.
    ENDSELECT.
    IF sy-subrc = 0.
      wa_final-lrno = lv_lr-bolnr.
      wa_final-lrdate = lv_lr-lrdate.
    ENDIF.
*    PERFORM READ_TEXT USING 'VBBK'
*                         WA_VBRK-VBELN
*                         'Z004'
*                         CHANGING WA_FINAL-VEH_NO.
*    IF WA_FINAL-VEH_NO IS INITIAL.
*      WA_FINAL-VEH_NO = WA_ZTRANSP_D-ZVEHICAL.
*    ENDIF.
    DATA: lv_veh TYPE zteway_transport-v_number .
    SELECT v_number FROM zteway_transport INTO lv_veh WHERE bukrs = wa_vbrk-bukrs AND docno =  wa_vbrk-vbeln  AND doctyp =  wa_vbrk-fkart.
    ENDSELECT.
    IF sy-subrc = 0.
      wa_final-veh_no = lv_veh.
    ENDIF.

    TRANSLATE wa_final-veh_no TO UPPER CASE.
    TRANSLATE wa_final-lrno TO UPPER CASE.
*    IF WA_FINAL-LFMNG IS INITIAL.
*      PERFORM READ_TEXT USING 'VBBP'
*                                 V_NAME
*                                 'Z020'
*                                 CHANGING WA_FINAL-LFMNG.
*    ENDIF.

    LOOP AT it_vbpa INTO DATA(wa_vbpa).
      CASE wa_vbpa-parvw.
        WHEN 'RE'.
          SELECT SINGLE * FROM kna1
                 INTO @DATA(st_kna1)
          WHERE kunnr = @wa_vbpa-kunnr.
          wa_final-btp_code = wa_vbpa-kunnr.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
            EXPORTING
              input  = wa_final-btp_code
            IMPORTING
              output = wa_final-btp_code.
          CONCATENATE st_kna1-name1 st_kna1-name2 INTO wa_final-btp_name SEPARATED BY space.
          wa_final-btp_gstno = st_kna1-stcd3.
        WHEN 'WE' OR 'ZH'.
          SELECT SINGLE * FROM kna1
                 INTO st_kna1
          WHERE kunnr = wa_vbpa-kunnr.
          wa_final-stp_code = wa_vbpa-kunnr.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
            EXPORTING
              input  = wa_final-stp_code
            IMPORTING
              output = wa_final-stp_code.
          CONCATENATE st_kna1-name1 st_kna1-name2 INTO wa_final-stp_name SEPARATED BY space.
          wa_final-stp_gstno = st_kna1-stcd3.

          SELECT SINGLE kdgrp
                 FROM knvv
                 INTO @DATA(lv_kdgrp)
                 WHERE kunnr = @wa_vbpa-kunnr
                 AND vkorg = ( SELECT DISTINCT vkorg FROM vbrk WHERE vbeln = @wa_vbrp-vbeln )
          AND vtweg = ( SELECT DISTINCT vtweg FROM vbrk WHERE vbeln = @wa_vbrp-vbeln ).
          IF sy-subrc = 0.
            SELECT SINGLE ktext
                   FROM t151t
                   INTO @DATA(lv_ktext)
                   WHERE kdgrp = @lv_kdgrp
            AND spras = @sy-langu.
            IF sy-subrc = 0.
              wa_final-ktext = lv_ktext.
            ENDIF.
            wa_final-kdgrp = lv_kdgrp.
          ENDIF.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.

    SELECT SINGLE landx
           FROM t005t
           INTO @DATA(lv_landx)
            WHERE spras  = @sy-langu
    AND  land1 = @st_kna1-land1.

    wa_final-landx = lv_landx.

    CLEAR: wa_vbpa, st_kna1.
*    REFRESH: it_vbpa.

*    SELECT SINGLE NAME1
*         FROM LFA1
*         INTO @DATA(LV_TRNS_NME)
*         WHERE LIFNR EQ ( SELECT DISTINCT LIFNR
*                                 FROM VBPA
*                                 WHERE VBELN EQ @WA_VBRP-VBELN AND
*    PARVW EQ 'ZT' ).
    DATA : lv_trns_nme TYPE ztransport.
    SELECT * FROM ztransport INTO lv_trns_nme  WHERE kunnr = wa_vbrk-kunag.
    ENDSELECT.
    IF sy-subrc = 0.
* TRANSLATE LV_TRANSNAME TO UPPER CASE.
*WA_FINAL-TRNS_NAME = LV_TRANSNAME.
*CLEAR LV_TRANSNAME.
*ENDIF.
      TRANSLATE lv_trns_nme TO UPPER CASE.
      wa_final-trns_name = lv_trns_nme-trpname.
      CLEAR: lv_trns_nme.
    ENDIF.
    SELECT SINGLE name1
           FROM lfa1
           INTO @DATA(lv_lia_nme)
           WHERE lifnr EQ ( SELECT DISTINCT lifnr
                                   FROM vbpa
                                   WHERE vbeln EQ @wa_vbrp-vbeln AND
    parvw EQ 'ZL' ).
    wa_final-lia_name = lv_lia_nme.
    CLEAR: lv_lia_nme.

    wa_final-aubel = wa_vbrp-aubel.
    SELECT SINGLE audat
           FROM vbak
           INTO @DATA(lv_audat)
    WHERE vbeln = @wa_vbrp-aubel.
    wa_final-audat = lv_audat.
    wa_final-vgbel = wa_vbrp-vgbel.

    SELECT SINGLE wadat_ist
           FROM likp
           INTO @DATA(lv_wadat_ist)
    WHERE vbeln = @wa_vbrp-vgbel.
    wa_final-wadat_ist = lv_wadat_ist.

    SELECT SINGLE bstkd, bstdk
           FROM vbkd
           INTO @DATA(st_vbkd)
    WHERE vbeln EQ @wa_vbrp-aubel.

    wa_final-bstkd = st_vbkd-bstkd.
    wa_final-bstdk1 = st_vbkd-bstdk.
    CLEAR: st_vbkd.

    CALL FUNCTION 'DD_DOMA_GET'
      EXPORTING
        domain_name   = 'VF_STATUS'
*       GET_STATE     = 'M  '
        langu         = sy-langu
*       PRID          = 0
        withtext      = 'X'
      TABLES
        dd07v_tab_a   = it_taba
        dd07v_tab_n   = it_tabb
      EXCEPTIONS
        illegal_value = 1
        op_failure    = 2
        OTHERS        = 3.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
    READ TABLE it_taba INTO DATA(wa_vfstatus) WITH KEY domvalue_l = wa_vbrk-vf_status.
    wa_final-vf_status = wa_vfstatus-ddtext.
    CLEAR: wa_vfstatus.
    REFRESH: it_taba, it_tabb.
    CALL FUNCTION 'DD_DOMA_GET'
      EXPORTING
        domain_name   = 'BUCHK'
*       GET_STATE     = 'M  '
        langu         = sy-langu
*       PRID          = 0
        withtext      = 'X'
      TABLES
        dd07v_tab_a   = it_taba
        dd07v_tab_n   = it_tabb
      EXCEPTIONS
        illegal_value = 1
        op_failure    = 2
        OTHERS        = 3.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
    READ TABLE it_taba INTO DATA(wa_buchk) WITH KEY domvalue_l = wa_vbrk-buchk.
    wa_final-buchk = wa_buchk-ddtext.
    CLEAR: wa_buchk.
    REFRESH: it_taba, it_tabb.
    SELECT SINGLE bstnk, bstdk
           FROM vbak
           INTO @DATA(st_vbak)
           WHERE vbeln EQ ( SELECT DISTINCT vgbel
                                   FROM vbrp
                                   WHERE vbeln EQ @wa_vbrp-vbeln
    AND posnr EQ @wa_vbrp-posnr ).
    wa_final-bstnk = st_vbak-bstnk.
    wa_final-bstdk = st_vbak-bstdk.
    SELECT SINGLE vbelv
           FROM vbfa
           INTO @DATA(lv_quotation)
           WHERE vbtyp_v EQ 'B'
            AND  vbeln EQ ( SELECT DISTINCT aubel
                                   FROM vbrp
                                   WHERE vbeln EQ @wa_vbrp-vbeln
    AND posnr EQ @wa_vbrp-posnr ).
    wa_final-quotation = lv_quotation.

    SELECT SINGLE vbelv
           FROM vbfa
           INTO @DATA(lv_contract)
           WHERE vbtyp_v EQ 'G'
            AND  vbeln EQ ( SELECT DISTINCT aubel
                                   FROM vbrp
                                   WHERE vbeln EQ @wa_vbrp-vbeln
    AND posnr EQ @wa_vbrp-posnr ).
    wa_final-contract = lv_contract.

    SELECT SINGLE vtext
           FROM t188t
           INTO @DATA(lv_vtext)
           WHERE spras = 'E'
            AND  konda = ( SELECT DISTINCT konda
                                  FROM vbrk
    WHERE vbeln = @wa_vbrk-vbeln ).
    wa_final-pgroup = lv_vtext.
    SELECT SINGLE kvgr1
                                      FROM vbak INTO wa_final-kvgr1
    WHERE vbeln = wa_vbrp-aubel.
    SELECT SINGLE bezei
           FROM tvv1t
           INTO @DATA(lv_cgrp1)
           WHERE spras = 'E'
    AND  kvgr1 = @wa_final-kvgr1.
    wa_final-cgrp1 = lv_cgrp1.
    SELECT SINGLE vfdat
           FROM mcha
           INTO @DATA(lv_vfdat)
           WHERE matnr = @wa_vbrp-matnr
            AND  werks = @wa_vbrp-werks
    AND  charg = @wa_vbrp-charg.
    IF wa_vbrk-vbtyp = 'N' OR wa_vbrk-vbtyp = 'O'.
      wa_final-invvalue = wa_vbrp-kzwi4 * -1.
    ELSE.
      wa_final-invvalue = wa_vbrp-kzwi4.
    ENDIF.
    IF ( wa_vbrk-fkart = 'YINF' OR wa_vbrk-fkart = 'YMIF' OR wa_vbrk-fkart = 'YPMF' OR
          wa_vbrk-fkart = 'YSAF' OR wa_vbrk-fkart = 'YTDF' OR wa_vbrk-fkart = 'YTRF' ) AND
          wa_vbrk-waerk NE 'INR'.
      IF wa_vbrk-vkorg = '1100'.
        CLEAR:wa_final-invvalue.
        wa_final-invvalue = wa_vbrp-kzwi3.
        wa_final-invvalue = ( wa_final-invvalue * wa_vbrk-kurrf ).

        wa_final-invvalue = ( wa_final-netwr + wa_final-kzwi3 ).
      ENDIF.
    ELSEIF
          ( wa_vbrk-fkart = 'YINF' OR wa_vbrk-fkart = 'YMIF' OR wa_vbrk-fkart = 'YPMF' OR
            wa_vbrk-fkart = 'YSAF' OR wa_vbrk-fkart = 'YTDF' OR wa_vbrk-fkart = 'YTRF' ) AND
            wa_vbrk-waerk = 'INR'.
      IF wa_vbrk-vkorg = '1100'.
        CLEAR:wa_final-invvalue.
        wa_final-invvalue = wa_vbrp-kzwi3.

        wa_final-invvalue = ( wa_final-netwr + wa_final-kzwi3 ).
      ENDIF.
    ENDIF.


    SELECT SINGLE bztxt FROM t171t INTO wa_final-bztxt
                         WHERE spras = 'EN'
    AND  bzirk =  wa_final-bzirk_auft.
    CLEAR : steuc,maabc.
    SELECT SINGLE steuc maabc FROM marc INTO ( steuc,maabc )
                         WHERE matnr = wa_final-matnr AND werks = wa_final-werks.
    wa_final-steuc = steuc.
    wa_final-abc_ind = maabc.
    SELECT SINGLE tmabc FROM tmabct INTO wa_final-abc_dind WHERE maabc = maabc AND spras = 'EN'.
    SELECT  prsfd INTO prsfd FROM tvap
                         WHERE pstyv = wa_final-pstyv.
      wa_final-prsfd = prsfd.
    ENDSELECT.
    IF wa_final-prsfd = 'X'.
      wa_final-billqty = wa_vbrp-fkimg.
    ELSEIF wa_final-prsfd = ' '.
      wa_final-freeqty = wa_vbrp-fkimg.
    ENDIF.

*************added by surabhi 03.05.2023 told by pratik
    IF wa_vbrk-fkart = 'ZREN' .
      wa_final-billqty = wa_final-billqty * -1.
    ENDIF.
****************************************

    READ TABLE it_vbrk INTO wa_vbrk WITH KEY vbeln = wa_vbrp-vbeln.

    IF sy-subrc = 0.
      wa_final-fkart = wa_vbrk-fkart.
      wa_final-fktyp = wa_vbrk-fktyp.
      wa_final-waerk = wa_vbrk-waerk.
      wa_final-vkorg = wa_vbrk-vkorg.
      wa_final-vtweg = wa_vbrk-vtweg.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = wa_vbrk-kunag
        IMPORTING
          output = wa_final-kunag.

      wa_final-spart = wa_vbrp-spart.
      wa_final-belnr = wa_vbrk-belnr.
      wa_final-mwsbk = wa_vbrk-mwsbk.
      wa_final-bupla = wa_vbrk-bupla.
      wa_final-bukrs = wa_vbrk-bukrs.
      SELECT SINGLE lfmng ktgrm scmng  mvgr1 FROM mvke INTO ( v_lfmng , wa_final-ktgrm , v_scmng, v_mvgr1 ) WHERE matnr = wa_final-matnr
                                                         AND  vkorg = wa_final-vkorg
                                                          AND  vtweg = wa_final-vtweg.
      DATA : lv_mvke TYPE mvke-mvgr4.
      SELECT mvgr4 FROM mvke INTO lv_mvke WHERE matnr = wa_final-matnr.
      ENDSELECT.
      IF wa_final-lfmng IS INITIAL.
*          WA_FINAL-LFMNG = V_LFMNG.
        "WA_FINAL-LFMNG = V_SCMNG.
        wa_final-lfmng = lv_mvke.
      ENDIF.

      IF wa_final-matnr IS NOT INITIAL.
        wa_final-mvgr1 = v_mvgr1.
      ENDIF.

      """""""""" Added by Pavan 20-12-2-23
      SELECT SINGLE bezei FROM tvm1t INTO ( v_bezei1 ) WHERE mvgr1 = wa_final-mvgr1.

      IF wa_final-mvgr1 IS NOT INITIAL.
        wa_final-bezei1 = v_bezei1.
      ENDIF.

      IF wa_final-vkorg IS NOT INITIAL.
        SELECT SINGLE vtext FROM tvkot INTO wa_final-vtext WHERE spras = sy-langu
        AND vkorg = wa_final-vkorg.
      ENDIF.
      IF wa_final-vtweg IS NOT INITIAL.
        SELECT SINGLE vtext FROM tvtwt INTO wa_final-vtext1 WHERE spras = sy-langu
        AND vtweg = wa_final-vtweg.
      ENDIF.
      IF wa_final-spart IS NOT INITIAL.
        SELECT SINGLE vtext FROM tspat INTO wa_final-vtext2 WHERE spras = sy-langu
        AND spart = wa_final-spart.
      ENDIF.
      IF wa_final-fkart IS NOT INITIAL.
        SELECT SINGLE vtext FROM tvfkt INTO wa_final-vtext3 WHERE spras = sy-langu
        AND fkart = wa_final-fkart.
      ENDIF.
      IF wa_final-ktgrm IS NOT INITIAL.
        SELECT SINGLE vtext FROM tvkmt INTO wa_final-vtext4 WHERE spras = sy-langu
        AND ktgrm = wa_final-ktgrm.
      ENDIF.

      SELECT SINGLE gstin FROM  j_1bbranch INTO wa_final-gstin
                        WHERE bukrs = wa_final-bukrs
      AND  branch = wa_final-bupla.

    ENDIF.
    IF ( wa_vbrk-fkart = 'YINF' OR wa_vbrk-fkart = 'YMIF' OR wa_vbrk-fkart = 'YPMF' OR
          wa_vbrk-fkart = 'YSAF' OR wa_vbrk-fkart = 'YTDF' OR wa_vbrk-fkart = 'YTRF' ) AND
          wa_vbrk-waerk NE 'INR'.

      wa_final-waerk = 'INR'.
    ENDIF.

    READ TABLE it_kna1 INTO wa_kna1 WITH KEY kunnr = wa_vbrk-kunag.
    IF sy-subrc = 0.
      wa_final-kunnr = wa_kna1-kunnr.
      CONCATENATE wa_kna1-name1 wa_kna1-name2 wa_kna1-name3 wa_kna1-name4 INTO lv_cust_name SEPARATED BY space.
      wa_final-name1 = lv_cust_name.
      CLEAR: lv_cust_name.
      wa_final-regio = wa_kna1-regio.
      wa_final-stcd3 = wa_kna1-stcd3.
      wa_final-pan_no = wa_kna1-pan_no.

      IF wa_final-kunnr IS NOT INITIAL.
*        READ TABLE it_zgst_region_map INTO wa_zgst_region_map WITH KEY land1 = wa_kna1-land1 regio = wa_kna1-regio.
        READ TABLE it_zgst_region_map INTO wa_zgst_region_map WITH KEY land1 = wa_kna1-land1 std_state_code = wa_kna1-regio.

        IF sy-subrc = 0.
*          wa_final-zgstr = wa_zgst_region_map-zgstr.
          wa_final-zgstr = wa_zgst_region_map-std_state_code.
          wa_final-bezei = wa_zgst_region_map-bezei.

        ENDIF.

      ENDIF.
    ENDIF.

**************************************Start of Addition By MayurB 12/07/23  <DS4K905313>***************************

    SELECT SINGLE ind_sector
                  FROM but0is
                  INTO @wa_final-industry_cd
                  WHERE partner = @wa_final-kunnr.

    SELECT SINGLE text
                  FROM tb038b
                  INTO @wa_final-industry_dscr
                  WHERE ind_sector = @wa_final-industry_cd.

********************End of Addition <DS4K905313>**************************************
    LOOP AT  it_konv INTO wa_konv WHERE knumv = wa_vbrk-knumv
                                        AND kposn = wa_vbrp-posnr.
      IF wa_konv-kschl = 'PTS1'.
        wa_final-prdctrate = wa_konv-kbetr.

      ELSEIF  wa_konv-kschl = 'ZNRV'. "'ZRET'.
        wa_final-ptr = wa_konv-kbetr.

      ELSEIF  wa_konv-kschl = 'ZTDS'.
        wa_final-tdsvalue = wa_konv-kbetr.

      ELSEIF wa_konv-kschl = 'ZL00'.
        wa_final-lir_name = wa_konv-kwert.
        wa_final-lir_com = wa_konv-kbetr.

      ELSEIF wa_konv-kschl = 'ZTRV'.
        wa_final-trv_rate = wa_konv-kbetr.

      ELSEIF  wa_konv-kschl = 'ZTAR'.
        wa_final-targetrate = wa_konv-kbetr.
        wa_final-targetamount = wa_konv-kwert.

      ELSEIF  wa_konv-kschl = 'ZMRP'.
        wa_final-mrp = wa_konv-kwert.

      ELSEIF  wa_konv-kschl = 'PTR1'.
        wa_final-ptr = wa_konv-kwert.

      ELSEIF  wa_konv-kschl = 'PTS1'.
        wa_final-pts = wa_konv-kwert.

      ELSEIF  wa_konv-kschl = 'ZRAT'.

        wa_final-strdiscnt = wa_konv-kwert.

      ELSEIF  wa_konv-kschl = 'ZCSH'.

        wa_final-cashdiscnt = wa_konv-kbetr.

      ELSEIF  wa_konv-kschl = 'JOCG'.

        wa_final-cgstrate = wa_konv-kbetr.
        IF wa_vbrk-vbtyp = 'N' OR wa_vbrk-vbtyp = 'O'.
          wa_final-cgstvalue = wa_konv-kwert * -1.
        ELSE.
          wa_final-cgstvalue = wa_konv-kwert.
        ENDIF.


      ELSEIF  wa_konv-kschl = 'JOSG'.

        wa_final-sgstrate = wa_konv-kbetr.
        IF wa_vbrk-vbtyp = 'N' OR wa_vbrk-vbtyp = 'O'.
          wa_final-sgstvalue = wa_konv-kwert * -1.
        ELSE.
          wa_final-sgstvalue = wa_konv-kwert.
        ENDIF.

      ELSEIF  wa_konv-kschl = 'JOIG'.
        wa_final-igstrate = wa_konv-kbetr.
        IF wa_vbrk-vbtyp = 'N' OR wa_vbrk-vbtyp = 'O'.
          wa_final-igstvalue = wa_konv-kwert * -1.
        ELSE.
          wa_final-igstvalue = wa_konv-kwert.
        ENDIF.

        IF  wa_vbrk-waerk NE 'INR'.
          wa_final-igstvalue = wa_final-igstvalue .
          wa_final-igst_inr = ( wa_final-igstvalue * wa_vbrk-kurrf ).

        ELSE.
          wa_final-igst_inr = wa_final-igstvalue .

        ENDIF.

      ENDIF.

      wa_final-targetvalue =  wa_final-targetamount + wa_final-strdiscnt + wa_final-cashdiscnt.
      CLEAR : wa_konv.
    ENDLOOP.


    CLEAR : wa_final-kzwi3.
    IF  wa_final-igstvalue IS INITIAL.
      wa_final-kzwi3 =  wa_final-sgstvalue + wa_final-cgstvalue + wa_final-zjt.
    ELSE.
      wa_final-kzwi3 =  wa_final-igstvalue + wa_final-zjt.
    ENDIF.


    CLEAR wa_final-invvalue.
    IF wa_final-waerk = 'INR'.
      wa_final-invvalue = wa_final-kzwi3 + wa_final-netwr.
    ELSE.
      wa_final-invvalue = wa_final-kzwi3 + wa_final-netwr.
      wa_final-invvalue = wa_final-invvalue * wa_vbrk-kurrf.
      wa_final-kzwi3 = wa_final-kzwi3 * wa_vbrk-kurrf.
    ENDIF.


    IF wa_final-fkart = 'ZLU1' OR
       wa_final-fkart = 'ZLUT'  .
      CLEAR : wa_final-kzwi3,
*              WA_FINAL-IGST_INR,
              wa_final-igstvalue,
              wa_final-igstrate.
    ENDIF.

    SHIFT wa_final-matnr LEFT DELETING LEADING '000000000000'.

    IF wa_final-igstvalue IS NOT INITIAL.
      wa_final-state = 'INTER STATE'.
    ELSEIF wa_final-cgstvalue IS NOT INITIAL AND wa_final-sgstvalue IS NOT INITIAL.
      wa_final-state = 'INTRA STATE'.
    ENDIF.


    IF wa_vbrk-waerk NE 'INR'. " commented by naga on 15-12-2022 " uncommented by surabhi 20.01.2023
*    IF wa_vbrk-waerk EQ'INR'. " added by naga on 15-12-2022
      wa_final-netwr = wa_final-netwr.
    ENDIF.
    READ TABLE it_vbpa INTO wa_vbpa WITH KEY vbeln = wa_vbrp-vbeln parvw = 'VE'.

    "START OF ADDITION ABAP01
    IF it_knvp IS NOT INITIAL.
      READ TABLE it_vbpa ASSIGNING FIELD-SYMBOL(<fs_vbpa>) WITH KEY vbeln = wa_vbrp-vbeln
                                                                    parvw = 'AG'.
      IF <fs_vbpa> IS ASSIGNED.
        READ TABLE it_knvp INTO wa_knvp WITH KEY kunnr = <fs_vbpa>-kunnr  BINARY SEARCH.
        IF sy-subrc = 0.
          SELECT SINGLE ename FROM pa0001 INTO wa_final-uename WHERE pernr = wa_knvp-pernr.
        ENDIF.
      ENDIF.
      CLEAR wa_knvp. "++abap01
      FREE <fs_vbpa>.
    ENDIF.
    "END OF ADDITION ABAP01

    IF sy-subrc = 0.
      SELECT SINGLE ename FROM pa0001 INTO wa_final-ename WHERE pernr = wa_vbpa-pernr.
    ENDIF.
    CLEAR wa_vbpa.


    READ TABLE it_vbpa INTO wa_vbpa WITH KEY vbeln = wa_vbrp-vbeln parvw = 'ZA'.

    IF sy-subrc = 0.
      SELECT SINGLE name1 FROM kna1 INTO wa_final-sales_agent WHERE kunnr = wa_vbpa-kunnr.
    ENDIF.
    CLEAR :wa_vbpa.

    im_inv_num = wa_final-vbeln.
*    CALL METHOD OBJ->GET_DATA_ADOBE
*      EXPORTING
*        IM_INV_NUM  = IM_INV_NUM
*      IMPORTING
*        E_EDOINEINV = E_EDOINEINV.
*
*    WA_FINAL-IRN    = E_EDOINEINV-INV_REG_NUM.
*    IF E_EDOINEINV-EWBNO IS NOT INITIAL.
*      WA_FINAL-EWBNO  = E_EDOINEINV-EWBNO.
*      WA_FINAL-EWBDT  = E_EDOINEINV-EWB_CREATE_DATE.
*    ENDIF.



*********************added by surabhi 18.01.2023
*    CALL METHOD OBJ->GET_DATA_EWAY
*      EXPORTING
*        IM_INV_NUM = IM_INV_NUM
*      IMPORTING
*        E_EDOINEWB = E_EDOINEWB.
*
*    IF WA_FINAL-EWBNO IS INITIAL AND E_EDOINEWB-EWB_NUMBER IS NOT INITIAL.
*      WA_FINAL-EWBNO  = E_EDOINEWB-EWB_NUMBER.
*      WA_FINAL-EWBDT  = E_EDOINEWB-EWB_CREATE_DATE.
*    ENDIF.
*****************************************************
****************added by surabhi 08.01.2022
*    SELECT SINGLE zfbdt FROM bsid INTO wa_final-duedt WHERE belnr = wa_vbrk-belnr.
    SELECT bukrs,docno,doc_year,doc_type,irn,erdat FROM j_1ig_invrefnum INTO TABLE @DATA(it_irn) FOR ALL ENTRIES IN
        @it_vbrk WHERE bukrs = @it_vbrk-bukrs AND docno =  @it_vbrk-vbeln AND doc_year =  @it_vbrk-gjahr AND doc_type =  @it_vbrk-fkart.


    READ TABLE it_irn INTO DATA(wa_irn) WITH KEY bukrs = wa_vbrk-bukrs docno = wa_vbrk-vbeln doc_year = wa_vbrk-gjahr doc_type = wa_vbrk-fkart.
    IF sy-subrc = 0.
      wa_final-irn = wa_irn-irn.
      wa_final-erdat = wa_irn-erdat.
*      wa_final-ewbno = wa_irn-ewbno.
*      wa_final-ewbdt = wa_irn-ewbdt.
      CLEAR : wa_irn.
    ENDIF.
    DATA : lv_eway TYPE j_1ig_ewaybill.
    SELECT * FROM j_1ig_ewaybill INTO lv_eway WHERE bukrs = wa_vbrk-bukrs AND docno =  wa_vbrk-vbeln  AND doctyp =  wa_vbrk-fkart.
    ENDSELECT.
    IF sy-subrc = 0.
      wa_final-ewbno = lv_eway-ebillno.
      wa_final-ewbdt = lv_eway-egen_dat.
    ENDIF.
    SELECT SINGLE *
               FROM t052
               INTO @DATA(lv_payment_term)
               WHERE zterm = @wa_vbrk-zterm.
    wa_final-duedt = wa_vbrk-fkdat + lv_payment_term-ztag1.
***********************************************
    wa_final-ship_bil_no   = wa_ztransp_d-zship_n.
    wa_final-ship_bil_date = wa_ztransp_d-zship_d.
    IF wa_vbrp-netwr IS NOT INITIAL OR wa_vbrp-fkimg IS NOT INITIAL.
*      WA_FINAL-RATE = WA_VBRP-NETWR / WA_VBRP-FKIMG.
      "WA_FINAL-RATE = WA_FINAL-ITEM_SALE / WA_VBRP-FKIMG.
*      WA_FINAL-RATE1 = WA_FINAL-ITEM_SALE1 / WA_VBRP-FKIMG.
    ENDIF.
*    IF WA_FINAL-RATE IS NOT INITIAL.
*      WA_FINAL-COGSPR = ( WA_FINAL-RATE - WA_FINAL-COGS ) / WA_FINAL-RATE.
*    ENDIF.
    wa_final-mwsbk = wa_final-mwsbk * wa_vbrk-kurrf.
    wa_final-ernam = wa_vbrp-ernam.
    wa_final-fkdat = wa_vbrk-fkdat.
    IF sy-subrc = 0.
      wa_final-con_fact = wa_vbrp-umvkz / wa_vbrp-umvkn.
    ENDIF.
    wa_final-inco1 = wa_vbrk-inco1.
    READ TABLE it_tinct INTO DATA(wa_tinct) WITH KEY inco1 = wa_vbrk-inco1 spras = 'E'.
    IF sy-subrc = 0.
      wa_final-inco1_d = wa_tinct-bezei.
    ENDIF.
    wa_final-std_val = wa_final-ppcip * wa_final-billqty.
    IF wa_vbrk-fkart EQ 'ZCRM' OR wa_vbrk-fkart = 'ZREN'.
      wa_final-fkimg = wa_final-fkimg * -1.
      IF wa_final-netwr > 0.
        wa_final-netwr = wa_final-netwr * -1.
      ENDIF.
      IF wa_final-billqty > 0.
        wa_final-billqty = wa_final-billqty * -1.
      ENDIF.
      IF wa_final-cgstvalue > 0 .
        wa_final-cgstvalue = wa_final-cgstvalue * -1.
      ENDIF.
      IF wa_final-sgstvalue > 0 .
        wa_final-sgstvalue = wa_final-sgstvalue * -1.
      ENDIF.
      IF wa_final-igstvalue > 0 .
        wa_final-igstvalue = wa_final-igstvalue * -1.
      ENDIF.

      wa_final-grossamt = wa_final-grossamt * -1.
      wa_final-netwr1 = wa_final-netwr1 * -1.
      wa_final-targetamount = wa_final-targetamount * -1.
      wa_final-item_sale = wa_final-item_sale * -1.
      IF wa_final-sales_inr > 0.
        wa_final-sales_inr = wa_final-sales_inr * -1.
      ENDIF.
      IF wa_final-std_val > 0.          " Added By MayurB 13/07/2023
        wa_final-std_val = wa_final-std_val * -1.
      ENDIF.                            " Added By MayurB 13/07/2023

      "WA_FINAL-RATE = WA_FINAL-RATE * -1.
      wa_final-targetvalue = wa_final-targetvalue * -1.

    ENDIF.
    wa_final-base_qty = wa_vbrp-fklmg.
    wa_final-base_umo = wa_vbrp-meins.
    IF wa_final-fkart = 'S1' OR wa_final-fkart = 'S2' OR wa_final-fkart = 'S3'.

      wa_final-item_sale = wa_final-item_sale * -1.
      wa_final-item_sale1 = wa_final-item_sale1 * -1.


      wa_final-pcip_v = wa_final-pcip_v * -1. "++addition of abap01 11/02/2025



    ENDIF.
********************************** Addition of Code By MayurB 13/07/2013 <DS4K905313>*************************************
    IF wa_vbrk-fkart = 'ZREN'.
      IF wa_final-item_sale1 > 0.
        wa_final-item_sale1 = wa_final-item_sale1 * -1.
      ENDIF.
      IF wa_final-base_qty > 0.
        wa_final-base_qty = wa_final-base_qty * -1.
      ENDIF.
      IF wa_final-pcip > 0.
        wa_final-pcip     = wa_final-pcip * -1.
      ENDIF.
      IF wa_final-ppcip > 0.
        wa_final-ppcip    = wa_final-ppcip * -1.
      ENDIF.
      IF wa_final-pcip_v > 0.
        wa_final-pcip_v   = wa_final-pcip_v * -1.
      ENDIF.
      IF wa_final-pcip_v > 0.
        wa_final-pcip_v   = wa_final-pcip_v * -1.
      ENDIF.
*      IF WA_FINAL-RATE1 > 0.
*        WA_FINAL-RATE1    = WA_FINAL-RATE1 * -1.
*      ENDIF.

    ENDIF.
****************************End of Addition <DS4K905313>********************************************
***SOC ADDED BY SANJAY FUNC-TEJAS 20.07.2023
    IF r3 = 'X' AND wa_final-vf_status = 'Canceled'.
      wa_final-invvalue = wa_final-invvalue * -1.

    ENDIF.
***EOC ADDED BY SANJAY FUNC-TEJAS 20.07.2023


    IF ( wa_final-fkart = 'ZCRM' OR wa_final-fkart = 'ZDRM' ) AND wa_final-gl_no = '0030101030'.
      CLEAR: wa_final-billqty.
    ENDIF.
* IF WA_VBRK-FKART = 'ZDTP' or wa_vbrk-fkart = 'ZICS'.
*          DATA CLIENT           TYPE SY-MANDT.
*          DATA ID               TYPE THEAD-TDID.
*          DATA LANGUAGE         TYPE THEAD-TDSPRAS.
*          DATA NAME             TYPE THEAD-TDNAME.
*          DATA OBJECT           TYPE THEAD-TDOBJECT.
*          DATA ARCHIVE_HANDLE   TYPE SY-TABIX.
*          DATA HEADER           TYPE THEAD.
*          DATA OLD_LINE_COUNTER TYPE THEAD-TDTXTLINES.
*          DATA LINES            TYPE STANDARD TABLE OF TLINE.
*          DATA: LV_BELNR TYPE BELNR_D.


    CONCATENATE wa_vbrp-vbeln wa_vbrp-posnr  INTO name.
    id = 'TX19'.
    object = 'VBBP'.


    SELECT SINGLE * FROM stxl
                    INTO @DATA(wa_stxl1)
                    WHERE tdobject EQ 'VBBP' AND
                          tdname   EQ @name   AND
                          tdid     EQ 'TX19'.

    IF sy-subrc = 0.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client           = sy-mandt
          id               = id
          language         = sy-langu
          name             = name
          object           = object
          archive_handle   = 0
        IMPORTING
          header           = header
          old_line_counter = old_line_counter
        TABLES
          lines            = lines.

      IF sy-subrc = 0.
        READ TABLE lines INTO DATA(wa_lines1) INDEX 1.
        CONDENSE wa_lines1-tdline.
        DATA(lv_belnr1) = wa_lines1-tdline. "changes by ABAP01 28/7/25
        wa_final-miro = lv_belnr1. " added by naga on 17-07-2024  ,"changes by ABAP01 28/7/25
      ENDIF.
    ENDIF.

***********************************************SOC ABAP01 01.09.2025 ADDITION OF HEADER TEXT*************************************************

    SELECT SINGLE vbeln , SUM( fkimg ) AS nmnge
      FROM vbrp INTO @DATA(lv_netmnge)
      WHERE vbeln = @wa_vbrk-vbeln
      GROUP BY vbeln.   " Total quantity of the bill.

    SELECT SINGLE * FROM stxh
     INTO @ls_stxh
     WHERE  tdobject = 'VBBK'
     AND    tdname = @wa_vbrk-vbeln
     AND    tdid  = 'Z022'
     AND    tdspras = @sy-langu.

    IF sy-subrc = 0.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
*         CLIENT   = LV_MANDT
          id       = ls_stxh-tdid
          language = ls_stxh-tdspras
          name     = ls_stxh-tdname
          object   = ls_stxh-tdobject
        TABLES
          lines    = gt_lines.
*      LOOP AT GT_LINES INTO LS_LINE.
*        WA_FINAL-Z022 = LS_LINE-TDLINE.
*      ENDLOOP.
      READ TABLE gt_lines ASSIGNING FIELD-SYMBOL(<fs_lines>) INDEX 1.
      IF <fs_lines> IS ASSIGNED AND sy-subrc = 0 AND lv_netmnge IS NOT INITIAL.
        lv_unit = <fs_lines>-tdline / lv_netmnge-nmnge.
        wa_final-z022 = lv_unit * wa_vbrp-fkimg.
      ENDIF.
    ENDIF.




    SELECT SINGLE * FROM stxh
    INTO @ls_stxh
    WHERE  tdobject = 'VBBK'
    AND    tdname = @wa_vbrk-vbeln
    AND    tdid  = 'Z023'
  AND    tdspras = @sy-langu.

    IF sy-subrc = 0.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
*         CLIENT   = LV_MANDT
          id       = ls_stxh-tdid
          language = ls_stxh-tdspras
          name     = ls_stxh-tdname
          object   = ls_stxh-tdobject
        TABLES
          lines    = gt_lines.
*      LOOP AT GT_LINES INTO LS_LINE.
*        WA_FINAL-Z023 = LS_LINE-TDLINE.
*      ENDLOOP.

      READ TABLE gt_lines ASSIGNING FIELD-SYMBOL(<fs_lines1>) INDEX 1.
      IF <fs_lines1> IS ASSIGNED AND sy-subrc = 0 AND lv_netmnge IS NOT INITIAL.
        lv_unit1 = <fs_lines1>-tdline / lv_netmnge-nmnge.
        wa_final-z023 = lv_unit1 * wa_vbrp-fkimg.
      ENDIF.
    ENDIF.

***********************************************EOC ABAP01 01.09.2025 ADDITION OF HEADER TEXT*************************************************

*          ENDIF.
*DATA : LV_FREIGHT type STRING,
*        LV_INS TYPE STRING,
*         LV_PTS Type string,
*         LV_FRI  TYPE STRING,
*         LV_INS1 TYPE STRING,
*         LV_FR1 TYPE STRING,
*         LT_PRCD TYPE tt_prcd,
*        LV_PTS1 TYPE STRING,
*LV_ZJT Type string,
*lV_ZJT1 TYPE string.
*    "" EOC by naga on 17-07-2024
*
*   select KNUMV
*       KSCHL
*       KBETR
*       KWERT
*       WAERS
*     from prcd_elements into TABLE lT_prcd where KNUMV = WA_vbrk-knumv .
*
*
*IF SY-SUBRC = 0.
*  LOOP AT LT_PRCD INTO LV_PRCD WHERE KNUMV =  WA_vbrk-knumv.
* case LV_PRCD-KSCHL .
*   WHEN 'Z001'.
*    lv_mrp1 = LV_PRCD-KBETR .
*CONCATENATE LV_MRP1 LV_PRCD-WAERS into LV_MRP SEPARATED BY SPACE.
*        wa_final-MRP = lv_mrp.
*        CLEAR LV_MRP.
* WHEN 'ZFOB'.
*   LV_FREIGHT = LV_PRCD-KBETR.
*   CONCATENATE LV_FREIGHT LV_PRCD-WAERS into LV_FRI SEPARATED BY SPACE.
*        wa_final-freight_amt = lV_FRI.
*   CLEAR LV_FRI.
*  WHEN 'ZINS'.
*    LV_INS = LV_PRCD-KBETR.
*       CONCATENATE LV_ins LV_PRCD-WAERS into LV_INS1 SEPARATED BY SPACE.
*        wa_final-INSURANCE_AMT = lV_INS1.
*   WHEN 'ZPTS'.
*         LV_PTS = LV_PRCD-KBETR.
*       CONCATENATE LV_PTS LV_PRCD-WAERS into LV_PTS1 SEPARATED BY SPACE.
*        wa_final-PTS = lV_PTS1..
*  when 'JTC2'.
*       LV_ZJT = LV_PRCD-KBETR.
*       CONCATENATE LV_ZJT LV_PRCD-WAERS into lv_ZJT1 SEPARATED BY SPACE.
*       wa_final-ZJT = lV_ZJT1..
*ENDCASE.
*ENDLOOP.
*ENDIF.

    wa_final-rate1 = wa_final-sales_inr /  wa_final-billqty.
    wa_final-rate = wa_final-sales_inr / wa_final-billqty.

    DATA: lv_vbeln TYPE vbrk-vbeln,
          lv_vbrp  TYPE vbrp.

*    SELECT SINGLE vbeln FROM vbrk INTO lv_vbeln WHERE vkorg IN s_vkorg .    "Commented by Varsha
*    IF sy-subrc = 0.
*      SELECT * FROM vbrp INTO lv_vbrp WHERE vbeln EQ lv_vbeln . wa_vbrk-vbeln
*      ENDSELECT.
*    ENDIF.

      SELECT * FROM vbrp INTO lv_vbrp WHERE vbeln EQ wa_vbrk-vbeln .
      ENDSELECT.
    wa_final-batch = lv_vbrp-charg.
    wa_final-ref_doc = lv_vbrp-vgbel.
    APPEND wa_final TO it_final.
    SORT it_final ASCENDING BY vbeln posnr.
    CLEAR : wa_final,wa_vbrk,wa_vbrp,wa_kna1,wa_bseg,wa_skat,wa_bkpf,v_lfmng,v_scmng,e_j_1ig_invrefnum,wa_ztransp_d,v_kunnr,
            lv_payment_term,wa_tinct,wa_lines1,lv_belnr.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FIELDCAT1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM fieldcat1 .

  wa_fieldcat-fieldname  = 'VBELN'.
  wa_fieldcat-seltext_m  = TEXT-000."'Billing Doc. No.'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'POSNR'.
  wa_fieldcat-seltext_m  = TEXT-100."'Item No.'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'VGBEL'. "'ZUONR'.
  wa_fieldcat-seltext_m  = 'Ref. Original Document No'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'BELNR'.
  wa_fieldcat-seltext_l  = TEXT-051."'Sales Organization'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'VKORG'.
  wa_fieldcat-seltext_l  = TEXT-001."'Sales Organization'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'VTEXT'.
  wa_fieldcat-seltext_l  = TEXT-002."'Sales Org. Description'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'VTWEG'.
  wa_fieldcat-seltext_m  = TEXT-003." 'Distribution Channel'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'VTEXT1'.
  wa_fieldcat-seltext_l  = TEXT-004."'Dist. Channel Desc.'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'SPART'.
  wa_fieldcat-seltext_m  = TEXT-005."'Division'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'VTEXT2'.
  wa_fieldcat-seltext_m  = TEXT-006."'Division Desc.'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
*  CLEAR wa_fieldcat.
*
*  wa_fieldcat-fieldname  = 'VTEXT5'.
*  wa_fieldcat-seltext_l = TEXT-053."'Sales Office Desc.'. " Commented by naga on 15-12-2022.
*  wa_fieldcat-tabname    = 'IT_FINAL'.
*  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'BZIRK_AUFT'.
  wa_fieldcat-seltext_l  =  'Customer Zone'. "TEXT-013."'Headquarter Code'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'BZTXT'.
  wa_fieldcat-seltext_m  = 'Customer Zone Description'.  "TEXT-014."'Headquarter Name'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'WERKS'.
  wa_fieldcat-seltext_m  = TEXT-007."'Location'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'LOCNAME'.
  wa_fieldcat-seltext_m  = TEXT-008."'Location Description'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'GSTIN'.
  wa_fieldcat-seltext_m  = TEXT-009."'Location GSTIN No'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'FKDAT'.
  wa_fieldcat-seltext_m  = TEXT-010."'Billing Date'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'FKART'.
  wa_fieldcat-seltext_m  = TEXT-011."'Billing Type'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'VTEXT3'.
  wa_fieldcat-seltext_l  = TEXT-012."'Billing Description'.
  wa_fieldcat-outputlen  = 40."'Billing Description'.
  wa_fieldcat-lowercase  = 'X'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'AUBEL'.
  wa_fieldcat-seltext_m  = TEXT-093."'Sales Order No'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'AUDAT'.
  wa_fieldcat-seltext_m  = TEXT-094."'Sales Order Date'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  wa_fieldcat-fieldname  = 'QUOTATION'.
*  wa_fieldcat-seltext_m  = TEXT-110."'Quotation'.
*  wa_fieldcat-tabname    = 'IT_FINAL'.
*  APPEND wa_fieldcat TO it_fieldcat.
*  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'KUNAG'.
  wa_fieldcat-seltext_m  = TEXT-015."'Customer Code'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'NAME1'.
  wa_fieldcat-seltext_m  = TEXT-016."'Customer Name'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'INCO1'.
  wa_fieldcat-seltext_m  = 'Inco term'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'INCO1_D'.
  wa_fieldcat-seltext_m  = 'IncoTerm Description'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'REGIO'.
  wa_fieldcat-seltext_m  = TEXT-017."'Customer State'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  WA_FIELDCAT-FIELDNAME  = 'ZGSTR'.
*  WA_FIELDCAT-SELTEXT_M  = TEXT-018."'GST State Code'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.

*  WA_FIELDCAT-FIELDNAME  = 'BEZEI'.
*  WA_FIELDCAT-SELTEXT_M  = TEXT-019."'Customer State Name'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.

  wa_fieldcat-fieldname  = 'LANDX'.
  wa_fieldcat-seltext_m  = TEXT-099."'Country'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'STCD3'.
  wa_fieldcat-seltext_m  = TEXT-020."'Customer GSTIN No.'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'BSTNK_D'.
  wa_fieldcat-seltext_m  = TEXT-097."'Buyer's Order No'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'BSTDK_D'."'BSTDK'.
  wa_fieldcat-seltext_m  = TEXT-118."'Buyer's Order Date'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'STP_CODE'.
  wa_fieldcat-seltext_m  = TEXT-088."'Ship-to-Party Code'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'STP_NAME'.
  wa_fieldcat-seltext_m  = TEXT-089."'Ship-to-Party Name'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'STP_GSTNO'.
  wa_fieldcat-seltext_m  = TEXT-103."'GSTN No.'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  wa_fieldcat-fieldname  = 'KDGRP'.
*  wa_fieldcat-seltext_m  = 'Customer Group'.
*  wa_fieldcat-tabname    = 'IT_FINAL'.         " Commented by naga on 15-12-2022
*  APPEND wa_fieldcat TO it_fieldcat.
*  CLEAR wa_fieldcat.
*
*  wa_fieldcat-fieldname  = 'KTEXT'.
*  wa_fieldcat-seltext_m  = 'Customer Group Description'.
*  wa_fieldcat-tabname    = 'IT_FINAL'.                       " Commented by naga on 15-12-2022
*  APPEND wa_fieldcat TO it_fieldcat.
*  CLEAR wa_fieldcat.

*  WA_FIELDCAT-FIELDNAME  = 'KVGR1'.
*  WA_FIELDCAT-SELTEXT_M  = 'Sub Zone'."TEXT-114."'Customer Group 1'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.

*  WA_FIELDCAT-FIELDNAME  = 'CGRP1'.
*  WA_FIELDCAT-SELTEXT_M  = 'Sub Zone Description'."TEXT-114."'Customer Group 1'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.

  wa_fieldcat-fieldname  = 'BTP_CODE'.
  wa_fieldcat-seltext_m  = TEXT-090."'Bill-to-Party Code'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'BTP_NAME'.
  wa_fieldcat-seltext_m  = TEXT-091."'Bill-to-Party Name'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'BTP_GSTNO'.
  wa_fieldcat-seltext_m  = 'GSTN No.'."'GSTN No.'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'TRNS_NAME' ."'TRNS_NAME1'.
  wa_fieldcat-seltext_m  = TEXT-092."'Transporter Name'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'VEH_NO'.
  wa_fieldcat-seltext_m  = 'Vehicle No.'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.



*
  wa_fieldcat-fieldname  = 'LRNO'.
  wa_fieldcat-seltext_m  = TEXT-026."'LR Number'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'LRDATE'.
  wa_fieldcat-seltext_m  = TEXT-027."'LR Date'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  wa_fieldcat-fieldname  = 'BSTKD'.
*  wa_fieldcat-seltext_m  = 'Party Order NO.'.
*  wa_fieldcat-tabname    = 'IT_FINAL'.
*  APPEND wa_fieldcat TO it_fieldcat.
*  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'MATNR'.
  wa_fieldcat-seltext_m  = TEXT-028."'Product Code'.
  wa_fieldcat-ref_fieldname = 'MATNR'.
  wa_fieldcat-ref_tabname = 'MARA'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'MAKTX'.
  wa_fieldcat-seltext_m  = TEXT-029."'Product Description'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'MATKL'.
  wa_fieldcat-seltext_m = 'Material Group'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'MATKL_D'.
  wa_fieldcat-seltext_m = 'Material Group Description'(112).
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


*  WA_FIELDCAT-FIELDNAME = 'EXTWG'.
*  WA_FIELDCAT-SELTEXT_M = 'Ext. Material Group'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.

  wa_fieldcat-fieldname = 'MVGR1'.           """""" Added by Pavan 18.12.2023
  wa_fieldcat-seltext_m = 'Material Group 1'(120).
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'BEZEI1'.           """""" Added by Pavan 20.12.2023
  wa_fieldcat-seltext_m = 'Material Group 1 Description1'(121).
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


*  WA_FIELDCAT-FIELDNAME = 'EWBEZ'.
*  WA_FIELDCAT-SELTEXT_M = 'Ext. Material Group Description'.
*  WA_FIELDCAT-SELTEXT_L = 'Ext. Material Group Description'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.

*  wa_fieldcat-col_pos = 18.
  wa_fieldcat-fieldname  = 'STEUC'.
  wa_fieldcat-seltext_m  = TEXT-030."'HSN Code'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  WA_FIELDCAT-FIELDNAME  = 'LFMNG'.
*  WA_FIELDCAT-SELTEXT_M  = 'PKG Size'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'ENAME'.
*  WA_FIELDCAT-SELTEXT_L = 'Sales Person'.
*  WA_FIELDCAT-TABNAME = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.

*  WA_FIELDCAT-FIELDNAME = 'SALES_AGENT'.
*  WA_FIELDCAT-SELTEXT_L = 'Sales Agent'.
*  WA_FIELDCAT-TABNAME = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.


*  wa_fieldcat-fieldname  = 'CHARG'.
*  wa_fieldcat-seltext_m  = TEXT-031."'Batch Number'.
*  wa_fieldcat-tabname    = 'IT_FINAL'.
*  APPEND wa_fieldcat TO it_fieldcat.
*  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'BATCH'.
  wa_fieldcat-seltext_l  = 'BATCH'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  wa_fieldcat-col_pos = 20.
  wa_fieldcat-fieldname  = 'BILLQTY'.
  wa_fieldcat-seltext_m  = TEXT-032."'Billed Qty'.
  wa_fieldcat-decimals_out = '2'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'VRKME'.
  wa_fieldcat-seltext_m  = 'Sales UOM'."'Billed Qty'.
*  WA_FIELDCAT-DECIMALS_OUT = '2'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'MEINS'.
  wa_fieldcat-seltext_l  = 'Base Unit of Measure'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'CON_FACT'.
  wa_fieldcat-seltext_l  = 'Conversion Factor'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'FREEQTY'.
  wa_fieldcat-seltext_m  = TEXT-033."'Free Qty'.
  wa_fieldcat-decimals_out = '2'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'MRP'.
  wa_fieldcat-seltext_m  = 'MRP Value'."'MRP'.
  wa_fieldcat-decimals_out = '2'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'STOCK'.
  wa_fieldcat-seltext_m  = 'Stockiest Discount '.
  wa_fieldcat-decimals_out = '2'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'ret'.
  wa_fieldcat-seltext_m  = 'Retailer Discount'.
  wa_fieldcat-decimals_out = '2'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'SPECIAL'.
  wa_fieldcat-seltext_m  = 'Special Discount'.
  wa_fieldcat-decimals_out = '2'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'HOSPI'.
  wa_fieldcat-seltext_m  = 'Hospital Discount'.
  wa_fieldcat-decimals_out = '2'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.



*  WA_FIELDCAT-FIELDNAME  = 'STRDISCNT1'.
*  WA_FIELDCAT-SELTEXT_M  = '% Discount'."TEXT-038."'Standard Discount'.
*  WA_FIELDCAT-DECIMALS_OUT = '2'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.

*  WA_FIELDCAT-FIELDNAME  = 'STRDISCNT'.
*  WA_FIELDCAT-SELTEXT_M  = 'Value Discount'."TEXT-038."'Standard Discount'.
*  WA_FIELDCAT-DECIMALS_OUT = '2'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR wa_fieldcat.
*
*
*  wa_fieldcat-fieldname  = 'CASHDISCNT_D'.
*  wa_fieldcat-seltext_m  = TEXT-039."'Cash Discount'. " commented by naga on 15-12-2022
*  wa_fieldcat-decimals_out = '2'.
*  wa_fieldcat-tabname    = 'IT_FINAL'.
*  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


*
*  WA_FIELDCAT-FIELDNAME  = 'PTS'.
*  WA_FIELDCAT-SELTEXT_M  = 'PTS VALUE'.
*  WA_FIELDCAT-DECIMALS_OUT = '2'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.

  wa_fieldcat-fieldname  = 'ITEM_SALE1'.
  wa_fieldcat-seltext_m  = 'Sales Value in Doc Currency'.
  wa_fieldcat-decimals_out = '2'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'ITEM_SALE'.
  wa_fieldcat-seltext_m  = 'Sales Value Local Currency'.
  wa_fieldcat-decimals_out = '2'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'SALES_INR'.
  wa_fieldcat-seltext_m  = 'Taxable Value'."Sales value in INR'. "TEXT-040."'Sales Value'.
  wa_fieldcat-decimals_out = '2'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  WA_FIELDCAT-COL_POS = 29.
  wa_fieldcat-fieldname  = 'CGSTRATE'.
  wa_fieldcat-seltext_m  = TEXT-041."'CGST Rate'.
  wa_fieldcat-decimals_out = '2'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.



  wa_fieldcat-fieldname  = 'CGSTVALUE'.
  wa_fieldcat-seltext_m  = TEXT-042."'CGST Value'.
  wa_fieldcat-decimals_out = '2'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'SGSTRATE'.
  wa_fieldcat-seltext_m  = TEXT-043."'SGST Rate'.
  wa_fieldcat-decimals_out = '2'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'SGSTVALUE'.
  wa_fieldcat-seltext_m  = TEXT-044."'SGST Value'.
  wa_fieldcat-decimals_out = '2'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'IGSTRATE'.
  wa_fieldcat-seltext_m  = TEXT-045."'IGST Rate'.
  wa_fieldcat-decimals_out = '2'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'IGSTVALUE'.
  wa_fieldcat-seltext_m  = TEXT-046."'IGST Value'.
  wa_fieldcat-decimals_out = '2'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'IGST_INR'.
  wa_fieldcat-seltext_m  = 'IGST Value in INR'.
  wa_fieldcat-decimals_out = '2'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'ZJT'.
  wa_fieldcat-seltext_m  = 'TCS Scrap'.
  wa_fieldcat-decimals_out = '2'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'TDSVALUE'.      "Added by varsha 31-20-2025
  wa_fieldcat-seltext_m  = 'TDS Value'.
  wa_fieldcat-decimals_out = '2'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'KZWI3'.
  wa_fieldcat-seltext_m  = TEXT-047."'Total Tax Value'.
  wa_fieldcat-decimals_out = '2'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'INVVALUE'.
  wa_fieldcat-seltext_m  = 'Gross value'." TEXT-048."'Invoice Value'.
  wa_fieldcat-decimals_out = '2'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'WAERK'.
  wa_fieldcat-seltext_m  = TEXT-098."'Document Currency'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'VTEXT4'.
  wa_fieldcat-seltext_l  = TEXT-050."'Acct.Assgnmt Grp. Desc.'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname  = 'PRCTR'.
  wa_fieldcat-seltext_m  = TEXT-078."'profit center'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'PAN_NO'.
  wa_fieldcat-seltext_m  = TEXT-079."'LR Date'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
*  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'INV_R'.
  wa_fieldcat-seltext_m  = 'Reference Invoice No.'. " Commented by naga on 15-12-2022 "uncommented by varsha 31-10-2025
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'GL_NO'.
  wa_fieldcat-seltext_m  = 'G/L Code'.
  wa_fieldcat-ref_fieldname = 'SAKNR'.
  wa_fieldcat-ref_tabname = 'SKA1'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'GL_DESCP'.
  wa_fieldcat-seltext_m  = 'G/L Description'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.
*
*  wa_fieldcat-fieldname  = 'REF_INVD'.
*  wa_fieldcat-seltext_l  = 'Reference Invoice Date'. " " Commented by naga on 15-12-2022
*  wa_fieldcat-tabname    = 'IT_FINAL'.
*  APPEND wa_fieldcat TO it_fieldcat.
*  CLEAR wa_fieldcat.
*  wa_fieldcat-fieldname  = 'RFBSK'. "'BUCHK'.
*  wa_fieldcat-seltext_m  = TEXT-102."'Posting Status'.
*  wa_fieldcat-tabname    = 'IT_FINAL'.
*  APPEND wa_fieldcat TO it_fieldcat.
*  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'ZTERM'.
  wa_fieldcat-seltext_m  = TEXT-116."'Payment Terms'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


*  wa_fieldcat-fieldname  = 'HSDAT'.
*  wa_fieldcat-seltext_l  = 'Mfg Date'.
*  wa_fieldcat-tabname    = 'IT_FINAL'.
*  APPEND wa_fieldcat TO it_fieldcat.
*  CLEAR wa_fieldcat.

*  wa_fieldcat-fieldname  = 'VFDAT1'.
*  wa_fieldcat-seltext_l  = 'Exp Date'.
*  wa_fieldcat-tabname    = 'IT_FINAL'.
*  APPEND wa_fieldcat TO it_fieldcat.
*  CLEAR wa_fieldcat.

*  wa_fieldcat-fieldname  = 'MAT_TEXT'.
*  wa_fieldcat-seltext_l  = 'GENERIC NAME'.
*  wa_fieldcat-tabname    = 'IT_FINAL'.
*  APPEND wa_fieldcat TO it_fieldcat.
*  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'PORT_CODE'.
  wa_fieldcat-seltext_l  = 'Port Code'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'GST_RATE'.
  wa_fieldcat-seltext_l  = 'GST Rate'.
  wa_fieldcat-decimals_out = '2'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'RATE1'.
  wa_fieldcat-seltext_l  = 'Unit Rate Doc Currency'. "'Rate' added by surabhi
  wa_fieldcat-decimals_out = '2'.
  wa_fieldcat-tabname    = 'IT_FINAL'.         "commented by vyshnavi.v
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'RATE'.
  wa_fieldcat-seltext_l  = 'Unit Rate Local Currency'. "'Rate' added by surabhi
  wa_fieldcat-decimals_out = '2'.
  wa_fieldcat-tabname    = 'IT_FINAL'.         "commented by vyshnavi.v
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'FREIGHT_AMT'.
  wa_fieldcat-seltext_l  = 'Freight Amount'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'INSURANCE_AMT'.
  wa_fieldcat-seltext_l  = 'Insurance amount'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  wa_fieldcat-fieldname  = 'MANUFRACTURER'.
*  wa_fieldcat-seltext_l  = 'Manufracturer'.
*  wa_fieldcat-tabname    = 'IT_FINAL'.
*  APPEND wa_fieldcat TO it_fieldcat.
*  CLEAR wa_fieldcat.



*  wa_fieldcat-fieldname  = 'STATE'.
*  wa_fieldcat-seltext_l  = 'Form Desc'."'Inter/Intra State'.
*  wa_fieldcat-outputlen  = 20.
*  wa_fieldcat-tabname    = 'IT_FINAL'.
*  APPEND wa_fieldcat TO it_fieldcat.
*  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'KURRF'.
  wa_fieldcat-seltext_l  = 'Exchange Rate'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'PRODH'.
  wa_fieldcat-seltext_l = 'Item Category'.
  wa_fieldcat-tabname = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'PRODH_D1'.
  wa_fieldcat-seltext_l = 'Item Category Description1'.
  wa_fieldcat-tabname = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'PRODH_D2'.
  wa_fieldcat-seltext_l = 'Item Category Description2'.
  wa_fieldcat-tabname = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'PRODH_D3'.
  wa_fieldcat-seltext_l = 'Item Category Description3'.
  wa_fieldcat-tabname = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.
***********************************

  wa_fieldcat-fieldname  = 'IRN'.
  wa_fieldcat-seltext_m  = 'IRN No.'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  wa_fieldcat-fieldname  = 'ERDAT'.
*  wa_fieldcat-seltext_m  = 'IRN Date'.
*  wa_fieldcat-tabname    = 'IT_FINAL'.
*  APPEND wa_fieldcat TO it_fieldcat.
*  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'EWBNO'.
  wa_fieldcat-seltext_m  = 'Ewaybill No'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'EWBDT'.
  wa_fieldcat-seltext_m  = 'Ewaybill Date'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'VF_STATUS'.
  wa_fieldcat-seltext_m  = TEXT-101."'Invoicing Status'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'DUEDT'.
  wa_fieldcat-seltext_m  = TEXT-117."'Due Date'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'SHIP_BIL_NO'.
  wa_fieldcat-seltext_l  = 'Shipping Bill No'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  WA_FIELDCAT-FIELDNAME  = 'SHIP_BIL_DATE'.
*  WA_FIELDCAT-SELTEXT_L  = 'Shipping Bill Date'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.

*  WA_FIELDCAT-FIELDNAME = 'UENAME'.
*  WA_FIELDCAT-SELTEXT_L = 'Updated Sales Person'.
*  WA_FIELDCAT-TABNAME = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.

*  WA_FIELDCAT-FIELDNAME = 'Z022'.
*  WA_FIELDCAT-SELTEXT_L = 'CHA Expense'.
*  WA_FIELDCAT-TABNAME = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.

*  WA_FIELDCAT-FIELDNAME = 'Z023'.
*  WA_FIELDCAT-SELTEXT_L = 'Commission / Brokerage'.
*  WA_FIELDCAT-TABNAME = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.



  wa_fieldcat-fieldname  = 'CITY'.
  wa_fieldcat-seltext_l  = 'Destination Name'.    "City name or TextName'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  WA_FIELDCAT-FIELDNAME  = 'INDUSTRY_CD'.
*  WA_FIELDCAT-SELTEXT_L  = 'Industry Code'.    "INDUSTRY CODE'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.

*  WA_FIELDCAT-FIELDNAME  = 'INDUSTRY_DSCR'.
*  WA_FIELDCAT-SELTEXT_L  = 'Industry Description'.    "INDUSTRY CODE'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.

  DATA: lv_tcode TYPE syst_tcode.
  DATA uri TYPE tihttpnvp.
  IMPORT uri = uri  FROM MEMORY ID 'ZREPORTGET'.
  IF sy-subrc EQ 0.
    LOOP AT uri ASSIGNING FIELD-SYMBOL(<r>) WHERE name CS 'filter'.
      TRANSLATE <r>-value TO UPPER CASE.
      REPLACE ALL OCCURRENCES OF '%27' IN <r>-value WITH ''.
      REPLACE ALL OCCURRENCES OF '%20' IN <r>-value WITH ''.
      REPLACE ALL OCCURRENCES OF '''' IN <r>-value WITH ''.
      REPLACE ALL OCCURRENCES OF '+' IN <r>-value WITH ''.
      SPLIT <r>-value AT 'AND' INTO DATA(tcode) DATA(var).
      SPLIT tcode AT 'EQ' INTO DATA(tcode1) DATA(tcode2).
      SPLIT var AT 'EQ' INTO DATA(var2) DATA(val2).
      EXIT.
    ENDLOOP.
    lv_tcode =  tcode2.
  ELSE.
    lv_tcode = sy-tcode.
  ENDIF.

  IF lv_tcode  = 'ZFI005'.
*    WA_FIELDCAT-FIELDNAME  = 'PCIP'.
*    WA_FIELDCAT-SELTEXT_L  = 'Actual Cost Rate'."'Cost Price Rate'.
*    WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*    APPEND WA_FIELDCAT TO IT_FIELDCAT.
*    CLEAR WA_FIELDCAT.

*    WA_FIELDCAT-FIELDNAME  = 'PCIP_V'.
*    WA_FIELDCAT-SELTEXT_L  = 'Actual Cost Value'."'Cost Price Value'.
*    WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*    APPEND WA_FIELDCAT TO IT_FIELDCAT.
*    CLEAR WA_FIELDCAT.
  ENDIF. "++"Start of Changes ABAP01.RBL

***************Addition Of Code By MayurB 12/07/23 *************************
*  WA_FIELDCAT-FIELDNAME  = 'CITY'.
*  WA_FIELDCAT-SELTEXT_L  = 'Destination Name'.    "City name or TextName'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME  = 'INDUSTRY_CD'.
*  WA_FIELDCAT-SELTEXT_L  = 'Industry Code'.    "INDUSTRY CODE'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME  = 'INDUSTRY_DSCR'.
*  WA_FIELDCAT-SELTEXT_L  = 'Industry Description'.    "INDUSTRY CODE'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.
***************End of Addition *************************************

*endif.--changes by abap01 .


*  WA_FIELDCAT-FIELDNAME  = 'COGS'.
*  WA_FIELDCAT-SELTEXT_L  = 'COGS Rate'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.

*  WA_FIELDCAT-FIELDNAME  = 'COGS_V'.
*  WA_FIELDCAT-SELTEXT_L  = 'COGS Value'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.

  wa_fieldcat-fieldname  = 'ERNAM'.
  wa_fieldcat-seltext_l  = 'Created By'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  WA_FIELDCAT-FIELDNAME  = 'COGSPR'.
*  WA_FIELDCAT-SELTEXT_L  = 'COGS %'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.

*  WA_FIELDCAT-FIELDNAME  = 'PPCIP'.
*  WA_FIELDCAT-SELTEXT_L  = 'STD Price Rate'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.


*  WA_FIELDCAT-FIELDNAME  = 'STD_VAL'.
*  WA_FIELDCAT-SELTEXT_L  = 'STD Price Value'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.

*  WA_FIELDCAT-FIELDNAME  = 'ZPR0'.
*  WA_FIELDCAT-SELTEXT_L  = 'GDP Price'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.

*  WA_FIELDCAT-FIELDNAME  = 'ZDIP'.
*  WA_FIELDCAT-SELTEXT_L  = 'DP Price'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME  = 'ZRDF'.
*  WA_FIELDCAT-SELTEXT_L  = 'Rate Difference'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.

  wa_fieldcat-fieldname  = 'LFMNG'."'PACK_SIZE'
  wa_fieldcat-seltext_l  = 'Pack size'.
  wa_fieldcat-tabname    = 'IT_FINAL'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

*  WA_FIELDCAT-FIELDNAME  = 'ABC_IND'.
*  WA_FIELDCAT-SELTEXT_L  = 'ABC Indicator'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.

*  WA_FIELDCAT-FIELDNAME  = 'ABC_DIND'.
*  WA_FIELDCAT-SELTEXT_L  = 'ABC Indicator Description'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.

*  wa_fieldcat-fieldname  = 'BASE_QTY'.   "commented by VARSHA
*  wa_fieldcat-seltext_l  = 'Base Quantity'.
*  wa_fieldcat-tabname    = 'IT_FINAL'.
*  APPEND wa_fieldcat TO it_fieldcat.
*  CLEAR wa_fieldcat.

*  WA_FIELDCAT-FIELDNAME  = 'BATCH'.
*  WA_FIELDCAT-SELTEXT_L  = 'BATCH'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.

*  wa_fieldcat-fieldname  = 'BASE_UMO'.    "Commented by VARSHA
*  wa_fieldcat-seltext_l  = 'Base UOM'.
*  wa_fieldcat-tabname    = 'IT_FINAL'.
*  APPEND wa_fieldcat TO it_fieldcat.
*  CLEAR wa_fieldcat.
*  WA_FIELDCAT-FIELDNAME  = 'MIRO'.
*  WA_FIELDCAT-SELTEXT_L  = 'Linked invoice number'.
*  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.

*  WA_FIELDCAT-FIELDNAME = 'UENAME'.
*  WA_FIELDCAT-SELTEXT_L = 'Updated Sales Agent'.
*  WA_FIELDCAT-TABNAME = 'IT_FINAL'.
*  APPEND WA_FIELDCAT TO IT_FIELDCAT.
*  CLEAR WA_FIELDCAT.
ENDFORM.

FORM add_days USING lv_time.
  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
    EXPORTING
      date      = wa_vbrk-fkdat
      days      = lv_time
      months    = 00
*     SIGNUM    = '+'
      years     = 00
    IMPORTING
      calc_date = wa_final-duedt.

ENDFORM.

FORM read_text  USING tdobject tdname tdid CHANGING field1.
  SELECT SINGLE *
                FROM stxh
                INTO @DATA(wa_stxh)
                WHERE tdobject = @tdobject
                  AND tdname   = @tdname
  AND tdid     = @tdid.
  IF sy-subrc = 0.
    DATA: it_thead TYPE TABLE OF tline.
    DATA:line_br TYPE c VALUE cl_abap_char_utilities=>cr_lf.
    CLEAR:it_thead.


    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                      = wa_stxh-tdid
        language                = 'E'
        name                    = wa_stxh-tdname
        object                  = wa_stxh-tdobject
      TABLES
        lines                   = it_thead
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.



    LOOP AT it_thead INTO DATA(wa_thead).
      REPLACE ALL OCCURRENCES OF '<(>' IN wa_thead-tdline WITH ''.
      REPLACE ALL OCCURRENCES OF '<)>' IN wa_thead-tdline WITH ''.
      IF sy-tabix = 1.
        field1 = wa_thead-tdline.
      ELSE.
        CONCATENATE field1 wa_thead-tdline INTO field1 SEPARATED BY ' '."LINE_BR.
      ENDIF.
      CLEAR:wa_thead.
    ENDLOOP.

  ENDIF.
  CLEAR:it_thead,it_thead[].

ENDFORM.

FORM initialize_variant .
  g_save = 'A'.
  CLEAR g_variant.
  g_variant-report = repname.
  gx_variant = g_variant.
  CALL FUNCTION 'REUSE_ALV_VARIANT_DEFAULT_GET'
    EXPORTING
      i_save     = g_save
    CHANGING
      cs_variant = gx_variant
    EXCEPTIONS
      not_found  = 2.
  IF sy-subrc = 0.
    p_vari = gx_variant-variant.
  ENDIF.
ENDFORM.                    " initialize_variant


*&---------------------------------------------------------------------*
*&      Form  f4_for_variant
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f4_for_variant .

  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      is_variant = g_variant
      i_save     = g_save
    IMPORTING
      e_exit     = g_exit
      es_variant = gx_variant
    EXCEPTIONS
      not_found  = 2.
  IF sy-subrc = 2.
    MESSAGE ID sy-msgid TYPE 'S'      NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    IF g_exit = space.
      p_vari = gx_variant-variant.
    ENDIF.
  ENDIF.
ENDFORM.                    " f4_for_variant

FORM pai_of_selection_screen .
  IF NOT p_vari IS INITIAL.
    MOVE g_variant TO gx_variant.
    MOVE p_vari TO gx_variant-variant.
    CALL FUNCTION 'REUSE_ALV_VARIANT_EXISTENCE'
      EXPORTING
        i_save     = g_save
      CHANGING
        cs_variant = gx_variant.
    g_variant = gx_variant.
  ELSE.
    PERFORM initialize_variant.
  ENDIF.
ENDFORM.


FORM bdc_dynpro USING program dynpro.
  CLEAR bdcdata.
  bdcdata-program  = program.
  bdcdata-dynpro   = dynpro.
  bdcdata-dynbegin = 'X'.
  APPEND bdcdata.
ENDFORM.                    "BDC_DYNPRO

FORM bdc_field USING fnam fval.
  CLEAR bdcdata.
  bdcdata-fnam = fnam.
  bdcdata-fval = fval.
  APPEND bdcdata.

ENDFORM.
