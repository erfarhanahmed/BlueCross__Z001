*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZDEV1...........................................*
DATA:  BEGIN OF STATUS_ZDEV1                         .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZDEV1                         .
CONTROLS: TCTRL_ZDEV1
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZDEV1                         .
TABLES: ZDEV1                          .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
