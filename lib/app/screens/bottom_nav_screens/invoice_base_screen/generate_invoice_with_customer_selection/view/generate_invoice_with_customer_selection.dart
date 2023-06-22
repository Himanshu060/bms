import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/image_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/generate_invoice_with_customer_selection/controller/generate_invoice_with_customer_selection_controller.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:bms/app/utils/number_formatter/number_formatter.dart';
import 'package:bms/app/utils/regex.dart';
import 'package:bms/app/utils/return_string_as_fixed_value.dart';
import 'package:bms/app/utils/text_styles.dart';
import 'package:bms/app/widgets/appBar/app_bar_with_back_button.dart';
import 'package:bms/app/widgets/buttons/primary_button.dart';
import 'package:bms/app/widgets/dialogs/show_confirm_dialog_widget.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class GenerateInvoiceWithCustomerSelection
    extends GetView<GenerateInvoiceWithCustomerSelectionController> {
  GenerateInvoiceWithCustomerSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.selectedItemsList.isNotEmpty) {
          showWarningDialogBox();
        } else {
          Get.back(result: false);
        }
        return false;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(),
              elevation: 0,
              titleSpacing: 0,
              automaticallyImplyLeading: true,
              backgroundColor: Colors.transparent,
              title: Text(
                kLabelGenerateInvoice.toUpperCase(),
                style: TextStyles.kTextH18DarkGreyBold700,
                textAlign: TextAlign.start,
              ),
              leading: IconButton(
                icon: SvgPicture.asset(
                  kIconBack,
                  semanticsLabel: kBackIconDescription,
                  color: kColorPrimary,
                ),
                onPressed: () {
                  if (controller.selectedItemsList.isNotEmpty) {
                    showWarningDialogBox();
                  } else {
                    Get.back(result: false);
                  }
                },
              )),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // invoiceQuotationCashSaleTabBar(),
                // Stack(
                //   children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: SizedBox(
                        height: Get.height*0.89,
                        child: Column(
                          children: [
                            selectCustomerOrAddNewUI(),
                            // selectCustomerOrAdd(),
                            // customerInfoContainer(),
                            productAndBarcodeContainer(),
                            itemsListView(),
                            finalAmountContainer(),
                            const Spacer(),
                            cancelAndConfirmButtons(),
                          ],
                        ),
                      ),
                    ),

                    // /// item search dropdown container
                    // Obx(
                    //   () {
                    //     return Visibility(
                    //       visible: controller.isFocusOnProductNameField.value
                    //       // ||
                    //       // controller.isFocusOnBarcodeField.value
                    //       ,
                    //       child: Positioned.fill(
                    //         top: Get.height * 0.19,
                    //         child: Obx(
                    //           () {
                    //             return Column(
                    //               children: [
                    //                 Container(
                    //                   height: Get.height * 0.28,
                    //                   margin: const EdgeInsets.symmetric(
                    //                       horizontal: 20),
                    //                   decoration: BoxDecoration(
                    //                     color: kColorWhite,
                    //                     borderRadius: BorderRadius.circular(10),
                    //                   ),
                    //                   child: ListView.builder(
                    //                     // itemCount: controller.itemsList.length,
                    //                     itemCount: controller
                    //                             .productNameValue.value.isNotEmpty
                    //                         ? controller.searchItemsList.length
                    //                         : controller.itemsList.length,
                    //                     itemBuilder: (context, index) {
                    //                       var itemData = controller
                    //                               .productNameValue
                    //                               .value
                    //                               .isNotEmpty
                    //                           ? controller.searchItemsList[index]
                    //                           : controller.itemsList[index];
                    //                       return Visibility(
                    //                         visible:
                    //                             itemData.isAddedToList == false,
                    //                         child: Container(
                    //                           margin: EdgeInsets.symmetric(
                    //                               vertical: 1),
                    //                           padding: EdgeInsets.only(
                    //                               top: 4, left: 8, bottom: 4),
                    //                           decoration: BoxDecoration(
                    //                             color: itemData.isSelected == true
                    //                                 ? kColorPrimary
                    //                                 : kColorWhite,
                    //                             borderRadius:
                    //                                 BorderRadius.circular(10),
                    //                           ),
                    //                           child: ListTile(
                    //                             onTap: () {
                    //                               var value = controller
                    //                                       .productNameValue
                    //                                       .value
                    //                                       .isNotEmpty
                    //                                   ? controller
                    //                                           .searchItemsList[
                    //                                               index]
                    //                                           .isSelected ??
                    //                                       false
                    //                                   : controller
                    //                                           .itemsList[index]
                    //                                           .isSelected ??
                    //                                       false;
                    //
                    //                               if (controller.productNameValue
                    //                                   .isNotEmpty) {
                    //                                 controller
                    //                                     .updateSelectedTileValues(
                    //                                         isSelected: value,
                    //                                         itemData: controller
                    //                                                 .searchItemsList[
                    //                                             index]);
                    //                               } else {
                    //                                 controller
                    //                                     .updateSelectedTileValues(
                    //                                         isSelected: value,
                    //                                         itemData: controller
                    //                                                 .itemsList[
                    //                                             index]);
                    //                               }
                    //                             },
                    //                             dense: true,
                    //                             visualDensity:
                    //                                 const VisualDensity(
                    //                                     horizontal: 0,
                    //                                     vertical: 0),
                    //                             contentPadding:
                    //                                 const EdgeInsets.symmetric(
                    //                                     horizontal: 0.0,
                    //                                     vertical: 0.0),
                    //                             title: Column(
                    //                               crossAxisAlignment:
                    //                                   CrossAxisAlignment.start,
                    //                               children: [
                    //                                 Text(
                    //                                   itemData.name ?? '',
                    //                                   style: itemData
                    //                                               .isSelected ==
                    //                                           true
                    //                                       ? TextStyles
                    //                                           .kTextH14WhiteBold400
                    //                                       : TextStyles
                    //                                           .kTextH14DarkGreyBold400,
                    //                                 ),
                    //
                    //                                 /// price and units
                    //                                 Row(
                    //                                   children: [
                    //                                     RichText(
                    //                                       text:
                    //                                           TextSpan(children: [
                    //                                         TextSpan(
                    //                                           text: kRupee,
                    //                                           style: itemData
                    //                                                       .isSelected ==
                    //                                                   true
                    //                                               ? TextStyles
                    //                                                   .kTextH14WhiteBold400
                    //                                               : TextStyles
                    //                                                   .kTextH14DarkGreyBold400,
                    //                                         ),
                    //                                         TextSpan(
                    //                                           text: returnToStringAsFixed(
                    //                                               value: itemData
                    //                                                       .itemTotal ??
                    //                                                   0.0),
                    //                                           style: itemData
                    //                                                       .isSelected ==
                    //                                                   true
                    //                                               ? TextStyles
                    //                                                   .kTextH14WhiteBold600
                    //                                               : TextStyles
                    //                                                   .kTextH14DarkGreyBold600,
                    //                                         ),
                    //                                       ]),
                    //                                     ),
                    //                                     Padding(
                    //                                       padding:
                    //                                           const EdgeInsets
                    //                                               .only(left: 6),
                    //                                       child: Text(
                    //                                         '/${controller.returnUnitName(index: index)}',
                    //                                         style: itemData
                    //                                                     .isSelected ==
                    //                                                 true
                    //                                             ? TextStyles
                    //                                                 .kTextH14WhiteBold400
                    //                                             : TextStyles
                    //                                                 .kTextH14DarkGreyBold400,
                    //                                       ),
                    //                                     ),
                    //                                   ],
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       );
                    //                     },
                    //                   ),
                    //                 ),
                    //                 MaterialButton(
                    //                   onPressed: () {
                    //                     FocusScope.of(context).unfocus();
                    //                     controller.addToList();
                    //                   },
                    //                   child: Container(
                    //                     width: Get.width,
                    //                     height: 55,
                    //                     decoration: BoxDecoration(
                    //                       border: Border.all(
                    //                         color: kColorWhite,
                    //                       ),
                    //                       color: kColorPrimary,
                    //                       borderRadius: const BorderRadius.only(
                    //                         bottomLeft: Radius.circular(10),
                    //                         bottomRight: Radius.circular(10),
                    //                       ),
                    //                     ),
                    //                     child: const Center(
                    //                       child: Text(
                    //                         kLabelAddToList,
                    //                         style: TextStyles.kTextH16White600,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             );
                    //           },
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),

                    /// customer search dropdown container
                    // Obx(
                    //   () {
                    //     return Visibility(
                    //       visible: controller.isFocusOnCustomerNameField.value,
                    //       // visible: controller.isFocusOnCustomerNameField.value,
                    //       child: Positioned.fill(
                    //         top: Get.height * 0.07,
                    //         child: Obx(
                    //           () {
                    //             return Column(
                    //               children: [
                    //                 Container(
                    //                   height: Get.height * 0.24,
                    //                   margin: const EdgeInsets.symmetric(
                    //                       horizontal: 20),
                    //                   decoration: BoxDecoration(
                    //                     color: kColorWhite,
                    //                     borderRadius: BorderRadius.circular(10),
                    //                   ),
                    //                   child: ListView.builder(
                    //                     shrinkWrap: true,
                    //                     // itemCount: controller.itemsList.length,
                    //                     itemCount: controller.customerNameValue
                    //                             .value.isNotEmpty
                    //                         ? controller.searchCustomerList.length
                    //                         : controller.customerDataList.length,
                    //                     itemBuilder: (context, index) {
                    //                       var itemData = controller
                    //                               .customerNameValue
                    //                               .value
                    //                               .isNotEmpty
                    //                           ? controller
                    //                               .searchCustomerList[index]
                    //                           : controller
                    //                               .customerDataList[index];
                    //                       return Container(
                    //                         margin: const EdgeInsets.symmetric(
                    //                             vertical: 1),
                    //                         padding: const EdgeInsets.only(
                    //                             top: 4, left: 8, bottom: 4),
                    //                         decoration: BoxDecoration(
                    //                           color: itemData.isSelected == true
                    //                               ? kColorPrimary
                    //                               : kColorWhite,
                    //                           borderRadius:
                    //                               BorderRadius.circular(10),
                    //                         ),
                    //                         child: ListTile(
                    //                           onTap: () {
                    //                             var value = controller
                    //                                     .customerNameValue
                    //                                     .value
                    //                                     .isNotEmpty
                    //                                 ? controller
                    //                                         .searchCustomerList[
                    //                                             index]
                    //                                         .isSelected ??
                    //                                     false
                    //                                 : controller
                    //                                         .customerDataList[
                    //                                             index]
                    //                                         .isSelected ??
                    //                                     false;
                    //
                    //                             if (controller.customerNameValue
                    //                                 .isNotEmpty) {
                    //                               controller.onCustomerSelection(
                    //                                   isSelected: value,
                    //                                   custData: controller
                    //                                           .searchCustomerList[
                    //                                       index],
                    //                                   index: index);
                    //                             } else {
                    //                               controller.onCustomerSelection(
                    //                                   isSelected: value,
                    //                                   custData: controller
                    //                                           .customerDataList[
                    //                                       index],
                    //                                   index: index);
                    //                             }
                    //                           },
                    //                           dense: true,
                    //                           visualDensity: const VisualDensity(
                    //                               horizontal: 0, vertical: 0),
                    //                           contentPadding:
                    //                               const EdgeInsets.symmetric(
                    //                                   horizontal: 0.0,
                    //                                   vertical: 0.0),
                    //                           title: Column(
                    //                             crossAxisAlignment:
                    //                                 CrossAxisAlignment.start,
                    //                             children: [
                    //                               Text(
                    //                                 itemData.name ?? '',
                    //                                 style: itemData.isSelected ==
                    //                                         true
                    //                                     ? TextStyles
                    //                                         .kTextH14WhiteBold400
                    //                                     : TextStyles
                    //                                         .kTextH14DarkGreyBold400,
                    //                               ),
                    //
                    //                               /// price and units
                    //                               // Row(
                    //                               //   children: [
                    //                               //     RichText(
                    //                               //       text:
                    //                               //           TextSpan(children: [
                    //                               //         TextSpan(
                    //                               //           text: kRupee,
                    //                               //           style: itemData
                    //                               //                       .isSelected ==
                    //                               //                   true
                    //                               //               ? TextStyles
                    //                               //                   .kTextH14WhiteBold400
                    //                               //               : TextStyles
                    //                               //                   .kTextH14DarkGreyBold400,
                    //                               //         ),
                    //                               //         TextSpan(
                    //                               //           text: returnToStringAsFixed(
                    //                               //               value: itemData
                    //                               //                       .itemTotal ??
                    //                               //                   0.0),
                    //                               //           style: itemData
                    //                               //                       .isSelected ==
                    //                               //                   true
                    //                               //               ? TextStyles
                    //                               //                   .kTextH14WhiteBold600
                    //                               //               : TextStyles
                    //                               //                   .kTextH14DarkGreyBold600,
                    //                               //         ),
                    //                               //       ]),
                    //                               //     ),
                    //                               //     Padding(
                    //                               //       padding:
                    //                               //           const EdgeInsets
                    //                               //               .only(left: 6),
                    //                               //       child: Text(
                    //                               //         '/${controller.returnUnitName(index: index)}',
                    //                               //         style: itemData
                    //                               //                     .isSelected ==
                    //                               //                 true
                    //                               //             ? TextStyles
                    //                               //                 .kTextH14WhiteBold400
                    //                               //             : TextStyles
                    //                               //                 .kTextH14DarkGreyBold400,
                    //                               //       ),
                    //                               //     ),
                    //                               //   ],
                    //                               // ),
                    //                             ],
                    //                           ),
                    //                         ),
                    //                       );
                    //                     },
                    //                   ),
                    //                 ),
                    //               ],
                    //             );
                    //           },
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                //   ],
                // )
              ],
            ),
          ),
        ),
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

  /// old select customer view with text-field
  // Widget selectCustomerOrAdd() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 6),
  //     child: Row(
  //       children: [
  //         GestureDetector(
  //             onTap: () {
  //               searchCustomerBottomSheet();
  //             },
  //             child: Focus(
  //               onFocusChange: (hasFocus) {
  //                 controller.changeFocus(hasFocus: hasFocus, fieldNumber: 3);
  //                 // if (controller.customerNameController.text.trim().isNotEmpty) {
  //                 controller.validateUserInput(
  //                     fieldNumber: 1, isOnChange: false);
  //                 // }
  //               },
  //               child: Obx(() {
  //                 return Container(
  //                   margin: const EdgeInsets.only(left: 20, right: 8),
  //                   width: Get.width * 0.77,
  //                   height: 42,
  //                   child: TextFormField(
  //                     enabled: false,
  //                     controller:
  //                         controller.selectedCustomerNameController.value,
  //                     maxLength: 25,
  //                     autovalidateMode: AutovalidateMode.onUserInteraction,
  //                     onChanged: (String value) {
  //                       controller.validateUserInput(fieldNumber: 1);
  //                     },
  //                     keyboardType: TextInputType.name,
  //                     textInputAction: TextInputAction.next,
  //                     style: TextStyles.kTextH14DarkGreyBold400,
  //                     enableSuggestions: false,
  //                     autocorrect: false,
  //                     obscureText: false,
  //                     decoration: InputDecoration(
  //                       labelText: controller.customerData.value.name != null
  //                           ? kLabelCustomersName
  //                           : kLabelSelectCustomer,
  //                       counterText: '',
  //                       fillColor: kColorPurpleF4F7FF,
  //                       filled: true,
  //                       contentPadding: controller.custTextFieldContentPadding,
  //                       labelStyle:
  //                           controller.isFocusOnCustomerNameField.value ||
  //                                   controller
  //                                       .customerNameController.text.isNotEmpty
  //                               ? TextStyles.kTextH14DarkGreyBold400
  //                               : TextStyles.kTextH14GreyBold400,
  //                       focusedBorder: const OutlineInputBorder(
  //                         borderSide:
  //                             BorderSide(color: kColorDarkGrey3535, width: 1.0),
  //                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
  //                       ),
  //                       enabledBorder: const OutlineInputBorder(
  //                         borderSide:
  //                             BorderSide(color: kColorLightGrey, width: 1.0),
  //                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
  //                       ),
  //                       disabledBorder: const OutlineInputBorder(
  //                         borderSide:
  //                             BorderSide(color: kColorLightGrey, width: 1.0),
  //                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
  //                       ),
  //                       hintStyle: TextStyles.kTextH14GreyBold600,
  //                       hintText: kLabelCustomersName,
  //                       focusColor: kColorPrimary,
  //                     ),
  //                   ),
  //                 );
  //               }),
  //             )),
  //         // Container(
  //         //   width: Get.width * 0.77,
  //         //   height: 42,
  //         //   margin: const EdgeInsets.only(left: 20, right: 8),
  //         //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
  //         //   decoration: BoxDecoration(
  //         //     color: kColorPurpleF4F7FF,
  //         //     borderRadius: BorderRadius.circular(10),
  //         //     border: Border.all(color: kColorLightGrey),
  //         //   ),
  //         //   child: const Text(
  //         //     kLabelSelectCustomer,
  //         //     style: TextStyles.kTextH14Grey96Bold400,
  //         //   ),
  //         // ),
  //         // ),
  //         GestureDetector(
  //           onTap: () {
  //             addNewCustomerBottomSheet();
  //           },
  //           child: Container(
  //             height: 42,
  //             width: 42,
  //             decoration: BoxDecoration(
  //               color: kColorPrimary,
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //             child: const Icon(
  //               Icons.add,
  //               color: kColorWhite,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget customerInfoContainer() {
    return Column(
      children: [
        /// customer name
        // Focus(
        //   onFocusChange: (hasFocus) {
        //     controller.changeFocus(hasFocus: hasFocus, fieldNumber: 3);
        //     // if (controller.productNameController.text.trim().isNotEmpty) {
        //     /*controller.validateUserInput(fieldNumber: 1, isOnChange: false);*/
        //     // }
        //   },
        //   child: Obx(
        //     () {
        //       return Container(
        //         width: Get.width,
        //         margin: const EdgeInsets.symmetric(horizontal: 20),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             SizedBox(
        //               height: 42,
        //               child: TextFormField(
        //                 controller: controller.customerNameController,
        //                 maxLength: 50,
        //                 autovalidateMode: AutovalidateMode.onUserInteraction,
        //                 onChanged: (String value) {
        //                   if (value.isEmpty) {
        //                     controller.customerNameValue.value = '';
        //                     controller.searchCustomerList.clear();
        //                   } else {
        //                     controller.customerNameValue.value = value;
        //                     controller.customerNameStr.value = '';
        //                     controller.onCustomerNameValueChange();
        //                   }
        //                 },
        //                 inputFormatters: [
        //                   FilteringTextInputFormatter.allow(
        //                       RegexData.nameRegex),
        //                 ],
        //                 keyboardType: TextInputType.emailAddress,
        //                 textInputAction: TextInputAction.next,
        //                 style: TextStyles.kTextH14DarkGreyBold400,
        //                 enableSuggestions: false,
        //                 autocorrect: false,
        //                 obscureText: false,
        //                 decoration: InputDecoration(
        //                   // labelText: kLabelProducts,
        //                   suffixIcon: Padding(
        //                     padding: const EdgeInsets.only(
        //                         left: 12, right: 9, bottom: 9, top: 9),
        //                     child: controller.isFocusOnCustomerNameField.value
        //                         ? SvgPicture.asset(kIconDropDownUp)
        //                         : SvgPicture.asset(kIconDropDown),
        //                   ),
        //                   counterText: '',
        //                   fillColor: kColorPurpleF4F7FF,
        //                   filled: true,
        //                   contentPadding: const EdgeInsets.only(
        //                       left: 14.0, bottom: 11, top: 11),
        //                   labelStyle:
        //                       controller.isFocusOnCustomerNameField.value ||
        //                               controller.customerNameController.text
        //                                   .isNotEmpty
        //                           ? TextStyles.kTextH14DarkGreyBold400
        //                           : TextStyles.kTextH14Grey96Bold400,
        //                   focusedBorder: const OutlineInputBorder(
        //                     borderSide: BorderSide(
        //                         color: kColorDarkGrey3535, width: 1.0),
        //                     borderRadius:
        //                         BorderRadius.all(Radius.circular(10.0)),
        //                   ),
        //                   enabledBorder: const OutlineInputBorder(
        //                     borderSide:
        //                         BorderSide(color: kColorLightGrey, width: 1.0),
        //                     borderRadius:
        //                         BorderRadius.all(Radius.circular(10.0)),
        //                   ),
        //                   hintStyle: TextStyles.kTextH14Grey96Bold400,
        //                   hintText: kLabelSearchCustomer,
        //                   focusColor: kColorPrimary,
        //                 ),
        //               ),
        //             ),
        //             Obx(() {
        //               return Visibility(
        //                 visible:
        //                     controller.customerNameController.text.isNotEmpty ||
        //                         controller.isValidCustomerName.value == false,
        //                 child: controller.customerNameStr.value == ''
        //                     ? Container()
        //                     : Padding(
        //                         padding:
        //                             const EdgeInsets.only(left: 10, top: 2),
        //                         child: Text(controller.customerNameStr.value,
        //                             style: TextStyles.kTextH12Red)),
        //               );
        //             }),
        //           ],
        //         ),
        //       );
        //     },
        //   ),
        // ),

        /// customer mobile no. and gmail id
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    /// mobile no. text-field
                    customerMobileNoTextField(),

                    /// emailId text-field
                    customerEmailIdTextField(),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    width: Get.width * 0.4,
                    child: Obx(() {
                      return Visibility(
                        visible: controller
                                .customerMobileNoController.text.isNotEmpty ||
                            controller.isValidPhoneNumber.value == false,
                        child: controller.customerMobileStr.value == ''
                            ? Container()
                            : Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 2),
                                child: Text(controller.customerMobileStr.value,
                                    style: TextStyles.kTextH12Red)),
                      );
                    }),
                  ),
                  Container(
                    width: Get.width * 0.4,
                    child: Obx(() {
                      return Visibility(
                        visible: controller
                                .customerEmailIdController.text.isNotEmpty ||
                            controller.isValidEmailId.value == false,
                        child: controller.customerEmailStr.value == ''
                            ? Container()
                            : Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 2),
                                child: Text(controller.customerEmailStr.value,
                                    style: TextStyles.kTextH12Red)),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
          // Visibility(
          //   visible:true,
          //   // visible: controller.customerData.value.emailId!=null,
          //   child: Row(
          //     children: [
          //       Container(
          //         height: 40,
          //         width: Get.width * 0.35,
          //         padding:
          //         const EdgeInsets.only(left: 14, top: 10, bottom: 10),
          //         decoration: BoxDecoration(
          //           color: kColorPurpleF4F7FF,
          //           borderRadius: BorderRadius.circular(10),
          //           border: Border.all(color: kColorLightGrey),
          //         ),
          //         child: Text(
          //           (controller.customerData.value.mobileNo ?? 'mobile no.').toString(),
          //           style: TextStyles.kTextH14DarkGreyBold400,
          //         ),
          //       ),
          //       Container(
          //         height: 40,
          //         width: Get.width * 0.53,
          //         padding:
          //         const EdgeInsets.only(left: 14, top: 10, bottom: 10),
          //         margin: const EdgeInsets.only(left: 6),
          //         decoration: BoxDecoration(
          //           color: kColorPurpleF4F7FF,
          //           borderRadius: BorderRadius.circular(10),
          //           border: Border.all(color: kColorLightGrey),
          //         ),
          //         child: Text(
          //           controller.customerData.value.emailId ?? 'email-Id',
          //           style: TextStyles.kTextH14DarkGreyBold400,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        )
      ],
    );
  }

  Widget customerMobileNoTextField() {
    return Focus(
      onFocusChange: (hasFocus) {
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 4);
        controller.validateUserInput(fieldNumber: 1, isOnChange: false);
        // if (controller.productNameController.text.trim().isNotEmpty) {
        /*controller.validateUserInput(fieldNumber: 1, isOnChange: false);*/
        // }
      },
      child: SizedBox(
        width: Get.width * 0.32,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              child: TextFormField(
                controller: controller.selectedCustomerMobileNoController,
                maxLength: 10,
                enabled:
                    // controller.customerNameValue.isNotEmpty &&
                    //         controller.searchCustomerList.isEmpty
                    //     ? true
                    //     :
                    false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textInputAction: TextInputAction.next,
                style: TextStyles.kTextH14DarkGreyBold400,
                enableSuggestions: false,
                autocorrect: false,
                obscureText: false,
                keyboardType: TextInputType.phone,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (String value) {
                  controller.validateUserInput(fieldNumber: 1);
                },
                decoration: const InputDecoration(
                  labelText: kLabelCustomersNo,
                  counterText: '',
                  fillColor: kColorPurpleF4F7FF,
                  filled: true,
                  isDense: true,
                  contentPadding:
                      EdgeInsets.only(left: 12, bottom: 10, top: 12),
                  labelStyle:
                      // controller.isFocusOnMobileNoField.value ||
                      //     controller
                      //         .selectedCustomerMobileNoController.text.isNotEmpty
                      //     ? TextStyles.kTextH14DarkGreyBold400
                      //     :
                      TextStyles.kTextH14Grey96Bold400,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: kColorDarkGrey3535, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kColorLightGrey, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kColorLightGrey, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  hintStyle: TextStyles.kTextH14Grey96Bold400,
                  hintText: kLabelContactNo,
                  focusColor: kColorPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customerEmailIdTextField() {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Focus(
        onFocusChange: (hasFocus) {
          controller.changeFocus(hasFocus: hasFocus, fieldNumber: 5);

          controller.validateUserInput(fieldNumber: 2, isOnChange: false);

          // if (controller.productNameController.text.trim().isNotEmpty) {
          /*controller.validateUserInput(fieldNumber: 1, isOnChange: false);*/
          // }
        },
        child: SizedBox(
          width: Get.width * 0.56,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
                child: TextFormField(
                  controller: controller.selectedCustomerEmailIdController,
                  maxLength: 50,
                  enabled:
                      // controller.customerNameValue.isNotEmpty &&
                      //         controller.searchCustomerList.isEmpty
                      //     ? true
                      //     :
                      false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: TextStyles.kTextH14DarkGreyBold400,
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: false,
                  onChanged: (String value) {
                    controller.validateUserInput(fieldNumber: 2);
                  },
                  decoration: const InputDecoration(
                    labelText: kLabelEmail,
                    counterText: '',
                    fillColor: kColorPurpleF4F7FF,
                    filled: true,
                    isDense: true,
                    alignLabelWithHint: true,
                    contentPadding:
                        EdgeInsets.only(left: 12, bottom: 10, top: 12),
                    labelStyle:
                        // controller.isFocusOnEmailIdField.value ||
                        //     controller
                        //         .selectedCustomerEmailIdController.text.isNotEmpty
                        //     ? TextStyles.kTextH14DarkGreyBold400
                        //     :
                        TextStyles.kTextH14Grey96Bold400,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kColorDarkGrey3535, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kColorLightGrey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kColorLightGrey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    hintStyle: TextStyles.kTextH14Grey96Bold400,
                    hintText: kLabelEmail,
                    focusColor: kColorPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
    return Obx(
      () {
        return GestureDetector(
          onTap: () {
            FocusScope.of(Get.overlayContext!).requestFocus();
            controller.navigateToSearchItemsScreen();
          },
          child: SizedBox(
            width: Get.width * 0.38, // 0.48
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 42,
                  child: TextFormField(
                    enabled: false,
                    controller: controller.productNameController,
                    maxLength: 50,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (String value) {
                      // if (value.isEmpty) {
                      //   controller.productNameValue.value = '';
                      //   controller.searchItemsList.clear();
                      // } else {
                      //   controller.productNameValue.value = value;
                      //   controller.onProductNameValueChange();
                      // }
                    },
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: TextStyles.kTextH14DarkGreyBold400,
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_right,
                        color: kColorWhite,
                        size: 22,
                      ),
                      // labelText: kLabelProducts,
                      // prefixIcon: Padding(
                      //   padding: const EdgeInsets.only(
                      //       left: 1, right: 1, bottom: 11, top: 11),
                      //   child: SvgPicture.asset(kIconSearch),
                      // ),
                      // suffixIcon: Padding(
                      //   padding: const EdgeInsets.only(
                      //       left: 12, right: 9, bottom: 9, top: 9),
                      //   child: controller.isFocusOnProductNameField.value
                      //       ? SvgPicture.asset(kIconDropDownUp)
                      //       : SvgPicture.asset(kIconDropDown),
                      // ),
                      counterText: '',
                      fillColor: kColorPrimary,
                      // fillColor: kColorGreyF1F1F1,
                      filled: true,
                      alignLabelWithHint: true,
                      isDense: true,
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 11, top: 11),
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
                      disabledBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: kColorLightGrey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      hintStyle: TextStyles.kTextH14WhiteBold400,
                      // hintStyle: TextStyles.kTextH14Grey96Bold400,
                      hintText: kLabelSelectItems,
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
          ),
        );
      },
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
              width: Get.width * 0.38, // 0.28
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
                        alignLabelWithHint: true,
                        isDense: true,
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 11, top: 11),
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
              margin: const EdgeInsets.only(left: 20, right: 20, top: 12),
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
              margin: const EdgeInsets.only(left: 20, right: 20, top: 12),
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
                                    text: controller.returnGSTRateItemTotal(
                                        itemData: itemData),
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
                              Text(
                                kLabelPriceWithColon,
                                style: controller.isItemPriceEditable.value
                                    ? TextStyles.kTextH14DarkGreyBold600
                                    : TextStyles.kTextH14DarkGreyBold400,
                              ),

                              /// price text-field
                              controller.isItemPriceEditable.value
                                  ? Focus(
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
                                          margin:
                                              const EdgeInsets.only(left: 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 28,
                                                child: TextFormField(
                                                  controller: controller
                                                          .priceTextFieldList[
                                                      index],
                                                  maxLength: 50,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  onChanged: (String value) {
                                                    controller
                                                        .onPriceValueChange(
                                                            index: index);
                                                  },
                                                  inputFormatters: <
                                                      TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  keyboardType:
                                                      TextInputType.number,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  style: TextStyles
                                                      .kTextH14DarkGreyBold600,
                                                  enableSuggestions: false,
                                                  autocorrect: false,
                                                  obscureText: false,
                                                  decoration:
                                                      const InputDecoration(
                                                    // labelText: kLabelBarcode,
                                                    prefixText: kRupee,
                                                    prefixStyle: TextStyles
                                                        .kTextH14DarkGreyBold400,
                                                    counterText: '',
                                                    fillColor: kColorGreyF1F1F1,
                                                    filled: true,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            left: 5,
                                                            bottom: 3,
                                                            top: 4),
                                                    // labelStyle: controller.isFocusOnBarcodeField.value ||
                                                    //     controller.textFieldList[index].text.isNotEmpty
                                                    //     ? TextStyles.kTextH14DarkGreyBold400
                                                    //     : TextStyles.kTextH14Grey96Bold400,
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: kColorWhite,
                                                          width: 1.0),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4.0)),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: kColorWhite,
                                                          width: 1.0),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4.0)),
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
                                                          .priceTextFieldList[
                                                              index]
                                                          .text
                                                          .isNotEmpty ||
                                                      controller.isValidBarcode
                                                              .value ==
                                                          false,
                                                  child: controller.barCodeStr
                                                              .value ==
                                                          ''
                                                      ? Container()
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10,
                                                                  top: 2),
                                                          child: Text(
                                                              controller
                                                                  .barCodeStr
                                                                  .value,
                                                              style: TextStyles
                                                                  .kTextH12Red)),
                                                );
                                              }),
                                            ],
                                          ),
                                        );
                                      }),
                                    )
                                  : Row(
                                      children: [
                                        Text(
                                          ' $kRupee${returnFormattedNumber(values: double.parse(controller.priceTextFieldList[index].text))}',
                                          style: TextStyles
                                              .kTextH14DarkGreyBold600,
                                        ),
                                      ],
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
                                      text: kLabelGSTWithColon,
                                      style:
                                          TextStyles.kTextH14DarkGreyBold400),
                                  TextSpan(
                                      text:
                                          '${controller.returnGstRate(itemData: itemData)} %',
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
                                        height: 32,
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
                                            fillColor: kColorGreyF1F1F1,
                                            filled: true,
                                            // labelStyle: controller.isFocusOnBarcodeField.value ||
                                            //     controller.textFieldList[index].text.isNotEmpty
                                            //     ? TextStyles.kTextH14DarkGreyBold400
                                            //     : TextStyles.kTextH14Grey96Bold400,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: kColorWhite,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(0.0)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: kColorWhite,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(0.0)),
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
      margin: const EdgeInsets.only(left: 22, right: 22, top: 16),
      child: Column(
        children: [
          /// discount price
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: controller.summaryTextFieldWidth,
                  height: controller.summaryTextFieldHeight,
                  child: Focus(
                    onFocusChange: (value) {
                      controller.onDiscountInAmountValueChange(
                          isOnChange: false);
                    },
                    child: Obx(() {
                      return TextFormField(
                        enabled:
                            controller.selectedItemsList.isEmpty ? false : true,
                        controller: controller.discountInAmountTextField,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        style: TextStyles.kTextH16DarkGrey600,
                        enableSuggestions: false,
                        autocorrect: false,
                        obscureText: false,
                        onChanged: (String value) {
                          controller.onDiscountInAmountValueChange();
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegexData.digitAndPointRegex),
                        ],
                        decoration: const InputDecoration(
                          hintText: '0',
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
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: kColorLightGrey, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: kColorLightGrey, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: kColorLightGrey, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                /// discount in percentage
                SizedBox(
                  width: controller.summaryTextFieldWidth,
                  height: controller.summaryTextFieldHeight,
                  child: Focus(
                    onFocusChange: (value) {
                      controller.onDiscountInPercentageValueChange(
                          isOnChange: false);
                    },
                    child: Obx(() {
                      return TextFormField(
                        // enabled: true,
                        enabled:
                            controller.selectedItemsList.isEmpty ? false : true,
                        controller: controller.discountInPercentageTextField,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        style: TextStyles.kTextH16DarkGrey600,
                        enableSuggestions: false,
                        autocorrect: false,
                        obscureText: false,
                        onChanged: (String value) {
                          controller.onDiscountInPercentageValueChange();
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegexData.digitAndPointRegex),
                        ],
                        decoration: const InputDecoration(
                          hintText: '0',
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
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: kColorLightGrey, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: kColorLightGrey, width: 1.0),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: kColorLightGrey, width: 1.0),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          /// additional and received price
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: controller.summaryTextFieldWidth,
                  height: controller.summaryTextFieldHeight,
                  child: Focus(
                    onFocusChange: (value) {
                      controller.onAdditionalChargeValueChange(
                          isOnChange: false);
                    },
                    child: Obx(() {
                      return TextFormField(
                        enabled:
                            controller.selectedItemsList.isEmpty ? false : true,
                        controller: controller.additionalChargeTextField,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        style: TextStyles.kTextH16DarkGrey600,
                        enableSuggestions: false,
                        autocorrect: false,
                        obscureText: false,
                        onChanged: (String value) {
                          controller.onAdditionalChargeValueChange();
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegexData.digitAndPointRegex),
                        ],
                        decoration: const InputDecoration(
                          hintText: '0',
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
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: kColorLightGrey, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: kColorLightGrey, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: kColorLightGrey, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(
                  width: controller.summaryTextFieldWidth,
                  height: controller.summaryTextFieldHeight,
                  child: Obx(() {
                    return TextFormField(
                      enabled:
                          controller.selectedItemsList.isEmpty ? false : true,
                      controller: controller.receivedAmountController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      style: TextStyles.kTextH16DarkGrey600,
                      enableSuggestions: false,
                      autocorrect: false,
                      obscureText: false,
                      decoration: const InputDecoration(
                        hintText: '0',
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
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: kColorLightGrey, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: kColorLightGrey, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: kColorLightGrey, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          /// total and payable price
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: controller.summaryTextFieldWidth,
                  height: controller.summaryTextFieldHeight,
                  child: TextFormField(
                    enabled: false,
                    controller: controller.invoiceTotal,
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
                      disabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: kColorLightGrey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: controller.summaryTextFieldWidth,
                  height: controller.summaryTextFieldHeight,
                  child: TextFormField(
                    enabled: false,
                    controller: controller.invoicePayable,
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
                      disabledBorder: OutlineInputBorder(
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

          /// total price
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     const Text(
          //       kLabelTotal,
          //       style: TextStyles.kTextH14DarkGreyBold400,
          //     ),
          //     Container(
          //       width: Get.width * 0.5,
          //       padding: const EdgeInsets.only(left: 12, top: 2, bottom: 2),
          //       decoration: BoxDecoration(
          //         color: kColorGreyF1F1F1,
          //         borderRadius: BorderRadius.circular(4),
          //       ),
          //       child: Obx(() {
          //         return RichText(
          //           text: TextSpan(children: [
          //             const TextSpan(
          //               text: kRupee,
          //               style: TextStyles.kTextH16DarkGrey400,
          //             ),
          //             TextSpan(
          //               // text: (controller.viewInvoiceData.value.totalAmount??0.0).toStringAsFixed(2),
          //               text: controller.invoiceTotal.value,
          //               style: TextStyles.kTextH16DarkGrey600,
          //             ),
          //           ]),
          //         );
          //       }),
          //     ),
          //   ],
          // ),

          /// discount price
          // Padding(
          //   padding: const EdgeInsets.only(top: 6),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       const Text(
          //         kLabelDiscount,
          //         style: TextStyles.kTextH14DarkGreyBold400,
          //       ),
          //       Row(
          //         children: [
          //           /// discount in amount
          //           Container(
          //             width: Get.width * 0.26,
          //             height: 28,
          //             padding: const EdgeInsets.only(top: 10, bottom: 0),
          //             decoration: BoxDecoration(
          //               color: kColorGreyF1F1F1,
          //               borderRadius: BorderRadius.circular(4),
          //             ),
          //             child: Focus(
          //               onFocusChange: (value) {
          //                 controller.onDiscountInAmountValueChange(
          //                     isOnChange: false);
          //               },
          //               child: TextFormField(
          //                 controller: controller.discountInAmountTextField,
          //                 autovalidateMode: AutovalidateMode.onUserInteraction,
          //                 onChanged: (String value) {
          //                   controller.onDiscountInAmountValueChange();
          //                 },
          //                 inputFormatters: [
          //                   FilteringTextInputFormatter.allow(
          //                       RegexData.digitAndPointRegex),
          //                 ],
          //                 keyboardType: TextInputType.number,
          //                 textInputAction: TextInputAction.next,
          //                 style: TextStyles.kTextH16DarkGrey600,
          //                 enableSuggestions: false,
          //                 autocorrect: false,
          //                 obscureText: false,
          //                 decoration: const InputDecoration(
          //                   prefixText: kRupee,
          //                   prefixStyle: TextStyles.kTextH14DarkGreyBold400,
          //                   counterText: '',
          //                   fillColor: kColorGreyF1F1F1,
          //                   filled: true,
          //                   contentPadding: EdgeInsets.only(
          //                       left: 12.0, bottom: 10, top: 11),
          //                   // labelStyle: controller.isFocusOnBarcodeField.value ||
          //                   //         controller.barCodeController.text.isNotEmpty
          //                   //     ? TextStyles.kTextH14DarkGreyBold400
          //                   //     : TextStyles.kTextH14Grey96Bold400,
          //                   border: InputBorder.none,
          //                   focusColor: kColorPrimary,
          //                 ),
          //               ),
          //             ),
          //           ),
          //
          //           /// discount in percentage
          //           Container(
          //             width: Get.width * 0.23,
          //             height: 28,
          //             padding:
          //                 const EdgeInsets.only(left: 12, top: 10, bottom: 0),
          //             margin: const EdgeInsets.only(left: 6),
          //             decoration: BoxDecoration(
          //               color: kColorGreyF1F1F1,
          //               borderRadius: BorderRadius.circular(4),
          //             ),
          //             child: Focus(
          //               onFocusChange: (value) {
          //                 controller.onDiscountInPercentageValueChange(
          //                     isOnChange: false);
          //               },
          //               child: TextFormField(
          //                 controller: controller.discountInPercentageTextField,
          //                 autovalidateMode: AutovalidateMode.onUserInteraction,
          //                 onChanged: (String value) {
          //                   controller.onDiscountInPercentageValueChange();
          //                 },
          //                 inputFormatters: [
          //                   FilteringTextInputFormatter.allow(
          //                       RegexData.digitAndPointRegex),
          //                 ],
          //                 keyboardType: TextInputType.number,
          //                 textInputAction: TextInputAction.next,
          //                 style: TextStyles.kTextH16DarkGrey600,
          //                 enableSuggestions: false,
          //                 autocorrect: false,
          //                 obscureText: false,
          //                 decoration: const InputDecoration(
          //                   suffixText: kPercentage,
          //                   suffixStyle: TextStyles.kTextH14DarkGreyBold400,
          //                   counterText: '',
          //                   fillColor: kColorGreyF1F1F1,
          //                   filled: true,
          //                   contentPadding: EdgeInsets.only(
          //                       right: 12.0, bottom: 10, top: 11),
          //                   // labelStyle: controller.isFocusOnBarcodeField.value ||
          //                   //         controller.barCodeController.text.isNotEmpty
          //                   //     ? TextStyles.kTextH14DarkGreyBold400
          //                   //     : TextStyles.kTextH14Grey96Bold400,
          //                   border: InputBorder.none,
          //                   focusColor: kColorPrimary,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),

          /// additional price
          // Padding(
          //   padding: const EdgeInsets.only(top: 6),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       const Text(
          //         kLabelAdditionalCharge,
          //         style: TextStyles.kTextH14DarkGreyBold400,
          //       ),
          //       Container(
          //         width: Get.width * 0.5,
          //         height: 28,
          //         padding: const EdgeInsets.only(left: 0, top: 10, bottom: 0),
          //         decoration: BoxDecoration(
          //           color: kColorGreyF1F1F1,
          //           borderRadius: BorderRadius.circular(4),
          //         ),
          //         child: Focus(
          //           onFocusChange: (value) {
          //             controller.onAdditionalChargeValueChange(
          //                 isOnChange: false);
          //           },
          //           child: TextFormField(
          //             controller: controller.additionalChargeTextField,
          //             autovalidateMode: AutovalidateMode.onUserInteraction,
          //             onChanged: (String value) {
          //               controller.onAdditionalChargeValueChange();
          //             },
          //             inputFormatters: [
          //               FilteringTextInputFormatter.allow(
          //                   RegexData.digitAndPointRegex),
          //             ],
          //             keyboardType: TextInputType.number,
          //             textInputAction: TextInputAction.next,
          //             style: TextStyles.kTextH16DarkGrey600,
          //             enableSuggestions: false,
          //             autocorrect: false,
          //             obscureText: false,
          //             decoration: const InputDecoration(
          //               prefixText: kRupee,
          //               prefixStyle: TextStyles.kTextH14DarkGreyBold400,
          //               counterText: '',
          //               fillColor: kColorGreyF1F1F1,
          //               filled: true,
          //               contentPadding:
          //                   EdgeInsets.only(left: 12.0, bottom: 10, top: 11),
          //               // labelStyle: controller.isFocusOnBarcodeField.value ||
          //               //         controller.barCodeController.text.isNotEmpty
          //               //     ? TextStyles.kTextH14DarkGreyBold400
          //               //     : TextStyles.kTextH14Grey96Bold400,
          //               border: InputBorder.none,
          //               focusColor: kColorPrimary,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          /// payable price
          // Padding(
          //   padding: const EdgeInsets.only(top: 6),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       const Text(
          //         kLabelPayableAmount,
          //         style: TextStyles.kTextH14DarkGreyBold400,
          //       ),
          //       Container(
          //         width: Get.width * 0.5,
          //         padding: const EdgeInsets.only(left: 12, top: 2, bottom: 2),
          //         decoration: BoxDecoration(
          //           color: kColorGreyF1F1F1,
          //           borderRadius: BorderRadius.circular(4),
          //         ),
          //         child: Obx(() {
          //           return RichText(
          //             text: TextSpan(children: [
          //               const TextSpan(
          //                 text: kRupee,
          //                 style: TextStyles.kTextH16DarkGrey400,
          //               ),
          //               TextSpan(
          //                 text: controller.invoicePayable.value,
          //                 // (controller.viewInvoiceData.value.payableAmount ??
          //                 //         0.0)
          //                 //     .toStringAsFixed(2),
          //                 style: TextStyles.kTextH16DarkGrey600,
          //               ),
          //             ]),
          //           );
          //         }),
          //       ),
          //     ],
          //   ),
          // ),

          /// received price
          // Padding(
          //   padding: const EdgeInsets.only(top: 6),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       const Text(
          //         kLabelReceivedAmount,
          //         style: TextStyles.kTextH14DarkGreyBold400,
          //       ),
          //       Container(
          //         width: Get.width * 0.5,
          //         height: 28,
          //         padding: const EdgeInsets.only(left: 0, top: 10, bottom: 0),
          //         decoration: BoxDecoration(
          //           color: kColorGreyF1F1F1,
          //           borderRadius: BorderRadius.circular(4),
          //         ),
          //         child: Focus(
          //           onFocusChange: (value) {
          //             // controller.onReceivedAmountValueChange(isOnChange: false);
          //           },
          //           child: TextFormField(
          //             controller: controller.receivedAmountController,
          //             autovalidateMode: AutovalidateMode.onUserInteraction,
          //             onChanged: (String value) {
          //               // controller.onReceivedAmountValueChange();
          //             },
          //             inputFormatters: [
          //               FilteringTextInputFormatter.allow(
          //                   RegexData.digitAndPointRegex),
          //             ],
          //             keyboardType: TextInputType.number,
          //             textInputAction: TextInputAction.next,
          //             style: TextStyles.kTextH16DarkGrey600,
          //             enableSuggestions: false,
          //             autocorrect: false,
          //             obscureText: false,
          //             decoration: const InputDecoration(
          //               prefixText: kRupee,
          //               prefixStyle: TextStyles.kTextH14DarkGreyBold400,
          //               counterText: '',
          //               fillColor: kColorGreyF1F1F1,
          //               filled: true,
          //               contentPadding:
          //               EdgeInsets.only(left: 12.0, bottom: 10, top: 11),
          //               // labelStyle: controller.isFocusOnBarcodeField.value ||
          //               //         controller.barCodeController.text.isNotEmpty
          //               //     ? TextStyles.kTextH14DarkGreyBold400
          //               //     : TextStyles.kTextH14Grey96Bold400,
          //               border: InputBorder.none,
          //               focusColor: kColorPrimary,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget cancelAndConfirmButtons() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 40,
              width: Get.width * 0.42,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: kColorPrimary,
                  ),
                  color: kColorWhite,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: MaterialButton(
                onPressed: () {
                  FocusScope.of(Get.overlayContext!).unfocus();
                  controller.resetInvoiceValues();
                  // Get.back(result: false);
                },
                child: const Center(
                    child: Text(
                  kLabelReset,
                  style: TextStyles.kTextH18PrimaryBold500,
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
                  kLabelGenerate,
                  style: TextStyles.kTextH18WhiteBold500
                      .copyWith(color: kColorWhite),
                )),
              ),
            ),
          ],
        ),
      ),
    );
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

  void addNewCustomerBottomSheet() {
    Get.bottomSheet(
      isDismissible: false,
      backgroundColor: kColorWhite,
      GestureDetector(
        onTap: () {
          FocusScope.of(Get.overlayContext!).unfocus();
        },
        child: Container(
          height: Get.height * 0.45,
          margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    kLabelAddNewCustomer,
                    style: TextStyles.kTextH16Primary600,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: SvgPicture.asset(kIconClosePrimary),
                  ),
                ],
              ),
              customerNameTextField(),
              customerContactNumberTextField(),
              customerEmailTextField(),
              const Spacer(),
              Container(
                height: controller.custTextFieldHeight,
                width: Get.width,
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: kColorPrimary,
                    ),
                    color: kColorPrimary,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: MaterialButton(
                  onPressed: () {
                    FocusScope.of(Get.overlayContext!).unfocus();
                    controller.checkCustomerAddValidation();
                  },
                  child: Center(
                      child: Text(
                    kLabelAddCustomer.toUpperCase(),
                    style: TextStyles.kTextH18WhiteBold500
                        .copyWith(color: kColorWhite),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customerNameTextField() {
    return Focus(
      onFocusChange: (hasFocus) {
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 3);
        // if (controller.customerNameController.text.trim().isNotEmpty) {
        controller.validateUserInput(fieldNumber: 1, isOnChange: false);
        // }
      },
      child: Obx(() {
        return Container(
          margin: const EdgeInsets.only(top: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: controller.custTextFieldHeight,
                child: TextFormField(
                  controller: controller.customerNameController,
                  maxLength: 25,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (String value) {
                    controller.validateUserInput(fieldNumber: 1);
                  },
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  style: TextStyles.kTextH14DarkGreyBold400,
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: kLabelCustomersName,
                    counterText: '',
                    contentPadding: controller.custTextFieldContentPadding,
                    labelStyle: controller.isFocusOnCustomerNameField.value ||
                            controller.customerNameController.text.isNotEmpty
                        ? TextStyles.kTextH14DarkGreyBold400
                        : TextStyles.kTextH14GreyBold400,
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
                    hintStyle: TextStyles.kTextH14GreyBold600,
                    hintText: kLabelCustomersName,
                    focusColor: kColorPrimary,
                  ),
                ),
              ),
              Obx(() {
                return Visibility(
                  visible: controller.customerNameController.text.isNotEmpty ||
                      controller.isValidCustomerName.value == false,
                  child: controller.customerNameStr.value == ''
                      ? Container()
                      : Padding(
                          padding: controller.custErrorValidationPadding,
                          child: Text(controller.customerNameStr.value,
                              style: TextStyles.kTextH12Red)),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget customerContactNumberTextField() {
    return Focus(
      onFocusChange: (hasFocus) {
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 4);
        controller.validateUserInput(fieldNumber: 2, isOnChange: false);
      },
      child: Obx(() {
        return Container(
          margin: const EdgeInsets.only(top: 6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: controller.custTextFieldHeight,
                child: TextFormField(
                  controller: controller.customerMobileNoController,
                  maxLength: 10,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  // validator: (text) {
                  //   return TwoWaayFormValidation().validate(widget.fieldType, text);
                  // },
                  onChanged: (String value) {
                    controller.validateUserInput(fieldNumber: 2);
                  },
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  textInputAction: TextInputAction.next,
                  style: TextStyles.kTextH14DarkGreyBold400,
                  enableSuggestions: false,
                  // buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                  autocorrect: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: kLabelContactNo,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        FocusScope.of(Get.overlayContext!).unfocus();
                        controller.navigateToImportContactsScreen();
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 5, bottom: 5, right: 14),
                        child:
                            SvgPicture.asset(kIconAddUserContact, height: 20),
                      ),
                    ),
                    contentPadding: controller.custTextFieldContentPadding,
                    counterText: '',
                    labelStyle: controller.isFocusOnMobileNoField.value ||
                            controller
                                .customerMobileNoController.text.isNotEmpty
                        ? TextStyles.kTextH14DarkGreyBold400
                        : TextStyles.kTextH14GreyBold400,
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
                    hintStyle: TextStyles.kTextH14GreyBold600,
                    hintText: kLabelContactNo,
                    focusColor: kColorPrimary,
                  ),
                ),
              ),
              Obx(() {
                return Visibility(
                  visible:
                      controller.customerMobileNoController.text.isNotEmpty ||
                          controller.isValidPhoneNumber.value == false,
                  child: controller.customerMobileStr.value == ''
                      ? Container()
                      : Padding(
                          padding: controller.custErrorValidationPadding,
                          child: Text(controller.customerMobileStr.value,
                              style: TextStyles.kTextH12Red)),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget customerEmailTextField() {
    return Focus(
      onFocusChange: (hasFocus) {
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 5);
        controller.validateUserInput(fieldNumber: 3, isOnChange: false);
      },
      child: Obx(() {
        return Container(
          margin: const EdgeInsets.only(top: 6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: controller.custTextFieldHeight,
                child: TextFormField(
                  maxLength: 50,
                  controller: controller.customerEmailIdController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (String value) {
                    controller.validateUserInput(fieldNumber: 3);
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: TextStyles.kTextH14DarkGreyBold400,
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: kLabelEmail,
                    contentPadding: controller.custTextFieldContentPadding,
                    counterText: '',
                    labelStyle: controller.isFocusOnEmailIdField.value ||
                            controller.customerEmailIdController.text.isNotEmpty
                        ? TextStyles.kTextH14DarkGreyBold400
                        : TextStyles.kTextH14GreyBold400,
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
                    hintStyle: TextStyles.kTextH14GreyBold600,
                    hintText: kLabelEmail,
                    focusColor: kColorPrimary,
                  ),
                ),
              ),
              Obx(() {
                return Visibility(
                  visible:
                      controller.customerEmailIdController.text.isNotEmpty ||
                          controller.isValidEmailId.value == false,
                  child: controller.customerEmailStr.value == ''
                      ? Container()
                      : Padding(
                          padding: controller.custErrorValidationPadding,
                          child: Text(controller.customerEmailStr.value,
                              style: TextStyles.kTextH12Red)),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  void searchCustomerBottomSheet() {
    Get.bottomSheet(
      // isDismissible: false,
      backgroundColor: kColorWhite,
      Obx(() {
        return Container(
            height: Get.height,
            child: controller.isShowAddCustomer.value
                ? addNewCustomerView()
                : selectCustomerWithList());
      }),
    );
  }

  void showWarningDialogBox() {
    // showDialog(
    //   context: Get.overlayContext!,
    //   builder: (context) {
    //     return
    showConfirmDialogBox(
      title: '',
      type: kLabelWarning,
      message: '$kAreYouSureToLeave',
      negativeButtonTitle: kLabelNo,
      negativeClicked: () {
        Get.back(result: false);
      },
      positiveButtonTitle: kLabelYes,
      positiveClicked: () {
        Get.back();
        Get.back(result: false);
      },
    );
    // },
    // );
  }

  Widget addNewCustomerView() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                kLabelAddNewCustomer,
                style: TextStyles.kTextH16Primary600,
              ),
              GestureDetector(
                onTap: () {
                  controller.isFocusOnCustomerNameField.value = false;
                  controller.isShowAddCustomer.value = false;
                  controller.customerNameController.text = '';
                  controller.customerMobileNoController.text = '';
                  // Get.back();
                },
                child: SvgPicture.asset(kIconClosePrimary),
              ),
            ],
          ),
          customerNameTextField(),
          customerContactNumberTextField(),
          customerEmailTextField(),
          const Spacer(),
          Container(
            height: controller.custTextFieldHeight,
            width: Get.width,
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
                border: Border.all(
                  color: kColorPrimary,
                ),
                color: kColorPrimary,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: MaterialButton(
              onPressed: () {
                FocusScope.of(Get.overlayContext!).unfocus();
                controller.checkCustomerAddValidation();
              },
              child: Center(
                  child: Text(
                kLabelAddCustomer.toUpperCase(),
                style: TextStyles.kTextH18WhiteBold500
                    .copyWith(color: kColorWhite),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget selectCustomerWithList() {
    return Column(
      children: [
        /// customer name
        Focus(
          onFocusChange: (hasFocus) {
            controller.changeFocus(hasFocus: hasFocus, fieldNumber: 3);
          },
          child: Obx(
            () {
              return Row(
                children: [
                  Container(
                    width: Get.width * 0.77,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
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
                                controller.customerNameStr.value = '';
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
                              suffixIcon: controller
                                      .customerNameValue.value.isEmpty
                                  ? const Text('')
                                  : GestureDetector(
                                      onTap: () {
                                        controller.customerNameController.text =
                                            '';
                                        controller.customerNameValue.value = '';
                                        controller.customerNameStr.value = '';
                                        controller.onCustomerNameValueChange();
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                            left: 12,
                                            right: 9,
                                            bottom: 9,
                                            top: 9),
                                        child: Icon(
                                          Icons.close,
                                          color: kColorGrey96,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                              labelText: kLabelSearchCustomer,
                              counterText: '',
                              // fillColor: kColorPurpleF4F7FF,
                              // filled: true,
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
                        // Obx(
                        //   () {
                        //     return Visibility(
                        //       visible: controller
                        //               .customerNameController.text.isNotEmpty ||
                        //           controller.isValidCustomerName.value == false,
                        //       child: controller.customerNameStr.value == ''
                        //           ? Container()
                        //           : Padding(
                        //               padding: const EdgeInsets.only(
                        //                   left: 10, top: 2),
                        //               child: Text(
                        //                   controller.customerNameStr.value,
                        //                   style: TextStyles.kTextH12Red)),
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.isFocusOnCustomerNameField.value = false;
                      controller.isShowAddCustomer.value = true;
                      controller.customerNameController.text = '';
                      // addNewCustomerBottomSheet();
                    },
                    child: Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: kColorPrimary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: kColorWhite,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        /// customer listing view
        Obx(() {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: kColorWhite,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                // itemCount: controller.itemsList.length,
                itemCount: controller.customerNameValue.value.isNotEmpty
                    ? controller.searchCustomerList.length
                    : controller.customerDataList.length,
                itemBuilder: (context, index) {
                  var custData = controller.customerNameValue.value.isNotEmpty
                      ? controller.searchCustomerList[index]
                      : controller.customerDataList[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.only(top: 2, left: 8, bottom: 2),
                    decoration: BoxDecoration(
                      color: custData.isSelected == true
                          ? kColorPrimary
                          : kColorWhite,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: kColorLightGrey),
                    ),
                    child: ListTile(
                      onTap: () {
                        var value = controller
                                .customerNameValue.value.isNotEmpty
                            ? controller.searchCustomerList[index].isSelected ??
                                false
                            : controller.customerDataList[index].isSelected ??
                                false;

                        if (controller.customerNameValue.isNotEmpty) {
                          controller.onCustomerSelection(
                              isSelected: value,
                              custData: controller.searchCustomerList[index],
                              index: index);
                        } else {
                          controller.onCustomerSelection(
                              isSelected: value,
                              custData: controller.customerDataList[index],
                              index: index);
                        }
                      },
                      dense: true,
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: 0),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 0.0, vertical: 0.0),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            custData.name ?? '',
                            style: custData.isSelected == true
                                ? TextStyles.kTextH14WhiteBold400
                                : TextStyles.kTextH14DarkGreyBold400,
                          ),
                          Text(
                            '${custData.mobileNo ?? 0}',
                            style: custData.isSelected == true
                                ? TextStyles.kTextH14WhiteBold400
                                : TextStyles.kTextH14DarkGreyBold400,
                          ),

                          /// price and units
                          // Row(
                          //   children: [
                          //     RichText(
                          //       text:
                          //           TextSpan(children: [
                          //         TextSpan(
                          //           text: kRupee,
                          //           style: itemData
                          //                       .isSelected ==
                          //                   true
                          //               ? TextStyles
                          //                   .kTextH14WhiteBold400
                          //               : TextStyles
                          //                   .kTextH14DarkGreyBold400,
                          //         ),
                          //         TextSpan(
                          //           text: returnToStringAsFixed(
                          //               value: itemData
                          //                       .itemTotal ??
                          //                   0.0),
                          //           style: itemData
                          //                       .isSelected ==
                          //                   true
                          //               ? TextStyles
                          //                   .kTextH14WhiteBold600
                          //               : TextStyles
                          //                   .kTextH14DarkGreyBold600,
                          //         ),
                          //       ]),
                          //     ),
                          //     Padding(
                          //       padding:
                          //           const EdgeInsets
                          //               .only(left: 6),
                          //       child: Text(
                          //         '/${controller.returnUnitName(index: index)}',
                          //         style: itemData
                          //                     .isSelected ==
                          //                 true
                          //             ? TextStyles
                          //                 .kTextH14WhiteBold400
                          //             : TextStyles
                          //                 .kTextH14DarkGreyBold400,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget selectCustomerOrAddNewUI() {
    return GestureDetector(
      onTap: () {
        searchCustomerBottomSheet();
      },
      child: Container(
        padding: const EdgeInsets.only(left: 14, top: 8, bottom: 8, right: 14),
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
        decoration: BoxDecoration(
          color: kColorPurpleF4F7FF,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kColorLightGrey),
        ),
        child: Obx(() {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person_outline,
                          size: 18,
                          color: controller.selectedCustomerNameController.value
                                      .text ==
                                  ''
                              ? kColorGrey8DShade
                              : kColorDarkGrey3535),
                      Text(
                        controller.selectedCustomerNameController.value.text ==
                                ''
                            ? ' $kLabelSelectCustomer'
                            : ' ${controller.selectedCustomerNameController.value.text}',
                        style: controller.selectedCustomerNameController.value
                                    .text ==
                                ''
                            ? TextStyles.kTextH14Grey8DShade400
                            : TextStyles.kTextH14DarkGreyBold400,
                      ),
                    ],
                  ),
                  Icon(Icons.keyboard_arrow_right_sharp,
                      color: controller
                                  .selectedCustomerNameController.value.text ==
                              ''
                          ? kColorGrey8DShade
                          : kColorDarkGrey3535),
                ],
              ),
              Obx(() {
                return Visibility(
                  visible:
                      controller.selectedCustomerNameController.value.text !=
                          '',
                  child: SizedBox(
                     width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// mobile number
                          Row(
                            children: [
                              const Icon(Icons.phone_outlined,
                                  size: 18, color: kColorDarkGrey3535),
                              Text(
                                ' ${controller.selectedCustomerMobileNoController.text}',
                                style: controller.selectedCustomerNameController
                                            .value.text ==
                                        ''
                                    ? TextStyles.kTextH14Grey8DShade400
                                    : TextStyles.kTextH14DarkGreyBold400,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.mail_outline,
                                  size: 18, color: kColorDarkGrey3535),
                              Text(
                                controller.selectedCustomerEmailIdController
                                            .text ==
                                        ''
                                    ? ' $kNoEmailFound'
                                    : controller.selectedCustomerEmailIdController.text.length >23 ?' ${controller.selectedCustomerEmailIdController.text.substring(0,23)}...': ' ${controller.selectedCustomerEmailIdController.text}',
                                style: controller.selectedCustomerNameController
                                            .value.text ==
                                        ''
                                    ? TextStyles.kTextH14Grey8DShade400
                                    : TextStyles.kTextH14DarkGreyBold400,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        }),
      ),
    );
  }
}
