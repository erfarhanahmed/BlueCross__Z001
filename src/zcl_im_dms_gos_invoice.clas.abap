class ZCL_IM_DMS_GOS_INVOICE definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_INVOICE_UPDATE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_DMS_GOS_INVOICE IMPLEMENTATION.


  method IF_EX_INVOICE_UPDATE~CHANGE_AT_SAVE.
  endmethod.


  METHOD if_ex_invoice_update~change_before_update.
*----------------------------------------------------------------------*
* Title  MIRO DMS File Name Update
*----------------------------------------------------------------------*
* Project      : Bluecross DMS
* Request	     : BCDK925296
* Author       : Karthik
* Requested by : Vaibhav
* Date         : 28.11.2019
*----------------------------------------------------------------------*
* Short description of the program:
*    - To update the attached file name based on Invoice Number and
*      Year.
*----------------------------------------------------------------------*

      IF sy-tcode = 'MIRO' AND sy-ucomm = 'BU'. " T-Code and User Action Check

    DATA: t_zdms_gos TYPE STANDARD TABLE OF zdms_gos.
    FIELD-SYMBOLS:<fs> LIKE LINE OF t_zdms_gos.
    DATA: lv_key   TYPE string.

    CONCATENATE s_rbkp_new-belnr s_rbkp_new-gjahr INTO lv_key.
    CONDENSE lv_key.

* To check file availability

    SELECT *
      FROM zdms_gos
      INTO TABLE t_zdms_gos
     WHERE doc_key EQ 'MIRODMS'
       AND zdate   EQ sy-datum.
    IF sy-subrc EQ 0.
      DATA(lt_zdms_gos) = t_zdms_gos.
      LOOP AT t_zdms_gos ASSIGNING <fs>.
        <fs>-doc_key = lv_key.
      ENDLOOP.
      DELETE zdms_gos FROM TABLE lt_zdms_gos.
      IF sy-subrc EQ 0.
        COMMIT WORK AND WAIT.
      ENDIF.
      MODIFY zdms_gos FROM TABLE t_zdms_gos. " To update
      IF sy-subrc EQ 0.
        COMMIT WORK AND WAIT.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMETHOD.


  method IF_EX_INVOICE_UPDATE~CHANGE_IN_UPDATE.
  endmethod.
ENDCLASS.
