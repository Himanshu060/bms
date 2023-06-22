import 'package:bms/app/utils/logger_utils.dart';
import 'package:get/get.dart';

class AddProductServiceTabController extends GetxController {
  RxInt currentTabValue = 1.obs;

  setIntentData({required dynamic intentData}) {
    try {
      currentTabValue.value = (intentData[0] as int);
      currentTabValue.refresh();
    } catch (e) {
      LoggerUtils.logException('setIntentData', e);
    }
  }
}
