*&---------------------------------------------------------------------*
*& Report  ZEXPIRY_LABESL1
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report zexpiry_labesl7.

tables : mara,
         qals,
*         MSEG,
         makt,
         qaqee,
         mkpf,
         jest,
         lfa1,
         t157e.

data: it_qals  type table of qals,
      wa_qals  type qals,
      it_qals1 type table of qals,
      wa_qals1 type qals.
data: it_mseg type table of mseg,
      wa_mseg type mseg.

data : itab  type   table of  zexp_lbl,
       wa    type      zexp_lbl,
       fname type     rs38l_fnam.
data : control  type ssfctrlop.
data : w_ssfcompop type ssfcompop.
data: n  type p decimals 2,
      n1 type p decimals 2.
data: qty type mseg-zeile.
data prueflos like qals-prueflos.
DATA: MATTXT(20) TYPE C.
data: maktx1     type makt-maktx,
      maktx2     type makt-maktx,
      maktx(100) type c,
      normt      type mara-normt,
      budat      type mkpf-budat,
      name1      type lfa1-name1,
      sgtxt      type mseg-sgtxt,
      grtxt      type t157e-grtxt,
      format(20) type c.
data: matnr like mseg-matnr,
      charg like mseg-charg.

selection-screen : begin of block b1 with frame title t1.
parameters : doc   like mseg-mblnr.
*             MATNR LIKE MSEG-MATNR,
*             CHARG LIKE MSEG-CHARG.
parameters : lineno like mseg-line_id.

*PARAMETERS : PRUEFLOS LIKE QALS-PRUEFLOS.
parameters lbl type mseg-zeile.
selection-screen : end of block b1 .

start-of-selection.

  select * from mseg into table it_mseg where mblnr eq doc and line_id eq lineno and bwart in ( '344','350' ) and xauto eq space.
  read table it_mseg into wa_mseg with key mblnr = doc line_id = lineno.
  if sy-subrc eq 0.
    matnr = wa_mseg-matnr.
    charg = wa_mseg-charg.
  endif.


  select * from qals into table it_qals1 where art eq '01' and matnr eq matnr and charg eq charg and lifnr ne space.
  if sy-subrc ne 0.
    select * from qals into table it_qals1 where art eq '01' and charg eq charg and lifnr ne space.
  endif.


  loop at it_qals1 into wa_qals1.
    select single * from jest where objnr eq wa_qals1-objnr and stat eq 'I0224'.
    if sy-subrc eq 0.
      delete it_qals1 where prueflos eq wa_qals1-prueflos.
    endif.
  endloop.

  select * from qals into table it_qals where matnr eq matnr and charg eq charg and stat34 eq 'X' and stat35 eq 'X'.
  if sy-subrc ne 0.
    message 'NO DATA FOUND' type 'E'.
  endif.
  sort it_qals descending by enstehdat.
  loop at it_qals into wa_qals.
    select single * from jest where objnr eq wa_qals-objnr and stat eq 'I0224'.
    if sy-subrc eq 0.
      delete it_qals where prueflos eq wa_qals-prueflos.
    endif.
  endloop.

  clear : sgtxt,grtxt.
  read table it_qals into wa_qals with key matnr = matnr charg = charg.
  if sy-subrc eq 0.
    CLEAR : MATTXT.
    select single * from mara where matnr eq wa_qals-matnr and mtart eq 'ZROH'.
    if sy-subrc eq 0.
      mattxt = 'RAW MATERIAL'.
    else.
      select single * from mara where matnr eq wa_qals-matnr and mtart eq 'ZVRP'.
      if sy-subrc eq 0.
        mattxt = 'PACKAGING MATERIAL'.
      endif.
    endif.


    prueflos = wa_qals-prueflos.
    read table it_mseg into wa_mseg with key mblnr = doc line_id = lineno.
    if sy-subrc eq 0.
*    SELECT SINGLE * FROM MSEG WHERE MBLNR EQ DOC AND BWART EQ '344' AND XAUTO EQ SPACE AND MATNR EQ WA_QALS-MATNR AND CHARG EQ WA_QALS-CHARG.
*    IF SY-SUBRC EQ 0.
      sgtxt = wa_mseg-sgtxt.
      select single * from t157e where spras eq 'EN' and bwart eq '344' and grund eq wa_mseg-grund.
      if sy-subrc eq 0.
        grtxt = t157e-grtxt.
      endif.
      read table it_qals1 into wa_qals1 with key art = '01' matnr = wa_qals-matnr charg = wa_qals-charg.
      if sy-subrc eq 0.
        select single * from lfa1 where lifnr eq wa_qals1-lifnr.
        if sy-subrc eq 0.
          name1 = lfa1-name1.
        endif.
      endif.

      clear : maktx1,maktx1,maktx,normt,budat.
      select single * from makt where matnr eq wa_qals-matnr and spras eq 'EN'.
      if sy-subrc eq 0.
        maktx1 = makt-maktx.
      endif.
      select single * from makt where matnr eq wa_qals-matnr and spras eq 'Z1'.
      if sy-subrc eq 0.
        maktx2 = makt-maktx.
      endif.
      concatenate maktx1 maktx2 into maktx separated by space.
      select single * from mara where matnr eq wa_qals-matnr.
      if sy-subrc eq 0.
        normt = mara-normt.
      endif.
      select single * from mkpf where mblnr eq wa_mseg-mblnr and mjahr eq wa_mseg-mjahr.
      if sy-subrc eq 0.
        budat = mkpf-budat.
      endif.

*  SELECT SINGLE * FROM QALS WHERE PRUEFLOS EQ PRUEFLOS..
*  IF SY-SUBRC EQ 0.
      call function 'SSF_FUNCTION_MODULE_NAME'
        exporting
*         FORMNAME           = 'ZREJ_LBL'
          formname           = 'ZREJ_LBL1'
*         VARIANT            = ‘ ‘
*         DIRECT_CALL        = ‘ ‘
        importing
          fm_name            = fname
        exceptions
          no_form            = 1
          no_function_module = 2
          others             = 3.
      control-no_open   = 'X'.
      control-no_close  = 'X'.

      call function 'SSF_OPEN'
        exporting
          control_parameters = control.

      n = lbl div 10.
      n1 =  lbl mod 10 .
      if n1 gt 0.
        n = n + 1.
      endif.
      qty = 0.
      do  n times.
        format = 'SOP/QC/008-F3'.

        call function fname
          exporting
            control_parameters = control
            user_settings      = 'X'
            output_options     = w_ssfcompop
*           ARCHIVE_INDEX      =
*           ARCHIVE_INDEX_TAB  =
*           ARCHIVE_PARAMETERS =
*           CONTROL_PARAMETERS =
*           MAIL_APPL_OBJ      =
*           MAIL_RECIPIENT     =
*           MAIL_SENDER        =
*           OUTPUT_OPTIONS     =
*           USER_SETTINGS      = ‘X’
* IMPORTING
*           DOCUMENT_OUTPUT_INFO       =
*           JOB_OUTPUT_INFO    =
*           JOB_OUTPUT_OPTIONS =
            qndat              = budat
            budat              = budat
            prueflos           = wa_qals-prueflos
            p_mittel           = qty
            matnr              = wa_qals-matnr
            charg              = wa_qals-charg
            maktx              = maktx
            normt              = normt
            menge              = wa_mseg-menge
            meins              = wa_mseg-meins
            vdatum             = qals-budat
            lbl                = lbl
            name1              = name1
            sgtxt              = sgtxt
            grtxt              = grtxt
            format             = format
            MATTXT = MATTXT
*    TABLES
*           ITAB               = ITAB
*    EXCEPTIONS
*           FORMATTING_ERROR   = 1
*           INTERNAL_ERROR     = 2
*           SEND_ERROR         = 3
*           USER_CANCELED      = 4
*           OTHERS             = 5
          .
*      enddo .

        qty = qty + 10.

      enddo.

      call function 'SSF_CLOSE'.
    endif.
  endif.
