// To parse this JSON data, do
//
//     final checkUserExistRequestModel = checkUserExistRequestModelFromJson(jsonString);

import 'dart:convert';

CheckUserExistRequestModel checkUserExistRequestModelFromJson(String str) => CheckUserExistRequestModel.fromJson(json.decode(str));

String checkUserExistRequestModelToJson(CheckUserExistRequestModel data) => json.encode(data.toJson());

class CheckUserExistRequestModel {
  CheckUserExistRequestModel({
    this.mobileNo,
    this.emailId,
  });

  int? mobileNo;
  String? emailId;

  factory CheckUserExistRequestModel.fromJson(Map<String, dynamic> json) => CheckUserExistRequestModel(
    mobileNo: json["mobileNo"],
    emailId: json["emailID"],
  );

  Map<String, dynamic> toJson() => {
    "mobileNo": mobileNo,
    "emailID": emailId,
  };
}
