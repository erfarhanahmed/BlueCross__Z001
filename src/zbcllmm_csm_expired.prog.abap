*&---------------------------------------------------------------------*
*& Report  ZBCLLMM_CSM_EXPIRED
*& developed by Jyotsna
*&---------------------------------------------------------------------*
*&this will will give the list of control samples for destruction
*&
*&---------------------------------------------------------------------*
report zbcllmm_csm_expired_1..

tables : mchb,
         mcha,
         makt,
         t001w,
         mch1,
         mbew.

type-pools:  slis.

data: g_repid     like sy-repid,
      fieldcat    type slis_t_fieldcat_alv,
      wa_fieldcat like line of fieldcat,
      sort        type slis_t_sortinfo_alv,
      wa_sort     like line of sort,
      layout      type slis_layout_alv.

data : it_mchb type table of mchb,
       wa_mchb type mchb.

types : begin of itab1,
          chk           type  char5,
          matnr         type mchb-matnr,
          charg         type mchb-charg,
          cspem         type p,
          hsdat         type mcha-hsdat,
          vfdat         type mcha-vfdat,
          date1         type sy-datum,
          maktx         type makt-maktx,
          line_color(4) type c,
          sr            type i,
          vprsv         type mbew-vprsv,
          rate          type mbew-stprs,
          value         type p decimals 2,
        end of itab1.

data: ld_color(1) type c,
      w_plant     type mchb-werks,
      kunnr       type t001w-kunnr.

data : it_tab1 type table of itab1,
       wa_tab1 type itab1,
       it_tab2 type table of itab1,
       wa_tab2 type itab1.

data : date1 type sy-datum,
       count type i,
       value type p decimals 2.

data:
*      goodsmvt_header TYPE BAPI2017_GM_HEAD_RET,
  goodsmvt_code   type bapi2017_gm_code,
  goodsmvt_header type bapi2017_gm_head_01,
  goodsmvt_item   type bapi2017_gm_item_create.
*      goodsmvt_itemt TYPE

data: goodsmvt_itemt        type standard table of bapi2017_gm_item_create,
      return                type standard table of bapiret2,
      goodsmvt_serialnumber type standard table of bapi2017_gm_serialnumber.

data: materialdocument type mkpf-mblnr,
      matdocumentyear  type mkpf-mjahr.

selection-screen begin of block b1 with frame title text-002.
parameters : r1 radiobutton group r1,
             r2 radiobutton group r1.
selection-screen end of block b1.

selection-screen begin of block b2 with frame title text-002.
select-options : material for mchb-matnr.
parameters : plant like mchb-werks.

select-options : pdate for sy-datum.
selection-screen end of block b2.

initialization.
  g_repid = sy-repid.

start-of-selection.


  select * from mchb into table it_mchb where matnr in material and werks eq plant and lgort eq 'CSM' .
  delete it_mchb where cspem eq 0.

  if it_mchb is not initial.
    loop at it_mchb into wa_mchb.
      clear : date1.
*    WRITE : / WA_MCHB-MATNR,WA_MCHB-CHARG, WA_MCHB-CSPEM.
      select single * from mch1 where matnr eq wa_mchb-matnr and charg eq wa_mchb-charg.
      if sy-subrc eq 0.
        w_plant = wa_mchb-werks.
*        WRITE : MCHA-HSDAT,MCHA-VFDAT.
        call function 'RP_CALC_DATE_IN_INTERVAL'
          exporting
            date      = mch1-vfdat
            days      = '00'
            months    = '00'
            signum    = '+'
            years     = '01'
          importing
            calc_date = date1.

*      WRITE:  date1.
        if date1 ge pdate-low and date1 le pdate-high.
          wa_tab1-matnr =  wa_mchb-matnr.
          wa_tab1-charg = wa_mchb-charg.
          wa_tab1-cspem = wa_mchb-cspem.
          wa_tab1-hsdat = mch1-hsdat.
          wa_tab1-vfdat = mch1-vfdat.
          wa_tab1-date1 = date1.
          select single * from makt where matnr eq wa_mchb-matnr and spras eq 'EN'.
          if sy-subrc eq 0.
            wa_tab1-maktx = makt-maktx.
          endif.
          select single * from mbew where matnr eq wa_mchb-matnr and bwkey eq wa_mchb-werks .
          if sy-subrc eq 0.
            wa_tab1-vprsv = mbew-vprsv.
            if mbew-vprsv eq 'S'.
              wa_tab1-rate = mbew-stprs.
            elseif mbew-vprsv eq 'V'.
              wa_tab1-rate = mbew-verpr.
            endif.
          endif.
          clear : value.
          value = wa_tab1-rate * wa_tab1-cspem.
          wa_tab1-value = value.

          ld_color = ld_color + 1.
          if ld_color = 8.
            ld_color = 1.
          endif.
          if date1 lt sy-datum.
            ld_color = 6.
            wa_tab1-chk = 'X'.
          else.
            ld_color = 8.
          endif.
          concatenate 'C' ld_color  into wa_tab1-line_color.

          collect wa_tab1 into it_tab1.
          clear wa_tab1.
        endif.
      endif.
    endloop.
  endif.



  select single * from t001w where werks eq w_plant.
  if sy-subrc eq 0.
    kunnr = t001w-kunnr.
  endif.

*LOOP AT IT_TAB1 INTO WA_TAB1.
*  WRITE : / WA_TAB1-MAKTX,WA_TAB1-MATNR,WA_TAB1-CHARG,WA_TAB1-CSPEM,WA_TAB1-HSDAT,WA_TAB1-VFDAT,WA_TAB1-DATE1.
*ENDLOOP.
  if r1 eq 'X'.
    perform alvdisp.
  elseif r2 eq 'X'.
    perform posting.
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
  if r1 eq 'X'.
    wa_comment-info = 'CLICK ON SAVE BUTTON FOR PRINTOUT'.
  elseif r2 eq 'X'.
    wa_comment-info = 'CLICK ON SAVE BUTTON FOR POSTING'.
  endif.
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
form user_comm using ucomm like sy-ucomm selfield type slis_selfield.
*  IF R1 EQ 'X'.
  case sy-ucomm. "SELFIELD-FIELDNAME.
*      loop at it_tab5 into wa_tab5 WHERE nsampqty ne 0 AND chk ne 'X'.
*        MESSAGE 'TICK THE CHECKBOX TO SAVE DATA' TYPE 'E'.
*      ENDLOOP.
*      BREAK-POINT.
    when 'MATNR'.
      set parameter id 'MAT' field selfield-value.
      call transaction 'MM03' and skip first screen.
    when '&DATA_SAVE'(001).
*      message 'TERRITORY SAVED 1' type 'I'.
*      PERFORM BDC.
      perform print.
    when others.
  endcase.
  exit.

endform.

form user_comm1 using ucomm like sy-ucomm selfield type slis_selfield.
*  IF R1 EQ 'X'.
  case sy-ucomm. "SELFIELD-FIELDNAME.
*      loop at it_tab5 into wa_tab5 WHERE nsampqty ne 0 AND chk ne 'X'.
*        MESSAGE 'TICK THE CHECKBOX TO SAVE DATA' TYPE 'E'.
*      ENDLOOP.
*      BREAK-POINT.
    when 'MATNR'.
      set parameter id 'MAT' field selfield-value.
      call transaction 'MM03' and skip first screen.
    when '&DATA_SAVE'(001).
*      message 'TERRITORY SAVED 1' type 'I'.
*      PERFORM BDC.
      perform post.
      EXIT.
    when others.
  endcase.
  exit.

endform.
*&---------------------------------------------------------------------*
*&      Form  PRINT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form print .
  sort it_tab1 by charg maktx.
  clear : count.
  count = 1.
  loop at it_tab1 into wa_tab1 where chk eq 'X'.
    wa_tab2-sr = count.
    wa_tab2-maktx = wa_tab1-maktx.
    wa_tab2-matnr = wa_tab1-matnr.
    wa_tab2-charg = wa_tab1-charg.
    wa_tab2-cspem = wa_tab1-cspem.
    wa_tab2-hsdat = wa_tab1-hsdat.
    wa_tab2-vfdat = wa_tab1-vfdat.
    wa_tab2-date1 = wa_tab1-date1.
    collect wa_tab2 into it_tab2.
    clear wa_tab2.
    count = count + 1.
  endloop.

  call function 'OPEN_FORM'
    exporting
      device   = 'PRINTER'
      dialog   = 'X'
*     form     = 'ZSR9_1'
      language = sy-langu
    exceptions
      canceled = 1
      device   = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

  call function 'START_FORM'
    exporting
      form        = 'ZCSMDUE'
      language    = sy-langu
    exceptions
      form        = 1
      format      = 2
      unended     = 3
      unopened    = 4
      unused      = 5
      spool_error = 6
      codepage    = 7
      others      = 8.
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.


  loop at it_tab2 into wa_tab2.
    call function 'WRITE_FORM'
      exporting
        element = 'T1'
        window  = 'MAIN'.
  endloop.

  call function 'END_FORM'
    exceptions
      unopened                 = 1
      bad_pageformat_for_print = 2
      spool_error              = 3
      codepage                 = 4
      others                   = 5.
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.
  call function 'CLOSE_FORM'
* IMPORTING
*   RESULT                         =
*   RDI_RESULT                     =
* TABLES
*   OTFDATA                        =
    exceptions
      unopened                 = 1
      bad_pageformat_for_print = 2
      send_error               = 3
      spool_error              = 4
      codepage                 = 5
      others                   = 6.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

  clear : it_tab2,wa_tab2,count.
  leave to transaction 'ZCSMDUE'.
  exit.
endform.
*&---------------------------------------------------------------------*
*&      Form  ALVDISP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form alvdisp .

  loop at it_tab1 into wa_tab1.
    pack wa_tab1-matnr to wa_tab1-matnr.
    condense wa_tab1-matnr.
    modify it_tab1 from wa_tab1 transporting matnr.
  endloop.


  wa_fieldcat-fieldname = 'MAKTX'.
  wa_fieldcat-seltext_l = 'PRODUCT NAME'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_l = 'PRODUCT CODE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CHARG'.
  wa_fieldcat-seltext_l = 'BATCH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CSPEM'.
  wa_fieldcat-seltext_l = 'BLOCKED QTY'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'VPRSV'.
  wa_fieldcat-seltext_l = 'VTYPE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'RATE'.
  wa_fieldcat-seltext_l = 'RATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'VALUE'.
  wa_fieldcat-seltext_l = 'VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'HSDAT'.
  wa_fieldcat-seltext_l = 'MFG. DATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'VFDAT'.
  wa_fieldcat-seltext_l = 'EXP. DATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'DATE1'.
  wa_fieldcat-seltext_l = 'DUE DATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CHK'.
  wa_fieldcat-seltext_l = 'SELECT'.
  wa_fieldcat-checkbox = 'X'.
  wa_fieldcat-edit = 'X'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.



  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'LIST OF CONTROL SAMPLE FOR DESTRUCTION'.
  layout-info_fieldname  = 'LINE_COLOR'.


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
      t_outtab                = it_tab1
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

endform.
*&---------------------------------------------------------------------*
*&      Form  POSTING
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form posting .
  wa_fieldcat-fieldname = 'MAKTX'.
  wa_fieldcat-seltext_l = 'PRODUCT NAME'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_l = 'PRODUCT CODE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CHARG'.
  wa_fieldcat-seltext_l = 'BATCH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CSPEM'.
  wa_fieldcat-seltext_l = 'BLOCKED QTY'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'VPRSV'.
  wa_fieldcat-seltext_l = 'VTYPE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'RATE'.
  wa_fieldcat-seltext_l = 'RATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'VALUE'.
  wa_fieldcat-seltext_l = 'VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'HSDAT'.
  wa_fieldcat-seltext_l = 'MFG. DATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'VFDAT'.
  wa_fieldcat-seltext_l = 'EXP. DATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'DATE1'.
  wa_fieldcat-seltext_l = 'DUE DATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CHK'.
  wa_fieldcat-seltext_l = 'SELECT'.
  wa_fieldcat-checkbox = 'X'.
  wa_fieldcat-edit = 'X'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.



  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'SELECT SAMPLE & SAVE FOR POSTING'.
  layout-info_fieldname  = 'LINE_COLOR'.


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
CLEAR : FIELDCAT,WA_FIELDCAT.
endform.
*&---------------------------------------------------------------------*
*&      Form  POST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form post.
  sort it_tab1 by charg maktx.
  clear : count.
  count = 1.
  loop at it_tab1 into wa_tab1 where chk eq 'X'.
    wa_tab2-sr = count.
    wa_tab2-maktx = wa_tab1-maktx.
    wa_tab2-matnr = wa_tab1-matnr.
    wa_tab2-charg = wa_tab1-charg.
    wa_tab2-cspem = wa_tab1-cspem.
    wa_tab2-hsdat = wa_tab1-hsdat.
    wa_tab2-vfdat = wa_tab1-vfdat.
    wa_tab2-date1 = wa_tab1-date1.
    collect wa_tab2 into it_tab2.
    clear wa_tab2.
    count = count + 1.
  endloop.

*  ******BAPI TO POST***********************


  " Set GM_CODE
  goodsmvt_code-gm_code = '03'  . " Transfer Posting

  " Set Header Line
  goodsmvt_header-pstng_date = sy-datum .
  goodsmvt_header-doc_date   = sy-datum.
  goodsmvt_header-header_txt = 'REMOVAL OF CONTROL SAMPLE'.  "header_txt. "# a description as input
  goodsmvt_header-pr_uname   = sy-uname .
  loop at it_tab2 into wa_tab2.
    " Set Item line
*GOODSMVT_ITEM-MATERIAL   = '000000000000012902'.
*GOODSMVT_ITEM-PLANT      = '1000'.  "p_werks_out .
*GOODSMVT_ITEM-STGE_LOC   = 'CSM'.  "p_lgort_out.
*GOODSMVT_ITEM-BATCH   = 'BDP2615'.  "p_lgort_out.
*GOODSMVT_ITEM-MOVE_TYPE  = '555' .
*GOODSMVT_ITEM-COSTCENTER = '10A'.
*GOODSMVT_ITEM-GL_ACCOUNT = '0000004000'.
*GOODSMVT_ITEM-ENTRY_QNT  = 1 ."p_qty . "# Set your quantity
*
*GOODSMVT_ITEM-MOVE_PLANT = '1000'.  "p_werks_in.
*GOODSMVT_ITEM-MOVE_STLOC = 'CSM'.  "p_lgort_in.
*GOODSMVT_ITEM-MVT_IND    = '' .

    goodsmvt_item-material   = wa_tab2-matnr.
    goodsmvt_item-plant      = plant.  "p_werks_out .
    goodsmvt_item-stge_loc   = 'CSM'.  "p_lgort_out.
    goodsmvt_item-batch   = wa_tab2-charg.  "p_lgort_out.
    goodsmvt_item-move_type  = '555' .
    if plant eq '1000'.
      goodsmvt_item-costcenter = '10Q'.
    elseif plant eq '1001'.
      goodsmvt_item-costcenter = '30Q'.
    endif.

    goodsmvt_item-gl_account = '0000040300'.
    goodsmvt_item-entry_qnt  = wa_tab2-cspem ."p_qty . "# Set your quantity

    goodsmvt_item-move_plant = plant.  "p_werks_in.
    goodsmvt_item-move_stloc = 'CSM'.  "p_lgort_in.
    goodsmvt_item-mvt_ind    = '' .

    append goodsmvt_item to goodsmvt_itemt.
  endloop.
  " set Equipement
***  LOOP AT lt_serial into ls_serial.
***     goodsmv_serialnumber-matdoc_itm = 1 .
***     goodsmv_serialnumber-serialno = ls_serial-serialnr.
***     append goodsmv_serialnumber to goodsmvt_serialnumber.
***  ENDLOOP.
*  BREAK-POINT.
  " Call Good Movement Creation BAPI
  call function 'BAPI_GOODSMVT_CREATE'
    exporting
      goodsmvt_header       = goodsmvt_header
      goodsmvt_code         = goodsmvt_code
*     testrun               = p_testrun "# 'X' "testrun
    importing
      materialdocument      = materialdocument
      matdocumentyear       = matdocumentyear
    tables
      goodsmvt_item         = goodsmvt_itemt
      goodsmvt_serialnumber = goodsmvt_serialnumber
      return                = return.
*  BREAK-POINT.
  if return[] is initial .
*    and p_testrun EQ ' '.
    " commit Transaction
    call function 'BAPI_TRANSACTION_COMMIT'
      exporting
        wait = 'X'.
  else.
*    " Error -> Roll Back
*    call function 'BAPI_TRANSACTION_ROLLBACK'
  endif.

  clear : goodsmvt_itemt,goodsmvt_serialnumber,goodsmvt_header.
  clear : it_tab1,it_tab2.

  write : / 'MATERIAL DOCUMENT IS POSTED',materialdocument.
  message s531(0u) with materialdocument.
  LEAVE TO SCREEN 0.
  EXIT.
*  call transaction 'ZCSMDUE'.
endform.
