// To parse this JSON data, do
//
//     final offlinePayInRequestModel = offlinePayInRequestModelFromJson(jsonString);

import 'dart:convert';

OfflinePayInRequestModel offlinePayInRequestModelFromJson(String str) => OfflinePayInRequestModel.fromJson(json.decode(str));

String offlinePayInRequestModelToJson(OfflinePayInRequestModel data) => json.encode(data.toJson());

class OfflinePayInRequestModel {
  OfflinePayInRequestModel({
    this.bizId,
    this.custId,
    this.invoiceId,
    this.paidAmount,
  });

  int? bizId;
  int? custId;
  int? invoiceId;
  double? paidAmount;

  factory OfflinePayInRequestModel.fromJson(Map<String, dynamic> json) => OfflinePayInRequestModel(
    bizId: json["bizID"],
    custId: json["custID"],
    invoiceId: json["invoiceID"],
    paidAmount: json["paidAmount"],
  );

  Map<String, dynamic> toJson() => {
    "bizID": bizId,
    "custID": custId,
    "invoiceID": invoiceId,
    "paidAmount": paidAmount,
  };
}
