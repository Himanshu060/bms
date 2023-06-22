import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/image_constants.dart';
import 'package:bms/app/screens/authentication/login/controller/login_controller.dart';
import 'package:bms/app/utils/text_styles.dart';
import 'package:bms/app/widgets/buttons/primary_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LoginScreen extends GetView<LoginController> {
  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: SizedBox(
            width: Get.width,
            height: Get.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// login graphics
                Padding(
                  padding: const EdgeInsets.only(top: 66, left: 26, right: 26),
                  child: Center(
                    child: SvgPicture.asset(kImgLogin),
                  ),
                ),

                /// Login text label
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 21),
                  child: Text(
                    kLabelLogin,
                    style: TextStyles.kTextH30PrimaryBold600,
                  ),
                ),

                /// Email ID input field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Focus(
                      onFocusChange: (hasFocus) {
                        controller.changeFocus(
                            hasFocus: hasFocus, isCheckForEmailField: true);
                        // if (controller.userEmailOrMobileNumberController.text
                        //     .trim()
                        //     .isNotEmpty) {
                          controller.checkInputIsDigitOrMail(
                              fieldNumber: 1, isOnChangeCall: false);
                          // controller.validateUserInput(fieldNumber: 1);
                        // }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 35.0),
                        child: Obx(() {
                          return TextFormField(
                            controller:
                                controller.userEmailOrMobileNumberController,
                            maxLength: 100,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            // validator: (text) {
                            //   return TwoWaayFormValidation().validate(widget.fieldType, text);
                            // },
                            onChanged: (String inputEntry) {
                              // controller.userEmailController.text = inputEntry;
                              // controller.validateUserInput(fieldNumber: 1);
                              controller.checkInputIsDigitOrMail(
                                  fieldNumber: 1);
                            },
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            style: TextStyles.kTextH14DarkGreyBold400,
                            enableSuggestions: false,
                            autocorrect: false,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: kLabelEmailOrMobileNo,
                              contentPadding: const EdgeInsets.only(
                                  left: 28.0, right: 46.0, bottom: 19, top: 20),
                              counterText: '',
                              labelStyle: controller.isFocusOnMailField.value ||
                                      controller
                                          .userEmailOrMobileNumberController
                                          .text
                                          .isNotEmpty
                                  ? TextStyles.kTextH14DarkGreyBold400
                                  : TextStyles.kTextH14GreyBold400,
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: kColorDarkGrey3535, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: kColorLightGrey, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              hintStyle: TextStyles.kTextH14GreyBold600,
                              hintText: kLabelEmailOrMobileNo,
                              focusColor: kColorPrimary,
                            ),
                          );
                        }),
                      ),
                    ),
                    Obx(
                      () {
                        return Visibility(
                          visible: controller.userEmailOrMobileNumberController
                                  .text.isNotEmpty ||
                              controller.isValidPhoneOrEmail.value == false,
                          child: controller.userPhoneOrEmailStr.value == ''
                              ? Container()
                              : Padding(
                                  padding:
                                      const EdgeInsets.only(left: 22, top: 2),
                                  child: Text(
                                      controller.userPhoneOrEmailStr.value,
                                      style: TextStyles.kTextH12Red)),
                        );
                      },
                    ),
                  ],
                ),

                /// password input field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Focus(
                      onFocusChange: (hasFocus) {
                        controller.changeFocus(
                            hasFocus: hasFocus, isCheckForEmailField: false);
                        // controller.validateUserInput(fieldNumber: 3);
                        // if (controller.passwordController.text
                        //     .trim()
                        //     .isNotEmpty) {
                          controller.checkInputIsDigitOrMail(
                              fieldNumber: 2, isOnChangeCall: false);
                        // }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                          top: 20.0,
                        ),
                        child: Obx(() {
                          return TextFormField(
                            maxLength: 100,
                            controller: controller.passwordController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: (String inputEntry) {
                              // controller.validateUserInput(fieldNumber: 3);
                              controller.checkInputIsDigitOrMail(
                                  fieldNumber: 2);
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
                                        padding: const EdgeInsets.only(
                                            top: 12, bottom: 12),
                                        child:
                                            SvgPicture.asset(kIconsPassWordOff),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            top: 12, bottom: 12),
                                        child:
                                            SvgPicture.asset(kIconsPassWordOn),
                                      ),
                                onTap: () {
                                  controller.updatePasswordVisibilityStatus();
                                },
                              ),
                              labelText: kLabelPassword,
                              contentPadding: const EdgeInsets.only(
                                  left: 28.0, right: 46.0, bottom: 19, top: 20),
                              counterText: '',
                              labelStyle:
                                  controller.isFocusOnPasswordField.value ||
                                          controller.passwordController.text
                                              .isNotEmpty
                                      ? TextStyles.kTextH14DarkGreyBold400
                                      : TextStyles.kTextH14GreyBold400,
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: kColorDarkGrey3535, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: kColorLightGrey, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              hintStyle: TextStyles.kTextH14GreyBold600,
                              hintText: kLabelPassword,
                              focusColor: kColorPrimary,
                            ),
                          );
                        }),
                      ),
                    ),
                    Obx(
                      () {
                        return Visibility(
                          visible:
                              controller.passwordController.text.isNotEmpty ||
                                  controller.isValidPassword.value == false,
                          child: controller.userPasswordStr.value == ''
                              ? Container()
                              : Padding(
                                  padding: EdgeInsets.only(
                                      left: 22, top: 2, right: Get.width * 0.1),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.userPasswordStr.value,
                                        style: TextStyles.kTextH12Red,
                                      ),
                                      Text(
                                        controller.userPasswordStr2.value,
                                        style: TextStyles.kTextH12Red,
                                      ),
                                    ],
                                  ),
                                ),
                        );
                      },
                    ),
                  ],
                ),

                /// forgot password text
                GestureDetector(
                  onTap: () {
                    controller.navigateToForgotPasswordScreen();
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(top: 10, right: 20),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(kLabelForgotPassword,
                          style: TextStyles.kTextH14PrimaryBold400),
                    ),
                  ),
                ),

                const Spacer(),

                /// login button
                PrimaryButtonWidget(
                  onPressed: () {
                    FocusScope.of(context).unfocus();

                    controller.checkRegexValidation();
                  },
                  color: kColorPrimary,
                  buttonTitle: kLabelLogin.toUpperCase(),
                ),

                /// register account text
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 22, bottom: 22),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: kLabelDontHaveAnAccount,
                            style: TextStyles.kTextH14PrimaryBold400,
                          ),
                          TextSpan(
                              text: ' $kLabelRegister',
                              style: TextStyles.kTextH14PrimaryBold500,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => {
                                      FocusScope.of(context).unfocus(),
                                      controller.navigateToUserSignUpScreen()
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
}
