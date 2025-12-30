@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BSR totals (receipt - control sample)'
@AbapCatalog.sqlViewName:'ZIBSRTOT'

define view  ZI_BSR_Total 
    as select from ZI_QALS_BatchReceipt as Q
    left outer join ZI_S035_ControlSample as S
      on  S.Material = Q.Material
      and S.Batch    = Q.Batch
      and S.Plant    = Q.Plant
{
  Q.Material,
  Q.Batch,
  sum( Q.SignedReceiptQty )                  as ReceiptQty,
  max( S.ControlSampleQty )  as ControlSampleQty,
  
  sum( Q.SignedReceiptQty ) -  max( S.ControlSampleQty )
                                             as NetQtyAtBSR
}
group by Q.Material, Q.Batch
