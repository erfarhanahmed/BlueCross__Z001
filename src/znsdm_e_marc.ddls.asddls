@AbapCatalog.sqlViewAppendName: 'ZNSDM_V'
@EndUserText.label: 'NSDM_E_MARC'
extend view nsdm_e_marc with ZNSDM_E_MARC
{
  zzregn_no,
  zzpacksize
}
