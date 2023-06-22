// To parse this JSON data, do
//
//     final preferencesData = preferencesDataFromJson(jsonString);

import 'dart:convert';

PreferencesData preferencesDataFromJson(String str) => PreferencesData.fromJson(json.decode(str));

String preferencesDataToJson(PreferencesData data) => json.encode(data.toJson());

class PreferencesData {
  PreferencesData({
    this.dateFormat,
    this.invoiceFormatId,
  });

  int? dateFormat;
  int? invoiceFormatId;

  factory PreferencesData.fromJson(Map<String, dynamic> json) => PreferencesData(
    dateFormat: json["dateFormat"],
    invoiceFormatId: json["invoiceFormatID"],
  );

  Map<String, dynamic> toJson() => {
    "dateFormat": dateFormat,
    "invoiceFormatID": invoiceFormatId,
  };
}
