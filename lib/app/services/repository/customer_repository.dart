import 'package:bms/app/common/model/common_response_model.dart';
import 'package:bms/app/screens/bottom_nav_screens/customer_base_screen/add_customer/model/request/add_customer_request_modell.dart';
import 'package:bms/app/screens/bottom_nav_screens/customer_base_screen/add_customer/model/request/update_customer_request_model.dart';
import 'package:bms/app/services/api_services/api_constants.dart';
import 'package:bms/app/services/api_services/api_services.dart';
import 'package:bms/app/utils/alert_message_utils.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:get/get.dart';

class CustomerRepository {
  /// get all customer list from server
  Future<CommonResponseModel?> getAllCustomerList({
    required String bizId,
    required String pageNumber,
    // required Map<String, String> headers,
  }) async {
    try {
      final response = await ApiServices().getRequest(
        endPoint: ApiConstants.getAllCustomerList + '/$bizId/$pageNumber',
        // headers: headers,
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
      LoggerUtils.logException('getAllCustomerList', e);
    }
    return null;
  }

  /// get all customer list from server
  Future<CommonResponseModel?> addCustomer({
    required AddCustomerRequestModel requestModel,
    // required Map<String, String> headers,
  }) async {
    try {
      final response = await ApiServices().postRequest(
        endPoint: ApiConstants.addCustomer,
        requestModel: addCustomerRequestModelToJson(requestModel),
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
      LoggerUtils.logException('getAllCustomerList', e);
    }
    return null;
  }

  /// get all customer list from server
  Future<CommonResponseModel?> getCustomer({
    required bizId,
    required customerId,
    // required Map<String, String> headers,
  }) async {
    try {
      final response = await ApiServices().getRequest(
        endPoint: ApiConstants.getCustomerDetails + '/$bizId/$customerId',
        // headers: headers,
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
      LoggerUtils.logException('getAllCustomerList', e);
    }
    return null;
  }

  /// get all customer list from server
  Future<CommonResponseModel?> updateCustomer({
    required UpdateCustomerRequestModel requestModel,
    // required Map<String, String> headers,
  }) async {
    try {
      final response = await ApiServices().postRequest(
        endPoint: ApiConstants.updateCustomer,
        requestModel: updateCustomerRequestModelToJson(requestModel),
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
      LoggerUtils.logException('getAllCustomerList', e);
    }
    return null;
  }

  /// delete customer api call
  Future<CommonResponseModel?> deleteCustomer({
    required bizId,
    required customerId,
  }) async {
    try {
      final response = await ApiServices().deleteRequest(
        endPoint: ApiConstants.deleteCustomer + '/$bizId/$customerId',
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
      LoggerUtils.logException('deleteCustomer', e);
    }
    return null;
  }
}
