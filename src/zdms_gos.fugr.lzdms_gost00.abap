*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZDMS_GOS........................................*
DATA:  BEGIN OF STATUS_ZDMS_GOS                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZDMS_GOS                      .
CONTROLS: TCTRL_ZDMS_GOS
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZDMS_GOS                      .
TABLES: ZDMS_GOS                       .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
