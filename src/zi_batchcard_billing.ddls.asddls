@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Batch Card – Billing (ECC itab1 shape)'

define view entity ZI_BatchCard_Billing 
    as select from I_BillingDocumentItem as Item
    inner join I_BillingDocument       as Head  on Item.BillingDocument = Head.BillingDocument
    left outer join I_Plant            as Plant on Item.Plant           = Plant.Plant
    left outer join ZI_SoldToNameCity  as SoldTo on SoldTo.Customer     = Head.SoldToParty
{
  /* ECC-like column names */
  @EndUserText.label: 'INVOICE NO'
  key Item.BillingDocument                 as VBELN,

  Item.Material                            as MATNR,
  Item.Batch                               as CHARG,

  @EndUserText.label: 'INVOICE DATE'
  Head.BillingDocumentDate                 as FKDAT,

  @EndUserText.label: 'SALE FROM PLANT'
  Item.Plant                               as WERKS,

  @EndUserText.label: 'SALE TO CUSTOMER'
  Head.SoldToParty                         as KUNAG,

  @EndUserText.label: 'CUSTOMER NAME'
  SoldTo.Name1                             as NAME1,

  @EndUserText.label: 'PLACE'
  SoldTo.Ort01                             as ORT01,
  Item.BaseUnit                            as UnitofMeasure,
  
   @Semantics.quantity.unitOfMeasure: 'UnitofMeasure'
  /* split columns by item category exactly like ECC */
  cast( case when Item.SalesDocumentItemCategory = 'ZAN'  then Item.BillingQuantity else 0 end
        as abap.quan( 13, 3 ) )            as QTY_C,

//  @Semantics.amount.currencyCode: 'TransactionCurrency'
   case when Item.SalesDocumentItemCategory = 'ZAN'  then cast(Item.NetAmount as abap.dec(15,2)) else 0 end
                    as VAL_C,
  Head.TransactionCurrency,
  @Semantics.quantity.unitOfMeasure: 'UnitofMeasure'
  cast( case when Item.SalesDocumentItemCategory = 'ZANN' then Item.BillingQuantity else 0 end
        as abap.quan( 13, 3 ) )            as QTY_F
}
where Item.Batch is not null
