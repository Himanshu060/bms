import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/preference/invoice_format/base/model/response/invoice_format_data.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:get/get.dart';

class ViewInvFormatController extends GetxController {
  Rx<InvoiceFormatData> invFormatData = InvoiceFormatData().obs;

  void setIntentData({required dynamic intentData}) {
    try {
      invFormatData.value = (intentData[0] as InvoiceFormatData);
    } catch (e) {
      LoggerUtils.logException('setIntentData', e);
    }
  }
}
