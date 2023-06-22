// To parse this JSON data, do
//
//     final commonResponseModel = commonResponseModelFromJson(jsonString);

import 'dart:convert';

CommonResponseModel commonResponseModelFromJson(String str) =>
    CommonResponseModel.fromJson(json.decode(str));

class CommonResponseModel {
  CommonResponseModel({
    this.data,
    this.statusCode,
    this.msg,
  });

  String? data;
  int? statusCode;
  String? msg;

  factory CommonResponseModel.fromJson(Map<String, dynamic> json) =>
      CommonResponseModel(
        data: json["data"],
        statusCode: json["statusCode"],
        msg: json["msg"] ?? "",
      );
}
