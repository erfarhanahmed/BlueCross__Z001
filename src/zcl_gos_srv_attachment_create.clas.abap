class ZCL_GOS_SRV_ATTACHMENT_CREATE definition
  public
  inheriting from CL_GOS_SERVICE
  create public .

public section.

  interfaces IF_GOS_SERVICE_ON_CREATE .
  interfaces IF_GOS_SERVICE_TOOLS .

  methods EXECUTE
    redefinition .
protected section.

  methods CHECK_STATUS
    redefinition .
private section.
 data:
    gt_attachments type table of sibflporb .
  data:
    GT_ARLINKS type table of relgraphlk .
ENDCLASS.



CLASS ZCL_GOS_SRV_ATTACHMENT_CREATE IMPLEMENTATION.


  method CHECK_STATUS.
*CALL METHOD SUPER->CHECK_STATUS
*  EXPORTING
*    IS_LPORB  =
**    is_object =
**  IMPORTING
**    ep_status =
**    ep_icon   =
*    .

*--------------------------------------------------------------------*
*-- Code
*  IF sy-uname = 'KPMG_ABAP6' or sy-uname = 'KPMG_ABAP7' or sy-uname = 'KPMG_ABAP35'.

  DATA : LS_TCODE  TYPE ZDMS_GOS_TCODE,
         LS_BUS    TYPE SWOTLV,
         LV_INID   TYPE CHAR70,
         LV_TCODE  TYPE STRING,
         LV_TCODE1 TYPE STRING.
  SPLIT GS_LPORB-INSTID AT '-' INTO LV_INID LV_TCODE LV_TCODE1.
  GS_LPORB-INSTID = LV_INID.

  IF SY-TCODE IS NOT INITIAL.
    LV_TCODE = SY-TCODE.
  ENDIF.


*----------> Added by Karthik on 06.11.2019

  IF LV_TCODE = 'QP01'.
    IF GS_LPORB-INSTID IS INITIAL.
      MESSAGE 'Material and Plant are required for Create Attachment' TYPE 'E'.
    ENDIF.
  ENDIF.

*----------> End of addition

****code added by anbu starts on 7 jan 2019
****this below code added because while executing T-code /DBM/ORDER02
****in the current program SY-Tcode value is BLANK so manually we are
****moving L_Tcode to SY-TCODE
*  IF sy-tcode IS INITIAL.
*    sy-tcode = lv_tcode.
*  ENDIF.
****code added by anbu ends on 7 jan 2019


  DATA : LR_TR_MGR         TYPE REF TO IF_OS_TRANSACTION_MANAGER,
         LR_TRANS          TYPE REF TO IF_OS_TRANSACTION,
         E_UNDO_RELEVANT   TYPE OS_BOOLEAN,
         E_CHAINED         TYPE OS_BOOLEAN,
         E_UPDATE_MODE     TYPE OS_DMODE,
         E_EXTERNAL_COMMIT TYPE OS_BOOLEAN.

  DATA: LR_RESULT TYPE        OS_TSTATUS.

*  IF lv_tcode = 'BP'.
  LR_TR_MGR = CL_OS_SYSTEM=>GET_TRANSACTION_MANAGER( ).
  TRY.
      CALL METHOD LR_TR_MGR->GET_CURRENT_TRANSACTION RECEIVING RESULT = LR_TRANS.
      CALL METHOD LR_TRANS->GET_MODES
        IMPORTING
          E_UNDO_RELEVANT   = E_UNDO_RELEVANT
          E_CHAINED         = E_CHAINED
          E_UPDATE_MODE     = E_UPDATE_MODE
          E_EXTERNAL_COMMIT = E_EXTERNAL_COMMIT.
      IF E_UNDO_RELEVANT = 'X'.
        LR_TRANS->END( ).
        LR_TRANS->UNDO( ).
      ENDIF.
  ENDTRY.

  SELECT SINGLE * FROM
    ZDMS_GOS_TCODE INTO LS_TCODE WHERE TCODE = LV_TCODE.
  IF SY-SUBRC EQ 0.
*****
**data : v_vbeln type  /DBM/VBAK_DB-vbeln,
**       v_closed type /DBM/VBAK_DB-closed,
**       wa_string1(50)." type string.
**
**if lv_tcode = '/DBM/ORDER02' or
**   lv_tcode = '/DBM/ORDER03'.
**
**clear : v_vbeln, v_closed, wa_string1.
**select single vbeln closed INTO (v_vbeln, v_closed ) FROM /DBM/VBAK_DB   WHERE vbeln = gs_lporb-instid.
**  if sy-subrc = 0.
**    if v_closed = 'X'.
***      CONCATENATE 'Order' gs_lporb-instid 'Invoiced and Not Allowed for Attachment' into wa_string1 SEPARATED BY space.
***     message wa_string1 Type 'E'.
***      message 'DBM Order Invoiced and Not Allowed for Attachment'  Type 'E'.
**      message 'Not Allowed for DBM Order Invoiced'  Type 'E'.
**     return.
**    endif.
**    clear : v_vbeln, v_closed, wa_string1.
**  endif.
**endif.
*****



    DATA : GV_FILE TYPE IBIPPARMS-PATH,
           LV_KEY  TYPE CHAR20.
    LV_KEY = GS_LPORB-INSTID.
*--
    CALL FUNCTION 'Z_SRV_CREATE_DOC_IN_DMS'
      EXPORTING
        IS_OBJECT = GS_LPORB
        VBELN     = LV_KEY
        LV_TCODE  = LV_TCODE. "added by anbu

  ELSE.
*--------------------------------------------------------------------*
    DATA LO_ATTACHMENT TYPE REF TO CL_GOS_DOCUMENT_SERVICE.
    DATA LS_OBJECT TYPE BORIDENT.
    DATA LP_ATTACHMENT TYPE SWO_TYPEID.
    DATA LS_ATTACHMENT TYPE SIBFLPORB.

    LS_OBJECT-OBJKEY = GS_LPORB-INSTID.
    LS_OBJECT-OBJTYPE = GS_LPORB-TYPEID.

    CREATE OBJECT LO_ATTACHMENT.
    CALL METHOD LO_ATTACHMENT->CREATE_ATTACHMENT
      EXPORTING
        IS_OBJECT     = LS_OBJECT
      IMPORTING
        EP_ATTACHMENT = LP_ATTACHMENT.
    IF LP_ATTACHMENT IS INITIAL.
      MESSAGE S042(SGOS_MSG).
    ELSEIF LS_OBJECT-OBJKEY IS INITIAL AND
       NOT LP_ATTACHMENT IS INITIAL.
      LS_ATTACHMENT-INSTID = LP_ATTACHMENT.
      LS_ATTACHMENT-TYPEID = 'MESSAGE'.
      LS_ATTACHMENT-CATID = 'BO'.
      APPEND LS_ATTACHMENT TO GT_ATTACHMENTS.
    ELSE.
      MESSAGE S043(SGOS_MSG).
      RAISE EVENT COMMIT_REQUIRED.
      RAISE EVENT SERVICE_SUCCEEDED
        EXPORTING EO_SERVICE = ME.
    ENDIF.
  ENDIF.

  endmethod.


  method EXECUTE.
*--------------------------------------------------------------------*
*-- Code
*  IF sy-uname = 'KPMG_ABAP6' or sy-uname = 'KPMG_ABAP7' or sy-uname = 'KPMG_ABAP35'.

  DATA : LS_TCODE  TYPE ZDMS_GOS_TCODE,
         LS_BUS    TYPE SWOTLV,
         LV_INID   TYPE CHAR70,
         LV_TCODE  TYPE STRING,
         LV_TCODE1 TYPE STRING.
  SPLIT GS_LPORB-INSTID AT '-' INTO LV_INID LV_TCODE LV_TCODE1.
  GS_LPORB-INSTID = LV_INID.

  IF SY-TCODE IS NOT INITIAL.
    LV_TCODE = SY-TCODE.
  ENDIF.


*----------> Added by Karthik on 06.11.2019

  IF LV_TCODE = 'QP01'.
    IF GS_LPORB-INSTID IS INITIAL.
      MESSAGE 'Material and Plant are required for Create Attachment' TYPE 'E'.
    ENDIF.
  ENDIF.

*----------> End of addition

****code added by anbu starts on 7 jan 2019
****this below code added because while executing T-code /DBM/ORDER02
****in the current program SY-Tcode value is BLANK so manually we are
****moving L_Tcode to SY-TCODE
*  IF sy-tcode IS INITIAL.
*    sy-tcode = lv_tcode.
*  ENDIF.
****code added by anbu ends on 7 jan 2019


  DATA : LR_TR_MGR         TYPE REF TO IF_OS_TRANSACTION_MANAGER,
         LR_TRANS          TYPE REF TO IF_OS_TRANSACTION,
         E_UNDO_RELEVANT   TYPE OS_BOOLEAN,
         E_CHAINED         TYPE OS_BOOLEAN,
         E_UPDATE_MODE     TYPE OS_DMODE,
         E_EXTERNAL_COMMIT TYPE OS_BOOLEAN.

  DATA: LR_RESULT TYPE        OS_TSTATUS.

*  IF lv_tcode = 'BP'.
  LR_TR_MGR = CL_OS_SYSTEM=>GET_TRANSACTION_MANAGER( ).
  TRY.
      CALL METHOD LR_TR_MGR->GET_CURRENT_TRANSACTION RECEIVING RESULT = LR_TRANS.
      CALL METHOD LR_TRANS->GET_MODES
        IMPORTING
          E_UNDO_RELEVANT   = E_UNDO_RELEVANT
          E_CHAINED         = E_CHAINED
          E_UPDATE_MODE     = E_UPDATE_MODE
          E_EXTERNAL_COMMIT = E_EXTERNAL_COMMIT.
      IF E_UNDO_RELEVANT = 'X'.
        LR_TRANS->END( ).
        LR_TRANS->UNDO( ).
      ENDIF.
  ENDTRY.

  SELECT SINGLE * FROM
    ZDMS_GOS_TCODE INTO LS_TCODE WHERE TCODE = LV_TCODE.
  IF SY-SUBRC EQ 0.
*****
**data : v_vbeln type  /DBM/VBAK_DB-vbeln,
**       v_closed type /DBM/VBAK_DB-closed,
**       wa_string1(50)." type string.
**
**if lv_tcode = '/DBM/ORDER02' or
**   lv_tcode = '/DBM/ORDER03'.
**
**clear : v_vbeln, v_closed, wa_string1.
**select single vbeln closed INTO (v_vbeln, v_closed ) FROM /DBM/VBAK_DB   WHERE vbeln = gs_lporb-instid.
**  if sy-subrc = 0.
**    if v_closed = 'X'.
***      CONCATENATE 'Order' gs_lporb-instid 'Invoiced and Not Allowed for Attachment' into wa_string1 SEPARATED BY space.
***     message wa_string1 Type 'E'.
***      message 'DBM Order Invoiced and Not Allowed for Attachment'  Type 'E'.
**      message 'Not Allowed for DBM Order Invoiced'  Type 'E'.
**     return.
**    endif.
**    clear : v_vbeln, v_closed, wa_string1.
**  endif.
**endif.
*****



    DATA : GV_FILE TYPE IBIPPARMS-PATH,
           LV_KEY  TYPE CHAR20.
    LV_KEY = GS_LPORB-INSTID.
*--
    CALL FUNCTION 'Z_SRV_CREATE_DOC_IN_DMS'
      EXPORTING
        IS_OBJECT = GS_LPORB
        VBELN     = LV_KEY
        LV_TCODE  = LV_TCODE. "added by anbu

  ELSE.
*--------------------------------------------------------------------*
    DATA LO_ATTACHMENT TYPE REF TO CL_GOS_DOCUMENT_SERVICE.
    DATA LS_OBJECT TYPE BORIDENT.
    DATA LP_ATTACHMENT TYPE SWO_TYPEID.
    DATA LS_ATTACHMENT TYPE SIBFLPORB.

    LS_OBJECT-OBJKEY = GS_LPORB-INSTID.
    LS_OBJECT-OBJTYPE = GS_LPORB-TYPEID.

    CREATE OBJECT LO_ATTACHMENT.
    CALL METHOD LO_ATTACHMENT->CREATE_ATTACHMENT
      EXPORTING
        IS_OBJECT     = LS_OBJECT
      IMPORTING
        EP_ATTACHMENT = LP_ATTACHMENT.
    IF LP_ATTACHMENT IS INITIAL.
      MESSAGE S042(SGOS_MSG).
    ELSEIF LS_OBJECT-OBJKEY IS INITIAL AND
       NOT LP_ATTACHMENT IS INITIAL.
      LS_ATTACHMENT-INSTID = LP_ATTACHMENT.
      LS_ATTACHMENT-TYPEID = 'MESSAGE'.
      LS_ATTACHMENT-CATID = 'BO'.
      APPEND LS_ATTACHMENT TO GT_ATTACHMENTS.
    ELSE.
      MESSAGE S043(SGOS_MSG).
      RAISE EVENT COMMIT_REQUIRED.
      RAISE EVENT SERVICE_SUCCEEDED
        EXPORTING EO_SERVICE = ME.
    ENDIF.
  ENDIF.

  endmethod.


  method IF_GOS_SERVICE_ON_CREATE~ON_OBJECT_CREATED.
* ...
  DATA ls_attachment TYPE sibflporb.

  CHECK NOT es_lpor-instid IS INITIAL.
  LOOP AT gt_attachments INTO ls_attachment.
    TRY.
        CALL METHOD cl_binary_relation=>create_link
          EXPORTING
            is_object_a            = es_lpor
            is_object_b            = ls_attachment
            ip_reltype             = 'ATTA'.
      CATCH cx_obl_internal_error cx_obl_model_error.
    ENDTRY.
  ENDLOOP.
  IF sy-subrc = 0.
    RAISE EVENT commit_required.
*    RAISE EVENT service_succeeded
*      EXPORTING eo_service = me.
  ENDIF.

  endmethod.


METHOD IF_GOS_SERVICE_TOOLS~COPY_SERVICE_OBJECTS .
*---------------------------------------------------------------------*
*       METHOD IF_GOS_SERVICE_TOOLS~COPY_SERVICE_OBJ                  *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
  DATA:
    ls_link TYPE obl_s_link,
    lt_links TYPE obl_t_link,
    ls_object TYPE sibflporb.

  TRY.
      CALL METHOD cl_binary_relation=>read_links_of_binrel
        EXPORTING
          is_object   = gs_lporb
          ip_relation = 'ATTA'
          ip_role     = 'GOSAPPLOBJ'
        IMPORTING
          et_links    = lt_links.

* Copy links to Attachments
      LOOP AT lt_links INTO ls_link WHERE reltype = 'ATTA'.
        ls_object-instid = ls_link-instid_b.
        ls_object-typeid = ls_link-typeid_b.
        ls_object-catid = ls_link-catid_b.
        TRY.
            CALL METHOD cl_binary_relation=>create_link
              EXPORTING
                is_object_a = is_copy_to
                is_object_b = ls_object
                ip_reltype  = ls_link-reltype.
          CATCH cx_obl.
        ENDTRY.

      ENDLOOP.
      IF sy-subrc = 0.
        RAISE EVENT commit_required.
      ENDIF.
      CATCH cx_obl .
    ENDTRY.
  ENDMETHOD.                    "IF_GOS_SERVICE_TOOLS~COPY_SERVICE_OBJECTS


  method IF_GOS_SERVICE_TOOLS~DELETE_SERVICE_OBJECTS.
* ...
  DATA: lo_attachment TYPE REF TO cl_gos_document_service,
        lp_attachment TYPE swo_typeid,
        lt_roles TYPE obl_t_role,
        ls_role TYPE obl_s_role.
  TRY.
      CALL METHOD cl_binary_relation=>read_links_of_binrel
        EXPORTING
          is_object              = gs_lporb
          ip_relation            = 'ATTA'
          ip_role                = 'GOSAPPLOBJ'
        IMPORTING
          et_roles               = lt_roles
          .
      CREATE OBJECT lo_attachment.
      LOOP AT lt_roles INTO ls_role WHERE roletype = 'ATTACHMENT'.
        lp_attachment =  ls_role-instid.
        CALL METHOD lo_attachment->delete_attachment
          EXPORTING
            is_lporb        = gs_lporb
            ip_attachment   = lp_attachment.
      ENDLOOP.
      IF sy-subrc = 0.
        RAISE EVENT commit_required.
      ENDIF.
    CATCH cx_obl_internal_error .
    CATCH cx_obl_model_error .
  ENDTRY.
  endmethod.


  method IF_GOS_SERVICE_TOOLS~MOVE_SERVICE_OBJECTS.

    DATA:
    ls_link TYPE obl_s_link,
    lt_links TYPE obl_t_link,
    ls_object TYPE sibflporb.

  TRY.
      CALL METHOD cl_binary_relation=>read_links_of_binrel
        EXPORTING
          is_object   = gs_lporb
          ip_relation = 'ATTA'
          ip_role     = 'GOSAPPLOBJ'
        IMPORTING
          et_links    = lt_links.

* move links to Attachments
      LOOP AT lt_links INTO ls_link.
        ls_object-instid = ls_link-instid_b.
        ls_object-typeid = ls_link-typeid_b.
        ls_object-catid = ls_link-catid_b.
        TRY.
            CALL METHOD cl_binary_relation=>create_link
              EXPORTING
                is_object_a = is_move_to
                is_object_b = ls_object
                ip_reltype  = ls_link-reltype.

            CALL METHOD cl_binary_relation=>delete_link
              EXPORTING
                is_object_a = gs_lporb
                is_object_b = ls_object
                ip_reltype  = ls_link-reltype.
          CATCH cx_obl.
        ENDTRY.

      ENDLOOP.
      IF sy-subrc = 0.
        RAISE EVENT commit_required.
      ENDIF.
      CATCH cx_obl .
    ENDTRY.
  endmethod.
ENDCLASS.
