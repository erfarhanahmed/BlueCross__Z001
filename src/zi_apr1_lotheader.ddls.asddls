
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lot header'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZI_APR1_LotHeader 
    as select from I_InspectionLot as Lot
    left outer join jest as Del
      on  Del.objnr = Lot.StatusObject
      and Del.stat  = 'I0224'         // deletion status
{
  key Lot.InspectionLot         as Prueflos,
      Lot.Material              as Matnr,
      Lot.Batch                 as Charg,
      Lot.Plant                 as Werk,
      Lot.InspectionLotType        as Art,
      Lot.InspectionLotCreatedOn          as Enstehdat
}
where Del.objnr is null
