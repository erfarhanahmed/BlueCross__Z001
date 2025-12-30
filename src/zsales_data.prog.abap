*&---------------------------------------------------------------------*
*& Report  ZSALES_DATA1
*& DEVELOPED BY JYOTSNA  5.4.24
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zsales_data6.

TYPE-POOLS:  slis.

DATA: g_repid     LIKE sy-repid,
      fieldcat    TYPE slis_t_fieldcat_alv,
      wa_fieldcat LIKE LINE OF fieldcat,
      sort        TYPE slis_t_sortinfo_alv,
      wa_sort     LIKE LINE OF sort,
      layout      TYPE slis_layout_alv.


TABLES: zsales_tab1,
        zcredit_tab1,
        zdebit_tab1,
        marc,
        makt,
        t001l.

DATA: loc(6) TYPE c.
DATA: gross TYPE p DECIMALS 2.

DATA: it_zsales_tab1  TYPE TABLE OF zsales_tab1,
      wa_zsales_tab1  TYPE zsales_tab1,
      it_zcredit_tab1 TYPE TABLE OF zcredit_tab1,
      wa_zcredit_tab1 TYPE zcredit_tab1,
      it_zdebit_tab1  TYPE TABLE OF zdebit_tab1,
      wa_zdebit_tab1  TYPE zdebit_tab1.

TYPES: BEGIN OF mat1,
         matnr TYPE mara-matnr,
       END OF mat1.

TYPES: BEGIN OF mat2,
         matnr TYPE mara-matnr,
         sale  TYPE p DECIMALS 2,
         cn    TYPE p DECIMALS 2,
         dn    TYPE p DECIMALS 2,
       END OF mat2.

TYPES: BEGIN OF itab1,
         matnr  TYPE mara-matnr,
         sale   TYPE p DECIMALS 2,
         cn     TYPE p DECIMALS 2,
         dn     TYPE p DECIMALS 2,
         gross  TYPE p DECIMALS 2,
         loc(6) TYPE c,
         maktx  TYPE makt-maktx,
       END OF itab1.

TYPES: BEGIN OF itab2,
         cnt(1) TYPE c,
         loc(6) TYPE c,
         sale   TYPE p DECIMALS 2,
         cn     TYPE p DECIMALS 2,
         dn     TYPE p DECIMALS 2,
         gross  TYPE p DECIMALS 2,
       END OF itab2.

TYPES: BEGIN OF itab3,
         loc(15) TYPE c,
         sale    TYPE p DECIMALS 2,
         cn      TYPE p DECIMALS 2,
         dn      TYPE p DECIMALS 2,
         gross   TYPE p DECIMALS 2,
         ctot1   TYPE p,
         cnt(1)  TYPE c,
       END OF itab3.

*types: begin of itab4,
*         loc(15)   type c,
*         sale(15)  type c,
*         cn(15)    type c,
*         dn(15)    type c,
*         gross(15) type c,
*         ctot(15)  type c,
*         cnt(1)    type c,
*       end of itab4.

DATA: it_mat1 TYPE TABLE OF mat1,
      wa_mat1 TYPE mat1,
      it_mat2 TYPE TABLE OF mat2,
      wa_mat2 TYPE mat2,
      it_tab1 TYPE TABLE OF itab1,
      wa_tab1 TYPE itab1,
      it_tab2 TYPE TABLE OF itab2,
      wa_tab2 TYPE itab2,
      it_tab3 TYPE TABLE OF itab3,
      wa_tab3 TYPE itab3,
      it_tab4 TYPE TABLE OF zsr1m,
      wa_tab4 TYPE zsr1m.

DATA: tgross TYPE p DECIMALS 2,
      tsale  TYPE p DECIMALS 2,
      tcn    TYPE p DECIMALS 2,
      tdn    TYPE p DECIMALS 2.
DATA: totgross TYPE p DECIMALS 2,
      totsale  TYPE p DECIMALS 2,
      totcn    TYPE p DECIMALS 2,
      totdn    TYPE p DECIMALS 2.
DATA: comtot TYPE p DECIMALS 2.
DATA: ctot1  TYPE p,
      tctot1 TYPE p.
DATA: txt1(15) TYPE c.

DATA: wgross TYPE p,
      wsale  TYPE p,
      wcn    TYPE p,
      wdn    TYPE p,
      wctot  TYPE p.

DATA : v_fm TYPE rs38l_fnam.
DATA: format(10) TYPE c.
DATA : control  TYPE ssfctrlop.
DATA : w_ssfcompop TYPE ssfcompop.
DATA: budat1 TYPE sy-datum,
      budat2 TYPE sy-datum.

****************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK merkmale1 WITH FRAME TITLE text-001.
PARAMETERS: r1 RADIOBUTTON GROUP r1,
            r2 RADIOBUTTON GROUP r1.
SELECT-OPTIONS: budat FOR sy-datum.
SELECTION-SCREEN END OF BLOCK merkmale1 .

INITIALIZATION.
  g_repid = sy-repid.

START-OF-SELECTION.



  SELECT * FROM zsales_tab1 INTO TABLE it_zsales_tab1 WHERE datab GE budat-low AND datbi LE budat-high.
  SELECT * FROM zcredit_tab1 INTO TABLE it_zcredit_tab1 WHERE datab GE budat-low AND datbi LE budat-high.
  SELECT * FROM zdebit_tab1 INTO TABLE it_zdebit_tab1 WHERE datab GE budat-low AND datbi LE budat-high.

  LOOP AT it_zsales_tab1 INTO wa_zsales_tab1.
*    write : / wa_zsales_tab1-matnr ,wa_zsales_tab1-net.
    wa_mat1-matnr = wa_zsales_tab1-matnr.
    COLLECT wa_mat1 INTO it_mat1.
    CLEAR wa_mat1.
    wa_mat2-matnr = wa_zsales_tab1-matnr.
    wa_mat2-sale = wa_zsales_tab1-net.
    COLLECT wa_mat2 INTO it_mat2.
    CLEAR wa_mat2.
  ENDLOOP.

  LOOP AT it_zcredit_tab1 INTO wa_zcredit_tab1.
*    write : / wa_zcredit_tab1-matnr ,wa_zcredit_tab1-net.
    wa_mat1-matnr = wa_zcredit_tab1-matnr.
    COLLECT wa_mat1 INTO it_mat1.
    CLEAR wa_mat1.
    wa_mat2-matnr = wa_zcredit_tab1-matnr.
    wa_mat2-cn = wa_zcredit_tab1-net.
    COLLECT wa_mat2 INTO it_mat2.
    CLEAR wa_mat2.
  ENDLOOP.

  LOOP AT it_zdebit_tab1 INTO wa_zdebit_tab1.
*    write : / wa_zdebit_tab1-matnr ,wa_zdebit_tab1-net.
    wa_mat1-matnr = wa_zdebit_tab1-matnr.
    COLLECT wa_mat1 INTO it_mat1.
    CLEAR wa_mat1.
    wa_mat2-matnr = wa_zdebit_tab1-matnr.
    wa_mat2-dn = wa_zdebit_tab1-net.
    COLLECT wa_mat2 INTO it_mat2.
    CLEAR wa_mat2.
  ENDLOOP.

  SORT it_mat1 BY matnr.
  DELETE ADJACENT DUPLICATES FROM it_mat1 COMPARING matnr.

  LOOP AT it_mat1 INTO wa_mat1 .
    CLEAR : loc,gross.
    wa_tab1-matnr = wa_mat1-matnr.
    SELECT SINGLE * FROM makt WHERE matnr EQ wa_mat1-matnr AND spras EQ 'EN'.
    IF sy-subrc EQ 0.
      wa_tab1-maktx = makt-maktx.
    ENDIF.
    READ TABLE it_mat2 INTO wa_mat2 WITH KEY matnr = wa_mat1-matnr.
    IF sy-subrc EQ 0.
      wa_tab1-gross = wa_mat2-sale.
      wa_tab1-cn  = wa_mat2-cn.
      wa_tab1-dn = wa_mat2-dn.
      gross = wa_mat2-sale - wa_mat2-cn + wa_mat2-dn.
      wa_tab1-sale = gross.
    ENDIF.
    SELECT SINGLE * FROM marc WHERE matnr EQ wa_mat1-matnr AND werks GE '2000' AND lgpro NE space.
    IF sy-subrc EQ 0.
*      write : marc-lgpro.
      IF marc-lgpro EQ 'NS01'.
        loc = 'NSK-1'.
      ELSEIF marc-lgpro EQ 'NS02'.
        loc = 'NSK-2'.
      ELSEIF marc-lgpro EQ 'NS03'.
        loc = 'NSK-3'.
      ELSEIF marc-lgpro EQ 'NS04'.
        loc = 'NSK-4'.
      ELSEIF marc-lgpro EQ 'GA01'.
        loc = 'GOA-1'.
      ELSEIF marc-lgpro EQ 'GA02'.
        loc = 'GOA-2'.
      ELSEIF marc-lgpro EQ 'GA03'.
        loc = 'GOA-3'.
      ELSEIF marc-lgpro EQ 'GA04'.
        loc = 'GOA-4'.
      ELSEIF marc-lgpro EQ 'MU01'.
        loc = 'MUM-1'.
      ELSEIF marc-lgpro EQ 'MU02'.
        loc = 'MUM-2'.
      ELSEIF marc-lgpro EQ 'MU03'.
        loc = 'MUM-3'.
      ELSEIF marc-lgpro EQ 'MU04'.
        loc = 'MUM-4'.
      ELSEIF marc-lgpro EQ 'MU05'.
        loc = 'MUM-5'.
      ELSEIF marc-lgpro EQ 'MU06'.
        loc = 'MUM-6'.
      ELSE.
        loc = marc-lgpro.
      ENDIF.
    ENDIF.
    IF loc EQ space.
      SELECT SINGLE * FROM marc WHERE matnr EQ wa_mat1-matnr AND werks EQ '1000'.
      IF sy-subrc EQ 0.
*        write : marc-lgpro.
        IF marc-lgpro EQ 'FG01'.
          loc = 'NSK-1'.
        ELSEIF marc-lgpro EQ 'FG02'.
          loc = 'NSK-2'.
        ELSEIF marc-lgpro EQ 'FG03'.
          loc = 'NSK-3'.
        ELSEIF marc-lgpro EQ 'FG04'.
          loc = 'NSK-4'.
        ENDIF.
      ENDIF.
    ENDIF.
    IF loc EQ space.
      SELECT SINGLE * FROM marc WHERE matnr EQ wa_mat1-matnr AND werks EQ '1001'.
      IF sy-subrc EQ 0.
*        write : marc-lgpro.
        IF marc-lgpro EQ 'FG01'.
          loc = 'GOA-1'.
        ELSEIF marc-lgpro EQ 'FG02'.
          loc = 'GOA-2'.
        ELSEIF marc-lgpro EQ 'FG03'.
          loc = 'GOA-3'.
        ELSEIF marc-lgpro EQ 'FG04'.
          loc = 'GOA-4'.
        ENDIF.
      ENDIF.
    ENDIF.

    wa_tab1-loc = loc.

    COLLECT wa_tab1 INTO it_tab1.
    CLEAR wa_tab1.
  ENDLOOP.

  IF r1 EQ 'X'.
    PERFORM alv.
  ELSE.
    PERFORM sfdet.
  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv .
  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_l = 'PRODUCT CODE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'MAKTX'.
  wa_fieldcat-seltext_l = 'PRODUCT NAME'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'LOC'.
  wa_fieldcat-seltext_l = 'LOCATION'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'GROSS'.
  wa_fieldcat-seltext_l = 'GROSS SALE VALUE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'CN'.
  wa_fieldcat-seltext_l = 'CREDIT NOTE VAL'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'DN'.
  wa_fieldcat-seltext_l = 'DEBIT NOTE VAL'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'SALE'.
  wa_fieldcat-seltext_l = 'NET SALE VALUE'.
  APPEND wa_fieldcat TO fieldcat.





  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'MANUFACTURING LOCATION WISE SALE CN & DN DATA'.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = g_repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
      i_callback_user_command = 'USER_COMM'
      i_callback_top_of_page  = 'TOP'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         =
      is_layout               = layout
      it_fieldcat             = fieldcat
*     IT_EXCLUDING            =
*     IT_SPECIAL_GROUPS       =
*     IT_SORT                 =
*     IT_FILTER               =
*     IS_SEL_HIDE             =
*     I_DEFAULT               = 'X'
      i_save                  = 'A'
*     IS_VARIANT              =
*     IT_EVENTS               =
*     IT_EVENT_EXIT           =
*     IS_PRINT                =
*     IS_REPREP_ID            =
*     I_SCREEN_START_COLUMN   = 0
*     I_SCREEN_START_LINE     = 0
*     I_SCREEN_END_COLUMN     = 0
*     I_SCREEN_END_LINE       = 0
*     I_HTML_HEIGHT_TOP       = 0
*     I_HTML_HEIGHT_END       = 0
*     IT_ALV_GRAPHICS         =
*     IT_HYPERLINK            =
*     IT_ADD_FIELDCAT         =
*     IT_EXCEPT_QINFO         =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER =
*     ES_EXIT_CAUSED_BY_USER  =
    TABLES
      t_outtab                = it_tab1
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.


FORM top.

  DATA: comment    TYPE slis_t_listheader,
        wa_comment LIKE LINE OF comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'MANUFACTURING LOCATION WISE SALE DATA'.
*  WA_COMMENT-INFO = P_FRMDT.
  APPEND wa_comment TO comment.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = comment
*     I_LOGO             = 'ENJOYSAP_LOGO'
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .

  CLEAR comment.

ENDFORM.                    "TOP



*&---------------------------------------------------------------------*
*&      Form  USER_COMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->UCOMM      text
*      -->SELFIELD   text
*----------------------------------------------------------------------*
FORM user_comm USING ucomm LIKE sy-ucomm
                     selfield TYPE slis_selfield.



  CASE selfield-fieldname.
    WHEN 'VBELN'.
      SET PARAMETER ID 'VF' FIELD selfield-value.
      CALL TRANSACTION 'VF03' AND SKIP FIRST SCREEN.
    WHEN 'VBELN1'.
      SET PARAMETER ID 'BV' FIELD selfield-value.
      CALL TRANSACTION 'VL03N' AND SKIP FIRST SCREEN.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.                    "USER_COMM
*&---------------------------------------------------------------------*
*&      Form  SFDET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sfdet .
  CLEAR : comtot.
  LOOP AT it_tab1 INTO wa_tab1.
*    write : / '1A1',wa_tab1-matnr,wa_tab1-loc,wa_tab1-sale,wa_tab1-cn, wa_tab1-dn.
    wa_tab2-loc = wa_tab1-loc.
    wa_tab2-gross = wa_tab1-gross.
    wa_tab2-sale = wa_tab1-sale.
    wa_tab2-cn = wa_tab1-cn.
    wa_tab2-dn = wa_tab1-dn.
    IF wa_tab1-loc CS 'NSK'.
      wa_tab2-cnt = 'A'.
    ELSEIF wa_tab1-loc CS 'GOA'.
      wa_tab2-cnt = 'B'.
    ELSEIF wa_tab1-loc CS 'MUM'.
      wa_tab2-cnt = 'C'.
*    elseif wa_tab1-loc cs 'MUM-2'.
*      wa_tab2-cnt = 'D'.
*    elseif wa_tab1-loc cs 'MUM-3'.
*      wa_tab2-cnt = 'E'.
*    elseif wa_tab1-loc cs 'MUM-4'.
*      wa_tab2-cnt = 'F'.
*    elseif wa_tab1-loc cs 'MUM-5'.
*      wa_tab2-cnt = 'G'.
*    elseif wa_tab1-loc cs 'MUM-6'.
*      wa_tab2-cnt = 'H'.
    ENDIF.
    comtot = comtot + wa_tab1-sale.
    COLLECT wa_tab2 INTO it_tab2 .
    CLEAR wa_tab2.
  ENDLOOP.
  SORT it_tab2 BY cnt loc.
  CLEAR : tgross,tsale,tcn,tdn,totgross.

  LOOP AT it_tab2 INTO wa_tab2.
    CLEAR : ctot1.
    ctot1 = ( wa_tab2-sale / comtot ) * 100.
    tgross = tgross + wa_tab2-gross.
    totgross = totgross + wa_tab2-gross.
    tsale = tsale + wa_tab2-sale.
    totsale = totsale + wa_tab2-sale.
    tcn = tcn + wa_tab2-cn.
    totcn = totcn + wa_tab2-cn.
    tdn = tdn + wa_tab2-dn.
    totdn = totdn + wa_tab2-dn.

    wa_tab3-loc = wa_tab2-loc.
    wa_tab3-gross = wa_tab2-gross.
    wa_tab3-cn = wa_tab2-cn.
    wa_tab3-dn = wa_tab2-dn.
    wa_tab3-sale = wa_tab2-sale.
    wa_tab3-ctot1 = ctot1.
    wa_tab3-cnt = space.
    COLLECT wa_tab3 INTO it_tab3.
    AT END OF cnt.
      CLEAR : txt1,tctot1.
      IF wa_tab2-cnt EQ 'A'.
        txt1 = 'NASHIK TOTAL'.
      ELSEIF wa_tab2-cnt EQ 'B'.
        txt1 = 'GOA TOTAL'.
      ELSEIF wa_tab2-cnt EQ 'C'.
        txt1 = 'OML TOTAL'.
      ENDIF.
*      break-point .
      tctot1 = ( tsale / comtot ) * 100.
*      write : / txt1, tgross,tcn,tdn,tsale,tctot1.
      wa_tab3-loc = txt1.
      wa_tab3-gross = tgross.
      wa_tab3-cn = tcn.
      wa_tab3-dn = tdn.
      wa_tab3-sale = tsale.
      wa_tab3-ctot1 = tctot1.
      wa_tab3-cnt = 'B'.
      APPEND wa_tab3 TO it_tab3.
      CLEAR:  tgross,tsale,tcn,tdn,tctot1,txt1.
    ENDAT.

    AT LAST .
      wa_tab3-loc = 'COMPANY TOTAL'.
      wa_tab3-gross = totgross.
      wa_tab3-cn = totcn.
      wa_tab3-dn = totdn.
      wa_tab3-sale = totsale.
      wa_tab3-ctot1 = 0.
      wa_tab3-cnt = 'B'.
      APPEND wa_tab3 TO it_tab3.
    ENDAT.
    CLEAR wa_tab3.
  ENDLOOP.

  LOOP AT it_tab3 INTO wa_tab3.
    CLEAR : wgross,wsale,wcn,wdn,wctot.
    wgross = wa_tab3-gross.
    wsale = wa_tab3-sale.
    wcn = wa_tab3-cn.
    wdn = wa_tab3-dn.
    wctot = wa_tab3-ctot1.
    wa_tab4-loc = wa_tab3-loc.
    wa_tab4-gross = wgross.
    wa_tab4-sale = wsale.
    wa_tab4-cn = wcn.
    wa_tab4-dn = wdn.
    IF wctot EQ 0 AND wa_tab3-cnt EQ 'B'.
      wa_tab4-ctot = space.
    ELSE.
      wa_tab4-ctot = wctot.
    ENDIF.

    wa_tab4-cnt = wa_tab3-cnt.

    IF wa_tab4-loc EQ 'NSK-1'.
      SELECT SINGLE * FROM t001l WHERE lgort EQ 'NS01'.
      IF sy-subrc EQ 0.
        CONCATENATE wa_tab4-loc '(' t001l-lgobe ')' INTO wa_tab4-loc SEPARATED BY space.
      ENDIF.
    ELSEIF wa_tab4-loc EQ 'NSK-2'.
      SELECT SINGLE * FROM t001l WHERE lgort EQ 'NS02'.
      IF sy-subrc EQ 0.
        CONCATENATE wa_tab4-loc '(' t001l-lgobe ')' INTO wa_tab4-loc SEPARATED BY space.
      ENDIF.
    ELSEIF wa_tab4-loc EQ 'NSK-3'.
      SELECT SINGLE * FROM t001l WHERE lgort EQ 'NS03'.
      IF sy-subrc EQ 0.
        CONCATENATE wa_tab4-loc '(' t001l-lgobe ')' INTO wa_tab4-loc SEPARATED BY space.
      ENDIF.
    ELSEIF wa_tab4-loc EQ 'NSK-4'.
      SELECT SINGLE * FROM t001l WHERE lgort EQ 'NS04'.
      IF sy-subrc EQ 0.
        CONCATENATE wa_tab4-loc '(' t001l-lgobe ')' INTO wa_tab4-loc SEPARATED BY space.
      ENDIF.
    ELSEIF wa_tab4-loc EQ 'GOA-1'.
      SELECT SINGLE * FROM t001l WHERE lgort EQ 'GA01'.
      IF sy-subrc EQ 0.
        CONCATENATE wa_tab4-loc '(' t001l-lgobe ')' INTO wa_tab4-loc SEPARATED BY space.
      ENDIF.
    ELSEIF wa_tab4-loc EQ 'GOA-2'.
      SELECT SINGLE * FROM t001l WHERE lgort EQ 'GA02'.
      IF sy-subrc EQ 0.
        CONCATENATE wa_tab4-loc '(' t001l-lgobe ')' INTO wa_tab4-loc SEPARATED BY space.
      ENDIF.
    ELSEIF wa_tab4-loc EQ 'GOA-3'.
      SELECT SINGLE * FROM t001l WHERE lgort EQ 'GA03'.
      IF sy-subrc EQ 0.
        CONCATENATE wa_tab4-loc '(' t001l-lgobe ')' INTO wa_tab4-loc SEPARATED BY space.
      ENDIF.
    ELSEIF wa_tab4-loc EQ 'GOA-4'.
      SELECT SINGLE * FROM t001l WHERE lgort EQ 'GA04'.
      IF sy-subrc EQ 0.
        CONCATENATE wa_tab4-loc '(' t001l-lgobe ')' INTO wa_tab4-loc SEPARATED BY space.
      ENDIF.

    ELSEIF wa_tab4-loc EQ 'MUM-1'.
      SELECT SINGLE * FROM t001l WHERE lgort EQ 'MU01'.
      IF sy-subrc EQ 0.
        CONCATENATE wa_tab4-loc '(' t001l-lgobe ')' INTO wa_tab4-loc SEPARATED BY space.
      ENDIF.
    ELSEIF wa_tab4-loc EQ 'MUM-2'.
      SELECT SINGLE * FROM t001l WHERE lgort EQ 'MU02'.
      IF sy-subrc EQ 0.
        CONCATENATE wa_tab4-loc '(' t001l-lgobe ')' INTO wa_tab4-loc SEPARATED BY space.
      ENDIF.
    ELSEIF wa_tab4-loc EQ 'MUM-3'.
      SELECT SINGLE * FROM t001l WHERE lgort EQ 'MU03'.
      IF sy-subrc EQ 0.
        CONCATENATE wa_tab4-loc '(' t001l-lgobe ')' INTO wa_tab4-loc SEPARATED BY space.
      ENDIF.
    ELSEIF wa_tab4-loc EQ 'MUM-4'.
      SELECT SINGLE * FROM t001l WHERE lgort EQ 'MU04'.
      IF sy-subrc EQ 0.
        CONCATENATE wa_tab4-loc '(' t001l-lgobe ')' INTO wa_tab4-loc SEPARATED BY space.
      ENDIF.
    ELSEIF wa_tab4-loc EQ 'MUM-5'.
      SELECT SINGLE * FROM t001l WHERE lgort EQ 'MU05'.
      IF sy-subrc EQ 0.
        CONCATENATE wa_tab4-loc '(' t001l-lgobe ')' INTO wa_tab4-loc SEPARATED BY space.
      ENDIF.
    ELSEIF wa_tab4-loc EQ 'MUM-6'.
      SELECT SINGLE * FROM t001l WHERE lgort EQ 'MU06'.
      IF sy-subrc EQ 0.
        CONCATENATE wa_tab4-loc '(' t001l-lgobe ')' INTO wa_tab4-loc SEPARATED BY space.
      ENDIF.

    ENDIF.
    CONDENSE: wa_tab4-gross,wa_tab4-cn,wa_tab4-dn,wa_tab4-ctot,wa_tab4-sale.
    COLLECT wa_tab4 INTO it_tab4.
    CLEAR wa_tab4.
  ENDLOOP.

*  loop at it_tab4 into wa_tab4.
*    write : / '2',wa_tab4-cnt,wa_tab4-loc,wa_tab4-gross,wa_tab4-cn,wa_tab4-dn,wa_tab4-sale,wa_tab4-ctot.
*  endloop.
  DELETE it_tab4 WHERE loc EQ space.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZSR1M'
*     FORMNAME           = 'ZSR9_9'
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
      fm_name            = v_fm
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.

  control-no_open   = 'X'.
  control-no_close  = 'X'.


  CALL FUNCTION 'SSF_OPEN'
    EXPORTING
      control_parameters = control.
*  SORT IT_CHECK BY REG.

  budat1 = budat-low.
  budat2 = budat-high.

  CALL FUNCTION v_fm
    EXPORTING
      control_parameters = control
      user_settings      = 'X'
      output_options     = w_ssfcompop
      format             = format
      budat1             = budat1
      budat2             = budat2
    TABLES
      it_tab1            = it_tab4
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.

  CLEAR : it_tab4,wa_tab4.

  CLEAR : format.

  CLEAR : it_tab4,wa_tab4.
  CALL FUNCTION 'SSF_CLOSE'.
ENDFORM.
