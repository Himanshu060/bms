import 'package:bms/app/utils/logger_utils.dart';

class StringUtils {
  static String getSanitizedContactNumber(String inputNumber) {
    String finalNumber = '';
    try {
      var trimmedNumber = inputNumber.trim();
      var removedSpecialChars = trimmedNumber.replaceAll(RegExp(r'[^\d]+'), '');
      if (removedSpecialChars.length > 10) {
        var last10Digit =
            removedSpecialChars.substring(removedSpecialChars.length - 10);
        if (last10Digit.length == 10) {
          finalNumber = last10Digit;
        }
      }
      else {
        finalNumber = removedSpecialChars;
      }
    } catch (ex) {
      LoggerUtils.logException('getSanitizedContactNumber', ex);
    }
    return finalNumber;
  }
}
