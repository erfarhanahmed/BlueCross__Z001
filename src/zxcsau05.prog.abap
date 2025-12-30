*&---------------------------------------------------------------------*
*& Include          ZXCSAU05
*&---------------------------------------------------------------------*
userdata-zmfr = stko-zmfr.

*LOOP AT SCREEN.
**        if screen-name = 'ZMFR'.
*  SCREEN-INPUT = '0'.
*  SCREEN-ACTIVE = '0'.
*  MODIFY SCREEN.
**        endif.
*ENDLOOP.
*
**BREAK-POINT.
*SCREEN-INPUT = '0'.
*SCREEN-active = '0'.
*MODIFY SCREEN.
