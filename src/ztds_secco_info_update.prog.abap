*&---------------------------------------------------------------------*
*& Report ZTDS_SECCO_INFO_UPDATE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTDS_SECCO_INFO_UPDATE.

TYPE-POOLS: truxs .

types : begin of record,
BUKRS(4),  "companycode
KOART(1),
ACCNO(10), "V/C accnt
*FIWTIN_TANEX_SUB
  FIWTIN_TANEX_SUB(1),
SECCODE(4), "Sect. Code
WITHT(2), "Withhld tax type
WT_WITHCD(2), "W/tax code
WT_EXDF(10), " exempt from
pan(40),"
WT_EXDT(10), " Exempt To
WT_EXNR(25), "Exemption number
WT_EXRT(10)   , "Exemption rate
"WT_EXRT type WT_EXRT   , "Exemption rate
WT_WTEXRS(2), " Exemption reas.
FIWTIN_EXEM_THR(20), "Exem threshold
WAERS(5), "Currency

      end of record.

DATA : it_upload TYPE TABLE OF record.
DATA : wa_upload TYPE record.
DATA : wa_excel TYPE alsmex_tabline, "Excel data
       t_excel TYPE STANDARD TABLE OF alsmex_tabline.
DATA : it_msg  TYPE TABLE OF bdcmsgcoll,
       it_msg1 TYPE TABLE OF bdcmsgcoll,
       wa_msg  TYPE bdcmsgcoll,
       wa_msg1 TYPE bdcmsgcoll.
data: it_tan type table of FIWTIN_TAN_EXEM,
      wa_tan type FIWTIN_TAN_EXEM.
data: it_tan1 type table of FIWTIN_TAN_EXEM,
      wa_tan1 type FIWTIN_TAN_EXEM.
TYPES:BEGIN OF error_type,
BUKRS	type BUKRS,
*KOART  type  KOART,
ACCNO	type 	WT_ACNO,
*FIWTIN_TANEX_SUB	type 	FIWTIN_TANEX_SUB
SECCODE	type 	SECCO,
WITHT   type  WITHT,
WT_WITHCD	type WT_WITHCD,
WT_EXDF	type WT_EXDF,
PAN_NO  type J_1IPANNO,
 text  TYPE string,       " text
      END OF error_type.

data: it_error type table of error_type,
      wa_error type error_type.

DATA : it_raw TYPE truxs_t_text_data.

data:       lv_prog     TYPE sy-repid,
      gd_layout   TYPE slis_layout_alv,
             wa_fcat    TYPE slis_fieldcat_alv,
       it_fcat    TYPE slis_t_fieldcat_alv.


CONSTANTS:
*abap_true TYPE abap_bool VALUE 'X',
  grid_tit  TYPE lvc_title VALUE 'Error Details'.

SELECTION-SCREEN BEGIN OF BLOCK blck WITH FRAME TITLE text-000.
PARAMETERS : f_path   TYPE rlgrap-filename.
*PARAMETERS : CBOX     AS CHECKBOX DEFAULT 'X'.                  " File Path
SELECTION-SCREEN END OF BLOCK blck.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR f_path.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = 'F_PATH'
    IMPORTING
      file_name     = f_path.


   START-OF-SELECTION.

   PERFORM GET_DATA.
   PERFORM UPLOAD_DATA.
   perform error_disp.

FORM get_data.

TYPES:fs_struct(4096) TYPE c OCCURS 0.
DATA:w_struct TYPE fs_struct.

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
      i_field_seperator    = 'X'
      i_line_header        = 'X'
      i_tab_raw_data       = w_struct
      i_filename           = f_path
    TABLES
      i_tab_converted_data = it_upload
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UPLOAD_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM upload_data .


  LOOP AT it_upload INTO wa_upload.


"MOVE-CORRESPONDING wa_upload to wa_tan.

"wa_tan = CORRESPONDING #( wa_upload  ).
wa_tan-bukrs = wa_upload-bukrs.
wa_tan-koart = wa_upload-koart.

wa_tan-accno = wa_upload-accno.
wa_tan-FIWTIN_TANEX_SUB = wa_upload-FIWTIN_TANEX_SUB.
wa_tan-seccode = wa_upload-seccode.
wa_tan-witht = wa_upload-witht.
wa_tan-wt_withcd = wa_upload-wt_withcd.
wa_tan-WT_EXDF = wa_upload-WT_EXDF.
wa_tan-pan_no = wa_upload-pan.
wa_tan-WT_EXDT = wa_upload-wt_exdt.
wa_tan-WT_EXNR = wa_upload-wt_exnr.
wa_tan-wt_exrt = wa_upload-wt_exrt.  "commented due to type, Need to check again
wa_tan-WT_WTEXRS = wa_upload-WT_WTEXRS.
wa_tan-FIWTIN_EXEM_THR = wa_upload-fiwtin_exem_thr. " commenred due to type,Need to chek again
wa_tan-WAERS = wa_upload-WAERS.




CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
  EXPORTING
    INPUT         = wa_tan-accno
 IMPORTING
   OUTPUT        = wa_tan-accno
          .


 wa_tan-MANDT = sy-mandt.

select single J_1IPANNO from LFA1 into wa_tan-PAN_NO where lifnr = wa_tan-accno.

* wa_tan-KOART = 'K'.

concatenate wa_upload-WT_EXDF+6(4) wa_upload-WT_EXDF+3(2) wa_upload-WT_EXDF+0(2)
    into wa_tan-WT_EXDF.

concatenate wa_upload-WT_EXDT+6(4) wa_upload-WT_EXDT+3(2) wa_upload-WT_EXDT+0(2)
    into wa_tan-WT_EXDT.

append wa_tan to it_tan.
clear wa_tan.


  ENDLOOP.

if it_tan is not initial.

    TRY.
        INSERT FIWTIN_TAN_EXEM FROM TABLE it_tan ."ACCEPTING DUPLICATE KEYS.
        IF sy-subrc = 0.
          COMMIT WORK.
          MESSAGE 'Uplaoded Successfully' TYPE 'I'.
        ELSE.
          MESSAGE 'Error' TYPE 'I'.
        ENDIF.

      CATCH cx_root.

        SELECT * FROM FIWTIN_TAN_EXEM INTO TABLE it_tan1
           FOR ALL ENTRIES IN it_tan WHERE BUKRS = it_tan-bukrs
and ACCNO = it_tan-ACCNO
and SECCODE = it_tan-SECCODE
and WITHT = it_tan-WITHT
and WT_WITHCD = it_tan-WT_WITHCD
and WT_EXDF = it_tan-WT_EXDF
and PAN_NO = it_tan-PAN_NO.

        LOOP AT it_tan INTO wa_tan.

          READ TABLE it_tan1 INTO wa_tan1 WITH KEY bukrs = wa_tan-bukrs
                                    ACCNO = wa_tan-ACCNO
                                    SECCODE = wa_tan-SECCODE
                                    WITHT = wa_tan-WITHT
                                    WT_WITHCD = wa_tan-WT_WITHCD
                                    WT_EXDF = wa_tan-WT_EXDF
                                    PAN_NO = wa_tan-PAN_NO.
          IF sy-subrc = 0.
  wa_error-bukrs = wa_tan1-bukrs.
  wa_error-ACCNO = wa_tan1-ACCNO.
  wa_error-SECCODE = wa_tan1-SECCODE.
  wa_error-WITHT = wa_tan1-WITHT.
  wa_error-WT_WITHCD = wa_tan1-WT_WITHCD.
  wa_error-WT_EXDF = wa_tan1-WT_EXDF.
  wa_error-PAN_NO = wa_tan1-PAN_NO.
  wa_error-text = 'Duplicate Record'.
      APPEND wa_error TO it_error.
      CLEAR wa_error.
          ENDIF.

        ENDLOOP.

        MESSAGE 'Duplicate Record found' TYPE 'I'.


 ENDTRY.

endif.



ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  ERROR_DISP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ERROR_DISP .
  lv_prog = sy-repid.
  gd_layout-zebra = 'X'.
  gd_layout-colwidth_optimize = 'X'.

  PERFORM build_fcat USING 'BUKRS'  'Company Code'  .
  PERFORM build_fcat USING 'ACCNO'  'Vendor/customer account number'  .
  PERFORM build_fcat USING 'SECCODE'  'Section Code'  .
  PERFORM build_fcat USING 'WITHT'  'Indicator for wh tax type'  .
  PERFORM build_fcat USING 'WT_WITHCD'  'Withholding tax code'  .
  PERFORM build_fcat USING 'WT_EXDF'  'Exemption from'  .
  PERFORM build_fcat USING 'PAN_NO'  'Pan Number'  .
  PERFORM build_fcat USING 'TEXT'  'Error Description'  .

  IF it_error IS NOT INITIAL.
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program = lv_prog
        i_grid_title       = grid_tit
        is_layout          = gd_layout
        it_fieldcat        = it_fcat[]
      TABLES
        t_outtab           = it_error[]
      EXCEPTIONS
        program_error      = 1
        OTHERS             = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.
ENDFORM.


FORM build_fcat USING fieldname
                      text.
  CLEAR wa_fcat.
  wa_fcat-fieldname   = fieldname.
  wa_fcat-seltext_l   = text.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
ENDFORM.
