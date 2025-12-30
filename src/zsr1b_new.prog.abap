*&---------------------------------------------------------------------*
*& Report  ZSR1B
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

report  zsr1b_2.

tables : zexpdata,
         zexpbudget,
         zprdgroup,
         makt,
         mvke,
         tvm5t,
         mara,
         t023,
         tvm4t,
         t247,
         t005t,
         t023t,
         zexpestsale.

type-pools:  slis.

data: g_repid     like sy-repid,
      mdatael     type element,
      mdiv        type zprdgroup-grp_div,
      fieldcat    type slis_t_fieldcat_alv,
      wa_fieldcat like line of fieldcat,
      mctryname   like t005t-landx,
      sort        type slis_t_sortinfo_alv,
      wa_sort     like line of sort,
      layout      type slis_layout_alv.

data : it_zexpdata    type table of zexpdata,
       wa_zexpdata    type zexpdata,
       it_zexpbudget  type table of zexpbudget,
       wa_zexpbudget  type zexpbudget,
       it_mara        type table of mara,
       wa_mara        type mara,
       it_t005t       type table of t005t,
       wa_t005t       type t005t,
       it_zexpdata2   type table of zexpdata,
       wa_zexpdata2   type zexpdata,
       it_zsales_tab3 type table of zexpdata,
       wa_zsales_tab3 type zexpdata.

data : l_date      type sy-datum,
       c_date      type sy-datum,
       m_date      type sy-datum,
       pdate1      type sy-datum,
       pdate2      type sy-datum,
       ll_date     type sy-datum,
       lc_date     type sy-datum,
       mdays       type string,
       mctr        type string,
       grpname(25) type c,
       pack1(5)    type c,
       flag(1)     type c,
       ll_mth      type string,
       ll_day      type string,
       ll_yr       type string,
       mmth1       type string,
       mmth2       type string,
       mmth3       type string,
       mmth4       type string,
       mmth5       type string,
       mmth6       type string,
       mmth7       type string,
       mmth8       type string,
       mmth9       type string,
       mmth10      type string,
       mmth11      type string,
       mmth12      type string,
       myr1        type string,
       myr2        type string,
       myr3        type string,
       myr4        type string,
       myr5        type string,
       myr6        type string,
       myr7        type string,
       myr8        type string,
       myr9        type string,
       myr10       type string,
       myr11       type string,
       myr12       type string.

data: month_name type table of t247 with header line.
data: mm(2)       type n,
      myr(4)      type n,
      mtitle(90)  type c,
      prdname(25) type c,
      formnm(10)  type c,
      w_month(30) type c,
      tot_gr2     type p,
      tot_perf    type p,
      w_year(4)   type c.

data : qty1(8)  type p,
       qty2(8)  type p,
       qty3(8)  type p,
       qty4(8)  type p,
       qty5(8)  type p,
       qty6(8)  type p,
       qty7(8)  type p,
       qty8(8)  type p,
       qty9(8)  type p,
       qty10(8) type p,
       qty11(8) type p,
       qty12(8) type p.
data : dqty1(8)  type p,
       dqty2(8)  type p,
       dqty3(8)  type p,
       dqty4(8)  type p,
       dqty5(8)  type p,
       dqty6(8)  type p,
       dqty7(8)  type p,
       dqty8(8)  type p,
       dqty9(8)  type p,
       dqty10(8) type p,
       dqty11(8) type p,
       dqty12(8) type p.
data : fqty1(8)  type p,
       fqty2(8)  type p,
       fqty3(8)  type p,
       fqty4(8)  type p,
       fqty5(8)  type p,
       fqty6(8)  type p,
       fqty7(8)  type p,
       fqty8(8)  type p,
       fqty9(8)  type p,
       fqty10(8) type p,
       fqty11(8) type p,
       fqty12(8) type p.

types : begin of itab_1,
          spart   type mara-spart,
          land1   type zexpdata-country,
          maktx   type makt-maktx,
          matkl   type mara-matkl,
          mvgr4   type mvke-mvgr4,
          bezei   type tvm5t-bezei,
          qty     type zexpdata-c_qty,
          val     type zexpdata-val,
          pqty    type zexpdata-c_qty,
          pval    type zexpdata-val,
          tot_qty type zexpdata-val,
        end of itab_1.

types : begin of itab_b1,
          spart   type mara-spart,
          land1   type zexpdata-country,
          maktx   type makt-maktx,
          matkl   type mara-matkl,
          mvgr4   type mvke-mvgr4,
          bezei   type tvm5t-bezei,
          qty     type zexpdata-c_qty,
          val     type zexpdata-val,
          tot_qty type zexpdata-val,
        end of itab_b1.

types : begin of itab_tot,
          land1      type t005t-landx,
          bezei      type tvm4t-bezei,
          curr_qty   type zexpdata-c_qty,
          curr_val   type zexpdata-c_qty,
          curr_bqty  type zexpdata-c_qty,
          curr_bval  type zexpdata-c_qty,
          curr_tqty  type zexpdata-c_qty,
          curr_tval  type zexpdata-c_qty,
          curr_tbqty type zexpdata-c_qty,
          curr_tbval type zexpdata-c_qty,
          prev_qty   type zexpdata-c_qty,
          prev_val   type zexpdata-c_qty,
          perf       type p,
          qty_grth   type p,
          val_grth   type p,
        end of itab_tot.

data : it_tab1    type table of itab_1,
       wa_tab1    type itab_1,
       it_tab_b1  type table of itab_b1,
       wa_tab_b1  type itab_b1,
       it_tabf1   type table of itab_1,
       wa_tabf1   type itab_1,
       it_tab_bf1 type table of itab_b1,
       wa_tab_bf1 type itab_b1,
       it_tabtot  type table of itab_tot,
       wa_tabtot  type itab_tot.

data : options        type itcpo,
       l_otf_data     like itcoo occurs 10,
       l_asc_data     like tline occurs 10,
       l_docs         like docs  occurs 10,
       l_pdf_data     like solisti1 occurs 10,
       l_pdf_data1    like solisti1 occurs 10,
       l_bin_filesize type i.
data :  result      like  itcpp.
data: docdata like solisti1  occurs  10,
      objhead like solisti1  occurs  1,
      objbin1 like solisti1  occurs 10,
      objbin  like solisti1  occurs 10.
data: listobject like abaplist  occurs  1 .
data: doc_chng like sodocchgi1.
data reclist    like somlreci1  occurs  1 with header line.
data mcount type i.
data : v_werks type werks_d.
data : v_text(70) type c.
data: ltx like t247-ltx.

data : usrid_long like pa0105-usrid_long.
data : w_usrid_long type pa0105-usrid_long.
data righe_attachment type i.
data righe_testo type i.
data tab_lines type i.
data  begin of objpack occurs 0 .
        include structure  sopcklsti1.
data end of objpack.

data begin of objtxt occurs 0.
        include structure solisti1.
data end of objtxt.
data: v_msg(125) type c.

data : wa_d1(10) type c,
       wa_d2(10) type c,
       c1(241)   type c.

data: mon(2)   type c,
      yr       type bkpf-gjahr,
      curr_val type p decimals 2.
data: fyear1 type bkpf-gjahr.
data: cnval type p decimals 2,
      dnval type p decimals 2.

data: it_zexpestsale type table of zexpestsale,
      wa_zexpestsale type zexpestsale.

types : begin of itam1,
          pernr type pa0001-pernr,
          rm    type yterrallc-bzirk,
        end of itam1.


types : begin of itam2,
          pernr      type pa0001-pernr,
          usrid_long type pa0105-usrid_long,
        end of itam2.

data : it_tam2 type table of itam2,
       wa_tam2 type itam2,
       it_tam1 type table of itam1,
       wa_tam1 type itam1.

select-options : s_budat for sy-cdate.
*select-options : mmth for zexpdata-zmonth.
*select-options : myr for zexpdata-ZYEAR.
*select-options : mland1 FOR T005T-LAND1.
selection-screen begin of block b2 with frame title text-002.
parameters : r5 radiobutton group r2,
             r6 radiobutton group r2,
             r7 radiobutton group r2.
parameter : uemail(70) type c.
selection-screen end of block b2.


initialization.
  g_repid = sy-repid.

at selection-screen.
  if s_budat-low+6(2) ne '01'.
    message 'ENTER START DATE OF MONTH' type 'E'.
  endif.

  call function 'RP_LAST_DAY_OF_MONTHS'
    exporting
      day_in            = s_budat-low
    importing
      last_day_of_month = l_date.

  if s_budat-high ne l_date.
    message 'ENTER END DATE OF THE MONTH' type 'E'.
  endif.

  if r7 eq 'X'.
    if uemail eq '                                                                     '.
      message 'ENTER EMAIL ID' type 'E'.
    endif.
  endif.

start-of-selection.
  c_date+6(2) = '01'.
  c_date+4(2) = '04'.
  l_date = s_budat-high.

  if s_budat-low+4(2) lt '04'.
    c_date+0(4) = s_budat-low+0(4) - 1.
  else.
    c_date+0(4) = s_budat-low+0(4).
  endif.
*  WRITE :/1 C_DATE , L_DATE.

  mm = s_budat-high+4(2).
  call function 'MONTH_NAMES_GET'
    tables
      month_names = month_name.
  read table month_name index mm.

  mtitle = month_name-ktx.
  mtitle+3(3) = '`' .
  mtitle+4(2) = s_budat-high+2(2).

  perform curr_mth_data.
  perform fullyr_data.
  perform merge_data.
  if r5 = 'X'.
    perform alv_disp_sr1b.
  elseif r6 = 'X'.
    formnm = 'ZSR1B_EXP'.
    perform open_form.
    perform new_sr1form.
    perform close_form.
  elseif r7 = 'X'.
    formnm = 'ZSR1B_EXP'.
    perform exp_sr1_email.

  endif.

*&---------------------------------------------------------------------*
*&      Form  CURR_MTH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form curr_mth_data .
  lc_date = s_budat-low.
  mm = lc_date+4(2).
  myr = lc_date+0(4).
*  WRITE :/1 MYR , MM.

  select * from zexpdata into table it_zexpdata where zmonth = mm and zyear = myr.
  loop at it_zexpdata into wa_zexpdata.
    wa_tab1-land1 = wa_zexpdata-country.
    wa_tab1-qty = wa_zexpdata-c_qty * wa_zexpdata-conv .
    wa_tab1-val = wa_zexpdata-val + wa_zexpdata-freight.
    collect wa_tab1 into it_tab1.
    clear wa_tab1.
  endloop.

  select * from zexpbudget into table it_zexpbudget where zmonth = mm and zyear = myr.
  loop at it_zexpbudget into wa_zexpbudget.
    wa_tab_b1-land1 = wa_zexpbudget-country.
    wa_tab_b1-qty = wa_zexpbudget-c_qty.
    wa_tab_b1-val = wa_zexpbudget-net_val.
    collect wa_tab_b1 into it_tab_b1.
    clear wa_tab_b1.
  endloop.

endform.                    " CURR_MTH_DATA
*&---------------------------------------------------------------------*
*&      Form  FULLYR_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form fullyr_data .
  lc_date = c_date.
  pdate1 = c_date.
  pdate2 = s_budat-high.
  pdate1+0(4) = pdate1+0(4) - 1.
  pdate2+0(4) = pdate2+0(4) - 1.
  mm = lc_date+4(2).
  myr = lc_date+0(4).
*  WRITE :/1 MYR , MM, C_DATE .
*  WRITE :/1 PDATE1 , PDATE2.
  select * from zexpdata into table it_zexpdata .
  loop at it_zexpdata into wa_zexpdata.
    m_date = s_budat-low.
    m_date+0(4) = wa_zexpdata-zyear.
    m_date+4(2) = wa_zexpdata-zmonth.
*    write : /1 wa_zexpdata-zyear, wa_zexpdata-zmonth, m_date.
    if m_date < s_budat-high and m_date >=  c_date.
      wa_tabf1-land1 = wa_zexpdata-country.
      wa_tabf1-qty = wa_zexpdata-c_qty * wa_zexpdata-conv .
      wa_tabf1-val = wa_zexpdata-val  + wa_zexpdata-freight.
      collect wa_tabf1 into it_tabf1.
      clear wa_tabf1.
    elseif m_date < pdate2 and m_date >=  pdate1.
      wa_tabf1-land1 = wa_zexpdata-country.
      wa_tabf1-pqty = wa_zexpdata-c_qty * wa_zexpdata-conv .
      wa_tabf1-pval = wa_zexpdata-val  + wa_zexpdata-freight.
      collect wa_tabf1 into it_tabf1.
      clear wa_tabf1.
    endif.
  endloop.

  lc_date = c_date.
  mm = lc_date+4(2).
  myr = lc_date+0(4).
*  WRITE :/1 MYR , MM, C_DATE .
  select * from zexpbudget into table it_zexpbudget .
  loop at it_zexpbudget into wa_zexpbudget.
    m_date = s_budat-low.
    m_date+0(4) = wa_zexpbudget-zyear.
    m_date+4(2) = wa_zexpbudget-zmonth.
    if m_date < s_budat-high and m_date >=  c_date.
      wa_tab_bf1-land1 = wa_zexpbudget-country.
      wa_tab_bf1-qty = wa_zexpbudget-c_qty.
      wa_tab_bf1-val = wa_zexpbudget-net_val.
      collect wa_tab_bf1 into it_tab_bf1.
      clear wa_tab_bf1.
    endif.
  endloop.

endform.                    " FULLYR_DATA
*&---------------------------------------------------------------------*
*&      Form  MERGE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form merge_data .
  select * from t005t  into table it_t005t where spras = 'EN'.
  loop at it_t005t into wa_t005t.
*   WRITE : /1  wa_T005T-LAND1 , WA_T005T-LANDX.
    read table it_tab1 into wa_tab1 with key land1 = wa_t005t-land1.
    if sy-subrc eq 0.
      wa_tabtot-curr_qty = wa_tab1-qty.
      wa_tabtot-curr_val = wa_tab1-val.
    endif.
    read table it_tab_b1 into wa_tab_b1 with key land1 = wa_t005t-land1.
    if sy-subrc eq 0.
      wa_tabtot-curr_bqty = wa_tab_b1-qty.
      wa_tabtot-curr_bval = wa_tab_b1-val.
    endif.
    read table it_tabf1 into wa_tabf1 with key land1 = wa_t005t-land1.
    if sy-subrc eq 0.
      wa_tabtot-curr_tqty = wa_tabf1-qty.
      wa_tabtot-curr_tval = wa_tabf1-val.
      wa_tabtot-prev_qty = wa_tabf1-pqty.
      wa_tabtot-prev_val = wa_tabf1-pval.
    endif.
    read table it_tab_bf1 into wa_tab_bf1 with key land1 = wa_t005t-land1.
    if sy-subrc eq 0.
      wa_tabtot-curr_tbqty = wa_tab_bf1-qty.
      wa_tabtot-curr_tbval = wa_tab_bf1-val.
    endif.
    if wa_tabtot-curr_qty <> 0 or wa_tabtot-curr_val <> 0 or
        wa_tabtot-curr_bqty <> 0 or wa_tabtot-curr_bval <> 0 or
          wa_tabtot-curr_tqty <> 0 or wa_tabtot-curr_tval <> 0 or
        wa_tabtot-prev_qty <> 0 or wa_tabtot-prev_val <> 0 or
        wa_tabtot-curr_tbqty <> 0 or wa_tabtot-curr_tbval <> 0.
*        WRITE : /1  wa_T005T-LAND1 , WA_T005T-LANDX , 'DATA UPDATED'.
      wa_tabtot-land1  = wa_t005t-land1.
      wa_tabtot-bezei  = wa_t005t-landx.
      collect wa_tabtot into it_tabtot.
    endif.
    clear wa_tabtot.
  endloop.

  loop at it_tabtot  into wa_tabtot.
    if wa_tabtot-curr_tqty <> 0 and wa_tabtot-prev_qty <> 0.
      wa_tabtot-qty_grth =  ( ( wa_tabtot-curr_tqty / wa_tabtot-prev_qty ) * 100 ) - 100 .
    elseif wa_tabtot-curr_tqty = 0 and wa_tabtot-prev_qty = 0.
      wa_tabtot-qty_grth = 100.
    elseif wa_tabtot-curr_tqty = 0 and wa_tabtot-prev_qty > 0.
      wa_tabtot-qty_grth = - 100.
    elseif wa_tabtot-curr_tqty > 0 and wa_tabtot-prev_qty = 0.
      wa_tabtot-qty_grth = 100.
    endif.
    if wa_tabtot-curr_tval <> 0 and wa_tabtot-prev_val <> 0.
      wa_tabtot-val_grth =  ( ( wa_tabtot-curr_tval / wa_tabtot-prev_val ) * 100 ) - 100 .
    elseif wa_tabtot-curr_tval = 0 and wa_tabtot-prev_val = 0.
      wa_tabtot-val_grth = 100.
    elseif wa_tabtot-curr_tval = 0 and wa_tabtot-prev_val > 0.
      wa_tabtot-val_grth = - 100.
    elseif wa_tabtot-curr_tval > 0 and wa_tabtot-prev_val = 0.
      wa_tabtot-val_grth = 100.
    endif.
    if wa_tabtot-curr_tval <> 0 and wa_tabtot-curr_tbval <> 0.
      wa_tabtot-perf = ( wa_tabtot-curr_tval / wa_tabtot-curr_tbval ) * 100.
    elseif wa_tabtot-curr_tval <> 0 and wa_tabtot-curr_tbval = 0.
      wa_tabtot-perf = 100.
    elseif wa_tabtot-curr_tval = 0 and wa_tabtot-curr_tbval <> 0.
      wa_tabtot-perf = 0.
    endif.
    modify it_tabtot from wa_tabtot.
    clear wa_tabtot.
  endloop.
  sort it_tabtot by bezei.

*  break-point.

  mon = s_budat-low+4(2).
  yr = s_budat-low+0(4).
  select single  * from zexpestsale where zmonth eq mon and zyear eq yr.
  if sy-subrc eq 0.
    curr_val = zexpestsale-cnval - zexpestsale-dnval.
  endif.

  if mon ge '04'.
    fyear1 = yr.
  else.
    fyear1 = yr - 1.
  endif.
  select * from zexpestsale into table it_zexpestsale where zyear eq fyear1.
  clear : cnval,dnval.
  loop at it_zexpestsale into wa_zexpestsale.
    cnval = cnval + wa_zexpestsale-cnval.
    dnval = dnval + wa_zexpestsale-dnval.
  endloop.
endform.                    " MERGE_DATA
*&---------------------------------------------------------------------*
*&      Form  ALV_DISP_SR1B
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form alv_disp_sr1b .
*  wa_fieldcat-fieldname = 'GRP_DIV'.
*  wa_fieldcat-seltext_l = 'DIVISION'.
*  append wa_fieldcat to fieldcat.


  wa_fieldcat-fieldname = 'BEZEI'.
  wa_fieldcat-seltext_l = 'COUNTRY'.
  append wa_fieldcat to fieldcat.

** wa_fieldcat-fieldname = 'CURR_QTY'.
** wa_fieldcat-seltext_l = 'UNIT SALE THIS MTH'.
** append wa_fieldcat to fieldcat.
**
** wa_fieldcat-fieldname = 'CURR_BQTY'.
** wa_fieldcat-seltext_l = 'UNIT BUD THIS MTH'.
** append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CURR_VAL'.
  wa_fieldcat-seltext_l = 'SALE THIS MTH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CURR_BVAL'.
  wa_fieldcat-seltext_l = 'VAL BUD THIS MTH'.
  append wa_fieldcat to fieldcat.

** wa_fieldcat-fieldname = 'CURR_TQTY'.
** wa_fieldcat-seltext_l = 'UNIT SALE THIS YTD'.
** append wa_fieldcat to fieldcat.
**
** wa_fieldcat-fieldname = 'CURR_TBQTY'.
** wa_fieldcat-seltext_l = 'UNIT BUD THIS YTD'.
** append wa_fieldcat to fieldcat.
**
  wa_fieldcat-fieldname = 'CURR_TVAL'.
  wa_fieldcat-seltext_l = 'SALE THIS YTD'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CURR_TBVAL'.
  wa_fieldcat-seltext_l = 'VAL BUD THIS YTD'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'PERF'.
  wa_fieldcat-seltext_l = '% ACHEIVED YTD'.
  append wa_fieldcat to fieldcat.

** wa_fieldcat-fieldname = 'PREV_QTY'.
** wa_fieldcat-seltext_l = 'QTY LAST YTD'.
** append wa_fieldcat to fieldcat.
**
  wa_fieldcat-fieldname = 'PREV_VAL'.
  wa_fieldcat-seltext_l = 'VAL LAST YTD'.
  append wa_fieldcat to fieldcat.


**wa_fieldcat-fieldname = 'QTY_GRTH'.
** wa_fieldcat-seltext_l = 'UNIT GRTH SALE THIS YTD'.
** append wa_fieldcat to fieldcat.
**
  wa_fieldcat-fieldname = 'VAL_GRTH'.
  wa_fieldcat-seltext_l = 'VAL GRTH THIS YTD'.
  append wa_fieldcat to fieldcat.

  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'EXPORT SALE ( GROSS ) GROUP WISE SUMMARY '.

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
      t_outtab                = it_tabtot
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.


endform.                    " ALV_DISP_SR1B


*&---------------------------------------------------------------------*
*&      Form  top
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form top.

  data: comment     type  slis_t_listheader,
        wa_comment1 like line of comment,
        wa_comment  like line of comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'SR-1-B : EXPORT SALES COUNTRY SUMMARY AS OF '.
  c_date := s_budat.

*  WA_COMMENT-INFO = P_FRMDT.

*  PERFORM MTH_NAMES_GET.

* wa_comment-info+45{10) = MONTH_NAMES_GET(s_budat-low).

  mm = s_budat-low+4(2).
  call function 'MONTH_NAMES_GET'
    tables
      month_names = month_name.
  read table month_name index mm.

*wa_comment-info+41(3) = month_name-ktx.
*wa_comment-info+44(1) = '`'.
*wa_comment-info+45(2) = s_budat-low+2(2).
*wa_comment-info+48(2) = 'TO'.

*wa_comment-info+45(2) = s_budat-low+6(2).
*  wa_comment-info+47(1) = '.'.
*  wa_comment-info+48(2) = s_budat-low+4(2).

  mm = s_budat-high+4(2).
  call function 'MONTH_NAMES_GET'
    tables
      month_names = month_name.
  read table month_name index mm.

  wa_comment-info+49(3) = month_name-ktx.
  wa_comment-info+52(1) = '`'.
  wa_comment-info+53(2) = s_budat-high+2(2).
  wa_comment-info+55(5) = ' & CUM '.


*wa_comment1-info+58(2) = s_budat-high+6(2).
*  wa_comment1-info+64(1) = '.'.
*  wa_comment1-info+65(2) = s_budat-high+4(2).
*  wa_comment1-info+67(1) = '.'.
*  wa_comment1-info+68(4) = s_budat-high+0(4).

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
*&      Form  open_form
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form open_form.
  call function 'OPEN_FORM'
    exporting
*     APPLICATION                 = 'TX'
*     ARCHIVE_INDEX               =
*     ARCHIVE_PARAMS              =
*     DEVICE                      = 'PRINTER'
*     DIALOG                      = 'X'
      form                        = formnm
*     LANGUAGE                    = SY-LANGU
*     OPTIONS                     =
*     MAIL_SENDER                 =
*     MAIL_RECIPIENT              =
*     MAIL_APPL_OBJECT            =
*     RAW_DATA_INTERFACE          = '*'
*     SPONUMIV                    =
* IMPORTING
*     LANGUAGE                    =
*     NEW_ARCHIVE_PARAMS          =
*     RESULT                      =
    exceptions
      canceled                    = 1
      device                      = 2
      form                        = 3
      options                     = 4
      unclosed                    = 5
      mail_options                = 6
      archive_error               = 7
      invalid_fax_number          = 8
      more_params_needed_in_batch = 9
      spool_error                 = 10
      codepage                    = 11
      others                      = 12.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

endform.                    "open_form



*&---------------------------------------------------------------------*
*&      Form  close_form
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form close_form.
  call function 'CLOSE_FORM'
*   IMPORTING
*     RESULT                         =
*     RDI_RESULT                     =
*   TABLES
*     OTFDATA                        =
*   EXCEPTIONS
*     UNOPENED                       = 1
*     BAD_PAGEFORMAT_FOR_PRINT       = 2
*     SEND_ERROR                     = 3
*     SPOOL_ERROR                    = 4
*     CODEPAGE                       = 5
*     OTHERS                         = 6
    .
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

endform.                    "close_form

*&---------------------------------------------------------------------*
*&      Form  write_main_form
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form write_main_form .
  call function 'WRITE_FORM'
    exporting
      element                  = 'DET1'
*     FUNCTION                 = 'SET'
*     TYPE                     = 'BODY'
      window                   = 'MAIN'
* IMPORTING
*     PENDING_LINES            =
    exceptions
      element                  = 1
      function                 = 2
      type                     = 3
      unopened                 = 4
      unstarted                = 5
      window                   = 6
      bad_pageformat_for_print = 7
      spool_error              = 8
      codepage                 = 9
      others                   = 10.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.
endform.                    " WRITE_MAIN_FORM

*&---------------------------------------------------------------------*
*&      Form  start_form
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form start_form.
  call function 'START_FORM'
    exporting
*     ARCHIVE_INDEX          =
      form        = formnm
*     LANGUAGE    = ' '
*     STARTPAGE   = ' '
*     PROGRAM     = ' '
*     MAIL_APPL_OBJECT       =
*   IMPORTING
*     LANGUAGE    =
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
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

endform.                    "start_form
*&---------------------------------------------------------------------*
*&      Form  NEW_SR2FORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form new_sr1form .

  flag = '0'.
  tot_gr2 = 0.
* SORT IT_TABTOT BY PRN_SEQ.
  sort it_tabtot by bezei.
  loop at it_tabtot into wa_tabtot.
    tot_gr2 = 0.
    perform start_form.
    perform writeform.
    prdname = wa_tabtot-bezei.
    translate prdname to upper case.
*     pack1 = WA_TABTOT-pack.
    qty1 = wa_tabtot-curr_val.
    qty2 = wa_tabtot-curr_bval.
    qty3 = wa_tabtot-curr_tval.
    qty4 = wa_tabtot-curr_tbval.
    qty5 = wa_tabtot-perf.
    qty6 = wa_tabtot-prev_val.
    fqty1  = fqty1 + wa_tabtot-curr_val.
    fqty2  = fqty2 + wa_tabtot-curr_bval.
    fqty3  = fqty3 + wa_tabtot-curr_tval.
    fqty4  = fqty4 + wa_tabtot-curr_tbval.
    fqty5  = fqty5 + wa_tabtot-prev_val.
    mdatael = 'DET1'.
    perform write_line.
*    CLEAR : QTY1, QTY2, QTY3, QTY4, QTY5, QTY6, QTY7,QTY8, TOT_GR2.
    at last.
      fqty1 = fqty1 - curr_val.
      fqty3 = fqty3 - cnval + dnval.
      tot_perf = ( ( fqty3 / fqty4 ) * 100 ).
      tot_gr2 = ( ( ( fqty3 / fqty5 ) * 100 ) - 100 ).
      prdname = 'EXPORT SALES TOTAL :'.
      mdatael = 'FDET1'.
      perform write_line.
    endat.
  endloop.

endform.                    " NEW_SR2FORM

*&---------------------------------------------------------------------*
*&      Form  WRITE_line
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form write_line .
  call function 'WRITE_FORM'
    exporting
      element                  = mdatael
*     FUNCTION                 = 'SET'
      type                     = 'BODY'
      window                   = 'MAIN'
*   IMPORTING
*     PENDING_LINES            =
    exceptions
      element                  = 1
      function                 = 2
      type                     = 3
      unopened                 = 4
      unstarted                = 5
      window                   = 6
      bad_pageformat_for_print = 7
      spool_error              = 8
      codepage                 = 9
      others                   = 10.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

endform.                    " PRD_WRITE

*&---------------------------------------------------------------------*
*&      Form  writeform
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form writeform .
  call function 'WRITE_FORM'
    exporting
*     ELEMENT                  = 'RM'
*     FUNCTION                 = 'SET'
      type                     = 'BODY'
      window                   = 'WINDOW1'
*   IMPORTING
*     PENDING_LINES            =
    exceptions
      element                  = 1
      function                 = 2
      type                     = 3
      unopened                 = 4
      unstarted                = 5
      window                   = 6
      bad_pageformat_for_print = 7
      spool_error              = 8
      codepage                 = 9
      others                   = 10.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

endform.                    " HEADER
*&---------------------------------------------------------------------*
*&      Form  EXP_SR2_EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form exp_sr1_email .
  options-tdgetotf = 'X'.

  flag = '0'.
*  SORT IT_TABTOT BY PRN_SEQ.
  sort it_tabtot by bezei.
  perform open_form1.
  sort it_tabtot by bezei.
  loop at it_tabtot into wa_tabtot.
    tot_gr2 = 0.
    perform start_form.
    perform writeform.
    prdname = wa_tabtot-bezei.
    translate prdname to upper case.
*     pack1 = WA_TABTOT-pack.
    qty1 = wa_tabtot-curr_val.
    qty2 = wa_tabtot-curr_bval.
    qty3 = wa_tabtot-curr_tval.
    qty4 = wa_tabtot-curr_tbval.
    qty5 = wa_tabtot-perf.
    qty6 = wa_tabtot-prev_val.
    fqty1  = fqty1 + wa_tabtot-curr_val.
    fqty2  = fqty2 + wa_tabtot-curr_bval.
    fqty3  = fqty3 + wa_tabtot-curr_tval.
    fqty4  = fqty4 + wa_tabtot-curr_tbval.
    fqty5  = fqty5 + wa_tabtot-prev_val.
    mdatael = 'DET1'.
    perform write_line.
*    CLEAR : QTY1, QTY2, QTY3, QTY4, QTY5, QTY6, QTY7,QTY8, TOT_GR2.
    at last.
      fqty1 = fqty1 - curr_val.
      fqty3 = fqty3 - cnval + dnval.

      tot_perf =  ( ( fqty3 / fqty4 ) * 100 ).
      tot_gr2 = ( ( ( fqty3 / fqty5 ) * 100 ) - 100 ).
      prdname = 'EXPORT SALES TOTAL :'.
      mdatael = 'FDET1'.
      perform write_line.
    endat.
  endloop.
  perform exp_sr2_close.
  perform close_form2.

endform.                    " EXP_SR2_EMAIL

*&---------------------------------------------------------------------*
*&      Form  OPEN_FORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form open_form1 .

  call function 'OPEN_FORM'
    exporting
      device                      = 'PRINTER'
      dialog                      = ''
*     FORM                        = FORMNM
      language                    = sy-langu
      options                     = options
    exceptions
      canceled                    = 1
      device                      = 2
      form                        = 3
      options                     = 4
      unclosed                    = 5
      mail_options                = 6
      archive_error               = 7
      invalid_fax_number          = 8
      more_params_needed_in_batch = 9
      spool_error                 = 10
      codepage                    = 11
      others                      = 12.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

endform.                    " OPEN_FORM1

*&---------------------------------------------------------------------*
*&      Form  close_form2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form close_form2.
  call function 'CLOSE_FORM'
    importing
      result  = result
    tables
      otfdata = l_otf_data.

  .
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

  call function 'CONVERT_OTF'
    exporting
      format       = 'PDF'
    importing
      bin_filesize = l_bin_filesize
    tables
      otf          = l_otf_data
      lines        = l_asc_data.

  call function 'SX_TABLE_LINE_WIDTH_CHANGE'
    exporting
      line_width_dst = '255'
    tables
      content_in     = l_asc_data
      content_out    = objbin.

  write s_budat-low to wa_d1 dd/mm/yy.
  write s_budat-high to wa_d2 dd/mm/yy.

  describe table objbin lines righe_attachment.
  objtxt = 'This eMail is meant for information only. Please DO NOT REPLY'.append objtxt.
  objtxt = '                                 '.append objtxt.
  objtxt = 'BLUE CROSS LABORATORIES LTD.'.append objtxt.
  describe table objtxt lines righe_testo.
  doc_chng-obj_name = 'URGENT'.
  doc_chng-expiry_dat = sy-datum + 10.
  condense ltx.
  condense objtxt.

*     concatenate 'ES-4: MONTHLY ACTUAL UNITS SOLD FOR PERIOD' wa_d1 'TO ' wa_d2  into doc_chng-obj_descr separated by space.
  concatenate 'SR-1-B : EXPORT SALES - COUNTRYWISE SUMMARY AS OF ' mtitle+0(6) '& CUM'  into doc_chng-obj_descr separated by space.
  doc_chng-sensitivty = 'F'.
  doc_chng-doc_size = righe_testo * 255 .

  clear objpack-transf_bin.

  objpack-head_start = 1.
  objpack-head_num = 0.
  objpack-body_start = 1.
  objpack-body_num = 4.
  objpack-doc_type = 'TXT'.
  append objpack.

  objpack-transf_bin = 'X'.
  objpack-head_start = 1.
  objpack-head_num = 0.
  objpack-body_start = 1.
  objpack-body_num = righe_attachment.
  objpack-doc_type = 'PDF'.
  objpack-obj_name = 'TEST'.
  condense ltx.

*      concatenate 'ACTUAL UNIT  FOR PERIOD' wa_d1 'TO ' wa_d2 '.' into objpack-obj_descr separated by space.
  concatenate 'SR-1-B' '' into objpack-obj_descr.    "  separated by space.
  objpack-doc_size = righe_attachment * 255.
  append objpack.
  clear objpack.

  reclist-receiver = uemail.
  reclist-express = 'X'.
  reclist-rec_type = 'U'.
  reclist-notif_del = 'X'. " request delivery notification
  reclist-notif_ndel = 'X'. " request not delivered notification
  append reclist.
  clear reclist.

  describe table reclist lines mcount.
  if mcount > 0.
    data: sender like soextreci1-receiver.
***ADDED BY SATHISH.B
    types: begin of t_usr21,
             bname      type usr21-bname,
             persnumber type usr21-persnumber,
             addrnumber type usr21-addrnumber,
           end of t_usr21.

    types: begin of t_adr6,
             addrnumber type usr21-addrnumber,
             persnumber type usr21-persnumber,
             smtp_addr  type adr6-smtp_addr,
           end of t_adr6.

    data: it_usr21 type table of t_usr21,
          wa_usr21 type t_usr21,
          it_adr6  type table of t_adr6,
          wa_adr6  type t_adr6.
    select  bname persnumber addrnumber from usr21 into table it_usr21
        where bname = sy-uname.
    if sy-subrc = 0.
      select addrnumber persnumber smtp_addr from adr6 into table it_adr6
        for all entries in it_usr21 where addrnumber = it_usr21-addrnumber
                                    and   persnumber = it_usr21-persnumber.
    endif.
    loop at it_usr21 into wa_usr21.
      read table it_adr6 into wa_adr6 with key addrnumber = wa_usr21-addrnumber.
      if sy-subrc = 0.
        sender = wa_adr6-smtp_addr.
      endif.
    endloop.
    call function 'SO_DOCUMENT_SEND_API1'
      exporting
        document_data              = doc_chng
        put_in_outbox              = 'X'
        sender_address             = sender
        sender_address_type        = 'SMTP'
*       COMMIT_WORK                = ' '
* IMPORTING
*       SENT_TO_ALL                =
*       NEW_OBJECT_ID              =
*       SENDER_ID                  =
      tables
        packing_list               = objpack
*       OBJECT_HEADER              =
        contents_bin               = objbin
        contents_txt               = objtxt
*       CONTENTS_HEX               =
*       OBJECT_PARA                =
*       OBJECT_PARB                =
        receivers                  = reclist
      exceptions
        too_many_receivers         = 1
        document_not_sent          = 2
        document_type_not_exist    = 3
        operation_no_authorization = 4
        parameter_error            = 5
        x_error                    = 6
        enqueue_error              = 7
        others                     = 8.
    if sy-subrc <> 0.
      message id sy-msgid type sy-msgty number sy-msgno
              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.

    commit work.


    if sy-subrc eq 0.

      write : / 'EMAIL SENT ON ',wa_tam2-usrid_long.
    endif.



    clear   : objpack,
             objhead,
             objtxt,
             objbin,
             reclist.

    refresh : objpack,
              objhead,
              objtxt,
              objbin,
              reclist.

  endif.
  loop at it_tam1 into wa_tam1.
    read table it_tam2 into wa_tam2 with key  pernr = wa_tam1-pernr .
    if sy-subrc eq 4.
      format color 6.
      write : / 'EMAIL ID NOT MAINTAINED FOR EMP. CODE :',wa_tam1-pernr.
    endif.
  endloop.

endform.                    "close_form2
*&---------------------------------------------------------------------*
*&      Form  EXP_SR2_CLOSE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form exp_sr2_close .
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
endform.                    " EXP_SR2_CLOSE
