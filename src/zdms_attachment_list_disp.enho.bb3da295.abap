"Name: \TY:CL_GOS_TOOLBOX_MODEL\ME:CREATE_SERVICE\SE:END\EI
ENHANCEMENT 0 ZDMS_ATTACHMENT_LIST_DISP.

if IS_ATTRIBUTES-CLSNAME  = 'ZCL_GOS_SRV_ATTACHMENT_LIST' and   IS_ATTRIBUTES-name = 'VIEW_ATTA'.
EP_STATUS = '0'.
*
if sy-tcode is not INITIAL.
data lv_inid type char70.
lv_inid = gs_object-instid.
concatenate gs_object-instid '-' sy-tcode into gs_object-instid.
CALL METHOD eo_service->set_object
          EXPORTING
            is_lporb             = gs_object
            ip_default_attribute = lp_defattrib
            ip_mode              = gp_mode
            ip_cmode             = gp_no_commit
            io_model             = me
          IMPORTING
            ep_status            = ep_status
            ep_icon              = ep_icon.
gs_object-instid = lv_inid.
ep_status = 0.
endif.
endif.

if IS_ATTRIBUTES-CLSNAME  = 'ZCL_GOS_SRV_ATTACHMENT_CREATE' and   IS_ATTRIBUTES-name = 'PCATTA_CREA'.
if sy-tcode is not INITIAL.
concatenate gs_object-instid '-' sy-tcode into gs_object-instid.
CALL METHOD eo_service->set_object
          EXPORTING
            is_lporb             = gs_object
            ip_default_attribute = lp_defattrib
            ip_mode              = gp_mode
            ip_cmode             = gp_no_commit
            io_model             = me
          IMPORTING
            ep_status            = ep_status
            ep_icon              = ep_icon.
endif.
endif.

ENDENHANCEMENT.
