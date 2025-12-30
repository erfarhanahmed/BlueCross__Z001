
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Batch Expiry (MCHA)'

define view entity ZI_ProductBatch 
    as select from mcha as b
{
  key b.matnr        as Material,
  key b.werks        as Plant,
  key b.charg        as Batch,
      b.vfdat        as BatchExpirationDate
}
