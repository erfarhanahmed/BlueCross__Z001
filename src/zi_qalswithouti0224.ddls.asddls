@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'QALS lots without active JEST status I0224'

define view entity ZI_QalsWithoutI0224
  as select from qals as q
    left outer join jest as j
      on  j.objnr = q.objnr
      and j.stat  = 'I0224'
      and j.inact = ' '           // active status
{
  key q.werk,
  key q.matnr,
  key q.charg,
  key q.mblnr,
      q.prueflos,
      q.pastrterm
}
where j.objnr is null
