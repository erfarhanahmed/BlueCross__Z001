*&---------------------------------------------------------------------*
*& Report  ZEXCHANGE_RATE
*&Developed by Jyotsna
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report zexchange_rate_update.

tables : ZMB1B_DOC1,
         vbrk,
         mseg.


data : it_ZMB1B_DOC1 type table of ZMB1B_DOC1,
       wa_ZMB1B_DOC1 type ZMB1B_DOC1.

types : begin of itab1,
          mblnr type mseg-mblnr,
          mjahr type mseg-mjahr,
          vbeln type vbrk-vbeln,
        end of itab1.

types : begin of itab11,
          mblnr type mseg-mblnr,
          mjahr type mseg-mjahr,
          vbeln type vbrk-vbeln,
          werks type mseg-werks,
        end of itab11.

data : it_tab1  type table of itab1,
       wa_tab1  type itab1,
       it_tab11 type table of itab11,
       wa_tab11 type itab11,
       it_tab12 type table of itab11,
       wa_tab12 type itab11.

data : a      type i,
       werks1 type mseg-werks,
       werks  type mseg-werks.

type-pools:  slis.

data: g_repid     like sy-repid,
      fieldcat    type slis_t_fieldcat_alv,
      wa_fieldcat like line of fieldcat,
      sort        type slis_t_sortinfo_alv,
      wa_sort     like line of sort,
      layout      type slis_layout_alv.

selection-screen begin of block merkmale1 with frame title text-001.

PARAMETERS : doc LIKE ZMB1B_DOC1-mblnr.
SELECT-OPTIONS : MBLNR1 FOR MSEG-MBLNR.
parameters : YEAR  LIKE MSEG-MJAHR,
             plant like mseg-werks.
parameters : r2 radiobutton group r1 user-command r2 default 'X',
             r1 radiobutton group r1.
selection-screen end of block merkmale1 .

at selection-screen output.
  if r2 eq 'X'.
    loop at screen.
      if screen-name cp '*DOC*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*MBLNR1*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.

  ELSEIF R1 EQ 'X'.

    loop at screen.
      if screen-name cp '*DOC*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*MBLNR1*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.

  ENDIF.

initialization.
  g_repid = sy-repid.

start-of-selection.

  if year IS INITIAL.
    MESSAGE 'ENTER YEAR' TYPE 'E'.
  ENDIF.
  IF PLANT IS INITIAL.
    MESSAGE 'ENTER PLANT' TYPE 'E'.
  ENDIF.

  if r1 eq 'X'.
    perform display.
  elseif r2 eq 'X'.
    perform update.
  endif.


*ENDFORM.                    "SUMMARY

*&---------------------------------------------------------------------*
*&      Form  TOP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form top.

  data: comment    type slis_t_listheader,
        wa_comment like line of comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'DELIVERY CHALLAN NUMBER FOR TRANSFER DOCUMENT'.
*  WA_COMMENT-INFO = P_FRMDT.
  append wa_comment to comment.

  call function 'REUSE_ALV_COMMENTARY_WRITE'
    exporting
      it_list_commentary = comment
*     I_LOGO             = 'ENJOYSAP_LOGO'
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .

  clear comment.

endform.                    "TOP



*&---------------------------------------------------------------------*
*&      Form  USER_COMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->UCOMM      text
*      -->SELFIELD   text
*----------------------------------------------------------------------*
form user_comm using ucomm like sy-ucomm
                     selfield type slis_selfield.



  case selfield-fieldname.
    when 'VBELN'.
      set parameter id 'VF' field selfield-value.
      call transaction 'VF03' and skip first screen.
    when 'VBELN1'.
      set parameter id 'BV' field selfield-value.
      call transaction 'VL03N' and skip first screen.
    when others.
  endcase.
endform.                    "USER_COMM
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form display .
  if plant is initial.
    message 'ENTER PLANT' type 'I'.
    exit.
  endif.
  select * from ZMB1B_DOC1 into table it_ZMB1B_DOC1 where mblnr IN MBLNR1.
  loop at it_ZMB1B_DOC1 into wa_ZMB1B_DOC1.
    select single * from mseg where mblnr eq wa_ZMB1B_DOC1-mblnr and mjahr eq wa_ZMB1B_DOC1-mjahr and WERKS EQ PLANT.
    if sy-subrc eq 0.
      wa_tab11-mblnr = wa_ZMB1B_DOC1-mblnr.
      wa_tab11-mjahr = wa_ZMB1B_DOC1-mjahr.
      wa_tab11-vbeln = wa_ZMB1B_DOC1-vbeln.
      wa_tab11-werks = PLANT.
      collect wa_tab11 into it_tab11.
      clear wa_tab11.
    ENDIF.
  endloop.

  loop at it_tab11 into wa_tab11 where werks eq plant.
    wa_tab12-mblnr = wa_tab11-mblnr.
    wa_tab12-mjahr = wa_tab11-mjahr.
    wa_tab12-vbeln = wa_tab11-vbeln.
    wa_tab12-werks = wa_tab11-werks.
    collect wa_tab12 into it_tab12.
    clear wa_tab12.
  endloop.

  wa_fieldcat-fieldname = 'MBLNR'.
  wa_fieldcat-seltext_l = 'DOCUMENT NUMBER'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MJAHR'.
  wa_fieldcat-seltext_l = 'DOC YEAR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'VBELN'.
  wa_fieldcat-seltext_l = 'CHALLAN NUMBER'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'WERKS'.
  wa_fieldcat-seltext_l = 'PLANT'.
  append wa_fieldcat to fieldcat.

  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'DELIVERY CHALLAN NUMBER FOR DOCUMENT TRANSFER'.


  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
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
    tables
      t_outtab                = it_tab12
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

endform.
*&---------------------------------------------------------------------*
*&      Form  UPDATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form update .

  wa_tab1-mblnr = doc.
  wa_tab1-mjahr = year.
  wa_tab1-vbeln = space.
  collect wa_tab1 into it_tab1.
  clear wa_tab1.

  wa_fieldcat-fieldname = 'MBLNR'.
  wa_fieldcat-seltext_l = 'MATERIAL DOCUMENT NO.'.
*  wa_fieldcat-edit = 'X'.
  append wa_fieldcat to fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'MJAHR'.
  wa_fieldcat-seltext_l = 'DOC YERA'.
*  wa_fieldcat-edit = 'X'.
  append wa_fieldcat to fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'VBELN'.
  wa_fieldcat-seltext_l = 'DEL. CHALLAN NO.'.
  wa_fieldcat-edit = 'X'.
  append wa_fieldcat to fieldcat.
  CLEAR wa_fieldcat.

  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'UPDATE DELIVERY CHALLAN NUMBER FOR RM TRANSFER DOCUEMENT NUMBER'.

  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = g_repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
      i_callback_user_command = 'USER_COMM1'
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
    tables
      t_outtab                = it_tab1
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

endform.

form user_comm1 using ucomm like sy-ucomm selfield type slis_selfield.
*  IF R1 EQ 'X'.
  case sy-ucomm. "SELFIELD-FIELDNAME.
*      loop at it_tab5 into wa_tab5 WHERE nsampqty ne 0 AND chk ne 'X'.
*        MESSAGE 'TICK THE CHECKBOX TO SAVE DATA' TYPE 'E'.
*      ENDLOOP.
*      BREAK-POINT.
    when '&DATA_SAVE'(001).
*      message 'TERRITORY SAVED 1' type 'I'.
*      PERFORM BDC.
      perform edit.
    when others.
  endcase.
  exit.
endform.                    "USER_COMM
*&---------------------------------------------------------------------*
*&      Form  EDIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form edit.

  select * from ZMB1B_DOC1 into table it_ZMB1B_DOC1.
  sort it_ZMB1B_DOC1 descending by mblnr.

  loop at it_tab1 into wa_tab1.
    select single * from mseg where mblnr eq wa_tab1-mblnr and mjahr eq wa_tab1-mjahr and werks eq plant.
    if sy-subrc eq 0.
      werks = mseg-werks.
    else.
      message 'ENTER CORRECT DOCUMENT NUMBER ' type 'E'.
    endif.
    select single * from ZMB1B_DOC1 where mblnr eq wa_tab1-mblnr .
    if sy-subrc eq 0.
      message 'THIS DOCUMENT IS ALREADY MAINTAINED' type 'E'.
    endif.
    select single * from ZMB1B_DOC1 where vbeln eq wa_tab1-vbeln.
    if sy-subrc eq 0.
      select single * from mseg where mblnr eq ZMB1B_DOC1-mblnr and mjahr eq ZMB1B_DOC1-mjahr .
      if sy-subrc eq 0.
        werks1 = mseg-werks.
      endif.
      if werks = werks1.
        message 'THIS CHALLAN NUMBER IS ALREADY MAINTAINED' type 'E'.
      endif.
    endif.
    if wa_tab1-mblnr eq space.
      message 'ENTER DOCUMENT NUMBER' type 'E'.
    endif.
    if wa_tab1-mjahr eq space.
      message 'ENTER YEAR' type 'E'.
    endif.
    if wa_tab1-vbeln eq space.
      message 'ENTER DELIVERY CHALLAN NUMBER' type 'E'.
    endif.

    wa_ZMB1B_DOC1-mblnr = wa_tab1-mblnr.
    wa_ZMB1B_DOC1-mjahr = wa_tab1-mjahr.
    wa_ZMB1B_DOC1-vbeln = wa_tab1-vbeln.
    insert into ZMB1B_DOC1 values wa_ZMB1B_DOC1.
    if sy-subrc eq 0.
      a = 1.
    endif.
    clear wa_ZMB1B_DOC1.
  endloop.

  if a eq 1.
    message 'DATA UPDATED' type 'I'.
  endif.
*  exit.
  call  transaction 'ZTRF_CHALLAN1'.
  leave to screen 0.
endform.
