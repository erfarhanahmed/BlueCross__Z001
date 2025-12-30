@EndUserText.label: 'SO Item→Pricing Document (KNUMV) key'
define view entity ZI_SalesOrderItemKnumv 
    as select from vbap as vbap
    left outer join vbak as _vbak on _vbak.vbeln = vbap.vbeln

{

  key vbap.vbeln  as SalesOrder,

  key vbap.posnr  as SalesOrderItem,

      _vbak.knumv  as PricingDocument

}
