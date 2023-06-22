import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/image_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/base/controller/invoice_quotation_listing_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/base/view/invoice_listing_screen.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/quotation/base/view/quotation_listing_screen.dart';
import 'package:bms/app/utils/calculate_price/calculations.dart';
import 'package:bms/app/utils/currency_formatter/currency_formatter.dart';
import 'package:bms/app/utils/text_styles.dart';
import 'package:bms/app/widgets/appBar/app_bar_with_back_button.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class InvoiceQuotationListingScreen
    extends GetView<InvoiceQuotationListingController> {
  InvoiceQuotationListingScreen({Key? key}) : super(key: key) {
    final intentData = Get.arguments;
    controller.setIntentData(intentData: intentData);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: controller.isCustomerUpdated.value);
        return true;
      },
      child: SafeArea(
        child: Obx(() {
          return Scaffold(
            backgroundColor: kColorWhite,
            appBar: AppBarWithBackButton(
              title: controller.customerData.value.name ?? '',
              isShowLeadingIcon: true,
              isShowActionWidgets: true,
              result: controller.isCustomerUpdated.value,
              widget: [
                Obx(() {
                  return GestureDetector(
                    onTap: () {
                      openFilterBottomSheet();
                    },
                    child: controller.isFilterApplied.value ? SvgPicture.asset(
                        kIconFilledFilterWithoutBox) : SvgPicture.asset(kIconFilterWithOutBox),);
                }),
                GestureDetector(
                  onTap: () {
                    controller.navigateToEditCustomerScreen();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 23, right: 30),
                    child: SvgPicture.asset(
                      kIconEdit,
                    ),
                  ),
                ),
              ],
            ),
            body: Obx(
                  () {
                return controller.isDataLoading.value
                    ? Container()
                    : Column(
                  children: [
                    priceSummaryInfoContainer(),
                    invoiceQuotationTabBar(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: InvoiceListingScreen(),
                      ),
                    ),
                    // invoiceQuotationTabBar(),
                    // Obx(
                    //       () {
                    //     return Expanded(
                    //       child: Container(
                    //         child: controller.currentTabValue.value == 1
                    //             ? InvoiceListingScreen()
                    //             : QuotationListingScreen(),
                    //       ),
                    //     );
                    //   },
                    // ),
                  ],
                );
              },
            ),
          );
        }),
      ),
    );
  }

  /// price summary data container
  Widget priceSummaryInfoContainer() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            width: 110,
            height: 80,
            margin: const EdgeInsets.only(left: 20),
            padding: const EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              color: kColorPurpleEEF2,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                    '$kRupee ${currencyFormatter(
                        amount: (controller.summaryData.value.totalSell ?? 0.0))
                        .output.compactNonSymbol}',
                    style: TextStyles.kTextH20DarkGreyBold600),
                const Text(kLabelTotalSell,
                    style: TextStyles.kTextH14DarkGreyBold400),
              ],
            ),
          ),
          Container(
            width: 110,
            height: 80,
            margin: const EdgeInsets.only(left: 10),
            padding: const EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              color: kColorGreenF1FF,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                    '$kRupee ${currencyFormatter(
                        amount: (controller.summaryData.value.totalCollected ??
                            0.0)).output.compactNonSymbol}',
                    style: TextStyles.kTextH20Green7BD336Bold600),
                const Text(kLabelCollected,
                    style: TextStyles.kTextH14DarkGreyBold400),
              ],
            ),
          ),
          Container(
            width: 110,
            height: 80,
            margin: const EdgeInsets.only(left: 10),
            padding: const EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              color: kColorRedFFF1F2,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                    '$kRupee ${currencyFormatter(amount: (calculateDueAmount(
                        totalSellAmount: controller.summaryData.value
                            .totalSell ?? 0.0,
                        totalCollectedAmount: controller.summaryData.value
                            .totalCollected ?? 0.0))).output.compactNonSymbol}',
                    style: TextStyles.kTextH20RedEE7078Bold600),
                const Text(kLabelDue,
                    style: TextStyles.kTextH14DarkGreyBold400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget invoiceQuotationTabBar() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.only(
            left: 20, right: 20, top: 10, bottom: 10),
        child: CustomSlidingSegmentedControl<int>(
          initialValue: 1,
          isStretch: true,
          children: {
            1: Text(
              kLabelInvoice,
              style: controller.currentTabValue.value == 1
                  ? TextStyles.kTextH16White500
                  : TextStyles.kTextH16Grey73500,
            ),
            // 2: Text(
            //   kLabelQuotation,
            //   style: controller.currentTabValue.value == 2
            //       ? TextStyles.kTextH16White500
            //       : TextStyles.kTextH16Grey73500,
            // ),
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

  void openFilterBottomSheet() {
    Get.bottomSheet(
      isDismissible: false,
      Container(
        height: Get.height*0.4, // 300
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
                  const Text(kLabelSortByPaymentStatus,
                      style: TextStyles.kTextH16Primary600),
                  Wrap(
                    spacing: 8,
                    children: filterChips(),
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
      ),
    );
  }

  List<Widget> filterChips() {
    List<Widget> widgets = [];
    for (int i = 0; i < controller.invFiltersList.length; i++) {
      Widget chips = Obx(() {
        return FilterChip(
          selectedColor: kColorPrimary,
          showCheckmark: false,
          selected: controller.invFiltersList[i].isSelected,
          elevation: 0.4,
          backgroundColor: kColorWhite,
          shadowColor: kColorDarkGreyAFAFAF,
          label: Text(controller.invFiltersList[i].filterName,
              style: controller.invFiltersList[i].isSelected == true
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
}
