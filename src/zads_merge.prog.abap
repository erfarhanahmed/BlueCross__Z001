*&---------------------------------------------------------------------*
*& Report ZADS_MERGE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zads_merge.

SELECTION-SCREEN : BEGIN OF BLOCK a WITH FRAME TITLE TEXT-001.
  PARAMETERS : r_zads      RADIOBUTTON GROUP a MODIF ID abc.
*  PARAMETERS : r_zfgin RADIOBUTTON GROUP a MODIF ID abc .
  PARAMETERS : r_zpmrm RADIOBUTTON GROUP a MODIF ID abc.
*  PARAMETERS : r_zstab RADIOBUTTON GROUP a MODIF ID abc.
SELECTION-SCREEN : END OF BLOCK a .

* Initialize variables
DATA: lv_selection TYPE string.

START-OF-SELECTION.

* Determine which radio button was selected
  IF r_zads = 'X'.
    lv_selection = 'ZADS'.
*  ELSEIF r_zfgin = 'X'.
**    lv_selection = 'ZFGINSP'.
*      lv_selection = 'ZFGINSPNEW'.
  ELSEIF r_zpmrm = 'X'.
    lv_selection = 'ZPMRMROA'.
*  ELSEIF r_zstab = 'X'.
*    lv_selection = 'ZSTAB_ADS'.
  ENDIF.

* Call the corresponding function based on the selection
  CASE lv_selection.
    WHEN 'ZADS'.
      PERFORM execute_zads.
    WHEN 'ZFGINSP'.
      PERFORM execute_zfginsp.
    WHEN 'ZPMRMROA'.
      PERFORM execute_zpmrmroa.
    WHEN 'ZSTAB_ADS'.
      PERFORM execute_zstab_ads.
    WHEN OTHERS.
      WRITE: 'No valid option selected.'.
  ENDCASE.

FORM execute_zads.

  CALL TRANSACTION 'ZADS_N'.
ENDFORM.

FORM execute_zfginsp.

   CALL TRANSACTION 'ZFGINSP'.
ENDFORM.

FORM execute_zpmrmroa.
*  WRITE: / 'Executing functionality for ZPMRMROA'.
  CALL TRANSACTION 'ZPMRMROA'.
  " Insert current ZPMRMROA logic here
ENDFORM.

FORM execute_zstab_ads.
*  WRITE: / 'Executing functionality for ZSTAB_ADS'.
    CALL TRANSACTION 'ZSTAB_ADS'.
  " Insert current ZSTAB_ADS logic here
ENDFORM.
