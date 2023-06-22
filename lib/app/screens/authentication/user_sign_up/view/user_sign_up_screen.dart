import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/image_constants.dart';
import 'package:bms/app/screens/authentication/user_sign_up/controller/user_sign_up_controller.dart';
import 'package:bms/app/utils/text_styles.dart';
import 'package:bms/app/widgets/appBar/app_bar_with_back_button.dart';
import 'package:bms/app/widgets/buttons/primary_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class UserSignUpScreen extends GetView<UserSignUpController> {
  UserSignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: kColorWhite,
        // resizeToAvoidBottomInset: false,
        appBar: AppBarWithBackButton(
            title: kLabelUserDetails, isShowLeadingIcon: false),
        body: SingleChildScrollView(
          child: SizedBox(
            width: Get.width,
            height: Get.height *0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// signup graphics
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 26, right: 26),
                  child: Center(
                    child: SvgPicture.asset(kImgSignUpImage),
                  ),
                ),

                userNameTextField(),
                userContactNumberTextField(),
                userEmailTextField(),
                passwordTextField(),
                confirmPasswordTextField(),

                const Spacer(),

                Padding(
                  padding: const EdgeInsets.only(top: 23),
                  child: PrimaryButtonWidget(
                      onPressed: () {

                        // if (controller.isButtonEnable.value) {
                        controller.checkRegexValidation();
                        // }
                        FocusScope.of(context).unfocus();
                      },
                      color: kColorPrimary,
                      buttonTitle: kLabelSendOtp),
                ),

                ///  already account and login text
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 22, bottom: 22),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: kLabelAlreadyHaveAnAccount,
                            style: TextStyles.kTextH14PrimaryBold400,
                          ),
                          TextSpan(
                              text: ' $kLabelLogin',
                              style: TextStyles.kTextH14PrimaryBold500,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => {
                                      FocusScope.of(context).unfocus(),
                                      controller.navigateToLoginScreen()
                                    }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget userNameTextField() {
    return Focus(
      onFocusChange: (hasFocus) {
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 1);
        // if (controller.userNameController.text.trim().isNotEmpty) {
          controller.validateUserInput(fieldNumber: 1, isOnChange: false);
        // }
      },
      child: Obx(() {
        return Container(
          margin:  controller.textFieldsMargin,
          // margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: controller.textFieldsHeight.value,
                child: TextFormField(
                  maxLength: 25,
                  controller: controller.userNameController,
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
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: '$kLabelUserName *',
                    alignLabelWithHint: true,
                    contentPadding: const EdgeInsets.only(
                        left: 28.0),
                    // contentPadding: const EdgeInsets.only(
                    //     left: 28.0, right: 46.0, bottom: 19, top: 20),
                    // contentPadding: EdgeInsets.only(left: 28.0, right: 20.0),
                    counterText: '',
                    labelStyle: controller.isFocusOnUserNameField.value ||
                            controller.userNameController.text.isNotEmpty
                        ? TextStyles.kTextH14DarkGreyBold400
                        : TextStyles.kTextH14GreyBold400,
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: kColorDarkGrey3535, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: kColorLightGrey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    hintStyle: TextStyles.kTextH14GreyBold600,
                    hintText: '$kLabelUserName *',
                    focusColor: kColorPrimary,
                  ),
                ),
              ),
              Obx(() {
                return Visibility(
                  visible: controller.userNameController.text.isNotEmpty ||
                      controller.isValidName.value == false,
                  child: controller.userNameStr.value == ''
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(left: 10, top: 2),
                          child: Text(controller.userNameStr.value,
                              style: TextStyles.kTextH12Red)),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget userEmailTextField() {
    return Focus(
      onFocusChange: (hasFocus) {
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 2);
        controller.validateUserInput(fieldNumber: 3, isOnChange: false);
      },
      child: Obx(() {
        return Container(
          margin:
          controller.textFieldsMargin,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: controller.textFieldsHeight.value,
                child: TextFormField(
                  maxLength: 50,
                  controller: controller.emailIdController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  // validator: (text) {
                  //   return TwoWaayFormValidation().validate(widget.fieldType, text);
                  // },
                  onChanged: (String value) {
                    controller.validateUserInput(fieldNumber: 3);
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: TextStyles.kTextH14DarkGreyBold400,
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: '$kLabelEmail *',
                    alignLabelWithHint: true,
                    contentPadding: const EdgeInsets.only(
                        left: 28.0),
                    // contentPadding: const EdgeInsets.only(
                    //     left: 28.0, right: 46.0, bottom: 19, top: 20),
                    // contentPadding: EdgeInsets.only(left: 28.0, right: 20.0),
                    counterText: '',
                    labelStyle: controller.isFocusOnEmailIdField.value ||
                            controller.emailIdController.text.isNotEmpty
                        ? TextStyles.kTextH14DarkGreyBold400
                        : TextStyles.kTextH14GreyBold400,
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: kColorDarkGrey3535, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: kColorLightGrey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    hintStyle: TextStyles.kTextH14GreyBold600,
                    hintText: kLabelEmail,
                    focusColor: kColorPrimary,
                  ),
                ),
              ),
              Obx(() {
                return Visibility(
                  visible: controller.emailIdController.text.isNotEmpty ||
                      controller.isValidEmailId.value == false,
                  child: controller.userEmailStr.value == ''
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(left: 10, top: 2),
                          child: Text(controller.userEmailStr.value,
                              style: TextStyles.kTextH12Red)),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget userContactNumberTextField() {
    return Focus(
      onFocusChange: (hasFocus) {
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 3);
        controller.validateUserInput(fieldNumber: 2, isOnChange: false);
      },
      child: Obx(() {
        return Container(
          margin:controller.textFieldsMargin,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: controller.textFieldsHeight.value,
                child: TextFormField(
                  maxLength: 10,
                  controller: controller.contactNumberController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  // validator: (text) {
                  //   return TwoWaayFormValidation().validate(widget.fieldType, text);
                  // },
                  onChanged: (String value) {
                    controller.validateUserInput(fieldNumber: 2);
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
                    labelText: '$kLabelContactNo *',
                    alignLabelWithHint: true,
                    contentPadding: const EdgeInsets.only(
                        left: 28.0),
                    // contentPadding: const EdgeInsets.only(
                    //     left: 28.0, right: 46.0, bottom: 19, top: 20),
                    counterText: '',
                    labelStyle: controller.isFocusOnContactNumberField.value ||
                            controller.contactNumberController.text.isNotEmpty
                        ? TextStyles.kTextH14DarkGreyBold400
                        : TextStyles.kTextH14GreyBold400,
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: kColorDarkGrey3535, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: kColorLightGrey, width: 1.0),
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
                  visible: controller.contactNumberController.text.isNotEmpty ||
                      controller.isValidPhoneNumber.value == false,
                  child: controller.userMobileStr.value == ''
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(left: 10, top: 2),
                          child: Text(controller.userMobileStr.value,
                              style: TextStyles.kTextH12Red)),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget passwordTextField() {
    return Focus(
      onFocusChange: (hasFocus) {
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 4);
        controller.validateUserInput(fieldNumber: 4, isOnChange: false);
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
                      controller.validateUserInput(fieldNumber: 4);
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
                      contentPadding: const EdgeInsets.only(
                          left: 28.0),
                      // contentPadding: const EdgeInsets.only(
                      //     left: 28.0, right: 46.0, bottom: 19, top: 20),
                      counterText: '',
                      labelStyle: controller.isFocusOnPasswordField.value ||
                              controller.passwordController.text.isNotEmpty
                          ? TextStyles.kTextH14DarkGreyBold400
                          : TextStyles.kTextH14GreyBold400,
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: kColorDarkGrey3535, width: 1.0),
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
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 5);
        controller.validateUserInput(fieldNumber: 5,isOnChange: false);
      },
      child: Obx(() {
        return Container(
          margin:controller.textFieldsMargin,
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
                    controller.validateUserInput(fieldNumber: 5);
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
                              padding: const EdgeInsets.only(top: 12, bottom: 12),
                              child: SvgPicture.asset(kIconsPassWordOff),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 12, bottom: 12),
                              child: SvgPicture.asset(kIconsPassWordOn),
                            ),
                      onTap: () {
                        controller.updateConfirmPasswordVisibilityStatus();
                      },
                    ),
                    labelText: '$kLabelConfirmPassword *',
                    alignLabelWithHint: true,
                    contentPadding: const EdgeInsets.only(
                        left: 28.0),
                    // contentPadding: const EdgeInsets.only(
                    //     left: 28.0, right: 46.0, bottom: 19, top: 20),
                    counterText: '',
                    labelStyle: controller.isFocusOnConfirmPasswordField.value ||
                            controller.confirmPasswordController.text.isNotEmpty
                        ? TextStyles.kTextH14DarkGreyBold400
                        : TextStyles.kTextH14GreyBold400,
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: kColorDarkGrey3535, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: kColorLightGrey, width: 1.0),
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
