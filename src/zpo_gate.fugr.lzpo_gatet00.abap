*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZPO_GATE........................................*
DATA:  BEGIN OF STATUS_ZPO_GATE                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZPO_GATE                      .
CONTROLS: TCTRL_ZPO_GATE
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZPO_GATE                      .
TABLES: ZPO_GATE                       .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
