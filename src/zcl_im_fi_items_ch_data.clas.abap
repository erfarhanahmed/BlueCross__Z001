class ZCL_IM_FI_ITEMS_CH_DATA definition
  public
  final
  create public .

public section.

  interfaces IF_EX_FI_ITEMS_CH_DATA .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_FI_ITEMS_CH_DATA IMPLEMENTATION.


  method IF_EX_FI_ITEMS_CH_DATA~CHANGE_ITEMS.

    CONSTANTS:
    LC_FBL1N TYPE TCODE VALUE 'FBL1N'.
    IF  SY-TCODE = LC_FBL1N.
      LOOP AT CT_ITEMS ASSIGNING FIELD-SYMBOL(<FS_ITEMS>).
        IF NOT <FS_ITEMS>-KONTO IS INITIAL.
          SELECT SINGLE NAME1
            FROM LFA1
            WHERE LIFNR = @<FS_ITEMS>-KONTO
            INTO @<FS_ITEMS>-ZVEND_NAME.

          SELECT SINGLE mindk
            FROM LFb1
            WHERE LIFNR = @<FS_ITEMS>-KONTO
            INTO @<FS_ITEMS>-ZMINO_IND.
        ENDIF.
   ENDLOOP.
    ENDIF.

  endmethod.
ENDCLASS.
