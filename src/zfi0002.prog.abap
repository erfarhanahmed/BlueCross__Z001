*&---------------------------------------------------------------------*
*   Object ID        :
*   Tech Object ID   :
*   Project          :
*   Dev. Class       : Z001
*   Report Name      : ZFI0002
*   Program Type     : Executable Program
*   Created by       :
*   Created on       :
*   Technical head   :
*   Delivery Manager :
*   Func Consultant  :
*   Company name     : Castaliaz Technologies Pvt. Ltd.
*   Transaction Code : ZFI002
*   Module Name      : FI
*   Description      : Employee master data upload
*   Transport No     :
*&-----------------------------------------------------------------------*


REPORT ZFI0002
       NO STANDARD PAGE HEADING LINE-SIZE 255.

TYPES: BEGIN OF record,
         pernr(038),
        choic(035),
        subty(004),
        BEGDA(010),
        ENDDA(010),
        email(240),
       END OF record.

       DATA : it_final TYPE TABLE OF record,
       wa_final TYPE record.
TYPES: BEGIN OF ty_msg,
         id      TYPE bdcmsgcoll-msgtyp,
         message TYPE bdcmsgcoll-msgv1,
       END OF ty_msg.

DATA: it_fieldcatalog TYPE slis_t_fieldcat_alv,
      wa_fieldcatalog TYPE slis_fieldcat_alv,
      gwa_layout      TYPE slis_layout_alv.

DATA: i_msg       TYPE TABLE OF ty_msg WITH HEADER LINE,
      v_file      TYPE rlgrap-filename.

   data lv_info(4) type n.
   data lv_sub(4) type n.

data: IT_BMC TYPE STANDARD TABLE OF bdcmsgcoll,
      WA_BMC TYPE bdcmsgcoll.
DATA V_MSG(100) TYPE C.
DATA : BEGIN OF WA,
LNO TYPE SYTABIX,
  pernr(038),
MSG(100) TYPE C,
END OF WA.

DATA IT LIKE TABLE OF WA.

DATA : it_bdc TYPE TABLE OF bdcdata WITH HEADER LINE,
       it_raw TYPE truxs_t_text_data.

DATA: it_intern   TYPE TABLE OF  alsmex_tabline,
      wa_intern   TYPE  alsmex_tabline,
      filename    TYPE  rlgrap-filename,
      i_begin_col TYPE  i,
      i_begin_row TYPE  i,
      i_end_col   TYPE  i,
      i_end_row   TYPE  i.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS : p_file TYPE ibipparms-path OBLIGATORY.
*               p_mode TYPE ctu_mode OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

DATA : file_name TYPE ibipparms-path.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  CALL FUNCTION 'F4_FILENAME'
*    EXPORTING
*      program_name  = syst-cprog
*      dynpro_number = syst-dynnr
*      field_name    = ' '
    IMPORTING
      file_name = p_file.



start-of-selection.

START-OF-SELECTION.
  PERFORM get_file_data.
  PERFORM data_upload.
**  PERFORM message_display.
**  PERFORM display.

FORM data_upload .

  CALL FUNCTION 'BDC_OPEN_GROUP'
 EXPORTING
*   CLIENT                    = SY-MANDT
*   DEST                      = FILLER8
   GROUP                     = 'PA30'
*   HOLDDATE                  = FILLER8
   KEEP                      = 'X'
   USER                      = SY-UNAME
*   RECORD                    = FILLER1
   PROG                      = SY-CPROG
*   DCPFM                     = '%'
*   DATFM                     = '%'
*   APP_AREA                  = FILLER12
*   LANGU                     = SY-LANGU
* IMPORTING
*   QID                       =
* EXCEPTIONS
*   CLIENT_INVALID            = 1
*   DESTINATION_INVALID       = 2
*   GROUP_INVALID             = 3
*   GROUP_IS_LOCKED           = 4
*   HOLDDATE_INVALID          = 5
*   INTERNAL_ERROR            = 6
*   QUEUE_ERROR               = 7
*   RUNNING                   = 8
*   SYSTEM_LOCK_ERROR         = 9
*   USER_INVALID              = 10
*   OTHERS                    = 11
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.


  LOOP AT it_final INTO wa_final.
     WA-LNO = SY-TABIX.
*  wa-pernr = wa_final-pernr.
     if wa_final-subty = '0010'.
perform bdc_dynpro      using 'SAPMP50A' '1000'.
perform bdc_field       using 'BDC_OKCODE'
                              '=INS'.
perform bdc_field       using 'RP50G-PERNR'
                              wa_final-pernr.   "'1016'.
perform bdc_field       using 'RP50G-TIMR6'
                              'X'.
perform bdc_field       using 'BDC_CURSOR'
                              'RP50G-SUBTY'.
perform bdc_field       using 'RP50G-CHOIC'
                              wa_final-choic.   "'0105'.
perform bdc_field       using 'RP50G-SUBTY'
                              wa_final-subty.  "'0010'.
perform bdc_dynpro      using 'MP010500' '2000'.
perform bdc_field       using 'BDC_CURSOR'
                              'P0105-USRID_LONG'.
perform bdc_field       using 'BDC_OKCODE'
                              '=UPD'.
perform bdc_field       using 'P0105-BEGDA'
                              wa_final-begda.   "'27.09.2022'.
perform bdc_field       using 'P0105-ENDDA'
                              wa_final-endda.  "'31.12.9999'.
perform bdc_field       using 'P0105-USRID_LONG'
                              wa_final-email.

ELSEIF wa_final-subty = '0001'.
perform bdc_dynpro      using 'SAPMP50A' '1000'.
perform bdc_field       using 'BDC_OKCODE'
                              '=INS'.
perform bdc_field       using 'RP50G-PERNR'
                              wa_final-pernr.  "'1475'.
perform bdc_field       using 'RP50G-TIMR6'
                              'X'.
perform bdc_field       using 'BDC_CURSOR'
                              'RP50G-SUBTY'.
perform bdc_field       using 'RP50G-CHOIC'
                               wa_final-choic. "'Communication'.
perform bdc_field       using 'RP50G-SUBTY'
                               wa_final-subty. "'0001'.
perform bdc_dynpro      using 'MP010500' '2000'.
perform bdc_field       using 'BDC_CURSOR'
                              'P0105-USRID'.
perform bdc_field       using 'BDC_OKCODE'
                              '=UPD'.
perform bdc_field       using 'P0105-BEGDA'
                               wa_final-begda.  "'01.04.2022'.
perform bdc_field       using 'P0105-ENDDA'
                               wa_final-endda.  "'31.12.9999'.
perform bdc_field       using 'P0105-USRID'
                                wa_final-email.   "'madhuri'.
ENDIF.

CALL FUNCTION 'BDC_INSERT'
 EXPORTING
   TCODE                  = 'PA30'
*   POST_LOCAL             = NOVBLOCAL
*   PRINTING               = NOPRINT
*   SIMUBATCH              = ' '
*   CTUPARAMS              = ' '
  TABLES
    dynprotab              = it_bdc[]
* EXCEPTIONS
*   INTERNAL_ERROR         = 1
*   NOT_OPEN               = 2
*   QUEUE_ERROR            = 3
*   TCODE_INVALID          = 4
*   PRINTING_INVALID       = 5
*   POSTING_INVALID        = 6
*   OTHERS                 = 7
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

REFRESH it_bdc.

*     CALL TRANSACTION 'PA30' USING it_bdc  MODE p_mode UPDATE 'S' MESSAGES INTO IT_BMC.

***    LOOP AT IT_BMC INTO WA_BMC.
***   CALL FUNCTION 'FORMAT_MESSAGE'
***   EXPORTING
***     ID = WA_BMC-MSGID
***     LANG = SY-LANGU
***     NO = WA_BMC-MSGNR
***     V1 = WA_BMC-MSGV1
***     V2 = WA_BMC-MSGV2
***     V3 = WA_BMC-MSGV3
***     V4 = WA_BMC-MSGV4
***
***   IMPORTING
***     MSG = V_MSG.
****     WA-LNO = SY-TABIX.
***     WA-MSG = V_MSG.
***     APPEND WA TO IT.
***     clear: wa, v_msg.
***     endloop.
***     REFRESH: it_bdc[].
*** refresh it_bmc.
  ENDLOOP.

  WRITE:/ 'Please go to tcode- SM35 for the session : PA30'.

  CALL FUNCTION 'BDC_CLOSE_GROUP'
* EXCEPTIONS
*   NOT_OPEN          = 1
*   QUEUE_ERROR       = 2
*   OTHERS            = 3
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_file_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_file_data .
filename = p_file.
  i_begin_col = '1'.
  i_begin_row = 2.
  i_end_col   = 9999.
  i_end_row   = 9999.

  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = filename
      i_begin_col             = i_begin_col
      i_begin_row             = i_begin_row
      i_end_col               = i_end_col
      i_end_row               = i_end_row
    TABLES
      intern                  = it_intern
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  LOOP AT it_intern INTO wa_intern.

    CASE wa_intern-col.
      WHEN '0001'.
       wa_final-pernr = wa_intern-value.
      WHEN '0002'.
        lv_info = wa_intern-value.
        wa_final-choic = lv_info.
      WHEN '0003'.
        lv_sub = wa_intern-value..
        wa_final-subty = lv_sub.
      when '0004'.
          wa_final-BEGDA = wa_intern-value.
      when '0005'.
           wa_final-endda = wa_intern-value.
      WHEN '0006'.
        wa_final-email = wa_intern-value.
    ENDCASE.
    AT END OF row.
      APPEND wa_final TO it_final.
      CLEAR wa_final.
    ENDAT.
    CLEAR: wa_intern, lv_info, lv_sub.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form message_display
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
**FORM message_display .
**  wa_fieldcatalog-fieldname   = 'LNO'.
**  wa_fieldcatalog-seltext_l   = 'SR.NO'.
**  wa_fieldcatalog-col_pos   = '1'.
**  APPEND wa_fieldcatalog to it_fieldcatalog.
**  clear: wa_fieldcatalog.
**wa_fieldcatalog-fieldname   = 'PERNR'.
**  wa_fieldcatalog-seltext_l   = 'persnl no.'.
**  wa_fieldcatalog-col_pos   = '2'.
**  APPEND wa_fieldcatalog to it_fieldcatalog.
**  clear: wa_fieldcatalog.
**  wa_fieldcatalog-fieldname   = 'MSG'.
**  wa_fieldcatalog-seltext_l   = 'MESSAGE'.
**  wa_fieldcatalog-col_pos   = '3'.
**  APPEND wa_fieldcatalog to it_fieldcatalog.
**  clear: wa_fieldcatalog.
**
**ENDFORM.
*&---------------------------------------------------------------------*
*& Form display
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
***FORM display .
*** DATA: gd_repid TYPE sy-repid.
***
***  gd_repid = sy-repid.
***
***  gwa_layout-colwidth_optimize = 'X'.
***  gwa_layout-zebra             = 'X'.
***  gwa_layout-info_fieldname    = 'LCOL'.
***
****  IF NOT i_msg[] IS INITIAL.
***  IF NOT IT IS INITIAL.
***
***    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
***      EXPORTING
***        i_callback_program = gd_repid
***        is_layout          = gwa_layout
***        it_fieldcat        = it_fieldcatalog
***        i_save             = 'A'
***      TABLES
***        t_outtab           =    IT  "i_msg[]
***      EXCEPTIONS
***        program_error      = 1
***        OTHERS             = 2.
***
***  ENDIF.
***
***ENDFORM.

FORM bdc_field USING fnam fval.
  CLEAR it_bdc.
  it_bdc-fnam = fnam.
  it_bdc-fval = fval.
  APPEND it_bdc.
ENDFORM.

FORM bdc_dynpro USING program dynpro.
  CLEAR it_bdc.
  it_bdc-program  = program.
  it_bdc-dynpro   = dynpro.
  it_bdc-dynbegin = 'X'.
  APPEND it_bdc.
ENDFORM.
