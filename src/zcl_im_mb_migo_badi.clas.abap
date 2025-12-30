class ZCL_IM_MB_MIGO_BADI definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_MB_MIGO_BADI .

  data Z_REFDOC type REFDOC .
  data Z_ACTION type GOACTION .
protected section.
private section.

  data Z_DISPLAY type CHAR2 .
  constants Z_CLASS_ID type MIGO_CLASS_ID value 'ZMB_MIGO_BADI' ##NO_TEXT.
  data GT_GOITEM type GOITEM_T .
  data GS_GODYNPRO type GODYNPRO .
  constants C_HC type CHAR2 value 'HC' ##NO_TEXT.
  constants C_HD type CHAR2 value 'HD' ##NO_TEXT.
  constants C_HE type CHAR2 value 'HE' ##NO_TEXT.
  constants C_IC type CHAR2 value 'IC' ##NO_TEXT.
  constants C_ID type CHAR2 value 'ID' ##NO_TEXT.
  constants C_IE type CHAR2 value 'IE' ##NO_TEXT.
  constants C_BC type CHAR2 value 'BC' ##NO_TEXT.
  constants C_BD type CHAR2 value 'BD' ##NO_TEXT.
  constants C_BE type CHAR2 value 'BE' ##NO_TEXT.
  data GT_ALLAUSP type RMCLAUSP_T .
ENDCLASS.



CLASS ZCL_IM_MB_MIGO_BADI IMPLEMENTATION.


  METHOD IF_EX_MB_MIGO_BADI~CHECK_HEADER.

    FIELD-SYMBOLS: <F1> TYPE RMCLAUSP_T,
                   <F2> TYPE GOITEM,
                   <F3> TYPE ZSMIGO_HSCREEN.
    DATA: LS_RETURN TYPE BAPIRET2,
          LV_FLAG   TYPE CHAR1,
          LS_GOITEM TYPE GOITEM.
    TYPES: BEGIN OF TY_OBJEK,
             OBJEK TYPE CUOBN,
           END   OF TY_OBJEK,
           TTY_OBJEK TYPE STANDARD TABLE OF TY_OBJEK.

    DATA: LT_OBJEK TYPE TTY_OBJEK,
          LS_OBJEK TYPE TY_OBJEK.

* Do not validate in case of service PO
    IF   ( Z_ACTION = 'A01' AND Z_REFDOC = 'R01' ).  "GR posting against PO
      ASSIGN ('(SAPLMIGO)GOITEM') TO <F2>.
      IF <F2> IS ASSIGNED.
        LS_GOITEM = <F2>.
*        LV_BWART = <F2>-BWART.

* Do not validate in case of service PO
        SELECT SINGLE BSART INTO @DATA(LV_BSART) FROM EKKO
             WHERE EBELN = @LS_GOITEM-EBELN.
        IF LV_BSART = 'ZSER' OR
           LV_BSART = 'ZSRV'.
          RETURN.
        ENDIF.
      ENDIF.
      UNASSIGN <F2>.

* Validation - Starts.
      DATA: LV_ATNAM TYPE ATNAM VALUE 'ZVENDOR_BATCH'.
      DATA(LT_GOITEM) = GT_GOITEM.
      DELETE LT_GOITEM WHERE TAKE_IT IS INITIAL.
      LT_OBJEK = CORRESPONDING #( LT_GOITEM MAPPING OBJEK = MATNR ).

      CHECK LT_OBJEK IS NOT INITIAL.
      SELECT SINGLE ATINN FROM CABN
                WHERE ATNAM = @LV_ATNAM
                  INTO @DATA(LV_ATINN).

      SELECT FROM INOB AS A
            INNER JOIN KSSK AS B ON B~OBJEK = A~CUOBJ
                                AND B~MAFID = 'O'
                                AND B~KLART = A~KLART
            INNER JOIN KLAH AS C ON C~CLINT = B~CLINT
                                AND C~KLART = B~KLART
            INNER JOIN KSML AS D ON D~CLINT = B~CLINT
                                AND D~IMERK = @LV_ATINN
                                AND D~KLART = B~KLART
           FIELDS
           A~OBJEK,
           A~CUOBJ,
           B~CLINT,
           C~KLART,
           C~CLASS,
           D~IMERK
          FOR ALL ENTRIES IN @LT_OBJEK
           WHERE A~KLART = '023'
             AND A~OBTAB = 'MARA'
             AND A~OBJEK = @LT_OBJEK-OBJEK
            INTO TABLE @DATA(LT_TEMP).
      SORT LT_TEMP BY OBJEK.
* Validation - Ends.

      CLEAR: LT_OBJEK.
      DATA: BEGIN OF WA_OBJ,
              MATNR TYPE MATNR,
              CHARG TYPE CHARG_D,
            END   OF WA_OBJ.
      LOOP AT LT_TEMP INTO DATA(LS_TEMP).
        LOOP AT LT_GOITEM INTO DATA(LWA_GOITEM) WHERE MATNR = LS_TEMP-OBJEK.
          WA_OBJ-MATNR =  LWA_GOITEM-MATNR.
          WA_OBJ-CHARG =  LWA_GOITEM-CHARG.
          LS_OBJEK-OBJEK = WA_OBJ.
          APPEND LS_OBJEK TO LT_OBJEK.
        ENDLOOP.
      ENDLOOP.

      DATA(LV_BWART) = VALUE #( LT_GOITEM[ 1 ]-BWART OPTIONAL ).

      IF LT_TEMP IS NOT INITIAL AND LV_BWART = '101'.
        CLEAR: GT_ALLAUSP.
        ASSIGN ('(SAPLCLFM)ALLAUSP[]') TO <F1>.
        IF <F1> IS ASSIGNED.
          GT_ALLAUSP  = <F1>.
        ENDIF.
        UNASSIGN <F1>.

* in case no record exists
        IF GT_ALLAUSP IS INITIAL.
          LV_FLAG = 'X'.
        ENDIF.

        SORT LT_OBJEK.
        LOOP AT LT_OBJEK INTO LS_OBJEK.
          LOOP AT GT_ALLAUSP INTO DATA(LS_AUSP) WHERE OBJEK = LS_OBJEK-OBJEK
                                                  AND ATINN = LV_ATINN.
            IF LS_AUSP-ATWRT IS INITIAL.
              LV_FLAG = 'X'.
            ENDIF.

          ENDLOOP.
          IF SY-SUBRC <> 0.
            LV_FLAG = 'X'.
          ENDIF.
          IF LV_FLAG IS NOT INITIAL.
            EXIT.
          ENDIF.

        ENDLOOP.

* In case vendor batch doesn't exist

        IF LV_FLAG IS NOT INITIAL.
          LS_RETURN-TYPE    = 'E'.
          LS_RETURN-ID      = 'LB'.
          LS_RETURN-NUMBER  = '045'.
          APPEND LS_RETURN TO ET_BAPIRET2.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD IF_EX_MB_MIGO_BADI~CHECK_ITEM.

*    DATA LO_MSG_LIST TYPE REF TO CL_RECA_MESSAGE_LIST.
*    DATA LT_MSGS     TYPE RE_T_MSG.
*    DATA LS_MSG      TYPE RECAMSG.
*
*    " Get the global message collector
*    LO_MSG_LIST = CL_RECA_MESSAGE_LIST=>GET_INSTANCE( ).
*
*
*    " Read all messages raised so far (MIGO, T160M, BAdIs, standard logic)
**    LO_MSG_LIST->GET_MESSAGES( IMPORTING ET_MESSAGE = LT_MSGS ).
*    LO_MSG_LIST->GET_MESSAGES( IMPORTING ET_MESSAGE = LT_MSGS ).
  ENDMETHOD.


  method IF_EX_MB_MIGO_BADI~HOLD_DATA_DELETE.
  endmethod.


  method IF_EX_MB_MIGO_BADI~HOLD_DATA_LOAD.
  endmethod.


  method IF_EX_MB_MIGO_BADI~HOLD_DATA_SAVE.
  endmethod.


  METHOD if_ex_mb_migo_badi~init.
    APPEND z_class_id TO ct_init.
    clear: gt_goitem.
  ENDMETHOD.


  method IF_EX_MB_MIGO_BADI~LINE_DELETE.
  endmethod.


  METHOD IF_EX_MB_MIGO_BADI~LINE_MODIFY.

    FIELD-SYMBOLS: <F1> TYPE ZSMIGO_HSCREEN,
                   <F2> TYPE ANY.

    EXPORT CS_GOITEM FROM CS_GOITEM TO MEMORY ID 'Z_GOITEM'.

    IF Z_ACTION = 'A04' AND Z_REFDOC = 'R02'. "GR Display

      ASSIGN ('(ZMIGO_HSCREEN)GWA_ZMIGOH') TO <F1>.
      IF <F1> IS ASSIGNED.
        SELECT SINGLE GTENTNO, GTENTDT INTO ( @<F1>-ZZ_GATEID, @<F1>-ZZ_GATEDT )
                  FROM ZTB_HSMIGO WHERE MBLNR = @CS_GOITEM-MBLNR
                                    AND MJAHR = @CS_GOITEM-MJAHR.
* Sample Control Quantity
        SELECT SINGLE ZZ_SMPQTY, ZZ_INSQTY INTO ( @CS_GOITEM-ZZ_SMPQTY, @CS_GOITEM-ZZ_INSQTY )
            FROM ZTB_MIGOITM WHERE MBLNR = @CS_GOITEM-MBLNR
                                    AND MJAHR = @CS_GOITEM-MJAHR
                                    AND ZEILE = @CS_GOITEM-ZEILE.
      ENDIF.
      UNASSIGN <F1>.
      ASSIGN ('(ZMIGO_HSCREEN)ZZ_SMPQTY') TO <F2>.
      IF <F2> IS ASSIGNED.
        <F2> = CS_GOITEM-ZZ_SMPQTY.
      ENDIF.
      ASSIGN ('(ZMIGO_HSCREEN)ZZ_INSQTY') TO <F2>.
      IF <F2> IS ASSIGNED.
        <F2> = CS_GOITEM-ZZ_INSQTY.
      ENDIF.

      UNASSIGN <F2>.
    ENDIF.
* GR against PO posting
    IF Z_ACTION = 'A01' AND Z_REFDOC = 'R01'. "GR Posting
      ASSIGN ('(ZMIGO_HSCREEN)GWA_ZMIGOH') TO <F1>.
      IF <F1> IS ASSIGNED.
        <F1>-EBELN =  CS_GOITEM-EBELN.
        UNASSIGN <F1>.
      ENDIF.
    ENDIF.

* GR against Production order posting
*    IF Z_ACTION = 'A01' AND Z_REFDOC = 'R08'. "GR Posting
    READ TABLE GT_GOITEM WITH KEY ZEILE = CS_GOITEM-ZEILE TRANSPORTING NO FIELDS.
    DATA(LV_IDX) = SY-TABIX.
    IF SY-SUBRC <> 0.
      APPEND CS_GOITEM TO GT_GOITEM.
    ELSE.
      MODIFY GT_GOITEM FROM CS_GOITEM INDEX LV_IDX.
    ENDIF.

* Charactarstics

*    FIELD-SYMBOLS: <F3> TYPE RMCLAUSP_T.
*    TYPES: BEGIN OF TY_OBJEK,
*             OBJEK TYPE CUOBN,
*           END   OF TY_OBJEK,
*           TTY_OBJEK TYPE STANDARD TABLE OF TY_OBJEK.
*
*    DATA: LT_ALLAUSP TYPE RMCLAUSP_T,
*          LT_OBJEK   TYPE TTY_OBJEK.
*    DATA: LV_ATNAM TYPE ATNAM VALUE 'ZVENDOR_BATCH'.
** Temp starts
**    LT_OBJEK = CORRESPONDING #( GT_GOITEM MAPPING OBJEK = MATNR ).
*** Read the ATINN
**    SELECT SINGLE ATINN FROM CABN
**              WHERE ATNAM = @LV_ATNAM
**                INTO @DATA(LV_ATINN).
**
**    SELECT FROM INOB AS A
**          INNER JOIN KSSK AS B ON B~OBJEK = A~CUOBJ
**                              AND B~MAFID = 'O'
**                              AND B~KLART = A~KLART
**          INNER JOIN KLAH AS C ON C~CLINT = B~CLINT
**                              AND C~KLART = B~KLART
**          INNER JOIN KSML AS D ON D~CLINT = B~CLINT
**                              AND D~IMERK = @LV_ATINN
**                              AND D~KLART = B~KLART
**         FIELDS
**         A~OBJEK,
**         A~CUOBJ,
**         B~CLINT,
**         C~KLART,
**         C~CLASS,
**         D~IMERK
**        FOR ALL ENTRIES IN @LT_OBJEK
**         WHERE A~KLART = '023'
**           AND A~OBTAB = 'MARA'
**           AND A~OBJEK = @LT_OBJEK-OBJEK
**          INTO TABLE @DATA(LT_TEMP).
**    SORT LT_TEMP BY OBJEK.
*
** Temp ends
*    ASSIGN ('(SAPLCLFM)ALLAUSP[]') TO <F3>.
*    IF <F3> IS ASSIGNED AND SY-SUBRC = 0.
*      LOOP AT <F3> INTO DATA(LWA_AUSP).
*        READ TABLE GT_ALLAUSP INTO DATA(LWA_TEMP) WITH KEY OBJEK = LWA_AUSP-OBJEK.
*        LV_IDX = SY-TABIX.
*        IF SY-SUBRC <> 0.
*          APPEND LWA_AUSP TO GT_ALLAUSP.
*        ELSEIF SY-SUBRC = 0.
*          MODIFY GT_ALLAUSP FROM LWA_AUSP INDEX LV_IDX.
*        ENDIF.
*      ENDLOOP.
*    ENDIF.

*    ENDIF.
  ENDMETHOD.


  method IF_EX_MB_MIGO_BADI~MAA_LINE_ID_ADJUST.
  endmethod.


  METHOD if_ex_mb_migo_badi~mode_set.

    FIELD-SYMBOLS: <f1> TYPE godynpro.
    DATA: lv_where TYPE string.

    ASSIGN ('(SAPLMIGO)GODYNPRO') TO <f1>.
    IF <f1> IS ASSIGNED.
      gs_godynpro = <f1>.

      IF gs_godynpro-doc_year IS INITIAL.
        lv_where = |MBLNR = '{ gs_godynpro-mat_doc }'  |.
      ELSE.
        lv_where = |MBLNR = '{ gs_godynpro-mat_doc }' and MJAHR = '{ gs_godynpro-doc_year }'  |.
      ENDIF.

      SELECT SINGLE * FROM ztb_hsmigo INTO @DATA(ls_hsmigo)
*                             WHERE mblnr = @gs_godynpro-mat_doc
*                               AND mjahr = @gs_godynpro-doc_year.
                              WHERE (lv_where).
      SELECT SINGLE * FROM ztb_migoitm INTO @DATA(ls_migoitm)
*                            WHERE mblnr = @gs_godynpro-mat_doc
*                              AND mjahr = @gs_godynpro-doc_year.
                              WHERE (lv_where).
* Change
      IF    ( i_action = 'A12' AND i_refdoc = 'R02' ).    "MIGO Change
*        IF gs_godynpro-mat_doc IS NOT INITIAL AND gs_godynpro-doc_year IS NOT INITIAL.

          IF ls_hsmigo IS NOT INITIAL.
            z_display = c_he.     "Header Change
          ENDIF.

          IF ls_migoitm IS NOT INITIAL.
            z_display = c_ie.     "Item Change
          ENDIF.
*        ELSEIF gs_godynpro-mat_doc IS NOT INITIAL AND gs_godynpro-doc_year IS INITIAL.
*        ENDIF.
      ELSEIF    ( i_action = 'A04' AND i_refdoc = 'R02' ).    "MIGO Display
        IF ls_hsmigo IS NOT INITIAL.
          z_display = c_hd.     "Header Display
        ENDIF.

        IF ls_migoitm IS NOT INITIAL.
          z_display = c_id.     "Item Display
        ENDIF.
* Both display
        IF ls_hsmigo IS NOT INITIAL AND ls_migoitm IS NOT INITIAL.
          z_display = c_bd.     "Both display
        ENDIF.
      ENDIF.
    ENDIF.
    UNASSIGN <f1>.

    IF    ( i_action = 'A01' AND i_refdoc = 'R01' ).    "GR Creation against PO
      z_display = c_hc.     "Header Create
*    ELSE.
*      z_display = 'Y'.
    ENDIF.

* Item screen
    IF    ( i_action = 'A01' AND i_refdoc = 'R08' ).    "GR agains Order.
      z_display = c_ic.       "Item Create
    ENDIF.

    z_refdoc = i_refdoc.
    z_action = i_action.
  ENDMETHOD.


  method IF_EX_MB_MIGO_BADI~PAI_DETAIL.
  endmethod.


  method IF_EX_MB_MIGO_BADI~PAI_HEADER.
  endmethod.


  METHOD if_ex_mb_migo_badi~pbo_detail.
    CHECK i_class_id = z_class_id.
    CASE z_display.
      WHEN c_ic OR c_bc.      "Item or Header & Item Create
        e_cprog = 'ZMIGO_HSCREEN'.
        e_dynnr = '0200'.
        e_heading =  'Custom Fields'.

      WHEN c_ie OR c_be.      "Item or Header & Item Change
        e_cprog = 'ZMIGO_HSCREEN'.
        e_dynnr = '0201'.             "Change screen
*        e_dynnr = '0200'.
        e_heading =  'Custom Fields'.
      WHEN c_id OR c_bd.      "Item or Header & Item Display
        e_cprog = 'ZMIGO_HSCREEN'.
        e_dynnr = '0202'.             "Display screen
        e_heading =  'Custom Fields'.
      WHEN OTHERS.
    ENDCASE.

*    IF z_display = '1'.
*      e_cprog = 'ZMIGO_HSCREEN'.
*      e_dynnr = '0200'.
*      e_heading =  'Custom Fields'.
*    ELSEIF z_display = 'X'.
*      e_cprog = 'ZMIGO_HSCREEN'.
*      e_dynnr = '0201'.
*      e_heading =  'Custom Fields'.
*    ENDIF.
  ENDMETHOD.


  METHOD if_ex_mb_migo_badi~pbo_header.

*    IF sy-uname =  'CTPLSM'.
    CHECK i_class_id = z_class_id.
    CASE z_display.
      WHEN c_hc OR c_bc.      "Header or Header & Item Create
        e_cprog = 'ZMIGO_HSCREEN'.
        e_dynnr = '0100'.
        e_heading =  'MIGO Custom Screen'.

      WHEN c_he or c_be.      "Header or Header & Item Change
        e_cprog = 'ZMIGO_HSCREEN'.
        e_dynnr = '0101'.
        e_heading =  'MIGO Custom Screen'.

      WHEN c_hd or c_bd.      "Header or Header & Item display
        e_cprog = 'ZMIGO_HSCREEN'.
        e_dynnr = '0101'.
        e_heading =  'MIGO Custom Screen'.

      WHEN OTHERS.
    ENDCASE.
*      IF z_display = ''.
*        e_cprog = 'ZMIGO_HSCREEN'.
*        e_dynnr = '0100'.
*        e_heading =  'MIGO Custom Screen'.
*      ELSEIF z_display = 'X'.
*        e_cprog = 'ZMIGO_HSCREEN'.
*        e_dynnr = '0101'.
*        e_heading =  'MIGO Custom Screen'.
*      ENDIF.
*    ENDIF.

  ENDMETHOD.


  METHOD IF_EX_MB_MIGO_BADI~POST_DOCUMENT.
    IF   ( Z_ACTION = 'A01' AND Z_REFDOC = 'R01' ).  "GR posting against PO
*      OR ( z_action = 'A01' AND z_refdoc = 'R10' ).
      TYPES: BEGIN OF TY_OBJEK,
               OBJEK TYPE CUOBN,
             END   OF TY_OBJEK,
             TTY_OBJEK TYPE STANDARD TABLE OF TY_OBJEK.

      DATA: LS_HSMIGO TYPE   ZTB_HSMIGO,
            LT_OBJEK  TYPE TTY_OBJEK,
            LS_OBJEK  TYPE TY_OBJEK,
            LV_FLAG   TYPE CHAR1.

      FIELD-SYMBOLS: <F1> TYPE ZSMIGO_HSCREEN,
                     <F2> TYPE ANY,
                     <F3> TYPE RMCLAUSP_T.

* Batch characteristics validation - Step 1 Starts
      DATA: LV_ATNAM TYPE ATNAM VALUE 'ZVENDOR_BATCH'.
      DATA(LT_GOITEM) = GT_GOITEM.
      DELETE LT_GOITEM WHERE TAKE_IT IS INITIAL.
      LT_OBJEK = CORRESPONDING #( LT_GOITEM MAPPING OBJEK = MATNR ).
*      LT_OBJEK = CORRESPONDING #( IT_MSEG MAPPING OBJEK = MATNR ).

* Read the ATINN
      IF LT_OBJEK IS NOT INITIAL.
        SELECT SINGLE ATINN FROM CABN
                  WHERE ATNAM = @LV_ATNAM
                    INTO @DATA(LV_ATINN).

        SELECT FROM INOB AS A
              INNER JOIN KSSK AS B ON B~OBJEK = A~CUOBJ
                                  AND B~MAFID = 'O'
                                  AND B~KLART = A~KLART
              INNER JOIN KLAH AS C ON C~CLINT = B~CLINT
                                  AND C~KLART = B~KLART
              INNER JOIN KSML AS D ON D~CLINT = B~CLINT
                                  AND D~IMERK = @LV_ATINN
                                  AND D~KLART = B~KLART
             FIELDS
             A~OBJEK,
             A~CUOBJ,
             B~CLINT,
             C~KLART,
             C~CLASS,
             D~IMERK
            FOR ALL ENTRIES IN @LT_OBJEK
             WHERE A~KLART = '023'
               AND A~OBTAB = 'MARA'
               AND A~OBJEK = @LT_OBJEK-OBJEK
              INTO TABLE @DATA(LT_TEMP).
        SORT LT_TEMP BY OBJEK.
      ENDIF.
* Batch characteristics validation - Step 1 ends

      LS_HSMIGO-MBLNR = IS_MKPF-MBLNR.
      LS_HSMIGO-MJAHR = IS_MKPF-MJAHR.
      DATA(LV_EBELN) = VALUE #( IT_MSEG[ 1 ]-EBELN OPTIONAL ).

      ASSIGN ('(ZMIGO_HSCREEN)GWA_ZMIGOH') TO <F1>.
      IF <F1> IS ASSIGNED.
        SELECT SINGLE BSART INTO @DATA(LV_BSART) FROM EKKO
*             WHERE EBELN = @<F1>-EBELN.
             WHERE EBELN = @LV_EBELN.
        IF LV_BSART = 'ZSER' OR
           LV_BSART = 'ZSRV'.

        ELSE.
          LS_HSMIGO-GTENTDT = <F1>-ZZ_GATEDT.
          LS_HSMIGO-GTENTNO = <F1>-ZZ_GATEID.

          MODIFY ZTB_HSMIGO FROM LS_HSMIGO.

* Validation against characteristics
* Batch characteristics validation - Step 2 Starts
          ASSIGN ('(SAPLCLFM)ALLAUSP[]') TO <F3>.
          IF <F3> IS ASSIGNED.
            GT_ALLAUSP  = <F3>.
          ENDIF.
          UNASSIGN <F3>.
          DATA: BEGIN OF WA_OBJ,
                  MATNR TYPE MATNR,
                  CHARG TYPE CHARG_D,
                END   OF WA_OBJ.
          CLEAR: LT_OBJEK.
          LOOP AT LT_TEMP INTO DATA(LS_TEMP).
            LOOP AT LT_GOITEM INTO DATA(LWA_GOITEM) WHERE MATNR = LS_TEMP-OBJEK.
              WA_OBJ-MATNR =  LWA_GOITEM-MATNR.
              WA_OBJ-CHARG =  LWA_GOITEM-CHARG.
              LS_OBJEK-OBJEK = WA_OBJ.
              APPEND LS_OBJEK TO LT_OBJEK.
            ENDLOOP.
          ENDLOOP.

          LOOP AT LT_OBJEK INTO LS_OBJEK.
            LOOP AT GT_ALLAUSP INTO DATA(LS_AUSP) WHERE OBJEK = LS_OBJEK-OBJEK
                                                    AND ATINN = LV_ATINN.
              IF LS_AUSP-ATWRT IS INITIAL.
                LV_FLAG = 'X'.
              ENDIF.

            ENDLOOP.
            IF SY-SUBRC <> 0.
              LV_FLAG = 'X'.
            ENDIF.
            IF LV_FLAG IS NOT INITIAL.
              EXIT.
            ENDIF.

          ENDLOOP.
* Batch characteristics validation - Step 2 Ends
        ENDIF.
        CLEAR:<F1>.
        UNASSIGN <F1>.
      ENDIF.

* Batch characteristics validation - Step 3 Starts
*      DATA(LV_BWART) = VALUE #( IT_MSEG[ 1 ]-BWART OPTIONAL ).
      IF LV_FLAG IS NOT INITIAL.
        MESSAGE E045(LB).
      ENDIF.
* Batch characteristics validation - Step 2 ends

* Incase of cancellation
    ELSEIF ( Z_ACTION = 'A03' AND Z_REFDOC = 'R02' ).
      DATA(LS_MSEG) = VALUE #( IT_MSEG[ 1 ] OPTIONAL ).
      IF LS_MSEG IS NOT INITIAL AND ( LS_MSEG-BWART = '102' OR LS_MSEG-BWART = '562' ).
        SELECT SINGLE * FROM ZTB_HSMIGO INTO LS_HSMIGO
                  WHERE MBLNR = LS_MSEG-SMBLN
                    AND MJAHR = LS_MSEG-SJAHR.
        IF SY-SUBRC = 0.
          LS_HSMIGO-GR_CANCELLED = 'X'.
          MODIFY ZTB_HSMIGO FROM LS_HSMIGO.
        ENDIF.

      ENDIF.
    ENDIF.

*
    IF   ( Z_ACTION = 'A01' AND Z_REFDOC = 'R08' ).  "GR posting against Production Order
      DATA: LT_MIGOITM TYPE STANDARD TABLE OF ZTB_MIGOITM,
            LS_MIGOITM TYPE ZTB_MIGOITM.
*      LOOP AT gt_goitem INTO DATA(ls_goitem) WHERE zz_smpqty > 0.
      LOOP AT GT_GOITEM INTO DATA(LS_GOITEM).
        MOVE-CORRESPONDING LS_GOITEM TO LS_MIGOITM.
        LS_MIGOITM-MBLNR = VALUE #( IT_MSEG[ ZEILE = LS_GOITEM-ZEILE ]-MBLNR OPTIONAL ).
        LS_MIGOITM-MJAHR = VALUE #( IT_MSEG[ ZEILE = LS_GOITEM-ZEILE ]-MJAHR OPTIONAL ).
        APPEND LS_MIGOITM TO LT_MIGOITM.
*        ENDIF.
      ENDLOOP.
      MODIFY ZTB_MIGOITM FROM TABLE LT_MIGOITM.

      ASSIGN ('(ZMIGO_HSCREEN)ZZ_SMPQTY') TO <F2>.
      IF <F2> IS ASSIGNED.
        CLEAR: <F2>.
      ENDIF.
      ASSIGN ('(ZMIGO_HSCREEN)ZZ_INSQTY') TO <F2>.
      IF <F2> IS ASSIGNED.
        CLEAR: <F2>.
      ENDIF.

*      lt_migoitm = CORRESPONDING #( FILTER #( gt_goitem WHERE zz_smpqty > conv #( 0 ) )  ).
    ENDIF.

* Change
    IF   ( Z_ACTION = 'A12' AND Z_REFDOC = 'R02' ).
* Check header
      SELECT SINGLE * FROM ZTB_HSMIGO INTO @LS_HSMIGO
                              WHERE MBLNR = @IS_MKPF-MBLNR
                                AND MJAHR = @IS_MKPF-MJAHR.
      IF SY-SUBRC = 0.
        ASSIGN ('(ZMIGO_HSCREEN)GWA_ZMIGOH') TO <F1>.
        IF <F1> IS ASSIGNED.
          LS_HSMIGO-GTENTDT = <F1>-ZZ_GATEDT.
          LS_HSMIGO-GTENTNO = <F1>-ZZ_GATEID.

          MODIFY ZTB_HSMIGO FROM LS_HSMIGO.

        ENDIF.
        CLEAR <F1>.
        UNASSIGN <F1>.
      ENDIF.

* Check GR Change for process order
      SELECT * FROM ZTB_MIGOITM INTO TABLE @LT_MIGOITM
                    FOR ALL ENTRIES IN @IT_MSEG
                          WHERE MBLNR = @IT_MSEG-MBLNR
                            AND MJAHR = @IT_MSEG-MJAHR
                            AND ZEILE = @IT_MSEG-ZEILE.
      IF SY-SUBRC = 0.
      ENDIF.

    ENDIF.
    CLEAR: LS_MSEG, LS_HSMIGO, GT_GOITEM, LT_MIGOITM, Z_DISPLAY.
  ENDMETHOD.


  method IF_EX_MB_MIGO_BADI~PROPOSE_SERIALNUMBERS.
  endmethod.


  method IF_EX_MB_MIGO_BADI~PUBLISH_MATERIAL_ITEM.
  endmethod.


  method IF_EX_MB_MIGO_BADI~RESET.
  endmethod.


  method IF_EX_MB_MIGO_BADI~STATUS_AND_HEADER.
  endmethod.
ENDCLASS.
