import 'package:bms/app/common/model/common_response_model.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/base/model/response/donwload_pdf_response_model.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/generate_invoice/model/response/generate_invoice_request_model.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/pay_in/model/request/cancel_pay_in_request_model.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/pay_in/model/request/offline_pay_in_request_model.dart';
import 'package:bms/app/services/api_services/api_constants.dart';
import 'package:bms/app/services/api_services/api_services.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:get/get.dart';

import '../../utils/alert_message_utils.dart';

class InvoiceRepository {
  /// get invoice details api call
  Future<CommonResponseModel?> getInvoiceDetailsApi(
      {required String bizId, required int invoiceId}) async {
    try {
      final response = await ApiServices().getRequest(
        endPoint: ApiConstants.getInvoiceDetails + '/$bizId/$invoiceId',
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
      LoggerUtils.logException('getInvoiceDetailsDataApi', e);
    }
    return null;
  }

  /// generate invoice api call
  Future<CommonResponseModel?> generateOrUpdateInvoiceApi(
      {required GenerateInvoiceRequestModel requestModel,
      required isForUpdateInvoice}) async {
    try {
      final response = await ApiServices().postRequest(
        endPoint: isForUpdateInvoice
            ? ApiConstants.updateInvoice
            : ApiConstants.generateInvoice,
        requestModel: generateInvoiceRequestModelToJson(requestModel),
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
      LoggerUtils.logException('generateInvoiceApi', e);
    }
    return null;
  }

  /// cancel invoice api call
  Future<CommonResponseModel?> cancelInvoiceApi(
      {required String bizId, required String invoiceId}) async {
    try {
      final response = await ApiServices().deleteRequest(
        endPoint: ApiConstants.cancelInvoice + '/$bizId/$invoiceId',
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
      LoggerUtils.logException('cancelInvoiceApi', e);
    }
    return null;
  }

  /// get pay-in api call
  Future<CommonResponseModel?> getPayInDataApi(
      {required String bizId, required String invoiceId}) async {
    try {
      final response = await ApiServices().getRequest(
        endPoint: ApiConstants.getPayIn + '/$bizId/$invoiceId',
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
      LoggerUtils.logException('getPayInDataApi', e);
    }
    return null;
  }

  /// cancel pay-in api call
  Future<CommonResponseModel?> cancelPayInApi(
      {required CancelPayInRequestModel requestModel}) async {
    try {
      final response = await ApiServices().deleteRequest(
        endPoint: ApiConstants.cancelPayIn,
        requestModel: cancelPayInRequestModelToJson(requestModel),
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
      LoggerUtils.logException('cancelInvoiceApi', e);
    }
    return null;
  }

  /// set pay-in amount api call
  Future<CommonResponseModel?> offlinePayInDataApi(
      {required OfflinePayInRequestModel requestModel}) async {
    try {
      final response = await ApiServices().postRequest(
        endPoint: ApiConstants.offlinePayIn,
        requestModel: offlinePayInRequestModelToJson(requestModel),
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
      LoggerUtils.logException('getPayInDataApi', e);
    }
    return null;
  }

  /// download pdf api call
  Future<CommonResponseModel?> downloadInvoicePDFApi(
      {required String bizId,required String invoiceId}) async {
    try {
      final response = await ApiServices().getRequest(
        endPoint: ApiConstants.downloadInvoice+'/$bizId/$invoiceId',
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
      LoggerUtils.logException('downloadInvoicePDFApi', e);
    }
    return null;
  }
}
