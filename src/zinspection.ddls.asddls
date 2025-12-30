@AbapCatalog.sqlViewName: 'ZINSPRESULT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inspection details'
@Metadata.ignorePropagatedAnnotations: true

define view zinspection 

    as select from iinspchar as a
    inner join iinspectionlot as insp on insp.inspectionlot = a.inspectionlot
    inner join iinspoperation as b on b.inspectionlot = a.inspectionlot and b.inspplanoperationinternalid = a.inspplanoperationinternalid
    left outer join iinspresult on a.inspectionlot = iinspresult.inspectionlot
         and a.inspplanoperationinternalid = iinspresult.inspplanoperationinternalid
         and a.inspectioncharacteristic = iinspresult.inspectioncharacteristic
    left outer join iinspsschartp as c on c.inspectionlot = a.inspectionlot
         and iinspresult.inspresultvalidvaluesnumber = c.inspresultvalidvaluesnumber
         and iinspresult.inspectioncharacteristic = c.inspectioncharacteristic
{
key a.inspectionlot
    ,insp.material
    ,insp.batch
    ,insp.plant
    ,insp.inspectionlottype
    ,insp.inspectionlotobjecttext as Description
    ,insp.inspectionlotcreatedon
    ,a.inspplanoperationinternalid
    ,a.inspectioncharacteristic
    ,a.inspectionspecificationtext
    ,b.operationtext
    ,b.inspectionoperation
    ,iinspresult.inspresultvalidvaluesnumber
    ,a.inspspecisquantitative
    ,a.inspectionspecification
    ,case
        when a.inspspecisquantitative = '' then a.inspectionspecificationtext
        when a.inspspechasupperlimit = 'X' and a.inspspechaslowerlimit = 'X'
        then concat(concat(concat(cast(fltp_to_dec(a.inspspeclowerlimit as abap.dec (10,2)) as abap.char(20)),'-'),
                cast(fltp_to_dec(a.inspspecupperlimit as abap.dec (10,2)) as abap.char(20))),a.inspectionspecificationunit)
        when a.inspspechasupperlimit = 'X' and a.inspspechaslowerlimit = '' then concat(concat('','<='),concat(
                cast(fltp_to_dec(a.inspspecupperlimit as abap.dec (10,2)) as abap.char(20)),a.inspectionspecificationunit))
        when a.inspspechasupperlimit = '' and a.inspspechaslowerlimit = 'X' then concat(concat(
                cast(fltp_to_dec(a.inspspeclowerlimit as abap.dec (10,2)) as abap.char(20)),'>='),concat('',a.inspectionspecificationunit))
        when a.inspspechasupperlimit = '' and a.inspspechaslowerlimit = '' then a.inspectionspecificationunit
        else ' '
    end as Specification
    ,cast(fltp_to_dec(a.inspspeclowerlimit as abap.dec (10,2)) as abap.char(20)) as lowerlimit
    ,cast(fltp_to_dec(a.inspspecupperlimit as abap.dec (10,2)) as abap.char(20)) as upperlimit
    ,concat(iinspresult.characteristicattributecode,iinspresult.inspectionresultoriginalvalue) as insp_result
    ,iinspresult.inspectionresulttext as insp_description
    ,iinspresult.inspectionvaluationresult as insp_valuation
    ,iinspresult.creationdate as insp_end_date
    ,c.inspectionresultoriginalvalue as zresult
    ,c.characteristicattributecodetxt as zresulttext
    ,c.inspspecimportancecodetext
    
}
