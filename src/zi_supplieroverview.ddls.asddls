@EndUserText.label: 'Supplier overview with bank lines'
@AccessControl.authorizationCheck: #CHECK

define view entity ZI_SupplierOverview 

    with parameters
    p_companycode: bukrs
as select from ZI_SupplierCompanyBasic( p_companycode: $parameters.p_companycode ) as Comp
  left outer join ZI_SupplierBankDetails as BankDet
    on BankDet.Supplier = Comp.Supplier

    association [0..*] to ZI_SupplierBankDetails as _BankDetails
      on _BankDetails.Supplier = Comp.Supplier

{
  key Comp.Supplier,
      Comp.SupplierName,
      Comp.CompanyCode,
      Comp.ReconciliationAccount,
      Comp.PaymentTerms,
      Comp.SupplierAccountGroup,

      /* bank projection (0..*) */
      BankDet.BankAccountType,
      BankDet.BankKey,
      BankDet.BankAccount,
      BankDet.BankAccountHolderName,
      BankDet.BankCountry,
      BankDet.BankName
}
