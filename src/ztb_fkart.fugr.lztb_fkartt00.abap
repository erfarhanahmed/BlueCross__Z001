*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTB_FKART.......................................*
DATA:  BEGIN OF STATUS_ZTB_FKART                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTB_FKART                     .
CONTROLS: TCTRL_ZTB_FKART
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZTB_FKART                     .
TABLES: ZTB_FKART                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
