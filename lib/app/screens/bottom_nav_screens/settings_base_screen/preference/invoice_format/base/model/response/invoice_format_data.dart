// To parse this JSON data, do
//
//     final invoiceFormatData = invoiceFormatDataFromJson(jsonString);

import 'dart:convert';

List<InvoiceFormatData> invoiceFormatDataFromJson(String str) =>
    List<InvoiceFormatData>.from(
        json.decode(str).map((x) => InvoiceFormatData.fromJson(x)));

String invoiceFormatDataToJson(List<InvoiceFormatData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InvoiceFormatData {
  InvoiceFormatData({
    this.invFormatId,
    this.formatName,
    this.base64Img,
    this.isSelected,
  });

  int? invFormatId;
  String? formatName;
  String? base64Img;
  bool? isSelected;

  factory InvoiceFormatData.fromJson(Map<String, dynamic> json) =>
      InvoiceFormatData(
        invFormatId: json["invFormatID"],
        formatName: json["formatName"],
        base64Img: json["base64Img"],
        isSelected: json["isSelected"] = false,
      );

  Map<String, dynamic> toJson() => {
        "invFormatID": invFormatId,
        "formatName": formatName,
        "base64Img": base64Img,
      };
}
