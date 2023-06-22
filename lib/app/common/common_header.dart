import 'package:bms/app/common/local_storage_constants.dart';
import 'package:bms/app/utils/local_storage.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:get/get.dart';

class CommonHeader {
  Future<Map<String, String>> headers() async {
    try{
      var token = await Get.find<LocalStorage>().getStringFromStorage(kStorageToken);
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      return headers;
    }catch(e){
      LoggerUtils.logException('common headers', e);
    }
    return Map();
  }
}