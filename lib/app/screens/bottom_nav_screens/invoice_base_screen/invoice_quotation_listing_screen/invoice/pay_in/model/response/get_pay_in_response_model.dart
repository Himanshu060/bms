// To parse this JSON data, do
//
//     final payInData = payInDataFromJson(jsonString);

import 'dart:convert';

List<PayInData> payInDataFromJson(String str) => List<PayInData>.from(json.decode(str).map((x) => PayInData.fromJson(x)));

String payInDataToJson(List<PayInData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PayInData {
  PayInData({
    this.paymentInId,
    this.invoiceId,
    this.paidAmount,
    this.paymentModeId,
    this.createdOn,
    this.cancelledOn,
    this.bizId,
    this.custId,
  });

  int? paymentInId;
  int? invoiceId;
  double? paidAmount;
  int? paymentModeId;
  String? createdOn;
  String? cancelledOn;
  int? bizId;
  int? custId;

  factory PayInData.fromJson(Map<String, dynamic> json) => PayInData(
    paymentInId: json["paymentInID"],
    invoiceId: json["invoiceID"],
    paidAmount: json["paidAmount"],
    paymentModeId: json["paymentModeID"],
    createdOn: json["createdOn"],
    cancelledOn: json["cancelledOn"],
    bizId: json["bizID"],
    custId: json["custID"],
  );

  Map<String, dynamic> toJson() => {
    "paymentInID": paymentInId,
    "invoiceID": invoiceId,
    "paidAmount": paidAmount,
    "paymentModeID": paymentModeId,
    "createdOn": createdOn,
    "cancelledOn": cancelledOn,
    "bizID": bizId,
    "custID": custId,
  };
}
