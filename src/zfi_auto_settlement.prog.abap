*&---------------------------------------------------------------------*
*& Report ZFI_AUTO_SETTLEMENT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFI_AUTO_SETTLEMENT.
TABLES:cobra.

types :BEGIN OF ty_final,
       aufnr type afpo-aufnr,
       END OF ty_final.
data:lt_final type STANDARD TABLE OF ty_final,
      ls_final type ty_final.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS : s_date FOR cobra-erdat.
SELECTION-SCREEN END OF BLOCK b1.


INITIALIZATION.

INITIALIZATION.
  DATA(date) = sy-datum - 7.
  s_date-low  = date.  " Low date (e.g., Jan 1, 2025)
  s_date-high = sy-datum.  " High date (e.g., Dec 31, 2025)
  s_date-sign = 'I'.
  s_date-option = 'BT'.      " Between
  APPEND s_date.

START-OF-SELECTION.

  PERFORM get_data.
  PERFORM dis_data.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .
  SELECT * FROM cobra INTO TABLE @DATA(lt_cobra)
  WHERE erdat IN @s_date.

  IF lt_cobra IS NOT INITIAL.
    SELECT * FROM jest INTO TABLE @DATA(lt_jest)
      FOR ALL ENTRIES IN @lt_cobra
         WHERE objnr = @lt_cobra-objnr
         AND stat IN ( 'I0012' ,'I0045' ) AND inact EQ ' '.

    IF  lt_jest IS NOT INITIAL.
      DATA: lt_objnr TYPE RANGE OF coep-objnr.
      DATA: lt_aufnr TYPE RANGE OF coep-objnr.
      DATA: lt_year TYPE RANGE OF c.

LOOP AT lt_jest INTO DATA(ls_jest).
  APPEND VALUE #( sign = 'I' option = 'EQ' low = ls_jest-objnr ) TO lt_objnr.
ENDLOOP.
SELECT objnr, SUM( wtgbtr ) AS total
  INTO TABLE @DATA(lt_sum)
  FROM coep
  WHERE objnr IN @lt_objnr
  GROUP BY objnr.
  ENDIF.
  LOOP AT lt_sum INTO DATA(ls_sum).
    ls_sum-objnr = ls_sum-objnr+4(10).
    if ls_sum-total ne '0.00'.
       APPEND VALUE #( sign = 'I' option = 'EQ' low = ls_sum-objnr ) TO lt_aufnr.
    DATA(lv_year) = sy-datum+0(4).
*    APPEND VALUE #( sign = 'I' option = 'EQ' low = lv_year ) TO lt_year.
      FIELD-SYMBOLS: <LT_PAY_DATA>  TYPE ANY TABLE,
<LT_PAY_DATA1> TYPE ANY TABLE.
  DATA LR_PAY_DATA           TYPE REF TO DATA.
  CL_SALV_BS_RUNTIME_INFO=>SET(
    EXPORTING
      DISPLAY  = ABAP_FALSE
      METADATA = ABAP_FALSE
      DATA     = ABAP_TRUE ).
    SUBMIT FCO_RKO7CO88H
    USING SELECTION-SET 'ZSETTLEMENT'
           WITH aufnr in lt_aufnr
           WITH gjahr = lv_year
          AND RETURN.

      TRY.
      CL_SALV_BS_RUNTIME_INFO=>GET_DATA_REF(
        IMPORTING
          R_DATA = LR_PAY_DATA ).
      IF LR_PAY_DATA IS NOT INITIAL.
        ASSIGN LR_PAY_DATA->* TO <LT_PAY_DATA>.
        IF  <LT_PAY_DATA> IS ASSIGNED.
*          MOVE-CORRESPONDING <LT_PAY_DATA> TO LT_MM60.
          CLEAR : LR_PAY_DATA.
          REFRESH : <LT_PAY_DATA>[].
        ENDIF.
      ENDIF.
    CATCH CX_SALV_BS_SC_RUNTIME_INFO.
      MESSAGE `Unable to retrieve ALV data` TYPE 'E'.
  ENDTRY.
  CL_SALV_BS_RUNTIME_INFO=>CLEAR_ALL( ).

      ENDIF.
    ls_final-aufnr = ls_sum-objnr.
    APPEND ls_final to lt_final.
    CLear :ls_final.
  ENDLOOP.


  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form dis_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM dis_data .

DATA : lT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
       ls_FCAT TYPE SLIS_FIELDCAT_ALV,
       ls_layout TYPE slis_layout_alv.
ls_fcat-col_pos        = '1'.
ls_fcat-fieldname      = 'AUFNR'.
ls_fcat-tabname      = 'LT_FINAL'.
ls_fcat-seltext_l = 'Order No'.
APPEND ls_fcat to lt_fcat.
CLEAR ls_fcat.

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING
   I_CALLBACK_PROGRAM                = sy-cprog
*   IS_LAYOUT                         =
   IT_FIELDCAT                       = lt_fcat
*
  TABLES
    t_outtab                          = lt_final
 EXCEPTIONS
   PROGRAM_ERROR                     = 1
   OTHERS                            = 2 .
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.




ENDFORM.
