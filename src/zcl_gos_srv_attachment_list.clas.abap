class ZCL_GOS_SRV_ATTACHMENT_LIST definition
  public
  inheriting from CL_GOS_SERVICE
  create public .

public section.

  methods ON_COMMIT_REQUIRED
    for event COMMIT_REQUIRED of CL_GOS_ATTACHMENTS .
  methods ON_LINK_CREATED
    for event LINK_CREATED of CL_BINARY_RELATION
    importing
      !EI_LINK .
  methods ON_LINK_DELETED
    for event LINK_DELETED of CL_BINARY_RELATION
    importing
      !EI_LINK .

  methods EXECUTE
    redefinition .
  methods ON_MODE_CHANGED
    redefinition .
  methods ON_SERVICE_CANCELED
    redefinition .
  methods ON_SERVICE_SUCCEEDED
    redefinition .
protected section.

  data G_REFRESH type FLAG value 'X' ##NO_TEXT.
  data GO_ATTACHMENT_LIST type ref to CL_GOS_ATTACHMENTS .

  methods CREATE_ROOT_ITEM
    returning
      value(RESULT) type ref to CL_BROWSER_ITEM .
  methods CHECK_SUPERTYPES .

  methods CHECK_STATUS
    redefinition .
private section.

  types:
    TT_TOAV0 type table of toav0 .

  data:
    GT_SUPERTYPE type table of swotip .
  data GO_BADI type ref to CL_EX_GOS_MULT_PUBLISH .
  constants GC_SRVC type SGS_SRVNAM value 'VIEW_ATTA' ##NO_TEXT.

  methods GET_ARCHIVE_IMAGES
    exporting
      !ET_CONNECTIONS type TT_TOAV0
    exceptions
      NO_CONNECTIONS .
ENDCLASS.



CLASS ZCL_GOS_SRV_ATTACHMENT_LIST IMPLEMENTATION.


  method CHECK_STATUS.
*CALL METHOD SUPER->CHECK_STATUS
*  EXPORTING
*    IS_LPORB  =
**    is_object =
**  IMPORTING
**    ep_status =
**    ep_icon   =
*    .


* ...
  DATA:
    lo_bitem          TYPE REF TO cl_browser_item,
    lp_notes          type sgs_flag value 'X',
    lp_attachments    type sgs_flag value 'X',
    lp_urls           type sgs_flag value 'X',
    lt_service_select type tgos_sels,
    ls_service_select type sgos_sels.

  ep_status = mp_status_inactive.

  if gp_cmode <> 'R'.
    clear g_refresh.
  endif.

  if gp_mode <> mp_mode_write.
    gp_mode = mp_mode_read.
  endif.

  IF NOT gs_lporb-instid IS INITIAL.
    IF go_attachment_list IS INITIAL.
      TRY.
          lo_bitem = create_root_item( ).
*         check excluded services for attachment list   "note 1317173
          ls_service_select-sign   = 'E'.
          ls_service_select-option = 'EQ'.
          if not go_model is initial.
            if go_model->check_service( 'NOTE_CREA' ) <> mp_status_active.
              ls_service_select-low    = 'NOTE_CREA'.
              append ls_service_select to lt_service_select.
            endif.
            if go_model->check_service( 'URL_CREA' ) <> mp_status_active.
              ls_service_select-low    = 'URL_CREA'.
              append ls_service_select to lt_service_select.
            endif.
            if go_model->check_service( 'PCATTA_CREA' ) <> mp_status_active.
              ls_service_select-low    = 'PCATTA_CREA'.
              append ls_service_select to lt_service_select.
            endif.
            if go_model->check_service( 'ARL_LINK' ) <> mp_status_active.
              ls_service_select-low    = 'ARL_LINK'.
              append ls_service_select to lt_service_select.
            endif.
          endif.

          CREATE OBJECT go_attachment_list
            EXPORTING
              io_object       = lo_bitem
              ip_check_arl    = 'X'
              ip_check_bds    = 'X'
              ip_mode         = gp_mode
              ip_notes        = lp_notes
              ip_attachments  = lp_attachments
              ip_urls         = lp_urls
              it_service_select = lt_service_select     "note 1317173
                  .
        CATCH cx_sobl_browser .
          ep_status = mp_status_invisible.
      ENDTRY.

    ENDIF.

    IF go_attachment_list->check_available( g_refresh ) = 'X'.
      ep_status = mp_status_active.
    ENDIF.
    clear g_refresh.
  ENDIF.
* Set an event handler to be informed on changes
  IF ep_status = mp_status_inactive.
    IF gp_cmode <> 'R'.
      SET HANDLER:
        on_service_succeeded FOR ALL INSTANCES ACTIVATION 'X',
        on_link_created ACTIVATION 'X'.

    ELSEIF gp_cmode = 'R'.
      SET HANDLER:
        on_service_succeeded FOR ALL INSTANCES ACTIVATION 'X'.
    ENDIF.
  ELSE.
    SET HANDLER:
      on_link_created ACTIVATION space,
      on_service_succeeded FOR ALL INSTANCES ACTIVATION space.
  ENDIF.

* Status changed?
  IF ep_status <> gp_status.
    gp_status = ep_status.
    RAISE EVENT service_changed
      EXPORTING
        ep_status  = gp_status
        eo_service = me
        .
  ENDIF.
  endmethod.


METHOD CHECK_SUPERTYPES .
* ...

  DATA: lp_objtype TYPE swo_objtyp.
  data: ls_supertype type swotip.

  IF gs_lporb-catid = 'BO' and gt_supertype IS INITIAL.
*- for archiv we must check all supertypes of the actual object
    lp_objtype = gs_lporb-typeid.
    CALL FUNCTION 'SWO_QUERY_SUPERTYPES'
         EXPORTING
              objtype           = lp_objtype
         TABLES
              supertypes        = gt_supertype
         EXCEPTIONS
              OTHERS            = 0.
    CLEAR ls_supertype.
    ls_supertype-parent = lp_objtype.
    APPEND ls_supertype TO gt_supertype.
  ENDIF.

ENDMETHOD.


METHOD CREATE_ROOT_ITEM .
*---------------------------------------------------------------------*
*  METHOD CREATE_ROOT_ITEM
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
  DATA:
    lo_bitem TYPE REF TO cl_browser_item,
    ls_borident TYPE borident,
    ls_lpor TYPE sibflpor,
    ls_lporb TYPE sibflporb,
    lt_lporb TYPE sibflporbt,
    lt_items TYPE bitem_t,
    lo_mitem TYPE REF TO cl_container_item,
    lp_lines TYPE i.

  CREATE OBJECT go_badi.
  CLEAR lt_lporb.
  APPEND gs_lporb TO lt_lporb.
  CALL METHOD go_badi->if_ex_gos_mult_publish~add_objects
    EXPORTING
      flt_val  = gc_srvc
    CHANGING
      ct_lporb = lt_lporb.

*  sort lt_lporb.                            " ad 20.01.2005
*  delete adjacent duplicates from lt_lporb. " ad 20.01.2005
  do.                                        " ad 02.12.2005
    delete table lt_lporb from gs_lporb.     " ad 02.12.2005
    if sy-subrc <> 0.                        " ad 02.12.2005
      exit.                                  " ad 02.12.2005
    endif.                                   " ad 02.12.2005
  enddo.                                     " ad 02.12.2005
  insert gs_lporb into lt_lporb index 1.     " ad 02.12.2005

  DESCRIBE TABLE lt_lporb LINES lp_lines.
  IF lp_lines = 1.
    READ TABLE lt_lporb INDEX 1 INTO ls_lporb.
    CASE ls_lporb-catid.
      WHEN 'BO'.
        ls_borident-objkey = ls_lporb-instid.
        ls_borident-objtype = ls_lporb-typeid.

        CREATE OBJECT lo_bitem TYPE cl_sobl_bor_item
          EXPORTING
            is_bor = ls_borident.
      WHEN OTHERS.
        MOVE-CORRESPONDING ls_lporb TO ls_lpor.
        CREATE OBJECT lo_bitem TYPE cl_obl_bc_item
          EXPORTING
            is_lpor = ls_lpor.
    ENDCASE.
    result ?= lo_bitem.
  ELSE.

    LOOP AT lt_lporb INTO ls_lporb.

      CASE ls_lporb-catid.
        WHEN 'BO'.
          ls_borident-objkey = ls_lporb-instid.
          ls_borident-objtype = ls_lporb-typeid.

          CREATE OBJECT lo_bitem TYPE cl_sobl_bor_item
            EXPORTING
              is_bor = ls_borident.
        WHEN OTHERS.
          MOVE-CORRESPONDING ls_lporb TO ls_lpor.
          CREATE OBJECT lo_bitem TYPE cl_obl_bc_item
            EXPORTING
              is_lpor = ls_lpor.
      ENDCASE.

      IF NOT lo_bitem IS INITIAL.
        APPEND lo_bitem TO lt_items.
      ENDIF.

    ENDLOOP.
    CREATE OBJECT lo_mitem.
    CALL METHOD lo_mitem->if_container_item~set_items
      EXPORTING
        it_bitem = lt_items.
    lo_mitem->gp_descr = gp_def_attrib.

    result ?= lo_mitem.

  ENDIF.
ENDMETHOD.                    "CREATE_ROOT_ITEM


  method EXECUTE.
**
  DATA : LV_DOCKEY TYPE CHAR20.
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
  SELECT SINGLE * FROM ZDMS_GOS_TCODE INTO LS_TCODE WHERE TCODE = LV_TCODE.
  IF SY-SUBRC EQ 0.
    LV_DOCKEY = GS_LPORB-INSTID.
    DATA : LT_DMS TYPE TABLE OF ZDMS_GOS.
    CLEAR LT_DMS[]. REFRESH LT_DMS.
    SELECT * INTO TABLE LT_DMS FROM ZDMS_GOS WHERE DOC_KEY = LV_DOCKEY.
    IF LT_DMS[] IS NOT INITIAL.
*      SUBMIT zdms_download_file WITH p_doc = lv_dockey AND RETURN. "commented by anbu on 14 jan 2019
      SUBMIT ZDMS_DOWNLOAD_FILE WITH P_DOC = LV_DOCKEY WITH P_KEY = LS_TCODE-KEYVALUE
             WITH P_TCODE = LV_TCODE AND RETURN. "added by anbu on 14 jan 2019
      MESSAGE S051(SGOS_MSG) RAISING CONTAINER_IGNORED.
    ELSE.

      DATA:LV_FLAG(1)  TYPE C.
      LV_FLAG = 'X'.
      EXPORT LV_FLAG FROM LV_FLAG TO MEMORY ID 'ZDUMP'.

      MESSAGE S042(SGOS_MSG) RAISING CONTAINER_IGNORED.
    ENDIF.
  ELSE.

    DATA:
      LO_BITEM          TYPE REF TO CL_BROWSER_ITEM,
      LP_NOTES          TYPE SGS_FLAG VALUE 'X',
      LP_ATTACHMENTS    TYPE SGS_FLAG VALUE 'X',
      LP_URLS           TYPE SGS_FLAG VALUE 'X',
      LT_SERVICE_SELECT TYPE TGOS_SELS,
      LS_SERVICE_SELECT TYPE SGOS_SELS.

    TRY.

        LO_BITEM ?= CREATE_ROOT_ITEM( ).

        IF GO_ATTACHMENT_LIST IS INITIAL.
*       check excluded services for attachment list     "note 1317173
          LS_SERVICE_SELECT-SIGN   = 'E'.
          LS_SERVICE_SELECT-OPTION = 'EQ'.
          IF GO_MODEL->CHECK_SERVICE( 'NOTE_CREA' ) <> MP_STATUS_ACTIVE.
            LS_SERVICE_SELECT-LOW    = 'NOTE_CREA'.
            APPEND LS_SERVICE_SELECT TO LT_SERVICE_SELECT.
          ENDIF.
          IF GO_MODEL->CHECK_SERVICE( 'URL_CREA' ) <> MP_STATUS_ACTIVE.
            LS_SERVICE_SELECT-LOW    = 'URL_CREA'.
            APPEND LS_SERVICE_SELECT TO LT_SERVICE_SELECT.
          ENDIF.
          IF GO_MODEL->CHECK_SERVICE( 'PCATTA_CREA' ) <> MP_STATUS_ACTIVE.
            LS_SERVICE_SELECT-LOW    = 'PCATTA_CREA'.
            APPEND LS_SERVICE_SELECT TO LT_SERVICE_SELECT.
          ENDIF.
          IF GO_MODEL->CHECK_SERVICE( 'ARL_LINK' ) <> MP_STATUS_ACTIVE.
            LS_SERVICE_SELECT-LOW    = 'ARL_LINK'.
            APPEND LS_SERVICE_SELECT TO LT_SERVICE_SELECT.
          ENDIF.

          CREATE OBJECT GO_ATTACHMENT_LIST
            EXPORTING
              IO_OBJECT         = LO_BITEM
              IO_CONTAINER      = IO_CONTAINER
              IP_MODE           = GP_MODE
              IP_CHECK_ARL      = 'X'
              IP_CHECK_BDS      = 'X'
              IP_NOTES          = LP_NOTES
              IP_ATTACHMENTS    = LP_ATTACHMENTS
              IP_URLS           = LP_URLS
              IT_SERVICE_SELECT = LT_SERVICE_SELECT.       "note 1317173
        ELSE.
          CALL METHOD GO_ATTACHMENT_LIST->SET_CONTAINER( IO_CONTAINER ).
        ENDIF.

        SET HANDLER ON_COMMIT_REQUIRED FOR GO_ATTACHMENT_LIST.
        CALL METHOD GO_ATTACHMENT_LIST->DISPLAY.
      CATCH CX_SOBL_BROWSER.
        MESSAGE S104(SGOS_MSG) RAISING EXECUTION_FAILED.
    ENDTRY.

  ENDIF.

ENDMETHOD.


METHOD GET_ARCHIVE_IMAGES .
* ...
  DATA ls_supertype TYPE swotip.
  DATA: lt_connect TYPE TABLE OF toav0,
        ls_connect TYPE toav0,
        lp_objecttype TYPE saeanwdid,
        lp_object_id TYPE saeobjid.

  LOOP AT gt_supertype INTO ls_supertype.
    clear lt_connect.
    lp_objecttype = ls_supertype-parent.
    lp_object_id = gs_lporb-instid.
    CALL FUNCTION 'ARCHIV_GET_CONNECTIONS'
         EXPORTING
              objecttype  = lp_objecttype
              object_id   = lp_object_id
         TABLES
              connections = lt_connect
         EXCEPTIONS
              OTHERS      = 0.
    APPEND LINES OF lt_connect TO et_connections.
  ENDLOOP.
  IF et_connections IS INITIAL.
    RAISE no_connections.
  ENDIF.
ENDMETHOD.


method ON_COMMIT_REQUIRED.
* raise event commit_required.
gp_changed = 'X'.
endmethod.


METHOD ON_LINK_CREATED.

  DATA:
    li_link TYPE REF TO cl_obl_binrel,
    li_model TYPE REF TO if_model_binrel,
    lp_status TYPE sgs_status.

  TRY.
      li_link ?= ei_link.
      li_model = li_link->get_model( ).
    CATCH cx_os cx_sy_move_cast_error cx_obl_model_error .
      RETURN.
  ENDTRY.

  IF li_model->go_role_b->gp_type = 'ATTACHMENT' OR
     li_model->go_role_b->gp_type = 'ANNOTATION' OR
     li_model->go_role_b->gp_type = 'WEB_SITE'.

    IF li_link->get_instid_a( ) = gs_lporb-instid AND
       li_link->get_typeid_a( ) = gs_lporb-typeid AND
       li_link->get_catid_a( )  = gs_lporb-catid.

      lp_status = mp_status_active.

      IF lp_status <> gp_status.

        gp_status = lp_status.

        RAISE EVENT service_changed
          EXPORTING
            ep_status  = lp_status
            eo_service = me
            .
        set handler:
          on_link_created activation space.
*          on_link_deleted activation 'X'.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMETHOD.


METHOD ON_LINK_DELETED .

  DATA:
    li_link TYPE REF TO cl_obl_binrel,
    li_model TYPE REF TO if_model_binrel,
    lp_status TYPE sgs_status,
    li_blink type ref to if_browser_link,
    lo_bitem type ref to cl_browser_item,
    lo_boritem type ref to cl_sobl_bor_item,
    ls_borident type borident.

  TRY.
      li_link ?= ei_link.
      li_model = li_link->get_model( ).

  IF li_model->go_role_b->gp_type = 'ATTACHMENT' OR
     li_model->go_role_b->gp_type = 'ANNOTATION' OR
     li_model->go_role_b->gp_type = 'WEB_SITE'.

     li_blink ?= li_link.
     lo_bitem = li_blink->GO_ITEM_A.
     lo_boritem ?= lo_bitem.
     call method lo_boritem->get_borident
       importing es_borident = ls_borident.

    IF ls_borident-objkey = gs_lporb-instid AND
       ls_borident-objtype = gs_lporb-typeid.

      CALL METHOD check_status
        exporting
          is_lporb = gs_lporb
        importing
          ep_status = lp_status.

      IF lp_status <> gp_status.

        gp_status = lp_status.

        RAISE EVENT service_changed
          EXPORTING
            ep_status  = lp_status
            eo_service = me
            .
      ENDIF.
    ENDIF.
  ENDIF.

    CATCH cx_os cx_sy_move_cast_error cx_obl_model_error .
      RETURN.
  ENDTRY.
ENDMETHOD.


METHOD ON_MODE_CHANGED .
  gp_mode = ep_mode.
  CHECK NOT go_attachment_list IS INITIAL.
  TRY.
      go_attachment_list->set_rwmode( ep_mode ).
    CATCH cx_gos_al_error.
  ENDTRY.
ENDMETHOD.                    "


METHOD ON_SERVICE_CANCELED .
* ...
  SET HANDLER:
    on_service_succeeded FOR ALL INSTANCES ACTIVATION space,
    on_service_canceled FOR ALL INSTANCES ACTIVATION space.
  TRY.
      IF NOT go_attachment_list IS INITIAL.
        SET HANDLER:
          on_commit_required FOR go_attachment_list ACTIVATION space.
        CALL METHOD go_attachment_list->close.
        CLEAR go_attachment_list.
      ENDIF.
    CATCH cx_sobl_browser.
  ENDTRY.

ENDMETHOD.


METHOD ON_SERVICE_SUCCEEDED.
  DATA lo_attachment TYPE REF TO cl_gos_srv_attachment_create.
  DATA lo_note TYPE REF TO cl_gos_srv_note_create.
  DATA lo_url TYPE REF TO cl_gos_srv_url_create.
  DATA lo_arlink TYPE REF TO cl_arl_srv_link.
  DATA lo_barcode TYPE REF TO cl_arl_srv_barcode.
  DATA lp_status TYPE sgs_status.
  DATA lp_new_check TYPE c.

  TRY.
      lo_attachment ?= eo_service.
      lp_new_check = 'X'.
    CATCH cx_sy_move_cast_error.
      TRY.
          lo_note ?= eo_service.
          lp_new_check = 'X'.
        CATCH cx_sy_move_cast_error.
          TRY.
              lo_url ?= eo_service.
              lp_new_check = 'X'.
            CATCH cx_sy_move_cast_error.
              TRY.
                  lo_arlink ?= eo_service.
                  lp_new_check = 'X'.
                CATCH cx_sy_move_cast_error.
                  TRY.
                      lo_barcode ?= eo_service.
                      lp_new_check = 'X'.
                    CATCH cx_sy_move_cast_error.
                  ENDTRY.
              ENDTRY.
          ENDTRY.
      ENDTRY.
  ENDTRY.

  IF lp_new_check = 'X'.
    lp_status = gp_status.
    gp_status = mp_status_active.

    IF lp_status <> gp_status.
      RAISE EVENT service_changed
        EXPORTING
          ep_status  = gp_status
          eo_service = me
          .
      SET HANDLER on_service_succeeded
        FOR ALL INSTANCES ACTIVATION space.
    ENDIF.
  ENDIF.
ENDMETHOD.
ENDCLASS.
