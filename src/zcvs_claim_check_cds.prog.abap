*&---------------------------------------------------------------------*
*& Report ZCVS_CLAIM_CHECK_CDS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zcvs_claim_check_cds.

DATA: gv_kunnr TYPE kna1-kunnr,
      gv_werks TYPE t001w-werks,
      gv_auart TYPE tvak-auart.
"— Selection screen (replicates key filters from ECC report)
PARAMETERS: p_max TYPE i DEFAULT 1000.
SELECT-OPTIONS: s_audat FOR sy-datum NO-EXTENSION, " Sales order date
                s_kunnr FOR gv_kunnr,         " Sold-to
                s_werks FOR gv_werks,           " Plant
                s_auart FOR gv_auart.            " Order type

"— Data fetch from CDS consumption view
TYPES: BEGIN OF ty_item,
         salesorder          TYPE I_SalesOrderItem-SalesOrder,
         salesorderitem      TYPE I_SalesOrderItem-SalesOrderItem,
         salesordertype      TYPE I_SalesOrder-SalesOrderType,
         salesorderdate      TYPE I_SalesOrder-SalesOrderDate,
         soldtoparty         TYPE I_SalesOrder-SoldToParty,
         customername        TYPE I_Customer-CustomerName,
         material            TYPE I_SalesOrderItem-Material,
         productname         TYPE I_ProductText-ProductName,
         orderquantity       TYPE I_SalesOrderItem-OrderQuantity,
         orderquantityunit   TYPE I_SalesOrderItem-OrderQuantityUnit,
         targetquantity      TYPE I_SalesOrderItem-TargetQuantity,
         targetquantityunit  TYPE I_SalesOrderItem-TargetQuantityUnit,
         transactioncurrency TYPE I_SalesOrderItem-TransactionCurrency,
         plant               TYPE I_SalesOrderItem-Plant,
         batch               TYPE I_SalesOrderItem-Batch,
         batchexpirationdate TYPE datum,
         materialgroup5      TYPE mvke-mvgr5,
         materialgroup5text  TYPE tvm5t-bezei,
         deliverystatus      TYPE I_SalesOrderItem-DeliveryStatus,
*         billingstatus       TYPE I_SalesOrderItem-BillingStatus,
*         overallitemstatus   TYPE I_SalesOrderItem-OverallItemStatus,
         itemconditionamount TYPE p LENGTH 16 DECIMALS 2,
       END OF ty_item.

DATA lt_items TYPE STANDARD TABLE OF ty_item.


START-OF-SELECTION.

  SELECT
      salesorder,
      salesorderitem,
      salesordertype,
      salesorderdate,
      soldtoparty,
      customername,
      material,
      productname,
      orderquantity,
      orderquantityunit,
      targetquantity,
      targetquantityunit,
      transactioncurrency,
      plant,
      batch,
      batchexpirationdate,
      materialgroup5,
      materialgroup5text,
      deliverystatus,
*      billingstatus,
*      overallitemstatus,
      itemconditionamount
    FROM ZC_ClaimCheckItem

    WHERE salesorderdate     IN @s_audat
      AND soldtoparty        IN @s_kunnr
      AND plant              IN @s_werks
      AND salesordertype     IN @s_auart

    INTO TABLE @lt_items
    UP TO @p_max ROWS.

  IF lt_items IS INITIAL.
    MESSAGE 'No items found for the given selection' TYPE 'S' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  "— Simple ALV
  TRY.
      cl_salv_table=>factory( IMPORTING r_salv_table = DATA(lo_alv)
                               CHANGING t_table = lt_items  ).
      lo_alv->display( ).
    CATCH : cx_salv_existing, cx_salv_msg, cx_salv_Data_error,
           cx_salv_not_found INTO DATA(ls_msg) .
  ENDTRY.
