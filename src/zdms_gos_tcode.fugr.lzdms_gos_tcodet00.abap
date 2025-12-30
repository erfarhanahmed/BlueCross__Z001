*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZDMS_GOS_TCODE..................................*
DATA:  BEGIN OF STATUS_ZDMS_GOS_TCODE                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZDMS_GOS_TCODE                .
CONTROLS: TCTRL_ZDMS_GOS_TCODE
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZDMS_GOS_TCODE                .
TABLES: ZDMS_GOS_TCODE                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
