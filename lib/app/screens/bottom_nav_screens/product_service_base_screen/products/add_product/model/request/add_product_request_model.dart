// To parse this JSON data, do
//
//     final addProductRequestModel = addProductRequestModelFromJson(jsonString);

import 'dart:convert';

AddProductRequestModel addProductRequestModelFromJson(String str) =>
    AddProductRequestModel.fromJson(json.decode(str));

String addProductRequestModelToJson(AddProductRequestModel data) =>
    json.encode(data.toJson());

class AddProductRequestModel {
  AddProductRequestModel({
    this.bizId,
    this.productID,
    this.name,
    this.categoryId,
    this.gstRateId,
    this.hsn,
    this.qrBarCode,
    this.purchasePrice,
    this.sellPrice,
    this.purIsTaxInc,
    this.sellIsTaxInc,
    this.unitId,
  });

  int? bizId;
  int? productID;
  String? name;
  int? categoryId;
  int? gstRateId;
  String? hsn;
  String? qrBarCode;
  double? purchasePrice;
  double? sellPrice;
  bool? purIsTaxInc;
  bool? sellIsTaxInc;
  int? unitId;

  factory AddProductRequestModel.fromJson(Map<String, dynamic> json) =>
      AddProductRequestModel(
        bizId: json["bizID"],
        productID: json["productID"],
        name: json["name"],
        categoryId: json["categoryID"],
        gstRateId: json["gstRateID"],
        hsn: json["hsn"],
        qrBarCode: json["qrBarCode"],
        purchasePrice: json["purchasePrice"],
        sellPrice: json["sellPrice"],
        purIsTaxInc: json["purIsTaxInc"],
        sellIsTaxInc: json["sellIsTaxInc"],
        unitId: json["unitID"],
      );

  Map<String, dynamic> toJson() => {
        "bizID": bizId,
        "productID": productID,
        "name": name,
        "categoryID": categoryId,
        "gstRateID": gstRateId,
        "hsn": hsn,
        "qrBarCode": qrBarCode,
        "purchasePrice": purchasePrice,
        "sellPrice": sellPrice,
        "sellIsTaxInc": sellIsTaxInc,
        "unitID": unitId,
      };
}
