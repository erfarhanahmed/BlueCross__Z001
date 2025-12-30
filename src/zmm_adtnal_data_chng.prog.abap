*&---------------------------------------------------------------------*
*& Report ZMM_ADTNAL_DATA_CHNG
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMM_ADTNAL_DATA_CHNG.


INCLUDE ZMM_ADTNAL_DATA_CHNG_TOP.

INCLUDE ZMM_ADTNAL_DATA_CHNG_SEL.

INCLUDE ZMM_ADTNAL_DATA_CHNG_FORMS.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.

  PERFORM: F_GET_F4_VAL.    "Get file name

  START-OF-SELECTION.

* Uploading the data in the file into internal table

  PERFORM: f_get_data.

* Updating the data from internal table to screen

  PERFORM: f_change_data.

*  Display Error & Success Messages

  PERFORM: f_Disp_msg.
