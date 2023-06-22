// To parse this JSON data, do
//
//     final businesSignUpResponseModel = businesSignUpResponseModelFromJson(jsonString);

import 'dart:convert';

BusinessSignUpResponseModel businessSignUpResponseModelFromJson(String str) => BusinessSignUpResponseModel.fromJson(json.decode(str));


class BusinessSignUpResponseModel {
  BusinessSignUpResponseModel({
    this.isMobileVerification,
    this.token,
    this.userId,
    this.bizIds,
  });

  bool? isMobileVerification;
  String? token;
  int? userId;
  List<int>? bizIds;

  factory BusinessSignUpResponseModel.fromJson(Map<String, dynamic> json) => BusinessSignUpResponseModel(
    isMobileVerification: json["isMobileVerification"],
    token: json["token"],
    userId: json["userID"],
    bizIds: List<int>.from(json["bizIds"].map((x) => x)),
  );

}
