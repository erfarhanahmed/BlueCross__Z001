@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Control sample qty (S035 @ CSM)'

define view entity ZI_S035_ControlSample 
    as select from s035 as S
{
  key S.matnr  as Material,
  key S.charg  as Batch,
  key S.werks  as Plant,
      S.basme  as UnitofMeasure,
    @Semantics.quantity.unitOfMeasure: 'UnitofMeasure'  
      cast( S.cmbwbest as abap.quan( 13, 3 ) ) as ControlSampleQty
}
where S.lgort = 'CSM'
