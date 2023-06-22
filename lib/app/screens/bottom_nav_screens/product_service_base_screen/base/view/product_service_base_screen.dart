import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/image_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/base/controller/product_service_base_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/products/base/view/products_base_screen.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/services/base/view/services_base_screen.dart';
import 'package:bms/app/utils/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';

class ProductServiceBaseScreen extends GetView<ProductServiceBaseController> {
  ProductServiceBaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Obx(() {
            return Column(
              children: [
                itemTextAndPlusIcon(),
                searchItemsTextFieldAndFilter(),
                productServiceTabBar(),
                Obx(() {
                  return Expanded(
                    child: Container(
                      child: controller.currentTabValue.value == 1
                          ? ProductsBaseScreen()
                          : ServicesBaseScreen(),
                    ),
                  );
                }),
                // Container(
                //   child: Obx(
                //     () {
                //       return controller.currentTabValue.value == 1
                //           ? ProductServiceBaseScreen()
                //           : ServicesBaseScreen();
                //     },
                //   ),
                // ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget itemTextAndPlusIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            kLabelItems,
            style: TextStyles.kTextH18MainDarkGreyBold700,
          ),
          GestureDetector(
            onTap: () {
              controller.navigateToAddItemsScreen();
            },
            child: SvgPicture.asset(kIconPlus),
          ),
        ],
      ),
    );
  }

  Widget searchItemsTextFieldAndFilter() {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SizedBox(
                height: 46,
                child: TextFormField(
                  maxLength: 100,
                  controller: controller.searchItemsController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  // validator: (text) {
                  //   return TwoWaayFormValidation().validate(widget.fieldType, text);
                  // },
                  onChanged: (String inputEntry) {
                    // controller.passwordController.text = inputEntry;
                    if (inputEntry.trim().isNotEmpty) {
                      controller.searchItemValue.value = inputEntry;
                    } else {
                      controller.searchItemValue.value = '';
                    }
                    controller.currentTabValue.value == 1
                        ? controller.searchProductName()
                        : controller.searchServiceName();
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: TextStyles.kTextH14DarkGrey3535Bold600,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    suffixIcon: controller.searchItemValue.value.isEmpty
                        ? Text('')
                        : GestureDetector(
                            onTap: () {
                              controller.searchItemsController.text = '';
                              controller.searchItemValue.value = '';
                              controller.currentTabValue.value == 1
                                  ? controller.searchProductName()
                                  : controller.searchServiceName();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 12, right: 9, bottom: 9, top: 9),
                              child: Icon(
                                Icons.close,
                                color: kColorGrey96,
                                size: 16,
                              ),
                            ),
                          ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(
                          left: 4, top: 12.83, bottom: 13),
                      child: SvgPicture.asset(
                        kIconSearch,
                        height: 20,
                        width: 20,
                      ),
                    ),
                    contentPadding:
                        const EdgeInsets.only(left: 14.0, bottom: 0, top: 1),
                    counterText: '',
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kColorDarkGrey3535, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kColorLightGrey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    hintStyle: TextStyles.kTextH14GreyBold400,
                    hintText: kLabelSearchProductsService,
                    focusColor: kColorPrimary,
                  ),
                ),
              ),
            ),
          ),
          Obx(() {
            return GestureDetector(
              onTap: () {
                controller.isMoreTextVisible.value = true;
                openFilterBottomSheet();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: controller.isFilterApplied.value
                    ? SvgPicture.asset(kIconFilledFilterWithBox)
                    : SvgPicture.asset(kIconFilter),
              ),
            );
          })
        ],
      ),
    );
  }

  Widget productServiceTabBar() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.only(
            left: 20, right: 20, top: 10, bottom: 8), // b-20
        child: CustomSlidingSegmentedControl<int>(
          initialValue: controller.currentTabValue.value,
          isStretch: true,
          children: {
            1: Text(
              kLabelProducts,
              style: controller.currentTabValue.value == 1
                  ? TextStyles.kTextH16White500
                  : TextStyles.kTextH16Grey73500,
            ),
            2: Text(
              kLabelServices,
              style: controller.currentTabValue.value == 2
                  ? TextStyles.kTextH16White500
                  : TextStyles.kTextH16Grey73500,
            ),
          },
          height: 46,
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
            controller.searchItemsController.text = '';
            FocusScope.of(Get.overlayContext!).unfocus();
            controller.searchServiceName();
            controller.searchProductName();
            controller.clearFilter();
          },
        ),
      );
    });
  }

  void openFilterBottomSheet() {
    Get.bottomSheet(
      isDismissible: false,
      Obx(() {
        return Container(
          height: 400,
          color: kColorWhite,
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Align(
                      alignment: Alignment.topRight,
                      child: SvgPicture.asset(kIconClosePrimary)),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(kLabelSortBy,
                        style: TextStyles.kTextH16Primary600),
                    Wrap(
                      spacing: 8,
                      children: filterChips(),
                    ),
                    const Text(kLabelSortByCategory,
                        style: TextStyles.kTextH16Primary600),
                    Container(
                      height: 150,
                      margin: EdgeInsets.only(top: 10),
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 8,
                          children: categoryFilterChips(),
                        ),
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 50,
                          width: Get.width * 0.42,
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: kColorPrimary,
                              ),
                              color: kColorWhite,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(70))),
                          child: MaterialButton(
                            onPressed: () {
                              FocusScope.of(Get.overlayContext!).unfocus();
                              controller.clearFilter();
                            },
                            child: Center(
                                child: Text(
                              kLabelClear,
                              style: TextStyles.kTextH18PrimaryBold500,
                            )),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: Get.width * 0.42,
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: kColorPrimary,
                              ),
                              color: kColorPrimary,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(70))),
                          child: MaterialButton(
                            onPressed: () {
                              controller.applyFilter();
                            },
                            child: Center(
                                child: Text(
                              kLabelApply,
                              style: TextStyles.kTextH18WhiteBold500
                                  .copyWith(color: kColorWhite),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  List<Widget> filterChips() {
    List<Widget> widgets = [];
    for (int i = 0; i < controller.itemsFiltersList.length; i++) {
      Widget chips = Obx(() {
        return FilterChip(
          selectedColor: kColorPrimary,
          showCheckmark: false,
          selected: controller.itemsFiltersList[i].isSelected,
          elevation: 0.4,
          backgroundColor: kColorWhite,
          shadowColor: kColorDarkGreyAFAFAF,
          label: Text(controller.itemsFiltersList[i].filterName,
              style: controller.itemsFiltersList[i].isSelected == true
                  ? TextStyles.kTextH14WhiteBold400
                  : TextStyles.kTextH14DarkGreyBold400),
          onSelected: (value) {
            controller.updateFilterStatus(i: i);
          },
        );
      });
      widgets.add(chips);
    }
    return widgets;
  }

  List<Widget> categoryFilterChips() {
    List<Widget> widgets = [];
    int length = controller.itemsFiltersList2.length >= 6 &&
            controller.isMoreTextVisible.value
        ? 6
        : controller.itemsFiltersList2.length;
    // for (int i = 0; i < controller.itemsFiltersList2.length; i++) {
    for (int i = 0; i < length; i++) {
      Widget chips = Obx(() {
        return FilterChip(
          selectedColor: kColorPrimary,
          showCheckmark: false,
          selected: controller.itemsFiltersList2[i].isSelected,
          elevation: 0.4,
          backgroundColor: kColorWhite,
          shadowColor: kColorDarkGreyAFAFAF,
          label: Text(controller.itemsFiltersList2[i].filterName,
              style: controller.itemsFiltersList2[i].isSelected == true
                  ? TextStyles.kTextH14WhiteBold400
                  : TextStyles.kTextH14DarkGreyBold400),
          onSelected: (value) {
            controller.updateCategoryFilterStatus(i: i);
          },
        );
      });

      widgets.add(chips);
    }
    if (length >= 6 && controller.isMoreTextVisible.value) {
      widgets.add(FilterChip(
        selectedColor: kColorPrimary,
        showCheckmark: false,
        // selected: controller.itemsFiltersList2[i].isSelected,
        // elevation: 0.4,
        backgroundColor: kColorWhite,
        shadowColor: kColorDarkGreyAFAFAF,
        label: Text(
            '${controller.itemsFiltersList2.length - length} $kLabelMore',
            style: TextStyles.kTextH14Grey8E8E8EBold400),
        onSelected: (value) {
          controller.isMoreTextVisible.value = false;
        },
      ));
    }
    return widgets;
  }
}
