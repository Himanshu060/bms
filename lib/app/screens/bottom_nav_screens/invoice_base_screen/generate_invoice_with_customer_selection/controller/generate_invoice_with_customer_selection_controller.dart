import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/route_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/customer_base_screen/add_customer/model/request/add_customer_request_modell.dart';
import 'package:bms/app/services/repository/customer_repository.dart';
import 'package:bms/app/utils/number_formatter/number_formatter.dart';
import 'package:bms/app/utils/regex.dart';
import 'package:bms/app/utils/text_styles.dart';
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
import 'package:quickalert/quickalert.dart';

class GenerateInvoiceWithCustomerSelectionController extends GetxController {
  RxInt currentTabValue = 1.obs;

  double custTextFieldHeight = 55;
  double custTextFieldWidth = 40;

  EdgeInsets custTextFieldContentPadding =
      EdgeInsets.only(left: 20.0, bottom: 10, top: 10);
  EdgeInsets custErrorValidationPadding = EdgeInsets.only(left: 10, bottom: 4);

  double summaryTextFieldHeight = 40;
  double summaryTextFieldWidth = Get.width * 0.42;

  RxInt pageNumber = 0.obs;
  String bizId = '';
  RxString customerNameValue = ''.obs;
  RxString productNameValue = ''.obs;

  RxInt invoiceNo = 0.obs;
  RxBool isShowAddCustomer = false.obs;
  RxBool isItemPriceEditable = false.obs;

  Rx<AllCustomerData> customerData = AllCustomerData().obs;
  RxList<AllCustomerData> customerDataList =
      List<AllCustomerData>.empty(growable: true).obs;

  /// search customer list
  RxList<AllCustomerData> searchCustomerList =
      List<AllCustomerData>.empty(growable: true).obs;

  /// discountAmount, discountPercentage, additionalCharges, productName, barCode text-fields
  TextEditingController discountInAmountTextField = TextEditingController();
  TextEditingController discountInPercentageTextField = TextEditingController();
  TextEditingController additionalChargeTextField = TextEditingController();

  Rx<TextEditingController> selectedCustomerNameController =
      TextEditingController().obs;
  TextEditingController selectedCustomerMobileNoController =
      TextEditingController();
  TextEditingController selectedCustomerEmailIdController =
      TextEditingController();

  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerMobileNoController = TextEditingController();
  TextEditingController customerEmailIdController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController barCodeController = TextEditingController();
  TextEditingController receivedAmountController = TextEditingController();

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
  TextEditingController invoiceTotal = TextEditingController(text: '0');
  TextEditingController invoicePayable = TextEditingController(text: '0');

  // RxString invoiceTotal = '0'.obs;
  // RxString invoicePayable = '0'.obs;

  /// focus node values
  RxBool isFocusOnCustomerNameField = false.obs;
  RxBool isFocusOnProductNameField = false.obs;
  RxBool isFocusOnBarcodeField = false.obs;
  RxBool isFocusOnMobileNoField = false.obs;
  RxBool isFocusOnEmailIdField = false.obs;

  /// validation values
  RxBool isValidCustomerName = false.obs;
  RxBool isValidProductName = false.obs;
  RxBool isValidBarcode = false.obs;
  RxBool isValidPhoneNumber = false.obs;
  RxBool isValidEmailId = true.obs;

  /// validation strings
  RxString customerNameStr = ''.obs;
  RxString productNameStr = ''.obs;
  RxString barCodeStr = ''.obs;
  RxString customerMobileStr = ''.obs;
  RxString customerEmailStr = ''.obs;

  /// while data loading from server bool value
  RxBool isDataLoading = true.obs;

  RxBool isButtonEnable = false.obs;
  RxBool isAddCustButtonEnable = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    Get.lazyPut(() => ProductRepository(), fenix: true);
    Get.lazyPut(() => ServiceRepository(), fenix: true);
    Get.lazyPut(() => CustomerRepository(), fenix: true);
    Get.lazyPut(() => InvoiceRepository(), fenix: true);
    bizId = await Get.find<LocalStorage>().getStringFromStorage(kStorageBizId);
    isItemPriceEditable.value = await Get.find<LocalStorage>().getBoolFromStorage(kStorageIsSellPriceEditable)??false;
    await getAllCustomerListFromServer();
    await getAllProductsListFromServer();
    await getAllServicesListFromServer();
    getTotalItemsList();
  }

  /// navigate to import device contacts screen
  Future<void> navigateToImportContactsScreen() async {
    var selectedContactData =
        await Get.toNamed(kRouteImportDeviceContactsScreen);

    customerNameController.text = selectedContactData.displayName ?? '';
    customerMobileNoController.text = selectedContactData.phoneNumber ?? '';
    customerMobileStr.value = '';
    customerNameStr.value = '';
    isValidPhoneNumber.value = true;
    isValidCustomerName.value = true;
    // isButtonEnable.value = true;
    isAddCustButtonEnable.value = true;
  }

  /// get all customer list from server
  Future<void> getAllCustomerListFromServer() async {
    isDataLoading.value = true;
    try {
      var response = await Get.find<CustomerRepository>().getAllCustomerList(
        bizId: bizId,
        pageNumber: '-1',
        // pageNumber: pageNumber.value.toString(),
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
    /// 1 : product name , 2 : barcode , 3 : customer name , 4 : mobile no. , 5 : emailId
    if (fieldNumber == 1) {
      isFocusOnProductNameField.value = hasFocus;
    } else if (fieldNumber == 2) {
      isFocusOnBarcodeField.value = hasFocus;
    } else if (fieldNumber == 3) {
      isFocusOnCustomerNameField.value = hasFocus;
    } else if (fieldNumber == 4) {
      isFocusOnMobileNoField.value = hasFocus;
    } else if (fieldNumber == 5) {
      isFocusOnEmailIdField.value = hasFocus;
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
      var response = await Get.find<ServiceRepository>()
          .getAllServicesDataFromServer(
              bizId: bizId, pageNumber: pageNumber.toString());

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
        discountInAmountTextField.text = '';
        discountInPercentageTextField.text = '';
        additionalChargeTextField.text = '';
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
          itemData.isAddedToList = true;
          isMatched = true;
          addToList(barCodeValue:  itemData.qrBarCode??'');
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
  void addToList(
      {bool? isComingFromSearchItemScreen = false,
      List<TotalProductServiceData>? selectedList,String? barCodeValue}) {
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

    // for (int i = 0; i < customerDataList.length; i++) {
    //   if (i == index) {
    //     customerDataList[i].isSelected =
    //         !(customerDataList[i].isSelected ?? false);
    //   } else {
    //     customerDataList[i].isSelected = false;
    //   }
    // }

    int selectedIndex =
        customerDataList.indexWhere((element) => element.isSelected == true);
    if (selectedIndex != -1 && selectedIndex != index) {
      customerDataList[selectedIndex].isSelected = false;
    }
    customerDataList[index].isSelected =
        !(customerDataList[index].isSelected ?? false);
    int i =
        customerDataList.indexWhere((element) => element.isSelected == true);
    if (i != -1) {
      customerData.value = custData;
      selectedCustomerNameController.value.text = custData.name ?? '';
      selectedCustomerMobileNoController.text =
          (custData.mobileNo ?? 0).toString();
      selectedCustomerEmailIdController.text = custData.emailId ?? '';
      isButtonEnable.value = true;
    } else {
      customerData.value = AllCustomerData();
      selectedCustomerNameController.value.text = '';
      selectedCustomerMobileNoController.text = '';
      selectedCustomerEmailIdController.text = '';
      isButtonEnable.value = false;
    }
    selectedCustomerNameController.refresh();
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
        selectedCustomerNameController.value.text = custData.name ?? '';
        selectedCustomerMobileNoController.text =
            (custData.mobileNo ?? 0).toString();
        selectedCustomerEmailIdController.text = custData.emailId ?? '';
        isButtonEnable.value = true;
      } else {
        customerData.value = AllCustomerData();
        selectedCustomerNameController.value.text = '';
        selectedCustomerMobileNoController.text = '';
        selectedCustomerEmailIdController.text = '';
        isButtonEnable.value = false;
      }
    }

    // customerNameController.text = custData.name ?? '';
    customerData.refresh();
    customerNameStr.value = '';
    isFocusOnCustomerNameField.value = false;
    FocusScope.of(Get.overlayContext!).unfocus();
    Get.back();
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
      }

      invoiceTotal.text = returnFormattedNumber(values: double.parse(returnToStringAsFixed(value: total)));
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
      double qty = qtyTextFieldList[index].text.isEmpty ||   double.parse(qtyTextFieldList[index].text) <= 1
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
          double.parse(priceTextFieldList[index].text.trim());
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
              double.parse(invoiceTotal.text.replaceAll(',',''))) {
        discountAmount = discountInAmountTextField.text.trim().isEmpty
            ? 0
            : double.parse(discountInAmountTextField.text);

        payableAmount = ((double.parse(invoiceTotal.text.replaceAll(',','')) - discountAmount) +
            additionalCharge);
      } else {
        payableAmount = (double.parse(invoiceTotal.text.replaceAll(',','')) + additionalCharge);
      }

      invoicePayable.text = returnFormattedNumber(values: double.parse(returnToStringAsFixed(value: payableAmount)));

      double percentage = calculateDiscountPercentage(
          discountPrice: discountAmount,
          totalAmount: double.parse(invoiceTotal.text.replaceAll(',','')));
      if (discountInAmountTextField.text.trim().isEmpty ||
          discountInAmountTextField.text.trim() == '0') {
        discountInPercentageTextField.text = '';
      }
      if (discountInAmountTextField.text.trim().isNotEmpty &&
          discountInAmountTextField.text.trim() != '0') {
        discountInPercentageTextField.text =
            returnToStringAsFixed(value: percentage);
      }
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
            totalAmount: double.parse(invoiceTotal.text.replaceAll(',','')),
            additionalCharges: additionalCharge,
            discountPercentage: discountPercentage);
        discountInAmountTextField.text =
            returnToStringAsFixed(value: discountAmount);
        payableAmount = ((double.parse(invoiceTotal.text.replaceAll(',','')) - discountAmount) +
            additionalCharge);
      } else if (discountInPercentageTextField.text.trim().length > 3 ||
          double.parse(discountInPercentageTextField.text.trim().isEmpty
                  ? '0'
                  : discountInPercentageTextField.text.trim()) >=
              100) {
        FocusScope.of(Get.overlayContext!).unfocus();
        discountInAmountTextField.text = invoiceTotal.text;
        discountInPercentageTextField.text = '100';
        payableAmount = (double.parse(invoiceTotal.text.replaceAll(',','')) * 2);
      } else {
        discountInAmountTextField.text = '';
        discountInAmountTextField.text = '';
        payableAmount = (double.parse(invoiceTotal.text.replaceAll(',','')) + additionalCharge);
      }
      invoicePayable.text = returnFormattedNumber(values: double.parse(returnToStringAsFixed(value: payableAmount)));
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
      double discInAmount = discountInAmountTextField.text.trim().isEmpty?0:double.parse(discountInAmountTextField.text.trim());
      if (additionalChargeTextField.text.trim().isNotEmpty &&
          double.parse(additionalChargeTextField.text) <=
              double.parse(invoiceTotal.text.replaceAll(',',''))) {
        additionalCharge = additionalChargeTextField.text.trim().isEmpty
            ? 0
            : double.parse(additionalChargeTextField.text);

        // payableAmount = (double.parse(invoiceTotal.value) + additionalCharge);
        payableAmount = ((double.parse(invoiceTotal.text.replaceAll(',','')) -
                discInAmount) +
            additionalCharge);
      } else {
        payableAmount = (double.parse(invoiceTotal.text.replaceAll(',','')) -
            discInAmount);
            // double.parse(discountInAmountTextField.text.trim()));
      }
      invoicePayable.text = returnFormattedNumber(values: double.parse(returnToStringAsFixed(value: payableAmount)));
    } else {
      if (additionalChargeTextField.text.trim().isEmpty) {
        additionalChargeTextField.text = '';
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
      if (receivedAmountController.text.trim().isNotEmpty &&
          double.parse(receivedAmountController.text.trim()) >
              double.parse(invoicePayable.text.replaceAll(',',''))) {
        Get.find<AlertMessageUtils>()
            .showErrorSnackBar(kReceivedAmountValidation);
      } else if (selectedItemsList.isEmpty) {
        Get.find<AlertMessageUtils>()
            .showErrorSnackBar(kPleaseSelectItemToGenerateInvoice);
      } else if (isValidPhoneNumber.value == false &&
          selectedItemsList.isNotEmpty &&
          customerNameController.text.trim().isNotEmpty) {
        customerMobileStr.value = kMobileNumberRequiredValidation;
      } else if (selectedCustomerNameController.value.text.trim().isEmpty) {
        customerNameStr.value = kCustomerSelectionRequiredValidation;
        Get.find<AlertMessageUtils>()
            .showErrorSnackBar(kPleaseSelectCustomerToGenerateInvoice);
      } else {
        generateInvoiceApi();
      }

      // if (double.parse(receivedAmountController.text.trim()) <=
      //     double.parse(invoicePayable.text)) {
      //   if (selectedItemsList.isNotEmpty && isButtonEnable.value) {
      //     generateInvoiceApi();
      //   } else if (isValidPhoneNumber.value == false &&
      //       selectedItemsList.isNotEmpty &&
      //       customerNameController.text.trim().isNotEmpty) {
      //     customerMobileStr.value = kMobileNumberRequiredValidation;
      //   } else if (customerNameController.text.trim().isEmpty) {
      //     customerNameStr.value = kCustomerSelectionRequiredValidation;
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
              gstRateId: itemData.gstRateId == 0 ? null : itemData.gstRateId,
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
            ),
          );
        }
      }

      var requestModel = GenerateInvoiceRequestModel(
        bizId: int.parse(bizId),
        custId: customerData.value.custId ?? 0,
        productList: productList,
        serviceList: serviceList,
        totalAmount: double.parse(invoiceTotal.text.replaceAll(',','')).toPrecision(2),
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
        // customerData: AddCustomerRequestModel(
        //   bizId: int.parse(bizId),
        //   name: selectedCustomerNameController.value.text.trim(),
        //   emailId: selectedCustomerEmailIdController.text.trim(),
        //   mobileNo: int.parse(selectedCustomerMobileNoController.text.trim()),
        // ),
        // isCustExits: customerData.value.custId == null ? false : true,
      );
      var response = await Get.find<InvoiceRepository>()
          .generateOrUpdateInvoiceApi(
              requestModel: requestModel, isForUpdateInvoice: false);

      if (response != null && response.data != null) {
        if (response.statusCode == 100) {
          // resetInvoiceAllData();
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

  void resetInvoiceAllData() {
    discountInPercentageTextField.text = '';
    discountInAmountTextField.text = '';
    additionalChargeTextField.text = '';

    invoiceTotal.text = '0';
    invoicePayable.text = '0';

    searchItemsList.clear();
    selectedItemsList.clear();
    customerData.value = AllCustomerData();
    searchCustomerList.clear();
  }

  void validateUserInput({required int fieldNumber, bool isOnChange = true}) {
    /// 1 : name , 2 : mobile no , 3 : emailId
    if (fieldNumber == 1 && isOnChange) {
      isValidCustomerName.value = false;
      isAddCustButtonEnable.value = false;
      customerNameStr.value = '';
      // if (customerNameController.text.trim().isEmpty) {
      //   customerNameStr.value = kCustomerNameRequiredValidation;
      // } else {
      if (customerNameController.text.trim().length > 3) {
        customerNameValidation();
      }
      // }
    } else if (fieldNumber == 1 && isOnChange == false) {
      isValidCustomerName.value = false;
      isAddCustButtonEnable.value = false;
      customerNameStr.value = '';
      if (customerNameController.text.trim().isEmpty) {
        // customerNameStr.value = kCustomerNameRequiredValidation;
      } else {
        customerNameValidation();
      }
    } else if (fieldNumber == 2 && isOnChange == false) {
      isValidPhoneNumber.value = false;
      isAddCustButtonEnable.value = false;
      customerMobileStr.value = '';
      if (customerMobileNoController.text.isEmpty) {
        // customerMobileStr.value = kMobileNumberRequiredValidation;
      } else {
        phoneNumberValidation();
      }
    } else if (fieldNumber == 2) {
      isValidPhoneNumber.value = false;
      isAddCustButtonEnable.value = false;
      customerMobileStr.value = '';
      // if (customerMobileNoController.text.isEmpty) {
      // customerMobileStr.value = kMobileNumberRequiredValidation;
      // } else {
      //   phoneNumberValidation();
      // }
    } else if (fieldNumber == 3 && isOnChange) {
      isValidEmailId.value = false;
      isAddCustButtonEnable.value = false;
      customerEmailStr.value = '';
      // if (customerEmailIdController.text.trim().isEmpty) {
      //   customerEmailStr.value = kEmailIdRequiredValidation;
      // } else {
      // if (customerEmailIdController.text.trim().length > 3) {
      //   emailValidation();
      // }
      // }
    } else if (fieldNumber == 3 && isOnChange == false) {
      isValidEmailId.value = false;
      isAddCustButtonEnable.value = false;
      customerEmailStr.value = '';
      if (customerEmailIdController.text.trim().isEmpty) {
        // customerEmailStr.value = kEmailIdRequiredValidation;
      } else {
        emailValidation();
      }
    }
  }

  bool customerNameValidation() {
    isValidCustomerName.value = false;
    if (customerNameController.text.trim().isNotEmpty) {
      if (!RegexData.nameRegex.hasMatch(customerNameController.text.trim())) {
        customerNameStr.value = kNameValidation;
      } else if (customerNameController.text.length < 3) {
        customerNameStr.value = kCustomerNameMinLengthValidation;
      } else {
        customerNameStr.value = '';
        isValidCustomerName.value = true;
      }
      if (isValidPhoneNumber.value &&
          isValidCustomerName.value &&
          isValidEmailId.value) {
        isAddCustButtonEnable.value = true;
      }
    } else {
      customerNameStr.value = kCustomerNameRequiredValidation;
    }
    return isValidCustomerName.value;
  }

  bool phoneNumberValidation() {
    isValidPhoneNumber.value = false;
    if (customerMobileNoController.text.trim().isNotEmpty) {
      if (!RegexData.mobileNumberRegex
          .hasMatch(customerMobileNoController.text.trim())) {
        customerMobileStr.value = kMobileNumberMaxValidation;
      } else if (customerMobileNoController.text.length != 10) {
        customerMobileStr.value = kMobileNumberMaxValidation;
      } else {
        customerMobileStr.value = '';
        isValidPhoneNumber.value = true;
      }
      if (isValidPhoneNumber.value &&
          isValidCustomerName.value &&
          isValidEmailId.value) {
        isAddCustButtonEnable.value = true;
      }
    } else {
      customerMobileStr.value = kMobileNumberRequiredValidation;
    }
    return isValidPhoneNumber.value;
  }

  bool emailValidation() {
    isValidEmailId.value = false;
    if (customerEmailIdController.text.isNotEmpty) {
      if (!RegexData.emailIdRegex
          .hasMatch(customerEmailIdController.text.trim())) {
        customerEmailStr.value = kEmailIdValidation;
      } else {
        customerEmailStr.value = '';
        isValidEmailId.value = true;
      }
      if (isValidPhoneNumber.value &&
          isValidCustomerName.value &&
          isValidEmailId.value) {
        isAddCustButtonEnable.value = true;
      }
    } else {
      customerEmailStr.value = kEmailIdRequiredValidation;
      isValidEmailId.value = true;
    }
    return isValidEmailId.value;
  }

  Future<void> navigateToSearchItemsScreen() async {
    var selectedData = await Get.toNamed(kRouteSearchItemsScreen,
        arguments: [selectedItemsList, true]);

    FocusScope.of(Get.overlayContext!).unfocus();
    List<TotalProductServiceData> selectedList = [];

    if (selectedData != null && selectedData[0].isNotEmpty) {
      selectedList = (selectedData[0] as List<TotalProductServiceData>);
    }
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
    return returnFormattedNumber(values: double.parse(returnToStringAsFixed(
        value: ((itemData.itemTotal ?? 0.0) + gstValue))));
  }

  void checkCustomerAddValidation() {
    if (isAddCustButtonEnable.value) {
      FocusScope.of(Get.overlayContext!).unfocus();
      addCustomerApiCall();
    } else if (customerNameController.text.trim().isEmpty ||
        customerMobileNoController.text.trim().isEmpty) {
      customerNameValidation();
      phoneNumberValidation();
    } else {
      if (!isValidCustomerName.value) {
        customerNameValidation();
        // validateUserInput(fieldNumber: 1);
      } else if (!isValidPhoneNumber.value) {
        phoneNumberValidation();
        // validateUserInput(fieldNumber: 2);
      } else if (!isValidEmailId.value) {
        emailValidation();
        // validateUserInput(fieldNumber: 3);
      }
    }
  }

  /// add customer api call
  Future<void> addCustomerApiCall() async {
    try {
      AddCustomerRequestModel requestModel = AddCustomerRequestModel(
          bizId: int.parse(bizId),
          name: customerNameController.text.trim(),
          mobileNo: int.parse(customerMobileNoController.text.trim()),
          emailId: customerEmailIdController.text.trim());
      var response = await Get.find<CustomerRepository>()
          .addCustomer(requestModel: requestModel);

      if (response != null && response.statusCode == 100) {
        // Get.back(result: true);

        customerDataList.clear();
        await getAllCustomerListFromServer();
        int index = customerDataList.indexWhere(
            (element) => element.name == customerNameController.text.trim());
        onCustomerSelection(
            isSelected: true,
            custData: AllCustomerData(
              custId: customerDataList[index].custId,
              emailId: customerEmailIdController.text.trim(),
              mobileNo: int.parse(customerMobileNoController.text.trim()),
              name: customerNameController.text.trim(),
            ),
            index: index);
        customerNameController.text = '';
        customerMobileNoController.text = '';
        isShowAddCustomer.value = false;
      } else {
        Get.find<AlertMessageUtils>().showErrorSnackBar(response?.msg ?? "");
      }
    } catch (e) {
      LoggerUtils.logException('addCustomerApiCall', e);
    }
  }

  void resetInvoiceValues() {
    discountInAmountTextField.text = '';
    discountInPercentageTextField.text = '';
    additionalChargeTextField.text = '';
    receivedAmountController.text = '';
    selectedItemsList.clear();
    customerData.value = AllCustomerData();
    selectedCustomerNameController.value.text = '';
    selectedCustomerMobileNoController.text = '';
    selectedCustomerEmailIdController.text = '';
    selectedCustomerNameController.refresh();
    // for (TotalProductServiceData itemData in itemsList) {
    //   itemData.isSelected = false;
    //   itemData.isAddedToList = false;
    // }
    int i = customerDataList.indexWhere((element) => element.isSelected==true);
    if(i!=-1){
      customerDataList[i].isSelected=false;
    }
    customerDataList.refresh();

    itemsList.clear();

    getTotalItemsList();
    getInvoiceTotalAndPayableAmount();
    onDiscountInPercentageValueChange();
  }

  showConfirmDialog() {
    QuickAlert.show(
      barrierDismissible: false,
      context: Get.overlayContext!,
      type: QuickAlertType.success,
      text: kInvoiceCreatedSuccessfully,
      confirmBtnColor: kColorPrimary,
      confirmBtnTextStyle: TextStyles.kTextH16White600,
      onConfirmBtnTap: () {
        Get.back();
        Get.back(result: true);
      },
    );
  }
}
