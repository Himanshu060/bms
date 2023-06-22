import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/common_header.dart';
import 'package:bms/app/services/api_services/api_constants.dart';
import 'package:bms/app/utils/alert_message_utils.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:bms/app/widgets/buttons/primary_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApiServices extends GetConnect {
  // final http.Client _client = InterceptedClient;

  Future<http.Response?> postRequestWithOutHeader({
    required String endPoint,
    dynamic requestModel,
    bool isShowLoader = true,
  }) async {
    if (await checkUserConnection()) {
      debugPrint("REQUEST MODEL :: $requestModel");

      // Map<String, String>? headers = {};
      if (isShowLoader) {
        Get.find<AlertMessageUtils>().showProgressDialog();
      }

      var headers = {'Content-Type': 'application/json'};

      var domainUrl = ApiConstants.baseUrl;

      var url = Uri.parse('$domainUrl$endPoint');

      debugPrint('url : $url');
      try {
        var response =
            await http.post(url, body: requestModel, headers: headers);
        debugPrint('response :  ${response.body}');
        return response;
      } catch (e) {
        LoggerUtils.logException('postRequest', e);
      } finally {
        if (isShowLoader) {
          Get.find<AlertMessageUtils>().hideProgressDialog();
        }
      }
    }else {
      showInternetConnectivityDialog();
      return null;
    }
    return null;
  }

  Future<http.Response?> postRequest({
    required String endPoint,
    dynamic requestModel,
    bool isShowLoader = true,
    // Map<String, String>? headers,
  }) async {
    if (await checkUserConnection()) {
    debugPrint("REQUEST MODEL :: $requestModel");

    // Map<String, String>? headers = {};
    if (isShowLoader) {
      Get.find<AlertMessageUtils>().showProgressDialog();
    }

    // headers ??= {'Content-Type': 'application/json'};
    var headers = await CommonHeader().headers();

    var domainUrl = ApiConstants.baseUrl;

    var url = Uri.parse('$domainUrl$endPoint');

    debugPrint('url : $url');
    try {
      var response = await http.post(url, body: requestModel, headers: headers);
      debugPrint('response :  ${response.body}');
      return response;
    } catch (e) {
      LoggerUtils.logException('postRequest', e);
    } finally {
      if (isShowLoader) {
        Get.find<AlertMessageUtils>().hideProgressDialog();
      }
    }}else {
      showInternetConnectivityDialog();
      return null;
    }
    return null;
  }

  Future<http.Response?> getRequest({
    required String endPoint,
    Map<String, dynamic>? params,
    bool isShowLoader = true,
    // Map<String, String>? headers,
  }) async {
    if (await checkUserConnection()) {
      debugPrint("REQUEST MODEL :: $params");

      // Map<String, String>? headers = {};
      if (isShowLoader) {
        Get.find<AlertMessageUtils>().showProgressDialog();
      }

      // headers ??= {'Content-Type': 'application/json'};
      var headers = await CommonHeader().headers();
      var domainUrl = ApiConstants.baseUrl;

      var url = Uri.parse('$domainUrl$endPoint');

      debugPrint('getRequest : $url');
      try {
        var response = await http.get(url, headers: headers);
        debugPrint('response :  ${response.body}');
        return response;
      } catch (e) {
        LoggerUtils.logException('getRequest', e);
      } finally {
        if (isShowLoader) {
          Get.find<AlertMessageUtils>().hideProgressDialog();
        }
      }
    } else {
      showInternetConnectivityDialog();
      return null;
    }
    return null;
  }

  Future<http.Response?> deleteRequest({
    required String endPoint,
    dynamic requestModel,
    Map<String, dynamic>? params,
    bool isShowLoader = true,
    // Map<String, String>? headers,
  }) async {
    if (await checkUserConnection()) {
    debugPrint("REQUEST MODEL :: $requestModel");

    // Map<String, String>? headers = {};
    if (isShowLoader) {
      Get.find<AlertMessageUtils>().showProgressDialog();
    }

    var headers = await CommonHeader().headers();
    var domainUrl = ApiConstants.baseUrl;

    var url = Uri.parse('$domainUrl$endPoint');

    debugPrint('deleteRequest : $url');
    try {
      var response =
          await http.delete(url, headers: headers, body: requestModel);
      debugPrint('response :  ${response.body}');
      return response;
    } catch (e) {
      LoggerUtils.logException('deleteRequest', e);
    } finally {
      if (isShowLoader) {
        Get.find<AlertMessageUtils>().hideProgressDialog();
      }
    }}else {
      showInternetConnectivityDialog();
      return null;
    }
    return null;
  }

  /// check user internet connection
  Future<bool> checkUserConnection() async {
    try {
      final ConnectivityResult result =
          await Connectivity().checkConnectivity();

      if (result == ConnectivityResult.wifi) {
        return true;
      } else if (result == ConnectivityResult.mobile) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      LoggerUtils.logException('checkUserConnection', e);
    }
    return false;
  }

  void showInternetConnectivityDialog() {
    showDialog(
        context: Get.overlayContext!,
        builder: (context) {
          return Dialog(
            child: SizedBox(
              height: 100,
              child: Column(
                children: [
                  Text(kUserConnectivity),
                  PrimaryButtonWidget(onPressed: (){
                    Get.back();
                  }, color:kColorPrimary, buttonTitle:kLabelOkay)
                ],
              ),
            ),
          );
        }
    );
  }
}
