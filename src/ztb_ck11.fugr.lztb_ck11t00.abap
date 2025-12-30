*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTB_CK11........................................*
DATA:  BEGIN OF STATUS_ZTB_CK11                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTB_CK11                      .
CONTROLS: TCTRL_ZTB_CK11
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZTB_CK11                      .
TABLES: ZTB_CK11                       .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
