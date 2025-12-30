*&---------------------------------------------------------------------*
*& Report  ZRPQV_ZRCUMPSO_UPDATE_FIL1
*&developed by Jyotsna 1.9.24- this will replace terr data.
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zrpqv_zrcumpso_update_file1.


DATA: it_ftab1  TYPE TABLE OF zrpqv,
      wa_ftab1  TYPE zrpqv,
      it_ftab11 TYPE TABLE OF zrcumpso,
      wa_ftab11 TYPE zrcumpso.
DATA: c_file TYPE string.

TYPES: BEGIN OF terr1,
         zmonth TYPE zrpqv-zmonth,
         zyear  TYPE zrpqv-zyear,
         bzirk  TYPE zrpqv-bzirk,
       END OF terr1.
DATA: it_terr1 TYPE TABLE OF terr1,
      wa_terr1 TYPE terr1.
DATA it_type   TYPE truxs_t_text_data.
DATA: zrpqv_wa    TYPE  zrpqv,
      zrcumpso_wa TYPE zrcumpso.


SELECTION-SCREEN BEGIN OF BLOCK merkmale2 WITH FRAME TITLE text-001.
PARAMETERS : m1(2) TYPE c OBLIGATORY,
             y1(4) TYPE c OBLIGATORY.
PARAMETERS : r1 RADIOBUTTON GROUP r1,
             r2 RADIOBUTTON GROUP r1.
PARAMETERS : e_file TYPE rlgrap-filename.
SELECTION-SCREEN END OF BLOCK merkmale2 .

AT SELECTION-SCREEN ON VALUE-REQUEST FOR e_file.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = ' '
    IMPORTING
      file_name     = e_file.

START-OF-SELECTION.

  IF r1 EQ 'X'.
    PERFORM form1.
  ELSEIF r2 EQ 'X'.
    PERFORM form2.
  ENDIF.


*&---------------------------------------------------------------------*
*&      Form  FORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM form1 .
  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
      i_field_seperator    = 'X'
      i_line_header        = 'X'
      i_tab_raw_data       = it_type
      i_filename           = e_file
    TABLES
      i_tab_converted_data = it_ftab1[].




  CLEAR : it_terr1,wa_terr1.
  LOOP AT it_ftab1 INTO wa_ftab1 WHERE zmonth EQ m1 AND zyear EQ y1.
    wa_terr1-zmonth = wa_ftab1-zmonth.
    wa_terr1-zyear = wa_ftab1-zyear.
    wa_terr1-bzirk = wa_ftab1-bzirk.
    COLLECT wa_terr1 INTO it_terr1.
    CLEAR wa_terr1.
  ENDLOOP.
*  BREAK-POINT .
  SORT it_terr1 BY zmonth zyear bzirk.
  LOOP AT it_terr1 INTO wa_terr1.
    DELETE FROM zrpqv WHERE zmonth EQ m1 AND zyear EQ y1 AND bzirk EQ wa_terr1-bzirk.
  ENDLOOP.
*  BREAK-POINT .

  LOOP AT it_ftab1 INTO wa_ftab1.
    UNPACK wa_ftab1-matnr TO wa_ftab1-matnr.
    zrpqv_wa-mandt = sy-mandt.
    zrpqv_wa-zmonth = m1.
    zrpqv_wa-zyear = y1.
    zrpqv_wa-bzirk = wa_ftab1-bzirk.
    zrpqv_wa-matnr = wa_ftab1-matnr.
    zrpqv_wa-grosspts = wa_ftab1-grosspts.
    zrpqv_wa-grossqty = wa_ftab1-grossqty.
    zrpqv_wa-rval = wa_ftab1-rval.
    zrpqv_wa-rqty = wa_ftab1-rqty.
    zrpqv_wa-nepval = wa_ftab1-nepval.
    zrpqv_wa-nepqty = wa_ftab1-nepqty.
    MODIFY zrpqv FROM zrpqv_wa.
    CLEAR zrpqv_wa.
  ENDLOOP.
  IF sy-subrc EQ 0.
    MESSAGE 'DATA UPLOADED IN TABLE ZRPQV' TYPE 'I'.
  ENDIF.
*  BREAK-POINT .
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FORM2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM form2 .
  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
      i_field_seperator    = 'X'
      i_line_header        = 'X'
      i_tab_raw_data       = it_type
      i_filename           = e_file
    TABLES
      i_tab_converted_data = it_ftab11[].




  CLEAR : it_terr1,wa_terr1.
  LOOP AT it_ftab11 INTO wa_ftab11 WHERE zmonth EQ m1 AND zyear EQ y1.
    wa_terr1-zmonth = wa_ftab1-zmonth.
    wa_terr1-zyear = wa_ftab1-zyear.
    wa_terr1-bzirk = wa_ftab1-bzirk.
    COLLECT wa_terr1 INTO it_terr1.
    CLEAR wa_terr1.
  ENDLOOP.
*  BREAK-POINT .
  SORT it_terr1 BY zmonth zyear bzirk.
  LOOP AT it_terr1 INTO wa_terr1.
    DELETE FROM zrcumpso WHERE zmonth EQ m1 AND zyear EQ y1 AND bzirk EQ wa_terr1-bzirk.
  ENDLOOP.
*  BREAK-POINT .

  LOOP AT it_ftab11 INTO wa_ftab11.
    UNPACK wa_ftab1-matnr TO wa_ftab1-matnr.
    zrcumpso_wa-mandt = sy-mandt.
    zrcumpso_wa-zmonth = m1.
    zrcumpso_wa-zyear = y1.
    zrcumpso_wa-bzirk = wa_ftab11-bzirk.
    zrcumpso_wa-grosspts = wa_ftab11-grosspts.
    zrcumpso_wa-rval = wa_ftab11-rval.
    zrcumpso_wa-zg2cnval = wa_ftab11-zg2cnval.
    zrcumpso_wa-othrcnval = wa_ftab11-othrcnval.
    zrcumpso_wa-netcnval = wa_ftab11-netcnval.
    zrcumpso_wa-nepval = wa_ftab11-nepval.
    zrcumpso_wa-netval = wa_ftab11-netval.
    zrcumpso_wa-pso = wa_ftab11-pso.
    zrcumpso_wa-join_dt = wa_ftab11-join_dt.
    MODIFY zrcumpso FROM zrcumpso_wa.
    CLEAR zrcumpso_wa.
  ENDLOOP.

  IF sy-subrc EQ 0.
    MESSAGE 'DATA UPDATED IN TABLE ZRCUMPSO' TYPE 'I'.
  ENDIF.

*  BREAK-POINT .
ENDFORM.
