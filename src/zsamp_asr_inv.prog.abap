*&---------------------------------------------------------------------*
*& Report  ZSAMP_ASR_INV
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report zsamp_asr_inv5 no standard page heading line-size 300.
tables : zsampasr1,
         vbrk,
         makt,
         pa0001.

types : begin of itab1,
          sampcode  type zsampasr1-sampcode,
          maktx     type makt-maktx,
          vbeln     type zsampasr1-vbeln,
          fkdat     type zsampasr1-fkdat,
          inv_qty   type p,
          empnam    type pa0001-ename,
          req_bynam type pa0001-ename,
        end of itab1.

types : begin of itab2,
          sampcode    type zsampasr1-sampcode,
          maktx       type makt-maktx,
          vbeln       type zsampasr1-vbeln,
*          fkdat     type zsampasr1-fkdat,
          inv_qty(10) type c,
          empnam      type pa0001-ename,
          req_bynam   type pa0001-ename,
        end of itab2.

data: it_tab1 type table of itab1,
      wa_tab1 type itab1,
      it_tab2 type table of itab2,
      wa_tab2 type itab2.
data: invqty type p.

data: it_zsampasr1 type table of zsampasr1,
      wa_zsampasr1 type zsampasr1.
data : v_fm type rs38l_fnam.

data: i_otf       type itcoo    occurs 0 with header line,
      i_tline     like tline    occurs 0 with header line,
      i_record    like solisti1 occurs 0 with header line,
      i_xstring   type xstring,
* Objects to send mail.
      i_objpack   like sopcklsti1 occurs 0 with header line,
      i_objtxt    like solisti1   occurs 0 with header line,
      i_objbin    like solix      occurs 0 with header line,
      i_reclist   like somlreci1  occurs 0 with header line,
* Work Area declarations
      wa_objhead  type soli_tab,
      w_ctrlop    type ssfctrlop,
      w_compop    type ssfcompop,
*      w_return    TYPE ssfcrescl,
      wa_buffer   type string,
* Variables declarations
      v_form_name type rs38l_fnam,
      v_len_in    like sood-objlen.

data: in_mailid type ad_smtpadr.
data : w_return    type ssfcrescl.
data: ntext1(100) type c.
***********************************************************************************************************************
selection-screen begin of block merkmale1 with frame title text-001.
select-options : sdate for vbrk-fkdat,
                 req_by for pa0001-pernr.
parameters : r1 radiobutton group r1,
             r2 radiobutton group r1.
selection-screen end of block merkmale1 .

type-pools:  slis.

data: g_repid     like sy-repid,
      fieldcat    type slis_t_fieldcat_alv,
      wa_fieldcat like line of fieldcat,
      sort        type slis_t_sortinfo_alv,
      wa_sort     like line of sort,
      layout      type slis_layout_alv.
data: ydate1 type sy-datum.

initialization.
  g_repid = sy-repid.

start-of-selection.


  if r2 eq 'X'.
    if sdate is initial.
      message 'ENTER DATE' type 'E'.
    endif.
    perform alvdata.
  elseif r1 eq 'X'.
    perform autodata.
  endif.


*  select * from zsampasr1 into table it_zsampasr1 where fkdat in sdate and inv_qty gt 0 and req_by in req_by.
*  if it_zsampasr1 is initial.
*    message 'NO DATA FOUND' type 'E'.
*  endif.
*
*  loop at it_zsampasr1 into wa_zsampasr1.
*    wa_tab1-sampcode = wa_zsampasr1-sampcode.
*    select single * from makt where matnr eq wa_zsampasr1-sampcode and spras eq 'EN'.
*    if sy-subrc eq 0.
*      wa_tab1-maktx = makt-maktx.
*    endif.
*    wa_tab1-vbeln = wa_zsampasr1-vbeln.
*    wa_tab1-fkdat = wa_zsampasr1-fkdat.
*    select single * from pa0001 where pernr eq wa_zsampasr1-emp and endda ge sy-datum.
*    if sy-subrc eq 0.
*      wa_tab1-empnam = pa0001-ename.
*    endif.
*    wa_tab1-inv_qty = wa_zsampasr1-inv_qty.
*    select single * from pa0001 where pernr eq wa_zsampasr1-req_by and endda ge sy-datum.
*    if sy-subrc eq 0.
*      wa_tab1-req_bynam = pa0001-ename.
*    endif.
*    collect wa_tab1 into it_tab1.
*    clear wa_tab1.
*  endloop.
*  sort it_tab1 by req_bynam empnam sampcode.
**  loop at it_tab1 into wa_tab1.
**    write : / wa_tab1-sampcode,wa_tab1-maktx,wa_tab1-fkdat,wa_tab1-vbeln,wa_tab1-inv_qty,wa_tab1-empnam,wa_tab1-req_bynam.
**  endloop.
*  loop at it_tab1 into wa_tab1.
*    pack wa_tab1-sampcode to wa_tab1-sampcode.
*    condense wa_tab1-sampcode.
*    modify it_tab1 from wa_tab1 transporting sampcode.
*  endloop.
*
*
*
*  if r1 eq 'X'.
*
*    loop at it_tab1 into wa_tab1.
*      wa_tab2-sampcode = wa_tab1-sampcode.
*      wa_tab2-maktx = wa_tab1-maktx.
*      wa_tab2-vbeln = wa_tab1-vbeln.
*      wa_tab2-inv_qty = wa_tab1-inv_qty.
*      wa_tab2-empnam = wa_tab1-empnam.
*      wa_tab2-req_bynam = wa_tab1-req_bynam.
*      collect wa_tab2 into it_tab2.
*      clear wa_tab2.
*    endloop.
*    perform print.
*
*  elseif r2 eq 'X'.
*    perform alv.
*  endif.

*form alv.
*
*  wa_fieldcat-fieldname = 'SAMPCODE'.
*  wa_fieldcat-seltext_l = 'SAMPLE CODE'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'MAKTX'.
*  wa_fieldcat-seltext_l = 'SAMPLE DESCRIPTION'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'FKDAT'.
*  wa_fieldcat-seltext_l = 'INVOICE DATE'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'VBELN'.
*  wa_fieldcat-seltext_l = 'INVOICE NO.'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'INV_QTY'.
*  wa_fieldcat-seltext_l = 'INVOICE QTY.'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'EMPNAM'.
*  wa_fieldcat-seltext_l = 'GIVE TO EMPLOYEE'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'REQ_BYNAM'.
*  wa_fieldcat-seltext_l = 'REQUESTED BY EMPLOYEE'.
*  append wa_fieldcat to fieldcat.
*
*  layout-zebra = 'X'.
*  layout-colwidth_optimize = 'X'.
*  layout-window_titlebar  = 'ASR SAMPLE INVOICE DETAILS'.
*
*
*  call function 'REUSE_ALV_GRID_DISPLAY'
*    exporting
**     I_INTERFACE_CHECK       = ' '
**     I_BYPASSING_BUFFER      = ' '
**     I_BUFFER_ACTIVE         = ' '
*      i_callback_program      = g_repid
**     I_CALLBACK_PF_STATUS_SET          = ' '
*      i_callback_user_command = 'USER_COMM'
*      i_callback_top_of_page  = 'TOP'
**     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
**     I_CALLBACK_HTML_END_OF_LIST       = ' '
**     I_STRUCTURE_NAME        =
**     I_BACKGROUND_ID         = ' '
**     I_GRID_TITLE            =
**     I_GRID_SETTINGS         =
*      is_layout               = layout
*      it_fieldcat             = fieldcat
**     IT_EXCLUDING            =
**     IT_SPECIAL_GROUPS       =
**     IT_SORT                 =
**     IT_FILTER               =
**     IS_SEL_HIDE             =
**     I_DEFAULT               = 'X'
*      i_save                  = 'A'
**     IS_VARIANT              =
**     IT_EVENTS               =
**     IT_EVENT_EXIT           =
**     IS_PRINT                =
**     IS_REPREP_ID            =
**     I_SCREEN_START_COLUMN   = 0
**     I_SCREEN_START_LINE     = 0
**     I_SCREEN_END_COLUMN     = 0
**     I_SCREEN_END_LINE       = 0
**     I_HTML_HEIGHT_TOP       = 0
**     I_HTML_HEIGHT_END       = 0
**     IT_ALV_GRAPHICS         =
**     IT_HYPERLINK            =
**     IT_ADD_FIELDCAT         =
**     IT_EXCEPT_QINFO         =
**     IR_SALV_FULLSCREEN_ADAPTER        =
** IMPORTING
**     E_EXIT_CAUSED_BY_CALLER =
**     ES_EXIT_CAUSED_BY_USER  =
*    tables
*      t_outtab                = it_tab1
*    exceptions
*      program_error           = 1
*      others                  = 2.
*  if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  endif.
*endform.                    "SUMMARY

*&---------------------------------------------------------------------*
*&      Form  TOP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form top.

  data: comment    type slis_t_listheader,
        wa_comment like line of comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'ASR : INVOICED SAMPLE DETAILS'.
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
*&      Form  PRINT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form print .
  call function 'SSF_FUNCTION_MODULE_NAME'
    exporting
      formname           = 'ZSAMPASR'
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    importing
      fm_name            = v_fm
    exceptions
      no_form            = 1
      no_function_module = 2
      others             = 3.

  call function v_fm
    exporting
      ydate1           = ydate1
*     format           = format
*     AUBEL            = AUBEL
*     adrc             = adrc
*     t001w            = t001w
*     J_1IMOCUST       = J_1IMOCUST
*     G_LSTNO          = G_LSTNO
*     WA_ADRC          = WA_ADRC
*     VBKD             = VBKD
*     vbrk             = vbrk
*     fkdat            = fkdat
*     TOTAL            = TOTAL
*     TOTAL1           = TOTAL1
*     VBRK             = VBRK
*     W_TAX            = W_TAX
*     W_VALUE          = W_VALUE
*     SPELL            = SPELL
*     W_DIFF           = W_DIFF
*     EMNAME           = EMNAME
*     RMNAME           = RMNAME
*     CLMDT            = CLMDT
    tables
      it_tab2          = it_tab2
*     it_vbrp          = it_vbrp
*     ITAB_DIVISION    = ITAB_DIVISION
*     ITAB_STORAGE     = ITAB_STORAGE
*     ITAB_PA0002      = ITAB_PA0002
    exceptions
      formatting_error = 1
      internal_error   = 2
      send_error       = 3
      user_canceled    = 4
      others           = 5.


endform.
*&---------------------------------------------------------------------*
*&      Form  ALVDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form alvdata .
  select * from zsampasr1 into table it_zsampasr1 where fkdat in sdate and inv_qty gt 0 and req_by in req_by.
  if it_zsampasr1 is initial.
    message 'NO DATA FOUND' type 'E'.
  endif.

  loop at it_zsampasr1 into wa_zsampasr1.
    wa_tab1-sampcode = wa_zsampasr1-sampcode.
    select single * from makt where matnr eq wa_zsampasr1-sampcode and spras eq 'EN'.
    if sy-subrc eq 0.
      wa_tab1-maktx = makt-maktx.
    endif.
    wa_tab1-vbeln = wa_zsampasr1-vbeln.
    wa_tab1-fkdat = wa_zsampasr1-fkdat.
    select single * from pa0001 where pernr eq wa_zsampasr1-emp and endda ge sy-datum.
    if sy-subrc eq 0.
      wa_tab1-empnam = pa0001-ename.
    endif.
    wa_tab1-inv_qty = wa_zsampasr1-inv_qty.
    select single * from pa0001 where pernr eq wa_zsampasr1-req_by and endda ge sy-datum.
    if sy-subrc eq 0.
      wa_tab1-req_bynam = pa0001-ename.
    endif.
    collect wa_tab1 into it_tab1.
    clear wa_tab1.
  endloop.
  sort it_tab1 by req_bynam empnam sampcode.
*  loop at it_tab1 into wa_tab1.
*    write : / wa_tab1-sampcode,wa_tab1-maktx,wa_tab1-fkdat,wa_tab1-vbeln,wa_tab1-inv_qty,wa_tab1-empnam,wa_tab1-req_bynam.
*  endloop.
  loop at it_tab1 into wa_tab1.
    pack wa_tab1-sampcode to wa_tab1-sampcode.
    condense wa_tab1-sampcode.
    modify it_tab1 from wa_tab1 transporting sampcode.
  endloop.



  wa_fieldcat-fieldname = 'SAMPCODE'.
  wa_fieldcat-seltext_l = 'SAMPLE CODE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MAKTX'.
  wa_fieldcat-seltext_l = 'SAMPLE DESCRIPTION'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'FKDAT'.
  wa_fieldcat-seltext_l = 'INVOICE DATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'VBELN'.
  wa_fieldcat-seltext_l = 'INVOICE NO.'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'INV_QTY'.
  wa_fieldcat-seltext_l = 'INVOICE QTY.'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'EMPNAM'.
  wa_fieldcat-seltext_l = 'GIVE TO EMPLOYEE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'REQ_BYNAM'.
  wa_fieldcat-seltext_l = 'REQUESTED BY EMPLOYEE'.
  append wa_fieldcat to fieldcat.

  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'ASR SAMPLE INVOICE DETAILS'.


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
*&      Form  AUTODATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form autodata .
*  ydate1 = '20220829'.
   ydate1 = sy-datum - 1.
  select * from zsampasr1 into table it_zsampasr1 where fkdat eq ydate1 and inv_qty gt 0 and req_by in req_by.
  if it_zsampasr1 is initial.
    message 'NO DATA FOUND' type 'E'.
  endif.

  loop at it_zsampasr1 into wa_zsampasr1.
    wa_tab1-sampcode = wa_zsampasr1-sampcode.
    select single * from makt where matnr eq wa_zsampasr1-sampcode and spras eq 'EN'.
    if sy-subrc eq 0.
      wa_tab1-maktx = makt-maktx.
    endif.
    wa_tab1-vbeln = wa_zsampasr1-vbeln.
    wa_tab1-fkdat = wa_zsampasr1-fkdat.
    select single * from pa0001 where pernr eq wa_zsampasr1-emp and endda ge sy-datum.
    if sy-subrc eq 0.
      wa_tab1-empnam = pa0001-ename.
    endif.
    clear : invqty.
    invqty = wa_zsampasr1-inv_qty.
    wa_tab1-inv_qty = invqty.
    select single * from pa0001 where pernr eq wa_zsampasr1-req_by and endda ge sy-datum.
    if sy-subrc eq 0.
      wa_tab1-req_bynam = pa0001-ename.
    endif.
    collect wa_tab1 into it_tab1.
    clear wa_tab1.
  endloop.
  sort it_tab1 by req_bynam empnam sampcode.
*  loop at it_tab1 into wa_tab1.
*    write : / wa_tab1-sampcode,wa_tab1-maktx,wa_tab1-fkdat,wa_tab1-vbeln,wa_tab1-inv_qty,wa_tab1-empnam,wa_tab1-req_bynam.
*  endloop.
  loop at it_tab1 into wa_tab1.
    pack wa_tab1-sampcode to wa_tab1-sampcode.
    condense wa_tab1-sampcode.
    modify it_tab1 from wa_tab1 transporting sampcode.
  endloop.





  loop at it_tab1 into wa_tab1.
    wa_tab2-sampcode = wa_tab1-sampcode.
    wa_tab2-maktx = wa_tab1-maktx.
    wa_tab2-vbeln = wa_tab1-vbeln.
    wa_tab2-inv_qty = wa_tab1-inv_qty.
    wa_tab2-empnam = wa_tab1-empnam.
    wa_tab2-req_bynam = wa_tab1-req_bynam.
    collect wa_tab2 into it_tab2.
    clear wa_tab2.
  endloop.
*  perform print.
*  perform email.
  if sy-host eq 'SAPQLT' or sy-host eq 'SAPDEV'.
*  if sy-host eq 'SAPDEV'.
  else.
    perform email1.
  endif.

endform.
*&---------------------------------------------------------------------*
*&      Form  EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form email .

**  call function 'SSF_FUNCTION_MODULE_NAME'
**    exporting
**      formname           = 'ZSAMPASR'
***     VARIANT            = ' '
***     DIRECT_CALL        = ' '
**    importing
**      fm_name            = v_fm
**    exceptions
**      no_form            = 1
**      no_function_module = 2
**      others             = 3.
**
**  call function v_fm
**    exporting
**      ydate1           = ydate1
***     format           = format
***     AUBEL            = AUBEL
***     adrc             = adrc
***     t001w            = t001w
***     J_1IMOCUST       = J_1IMOCUST
***     G_LSTNO          = G_LSTNO
***     WA_ADRC          = WA_ADRC
***     VBKD             = VBKD
***     vbrk             = vbrk
***     fkdat            = fkdat
***     TOTAL            = TOTAL
***     TOTAL1           = TOTAL1
***     VBRK             = VBRK
***     W_TAX            = W_TAX
***     W_VALUE          = W_VALUE
***     SPELL            = SPELL
***     W_DIFF           = W_DIFF
***     EMNAME           = EMNAME
***     RMNAME           = RMNAME
***     CLMDT            = CLMDT
**    tables
**      it_tab2          = it_tab2
***     it_vbrp          = it_vbrp
***     ITAB_DIVISION    = ITAB_DIVISION
***     ITAB_STORAGE     = ITAB_STORAGE
***     ITAB_PA0002      = ITAB_PA0002
**    exceptions
**      formatting_error = 1
**      internal_error   = 2
**      send_error       = 3
**      user_canceled    = 4
**      others           = 5.
*
*
*
**  if sy-host eq 'SAPQLT' or sy-host eq 'SAPDEV'.
*  if sy-host eq 'SAPDEV'.
*  else.
*    if it_tab2 is not initial.  "12.9.21
*
**PERFORM halbemail.
*
*
**LOOP AT IT_EMAIL INTO WA_EMAIL.
*      call function 'SSF_FUNCTION_MODULE_NAME'
*        exporting
*          formname           = 'ZSAMPASR'
**         VARIANT            = ' '
**         DIRECT_CALL        = ' '
*        importing
*          fm_name            = v_fm
*        exceptions
*          no_form            = 1
*          no_function_module = 2
*          others             = 3.
*
**   * Set the control parameter
*      w_ctrlop-getotf = abap_true.
*      w_ctrlop-no_dialog = abap_true.
*      w_compop-tdnoprev = abap_true.
*      w_ctrlop-preview = space.
*      w_compop-tddest = 'LOCL'.
*
*
*      call function v_fm
*        exporting
*          control_parameters = w_ctrlop
*          output_options     = w_compop
*          user_settings      = abap_true
*          ydate1             = ydate1
**         format             = format
**         AUBEL              = AUBEL
**         adrc               = adrc
**         t001w              = t001w
**         J_1IMOCUST         = J_1IMOCUST
**         G_LSTNO            = G_LSTNO
**         WA_ADRC            = WA_ADRC
**         VBKD               = VBKD
**         vbrk               = vbrk
**         fkdat              = fkdat
**         TOTAL              = TOTAL
**         TOTAL1             = TOTAL1
**         VBRK               = VBRK
**         W_TAX              = W_TAX
**         W_VALUE            = W_VALUE
**         SPELL              = SPELL
**         W_DIFF             = W_DIFF
**         EMNAME             = EMNAME
**         RMNAME             = RMNAME
**         CLMDT              = CLMDT
*        importing
*          job_output_info    = w_return " This will have all output
*        tables
*          it_tab2            = it_tab2
**         it_vbrp            = it_vbrp
**         ITAB_DIVISION      = ITAB_DIVISION
**         ITAB_STORAGE       = ITAB_STORAGE
**         ITAB_PA0002        = ITAB_PA0002
*        exceptions
*          formatting_error   = 1
*          internal_error     = 2
*          send_error         = 3
*          user_canceled      = 4
*          others             = 5.
*
*
*      i_otf[] = w_return-otfdata[].
*
** Import Binary file and filesize
*      call function 'CONVERT_OTF'
*        exporting
*          format                = 'PDF'
*          max_linewidth         = 132
*        importing
*          bin_filesize          = v_len_in
*          bin_file              = i_xstring   " This is NOT Binary. This is Hexa
*        tables
*          otf                   = i_otf
*          lines                 = i_tline
*        exceptions
*          err_max_linewidth     = 1
*          err_format            = 2
*          err_conv_not_possible = 3
*          others                = 4.
** Sy-subrc check not checked
*
*
*
**  * Convert Hexa String to Binary format
*      call function 'SCMS_XSTRING_TO_BINARY'
*        exporting
*          buffer     = i_xstring
*        tables
*          binary_tab = i_objbin[].
** Sy-subrc check not required.
*
**    DATA: IN_MAILID TYPE AD_SMTPADR.
*
** Begin of sending email to multiple users
** If business want email to be sent to all users at one time, it can be done
*
** For now we do not want to send 1 email to multiple users
** Mail has to be sent one email at a time
*
**  IF P2 EQ 'X'.
**
**      CLEAR IN_MAILID.
*      in_mailid = 'JYOTSNA@BLUECROSSLABS.COM'.
*      perform send_mail using in_mailid .
*
*
**  ENDLOOP.
*    endif.
*  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  SEND_MAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IN_MAILID  text
*----------------------------------------------------------------------*
form send_mail  using    p_in_mailid.
  data: salutation type string.
  data: body type string.
  data: footer type string.

  data: lo_send_request type ref to cl_bcs,
        lo_document     type ref to cl_document_bcs,
        lo_sender       type ref to if_sender_bcs,
        lo_recipient    type ref to if_recipient_bcs value is initial,lt_message_body type bcsy_text,
        lx_document_bcs type ref to cx_document_bcs,
        lv_sent_to_all  type os_boolean.

  "create send request
  lo_send_request = cl_bcs=>create_persistent( ).

  "create message body and subject
  salutation ='Dear Sir,'.
  append salutation to lt_message_body.
  append initial line to lt_message_body.

  body = 'Please find the attached file for ASR Invoiced Details in PDF format.'.

  append body to lt_message_body.
  append initial line to lt_message_body.

  footer = 'With Regards,'.
  append footer to lt_message_body.
  footer = 'BLUE CROSS LABORATORIES PVT LTD.'.
  append footer to lt_message_body.


  ntext1 = 'ASR Invoiced Details'.

  "put your text into the document


  lo_document = cl_document_bcs=>create_document(
  i_type = 'ASR'
  i_text = lt_message_body
  i_subject = 'ASR INVOICED DETAILS' ).

*DATA: l_size TYPE sood-objlen. " Size of Attachment
*l_size = l_lines * 255.
  try.

      lo_document->add_attachment(
      exporting
      i_attachment_type = 'PDF'
      i_attachment_subject = 'ASR INVOICED DETAILS'
      i_att_content_hex = i_objbin[] ).
    catch cx_document_bcs into lx_document_bcs.

  endtry.



* Add attachment
* Pass the document to send request
  lo_send_request->set_document( lo_document ).

  "Create sender
  lo_sender = cl_sapuser_bcs=>create( sy-uname ).

  "Set sender
  lo_send_request->set_sender( lo_sender ).

  "Create recipient
  lo_recipient = cl_cam_address_bcs=>create_internet_address( in_mailid ).

*Set recipient
  lo_send_request->add_recipient(
  exporting
  i_recipient = lo_recipient
  i_express = abap_true
  ).

  lo_send_request->add_recipient( lo_recipient ).

* Send email
  lo_send_request->send(
  exporting
  i_with_error_screen = abap_true
  receiving
  result = lv_sent_to_all ).

  concatenate 'Email sent to' in_mailid into data(lv_msg) separated by space.
  write:/ lv_msg color col_positive.
  skip.
* Commit Work to send the email
  commit work.
endform.
*&---------------------------------------------------------------------*
*&      Form  EMAIL1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form email1 .
*LOOP AT IT_EMAIL INTO WA_EMAIL.
  if it_tab2 is not initial.
    call function 'SSF_FUNCTION_MODULE_NAME'
      exporting
        formname           = 'ZSAMPASR'
*       VARIANT            = ' '
*       DIRECT_CALL        = ' '
      importing
*       FM_NAME            = V_FM
        fm_name            = v_form_name
      exceptions
        no_form            = 1
        no_function_module = 2
        others             = 3.
    if sy-subrc <> 0.
      message id sy-msgid type sy-msgty number sy-msgno
      with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.

*   * Set the control parameter
    w_ctrlop-getotf = abap_true.
    w_ctrlop-no_dialog = abap_true.
    w_compop-tdnoprev = abap_true.
    w_ctrlop-preview = space.
    w_compop-tddest = 'LOCL'.


    call function v_form_name
*  CALL FUNCTION V_FM
      exporting
        control_parameters = w_ctrlop
        output_options     = w_compop
        user_settings      = abap_true
        ydate1             = ydate1
*       matnr              = matnr
*       maktx              = maktx
*       ztext              = ztext
*       bqty               = bqty
*       meins              = meins
*       mast               = mast
*       kunnr              = kunnr
*       stlan              = wa_check-stlan
*       stlal              = wa_check-stlal
*       shelflife          = shelflife
*       j_1imocust         = j_1imocust
*       g_lstno            = g_lstno
*       wa_adrc            = wa_adrc
*       vbkd               = vbkd
*       vbak               = vbak
*       total              = total
*       total1             = total1
*       vbrk               = vbrk
*       w_tax              = w_tax
*       w_value            = w_value
*       spell              = spell
*       w_diff             = w_diff
*       emname             = emname
*       rmname             = rmname
*       clmdt              = clmdt
      importing
        job_output_info    = w_return " This will have all output
      tables
        it_tab2            = it_tab2
*       itab_division      = itab_division
*       itab_storage       = itab_storage
*       itab_pa0002        = itab_pa0002
      exceptions
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        others             = 5.


    i_otf[] = w_return-otfdata[].

* Import Binary file and filesize
    call function 'CONVERT_OTF'
      exporting
        format                = 'PDF'
        max_linewidth         = 132
      importing
        bin_filesize          = v_len_in
        bin_file              = i_xstring   " This is NOT Binary. This is Hexa
      tables
        otf                   = i_otf
        lines                 = i_tline
      exceptions
        err_max_linewidth     = 1
        err_format            = 2
        err_conv_not_possible = 3
        others                = 4.
* Sy-subrc check not checked



*  * Convert Hexa String to Binary format
    call function 'SCMS_XSTRING_TO_BINARY'
      exporting
        buffer     = i_xstring
      tables
        binary_tab = i_objbin[].
* Sy-subrc check not required.

*    DATA: IN_MAILID TYPE AD_SMTPADR.

* Begin of sending email to multiple users
* If business want email to be sent to all users at one time, it can be done

* For now we do not want to send 1 email to multiple users
* Mail has to be sent one email at a time

*  IF P2 EQ 'X'.
*
*      CLEAR IN_MAILID.
*    in_mailid = 'JYOTSNA@BLUECROSSLABS.COM'.
    in_mailid = 'ashish@bluecrosslabs.com'.
    perform send_mail1 using in_mailid .

*  ENDLOOP.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  SEND_MAIL1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IN_MAILID  text
*----------------------------------------------------------------------*
form send_mail1  using    p_in_mailid.
  data: salutation type string.
  data: body type string.
  data: footer type string.

  data: lo_send_request type ref to cl_bcs,
        lo_document     type ref to cl_document_bcs,
        lo_sender       type ref to if_sender_bcs,
        lo_recipient    type ref to if_recipient_bcs value is initial,lt_message_body type bcsy_text,
        lx_document_bcs type ref to cx_document_bcs,
        lv_sent_to_all  type os_boolean.

  "create send request
  lo_send_request = cl_bcs=>create_persistent( ).

  "create message body and subject
  salutation ='Dear Sir,'.
  append salutation to lt_message_body.
  append initial line to lt_message_body.
*  if r4 eq 'X'.
  body = 'Please find the attached ASR INVOICED DETAILS in PDF format.'.
*  else.
*    body = 'Please find the attached INSPECTION LOTS in PDF format.'.
*  endif.
  append body to lt_message_body.
  append initial line to lt_message_body.

  footer = 'With Regards,'.
  append footer to lt_message_body.
  footer = 'BLUE CROSS LABORATORIES PVT LTD.'.
  append footer to lt_message_body.

*  if r4 eq 'X'.
*  ntext1 = 'HALB LYING FOR MORE THAN 20 DAYS'.
  ntext1 = 'ASR INVOICED DETAILS'.
*  else.
*    ntext1 = 'INSPECTION PLAN NOT ATTACHED'.
*  endif.
  "put your text into the document

*  if r4 eq 'X'.
  lo_document = cl_document_bcs=>create_document(
i_type = 'RAW'
i_text = lt_message_body
*i_subject = 'HALB LYING FOR MORE THAN 20 DAYS' ).
i_subject = 'ASR INVOICED DETAILS' ).

*DATA: l_size TYPE sood-objlen. " Size of Attachment
*l_size = l_lines * 255.
  try.

      lo_document->add_attachment(
      exporting
      i_attachment_type = 'PDF'
*      i_attachment_subject = 'HALB LYING FOR MORE THAN 20 DAYS'
 i_attachment_subject = 'ASR INVOICED DETAILS'
      i_att_content_hex = i_objbin[] ).
    catch cx_document_bcs into lx_document_bcs.

  endtry.
*  else.
*    lo_document = cl_document_bcs=>create_document(
*    i_type = 'RAW'
*    i_text = lt_message_body
*    i_subject = 'INSPECTION PLAN NOT ATTACHED' ).
*
**DATA: l_size TYPE sood-objlen. " Size of Attachment
**l_size = l_lines * 255.
*    try.
*
*        lo_document->add_attachment(
*        exporting
*        i_attachment_type = 'PDF'
*        i_attachment_subject = 'INSPECTION PLAN NOT ATTACHED'
*        i_att_content_hex = i_objbin[] ).
*      catch cx_document_bcs into lx_document_bcs.
*
*    endtry.
*
*  endif.

* Add attachment
* Pass the document to send request
  lo_send_request->set_document( lo_document ).

  "Create sender
  lo_sender = cl_sapuser_bcs=>create( sy-uname ).

  "Set sender
  lo_send_request->set_sender( lo_sender ).

  "Create recipient
  lo_recipient = cl_cam_address_bcs=>create_internet_address( in_mailid ).

*Set recipient
  lo_send_request->add_recipient(
  exporting
  i_recipient = lo_recipient
  i_express = abap_true
  ).

  lo_send_request->add_recipient( lo_recipient ).

* Send email
  lo_send_request->send(
  exporting
  i_with_error_screen = abap_true
  receiving
  result = lv_sent_to_all ).

  concatenate 'Email sent to' in_mailid into data(lv_msg) separated by space.
  write:/ lv_msg color col_positive.
  skip.
* Commit Work to send the email
  commit work.
endform.
