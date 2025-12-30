@EndUserText.label: 'GRN Valuation (Consumption)'
/*@AccessControl.authorizationCheck: #Check*/
@UI.headerInfo: { typeName: 'GRN', typeNamePlural: 'GRNs',
  title: { type: #STANDARD, value: 'MBLNR' },
  description: { value: 'MaterialText' } }
define view entity ZC_GRNValuation
  as select from ZI_GRNItemEnriched as e
{
  key e.mblnr,
  key e.mjahr,
  key e.zeile,

  e.budat,
  e.werks,
  e.matnr,
  e.MaterialText,
  e.bwart,
  e.charg,

  e.Quantity, e.meins,
  e.CurrencyLocal,
  e.AmountLocal, 

  e.ebeln, e.ebelp,
  e.Bsart, e.PoTypeText, e.PoDocDate, e.PoItemChangeDate,

  e.lifnr, e.VendorName, e.VendorCity,

  e.VendorBatch, e.BatchMfgDate, e.BatchExpDate, e.DaysMfgToReceipt,

  e.InspectionLot, e.InspectionStatus, e.UsageDecisionDate,

  e.CostCenter,

  e.sgtxt, e.xblnr, e.Tcode
}
