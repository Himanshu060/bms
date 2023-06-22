import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/local_storage_constants.dart';
import 'package:bms/app/common/route_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/customer_base_screen/add_customer/model/request/add_customer_request_modell.dart';
import 'package:bms/app/screens/bottom_nav_screens/customer_base_screen/import_device_contacts/controller/import_device_contacts_controller.dart';
import 'package:bms/app/services/repository/customer_repository.dart';
import 'package:bms/app/utils/alert_message_utils.dart';
import 'package:bms/app/utils/local_storage.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:bms/app/utils/regex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCustomerController extends GetxController {
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerMobileNumberController =
      TextEditingController();
  TextEditingController customerEmailIdController = TextEditingController();
  TextEditingController customerAddressController = TextEditingController();
  TextEditingController customerPinCodeController = TextEditingController();
  TextEditingController customerGstNoController = TextEditingController();

  RxBool isFocusOnCustomerNameField = false.obs;
  RxBool isFocusOnCustomerNumberField = false.obs;
  RxBool isFocusOnCustomerEmailIdField = false.obs;
  RxBool isFocusOnCustomerAddressField = false.obs;
  RxBool isFocusOnCustomerPinCodeField = false.obs;
  RxBool isFocusOnCustomerGstNoField = false.obs;

  RxBool isButtonEnable = false.obs;

  /// validation bool variables
  RxBool isValidName = false.obs;
  RxBool isValidPhoneNumber = false.obs;
  RxBool isValidEmailId = true.obs;
  RxBool isValidAddress = true.obs;
  RxBool isValidPinCode = true.obs;
  RxBool isValidGstNo = true.obs;

  String bizId = '';

  /// validation strings
  RxString customerNameStr = ''.obs;
  RxString customerMobileStr = ''.obs;
  RxString customerEmailStr = ''.obs;
  RxString customerAddressStr = ''.obs;
  RxString customerPinCodeStr = ''.obs;
  RxString customerGstStr = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    bizId = await Get.find<LocalStorage>().getStringFromStorage(kStorageBizId);
  }

  /// navigate to import device contacts screen
  Future<void> navigateToImportContactsScreen() async {
    var selectedContactData =
        await Get.toNamed(kRouteImportDeviceContactsScreen);

    customerNameController.text = selectedContactData.displayName ?? '';
    customerMobileNumberController.text = selectedContactData.phoneNumber ?? '';
    customerMobileStr.value = '';
    customerNameStr.value = '';
    isValidPhoneNumber.value = true;
    isValidName.value = true;
    isButtonEnable.value = true;
  }

  /// update focus based on field selection
  void changeFocus({required bool hasFocus, required int fieldNumber}) {
    if (fieldNumber == 1) {
      isFocusOnCustomerNameField.value = hasFocus;
    } else if (fieldNumber == 2) {
      isFocusOnCustomerNumberField.value = hasFocus;
    } else if (fieldNumber == 3) {
      isFocusOnCustomerEmailIdField.value = hasFocus;
    } else if (fieldNumber == 4) {
      isFocusOnCustomerAddressField.value = hasFocus;
    } else if (fieldNumber == 5) {
      isFocusOnCustomerPinCodeField.value = hasFocus;
    } else if (fieldNumber == 6) {
      isFocusOnCustomerGstNoField.value = hasFocus;
    }
  }

  /// checking validation for input field
  void validateUserInput({required fieldNumber, bool isOnChange = true}) {
    /// FieldNumber = 1 : name , 2 : phoneNumber , 3 : emailId , 4 : address , 5 : pinCode , 6 : GSTNo
    if (fieldNumber == 1 && isOnChange) {
      isValidName.value = false;
      isButtonEnable.value = false;
      customerNameStr.value = '';
      // if (customerNameController.text.trim().isEmpty) {
      //   customerNameStr.value = kCustomerNameRequiredValidation;
      // } else {
      if (customerNameController.text.trim().length > 3) {
        customerNameValidation(isOnChange: true);
      }
      // }
    } else if (fieldNumber == 1 && isOnChange == false) {
      isValidName.value = false;
      isButtonEnable.value = false;
      customerNameStr.value = '';
      if (customerNameController.text.trim().isEmpty) {
        // customerNameStr.value = kCustomerNameRequiredValidation;
      } else {
        customerNameValidation();
      }
    } else if (fieldNumber == 2 && isOnChange) {
      isValidPhoneNumber.value = false;
      isButtonEnable.value = false;
      customerMobileStr.value = '';
      // if (customerMobileNumberController.text.trim().isEmpty) {
      //   customerMobileStr.value = kMobileNumberRequiredValidation;
      // }
      // else {
      //   if (contactNumberController.text.trim().length > 10) {
      //     userPhoneNumberValidation();
      //   }
      // }
      if (customerMobileNumberController.text.isNotEmpty) {
        phoneNumberValidation(isOnChange: true);
      }
    } else if (fieldNumber == 2 && isOnChange == false) {
      isValidPhoneNumber.value = false;
      isButtonEnable.value = false;
      customerMobileStr.value = '';
      if (customerMobileNumberController.text.isEmpty) {
        // customerMobileStr.value = kMobileNumberRequiredValidation;
      } else {
        phoneNumberValidation();
      }
    } else if (fieldNumber == 3 && isOnChange) {
      isValidEmailId.value = false;
      isButtonEnable.value = false;
      customerEmailStr.value = '';
      // if (customerEmailIdController.text.trim().isEmpty) {
      //   customerEmailStr.value = kEmailIdRequiredValidation;
      // } else {
      // if (customerEmailIdController.text.trim().length > 3) {
      //   emailValidation();
      // }
      // }
      if (customerEmailIdController.text.trim().isNotEmpty) {
        emailValidation(isOnChange: true);
      }
    } else if (fieldNumber == 3 && isOnChange == false) {
      isValidEmailId.value = false;
      isButtonEnable.value = false;
      customerEmailStr.value = '';
      if (customerEmailIdController.text.trim().isEmpty) {
        // customerEmailStr.value = kEmailIdRequiredValidation;
        emailValidation();
      } else {
        emailValidation();
      }
    } else if (fieldNumber == 4 && isOnChange) {
      isValidAddress.value = false;
      isButtonEnable.value = false;
      customerAddressStr.value = '';
      if (customerAddressController.text.trim().isNotEmpty) {
        addressValidation(isOnChange: true);
      }
    } else if (fieldNumber == 4 && isOnChange == false) {
      isValidAddress.value = false;
      isButtonEnable.value = false;
      customerAddressStr.value = '';
      if (customerAddressController.text.trim().isNotEmpty) {
      addressValidation();
      }
    } else if (fieldNumber == 5 && isOnChange == false) {
      isValidPinCode.value = false;
      isButtonEnable.value = false;
      customerPinCodeStr.value = '';
      pinCodeValidation();
    } else if (fieldNumber == 5) {
      isValidPinCode.value = false;
      isButtonEnable.value = false;
      customerPinCodeStr.value = '';
      if (customerPinCodeController.text.trim().isNotEmpty) {
        pinCodeValidation(isOnChange: true);
      }
    } else if (fieldNumber == 6 && isOnChange == false) {
      isValidGstNo.value = false;
      isButtonEnable.value = false;
      customerGstStr.value = '';
      if (customerGstNoController.text.trim().isNotEmpty) {
        gstNumberValidation();
      }
    } else if (fieldNumber == 6) {
      isValidGstNo.value = false;
      isButtonEnable.value = false;
      customerGstStr.value = '';
      if (customerGstNoController.text.trim().isNotEmpty) {
        gstNumberValidation(isOnChange: true);
      }
    } else {
      if (isValidName.value &&
          isValidPhoneNumber.value &&
          isValidEmailId.value &&
          isValidAddress.value &&
          isValidPinCode.value &&
          isValidGstNo.value) {
        isButtonEnable.value = true;
      }
    }
    // if (customerMobileNumberController.text.trim().isNotEmpty &&
    //     customerMobileNumberController.text.trim().isNotEmpty) {
    //   isButtonEnable.value = true;
    // } else {
    //   isButtonEnable.value = false;
    // }
  }

  /// validate regex for input fields
  void checkRegexValidation() {
    /// FieldNumber = 1 : name , 2 : phoneNumber , 3 : emailId , 4 : address , 5 : pinCode , 6 : GSTNo
    if (isButtonEnable.value) {
      addCustomerApiCall();
    } else if (customerNameController.text.trim().isEmpty ||
        customerMobileNumberController.text.trim().isEmpty) {
      customerNameValidation();
      phoneNumberValidation();
    } else {
      if (!isValidName.value) {
        customerNameValidation();
        // validateUserInput(fieldNumber: 1);
      } else if (!isValidPhoneNumber.value) {
        phoneNumberValidation();
        // validateUserInput(fieldNumber: 2);
      } else if (!isValidEmailId.value) {
        emailValidation();
        // validateUserInput(fieldNumber: 3);
      } else if (!isValidAddress.value) {
        addressValidation();
        // validateUserInput(fieldNumber: 4);
      } else if (!isValidPinCode.value) {
        pinCodeValidation();
        // validateUserInput(fieldNumber: 5);
      } else if (!isValidGstNo.value) {
        gstNumberValidation();
        // validateUserInput(fieldNumber: 6);
      }
    }
  }

  /// add customer api call
  Future<void> addCustomerApiCall() async {
    try {
      AddCustomerRequestModel requestModel = AddCustomerRequestModel(
          bizId: int.parse(bizId),
          name: customerNameController.text.trim(),
          mobileNo: int.parse(customerMobileNumberController.text.trim()),
          emailId: customerEmailIdController.text.trim(),
          billingAddress: customerAddressController.text.trim(),
          pinCode: customerPinCodeController.text.trim().isEmpty
              ? null
              : int.parse(customerPinCodeController.text.trim()),
          gstNo: customerGstNoController.text.trim().toUpperCase());
      var response = await Get.find<CustomerRepository>()
          .addCustomer(requestModel: requestModel);

      if (response != null && response.statusCode == 100) {
        Get.back(result: true);
      } else {
        Get.find<AlertMessageUtils>().showErrorSnackBar(response?.msg ?? "");
      }
    } catch (e) {
      LoggerUtils.logException('addCustomerApiCall', e);
    }
  }

  bool customerNameValidation({bool isOnChange = false}) {
    isValidName.value = false;
    if (customerNameController.text.trim().isNotEmpty) {
      if (!RegexData.nameRegex.hasMatch(customerNameController.text.trim())) {
        customerNameStr.value = isOnChange ? "" : kNameValidation;
      } else if (customerNameController.text.length < 3) {
        customerNameStr.value =
            isOnChange ? "" : kCustomerNameMinLengthValidation;
      } else {
        customerNameStr.value = '';
        isValidName.value = true;
      }
      if (isValidPhoneNumber.value &&
          isValidName.value &&
          isValidEmailId.value &&
          isValidAddress.value &&
          isValidGstNo.value &&
          isValidPinCode.value) {
        isButtonEnable.value = true;
      }
    } else {
      customerNameStr.value = isOnChange ? "" : kCustomerNameRequiredValidation;
    }
    return isValidName.value;
  }

  bool phoneNumberValidation({bool isOnChange = false}) {
    isValidPhoneNumber.value = false;
    if (customerMobileNumberController.text.trim().isNotEmpty) {
      if (!RegexData.mobileNumberRegex
          .hasMatch(customerMobileNumberController.text.trim())) {
        customerMobileStr.value = isOnChange ? "" : kMobileNumberMaxValidation;
      } else if (customerMobileNumberController.text.length != 10) {
        customerMobileStr.value = isOnChange ? "" : kMobileNumberMaxValidation;
      } else {
        customerMobileStr.value = '';
        isValidPhoneNumber.value = true;
      }
      if (isValidName.value &&
          isValidPhoneNumber.value &&
          isValidEmailId.value &&
          isValidAddress.value &&
          isValidGstNo.value &&
          isValidPinCode.value) {
        isButtonEnable.value = true;
      }
    } else {
      customerMobileStr.value =
          isOnChange ? "" : kMobileNumberRequiredValidation;
    }
    return isValidPhoneNumber.value;
  }

  bool emailValidation({bool isOnChange = false}) {
    isValidEmailId.value = false;
    if (customerEmailIdController.text.isNotEmpty) {
      if (!RegexData.emailIdRegex
          .hasMatch(customerEmailIdController.text.trim())) {
        customerEmailStr.value = isOnChange ? "" : kEmailIdValidation;
      } else {
        customerEmailStr.value = '';
        isValidEmailId.value = true;
      }
      if (isValidName.value &&
          isValidPhoneNumber.value &&
          isValidEmailId.value &&
          isValidAddress.value &&
          isValidGstNo.value &&
          isValidPinCode.value) {
        isButtonEnable.value = true;
      }
    } else {
      customerEmailStr.value = '';
      // customerEmailStr.value = kEmailIdRequiredValidation;
      isValidEmailId.value = true;
      if (isValidName.value &&
          isValidPhoneNumber.value &&
          isValidEmailId.value &&
          isValidAddress.value &&
          isValidGstNo.value &&
          isValidPinCode.value) {
        isButtonEnable.value = true;
      }
    }
    return isValidEmailId.value;
  }

  bool addressValidation({bool isOnChange = false}) {
    isValidAddress.value = false;
    if (customerAddressController.text.isNotEmpty) {
      if (!RegexData.addressRegex
          .hasMatch(customerAddressController.text.trim())) {
        customerAddressStr.value = isOnChange ? "" : kAddressValidation;
      } else if (customerAddressController.text.trim().length < 5) {
        customerAddressStr.value = isOnChange ? "" : kAddressMinValidation;
      } else {
        customerAddressStr.value = '';
        isValidAddress.value = true;
      }
      if (isValidName.value &&
          isValidPhoneNumber.value &&
          isValidEmailId.value &&
          isValidAddress.value &&
          isValidGstNo.value &&
          isValidPinCode.value) {
        isButtonEnable.value = true;
      }
    } else {
      // customerAddressStr.value = kAddressValidation;
      customerAddressStr.value = '';
      isValidAddress.value = true;
      if (isValidName.value &&
          isValidPhoneNumber.value &&
          isValidEmailId.value &&
          isValidAddress.value &&
          isValidGstNo.value &&
          isValidPinCode.value) {
        isButtonEnable.value = true;
      }
    }
    return isValidAddress.value;
  }

  bool pinCodeValidation({bool isOnChange = false}) {
    isValidPinCode.value = false;
    if (customerPinCodeController.text.isNotEmpty) {
      if (customerPinCodeController.text.trim().length != 6) {
        customerPinCodeStr.value = isOnChange ? "" : kPinCodeValidation;
      } else {
        customerPinCodeStr.value = '';
        isValidPinCode.value = true;
      }
      if (isValidName.value &&
          isValidPhoneNumber.value &&
          isValidEmailId.value &&
          isValidAddress.value &&
          isValidGstNo.value &&
          isValidPinCode.value) {
        isButtonEnable.value = true;
      }
    } else {
      customerPinCodeStr.value = '';
      isValidPinCode.value = true;
      if (isValidName.value &&
          isValidPhoneNumber.value &&
          isValidEmailId.value &&
          isValidAddress.value &&
          isValidGstNo.value &&
          isValidPinCode.value) {
        isButtonEnable.value = true;
      }
    }
    return isValidPinCode.value;
  }

  bool gstNumberValidation({bool isOnChange = false}) {
    isValidGstNo.value = false;
    if (customerGstNoController.text.isNotEmpty) {
      if (customerGstNoController.text.trim().length != 15) {
        customerGstStr.value = isOnChange ? "" : kGstValidation;
      } else {
        customerGstStr.value = '';
        isValidGstNo.value = true;
      }
      if (isValidName.value &&
          isValidPhoneNumber.value &&
          isValidEmailId.value &&
          isValidAddress.value &&
          isValidGstNo.value &&
          isValidPinCode.value) {
        isButtonEnable.value = true;
      }
    } else {
      customerGstStr.value = '';
      isValidGstNo.value = true;
      if (isValidName.value &&
          isValidPhoneNumber.value &&
          isValidEmailId.value &&
          isValidAddress.value &&
          isValidGstNo.value &&
          isValidPinCode.value) {
        isButtonEnable.value = true;
      }
    }
    return isValidGstNo.value;
  }
}
