FUNCTION ZGET_PLANT.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     VALUE(EX_PLANT) TYPE  WERKS_D
*"     VALUE(EX_NAME1) TYPE  MEPO1211-NAME1
*"----------------------------------------------------------------------

ASSIGN ('(SAPLMEGUI)MEPO1211-WERKS') TO FIELD-SYMBOL(<fs_werks>).
  IF <fs_werks> IS ASSIGNED.
    EX_PLANT = <fs_werks>.
  ENDIF.


ASSIGN ('(SAPLMEGUI)MEPO1211-NAME1') TO FIELD-SYMBOL(<fs_NAME1>).
IF <fs_NAME1> IS ASSIGNED.
  EX_NAME1 = <fs_NAME1>.
ENDIF.





ENDFUNCTION.
