// To parse this JSON data, do
//
//     final businesSignUpRequestModel = businesSignUpRequestModelFromJson(jsonString);

import 'dart:convert';

BusinessSignUpRequestModel businessSignUpRequestModelFromJson(String str) => BusinessSignUpRequestModel.fromJson(json.decode(str));

String businessSignUpRequestModelToJson(BusinessSignUpRequestModel data) => json.encode(data.toJson());

class BusinessSignUpRequestModel {
  BusinessSignUpRequestModel({
    this.bizID,
    this.userId,
    this.name,
    this.mobileNo,
    this.emailId,
    this.cityId,
    this.stateId,
    this.address,
    this.pincode,
    this.isGstEnabled,
    this.gstNo,
    this.logo,
    this.logoExtension,
    this.sign,
    this.signExtension,
  });

  int? bizID;
  int? userId;
  String? name;
  int? mobileNo;
  String? emailId;
  String? cityId;
  String? stateId;
  String? address;
  int? pincode;
  bool? isGstEnabled;
  String? gstNo;
  String? logo;
  String? logoExtension;
  String? sign;
  String? signExtension;

  factory BusinessSignUpRequestModel.fromJson(Map<String, dynamic> json) => BusinessSignUpRequestModel(
    bizID: json["bizID"],
    userId: json["userID"],
    name: json["name"],
    mobileNo: json["mobileNo"],
    emailId: json["emailID"],
    cityId: json["cityID"],
    stateId: json["stateID"],
    address: json["address"],
    pincode: json["pincode"],
    isGstEnabled: json["isGstEnabled"],
    gstNo: json["gstNo"],
    logo: json["logo"],
    logoExtension: json["logoExtention"],
    sign: json["sign"],
    signExtension: json["signExtention"],
  );

  Map<String, dynamic> toJson() => {
    "bizID": bizID,
    "userID": userId,
    "name": name,
    "mobileNo": mobileNo,
    "emailID": emailId,
    "cityID": cityId,
    "stateID": stateId,
    "address": address,
    "pincode": pincode,
    "isGstEnabled": isGstEnabled,
    "gstNo": gstNo,
    "logo": logo,
    "logoExtention": logoExtension,
    "sign": sign,
    "signExtention": signExtension,
  };
}
