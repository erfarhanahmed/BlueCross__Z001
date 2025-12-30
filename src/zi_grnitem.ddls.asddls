/*@AbapCatalog.sqlViewName: 'ZVIGRNITEM' */
/*@AbapCatalog.compiler.compareFilter: true*/
@EndUserText.label: 'GRN Items(core,signed qty/value,enriched)'
define view entity ZI_GRNItem
  as select from mseg as m
    inner join mkpf as h
      on  h.mblnr = m.mblnr
      and h.mjahr = m.mjahr

    left outer join ekko as ekko
      on  ekko.ebeln = m.ebeln

    left outer join ekpo as ekpo
      on  ekpo.ebeln = m.ebeln
      and ekpo.ebelp = m.ebelp

    left outer join lfa1 as vnd
      on  vnd.lifnr = m.lifnr

    left outer join mcha as b
      on  b.matnr = m.matnr
      and b.werks = m.werks
      and b.charg = m.charg

    left outer join makt as mt
      on  mt.matnr = m.matnr
      and mt.spras = $session.system_language

    left outer join ekkn as ekkn
      on  ekkn.ebeln = m.ebeln
      and ekkn.ebelp = m.ebelp

    /* Prefiltered QM lots: “no active I0224” */
    left outer join ZI_QalsWithoutI0224 as q
      on  q.werk  = m.werks
      and q.matnr = m.matnr
      and q.charg = m.charg
      and q.mblnr = m.mblnr

    left outer join qave as qv
      on  qv.prueflos = q.prueflos

    /* Plain join for PO Type text (no association navigation) */
    left outer join t161t as t161t
      on  t161t.bsart = ekko.bsart
      and t161t.spras = $session.system_language
      and t161t.bstyp = 'F'

  /* (Optional) Associations for navigation only — note: no commas here */
  association [0..1] to ekko as _EKKO on  _EKKO.ebeln = m.ebeln
  association [0..1] to ekpo as _EKPO on  _EKPO.ebeln = m.ebeln and _EKPO.ebelp = m.ebelp
  association [0..1] to lfa1 as _Vendor on _Vendor.lifnr = m.lifnr
  association [0..1] to mcha as _Batch  on _Batch.matnr = m.matnr and _Batch.werks = m.werks and _Batch.charg = m.charg

{
  /* Keys */
  key m.mblnr,
  key m.mjahr,
  key m.zeile,

  /* Core */
  m.werks,
  m.matnr,
  m.bwart,
  m.charg,

  /* Signed qty & amount (reversals) */
  @Semantics.quantity.unitOfMeasure: 'MEINS'
  case m.shkzg when 'H' then - m.erfmg else m.erfmg end as Quantity,
  m.meins,
  @Semantics.amount.currencyCode: 'CurrencyLocal'
  case m.shkzg when 'H' then - m.dmbtr else m.dmbtr end as AmountLocal,

  /* PO / Vendor */
  m.lifnr,
  m.ebeln,
  m.ebelp,
  m.sgtxt,

  /* Header dates/refs */
  h.budat,
  h.bldat,
  h.xblnr,
  h.tcode as Tcode,                // if your system has MKPF-TCODE2, alias it here instead

  /* PO header/item details */
  ekko.bsart  as Bsart,
  ekko.bedat  as PoDocDate,        // <-- PO date fixed vs AEDAT
  ekko.waers  as CurrencyLocal,
  ekpo.aedat  as PoItemChangeDate,
  ekpo.knttp  as AccountAssgmtCat,
  @Semantics.amount.currencyCode: 'CurrencyLocal'
  ekpo.netpr  as NetPrice,
  ekpo.peinh  as PriceUnit,
  t161t.batxt as PoTypeText,

  /* Vendor master */
  vnd.name1   as VendorName,
  vnd.ort01   as VendorCity,

  /* Batch master */
  b.hsdat     as BatchMfgDate,
  b.vfdat     as BatchExpDate,
  b.licha     as VendorBatch,

  /* QM info (already filtered for no active I0224) */
  q.prueflos  as InspectionLot,
  q.pastrterm as LotCreatedOn,
  qv.vdatum   as UsageDecisionDate,
  qv.vcode    as UsageDecisionCode,

  /* Cost center */

  ekkn.kostl  as CostCenter,

  /* Material text */
  mt.maktx    as MaterialText
}
