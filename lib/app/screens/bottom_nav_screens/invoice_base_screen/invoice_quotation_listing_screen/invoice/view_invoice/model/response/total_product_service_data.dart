class TotalProductServiceData {
  TotalProductServiceData({
    this.qty,
    this.itemId,
    this.name,
    this.categoryId,
    this.gstRateId,
    this.sellPrice,
    this.unitId,
    this.itemTotal,
    this.qrBarCode,
    this.isTaxIncluded,
    this.isSelected,
    this.isAddedToList,
    this.isProduct,
  });

  double? qty;
  int? itemId;
  String? name;
  int? categoryId;
  int? gstRateId;
  double? sellPrice;
  int? unitId;
  double? itemTotal;
  String? qrBarCode;
  bool? isTaxIncluded;
  bool? isSelected;
  bool? isAddedToList;
  bool? isProduct;

  factory TotalProductServiceData.fromJson(Map<String, dynamic> json) =>
      TotalProductServiceData(
        qty: json["qty"],
        itemId: json["itemID"],
        name: json["name"],
        categoryId: json["categoryID"],
        gstRateId: json["gstRateID"],
        sellPrice: json["sellingPrice"],
        unitId: json["unitID"],
        itemTotal: json["itemTotal"],
        qrBarCode: json["qrBarCode"],
        isTaxIncluded: json["isTaxIncluded"],
        isSelected: json["isSelected"] = false,
        isAddedToList: json["isAddedToList"] = false,
        isProduct: json["isProduct"] ,
      );
}
