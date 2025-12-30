class ZCL_1IG_BADI_ISD definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_J1IG_ISD .
protected section.
private section.
ENDCLASS.



CLASS ZCL_1IG_BADI_ISD IMPLEMENTATION.


  method IF_EX_J1IG_ISD~FILL_BAPI_EXTENSION.



*    DATA: ext LIKE LINE OF ch_t_bapiexten.
*DATA: bukrs(60) VALUE '(J_1IG_ISDN)P_BUKRS'.
*DATA: bukrs1(60) VALUE '(ZJ_1IG_ISDN)P_BUKRS'.
*ASSIGN (bukrs) TO FIELD-SYMBOL(<bk>).
*IF sy-subrc <> 0.
*ASSIGN (bukrs1) TO <bk>.
*ENDIF.
*IF sy-subrc = 0.
*  LOOP AT ch_t_tax ASSIGNING FIELD-SYMBOL(<im>).
*    READ TABLE ch_t_bapiexten INTO DATA(wa_ch_t_bapiexten)
*      WITH KEY valuepart3 = <im>-itemno_acc.
*    SELECT SINGLE * FROM zisd_bupla_prctr INTO @DATA(wa_zis_bupla_prctr)
*      WHERE bukrs = @<bk> AND isd_bupla = @wa_ch_t_bapiexten-valuepart2.
*    IF sy-subrc = 0.
*      CLEAR ext.
*      ext-structure   = 'SAPIM'.
*      ext-valuepart1  = <im>-itemno_acc.
*      ext-valuepart2  = 'PRCTR'.
*      ext-valuepart3  = wa_zis_bupla_prctr-prctr.
*      APPEND ext TO ch_t_bapiexten.
*    ENDIF.
*      CLEAR ext.
*      ext-structure   = 'SAPIM'.
*      ext-valuepart1  = <im>-itemno_acc.
*      ext-valuepart2  = 'BUPLA'.
*      ext-valuepart3  = WA_CH_T_BAPIEXTEN-VALUEPART2.
*      APPEND ext TO ch_t_bapiexten.
*  ENDLOOP.
*ENDIF.
*sort   CH_T_BAPIEXTEN BY valuepart4.

DATA: ext LIKE LINE OF ch_t_bapiexten.
DATA: bukrs(60) VALUE '(J_1IG_ISDN)P_BUKRS'.

ASSIGN (bukrs) TO FIELD-SYMBOL(<bk>).
IF sy-subrc = 0.
  LOOP AT ch_t_tax ASSIGNING FIELD-SYMBOL(<im>).
    READ TABLE ch_t_bapiexten INTO DATA(wa_ch_t_bapiexten)
      WITH KEY valuepart3 = <im>-itemno_acc.

    SELECT SINGLE * FROM zisd_bupla_prctr INTO @DATA(wa_zis_bupla_prctr)
      WHERE bukrs = @<bk> AND isd_bupla = @wa_ch_t_bapiexten-valuepart2.

    IF sy-subrc = 0.
      CLEAR ext.
*      ext-structure   = 'SAPIM'.
*      ext-valuepart1  = <im>-itemno_acc.
*      ext-valuepart2  = 'PRCTR'.
*      ext-valuepart3  = wa_zis_bupla_prctr-prctr.
      ext-valuepart1  = 'PRCTR'.
      ext-valuepart2  = wa_zis_bupla_prctr-prctr.
      ext-valuepart3  = <im>-itemno_acc.
      APPEND ext TO ch_t_bapiexten.
    ENDIF.
*
*      CLEAR ext.
*      ext-structure   = 'SAPIM'.
*      ext-valuepart1  = <im>-itemno_acc.
*      ext-valuepart2  = 'BUPLA'.
*      ext-valuepart3  = WA_CH_T_BAPIEXTEN-VALUEPART2.
*      APPEND ext TO ch_t_bapiexten.
  ENDLOOP.
ENDIF.
sort   CH_T_BAPIEXTEN BY valuepart4.

  endmethod.


  method IF_EX_J1IG_ISD~SUMMARIZE.
  endmethod.
ENDCLASS.
