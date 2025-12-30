*&---------------------------------------------------------------------*
*&  Include           ZFS_UPLOAD_TOP
*&---------------------------------------------------------------------*

TYPE-POOLS : truxs.

TYPES: BEGIN OF ty_final,

         bldat     TYPE bkpf-bldat,   "doc date.
         blart     TYPE bkpf-blart,    "Document Type
         bukrs     TYPE bkpf-bukrs,   "company code
         budat     TYPE bkpf-budat,    "postind date.
         xblnr     TYPE bkpf-xblnr,      "reference document number
         bktxt     TYPE bkpf-bktxt,       "document header text
         newbs     TYPE rf05a-newbs,     "Posting Key for the Next Line Item  "--- bschl
         newko     TYPE rf05a-newko,     "Account "g/l code
         wrbtr     TYPE c LENGTH 13,    "Amount in Document Currency "WRBTR TYPE BSEG-WRBTR

         bupla     TYPE bseg-bupla,    "business plac,
         kostl     TYPE cobl-kostl ,      "cost center
         gsber     TYPE cobl-gsber, "business area,
         valut     TYPE bseg-valut ,   "value date.
         zuonr     TYPE bseg-zuonr,  "assignment no,
         sgtxt     TYPE bseg-sgtxt,   "item text,

         newbs_nxt TYPE rf05a-newbs,     "Posting Key for the Next Line Item  "--- bschl
         newko_nxt TYPE rf05a-newko,     "Account "g/l code
         wrbtr_nxt TYPE c LENGTH 13,    "Amount in Document Currency "WRBTR TYPE BSEG-WRBTR
         sgtxt_nxt TYPE bseg-sgtxt,   "item text,

         line_no   TYPE i,
         status    TYPE c LENGTH 10,
         message   TYPE c LENGTH 100,

       END OF ty_final.

TYPES:BEGIN OF ty_data,
        col1  TYPE string,
        col2  TYPE string,
        col3  TYPE string,
        col4  TYPE string,
        col5  TYPE string,
        col6  TYPE string,
        col7  TYPE string,
        col8  TYPE string,
        col9  TYPE string,
        col10 TYPE string,
        col11 TYPE string,
        col12 TYPE string,
        col13 TYPE string,
        col14 TYPE string,
        col15 TYPE string,
      END OF ty_data.

DATA:gt_data TYPE STANDARD TABLE OF ty_data,
     gw_data TYPE                   ty_data.

DATA:gt_final  TYPE TABLE OF ty_final,
     gw_final  TYPE ty_final,

     gt_header TYPE TABLE OF ty_final,
     gw_header TYPE ty_final,

     gt_item   TYPE TABLE OF ty_final,
     gw_item   TYPE           ty_final.

DATA: gt_bdcdata TYPE TABLE OF bdcdata,
      gw_bdcdata TYPE bdcdata.

DATA:i_tab_raw_data TYPE  truxs_t_text_data.

DATA:gt_file_exc TYPE TABLE OF alsmex_tabline,
     gw_file_exc TYPE alsmex_tabline.

DATA: gt_bdcmsgcoll TYPE TABLE OF bdcmsgcoll,
      gw_bdcmsgcoll TYPE bdcmsgcoll.

DATA: gt_fcat TYPE slis_t_fieldcat_alv,
      gw_fcat TYPE slis_fieldcat_alv.


*DATA: doc_header LIKE bapiache09,
*      criteria   LIKE bapiackec9 OCCURS 0 WITH HEADER LINE,
*      doc_item   LIKE bapiacgl09 OCCURS 0 WITH HEADER LINE,
*      doc_ar     LIKE bapiacar09 OCCURS 0 WITH HEADER LINE,
*      doc_values LIKE bapiaccr09 OCCURS 0 WITH HEADER LINE,
*      return     LIKE bapiret2 OCCURS 0 WITH HEADER LINE,
*      extension1 LIKE bapiacextc OCCURS 0 WITH HEADER LINE,
*      obj_type   LIKE bapiache08-obj_type,
*      obj_key    LIKE bapiache02-obj_key,
*      obj_sys    LIKE bapiache02-obj_sys,
*      docnum     LIKE bkpf-belnr.
