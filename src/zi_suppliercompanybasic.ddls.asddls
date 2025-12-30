@EndUserText.label: 'Supplier + Company Code basics'
@AccessControl.authorizationCheck: #CHECK

define view entity ZI_SupplierCompanyBasic 
with parameters
    p_companycode: bukrs
as select from I_SupplierCompany as Comp
  inner join I_Supplier as Supp
    on Comp.Supplier = Supp.Supplier
{
  key Comp.Supplier                     as Supplier,
      Supp.SupplierName                 as SupplierName,
      Comp.CompanyCode                  as CompanyCode,
      Comp.ReconciliationAccount        as ReconciliationAccount,
      Comp.PaymentTerms                 as PaymentTerms,
      Supp.SupplierAccountGroup         as SupplierAccountGroup
}
where Comp.CompanyCode = $parameters.p_companycode
