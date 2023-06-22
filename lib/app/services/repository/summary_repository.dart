import 'package:bms/app/common/model/common_response_model.dart';
import 'package:bms/app/services/api_services/api_constants.dart';
import 'package:bms/app/services/api_services/api_services.dart';
import 'package:bms/app/utils/alert_message_utils.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:get/get.dart';

class SummaryRepository {
  /// get customer summary details api call
  Future<CommonResponseModel?> getServiceDetailsApi(
      {required String bizId, required String custId}) async {
    try {
      final response = await ApiServices().getRequest(
        endPoint: ApiConstants.getCustomerSummaryDetails + '/$bizId/$custId',
      );

      if (response != null) {
        var responseModel = commonResponseModelFromJson(response.body);
        if (response.statusCode == 200) {
          return responseModel;
        } else {
          Get.find<AlertMessageUtils>()
              .showErrorSnackBar(responseModel.msg ?? "");
        }
      }
    } catch (e) {
      LoggerUtils.logException('getServiceDetailsApi', e);
    }
    return null;
  }
}
