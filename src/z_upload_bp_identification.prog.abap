REPORT z_upload_bp_identification.

*---------------------------------------------------------------------
* Internal table and structure declarations
*---------------------------------------------------------------------
TYPES: BEGIN OF ty_input,
         bp_number  TYPE bu_partner,
         id_cat     TYPE bapibus1006_identification_key-identificationcategory,
         id_no      TYPE bapibus1006_identification_key-identificationnumber,
         valid_from TYPE char10,
         valid_to   TYPE char10,
       END OF ty_input.

DATA: lt_input    TYPE TABLE OF ty_input,
      ls_input    TYPE ty_input,
      lt_return   TYPE TABLE OF bapiret2,
      ls_return   TYPE bapiret2,
      lv_filename TYPE rlgrap-filename.

DATA: gt_raw TYPE truxs_t_text_data.

*---------------------------------------------------------------------
* File upload section
*---------------------------------------------------------------------
PARAMETERS: p_file TYPE rlgrap-filename OBLIGATORY.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = ' '
    IMPORTING
      file_name     = p_file.

START-OF-SELECTION.
  lv_filename  =  p_file.

START-OF-SELECTION.

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
      i_field_seperator    = 'X'
      i_line_header        = 'X'
      i_tab_raw_data       = gt_raw
      i_filename           = p_file
*     I_STEP               = 1
*     I_FILENAME_LONG      =
    TABLES
      i_tab_converted_data = lt_input
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF sy-subrc <> 0.
    WRITE: / 'Error uploading file:', p_file.
    EXIT.
  ENDIF.

  WRITE: / 'Total records read:', lines( lt_input ).

*---------------------------------------------------------------------
* Loop through each record and call BAPI
*---------------------------------------------------------------------
  LOOP AT lt_input INTO ls_input.

    CLEAR: lt_return, ls_return.



    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = ls_input-bp_number
      IMPORTING
        output = ls_input-bp_number.



    DATA: ls_ident TYPE bapibus1006_identification.

*    CONCATENATE ls_input-valid_from+6(4) ls_input-valid_from+3(2)   ls_input-valid_from+0(2) INTO ls_ident-idvalidfromdate .
*    CONCATENATE ls_input-valid_to+6(4) ls_input-valid_to+3(2)   ls_input-valid_from+0(2) INTO ls_ident-idvalidtodate .

" valid_from = DD-MM-YYYY
CONCATENATE ls_input-valid_from+6(4)   " YYYY
            ls_input-valid_from+3(2)   " MM
            ls_input-valid_from+0(2)   " DD
       INTO ls_ident-idvalidfromdate.

" valid_to = DD-MM-YYYY
CONCATENATE ls_input-valid_to+6(4)
            ls_input-valid_to+3(2)
            ls_input-valid_to+0(2)
       INTO ls_ident-idvalidtodate.


    CALL FUNCTION 'BAPI_IDENTIFICATION_ADD'
      EXPORTING
        businesspartner        = ls_input-bp_number
        identificationcategory = ls_input-id_cat
        identificationnumber   = ls_input-id_no
        identification         = ls_ident
      TABLES
        return                 = lt_return.


    READ TABLE lt_return INTO ls_return WITH KEY type = 'E'.
    IF sy-subrc = 0.
      WRITE: / 'BP:', ls_input-bp_number, ' -> ERROR:', ls_return-message.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.

      WRITE: / 'All records processed successfully.'.
      WRITE: / 'BP:', ls_input-bp_number, ' -> Identification Added OK'.
    ENDIF.

  ENDLOOP.

*---------------------------------------------------------------------
** Commit the LUW after all BAPI calls
**---------------------------------------------------------------------
*  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*    EXPORTING
*      wait = 'X'.
*
*  WRITE: / 'All records processed successfully.'.
