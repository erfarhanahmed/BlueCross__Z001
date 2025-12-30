*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZPO_MATNR.......................................*
DATA:  BEGIN OF STATUS_ZPO_MATNR                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZPO_MATNR                     .
CONTROLS: TCTRL_ZPO_MATNR
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZPO_MATNR                     .
TABLES: ZPO_MATNR                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
