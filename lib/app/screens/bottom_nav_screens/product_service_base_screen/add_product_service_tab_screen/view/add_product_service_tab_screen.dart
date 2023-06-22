import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/add_product_service_tab_screen/controller/add_product_service_tab_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/products/add_product/view/add_product_screen.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/services/add_service/view/add_service_screen.dart';
import 'package:bms/app/utils/text_styles.dart';
import 'package:bms/app/widgets/appBar/app_bar_with_back_button.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductServiceTabScreen
    extends GetView<AddProductServiceTabController> {
  AddProductServiceTabScreen({Key? key}) : super(key: key){
    final intentData = Get.arguments;
    controller.setIntentData(intentData: intentData);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarWithBackButton(
          title: kLabelAddItem,
          isShowLeadingIcon: true,
        ),
        body: Column(
          children: [
            productServiceTabBar(),
            Obx(() {
              return Expanded(
                child: Container(
                  child: controller.currentTabValue.value == 1
                      ? AddProductScreen()
                      : AddServiceScreen(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget productServiceTabBar() {
    return Obx(() {
      return Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 14),
        child: CustomSlidingSegmentedControl<int>(
          initialValue: controller.currentTabValue.value,
          isStretch: true,
          children: {
            1: Text(
              kLabelProduct,
              style: controller.currentTabValue.value == 1
                  ? TextStyles.kTextH16White600
                  : TextStyles.kTextH16Grey73500,
            ),
            2: Text(
              kLabelService,
              style: controller.currentTabValue.value == 2
                  ? TextStyles.kTextH16White600
                  : TextStyles.kTextH16Grey73500,
            ),
          },
          height: 42,
          padding: 0,
          decoration: BoxDecoration(
            color: kColorWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: kColorPrimary),
          ),
          thumbDecoration: BoxDecoration(
            color: kColorPrimary,
            borderRadius: BorderRadius.circular(8),
          ),
          onValueChanged: (v) {
            controller.currentTabValue.value = v;
          },
        ),
      );
    });
  }
}
