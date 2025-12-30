@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Pricing Elements (Item) – filtered to project KSCHL set'

define view entity ZI_SlsOrdItemPrice 
as select from prcd_elements as pe
{
  key pe.knumv                       as PricingDocument,
  key pe.kposn                       as PricingItem,
      pe.kschl                       as ConditionType,
      pe.kawrt                       as ConditionBaseValue,
      pe.kbetr                       as ConditionRateValue,
      @Semantics.amount.currencyCode: 'ConditionCurrency'
      pe.kwert                       as ConditionAmount,
/*      @Semantics.currencyCode: true */
      pe.waers                       as ConditionCurrency,
      pe.kpein                       as ConditionPricingUnit,
      pe.kmein                       as ConditionUnit
}
