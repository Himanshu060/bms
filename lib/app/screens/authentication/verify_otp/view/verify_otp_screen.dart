import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/image_constants.dart';
import 'package:bms/app/screens/authentication/verify_otp/controller/verify_otp_controller.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:bms/app/utils/text_styles.dart';
import 'package:bms/app/widgets/appBar/app_bar_with_back_button.dart';
import 'package:bms/app/widgets/buttons/primary_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyOtpScreen extends GetView<VerifyOtpController> {
  VerifyOtpScreen({Key? key}) : super(key: key) {
    final intentData = Get.arguments;
    controller.setIntentData(intentData: intentData);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBarWithBackButton(
              title: kLabelOtpVerification, isShowLeadingIcon: true),
          body: SingleChildScrollView(
            child: SizedBox(
              height: Get.height * 0.88,
              width: Get.width,
              child: Column(
                children: [
                  /// verify otp graphics
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 26, right: 26),
                    child: Center(
                      child: SvgPicture.asset(kImgLogin),
                    ),
                  ),

                  /// phone number id
                  Obx(() {
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 44, bottom: 14, right: 70, left: 70),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: kLabelVerificationHasBeenSentTo,
                              style: TextStyles.kTextH14MainGreyBold400,
                            ),
                            TextSpan(
                              text: '+91 ${controller.userPhoneNumber.value}',
                              style: TextStyles.kTextH14PrimaryBold,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  /// change phone address
                  const Center(
                    child: Text(kLabelChangePhoneNumber,
                        style: TextStyles.kTextH18PrimaryBold600),
                  ),

                  /// otp text field container
                  Container(
                    margin: EdgeInsets.only(
                      left: Get.width * 0.06,
                      right: Get.width * 0.06,
                      top: 30.0,
                    ),
                    child: PinCodeTextField(
                      // validator: validateVerificationCode,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      appContext: context,
                      length: 6,
                      pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 60,
                          fieldWidth: Get.width * 0.11,
                          activeFillColor: kColorWhite,
                          activeColor: kColorPrimary,
                          inactiveColor: kColorLightGrey,
                          inactiveFillColor: kColorLightGrey,
                          selectedColor: kColorLightGrey,
                          selectedFillColor: kColorLightGrey),
                      pastedTextStyle: TextStyles.kTextH14MainGreyBold400,
                      textStyle: TextStyles.kTextH14MainGreyBold400,
                      enableActiveFill: true,
                      keyboardType: TextInputType.number,
                      onCompleted: (v) {
                        LoggerUtils.logException('', 'Completed');
                        controller.isButtonEnable.value = true;
                      },
                      obscureText: false,
                      onChanged: (value) {
                        LoggerUtils.logException('', value);
                        controller.userInputOtp.value = value;
                        // controller.validateUserInput();
                      },
                    ),
                  ),

                  /// resent otp button
                  Obx(() {
                    return Visibility(
                      visible: controller.isResendOtpVisible.value,
                      child: InkWell(
                        onTap: () {
                          // controller.onResendOtpClicked();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text.rich(
                                  TextSpan(
                                      text: kLabelDidntReceivedMessage,
                                      style: TextStyles.kTextH14PrimaryBold400,
                                      children: <InlineSpan>[
                                        TextSpan(
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              controller.isButtonEnable.value =
                                                  false;
                                              controller.resetTimer();
                                              controller
                                                  .sendOtpForVerification();
                                              controller.startTimer();
                                            },
                                          text: ' $kLabelResend',
                                          style: controller
                                                  .isResendButtonEnable.value
                                              ? TextStyles
                                                  .kTextH14PrimaryBold500
                                              : TextStyles
                                                  .kTextH14Grey8DShade500,
                                        ),
                                      ]),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Text(controller.returnTimerValue()),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  const Spacer(),

                  /// submit otp button
                  PrimaryButtonWidget(
                      onPressed: () {
                        if (controller.isButtonEnable.value) {
                          controller.onVerifyOtpClicked();
                        } // controller.navigateToSignUpScreen();
                      },
                      color: kColorPrimary,
                      buttonTitle: kLabelSubmit),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
