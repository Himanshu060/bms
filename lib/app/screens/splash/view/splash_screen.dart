import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/screens/splash/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends GetView<SplashController> {
  SplashScreen({Key? key}) : super(key: key){
    var controller =
    Get.put<SplashController>(SplashController(), permanent: false);
    controller.navigateToNewScreen();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: kColorPrimary,
      ),
    );
  }
}
