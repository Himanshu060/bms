import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class LoggerUtils {
  static var logger = Logger(
      printer: PrettyPrinter(
    printEmojis: true,
    printTime: false,
    colors: true,
  ),);

  // myPrint(value) {
  //   if (kDebugMode) {
  //     log("$value");
  //   }
  // }

  // static void logException(String title, dynamic object) {
  //   if (kDebugMode) {
  //     log(' ########## Exception : $title', error: object);
  //   }
  // }
  static void logException(String title, dynamic object) {
    if (kDebugMode) {
      logger.e('##### Exception : $title', object);
    }
  }

  static void logD(String title, dynamic object) {
    if (kDebugMode) {
      logger.d('##### Exception : $title', object);
    }
  }

  static void logI(String title, dynamic object) {
    if (kDebugMode) {
      logger.i('##### Exception : $title', object);
    }
  }
}
