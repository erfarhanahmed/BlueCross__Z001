@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CSM Due-for-Destruction Batches (Interface)'
/*@AbapCatalog.compiler.compareFilter: true
@ClientHandling.algorithm: #AUTOMATED  */
@ObjectModel.usageType.serviceQuality: #C
@ObjectModel.usageType.sizeCategory: #M
@ObjectModel.usageType.dataClass: #MASTER

define view entity ZI_CSM_DUE_BATCHES
  with parameters
    p_werks      : werks_d,
    p_date_from  : dats,
    p_date_to    : dats
as select from mchb as b
  inner join mcha as a
    on  a.matnr = b.matnr
    and a.charg = b.charg
    and a.werks = b.werks
  left outer join mara as m
    on  m.matnr = b.matnr
  left outer join makt as t
    on  t.matnr = b.matnr
    and t.spras = $session.system_language
  left outer join mbew as v
    on  v.matnr = b.matnr
    and v.bwkey = b.werks
  left outer join t001w as w
    on  w.werks = b.werks
  left outer join t001k as k on k.bwkey = w.bwkey  
  left outer join t001 as c
    on  c.bukrs = k.bukrs

{
  key b.matnr                               as Material,
  key b.werks                               as Plant,
  key b.lgort                               as Sloc,
  key b.charg                               as Batch,

  @Semantics.quantity.unitOfMeasure: 'BaseUom'
  b.cspem                                   as QtyCsm,

  m.meins                                   as BaseUom,
  a.hsdat                                   as MfgDate,
  a.vfdat                                   as ExpiryDate,
 /* add_months( a.vfdat, 12 )                 as DueDate, */
    dats_add_months(a.vfdat, 12, 'FAIL')     as DueDate,    
  /* Flag rows already past due */
  cast( case when dats_add_months( a.vfdat, 12,'FAIL' ) < $session.system_date then 'X' else '' end as abap_boolean ) as IsExpired,

  @Semantics.text: true
  t.maktx                                   as MaterialText,

  v.vprsv                                   as PriceCtrl,
  @Semantics.amount.currencyCode: 'Currency'  
  v.stprs                                   as StdPrice,
  @Semantics.amount.currencyCode: 'Currency'
  v.verpr                                   as MovAvgPrice,

  /* Rate = STPRS when S, else VERPR */
  cast( case when v.vprsv = 'S' then v.stprs else v.verpr end as abap.dec(15,2) ) as Rate,

  c.waers                                   as Currency,

  /* Value = Rate * QtyCsm */
  @Semantics.amount.currencyCode: 'Currency'
 cast( case when v.vprsv = 'S' then v.stprs else v.verpr end as abap.dec(15,2) ) * cast(b.cspem as abap.dec(15,2)) as Value,

 /* @Semantics.plant.name: true */
  w.name1                                   as PlantName,

  m.mtart                                   as MatType
}
where
      b.lgort   = 'CSM'
  and b.cspem   > 0
  and b.werks   = $parameters.p_werks
  and dats_add_months( a.vfdat, 12,'FAIL' ) between $parameters.p_date_from and $parameters.p_date_to
