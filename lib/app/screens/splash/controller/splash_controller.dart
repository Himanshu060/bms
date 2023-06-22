import 'package:bms/app/common/local_storage_constants.dart';
import 'package:bms/app/common/route_constants.dart';
import 'package:bms/app/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  RxBool isLoggedIn = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    Get.lazyPut(() => LocalStorage());
    isLoggedIn.value =
        await Get.find<LocalStorage>().getBoolFromStorage(kStorageIsLoggedIn) ??
            false;

    checkIsUserLoggedIn();
  }

  void checkIsUserLoggedIn() {
    navigateToNewScreen();
  }

  void navigateToNewScreen() {
    Future.delayed(
      const Duration(seconds: 3),
      () async {
        if (isLoggedIn.value == true) {
          /// navigate to bottom bar nav screen
          // Get.offNamed(kRouteAddCustomerScreen);
          // Get.offAllNamed(kRouteBottomNavBaseScreen);
          Get.offNamedUntil(kRouteBottomNavBaseScreen,
              ModalRoute.withName(kRouteSplashScreen));
        } else {
          Get.offNamed(kRouteLoginScreen);
        }
      },
    );
  }
}
