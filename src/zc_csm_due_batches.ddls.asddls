@EndUserText.label: 'CSM Due-for-Destruction Batches'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
//@OData.publish: true   -- enable if you want a Fiori List Report

define view entity ZC_CSM_DUE_BATCHES
  with parameters
    p_werks      : werks_d,
    p_date_from  : dats,
    p_date_to    : dats
as select from ZI_CSM_DUE_BATCHES(
                    p_werks     : $parameters.p_werks,
                    p_date_from : $parameters.p_date_from,
                    p_date_to   : $parameters.p_date_to )
{
  Material,
  @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Material', element: 'Material' } }]
  MaterialText,
  Plant,
  PlantName,
  Sloc,
  Batch,
  QtyCsm,
  BaseUom,
  MfgDate,
  ExpiryDate,
  DueDate,
  IsExpired,
  PriceCtrl,
  @Semantics.amount.currencyCode: 'Currency'
  Rate,
  @Semantics.amount.currencyCode: 'Currency'
  Value,
  Currency,
  MatType
}
