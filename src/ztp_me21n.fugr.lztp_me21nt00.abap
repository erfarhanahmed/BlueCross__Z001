*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTP_ME21N.......................................*
DATA:  BEGIN OF STATUS_ZTP_ME21N                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTP_ME21N                     .
CONTROLS: TCTRL_ZTP_ME21N
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZTP_ME21N                     .
TABLES: ZTP_ME21N                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
