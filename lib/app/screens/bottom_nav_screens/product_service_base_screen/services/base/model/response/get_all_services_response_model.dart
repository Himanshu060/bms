// To parse this JSON data, do
//
//     final allServicesData = allServicesDataFromJson(jsonString);

import 'dart:convert';

List<AllServicesData> allServicesDataFromJson(String str) => List<AllServicesData>.from(json.decode(str).map((x) => AllServicesData.fromJson(x)));

class AllServicesData {
  AllServicesData({
    this.serviceId,
    this.bizId,
    this.categoryId,
    this.name,
    this.sac,
    this.unitId,
    this.sellPrice,
    this.isTaxInc,
    this.gstRateId,
    this.note,
    this.isActive,
  });

  int? serviceId;
  int? bizId;
  int? categoryId;
  String? name;
  String? sac;
  int? unitId;
  double? sellPrice;
  bool? isTaxInc;
  int? gstRateId;
  String? note;
  bool? isActive;

  factory AllServicesData.fromJson(Map<String, dynamic> json) => AllServicesData(
    serviceId: json["serviceID"],
    bizId: json["bizID"],
    categoryId: json["categoryID"],
    name: json["name"],
    sac: json["sac"],
    unitId: json["unitID"],
    sellPrice: json["sellPrice"],
    isTaxInc: json["isTaxInc"],
    gstRateId: json["gstRateID"],
    note: json["note"],
    isActive: json["isActive"],
  );

}
