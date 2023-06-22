import 'package:bms/app/common/model/common_response_model.dart';
import 'package:bms/app/common/model/craete_new_category_request_model.dart';
import 'package:bms/app/services/api_services/api_constants.dart';
import 'package:bms/app/services/api_services/api_services.dart';
import 'package:bms/app/utils/alert_message_utils.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:get/get.dart';

class MasterRepository {
  /// get state,gstRate,units api
  Future<CommonResponseModel?> getMasterApiData(
      {required String apiEndPoint,bool isShowLoader =  false}) async {
    try {
      final response = await ApiServices()
          .getRequest(endPoint: apiEndPoint, isShowLoader: isShowLoader);

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
      LoggerUtils.logException('getMasterApiData', e);
    }
    return null;
  }

  /// get cities api
  Future<CommonResponseModel?> getCitiesMasterApiData(
      {required String stateId}) async {
    try {
      final response = await ApiServices().getRequest(
          endPoint: ApiConstants.getCities + '/$stateId', isShowLoader: true);

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
      LoggerUtils.logException('getCitiesMasterApiData', e);
    }
    return null;
  }

  /// get categories api
  Future<CommonResponseModel?> getCategoriesMasterApiData(
      {required String bizId}) async {
    try {
      final response = await ApiServices().getRequest(
          endPoint: ApiConstants.getCategories + '/$bizId',
          isShowLoader: false);

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
      LoggerUtils.logException('getCategoriesMasterApiData', e);
    }
    return null;
  }

  /// create new category api
  Future<CommonResponseModel?> createCategoryMasterApiData(
      {required CreateNewCategoryRequestModel requestMode}) async {
    try {
      final response = await ApiServices().postRequest(
        endPoint: ApiConstants.getCategories,
        requestModel: createNewCategoryRequestModelToJson(requestMode),
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
      LoggerUtils.logException('createCategoryMasterApiData', e);
    }
    return null;
  }

  /// get business plans api
  Future<CommonResponseModel?> getBusinessPlansApi(
      {required String bizId}) async {
    try {
      final response = await ApiServices().getRequest(
          endPoint: ApiConstants.getBusinessPlans + '/$bizId',
          isShowLoader: false);

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
      LoggerUtils.logException('getBusinessPlansApi', e);
    }
    return null;
  }
}
