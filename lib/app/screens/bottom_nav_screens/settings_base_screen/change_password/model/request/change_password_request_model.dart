// To parse this JSON data, do
//
//     final changePasswordRequestModel = changePasswordRequestModelFromJson(jsonString);

import 'dart:convert';

ChangePasswordRequestModel changePasswordRequestModelFromJson(String str) => ChangePasswordRequestModel.fromJson(json.decode(str));

String changePasswordRequestModelToJson(ChangePasswordRequestModel data) => json.encode(data.toJson());

class ChangePasswordRequestModel {
  ChangePasswordRequestModel({
    this.bizId,
    this.userId,
    this.oldPassword,
    this.newPassword,
  });

  int? bizId;
  int? userId;
  String? oldPassword;
  String? newPassword;

  factory ChangePasswordRequestModel.fromJson(Map<String, dynamic> json) => ChangePasswordRequestModel(
    bizId: json["bizID"],
    userId: json["userID"],
    oldPassword: json["oldPassword"],
    newPassword: json["newPassword"],
  );

  Map<String, dynamic> toJson() => {
    "bizID": bizId,
    "userID": userId,
    "oldPassword": oldPassword,
    "newPassword": newPassword,
  };
}
