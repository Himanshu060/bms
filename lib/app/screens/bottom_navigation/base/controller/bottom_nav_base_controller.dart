import 'dart:convert';

import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/local_storage_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/base/view/settings_base_screen.dart';
import 'package:bms/app/screens/bottom_navigation/base/model/response/business_plans_data.dart';
import 'package:bms/app/screens/bottom_navigation/base/model/response/drop_down_common_data.dart';
import 'package:bms/app/services/api_services/api_constants.dart';
import 'package:bms/app/services/repository/master_repository.dart';
import 'package:bms/app/utils/decode_response_data/decode_response_data.dart';
import 'package:bms/app/utils/local_storage.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:get/get.dart';
import 'package:bms/app/screens/bottom_nav_screens/customer_base_screen/base/view/customer_base_screen.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/base/view/invoice_base_screen.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/base/view/product_service_base_screen.dart';


class BottomNavBaseController extends GetxController {
  RxInt tabIndex = 0.obs;
  String bizId = '';

  final pages = [
    CustomerBaseScreen(),
    ProductServiceBaseScreen(),
    InvoiceBaseScreen(),
    SettingsBaseScreen(),
  ];

  static RxList<DropdownCommonData> gstRateList =
      List<DropdownCommonData>.empty(growable: true).obs;
  static RxList<DropdownCommonData> unitList =
      List<DropdownCommonData>.empty(growable: true).obs;

  Rx<BusinessPlansData> businessPlansData = BusinessPlansData().obs;

  // static RxList<DropdownCommonData> categoryList =
  //     List<DropdownCommonData>.empty(growable: true).obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    Get.lazyPut(() => MasterRepository(), fenix: true);
    bizId = await Get.find<LocalStorage>().getStringFromStorage(kStorageBizId);
    getGstRateFromServer();
    getUnitsFromServer();
    getCategoriesFromServer();
    getBusinessPlansDataFromServer();
  }

  /// change tab index based on selected tab
  void changeTabIndex(int index) {
    tabIndex.value = index;
    // tabIndex.refresh();
  }

  /// get gst rate data from server
  Future<void> getGstRateFromServer() async {
    try {
      var response = await Get.find<MasterRepository>()
          .getMasterApiData(apiEndPoint: ApiConstants.getGstRates);
      if (response != null && response.statusCode == 100) {
        var res = decodeResponseData(responseData: response.data ?? '');
        if (res != null && res != '') {
          var tempList = dropdownCommonDataFromJson(res);
          gstRateList.addAll(tempList);
          Get.find<LocalStorage>().writeStringStorage(kStorageGstRateList, res);
          // gstRateList.insert(
          //     0, DropdownCommonData(id: 0, name: kLabelGSTRate, value: 0, subId: 0));
        }
      }
    } catch (e) {
      LoggerUtils.logException('getGstRateFromServer', e);
    }
  }

  /// get units rate data from server
  Future<void> getUnitsFromServer() async {
    appUnitList.clear();
    try {
      var response = await Get.find<MasterRepository>()
          .getMasterApiData(apiEndPoint: ApiConstants.getUnits);
      if (response != null && response.statusCode == 100) {
        var res = decodeResponseData(responseData: response.data ?? '');
        if (res != null && res != '') {
          var tempList = dropdownCommonDataFromJson(res);
          appUnitList.addAll(tempList);
          Get.find<LocalStorage>().writeStringStorage(kStorageUnitList, res);
        }
      }
    } catch (e) {
      LoggerUtils.logException('getGstRateFromServer', e);
    }
  }

  /// get categories data from server
  Future<void> getCategoriesFromServer() async {
    appCategoryList.clear();
    try {
      var response = await Get.find<MasterRepository>()
          .getCategoriesMasterApiData(bizId: bizId);
      if (response != null && response.statusCode == 100) {
        var res = decodeResponseData(responseData: response.data ?? '');
        if (res != null && res != '') {
          var tempList = dropdownCommonDataFromJson(res);
          appCategoryList.addAll(tempList);
          Get.find<LocalStorage>()
              .writeStringStorage(kStorageCategoryList, res);
        }
      }
    } catch (e) {
      LoggerUtils.logException('getGstRateFromServer', e);
    }
  }

  /// get business plan data from server
  Future<void> getBusinessPlansDataFromServer() async {
    try {
      var response =
          await Get.find<MasterRepository>().getBusinessPlansApi(bizId: bizId);
      if (response != null && response.statusCode == 100) {
        var res = decodeResponseData(responseData: response.data ?? '');
        if (res != null && res != '') {
          businessPlansData.value = businessPlansDataFromJson(res);
          Get.find<LocalStorage>().writeBoolStorage(kStorageIsSellPriceEditable,
              businessPlansData.value.editableSellPrice ?? false);
        }
      }
    } catch (e) {
      LoggerUtils.logException('getBusinessPlansDataFromServer', e);
    }
  }
}
