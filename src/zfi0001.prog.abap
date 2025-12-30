****&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*   Object ID        :
*   Tech Object ID   :
*   Project          :
*   Dev. Class       : Z001
*   Report Name      : ZFI0001
*   Program Type     : Executable Program
*   Created by       :
*   Created on       :
*   Technical head   :
*   Delivery Manager :
*   Func Consultant  :
*   Company name     : Castaliaz Technologies Pvt. Ltd.
*   Transaction Code : ZFI001
*   Module Name      : FI
*   Description      : Employee master data upload
*   Transport No     :

REPORT zfi0001   "report ZPM40
       NO STANDARD PAGE HEADING LINE-SIZE 255.


TYPES: BEGIN OF record,
         PERNR(010),
         begda(010),            "start date
         einda(010),            "From date
         endda(010),            "To date
         PLANS(010),
         werks(004),            "Personnel area
         persg(001),            "Employee group
         persk(002),            "Employee subgroup
         anrex(005),           "Title
         nachn(040),           "Last name
         vorna(040),            "First Name
         gesch(003),            "Gender
         gbdat(010),           "Birth date
*         gbdat type pa0002-gbdat,          "Birth date
         btrtl(004),            "Subarea
         abkrs(002),            "Payr.area
         anssa(003),             " address type
         name2(040),             "Care Of
         stras(060),             "Street and House No
         locat(040),             "Location
         pstlz(010),             "Postal Code
         ort01(040),             "City

       END OF record.

       types: BEGIN OF ty_pa0002,
              nachn type pa0002-nachn,
              vorna type pa0002-vorna,
              gbdat type pa0002-gbdat,
             END OF ty_pa0002.

 types: BEGIN OF ty_pa00021,
              nachn type pa0002-nachn,
              vorna type pa0002-vorna,
              gbdat type char30,
             END OF ty_pa00021.
DATA : it_final  TYPE TABLE OF record,
       wa_final  TYPE record,
       it_pa0002 TYPE TABLE OF ty_pa0002,
       it_pa00021 TYPE TABLE OF ty_pa00021,
       wa_pa0002 TYPE ty_pa0002,
       wa_pa00021 TYPE ty_pa00021.
TYPES: BEGIN OF ty_msg,
         id      TYPE bdcmsgcoll-msgtyp,
         message TYPE bdcmsgcoll-msgv1,
       END OF ty_msg.

DATA: it_fieldcatalog TYPE slis_t_fieldcat_alv,
      wa_fieldcatalog TYPE slis_fieldcat_alv,
      gwa_layout      TYPE slis_layout_alv.

DATA: i_msg       TYPE TABLE OF ty_msg WITH HEADER LINE,
      v_file      TYPE rlgrap-filename,
      gt_messages TYPE STANDARD TABLE OF bdcmsgcoll,
      gs_messages TYPE bdcmsgcoll.

DATA: it_bmc TYPE STANDARD TABLE OF bdcmsgcoll,
      wa_bmc TYPE bdcmsgcoll.
DATA v_msg(100) TYPE c.
DATA : BEGIN OF wa,
         lno      TYPE sytabix,
         name(80) TYPE c,
         msg(100) TYPE c,
       END OF wa.

DATA it LIKE TABLE OF wa.

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



START-OF-SELECTION.

START-OF-SELECTION.
  PERFORM get_file_data.
  PERFORM data_upload.
*  PERFORM message_display.
*  PERFORM display.

FORM data_upload .
refresh :it_pa0002 ,it_pa00021.
  SELECT nachn vorna gbdat FROM pa0002 INTO TABLE it_pa0002
            FOR ALL ENTRIES IN it_final
            WHERE nachn = it_final-nachn
              AND  vorna = it_final-vorna.
*              AND gbdat = it_final-gbdat.

    LOOP AT it_pa0002 INTO wa_pa0002.
    wa_pa00021-nachn = wa_pa0002-nachn.
    wa_pa00021-vorna = wa_pa0002-vorna.
    CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
      EXPORTING
        input         = wa_pa0002-gbdat
     IMPORTING
       OUTPUT        = wa_pa00021-gbdat.
    APPEND wa_pa00021 to it_pa00021.
              .
    CLEAR:wa_pa0002.

    ENDLOOP.

  CALL FUNCTION 'BDC_OPEN_GROUP'
    EXPORTING
*     CLIENT                    = SY-MANDT
*     DEST  = FILLER8
      group = 'PA40'
*     HOLDDATE                  = FILLER8
      keep  = 'X'
      user  = sy-uname
*     RECORD                    = FILLER1
      prog  = sy-cprog
*     DCPFM = '%'
*     DATFM = '%'
*     APP_AREA                  = FILLER12
*     LANGU = SY-LANGU
* IMPORTING
*     QID   =
* EXCEPTIONS
*     CLIENT_INVALID            = 1
*     DESTINATION_INVALID       = 2
*     GROUP_INVALID             = 3
*     GROUP_IS_LOCKED           = 4
*     HOLDDATE_INVALID          = 5
*     INTERNAL_ERROR            = 6
*     QUEUE_ERROR               = 7
*     RUNNING                   = 8
*     SYSTEM_LOCK_ERROR         = 9
*     USER_INVALID              = 10
*     OTHERS                    = 11
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


  LOOP AT it_final INTO wa_final.
    READ TABLE it_pa00021 INTO wa_pa00021 WITH KEY nachn = wa_final-nachn vorna = wa_final-vorna gbdat = wa_final-gbdat.
    IF  sy-subrc = 0.
      CONTINUE.
    ENDIF.

    PERFORM bdc_dynpro      USING 'SAPMP50A' '2000'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'T529T-MNTXT(01)'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=PICK'.
    PERFORM bdc_field       USING 'RP50G-PERNR'
                                  wa_final-PERNR.
    PERFORM bdc_field       USING 'RP50G-EINDA'
                                  wa_final-einda.   "'27.09.2022'.
    PERFORM bdc_field       USING 'RP50G-SELEC(01)'
                                  'X'.
    PERFORM bdc_dynpro      USING 'MP000000' '2000'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'PSPAR-PLANS'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=UPD'.
    PERFORM bdc_field       USING 'P0000-BEGDA'
                                  wa_final-begda.   "'27.09.2022'.
    PERFORM bdc_field       USING 'P0000-ENDDA'
                                  '31.12.9999'.
    PERFORM bdc_field       USING 'P0000-MASSN'
                                  '01'.
    PERFORM bdc_field       USING 'PSPAR-PLANS'
                                   wa_final-PLANS.
    PERFORM bdc_field       USING 'PSPAR-WERKS'
                                  wa_final-werks.   "'1000'.
    PERFORM bdc_field       USING 'PSPAR-PERSG'
                                  wa_final-persg.    "'1'.
    PERFORM bdc_field       USING 'PSPAR-PERSK'
                                  wa_final-persk.      "'N1'.

    PERFORM bdc_dynpro      USING 'MP000200' '2040'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'P0002-GBDAT'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=UPD'.
    PERFORM bdc_field       USING 'P0002-BEGDA'
                                  wa_final-begda.   "'27.09.2022'.
    PERFORM bdc_field       USING 'P0002-ENDDA'
                                  '31.12.9999'.
    PERFORM bdc_field       USING 'Q0002-ANREX'
                                  wa_final-anrex.   "'Mr'.
    PERFORM bdc_field       USING 'P0002-NACHN'
                                  wa_final-nachn.  "'anil'.
    PERFORM bdc_field       USING 'P0002-VORNA'
                                  wa_final-vorna.   "'kumar'.
    PERFORM bdc_field       USING 'P0002-GESCH'
                                  wa_final-gesch.   "'1'.
    PERFORM bdc_field       USING 'P0002-SPRSL'
                                  'EN'.
    PERFORM bdc_field       USING 'P0002-GBDAT'
                                  wa_final-gbdat.   "'30.12.2002'.
    PERFORM bdc_field       USING 'P0002-NATIO'
                                  'IN'.

    PERFORM bdc_dynpro      USING 'MP000100' '2000'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'P0001-BTRTL'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=UPD'.
    PERFORM bdc_field       USING 'P0001-BEGDA'
                                  wa_final-begda.   "'27.09.2022'.
    PERFORM bdc_field       USING 'P0001-ENDDA'
                                  '31.12.9999'.
    PERFORM bdc_field       USING 'P0001-BTRTL'
                                  wa_final-btrtl.  "'R001'.
    PERFORM bdc_field       USING 'P0001-ABKRS'
                                  wa_final-abkrs.   "'99'.


    PERFORM bdc_dynpro      USING 'MP000600' '2000'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'P0006-ORT01'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=UPD'.
    PERFORM bdc_field       USING 'P0006-BEGDA'
                                  wa_final-begda.   "'27.09.2022'.
    PERFORM bdc_field       USING 'P0006-ENDDA'
                                  '31.12.9999'.
*perform bdc_field       using 'P0006-ANSSA'
*                              wa_final-anssa.    ".
    PERFORM bdc_field       USING 'P0006-NAME2'
                                  wa_final-name2.   "'casataliaz'.
    PERFORM bdc_field       USING 'P0006-STRAS'
                                  wa_final-stras.   "'136,castaliaz'.
    PERFORM bdc_field       USING 'P0006-LOCAT'
                                  wa_final-locat.
    PERFORM bdc_field       USING 'P0006-PSTLZ'
                                  wa_final-pstlz.           "'450067'.
    PERFORM bdc_field       USING 'P0006-ORT01'
                                  wa_final-ort01.   "'MUMBAI'.
    PERFORM bdc_field       USING 'P0006-LAND1'
                                  'IN'.
    PERFORM bdc_dynpro      USING 'MP000700' '2000'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '/EBCK'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'P0007-BEGDA'.
    PERFORM bdc_dynpro      USING 'SAPMP50A' '2000'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '/EBCK'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'RP50G-PERNR'.




***perform bdc_dynpro      using 'SAPMP50A' '2000'.
***perform bdc_field       using 'BDC_CURSOR'
***                              'T529T-MNTXT(01)'.
***perform bdc_field       using 'BDC_OKCODE'
***                              '=PICK'.
***
***perform bdc_field       USING 'RP50G-PERNR'
***                               ' '.
***perform bdc_field       using 'RP50G-EINDA'
***                             wa_final-einda.  "'01.04.2022'.
***perform bdc_field       using 'RP50G-SELEC(01)'
***                              'X'.
***perform bdc_dynpro      using 'MP000000' '2000'.
***perform bdc_field       using 'BDC_CURSOR'
***                              'PSPAR-PERSK'.
***perform bdc_field       using 'BDC_OKCODE'
***                              '/00'.
***perform bdc_field       using 'P0000-BEGDA'
***                               wa_final-einda. "'01.04.2022'.
***perform bdc_field       using 'P0000-ENDDA'
***                              '31.12.9999'.
***perform bdc_field       using 'P0000-MASSN'
***                              '01'.
***perform bdc_field       using 'PSPAR-PLANS'
***                               '99999999'.
***perform bdc_field       using 'PSPAR-WERKS'
***                              wa_final-werks. "'1000'.
***perform bdc_field       using 'PSPAR-PERSG'
***                              wa_final-persg. "'1'.
***perform bdc_field       using 'PSPAR-PERSK'
***                              wa_final-persk. "'N1'.
***perform bdc_dynpro      using 'MP000000' '2000'.
***perform bdc_field       using 'BDC_CURSOR'
***                              'PSPAR-PERNR'.
***perform bdc_field       using 'BDC_OKCODE'
***                              '=UPD'.
***perform bdc_field       using 'PSPAR-PERNR'
***                              ' '.
***perform bdc_field       using 'P0000-BEGDA'
***                              wa_final-begda. "'01.04.2022'.
***perform bdc_field       using 'P0000-ENDDA'
***                              '31.12.9999'.
***perform bdc_field       using 'P0000-MASSN'
***                              '01'.
***perform bdc_field       using 'PSPAR-PLANS'
***                              '99999999'.
***perform bdc_field       using 'PSPAR-WERKS'
***                              wa_final-werks.  "'1000'.
***perform bdc_field       using 'PSPAR-PERSG'
***                              wa_final-persg. "'1'.
***perform bdc_field       using 'PSPAR-PERSK'
***                              wa_final-persk.  "'N1'.
***perform bdc_dynpro      using 'MP000200' '2040'.
***perform bdc_field       using 'BDC_CURSOR'
***                              'P0002-NATIO'.
***perform bdc_field       using 'BDC_OKCODE'
***                              '/00'.
***perform bdc_field       using 'P0002-BEGDA'
***                              wa_final-begda.  "'01.04.2022'.
***perform bdc_field       using 'P0002-ENDDA'
***                              '31.12.9999'.
***perform bdc_field       using 'Q0002-ANREX'
***                              wa_final-anrex.  "'Mr'.
***perform bdc_field       using 'P0002-NACHN'
***                              wa_final-nachn.   "'XYZ'.
***perform bdc_field       using 'P0002-VORNA'
***                              wa_final-vorna.  "'Kankal'.
***perform bdc_field       using 'P0002-GESCH'
***                              wa_final-gesch.  "'1'.
***perform bdc_field       using 'P0002-SPRSL'
***                              'EN'.
***perform bdc_field       using 'P0002-GBDAT'
***                              wa_final-gbdat.  "'02.10.1986'.
***perform bdc_field       using 'P0002-NATIO'
***                              'IN'.
***perform bdc_dynpro      using 'MP000200' '2040'.
***perform bdc_field       using 'BDC_CURSOR'
***                              'P0002-BEGDA'.
***perform bdc_field       using 'BDC_OKCODE'
***                              '=UPD'.
***perform bdc_field       using 'P0002-BEGDA'
***                              wa_final-begda.  "'02.10.1986'.
***perform bdc_field       using 'P0002-ENDDA'
***                              '31.12.9999'.
***perform bdc_field       using 'Q0002-ANREX'
***                              wa_final-anrex.  "'Mr'.
***perform bdc_field       using 'P0002-NACHN'
***                              wa_final-nachn.  "'XYZ'.
***perform bdc_field       using 'P0002-VORNA'
***                              wa_final-vorna.  "'Kankal'.
***perform bdc_field       using 'P0002-GESCH'
***                              wa_final-gesch.  "'1'.
***perform bdc_field       using 'P0002-SPRSL'
***                              'EN'.
***perform bdc_field       using 'P0002-GBDAT'
***                              wa_final-gbdat.   "'02.10.1986'.
****perform bdc_field       using 'P0002-NATIO'
****                              'IN'.
***perform bdc_dynpro      using 'MP000100' '2000'.
***perform bdc_field       using 'BDC_CURSOR'
***                              'P0001-BTRTL'.
***perform bdc_field       using 'BDC_OKCODE'
***                              '/00'.
***perform bdc_field       using 'P0001-BEGDA'
***                              wa_final-begda.  "'01.04.2022'.
***perform bdc_field       using 'P0001-ENDDA'
***                              '31.12.9999'.
***perform bdc_field       using 'P0001-BTRTL'
***                              wa_final-btrtl.  "'R001'.
***perform bdc_field       using 'P0001-ABKRS'
***                              wa_final-abkrs.  "'99'.
***perform bdc_field       using 'P0001-PLANS'
***                              '99999999'.
***perform bdc_dynpro      using 'MP000100' '2000'.
***perform bdc_field       using 'BDC_CURSOR'
***                              'P0001-BEGDA'.
***perform bdc_field       using 'BDC_OKCODE'
***                              '=UPD'.
***perform bdc_field       using 'P0001-BEGDA'
***                              wa_final-begda.   "'01.04.2022'.
***perform bdc_field       using 'P0001-ENDDA'
***                              '31.12.9999'.
***perform bdc_field       using 'P0001-BTRTL'
***                              wa_final-btrtl.  "'R001'.
***perform bdc_field       using 'P0001-ABKRS'
***                             wa_final-abkrs.  " '99'.
***perform bdc_field       using 'P0001-PLANS'
***                              '99999999'.
***perform bdc_field       using 'P0001-VDSK1'
***                              '1000'.
***perform bdc_dynpro      using 'MP000600' '2000'.
***perform bdc_field       using 'BDC_CURSOR'
***                              'P0006-ORT01'.
***perform bdc_field       using 'BDC_OKCODE'
***                              '/00'.
***perform bdc_field       using 'P0006-BEGDA'
***                              wa_final-begda.  "'01.04.2022'.
***perform bdc_field       using 'P0006-ENDDA'
***                              '31.12.9999'.
***perform bdc_field       using 'P0006-NAME2'
***                              wa_final-name2.   "car of
***perform bdc_field       using 'P0006-STRAS'
***                              wa_final-stras.   "address
***perform bdc_field       using 'P0006-LOCAT'
***                              wa_final-locat.   "second line
***
***perform bdc_field       using 'P0006-PSTLZ'
***                              wa_final-pstlz.  "'400077'.
***perform bdc_field       using 'P0006-ORT01'
***                              wa_final-ort01.  "'MUMBAI'.
***perform bdc_field       using 'P0006-LAND1'
***                              'IN'.
****perform bdc_dynpro      using 'MP000600' '2000'.
****perform bdc_field       using 'BDC_CURSOR'
****                              'P0006-BEGDA'.
****perform bdc_field       using 'BDC_OKCODE'
****                              '=UPD'.
****perform bdc_field       using 'P0006-BEGDA'
****                              wa_final-begda.  "'01.04.2022'.
****perform bdc_field       using 'P0006-ENDDA'
****                              '31.12.9999'.
****
****                              wa_final-pstlz.  "'400077'.
****perform bdc_field       using 'P0006-ORT01'
****                              wa_final-ort01.  "'MUMBAI'.
****perform bdc_field       using 'P0006-LAND1'
****                              'IN'.
***perform bdc_dynpro      using 'MP000700' '2000'.
***perform bdc_field       using 'BDC_OKCODE'
***                              '/EBCK'.
***perform bdc_field       using 'BDC_CURSOR'
***                              'P0007-BEGDA'.
***perform bdc_dynpro      using 'SAPMP50A' '2000'.
***perform bdc_field       using 'BDC_OKCODE'
***                              '/EBCK'.
***perform bdc_field       using 'BDC_CURSOR'
***                              'RP50G-PERNR'.
****perform bdc_field       using 'BDC_OKCODE'
****                              '/ENXT'.
****perform bdc_field       using 'BDC_CURSOR'
****                              'P0007-BEGDA'.
****perform bdc_dynpro      using 'MP000800' '2040'.
****perform bdc_field       using 'BDC_OKCODE'
****                              '/ENXT'.
****perform bdc_field       using 'BDC_CURSOR'
****                              'P0008-BEGDA'.
****perform bdc_dynpro      using 'MP000900' '2000'.
****perform bdc_field       using 'BDC_OKCODE'
****                              '/ENXT'.
****perform bdc_field       using 'BDC_CURSOR'
****                              'P0009-BEGDA'.
****perform bdc_dynpro      using 'MP058000' '2000'.
****perform bdc_field       using 'BDC_OKCODE'
****                              '/ENXT'.
****perform bdc_field       using 'BDC_CURSOR'
****                              'Q0580-GROSL'.
****perform bdc_dynpro      using 'MP058100' '2000'.
****perform bdc_field       using 'BDC_OKCODE'
****                              '/ENXT'.
****perform bdc_field       using 'BDC_CURSOR'
****                              'P0581-BEGDA'.
****perform bdc_dynpro      using 'MP058300' '2000'.
****perform bdc_field       using 'BDC_OKCODE'
****                              '/ENXT'.
****perform bdc_field       using 'BDC_CURSOR'
****                              'P0583-BEGDA'.
****   CALL TRANSACTION 'PA40' USING it_bdc  MODE p_mode UPDATE 'S' MESSAGES INTO IT_BMC.

    CALL FUNCTION 'BDC_INSERT'
      EXPORTING
        tcode     = 'PA40'
*       POST_LOCAL             = NOVBLOCAL
*       PRINTING  = NOPRINT
*       SIMUBATCH = ' '
*       CTUPARAMS = ' '
      TABLES
        dynprotab = it_bdc[]
* EXCEPTIONS
*       INTERNAL_ERROR         = 1
*       NOT_OPEN  = 2
*       QUEUE_ERROR            = 3
*       TCODE_INVALID          = 4
*       PRINTING_INVALID       = 5
*       POSTING_INVALID        = 6
*       OTHERS    = 7
      .
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    REFRESH it_bdc.


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
***     REFRESH: it_bdc[], gt_messages[].
*** refresh it_bmc.
  ENDLOOP.
  WRITE:/ 'Please go to tcode- SM35 for the session : PA40'.
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
*
    " naga
    CASE wa_intern-col.
      WHEN '0001'.
        wa_final-PERNR = wa_intern-value.
      WHEN '0002'.
        wa_final-begda = wa_intern-value.
      WHEN '0003'.
        wa_final-einda = wa_intern-value.
      WHEN '0004'.
        wa_final-endda = wa_intern-value.
      WHEN '0005'.
        wa_final-PLANS = wa_intern-value.
      WHEN '0006'.
        wa_final-werks = wa_intern-value.
      WHEN '0007'.
        wa_final-persg = wa_intern-value.
      WHEN '0008'.
        wa_final-persk = wa_intern-value.
      WHEN '0009'.
        wa_final-anrex = wa_intern-value.
      WHEN '0010'.
        wa_final-nachn = wa_intern-value.
      WHEN '0011'.
        wa_final-vorna = wa_intern-value.
      WHEN '0012'.
        wa_final-gesch = wa_intern-value.
      WHEN '0013'.
        wa_final-gbdat = wa_intern-value.
      WHEN '0014'.
        wa_final-btrtl = wa_intern-value.
      WHEN '0015'.
        wa_final-abkrs = wa_intern-value.
      WHEN '0016'.
        wa_final-anssa = wa_intern-value.
      WHEN '0017'.
        wa_final-name2 = wa_intern-value.
      WHEN '0018'.
        wa_final-stras = wa_intern-value.
      WHEN '0019'.
        wa_final-locat = wa_intern-value.
      WHEN '0020'.
        wa_final-pstlz = wa_intern-value.
      WHEN '0021'.
        wa_final-ort01 = wa_intern-value.
*         naga

    ENDCASE.
    AT END OF row.
      APPEND wa_final TO it_final.
      CLEAR wa_final.
    ENDAT.
    CLEAR wa_intern.
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
**wa_fieldcatalog-fieldname   = 'NAME'.
**  wa_fieldcatalog-seltext_l   = 'NAME'.
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
**FORM display .
** DATA: gd_repid TYPE sy-repid.
**
**  gd_repid = sy-repid.
**
**  gwa_layout-colwidth_optimize = 'X'.
**  gwa_layout-zebra             = 'X'.
**  gwa_layout-info_fieldname    = 'LCOL'.
**
***  IF NOT i_msg[] IS INITIAL.
**  IF NOT IT IS INITIAL.
**
**    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
**      EXPORTING
**        i_callback_program = gd_repid
**        is_layout          = gwa_layout
**        it_fieldcat        = it_fieldcatalog
**        i_save             = 'A'
**      TABLES
**        t_outtab           =    IT  "i_msg[]
**      EXCEPTIONS
**        program_error      = 1
**        OTHERS             = 2.
**
**  ENDIF.
**
**ENDFORM.

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
