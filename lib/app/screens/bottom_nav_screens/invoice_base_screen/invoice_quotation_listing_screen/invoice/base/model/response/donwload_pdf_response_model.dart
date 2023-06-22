// To parse this JSON data, do
//
//     final downloadPdfResponseModel = downloadPdfResponseModelFromJson(jsonString);

import 'dart:convert';

List<int> downloadPdfResponseModelFromJson(String str) => List<int>.from(json.decode(str).map((x) => x));

String downloadPdfResponseModelToJson(List<int> data) => json.encode(List<dynamic>.from(data.map((x) => x)));
