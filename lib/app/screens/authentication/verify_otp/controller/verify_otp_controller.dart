import 'dart:async';
import 'dart:convert';

import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/globa_variables.dart';
import 'package:bms/app/common/local_storage_constants.dart';
import 'package:bms/app/common/model/firebase_auth_model.dart';
import 'package:bms/app/common/route_constants.dart';
import 'package:bms/app/screens/authentication/user_sign_up/model/request/user_sign_up_request_model.dart';
import 'package:bms/app/screens/authentication/user_sign_up/model/response/user_sign_up_response_model.dart';
import 'package:bms/app/services/repository/authentication_repository.dart';
import 'package:bms/app/services/repository/registration_repository.dart';
import 'package:bms/app/utils/alert_message_utils.dart';
import 'package:bms/app/utils/decode_response_data/decode_response_data.dart';
import 'package:bms/app/utils/local_storage.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class VerifyOtpController extends GetxController {
  Rx<UserSignUpRequestModel> userSignUpRequestModel =
      UserSignUpRequestModel().obs;

  RxBool isButtonEnable = false.obs;

  RxString otpSendLimit = ''.obs;

  RxString userInputOtp = ''.obs;
  RxString userPhoneNumber = ''.obs;
  RxBool isResendOtpVisible = true.obs;
  RxBool isFromForgotPasswordScreen = false.obs;
  RxBool isResendButtonEnable = false.obs;

  Rx<UserSignUpResponseModel> userSignUpData = UserSignUpResponseModel().obs;

  // Step 2
  Timer? countdownTimer;
  int duration = 5;
  int durationGap = 1;
  Rx<Duration> myDuration = Duration().obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    Get.lazyPut(() => AuthenticationRepository(), fenix: true);
    Get.lazyPut(() => RegistrationRepository(), fenix: true);
    myDuration.value = Duration(minutes: duration);
    otpSendLimit.value = await Get.find<LocalStorage>()
        .getStringFromStorage(kStorageOtpSendLimit);
    startTimer();
  }

  // Step 3
  void startTimer() {
    isResendButtonEnable.value = false;
    countdownTimer =
        Timer.periodic(Duration(seconds: durationGap), (_) => setCountDown());
  }

  // Step 4
  void stopTimer() {
    countdownTimer!.cancel();
  }

  // Step 5
  void resetTimer() {
    myDuration.value = Duration(minutes: duration);
  }

  // Step 6
  void setCountDown() {
    const reduceSecondsBy = 1;

    final seconds = myDuration.value.inSeconds - reduceSecondsBy;
    if (seconds < 0) {
      countdownTimer!.cancel();
      stopTimer();
      isResendButtonEnable.value = true;
    } else {
      myDuration.value = Duration(seconds: seconds);
    }
  }

  /// set previous screen intent data
  void setIntentData({required dynamic intentData}) {
    try {
      userSignUpRequestModel.value = (intentData[0] as UserSignUpRequestModel);
      isFromForgotPasswordScreen.value = (intentData[1] as bool);
      userPhoneNumber.value = userSignUpRequestModel.value.mobileNo.toString();
      sendOtpForVerification();
    } catch (e) {
      LoggerUtils.logException('setIntentData', e);
    }
  }

  /// Send otp on user entered mobile number
  Future<void> sendOtpForVerification() async {
    if (otpSendLimit.value.isNotEmpty ||
        otpSendLimit.value != maxOtpSendCount.toString()) {
      FirebaseAuthenticationModel? firebaseAuthModel =
          await Get.find<AuthenticationRepository>()
              .sendOtpOnUserMobileFCM(phoneNumber: userPhoneNumber.value);
      // if user entered otp is verified then save user details to fire store
      if (firebaseAuthModel != null) {
        int count =
            otpSendLimit.value.isEmpty ? 1 : int.parse(otpSendLimit.value);
        count = count + 1;
        Get.find<LocalStorage>()
            .writeStringStorage(kStorageOtpSendLimit, count.toString());
        if (!isFromForgotPasswordScreen.value) {
          if (firebaseAuthModel.isOtpVerified) {
            // registerUserApi(idToken: firebaseAuthModel.idToken);
            // navigateToSignUpScreen();
          }
        }
      }
    } else {
      Get.find<AlertMessageUtils>().showErrorSnackBar(kYouReachMaxOtpSendLimit);
    }
  }

  /// onclick otp verification
  Future<void> onVerifyOtpClicked() async {
    Get.find<AlertMessageUtils>().showProgressDialog();
    var firebaseAuthModel = await Get.find<AuthenticationRepository>()
        .verifyUserReceivedOtpFCM(userInputOtp.value);
    isButtonEnable.value = false;
    // if user entered otp is verified then save user details to fire store
    if (firebaseAuthModel.isOtpVerified) {
      if (isFromForgotPasswordScreen.value) {
        Get.back(result: [true,firebaseAuthModel.idToken]);
      } else {
        registerUserApi(idToken: firebaseAuthModel.idToken);
      }
      // navigateToSignUpScreen();
    }
    // isButtonEnable.value = false;
  }

  Future<void> registerUserApi({required String idToken}) async {
    try {
      UserSignUpRequestModel requestModel = UserSignUpRequestModel(
        name: userSignUpRequestModel.value.name,
        mobileNo: userSignUpRequestModel.value.mobileNo,
        emailId: userSignUpRequestModel.value.emailId,
        password: userSignUpRequestModel.value.password,
        isMobileVerification: true,
        idToken: idToken,
      );

      var response = await Get.find<RegistrationRepository>()
          .userSignUpApi(requestModel: requestModel);

      if (response != null && response.statusCode == 100) {
        var res = decodeResponseData(responseData: response.data ?? '');
        if (res != null && res != '') {
          userSignUpData.value = userSignUpResponseModelFromJson(res);
          Get.find<LocalStorage>().writeStringStorage(
            kStorageUserId,
            userSignUpData.value.userId.toString(),
          );
          Get.find<LocalStorage>().writeStringStorage(
              kStorageToken, userSignUpData.value.token ?? '');
          navigateToSignUpScreen();
        } else {
          Get.find<AlertMessageUtils>().showErrorSnackBar(response.msg ?? '');
        }
      }
    } catch (e) {
      LoggerUtils.logException('registerUserApi', e);
    }
  }

  /// navigate to sign up screen
  void navigateToSignUpScreen() {
    Get.offNamedUntil(
      kRouteBusinessSignUpScreen,
      ModalRoute.withName(kRouteLoginScreen),
    );
  }

  String returnTimerValue() {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = strDigits(myDuration.value.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.value.inSeconds.remainder(60));
    return ' $minutes:$seconds';
  }
}
