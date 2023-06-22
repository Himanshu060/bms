import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/image_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/change_password/controller/change_password_controller.dart';
import 'package:bms/app/utils/text_styles.dart';
import 'package:bms/app/widgets/appBar/app_bar_with_back_button.dart';
import 'package:bms/app/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends GetView<ChangePasswordController> {
  ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBarWithBackButton(
            title: kChangePassword, isShowLeadingIcon: true),
        body: Column(
          children: [
            oldPasswordTextField(),
            passwordTextField(),
            confirmPasswordTextField(),
            SizedBox(height: 20),
            PrimaryButtonWidget(
                onPressed: () {
                  controller.checkValidationAndNavigate();
                },
                color: kColorPrimary,
                buttonTitle: kChangePassword),
          ],
        ),
      ),
    );
  }

  Widget oldPasswordTextField() {
    return Focus(
      onFocusChange: (hasFocus) {
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 3);
        controller.validateUserInput(fieldNumber: 1, isOnChange: false);
      },
      child: Obx(
        () {
          return Container(
            margin: controller.textFieldsMargin,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: controller.textFieldsHeight.value,
                  child: TextFormField(
                    maxLength: 20,
                    controller: controller.oldPasswordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // validator: (text) {
                    //   return TwoWaayFormValidation().validate(widget.fieldType, text);
                    // },
                    onChanged: (String value) {
                      controller.validateUserInput(fieldNumber: 1);
                    },
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: TextStyles.kTextH14DarkGreyBold400,
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: controller.isOldPasswordVisible.value,
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                        child: controller.isOldPasswordVisible.value
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: 12, bottom: 12),
                                child: SvgPicture.asset(kIconsPassWordOff),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.only(top: 12, bottom: 12),
                                child: SvgPicture.asset(kIconsPassWordOn),
                              ),
                        onTap: () {
                          controller.updateOldPasswordVisibilityStatus();
                        },
                      ),
                      labelText: '$kLabelOldPassword *',
                      alignLabelWithHint: true,
                      contentPadding: const EdgeInsets.only(left: 28.0),
                      // contentPadding: const EdgeInsets.only(
                      //     left: 28.0, right: 46.0, bottom: 19, top: 20),
                      counterText: '',
                      labelStyle: controller.isFocusOnOldPasswordField.value ||
                              controller.oldPasswordController.text.isNotEmpty
                          ? TextStyles.kTextH14DarkGreyBold400
                          : TextStyles.kTextH14GreyBold400,
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: kColorDarkGrey3535, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: kColorLightGrey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      hintStyle: TextStyles.kTextH14GreyBold600,
                      hintText: kLabelOldPassword,
                      focusColor: kColorPrimary,
                    ),
                  ),
                ),
                Obx(
                  () {
                    return Visibility(
                      visible:
                          controller.oldPasswordController.text.isNotEmpty ||
                              controller.isValidOldPassword.value == false,
                      child: controller.oldPasswordStr.value == ''
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(left: 10, top: 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.oldPasswordStr.value,
                                    style: TextStyles.kTextH12Red,
                                  ),
                                  Visibility(
                                    visible:
                                        controller.oldPasswordStr2.value != '',
                                    child: Text(
                                      controller.oldPasswordStr2.value,
                                      style: TextStyles.kTextH12Red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget passwordTextField() {
    return Focus(
      onFocusChange: (hasFocus) {
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 1);
        controller.validateUserInput(fieldNumber: 2, isOnChange: false);
      },
      child: Obx(
        () {
          return Container(
            margin: controller.textFieldsMargin,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: controller.textFieldsHeight.value,
                  child: TextFormField(
                    maxLength: 20,
                    controller: controller.newPasswordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // validator: (text) {
                    //   return TwoWaayFormValidation().validate(widget.fieldType, text);
                    // },
                    onChanged: (String value) {
                      controller.validateUserInput(fieldNumber: 2);
                    },
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: TextStyles.kTextH14DarkGreyBold400,
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: controller.isPasswordVisible.value,
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                        child: controller.isPasswordVisible.value
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: 12, bottom: 12),
                                child: SvgPicture.asset(kIconsPassWordOff),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.only(top: 12, bottom: 12),
                                child: SvgPicture.asset(kIconsPassWordOn),
                              ),
                        onTap: () {
                          controller.updatePasswordVisibilityStatus();
                        },
                      ),
                      labelText: '$kLabelNewPassword *',
                      alignLabelWithHint: true,
                      contentPadding: const EdgeInsets.only(left: 28.0),
                      // contentPadding: const EdgeInsets.only(
                      //     left: 28.0, right: 46.0, bottom: 19, top: 20),
                      counterText: '',
                      labelStyle: controller.isFocusOnPasswordField.value ||
                              controller.newPasswordController.text.isNotEmpty
                          ? TextStyles.kTextH14DarkGreyBold400
                          : TextStyles.kTextH14GreyBold400,
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: kColorDarkGrey3535, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: kColorLightGrey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      hintStyle: TextStyles.kTextH14GreyBold600,
                      hintText: kLabelNewPassword,
                      focusColor: kColorPrimary,
                    ),
                  ),
                ),
                Obx(
                  () {
                    return Visibility(
                      visible:
                          controller.newPasswordController.text.isNotEmpty ||
                              controller.isValidPassword.value == false,
                      child: controller.userPasswordStr.value == ''
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(left: 10, top: 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.userPasswordStr.value,
                                    style: TextStyles.kTextH12Red,
                                  ),
                                  Visibility(
                                    visible:
                                        controller.userPasswordStr2.value != '',
                                    child: Text(
                                      controller.userPasswordStr2.value,
                                      style: TextStyles.kTextH12Red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget confirmPasswordTextField() {
    return Focus(
      onFocusChange: (hasFocus) {
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 2);
        controller.validateUserInput(fieldNumber: 3, isOnChange: false);
      },
      child: Obx(() {
        return Container(
          margin: controller.textFieldsMargin,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: controller.textFieldsHeight.value,
                child: TextFormField(
                  maxLength: 20,
                  controller: controller.confirmPasswordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (String value) {
                    controller.validateUserInput(fieldNumber: 3);
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: TextStyles.kTextH14DarkGreyBold400,
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: controller.isConfirmPasswordVisible.value,
                  decoration: InputDecoration(
                    suffixIcon: InkWell(
                      child: controller.isConfirmPasswordVisible.value
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(top: 12, bottom: 12),
                              child: SvgPicture.asset(kIconsPassWordOff),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.only(top: 12, bottom: 12),
                              child: SvgPicture.asset(kIconsPassWordOn),
                            ),
                      onTap: () {
                        controller.updateConfirmPasswordVisibilityStatus();
                      },
                    ),
                    labelText: '$kLabelConfirmPassword *',
                    alignLabelWithHint: true,
                    contentPadding: const EdgeInsets.only(left: 28.0),
                    // contentPadding: const EdgeInsets.only(
                    //     left: 28.0, right: 46.0, bottom: 19, top: 20),
                    counterText: '',
                    labelStyle: controller
                                .isFocusOnConfirmPasswordField.value ||
                            controller.confirmPasswordController.text.isNotEmpty
                        ? TextStyles.kTextH14DarkGreyBold400
                        : TextStyles.kTextH14GreyBold400,
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kColorDarkGrey3535, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kColorLightGrey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    hintStyle: TextStyles.kTextH14GreyBold600,
                    hintText: kLabelConfirmPassword,
                    focusColor: kColorPrimary,
                  ),
                ),
              ),
              Obx(() {
                return Visibility(
                  visible:
                      controller.confirmPasswordController.text.isNotEmpty ||
                          controller.isValidConfirmPass.value == false,
                  child: controller.userConfirmPasswordStr.value == ''
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(left: 10, top: 2),
                          child: Text(controller.userConfirmPasswordStr.value,
                              style: TextStyles.kTextH12Red)),
                );
              }),
            ],
          ),
        );
      }),
    );
  }
}
