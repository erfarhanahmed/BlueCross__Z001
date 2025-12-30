*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZIR1_EXCLUDE....................................*
DATA:  BEGIN OF STATUS_ZIR1_EXCLUDE                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZIR1_EXCLUDE                  .
CONTROLS: TCTRL_ZIR1_EXCLUDE
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZIR1_EXCLUDE                  .
TABLES: ZIR1_EXCLUDE                   .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
