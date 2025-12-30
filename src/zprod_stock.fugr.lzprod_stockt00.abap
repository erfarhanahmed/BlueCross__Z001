*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZPROD_STOCK.....................................*
DATA:  BEGIN OF STATUS_ZPROD_STOCK                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZPROD_STOCK                   .
CONTROLS: TCTRL_ZPROD_STOCK
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZPROD_STOCK                   .
TABLES: ZPROD_STOCK                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
