import 'dart:io';
import 'dart:typed_data';

import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/model/filters.dart';
import 'package:bms/app/common/route_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/base/model/response/transaction_response_model.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/base/model/response/donwload_pdf_response_model.dart';
import 'package:bms/app/services/repository/customer_repository.dart';
import 'package:bms/app/services/repository/transaction_repository.dart';
import 'package:bms/app/utils/number_formatter/number_formatter.dart';
import 'package:get/get.dart';
import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/local_storage_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/customer_base_screen/base/model/response/get_customer_response_model.dart';
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
import 'package:bms/app/utils/return_string_as_fixed_value.dart';
import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';

class InvoiceBaseController extends GetxController {
  RxInt currentTabValue = 1.obs;
  RxBool isFilterApplied = false.obs;

  RxInt pageNumber = 0.obs;
  String bizId = '';
  RxString customerNameValue = ''.obs;
  RxString productNameValue = ''.obs;

  RxInt invoiceNo = 0.obs;

  Rx<AllCustomerData> customerData = AllCustomerData().obs;
  RxList<AllCustomerData> customerDataList =
      List<AllCustomerData>.empty(growable: true).obs;

  TextEditingController searchInvoiceController = TextEditingController();
  RxString searchTransStr = ''.obs;

  /// search customer list
  RxList<AllCustomerData> searchCustomerList =
      List<AllCustomerData>.empty(growable: true).obs;

  /// discountAmount, discountPercentage, additionalCharges, productName, barCode text-fields
  TextEditingController discountInAmountTextField =
      TextEditingController(text: '0');
  TextEditingController discountInPercentageTextField =
      TextEditingController(text: '0');
  TextEditingController additionalChargeTextField =
      TextEditingController(text: '0');
  TextEditingController customerNameController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController barCodeController = TextEditingController();

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

  /// main transaction list
  RxList<TransactionsResponseModel> transList =
      List<TransactionsResponseModel>.empty(growable: true).obs;

  /// search transaction list
  RxList<TransactionsResponseModel> searchTransList =
      List<TransactionsResponseModel>.empty(growable: true).obs;

  /// transaction list
  RxList<TransactionsResponseModel> appliedFilterTransList =
      List<TransactionsResponseModel>.empty(growable: true).obs;

  /// transaction filter list
  RxList<Filters> transFiltersList = List<Filters>.empty(growable: true).obs;
  RxList<Filters> transFiltersList2 = List<Filters>.empty(growable: true).obs;

  /// invoice details data
  Rx<GetInvoiceDetailsResponseModel> invoiceDetailsData =
      GetInvoiceDetailsResponseModel().obs;

  /// previous screen invoice intent data
  Rx<InvoiceDetailData> intentInvoiceData = InvoiceDetailData().obs;

  /// initialization of invoiceTotal and invoicePayable
  RxString invoiceTotal = '0'.obs;
  RxString invoicePayable = '0'.obs;

  /// focus node values
  RxBool isFocusOnCustomerNameField = false.obs;
  RxBool isFocusOnProductNameField = false.obs;
  RxBool isFocusOnBarcodeField = false.obs;

  /// validation values
  RxBool isValidCustomerName = false.obs;
  RxBool isValidProductName = false.obs;
  RxBool isValidBarcode = false.obs;

  /// validation strings
  RxString customerNameStr = ''.obs;
  RxString productNameStr = ''.obs;
  RxString barCodeStr = ''.obs;

  /// while data loading from server bool value
  RxBool isDataLoading = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    Get.lazyPut(() => ProductRepository(), fenix: true);
    Get.lazyPut(() => ServiceRepository(), fenix: true);
    Get.lazyPut(() => CustomerRepository(), fenix: true);
    Get.lazyPut(() => InvoiceRepository(), fenix: true);
    Get.lazyPut(() => TransactionRepository(), fenix: true);
    bizId = await Get.find<LocalStorage>().getStringFromStorage(kStorageBizId);
    await getAllCustomerListFromServer();
    await getAllProductsListFromServer();
    await getAllServicesListFromServer();
    await getTransactionDataFromServer();
    getTotalItemsList();
    setTransFilters();
    Get.find<BottomNavBaseController>().tabIndex.listen((p0) {
      if (p0 == 2) {
        isFilterApplied.value = false;
        searchInvoiceController.text = '';
        searchTransStr.value = '';
        searchTransList.value = [];
        transList.clear();
        appliedFilterTransList.clear();
        transFiltersList.clear();
        transFiltersList2.clear();
        getTransactionDataFromServer();
        setTransFilters();
      }
    });
  }

  /// set transaction filters
  void setTransFilters() {
    transFiltersList.add(
        Filters(filterName: kAscOrder, isSelected: false, sortName: kAToZ));
    transFiltersList.add(
        Filters(filterName: kDscOrder, isSelected: false, sortName: kZToA));
    transFiltersList2.add(Filters(
        filterName: kLabelPaid, isSelected: false, sortName: kLabelPaid));
    transFiltersList2.add(Filters(
        filterName: kLabelUnPaid, isSelected: false, sortName: kLabelUnPaid));
    transFiltersList2.add(Filters(
        filterName: kLabelPartialPaid,
        isSelected: false,
        sortName: kLabelPartialPaid));
    transFiltersList2.add(Filters(
        filterName: kLabelCancelled,
        isSelected: false,
        sortName: kLabelCancel));
  }

  /// get all customer list from server
  Future<void> getAllCustomerListFromServer() async {
    isDataLoading.value = true;
    try {
      var response = await Get.find<CustomerRepository>().getAllCustomerList(
        bizId: bizId,
        pageNumber: pageNumber.value.toString(),
        // headers: await CommonHeader().headers(),
      );

      if (response != null && response.statusCode == 100) {
        var res = decodeResponseData(responseData: response.data ?? '');
        if (res != null && res != '') {
          var tempList = allCustomerDataFromJson(res);

          customerDataList.addAll(tempList);
        }
      } else {
        Get.find<AlertMessageUtils>().showErrorSnackBar(response?.msg ?? '');
      }
      isDataLoading.value = false;
    } catch (e) {
      isDataLoading.value = false;
      LoggerUtils.logException('getAllCustomerListFromServer', e);
    }
  }

  // /// assigning customerData from intent value
  // Future<void> setIntentData({required dynamic intentData}) async {
  //   try {
  //     customerData.value = (intentData[0] as AllCustomerData);
  //     bizId =
  //         await Get.find<LocalStorage>().getStringFromStorage(kStorageBizId);
  //     await getAllProductsListFromServer();
  //     await getAllServicesListFromServer();
  //     getTotalItemsList();
  //   } catch (e) {
  //     LoggerUtils.logException('setIntentData', e);
  //   }
  // }

  /// update focus based on field selection
  void changeFocus({required bool hasFocus, required int fieldNumber}) {
    /// 1 : product name , 2 : barcode , 3 : customer name
    if (fieldNumber == 1) {
      isFocusOnProductNameField.value = hasFocus;
    } else if (fieldNumber == 2) {
      isFocusOnBarcodeField.value = hasFocus;
    } else if (fieldNumber == 3) {
      isFocusOnCustomerNameField.value = hasFocus;
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
      var response = await Get.find<ProductRepository>()
          .getAllProductsDataFromServer(
              bizId: bizId, pageNumber: pageNumber.toString());

      if (response != null && response.statusCode == 100) {
        var res = decodeResponseData(responseData: response.data ?? '');
        if (res != null && res != '') {
          var tempList = allProductsDataFromJson(res);
          allProductsDataList.addAll(tempList);
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
      var response = await Get.find<ServiceRepository>()
          .getAllServicesDataFromServer(
              bizId: bizId, pageNumber: pageNumber.toString());

      if (response != null && response.statusCode == 100) {
        var res = decodeResponseData(responseData: response.data ?? '');
        if (res != null && res != '') {
          var tempList = allServicesDataFromJson(res);
          allServicesDataList.addAll(tempList);
        }
      } else {
        Get.find<AlertMessageUtils>().showErrorSnackBar(response?.msg ?? '');
      }
    } catch (e) {
      LoggerUtils.logException('getAllProductsListFromServer', e);
    }
  }

  /// get all transactions from server
  Future<void> getTransactionDataFromServer() async {
    isDataLoading.value = true;
    try {
      var response = await Get.find<TransactionRepository>()
          .getAllTransactionDataFromServer(bizId: bizId, pageNumber: '-1');
      if (response != null && response.data != null) {
        var res = decodeResponseData(responseData: response.data ?? '');
        if (res != null && res != '') {
          var tempList = transactionsResponseModelFromJson(res);
          transList.addAll(tempList);
          appliedFilterTransList.addAll(tempList);
        }
      }
      isDataLoading.value = false;
    } catch (e) {
      isDataLoading.value = false;
      LoggerUtils.logException('getTransactionDataFromServer', e);
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

      getItemTotalValues();
      addingPriceAndQtyTextFieldListValues();
      // getItemTotalValues();
    } catch (e) {
      LoggerUtils.logException('getTotalItemsList', e);
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

      /// manage when selectItem list is empty then reset discount data
      if (selectedItemsList.isEmpty) {
        discountInAmountTextField.text = '0';
        discountInPercentageTextField.text = '0';
      } else {
        onDiscountInPercentageValueChange();
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

    for (AllProductsData itemData in allProductsDataList) {
      for (DropdownCommonData unit in BottomNavBaseController.unitList) {
        // if (unit.id == allProductsDataList[index].unitId) {
        if (unit.id == itemData.unitId) {
          unitName = unit.name ?? '';
          return unitName;
        }
      }
    }
    return unitName;
  }

  /// return match gst rate from gstRateList
  String returnGstRate({required int index}) {
    String gstRate = '';

    for (DropdownCommonData gstRateData
        in BottomNavBaseController.gstRateList) {
      if (gstRateData.id == allProductsDataList[index].gstRateId) {
        gstRate = (gstRateData.value ?? 0.0).toStringAsFixed(2);
        return gstRate;
      }
    }
    return gstRate;
  }

  void onProductNameValueChange() {
    searchItemsList.clear();
    if (itemsList.isNotEmpty) {
      for (TotalProductServiceData itemData in itemsList) {
        if ((itemData.name ?? '')
            .toLowerCase()
            .contains(productNameValue.value)) {
          searchItemsList.add(itemData);
        }
      }
    }
    // searchItemsList.refresh();
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
          isMatched = true;
          addToList();
          FocusScope.of(Get.overlayContext!).unfocus();
        }
        // }
      }
    }
    // searchItemsList.refresh();
  }

  void onCustomerNameValueChange() {
    searchCustomerList.clear();
    if (customerDataList.isNotEmpty) {
      for (AllCustomerData customerData in customerDataList) {
        if ((customerData.name ?? '')
            .toLowerCase()
            .contains(customerNameValue.value)) {
          searchCustomerList.add(customerData);
        }
      }
    }
  }

  /// adding selected product to selectedItemList
  void addToList() {
    for (TotalProductServiceData itemData in itemsList) {
      if (itemData.isSelected == true && itemData.isAddedToList == false) {
        selectedItemsList.add(itemData);
        // itemData.isAddedToList = !(itemData.isAddedToList ?? false);
        itemData.isAddedToList = true;
      }
    }
    itemsList.refresh();
    selectedItemsList.value = selectedItemsList.reversed.toList();
    isFocusOnProductNameField.value = false;
    selectedItemsList.refresh();
    productNameController.text = '';
    barCodeController.text = '';
    productNameValue.value = '';
    addingPriceAndQtyTextFieldListValues();
    getItemTotalValues();
  }

  void updateSelectedTileValues(
      {required bool isSelected, required TotalProductServiceData itemData}) {
    int index =
        itemsList.indexWhere((element) => element.itemId == itemData.itemId);

    itemData.isSelected = !(itemData.isSelected ?? false);
    itemsList.refresh();

    if (productNameValue.trim().isNotEmpty) {
      int searchIndex = searchItemsList
          .indexWhere((element) => element.itemId == itemData.itemId);

      searchItemsList[searchIndex].isSelected = !isSelected;
      searchItemsList.refresh();
    }
  }

  void onCustomerSelection({
    required bool isSelected,
    required AllCustomerData custData,
    required int index,
  }) {
    // int i =
    //     customerDataList.indexWhere((element) => element.isSelected == true);

    // if (i != -1) {
    //   customerDataList[i].isSelected = true;
    //   customerData.value = custData;
    // }
    // customerDataList[index].isSelected = false;

    // custData.isSelected = !(custData.isSelected ?? false);

    for (int i = 0; i < customerDataList.length; i++) {
      if (i == index) {
        customerDataList[i].isSelected =
            !(customerDataList[i].isSelected ?? false);
      } else {
        customerDataList[i].isSelected = false;
      }
    }
    int i =
        customerDataList.indexWhere((element) => element.isSelected == true);
    if (i != -1) {
      customerData.value = custData;
    } else {
      customerData.value = AllCustomerData();
      customerNameController.text = '';
    }
    customerDataList.refresh();

    if (customerNameValue.trim().isNotEmpty) {
      for (int i = 0; i < searchCustomerList.length; i++) {
        if (i == index) {
          searchCustomerList[i].isSelected =
              !(searchCustomerList[i].isSelected ?? false);
        } else {
          searchCustomerList[i].isSelected = false;
        }
      }
      int i = searchCustomerList
          .indexWhere((element) => element.isSelected == true);
      if (i != -1) {
        customerData.value = custData;
      } else {
        customerData.value = AllCustomerData();
        customerNameController.text = '';
      }
    }

    customerNameController.text = custData.name ?? '';
    customerData.refresh();
    FocusScope.of(Get.overlayContext!).unfocus();
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
      for (TotalProductServiceData itemData in selectedItemsList) {
        total = total + (itemData.itemTotal ?? 0.0);
      }

      invoiceTotal.value = returnToStringAsFixed(value: total);
      // String payableAmount = returnToStringAsFixed(value: total);
      invoicePayable.value = returnToStringAsFixed(
          value:
              ((total - double.parse(discountInAmountTextField.text.trim())) +
                  double.parse(additionalChargeTextField.text.trim())));
    } else {
      invoiceTotal.value = '0';
      invoicePayable.value = '0';
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
      selectedItemsList[index].qty = double.parse(qtyTextFieldList[index].text);
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
    }
  }

  /// onChange priceTextFieldList values
  void onPriceValueChange({required int index, bool isOnChange = true}) {
    if (isOnChange) {
      selectedItemsList[index].sellPrice =
          double.parse(priceTextFieldList[index].text.trim());
      selectedItemsList.refresh();
      discountInPercentageTextField.text = '0';
      discountInAmountTextField.text = '0';
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
              double.parse(invoiceTotal.value)) {
        discountAmount = discountInAmountTextField.text.trim().isEmpty
            ? 0
            : double.parse(discountInAmountTextField.text);

        payableAmount = ((double.parse(invoiceTotal.value) - discountAmount) +
            additionalCharge);
      } else {
        payableAmount = (double.parse(invoiceTotal.value) + additionalCharge);
      }
      invoicePayable.value = returnToStringAsFixed(value: payableAmount);

      double percentage = calculateDiscountPercentage(
          discountPrice: discountAmount,
          totalAmount: double.parse(invoiceTotal.value));
      discountInPercentageTextField.text =
          returnToStringAsFixed(value: percentage);
    } else {
      if (discountInAmountTextField.text.trim().isEmpty) {
        discountInAmountTextField.text = '0';
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
            totalAmount: double.parse(invoiceTotal.value),
            additionalCharges: additionalCharge,
            discountPercentage: discountPercentage);
        discountInAmountTextField.text =
            returnToStringAsFixed(value: discountAmount);
        payableAmount = ((double.parse(invoiceTotal.value) - discountAmount) +
            additionalCharge);
      } else if (discountInPercentageTextField.text.trim().length > 3 ||
          double.parse(discountInPercentageTextField.text) >= 100) {
        FocusScope.of(Get.overlayContext!).unfocus();
        discountInAmountTextField.text = invoiceTotal.value;
        discountInPercentageTextField.text = '100';
        payableAmount = (double.parse(invoiceTotal.value) * 2);
      } else {
        discountInAmountTextField.text = '0';
        discountInAmountTextField.text = '0';
        payableAmount = (double.parse(invoiceTotal.value) + additionalCharge);
      }
      invoicePayable.value = returnToStringAsFixed(value: payableAmount);
    } else {
      if (discountInPercentageTextField.text.trim().isEmpty) {
        discountInPercentageTextField.text = '0';
        discountInAmountTextField.text = '0';
      }
    }
  }

  /// onChange additionalChargeTextField values
  void onAdditionalChargeValueChange({bool isOnChange = true}) {
    if (isOnChange) {
      double additionalCharge = 0.0;
      double payableAmount = 0.0;
      if (additionalChargeTextField.text.trim().isNotEmpty &&
          double.parse(additionalChargeTextField.text) <=
              double.parse(invoiceTotal.value)) {
        additionalCharge = additionalChargeTextField.text.trim().isEmpty
            ? 0
            : double.parse(additionalChargeTextField.text);

        // payableAmount = (double.parse(invoiceTotal.value) + additionalCharge);
        payableAmount = ((double.parse(invoiceTotal.value) -
                double.parse(discountInAmountTextField.text.trim())) +
            additionalCharge);
      } else {
        payableAmount = (double.parse(invoiceTotal.value) -
            double.parse(discountInAmountTextField.text.trim()));
      }
      invoicePayable.value = returnToStringAsFixed(value: payableAmount);
    } else {
      if (additionalChargeTextField.text.trim().isEmpty) {
        additionalChargeTextField.text = '0';
      }
    }
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
      if (selectedItemsList.isNotEmpty) {
        generateInvoiceApi();
      } else {
        Get.find<AlertMessageUtils>()
            .showErrorSnackBar(kPleaseSelectItemToGenerateInvoice);
      }
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
              gstRateId: itemData.gstRateId,
            ),
          );
        } else {
          serviceList.add(
            ServiceList(
              sellingPrice: itemData.sellPrice,
              qty: itemData.qty,
              unitId: itemData.unitId,
              itemId: itemData.itemId,
              gstRateId: itemData.gstRateId,
            ),
          );
        }
      }

      var requestModel = GenerateInvoiceRequestModel(
        bizId: int.parse(bizId),
        custId: customerData.value.custId,
        productList: productList,
        serviceList: serviceList,
        totalAmount: double.parse(invoiceTotal.value).toPrecision(2),
        discountAmount:
            double.parse(discountInAmountTextField.text.trim()).toPrecision(2),
        additionalCharge:
            double.parse(additionalChargeTextField.text.trim()).toPrecision(2),
      );
      var response = await Get.find<InvoiceRepository>()
          .generateOrUpdateInvoiceApi(
              requestModel: requestModel, isForUpdateInvoice: false);

      if (response != null && response.data != null) {
        if (response.statusCode == 100) {
          resetInvoiceAllData();
        } else {
          Get.find<AlertMessageUtils>().showErrorSnackBar(response.msg ?? '');
        }
      }
    } catch (e) {
      LoggerUtils.logException('generateInvoiceApi', e);
    }
  }

  void resetInvoiceAllData() {
    discountInPercentageTextField.text = '0';
    discountInAmountTextField.text = '0';
    additionalChargeTextField.text = '0';

    invoiceTotal.value = '0';
    invoicePayable.value = '0';

    searchItemsList.clear();
    selectedItemsList.clear();
    customerData.value = AllCustomerData();
    searchCustomerList.clear();
  }

  String returnPaymentTag({required int status}) {
    String paymentTag = '';
    if (status == 1) {
      paymentTag = kLabelPaid;
    } else if (status == 2) {
      paymentTag = kLabelPartialPaid;
    } else if (status == 3) {
      paymentTag = kLabelUnPaid;
    } else if (status == 4) {
      paymentTag = kLabelCancelled;
    }

    return paymentTag;
  }

  Future<void> navigateToAddInvoiceScreen() async {
    bool isAdded =
        await Get.toNamed(kRouteGenerateInvoiceWithCustomerSelection);
    if (isAdded) {
      transList.clear();
      clearFilter();
      getTransactionDataFromServer();
    }
  }

  void navigateToViewInvoiceScreen(
      {required TransactionsResponseModel transData}) {
    AllCustomerData custData = AllCustomerData(
      name: transData.custName,
      emailId: transData.emailID,
      mobileNo: transData.mobileNumber,
    );

    InvoiceDetailData invData = InvoiceDetailData(
      invoiceId: transData.id,
      createdOn: transData.createdOn,
      status: transData.status,
      invNo: transData.invoiceNo,
      totalAmount: transData.payableAmount,
      collected: transData.collected,
    );
    Get.toNamed(kRouteViewInvoiceScreen, arguments: [
      custData,
      invData,
    ]);
  }

  Future<void> navigateToUpdateInvoiceScreen(
      {required TransactionsResponseModel transData}) async {
    AllCustomerData custData = AllCustomerData(
      name: transData.custName,
      emailId: transData.emailID,
      mobileNo: transData.mobileNumber,
    );

    InvoiceDetailData invData = InvoiceDetailData(
      invoiceId: transData.id,
      createdOn: transData.createdOn,
      status: transData.status,
      invNo: transData.invoiceNo,
      totalAmount: transData.payableAmount,
      collected: transData.collected,
    );
    bool isAdded = await Get.toNamed(
      kRouteGenerateInvoiceScreen,
      arguments: [
        custData,
        true,
        invData,
      ],
    );

    if (isAdded == true) {
      transList.clear();
      clearFilter();
      // getTransactionDataFromServer();

    } else {}
  }

  Future<void> navigateToPayInScreen(
      {required TransactionsResponseModel transData}) async {
    InvoiceDetailData invData = InvoiceDetailData(
      custId: transData.custId,
      invoiceId: transData.id,
      createdOn: transData.createdOn,
      status: transData.status,
      invNo: transData.invoiceNo,
      totalAmount: transData.payableAmount,
      collected: transData.collected,
    );
    bool isUpdated =
        await Get.toNamed(kRouteInvoicePayInScreen, arguments: [invData]);

    if (isUpdated == true) {
      transList.clear();
      clearFilter();
      getTransactionDataFromServer();

      true;
    }
  }

  /// cancel invoice api call
  Future<void> cancelInvoice({required String invoiceId}) async {
    try {
      var response = await Get.find<InvoiceRepository>()
          .cancelInvoiceApi(bizId: bizId, invoiceId: invoiceId);

      if (response != null && response.statusCode == 100) {
        transList.clear();
        clearFilter();
        // await getTransactionDataFromServer();
      }
    } catch (e) {
      LoggerUtils.logException('cancelInvoice', e);
    }
  }

  /// download invoice pdf data from server
  Future<void> downloadInvoicePdfDataFromServer(
      {required String invoiceId,
      required String invoiceNo,
      bool? isShareFile = false}) async {
    try {
      var response = await Get.find<InvoiceRepository>()
          .downloadInvoicePDFApi(bizId: bizId, invoiceId: invoiceId);

      if (response != null && response.data != null) {
        var res = decodeResponseData(responseData: response.data ?? '');

        if (res != null && res != '') {
          List<int> dataByteArray = downloadPdfResponseModelFromJson(res);
          writeByteArrayToFileAndStoreInDevice(
              dataByteArray: dataByteArray,
              invoiceId: invoiceId,
              invoiceNo: invoiceNo,
              isShareFile: isShareFile ?? false);
        }
      }
    } catch (e) {
      LoggerUtils.logException('downloadInvoicePdfDataFromServer', e);
    }
  }

  /// write byte array to file and storing file to user device
  Future<void> writeByteArrayToFileAndStoreInDevice(
      {required List<int> dataByteArray,
      required String invoiceNo,
      required String invoiceId,
      required bool isShareFile}) async {
    try {
      Uint8List uInt8list = Uint8List.fromList(dataByteArray);
      final directory = Directory('/storage/emulated/0/Download');
      final path = directory.path;
      final file = File('$path/invoice $invoiceNo.pdf');
      file.writeAsBytes(uInt8list);
      Get.snackbar(
        'Download invoice successfully',
        '',
        backgroundColor: kColorGreen,
        colorText: kColorWhite,
        snackPosition: SnackPosition.BOTTOM,
      );
      if (isShareFile) {
        shareInvoicePdf(invoiceId: invoiceId, invoiceNo: invoiceNo);
      } else {
        Get.toNamed(kRoutePreviewInvPdfScreen, arguments: [file]);
      }
    } catch (e) {
      LoggerUtils.logException('writeByteArrayToFileAndStoreInDevice', e);
    }
  }

  Future<void> shareInvoicePdf(
      {required String invoiceId, required String invoiceNo}) async {
    try {
      final directory = Directory('/storage/emulated/0/Download');
      final path = directory.path;

      bool isExist = await File('$path/invoice $invoiceNo.pdf').exists();
      if (isExist) {
        Share.shareFiles(['$path/invoice $invoiceNo.pdf']);
      } else {
        downloadInvoicePdfDataFromServer(
          invoiceId: invoiceId,
          invoiceNo: invoiceNo,
          isShareFile: true,
        );
      }
    } catch (e) {
      LoggerUtils.logException('shareInvoicePdf', e);
    }
  }

  void updateFilterStatus({required int i}) {
    int index =
        transFiltersList.indexWhere((element) => element.isSelected == true);
    if (index != -1 && i != index) {
      transFiltersList[index].isSelected = false;
    }
    transFiltersList[i].isSelected = !transFiltersList[i].isSelected;
    transFiltersList.refresh();
  }

  void updateTransStatusFilterStatus({required int i}) {
    int index =
        transFiltersList2.indexWhere((element) => element.isSelected == true);
    if (index != -1 && i != index) {
      transFiltersList2[index].isSelected = false;
    }
    transFiltersList2[i].isSelected = !transFiltersList2[i].isSelected;
    transFiltersList2.refresh();
  }

  void applyFilter() {
    String appliedFilter = '';

    /// first filter apply
    int i =
        transFiltersList.indexWhere((element) => element.isSelected == true);
    if (i != -1) {
      appliedFilter = transFiltersList[i].sortName;
    }

    if (appliedFilter == kAToZ) {
      appliedFilterTransList.clear();
      appliedFilterTransList.addAll(transList);
      appliedFilterTransList
          .sort((a, b) => (a.custName ?? '').compareTo(b.custName ?? ''));
      appliedFilterTransList.refresh();
    } else if (appliedFilter == kZToA) {
      appliedFilterTransList.clear();
      appliedFilterTransList.addAll(transList);
      appliedFilterTransList
          .sort((a, b) => (b.custName ?? '').compareTo(a.custName ?? ''));
      appliedFilterTransList.refresh();
    }

    /// status filter apply
    int j = transFiltersList2.indexWhere((element) => element.isSelected);
    List<TransactionsResponseModel> tempFilter = [];

    if (j != -1) {
      appliedFilter = transFiltersList2[j].sortName;
    }

    /// managing first filter apply values
    if (i != -1) {
      tempFilter.addAll(appliedFilterTransList);
      appliedFilterTransList.clear();
    } else if (i == -1 || i == 0) {
      // appliedFilter = transFiltersList2[j].sortName;
      tempFilter.addAll(transList);
      appliedFilterTransList.clear();
    }
    // else if (j == -1) {
    //   appliedFilterTransList.clear();
    //   tempFilter.addAll(transList);
    // }

    if (appliedFilter == kLabelPaid) {
      for (var transData in tempFilter) {
        if (transData.status == 1) {
          appliedFilterTransList.add(transData);
        }
      }
      appliedFilterTransList.refresh();
    } else if (appliedFilter == kLabelPartialPaid) {
      for (var transData in tempFilter) {
        if (transData.status == 2) {
          appliedFilterTransList.add(transData);
        }
      }
      appliedFilterTransList.refresh();
    } else if (appliedFilter == kLabelUnPaid) {
      for (var transData in tempFilter) {
        if (transData.status == 3) {
          appliedFilterTransList.add(transData);
        }
      }
      appliedFilterTransList.refresh();
    } else if (appliedFilter == kLabelCancel) {
      for (var transData in tempFilter) {
        if (transData.status == 4) {
          appliedFilterTransList.add(transData);
        }
      }
      appliedFilterTransList.refresh();
    } else {
      appliedFilterTransList.addAll(tempFilter);
    }

    if (i != -1 || j != -1) {
      isFilterApplied.value = true;
    } else {
      isFilterApplied.value = false;
    }
    Get.back();
  }

  void clearFilter() {
    int i =
        transFiltersList.indexWhere((element) => element.isSelected == true);
    int j =
        transFiltersList2.indexWhere((element) => element.isSelected == true);
    if (i != -1) {
      transFiltersList[i].isSelected = false;
    }
    if (j != -1) {
      transFiltersList2[j].isSelected = false;
    }
    isFilterApplied.value = false;
    // transList.clear();
    appliedFilterTransList.clear();
    // getTransactionDataFromServer();
    transFiltersList.refresh();
    transFiltersList2.refresh();
    appliedFilterTransList.addAll(transList);
  }

  void onSearchValueChange() {
    searchTransList.clear();
    try {
      for (var transData in appliedFilterTransList) {
        if ((transData.custName ?? '')
                .toLowerCase()
                .contains(searchTransStr.toLowerCase()) ||
            ((transData.invoiceNo ?? 0)
                .toString()
                .contains(searchTransStr.toLowerCase()))) {
          searchTransList.add(transData);
        }
      }
    } catch (e) {
      LoggerUtils.logException('onSearchValueChange', e);
    }
  }

  /// returning due amount values based on amount and invoice-status
  String returnDueAmountText({required TransactionsResponseModel transData}) {
    if (transData.status == 4 || transData.status == 1) {
      return '-';
    } else {
      return '$kRupee${returnFormattedNumber(values: double.parse(returnToStringAsFixed(value: calculateDueAmount(totalSellAmount: transData.payableAmount ?? 0.0, totalCollectedAmount: transData.collected ?? 0.0))))}';
    }
  }
}
