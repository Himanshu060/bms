import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/local_storage_constants.dart';
import 'package:bms/app/common/route_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/customer_base_screen/base/model/response/get_customer_response_model.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/base/controller/invoice_quotation_listing_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/base/model/response/summary_data_response.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/generate_invoice/model/response/generate_invoice_request_model.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/generate_invoice/model/response/get_invoice_details_response_model.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/view_invoice/model/response/total_product_service_data.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/products/base/model/response/all_products_response_model.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/services/base/model/response/get_all_services_response_model.dart';
import 'package:bms/app/screens/bottom_navigation/base/controller/bottom_nav_base_controller.dart';
import 'package:bms/app/screens/bottom_navigation/base/model/response/drop_down_common_data.dart';
import 'package:bms/app/services/repository/invoice_repository.dart';
import 'package:bms/app/services/repository/product_repository.dart';
import 'package:bms/app/services/repository/service_repository.dart';
import 'package:bms/app/utils/alert_message_utils.dart';
import 'package:bms/app/utils/calculate_price/calculations.dart';
import 'package:bms/app/utils/decode_response_data/decode_response_data.dart';
import 'package:bms/app/utils/local_storage.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:bms/app/utils/number_formatter/number_formatter.dart';
import 'package:bms/app/utils/return_string_as_fixed_value.dart';
import 'package:bms/app/utils/text_styles.dart';
import 'package:bms/app/widgets/dialogs/show_confirm_dialog_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';

class GenerateInvoiceController extends GetxController {
  // RxInt pageNumber = 0.obs;
  String bizId = '';
  RxString productNameValue = ''.obs;
  double textFieldHeight = 40;
  double textFieldWidth = Get.width * 0.42;

  RxInt invoiceNo = 0.obs;
  RxBool isForUpdateInvoice = false.obs;
  RxBool isForUpdate = false.obs;
  RxBool isItemPriceEditable = false.obs;

  Rx<AllCustomerData> customerData = AllCustomerData().obs;

  /// discountAmount, discountPercentage, additionalCharges, productName, barCode text-fields
  TextEditingController discountInAmountTextField = TextEditingController();
  TextEditingController discountInPercentageTextField = TextEditingController();
  TextEditingController additionalChargeTextField = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController barCodeController = TextEditingController();
  TextEditingController receivedAmountController = TextEditingController();

  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerMobileNoController = TextEditingController();
  TextEditingController customerEmailIdController = TextEditingController();

  TextEditingController totalController = TextEditingController();
  TextEditingController payableAmountController = TextEditingController();

  /// price and qty text-field list
  RxList<TextEditingController> priceTextFieldList =
      List<TextEditingController>.empty(growable: true).obs;
  RxList<TextEditingController> qtyTextFieldList =
      List<TextEditingController>.empty(growable: true).obs;

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

  /// selected items list
  RxList<TotalProductServiceData> selectedItemsList =
      List<TotalProductServiceData>.empty(growable: true).obs;

  Rx<GetInvoiceDetailsResponseModel> invoiceDetailsData =
      GetInvoiceDetailsResponseModel().obs;
  Rx<InvoiceDetailData> intentInvoiceData = InvoiceDetailData().obs;

  /// initialization of invoiceTotal and invoicePayable
  // RxString invoiceTotal = '0'.obs;
  // RxString invoicePayable = '0'.obs;
  TextEditingController invoiceTotal = TextEditingController(text: '0');
  TextEditingController invoicePayable = TextEditingController(text: '0');

  // RxString invoiceTotal = '0'.obs;
  // RxString invoicePayable = '0'.obs;

  /// focus node values
  RxBool isFocusOnProductNameField = false.obs;
  RxBool isFocusOnBarcodeField = false.obs;

  /// validation values
  RxBool isValidProductName = false.obs;
  RxBool isValidBarcode = false.obs;

  /// validation strings
  RxString productNameStr = ''.obs;
  RxString barCodeStr = ''.obs;

  /// while data loading from server bool value
  RxBool isDataLoading = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    Get.lazyPut(() => ProductRepository(), fenix: true);
    Get.lazyPut(() => ServiceRepository(), fenix: true);
    Get.lazyPut(() => InvoiceRepository(), fenix: true);

    isItemPriceEditable.value = await Get.find<LocalStorage>()
            .getBoolFromStorage(kStorageIsSellPriceEditable) ??
        false;
    // await getAllProductsListFromServer();
    // await getAllServicesListFromServer();
    // getTotalItemsList();
  }

  /// assigning customerData from intent value
  Future<void> setIntentData({required dynamic intentData}) async {
    try {
      customerData.value = (intentData[0] as AllCustomerData);
      customerNameController.text = customerData.value.name ?? '';
      customerMobileNoController.text =
          (customerData.value.mobileNo ?? 0).toString();
      customerEmailIdController.text = customerData.value.emailId ?? '';
      isForUpdateInvoice.value = (intentData[1] as bool);
      isForUpdate.value = (intentData[1] as bool);
      if (isForUpdateInvoice.value) {
        intentInvoiceData.value = (intentData[2] as InvoiceDetailData);
      }
      bizId =
          await Get.find<LocalStorage>().getStringFromStorage(kStorageBizId);
      await getAllProductsListFromServer();
      await getAllServicesListFromServer();
      getTotalItemsList();
    } catch (e) {
      LoggerUtils.logException('setIntentData', e);
    }
  }

  /// adding products and services into single list
  Future<void> getTotalItemsList() async {
    try {
      for (AllProductsData productData in allProductsDataList) {
        itemsList.add(
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
        itemsList.add(
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
      itemsList.refresh();

      if (isForUpdateInvoice.value) {
        await getInvoiceDetailsFromServer();
      }

      getItemTotalValues();
      addingPriceAndQtyTextFieldListValues();
      // getItemTotalValues();
    } catch (e) {
      LoggerUtils.logException('getTotalItemsList', e);
    }
  }

  /// update focus based on field selection
  void changeFocus({required bool hasFocus, required int fieldNumber}) {
    if (fieldNumber == 1) {
      isFocusOnProductNameField.value = hasFocus;
    } else if (fieldNumber == 2) {
      isFocusOnBarcodeField.value = hasFocus;
    } else if (fieldNumber == 3) {
      // isFocusOnSellingPriceField.value = hasFocus;
    } else if (fieldNumber == 4) {
      // isFocusOnHSNCodeField.value = hasFocus;
    } else if (fieldNumber == 5) {
      // isFocusOnBarcodeField.value = hasFocus;
    }
  }

  /// get all products list from server
  Future<void> getAllProductsListFromServer() async {
    try {
      allProductsDataList.clear();
      var response =
          await Get.find<ProductRepository>().getAllProductsDataFromServer(
        bizId: bizId,
        pageNumber: '-1',
        // pageNumber: pageNumber.toString(),
      );

      if (response != null && response.statusCode == 100) {
        var res = decodeResponseData(responseData: response.data ?? '');
        if (res != null && res != '') {
          var tempList = allProductsDataFromJson(res);
          allProductsDataList.addAll(tempList);
          Get.find<LocalStorage>()
              .writeStringStorage(kStorageProductsList, res);
        }
      } else {
        Get.find<AlertMessageUtils>().showErrorSnackBar(response?.msg ?? '');
      }
    } catch (e) {
      LoggerUtils.logException('getAllProductsListFromServer', e);
    }
  }

  /// get all services list from server
  Future<void> getAllServicesListFromServer() async {
    try {
      allServicesDataList.clear();
      var response =
          await Get.find<ServiceRepository>().getAllServicesDataFromServer(
        bizId: bizId, pageNumber: '-1',
        // pageNumber: pageNumber.toString(),
      );

      if (response != null && response.statusCode == 100) {
        var res = decodeResponseData(responseData: response.data ?? '');
        if (res != null && res != '') {
          var tempList = allServicesDataFromJson(res);
          allServicesDataList.addAll(tempList);
          Get.find<LocalStorage>()
              .writeStringStorage(kStorageServicesList, res);
        }
      } else {
        Get.find<AlertMessageUtils>().showErrorSnackBar(response?.msg ?? '');
      }
    } catch (e) {
      LoggerUtils.logException('getAllProductsListFromServer', e);
    }
  }

  /// get invoice details data from server
  Future<void> getInvoiceDetailsFromServer() async {
    try {
      List<TotalProductServiceData> fromApiCartItemsList = [];
      var response = await Get.find<InvoiceRepository>().getInvoiceDetailsApi(
          bizId: bizId, invoiceId: intentInvoiceData.value.invoiceId ?? 0);

      if (response != null && response.statusCode == 100) {
        var res = decodeResponseData(responseData: response.data ?? '');
        if (res != null && res != '') {
          invoiceDetailsData.value =
              getInvoiceDetailsResponseModelFromJson(res);
          fromApiCartItemsList = invoiceDetailsData.value.itemList ?? [];
          // itemsList.addAll(invoiceDetailsData.value.itemList ?? []);
        }
      }

      if (fromApiCartItemsList.isNotEmpty) {
        for (TotalProductServiceData apiCartData in fromApiCartItemsList) {
          for (TotalProductServiceData itemData in itemsList) {
            // if (apiCartData.isProduct == true) {
              if (apiCartData.itemId == itemData.itemId) {
                itemData.isAddedToList = true;
                itemData.isSelected = true;
                selectedItemsList.add(apiCartData);
              }
            // } else {
            //   if (apiCartData.itemId == itemData.itemId) {
            //     itemData.isAddedToList = true;
            //     itemData.isSelected = true;
            //     selectedItemsList.add(apiCartData);
            //   }
            // }
          }
        }
      }

      discountInAmountTextField.text = returnToStringAsFixed(
          value: invoiceDetailsData.value.discountAmount ?? 0.0);
      additionalChargeTextField.text = returnToStringAsFixed(
          value: invoiceDetailsData.value.additionalCharge ?? 0.0);
      // itemsList.refresh();
      selectedItemsList.refresh();
    } catch (e) {
      LoggerUtils.logException('getInvoiceDetailsFromServer', e);
    }
  }

  /// adding values in price and qty text field list
  addingPriceAndQtyTextFieldListValues() {
    try {
      priceTextFieldList.clear();
      qtyTextFieldList.clear();
      if (selectedItemsList.isNotEmpty) {
        for (int i = 0; i < selectedItemsList.length; i++) {
          /// adding priceText-field values
          priceTextFieldList.add(
            TextEditingController(
              text: returnToStringAsFixed(
                  value: (selectedItemsList[i].sellPrice ?? 0.0)),
            ),
          );

          /// adding qty text-field values
          double qty = selectedItemsList[i].qty == null
              ? 1.0
              : (selectedItemsList[i].qty ?? 1.0);
          qtyTextFieldList.add(
            TextEditingController(text: returnToStringAsFixed(value: qty)),
          );
        }
      }
      getInvoiceTotalAndPayableAmount();
      if (isForUpdateInvoice.value) {
        onDiscountInAmountValueChange();
      } else {
        /// manage when selectItem list is empty then reset discount data
        if (selectedItemsList.isEmpty) {
          discountInAmountTextField.text = '';
          discountInPercentageTextField.text = '';
          additionalChargeTextField.text = '';
        } else {
          onDiscountInPercentageValueChange();
        }
      }
    } catch (e) {
      LoggerUtils.logException('addingPriceAndQtyTextFieldListValues', e);
    }
  }

  /// calculating individual items total
  getItemTotalValues() {
    try {
      if (selectedItemsList.isEmpty) {
        for (TotalProductServiceData itemData in itemsList) {
          itemData.itemTotal = double.parse(returnToStringAsFixed(
              value: calculateItemTotal(
                  sellPrice: itemData.sellPrice ?? 0.0,
                  qty: itemData.qty ?? 0.0)));
        }
      } else {
        for (TotalProductServiceData itemData in selectedItemsList) {
          itemData.itemTotal = double.parse(returnToStringAsFixed(
              value: calculateItemTotal(
                  sellPrice: itemData.sellPrice ?? 0.0,
                  qty: itemData.qty ?? 0.0)));
        }
      }
      // getInvoiceTotalAndPayableAmount();
    } catch (e) {
      LoggerUtils.logException('getItemTotalValues', e);
    }
  }

  /// return match unit name from unitList
  String returnUnitName({required int index}) {
    String unitName = '';

    for (DropdownCommonData unit in appUnitList) {
      if (unit.id == selectedItemsList[index].unitId) {
        unitName = unit.name ?? '';
        return unitName;
      }
    }
    return unitName;
  }

  /// return match gst rate from gstRateList
  String returnGstRate({required TotalProductServiceData itemData}) {
    String gstRate = '0.0';

    for (var gstData in BottomNavBaseController.gstRateList) {
      if (itemData.gstRateId != null && itemData.gstRateId == gstData.id) {
        gstRate = ((gstData.value) ?? 0.0).toStringAsFixed(2);
      }
    }
    return gstRate;
  }

  /// onChange of barCode values
  void onBarCodeValueChange() {
    searchItemsList.clear();
    if (itemsList.isNotEmpty) {
      bool isMatched = false;
      for (TotalProductServiceData itemData in itemsList) {
        // if ((itemData.qrBarCode ?? '').contains(productNameValue.value)) {
        //   searchItemsList.add(itemData);

        if (((itemData.qrBarCode ?? '') == productNameValue.value) &&
            isMatched == false) {
          itemData.isSelected = !(itemData.isSelected ?? false);
          itemData.isAddedToList = true;
          isMatched = true;
          addToList(barCodeValue: itemData.qrBarCode ?? '');
          FocusScope.of(Get.overlayContext!).unfocus();
        }
        // }
      }
    }
    // searchItemsList.refresh();
  }

  /// adding selected product to selectedItemList
  void addToList(
      {bool? isComingFromSearchItemScreen = false,
      List<TotalProductServiceData>? selectedList,
      String? barCodeValue}) {
    if (isComingFromSearchItemScreen == false) {
      for (TotalProductServiceData itemData in itemsList) {
        if (itemData.isSelected == true && itemData.isAddedToList == false) {
          selectedItemsList.add(itemData);
          // itemData.isAddedToList = !(itemData.isAddedToList ?? false);
          itemData.isAddedToList = true;
        } else if (itemData.isAddedToList == true &&
            itemData.qrBarCode == barCodeValue) {
          int i= selectedItemsList.indexWhere((element) => element.itemId == itemData.itemId);
          if(i!=-1){
          itemData.qty = (itemData.qty ?? 0.0) + 1.0;}
          selectedItemsList.removeWhere((element) => element.itemId == itemData.itemId);
          selectedItemsList.add(itemData);
        }
      }
    } else {
      for (TotalProductServiceData selectedData in selectedList ?? []) {
        for (TotalProductServiceData itemData in itemsList) {
          if (selectedData.itemId == itemData.itemId) {
            selectedItemsList.add(itemData);
            // itemData.isAddedToList = !(itemData.isAddedToList ?? false);
            itemData.isAddedToList = true;
          }
        }
      }
    }
    itemsList.refresh();
    selectedItemsList.value = selectedItemsList.reversed.toList();
    isFocusOnProductNameField.value = false;
    selectedItemsList.refresh();
    productNameController.text = '';
    barCodeController.text = '';
    productNameValue.value = '';
    getItemTotalValues();
    addingPriceAndQtyTextFieldListValues();
  }

  /// decrease qty values
  void minus({required int index}) {
    selectedItemsList[index].qty = selectedItemsList[index].qty! - 1;
    String updatedQty =
        (selectedItemsList[index].qty ?? 0.0).toStringAsFixed(2);
    if (updatedQty.split('.').last != '00') {
      qtyTextFieldList[index].text = updatedQty;
    } else {
      qtyTextFieldList[index].text = updatedQty.split('.').first;
    }
    selectedItemsList.refresh();
    qtyTextFieldList.refresh();
    incrsDescPriceValues(index: index);
  }

  /// increase qty values
  void plus({required int index}) {
    selectedItemsList[index].qty = selectedItemsList[index].qty! + 1;
    String updatedQty =
        (selectedItemsList[index].qty ?? 0.0).toStringAsFixed(2);
    if (updatedQty.split('.').last != '00') {
      qtyTextFieldList[index].text = updatedQty;
    } else {
      qtyTextFieldList[index].text = updatedQty.split('.').first;
    }
    selectedItemsList.refresh();
    qtyTextFieldList.refresh();
    incrsDescPriceValues(index: index);
  }

  /// after incr or desc update total item price values
  incrsDescPriceValues({required int index, bool isOnChange = false}) {
    if (selectedItemsList[index].qty! > 0) {
      selectedItemsList[index].itemTotal = (calculateItemTotal(
          sellPrice: selectedItemsList[index].sellPrice ?? 0.0,
          qty: selectedItemsList[index].qty ?? 0.0));
    } else if (isOnChange == false) {
      qtyTextFieldList[index].text = '1';
    }
    selectedItemsList.refresh();
    getInvoiceTotalAndPayableAmount();
    onDiscountInPercentageValueChange();
    // getInvoicePayableAmount();
  }

  /// calculating total amount and payable amount
  getInvoiceTotalAndPayableAmount() {
    if (selectedItemsList.isNotEmpty) {
      double total = 0.0;
      double gstValue = 0.0;
      for (TotalProductServiceData itemData in selectedItemsList) {
        if (itemData.isTaxIncluded == false && itemData.gstRateId != null) {
          gstValue = calculateDiscountAmount(
              totalAmount: itemData.itemTotal ?? 0.0,
              additionalCharges: 0,
              discountPercentage: (BottomNavBaseController
                      .gstRateList[(itemData.gstRateId ?? 0) - 1].value ??
                  0.0));
        }
        total = (total + (itemData.itemTotal ?? 0.0) + gstValue);
        // total = total + (itemData.itemTotal ?? 0.0);
      }

      invoiceTotal.text = returnFormattedNumber(
          values: double.parse(returnToStringAsFixed(value: total)));
      // String payableAmount = returnToStringAsFixed(value: total);
      var disAmount = discountInAmountTextField.text.trim().isEmpty
          ? '0'
          : discountInAmountTextField.text.trim();
      var additAmount = additionalChargeTextField.text.trim().isEmpty
          ? '0'
          : additionalChargeTextField.text.trim();

      double payableAmount = double.parse(returnToStringAsFixed(
          value:
              ((total - double.parse(disAmount)) + double.parse(additAmount))));
      invoicePayable.text = returnFormattedNumber(values: payableAmount);
    } else {
      invoiceTotal.text = '0';
      invoicePayable.text = '0';
    }
    // if (total.toStringAsFixed(2).split('.').last == "00") {
    //   invoiceTotal.value = total.toStringAsFixed(0);
    //   invoicePayable.value = total.toStringAsFixed(0);
    // } else {
    //   invoiceTotal.value = total.toStringAsFixed(2);
    //   invoicePayable.value = total.toStringAsFixed(2);
    // }
  }

  /// onChange of qtyTextFieldList values
  void onQtyValueChange({required int index, bool isOnChange = true}) {
    if (isOnChange) {
      double qty = qtyTextFieldList[index].text.isEmpty ||
              qtyTextFieldList[index].text.trim() == "0"
          ? 1
          : double.parse(qtyTextFieldList[index].text);
      selectedItemsList[index].qty = qty;
      selectedItemsList.refresh();
      incrsDescPriceValues(index: index, isOnChange: true);
    } else {
      if (qtyTextFieldList[index].text.isEmpty ||
          double.parse(qtyTextFieldList[index].text) <= 1) {
        qtyTextFieldList[index].text = '1';
        // itemsList[index].sellPrice = 1.0;
        qtyTextFieldList.refresh();
        incrsDescPriceValues(index: index);
      }
      // if((isOnChange ==false && qtyTextFieldList[index].text.isEmpty) || qtyTextFieldList[index].text == "0"){
      //   qtyTextFieldList[index].text = '1';
      //   priceTextFieldList[index].text = '1';
      //   selectedItemsList[index].qty = 1.0;
      //   selectedItemsList[index].sellPrice = 1.0;
      //   selectedItemsList[index].itemTotal = 1.0;
      //   selectedItemsList.refresh();
      //   qtyTextFieldList.refresh();
      //   incrsDescPriceValues(index: index);
      // }
    }
  }

  /// onChange priceTextFieldList values
  void onPriceValueChange({required int index, bool isOnChange = true}) {
    if (isOnChange) {
      selectedItemsList[index].sellPrice =
          priceTextFieldList[index].text.trim().isEmpty
              ? 0
              : double.parse(priceTextFieldList[index].text.trim());
      selectedItemsList.refresh();
      discountInPercentageTextField.text = '';
      discountInAmountTextField.text = '';
      incrsDescPriceValues(index: index);
    } else {
      if (priceTextFieldList[index].text.trim().isEmpty ||
          double.parse(priceTextFieldList[index].text.trim()) <= 0) {
        priceTextFieldList[index].text = '1';
        selectedItemsList[index].sellPrice = 1.0;
        selectedItemsList.refresh();
        priceTextFieldList.refresh();
        incrsDescPriceValues(index: index);
      } else {
        priceTextFieldList[index].text = returnToStringAsFixed(
            value: double.parse(priceTextFieldList[index].text.trim()));
      }
    }
  }

  /// onChange discountInAmountTextField values
  void onDiscountInAmountValueChange({bool isOnChange = true}) {
    if (isOnChange) {
      double discountAmount = 0.0;
      double payableAmount = 0.0;
      double additionalCharge = 0.0;
      additionalCharge = additionalChargeTextField.text.trim().isEmpty
          ? 0.0
          : double.parse(additionalChargeTextField.text.trim());
      if (discountInAmountTextField.text.trim().isNotEmpty &&
          double.parse(discountInAmountTextField.text) <=
              double.parse(invoiceTotal.text.replaceAll(',', ''))) {
        discountAmount = discountInAmountTextField.text.trim().isEmpty
            ? 0
            : double.parse(discountInAmountTextField.text);

        payableAmount = ((double.parse(invoiceTotal.text.replaceAll(',', '')) -
                discountAmount) +
            additionalCharge);
      } else {
        payableAmount = (double.parse(invoiceTotal.text.replaceAll(',', '')) +
            additionalCharge);
      }
      invoicePayable.text = returnFormattedNumber(
          values: double.parse(returnToStringAsFixed(value: payableAmount)));

      double percentage = calculateDiscountPercentage(
          discountPrice: discountAmount,
          totalAmount: double.parse(invoiceTotal.text.replaceAll(',', '')));
      if (discountInAmountTextField.text.trim().isEmpty ||
          discountInAmountTextField.text.trim() == '0') {
        discountInPercentageTextField.text = '';
      }
      if (discountInAmountTextField.text.trim().isNotEmpty &&
          discountInAmountTextField.text.trim() != '0') {
        discountInPercentageTextField.text =
            returnToStringAsFixed(value: percentage);
      }
      isForUpdateInvoice.value = false;
    } else {
      if (discountInAmountTextField.text.trim().isEmpty ||
          discountInAmountTextField.text.trim() == '0') {
        discountInAmountTextField.text = '';
        discountInPercentageTextField.text = '';
      }
    }
  }

  /// onChange discountInPercentageTextField values
  void onDiscountInPercentageValueChange({bool isOnChange = true}) {
    if (isOnChange) {
      double discountPercentage = 0.0;
      double payableAmount = 0.0;
      double additionalCharge = 0.0;
      additionalCharge = additionalChargeTextField.text.trim().isEmpty
          ? 0.0
          : double.parse(additionalChargeTextField.text.trim());

      if (discountInPercentageTextField.text.trim().isNotEmpty &&
          double.parse(discountInPercentageTextField.text) <= 100) {
        discountPercentage = discountInPercentageTextField.text.trim().isEmpty
            ? 0
            : double.parse(discountInPercentageTextField.text);

        double discountAmount = calculateDiscountAmount(
            totalAmount: double.parse(invoiceTotal.text.replaceAll(',', '')),
            additionalCharges: additionalCharge,
            discountPercentage: discountPercentage);
        discountInAmountTextField.text =
            returnToStringAsFixed(value: discountAmount);
        payableAmount = ((double.parse(invoiceTotal.text.replaceAll(',', '')) -
                discountAmount) +
            additionalCharge);
      } else if (discountInPercentageTextField.text.trim().length > 3 ||
          double.parse(discountInPercentageTextField.text.trim().isEmpty
                  ? '0'
                  : discountInPercentageTextField.text.trim()) >=
              100) {
        FocusScope.of(Get.overlayContext!).unfocus();
        discountInAmountTextField.text = invoiceTotal.text;
        discountInPercentageTextField.text = '100';
        payableAmount = (double.parse(invoiceTotal.text) * 2);
      } else {
        discountInAmountTextField.text = '';
        discountInAmountTextField.text = '';
        payableAmount = (double.parse(invoiceTotal.text.replaceAll(',', '')) +
            additionalCharge);
      }
      invoicePayable.text = returnFormattedNumber(
          values: double.parse(returnToStringAsFixed(value: payableAmount)));
    } else {
      if (discountInPercentageTextField.text.trim().isEmpty) {
        discountInPercentageTextField.text = '';
        discountInAmountTextField.text = '';
      }
    }
  }

  /// onChange additionalChargeTextField values
  void onAdditionalChargeValueChange({bool isOnChange = true}) {
    if (isOnChange) {
      double additionalCharge = 0.0;
      double payableAmount = 0.0;
      double discInAmount = discountInAmountTextField.text.trim().isEmpty
          ? 0
          : double.parse(discountInAmountTextField.text.trim());
      if (additionalChargeTextField.text.trim().isNotEmpty &&
          double.parse(additionalChargeTextField.text) <=
              double.parse(invoiceTotal.text.replaceAll(',', ''))) {
        additionalCharge = additionalChargeTextField.text.trim().isEmpty
            ? 0
            : double.parse(additionalChargeTextField.text);

        // payableAmount = (double.parse(invoiceTotal.value) + additionalCharge);
        payableAmount = ((double.parse(invoiceTotal.text.replaceAll(',', '')) -
                discInAmount) +
            additionalCharge);
      } else {
        payableAmount = (double.parse(invoiceTotal.text.replaceAll(',', '')) -
            discInAmount);
      }
      invoicePayable.text = returnFormattedNumber(
          values: double.parse(returnToStringAsFixed(value: payableAmount)));
    } else {
      if (additionalChargeTextField.text.trim().isEmpty) {
        additionalChargeTextField.text = '';
      }
    }
  }

  void onReceivedAmountValueChange({bool isOnChange = true}) {
    if (isOnChange) {}
  }

  void removeItemFromList({required TotalProductServiceData itemData}) {
    itemData.isAddedToList = false;
    itemData.isSelected = false;
    selectedItemsList.remove(itemData);
    selectedItemsList.refresh();
    addingPriceAndQtyTextFieldListValues();
    getItemTotalValues();
  }

  /// checking if selected item list empty or not
  Future<void> checkValidationsAndApiCall() async {
    try {
      if (receivedAmountController.text.trim().isNotEmpty &&
          double.parse(receivedAmountController.text.trim()) >
              double.parse(invoicePayable.text.replaceAll(',', ''))) {
        Get.find<AlertMessageUtils>()
            .showErrorSnackBar(kReceivedAmountValidation);
      } else if (selectedItemsList.isEmpty) {
        Get.find<AlertMessageUtils>()
            .showErrorSnackBar(kPleaseSelectItemToGenerateInvoice);
      } else {
        generateInvoiceApi();
      }

      // if (double.parse(receivedAmountController.text.trim()) <=
      //     double.parse(invoicePayable.text)) {
      //   if (selectedItemsList.isNotEmpty) {
      //     generateInvoiceApi();
      //   } else {
      //     Get.find<AlertMessageUtils>()
      //         .showErrorSnackBar(kPleaseSelecteItemToGenerateInvoice);
      //   }
      // } else {
      //   Get.find<AlertMessageUtils>()
      //       .showErrorSnackBar(kReceivedAmountValidation);
      // }
    } catch (e) {
      LoggerUtils.logException('checkValidationsAndApiCall', e);
    }
  }

  /// generate invoice api call
  Future<void> generateInvoiceApi() async {
    try {
      List<ProductList> productList = [];
      List<ServiceList> serviceList = [];

      for (TotalProductServiceData itemData in selectedItemsList) {
        if (itemData.isProduct == true) {
          productList.add(
            ProductList(
              sellingPrice: itemData.sellPrice,
              qty: itemData.qty,
              unitId: itemData.unitId,
              itemId: itemData.itemId,
              gstRateId: itemData.gstRateId == 01 ? null : itemData.gstRateId,
              isTaxInc: itemData.isTaxIncluded,
            ),
          );
        } else {
          serviceList.add(
            ServiceList(
              sellingPrice: itemData.sellPrice,
              qty: itemData.qty,
              unitId: itemData.unitId,
              itemId: itemData.itemId,
              gstRateId: itemData.gstRateId == 0 ? null : itemData.gstRateId,
              isTaxInc: itemData.isTaxIncluded,
            ),
          );
        }
      }

      var requestModel = GenerateInvoiceRequestModel(
        bizId: int.parse(bizId),
        invoiceID: isForUpdate.value ? intentInvoiceData.value.invoiceId : null,
        custId: isForUpdate.value ? null : customerData.value.custId,
        productList: productList,
        serviceList: serviceList,
        totalAmount:
            double.parse(invoiceTotal.text.replaceAll(',', '')).toPrecision(2),
        discountAmount: discountInAmountTextField.text.trim().isEmpty
            ? 0
            : double.parse(discountInAmountTextField.text.trim())
                .toPrecision(2),
        additionalCharge: additionalChargeTextField.text.trim().isEmpty
            ? 0
            : double.parse(additionalChargeTextField.text.trim())
                .toPrecision(2),
        paidAmount: receivedAmountController.text.trim().isEmpty
            ? 0
            : double.parse(receivedAmountController.text.trim()).toPrecision(2),
      );
      var response = await Get.find<InvoiceRepository>()
          .generateOrUpdateInvoiceApi(
              requestModel: requestModel,
              isForUpdateInvoice: isForUpdate.value);

      if (response != null && response.data != null) {
        if (response.statusCode == 100) {
          Get.find<InvoiceQuotationListingController>()
              .isCustomerUpdated
              .value = true;
          // Get.back(result: true);

          showConfirmDialog();
        } else {
          Get.find<AlertMessageUtils>().showErrorSnackBar(response.msg ?? '');
        }
      }
    } catch (e) {
      LoggerUtils.logException('generateInvoiceApi', e);
    }
  }

  void showConfirmDialog() {
    showDialog(
      context: Get.overlayContext!,
      builder: (context) {
        return ShowConfirmationDialogWidget(
          title: '',
          // type: kLabelWarning,
          message: kInvoiceCreatedSuccessfully,
          negativeButtonTitle: kLabelNo,
          negativeClicked: () {
            Get.back(result: false);
          },
          positiveButtonTitle: kLabelOkay,
          positiveClicked: () {
            Get.back();
            Get.back(result: true);
          },
        );
      },
    );
  }

  // showConfirmDialog() {
  //   QuickAlert.show(
  //     barrierDismissible: false,
  //     context: Get.overlayContext!,
  //     type: QuickAlertType.success,
  //     text: kInvoiceCreatedSuccessfully,
  //     confirmBtnColor: kColorPrimary,
  //     confirmBtnTextStyle: TextStyles.kTextH16White600,
  //     onConfirmBtnTap: () {
  //       Get.back();
  //       Get.back(result: true);
  //     },
  //   );
  // }

  Future<void> navigateToSearchItemsScreen() async {
    var selectedData = await Get.toNamed(kRouteSearchItemsScreen,
        arguments: [selectedItemsList, false]);

    FocusScope.of(Get.overlayContext!).unfocus();
    List<TotalProductServiceData> selectedList = [];

    if (selectedData != null && selectedData[0].isNotEmpty) {
      selectedList = (selectedData[0] as List<TotalProductServiceData>);
    }
    // selectedItemsList.addAll(selectedList);
    addToList(isComingFromSearchItemScreen: true);
  }

  returnGSTRateItemTotal({required TotalProductServiceData itemData}) {
    double gstValue = 0.0;
    if (itemData.isTaxIncluded == false && itemData.gstRateId != null) {
      gstValue = calculateDiscountAmount(
          totalAmount: itemData.itemTotal ?? 0.0,
          additionalCharges: 0,
          discountPercentage: (BottomNavBaseController
                  .gstRateList[(itemData.gstRateId ?? 0) - 1].value ??
              0.0));
    }
    return returnFormattedNumber(
        values: double.parse(returnToStringAsFixed(
            value: ((itemData.itemTotal ?? 0.0) + gstValue))));
  }

  void resetInvoiceValues() {
    discountInAmountTextField.text = '';
    discountInPercentageTextField.text = '';
    additionalChargeTextField.text = '';
    receivedAmountController.text = '';
    selectedItemsList.clear();
    // customerData.value = AllCustomerData();

    // for (TotalProductServiceData itemData in itemsList) {
    //   itemData.isSelected = false;
    //   itemData.isAddedToList = false;
    //   itemData.qty=1;
    // }
    // itemsList.refresh();
    itemsList.clear();

    getTotalItemsList();
    getInvoiceTotalAndPayableAmount();
    onDiscountInPercentageValueChange();
  }
}
