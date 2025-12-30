"Name: \TY:CL_IM_FIN_GOS_HTMLGUI\IN:IF_EX_GOS_SRV_SELECT\ME:SELECT_SERVICES\SE:END\EI
ENHANCEMENT 0 ZGOS_SRV_SELECTION.
CLEAR ls_option.
 ls_option-sign   = 'I'.
      ls_option-option = 'EQ'.
      ls_option-low    = 'ARL_LINK'.
      APPEND ls_option TO et_options.

       CLEAR ls_option.
      ls_option-sign   = 'I'.
      ls_option-option = 'EQ'.
      ls_option-low    = 'VIEW_ATTA'.
      APPEND ls_option TO et_options.

IF sy-tcode = 'ME21N' or sy-tcode = 'ME22N' or sy-tcode = 'ME23N'.

      CLEAR ls_option.
      ls_option-sign   = 'I'.
      ls_option-option = 'EQ'.
      ls_option-low    = 'WF_OVERVIEW'.
      APPEND ls_option TO et_options.

        CLEAR ls_option.
      ls_option-sign   = 'I'.
      ls_option-option = 'EQ'.
      ls_option-low    = 'WF_ARCHIVE'.
      APPEND ls_option TO et_options.

        CLEAR ls_option.
      ls_option-sign   = 'I'.
      ls_option-option = 'EQ'.
      ls_option-low    = 'WF_START'.
      APPEND ls_option TO et_options.

ENDIF.

ENDENHANCEMENT.
