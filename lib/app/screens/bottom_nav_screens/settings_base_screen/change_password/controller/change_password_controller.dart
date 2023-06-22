import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/local_storage_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/change_password/model/request/change_password_request_model.dart';
import 'package:bms/app/services/repository/setting_repository.dart';
import 'package:bms/app/utils/alert_message_utils.dart';
import 'package:bms/app/utils/local_storage.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:bms/app/utils/regex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  var bizId = '';
  var userId = '';

  RxDouble textFieldsHeight = 55.0.obs;
  EdgeInsets textFieldsMargin =
      const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0);

  RxBool isFocusOnPasswordField = false.obs;
  RxBool isFocusOnConfirmPasswordField = false.obs;
  RxBool isFocusOnOldPasswordField = false.obs;

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  /// validation strings
  RxString oldPasswordStr = ''.obs;
  RxString oldPasswordStr2 = ''.obs;
  RxString userPasswordStr = ''.obs;
  RxString userPasswordStr2 = ''.obs;
  RxString userConfirmPasswordStr = ''.obs;

  /// validation bool variables
  RxBool isValidOldPassword = false.obs;
  RxBool isValidPassword = false.obs;
  RxBool isValidConfirmPass = false.obs;

  RxBool isButtonEnable = false.obs;

  RxBool isOldPasswordVisible = true.obs;
  RxBool isPasswordVisible = true.obs;
  RxBool isConfirmPasswordVisible = true.obs;

  @override
  Future<void> onInit() async {
    Get.lazyPut(() => SettingRepository(), fenix: true);
    bizId = await Get.find<LocalStorage>().getStringFromStorage(kStorageBizId);
    userId =
        await Get.find<LocalStorage>().getStringFromStorage(kStorageUserId);
    super.onInit();
  }

  /// update visibility of old password field
  void updateOldPasswordVisibilityStatus() {
    isOldPasswordVisible.value = !isOldPasswordVisible.value;
  }

  /// update visibility of password field
  void updatePasswordVisibilityStatus() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// update visibility of confirm password field
  void updateConfirmPasswordVisibilityStatus() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  /// update focus based on field selection
  void changeFocus({required bool hasFocus, required int fieldNumber}) {
    if (fieldNumber == 1) {
      isFocusOnPasswordField.value = hasFocus;
    } else if (fieldNumber == 2) {
      isFocusOnConfirmPasswordField.value = hasFocus;
    } else if (fieldNumber == 3) {
      isFocusOnOldPasswordField.value = hasFocus;
    }
  }

  /// checking validation for input field
  void validateUserInput({required fieldNumber, bool isOnChange = true}) {
    /// 1 : old password , 2 : password , 3 : confirm password
    if (fieldNumber == 1 && isOnChange) {
      isValidOldPassword.value = false;
      isButtonEnable.value = false;
      oldPasswordStr.value = '';
      if (oldPasswordController.text.trim().length > 8) {
        oldPasswordValidation();
      }
    } else if (fieldNumber == 1 && isOnChange == false) {
      isValidOldPassword.value = false;
      isButtonEnable.value = false;
      oldPasswordStr.value = '';
      if (oldPasswordController.text.isNotEmpty) {
        oldPasswordValidation();
      }
    } else if (fieldNumber == 2 && isOnChange) {
      isValidPassword.value = false;
      isButtonEnable.value = false;
      userPasswordStr.value = '';
      if (newPasswordController.text.trim().length > 8) {
        passwordValidation();
      }
    } else if (fieldNumber == 2 && isOnChange == false) {
      isValidPassword.value = false;
      isButtonEnable.value = false;
      userPasswordStr.value = '';
      if (newPasswordController.text.trim().isNotEmpty) {
        passwordValidation();
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
      if (confirmPasswordController.text.trim().isNotEmpty) {
        confirmPasswordValidation();
      }
    }
  }

  bool oldPasswordValidation({bool isOnChange = true}) {
    isValidOldPassword.value = false;
    if (oldPasswordController.text.trim().isNotEmpty) {
      if (!RegexData.passwordRegex
          .hasMatch(oldPasswordController.text.trim())) {
        oldPasswordStr.value = isOnChange == false ? '' : kPasswordValidation;
        oldPasswordStr2.value = isOnChange == false ? '' : kPasswordValidation2;
      } else if (oldPasswordController.text.length < 8) {
        oldPasswordStr.value =
            isOnChange == false ? '' : kPasswordMinValidation;
        oldPasswordStr2.value = isOnChange == false ? '' : kPasswordValidation2;
      } else {
        oldPasswordStr.value = '';
        oldPasswordStr2.value = '';
        isValidOldPassword.value = true;
      }
      if (isValidOldPassword.value &&
          isValidPassword.value &&
          isValidConfirmPass.value) {
        isButtonEnable.value = true;
      }
    } else {
      oldPasswordStr.value =
          isOnChange == false ? '' : kOldPasswordRequiredValidation;
      oldPasswordStr2.value = '';
    }
    return isValidOldPassword.value;
  }

  bool passwordValidation({bool isOnChange = true}) {
    isValidPassword.value = false;
    if (newPasswordController.text.trim().isNotEmpty) {
      if (!RegexData.passwordRegex
          .hasMatch(newPasswordController.text.trim())) {
        userPasswordStr.value = isOnChange == false ? '' : kPasswordValidation;
        userPasswordStr2.value =
            isOnChange == false ? '' : kPasswordValidation2;
      } else if (newPasswordController.text.length < 8) {
        userPasswordStr.value =
            isOnChange == false ? '' : kPasswordMinValidation;
        userPasswordStr2.value =
            isOnChange == false ? '' : kPasswordValidation2;
      } else {
        userPasswordStr.value = '';
        userPasswordStr2.value = '';
        isValidPassword.value = true;
      }
      if (isValidOldPassword.value &&
          isValidPassword.value &&
          newPasswordController.text.trim() ==
              confirmPasswordController.text.trim()) {
        isButtonEnable.value = true;
      }
    } else {
      userPasswordStr.value =
          isOnChange == false ? '' : kNewPasswordRequiredValidation;
      userPasswordStr2.value = '';
    }
    return isValidPassword.value;
  }

  bool confirmPasswordValidation({bool isOnChange = true}) {
    isValidConfirmPass.value = false;
    if (confirmPasswordController.text.trim().isNotEmpty) {
      if (confirmPasswordController.text.trim() !=
          newPasswordController.text.trim()) {
        userConfirmPasswordStr.value =
            isOnChange == false ? '' : kConfirmPasswordValidation;
      } else {
        userConfirmPasswordStr.value = '';
        isValidConfirmPass.value = true;
      }
      if (isValidOldPassword.value &&
          isValidPassword.value &&
          newPasswordController.text.trim() ==
              confirmPasswordController.text.trim()) {
        isButtonEnable.value = true;
      }
    } else {
      userConfirmPasswordStr.value =
          isOnChange == false ? '' : kConfirmPasswordRequiredValidation;
    }
    return isValidConfirmPass.value;
  }

  /// check validations
  void checkValidationAndNavigate() {
    if (isButtonEnable.value) {
      changePasswordApiCall();
    } else if (newPasswordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty ||
        oldPasswordController.text.trim().isEmpty) {
      oldPasswordValidation();
      passwordValidation();
      confirmPasswordValidation();
    } else {
      if (!isValidOldPassword.value) {
        validateUserInput(fieldNumber: 1);
      } else if (!isValidPassword.value) {
        validateUserInput(fieldNumber: 2);
      } else if (!isValidConfirmPass.value) {
        validateUserInput(fieldNumber: 3);
      }
    }
  }

  Future<void> changePasswordApiCall() async {
    try {
      var requestModel = ChangePasswordRequestModel(
        bizId: int.parse(bizId),
        userId:int.parse(userId),
        newPassword: newPasswordController.text.trim(),
        oldPassword: oldPasswordController.text.trim(),
      );
      var response = await Get.find<SettingRepository>()
          .changePasswordApiCall(requestModel: requestModel);

      if (response != null) {
        if (response.statusCode == 100) {
          Get.back();
        } else {
          Get.find<AlertMessageUtils>().showErrorSnackBar(response.msg ?? '');
        }
      }
    } catch (e) {
      LoggerUtils.logException('changePasswordApiCall', e);
    }
  }
}
