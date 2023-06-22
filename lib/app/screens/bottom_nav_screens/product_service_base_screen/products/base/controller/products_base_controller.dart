import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/local_storage_constants.dart';
import 'package:bms/app/common/model/filters.dart';
import 'package:bms/app/common/route_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/products/base/model/response/all_products_response_model.dart';
import 'package:bms/app/screens/bottom_navigation/base/controller/bottom_nav_base_controller.dart';
import 'package:bms/app/screens/bottom_navigation/base/model/response/drop_down_common_data.dart';
import 'package:bms/app/services/repository/product_repository.dart';
import 'package:bms/app/utils/alert_message_utils.dart';
import 'package:bms/app/utils/decode_response_data/decode_response_data.dart';
import 'package:bms/app/utils/local_storage.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:get/get.dart';

class ProductsBaseController extends GetxController {
  // RxInt pageNumber = 0.obs;
  String bizId = '';
  RxBool isProductDataLoading = true.obs;
  RxList<AllProductsData> allProductsDataList =
      List<AllProductsData>.empty(growable: true).obs;
  RxList<AllProductsData> appliedFilterProductDataList =
      List<AllProductsData>.empty(growable: true).obs;
  RxList<AllProductsData> searchProductDataList =
      List<AllProductsData>.empty(growable: true).obs;
  RxString searchProductName = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    Get.lazyPut(() => ProductRepository(), fenix: true);
    bizId = await Get.find<LocalStorage>().getStringFromStorage(kStorageBizId);
    await getAllProductsListFromServer();
    Get.find<BottomNavBaseController>().tabIndex.listen((p0) {
      if (p0 == 1) {
        allProductsDataList.clear();
        appliedFilterProductDataList.clear();
        getAllProductsListFromServer();
      }
    });
  }

  /// get all products list from server
  Future<void> getAllProductsListFromServer() async {
    isProductDataLoading.value = true;
    try {
      allProductsDataList.clear();
      appliedFilterProductDataList.clear();
      var response =
          await Get.find<ProductRepository>().getAllProductsDataFromServer(
        bizId: bizId,
        pageNumber: '-1',
        // pageNumber: pageNumber.toString(),
      );

      if (response != null) {
        if (response.statusCode == 100) {
          var res = decodeResponseData(responseData: response.data ?? '');
          if (res != null && res != '') {
            var tempList = allProductsDataFromJson(res);
            allProductsDataList.addAll(tempList);
            appliedFilterProductDataList.addAll(tempList);
          }
        } else {
          Get.find<AlertMessageUtils>().showErrorSnackBar(response.msg ?? '');
        }
      }
      isProductDataLoading.value = false;
    } catch (e) {
      isProductDataLoading.value = false;
      LoggerUtils.logException('getAllProductsListFromServer', e);
    }
  }

  String returnUnitName({required int index}) {
    String unitName = '';

    for (DropdownCommonData unit in appUnitList) {
      if (appliedFilterProductDataList[index].unitId == unit.id) {
        unitName = unit.name ?? '';
        return unitName;
      }
    }
    return unitName;
  }

  String returnCategoryName({required int index}) {
    String catName = '';

    for (DropdownCommonData catData in appCategoryList) {
      if (appliedFilterProductDataList[index].categoryId == catData.id) {
        catName = catData.name ?? '';
        return catName;
      }
    }

    return catName;
  }

  Future<void> navigateToEditProductScreen({required int index}) async {
    bool isUpdate = await Get.toNamed(kRouteEditProductScreen,
        arguments: [allProductsDataList[index].productId]);

    if (isUpdate) {
      allProductsDataList.clear();
      appliedFilterProductDataList.clear();
      getAllProductsListFromServer();
    }
  }

  /// onChange product search value
  void onSearchValueChange({required String searchProductValue}) {
    try {
      searchProductDataList.clear();
      searchProductName.value = searchProductValue;
      if (searchProductName.value.isNotEmpty) {
        for (var productData in allProductsDataList) {
          if ((productData.name ?? '')
              .toLowerCase()
              .contains(searchProductValue.toLowerCase())) {
            searchProductDataList.add(productData);
          }
        }
      }
      searchProductDataList.refresh();
    } catch (e) {
      LoggerUtils.logException('onSearchValueChange', e);
    }
  }

  void applyFilter(
      {required List<Filters> itemsFilter,
      required List<Filters> itemsFilter2}) {
    String appliedFilter = '';

    int j = itemsFilter2.indexWhere((element) => element.isSelected == true);
    List<AllProductsData> tempProductList = [];

    if (j != -1) {
      tempProductList.addAll(allProductsDataList);
      // tempProductList.addAll(appliedFilterProductDataList);
      appliedFilterProductDataList.clear();
    }
    for (var filterData in itemsFilter2) {
      if (filterData.isSelected == true) {
        for (var productData in tempProductList) {
          if (productData.categoryId == filterData.filterId) {
            appliedFilterProductDataList.add(productData);
            // appliedFilter = filterData.sortName;
            // appliedFilterProductDataList
          }
        }
      }
    }
    appliedFilterProductDataList.refresh();

    int i = itemsFilter.indexWhere((element) => element.isSelected == true);
    if (i != -1) {
      if (j != -1) {
        tempProductList.clear();
        tempProductList.addAll(appliedFilterProductDataList);
        appliedFilterProductDataList.clear();
        appliedFilterProductDataList.addAll(tempProductList);
      } else {
        appliedFilterProductDataList.clear();
        appliedFilterProductDataList.addAll(allProductsDataList);
      }
      appliedFilter = itemsFilter[i].sortName;
      // }

      if (appliedFilter == kAToZ) {
        // appliedFilterProductDataList.clear();
        // appliedFilterProductDataList.addAll(allProductsDataList);
        appliedFilterProductDataList.sort((a, b) =>
            ((a.name ?? '').toLowerCase())
                .compareTo((b.name ?? '').toLowerCase()));
        appliedFilterProductDataList.refresh();
      } else if (appliedFilter == kZToA) {
        // appliedFilterProductDataList.clear();
        // appliedFilterProductDataList.addAll(allProductsDataList);
        appliedFilterProductDataList.sort((a, b) =>
            ((b.name ?? '').toLowerCase())
                .compareTo((a.name ?? '').toLowerCase()));
        appliedFilterProductDataList.refresh();
      }
    }
    // int j = itemsFilter2.indexWhere((element) => element.isSelected == true);
    // List<AllProductsData> tempProductList = [];

    appliedFilterProductDataList.refresh();
    Get.back();
  }

  void clearAppliedFilter() {
    appliedFilterProductDataList.clear();
    appliedFilterProductDataList.addAll(allProductsDataList);
  }
}
