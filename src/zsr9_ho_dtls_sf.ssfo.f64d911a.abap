data lv_begda TYPE string.
data lv_endda TYPE string.
data lv_str TYPE string.

****title
CLEAR lv_begda.
CONCATENATE gv_begda+6(2) '.' gv_begda+4(2) '.' gv_begda+0(4)
 INTO lv_begda.

CLEAR lv_endda.
CONCATENATE GV_ENDDA+6(2) '.' GV_ENDDA+4(2) '.' GV_ENDDA+0(4)
 INTO lv_endda.

CLEAR GV_TITLE.
CONCATENATE 'SR-9 : SALES(NET):'
             lv_begda 'TO'  lv_endda
             'ZONE:'GW_SR9_ZM-zm_hq INTO
GV_TITLE SEPARATED BY space.


















