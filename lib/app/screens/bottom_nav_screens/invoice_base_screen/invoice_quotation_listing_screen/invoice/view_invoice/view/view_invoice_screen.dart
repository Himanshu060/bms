import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/image_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/view_invoice/controller/view_invoice_controller.dart';
import 'package:bms/app/utils/calculate_price/calculations.dart';
import 'package:bms/app/utils/date_format/convert_date_time_to_formatted_date_time.dart';
import 'package:bms/app/utils/return_string_as_fixed_value.dart';
import 'package:bms/app/utils/text_styles.dart';
import 'package:bms/app/widgets/appBar/app_bar_with_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ViewInvoiceScreen extends GetView<ViewInvoiceController> {
  ViewInvoiceScreen({Key? key}) : super(key: key) {
    final intentData = Get.arguments;
    controller.setIntentData(intentData: intentData);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(),
            elevation: 0,
            titleSpacing: 0,
            automaticallyImplyLeading: true,
            backgroundColor: Colors.transparent,
            title: Padding(
              padding: EdgeInsets.only(left: 0),
              // padding: EdgeInsets.only(left: isShowLeadingIcon??false?33.5:0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: Get.width * 0.6,
                    child: Text(
                      controller.customerData.value.name ?? '',
                      style: TextStyles.kTextH18DarkGreyBold700,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      '${controller.customerData.value.mobileNo ?? 0}',
                      style: TextStyles.kTextH14Grey8DShade400,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  // AppBarWithBackButton(title: title, isShowLeadingIcon: isShowLeadingIcon)
                ],
              ),
            ),
            leading: IconButton(
              // icon: const Icon(Icons.arrow_back_ios),
              icon: SvgPicture.asset(
                kIconBack,
                semanticsLabel: kBackIconDescription,
                color: kColorPrimary,
                // color: kColorPrimary,
              ),
              onPressed: () {
                Get.back(result: false);
              },
            )),
        body: Column(
          children: [
            itemAndDateContainer(),
            itemsListView(),
            Spacer(),
            summaryContainer(),
          ],
        ),
      );
    });
  }

  Widget itemAndDateContainer() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                kIconProductServiceTabOff,
                color: kColorBlue1294FF,
                height: 14,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  '${controller.itemsList.length}-Items',
                  style: TextStyles.kTextH14Blue1294FF,
                ),
              ),
            ],
          ),
          Row(
            children: [
              SvgPicture.asset(
                kIconCalendar,
                color: kColorBlue1294FF,
                height: 14,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  returnConvertedDateTimerFormat(
                      createdOnDate:
                          controller.viewInvoiceData.value.createdOn ?? ''),
                  style: TextStyles.kTextH14Blue1294FF,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget itemsListView() {
    return Obx(() {
      return Container(
        height: Get.height * 0.55,
        margin: EdgeInsets.only(top: 16),
        child: ListView.builder(
          itemCount: controller.itemsList.length,
          itemBuilder: (context, index) {
            var itemData = controller.itemsList[index];
            return Container(
              padding: EdgeInsets.only(left: 11, right: 11, top: 9, bottom: 9),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(color: kColorLightGrey),
              ),
              child: Column(
                children: [
                  /// item name and category name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        itemData.name ?? '',
                        style: TextStyles.kTextH14DarkGrey3535Bold600,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: kColorGreyD8,
                          ),
                        ),
                        child: Text(
                          itemData.isProduct == true
                              ? kLabelProduct
                              : kLabelService,
                          style: TextStyles.kTextH12Grey8DBold500,
                        ),
                      ),
                    ],
                  ),

                  /// selling price and qty
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              kLabelPriceWithColon,
                              style: TextStyles.kTextH12Grey8DBold500,
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        ' $kRupee ${controller.returnFormattedAmount(values: returnToStringAsFixed(value: (itemData.sellingPrice ?? 0.0)))}',
                                    style: TextStyles.kTextH12DarkGreyBold600,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: kLabelQtyWithColon,
                                style: TextStyles.kTextH12Grey8DBold500,
                              ),
                              TextSpan(
                                text: returnToStringAsFixed(
                                    value: (itemData.qty ?? 0.0)),
                                style: TextStyles.kTextH12DarkGreyBold500,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// total price and gst
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              kLabelTotalWithColon,
                              style: TextStyles.kTextH12Grey8DBold500,
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        '$kRupee ${controller.returnFormattedAmount(values:controller.returnItemTotalValues(itemData: itemData))}',
                                    style: TextStyles.kTextH12DarkGreyBold600,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: kLabelGSTWithColon,
                                style: TextStyles.kTextH12Grey8DBold500,
                              ),
                              TextSpan(
                                text: controller.returnGstRate(
                                    itemData: itemData),
                                style: TextStyles.kTextH12DarkGreyBold500,
                              ),
                            ],
                          ),
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

  Widget summaryContainer() {
    return Container(
      margin: EdgeInsets.all(22),
      child: Column(
        children: [
          /// total and payable price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: Get.width * 0.4,
                height: 34,
                // padding: EdgeInsets.only(left: 12, top: 2, bottom: 2),
                // decoration: BoxDecoration(
                //   color: kColorGreyF1F1F1,
                //   borderRadius: BorderRadius.circular(4),
                // ),
                child: TextFormField(
                  enabled: false,
                  controller: controller.totalController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  style: TextStyles.kTextH16DarkGrey600,
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: false,
                  decoration: const InputDecoration(
                    labelText: kLabelTotal,
                    labelStyle: TextStyles.kTextH14Grey96Bold400,
                    prefixText: kRupee,
                    prefixStyle: TextStyles.kTextH14DarkGreyBold400,
                    counterText: '',
                    fillColor: kColorGreyF1F1F1,
                    filled: false,
                    contentPadding:
                        EdgeInsets.only(left: 12.0, bottom: 10, top: 10),
                    border: InputBorder.none,
                    focusColor: kColorPrimary,
                    disabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kColorLightGrey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
                // RichText(
                //   text: TextSpan(children: [
                //     TextSpan(
                //       text: kRupee,
                //       style: TextStyles.kTextH16DarkGrey400,
                //     ),
                //     TextSpan(
                //       text: controller.returnFormattedAmount(values: returnToStringAsFixed(
                //           value:
                //           (controller.viewInvoiceData.value.totalAmount ??
                //               0.0))),
                //       style: TextStyles.kTextH16DarkGrey600,
                //     ),
                //   ]),
                // ),
              ),
              Container(
                width: Get.width * 0.4,
                height: 34,
                // padding: EdgeInsets.only(left: 12, top: 2, bottom: 2),
                // decoration: BoxDecoration(
                //   color: kColorGreyF1F1F1,
                //   borderRadius: BorderRadius.circular(4),
                // ),
                child: TextFormField(
                  enabled: false,
                  controller: controller.payableAmountController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  style: TextStyles.kTextH16DarkGrey600,
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: false,
                  decoration: const InputDecoration(
                    labelText: kLabelPayableAmount,
                    labelStyle: TextStyles.kTextH14Grey96Bold400,
                    prefixText: kRupee,
                    prefixStyle: TextStyles.kTextH14DarkGreyBold400,
                    counterText: '',
                    fillColor: kColorGreyF1F1F1,
                    filled: false,
                    contentPadding:
                        EdgeInsets.only(left: 12.0, bottom: 10, top: 10),
                    border: InputBorder.none,
                    focusColor: kColorPrimary,
                    disabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kColorLightGrey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
                // RichText(
                //   text: TextSpan(children: [
                //     TextSpan(
                //       text: kRupee,
                //       style: TextStyles.kTextH16DarkGrey400,
                //     ),
                //     TextSpan(
                //       text: controller.returnFormattedAmount(values: returnToStringAsFixed(
                //           value: (controller
                //               .viewInvoiceData.value.payableAmount ??
                //               0.0))),
                //       style: TextStyles.kTextH16DarkGrey600,
                //     ),
                //   ]),
                // ),
              ),
            ],
          ),

          /// discount price
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(
                //   kLabelDiscount,
                //   style: TextStyles.kTextH14DarkGreyBold400,
                // ),
                Container(
                  width: Get.width * 0.4,
                  height: 34,
                  // padding: EdgeInsets.only(left: 12, top: 2, bottom: 2),
                  // decoration: BoxDecoration(
                  //   color: kColorGreyF1F1F1,
                  //   borderRadius: BorderRadius.circular(4),
                  // ),
                  child: TextFormField(
                    enabled: false,
                    controller: controller.discInAmountController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    style: TextStyles.kTextH16DarkGrey600,
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: false,
                    decoration: const InputDecoration(
                      labelText: kLabelDiscountWithSymbol,
                      labelStyle: TextStyles.kTextH14Grey96Bold400,
                      prefixText: kRupee,
                      prefixStyle: TextStyles.kTextH14DarkGreyBold400,
                      counterText: '',
                      fillColor: kColorGreyF1F1F1,
                      filled: false,
                      contentPadding:
                          EdgeInsets.only(left: 12.0, bottom: 10, top: 10),
                      border: InputBorder.none,
                      focusColor: kColorPrimary,
                      disabledBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: kColorLightGrey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                  // RichText(
                  //   text: TextSpan(children: [
                  //     TextSpan(
                  //       text: kRupee,
                  //       style: TextStyles.kTextH16DarkGrey400,
                  //     ),
                  //     TextSpan(
                  //       text:controller.returnFormattedAmount(values:  returnToStringAsFixed(
                  //           value: (controller.viewInvoiceData.value
                  //               .discountAmount ??
                  //               0.0))),
                  //       style: TextStyles.kTextH16DarkGrey600,
                  //     ),
                  //   ]),
                  // ),
                ),

                /// discount in percentage
                Container(
                  width: Get.width * 0.4,
                  height: 34,
                  // padding: EdgeInsets.only(left: 12, top: 2, bottom: 2),
                  // margin: EdgeInsets.only(left: 6),
                  // decoration: BoxDecoration(
                  //   color: kColorGreyF1F1F1,
                  //   borderRadius: BorderRadius.circular(4),
                  // ),
                  child: TextFormField(
                    enabled: false,
                    controller: controller.discInPercentageController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    style: TextStyles.kTextH16DarkGrey600,
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: false,
                    decoration: const InputDecoration(
                      labelText: kLabelDiscountWithPercentage,
                      labelStyle: TextStyles.kTextH14Grey96Bold400,
                      prefixText: '%',
                      prefixStyle: TextStyles.kTextH14DarkGreyBold400,
                      counterText: '',
                      fillColor: kColorGreyF1F1F1,
                      filled: false,
                      contentPadding:
                          EdgeInsets.only(left: 12.0, bottom: 10, top: 10),
                      border: InputBorder.none,
                      focusColor: kColorPrimary,
                      disabledBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: kColorLightGrey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                  // RichText(
                  //   text: TextSpan(children: [
                  //     TextSpan(
                  //       text: returnToStringAsFixed(
                  //           value: (controller.viewInvoiceData.value
                  //                   .discountPercentage ??
                  //               0.0)),
                  //       style: TextStyles.kTextH16DarkGrey600,
                  //     ),
                  //     TextSpan(
                  //       text: '%',
                  //       style: TextStyles.kTextH16DarkGrey400,
                  //     ),
                  //   ]),
                  // ),
                ),
              ],
            ),
          ),

          /// additional and received price
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: Get.width * 0.4,
                  height: 34,
                  // padding: EdgeInsets.only(left: 12, top: 2, bottom: 2),
                  // decoration: BoxDecoration(
                  //   color: kColorGreyF1F1F1,
                  //   borderRadius: BorderRadius.circular(4),
                  // ),
                  child: TextFormField(
                    enabled: false,
                    controller: controller.additionalChargesController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    style: TextStyles.kTextH16DarkGrey600,
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: false,
                    decoration: const InputDecoration(
                      labelText: kLabelAdditionalCharge,
                      labelStyle: TextStyles.kTextH14Grey96Bold400,
                      prefixText: kRupee,
                      prefixStyle: TextStyles.kTextH14DarkGreyBold400,
                      counterText: '',
                      fillColor: kColorGreyF1F1F1,
                      filled: false,
                      contentPadding:
                          EdgeInsets.only(left: 12.0, bottom: 10, top: 10),
                      border: InputBorder.none,
                      focusColor: kColorPrimary,
                      disabledBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: kColorLightGrey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                  // RichText(
                  //   text: TextSpan(children: [
                  //     TextSpan(
                  //       text: kRupee,
                  //       style: TextStyles.kTextH16DarkGrey400,
                  //     ),
                  //     TextSpan(
                  //       text: controller.returnFormattedAmount(values: returnToStringAsFixed(
                  //           value: (controller
                  //               .viewInvoiceData.value.additionalCharge ??
                  //               0.0))),
                  //       style: TextStyles.kTextH16DarkGrey600,
                  //     ),
                  //   ]),
                  // ),
                ),
                Container(
                  width: Get.width * 0.4,
                  height: 34,
                  // padding: EdgeInsets.only(left: 12, top: 2, bottom: 2),
                  // decoration: BoxDecoration(
                  //   color: kColorGreyF1F1F1,
                  //   borderRadius: BorderRadius.circular(4),
                  // ),
                  child: TextFormField(
                    enabled: false,
                    controller: controller.receivedAmountController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    style: TextStyles.kTextH16DarkGrey600,
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: false,
                    decoration: const InputDecoration(
                      labelText: kLabelReceivedAmount,
                      labelStyle: TextStyles.kTextH14Grey96Bold400,
                      prefixText: kRupee,
                      prefixStyle: TextStyles.kTextH14DarkGreyBold400,
                      counterText: '',
                      fillColor: kColorGreyF1F1F1,
                      filled: false,
                      contentPadding:
                          EdgeInsets.only(left: 12.0, bottom: 10, top: 10),
                      border: InputBorder.none,
                      focusColor: kColorPrimary,
                      disabledBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: kColorLightGrey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // /// payable price
          // Padding(
          //   padding: EdgeInsets.only(top: 6),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         kLabelPayableAmount,
          //         style: TextStyles.kTextH14DarkGreyBold400,
          //       ),
          //       Container(
          //         width: Get.width * 0.5,
          //         padding: EdgeInsets.only(left: 12, top: 2, bottom: 2),
          //         decoration: BoxDecoration(
          //           color: kColorGreyF1F1F1,
          //           borderRadius: BorderRadius.circular(4),
          //         ),
          //         child: RichText(
          //           text: TextSpan(children: [
          //             TextSpan(
          //               text: kRupee,
          //               style: TextStyles.kTextH16DarkGrey400,
          //             ),
          //             TextSpan(
          //               text: controller.returnFormattedAmount(values: returnToStringAsFixed(
          //                   value: (controller
          //                       .viewInvoiceData.value.payableAmount ??
          //                       0.0))),
          //               style: TextStyles.kTextH16DarkGrey600,
          //             ),
          //           ]),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          // /// received price
          // Padding(
          //   padding: EdgeInsets.only(top: 6),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //
          //       Container(
          //         width: Get.width * 0.5,
          //         padding: EdgeInsets.only(left: 12, top: 2, bottom: 2),
          //         decoration: BoxDecoration(
          //           color: kColorGreyF1F1F1,
          //           borderRadius: BorderRadius.circular(4),
          //         ),
          //         child: RichText(
          //           text: TextSpan(children: [
          //             TextSpan(
          //               text: kRupee,
          //               style: TextStyles.kTextH16DarkGrey400,
          //             ),
          //             TextSpan(
          //               text: controller.returnFormattedAmount(values: returnToStringAsFixed(
          //                   value: (controller.viewInvoiceData.value
          //                       .totalReceivedAmount ??
          //                       0.0))),
          //               style: TextStyles.kTextH16DarkGrey600,
          //             ),
          //           ]),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
