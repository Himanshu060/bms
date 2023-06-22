import 'dart:io' as io;
import 'dart:math';
import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/local_storage_constants.dart';
import 'package:bms/app/common/route_constants.dart';
import 'package:bms/app/screens/authentication/business_sign_up/model/request/business_sign_up_request_model.dart';
import 'package:bms/app/screens/authentication/business_sign_up/model/response/business_sign_up_response_model.dart';
import 'package:bms/app/screens/bottom_navigation/base/model/response/drop_down_common_data.dart';
import 'package:bms/app/services/api_services/api_constants.dart';
import 'package:bms/app/services/repository/master_repository.dart';
import 'package:bms/app/services/repository/registration_repository.dart';
import 'package:bms/app/utils/alert_message_utils.dart';
import 'package:bms/app/utils/decode_response_data/decode_response_data.dart';
import 'package:bms/app/utils/image_encode_decode_base64/encode_image_base64.dart';
import 'package:bms/app/utils/local_storage.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:bms/app/utils/regex.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class BusinessSignUpController extends GetxController {
  RxDouble textFieldsHeight = 55.0.obs;
  EdgeInsets textFieldsMargin =
      const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0);

  TextEditingController businessNameController = TextEditingController();
  TextEditingController businessMobileNumberController =
      TextEditingController();
  TextEditingController businessEmailIdController = TextEditingController();
  TextEditingController gstNumberController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  RxList<DropdownCommonData> cityList =
      List<DropdownCommonData>.empty(growable: true).obs;
  RxList<DropdownCommonData> stateList =
      List<DropdownCommonData>.empty(growable: true).obs;
  Rx<DropdownCommonData> selectedState = DropdownCommonData().obs;
  Rx<DropdownCommonData> selectedCity = DropdownCommonData().obs;

  RxBool isFocusOnBusinessNameField = false.obs;
  RxBool isFocusOnBusinessContactNumberField = false.obs;
  RxBool isFocusOnBusinessMailField = false.obs;
  RxBool isFocusOnGstNumberField = false.obs;
  RxBool isFocusOnStateField = false.obs;
  RxBool isFocusOnCityField = false.obs;
  RxBool isFocusOnPinCodeField = false.obs;
  RxBool isFocusOnAddressField = false.obs;

  RxBool isBusinessLogoSet = false.obs;
  RxBool isBusinessSignatureSet = false.obs;
  Rx<XFile> businessLogo = XFile('').obs;
  Rx<XFile> businessSignature = XFile('').obs;
  RxString logoExtension = ''.obs;
  RxString signatureExtension = ''.obs;

  RxString convertedLogoToBase64 = ''.obs;
  RxString convertedSignatureToBase64 = ''.obs;

  RxString userId = ''.obs;

  RxBool isPinCodeEntered = false.obs;
  RxBool isGSTEntered = false.obs;
  RxBool isGstEnabled = false.obs;
  RxBool isButtonEnable = false.obs;
  RxBool isSelectedLogoLessThan100Kb = false.obs;
  RxBool isSelectedSignatureLessThan100Kb = false.obs;

  Rx<BusinessSignUpResponseModel> businessData =
      BusinessSignUpResponseModel().obs;

  /// validation strings
  RxString nameStr = ''.obs;
  RxString mobileStr = ''.obs;
  RxString emailStr = ''.obs;
  RxString gstNoStr = ''.obs;
  RxString pinCodeStr = ''.obs;
  RxString addressStr = ''.obs;

  /// validation bool variables
  RxBool isValidName = false.obs;
  RxBool isValidPhoneNumber = false.obs;
  RxBool isValidEmailId = false.obs;
  RxBool isValidGstNo = false.obs;
  RxBool isValidPinCode = false.obs;
  RxBool isValidAddress = false.obs;

  @override
  Future<void> onInit() async {
    Get.lazyPut(() => MasterRepository(), fenix: true);
    Get.lazyPut(() => RegistrationRepository(), fenix: true);

    userId.value =
        await Get.find<LocalStorage>().getStringFromStorage(kStorageUserId);
    await getStatesFromServer();
    selectedState.value = stateList[0];
    cityList.insert(0, DropdownCommonData(id: 0, name: 'select city'));
    selectedCity.value = cityList[0];
    super.onInit();
  }

  /// get states rate data from server
  Future<void> getStatesFromServer() async {
    try {
      var response = await Get.find<MasterRepository>().getMasterApiData(
          apiEndPoint: ApiConstants.getState, isShowLoader: true);
      if (response != null && response.statusCode == 100) {
        var res = decodeResponseData(responseData: response.data ?? '');
        if (res != null && res != '') {
          var tempList = dropdownCommonDataFromJson(res);
          stateList.addAll(tempList);
          stateList.insert(0, DropdownCommonData(id: 0, name: 'select state'));
        }
      }
    } catch (e) {
      LoggerUtils.logException('getGstRateFromServer', e);
    }
  }

  /// update focus based on field selection
  void changeFocus({required bool hasFocus, required int fieldNumber}) {
    if (fieldNumber == 1) {
      isFocusOnBusinessNameField.value = hasFocus;
    } else if (fieldNumber == 2) {
      isFocusOnBusinessContactNumberField.value = hasFocus;
    } else if (fieldNumber == 3) {
      isFocusOnBusinessMailField.value = hasFocus;
    } else if (fieldNumber == 4) {
      isFocusOnGstNumberField.value = hasFocus;
    } else if (fieldNumber == 5) {
      isFocusOnStateField.value = hasFocus;
    } else if (fieldNumber == 6) {
      isFocusOnCityField.value = hasFocus;
    } else if (fieldNumber == 7) {
      isFocusOnPinCodeField.value = hasFocus;
    } else if (fieldNumber == 8) {
      isFocusOnAddressField.value = hasFocus;
    }
  }

  /// checking validation for input field
  void validateUserInput({required int fieldNumber, bool isOnChange = true}) {
    /// FieldNumber = 1 : name , 2 : phoneNumber , 3 : emailId , 4 : gstNo , 5 : pinCode , 6 : address
    if (fieldNumber == 1 && isOnChange) {
      isValidName.value = false;
      isButtonEnable.value = false;
      nameStr.value = '';
      // if (businessNameController.text.trim().isEmpty) {
      //   nameStr.value = kBusinessNameRequiredValidation;
      // } else {
      if (businessNameController.text.trim().length > 3) {
        businessNameValidation();
        // }
      }
    } else if (fieldNumber == 1 && isOnChange == false) {
      isValidName.value = false;
      isButtonEnable.value = false;
      nameStr.value = '';
      if (businessNameController.text.trim().isEmpty) {
        // nameStr.value = kBusinessNameRequiredValidation;
      } else {
        businessNameValidation();
      }
    } else if (fieldNumber == 2 && isOnChange) {
      isValidPhoneNumber.value = false;
      isButtonEnable.value = false;
      mobileStr.value = '';
      // if (businessMobileNumberController.text.trim().isEmpty) {
      //   mobileStr.value = kMobileNumberRequiredValidation;
      // }
      // else {
      //   if (contactNumberController.text.trim().length > 10) {
      //     userPhoneNumberValidation();
      //   }
      // }
    } else if (fieldNumber == 2 && isOnChange == false) {
      isValidPhoneNumber.value = false;
      isButtonEnable.value = false;
      mobileStr.value = '';
      if (businessMobileNumberController.text.isEmpty) {
        // mobileStr.value = kMobileNumberRequiredValidation;
      } else {
        phoneNumberValidation();
      }
    } else if (fieldNumber == 3 && isOnChange) {
      isValidEmailId.value = false;
      isButtonEnable.value = false;
      emailStr.value = '';
      // if (businessEmailIdController.text.trim().isEmpty) {
      //   emailStr.value = kEmailIdRequiredValidation;
      // } else {
      if (businessEmailIdController.text.trim().length > 3) {
        emailIdValidation();
      }
      // }
    } else if (fieldNumber == 3 && isOnChange == false) {
      isValidEmailId.value = false;
      isButtonEnable.value = false;
      emailStr.value = '';
      if (businessEmailIdController.text.trim().isEmpty) {
        // emailStr.value = kEmailIdRequiredValidation;
      } else {
        emailIdValidation();
      }
    } else if (fieldNumber == 4 && isOnChange == false) {
      isValidGstNo.value = false;
      isButtonEnable.value = false;
      gstNoStr.value = '';
      gstNumberValidation();
    } else if (fieldNumber == 4) {
      isValidGstNo.value = false;
      isButtonEnable.value = false;
      gstNoStr.value = '';
    } else if (fieldNumber == 5 && isOnChange == false) {
      isValidPinCode.value = false;
      isButtonEnable.value = false;
      pinCodeStr.value = '';
      pinCodeValidation();
    } else if (fieldNumber == 5) {
      isValidPinCode.value = false;
      isButtonEnable.value = false;
      pinCodeStr.value = '';
    }
    /*else if (fieldNumber == 5 && isOnChange) {
      isValidPinCode.value = false;
      isButtonEnable.value = false;
      pinCodeStr.value = '';
      // if (pinCodeController.text.trim().isEmpty) {
      // pinCodeStr.value = kPinCodeRequiredValidation;
      // } else {}
    } else if (fieldNumber == 5 && isOnChange == false) {
      isValidPinCode.value = false;
      isButtonEnable.value = false;
      pinCodeStr.value = '';
      if (pinCodeController.text.trim().isEmpty) {
        // pinCodeStr.value = kPinCodeRequiredValidation;
      } else {
        pinCodeValidation();
      }
    } */
    else if (fieldNumber == 6 && isOnChange) {
      isValidAddress.value = false;
      isButtonEnable.value = false;
      addressStr.value = '';
      // if (addressController.text.trim().isEmpty) {
      //   addressStr.value = kAddressRequiredValidation;
      // } else {
      if (addressController.text.trim().length > 5) {
        addressValidation();
      }
      // }
    } else if (fieldNumber == 6 && isOnChange == false) {
      isValidAddress.value = false;
      isButtonEnable.value = false;
      addressStr.value = '';
      if (addressController.text.trim().isEmpty) {
        // addressStr.value = kAddressRequiredValidation;
      } else {
        addressValidation();
      }
    }
  }

  /// image picker
  Future<void> imagePicker(ImageSource source,
      {required isImagePickerForLogo}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: source);

    if (isImagePickerForLogo) {
      if (pickedImage != null) {
        final bytes = (await pickedImage.readAsBytes()).lengthInBytes;
        double kb = bytes / 1024;
        if (kb <= 100) {
          businessLogo.value = pickedImage;
          logoExtension.value = pickedImage.path.split('/').last;
          logoExtension.value = logoExtension.value.split('.').last;
          isSelectedLogoLessThan100Kb.value = true;
          isBusinessLogoSet.value = true;
          convertedLogoToBase64.value =
              await encodeImageToBase64(filePath: pickedImage.path);
        } else {
          Get.find<AlertMessageUtils>().showErrorSnackBar(kLogoSizeValidation);
          isBusinessLogoSet.value = false;
          isSelectedLogoLessThan100Kb.value = false;
        }
      }
    } else {
      if (pickedImage != null) {
        io.File? croppedImageFile = await ImageCropper().cropImage(
          sourcePath: pickedImage.path,
        );

        final bytes = (await croppedImageFile?.readAsBytes())?.lengthInBytes;
        if(bytes!=null){
          double kb = bytes / 1024;
          if (kb <= 250) {
            signatureExtension.value = croppedImageFile?.path.split('/').last??'';
            signatureExtension.value = signatureExtension.value.split('.').last;
            businessSignature.value = XFile(croppedImageFile?.path ?? '');
            isBusinessSignatureSet.value = true;
            isSelectedSignatureLessThan100Kb.value = true;
            convertedSignatureToBase64.value =
            await encodeImageToBase64(filePath: croppedImageFile?.path??'');
          } else {
            isBusinessSignatureSet.value = false;
            isSelectedSignatureLessThan100Kb.value = false;
          }}
      }
    }
  }

  /// call register business details api call
  Future<void> registerBusinessApiCall() async {
    if (gstNumberController.text.trim().isNotEmpty && isValidGstNo.value) {
      isGstEnabled.value = true;
    }
    try {
      BusinessSignUpRequestModel requestModel = BusinessSignUpRequestModel(
        userId: int.parse(userId.value),
        name: businessNameController.text.trim(),
        mobileNo: int.parse(businessMobileNumberController.text.trim()),
        emailId: businessEmailIdController.text.trim(),
        cityId: selectedCity.value.id == 0 ? null : '${selectedCity.value.id}',
        stateId:
            selectedState.value.id == 0 ? null : '${selectedState.value.id}',
        address: addressController.text.trim(),
        isGstEnabled: isGstEnabled.value,
        gstNo: gstNumberController.text.trim().isEmpty
            ? null
            : gstNumberController.text.trim(),
        pincode: pinCodeController.text.trim().isEmpty
            ? null
            : int.parse(pinCodeController.text.trim()),
        logo: convertedLogoToBase64.value,
        logoExtension: logoExtension.value,
        sign: convertedSignatureToBase64.value,
        signExtension: signatureExtension.value,
      );

      var response = await Get.find<RegistrationRepository>()
          .businessSignUpApi(requestModel: requestModel);

      if (response != null) {
        if (response.statusCode == 100) {
          var res = decodeResponseData(responseData: response.data ?? '');
          if (res != null && res != '') {
            businessData.value = businessSignUpResponseModelFromJson(res);
            Get.find<LocalStorage>().writeStringStorage(
              kStorageUserId,
              businessData.value.userId.toString(),
            );
            Get.find<LocalStorage>().writeStringStorage(
                kStorageBizId, (businessData.value.bizIds?[0] ?? 0).toString());
            Get.find<LocalStorage>().writeBoolStorage(kStorageIsLoggedIn, true);
            Get.find<LocalStorage>().writeStringStorage(
                kStorageToken, businessData.value.token ?? '');
            navigateToBottomNavBaseScreen();
          }
        } else {
          Get.find<AlertMessageUtils>().showErrorSnackBar(response.msg ?? '');
        }
      }
    } catch (e) {
      LoggerUtils.logException('registerBusinessApiCall', e);
    }
  }

  /// navigate to bottom nav base screen
  void navigateToBottomNavBaseScreen() {
    // Get.offAllNamed(kRouteBottomNavBaseScreen);
    Get.offNamedUntil(kRouteBottomNavBaseScreen, (route) => false);
  }

  /// checking logo or signature selected and less than 100 KB
  void checkLogoOrSignatureSelected() {
    // bool isLogoCheck = false;
    // bool isSignatureCheck = false;

    // if (isBusinessLogoSet.value && isSelectedLogoLessThan100Kb.value) {
    //   isLogoCheck = true;
    //   // if (isBusinessSignatureSet.value &&
    //   //     isSelectedSignatureLessThan100Kb.value) {
    //   //   checkRegexValidation();
    //   // } else {
    //   //   checkRegexValidation();
    //   // }
    // } else {
    //   isLogoCheck = false;
    //   Get.find<AlertMessageUtils>().showErrorSnackBar(kLogoSizeValidation);
    // }
    // if (isBusinessSignatureSet.value &&
    //     isSelectedSignatureLessThan100Kb.value) {
    //   isSignatureCheck = true;
    //   // if (isBusinessLogoSet.value && isSelectedLogoLessThan100Kb.value) {
    //   //   checkRegexValidation();
    //   // } else {
    //   //   checkRegexValidation();
    //   // }
    // } else {
    //   isSignatureCheck = false;
    //   Get.find<AlertMessageUtils>().showErrorSnackBar(kSignatureSizeValidation);
    // }
    if (isBusinessSignatureSet.value == false ||
        isBusinessLogoSet.value == false ||
        isBusinessLogoSet.value ||
        isBusinessSignatureSet.value) {
      checkRegexValidation();
    }
  }

  /// validate regex for input fields
  void checkRegexValidation() {
    /// FieldNumber = 1 : name , 2 : phoneNumber , 3 : emailId , 4 : gstNo , 5 : pinCode , 6 : address
    if (isButtonEnable.value) {
      registerBusinessApiCall();
    } else if (businessEmailIdController.text.trim().isEmpty ||
        businessMobileNumberController.text.trim().isEmpty ||
        businessNameController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty) {
      businessNameValidation();
      phoneNumberValidation();
      emailIdValidation();
      addressValidation();
    } else {
      if (!isValidName.value) {
        businessNameValidation();
        // validateUserInput(fieldNumber: 1);
      } else if (!isValidPhoneNumber.value) {
        phoneNumberValidation();
        // validateUserInput(fieldNumber: 2);
      } else if (!isValidEmailId.value) {
        emailIdValidation();
        // validateUserInput(fieldNumber: 3);
      } else if (!isValidGstNo.value) {
        gstNumberValidation();
        // validateUserInput(fieldNumber: 4);
      } else if (!isValidPinCode.value) {
        pinCodeValidation();
        // validateUserInput(fieldNumber: 5);
      } else if (!isValidAddress.value) {
        addressValidation();
        // validateUserInput(fieldNumber: 6);
      } else {
        registerBusinessApiCall();
      }
    }
  }

  bool businessNameValidation() {
    isValidName.value = false;
    if (businessNameController.text.trim().isNotEmpty) {
      if (!RegexData.nameRegex.hasMatch(businessNameController.text.trim())) {
        nameStr.value = kNameValidation;
      } else if (businessNameController.text.length < 3) {
        nameStr.value = kBusinessNameMinLengthValidation;
      } else {
        nameStr.value = '';
        isValidName.value = true;
      }
      if (isValidPhoneNumber.value &&
          isValidEmailId.value &&
          isValidAddress.value) {
        isButtonEnable.value = true;
      }
    } else {
      nameStr.value = kBusinessNameRequiredValidation;
    }
    return isValidName.value;
  }

  bool phoneNumberValidation() {
    isValidPhoneNumber.value = false;
    if (businessMobileNumberController.text.trim().isNotEmpty) {
      if (!RegexData.mobileNumberRegex
          .hasMatch(businessMobileNumberController.text.trim())) {
        mobileStr.value = kMobileNumberMaxValidation;
      } else if (businessMobileNumberController.text.length != 10) {
        mobileStr.value = kMobileNumberMaxValidation;
      } else {
        mobileStr.value = '';
        isValidPhoneNumber.value = true;
      }
      if (isValidName.value && isValidEmailId.value && isValidAddress.value) {
        isButtonEnable.value = true;
      }
    } else {
      mobileStr.value = kMobileNumberRequiredValidation;
    }
    return isValidPhoneNumber.value;
  }

  bool emailIdValidation() {
    isValidEmailId.value = false;
    if (businessEmailIdController.text.trim().isNotEmpty) {
      if (!RegexData.emailIdRegex
          .hasMatch(businessEmailIdController.text.trim())) {
        emailStr.value = kEmailIdValidation;
      } else {
        emailStr.value = '';
        isValidEmailId.value = true;
      }
      if (isValidName.value &&
          isValidPhoneNumber.value &&
          isValidAddress.value) {
        isButtonEnable.value = true;
      }
    } else {
      emailStr.value = kEmailIdRequiredValidation;
    }
    return isValidEmailId.value;
  }

  bool gstNumberValidation() {
    isValidGstNo.value = false;
    if (gstNumberController.text.isNotEmpty) {
      if (gstNumberController.text.trim().length != 15) {
        gstNoStr.value = kGstValidation;
      } else {
        gstNoStr.value = '';
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
      gstNoStr.value = '';
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

  bool pinCodeValidation() {
    isValidPinCode.value = false;
    if (pinCodeController.text.isNotEmpty) {
      if (pinCodeController.text.trim().length != 6) {
        pinCodeStr.value = kRequired;
        // pinCodeStr.value = kPinCodeValidation;
      } else {
        pinCodeStr.value = '';
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
      pinCodeStr.value = '';
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

  bool addressValidation() {
    isValidAddress.value = false;
    if (addressController.text.trim().isNotEmpty) {
      if (!RegexData.addressRegex.hasMatch(addressController.text.trim())) {
        addressStr.value = kAddressValidation;
      } else if (addressController.text.length < 5) {
        addressStr.value = kAddressMinValidation;
      } else {
        addressStr.value = '';
        isValidAddress.value = true;
      }
    } else {
      if (isValidName.value &&
          isValidPhoneNumber.value &&
          isValidEmailId.value &&
          isValidPinCode.value &&
          isValidGstNo.value) {
        isButtonEnable.value = true;
      } else {
        addressStr.value = kAddressRequiredValidation;
      }
    }
    return isValidAddress.value;
  }

  /// get city based on state selection
  Future<void> getCityBasedOnStateSelection() async {
    try {
      cityList.clear();
      var response = await Get.find<MasterRepository>()
          .getCitiesMasterApiData(stateId: '${selectedState.value.id ?? 0}');

      if (response != null) {
        if (response.statusCode == 100) {
          var res = decodeResponseData(responseData: response.data ?? '');
          if (res != null && res != '') {
            var tempList = dropdownCommonDataFromJson(res);
            cityList.addAll(tempList);
            cityList.insert(0, DropdownCommonData(id: 0, name: 'select city'));
            selectedCity.value = cityList[0];
          }
        } else {
          Get.find<AlertMessageUtils>().showErrorSnackBar(response.msg ?? '');
        }
      }
    } catch (e) {
      LoggerUtils.logException('getCityBasedOnStateSelection', e);
    }
  }
}
