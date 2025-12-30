*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZGRN_LABEL......................................*
DATA:  BEGIN OF STATUS_ZGRN_LABEL                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZGRN_LABEL                    .
CONTROLS: TCTRL_ZGRN_LABEL
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZGRN_LABEL                    .
TABLES: ZGRN_LABEL                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
