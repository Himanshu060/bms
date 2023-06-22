import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/image_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/base/model/response/summary_data_response.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/base/controller/invoice_listing_controller.dart';
import 'package:bms/app/utils/date_format/convert_date_time_to_formatted_date_time.dart';
import 'package:bms/app/utils/number_formatter/number_formatter.dart';
import 'package:bms/app/utils/return_string_as_fixed_value.dart';
import 'package:bms/app/utils/text_styles.dart';
import 'package:bms/app/widgets/buttons/primary_button.dart';
import 'package:bms/app/widgets/dialogs/show_confirm_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class InvoiceListingScreen extends GetView<InvoiceListingController> {
  InvoiceListingScreen({Key? key, InvoiceDetailData? invoiceDetailData})
      : super(key: key) {
    controller.setIntentData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          return Expanded(
            child: controller.appliedInvoiceFilterList.isEmpty
                ? emptyInvoiceWidget()
                : ListView.builder(
                    itemCount: controller.appliedInvoiceFilterList.length,
                    itemBuilder: (context, index) {
                      var invoiceData = controller.appliedInvoiceFilterList[index];
                      return Container(
                        margin: const EdgeInsets.only(
                            right: 20, left: 20, bottom: 10),
                        decoration: const BoxDecoration(
                          color: kColorPurpleF4F7FF,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          title: Column(
                            children: [
                              /// invoice number
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 14, top: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          kLabelInvoiceNo,
                                          style: TextStyles
                                              .kTextH14DarkGreyBold400,
                                        ),
                                        Text(
                                          '#${invoiceData.invNo ?? 0}',
                                          style: TextStyles
                                              .kTextH14DarkGreyBold600,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              controller
                                                  .downloadInvoicePdfDataFromServer(
                                                      invoiceId: invoiceData
                                                          .invoiceId
                                                          .toString(),
                                                      invoiceNo: invoiceData
                                                          .invNo
                                                          .toString());
                                            },
                                            child: SvgPicture.asset(
                                                kIconPdfDownload)),
                                        PopupMenuButton(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 14),
                                            child:
                                                SvgPicture.asset(kIconMenu),
                                          ),
                                          itemBuilder: (context) =>
                                              <PopupMenuEntry<Widget>>[
                                            PopupMenuItem(
                                              height: 12,
                                              padding: const EdgeInsets.only(
                                                  left: 12, top: 6),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      kIconPrint),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8),
                                                    child: Text(
                                                      kLabelPrint,
                                                      style: TextStyles
                                                          .kTextH12PrimaryBold400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              height: 10,
                                              onTap: () {
                                                controller.shareInvoicePdf(
                                                    invoiceId: invoiceData.invoiceId.toString(),
                                                    invoiceNo:
                                                    invoiceData.invNo.toString());
                                              },
                                              padding: const EdgeInsets.only(
                                                  left: 12, top: 12),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      kIconShare),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8),
                                                    child: Text(
                                                      kLabelShare,
                                                      style: TextStyles
                                                          .kTextH12PrimaryBold400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              height: 10,
                                              padding: const EdgeInsets.only(
                                                  left: 12,
                                                  top: 12,
                                                  bottom: 6),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      kIconReminder),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8),
                                                    child: Text(
                                                      kLabelReminder,
                                                      style: TextStyles
                                                          .kTextH12PrimaryBold400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 1,
                                color: kColorGreyD8,
                                margin: const EdgeInsets.only(
                                    top: 4, right: 14, left: 14),
                              ),

                              /// total and date row
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 14, right: 11, top: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(kLabelTotalWithColon,
                                            style: TextStyles
                                                .kTextH14DarkGreyBold400),
                                        Text(
                                            '$kRupee${returnFormattedNumber(values: double.parse(returnToStringAsFixed(value: invoiceData.totalAmount ?? 0.0)))}',
                                            style: invoiceData.status == 4
                                                ? TextStyles
                                                    .kTextH16DarkGreyAFAFAF600
                                                : TextStyles
                                                    .kTextH16DarkGrey600),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(kIconCalendar),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Text(
                                              returnConvertedDateTimerFormat(
                                                  createdOnDate:
                                                      invoiceData.createdOn ??
                                                          ''),
                                              style: TextStyles
                                                  .kTextH14DarkGreyBold400),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              /// due and payment tag
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 14, right: 7, top: 8, bottom: 9),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(kLabelDueWithColon,
                                            style: TextStyles
                                                .kTextH14DarkGreyBold400),
                                        Text(
                                            controller.returnDueAmountText(
                                                invoiceData: invoiceData),
                                            style: TextStyles
                                                .kTextH16DarkGrey600),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                              left: 7, right: 7),
                                          decoration: BoxDecoration(
                                            color: kColorWhite,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Row(
                                            children: [
                                              getPaymentTabIcon(
                                                  status:
                                                      invoiceData.status ??
                                                          0),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(
                                                        left: 8),
                                                child: Text(
                                                    controller
                                                        .returnPaymentTag(
                                                            status: invoiceData
                                                                    .status ??
                                                                0),
                                                    style: TextStyles
                                                        .kTextH14DarkGreyBold400),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          children: [
                            Container(
                              height: 38,
                              margin:
                                  const EdgeInsets.only(right: 0, left: 0),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: const BoxDecoration(
                                color: kColorPrimary,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      controller.navigateToViewInvoiceScreen(
                                          index: index);
                                    },
                                    child: const Text(kLabelView,
                                        style: TextStyles.kTextH12WhiteBold700),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (invoiceData.status != 4) {
                                        controller
                                            .navigateToUpdateInvoiceScreen(
                                                invoiceDetailData: invoiceData);
                                      }
                                    },
                                    child:  Text(kLabelUpdate,
                                        style:invoiceData.status == 4?TextStyles.kTextH14Grey8DShade600: TextStyles.kTextH12WhiteBold700),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      controller.navigateToPayInScreen(
                                          invoiceData: invoiceData);
                                    },
                                    child: const Text(kLabelPayIn,
                                        style: TextStyles.kTextH12WhiteBold700),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (invoiceData.status != 4) {
                                        showDeleteDialog(
                                            invoiceData: invoiceData);
                                      }
                                    },
                                    child:  Text(kLabelCancel,
                                        style: invoiceData.status == 4?TextStyles.kTextH14Grey8DShade600:  TextStyles.kTextH12WhiteBold700),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
          );
        }),
        Padding(
          padding: const EdgeInsets.only(top: 11, bottom: 20),
          child: PrimaryButtonWidget(
              onPressed: () {
                controller.navigateToGenerateInvoiceScreen();
              },
              color: kColorPrimary,
              buttonTitle: kLabelGenerateInvoice.toUpperCase()),
        ),
      ],
    );
  }

  void showDeleteDialog({required InvoiceDetailData invoiceData}) {
    // showDialog(
    //   context: Get.overlayContext!,
    //   builder: (context) {
    //     return
          showConfirmDialogBox(
          title: '',
            type: kLabelWarning,
          message:
              '$kAreYouSureToCancel #${kLabelInvoiceNo}${invoiceData.invNo} ?',
          negativeButtonTitle: kLabelNo,
          negativeClicked: () {
            Get.back();
          },
          positiveButtonTitle: kLabelYes,
          positiveClicked: () {
            Get.back();
            controller.cancelInvoice(
              invoiceId: invoiceData.invoiceId.toString(),
            );
          },
        );
      // },
    // );
  }

  getPaymentTabIcon({required int status}) {
    if (status == 1) {
      return SvgPicture.asset(kIconPaidTag);
    } else if (status == 2) {
      return SvgPicture.asset(kIconPartialPaidTag);
    } else if (status == 3) {
      return SvgPicture.asset(kIconUnPaidTag);
    } else if (status == 4) {
      return SvgPicture.asset(kIconCancelTag);
    }
  }

  emptyInvoiceWidget() {
    return SvgPicture.asset(kImgInvoiceEmptyGraphic);
  }
}
