*&-------------------------------------------------------------------------------------------------*
*& Report  ZCSS_REPORT
*&-------------------------------------------------------------------------------------------------*
*&DESCRIPTION       : CSS report with MRP,PTS and Value details
*CREATED BY         : Shraddha Pradhan
*CREATED ON         : 25/06/2024
*Request No         : BCDK935361 , BCDK935371,BCDK935375
*T-code             : ZCSS_REPORT
*&-------------------------------------------------------------------------------------------------*
*&Modification History
*&---------------------------
*&Changed by/date       : shraddha / 17.07.2024
*&DESCRIPTION           : Add new css outward print option
*&Request No.          : BCDK935471, BCDK935519,BCDK935577,BCDK935583
*&-------------------------------------------------------------------------------------------------*
report zcss_report.

tables :zcss_request,
        makt,
        mara,
        pa0000,
        pa0001.

constants : gc_fm_css   type  tdsfname value 'ZCSS_OUTWARD_SF'.

types: begin of ty_fdata.
         include structure zcss_request.
         types :  maktx      type maktx,
         name1      type name1,
         ename      type emnam,
         zpmt_ename type emnam,
         zz_hqdesc  type zdehr_hqdesc,
         grp_bezei  type bezei40,
         bezei      type bezei40,   "packsize
         labst      type labst,     "stock
         umrez      type umrez,      "box size
         kbetr      type kbetr_kond,
         val        type kbetr_kond,
         pts        type zval_dec2,

       end of ty_fdata.

types: begin of ty_0001,
         pernr     type persno,
         ename     type emnam,
         plans     type plans,
         persk     type persk,
         zz_hqcode type zdehr_hqcode,
       end of ty_0001,

       begin of ty_konp,
         knumh type knumh,
         kopos type kopos,
         kschl type kschl,
         kbetr type kbetr_kond,
       end of ty_konp.

data : gt_0001         type table of ty_0001,
       gw_0001         type ty_0001,
       gt_0006         type table of pa0006,
       gw_0006         type pa0006,
       gt_fdata        type table of zty_zcss_request, "TY_FDATA,
       gw_fdata        type zty_zcss_request, "TY_FDATA,
       gt_fdata_lp     type table of zty_zcss_request,
       gw_fdata_lp     type zty_zcss_request,
       gt_mara         type table of mara,
       gw_mara         type mara,
       gt_makt         type table of makt,
       gw_makt         type makt,
       gt_zpmt         type table of zpmt,
       gw_zpmt         type zpmt,
       gt_yterr        type table of yterrallc,
       gw_yterr        type yterrallc,
       gt_hq_des       type table of zthr_heq_des,
       gw_hq_des       type zthr_heq_des,
       gt_t001w        type table of t001w,
       gw_t001w        type t001w,
       gt_mvke         type table of mvke,
       gw_mvke         type mvke,
       gt_a602         type table of a602,
       gw_a602         type a602,
       gt_konp         type table of ty_konp,
       gw_konp         type ty_konp,
       gt_zcss_request type table of zcss_request,
       gw_zcss_request type zcss_request.

data : gv_msg   type string,
       gv_werks type xuvalue.

data : gt_fcat    type slis_t_fieldcat_alv,
       gw_fcat    like line of gt_fcat,
       gw_layout  type slis_layout_alv,
       gt_comment type slis_t_listheader,
       gw_comment like line of gt_comment,
       gt_sort    type slis_t_sortinfo_alv,
       gw_sort    like line of gt_sort.

data : gw_output_opts type ssfcompop,
       gw_contrl_para type ssfctrlop,
       gt_otf_data    type ssfcrescl,
       gt_otf         type standard table of itcoo,
       gt_tline       type standard table of tline,
       gt_pdf_data    type solix_tab,
       gt_text        type bcsy_text.

********** SELECTION SCREEN *********************************************************************************************************
selection-screen begin of block b0 with frame title text-001.
select-options :s_date for zcss_request-ersda obligatory,
                s_div for mara-spart no intervals.

*****SELECT-OPTIONS :S_WERKS FOR ZCSS_REQUEST-WERKS.

parameters : p_pmt type persno matchcode object zpmt.
parameters : p_werks type werks_d matchcode object h_t001w.
selection-screen end of block b0.

selection-screen begin of block b1 with frame title text-002 .
parameters: p_alv  radiobutton group r1 user-command rb1,
            p_prnt radiobutton group r1.
selection-screen end of block b1.

at selection-screen.
  if p_prnt = abap_true.
    if p_werks is not initial.
      authority-check object '/DSD/SL_WR'
         id 'WERKS' field p_werks.
      if sy-subrc <> 0.
        clear gv_msg.
        concatenate 'No authorization for Plant - ' p_werks  into gv_msg.
        message gv_msg type 'E'.
      endif.
    else.
      clear gv_msg.
      gv_msg = 'Please enter Inventory plant.'.
      message gv_msg type 'E'.
    endif.
  endif.
*****AT SELECTION-SCREEN OUTPUT.

*****  IF P_PRNT = ABAP_TRUE.
*****    CLEAR GV_WERKS.
*****    SELECT SINGLE PARVA FROM USR05 INTO GV_WERKS
*****      WHERE BNAME = SY-UNAME
*****      AND PARID = 'ZPLANT'.
*****    IF SY-SUBRC <> 0.
*****      CONCATENATE 'No authorization/parameter for Plant/User - ' P_WERKS '/' SY-UNAME  INTO GV_MSG
*****      SEPARATED BY SPACE.
*****      MESSAGE GV_MSG TYPE 'E'.
*****    ELSE.
*****      P_WERKS = GV_WERKS.
*****      LOOP AT SCREEN .
*****        IF SCREEN-NAME = 'P_WERKS'.
*****          SCREEN-INPUT = 0.
*****          MODIFY SCREEN.
*****        ENDIF.
*****      ENDLOOP.
*****    ENDIF.
*****  ENDIF.


start-of-selection.
  clear gt_zcss_request[].
  if p_pmt is not initial.
    select * from zcss_request into table gt_zcss_request
      where zpmt_pernr = p_pmt
      and ersda in s_date.
  else.
    select * from zcss_request into table gt_zcss_request
  where ersda in s_date.
  endif.

  if gt_zcss_request[] is not initial.
    perform get_data.
    if gt_fdata[] is not initial.
      if s_div[] is not initial.
        sort gt_fdata by spart.
        delete gt_fdata[] where spart not in s_div[].
      endif.
      if p_werks is not initial.
        sort gt_fdata by werks.
        delete gt_fdata[] where werks <> p_werks.
      endif.
      if p_alv = abap_true.
        sort gt_fdata by ersda werks.
        perform build_fcat.
        perform display_alv.
      else.
        perform display_sform.
      endif.
    endif.
  else.
    clear gv_msg.
    gv_msg = 'No data found.'.
    message gv_msg type 'I'.
  endif.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form get_data .

  if s_div[] is initial.
    clear gt_mara[].
    select * from mara into table gt_mara where mtart in ('ZFRT', 'ZHWA').
  else.
    clear gt_mara[].
    select * from mara into table gt_mara where mtart in ('ZFRT', 'ZHWA') and spart in s_div.
  endif.
  clear gt_makt[].
  select * from makt into table gt_makt where spras = sy-langu.

  clear gt_0001.
  select pernr ename plans persk zz_hqcode from pa0001 into table  gt_0001
    where endda >= sy-datum
      and plans <> '99999999'.
  if sy-subrc = 0.
    clear gt_yterr[].
    select * from yterrallc into table gt_yterr
      for all entries in gt_0001
      where plans = gt_0001-plans
      and endda >= sy-datum.
  endif.
  clear gt_hq_des[].
  select * from zthr_heq_des into table gt_hq_des .

  clear gt_zpmt[].
  select * from zpmt into table gt_zpmt.

  clear gt_mvke[].
  select * from mvke into table gt_mvke
    where vkorg = '1000'.

  clear gt_t001w[].
  select * from t001w into table gt_t001w
    where vkorg = '1000'.

  clear gt_a602[].
  select * from a602 into table gt_a602
    where kschl = 'Z001'
    and datab le sy-datum
    and datbi ge sy-datum.
  if sy-subrc = 0.
    sort gt_a602 by knumh.
    clear gt_konp[].
    select knumh kopos kschl kbetr from konp into table gt_konp
      for all entries in gt_a602
      where knumh = gt_a602-knumh
      and kschl eq gt_a602-kschl
      and loevm_ko ne 'X'.
  endif.

  clear gt_fdata[].
  loop at gt_zcss_request into gw_zcss_request.
    move-corresponding gw_zcss_request to gw_fdata.

    if gw_zcss_request-approve = 'X'.
      gw_fdata-approve = 'Y'.
    endif.
    clear gw_mara.
    read table gt_mara into gw_mara with key matnr = gw_fdata-matnr.
    if sy-subrc = 0.
      gw_fdata-spart = gw_mara-spart.
    endif.
    clear gw_makt.
    read table gt_makt into gw_makt with key matnr = gw_fdata-matnr.
    if sy-subrc = 0.
      gw_fdata-maktx = gw_makt-maktx.
    endif.

    clear gw_0001.
    read table gt_0001 into gw_0001 with key pernr = gw_zcss_request-zemp_req.
    if sy-subrc = 0.
      gw_fdata-ename = gw_0001-ename.
      clear gw_hq_des.
      read table gt_hq_des into gw_hq_des with key zz_hqcode = gw_0001-zz_hqcode.
      if sy-subrc = 0.
        gw_fdata-zz_hqdesc = gw_hq_des-zz_hqdesc.
      endif.
    endif.
    clear gw_zpmt.
    read table gt_zpmt into gw_zpmt with key pernr = gw_fdata-zpmt_pernr.
    if sy-subrc = 0.
      gw_fdata-zpmt_ename = gw_zpmt-ename.
    endif.


    select single name1 from t001w into gw_fdata-name1 where werks = gw_fdata-werks.

    select single bezei from tvm4t into gw_fdata-grp_bezei where spras = sy-langu and mvgr4 = gw_fdata-mvgr4.
**** pack-size
    clear gw_mvke.
    read table gt_mvke  into gw_mvke with key matnr =  gw_fdata-matnr.
    if sy-subrc = 0.
      select single bezei from tvm5t into gw_fdata-bezei where spras = sy-langu and mvgr5 = gw_mvke-mvgr5.
    endif.
    if gw_mvke-mvgr1 ne 'LIQ'.
***** Box size and convert qty as per BOX size
      select single umrez from marm into gw_fdata-umrez
         where matnr = gw_fdata-matnr
         and meinh eq 'BOX'.
      if sy-subrc = 0.
        gw_fdata-qty = gw_fdata-qty * gw_fdata-umrez.
      endif.
    else.
***** Shipper size and convert qty as per SPR size
      select single umrez from marm into gw_fdata-umrez
         where matnr = gw_fdata-matnr
         and meinh eq 'SPR'.
      if sy-subrc = 0.
        gw_fdata-qty = gw_fdata-qty * gw_fdata-umrez.
      endif.
    endif.

******  rate ,val and PTS
    clear gw_a602.
    read table gt_a602 into gw_a602 with key matnr =  gw_fdata-matnr charg = gw_fdata-charg.
    if sy-subrc = 0.
      clear gw_konp.
      read table gt_konp into gw_konp with key knumh = gw_a602-knumh.
      if sy-subrc = 0.
        gw_fdata-kbetr = gw_konp-kbetr.
      endif.
    endif.
    gw_fdata-pts = gw_fdata-kbetr * '0.6429'.
    gw_fdata-val = gw_fdata-pts * gw_fdata-qty.

    append gw_fdata to gt_fdata.
    clear gw_fdata.
  endloop.

endform.
*&---------------------------------------------------------------------*
*&      Form  BUILD_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form build_fcat .
  data lv_pos type i.

  clear gt_fcat[].

  lv_pos = 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'ZCSS_NO'.
  gw_fcat-seltext_l = 'CSS No.'.
  gw_fcat-col_pos = lv_pos.
  gw_fcat-outputlen = '5'.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'MATNR'.
  gw_fcat-seltext_l = 'Product Code'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'MAKTX'.
  gw_fcat-seltext_l = 'Product Desc.'.
  gw_fcat-col_pos = lv_pos.
  gw_fcat-key = 'X'.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'BEZEI'.
  gw_fcat-seltext_l = 'Pack size'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'UMREZ'.
  gw_fcat-seltext_l = 'BOX / SPR size'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'GRP_BEZEI'.
  gw_fcat-seltext_l = 'Product Group'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'SPART'.
  gw_fcat-seltext_l = 'Product Div.'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'QTY'.
  gw_fcat-seltext_l = 'Quantity'.
  gw_fcat-col_pos = lv_pos.
  gw_fcat-key = 'X'.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'CHARG'.
  gw_fcat-seltext_l = 'Batch'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'KBETR'.
  gw_fcat-seltext_l = 'MRP'.
  gw_fcat-col_pos = lv_pos.
  gw_fcat-key = 'X'.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'PTS'.
  gw_fcat-seltext_l = 'PTS'.
  gw_fcat-col_pos = lv_pos.
  gw_fcat-key = 'X'.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'VAL'.
  gw_fcat-seltext_l = 'Value (PTS * Qty)'.
  gw_fcat-col_pos = lv_pos.
  gw_fcat-key = 'X'.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'WERKS'.
  gw_fcat-seltext_l = 'Plant'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'NAME1'.
  gw_fcat-seltext_l = 'Plant Name'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'BZIRK'.
  gw_fcat-seltext_l = 'Territory'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

*****  LV_POS = LV_POS + 1.
*****  CLEAR GW_FCAT.
*****  GW_FCAT-FIELDNAME = 'ZEMP_REQ'.
*****  GW_FCAT-SELTEXT_L = 'Request From(Field)'.
*****  GW_FCAT-COL_POS = LV_POS.
*****  APPEND GW_FCAT TO GT_FCAT.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'ENAME'.
  gw_fcat-seltext_l = 'Issued To(Field)'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.


  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'ZZ_HQDESC'.
  gw_fcat-seltext_l = 'H.Q.'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

*****  LV_POS = LV_POS + 1.
*****  CLEAR GW_FCAT.
*****  GW_FCAT-FIELDNAME = 'ZPMT_PERNR'.
*****  GW_FCAT-SELTEXT_L = 'Created by(PMT)'.
*****  GW_FCAT-COL_POS = LV_POS.
*****  APPEND GW_FCAT TO GT_FCAT.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'ZPMT_ENAME'.
  gw_fcat-seltext_l = 'Created by(PMT)'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'ERSDA'.
  gw_fcat-seltext_l = 'Created On'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'APPROVE'.
  gw_fcat-seltext_l = 'Approved'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'APP_DT'.
  gw_fcat-seltext_l = 'Approved On'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

  lv_pos = lv_pos + 1.
  clear gw_fcat.
  gw_fcat-fieldname = 'MBLNR'.
  gw_fcat-seltext_l = 'Document Posted'.
  gw_fcat-col_pos = lv_pos.
  append gw_fcat to gt_fcat.

endform.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form display_alv .
  data : lv_gtitle  type lvc_title.
  gw_layout-zebra = 'X'.
  gw_layout-colwidth_optimize = 'X'.

  lv_gtitle = 'CSS Details.'.
  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
      i_callback_program = sy-repid
****      I_CALLBACK_USER_COMMAND = 'USER_COMMAND'
*****      i_callback_top_of_page = 'TOP_OF_PAGE'
      i_grid_title       = lv_gtitle
      is_layout          = gw_layout
      it_fieldcat        = gt_fcat[]
*     I_DEFAULT          = 'X'
      i_save             = 'A'
    tables
      t_outtab           = gt_fdata[]
    exceptions
      program_error      = 1
      others             = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_SFORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form display_sform .

  data: fm_name type  tdsfname.

  sort gt_fdata by zemp_req.
  clear gt_0006[].
******* select for postal address of requester
  clear gt_0006[].
  select * from pa0006 into table gt_0006
    for all entries in gt_fdata
    where pernr = gt_fdata-zemp_req
    and subty = '1'
    and endda >= sy-datum.


  clear gt_fdata_lp[].
  gt_fdata_lp[] = gt_fdata[].
  sort gt_fdata_lp[] by zcss_no.
  delete adjacent duplicates from gt_fdata_lp[] comparing zcss_no.
  sort gt_fdata by ersda werks zcss_no.

  clear fm_name.
  call function 'SSF_FUNCTION_MODULE_NAME'
    exporting
      formname = gc_fm_css
    importing
      fm_name  = fm_name.

  gw_output_opts-tdnoprev = space.
  gw_output_opts-tdnoprev = space."gc_true.
  gw_output_opts-tddest    = 'LOCL'.
  gw_output_opts-tdnoprint = space."gc_true.

  gw_contrl_para-getotf = space."gc_true.
  gw_contrl_para-no_dialog = space."gc_true.
  gw_contrl_para-preview = space.

  call function fm_name
    exporting
      control_parameters = gw_contrl_para
      output_options     = gw_output_opts
*    importing
*     document_output_info =
*     job_output_info    = gt_otf_data
*     job_output_options =
    tables
      gt_fdata           = gt_fdata[]
      gt_fdata_lp        = gt_fdata_lp[]
      gt_0006            = gt_0006[]
    exceptions
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      others             = 5.
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

  endif.
endform.
