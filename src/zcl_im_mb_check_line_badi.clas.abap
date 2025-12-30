class ZCL_IM_MB_CHECK_LINE_BADI definition
  public
  final
  create public .

public section.

  interfaces IF_EX_MB_CHECK_LINE_BADI .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_MB_CHECK_LINE_BADI IMPLEMENTATION.


  method IF_EX_MB_CHECK_LINE_BADI~CHECK_LINE.
    BREAK CTPLGW.
*  ***** Restrict tcode MB1A against irrelevant production order** by Jyotsna on 11.4.2019 **********

  DATA :  zmatnr   TYPE aufm-matnr,
          zcharg   TYPE aufm-charg,
          lgort    TYPE MSEG-lgort,
          lwa_afpo TYPE afpo.
  IF sy-tcode EQ 'MIGO'.

    IF IS_MSEG-bwart EQ 'Y01' OR IS_MSEG-bwart EQ 'Y02'.
      MESSAGE 'THIS MOVEMENT IS NOT POSSIBLE' TYPE 'E'.
    ENDIF.

    IF IS_MSEG-aufnr IS NOT INITIAL.
      IF IS_MSEG-bwart EQ '262'.
        IF IS_MSEG-matnr IS NOT INITIAL.
          CLEAR : zmatnr,zcharg.
          zmatnr = IS_MSEG-matnr.
          zcharg = IS_MSEG-charg.

          SELECT SINGLE matnr charg FROM aufm INTO (zmatnr, zcharg) WHERE aufnr EQ IS_MSEG-aufnr AND matnr = IS_MSEG-matnr AND charg = IS_MSEG-charg.
          IF sy-subrc EQ 4.
*        BREAK-POINT.
            MESSAGE 'INVALID ORDER' TYPE 'E'.
          ENDIF.
        ENDIF.
**************************MRN CHECKING***********************
*************mrn1 mandatory for mrn material  3.12.21
        CLEAR : lgort.
        SELECT SINGLE * FROM zmrn INTO @DATA(LS_ZRMN) WHERE pmmatnr EQ @IS_MSEG-matnr AND werks EQ @IS_MSEG-werks.
        IF sy-subrc EQ 0.
          SELECT SINGLE * FROM afpo INTO lwa_afpo WHERE aufnr EQ IS_MSEG-aufnr.
          IF sy-subrc EQ 0.
            lgort = lwa_afpo-lgort.
          ENDIF.
          IF lgort EQ 'FG04'.
            IF IS_MSEG-lgort NE 'MRN4'.
              IF sy-datum GE '20220401'.
                SELECT SINGLE * FROM zmb1a into @DATA(LS_MB1A) WHERE uname EQ @sy-uname AND cpudt EQ @sy-datum.  "3.8.22
                IF sy-subrc EQ 0.
                  MESSAGE 'CHECK MRN STORAGE LOCATION  - MRN4' TYPE 'I'.
                ELSE.
                  MESSAGE 'CHECK MRN STORAGE LOCATION  - MRN4' TYPE 'E'.
                ENDIF.
              ENDIF.
            ENDIF.
          ELSE.
            IF IS_MSEG-lgort NE 'MRN1'.
              IF sy-datum GE '20220401'.
                SELECT SINGLE * FROM zmb1a INTO @DATA(LS_ZMB1A) WHERE uname EQ @sy-uname AND cpudt EQ @sy-datum.  "3.8.22
                IF sy-subrc EQ 0.
                  MESSAGE 'CHECK MRN STORAGE LOCATION  - MRN1' TYPE 'I'.
                ELSE.
                  MESSAGE 'CHECK MRN STORAGE LOCATION  - MRN1' TYPE 'E'.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.


****************************MRN CHECKING ENDS HERE***************************
      ENDIF.
    ENDIF.

    IF IS_MSEG-bwart EQ '907'.  "PHYSICAL INVENTORY ADJ  8.3.21
*      BREAK-POINT .
      IF IS_MSEG-matnr IS NOT INITIAL.
        SELECT SINGLE * FROM mcha into @DATA(LS_MCHA) WHERE matnr EQ @IS_MSEG-matnr AND werks EQ @IS_MSEG-werks AND charg EQ @IS_MSEG-charg.
        IF sy-subrc EQ 4.
          MESSAGE 'INVALID BATCH, PLEASE CHECK' TYPE 'E'.
        ENDIF.
      ENDIF.
    ENDIF.


  ENDIF.



  DATA : "zmatnr    TYPE aufm-matnr,
        "zcharg    TYPE aufm-charg,
        "lgort     TYPE mseg-lgort,
*        lwa_afpo  TYPE afpo,
        lwa_zmrn  TYPE zmrn,
        lwa_zmb1a TYPE zmb1a.
.
  IF sy-tcode = 'MIGO'.

    IF IS_MSEG-bwart EQ 'Y01' OR IS_MSEG-bwart EQ 'Y02'.
      MESSAGE 'THIS MOVEMENT IS NOT POSSIBLE' TYPE 'E'.
    ENDIF.

***********NEW CHANGE TO RESTRICT PACKING MATERIAL ISSUANCE OTHER THAN PRIMARY FOR SALE PRODUCTS********************************
*  *********************************

    IF IS_MSEG-bwart EQ '261'.
      DATA: it_qals TYPE TABLE OF qals,
            wa_qals TYPE qals.

      DATA: vcode TYPE qave-vcode.
      DATA: matnr1 TYPE mara-matnr.
      DATA: zaufnr TYPE afpo-aufnr.

      DATA: exp1(1) TYPE C.
      DATA: mtart TYPE mara-mtart.
      CLEAR : vcode.

**************************** ALLOW EXPORT AND SAMPLE *************
      SELECT SINGLE * FROM afpo INTO lwa_afpo WHERE aufnr EQ IS_MSEG-aufnr.
      IF sy-subrc = 0.
*************** ALLOW EXPORT & SAMPLE. **********************************
        CLEAR : mtart,exp1.
        SELECT SINGLE mtart INTO mtart FROM mara WHERE matnr EQ lwa_afpo-matnr.

        IF mtart EQ 'ZESC' OR mtart EQ 'ZESM' OR mtart EQ 'ZDSM'.
          exp1 = 'A'.
        ENDIF.

      ENDIF.
      IF mtart EQ 'ZHLB'.
        exp1 = 'A'.
      ENDIF.
**************allow reprocessing batches 5.9.25- Jyotsna*****
      DATA: rcharg TYPE afpo-charg.
      CLEAR : rcharg.
      SELECT SINGLE  rcharg INTO rcharg FROM zcoabatch WHERE rcharg EQ lwa_afpo-charg.  "ADDED ON 5.9.25 FOR REPROCESSED BATCH
      IF rcharg IS NOT INITIAL.
        exp1 = 'A'.
      ENDIF.
***************ENDS EXPORT LIQUID**************************
      IF exp1 EQ 'A'.

      ELSE.
        SELECT SINGLE aufnr INTO zaufnr FROM zmrn_ord WHERE aufnr EQ IS_MSEG-aufnr.  "added on 16.12.24 Jyotsna for mft & mpt batch issue
        IF zaufnr IS INITIAL.

          SELECT SINGLE * FROM afpo INTO lwa_afpo WHERE aufnr EQ IS_MSEG-aufnr.
          IF sy-subrc EQ 0.
            SELECT * FROM qals INTO TABLE it_qals WHERE art EQ '04' AND charg EQ lwa_afpo-charg
            AND werk EQ lwa_afpo-pwerk.
            LOOP AT it_qals INTO wa_qals.
              SELECT SINGLE vcode FROM qave INTO vcode WHERE prueflos EQ wa_qals-prueflos AND vcode EQ 'A'.
            ENDLOOP.
            CLEAR : matnr1.
            IF vcode NE 'A'.
              IF IS_MSEG-erfmg GT 0.
*                MESSAGE 'HALB IS NOT RELEASED' TYPE 'I'.
                SELECT SINGLE matnr FROM mara INTO matnr1 WHERE matnr EQ IS_MSEG-matnr AND matkl EQ 'PPM001'.
                IF matnr1 EQ space.
*                  MESSAGE 'MATERIAL ISSUE IS NOT ALLOWED AS HALB IS NOT YET RELEASED' TYPE 'E'.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

      ENDIF.
    ENDIF.
*endif.
************************************
***************END ****************

    IF IS_MSEG-aufnr IS NOT INITIAL.
      IF IS_MSEG-bwart EQ '262'.

        CLEAR : lgort.
        SELECT SINGLE * FROM zmrn INTO lwa_zmrn WHERE pmmatnr EQ IS_MSEG-matnr AND werks EQ IS_MSEG-werks.
        IF sy-subrc EQ 0.
          SELECT SINGLE * FROM afpo INTO lwa_afpo WHERE aufnr EQ IS_MSEG-aufnr.
          IF sy-subrc EQ 0.
            lgort = lwa_afpo-lgort.
          ENDIF.
          IF lgort EQ 'FG04'.
            IF IS_MSEG-lgort NE 'MRN4'.
              IF sy-datum GE '20220401'.
                SELECT SINGLE * FROM zmb1a INTO lwa_zmb1a WHERE uname EQ sy-uname AND cpudt EQ sy-datum.
                IF sy-subrc EQ 0.
                  MESSAGE 'CHECK MRN STORAGE LOCATION  - MRN4' TYPE 'I'.
                ELSE.
                  MESSAGE 'CHECK MRN STORAGE LOCATION  - MRN4' TYPE 'E'.
                ENDIF.
              ENDIF.
            ENDIF.
          ELSE.
            IF IS_MSEG-lgort NE 'MRN1'.
              IF sy-datum GE '20220401'.
                SELECT SINGLE * FROM zmb1a INTO lwa_zmb1a WHERE uname EQ sy-uname AND cpudt EQ sy-datum.
                IF sy-subrc EQ 0.
                  MESSAGE 'CHECK MRN STORAGE LOCATION  - MRN1' TYPE 'I'.
                ELSE.
                  MESSAGE 'CHECK MRN STORAGE LOCATION  - MRN1' TYPE 'E'.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

      ENDIF.
    ENDIF.
  ENDIF.


  endmethod.
ENDCLASS.
