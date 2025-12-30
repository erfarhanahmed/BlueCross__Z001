*&---------------------------------------------------------------------*
*& Report ZBCLLSD_MM_STOCK1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbcllsd_mm_stock1.

*--------------------------------------------------------------------*
* Assumption: S/4HANA 2023; MATDOC used instead of MKPF/MSEG
*--------------------------------------------------------------------*

TABLES: mara, makt, mard, t001w, t134t, tspat.
DATA: gv_charg TYPE matdoc-charg.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_matnr FOR mara-matnr,
                  s_werks FOR mard-werks,
                  s_lgort FOR mard-lgort,
                  s_mtart FOR mara-mtart,
                  s_charg FOR gv_charg,
                  s_budat FOR sy-datum NO-EXTENSION.
SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.
*  TEXT-001 = 'Stock Overview of Materials (S/4HANA 2023)'.

  TYPES: BEGIN OF ty_stock_cur,
           werks TYPE mard-werks,
           matnr TYPE mard-matnr,
           labst TYPE mard-labst,
           insme TYPE mard-insme,
           einme TYPE mard-einme,
           speme TYPE mard-speme,
           retme TYPE mard-retme,
         END OF ty_stock_cur.

  TYPES: BEGIN OF ty_mov_after,
           werks   TYPE matdoc-werks,
           matnr   TYPE matdoc-matnr,
           s_after TYPE mseg-menge,
           h_after TYPE mseg-menge,
         END OF ty_mov_after.

  TYPES: BEGIN OF ty_mov_in,
           werks   TYPE matdoc-werks,
           matnr   TYPE matdoc-matnr,
           s_in    TYPE mseg-menge,
           h_in    TYPE mseg-menge,
           qty_102 TYPE mseg-menge,
           qty_642 TYPE mseg-menge,
         END OF ty_mov_in.

  TYPES: BEGIN OF ty_out,
           werks     TYPE mard-werks,
           plantnm   TYPE t001w-name1,
           matnr     TYPE mara-matnr,
           maktx     TYPE makt-maktx,
           meins     TYPE mara-meins,
           mtart     TYPE mara-mtart,
           mtbez     TYPE t134t-mtbez,
           spart     TYPE mara-spart,
           vtext     TYPE tspat-vtext,
           open_qty  TYPE mseg-menge,
           rcpt_qty  TYPE mseg-menge,
           issue_qty TYPE mseg-menge,
           close_qty TYPE mseg-menge,
         END OF ty_out.

  DATA: lt_cur   TYPE SORTED TABLE OF ty_stock_cur WITH UNIQUE KEY werks matnr,
        lt_after TYPE HASHED  TABLE OF ty_mov_after WITH UNIQUE KEY werks matnr,
        lt_in    TYPE HASHED  TABLE OF ty_mov_in   WITH UNIQUE KEY werks matnr,
        lt_out   TYPE STANDARD TABLE OF ty_out WITH DEFAULT KEY.

  DATA: lv_low  TYPE sy-datum,
        lv_high TYPE sy-datum.

INITIALIZATION.
  lv_low  = s_budat-low.
  lv_high = s_budat-high.

START-OF-SELECTION.

*-------------------- Authorization checks (plants/materials) -----------------*
  DATA: lt_werks TYPE STANDARD TABLE OF t001w-werks.  "  "WITH UNIQUE KEY table_line.

  SELECT werks FROM t001w INTO TABLE @lt_werks WHERE werks IN @s_werks.
  LOOP AT lt_werks ASSIGNING FIELD-SYMBOL(<w>).
    AUTHORITY-CHECK OBJECT 'M_MATE_WRK'
         ID 'WERKS' FIELD <w>
         ID 'ACTVT' FIELD '03'.
    IF sy-subrc <> 0.
      MESSAGE e398(00) WITH |No display auth. for plant { <w> }|.
    ENDIF.
  ENDLOOP.

*-------------------- Current stock (MARD) ------------------------------------*
  SELECT werks, matnr,
         SUM( labst ) AS labst,
         SUM( insme ) AS insme,
         SUM( einme ) AS einme,
         SUM( speme ) AS speme,
         SUM( retme ) AS retme
    FROM mard
    WHERE werks IN @s_werks
      AND lgort IN @s_lgort
      AND matnr IN @s_matnr
    GROUP BY werks, matnr
    INTO TABLE @DATA(lt_mard_sum).

  lt_cur = CORRESPONDING #( lt_mard_sum ).

*-------------------- Movements AFTER date-high (MATDOC) ----------------------*
  SELECT werks, matnr,
         SUM( CASE WHEN shkzg = 'S' THEN menge ELSE 0 END ) AS s_after,
         SUM( CASE WHEN shkzg = 'H' THEN menge ELSE 0 END ) AS h_after
    FROM matdoc
    WHERE
         record_type = 'MDOC'
      AND   budat > @lv_high
      AND werks IN @s_werks
      AND lgort IN @s_lgort
      AND matnr IN @s_matnr
      AND charg IN @s_charg
      AND bwart NOT IN ( '321', '349' )
      AND ( xauto = '' OR bustm NOT IN ( 'MA02', 'MA05' ) )
    GROUP BY werks, matnr
    INTO TABLE @lt_after.

*-------------------- Movements IN the period (MATDOC) ------------------------*
  SELECT werks, matnr,
         SUM( CASE WHEN shkzg = 'S' THEN menge ELSE 0 END ) AS s_in,
         SUM( CASE WHEN shkzg = 'H' THEN menge ELSE 0 END ) AS h_in,
         SUM( CASE WHEN bwart = '102' THEN menge ELSE 0 END ) AS qty_102,
         SUM( CASE WHEN bwart = '642' THEN menge ELSE 0 END ) AS qty_642
    FROM matdoc
    WHERE
         budat IN @s_budat AND
*         budat BETWEEN @lv_low AND @lv_high AND
       werks IN @s_werks
      AND lgort IN @s_lgort
      AND matnr IN @s_matnr
      AND charg IN @s_charg
*      AND ( ( xwoff = '' OR xwoff IS NULL ) )
*      AND ( sobkz IN ( ' ', 'O', 'W', 'V' ) OR kzbws IN ( 'M', 'A' ) )
       AND ( xwoff =  @space OR xwoff IS NULL )
       AND ( sobkz = ' ' OR
             sobkz = 'O' OR
             sobkz = 'W' OR
             sobkz = 'V' OR
             kzbws = 'M' OR
             kzbws = 'A' )
      AND bwart NOT IN ( '321', '349' )
    GROUP BY werks, matnr
    INTO TABLE @lt_in.

  TYPES: ty_qty TYPE MENGE_D.

*-------------------- Build output -------------------------------------------*
  LOOP AT lt_cur ASSIGNING FIELD-SYMBOL(<c>).

    DATA(lv_current) = CONV ty_qty( ( <c>-labst + <c>-insme + <c>-einme + <c>-speme + <c>-retme ) ).

    READ TABLE lt_after ASSIGNING FIELD-SYMBOL(<a>) WITH KEY werks = <c>-werks matnr = <c>-matnr.
    DATA(lv_s_after) = CONV ty_qty( COND mseg-menge( WHEN sy-subrc = 0 THEN <a>-s_after ELSE 0 ) ).
    DATA(lv_h_after) = CONV ty_qty( COND mseg-menge( WHEN sy-subrc = 0 THEN <a>-h_after ELSE 0 ) ).

    READ TABLE lt_in ASSIGNING FIELD-SYMBOL(<p>) WITH KEY werks = <c>-werks matnr = <c>-matnr.
    DATA(lv_s_in)    = CONV ty_qty( COND mseg-menge( WHEN sy-subrc = 0 THEN <p>-s_in   ELSE 0 ) ).
    DATA(lv_h_in)    = CONV ty_qty( COND mseg-menge( WHEN sy-subrc = 0 THEN <p>-h_in   ELSE 0 ) ).
    DATA(lv_c102)    = CONV ty_qty( COND mseg-menge( WHEN sy-subrc = 0 THEN <p>-qty_102 ELSE 0 ) ).
    DATA(lv_c642)    = CONV ty_qty( COND mseg-menge( WHEN sy-subrc = 0 THEN <p>-qty_642 ELSE 0 ) ).
    data(lv_cancel)  = CONV ty_qty( lv_c102 + lv_c642 ).

*    DATA(lv_close) = CONV ty_qty( lv_current - lv_s_after + lv_h_after ).

    DATA(lv_rcpt)  = CONV ty_qty( lv_s_after  - lv_cancel ).
    DATA(lv_issue) = CONV ty_qty( lv_h_after  - lv_cancel ).

    DATA(lv_open)  = CONV ty_qty( lv_current - lv_rcpt + lv_issue ).
    DATA(lv_close) = CONV ty_qty( lv_open + lv_rcpt - lv_issue ).

    APPEND VALUE ty_out( werks = <c>-werks
                         matnr = <c>-matnr
                         close_qty = lv_close
                         rcpt_qty  = lv_rcpt
                         issue_qty = lv_issue
                         open_qty  = lv_open ) TO lt_out.
  ENDLOOP.

*-------------------- Enrich with master data and filter by MTART -------------*
  IF lt_out IS NOT INITIAL.
    SELECT a~matnr, a~meins, a~mtart, a~spart,
           t~maktx, w~name1 AS plantnm, mt~mtbez, sp~vtext,
           o~werks
      FROM @lt_out AS o
      INNER JOIN mara AS a ON a~matnr = o~matnr
      LEFT  JOIN makt AS t ON t~matnr = o~matnr AND t~spras = @sy-langu
      LEFT  JOIN t001w AS w ON w~werks = o~werks
      LEFT  JOIN t134t AS mt ON mt~mtart = a~mtart AND mt~spras = @sy-langu
      LEFT  JOIN tspat AS sp ON sp~spart = a~spart AND sp~spras = @sy-langu
      INTO TABLE @DATA(lt_enriched).

    LOOP AT lt_out ASSIGNING FIELD-SYMBOL(<o>).
      READ TABLE lt_enriched ASSIGNING FIELD-SYMBOL(<e>)
        WITH KEY matnr = <o>-matnr werks = <o>-werks.
      IF sy-subrc = 0.
        <o>-meins   = <e>-meins.
        <o>-mtart   = <e>-mtart.
        <o>-spart   = <e>-spart.
        <o>-maktx   = <e>-maktx.
        <o>-plantnm = <e>-plantnm.
        <o>-mtbez   = <e>-mtbez.
        <o>-vtext   = <e>-vtext.
      ENDIF.
    ENDLOOP.

    DELETE lt_out WHERE mtart NOT IN s_mtart.
  ENDIF.

*-------------------- Sort and display ----------------------------------------*
  SORT lt_out BY werks spart maktx.
*  DATA(lo_alv) = NEW cl_salv_table( ).
  TRY.
      cl_salv_table=>factory( IMPORTING r_salv_table = DATA(lo_alv)
                              CHANGING t_table = lt_out ).

      lo_alv->get_functions( )->set_all( abap_true ).
      lo_alv->get_columns( )->set_optimize( abap_True ).
      lo_alv->get_sorts( )->add_sort( columnname = 'WERKS' ).
      lo_alv->get_sorts( )->add_sort( columnname = 'SPART' ).
      lo_alv->get_sorts( )->add_sort( columnname = 'MAKTX' ).
      lo_alv->get_display_settings( )->set_striped_pattern( abap_true ).
      lo_alv->display( ).
    CATCH : cx_salv_existing, cx_salv_msg, cx_salv_Data_error,
            cx_salv_not_found INTO DATA(ls_msg) .
  ENDTRY.
