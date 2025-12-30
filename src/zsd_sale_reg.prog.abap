
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&   Developer Name        :
*&   Date of Development   :                                            *
*&   Program Type          : Excutable                                  *
*&   Program Name          : ZSD_SALES_REG
*&   Transaction Code      :                                            *
*&   Technical Lead        :                                            *
*&   Functional Consultant :
*&   Description           :
*&   Transport Request     :                                            *
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*

REPORT ZSD_SALE_REG.


TABLES : VBRK,VBRP.
TYPE-POOLS : SLIS.
TYPES : BEGIN OF TS_VBRK,
          VBELN     TYPE VBRK-VBELN,""
          FKART     TYPE VBRK-FKART,
          FKTYP     TYPE VBRK-FKTYP,
          WAERK     TYPE VBRK-WAERK,
          VKORG     TYPE VBRK-VKORG,
          VTWEG     TYPE VBRK-VTWEG,
          KNUMV     TYPE VBRK-KNUMV,
          FKDAT     TYPE VBRK-FKDAT,
          GJAHR     TYPE VBRK-GJAHR,
          INCO1     TYPE VBRK-INCO1,
          REGIO     TYPE VBRK-REGIO,
          BUKRS     TYPE VBRK-BUKRS,
          NETWR     TYPE VBRK-NETWR,
          ERDAT     TYPE VBRK-ERDAT,
          KUNAG     TYPE VBRK-KUNAG,
          SFAKN     TYPE VBRK-SFAKN,
          SPART     TYPE VBRK-SPART,
          XBLNR     TYPE VBRK-XBLNR,
          MWSBK     TYPE VBRK-MWSBK,
          FKSTO     TYPE VBRK-FKSTO,
          BUPLA     TYPE VBRK-BUPLA,
          VF_STATUS TYPE VBRK-VF_STATUS,
          BUCHK     TYPE VBRK-BUCHK,
          VBTYP     TYPE VBRK-VBTYP,
          ZTERM     TYPE VBRK-ZTERM,
          ZUONR     TYPE ORDNR_V,
          KURRF     TYPE VBRK-KURRF,
          BELNR     TYPE VBRK-BELNR,
          RFBSK     TYPE VBRK-RFBSK,
        END OF TS_VBRK.

TYPES : BEGIN OF TS_VBRP,
          VBELN      TYPE VBRP-VBELN,
          POSNR      TYPE VBRP-POSNR,
          FKIMG      TYPE VBRP-FKIMG,
          NTGEW      TYPE VBRP-NTGEW,
          NETWR      TYPE VBRP-NETWR,
          VGBEL      TYPE VBRP-VGBEL,
          VGTYP      TYPE VBRP-VGTYP,
          VGPOS      TYPE VBRP-VGPOS,
          AUBEL      TYPE VBRP-AUBEL,
          AUPOS      TYPE VBRP-AUPOS,
          MATNR      TYPE VBRP-MATNR,
          CHARG      TYPE VBRP-CHARG,
          PSTYV      TYPE VBRP-PSTYV,
          SPART      TYPE VBRP-SPART,
          WERKS      TYPE VBRP-WERKS,
          VKGRP      TYPE VBRP-VKGRP,
          VKBUR      TYPE VBRP-VKBUR,
          KZWI1      TYPE VBRP-KZWI1,
          KZWI2      TYPE VBRP-KZWI2,
          KZWI3      TYPE VBRP-KZWI3,
          KZWI4      TYPE VBRP-KZWI4,
          PRCTR      TYPE VBRP-PRCTR,
          VKORG_AUFT TYPE VBRP-VKORG_AUFT,
          VTWEG_AUFT TYPE VBRP-VTWEG_AUFT,
          BZIRK_AUFT TYPE VBRP-BZIRK_AUFT,
          MEINS      TYPE MEINS,
          FKLMG      TYPE VBRP-FKLMG,
          PRODH      TYPE VBRP-PRODH,
          ERNAM      TYPE VBRP-ERNAM,
*          LMENG      TYPE VBRP-LMENG, "*
          ARKTX      TYPE VBRP-ARKTX,
          VRKME      TYPE VBRP-VRKME,
          UMVKZ      TYPE VBRP-UMVKZ,
          UMVKN      TYPE VBRP-UMVKN,
          MVGR1      TYPE VBRP-MVGR1,
          KUNRG_ANA  TYPE VBRP-KUNRG_ANA,
          UECHA      TYPE VBRP-UECHA,
          wavwr      type vbrp-wavwr,
          fkart_ana type vbrp-fkart_ana,
        END OF TS_VBRP.

TYPES : BEGIN OF TS_VBRP1,
          VBELN TYPE VBRP-VBELN,
          POSNR TYPE VBRP-POSNR,
          MATNR TYPE VBRP-MATNR,
          CHARG TYPE VBRP-CHARG,
          UECHA TYPE VBRP-UECHA,
        END OF TS_VBRP1.

TYPES : BEGIN OF TS_VBRP2,
          VBELN TYPE VBRP-VBELN,
          POSNR TYPE VBRP-POSNR,
          FKIMG TYPE VBRP-FKIMG,
          MATNR TYPE VBRP-MATNR,
          CHARG TYPE VBRP-CHARG,
          UECHA TYPE VBRP-UECHA,
          PSTYV TYPE VBRP-PSTYV,
          NETWR TYPE VBRP-NETWR,
        END OF TS_VBRP2.

TYPES : BEGIN OF TS_LIPS,
          VBELN TYPE LIPS-VBELN,
          POSNR TYPE LIPS-POSNR,
          PSTYV TYPE LIPS-PSTYV,
          MATNR TYPE LIPS-MATNR,
          WERKS TYPE LIPS-WERKS,
          VGPOS TYPE LIPS-VGPOS,
          CHARG TYPE LIPS-CHARG,
          LFIMG TYPE LIPS-LFIMG,
          UECHA TYPE LIPS-UECHA,
        END OF TS_LIPS.

TYPES : BEGIN OF TS_KNA1,
          KUNNR  TYPE KNA1-KUNNR,
          LAND1  TYPE KNA1-LAND1,
          NAME1  TYPE KNA1-NAME1,
          NAME2  TYPE KNA1-NAME2,
          ORT01  TYPE KNA1-ORT01,
          ADRNR  TYPE KNA1-ADRNR,
          NAME3  TYPE KNA1-NAME3,
          NAME4  TYPE KNA1-NAME4,
          REGIO  TYPE KNA1-REGIO,
          STCD3  TYPE KNA1-STCD3,
          PAN_NO TYPE KNA1-J_1IPANNO,
        END OF TS_KNA1.

TYPES : BEGIN OF TS_PRCD_ELEMENTS,
          KNUMV TYPE PRCD_ELEMENTS-KNUMV,
          KPOSN TYPE PRCD_ELEMENTS-KPOSN,
          KSCHL TYPE PRCD_ELEMENTS-KSCHL,
          KRECH TYPE PRCD_ELEMENTS-KRECH,
          KAWRT TYPE PRCD_ELEMENTS-KAWRT,
          KBETR TYPE PRCD_ELEMENTS-KBETR,
          WAERS TYPE PRCD_ELEMENTS-WAERS,
          KNUMH TYPE PRCD_ELEMENTS-KNUMH,
          MWSK2 TYPE PRCD_ELEMENTS-MWSK2,
*          KWERT TYPE J_7LRGEW_3,
          KWERT TYPE PRCD_ELEMENTS-KWERT,
        END OF TS_PRCD_ELEMENTS.

TYPES : BEGIN OF TS_PRCD_ELEMENTS1,
          KNUMV TYPE PRCD_ELEMENTS-KNUMV,
          KPOSN TYPE PRCD_ELEMENTS-KPOSN,
          KSCHL TYPE PRCD_ELEMENTS-KSCHL,
          KWERT TYPE PRCD_ELEMENTS-KWERT,
        END OF TS_PRCD_ELEMENTS1.


TYPES : BEGIN OF TY_VBFA,
          VBELV   TYPE VBFA-VBELV,
          VBELN   TYPE VBFA-VBELN,
          VBTYP_V TYPE VBFA-VBTYP_V,
          VBTYP_N TYPE VBFA-VBTYP_N,
          ERDAT   TYPE VBFA-ERDAT,
          POSNV   TYPE POSNR_VON,
        END OF TY_VBFA.

TYPES : BEGIN OF TY_VBKD,
          VBELN TYPE VBKD-VBELN,
          BSTKD TYPE VBKD-BSTKD,
          BSTDK TYPE VBKD-BSTDK,
        END OF TY_VBKD.

TYPES : BEGIN OF TY_MCH1,
          MATNR TYPE MCH1-MATNR,
          CHARG TYPE MCH1-CHARG,
          HSDAT TYPE MCH1-HSDAT,
          VFDAT TYPE MCH1-VFDAT,
        END OF TY_MCH1.

TYPES : BEGIN OF TY_VBPA,
          VBELN TYPE VBPA-VBELN,
          PARVW TYPE VBPA-PARVW,
          KUNNR TYPE VBPA-KUNNR,
          LIFNR TYPE VBPA-LIFNR,
        END OF TY_VBPA.

TYPES : BEGIN OF TY_ADRC,
          NAME1      TYPE ADRC-NAME1,
          ADDRNUMBER TYPE ADRC-ADDRNUMBER,
        END OF TY_ADRC.

TYPES : BEGIN OF TY_PRD,
          KNUMV TYPE PRCD_ELEMENTS-KNUMV,
          KPOSN TYPE KPOSN,
          KSCHL TYPE PRCD_ELEMENTS-KSCHL,
          KBETR TYPE PRCD_ELEMENTS-KBETR,
*          KWERT TYPE J_7LRGEW_3,
          KWERT TYPE PRCD_ELEMENTS-KWERT,
        END OF TY_PRD.

TYPES : BEGIN OF TY_KNA1,
          KUNNR TYPE KNA1-KUNNR,
          NAME1 TYPE KNA1-NAME1,
        END OF TY_KNA1.

TYPES : BEGIN OF TY_LFA1,
          LIFNR TYPE LFA1-LIFNR,
          NAME1 TYPE LFA1-NAME1,
        END OF TY_LFA1.



TYPES : BEGIN OF TY_VBAK_D,
          VBELN TYPE VBAK-VBELN,
          AUDAT TYPE VBAK-AUDAT,
          AUART TYPE VBAK-AUART,
          BSTNK TYPE BSTNK,
          BSTDK	TYPE DATUM,

        END OF TY_VBAK_D.

TYPES : BEGIN OF TY_BKPF,
          BELNR TYPE BELNR_D,
          KURSF TYPE KURSF,
        END OF TY_BKPF.

TYPES : BEGIN OF TY_LIKP,
          VBELN     TYPE LIKP-VBELN,
          ERDAT     TYPE LIKP-ERDAT,
          WADAT     TYPE LIKP-WADAT,
          WADAT_IST TYPE  LIKP-WADAT_IST,
        END OF TY_LIKP.

TYPES : BEGIN OF TY_KNMT,
          POSTX TYPE KDPTX,
          MATNR TYPE MATNR,
        END OF TY_KNMT.




DATA : LT_BKPF TYPE STANDARD TABLE OF TY_BKPF,
       LA_BKPF TYPE TY_BKPF.

DATA : IT_LIKP TYPE TABLE OF TY_LIKP,
       WA_LIKP TYPE TY_LIKP.

DATA : IT_VBAK_D TYPE STANDARD TABLE OF TY_VBAK_D,
       WA_VBAK_D TYPE TY_VBAK_D.

DATA : IT_LFA1 TYPE STANDARD TABLE OF TY_LFA1,
       WA_LFA1 TYPE TY_LFA1.
DATA : IT_LFA1_VBRP TYPE STANDARD TABLE OF TY_LFA1,
       WA_LFA1_VBRP TYPE TY_LFA1.
DATA : IT_KNA1_D TYPE STANDARD TABLE OF TY_KNA1,
       WA_KNA1_D TYPE TY_KNA1.
DATA : IT_PRD TYPE STANDARD TABLE OF TY_PRD,
       WA_PRD TYPE TY_PRD.
DATA : IT_ADRC TYPE STANDARD TABLE OF TY_ADRC,
       WA_ADRC TYPE TY_ADRC.

DATA : IT_VBPA     TYPE STANDARD TABLE OF TY_VBPA,
       IT_VBPA_TMP TYPE STANDARD TABLE OF TY_VBPA,
       WA_VBPA     TYPE TY_VBPA,
       IT_VBFA     TYPE STANDARD TABLE OF TY_VBFA,
       IT_VBKD     TYPE STANDARD TABLE OF TY_VBKD,
       WA_VBFA     TYPE TY_VBFA,
       WA_VBKD     TYPE TY_VBKD,
       IT_MCH1     TYPE STANDARD TABLE OF TY_MCH1,
       WA_MCH1     TYPE TY_MCH1,
       IT_LINE_D   TYPE STANDARD TABLE OF TLINE.

DATA OBJ TYPE REF TO ZCL_GET_EINVOICE_DETAILS.
CREATE OBJECT OBJ.
DATA : IM_INV_NUM  TYPE EDOCUMENT-SOURCE_KEY.
DATA : E_EDOINEINV  TYPE  EDOINEINV.
DATA : E_EDOINEWB  TYPE  EDOINEWB.

DATA : LV_VBFA TYPE TY_VBFA .

TYPES:BEGIN OF TY_EKKO,
        EBELN TYPE EKKO-EBELN,
        KNUMV TYPE EKKO-KNUMV,
        BEDAT type ekko-bedat,
      END OF TY_EKKO.


TYPES : BEGIN OF TS_FINAL,
          VBELN            TYPE VBRK-VBELN,
          IRN              TYPE J_1IG_IRN,
          ERDAT            TYPE ERDAT,
          EWBNO            TYPE STRING,
          EWBDT            TYPE ZEWBDT,
          FKART            TYPE VBRK-FKART,
          FKTYP            TYPE VBRK-FKTYP,
          WAERK            TYPE VBRK-WAERK,
          VKORG            TYPE VBRK-VKORG,
          VTWEG            TYPE VBRK-VTWEG,
          KNUMV            TYPE VBRK-KNUMV,
          INV_BILLING_DATE TYPE VBRK-FKDAT,
          FKDAT            TYPE VBRK-FKDAT,
          BUKRS            TYPE VBRK-BUKRS,
          NETWR            TYPE VBRK-NETWR,
          NETWR1           TYPE VBRK-NETWR,
          KUNAG            TYPE VBRK-KUNAG,
          SPART            TYPE VBRK-SPART,
          XBLNR            TYPE VBRK-XBLNR,
          MWSBK            TYPE VBRK-MWSBK,
          BUPLA            TYPE VBRK-BUPLA,
          POSNR            TYPE VBRP-POSNR,
          FKIMG            TYPE VBRP-FKIMG,
          NTGEW            TYPE VBRP-NTGEW,
          VGBEL            TYPE CHAR10,       "VBRP-VGBEL,
          MATNR            TYPE VBRP-MATNR,
          MATKL            TYPE MARA-MATKL,
          MATKL_D          TYPE T023T-WGBEZ,
          EXTWG            TYPE MARA-EXTWG,
          EWBEZ            TYPE TWEWT-EWBEZ,
          MAKTX            TYPE MAKT-MAKTX,
          CHARG            TYPE VBRP-CHARG,
          PSTYV            TYPE VBRP-PSTYV,
          WERKS            TYPE VBRP-WERKS,
          VKGRP            TYPE VBRP-VKGRP,
          VKBUR            TYPE VBRP-VKBUR,
          KZWI3            TYPE VBRP-KZWI3,
          KZWI4            TYPE VBRP-KZWI4,
          BZIRK_AUFT       TYPE VBRP-BZIRK_AUFT,
          KUNNR            TYPE KNA1-KUNNR,
          NAME1(70)        TYPE C,  "kna1-name1,   "Customer Name
          REGIO            TYPE KNA1-REGIO,
          STCD3            TYPE KNA1-STCD3,
          GSTIN            TYPE J_1BBRANCH-GSTIN,
          BZTXT            TYPE T171T-BZTXT,
          INVVALUE         TYPE VBRP-NETWR,
          STEUC            TYPE MARC-STEUC,
          PRSFD            TYPE TVAP-PRSFD,
          BILLQTY          TYPE VBRP-FKIMG,
          FREEQTY          TYPE VBRP-FKIMG,
          PRDCTRATE        TYPE PRCD_ELEMENTS-KBETR,
          PTR              TYPE PRCD_ELEMENTS-KBETR,
          MRP              TYPE PRCD_ELEMENTS-KBETR,
          PTS              TYPE PRCD_ELEMENTS-KBETR,
          GROSSAMT         TYPE VBRP-NETWR, "prcd_elements-kbetr,
          STRDISCNT        TYPE PRCD_ELEMENTS-KBETR,
          STRDISCNT1       TYPE PRCD_ELEMENTS-KBETR,
          CASHDISCNT       TYPE VBRP-NETWR, "prcd_elements-kbetr,
          CASHDISCNT_D     TYPE PRCD_ELEMENTS-KBETR,
          CGSTRATE         TYPE PRCD_ELEMENTS-KBETR,
          SGSTRATE         TYPE PRCD_ELEMENTS-KBETR,
          IGSTRATE         TYPE PRCD_ELEMENTS-KBETR,
          CGSTVALUE        TYPE PRCD_ELEMENTS-KBETR,
          SGSTVALUE        TYPE PRCD_ELEMENTS-KBETR,
          IGSTVALUE        TYPE PRCD_ELEMENTS-KBETR,
          ROUNDOFF         TYPE VBRP-KZWI3,
          BSTKD            TYPE VBKD-BSTKD,      "Buyer's Order No.
          BSTDK1           TYPE VBKD-BSTDK,      "Buyer's Order Date
          STP_GSTNO        TYPE KNA1-STCD3,      "Shipt to Party GST No.
          STP_CODE         TYPE KUNNR,
          STP_NAME(70)     TYPE C,
          BTP_CODE         TYPE KUNNR,
          BTP_NAME(70)     TYPE C,
          BTP_GSTNO        TYPE KNA1-STCD3,      "Bill to Party GST No.
          TRNS_NAME        TYPE LFA1-NAME1,       "Transporter Name
          LIA_NAME         TYPE LFA1-NAME1,       "Liasoning Agent Name "
          LIR_NAME         TYPE PRCD_ELEMENTS-KWERT, "Liasoner Commision "
          LRNO             TYPE TDLINE,           "LR No.
          LRDATE           TYPE SY-DATUM,           "LR Date
          VTEXT            TYPE TVKOT-VTEXT,
          VTEXT1           TYPE TVTWT-VTEXT,
          VTEXT2           TYPE TSPAT-VTEXT,
          LOCNAME          TYPE T001W-NAME1,
          VTEXT3           TYPE TVFKT-VTEXT,
          AUBEL            TYPE VBRP-AUBEL,        "Sales Order No.
          AUDAT            TYPE VBAK-AUDAT,        "Sales Order Date
          WADAT            TYPE LIKP-WADAT,
          WADAT_IST        TYPE LIKP-WADAT_IST,    "Delivery Note Date*

          SFAKN            TYPE VBRK-SFAKN,         "REVERSE IINVOICE
          REVERSE_DATE     TYPE VBRK-FKDAT,      ""REVERSE DATE
          KTGRM            TYPE MVKE-KTGRM,        "ACCNT ASSIGNMENT GRP
          MVGR1            TYPE MVKE-MVGR1,      "" Added by pavan 19.12.2023
          VTEXT4           TYPE TVKMT-VTEXT,
          VTEXT5           TYPE TVKBT-BEZEI,
          VTEXT6           TYPE TVGRT-BEZEI,
          TARGETRATE       TYPE PRCD_ELEMENTS-KBETR,
          TARGETVALUE      TYPE PRCD_ELEMENTS-KBETR,
          TARGETAMOUNT     TYPE PRCD_ELEMENTS-KBETR,
          KWERT            TYPE J_7LRGEW_3,
*          KWERT            TYPE PRCD_ELEMENTS-KWERT,
          PRCTR            TYPE VBRP-PRCTR,
          PAN_NO           TYPE KNA1-J_1IPANNO,
*          zgstr         TYPE zgst_region_map-zgstr,
          ZGSTR            TYPE REGIO,
          BEZEI            TYPE ZGST_REGION_MAP-BEZEI,
          LANDX            TYPE T005T-LANDX,            "Country
          VF_STATUS        TYPE DD07D-DDTEXT,           "Invoicing Status
          BUCHK            TYPE DD07D-DDTEXT,           "Posting Status
          INCO1            TYPE VBRK-INCO1,
          INCO1_D          TYPE  TINCT-BEZEI,
          KDGRP            TYPE KNVV-KDGRP,
          KTEXT            TYPE T151T-KTEXT,             "Customer Group
          BSTNK            TYPE VBAK-BSTNK,             "Customer Reference No.
          BSTDK            TYPE VBAK-BSTDK,             "Customer Reference Date
          TRV_RATE         TYPE PRCD_ELEMENTS-KBETR,    "TRV Rate
          QUOTATION        TYPE VBFA-VBELV,             "Quotation
          CONTRACT         TYPE VBFA-VBELV,             "Contract
          GENMTXT          TYPE STRING,                 "Generic Material Text
          PGROUP           TYPE BEZEI20,            "Price Group
          CGRP1            TYPE BEZEI20,            "Customer Group 1
          KVGR1            TYPE VBAK-KVGR1,
          LIR_COM          TYPE PRCD_ELEMENTS-KBETR, "Liasoner Commission %
          ZTERM            TYPE TVZBT-VTEXT,          "Payment Terms
          DUEDT            TYPE VBRK-FKDAT,           "Due Date
          VFDAT            TYPE MCHA-VFDAT,         "Expiry Date for Batch
          ZUONR            TYPE ORDNR_V,
          INV_R            TYPE BKPF-XBLNR,        "Reference Invoice no.
          GL_NO            TYPE PRCD_ELEMENTS-SAKN1, "BSEG-HKONT,             "G/L NO
          GL_DESCP         TYPE SKAT-TXT50,           "G/L Description
          REF_INVD         TYPE BKPF-BLDAT,           " Reference Invoice Date
          RFBSK            TYPE VBRK-RFBSK,
          BSTNK_D          TYPE BSTNK,
          BSTDK_D	         TYPE DATUM,
          HSDAT            TYPE MCH1-HSDAT,                  "MFG date.
          VFDAT1           TYPE MCH1-VFDAT,                  "EXP date
          MAT_TEXT         TYPE CHAR100,
          PORT_CODE        TYPE ADRC-NAME1,
          TRNS_NAME1       TYPE ADRC-NAME1,
          VEH_NO           TYPE CHAR100,
          GST_RATE         TYPE PRCD_ELEMENTS-KWERT, "p DECIMALS 2,
          RATE             TYPE PRCD_ELEMENTS-KWERT,
          RATE1            TYPE PRCD_ELEMENTS-KWERT,
          FREIGHT_AMT      TYPE PRCD_ELEMENTS-KWERT,  "Freight amount.
          INSURANCE_AMT    TYPE PRCD_ELEMENTS-KWERT,  "Freight amount.
          SHIP_BIL_NO      TYPE CHAR20,
          SHIP_BIL_DATE    TYPE DATUM,
          MANUFRACTURER    TYPE CHAR100,
          AMOUNT           TYPE KWERT,
          MEINS            TYPE MEINS,      " Base Unit of Measure
          CON_FACT         TYPE NETWR,
          SALES_INR        TYPE NETWR,
          IGST_INR         TYPE VFPRC_ELEMENT_AMOUNT,
          TCS_BASE         TYPE VFPRC_ELEMENT_VALUE,
          TCS_RATE         TYPE VFPRC_ELEMENT_AMOUNT,
          TCS_AMOUNT       TYPE VFPRC_ELEMENT_VALUE,
          STATE            TYPE CHAR6,
          ENAME            TYPE PA0001-ENAME,
          SALES_AGENT      TYPE KNA1-NAME1,   "added by surabhi 05.02.2023
          KURRF            TYPE VBRK-KURRF,
          PRODH            TYPE VBRP-PRODH,
          PRODH_D1         TYPE T179T-VTEXT,
          PRODH_D2         TYPE T179T-VTEXT,
          PRODH_D3         TYPE T179T-VTEXT,
          LFMNG            TYPE STRING,
          PCIP             TYPE NETWR,
          PCIP_V           TYPE NETWR,
          COGS             TYPE NETWR,
          COGS_V           TYPE NETWR,
          ERNAM            TYPE VBRK-ERNAM,
          VRKME            TYPE VBRP-VRKME,
          COGSPR           TYPE P DECIMALS 2,
          PPCIP            TYPE NETWR,
          STD_VAL          TYPE NETWR,
          ABC_IND          TYPE MARC-MAABC,
          ABC_DIND         TYPE STRING,
          ZPR0             TYPE NETWR,
          ZDIP             TYPE NETWR,
          ZRDF             TYPE NETWR,
*          PACK_SIZE     TYPE MVKE-SCMNG,
          ITEM_SALE        TYPE NETWR,
*          ITEM_SALE        TYPE J_7LRGEW_3,
          ITEM_SALE1       TYPE NETWR,
*          ITEM_SALE1       TYPE J_7LRGEW_3,
          BASE_QTY         TYPE NETWR,
          BASE_UMO         TYPE VBRP-MEINS,
          CITY             TYPE ADRC-CITY1,                    "Added By MayurB 12/07/23  <DS4K905313>
          INDUSTRY_CD      TYPE BUT0IS-IND_SECTOR,             "Added By MayurB 12/07/23  <DS4K905313>
          INDUSTRY_DSCR    TYPE CHAR20,                        "Added By MayurB 12/07/23  <DS4K905313>
*          MVGR11         TYPE vbrp-MVGR1,
          BEZEI1           TYPE TVM1T-BEZEI,
          LIFNR            TYPE LFB1-LIFNR,        "Salesperson ID
          KUNRG_ANA        TYPE VBRP-KUNRG_ANA,    "Payer ID
          NAME1_1          TYPE ADRC-NAME1,        "Payer Description
          KUNN2            TYPE KNVP-KUNN2,        "Customer ZA ID
          NAME1_D          TYPE KNA1-NAME1,        "Customer ZA Description
          ORT01            TYPE KNA1-ORT01,        "Customer City
          VBELV_1          TYPE VBFA-VBELV,        " Invoice Cancellation Number
          ERDAT_1          TYPE VBFA-ERDAT,        "Invoice Cancellation Date
          LIFNR_1          TYPE KNVP-LIFNR,        "Transporter SAP ID
          MBLNR            TYPE MSEG-MBLNR,        "PGI Number
          ERDAT_2          TYPE VBFA-ERDAT,        "PGI Date
          VBELV_2          TYPE VBFA-VBELV,        "OBD Number
*          ERDAT_3          TYPE CHAR10,            "VBFA-ERDAT,        "OBD Date
          ERDAT_3          TYPE VBFA-ERDAT,            "VBFA-ERDAT,        "OBD Date
          ARKTX_1          TYPE VBRP-ARKTX,        "Material Description
          POSTX_1          TYPE KNMT-POSTX,        "Material Customer Description
          CHARG_1          TYPE VBRP-CHARG,        "Batch Number
          ZTERM_1(25) TYPE C, "          TYPE VBRK-ZTERM,        "Payment Term ID
          LMENG_1          TYPE VBRP-LMENG,        "1. Material Batch Quantity
          VFDAT_1          TYPE MCH1-VFDAT,       "3. Material Batch Expiry Date
          HSDAT_1          TYPE  MCH1-HSDAT,      "2. Material Batch Mfg Date
          AUART_1          TYPE VBAK-AUART,       "1. Sales Order Document Type
          LTEXT_1          TYPE TCURT-LTEXT,     "Currency Description
        END OF TS_FINAL.

TYPES : BEGIN OF TY_STATE,
          BUKRS      TYPE BUKRS,
          BRANCH     TYPE J_1BBRANC_,
          BUPLA_TYPE TYPE GLO_BUPLA_TYPE_CODE,
          ADRNR      TYPE ADRNR,
        END OF TY_STATE.

TYPES : BEGIN OF TY_ADR,
          ADDRNUMBER TYPE AD_ADDRNUM,
          DATE_FROM  TYPE AD_DATE_FR,
          NATION     TYPE AD_NATION,
          REGION     TYPE REGIO,
        END OF TY_ADR.

TYPES : BEGIN OF TY_FKDAT,
          VBELN TYPE VBELN_VF,
          FKDAT TYPE FKDAT,
        END OF TY_FKDAT.

TYPES : BEGIN OF TY_IRN,
          BUKRS    TYPE BUKRS,
          DOCNO    TYPE J_1IG_DOCNO,
          DOC_YEAR TYPE J_1IG_DOC_YEAR,
          DOC_TYPE TYPE J_1IG_DOCTYP,
          IRN      TYPE J_1IG_IRN,
          ERDAT    TYPE ERDAT,
        END OF TY_IRN.

TYPES : BEGIN OF TY_TVKOT,
          SPRAS TYPE SPRAS,
          VKORG TYPE VKORG,
          VTEXT TYPE VTXTK,
        END OF TY_TVKOT.

TYPES : BEGIN OF TY_TVTWT,
          SPRAS TYPE SPRAS,
          VTWEG TYPE VTWEG,
          VTEXT TYPE VTXTK,

        END OF TY_TVTWT.

TYPES : BEGIN OF TY_TSPAT,
          SPRAS TYPE SPRAS,
          SPART TYPE SPART,
          VTEXT TYPE VTXTK,

        END OF TY_TSPAT.

TYPES : BEGIN OF TY_TVFKT,
          SPRAS TYPE SPRAS,
          FKART TYPE FKART,
          VTEXT TYPE BEZEI40,

        END OF TY_TVFKT.

TYPES : BEGIN OF TY_J_1BBRANCH,
          BUKRS  TYPE BUKRS,
          BRANCH TYPE J_1BBRANC_,
          GSTIN  TYPE J_1IGSTCD3,
        END OF TY_J_1BBRANCH.

TYPES : BEGIN OF TY_TVKBT,
          BEZEI TYPE BEZEI20,
          SPRAS TYPE SPRAS,
          VKBUR TYPE VKBUR,
        END OF TY_TVKBT.

TYPES : BEGIN OF TY_TVGRT,
          BEZEI TYPE BEZEI20,
          SPRAS TYPE SPRAS,
          VKGRP TYPE VKGRP,
        END OF TY_TVGRT.

TYPES : BEGIN OF TY_T001W,
          NAME1 TYPE NAME1,
          WERKS TYPE WERKS_D,
          SPRAS TYPE SPRAS,
        END OF TY_T001W.

TYPES : BEGIN OF TY_VBAK,
          VBELN TYPE VBELN_VA,
          AUDAT TYPE AUDAT,
          KVGR1 TYPE KVGR1,
        END OF TY_VBAK.

TYPES : BEGIN OF    TY_CGRP1,
          BEZEI TYPE BEZEI20,
          SPRAS TYPE  SPRAS,
          KVGR1 TYPE KVGR1,
        END OF TY_CGRP1.

TYPES : BEGIN OF TY_LIKP1,
          WADAT_IST TYPE  LIKP-WADAT_IST,
          WADAT     TYPE LIKP-WADAT,
          VBELN     TYPE LIKP-VBELN,
        END OF TY_LIKP1.

TYPES : BEGIN OF TY_T188T,
          VTEXT TYPE BEZEI20,
          SPRAS TYPE SPRAS,
          KONDA TYPE     KONDA,
        END OF TY_T188T.

TYPES : BEGIN OF TY_TVZBT,
          VTEXT TYPE DZTERM_BEZ,
          SPRAS TYPE SPRAS,
          ZTERM TYPE  DZTERM,
        END OF TY_TVZBT.

TYPES : BEGIN OF TY_T052U,
          SPRAS TYPE SPRAS,
          ZTERM TYPE DZTERM,
          TEXT1 TYPE TEXT1_052,
        END OF TY_T052U.

TYPES : BEGIN OF TY_T052,
          ZTAG1 TYPE DZTAGE,
          ZTERM TYPE DZTERM,
        END OF TY_T052.

TYPES : BEGIN OF TY_VBRP3,
          VBELN TYPE VBELN_VF,
          CHARG TYPE CHARG_D,
          POSNR TYPE POSNR_VF,
          MATNR TYPE  MATNR,
          PSTYV TYPE PSTYV,
        END OF TY_VBRP3.

TYPES : BEGIN OF TY_T179T,
          VTEXT TYPE BEZEI40,
          PRODH TYPE PRODH_D,
          SPRAS TYPE   SPRAS,
        END OF TY_T179T.

TYPES : BEGIN OF TY_MSEG,  "MBLNR,VBELN_IM, MATNR, menge
          MBLNR    TYPE MBLNR,
          zeile    type MBLPO,
          mjahr    type mjahr,
          BUDAT_MKPF type budat,
          MATNR    TYPE MATNR,
          charg    type lips-charg,
          menge    type menge_d,
          erfmg    type menge_d,
          VBELN_IM TYPE VBELN_VL,
          vbelp_im type lips-posnr,
          bwart    type bwart,
          smbln    type mblnr,
          SJAHR    type mjahr,
          SMBLP    type mblpo,
        END OF TY_MSEG.


TYPES : BEGIN OF TY_TCURT,
          WAERS TYPE TCURT-WAERS,
          LTEXT TYPE TCURT-LTEXT,
        END OF TY_TCURT.

TYPES : BEGIN OF TY_KNVP,
          PERNR TYPE PERNR_D,
          KUNN2 TYPE KUNN2,
          KUNNR TYPE  KUNNR,
          VKORG TYPE VKORG,
          VTWEG TYPE VTWEG,
          SPART TYPE SPART,
          PARVW TYPE PARVW,
          LIFNR TYPE LIFNR,
        END OF TY_KNVP.

TYPES : BEGIN OF TY_LFB1,
          LIFNR TYPE LIFNR,
          PERNR TYPE PERNR_D,
        END OF TY_LFB1.

TYPES : BEGIN OF TY_PA0001,
          ENAME TYPE EMNAM,
          PERNR TYPE PERSNO,
        END OF TY_PA0001.

TYPES : BEGIN OF TY_MARA,
          MATKL TYPE MARA-MATKL,
          EXTWG TYPE MARA-EXTWG,
          MATNR TYPE MARA-MATNR,
        END OF TY_MARA.

TYPES : BEGIN OF TY_T023T,
          WGBEZ TYPE WGBEZ,
          MATKL TYPE MATKL,
          SPRAS TYPE SPRAS,
        END OF TY_T023T.

TYPES : BEGIN OF TY_TWEWT,
          EWBEZ TYPE EWBEZ,
          SPRAS TYPE SPRAS,
          EXTWG TYPE EXTWG,
        END OF TY_TWEWT.

TYPES : BEGIN OF TY_T005T,
          LANDX TYPE T005T-LANDX,
          SPRAS TYPE T005T-SPRAS,
          LAND1 TYPE T005T-LAND1,
        END OF TY_T005T.

TYPES : BEGIN OF TY_MCHA,
          VFDAT TYPE VFDAT,
          MATNR TYPE MATNR,
          WERKS TYPE WERKS_D,
          CHARG TYPE CHARG_D,
        END OF TY_MCHA.

TYPES : BEGIN OF TY_T171T,
          SPRAS TYPE T171T-SPRAS,
          BZIRK TYPE T171T-BZIRK,
          BZTXT TYPE T171T-BZTXT,
        END OF TY_T171T.

TYPES : BEGIN OF TY_MARC,
          STEUC TYPE MARC-STEUC,
          MAABC TYPE MARC-MAABC,
          MATNR TYPE MARC-MATNR,
          WERKS TYPE MARC-WERKS,
        END OF TY_MARC.

TYPES : BEGIN OF TY_TMABCT,
          MAABC TYPE TMABCT-MAABC,
          SPRAS TYPE TMABCT-SPRAS,
          TMABC TYPE TMABCT-TMABC,
        END OF TY_TMABCT.

TYPES : BEGIN OF TY_TVAP,
          PRSFD TYPE TVAP-PRSFD,
          PSTYV TYPE TVAP-PSTYV,
        END OF TY_TVAP.

TYPES : BEGIN OF TY_MVKE,
          LFMNG TYPE MVKE-LFMNG,
          KTGRM TYPE MVKE-KTGRM,
          SCMNG TYPE MVKE-SCMNG,
          MVGR1 TYPE MVKE-MVGR1,
          MATNR TYPE MVKE-MATNR,
          VKORG TYPE MVKE-VKORG,
          VTWEG TYPE MVKE-VTWEG,
        END OF TY_MVKE.

TYPES : BEGIN OF TY_BUT0IS,
          PARTNER    TYPE  BUT0IS-PARTNER,
          IND_SECTOR TYPE  BUT0IS-IND_SECTOR,

        END OF TY_BUT0IS.

TYPES : BEGIN OF TY_TB038B,

          IND_SECTOR TYPE TB038B-IND_SECTOR,
  TEXT       TYPE TB038B-TEXT,
        END OF TY_TB038B.
data : begin of i_mkpf occurs 0,
       mblnr like mkpf-mblnr,
       mjahr like mkpf-mjahr,
       bldat like mkpf-bldat,
       budat like mkpf-budat,
       le_vbeln like mkpf-le_vbeln,
       end of i_mkpf.
data : wa_mkpf like i_mkpf.
data : begin of i_knmt occurs 0,
       VKORG   like knmt-vkorg,
VTWEG  like knmt-vtweg,
KUNNR   like knmt-kunnr,
MATNR  like knmt-matnr,
KDMAT   like knmt-kdmat,
POSTX  like knmt-postx,
end of i_knmt.
data : wa_knmt like i_knmt.
DATA :
  LOCNAME TYPE T001W-NAME1,
  STEUC   TYPE MARC-STEUC,
  MAABC   TYPE MARC-MAABC,
  PRSFD   TYPE TVAP-PRSFD.
DATA : IT_VBRK            TYPE TABLE OF TS_VBRK,
       IT_VBRK1           TYPE TABLE OF TS_VBRK,
       IT_VBRK2           TYPE TABLE OF TS_VBRK,
       WA_VBRK            TYPE TS_VBRK,
       WA_VBRK1           TYPE TS_VBRK,
       WA_VBRK2           TYPE TS_VBRK,
       IT_VBRP            TYPE TABLE OF TS_VBRP,
       IT_VBRP_n          TYPE TABLE OF TS_VBRP,
       WA_VBRP            TYPE TS_VBRP,
       wa_vbrp_n          TYPE TS_VBRP,
       IT_VBRP1           TYPE TABLE OF TS_VBRP1,
       WA_VBRP1           TYPE TS_VBRP1,
       IT_VBRP2           TYPE TABLE OF TS_VBRP2,
       WA_VBRP2           TYPE TS_VBRP2,
       IT_LIPS            TYPE TABLE OF TS_LIPS,
       WA_LIPS            TYPE  TS_LIPS,
       IT_KNA1            TYPE TABLE OF TS_KNA1,
       WA_KNA1            TYPE TS_KNA1,
       IT_KONV            TYPE TABLE OF TS_PRCD_ELEMENTS,
       WA_KONV            TYPE TS_PRCD_ELEMENTS,
       IT_FINAL           TYPE TABLE OF TS_FINAL,
       WA_FINAL           TYPE TS_FINAL,
       IT_EKKO            TYPE TABLE OF TY_EKKO,
       WA_EKKO            TYPE TY_EKKO,
       IT_PRCD            TYPE TABLE OF  TS_PRCD_ELEMENTS1,
       WA_PRCD            TYPE  TS_PRCD_ELEMENTS1,
*       it_zgst_region_map TYPE TABLE OF zgst_region_map,
*       wa_zgst_region_map TYPE zgst_region_map,
       IT_ZGST_REGION_MAP TYPE TABLE OF J_1ISTATECDM,
       WA_ZGST_REGION_MAP TYPE J_1ISTATECDM,
       IT_LINES           TYPE /OSP/TT_TLINE,
       WA_LINES           TYPE TLINE,
       IT_TABA            TYPE STANDARD TABLE OF DD07V,
       IT_TABB            TYPE STANDARD TABLE OF DD07V,
       WA_BSEG            TYPE BSEG,
       IT_BSEG            TYPE TABLE OF BSEG,
       WA_BKPF            TYPE BKPF,
       IT_BKPF            TYPE TABLE OF BKPF,
       WA_SKAT            TYPE SKAT,
       IT_SKAT            TYPE TABLE OF SKAT,
       wa_mseg            type ty_mseg,
       wa_mseg1           type ty_mseg.

DATA :E_J_1IG_INVREFNUM TYPE  J_1IG_INVREFNUM.
DATA :WA_ZTRANSP_D  TYPE  ZTRANSP_D.


DATA: IT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FIELDCAT TYPE SLIS_FIELDCAT_ALV.
DATA : WA_LAYOUT TYPE SLIS_LAYOUT_ALV .
DATA : LV_LRNO          TYPE TDLINE,       "Local Variable for LR No.
       LV_LRDT          TYPE TDLINE,       "Local Variable for LR Date
       VEH_NO           TYPE TDLINE,       "Local Variable for LR Date
       LV_GENMTXT(255)  TYPE C,    "Local Variable for Generic Material Text
       LV_CUST_NAME(70) TYPE C,
       LV_AWKEY         TYPE TDOBNAME,    "Local Variable for TDNAME
       LV_TIME          TYPE DLYDY,   "Local Variable for time in days
       LV_FKDAT         TYPE SY-DATUM,       "Local Variable Invoice Posting Date
       TKNUM            TYPE VTTP-TKNUM.

DATA: LV_REPID TYPE SY-REPID.

DATA:WA_VBAP  TYPE VBAP,
     IT_VBAP  TYPE TABLE OF VBAP,
     WA_BKPF1 TYPE BKPF,
     IT_BKPF1 TYPE TABLE OF BKPF.

DATA:IT_GLC TYPE TABLE OF PRCD_ELEMENTS,
     WA_GLC TYPE PRCD_ELEMENTS,
     IT_GLD TYPE TABLE OF SKAT,
     WA_GLD TYPE SKAT.

DATA : LV_WERKS TYPE WERKS_D.
DATA : LV_PARVA TYPE USR05-PARVA.
DATA : LV_PLANT TYPE STRING.
DATA: REPNAME    LIKE SY-REPID,
      G_SAVE(1)  TYPE C,
      G_EXIT(1)  TYPE C,
      G_VARIANT  LIKE DISVARIANT,
      GX_VARIANT LIKE DISVARIANT.

DATA: BDCDATA       LIKE BDCDATA OCCURS 0 WITH HEADER LINE,
      WA_CTU_PARAMS TYPE CTU_PARAMS,
      IT_MSG        TYPE TABLE OF BDCMSGCOLL,
      WA_MSG        TYPE BDCMSGCOLL,
      W_MSG         TYPE BDCMSGCOLL.

DATA : LV_STRING TYPE STRING.
DATA : IV_AUDAT TYPE TABLE OF TY_VBAK,
       LV_AUDAT TYPE TY_VBAK.


DATA : IT_STATE TYPE TABLE OF TY_STATE.
DATA : IT_ADR   TYPE TABLE OF TY_ADR.
DATA : IT_IRN   TYPE TABLE OF TY_IRN.
DATA : IT_FKDAT TYPE TABLE OF TY_FKDAT.
DATA : IT_TVKOT TYPE TABLE OF TY_TVKOT,
       W_TVKOT  TYPE TY_TVKOT.
DATA : IT_TVTWT TYPE TABLE OF TY_TVTWT,
       WA_TVTWT TYPE TY_TVTWT.
DATA : IT_TSPAT TYPE TABLE OF TY_TSPAT,
       WA_TSPAT TYPE TY_TSPAT.
DATA : IT_TVFKT TYPE TABLE OF TY_TVFKT,
       WA_TVFKT TYPE TY_TVFKT.
DATA : IT_J_1BBRANCH TYPE TABLE OF TY_J_1BBRANCH,
       WA_J_1BBRANCH TYPE TY_J_1BBRANCH.
DATA : IT_TVKBT TYPE TABLE OF TY_TVKBT,
       WA_TVKBT TYPE TY_TVKBT.
DATA : IT_TVGRT TYPE TABLE OF TY_TVGRT,
       WA_TVGRT TYPE  TY_TVGRT.
DATA : IT_T001W TYPE TABLE OF TY_T001W,
       WA_T001W TYPE TY_T001W.
DATA : IV_CGRP1 TYPE TABLE OF TY_CGRP1,
       WA_CGRP1 TYPE TY_CGRP1.
DATA : IT_LIKP1 TYPE TABLE OF  TY_LIKP1,
       WA_LIKP1 TYPE TY_LIKP1.
DATA : IV_VTEXT TYPE TABLE OF TY_T188T.
DATA : IV_ZTERM_TXT TYPE TABLE OF TY_TVZBT.
DATA : IT_T052U  TYPE TABLE OF TY_T052U.
DATA : IV_PAYMENT_TERM TYPE TABLE OF TY_T052.
DATA : LV_POSTX TYPE TABLE OF TY_KNMT.
DATA : IV_CHARG TYPE TABLE OF TY_VBRP3.
DATA : IT_T179T TYPE TABLE OF TY_T179T.
DATA : IT_MSEG TYPE TABLE OF TY_MSEG.
DATA : IT_MSEG1  TYPE TABLE OF TY_MSEG.
DATA : IT_TCURT TYPE TABLE OF TY_TCURT.
DATA : IT_KNVP TYPE TABLE OF TY_KNVP.
DATA : IT_LFB1 TYPE TABLE OF TY_LFB1.
DATA : IT_PA0001 TYPE TABLE OF TY_PA0001.
DATA : IT_MARA TYPE TABLE OF TY_MARA.
DATA : IT_TCURX TYPE TABLE OF TCURX.
DATA : IT_T023T TYPE TABLE OF TY_T023T.
DATA : IT_TWEWT TYPE TABLE OF TY_TWEWT.
DATA : IT_ZTRANSP_D TYPE TABLE OF ZTRANSP_D.
DATA : IT_T005T TYPE TABLE OF TY_T005T.
DATA : IT_MCHA TYPE TABLE OF TY_MCHA.
DATA : IT_T171T TYPE TABLE OF TY_T171T.
DATA : IT_MARC TYPE TABLE OF TY_MARC.
DATA : IT_TMABCT TYPE TABLE OF  TY_TMABCT.
DATA : IT_TVAP TYPE TABLE OF TY_TVAP.
DATA : IT_MVKE TYPE TABLE OF TY_MVKE.
DATA : IT_BUT0IS TYPE TABLE OF TY_BUT0IS.
DATA : IT_TB038B TYPE TABLE OF TY_TB038B.
DATA : IT_VBPA1 TYPE TABLE OF TY_VBPA.
data : wa_mvke like it_mvke.
data : begin of it_vbrk_r occurs 0,
            vbeln like vbrk-vbeln,
            sfakn like vbrk-sfakn,
            fkdat like vbrk-fkdat,
            end of it_vbrk_r.
data : wa_vbrk_r like it_vbrk_r.
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-054.
  PARAMETERS      p_vkorg like vbrk-vkorg OBLIGATORY default '1000'.
  SELECT-OPTIONS: "S_VKORG FOR VBRK-VKORG OBLIGATORY ,
                  S_VTWEG FOR VBRK-VTWEG ,"OBLIGATORY, "commented by surabhi 02.06.2023
                  S_SPART FOR VBRK-SPART,
                  S_FKART FOR VBRK-FKART," OBLIGATORY,
                  S_WERKS FOR VBRP-WERKS ,
                  S_VBELN FOR VBRK-VBELN,
                  S_XBLNR FOR VBRK-XBLNR no-DISPLAY,
                  S_FKDAT FOR VBRK-FKDAT OBLIGATORY,
                  S_MATNR FOR VBRP-MATNR no-DISPLAY,
*                  S_VKBUR FOR VBRP-VKBUR,
                  S_KUNAG FOR VBRK-KUNAG.
*                  S_ERDAT FOR VBRK-ERDAT.
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN : BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-004.
*  PARAMETERS : CB1 AS CHECKBOX.    "EDITED BY AMIT"
  PARAMETERS : rd1 RADIOBUTTON GROUP A1,
               rd2 RADIOBUTTON GROUP A1,
               rd3 RADIOBUTTON GROUP a1.
SELECTION-SCREEN END OF BLOCK B3.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-120.
  PARAMETERS:
         P_VARI LIKE DISVARIANT-VARIANT. "User Layout
SELECTION-SCREEN END OF BLOCK B2.

INITIALIZATION.
  REPNAME = SY-REPID.
  PERFORM INITIALIZE_VARIANT.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_VARI.
  PERFORM F4_FOR_VARIANT.

AT SELECTION-SCREEN.
  IF SY-TCODE = 'ZSD0020'.
    SY-TITLE = 'Sales Register Report_Actual COGS'.
  ENDIF.
  PERFORM PAI_OF_SELECTION_SCREEN.

  SELECT SINGLE PARVA INTO LV_PARVA FROM USR05
    WHERE BNAME = SY-UNAME
  AND  PARID = 'ZSD_CNF'.
  IF LV_PARVA = 'X'.
    IF LV_WERKS NE S_WERKS-LOW.
      CONCATENATE  TEXT-060 S_WERKS-LOW TEXT-061  INTO LV_PLANT SEPARATED BY SPACE.
      MESSAGE LV_PLANT TYPE 'E'.
      STOP.
    ENDIF.
  ENDIF.

START-OF-SELECTION.

  PERFORM FETCH_DATA.
  PERFORM LOOP_DATA1.
  PERFORM FIELDCAT1.
  PERFORM DISPLAY.

*&---------------------------------------------------------------------*
*& Form FETCH_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FETCH_DATA .
  LOOP AT S_FKART ASSIGNING FIELD-SYMBOL(<LFS_FKART>).
    IF <LFS_FKART>-LOW EQ 'ZS1' OR
       <LFS_FKART>-LOW EQ 'ZS2' OR
       <LFS_FKART>-LOW EQ 'S2'.
      CLEAR:<LFS_FKART>-LOW.
    ELSEIF <LFS_FKART>-HIGH EQ 'ZS1' OR
           <LFS_FKART>-HIGH EQ 'ZS2' OR
           <LFS_FKART>-HIGH EQ 'S2'.
      CLEAR:<LFS_FKART>-HIGH.
    ENDIF.
  ENDLOOP.
  data : begin of i_fkart occurs 0,
           fkart like ztb_fkart-fkart, "include STRUCTURE ZTB_FKART.
         end of i_fkart.

 if rd1 = 'X'.
  select *  from ztb_fkart into corresponding fields of table
                  i_fkart where vkorg = p_vkorg and
                                fkart in s_fkart and
                                flag = 'A'.
 elseif rd2 = 'X'.
  select *  from ztb_fkart into corresponding fields of table
                  i_fkart where vkorg = p_vkorg and
                                fkart in s_fkart and
                                flag = 'B'.
 else.
  select *  from ztb_fkart into corresponding fields of table
                  i_fkart where vkorg = p_vkorg and
                                fkart in s_fkart." and
 endif.

   if s_fkart[] is not INITIAL.
     if i_fkart[] is initial.
      Message 'No Data Found' type 'I' DISPLAY LIKE 'W'.
      leave to TRANSACTION 'ZSD0020'.
     endif.
   endif.
   if i_fkart[] is not INITIAL.
    refresh s_fkart[].
    loop at i_fkart.
      S_FKART-SIGN = 'I'.
      S_FKART-OPTION = 'EQ'.
      S_FKART-LOW = i_fkart-fkart. "'XXXX'.
      append s_fkart.
    endloop.
   endif.

  SELECT  VBELN
          FKART
          FKTYP
          WAERK
          VKORG
          VTWEG
          KNUMV
          FKDAT
          GJAHR
          INCO1
          REGIO
          BUKRS
          NETWR
          ERDAT
          KUNAG
          SFAKN
          SPART
          XBLNR
          MWSBK
          FKSTO
          BUPLA
          VF_STATUS
          BUCHK
          VBTYP
          ZTERM
          ZUONR
          KURRF
          BELNR
          RFBSK
  FROM VBRK INTO TABLE IT_VBRK
    WHERE vkorg = p_vkorg    and
          SPART IN S_SPART   and
          FKART IN S_FKART   and
          VBELN IN S_VBELN   and
          fkdat in s_fkdat   and
          KUNAG IN S_KUNAG."   and
  if sy-subrc eq 0.
   delete it_vbrk where fkart eq 'ZPV1'.
  endif.
*if RD1 = 'X'.
*delete it_vbrk where  fkart = 'ZCRM'.
*delete it_vbrk where  fkart = 'ZSCR'.
*delete it_vbrk where  fkart = 'ZDTP'.
*endif.


  IT_VBRK1[] = IT_VBRK[].
  IT_VBRK2[] = IT_VBRK[].

  IF IT_VBRK1 IS NOT INITIAL.
    SELECT   WAERS , LTEXT FROM TCURT
        INTO TABLE @IT_TCURT
      FOR ALL ENTRIES IN @IT_VBRK1
       WHERE WAERS = @IT_VBRK1-WAERK.
  ENDIF.

  IF IT_VBRK IS NOT INITIAL.
    SELECT   VBELN
             POSNR
             FKIMG
             NTGEW
             NETWR
             VGBEL
             VGTYP
             VGPOS
             AUBEL
             AUPOS
             MATNR
             CHARG
             PSTYV
             SPART
             WERKS
             VKGRP
             VKBUR
             KZWI1
             KZWI2
             KZWI3
             KZWI4
             PRCTR
             VKORG_AUFT
             VTWEG_AUFT
             BZIRK_AUFT
             MEINS
             FKLMG
             PRODH
             ERNAM
             ARKTX
             VRKME
             UMVKZ
             UMVKN
             UECHA
             KUNRG_ANA     "added for new logic
             wavwr
             fkart_ana
      FROM VBRP
      INTO CORRESPONDING FIELDS OF TABLE IT_VBRP
      FOR ALL ENTRIES IN IT_VBRK
      WHERE VBELN = IT_VBRK-VBELN
*     AND  MATNR IN S_MATNR
     AND WERKS IN S_WERKS.

  ENDIF.
*************************************************************************************
  SORT IT_VBRP BY VBELN.

  IF IT_VBRP[] IS NOT INITIAL.
    SELECT VBELN
           POSNR
           PSTYV
           MATNR
           WERKS
           VGPOS
           CHARG
           LFIMG
           UECHA
      FROM LIPS
      INTO TABLE IT_LIPS
      FOR ALL ENTRIES IN IT_VBRP
      WHERE: VBELN = IT_VBRP-VGBEL
             AND WERKS = IT_VBRP-WERKS
             AND LFIMG NE '0'.
  select mblnr mjahr budat bldat le_vbeln
            from mkpf into CORRESPONDING FIELDS OF table
            i_mkpf for all entries in it_vbrp
            where le_vbeln = IT_VBRP-VGBEL.
*  select * from vbfa into CORRESPONDING FIELDS OF table
*            IT_VBFA  for ALL ENTRIES IN it_vbrp
*                   where vbelv = it_vbrp-vgbel and
*                         bwart in  ( '601' , '641' ).
  ENDIF.

  IF IT_VBRP IS NOT INITIAL.
    SELECT EBELN
           KNUMV
           BEDAT
           FROM EKKO
           INTO TABLE IT_EKKO
           FOR ALL ENTRIES IN IT_VBRP
    WHERE EBELN = IT_VBRP-AUBEL.
    SELECT VBELN
           POSNR
           VGBEL
       FROM VBAP INTO CORRESPONDING FIELDS OF TABLE IT_VBAP
      FOR ALL ENTRIES IN IT_VBRP
      WHERE VBELN = IT_VBRP-AUBEL AND
    POSNR = IT_VBRP-AUPOS.

    IF IT_VBRK IS NOT INITIAL.
      SELECT WADAT_IST, WADAT, VBELN
        FROM LIKP INTO TABLE @IT_LIKP1
        FOR ALL ENTRIES IN @IT_VBRP
        WHERE VBELN = @IT_VBRP-VGBEL.
    ENDIF.
********************   EOC ***********

  ENDIF.
  SORT IT_EKKO BY EBELN."ck

  IF IT_EKKO IS NOT INITIAL.
    SELECT KNUMV
           KPOSN
           KSCHL
           KWERT
           FROM PRCD_ELEMENTS
           INTO TABLE IT_PRCD
           FOR ALL ENTRIES IN IT_EKKO
           WHERE KNUMV = IT_EKKO-KNUMV
           AND KPOSN = '0'
    AND KSCHL = 'ZSF2'.
  ENDIF.

  IF IT_VBRK IS NOT INITIAL.
    SELECT  KUNNR
            LAND1
            NAME1
            NAME2
            ORT01     "Customer City
            ADRNR
            NAME3
            NAME4
            REGIO
            STCD3
            J_1IPANNO
    FROM KNA1 INTO TABLE IT_KNA1
      FOR ALL ENTRIES IN IT_VBRK
    WHERE KUNNR = IT_VBRK-KUNAG.

    IF IT_KNA1 IS NOT INITIAL.
      SELECT * FROM J_1ISTATECDM
        INTO TABLE IT_ZGST_REGION_MAP
        FOR ALL ENTRIES IN IT_KNA1
        WHERE LAND1 = IT_KNA1-LAND1
      AND STD_STATE_CODE = IT_KNA1-REGIO.

      SELECT NAME1, ADDRNUMBER
        FROM ADRC INTO TABLE @IT_ADRC
        FOR ALL ENTRIES IN @IT_KNA1
        WHERE ADDRNUMBER = @IT_KNA1-ADRNR.

      SELECT PARTNER
          IND_SECTOR
          FROM BUT0IS INTO TABLE IT_BUT0IS
        FOR ALL ENTRIES IN IT_KNA1
        WHERE PARTNER = IT_KNA1-KUNNR.

      SELECT  IND_SECTOR, TEXT
             FROM TB038B
             INTO TABLE @IT_TB038B
            FOR ALL ENTRIES IN @IT_BUT0IS
             WHERE IND_SECTOR = @IT_BUT0IS-IND_SECTOR.

      SELECT LANDX, SPRAS, LAND1
        FROM T005T INTO TABLE @IT_T005T
        FOR ALL ENTRIES IN @IT_KNA1
        WHERE  SPRAS = @SY-LANGU
         AND   LAND1 = @IT_KNA1-LAND1.
    ENDIF.
  ENDIF.


  IF  IT_VBRP IS NOT INITIAL.
    SELECT VBELN
           PARVW
           KUNNR  FROM VBPA INTO TABLE IT_VBPA1
      FOR ALL ENTRIES IN IT_VBRP
      WHERE VBELN = IT_VBRP-VBELN.
  ENDIF.

  IF IT_VBRP IS NOT INITIAL.
    SELECT VBELN
           AUDAT
           AUART
           BSTNK
           BSTDK
      FROM VBAK
      INTO TABLE IT_VBAK_D
      FOR ALL ENTRIES IN IT_VBRP
    WHERE VBELN = IT_VBRP-AUBEL.
  ENDIF.

  IF IT_VBRP IS NOT INITIAL.
    SELECT MATNR
           CHARG
           HSDAT
           VFDAT
      FROM MCH1
      INTO TABLE IT_MCH1
      FOR ALL ENTRIES IN IT_VBRP
      WHERE MATNR = IT_VBRP-MATNR
    AND   CHARG = IT_VBRP-CHARG.
  ENDIF.
  IF IT_VBRP IS NOT INITIAL.
    SELECT VBELN
           PARVW
           KUNNR
      FROM VBPA
      INTO TABLE IT_VBPA
      FOR ALL ENTRIES IN IT_VBRP
      WHERE VBELN = IT_VBRP-VBELN
    AND   ( PARVW = 'ZP' OR  PARVW = 'ZT' ).
    IF SY-SUBRC = 0 AND IT_VBPA IS NOT INITIAL.
      IT_VBPA_TMP = IT_VBPA.
      SELECT  KUNNR
              NAME1
        FROM KNA1
        INTO TABLE IT_KNA1_D
        FOR ALL ENTRIES IN IT_VBPA
      WHERE KUNNR = IT_VBPA-KUNNR.

      SELECT LIFNR
             NAME1
        FROM LFA1
        INTO TABLE IT_LFA1
        FOR ALL ENTRIES IN IT_VBPA
      WHERE LIFNR = IT_VBPA-LIFNR.
    ENDIF.
  ENDIF.


  IF IT_VBRK IS NOT INITIAL.
    SELECT BUKRS,
           BRANCH,
           BUPLA_TYPE,
           ADRNR FROM J_1BBRANCH
           INTO TABLE @IT_STATE
           FOR ALL ENTRIES IN @IT_VBRK
           WHERE BUKRS = @IT_VBRK-BUKRS AND BRANCH = @IT_VBRK-BUPLA.
    IF SY-SUBRC  = 0.
      SELECT ADDRNUMBER,
             DATE_FROM,
             NATION,
             REGION FROM ADRC
             INTO TABLE @IT_ADR
             FOR ALL ENTRIES IN @IT_STATE
             WHERE ADDRNUMBER = @IT_STATE-ADRNR.
    ENDIF.

    SELECT BUKRS,
           DOCNO,
           DOC_YEAR,
           DOC_TYPE,
           IRN,
           ERDAT FROM J_1IG_INVREFNUM
           INTO TABLE @IT_IRN
           FOR ALL ENTRIES IN @IT_VBRK
           WHERE BUKRS = @IT_VBRK-BUKRS
           AND DOCNO =  @IT_VBRK-VBELN
           AND DOC_YEAR =  @IT_VBRK-GJAHR
           AND DOC_TYPE =  @IT_VBRK-FKART.
  ENDIF.

  IF IT_VBRK IS NOT INITIAL.
    SELECT  SPRAS, VKORG, VTEXT FROM TVKOT
            INTO TABLE @IT_TVKOT
            FOR ALL ENTRIES IN @IT_VBRK
            WHERE SPRAS = @SY-LANGU
            AND VKORG = @IT_VBRK-VKORG.

    SELECT SPRAS, VTWEG, VTEXT FROM TVTWT
            INTO TABLE @IT_TVTWT
            FOR ALL ENTRIES IN @IT_VBRK
            WHERE SPRAS = @SY-LANGU
            AND VTWEG = @IT_VBRK-VTWEG.

    SELECT  SPRAS, SPART, VTEXT   FROM TSPAT
            INTO TABLE @IT_TSPAT
            FOR ALL ENTRIES IN @IT_VBRK
            WHERE SPRAS = @SY-LANGU
            AND SPART = @IT_VBRK-SPART.

    SELECT  SPRAS, FKART, VTEXT  FROM TVFKT
           INTO TABLE @IT_TVFKT
           FOR ALL ENTRIES IN @IT_VBRK
           WHERE SPRAS = @SY-LANGU
           AND FKART = @IT_VBRK-FKART.

    SELECT BUKRS, BRANCH, GSTIN  FROM  J_1BBRANCH
           INTO TABLE @IT_J_1BBRANCH
           FOR ALL ENTRIES IN @IT_VBRK
           WHERE BUKRS = @IT_VBRK-BUKRS
           AND  BRANCH = @IT_VBRK-BUPLA.

    SELECT VTEXT, SPRAS, ZTERM
          FROM TVZBT
          INTO TABLE @IV_ZTERM_TXT
          FOR ALL ENTRIES IN @IT_VBRK
          WHERE SPRAS EQ 'E'
          AND  ZTERM EQ @IT_VBRK-ZTERM.

    SELECT SPRAS, ZTERM , TEXT1
           FROM T052U
           INTO TABLE @IT_T052U
           WHERE SPRAS = 'E'.

    SELECT ZTAG1, ZTERM
           FROM T052
           INTO TABLE @IV_PAYMENT_TERM
      FOR ALL ENTRIES IN @IT_VBRK
     WHERE ZTERM = @IT_VBRK-ZTERM.

    SELECT PERNR, KUNN2,KUNNR, VKORG, VTWEG, SPART, PARVW , lifnr FROM KNVP INTO TABLE @IT_KNVP
      FOR ALL ENTRIES IN @IT_VBRK
               WHERE  KUNNR = @IT_VBRK-KUNAG
               AND    VKORG = @IT_VBRK-VKORG
               AND    VTWEG = @IT_VBRK-VTWEG
               AND    SPART  = @IT_VBRK-SPART.
*               AND    PARVW   = 'VE'.

    SELECT ENAME, PERNR
            FROM PA0001
            INTO TABLE @IT_PA0001
      FOR ALL ENTRIES IN @IT_KNVP
            WHERE PERNR =  @IT_KNVP-PERNR.

    SELECT * FROM ZTRANSP_D
             INTO TABLE IT_ZTRANSP_D
      FOR ALL ENTRIES IN IT_VBRK
      WHERE ZBILL_NO = IT_VBRK-VBELN.

  ENDIF.

  SELECT  VTEXT, PRODH, SPRAS
         FROM T179T INTO TABLE @IT_T179T
         WHERE SPRAS = 'E'.

  IF IT_VBRP IS NOT INITIAL.
    SELECT BEZEI,
           SPRAS,
           VKBUR FROM TVKBT
           INTO TABLE @IT_TVKBT
      FOR ALL ENTRIES IN  @IT_VBRP
           WHERE SPRAS = 'EN'
           AND VKBUR = @IT_VBRP-VKBUR.

    SELECT BEZEI,
           SPRAS,
           VKGRP FROM TVGRT
           INTO TABLE @IT_TVGRT
           FOR ALL ENTRIES IN @IT_VBRP
           WHERE SPRAS = 'EN'
           AND   VKGRP = @IT_VBRP-VKGRP.

    SELECT NAME1,
           WERKS,
           SPRAS FROM T001W
           INTO TABLE @IT_T001W
           FOR ALL ENTRIES IN  @IT_VBRP
           WHERE SPRAS = @SY-LANGU
           AND   WERKS =  @IT_VBRP-WERKS.

    SELECT  VBELN, AUDAT, KVGR1
             FROM VBAK
             INTO TABLE @IV_AUDAT
            FOR ALL ENTRIES IN @IT_VBRP
      WHERE VBELN = @IT_VBRP-AUBEL.

    SELECT   BEZEI, SPRAS, KVGR1
             FROM TVV1T
             INTO TABLE @IV_CGRP1
             FOR ALL ENTRIES IN @IV_AUDAT
             WHERE SPRAS = 'E'
             AND  KVGR1 = @IV_AUDAT-KVGR1.

    SELECT  VBELN,
            ERDAT,
            WADAT,
           WADAT_IST
           FROM LIKP
      INTO TABLE @IT_LIKP
         FOR ALL ENTRIES IN @IT_VBRP
      WHERE VBELN = @IT_VBRP-VGBEL.

    SELECT VTEXT, SPRAS, KONDA
           FROM T188T
           INTO TABLE @IV_VTEXT
      FOR ALL ENTRIES IN @IT_VBRP
           WHERE SPRAS = 'E'
            AND  KONDA = ( SELECT DISTINCT KONDA_AUFT
                                  FROM VBRP
                                  WHERE VBELN = @IT_VBRP-VBELN
                                  AND POSNR = @IT_VBRP-POSNR ).

    SELECT  MBLNR,
            zeile,
            mjahr,
            BUDAT_MKPF,
            MATNR,
            charg,
            menge,
            erfmg,
            VBELN_IM,
            vbelp_im,
            bwart,
            smbln,
            SJAHR,
            smblp
            from mseg
           INTO TABLE @IT_MSEG
           FOR ALL ENTRIES IN @IT_VBRP
           WHERE VBELN_IM = @IT_VBRP-VGBEL
           AND MATNR = @IT_VBRP-MATNR and
               menge ne 0 and
               bwart in ( '601' , '641' ,
                          '655' ).
*if sy-subrc eq 0.
*   IT_MSEG1[] = IT_MSEG[].
*   delete it_mseg where bwart = '602'.
*   sort it_mseg1 by mblnr mjahr.
*   sort it_mseg  by mblnr mjahr.
*   loop at it_mseg into wa_mseg.
*      read table it_mseg1 into wa_mseg1
*            with key smbln = wa_mseg-mblnr
*                     sjahr = wa_mseg-mjahr
*                     smblp = wa_mseg-zeile.
*      if sy-subrc eq 0.
*        clear : wa_mseg.
*        modify it_mseg from wa_mseg.
*      endif.
*   endloop.
*   delete it_mseg where mblnr = ''.
*endif.
sort it_mseg by mblnr mjahr vbeln_im vbelp_im.
delete ADJACENT DUPLICATES FROM it_mseg
               COMPARING vbeln_im vbelp_im.

    SELECT MATKL,EXTWG, MATNR
            FROM MARA
            INTO TABLE @IT_MARA
      FOR ALL ENTRIES IN @IT_VBRP
       WHERE MATNR =  @IT_VBRP-MATNR.

    SELECT  WGBEZ, MATKL, SPRAS
           FROM T023T INTO TABLE @IT_T023T
      FOR ALL ENTRIES IN @IT_MARA
       WHERE MATKL =  @IT_MARA-MATKL
      AND SPRAS = 'E'.

    SELECT  EWBEZ, SPRAS, EXTWG
       FROM TWEWT INTO TABLE @IT_TWEWT
      FOR ALL ENTRIES IN @IT_MARA
       WHERE SPRAS = 'E'
      AND EXTWG = @IT_MARA-EXTWG.

    SELECT VFDAT, MATNR, WERKS, CHARG
      FROM MCHA
      INTO TABLE @IT_MCHA
      FOR ALL ENTRIES IN @IT_VBRP
      WHERE MATNR = @IT_VBRP-MATNR
      AND   WERKS = @IT_VBRP-WERKS
      AND   CHARG = @IT_VBRP-CHARG.

    SELECT  SPRAS, BZIRK, BZTXT FROM T171T INTO TABLE  @IT_T171T
      FOR ALL ENTRIES IN @IT_VBRP
                       WHERE SPRAS = 'EN'
                       AND  BZIRK =  @IT_VBRP-BZIRK_AUFT.

    SELECT  STEUC MAABC MATNR WERKS FROM MARC
           INTO TABLE IT_MARC
           FOR ALL ENTRIES IN IT_VBRP
           WHERE MATNR = IT_VBRP-MATNR AND WERKS = IT_VBRP-WERKS.

    SELECT   MAABC SPRAS TMABC
             FROM TMABCT
            INTO TABLE IT_TMABCT
            FOR ALL ENTRIES IN IT_MARC
            WHERE MAABC = IT_MARC-MAABC
            AND SPRAS = 'EN'.

    SELECT  PRSFD PSTYV
            FROM TVAP INTO TABLE IT_TVAP
            FOR ALL ENTRIES IN IT_VBRP
            WHERE PSTYV = IT_VBRP-PSTYV.

  ENDIF.
**********************************

ENDFORM.

FORM DISPLAY .
  DATA: VARIANT TYPE DISVARIANT.
  VARIANT-REPORT = SY-REPID.
  VARIANT-USERNAME  = SY-UNAME.
  WA_LAYOUT-ZEBRA = 'X' .
  WA_LAYOUT-COLWIDTH_OPTIMIZE = 'X' .
  LV_REPID = SY-REPID.
*DATA: lv_repid TYPE sy-rep
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM      = LV_REPID "'ZSD_SALES_REG' "SY-REPID
      IS_LAYOUT               = WA_LAYOUT
      IT_FIELDCAT             = IT_FIELDCAT
      I_CALLBACK_USER_COMMAND = 'UCOMM'
      I_SAVE                  = 'A'
      IS_VARIANT              = VARIANT
    TABLES
      T_OUTTAB                = IT_FINAL
    EXCEPTIONS
      PROGRAM_ERROR           = 1
      OTHERS                  = 2.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
          WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
* Implement suitable error handling here
  ENDIF.

ENDFORM.

FORM UCOMM USING OK_CODE TYPE SY-UCOMM
                 SELFIELD TYPE SLIS_SELFIELD.
  .
  CASE OK_CODE.
    WHEN '&IC1'.
      IF SELFIELD-TABNAME = 'IT_FINAL'.
        IF SELFIELD-FIELDNAME = 'VBELN'.
          READ TABLE IT_FINAL INTO WA_FINAL INDEX SELFIELD-TABINDEX.
          IF SY-SUBRC = 0.
            CLEAR:BDCDATA,BDCDATA[].
            PERFORM BDC_DYNPRO      USING 'SAPMV60A' '0101'.
            PERFORM BDC_FIELD       USING 'VBRK-VBELN'
                                               WA_FINAL-VBELN.
            CALL TRANSACTION 'VF03' USING BDCDATA
                                OPTIONS FROM WA_CTU_PARAMS
                                MESSAGES INTO IT_MSG.
          ENDIF.
          CLEAR : WA_FINAL.
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
FORM LOOP_DATA1.
data : lv_amt type dmbtr,
       lv_amt1 type dmbt2.
  SELECT VALFROM FROM SETLEAF INTO TABLE @DATA(SET) WHERE SETNAME = 'DTPFKART'.
  IF IT_VBRK IS NOT INITIAL.
    SELECT * FROM TINCT INTO TABLE @DATA(IT_TINCT)
      FOR ALL ENTRIES IN @IT_VBRK
      WHERE INCO1 = @IT_VBRK-INCO1 AND SPRAS = 'E'.
  ENDIF.

  select VKORG VTWEG KUNNR MATNR kdmat  POSTX
         from knmt into corresponding fields of table
         i_knmt for all entries in it_vbrk
         where vkorg = it_vbrk-vkorg and
               kunnr = it_vbrk-kunag.

 select vbeln sfakn fkdat from vbrk into corresponding fields of table
               it_vbrk_r for ALL ENTRIES IN  it_vbrk
               where sfakn = it_vbrk-vbeln .

break ctplabap.
data : wa_vbrp_t like it_vbrp.
 IT_VBRP_n[] = IT_VBRP[].

 delete it_vbrp_n where fkimg = 0.
 delete IT_VBRP where fkart_ana = 'S1'.
 delete IT_VBRP where fkart_ana = 'S2'.
 sort IT_VBFA by vbelv posnv vbeln DESCENDING.
 delete ADJACENT DUPLICATES FROM it_vbfa
                   COMPARING vbelv posnv.
  if it_vbrp[] is not INITIAL.
    select  LFMNG
            KTGRM
            SCMNG
            MVGR1
            MATNR
            VKORG
            VTWEG from mvke into
            corresponding fields of table it_mvke
            for all entries in it_vbrp where
                         matnr = it_vbrp-matnr and
                         vkorg = p_vkorg and
                         vtweg in s_vtweg.
  endif.
  LOOP AT IT_VBRP INTO WA_VBRP where charg ne ''  or
                        ( fkart_ana eq 'ZDTP' or
                          fkart_ana eq 'ZCRM'  or
                          fkart_ana eq 'ZETP'  or
                          fkart_ana eq 'ZREN'  or
                          fkart_ana eq 'ZSCR'  or
                          fkart_ana eq 'ZDRM'  or
                          fkart_ana eq 'ZBV' ).
    clear : wa_final.
    clear : wa_vbrk.
    read table it_vbrk into wa_vbrk with
             key vbeln = wa_vbrp-vbeln
                 fkart = 'ZPV1'.
    check sy-subrc eq 4.
    WA_FINAL-VBELN  = WA_VBRP-VBELN.
    WA_FINAL-POSNR  = WA_VBRP-POSNR.
    WA_FINAL-NTGEW  = WA_VBRP-NTGEW.
    WA_FINAL-MEINS  = WA_VBRP-MEINS.
    WA_FINAL-PRODH  = WA_VBRP-PRODH.
    WA_FINAL-VRKME = WA_VBRP-VRKME.
    WA_FINAL-CHARG_1 = WA_VBRP-CHARG.
    WA_FINAL-ARKTX_1 = WA_VBRP-ARKTX.
    WA_FINAL-MATNR   = WA_VBRP-MATNR.
    wa_final-AUBEL   = wa_vbrp-AUBEL.
*    wa_final-fkdat   = wa_vbrk-fkdat.
    clear : wa_lips.
    read table it_lips into wa_lips with key
                         vbeln = wa_vbrp-vgbel
                         posnr = wa_vbrp-VGPOS
                         charg = wa_vbrp-charg.
    if sy-subrc eq 0.
    WA_FINAL-LMENG_1   = wa_lips-lfimg. "RP-FKIMG.
    wa_vbrp-fkimg      = wa_lips-lfimg.
    else.
     WA_FINAL-LMENG_1   = WA_VBRP-FKIMG.
    endif.
    READ TABLE IT_VBAK_D INTO DATA(W_AUDAT) WITH KEY VBELN = WA_VBRP-AUBEL.
    if sy-subrc eq 0.
    DATA(LV_AUDAT) = W_AUDAT-AUDAT.
    wa_final-AUART_1 = w_audat-auart.
    wa_final-BSTNK_D = w_audat-bstnk.
    wa_final-BSTDK_D = w_audat-bstdk.
    WA_FINAL-AUDAT = LV_AUDAT.
endif.
    read table it_mvke into data(wa_mvke_1) with
                       key vkorg = p_vkorg
                           matnr = WA_VBRP-matnr.
    if sy-subrc eq 0.
      move : wa_mvke_1-scmng to wa_final-LFMNG.
    endif.
*    endif.
    clear : W_AUDAT.
    clear : wa_ekko.
    read table it_ekko into wa_ekko with key
                       ebeln = wa_final-aubel.
    if sy-subrc eq 0.
     move : wa_ekko-bedat to wa_final-audat.
    endif.
   clear : wa_likp1.
   READ TABLE IT_LIKP1 INTO WA_LIKP1 WITH KEY VBELN = WA_VBRP-VGBEL.
   if sy-subrc eq 0.
      WA_FINAL-ERDAT_3 = WA_LIKP1-WADAT_IST.
      wa_final-VBELV_2 = wA_likp1-vbeln.
      CLEAR : WA_MKPF.
   endif.
  clear : wa_vbfa.
***Modified on 04.02.2025
*  read table it_vbfa into wa_vbfa with key
*                      vbelv = wa_vbrp-vgbel.
*  if sy-subrc eq 0.
*    move : wa_vbfa-vbeln  to wa_final-mblnr,
*           wa_vbfa-erdat  to wa_final-wadat_ist.
*  else.
*    read table i_mkpf into wa_mkpf with key le_vbeln = wa_vbrp-VGBEL.
*  if sy-subrc eq 0.
*  wa_final-mblnr = wa_mkpf-mblnr.
*  WA_FINAL-WADAT_IST = wa_mkpf-budat.
*  endif.
*  endif.
*   if wa_final-mblnr ne ''.
*      WA_FINAL-VBELV_2 = WA_VBRP-vgbel.
*   endif.
***Modified on 04.02.2025
  CLEAR : WA_BKPF, WA_BKPF1.
  clear : wa_vbrk.
*  if WA_FINAL-FKIMG = 0.
     clear : wa_mseg.
     read table it_mseg into wa_mseg with
                      key vbeln_im =  wa_vbrp-vgbel
                          vbelp_im =  wa_vbrp-vgpos.
     if sy-subrc eq 0.
     WA_FINAL-LMENG_1 = wa_mseg-erfmg. "menge.
     wa_final-mblnr   = wa_mseg-mblnr.
     wa_final-WADAT_IST   = wa_mseg-BUDAT_MKPF.
*    wa_final-VBELV_2     = wa_mseg-vbeln_im.
     else.
     WA_FINAL-LMENG_1 = wa_vbrp-fkimg.
     endif.
*  endif.
READ TABLE it_vbrk into wa_vbrk with key vbeln = wa_vbrp-vbeln.
  if sy-subrc eq 0.
   WA_FINAL-KUNaG     =  WA_VBRk-KUNAG.
   WA_FINAL-FKART     = wa_VBRK-FKART.
   WA_FINAL-FKTYP     = wa_VBRK-FKTYP.
   WA_FINAL-WAERK     = wa_VBRK-WAERK.
   WA_FINAL-VKORG     = wa_VBRK-VKORG.
   wa_final-xblnr     = wa_vbrk-xblnr.
   wa_final-ZTERM_1     = wa_vbrk-zterm.
   WA_FINAL-VTWEG     = wa_VBRK-VTWEG.
   WA_FINAL-Vkbur     = wa_VBRp-Vkbur.
    WA_FINAL-Vkgrp     = wa_VBRp-Vkgrp.
   WA_FINAL-INV_BILLING_DATE = wa_VBRK-FKDAT.
   WA_FINAL-FKDAT            = wa_VBRK-FKDAT.
   wa_final-werks            = wa_vbrp-werks.
   WA_FINAL-INCO1 = WA_VBRK-INCO1.

    READ TABLE IT_TINCT INTO DATA(WA_TINCT) WITH KEY INCO1 = WA_VBRK-INCO1 SPRAS = 'E'.
    IF SY-SUBRC = 0.
      WA_FINAL-INCO1_D = WA_TINCT-BEZEI.
    ENDIF.
     clear : WA_TINCT.
     clear : wa_t001w.
     READ TABLE IT_T001W INTO WA_T001W WITH KEY SPRAS = SY-LANGU WERKS = WA_FINAL-WERKS.
     if sy-subrc eq 0.
      LOCNAME = WA_T001W-NAME1.
      WA_FINAL-LOCNAME = LOCNAME.
      endif.
   clear : wa_tvkbt.
  READ TABLE IT_TVKBT INTO WA_TVKBT WITH KEY SPRAS = 'EN' VKBUR = WA_FINAL-VKBUR.
  if sy-subrc eq 0.
    WA_FINAL-VTEXT5 = WA_TVKBT-BEZEI.
  endif.
    clear : WA_TVGRT.
    READ TABLE IT_TVGRT INTO WA_TVGRT WITH KEY SPRAS = 'EN' VKGRP = WA_FINAL-VKGRP.
    if sy-subrc eq 0.
    WA_FINAL-VTEXT6 = WA_TVKBT-BEZEI.
    endif..
   clear : wa_tvtwt.
   READ TABLE IT_TVTWT INTO WA_TVTWT WITH KEY SPRAS = SY-LANGU
                                            VTWEG = WA_VBRK-VTWEG.
   if sy-subrc eq 0.
    WA_FINAL-VTEXT1 = WA_TVTWT-VTEXT.
   endif.
    clear : wa_tspat.
    READ TABLE IT_TSPAT INTO WA_TSPAT WITH KEY SPRAS = SY-LANGU
                                             SPART = WA_VBRK-SPART.
    if sy-subrc eq 0.
    WA_FINAL-VTEXT2 = WA_TSPAT-VTEXT.
    endif.
    WA_FINAL-spart  = WA_TSPAT-spart.
    clear : wa_tvfkt.
    READ TABLE IT_TVFKT INTO WA_TVFKT WITH KEY SPRAS = SY-LANGU
                                             FKART = WA_VBRK-FKART.
    if sy-subrc eq 0.
    WA_FINAL-VTEXT3 = WA_TVFKT-VTEXT.
    endif.
    clear : w_tvkot.
    READ TABLE IT_TVKOT INTO W_TVKOT WITH  KEY SPRAS = SY-LANGU
                                            VKORG = WA_VBRK-VKORG.
    if sy-subrc eq 0.
    WA_FINAL-VTEXT = W_TVKOT-VTEXT.
    endif.
*VBRK-KURRF
 wa_final-KURRF = wa_vbrk-kurrf.
 clear : lv_amt.
 read table IT_VBRP_N into wa_vbrp_n with key vbeln = wa_vbrp-vbeln
                                              matnr = wa_vbrp-matnr
                                              posnr = wa_vbrp-posnr.
 if sy-subrc eq 0.
   WA_FINAL-RATE1 =  wa_vbrp_n-netwr / wa_vbrp_n-fkimg .
   WA_FINAL-ITEM_SALE1 = WA_FINAL-RATE1 * wa_vbrp_n-fkimg.
   lv_amt =  WA_FINAL-RATE1 * wa_vbrp_n-fkimg .
   WA_FINAL-ITEM_SALE = lv_amt * wa_final-KURRF .
   clear : lv_amt.
   lv_amt =  wa_vbrp_n-netwr / wa_vbrp_n-fkimg  .
   WA_FINAL-RATE =  lv_amt * wa_final-KURRF .
*   WA_FINAL-ITEM_SALE = ( WA_FINAL-RATE1 * wa_vbrp-fkimg ) * wa_final-KURRF .
*   WA_FINAL-RATE =  ( wa_vbrp_n-netwr / wa_vbrp_n-fkimg  ) * wa_final-KURRF .
 endif.

   READ TABLE IT_IRN INTO DATA(WA_IRN) WITH KEY BUKRS = WA_VBRK-BUKRS
                                                DOCNO = WA_VBRK-VBELN
                                                DOC_YEAR = WA_VBRK-GJAHR
                                                DOC_TYPE = WA_VBRK-FKART.
   IF SY-SUBRC = 0.
     WA_FINAL-IRN = WA_IRN-IRN.
     WA_FINAL-ERDAT = WA_IRN-ERDAT.
      CLEAR : WA_IRN.
    ENDIF.
*IF WA_FINAL-LFMNG IS INITIAL.
*      clear : wa_vbrp_n.
*      read table it_vbrp_n into wa_vbrp_n with key vbeln = wa_vbrp-vbeln
*                                                   matnr = wa_vbrp-matnr.
*      CONCATENATE wa_vbrp_n-VBELN wa_vbrp_n-POSNR INTO DATA(V_NAME).
*      PERFORM READ_TEXT USING 'VBBP'
*                                 V_NAME
*                                 'Z020'
*                                 CHANGING WA_FINAL-LFMNG.
*    ENDIF.

 IM_INV_NUM = WA_FINAL-VBELN.
    CALL METHOD OBJ->GET_DATA_ADOBE
      EXPORTING
        IM_INV_NUM  = IM_INV_NUM
      IMPORTING
        E_EDOINEINV = E_EDOINEINV.

    WA_FINAL-IRN    = E_EDOINEINV-INV_REG_NUM.
    IF E_EDOINEINV-EWBNO IS NOT INITIAL.
      WA_FINAL-EWBNO  = E_EDOINEINV-EWBNO.
      WA_FINAL-EWBDT  = E_EDOINEINV-EWB_CREATE_DATE.
    ENDIF.

* IF WA_vbrk-ZTERM1 IS INITIAL.
      WA_FINAL-ZTERM  = WA_VBRK-ZTERM.
      READ TABLE IT_T052U INTO DATA(WA_T052U) WITH KEY
                                     SPRAS = 'E'
                                     ZTERM = WA_VBRK-ZTERM.
      IF SY-SUBRC EQ 0.
       "TEXT1.
      WA_FINAL-ZTERM_1 = WA_T052U-TEXT1.
      ENDIF.
      clear : WA_T052U.
*    ENDIF.
 clear : wa_kna1.
 READ TABLE IT_KNA1 INTO WA_KNA1 WITH KEY KUNNR = WA_VBRK-KUNAG.
    IF SY-SUBRC = 0.
      WA_FINAL-KUNNR = WA_KNA1-KUNNR.
      CONCATENATE WA_KNA1-NAME1 WA_KNA1-NAME2 WA_KNA1-NAME3 WA_KNA1-NAME4  INTO LV_CUST_NAME SEPARATED BY SPACE.
      WA_FINAL-NAME1 = LV_CUST_NAME.
      CLEAR: LV_CUST_NAME.
      WA_FINAL-REGIO = WA_KNA1-REGIO.
      WA_FINAL-STCD3 = WA_KNA1-STCD3.
      WA_FINAL-ORT01  = WA_KNA1-ORT01.
      WA_FINAL-PAN_NO = WA_KNA1-PAN_NO.
    endif.
      clear : WA_ZGST_REGION_MAP.
      READ TABLE IT_ZGST_REGION_MAP INTO WA_ZGST_REGION_MAP WITH KEY LAND1 = WA_KNA1-LAND1 STD_STATE_CODE = WA_KNA1-REGIO.
      IF SY-SUBRC = 0.
        WA_FINAL-ZGSTR = WA_ZGST_REGION_MAP-STD_STATE_CODE.
        WA_FINAL-BEZEI = WA_ZGST_REGION_MAP-BEZEI.
      ENDIF.
   read table IT_VBPA1 into data(wa_vbpa1) with key vbeln = WA_VBRP-vbeln
                                                   parvw = 'AG'. "'SP'.  "Sold
   if sy-subrc eq 0.
     wa_final-STP_CODE  = wa_vbpa1-kunnr.
     clear : wa_kna1.
    read table it_kna1 into wa_kna1 with key kunnr = wa_vbpa1-kunnr.
     if sy-subrc eq 0.
       wa_final-STP_name = wa_kna1-name1.
     endif.
   endif.
   clear : wa_vbpa1.
   read table IT_VBPA1 into data(wa_vbpa2) with key vbeln = WA_VBRP-vbeln
                                                   parvw = 'RE'. "'BP'.  "Bill to
   if sy-subrc eq 0.
     wa_final-BTP_Code  = wa_vbpa2-kunnr.
      clear : wa_kna1.
    read table it_kna1 into wa_kna1 with key kunnr = wa_vbpa2-kunnr.
     if sy-subrc eq 0.
       wa_final-BTP_name = wa_kna1-name1.
     endif.
   endif.
   read table IT_VBPA1 into data(wa_vbpa3) with key vbeln = WA_VBRP-vbeln
                                                   parvw = 'RG'. "PY'.   "Payer
   if sy-subrc eq 0.
    wa_final-KUNRG_ANA  = wa_vbpa3-kunnr.
     clear : wa_kna1.
    read table it_kna1 into wa_kna1 with key kunnr = wa_vbpa3-kunnr.
     if sy-subrc eq 0.
       wa_final-NAME1_1 = wa_kna1-name1.
     endif.
   endif.
   read table IT_VBPA1 into data(wa_vbpa5) with key vbeln = wa_vbrp-vbeln
                                                   parvw = 'ZA'. "PY'.   "Payer
   if sy-subrc eq 0.
    wa_final-KUNN2  = wa_vbpa3-kunnr.
     clear : wa_kna1.
    read table it_kna1 into wa_kna1 with key kunnr = wa_vbpa3-kunnr.
     if sy-subrc eq 0.
       wa_final-NAME1_D = wa_kna1-name1.
     endif.
   endif.

   read table IT_VBPA1 into data(wa_vbpa4) with key vbeln = WA_VBRP-vbeln
                                                   parvw = 'WE'. "SH'. "Ship to
    if sy-subrc eq 0.
    READ TABLE IT_KNVP INTO DATA(WA_KNVP) WITH KEY KUNNr = WA_VBRK-KUNAG
                                                   VKORG = WA_VBRK-VKORG
                                                   VTWEG = WA_VBRK-VTWEG
                                                   SPART = WA_VBRK-SPART
                                                   PARVW = 'VE'.
    DATA(LV_PERNR) = WA_KNVP-PERNR.  "Salesperson ID   Patner function  it will change

    IF SY-SUBRC = 0.
      READ TABLE IT_LFB1 INTO DATA(LV_LIFNR) WITH KEY PERNR = LV_PERNR.
      WA_FINAL-LIFNR  =  LV_LIFNR-LIFNR.  "Salesperson ID
      READ TABLE IT_PA0001 INTO DATA(WA_PA0001) WITH KEY PERNR = LV_PERNR.
      WA_FINAL-ENAME  = WA_PA0001-ENAME.
      wa_final-lifnr  = lv_pernr.
    ENDIF.
   endif.
    READ TABLE IT_KNVP INTO DATA(WA_KNVP2) WITH KEY KUNNr = WA_VBRK-KUNAG
                                                    VKORG = WA_VBRK-VKORG
                                                    VTWEG = WA_VBRK-VTWEG
                                                       SPART = WA_VBRK-SPART
                                                       PARVW = 'ZA'.

    IF SY-SUBRC = 0.
      WA_FINAL-KUNN2 =  WA_KNVP2-KUNN2.  "Customer ZA ID
    ENDIF.
   clear : wa_knmt.
   read table i_knmt into wa_knmt with key
                    kunnr = wa_vbrk-kunag
                    matnr = wa_vbrp-matnr.
  if sy-subrc eq 0.
     WA_FINAL-POSTX_1 = wa_knmt-postx.
  endif.

endif.
*****
clear : wa_vbrk1,wa_vbrk2.
*Read table it_vbrk into wa_vbrk1 with key sfakn = wa_vbrp-vbeln .
 read table it_vbrk_r into wa_vbrk_r with key sfakn = wa_vbrp-vbeln.
if sy-subrc eq 0.
  move : wa_vbrk_r-vbeln to wa_final-VBELV_1,
         wa_vbrk_r-fkdat to wa_final-erdat_1.
*  if sy-subrc eq 0.
*  read table it_vbrk into wa_vbrk2 with key
*                      vbeln = wa_final-VBELV_1.
*  if sy-subrc eq 0.
*  move : wa_vbrk2-fkdat to wa_final-ERDAT_1.
*  endif.
*  endif.
endif.
*****
clear : wa_mch1.
READ TABLE IT_MCH1 INTO WA_MCH1 WITH KEY CHARG = WA_VBRP-CHARG
                                         MATNR = WA_VBRP-MATNR.
    IF SY-SUBRC = 0.
      WA_FINAL-VFDAT_1 = WA_MCH1-VFDAT.   "3. Material Batch Expiry Date
      WA_FINAL-HSDAT_1 = WA_MCH1-HSDAT.   "2. Material Batch Mfg Date
    ENDIF.
    READ TABLE IT_ZTRANSP_D INTO DATA(WA_ZTRANSP_D) WITH KEY ZBILL_NO = WA_VBRp-VBELN.
    if sy-subrc eq 0.
    wa_final-TRNS_NAME1 = WA_ZTRANSP_D-ZTRANS_N.
    wa_final-LRNO       = WA_ZTRANSP_D-zlr_no.
    wa_final-lrdate     = WA_ZTRANSP_D-zlr_date.
    wa_final-VEH_NO     = WA_ZTRANSP_D-zvehical.
    endif.

    IF WA_VBRK-WAERK IS NOT INITIAL. "#ADDED
      READ TABLE IT_TCURT INTO DATA(WA_TCURT) WITH KEY WAERS = WA_VBRK-WAERK.
      IF SY-SUBRC = 0.
     WA_FINAL-LTEXT_1 =  WA_TCURT-LTEXT.
     wa_final-WAERK   =  wa_vbrk-waerk.                      ""Currency Description
   ENDIF.
   endif.
       READ TABLE IT_KNVP INTO DATA(LV_LIFNR1) WITH KEY  KUNNR = WA_VBRK-KUNAG
                                                      VKORG = WA_VBRK-VKORG
                                                      VTWEG = WA_VBRK-VTWEG
                                                      SPART  = WA_VBRK-SPART
                                                      PARVW   = 'ZT'.
    IF SY-SUBRC = 0.
      WA_FINAL-LIFNR_1 = LV_LIFNR1-LIFNR.    "Transporter SAP ID
    ENDIF.
   clear : lv_lifnr1.
clear : wa_lips.

APPEND WA_FINAL TO IT_FINAL.
   CLEAR : WA_FINAL.
   clear : wa_vbrp,wa_vbrk.
  ENDLOOP.
delete it_final where charg_1   = '' and
                      LMENG_1   = 0.
delete it_final where vbeln = ''.
sort it_final by vbeln .
ENDFORM.

*&---------------------------------------------------------------------*
*& Form FIELDCAT1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FIELDCAT1 .

  WA_FIELDCAT-FIELDNAME  = 'VBELN'.
  WA_FIELDCAT-SELTEXT_M  = TEXT-000."'Billing Doc. No.'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'XBLNR'.
  WA_FIELDCAT-SELTEXT_L  = TEXT-051."'Sales Organization'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'VKORG'.
  WA_FIELDCAT-SELTEXT_L  = TEXT-001."'Sales Organization'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'VTEXT'.
  WA_FIELDCAT-SELTEXT_L  = TEXT-002."'Sales Org. Description'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.


  WA_FIELDCAT-FIELDNAME  = 'VTWEG'.
  WA_FIELDCAT-SELTEXT_M  = TEXT-003." 'Distribution Channel'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.


  WA_FIELDCAT-FIELDNAME  = 'VTEXT1'.
  WA_FIELDCAT-SELTEXT_L  = TEXT-004."'Dist. Channel Desc.'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.


  WA_FIELDCAT-FIELDNAME  = 'SPART'.
  WA_FIELDCAT-SELTEXT_M  = TEXT-005."'Division'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.


  WA_FIELDCAT-FIELDNAME  = 'VTEXT2'.
  WA_FIELDCAT-SELTEXT_M  = TEXT-006."'Division Desc.'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR wa_fieldcat.

  WA_FIELDCAT-FIELDNAME  = 'WERKS'.
  WA_FIELDCAT-SELTEXT_M  = TEXT-007."'Location'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'LOCNAME'.
  WA_FIELDCAT-SELTEXT_M  = TEXT-008."'Location Description'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'FKDAT'.
  WA_FIELDCAT-SELTEXT_M  = TEXT-010."'Billing Date'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'INV_BILLING_DATE'.
  WA_FIELDCAT-SELTEXT_M  = 'Invoice Posting Date'. "TEXT-121."'Billing Date'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'FKART'.
  WA_FIELDCAT-SELTEXT_M  = TEXT-011."'Billing Type'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.


  WA_FIELDCAT-FIELDNAME  = 'AUBEL'.
  WA_FIELDCAT-SELTEXT_M  = TEXT-093."'Sales Order No'.
  WA_FIELDCAT-NO_ZERO = 'X' .
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'AUDAT'.
  WA_FIELDCAT-SELTEXT_M  = TEXT-094."'Sales Order Date'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'KUNAG'.
  WA_FIELDCAT-SELTEXT_M  = TEXT-015."'Customer Code'. C
  WA_FIELDCAT-no_zero = 'X'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.


  WA_FIELDCAT-FIELDNAME  = 'NAME1'.
  WA_FIELDCAT-SELTEXT_M  = TEXT-016."'Customer Name'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'INCO1'.
  WA_FIELDCAT-SELTEXT_M  = 'Inco term ID'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'INCO1_D'.
  WA_FIELDCAT-SELTEXT_M  = 'IncoTerm Description'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'REGIO'.
  WA_FIELDCAT-SELTEXT_M  = TEXT-017."'Customer State'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'BEZEI'.
  WA_FIELDCAT-SELTEXT_M  = TEXT-019."'Customer State Name'.C
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

********************************************************
  WA_FIELDCAT-FIELDNAME  = 'LIFNR'.
  WA_FIELDCAT-SELTEXT_L  = 'Salesperson ID'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'KUNRG_ANA'.
  WA_FIELDCAT-SELTEXT_L  = 'Payer ID'.
  WA_FIELDCAT-NO_ZERO = 'X' .
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'NAME1_1'.
  WA_FIELDCAT-SELTEXT_L  = 'Payer Description'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'KUNN2'.
  WA_FIELDCAT-SELTEXT_L  = 'Customer ZA ID'.
  WA_FIELDCAT-NO_ZERO = 'X' .
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'NAME1_D'.
  WA_FIELDCAT-SELTEXT_L  = 'Customer ZA Description'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'ORT01'.
  WA_FIELDCAT-SELTEXT_L  = 'Customer City'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'VBELV_1'.
  WA_FIELDCAT-SELTEXT_L  = 'Invoice Cancellation Number'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'ERDAT_1'.
  WA_FIELDCAT-SELTEXT_L  = 'Invoice Cancellation Date'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'LIFNR_1'.
  WA_FIELDCAT-SELTEXT_L  = 'Transporter SAP ID'.
  WA_FIELDCAT-NO_ZERO = 'X' .
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'MBLNR'.
  WA_FIELDCAT-SELTEXT_L  = 'PGI Number'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'WADAT_IST'.
  WA_FIELDCAT-SELTEXT_L  = 'PGI Date'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'VBELV_2'.
  WA_FIELDCAT-SELTEXT_L  = 'OBD Number'.
  WA_FIELDCAT-NO_ZERO = 'X' .
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'ERDAT_3'.
  WA_FIELDCAT-SELTEXT_L  = 'OBD Date'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'ARKTX_1'.
  WA_FIELDCAT-SELTEXT_L  = 'Material Description'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'POSTX_1'.
  WA_FIELDCAT-SELTEXT_L  = 'Material Customer Description'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'CHARG_1'.
  WA_FIELDCAT-SELTEXT_L  = 'Batch Number'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'ZTERM'.
  WA_FIELDCAT-SELTEXT_L  = 'Payment Term ID'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'ZTERM_1'.
  WA_FIELDCAT-SELTEXT_M  = TEXT-116."'Payment Terms'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.


  WA_FIELDCAT-FIELDNAME  = 'LMENG_1'.
  WA_FIELDCAT-SELTEXT_L  = 'Material Batch Quantity(Sales UoM)'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.


  WA_FIELDCAT-FIELDNAME  = 'VFDAT_1'.
  WA_FIELDCAT-SELTEXT_L  = 'Material Batch Expiry Date'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'HSDAT_1'.
  WA_FIELDCAT-SELTEXT_L  = 'Material Batch Mfg Date'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'AUART_1'.
  WA_FIELDCAT-SELTEXT_L  = 'Sales Order Document Type'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'LTEXT_1'.
  WA_FIELDCAT-SELTEXT_L  = 'Currency Description'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.
**************************************************************

  WA_FIELDCAT-FIELDNAME  = 'STCD3'.
  WA_FIELDCAT-SELTEXT_L = TEXT-020."'Customer GSTIN No.'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'BSTNK_D'.
  WA_FIELDCAT-SELTEXT_M  = TEXT-107."'Buyer's Order No'.C
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'BSTDK_D'."'BSTDK'.
  WA_FIELDCAT-SELTEXT_M  = TEXT-108."'Buyer's Order Date'. C
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.


  WA_FIELDCAT-FIELDNAME  = 'STP_CODE'.
  WA_FIELDCAT-SELTEXT_M  = TEXT-088."'Ship-to-Party Code'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'STP_NAME'.
  WA_FIELDCAT-SELTEXT_M  = TEXT-089."'Ship-to-Party Name'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'BTP_CODE'.
  WA_FIELDCAT-SELTEXT_M  = TEXT-090."'Bill-to-Party Code'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'BTP_NAME'.
  WA_FIELDCAT-SELTEXT_M  = TEXT-091."'Bill-to-Party Name'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'TRNS_NAME1'.
  WA_FIELDCAT-SELTEXT_M  = TEXT-092."'Transporter Name'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.


  WA_FIELDCAT-FIELDNAME  = 'VEH_NO'.
  WA_FIELDCAT-SELTEXT_M  = 'Vehicle Number'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'LRNO'.
  WA_FIELDCAT-SELTEXT_M  = TEXT-026."'LR Number'. C
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.


  WA_FIELDCAT-FIELDNAME  = 'LRDATE'.
  WA_FIELDCAT-SELTEXT_M  = TEXT-027."'LR Date'.C
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'MATNR'.
  WA_FIELDCAT-SELTEXT_M  = TEXT-028."'Product Code'.
  WA_FIELDCAT-REF_FIELDNAME = 'MATNR'.
  WA_FIELDCAT-REF_TABNAME = 'MARA'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'ENAME'.
  WA_FIELDCAT-SELTEXT_L = 'Salesperson Name'.
  WA_FIELDCAT-TABNAME = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'VRKME'.
  WA_FIELDCAT-SELTEXT_M  = 'Product Sale UOM'."'Billed Qty'.
*  WA_FIELDCAT-DECIMALS_OUT = '2'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'MEINS'.
  WA_FIELDCAT-SELTEXT_L  = 'Product Base UOM'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'ITEM_SALE1'.
  WA_FIELDCAT-SELTEXT_L  = 'Product Sales Value in TXN Currency'.
  WA_FIELDCAT-DECIMALS_OUT = '2'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'ITEM_SALE'.
  WA_FIELDCAT-SELTEXT_L  = 'Product Sales Value In Base Currency'.
  WA_FIELDCAT-DECIMALS_OUT = '2'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'WAERK'.
  WA_FIELDCAT-SELTEXT_M  = TEXT-098."'Document Currency'. C
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.


  WA_FIELDCAT-FIELDNAME  = 'RATE1'.
  WA_FIELDCAT-SELTEXT_L  = 'Product Sales Rate TXN currency'.
  WA_FIELDCAT-DECIMALS_OUT = '2'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'RATE'.
  WA_FIELDCAT-SELTEXT_L  = 'Product Sales Rate Base currency'.
  WA_FIELDCAT-DECIMALS_OUT = '2'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'KURRF'.
  WA_FIELDCAT-SELTEXT_L  = 'Currency Exchange Rate'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'EWBNO'.
  WA_FIELDCAT-SELTEXT_M  = 'E-way Bill Number'.  "C
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'EWBDT'.
  WA_FIELDCAT-SELTEXT_M  = 'E-way Bill Date'.  "C
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.


  DATA: LV_TCODE TYPE SYST_TCODE.
  DATA URI TYPE TIHTTPNVP.
  IMPORT URI = URI  FROM MEMORY ID 'ZREPORTGET'.
  IF SY-SUBRC EQ 0.
    LOOP AT URI ASSIGNING FIELD-SYMBOL(<R>) WHERE NAME CS 'filter'.
      TRANSLATE <R>-VALUE TO UPPER CASE.
      REPLACE ALL OCCURRENCES OF '%27' IN <R>-VALUE WITH ''.
      REPLACE ALL OCCURRENCES OF '%20' IN <R>-VALUE WITH ''.
      REPLACE ALL OCCURRENCES OF '''' IN <R>-VALUE WITH ''.
      REPLACE ALL OCCURRENCES OF '+' IN <R>-VALUE WITH ''.
      SPLIT <R>-VALUE AT 'AND' INTO DATA(TCODE) DATA(VAR).
      SPLIT TCODE AT 'EQ' INTO DATA(TCODE1) DATA(TCODE2).
      SPLIT VAR AT 'EQ' INTO DATA(VAR2) DATA(VAL2).
      EXIT.
    ENDLOOP.
    LV_TCODE =  TCODE2.
  ELSE.
    LV_TCODE = SY-TCODE.
  ENDIF.

  IF LV_TCODE  = 'ZFI005'.
    WA_FIELDCAT-FIELDNAME  = 'PCIP'.
    WA_FIELDCAT-SELTEXT_L  = 'Actual Cost Rate'."'Cost Price Rate'.
    WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
    APPEND WA_FIELDCAT TO IT_FIELDCAT.
    CLEAR WA_FIELDCAT.

    WA_FIELDCAT-FIELDNAME  = 'PCIP_V'.
    WA_FIELDCAT-SELTEXT_L  = 'Actual Cost Value'."'Cost Price Value'.
    WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
    APPEND WA_FIELDCAT TO IT_FIELDCAT.
    CLEAR WA_FIELDCAT.

***************Addition Of Code By MayurB 12/07/23 *************************
    WA_FIELDCAT-FIELDNAME  = 'CITY'.
    WA_FIELDCAT-SELTEXT_L  = 'Destination Name'.    "City name or TextName'.
    WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
    APPEND WA_FIELDCAT TO IT_FIELDCAT.
    CLEAR WA_FIELDCAT.

    WA_FIELDCAT-FIELDNAME  = 'INDUSTRY_CD'.
    WA_FIELDCAT-SELTEXT_L  = 'Industry Code'.    "INDUSTRY CODE'.
    WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
    APPEND WA_FIELDCAT TO IT_FIELDCAT.
    CLEAR WA_FIELDCAT.

    WA_FIELDCAT-FIELDNAME  = 'INDUSTRY_DSCR'.
    WA_FIELDCAT-SELTEXT_L  = 'Industry Description'.    "INDUSTRY CODE'.
    WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
    APPEND WA_FIELDCAT TO IT_FIELDCAT.
    CLEAR WA_FIELDCAT.
***************End of Addition *************************************

  ENDIF.


  WA_FIELDCAT-FIELDNAME  = 'LFMNG'."'PACK_SIZE'  C
  WA_FIELDCAT-SELTEXT_L  = 'Material pack size'.
  WA_FIELDCAT-TABNAME    = 'IT_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

ENDFORM.

FORM ADD_DAYS USING LV_TIME.
  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
    EXPORTING
      DATE      = WA_VBRK-FKDAT
      DAYS      = LV_TIME
      MONTHS    = 00
*     SIGNUM    = '+'
      YEARS     = 00
    IMPORTING
      CALC_DATE = WA_FINAL-DUEDT.

ENDFORM.

FORM READ_TEXT  USING TDOBJECT TDNAME TDID CHANGING FIELD1.
  SELECT SINGLE *
                FROM STXH
                INTO @DATA(WA_STXH)
                WHERE TDOBJECT = @TDOBJECT
                  AND TDNAME   = @TDNAME
  AND TDID     = @TDID.
  IF SY-SUBRC = 0.
    DATA: IT_THEAD TYPE TABLE OF TLINE.
    DATA:LINE_BR TYPE C VALUE CL_ABAP_CHAR_UTILITIES=>CR_LF.
    CLEAR:IT_THEAD.


    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        ID                      = WA_STXH-TDID
        LANGUAGE                = 'E'
        NAME                    = WA_STXH-TDNAME
        OBJECT                  = WA_STXH-TDOBJECT
      TABLES
        LINES                   = IT_THEAD
      EXCEPTIONS
        ID                      = 1
        LANGUAGE                = 2
        NAME                    = 3
        NOT_FOUND               = 4
        OBJECT                  = 5
        REFERENCE_CHECK         = 6
        WRONG_ACCESS_TO_ARCHIVE = 7
        OTHERS                  = 8.



    LOOP AT IT_THEAD INTO DATA(WA_THEAD).
      REPLACE ALL OCCURRENCES OF '<(>' IN WA_THEAD-TDLINE WITH ''.
      REPLACE ALL OCCURRENCES OF '<)>' IN WA_THEAD-TDLINE WITH ''.
      IF SY-TABIX = 1.
        FIELD1 = WA_THEAD-TDLINE.
      ELSE.
        CONCATENATE FIELD1 WA_THEAD-TDLINE INTO FIELD1 SEPARATED BY ' '."LINE_BR.
      ENDIF.
      CLEAR:WA_THEAD.
    ENDLOOP.

  ENDIF.
  CLEAR:IT_THEAD,IT_THEAD[].

ENDFORM.

FORM INITIALIZE_VARIANT .
  G_SAVE = 'A'.
  CLEAR G_VARIANT.
  G_VARIANT-REPORT = REPNAME.
  GX_VARIANT = G_VARIANT.
  CALL FUNCTION 'REUSE_ALV_VARIANT_DEFAULT_GET'
    EXPORTING
      I_SAVE     = G_SAVE
    CHANGING
      CS_VARIANT = GX_VARIANT
    EXCEPTIONS
      NOT_FOUND  = 2.
  IF SY-SUBRC = 0.
    P_VARI = GX_VARIANT-VARIANT.
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
FORM F4_FOR_VARIANT .

  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      IS_VARIANT = G_VARIANT
      I_SAVE     = G_SAVE
    IMPORTING
      E_EXIT     = G_EXIT
      ES_VARIANT = GX_VARIANT
    EXCEPTIONS
      NOT_FOUND  = 2.
  IF SY-SUBRC = 2.
    MESSAGE ID SY-MSGID TYPE 'S'      NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ELSE.
    IF G_EXIT = SPACE.
      P_VARI = GX_VARIANT-VARIANT.
    ENDIF.
  ENDIF.
ENDFORM.                    " f4_for_variant

FORM PAI_OF_SELECTION_SCREEN .
  IF NOT P_VARI IS INITIAL.
    MOVE G_VARIANT TO GX_VARIANT.
    MOVE P_VARI TO GX_VARIANT-VARIANT.
    CALL FUNCTION 'REUSE_ALV_VARIANT_EXISTENCE'
      EXPORTING
        I_SAVE     = G_SAVE
      CHANGING
        CS_VARIANT = GX_VARIANT.
    G_VARIANT = GX_VARIANT.
  ELSE.
    PERFORM INITIALIZE_VARIANT.
  ENDIF.
ENDFORM.


FORM BDC_DYNPRO USING PROGRAM DYNPRO.
  CLEAR BDCDATA.
  BDCDATA-PROGRAM  = PROGRAM.
  BDCDATA-DYNPRO   = DYNPRO.
  BDCDATA-DYNBEGIN = 'X'.
  APPEND BDCDATA.
ENDFORM.                    "BDC_DYNPRO

FORM BDC_FIELD USING FNAM FVAL.
  CLEAR BDCDATA.
  BDCDATA-FNAM = FNAM.
  BDCDATA-FVAL = FVAL.
  APPEND BDCDATA.

ENDFORM.
