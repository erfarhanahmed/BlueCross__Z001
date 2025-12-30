report zsampdata_bdc_01       no standard page heading line-size 255.

*BCDK913740

*parameters : filename like rlgrap-filename.


*data: begin of record OCCURS 0.
*include STRUCTURE ZSAMPDATA.
*DATA: end of record.

types : begin of str,
        zmonth type zsampdata-zmonth,
        zyear type zsampdata-zyear,
        bzirk type zsampdata-bzirk,
        matnr type zsampdata-matnr,
        mvgr4 type zsampdata-mvgr4,
        qty type zsampdata-qty,
      end of str.



data: datatab    type table of str,
      wa_datatab type str,
      wa_datatab1 type zsampdata,

      ld_lines   type i,
      ld_file    type string.


data : deltab TYPE table of zsampdata.


data: data_suc    type table of str with header line.


data: data_error    type table of str with header line.


skip 10 .

parameters : filename like rlgrap-filename.

data : p_file(300) type c.

skip  10 .

PARAMETERS  :  Mon_del type zsampdata-zmonth,
               year_del type zsampdata-zyear.

PARAMETERS : del as CHECKBOX DEFAULT ' '.

*** End generated data section ***
at selection-screen on value-request for filename.

  perform export_file.



  AT SELECTION-SCREEN.

    if     del = 'X'.
      if  Mon_del is not  INITIAL and year_del is not INITIAL.
        else.
          message 'Kindly  give both inputs for deletion'  type 'E'.

      endif.
    endif.

start-of-selection.


  if del is INITIAL.
  perform upload_file.
  perform  update.

  ELSEIF del = 'X'.
    refresh deltab.


    SELECT * from zsampdata into table deltab
    where ZMONTH = Mon_del and ZYEAR = year_del.

    delete zsampdata  from table deltab.
    if sy-subrc = 0.
     MESSAGE   'Entries Deleted ' type  'S'.
    endif.
  endif.





form upload_file.
  ld_file = p_file = filename.
  call function 'GUI_UPLOAD'
    exporting
      filename                      = ld_file
      filetype                      = 'ASC'
      has_field_separator           = 'X'
*    header_length                 = header_length
*    read_by_line                  = read_by_line
*    dat_mode                      = dat_mode
*    codepage                      = codepage
*    ignore_cerr                   = ignore_cerr
*    replacement                   = replacement
*    virus_scan_profile            = virus_scan_profile
*  importing
*    filelength                    = filelength
*    header                        = header
    tables
      data_tab                      = datatab
    exceptions
      file_open_error               = 1
      file_read_error               = 2
      no_batch                      = 3
      gui_refuse_filetransfer       = 4
      invalid_type                  = 5
      no_authority                  = 6
      unknown_error                 = 7
      bad_data_format               = 8
      header_not_allowed            = 9
      separator_not_allowed         = 10
      header_too_long               = 11
      unknown_dp_error              = 12
      access_denied                 = 13
      dp_out_of_memory              = 14
      disk_full                     = 15
      dp_timeout                    = 16
      others                        = 17
      .


endform.                    " UPLOAD_FILE
*---------------------------------------------------------------------*
*       FORM EXPORT_FILE                                              *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
form export_file.
  call function 'WS_FILENAME_GET'
      exporting
         def_filename     = ' '
         def_path         = filename
         mask             = ',*.*,*.*.'
         mode             = 'O'
         title            = 'Choose from file'
   importing
         filename         = filename
*        RC               =
      exceptions
         inv_winsys       = 1
         no_batch         = 2
         selection_cancel = 3
         selection_error  = 4
         others           = 5
            .
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.
endform.                    "export_file

form UPDATE .

  if datatab[] is not initial.
    loop at datatab into wa_datatab.
*      if wa_datatab-zmonth is not initial and wa_datatab-zyear is not initial  and wa_datatab-bzirk is not initial  and
*         wa_datatab-matnr is not initial  and wa_datatab-mvgr4 is not initial  .
        move-corresponding wa_datatab  to wa_datatab1.
        CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
          EXPORTING
            INPUT        = WA_DATATAB-MATNR
          IMPORTING
            OUTPUT       = WA_DATATAB1-MATNR
          EXCEPTIONS
            LENGTH_ERROR = 1
            OTHERS       = 2.
        IF SY-SUBRC <> 0.
* Implement suitable error handling here
        ENDIF.

        move sy-mandt to wa_datatab1-mandt.
        modify  zsampdata from wa_datatab1 .
        clear wa_datatab.
        if sy-subrc = 0.
          move-corresponding wa_datatab1  to wa_datatab.
          append wa_datatab to data_suc.
          commit work.
        else.
          move-corresponding wa_datatab1  to wa_datatab.
          append wa_datatab to data_error.
        endif.
*      endif.
      clear wa_datatab.
      call function 'SAPGUI_PROGRESS_INDICATOR'
        exporting
*          percentage =
          text       = sy-tabix .
    endloop.
  endif.

*  write  : / 'SUCCESS'.
  loop at  data_suc.
    format color 5.
    write : /  , data_suc-zyear , data_suc-bzirk ,data_suc-matnr .
  endloop.

*  write  : / 'ERROR'.
  loop at    data_error.
    format color 6.
    write : / , data_error-zyear , data_error-bzirk , data_error-matnr .
  endloop.
endform.                    " UPDATE
