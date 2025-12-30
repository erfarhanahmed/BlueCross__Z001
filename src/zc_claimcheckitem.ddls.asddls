@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Claim Check – SO Items with header, texts, price& batch'

define view entity ZC_ClaimCheckItem 
    as select from I_SalesOrderItem as si
    inner join I_SalesOrder     as so on so.SalesOrder = si.SalesOrder
    left  outer join I_Customer as cu on cu.Customer   = so.SoldToParty
    left  outer join I_ProductText as pt
         on  pt.Product  = si.Material
         and pt.Language = $session.system_language
    left  outer join ZI_SalesOrderItemKnumv as sk
         on  sk.SalesOrder     = si.SalesOrder
         and sk.SalesOrderItem = si.SalesOrderItem
    left  outer join ZI_SlsOrdItemPrice as pe
         on  pe.PricingDocument = sk.PricingDocument
         and pe.PricingItem     = si.SalesOrderItem
    left  outer join ZI_ProductBatch as bt
         on  bt.Material = si.Material
         and bt.Plant    = si.Plant
         and bt.Batch    = si.Batch
    left  outer join ZI_ProductSalesAttr as psa
         on  psa.Material           = si.Material
         and psa.SalesOrganization  = so.SalesOrganization
         and psa.DistributionChannel= so.DistributionChannel
// Associations (none; using explicit joins)
 
// Projection
{
  key si.SalesOrder,
  key si.SalesOrderItem,
 
      so.SalesOrderType,
      so.SalesOrderDate,
      so.SoldToParty,
      cu.CustomerName,
 
      si.Material,
      pt.ProductName,
 
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      si.OrderQuantity,
      si.OrderQuantityUnit,
 
      @Semantics.quantity.unitOfMeasure: 'TargetQuantityUnit'
      si.TargetQuantity,
      si.TargetQuantityUnit,
 
      si.TransactionCurrency,
 
      si.Plant,
      si.Batch,
      bt.BatchExpirationDate,
 
      psa.MaterialGroup5,
      psa.MaterialGroup5Text,
 
      si.DeliveryStatus,
//      si.BillingStatus,
//      si.OverallItemStatus,
 
      // aggregated pricing amount for selected KSCHL set
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      sum( pe.ConditionAmount ) as ItemConditionAmount
}
// WHERE (none – filters pushed from consumer)
// GROUP BY for all non-aggregated columns
group by
      si.SalesOrder,
      si.SalesOrderItem,
      so.SalesOrderType,
      so.SalesOrderDate,
      so.SoldToParty,
      cu.CustomerName,
      si.Material,
      pt.ProductName,
      si.OrderQuantity,
      si.OrderQuantityUnit,
      si.TargetQuantity,
      si.TargetQuantityUnit,
      si.TransactionCurrency,
      si.Plant,
      si.Batch,
      bt.BatchExpirationDate,
      psa.MaterialGroup5,
      psa.MaterialGroup5Text,
      si.DeliveryStatus
//      si.BillingStatus,
//      si.OverallItemStatus
