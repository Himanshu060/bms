// To parse this JSON data, do
//
//     final cancelPayInRequestModel = cancelPayInRequestModelFromJson(jsonString);

import 'dart:convert';

CancelPayInRequestModel cancelPayInRequestModelFromJson(String str) => CancelPayInRequestModel.fromJson(json.decode(str));

String cancelPayInRequestModelToJson(CancelPayInRequestModel data) => json.encode(data.toJson());

class CancelPayInRequestModel {
  CancelPayInRequestModel({
    this.bizId,
    this.custId,
    this.invoiceId,
    this.payInId,
  });

  int? bizId;
  int? custId;
  int? invoiceId;
  int? payInId;

  factory CancelPayInRequestModel.fromJson(Map<String, dynamic> json) => CancelPayInRequestModel(
    bizId: json["bizID"],
    custId: json["custID"],
    invoiceId: json["invoiceID"],
    payInId: json["payInID"],
  );

  Map<String, dynamic> toJson() => {
    "bizID": bizId,
    "custID": custId,
    "invoiceID": invoiceId,
    "payInID": payInId,
  };
}
