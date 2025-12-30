function-pool qst01              message-id qy.

*--- overall status processing
include lqprsts0.

*--- status processing for maintenance plan
include mixstt00.

*--- archiving maintenance plans
type-pools: ipml.

*--- general data and constants for stability study
include qstabicons.

*--- table controls for different dynpros
controls: tc_lager_0200     type tableview using screen 0200,
          tc_lager_0250     type tableview using screen 0250,
          tc_lager_0400     type tableview using screen 0400,
          tc_lager_0500     type tableview using screen 0500,
          tc_lager_0600     type tableview using screen 0600,
          tc_lager_0800     type tableview using screen 0800,
          tc_lager_1100     type tableview using screen 1100,
          tc_lager_1200     type tableview using screen 1200.

*--- tables
tables: qprn,        "sample drawing
        qprs,        "physical sample
        rqprs,       "dialog structure physical sample
        qals,        "inspection lot
        mpla,        "maintenance plan
        mpos,        "positions in maint. plan
        mhio,        "call objects maintenance plan
        mhis,        "scheduled dates
        makt,        "material description
        mtqss,       "material master view QSS
        viqmel,      "notifications
        tq43,        "storage conditions
        tq43t,       "storage conditions - texts
        tq42t,       "texts for phys. sample containers
        tq40t,       "texts for sample types
        tq41t,       "texts for storage locations
        t399w,       "parameter maintenance plan
        tq80,        "notification types
        t001w,       "plants
        t390,        "workpapers
        rmipm,       "preventive maintenance
        qst010000,   "header data for activities for storage cond.
        qst010100,   "fields dynpro 0100 - create initial sample
        qst010150,   "fields dynpro 0150 - change initial sample
        qst010200,   "fields dynpro 0200 - create storage cond.
        qst010250,   "fields dynpro 0250 - change storage cond.
        qst010300,   "fields dynpro 0300 - release initial sample
        qst010700,   "fields dynpro 0700 - create maintenance plan
        qst010900,   "fields dynpro 0900 - assign BOM
        wworkpaper,  "Print variables
        riwo00,
        riwo1.


*----- Constants
constants:  c_x                                        value 'X',
            c_yes                                      value '+',
            c_i             like sy-msgty              value 'I',
            c_rc00          like sy-subrc              value '0',
            c_nrnr_mpla     like inri-object           value 'MPLA_NR',
            c_origin_st     like qals-herkunft         value '16',
            c_itype_st      like qals-art              value '16',
            c_callmode_n    like ibipparms-callmode    value 'N',
            c_updatemode_s  like ibipparms-updatemode  value 'S',
            c_st            type mityp                 value 'ST',
            id_iprt_options(16)       value 'ID_IPRT_OPTIONS',
            id_iprt_struct(16)        value 'ID_IPRT_STRUCT',
            id_iprt_rqm00(16)         value 'ID_IPRT_RQM00',
            id_iprt_papers(16)        value 'ID_IPRT_PAPERS'.

*----- internal types
* Definition of storage condition
types: begin of tc_lager_type,
         selected,
         stabicon           like qprs_addon-stabicon,
         stabicontxt        like tq43t-stabicontxt,
         stabimenge         like rqprs-menge,
         stabimeinh         like rqprs-meinh,
         stabiphynr         like qprs-phynr,
         objnr              like qprs-objnr,
       end of tc_lager_type.

types: begin of tc_lager_type_bb,
         stabicon           like qprs_addon-stabicon,
         stabicontxt        like tq43t-stabicontxt,
         prart              like qprs-prart,
         menge              like rqprs-menge,
         meinh              like rqprs-meinh,
         phynr              like qprs-phynr,
         gbtyp              like qprs-gbtyp,
         abort              like qprs-abort,
         objnr              like qprs-objnr,
       end of tc_lager_type_bb.

*----- OK-Code
data:  ok_code              like sy-ucomm,
       save_ok_code         like sy-ucomm.

*----- global parameters
data:  g_exit,
       g_buch,
       g_aend,
       g_flag_selected,
       g_flag_message,
       g_total_menge        like qprs-menge,
       g_stl_neu,           "BOM new
       g_stl_vorh,          "BOM exists
       g_stl_zuge,          "BOM assigned
       g_stl_del,           "BOM deleted
       g_isample_rel,       "initial sample is released
       g_storcond_rel.      "storage cond. is released

data:  g_warpl              like mpos-warpl.    "maint. plan

*-- internal workareas
data:  g_qprn               like qprn,         "sample drawing
       wa_qprs              like qprs,         "phys. sample
       g_qprs_old           like qprs,         "physical sample
       g_qprs_initial       like qprs,         "initial sample
       g_qprs_addon         like qprs_addon,   "addon data for sample
       g_qmel_ext           like qmel_ext.      "extension of QMEL

*-- definition of storage conditions
data:  wa_lager_def         type tc_lager_type.
data:  wa_lager_def_bb      type tc_lager_type_bb.

*-- update of storage conditions
data:  begin of wa_lager_upd,
        selected            like qm00-qkz,
        objnr               like qprs-objnr,
        anzlab              like qst010250-anzlab,
        sper                like qm00-qkz.
        include structure   rqprs.
data:  end   of wa_lager_upd.
*-- update of storage conditions
data:  wa_lager_upd_old like wa_lager_upd.

*------ Internal tables
*-- Table of physical samples
data:  it_qprs_all          type table of qprs,  "all samples for study
       it_qprs_stabi        type table of qprs,  "storage conditions
       it_lager_def         type table of tc_lager_type,
       it_lager_def_bb      type table of tc_lager_type_bb,
       it_lager_upd         like wa_lager_upd occurs 0,    "rqprs.
       it_lager_upd_old     like wa_lager_upd occurs 0.

*-- Building Block
data: g_bb_header              type  rmxts_q10,
      gt_bb_planning           type  rmxtty_q11,
      gt_bb_prodh              type  rmxtty_q12,
      gt_bb_descr              type  rmxtty_q10t,
      wa_bb_planning           like  rmxtt_q11.

* API
data: go_trial   type ref to if_rmxt_trialobj.

data: begin of gs_lager_upd,
        selected            like qm00-qkz,
        objnr               like qprs-objnr,
        anzlab              like qst010250-anzlab,
        sper                like qm00-qkz.
        include structure   rqprs.
data: end of gs_lager_upd.

data: g_not_scheduled     type flag,
      g_started           type flag,
      g_gstrp_flag,
      g_nplda_flag,
      gt_lager_upd        like gs_lager_upd occurs 0,
      gs_viqmel           type viqmel,
      gs_qmel_ext         type qmel_ext,
      g_upd_mpla          like qm00-qkz,
      g_new_stcon         like qm00-qkz,
      gt_mpos             like mpos occurs 0.

data: begin of g_prueflos_tab occurs 0,
        prueflos like vimhio-prueflos,
      end of g_prueflos_tab.

data: begin of gt_qsta006 occurs 1.
        include structure qsta006.
data:   ptext1 type txzyklus,
        ptext2 type txzyklus,
        txtaufb type qkurztxtao,
      end of gt_qsta006.

*--- printing storage list
data: iviqmel    type viqmel,
      iviqmfe    type table of wqmfe initial size 0 with header line,
      iviqmma    type table of wqmma initial size 0 with header line,
      iviqmsm    type table of wqmsm initial size 0 with header line,
      iviqmur    type table of wqmur initial size 0 with header line,
      iqmelext   type qmel_ext,
      iqkat      type table of qkat initial size 0,
      ihpad_tab  type table of ihpad initial size 0,
      rqm00      type rqm00,
      iworkpaper type wworkpaper occurs 0 with header line.



*----------------------------------------------------------------------*
*--- Ranges Tabellen
*----------------------------------------------------------------------*
ranges:
*-- Wartungspakete
  paket_ranges for plwp-paket,
*-- relevante Planknoten
  plnkn_ranges for plpo-plnkn.

ranges: r_status   for vimhio-status.




*#######################################################################
* Sending of infomail
************************************************************************
* The following declarations, embraced by ##################
* are required for the function to send an info e-mail with one
* activity.
* See also the comments in include LQST01F03
*include <cntn01>.
*type-pools: szadr.
*
*data: g_sender_id      like swotobjid,
*      g_appl_object_id like swotobjid,
*      g_recipient_id   like swotobjid,
*      g_recipient      type swc_object,
*      g_message        type swc_object,
*      g_address_string like soxna-fullname,
*      g_emailadr       type qnemailadr,
*      g_no_mail        type flag,
*      g_sent_succ      type flag.
*
*data: gt_adsmtp     type table of szadr_adsmtp_line with header line,
*      gt_addr_complete type szadr_addr3_complete.
** Containers for BCI
*swc_container g_container.
*
*types:
** structure to define text table
*  begin of source,
*   line like tline-tdline,
*  end of source,
** ABAP source code table type definition
*  gt_source_table type source occurs 0.
*#######################################################################
