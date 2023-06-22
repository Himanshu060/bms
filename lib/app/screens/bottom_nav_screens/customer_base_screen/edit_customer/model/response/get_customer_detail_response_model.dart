// To parse this JSON data, do
//
//     final getCustomerDetailRequestModel = getCustomerDetailRequestModelFromJson(jsonString);

import 'dart:convert';

GetCustomerDetailResponseModel getCustomerDetailResponseModelFromJson(String str) => GetCustomerDetailResponseModel.fromJson(json.decode(str));

String getCustomerDetailResponseModelToJson(GetCustomerDetailResponseModel data) => json.encode(data.toJson());

class GetCustomerDetailResponseModel {
  GetCustomerDetailResponseModel({
    this.custId,
    this.bizId,
    this.name,
    this.emailId,
    this.mobileNo,
    this.gstNo,
    // this.cityId,
    // this.stateId,
    this.pincode,
    this.billingAddress,
    // this.balance,
    // this.isActive,
  });

  int? custId;
  int? bizId;
  String? name;
  String? emailId;
  int? mobileNo;
  String? gstNo;
  // int cityId;
  // int stateId;
  int? pincode;
  String? billingAddress;
  // int balance;
  // bool isActive;

  factory GetCustomerDetailResponseModel.fromJson(Map<String, dynamic> json) => GetCustomerDetailResponseModel(
    custId: json["custID"],
    bizId: json["bizID"],
    name: json["name"],
    emailId: json["emailID"],
    mobileNo: json["mobileNo"],
    gstNo: json["gstNo"],
    // cityId: json["cityID"],
    // stateId: json["StateID"],
    pincode: json["pincode"],
    billingAddress: json["billingAddress"],
    // balance: json["balance"],
    // isActive: json["isActive"],
  );

  Map<String, dynamic> toJson() => {
    "custID": custId,
    "bizID": bizId,
    "name": name,
    "emailID": emailId,
    "mobileNo": mobileNo,
    "gstNo": gstNo,
    // "cityID": cityId,
    // "StateID": stateId,
    "pincode": pincode,
    "billingAddress": billingAddress,
    // "balance": balance,
    // "isActive": isActive,
  };
}
