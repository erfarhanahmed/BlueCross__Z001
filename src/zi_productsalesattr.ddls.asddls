@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Sales Attributes (MVGR5 + text)'

define view entity ZI_ProductSalesAttr 
as select from mvke  as s
    left outer join tvm5t as t
      on  t.mvgr5 = s.mvgr5
      and t.spras = $session.system_language
{
  key s.matnr        as Material,
  key s.vkorg        as SalesOrganization,
  key s.vtweg        as DistributionChannel,
      s.mvgr5        as MaterialGroup5,
      t.bezei        as MaterialGroup5Text
}
