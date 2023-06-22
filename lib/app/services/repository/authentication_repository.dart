import 'package:bms/app/common/model/common_response_model.dart';
import 'package:bms/app/common/model/firebase_auth_model.dart';
import 'package:bms/app/screens/authentication/forgot_password/model/request/check_user_exist_request_model.dart';
import 'package:bms/app/screens/authentication/forgot_password/model/request/forgot_password_request_model.dart';
import 'package:bms/app/screens/authentication/login/model/request/login_request_model.dart';
import 'package:bms/app/services/api_services/api_constants.dart';
import 'package:bms/app/services/api_services/api_services.dart';
import 'package:bms/app/services/firebase_services/firebase_auth_service.dart';
import 'package:bms/app/utils/alert_message_utils.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:get/get.dart';

class AuthenticationRepository {
  late FirebaseAuthService _mService;
  static final AuthenticationRepository _singleton =
      AuthenticationRepository._internal();

  AuthenticationRepository._internal();

  factory AuthenticationRepository() {
    _singleton._mService = FirebaseAuthService();
    return _singleton;
  }

  /// Send otp to entered mobile number
  Future<FirebaseAuthenticationModel?> sendOtpOnUserMobileFCM(
      {required String phoneNumber}) {
    return _singleton._mService.sendOtpToMobileNumber(phoneNumber: phoneNumber);
  }

  /// Verify user otp manually entered
  Future<FirebaseAuthenticationModel> verifyUserReceivedOtpFCM(
      String otp) async {
    return await _singleton._mService.verifyUserOtp(otp);
  }

  /// login api call
  Future<CommonResponseModel?> loginApiCall(
      {required LoginRequestModel requestModel}) async {
    try {
      final response = await ApiServices().postRequestWithOutHeader(
        endPoint: ApiConstants.login,
        requestModel: loginRequestModelToJson(requestModel),
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
      LoggerUtils.logException('loginApiCall', e);
    }
    return null;
  }

  /// check user exist api call
  Future<CommonResponseModel?> checkUserExistApiCall(
      {required CheckUserExistRequestModel requestModel}) async {
    try {
      final response = await ApiServices().postRequestWithOutHeader(
        endPoint: ApiConstants.checkUserExits,
        requestModel: checkUserExistRequestModelToJson(requestModel),
        isShowLoader: true,
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
      LoggerUtils.logException('checkUserExistApiCall', e);
    }
    return null;
  }

  /// forgot password api call
  Future<CommonResponseModel?> forgotPasswordApiCall(
      {required ForgotPasswordRequestModel requestModel}) async {
    try {
      final response = await ApiServices().postRequestWithOutHeader(
        endPoint: ApiConstants.forgotPassword,
        requestModel: forgotPasswordRequestModelToJson(requestModel),
        isShowLoader: true,
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
      LoggerUtils.logException('forgotPasswordApiCall', e);
    }
    return null;
  }
}
