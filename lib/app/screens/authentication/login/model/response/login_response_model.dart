// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  LoginResponseModel({
    this.token,
    this.userId,
    this.bizIds,
  });

  String? token;
  int? userId;
  List<int>? bizIds;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        token: json["token"],
        userId: json["userID"],
        bizIds: List<int>.from(json["bizIds"].map((x) => x)),
      );
}
