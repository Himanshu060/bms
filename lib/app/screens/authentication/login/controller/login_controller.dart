import 'dart:math';

import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/local_storage_constants.dart';
import 'package:bms/app/common/route_constants.dart';
import 'package:bms/app/screens/authentication/login/model/request/login_request_model.dart';
import 'package:bms/app/screens/authentication/login/model/response/login_response_model.dart';
import 'package:bms/app/services/repository/authentication_repository.dart';
import 'package:bms/app/utils/alert_message_utils.dart';
import 'package:bms/app/utils/decode_response_data/decode_response_data.dart';
import 'package:bms/app/utils/local_storage.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:bms/app/utils/regex.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController userEmailOrMobileNumberController =
      TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isFocusOnMailField = false.obs;
  RxBool isFocusOnPasswordField = false.obs;

  RxBool isPasswordVisible = true.obs;

  Rx<LoginResponseModel> loginData = LoginResponseModel().obs;

  RxBool isUserNameOrMobileFieldNotEmpty = false.obs;
  RxBool isPasswordFieldNotEmpty = false.obs;
  RxBool isButtonEnable = false.obs;

  /// validation strings
  RxString userPhoneOrEmailStr = ''.obs;
  RxString userPasswordStr = ''.obs;
  RxString userPasswordStr2 = ''.obs;

  /// validation bool variables
  RxBool isValidPhoneOrEmail = false.obs;
  RxBool isValidPassword = false.obs;

  @override
  void onInit() {
    Get.lazyPut(() => AuthenticationRepository(), fenix: true);
    super.onInit();
  }

  /// update visibility of password field
  void updatePasswordVisibilityStatus() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// navigate to user sign up screen
  navigateToUserSignUpScreen() {
    Get.offAllNamed(kRouteUserSignUpScreen);
  }

  /// update focus based on field selection
  void changeFocus({required bool hasFocus, required isCheckForEmailField}) {
    if (isCheckForEmailField) {
      isFocusOnMailField.value = hasFocus;
    } else {
      isFocusOnPasswordField.value = hasFocus;
    }
  }

  /// checking validation for input field
  void validateUserInput({required int fieldNumber}) {
    /// FieldNumber = 1 : phoneNumber , 2 : emailId ,  3 : password
    if (fieldNumber == 1) {
      isValidPhoneOrEmail.value = false;
      if (userEmailOrMobileNumberController.text.length != 10 ||
          userEmailOrMobileNumberController.text.length > 10) {
        userPhoneOrEmailStr.value = kMobileNumberMaxValidation;
      } else {
        userPhoneOrEmailStr.value = '';
        isValidPhoneOrEmail.value = true;
      }
      if (isValidPhoneOrEmail.value && isValidPassword.value) {
        isValidPhoneOrEmail.value = true;
        isButtonEnable.value = true;
      }
    }
    if (fieldNumber == 2) {
      isValidPhoneOrEmail.value = false;
      if (!RegexData.emailIdRegex
          .hasMatch(userEmailOrMobileNumberController.text.trim())) {
        userPhoneOrEmailStr.value = kEmailIdValidation;
      } else if (userEmailOrMobileNumberController.text.length > 50) {
        userPhoneOrEmailStr.value = kEmailIdMaxValidation;
      } else {
        userPhoneOrEmailStr.value = '';
        isValidPhoneOrEmail.value = true;
      }
      if (isValidPhoneOrEmail.value && isValidPassword.value) {
        isButtonEnable.value = true;
      }
    }
    if (fieldNumber == 3) {
      isValidPassword.value = false;
      if (passwordController.text.trim().isNotEmpty) {
        if (!RegexData.passwordRegex.hasMatch(passwordController.text.trim())) {
          userPasswordStr.value = kPasswordValidation;
          userPasswordStr2.value = kPasswordValidation2;
        } else if (passwordController.text.length >= 20 &&
            passwordController.text.length < 8) {
          userPasswordStr.value = kPasswordValidation;
          userPasswordStr2.value = kPasswordValidation2;
        } else {
          userPasswordStr.value = '';
          userPasswordStr2.value = '';
          isValidPassword.value = true;
        }
        if (isValidPhoneOrEmail.value && isValidPassword.value) {
          isButtonEnable.value = true;
        }
      } else {
        // userPasswordStr.value = kPasswordRequiredValidation;
        userPasswordStr.value = '';
        userPasswordStr2.value = '';
      }
    }

    // if (userEmailOrMobileNumberController.text.trim().isNotEmpty &&
    //     passwordController.text.trim().isNotEmpty) {
    //   isButtonEnable.value = true;
    // } else {
    //   isButtonEnable.value = false;
    // }
  }

  /// call login api
  Future<void> callLoginAPi() async {
    try {
      LoginRequestModel requestModel = LoginRequestModel(
        userName: userEmailOrMobileNumberController.text.trim(),
        password: passwordController.text.trim(),
      );

      var response = await Get.find<AuthenticationRepository>()
          .loginApiCall(requestModel: requestModel);

      if (response != null) {
        if (response.statusCode == 100) {
          var res = decodeResponseData(responseData: response.data ?? '');
          loginData.value = loginResponseModelFromJson(res);
          if (res != null && res != '') {
            Get.find<LocalStorage>()
                .writeStringStorage(kStorageToken, loginData.value.token ?? '');
            Get.find<LocalStorage>().writeStringStorage(
                kStorageUserId, loginData.value.userId.toString());
            if (loginData.value.bizIds == [] ||
                (loginData.value.bizIds ?? []).isEmpty) {
              loginData.value = loginResponseModelFromJson(res);
              Get.find<LocalStorage>()
                  .writeBoolStorage(kStorageIsLoggedIn, false);
              navigateToSignUpScreen();
            } else {
              Get.find<LocalStorage>().writeStringStorage(
                  kStorageBizId, (loginData.value.bizIds?[0] ?? 0).toString());
              loginData.value = loginResponseModelFromJson(res);
              Get.find<LocalStorage>()
                  .writeBoolStorage(kStorageIsLoggedIn, true);
              navigateToBottomBarNavScreen();
            }
          }
        } else {
          Get.find<AlertMessageUtils>().showErrorSnackBar(response.msg ?? '');
        }
      }
    } catch (e) {
      LoggerUtils.logException('callLoginAPi', e);
    }
  }

  void navigateToBottomBarNavScreen() {
    Get.offNamed(kRouteBottomNavBaseScreen);
    // Get.offNamedUntil(kRouteBottomNavBaseScreen, (route) => false);
  }

  /// navigate to sign up screen
  void navigateToSignUpScreen() {
    Get.offNamedUntil(
      kRouteBusinessSignUpScreen,
      ModalRoute.withName(kRouteLoginScreen),
    );
  }

  /// navigate to forgot password screen
  void navigateToForgotPasswordScreen() {
    Get.toNamed(kRouteForgotPasswordScreen);
  }

  /// validate regex for input fields
  void checkRegexValidation() {
    if (isButtonEnable.value) {
      callLoginAPi();
    }
    // else if (!isValidPhoneOrEmail.value && !isValidPassword.value) {
    //   userPhoneOrEmailStr.value = kPleaseEnterEmailOrPhoneNumber;
    // checkInputIsDigitOrMail(fieldNumber: 1);
    // validateUserInput(fieldNumber: 1);
    // }
    else if (passwordController.text.trim().isEmpty ||
        userEmailOrMobileNumberController.text.trim().isEmpty) {
      userPhoneOrEmailStr.value = kPleaseEnterEmailOrPhoneNumber;
      userPasswordStr.value = kPasswordRequiredValidation;
    } else {
      if (!isValidPhoneOrEmail.value) {
        validateUserInput(fieldNumber: 1);
      } else if (!isValidPassword.value) {
        validateUserInput(fieldNumber: 3);
      }
    }
    // mobile number and password regex validation
    // if (RegexData.mobileNumberRegex
    //         .hasMatch(userEmailOrMobileNumberController.text.trim()) &&
    //     RegexData.passwordRegex.hasMatch(passwordController.text.trim()) &&
    //     userEmailOrMobileNumberController.text.length == 10 &&
    //     passwordController.text.length <= 20) {
    //   callLoginAPi();
    // }
    //
    // // email id and password regex validation
    // else if (RegexData.emailIdRegex
    //         .hasMatch(userEmailOrMobileNumberController.text.trim()) &&
    //     RegexData.passwordRegex.hasMatch(passwordController.text.trim()) &&
    //     userEmailOrMobileNumberController.text.length <= 25 &&
    //     userEmailOrMobileNumberController.text.length > 3 &&
    //     passwordController.text.length <= 20) {
    //   callLoginAPi();
    // } else {
    //   Get.find<AlertMessageUtils>()
    //       .showErrorSnackBar(kLoginCredentialsValidation);
    // }
  }

  void checkInputIsDigitOrMail(
      {required fieldNumber, bool isOnChangeCall = true}) {
    if (fieldNumber == 1) {
      if (isOnChangeCall) {
        isValidPhoneOrEmail.value = false;
        userPhoneOrEmailStr.value = '';
        if (userEmailOrMobileNumberController.text.trim().isNotEmpty) {
          if (RegexData.digitRegex
              .hasMatch(userEmailOrMobileNumberController.text.trim())) {
            if (userEmailOrMobileNumberController.text.length > 10) {
              validateUserInput(fieldNumber: 1);
            } else {
              userPhoneOrEmailStr.value = '';
              isValidPhoneOrEmail.value = true;
            }
          } else if (!isValidPhoneOrEmail.value) {
            validateUserInput(fieldNumber: 2);
          }
        }
      } else {
        isValidPhoneOrEmail.value = false;
        userPhoneOrEmailStr.value = '';
        if (userEmailOrMobileNumberController.text.trim().isNotEmpty) {
          if (RegexData.digitRegex
              .hasMatch(userEmailOrMobileNumberController.text.trim())) {
            if (userEmailOrMobileNumberController.text.length != 10) {
              validateUserInput(fieldNumber: 1);
            } else {
              userPhoneOrEmailStr.value = '';
              isValidPhoneOrEmail.value = true;
            }
          } else if (!isValidPhoneOrEmail.value) {
            validateUserInput(fieldNumber: 2);
          }
        }
      }
    } else if (fieldNumber == 2) {
      isValidPassword.value = false;
      if (isOnChangeCall) {
        if (passwordController.text.trim().isNotEmpty) {
          userPasswordStr.value = '';
          if (RegexData.passwordRegex
              .hasMatch(passwordController.text.trim())) {
            if (passwordController.text.trim().length > 8) {
              validateUserInput(fieldNumber: 3);
            }
            // else {
            //   userPasswordStr.value = '';
            //   userPasswordStr2.value = '';
            //   isValidPassword.value = true;
            // }
          } else if (!isValidPassword.value &&
              passwordController.text.trim().length >= 7) {
            validateUserInput(fieldNumber: 3);
          }
          // else if (passwordController.text.trim().isEmpty) {
          //   userPasswordStr.value = kPasswordRequiredValidation;
          // }
        }
      } else {
        validateUserInput(fieldNumber: 3);
      }
    }
    // validateUserInput(fieldNumber: 1);
  }
}
