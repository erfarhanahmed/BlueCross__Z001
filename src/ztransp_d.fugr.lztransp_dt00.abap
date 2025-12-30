*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTRANSP_D.......................................*
DATA:  BEGIN OF STATUS_ZTRANSP_D                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTRANSP_D                     .
CONTROLS: TCTRL_ZTRANSP_D
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZTRANSP_D                     .
TABLES: ZTRANSP_D                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
