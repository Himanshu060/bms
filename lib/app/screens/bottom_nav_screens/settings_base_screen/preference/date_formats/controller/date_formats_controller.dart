import 'package:bms/app/common/local_storage_constants.dart';
import 'package:bms/app/common/status_codes.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/preference/base/model/request/update_pref_data.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/preference/date_formats/model/response/date_formats_data.dart';
import 'package:bms/app/services/repository/setting_repository.dart';
import 'package:bms/app/utils/alert_message_utils.dart';
import 'package:bms/app/utils/local_storage.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateFormatsController extends GetxController {
  var bizId ='';
  RxList<DateFormatsData> dateFormatsList =
      List<DateFormatsData>.empty(growable: true).obs;
  RxInt prefSelectedDateId = 0.obs;
  RxBool isDateFormatUpdate = false.obs;

  @override
  Future<void> onInit() async {
    Get.lazyPut(() => SettingRepository(), fenix: true);
    bizId = await Get.find<LocalStorage>().getStringFromStorage(kStorageBizId);
    dateFormatsList.add(
      DateFormatsData(
          isSelected: false, dateFormat: 'yyyy-MM-dd', dateFormatId: 1),
    );
    dateFormatsList.add(
      DateFormatsData(
          isSelected: false, dateFormat: 'dd/MM/yyyy', dateFormatId: 2),
    );
    dateFormatsList.add(
      DateFormatsData(
          isSelected: false, dateFormat: 'yyyy-MM-dd hh:mm', dateFormatId: 3),
    );
    dateFormatsList.add(
      DateFormatsData(isSelected: false, dateFormat: 'yMMMEd', dateFormatId: 4),
    );
    super.onInit();
  }

  void updateSelectedDateFormat({required int index}) {
    int i = dateFormatsList.indexWhere((element) => element.isSelected == true);
    if (i != -1 && i != index) {
      dateFormatsList[i].isSelected = false;
    }
    dateFormatsList[index].isSelected =
        !(dateFormatsList[index].isSelected ?? false);
    dateFormatsList.refresh();
    int j = dateFormatsList.indexWhere((element) => element.isSelected == true);
    if (j != -1) {
      prefSelectedDateId.value = dateFormatsList[j].dateFormatId ?? 0;
      isDateFormatUpdate.value = true;
    } else {
      isDateFormatUpdate.value = false;
    }
  }

  String returnFormattedDates({required String dateFormat}) {
    String dateTimeFormat = '';

    dateTimeFormat = DateFormat(dateFormat).format(DateTime.now());
    return dateTimeFormat;
  }

  Future<void> updatePref() async {
    try {
      var requestModel = UpdatePreferenceData(
        bizId: int.parse(bizId),
        invoiceFormatId: prefSelectedDateId.value,
      );
      var response = await Get.find<SettingRepository>()
          .updatePref(requestModel: requestModel);
      if (response != null) {
        if (response.statusCode == successStatusCode) {
          Get.back(result: true);
        } else {
          Get.find<AlertMessageUtils>().showErrorSnackBar(response.msg ?? '');
        }
      }
    } catch (e) {
      LoggerUtils.logException('updatePref', e);
    }
  }
}
