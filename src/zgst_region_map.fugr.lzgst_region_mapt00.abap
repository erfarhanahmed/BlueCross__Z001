*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZGST_REGION_MAP.................................*
DATA:  BEGIN OF STATUS_ZGST_REGION_MAP               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZGST_REGION_MAP               .
CONTROLS: TCTRL_ZGST_REGION_MAP
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZGST_REGION_MAP               .
TABLES: ZGST_REGION_MAP                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
