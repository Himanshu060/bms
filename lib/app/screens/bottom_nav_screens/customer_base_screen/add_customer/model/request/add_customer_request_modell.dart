// To parse this JSON data, do
//
//     final addCustomerRequestModel = addCustomerRequestModelFromJson(jsonString);

import 'dart:convert';

AddCustomerRequestModel addCustomerRequestModelFromJson(String str) =>
    AddCustomerRequestModel.fromJson(json.decode(str));

String addCustomerRequestModelToJson(AddCustomerRequestModel data) =>
    json.encode(data.toJson());

class AddCustomerRequestModel {
  AddCustomerRequestModel({
    this.bizId,
    this.name,
    this.emailId,
    this.mobileNo,
    this.pinCode,
    this.gstNo,
    this.billingAddress,
  });

  int? bizId;
  String? name;
  String? emailId;
  int? mobileNo;
  int? pinCode;
  String? gstNo;
  String? billingAddress;

  factory AddCustomerRequestModel.fromJson(Map<String, dynamic> json) =>
      AddCustomerRequestModel(
        bizId: json["bizID"],
        name: json["name"],
        emailId: json["emailID"],
        mobileNo: json["mobileNo"],
        pinCode: json["pincode"],
        gstNo: json["gstNo"],
        billingAddress: json["billingAddress"],
      );

  Map<String, dynamic> toJson() => {
        "bizID": bizId,
        "name": name,
        "emailID": emailId,
        "mobileNo": mobileNo,
        "pincode": pinCode,
        "gstNo": gstNo,
        "billingAddress": billingAddress,
      };
}
