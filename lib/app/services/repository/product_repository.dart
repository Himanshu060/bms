import 'package:bms/app/common/model/common_response_model.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/products/add_product/model/request/add_product_request_model.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/products/base/model/request/add_service_request_model.dart';
import 'package:bms/app/services/api_services/api_constants.dart';
import 'package:bms/app/services/api_services/api_services.dart';
import 'package:bms/app/utils/alert_message_utils.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:get/get.dart';

class ProductRepository {
  /// get all products list data from server
  Future<CommonResponseModel?> getAllProductsDataFromServer(
      {required String bizId, required String pageNumber}) async {
    try {
      final response = await ApiServices().getRequest(
        endPoint: ApiConstants.getAllProducts + '/$bizId/$pageNumber',
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

  /// add products api call
  Future<CommonResponseModel?> addProductApi(
      {required AddProductRequestModel requestModel}) async {
    try {
      final response = await ApiServices().postRequest(
        endPoint: ApiConstants.addProducts,
        requestModel: addProductRequestModelToJson(requestModel),
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
      LoggerUtils.logException('addProductApi', e);
    }
    return null;
  }

  /// update products api call
  Future<CommonResponseModel?> updateProductApi(
      {required AddProductRequestModel requestModel}) async {
    try {
      final response = await ApiServices().postRequest(
        endPoint: ApiConstants.updateProducts,
        requestModel: addProductRequestModelToJson(requestModel),
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
      LoggerUtils.logException('updateProductApi', e);
    }
    return null;
  }

  /// get product details api call
  Future<CommonResponseModel?> getProductDetailsApi(
      {required String bizId, required String productId}) async {
    try {
      final response = await ApiServices().getRequest(
        endPoint: ApiConstants.getProductDetails + '/$bizId/$productId',
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
      LoggerUtils.logException('getProductDetailsApi', e);
    }
    return null;
  }

  /// add service api call
  Future<CommonResponseModel?> addServiceApi(
      {required AddServiceRequestModel requestModel}) async {
    try {
      final response = await ApiServices().postRequest(
        endPoint: ApiConstants.addServices,
        requestModel: addServiceRequestModelToJson(requestModel),
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
      LoggerUtils.logException('addServiceApi', e);
    }
    return null;
  }

  /// update service api call
  Future<CommonResponseModel?> updateServiceApi(
      {required AddServiceRequestModel requestModel}) async {
    try {
      final response = await ApiServices().postRequest(
        endPoint: ApiConstants.updateServices,
        requestModel: addServiceRequestModelToJson(requestModel),
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
      LoggerUtils.logException('addServiceApi', e);
    }
    return null;
  }

  /// get service details api call
  Future<CommonResponseModel?> getServiceDetailsApi(
      {required String bizId, required String serviceId}) async {
    try {
      final response = await ApiServices().getRequest(
        endPoint: ApiConstants.getServicesDetails + '/$bizId/$serviceId',
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
      LoggerUtils.logException('addProductApi', e);
    }
    return null;
  }

  /// delete service api call
  Future<CommonResponseModel?> deleteService({
    required bizId,
    required serviceId,
  }) async {
    try {
      final response = await ApiServices().deleteRequest(
        endPoint: ApiConstants.deleteServices + '/$bizId/$serviceId',
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
      LoggerUtils.logException('deleteService', e);
    }
    return null;
  }

  /// delete product api call
  Future<CommonResponseModel?> deleteProduct({
    required bizId,
    required productId,
  }) async {
    try {
      final response = await ApiServices().deleteRequest(
        endPoint: ApiConstants.deleteProducts + '/$bizId/$productId',
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
      LoggerUtils.logException('deleteProduct', e);
    }
    return null;
  }
}
