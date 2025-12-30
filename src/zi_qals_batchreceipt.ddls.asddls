@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BSR receipt by batch (QALS)'

define view entity ZI_QALS_BatchReceipt 
    as select from qals as Q
{
  key Q.matnr     as Material,
  key Q.charg     as Batch,
  key Q.werk      as Plant,
      Q.lagortchrg as StorageLocation,
      Q.bwart     as MovementType,
      Q.mengeneinh as UnitofMeasure,
      @Semantics.quantity.unitOfMeasure: 'UnitofMeasure'
      cast(
        case when Q.bwart = '350' then - Q.lmenge01 else Q.lmenge01 end
        as abap.quan( 13, 3 )
      )           as SignedReceiptQty
}
where ( Q.lagortchrg = 'FG01' 
        or Q.lagortchrg = 'FG02' 
        or Q.lagortchrg = 'FG03' 
        or Q.lagortchrg = 'FG04' )
  and ( Q.bwart = '349'
       or Q.bwart = '350' )
