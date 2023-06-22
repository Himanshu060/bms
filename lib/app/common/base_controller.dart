import 'package:bms/app/utils/alert_message_utils.dart';
import 'package:get/get.dart';

class BaseController extends GetxController {
  BaseController() {
    Get.lazyPut(() => AlertMessageUtils(), fenix: true);
  }
}
