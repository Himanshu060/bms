import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/route_constants.dart';
import 'package:bms/app/screens/authentication/forgot_password/model/request/check_user_exist_request_model.dart';
import 'package:bms/app/screens/authentication/forgot_password/model/response/check_user_exist_response_model.dart';
import 'package:bms/app/screens/authentication/user_sign_up/model/request/user_sign_up_request_model.dart';
import 'package:bms/app/services/repository/authentication_repository.dart';
import 'package:bms/app/utils/alert_message_utils.dart';
import 'package:bms/app/utils/decode_response_data/decode_response_data.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:bms/app/utils/regex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserSignUpController extends GetxController {
  TextEditingController userNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  RxDouble textFieldsHeight = 55.0.obs;
  EdgeInsets textFieldsMargin = const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0);

  RxBool isFocusOnUserNameField = false.obs;
  RxBool isFocusOnContactNumberField = false.obs;
  RxBool isFocusOnEmailIdField = false.obs;
  RxBool isFocusOnPasswordField = false.obs;
  RxBool isFocusOnConfirmPasswordField = false.obs;

  RxBool isPasswordVisible = true.obs;
  RxBool isConfirmPasswordVisible = true.obs;

  RxBool isButtonEnable = false.obs;

  /// validation strings
  RxString userNameStr = ''.obs;
  RxString userMobileStr = ''.obs;
  RxString userEmailStr = ''.obs;
  RxString userPasswordStr = ''.obs;
  RxString userPasswordStr2 = ''.obs;
  RxString userConfirmPasswordStr = ''.obs;

  /// validation bool variables
  RxBool isValidName = false.obs;
  RxBool isValidPhoneNumber = false.obs;
  RxBool isValidEmailId = false.obs;
  RxBool isValidPassword = false.obs;
  RxBool isValidConfirmPass = false.obs;

  @override
  void onInit() {
    Get.lazyPut(() => AuthenticationRepository(),fenix: true);
    super.onInit();
  }
  
  /// update focus based on field selection
  void changeFocus({required bool hasFocus, required int fieldNumber}) {
    if (fieldNumber == 1) {
      isFocusOnUserNameField.value = hasFocus;
    } else if (fieldNumber == 2) {
      isFocusOnEmailIdField.value = hasFocus;
    } else if (fieldNumber == 3) {
      isFocusOnContactNumberField.value = hasFocus;
    } else if (fieldNumber == 4) {
      isFocusOnPasswordField.value = hasFocus;
    } else if (fieldNumber == 5) {
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
  void validateUserInput({required int fieldNumber, bool isOnChange = true}) {
    /// FieldNumber = 1 : name , 2 : phoneNumber , 3 : emailId , 4 : password , 5 : confirm password
    if (fieldNumber == 1 && isOnChange) {
      isValidName.value = false;
      isButtonEnable.value = false;
      userNameStr.value = '';
      // if (userNameController.text.trim().isEmpty) {
      //   userNameStr.value = kUserNameRequiredValidation;
      // } else {
      if (userNameController.text.trim().length > 3) {
        userNameValidation();
      }
      // }
    } else if (fieldNumber == 1 && isOnChange == false) {
      isValidName.value = false;
      isButtonEnable.value = false;
      userNameStr.value = '';
      if (userNameController.text.trim().isEmpty) {
        // userNameStr.value = kUserNameRequiredValidation;
      } else {
        userNameValidation();
      }
    } else if (fieldNumber == 2 && isOnChange) {
      isValidPhoneNumber.value = false;
      isButtonEnable.value = false;
      userMobileStr.value = '';
      // if (contactNumberController.text.trim().isEmpty) {
      //   userMobileStr.value = kMobileNumberRequiredValidation;
      // }
      // else {
      //   if (contactNumberController.text.trim().length > 10) {
      //     userPhoneNumberValidation();
      //   }
      // }
    } else if (fieldNumber == 2 && isOnChange == false) {
      isValidPhoneNumber.value = false;
      isButtonEnable.value = false;
      userMobileStr.value = '';
      if (contactNumberController.text.isEmpty) {
        // userMobileStr.value = kMobileNumberRequiredValidation;
      } else {
        userPhoneNumberValidation();
      }
    } else if (fieldNumber == 3 && isOnChange) {
      isValidEmailId.value = false;
      isButtonEnable.value = false;
      userEmailStr.value = '';
      // if (emailIdController.text.trim().isEmpty) {
      //   userEmailStr.value = kEmailIdRequiredValidation;
      // } else {
      if (emailIdController.text.trim().length > 3) {
        useEmailValidation();
        // }
      }
    } else if (fieldNumber == 3 && isOnChange == false) {
      isValidEmailId.value = false;
      isButtonEnable.value = false;
      userEmailStr.value = '';
      if (emailIdController.text.trim().isEmpty) {
        // userEmailStr.value = kEmailIdRequiredValidation;
      } else {
        useEmailValidation();
      }
    } else if (fieldNumber == 4 && isOnChange) {
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
    } else if (fieldNumber == 4 && isOnChange == false) {
      isValidPassword.value = false;
      isButtonEnable.value = false;
      userPasswordStr.value = '';
      if (passwordController.text.trim().isEmpty) {
        // userPasswordStr.value = kPasswordRequiredValidation;
        // userPasswordStr2.value = '';
      } else {
        // if (!isValidConfirmPass.value ||
        //     confirmPasswordController.text.trim().isNotEmpty) {
        //   isValidConfirmPass.value = false;
        //   confirmPasswordValidation();
        // } else {
        passwordValidation();
        // }
      }
    } else if (fieldNumber == 5 && isOnChange) {
      isValidConfirmPass.value = false;
      isButtonEnable.value = false;
      userConfirmPasswordStr.value = '';
      if (confirmPasswordController.text.trim().isNotEmpty) {
        confirmPasswordValidation();
      }
    } else if (fieldNumber == 5 && isOnChange == false) {
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

  /// navigate to login screen
  navigateToLoginScreen() {
    Get.offAllNamed(kRouteLoginScreen);
  }

  /// navigate to verify otp screen
  void navigateToVerifyOtpScreen() {
    UserSignUpRequestModel requestModel = UserSignUpRequestModel(
      emailId: emailIdController.text.trim(),
      mobileNo: int.parse(contactNumberController.text.trim()),
      password: passwordController.text.trim(),
      name: userNameController.text.trim(),
    );

    Get.toNamed(kRouteVerifyOtpScreen, arguments: [requestModel,false]);
  }


  /// check user exist api call
  Future<void> checkUserExistOrNot() async {
    try {
      var requestModel = CheckUserExistRequestModel(
        mobileNo: int.parse(contactNumberController.text.trim()),
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
            Get.find<AlertMessageUtils>().showErrorSnackBar(kUserAlreadyExist);
          } else {
            navigateToVerifyOtpScreen();
          }
        }
      }
    } catch (e) {
      LoggerUtils.logException('checkUserExistOrNot', e);
    }
  }
  
  /// validate regex for input fields
  void checkRegexValidation() {
    /// FieldNumber = 1 : name , 2 : phoneNumber , 3 : emailId , 4 : password , 5 : confirm password
    if (isButtonEnable.value) {
      // navigateToVerifyOtpScreen();
      checkUserExistOrNot();
    }
    // else if (!isValidName.value &&
    //     !isValidPhoneNumber.value &&
    //     !isValidEmailId.value &&
    //     !isValidPassword.value &&
    //     !isValidConfirmPass.value) {
    //   userNameStr.value = kNameRequiredValidation;
    // }
    else if (userNameController.text.trim().isEmpty ||
        contactNumberController.text.trim().isEmpty ||
        emailIdController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty) {
      userNameValidation();
      userPhoneNumberValidation();
      useEmailValidation();
      passwordValidation();
      confirmPasswordValidation();
      // userNameStr.value = kUserNameRequiredValidation;
      // userMobileStr.value = kMobileNumberRequiredValidation;
      // userEmailStr.value = kEmailIdRequiredValidation;
      // userPasswordStr.value = kPasswordRequiredValidation;
      // userConfirmPasswordStr.value = kConfirmPasswordRequiredValidation;
    } else {
      if (!isValidName.value) {
        validateUserInput(fieldNumber: 1);
      } else if (!isValidPhoneNumber.value) {
        validateUserInput(fieldNumber: 2);
      } else if (!isValidEmailId.value) {
        validateUserInput(fieldNumber: 3);
      } else if (!isValidPassword.value) {
        validateUserInput(fieldNumber: 4);
      } else if (!isValidConfirmPass.value) {
        validateUserInput(fieldNumber: 5);
      }
    }
  }

  bool userNameValidation() {
    isValidName.value = false;
    if (userNameController.text.trim().isNotEmpty) {
      if (!RegexData.nameRegex.hasMatch(userNameController.text.trim())) {
        userNameStr.value = kNameValidation;
      } else if (userNameController.text.length < 3) {
        userNameStr.value = kUserNameMinLengthValidation;
      } else {
        userNameStr.value = '';
        isValidName.value = true;
      }
      if (isValidPhoneNumber.value &&
          isValidEmailId.value &&
          isValidPassword.value &&
          isValidConfirmPass.value) {
        isButtonEnable.value = true;
      }
    } else {
      userNameStr.value = kUserNameRequiredValidation;
    }
    return isValidName.value;
  }

  bool userPhoneNumberValidation() {
    isValidPhoneNumber.value = false;
    if (contactNumberController.text.trim().isNotEmpty) {
      // if (!RegexData.mobileNumberRegex
      if (!RegexData.digitRegex.hasMatch(contactNumberController.text.trim())) {
        userMobileStr.value = kMobileNumberMaxValidation;
      } else if (contactNumberController.text.length != 10) {
        userMobileStr.value = kMobileNumberMaxValidation;
      } else {
        userMobileStr.value = '';
        isValidPhoneNumber.value = true;
      }
      if (isValidName.value &&
          isValidEmailId.value &&
          isValidPassword.value &&
          isValidConfirmPass.value) {
        isButtonEnable.value = true;
      }
    } else {
      userMobileStr.value = kMobileNumberRequiredValidation;
    }
    return isValidPhoneNumber.value;
  }

  bool useEmailValidation() {
    isValidEmailId.value = false;
    if (emailIdController.text.trim().isNotEmpty) {
      if (!RegexData.emailIdRegex.hasMatch(emailIdController.text.trim())) {
        userEmailStr.value = kEmailIdValidation;
      } else if (emailIdController.text.length > 50) {
        userEmailStr.value = kEmailIdMaxValidation;
      } else if (emailIdController.text.trim().length < 3) {
        userEmailStr.value = kEmailIdValidation;
      } else {
        userEmailStr.value = '';
        isValidEmailId.value = true;
      }
      if (isValidName.value &&
          isValidPhoneNumber.value &&
          isValidPassword.value &&
          isValidConfirmPass.value) {
        isButtonEnable.value = true;
      }
    } else {
      userEmailStr.value = kEmailIdRequiredValidation;
    }
    return isValidEmailId.value;
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
      if (isValidName.value &&
          isValidPhoneNumber.value &&
          isValidEmailId.value &&
          isValidConfirmPass.value) {
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
      if (isValidName.value &&
          isValidPhoneNumber.value &&
          isValidEmailId.value &&
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
}
