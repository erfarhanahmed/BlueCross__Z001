class YCL_IM_MB_CHECK_LINE_BADI definition
  public
  final
  create public .

public section.

  interfaces IF_EX_MB_CHECK_LINE_BADI .
protected section.
private section.
ENDCLASS.



CLASS YCL_IM_MB_CHECK_LINE_BADI IMPLEMENTATION.


  METHOD if_ex_mb_check_line_badi~check_line.

  IF SY-TCODE = 'MIGO' AND  IS_MSEG-BWART = '261' AND IS_MSEG-AUFNR IS NOT INITIAL .   " IS_MKPF-blart = 'WA'

    SELECT SINGLE mtart
      FROM mara
        INTO @DATA(lv_mtart)
        WHERE matnr = @is_mseg-matnr.
    IF lv_mtart = 'ZHLB'.
      SELECT SINGLE aufnr
        FROM afpo
            INTO @DATA(lv_aufnr)
            WHERE matnr = @is_mseg-matnr
            AND charg = @is_mseg-charg
            AND wemng IS NOT NULL.
      IF lv_aufnr IS NOT INITIAL.
        SELECT SINGLE objnr
          FROM aufk
           INTO @DATA(lv_objnr)
           WHERE aufnr = @lv_aufnr.
      IF lv_objnr IS NOT INITIAL.
        SELECT SINGLE STAT, INACT
          FROM JEST
          INTO @DATA(LW_JEST)
          WHERE objnr = @lv_objnr
          AND STAT = 'I0045'.
        IF SY-SUBRC IS INITIAL .
          IF LW_JEST-INACT = 'X'..
             MESSAGE 'Complete the TECO for HALB product before proceeding'  TYPE 'E'.
          ENDIF.
        ELSE.
           MESSAGE 'Complete the TECO for HALB product before proceeding'  TYPE 'E'.
        ENDIF.

      ENDIF.
      ENDIF.

  ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
