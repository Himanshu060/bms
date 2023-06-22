import 'package:bms/app/utils/logger_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AlertMessageUtils {
  /// show success popup snackBar message
  void showSuccessSnackBar(String message) {
    Get.snackbar('Success', message, snackPosition: SnackPosition.BOTTOM);
  }

  /// show error popup snackBar message
  void showErrorSnackBar(String message) {
    Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
  }

  /// show circular progress bar
  void showProgressDialog() {
    try {
      showDialog(
          context: Get.overlayContext!,
          builder: (_) => WillPopScope(
                child: Center(
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: Lottie.asset('lib/assets/gif/loader.json'),
                  ),
                ),
                onWillPop: () async => false,
              ));
    } catch (e) {
      LoggerUtils.logException('showProgressDialog', e);
    }
  }

  /// hider circular progress bar
  void hideProgressDialog() {
    try {
      Navigator.of(Get.overlayContext!).pop();
    } catch (ex) {
      LoggerUtils.logException('hideProgressDialog', ex);
    }
  }
}
