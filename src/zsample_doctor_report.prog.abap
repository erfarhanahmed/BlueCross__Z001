*&---------------------------------------------------------------------*
*& Report  ZSAMPLE_DOCTOR_REPORT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report zsample_doctor_report_n3.
tables : mara,
         zdsmter,
         pa0001,
         makt,
         zsamp_doctor .

data: c_ccont   type ref to cl_gui_custom_container,         "Custom container object
      c_alvgd   type ref to cl_gui_alv_grid,         "ALV grid object
      it_fcat   type lvc_t_fcat,                  "Field catalogue
      it_layout type lvc_s_layo.                  "Layout
*ok code declaration
data: ok_code  type ui_func,
      ok_code1 type ui_func.
data: it_dropdown type lvc_t_drop,
      ty_dropdown type lvc_s_drop,
*data declaration for refreshing of alv
      stable      type lvc_s_stbl.
*Global variable declaration
data: gstring type c.

data: m1(2) type c,
      y1(4) type c.
data: it_zdoctor type table of zsampdoc_update1,
      wa_zdoctor type zsampdoc_update1.

types : begin of tas1,
          pernr       type pa0001-pernr,
          bzirk       type zsampinvp-bzirk,
          matnr       type mara-matnr,
          charg       type zsampinvp-charg,
          docno       type zsampdoc_update1-docno,
          budat       type sy-datum,
          qty         type zsampdoc_update1-qty,
          docname     type pa0001-ename,
          kbetr       type konp-kbetr,
          value       type konp-kbetr,
          ename       type pa0001-ename,
          maktx       type makt-maktx,
          cpudt       type sy-datum,
*          UNAME    TYPE zsampdoc_update1-UNAME,
*          UZEIT    TYPE zsampdoc_update1-UZEIT,
          zdsm        type zsampdoc_update1-zdsm,
          ebeln       type ekpo-ebeln,
          fgmatnr     type mara-matnr,
          fgpack      type tvm5t-bezei,
          mrp         type prcd_elements-kbetr,
          samppack    type tvm5t-bezei,
          docqualfctn type  zsamp_doctor-docqualfctn,
          docplace    type  zsamp_doctor-docplace,
*          CHARG   TYPE ZDOCTOR-CHARG,
          vbeln       type zsampdoc_update1-vbeln,
          gjahr       type zsampdoc_update1-gjahr,
          fkdat       type zsampdoc_update1-fkdat,
        end of tas1.

data: it_tas1 type table of tas1,
      wa_tas1 type tas1.

selection-screen begin of block merkmale2 with frame title text-002.
select-options: matnr for mara-matnr,
*PERNR FOR   PA0001-PERNR,
budat for sy-datum ,
*TER FOR ZDSMTER-BZIRK,
org for zdsmter-zdsm matchcode object zsr9_1 .
parameters : r1 radiobutton group r1,
             r2 radiobutton group r1.
*             r3 radiobutton group r1.
*             R4 RADIOBUTTON GROUP R1.

selection-screen end of block merkmale2 .

if budat is initial.
  message 'ENTER DATE' type 'E'.
endif.
*if org is initial.
*  message 'ENTER ZONE' type 'E'.
*endif.
m1 = budat-low+4(2).
y1 = budat-low+0(4).
*    PERFORM ZONE.
perform display.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form display .

*  if r1 eq 'X'.
  select * from zsampdoc_update1 into table it_zdoctor where matnr in matnr and budat in budat and zdsm in org and rate gt 0.
  if sy-subrc eq 4.
    message 'NO DATA' type 'E'.
  endif.

*  elseif r2 eq 'X'.
*    select * from zsampdoc_update1 into table it_zdoctor where matnr in matnr and budat in budat and zdsm in org and rate gt 0.
*    if sy-subrc eq 4.
*      message 'NO DATA' type 'E'.
*    endif.

*  elseif r3 eq 'X'.
*    select * from zsampdoc_update1 into table it_zdoctor where matnr in matnr and budat in budat and zdsm in org and rate le 0.
*    if sy-subrc eq 4.
*      message 'NO DATA' type 'E'.
*    endif.
*
**  ELSEIF R4 EQ 'X'.
**    SELECT * FROM ZSAMPDOC_UPDATE1 INTO TABLE IT_ZDOCTOR WHERE MATNR IN MATNR AND BUDAT IN BUDAT AND ZDSM IN ORG.
**    IF SY-SUBRC EQ 4.
**      MESSAGE 'NO DATA' TYPE 'E'.
**    ENDIF.
*  endif.

  if it_zdoctor is initial.
    message 'no data' type 'E'.
    exit.
  endif.

  if r1 eq 'X'.
    perform summary.
  elseif r2 eq 'X'.
    perform detail.
  endif.





  call screen 9002.
endform.
*&---------------------------------------------------------------------*
*&      Module  STATUS_9002  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module status_9002 output.
  set pf-status 'STATUS1'.
  set titlebar 'TITLE2'.
  perform pbo1.
endmodule.
*&---------------------------------------------------------------------*
*&      Form  PBO1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form pbo1 .
*Creating objects of the container
  create object c_ccont
    exporting
      container_name = 'CCONT'.
*  create object for alv grid


  create object c_alvgd
    exporting
      i_parent = cl_gui_custom_container=>screen0.

*  CREATE OBJECT c_alvgd
*    EXPORTING
*      i_parent = c_ccont.



*  SET field for ALV
  data lv_fldcat type lvc_s_fcat.
  IF R1 EQ 'X'.
    perform alv_build_fieldcat2.
    ELSEIF R2 EQ 'X'.
  perform alv_build_fieldcat1.
  ENDIF.
* Set ALV attributes FOR LAYOUT
  perform alv_report_layout.
  check not c_alvgd is initial.
* Call ALV GRID
  call method c_alvgd->set_table_for_first_display
    exporting
      is_layout                     = it_layout
      i_save                        = 'A'
    changing
      it_outtab                     = it_tas1
      it_fieldcatalog               = it_fcat
    exceptions
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      others                        = 4.
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
               with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  ALV_BUILD_FIELDCAT1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form alv_build_fieldcat1 .
  data lv_fldcat type lvc_s_fcat.

  lv_fldcat-fieldname = 'ZDSM'.
  lv_fldcat-scrtext_m = 'ZONE'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'BZIRK'.
  lv_fldcat-scrtext_m = 'TERRITORY CODE'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'PERNR'.
  lv_fldcat-scrtext_m = 'EMPLOYEE CODE'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'ENAME'.
  lv_fldcat-scrtext_m = 'EMPLOYEE NAME'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'BUDAT'.
  lv_fldcat-scrtext_m = 'POSTING DATE'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'MATNR'.
  lv_fldcat-scrtext_m = 'SAMPLE CODE'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

*  IF R4 NE 'X'.
  lv_fldcat-fieldname = 'CHARG'.
  lv_fldcat-scrtext_m = 'BATCH'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'EBELN'.
  lv_fldcat-scrtext_m = 'PO NO.'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'KBETR'.
  lv_fldcat-scrtext_m = 'SAMPLE RATE'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'VALUE'.
  lv_fldcat-scrtext_m = 'SAMPLE VALUE'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'FGMATNR'.
  lv_fldcat-scrtext_m = 'FG CODE'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'FGPACK'.
  lv_fldcat-scrtext_m = 'FG PACK'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'MRP'.
  lv_fldcat-scrtext_m = 'MRP'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'SAMPPACK'.
  lv_fldcat-scrtext_m = 'SAMPLE PACK'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.
*  ENDIF.

  lv_fldcat-fieldname = 'VBELN'.
  lv_fldcat-scrtext_m = 'INV. NO'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'FKDAT'.
  lv_fldcat-scrtext_m = 'INV. DATE'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'MAKTX'.
  lv_fldcat-scrtext_m = 'SAMPLE DESCRIPTION'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'QTY'.
  lv_fldcat-scrtext_m = 'SAMPLE QUANTITY'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.



  lv_fldcat-fieldname = 'DOCNO'.
  lv_fldcat-scrtext_m = 'DOCTOR UNIQUE CODE'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'DOCNAME'.
  lv_fldcat-scrtext_m = 'DOCTOR NAME'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'DOCQUALFCTN'.
  lv_fldcat-scrtext_m = 'DOCTOR QUALIFICATION'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'DOCPLACE'.
  lv_fldcat-scrtext_m = 'DOCTOR PLACE'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

*  LV_FLDCAT-FIELDNAME = 'CPUDT'.
*  LV_FLDCAT-SCRTEXT_M = 'ENTRY DATE'.
**  LV_FLDCAT-EDIT = 'X'.
*  APPEND LV_FLDCAT TO IT_FCAT.
*  CLEAR LV_FLDCAT.
*
*  LV_FLDCAT-FIELDNAME = 'UNAME'.
*  LV_FLDCAT-SCRTEXT_M = 'ENTERED BY'.
**  LV_FLDCAT-EDIT = 'X'.
*  APPEND LV_FLDCAT TO IT_FCAT.
*  CLEAR LV_FLDCAT.
*
*  LV_FLDCAT-FIELDNAME = 'UZEIT'.
*  LV_FLDCAT-SCRTEXT_M = 'ENTRY TIME'.
**  LV_FLDCAT-EDIT = 'X'.
*  APPEND LV_FLDCAT TO IT_FCAT.
*  CLEAR LV_FLDCAT.

endform.
*&---------------------------------------------------------------------*
*&      Form  ALV_REPORT_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form alv_report_layout .
  it_layout-cwidth_opt = 'X'.
  it_layout-col_opt = 'X'.
  it_layout-zebra = 'X'.
endform.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9002  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module user_command_9002 input.
  case ok_code1.

    when 'BACK' or 'EXIT' or 'CANCEL'.
      leave to screen 0.
  endcase.
  clear: ok_code1.
endmodule.
*&---------------------------------------------------------------------*
*&      Form  SUMMARY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form summary .
  if it_zdoctor is not initial.
    loop at it_zdoctor into wa_zdoctor.
*      wa_tas1-pernr = wa_zdoctor-pernr.
*      wa_tas1-bzirk = wa_zdoctor-bzirk.
**      wa_tas1-vbeln = wa_zdoctor_bzirk.
*
*      select single * from pa0001 where pernr eq wa_zdoctor-pernr and endda ge sy-datum.
*      if sy-subrc eq 0.
*        wa_tas1-ename = pa0001-ename.
*      endif.
*      wa_tas1-matnr = wa_zdoctor-matnr.
*      select single * from makt where matnr eq wa_zdoctor-matnr and spras eq 'EN'.
*      if sy-subrc eq 0.
*        wa_tas1-maktx = makt-maktx.
*      endif.
      wa_tas1-docno = wa_zdoctor-docno.
      select single * from zsamp_doctor where docno eq wa_zdoctor-docno.
      if sy-subrc eq 0.
        wa_tas1-docname = zsamp_doctor-docname.
        wa_tas1-docqualfctn = zsamp_doctor-docqualfctn.
        wa_tas1-docplace = zsamp_doctor-docplace.
      endif.

      wa_tas1-budat = wa_zdoctor-budat.
      wa_tas1-qty = wa_zdoctor-qty.
*      WA_TAS1-DOCNAME = WA_ZDOCTOR-DOCNAME.
*      WA_TAS1-DOCNAME = WA_ZDOCTOR-DOCNAME.
*      WA_TAS1-DOCNAME = WA_ZDOCTOR-DOCNAME.
*      WA_TAS1-DOCNAME = WA_ZDOCTOR-DOCNAME.
*      WA_TAS1-DOCNAME = WA_ZDOCTOR-DOCNAME.
*      WA_TAS1-DOCNAME = WA_ZDOCTOR-DOCNAME.
*      wa_tas1-zdsm = wa_zdoctor-zdsm.
*      WA_TAS1-CPUDT = WA_ZDOCTOR-CPUDT.
*      WA_TAS1-UZEIT = WA_ZDOCTOR-UZEIT.
*      WA_TAS1-UNAME = WA_ZDOCTOR-UNAME.
*      wa_tas1-kbetr = wa_zdoctor-rate.
*      wa_tas1-charg = wa_zdoctor-batch.
*      wa_tas1-ebeln = wa_zdoctor-ebeln.
*      wa_tas1-fgmatnr = wa_zdoctor-fgmatnr.
*      wa_tas1-fgpack = wa_zdoctor-fgpack.
*      wa_tas1-mrp = wa_zdoctor-mrp.
*      wa_tas1-samppack = wa_zdoctor-samppack.
*      wa_tas1-vbeln = wa_zdoctor-vbeln.
*      wa_tas1-gjahr = wa_zdoctor-gjahr.
*      wa_tas1-fkdat = wa_zdoctor-fkdat.
      wa_tas1-value = wa_zdoctor-rate * wa_zdoctor-qty.
      collect wa_tas1 into it_tas1.
      clear wa_tas1.
    endloop.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  DETAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form detail .
  if it_zdoctor is not initial.
    loop at it_zdoctor into wa_zdoctor.
      wa_tas1-pernr = wa_zdoctor-pernr.
      wa_tas1-bzirk = wa_zdoctor-bzirk.
*      wa_tas1-vbeln = wa_zdoctor_bzirk.

      select single * from pa0001 where pernr eq wa_zdoctor-pernr and endda ge sy-datum.
      if sy-subrc eq 0.
        wa_tas1-ename = pa0001-ename.
      endif.
      wa_tas1-matnr = wa_zdoctor-matnr.
      select single * from makt where matnr eq wa_zdoctor-matnr and spras eq 'EN'.
      if sy-subrc eq 0.
        wa_tas1-maktx = makt-maktx.
      endif.
      wa_tas1-docno = wa_zdoctor-docno.
      select single * from zsamp_doctor where docno eq wa_zdoctor-docno.
      if sy-subrc eq 0.
        wa_tas1-docname = zsamp_doctor-docname.
        wa_tas1-docqualfctn = zsamp_doctor-docqualfctn.
        wa_tas1-docplace = zsamp_doctor-docplace.
      endif.

      wa_tas1-budat = wa_zdoctor-budat.
      wa_tas1-qty = wa_zdoctor-qty.
*      WA_TAS1-DOCNAME = WA_ZDOCTOR-DOCNAME.
*      WA_TAS1-DOCNAME = WA_ZDOCTOR-DOCNAME.
*      WA_TAS1-DOCNAME = WA_ZDOCTOR-DOCNAME.
*      WA_TAS1-DOCNAME = WA_ZDOCTOR-DOCNAME.
*      WA_TAS1-DOCNAME = WA_ZDOCTOR-DOCNAME.
*      WA_TAS1-DOCNAME = WA_ZDOCTOR-DOCNAME.
      wa_tas1-zdsm = wa_zdoctor-zdsm.
*      WA_TAS1-CPUDT = WA_ZDOCTOR-CPUDT.
*      WA_TAS1-UZEIT = WA_ZDOCTOR-UZEIT.
*      WA_TAS1-UNAME = WA_ZDOCTOR-UNAME.
      wa_tas1-kbetr = wa_zdoctor-rate.
      wa_tas1-charg = wa_zdoctor-batch.
      wa_tas1-ebeln = wa_zdoctor-ebeln.
      wa_tas1-fgmatnr = wa_zdoctor-fgmatnr.
      wa_tas1-fgpack = wa_zdoctor-fgpack.
      wa_tas1-mrp = wa_zdoctor-mrp.
      wa_tas1-samppack = wa_zdoctor-samppack.
      wa_tas1-vbeln = wa_zdoctor-vbeln.
      wa_tas1-gjahr = wa_zdoctor-gjahr.
      wa_tas1-fkdat = wa_zdoctor-fkdat.
      wa_tas1-value = wa_zdoctor-rate * wa_zdoctor-qty.
      collect wa_tas1 into it_tas1.
      clear wa_tas1.
    endloop.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  ALV_BUILD_FIELDCAT2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form alv_build_fieldcat2 .
 data lv_fldcat type lvc_s_fcat.

*  lv_fldcat-fieldname = 'ZDSM'.
*  lv_fldcat-scrtext_m = 'ZONE'.
**  LV_FLDCAT-EDIT = 'X'.
*  append lv_fldcat to it_fcat.
*  clear lv_fldcat.
*
*  lv_fldcat-fieldname = 'BZIRK'.
*  lv_fldcat-scrtext_m = 'TERRITORY CODE'.
**  LV_FLDCAT-EDIT = 'X'.
*  append lv_fldcat to it_fcat.
*  clear lv_fldcat.
*
*  lv_fldcat-fieldname = 'PERNR'.
*  lv_fldcat-scrtext_m = 'EMPLOYEE CODE'.
**  LV_FLDCAT-EDIT = 'X'.
*  append lv_fldcat to it_fcat.
*  clear lv_fldcat.

*  lv_fldcat-fieldname = 'ENAME'.
*  lv_fldcat-scrtext_m = 'EMPLOYEE NAME'.
**  LV_FLDCAT-EDIT = 'X'.
*  append lv_fldcat to it_fcat.
*  clear lv_fldcat.

  lv_fldcat-fieldname = 'BUDAT'.
  lv_fldcat-scrtext_m = 'POSTING DATE'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

*  lv_fldcat-fieldname = 'MATNR'.
*  lv_fldcat-scrtext_m = 'SAMPLE CODE'.
**  LV_FLDCAT-EDIT = 'X'.
*  append lv_fldcat to it_fcat.
*  clear lv_fldcat.
*
**  IF R4 NE 'X'.
*  lv_fldcat-fieldname = 'CHARG'.
*  lv_fldcat-scrtext_m = 'BATCH'.
**  LV_FLDCAT-EDIT = 'X'.
*  append lv_fldcat to it_fcat.
*  clear lv_fldcat.

*  lv_fldcat-fieldname = 'EBELN'.
*  lv_fldcat-scrtext_m = 'PO NO.'.
**  LV_FLDCAT-EDIT = 'X'.
*  append lv_fldcat to it_fcat.
*  clear lv_fldcat.
*
*  lv_fldcat-fieldname = 'KBETR'.
*  lv_fldcat-scrtext_m = 'SAMPLE RATE'.
**  LV_FLDCAT-EDIT = 'X'.
*  append lv_fldcat to it_fcat.
*  clear lv_fldcat.

  lv_fldcat-fieldname = 'VALUE'.
  lv_fldcat-scrtext_m = 'SAMPLE VALUE'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

*  lv_fldcat-fieldname = 'FGMATNR'.
*  lv_fldcat-scrtext_m = 'FG CODE'.
**  LV_FLDCAT-EDIT = 'X'.
*  append lv_fldcat to it_fcat.
*  clear lv_fldcat.
*
*  lv_fldcat-fieldname = 'FGPACK'.
*  lv_fldcat-scrtext_m = 'FG PACK'.
**  LV_FLDCAT-EDIT = 'X'.
*  append lv_fldcat to it_fcat.
*  clear lv_fldcat.
*
*  lv_fldcat-fieldname = 'MRP'.
*  lv_fldcat-scrtext_m = 'MRP'.
**  LV_FLDCAT-EDIT = 'X'.
*  append lv_fldcat to it_fcat.
*  clear lv_fldcat.

*  lv_fldcat-fieldname = 'SAMPPACK'.
*  lv_fldcat-scrtext_m = 'SAMPLE PACK'.
**  LV_FLDCAT-EDIT = 'X'.
*  append lv_fldcat to it_fcat.
*  clear lv_fldcat.
**  ENDIF.
*
*  lv_fldcat-fieldname = 'VBELN'.
*  lv_fldcat-scrtext_m = 'INV. NO'.
**  LV_FLDCAT-EDIT = 'X'.
*  append lv_fldcat to it_fcat.
*  clear lv_fldcat.

*  lv_fldcat-fieldname = 'FKDAT'.
*  lv_fldcat-scrtext_m = 'INV. DATE'.
**  LV_FLDCAT-EDIT = 'X'.
*  append lv_fldcat to it_fcat.
*  clear lv_fldcat.
*
*  lv_fldcat-fieldname = 'MAKTX'.
*  lv_fldcat-scrtext_m = 'SAMPLE DESCRIPTION'.
**  LV_FLDCAT-EDIT = 'X'.
*  append lv_fldcat to it_fcat.
*  clear lv_fldcat.

  lv_fldcat-fieldname = 'QTY'.
  lv_fldcat-scrtext_m = 'SAMPLE QUANTITY'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.



  lv_fldcat-fieldname = 'DOCNO'.
  lv_fldcat-scrtext_m = 'DOCTOR UNIQUE CODE'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'DOCNAME'.
  lv_fldcat-scrtext_m = 'DOCTOR NAME'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'DOCQUALFCTN'.
  lv_fldcat-scrtext_m = 'DOCTOR QUALIFICATION'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'DOCPLACE'.
  lv_fldcat-scrtext_m = 'DOCTOR PLACE'.
*  LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

*  LV_FLDCAT-FIELDNAME = 'CPUDT'.
*  LV_FLDCAT-SCRTEXT_M = 'ENTRY DATE'.
**  LV_FLDCAT-EDIT = 'X'.
*  APPEND LV_FLDCAT TO IT_FCAT.
*  CLEAR LV_FLDCAT.
*
*  LV_FLDCAT-FIELDNAME = 'UNAME'.
*  LV_FLDCAT-SCRTEXT_M = 'ENTERED BY'.
**  LV_FLDCAT-EDIT = 'X'.
*  APPEND LV_FLDCAT TO IT_FCAT.
*  CLEAR LV_FLDCAT.
*
*  LV_FLDCAT-FIELDNAME = 'UZEIT'.
*  LV_FLDCAT-SCRTEXT_M = 'ENTRY TIME'.
**  LV_FLDCAT-EDIT = 'X'.
*  APPEND LV_FLDCAT TO IT_FCAT.
*  CLEAR LV_FLDCAT.
endform.
