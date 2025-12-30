*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZPMS_ART_TABLE..................................*
DATA:  BEGIN OF STATUS_ZPMS_ART_TABLE                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZPMS_ART_TABLE                .
CONTROLS: TCTRL_ZPMS_ART_TABLE
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZPMS_ART_TABLE                .
TABLES: ZPMS_ART_TABLE                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
