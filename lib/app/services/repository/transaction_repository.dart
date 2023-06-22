import 'package:bms/app/common/model/common_response_model.dart';
import 'package:bms/app/services/api_services/api_constants.dart';
import 'package:bms/app/services/api_services/api_services.dart';
import 'package:bms/app/utils/alert_message_utils.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:get/get.dart';

class TransactionRepository{

  /// get all services list data from server
  Future<CommonResponseModel?> getAllTransactionDataFromServer(
      {required String bizId, required String pageNumber}) async {
    try {
      final response = await ApiServices().getRequest(
        endPoint: ApiConstants.getTrans + '/$bizId/$pageNumber',
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
      LoggerUtils.logException('getAllProductsDataFromServer', e);
    }
    return null;
  }
}