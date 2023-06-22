import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/image_constants.dart';
import 'package:bms/app/screens/bottom_navigation/base/controller/bottom_nav_base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BottomNavBaseScreen extends GetView<BottomNavBaseController> {
  BottomNavBaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(() {
        return customBottomBarContainer();
      }),
      body: Obx(() {
        return controller.pages[controller.tabIndex.value];
      }),
    );
  }

  Widget customBottomBarContainer() {
    return Container(
      color: kColorPrimary,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              controller.changeTabIndex(0);
            },
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: controller.tabIndex.value == 0
                      ? SvgPicture.asset(kIconCustomerTabOn)
                      : SvgPicture.asset(kIconCustomerTabOff),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: controller.tabIndex.value == 0
                      ? SvgPicture.asset(kIconUnderLine)
                      : SvgPicture.asset(
                          kIconUnderLine,
                          color: kColorPrimary,
                        ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.changeTabIndex(1);
            },
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: controller.tabIndex.value == 1
                      ? SvgPicture.asset(kIconProductServiceTabOn)
                      : SvgPicture.asset(kIconProductServiceTabOff),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: controller.tabIndex.value == 1
                      ? SvgPicture.asset(kIconUnderLine)
                      : SvgPicture.asset(
                          kIconUnderLine,
                          color: kColorPrimary,
                        ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.changeTabIndex(2);
            },
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: controller.tabIndex.value == 2
                      ? SvgPicture.asset(kIconInvoiceTabOn)
                      : SvgPicture.asset(kIconInvoiceTabOff),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: controller.tabIndex.value == 2
                      ? SvgPicture.asset(kIconUnderLine)
                      : SvgPicture.asset(
                          kIconUnderLine,
                          color: kColorPrimary,
                        ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.changeTabIndex(3);
            },
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: controller.tabIndex.value == 3
                      ? SvgPicture.asset(kIconSettingTabOn)
                      : SvgPicture.asset(kIconSettingTabOff),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: controller.tabIndex.value == 3
                      ? SvgPicture.asset(kIconUnderLine)
                      : SvgPicture.asset(
                          kIconUnderLine,
                          color: kColorPrimary,
                        ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
