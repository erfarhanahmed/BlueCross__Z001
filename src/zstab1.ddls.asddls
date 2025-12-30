@AbapCatalog.sqlViewName: 'ZZSTAB'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'stability'
@Metadata.ignorePropagatedAnnotations: true
define view zstab1 
as select from qals
left outer join qprs on qprs.plos2 = qals.prueflos
left outer join qprn on qprn.pn_nr = qprs.pn_nr
left outer join tq43t on tq43t.stabicon = qprs.stabicon and tq43t.spras = $session.system_language
left outer join tq45t on tq45t.primpack = qprs.primpack and tq45t.sprache = $session.system_language
left outer join tq42t on tq42t.gebindetyp = qprs.gbtyp and tq42t.sprache = $session.system_language
left outer join nsdm_v_mseg on nsdm_v_mseg.xblnr_mkpf = qals.prueflos
                           and nsdm_v_mseg.matnr = qals.matnr
                           and nsdm_v_mseg.charg = qals.charg
                           and nsdm_v_mseg.bwart = '201'

{
    prueflos,
    case when qals.art = '1601' then qprn.qmnum else qals.warpl end as qmnum
    
    ,qprn.anlna
    ,qprn.anldt
    ,qprn.anlzt
    ,qprn.matnr
    ,qals.ktextmat
    ,qprn.werks
    ,qprn.charg
--    ,qmel.lgortcharg
    ,@Semantics.quantity.unitOfMeasure: 'a.inspectionlotquantityunit'
    qals.lmengeist
    ,qals.einhprobe
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
    ,qals.art
    ,@Semantics.quantity.unitOfMeasure: 'a.inspectionlotquantityunit'
     sum(case when nsdm_v_mseg.menge is null then 0 else nsdm_v_mseg.menge end) as withdraw_qty
    ,@Semantics.quantity.unitOfMeasure: 'a.inspectionlotquantityunit'
    ( qals.lmengeist - sum( case when nsdm_v_mseg.menge is null then 0 else nsdm_v_mseg.menge end ) ) as Balance_qty  

}
group by 
    prueflos,
    qals.art,
    qprn.qmnum,
    qals.warpl,
    qprn.anlna,
    qprn.anldt,
    qprn.anlzt,
    qprn.matnr,
    qals.ktextmat,
    qprn.werks,
    qprn.charg,
    qals.lmengeist,
    qals.einhprobe,
    qprn.pn_nr,
    qprn.pztxt,
    qprs.plos2,
    qprs.gbtyp,
    tq42t.kurztext,
    qprs.ktext,
    qprs.abort,
    qprs.primpack,
    tq45t.primpacktxt,
    qprs.stabicon,
    tq43t.stabicontxt;
