*&---------------------------------------------------------------------*
*& Report  ZR_DELIVERY
*&---------------------------------------------------------------------*
REPORT zr_delivery
NO STANDARD PAGE HEADING.

TABLES : vbfa, vbrk.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE t1.
PARAMETERS : p_vbeln TYPE vbfa-vbeln.
SELECTION-SCREEN END OF BLOCK b1.

TYPES : BEGIN OF ty_final,
          vbeln   TYPE likp-vbeln,
          lfart   TYPE likp-lfart,
          fkstk   TYPE vbuk-fkstk,
          gbstk   TYPE vbuk-gbstk,
          vbtyp_n TYPE vbfa-vbtyp_n,
          plmin   TYPE vbfa-plmin,
          rfbsk   TYPE vbrk-rfbsk,
        END OF ty_final.

DATA : it_final TYPE TABLE OF ty_final,
       wa_final TYPE ty_final.

START-OF-SELECTION.

  SELECT vbeln,
         lfart
    FROM likp INTO TABLE @DATA(gt_likp)
    WHERE vbeln EQ @p_vbeln
      AND lfart EQ 'NL'.

  IF sy-subrc EQ 0.

    SELECT  vbeln,
            fkstk,
            gbstk
      FROM vbuk INTO TABLE @DATA(gt_vbuk)
      FOR ALL ENTRIES IN @gt_likp
      WHERE vbeln EQ @gt_likp-vbeln
        AND fkstk EQ 'C'
        AND gbstk EQ 'C'.

    SELECT vbelv,
           vbeln,
           vbtyp_n,
           plmin
      FROM vbfa INTO TABLE @DATA(gt_vbfa)
      FOR ALL ENTRIES IN @gt_likp
      WHERE vbelv EQ @gt_likp-vbeln
      AND   vbtyp_n = 'U'
      AND   plmin   = '+'.

    SELECT vbeln,
           rfbsk
      FROM vbrk  INTO TABLE @DATA(gt_vbrk)
      FOR ALL ENTRIES IN @gt_likp
      WHERE vbeln EQ @gt_likp-vbeln
        AND rfbsk = 'E'.
  ENDIF.

  LOOP AT gt_likp INTO DATA(gs_likp).

    wa_final-vbeln = gs_likp-vbeln.
    wa_final-lfart = gs_likp-lfart.

    READ TABLE gt_vbuk INTO DATA(gs_vbuk) WITH KEY vbeln = gs_likp-vbeln.

    IF sy-subrc EQ 0.
      wa_final-fkstk = gs_vbuk-fkstk.
      wa_final-gbstk = gs_vbuk-gbstk.
    ENDIF.

    READ TABLE gt_vbfa INTO DATA(gs_vbfa) WITH KEY vbeln = gs_likp-vbeln.
    IF sy-subrc EQ 0.
      wa_final-vbtyp_n = gs_vbfa-vbtyp_n.
      wa_final-plmin   = gs_vbfa-plmin.
    ENDIF.

    READ TABLE gt_vbrk INTO DATA(gs_vbrk) WITH KEY vbeln = gs_likp-vbeln.
    IF sy-subrc EQ 0.
      wa_final-rfbsk = gs_vbrk-rfbsk.
    ENDIF.
    APPEND wa_final TO it_final.

     IF WA_FINAL-LFART EQ 'NL' AND WA_FINAL-FKSTK = 'C' AND WA_FINAL-GBSTK = 'C' .

    update vbfa set plmin = '0' where vbtyp_n = 'U' AND VBELV EQ P_VBELN.

      IF SY-SUBRC EQ 0.
        MESSAGE 'Successfully Changed for Delivery No:wa_final-vbeln' type 'I'.
      ENDIF.
    ENDIF.

    CLEAR wa_final.
  ENDLOOP.
