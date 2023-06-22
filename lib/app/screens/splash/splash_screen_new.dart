import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/local_storage_constants.dart';
import 'package:bms/app/common/route_constants.dart';
import 'package:bms/app/utils/local_storage.dart' as l;
import 'package:bms/app/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreenNew extends StatefulWidget {
  SplashScreenNew({Key? key}) : super(key: key);

  @override
  State<SplashScreenNew> createState() => _SplashScreenNewState();
}

class _SplashScreenNewState extends State<SplashScreenNew> {
  l.LocalStorage localStorage = Get.put(l.LocalStorage());

  @override
  void initState() {
    navigateToNewScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kColorPrimary,
    );
  }

  Future<void> navigateToNewScreen() async {
    bool? isLoggedIn =
        await localStorage.getBoolFromStorage(kStorageIsLoggedIn);
    Future.delayed(
      const Duration(seconds: 3),
      () async {
        if (isLoggedIn == true) {
          /// navigate to bottom bar nav screen
          // Get.offNamed(kRouteAddCustomerScreen);
          // Get.offAllNamed(kRouteBottomNavBaseScreen);
          Get.offNamedUntil(kRouteBottomNavBaseScreen,
              ModalRoute.withName(kRouteSplashScreen));
        } else {
          // Get.offNamed(kRouteInvoiceQuotationListingScreen);
          Get.offNamed(kRouteLoginScreen);
        }
      },
    );
  }
}
