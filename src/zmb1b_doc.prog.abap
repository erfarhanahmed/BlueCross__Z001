*&---------------------------------------------------------------------*
*& Report ZMB1B_DOC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMB1B_DOC.
selection-screen begin of block merkmale1 with frame title text-001.
PARAMETERS : R1 RADIOBUTTON GROUP R1,
             R2 RADIOBUTTON GROUP R1.
selection-screen end of block merkmale1.

IF R1 EQ 'X'.
  CALL TRANSACTION 'ZTRF_CHALLAN1'.
ELSEIF R2 EQ 'X'.
  CALL TRANSACTION 'ZTRF_CHALLAN2'.
ENDIF.
