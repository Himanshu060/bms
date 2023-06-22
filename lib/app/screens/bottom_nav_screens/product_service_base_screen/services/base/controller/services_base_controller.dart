import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/local_storage_constants.dart';
import 'package:bms/app/common/model/filters.dart';
import 'package:bms/app/common/route_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/services/base/model/response/get_all_services_response_model.dart';
import 'package:bms/app/screens/bottom_navigation/base/controller/bottom_nav_base_controller.dart';
import 'package:bms/app/screens/bottom_navigation/base/model/response/drop_down_common_data.dart';
import 'package:bms/app/services/repository/service_repository.dart';
import 'package:bms/app/utils/alert_message_utils.dart';
import 'package:bms/app/utils/decode_response_data/decode_response_data.dart';
import 'package:bms/app/utils/local_storage.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:get/get.dart';

class ServicesBaseController extends GetxController {
  // RxInt pageNumber = 0.obs;
  String bizId = '';
  RxBool isServiceDataLoading = true.obs;
  RxList<AllServicesData> allServicesDataList =
      List<AllServicesData>.empty(growable: true).obs;
  RxList<AllServicesData> appliedFilterServiceDataList =
      List<AllServicesData>.empty(growable: true).obs;
  RxList<AllServicesData> searchServiceDataList =
      List<AllServicesData>.empty(growable: true).obs;

  RxString searchServiceName = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    Get.lazyPut(() => ServiceRepository(), fenix: true);
    bizId = await Get.find<LocalStorage>().getStringFromStorage(kStorageBizId);
    await getAllServicesListFromServer();
    Get.find<BottomNavBaseController>().tabIndex.listen((p0) {
      if (p0 == 1) {
        allServicesDataList.clear();
        appliedFilterServiceDataList.clear();
        getAllServicesListFromServer();
      }
    });
  }

  /// get all services list from server
  Future<void> getAllServicesListFromServer() async {
    isServiceDataLoading.value = true;
    try {
      allServicesDataList.clear();
      appliedFilterServiceDataList.clear();
      var response =
          await Get.find<ServiceRepository>().getAllServicesDataFromServer(
        bizId: bizId,
        pageNumber: '-1',
        // pageNumber: pageNumber.toString(),
      );

      if (response != null) {
        if (response.statusCode == 100) {
          var res = decodeResponseData(responseData: response.data ?? '');
          if (res != null && res != '') {
            var tempList = allServicesDataFromJson(res);
            allServicesDataList.addAll(tempList);
            appliedFilterServiceDataList.addAll(tempList);
          }
        } else {
          Get.find<AlertMessageUtils>().showErrorSnackBar(response.msg ?? '');
        }
      }
      isServiceDataLoading.value = false;
    } catch (e) {
      isServiceDataLoading.value = false;
      LoggerUtils.logException('getAllProductsListFromServer', e);
    }
  }


  String returnUnitName({required int index}) {
    String unitName = '';

    for (DropdownCommonData unit in appUnitList) {
      if (appliedFilterServiceDataList[index].unitId == unit.id) {
        unitName = unit.name ?? '';
        return unitName;
      }
    }
    return unitName;
  }

  String returnCategoryName({required int index}) {
    String catName = '';

    for (DropdownCommonData catData in appCategoryList) {
      if (appliedFilterServiceDataList[index].categoryId == catData.id) {
        catName = catData.name ?? '';
        return catName;
      }
    }

    return catName;
  }

  Future<void> navigateToServiceDetailsScreen({required int index}) async {
    bool isUpdate = await Get.toNamed(kRouteEditServiceScreen,
        arguments: [allServicesDataList[index].serviceId]);
    if (isUpdate) {
      allServicesDataList.clear();
      appliedFilterServiceDataList.clear();
      getAllServicesListFromServer();
    }
  }

  /// onChange service search value
  void onSearchValueChange({required String searchProductValue}) {
    try {
      searchServiceDataList.clear();
      searchServiceName.value = searchProductValue;
      if (searchServiceName.value.isNotEmpty) {
        for (var productData in allServicesDataList) {
          if ((productData.name ?? '')
              .toLowerCase()
              .contains(searchProductValue.toLowerCase())) {
            searchServiceDataList.add(productData);
          }
        }
      }
      searchServiceDataList.refresh();
    } catch (e) {
      LoggerUtils.logException('onSearchValueChange', e);
    }
  }

  void applyFilter(
      {required List<Filters> itemsFilter,
      required List<Filters> itemsFilter2}) {
    String appliedFilter = '';

    int j = itemsFilter2.indexWhere((element) => element.isSelected == true);
    List<AllServicesData> tempServiceList = [];

    if (j != -1) {
      tempServiceList.addAll(allServicesDataList);
      // tempServiceList.addAll(appliedFilterServiceDataList);
      appliedFilterServiceDataList.clear();
    }
    for (var filterData in itemsFilter2) {
      if (filterData.isSelected == true) {
        for (var productData in tempServiceList) {
          if (productData.categoryId == filterData.filterId) {
            appliedFilterServiceDataList.add(productData);
          }
        }
      }
    }
    appliedFilterServiceDataList.refresh();

    int i = itemsFilter.indexWhere((element) => element.isSelected == true);
    if (i != -1) {
      if (j != -1) {
        tempServiceList.clear();
        tempServiceList.addAll(appliedFilterServiceDataList);
        appliedFilterServiceDataList.clear();
        appliedFilterServiceDataList.addAll(tempServiceList);
      } else {
        appliedFilterServiceDataList.clear();
        appliedFilterServiceDataList.addAll(allServicesDataList);
      }
      appliedFilter = itemsFilter[i].sortName;
      // }

      if (appliedFilter == kAToZ) {
        appliedFilterServiceDataList.sort((a, b) =>
            ((a.name ?? '').toLowerCase())
                .compareTo((b.name ?? '').toLowerCase()));
        appliedFilterServiceDataList.refresh();
      } else if (appliedFilter == kZToA) {
        appliedFilterServiceDataList.sort((a, b) =>
            ((b.name ?? '').toLowerCase())
                .compareTo((a.name ?? '').toLowerCase()));
        appliedFilterServiceDataList.refresh();
      }
    }

    appliedFilterServiceDataList.refresh();
    Get.back();
  }

  void clearAppliedFilter() {
    appliedFilterServiceDataList.clear();
    appliedFilterServiceDataList.addAll(allServicesDataList);
  }
}
