// To parse this JSON data, do
//
//     final createNewCategoryRequestModel = createNewCategoryRequestModelFromJson(jsonString);

import 'dart:convert';

CreateNewCategoryRequestModel createNewCategoryRequestModelFromJson(String str) => CreateNewCategoryRequestModel.fromJson(json.decode(str));

String createNewCategoryRequestModelToJson(CreateNewCategoryRequestModel data) => json.encode(data.toJson());

class CreateNewCategoryRequestModel {
  CreateNewCategoryRequestModel({
    this.bizId,
    this.catName,
  });

  int? bizId;
  String? catName;

  factory CreateNewCategoryRequestModel.fromJson(Map<String, dynamic> json) => CreateNewCategoryRequestModel(
    bizId: json["bizID"],
    catName: json["catName"],
  );

  Map<String, dynamic> toJson() => {
    "bizID": bizId,
    "catName": catName,
  };
}
