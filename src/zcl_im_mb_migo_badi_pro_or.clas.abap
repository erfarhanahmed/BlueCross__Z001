class ZCL_IM_MB_MIGO_BADI_PRO_OR definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_MB_MIGO_BADI .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_MB_MIGO_BADI_PRO_OR IMPLEMENTATION.


  method IF_EX_MB_MIGO_BADI~CHECK_HEADER.
  endmethod.


  method IF_EX_MB_MIGO_BADI~CHECK_ITEM.

    BREAK CTPLGW.
**  ***** Restrict tcode MB1A against irrelevant production order** by Jyotsna on 11.4.2019 **********
**  TABLES : zmrn,
**    zmb1a.
*
*  DATA : zmatnr   TYPE aufm-matnr,
*        zcharg   TYPE aufm-charg,
*        lgort    TYPE mseg-lgort,
*        lwa_afpo TYPE afpo.
*  IF sy-tcode EQ 'MIGO'.
*
**    IF cobl-bwart EQ 'Y01' OR cobl-bwart EQ 'Y02'.
*    IF I_LINE_ID-BWART EQ 'Y01' OR I_LINE_ID-BWART EQ 'Y02'.
*      MESSAGE 'THIS MOVEMENT IS NOT POSSIBLE' TYPE 'E'.
*    ENDIF.
*
*    IF cobl-aufnr IS NOT INITIAL.
*      IF cobl-bwart EQ '262'.
*        IF mseg-matnr IS NOT INITIAL.
*          CLEAR : zmatnr,zcharg.
*          zmatnr = mseg-matnr.
*          zcharg = mseg-charg.
*
*          SELECT SINGLE matnr charg FROM aufm INTO (zmatnr, zcharg) WHERE aufnr EQ cobl-aufnr AND matnr = mseg-matnr AND charg = mseg-charg.
*          IF sy-subrc EQ 4.
**        BREAK-POINT.
*            MESSAGE 'INVALID ORDER' TYPE 'E'.
*          ENDIF.
*        ENDIF.
***************************MRN CHECKING***********************
**************mrn1 mandatory for mrn material  3.12.21
*        CLEAR : lgort.
*        SELECT SINGLE * FROM zmrn WHERE pmmatnr EQ mseg-matnr AND werks EQ mseg-werks.
*        IF sy-subrc EQ 0.
*          SELECT SINGLE * FROM afpo INTO lwa_afpo WHERE aufnr EQ cobl-aufnr.
*          IF sy-subrc EQ 0.
*            lgort = lwa_afpo-lgort.
*          ENDIF.
*          IF lgort EQ 'FG04'.
*            IF mseg-lgort NE 'MRN4'.
*              IF sy-datum GE '20220401'.
*                SELECT SINGLE * FROM zmb1a WHERE uname EQ sy-uname AND cpudt EQ sy-datum.  "3.8.22
*                IF sy-subrc EQ 0.
*                  MESSAGE 'CHECK MRN STORAGE LOCATION  - MRN4' TYPE 'I'.
*                ELSE.
*                  MESSAGE 'CHECK MRN STORAGE LOCATION  - MRN4' TYPE 'E'.
*                ENDIF.
*              ENDIF.
*            ENDIF.
*          ELSE.
*            IF mseg-lgort NE 'MRN1'.
*              IF sy-datum GE '20220401'.
*                SELECT SINGLE * FROM zmb1a WHERE uname EQ sy-uname AND cpudt EQ sy-datum.  "3.8.22
*                IF sy-subrc EQ 0.
*                  MESSAGE 'CHECK MRN STORAGE LOCATION  - MRN1' TYPE 'I'.
*                ELSE.
*                  MESSAGE 'CHECK MRN STORAGE LOCATION  - MRN1' TYPE 'E'.
*                ENDIF.
*              ENDIF.
*            ENDIF.
*          ENDIF.
*        ENDIF.
*
*
*****************************MRN CHECKING ENDS HERE***************************
*      ENDIF.
*    ENDIF.
*
*    IF cobl-bwart EQ '907'.  "PHYSICAL INVENTORY ADJ  8.3.21
**      BREAK-POINT .
*      IF mseg-matnr IS NOT INITIAL.
*        SELECT SINGLE * FROM mcha WHERE matnr EQ mseg-matnr AND werks EQ mseg-werks AND charg EQ mseg-charg.
*        IF sy-subrc EQ 4.
*          MESSAGE 'INVALID BATCH, PLEASE CHECK' TYPE 'E'.
*        ENDIF.
*      ENDIF.
*    ENDIF.
*
*
*  ENDIF.
  endmethod.


  method IF_EX_MB_MIGO_BADI~HOLD_DATA_DELETE.
  endmethod.


  method IF_EX_MB_MIGO_BADI~HOLD_DATA_LOAD.
  endmethod.


  method IF_EX_MB_MIGO_BADI~HOLD_DATA_SAVE.
  endmethod.


  method IF_EX_MB_MIGO_BADI~INIT.
  endmethod.


  method IF_EX_MB_MIGO_BADI~LINE_DELETE.
  endmethod.


  method IF_EX_MB_MIGO_BADI~LINE_MODIFY.
  endmethod.


  method IF_EX_MB_MIGO_BADI~MAA_LINE_ID_ADJUST.
  endmethod.


  method IF_EX_MB_MIGO_BADI~MODE_SET.
  endmethod.


  method IF_EX_MB_MIGO_BADI~PAI_DETAIL.
  endmethod.


  method IF_EX_MB_MIGO_BADI~PAI_HEADER.
  endmethod.


  method IF_EX_MB_MIGO_BADI~PBO_DETAIL.
  endmethod.


  method IF_EX_MB_MIGO_BADI~PBO_HEADER.
  endmethod.


  method IF_EX_MB_MIGO_BADI~POST_DOCUMENT.

  endmethod.


  method IF_EX_MB_MIGO_BADI~PROPOSE_SERIALNUMBERS.
  endmethod.


  method IF_EX_MB_MIGO_BADI~PUBLISH_MATERIAL_ITEM.
  endmethod.


  method IF_EX_MB_MIGO_BADI~RESET.
  endmethod.


  method IF_EX_MB_MIGO_BADI~STATUS_AND_HEADER.
  endmethod.
ENDCLASS.
