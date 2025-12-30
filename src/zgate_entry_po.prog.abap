*&---------------------------------------------------------------------*
*& Report  ZGATE_ENTRY
*& report developed by Jyotsna.
*&---------------------------------------------------------------------*
*&database table: ZPO_GATE
*&GRN CAN NOT BE DONE FOR THE PO IF NO CONFIMATION GATE ENTRY EXISIT IN SYSTEM.
** GATE ENTRY SHALL BE MAINTAINED IN GRN HEADER DATA- 20.4.25- JYOTSNA
*&---------------------------------------------------------------------*
report zgate_entry_po_a1.
tables : ekpo,
         ekko,
         lfa1,
         adrc,
         mkpf,
         zpo_gate,
         usr05,
         zpassw,
         pa0001,
         zqms_depthead1,
         t001w.

type-pools:  slis.

data: g_repid     like sy-repid,
      fieldcat    type slis_t_fieldcat_alv,
      wa_fieldcat like line of fieldcat,
      sort        type slis_t_sortinfo_alv,
      wa_sort     like line of sort,
      layout      type slis_layout_alv,
      l_glay      type lvc_s_glay.

data: it_ekpo type table of ekpo,
      wa_ekpo type ekpo,
      it_mseg type table of mseg,
      wa_mseg type mseg,
      it_ekko type table of ekko,
      wa_ekko type ekko,
      it_ekbe type table of ekbe,
      wa_ekbe type ekbe.
types: begin of itab1,
         ebeln       type ekpo-ebeln,
         ebelp       type ekpo-ebelp,
         matnr       type ekpo-matnr,
         txz01       type ekpo-txz01,
         chk(1)      type c,
         xblnr       type string,
         bldat       type bkpf-bldat,
         vehno(10)   type c,
         transporter type string,
         remark      type string,
       end of itab1.

types: begin of disp1,
         stry(1)       type c,
         strn(1)       type c,
         strtxt(100)   type c,
         vbeln         type zpo_gate-vbeln,
         mjahr         type zpo_gate-mjahr,
         werks         type zpo_gate-werks,
         num           type zpo_gate-num,
         ebeln         type ekpo-ebeln,
         cpudt         type sy-datum,
         cputm         type sy-uzeit,
         usnam         type sy-uname,
         aedat         type ekko-aedat,
         name1         type adrc-name1,
         ort01         type lfa1-ort01,
         strstatus(10) type  c,
         sname         type pa0001-ename,
         scpudt        type sy-datum,
         scputm        type sy-uzeit,
         gin(1)        type c,
         gout(1)       type c,
         gstatus(20)   type c,
         gcpudt        type sy-datum,
         gcputm        type sy-uzeit,
         gocpudt       type sy-datum,
         gocputm       type sy-uzeit,
         apr(1)        type c,
         rejname       type pa0001-ename,
         rejcpudt      type sy-datum,
         rejcputm      type sy-uzeit,
         xblnr         type string,
         bldat         type bkpf-bldat,
         vehno(10)     type c,
         transporter   type string,
         remark        type string,
         deldt         type sy-datum,
         deltxt        type zpo_gate-deltxt,
         delename      type pa0001-ename,
         mblnr         type mkpf-mblnr,
         budat         type mkpf-budat,
       end of disp1.



types: begin of disp2,
         ebeln      type ekpo-ebeln,
         cpudt      type sy-datum,
         cputm      type sy-uzeit,
         usnam      type sy-uname,
         aedat      type ekko-aedat,
         name1      type adrc-name1,
         ort01      type lfa1-ort01,

         ebelp      type mseg-ebelp,
         mblnr      type mseg-mblnr,
         bwart      type mseg-bwart,
         matnr      type mseg-matnr,
         menge      type mseg-menge,
         grnmenge   type mseg-menge,
         budat      type mkpf-budat,
         xblnr      type mkpf-xblnr,
         bldat      type mkpf-bldat,
         txz01      type ekpo-txz01,
         gateno(10) type c,
         gateyr(10) type c,

         gatecpudt  type zpo_gate-cpudt,
         gatecputm  type zpo_gate-cputm,
         gateuname  type zpo_gate-usnam,

       end of disp2.
types: begin of gat1,
         ebeln type ekbe-ebeln,
         ebelp type ekbe-ebelp,
         mblnr type mkpf-mblnr,
         mjahr type mkpf-mjahr,
         bktxt type mkpf-bktxt,
         budat type mkpf-budat,
       end of gat1.
data: it_tab1  type table of itab1,
      wa_tab1  type itab1,
      it_disp1 type table of disp1,
      wa_disp1 type disp1,
      it_disp2 type table of disp2,
      wa_disp2 type disp2,
      it_gat1  type table of gat1,
      wa_gat1  type gat1.
data: name1 type lfa1-name1,
      aedat type ekko-aedat,
      ort01 type lfa1-ort01.
data: text1(60) type c,
      text2(60) type c.
data: e1     type i,
      a1     type i,
      rej1   type i,
      rejem1 type i,
      accem1 type i.
data: count1          type i,
      xblnr           type bkpf-xblnr,
      bldat           type bkpf-bldat,
      vehno(10)       type c,
      transporter(40) type c,
      remark(100)     type c,
      err1            type i.

data: allw1 type i.
data: it_zpo_gate type table of zpo_gate,
      wa_zpo_gate type zpo_gate.
*DATA: BUZEI TYPE ZPO_GATE-BUZEI.
data: zpo_gate_wa type zpo_gate.
data: plant1 type ekpo-werks.
data: msg type string.
data: it_t001w type table of t001w,
      wa_t001w type t001w.
data: mjahr type mseg-mjahr.
data: yr(2) type c.
data: num1(10) type n.
data: num2(10) type c.
data: num3(5) type n.
data: num4(16) type c.
data: plant type ekpo-werks.
data: o_encryptor        type ref to cl_hard_wired_encryptor,
      o_cx_encrypt_error type ref to cx_encrypt_error.
data:
*      v_ac_xstring type xstring,
  v_en_string type string,
*      v_en_xstring type xstring,
  v_de_string type string,
*      v_de_xstring type string,
  v_error_msg type string.
**************************************************

data: subject(310) type c.
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
data: ename type pa0001-ename.
data : w_objtxt(310) type c.
data : w_objtxt1(110) type c.
data: v_msg(125) type c.
data : wa_d1(10) type c.
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
types : begin of email,
          pernr      type pa0001-pernr,
          usrid_long type pa0105-usrid_long,
        end of email.
data : it_email  type table of email,
       wa_email  type email,
       it_pa0001 type table of pa0001,
       wa_pa0001 type pa0001.
data: del1 type i.
************************************************************************************

selection-screen begin of block merkmale1 with frame title text-001.
parameters : pernr    like pa0001-pernr matchcode object prem,
             pass(10) type c.
selection-screen end of block merkmale1.

selection-screen begin of block merkmale2 with frame title text-001.
parameters : po like ekpo-ebeln.
select-options : budat for sy-datum.

select-options: ord for ekpo-ebeln,
                vendor for lfa1-lifnr.
parameters : gentry like zpo_gate-num.
parameters : deltxt like zpo_gate-deltxt.
parameters : werks like ekpo-werks.
selection-screen end of block merkmale2.
selection-screen begin of block merkmale3 with frame title text-001.
parameters : r1  radiobutton group r1 user-command r2 default 'X',
             r2  radiobutton group r1,
             r3  radiobutton group r1,
             r3o radiobutton group r1,
             rr  radiobutton group r1,
             r4  radiobutton group r1,
             r5  radiobutton group r1,
             r6  radiobutton group r1.
selection-screen end of block merkmale3.

at selection-screen output.
  if r1 eq 'X'.
    loop at screen.
      if screen-name cp '*PO*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*WERKS*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*BUDAT*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*PERNR*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*PASS*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*ORD*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*VENDOR*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*GENTRY*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*DELTXT*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.

  elseif r2 eq 'X' or rr eq 'X'.
    loop at screen.
      if screen-name cp '*PERNR*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*PASS*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*PO*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*WERKS*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*BUDAT*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*ORD*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*VENDOR*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*GENTRY*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*DELTXT*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.

  elseif r3 eq 'X' or r3o eq 'X'.
    loop at screen.
      if screen-name cp '*PERNR*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*PASS*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*PO*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*WERKS*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*BUDAT*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*ORD*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*VENDOR*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*GENTRY*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*DELTXT*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.

  elseif r4 eq 'X' or r6 eq 'X'.
    loop at screen.
      if screen-name cp '*PERNR*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*PASS*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*PO*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*WERKS*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*BUDAT*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*ORD*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*VENDOR*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*GENTRY*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*DELTXT*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
  elseif r5 eq 'X'.


    loop at screen.
      if screen-name cp '*PO*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*WERKS*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*BUDAT*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*PERNR*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*PASS*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*ORD*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*VENDOR*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*GENTRY*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*DELTXT*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.


  endif.

  loop at screen.
    check screen-name eq 'PASS'.
    screen-invisible = 1.
    modify screen.
  endloop.

  select single * from usr05 where bname = sy-uname and parid eq 'ZPLANT'.
  if sy-subrc eq 0.
    werks = usr05-parva.
  endif.

initialization.
  g_repid = sy-repid.

start-of-selection.
  select single * from ekpo where ebeln eq po.
  if sy-subrc eq 0.
    plant1 = ekpo-werks.
  endif.
  if r1 eq 'X'.
    perform auth.
    perform porel.  "ALLOW GATE ENTRY IF PO IS RELEASED.
    perform chkgate. "'ACTIVATE'
    perform form1.
  elseif r2 eq 'X'.  "STORE
    if sy-uname eq 'MMINVNSK02' or sy-uname eq 'BCLLDEVP1'.
    else.
      perform passw.
    endif.
    perform auth1.
    perform deptchk. "ACTIVATE
    perform form2.
  elseif r3 eq 'X'. "Gate Confirmation
    perform auth1.
    perform chkgate.  "ACTIVATE
    perform form3.
  elseif r3o eq 'X'. "Gate Confirmation
    perform auth1.
    perform chkgate. "ACTIVATE
    perform form3o.
  elseif rr eq 'X'.  "REJECTION
    perform auth1.
    perform deptchk. "ACTIVATE
    perform rejform.
  elseif r4 eq 'X' or r6 eq 'X'.
    perform auth1.
    perform form4.
  elseif r5 eq 'X'.
    perform passw.
    perform deptchk1.
    perform delflag.

*    PERFORM GRNDISP.
  endif.

*&---------------------------------------------------------------------*
*&      Form  EDIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form edit .
  clear : count1.
  count1 = 1.
  loop at it_tab1 into wa_tab1.
    if count1 ge 2.
      message 'ENTER BILL/CHALL NO, DATE, TRANSPOTER & REMARK IN FIST ROW ONLY' type 'E'.
    endif.
  endloop.
  clear : xblnr,bldat,vehno,transporter,remark,err1.
  read table it_tab1 into wa_tab1 with key ebeln = po.
  if sy-subrc eq 0.
    xblnr = wa_tab1-xblnr.
    bldat = wa_tab1-bldat.
    vehno = wa_tab1-vehno.
    transporter = wa_tab1-transporter.
    remark = wa_tab1-remark.
  endif.

  translate xblnr to upper case.
  translate vehno to upper case.
  condense: xblnr no-gaps, vehno no-gaps.


  if xblnr is initial.
    err1 = 1.
    message 'ENTER BILL / CHALLAN NUMBER' type 'E'.
  endif.

  select single * from zpo_gate where ebeln eq po and xblnr eq xblnr.
  if sy-subrc eq 0.
    if zpo_gate-xblnr is not initial.
      message 'This PO & BILL/CHALLAN No. alredy exisit in system' type 'E'.
    endif.
  endif.

*  BREAK-POINT.
  mjahr = sy-datum+0(4).
  yr = sy-datum+2(2).

*  IF SY-DATUM+4(2) GE '04'.
*    GJAHR = SY-DATUM+0(4).
*  ELSE.
*    GJAHR = SY-DATUM+0(4) - 1.
*  ENDIF.
  clear : plant,num1,num2,num3,num4.
*  BREAK-POINT .

  select single * from ekpo where ebeln eq po and werks eq werks.
  if sy-subrc eq 0.
    plant = ekpo-werks.
  endif.

  select * from zpo_gate into table it_zpo_gate where mjahr eq mjahr and werks eq plant.
  sort it_zpo_gate descending by vbeln.
  read table it_zpo_gate into wa_zpo_gate with key mjahr = mjahr werks = plant.
  if sy-subrc eq 0.
    num1 = wa_zpo_gate-vbeln.
  endif.
  num1 = num1 + 1.
*  IF NUM1 IS INITIAL.
*    IF PLANT EQ '1000'.
*      NUM1 = 10000.
*    ELSEIF PLANT EQ '1001'.
*      NUM1 = 20000.
*    ENDIF.
*  ENDIF.
*
*  NUM1 = NUM1 + 1.
  num2 = num1.
  pack num2 to num2.
  condense num2.
  num3 = num2.

  if plant1 eq '1000'.
    concatenate 'NSK/PO/' yr '/' num3 into num4.
  elseif plant1 eq '1001' or plant1 eq '2024'.
    concatenate 'GOA/PO/' yr '/' num3 into num4.
*     else.

  endif.
  condense num4.

**************************************
  if err1 ne 1.
    zpo_gate_wa-vbeln = num1.
    zpo_gate_wa-mjahr = mjahr.
    zpo_gate_wa-werks = plant.
    zpo_gate_wa-num = num4.
    zpo_gate_wa-ebeln = po.
    zpo_gate_wa-xblnr = xblnr.
    zpo_gate_wa-bldat = bldat.
    zpo_gate_wa-vehno = vehno.
    zpo_gate_wa-transporter = transporter.
    zpo_gate_wa-remark = remark.
    zpo_gate_wa-cpudt = sy-datum.
    zpo_gate_wa-cputm = sy-uzeit.
    zpo_gate_wa-usnam = sy-uname.

    modify zpo_gate from zpo_gate_wa .
    clear zpo_gate_wa.
    if sy-subrc eq 0.
      message i970(zhr_message) with num4.
*  MESSAGE 'GATE ENTRY & IS GENERATED' TYPE 'I'.
      perform email.
    endif.
  endif.
  leave to screen 0.
endform.

form top.

  data: comment    type slis_t_listheader,
        wa_comment like line of comment.
  if r1 eq 'X'.
*  BREAK-POINT .
    concatenate 'VENDOR: ' name1 ',' ort01 into text1 separated by space.
    condense text1.
    wa_comment-typ = 'A'.
    wa_comment-info = text1.
*  WA_COMMENT-INFO = P_FRMDT.
    append wa_comment to comment.
    clear wa_comment.
    concatenate 'PO DATE : ' aedat+6(2) '.' aedat+4(2) '.' aedat+0(4) into text2.
    wa_comment-typ = 'A'.
    wa_comment-info = text2.
*  WA_COMMENT-INFO+9(10) = AEDAT.
    append wa_comment to comment.
    clear wa_comment.

    concatenate 'PO DATE : ' aedat+6(2) '.' aedat+4(2) '.' aedat+0(4) into text2.
    wa_comment-typ = 'A'.
    wa_comment-info = 'Enter BILL/CHALLAN No. & other details in first line only'.
*  WA_COMMENT-INFO+9(10) = AEDAT.
    append wa_comment to comment.
    clear wa_comment.
  elseif r2 eq 'X' .
    wa_comment-typ = 'A'.
    wa_comment-info = 'STORE APPROVAL FOR SENDING VEHICLE'.
*  WA_COMMENT-INFO+9(10) = AEDAT.
    append wa_comment to comment.
    clear wa_comment.
  elseif r3 eq 'X'.
    wa_comment-typ = 'A'.
    wa_comment-info = 'CONFIRMATION FROM GATE TO SEND VEHICLE AFTER STORE APPROVAL'.
*  WA_COMMENT-INFO+9(10) = AEDAT.
    append wa_comment to comment.
    clear wa_comment.
  elseif r4 eq 'X'.
    wa_comment-typ = 'A'.
    wa_comment-info = 'GATE ENTRY DATA'.
*  WA_COMMENT-INFO+9(10) = AEDAT.
    append wa_comment to comment.
    clear wa_comment.

  elseif rr eq 'X'.
    wa_comment-typ = 'A'.
    wa_comment-info = 'APPROVAL TO RETURN VEHICLE'.
*  WA_COMMENT-INFO+9(10) = AEDAT.
    append wa_comment to comment.
    clear wa_comment.

  elseif r5 eq 'X' or r6 eq 'X'.
    wa_comment-typ = 'A'.
    wa_comment-info = 'DELETED GATE ENTRY DATA'.
*  WA_COMMENT-INFO+9(10) = AEDAT.
    append wa_comment to comment.
    clear wa_comment.

  endif.
  call function 'REUSE_ALV_COMMENTARY_WRITE'
    exporting
      it_list_commentary = comment.
*     I_LOGO                   = 'ENJOYSAP_LOGO'
*     I_END_OF_LIST_GRID       =
*     I_ALV_FORM               =
  clear comment.


endform.                    "TOP
*&---------------------------------------------------------------------*
*&      Form  FORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form form1 .
*  BREAK-POINT.
  select single * from ekko where ebeln eq po.
  if sy-subrc eq 0.
    aedat = ekko-aedat.
    select single * from lfa1 where lifnr eq ekko-lifnr.
    if sy-subrc eq 0.
      name1 = lfa1-name1.
      ort01 = lfa1-ort01.
    endif.
  endif.

  select * from ekpo into table it_ekpo where ebeln eq po and elikz eq space and werks eq werks.
  if it_ekpo is initial.
    message 'NO OPEN ITEM FOR THIS PO' type 'I'.
    leave to screen 0.
  endif.
*  BREAK-POINT .
  loop at it_ekpo into wa_ekpo.
    wa_tab1-ebeln = wa_ekpo-ebeln.
    wa_tab1-ebelp = wa_ekpo-ebelp.
    wa_tab1-matnr = wa_ekpo-matnr.
    wa_tab1-txz01 = wa_ekpo-txz01.
    collect wa_tab1 into it_tab1.
    clear wa_tab1.
  endloop.

*  LOOP AT IT_TAB1 INTO WA_TAB1.
*    WRITE : / WA_TAB1-EBELN,WA_TAB1-EBELP,WA_TAB1-MATNR,WA_TAB1-TXZ01.
*  ENDLOOP.

  wa_fieldcat-fieldname = 'EBELN'.
  wa_fieldcat-seltext_l = 'PO NO.'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'EBELP'.
  wa_fieldcat-seltext_l = 'PO ITEM NO.'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_l = 'PO ITEM CODE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.
*
  wa_fieldcat-fieldname = 'TXZ01'.
  wa_fieldcat-seltext_l = 'PO ITEM DESCRIPTION'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'XBLNR'.
  wa_fieldcat-seltext_l = 'BILL/CHALLAN NO.'.
  wa_fieldcat-edit = 'X'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'BLDAT'.
  wa_fieldcat-seltext_l = 'BILL/CHALLAN DATE'.
  wa_fieldcat-edit = 'X'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'VEHNO'.
  wa_fieldcat-seltext_l = 'VEHICLE NO.'.
  wa_fieldcat-edit = 'X'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'TRANSPORTER'.
  wa_fieldcat-seltext_l = 'TRANSPORTER NAME'.
  wa_fieldcat-edit = 'X'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'REMARK'.
  wa_fieldcat-seltext_l = 'ENTER REMARK IF ANY'.
  wa_fieldcat-edit = 'X'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.


*  append wa_fieldcat to fieldcat.

  l_glay-edt_cll_cb = 'X'.

*  ls_layout-colwidth_optimize = 'X'.


  wa_fieldcat-fieldname = 'CHK'.
  wa_fieldcat-seltext_l = 'S'.
*  WA_FIELDCAT-CHECKBOX = 'X'.
  wa_fieldcat-edit = 'X'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.



  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'PURCHASE ORDER DETAILS'.


  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = g_repid
*     I_CALLBACK_PF_STATUS_SET          = 'STATUS'
      i_callback_user_command = 'USER_COMM'
      i_callback_top_of_page  = 'TOP'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         = L_GLAY
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
  clear : fieldcat,layout.

endform.

form user_comm using ucomm like sy-ucomm selfield type slis_selfield.
*  IF R1 EQ 'X'.
  case sy-ucomm. "SELFIELD-FIELDNAME.
*      loop at it_tab5 into wa_tab5 WHERE nsampqty ne 0 AND chk ne 'X'.
*        MESSAGE 'TICK THE CHECKBOX TO SAVE DATA' TYPE 'E'.
*      ENDLOOP.
*      BREAK-POINT.
    when '&DATA_SAVE'(001).
*      message 'TERRITORY SAVED 1' type 'I'.
*      PERFORM BDC.
      if r1 eq 'X'.
        perform edit.
      elseif r2 eq 'X'.
        perform stockdata.
      elseif rr eq 'X'.
        perform rejapproval.
      elseif r3 eq 'X'.  "GATE CONFIRMATION
        perform gateconf.
      elseif r3o eq 'X'.  "GATE CONFIRMATION
        perform gateconfo.
      endif.
    when others.
  endcase.
  exit.
endform.                    "USER_COMM


*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FORM2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form form2 .
*  BREAK-POINT .
  select * from zpo_gate into table it_zpo_gate where werks eq werks and cpudt in budat and stry eq space and del eq space.
*    SPERNR LE 0.
  if sy-subrc eq 0.
    select * from ekpo into table it_ekpo for all entries in it_zpo_gate where ebeln eq it_zpo_gate-ebeln and werks eq werks and ebeln in ord.
    if sy-subrc eq 0.
      select * from ekko into table it_ekko for all entries in it_ekpo where ebeln eq it_ekpo-ebeln and lifnr in vendor.
    endif.
  endif.
  if it_ekpo is initial.
    message 'NO DATA FOUND' type 'I'.
    leave to screen 0.
  endif.

  loop at it_zpo_gate into wa_zpo_gate.
    if wa_zpo_gate-strn eq 'X' and wa_zpo_gate-rejcpudt gt 0.
    else.
      read table it_ekko into wa_ekko with key ebeln = wa_zpo_gate-ebeln.
      if sy-subrc eq 0.
        read table it_ekpo into wa_ekpo with key ebeln = wa_zpo_gate-ebeln.
        if sy-subrc eq 0.
          wa_disp1-vbeln = wa_zpo_gate-vbeln.
          wa_disp1-mjahr = wa_zpo_gate-mjahr.
          wa_disp1-werks = wa_zpo_gate-werks.
          wa_disp1-num = wa_zpo_gate-num.
          wa_disp1-ebeln = wa_zpo_gate-ebeln.
          wa_disp1-aedat = wa_ekko-aedat.
          select single * from lfa1 where lifnr eq wa_ekko-lifnr.
          if sy-subrc eq 0.
            select single * from adrc where addrnumber eq lfa1-adrnr.
            if sy-subrc eq 0.
              wa_disp1-name1 = adrc-name1.
            endif.
            wa_disp1-ort01 = lfa1-ort01.
          endif.
          if wa_zpo_gate-strn eq 'X'.
            wa_disp1-strn = 'X'.
            wa_disp1-strtxt = wa_zpo_gate-strtxt.
          endif.
          wa_disp1-xblnr = wa_zpo_gate-xblnr.
          wa_disp1-bldat = wa_zpo_gate-bldat.
          wa_disp1-vehno = wa_zpo_gate-vehno.
          wa_disp1-transporter = wa_zpo_gate-transporter.
          wa_disp1-remark = wa_zpo_gate-remark.

          wa_disp1-cpudt = wa_zpo_gate-cpudt.
          wa_disp1-cputm = wa_zpo_gate-cputm.
          wa_disp1-usnam = wa_zpo_gate-usnam.

          collect wa_disp1 into it_disp1.
          clear wa_disp1.
        endif.
      endif.
    endif.
  endloop.

*  *  WA_FIELDCAT-FIELDNAME = 'WERKS'.
*  WA_FIELDCAT-SELTEXT_L = 'PLANT'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.
*
**  WA_FIELDCAT-FIELDNAME = 'VBELN'.
**  WA_FIELDCAT-SELTEXT_L = 'GATE ENTRY SEQ'.
**  APPEND WA_FIELDCAT TO FIELDCAT.
**  CLEAR WA_FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'MJAHR'.
*  WA_FIELDCAT-SELTEXT_L = 'YEAR'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.

  wa_fieldcat-fieldname = 'STRY'.
  wa_fieldcat-seltext_l = 'ACCEPT'.
  wa_fieldcat-edit = 'X'.
  wa_fieldcat-checkbox = 'X'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'STRN'.
  wa_fieldcat-seltext_l = 'REJECT'.
  wa_fieldcat-edit = 'X'.
  wa_fieldcat-checkbox = 'X'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'STRTXT'.
  wa_fieldcat-seltext_l = 'ENTER REMARK'.
  wa_fieldcat-edit = 'X'.
  wa_fieldcat-outputlen = 50.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'NUM'.
  wa_fieldcat-seltext_l = 'GATE ENTRY NO.'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'EBELN'.
  wa_fieldcat-seltext_l = 'PO NO.'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'AEDAT'.
  wa_fieldcat-seltext_l = 'PO DATE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'NAME1'.
  wa_fieldcat-seltext_l = 'PO VENDOR NAME'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'ORT01'.
  wa_fieldcat-seltext_l = 'PO VENDOR PLACE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'XBLNR'.
  wa_fieldcat-seltext_l = 'BILL/CHALLAN NO.'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'BLDAT'.
  wa_fieldcat-seltext_l = 'BILL/CHALLAN DATE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'VEHNO'.
  wa_fieldcat-seltext_l = 'VEHICLE NO.'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'TRANSPORTER'.
  wa_fieldcat-seltext_l = 'TRANSPORTER NAME'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'REMARK'.
  wa_fieldcat-seltext_l = 'REMARK BY SECURITY GATE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'CPUDT'.
  wa_fieldcat-seltext_l = 'GATE ENTRY DATE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'CPUTM'.
  wa_fieldcat-seltext_l = 'GATE ENTRY TIME'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.
*
  wa_fieldcat-fieldname = 'USNAM'.
  wa_fieldcat-seltext_l = 'GATE ENTRY LOGIN'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.


**  append wa_fieldcat to fieldcat.
*
*  L_GLAY-EDT_CLL_CB = 'X'.
*
**  ls_layout-colwidth_optimize = 'X'.
*
*
*  WA_FIELDCAT-FIELDNAME = 'CHK'.
*  WA_FIELDCAT-SELTEXT_L = 'SELECT'.
*  WA_FIELDCAT-CHECKBOX = 'X'.
*  WA_FIELDCAT-EDIT = 'X'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.



  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'STORE ACCEPTANCE/ REJECTION FOR GATE ENTRY AGAINST PURCHASE ORDER'.


  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = g_repid
*     I_CALLBACK_PF_STATUS_SET          = 'STATUS'
      i_callback_user_command = 'USER_COMM'
      i_callback_top_of_page  = 'TOP'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         = L_GLAY
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
      t_outtab                = it_disp1
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.
  clear : fieldcat,layout.



endform.
*&---------------------------------------------------------------------*
*&      Form  AUTH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form auth .
  authority-check object 'M_BCO_WERK'
            id 'WERKS' field plant1.
  if sy-subrc <> 0.
    concatenate 'No authorization for Plant' plant1 into msg
    separated by space.
    message msg type 'E'.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  AUTH1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form auth1 .
  select * from t001w into table it_t001w where werks eq werks.
  loop at it_t001w into wa_t001w.
    authority-check object 'M_BCO_WERK'
            id 'WERKS' field wa_t001w-werks.
    if sy-subrc <> 0.
      concatenate 'No authorization for Plant' wa_t001w-werks into msg
      separated by space.
      message msg type 'E'.
    endif.
  endloop.
endform.
*&---------------------------------------------------------------------*
*&      Form  ALVDISP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*


form user_comm1 using ucomm like sy-ucomm
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
*&      Form  FORM3
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form grndisp.

  sort it_disp1 by ebeln.
  delete adjacent duplicates from it_disp1 comparing ebeln.
  if it_disp1 is not initial.
    select * from mseg into table it_mseg for all entries in it_disp1 where ebeln eq it_disp1-ebeln and lifnr gt 0 and bwart in ('101','102','161','162').
  endif.
*  BREAK-POINT.
  loop at it_mseg into wa_mseg.
    read table it_ekko into wa_ekko with key ebeln = wa_mseg-ebeln.
    if sy-subrc eq 0.
      wa_disp2-ebeln = wa_ekko-ebeln.
      wa_disp2-aedat = wa_ekko-aedat.
      wa_disp2-ebelp = wa_mseg-ebelp.
      wa_disp2-mblnr = wa_mseg-mblnr.
      wa_disp2-bwart = wa_mseg-bwart.
      wa_disp2-matnr = wa_mseg-matnr.
      if wa_mseg-shkzg eq 'H'.
        wa_mseg-menge = wa_mseg-menge * ( - 1 ).
      endif.
      wa_disp2-grnmenge = wa_mseg-menge.
      select single * from mkpf where mblnr eq wa_mseg-mblnr and mjahr eq wa_mseg-mjahr.
      if sy-subrc eq 0.
        wa_disp2-budat = mkpf-budat.
        wa_disp2-xblnr = mkpf-xblnr.
        wa_disp2-bldat = mkpf-bldat.
        wa_disp2-gateno = mkpf-bktxt.
        wa_disp2-gateyr = mkpf-mjahr.
        select single * from zpo_gate where mjahr eq mkpf-mjahr and vbeln eq mkpf-bktxt.
        if sy-subrc eq 0.
          wa_disp2-gatecpudt =  zpo_gate-cpudt.
          wa_disp2-gatecputm =  zpo_gate-cputm.
          wa_disp2-gateuname =  zpo_gate-usnam.
        endif.
      endif.

      read table it_ekpo into wa_ekpo with key ebeln = wa_mseg-ebeln ebelp = wa_mseg-ebelp.
      if sy-subrc eq 0.
        wa_disp2-txz01 = wa_ekpo-txz01.
        wa_disp2-menge = wa_ekpo-menge.
      endif.
      select single * from lfa1 where lifnr eq wa_ekko-lifnr.
      if sy-subrc eq 0.
        select single * from adrc where addrnumber eq lfa1-adrnr.
        if sy-subrc eq 0.
          wa_disp2-name1 = adrc-name1.
        endif.
        wa_disp2-ort01 = lfa1-ort01.
      endif.
      collect wa_disp2 into it_disp2.
      clear wa_disp2.
    endif.
  endloop.

  perform alv1.

endform.
*&---------------------------------------------------------------------*
*&      Form  ALV1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form alv1 .


  wa_fieldcat-fieldname = 'EBELN'.
  wa_fieldcat-seltext_l = 'PO NO.'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'AEDAT'.
  wa_fieldcat-seltext_l = 'PO DATE.'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'EBELP'.
  wa_fieldcat-seltext_l = 'PO ITEM NO.'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_l = 'PO ITEM CODE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.
*
  wa_fieldcat-fieldname = 'TXZ01'.
  wa_fieldcat-seltext_l = 'PO ITEM DESCRIPTION'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'MENGE'.
  wa_fieldcat-seltext_l = 'PO QTY'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'NAME1'.
  wa_fieldcat-seltext_l = 'PO VENDOR NAME'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'ORT01'.
  wa_fieldcat-seltext_l = 'PO VENDOR PLACE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'MBLNR'.
  wa_fieldcat-seltext_l = 'GRN NO.'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'BUDAT'.
  wa_fieldcat-seltext_l = 'GRN MOV'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'GRNMENGE'.
  wa_fieldcat-seltext_l = 'GRN QUANTITY'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'XBLNR'.
  wa_fieldcat-seltext_l = 'BILL NO.'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'BLDAT'.
  wa_fieldcat-seltext_l = 'BILL DATE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'GATENO'.
  wa_fieldcat-seltext_l = 'GATE ENTRY NO'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'GATEYR'.
  wa_fieldcat-seltext_l = 'GATE ENTRY YEAR'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'GATECPUDT'.
  wa_fieldcat-seltext_l = 'GATE ENTRY DATE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'GATECPUTM'.
  wa_fieldcat-seltext_l = 'GATE ENTRY TIME'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'GATEUNAME'.
  wa_fieldcat-seltext_l = 'GATE ENTRY LOGIN'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.



*  append wa_fieldcat to fieldcat.

  l_glay-edt_cll_cb = 'X'.

*  ls_layout-colwidth_optimize = 'X'.





  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'PURCHASE ORDER DETAILS'.


  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = g_repid
*     I_CALLBACK_PF_STATUS_SET          = 'STATUS'
      i_callback_user_command = 'USER_COMM'
      i_callback_top_of_page  = 'TOP'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         = L_GLAY
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
      t_outtab                = it_disp2
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.
  clear : fieldcat,layout.
endform.
*&---------------------------------------------------------------------*
*&      Form  STOCKDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form stockdata .
*  CLEAR : E1.
*  LOOP AT IT_DISP1 INTO WA_DISP1.
*    SELECT SINGLE * FROM ZPO_GATE WHERE VBELN EQ WA_DISP1-VBELN AND MJAHR EQ WA_DISP1-MJAHR AND WERKS EQ WA_DISP1-WERKS.
*    IF SY-SUBRC EQ 0.
*      IF WA_DISP1-STRY EQ SPACE AND WA_DISP1-STRN EQ SPACE.
*        E1 = 1.
*        MESSAGE 'EITHER ACCEPT OR REJECT' TYPE 'I'.
*        LEAVE TO SCREEN 0.
*      ENDIF.
*      IF WA_DISP1-STRY NE SPACE AND WA_DISP1-STRN NE SPACE.
*        E1 = 1.
*        MESSAGE 'EITHER ACCEPT OR REJECT' TYPE 'I'.
*        LEAVE TO SCREEN 0.
*      ENDIF.
*    ENDIF.
*  ENDLOOP.

  clear : e1,a1.
  loop at it_disp1 into wa_disp1.
    clear : e1.
    select single * from zpo_gate where vbeln eq wa_disp1-vbeln and mjahr eq wa_disp1-mjahr and werks eq wa_disp1-werks.
    if sy-subrc eq 0.
      if wa_disp1-stry eq space and wa_disp1-strn eq space.
        e1 = 1.
        message 'EITHER ACCEPT OR REJECT' type 'I'.
*        LEAVE TO SCREEN 0.
      endif.
      if wa_disp1-stry ne space and wa_disp1-strn ne space.
        e1 = 1.
        message 'EITHER ACCEPT OR REJECT' type 'I'.
*        LEAVE TO SCREEN 0.
      endif.
      if wa_disp1-strn ne space and wa_disp1-strtxt eq space.
        e1 = 1.
        message 'ENTER REMARK FOR REJECTION' type 'I'.
      endif.

      if e1 ne 1.
        move-corresponding zpo_gate to zpo_gate_wa.
        zpo_gate_wa-stry = wa_disp1-stry.
        zpo_gate_wa-strn = wa_disp1-strn.
        if wa_disp1-strn eq 'X'.
          rejem1 = 1.
        endif.
        if wa_disp1-stry eq 'X'.
          accem1 = 1.
        endif.
        zpo_gate_wa-strtxt = wa_disp1-strtxt.
        zpo_gate_wa-scpudt = sy-datum.
        zpo_gate_wa-scputm = sy-uzeit.
        zpo_gate_wa-susnam = sy-uname.
        zpo_gate_wa-spernr = pernr.
        modify  zpo_gate from  zpo_gate_wa.
        commit work and wait .
        clear  zpo_gate_wa.
        a1 = 1.
      endif.
    endif.
  endloop.

  if a1 eq 1.

    message 'DATA SAVED' type 'I'.
*    IF REJEM1 EQ 'X'.
    if rejem1 eq 1.
      perform email.
    endif.
    if accem1 eq 1.
      perform email.
    endif.

  endif.

  leave to screen 0.
endform.
*&---------------------------------------------------------------------*
*&      Form  PASSW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form passw .
  select single * from zpassw where pernr = pernr.
  if sy-subrc eq 0.

    if sy-uname ne zpassw-uname.  "added on 18.5.23
      message 'INVALID LOGIN ID' type 'I'.
      leave to screen 0.
    endif.
    v_en_string = zpassw-password.
*&———————————————————————** Decryption – String to String*&———————————————————————*
    try.
        create object o_encryptor.
        call method o_encryptor->decrypt_string2string
          exporting
            the_string = v_en_string
          receiving
            result     = v_de_string.
      catch cx_encrypt_error into o_cx_encrypt_error.
        call method o_cx_encrypt_error->if_message~get_text
          receiving
            result = v_error_msg.
        message v_error_msg type 'E'.
    endtry.
    if v_de_string eq pass.
*      message 'CORRECT PASSWORD' type 'I'.
    else.
      message 'INCORRECT PASSWORD' type 'I'.
      leave to screen 0.
    endif.
  else.
    message 'NOT VALID USER' type 'I'.
    leave to screen 0.
    exit.
  endif.
  clear : pass.
  pass = '   '.
endform.
*&---------------------------------------------------------------------*
*&      Form  FORM3
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form form3 .


*  BREAK-POINT .
  select * from zpo_gate into table it_zpo_gate where werks eq werks and cpudt in budat and scpudt gt 0 and gcpudt le 0 and gocpudt le 0.
  if sy-subrc eq 0.
    select * from ekpo into table it_ekpo for all entries in it_zpo_gate where ebeln eq it_zpo_gate-ebeln and werks eq werks and ebeln in ord.
    if sy-subrc eq 0.
      select * from ekko into table it_ekko for all entries in it_ekpo where ebeln eq it_ekpo-ebeln.
    endif.
  endif.
  if it_ekpo is initial.
    message 'NO DATA FOUND' type 'I'.
    leave to screen 0.
  endif.
  clear : rej1.
  loop at it_zpo_gate into wa_zpo_gate.
    read table it_ekko into wa_ekko with key ebeln = wa_zpo_gate-ebeln.
    if sy-subrc eq 0.
      read table it_ekpo into wa_ekpo with key ebeln = wa_zpo_gate-ebeln.
      if sy-subrc eq 0.
        wa_disp1-vbeln = wa_zpo_gate-vbeln.
        wa_disp1-mjahr = wa_zpo_gate-mjahr.
        wa_disp1-werks = wa_zpo_gate-werks.
        wa_disp1-num = wa_zpo_gate-num.
        wa_disp1-ebeln = wa_zpo_gate-ebeln.
        wa_disp1-aedat = wa_ekko-aedat.
        select single * from lfa1 where lifnr eq wa_ekko-lifnr.
        if sy-subrc eq 0.
          select single * from adrc where addrnumber eq lfa1-adrnr.
          if sy-subrc eq 0.
            wa_disp1-name1 = adrc-name1.
          endif.
          wa_disp1-ort01 = lfa1-ort01.
        endif.

        wa_disp1-xblnr = wa_zpo_gate-xblnr.
        wa_disp1-bldat = wa_zpo_gate-bldat.
        wa_disp1-vehno = wa_zpo_gate-vehno.
        wa_disp1-transporter = wa_zpo_gate-transporter.
        wa_disp1-remark = wa_zpo_gate-remark.


        wa_disp1-cpudt = wa_zpo_gate-cpudt.
        wa_disp1-cputm = wa_zpo_gate-cputm.
        wa_disp1-usnam = wa_zpo_gate-usnam.
        if wa_zpo_gate-stry eq 'X'.
          wa_disp1-strstatus = 'ACCEPTED'.
        elseif wa_zpo_gate-strn eq 'X'.
          wa_disp1-strstatus = 'REJECTED'.
        endif.
        wa_disp1-strtxt = wa_zpo_gate-strtxt.
        select single * from pa0001 where pernr eq wa_zpo_gate-spernr and endda ge sy-datum.
        if sy-subrc eq 0.
          wa_disp1-sname = pa0001-ename.
        endif.

        wa_disp1-scpudt = wa_zpo_gate-scpudt.
        wa_disp1-scputm = wa_zpo_gate-scputm.

        if wa_zpo_gate-rejpernr gt 0.
          rej1 = 1.
          select single * from pa0001 where pernr eq wa_zpo_gate-rejpernr and endda ge sy-datum.
          if sy-subrc eq 0.
            wa_disp1-rejname = pa0001-ename.
          endif.
          wa_disp1-rejcpudt = wa_zpo_gate-rejcpudt.
          wa_disp1-rejcputm = wa_zpo_gate-rejcputm.
        endif.

        collect wa_disp1 into it_disp1.
        clear wa_disp1.
      endif.
    endif.
  endloop.

*  *  WA_FIELDCAT-FIELDNAME = 'WERKS'.
*  WA_FIELDCAT-SELTEXT_L = 'PLANT'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.
*
**  WA_FIELDCAT-FIELDNAME = 'VBELN'.
**  WA_FIELDCAT-SELTEXT_L = 'GATE ENTRY SEQ'.
**  APPEND WA_FIELDCAT TO FIELDCAT.
**  CLEAR WA_FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'MJAHR'.
*  WA_FIELDCAT-SELTEXT_L = 'YEAR'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.

  wa_fieldcat-fieldname = 'NUM'.
  wa_fieldcat-seltext_l = 'GATE ENTRY NO.'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'GIN'.
  wa_fieldcat-seltext_l = 'VEHICLE IN'.
  wa_fieldcat-edit = 'X'.
  wa_fieldcat-checkbox = 'X'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

*  WA_FIELDCAT-FIELDNAME = 'GOUT'.
*  WA_FIELDCAT-SELTEXT_L = 'VEHICLE OUT'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-CHECKBOX = 'X'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.

  wa_fieldcat-fieldname = 'STRSTATUS'.
  wa_fieldcat-seltext_l = 'STORE STATUS'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-CHECKBOX = 'X'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'STRTXT'.
  wa_fieldcat-seltext_l = 'STORE REMARK'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-OUTPUTLEN = 50.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'SNAME'.
  wa_fieldcat-seltext_l = 'STORE ENTRY BY'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-OUTPUTLEN = 50.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'SCPUDT'.
  wa_fieldcat-seltext_l = 'STORE ENTRY DATE'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-OUTPUTLEN = 50.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'SCPUTM'.
  wa_fieldcat-seltext_l = 'STORE ENTRY TIME'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-OUTPUTLEN = 50.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  if rej1 eq 1.
    wa_fieldcat-fieldname = 'REJNAME'.
    wa_fieldcat-seltext_l = 'REJECTION APPROVED BY'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-OUTPUTLEN = 50.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.


    wa_fieldcat-fieldname = 'RECPUDT'.
    wa_fieldcat-seltext_l = 'REJECTION APPROVED DATE'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-OUTPUTLEN = 50.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

    wa_fieldcat-fieldname = 'RECPUTM'.
    wa_fieldcat-seltext_l = 'REJECTION APPROVED TIME'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-OUTPUTLEN = 50.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

  endif.

  wa_fieldcat-fieldname = 'EBELN'.
  wa_fieldcat-seltext_l = 'PO NO.'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'AEDAT'.
  wa_fieldcat-seltext_l = 'PO DATE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'NAME1'.
  wa_fieldcat-seltext_l = 'PO VENDOR NAME'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'ORT01'.
  wa_fieldcat-seltext_l = 'PO VENDOR PLACE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.


  wa_fieldcat-fieldname = 'XBLNR'.
  wa_fieldcat-seltext_l = 'BILL/CHALLAN NO.'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'BLDAT'.
  wa_fieldcat-seltext_l = 'BILL/CHALLAN DATE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'VEHNO'.
  wa_fieldcat-seltext_l = 'VEHICLE NO.'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'TRANSPORTER'.
  wa_fieldcat-seltext_l = 'TRANSPORTER NAME'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'REMARK'.
  wa_fieldcat-seltext_l = 'REMARK BY SECURITY GATE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'CPUDT'.
  wa_fieldcat-seltext_l = 'GATE ENTRY DATE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'CPUTM'.
  wa_fieldcat-seltext_l = 'GATE ENTRY TIME'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.
*
  wa_fieldcat-fieldname = 'USNAM'.
  wa_fieldcat-seltext_l = 'GATE ENTRY LOGIN'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.


**  append wa_fieldcat to fieldcat.
*
*  L_GLAY-EDT_CLL_CB = 'X'.
*
**  ls_layout-colwidth_optimize = 'X'.
*
*
*  WA_FIELDCAT-FIELDNAME = 'CHK'.
*  WA_FIELDCAT-SELTEXT_L = 'SELECT'.
*  WA_FIELDCAT-CHECKBOX = 'X'.
*  WA_FIELDCAT-EDIT = 'X'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.



  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'GATE CONFIRMATION TO SEND VEHICLE IN.'.


  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = g_repid
*     I_CALLBACK_PF_STATUS_SET          = 'STATUS'
      i_callback_user_command = 'USER_COMM'
      i_callback_top_of_page  = 'TOP'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         = L_GLAY
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
      t_outtab                = it_disp1
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.
  clear : fieldcat,layout.

endform.
*&---------------------------------------------------------------------*
*&      Form  GATECONF
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form gateconf .
*  BREAK-POINT .
*  CLEAR : E1,A1.
  loop at it_disp1 into wa_disp1 where gin eq 'X'.
    clear : e1.
    select single * from zpo_gate where vbeln eq wa_disp1-vbeln and mjahr eq wa_disp1-mjahr and werks eq wa_disp1-werks and scpudt gt 0.
    if sy-subrc eq 0.
      if zpo_gate-stry eq 'X' and wa_disp1-gout eq 'X'.
        e1 = 1.
        message 'CONFIRM TO SEND VEHICLE INSIDE PLANT' type 'I'.
*        LEAVE TO SCREEN 0.
      endif.
      if zpo_gate-strn eq 'X' and wa_disp1-gin eq 'X'.
        e1 = 1.
        message 'CONFIRM TO SEND VEHICLE OUTSIDE PLANT' type 'I'.
*        LEAVE TO SCREEN 0.
      endif.
      if zpo_gate-strn eq 'X' and wa_disp1-rejname eq space.
        e1 = 1.
        message 'REJECTION IS NOT YET APPROVED' type 'I'.
*        LEAVE TO SCREEN 0.
      endif.
      if zpo_gate-gin eq 'X' and wa_disp1-gout eq 'X'.
        e1 = 1.
        message 'Select either VEHICLE IN or VHICLE OUT' type 'I'.
*        LEAVE TO SCREEN 0.
      endif.


      if e1 ne 1.
        move-corresponding zpo_gate to zpo_gate_wa.
        zpo_gate_wa-gin = wa_disp1-gin.
*        ZPO_GATE_WA-GOUT = WA_DISP1-GOUT.
        zpo_gate_wa-gcpudt = sy-datum.
        zpo_gate_wa-gcputm = sy-uzeit.
        zpo_gate_wa-gusnam = sy-uname.
        modify  zpo_gate from  zpo_gate_wa.
        commit work and wait .
        clear  zpo_gate_wa.
        a1 = 1.
      endif.
    endif.
  endloop.

  if a1 eq 1.
    message 'Data saved for VEHICLE IN' type 'I'.
  endif.

  leave to screen 0.

endform.
*&---------------------------------------------------------------------*
*&      Form  FORM4
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form form4 .


*  BREAK-POINT .
  if r6 eq 'X'.
    select * from zpo_gate into table it_zpo_gate where werks eq werks and  cpudt in budat and del ne space.
  else.
    select * from zpo_gate into table it_zpo_gate where werks eq werks and  cpudt in budat and del eq space.
  endif.
  if it_zpo_gate is not initial.
    select * from ekpo into table it_ekpo for all entries in it_zpo_gate where ebeln eq it_zpo_gate-ebeln and werks eq werks and ebeln in ord.
    if sy-subrc eq 0.
      select * from ekbe into table it_ekbe for all entries in it_ekpo where ebeln eq it_ekpo-ebeln and ebelp eq it_ekpo-ebelp.
      select * from ekko into table it_ekko for all entries in it_ekpo where ebeln eq it_ekpo-ebeln and lifnr in vendor.
    endif.
  endif.
  if it_ekpo is initial.
    message 'NO DATA FOUND' type 'I'.
    leave to screen 0.
  endif.
  clear : rej1.

  loop at it_ekbe into wa_ekbe.
    select single * from mkpf where mblnr eq wa_ekbe-belnr and mjahr eq wa_ekbe-gjahr.
    if sy-subrc eq 0.
      wa_gat1-ebeln = wa_ekbe-ebeln.
      wa_gat1-ebelp = wa_ekbe-ebelp.
      wa_gat1-mblnr = mkpf-mblnr.
      wa_gat1-mjahr = mkpf-mjahr.
      wa_gat1-bktxt = mkpf-bktxt.
      wa_gat1-budat = mkpf-budat.
      collect wa_gat1 into it_gat1.
      clear wa_gat1.
    endif.
  endloop.
  sort it_gat1 descending by mblnr.
  loop at it_zpo_gate into wa_zpo_gate.
    read table it_ekko into wa_ekko with key ebeln = wa_zpo_gate-ebeln.
    if sy-subrc eq 0.
      read table it_ekpo into wa_ekpo with key ebeln = wa_zpo_gate-ebeln.
      if sy-subrc eq 0.
        wa_disp1-vbeln = wa_zpo_gate-vbeln.
        wa_disp1-mjahr = wa_zpo_gate-mjahr.
        wa_disp1-werks = wa_zpo_gate-werks.
        wa_disp1-num = wa_zpo_gate-num.
        wa_disp1-ebeln = wa_zpo_gate-ebeln.
*        read table it_gat1 into wa_gat1 with key ebeln = wa_ekpo-ebeln ebelp = wa_ekpo-ebelp bktxt = wa_zpo_gate-num.
        read table it_gat1 into wa_gat1 with key ebeln = wa_ekpo-ebeln bktxt = wa_zpo_gate-num.
        if sy-subrc eq 0.
          wa_disp1-mblnr = wa_gat1-mblnr.
          wa_disp1-budat = wa_gat1-budat.
        endif.
        wa_disp1-aedat = wa_ekko-aedat.
        select single * from lfa1 where lifnr eq wa_ekko-lifnr.
        if sy-subrc eq 0.
          select single * from adrc where addrnumber eq lfa1-adrnr.
          if sy-subrc eq 0.
            wa_disp1-name1 = adrc-name1.
          endif.
          wa_disp1-ort01 = lfa1-ort01.
        endif.

        if wa_disp1-name1 eq space.
          select single * from t001w where werks eq wa_ekko-reswk.
        if sy-subrc eq 0.
*          select single * from adrc where addrnumber eq lfa1-adrnr.
*          if sy-subrc eq 0.
            wa_disp1-name1 = t001w-name1.
*          endif.
          wa_disp1-ort01 = t001w-ort01.
        endif.

        endif.

        wa_disp1-xblnr = wa_zpo_gate-xblnr.
        wa_disp1-bldat = wa_zpo_gate-bldat.
        wa_disp1-vehno = wa_zpo_gate-vehno.
        wa_disp1-transporter = wa_zpo_gate-transporter.
        wa_disp1-remark = wa_zpo_gate-remark.


        wa_disp1-cpudt = wa_zpo_gate-cpudt.
        wa_disp1-cputm = wa_zpo_gate-cputm.
        wa_disp1-usnam = wa_zpo_gate-usnam.
        if wa_zpo_gate-stry eq 'X'.
          wa_disp1-strstatus = 'ACCEPTED'.
        elseif wa_zpo_gate-strn eq 'X'.
          wa_disp1-strstatus = 'REJECTED'.
          rej1 = 1.
        endif.
        wa_disp1-strtxt = wa_zpo_gate-strtxt.
        select single * from pa0001 where pernr eq wa_zpo_gate-spernr and endda ge sy-datum.
        if sy-subrc eq 0.
          wa_disp1-sname = pa0001-ename.
        endif.

        if wa_zpo_gate-rejpernr gt 0.
          select single * from pa0001 where pernr eq wa_zpo_gate-rejpernr and endda ge sy-datum.
          if sy-subrc eq 0.
            wa_disp1-rejname = pa0001-ename.
          endif.
          wa_disp1-rejcpudt = wa_zpo_gate-rejcpudt.
          wa_disp1-rejcputm = wa_zpo_gate-rejcputm.
        endif.
        wa_disp1-scpudt = wa_zpo_gate-scpudt.
        wa_disp1-scputm = wa_zpo_gate-scputm.
        if wa_zpo_gate-rejusnam ne space.
          wa_disp1-gstatus = 'REJECTED'.
        endif.
        wa_disp1-gcpudt = wa_zpo_gate-gcpudt.
        wa_disp1-gcputm = wa_zpo_gate-gcputm.
        wa_disp1-gocpudt = wa_zpo_gate-gocpudt.
        wa_disp1-gocputm = wa_zpo_gate-gocputm.
        wa_disp1-deldt = wa_zpo_gate-deldt.
        wa_disp1-deltxt = wa_zpo_gate-deltxt.
        select single * from pa0001 where pernr eq wa_zpo_gate-delpernr and endda ge sy-datum.
        if sy-subrc eq 0.
          wa_disp1-delename = pa0001-ename.
        endif.

        collect wa_disp1 into it_disp1.
        clear wa_disp1.
      endif.
    endif.
  endloop.

*  *  WA_FIELDCAT-FIELDNAME = 'WERKS'.
*  WA_FIELDCAT-SELTEXT_L = 'PLANT'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.
*
**  WA_FIELDCAT-FIELDNAME = 'VBELN'.
**  WA_FIELDCAT-SELTEXT_L = 'GATE ENTRY SEQ'.
**  APPEND WA_FIELDCAT TO FIELDCAT.
**  CLEAR WA_FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'MJAHR'.
*  WA_FIELDCAT-SELTEXT_L = 'YEAR'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.

  wa_fieldcat-fieldname = 'NUM'.
  wa_fieldcat-seltext_l = 'GATE ENTRY NO.'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'EBELN'.
  wa_fieldcat-seltext_l = 'PO NO.'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'MBLNR'.
  wa_fieldcat-seltext_l = 'GRN NO.'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'BUDAT'.
  wa_fieldcat-seltext_l = 'POSTING DT'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'AEDAT'.
  wa_fieldcat-seltext_l = 'PO DATE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'NAME1'.
  wa_fieldcat-seltext_l = 'PO VENDOR NAME'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'ORT01'.
  wa_fieldcat-seltext_l = 'PO VENDOR PLACE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'XBLNR'.
  wa_fieldcat-seltext_l = 'BILL/CHALLAN NO.'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'BLDAT'.
  wa_fieldcat-seltext_l = 'BILL/CHALLAN DATE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'VEHNO'.
  wa_fieldcat-seltext_l = 'VEHICLE NO.'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'TRANSPORTER'.
  wa_fieldcat-seltext_l = 'TRANSPORTER NAME'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'REMARK'.
  wa_fieldcat-seltext_l = 'REMARK BY SECURITY GATE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.


  wa_fieldcat-fieldname = 'CPUDT'.
  wa_fieldcat-seltext_l = 'GATE ENTRY DATE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'CPUTM'.
  wa_fieldcat-seltext_l = 'GATE ENTRY TIME'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.
*
  wa_fieldcat-fieldname = 'USNAM'.
  wa_fieldcat-seltext_l = 'GATE ENTRY LOGIN'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.



  wa_fieldcat-fieldname = 'STRSTATUS'.
  wa_fieldcat-seltext_l = 'STORE STATUS'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-CHECKBOX = 'X'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'STRTXT'.
  wa_fieldcat-seltext_l = 'STORE REMARK'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-OUTPUTLEN = 50.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'SNAME'.
  wa_fieldcat-seltext_l = 'STORE ENTRY BY'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-OUTPUTLEN = 50.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'SCPUDT'.
  wa_fieldcat-seltext_l = 'STORE ENTRY DATE'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-OUTPUTLEN = 50.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'SCPUTM'.
  wa_fieldcat-seltext_l = 'STORE ENTRY TIME'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-OUTPUTLEN = 50.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

*  IF REJ1 EQ 1.
  wa_fieldcat-fieldname = 'REJNAME'.
  wa_fieldcat-seltext_l = 'REJECTION APPROVED BY'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-OUTPUTLEN = 50.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'REJCPUDT'.
  wa_fieldcat-seltext_l = 'REJECTION APPROVAL DATE'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-OUTPUTLEN = 50.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'REJCPUTM'.
  wa_fieldcat-seltext_l = 'REJECTION APPROVAL TIME'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-OUTPUTLEN = 50.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.
*  ENDIF.


  wa_fieldcat-fieldname = 'GSTATUS'.
  wa_fieldcat-seltext_l = 'GATE CONFIRMATION FOR'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-CHECKBOX = 'X'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'GCPUDT'.
  wa_fieldcat-seltext_l = 'VEHICLE IN DT'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'GCPUTM'.
  wa_fieldcat-seltext_l = 'VEHICLE IN TM'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'GOCPUDT'.
  wa_fieldcat-seltext_l = 'VEHICLE OUT DT'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'GOCPUTM'.
  wa_fieldcat-seltext_l = 'VEHICLE OUT TM'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  if r6 eq 'X'.
    wa_fieldcat-fieldname = 'DELTXT'.
    wa_fieldcat-seltext_l = 'DELETION REASON'.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

    wa_fieldcat-fieldname = 'DELENAME'.
    wa_fieldcat-seltext_l = 'DELETED BY'.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

    wa_fieldcat-fieldname = 'DELDT'.
    wa_fieldcat-seltext_l = 'DELETED ON'.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.
  endif.





**  append wa_fieldcat to fieldcat.
*
*  L_GLAY-EDT_CLL_CB = 'X'.
*
**  ls_layout-colwidth_optimize = 'X'.
*
*
*  WA_FIELDCAT-FIELDNAME = 'CHK'.
*  WA_FIELDCAT-SELTEXT_L = 'SELECT'.
*  WA_FIELDCAT-CHECKBOX = 'X'.
*  WA_FIELDCAT-EDIT = 'X'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.



  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.

  if r6 eq 'X'.
    layout-window_titlebar  = 'DELETED GATE ENTRY DETAILS'.
  else.
    layout-window_titlebar  = 'GATE ENTRY DETAILS'.
  endif.


  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = g_repid
*     I_CALLBACK_PF_STATUS_SET          = 'STATUS'
      i_callback_user_command = 'USER_COMM'
      i_callback_top_of_page  = 'TOP'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         = L_GLAY
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
      t_outtab                = it_disp1
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.
  clear : fieldcat,layout.


endform.
*&---------------------------------------------------------------------*
*&      Form  REJFORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form rejform .
*  BREAK-POINT .
  select * from zpo_gate into table it_zpo_gate where werks eq werks and cpudt in budat and strn eq 'X' and rejcpudt le 0 and gcpudt le 0 and del eq space.
  if sy-subrc eq 0.
    select * from ekpo into table it_ekpo for all entries in it_zpo_gate where ebeln eq it_zpo_gate-ebeln and werks eq werks and ebeln in ord.
    if sy-subrc eq 0.
      select * from ekko into table it_ekko for all entries in it_ekpo where ebeln eq it_ekpo-ebeln and lifnr in vendor.
    endif.
  endif.
  if it_ekpo is initial.
    message 'NO DATA FOUND' type 'I'.
    leave to screen 0.
  endif.

  loop at it_zpo_gate into wa_zpo_gate.
    read table it_ekko into wa_ekko with key ebeln = wa_zpo_gate-ebeln.
    if sy-subrc eq 0.
      read table it_ekpo into wa_ekpo with key ebeln = wa_zpo_gate-ebeln.
      if sy-subrc eq 0.
        wa_disp1-vbeln = wa_zpo_gate-vbeln.
        wa_disp1-mjahr = wa_zpo_gate-mjahr.
        wa_disp1-werks = wa_zpo_gate-werks.
        wa_disp1-num = wa_zpo_gate-num.
        wa_disp1-ebeln = wa_zpo_gate-ebeln.
        wa_disp1-aedat = wa_ekko-aedat.
        select single * from lfa1 where lifnr eq wa_ekko-lifnr.
        if sy-subrc eq 0.
          select single * from adrc where addrnumber eq lfa1-adrnr.
          if sy-subrc eq 0.
            wa_disp1-name1 = adrc-name1.
          endif.
          wa_disp1-ort01 = lfa1-ort01.
        endif.

        wa_disp1-xblnr = wa_zpo_gate-xblnr.
        wa_disp1-bldat = wa_zpo_gate-bldat.
        wa_disp1-vehno = wa_zpo_gate-vehno.
        wa_disp1-transporter = wa_zpo_gate-transporter.
        wa_disp1-remark = wa_zpo_gate-remark.


        wa_disp1-cpudt = wa_zpo_gate-cpudt.
        wa_disp1-cputm = wa_zpo_gate-cputm.
        wa_disp1-usnam = wa_zpo_gate-usnam.
        if wa_zpo_gate-stry eq 'X'.
          wa_disp1-strstatus = 'ACCEPTED'.
        elseif wa_zpo_gate-strn eq 'X'.
          wa_disp1-strstatus = 'REJECTED'.
        endif.
        wa_disp1-strtxt = wa_zpo_gate-strtxt.
        select single * from pa0001 where pernr eq wa_zpo_gate-spernr and endda ge sy-datum.
        if sy-subrc eq 0.
          wa_disp1-sname = pa0001-ename.
        endif.

        wa_disp1-scpudt = wa_zpo_gate-scpudt.
        wa_disp1-scputm = wa_zpo_gate-scputm.

        collect wa_disp1 into it_disp1.
        clear wa_disp1.
      endif.
    endif.
  endloop.

*  *  WA_FIELDCAT-FIELDNAME = 'WERKS'.
*  WA_FIELDCAT-SELTEXT_L = 'PLANT'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.
*
**  WA_FIELDCAT-FIELDNAME = 'VBELN'.
**  WA_FIELDCAT-SELTEXT_L = 'GATE ENTRY SEQ'.
**  APPEND WA_FIELDCAT TO FIELDCAT.
**  CLEAR WA_FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'MJAHR'.
*  WA_FIELDCAT-SELTEXT_L = 'YEAR'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.

  wa_fieldcat-fieldname = 'NUM'.
  wa_fieldcat-seltext_l = 'GATE ENTRY NO.'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'APR'.
  wa_fieldcat-seltext_l = 'APPROVE REJECTION'.
  wa_fieldcat-edit = 'X'.
  wa_fieldcat-checkbox = 'X'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.


  wa_fieldcat-fieldname = 'STRSTATUS'.
  wa_fieldcat-seltext_l = 'STORE STATUS'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-CHECKBOX = 'X'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'STRTXT'.
  wa_fieldcat-seltext_l = 'STORE REMARK'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-OUTPUTLEN = 50.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'SNAME'.
  wa_fieldcat-seltext_l = 'STORE ENTRY BY'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-OUTPUTLEN = 50.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'SCPUDT'.
  wa_fieldcat-seltext_l = 'STORE ENTRY DATE'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-OUTPUTLEN = 50.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'SCPUTM'.
  wa_fieldcat-seltext_l = 'STORE ENTRY TIME'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-OUTPUTLEN = 50.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.




  wa_fieldcat-fieldname = 'EBELN'.
  wa_fieldcat-seltext_l = 'PO NO.'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'AEDAT'.
  wa_fieldcat-seltext_l = 'PO DATE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'NAME1'.
  wa_fieldcat-seltext_l = 'PO VENDOR NAME'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'ORT01'.
  wa_fieldcat-seltext_l = 'PO VENDOR PLACE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'XBLNR'.
  wa_fieldcat-seltext_l = 'BILL/CHALLAN NO.'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'BLDAT'.
  wa_fieldcat-seltext_l = 'BILL/CHALLAN DATE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'VEHNO'.
  wa_fieldcat-seltext_l = 'VEHICLE NO.'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'TRANSPORTER'.
  wa_fieldcat-seltext_l = 'TRANSPORTER NAME'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'REMARK'.
  wa_fieldcat-seltext_l = 'REMARK BY SECURITY GATE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.


  wa_fieldcat-fieldname = 'CPUDT'.
  wa_fieldcat-seltext_l = 'GATE ENTRY DATE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'CPUTM'.
  wa_fieldcat-seltext_l = 'GATE ENTRY TIME'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.
*
  wa_fieldcat-fieldname = 'USNAM'.
  wa_fieldcat-seltext_l = 'GATE ENTRY LOGIN'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.


**  append wa_fieldcat to fieldcat.
*
*  L_GLAY-EDT_CLL_CB = 'X'.
*
**  ls_layout-colwidth_optimize = 'X'.
*
*
*  WA_FIELDCAT-FIELDNAME = 'CHK'.
*  WA_FIELDCAT-SELTEXT_L = 'SELECT'.
*  WA_FIELDCAT-CHECKBOX = 'X'.
*  WA_FIELDCAT-EDIT = 'X'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.



  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'REJECTION APPROVAL TO RETURN VEHICLE'.


  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = g_repid
*     I_CALLBACK_PF_STATUS_SET          = 'STATUS'
      i_callback_user_command = 'USER_COMM'
      i_callback_top_of_page  = 'TOP'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         = L_GLAY
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
      t_outtab                = it_disp1
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.
  clear : fieldcat,layout.

endform.
*&---------------------------------------------------------------------*
*&      Form  REJAPPROVAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form rejapproval .
  loop at it_disp1 into wa_disp1 where apr eq 'X'.
    select single * from zpo_gate where vbeln eq wa_disp1-vbeln and mjahr eq wa_disp1-mjahr and werks eq wa_disp1-werks and strn eq 'X' and rejcpudt le 0.
    if sy-subrc eq 0.
      move-corresponding zpo_gate to zpo_gate_wa.
      zpo_gate_wa-rejcpudt = sy-datum.
      zpo_gate_wa-rejcputm = sy-uzeit.
      zpo_gate_wa-rejusnam = sy-uname.
      zpo_gate_wa-rejpernr = pernr.
      modify  zpo_gate from  zpo_gate_wa.
      commit work and wait .
      clear  zpo_gate_wa.
      a1 = 1.
    endif.
  endloop.

  if a1 eq 1.
    message 'REJECTION IS APPROVED TO RETURN VEHICLE' type 'I'.
    perform email.
  endif.

  leave to screen 0.
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
*  BREAK-POINT .
*  CLEAR : SUBJECT.
  clear : objtxt. "7.6.21
  refresh objtxt. "7.6.21
*  SELECT SINGLE * FROM ZDMS1 WHERE MJAHR EQ YEAR AND MBLNR EQ CCNUM.
*  IF SY-SUBRC EQ 0.
*    CONCATENATE ZDMS1-QAREMARK1 ZDMS1-QAREMARK2  ZDMS1-QAREMARK3 INTO SUBJECT SEPARATED BY SPACE.
*  ENDIF.

*  SUBJECT = 'GATE ENTRY'.
*  BREAK-POINT.
  clear : it_email,wa_email.
  if sy-host cs 'SAPQLT' or sy-host cs 'SAPDEV'.
*  IF SY-HOST EQ 'SAPQLT'.
*  BREAK-POINT .
*  IF SY-HOST EQ 'SAPQLT'.
*  IF SY-HOST EQ 'SAPDEV'.
  else.
    clear : it_email,wa_email.
    if r1 eq 'X'.
      perform email1.
    elseif r2 eq 'X'.
      if rejem1 eq 1.
        perform emailrej.
      elseif accem1 eq 1.
        perform emailacc.
      endif.
    elseif rr eq 'X'.
      perform emailacc.
    endif.

    call function 'SX_TABLE_LINE_WIDTH_CHANGE'
      exporting
        line_width_dst = '255'
      tables
        content_in     = l_asc_data
        content_out    = objbin.

    if r1 eq 'X'.
      write sy-datum to wa_d1 dd/mm/yyyy.
    else.
*      SELECT SINGLE * FROM ZDMS1 WHERE MJAHR EQ YEAR AND MBLNR EQ CCNUM.
*      IF SY-SUBRC EQ 0.
*        WRITE ZDMS1-BUDAT TO WA_D1 DD/MM/YYYY.
*      ENDIF.
    endif.


*    BREAK-POINT.
    condense objtxt.

    describe table objbin lines righe_attachment.
*    SUBJECT = 'GATE ENTRY'.
*    W_OBJTXT = SUBJECT.
*    APPEND W_OBJTXT TO OBJTXT.
*    CLEAR W_OBJTXT.
*    CONDENSE objtxt.
*
*    W_OBJTXT = '    '.
*    APPEND W_OBJTXT TO OBJTXT.
*    CLEAR W_OBJTXT.
*    CONDENSE objtxt.
    if r1 eq 'X'.
      w_objtxt+0(40) = 'Approve Gate entry to send vehicle Inn'.
    elseif r2 eq 'X'.
      if rejem1 eq 1.
        w_objtxt+0(40) = 'Approve rejected Gate entry to send vehicle OUT'.
      elseif accem1 eq 1.
        w_objtxt+0(40) = 'Accepted by Store, : Send vehicle Inn'.
      endif.
    elseif rr eq 'X'.
      w_objtxt+0(40) = 'Rejection is approved by Plant Head to : Send vehicle OUT'.
    endif.
    w_objtxt+41(20) = ename.
    append w_objtxt to objtxt.
    clear w_objtxt.




    condense ltx.
    condense objtxt.
    concatenate 'GATE ENTRY' 'Dated' wa_d1 into doc_chng-obj_descr separated by space.   "SUBJECT

    doc_chng-sensitivty = 'F'.
    doc_chng-doc_size = righe_testo * 255 .

    clear objpack-transf_bin.

    objpack-head_start = 1.
    objpack-head_num = 0.
    objpack-body_start = 1.
    objpack-body_num = 5.
    objpack-doc_type = 'TXT'.
    append objpack.
*  BREAK-POINT.
    loop at it_email into wa_email.
      reclist-receiver =   wa_email-usrid_long.
      reclist-express = 'X'.
      reclist-rec_type = 'U'.
      reclist-notif_del = 'X'. " request delivery notification
      reclist-notif_ndel = 'X'. " request not delivered notification
      append reclist.
      clear reclist.
    endloop.
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
*         COMMIT_WORK                = ' '
* IMPORTING
*         SENT_TO_ALL                =
*         NEW_OBJECT_ID              =
*         SENDER_ID                  =
        tables
          packing_list               = objpack
*         OBJECT_HEADER              =
          contents_bin               = objbin
          contents_txt               = objtxt
*         CONTENTS_HEX               =
*         OBJECT_PARA                =
*         OBJECT_PARB                =
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

        write : / 'EMAIL SENT ON ','id'.
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
  endif.
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
*CLEAR : depthead.
*  SELECT SINGLE * FROM pa0001 WHERE pernr = pernr AND endda GE sy-datum AND plans NE '99999999'..
*  IF sy-subrc EQ 0.
*    SELECT SINGLE * FROM zqms_depthead1 WHERE btrtl EQ pa0001-btrtl AND to_dt GE sy-datum..  "24.7.22
*    IF sy-subrc EQ 0.
*      depthead = zqms_depthead1-pernr.
*    ENDIF.
*  ENDIF.

*  SELECT SINGLE * FROM ZPASSW WHERE PERNR EQ '00007413'.
*  IF SY-SUBRC EQ 0.
*    WA_EMAIL-PERNR = DEPTHEAD.
*    WA_EMAIL-USRID_LONG = ZPASSW-SMTP_ADDR.
*    COLLECT WA_EMAIL INTO IT_EMAIL.
*    CLEAR WA_EMAIL.
*  ENDIF.

*WA_EMAIL-PERNR = DEPTHEAD.
  if werks eq '1000'.
    clear : it_pa0001,wa_pa0001.
    select * from pa0001 into table it_pa0001 where btrtl eq '1222' and endda ge sy-datum and plans ne '99999999'.
    if it_pa0001 is not initial.
      loop at it_pa0001 into wa_pa0001.
        select single * from zpassw where pernr eq wa_pa0001-pernr.
        if sy-subrc eq 0.
          wa_email-usrid_long = zpassw-smtp_addr.
          collect wa_email into it_email.
          clear wa_email.
        endif.
      endloop.
    endif.

  elseif werks eq '1001'.
    clear : it_pa0001,wa_pa0001.
    select * from pa0001 into table it_pa0001 where btrtl eq '1322' and endda ge sy-datum and plans ne '99999999'.
    if it_pa0001 is not initial.
      loop at it_pa0001 into wa_pa0001.
        select single * from zpassw where pernr eq wa_pa0001-pernr.
        if sy-subrc eq 0.
          wa_email-usrid_long = zpassw-smtp_addr.
          collect wa_email into it_email.
          clear wa_email.
        endif.
      endloop.
    endif.

  endif.

endform.
*&---------------------------------------------------------------------*
*&      Form  EMAILREJ
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form emailrej.
  if werks eq '1000'.
    select single * from zqms_depthead1 where btrtl eq '1222' and to_dt ge sy-datum.
    if sy-subrc eq 0.
      select single * from zpassw where pernr eq zqms_depthead1-fappr.
      if sy-subrc eq 0.
        wa_email-usrid_long = zpassw-smtp_addr.
        collect wa_email into it_email.
        clear wa_email.
      endif.
    endif.
    select single * from zqms_depthead1 where btrtl eq '1221' and to_dt ge sy-datum.
    if sy-subrc eq 0.
      select single * from zpassw where pernr eq zqms_depthead1-fappr.
      if sy-subrc eq 0.
        wa_email-usrid_long = zpassw-smtp_addr.
        collect wa_email into it_email.
        clear wa_email.
      endif.
    endif.
  elseif werks eq '1001'.
    select single * from zqms_depthead1 where btrtl eq '1322' and to_dt ge sy-datum.
    if sy-subrc eq 0.
      select single * from zpassw where pernr eq zqms_depthead1-fappr.
      if sy-subrc eq 0.
        wa_email-usrid_long = zpassw-smtp_addr.
        collect wa_email into it_email.
        clear wa_email.
      endif.
    endif.
    select single * from zqms_depthead1 where btrtl eq '1321' and to_dt ge sy-datum.
    if sy-subrc eq 0.
      select single * from zpassw where pernr eq zqms_depthead1-fappr.
      if sy-subrc eq 0.
        wa_email-usrid_long = zpassw-smtp_addr.
        collect wa_email into it_email.
        clear wa_email.
      endif.
    endif.
  endif.

endform.
*&---------------------------------------------------------------------*
*&      Form  EMAILACC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form emailacc.

  if sy-host cs 'SAPQLT' or sy-host cs 'SAPDEV'.
  else.
    if werks eq '1000'.
      wa_email-usrid_long = 'bclgatensk@gmail.com'.
      collect wa_email into it_email.
      clear wa_email.
      select single * from zqms_depthead1 where btrtl eq '1221' and to_dt ge sy-datum.
      if sy-subrc eq 0.
        select single * from zpassw where pernr eq zqms_depthead1-fappr.
        if sy-subrc eq 0.
          wa_email-usrid_long = zpassw-smtp_addr.
          collect wa_email into it_email.
          clear wa_email.
        endif.
      endif.
    elseif werks eq '1001'.
      wa_email-usrid_long = 'bclgategoa@gmail.com'.
      collect wa_email into it_email.
      clear wa_email.
      select single * from zqms_depthead1 where btrtl eq '1321' and to_dt ge sy-datum.
      if sy-subrc eq 0.
        select single * from zpassw where pernr eq zqms_depthead1-fappr.
        if sy-subrc eq 0.
          wa_email-usrid_long = zpassw-smtp_addr.
          collect wa_email into it_email.
          clear wa_email.
        endif.
      endif.
    endif.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  DEPTCHK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form deptchk .
  if r2 eq 'X'.
    if werks eq '1000'.
      if sy-uname eq 'MMINVNSK02' or sy-uname eq 'BCLLDEVP1'.
      else.
        select single * from pa0001 where pernr eq pernr and btrtl eq '1222'.
        if sy-subrc eq 4.
          message 'INVALID APPROVER' type 'I'.
          leave to screen 0.
        endif.
      endif.
    elseif werks eq '1001'.
      select single * from pa0001 where pernr eq pernr and btrtl eq '1322'.
      if sy-subrc eq 4.
        message 'INVALID APPROVER' type 'I'.
        leave to screen 0.
      endif.
    endif.
  elseif rr eq 'X'.
    if werks eq '1000'.
      select single * from zqms_depthead1 where btrtl eq '1222' and fappr eq pernr.
      if sy-subrc eq 4.
        message 'INVALID APPROVER' type 'I'.
        leave to screen 0.
      endif.
    elseif werks eq '1001'.
      select single * from zqms_depthead1 where btrtl eq '1322' and fappr eq pernr.
      if sy-subrc eq 4.
        message 'INVALID APPROVER' type 'I'.
        leave to screen 0.
      endif.

    endif.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  CHKGATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form chkgate .
  if sy-uname ne 'ITBOM01' or sy-uname eq 'BCLLDEVP1'.
  else.
    if plant1 eq '1000'.
      if sy-uname ne 'GATENSK01'.
        message 'ENTRY ONLY FOR SECURITY GATE' type 'I'.
        leave to screen 0.
      endif.
    elseif plant1 eq '1001' or plant1 eq '2024'.
      if sy-uname ne 'GATEGOA01'.
        message 'ENTRY ONLY FOR SECURITY GATE' type 'I'.
        leave to screen 0.
      endif.
    endif.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  FORM3O
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form form3o .



*  BREAK-POINT .
  select * from zpo_gate into table it_zpo_gate where werks eq werks and cpudt in budat and scpudt gt 0 and gocpudt le 0 and del eq space.
  if sy-subrc eq 0.
    select * from ekpo into table it_ekpo for all entries in it_zpo_gate where ebeln eq it_zpo_gate-ebeln and werks eq werks and ebeln in ord.
    if sy-subrc eq 0.
      select * from ekko into table it_ekko for all entries in it_ekpo where ebeln eq it_ekpo-ebeln.
    endif.
  endif.
  if it_ekpo is initial.
    message 'NO DATA FOUND' type 'I'.
    leave to screen 0.
  endif.
  clear : rej1.
  loop at it_zpo_gate into wa_zpo_gate.
    read table it_ekko into wa_ekko with key ebeln = wa_zpo_gate-ebeln.
    if sy-subrc eq 0.
      read table it_ekpo into wa_ekpo with key ebeln = wa_zpo_gate-ebeln.
      if sy-subrc eq 0.
        clear : allw1.
        if wa_zpo_gate-gcpudt gt 0.
          allw1 = 1.
        endif.
        if wa_zpo_gate-gcpudt le 0 and wa_zpo_gate-rejpernr gt 0.
          allw1 = 1.
        endif.
        if allw1 eq 1.

          if wa_zpo_gate-stry eq 'X'.
            wa_disp1-strstatus = 'ACCEPTED'.
          elseif wa_zpo_gate-strn eq 'X'.
            wa_disp1-strstatus = 'REJECTED'.
          endif.

          wa_disp1-vbeln = wa_zpo_gate-vbeln.
          wa_disp1-mjahr = wa_zpo_gate-mjahr.
          wa_disp1-werks = wa_zpo_gate-werks.
          wa_disp1-num = wa_zpo_gate-num.
          wa_disp1-ebeln = wa_zpo_gate-ebeln.
          wa_disp1-aedat = wa_ekko-aedat.
          select single * from lfa1 where lifnr eq wa_ekko-lifnr.
          if sy-subrc eq 0.
            select single * from adrc where addrnumber eq lfa1-adrnr.
            if sy-subrc eq 0.
              wa_disp1-name1 = adrc-name1.
            endif.
            wa_disp1-ort01 = lfa1-ort01.
          endif.

          wa_disp1-xblnr = wa_zpo_gate-xblnr.
          wa_disp1-bldat = wa_zpo_gate-bldat.
          wa_disp1-vehno = wa_zpo_gate-vehno.
          wa_disp1-transporter = wa_zpo_gate-transporter.
          wa_disp1-remark = wa_zpo_gate-remark.

          wa_disp1-cpudt = wa_zpo_gate-cpudt.
          wa_disp1-cputm = wa_zpo_gate-cputm.
          wa_disp1-usnam = wa_zpo_gate-usnam.

          wa_disp1-strtxt = wa_zpo_gate-strtxt.
          select single * from pa0001 where pernr eq wa_zpo_gate-spernr and endda ge sy-datum.
          if sy-subrc eq 0.
            wa_disp1-sname = pa0001-ename.
          endif.

          wa_disp1-scpudt = wa_zpo_gate-scpudt.
          wa_disp1-scputm = wa_zpo_gate-scputm.

          if wa_zpo_gate-rejpernr gt 0.
            rej1 = 1.
            select single * from pa0001 where pernr eq wa_zpo_gate-rejpernr and endda ge sy-datum.
            if sy-subrc eq 0.
              wa_disp1-rejname = pa0001-ename.
            endif.
            wa_disp1-rejcpudt = wa_zpo_gate-rejcpudt.
            wa_disp1-rejcputm = wa_zpo_gate-rejcputm.
          endif.

          collect wa_disp1 into it_disp1.
          clear wa_disp1.
        endif.
      endif.
    endif.
  endloop.

*  *  WA_FIELDCAT-FIELDNAME = 'WERKS'.
*  WA_FIELDCAT-SELTEXT_L = 'PLANT'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.
*
**  WA_FIELDCAT-FIELDNAME = 'VBELN'.
**  WA_FIELDCAT-SELTEXT_L = 'GATE ENTRY SEQ'.
**  APPEND WA_FIELDCAT TO FIELDCAT.
**  CLEAR WA_FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'MJAHR'.
*  WA_FIELDCAT-SELTEXT_L = 'YEAR'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.

  wa_fieldcat-fieldname = 'NUM'.
  wa_fieldcat-seltext_l = 'GATE ENTRY NO.'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

*  WA_FIELDCAT-FIELDNAME = 'GIN'.
*  WA_FIELDCAT-SELTEXT_L = 'VEHICLE IN'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-CHECKBOX = 'X'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.

  wa_fieldcat-fieldname = 'GOUT'.
  wa_fieldcat-seltext_l = 'VEHICLE OUT'.
  wa_fieldcat-edit = 'X'.
  wa_fieldcat-checkbox = 'X'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'STRSTATUS'.
  wa_fieldcat-seltext_l = 'STORE STATUS'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-CHECKBOX = 'X'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'STRTXT'.
  wa_fieldcat-seltext_l = 'STORE REMARK'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-OUTPUTLEN = 50.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'SNAME'.
  wa_fieldcat-seltext_l = 'STORE ENTRY BY'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-OUTPUTLEN = 50.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'SCPUDT'.
  wa_fieldcat-seltext_l = 'STORE ENTRY DATE'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-OUTPUTLEN = 50.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'SCPUTM'.
  wa_fieldcat-seltext_l = 'STORE ENTRY TIME'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-OUTPUTLEN = 50.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  if rej1 eq 1.
    wa_fieldcat-fieldname = 'REJNAME'.
    wa_fieldcat-seltext_l = 'REJECTION APPROVED BY'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-OUTPUTLEN = 50.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.


    wa_fieldcat-fieldname = 'RECPUDT'.
    wa_fieldcat-seltext_l = 'REJECTION APPROVED DATE'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-OUTPUTLEN = 50.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

    wa_fieldcat-fieldname = 'RECPUTM'.
    wa_fieldcat-seltext_l = 'REJECTION APPROVED TIME'.
*  WA_FIELDCAT-EDIT = 'X'.
*  WA_FIELDCAT-OUTPUTLEN = 50.
    append wa_fieldcat to fieldcat.
    clear wa_fieldcat.

  endif.

  wa_fieldcat-fieldname = 'EBELN'.
  wa_fieldcat-seltext_l = 'PO NO.'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'AEDAT'.
  wa_fieldcat-seltext_l = 'PO DATE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'NAME1'.
  wa_fieldcat-seltext_l = 'PO VENDOR NAME'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'ORT01'.
  wa_fieldcat-seltext_l = 'PO VENDOR PLACE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'XBLNR'.
  wa_fieldcat-seltext_l = 'BILL/CHALLAN NO.'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'BLDAT'.
  wa_fieldcat-seltext_l = 'BILL/CHALLAN DATE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'VEHNO'.
  wa_fieldcat-seltext_l = 'VEHICLE NO.'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'TRANSPORTER'.
  wa_fieldcat-seltext_l = 'TRANSPORTER NAME'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'REMARK'.
  wa_fieldcat-seltext_l = 'REMARK BY SECURITY GATE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'CPUDT'.
  wa_fieldcat-seltext_l = 'GATE ENTRY DATE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'CPUTM'.
  wa_fieldcat-seltext_l = 'GATE ENTRY TIME'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.
*
  wa_fieldcat-fieldname = 'USNAM'.
  wa_fieldcat-seltext_l = 'GATE ENTRY LOGIN'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.


**  append wa_fieldcat to fieldcat.
*
*  L_GLAY-EDT_CLL_CB = 'X'.
*
**  ls_layout-colwidth_optimize = 'X'.
*
*
*  WA_FIELDCAT-FIELDNAME = 'CHK'.
*  WA_FIELDCAT-SELTEXT_L = 'SELECT'.
*  WA_FIELDCAT-CHECKBOX = 'X'.
*  WA_FIELDCAT-EDIT = 'X'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.



  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'GATE CONFIRMATION TO SEND VEHICLE OUT.'.


  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = g_repid
*     I_CALLBACK_PF_STATUS_SET          = 'STATUS'
      i_callback_user_command = 'USER_COMM'
      i_callback_top_of_page  = 'TOP'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         = L_GLAY
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
      t_outtab                = it_disp1
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.
  clear : fieldcat,layout.

endform.
*&---------------------------------------------------------------------*
*&      Form  GATECONFO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form gateconfo .
*BREAK-POINT .
*  CLEAR : E1,A1.
  loop at it_disp1 into wa_disp1 where gout eq 'X'.
    clear : e1.
    select single * from zpo_gate where vbeln eq wa_disp1-vbeln and mjahr eq wa_disp1-mjahr and werks eq wa_disp1-werks and scpudt gt 0.
    if sy-subrc eq 0.
*      IF ZPO_GATE-STRY EQ 'X' AND WA_DISP1-GOUT EQ 'X'.
*        E1 = 1.
*        MESSAGE 'CONFIRM TO SEND VEHICLE INSIDE PLANT' TYPE 'I'.
**        LEAVE TO SCREEN 0.
*      ENDIF.
*      IF ZPO_GATE-STRN EQ 'X' AND WA_DISP1-GIN EQ 'X'.
*        E1 = 1.
*        MESSAGE 'CONFIRM TO SEND VEHICLE OUTSIDE PLANT' TYPE 'I'.
**        LEAVE TO SCREEN 0.
*      ENDIF.
*      IF ZPO_GATE-STRN EQ 'X' AND WA_DISP1-REJNAME EQ SPACE.
*        E1 = 1.
*        MESSAGE 'REJECTION IS NOT YET APPROVED' TYPE 'I'.
**        LEAVE TO SCREEN 0.
*      ENDIF.
      if wa_disp1-gout eq space.
        e1 = 1.
        message 'Select VEHICLE OUT' type 'I'.
*        LEAVE TO SCREEN 0.
      endif.


      if e1 ne 1.
        move-corresponding zpo_gate to zpo_gate_wa.
*        ZPO_GATE_WA-GIN = WA_DISP1-GIN.
        zpo_gate_wa-gout = wa_disp1-gout.
        zpo_gate_wa-gocpudt = sy-datum.
        zpo_gate_wa-gocputm = sy-uzeit.
        zpo_gate_wa-gousnam = sy-uname.
        modify  zpo_gate from  zpo_gate_wa.
        commit work and wait .
        clear  zpo_gate_wa.
        a1 = 1.
      endif.
    endif.
  endloop.

  if a1 eq 1.
    message 'Data saved for VEHICLE OUT' type 'I'.
  endif.

  leave to screen 0.
endform.
*&---------------------------------------------------------------------*
*&      Form  POREL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form porel .
  select single * from ekko where ebeln eq po and frgke eq '0'.
  if sy-subrc eq 0.
    message 'PO IS NOT RELEASED' type 'E'.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  DELFLAG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form delflag .
  clear : del1.
  select single * from zpo_gate where num eq gentry and stry eq space and del eq space.
  if sy-subrc eq 0.
    move-corresponding zpo_gate to zpo_gate_wa.
    zpo_gate_wa-deltxt = deltxt.
    zpo_gate_wa-del = 'X'.
    zpo_gate_wa-deldt = sy-datum.
    zpo_gate_wa-deltm = sy-uzeit.
    zpo_gate_wa-delusnam = sy-uname.
    zpo_gate_wa-delpernr = pernr.
    modify zpo_gate from zpo_gate_wa.
    clear zpo_gate_wa.
    del1 = 1.
  endif.
  if del1 eq 1.
    message 'ENTRY IS MARKED FOR DELETION' type 'I'.
  endif.
  leave program.
endform.
*&---------------------------------------------------------------------*
*&      Form  DEPTCHK1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form deptchk1 .
  if r5 eq 'X'.
    if sy-uname eq 'ITBOM01' or sy-uname eq 'BCLLDEVP1'.

    else.
      if werks eq '1000'.
        select single * from pa0001 where pernr eq pernr and btrtl eq '1202'.
        if sy-subrc eq 4.
          message 'INVALID APPROVER' type 'I'.
          leave to screen 0.
        endif.
      elseif werks eq '1001'.
        select single * from pa0001 where pernr eq pernr and btrtl eq '1316'.
        if sy-subrc eq 4.
          message 'INVALID APPROVER' type 'I'.
          leave to screen 0.
        endif.
      endif.
    endif.
  endif.
endform.
