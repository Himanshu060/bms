import 'package:bms/app/common/local_storage_constants.dart';
import 'package:bms/app/common/route_constants.dart';
import 'package:bms/app/common/status_codes.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/preference/base/model/request/update_pref_data.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/preference/invoice_format/base/model/response/invoice_format_data.dart';

import 'package:bms/app/services/repository/setting_repository.dart';
import 'package:bms/app/utils/alert_message_utils.dart';
import 'package:bms/app/utils/decode_response_data/decode_response_data.dart';
import 'package:bms/app/utils/local_storage.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:get/get.dart';

class InvoiceFormatsController extends GetxController {
  String bizId = '';
  RxInt prefSelectedInvId = 0.obs;
  RxBool isInvFormatUpdate = false.obs;

  RxList<InvoiceFormatData> invFormatsList =
      List<InvoiceFormatData>.empty(growable: true).obs;

  @override
  void onInit() {
    Get.lazyPut(() => SettingRepository(), fenix: true);
    super.onInit();
  }

  void setIntentData({required dynamic intentData}) async {
    try {
      bizId =
          await Get.find<LocalStorage>().getStringFromStorage(kStorageBizId);
      invFormatsList.clear();
      await getInvoiceFormatsFromServer();
      prefSelectedInvId.value = (intentData[0] as int);

      if (prefSelectedInvId.value != 0) {
        int i = invFormatsList.indexWhere(
            (element) => element.invFormatId == prefSelectedInvId.value);
        if (i != -1) {
          invFormatsList[i].isSelected = true;
        }
      }
    } catch (e) {
      LoggerUtils.logException('setIntentData', e);
    }
  }

  Future<void> getInvoiceFormatsFromServer() async {
    try {
      var response =
          await Get.find<SettingRepository>().getInvoiceFormats(bizId: bizId);
      if (response != null) {
        if (response.statusCode == 100) {
          var res = decodeResponseData(responseData: response.data ?? '');
          if (res != null && res != '') {
            var tempList = invoiceFormatDataFromJson(res);
            invFormatsList.addAll(tempList);
          }
        } else {
          Get.find<AlertMessageUtils>().showErrorSnackBar(response.msg ?? '');
        }
      }
    } catch (e) {
      LoggerUtils.logException('getInvoiceFormatsFromServer', e);
    }
  }

  void updateSelectedInvFormat({required int index}) {
    int i = invFormatsList.indexWhere((element) => element.isSelected == true);
    if (i != -1 && i != index) {
      invFormatsList[i].isSelected = false;
    }
    invFormatsList[index].isSelected =
        !(invFormatsList[index].isSelected ?? false);
    invFormatsList.refresh();

    int j = invFormatsList.indexWhere((element) => element.isSelected == true);
    if (j != -1) {
      prefSelectedInvId.value = invFormatsList[j].invFormatId ?? 0;
      isInvFormatUpdate.value = true;
    } else {
      isInvFormatUpdate.value = false;
    }
  }

  void navigateToViewInvFormatScreen({required InvoiceFormatData data}) {
    Get.toNamed(kRouteViewInvFormatScreen, arguments: [data]);
  }

  Future<void> updatePref() async {
    try {
      var requestModel = UpdatePreferenceData(
        bizId: int.parse(bizId),
        invoiceFormatId: prefSelectedInvId.value,
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
