import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/local_storage_constants.dart';
import 'package:bms/app/common/model/craete_new_category_request_model.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/base/controller/product_service_base_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/products/add_product/model/request/add_product_request_model.dart';
import 'package:bms/app/screens/bottom_navigation/base/controller/bottom_nav_base_controller.dart';
import 'package:bms/app/screens/bottom_navigation/base/model/response/drop_down_common_data.dart';
import 'package:bms/app/services/repository/master_repository.dart';
import 'package:bms/app/services/repository/product_repository.dart';
import 'package:bms/app/utils/alert_message_utils.dart';
import 'package:bms/app/utils/decode_response_data/decode_response_data.dart';
import 'package:bms/app/utils/local_storage.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:bms/app/utils/regex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProductController extends GetxController {
  int productId = 0;
  String bizId = '';
  Rx<AddProductRequestModel> productData = AddProductRequestModel().obs;

  Rx<DropdownCommonData> selectedCategory = DropdownCommonData().obs;
  Rx<DropdownCommonData> selectedGST = DropdownCommonData().obs;
  Rx<DropdownCommonData> selectedUnits = DropdownCommonData().obs;

  RxList<DropdownCommonData> categoryList =
      List<DropdownCommonData>.empty(growable: true).obs;
  RxList<DropdownCommonData> gstList =
      List<DropdownCommonData>.empty(growable: true).obs;
  RxList<DropdownCommonData> unitList =
      List<DropdownCommonData>.empty(growable: true).obs;

  TextEditingController productNameController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();
  TextEditingController hsnCodeController = TextEditingController();
  TextEditingController barCodeController = TextEditingController();

  TextEditingController categoryController = TextEditingController();
  TextEditingController createCategoryController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController gstController = TextEditingController();

  RxString createCatValue = ''.obs;

  RxBool isSellingTaxApplied = false.obs;

  RxBool isValidProductName = false.obs;
  RxBool isValidPurchasePrice = false.obs;
  RxBool isValidSellingPrice = false.obs;
  RxBool isValidHSNCode = false.obs;
  RxBool isValidBarcode = false.obs;

  RxBool isFocusOnProductNameField = true.obs;
  RxBool isFocusOnPurchasePriceField = true.obs;
  RxBool isFocusOnSellingPriceField = true.obs;
  RxBool isFocusOnHSNCodeField = true.obs;
  RxBool isFocusOnBarcodeField = true.obs;

  RxString productNameStr = ''.obs;
  RxString purchasePriceStr = ''.obs;
  RxString sellingPriceStr = ''.obs;
  RxString unitStr = ''.obs;
  RxString hsnCodeStr = ''.obs;
  RxString barCodeStr = ''.obs;

  RxBool isButtonEnable = false.obs;

  RxBool isCategoryDropdownOpen = false.obs;
  RxBool isGSTDropdownOpen = false.obs;

  RxBool isGstSelected = false.obs;
  RxBool isDataLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    Get.lazyPut(() => ProductRepository(), fenix: true);
    Get.lazyPut(() => MasterRepository(), fenix: true);
    // setCategoryValues();
    // setGSTRateValues();
  }

  setCategoryValues() async {
    var res = await Get.find<LocalStorage>().getStringFromStorage(kStorageCategoryList);
    categoryList.addAll(dropdownCommonDataFromJson(res));
    if (productData.value.categoryId == null) {
      categoryList.add(DropdownCommonData(name: 'General', id: 1));
      // selectedCategory.value = categoryList[0];

    } else {
      for (DropdownCommonData catData in categoryList) {
        if (productData.value.categoryId == catData.id) {
          selectedCategory.value = catData;
        }
      }
    }
    selectedCategory.refresh();
    categoryController.text =
        selectedCategory.value.name ?? kLabelSelectCategory;
    int i = categoryList
        .indexWhere((element) => element.id == selectedCategory.value.id);
    categoryList[i].isSelected = true;
    // selectedCategory.value = categoryList[0];
  }

  setGSTRateValues() async {
    var res = await Get.find<LocalStorage>().getStringFromStorage(kStorageGstRateList);
    gstList.addAll(dropdownCommonDataFromJson(res));
    if (productData.value.gstRateId != null) {
      for (DropdownCommonData gstData in gstList) {
        if (productData.value.gstRateId == gstData.id) {
          selectedGST.value = gstData;
        }
        isGstSelected.value = true;
      }
    } else {
      selectedGST.value = DropdownCommonData();
      // selectedGST.value = gstList[0];
    }
    selectedGST.refresh();
    String perc = selectedGST.value.value!=null?' %':'';
    gstController.text = '${selectedGST.value.value ?? kLabelSelectGSTRate}$perc';
    if (selectedGST.value.value != null) {
      int i =
      gstList.indexWhere((element) => element.id == selectedGST.value.id);
      gstList[i].isSelected = true;
    }
  }

  setUnitValues() async {
    var res = await Get.find<LocalStorage>().getStringFromStorage(kStorageUnitList);
    unitList.addAll(dropdownCommonDataFromJson(res));
    if (productData.value.unitId != null) {
      for (DropdownCommonData unit in unitList) {
        if (productData.value.unitId== unit.id) {
          selectedUnits.value = unit;

      selectedUnits.refresh();
        }
      }
    }

    unitController.text = selectedUnits.value.name ?? kLabelSelectUnit;
    int i = unitList.indexWhere((element) => element.id == selectedUnits.value.id);
    unitList[i].isSelected = true;
  }

  /// set intent data from previous screen
  Future<void> setIntentData({required dynamic intentData}) async {
    try {
      bizId =
          await Get.find<LocalStorage>().getStringFromStorage(kStorageBizId);
      productId = (intentData[0] as int);
      await getProductDetailsApi();
    } catch (e) {
      LoggerUtils.logException('setIntentData', e);
    }
  }

  /// get product details from server
  Future<void> getProductDetailsApi() async {
    try {
      var response = await Get.find<ProductRepository>()
          .getProductDetailsApi(bizId: bizId, productId: productId.toString());
      if (response != null && response.statusCode == 100) {
        var res = decodeResponseData(responseData: response.data ?? '');
        if (res != null && res != '') {
          productData.value = addProductRequestModelFromJson(res);
          productNameController.text = productData.value.name ?? '';
          purchasePriceController.text =
              productData.value.purchasePrice.toString();
          sellingPriceController.text = productData.value.sellPrice.toString();
          hsnCodeController.text = productData.value.hsn ?? '';
          barCodeController.text = productData.value.qrBarCode ?? '';
          isSellingTaxApplied.value = productData.value.sellIsTaxInc??true;
          setGSTRateValues();
          setUnitValues();
          setCategoryValues();
          isValidProductName.value = true;
          isValidPurchasePrice.value = true;
          isValidSellingPrice.value = true;
          isValidHSNCode.value = true;
          isValidBarcode.value = true;
          isButtonEnable.value = true;
          setSelectedGstRate();
        }
      }
    } catch (e) {
      LoggerUtils.logException('getProductDetailsApi', e);
    }
  }

  /// set gst rate which gstId match with productData
  void setSelectedGstRate() {
    for (DropdownCommonData gstRateData in gstList) {
      if (gstRateData.id == productData.value.gstRateId) {
        selectedGST.value = gstRateData;
      }
    }
    selectedGST.refresh();
  }

  /// on tax switch value changes
  void onTaxSwitchValueChanges(val) {
    isSellingTaxApplied.value = val;
  }

  void changeFocus({required bool hasFocus, required int fieldNumber}) {
    if (fieldNumber == 1) {
      isFocusOnProductNameField.value = hasFocus;
    } else if (fieldNumber == 2) {
      isFocusOnPurchasePriceField.value = hasFocus;
    } else if (fieldNumber == 3) {
      isFocusOnSellingPriceField.value = hasFocus;
    } else if (fieldNumber == 4) {
      isFocusOnHSNCodeField.value = hasFocus;
    } else if (fieldNumber == 5) {
      isFocusOnBarcodeField.value = hasFocus;
    }
  }

  /// check regex validation
  void validateUserInput({required int fieldNumber, bool isOnChange = true}) {
    /// FieldNumber = 1 : product name , 2 : purchase price , 3 : selling price , 4 : hsnCode , 5 : barcode
    if (fieldNumber == 1 && isOnChange) {
      isValidProductName.value = false;
      isButtonEnable.value = false;
      productNameStr.value = '';
      // if (productNameController.text.trim().isEmpty) {
      //   productNameStr.value = kProductNameRequiredValidation;
      // } else {
      if (productNameController.text.trim().length > 3) {
        productNameValidation(isOnChange: true);
      }
      // }
    } else if (fieldNumber == 1 && isOnChange == false) {
      isValidProductName.value = false;
      isButtonEnable.value = false;
      productNameStr.value = '';
      if (productNameController.text.trim().isEmpty) {
        // productNameStr.value = kProductNameRequiredValidation;
      } else {
        productNameValidation();
      }
    } else if (fieldNumber == 2 && isOnChange) {
      isValidPurchasePrice.value = false;
      isButtonEnable.value = false;
      purchasePriceStr.value = '';
      // if (sellingPriceController.text.trim().isNotEmpty) {
      purchasePriceValidation(isOnChange: true);
      // }
    } else if (fieldNumber == 2 && isOnChange == false) {
      isValidPurchasePrice.value = false;
      isButtonEnable.value = false;
      purchasePriceStr.value = '';
      // if (sellingPriceController.text.isNotEmpty &&
      //     purchasePriceController.text.isNotEmpty) {

      // if (int.parse(purchasePriceController.text.trim()) <
      //         int.parse(sellingPriceController.text.trim()) &&
      //     sellingPriceController.text.trim().isNotEmpty) {
      //   sellingPriceStr.value = '';
      //   isValidSellingPrice.value = true;
      // } else {
      //   sellingPriceStr.value = kSellingPriceShouldGreaterThanPurchasePrice;
      // }
      if (sellingPriceController.text.trim().isNotEmpty) {
        purchasePriceValidation();
      }
      // }
    } else if (fieldNumber == 3 && isOnChange) {
      isButtonEnable.value = false;
      isValidSellingPrice.value = false;
      sellingPriceStr.value = '';
      // if(sellingPriceController.text.trim().isNotEmpty){
      sellingPriceValidation(isOnChange: true);
      // }
      // if (int.parse(purchasePriceController.text.trim()) <
      //         int.parse(sellingPriceController.text.trim()) &&
      //     sellingPriceController.text.trim().isNotEmpty) {
      //   sellingPriceStr.value = '';
      //   isValidSellingPrice.value = true;
      // }
      // else {
      //   sellingPriceStr.value = kSellingPriceShouldGreaterThanPurchasePrice;
      // }
      // if (sellingPriceController.text.trim().isNotEmpty) {
      //   sellingPriceValidation();
      // }
    } else if (fieldNumber == 3 && isOnChange == false) {
      isValidSellingPrice.value = false;
      isButtonEnable.value = false;
      sellingPriceStr.value = '';
      if (sellingPriceController.text.trim().isEmpty) {
        // productNameStr.value = kProductNameRequiredValidation;
      } else {
        sellingPriceValidation();
      }
    } else if (fieldNumber == 4 && isOnChange == false) {
      isValidHSNCode.value = false;
      isButtonEnable.value = false;
      hsnCodeStr.value = '';

      hsnCodeValidation();
    } else if (fieldNumber == 4) {
      isValidHSNCode.value = false;
      isButtonEnable.value = false;
      hsnCodeStr.value = '';
      hsnCodeValidation(isOnChange: true);
    } else if (fieldNumber == 5 && isOnChange == false) {
      isValidBarcode.value = false;
      isButtonEnable.value = false;
      barCodeStr.value = '';
      barCodeValidation();
    } else if (fieldNumber == 5) {
      isValidBarcode.value = false;
      isButtonEnable.value = false;
      barCodeStr.value = '';
      barCodeValidation(isOnChange: true);
    }
  }

  /// check validation and if isButtonEnable then call addProduct api call
  void checkValidationsAndApiCall() {
    if (isButtonEnable.value && selectedUnits.value.name != null) {
      updateProductApiCall();
    } else if (productNameController.text.trim().isEmpty ||
        purchasePriceController.text.trim().isEmpty ||
        sellingPriceController.text.trim().isEmpty ||
        selectedUnits.value.name == null) {
      productNameValidation();
      purchasePriceValidation();
      sellingPriceValidation();
      unitStr.value = kRequired;
    } else {
      if (!isValidProductName.value) {
        // validateUserInput(fieldNumber: 1);
        productNameValidation();
      } else if (!isValidPurchasePrice.value) {
        purchasePriceValidation();
      } else if (!isValidSellingPrice.value) {
        sellingPriceValidation();
      } else if (!isValidHSNCode.value) {
        hsnCodeValidation();
      } else if (!isValidBarcode.value) {
        barCodeValidation();
      }
    }
  }

  /// add product api all
  Future<void> updateProductApiCall() async {
    try {
      var requestModel = AddProductRequestModel(
        bizId: int.parse(bizId),
        productID: productId,
        name: productNameController.text.trim(),
        purchasePrice:
            double.parse(purchasePriceController.text.trim()).toPrecision(2),
        sellPrice:
            double.parse(sellingPriceController.text.trim()).toPrecision(2),
        sellIsTaxInc: isSellingTaxApplied.value,
        qrBarCode: barCodeController.text.trim(),
        hsn: hsnCodeController.text.trim(),
        gstRateId: isGstSelected.value ? selectedGST.value.id : null,
        categoryId: selectedCategory.value.id,
        unitId: selectedUnits.value.id,
      );

      var response = await Get.find<ProductRepository>()
          .updateProductApi(requestModel: requestModel);

      if (response != null && response.statusCode == 100) {
        Get.back(result: true);
      } else {
        Get.find<AlertMessageUtils>().showErrorSnackBar(response?.msg ?? '');
      }
    } catch (e) {
      LoggerUtils.logException('updateProductApiCall', e);
    }
  }

  /// regex validations
  bool productNameValidation({bool isOnChange = false}) {
    isValidProductName.value = false;
    if (productNameController.text.trim().isNotEmpty) {
      if (!RegexData.nameRegex.hasMatch(productNameController.text.trim())) {
        productNameStr.value = isOnChange?"":kNameValidation;
      } else if (productNameController.text.length < 3) {
        productNameStr.value =isOnChange?"" :kProductNameMinLengthValidation;
      } else if (productNameController.text.length > 20) {
        productNameStr.value = isOnChange?"":kProductNameMaxLengthValidation;
      } else {
        productNameStr.value = '';
        isValidProductName.value = true;
      }
      if (isValidPurchasePrice.value &&
          isValidSellingPrice.value &&
          isValidHSNCode.value &&
          isValidBarcode.value &&
          isValidProductName.value) {
        isButtonEnable.value = true;
      }
    } else {
      productNameStr.value =isOnChange?"": kProductNameRequiredValidation;
    }
    return isValidProductName.value;
  }

  bool purchasePriceValidation({bool isOnChange = false}) {
    isValidPurchasePrice.value = false;
    if (purchasePriceController.text.trim().isNotEmpty) {
      if (!RegexData.digitAndPointRegex
          .hasMatch(purchasePriceController.text.trim())) {
        purchasePriceStr.value =  isOnChange?"":kPurchasePriceOnlyDigitsValidation;
      } else {
        purchasePriceStr.value = '';
        isValidPurchasePrice.value = true;
      }
      if (isValidPurchasePrice.value &&
          isValidSellingPrice.value &&
          isValidHSNCode.value &&
          isValidBarcode.value &&
          isValidProductName.value) {
        isButtonEnable.value = true;
      }
    } else {
      purchasePriceStr.value =isOnChange?"": kRequired;
    }
    return isValidPurchasePrice.value;
  }

  bool sellingPriceValidation({bool isOnChange = false}) {
    isValidSellingPrice.value = false;
    if (sellingPriceController.text.trim().isNotEmpty) {
      if (!RegexData.digitAndPointRegex
          .hasMatch(sellingPriceController.text.trim())) {
        sellingPriceStr.value = isOnChange?"": kPurchasePriceOnlyDigitsValidation;
      } else if (double.parse(purchasePriceController.text.trim()) >
          double.parse(sellingPriceController.text.trim()) &&
          sellingPriceController.text.trim().isNotEmpty) {
        sellingPriceStr.value =  isOnChange?"":kSellingPriceShouldGreaterThanPurchasePrice;
      } else {
        sellingPriceStr.value = '';
        isValidSellingPrice.value = true;
      }
      if (isValidPurchasePrice.value &&
          isValidSellingPrice.value &&
          isValidHSNCode.value &&
          isValidBarcode.value &&
          isValidProductName.value) {
        isButtonEnable.value = true;
      }
    } else {
      sellingPriceStr.value = isOnChange?"":kRequired;
    }
    return isValidSellingPrice.value;
  }

  bool hsnCodeValidation({bool isOnChange = false}) {
    isValidHSNCode.value = false;
    if (hsnCodeController.text.trim().isNotEmpty) {
      if (hsnCodeController.text.trim().length < 4) {
        hsnCodeStr.value =  isOnChange?"":kHSNCodeValidation;
      } else if (!RegexData.hsnCodeRegex
          .hasMatch(hsnCodeController.text.trim())) {
        hsnCodeStr.value =  isOnChange?"":kHSNCodeValidation;
      } else {
        hsnCodeStr.value = '';
        isValidHSNCode.value = true;
      }
      if (isValidPurchasePrice.value &&
          isValidSellingPrice.value &&
          isValidHSNCode.value &&
          isValidBarcode.value &&
          isValidProductName.value) {
        isButtonEnable.value = true;
      }
    } else {
      hsnCodeStr.value = '';
      isValidHSNCode.value = true;
      if (isValidPurchasePrice.value &&
          isValidSellingPrice.value &&
          isValidHSNCode.value &&
          isValidBarcode.value &&
          isValidProductName.value) {
        isButtonEnable.value = true;
      }
    }
    return isValidHSNCode.value;
  }

  bool barCodeValidation({bool isOnChange = false}) {
    isValidBarcode.value = false;
    if (barCodeController.text.trim().isNotEmpty) {
      // if (hsnCodeController.text.trim().length > 15 &&
      //     hsnCodeController.text.trim().length < 4) {
      if (!RegexData.nameRegex.hasMatch(barCodeController.text.trim())) {
        barCodeStr.value =  isOnChange?"":kBarCodeValidation;
      } else {
        barCodeStr.value = '';
        isValidBarcode.value = true;
      }
      if (isValidPurchasePrice.value &&
          isValidSellingPrice.value &&
          isValidHSNCode.value &&
          isValidBarcode.value &&
          isValidProductName.value) {
        isButtonEnable.value = true;
      }
    } else {
      barCodeStr.value = '';
      isValidBarcode.value = true;
      if (isValidPurchasePrice.value &&
          isValidSellingPrice.value &&
          isValidHSNCode.value &&
          isValidBarcode.value &&
          isValidProductName.value) {
        isButtonEnable.value = true;
      }
    }
    return isValidBarcode.value;
  }

  /// delete product api call
  Future<void> deleteServiceApiCall() async {
    try {
      var response = await Get.find<ProductRepository>().deleteProduct(
        bizId: bizId,
        productId: productData.value.productID,
      );

      if (response != null && response.statusCode == 100) {
        Get.find<ProductServiceBaseController>().currentTabValue.value = 1;
        Get.back(result: true);
      }
    } catch (e) {
      LoggerUtils.logException('deleteCustomerApiCall', e);
    }
  }

  void updateUnitStatus({required int i}) {
    int index = unitList.indexWhere((element) => element.isSelected == true);

    if (index != -1 && i != index) {
      unitList[index].isSelected = false;
    }
    unitList[i].isSelected = !(unitList[i].isSelected ?? false);
    if (unitList[i].isSelected == true) {
      selectedUnits.value = unitList[i];
      unitController.text = selectedUnits.value.name ?? '';
    } else {
      selectedUnits.value = DropdownCommonData();
      unitController.text = kLabelSelectUnit;
    }
    unitList.refresh();
    Get.back();
  }

  void updateCategoryStatus({required int i}) {
    int index =
        categoryList.indexWhere((element) => element.isSelected == true);

    if (index != -1 && i != index) {
      categoryList[index].isSelected = false;
    }
    categoryList[i].isSelected = !(categoryList[i].isSelected ?? false);
    if (categoryList[i].isSelected == true) {
      selectedCategory.value = categoryList[i];
      categoryController.text = selectedCategory.value.name ?? '';
    } else {
      selectedCategory.value = DropdownCommonData();
      categoryController.text = kLabelSelectCategory;
    }
    categoryList.refresh();
    Get.back();
  }

  void updateGSTStatus({required int i}) {
    int index = gstList.indexWhere((element) => element.isSelected == true);

    if (index != -1 && i != index) {
      gstList[index].isSelected = false;
    }
    gstList[i].isSelected = !(gstList[i].isSelected ?? false);
    if (gstList[i].isSelected == true) {
      selectedGST.value = gstList[i];
      gstController.text = '${selectedGST.value.value ?? ''} %';
      isGstSelected.value = true;
    } else {
      selectedGST.value = DropdownCommonData();
      gstController.text = kLabelSelectGSTRate;
      isGstSelected.value = false;
    }
    gstList.refresh();
    Get.back();
  }

  /// create new category api call
  Future<void> createCategoryApiCall() async {
    try {
      int i = categoryList.indexWhere((element) =>
      element.name?.trim().toLowerCase() ==
          createCategoryController.text.trim().toLowerCase());
      if (i==-1) {
      isDataLoading.value = true;
      var requestMode = CreateNewCategoryRequestModel(
        bizId: int.parse(bizId),
        catName: createCategoryController.text.trim(),
      );

      var response = await Get.find<MasterRepository>()
          .createCategoryMasterApiData(requestMode: requestMode);

      if (response != null && response.data != null && response.statusCode==100) {
        await Get.find<BottomNavBaseController>().getCategoriesFromServer();
        categoryList.add(
          DropdownCommonData(
            isSelected: false,
            name: createCategoryController.text.trim(),
            value: 0.0,
            id: (categoryList.last.id??0) + 1,
          ),
        );
        appCategoryList.add(DropdownCommonData(
          isSelected: false,
          name: createCategoryController.text.trim(),
          value: 0.0,
          id: (categoryList.last.id??0) + 1,
        ));
        categoryList.refresh();
      }
      createCategoryController.text = '';
      isDataLoading.value = false; }
      else{
        createCategoryController.text = '';
        Get.find<AlertMessageUtils>().showErrorSnackBar(kDuplicateCategoryName);
      }
    } catch (e) {
      isDataLoading.value = false;
      LoggerUtils.logException('createCategoryApiCall', e);
    }
  }

  void setBarCodeValueToController({required String barcodeScanRes}) {
    barCodeController.text = barcodeScanRes == "-1" ?productData.value.qrBarCode.toString():barcodeScanRes;
  }
}
