// To parse this JSON data, do
//
//     final addServiceRequestModel = addServiceRequestModelFromJson(jsonString);

import 'dart:convert';

AddServiceRequestModel addServiceRequestModelFromJson(String str) => AddServiceRequestModel.fromJson(json.decode(str));

String addServiceRequestModelToJson(AddServiceRequestModel data) => json.encode(data.toJson());

class AddServiceRequestModel {
  AddServiceRequestModel({
    this.bizId,
    this.serviceID,
    this.name,
    this.categoryId,
    this.sac,
    this.sellPrice,
    this.isTaxInc,
    this.unitId,
    this.gstRateId,
  });

  int? bizId;
  int? serviceID;
  String? name;
  int? categoryId;
  String? sac;
  double? sellPrice;
  bool? isTaxInc;
  int? unitId;
  int? gstRateId;

  factory AddServiceRequestModel.fromJson(Map<String, dynamic> json) => AddServiceRequestModel(
    bizId: json["bizID"],
    serviceID: json["serviceID"],
    name: json["name"],
    categoryId: json["categoryID"],
    sac: json["sac"],
    sellPrice: json["sellPrice"],
    isTaxInc: json["isTaxInc"],
    unitId: json["unitID"],
    gstRateId: json["gstRateID"],
  );

  Map<String, dynamic> toJson() => {
    "bizID": bizId,
    "serviceID": serviceID,
    "name": name,
    "categoryID": categoryId,
    "sac": sac,
    "sellPrice": sellPrice,
    "isTaxInc": isTaxInc,
    "unitID": unitId,
    "gstRateID": gstRateId,
  };
}
