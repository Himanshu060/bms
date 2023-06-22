// To parse this JSON data, do
//
//     final businessDetailsData = businessDetailsDataFromJson(jsonString);

import 'dart:convert';

BusinessDetailsData businessDetailsDataFromJson(String str) =>
    BusinessDetailsData.fromJson(json.decode(str));

String businessDetailsDataToJson(BusinessDetailsData data) =>
    json.encode(data.toJson());

class BusinessDetailsData {
  BusinessDetailsData({
    this.bizId,
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
    this.totalSellAmount,
    this.totalCollected,
  });

  int? bizId;
  int? userId;
  String? name;
  int? mobileNo;
  String? emailId;
  int? cityId;
  int? stateId;
  String? address;
  int? pincode;
  bool? isGstEnabled;
  String? gstNo;
  String? logo;
  double? totalSellAmount;
  double? totalCollected;

  factory BusinessDetailsData.fromJson(Map<String, dynamic> json) =>
      BusinessDetailsData(
        bizId: json["bizID"],
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
        totalSellAmount: json["totalSellAmount"].toDouble(),
        totalCollected: json["totalCollected"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "bizID": bizId,
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
        "totalSellAmount": totalSellAmount,
        "totalCollected": totalCollected,
      };
}
