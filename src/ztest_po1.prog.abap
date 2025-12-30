*&---------------------------------------------------------------------*
*& Subroutinenpool ZTEST_PO1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
PROGRAM ztest_po1.
DATA : me_copypo.
*INCLUDE ZMM_BCLLFM06PTOP_p1.
*include ztop1.
*include ztop1.
INCLUDE ztop1.
INCLUDE fm06pe01_entry_neu .   " ENTRY_NEU


*INCLUDE ZMM_BCLLFM06PF01.
*&---------------------------------------------------------------------*
*&      Form  LESEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_NAST  text
*----------------------------------------------------------------------*
FORM lesen USING unast STRUCTURE nast.
  CLEAR : it_ekpo,wa_ekpo.
  CLEAR : it_tab1,wa_tab1.

  CLEAR : deldt.
*********************delivery date***********
  CLEAR : it_eket,wa_eket,deldt,muldel.
  SELECT * FROM eket INTO TABLE it_eket WHERE ebeln EQ nast-objky .

  SELECT * FROM ekpo INTO TABLE it_ekpo WHERE ebeln EQ nast-objky AND loekz EQ space.
  IF it_ekpo IS NOT INITIAL.
    CLEAR : tot,potot,werks,tax1,waers,mat.
    REFRESH : t_lines,it_txt1.
    LOOP AT it_ekpo INTO wa_ekpo.
      SELECT SINGLE * FROM ekko WHERE ebeln EQ wa_ekpo-ebeln. "added on 11.12.23
      IF sy-subrc EQ 0.
        CLEAR : qty,bsart,prms,mtart,aedat,prmsno,artno,art,knumv,lifnr,ser,pms,art.
        werks = wa_ekpo-werks.
        wa_tab1-ebelp = wa_ekpo-ebelp.
        wa_tab1-txz01 = wa_ekpo-txz01.
        SELECT SINGLE * FROM eket WHERE ebeln EQ wa_ekpo-ebeln AND ebelp EQ wa_ekpo-ebelp.
        IF sy-subrc EQ 0.
          wa_tab1-licha = eket-licha.
        ENDIF.
        wa_tab1-retpo = wa_ekpo-retpo.
        IF wa_ekpo-retpo EQ 'X'.  "24.11.23
          wa_ekpo-menge = wa_ekpo-menge * ( - 1 ).
          wa_ekpo-netpr = wa_ekpo-netpr * ( - 1 ).
          wa_ekpo-netwr = wa_ekpo-netwr * ( - 1 ).
        ENDIF.
        IF wa_ekpo-matnr GT 0.
          mat = 'Y'.
        ENDIF.
**************************
*      ********** CHANGE IN PO FOR LONG DESCRIPTION FROM MM02-ADDIIRONAL TEST EN & ZI - 10.12.20
        CLEAR : maktx,maktx1,maktx2,normt.  "10.12.20
        SELECT SINGLE * FROM makt WHERE spras EQ 'EN' AND matnr EQ wa_ekpo-matnr.
        IF sy-subrc EQ 0.
          maktx1 = makt-maktx.
        ENDIF.
        SELECT SINGLE * FROM makt WHERE spras EQ 'Z1' AND matnr EQ wa_ekpo-matnr.
        IF sy-subrc EQ 0.
          maktx2 = makt-maktx.
        ENDIF.
        SELECT SINGLE * FROM mara WHERE matnr EQ wa_ekpo-matnr.
        IF sy-subrc EQ 0.
          normt = mara-normt.
        ENDIF.
        CONCATENATE maktx1 maktx2 normt INTO maktx SEPARATED BY space.
*          IF maktx2 EQ space.  "3.2.22
*            maktx = ekpo-txz01.
*          ENDIF.
        IF maktx EQ space.
          maktx = wa_ekpo-txz01.
        ENDIF.
*          IF ekpo-aedat LT '20201210'.  "3.2.22
        IF ekko-aedat LT '20201210'.
          maktx = wa_ekpo-txz01.
        ENDIF.
********* added on 29.11.22*********************
        SELECT SINGLE * FROM zpo_matnr WHERE matnr EQ wa_ekpo-matnr.
        IF sy-subrc EQ 0.
          SELECT SINGLE * FROM ekpa WHERE ebeln EQ ekko-ebeln AND parvw EQ 'HR'.
          IF sy-subrc EQ 0.
            SELECT SINGLE * FROM zpo_matnr WHERE matnr EQ wa_ekpo-matnr AND lifnr EQ ekpa-lifn2.
            IF sy-subrc EQ 0.
              IF ekko-aedat GE zpo_matnr-effectdt.
                maktx = zpo_matnr-maktx.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
*************************************************

        CONDENSE maktx.

        wa_tab1-txz01 = maktx.
********************************
        CLEAR : qty.
        qty = wa_ekpo-menge.
        wa_tab1-menge = qty.
*      if wa_ekpo-matkl cs 'SER'.
*        ser = 'Y'.
*      else.
*        ser = 'N'.
*      endif.
        wa_tab1-meins = wa_ekpo-meins.
        wa_tab1-netpr = wa_ekpo-netpr.
        wa_tab1-peinh = wa_ekpo-peinh.
        wa_tab1-netwr = wa_ekpo-netwr.
        wa_tab1-matnr = wa_ekpo-matnr.
        wa_tab1-j_1bnbm = wa_ekpo-j_1bnbm.
        CONDENSE: wa_tab1-peinh,wa_tab1-matnr, wa_tab1-menge.
*        wa_tab1-netWR,wa_tab1-netpr,
        CLEAR : hsntxt.
        IF wa_ekpo-matkl+0(4) CS 'SERV'.
          hsntxt = 'SAC CODE'.
        ELSE.
          hsntxt = 'HSN CODE'.
        ENDIF.
        wa_tab1-hsntxt = hsntxt.
        SELECT SINGLE * FROM mara WHERE matnr EQ wa_ekpo-matnr.
        IF sy-subrc EQ 0.
          mtart = mara-mtart.
        ENDIF.
        IF mtart EQ 'ZVRP'.
          prms = 'PMS No.: '.
          art = 'Y'.
        ELSEIF mtart EQ 'ZROH'.
          prms = 'RMS No.: '.
        ENDIF.
        SELECT SINGLE * FROM ekko WHERE ebeln EQ wa_ekpo-ebeln.
        IF sy-subrc EQ 0.
          bsart = ekko-bsart.
          aedat = ekko-aedat.
          knumv = ekko-knumv.
          lifnr = ekko-lifnr.
          wa_tab1-waers = ekko-waers.
          waers = ekko-waers.
        ENDIF.

*      SHIFT wa_tab1-ebelp LEFT DELETING LEADING '000'.
***************pms*************************
        "IF bsart  EQ 'ZL'.  "12.1.21
        IF ekko-aedat GE '20210423'.  "23.4.21
          SELECT SINGLE * FROM zqspecification  WHERE matnr EQ wa_ekpo-matnr AND werks EQ wa_ekpo-werks AND effectdt LE aedat AND effectenddt GE aedat.
          IF sy-subrc EQ 0.
            prmsno = zqspecification-specification.
            artno = zqspecification-artwork.
          ENDIF.
        ELSE.
          SELECT SINGLE * FROM zpms_art_table WHERE matnr EQ wa_ekpo-matnr AND from_dt LE wa_ekpo-aedat AND to_dt GE wa_ekpo-aedat.
          IF sy-subrc EQ 0.
            prmsno = zpms_art_table-pms_no.
            artno = zpms_art_table-art_no.
          ENDIF.
          "ENDIF.
        ENDIF.
        wa_tab1-prms = prms.
        wa_tab1-art = 'Artwork No.'.
        wa_tab1-prmsno = prmsno.
        wa_tab1-artno = artno.
        IF prmsno NE space.
          pms = 'Y'.
        ENDIF.
*      if artno ne space.
*        art = 'Y'.
*      endif.
*********read text***********
        CLEAR : l_line,l_name.
        REFRESH : t_lines.
        l_id = 'F01'.
        l_lang = 'EN'.
        l_object = 'EKPO'.
        CONCATENATE wa_ekpo-ebeln wa_ekpo-ebelp INTO l_name.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
*           CLIENT                  = SY-MANDT
            id                      = l_id
            language                = l_lang
            name                    = l_name
            object                  = l_object
*           ARCHIVE_HANDLE          = 0
*           LOCAL_CAT               = ' '
* IMPORTING
*           HEADER                  =
          TABLES
            lines                   = t_lines
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.
        IF sy-subrc = 0.
          READ TABLE t_lines INTO l_line INDEX 1.
        ELSE.
          l_line = ' '.
        ENDIF.
*      if t_lines IS NOT INITIAL.


*      if l_line is not initial.
        CLEAR : count.
        count = 1.
        CLEAR : txt2.
        LOOP AT t_lines.
          wa_txt1-count = count.
          wa_txt1-ebelp = wa_ekpo-ebelp.
          REPLACE ALL OCCURRENCES OF '<(>' IN t_lines-tdline WITH ''.
          REPLACE ALL OCCURRENCES OF '<)>' IN t_lines-tdline WITH ''.
          txt2 = 'Y'.
          MOVE t_lines-tdline TO wa_txt1-text.
          COLLECT wa_txt1 INTO it_txt1.
          CLEAR wa_txt1.
          count = count + 1.
        ENDLOOP.

*********************** text2*********************
        IF txt2 NE 'Y'.
****        ******read text***********
          CLEAR : l_line,l_name.
          REFRESH : t_lines.
          l_id = 'F02'.
          l_lang = 'EN'.
          l_object = 'EKPO'.
          CONCATENATE wa_ekpo-ebeln wa_ekpo-ebelp INTO l_name.
          CALL FUNCTION 'READ_TEXT'
            EXPORTING
*             CLIENT                  = SY-MANDT
              id                      = l_id
              language                = l_lang
              name                    = l_name
              object                  = l_object
*             ARCHIVE_HANDLE          = 0
*             LOCAL_CAT               = ' '
* IMPORTING
*             HEADER                  =
            TABLES
              lines                   = t_lines
            EXCEPTIONS
              id                      = 1
              language                = 2
              name                    = 3
              not_found               = 4
              object                  = 5
              reference_check         = 6
              wrong_access_to_archive = 7
              OTHERS                  = 8.
          IF sy-subrc = 0.
            READ TABLE t_lines INTO l_line INDEX 1.
          ELSE.
            l_line = ' '.
          ENDIF.
*      if t_lines IS NOT INITIAL.
*      if l_line is not initial.
          CLEAR : count.
          count = 1.
****************************************************
          LOOP AT t_lines.
            wa_txt1-count = count.
            wa_txt1-ebelp = wa_ekpo-ebelp.
            txt2 = 'Y'.
            REPLACE ALL OCCURRENCES OF '<(>' IN t_lines-tdline WITH ''.
            REPLACE ALL OCCURRENCES OF '<)>' IN t_lines-tdline WITH ''.
            MOVE t_lines-tdline TO wa_txt1-text.
            COLLECT wa_txt1 INTO it_txt1.
            CLEAR wa_txt1.
            count = count + 1.
          ENDLOOP.
        ENDIF.

*******************add third text if 2 text are not available*-****************

        IF txt2 NE 'Y'.
****        ******read text***********
          CLEAR : l_line,l_name.
          REFRESH : t_lines.
          l_id = 'F03'.
          l_lang = 'EN'.
          l_object = 'EKPO'.
          CONCATENATE wa_ekpo-ebeln wa_ekpo-ebelp INTO l_name.
          CALL FUNCTION 'READ_TEXT'
            EXPORTING
*             CLIENT                  = SY-MANDT
              id                      = l_id
              language                = l_lang
              name                    = l_name
              object                  = l_object
*             ARCHIVE_HANDLE          = 0
*             LOCAL_CAT               = ' '
* IMPORTING
*             HEADER                  =
            TABLES
              lines                   = t_lines
            EXCEPTIONS
              id                      = 1
              language                = 2
              name                    = 3
              not_found               = 4
              object                  = 5
              reference_check         = 6
              wrong_access_to_archive = 7
              OTHERS                  = 8.
          IF sy-subrc = 0.
            READ TABLE t_lines INTO l_line INDEX 1.
          ELSE.
            l_line = ' '.
          ENDIF.
*      if t_lines IS NOT INITIAL.
*      if l_line is not initial.
          CLEAR : count.
          count = 1.
****************************************************
          LOOP AT t_lines.
            wa_txt1-count = count.
            wa_txt1-ebelp = wa_ekpo-ebelp.
            txt2 = 'Y'.
            REPLACE ALL OCCURRENCES OF '<(>' IN t_lines-tdline WITH ''.
            REPLACE ALL OCCURRENCES OF '<)>' IN t_lines-tdline WITH ''.
            MOVE t_lines-tdline TO wa_txt1-text.
            COLLECT wa_txt1 INTO it_txt1.
            CLEAR wa_txt1.
            count = count + 1.
          ENDLOOP.
        ENDIF.

******************* material text if all other texts are blank - text are not available*-****************

        IF txt2 EQ space.
*        break-point  .
****        ******read text***********
          CLEAR : l_line,l_name,l_id,l_object.
          REFRESH : t_lines.
          l_id = 'BEST'.
          l_lang = 'EN'.
          l_object = 'MATERIAL'.
          l_name = wa_ekpo-matnr.
*        concatenate wa_ekpo-matnr into l_name.
          CALL FUNCTION 'READ_TEXT'
            EXPORTING
*             CLIENT                  = SY-MANDT
              id                      = l_id
              language                = l_lang
              name                    = l_name
              object                  = l_object
*             ARCHIVE_HANDLE          = 0
*             LOCAL_CAT               = ' '
* IMPORTING
*             HEADER                  =
            TABLES
              lines                   = t_lines
            EXCEPTIONS
              id                      = 1
              language                = 2
              name                    = 3
              not_found               = 4
              object                  = 5
              reference_check         = 6
              wrong_access_to_archive = 7
              OTHERS                  = 8.
          IF sy-subrc = 0.
            READ TABLE t_lines INTO l_line INDEX 1.
          ELSE.
            l_line = ' '.
          ENDIF.
*      if t_lines IS NOT INITIAL.
*      if l_line is not initial.
          CLEAR : count.
          count = 1.
****************************************************
          LOOP AT t_lines.
            wa_txt1-count = count.
            wa_txt1-ebelp = wa_ekpo-ebelp.
            txt2 = 'Y'.
            REPLACE ALL OCCURRENCES OF '<(>' IN t_lines-tdline WITH ''.
            REPLACE ALL OCCURRENCES OF '<)>' IN t_lines-tdline WITH ''.
            MOVE t_lines-tdline TO wa_txt1-text.
            COLLECT wa_txt1 INTO it_txt1.
            CLEAR wa_txt1.
            count = count + 1.
          ENDLOOP.
        ENDIF.
*******************************gross prices before discount*************
        CLEAR: gross,grossval.
        SELECT SINGLE * FROM prcd_elements WHERE knumv EQ knumv AND kposn EQ wa_ekpo-ebelp AND kschl EQ 'PBXX'.
        IF sy-subrc EQ 0.
          gross = prcd_elements-kbetr.
          grossval = prcd_elements-kwert.
        ENDIF.
        wa_tab1-gross = gross.
        wa_tab1-grossval = grossval.
*      condense :wa_tab1-gross,wa_tab1-grossval.
*************tax******************
        tax1 = 'Y'.
        PERFORM oritax.
        IF tax EQ 0.
          CLEAR : tax1.
          tax1 = ' '.
*      perform tax.                  "Uncommented BY Mounika on 01.09.2023
        ENDIF.
        tot = tot + wa_ekpo-netwr + jiig_val + jisg_val + jicg_val + jcis_val.
*      break-point.
*******************GST NO.******************************************************
        PERFORM gstnno.
        PERFORM deldt.

        DATA: lt_lfa1 TYPE lfa1,
              lv_mfg  TYPE lfa1-name1,
              lv_ekpo TYPE ekpo,
              lv_lifnr TYPE ekko-lifnr.

        Select lifnr from ekko into lv_lifnr where ebeln = wa_ekpo-ebeln.
        ENDSELECT.
        SELECT * FROM ekpo INTO  lv_ekpo  WHERE ebeln = wa_ekpo-ebeln AND ebelp = wa_ekpo-ebelp.
        ENDSELECT.
        "select * from lfa1 into lt_lfa1 where lifnr = wa_ekpo-MFRNR.
          IF lv_lifnr NE LV_ekpo-mfrnr.
          SELECT * FROM lfa1 INTO lt_lfa1 WHERE lifnr = LV_ekpo-mfrnr.
          ENDSELECT.
          IF sy-subrc = 0.
*            mfg = 'Y'.
*          ENDIF.

          mfg = 'Y'.
          lv_mfg = lt_LFA1-name1.
          ENDIF.
          CONDENSE lv_mfg.

          wa_tab1-name1 = lv_mfg.
          CLEAR lv_mfg.
        ENDIF.
*wa_tab1-MFRNR = wa_ekpo-MFRNR.
*Append wa_tab1 To IT_tab1.
*if sy-subrc = 0.
*mfg = 'Y'.
*endif.
************************************************************************
        COLLECT wa_tab1 INTO it_tab1.
*      ENDIF.,
*do 30 TIMES .
**        APPEND  wa_tab1 to it_tab1.
*
*       enddo.
*    ENDIF.

    SORT it_tab1 BY ebelp.
    CLEAR wa_tab1.
  ENDIF.
ENDLOOP.
ENDIF.

READ TABLE it_eket INTO wa_eket WITH KEY ebeln = ekko-ebeln.
IF sy-subrc EQ 0.
deldt = wa_eket-eindt.
ENDIF.
LOOP AT it_eket INTO wa_eket WHERE ebeln EQ ekko-ebeln AND eindt NE deldt.
muldel = 'Y'.
ENDLOOP.


*  break-point .

potot = tot.
CLEAR totword.
CALL FUNCTION 'Z_SPELL_AMOUNT_INDIA'
EXPORTING
  amount   = tot
  language = sy-langu
IMPORTING
  in_words = wor.

WRITE wor-word TO totword-word.
SHIFT totword-word LEFT DELETING LEADING space.
SHIFT totword-word LEFT DELETING LEADING '0'.
SHIFT totword-word LEFT DELETING LEADING '#'.
SHIFT totword-word LEFT DELETING LEADING space(1).

totword1 = totword-word.

*  CLEAR : mfgr,mfg.
SELECT SINGLE * FROM ekpa WHERE ebeln EQ ekko-ebeln AND parvw EQ 'HR'.
IF sy-subrc EQ 0.
  SELECT SINGLE * FROM lfa1 WHERE lifnr EQ ekpa-lifn2.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM adrc WHERE addrnumber EQ lfa1-adrnr.
*      IF sy-subrc EQ 0.
*        mfgr = adrc-name1.
*        mfg = 'Y'.
*        IF ekpa-lifn2 EQ ekko-lifnr.
*          CLEAR : mfg.
*        ENDIF.
*      ENDIF.
      ENDIF.
    ENDIF.

*data: lt_lfa1 type lfa1,
*      LV_MFG TYPE STRING,
*      lt_ekpo TYPE  table of EKPO,
*      lv_ekpo type ekpo.
*
*select * FROM ekpo INTO table lt_ekpo  where EBELN = wa_ekpo-ebeln AND EBELP = wa_ekpo-ebelp.
*
*
*"select * from lfa1 into lt_lfa1 where lifnr = wa_ekpo-MFRNR.
*IF lt_ekpo is not INITIAL.
*READ TABLE lt_ekpo into lv_ekpo index 1.
*if sy-subrc = 0.
*select * from lfa1 into lt_lfa1 where lifnr = LV_ekpo-MFRNR.
*ENDSELECT.
*endif.
*LV_MFG = lt_LFA1-NAME1.
*CONDENSE LV_MFG.
*
*endif.
**wa_tab1-MFRNR = wa_ekpo-MFRNR.
**Append wa_tab1 To IT_tab1.
*if sy-subrc = 0.
*mfg = 'Y'.
*endif.

*****************vendor address***********************
    CLEAR : name1,name2,ort01,stcd3,sc.
    SELECT SINGLE * FROM lfa1 WHERE lifnr EQ lifnr.
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM adrc WHERE addrnumber EQ lfa1-adrnr.
          IF sy-subrc EQ 0.
            name1 = adrc-name1.
            CONCATENATE adrc-name2 adrc-name3 adrc-name4 adrc-street adrc-str_suppl1 adrc-str_suppl2 INTO name2 SEPARATED BY space.
          ENDIF.
          CONCATENATE lfa1-ort01 lfa1-pstlz INTO ort01 SEPARATED BY space.
          stcd3 = lfa1-stcd3.
          sc = lfa1-stcd3+0(2).
        ENDIF.
        CONDENSE: name1, name2, ort01.
        CLEAR : addr4,addr2,addr3.
        SELECT SINGLE * FROM t001w WHERE werks EQ werks.
          IF sy-subrc EQ 0.
            SELECT SINGLE * FROM adrc WHERE addrnumber EQ t001w-adrnr.
              IF sy-subrc EQ 0.
                addr2 = adrc-name2.
                IF addr2 IS INITIAL.
                  addr2 = adrc-name_co.
                ENDIF.
*      addr3 = adrc-name3.
*      addr4 = adrc-name4.
*                CONCATENATE adrc-street adrc-str_suppl1 INTO addr3 SEPARATED BY space.

                addr3 = adrc-street .
                CONDENSE addr3.
                CONCATENATE  adrc-str_suppl1 adrc-city1 adrc-post_code1 INTO addr4 SEPARATED BY space.
                CONDENSE addr4.
              ENDIF.
*    select single *  from kna1 where kunnr eq t001w-kunnr.
*    if sy-subrc eq 0.
*      astcd3 = kna1-stcd3.
*      asc = kna1-stcd3+0(2).
*    endif.
            ENDIF.
            CONDENSE : addr2,addr3,addr4.
*************header text****************************************************
******read text***********
            CLEAR : l_line,l_name.
            REFRESH : t_lines.
            CLEAR : l_id,l_lang,l_object,l_name.
            l_id = 'F01'.
            l_lang = 'EN'.
            l_object = 'EKKO'.
            l_name = ekko-ebeln.
            CALL FUNCTION 'READ_TEXT'
              EXPORTING
*               CLIENT                  = SY-MANDT
                id                      = l_id
                language                = l_lang
                name                    = l_name
                object                  = l_object
*               ARCHIVE_HANDLE          = 0
*               LOCAL_CAT               = ' '
* IMPORTING
*               HEADER                  =
              TABLES
                lines                   = t_lines
              EXCEPTIONS
                id                      = 1
                language                = 2
                name                    = 3
                not_found               = 4
                object                  = 5
                reference_check         = 6
                wrong_access_to_archive = 7
                OTHERS                  = 8.
            IF sy-subrc = 0.
              READ TABLE t_lines INTO l_line INDEX 1.
            ELSE.
              l_line = ' '.
            ENDIF.
*      if t_lines IS NOT INITIAL.


*      if l_line is not initial.
            CLEAR : count.
            count = 1.

            LOOP AT t_lines.
              wa_txt2-count = count.
              REPLACE ALL OCCURRENCES OF '<(>' IN t_lines-tdline WITH ''.
              REPLACE ALL OCCURRENCES OF '<)>' IN t_lines-tdline WITH ''.
              MOVE t_lines-tdline TO wa_txt2-text.
              COLLECT wa_txt2 INTO it_txt2.
              CLEAR wa_txt2.
              count = count + 1.
            ENDLOOP.
*******DELIVERY DATE & TERMS OF PAYMENT**********
            CLEAR : popayterm.
*  clear : deldt.
**********************delivery date***********
*  clear : it_eket,wa_eket,deldt,muldel.
*  select * from eket into table it_eket where ebeln eq ekko-ebeln.
*  read table it_eket into wa_eket with key ebeln = ekko-ebeln.
*  if sy-subrc eq 0.
*    deldt = wa_eket-eindt.
*  endif.
*  loop at it_eket into wa_eket where ebeln eq ekko-ebeln and eindt ne deldt.
*    muldel = 'Y'.
*  endloop.
*  break-point .
****************************************************************

***  select single * from ekpo where ebeln eq ekko-ebeln and loekz eq space.
***  if sy-subrc eq 0.
***    select single * from eket where ebeln eq ekpo-ebeln.
***    if sy-subrc eq 0.
***      deldt = eket-eindt.
***    endif.
***  endif.

            CLEAR: t_ztext.
*  if ekko-aedat lt '20230921'.
*    call function 'FI_PRINT_ZTERM'
*      exporting
*        i_zterm = ekko-zterm
*        i_langu = sy-langu
**       I_XT052U              = ' '
**       I_T052  =
*      tables
*        t_ztext = t_ztext
**  call function 'FI_F4_ZTERM'
**    exporting
**       i_koart = 'X'
**       i_zterm = ekko-zterm
***     I_XSHOW    = ' '
***     I_ZTYPE    = ' '
**       i_no_popup = 'X'
**    importing
**       e_zterm = t_ztext2
**       et_zterm   = w_ztext2
***TABLES
***  T
*** EXCEPTIONS
***     NOTHING_FOUND       = 1
***     OTHERS     = 2
**    .
**  if sy-subrc <> 0.
*** Implement suitable error handling here
**  endif.
**LOOP AT T_ztext2 .
***  WHERE ZTERM EQ EKKO-ZTERM.
**
** ENDLOOP.
** EXCEPTIONS
**       ZTERM_NOT_FOUND       = 1
**       OTHERS  = 2
*      .
*    if sy-subrc <> 0.
** Implement suitable error handling here
*    endif.
*    clear : it_pterm1.
*    loop at t_ztext into w_ztext.
*      wa_pterm1-text1 = w_ztext-text1.
*      collect wa_pterm1 into it_pterm1.
*      clear wa_pterm1.
*    endloop.
*  else.
            SELECT SINGLE * FROM tvzbt WHERE spras EQ 'EN' AND zterm EQ ekko-zterm.
              IF sy-subrc EQ 0.
                IF tvzbt-vtext EQ space.
                  SELECT SINGLE * FROM t052u WHERE spras EQ 'EN' AND zterm EQ ekko-zterm.
                    IF sy-subrc EQ 0.
                      wa_pterm1-text1 = t052u-text1.
                      COLLECT wa_pterm1 INTO it_pterm1.
                      CLEAR wa_pterm1.
                    ENDIF.
                  ELSE.
                    wa_pterm1-text1 = tvzbt-vtext.
                    COLLECT wa_pterm1 INTO it_pterm1.
                    CLEAR wa_pterm1.
                  ENDIF.
                ELSE.
                  SELECT SINGLE * FROM t052u WHERE spras EQ 'EN' AND zterm EQ ekko-zterm.
                    IF sy-subrc EQ 0.
                      wa_pterm1-text1 = t052u-text1.
                      COLLECT wa_pterm1 INTO it_pterm1.
                      CLEAR wa_pterm1.
                    ENDIF.
                  ENDIF.

*  select single * from t052u where spras eq 'EN' and zterm eq ekko-zterm.
*  if sy-subrc eq 0.
*    wa_pterm1-text1 = t052u-text1.
*    collect wa_pterm1 into it_pterm1.
*    clear wa_pterm1.
*  endif.
*  endif.
*  loop at it_txt1 into wa_txt1.
*    replace all occurrences of '<(>' in wa_txt1-text with ''.
*    replace all occurrences of '<)>' in wa_txt1-text with ''.
*  endloop.
*******************************************************************************
*  break-point.

                  IF ekko-bsart CS 'ZSRV'.
                    ser = 'Y'.
                  ELSE.
                    ser = 'N'.
                  ENDIF.
                  CLEAR : imp.
                  IF ekko-bsart CS 'ZI'.
                    imp = 'Y'.
                  ENDIF.

                  LOOP AT it_tab1 INTO wa_tab1 WHERE jiig GT 0.
*    JI = 'Y'.
                    tax1 = 'Y'.
                  ENDLOOP.
                  LOOP AT it_tab1 INTO wa_tab1 WHERE jicg GT 0.
*    JC = 'Y'.
                    tax1 = 'Y'.
                  ENDLOOP.
                  LOOP AT it_tab1 INTO wa_tab1 WHERE Jcis GT 0.
*    JCi = 'Y'.
                    tax1 = 'Y'.
                  ENDLOOP.

 data:ls_control TYPE ssfctrlop,
       ls_output  TYPE ssfcompop.
                  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
                    EXPORTING
                      formname           = 'ZPO'
*                     VARIANT            = ' '
*                     DIRECT_CALL        = ' '
                    IMPORTING
                      fm_name            = v_fm
                    EXCEPTIONS
                      no_form            = 1
                      no_function_module = 2
                      OTHERS             = 3.

                  CONCATENATE totword1 'ONLY' INTO totword1 SEPARATED BY space.

*  CALL FUNCTION v_fm
*    EXPORTING
**     control_parameters = control
**     user_settings    = 'X'
**     output_options   = w_ssfcompop
*      format           = format
*      objky            = nast-objky
*      potot            = potot
*      totword          = totword1
*      aedat            = aedat
*      lifnr            = lifnr
*      matkl            = matkl
*      ser              = ser
*      name1            = name1
*      name2            = name2
*      ort01            = ort01
*      stcd3            = stcd3
*      sc               = sc
*      addr2            = addr2
*      addr3            = addr3
*      addr4            = addr4
*      astcd3           = astcd3
*      asc              = asc
*      mfg              = mfg
*      pms              = pms
*      art              = art
*      jc               = jc
*      ji               = ji
*      jci              = jci
*      mfgr             = mfgr
*      deldt            = deldt
*      waers            = waers
*      tax1             = tax1
*      isd              = isd
*      imp              = imp
*      mat              = mat
*      muldel           = muldel
*    TABLES
*      it_tab1          = it_tab1
*      it_txt1          = it_txt1
*      it_txt2          = it_txt2
*      it_pterm1        = it_pterm1
*      it_del1          = it_del1
**     itab_division    = itab_division
**     itab_storage     = itab_storage
**     itab_pa0002      = itab_pa0002
*    EXCEPTIONS
*      formatting_error = 1
*      internal_error   = 2
*      send_error       = 3
*      user_canceled    = 4
*      OTHERS           = 5.
*   ls_control-getotf   = 'X'.
*   ls_control-preview  = 'X'.
*
*   CLEAR ls_output.
*  ls_output-tdnoprev = ''.
" Control parameters: two-pass generation
     " Allows preview
                  CALL FUNCTION v_fm "'/1BCDWB/SF00000075'
                    EXPORTING
*                     ARCHIVE_INDEX    =
*                     ARCHIVE_INDEX_TAB          =
*                     ARCHIVE_PARAMETERS         =
                    CONTROL_PARAMETERS         = ls_control
*                     MAIL_APPL_OBJ    =
*                     MAIL_RECIPIENT   =
*                     MAIL_SENDER      =
"                     OUTPUT_OPTIONS   = ls_output
                     USER_SETTINGS    = 'X'
                      format           = format
                      objky            = nast-objky
                      potot            = potot
                      totword          = totword1
                      aedat            = aedat
                      lifnr            = lifnr
                      matkl            = matkl
                      ser              = ser
                      name1            = name1
                      name2            = name2
                      ort01            = ort01
                      stcd3            = stcd3
                      sc               = sc
                      addr2            = addr2
                      addr3            = addr3
                      addr4            = addr4
                      astcd3           = astcd3
                      asc              = asc
                      mfg              = mfg
                      pms              = pms
                      art              = art
                      jc               = jc
                      ji               = ji
                      jci              = jci
                      mfgr             = mfgr
                      deldt            = deldt
                      waers            = waers
                      tax1             = tax1
                      isd              = isd
                      imp              = imp
                      mat              = mat
                      muldel           = muldel
                      lv_mfg           = lv_mfg
* IMPORTING
*                     DOCUMENT_OUTPUT_INFO       =
*                     JOB_OUTPUT_INFO  =
*                     JOB_OUTPUT_OPTIONS         =
                    TABLES
                      it_tab1          = it_tab1
                      it_txt1          = it_txt1
                      it_txt2          = it_txt2
                      it_pterm1        = it_pterm1
                      it_del1          = it_del1
                    EXCEPTIONS
                      formatting_error = 1
                      internal_error   = 2
                      send_error       = 3
                      user_canceled    = 4
                      OTHERS           = 5.
                  IF sy-subrc <> 0.
* Implement suitable error handling here
                  ENDIF.


                  CLEAR : it_tab1,wa_tab1,it_txt1,wa_txt1,it_txt2,wa_txt2,it_del1,wa_del1.
                  CLEAR: it_txt1,wa_txt1,it_pterm1,wa_pterm1.
                  REFRESH : it_txt1,t_lines,it_pterm1.
                  REFRESH : t_lines,it_txt1.

                  CLEAR : format,   potot, totword, aedat, lifnr, matkl, ser, name1, name2, ort01, stcd3, sc, addr2,addr3 ,addr4 ,
                      astcd3 , asc, mfg, pms, art , jc , ji , jci, mfgr  ,   deldt,  waers ,  tax1 ,   isd,imp.
**********ADDED ON 10.2.25 FOR SHUBHANGI TO GET PO PRINT STATUS BY JYOTSNA
                  DATA: zpo_print_wa TYPE zpo_print.
                  IF sy-ucomm EQ 'PRNT'.
*  BREAK-POINT .
                    zpo_print_wa-ebeln = nast-objky.
                    zpo_print_wa-budat = sy-datum.
                    zpo_print_wa-usnam = sy-uname.
                    zpo_print_wa-uzeit = sy-uzeit.
                    MODIFY zpo_print FROM zpo_print_wa.
                    CLEAR zpo_print_wa.
                  ENDIF.





*  CALL FUNCTION 'SSF_CLOSE'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  TAX
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*form tax .
*  clear : ven_reg, plt_reg, jiig_rate, jisg_rate, jicg_rate,jiig_val, jisg_val, jicg_val.
*
*  select single * from lfa1 where lifnr eq lifnr.
*  if sy-subrc eq 0.
*    ven_reg = lfa1-regio.
*  endif.
*  select single * from t001w where werks eq wa_ekpo-werks.
*  if sy-subrc eq 0.
*    plt_reg = t001w-regio.
*  endif.
*
*  if bsart eq 'ZL' .
**    or ekko-bsart eq 'ZS'.
*
*    select single * from a792 where kappl eq 'TX' and kschl eq 'JIIG' and lland eq 'IN' and regio eq ven_reg and wkreg eq plt_reg and
*      steuc eq wa_ekpo-j_1bnbm and datab le wa_ekpo-aedat and datbi ge wa_ekpo-aedat.
*    if sy-subrc eq 0.
*      select single * from konp where knumh eq a792-knumh and kappl eq 'TX' and kschl eq 'JIIG'.
*      if sy-subrc eq 0.
*        jiig_rate = konp-kbetr / 10.
*        jiig_val = wa_ekpo-netwr * ( jiig_rate / 100 ).
*      endif.
*    else.
*      select single * from a792 where kappl eq 'TX' and kschl eq 'JISG' and lland eq 'IN' and regio eq ven_reg and wkreg eq plt_reg and
*                     steuc eq wa_ekpo-j_1bnbm and datab le wa_ekpo-aedat and datbi ge wa_ekpo-aedat.
*      if sy-subrc eq 0.
*        select single * from konp where knumh eq a792-knumh and kappl eq 'TX' and kschl eq 'JISG'.
*        if sy-subrc eq 0.
*          jisg_rate = konp-kbetr / 10.
*          jisg_val = wa_ekpo-netwr * ( jisg_rate / 100 ).
*        endif.
*      endif.
*      select single * from a792 where kappl eq 'TX' and kschl eq 'JICG' and lland eq 'IN' and regio eq ven_reg and wkreg eq plt_reg and
*                     steuc eq wa_ekpo-j_1bnbm and datab le wa_ekpo-aedat and datbi ge wa_ekpo-aedat.
*      if sy-subrc eq 0.
*        select single * from konp where knumh eq a792-knumh and kappl eq 'TX' and kschl eq 'JICG'.
*        if sy-subrc eq 0.
*          jicg_rate = konp-kbetr / 10.
*          jicg_val = wa_ekpo-netwr * ( jicg_rate / 100 ).
*        endif.
*      endif.
*    endif.
*
*  elseif  bsart eq 'ZS'.
*
*
*    select single * from a003 where kappl eq 'TX' and kschl eq 'JIIG' and aland eq 'IN' and mwskz eq wa_ekpo-mwskz.
*    if sy-subrc eq 0.
*      select single * from konp where knumh eq a003-knumh and kappl eq 'TX' and kschl eq 'JIIG'.
*      if sy-subrc eq 0.
*        jiig_rate = konp-kbetr / 10.
*        jiig_val = wa_ekpo-netwr * ( jiig_rate / 100 ).
*      endif.
*    else.
*      select single * from a003 where kappl eq 'TX' and kschl eq 'JISG' and aland eq 'IN' and mwskz eq wa_ekpo-mwskz.
*      if sy-subrc eq 0.
*        select single * from konp where knumh eq a003-knumh and kappl eq 'TX' and kschl eq 'JISG'.
*        if sy-subrc eq 0.
*          jisg_rate = konp-kbetr / 10.
*          jisg_val = wa_ekpo-netwr * ( jisg_rate / 100 ).
*        endif.
*      endif.
*      select single * from a003 where kappl eq 'TX' and kschl eq 'JICG' and aland eq 'IN' and mwskz eq wa_ekpo-mwskz.
*      if sy-subrc eq 0.
*        select single * from konp where knumh eq a003-knumh and kappl eq 'TX' and kschl eq 'JICG'.
*        if sy-subrc eq 0.
*          jicg_rate = konp-kbetr / 10.
*          jicg_val = wa_ekpo-netwr * ( jicg_rate / 100 ).
*        endif.
*      endif.
*    endif.
*
*    if ( jicg_val + jisg_val + jiig_val ) le 0.
*
*      select single * from a792 where kappl eq 'TX' and kschl eq 'JIIG' and lland eq 'IN' and regio eq ven_reg and wkreg eq plt_reg and
*         steuc eq wa_ekpo-j_1bnbm and datab le wa_ekpo-aedat and datbi ge wa_ekpo-aedat.
*      if sy-subrc eq 0.
*        select single * from konp where knumh eq a792-knumh and kappl eq 'TX' and kschl eq 'JIIG'.
*        if sy-subrc eq 0.
*          jiig_rate = konp-kbetr / 10.
*          jiig_val = wa_ekpo-netwr * ( jiig_rate / 100 ).
*        endif.
*      else.
*        select single * from a792 where kappl eq 'TX' and kschl eq 'JISG' and lland eq 'IN' and regio eq ven_reg and wkreg eq plt_reg and
*                       steuc eq wa_ekpo-j_1bnbm and datab le wa_ekpo-aedat and datbi ge wa_ekpo-aedat.
*        if sy-subrc eq 0.
*          select single * from konp where knumh eq a792-knumh and kappl eq 'TX' and kschl eq 'JISG'.
*          if sy-subrc eq 0.
*            jisg_rate = konp-kbetr / 10.
*            jisg_val = wa_ekpo-netwr * ( jisg_rate / 100 ).
*          endif.
*        endif.
*        select single * from a792 where kappl eq 'TX' and kschl eq 'JICG' and lland eq 'IN' and regio eq ven_reg and wkreg eq plt_reg and
*                       steuc eq wa_ekpo-j_1bnbm and datab le wa_ekpo-aedat and datbi ge wa_ekpo-aedat.
*        if sy-subrc eq 0.
*          select single * from konp where knumh eq a792-knumh and kappl eq 'TX' and kschl eq 'JICG'.
*          if sy-subrc eq 0.
*            jicg_rate = konp-kbetr / 10.
*            jicg_val = wa_ekpo-netwr * ( jicg_rate / 100 ).
*          endif.
*        endif.
*      endif.
*
*    endif.
*
*
*
*  elseif bsart eq 'ZNIV' or bsart eq 'ZSER'.
**      IF wa_ekpo-matnr GE '000000000000900000'.
*    if wa_ekpo-matnr ne space.
*      select single * from a792 where kappl eq 'TX' and kschl eq 'JIIG' and lland eq 'IN' and regio eq ven_reg and wkreg eq plt_reg and
*steuc eq wa_ekpo-j_1bnbm and datab le wa_ekpo-aedat and datbi ge wa_ekpo-aedat.
*      if sy-subrc eq 0.
*        select single * from konp where knumh eq a792-knumh and kappl eq 'TX' and kschl eq 'JIIG'.
*        if sy-subrc eq 0.
*          jiig_rate = konp-kbetr / 10.
*          jiig_val = wa_ekpo-netwr * ( jiig_rate / 100 ).
*        endif.
*      else.
*        select single * from a792 where kappl eq 'TX' and kschl eq 'JISG' and lland eq 'IN' and regio eq ven_reg and wkreg eq plt_reg and
*                       steuc eq wa_ekpo-j_1bnbm and datab le wa_ekpo-aedat and datbi ge wa_ekpo-aedat.
*        if sy-subrc eq 0.
*          select single * from konp where knumh eq a792-knumh and kappl eq 'TX' and kschl eq 'JISG'.
*          if sy-subrc eq 0.
*            jisg_rate = konp-kbetr / 10.
*            jisg_val = wa_ekpo-netwr * ( jisg_rate / 100 ).
*          endif.
*        endif.
*        select single * from a792 where kappl eq 'TX' and kschl eq 'JICG' and lland eq 'IN' and regio eq ven_reg and wkreg eq plt_reg and
*                       steuc eq wa_ekpo-j_1bnbm and datab le wa_ekpo-aedat and datbi ge wa_ekpo-aedat.
*        if sy-subrc eq 0.
*          select single * from konp where knumh eq a792-knumh and kappl eq 'TX' and kschl eq 'JICG'.
*          if sy-subrc eq 0.
*            jicg_rate = konp-kbetr / 10.
*            jicg_val = wa_ekpo-netwr * ( jicg_rate / 100 ).
*          endif.
*        endif.
*      endif.
*    else.
*      select single * from a796 where kappl eq 'TX' and kschl eq 'JIIG' and regio eq ven_reg and wkreg eq plt_reg and
*          steuc eq wa_ekpo-j_1bnbm and matkl eq wa_ekpo-matkl and datab le wa_ekpo-aedat and datbi ge wa_ekpo-aedat.
*      if sy-subrc eq 0.
*        select single * from konp where knumh eq a796-knumh and kappl eq 'TX' and kschl eq 'JIIG'.
*        if sy-subrc eq 0.
*          jiig_rate = konp-kbetr / 10.
*          jiig_val = wa_ekpo-netwr * ( jiig_rate / 100 ).
*        endif.
*      else.
*        select single * from a796 where kappl eq 'TX' and kschl eq 'JISG' and regio eq ven_reg and wkreg eq plt_reg and
*                       steuc eq wa_ekpo-j_1bnbm and matkl eq wa_ekpo-matkl and datab le wa_ekpo-aedat and datbi ge wa_ekpo-aedat.
*        if sy-subrc eq 0.
*          select single * from konp where knumh eq a796-knumh and kappl eq 'TX' and kschl eq 'JISG'.
*          if sy-subrc eq 0.
*            jisg_rate = konp-kbetr / 10.
*            jisg_val = wa_ekpo-netwr * ( jisg_rate / 100 ).
*          endif.
*        endif.
*        select single * from a796 where kappl eq 'TX' and kschl eq 'JICG' and regio eq ven_reg and wkreg eq plt_reg and
*                       steuc eq wa_ekpo-j_1bnbm and matkl eq wa_ekpo-matkl and datab le wa_ekpo-aedat and datbi ge wa_ekpo-aedat.
*        if sy-subrc eq 0.
*          select single * from konp where knumh eq a796-knumh and kappl eq 'TX' and kschl eq 'JICG'.
*          if sy-subrc eq 0.
*            jicg_rate = konp-kbetr / 10.
*            jicg_val = wa_ekpo-netwr * ( jicg_rate / 100 ).
*          endif.
*        endif.
********************* cess condition*********************
*        select single * from a796 where kappl eq 'TX' and kschl eq 'JCIS' and regio eq ven_reg and wkreg eq plt_reg and
*                    steuc eq wa_ekpo-j_1bnbm and datab le wa_ekpo-aedat and datbi ge wa_ekpo-aedat.
*        if sy-subrc eq 0.
*          select single * from konp where knumh eq a796-knumh and kappl eq 'TX' and kschl eq 'JCIS'.
*          if sy-subrc eq 0.
*            jcis_rate = konp-kbetr / 10.
*            jcis_val = wa_ekpo-netwr * ( jcis_rate / 100 ).
*          endif.
*        endif.
*      endif.
*    endif.
*  endif.
*  wa_tab1-jiigrt = jiig_rate.
*  wa_tab1-jicgrt = jicg_rate.
*  wa_tab1-jisgrt = jisg_rate.
*  wa_tab1-jcisrt = jcis_rate.
*
*  wa_tab1-jiig = jiig_val.
*  wa_tab1-jisg = jisg_val.
*  wa_tab1-jicg = jicg_val.
*  wa_tab1-jcis = jcis_val.
*
*  clear : ji,jc,jci.
*  if jiig_val gt 0.
*    ji = 'Y'.
*  endif.
*  if jicg_val gt 0.
*    jc = 'Y'.
*  endif.
*  if jcis_val gt 0.
*    jci = 'Y'.
*  endif.
*
*  condense : wa_tab1-jiigrt,wa_tab1-jicgrt,wa_tab1-jisgrt,wa_tab1-jcisrt.
**  wa_tab1-jiig,wa_tab1-jisg,wa_tab1-jicg,wa_tab1-jcis.
*
*endform.
*&---------------------------------------------------------------------*
*&      Form  GSTNNO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM gstnno .
  CLEAR : isd.
  SELECT SINGLE * FROM t001w WHERE werks EQ wa_ekpo-werks.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM kna1 WHERE kunnr EQ t001w-kunnr.
        IF sy-subrc EQ 0.
          IF wa_ekpo-matkl EQ 'SERVISD' AND t001w-kunnr EQ 'BCL3000'.
            astcd3 = '27AAACB1549G2ZW'.
            isd = 'Y'.
*          ************new condition added on 4.10.22**************
          ELSEIF ekko-bsart EQ  'ZSRV'  AND wa_ekpo-matkl EQ 'SERV' AND  t001w-kunnr EQ 'BCL3000' AND ekko-aedat GE '20230718'.  "18.7.23, EFFECTIVE FROM 1.7.23
*          or t001w-kunnr eq 'NASIK' or t001w-kunnr eq 'DINDORI' or t001w-kunnr eq 'DINDORI-2' or t001w-kunnr eq 'DINDORI-3' )

*          GSTNNO = '27AAACB1549G2ZW'.
***************************************************************************
            isd = 'Y'.
            astcd3 = '27AAACB1549G2ZW'.
          ELSEIF ekko-bsart EQ 'ZSRV' AND wa_ekpo-matkl EQ 'SERV' AND ( t001w-kunnr EQ 'BCL3000' OR t001w-kunnr EQ 'BCL1000'
         OR t001w-kunnr EQ 'DINDORI' OR t001w-kunnr EQ 'DINDORI-2' OR t001w-kunnr EQ 'DINDORI-3' )  AND
            ( ekko-aedat GE '20220901'  AND  ekko-aedat LT '20230718' ).  "4.10.22, EFFECTIVE FROM 1.9.22
*          GSTNNO = '27AAACB1549G2ZW'.
***************************************************************************
            isd = 'Y'.
            astcd3 = '27AAACB1549G2ZW'.
          ELSE.
            astcd3 = kna1-stcd3.
          ENDIF.
*       GSTNNO = kna1-stcd3.
        ENDIF.
      ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ORITAX
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM oritax .
  DATA :tkomv  TYPE STANDARD TABLE OF komv,
        tkomvd TYPE STANDARD TABLE OF komvd,
        t_konv TYPE STANDARD TABLE OF prcd_elements,
        xkomv  TYPE STANDARD TABLE OF komv.

  DATA : wa_t005 TYPE t005.
  DATA : me_copypo.

  CLEAR ls_taxcom.
  SELECT SINGLE * FROM t001 WHERE bukrs EQ ekko-bukrs.

    DELETE it_ekpo WHERE loekz IS NOT INITIAL.

    CLEAR : ls_taxcom.
    REFRESH lt_komv[].

    CALL FUNCTION 'ZIND_PO_TAX'
      EXPORTING
        i_ebeln             = wa_ekpo-ebeln
        i_ebelp             = wa_ekpo-ebelp
      TABLES
        it_komv             = lt_komv
      EXCEPTIONS
        mwskz_not_defined   = 1
        mwskz_no            = 2
        mwskz_not_found     = 3
        mwskz_not_valid     = 4
        steuerbetrag_falsch = 5
        country_not_found   = 6
        OTHERS              = 7.
    IF sy-subrc = 0.

      CLEAR : jiig_rate, jisg_rate, jicg_rate,jiig_val, jisg_val, jicg_val, jcis_rate,jcis_val, tax.


      READ TABLE lt_komv INTO lw_komv WITH KEY kposn = wa_ekpo-ebelp kschl = 'JICG'.
      IF sy-subrc EQ 0.
        jicg_rate = lw_komv-kbetr / 10.
        jicg_val = lw_komv-kwert.
      ENDIF.

      READ TABLE lt_komv INTO lw_komv WITH KEY kposn = wa_ekpo-ebelp kschl = 'JISG'.
      IF sy-subrc EQ 0.
        jisg_rate = lw_komv-kbetr / 10.
        jisg_val = lw_komv-kwert.
      ENDIF.

      READ TABLE lt_komv INTO lw_komv WITH KEY kposn = wa_ekpo-ebelp kschl = 'JIIG'.
      IF sy-subrc EQ 0.
        jiig_rate = lw_komv-kbetr / 10.
        jiig_val = lw_komv-kwert.
      ENDIF.

      READ TABLE lt_komv INTO lw_komv WITH KEY kposn = wa_ekpo-ebelp kschl = 'JCIS'.
      IF sy-subrc EQ 0.
        jcis_rate = lw_komv-kbetr / 10.
        jcis_val = lw_komv-kwert.
      ENDIF.

      IF wa_ekpo-retpo EQ 'X'.
        jiig_rate = jiig_rate * ( - 1 ).
        jicg_rate = jicg_rate * ( - 1 ).
        jisg_rate = jisg_rate * ( - 1 ).
        jcis_rate = jcis_rate * ( - 1 ).

        jiig_val = jiig_val * ( - 1 ).
        jisg_val = jisg_val * ( - 1 ).
        jicg_val = jicg_val * ( - 1 ).
        jcis_val = jcis_val * ( - 1 ).
      ENDIF.

      wa_tab1-jiigrt = jiig_rate.
      wa_tab1-jicgrt = jicg_rate.
      wa_tab1-jisgrt = jisg_rate.
      wa_tab1-jcisrt = jcis_rate.

      wa_tab1-jiig = jiig_val.
      wa_tab1-jisg = jisg_val.
      wa_tab1-jicg = jicg_val.
      wa_tab1-jcis = jcis_val.

      tax = jiig_val + jisg_val + jicg_val + jcis_val.

      CLEAR : ji,jc,jci.
      IF jiig_val NE 0.
        ji = 'Y'.
      ENDIF.
      IF jicg_val NE 0.
        jc = 'Y'.
      ENDIF.
*    if jcis_val gt 0.
      IF jcis_val NE 0.
        jci = 'Y'.
      ENDIF.
      CONDENSE : wa_tab1-jiigrt,wa_tab1-jicgrt,wa_tab1-jisgrt,wa_tab1-jcisrt.
*    wa_tab1-jiig,wa_tab1-jisg,wa_tab1-jicg,wa_tab1-jcis.
    ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DELDT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM deldt .
*  clear : deldt.
**********************delivery date***********
*  clear : it_eket,wa_eket,deldt,muldel.
*  select * from eket into table it_eket where ebeln eq ekko-ebeln.
*  read table it_eket into wa_eket with key ebeln = ekko-ebeln.
*  if sy-subrc eq 0.
*    deldt = wa_eket-eindt.
*  endif.
*  loop at it_eket into wa_eket where ebeln eq ekko-ebeln and eindt ne deldt.
*    muldel = 'Y'.
*  endloop.
*  break-point .

  LOOP AT it_eket INTO wa_eket WHERE ebeln = wa_ekpo-ebeln AND ebelp = wa_ekpo-ebelp.
*    break-point.
    wa_del1-ebeln = wa_eket-ebeln.
    wa_del1-ebelp = wa_eket-ebelp.
    wa_del1-etenr = wa_eket-etenr.
    wa_del1-qty = wa_eket-menge.
    wa_del1-meins = wa_ekpo-meins.
    wa_del1-deldt = wa_eket-eindt.
    COLLECT wa_del1 INTO it_del1.
    CLEAR wa_del1.
  ENDLOOP.
  SORT it_del1 BY ebeln ebelp deldt.  "added on 11.4.24
ENDFORM.
