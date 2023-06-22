// To parse this JSON data, do
//
//     final allCustomerData = allCustomerDataFromJson(jsonString);

import 'dart:convert';

List<AllCustomerData> allCustomerDataFromJson(String str) => List<AllCustomerData>.from(json.decode(str).map((x) => AllCustomerData.fromJson(x)));



class AllCustomerData {
  AllCustomerData({
    this.custId,
    this.bizId,
    this.name,
    this.emailId,
    this.mobileNo,
    this.gstNo,
    this.cityId,
    this.stateId,
    this.pincode,
    this.billingAddress,
    this.collected,
    this.totalSellAmount,
    this.dueAmount,
    this.isSelected,
    this.isActive,
  });

  int? custId;
  int? bizId;
  String? name;
  String? emailId;
  int? mobileNo;
  String? gstNo;
  int? cityId;
  int? stateId;
  int? pincode;
  String? billingAddress;
  double? collected;
  double? totalSellAmount;
  double? dueAmount;
  bool? isSelected;
  bool? isActive;

  factory AllCustomerData.fromJson(Map<String, dynamic> json) => AllCustomerData(
    custId: json["custID"],
    bizId: json["bizID"],
    name: json["name"],
    emailId: json["emailID"],
    mobileNo: json["mobileNo"],
    gstNo: json["gstNo"],
    cityId: json["cityID"],
    stateId: json["StateID"],
    pincode: json["pincode"],
    billingAddress: json["billingAddress"],
    collected: json["collected"],
    totalSellAmount: json["totalSellAmount"],
    dueAmount: json["dueAmount"] = 0.0,
    isSelected: json["isSelected"] = false,
    isActive: json["isActive"],
  );

}
