// To parse this JSON data, do
//
//     final forgotPasswordRequestModel = forgotPasswordRequestModelFromJson(jsonString);

import 'dart:convert';

ForgotPasswordRequestModel forgotPasswordRequestModelFromJson(String str) => ForgotPasswordRequestModel.fromJson(json.decode(str));

String forgotPasswordRequestModelToJson(ForgotPasswordRequestModel data) => json.encode(data.toJson());

class ForgotPasswordRequestModel {
  ForgotPasswordRequestModel({
    this.mobileNo,
    this.idToken,
    this.password,
    this.isMobileVerification,
  });

  int? mobileNo;
  String? idToken;
  String? password;
  bool? isMobileVerification;

  factory ForgotPasswordRequestModel.fromJson(Map<String, dynamic> json) => ForgotPasswordRequestModel(
    mobileNo: json["mobileNo"],
    idToken: json["idToken"],
    password: json["password"],
    isMobileVerification: json["isMobileVerification"],
  );

  Map<String, dynamic> toJson() => {
    "mobileNo": mobileNo,
    "idToken": idToken,
    "password": password,
    "isMobileVerification": isMobileVerification,
  };
}
