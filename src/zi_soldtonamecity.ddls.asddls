@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sold-to: name and place (KNA1)'

define view entity ZI_SoldToNameCity 
    as select from kna1
{
  key kna1.kunnr       as Customer,
      kna1.name1       as Name1,
      kna1.ort01       as Ort01
}
