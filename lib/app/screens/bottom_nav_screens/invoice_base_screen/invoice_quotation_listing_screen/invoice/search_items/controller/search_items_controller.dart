import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/local_storage_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/generate_invoice_with_customer_selection/controller/generate_invoice_with_customer_selection_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/generate_invoice/controller/generate_invoice_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/view_invoice/model/response/total_product_service_data.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/products/base/model/response/all_products_response_model.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/services/base/model/response/get_all_services_response_model.dart';
import 'package:bms/app/screens/bottom_navigation/base/controller/bottom_nav_base_controller.dart';
import 'package:bms/app/screens/bottom_navigation/base/model/response/drop_down_common_data.dart';
import 'package:bms/app/utils/local_storage.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchItemsController extends GetxController {
  TextEditingController productNameController = TextEditingController();
  RxString productNameValue = ''.obs;

  /// all products and services list
  RxList<AllServicesData> allServicesDataList =
      List<AllServicesData>.empty(growable: true).obs;
  RxList<AllProductsData> allProductsDataList =
      List<AllProductsData>.empty(growable: true).obs;

  /// total items list
  RxList<TotalProductServiceData> itemsList =
      List<TotalProductServiceData>.empty(growable: true).obs;

  /// search items list
  RxList<TotalProductServiceData> searchItemsList =
      List<TotalProductServiceData>.empty(growable: true).obs;

  /// total items list
  RxList<TotalProductServiceData> itemsListData =
      List<TotalProductServiceData>.empty(growable: true).obs;

  /// selected items list
  RxList<TotalProductServiceData> selectedItemsList =
      List<TotalProductServiceData>.empty(growable: true).obs;

  /// focus node values
  RxBool isFocusOnProductNameField = false.obs;

  RxInt selectedItemCount = 0.obs;

  RxBool isComingFromMainGenerateInvoiceScreen = false.obs;

  Future<void> setIntentData({required dynamic intentData}) async {
    try {
      selectedItemsList.clear();
      selectedItemsList.value =
          (intentData[0] as List<TotalProductServiceData>);
      isComingFromMainGenerateInvoiceScreen.value = (intentData[1] as bool);

      var services = await Get.find<LocalStorage>()
          .getStringFromStorage(kStorageServicesList);
      var products = await Get.find<LocalStorage>()
          .getStringFromStorage(kStorageProductsList);

      allServicesDataList.addAll(allServicesDataFromJson(services));
      allProductsDataList.addAll(allProductsDataFromJson(products));
      getTotalItemsList();
      // getItemList();
      // itemsList.value = Get.find<GenerateInvoiceController>().itemsList;
    } catch (e) {
      LoggerUtils.logException('setIntentData', e);
    }
  }

  /// adding products and services into single list
  Future<void> getTotalItemsList() async {
    try {
      for (AllProductsData productData in allProductsDataList) {
        itemsListData.add(
          TotalProductServiceData(
            qty: 1,
            name: productData.name,
            gstRateId: productData.gstRateId,
            categoryId: productData.categoryId,
            itemId: productData.productId,
            sellPrice: productData.sellPrice,
            unitId: productData.unitId,
            isTaxIncluded: productData.sellIsTaxInc,
            qrBarCode: productData.qrBarCode,
            isSelected: false,
            isAddedToList: false,
            isProduct: true,
          ),
        );
      }
      for (AllServicesData serviceData in allServicesDataList) {
        itemsListData.add(
          TotalProductServiceData(
            qty: 1,
            name: serviceData.name,
            gstRateId: serviceData.gstRateId,
            categoryId: serviceData.categoryId,
            itemId: serviceData.serviceId,
            sellPrice: serviceData.sellPrice,
            unitId: serviceData.unitId,
            isTaxIncluded: serviceData.isTaxInc,
            isSelected: false,
            isAddedToList: false,
            isProduct: false,
          ),
        );
      }

      if (selectedItemsList.isNotEmpty) {
        for (var selectedItemsData in selectedItemsList) {
          for(var itemsData in itemsListData){
            if(itemsData.itemId == selectedItemsData.itemId){
              itemsData.isSelected=true;
              itemsData.isAddedToList=true;
            }
          }
        }
      }

      itemsListData.refresh();

      /*if (isForUpdateInvoice.value) {
        await getInvoiceDetailsFromServer();
      }

      getItemTotalValues();
      addingPriceAndQtyTextFieldListValues();*/
      // getItemTotalValues();
    } catch (e) {
      LoggerUtils.logException('getTotalItemsList', e);
    }
  }

  // getItemList() {
  //   List<TotalProductServiceData> tempList =[];
  //   if (isComingFromMainGenerateInvoiceScreen.value) {
  //     tempList = Get.find<GenerateInvoiceWithCustomerSelectionController>().itemsList;
  //   } else {
  //     for(TotalProductServiceData itemData in  Get.find<GenerateInvoiceController>().itemsList) {
  //       tempList.add(itemData);
  //     }
  //   }
  //   for (TotalProductServiceData element in tempList) {
  //     if (element.isAddedToList == false) {
  //       itemsListData.add(element);
  //     }
  //   }
  // }

  /// update focus based on field selection
  void changeFocus({required bool hasFocus, required int fieldNumber}) {
    if (fieldNumber == 1) {
      isFocusOnProductNameField.value = hasFocus;
    }
  }

  /// onChange of productName values
  void onProductNameValueChange() {
    searchItemsList.clear();
    if (itemsListData.isNotEmpty) {
      for (TotalProductServiceData itemData in itemsListData) {
        if ((itemData.name ?? '')
            .toLowerCase()
            .contains(productNameValue.value)) {
          searchItemsList.add(itemData);
        }
      }
    }
    // searchItemsList.refresh();
  }

  void updateSelectedTileValues(
      {required bool isSelected, required TotalProductServiceData itemData}) {
    int index = itemsListData
        .indexWhere((element) => element.itemId == itemData.itemId);

    itemData.isSelected = !(itemData.isSelected ?? false);
    itemsListData.refresh();

    if (productNameValue.trim().isNotEmpty) {
      int searchIndex = searchItemsList
          .indexWhere((element) => element.itemId == itemData.itemId);

      searchItemsList[searchIndex].isSelected = !isSelected;
      searchItemsList.refresh();
    }
    selectedItemCount.value = 0;
    for (int i = 0; i < itemsListData.length; i++) {
      if (itemsListData[i].isSelected == true) {
        selectedItemCount.value = selectedItemCount.value + 1;
      }
    }
  }

  /// return match unit name from unitList
  String returnUnitName({required int index}) {
    String unitName = '';

    for (DropdownCommonData unit in appUnitList) {
      if (unit.id == itemsListData[index].unitId) {
        unitName = unit.name ?? '';
        return unitName;
      }
    }
    return unitName;
  }

  void navigateToBackScreen({bool? isBackPressed = false}) {
    if (isBackPressed == true) {
      for (TotalProductServiceData itemData in itemsListData) {
        if (itemData.isSelected == true && itemData.isAddedToList == false) {
          selectedItemsList.remove(itemData);
          // itemData.isAddedToList = true;
          itemData.isSelected = false;
        }
      }
    }
    // Get.back(result: [null]);

    else {
      for (TotalProductServiceData itemData in itemsListData) {
        if (itemData.isSelected == true && itemData.isAddedToList == false) {
          selectedItemsList.add(itemData);
          itemData.isAddedToList = true;
        }
      }
    }
    Get.back(result: [selectedItemsList]);
  }
}
