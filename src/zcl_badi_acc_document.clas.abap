class ZCL_BADI_ACC_DOCUMENT definition
  public
  final
  create public .

*"* public components of class CL_EXM_IM_ACC_DOCUMENT
*"* do not include other source files here!!!
public section.

  interfaces IF_EX_ACC_DOCUMENT .
protected section.
*"* protected components of class CL_EXM_IM_ACC_DOCUMENT
*"* do not include other source files here!!!
private section.
*"* private components of class CL_EXM_IM_ACC_DOCUMENT
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_BADI_ACC_DOCUMENT IMPLEMENTATION.


METHOD if_ex_acc_document~change .

"Code for resolving 'Balancing field "Profit Center" error'

 DATA : WA_MARC TYPE MARC.
  LOOP AT C_ACCIT INTO data(WA_ACCIT).
  CLEAR WA_MARC.
  IF WA_ACCIT-MATNR is NOT INITIAL AND WA_ACCIT-WERKS is NOT INITIAL.
      SELECT SINGLE * FROM MARC INTO WA_MARC
        WHERE MATNR = WA_ACCIT-MATNR
        AND   WERKS = WA_ACCIT-WERKS.
     IF WA_MARC is NOT INITIAL.
      WA_ACCIT-PRCTR = WA_MARC-PRCTR.
      MODIFY C_ACCIT FROM WA_ACCIT TRANSPORTING PRCTR.
      CLEAR: WA_ACCIT.
     ENDIF.
endif.
endloop.
"End of code by Madhavi

ENDMETHOD.                    "IF_EX_ACC_DOCUMENT~CHANGE


method IF_EX_ACC_DOCUMENT~FILL_ACCIT.
endmethod.
ENDCLASS.
