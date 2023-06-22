// To parse this JSON data, do
//
//     final viewInvoiceData = viewInvoiceDataFromJson(jsonString);

import 'dart:convert';

ViewInvoiceData viewInvoiceDataFromJson(String str) =>
    ViewInvoiceData.fromJson(json.decode(str));

class ViewInvoiceData {
  ViewInvoiceData({
    this.itemList,
    this.totalAmount,
    this.totalReceivedAmount,
    this.additionalCharge,
    this.discountAmount,
    this.payableAmount,
    this.collected,
    this.createdOn,
    this.discountPercentage,
    this.gstRateId,
  });

  List<ViewItemList>? itemList;
  double? totalAmount;
  double? totalReceivedAmount;
  double? additionalCharge;
  double? payableAmount;
  double? collected;
  double? discountAmount;
  String? createdOn;
  double? discountPercentage;
  int? gstRateId;

  factory ViewInvoiceData.fromJson(Map<String, dynamic> json) =>
      ViewInvoiceData(
        itemList: List<ViewItemList>.from(
            json["itemList"].map((x) => ViewItemList.fromJson(x))),
        totalAmount: json["totalAmount"] = 0.0,
        totalReceivedAmount: json["totalReceivedAmount"],
        additionalCharge: json["additionalCharge"],
        discountAmount: json["discountAmount"],
        payableAmount: json["payableAmount"],
        collected: json["collected"],
        createdOn: json["createdOn"],
        discountPercentage: json["discountPercentage"] = 0.0,
        gstRateId: json["gstRateID"],
      );
}

class ViewItemList {
  ViewItemList({
    this.name,
    this.isProduct,
    this.isTaxInc,
    this.itemId,
    this.sellingPrice,
    this.qty,
    this.unitId,
    this.gstRateId,
  });

  String? name;
  bool? isProduct;
  bool? isTaxInc;
  int? itemId;
  double? sellingPrice;
  double? qty;
  int? unitId;
  int? gstRateId;

  factory ViewItemList.fromJson(Map<String, dynamic> json) => ViewItemList(
        name: json["name"],
        isProduct: json["isProduct"],
        isTaxInc: json["isTaxInc"],
        itemId: json["itemID"],
        sellingPrice: json["sellingPrice"],
        qty: json["qty"],
        unitId: json["unitID"],
        gstRateId: json["gstRateID"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "isProduct": isProduct,
        "isTaxInc": isTaxInc,
        "itemID": itemId,
        "sellingPrice": sellingPrice,
        "qty": qty,
        "unitID": unitId,
        "gstRateID": gstRateId,
      };
}
