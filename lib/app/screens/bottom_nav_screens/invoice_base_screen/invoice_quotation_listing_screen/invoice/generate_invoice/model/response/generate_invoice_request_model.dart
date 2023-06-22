// To parse this JSON data, do
//
//     final generateInvoiceRequestModel = generateInvoiceRequestModelFromJson(jsonString);

import 'dart:convert';

import 'package:bms/app/screens/bottom_nav_screens/customer_base_screen/add_customer/model/request/add_customer_request_modell.dart';

GenerateInvoiceRequestModel generateInvoiceRequestModelFromJson(String str) =>
    GenerateInvoiceRequestModel.fromJson(json.decode(str));

String generateInvoiceRequestModelToJson(GenerateInvoiceRequestModel data) =>
    json.encode(data.toJson());

class GenerateInvoiceRequestModel {
  GenerateInvoiceRequestModel({
    this.bizId,
    this.custId,
    this.invoiceID,
    this.productList,
    this.serviceList,
    this.additionalCharge,
    this.totalAmount,
    this.paidAmount,
    this.discountAmount,
    this.isCustExits,
    this.customerData,
  });

  int? bizId;
  int? custId;
  int? invoiceID;
  List<ProductList>? productList;
  List<ServiceList>? serviceList;
  double? additionalCharge;
  double? totalAmount;
  double? paidAmount;
  double? discountAmount;
  bool? isCustExits;
  AddCustomerRequestModel? customerData;

  factory GenerateInvoiceRequestModel.fromJson(Map<String, dynamic> json) =>
      GenerateInvoiceRequestModel(
        bizId: json["bizID"],
        custId: json["custID"],
        invoiceID: json["invoiceID"],
        productList: List<ProductList>.from(
            json["productList"].map((x) => ProductList.fromJson(x))),
        serviceList: List<ServiceList>.from(
            json["serviceList"].map((x) => ServiceList.fromJson(x))),
        additionalCharge: json["additionalCharge"],
        totalAmount: json["totalAmount"],
        paidAmount: json["paidAmount"],
        discountAmount: json["discountAmount"].toDouble(),
        isCustExits: json["discountAmount"],
        customerData: AddCustomerRequestModel.fromJson(json["custModel"]),
      );

  Map<String, dynamic> toJson() => {
        "bizID": bizId,
        "custID": custId,
        "invoiceID": invoiceID,
        "productList":
            List<dynamic>.from((productList ?? []).map((x) => x.toJson())),
        "serviceList":
            List<dynamic>.from((serviceList ?? []).map((x) => x.toJson())),
        "additionalCharge": additionalCharge,
        "totalAmount": totalAmount,
        "paidAmount": paidAmount,
        "discountAmount": discountAmount,
        "isCustExits": isCustExits,
        "custModel": customerData,
      };
}

class ProductList {
  ProductList({
    this.itemId,
    this.sellingPrice,
    this.qty,
    this.unitId,
    this.gstRateId,
    this.isTaxInc,
  });

  int? itemId;
  double? sellingPrice;
  double? qty;
  int? unitId;
  int? gstRateId;
  bool? isTaxInc;

  factory ProductList.fromJson(Map<String, dynamic> json) => ProductList(
        itemId: json["itemID"],
        sellingPrice: json["sellingPrice"],
        qty: json["qty"],
        unitId: json["unitID"],
        gstRateId: json["gstRateID"],
    isTaxInc: json["isTaxInc"],
      );

  Map<String, dynamic> toJson() => {
        "itemID": itemId,
        "sellingPrice": sellingPrice,
        "qty": qty,
        "unitID": unitId,
        "gstRateID": gstRateId,
        "isTaxInc": isTaxInc,
      };
}

class ServiceList {
  ServiceList({
    this.itemId,
    this.sellingPrice,
    this.qty,
    this.unitId,
    this.gstRateId,
    this.isTaxInc,
  });

  int? itemId;
  double? sellingPrice;
  double? qty;
  int? unitId;
  int? gstRateId;
  bool? isTaxInc;

  factory ServiceList.fromJson(Map<String, dynamic> json) => ServiceList(
        itemId: json["itemID"],
        sellingPrice: json["sellingPrice"],
        qty: json["qty"],
        unitId: json["unitID"],
        gstRateId: json["gstRateID"],
    isTaxInc: json["isTaxInc"],
      );

  Map<String, dynamic> toJson() => {
        "itemID": itemId,
        "sellingPrice": sellingPrice,
        "qty": qty,
        "unitID": unitId,
        "gstRateID": gstRateId,
        "isTaxInc": isTaxInc,
      };
}
