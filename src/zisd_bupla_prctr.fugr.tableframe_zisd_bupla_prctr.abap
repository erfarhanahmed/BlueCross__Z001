*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZISD_BUPLA_PRCTR
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZISD_BUPLA_PRCTR   .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
