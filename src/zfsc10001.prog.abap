*&---------------------------------------------------------------------*
*& Report  ZFS_UPLOAD
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zfsc10001.

INCLUDE zfsc10001_top.
INCLUDE zfsc10001_scr.
INCLUDE zfsc10001_form.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_local.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
    IMPORTING
      file_name     = p_local.

START-OF-SELECTION.
  PERFORM convert_xl_itab.
  PERFORM fill_bdcdata_call_txn.
  PERFORM display_report.
*  perform fill_bapi.
