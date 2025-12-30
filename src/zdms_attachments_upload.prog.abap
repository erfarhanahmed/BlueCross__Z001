*&---------------------------------------------------------------------*
*& Report ZDMS_ATTACHMENTS_UPLOAD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdms_attachments_upload.




DATA:
  lv_docty         TYPE dokar,
  lv_docnr         TYPE doknr,
  lv_docpr         TYPE doktl_d,
  lv_docvr         TYPE dokvr,
  ls_ret           TYPE bapiret2,
  lt_files         TYPE TABLE OF bapi_doc_files2,
*  it_draw          LIKE draw OCCURS 0 WITH HEADER LINE,
  ls_files         LIKE LINE OF lt_files,
  ls_documentdata  TYPE bapi_doc_draw2,
  ls_documentdata1 TYPE bapi_doc_draw2,
  dms_key          TYPE draw,
  wa_d             TYPE draw,
*      P_file type string ,
*      var_filename type string,
  ls_return        TYPE bapiret2,
  ls_status        TYPE char_132.

""" EXCEL DATA UPLOAD "

DATA: BEGIN OF record OCCURS 0,
        mandt(12)   TYPE c,
        dokar(03),
        doknr(30),
        dokvr(02),
        doktl(30),
        dwnam(30),
        dokst(30),
        labor(30),
        aennr(30),
        werka(30),
        loedk(30),
        cadkz(30),
        prenr(30),
        prevr(30),
        pretl(30),
        prear(30),
        begru(30),
        filep(1000),
        dttrg(30),
        dappl(30),
        filep1(30),
        dttrg1(30),
        dokob(10),
        objky(50),
        dktxt(50),
      END OF record.


DATA : wa_record  LIKE record.
DATA : wa_record1 LIKE record.
DATA : wa_record2 LIKE record.
DATA : record1 LIKE  record OCCURS 0.
DATA : record2 LIKE  record OCCURS 0.
DATA : itab_temp LIKE record OCCURS 0.
DATA : wa_tab LIKE record. "itab_temp.
DATA : wa_draw TYPE draw.
*data : ls_draw type draw.
*DATA : ls_draw TYPE draw.
DATA : ls_dokar TYPE dokar.
DATA : ls_doknr TYPE doknr.
DATA : ls_dokvr TYPE dokvr.
DATA : ls_doktl TYPE doktl.
DATA: ls_dokst TYPE dokst.
DATA : ls_filep TYPE filep.
DATA : ls_drad TYPE drad.
DATA : ls_objky TYPE objky.
DATA : wa_doknr TYPE draw.
DATA : ls_dappl  TYPE dappl.
DATA : ls_dttrg  TYPE dttrg.
DATA : vs_objky  TYPE objky.
DATA : vs_drad TYPE TABLE OF drad.
DATA : BEGIN OF itab OCCURS 0.
         INCLUDE STRUCTURE draw.
DATA : END OF itab.
DATA : wa_itab LIKE itab.
DATA: it_fieldcat  TYPE slis_t_fieldcat_alv.
DATA: wa_fieldcat  TYPE slis_fieldcat_alv.
DATA: is_layout TYPE slis_layout_alv.

 " replace with your structure
TYPES: BEGIN OF ty_alv,
         mandt TYPE c LENGTH 12,
         dokar TYPE c LENGTH 3,
         doknr TYPE c LENGTH 30,
         dokvr TYPE c LENGTH 2,
         doktl TYPE c LENGTH 30,
         dokst TYPE c LENGTH 30,
         filep TYPE c LENGTH 900,
         dktxt TYPE c LENGTH 50,
         dttrg TYPE c LENGTH 30,
         dappl TYPE c LENGTH 30,
         dokob TYPE c LENGTH 10,
         objky TYPE c LENGTH 50,
         message TYPE c LENGTH 100,
       END OF ty_alv.

TYPES : BEGIN OF ty_msg,
          sr_no    TYPE char5,
          msg_desc TYPE string,
        END OF ty_msg.

TYPES : BEGIN OF ty_drad,
          dokob TYPE dokob,
          objky TYPE objky,
        END OF ty_drad.
DATA: it_drad LIKE bapi_doc_drad OCCURS 0 WITH HEADER LINE.

DATA : it_msg  TYPE TABLE OF ty_msg,
       wa_msg  TYPE ty_msg,
       lv_line TYPE i.
DATA : lw_char25 TYPE char25,
       lw_doknr  TYPE doknr.

DATA: gt_records  TYPE STANDARD TABLE OF ty_alv,
      gs_record   TYPE ty_alv,
      gt_fieldcat TYPE slis_t_fieldcat_alv,
      gs_fieldcat TYPE slis_fieldcat_alv,
      gv_repid    TYPE sy-repid.

" data to check document status.

DATA: lf_doctype      LIKE bapi_doc_draw-documenttype,

      lf_docnumber    LIKE bapi_doc_draw-documentnumber,

      lf_docpart      LIKE bapi_doc_draw-documentpart,

      lf_docversion   LIKE bapi_doc_draw-documentversion,

      lf_statusextern LIKE bapi_doc_draw-statusextern,

      lf_statusintern LIKE bapi_doc_draw-statusintern,

      lf_statuslog    LIKE bapi_doc_draw-statuslog.


DATA: lt_return LIKE bapiret2.

*DATA: it_fieldcat1  TYPE slis_t_fieldcat_alv.
*DATA: wa_fieldcat1  TYPE slis_fieldcat_alv.
*DATA: is_layout1 TYPE slis_lyout_alv.

DATA: messtab LIKE bdcmsgcoll OCCURS 0 WITH HEADER LINE.
DATA : wa_tab1 LIKE messtab.
*data : IT_RECORD type record .
DATA : ls_record TYPE record.
TYPE-POOLS : truxs.
DATA : it_file TYPE TABLE OF alsmex_tabline,
       wa_file TYPE alsmex_tabline.

DATA : lenth TYPE i.                          "ADDED BY RAJABABU DATE:19-09-2022

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: f_path TYPE rlgrap-filename.               "File Path
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-001.
  PARAMETERS: s_strg TYPE dttrg.               "File Path
SELECTION-SCREEN END OF BLOCK b2.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR f_path.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = sy-repid
      dynpro_number = sy-dynnr
      field_name    = 'F_PATH'
    IMPORTING
      file_name     = f_path.

AT SELECTION-SCREEN.
  IF f_path IS NOT INITIAL.
    CLEAR lenth.
    lenth = strlen( f_path ).
    IF lenth > 127 .
      MESSAGE 'Template file name length Exceed 127' TYPE 'E'.
      LEAVE TO LIST-PROCESSING.
    ENDIF.
  ENDIF.



START-OF-SELECTION.

  PERFORM upload.

END-OF-SELECTION.


FORM upload .
  FIELD-SYMBOLS: <fs_draw> TYPE record.


       TYPES: BEGIN OF ty_record,
         mandt TYPE c LENGTH 12,     " Client or similar
         dokar TYPE c LENGTH 3,      " Document type
         doknr TYPE c LENGTH 30,     " Document number
         dokvr TYPE c LENGTH 2,      " Document version
         doktl TYPE c LENGTH 30,     " Document part
         dokst TYPE c LENGTH 30,     " Document status
         filep TYPE c LENGTH 900,    " File path or file name
         DKTXT TYPE c LENGTH 50,
         dttrg TYPE c LENGTH 30,     " Trigger date/time or description
         dappl TYPE c LENGTH 30,     " Application area
         dokob TYPE c LENGTH 10,     " Document object
         objky TYPE c LENGTH 50,     " Object key
       END OF ty_record.
*MANDT  DOKAR DOKNR DOKVR DOKTL DOKST FILEP DKTXT DTTRG DAPPL DOKOB OBJKY

       DATA: it_raw  TYPE truxs_t_text_data,
      it_file2  TYPE TABLE of ty_record.

CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
  EXPORTING
    i_tab_raw_data       = it_raw
    i_filename           = f_path
    i_line_header        = 'X'  " if first row has headers
     I_FIELD_SEPERATOR    = 'X'
  TABLES
    i_tab_converted_data = it_file2[]
  EXCEPTIONS
    conversion_failed    = 1
    OTHERS               = 2.

IF sy-subrc <> 0.
  MESSAGE 'Excel upload failed' TYPE 'E'.
ENDIF.

MOVE-CORRESPONDING it_file2 to record[].
  ls_status ='Document already exist'.


  IF sy-subrc = 0.

    LOOP AT record INTO wa_tab.

MOVE-CORRESPONDING wa_tab to gs_record.
      ls_dokar = wa_tab-dokar.
      ls_doknr = wa_tab-doknr.
      ls_dokvr = wa_tab-dokvr.
      ls_dokst = wa_tab-dokst.
      ls_filep = wa_tab-filep.
*      ls_drad-dokob = wa_tab-dokob.
*      ls_drad-objky = wa_tab-objky.
      ls_dappl = wa_tab-dappl.
      ls_dttrg = wa_tab-dttrg.

*
      IF ls_drad-objky IS NOT INITIAL.
        MOVE ls_drad-dokob TO it_drad-objecttype.
        MOVE ls_drad-objky TO it_drad-objectkey.
        APPEND it_drad.
      ENDIF.

      " adding leading zeros
      lw_char25 = ls_doknr.
      lw_doknr = lw_char25.

*if it_draw is not INITIAL.
*  READ TABLE it_draw WITH TABLE KEY doknr = ls_doknr.
*  if sy-subrc = 0.


      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lw_doknr
        IMPORTING
          output = lw_doknr.



      SELECT * FROM draw INTO TABLE @DATA(it_doknr) WHERE doknr = @lw_doknr AND dokar = @ls_dokar.

      IF sy-subrc = 0.
gs_record-message = 'Document already exist'.
APPEND gs_record to gt_records.
CLEAR: gs_record.


*        SKIP.
      ELSE.

        CLEAR ls_documentdata.
        CLEAR ls_documentdata.
        CLEAR lt_files.
        ls_documentdata-documenttype = ls_dokar. "'ZRM'.
        ls_documentdata-documentnumber = lw_doknr.

*       ls_documentdata-documentversion = ls_dokvr.
*       ls_documentdata-DOCUMENTPART = ls_doktl.
*        ls_documentdata-description = 'test dms'. "'Testing DMS-Ecratum'.
        ls_documentdata-description = wa_tab-dktxt. "'Testing DMS-Ecratum'.
        ls_documentdata-username = sy-uname.
*       ls_documentdata-statusextern = ls_dokst.
*       ls_documentdata-statusintern = ls_dokst.

        " DOCUMENT WITHOUT object link .


        SELECT * FROM drad  INTO TABLE vs_drad WHERE doknr = dms_key-doknr AND dokar = dms_key-dokar.
        IF sy-subrc = 0.
          vs_objky = 'X'.

        ENDIF.

        IF it_drad IS NOT INITIAL AND vs_objky EQ 'X'.

          CALL FUNCTION 'BAPI_DOCUMENT_CREATE2'
            EXPORTING
              documentdata    = ls_documentdata
              pf_ftp_dest     = 'SAPFTPA'
              pf_http_dest    = 'SAPHTTPA'
            IMPORTING
              documenttype    = dms_key-dokar
              documentnumber  = dms_key-doknr
              documentpart    = dms_key-doktl
              documentversion = dms_key-dokvr
              return          = ls_ret
            TABLES
              documentfiles   = lt_files.

IF ls_ret is   NOT INITIAL.
gs_record-message = ls_ret-message.
APPEND gs_record to gt_records.
CLEAR: gs_record.
ENDIF.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait   = abap_true
            IMPORTING
              return = ls_return.

*****---- Attach document by getting file from application server



          DATA: var_pos TYPE i.
          DATA: var_file TYPE string.
          DATA: var_dir TYPE string.
          DATA: var_filename TYPE string.
          DATA : wa_d TYPE draw.
          TYPES: BEGIN OF ts_document_hdr,
                   type    TYPE dokar,
                   number  TYPE doknr,
                   part    TYPE doktl_d,
                   version TYPE dokvr,
                 END OF ts_document_hdr.

          DATA: ls_document_hdr  TYPE bapi_doc_draw2,
                ls_documentdatax TYPE bapi_doc_drawx2.

* Document Header
          ls_document_hdr-documenttype = dms_key-dokar.
          ls_document_hdr-documentnumber = dms_key-doknr.
          ls_document_hdr-documentpart = dms_key-doktl.
          ls_document_hdr-documentversion = dms_key-dokvr.



* Document Data
          ls_documentdata1-wsapplication2 = ls_dappl."p_filty.
          ls_documentdatax-wsapplication2 = abap_true.
*          ls_documentdatax-statusextern = 'X'.
*          ls_documentdatax-statusintern = 'X'.
*          ls_documentdata1-statusextern = ls_dokst.
*          ls_documentdata1-statusintern = ls_dokst.
          ls_documentdata1-docfile2 = ls_filep . "p_path && p_filnm.
          ls_documentdatax-docfile2 = abap_true.

          var_pos = strlen( ls_filep ).


          IF ls_dttrg NE 'Z1' OR ls_dttrg IS INITIAL.
*loop at record to WA_D.
*  IF WA_D-DOKNR =  ls_document_hdr-documentnumber.
* Document Files
            ls_files-documenttype = ls_document_hdr-documenttype.
            ls_files-documentnumber = ls_document_hdr-documentnumber.
            ls_files-documentpart = ls_document_hdr-documentpart.
            ls_files-documentversion = ls_document_hdr-documentversion.
*            ls_files-statusextern = ls_dokst.
*            ls_files-statusintern = ls_dokst.
*            ls_files-statusextern = ls_documentdatax-statusextern.
            ls_files-docpath = ls_filep+0(3). "p_path.
            ls_files-docfile = ls_filep+3(var_pos). "p_filnm.
            ls_files-description = ls_filep+0(3).
            ls_files-wsapplication = ls_dappl. "p_filty.
* ls_files-sourcedatacarrier = 'DV-1' . "p_datcar.
            ls_files-originaltype = '1'.
            ls_files-storagecategory = s_strg. " Here tried with "SAP-SYSTEM"
            APPEND ls_files TO lt_files.

*ENDIF.
*ENDLOOP.
          ELSE.
            ls_files-documenttype = ls_document_hdr-documenttype.
            ls_files-documentnumber = ls_document_hdr-documentnumber.
            ls_files-documentpart = ls_document_hdr-documentpart.
            ls_files-documentversion = ls_document_hdr-documentversion.
            ls_files-statusextern = 'RE'.
            ls_documentdata1-statusextern = 'RE'.
            ls_documentdatax-statusextern = 'X'.
            ls_files-docpath = ls_filep+0(7). "p_path.
            ls_files-docfile = ls_filep+7(var_pos). "p_filnm.
            ls_files-description = ls_filep+0(3).
            ls_files-wsapplication = ls_dappl. "p_filty.
            ls_files-originaltype = '1'.
            ls_files-storagecategory = s_strg. " Here tried with "SAP-SYSTEM"

            APPEND ls_files TO lt_files.



          ENDIF.
          "Attach file to the Document.

          CALL FUNCTION 'BAPI_DOCUMENT_CHANGE2'
            EXPORTING
              documenttype    = ls_document_hdr-documenttype
              documentnumber  = ls_document_hdr-documentnumber
              documentpart    = ls_document_hdr-documentpart
              documentversion = ls_document_hdr-documentversion
              documentdata    = ls_documentdata1
              documentdatax   = ls_documentdatax
            IMPORTING
              return          = ls_return
            TABLES
              documentfiles   = lt_files.

IF ls_return is   NOT INITIAL.
gs_record-message = ls_return-message.
APPEND gs_record to gt_records.
CLEAR: gs_record.
ENDIF.
          " update status of document change.

          lf_docnumber = ls_document_hdr-documentnumber.

          lf_doctype = ls_document_hdr-documenttype.

          lf_docversion = ls_document_hdr-documentversion.

          lf_docpart = ls_document_hdr-documentpart.

          lf_statusintern = ls_dokst.

          IF  lf_statusintern NE 'PR' AND ls_dttrg EQ 'Z1'.
            SKIP.
          ELSE.
            CALL FUNCTION 'BAPI_DOCUMENT_SETSTATUS'
              EXPORTING
                documenttype    = lf_doctype
                documentnumber  = lf_docnumber
                documentpart    = lf_docpart
                documentversion = lf_docversion
                statusextern    = lf_statusextern
                statusintern    = lf_statusintern
                statuslog       = lf_statuslog
              IMPORTING
                return          = lt_return.



            IF ls_return-type CA 'EA'.

              ROLLBACK WORK.

*              MESSAGE ID '26' TYPE 'I' NUMBER '000'
*
*              WITH ls_return-message.

IF lt_return is   NOT INITIAL.
gs_record-message = lt_return-message.
APPEND gs_record to gt_records.
CLEAR: gs_record.
ENDIF.

            ELSE.

              COMMIT WORK.

            ENDIF.

            " TO ATTACH AND ADD OBJECTLINK.
          ENDIF.

        ELSE.
          CALL FUNCTION 'BAPI_DOCUMENT_CREATE2'
            EXPORTING
              documentdata    = ls_documentdata
              pf_ftp_dest     = 'SAPFTPA'
              pf_http_dest    = 'SAPHTTPA'
            IMPORTING
              documenttype    = dms_key-dokar
              documentnumber  = dms_key-doknr
              documentpart    = dms_key-doktl
              documentversion = dms_key-dokvr
              return          = ls_ret
            TABLES
              documentfiles   = lt_files
              objectlinks     = it_drad.

*CLEAR lt_files.
*clear it_drad.
 IF ls_ret-type CA 'EA'.
              ROLLBACK WORK.
*              MESSAGE ID '26' TYPE 'I' NUMBER '000'
*              WITH ls_return-message.

gs_record-message = ls_ret-message.
APPEND gs_record to gt_records.
CLEAR: gs_record.
*            ELSE.
*              COMMIT WORK.
            ENDIF.

          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait   = abap_true
            IMPORTING
              return = ls_return.
*        ENDIF.
*****---- Attach document by getting file from application server

* Document Header
          ls_document_hdr-documenttype = dms_key-dokar.
          ls_document_hdr-documentnumber = dms_key-doknr.
          ls_document_hdr-documentpart = dms_key-doktl.
          ls_document_hdr-documentversion = dms_key-dokvr.

* Document Data
          ls_documentdata1-wsapplication2 = ls_dappl."p_filty.
          ls_documentdatax-wsapplication2 = abap_true.
          ls_documentdata1-docfile2 = ls_filep . "p_path && p_filnm.
          ls_documentdatax-docfile2 = abap_true.

          var_pos = strlen( ls_filep ).


          IF ls_dttrg NE 'Z1' OR ls_dttrg IS INITIAL.

*loop at record to WA_D.
*  IF WA_D-DOKNR =  ls_document_hdr-documentnumber.
* Document Files
            ls_files-documenttype = ls_document_hdr-documenttype.
            ls_files-documentnumber = ls_document_hdr-documentnumber.
            ls_files-documentpart = ls_document_hdr-documentpart.
            ls_files-documentversion = ls_document_hdr-documentversion.
*            ls_files-statusextern = ls_documentdata-statusextern.
            ls_files-docpath = ls_filep+0(3). "p_path.
            ls_files-docfile = ls_filep+3(var_pos). "p_filnm.
            ls_files-description = ls_filep+0(3) && ls_filep+3(var_pos).
            ls_files-wsapplication = ls_dappl. "p_filty.
* ls_files-sourcedatacarrier = 'DV-1' . "p_datcar.
            ls_files-originaltype = '1'.
            ls_files-storagecategory = s_strg. " Here tried with "SAP-SYSTEM"

            APPEND ls_files TO lt_files.
*              ENDIF.
*           ENDLOOP.

          ELSE.
            ls_files-documenttype = ls_document_hdr-documenttype.
            ls_files-documentnumber = ls_document_hdr-documentnumber.
            ls_files-documentpart = ls_document_hdr-documentpart.
            ls_files-documentversion = ls_document_hdr-documentversion.
            ls_files-statusextern = 'RE'.
            ls_documentdata1-statusextern = 'RE'.
            ls_documentdatax-statusextern = 'X'.
            ls_files-docpath = ls_filep+0(3). "p_path.
            ls_files-docfile = ls_filep+3(var_pos). "p_filnm.
            ls_files-description = ls_filep+3(var_pos).
            ls_files-wsapplication = ls_dappl. "p_filty.

* ls_files-sourcedatacarrier = 'DV-1' . "p_datcar.
            ls_files-originaltype = '1'.
            ls_files-storagecategory = s_strg. " Here tried with "SAP-SYSTEM"
            APPEND ls_files TO lt_files.

          ENDIF.


          "Attach file to the Document.
          CALL FUNCTION 'BAPI_DOCUMENT_CHANGE2'
            EXPORTING
              documenttype    = ls_document_hdr-documenttype
              documentnumber  = ls_document_hdr-documentnumber
              documentpart    = ls_document_hdr-documentpart
              documentversion = ls_document_hdr-documentversion
              documentdata    = ls_documentdata1
              documentdatax   = ls_documentdatax
            IMPORTING
              return          = ls_return
            TABLES
              documentfiles   = lt_files
              objectlinks     = it_drad.
          CLEAR it_drad.
if ls_return is INITIAL .
gs_record-message = ls_return-message.
APPEND gs_record to gt_records.
CLEAR: gs_record.
endif.

          " update status of document change.

          lf_docnumber = ls_document_hdr-documentnumber.

          lf_doctype = ls_document_hdr-documenttype.

          lf_docversion = ls_document_hdr-documentversion.

          lf_docpart = ls_document_hdr-documentpart.

          lf_statusintern = ls_dokst.

          IF lf_statusintern NE 'AP' AND ls_dttrg EQ 'Z1'.
            SKIP.
          ELSE.

            CALL FUNCTION 'BAPI_DOCUMENT_SETSTATUS'
              EXPORTING
                documenttype    = lf_doctype
                documentnumber  = lf_docnumber
                documentpart    = lf_docpart
                documentversion = lf_docversion
                statusextern    = lf_statusextern
                statusintern    = lf_statusintern
                statuslog       = lf_statuslog
              IMPORTING
                return          = lt_return.



            IF ls_return-type CA 'EA'.
              ROLLBACK WORK.
              MESSAGE ID '26' TYPE 'I' NUMBER '000'
              WITH ls_return-message.
            ELSE.
              COMMIT WORK.
            ENDIF.
          ENDIF.

          IF ls_return-type NE 'E'.
            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
              EXPORTING
                wait = abap_true.
            MESSAGE s000(zz) WITH 'Success'.
          ELSE.
            CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
            MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number
            WITH ls_return-message_v1 ls_return-message_v2 ls_return-message_v3 ls_return-message_v4.
          ENDIF.

          CLEAR it_drad.
          REFRESH it_drad.

          CALL FUNCTION 'BAPI_DOCUMENT_GETDETAIL2'
            EXPORTING
              documenttype    = ls_document_hdr-documenttype
              documentnumber  = ls_document_hdr-documentnumber
              documentpart    = ls_document_hdr-documentpart
              documentversion = ls_document_hdr-documentversion
              getactivefiles  = 'X'
*getdocdescriptions = 'X'
              getobjectlinks  = 'X'
              getdocfiles     = 'X'
            IMPORTING
              documentdata    = ls_documentdata
              return          = ls_return
            TABLES
              objectlinks     = it_drad.

if ls_return is not INITIAL.
gs_record-message = ls_return-message.
APPEND gs_record to gt_records.
CLEAR: gs_record.
endif.
*    CLEAR ls_status.
        ENDIF.
       IF gs_record-message is INITIAL.
gs_record-message = 'File uploaded suceesfully'.
APPEND gs_record to gt_records.
CLEAR: gs_record.
ENDIF.

      ENDIF.



    ENDLOOP.
*    WRITE:/ ls_status.
  ENDIF.



"-REPORT zshow_alv_demo.


gv_repid = sy-repid.

*--------------------------------------------------------------------*
* Build Field Catalog
*--------------------------------------------------------------------*
PERFORM build_fieldcat.

*--------------------------------------------------------------------*
* Display ALV Grid
*--------------------------------------------------------------------*
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    i_callback_program = gv_repid
    it_fieldcat        = gt_fieldcat
    i_save             = 'A'
    i_grid_title       = 'Document Records'
  TABLES
    t_outtab           = gt_records
  EXCEPTIONS
    program_error      = 1
    OTHERS             = 2.

IF sy-subrc <> 0.
  MESSAGE 'Error displaying ALV grid' TYPE 'E'.
ENDIF.

*--------------------------------------------------------------------*
* FORM: Build Field Catalog
*--------------------------------------------------------------------*




ENDFORM.


FORM build_fieldcat.
  DEFINE add_fieldcat.
    CLEAR gs_fieldcat.
    gs_fieldcat-fieldname = &1.
    gs_fieldcat-seltext_m = &2.
    gs_fieldcat-outputlen = &3.
    APPEND gs_fieldcat TO gt_fieldcat.
  END-OF-DEFINITION.

  add_fieldcat 'MANDT' 'Client' 12.
  add_fieldcat 'DOKAR' 'Document Type' 3.
  add_fieldcat 'DOKNR' 'Document Number' 30.
  add_fieldcat 'DOKVR' 'Version' 2.
  add_fieldcat 'DOKTL' 'Document Part' 30.
  add_fieldcat 'DOKST' 'Document Status' 30.
  add_fieldcat 'FILEP' 'File Path' 50.
  add_fieldcat 'DKTXT' 'Description' 50.
  add_fieldcat 'DTTRG' 'Trigger Info' 30.
  add_fieldcat 'DAPPL' 'Application Area' 30.
  add_fieldcat 'DOKOB' 'Document Object' 10.
  add_fieldcat 'OBJKY' 'Object Key' 50.
  add_fieldcat 'MESSAGE' 'Message' 100.
ENDFORM.
