// To parse this JSON data, do
//
//     final allProductsData = allProductsDataFromJson(jsonString);

import 'dart:convert';

List<AllProductsData> allProductsDataFromJson(String str) =>
    List<AllProductsData>.from(
        json.decode(str).map((x) => AllProductsData.fromJson(x)));

String allProductsDataToJson(List<AllProductsData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllProductsData {
  AllProductsData({
    this.productId,
    this.bizId,
    this.name,
    this.categoryId,
    this.gstRateId,
    this.hsn,
    this.qrBarCode,
    this.purchasePrice,
    this.purIsTaxInc,
    this.sellPrice,
    this.sellIsTaxInc,
    this.unitId,
    this.note,
    this.isActive,
  });

  int? productId;
  int? bizId;
  String? name;
  int? categoryId;
  int? gstRateId;
  String? hsn;
  String? qrBarCode;
  double? purchasePrice;
  bool? purIsTaxInc;
  double? sellPrice;
  bool? sellIsTaxInc;
  int? unitId;
  String? note;
  bool? isActive;

  factory AllProductsData.fromJson(Map<String, dynamic> json) =>
      AllProductsData(
        productId: json["productID"],
        bizId: json["bizID"],
        name: json["name"],
        categoryId: json["categoryID"],
        gstRateId: json["gstRateID"],
        hsn: json["hsn"],
        qrBarCode: json["qrBarCode"],
        purchasePrice: json["purchasePrice"],
        purIsTaxInc: json["purIsTaxInc"],
        sellPrice: json["sellPrice"],
        sellIsTaxInc: json["sellIsTaxInc"],
        unitId: json["unitID"],
        note: json["note"],
        isActive: json["isActive"],
      );

  Map<String, dynamic> toJson() => {
        "productID": productId,
        "bizID": bizId,
        "name": name,
        "categoryID": categoryId,
        "gstRateID": gstRateId,
        "purchasePrice": purchasePrice,
        "purIsTaxInc": purIsTaxInc,
        "sellPrice": sellPrice,
        "sellIsTaxInc": sellIsTaxInc,
        "unitID": unitId,
        "isActive": isActive,
      };
}
