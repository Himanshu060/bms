import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/model/filters.dart';
import 'package:bms/app/common/route_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/products/base/controller/products_base_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/services/base/controller/services_base_controller.dart';
import 'package:bms/app/screens/bottom_navigation/base/controller/bottom_nav_base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductServiceBaseController extends GetxController {
  TextEditingController searchItemsController = TextEditingController();
  RxString searchItemValue = ''.obs;
  RxInt currentTabValue = 1.obs;

  RxBool isMoreTextVisible = true.obs;
  RxBool isFilterApplied = false.obs;

  /// items filter list
  RxList<Filters> itemsFiltersList = List<Filters>.empty(growable: true).obs;
  RxList<Filters> itemsFiltersList2 = List<Filters>.empty(growable: true).obs;

  @override
  void onInit() {
    setCustFilters();
    Get.find<BottomNavBaseController>().tabIndex.listen((p0) {
      if (p0 == 1) {
        isFilterApplied.value=false;
        searchItemsController.text = '';
        searchItemValue.value = '';
        searchProductName();
        searchServiceName();
        itemsFiltersList.clear();
        itemsFiltersList2.clear();
        setCustFilters();
      }
    });
    super.onInit();
  }

  /// set customer filters
  void setCustFilters() {
    itemsFiltersList.add(
        Filters(filterName: kAscOrder, isSelected: false, sortName: kAToZ));
    itemsFiltersList.add(
        Filters(filterName: kDscOrder, isSelected: false, sortName: kZToA));
    for (var catData in appCategoryList) {
      itemsFiltersList2.add(
        Filters(
            filterName: catData.name ?? '',
            isSelected: false,
            filterId: catData.id,
            sortName: catData.name ?? ''),
      );
    }
    // itemsFiltersList
    //     .add(Filters(filterName: kMinDue, isSelected: false, sortName: kMin));
    // itemsFiltersList
    //     .add(Filters(filterName: kMaxDue, isSelected: false, sortName: kMax));
  }

  Future<void> navigateToAddItemsScreen() async {
    /// 1 : product added 2 : service added
    var isAdded = await Get.toNamed(kRouteAddProductServiceTabScreen,
        arguments: [currentTabValue.value]);
    if (isAdded == 1) {
      itemsFiltersList.clear();
      itemsFiltersList2.clear();
      setCustFilters();
      Get.find<ProductsBaseController>().getAllProductsListFromServer();
    } else if (isAdded == 2) {
      itemsFiltersList.clear();
      itemsFiltersList2.clear();
      setCustFilters();
      Get.find<ServicesBaseController>().getAllServicesListFromServer();
    }
  }

  //
  // void changeTabValue(value){
  //   currentTabValue.value = value;
  //   currentTabValue.refresh();
  // }

  searchProductName() {
    // if (searchItemsController.text.trim().isNotEmpty) {
    // } else {
    Get.find<ProductsBaseController>().onSearchValueChange(
        searchProductValue: searchItemsController.text.trim());
    // }
  }

  searchServiceName() {
    Get.find<ServicesBaseController>().onSearchValueChange(
        searchProductValue: searchItemsController.text.trim());
  }

  void clearFilter() {
    if (currentTabValue.value == 1) {
      int index =
          itemsFiltersList.indexWhere((element) => element.isSelected == true);
      if (index != -1) {
        itemsFiltersList[index].isSelected = false;
        itemsFiltersList.refresh();
        // Get.find<ProductsBaseController>().clearAppliedFilter();
        // Get.find<ServicesBaseController>().clearAppliedFilter();
      }
      for (var filterData in itemsFiltersList2) {
        filterData.isSelected = false;
      }
      itemsFiltersList2.refresh();
      Get.find<ProductsBaseController>().clearAppliedFilter();
      Get.find<ServicesBaseController>().clearAppliedFilter();
    } else {
      int index =
          itemsFiltersList.indexWhere((element) => element.isSelected == true);
      if (index != -1) {
        itemsFiltersList[index].isSelected = false;
        itemsFiltersList.refresh();
      }

      for (var filterData in itemsFiltersList2) {
        filterData.isSelected = false;
      }
      itemsFiltersList2.refresh();
      Get.find<ServicesBaseController>().clearAppliedFilter();
      Get.find<ProductsBaseController>().clearAppliedFilter();
    }
    isFilterApplied.value = false;
  }

  void applyFilter() {
    int i =
        itemsFiltersList.indexWhere((element) => element.isSelected == true);
    int j =
        itemsFiltersList2.indexWhere((element) => element.isSelected == true);
    if (currentTabValue.value == 1) {
      Get.find<ProductsBaseController>().applyFilter(
          itemsFilter: itemsFiltersList, itemsFilter2: itemsFiltersList2);

    } else {
      Get.find<ServicesBaseController>().applyFilter(
          itemsFilter: itemsFiltersList, itemsFilter2: itemsFiltersList2);

    }
    if (i != -1 || j != -1) {
      isFilterApplied.value = true;
    } else {
      isFilterApplied.value = false;
    }
  }

  void updateFilterStatus({required int i}) {
    int index =
        itemsFiltersList.indexWhere((element) => element.isSelected == true);
    if (index != -1 && i != index) {
      itemsFiltersList[index].isSelected = false;
    }
    itemsFiltersList[i].isSelected = !itemsFiltersList[i].isSelected;
    itemsFiltersList.refresh();
  }

  void updateCategoryFilterStatus({required int i}) {
    // int index =
    //     itemsFiltersList2.indexWhere((element) => element.isSelected == true);
    // if (index != -1 && i != index) {
    //   itemsFiltersList[index].isSelected = false;
    // }
    itemsFiltersList2[i].isSelected = !itemsFiltersList2[i].isSelected;
    itemsFiltersList2.refresh();
  }
}
