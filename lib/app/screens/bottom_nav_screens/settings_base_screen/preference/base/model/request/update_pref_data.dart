// To parse this JSON data, do
//
//     final updatePrefereneData = updatePrefereneDataFromJson(jsonString);

import 'dart:convert';

UpdatePreferenceData updatePreferenceDataFromJson(String str) => UpdatePreferenceData.fromJson(json.decode(str));

String updatePreferenceDataToJson(UpdatePreferenceData data) => json.encode(data.toJson());

class UpdatePreferenceData {
  UpdatePreferenceData({
    this.bizId,
    this.invoiceFormatId,
  });

  int? bizId;
  int? invoiceFormatId;

  factory UpdatePreferenceData.fromJson(Map<String, dynamic> json) => UpdatePreferenceData(
    bizId: json["bizID"],
    invoiceFormatId: json["invoiceFormatID"],
  );

  Map<String, dynamic> toJson() => {
    "bizID": bizId,
    "invoiceFormatID": invoiceFormatId,
  };
}
