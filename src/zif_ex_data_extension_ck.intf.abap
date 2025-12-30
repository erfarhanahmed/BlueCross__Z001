interface ZIF_EX_DATA_EXTENSION_CK
  public .


  methods ON_MATERIAL_SELECTION
    importing
      !IM_TCK03 type TCK03
      !IM_MACK3 type MACK3
      value(IM_CKKVMK) type CKKVMK
      !IM_PARAMETER1 type ANY optional
      !IM_PARAMETER2 type ANY optional
      !IM_PARAMETER3 type ANY optional
      !IM_PARAMETER4 type ANY optional
      !IM_PARAMETER5 type ANY optional
      !IM_PARAMETER6 type ANY optional
    changing
      !CH_DATA_EXTENSION_HEADER type CKF_KALM_EXTENSION .
  methods ON_BOM_EXPLOSION
    importing
      !IM_TCK03 type TCK03
      !IM_CSTMAT type CSTMAT
      value(IM_CKKVMK) type CKKVMK
      !IM_PARAMETER1 type ANY optional
      !IM_PARAMETER2 type ANY optional
      !IM_PARAMETER3 type ANY optional
      !IM_PARAMETER4 type ANY optional
      !IM_PARAMETER5 type ANY optional
      !IM_PARAMETER6 type ANY optional
    changing
      !CH_DATA_EXTENSION_HEADER type CKF_KALM_EXTENSION .
  methods ON_ASSEMBLY_COSTING
    importing
      !IM_TCK03 type TCK03
      !IM_CAUFVD type CAUFVD
      !IM_CKKVMK type CKKVMK optional
      !IM_PARAMETER1 type ANY optional
      !IM_PARAMETER2 type ANY optional
      !IM_PARAMETER3 type ANY optional
      !IM_PARAMETER4 type ANY optional
      !IM_PARAMETER5 type ANY optional
      !IM_PARAMETER6 type ANY optional
    changing
      !CH_DATA_EXTENSION_HEADER type CKF_KALM_EXTENSION .
  methods ON_COSTING_HEADER_CREATE
    importing
      !IM_TCK03 type TCK03
      value(IM_KEKO) type KEKO
      !IM_PARAMETER1 type ANY optional
      !IM_PARAMETER2 type ANY optional
      !IM_PARAMETER3 type ANY optional
      !IM_PARAMETER4 type ANY optional
      !IM_PARAMETER5 type ANY optional
      !IM_PARAMETER6 type ANY optional
    changing
      !CH_DATA_EXTENSION_HEADER type CKF_KEKO_EXTENSION .
  methods ON_ITEM_CREATE
    importing
      !IM_KLVAR type TCK03-KLVAR
      !IM_CAUFVD type CAUFVD optional
      !IM_AFPODGET type AFPODGET optional
      !IM_RESBD type RESBD optional
      !IM_AFVGD type AFVGD optional
      !IM_CO_OBJECT type CK_CO_OBJECT optional
      value(IM_KALKTAB) type CKKALKTAB
      !IM_PARAMETER1 type ANY optional
      !IM_PARAMETER2 type ANY optional
      !IM_PARAMETER3 type ANY optional
      !IM_PARAMETER4 type ANY optional
      !IM_PARAMETER5 type ANY optional
      !IM_PARAMETER6 type ANY optional
    changing
      !CH_DATA_EXTENSION_POS type CKF_KALKTAB_EXTENSION .
  methods ON_ITEM_VALUATE
    importing
      !IM_TCK03 type TCK03
      !IM_CKIBEW type CKIBEW
      value(IM_CKKALKTAB) type CKKALKTAB
      !IM_PARAMETER1 type ANY optional
      !IM_PARAMETER2 type ANY optional
      !IM_PARAMETER3 type ANY optional
      !IM_PARAMETER4 type ANY optional
      !IM_PARAMETER5 type ANY optional
      !IM_PARAMETER6 type ANY optional
    changing
      !CH_DATA_EXTENSION_POS type CKF_KALKTAB_EXTENSION .
  methods ON_MARKING
    importing
      !IM_KLVAR type TCK03-KLVAR
      !IM_MACK4 type MACK4
      value(IM_KEKO) type KEKO
      !IM_PARAMETER1 type ANY optional
      !IM_PARAMETER2 type ANY optional
      !IM_PARAMETER3 type ANY optional
      !IM_PARAMETER4 type ANY optional
      !IM_PARAMETER5 type ANY optional
      !IM_PARAMETER6 type ANY optional
    changing
      !CH_DATA_EXTENSION type CKF_KEKO_EXTENSION .
  methods ON_RELEASING
    importing
      !IM_KLVAR type TCK03-KLVAR
      !IM_CKMLPR type CKMLPR
      value(IM_KEKO) type KEKO
      !IM_PARAMETER1 type ANY optional
      !IM_PARAMETER2 type ANY optional
      !IM_PARAMETER3 type ANY optional
      !IM_PARAMETER4 type ANY optional
      !IM_PARAMETER5 type ANY optional
      !IM_PARAMETER6 type ANY optional
    changing
      !CH_DATA_EXTENSION type CKF_KEKO_EXTENSION .
endinterface.
