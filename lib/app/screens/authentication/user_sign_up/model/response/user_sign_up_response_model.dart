// To parse this JSON data, do
//
//     final userSignUpResponseModel = userSignUpResponseModelFromJson(jsonString);

import 'dart:convert';

UserSignUpResponseModel userSignUpResponseModelFromJson(String str) =>
    UserSignUpResponseModel.fromJson(json.decode(str));

class UserSignUpResponseModel {
  UserSignUpResponseModel({
    this.isMobileVerification,
    this.token,
    this.userId,
  });

  bool? isMobileVerification;
  String? token;
  int? userId;

  factory UserSignUpResponseModel.fromJson(Map<String, dynamic> json) =>
      UserSignUpResponseModel(
        isMobileVerification: json["isMobileVerification"],
        token: json["token"],
        userId: json["userID"],
      );
}
