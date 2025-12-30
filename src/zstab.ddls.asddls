@AbapCatalog.sqlViewName: 'ZSTABILITY'
@AbapCatalog.compiler.compareFilter: true
--@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'stability'
@Metadata.ignorePropagatedAnnotations: true
define view zstab 
as select from qprn
inner join qprs on qprs.pn_nr = qprn.pn_nr
inner join qmel on qmel.qmnum = qprn.qmnum
inner join iinspectionlot as a on a.inspectionlot = qprs.plos2
left outer join nsdm_v_mseg on nsdm_v_mseg.xblnr_mkpf = a.inspectionlot
                           and nsdm_v_mseg.matnr = a.material
                           and nsdm_v_mseg.charg = a.batch
                           and nsdm_v_mseg.bwart = '201'
left outer join tq43t on tq43t.stabicon = qprs.stabicon and tq43t.spras = $session.system_language
left outer join tq45t on tq45t.primpack = qprs.primpack and tq45t.sprache = $session.system_language
left outer join tq42t on tq42t.gebindetyp = qprs.gbtyp and tq42t.sprache = $session.system_language

{
     qprn.qmnum
    ,qprn.anlna
    ,qprn.anldt
    ,qprn.anlzt
    ,qprn.matnr
    ,a.inspectionlotobjecttext
    ,qprn.werks
    ,qprn.charg
    ,qmel.lgortcharg
    ,@Semantics.quantity.unitOfMeasure: 'a.inspectionlotquantityunit'
    a.inspectionlotactualquantity
    ,a.inspectionlotquantityunit
    ,qprn.pn_nr
    ,qprn.pztxt
    ,qprs.plos2
    ,qprs.gbtyp
    ,@Environment.systemField: #SYSTEM_LANGUAGE
    tq42t.kurztext
    ,qprs.ktext
    ,qprs.abort
    ,qprs.primpack
    ,@Environment.systemField: #SYSTEM_LANGUAGE
    tq45t.primpacktxt
    ,qprs.stabicon  // description
    ,@Environment.systemField: #SYSTEM_LANGUAGE
    tq43t.stabicontxt
    ,a.inspectionlottype
    ,@Semantics.quantity.unitOfMeasure: 'a.inspectionlotquantityunit'
     sum(case when nsdm_v_mseg.menge is null then 0 else nsdm_v_mseg.menge end) as withdraw_qty
    ,@Semantics.quantity.unitOfMeasure: 'a.inspectionlotquantityunit'
    ( a.inspectionlotactualquantity - sum( case when nsdm_v_mseg.menge is null then 0 else nsdm_v_mseg.menge end ) ) as Balance_qty  
}
group by      
    qprn.qmnum
    ,qprn.anlna
    ,qprn.anldt
    ,qprn.anlzt
    ,qprn.matnr
    ,a.inspectionlotobjecttext
    ,qprn.werks
    ,qprn.charg
    ,qmel.lgortcharg
    ,a.inspectionlotactualquantity
    ,a.inspectionlotquantityunit
    ,qprn.pn_nr
    ,qprn.pztxt
    ,qprs.plos2
    ,qprs.gbtyp
    ,tq42t.kurztext
    ,qprs.ktext
    ,qprs.abort
    ,qprs.primpack
    ,tq45t.primpacktxt
    ,qprs.stabicon
    ,tq43t.stabicontxt
    ,a.inspectionlottype;
