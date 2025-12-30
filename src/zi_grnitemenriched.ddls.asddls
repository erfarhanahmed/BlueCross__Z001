/*@AbapCatalog.sqlViewName: 'ZVIGRNENRCH'*/
@EndUserText.label: 'GRN Items (enriched, display-ready)'

define view entity ZI_GRNItemEnriched
  as select from ZI_GRNItem as i
{
  key i.mblnr,
  key i.mjahr,
  key i.zeile,

  i.werks,
  i.matnr,
  i.MaterialText,
  i.bwart,
  i.charg,

  i.CurrencyLocal   as CurrencyLocal, 
  i.Quantity,
  i.meins,
  i.AmountLocal, 
  
  i.ebeln,
  i.ebelp,

  i.Bsart,
  i.PoTypeText,
  i.PoDocDate,
  i.PoItemChangeDate,

  i.lifnr,
  i.VendorName,
  i.VendorCity,

  i.VendorBatch,
  i.BatchMfgDate,
  i.BatchExpDate,

  /* Derived days from mfg to receipt (ABAP CDS date helper) */
  dats_days_between( cast( i.budat as abap.dats ),
                     cast( i.BatchMfgDate as abap.dats ) ) as DaysMfgToReceipt,

  /* Human-readable QM status */
  case i.UsageDecisionCode
    when 'A'  then 'ACCEPTED'
    when 'PA' then 'PARTIALLY ACCEPTED'
    when 'R'  then 'REJECTED'
  end as InspectionStatus,

  i.UsageDecisionDate,
  i.InspectionLot,
  i.LotCreatedOn,

  i.CostCenter,

  i.sgtxt,
  i.xblnr,
  i.Tcode,
  i.budat,
  i.bldat
}
