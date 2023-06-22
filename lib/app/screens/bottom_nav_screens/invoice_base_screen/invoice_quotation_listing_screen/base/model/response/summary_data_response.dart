// To parse this JSON data, do
//
//     final summaryData = summaryDataFromJson(jsonString);

import 'dart:convert';

SummaryData summaryDataFromJson(String str) =>
    SummaryData.fromJson(json.decode(str));

String summaryDataToJson(SummaryData data) => json.encode(data.toJson());

class SummaryData {
  SummaryData({
    this.custId,
    this.customerName,
    this.totalSell,
    this.totalCollected,
    this.invDetail,
  });

  int? custId;
  String? customerName;
  double? totalSell;
  double? totalCollected;
  List<InvoiceDetailData>? invDetail;

  factory SummaryData.fromJson(Map<String, dynamic> json) => SummaryData(
        custId: json["custID"],
        customerName: json["customerName"],
        totalSell: json["totalSell"],
        totalCollected: json["totalCollected"],
        invDetail: List<InvoiceDetailData>.from(
            json["invDetail"].map((x) => InvoiceDetailData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "custID": custId,
        "customerName": customerName,
        "totalSell": totalSell,
        "totalCollected": totalCollected,
        "invDetail": List<dynamic>.from(invDetail!.map((x) => x.toJson())),
      };
}

class InvoiceDetailData {
  InvoiceDetailData({
    this.custId,
    this.invoiceId,
    this.invNo,
    this.totalAmount,
    this.collected,
    this.status,
    this.createdOn,
  });

  int? custId;
  int? invoiceId;
  int? invNo;
  double? totalAmount;
  double? collected;
  int? status;
  String? createdOn;

  factory InvoiceDetailData.fromJson(Map<String, dynamic> json) => InvoiceDetailData(
    custId: json["custId"],
        invoiceId: json["invoiceID"],
        invNo: json["invNo"],
        totalAmount: json["totalAmount"],
        collected: json["collected"],
        status: json["status"],
        createdOn: json["createdOn"],
      );

  Map<String, dynamic> toJson() => {
        "custId": custId,
        "invoiceID": invoiceId,
        "invNo": invNo,
        "totalAmount": totalAmount,
        "collected": collected,
        "status": status,
        "createdOn": createdOn,
      };
}
