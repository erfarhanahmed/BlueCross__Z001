*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZPASSW..........................................*
DATA:  BEGIN OF STATUS_ZPASSW                        .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZPASSW                        .
CONTROLS: TCTRL_ZPASSW
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZPASSW                        .
TABLES: ZPASSW                         .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
