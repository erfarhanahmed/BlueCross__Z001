*&---------------------------------------------------------------------*
*& Report  YR_SD_UPLOAD_SAT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

report  yr_sd_upload_sat_1.

type-pools: slis.

types: begin of ty_vbrk,
         mandt type mandt,
         vbeln type vbrk-vbeln,
         fkart type vbrk-fkart,
         fkdat type vbrk-fkdat,
         kunrg type vbrk-kunrg,
         fksto type vbrk-fksto,
       end of ty_vbrk.
types: begin of ty_kna1,
         kunnr type kna1-kunnr,
         name1 type kna1-name1,
       end of ty_kna1.

types: begin of ty_final,
         chk         type  char5,
         mandt       type mandt,
         vbeln       type vbrk-vbeln,
         fkdat       type vbrk-fkdat,
         werks       type vbrp-werks,
         kunrg       type vbrk-kunrg,
         name1       type kna1-name1,
         lrno        type likp-bolnr,
         lrdate      type bseg-zfbdt,
         cases(40),  " type LIKP-BOLNR,
         vbeln_dummy type char20,

       end of ty_final.

types: begin of ty_bkpf,
         bukrs type bkpf-bukrs,
         belnr type bkpf-belnr,
         gjahr type bkpf-gjahr,
         awkey type bkpf-awkey,
       end of ty_bkpf.

types: begin of ty_vbrp,
         vbeln type vbrk-vbeln,
         werks type vbrp-werks,
         vgbel type vbrp-vgbel,
       end of ty_vbrp.

types: begin of ty_vbrp1,
         vbeln type vbrk-vbeln,
         matnr type vbrp-matnr,
         werks type vbrp-werks,
         vgbel type vbrp-vgbel,
       end of ty_vbrp1.

data: v_fkdat type vbrk-fkdat,
      v_werks type vbrp-werks.

data: it_vbrk     type table of ty_vbrk,
      wa_vbrk     type ty_vbrk,
      it_kna1     type table of ty_kna1,
      wa_kna1     type ty_kna1,
      l_year      type char4,
      l_fyv       type periv,
      bdcdata     like bdcdata    occurs 0 with header line,
      it_vbrp     type table of ty_vbrp,
      wa_vbrp     type ty_vbrp,
      it_vbrp1    type table of ty_vbrp1,
      wa_vbrp1    type ty_vbrp1,
      it_final    type table of ty_final,
      wa_final    type ty_final,
      wa_dat      type char10,
      it_zupload  type table of zupload,
      wa_zupload  type zupload,
      it_bkpf     type table of ty_bkpf,
      wa_bkpf     type ty_bkpf,
      it_fieldcat type slis_t_fieldcat_alv,
      l_glay      type lvc_s_glay,
      ls_layout   type slis_layout_alv,
      wa_fieldcat type slis_fieldcat_alv,
      it_mess     type table of bdcmsgcoll,
      wa_mess     type bdcmsgcoll,
      wa_tdhead   type thead,

      it_tline2   type table of tline,
      wa_tline2   type tline.

selection-screen: begin of block blk with frame title text-001.
select-options: s_fkdat for v_fkdat no-extension obligatory,
                s_werks for v_werks no intervals no-extension obligatory.
selection-screen end of block blk.

selection-screen: begin of block b2 with frame title text-002.
parameters: p_rad1 radiobutton group r1,
            p_rad2 radiobutton group r1.
selection-screen: end of block b2.

perform get_fiscal_year.
perform select.
perform fill_final_table.

if p_rad1 = 'X'.
  perform alv_display.
else.
  perform alv_display1.
endif.






*&---------------------------------------------------------------------*
*&      Form  SELECT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form select.
  select mandt vbeln fkart fkdat kunrg fksto from vbrk into table it_vbrk where fkdat in s_fkdat and fkart in ('ZBDF','ZCDF','Z002','Z004').
  if sy-subrc = 0.
    sort it_vbrk by vbeln.
  endif.
  delete it_vbrk where fksto = 'X'.
  if it_vbrk is not initial.
    select vbeln matnr werks vgbel from vbrp into table it_vbrp1 for all entries in it_vbrk where vbeln = it_vbrk-vbeln and werks in s_werks.
    if sy-subrc = 0.
      sort it_vbrp by vbeln.
    endif.
    select vbeln werks vgbel from vbrp into table it_vbrp for all entries in it_vbrk where vbeln = it_vbrk-vbeln and werks in s_werks.
    if sy-subrc = 0.
      sort it_vbrp by vbeln.
    endif.
    select kunnr name1 from kna1 into table it_kna1 for all entries in it_vbrk where kunnr = it_vbrk-kunrg.
    select * from zupload into table it_zupload for all entries in it_vbrk where vbeln = it_vbrk-vbeln.
*        SELECT BELNR GJAHR VBELN ZFBDT FROM BSEG INTO TABLE IT_BSEG
*             FOR ALL ENTRIES IN IT_VBRK WHERE BUKRS = 'BCLL'
*                                        AND GJAHR = L_YEAR
  endif.
endform.                    " SELECT
*&---------------------------------------------------------------------*
*&      Form  FILL_FINAL_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form fill_final_table .
  loop at it_vbrp1 into wa_vbrp1.
    wa_final-werks = wa_vbrp1-werks.
    read table it_vbrk into wa_vbrk with key vbeln = wa_vbrp1-vbeln.
    if sy-subrc = 0.
      if wa_vbrk-fkart eq 'Z002' OR wa_vbrk-fkart eq 'Z004'.
        if wa_vbrp1-matnr+10(3) eq '425'.
        else.
          delete it_vbrk where vbeln eq wa_vbrp1-vbeln.
          delete it_vbrp where vbeln eq wa_vbrp1-vbeln.
        endif.
      endif.
    endif.
*    append wa_final to it_final.
*    clear wa_final.
  endloop.
  loop at it_vbrp into wa_vbrp.
    wa_final-werks = wa_vbrp-werks.
    read table it_vbrk into wa_vbrk with key vbeln = wa_vbrp-vbeln.
    if sy-subrc = 0.
      wa_final-mandt = wa_vbrk-mandt.
      wa_final-vbeln = wa_vbrk-vbeln.
      wa_final-fkdat = wa_vbrk-fkdat.
      wa_final-kunrg = wa_vbrk-kunrg.

      read table it_kna1 into wa_kna1 with key kunnr = wa_vbrk-kunrg.
      if sy-subrc = 0.
        wa_final-name1 = wa_kna1-name1.
      endif.
      read table it_zupload into wa_zupload with key vbeln = wa_vbrk-vbeln.
      if sy-subrc = 0.
        wa_final-lrno = wa_zupload-bolnr.
        wa_final-lrdate = wa_zupload-zfbdt.
        wa_final-cases = wa_zupload-cases.
      endif.
    endif.

    append wa_final to it_final.
    clear wa_final.
  endloop.

  loop at it_final into wa_final.
    wa_final-vbeln_dummy = wa_final-vbeln.
    modify it_final from wa_final.
    clear wa_final.
  endloop.

  if it_final is not initial.
    select bukrs belnr gjahr awkey from bkpf into table it_bkpf for all entries in it_final
                                                         where awtyp = 'VBRK'

                                                          and awkey = it_final-vbeln_dummy
                                                          and awsys = space.
  endif.

endform.                    " FILL_FINAL_TABLE
*&---------------------------------------------------------------------*
*&      Form  FILL_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form fill_fieldcat .
  clear wa_fieldcat.
  refresh it_fieldcat.
  l_glay-edt_cll_cb = 'X'.

  ls_layout-colwidth_optimize = 'X'.

  wa_fieldcat-fieldname = 'CHK'.
  wa_fieldcat-seltext_l = ''.
  wa_fieldcat-checkbox = 'X'.
  wa_fieldcat-edit = 'X'.
  append wa_fieldcat to it_fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'VBELN'.
  wa_fieldcat-seltext_l = 'Billing Document'.
  append wa_fieldcat to it_fieldcat.

  wa_fieldcat-fieldname = 'FKDAT'.
  wa_fieldcat-seltext_l = 'Billing Date'.
  append wa_fieldcat to it_fieldcat.

  wa_fieldcat-fieldname = 'KUNRG'.
  wa_fieldcat-seltext_l = 'Party Code'.
  append wa_fieldcat to it_fieldcat.

  wa_fieldcat-fieldname = 'NAME1'.
  wa_fieldcat-seltext_l = 'Party name'.
  append wa_fieldcat to it_fieldcat.

  wa_fieldcat-fieldname = 'LRNO'.
  wa_fieldcat-seltext_l = 'Lr Number'.
  wa_fieldcat-edit = 'X'.
  wa_fieldcat-outputlen = '35'.
  append wa_fieldcat to it_fieldcat.

  wa_fieldcat-fieldname = 'LRDATE'.
  wa_fieldcat-seltext_l = 'Lr Date'.
  wa_fieldcat-edit = 'X'.
  append wa_fieldcat to it_fieldcat.

  wa_fieldcat-fieldname = 'CASES'.
  wa_fieldcat-seltext_l = 'No of Cases'.
  wa_fieldcat-edit = 'X'.
  wa_fieldcat-outputlen = '40'.
  append wa_fieldcat to it_fieldcat.

endform.                    " FILL_FIELDCAT
*&---------------------------------------------------------------------*
*&      Form  ALV_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form alv_display .

  perform fill_fieldcat.

  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
*     I_INTERFACE_CHECK        = ' '
*     I_BYPASSING_BUFFER       = ' '
*     I_BUFFER_ACTIVE          = ' '
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'STATUS'
      i_callback_user_command  = 'USER_COMMAND'
*     I_CALLBACK_TOP_OF_PAGE   = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME         =
*     I_BACKGROUND_ID          = ' '
*     I_GRID_TITLE             =
      i_grid_settings          = l_glay
      is_layout                = ls_layout
      it_fieldcat              = it_fieldcat
*     IT_EXCLUDING             =
*     IT_SPECIAL_GROUPS        =
*     IT_SORT                  =
*     IT_FILTER                =
*     IS_SEL_HIDE              =
*     I_DEFAULT                = 'X'
*     I_SAVE                   = ' '
*     IS_VARIANT               =
*     IT_EVENTS                =
*     IT_EVENT_EXIT            =
*     IS_PRINT                 =
*     IS_REPREP_ID             =
*     I_SCREEN_START_COLUMN    = 0
*     I_SCREEN_START_LINE      = 0
*     I_SCREEN_END_COLUMN      = 0
*     I_SCREEN_END_LINE        = 0
*     I_HTML_HEIGHT_TOP        = 0
*     I_HTML_HEIGHT_END        = 0
*     IT_ALV_GRAPHICS          =
*     IT_HYPERLINK             =
*     IT_ADD_FIELDCAT          =
*     IT_EXCEPT_QINFO          =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER  =
*     ES_EXIT_CAUSED_BY_USER   =
    tables
      t_outtab                 = it_final
*   EXCEPTIONS
*     PROGRAM_ERROR            = 1
*     OTHERS                   = 2
    .
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.


endform.                    " ALV_DISPLAY
*&---------------------------------------------------------------------*
*&      Form  ALV_DISPLAY1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form alv_display1 .

  perform fill_fieldcat.

  loop at it_final into wa_final where lrno is not initial and lrdate is not initial
                                 and cases is not initial.
    delete it_final.
  endloop.

  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
*     I_INTERFACE_CHECK        = ' '
*     I_BYPASSING_BUFFER       = ' '
*     I_BUFFER_ACTIVE          = ' '
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'STATUS'
      i_callback_user_command  = 'USER_COMMAND'
*     I_CALLBACK_TOP_OF_PAGE   = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME         =
*     I_BACKGROUND_ID          = ' '
*     I_GRID_TITLE             =
      i_grid_settings          = l_glay
      is_layout                = ls_layout
      it_fieldcat              = it_fieldcat
*     IT_EXCLUDING             =
*     IT_SPECIAL_GROUPS        =
*     IT_SORT                  =
*     IT_FILTER                =
*     IS_SEL_HIDE              =
*     I_DEFAULT                = 'X'
*     I_SAVE                   = ' '
*     IS_VARIANT               =
*     IT_EVENTS                =
*     IT_EVENT_EXIT            =
*     IS_PRINT                 =
*     IS_REPREP_ID             =
*     I_SCREEN_START_COLUMN    = 0
*     I_SCREEN_START_LINE      = 0
*     I_SCREEN_END_COLUMN      = 0
*     I_SCREEN_END_LINE        = 0
*     I_HTML_HEIGHT_TOP        = 0
*     I_HTML_HEIGHT_END        = 0
*     IT_ALV_GRAPHICS          =
*     IT_HYPERLINK             =
*     IT_ADD_FIELDCAT          =
*     IT_EXCEPT_QINFO          =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER  =
*     ES_EXIT_CAUSED_BY_USER   =
    tables
      t_outtab                 = it_final
*   EXCEPTIONS
*     PROGRAM_ERROR            = 1
*     OTHERS                   = 2
    .
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.



endform.
form status using rt_extab type slis_t_extab.
  set pf-status 'STATUS_2' of program 'YR_SD_UPLOAD_SAT' .
endform.                    " ALV_DISPLAY1

form user_command using r_ucomm like sy-ucomm
                        rs_selfield type slis_selfield.
  case r_ucomm.



    when 'DELETE'.

      rs_selfield-refresh = 'X'.

      loop at it_final into wa_final where chk = 'X'.
        delete it_final.
      endloop.

      perform fill_fieldcat.

      call function 'REUSE_ALV_GRID_DISPLAY'
        exporting
*         I_INTERFACE_CHECK        = ' '
*         I_BYPASSING_BUFFER       = ' '
*         I_BUFFER_ACTIVE          = ' '
          i_callback_program       = sy-repid
          i_callback_pf_status_set = 'STATUS'
          i_callback_user_command  = 'USER_COMMAND'
*         I_CALLBACK_TOP_OF_PAGE   = ' '
*         I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*         I_CALLBACK_HTML_END_OF_LIST       = ' '
*         I_STRUCTURE_NAME         =
*         I_BACKGROUND_ID          = ' '
*         I_GRID_TITLE             =
          i_grid_settings          = l_glay
          is_layout                = ls_layout
          it_fieldcat              = it_fieldcat
*         IT_EXCLUDING             =
*         IT_SPECIAL_GROUPS        =
*         IT_SORT                  =
*         IT_FILTER                =
*         IS_SEL_HIDE              =
*         I_DEFAULT                = 'X'
*         I_SAVE                   = ' '
*         IS_VARIANT               =
*         IT_EVENTS                =
*         IT_EVENT_EXIT            =
*         IS_PRINT                 =
*         IS_REPREP_ID             =
*         I_SCREEN_START_COLUMN    = 0
*         I_SCREEN_START_LINE      = 0
*         I_SCREEN_END_COLUMN      = 0
*         I_SCREEN_END_LINE        = 0
*         I_HTML_HEIGHT_TOP        = 0
*         I_HTML_HEIGHT_END        = 0
*         IT_ALV_GRAPHICS          =
*         IT_HYPERLINK             =
*         IT_ADD_FIELDCAT          =
*         IT_EXCEPT_QINFO          =
*         IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*         E_EXIT_CAUSED_BY_CALLER  =
*         ES_EXIT_CAUSED_BY_USER   =
        tables
          t_outtab                 = it_final
*   EXCEPTIONS
*         PROGRAM_ERROR            = 1
*         OTHERS                   = 2
        .
      if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      endif.


    when '&DATA_SAVE'.

      loop at it_final into wa_final where lrno is initial or lrdate is initial
                                     or cases is initial.
        message 'Enter Lr.No Lr.Date and Cases' type 'E'.
      endloop.

      loop at it_final into wa_final.

        clear wa_bkpf.

        write wa_final-lrdate to wa_dat dd/mm/yyyy.

        read table it_bkpf into wa_bkpf with key awkey = wa_final-vbeln_dummy.
        if sy-subrc = 0.

          perform bdc_dynpro      using 'SAPMF05L' '0100'.
          perform bdc_field       using 'BDC_CURSOR'
                                        'RF05L-GJAHR'.
          perform bdc_field       using 'BDC_OKCODE'
                                        '/00'.
          perform bdc_field       using 'RF05L-BELNR'
                                        wa_bkpf-belnr.
          perform bdc_field       using 'RF05L-BUKRS'
                                        wa_bkpf-bukrs.
          perform bdc_field       using 'RF05L-GJAHR'
                                        wa_bkpf-gjahr.
          perform bdc_dynpro      using 'SAPMF05L' '0700'.
          perform bdc_field       using 'BDC_CURSOR'
                                        'RF05L-ANZDT(01)'.
          perform bdc_field       using 'BDC_OKCODE'
                                        '=PK'.
          perform bdc_dynpro      using 'SAPMF05L' '0301'.
          perform bdc_field       using 'BDC_CURSOR'
                                        'BSEG-ZFBDT'.
          perform bdc_field       using 'BDC_OKCODE'
                                        'RW'.
          perform bdc_field       using 'BSEG-ZFBDT'
                                         wa_dat.
          perform bdc_field       using 'BSEG-ZUONR'
                                         wa_final-vbeln.
          perform bdc_dynpro      using 'SAPMF05L' '0700'.
          perform bdc_field       using 'BDC_CURSOR'
                                        'BKPF-BELNR'.
          perform bdc_field       using 'BDC_OKCODE'
                                        '=RW'.
          perform bdc_dynpro      using 'SAPLSPO1' '0100'.
          perform bdc_field       using 'BDC_OKCODE'
                                        '=YES'.
          call transaction 'FB02' using bdcdata mode 'N' messages into it_mess.
*   IF SY-SUBRC <> 0.
*
*     ENDIF.
          refresh bdcdata[].
          clear bdcdata.
          clear wa_dat.
          clear wa_final.
        else.
          message 'BLine date not getting updated' type 'E'.

        endif.

      endloop.



      loop at it_final into wa_final.

        clear wa_vbrp.

        read table it_vbrp into wa_vbrp with key vbeln = wa_final-vbeln.

        if sy-subrc = 0.

          perform bdc_dynpro      using 'SAPMV50A' '4004'.
          perform bdc_field       using 'BDC_CURSOR'
                                        'LIKP-VBELN'.
          perform bdc_field       using 'BDC_OKCODE'
                                        '/00'.
          perform bdc_field       using 'LIKP-VBELN'
                                        wa_vbrp-vgbel.
          perform bdc_dynpro      using 'SAPMV50A' '1000'.
          perform bdc_field       using 'BDC_OKCODE'
                                        'HDET_T'.
          perform bdc_field       using 'BDC_CURSOR'
                                        'LIPS-MATNR(02)'.
          perform bdc_dynpro      using 'SAPMV50A' '2000'.
          perform bdc_field       using 'BDC_OKCODE'
                                        '=T\04'.
          perform bdc_field       using 'BDC_CURSOR'
                                        'KUWEV-KUNNR'.

****blocked by anbu on 19.12.2011 starts
*perform bdc_dynpro      using 'SAPMV50A' '2000'.
*perform bdc_field       using 'BDC_OKCODE'
*                              '=T\09'.
*perform bdc_field       using 'BDC_CURSOR'
*                              'LIKP-BOLNR'.
*perform bdc_field       using 'LIKP-BOLNR'
*                              wa_final-lrno.
****blocked by anbu on 19.12.2011 ends

****added by anbu on 19.12.2011 starts
*perform bdc_dynpro      using 'SAPMV50A' '2000'.
*perform bdc_field       using 'BDC_OKCODE'
*                              '/00'.
*perform bdc_field       using 'BDC_CURSOR'
*                              'LIKP-BOLNR'.
*perform bdc_field       using 'LIKP-BOLNR'
*                              wa_final-lrno.

          perform bdc_dynpro      using 'SAPMV50A' '2000'.
          perform bdc_field       using 'BDC_OKCODE'
                                        '=SICH_T'.
          perform bdc_field       using 'BDC_CURSOR'
                                        'LIKP-BOLNR'.
          perform bdc_field       using 'LIKP-BOLNR'
                                        wa_final-lrno..

****added by anbu on 19.12.2011 ends






          perform bdc_dynpro      using 'SAPMV50A' '2000'.
          perform bdc_field       using 'BDC_OKCODE'
                                        '=%_GC 121 22'.
          perform bdc_field       using 'LV70T-SPRAS'
                                        'EN'.
          perform bdc_dynpro      using 'SAPMV50A' '2000'.
          perform bdc_field       using 'BDC_OKCODE'
                                        '=SICH_T'.
          call transaction 'VL02N' using bdcdata mode 'N'.
          COMMIT WORK.
          refresh bdcdata[].
          clear bdcdata.
          clear wa_final.
        else.
          message 'LRno not getting updated' type 'E'.

        endif.
      endloop.

      clear wa_vbrp.

      loop at it_final into wa_final.

        clear: wa_vbrp,wa_tdhead,wa_tline2.
        refresh it_tline2[].

        read table it_vbrp into wa_vbrp with key vbeln = wa_final-vbeln.
        if sy-subrc = 0.
          move 'VBBK' to wa_tdhead-tdobject.
          move wa_vbrp-vgbel to wa_tdhead-tdname.
          move '0002' to wa_tdhead-tdid.
          move 'EN' to wa_tdhead-tdspras.
          move '100' to wa_tdhead-tdlinesize.

*    CONCATENATE '00' WA_TDHEAD-TDNAME INTO WA_TDHEAD-TDNAME.

          move '*' to wa_tline2-tdformat.
          move wa_final-cases to wa_tline2-tdline.
          append wa_tline2 to it_tline2.



          call function 'SAVE_TEXT'
            exporting
*             CLIENT          = SY-MANDT
              header          = wa_tdhead
              insert          = ' '
              savemode_direct = 'X'
              owner_specified = ' '
              local_cat       = ' '
*   IMPORTING
*             FUNCTION        =
*             NEWHEADER       =
            tables
              lines           = it_tline2
            exceptions
              id              = 1
              language        = 2
              name            = 3
              object          = 4
              others          = 5.
          if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
          endif.

        endif.
      endloop.

      loop at it_final into wa_final.
        wa_zupload-mandt = wa_final-mandt.
        wa_zupload-vbeln = wa_final-vbeln.
        wa_zupload-fkdat = wa_final-fkdat.
        wa_zupload-bolnr = wa_final-lrno.
        wa_zupload-zfbdt = wa_final-lrdate.
        wa_zupload-cases = wa_final-cases.
        wa_zupload-user_name = sy-uname.
        wa_zupload-uzeit = sy-uzeit.
        wa_zupload-datum = sy-datum.

        modify zupload from wa_zupload.
        clear wa_zupload.



      endloop.
  endcase.
endform.
form bdc_dynpro using program dynpro.
  clear bdcdata.
  bdcdata-program  = program.
  bdcdata-dynpro   = dynpro.
  bdcdata-dynbegin = 'X'.
  append bdcdata.
endform.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
form bdc_field using fnam fval.
*  IF FVAL <> NODATA.
  clear bdcdata.
  bdcdata-fnam = fnam.
  bdcdata-fval = fval.
  append bdcdata.
*  ENDIF.
endform.
*&---------------------------------------------------------------------*
*&      Form  GET_FISCAL_YEAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form get_fiscal_year .

  l_fyv = 'V3'.

  call function 'GM_GET_FISCAL_YEAR'
    exporting
      i_date = sy-datum
      i_fyv  = l_fyv
    importing
      e_fy   = l_year
* EXCEPTIONS
*     FISCAL_YEAR_DOES_NOT_EXIST       = 1
*     NOT_DEFINED_FOR_DATE             = 2
*     OTHERS = 3
    .
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

endform.                    " GET_FISCAL_YEAR
