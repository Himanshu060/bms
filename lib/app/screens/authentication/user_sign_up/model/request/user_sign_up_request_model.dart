// To parse this JSON data, do
//
//     final userSignUpRequestModel = userSignUpRequestModelFromJson(jsonString);

import 'dart:convert';

UserSignUpRequestModel userSignUpRequestModelFromJson(String str) => UserSignUpRequestModel.fromJson(json.decode(str));

String userSignUpRequestModelToJson(UserSignUpRequestModel data) => json.encode(data.toJson());

class UserSignUpRequestModel {
  UserSignUpRequestModel({
    this.name,
    this.mobileNo,
    this.emailId,
    this.password,
    this.isMobileVerification,
    this.idToken,
  });

  String? name;
  int? mobileNo;
  String? emailId;
  String? password;
  bool? isMobileVerification;
  String? idToken;

  factory UserSignUpRequestModel.fromJson(Map<String, dynamic> json) => UserSignUpRequestModel(
    name: json["name"],
    mobileNo: json["mobileNo"],
    emailId: json["emailID"],
    password: json["password"],
    isMobileVerification: json["isMobileVerification"],
    idToken: json["idToken"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "mobileNo": mobileNo,
    "emailID": emailId,
    "password": password,
    "isMobileVerification": isMobileVerification,
    "idToken": idToken,
  };
}
