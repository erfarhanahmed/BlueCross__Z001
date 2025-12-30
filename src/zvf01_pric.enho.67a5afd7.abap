"Name: \PR:SAPLV60A\FO:USEREXIT_PRICING_PREPARE_TKOMK\SE:BEGIN\EI
ENHANCEMENT 0 ZVF01_PRIC.
*
  IF sy-tcode = 'VF01' OR sy-tcode = 'VF02'.
  DATA: wa_vbrp LIKE vbrp.
  DATA: mess TYPE string.
  DATA: wa_a602d LIKE a602.
  DATA: wa_konpd LIKE konp.
  DATA: wa_vbakd LIKE vbak.
  CLEAR: wa_a602d, wa_konpd, wa_vbakd.
*  MOVE : i_xaccit_deb TO e_xaccit_deb.
  SELECT SINGLE * FROM vbak INTO wa_vbakd WHERE vbeln = vbrp-vgbel.
  IF sy-subrc = 0.
    IF wa_vbakd-auart = 'ZCR'.
      SELECT SINGLE * FROM a602 INTO wa_a602d WHERE kappl = 'V'
                                              AND matnr = vbrp-matnr
                                              AND charg = vbrp-charg
                                              AND vkorg = vbrp-vkorg_auft
                                              AND kschl = 'Z001'
                                              AND datab <= sy-datum
                                              AND datbi >= sy-datum .

      IF sy-subrc = 0.

        SELECT SINGLE * FROM konp INTO wa_konpd WHERE knumh = wa_a602d-knumh
                                   AND loevm_ko NE 'X'.
        IF sy-subrc = 0.

          IF wa_konpd-kbetr IS INITIAL.
            CONCATENATE 'Maintain value for the key combination Sales org./Material/Batch for'
           vbrp-vkorg_auft '/' vbrp-matnr '/' vbrp-charg
             INTO  mess SEPARATED BY space.
            MESSAGE  mess TYPE 'E'.
          ENDIF.

        ELSE.
          CONCATENATE 'Maintain value for the key combination Sales org./Material/Batch for'  vbrp-vkorg_auft
     '/' vbrp-matnr '/' vbrp-charg  INTO  mess SEPARATED BY space.
          MESSAGE  mess TYPE 'E'.
        ENDIF.

      ELSE.

        CONCATENATE 'Maintain value for the key combination Sales org./Material/Batch for'  vbrp-vkorg_auft
         '/' vbrp-matnr '/' vbrp-matnr '/' vbrp-charg  INTO  mess SEPARATED BY space.
        MESSAGE  mess TYPE 'E'.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.



ENDENHANCEMENT.
