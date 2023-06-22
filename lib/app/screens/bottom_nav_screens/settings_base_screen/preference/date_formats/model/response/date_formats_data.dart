// To parse this JSON data, do
//
//     final dateFormatsData = dateFormatsDataFromJson(jsonString);

import 'dart:convert';

List<DateFormatsData> dateFormatsDataFromJson(String str) => List<DateFormatsData>.from(json.decode(str).map((x) => DateFormatsData.fromJson(x)));

String dateFormatsDataToJson(List<DateFormatsData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DateFormatsData {
  DateFormatsData({
    this.dateFormatId,
    this.dateFormat,
    this.isSelected,
  });

  int? dateFormatId;
  String? dateFormat;
  bool? isSelected;

  factory DateFormatsData.fromJson(Map<String, dynamic> json) => DateFormatsData(
    dateFormatId: json["dateFormatID"],
    dateFormat: json["dateFormat"],
    isSelected: json["isSelected"],
  );

  Map<String, dynamic> toJson() => {
    "dateFormatId": dateFormatId,
    "dateFormat": dateFormat,
    "isSelected": isSelected,
  };
}
