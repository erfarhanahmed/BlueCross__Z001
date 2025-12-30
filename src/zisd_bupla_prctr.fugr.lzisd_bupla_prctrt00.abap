*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZISD_BUPLA_PRCTR................................*
DATA:  BEGIN OF STATUS_ZISD_BUPLA_PRCTR              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZISD_BUPLA_PRCTR              .
CONTROLS: TCTRL_ZISD_BUPLA_PRCTR
            TYPE TABLEVIEW USING SCREEN '9000'.
*.........table declarations:.................................*
TABLES: *ZISD_BUPLA_PRCTR              .
TABLES: ZISD_BUPLA_PRCTR               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
