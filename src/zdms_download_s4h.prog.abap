*&---------------------------------------------------------------------*
*& Report ZDMS_DOWNLOAD_S4H
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZDMS_DOWNLOAD_S4H.

*------------------------------------------------------------*
* Declarations
*------------------------------------------------------------*
*TABLES: draw, drad, drat.
*
*DATA: BEGIN OF record OCCURS 0,
*        mandt TYPE draw-mandt,
*        dokar TYPE draw-dokar,
*        doknr TYPE draw-doknr,
*        dokvr TYPE draw-dokvr,
*        doktl TYPE draw-doktl,
*        dokst TYPE draw-dokst,
*        filep TYPE draw-filep,
*        dktxt TYPE drat-dktxt,
*        dttrg TYPE draw-dttrg,
*        dappl TYPE draw-dappl,
*        dokob TYPE drad-dokob,
*        objky TYPE drad-objky,
*      END OF record.
*
*FIELD-SYMBOLS: <fs_draw> TYPE draw,
*               <fs_drad> TYPE drad.
*
*DATA: w_documentnumber     TYPE bapi_doc_aux-docnumber,
*      w_documentnumber_in  TYPE bapi_doc_aux-docnumber,
*      w_documenttype       TYPE bapi_doc_aux-doctype,
*      w_documentpart       TYPE bapi_doc_aux-docpart,
*      w_documentversion    TYPE bapi_doc_aux-docversion,
*      w_return             TYPE bapiret2,
*      w_documentdata       TYPE bapi_doc_draw2,
*      w_documentdatax      TYPE bapi_doc_drawx2.
*
*DATA: wa_refdocumenttype   TYPE bapi_doc_aux-doctype,
*      wa_refdocumentnumber TYPE bapi_doc_aux-docnumber,
*      wa_refdocumentpart   TYPE bapi_doc_aux-docpart,
*      wa_refdocumentversion TYPE bapi_doc_aux-docversion,
*      wa_newdocumentversion TYPE bapi_doc_aux-docversion,
*      wa_docversion        TYPE bapi_doc_aux-docversion.
*
*DATA: it_draw     TYPE TABLE OF draw,
*      lf_tmp_file TYPE draw-filep.
*
*DATA: t_objectlinks   LIKE bapi_doc_drad OCCURS 0 WITH HEADER LINE,
*      t_documentdescr LIKE bapi_doc_drat OCCURS 0 WITH HEADER LINE,
*      t_longtexts     LIKE bapi_doc_text OCCURS 0 WITH HEADER LINE,
*      t_statuslog     LIKE bapi_doc_drap OCCURS 0 WITH HEADER LINE,
*      t_components    LIKE bapi_doc_comp OCCURS 0 WITH HEADER LINE,
*      t_classalloc    LIKE bapi_class_allocation OCCURS 0 WITH HEADER LINE,
*      t_documentfiles LIKE bapi_doc_files2 OCCURS 0 WITH HEADER LINE,
*      t_documentstruct LIKE bapi_doc_structure OCCURS 0 WITH HEADER LINE,
*      t_charvalues    LIKE bapi_characteristic_values OCCURS 0 WITH HEADER LINE.
*
*DATA: v_file       TYPE string,
*      it_tab       TYPE TABLE OF record,
*      it_drad      TYPE drad OCCURS 0,
*      it_onjlink   TYPE dokob,
*      it_objkey    TYPE objky.
*
*DATA: gt_draw    LIKE draw OCCURS 0,
*      gt_file    TYPE dms_rec_file2 OCCURS 0,
*      it_dokar   TYPE draw-dokar,
*      it_doknr   TYPE draw-doknr,
*      it_doktl   TYPE draw-doktl,
*      it_dokvr   TYPE draw-dokvr,
*      it_filep   TYPE draw-filep,
*      it_files   TYPE TABLE OF cvapi_doc_file,
*      pfx_file   TYPE draw-filep,
*      lf_func_type TYPE tdwx-apptp,
*      it_xstring TYPE xstring,
*      lf_check_file TYPE c.
*
**------------------------------------------------------------*
** Selection Screen
**------------------------------------------------------------*
*SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE text-001.
*SELECT-OPTIONS:
*  s_dokar FOR draw-dokar MEMORY ID cv2,
*  s_doknr FOR draw-doknr MEMORY ID cv1.
*SELECTION-SCREEN END OF BLOCK a1.
*
*SELECTION-SCREEN BEGIN OF BLOCK a2 WITH FRAME TITLE text-002.
*PARAMETERS: p_file TYPE string.
*SELECTION-SCREEN END OF BLOCK a2.
*
**------------------------------------------------------------*
** F4 Help for directory path
**------------------------------------------------------------*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
*  PERFORM file_f4 CHANGING p_file.
*
**------------------------------------------------------------*
** Start of selection
**------------------------------------------------------------*
*START-OF-SELECTION.
*  PERFORM download_dms_attachment.
*
**------------------------------------------------------------*
** FORM: file_f4
**------------------------------------------------------------*
*FORM file_f4 CHANGING p_file TYPE string.
*  DATA: lv_title TYPE string,
*        lv_path  TYPE string.
*
*  lv_title = 'Choose Directory'.
*  lv_path  = p_file.
*
*  CALL METHOD cl_gui_frontend_services=>directory_browse
*    EXPORTING
*      window_title    = lv_title
*      initial_folder  = lv_path
*    CHANGING
*      selected_folder = lv_path
*    EXCEPTIONS
*      cntl_error           = 1
*      error_no_gui         = 2
*      not_supported_by_gui = 3
*      OTHERS               = 4.
*
*  IF sy-subrc = 0.
*    p_file = lv_path.
*  ELSE.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*  ENDIF.
*ENDFORM.
*
**------------------------------------------------------------*
** FORM: download_dms_attachment
**------------------------------------------------------------*
*FORM download_dms_attachment.
*
*  CLEAR gt_draw.
*  REFRESH gt_draw.
*
*  SELECT * FROM draw INTO TABLE gt_draw
*    WHERE dokar IN s_dokar AND
*          doknr IN s_doknr.
*
*  IF sy-subrc <> 0.
*    MESSAGE 'No documents found.' TYPE 'I'.
*    RETURN.
*  ENDIF.
*
*  LOOP AT gt_draw ASSIGNING <fs_draw>.
*    "MOVE-CORRESPONDING <fs_draw> TO:
*      IT_DOKAR =  <FS_DRAW>-DOKAR.
*      IT_DOKNR =  <FS_DRAW>-DOKNR.
*      IT_DOKTL =  <FS_DRAW>-DOKTL.
*      IT_DOKVR =   <FS_DRAW>-DOKVR.
*      IT_FILEP =    <FS_DRAW>-FILEP.
*
*    CALL FUNCTION 'BAPI_DOCUMENT_GETDETAIL2'
*      EXPORTING
*        documenttype    = it_dokar
*        documentnumber  = it_doknr
*        documentpart    = it_doktl
*        documentversion = it_dokvr
*        getdocfiles     = 'X'
*      IMPORTING
*        documentdata    = w_documentdata
*      TABLES
*        documentfiles   = t_documentfiles.
*
*    LOOP AT t_documentfiles.
*
*      DATA: var_pos      TYPE i,
*            var_file     TYPE string,
*            var_dir      TYPE string,
*            var_filename TYPE string,
*            ls_pos       TYPE string.
*
*      CLEAR: var_pos, var_file, var_dir, var_filename, ls_pos.
*
*      IF t_documentfiles-storagecategory NE 'Z1'.
*
*        var_pos = strlen( t_documentfiles-docfile ).
*
*        DO.
*          var_pos = var_pos - 1.
*          IF var_pos < 0.
*            MOVE t_documentfiles-docfile TO var_file.
*            EXIT.
*          ENDIF.
*          IF t_documentfiles-docfile+var_pos(1) = '\'.
*            var_pos = var_pos + 1.
*            var_file = t_documentfiles-docfile+var_pos.
*            EXIT.
*          ENDIF.
*        ENDDO.
*
*        var_dir = p_file.
*        ls_pos = strlen( var_file ).
*
*        IF ls_pos BETWEEN 40 AND 63.
*          CONCATENATE it_doknr+22() it_dokar+2() var_file+13() INTO var_filename SEPARATED BY '_'.
*        ELSEIF ls_pos BETWEEN 63 AND 102.
*          CONCATENATE it_doknr+22() it_dokar+2() var_file+55() INTO var_filename SEPARATED BY '_'.
*        ELSEIF ls_pos > 103.
*          CONCATENATE it_doknr+22() it_dokar+2() var_file+95() INTO var_filename SEPARATED BY '_'.
*        ELSE.
*          CONCATENATE it_doknr+22() it_dokar+2() var_file INTO var_filename SEPARATED BY '_'.
*        ENDIF.
*
*        CONCATENATE var_dir var_filename INTO var_filename.
*        TRANSLATE var_filename TO UPPER CASE.
*
*        DATA: ps_cout_def  LIKE dms_checkout_def,
*              ps_doc_file  LIKE dms_doc_file,
*              ps_draw      LIKE draw,
*              ps_phio      LIKE dms_phio,
*              ps_frontend  LIKE dms_frontend_data.
*
*        MOVE-CORRESPONDING w_documentdata TO ps_draw.
*        MOVE var_filename TO ps_doc_file-filename.
*        MOVE t_documentfiles-wsapplication TO ps_doc_file-dappl.
*        MOVE t_documentfiles-language TO ps_doc_file-langu.
*
*        MOVE-CORRESPONDING ps_doc_file TO ps_draw.
*        MOVE: 'X' TO ps_cout_def-kpro_use,
*              'X' TO ps_cout_def-comp_get.
*
*        MOVE: 'PC'     TO ps_frontend-frontend_type,
*              'DEFAULT' TO ps_frontend-hostname,
*              'WN32'    TO ps_frontend-winsys.
*
*        CALL FUNCTION 'CV120_DOC_CHECKOUT_VIEW'
*          EXPORTING
*            ps_cout_def = ps_cout_def
*            pf_tcode    = 'CV03'
*            ps_doc_file = ps_doc_file
*            ps_draw     = ps_draw
*            ps_phio     = ps_phio
*            ps_frontend = ps_frontend
*          IMPORTING
*            pfx_file    = pfx_file
*          EXCEPTIONS
*            OTHERS      = 1.
*
*        MOVE-CORRESPONDING ps_draw TO record.
*        record-filep = ps_doc_file-filename.
*
*        SELECT SINGLE dktxt INTO record-dktxt
*          FROM drat
*          WHERE doknr = ps_draw-doknr AND dokar = ps_draw-dokar.
*
*        SELECT SINGLE dokob objky INTO (record-dokob, record-objky)
*          FROM drad
*          WHERE doknr = ps_draw-doknr AND dokar = ps_draw-dokar.
*
*        APPEND record.
*
*      ENDIF.
*    ENDLOOP.
*  ENDLOOP.
*
** Excel Export
*  PERFORM export_to_excel.
*
*ENDFORM.
*
**------------------------------------------------------------*
** FORM: export_to_excel
**------------------------------------------------------------*
*FORM export_to_excel.
*  DATA: gd_filename   TYPE string,
*        gd_path       TYPE string,
*        gd_fullpath   TYPE string,
*        gd_result     TYPE i,
*        f_file        TYPE string,
*        lv_localfile  TYPE localfile.
*
*  TYPES: BEGIN OF gty_fieldnames,
*           title(100),
*         END OF gty_fieldnames.
*
*  DATA: git_fieldnames TYPE STANDARD TABLE OF gty_fieldnames,
*        gwa_fieldnames TYPE gty_fieldnames.
*
*  CLEAR gwa_fieldnames.
*  LOOP AT record.
*    gwa_fieldnames-title = 'MANDT'. APPEND gwa_fieldnames TO git_fieldnames.
*    gwa_fieldnames-title = 'DOKAR'. APPEND gwa_fieldnames TO git_fieldnames.
*    gwa_fieldnames-title = 'DOKNR'. APPEND gwa_fieldnames TO git_fieldnames.
*    gwa_fieldnames-title = 'DOKVR'. APPEND gwa_fieldnames TO git_fieldnames.
*    gwa_fieldnames-title = 'DOKTL'. APPEND gwa_fieldnames TO git_fieldnames.
*    gwa_fieldnames-title = 'DOKST'. APPEND gwa_fieldnames TO git_fieldnames.
*    gwa_fieldnames-title = 'FILEP'. APPEND gwa_fieldnames TO git_fieldnames.
*    gwa_fieldnames-title = 'DKTXT'. APPEND gwa_fieldnames TO git_fieldnames.
*    gwa_fieldnames-title = 'DTTRG'. APPEND gwa_fieldnames TO git_fieldnames.
*    gwa_fieldnames-title = 'DAPPL'. APPEND gwa_fieldnames TO git_fieldnames.
*    gwa_fieldnames-title = 'DOKOB'. APPEND gwa_fieldnames TO git_fieldnames.
*    gwa_fieldnames-title = 'OBJKY'. APPEND gwa_fieldnames TO git_fieldnames.
*    EXIT.
*  ENDLOOP.
*
*  CONCATENATE it_dokar 'excel' INTO f_file SEPARATED BY space.
*
*  CALL METHOD cl_gui_frontend_services=>file_save_dialog
*    EXPORTING
*      window_title      = 'Save File As...'
*      default_extension = 'XLS'
*      default_file_name = f_file
*      initial_directory = p_file
*    CHANGING
*      filename          = gd_filename
*      path              = gd_path
*      fullpath          = gd_fullpath
*      user_action       = gd_result.
*
*  CHECK gd_result = 0.
*
*  CALL FUNCTION 'GUI_DOWNLOAD'
*    EXPORTING
*      filename              = gd_fullpath
*      filetype              = 'ASC'
*      write_field_separator = 'X'
*    TABLES
*      data_tab              = record
*      fieldnames            = git_fieldnames
*    EXCEPTIONS
*      OTHERS                = 1.
*ENDFORM.

TABLES: DRAW,DRAD,DRAT.

DATA : BEGIN OF RECORD OCCURS 0,
  MANDT TYPE DRAW-MANDT,
DOKAR TYPE DRAW-DOKAR,
DOKNR TYPE DRAW-DOKNR,
DOKVR TYPE DRAW-DOKVR,
DOKTL TYPE DRAW-DOKTL,
DOKST TYPE DRAW-DOKST,
FILEP TYPE DRAW-FILEP,
DKTXT TYPE DRAT-DKTXT,
DTTRG TYPE DRAW-DTTRG,
DAPPL TYPE DRAW-DAPPL,
DOKOB TYPE DRAD-DOKOB,
OBJKY TYPE DRAD-OBJKY,
  END OF RECORD.

FIELD-SYMBOLS: <FS_TAB> TYPE DRAW.

*
DATA: W_DOCUMENTNUMBER LIKE BAPI_DOC_AUX-DOCNUMBER,
 W_DOCUMENTNUMBER_IN LIKE BAPI_DOC_AUX-DOCNUMBER,
 W_DOCUMENTTYPE LIKE BAPI_DOC_AUX-DOCTYPE,
 W_DOCUMENTPART LIKE BAPI_DOC_AUX-DOCPART,
 W_DOCUMENTVERSION LIKE BAPI_DOC_AUX-DOCVERSION,
 W_RETURN LIKE BAPIRET2,
 W_DOCUMENTDATA LIKE BAPI_DOC_DRAW2,
 W_DOCUMENTDATAX LIKE BAPI_DOC_DRAWX2.

DATA: WA_REFDOCUMENTTYPE LIKE BAPI_DOC_AUX-DOCTYPE,
 WA_REFDOCUMENTNUMBER LIKE BAPI_DOC_AUX-DOCNUMBER,
 WA_REFDOCUMENTPART LIKE BAPI_DOC_AUX-DOCPART,
 WA_REFDOCUMENTVERSION LIKE BAPI_DOC_AUX-DOCVERSION,
 WA_NEWDOCUMENTVERSION LIKE BAPI_DOC_AUX-DOCVERSION,
 WA_DOCVERSION LIKE BAPI_DOC_AUX-DOCVERSION,
IT_DRAW TYPE TABLE OF DRAW,
LF_TMP_FILE TYPE DRAW-FILEP.

DATA:
 T_OBJECTLINKS LIKE BAPI_DOC_DRAD OCCURS 0 WITH HEADER LINE,
 T_DOCUMENTDESCR LIKE BAPI_DOC_DRAT OCCURS 0 WITH HEADER LINE,
 T_LONGTEXTS LIKE BAPI_DOC_TEXT OCCURS 0 WITH HEADER LINE,
 T_STATUSLOG LIKE BAPI_DOC_DRAP OCCURS 0 WITH HEADER LINE,
 T_COMPONENTS LIKE BAPI_DOC_COMP OCCURS 0 WITH HEADER LINE,
 T_CLASSALLOC LIKE BAPI_CLASS_ALLOCATION OCCURS 0 WITH HEADER LINE,
 T_DOCUMENTFILES LIKE BAPI_DOC_FILES2 OCCURS 0 WITH HEADER LINE,
 T_DOCUMENTSTRUCT LIKE BAPI_DOC_STRUCTURE OCCURS 0 WITH HEADER LINE,
 T_CHARVALUES LIKE BAPI_CHARACTERISTIC_VALUES
 OCCURS 0 WITH HEADER LINE.
DATA: V_FILE TYPE STRING.
DATA: IT_TAB TYPE TABLE OF RECORD.

DATA: IT_DRAD TYPE DRAD OCCURS 0,
      IT_ONJLINK TYPE DOKOB,
      IT_OBJKEY TYPE OBJKY.
FIELD-SYMBOLS : <FS_DRAD> TYPE DRAD.
DATA: GT_DRAW LIKE DRAW OCCURS 0,
      GT_FILE TYPE DMS_REC_FILE2 OCCURS 0,
      IT_DOKAR TYPE DRAW-DOKAR,
      IT_DOKNR  TYPE DRAW-DOKNR,
      IT_DOKTL TYPE DRAW-DOKTL,
      IT_FILEP TYPE DRAW-FILEP,
      IT_FILES TYPE TABLE OF CVAPI_DOC_FILE,
      IT_DOKVR TYPE  DRAW-DOKVR,
      PFX_FILE TYPE DRAW-FILEP,
      LF_FUNC_TYPE TYPE TDWX-APPTP,
      IT_XSTRING TYPE XSTRING,
      LF_CHECK_FILE TYPE C.

*--- Selection-screen
SELECTION-SCREEN: BEGIN OF BLOCK A1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: S_DOKAR FOR DRAW-DOKAR  MEMORY ID CV2,
                S_DOKNR FOR DRAW-DOKNR  MEMORY ID CV1.
* p_doktl LIKE draw-doktl,
* p_dokvr LIKE draw-dokvr.
SELECTION-SCREEN: END OF BLOCK A1.
*
SELECTION-SCREEN: BEGIN OF BLOCK A2 WITH FRAME TITLE TEXT-002.
PARAMETERS: P_FILE TYPE STRING.
SELECTION-SCREEN: END OF BLOCK A2.
*
*SELECTION-SCREEN: BEGIN OF BLOCK a3 WITH FRAME TITLE TEXT-002.
*PARAMETERS: p_exp TYPE string.
*SELECTION-SCREEN: END OF BLOCK a3.

*-- AT SELECTION-SCREEN ON VALUE-REQUEST
AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.
  PERFORM FILE_F4 CHANGING P_FILE.

*--- Start-of-selection
START-OF-SELECTION.

*-- Read Document and download them into a folder

  PERFORM DOWNLOAD_DMS_ATTACHMENT.
* PERFORM display_document.
* PERFORM download_document.

END-OF-SELECTION.


*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_exp.
* PERFORM file_f5 CHANGING p_exp.
*--- Start-of-selection


*&---------------------------------------------------------------------*
*& Form FILE_F4
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* <--P_P_FILE text
*----------------------------------------------------------------------*
FORM FILE_F4 CHANGING P_FILE.

  DATA: LV_TITLE TYPE STRING, " Title
   LV_PATH TYPE STRING. " For path

  LV_TITLE = 'Choose Directory'.
  LV_PATH = P_FILE.

* To Provide F4 help for selecting the folder Path.
  CALL METHOD CL_GUI_FRONTEND_SERVICES=>DIRECTORY_BROWSE
    EXPORTING
      WINDOW_TITLE         = LV_TITLE
      INITIAL_FOLDER       = LV_PATH
    CHANGING
      SELECTED_FOLDER      = LV_PATH
    EXCEPTIONS
      CNTL_ERROR           = 1
      ERROR_NO_GUI         = 2
      NOT_SUPPORTED_BY_GUI = 3
      OTHERS               = 4.

  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
    WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  P_FILE = LV_PATH.

ENDFORM. " FILE_F4





*&---------------------------------------------------------------------*
*&      Form  Download_DMS_attachment
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM DOWNLOAD_DMS_ATTACHMENT.

  FIELD-SYMBOLS: <FS_DRAW> TYPE DRAW.

  " get document-data

  CLEAR GT_DRAW. REFRESH GT_DRAW.
  SELECT * FROM DRAW INTO TABLE GT_DRAW
  WHERE DOKAR IN S_DOKAR AND
        DOKNR IN S_DOKNR.



  IF SY-SUBRC = 0.
    LOOP AT GT_DRAW ASSIGNING <FS_DRAW>.
      IT_DOKAR =  <FS_DRAW>-DOKAR.
      IT_DOKNR =  <FS_DRAW>-DOKNR.
      IT_DOKTL =  <FS_DRAW>-DOKTL.
      IT_DOKVR =   <FS_DRAW>-DOKVR.
      IT_FILEP =    <FS_DRAW>-FILEP.



      " CHANGE_DOCUMENT
*&---------------------------------------------------------------------*
*& Form DISPLAY_DOCUMENT
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
*FORM display_document .


      CALL FUNCTION 'BAPI_DOCUMENT_GETDETAIL2'
        EXPORTING
          DOCUMENTTYPE    = IT_DOKAR
          DOCUMENTNUMBER  = IT_DOKNR
          DOCUMENTPART    = IT_DOKTL
          DOCUMENTVERSION = IT_DOKVR
          GETDOCFILES     = 'X'
        IMPORTING
          DOCUMENTDATA    = W_DOCUMENTDATA
        TABLES
          DOCUMENTFILES   = T_DOCUMENTFILES.

*download_document .

      DATA: VAR_POS TYPE I.
      DATA: VAR_FILE TYPE STRING.
      DATA: VAR_DIR TYPE STRING.
      DATA: VAR_FILENAME TYPE STRING.

      DATA: PS_COUT_DEF LIKE DMS_CHECKOUT_DEF,
       PS_DOC_FILE LIKE DMS_DOC_FILE,
       PS_DRAW LIKE DRAW,
       VS_DRAW LIKE DRAW,
       PS_PHIO LIKE DMS_PHIO,
       PS_FRONTEND LIKE DMS_FRONTEND_DATA,
       PFX_FILE LIKE DRAW-FILEP.

      DATA:LS_POS TYPE STRING.
      LOOP AT T_DOCUMENTFILES.

        IF T_DOCUMENTFILES-STORAGECATEGORY NE 'Z1'.
          " Get the File Name
          CLEAR VAR_POS.
          VAR_POS = STRLEN( T_DOCUMENTFILES-DOCFILE ).
*          LS_POS = VAR_POS.
          DO.
            VAR_POS = VAR_POS - 1.
            IF VAR_POS < 0.
              MOVE T_DOCUMENTFILES-DOCFILE TO VAR_FILE.
              EXIT.
            ENDIF.
            IF T_DOCUMENTFILES-DOCFILE+VAR_POS(1) EQ '\'.
              VAR_POS = VAR_POS + 1.
              MOVE T_DOCUMENTFILES-DOCFILE+VAR_POS TO VAR_FILE.
              EXIT.
            ENDIF.
          ENDDO.

          " Populate File Name
          VAR_DIR = P_FILE.
           ls_POS = STRLEN( VAR_FILE ).

          IF LS_POS  BETWEEN  40 AND 63.
            CONCATENATE IT_DOKNR+22() IT_DOKAR+2() VAR_FILE+13() INTO VAR_FILENAME SEPARATED BY '_'.

          ELSEIF   LS_POS BETWEEN  63 AND 102 .
            CONCATENATE IT_DOKNR+22() IT_DOKAR+2() VAR_FILE+55() INTO VAR_FILENAME SEPARATED BY '_'.
          ELSEIF LS_POS > 103.
            CONCATENATE IT_DOKNR+22() IT_DOKAR+2() VAR_FILE+95() INTO VAR_FILENAME SEPARATED BY '_'.
          ELSE.
            CONCATENATE IT_DOKNR+22() IT_DOKAR+2() VAR_FILE INTO VAR_FILENAME SEPARATED BY '_'.
          ENDIF.

          CONCATENATE VAR_DIR  VAR_FILENAME INTO VAR_FILENAME.
          TRANSLATE VAR_FILENAME TO UPPER CASE.


          " Populate import structures
          CLEAR: PS_COUT_DEF, PS_DOC_FILE, PS_DRAW,
          PS_PHIO, PS_FRONTEND, PFX_FILE.

          MOVE: 'X' TO PS_COUT_DEF-KPRO_USE,
           'X' TO PS_COUT_DEF-COMP_GET.

          MOVE: T_DOCUMENTFILES-LANGUAGE TO PS_DOC_FILE-LANGU,
           VAR_FILENAME TO PS_DOC_FILE-FILENAME,
           T_DOCUMENTFILES-WSAPPLICATION TO PS_DOC_FILE-DAPPL.


          MOVE: SY-MANDT TO PS_DRAW-MANDT,
           W_DOCUMENTDATA-DOCUMENTTYPE TO PS_DRAW-DOKAR,
           W_DOCUMENTDATA-DOCUMENTNUMBER TO PS_DRAW-DOKNR,
           W_DOCUMENTDATA-DOCUMENTVERSION TO PS_DRAW-DOKVR,
           W_DOCUMENTDATA-DOCUMENTPART TO PS_DRAW-DOKTL,
* w_documentdata-username TO ps_draw-dwnam,
 W_DOCUMENTDATA-STATUSINTERN TO PS_DRAW-DOKST,
* w_documentdata-createdate TO ps_draw-adatum,
            PS_DOC_FILE-FILENAME TO  PS_DRAW-FILEP,
            PS_DOC_FILE-DAPPL TO  PS_DRAW-DAPPL.

          SELECT * FROM DRAT WHERE DOKNR = PS_DRAW-DOKNR AND DOKAR = PS_DRAW-DOKAR.
          ENDSELECT.
          IF SY-SUBRC = 0.
            MOVE DRAT-DKTXT TO RECORD-DKTXT.
          ENDIF.
          SELECT * FROM DRAD WHERE DOKNR = PS_DRAW-DOKNR AND DOKAR = PS_DRAW-DOKAR.
          ENDSELECT.
          IF SY-SUBRC = 0.
            MOVE: DRAD-DOKOB TO RECORD-DOKOB,
            DRAD-OBJKY TO RECORD-OBJKY.
          ELSE.
            RECORD-DOKOB = ' '.
            RECORD-OBJKY = ' '.
          ENDIF.

          RECORD-MANDT = PS_DRAW-MANDT.
          RECORD-DOKAR = PS_DRAW-DOKAR.
          RECORD-DOKNR = PS_DRAW-DOKNR.
          RECORD-DOKTL = PS_DRAW-DOKTL.
          RECORD-DOKVR = PS_DRAW-DOKVR.
          RECORD-DOKST = PS_DRAW-DOKST.
          RECORD-FILEP = PS_DRAW-FILEP.
          RECORD-DTTRG = PS_DRAW-DTTRG.
          RECORD-DAPPL = PS_DRAW-DAPPL.
          APPEND RECORD.
          " added drad


          MOVE: T_DOCUMENTFILES-ORIGINALTYPE TO PS_PHIO-LO_INDEX,
           T_DOCUMENTFILES-STORAGECATEGORY TO PS_PHIO-STORAGE_CAT,
           VAR_FILENAME TO PS_PHIO-FILENAME,
           T_DOCUMENTFILES-APPLICATION_ID TO PS_PHIO-LO_OBJID,
           T_DOCUMENTFILES-FILE_ID TO PS_PHIO-PH_OBJID,
           T_DOCUMENTFILES-LANGUAGE TO PS_PHIO-LANGU,
           T_DOCUMENTFILES-ACTIVE_VERSION TO PS_PHIO-ACTIVE_VERSION,
           'X' TO PS_PHIO-DELETE_FLAG,
           'X' TO PS_PHIO-PROTECTED,
           'X' TO PS_PHIO-DEFAULT_LANGU.

          MOVE: 'PC' TO PS_FRONTEND-FRONTEND_TYPE,
           'DEFAULT' TO PS_FRONTEND-HOSTNAME,
           'WN32' TO PS_FRONTEND-WINSYS.

          CALL FUNCTION 'CV120_DOC_CHECKOUT_VIEW'
            EXPORTING
              PS_COUT_DEF = PS_COUT_DEF
              PF_TCODE    = 'CV03'
              PS_DOC_FILE = PS_DOC_FILE
              PS_DRAW     = PS_DRAW
              PS_PHIO     = PS_PHIO
              PS_FRONTEND = PS_FRONTEND
            IMPORTING
              PFX_FILE    = PFX_FILE
            EXCEPTIONS
              ERROR       = 1
              OTHERS      = 2.
          IF SY-SUBRC <> 0.
          ELSE.

          ENDIF.

        ELSEIF  T_DOCUMENTFILES-STORAGECATEGORY EQ 'Z1'.


          MOVE: SY-MANDT TO PS_DRAW-MANDT,
          W_DOCUMENTDATA-DOCUMENTTYPE TO PS_DRAW-DOKAR,
          W_DOCUMENTDATA-DOCUMENTNUMBER TO PS_DRAW-DOKNR,
          W_DOCUMENTDATA-DOCUMENTVERSION TO PS_DRAW-DOKVR,
          W_DOCUMENTDATA-DOCUMENTPART TO PS_DRAW-DOKTL,
          W_DOCUMENTDATA-STATUSINTERN TO PS_DRAW-DOKST,
          T_DOCUMENTFILES-STORAGECATEGORY TO PS_DRAW-DTTRG,
          T_DOCUMENTFILES-DOCFILE TO VAR_FILE,
*         PS_DOC_FILE-FILENAME TO  PS_DRAW-FILEP,
            T_DOCUMENTFILES-WSAPPLICATION TO  PS_DRAW-DAPPL.

          DATA : WA_D TYPE DRAW.
          DATA : YT_DRAW TYPE TABLE OF DRAW.
          DATA : IT_FILE TYPE DRAW.
          DATA : LV_PATH TYPE STRING.
          DATA :X_FILE_WITH_PATH TYPE STRING.
          LV_PATH = 'C:/DMS/'.


          CONCATENATE LV_PATH VAR_FILE INTO X_FILE_WITH_PATH.

          CALL METHOD CL_GUI_FRONTEND_SERVICES=>DIRECTORY_EXIST

          EXPORTING

          DIRECTORY = LV_PATH

*RECEIVING
*
*result = lv_valid

          EXCEPTIONS

          CNTL_ERROR = 1

          ERROR_NO_GUI = 2

          WRONG_PARAMETER = 3

          NOT_SUPPORTED_BY_GUI = 4

          OTHERS = 5.

          CALL METHOD CL_GUI_FRONTEND_SERVICES=>FILE_EXIST

          EXPORTING

          FILE = X_FILE_WITH_PATH

*RECEIVING
*
*result = y_file_exists

          EXCEPTIONS

          CNTL_ERROR = 1

          ERROR_NO_GUI = 2

          WRONG_PARAMETER = 3

          NOT_SUPPORTED_BY_GUI = 4

          OTHERS = 5.


          IF SY-SUBRC = 0 .
            MOVE  X_FILE_WITH_PATH TO RECORD-FILEP.
*            VS_DRAW-FILEP = RECORD-FILEP.
          ENDIF.

          SELECT * FROM DRAT WHERE DOKNR = PS_DRAW-DOKNR AND DOKAR = PS_DRAW-DOKAR.
          ENDSELECT.
          IF SY-SUBRC = 0.
            MOVE DRAT-DKTXT TO RECORD-DKTXT.
          ENDIF.
          SELECT * FROM DRAD WHERE DOKNR = PS_DRAW-DOKNR AND DOKAR = PS_DRAW-DOKAR.
          ENDSELECT.
          IF SY-SUBRC = 0.
            MOVE: DRAD-DOKOB TO RECORD-DOKOB.
            MOVE: DRAD-OBJKY TO RECORD-OBJKY.
          ELSE.
            RECORD-DOKOB = ' '.
            RECORD-OBJKY = ' '.
          ENDIF.
*              if RECORD-DOKOB eq 'EKPO'.
*              RECORD-OBJKY = DRAD-OBJKY+0(10).
*              endif.

          RECORD-MANDT = PS_DRAW-MANDT.
          RECORD-DOKAR = PS_DRAW-DOKAR.
          RECORD-DOKNR = PS_DRAW-DOKNR.
          RECORD-DOKTL = PS_DRAW-DOKTL.
          RECORD-DOKVR = PS_DRAW-DOKVR.
          RECORD-DOKST = PS_DRAW-DOKST.
*          RECORD-FILEP = PS_DRAW-FILEP.
          RECORD-DTTRG = PS_DRAW-DTTRG.
          RECORD-DAPPL = PS_DRAW-DAPPL.

          APPEND RECORD.

        ENDIF.
      ENDLOOP.
    ENDLOOP.


  ENDIF.


  DATA: LV_LOCALFILE TYPE LOCALFILE.

  DATA : F_FILE TYPE STRING.

  CONCATENATE IT_DOKAR 'excel' INTO F_FILE SEPARATED BY ' '.

  TYPES : BEGIN OF GTY_FIELDNAMES,

  TITLE(100),

  END OF GTY_FIELDNAMES.

  DATA: GIT_FIELDNAMES TYPE STANDARD TABLE OF GTY_FIELDNAMES,

  GWA_FIELDNAMES TYPE GTY_FIELDNAMES.

  DATA : GD_FILENAME TYPE STRING,

  GD_PATH TYPE STRING,

  GD_FULLPATH TYPE STRING,

  GD_RESULT TYPE I.

  CLEAR GWA_FIELDNAMES.
  GWA_FIELDNAMES-TITLE = 'MANDT'.
  APPEND GWA_FIELDNAMES TO GIT_FIELDNAMES.
  CLEAR GWA_FIELDNAMES.

  GWA_FIELDNAMES-TITLE = 'DOKAR'.
  APPEND GWA_FIELDNAMES TO GIT_FIELDNAMES.
  CLEAR GWA_FIELDNAMES.
  GWA_FIELDNAMES-TITLE  = 'DOKNR'.
  APPEND GWA_FIELDNAMES TO GIT_FIELDNAMES.
  CLEAR GWA_FIELDNAMES.
  GWA_FIELDNAMES-TITLE = 'DOKVR'.
  APPEND GWA_FIELDNAMES TO GIT_FIELDNAMES.
  CLEAR GWA_FIELDNAMES.
  GWA_FIELDNAMES-TITLE = 'DOKTL'.
  APPEND GWA_FIELDNAMES TO GIT_FIELDNAMES.
  CLEAR GWA_FIELDNAMES.
  GWA_FIELDNAMES-TITLE = 'DOKST'.
  APPEND GWA_FIELDNAMES TO GIT_FIELDNAMES.
  CLEAR GWA_FIELDNAMES.
  GWA_FIELDNAMES-TITLE = 'FILEP'.
  APPEND GWA_FIELDNAMES TO GIT_FIELDNAMES.
  CLEAR GWA_FIELDNAMES.
  GWA_FIELDNAMES-TITLE = 'DKTXT'.
  APPEND GWA_FIELDNAMES TO GIT_FIELDNAMES.
  CLEAR GWA_FIELDNAMES.
  GWA_FIELDNAMES-TITLE = 'DTTRG'.
  APPEND GWA_FIELDNAMES TO GIT_FIELDNAMES.
  CLEAR GWA_FIELDNAMES.
  GWA_FIELDNAMES-TITLE = 'DAPPL'.
  APPEND GWA_FIELDNAMES TO GIT_FIELDNAMES.
  CLEAR GWA_FIELDNAMES.
  GWA_FIELDNAMES-TITLE = 'DOKOB'.
  APPEND GWA_FIELDNAMES TO GIT_FIELDNAMES.
  CLEAR GWA_FIELDNAMES.
  GWA_FIELDNAMES-TITLE = 'OBJKY'.
  APPEND GWA_FIELDNAMES TO GIT_FIELDNAMES.
  CLEAR GWA_FIELDNAMES.



  APPEND GWA_FIELDNAMES TO GIT_FIELDNAMES.

*lv_LOCALFILE = p_file && |'excel/file.xls'|.



  CALL METHOD CL_GUI_FRONTEND_SERVICES=>FILE_SAVE_DIALOG
    EXPORTING
      WINDOW_TITLE      = 'Save File As...'
      DEFAULT_EXTENSION = 'XLS'
      DEFAULT_FILE_NAME = F_FILE
      INITIAL_DIRECTORY = P_FILE
    CHANGING
      FILENAME          = GD_FILENAME
      PATH              = GD_PATH
      FULLPATH          = GD_FULLPATH
      USER_ACTION       = GD_RESULT.

  CHECK GD_RESULT EQ '0'.

  P_FILE = GD_FULLPATH.

* Check user did not cancel request

  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      FILENAME              = GD_FULLPATH
      FILETYPE              = 'ASC'
      WRITE_FIELD_SEPARATOR = 'X'
    TABLES
      DATA_TAB              = RECORD " Internal table having data
      FIELDNAMES            = GIT_FIELDNAMES " Internal table having headings
    EXCEPTIONS
      FILE_OPEN_ERROR       = 1                         "#EC ARGCHECKED
      FILE_WRITE_ERROR      = 2
      OTHERS                = 3.

ENDFORM.                    "Download_DMS_attachment
