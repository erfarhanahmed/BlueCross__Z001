@EndUserText.label: 'Cardex Movement (Detail)'
@AccessControl.authorizationCheck: #CHECK

define view entity ZI_CardexMovement 
        with parameters
    p_date_from : abap.dats,
    p_date_to   : abap.dats
as select from I_MaterialDocumentItem as Item
  inner join I_MaterialDocumentHeader as Head
    on  Item.MaterialDocument     = Head.MaterialDocument
    and Item.MaterialDocumentYear = Head.MaterialDocumentYear
  left outer join I_Product as Prod
    on Prod.Product = Item.Material
  left outer join I_Batch as Batch
    on  Batch.Material = Item.Material
    and Batch.Plant    = Item.Plant
    and Batch.Batch    = Item.Batch
  left outer join I_Supplier as Supp
  //  on Supp.Supplier = Head.Supplier
      on Supp.Supplier = Item.Supplier

  // ---- Associations (texts) ----
  association to I_ProductText as _ProdText
    on  _ProdText.Product  = Prod.Product
    and _ProdText.Language = $session.system_language

{
  // --- Keys from material document item ---
  key Item.MaterialDocument           as MaterialDocument,
  key Item.MaterialDocumentYear       as MaterialDocumentYear,
  key Item.MaterialDocumentItem       as MaterialDocumentItem,

  // --- Selection / grouping fields ---
  Item.Material                       as Material,
  Item.Plant                          as Plant,
  Item.StorageLocation                as StorageLocation,
  Item.Batch                          as Batch,
  Head.PostingDate                    as PostingDate,

  // --- Movement info ---
  Item.GoodsMovementType                   as MovementType,
  @Semantics.quantity.unitOfMeasure: 'BaseUnit'
  Item.QuantityInBaseUnit             as MovementQuantity,
  Item.MaterialBaseUnit                       as BaseUnit,
  Item.DebitCreditCode                as DebitCreditCode,

  // --- Enrichment ---
  _ProdText.ProductName        as MaterialDescription,
  Supp.Supplier                       as Supplier,
  Supp.SupplierName                   as SupplierName,

  // Batch info (fields may vary by tenant activation)
  Batch.ManufactureDate               as ManufactureDate,
  Batch.ShelfLifeExpirationDate       as ExpirationDate
}
where Head.PostingDate between $parameters.p_date_from and $parameters.p_date_to
