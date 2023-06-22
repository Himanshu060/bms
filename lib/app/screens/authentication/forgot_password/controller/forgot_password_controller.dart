import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/local_storage_constants.dart';
import 'package:bms/app/common/route_constants.dart';
import 'package:bms/app/common/status_codes.dart';
import 'package:bms/app/screens/authentication/forgot_password/model/request/check_user_exist_request_model.dart';
import 'package:bms/app/screens/authentication/forgot_password/model/request/forgot_password_request_model.dart';
import 'package:bms/app/screens/authentication/user_sign_up/model/request/user_sign_up_request_model.dart';
import 'package:bms/app/services/repository/authentication_repository.dart';
import 'package:bms/app/utils/alert_message_utils.dart';
import 'package:bms/app/utils/decode_response_data/decode_response_data.dart';
import 'package:bms/app/utils/local_storage.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:bms/app/utils/regex.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../model/response/check_user_exist_response_model.dart';

class ForgotPasswordController extends GetxController {
  RxDouble textFieldsHeight = 55.0.obs;
  EdgeInsets textFieldsMargin =
      const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0);

  TextEditingController mobileNumberController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  RxBool isFocusOnCustomerNumberField = false.obs;
  RxBool isOptVerifiedSuccessfully = false.obs;

  RxString customerMobileStr = ''.obs;
  RxBool isValidPhoneNumber = false.obs;

  RxBool isFocusOnPasswordField = false.obs;
  RxBool isFocusOnConfirmPasswordField = false.obs;

  RxBool isPasswordVisible = true.obs;
  RxBool isConfirmPasswordVisible = true.obs;

  RxBool isButtonEnable = false.obs;

  /// validation strings
  RxString userPasswordStr = ''.obs;
  RxString userPasswordStr2 = ''.obs;
  RxString userConfirmPasswordStr = ''.obs;

  /// validation bool variables
  RxBool isValidPassword = false.obs;
  RxBool isValidConfirmPass = false.obs;

  String idToken = '';
  String userId = '';

  @override
  Future<void> onInit() async {
    Get.lazyPut(() => AuthenticationRepository(), fenix: true);
    userId =
        await Get.find<LocalStorage>().getStringFromStorage(kStorageUserId);
    super.onInit();
  }

  /// update focus based on field selection
  void changeFocus({required bool hasFocus, required int fieldNumber}) {
    if (fieldNumber == 1) {
      isFocusOnPasswordField.value = hasFocus;
    } else if (fieldNumber == 2) {
      isFocusOnConfirmPasswordField.value = hasFocus;
    }
  }

  /// update visibility of password field
  void updatePasswordVisibilityStatus() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// update visibility of confirm password field
  void updateConfirmPasswordVisibilityStatus() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  /// checking validation for input field
  void validateUserInput({required fieldNumber, bool isOnChange = true}) {
    /// 1 : mobile no. , 2 : password , 3 : confirm password
    if (fieldNumber == 1 && isOnChange) {
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
      if (mobileNumberController.text.isNotEmpty) {
        phoneNumberValidation(isOnChange: true);
      }
    } else if (fieldNumber == 1 && isOnChange == false) {
      isValidPhoneNumber.value = false;
      isButtonEnable.value = false;
      customerMobileStr.value = '';
      if (mobileNumberController.text.isEmpty) {
        // customerMobileStr.value = kMobileNumberRequiredValidation;
      } else {
        phoneNumberValidation();
      }
    } else if (fieldNumber == 2 && isOnChange) {
      isValidPassword.value = false;
      isButtonEnable.value = false;
      userPasswordStr.value = '';
      // if (passwordController.text.trim().isEmpty) {
      //   userPasswordStr.value = kPasswordRequiredValidation;
      //   userPasswordStr2.value = '';
      // } else {
      if (passwordController.text.trim().length > 8) {
        passwordValidation();
        // }
      }
    } else if (fieldNumber == 2 && isOnChange == false) {
      isValidPassword.value = false;
      isButtonEnable.value = false;
      userPasswordStr.value = '';
      if (passwordController.text.trim().isEmpty) {
        // userPasswordStr.value = kPasswordRequiredValidation;
        // userPasswordStr2.value = '';
      }
    } else if (fieldNumber == 3 && isOnChange) {
      isValidConfirmPass.value = false;
      isButtonEnable.value = false;
      userConfirmPasswordStr.value = '';
      if (confirmPasswordController.text.trim().isNotEmpty) {
        confirmPasswordValidation();
      }
    } else if (fieldNumber == 3 && isOnChange == false) {
      isValidConfirmPass.value = false;
      isButtonEnable.value = false;
      userConfirmPasswordStr.value = '';
      if (confirmPasswordController.text.trim().isEmpty) {
        // userPasswordStr.value = kPasswordRequiredValidation;
        // userPasswordStr2.value = '';
      } else {
        confirmPasswordValidation();
      }
    }
  }

  /// phone number validation
  bool phoneNumberValidation({bool isOnChange = false}) {
    isValidPhoneNumber.value = false;
    if (mobileNumberController.text.trim().isNotEmpty) {
      if (!RegexData.mobileNumberRegex
          .hasMatch(mobileNumberController.text.trim())) {
        customerMobileStr.value = isOnChange ? "" : kMobileNumberMaxValidation;
      } else if (mobileNumberController.text.length != 10) {
        customerMobileStr.value = isOnChange ? "" : kMobileNumberMaxValidation;
      } else {
        customerMobileStr.value = '';
        isValidPhoneNumber.value = true;

        isButtonEnable.value = true;
      }
    } else {
      customerMobileStr.value =
          isOnChange ? "" : kMobileNumberRequiredValidation;
    }
    return isValidPhoneNumber.value;
  }

  bool passwordValidation() {
    isValidPassword.value = false;
    if (passwordController.text.trim().isNotEmpty) {
      if (!RegexData.passwordRegex.hasMatch(passwordController.text.trim())) {
        userPasswordStr.value = kPasswordValidation;
        userPasswordStr2.value = kPasswordValidation2;
      } else if (passwordController.text.length > 20) {
        userPasswordStr.value = kPasswordMaxValidation;
        userPasswordStr2.value = kPasswordValidation2;
      } else if (passwordController.text.length < 8) {
        userPasswordStr.value = kPasswordMinValidation;
        userPasswordStr2.value = kPasswordValidation2;
      } else {
        userPasswordStr.value = '';
        userPasswordStr2.value = '';
        isValidPassword.value = true;
      }
      if (isValidPhoneNumber.value && isValidConfirmPass.value) {
        isButtonEnable.value = true;
      }
    } else {
      userPasswordStr.value = kPasswordRequiredValidation;
      userPasswordStr2.value = '';
    }
    return isValidPassword.value;
  }

  bool confirmPasswordValidation() {
    isValidConfirmPass.value = false;
    if (confirmPasswordController.text.trim().isNotEmpty) {
      if (confirmPasswordController.text.trim() !=
          passwordController.text.trim()) {
        userConfirmPasswordStr.value = kConfirmPasswordValidation;
      } else {
        userConfirmPasswordStr.value = '';
        isValidConfirmPass.value = true;
      }
      if (isValidPhoneNumber.value &&
          isValidPassword.value &&
          passwordController.text.trim() ==
              confirmPasswordController.text.trim()) {
        isButtonEnable.value = true;
      }
    } else {
      userConfirmPasswordStr.value = kConfirmPasswordRequiredValidation;
    }
    return isValidConfirmPass.value;
  }

  /// navigate to verify otp screen
  Future<void> navigateToVerifyOtpScreen() async {
    UserSignUpRequestModel requestModel = UserSignUpRequestModel(
      mobileNo: int.parse(mobileNumberController.text.trim()),
    );

    var isOptVerified = await Get.toNamed(kRouteVerifyOtpScreen,
        arguments: [requestModel, true]);

    if (isOptVerified[0] == true) {
      isOptVerifiedSuccessfully.value = true;
      idToken = (isOptVerified[1] as String);
      isButtonEnable.value = false;
    }
  }

  /// check validations
  void checkValidationAndNavigate({bool isForResetPassword = false}) {
    if (isForResetPassword == true) {
      if (isButtonEnable.value) {
        forgotPasswordApiCall();
      } else if (passwordController.text.trim().isEmpty ||
          confirmPasswordController.text.trim().isEmpty) {
        passwordValidation();
        confirmPasswordValidation();
      } else {
        if (!isValidPassword.value) {
          validateUserInput(fieldNumber: 2);
        } else if (!isValidConfirmPass.value) {
          validateUserInput(fieldNumber: 3);
        }
      }
    } else {
      if (isButtonEnable.value && isOptVerifiedSuccessfully.value == false) {
        // navigateToVerifyOtpScreen();
        checkUserExistOrNot();
      }
      if (!isValidPhoneNumber.value) {
        phoneNumberValidation();
        // validateUserInput(fieldNumber: 2);
      }
    }
  }

  /// check user exist api call
  Future<void> checkUserExistOrNot() async {
    try {
      var requestModel = CheckUserExistRequestModel(
        mobileNo: int.parse(mobileNumberController.text.trim()),
        emailId: 'admin@gmail.com',
      );
      var response = await Get.find<AuthenticationRepository>()
          .checkUserExistApiCall(requestModel: requestModel);

      if (response != null && response.data != null) {
        var res = decodeResponseData(responseData: response.data ?? '');
        if (res != null && res != '') {
          CheckUserExistResponseModel checkUserExist =
              checkUserExistResponseModelFromJson(res);
          if (checkUserExist.exist == "1") {
            navigateToVerifyOtpScreen();
          } else {
            Get.find<AlertMessageUtils>().showErrorSnackBar(kUserDoesntExist);
          }
        }
      }
    } catch (e) {
      LoggerUtils.logException('checkUserExistOrNot', e);
    }
  }

  Future<void> forgotPasswordApiCall() async {
    try {
      var requestModel = ForgotPasswordRequestModel(
        mobileNo: int.parse(mobileNumberController.text.trim()),
        idToken: idToken,
        password: passwordController.text.trim(),
        isMobileVerification: true,
      );
      var response = await Get.find<AuthenticationRepository>().forgotPasswordApiCall(requestModel: requestModel);
      if (response != null && response.data != null) {
        if(response.statusCode == successStatusCode){
          Get.offAllNamed(kRouteLoginScreen);
        }
      }
    } catch (e) {
      LoggerUtils.logException('forgotPasswordApiCall', e);
    }
  }
}
