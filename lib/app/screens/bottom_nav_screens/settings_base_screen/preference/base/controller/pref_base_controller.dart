import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/local_storage_constants.dart';
import 'package:bms/app/common/route_constants.dart';
import 'package:bms/app/common/status_codes.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/preference/base/model/response/preferenes_data.dart';
import 'package:bms/app/services/repository/setting_repository.dart';
import 'package:bms/app/utils/alert_message_utils.dart';
import 'package:bms/app/utils/decode_response_data/decode_response_data.dart';
import 'package:bms/app/utils/local_storage.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:get/get.dart';

class PrefBaseController extends GetxController {
  String bizId = '';
  Rx<PreferencesData> prefData = PreferencesData().obs;
  RxList<String> screeNames = List<String>.empty(growable: true).obs;

  @override
  Future<void> onInit() async {
    Get.lazyPut(() => SettingRepository(), fenix: true);
    bizId = await Get.find<LocalStorage>().getStringFromStorage(kStorageBizId);
    screeNames.add(kInvoiceFormats);
    screeNames.add(kDateFormats);
    await getPreferencesFromServer();
    super.onInit();
  }

  Future<void> getPreferencesFromServer() async {
    try {
      var response =
          await Get.find<SettingRepository>().getPreferences(bizId: bizId);

      if (response != null) {
        if (response.statusCode == successStatusCode) {
          var res = decodeResponseData(responseData: response.data ?? '');
          if (res != null && res != '') {
            prefData.value = preferencesDataFromJson(res);
          }
        } else {
          Get.find<AlertMessageUtils>().showErrorSnackBar(response.msg ?? '');
        }
      }
    } catch (e) {
      LoggerUtils.logException('getPreferencesFromServer', e);
    }
  }

  void navigateToInvFormatScreen() {
    Get.toNamed(kRouteInvoiceFormatsScreen,
        arguments: [prefData.value.invoiceFormatId ?? 0]);
  }

  void navigateToDateFormatsScreen() {
    Get.toNamed(kRouteDateFormatsScreen);
  }

  void navigateToPrefsScreens({required int index}) {
    if (index == 0) {
      navigateToInvFormatScreen();
    } else {
      navigateToDateFormatsScreen();
    }
  }
}
