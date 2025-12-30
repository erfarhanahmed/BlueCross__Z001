*& Report  YR_SD_CHECK_LIST_BCL
**---------------------------------------------------------------------------*
**         Report Name    :  YR_SD_CHECK_LIST_BCL                             *
*-----------------------------------------------------------------------------*
**         Objective      :  To FIND                                          *
*                                 Territories without position                *
*                                 Field staff with no territery               *
*                                 No territories allocation                   *
*                                 field hierarchy not maintained              *
*                                 customer should be 100 %                    *
*                                 position/territory without target           *
*                                 Mismatch of Division                        *
*                                                                             *
*------------------------------------------------------------------------------*
*          Date Created   :  09.03.2011                                       *
*          Author         :  ANUBU THAMBI JAYARAM                             *
*          Request-Id     :  BCDK908431                                       *
*---------------------------------------------------------------------------*
report  yr_sd_check_list_bcl1.


***alv Declaration
type-pools: slis.

tables : hrp1000.

data: alv_fldcat type slis_t_fieldcat_alv,
        wa_fld like line of alv_fldcat,
        alv_layout type  slis_layout_alv,
        wa_repid like sy-repid value sy-repid.


****part1 declaration starts
data : itab_sd_spro type table of t171.
data : wa_sd_spro type t171.

data : itab_sd_yterrallc type table of yterrallc.
data : wa_sd_yterrallc type yterrallc.

***ADDED BY SATHISH.B TO GET THE TERRITORIES ALLOCATED TO A CUSTOMER
DATA: ITAB_CUSTOMER TYPE TABLE OF YSD_CUS_DIV_DIS,
      WA_CUSTOMER TYPE YSD_CUS_DIV_DIS,
      IT_HRP1000 TYPE TABLE OF HRP1000,
      WA_HRP1000 TYPE HRP1000.
***ADDED BY SATHISH.B TO GET THE TERRITORIES ALLOCATED TO A CUSTOMER
data : itab_final type table of t171t.
data : wa_final type t171t.

data : itab_sdt_spro type table of t171t.
data : wa_sdt_spro type t171t.
****part1 declaration ends


*** part2 declarion starts
types: begin of typ_hrp1001,
       otype type otype,
       objid type hrobjid,
       plvar type plvar,
       rsign type rsign,
       relat type relat,
       istat type istat_d,
       priox type priox,
       begda type begdatum,
       endda type enddatum,
       varyf type varyf,
       seqnr type seqnr,
       sclas type sclas,
       sobid type objid,"SOBID,
       end of typ_hrp1001.

types: begin of typ_sobid,
       objid type hrobjid,
       end of typ_sobid.


data: itab_hrp1001 type table of typ_hrp1001.
data: wa_hrp1001 type typ_hrp1001.

data: itab_hrp1001f type table of typ_hrp1001.
data: wa_hrp1001f type typ_hrp1001.

data: itab_sobid type table of typ_sobid with header line.
*      WA_SOBID TYPE TYP_SOBID.

data : it_yterrallc type table of yterrallc.
data : wa_yterrallc type yterrallc.

data : itab_emp type table of typ_hrp1001 with header line.

types: begin of typ_hrp1000,
       plvar type plvar,
       otype type otype,
       objid type hrobjid,
       istat type istat_d,
       begda type begdatum,
       endda type enddatum,
       langu type langu,
       seqnr type seqnr,
       short type short_d,
       mc_stext type hr_mcstext,
       end of typ_hrp1000.
data : itab_pos_nam type table of typ_hrp1000.

field-symbols: <fs_hrp1000> type typ_hrp1000,
               <fs_hrp1001> type typ_hrp1001.
 data: wa_off type i.

types: begin of typ_pernr,
       pernr type persno,
       end of typ_pernr.

data: itab_pernr type table of typ_pernr,
             wa_pernr type typ_pernr.

types: begin of typ_pa0002.
include type pakey.
types: nachn type pad_nachn,
       vorna type pad_vorna,
       end of typ_pa0002.
data : itab_pa0002 type table of typ_pa0002 with header line.

types: begin of typ_final,
       objid type hrobjid,
       pernr type persno,
       name(80) type c,
       hq(12) type c,
       end of typ_final.

data : itab_fin type table of typ_final with header line.
*** part2 declarion starts

*** part3 declarion starts
types: begin of typ_vbrk_vbrp,
       vbeln type vbeln_vf,
       fkdat type fkdat,
       kunrg type kunrg,
       spart_i type spart,
       end of typ_vbrk_vbrp.

data: itab_vbrk_vbrp type table of typ_vbrk_vbrp,
      wa_vbrk_vbrp type typ_vbrk_vbrp.

data : itab_100c type table of ysd_cus_div_dis,
       wa_100c type ysd_cus_div_dis.

types : begin of typ_fic,
        kunnr type kna1-kunnr,
       end of typ_fic.

data : itab_c type table of typ_fic,
       wa_c type typ_fic.
*** part3 declarion ends


****part4 declaration starts
data : itab_h type table of zthr_hierarchy.
DATA: IT_CHECK TYPE TABLE OF ZTHR_HIERARCHY,
      WA_CHECK TYPE ZTHR_HIERARCHY.
data : wa_h type zthr_hierarchy.

data : month(2).
data : year(4).

types: begin of typ_final1,
       objid type hrobjid,
       pernr type persno,
       REPPOSITION1 TYPE HROBJID,
       name(80) type c,
       hq(12) type c,
       end of typ_final1.

data : itab_hy type table of typ_final1 with header line.

types: begin of typ_pa0002n.
include type pakey.
types: nachn type pad_nachn,
       vorna type pad_vorna,
       end of typ_pa0002n.
data : itab_pa0002n type table of typ_pa0002n with header line.

****part4 declaration ends


****part5 declaration starts
data : itab_kna1 type table of kna1.
data : wa_kna1 type kna1.

data : itab_100p type table of ysd_cus_div_dis.
data : wa_100p type ysd_cus_div_dis.

data : itab_100t type table of ysd_cus_div_dis.
data : wa_100t type ysd_cus_div_dis.

types : begin of typ_c,
        kunnr type kna1-kunnr,
        spart type ysd_cus_div_dis-spart,
        percnt type ysd_cus_div_dis-percnt,
       end of typ_c.
data : itab_100pc type table of typ_c.
data : wa_100pc type typ_c.


types : begin of typ_fi,
        kunnr type kna1-kunnr,
        name1 type kna1-name1,
        spart type ysd_cus_div_dis-spart,
        bzirk type ysd_cus_div_dis-bzirk,
        percnt type ysd_cus_div_dis-percnt,
       end of typ_fi.

data : itab_fcus type table of typ_fi.
data : wa_fcus type typ_fi.
****part5 declaration ends

*--PART6  DECLARATION POSITION / TERITORY WITHOUT TARGET
    types : begin of ty_targ.
      include structure ysd_dist_targt.
    types : end of   ty_targ.

    types : begin of ty_t171.
       include structure t171.
    types : end of ty_t171.

    data  : it_targ   type table of ty_targ,
            it_t171   type table of ty_t171,
            it_wotarg type table of ty_t171,
            it_custom type table of ysd_cus_div_dis,
            wa_custom type ysd_cus_div_dis,
            wa_targ   type ty_targ,
            wa_t171   type ty_t171,
            wa_wotarg type ty_t171.

*--PART6  DECLARATION ENDS POSITION / TERITORY WITHOUT TARGET
*--part7--Declaration mismatch of division---------------------*
types : begin of ty_kna1.
        include structure kna1.
types : end of ty_kna1.
types : begin of ty_knvv.
        include structure knvv.
types : end of ty_knvv.
types : begin of ty_cusdiv.
  include structure ysd_cus_div_dis.
types : end of   ty_cusdiv.
types : begin of ty_talloc.
  include structure yterrallc.
types : end of  ty_talloc.
types : begin of ty_mmatch,
  kunnr type kna1-kunnr,
  name1 type kna1-name1,
  spart type knvv-spart,
  bzirk type knvv-bzirk,
  plans type yterrallc-plans,
  end of ty_mmatch.

data : it_kna1    type table of ty_kna1,
       it_knvv    type table of ty_knvv,
       it_cusdiv  type table of ty_cusdiv,
       it_cust    type table of ty_cusdiv,
       it_talloc  type table of ty_talloc,
       it_mmatch   type table of ty_mmatch,
       it_mmatch_f type table of ty_mmatch,
       it_mmatch_fi type table of ty_mmatch,
       wa_kna     type  ty_kna1,
       wa_knvv    type  ty_knvv,
       wa_cusdiv  type  ty_cusdiv,
       wa_cust    type  ty_cusdiv,
       wa_talloc  type  ty_talloc,
       wa_mmatch type   ty_mmatch,
       wa_mmatch_f type   ty_mmatch,
       wa_mmatch_fi type   ty_mmatch..

data : flag_50 type c,
       flag_60 type c.

*--part7--Declaration ends mismatch of division----------------*
data : v_bldat type bseg-bzdat.

selection-screen begin of block a1 with frame.
select-options : s_fkdat for v_bldat obligatory default sy-datum.
selection-screen end of block a1.

selection-screen begin of block b1 with frame.
  parameters: p1 radiobutton group g1, "List of Territories without any position
              p2 radiobutton group g1, "Field staff with no territorie
              p3 radiobutton group g1, "No territories allocation done
              p4 radiobutton group g1, "Field hierarchy not maintained
              p5 radiobutton group g1, "Customer should be 100 %
              p6 radiobutton group g1, "Position/territory without target
              p7 radiobutton group g1. "Mismatch of Division
selection-screen end of block b1.




start-of-selection.

**part1
if p1 = 'X'. "List of Territories without any position
    perform solution1.
    perform alv_output1.

elseif p2 = 'X'. "Field staff with no territorie
    perform solution2.
    perform alv_output2.

elseif p3 = 'X'. "Customer have done the sale but no territories allocation done.
    perform solution3.
    perform alv_output3.

elseif p4 = 'X'. "Field hierarchy not maintained
    perform solution4.
    perform alv_output4.

elseif p5 = 'X'. "Customer should be 100 %
    perform solution5.
    perform alv_output5.

elseif p6 = 'X'. "Position/territory without taret
    perform solution6.
    perform alv_output6.
elseif p7 = 'X'. "Mismatch of Division
    perform solution7.
    perform alv_output7.
endif.





*&---------------------------------------------------------------------*
*&      Form  ALV_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form alv_output1.

clear :wa_fld,alv_layout.
clear : alv_fldcat, alv_fldcat[].

  wa_fld-fieldname = 'BZIRK'.
  wa_fld-seltext_l = 'Sales District'.
  append wa_fld to alv_fldcat.

  wa_fld-fieldname = 'BZTXT'.
  wa_fld-seltext_l = 'Description'.
  append wa_fld to alv_fldcat.

  alv_layout-window_titlebar = 'List of Territories without any position'.
  alv_layout-colwidth_optimize = 'X'.
  alv_layout-zebra = 'X'.

  call function 'REUSE_ALV_GRID_DISPLAY'
   exporting
     i_callback_program                = wa_repid
*     I_CALLBACK_USER_COMMAND           = 'USER_COMMAND'
*     I_CALLBACK_TOP_OF_PAGE            = 'TOP_OF_LIST'
     is_layout                         =  alv_layout
     it_fieldcat                       = alv_fldcat
     i_default                         = 'X'
     i_save                            = 'A'
*     IT_EVENTS                         = IT_EVENTS
    tables
      t_outtab                          = itab_final
   exceptions
     program_error                     = 1
     others                            = 2
            .
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.
endform.                    " ALV_OUTPUT


*&---------------------------------------------------------------------*
*&      Form  SOLUTION1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form solution1 .

 select * from t171 into corresponding fields of table itab_sd_spro.

***COMMENTED BY SATHISH.B TO GET THE SALES DISTRICT BASED ON CUSTOMERS
*  select * from yterrallc into corresponding fields of table itab_sd_yterrallc.
***COMMENTED BY SATHISH.B TO GET THE SALES DISTRICT BASED ON CUSTOMERS

  select * from t171t into corresponding fields of table itab_sdt_spro.

   IF itab_sd_spro IS NOT INITIAL.
     SELECT * FROM YSD_CUS_DIV_DIS INTO TABLE itab_customer FOR ALL
       ENTRIES IN itab_sd_spro WHERE BZIRK = ITAB_SD_SPRO-BZIRK.
     ENDIF.

     IF ITAB_CUSTOMER IS NOT INITIAL.
       select * from yterrallc into corresponding fields of table itab_sd_yterrallc
          FOR ALL ENTRIES IN ITAB_CUSTOMER WHERE BZIRK = ITAB_CUSTOMER-BZIRK.
       ENDIF.

  loop at itab_sd_spro into wa_sd_spro.
    READ TABLE ITAB_CUSTOMER INTO WA_CUSTOMER WITH KEY BZIRK = WA_SD_SPRO-BZIRK.
    IF SY-SUBRC = 0.
      read table itab_sd_yterrallc into wa_sd_yterrallc with key bzirk = wa_sd_spro-bzirk.
        if sy-subrc ne 0.
            move : wa_sd_spro-bzirk to wa_final-bzirk.
                 read table itab_sdt_spro into wa_sdt_spro with key bzirk = wa_final-bzirk.
                    if sy-subrc = 0.
                       move : wa_sdt_spro-bztxt to wa_final-bztxt.
                    endif.
      append wa_final to itab_final.
      endif.
      ENDIF.
   clear : wa_sd_spro,wa_sd_yterrallc,wa_sdt_spro,wa_final.
  endloop.

 sort itab_final by bzirk.
 delete adjacent duplicates from itab_final comparing all fields.
endform.                    " SOLUTION1



*&---------------------------------------------------------------------*
*&      Form  SOLUTION5
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form solution5.

*select kunnr name1 from kna1 into corresponding fields of table itab_kna1.

*select * from ysd_cus_div_dis into table itab_100p for all entries in itab_kna1
*      where kunnr eq itab_kna1-kunnr and spart in ('50','60') and endda ge s_fkdat-high and begda le s_fkdat-low.
select * from ysd_cus_div_dis into table itab_100p
      where spart in ('50','60') and endda ge s_fkdat-high and begda le s_fkdat-low.
sort itab_100p by kunnr spart.

if itab_100p is not initial.
  select kunnr name1 from kna1 into corresponding fields of table itab_kna1 for all entries
    in itab_100p where kunnr = itab_100p-kunnr.
  endif.

itab_100t[] = itab_100p[].

loop at itab_100p into wa_100p.
  move-corresponding wa_100p to wa_100pc.
  collect wa_100pc into itab_100pc.
  clear :wa_100p.
endloop.

delete itab_100pc where percnt eq '100'.
sort itab_100pc by kunnr spart.


loop at itab_100p into wa_100p.
  read table itab_100pc into wa_100pc with key kunnr = wa_100p-kunnr spart = wa_100p-spart.
    if sy-subrc ne 0.
      delete itab_100p.
    else.

    endif.
endloop.

loop at itab_100p into wa_100p.
  move-corresponding wa_100p to wa_fcus.
  read table itab_kna1 into wa_kna1 with key kunnr = wa_100p-kunnr.
    if sy-subrc = 0.
      move wa_kna1-name1 to wa_fcus-name1.
    endif.
  append wa_fcus to itab_fcus.

  clear : wa_100p, wa_fcus, wa_kna1.
endloop.

loop at itab_kna1 into wa_kna1.
  read table itab_100t into wa_100t with key kunnr = wa_kna1-kunnr.
   if sy-subrc = 0.
      delete itab_kna1.
   endif.
clear : wa_kna1,wa_100t.
endloop.

loop at itab_kna1 into wa_kna1.
     move : wa_kna1-kunnr to wa_fcus-kunnr,
            wa_kna1-name1 to wa_fcus-name1.
     append  wa_fcus to itab_fcus.
clear :  wa_kna1, wa_fcus.
endloop.

endform.                    " SOLUTION5


*&---------------------------------------------------------------------*
*&      Form  ALV_OUTPUT5
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form alv_output5.

clear :wa_fld,alv_layout.
clear : alv_fldcat, alv_fldcat[].

  wa_fld-fieldname = 'KUNNR'.
  wa_fld-seltext_l = 'Customer Code'.
  append wa_fld to alv_fldcat.

  wa_fld-fieldname = 'NAME1'.
  wa_fld-seltext_l = 'Customer Name'.
  append wa_fld to alv_fldcat.

  wa_fld-fieldname = 'SPART'.
  wa_fld-seltext_l = 'Division'.
  append wa_fld to alv_fldcat.

  wa_fld-fieldname = 'BZIRK'.
  wa_fld-seltext_l = 'District'.
  append wa_fld to alv_fldcat.

  wa_fld-fieldname = 'PERCNT'.
  wa_fld-seltext_l = 'Percentage'.
  append wa_fld to alv_fldcat.

  alv_layout-window_titlebar = 'Total allocation for the Customer should be 100 % not more and not less'.
  alv_layout-colwidth_optimize = 'X'.
  alv_layout-zebra = 'X'.

  call function 'REUSE_ALV_GRID_DISPLAY'
   exporting
     i_callback_program                = wa_repid
*     I_CALLBACK_USER_COMMAND           = 'USER_COMMAND'
*     I_CALLBACK_TOP_OF_PAGE            = 'TOP_OF_LIST'
     is_layout                         =  alv_layout
     it_fieldcat                       = alv_fldcat
     i_default                         = 'X'
     i_save                            = 'A'
*     IT_EVENTS                         = IT_EVENTS
    tables
      t_outtab                          = itab_fcus
   exceptions
     program_error                     = 1
     others                            = 2
            .
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.
endform.                    " ALV_OUTPUT5



*&---------------------------------------------------------------------*
*&      Form  SOLUTION2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form solution2 .

***1ST level HIERARCHY
  select otype objid plvar rsign relat istat priox begda endda varyf seqnr sclas sobid
    from hrp1001 into table itab_hrp1001 where otype = 'O'
    and objid = '50000007' and rsign = 'B' and relat = '002'.

itab_hrp1001f[] = itab_hrp1001[].
clear : itab_hrp1001.
clear : itab_sobid,itab_sobid[].
delete itab_hrp1001f where sclas ne 'O'.

loop at itab_hrp1001f into wa_hrp1001f .
  move : wa_hrp1001f-sobid to itab_sobid.
  append itab_sobid.
  clear : wa_hrp1001f,itab_sobid.
endloop.
clear : itab_hrp1001f,wa_hrp1001f.


***2nd level TIME HIERARCHY
if itab_sobid[] is not initial.
  select otype objid plvar rsign relat istat priox begda endda varyf seqnr sclas sobid
    from hrp1001 into table itab_hrp1001 for all entries in itab_sobid
    where otype = 'O' and objid eq itab_sobid-objid. " AND BEGDA LE P_WA_DATE1 AND ENDDA GE P_WA_DATE2.
endif.

itab_hrp1001f[] = itab_hrp1001[].
clear : itab_hrp1001.
clear : itab_sobid,itab_sobid[].
delete itab_hrp1001f where sclas ne 'O'.

loop at itab_hrp1001f into wa_hrp1001f .
  move : wa_hrp1001f-sobid to itab_sobid.
  append itab_sobid.
  clear : wa_hrp1001f,itab_sobid.
endloop.
clear : itab_hrp1001f,wa_hrp1001f.


***3RD level TIME HIERARCHY
if itab_sobid[] is not initial.
  select otype objid plvar rsign relat istat priox begda endda varyf seqnr sclas sobid
    from hrp1001 into table itab_hrp1001 for all entries in itab_sobid
    where otype = 'O' and  objid = itab_sobid-objid. " AND BEGDA LE P_WA_DATE1 AND ENDDA GE P_WA_DATE2.
endif.

itab_hrp1001f[] = itab_hrp1001[].
clear : itab_hrp1001.
clear : itab_sobid,itab_sobid[].
delete itab_hrp1001f where sclas eq 'O'.

loop at itab_hrp1001f into wa_hrp1001f .
  move : wa_hrp1001f-sobid to itab_sobid.
  append itab_sobid.
  clear : wa_hrp1001f,itab_sobid.
endloop.

sort itab_sobid by objid.


select * from yterrallc into corresponding fields of table it_yterrallc where
   endda ge s_fkdat-high and begda le s_fkdat-low..

loop at itab_sobid.
  read table it_yterrallc into wa_yterrallc with key plans = itab_sobid-objid.
    if sy-subrc eq 0.
      delete itab_sobid.
    endif.
endloop.

if itab_sobid is not initial.
*    For the position, get the employee
    select otype objid plvar rsign relat istat priox begda endda varyf seqnr sclas sobid
      from hrp1001 into table itab_emp for all entries in itab_sobid where otype = 'S'
      and objid = itab_sobid-objid and plvar = '01' and rsign = 'A' and relat = '008' and
      begda le s_fkdat-high and endda ge s_fkdat-high.

*    Get the position description
    select plvar otype objid istat begda endda langu seqnr short mc_stext from hrp1000 into table
      itab_pos_nam for all entries in itab_sobid where plvar = '01' and otype = 'S' and
      objid = itab_sobid-objid and istat = '1' and begda le s_fkdat-high and endda ge
      s_fkdat-high and langu = sy-langu.
  endif.


*  if itab_emp is not initial.
    loop at itab_emp assigning <fs_hrp1001>.
      wa_pernr-pernr = <fs_hrp1001>-sobid.
      append wa_pernr to itab_pernr.
      clear wa_pernr.
    endloop.

    sort itab_pernr by pernr.
    delete adjacent duplicates from itab_pernr.

    if itab_pernr is not initial.
*      Get the employee name
      select pernr subty objps sprps endda begda seqnr nachn vorna from pa0002 into
        table itab_pa0002 for all entries in itab_pernr where pernr = itab_pernr-pernr
        and subty = ' ' and objps = ' ' and sprps = ' ' and endda ge s_fkdat-high and
        begda le s_fkdat-high and seqnr = ' '.
    endif.
*  endif.



sort itab_sobid by objid.
delete adjacent duplicates from itab_sobid comparing objid.

loop at itab_sobid.
 read table itab_emp with key objid = itab_sobid-objid.
   if sy-subrc = 0.
     move : itab_sobid-objid to itab_fin-objid,
             itab_emp-sobid to  itab_fin-pernr.
         read table itab_pa0002 with key pernr = itab_fin-pernr.
           if sy-subrc = 0.
             concatenate itab_pa0002-vorna ' ' itab_pa0002-nachn into itab_fin-name.
           endif.

  read table itab_pos_nam assigning <fs_hrp1000> with key objid = itab_sobid-objid.
  if sy-subrc = 0.
    find '-' in <fs_hrp1000>-mc_stext match offset wa_off.
    if sy-subrc = 0.
      wa_off = wa_off + 1.
      itab_fin-hq = <fs_hrp1000>-mc_stext+wa_off.
****      added by anbu 28.01.11 ver 1.1 starts
      condense  itab_fin-hq.
****      added by anbu 28.01.11 ver 1.1 starts
    endif.
   endif.
  endif.

append itab_fin.

clear : itab_pa0002, itab_emp, itab_sobid,  itab_fin.
endloop.

delete itab_fin where objid is initial.

IF ITAB_FIN[] IS NOT INITIAL.
  SELECT * FROM HRP1000 INTO TABLE IT_HRP1000 FOR ALL ENTRIES IN
     ITAB_FIN WHERE OTYPE = 'S' AND OBJID = ITAB_FIN-OBJID.
  ENDIF.

  SORT IT_HRP1000 BY OBJID.
  DELETE ADJACENT DUPLICATES FROM IT_HRP1000 COMPARING OBJID.

  LOOP AT ITAB_FIN.
    READ TABLE IT_HRP1000 INTO WA_HRP1000 WITH KEY OBJID = ITAB_FIN-OBJID
                                                   SHORT = 'ZM'.
        IF SY-SUBRC = 0.
          DELETE ITAB_FIN.
          ENDIF.

    READ TABLE IT_HRP1000 INTO WA_HRP1000 WITH KEY OBJID = ITAB_FIN-OBJID
                                                   SHORT = 'DZM'.
        IF SY-SUBRC = 0.
          DELETE ITAB_FIN.
          ENDIF.

    READ TABLE IT_HRP1000 INTO WA_HRP1000 WITH KEY OBJID = ITAB_FIN-OBJID
                                                   SHORT = 'RM'.
        IF SY-SUBRC = 0.
          DELETE ITAB_FIN.
          ENDIF.
  ENDLOOP.

  SORT ITAB_FIN BY OBJID.

endform.                    " SOLUTION2


*&---------------------------------------------------------------------*
*&      Form  ALV_OUTPUT2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form alv_output2 .

clear :wa_fld,alv_layout.
clear : alv_fldcat, alv_fldcat[].

  wa_fld-fieldname = 'OBJID'.
  wa_fld-seltext_l = 'Position'.
  append wa_fld to alv_fldcat.

  wa_fld-fieldname = 'PERNR'.
  wa_fld-seltext_l = 'Employee'.
  append wa_fld to alv_fldcat.

  wa_fld-fieldname = 'NAME'.
  wa_fld-seltext_l = 'Employee Name'.
  append wa_fld to alv_fldcat.

  wa_fld-fieldname = 'HQ'.
  wa_fld-seltext_l = 'Head Quarter'.
  append wa_fld to alv_fldcat.

  alv_layout-window_titlebar = 'Any Position under field staff with no territories associated'.
  alv_layout-colwidth_optimize = 'X'.
  alv_layout-zebra = 'X'.

  call function 'REUSE_ALV_GRID_DISPLAY'
   exporting
     i_callback_program                = wa_repid
*     I_CALLBACK_USER_COMMAND           = 'USER_COMMAND'
*     I_CALLBACK_TOP_OF_PAGE            = 'TOP_OF_LIST'
     is_layout                         =  alv_layout
     it_fieldcat                       = alv_fldcat
     i_default                         = 'X'
     i_save                            = 'A'
*     IT_EVENTS                         = IT_EVENTS
    tables
      t_outtab                          = itab_fin
   exceptions
     program_error                     = 1
     others                            = 2
            .
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.


endform.                    " ALV_OUTPUT2


*&---------------------------------------------------------------------*
*&      Form  SOLUTION4
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form solution4 .
***commented by sathish.B to get hierarchy
month = s_fkdat-low+4(2).
year = s_fkdat-low+0(4).

call function 'Z_FHR_POSITION_HIERARCHY'
  exporting
    month1                   = month
    year1                    = year
* IMPORTING
*   POSITION_HIERARCHY       =
  tables
    e_t_data                 = itab_h.

*       OBJID TYPE HROBJID,
*       PERNR TYPE PERSNO,
*       NAME(80) TYPE C,
*       HQ(12) TYPE C,

    if itab_h is not initial.
*      Get the employee name
      select pernr subty objps sprps endda begda seqnr nachn vorna from pa0002 into
        table itab_pa0002n for all entries in itab_h where pernr = itab_h-holdrpos "POSITIONS
        and subty = ' ' and objps = ' ' and sprps = ' ' and endda ge s_fkdat-high and
        begda le s_fkdat-high and seqnr = ' '.
    endif.




loop at itab_h into wa_h.
 move : wa_h-positions   to itab_hy-objid,
        wa_h-holdrpos    to itab_hy-pernr,
        WA_H-REPPOSITION1 TO ITAB_HY-REPPOSITION1,
        wa_h-holdrhqcode to itab_hy-hq.

 read table itab_pa0002n with key pernr = wa_h-holdrpos.
     if sy-subrc = 0.
        concatenate itab_pa0002n-vorna ' ' itab_pa0002n-nachn into itab_hy-name.
     endif.
append itab_hy.
clear : wa_h,itab_hy,itab_pa0002n.
endloop.

delete itab_hy where REPPOSITION1 is NOT initial.
***commented by sathish.B to get hierarchy

endform.                    " SOLUTION4



*&---------------------------------------------------------------------*
*&      Form  ALV_OUTPUT4
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form alv_output4 .

clear : wa_fld,alv_layout.
clear : alv_fldcat, alv_fldcat[].

  wa_fld-fieldname = 'OBJID'.
  wa_fld-seltext_l = 'Position'.
  append wa_fld to alv_fldcat.

  wa_fld-fieldname = 'PERNR'.
  wa_fld-seltext_l = 'Employee'.
  append wa_fld to alv_fldcat.

  wa_fld-fieldname = 'NAME'.
  wa_fld-seltext_l = 'Employee Name'.
  append wa_fld to alv_fldcat.

  wa_fld-fieldname = 'HQ'.
  wa_fld-seltext_l = 'Head Quarter'.
  append wa_fld to alv_fldcat.

  alv_layout-window_titlebar = 'Field hierarchy not maintained'.
  alv_layout-colwidth_optimize = 'X'.
  alv_layout-zebra = 'X'.

  call function 'REUSE_ALV_GRID_DISPLAY'
   exporting
     i_callback_program                = wa_repid
*     I_CALLBACK_USER_COMMAND           = 'USER_COMMAND'
*     I_CALLBACK_TOP_OF_PAGE            = 'TOP_OF_LIST'
     is_layout                         =  alv_layout
     it_fieldcat                       = alv_fldcat
     i_default                         = 'X'
     i_save                            = 'A'
*     IT_EVENTS                         = IT_EVENTS
    tables
      t_outtab                          = itab_hy
   exceptions
     program_error                     = 1
     others                            = 2
            .
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.


endform.                    " ALV_OUTPUT4
*&---------------------------------------------------------------------*
*&      Form  SOLUTION3
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form solution3 .



*    Select the sales invoice for the customers
    select vbeln fkdat kunrg spart_i from wb2_v_vbrk_vbrp2
     into table itab_vbrk_vbrp
     where fkdat in s_fkdat
      and vkorg = '1000'
      and vtweg = '10'
      and spart in ('50','60')." AND VBTYP IN R_VBTYP.

sort itab_vbrk_vbrp by kunrg.

delete adjacent duplicates from itab_vbrk_vbrp comparing kunrg.

if itab_vbrk_vbrp is not initial.
    select * from ysd_cus_div_dis into table itab_100c for all entries in itab_vbrk_vbrp
     where kunnr eq itab_vbrk_vbrp-kunrg
      and endda ge s_fkdat-high and begda le s_fkdat-low.
endif.

sort itab_100c by kunnr spart.

loop at itab_vbrk_vbrp into wa_vbrk_vbrp.
 read table itab_100c into wa_100c with key kunnr = wa_vbrk_vbrp-kunrg.
  if sy-subrc ne 0.
    move : wa_vbrk_vbrp-kunrg to wa_c-kunnr.
    append wa_c to itab_c.
  endif.
clear :wa_vbrk_vbrp,wa_100c,wa_c.
endloop.

endform.                    " SOLUTION3
*&---------------------------------------------------------------------*
*&      Form  ALV_OUTPUT3
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form alv_output3 .

clear : wa_fld,alv_layout.
clear : alv_fldcat, alv_fldcat[].

  wa_fld-fieldname = 'KUNNR'.
  wa_fld-seltext_l = 'Customer'.
  append wa_fld to alv_fldcat.

  alv_layout-window_titlebar = 'Customer have done the sale but no territories allocation done'.
  alv_layout-colwidth_optimize = 'X'.
  alv_layout-zebra = 'X'.

  call function 'REUSE_ALV_GRID_DISPLAY'
   exporting
     i_callback_program                = wa_repid
*     I_CALLBACK_USER_COMMAND           = 'USER_COMMAND'
*     I_CALLBACK_TOP_OF_PAGE            = 'TOP_OF_LIST'
     is_layout                         =  alv_layout
     it_fieldcat                       = alv_fldcat
     i_default                         = 'X'
     i_save                            = 'A'
*     IT_EVENTS                         = IT_EVENTS
    tables
      t_outtab                          = itab_c
   exceptions
     program_error                     = 1
     others                            = 2
            .
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.


endform.                    " ALV_OUTPUT3
*&---------------------------------------------------------------------*
*&      Form  SOLUTION6
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form solution6 .
   select * from t171 into table it_t171 .
     if it_t171 is not initial.
       select * from ysd_cus_div_dis into table it_custom
         for all entries in it_t171 where bzirk = it_t171-bzirk.
       endif.

   if it_custom is not initial.
   select * from ysd_dist_targt into table it_targ for all entries
     in it_custom where bzirk = it_custom-bzirk.
     endif.
  loop at it_t171 into wa_t171.
   READ TABLE IT_CUSTOM INTO WA_CUSTOM WITH KEY BZIRK = wa_t171-BZIRK.
    IF SY-SUBRC = 0.
  read table it_targ into wa_targ with key bzirk = WA_CUSTOM-bzirk.
  if sy-subrc <> 0 .
   move-corresponding wa_t171 to wa_wotarg.
   append wa_wotarg to it_wotarg.
  endif.
  endif.
  endloop.
endform.                    " SOLUTION6
*&---------------------------------------------------------------------*
*&      Form  ALV_OUTPUT6
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form alv_output6 .

clear :wa_fld,alv_layout.
clear : alv_fldcat, alv_fldcat[].

  wa_fld-fieldname = 'BZIRK'.
  wa_fld-seltext_l = 'Sales District Without Target'.
  append wa_fld to alv_fldcat.


  alv_layout-window_titlebar = 'DECLARATION POSITION / TERITORY WITHOUT TARGET'.
  alv_layout-colwidth_optimize = 'X'.
  alv_layout-zebra = 'X'.

  call function 'REUSE_ALV_GRID_DISPLAY'
   exporting
     i_callback_program                = wa_repid
*     I_CALLBACK_USER_COMMAND           = 'USER_COMMAND'
*     I_CALLBACK_TOP_OF_PAGE            = 'TOP_OF_LIST'
     is_layout                         =  alv_layout
     it_fieldcat                       = alv_fldcat
     i_default                         = 'X'
     i_save                            = 'A'
*     IT_EVENTS                         = IT_EVENTS
    tables
      t_outtab                          = it_wotarg
   exceptions
     program_error                     = 1
     others                            = 2
            .
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.
endform.                    " ALV_OUTPUT6
*&---------------------------------------------------------------------*
*&      Form  SOLUTION7
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form solution7 .
     select * from knvv into table it_knvv .
      if it_knvv is not initial.
      select * from ysd_cus_div_dis into  table it_cusdiv for all entries in
      it_knvv where kunnr = it_knvv-kunnr and endda le s_fkdat-high and begda ge s_fkdat-low.
      endif.
      sort it_cusdiv by bzirk.

 if it_knvv is not initial.
 select * from kna1 into table it_kna1 for all entries in
 it_knvv where kunnr = it_knvv-kunnr.
 endif.

if it_cusdiv is not initial.
 select * from yterrallc into table it_talloc for all entries in
      it_cusdiv where bzirk = it_cusdiv-bzirk.
endif.

 sort it_talloc by bzirk.
loop at it_cusdiv into wa_cusdiv.
if wa_cusdiv-spart = '50' or wa_cusdiv-spart = '60'.
else.
delete it_cusdiv.
endif.
endloop.

loop at it_cusdiv into wa_cusdiv.
  read table it_talloc into wa_talloc with key bzirk = wa_cusdiv-bzirk
                                               spart = wa_cusdiv-spart.
   if sy-subrc ne '0'.
     move wa_cusdiv-kunnr to wa_mmatch-kunnr.
     move wa_cusdiv-spart to wa_mmatch-spart.
     move wa_cusdiv-bzirk to wa_mmatch-bzirk.
     append wa_mmatch to it_mmatch.
     clear wa_mmatch.
   endif.
  endloop.


*loop at it_cusdiv into wa_cusdiv.
*loop at it_talloc into wa_talloc where bzirk = wa_cusdiv-bzirk.
* if wa_talloc-begda ge wa_cusdiv-begda .
* if wa_talloc-spart <> wa_cusdiv-spart .
* move wa_cusdiv-kunnr to wa_mmatch-kunnr.
* move wa_talloc-spart to wa_mmatch-spart.
* move wa_talloc-bzirk to wa_mmatch-bzirk.
* append wa_mmatch to it_mmatch.
*endif.
*endif.
*endloop.
*endloop.
*
*it_mmatch_f[] = it_mmatch[].
*
*loop at it_mmatch into wa_mmatch .
*read table it_mmatch_f into wa_mmatch_f with key kunnr = wa_mmatch-kunnr
*                                                 spart = '50'
*                                                 bzirk = wa_mmatch-bzirk.
*if sy-subrc = 0.
*  flag_50 = 'X'.
*endif.
*read table it_mmatch_f into wa_mmatch_f with key kunnr = wa_mmatch-kunnr
*                                                 spart = '60'
*                                                 bzirk = wa_mmatch-bzirk.
*if sy-subrc = 0.
*  flag_60 = 'X'.
*endif.
*
*if flag_50 <> 'X' and flag_60 = 'X'.
*   move wa_mmatch-kunnr to wa_mmatch_fi-kunnr.
*   move '60' to wa_mmatch_fi-spart.
*   move wa_mmatch-bzirk to wa_mmatch_fi-bzirk.
*   append wa_mmatch_fi to it_mmatch_fi.
*elseif flag_60 <> 'X' and flag_50 = 'X' .
*   move wa_mmatch-kunnr to wa_mmatch_fi-kunnr.
*   move '50' to wa_mmatch_fi-spart.
*   move wa_mmatch-bzirk to wa_mmatch_fi-bzirk.
*   append wa_mmatch_fi to it_mmatch_fi.
*endif.
*
*clear : flag_50 , flag_60,wa_mmatch,wa_mmatch_f,wa_mmatch_fi.
*endloop.
*
*clear wa_talloc.
loop at it_mmatch into wa_mmatch.
read table it_kna1 into wa_kna with key kunnr = wa_mmatch-kunnr.
if sy-subrc = 0.
move wa_kna-name1 to wa_mmatch-name1.
endif.
read table it_talloc into wa_talloc with key spart = wa_mmatch-spart
                                             bzirk = wa_mmatch-bzirk.
if sy-subrc = 0.
move wa_talloc-plans to wa_mmatch-plans.
endif.

modify  it_mmatch from  wa_mmatch transporting name1 plans.
clear : wa_mmatch,wa_talloc .
endloop.

sort it_mmatch by kunnr.
DELETE ADJACENT DUPLICATES FROM it_mmatch COMPARING kunnr.
endform.                    " SOLUTION7
*&---------------------------------------------------------------------*
*&      Form  ALV_OUTPUT7
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form alv_output7 .

clear :wa_fld,alv_layout.
clear : alv_fldcat, alv_fldcat[].

  wa_fld-fieldname = 'KUNNR'.
  wa_fld-seltext_l = 'EMPLOYEE'.
  append wa_fld to alv_fldcat.

  wa_fld-fieldname = 'NAME1'.
  wa_fld-seltext_l = 'EMPLOYEE NAME'.
  append wa_fld to alv_fldcat.

  wa_fld-fieldname = 'SPART'.
  wa_fld-seltext_l = 'spart'.
  append wa_fld to alv_fldcat.

  wa_fld-fieldname = 'BZIRK'.
  wa_fld-seltext_l = 'SALES DIST'.
  append wa_fld to alv_fldcat.

  wa_fld-fieldname = 'PLANS'.
  wa_fld-seltext_l = 'POSITION'.
  append wa_fld to alv_fldcat.

  alv_layout-window_titlebar = 'DECLARATION POSITION / TERITORY WITHOUT TARGET'.
  alv_layout-colwidth_optimize = 'X'.
  alv_layout-zebra = 'X'.

  call function 'REUSE_ALV_GRID_DISPLAY'
   exporting
     i_callback_program                = wa_repid
*     I_CALLBACK_USER_COMMAND           = 'USER_COMMAND'
*     I_CALLBACK_TOP_OF_PAGE            = 'TOP_OF_LIST'
     is_layout                         =  alv_layout
     it_fieldcat                       = alv_fldcat
     i_default                         = 'X'
     i_save                            = 'A'
*     IT_EVENTS                         = IT_EVENTS
    tables
      t_outtab                          = it_mmatch
   exceptions
     program_error                     = 1
     others                            = 2
            .
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.
endform.                    " ALV_OUTPUT7
