import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/image_constants.dart';
import 'package:bms/app/screens/authentication/forgot_password/controller/forgot_password_controller.dart';
import 'package:bms/app/utils/text_styles.dart';
import 'package:bms/app/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          body: Obx(() {
            return Column(
              children: controller.isOptVerifiedSuccessfully.value
                  ? resetPasswordView()
                  : forgotPasswordView(),
            );
          }),
        ),
      ),
    );
  }

  Widget customerContactNumberTextField() {
    return Focus(
      onFocusChange: (hasFocus) {
        // controller.changeFocus(hasFocus: hasFocus, fieldNumber: 2);
        controller.validateUserInput(fieldNumber: 1, isOnChange: false);
      },
      child: Obx(() {
        return Container(
          margin: const EdgeInsets.only(
              left: 20.0, right: 20.0, top: 20.0, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60,
                child: TextFormField(
                  enabled:
                      controller.isOptVerifiedSuccessfully.value ? false : true,
                  controller: controller.mobileNumberController,
                  maxLength: 10,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (String value) {
                    controller.validateUserInput(fieldNumber: 1);
                  },
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  textInputAction: TextInputAction.next,
                  style: TextStyles.kTextH14DarkGreyBold400,
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: kLabelContactNo,
                    contentPadding:
                        const EdgeInsets.only(left: 28.0, bottom: 20, top: 19),
                    isCollapsed: true,
                    counterText: '',
                    labelStyle: controller.isFocusOnCustomerNumberField.value ||
                            controller.mobileNumberController.text.isNotEmpty
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
                    disabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kColorLightGrey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    hintStyle: TextStyles.kTextH14GreyBold600,
                    hintText: kLabelContactNo,
                    focusColor: kColorPrimary,
                  ),
                ),
              ),
              Obx(() {
                return Visibility(
                  visible: controller.mobileNumberController.text.isNotEmpty ||
                      controller.isValidPhoneNumber.value == false,
                  child: controller.customerMobileStr.value == ''
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(left: 10, top: 2),
                          child: Text(controller.customerMobileStr.value,
                              style: TextStyles.kTextH12Red)),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  forgotPasswordView() {
    return <Widget>[
      /// verify otp graphics
      Padding(
        padding: const EdgeInsets.only(top: 20, left: 26, right: 26),
        child: Center(
          child: SvgPicture.asset(kImgLogin),
        ),
      ),
      customerContactNumberTextField(),
      PrimaryButtonWidget(
        onPressed: () {
          controller.checkValidationAndNavigate();
        },
        color: kColorPrimary,
        buttonTitle: kLabelSendOtp,
      ),
    ];
  }

  resetPasswordView() {
    return <Widget>[
      /// verify otp graphics
      Padding(
        padding: const EdgeInsets.only(top: 20, left: 26, right: 26),
        child: Center(
          child: SvgPicture.asset(kImgLogin),
        ),
      ),
      passwordTextField(),
      confirmPasswordTextField(),
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: PrimaryButtonWidget(
            onPressed: () {
              FocusScope.of(Get.overlayContext!).unfocus();
              controller.checkValidationAndNavigate(isForResetPassword: true);
            },
            color: kColorPrimary,
            buttonTitle: kLabelResetPassword),
      ),
    ];
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
                    controller: controller.passwordController,
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
                      labelText: '$kLabelPassword *',
                      alignLabelWithHint: true,
                      contentPadding: const EdgeInsets.only(left: 28.0),
                      // contentPadding: const EdgeInsets.only(
                      //     left: 28.0, right: 46.0, bottom: 19, top: 20),
                      counterText: '',
                      labelStyle: controller.isFocusOnPasswordField.value ||
                              controller.passwordController.text.isNotEmpty
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
                      hintText: kLabelPassword,
                      focusColor: kColorPrimary,
                    ),
                  ),
                ),
                Obx(
                  () {
                    return Visibility(
                      visible: controller.passwordController.text.isNotEmpty ||
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
