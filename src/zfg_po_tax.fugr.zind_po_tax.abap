FUNCTION ZIND_PO_TAX.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_EBELN) TYPE  EBELN
*"     REFERENCE(I_EBELP) TYPE  EBELP
*"  TABLES
*"      IT_KOMV STRUCTURE  KOMV
*"  EXCEPTIONS
*"      MWSKZ_NOT_DEFINED
*"      MWSKZ_NO
*"      MWSKZ_NOT_FOUND
*"      MWSKZ_NOT_VALID
*"      STEUERBETRAG_FALSCH
*"      COUNTRY_NOT_FOUND
*"----------------------------------------------------------------------

  DATA : w_item6(6),w_ebelp5(5).
  DATA: BEGIN OF wa_ekko ,
          bedat LIKE  ekko-bedat,
          bukrs LIKE  ekko-bukrs,
          waers LIKE  ekko-waers,
          bstyp LIKE  ekko-bstyp,
          lifnr LIKE  ekko-lifnr,
          lands LIKE  ekko-lands,
          ekorg LIKE  ekko-ekorg,
          llief LIKE  ekko-llief,
          kalsm LIKE  ekko-kalsm,
        END  OF  wa_ekko.
  DATA :BEGIN OF it_ekpo OCCURS 0,
          ebelp LIKE ekpo-ebelp,
          mwskz LIKE ekpo-mwskz,
          bukrs LIKE ekpo-bukrs,
          txjcd LIKE ekpo-txjcd,
          netwr LIKE ekpo-netwr,
          zwert LIKE ekpo-zwert,
          werks LIKE ekpo-werks,
          matnr LIKE ekpo-matnr,
          bwtar LIKE ekpo-bwtar,
          matkl LIKE ekpo-matkl,
          meins LIKE ekpo-meins,
          menge LIKE ekpo-menge,
          abmng LIKE ekpo-abmng,
          ktmng LIKE ekpo-ktmng,
          mtart LIKE ekpo-mtart,
        END OF it_ekpo.


  DATA : wa_ekpo LIKE it_ekpo.
  DATA wa_taxcom LIKE taxcom.
  DATA :it_xkomv LIKE komv OCCURS 0 WITH HEADER LINE.
  DATA :it_xkomv1 LIKE komv OCCURS 0 WITH HEADER LINE.

  REFRESH it_ekpo.
  CLEAR  :it_ekpo,
          wa_ekpo,
          wa_taxcom.

***21.09.2021
  DATA: lv_gst_rele TYPE char1,
        me_copypo   TYPE REF TO if_ex_me_cin_mm06efko,
        ls_ekpo     TYPE ekpo,
        ls_ekko     TYPE ekko.
  DATA lo_gst_service_purchasing TYPE REF TO j_1icl_gst_service_purchasing.
***21.09.2021
  SELECT SINGLE  bedat bukrs waers bstyp lifnr lands ekorg llief kalsm
    INTO CORRESPONDING FIELDS OF wa_ekko
    FROM ekko
    WHERE ebeln = i_ebeln.
  IF sy-subrc <> 0.
    MESSAGE e001(ztsl).
  ENDIF.
*maktl
  IF NOT i_ebelp IS INITIAL.
    SELECT ebelp  mwskz bukrs txjcd netwr zwert werks matnr bwtar matkl meins menge abmng ktmng  mtart
        FROM ekpo
     INTO CORRESPONDING FIELDS OF TABLE it_ekpo
     WHERE ebeln = i_ebeln AND
           ebelp = i_ebelp AND
           loekz NOT IN ('L','S').
  ELSE.
    SELECT ebelp  mwskz bukrs txjcd netwr zwert werks matnr bwtar
   matkl meins menge abmng ktmng  mtart
   FROM ekpo
   INTO CORRESPONDING FIELDS OF TABLE it_ekpo
    WHERE ebeln = i_ebeln AND
          loekz NOT IN ('L','S').

  ENDIF.

  SELECT ebeln,ebelp,prctr,kokrs FROM ekkn INTO TABLE @DATA(lt_ekkn) WHERE ebeln = @i_ebeln.
  SELECT SINGLE * FROM ekko INTO @DATA(ls_fekko) WHERE ebeln = @i_ebeln.
  SELECT SINGLE * FROM ekpo INTO @DATA(ls_fekpo) WHERE ebeln = @i_ebeln AND ebelp = @i_ebelp.

  LOOP AT it_ekpo INTO wa_ekpo.
    CLEAR: wa_taxcom.
    IF wa_ekpo-mwskz NE space.
      CLEAR wa_taxcom.
      wa_taxcom-bukrs = wa_ekpo-bukrs.
      wa_taxcom-budat = wa_ekko-bedat.
      wa_taxcom-waers = wa_ekko-waers.
      wa_taxcom-kposn = wa_ekpo-ebelp.
      wa_taxcom-mwskz = wa_ekpo-mwskz.
      wa_taxcom-txjcd = wa_ekpo-txjcd.
      wa_taxcom-shkzg = 'H'.
      wa_taxcom-xmwst = 'X'.
*      IF wa_ekko-bstyp EQ bstyp-best.
      wa_taxcom-wrbtr = wa_ekpo-netwr.
*      ELSE.
*        wa_taxcom-wrbtr = wa_ekpo-zwert.

      wa_taxcom-lifnr = wa_ekko-lifnr.
      wa_taxcom-land1 = wa_ekko-lands.                              "WIA
      wa_taxcom-ekorg = wa_ekko-ekorg.
      wa_taxcom-hwaer = wa_ekko-waers.
      wa_taxcom-llief = wa_ekko-llief.
      wa_taxcom-bldat = wa_ekko-bedat.
      wa_taxcom-matnr = wa_ekpo-matnr.         "HTN-Abwicklung
      wa_taxcom-werks = wa_ekpo-werks.
      wa_taxcom-bwtar = wa_ekpo-bwtar.
      wa_taxcom-matkl = wa_ekpo-matkl.
      IF wa_ekpo-meins EQ 'LE' .
        wa_taxcom-meins = 'AU'.
      ELSE.
        wa_taxcom-meins = wa_ekpo-meins.
      ENDIF .
      IF wa_ekko-bstyp EQ 'A'.
        wa_taxcom-wrbtr = wa_ekpo-zwert.
      ELSE.
        wa_taxcom-wrbtr = wa_ekpo-netwr.
      ENDIF.

*- Mengen richtig fuellen
*      ---------------------------------------------*
      IF wa_ekko-bstyp EQ 'F'."Purchase Order
        wa_taxcom-mglme = wa_ekpo-menge.
      ELSE.
        IF wa_ekko-bstyp EQ 'K' AND wa_ekpo-abmng GT 0.
          wa_taxcom-mglme = wa_ekpo-abmng.
        ELSE.
          wa_taxcom-mglme = wa_ekpo-ktmng.
        ENDIF.
      ENDIF.
      IF wa_taxcom-mglme EQ 0.
        "falls keine Menge gesetzt --> auf 1 setzen
        wa_taxcom-mglme = 1000.
      ENDIF.
      wa_taxcom-mtart = wa_ekpo-mtart.

      wa_taxcom-ebeln = i_ebeln.
      wa_taxcom-ebelp = i_ebelp.
      READ TABLE lt_ekkn INTO DATA(ls_ekkn) WITH KEY ebeln = i_ebeln ebelp = i_ebelp.
      IF sy-subrc = 0.
        wa_taxcom-prctr = ls_ekkn-prctr.
        wa_taxcom-kokrs = ls_ekkn-kokrs.
      ENDIF.
      CLEAR wa_taxcom-land1.

      MOVE-CORRESPONDING: ls_fekko TO ls_ekko,
                          ls_fekpo TO ls_ekpo.

      CALL FUNCTION 'J_1BSA_COMPONENT_ACTIVE'
        EXPORTING
          bukrs                = ls_fekko-bukrs
          component            = 'IN'
        EXCEPTIONS
          component_not_active = 1
          OTHERS               = 2.
      IF sy-subrc IS INITIAL.

        CALL METHOD cl_exithandler=>get_instance
          EXPORTING
            exit_name              = 'ME_CIN_MM06EFKO'
            null_instance_accepted = 'X'
          CHANGING
            instance               = me_copypo.

        IF NOT me_copypo IS INITIAL.
          CALL METHOD me_copypo->me_cin_copy_po_data
            EXPORTING
              flt_val = 'IN'
              y_ekpo  = ls_fekpo.
        ENDIF.

*** GST India ---------------------------------------------------------------*
***Check if Company Code Country is India
        CALL FUNCTION 'J_1BSA_COMPONENT_ACTIVE'
          EXPORTING
            bukrs                = ls_fekko-bukrs
            component            = 'IN'
          EXCEPTIONS
            component_not_active = 1
            OTHERS               = 2.
        IF sy-subrc EQ 0.
          DATA:im_gst_rele TYPE char1.
          CLEAR im_gst_rele.
          CALL FUNCTION 'J_1IG_DATE_CHECK'
            IMPORTING
              ex_gst_rele = im_gst_rele.
          IF im_gst_rele EQ 'X'.
*          PASS EKKO and EKPO to pricing
            CALL FUNCTION 'J_1IG_PASS_EKKO_EKPO'
              EXPORTING
                im_ekko = ls_ekko
                im_ekpo = ls_ekpo.
*** Begin of note 2444868
            lo_gst_service_purchasing = j_1icl_gst_service_purchasing=>get_instance( ).
            lo_gst_service_purchasing->extend_mm06efko_kond_taxes( ls_ekpo ).
*** End of note 2444868
          ENDIF.
        ENDIF.
*** GST India ---------------------------------------------------------------*
      ENDIF.

      CALL FUNCTION 'CALCULATE_TAX_ITEM'
        EXPORTING
          i_taxcom            = wa_taxcom
        TABLES
          t_xkomv             = it_xkomv
        EXCEPTIONS
          mwskz_not_defined   = 1
          mwskz_not_found     = 2
          mwskz_not_valid     = 3
          steuerbetrag_falsch = 4
          country_not_found   = 5
          OTHERS              = 6.
      IF sy-subrc <> 0.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
        RAISE error_in_function_module.
      ENDIF.
    ENDIF.
  ENDLOOP.
******CODE ADDED BY WILSON ON 11.07.2014 REQ BY BELINDA
  LOOP AT it_xkomv .
    READ TABLE it_xkomv1 WITH KEY kschl = it_xkomv-kschl
                                   kposn = it_xkomv-kposn.
    IF sy-subrc <> 0.
      APPEND it_xkomv TO it_xkomv1.
    ENDIF.
    CLEAR it_xkomv.
  ENDLOOP.
  it_xkomv[] = it_xkomv1[].
************END OF CODE ADED BY WILSON
  SELECT SINGLE MAX( ebelp ) FROM ekpo INTO w_ebelp5 WHERE ebeln EQ i_ebeln.
  w_item6 = w_ebelp5.
  CONCATENATE '0' w_ebelp5 INTO w_item6.
*  loop at it_xkomv.
  DELETE it_xkomv WHERE kposn GT w_item6.
*  endloop.
  CLEAR : w_ebelp5,w_item6.
  it_komv[] = it_xkomv[].

ENDFUNCTION.
