import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/image_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/base/controller/invoice_base_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/base/model/response/transaction_response_model.dart';
import 'package:bms/app/utils/date_format/convert_date_time_to_formatted_date_time.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:bms/app/utils/number_formatter/number_formatter.dart';
import 'package:bms/app/utils/regex.dart';
import 'package:bms/app/utils/return_string_as_fixed_value.dart';
import 'package:bms/app/utils/text_styles.dart';
import 'package:bms/app/widgets/dialogs/show_confirm_dialog_widget.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class InvoiceBaseScreen extends GetView<InvoiceBaseController> {
  InvoiceBaseScreen({Key? key}) : super(key: key);

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
                transactionTextAndPlusIcon(),
                controller.isDataLoading.value
                    ? Container()
                    : Expanded(
                    child: controller.appliedFilterTransList.isEmpty
                        ? emptyTransWidget()
                        : Column(
                      children: [
                        searchInvoiceTextFieldAndFilter(),
                        transListView()
                      ],
                    )),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget transactionTextAndPlusIcon() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 20, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            kLabelTransactions,
            style: TextStyles.kTextH18DarkGreyBold700,
          ),
          GestureDetector(
            onTap: () {
              controller.navigateToAddInvoiceScreen();
            },
            child: SvgPicture.asset(kIconPlus),
          ),
        ],
      ),
    );
  }

  Widget searchInvoiceTextFieldAndFilter() {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SizedBox(
                height: 45.38,
                child: TextFormField(
                  maxLength: 100,
                  controller: controller.searchInvoiceController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegexData.nameRegex),
                  ],
                  onChanged: (String inputEntry) {
                    if (inputEntry
                        .trim()
                        .isNotEmpty) {
                      controller.searchTransStr.value = inputEntry;
                      controller.onSearchValueChange();
                    } else {
                      controller.searchTransStr.value = '';
                      controller.searchTransList.value = [];
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: TextStyles.kTextH14DarkGrey3535Bold600,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    suffixIcon: controller.searchTransStr.value.isEmpty
                        ? Text('')
                        : GestureDetector(
                      onTap: () {
                        controller.searchInvoiceController.text = '';
                        controller.searchTransStr.value = '';
                        controller.searchTransList.value = [];
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
                          left: 13, top: 12.83, bottom: 13),
                      child: SvgPicture.asset(kIconSearch),
                    ),
                    contentPadding: const EdgeInsets.only(
                        left: 13.0, right: 46.0, bottom: 11.84, top: 12.83),
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
                    hintText: kLabelSearchInvoices,
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
                child: controller.isFilterApplied.value?SvgPicture.asset(kIconFilledFilterWithBox):SvgPicture.asset(kIconFilter),
              ),
            );
          })
        ],
      ),
    );
  }

  Widget transListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: controller.searchTransStr.value.isNotEmpty
            ? controller.searchTransList.length
            : controller.appliedFilterTransList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var transData = controller.searchTransStr.value.isNotEmpty
              ? controller.searchTransList[index]
              : controller.appliedFilterTransList[index];
          return Container(
            margin: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
            padding: EdgeInsets.zero,
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
                    padding: const EdgeInsets.only(left: 14, top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                           width: Get.width*0.65,
                          child: Text(
                            '#${transData.invoiceNo ?? 0} - ${transData
                                .custName ?? ''}',
                            style: TextStyles.kTextH14DarkGreyBold600,overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  controller.downloadInvoicePdfDataFromServer(
                                      invoiceId: transData.id.toString(),
                                      invoiceNo:
                                      transData.invoiceNo.toString());
                                },
                                child: SvgPicture.asset(kIconPdfDownload)),
                            PopupMenuButton(
                              child: Padding(
                                padding:
                                const EdgeInsets.only(left: 10, right: 14),
                                child: SvgPicture.asset(kIconMenu),
                              ),
                              itemBuilder: (context) =>
                              <PopupMenuEntry<Widget>>[
                                PopupMenuItem(
                                  height: 12,
                                  padding:
                                  const EdgeInsets.only(left: 12, top: 6),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(kIconPrint),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8),
                                        child: Text(
                                          kLabelPrint,
                                          style:
                                          TextStyles.kTextH12PrimaryBold400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  height: 10,
                                  onTap: () {
                                    controller.shareInvoicePdf(
                                        invoiceId: transData.id.toString(),
                                        invoiceNo:
                                        transData.invoiceNo.toString());
                                  },
                                  padding:
                                  const EdgeInsets.only(left: 12, top: 12),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(kIconShare),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8),
                                        child: Text(
                                          kLabelShare,
                                          style:
                                          TextStyles.kTextH12PrimaryBold400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  height: 10,
                                  padding: const EdgeInsets.only(
                                      left: 12, top: 12, bottom: 6),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(kIconReminder),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8),
                                        child: Text(
                                          kLabelReminder,
                                          style:
                                          TextStyles.kTextH12PrimaryBold400,
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
                    margin: const EdgeInsets.only(top: 4, right: 14, left: 14),
                  ),

                  /// total and date row
                  Padding(
                    padding: const EdgeInsets.only(left: 14, right: 11, top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(kLabelTotalWithColon,
                                style: TextStyles.kTextH14DarkGreyBold400),
                            Text(
                                '$kRupee${returnFormattedNumber(
                                    values: double.parse(returnToStringAsFixed(
                                        value: transData.payableAmount ??
                                            0.0)))}',
                                style: transData.status == 4
                                    ? TextStyles.kTextH16DarkGreyAFAFAF600
                                    : TextStyles.kTextH16DarkGrey600),
                          ],
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(kIconCalendar),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                  returnConvertedDateTimerFormat(
                                      createdOnDate: transData.createdOn ?? ''),
                                  style: TextStyles.kTextH14DarkGreyBold400),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(kLabelDueWithColon,
                                style: TextStyles.kTextH14DarkGreyBold400),
                            Text(
                                controller.returnDueAmountText(
                                    transData: transData),
                                style: TextStyles.kTextH16DarkGrey600),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 7, right: 7),
                              decoration: BoxDecoration(
                                color: kColorWhite,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  getPaymentTabIcon(
                                      status: transData.status ?? 0),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                        controller.returnPaymentTag(
                                            status: transData.status ?? 0),
                                        style:
                                        TextStyles.kTextH14DarkGreyBold400),
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
                  margin: const EdgeInsets.only(right: 0, left: 0),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    color: kColorPrimary,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.navigateToViewInvoiceScreen(
                              transData: transData);
                        },
                        child: const Text(kLabelView,
                            style: TextStyles.kTextH12WhiteBold700),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (transData.status != 4) {
                            controller.navigateToUpdateInvoiceScreen(
                                transData: transData);
                          }
                        },
                        child: Text(kLabelUpdate,
                            style: transData.status == 4 ? TextStyles
                                .kTextH14Grey8DShade600 : TextStyles
                                .kTextH12WhiteBold700),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.navigateToPayInScreen(
                              transData: transData);
                        },
                        child: const Text(kLabelPayIn,
                            style: TextStyles.kTextH12WhiteBold700),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (transData.status != 4) {
                            showDeleteDialog(transData: transData);
                          }
                        },
                        child: Text(kLabelCancel,
                            style: transData.status == 4 ? TextStyles
                                .kTextH14Grey8DShade600 : TextStyles
                                .kTextH12WhiteBold700),
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
  }

  Widget invoiceQuotationCashSaleTabBar() {
    return Obx(() {
      return Padding(
        padding:
        const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 16),
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
            2: Text(
              kLabelQuotation,
              style: controller.currentTabValue.value == 2
                  ? TextStyles.kTextH16White500
                  : TextStyles.kTextH16Grey73500,
            ),
            3: Text(
              kLabelCashSale,
              style: controller.currentTabValue.value == 3
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
          },
        ),
      );
    });
  }

  Widget customerInfoContainer() {
    return Obx(
          () {
        return Column(
          children: [

            /// customer name
            Focus(
              onFocusChange: (hasFocus) {
                controller.changeFocus(hasFocus: hasFocus, fieldNumber: 3);
                // if (controller.productNameController.text.trim().isNotEmpty) {
                /*controller.validateUserInput(fieldNumber: 1, isOnChange: false);*/
                // }
              },
              child: Obx(
                    () {
                  return Container(
                    width: Get.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 42,
                          child: TextFormField(
                            controller: controller.customerNameController,
                            maxLength: 50,
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            onChanged: (String value) {
                              if (value.isEmpty) {
                                controller.customerNameValue.value = '';
                                controller.searchCustomerList.clear();
                              } else {
                                controller.customerNameValue.value = value;
                                controller.onCustomerNameValueChange();
                              }
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegexData.nameRegex),
                            ],
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            style: TextStyles.kTextH14DarkGreyBold400,
                            enableSuggestions: false,
                            autocorrect: false,
                            obscureText: false,
                            decoration: InputDecoration(
                              // labelText: kLabelProducts,
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 9, bottom: 9, top: 9),
                                child:
                                controller.isFocusOnCustomerNameField.value
                                    ? SvgPicture.asset(kIconDropDownUp)
                                    : SvgPicture.asset(kIconDropDown),
                              ),
                              counterText: '',
                              fillColor: kColorPurpleF4F7FF,
                              filled: true,
                              contentPadding: const EdgeInsets.only(
                                  left: 14.0, bottom: 11, top: 11),
                              labelStyle:
                              controller.isFocusOnCustomerNameField.value ||
                                  controller.customerNameController.text
                                      .isNotEmpty
                                  ? TextStyles.kTextH14DarkGreyBold400
                                  : TextStyles.kTextH14Grey96Bold400,
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: kColorDarkGrey3535, width: 1.0),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: kColorLightGrey, width: 1.0),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                              ),
                              hintStyle: TextStyles.kTextH14Grey96Bold400,
                              hintText: kLabelSearchCustomer,
                              focusColor: kColorPrimary,
                            ),
                          ),
                        ),
                        Obx(() {
                          return Visibility(
                            visible: controller
                                .customerNameController.text.isNotEmpty ||
                                controller.isValidCustomerName.value == false,
                            child: controller.customerNameStr.value == ''
                                ? Container()
                                : Padding(
                                padding:
                                const EdgeInsets.only(left: 10, top: 2),
                                child: Text(
                                    controller.customerNameStr.value,
                                    style: TextStyles.kTextH12Red)),
                          );
                        }),
                      ],
                    ),
                  );
                },
              ),
            ),

            /// customer mobile no. and gmail id
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Visibility(
                visible: true,
                // visible: controller.customerData.value.emailId!=null,
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: Get.width * 0.35,
                      padding:
                      const EdgeInsets.only(left: 14, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: kColorPurpleF4F7FF,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: kColorLightGrey),
                      ),
                      child: Text(
                        (controller.customerData.value.mobileNo ?? 'mobile no.')
                            .toString(),
                        style: TextStyles.kTextH14DarkGreyBold400,
                      ),
                    ),
                    Container(
                      height: 40,
                      width: Get.width * 0.53,
                      padding:
                      const EdgeInsets.only(left: 14, top: 10, bottom: 10),
                      margin: const EdgeInsets.only(left: 6),
                      decoration: BoxDecoration(
                        color: kColorPurpleF4F7FF,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: kColorLightGrey),
                      ),
                      child: Text(
                        controller.customerData.value.emailId ?? 'email-Id',
                        style: TextStyles.kTextH14DarkGreyBold400,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget productAndBarcodeContainer() {
    return Container(
      margin: const EdgeInsets.only(left: 20.0),
      child: Row(
        children: [
          productNameTextField(),
          barCodeTextField(),
        ],
      ),
    );
  }

  Widget productNameTextField() {
    return Focus(
      onFocusChange: (hasFocus) {
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 1);
        // if (controller.productNameController.text.trim().isNotEmpty) {
        /*controller.validateUserInput(fieldNumber: 1, isOnChange: false);*/
        // }
      },
      child: Obx(
            () {
          return SizedBox(
            width: Get.width * 0.45,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 42,
                  child: TextFormField(
                    controller: controller.productNameController,
                    maxLength: 50,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (String value) {
                      if (value.isEmpty) {
                        controller.productNameValue.value = '';
                        controller.searchItemsList.clear();
                      } else {
                        controller.productNameValue.value = value;
                        controller.onProductNameValueChange();
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: TextStyles.kTextH14DarkGreyBold400,
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      // labelText: kLabelProducts,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(
                            left: 1, right: 1, bottom: 11, top: 11),
                        child: SvgPicture.asset(kIconSearch),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(
                            left: 12, right: 9, bottom: 9, top: 9),
                        child: controller.isFocusOnProductNameField.value
                            ? SvgPicture.asset(kIconDropDownUp)
                            : SvgPicture.asset(kIconDropDown),
                      ),
                      counterText: '',
                      fillColor: kColorGreyF1F1F1,
                      filled: true,
                      contentPadding:
                      const EdgeInsets.only(left: 0.0, bottom: 11, top: 11),
                      labelStyle: controller.isFocusOnProductNameField.value ||
                          controller.productNameController.text.isNotEmpty
                          ? TextStyles.kTextH14DarkGreyBold400
                          : TextStyles.kTextH14Grey96Bold400,
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
                      hintStyle: TextStyles.kTextH14Grey96Bold400,
                      hintText: kLabelSearch,
                      focusColor: kColorPrimary,
                    ),
                  ),
                ),
                Obx(() {
                  return Visibility(
                    visible: controller.productNameController.text.isNotEmpty ||
                        controller.isValidProductName.value == false,
                    child: controller.productNameStr.value == ''
                        ? Container()
                        : Padding(
                        padding: const EdgeInsets.only(left: 10, top: 2),
                        child: Text(controller.productNameStr.value,
                            style: TextStyles.kTextH12Red)),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget barCodeTextField() {
    return Row(
      children: [
        Focus(
          onFocusChange: (hasFocus) {
            controller.changeFocus(hasFocus: hasFocus, fieldNumber: 2);
            // if (controller.barCodeController.text.trim().isNotEmpty) {
            //   controller.validateUserInput(fieldNumber: 2,onChange: false);
            // }
          },
          child: Obx(() {
            return Container(
              width: Get.width * 0.31,
              margin: const EdgeInsets.only(left: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 42,
                    child: TextFormField(
                      controller: controller.barCodeController,
                      maxLength: 50,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (String value) {
                        // controller.validateUserInput(fieldNumber: 2);
                        if (value.isEmpty) {
                          controller.productNameValue.value = '';
                          controller.searchItemsList.clear();
                        } else {
                          controller.productNameValue.value = value;
                          controller.onBarCodeValueChange();
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      style: TextStyles.kTextH14DarkGreyBold400,
                      enableSuggestions: false,
                      autocorrect: false,
                      obscureText: false,
                      decoration: InputDecoration(
                        counterText: '',
                        fillColor: kColorGreyF1F1F1,
                        filled: true,
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 0, top: 11),
                        labelStyle: controller.isFocusOnBarcodeField.value ||
                            controller.barCodeController.text.isNotEmpty
                            ? TextStyles.kTextH14DarkGreyBold400
                            : TextStyles.kTextH14Grey96Bold400,
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
                        hintStyle: TextStyles.kTextH14Grey96Bold400,
                        hintText: kLabelBarcode,
                        focusColor: kColorPrimary,
                      ),
                    ),
                  ),
                  Obx(() {
                    return Visibility(
                      visible: controller.barCodeController.text.isNotEmpty ||
                          controller.isValidBarcode.value == false,
                      child: controller.barCodeStr.value == ''
                          ? Container()
                          : Padding(
                          padding: const EdgeInsets.only(left: 10, top: 2),
                          child: Text(controller.barCodeStr.value,
                              style: TextStyles.kTextH12Red)),
                    );
                  }),
                ],
              ),
            );
          }),
        ),
        GestureDetector(
          onTap: () {
            openBarCodeScanner();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 6),
            child: SvgPicture.asset(kIconBarcodeScanner),
          ),
        ),
      ],
    );
  }

  Widget itemsListView() {
    return Obx(() {
      return controller.selectedItemsList.isEmpty
          ? Container(
        height: Get.height * 0.44,
        margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
        decoration: BoxDecoration(
          border: Border.all(color: kColorLightGrey),
        ),
        child: const Center(
          child: Text(
            kNoItemsFound,
            style: TextStyles.kTextH16DarkGrey600,
          ),
        ),
      )
          : Container(
        height: Get.height * 0.44,
        margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
        child: ListView.builder(
          // itemCount: controller.itemsList.length,
          itemCount: controller.selectedItemsList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            // var itemData = controller.itemsList[index];
            var itemData = controller.selectedItemsList[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                border: Border.all(color: kColorLightGrey),
              ),
              child: Column(
                children: [

                  /// item name and price
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          itemData.name ?? '',
                          style: TextStyles.kTextH14DarkGreyBold400,
                        ),
                        RichText(
                          text: TextSpan(children: [
                            const TextSpan(
                              text: kRupee,
                              style: TextStyles.kTextH14DarkGreyBold400,
                            ),
                            TextSpan(
                              text: returnToStringAsFixed(
                                  value: itemData.itemTotal ?? 0.0),
                              style: TextStyles.kTextH14DarkGreyBold600,
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),

                  /// price label and item price text-field
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 10),
                    child: Row(
                      children: [

                        /// price label
                        const Text(
                          kLabelPrice,
                          style: TextStyles.kTextH14DarkGreyBold600,
                        ),

                        /// price text-field
                        Focus(
                          onFocusChange: (hasFocus) {
                            // controller.changeFocus(hasFocus: hasFocus, fieldNumber: 2);
                            // if (controller.barCodeController.text.trim().isNotEmpty) {
                            controller.onPriceValueChange(
                                index: index, isOnChange: false);
                            // }
                          },
                          child: Obx(() {
                            return Container(
                              width: Get.width * 0.2,
                              margin: const EdgeInsets.only(left: 0),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 28,
                                    child: TextFormField(
                                      controller: controller
                                          .priceTextFieldList[index],
                                      maxLength: 50,
                                      autovalidateMode: AutovalidateMode
                                          .onUserInteraction,
                                      onChanged: (String value) {
                                        controller.onPriceValueChange(
                                            index: index);
                                      },
                                      keyboardType:
                                      TextInputType.emailAddress,
                                      textInputAction:
                                      TextInputAction.next,
                                      style: TextStyles
                                          .kTextH14DarkGreyBold600,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      obscureText: false,
                                      decoration: const InputDecoration(
                                        // labelText: kLabelBarcode,
                                        prefixText: kRupee,
                                        prefixStyle: TextStyles
                                            .kTextH14DarkGreyBold400,
                                        counterText: '',
                                        fillColor: kColorGreyF1F1F1,
                                        filled: true,
                                        contentPadding: EdgeInsets.only(
                                            left: 5, bottom: 3, top: 4),
                                        // labelStyle: controller.isFocusOnBarcodeField.value ||
                                        //     controller.textFieldList[index].text.isNotEmpty
                                        //     ? TextStyles.kTextH14DarkGreyBold400
                                        //     : TextStyles.kTextH14Grey96Bold400,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: kColorWhite,
                                              width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: kColorWhite,
                                              width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                        // hintStyle: TextStyles.kTextH14Grey96Bold400,
                                        // hintText: kLabelBarcode,
                                        focusColor: kColorPrimary,
                                      ),
                                    ),
                                  ),
                                  Obx(() {
                                    return Visibility(
                                      visible: controller
                                          .priceTextFieldList[index]
                                          .text
                                          .isNotEmpty ||
                                          controller
                                              .isValidBarcode.value ==
                                              false,
                                      child: controller
                                          .barCodeStr.value ==
                                          ''
                                          ? Container()
                                          : Padding(
                                          padding:
                                          const EdgeInsets.only(
                                              left: 10, top: 2),
                                          child: Text(
                                              controller
                                                  .barCodeStr.value,
                                              style: TextStyles
                                                  .kTextH12Red)),
                                    );
                                  }),
                                ],
                              ),
                            );
                          }),
                        ),

                        /// units
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(
                            '/${controller.returnUnitName(index: index)}',
                            style: TextStyles.kTextH14DarkGreyBold400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// gst and plus-minus qty buttons
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, top: 7, right: 4, bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        /// gst text
                        RichText(
                          text: TextSpan(children: [
                            const TextSpan(
                                text: kLabelGST,
                                style:
                                TextStyles.kTextH14DarkGreyBold400),
                            TextSpan(
                                text:
                                '${controller.returnGstRate(index: index)} %',
                                style:
                                TextStyles.kTextH14DarkGreyBold600),
                          ]),
                        ),

                        /// plus-minus qty buttons
                        Row(
                          children: [

                            /// plus button
                            GestureDetector(
                              onTap: () {
                                if (itemData.qty! > 1) {
                                  controller.minus(index: index);
                                } else {
                                  controller.removeItemFromList(
                                      itemData: itemData);
                                }
                              },
                              child: Container(
                                height: 28,
                                width: 28,
                                decoration: const BoxDecoration(
                                  color: kColorPrimary,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    bottomLeft: Radius.circular(4),
                                  ),
                                ),
                                child: Center(
                                  child: itemData.qty! <= 1
                                      ? SvgPicture.asset(
                                    kIconDelete,
                                    color: kColorWhite,
                                    height: 15,
                                    width: 15,
                                  )
                                      : const Text(
                                    '-',
                                    style: TextStyles
                                        .kTextH18WhiteBold500,
                                  ),
                                ),
                              ),
                            ),

                            Focus(
                              onFocusChange: (hasFocus) {
                                // controller.changeFocus(hasFocus: hasFocus, fieldNumber: 2);
                                // if (controller.barCodeController.text.trim().isNotEmpty) {
                                controller.onQtyValueChange(
                                    index: index, isOnChange: false);
                                // }
                              },
                              child: Obx(() {
                                return SizedBox(
                                  width: Get.width * 0.1,
                                  height: 28,
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    controller: controller
                                        .qtyTextFieldList[index],
                                    autovalidateMode: AutovalidateMode
                                        .onUserInteraction,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegexData.digitAndPointRegex),
                                    ],
                                    onChanged: (String value) {
                                      controller.onQtyValueChange(
                                          index: index);
                                    },
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    style: TextStyles
                                        .kTextH14DarkGreyBold600,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    obscureText: false,
                                    decoration: const InputDecoration(
                                      // labelText: kLabelBarcode,
                                      counterText: '',
                                      contentPadding: EdgeInsets.only(
                                        // left: 10,
                                        bottom: 3,
                                        top: 4,
                                      ),
                                      // labelStyle: controller.isFocusOnBarcodeField.value ||
                                      //     controller.textFieldList[index].text.isNotEmpty
                                      //     ? TextStyles.kTextH14DarkGreyBold400
                                      //     : TextStyles.kTextH14Grey96Bold400,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: kColorWhite,
                                            width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: kColorWhite,
                                            width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      // hintStyle: TextStyles.kTextH14Grey96Bold400,
                                      // hintText: kLabelBarcode,
                                      focusColor: kColorPrimary,
                                    ),
                                  ),
                                );
                              }),
                            ),

                            /// minus button
                            GestureDetector(
                              onTap: () {
                                controller.plus(index: index);
                              },
                              child: Container(
                                height: 28,
                                width: 28,
                                decoration: const BoxDecoration(
                                  color: kColorPrimary,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(4),
                                    bottomRight: Radius.circular(4),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    '+',
                                    style:
                                    TextStyles.kTextH18WhiteBold500,
                                  ),
                                ),
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
          },
        ),
      );
    });
  }

  Widget finalAmountContainer() {
    return Container(
      margin: const EdgeInsets.only(left: 22, right: 22, top: 9),
      child: Column(
        children: [

          /// total price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                kLabelTotal,
                style: TextStyles.kTextH14DarkGreyBold400,
              ),
              Container(
                width: Get.width * 0.5,
                padding: const EdgeInsets.only(left: 12, top: 2, bottom: 2),
                decoration: BoxDecoration(
                  color: kColorGreyF1F1F1,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Obx(() {
                  return RichText(
                    text: TextSpan(children: [
                      const TextSpan(
                        text: kRupee,
                        style: TextStyles.kTextH16DarkGrey400,
                      ),
                      TextSpan(
                        // text: (controller.viewInvoiceData.value.totalAmount??0.0).toStringAsFixed(2),
                        text: controller.invoiceTotal.value,
                        style: TextStyles.kTextH16DarkGrey600,
                      ),
                    ]),
                  );
                }),
              ),
            ],
          ),

          /// discount price
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  kLabelDiscount,
                  style: TextStyles.kTextH14DarkGreyBold400,
                ),
                Row(
                  children: [

                    /// discount in amount
                    Container(
                      width: Get.width * 0.26,
                      height: 28,
                      padding: const EdgeInsets.only(top: 10, bottom: 0),
                      decoration: BoxDecoration(
                        color: kColorGreyF1F1F1,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Focus(
                        onFocusChange: (value) {
                          controller.onDiscountInAmountValueChange(
                              isOnChange: false);
                        },
                        child: TextFormField(
                          controller: controller.discountInAmountTextField,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (String value) {
                            controller.onDiscountInAmountValueChange();
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegexData.digitAndPointRegex),
                          ],
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          style: TextStyles.kTextH16DarkGrey600,
                          enableSuggestions: false,
                          autocorrect: false,
                          obscureText: false,
                          decoration: const InputDecoration(
                            prefixText: kRupee,
                            prefixStyle: TextStyles.kTextH14DarkGreyBold400,
                            counterText: '',
                            fillColor: kColorGreyF1F1F1,
                            filled: true,
                            contentPadding: EdgeInsets.only(
                                left: 12.0, bottom: 10, top: 11),
                            // labelStyle: controller.isFocusOnBarcodeField.value ||
                            //         controller.barCodeController.text.isNotEmpty
                            //     ? TextStyles.kTextH14DarkGreyBold400
                            //     : TextStyles.kTextH14Grey96Bold400,
                            border: InputBorder.none,
                            focusColor: kColorPrimary,
                          ),
                        ),
                      ),
                    ),

                    /// discount in percentage
                    Container(
                      width: Get.width * 0.23,
                      height: 28,
                      padding:
                      const EdgeInsets.only(left: 12, top: 10, bottom: 0),
                      margin: const EdgeInsets.only(left: 6),
                      decoration: BoxDecoration(
                        color: kColorGreyF1F1F1,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Focus(
                        onFocusChange: (value) {
                          controller.onDiscountInPercentageValueChange(
                              isOnChange: false);
                        },
                        child: TextFormField(
                          controller: controller.discountInPercentageTextField,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (String value) {
                            controller.onDiscountInPercentageValueChange();
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegexData.digitAndPointRegex),
                          ],
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          style: TextStyles.kTextH16DarkGrey600,
                          enableSuggestions: false,
                          autocorrect: false,
                          obscureText: false,
                          decoration: const InputDecoration(
                            suffixText: kPercentage,
                            suffixStyle: TextStyles.kTextH14DarkGreyBold400,
                            counterText: '',
                            fillColor: kColorGreyF1F1F1,
                            filled: true,
                            contentPadding: EdgeInsets.only(
                                right: 12.0, bottom: 10, top: 11),
                            // labelStyle: controller.isFocusOnBarcodeField.value ||
                            //         controller.barCodeController.text.isNotEmpty
                            //     ? TextStyles.kTextH14DarkGreyBold400
                            //     : TextStyles.kTextH14Grey96Bold400,
                            border: InputBorder.none,
                            focusColor: kColorPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// additional price
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  kLabelAdditionalCharge,
                  style: TextStyles.kTextH14DarkGreyBold400,
                ),
                Container(
                  width: Get.width * 0.5,
                  height: 28,
                  padding: const EdgeInsets.only(left: 0, top: 10, bottom: 0),
                  decoration: BoxDecoration(
                    color: kColorGreyF1F1F1,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Focus(
                    onFocusChange: (value) {
                      controller.onAdditionalChargeValueChange(
                          isOnChange: false);
                    },
                    child: TextFormField(
                      controller: controller.additionalChargeTextField,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (String value) {
                        controller.onAdditionalChargeValueChange();
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegexData.digitAndPointRegex),
                      ],
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      style: TextStyles.kTextH16DarkGrey600,
                      enableSuggestions: false,
                      autocorrect: false,
                      obscureText: false,
                      decoration: const InputDecoration(
                        prefixText: kRupee,
                        prefixStyle: TextStyles.kTextH14DarkGreyBold400,
                        counterText: '',
                        fillColor: kColorGreyF1F1F1,
                        filled: true,
                        contentPadding:
                        EdgeInsets.only(left: 12.0, bottom: 10, top: 11),
                        // labelStyle: controller.isFocusOnBarcodeField.value ||
                        //         controller.barCodeController.text.isNotEmpty
                        //     ? TextStyles.kTextH14DarkGreyBold400
                        //     : TextStyles.kTextH14Grey96Bold400,
                        border: InputBorder.none,
                        focusColor: kColorPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// payable price
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  kLabelPayableAmount,
                  style: TextStyles.kTextH14DarkGreyBold400,
                ),
                Container(
                  width: Get.width * 0.5,
                  padding: const EdgeInsets.only(left: 12, top: 2, bottom: 2),
                  decoration: BoxDecoration(
                    color: kColorGreyF1F1F1,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Obx(() {
                    return RichText(
                      text: TextSpan(children: [
                        const TextSpan(
                          text: kRupee,
                          style: TextStyles.kTextH16DarkGrey400,
                        ),
                        TextSpan(
                          text: controller.invoicePayable.value,
                          // (controller.viewInvoiceData.value.payableAmount ??
                          //         0.0)
                          //     .toStringAsFixed(2),
                          style: TextStyles.kTextH16DarkGrey600,
                        ),
                      ]),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget cancelAndConfirmButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 40,
            width: Get.width * 0.42,
            decoration: BoxDecoration(
                border: Border.all(
                  color: kColorLightGrey,
                ),
                color: kColorLightGrey,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: MaterialButton(
              onPressed: () {
                FocusScope.of(Get.overlayContext!).unfocus();
                Get.back(result: false);
              },
              child: Center(
                  child: Text(
                    kLabelCancel,
                    style: TextStyles.kTextH18WhiteBold500
                        .copyWith(color: kColorWhite),
                  )),
            ),
          ),
          Container(
            height: 40,
            width: Get.width * 0.42,
            decoration: BoxDecoration(
                border: Border.all(
                  color: kColorPrimary,
                ),
                color: kColorPrimary,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: MaterialButton(
              onPressed: () {
                FocusScope.of(Get.overlayContext!).unfocus();
                controller.checkValidationsAndApiCall();
              },
              child: Center(
                  child: Text(
                    kLabelConfirm,
                    style: TextStyles.kTextH18WhiteBold500
                        .copyWith(color: kColorWhite),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  void showDeleteDialog({required TransactionsResponseModel transData}) {
    // showDialog(
    //   context: Get.overlayContext!,
    //   builder: (context) {
    //     return
    showConfirmDialogBox(
      title: '',
      type: kLabelWarning,
      message:
      '$kAreYouSureToCancel #${kLabelInvoiceNo}${transData.invoiceNo} ?',
      negativeButtonTitle: kLabelNo,
      negativeClicked: () {
        Get.back();
      },
      positiveButtonTitle: kLabelYes,
      positiveClicked: () {
        Get.back();
        controller.cancelInvoice(
          invoiceId: transData.id.toString(),
        );
      },
    );
    //   },
    // );
  }

  Future<void> openBarCodeScanner() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#202A43', kLabelCancel, true, ScanMode.BARCODE);
      controller.productNameValue.value = barcodeScanRes;
      controller.onBarCodeValueChange();
    } catch (e) {
      LoggerUtils.logException('openBarCodeScanner', e);
    }
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

  emptyTransWidget() {
    return SvgPicture.asset(kImgInvoiceEmptyGraphic);
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
                    children: filterChips(),
                  ),
                  const Text(kLabelSortByPaymentStatus,
                      style: TextStyles.kTextH16Primary600),
                  Wrap(
                    spacing: 8,
                    children: statusFilterChips(),
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
    for (int i = 0; i < controller.transFiltersList.length; i++) {
      Widget chips = Obx(() {
        return FilterChip(
          selectedColor: kColorPrimary,
          showCheckmark: false,
          selected: controller.transFiltersList[i].isSelected,
          elevation: 0.4,
          backgroundColor: kColorWhite,
          shadowColor: kColorDarkGreyAFAFAF,
          label: Text(controller.transFiltersList[i].filterName,
              style: controller.transFiltersList[i].isSelected == true
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

  List<Widget> statusFilterChips() {
    List<Widget> widgets = [];
    for (int i = 0; i < controller.transFiltersList2.length; i++) {
      Widget chips = Obx(() {
        return FilterChip(
          selectedColor: kColorPrimary,
          showCheckmark: false,
          selected: controller.transFiltersList2[i].isSelected,
          elevation: 0.4,
          backgroundColor: kColorWhite,
          shadowColor: kColorDarkGreyAFAFAF,
          label: Text(controller.transFiltersList2[i].filterName,
              style: controller.transFiltersList2[i].isSelected == true
                  ? TextStyles.kTextH14WhiteBold400
                  : TextStyles.kTextH14DarkGreyBold400),
          onSelected: (value) {
            controller.updateTransStatusFilterStatus(i: i);
          },
        );
      });
      widgets.add(chips);
    }
    return widgets;
  }
}
