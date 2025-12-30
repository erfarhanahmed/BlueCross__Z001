*&---------------------------------------------------------------------*
*& Include          ZXCSAU04
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZXCSAU04
** Implementd by Jyotsna on 9.1.22 to add MFR number in tcode CS02, BOM
*&---------------------------------------------------------------------*
TABLES : STKO.
*         ZSTKO.

DATA: ZMFR TYPE STKO-ZMFR.
CLEAR : ZMFR.

IF SY-TCODE EQ 'CS03'.
  SELECT SINGLE * FROM STKO WHERE STLNR EQ HEADERALTDATA-STLNR AND STLAL EQ HEADERALTDATA-STLAL.
  IF SY-SUBRC EQ 0.
    ZMFR = STKO-ZMFR.
  ENDIF.
  STKO-ZMFR = ZMFR.
ELSE.

  IF STKO-ZMFR IS INITIAL.
    SELECT SINGLE * FROM STKO WHERE STLNR EQ HEADERALTDATA-STLNR AND STLAL EQ HEADERALTDATA-STLAL.
    IF SY-SUBRC EQ 0.
      ZMFR = STKO-ZMFR.
    ENDIF.
  ELSE.
    ZMFR = STKO-ZMFR.
  ENDIF.
  STKO-ZMFR = ZMFR.
ENDIF.

*IF zSTKO-ZMFR IS INITIAL.
*  SELECT SINGLE * FROM STKO WHERE STLNR EQ HEADERALTDATA-STLNR AND STLAL EQ HEADERALTDATA-STLAL.
*  IF SY-SUBRC EQ 0.
*    ZSTKO-ZMFR = STKO-ZMFR.
*  ENDIF.
*ELSE.
*  STKO-ZMFR = ZSTKO-ZMFR.
*ENDIF.
***BREAK-POINT.
**LOOP AT SCREEN.
***        if screen-name = 'ZMFR'.
**  SCREEN-INPUT = '0'.
**  SCREEN-ACTIVE = '0'.
**  MODIFY SCREEN.
***        endif.
**ENDLOOP.
**
***BREAK-POINT.
**SCREEN-INPUT = '0'.
**SCREEN-active = '0'.
**MODIFY SCREEN.
***BREAK-POINT.
