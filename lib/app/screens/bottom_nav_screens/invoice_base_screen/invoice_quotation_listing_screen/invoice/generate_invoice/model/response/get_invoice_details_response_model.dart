// To parse this JSON data, do
//
//     final getInvoiceDetailsResponseModel = getInvoiceDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/view_invoice/model/response/total_product_service_data.dart';

GetInvoiceDetailsResponseModel getInvoiceDetailsResponseModelFromJson(String str) => GetInvoiceDetailsResponseModel.fromJson(json.decode(str));

class GetInvoiceDetailsResponseModel {
  GetInvoiceDetailsResponseModel({
    this.bizMobileNo,
    this.bizIsGstEnabled,
    this.invoiceId,
    this.bizId,
    this.custId,
    this.invNo,
    this.itemList,
    this.additionalCharge,
    this.totalAmount,
    this.totalReceivedAmount,
    this.discountAmount,
    this.payableAmount,
    this.collected,
    this.status,
    this.type,
    this.createdOn,
  });

  int? bizMobileNo;
  bool? bizIsGstEnabled;
  int? invoiceId;
  int? bizId;
  int? custId;
  int? invNo;
  List<TotalProductServiceData>? itemList;
  double? additionalCharge;
  double? totalAmount;
  double? totalReceivedAmount;
  double? discountAmount;
  double? payableAmount;
  double? collected;
  int? status;
  int? type;
  String? createdOn;

  factory GetInvoiceDetailsResponseModel.fromJson(Map<String, dynamic> json) => GetInvoiceDetailsResponseModel(
    bizMobileNo: json["bizMobileNo"],
    bizIsGstEnabled: json["bizIsGstEnabled"],
    invoiceId: json["invoiceID"],
    bizId: json["bizID"],
    custId: json["custID"],
    invNo: json["invNo"],
    itemList: List<TotalProductServiceData>.from(json["itemList"].map((x) => TotalProductServiceData.fromJson(x))),
    additionalCharge: json["additionalCharge"].toDouble(),
    totalAmount: json["totalAmount"],
    totalReceivedAmount: json["totalReceivedAmount"],
    discountAmount: json["discountAmount"],
    payableAmount: json["payableAmount"].toDouble(),
    collected: json["collected"],
    status: json["status"],
    type: json["type"],
    createdOn: json["createdOn"],
  );


}

