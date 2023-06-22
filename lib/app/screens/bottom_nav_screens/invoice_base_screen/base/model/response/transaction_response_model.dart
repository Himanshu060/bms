// To parse this JSON data, do
//
//     final transactionsResponseModel = transactionsResponseModelFromJson(jsonString);

import 'dart:convert';

List<TransactionsResponseModel> transactionsResponseModelFromJson(String str) =>
    List<TransactionsResponseModel>.from(
        json.decode(str).map((x) => TransactionsResponseModel.fromJson(x)));

String transactionsResponseModelToJson(List<TransactionsResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransactionsResponseModel {
  TransactionsResponseModel({
    this.tranType,
    this.id,
    this.invoiceNo,
    this.custId,
    this.custName,
    this.mobileNumber,
    this.emailID,
    this.payableAmount,
    this.collected,
    this.status,
    this.createdOn,
  });

  int? tranType;
  int? id;
  int? invoiceNo;
  int? custId;
  String? custName;
  int? mobileNumber;
  String? emailID;
  double? payableAmount;
  double? collected;
  int? status;
  String? createdOn;

  factory TransactionsResponseModel.fromJson(Map<String, dynamic> json) =>
      TransactionsResponseModel(
        tranType: json["tranType"],
        id: json["ID"],
        invoiceNo: json["invoiceNo"],
        custId: json["custID"],
        custName: json["custName"],
        mobileNumber: json["mobileNumber"],
        emailID: json["emailID"],
        payableAmount: json["payableAmount"],
        collected: json["collected"],
        status: json["status"],
        createdOn: json["createdOn"],
      );

  Map<String, dynamic> toJson() => {
        "tranType": tranType,
        "ID": id,
        "invoiceNo": invoiceNo,
        "custID": custId,
        "custName": custName,
        "mobileNumber": mobileNumber,
        "emailID": emailID,
        "payableAmount": payableAmount,
        "collected": collected,
        "status": status,
        "createdOn": createdOn,
      };
}
