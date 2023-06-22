import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/image_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/pay_in/controller/invoice_pay_in_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/pay_in/model/response/get_pay_in_response_model.dart';
import 'package:bms/app/utils/date_format/convert_date_time_to_formatted_date_time.dart';
import 'package:bms/app/utils/number_formatter/number_formatter.dart';
import 'package:bms/app/utils/regex.dart';
import 'package:bms/app/utils/return_string_as_fixed_value.dart';
import 'package:bms/app/utils/text_styles.dart';
import 'package:bms/app/widgets/appBar/app_bar_with_back_button.dart';
import 'package:bms/app/widgets/dialogs/show_confirm_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class InvoicePayInScreen extends GetView<InvoicePayInController> {
  InvoicePayInScreen({Key? key}) : super(key: key) {
    final intentData = Get.arguments;
    controller.setIntentData(intentData: intentData);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: controller.isPayInUpdated.value);
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Obx(() {
          return Scaffold(
            appBar: AppBarWithBackButton(
                title: kLabelPayIn,
                isShowLeadingIcon: true,
                result: controller.isPayInUpdated.value),
            body: Obx(() {
              return controller.isDataLoading.value
                  ? Container()
                  : Column(
                      children: [
                        Visibility(
                          visible: controller.invoiceData.value.status != 4 &&
                              controller.invoiceData.value.status != 1,
                          child: Column(
                            children: [
                              invoiceNumberAndSettleAmountSwipeContainer(),
                              amountTextFieldAndCollectButton(),
                            ],
                          ),
                        ),
                        historyTextRow(),
                        historyListing(),
                      ],
                    );
            }),
          );
        }),
      ),
    );
  }

  Widget invoiceNumberAndSettleAmountSwipeContainer() {
    return Container(
      height: 108,
      margin: const EdgeInsets.only(left: 6, right: 6, top: 6),
      decoration: const BoxDecoration(
        color: kColorEFEFEF,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(kLabelInvoiceNo,
                    style: TextStyles.kTextH14DarkGreyBold400),
                Text('#${controller.invoiceData.value.invNo ?? 0}',
                    style: TextStyles.kTextH14DarkGreyBold600),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(kLabelRemainingAmountWithColon,
                    style: TextStyles.kTextH12Grey8DBold500),
                Text(
                    '$kRupee ${returnFormattedNumber(values: double.parse(returnToStringAsFixed(value: controller.remainingAmount.value)))}',
                    style: TextStyles.kTextH14DarkGreyBold600),
              ],
            ),
          ),
          // IgnorePointer(
          //   ignoring: controller.remainingAmount.value == 0.0,
          //   child: Row(
          //     children: [
          //       Text(kLabelRemainingAmountWithColon),
          //       Switch(
          //         value: controller.isDoFullPayment.value,
          //         onChanged: (value) {
          //           controller.isDoFullPayment.value = value;
          //           if (value) {
          //             controller.remainingPaidAmountController.text =
          //                 controller.remainingAmount.value.toStringAsFixed(2);
          //           } else {
          //             controller.remainingPaidAmountController.text = '';
          //           }
          //         },
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget amountTextFieldAndCollectButton() {
    if (controller.payInDataList.length == 4) {
      controller.remainingPaidAmountController.text =
          returnToStringAsFixed(value: controller.remainingAmount.value);
      controller.isValidAmount.value = true;
      controller.isButtonEnable.value = true;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: Get.width * 0.62,
                height: 34,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 0),
                  child: TextFormField(
                    maxLength: 100,
                    enabled: controller.payInDataList.length == 4 ||
                            // controller.isDoFullPayment.value ||
                            controller.remainingAmount.value == 0.0
                        ? false
                        : true,
                    controller: controller.remainingPaidAmountController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (String inputEntry) {
                      if (inputEntry.trim().isNotEmpty) {
                        controller.remainingAmountValue.value = inputEntry;
                      } else {
                        controller.remainingAmountValue.value = '';
                      }
                      // controller.passwordController.text = inputEntry;
                      controller.validateUserInput();
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegexData.digitAndPointRegex),
                    ],
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    style: TextStyles.kTextH14DarkGrey3535Bold600,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      suffixIcon: controller.remainingAmountValue.value.isEmpty
                          ? const Text('')
                          : GestureDetector(
                              onTap: () {
                                FocusScope.of(Get.overlayContext!).unfocus();
                                controller.remainingPaidAmountController.text =
                                    '';
                                controller.remainingAmountValue.value = '';
                              },
                              child:const Padding(
                                padding:  EdgeInsets.only(
                                    left: 12, right: 9, bottom: 9, top: 9),
                                child: Icon(
                                  Icons.close,
                                  color: kColorGrey96,
                                  size: 16,
                                ),
                              ),
                            ),
                      contentPadding:const EdgeInsets.only(
                          left: 20.0, bottom: 5, top: 5),
                      counterText: '',
                      focusedBorder:const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: kColorDarkGrey3535, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      enabledBorder:const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: kColorLightGrey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      disabledBorder:const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: kColorLightGrey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      hintStyle: TextStyles.kTextH16DarkGrey8D600,
                      hintText: kLabelPayInCollectHint,
                      focusColor: kColorPrimary,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: Get.width * 0.35,
                child: MaterialButton(
                  onPressed: () {
                    FocusScope.of(Get.overlayContext!).unfocus();
                    controller.checkValidation();
                  },
                  child: Container(
                    width: Get.width,
                    height: 34,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: kColorPrimary,
                        ),
                        color: kColorPrimary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6))),
                    child: Center(
                        child: Text(
                      kLabelCollect,
                      style: TextStyles.kTextH14WhiteBold500
                          .copyWith(color: kColorWhite),
                    )),
                  ),
                ),
              ),
            ],
          ),
          Obx(() {
            return Visibility(
              visible:
                  controller.remainingPaidAmountController.text.isNotEmpty ||
                      controller.isValidAmount.value == false,
              child: controller.amountStr.value == ''
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(left: 30, top: 2),
                      child: Text(controller.amountStr.value,
                          style: TextStyles.kTextH12Red)),
            );
          }),
        ],
      ),
    );
  }

  Widget historyTextRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: kColorLightGrey,
              // width: Get.width * 0.34,
              height: 1,
              margin: const EdgeInsets.only(left: 30, right: 8),
            ),
          ),
          const Text(
            kLabelHistory,
            style: TextStyles.kTextH14Grey8DShade500,
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: kColorLightGrey,
              // width: Get.width * 0.34,
              height: 1,
              margin: const EdgeInsets.only(left: 8, right: 30),
            ),
          ),
        ],
      ),
    );
  }

  Widget historyListing() {
    return Obx(() {
      return Expanded(
        child: controller.payInDataList.isEmpty
            ? const Center(
                child: Text(kNoPayInFound,
                    style: TextStyles.kTextH14MainGreyBold400),
              )
            : ListView.builder(
                itemCount: controller.payInDataList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var payInData = controller.payInDataList[index];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, bottom: 10, top: 10),
                        child: Row(
                          children: [
                            /// index number
                            Container(
                              color: kColorGreyF1F1F1,
                              margin: const EdgeInsets.only(right: 10),
                              height: 24,
                              width: 23,
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyles.kTextH16DarkGrey400,
                                ),
                              ),
                            ),

                            /// price , date and close button
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    /// price
                                    SizedBox(
                                      width: Get.width * 0.58,
                                      child: Text(
                                        '$kRupee ${returnFormattedNumber(values: double.parse(returnToStringAsFixed(value: payInData.paidAmount ?? 0.0)))}',
                                        style: payInData.cancelledOn != null
                                            ? TextStyles
                                                .kTextH16DarkGreyAFAFAF600
                                            : TextStyles.kTextH16DarkGrey600,
                                      ),
                                    ),
                                    /// date and close button
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            returnConvertedDateTimerFormat(
                                                createdOnDate:
                                                    payInData.createdOn ?? ''),
                                            style: payInData.cancelledOn != null
                                                ? TextStyles
                                                    .kTextH16DarkGreyAFAFAF600
                                                : TextStyles
                                                    .kTextH16DarkGrey400,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if (controller
                                                      .remainingAmount.value >
                                                  0) {
                                                if (controller.invoiceData.value
                                                            .status !=
                                                        4 &&
                                                    controller.invoiceData.value
                                                            .status !=
                                                        1) {
                                                  if (payInData.cancelledOn ==
                                                      null) {
                                                    showDeleteDialog(
                                                        payInData: payInData);
                                                  }
                                                }
                                              }
                                            },
                                            child: SvgPicture.asset(
                                              kIconCloseRed,
                                              color:
                                                  payInData.cancelledOn !=
                                                              null ||
                                                          controller
                                                                  .invoiceData
                                                                  .value
                                                                  .status ==
                                                              1 ||
                                                          controller
                                                                  .invoiceData
                                                                  .value
                                                                  .status ==
                                                              4
                                                      ? kColorDarkGreyAFAFAF
                                                      : kColorRed,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: index != controller.payInDataList.length - 1,
                        child: Container(
                          height: 1,
                          color: kColorDividerGrey,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ],
                  );
                },
              ),
      );
    });
  }

  void showDeleteDialog({required PayInData payInData}) {
    // showDialog(
    //   context: Get.overlayContext!,
    //   builder: (context) {
    //     return
    showConfirmDialogBox(
      title: '',
      message:
          '$kAreYouSureToDelete ${returnConvertedDateTimerFormat(createdOnDate: payInData.createdOn ?? '')} ?',
      negativeButtonTitle: kLabelCancel,
      negativeClicked: () {
        Get.back();
      },
      positiveButtonTitle: kLabelDelete,
      positiveClicked: () {
        Get.back();
        controller.cancelPayInApiCall(payInData: payInData);
      },
    );
    // },
    // );
  }
}
