@EndUserText.label: 'Supplier bank details with bank name'
@AccessControl.authorizationCheck: #CHECK

define view entity ZI_SupplierBankDetails 
as select from I_SuplrBankDetailsByIntId as BankDet
    association [0..1] to I_Bank as _Bank
      on  _Bank.Bank    = BankDet.Bank
      and _Bank.BankCountry = BankDet.BankCountry
{
  key BankDet.Supplier                  as Supplier,
      BankDet.BPBankAccountInternalID   as BankAccountType,
      BankDet.Bank                      as BankKey,
      BankDet.BankAccount               as BankAccount,
      BankDet.BankAccountHolderName     as BankAccountHolderName,
      BankDet.BankCountry               as BankCountry,
      _Bank.BankName                    as BankName
}
