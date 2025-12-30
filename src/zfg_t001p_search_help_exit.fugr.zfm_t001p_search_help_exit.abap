FUNCTION ZFM_T001P_SEARCH_HELP_EXIT.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  TABLES
*"      SHLP_TAB TYPE  SHLP_DESCT
*"      RECORD_TAB STRUCTURE  SEAHLPRES
*"  CHANGING
*"     REFERENCE(SHLP) TYPE  SHLP_DESCR
*"     REFERENCE(CALLCONTROL) TYPE  DDSHF4CTRL
*"----------------------------------------------------------------------


CASE callcontrol-step.
  WHEN 'SELONE'.
  WHEN 'PRESEL1'.
    when 'SELECT'.
      when 'DISP'.
*        loop at record_tab.
**        IF record_tab-string+21(4) <> gv_werks.
**        DELETE record_tab INDEX sy-tabix.
**        ENDIF.
*        ENDLOOP.
        delete ADJACENT DUPLICATES FROM record_tab COMPARING string.

  WHEN 'RETURN'.
ENDCASE.



ENDFUNCTION.
