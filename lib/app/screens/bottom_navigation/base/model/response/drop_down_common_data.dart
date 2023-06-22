// To parse this JSON data, do
//
//     final dropdownCommonData = dropdownCommonDataFromJson(jsonString);

import 'dart:convert';

List<DropdownCommonData> dropdownCommonDataFromJson(String str) => List<DropdownCommonData>.from(json.decode(str).map((x) => DropdownCommonData.fromJson(x)));


class DropdownCommonData {
  DropdownCommonData({
    this.id,
    this.value,
    this.subId,
    this.name,
    this.isSelected,
  });

  int? id;
  double? value;
  int? subId;
  String? name;
  bool? isSelected;

  factory DropdownCommonData.fromJson(Map<String, dynamic> json) => DropdownCommonData(
    id: json["id"],
    value: json["value"].toDouble(),
    subId: json["subID"],
    name: json["name"],
    isSelected: json["isSelected"] = false,
  );


}
