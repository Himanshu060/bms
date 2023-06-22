import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/image_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/customer_base_screen/base/controller/customer_base_controller.dart';
import 'package:bms/app/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomerBaseScreen extends GetView<CustomerBaseController> {
  CustomerBaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kColorWhite,
          resizeToAvoidBottomInset: true,
          body: Obx(() {
            return Column(
              children: [
                customerTextAndPlusIcon(),
                controller.isDataLoading.value
                    ? Container()
                    : controller.appliedCustomerDataList.isEmpty
                        ? SvgPicture.asset(kImgCustomerEmptyGraphic)
                        : Expanded(
                            child: Column(
                              children: [
                                searchCustomerTextFieldAndFilter(),
                                customerListView(),
                              ],
                            ),
                          ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget searchCustomerTextFieldAndFilter() {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SizedBox(
                height: 45.38,
                child: TextFormField(
                  maxLength: 100,
                  controller: controller.searchCustomerController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  // validator: (text) {
                  //   return TwoWaayFormValidation().validate(widget.fieldType, text);
                  // },
                  onChanged: (String inputEntry) {
                    if (inputEntry.trim().isNotEmpty) {
                      controller.searchCustomerValue.value = inputEntry;
                      controller.onSearchValueChange();
                    } else {
                      controller.searchCustomerValue.value = '';
                      controller.searchCustomerDataList.value = [];
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: TextStyles.kTextH14DarkGrey3535Bold600,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    suffixIcon: controller.searchCustomerValue.value.isEmpty
                        ? Text('')
                        : GestureDetector(
                            onTap: () {
                              controller.searchCustomerController.text = '';
                              controller.searchCustomerValue.value = '';
                              controller.searchCustomerDataList.value = [];
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
                    contentPadding: const EdgeInsets.only(
                      left: 14.0,
                      bottom: 0,
                      top: 13,
                    ),
                    isCollapsed: true,
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
                    hintText: kLabelSearchCustomers,
                    focusColor: kColorPrimary,
                  ),
                ),
              ),
            ),
          ),
          Obx(() {
            return GestureDetector(
              onTap: () {
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

  Widget customerTextAndPlusIcon() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 20, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            kLabelCustomers,
            style: TextStyles.kTextH18DarkGreyBold700,
          ),
          GestureDetector(
            onTap: () {
              controller.navigateToAddCustomerScreen();
            },
            child: SvgPicture.asset(kIconPlus),
          ),
        ],
      ),
    );
  }

  customerListView() {
    return Obx(
      () {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 16),
            child: ListView.builder(
              itemCount: controller.searchCustomerValue.isNotEmpty
                  ? controller.searchCustomerDataList.length
                  : controller.appliedCustomerDataList.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                var customerData = controller.searchCustomerValue.isNotEmpty
                    ? controller.searchCustomerDataList[index]
                    : controller.appliedCustomerDataList[index];
                return GestureDetector(
                  onTap: () {
                    controller.navigateToInvoiceQuotationListingScreen(
                        customerDetailData: customerData);
                  },
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 27, top: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: Get.width * 0.55,
                                child: Text(customerData.name ?? '',
                                    style: TextStyles.kTextH16DarkGrey600,
                                    maxLines: 2),
                              ),
                              Text(
                              '$kRupee${controller.returnFormattedAmountValues(
                                  customerData: customerData)}',
                                  style: TextStyles.kTextH16Primary600),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 27, top: 11, bottom: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: SvgPicture.asset(kIconPhone),
                                  ),
                                  Text((customerData.mobileNo ?? 0).toString(),
                                      style: TextStyles.kTextH14Grey8DShade600),
                                ],
                              ),
                              const Text(
                                // ((customerData.balance).toString()[0]) == "-"
                                //     ? kLabelPay
                                //     :
                                kLabelDue,
                                style:
                                    // ((customerData.balance).toString()[0]) ==
                                    //         "-"
                                    //     ? TextStyles.kTextH14RedBold500
                                    //     :
                                    TextStyles.kTextH14GreenBold500,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: kColorDividerGrey,
                          height: 1,
                          margin: const EdgeInsets.only(left: 22, right: 25),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void openFilterBottomSheet() {
    Get.bottomSheet(
      isDismissible: false,
      Container(
        height: 300,
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
                    children: orderingChips(),
                  ),
                  const Text(kLabelFilterBy,
                      style: TextStyles.kTextH16Primary600),
                  Wrap(
                    spacing: 8,
                    children: dueChips(),
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

  List<Widget> orderingChips() {
    List<Widget> widgets = [];
    for (int i = 0; i < controller.custFiltersList.length; i++) {
      Widget chips = Obx(() {
        return FilterChip(
          selectedColor: kColorPrimary,
          showCheckmark: false,
          selected: controller.custFiltersList[i].isSelected,
          elevation: 0.4,
          backgroundColor: kColorWhite,
          shadowColor: kColorDarkGreyAFAFAF,
          label: Text(controller.custFiltersList[i].filterName,
              style: controller.custFiltersList[i].isSelected == true
                  ? TextStyles.kTextH14WhiteBold400
                  : TextStyles.kTextH14DarkGreyBold400),
          onSelected: (value) {
            controller.updateOrderingFilterStatus(i: i);
          },
        );
      });
      widgets.add(chips);
    }
    return widgets;
  }

  List<Widget> dueChips() {
    List<Widget> widgets = [];
    for (int i = 0; i < controller.custFiltersList2.length; i++) {
      Widget chips = Obx(() {
        return FilterChip(
          selectedColor: kColorPrimary,
          showCheckmark: false,
          selected: controller.custFiltersList2[i].isSelected,
          elevation: 0.4,
          backgroundColor: kColorWhite,
          shadowColor: kColorDarkGreyAFAFAF,
          label: Text(controller.custFiltersList2[i].filterName,
              style: controller.custFiltersList2[i].isSelected == true
                  ? TextStyles.kTextH14WhiteBold400
                  : TextStyles.kTextH14DarkGreyBold400),
          onSelected: (value) {
            controller.updateDueFilterStatus(i: i);
          },
        );
      });
      widgets.add(chips);
    }
    return widgets;
  }
}
