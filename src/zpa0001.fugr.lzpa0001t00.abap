*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZPA0001.........................................*
DATA:  BEGIN OF STATUS_ZPA0001                       .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZPA0001                       .
CONTROLS: TCTRL_ZPA0001
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZPA0001                       .
TABLES: ZPA0001                        .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
