*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZV_TPARA........................................*
TABLES: ZV_TPARA, *ZV_TPARA. "view work areas
CONTROLS: TCTRL_ZV_TPARA
TYPE TABLEVIEW USING SCREEN '9000'.
DATA: BEGIN OF STATUS_ZV_TPARA. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZV_TPARA.
* Table for entries selected to show on screen
DATA: BEGIN OF ZV_TPARA_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZV_TPARA.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZV_TPARA_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZV_TPARA_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZV_TPARA.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZV_TPARA_TOTAL.

*.........table declarations:.................................*
TABLES: TPARA                          .
