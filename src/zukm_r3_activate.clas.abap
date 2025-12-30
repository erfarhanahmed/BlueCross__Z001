class ZUKM_R3_ACTIVATE definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_UKM_R3_ACTIVATE .
protected section.
private section.
ENDCLASS.



CLASS ZUKM_R3_ACTIVATE IMPLEMENTATION.


  method IF_EX_UKM_R3_ACTIVATE~DCD_ACTIVE.
  endmethod.


  method IF_EX_UKM_R3_ACTIVATE~FI_AR_UPDATE_MODE.
  endmethod.


  method IF_EX_UKM_R3_ACTIVATE~GET_RFCDEST_FSCM.
  endmethod.


  method IF_EX_UKM_R3_ACTIVATE~NO_SLD.
  endmethod.


  method IF_EX_UKM_R3_ACTIVATE~SET_ACTIVE.
*     e_ukm_active = abap_true.
*    E_ACTIVE_FLAG = abap_true.
  endmethod.
ENDCLASS.
