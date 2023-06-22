import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/local_storage_constants.dart';
import 'package:bms/app/common/model/craete_new_category_request_model.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/products/add_product/model/request/add_product_request_model.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/products/base/model/request/add_service_request_model.dart';
import 'package:bms/app/screens/bottom_navigation/base/controller/bottom_nav_base_controller.dart';
import 'package:bms/app/screens/bottom_navigation/base/model/response/drop_down_common_data.dart';
import 'package:bms/app/services/repository/master_repository.dart';
import 'package:bms/app/services/repository/product_repository.dart';
import 'package:bms/app/utils/alert_message_utils.dart';
import 'package:bms/app/utils/local_storage.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:bms/app/utils/regex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddServiceController extends GetxController {
  Rx<DropdownCommonData> selectedCategory = DropdownCommonData().obs;
  Rx<DropdownCommonData> selectedGST = DropdownCommonData().obs;
  Rx<DropdownCommonData> selectedUnits = DropdownCommonData().obs;

  RxList<DropdownCommonData> categoryList =
      List<DropdownCommonData>.empty(growable: true).obs;
  RxList<DropdownCommonData> gstList =
      List<DropdownCommonData>.empty(growable: true).obs;
  RxList<DropdownCommonData> unitsList =
      List<DropdownCommonData>.empty(growable: true).obs;

  TextEditingController serviceNameController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();
  TextEditingController sacCodeController = TextEditingController();

  TextEditingController categoryController = TextEditingController();
  TextEditingController createCategoryController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController gstController = TextEditingController();

  RxString createCatValue = ''.obs;

  // TextEditingController barCodeController = TextEditingController();

  String bizId = '';
  RxBool isSellingTaxApplied = true.obs;

  RxBool isValidServiceName = false.obs;
  RxBool isValidSellingPrice = false.obs;
  RxBool isValidSACCode = true.obs;

  // RxBool isValidBarcode = false.obs;

  RxBool isFocusOnServiceNameField = false.obs;
  RxBool isFocusOnSellingPriceField = false.obs;
  RxBool isFocusOnSACCodeField = false.obs;
  RxBool isFocusOnBarcodeField = false.obs;

  RxString serviceNameStr = ''.obs;
  RxString sellingPriceStr = ''.obs;
  RxString unitStr = ''.obs;
  RxString sacCodeStr = ''.obs;

  // RxString barCodeStr = ''.obs;

  RxBool isButtonEnable = false.obs;

  RxBool isCategoryDropdownOpen = false.obs;
  RxBool isGSTDropdownOpen = false.obs;

  RxBool isGstSelected = false.obs;

  RxBool isDataLoading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    Get.lazyPut(() => ProductRepository(), fenix: true);
    Get.lazyPut(() => MasterRepository(), fenix: true);
    bizId = await Get.find<LocalStorage>().getStringFromStorage(kStorageBizId);

    setCategoryValues();
    setUnitValues();
    setGSTRateValues();
  }


  setCategoryValues() async {
    var res = await Get.find<LocalStorage>().getStringFromStorage(kStorageCategoryList);
    if (appCategoryList.isEmpty) {
      categoryList.add(DropdownCommonData(name: 'General', id: 1));
      // selectedCategory.value = categoryList[0];

    } else {
      categoryList.addAll(dropdownCommonDataFromJson(res));
      // categoryList.addAll(appCategoryList);
      // categoryList.addAll(BottomNavBaseController.categoryList);
      // selectedCategory.value = categoryList[0];
    }
    categoryController.text = kLabelSelectCategory;
    // selectedCategory.value = categoryList[0];
  }

  setGSTRateValues() async {
    var res = await Get.find<LocalStorage>().getStringFromStorage(kStorageGstRateList);
    gstList.addAll(dropdownCommonDataFromJson(res));
    gstController.text = selectedGST.value.name ?? kLabelSelectGSTRate;
  }

  setUnitValues() async {
    var res = await Get.find<LocalStorage>().getStringFromStorage(kStorageUnitList);
    unitsList.addAll(dropdownCommonDataFromJson(res));
    unitController.text = kLabelSelectUnit;
  }

  /// on tax switch value changes
  void onTaxSwitchValueChanges(val) {
    isSellingTaxApplied.value = val;
  }

  void changeFocus({required bool hasFocus, required int fieldNumber}) {
    if (fieldNumber == 1) {
      isFocusOnServiceNameField.value = hasFocus;
    } else if (fieldNumber == 3) {
      isFocusOnSellingPriceField.value = hasFocus;
    } else if (fieldNumber == 4) {
      isFocusOnSACCodeField.value = hasFocus;
    } else if (fieldNumber == 5) {
      isFocusOnBarcodeField.value = hasFocus;
    }
  }

  /// check regex validation
  void validateUserInput({required int fieldNumber, bool isOnChange = true}) {
    /// FieldNumber = 1 : service name , 2 : purchase price , 3 : selling price , 4 : sacCode , 5 : barcode
    if (fieldNumber == 1 && isOnChange) {
      isValidServiceName.value = false;
      isButtonEnable.value = false;
      serviceNameStr.value = '';
      // if (productNameController.text.trim().isEmpty) {
      //   productNameStr.value = kProductNameRequiredValidation;
      // } else {
      if (serviceNameController.text.trim().length > 3) {
        serviceNameValidation(isOnChange: true);
      }
      // }
    } else if (fieldNumber == 1 && isOnChange == false) {
      isValidServiceName.value = false;
      isButtonEnable.value = false;
      serviceNameStr.value = '';
      if (serviceNameController.text.trim().isEmpty) {
        // productNameStr.value = kProductNameRequiredValidation;
      } else {
        serviceNameValidation();
      }
    } else if (fieldNumber == 3 && isOnChange) {
      isButtonEnable.value = false;
      isValidSellingPrice.value = false;
      sellingPriceStr.value = '';
      if (sellingPriceController.text.trim().isNotEmpty) {
        sellingPriceValidation(isOnChange: true);
      }
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
      sacCodeStr.value = '';
      isValidSACCode.value = false;
      isButtonEnable.value = false;
      sacCodeValidation();
    } else if (fieldNumber == 4) {
      sacCodeStr.value = '';
      isValidSACCode.value = false;
      isButtonEnable.value = false;
      sacCodeValidation(isOnChange: true);
    }
    // else if (fieldNumber == 5) {
    //   barCodeValidation();
    // }
  }

  /// check validation and if isButtonEnable then call addProduct api call
  void checkValidationsAndApiCall() {
    // if (isButtonEnable.value && selectedUnits.value.name != null) {
    if (isValidSellingPrice.value &&
        isValidServiceName.value &&
        isValidSACCode.value&& selectedUnits.value.name != null) {
      addServiceApiCall();
    }

    else if (serviceNameController.text.trim().isEmpty ||
        sellingPriceController.text.trim().isEmpty ||
        selectedUnits.value.name == null) {
      serviceNameValidation();
      sellingPriceValidation();
      unitStr.value = kRequired;
    } else {
      if (!isValidServiceName.value) {
        // validateUserInput(fieldNumber: 1);
        serviceNameValidation();
      } else if (!isValidSellingPrice.value) {
        sellingPriceValidation();
      } else if (!isValidSACCode.value) {
        sacCodeValidation();
      }
      // else if (!isValidBarcode.value) {
      //   barCodeValidation();
      // }
    }
  }

  /// regex validations
  bool serviceNameValidation({bool isOnChange = false}) {
    isValidServiceName.value = false;
    if (serviceNameController.text.trim().isNotEmpty) {
      if (!RegexData.nameRegex.hasMatch(serviceNameController.text.trim())) {
        serviceNameStr.value = isOnChange?"": kNameValidation;
      } else if (serviceNameController.text.length < 3) {
        serviceNameStr.value = isOnChange?"": kServiceNameMinLengthValidation;
      } else {
        serviceNameStr.value = '';
        isValidServiceName.value = true;
      }
      if (isValidSellingPrice.value &&
          isValidServiceName.value &&
          isValidSACCode.value) {
        isButtonEnable.value = true;
      }
    } else {
      serviceNameStr.value =  isOnChange?"":kServiceNameRequiredValidation;
    }
    return isValidServiceName.value;
  }

  bool sellingPriceValidation({bool isOnChange = false}) {
    isValidSellingPrice.value = false;
    if (sellingPriceController.text.trim().isNotEmpty) {
      if (!RegexData.digitAndPointRegex
          .hasMatch(sellingPriceController.text.trim())) {
        sellingPriceStr.value = isOnChange?"": kPurchasePriceOnlyDigitsValidation;
      } else {
        sellingPriceStr.value = '';
        isValidSellingPrice.value = true;
      }
      if (isValidSellingPrice.value &&
          isValidServiceName.value &&
          isValidSACCode.value) {
        isButtonEnable.value = true;
      }
    } else {
      sellingPriceStr.value = isOnChange?"": kRequired;
    }
    return isValidSellingPrice.value;
  }

  bool sacCodeValidation({bool isOnChange = false}) {
    isValidSACCode.value = false;
    if (sacCodeController.text.trim().isNotEmpty) {
      if (sacCodeController.text.trim().length > 15 ||
          sacCodeController.text.trim().length < 4) {
        sacCodeStr.value =  isOnChange?"":kSACCodeValidation;
      } else if (!RegexData.hsnCodeRegex
          .hasMatch(sacCodeController.text.trim())) {
        sacCodeStr.value = isOnChange?"": kSACCodeValidation;
      } else {
        sacCodeStr.value = '';
        isValidSACCode.value = true;
      }
      // if (isValidSellingPrice.value &&
      //     isValidServiceName.value &&
      //     isValidSACCode.value) {
      //   isButtonEnable.value = true;
      // }
    } else {
      sacCodeStr.value = '';
      isValidSACCode.value = true;
      // if (isValidSellingPrice.value &&
      //     isValidServiceName.value &&
      //     isValidSACCode.value) {
      //   isButtonEnable.value = true;
      // }
    }
    return isValidSACCode.value;
  }

  void updateUnitStatus({required int i}) {
    int index = unitsList.indexWhere((element) => element.isSelected == true);

    if (index != -1 && i != index) {
      unitsList[index].isSelected = false;
    }
    unitsList[i].isSelected = !(unitsList[i].isSelected ?? false);
    if (unitsList[i].isSelected == true) {
      selectedUnits.value = unitsList[i];
      unitController.text = selectedUnits.value.name ?? '';
    } else {
      selectedUnits.value = DropdownCommonData();
      unitController.text = kLabelSelectUnit;
    }
    unitsList.refresh();
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
    } else {
      selectedGST.value = DropdownCommonData();
      gstController.text = kLabelSelectGSTRate;
    }
    gstList.refresh();
    Get.back();
  }

  /// create new category api call
  Future<void> createCategoryApiCall() async {
    try { int i = categoryList.indexWhere((element) =>
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

  /// add service api all
  Future<void> addServiceApiCall() async {
    try {
      var requestModel = AddServiceRequestModel(
        bizId: int.parse(bizId),
        name: serviceNameController.text.trim(),
        sellPrice:
            double.parse(sellingPriceController.text.trim()).toPrecision(2),
        isTaxInc: isSellingTaxApplied.value,
        sac: sacCodeController.text.trim(),
        gstRateId: isGstSelected.value ? selectedGST.value.id : null,
        categoryId: selectedCategory.value.id,
        unitId: selectedUnits.value.id,
      );

      var response = await Get.find<ProductRepository>()
          .addServiceApi(requestModel: requestModel);

      if (response != null && response.statusCode == 100) {
        Get.back(result: 2);
      } else {
        Get.find<AlertMessageUtils>().showErrorSnackBar(response?.msg ?? '');
      }
    } catch (e) {
      LoggerUtils.logException('addServiceApiCall', e);
    }
  }
}
