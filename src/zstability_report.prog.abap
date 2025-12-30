*&---------------------------------------------------------------------*
*& Report ZSTABILITY_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSTABILITY_REPORT.

*----------------------------------------------------------------------
* Type pools
*----------------------------------------------------------------------
TYPE-POOLS: SLIS, ICON.
TABLES: QALS .
*DATA: GV_QMNUM TYPE ZSTABILITY-QMNUM,
DATA: GV_QMNUM TYPE QMNUM,
      GV_LOT   TYPE QALS-PRUEFLOS,
      GV_ANLDT TYPE QPRS_ANLDT.
*----------------------------------------------------------------------
* Selection screen
*----------------------------------------------------------------------
SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-T01.
  SELECT-OPTIONS: S_QMNUM   FOR GV_QMNUM,
                  S_PRFLS   FOR QALS-PRUEFLOS , " GV_LOT,
                  S_ANLDT   FOR GV_ANLDT.
  SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME.
    SELECTION-SCREEN BEGIN OF LINE.
      PARAMETERS: P_RB1 RADIOBUTTON GROUP RBG1 DEFAULT 'X'.
      SELECTION-SCREEN COMMENT 10(15) FOR FIELD P_RB1.
      PARAMETERS: P_RB2 RADIOBUTTON GROUP RBG1.
      SELECTION-SCREEN COMMENT 30(15) FOR FIELD P_RB2.
    SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN: END OF BLOCK B1.

*----------------------------------------------------------------------
* Types
*----------------------------------------------------------------------
TYPES: BEGIN OF TY_ROW,
*         sel                         TYPE abap_bool,  " Checkbox to post selected only
         PLOS2                       TYPE QALS-PRUEFLOS,   " Inspection Lot
         QMNUM                       TYPE QMNUM,      " Notification
         ANLNA                       TYPE QPRS_ANL,      " Created By
         ANLDT                       TYPE QPRS_ANLDT,      " Created On (DATS)
         MATNR                       TYPE MATNR,      " Material
         INSPECTIONLOTOBJECTTEXT     TYPE ZSTABILITY-INSPECTIONLOTOBJECTTEXT, " Desc
         WERKS                       TYPE ZSTABILITY-WERKS,      " Plant
         CHARG                       TYPE ZSTABILITY-CHARG,      " Batch
         LGORTCHARG                  TYPE ZSTABILITY-LGORTCHARG, " Storage Location
         INSPECTIONLOTACTUALQUANTITY TYPE ZSTABILITY-INSPECTIONLOTACTUALQUANTITY,
         INSPECTIONLOTQUANTITYUNIT   TYPE ZSTABILITY-INSPECTIONLOTQUANTITYUNIT, " Base UoM
         KURZTEXT                    TYPE ZSTABILITY-KURZTEXT,   " Sample Container
         PRIMPACKTXT                 TYPE ZSTABILITY-PRIMPACKTXT, " Primary Packaging
         STABICONTXT                 TYPE ZSTABILITY-STABICONTXT, " Storage Condition

         BALANCE_QTY                 TYPE ZSTABILITY-BALANCE_QTY, " Needed for validation
         XBLNR                       TYPE MATDOC-XBLNR,

         WQTY                        TYPE ZSTABILITY-INSPECTIONLOTACTUALQUANTITY, " EDITABLE
         CNTR                        TYPE KOSTL,                                       " EDITABLE
         REMARKS                     TYPE TEXT132,
         ZEILE                       TYPE MATDOC-ZEILE,
         BUDAT                       TYPE MATDOC-BUDAT,
         USNAM                       TYPE MATDOC-USNAM,
         MBLNR                       TYPE MATDOC-MBLNR,
         MJAHR                       TYPE MATDOC-MJAHR,

         """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
         PC                          TYPE ZSTABILITY-INSPECTIONLOTACTUALQUANTITY, " EDITABLE
         M                           TYPE ZSTABILITY-INSPECTIONLOTACTUALQUANTITY, " EDITABLE
         UDFLAG                      TYPE CHAR1,
         UDSTAT                      TYPE J_STEXT,
         CELLTAB                     TYPE LVC_T_STYL,

       END OF TY_ROW.

TYPES: TY_TAB TYPE STANDARD TABLE OF TY_ROW WITH DEFAULT KEY.

*----------------------------------------------------------------------
* Data
*----------------------------------------------------------------------
DATA: GT_DATA   TYPE TY_TAB,
      GS_DATA   TYPE TY_ROW,
      GS_ZSTABW TYPE ZSTABW,
      GT_FCAT   TYPE LVC_T_FCAT,
      GS_FCAT   TYPE LVC_S_FCAT,
      GS_LAYOUT TYPE LVC_S_LAYO.

DATA:
*      go_dock TYPE REF TO cl_gui_docking_container,
  GO_CUST TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
  GO_GRID TYPE REF TO CL_GUI_ALV_GRID.

CONSTANTS: C_INSPLOT_TYPE TYPE ZSTABILITY-INSPECTIONLOTTYPE VALUE '1601',
           C_FC_POST      TYPE SYUCOMM VALUE 'POSTGR'.

*----------------------------------------------------------------------
* Local handler for ALV events
*----------------------------------------------------------------------
CLASS LCL_EVENTS DEFINITION.
  PUBLIC SECTION.
    METHODS ON_TOOLBAR      FOR EVENT TOOLBAR      OF CL_GUI_ALV_GRID IMPORTING E_OBJECT E_INTERACTIVE  ##NEEDED.
    METHODS ON_USER_COMMAND FOR EVENT USER_COMMAND OF CL_GUI_ALV_GRID IMPORTING E_UCOMM.
    METHODS ON_DATA_CHANGED  FOR EVENT DATA_CHANGED  OF CL_GUI_ALV_GRID IMPORTING ER_DATA_CHANGED.
ENDCLASS.

CLASS LCL_EVENTS IMPLEMENTATION.
  METHOD ON_TOOLBAR.
    DATA LS_BUTTON TYPE STB_BUTTON.

    CLEAR LS_BUTTON.
    LS_BUTTON-FUNCTION  = C_FC_POST.
    LS_BUTTON-ICON      = ICON_EXECUTE_OBJECT.
    LS_BUTTON-QUICKINFO = TEXT-S01.
    LS_BUTTON-TEXT      = TEXT-S02.
    LS_BUTTON-BUTN_TYPE = 0.
    APPEND LS_BUTTON TO E_OBJECT->MT_TOOLBAR.
  ENDMETHOD.

  METHOD ON_USER_COMMAND.
    CASE E_UCOMM.
      WHEN C_FC_POST.
        PERFORM POST_GOODS_MOVEMENT. " Validation + BAPI call
        "Refresh ALV after posting (balances may change)
        IF GO_GRID IS BOUND.
          GO_GRID->REFRESH_TABLE_DISPLAY( ).
        ENDIF.
    ENDCASE.
  ENDMETHOD.
  METHOD ON_DATA_CHANGED.
    " Immediate validation for WQTY <= BALANCE_QTY
    DATA: LS_MOD  TYPE LVC_S_MODI,
          LV_WQTY TYPE ZSTABILITY-INSPECTIONLOTACTUALQUANTITY,
          LV_BAL  TYPE ZSTABILITY-BALANCE_QTY,
          LV_IDX  TYPE SY-TABIX.

    LOOP AT ER_DATA_CHANGED->MT_GOOD_CELLS INTO LS_MOD.
      IF LS_MOD-FIELDNAME = 'WQTY'.
        LV_IDX = LS_MOD-ROW_ID.
        READ TABLE GT_DATA INTO GS_DATA INDEX LV_IDX.
        IF SY-SUBRC = 0.
          LV_WQTY = LS_MOD-VALUE.
          LV_BAL  = GS_DATA-BALANCE_QTY.
          IF LV_WQTY > LV_BAL.
            " Error message and cap value to BALANCE_QTY
            ER_DATA_CHANGED->ADD_PROTOCOL_ENTRY(
              EXPORTING
                I_MSGID     = '00'
                I_MSGNO     = '398'
                I_MSGTY     = 'E'
                I_MSGV1     = |WQTY ({ LV_WQTY }) > Balance ({ LV_BAL })|
                I_FIELDNAME = 'WQTY'
                I_ROW_ID    = LV_IDX ).

            " Set the cell back to BALANCE_QTY
            ER_DATA_CHANGED->MODIFY_CELL( I_TABIX     = LV_IDX
                                          I_FIELDNAME = 'WQTY'
                                          I_VALUE     = LV_BAL ).

          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

DATA: GO_EVENTS TYPE REF TO LCL_EVENTS.

*----------------------------------------------------------------------
* Start-of-selection: fetch data
*----------------------------------------------------------------------
START-OF-SELECTION.
*  IF  S_PRFLS-LOW IS INITIAL AND S_PRFLS-HIGH IS INITIAL .
*    REFRESH : S_PRFLS[].
*  ENDIF.


  PERFORM GET_DATA.
  PERFORM BUILD_FIELDCATALOG.
*  PERFORM display_alv.
  CALL SCREEN 100.   " <— instead of PERFORM display_alv / CALL SCREEN 0

*----------------------------------------------------------------------
* Fetch data with filters and business conditions
*----------------------------------------------------------------------
FORM GET_DATA.
  CLEAR: GT_DATA.

*  SELECT
*    plos2,
*    qmnum,
*    anlna,
*    anldt,
*    matnr,
*    inspectionlotobjecttext,
*    werks,
*    charg,
*    lgortcharg,
*    inspectionlotactualquantity,
*    inspectionlotquantityunit,
*    kurztext,
*    primpacktxt,
*    stabicontxt,
*    balance_qty,
*    plos2 AS xblnr
*    FROM zstability
*    INTO CORRESPONDING FIELDS OF TABLE @gt_data
*    WHERE balance_qty       > 0
*      AND inspectionlottype = @c_insplot_type
*      AND qmnum     IN @s_qmnum
*      AND plos2     IN @s_prfls
*      AND anldt     IN @s_anldt ##TOO_MANY_ITAB_FIELDS.


*  SELECT PRUEFLOS       ,
*         QMNUM          ,
*         ANLNA          ,
*         ANLDT          ,
*         ANLZT          ,
*         KTEXTMAT       ,
*         MATNR          ,
*         WERKS          ,
*         CHARG          ,
*         LMENGEIST      ,
*         EINHPROBE      ,
*         KURZTEXT       ,
*         PRIMPACK       ,
*         PRIMPACKTXT
  SELECT *
      FROM ZZSTAB
      INTO TABLE @DATA(IT_ZZSTAB)
      WHERE QMNUM     IN @S_QMNUM
      AND   PLOS2     IN @S_PRFLS
      AND   ANLDT     IN @S_ANLDT .
*    AND   INSPECTIONLOTTYPE = @C_INSPLOT_TYPE .


  SELECT QMNUM , LGORTCHARG
    FROM QMEL
    FOR ALL ENTRIES IN @IT_ZZSTAB
      WHERE QMNUM = @IT_ZZSTAB-QMNUM
       INTO TABLE @DATA(IT_QMEL).

*  SORT IT_ZZSTAB BY PRUEFLOS QMNUM  DESCENDING .
  SORT IT_ZZSTAB BY QMNUM PRUEFLOS.

  DATA LV_AMT TYPE ZZSTAB-WITHDRAW_QTY .

  IF IT_ZZSTAB IS NOT INITIAL .
    SELECT * FROM QAVE
      INTO TABLE @DATA(IT_QAVE)
        FOR ALL ENTRIES IN @IT_ZZSTAB
          WHERE PRUEFLOS = @IT_ZZSTAB-PRUEFLOS .

* Read entries from custom table ZTABW
    SELECT FROM ZSTABW
       FIELDS
      PLOS2,
      MBLNR,
      MJAHR,
      QMNUM,
      WQTY,
      PC,
      M
      FOR ALL ENTRIES IN @IT_ZZSTAB
        WHERE PLOS2 = @IT_ZZSTAB-PRUEFLOS
       INTO TABLE @DATA(LT_ZsTABW).

    SORT LT_ZSTABW BY PLOS2 MBLNR MJAHR.

** REad objnr from QALs
*    select from QALS
*      FIELDS
*      PRUEFLOS,
*      OBJNR,
*      obtyp
*      FOR ALL ENTRIES IN @IT_ZZSTAB
*      WHERE PRUEFLOS = @IT_ZZSTAB-PLOS2
*      INTO TABLE @data(lt_qals).
*
*     sort lt_qals by prueflos.

  ENDIF.
  DATA: GT_STYLE TYPE LVC_T_STYL,
        LS_STYLE TYPE LVC_S_STYL.
  DATA(LV_INDEX) = 0.

  DATA(LT_ZZSTAB_TMP) = IT_ZZSTAB.

  LOOP AT IT_ZZSTAB INTO DATA(WA_ZZSTAB).
*    LV_INDEX += 1.
*    LS_STYLE-   = LV_INDEX.
    ON CHANGE OF WA_ZZSTAB-QMNUM.
      CLEAR: LV_AMT.
    ENDON.

    READ TABLE IT_QAVE INTO DATA(WA_QAVE) WITH KEY PRUEFLOS = WA_ZZSTAB-PRUEFLOS .

    LS_STYLE-FIELDNAME = 'M'.
    LS_STYLE-STYLE = CL_GUI_ALV_GRID=>MC_STYLE_DISABLED. "Non Editable
    APPEND LS_STYLE TO GS_DATA-CELLTAB.


    READ TABLE IT_QMEL INTO  DATA(WA_QMEL) WITH KEY  QMNUM = WA_ZZSTAB-QMNUM       .
    IF SY-SUBRC EQ 0 .
      GS_DATA-LGORTCHARG    = WA_QMEL-LGORTCHARG .
    ENDIF.

    GS_DATA-PLOS2                                  = WA_ZZSTAB-PRUEFLOS             .
    GS_DATA-QMNUM                                  = WA_ZZSTAB-QMNUM                .
    GS_DATA-ANLNA                                  = WA_ZZSTAB-ANLNA                .
    GS_DATA-ANLDT                                  = WA_ZZSTAB-ANLDT                .
*     gs_data-                                     = wa_zzstab-ANLZT                .
    GS_DATA-MATNR                                  = WA_ZZSTAB-MATNR                .

    GS_DATA-WERKS                                  = WA_ZZSTAB-WERKS                .
    GS_DATA-CHARG                                  = WA_ZZSTAB-CHARG                .
    GS_DATA-INSPECTIONLOTOBJECTTEXT                = WA_ZZSTAB-KTEXTMAT             .
    GS_DATA-INSPECTIONLOTACTUALQUANTITY            = WA_ZZSTAB-LMENGEIST            .
    GS_DATA-INSPECTIONLOTQUANTITYUNIT              = WA_ZZSTAB-EINHPROBE            .
    GS_DATA-KURZTEXT                               = WA_ZZSTAB-KURZTEXT             .
    GS_DATA-PRIMPACKTXT                            = WA_ZZSTAB-PRIMPACK             .
    GS_DATA-STABICONTXT                            = WA_ZZSTAB-STABICONTXT          .

    GS_DATA-XBLNR                                  = WA_ZZSTAB-PRUEFLOS             .


*    CLEAR : LV_AMT.
*    DATA(LT_ZZSTAB_TMP) = IT_ZZSTAB.
*    DELETE LT_ZZSTAB_TMP WHERE QMNUM <> WA_ZZSTAB-QMNUM.
*    LOOP AT LT_ZZSTAB_TMP INTO DATA(WA_ZSTB) WHERE QMNUM = WA_ZZSTAB-QMNUM .
*      LV_AMT = WA_ZSTB-WITHDRAW_QTY + LV_AMT .
*      CLEAR : WA_ZSTB .
*    ENDLOOP.
    LV_AMT = LV_AMT + WA_ZZSTAB-WITHDRAW_QTY.

    GS_DATA-BALANCE_QTY   = WA_ZZSTAB-LMENGEIST - LV_AMT     .

*    READ TABLE IT_ZZSTAB INTO  data(WA_ZSTB)  WITH KEY  QMNUM = WA_ZZSTAB-QMNUM  .
    READ TABLE LT_ZZSTAB_TMP INTO  DATA(WA_ZSTB)  WITH KEY  QMNUM = WA_ZZSTAB-QMNUM  .


    IF GS_DATA-ANLNA IS   INITIAL .
      GS_DATA-ANLNA       = WA_ZSTB-ANLNA         .
    ENDIF.
    IF GS_DATA-ANLDT IS   INITIAL .
      GS_DATA-ANLDT       = WA_ZSTB-ANLDT         .
    ENDIF.

    IF GS_DATA-MATNR IS   INITIAL .
      GS_DATA-MATNR       = WA_ZSTB-MATNR         .
    ENDIF.

    IF GS_DATA-WERKS IS   INITIAL .
      GS_DATA-WERKS        = WA_ZSTB-WERKS        .
    ENDIF.

    IF GS_DATA-CHARG IS   INITIAL .
      GS_DATA-CHARG        = WA_ZSTB-CHARG        .
    ENDIF.

    IF GS_DATA-KURZTEXT IS   INITIAL .
      GS_DATA-KURZTEXT     = WA_ZSTB-KURZTEXT     .
    ENDIF.

    IF GS_DATA-PRIMPACKTXT IS   INITIAL .
      GS_DATA-PRIMPACKTXT   = WA_ZSTB-PRIMPACK    .
    ENDIF.

    IF GS_DATA-STABICONTXT IS   INITIAL .
      GS_DATA-STABICONTXT   = WA_ZSTB-STABICONTXT  .
    ENDIF.

    SHIFT GS_DATA-MATNR  LEFT DELETING LEADING '0'.

    gs_Data-UDFLAG = VALUE #( IT_QAVE[ PRUEFLOS = GS_DATA-PLOS2 ]-VBEWERTUNG OPTIONAL ).
    APPEND GS_DATA TO GT_DATA.
    CLEAR : GS_DATA,WA_ZZSTAB.

  ENDLOOP.


  IF GT_DATA IS NOT INITIAL.
    SELECT FROM MATDOC
      FIELDS
      XBLNR,
      ZEILE,
      MBLNR,
      MJAHR,
      BUDAT AS BUDAT,
      USNAM AS USNAM,
      MENGE AS WQTY,
      KOSTL AS CNTR
      FOR ALL ENTRIES IN @GT_DATA
      WHERE RECORD_TYPE = 'MDOC'
        AND XBLNR = @GT_DATA-XBLNR
        AND ZEILE = '001'
        AND CANCELLED = @SPACE
        AND REVERSAL_MOVEMENT = @SPACE
        AND BWART = '201'
      INTO TABLE @DATA(LT_MATDOC).

    SORT LT_MATDOC BY XBLNR.
  ENDIF.

  " Init editable columns
  DATA: LV_TABIX TYPE SY-TABIX,
        LV_CNT   TYPE I.

  SORT GT_DATA BY PLOS2.

  DATA: LV_SEQ TYPE MATDOC-ZEILE.
  IF P_RB1 IS NOT INITIAL.
    DATA(LS_DATA) = VALUE #( GT_DATA[ 1 ] OPTIONAL ).

    LOOP AT LT_MATDOC ASSIGNING FIELD-SYMBOL(<F2>).
      CLEAR: LS_DATA.
      AT NEW XBLNR.
        LV_SEQ = 0.
      ENDAT.
      LV_SEQ += 1.
      <F2>-ZEILE = LV_SEQ.
* PC / M Quantity
      IF P_RB1 IS NOT INITIAL.
        ls_Data-PC  = VALUE #( LT_ZSTABW[ PLOS2 = <F2>-XBLNR
                                          MBLNR = <F2>-MBLNR
                                          MJAHR = <F2>-MJAHR ]-PC OPTIONAL ).

        ls_Data-M  = VALUE #( LT_ZSTABW[ PLOS2 = <F2>-XBLNR
                                         MBLNR = <F2>-MBLNR
                                         MJAHR = <F2>-MJAHR ]-M OPTIONAL ).

      ENDIF.

      IF LV_SEQ = 1.
        READ TABLE GT_DATA ASSIGNING FIELD-SYMBOL(<F1>) WITH KEY XBLNR = <F2>-XBLNR BINARY SEARCH.
        IF SY-SUBRC = 0.
          IF <F1>-MBLNR IS INITIAL.
            MOVE-CORRESPONDING <F2> TO <F1>.
            <F1>-PC = ls_Data-PC.
            <F1>-M = ls_Data-M.
          ENDIF.
        ENDIF.
      ELSE.
        MOVE-CORRESPONDING <F2> TO LS_DATA.
        CLEAR : WA_ZSTB .
        READ TABLE IT_ZZSTAB INTO  WA_ZSTB  WITH KEY  QMNUM = WA_ZZSTAB-QMNUM  .
        IF SY-SUBRC EQ 0 .
          IF LS_DATA-ANLNA IS   INITIAL .
            LS_DATA-ANLNA       = WA_ZSTB-ANLNA         .
          ENDIF.
          IF LS_DATA-ANLDT IS   INITIAL .
            LS_DATA-ANLDT       = WA_ZSTB-ANLDT         .
          ENDIF.

          IF LS_DATA-MATNR IS   INITIAL .
            LS_DATA-MATNR       = WA_ZSTB-MATNR         .
          ENDIF.

          IF LS_DATA-WERKS IS   INITIAL .
            LS_DATA-WERKS        = WA_ZSTB-WERKS        .
          ENDIF.

          IF LS_DATA-CHARG IS   INITIAL .
            LS_DATA-CHARG        = WA_ZSTB-CHARG        .
          ENDIF.

          IF LS_DATA-KURZTEXT IS   INITIAL .
            LS_DATA-KURZTEXT     = WA_ZSTB-KURZTEXT     .
          ENDIF.

          IF LS_DATA-PRIMPACKTXT IS   INITIAL .
            LS_DATA-PRIMPACKTXT   = WA_ZSTB-PRIMPACK    .
          ENDIF.

          IF LS_DATA-STABICONTXT IS   INITIAL .
            LS_DATA-STABICONTXT   = WA_ZSTB-STABICONTXT  .
          ENDIF.
        ENDIF.

        SHIFT GS_DATA-MATNR  LEFT DELETING LEADING '0'.
*        READ TABLE
        LS_DATA-PLOS2 = <F2>-XBLNR.
        APPEND LS_DATA TO GT_DATA.
      ENDIF.
      CLEAR: LS_DATA.
    ENDLOOP.
    UNASSIGN <F2>.
    SORT GT_DATA BY PLOS2 ZEILE.
  ENDIF.
ENDFORM.

*----------------------------------------------------------------------
* Build field catalog (WQTY, CNTR editable)
*----------------------------------------------------------------------
FORM BUILD_FIELDCATALOG.
  DATA: LV_CNT TYPE I,
        LV_X   TYPE CHAR1.

  DEFINE ADD_COL.
    CLEAR GS_FCAT.
    ADD 1 TO LV_CNT.
    GS_FCAT-COL_POS = LV_CNT.
    GS_FCAT-FIELDNAME = &1.
    GS_FCAT-COLTEXT   = &2.
    GS_FCAT-OUTPUTLEN = &3.
    GS_FCAT-EDIT      = &4.
    IF &5 = 'X'. GS_FCAT-KEY  = 'X'. ENDIF.
    IF &6 = 'X'. GS_FCAT-CHECKBOX = 'X'. ENDIF.
    IF &1 = 'WQTY'  OR &1 = 'PC' OR &1 = 'M' .
      GS_FCAT-DATATYPE = 'QUAN'.
      GS_FCAT-DECIMALS = 3.
      GS_FCAT-STYLE = 'CELLTAB'.
      IF  P_RB1 = ''.
      GS_FCAT-EDIT       = 'X'.
      ENDIF.
    ENDIF.
* Remove Leading zero for material
    IF &1 = 'MATNR'.
      GS_FCAT-LZERO = 'X'.
    ENDIF.



    APPEND GS_FCAT TO GT_FCAT.
  END-OF-DEFINITION.

*  add_col 'SEL'  'Sel.'  1  'X' '' 'X'.
  LV_CNT = 0.
  IF P_RB1 = 'X'.
    CLEAR LV_X.
  ELSE.
    LV_X = 'X'.
  ENDIF.

  ADD_COL 'PLOS2'                       'Inspection Lot'            15 '' 'X' ''  ##NO_TEXT.
  ADD_COL 'QMNUM'                       'Notification'              12 '' ''  ''  ##NO_TEXT.
  ADD_COL 'ANLNA'                       'Created By'                12 '' ''  ''  ##NO_TEXT.
  ADD_COL 'ANLDT'                       'Created On'                10 '' ''  ''  ##NO_TEXT.
  ADD_COL 'MATNR'                       'Material'                  18 '' ''  ''  ##NO_TEXT.
  ADD_COL 'INSPECTIONLOTOBJECTTEXT'     'Description'               30 '' ''  ''  ##NO_TEXT.
  ADD_COL 'WERKS'                       'Plant'                      4 '' ''  ''  ##NO_TEXT.
  ADD_COL 'CHARG'                       'Batch'                     10 '' ''  ''  ##NO_TEXT.
  ADD_COL 'LGORTCHARG'                  'Storage Location'           4 '' ''  ''  ##NO_TEXT.
  ADD_COL 'INSPECTIONLOTACTUALQUANTITY' 'Actual Lot Quantity'       15 '' ''  ''  ##NO_TEXT.
  ADD_COL 'INSPECTIONLOTQUANTITYUNIT'   'Base UoM'                   5 '' ''  ''  ##NO_TEXT.
  ADD_COL 'KURZTEXT'                    'Sample Container'          20 '' ''  ''  ##NO_TEXT.
  ADD_COL 'PRIMPACKTXT'                 'Primary Packaging'         20 '' ''  ''  ##NO_TEXT.
  ADD_COL 'STABICONTXT'                 'Storage Condition'         20 '' ''  ''  ##NO_TEXT.
  ADD_COL 'BALANCE_QTY'                 'Balance Qty'               15 '' ''  ''  ##NO_TEXT.

  " Editable columns:
*  ADD_COL 'WQTY'                        'Withdraw Qty'              15 LV_X '' ''  ##NO_TEXT.
  ADD_COL 'PC'                     'PC'                      5 LV_X '' ''   ##NO_TEXT.
  ADD_COL 'M'                     'M'                      5 LV_X '' '' ##NO_TEXT.

  ADD_COL 'CNTR'                        'Cost Center'               12 LV_X '' ''  ##NO_TEXT.
  IF P_RB1 IS INITIAL.
    ADD_COL 'REMARKS'                     'Remarks   '                12 '' '' '' ##NO_TEXT.
  ENDIF.
  IF P_RB2 IS INITIAL.
    ADD_COL 'BUDAT'                     'Withdrawal Date'              12 '' '' '' ##NO_TEXT.
    ADD_COL 'USNAM'                     'User Id'                   12 '' '' '' ##NO_TEXT.
    ADD_COL 'MBLNR'                     'Mat.Doc.No'                10 '' '' '' ##NO_TEXT.
    ADD_COL 'MJAHR'                     'Year'                      5 '' '' '' ##NO_TEXT.
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

*    ADD_COL 'MJAHR'                     'Year'                      5 '' '' '' ##NO_TEXT.
  ENDIF.
  ADD_COL 'UDFLAG'                     'UD Flag'                      5 '' '' '' ##NO_TEXT.

  " Layout
  CLEAR GS_LAYOUT.
*  gs_layout-edit = 'X'.
  GS_LAYOUT-ZEBRA = 'X'.
  GS_LAYOUT-CWIDTH_OPT = 'X'. " optimize widths
*  gs_layout-box_fname = 'SEL'.  " show checkboxes in this column

  " ---- Lock everything first, then allow only specific columns ----
  FIELD-SYMBOLS <FC> TYPE LVC_S_FCAT.

*  LOOP AT gt_fcat ASSIGNING <fc>.
*    <fc>-edit = space.
*  ENDLOOP.

*  READ TABLE gt_fcat ASSIGNING <fc> WITH KEY fieldname = 'WQTY'.
*  IF sy-subrc = 0.
*    <fc>-edit = 'X'.
*  ENDIF.
*
*  READ TABLE gt_fcat ASSIGNING <fc> WITH KEY fieldname = 'CNTR'.
*  IF sy-subrc = 0.
*    <fc>-edit = 'X'.
*  ENDIF.

ENDFORM.

*----------------------------------------------------------------------
* Post goods movement (201 to Cost Center) via BAPI
*----------------------------------------------------------------------
FORM POST_GOODS_MOVEMENT.

  DATA: LV_ERRFLAG TYPE C.

  " Sync any pending edits
  IF GO_GRID IS BOUND.
    GO_GRID->CHECK_CHANGED_DATA( ).
  ENDIF.

  GO_GRID->GET_SELECTED_ROWS( IMPORTING ET_INDEX_ROWS = DATA(LT_ROWS)
                                        ET_ROW_NO     = DATA(LT_ROW_NO) ) ##NEEDED.
  DATA: LT_SELECTED TYPE TY_TAB,
        LS_ROW      TYPE TY_ROW.


  LOOP AT GT_DATA INTO DATA(WA_DATA).
    WA_DATA-WQTY = WA_DATA-PC + WA_DATA-M .
    MODIFY GT_DATA FROM WA_DATA TRANSPORTING WQTY.
    CLEAR WA_DATA .
  ENDLOOP.

*    IF GO_GRID IS BOUND.
  GO_GRID->REFRESH_TABLE_DISPLAY( ).
*  ENDIF.

*  " Collect ONLY selected rows
  LOOP AT LT_ROW_NO INTO DATA(LS_ROW_NO) .
    CLEAR: LS_ROW.
    READ TABLE GT_DATA INTO LS_ROW INDEX LS_ROW_NO-ROW_ID.
    IF SY-SUBRC = 0.
      APPEND LS_ROW TO LT_SELECTED.
    ENDIF.
    IF LS_ROW-WQTY IS INITIAL OR LS_ROW-WQTY <= 0.
      LV_ERRFLAG = 'X'.
      MESSAGE S398(00) WITH |Skip { LS_ROW-PLOS2 }: WQTY is initial or <= 0| '' '' ''.
      CONTINUE.
    ENDIF.

    IF LS_ROW-WQTY > LS_ROW-BALANCE_QTY.
      LV_ERRFLAG = 'X'.
      MESSAGE E398(00) WITH |Lot { LS_ROW-PLOS2 }: WQTY ({ LS_ROW-WQTY }) > Balance ({ LS_ROW-BALANCE_QTY })| '' '' '' .
      CONTINUE.
    ENDIF.

    IF LS_ROW-CNTR IS INITIAL.
      LV_ERRFLAG = 'X'.
      MESSAGE E398(00) WITH |Lot { LS_ROW-PLOS2 }: Cost Center is required| '' '' ''.
      CONTINUE.
    ENDIF.

* Check usage decision
    IF LS_ROW-UDFLAG IS NOT INITIAL.
      LV_ERRFLAG = 'X'.
      MESSAGE E398(00) WITH |UD is alredy done for Lot { LS_ROW-PLOS2 }| '' '' ''.
      CONTINUE.
    ENDIF.

    CHECK LV_ERRFLAG IS INITIAL.
  ENDLOOP.

  IF LT_SELECTED IS INITIAL.
    MESSAGE S398(00) WITH TEXT-S03 '' '' ''.
    RETURN.
  ENDIF.

  DATA: LT_ITEMS  TYPE TABLE OF BAPI2017_GM_ITEM_CREATE,
        LS_ITEM   TYPE BAPI2017_GM_ITEM_CREATE,
        LS_HEAD   TYPE BAPI2017_GM_HEAD_01,
        LS_CODE   TYPE BAPI2017_GM_CODE,
        LT_RETURN TYPE TABLE OF BAPIRET2,
        LS_RETURN TYPE BAPIRET2,
        LV_MBLNR  TYPE BAPI2017_GM_HEAD_RET-MAT_DOC,
        LV_MJAHR  TYPE BAPI2017_GM_HEAD_RET-DOC_YEAR,
        LV_ERRORS TYPE I VALUE 0.

  CHECK LV_ERRFLAG IS INITIAL.




  LOOP AT LT_SELECTED INTO LS_ROW.
    " ---- Validations ----


    " ---- Build single-line posting per row (keeps PRUEFLOS as header ref) ----
    CLEAR: LT_ITEMS, LS_ITEM, LS_HEAD, LS_CODE, LT_RETURN, LV_MBLNR, LV_MJAHR.

    LS_HEAD-PSTNG_DATE = SY-DATUM.
    LS_HEAD-DOC_DATE   = SY-DATUM.
    LS_HEAD-HEADER_TXT = |Insp.Lot { GS_DATA-PLOS2 }|. " material slip/ref text
    LS_HEAD-REF_DOC_NO = LS_ROW-PLOS2.
    LS_HEAD-BILL_OF_LADING = LS_ROW-PLOS2.

    LS_CODE-GM_CODE = '03'.  " as requested

    LS_ITEM-MATERIAL  = LS_ROW-MATNR.

    LS_ITEM-MATERIAL  = |{ LS_ITEM-MATERIAL  ALPHA = IN }|.

    LS_ITEM-PLANT     = LS_ROW-WERKS.
    LS_ITEM-STGE_LOC  = LS_ROW-LGORTCHARG.
    LS_ITEM-BATCH     = LS_ROW-CHARG.
    LS_ITEM-MOVE_TYPE = '201'.
    LS_ITEM-ENTRY_QNT = LS_ROW-WQTY.
    LS_ITEM-ENTRY_UOM = LS_ROW-INSPECTIONLOTQUANTITYUNIT.
    LS_ITEM-COSTCENTER = LS_ROW-CNTR.

    APPEND LS_ITEM TO LT_ITEMS.

    CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
      EXPORTING
        GOODSMVT_HEADER  = LS_HEAD
        GOODSMVT_CODE    = LS_CODE
      IMPORTING
        MATERIALDOCUMENT = LV_MBLNR
        MATDOCUMENTYEAR  = LV_MJAHR
      TABLES
        GOODSMVT_ITEM    = LT_ITEMS
        RETURN           = LT_RETURN.

    IF LV_MBLNR IS NOT INITIAL.

      " Commit if OK
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          WAIT = 'X'.
      LS_ROW-REMARKS =  |Posted matdoc { LV_MBLNR }/{ LV_MJAHR } for lot { LS_ROW-PLOS2 } qty { LS_ROW-WQTY }|.

      MOVE-CORRESPONDING LS_ROW TO GS_ZSTABW .
      GS_ZSTABW-MANDT = SY-MANDT .
      GS_ZSTABW-MBLNR = LV_MBLNR .
      GS_ZSTABW-MJAHR = LV_MJAHR .

      MODIFY ZSTABW FROM GS_ZSTABW .
      CLEAR : GS_ZSTABW .
    ELSE.
      READ TABLE LT_RETURN INTO LS_RETURN WITH KEY TYPE = 'E' .
      IF SY-SUBRC = 0.
        LV_ERRORS = LV_ERRORS + 1.
        " Show all messages for this line
*        LOOP AT lt_return INTO ls_return.
*          MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number
*            WITH ls_return-message_v1 ls_return-message_v2 ls_return-message_v3 ls_return-message_v4.
*        ENDLOOP.
*        CONTINUE.
        LS_ROW-REMARKS =  |Error: { LS_RETURN-MESSAGE_V1 } { LS_RETURN-MESSAGE_V2 }|.

      ENDIF.
    ENDIF.

    " Feedback and update local balance
*    MESSAGE s398(00) WITH |Posted matdoc { lv_mblnr }/{ lv_mjahr } for lot { gs_data-plos2 } qty { gs_data-wqty }|.

    " Reflect changes back to main table: reduce balance, clear WQTY, unselect
    READ TABLE GT_DATA INTO GS_DATA WITH KEY PLOS2 = LS_ROW-PLOS2 QMNUM = LS_ROW-QMNUM.
    DATA(LV_IDX) = SY-TABIX.
    IF SY-SUBRC = 0.
      GS_DATA-BALANCE_QTY = GS_DATA-BALANCE_QTY - LS_ROW-WQTY.
      GS_DATA-REMARKS = LS_ROW-REMARKS.
      CLEAR: GS_DATA-WQTY.
      MODIFY GT_DATA FROM GS_DATA INDEX LV_IDX TRANSPORTING BALANCE_QTY WQTY REMARKS.
    ENDIF.
  ENDLOOP.

*  LOOP AT GT_DATA INTO DATA(WA_DATA).
*    WA_DATA-WQTY = WA_DATA-PC + WA_DATA-M .
*    MODIFY GT_DATA FROM WA_DATA TRANSPORTING WQTY.
*    CLEAR WA_DATA .
*  ENDLOOP.

  IF GO_GRID IS BOUND.
    GO_GRID->REFRESH_TABLE_DISPLAY( ).
  ENDIF.

  IF LV_ERRORS > 0.
    MESSAGE S398(00) WITH LV_ERRORS TEXT-S04 '' ''.
  ELSE.
    MESSAGE S398(00) WITH TEXT-S05 '' '' ''.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS 'ZMAIN'.
  SET TITLEBAR 'ZSTAB'.
  PERFORM DISPLAY_ALV_CONTROL.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_CONTROL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_CONTROL .
  DATA: LT_EXCL    TYPE UI_FUNCTIONS,
        GS_VARIANT TYPE DISVARIANT.
  " Guard: only build the grid once
  IF GO_GRID IS INITIAL.

    DATA(LV_GUI_OK) = ABAP_TRUE.
    " Safety: don’t try to open ALV if no frontend or background
    " Block background immediately (controls can't run in background)
    IF SY-BATCH = 'X'.
      MESSAGE TEXT-S06 TYPE 'E'.
    ENDIF.

    " Universal GUI availability check
    CALL FUNCTION 'GUI_IS_AVAILABLE'
      IMPORTING
        RETURN = LV_GUI_OK.

    IF LV_GUI_OK IS INITIAL.
      MESSAGE TEXT-S07 TYPE 'E'.
    ENDIF.

    " Create Custom Container bound to screen 0100
    CREATE OBJECT GO_CUST
      EXPORTING
        CONTAINER_NAME = 'CC_ALV'.

    " Create ALV Grid
    CREATE OBJECT GO_GRID
      EXPORTING
        I_PARENT = GO_CUST.

    " Hook events (you already have lcl_events)
    IF GO_EVENTS IS INITIAL.
      CREATE OBJECT GO_EVENTS.
    ENDIF.
    IF P_RB2 IS NOT INITIAL.
      SET HANDLER GO_EVENTS->ON_TOOLBAR      FOR GO_GRID.
      SET HANDLER GO_EVENTS->ON_USER_COMMAND FOR GO_GRID.
    ENDIF.
    SET HANDLER GO_EVENTS->ON_DATA_CHANGED FOR GO_GRID.

    " (Keep your Save Layout setup)
    GS_VARIANT-REPORT = SY-REPID.
    GS_VARIANT-HANDLE = 'ZSTAB'.

    " Exclude row-creation/deletion (and clipboard) functions
    LT_EXCL = VALUE UI_FUNCTIONS(
      ( CL_GUI_ALV_GRID=>MC_FC_LOC_APPEND_ROW )
      ( CL_GUI_ALV_GRID=>MC_FC_LOC_INSERT_ROW )
      ( CL_GUI_ALV_GRID=>MC_FC_LOC_DELETE_ROW )
      ( CL_GUI_ALV_GRID=>MC_FC_LOC_MOVE_ROW )
      ( CL_GUI_ALV_GRID=>MC_FC_LOC_COPY_ROW )
      ( CL_GUI_ALV_GRID=>MC_FC_LOC_CUT )
      ( CL_GUI_ALV_GRID=>MC_FC_LOC_PASTE )
      ( CL_GUI_ALV_GRID=>MC_FC_LOC_PASTE_NEW_ROW )
*      ( cl_gui_alv_grid=>mc_fc_loc_paste_new_rows )
      ( CL_GUI_ALV_GRID=>MC_FC_LOC_UNDO )
    ).

    GO_GRID->SET_READY_FOR_INPUT( 1 ).

    " First display

    GO_GRID->SET_TABLE_FOR_FIRST_DISPLAY(
      EXPORTING
        IS_LAYOUT            = GS_LAYOUT
        IS_VARIANT           = GS_VARIANT
        I_SAVE               = 'A'            " <-- allow saving variants
        I_DEFAULT            = 'X'            " <-- load user's default on open
        IT_TOOLBAR_EXCLUDING = LT_EXCL    " <— disables create/add/delete/etc.
      CHANGING
        IT_OUTTAB            = GT_DATA
        IT_FIELDCATALOG      = GT_FCAT  ).

*    " Make grid editable
    GO_GRID->SET_READY_FOR_INPUT( 1 ).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.
  PERFORM OK_CODE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form OK_CODE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM OK_CODE .
  CASE SY-UCOMM.
    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
*      LEAVE PROGRAM.
      LEAVE TO SCREEN 0.
*      leave to LIST-PROCESSING.
  ENDCASE.
ENDFORM.
