*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZINSP...........................................*
DATA:  BEGIN OF STATUS_ZINSP                         .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZINSP                         .
CONTROLS: TCTRL_ZINSP
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZINSP                         .
TABLES: ZINSP                          .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
