import 'package:bms/app/common/model/firebase_auth_model.dart';
import 'package:bms/app/utils/alert_message_utils.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FirebaseAuthService {
    FirebaseAuth? _mFirebaseAuth;

  FirebaseAuthService() {
    _mFirebaseAuth = FirebaseAuth.instance;
  }

  static final FirebaseAuthenticationModel _mAuthModel =
      FirebaseAuthenticationModel();

  /// send otp to user mobile number
  Future<FirebaseAuthenticationModel> sendOtpToMobileNumber(
      {required String phoneNumber}) async {
    try {
      var countryCode = '+91';
      await _mFirebaseAuth?.verifyPhoneNumber(
        phoneNumber: '$countryCode$phoneNumber',
        timeout: const Duration(seconds: 120),
        verificationCompleted: (phoneAuthCredential) async {
          // UserCredential userCredential =
          //     await _mFirebaseAuth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          LoggerUtils.logException('verificationFailed', error);
        },
        codeSent: (String verificationId, forceResendingToken) {
          LoggerUtils.logException('codeSent', verificationId);
          _mAuthModel.otpVerificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );

      return _mAuthModel;
    } catch (e) {
      LoggerUtils.logException('sendOtpToMobileNumber', e);
      return _mAuthModel;
    }
  }

  /// Verify user otp if entered manually
  Future<FirebaseAuthenticationModel> verifyUserOtp(String otp) async {
    try {
      PhoneAuthCredential? phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: _mAuthModel.otpVerificationId, smsCode: otp);



      try {
        // 1. Verify Otp and create user account
        UserCredential? userCredential =
        await _mFirebaseAuth?.signInWithCredential(phoneAuthCredential);

        final idToken = await userCredential?.user?.getIdToken();
        _mAuthModel.idToken = idToken ?? '';
        LoggerUtils.logException('idToken',_mAuthModel.idToken);
      } catch (ex) {
        LoggerUtils.logException('verifyUserOtp ', ex);
      }


      Get.find<AlertMessageUtils>().hideProgressDialog();
      _mAuthModel.isOtpVerified = true;
      return _mAuthModel;
    } catch (ex) {
      Get.find<AlertMessageUtils>().hideProgressDialog();
      _mAuthModel.isOtpVerified = false;
      LoggerUtils.logException('otp failed', ex);
      // if (ex is FirebaseAuthException) {
      //   LoggerUtils.logException('verifyUserOtp', ex.message);
      //   if (ex.code == kFcmCodeInvalidVerificationCode ||
      //       ex.code == kFcmCodeInvalidVerificationId ||
      //       ex.code == kFcmCodeSessionExpired) {
      //     Get.toNamed(kRouteVerifyOtpSuccessScreen,
      //         arguments: [false, ex.code, otp]);
      //   }
      // }
      return _mAuthModel;
    }
  }
}
