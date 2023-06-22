// To parse this JSON data, do
//
//     final addCustomerRequestModel = addCustomerRequestModelFromJson(jsonString);

import 'dart:convert';

UpdateCustomerRequestModel updateCustomerRequestModelFromJson(String str) =>
    UpdateCustomerRequestModel.fromJson(json.decode(str));

String updateCustomerRequestModelToJson(UpdateCustomerRequestModel data) =>
    json.encode(data.toJson());

class UpdateCustomerRequestModel {
  UpdateCustomerRequestModel({
    this.bizId,
    this.custID,
    this.name,
    this.emailId,
    this.mobileNo,
    this.pinCode,
    this.gstNo,
    this.billingAddress,
  });

  int? bizId;
  int? custID;
  String? name;
  String? emailId;
  int? mobileNo;
  int? pinCode;
  String? gstNo;
  String? billingAddress;

  factory UpdateCustomerRequestModel.fromJson(Map<String, dynamic> json) =>
      UpdateCustomerRequestModel(
        bizId: json["bizID"],
        custID: json["custID"],
        name: json["name"],
        emailId: json["emailID"],
        mobileNo: json["mobileNo"],
        pinCode: json["pincode"],
        gstNo: json["gstNo"],
        billingAddress: json["billingAddress"],
      );

  Map<String, dynamic> toJson() => {
        "bizID": bizId,
        "custID": custID,
        "name": name,
        "emailID": emailId,
        "mobileNo": mobileNo,
        "pincode": pinCode,
        "gstNo": gstNo,
        "billingAddress": billingAddress,
      };
}
