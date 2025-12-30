*&---------------------------------------------------------------------*
*& Report ZMIGO_HSCREEN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMIGO_HSCREEN.

DATA: GWA_ZMIGOH TYPE ZSMIGO_HSCREEN.
DATA: LS_HSMIGO       TYPE ZTB_HSMIGO,
      IS_MKPF         TYPE MKPF,
      CS_GOITEM       TYPE GOITEM,
      GS_ZGE_IW_ITEMS TYPE ZGE_IW_ITEMS,
      ZZ_SMPQTY       TYPE ZDESMPQTY,      " Control Sample Qty
      ZZ_INSQTY       TYPE ZDEINSPQTY.     "Inspected quantity

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.
  CASE SY-UCOMM.
*    WHEN 'OK_POST1' .
    WHEN 'OK_POST' OR 'OK_POST1'.

      IF GWA_ZMIGOH-ERRFLAG  IS NOT INITIAL.
        MESSAGE E703(ZPP).
      ENDIF.

      IMPORT IS_MKPF TO IS_MKPF FROM MEMORY ID 'Z_MKPF'.
      CLEAR: LS_HSMIGO.
      IF IS_MKPF IS NOT INITIAL.
        LS_HSMIGO-MBLNR = IS_MKPF-MBLNR.
        LS_HSMIGO-MJAHR = IS_MKPF-MJAHR.
        LS_HSMIGO-GTENTDT = GWA_ZMIGOH-ZZ_GATEDT.
        LS_HSMIGO-GTENTNO = GWA_ZMIGOH-ZZ_GATEID.
        MODIFY ZTB_HSMIGO FROM LS_HSMIGO.
      ENDIF.
*      CLEAR: is_mkpf, gwa_zmigoh.
      CLEAR: GS_ZGE_IW_ITEMS.
    WHEN 'OK_GO'.
      PERFORM VALIDATE_PO.
    WHEN 'OK_END' OR 'OK_EXIT'.
      PERFORM CLEAR_VARIABLES.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
* SET PF-STATUS 'xxxxxxxx'.
* SET TITLEBAR 'xxx'.
  PERFORM GET_GATEENTRY_DATE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0101 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0101 OUTPUT.
* SET PF-STATUS 'xxxxxxxx'.
* SET TITLEBAR 'xxx'.
*  CLEAR: cs_goitem, gwa_zmigoh,ls_hsmigo.
*  IMPORT cs_goitem TO cs_goitem FROM MEMORY ID 'Z_GOITEM'.
*
*  SELECT SINGLE * FROM ztb_hsmigo INTO @ls_hsmigo
*     WHERE mblnr = @cs_goitem-mblnr
*       AND mjahr = @cs_goitem-mjahr.
*
*  gwa_zmigoh-zz_gateid = ls_hsmigo-gtentno.
*  gwa_zmigoh-zz_gatedt = ls_hsmigo-gtentdt.
*  CLEAR: ls_hsmigo.
  IF GWA_ZMIGOH-ZZ_GATEID IS INITIAL.
    PERFORM READ_HEADER_DATA.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0101 INPUT.

  PERFORM PROCESS_OK_CODE.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form PROCESS_OK_CODE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PROCESS_OK_CODE .
  CASE SY-UCOMM.
    WHEN 'OK_GO'.
      CLEAR: CS_GOITEM, GWA_ZMIGOH,LS_HSMIGO.
      IMPORT CS_GOITEM TO CS_GOITEM FROM MEMORY ID 'Z_GOITEM'.
*
*      SELECT SINGLE * FROM ztb_hsmigo INTO @ls_hsmigo
*         WHERE mblnr = @cs_goitem-mblnr
*           AND mjahr = @cs_goitem-mjahr.
*
*      gwa_zmigoh-zz_gateid = ls_hsmigo-gtentno.
*      gwa_zmigoh-zz_gatedt = ls_hsmigo-gtentdt.
*      CLEAR: ls_hsmigo.
*      FREE MEMORY ID 'Z_GOITEM'.
      PERFORM READ_HEADER_DATA.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_gateentry_date
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_GATEENTRY_DATE.
  DATA: LV_ID TYPE ZGE_IW_ITEMS-ID.
  FIELD-SYMBOLS: <F1> TYPE GOHEAD.

  ASSIGN ('(SAPLMIGO)GOHEAD') TO <F1>.
  IF <F1> IS ASSIGNED.
    IF <F1>-LIFNR IS INITIAL.
      CLEAR: GWA_ZMIGOH, LS_HSMIGO .
    ENDIF.
  ENDIF.

  IF GWA_ZMIGOH-ZZ_GATEID IS NOT INITIAL.
    LV_ID = GWA_ZMIGOH-ZZ_GATEID.

    SELECT SINGLE * INTO @GS_ZGE_IW_ITEMS
              FROM ZGE_IW_ITEMS WHERE ID = @GWA_ZMIGOH-ZZ_GATEID.
    GWA_ZMIGOH-ZZ_GATEDT = GS_ZGE_IW_ITEMS-GATEENTRYDATE.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form validate_po
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM VALIDATE_PO .
  FIELD-SYMBOLS: <F1> TYPE ANY.

  IF GWA_ZMIGOH-EBELN IS INITIAL.
    ASSIGN ('(ZMIGO_HSCREEN)GODEFAULT_TV-BWART') TO <F1>.

    IF <F1> IS ASSIGNED.
      IF <F1>  <> '101'.
        UNASSIGN <F1>.
        RETURN.
      ENDIF.
    ENDIF.

    ASSIGN ('(ZMIGO_HSCREEN)GODYNPRO-PO_NUMBER') TO <F1>.
    IF <F1> IS ASSIGNED.
      CLEAR: GWA_ZMIGOH-EBELN.
      IF <F1> IS NOT INITIAL.
        GWA_ZMIGOH-EBELN = <F1>.
      ENDIF.
      UNASSIGN <F1>.
      IF GWA_ZMIGOH-EBELN IS INITIAL.
        ASSIGN ('(ZMIGO_HSCREEN)GOITEM-EBELN') TO <F1>.
        IF <F1> IS ASSIGNED.
          IF <F1> IS NOT INITIAL.
            GWA_ZMIGOH-EBELN = <F1>.
          ENDIF.
        ENDIF.
        UNASSIGN <F1>.
      ENDIF.
    ENDIF.
  ENDIF.

* If it is Service po then no validation
  IF GWA_ZMIGOH-EBELN IS NOT INITIAL.
*    SELECT SINGLE bsart INTO @DATA(lv_bsart) FROM ekko
*              WHERE ebeln = @gwa_zmigoh-ebeln.
    SELECT SINGLE EBELN, BSART, WERKS_I FROM WB2_V_EKKO_EKPO2
                  INTO @DATA(LS_EKKOPO)
                  WHERE EBELN = @GWA_ZMIGOH-EBELN.
    IF LS_EKKOPO-BSART = 'ZSER' OR
       LS_EKKOPO-BSART = 'ZSRV'.
* No validation.
      CLEAR:   GWA_ZMIGOH-ERRFLAG, GWA_ZMIGOH-EBELN.
      RETURN.
    ENDIF.
    IF LS_EKKOPO-WERKS_I = '1000' OR LS_EKKOPO-WERKS_I = '1001' OR
       LS_EKKOPO-WERKS_I = '2024'.
    ELSE.
* No validation.
      CLEAR:   GWA_ZMIGOH-ERRFLAG, GWA_ZMIGOH-EBELN.
      RETURN.
    ENDIF.
  ENDIF.
* Check if Gate entry already been used
  IF GWA_ZMIGOH-ZZ_GATEID IS NOT INITIAL.
    CLEAR: LS_HSMIGO.
    SELECT SINGLE * INTO @LS_HSMIGO FROM ZTB_HSMIGO
                WHERE GTENTNO = @GWA_ZMIGOH-ZZ_GATEID
                  AND GR_CANCELLED = @SPACE.
    IF SY-SUBRC = 0.
      GWA_ZMIGOH-ERRFLAG  = 'X'.
      MESSAGE W704(ZPP) WITH LS_HSMIGO-MBLNR LS_HSMIGO-MJAHR.
      RETURN.
    ENDIF.

  ENDIF.

* Set error flag if PO number and Gate entry application# are blank
  IF GWA_ZMIGOH-EBELN IS INITIAL AND
     GWA_ZMIGOH-ZZ_GATEID IS INITIAL.
    GWA_ZMIGOH-ERRFLAG = 'X'.
  ENDIF.
  IF GWA_ZMIGOH-EBELN IS INITIAL AND
     GWA_ZMIGOH-ZZ_GATEID IS NOT INITIAL.
    GWA_ZMIGOH-ERRFLAG = 'X'.
  ENDIF.

* if PO is entered and Gate Application No is blank
  IF GWA_ZMIGOH-EBELN IS NOT INITIAL AND GWA_ZMIGOH-ZZ_GATEID IS INITIAL.
    CLEAR: SY-UCOMM.
    GWA_ZMIGOH-ERRFLAG  = 'X'.
    MESSAGE W701(ZPP).
  ENDIF.

* Get date if id entered
  IF   GWA_ZMIGOH-ZZ_GATEID IS NOT INITIAL.
    SELECT SINGLE * INTO @GS_ZGE_IW_ITEMS
                FROM ZGE_IW_ITEMS WHERE ID = @GWA_ZMIGOH-ZZ_GATEID.
    GWA_ZMIGOH-ZZ_GATEDT = GS_ZGE_IW_ITEMS-GATEENTRYDATE.
  ENDIF.

  IF GWA_ZMIGOH-EBELN IS NOT INITIAL AND GWA_ZMIGOH-ZZ_GATEID IS NOT INITIAL.
    CLEAR: GS_ZGE_IW_ITEMS.
    SELECT SINGLE * INTO @GS_ZGE_IW_ITEMS
             FROM ZGE_IW_ITEMS WHERE ID = @GWA_ZMIGOH-ZZ_GATEID.
    IF GWA_ZMIGOH-EBELN <> GS_ZGE_IW_ITEMS-REFERENCEDOCUMENT.
      CLEAR: SY-UCOMM.
      GWA_ZMIGOH-ERRFLAG  = 'X'.
      MESSAGE W702(ZPP) WITH GWA_ZMIGOH-ZZ_GATEID GWA_ZMIGOH-EBELN.
    ELSE.
      CLEAR:   GWA_ZMIGOH-ERRFLAG.
    ENDIF.
  ENDIF.

* Set parameter
  IF GWA_ZMIGOH-EBELN IS NOT INITIAL.
    SET PARAMETER ID 'BES' FIELD GWA_ZMIGOH-EBELN.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Module STATUS_0201 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0201 OUTPUT.
* SET PF-STATUS 'xxxxxxxx'.
* SET TITLEBAR 'xxx'.
*  IF GOITEM-zz_smpqty > 0 .
*  ENDIF.
  IF ZZ_SMPQTY IS INITIAL AND ZZ_INSQTY IS INITIAL.
    PERFORM GET_QUANTITY.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form get_quantity
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_QUANTITY .
  FIELD-SYMBOLS: <F1> TYPE GOITEM,
                 <F2> TYPE ANY.

  ASSIGN ('(ZMIGO_HSCREEN)GOITEM') TO <F1>.
  IF <F1> IS ASSIGNED.

    SELECT SINGLE ZZ_SMPQTY, ZZ_INSQTY INTO ( @<F1>-ZZ_SMPQTY, @<F1>-ZZ_INSQTY )
        FROM ZTB_MIGOITM WHERE MBLNR = @<F1>-MBLNR
                           AND MJAHR = @<F1>-MJAHR
                           AND ZEILE = @<F1>-ZEILE.
*      GOITEM-ZZ_SMPQTY = <f1>-zz_smpqty.
    ASSIGN ('(ZMIGO_HSCREEN)ZZ_SMPQTY') TO <F2>.
    IF <F2> IS ASSIGNED.
      <F2> = <F1>-ZZ_SMPQTY.
    ENDIF.

    ASSIGN ('(ZMIGO_HSCREEN)ZZ_INSQTY') TO <F2>.
    IF <F2> IS ASSIGNED.
      <F2> = <F1>-ZZ_INSQTY.
    ENDIF.
    UNASSIGN <F2>.
  ENDIF.
  UNASSIGN <F1>.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0201  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0201 INPUT.
  CASE SY-UCOMM.
*    WHEN 'OK_POST1' .
    WHEN 'OK_POST' OR 'OK_POST1'.
      PERFORM UPDATE_ITEM.
    WHEN 'OK_GO'.
*      PERFORM validate_po.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form update_item
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM UPDATE_ITEM .
  FIELD-SYMBOLS: <F1> TYPE GOITEM.
*                 <F2> TYPE GOITEM-ZZ_SMPQTY.

  ASSIGN ('(ZMIGO_HSCREEN)GOITEM') TO <F1>.
  IF <F1> IS ASSIGNED.
    <F1>-ZZ_SMPQTY  = ZZ_SMPQTY.
    <F1>-ZZ_INSQTY  = ZZ_INSQTY.
  ENDIF.
  UNASSIGN: <F1>.

  ASSIGN ('(SAPLMIGO)GOITEM') TO <F1>.
  IF <F1> IS ASSIGNED.
    <F1>-ZZ_SMPQTY = ZZ_SMPQTY.
    <F1>-ZZ_INSQTY = ZZ_INSQTY.
  ENDIF.
  UNASSIGN <F1>.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0200 INPUT.
  CASE SY-UCOMM.
*    WHEN 'OK_POST1' .
    WHEN 'OK_POST' OR 'OK_POST1'.
      PERFORM UPDATE_ITEM.
    WHEN 'OK_GO'.
      PERFORM SET_VALUES.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form set_values
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_VALUES .
  FIELD-SYMBOLS: <F1> TYPE GOITEM.

  ASSIGN ('(SAPLMIGO)GOITEM') TO <F1>.
  IF <F1> IS ASSIGNED.
    <F1>-ZZ_SMPQTY = ZZ_SMPQTY.
    <F1>-ZZ_INSQTY = ZZ_INSQTY.
  ENDIF.
  UNASSIGN <F1>.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CLEAR_VARIABLES
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CLEAR_VARIABLES .
  CLEAR: GWA_ZMIGOH.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form read_header_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM READ_HEADER_DATA .
  DATA: LS_GODYNPRO TYPE GODYNPRO.
  FIELD-SYMBOLS: <F1> TYPE GODYNPRO.

  ASSIGN ('(SAPLMIGO)GODYNPRO') TO <F1>.
  IF <F1> IS ASSIGNED.
    LS_GODYNPRO = <F1>.
    SELECT SINGLE * FROM ZTB_HSMIGO INTO @DATA(LS_HSMIGO)
     WHERE MBLNR = @LS_GODYNPRO-MAT_DOC
       AND MJAHR = @LS_GODYNPRO-DOC_YEAR.

    GWA_ZMIGOH-ZZ_GATEID = LS_HSMIGO-GTENTNO.
    GWA_ZMIGOH-ZZ_GATEDT = LS_HSMIGO-GTENTDT.

  ENDIF.
  UNASSIGN <F1>.
ENDFORM.
