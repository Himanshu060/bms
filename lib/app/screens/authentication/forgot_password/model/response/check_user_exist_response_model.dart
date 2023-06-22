// To parse this JSON data, do
//
//     final checkUserExistResponseModel = checkUserExistResponseModelFromJson(jsonString);

import 'dart:convert';

CheckUserExistResponseModel checkUserExistResponseModelFromJson(String str) => CheckUserExistResponseModel.fromJson(json.decode(str));

String checkUserExistResponseModelToJson(CheckUserExistResponseModel data) => json.encode(data.toJson());

class CheckUserExistResponseModel {
  CheckUserExistResponseModel({
    this.exist,
  });

  String? exist;

  factory CheckUserExistResponseModel.fromJson(Map<String, dynamic> json) => CheckUserExistResponseModel(
    exist: json["exist"],
  );

  Map<String, dynamic> toJson() => {
    "exist": exist,
  };
}
