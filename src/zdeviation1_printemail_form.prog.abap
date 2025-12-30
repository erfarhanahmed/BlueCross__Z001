*&---------------------------------------------------------------------*
*& Report  ZDEVIATION5
*&***..
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zdeviation1_printemail_form_a1.
TABLES : t001p,
         pa0001,
         zdev2,
         zdev3,
         zdev4,
         zdev6,
         zdev1,
         zdev21,
         zqms_depthead1,
         zpassw,
         pa0002.

DATA: it_zdev1  TYPE TABLE OF zdev1,
      wa_zdev1  TYPE zdev1,
      it_zdev5  TYPE TABLE OF zdev5,
      wa_zdev5  TYPE zdev5,
      it_zdev6  TYPE TABLE OF zdev6,
      wa_zdev6  TYPE zdev6,
      it_zdev51 TYPE TABLE OF zdev5,  "additional Department Comments
      wa_zdev51 TYPE zdev5,
      it_zdev8  TYPE TABLE OF zdev8,
      wa_zdev8  TYPE zdev8,
      it_zdev9  TYPE TABLE OF zdev9,
      wa_zdev9  TYPE zdev9.
TYPES : BEGIN OF dept1,
          btrtl TYPE pa0001-btrtl,
        END OF dept1.
DATA: it_dept1 TYPE TABLE OF dept1,
      wa_dept1 TYPE dept1.
DATA: ewerks(4) TYPE c.
DATA: adddept(1) TYPE c.
DATA: dept(1)  TYPE c,
      qahnmapp TYPE pa0001-ename,
      qahdtapp TYPE sy-datum,
      qahtmapp TYPE sy-uzeit.
DATA: sp1(10) TYPE c.

DATA : v_fm TYPE rs38l_fnam.

DATA: d1(20) TYPE c,
      d2(20) TYPE c,
      d3(20) TYPE c,
      d4(20) TYPE c,
      d5(21) TYPE c,
      d6(20) TYPE c,
      d7(20) TYPE c,
      d8(20) TYPE c,
      d9(50) TYPE c.
DATA: n1(1) TYPE c.
DATA: dtext1(100) TYPE c,
      dtext2(100) TYPE c.

DATA: d11(20) TYPE c,
      d12(20) TYPE c,
      d13(20) TYPE c,
      d14(20) TYPE c,
      d15(20) TYPE c,
      d16(20) TYPE c,
      d17(20) TYPE c,
      d18(20) TYPE c,
      d19(50) TYPE c.
DATA: dtext3(100) TYPE c,
      dtext4(100) TYPE c.
DATA: cqaname  TYPE pa0001-ename,
      cqadt    TYPE sy-datum,
      cqahname TYPE pa0001-ename,
      cqahdt   TYPE sy-datum,
      ctdname  TYPE pa0001-ename,
      ctddt    TYPE sy-datum.
DATA: capacl(1) TYPE c,  "capaclosure
      cclname   TYPE pa0001-ename,
      ccldt     TYPE sy-datum,
      capacldt  TYPE sy-datum,
      cclhname  TYPE pa0001-ename,
      cclhdt    TYPE sy-datum.
*      clrem1    TYPE zdev6-clrem1,
*      clrem2    TYPE zdev6-clrem1,
*      clrem3    TYPE zdev6-clrem1.



DATA: deptname TYPE t001p-btext,
      ename    TYPE pa0001-ename,
      budat    TYPE sy-datum,
      uzeit    TYPE sy-uzeit,
      occdt    TYPE sy-datum.



TYPES : BEGIN OF itab1,
          dev1(100)     TYPE c,
          dev2(100)     TYPE c,
          dev3(100)     TYPE c,
          dev4(100)     TYPE c,
          dev5(100)     TYPE c,
          dev6(100)     TYPE c,
          dev7(100)     TYPE c,
          dev8(100)     TYPE c,
          dev9(100)     TYPE c,
          dev10(100)    TYPE c,

          dsp1(100)     TYPE c,
          dsp2(100)     TYPE c,
          dsp3(100)     TYPE c,
          dsp4(100)     TYPE c,
          dsp5(100)     TYPE c,

          ric1(100)     TYPE c,
          ric2(100)     TYPE c,
          ric3(100)     TYPE c,
          ric4(100)     TYPE c,
          ric5(100)     TYPE c,


          pid1(100)     TYPE c,
          pid2(100)     TYPE c,
          pid3(100)     TYPE c,
          pid4(100)     TYPE c,
          pid5(100)     TYPE c,
          pid6(100)     TYPE c,
          pid7(100)     TYPE c,
          pid8(100)     TYPE c,
          pid9(100)     TYPE c,
          pid10(100)    TYPE c,

          irc1(100)     TYPE c,
          irc2(100)     TYPE c,
          irc3(100)     TYPE c,
          irc4(100)     TYPE c,
          irc5(100)     TYPE c,
          irc6(100)     TYPE c,
          irc7(100)     TYPE c,
          irc8(100)     TYPE c,
*
          capast1(100)  TYPE c,
          capast2(100)  TYPE c,
          capast3(100)  TYPE c,
          capast4(100)  TYPE c,
          capast5(100)  TYPE c,
*

          rad1(100)     TYPE c,
          rad2(100)     TYPE c,
          rad3(100)     TYPE c,
          rad4(100)     TYPE c,
          rad5(100)     TYPE c,
          rad6(100)     TYPE c,
          rad7(100)     TYPE c,
          rad8(100)     TYPE c,
          rad9(100)     TYPE c,
          rad10(100)    TYPE c,

          qarem1(100)   TYPE c,
          qarem2(100)   TYPE c,
          qarem3(100)   TYPE c,
          qarem4(100)   TYPE c,
          qarem5(100)   TYPE c,

          capacl1(100)  TYPE c,
          capacl2(100)  TYPE c,
          capacl3(100)  TYPE c,
          capacl4(100)  TYPE c,
          capacl5(100)  TYPE c,
          capacl11(100) TYPE c,
          capacl12(100) TYPE c,
          capacl13(100) TYPE c,
          capacl14(100) TYPE c,
          capacl15(100) TYPE c,


*          acpa1(100)     TYPE c,
*          acpa2(100)     TYPE c,
*          acpa3(100)     TYPE c,
*          acpa4(100)     TYPE c,
*          acpa5(100)     TYPE c,
*          acpa6(100)     TYPE c,
*          acpa7(100)     TYPE c,
*          acpa8(100)     TYPE c,
*          acpa9(100)     TYPE c,
*          acpa10(100)    TYPE c,

*          caparem1(100)  TYPE c,
*          caparem2(100)  TYPE c,
*          caparem3(100)  TYPE c,
*          caparem4(100)  TYPE c,
*          caparem5(100)  TYPE c,
*          caparem6(100)  TYPE c,
*          caparem7(100)  TYPE c,
*          caparem8(100)  TYPE c,
*          caparem9(100)  TYPE c,
*          caparem10(100) TYPE c,

        END  OF itab1.

TYPES: BEGIN OF itab2,
         btrtl    TYPE t001p-btrtl,
         deptname TYPE t001p-btext,
       END OF itab2.

TYPES: BEGIN OF itab3,
         btrtl    TYPE t001p-btrtl,
         ename    TYPE pa0001-ename,
         budat    TYPE pa0001-begda,
         deptname TYPE t001p-btext,
       END OF itab3.

TYPES: BEGIN OF itab4,
         btrtl      TYPE t001p-btrtl,
         com1(100)  TYPE c,
         com2(100)  TYPE c,
         com3(100)  TYPE c,
         com4(100)  TYPE c,
         com5(100)  TYPE c,
         com6(100)  TYPE c,
         com7(100)  TYPE c,
         com8(100)  TYPE c,
         com9(100)  TYPE c,
         com10(100) TYPE c,
       END OF itab4.

TYPES: BEGIN OF itab5,
         rcpa(300) TYPE c,
*         rcpa     TYPE string,
         btrtl     TYPE t001p-btrtl,
         deptname  TYPE t001p-btext,
         tcd       TYPE pa0001-begda,
         count(2)  TYPE n,
       END OF itab5.

TYPES: BEGIN OF itab6,
         rcpa(300) TYPE c,
         btrtl     TYPE t001p-btrtl,
         deptname  TYPE t001p-btext,
         tcd       TYPE pa0001-begda,
         acd       TYPE pa0001-begda,
         longt(1)  TYPE c,
         count(2)  TYPE n,
       END OF itab6.

*TYPES : BEGIN OF act1,
*          imp      TYPE zdev7-imp1,
*          deptname TYPE t001p-btext,
*          tcd1     TYPE zdev7-tcd1,
*          acd1     TYPE zdev7-acd1,
*          qaname   TYPE  pa0001-ename,
*          qadt     TYPE zdev7-qa1dt,
*          count(3) TYPE c,
*        END OF act1.

DATA: it_tab1 TYPE TABLE OF itab1,
      wa_tab1 TYPE itab1,
      it_tab2 TYPE TABLE OF itab2,
      wa_tab2 TYPE itab2,
      it_tab3 TYPE TABLE OF itab3,
      wa_tab3 TYPE itab3,
      it_tab4 TYPE TABLE OF itab4,
      wa_tab4 TYPE itab4,
      it_tab5 TYPE TABLE OF itab5,
      wa_tab5 TYPE itab5,
      it_tab6 TYPE TABLE OF itab6,
      wa_tab6 TYPE itab6,
      it_tab7 TYPE TABLE OF itab6,
      wa_tab7 TYPE itab6,
      it_tab8 TYPE TABLE OF itab6,
      wa_tab8 TYPE itab6.
*      it_act1 TYPE TABLE OF act1,
*      wa_act1 TYPE act1.
*DATA: it_zdev7 TYPE TABLE OF zdev7,
*      wa_zdev7 TYPE zdev7.
DATA: longt(1) TYPE c.
DATA: dname    TYPE  pa0001-ename,
      depthdt  TYPE zdev2-depthdt,
      depthtm  TYPE zdev2-depthtm,
      rdname   TYPE  pa0001-ename,
      rdepthdt TYPE zdev2-depthdt,
      rdepthtm TYPE zdev2-depthtm,
      adname   TYPE  pa0001-ename,
      adepthdt TYPE zdev2-depthdt,
      adepthtm TYPE zdev2-depthtm,
      stype(3) TYPE c.
DATA: qa3name TYPE pa0001-ename,
      qa3dt   TYPE sy-datum.
DATA: rpn_s(1)     TYPE c,
      rpn_p(1)     TYPE c,
      rpn_d(1)     TYPE c,
      rpn_s1(3)    TYPE c,
      rpn_p1(3)    TYPE c,
      rpn_d1(3)    TYPE c,
      rpnval(3)    TYPE c,
      invsat(3)    TYPE c,
      furinv(3)    TYPE c,
      invrepno(50) TYPE c,
      rpnstat(10)  TYPE c.
DATA: devstatus(21) TYPE c.
DATA: pland(10) TYPE c.
DATA: qaname      TYPE pa0001-ename,
      qadt        TYPE sy-datum,
      qatm        TYPE sy-uzeit,
      qahname     TYPE pa0001-ename,
      qahdt       TYPE sy-datum,
      qahtm       TYPE sy-uzeit,
      qahst(10)   TYPE c,
      tdname      TYPE pa0001-ename,
      tddt        TYPE sy-datum,
      tdtm        TYPE sy-uzeit,
      tdst(10)    TYPE c,
      devclodt1   TYPE sy-datum,
      clqaname    TYPE pa0001-ename,
      clqadt      TYPE sy-datum,
      clqatm      TYPE sy-uzeit,
      clqahtm     TYPE sy-uzeit,
      clqahname   TYPE pa0001-ename,
      clqahdt     TYPE sy-datum,
      devclodt2   TYPE sy-datum,
      cl2qaname   TYPE pa0001-ename,
      cl2qadt     TYPE sy-datum,
      cl2qatm     TYPE sy-uzeit,
      cl2qahname  TYPE pa0001-ename,
      cl2qahdt    TYPE sy-datum,
      cl2qahtm    TYPE sy-uzeit,
      qahrem(300) TYPE c,
      tdrem(300)  TYPE c.
DATA:  devno TYPE zdev3-devno.
DATA: kunnr TYPE t001w-kunnr.
DATA:  uname(40) TYPE c.
DATA: werks LIKE zdev1-werks.
DATA: format1(100) TYPE c.
DATA: capasop(20) TYPE c.
DATA : msg TYPE string.
TYPES : BEGIN OF tam1,
          mjahr TYPE zdev1-mjahr,
          mblnr TYPE zdev1-mblnr,
          btext TYPE t001p-btext,
          ename TYPE pa0001-ename,
          budat TYPE sy-datum,
          werks TYPE zdev1-werks,
        END OF tam1.
DATA: it_tam1 TYPE TABLE OF tam1,
      wa_tam1 TYPE tam1.
TYPES : BEGIN OF email1,
          mblnr    TYPE zdev1-mblnr,
          mjahr    TYPE zdev1-mjahr,
          email    TYPE pa0105-usrid_long,
          count(2) TYPE c,
        END OF email1.
DATA: it_email1 TYPE TABLE OF email1,
      wa_email1 TYPE email1.
DATA: e TYPE i.
DATA: count TYPE i.
DATA: lo_gos_manager TYPE REF TO cl_gos_manager,
      ls_borident    TYPE borident,
      lv_mblnr       TYPE mblnr.
DATA:
  ok_code       TYPE ui_func.
DATA: variant TYPE disvariant.
DATA : gr_alvgrid    TYPE REF TO cl_gui_alv_grid,
       gr_ccontainer TYPE REF TO cl_gui_custom_container,
       gt_fcat       TYPE lvc_t_fcat,
       gs_layo       TYPE lvc_s_layo.
DATA: c_alvgd   TYPE REF TO cl_gui_alv_grid.         "ALV grid object
DATA: gstring TYPE c.
*Data declarations for ALV
DATA: c_ccont   TYPE REF TO cl_gui_custom_container,         "Custom container object
*      C_ALVGD   TYPE REF TO CL_GUI_ALV_GRID,         "ALV grid object
      it_fcat   TYPE lvc_t_fcat,                  "Field catalogue
      it_layout TYPE lvc_s_layo.
DATA: rev(1) TYPE c.
DATA : w_return    TYPE ssfcrescl.
******************************************

DATA: format(10) TYPE c.
DATA : control  TYPE ssfctrlop.
DATA : w_ssfcompop TYPE ssfcompop.

DATA: i_otf       TYPE itcoo    OCCURS 0 WITH HEADER LINE,
      i_tline     LIKE tline    OCCURS 0 WITH HEADER LINE,
      i_record    LIKE solisti1 OCCURS 0 WITH HEADER LINE,
      i_xstring   TYPE xstring,
* Objects to send mail.
      i_objpack   LIKE sopcklsti1 OCCURS 0 WITH HEADER LINE,
      i_objtxt    LIKE solisti1   OCCURS 0 WITH HEADER LINE,
      i_objbin    LIKE solix      OCCURS 0 WITH HEADER LINE,
      i_reclist   LIKE somlreci1  OCCURS 0 WITH HEADER LINE,
* Work Area declarations
      wa_objhead  TYPE soli_tab,
      w_ctrlop    TYPE ssfctrlop,
      w_compop    TYPE ssfcompop,
*      w_return    TYPE ssfcrescl,
      wa_buffer   TYPE string,
* Variables declarations
      v_form_name TYPE rs38l_fnam,
      v_len_in    LIKE sood-objlen.
DATA: ydate TYPE sy-datum.
DATA: it_zdev41 TYPE TABLE OF zdev4,
      wa_zdev41 TYPE zdev4.

DATA: in_mailid TYPE ad_smtpadr.
DATA: txt1(100) TYPE c,
      txt2      TYPE string.
DATA: subject(310) TYPE c.
DATA: mblnr1 LIKE zdev1-mblnr.
DATA: o_encryptor        TYPE REF TO cl_hard_wired_encryptor,
      o_cx_encrypt_error TYPE REF TO cx_encrypt_error.
DATA:
*      v_ac_xstring type xstring,
  v_en_string TYPE string,
*      v_en_xstring type xstring,
  v_de_string TYPE string,
*      v_de_xstring type string,
  v_error_msg TYPE string.

****************************************************************************************

*SELECTION-SCREEN BEGIN OF BLOCK merkmale2 WITH FRAME TITLE text-002.
*PARAMETERS : pernr    TYPE pa0001-pernr,
*             pass(10) TYPE c.
**PARAMETERS : phynr LIKE qprs-phynr.
*SELECTION-SCREEN END OF BLOCK merkmale2 .

SELECTION-SCREEN BEGIN OF BLOCK merkmale1 WITH FRAME TITLE text-001.
PARAMETERS : r1  RADIOBUTTON GROUP r1,
             r2  RADIOBUTTON GROUP r1,
             r31 RADIOBUTTON GROUP r1,
             r3  RADIOBUTTON GROUP r1,
             r4  RADIOBUTTON GROUP r1.
*PARAMETERS: pernr LIKE pa0001-pernr.

SELECTION-SCREEN END OF BLOCK merkmale1.

SELECTION-SCREEN BEGIN OF BLOCK merkmale3 WITH FRAME TITLE text-001.
PARAMETERS : mblnr LIKE zdev1-mblnr,
             year  LIKE zdev1-mjahr.
*             werks LIKE zdev1-werks.
SELECTION-SCREEN END OF BLOCK merkmale3.

AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.
    CHECK screen-name EQ 'PASS'.
    screen-invisible = 1.
    MODIFY SCREEN.
  ENDLOOP.

*  PERFORM SEARCHHELP.

INITIALIZATION.
*  g_repid = sy-repid.

START-OF-SELECTION.

  PERFORM pass.

  IF r4 EQ 'X'.
  ELSE.
    IF mblnr IS INITIAL.
      MESSAGE 'ENTER DEVIATION NOTIFICATION NUMBER' TYPE 'E'.
    ENDIF.
    IF year IS INITIAL.
      MESSAGE 'ENTER DEVIATION NOTIFICATION YEAR' TYPE 'E'.
    ENDIF.
  ENDIF.

  CLEAR : it_zdev1,wa_zdev1,werks.
  SELECT SINGLE * FROM zdev1 WHERE mblnr EQ mblnr AND mjahr EQ year.
  IF sy-subrc EQ 0.
    werks = zdev1-werks.
  ENDIF.
  CLEAR : format1,capasop.
  IF werks EQ '1000'.
    format1 = 'SOP/QAD/045-09-F1 (Ref. SOP No.: SOP/QAD/045)'.
    capasop = 'SOP/QAD/094'.
  ELSEIF werks EQ '1001'.
    format1 = 'QA/GM/035-11-F1 (Ref. SOP No.: QA/GM/035)'.
    capasop = 'QA/GM/028'.
  ELSEIF werks EQ '3000'.
    capasop = 'SOP/CQD/040'.
  ENDIF.

  PERFORM auth.

  IF r4 NE 'X'.
    SELECT * FROM zdev1 INTO TABLE it_zdev1 WHERE mblnr EQ mblnr AND mjahr EQ year AND werks EQ werks.
    IF sy-subrc EQ 4.
      MESSAGE 'no data' TYPE 'E'.
    ENDIF.
  ENDIF.

  IF r1 EQ 'X'.
    PERFORM form1.
  ELSEIF r2 EQ 'X'.
    PERFORM form2.

  ELSEIF r3 EQ 'X'.
    IF sy-host CS 'SAPQLT' OR sy-host CS 'SAPDEV'.
*     IF sy-host EQ 'SAPQLT'.
    ELSE.
      PERFORM form3.
    ENDIF.
  ELSEIF r31 EQ 'X'.
    IF sy-host CS 'SAPQLT' OR sy-host CS 'SAPDEV'.
*     IF sy-host EQ 'SAPQLT' .
    ELSE.
      PERFORM appdept.
      PERFORM form1.
    ENDIF.
  ELSEIF r4 EQ 'X'.
    IF sy-host CS 'SAPQLT' OR sy-host CS 'SAPDEV'.
    ELSE.
      PERFORM autoemail.
    ENDIF.
  ENDIF.




*&---------------------------------------------------------------------*
*&      Form  AUTH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM auth .
  AUTHORITY-CHECK OBJECT 'M_BCO_WERK' ID 'WERKS' FIELD werks.
  IF sy-subrc <> 0.
    CONCATENATE 'No authorization for Plant' werks INTO msg
    SEPARATED BY space.
    MESSAGE msg TYPE 'E'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM form1 .
  CLEAR : it_tab1,wa_tab1.
  IF it_zdev1 IS NOT INITIAL.

    CLEAR : devstatus.
    LOOP AT it_zdev1 INTO wa_zdev1.
      CLEAR : n1.
      IF wa_zdev1-budat GE '20230522'.
        n1 = 'A'.
      ENDIF.

      CLEAR: d1,d2,d3,d4,d5,d6,d7,d8,d9,dtext1,dtext2.
      IF wa_zdev1-d1 EQ 'X'.
        d1 = 'Product,'.
      ENDIF.
      IF wa_zdev1-d2 EQ 'X'.
        d2 = 'Facility,'.
      ENDIF.
      IF wa_zdev1-d3 EQ 'X'.
        d3 = 'System,'.
      ENDIF.
      IF wa_zdev1-d4 EQ 'X'.
        d4 = 'Document,'.
      ENDIF.
      IF wa_zdev1-d5 EQ 'X'.
        d5 = 'Equipment/Instrument,'.
      ENDIF.
      IF wa_zdev1-d6 EQ 'X'.
        d6 = 'Procedure,'.
      ENDIF.
      IF wa_zdev1-d7 EQ 'X'.
        d7 = 'Process,'.
      ENDIF.
      IF wa_zdev1-d8 EQ 'X'.
        d8 = 'Material,'.
      ENDIF.

      IF wa_zdev1-d9 EQ 'X'.
        d9 = 'Stability,'.
      ENDIF.

      CONCATENATE d1 d2 d3 d4 d5 d6 d7 d8 d9 INTO dtext1 SEPARATED BY space.
      CONDENSE dtext1.
      IF wa_zdev1-dtext NE space.
        CONCATENATE 'Any Other: ' wa_zdev1-dtext INTO dtext2 SEPARATED BY space.
      ENDIF.
      CLEAR : deptname.
      SELECT SINGLE * FROM t001p WHERE btrtl EQ wa_zdev1-ibtrtl AND molga EQ '40'.
      IF sy-subrc EQ 0.
        deptname = t001p-btext.
      ENDIF.
      CLEAR : ename.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_zdev1-pernr AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        ename = pa0001-ename.
      ENDIF.
      CLEAR : budat,occdt,uzeit.
      budat = wa_zdev1-budat.
      uzeit = wa_zdev1-uzeit.
      occdt = wa_zdev1-occdt.
      CLEAR : pland.
      IF wa_zdev1-pl EQ 'X'.
        pland = 'PLANNED'.
      ELSEIF wa_zdev1-upl EQ 'X'.
        pland = 'UNPLANNED'.
      ENDIF.

      wa_tab1-dev1 = wa_zdev1-dev1.
      wa_tab1-dev2 = wa_zdev1-dev2.
      wa_tab1-dev3 = wa_zdev1-dev3.
      wa_tab1-dev4 = wa_zdev1-dev4 .
      wa_tab1-dev5 = wa_zdev1-dev5.
      wa_tab1-dev6 = wa_zdev1-dev6.
      wa_tab1-dev7 = wa_zdev1-dev7.
      wa_tab1-dev8 = wa_zdev1-dev8.
      wa_tab1-dev9 = wa_zdev1-dev9.
      wa_tab1-dev10 = wa_zdev1-dev10.

      wa_tab1-dsp1 = wa_zdev1-dsp1.
      wa_tab1-dsp2 = wa_zdev1-dsp2.
      wa_tab1-dsp3 = wa_zdev1-dsp3.
      wa_tab1-dsp4 = wa_zdev1-dsp4.
      wa_tab1-dsp5 =  wa_zdev1-dsp5.

      wa_tab1-ric1 = wa_zdev1-ric1.
      wa_tab1-ric2 = wa_zdev1-ric2.
      wa_tab1-ric3 = wa_zdev1-ric3.
      wa_tab1-ric4 = wa_zdev1-ric4 .
      wa_tab1-ric5 = wa_zdev1-ric5.
*
      wa_tab1-pid1 = wa_zdev1-pid1.
      wa_tab1-pid2 = wa_zdev1-pid2.
      wa_tab1-pid3 = wa_zdev1-pid3.
      wa_tab1-pid4 = wa_zdev1-pid4 .
      wa_tab1-pid5 = wa_zdev1-pid5.
      wa_tab1-pid6 = wa_zdev1-pid6.
      wa_tab1-pid7 = wa_zdev1-pid7.
      wa_tab1-pid8 = wa_zdev1-pid8.
      wa_tab1-pid9 = wa_zdev1-pid9 .
      wa_tab1-pid10 = wa_zdev1-pid10.
*
      wa_tab1-irc1 = wa_zdev1-irc1.
      wa_tab1-irc2 = wa_zdev1-irc2.
      wa_tab1-irc3 = wa_zdev1-irc3.
      wa_tab1-irc4 = wa_zdev1-irc4 .
      wa_tab1-irc5 = wa_zdev1-irc5.
      wa_tab1-irc6 = wa_zdev1-irc6.
      wa_tab1-irc7 = wa_zdev1-irc7.
      wa_tab1-irc8 = wa_zdev1-irc8.

*      ******* check revirwer & approver****************
      CLEAR : rev.
      SELECT SINGLE * FROM zqms_depthead1 WHERE btrtl EQ wa_zdev1-ibtrtl AND approver LE 0 AND TO_DT GE SY-DATUM..
      IF sy-subrc EQ 4.
        rev = 'A'.
      ENDIF.
*      IF wa_zdev1-ibtrtl EQ '1223' OR wa_zdev1-ibtrtl EQ '1224' OR wa_zdev1-ibtrtl EQ '1228'.
*      ELSE.
*        rev = 'A'.
*      ENDIF.
**********************************************************************
      CLEAR : dname,depthdt,depthtm,rdname,rdepthdt,rdepthtm,adname,adepthdt,adepthtm,stype.
      SELECT SINGLE * FROM zdev2 WHERE mblnr EQ wa_zdev1-mblnr AND mjahr EQ wa_zdev1-mjahr.
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM pa0001 WHERE pernr EQ zdev2-depth AND endda GE sy-datum.
        IF sy-subrc EQ 0.
          dname = pa0001-ename.
          depthdt = zdev2-depthdt.
          depthtm = zdev2-depthtm.
        ENDIF.

        SELECT SINGLE * FROM pa0001 WHERE pernr EQ zdev2-depth AND endda GE sy-datum.
        IF sy-subrc EQ 0.
          dname = pa0001-ename.
        ENDIF.
        depthdt = zdev2-depthdt.
        depthtm = zdev2-depthtm.

        SELECT SINGLE * FROM pa0001 WHERE pernr EQ zdev2-rdepth AND endda GE sy-datum.
        IF sy-subrc EQ 0.
          rdname = pa0001-ename.
        ENDIF.
        rdepthdt = zdev2-rdepthdt.
        rdepthtm = zdev2-rdepthtm.
        SELECT SINGLE * FROM pa0001 WHERE pernr EQ zdev2-adepth AND endda GE sy-datum.
        IF sy-subrc EQ 0.
          adname = pa0001-ename.
        ENDIF.
        adepthdt = zdev2-adepthdt.
        adepthtm = zdev2-adepthtm.

        IF zdev2-stype EQ 'Y'.
          stype = 'YES'.
        ELSEIF zdev2-stype EQ 'N'.
          stype = 'NO'.
        ENDIF.
        wa_tab1-capast1 = zdev2-capast1.
        wa_tab1-capast2 = zdev2-capast2.
        wa_tab1-capast3 = zdev2-capast3.
        wa_tab1-capast4 = zdev2-capast4.
        wa_tab1-capast5 = zdev2-capast5.
      ENDIF.
*
      CLEAR :  devstatus, devno, qa3name, qa3dt.
      SELECT SINGLE * FROM zdev3 WHERE mblnr EQ mblnr AND mjahr EQ year.
      IF sy-subrc EQ 0.
        IF zdev3-qarej EQ 'X'.
          devstatus = 'DEVIATION IS REJECTED'.
        ENDIF.
        devno = zdev3-devno.
        SELECT SINGLE * FROM pa0001 WHERE pernr EQ zdev3-qapernr AND endda GT 0.
        IF sy-subrc EQ 0.
          qa3name = pa0001-ename.
        ENDIF.
        qa3dt = zdev3-qacpudt.
      ENDIF.

      CLEAR:  rpn_s1, rpn_p1, rpn_d1,rpn_s,rpn_p,rpn_d.

      SELECT SINGLE * FROM zdev4 WHERE mblnr EQ mblnr AND mjahr EQ year.
      IF sy-subrc EQ 0.
        IF zdev4-qahrej EQ 'X'.
          devstatus = 'DEVIATION IS REJECTED'.
        ENDIF.
        IF zdev4-tdrej EQ 'X'.
          devstatus = 'DEVIATION IS REJECTED'.
        ENDIF.
        wa_tab1-rad1 = zdev4-rad1.
        wa_tab1-rad2 = zdev4-rad2.
        wa_tab1-rad3 = zdev4-rad3.
        wa_tab1-rad4 = zdev4-rad4.
        wa_tab1-rad5 = zdev4-rad5.
        wa_tab1-rad6 = zdev4-rad6.
        wa_tab1-rad7 = zdev4-rad7.
        wa_tab1-rad8 = zdev4-rad8.
        wa_tab1-rad9 = zdev4-rad9.
        wa_tab1-rad10 = zdev4-rad10.
*        BREAK-POINT .
        rpn_s1 = zdev4-rpn_s.
        rpn_p1 = zdev4-rpn_p.
        rpn_d1 = zdev4-rpn_d.
        PACK rpn_s1 TO rpn_s1.
        PACK rpn_p1 TO rpn_p1.
        PACK rpn_d1 TO rpn_d1.

        CONDENSE rpn_s1.
        CONDENSE rpn_p1.
        CONDENSE rpn_d1.
        rpn_s = rpn_s1.
        rpn_p = rpn_p1.
        rpn_d = rpn_d1.
        CONDENSE  rpn_s.
        rpnval = zdev4-rpn_s * zdev4-rpn_p * zdev4-rpn_d.
        CLEAR : rpnstat.
        IF rpnval GT 76.
          rpnstat = 'CRITICAL'.
        ELSEIF rpnval GT 25 AND rpnval LE 75.
          rpnstat = 'MAJOR'.
        ELSEIF  rpnval GT 0 AND rpnval LE 25.
          rpnstat = 'MINOR'.
        ENDIF.
        CLEAR : pland.
        IF zdev4-pland EQ 'Y'.
          pland = 'PLANNED'.
        ELSEIF zdev4-pland EQ 'N'.
          pland = 'UNPLANNED'.
        ENDIF.
        CLEAR : invsat,furinv,invrepno.
        IF zdev4-invsat EQ 'Y'.
          invsat = 'YES'.
        ELSEIF zdev4-invsat EQ 'N'.
          invsat = 'NO'.
        ENDIF.
        IF zdev4-furinv EQ 'Y'.
          furinv = 'YES'.
        ELSEIF zdev4-furinv EQ 'N'.
          furinv = 'NO'.
        ENDIF.
        wa_tab1-qarem1 = zdev4-qarem1.
        wa_tab1-qarem2 = zdev4-qarem2.
        wa_tab1-qarem3 = zdev4-qarem3.
        wa_tab1-qarem4 = zdev4-qarem4.
        wa_tab1-qarem5 = zdev4-qarem5.
        invrepno = zdev4-invrepno.

*        wa_tab1-acpa1 = zdev4-acpa1.
*        wa_tab1-acpa2 = zdev4-acpa2.
*        wa_tab1-acpa3 = zdev4-acpa3.
*        wa_tab1-acpa4 = zdev4-acpa4.
*        wa_tab1-acpa5 = zdev4-acpa5.
*        wa_tab1-acpa6 = zdev4-acpa6.
*        wa_tab1-acpa7 = zdev4-acpa7.
*        wa_tab1-acpa8 = zdev4-acpa8.
*        wa_tab1-acpa9 = zdev4-acpa9.
*        wa_tab1-acpa10 = zdev4-acpa10.
        CLEAR : qaname,qadt,qatm.
        SELECT SINGLE * FROM pa0001 WHERE pernr EQ zdev4-pernr AND endda GT 0.
        IF sy-subrc EQ 0.
          qaname = pa0001-ename.
          qadt = zdev4-budat.
          qatm = zdev4-uzeit.
        ENDIF.
        CLEAR : qahname,qahdt,qahtm.
        SELECT SINGLE * FROM pa0001 WHERE pernr EQ zdev4-qahead AND endda GT 0.
        IF sy-subrc EQ 0.
          qahname = pa0001-ename.
          qahdt = zdev4-qaheaddt.
          qahtm = zdev4-qaheadtm.
        ENDIF.
        CLEAR : qahst,qahrem.
        IF zdev4-qahapr EQ 'X'.
          qahst = 'APPROVED'.
        ELSEIF zdev4-qahrej EQ 'X'.
          qahst = 'REJECTED'.
        ELSE.
          qahst = '______'.
        ENDIF.
        CONCATENATE zdev4-qahrem1 zdev4-qahrem2 INTO qahrem.
        CLEAR :  tdname,tddt,tdtm,tdst,tdrem.
        SELECT SINGLE * FROM pa0001 WHERE pernr EQ zdev4-td AND endda GT 0.
        IF sy-subrc EQ 0.
          tdname = pa0001-ename.
          tddt = zdev4-tddate.
          tdtm = zdev4-tdtime.
        ENDIF.
        IF zdev4-tdapr EQ 'X'.
          tdst = 'AUTHORIZED'.
        ELSEIF zdev4-tdrej EQ 'X'.
          tdst = 'REJECTED'.
        ELSE.
          tdst = '_______'.
        ENDIF.
        CONCATENATE zdev4-tdrem1 zdev4-tdrem2 INTO tdrem.

*        SELECT SINGLE * FROM zdev6 WHERE mblnr EQ mblnr AND mjahr EQ year.
*        IF sy-subrc EQ 0.
*          refcapano = zdev6-refcapano.
*
**        wa_tab1-caparem1 = zdev6-caparem1.
**        wa_tab1-caparem2 = zdev6-caparem2.
**        wa_tab1-caparem3 = zdev6-caparem3.
**        wa_tab1-caparem4 = zdev6-caparem4.
**        wa_tab1-caparem5 = zdev6-caparem5.
**        wa_tab1-caparem6 = zdev4-caparem6.
**        wa_tab1-caparem7 = zdev4-caparem7.
**        wa_tab1-caparem8 = zdev4-caparem8.
**        wa_tab1-caparem9 = zdev4-caparem9.
**        wa_tab1-caparem10 = zdev4-caparem10.
*          devclodt = zdev6-devclodt1.
*
*          SELECT SINGLE * FROM pa0001 WHERE pernr EQ zdev4-qa1 AND endda GT 0.
*          IF sy-subrc EQ 0.
*            clqaname = pa0001-ename.
*          ENDIF.
*          clqadt = zdev6-qa1dt.
*          SELECT SINGLE * FROM pa0001 WHERE pernr EQ zdev6-qa1head AND endda GT 0.
*          IF sy-subrc EQ 0.
*            clqahname = pa0001-ename.
*            clqahdt = zdev4-qaheaddt.
*          ENDIF.
*        ENDIF.

*         WA_TAB1-ACPA1 = ZDEV4-ACPA1.



      ENDIF.
      CLEAR : devclodt1 ,clqaname, clqadt,clqahname, clqahdt,  devclodt2 ,clqatm,clqahtm,cl2qadt,cl2qatm,cl2qahdt,cl2qahtm.
      SELECT SINGLE * FROM zdev6 WHERE mblnr EQ mblnr AND mjahr EQ year.
      IF sy-subrc EQ 0.

        wa_tab1-capacl1 = zdev6-capacl1.
        wa_tab1-capacl2 = zdev6-capacl2.
        wa_tab1-capacl3 = zdev6-capacl3.
        wa_tab1-capacl4 = zdev6-capacl4.
        wa_tab1-capacl5 = zdev6-capacl5.

        wa_tab1-capacl11 = zdev6-capacl11.
        wa_tab1-capacl12 = zdev6-capacl12.
        wa_tab1-capacl13 = zdev6-capacl13.
        wa_tab1-capacl14 = zdev6-capacl14.
        wa_tab1-capacl15 = zdev6-capacl15.

        devclodt1 = zdev6-devclodt1.
        SELECT SINGLE * FROM pa0001 WHERE pernr EQ zdev6-qa1 AND endda GT 0.
        IF sy-subrc EQ 0.
          clqaname = pa0001-ename.
        ENDIF.
        clqadt = zdev6-qa1dt.
        clqatm = zdev6-qa1tm.
        SELECT SINGLE * FROM pa0001 WHERE pernr EQ zdev6-qa1head AND endda GT 0.
        IF sy-subrc EQ 0.
          clqahname = pa0001-ename.
*          clqahdt = zdev4-qaheaddt.
        ENDIF.
        clqahdt = zdev6-qa1headdt.  "13.3.23
        clqahtm = zdev6-qa1headtm.  "13.3.23

        devclodt2 = zdev6-devclodt2.
        SELECT SINGLE * FROM pa0001 WHERE pernr EQ zdev6-qa2 AND endda GT 0.
        IF sy-subrc EQ 0.
          cl2qaname = pa0001-ename.
        ENDIF.
        cl2qadt = zdev6-qa2dt.
        cl2qatm = zdev6-qa2tm.
        SELECT SINGLE * FROM pa0001 WHERE pernr EQ zdev6-qa2head AND endda GT 0.
        IF sy-subrc EQ 0.
          cl2qahname = pa0001-ename.
*          cl2qahdt = zdev4-qaheaddt.
*          cl2qahtm = zdev4-qaheadtm.
          cl2qahdt = zdev6-qa2headdt.
          cl2qahtm = zdev6-qa2headtm.
        ENDIF.

*        CLEAR: d11,d12,d13,d14,d15,d16,d17,d18,d19,dtext3,dtext4.
*        IF zdev6-dev EQ 'X'.
*          d11 = 'Deviation,'.
*        ENDIF.
*        IF zdev6-inv EQ 'X'.
*          d12 = 'Investigation Report,'.
*        ENDIF.
*        IF zdev6-aud EQ 'X'.
*          d13 = 'Audit Findings,'.
*        ENDIF.
*        IF zdev6-sho EQ 'X'.
*          d14 = 'Shop Floor Incident,'.
*        ENDIF.
*        IF zdev6-lab EQ 'X'.
*          d15 = 'Laboratory incident,'.
*        ENDIF.
*        IF zdev6-oos EQ 'X'.
*          d16 = 'OOS,'.
*        ENDIF.
*        IF zdev6-mar EQ 'X'.
*          d17 = 'Market complaint,'.
*        ENDIF.
*        IF zdev6-pro EQ 'X'.
*          d18 = 'Product recall'.
*        ENDIF.
*        CONCATENATE d11 d12 d13 d14 d15 d16 d17 d18 INTO dtext3 SEPARATED BY space.
*        CONDENSE dtext3.
*        IF zdev6-anyo NE space.
*          CONCATENATE 'Any Othre: ' zdev6-anyo INTO dtext4 SEPARATED BY space.
*        ENDIF.
*        SELECT SINGLE * FROM pa0001 WHERE pernr EQ zdev6-qa AND endda GE sy-datum.
*        IF sy-subrc EQ 0.
*          cqaname = pa0001-ename.
*        ENDIF.
*        cqadt = zdev6-qadt.
*        SELECT SINGLE * FROM pa0001 WHERE pernr EQ zdev6-qahead AND endda GE sy-datum.
*        IF sy-subrc EQ 0.
*          cqahname = pa0001-ename.
*        ENDIF.
*        cqahdt = zdev6-qaheaddt.
*        SELECT SINGLE * FROM pa0001 WHERE pernr EQ zdev6-td AND endda GE sy-datum.
*        IF sy-subrc EQ 0.
*          ctdname = pa0001-ename.
*        ENDIF.
*        ctddt = zdev6-tddt.
*        CLEAR : capacl.
*        IF zdev6-cl1pernr GT 0.
*          capacl = '1'.
*          SELECT SINGLE * FROM pa0001 WHERE pernr EQ zdev6-cl1pernr AND endda GE sy-datum.
*          IF sy-subrc EQ 0.
*            cclname = pa0001-ename.
*          ENDIF.
*          ccldt = zdev6-cl1dt.
*          capacldt = zdev6-capacldt.
*          SELECT SINGLE * FROM pa0001 WHERE pernr EQ zdev6-cl1hpernr AND endda GE sy-datum.
*          IF sy-subrc EQ 0.
*            cclhname = pa0001-ename.
*          ENDIF.
*          cclhdt = zdev6-cl1dt.
*          clrem1 = zdev6-clrem1.
*          clrem2 = zdev6-clrem2.
*          clrem3 = zdev6-clrem3.



*        ENDIF.


      ENDIF.

      COLLECT wa_tab1 INTO it_tab1 .
      CLEAR wa_tab1.


    ENDLOOP.
  ENDIF.
  CLEAR : it_zdev5,wa_zdev5.
  IF it_zdev1 IS NOT INITIAL.
    SELECT * FROM zdev5 INTO TABLE it_zdev5 FOR ALL ENTRIES IN it_zdev1 WHERE mblnr EQ it_zdev1-mblnr AND mjahr EQ it_zdev1-mjahr.
  ENDIF.
  CLEAR : dept.
  IF it_zdev5 IS NOT INITIAL.
    LOOP AT it_zdev5 INTO wa_zdev5.
      wa_tab2-btrtl = wa_zdev5-btrtl.
      SELECT SINGLE * FROM t001p WHERE btrtl EQ wa_zdev5-btrtl AND molga EQ '40'.
      IF sy-subrc EQ 0.
        wa_tab2-deptname = t001p-btext.
      ENDIF.
      dept = '1'.
      COLLECT wa_tab2 INTO it_tab2.
      CLEAR wa_tab2.
      CLEAR : qahnmapp,qahdtapp, qahtmapp.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_zdev5-pernr AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        qahnmapp = pa0001-ename.
      ENDIF.
      qahdtapp = wa_zdev5-cpudt.
      qahtmapp = wa_zdev5-uzeit.
    ENDLOOP.
  ENDIF.
*  IF it_zdev1 IS NOT INITIAL.
*    SELECT * FROM zdev7 INTO TABLE it_zdev7 FOR ALL ENTRIES IN it_zdev1 WHERE mblnr EQ it_zdev1-mblnr AND mjahr EQ it_zdev1-mjahr.
*  ENDIF.
**BREAK-POINT.
*  LOOP AT it_zdev7 INTO wa_zdev7 WHERE imp1 NE space.
*    wa_act1-imp = wa_zdev7-imp1.
*    SELECT SINGLE * FROM t001p WHERE btrtl EQ wa_zdev7-btrtl.
*    IF sy-subrc EQ 0.
*      wa_act1-deptname = t001p-btext.
*    ENDIF.
*    wa_act1-tcd1 = wa_zdev7-tcd1.
*    wa_act1-acd1 = wa_zdev7-acd1.
*    IF wa_zdev7-qa1 GT 0.
*      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_zdev7-qa1 AND endda GE sy-datum.
*      IF sy-subrc EQ 0.
*        wa_act1-qaname = pa0001-ename.
*      ENDIF.
*    ENDIF.
*    wa_act1-qadt = wa_zdev7-qa1dt.
*    wa_act1-count = wa_zdev7-buzei.
*    COLLECT wa_act1 INTO it_act1.
*    CLEAR wa_act1.
*  ENDLOOP.

*************additional dept comments on Deviation****************
  CLEAR : adddept.
  CLEAR : it_zdev51,wa_zdev51.
  CLEAR : it_tab3,wa_tab3.
  IF it_zdev1 IS NOT INITIAL.
    SELECT * FROM zdev5 INTO TABLE it_zdev51 FOR ALL ENTRIES IN it_zdev1 WHERE mblnr EQ it_zdev1-mblnr AND mjahr EQ it_zdev1-mjahr AND com EQ 'X'.
  ENDIF.
  IF it_zdev51 IS NOT INITIAL.
    LOOP AT it_zdev51 INTO wa_zdev51.
      adddept = '1'.
      wa_tab3-btrtl = wa_zdev51-btrtl.
      SELECT SINGLE * FROM t001p WHERE btrtl EQ wa_zdev51-btrtl AND molga EQ '40'.
      IF sy-subrc EQ 0.
        wa_tab3-deptname = t001p-btext.
      ENDIF.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_zdev51-addpernr AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        wa_tab3-ename = pa0001-ename.
      ENDIF.
      wa_tab3-budat = wa_zdev51-addcpudt.
      COLLECT wa_tab3 INTO it_tab3.
      CLEAR wa_tab3.
    ENDLOOP.
  ENDIF.
  CLEAR : it_tab4,wa_tab4.
  IF it_zdev51 IS NOT INITIAL.
    LOOP AT it_zdev51 INTO wa_zdev51.
      wa_tab4-btrtl = wa_zdev51-btrtl.
      wa_tab4-com1 = wa_zdev51-com1.
      wa_tab4-com2 = wa_zdev51-com2.
      wa_tab4-com3 = wa_zdev51-com3.
      wa_tab4-com4 = wa_zdev51-com4.
      wa_tab4-com5 = wa_zdev51-com5.
      wa_tab4-com6 = wa_zdev51-com6.
      wa_tab4-com7 = wa_zdev51-com7.
      wa_tab4-com8 = wa_zdev51-com8.
      wa_tab4-com9 = wa_zdev51-com9.
      wa_tab4-com10 = wa_zdev51-com10.
      COLLECT wa_tab4 INTO it_tab4.
      CLEAR wa_tab4.
    ENDLOOP.
  ENDIF.
*  **********  RECOMMENDED & CORRECTIVE ACTION FROM TABLE ZDEV21.
  CLEAR : it_tab5,wa_tab5.
  CLEAR : it_zdev8,wa_zdev8.
  IF it_zdev1 IS NOT INITIAL.
    SELECT * FROM zdev8 INTO TABLE it_zdev8 FOR ALL ENTRIES IN it_zdev1 WHERE mblnr EQ it_zdev1-mblnr AND mjahr EQ it_zdev1-mjahr.
  ENDIF.
*  BREAK-POINT .
  DELETE it_zdev8 WHERE imp1 EQ space.
  IF it_zdev8 IS NOT INITIAL.
    LOOP AT it_zdev8 INTO wa_zdev8.
      CLEAR : txt2.
      CONCATENATE wa_zdev8-imp1 wa_zdev8-imp2 INTO txt2.
      CONDENSE txt2.
      wa_tab5-rcpa  = txt2.
      CONDENSE wa_tab5-rcpa.
      wa_tab5-btrtl = wa_zdev8-btrtl.
      wa_tab5-tcd = wa_zdev8-tcd.
      SELECT SINGLE * FROM t001p WHERE btrtl EQ wa_zdev8-btrtl AND molga EQ '40'.
      IF sy-subrc EQ 0.
        wa_tab5-deptname = t001p-btext.
      ENDIF.
      wa_tab5-count = wa_zdev8-buzei.
      COLLECT wa_tab5 INTO it_tab5.
      CLEAR wa_tab5.
    ENDLOOP.
  ENDIF.
  DELETE it_tab5 WHERE rcpa EQ space.
*BREAK-POINT.
*  *  **********    QA RECOMMENDED & CORRECTIVE ACTION FROM TABLE ZDEV21.
  CLEAR : it_tab6,wa_tab6.
  CLEAR : it_zdev9,wa_zdev9.
  IF it_zdev1 IS NOT INITIAL.
    SELECT * FROM zdev9 INTO TABLE it_zdev9 FOR ALL ENTRIES IN it_zdev1 WHERE mblnr EQ it_zdev1-mblnr AND mjahr EQ it_zdev1-mjahr.
  ENDIF.
  DELETE it_zdev9 WHERE imp1 EQ space.
  IF it_zdev9 IS NOT INITIAL.
    LOOP AT it_zdev9 INTO wa_zdev9.
      CONCATENATE wa_zdev9-imp1 wa_zdev9-imp2 INTO  wa_tab6-rcpa SEPARATED BY space.
      wa_tab6-btrtl = wa_zdev9-btrtl.
      wa_tab6-tcd = wa_zdev9-tcd.
      wa_tab6-acd = wa_zdev9-acd.
      wa_tab6-longt = wa_zdev9-longt.
      SELECT SINGLE * FROM t001p WHERE btrtl EQ wa_zdev9-btrtl AND molga EQ '40'.
      IF sy-subrc EQ 0.
        wa_tab6-deptname = t001p-btext.
      ENDIF.
      wa_tab6-count = wa_zdev9-buzei.
      COLLECT wa_tab6 INTO it_tab6.
      CLEAR wa_tab6.
    ENDLOOP.
  ENDIF.
  DELETE it_tab6 WHERE rcpa EQ space.

*  *  **********    LONG TERM QA RECOMMENDED & CORRECTIVE ACTION FROM TABLE ZDEV21.
  CLEAR : longt.
  CLEAR : it_tab7,wa_tab7,it_zdev9,wa_zdev9.
  IF it_zdev1 IS NOT INITIAL.
    SELECT * FROM zdev9 INTO TABLE it_zdev9 FOR ALL ENTRIES IN it_zdev1 WHERE mblnr EQ it_zdev1-mblnr AND mjahr EQ it_zdev1-mjahr AND longt NE space.
  ENDIF.
  DELETE it_zdev9 WHERE imp1 EQ space.
  IF it_zdev9 IS NOT INITIAL.
    CLEAR : count.
    count = 1.
    LOOP AT it_zdev9 INTO wa_zdev9 WHERE longt NE space.
      longt = 'A'.
      CONCATENATE wa_zdev9-imp1 wa_zdev9-imp2 INTO  wa_tab7-rcpa SEPARATED BY space.
      wa_tab7-btrtl = wa_zdev9-btrtl.
      wa_tab7-tcd = wa_zdev9-tcd.
      wa_tab7-acd = wa_zdev9-acd.
      wa_tab7-longt = wa_zdev9-longt.
      SELECT SINGLE * FROM t001p WHERE btrtl EQ wa_zdev9-btrtl AND molga EQ '40'.
      IF sy-subrc EQ 0.
        wa_tab7-deptname = t001p-btext.
      ENDIF.
*      wa_tab7-count = wa_zdev9-buzei.
      wa_tab7-count = count.
      COLLECT wa_tab7 INTO it_tab7.
      CLEAR wa_tab7.
      count = count + 1.
    ENDLOOP.
  ENDIF.
  DELETE it_tab7 WHERE rcpa EQ space.

*  *  **********    QA RECOMMENDED & CORRECTIVE ACTION FROM TABLE ZDEV21.
*  BREAK-POINT.
  CLEAR : count.
  CLEAR : it_tab8,wa_tab8.
  CLEAR : it_zdev9,wa_zdev9.
  IF it_zdev1 IS NOT INITIAL.
    SELECT * FROM zdev9 INTO TABLE it_zdev9 FOR ALL ENTRIES IN it_zdev1 WHERE mblnr EQ it_zdev1-mblnr AND mjahr EQ it_zdev1-mjahr AND longt EQ space.
  ENDIF.
  DELETE it_zdev9 WHERE imp1 EQ space.
  count = 1.
  IF it_zdev9 IS NOT INITIAL.
    LOOP AT it_zdev9 INTO wa_zdev9.
      CONCATENATE wa_zdev9-imp1 wa_zdev9-imp2 INTO  wa_tab8-rcpa SEPARATED BY space.
      wa_tab8-btrtl = wa_zdev9-btrtl.
      wa_tab8-tcd = wa_zdev9-tcd.
      wa_tab8-acd = wa_zdev9-acd.
      wa_tab8-longt = wa_zdev9-longt.
      SELECT SINGLE * FROM t001p WHERE btrtl EQ wa_zdev9-btrtl AND molga EQ '40'.
      IF sy-subrc EQ 0.
        wa_tab8-deptname = t001p-btext.
      ENDIF.
      wa_tab8-count = count.
      COLLECT wa_tab8 INTO it_tab8.
      CLEAR wa_tab8.
      count = count + 1.
    ENDLOOP.
  ENDIF.
  DELETE it_tab8 WHERE rcpa EQ space.

*  BREAK-POINT.

*  LOOP AT it_zdev6 INTO wa_zdev6 WHERE imp2 NE space.
*    wa_act1-imp = wa_zdev6-imp2.
*    SELECT SINGLE * FROM t001p WHERE btrtl EQ wa_zdev6-dept2.
*    IF sy-subrc EQ 0.
*      wa_act1-deptname = t001p-btext.
*    ENDIF.
*    wa_act1-tcd1 = wa_zdev6-tcd2.
*    wa_act1-acd1 = wa_zdev6-acd2.
*    IF wa_zdev6-qa1 GT 0.
*      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_zdev6-qa1 AND endda GE sy-datum.
*      IF sy-subrc EQ 0.
*        wa_act1-qaname = pa0001-ename.
*      ENDIF.
*    ENDIF.
*    wa_act1-qadt = wa_zdev6-qa1dt.
*    wa_act1-count = '1'.
*    COLLECT wa_act1 INTO it_act1.
*    CLEAR wa_act1.
*  ENDLOOP.


  IF werks EQ '1000'.
    kunnr = 'NASHIK'.
  ELSEIF werks EQ '1001'.
    kunnr = 'GOA'.
  ELSE.
    kunnr = 'MUMBAI'.
  ENDIF.

  CLEAR : uname.
*  SELECT SINGLE * FROM pa0002 WHERE pernr EQ pernr AND endda GE sy-datum.
  IF sy-subrc EQ 0.
    CONCATENATE pa0002-vorna pa0002-nachn INTO uname SEPARATED BY space.
  ENDIF.


  IF r1 EQ 'X'.

    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
*       formname           = 'ZDEV6'
*       formname           = 'ZDEV7'
*       formname           = 'ZDEV8'
*       formname           = 'ZDEV9'
*       formname           = 'ZDEV10'
*       formname           = 'ZDEV11'
        formname           = 'ZDEV1'
*       VARIANT            = ' '
*       DIRECT_CALL        = ' '
      IMPORTING
        fm_name            = v_fm
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.

    CALL FUNCTION v_fm
      EXPORTING
        mblnr            = mblnr
        year             = year
        werks            = werks
        dtext1           = dtext1
        dtext2           = dtext2
        dtext3           = dtext3
        dtext4           = dtext4
        deptname         = deptname
        ename            = ename
        budat            = budat
        uzeit            = uzeit
        occdt            = occdt
        dname            = dname
        depthdt          = depthdt
        depthtm          = depthtm
        rdepthtm         = rdepthtm
        adepthtm         = adepthtm
        rdname           = rdname
        rdepthdt         = rdepthdt
        adname           = adname
        adepthdt         = adepthdt
        stype            = stype
        rpn_s            = rpn_s
        rpn_p            = rpn_p
        rpn_d            = rpn_d
        rpnval           = rpnval
        invsat           = invsat
        furinv           = furinv
        invrepno         = invrepno
        rpnstat          = rpnstat
        qaname           = qaname
        qadt             = qadt
        qatm             = qatm
        qahname          = qahname
        qahdt            = qahdt
        qahtm            = qahtm
        qahst            = qahst
        tdname           = tdname
        tddt             = tddt
        tdtm             = tdtm
        tdst             = tdst
        dept             = dept
        qahnmapp         = qahnmapp
        qahdtapp         = qahdtapp
        qahtmapp         = qahtmapp
        devclodt1        = devclodt1
        clqaname         = clqaname
        clqadt           = clqadt
        clqatm           = clqatm
        clqahname        = clqahname
        clqahdt          = clqahdt
        clqahtm          = clqahtm
        devclodt2        = devclodt2
        cl2qaname        = cl2qaname
        cl2qadt          = cl2qadt
        cl2qatm          = cl2qatm
        cl2qahtm         = cl2qahtm
        cl2qahname       = cl2qahname
        cl2qahdt         = cl2qahdt
        devno            = devno
        qa3name          = qa3name
        qa3dt            = qa3dt
        kunnr            = kunnr
        pland            = pland
        cqaname          = cqaname
        cqadt            = cqadt
        cqahname         = cqahname
        cqahdt           = cqahdt
        ctdname          = ctdname
        ctddt            = ctddt
        capacl           = capacl
        cclname          = cclname
        ccldt            = ccldt
        capacldt         = capacldt
        cclhname         = cclhname
        cclhdt           = cclhdt
*       clrem1           = clrem1
*       clrem2           = clrem2
*       clrem3           = clrem3
        adddept          = adddept
        sp1              = sp1
        rev              = rev
        longt            = longt
        qahrem           = qahrem
        tdrem            = tdrem
        format1          = format1
        devstatus        = devstatus
        capasop          = capasop
        n1               = n1
        uname            = uname
      TABLES
        it_tab1          = it_tab1
        it_tab2          = it_tab2
        it_tab3          = it_tab3
        it_tab4          = it_tab4
        it_tab5          = it_tab5
        it_tab6          = it_tab6
        it_tab7          = it_tab7
        it_tab8          = it_tab8
*       it_vbrp          = it_vbrp
*       ITAB_DIVISION    = ITAB_DIVISION
*       ITAB_STORAGE     = ITAB_STORAGE
*       ITAB_PA0002      = ITAB_PA0002
      EXCEPTIONS
        formatting_error = 1
        internal_error   = 2
        send_error       = 3
        user_canceled    = 4
        OTHERS           = 5.

    CLEAR : it_tab3,wa_tab3,it_tab4,wa_tab4,it_tab1,wa_tab1,it_tab2,wa_tab2,it_tab5,wa_tab5,it_tab6,wa_tab6,it_tab7,wa_tab7,it_tab8,wa_tab8.
*****************
    CLEAR : mblnr,year, werks,dtext1, dtext2,dtext3, dtext4,deptname, ename,budat, occdt,dname, depthdt,rdname, rdepthdt,adname,adepthdt,
    stype,rpn_s,rpn_p,rpn_d, rpnval,invsat,furinv,invrepno,rpnstat, qaname,qadt,qahname,qahdt,qahst,tdname,tddt,tdst,dept, qahnmapp,qahdtapp,
    devclodt1,clqaname,clqadt,clqahname,clqahdt,devclodt2,cl2qaname,cl2qadt,cl2qahname,cl2qahdt,devno,qa3name,qa3dt,kunnr,pland,cqaname,
    cqadt,cqahname,cqahdt, ctdname,ctddt,capacl,cclname, ccldt, capacldt,cclhname, cclhdt,
    adddept,sp1,rev,longt,qahrem,tdrem,format1,devstatus,capasop,clqatm,clqahtm,cl2qatm,cl2qahtm,n1.
**********************

  ELSEIF r3 EQ 'X' OR r31 EQ 'X' OR r4 EQ 'X'.

    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
*       formname           = 'ZDEV6'
*       formname           = 'ZDEV7'
*       formname           = 'ZDEV8'
*       formname           = 'ZDEV9'
*       formname           = 'ZDEV11'
        formname           = 'ZDEV1'
*       VARIANT            = ' '
*       DIRECT_CALL        = ' '
      IMPORTING
        fm_name            = v_fm
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

* set the control parameter
    w_ctrlop-getotf = abap_true.
    w_ctrlop-no_dialog = abap_true.
    w_compop-tdnoprev = abap_true.
    w_ctrlop-preview = space.
    w_compop-tddest = 'LOCL'.

    CALL FUNCTION v_fm
      EXPORTING
        control_parameters = w_ctrlop
        output_options     = w_compop
        user_settings      = abap_true
        mblnr              = mblnr
        year               = year
        werks              = werks
        dtext1             = dtext1
        dtext2             = dtext2
        dtext3             = dtext3
        dtext4             = dtext4
        deptname           = deptname
        ename              = ename
        budat              = budat
        uzeit              = uzeit
        occdt              = occdt
        dname              = dname
        depthdt            = depthdt
        depthtm            = depthtm
        rdepthtm           = rdepthtm
        adepthtm           = adepthtm
        rdname             = rdname
        rdepthdt           = rdepthdt
        adname             = adname
        adepthdt           = adepthdt
        stype              = stype
        rpn_s              = rpn_s
        rpn_p              = rpn_p
        rpn_d              = rpn_d
        rpnval             = rpnval
        invsat             = invsat
        furinv             = furinv
        invrepno           = invrepno
        rpnstat            = rpnstat
        qaname             = qaname
        qadt               = qadt
        qatm               = qatm
        qahname            = qahname
        qahdt              = qahdt
        qahtm              = qahtm
        qahst              = qahst
        tdname             = tdname
        tddt               = tddt
        tdtm               = tdtm
        tdst               = tdst
        dept               = dept
        qahnmapp           = qahnmapp
        qahdtapp           = qahdtapp
        qahtmapp           = qahtmapp
        devclodt1          = devclodt1
        clqaname           = clqaname
        clqadt             = clqadt
        clqatm             = clqatm
        cl2qatm            = cl2qatm
        cl2qahtm           = cl2qahtm
        clqahname          = clqahname
        clqahdt            = clqahdt
        clqahtm            = clqahtm
        devclodt2          = devclodt2
        cl2qaname          = cl2qaname
        cl2qadt            = cl2qadt
        cl2qahname         = cl2qahname
        cl2qahdt           = cl2qahdt
        devno              = devno
        qa3name            = qa3name
        qa3dt              = qa3dt
        kunnr              = kunnr
        pland              = pland
        cqaname            = cqaname
        cqadt              = cqadt
        cqahname           = cqahname
        cqahdt             = cqahdt
        ctdname            = ctdname
        ctddt              = ctddt
        capacl             = capacl
        cclname            = cclname
        ccldt              = ccldt
        capacldt           = capacldt
        cclhname           = cclhname
        cclhdt             = cclhdt
*       clrem1             = clrem1
*       clrem2             = clrem2
*       clrem3             = clrem3
        adddept            = adddept
        sp1                = sp1
        rev                = rev
        longt              = longt
        qahrem             = qahrem
        tdrem              = tdrem
        format1            = format1
        devstatus          = devstatus
        capasop            = capasop
        n1                 = n1
        uname              = uname
      IMPORTING
        job_output_info    = w_return " This will have all output
      TABLES
        it_tab1            = it_tab1
        it_tab2            = it_tab2
        it_tab3            = it_tab3
        it_tab4            = it_tab4
        it_tab5            = it_tab5
        it_tab6            = it_tab6
        it_tab7            = it_tab7
        it_tab8            = it_tab8
*       it_vbrp            = it_vbrp
*       ITAB_DIVISION      = ITAB_DIVISION
*       ITAB_STORAGE       = ITAB_STORAGE
*       ITAB_PA0002        = ITAB_PA0002
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.

    CLEAR : it_tab3,wa_tab3,it_tab4,wa_tab4,it_tab5,wa_tab5,it_tab6,wa_tab6,it_tab7,wa_tab7.
    CLEAR : it_tab3,wa_tab3,it_tab4,wa_tab4,it_tab1,wa_tab1,it_tab2,wa_tab2,it_tab5,wa_tab5,it_tab6,wa_tab6,it_tab7,wa_tab7,it_tab8,wa_tab8.
    CLEAR : mblnr,year, werks,dtext1, dtext2,dtext3, dtext4,deptname, ename,budat,uzeit,depthtm,rdepthtm,adepthtm, occdt,dname, depthdt,rdname, rdepthdt,adname,adepthdt,
  stype,rpn_s,rpn_p,rpn_d, rpnval,invsat,furinv,invrepno,rpnstat, qaname,qadt,qahname,qahdt,qahst,tdname,tddt,tdst,dept, qahnmapp,qahdtapp,
  devclodt1,clqaname,clqadt,clqahname,clqahdt,devclodt2,cl2qaname,cl2qadt,cl2qahname,cl2qahdt,devno,qa3name,qa3dt,kunnr,pland,cqaname,
  cqadt,cqahname,cqahdt, ctdname,ctddt,capacl,cclname, ccldt, capacldt,cclhname, cclhdt,
  adddept,sp1,rev,longt,qahrem,tdrem,format1,devstatus,capasop,qatm,qahtm,tdtm,qahtmapp,clqatm,clqahtm,cl2qatm,cl2qahtm,n1.

*    *    * Get Output Text Format (OTF)
    i_otf[] = w_return-otfdata[].

* Import Binary file and filesize
    CALL FUNCTION 'CONVERT_OTF'
      EXPORTING
        format                = 'PDF'
        max_linewidth         = 132
      IMPORTING
        bin_filesize          = v_len_in
        bin_file              = i_xstring   " This is NOT Binary. This is Hexa
      TABLES
        otf                   = i_otf
        lines                 = i_tline
      EXCEPTIONS
        err_max_linewidth     = 1
        err_format            = 2
        err_conv_not_possible = 3
        OTHERS                = 4.
* Sy-subrc check not checked



*  * Convert Hexa String to Binary format
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer     = i_xstring
      TABLES
        binary_tab = i_objbin[].

*    BREAK-POINT.

*         in_mailid = s_email-low.
    DELETE it_email1 WHERE email EQ space.
    SORT it_email1 BY email.
    DELETE ADJACENT DUPLICATES FROM it_email1 COMPARING email.
    LOOP AT it_email1 INTO wa_email1.
      in_mailid  = wa_email1-email.
*      BREAK-POINT.
*    in_mailid  = 'jyotsna@bluecrosslabs.com'.
      PERFORM send_mail USING in_mailid .
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FORM2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM form2 .
  LOOP AT it_zdev1 INTO wa_zdev1.
    wa_tam1-mblnr = wa_zdev1-mblnr.
    wa_tam1-mjahr = wa_zdev1-mjahr.
    SELECT SINGLE * FROM t001p WHERE btrtl EQ wa_zdev1-ibtrtl.
    IF sy-subrc EQ 0.
      wa_tam1-btext = t001p-btext.
    ENDIF.
    wa_tam1-werks = wa_zdev1-werks.
    SELECT SINGLE * FROM pa0001 WHERE pernr EQ zdev1-pernr AND endda GE sy-datum.
    IF sy-subrc EQ 0.
      wa_tam1-ename = pa0001-ename.
    ENDIF.
    wa_tam1-budat = wa_zdev1-budat.
    COLLECT wa_tam1 INTO it_tam1.
    CLEAR wa_tam1.
  ENDLOOP.

  CALL SCREEN 9009.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  STATUS_9009  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9009 OUTPUT.
  SET PF-STATUS 'STATUS'.
  SET TITLEBAR 'ATTACH'.
  PERFORM pbo.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9009  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9009 INPUT.
  CASE ok_code.

    WHEN 'BACK' OR 'EXIT'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'OTHERS'.
      LEAVE PROGRAM.
  ENDCASE.
  CLEAR : sy-ucomm.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  ACTIVATE_DMS_GOS  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE activate_dms_gos OUTPUT.

***  DATA: lv_del    TYPE c,
***        lv_ename  TYPE zemnam,
***        lv_btext  TYPE zbtext,
***        lv_stage  TYPE zstage,
***        lv_persno TYPE persno,
***        lv_werks  TYPE pa0001-werks,
***        lv_btrtl  TYPE pa0001-btrtl.
***
****----------------------> Commented by Karthik on 31.12.2019
***
****  IF R1 = ABAP_TRUE OR R1C = ABAP_TRUE OR R2 = ABAP_TRUE
****    OR R3 = ABAP_TRUE.
***
****---------------------> End of Comments
***
****  IF r1c = abap_true OR r2 = abap_true
****    OR r3 = abap_true.
***
***  lv_mblnr = zdev1-mblnr.
***
***  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
***    EXPORTING
***      input  = lv_mblnr
***    IMPORTING
***      output = lv_mblnr.
***
***  ls_borident-objkey = lv_mblnr.
***
****    CONCATENATE ls_borident-objkey '_' sy-datum+0(4)
***  CONCATENATE ls_borident-objkey '_' zdev1-mjahr "Commented & Added by Gokulan.03.01.2021
***  INTO ls_borident-objkey.
***
***  CONDENSE ls_borident-objkey.
***
***  FREE MEMORY ID 'ZDEL'.
***
***  FREE MEMORY ID: 'ZENAME',
***                  'ZBTEXT',
***                  'ZSTAGE',
***                  'ZPERSNO'.
***
***  lv_persno = pernr.
****    LV_BTEXT = DEPT.
****    LV_ENAME = ENAME.
***  IF lv_persno NE '00000000'.
***    CLEAR : lv_ename.
***    SELECT SINGLE ename werks btrtl INTO (lv_ename,lv_werks,lv_btrtl) FROM pa0001
***       WHERE pernr EQ lv_persno
***       AND begda <= sy-datum
***       AND endda >= sy-datum.
***    IF lv_werks IS NOT INITIAL AND
***       lv_btrtl IS NOT INITIAL.
***      CLEAR : lv_btext.
***      SELECT SINGLE btext INTO lv_btext FROM t001p
***        WHERE werks EQ lv_werks
***        AND btrtl EQ lv_btrtl.
***    ENDIF.
***  ENDIF.
***
****---------------> Commented by Karthik on 31.12.2019
***
****    IF R1 = ABAP_TRUE.
****      LV_STAGE = 'Create (Initiator)'.
****    ELSEIF R1C = ABAP_TRUE.
***
****---------------> End of Comments
***
****    IF r1c = abap_true.
***  lv_stage = 'Initiator'.
****    ELSEIF r2 = abap_true.
****      lv_stage = 'Department Heads Approval (Initiator)'.
****    ELSEIF r3 = abap_true.
****      lv_stage = 'Enter Impacted Activities'.
****    ENDIF.
***
***  EXPORT: lv_ename TO MEMORY ID 'ZENAME',
***          lv_btext TO MEMORY ID 'ZBTEXT',
***          lv_stage TO MEMORY ID 'ZSTAGE',
***          lv_persno TO MEMORY ID 'ZPERSNO'.
***
****    IF R3 = ABAP_TRUE. " Commented by Karthik on 31.12.2019
***
****    IF r1c = abap_true OR r2 = abap_true OR r3 = abap_true.
***  lv_del = abap_true.
***  EXPORT lv_del TO MEMORY ID 'ZDEL'. " To restrict Deletion option
****    ENDIF.
***
***  CREATE OBJECT lo_gos_manager
***    EXPORTING
***      is_object      = ls_borident
***      ip_no_commit   = ' '
***    EXCEPTIONS
***      object_invalid = 1.
***
****  ELSEIF r21 = abap_true OR r21a = abap_true. " For Reviewed by and Approved by
****
***  PERFORM activate_dms_gos_disp. " To activate DMS GOS for Display
****
****  ENDIF.


  DATA: lt_sel TYPE tgos_sels,
        ls_sel TYPE sgos_sels,
        lv_del TYPE c.

  CLEAR lt_sel.

  IF sy-uname EQ 'ITBOM01' AND r2 EQ 'X'.  "ENABLE DELETE OPTION  21.1.21

***      ls_sel-sign = 'I'.
***  ls_sel-option = 'EQ'.
***  ls_sel-low = 'VIEW_ATTA'.
***  ls_sel-high = 'VIEW_ATTA'.
***  APPEND ls_sel TO lt_sel.
***  CLEAR ls_sel.

    FREE MEMORY ID 'ZDEL'. " Commented by Karthik on 31.12.2019

*  if r13 <> abap_true.
*  lv_del = abap_true.
*  endif.

    EXPORT lv_del TO MEMORY ID 'ZDEL'. " To restrict Deletion option

    lv_mblnr = mblnr.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = lv_mblnr
      IMPORTING
        output = lv_mblnr.

    ls_borident-objkey = lv_mblnr.

*  CONCATENATE ls_borident-objkey '_' sy-datum+0(4)
    CONCATENATE ls_borident-objkey '_' zdev1-mjahr "Commented & Added by Gokulan.03.01.2021
    INTO ls_borident-objkey.

    CONDENSE ls_borident-objkey.
ls_borident-objtype = 'BUS2017'.  "Added by madhuri from ctpl given by jyostna on 31/10/2025
    CREATE OBJECT lo_gos_manager
      EXPORTING
        is_object            = ls_borident
        it_service_selection = lt_sel
        ip_no_commit         = ' '
      EXCEPTIONS
        object_invalid       = 1.

  ELSE.

    ls_sel-sign = 'I'.
    ls_sel-option = 'EQ'.
    ls_sel-low = 'VIEW_ATTA'.
    ls_sel-high = 'VIEW_ATTA'.
    APPEND ls_sel TO lt_sel.
    CLEAR ls_sel.

*  FREE MEMORY ID 'ZDEL'. " Commented by Karthik on 31.12.2019

*  if r13 <> abap_true.
    lv_del = abap_true.
*  endif.

    EXPORT lv_del TO MEMORY ID 'ZDEL'. " To restrict Deletion option

    lv_mblnr = mblnr.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = lv_mblnr
      IMPORTING
        output = lv_mblnr.

    ls_borident-objkey = lv_mblnr.

*  CONCATENATE ls_borident-objkey '_' sy-datum+0(4)
    CONCATENATE ls_borident-objkey '_' zdev1-mjahr "Commented & Added by Gokulan.03.01.2021
    INTO ls_borident-objkey.

    CONDENSE ls_borident-objkey.
ls_borident-objtype = 'BUS2017'.  "Added by madhuri from ctpl given by jyostna on 31/10/2025
    CREATE OBJECT lo_gos_manager
      EXPORTING
        is_object            = ls_borident
        it_service_selection = lt_sel
        ip_no_commit         = ' '
      EXCEPTIONS
        object_invalid       = 1.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  ACTIVATE_DMS_GOS_DISP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM activate_dms_gos_disp .
  DATA: lt_sel TYPE tgos_sels,
        ls_sel TYPE sgos_sels,
        lv_del TYPE c.

  CLEAR lt_sel.

  IF sy-uname EQ 'ITBOM01' .
*    AND r12 EQ 'X'.  "ENABLE DELETE OPTION  21.1.21

***      ls_sel-sign = 'I'.
***  ls_sel-option = 'EQ'.
***  ls_sel-low = 'VIEW_ATTA'.
***  ls_sel-high = 'VIEW_ATTA'.
***  APPEND ls_sel TO lt_sel.
***  CLEAR ls_sel.

    FREE MEMORY ID 'ZDEL'. " Commented by Karthik on 31.12.2019

*  if r13 <> abap_true.
*  lv_del = abap_true.
*  endif.

    EXPORT lv_del TO MEMORY ID 'ZDEL'. " To restrict Deletion option

    lv_mblnr = zdev1-mblnr.
*    ccnum.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = lv_mblnr
      IMPORTING
        output = lv_mblnr.

    ls_borident-objkey = lv_mblnr.

*  CONCATENATE ls_borident-objkey '_' sy-datum+0(4)
    CONCATENATE ls_borident-objkey '_' zdev1-mjahr "Commented & Added by Gokulan.03.01.2021
    INTO ls_borident-objkey.

    CONDENSE ls_borident-objkey.
ls_borident-objtype = 'BUS2017'.  "Added by madhuri from ctpl given by jyostna on 31/10/2025
    CREATE OBJECT lo_gos_manager
      EXPORTING
        is_object            = ls_borident
        it_service_selection = lt_sel
        ip_no_commit         = ' '
      EXCEPTIONS
        object_invalid       = 1.

  ELSE.

    ls_sel-sign = 'I'.
    ls_sel-option = 'EQ'.
    ls_sel-low = 'VIEW_ATTA'.
    ls_sel-high = 'VIEW_ATTA'.
    APPEND ls_sel TO lt_sel.
    CLEAR ls_sel.

*  FREE MEMORY ID 'ZDEL'. " Commented by Karthik on 31.12.2019

*  if r13 <> abap_true.
    lv_del = abap_true.
*  endif.

    EXPORT lv_del TO MEMORY ID 'ZDEL'. " To restrict Deletion option

    lv_mblnr = zdev1-mblnr.
*    ccnum.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = lv_mblnr
      IMPORTING
        output = lv_mblnr.

    ls_borident-objkey = lv_mblnr.

*  CONCATENATE ls_borident-objkey '_' sy-datum+0(4)
    CONCATENATE ls_borident-objkey '_' zdev1-mjahr "Commented & Added by Gokulan.03.01.2021
    INTO ls_borident-objkey.

    CONDENSE ls_borident-objkey.
ls_borident-objtype = 'BUS2017'.  "Added by madhuri from ctpl given by jyostna on 31/10/2025
    CREATE OBJECT lo_gos_manager
      EXPORTING
        is_object            = ls_borident
        it_service_selection = lt_sel
        ip_no_commit         = ' '
      EXCEPTIONS
        object_invalid       = 1.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PBO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM pbo .
  CREATE OBJECT gr_alvgrid
    EXPORTING
*     i_parent          = gr_ccontainer
      i_parent          = cl_gui_custom_container=>screen0
    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.
  IF sy-subrc <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  PERFORM alv_build_fieldcat.

  CALL METHOD gr_alvgrid->set_table_for_first_display
    EXPORTING
*     I_BUFFER_ACTIVE =
*     I_BYPASSING_BUFFER            =
*     I_CONSISTENCY_CHECK           =
*     I_STRUCTURE_NAME              =
      is_variant      = variant
      i_save          = 'A'
*     I_DEFAULT       = 'X'
      is_layout       = gs_layo
*     IS_PRINT        =
*     IT_SPECIAL_GROUPS             =
*     IT_TOOLBAR_EXCLUDING          =
*     IT_HYPERLINK    =
*     IT_ALV_GRAPHICS =
*     IT_EXCEPT_QINFO =
*     IR_SALV_ADAPTER =
    CHANGING
      it_outtab       = it_tam1
      it_fieldcatalog = it_fcat
*     IT_SORT         =
*     IT_FILTER       =
*      EXCEPTIONS
*     INVALID_PARAMETER_COMBINATION = 1
*     PROGRAM_ERROR   = 2
*     TOO_MANY_LINES  = 3
*     others          = 4
    .
  IF sy-subrc <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_build_fieldcat .
  DATA lv_fldcat TYPE lvc_s_fcat.




  lv_fldcat-fieldname = 'MJAHR'.
*  LV_FLDCAT-TABNAME   = 'IT_TAB1'.
  lv_fldcat-scrtext_m = 'Dev. Year'.
*  lv_fldcat-edit   = 'X'.
*  lv_fldcat-outputlen = 10.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'MBLNR'.
*  LV_FLDCAT-TABNAME   = 'IT_TAB1'.
  lv_fldcat-scrtext_m = 'Deviation No.'.
*  lv_fldcat-edit   = 'X'.
*  lv_fldcat-outputlen = 4.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'WERKS'.
  lv_fldcat-scrtext_m = 'Plant'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'ENAME'.
  lv_fldcat-scrtext_m = 'Deviation Raised By'.
  lv_fldcat-outputlen = 25.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'BTEXT'.
  lv_fldcat-scrtext_m = 'Department'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'BUDAT'.
  lv_fldcat-scrtext_m = 'Dev. Date'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FORM3
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM form3 .
  CLEAR : count.
  count = 1.
  DO 20 TIMES.
    wa_email1-mblnr = mblnr.
    wa_email1-mjahr = year.
    wa_email1-email = space.
    wa_email1-count = count.
    count = count + 1.
    COLLECT wa_email1 INTO it_email1.
    CLEAR wa_email1.
  ENDDO.

  CALL SCREEN 9002.



*  ENDDO.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  STATUS_9002  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9002 OUTPUT.
  SET PF-STATUS 'STATUS1'.
  SET TITLEBAR 'TITLE2'.
  PERFORM emaildev.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9002  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9002 INPUT.
  gr_alvgrid->check_changed_data( ).
  CASE ok_code.
*      BREAK-POINT.
    WHEN 'SAVE'.
      CLEAR : e.
      SORT it_email1 BY email.
      DELETE ADJACENT DUPLICATES FROM it_email1 COMPARING email.
      IF it_email1 IS NOT INITIAL.
        e = 1.
      ENDIF.

*      LOOP AT it_email1 INTO wa_email1.
*        IF wa_email1-email NE space.
      IF e EQ 1.
        PERFORM form1.
      ENDIF.

      IF e EQ 1.
        MESSAGE 'Email sent' TYPE 'I'.
      ENDIF.
*          e = 1.
*        ENDIF.
*        EXIT.
*      ENDLOOP.

      LEAVE TO SCREEN 0.

    WHEN 'BACK' OR 'EXIT'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'OTHERS'.
      LEAVE PROGRAM.
  ENDCASE.
  CLEAR : sy-ucomm.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  EMAILDEV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM emaildev .
  CREATE OBJECT gr_alvgrid
    EXPORTING
*     i_parent          = gr_ccontainer
      i_parent          = cl_gui_custom_container=>screen0
    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.
  IF sy-subrc <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  PERFORM alv_build_fieldcat1.

  CALL METHOD gr_alvgrid->set_table_for_first_display
    EXPORTING
*     I_BUFFER_ACTIVE =
*     I_BYPASSING_BUFFER            =
*     I_CONSISTENCY_CHECK           =
*     I_STRUCTURE_NAME              =
      is_variant      = variant
      i_save          = 'A'
*     I_DEFAULT       = 'X'
      is_layout       = gs_layo
*     IS_PRINT        =
*     IT_SPECIAL_GROUPS             =
*     IT_TOOLBAR_EXCLUDING          =
*     IT_HYPERLINK    =
*     IT_ALV_GRAPHICS =
*     IT_EXCEPT_QINFO =
*     IR_SALV_ADAPTER =
    CHANGING
      it_outtab       = it_email1
      it_fieldcatalog = it_fcat
*     IT_SORT         =
*     IT_FILTER       =
*      EXCEPTIONS
*     INVALID_PARAMETER_COMBINATION = 1
*     PROGRAM_ERROR   = 2
*     TOO_MANY_LINES  = 3
*     others          = 4
    .
  IF sy-subrc <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_BUILD_FIELDCAT1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_build_fieldcat1 .


  DATA lv_fldcat TYPE lvc_s_fcat.




  lv_fldcat-fieldname = 'MJAHR'.
*  LV_FLDCAT-TABNAME   = 'IT_TAB1'.
  lv_fldcat-scrtext_m = 'Dev. Year'.
*  lv_fldcat-edit   = 'X'.
*  lv_fldcat-outputlen = 10.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'MBLNR'.
*  LV_FLDCAT-TABNAME   = 'IT_TAB1'.
  lv_fldcat-scrtext_m = 'Deviation No.'.
*  lv_fldcat-edit   = 'X'.
*  lv_fldcat-outputlen = 4.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'EMAIL'.
  lv_fldcat-scrtext_m = 'Enter Email id'.
  lv_fldcat-edit   = 'X'.
  lv_fldcat-ref_table = 'ZPASSW_NAME'.
  lv_fldcat-ref_field = 'SMTP_ADDR'.
  lv_fldcat-outputlen = 70.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SEND_MAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IN_MAILID  text
*----------------------------------------------------------------------*
FORM send_mail  USING    p_in_mailid.
  DATA: salutation TYPE string.
  DATA: body TYPE string.
  DATA: footer TYPE string.

  DATA: lo_send_request TYPE REF TO cl_bcs,
        lo_document     TYPE REF TO cl_document_bcs,
        lo_sender       TYPE REF TO if_sender_bcs,
        lo_recipient    TYPE REF TO if_recipient_bcs VALUE IS INITIAL,lt_message_body TYPE bcsy_text,
        lx_document_bcs TYPE REF TO cx_document_bcs,
        lv_sent_to_all  TYPE os_boolean.

  "create send request
  lo_send_request = cl_bcs=>create_persistent( ).

  "create message body and subject
  salutation ='Dear Sir/Madam,'.
  APPEND salutation TO lt_message_body.
  APPEND INITIAL LINE TO lt_message_body.

  body = 'Please find the attached Deviation Form in PDF format.'.
  APPEND body TO lt_message_body.
  APPEND INITIAL LINE TO lt_message_body.
  IF r4 EQ 'X'.
    mblnr = wa_zdev41-mblnr.
    year = wa_zdev41-mjahr.
    mblnr1 = mblnr.
  ELSE.
    mblnr1 = mblnr.
  ENDIF.
  PACK mblnr1 TO mblnr1.
***  IF r4 NE 'X'.  "deactivated on 21.7.23 Jyotsna
***    CONCATENATE 'Deviation Notification No. ' mblnr1 ', Year ' year INTO txt1 SEPARATED BY space.
***    CONDENSE txt1.
****  BREAK-POINT.
***    body = txt1.
***    APPEND body TO lt_message_body.
***    APPEND INITIAL LINE TO lt_message_body.
***  ENDIF.
*********************************************************************************************
  CLEAR : subject.
  SELECT SINGLE * FROM zdev3 WHERE mjahr EQ year AND mblnr EQ mblnr.
  IF sy-subrc EQ 0.
    CONCATENATE zdev3-sub1 zdev3-sub2  zdev3-sub3 INTO subject SEPARATED BY space.
  ENDIF.
  IF subject IS INITIAL.
    subject = 'DEVIATION'.
  ENDIF.
  CONDENSE subject.
*  BREAK-POINT.
  body = subject.
  APPEND body TO lt_message_body.
  APPEND INITIAL LINE TO lt_message_body.
*************************************************************

  footer = 'With Regards,'.
  APPEND footer TO lt_message_body.
  footer = 'BLUE CROSS LABORATORIES PVT LTD.'.
  APPEND footer TO lt_message_body.
  "put your text into the document
  lo_document = cl_document_bcs=>create_document(
  i_type = 'RAW'
  i_text = lt_message_body
  i_subject = 'Deviation' ).

*DATA: l_size TYPE sood-objlen. " Size of Attachment
*l_size = l_lines * 255.
  TRY.
      lo_document->add_attachment(
      EXPORTING
      i_attachment_type = 'PDF'
      i_attachment_subject = 'Deviation'
      i_att_content_hex = i_objbin[] ).
    CATCH cx_document_bcs INTO lx_document_bcs.
  ENDTRY.

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
  EXPORTING
  i_recipient = lo_recipient
  i_express = abap_true
  ).

  lo_send_request->add_recipient( lo_recipient ).

* Send email
  lo_send_request->send(
  EXPORTING
  i_with_error_screen = abap_true
  RECEIVING
  result = lv_sent_to_all ).

  CONCATENATE 'Email sent to' in_mailid INTO DATA(lv_msg) SEPARATED BY space.
  WRITE:/ lv_msg COLOR COL_POSITIVE.
  SKIP.
* Commit Work to send the email
  COMMIT WORK.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  APPDEPT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM appdept .
*BREAK-POINT.
  CLEAR : it_dept1,wa_dept1.
  SELECT SINGLE * FROM zdev4 WHERE mjahr EQ year AND mblnr EQ mblnr AND tdapr NE space.
  IF sy-subrc EQ 4.
    MESSAGE 'THIS DEVIATION IS NOT YET AUTHORIZED' TYPE 'E'.
  ENDIF.
  CLEAR : it_zdev5,wa_zdev5.
  SELECT * FROM zdev5 INTO TABLE it_zdev5 WHERE mjahr EQ year AND mblnr EQ mblnr.
  IF it_zdev5 IS NOT INITIAL.
    LOOP AT it_zdev5 INTO wa_zdev5.
      wa_dept1-btrtl = wa_zdev5-btrtl.
      COLLECT wa_dept1 INTO it_dept1.
      CLEAR wa_dept1.
    ENDLOOP.
  ENDIF.
  CLEAR : it_zdev9,wa_zdev9.
  SELECT * FROM zdev9 INTO TABLE it_zdev9 WHERE mjahr EQ year AND mblnr EQ mblnr.
  IF it_zdev9 IS NOT INITIAL.
    LOOP AT it_zdev9 INTO wa_zdev9.
      wa_dept1-btrtl = wa_zdev9-btrtl.
      COLLECT wa_dept1 INTO it_dept1.
      CLEAR wa_dept1.
    ENDLOOP.
  ENDIF.

  CLEAR : ewerks.
  SELECT SINGLE * FROM zdev1 WHERE mjahr EQ year AND mblnr EQ mblnr.
  IF sy-subrc EQ 0.
    wa_dept1-btrtl = zdev1-ibtrtl.
    ewerks = zdev1-werks.
  ENDIF.
  IF ewerks EQ '1000'.
    wa_dept1-btrtl = '1228'.
    COLLECT wa_dept1 INTO it_dept1.
    CLEAR wa_dept1.
  ELSEIF ewerks = '1001'.
    wa_dept1-btrtl = '1328'.
    COLLECT wa_dept1 INTO it_dept1.
    CLEAR wa_dept1.
  ELSE.
    wa_dept1-btrtl = '1232'.
    COLLECT wa_dept1 INTO it_dept1.
    CLEAR wa_dept1.
  ENDIF.
  SORT it_dept1 BY btrtl.
  DELETE ADJACENT DUPLICATES FROM it_dept1 COMPARING btrtl.

  CLEAR : it_email1,wa_email1.
  LOOP AT it_dept1 INTO wa_dept1.
    SELECT SINGLE * FROM zqms_depthead1 WHERE btrtl EQ wa_dept1-btrtl AND TO_DT GE SY-DATUM..
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM zpassw WHERE pernr EQ zqms_depthead1-pernr.
      IF sy-subrc EQ 0.
        wa_email1-mblnr = mblnr.
        wa_email1-mjahr = year.
        wa_email1-email = zpassw-smtp_addr.
*          wa_email1-count = count.
        COLLECT wa_email1 INTO it_email1.
        CLEAR wa_email1.
      ENDIF.
    ENDIF.
  ENDLOOP.

  IF ewerks EQ '1000'.
    SELECT SINGLE * FROM zpassw WHERE pernr EQ '00010860'.
    IF sy-subrc EQ 0.
      wa_email1-mblnr = mblnr.
      wa_email1-mjahr = year.
      wa_email1-email = zpassw-smtp_addr.
*          wa_email1-count = count.
      COLLECT wa_email1 INTO it_email1.
      CLEAR wa_email1.
    ENDIF.
  ELSEIF ewerks EQ '1001'.
    SELECT SINGLE * FROM zpassw WHERE pernr EQ '00013907'.
    IF sy-subrc EQ 0.
      wa_email1-mblnr = mblnr.
      wa_email1-mjahr = year.
      wa_email1-email = zpassw-smtp_addr.
*          wa_email1-count = count.
      COLLECT wa_email1 INTO it_email1.
      CLEAR wa_email1.
    ENDIF.
    SELECT SINGLE * FROM zpassw WHERE pernr EQ '00012420'.
    IF sy-subrc EQ 0.
      wa_email1-mblnr = mblnr.
      wa_email1-mjahr = year.
      wa_email1-email = zpassw-smtp_addr.
      COLLECT wa_email1 INTO it_email1.
      CLEAR wa_email1.
    ENDIF.
    SELECT SINGLE * FROM zpassw WHERE pernr EQ '00016122'.
    IF sy-subrc EQ 0.
      wa_email1-mblnr = mblnr.
      wa_email1-mjahr = year.
      wa_email1-email = zpassw-smtp_addr.
      COLLECT wa_email1 INTO it_email1.
      CLEAR wa_email1.
    ENDIF.
  ENDIF.

  SELECT SINGLE * FROM zdev2 WHERE mblnr EQ mblnr AND mjahr EQ year AND rdepth GT 0.
  IF sy-subrc EQ 0.
    SELECT SINGLE * FROM zpassw WHERE pernr EQ zdev2-rdepth.
    IF sy-subrc EQ 0.
      wa_email1-mblnr = mblnr.
      wa_email1-mjahr = year.
      wa_email1-email = zpassw-smtp_addr.
      COLLECT wa_email1 INTO it_email1.
      CLEAR wa_email1.
    ENDIF.
  ENDIF.

  SELECT SINGLE * FROM zdev2 WHERE mblnr EQ mblnr AND mjahr EQ year AND adepth GT 0.
  IF sy-subrc EQ 0.
    SELECT SINGLE * FROM zpassw WHERE pernr EQ zdev2-adepth.
    IF sy-subrc EQ 0.
      wa_email1-mblnr = mblnr.
      wa_email1-mjahr = year.
      wa_email1-email = zpassw-smtp_addr.
      COLLECT wa_email1 INTO it_email1.
      CLEAR wa_email1.
    ENDIF.
  ENDIF.
*BREAK-POINT.
  DELETE it_email1 WHERE email EQ space.
*CLEAR : count.
*  count = 1.
*  DO 20 TIMES.
*    wa_email1-mblnr = mblnr.
*    wa_email1-mjahr = year.
*    wa_email1-email = space.
*    wa_email1-count = count.
*    count = count + 1.
*    COLLECT wa_email1 INTO it_email1.
*    CLEAR wa_email1.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  AUTOEMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM autoemail.


  CLEAR: ydate.
  ydate = sy-datum - 1.

  SELECT * FROM zdev4 INTO TABLE it_zdev41 WHERE tddate EQ ydate AND tdapr EQ 'X'.
  IF it_zdev41 IS NOT INITIAL.
    LOOP AT it_zdev41 INTO wa_zdev41.
******************************************************
******************************************

      CLEAR : year,mblnr.
      year = wa_zdev41-mjahr.
      mblnr = wa_zdev41-mblnr.
*********************************
      CLEAR : it_zdev1,wa_zdev1,werks.
      SELECT SINGLE * FROM zdev1 WHERE mblnr EQ mblnr AND mjahr EQ year.
      IF sy-subrc EQ 0.
        werks = zdev1-werks.
      ENDIF.
      CLEAR : format1,capasop.
      IF werks EQ '1000'.
        format1 = 'SOP/QAD/045-09-F1 (Ref. SOP No.: SOP/QAD/045)'.
        capasop = 'SOP/QAD/094'.
      ELSEIF werks EQ '1001'.
        format1 = 'QA/GM/035-11-F1 (Ref. SOP No.: QA/GM/035)'.
        capasop = 'QA/GM/028'.
      ELSEIF werks EQ '3000'.
        capasop = 'SOP/CQD/040'.
      ENDIF.

*      PERFORM AUTH.

      SELECT * FROM zdev1 INTO TABLE it_zdev1 WHERE mblnr EQ mblnr AND mjahr EQ year AND werks EQ werks.
      IF sy-subrc EQ 4.
        MESSAGE 'no data' TYPE 'E'.
      ENDIF.
********************************************************
      PERFORM appdept.
      PERFORM form1.
    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PASS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM pass .
*  SELECT SINGLE * FROM zpassw WHERE pernr = pernr.
*  IF sy-subrc EQ 0.
*
*    IF sy-uname NE zpassw-uname.
*      MESSAGE 'INVALID LOGIN ID' TYPE 'E'.
*    ENDIF.
*    v_en_string = zpassw-password.
**&———————————————————————** Decryption – String to String*&———————————————————————*
*    TRY.
*        CREATE OBJECT o_encryptor.
*        CALL METHOD o_encryptor->decrypt_string2string
*          EXPORTING
*            the_string = v_en_string
*          RECEIVING
*            result     = v_de_string.
*      CATCH cx_encrypt_error INTO o_cx_encrypt_error.
*        CALL METHOD o_cx_encrypt_error->if_message~get_text
*          RECEIVING
*            result = v_error_msg.
*        MESSAGE v_error_msg TYPE 'E'.
*    ENDTRY.
*    IF v_de_string EQ pass.
**      message 'CORRECT PASSWORD' type 'I'.
*    ELSE.
*      MESSAGE 'INCORRECT PASSWORD' TYPE 'E'.
*    ENDIF.
*  ELSE.
*    MESSAGE 'NOT VALID USER' TYPE 'E'.
*    EXIT.
*  ENDIF.
*  CLEAR : pass.
*  pass = '   '.
ENDFORM.
