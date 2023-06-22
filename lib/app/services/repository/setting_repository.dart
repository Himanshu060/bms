import 'package:bms/app/common/model/common_response_model.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/change_password/model/request/change_password_request_model.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/preference/base/model/request/update_pref_data.dart';
import 'package:bms/app/services/api_services/api_constants.dart';
import 'package:bms/app/services/api_services/api_services.dart';
import 'package:bms/app/utils/alert_message_utils.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:get/get.dart';

class SettingRepository {
  /// get all products list data from server
  Future<CommonResponseModel?> getBusinessDetails(
      {required String bizId}) async {
    try {
      final response = await ApiServices().getRequest(
        endPoint: ApiConstants.getBusinessDetails + '/$bizId',
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
      LoggerUtils.logException('getBusinessDetails', e);
    }
    return null;
  }

  /// change password api call
  Future<CommonResponseModel?> changePasswordApiCall(
      {required ChangePasswordRequestModel requestModel}) async {
    try {
      final response = await ApiServices().postRequest(
        endPoint: ApiConstants.changePassword,
        requestModel: changePasswordRequestModelToJson(requestModel),
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
      LoggerUtils.logException('changePasswordApiCall', e);
    }
    return null;
  }

  /// get invoice formats api call
  Future<CommonResponseModel?> getPreferences({required String bizId}) async {
    try {
      final response = await ApiServices().getRequest(
        endPoint: ApiConstants.getPref + '/$bizId',
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
      LoggerUtils.logException('getPreferences', e);
    }
    return null;
  }

  /// get invoice formats api call
  Future<CommonResponseModel?> getInvoiceFormats(
      {required String bizId}) async {
    try {
      final response = await ApiServices().getRequest(
        endPoint: ApiConstants.invoiceFormats + '/$bizId',
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
      LoggerUtils.logException('getInvoiceFormats', e);
    }
    return null;
  }

  /// update pref api call
  Future<CommonResponseModel?> updatePref(
      {required UpdatePreferenceData requestModel}) async {
    try {
      final response = await ApiServices().postRequest(
        endPoint: ApiConstants.getPref,
        requestModel: updatePreferenceDataToJson(requestModel),
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
      LoggerUtils.logException('updatePref', e);
    }
    return null;
  }
}
