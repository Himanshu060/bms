import 'package:bms/app/common/model/common_response_model.dart';
import 'package:bms/app/screens/authentication/business_sign_up/model/request/business_sign_up_request_model.dart';
import 'package:bms/app/screens/authentication/user_sign_up/model/request/user_sign_up_request_model.dart';
import 'package:bms/app/services/api_services/api_constants.dart';
import 'package:bms/app/services/api_services/api_services.dart';
import 'package:bms/app/utils/alert_message_utils.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:get/get.dart';

class RegistrationRepository {
  /// user sign up api call
  Future<CommonResponseModel?> userSignUpApi(
      {required UserSignUpRequestModel requestModel}) async {
    try {
      final response = await ApiServices().postRequestWithOutHeader(
        endPoint: ApiConstants.registerUser,
        requestModel: userSignUpRequestModelToJson(requestModel),
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
      LoggerUtils.logException('userSignUpApi', e);
    }
    return null;
  }

  /// business registration api call
  Future<CommonResponseModel?> businessSignUpApi({
    required BusinessSignUpRequestModel requestModel,
    // required Map<String, String> headers,
  }) async {
    try {
      final response = await ApiServices().postRequest(
        endPoint: ApiConstants.registerBusinessDetails,
        requestModel: businessSignUpRequestModelToJson(requestModel),
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
      LoggerUtils.logException('businessSignUpApi', e);
    }
    return null;
  }

  /// update business details api call
  Future<CommonResponseModel?> updateBusinessDetailsApi({
    required BusinessSignUpRequestModel requestModel,
    // required Map<String, String> headers,
  }) async {
    try {
      final response = await ApiServices().postRequest(
        endPoint: ApiConstants.updateBusinessDetails,
        requestModel: businessSignUpRequestModelToJson(requestModel),
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
      LoggerUtils.logException('updateBusinessDetailsApi', e);
    }
    return null;
  }
}
