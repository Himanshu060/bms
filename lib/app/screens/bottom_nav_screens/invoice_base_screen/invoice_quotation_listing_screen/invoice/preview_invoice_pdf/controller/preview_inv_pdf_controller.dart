import 'dart:io';

import 'package:bms/app/utils/logger_utils.dart';
import 'package:get/get.dart';

class PreviewInvPdfController extends GetxController {
  late Rx<File> pdfFIle = File('').obs;

  void setIntentData({required dynamic intentData}) {
    try {
      Future.delayed(
        Duration(seconds: 1),
        () {
          pdfFIle.value = (intentData[0] as File);
        },
      );
    } catch (e) {
      LoggerUtils.logException('setIntentData', e);
    }
  }
}
