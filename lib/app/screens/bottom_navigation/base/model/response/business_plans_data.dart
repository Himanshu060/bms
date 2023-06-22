// To parse this JSON data, do
//
//     final businessPlansData = businessPlansDataFromJson(jsonString);

import 'dart:convert';

BusinessPlansData businessPlansDataFromJson(String str) => BusinessPlansData.fromJson(json.decode(str));

class BusinessPlansData {
  BusinessPlansData({
    this.editableSellPrice,
  });

  bool? editableSellPrice;

  factory BusinessPlansData.fromJson(Map<String, dynamic> json) => BusinessPlansData(
    editableSellPrice: json["editableSellPrice"],
  );
}
