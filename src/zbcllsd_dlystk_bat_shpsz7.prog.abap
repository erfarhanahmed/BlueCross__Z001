*&---------------------------------------------------------------------*
*& Report ZBCLLSD_DLYSTK_BAT_SHPSZ7
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbcllsd_dlystk_bat_shpsz7.

* developed by anjali for BSR nasik and Goa
* Original prog is ZDBS - changes are made by Jyotsna - 26.5.2009
** added purchase price for SPR & ADDED - jYOTSNA11.9.24
TABLES : mcha,
         mchb,
         marm,
         a602,
         konp,
         makt,
         t001w,
         mseg,
         qals,
         a501,
         a611,
         mara,
         afpo,
         aufk,
         afru,
         a609,
         adrc,
         zshipper,
         ekpo.

TYPE-POOLS:  slis.

DATA: g_repid     LIKE sy-repid,
      fieldcat    TYPE slis_t_fieldcat_alv,
      wa_fieldcat LIKE LINE OF fieldcat,
      sort        TYPE slis_t_sortinfo_alv,
      wa_sort     LIKE LINE OF sort,
      layout      TYPE slis_layout_alv.
DATA: it_mseg TYPE TABLE OF mseg,
      wa_mseg TYPE mseg.

TYPES : BEGIN OF itas1,
          matnr       LIKE mchb-matnr,
          maktx       LIKE makt-maktx,
          lgort       LIKE mchb-lgort,
          charg       LIKE mchb-charg,
          vfdat       LIKE mcha-vfdat,
          hsdat       LIKE mcha-hsdat,
          stock       TYPE p,
          stock1      TYPE p,
          status(2)   TYPE c,
          ablad       LIKE mseg-ablad,
          w_rem(15)   TYPE c,
          w_kbetr1(7) TYPE c,
          zex2        TYPE p DECIMALS 2,
          w_kbetr2    LIKE konp-kbetr,
          jmod        TYPE konp-kbetr,
          brgew       TYPE mara-brgew,
          ntgew       TYPE mara-ntgew,
          iedd        TYPE afru-iedd,
          text1(50)   TYPE c,
          menge       TYPE mseg-menge,
          text2(1000) TYPE c,
          zsam        TYPE konv-kbetr,
          zsmp        TYPE konv-kbetr,
        END OF itas1.

TYPES : BEGIN OF itab2,
          matnr      LIKE mchb-matnr,
          maktx      LIKE makt-maktx,
          lgort      LIKE mchb-lgort,
          charg      LIKE mchb-charg,
          vfdat      LIKE mcha-vfdat,
          hsdat      LIKE mcha-hsdat,
          stock(15)  TYPE c,
          stock1(15) TYPE c,
          w_rem(15)  TYPE c,
          mrpsam(10) TYPE c,
*          W_KBETR1(7) TYPE C,
*          ZEX2        TYPE P DECIMALS 2,
*          W_KBETR2    LIKE KONP-KBETR,
*          JMOD        TYPE KONP-KBETR,
*          BRGEW       TYPE MARA-BRGEW,
*          NTGEW       TYPE MARA-NTGEW,
*          IEDD        TYPE AFRU-IEDD,
*          TEXT1(50)   TYPE C,
*          MENGE       TYPE MSEG-MENGE,
*          TEXT2(1000) TYPE C,
*          ZSAM        TYPE KONV-KBETR,
        END OF itab2.

DATA: ablad(500) TYPE c.

TYPES: BEGIN OF smp1,
         matnr TYPE mara-matnr,
         charg TYPE mchb-charg,
       END OF smp1.
DATA : it_tas1 TYPE TABLE OF itas1,
       wa_tas1 TYPE itas1,
       it_tab2 TYPE TABLE OF itab2,
       wa_tab2 TYPE itab2,
       it_smp1 TYPE TABLE OF smp1,
       wa_smp1 TYPE smp1.



DATA : BEGIN OF itab OCCURS 0,
         matnr     LIKE mchb-matnr,
         maktx     LIKE makt-maktx,
         lgort     LIKE mchb-lgort,
         charg     LIKE mchb-charg,
         vfdat     LIKE mcha-vfdat,
         hsdat     LIKE mcha-hsdat,
         stock     TYPE p,
         stock1    TYPE p,
         status(2) TYPE c,
         ablad     LIKE mseg-ablad.

DATA : END OF itab.
DATA : BEGIN OF w-mchb OCCURS 0.
         INCLUDE STRUCTURE  mchb.
DATA : END OF w-mchb.

DATA : w_vfdat LIKE mcha-vfdat.
DATA : w_hsdat LIKE mcha-hsdat.
DATA : w_maktx LIKE makt-maktx.
DATA : w_name3 LIKE t001w-name1.
DATA : w_totqty LIKE mchb-clabs.
DATA : w_totqty1 LIKE mchb-clabs.
DATA : w_umrez LIKE marm-umrez.
DATA : w_umrez1(6) TYPE c.
DATA : w_rem(15) TYPE c.
DATA : w_remk(15) TYPE c.
DATA : w_fqty(6)  TYPE c.
DATA : w_sqty(6) TYPE c .
DATA : w_fqty1(6) TYPE c.
DATA : w_sqty1(6) TYPE c.
DATA : w_knumh LIKE a602-knumh.
DATA : w_kbetr LIKE konp-kbetr.
DATA : w_knumh1 LIKE a602-knumh.
DATA : w_kbetr2 LIKE konp-kbetr.
DATA : w_kbetr1(7) TYPE c,
       jmod        TYPE konp-kbetr,
       zex2        TYPE p DECIMALS 2.
DATA: mtart TYPE mara-mtart.
DATA:  rate TYPE ekpo-netpr.

DATA : a1 TYPE p DECIMALS 2,
       a2 TYPE p DECIMALS 2,
       a3 TYPE p DECIMALS 2.

DATA : matnr TYPE mara-matnr.

DATA : v_fm TYPE rs38l_fnam.
DATA : format(100) TYPE c.

TYPES: BEGIN OF typ_t001w,
         werks TYPE werks_d,
         name1 TYPE name1,
       END OF typ_t001w.

DATA : itab_t001w TYPE TABLE OF typ_t001w,
       wa_t001w   TYPE typ_t001w.
DATA : msg TYPE string.
DATA: kunnr     TYPE t001w-kunnr,
      addr(100) TYPE c.

SELECTION-SCREEN BEGIN OF BLOCK merkmale WITH FRAME TITLE TEXT-001.
  PARAMETERS : p_plant LIKE mchb-werks,
               p_lfrom LIKE mchb-lgort,
               p_lto   LIKE mchb-lgort.
SELECTION-SCREEN END OF BLOCK merkmale.
SELECTION-SCREEN BEGIN OF BLOCK merkmale1 WITH FRAME TITLE TEXT-001.
  PARAMETERS : r1 RADIOBUTTON GROUP r1,
               r2 RADIOBUTTON GROUP r1,
               r3 RADIOBUTTON GROUP r1,
               r4 RADIOBUTTON GROUP r1.
SELECTION-SCREEN END OF BLOCK merkmale1.

INITIALIZATION.
  g_repid = sy-repid.

AT SELECTION-SCREEN.
  PERFORM authorization.

START-OF-SELECTION.

  IF r4 EQ 'X'.
    CALL TRANSACTION 'ZSHIPPER'.
  ELSE.

    SELECT SINGLE * FROM t001w WHERE werks EQ p_plant.
    IF sy-subrc EQ 0.
      IF p_plant EQ '1000'.
        kunnr = t001w-ort01.
      ELSE.
        kunnr = t001w-kunnr.
      ENDIF.
      CLEAR : addr.
      SELECT SINGLE * FROM adrc WHERE addrnumber EQ t001w-adrnr.
      IF sy-subrc EQ 0.
        addr = adrc-name2 .
*        CONCATENATE adrc-name2 adrc-name3 INTO addr.
      ENDIF.
    ENDIF.

    SELECT * FROM mchb INTO TABLE w-mchb WHERE werks = p_plant AND ( lgort BETWEEN p_lfrom AND p_lto ).

    LOOP AT w-mchb.
      w_totqty = w-mchb-clabs + w-mchb-cumlm + w-mchb-cinsm + w-mchb-ceinm + w-mchb-cspem + w-mchb-cretm.
      w_totqty1 = w-mchb-clabs.
      IF w_totqty GT 0.
*        SELECT SINGLE  VFDAT HSDAT  FROM MCHA INTO (W_VFDAT,W_HSDAT) WHERE MATNR = W-MCHB-MATNR AND WERKS = W-MCHB-WERKS AND CHARG = W-MCHB-CHARG.
        SELECT SINGLE  vfdat hsdat  FROM mch1 INTO (w_vfdat,w_hsdat) WHERE matnr = w-mchb-matnr  AND charg = w-mchb-charg ." AND werks = w-mchb-werks .
        SELECT SINGLE maktx FROM makt INTO w_maktx WHERE matnr = w-mchb-matnr
                                                     AND spras = sy-langu.
        PERFORM itab-upd.
      ENDIF.
    ENDLOOP.



    PERFORM itab-prt.
  ENDIF.
*---------------------------------------------------------------------*
*       FORM itab-upd                                                 *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM itab-upd.

  w_totqty = w-mchb-clabs + w-mchb-cumlm + w-mchb-cinsm + w-mchb-ceinm +
 w-mchb-cspem + w-mchb-cretm.
  w_totqty1 = w-mchb-clabs.
  CLEAR itab.
  itab-matnr = w-mchb-matnr.
  itab-maktx = w_maktx.
  itab-lgort = w-mchb-lgort.
  itab-charg = w-mchb-charg.
  itab-vfdat = w_vfdat.
  itab-hsdat = w_hsdat.
  itab-stock = w_totqty.
  itab-stock1 = w_totqty1.
  IF itab-stock = itab-stock1.
    itab-status = 'R'.
*       else.
*         itab-status = 'B'.
  ENDIF.

  APPEND itab.
ENDFORM.                    "itab-upd

TOP-OF-PAGE.
*  FORMAT COLOR 4.

  SELECT SINGLE name1 FROM t001w INTO w_name3 WHERE werks = p_plant.

  WRITE : /1 'Daily Stock Statement (Batchwise)  as on ' ,
          45 sy-datum,
          60 'for ',
          65 w_name3.
  ULINE.
  WRITE :
*           141 'ZEX2',
*           149 'ZEX2',
*           157 'ZEX2',
*           165 'NEW',
          85 '  Total',
          100 'Unrestricted',
*          148 'ZCIN',
          175 'Gross',
          186 'Net',
          196 'Batch'.


  WRITE : /1  'Matnr.no.',
           13 'Description',
           39 'Stor',
           46 'Batch',
           59 'Exp. date',
           71 'Mfg. Date',
           85 '  Stock',
           100 'Stock',
           110 'Shipper Brk.up',
           137 'MRP',
*           142 '10',
*           150 '20',
*           158 '80',
*           141 'ZEX2',
*           141 'ZSAM',
           149 'ZSAM',
           159 'ZSMP',
           165 'ZCIN',
           175 'Weight',
           186 'Weight',
           198 'Final conf',
           208 'CONTROL SAMPLE STATUS'.

  ULINE.

*   WRITE : /1(8) WA_TAS1-MATNR LEFT-JUSTIFIED,11(25) WA_TAS1-MAKTX LEFT-JUSTIFIED,39(4) WA_TAS1-LGORT,46(10) WA_TAS1-CHARG,
*    59(10) WA_TAS1-VFDAT,71(10) WA_TAS1-HSDAT,84(10) WA_TAS1-STOCK,97(10) WA_TAS1-STOCK1,110(25) WA_TAS1-W_REM,
*    137(7) WA_TAS1-W_KBETR1,147(7) WA_TAS1-ZSAM,157(7) WA_TAS1-ZSMP,166(7) WA_TAS1-W_KBETR2,175 WA_TAS1-BRGEW LEFT-JUSTIFIED,186 WA_TAS1-NTGEW LEFT-JUSTIFIED,
*    196(10) WA_TAS1-IEDD LEFT-JUSTIFIED ,208(15) WA_TAS1-TEXT1 LEFT-JUSTIFIED.
**      137(7) WA_TAS1-W_KBETR1,147(7) WA_TAS1-ZSAM,157(7) WA_TAS1-ZSMP,WA_TAS1-W_KBETR2,166 WA_TAS1-BRGEW LEFT-JUSTIFIED,176 WA_TAS1-NTGEW LEFT-JUSTIFIED,
**    186(10) WA_TAS1-IEDD LEFT-JUSTIFIED ,198(15) WA_TAS1-TEXT1 LEFT-JUSTIFIED.
*    IF WA_TAS1-MENGE NE 0.
*      WRITE : 225 WA_TAS1-MENGE LEFT-JUSTIFIED.
*    ELSE.
*      WRITE : 225 WA_TAS1-TEXT2 LEFT-JUSTIFIED.

*---------------------------------------------------------------------*
*       FORM ITAB-PRT                                                 *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM itab-prt.
  SORT itab BY matnr charg.


  LOOP AT itab.

    CLEAR : w_kbetr,w_umrez,w_umrez1,w_totqty,w_rem,w_sqty,w_fqty,w_fqty1,w_sqty,w_sqty1,zex2,jmod,ablad.
    w_umrez  = 0.
    w_rem = '  '.
    w_kbetr = 0.
    w_knumh = '  '.
    SELECT SINGLE umrez FROM marm INTO w_umrez WHERE matnr = itab-matnr AND meinh = 'SPR'.

    SELECT SINGLE * FROM zshipper WHERE matnr EQ itab-matnr.  "30.5.22
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM mcha WHERE matnr EQ itab-matnr AND charg EQ itab-charg AND ersda LE zshipper-to_dt.
      IF sy-subrc EQ 0.
        w_umrez = zshipper-umrez.
      ENDIF.
    ENDIF.

*****************mrp logic for Nepal**********************************************************
    CLEAR : matnr,w_kbetr1.

    IF itab-matnr+10(3) EQ '425'.
      matnr = itab-matnr.
      IF matnr+10(3) EQ '425'.
*        matnr+10(3) = '000'.  "DEACTIVATED ON EMAIL FROM NEKAR DATED 12.6.22 ---JYOTSNA
      ENDIF.

**********************

*******************

      SELECT SINGLE * FROM a602 WHERE kschl = 'Z001' AND vkorg EQ '2000' AND matnr = itab-matnr AND charg = itab-charg AND datbi GT sy-datum.
      IF sy-subrc = 0.
        SELECT SINGLE * FROM konp WHERE knumh = a602-knumh.
        IF sy-subrc EQ 0.
          w_kbetr1 = konp-kbetr.
        ENDIF.
      ENDIF.
      IF w_kbetr1 EQ space.
        SELECT SINGLE * FROM a602 WHERE kschl = 'Z001' AND matnr = matnr AND charg = itab-charg AND datbi GT sy-datum.
        IF sy-subrc = 0.
          SELECT SINGLE * FROM konp WHERE knumh = a602-knumh.
          IF sy-subrc EQ 0.
            w_kbetr1 = konp-kbetr.
          ENDIF.
        ENDIF.
      ENDIF.
    ELSE.
      SELECT SINGLE * FROM a602 WHERE kschl = 'Z001' AND matnr = itab-matnr AND charg = itab-charg AND datbi GT sy-datum.
      IF sy-subrc = 0.
        SELECT SINGLE * FROM konp WHERE knumh = a602-knumh.
        IF sy-subrc EQ 0.
          w_kbetr1 = konp-kbetr.
        ENDIF.
      ENDIF.
    ENDIF.
    IF w_kbetr1 EQ space.
      w_kbetr1 = 'NOT DEF'.
    ENDIF.
*************************************************************************************************
    w_umrez1 = w_umrez.
    w_totqty = itab-stock.
    IF w_umrez = 0.
      w_rem = 'NOT DEFINED'.
    ELSE.
      w_sqty = w_totqty MOD w_umrez.
      w_fqty = ( w_totqty - w_sqty ) / w_umrez.
      w_fqty1 = w_fqty.
      w_sqty1 = w_sqty.
      SHIFT w_fqty1 LEFT DELETING LEADING space.
      SHIFT w_sqty1 LEFT DELETING LEADING space.
      SHIFT w_umrez1 LEFT DELETING LEADING space.
      CONCATENATE w_fqty1 'x' w_umrez1 INTO w_rem.
      IF w_sqty NE 0.
        CONCATENATE w_rem ',' '1x' w_sqty1 INTO w_rem.
      ENDIF.
    ENDIF.
*    FORMAT COLOR 1.
*    write : /1(10) itab-matnr,
*     12(25) itab-maktx,
*     39(4) itab-lgort,
*     45(10) itab-charg,
**            57(2)  itab-status,
*     57(10) itab-vfdat,
*     69(10) itab-hsdat,
*     80(9) itab-stock,
*     90(9) itab-stock1,
*     103(25) w_rem,
*     131(7) w_kbetr1.
**            122(2) itab-status.

    wa_tas1-matnr = itab-matnr.
    wa_tas1-maktx = itab-maktx.
    wa_tas1-lgort = itab-lgort.
    wa_tas1-charg = itab-charg.
*            57(2)  itab-status,
    wa_tas1-vfdat = itab-vfdat.
    wa_tas1-hsdat = itab-hsdat.
    wa_tas1-stock = itab-stock.
    wa_tas1-stock1 = itab-stock1.
    wa_tas1-w_rem = w_rem.
    wa_tas1-w_kbetr1 = w_kbetr1.
*            122(2) itab-status.

************* NEW LOGIC FOR ZEX2*****

    SELECT SINGLE * FROM a501 WHERE matnr EQ itab-matnr AND charg EQ itab-charg AND kschl EQ 'ZEX2' AND vkorg EQ '1000' AND vtweg EQ '10' AND
    datab LE sy-datum AND datbi GE sy-datum.
    IF sy-subrc EQ 0.
*    write :  '10'.
*    if a501-vtweg eq '10'.
      SELECT SINGLE * FROM konp WHERE knumh EQ a501-knumh AND kschl EQ 'ZEX2'.
      IF sy-subrc EQ 0.
        a1 = konp-kbetr / 10.
*          WRITE : 140(6) a1.
      ENDIF.
    ENDIF.

    SELECT SINGLE * FROM a501 WHERE matnr EQ itab-matnr AND charg EQ itab-charg AND kschl EQ 'ZEX2' AND vkorg EQ '1000' AND vtweg EQ '20' AND
    datab LE sy-datum AND datbi GE sy-datum.
    IF sy-subrc EQ 0.
*    write :  '10'.
*    if a501-vtweg eq '10'.
      SELECT SINGLE * FROM konp WHERE knumh EQ a501-knumh AND kschl EQ 'ZEX2'.
      IF sy-subrc EQ 0.
        a2 = konp-kbetr / 10.
*          WRITE : 148(6) a2.
      ENDIF.
    ENDIF.

    SELECT SINGLE * FROM a501 WHERE matnr EQ itab-matnr AND charg EQ itab-charg AND kschl EQ 'ZEX2' AND vkorg EQ '1000' AND vtweg EQ '80' AND
    datab LE sy-datum AND datbi GE sy-datum.
    IF sy-subrc EQ 0.
*    write :  '10'.
*    if a501-vtweg eq '10'.
      SELECT SINGLE * FROM konp WHERE knumh EQ a501-knumh AND kschl EQ 'ZEX2'.
      IF sy-subrc EQ 0.
        a3 = konp-kbetr / 10.
*          WRITE : 156(6) a3.
      ENDIF.
    ENDIF.


    SELECT SINGLE * FROM a611 WHERE kappl EQ 'V' AND matnr EQ itab-matnr AND charg EQ itab-charg AND kschl EQ 'ZEX2' AND vkorg EQ '1000' AND datab LE sy-datum AND
    datbi GE sy-datum.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM konp WHERE knumh EQ a611-knumh AND kschl EQ 'ZEX2'.
      IF sy-subrc EQ 0.
        zex2 = konp-kbetr / 10.
*        write :  140(6) zex2.
        wa_tas1-zex2 = zex2.
      ENDIF.
    ENDIF.

******ZCIN VALUE**********************

    SELECT SINGLE knumh FROM a602 INTO w_knumh1 WHERE kschl = 'ZCIN' AND matnr = itab-matnr AND charg = itab-charg AND datbi GT sy-datum.
    IF sy-subrc EQ 0.
      SELECT SINGLE kbetr FROM konp INTO w_kbetr2 WHERE knumh = w_knumh1.
*      write : 148(6) w_kbetr2 left-justified.
      wa_tas1-w_kbetr2 = w_kbetr2.
    ENDIF.
***************JMOD******************
    SELECT SINGLE * FROM a611 WHERE kappl EQ 'V' AND kschl EQ 'JMOD' AND vkorg EQ '1000' AND matnr EQ itab-matnr AND charg = itab-charg AND
    datab LE sy-datum AND datbi GE sy-datum.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM konp WHERE knumh EQ a611-knumh AND kschl EQ 'JMOD'.
      IF sy-subrc EQ 0.
        CLEAR : jmod.
        jmod = konp-kbetr / 10.
        wa_tas1-jmod = jmod.
      ENDIF.
    ELSE.
      SELECT SINGLE * FROM a609 WHERE kappl EQ 'V' AND kschl EQ 'JMOD' AND vkorg EQ '1000' AND matnr EQ itab-matnr AND
      datab LE sy-datum AND datbi GE sy-datum.
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM konp WHERE knumh EQ a609-knumh AND kschl EQ 'JMOD'.
        IF sy-subrc EQ 0.
          CLEAR : jmod.
          jmod = konp-kbetr / 10.
          wa_tas1-jmod = jmod.
        ENDIF.
      ENDIF.
    ENDIF.
**********************
    CLEAR : mtart.
    SELECT SINGLE * FROM mara WHERE matnr EQ itab-matnr.
    IF sy-subrc EQ 0.
*     WRITE : 156 mara-brgew LEFT-JUSTIFIED,164 mara-ntgew LEFT-JUSTIFIED.
*      write : 165 mara-brgew left-justified,174 mara-ntgew left-justified.
      wa_tas1-brgew = mara-brgew.
      wa_tas1-ntgew = mara-ntgew.
      mtart = mara-mtart.
    ENDIF.
*****************TECHO  STATUS******************
    SELECT SINGLE * FROM afpo WHERE dwerk EQ p_plant AND matnr EQ itab-matnr AND charg EQ itab-charg AND wemng GT 0 .
*      AND DNREL EQ 'X'.
    IF sy-subrc EQ 0.
*      WRITE : AFPO-ELIKZ,AFPO-DNREL.
      SELECT SINGLE * FROM afru WHERE aufnr EQ afpo-aufnr AND aueru EQ 'X'.
      IF sy-subrc EQ 0.
        wa_tas1-iedd = afru-iedd.
      ENDIF.
    ENDIF.
***********************************************
    SELECT SINGLE * FROM mseg WHERE matnr EQ itab-matnr AND charg EQ itab-charg AND werks EQ p_plant AND lgort EQ 'CSM'.
    IF sy-subrc EQ 0.
      wa_tas1-text1 = 'CS ISSUED   '.
      wa_tas1-menge = mseg-menge.
    ELSE.
      wa_tas1-text1 = 'CS NOT ISSUED  '.
      CLEAR : ablad.
      SELECT * FROM mseg WHERE matnr EQ itab-matnr AND charg EQ itab-charg AND werks EQ p_plant.
        CONCATENATE ablad mseg-ablad INTO ablad SEPARATED BY '   '.
      ENDSELECT.
      wa_tas1-text2 = ablad.
*      select single * from mseg where matnr eq itab-matnr and charg eq itab-charg and werks eq p_plant and ablad ne space.
*      if sy-subrc eq 0.
*        wa_tas1-text2 = mseg-ablad.
*      endif.

    ENDIF.

    SELECT SINGLE * FROM a602 WHERE kschl = 'ZSAM' AND vkorg EQ '1000' AND matnr = itab-matnr AND charg = itab-charg AND datbi GT sy-datum.
    IF sy-subrc = 0.
      SELECT SINGLE * FROM konp WHERE knumh = a602-knumh.
      IF sy-subrc EQ 0.
        wa_tas1-zsam = konp-kbetr.
      ENDIF.
    ENDIF.
    SELECT SINGLE * FROM a602 WHERE kschl = 'ZSMP' AND vkorg EQ '1000' AND matnr = itab-matnr AND charg = itab-charg AND datbi GT sy-datum.
    IF sy-subrc = 0.
      SELECT SINGLE * FROM konp WHERE knumh = a602-knumh.
      IF sy-subrc EQ 0.
        wa_tas1-zsmp = konp-kbetr.
      ENDIF.
    ENDIF.
    IF r3 EQ 'X'.
*      IF mtart EQ 'ZDSM'.  "23.5.22
      IF mtart EQ 'ZDSM' OR mtart EQ 'ZESM'.  "7.6.22
*        IF  WA_TAS1-W_KBETR1 NE SPACE.
        wa_tas1-w_kbetr1 = wa_tas1-zsam .
        CONDENSE  wa_tas1-w_kbetr1.
*        ENDIF.
      ENDIF.
      IF  wa_tas1-w_kbetr1 EQ space.
        IF mtart EQ 'ZDSM' OR mtart EQ 'ZSMP'.  "7.6.22
*        IF  WA_TAS1-W_KBETR1 NE SPACE.
          wa_tas1-w_kbetr1 = wa_tas1-zsmp .
          CONDENSE  wa_tas1-w_kbetr1.
*        ENDIF.
        ENDIF.

      ENDIF.
    ENDIF.

*    SELECT SINGLE * FROM mseg WHERE matnr EQ itab-matnr AND charg EQ itab-charg AND werks EQ p_plant.
*
*    IF mseg-lgort CS 'CSM '.
**      WRITE : 163 'CS ISSUED   '.
*      WRITE : 171 'CS ISSUED   '.
*      SELECT * FROM mseg WHERE matnr EQ itab-matnr AND charg EQ itab-charg AND werks EQ p_plant.
*        IF mseg-lgort EQ 'CSM '.
**          WRITE : 176 mseg-menge.
*          WRITE : 184 mseg-menge.
*        ENDIF.
*      ENDSELECT.
*    ELSE.
*      WRITE : 171 'CS NOT ISSUED  '.
*      SELECT * FROM mseg WHERE matnr EQ itab-matnr AND charg EQ itab-charg AND
*      werks EQ p_plant.
*        WRITE :   mseg-ablad.
*      ENDSELECT.
*
*
*    ENDIF.

*ENDSELECT.

    COLLECT wa_tas1 INTO it_tas1.
    CLEAR wa_tas1.
  ENDLOOP.
  IF r3 NE 'X'.
    LOOP AT it_tas1 INTO wa_tas1.
      IF wa_tas1-matnr CA 'H'.
      ELSE.
*        PACK wa_tas1-matnr TO wa_tas1-matnr.

        SHIFT wa_tas1-matnr LEFT DELETING LEADING '0'.
        CONDENSE wa_tas1-matnr.
        MODIFY it_tas1 FROM wa_tas1 TRANSPORTING matnr.
      ENDIF.
    ENDLOOP.
  ENDIF.

*        MATNR  maktx lgort charg vfdat hsdat stock
*          stock1  status(2) ablad w_rem(15) w_kbetr1(7) zex2 w_kbetr2 jmod brgew ntgew
*          iedd text1(50) menge text2

  IF r1 EQ 'X'.
    PERFORM alv.
  ELSEIF r2 EQ 'X'.
    PERFORM nonalv.
  ELSEIF r3 EQ 'X'.
    PERFORM print.
  ENDIF.

ENDFORM.

FORM nonalv.
  LOOP AT it_tas1 INTO wa_tas1.
    WRITE : /1(8) wa_tas1-matnr LEFT-JUSTIFIED,11(25) wa_tas1-maktx LEFT-JUSTIFIED,39(4) wa_tas1-lgort,46(10) wa_tas1-charg,
    59(10) wa_tas1-vfdat,71(10) wa_tas1-hsdat,84(10) wa_tas1-stock,97(10) wa_tas1-stock1,110(25) wa_tas1-w_rem,
    137(7) wa_tas1-w_kbetr1,147(7) wa_tas1-zsam,157(7) wa_tas1-zsmp,166(7) wa_tas1-w_kbetr2,175 wa_tas1-brgew LEFT-JUSTIFIED,186 wa_tas1-ntgew LEFT-JUSTIFIED,
    196(10) wa_tas1-iedd LEFT-JUSTIFIED ,208(15) wa_tas1-text1 LEFT-JUSTIFIED.
*      137(7) WA_TAS1-W_KBETR1,147(7) WA_TAS1-ZSAM,157(7) WA_TAS1-ZSMP,WA_TAS1-W_KBETR2,166 WA_TAS1-BRGEW LEFT-JUSTIFIED,176 WA_TAS1-NTGEW LEFT-JUSTIFIED,
*    186(10) WA_TAS1-IEDD LEFT-JUSTIFIED ,198(15) WA_TAS1-TEXT1 LEFT-JUSTIFIED.
    IF wa_tas1-menge NE 0.
      WRITE : 225 wa_tas1-menge LEFT-JUSTIFIED.
    ELSE.
      WRITE : 225 wa_tas1-text2 LEFT-JUSTIFIED.
    ENDIF.
  ENDLOOP.
ENDFORM.

FORM alv.
  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_l = 'PRODUCT CODE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'MAKTX'.
  wa_fieldcat-seltext_l = 'PRODUCT NAME'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'LGORT'.
  wa_fieldcat-seltext_l = 'STORAGE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'CHARG'.
  wa_fieldcat-seltext_l = 'BATCH'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'VFDAT'.
  wa_fieldcat-seltext_l = 'EXPIRY DATE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'HSDAT'.
  wa_fieldcat-seltext_l = 'MFG. DATE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'STOCK'.
  wa_fieldcat-seltext_l = 'TOTAL STOCK'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'STOCK1'.
  wa_fieldcat-seltext_l = 'UNREST.STOCK'.
  APPEND wa_fieldcat TO fieldcat.

*  wa_fieldcat-fieldname = 'STATUS'.
*  wa_fieldcat-seltext_l = 'STATUS'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'ABLAD'.
*  wa_fieldcat-seltext_l = 'ABLAD'.
*  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'W_REM'.
  wa_fieldcat-seltext_l = 'SHIPPER BREAK UP'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'W_KBETR1'.
  wa_fieldcat-seltext_l = 'MRP'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'ZSAM'.
  wa_fieldcat-seltext_l = 'ZSAM'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'ZSMP'.
  wa_fieldcat-seltext_l = 'ZSMP'.
  APPEND wa_fieldcat TO fieldcat.

*  wa_fieldcat-fieldname = 'ZEX2'.
*  wa_fieldcat-seltext_l = 'ZEX2'.
*  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'W_KBETR2'.
  wa_fieldcat-seltext_l = 'ZCIN'.
  APPEND wa_fieldcat TO fieldcat.

*  wa_fieldcat-fieldname = 'JMOD'.
*  wa_fieldcat-seltext_l = 'JMOD'.
*  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'BRGEW'.
  wa_fieldcat-seltext_l = 'GROSS WT'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'NTGEW'.
  wa_fieldcat-seltext_l = 'NET WT'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'IEDD'.
  wa_fieldcat-seltext_l = 'FINAL BATCH CONF.'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'TEXT1'.
  wa_fieldcat-seltext_l = 'CS STATUS'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'MENGE'.
  wa_fieldcat-seltext_l = 'CS QTY'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'TEXT2'.
  wa_fieldcat-seltext_l = 'STATUS'.
  APPEND wa_fieldcat TO fieldcat.


  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'STOCK DETAIL'.


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
      t_outtab                = it_tas1
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.                    "itab-prt

FORM top.

  DATA: comment    TYPE slis_t_listheader,
        wa_comment LIKE LINE OF comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'STOCK DETAILS'.
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
    WHEN 'MATNR'.
      SET PARAMETER ID 'MAT' FIELD selfield-value.
      CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
    WHEN 'VBELN1'.
      SET PARAMETER ID 'BV' FIELD selfield-value.
      CALL TRANSACTION 'VL03N' AND SKIP FIRST SCREEN.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.                    "USER_COMM

FORM authorization .

  SELECT werks name1 FROM t001w INTO TABLE itab_t001w WHERE werks EQ p_plant.

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
*&      Form  PRINT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print .

  LOOP AT it_tas1 INTO wa_tas1.
    SELECT SINGLE * FROM mara WHERE matnr EQ wa_tas1-matnr AND mtart EQ 'ZDSI'.
    IF sy-subrc EQ 0.
      wa_smp1-matnr = mara-matnr.
      wa_smp1-charg = wa_tas1-charg.
      COLLECT wa_smp1 INTO it_smp1.
      CLEAR wa_smp1.
    ENDIF.
  ENDLOOP.

  IF it_smp1 IS NOT INITIAL.
    SELECT * FROM mseg INTO TABLE it_mseg FOR ALL ENTRIES IN it_smp1 WHERE bwart EQ '101' AND matnr EQ it_smp1-matnr AND charg EQ it_smp1-charg
      AND lifnr NE space.
  ENDIF.
  SORT it_mseg DESCENDING BY mblnr.

  LOOP AT it_tas1 INTO wa_tas1.
    wa_tab2-matnr = wa_tas1-matnr.
    wa_tab2-maktx = wa_tas1-maktx.
    wa_tab2-lgort = wa_tas1-lgort.
    wa_tab2-charg = wa_tas1-charg.
    wa_tab2-vfdat = wa_tas1-vfdat.
    wa_tab2-hsdat = wa_tas1-hsdat.

    wa_tab2-stock = wa_tas1-stock.
    wa_tab2-stock1 = wa_tas1-stock1.
    wa_tab2-w_rem = wa_tas1-w_rem.
    CLEAR: mtart.
    SELECT SINGLE * FROM mara WHERE matnr EQ wa_tas1-matnr.
    IF sy-subrc EQ 0.
      mtart = mara-mtart.
    ENDIF.
    IF mtart EQ 'ZDSM'.
      wa_tab2-mrpsam = wa_tas1-zsam.
    ELSE.
      wa_tab2-mrpsam = wa_tas1-w_kbetr1.
    ENDIF.

    IF mtart EQ 'ZDSI'.
      READ TABLE it_mseg INTO wa_mseg WITH KEY matnr = wa_tas1-matnr charg = wa_tas1-charg.
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM ekpo WHERE ebeln EQ wa_mseg-ebeln AND ebelp EQ wa_mseg-ebelp.
        IF sy-subrc EQ 0.
          CLEAR : rate.
          rate = ekpo-netpr / ekpo-peinh.
        ENDIF.
        wa_tab2-mrpsam = rate.
      ENDIF.
    ENDIF.

    CONDENSE : wa_tab2-stock,wa_tab2-stock1,wa_tab2-w_rem,wa_tab2-mrpsam.
    COLLECT wa_tab2 INTO it_tab2.
    CLEAR wa_tab2.
  ENDLOOP.

  LOOP AT it_tab2 INTO wa_tab2.
    IF wa_tab2-matnr CA 'H'.
    ELSE.
*      PACK wa_tab2-matnr TO wa_tab2-matnr.

      SHIFT wa_tas1-matnr LEFT DELETING LEADING '0'.
      CONDENSE wa_tab2-matnr.
      MODIFY it_tab2 FROM wa_tab2 TRANSPORTING matnr.
    ENDIF.
  ENDLOOP.


  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
*     formname           = 'ZDBS1'
      formname           = 'ZDBS2'
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
      fm_name            = v_fm
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.

  CALL FUNCTION v_fm
    EXPORTING
*     from_dt          = from_dt
*     to_dt            = to_dt
      format           = format
      kunnr            = kunnr
      addr             = addr
*     AUBEL            = AUBEL
*     adrc             = adrc
*     t001w            = t001w
*     J_1IMOCUST       = J_1IMOCUST
*     G_LSTNO          = G_LSTNO
*     WA_ADRC          = WA_ADRC
*     VBKD             = VBKD
*     vbrk             = vbrk
*     fkdat            = fkdat
*     TOTAL            = TOTAL
*     TOTAL1           = TOTAL1
*     VBRK             = VBRK
*     W_TAX            = W_TAX
*     W_VALUE          = W_VALUE
*     SPELL            = SPELL
*     W_DIFF           = W_DIFF
*     EMNAME           = EMNAME
*     RMNAME           = RMNAME
*     CLMDT            = CLMDT
    TABLES
      it_tab2          = it_tab2
*     it_vbrp          = it_vbrp
*     ITAB_DIVISION    = ITAB_DIVISION
*     ITAB_STORAGE     = ITAB_STORAGE
*     ITAB_PA0002      = ITAB_PA0002
    EXCEPTIONS
      formatting_error = 1
      internal_error   = 2
      send_error       = 3
      user_canceled    = 4
      OTHERS           = 5.



*  wa_fieldcat-fieldname = 'W_KBETR1'.
*  wa_fieldcat-seltext_l = 'MRP'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'ZSAM'.
*  wa_fieldcat-seltext_l = 'ZSAM'.
*  append wa_fieldcat to fieldcat.
*
**  wa_fieldcat-fieldname = 'ZEX2'.
**  wa_fieldcat-seltext_l = 'ZEX2'.
**  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'W_KBETR2'.
*  wa_fieldcat-seltext_l = 'ZCIN'.
*  append wa_fieldcat to fieldcat.


ENDFORM.
