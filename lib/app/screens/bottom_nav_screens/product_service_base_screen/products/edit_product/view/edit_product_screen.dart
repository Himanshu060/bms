import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/image_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/products/edit_product/controller/edit_product_controller.dart';
import 'package:bms/app/screens/bottom_navigation/base/model/response/drop_down_common_data.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:bms/app/utils/regex.dart';
import 'package:bms/app/utils/text_styles.dart';
import 'package:bms/app/widgets/appBar/app_bar_with_back_button.dart';
import 'package:bms/app/widgets/buttons/primary_button.dart';
import 'package:bms/app/widgets/dialogs/show_confirm_dialog_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class EditProductScreen extends GetView<EditProductController> {
  EditProductScreen({Key? key}) : super(key: key) {
    final intentData = Get.arguments;
    controller.setIntentData(intentData: intentData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBackButton(
        title: kLabelEditProductName,
        isShowLeadingIcon: true,
        isShowActionWidgets: true,
        widget: [
          GestureDetector(
            onTap: () {
              showDeleteDialog();
              //controller.deleteCustomerApiCall();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 30),
              child: SvgPicture.asset(kIconDelete),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: SizedBox(
            height: Get.height * 0.89,
            child: Column(
              children: [
                productNameTextField(),
                categoryDropDown(),
                purchasePriceAndUnitContainer(),
                sellingPriceAndTaxSwitchContainer(),
                hsnAndGstRateContainer(),
                barCodeTextField(),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 60,
                        width: Get.width * 0.42,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: kColorLightGrey,
                            ),
                            color: kColorLightGrey,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: MaterialButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
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
                        height: 60,
                        width: Get.width * 0.42,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: kColorPrimary,
                            ),
                            color: kColorPrimary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: MaterialButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            controller.checkValidationsAndApiCall();
                          },
                          child: Center(
                              child: Text(
                            kLabelUpdate,
                            style: TextStyles.kTextH18WhiteBold500
                                .copyWith(color: kColorWhite),
                          )),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget productNameTextField() {
    return Focus(
      onFocusChange: (hasFocus) {
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 1);
        // if (controller.productNameController.text.trim().isNotEmpty) {
        controller.validateUserInput(fieldNumber: 1, isOnChange: false);
        // }
      },
      child: Obx(() {
        return Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 43,
                child: TextFormField(
                  controller: controller.productNameController,
                  maxLength: 20,
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
                    labelText: kLabelProductName,
                    counterText: '',
                    fillColor: kColorGreyF6,
                    filled: true,
                    alignLabelWithHint: true,
                    contentPadding:
                        const EdgeInsets.only(left: 14.0, bottom: 1, top: 11),
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
                    hintText: kLabelProductName,
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
      }),
    );
  }

  Widget categoryDropDown() {
    return GestureDetector(
      onTap: () {
        openBottomSheet(bottomSheetNumber: 1);
      },
      child: Container(
        height: 43,
        width: Get.width,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        // padding: EdgeInsets.only(left: 14, right: 8, bottom: 8, top: 8),
        // decoration: BoxDecoration(
        //     color: kColorGreyF6,
        //     borderRadius: BorderRadius.circular(10),
        //     border: Border.all(color: kColorLightGrey)),
        child: Obx(() {
          return TextFormField(
            enabled: false,
            controller: controller.categoryController,
            maxLength: 20,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            style: controller.selectedCategory.value.name == null
                ? TextStyles.kTextH14Grey96Bold400
                : TextStyles.kTextH14DarkGreyBold400,
            enableSuggestions: false,
            autocorrect: false,
            obscureText: false,
            decoration: InputDecoration(
              labelText: controller.selectedCategory.value.name == null
                  ? ''
                  : kLabelCategory,
              counterText: '',
              fillColor: kColorGreyF6,
              filled: true,
              isDense: true,
              alignLabelWithHint: true,
              contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 11, top: 11),
              suffixIcon: Padding(
                padding: EdgeInsets.only(left: 14, right: 9, bottom: 8, top: 8),
                child: SvgPicture.asset(kIconDropDown),
              ),
              labelStyle: TextStyles.kTextH14DarkGreyBold400,
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: kColorLightGrey, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              hintStyle: TextStyles.kTextH14Grey96Bold400,
              hintText: kLabelSelectCategory,
              focusColor: kColorPrimary,
            ),
          );
        }),
        //   DropdownButtonHideUnderline(
        //   child: DropdownButton2(
        //     // dropdownWidth: Get.width * 0.9,
        //     value: controller.selectedCategory.value,
        //     isDense: true,
        //     // hint: Obx(() {
        //     //   return Text(controller.selectedCategory.value.cateName ?? '');
        //     // }),
        //     onMenuStateChange: (isOpen) {
        //       controller.isCategoryDropdownOpen.value = isOpen;
        //     },
        //     icon: controller.isCategoryDropdownOpen.value
        //         ? SvgPicture.asset(kIconDropDownUp)
        //         : SvgPicture.asset(kIconDropDown),
        //     selectedItemBuilder: (context) {
        //       return controller.categoryList.map<Widget>(
        //             (element) {
        //           return Text(
        //             element.name ?? '',
        //             style: TextStyles.kTextH14DarkGreyBold400,
        //           );
        //         },
        //       ).toList();
        //     },
        //
        //     items: controller.categoryList
        //         .map<DropdownMenuItem<DropdownCommonData>>(
        //             (DropdownCommonData item) {
        //           return DropdownMenuItem<DropdownCommonData>(
        //             value: item,
        //             child: Row(
        //               children: [
        //                 item.id == controller.selectedCategory.value.id
        //                     ? SvgPicture.asset(kIconSelected)
        //                     : SvgPicture.asset(kIconUnSelected),
        //                 Padding(
        //                   padding: const EdgeInsets.only(left: 9),
        //                   child: Text(
        //                     item.name ?? '',
        //                     style: TextStyles.kTextH14DarkGreyBold400,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           );
        //         }).toList(),
        //     // controller.categoryList.map(
        //     //   (element) {
        //     //     return DropdownMenuItem(
        //     //       value: element,
        //     //       child: Row(
        //     //         children: [
        //     //           element.cateName ==
        //     //                   controller.selectedCategory.value.cateName
        //     //               ? SvgPicture.asset(kIconSelected)
        //     //               : SvgPicture.asset(kIconUnSelected),
        //     //           Text(
        //     //             element.cateName ?? '',
        //     //             style: TextStyles.kTextH14DarkGreyBold400,
        //     //           ),
        //     //         ],
        //     //       ),
        //     //     );
        //     //   },
        //     // ).toList(),
        //     onChanged: (value) {
        //       controller.selectedCategory.value = value!;
        //     },
        //   ),
        // );

        // Obx(
        //   () {
        //     return DropdownButtonHideUnderline(
        //       child: DropdownButton(
        //         hint: Obx(() {
        //           return Text(controller.selectedCategory.value.cateName ?? '');
        //         }),
        //         items: [],
        //         onChanged: (value) {},
        //       ),
        //     );
        //   },
        // ),
      ),
    );
  }

  Widget purchasePriceAndUnitContainer() {
    return Column(
      children: [
        Row(
          children: [
            purchasePriceTextField(),
            unitListContainer(),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              SizedBox(
                width: Get.width * 0.43,
                child: Obx(() {
                  return Visibility(
                    visible:
                        controller.purchasePriceController.text.isNotEmpty ||
                            controller.isValidPurchasePrice.value == false,
                    child: controller.purchasePriceStr.value == ''
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(left: 10, top: 2),
                            child: Text(controller.purchasePriceStr.value,
                                style: TextStyles.kTextH12Red)),
                  );
                }),
              ),
              SizedBox(
                width: Get.width * 0.45,
                child: Obx(() {
                  return Container(
                    width: Get.width * 0.45,
                    child: Visibility(
                      visible: controller.selectedUnits.value.name == null,
                      child: controller.unitStr.value == ''
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(left: 10, top: 2),
                              child: Text(controller.unitStr.value,
                                  style: TextStyles.kTextH12Red)),
                    ),
                  );
                }),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget purchasePriceTextField() {
    return Focus(
      onFocusChange: (hasFocus) {
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 2);
        // if (controller.purchasePriceController.text.trim().isNotEmpty) {
        controller.validateUserInput(fieldNumber: 2, isOnChange: false);
        // }
      },
      child: Obx(() {
        return Container(
          width: Get.width * 0.43,
          margin: const EdgeInsets.only(left: 20.0, top: 0), // top : 11
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 43,
                // margin: EdgeInsets.only(
                // bottom: controller.selectedUnits.value.name == null &&
                //         controller.purchasePriceStr.value != ''
                //     ? 0
                //     : 0,
                // ),
                child: TextFormField(
                  controller: controller.purchasePriceController,
                  maxLength: 50,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  // validator: (text) {
                  //   return TwoWaayFormValidation().validate(widget.fieldType, text);
                  // },
                  onChanged: (String value) {
                    controller.validateUserInput(fieldNumber: 2);
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegexData.digitAndPointRegex),
                  ],
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  style: TextStyles.kTextH14DarkGreyBold400,
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: false,

                  decoration: InputDecoration(
                    labelText: kLabelPurchasePrice,
                    counterText: '',
                    fillColor: kColorWhite,
                    filled: true,
                    alignLabelWithHint: true,
                    contentPadding:
                        const EdgeInsets.only(left: 14.0, bottom: 1, top: 11),
                    labelStyle: controller.isFocusOnPurchasePriceField.value ||
                            controller.purchasePriceController.text.isNotEmpty
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
                    hintText: kLabelPurchasePrice,
                    focusColor: kColorPrimary,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget unitListContainer() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(Get.overlayContext!).unfocus();
        openBottomSheet(bottomSheetNumber: 2);
      },
      child: Column(
        children: [
          Container(
            width: Get.width * 0.45,
            height: 43,
            margin: EdgeInsets.only(
              left: 9,
              // bottom: controller.purchasePriceStr.value == '' ? 20 : 0,
            ),
            child: Obx(() {
              return TextFormField(
                enabled: false,
                controller: controller.unitController,
                maxLength: 20,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                style: controller.selectedUnits.value.name == null
                    ? TextStyles.kTextH14Grey96Bold400
                    : TextStyles.kTextH14DarkGreyBold400,
                enableSuggestions: false,
                autocorrect: false,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: controller.selectedUnits.value.name == null
                      ? ''
                      : kLabelUnit,
                  counterText: '',
                  fillColor: kColorGreyF6,
                  filled: true,
                  isDense: true,
                  alignLabelWithHint: true,
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 11, top: 11),
                  suffixIcon: Padding(
                    padding:
                        EdgeInsets.only(left: 14, right: 9, bottom: 8, top: 8),
                    child: SvgPicture.asset(kIconDropDown),
                  ),
                  labelStyle: TextStyles.kTextH14DarkGreyBold400,
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: kColorLightGrey, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  hintStyle: TextStyles.kTextH14Grey96Bold400,
                  hintText: kLabelSelectUnit,
                  focusColor: kColorPrimary,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget sellingPriceAndTaxSwitchContainer() {
    return Container(
      // height: controller.sellingPriceStr.value != '' ? 80 : 58,
      margin: EdgeInsets.only(left: 16, right: 20, top: 11),
      padding: EdgeInsets.only(top: 0, bottom: 4, left: 4),
      decoration: BoxDecoration(
        color: kColorGreyF6,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              sellingPriceTextField(),
              taxSwitch(),
            ],
          ),
          Obx(() {
            return Visibility(
              visible: controller.sellingPriceController.text.isNotEmpty ||
                  controller.isValidSellingPrice.value == false,
              child: controller.sellingPriceStr.value == ''
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(left: 10, top: 2),
                      child: Text(controller.sellingPriceStr.value,
                          style: TextStyles.kTextH12Red)),
            );
          }),
        ],
      ),
    );
  }

  Widget sellingPriceTextField() {
    return Focus(
      onFocusChange: (hasFocus) {
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 3);
        // if (controller.sellingPriceController.text.trim().isNotEmpty) {
        controller.validateUserInput(fieldNumber: 3,isOnChange: false);
        // }
      },
      child: Obx(() {
        return SizedBox(
          width: Get.width * 0.43,
          // height:
          //     controller.sellingPriceStr.value != "" ? Get.height * 0.3 : 56,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 43,
                child: TextFormField(
                  controller: controller.sellingPriceController,
                  maxLength: 50,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (String value) {
                    controller.validateUserInput(fieldNumber: 3);
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegexData.digitAndPointRegex),
                  ],
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  style: TextStyles.kTextH14DarkGreyBold400,
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: kLabelSellingPrice,
                    counterText: '',
                    fillColor: kColorWhite,
                    filled: true,
                    alignLabelWithHint: true,
                    contentPadding:
                        const EdgeInsets.only(left: 14.0, bottom: 11, top: 11),
                    labelStyle: controller.isFocusOnSellingPriceField.value ||
                            controller.sellingPriceController.text.isNotEmpty
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
                    hintText: kLabelSellingPrice,
                    focusColor: kColorPrimary,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget taxSwitch() {
    return Padding(
      padding: EdgeInsets.only(
          // bottom: controller.sellingPriceStr.value != '' ? 20 : 0,
          ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            child: Obx(
              () {
                return CupertinoSwitch(
                  value: controller.isSellingTaxApplied.value,
                  onChanged: (value) {
                    controller.onTaxSwitchValueChanges(value);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              kLabelTaxInclude,
              style: TextStyles.kTextH12DarkGreyBold500,
            ),
          ),
        ],
      ),
    );
  }

  Widget hsnAndGstRateContainer() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          hsnCodeTextField(),
          gstRateContainer(),
        ],
      ),
    );
  }

  Widget hsnCodeTextField() {
    return Focus(
      onFocusChange: (hasFocus) {
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 4);
        // if (controller.hsnCodeController.text.trim().isNotEmpty) {
        controller.validateUserInput(fieldNumber: 4, isOnChange: false);
        // }
      },
      child: Obx(() {
        return Container(
          width: Get.width * 0.43,
          margin: const EdgeInsets.only(left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 42,
                child: TextFormField(
                  controller: controller.hsnCodeController,
                  maxLength: 15,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (String value) {
                    controller.validateUserInput(fieldNumber: 4);
                  },
                  // inputFormatters: <TextInputFormatter>[
                  //   FilteringTextInputFormatter.singleLineFormatter
                  // ],
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  style: TextStyles.kTextH14DarkGreyBold400,
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: kLabelHSNCode,
                    counterText: '',
                    fillColor: kColorGreyF6,
                    filled: true,
                    alignLabelWithHint: true,
                    contentPadding:
                        const EdgeInsets.only(left: 14.0, bottom: 11, top: 11),
                    labelStyle: controller.isFocusOnHSNCodeField.value ||
                            controller.hsnCodeController.text.isNotEmpty
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
                    hintText: kLabelHSNCode,
                    focusColor: kColorPrimary,
                  ),
                ),
              ),
              Obx(() {
                return Visibility(
                  visible: controller.hsnCodeController.text.isNotEmpty ||
                      controller.isValidHSNCode.value == false,
                  child: controller.hsnCodeStr.value == ''
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(left: 10, top: 2),
                          child: Text(controller.hsnCodeStr.value,
                              style: TextStyles.kTextH12Red)),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget gstRateContainer() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(Get.overlayContext!).unfocus();
        openBottomSheet(bottomSheetNumber: 3);
      },
      child: Container(
        width: Get.width * 0.45,
        // width: Get.width * 0.40,
        height: 43,
        margin: EdgeInsets.only(
          left: 9,
          right: 18,
        ),
        // padding: EdgeInsets.only(left: 14, right: 9, bottom: 8, top: 8),
        // decoration: BoxDecoration(
        //     color: kColorGreyF6,
        //     borderRadius: BorderRadius.circular(10),
        //     border: Border.all(color: kColorLightGrey)),
        child: Obx(() {
          return TextFormField(
            enabled: false,
            controller: controller.gstController,
            maxLength: 20,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            style: controller.selectedGST.value.value == null
                ? TextStyles.kTextH14Grey96Bold400
                : TextStyles.kTextH14DarkGreyBold400,
            enableSuggestions: false,
            autocorrect: false,
            obscureText: false,
            decoration: InputDecoration(
              labelText: controller.selectedGST.value.value == null
                  ? ''
                  : kLabelGSTRate,
              counterText: '',
              fillColor: kColorGreyF6,
              filled: true,
              isDense: true,
              alignLabelWithHint: true,
              contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 11, top: 11),
              suffixIcon: Padding(
                padding: EdgeInsets.only(left: 14, right: 9, bottom: 8, top: 8),
                child: SvgPicture.asset(kIconDropDown),
              ),
              labelStyle: TextStyles.kTextH14DarkGreyBold400,
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: kColorLightGrey, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              hintStyle: TextStyles.kTextH14Grey96Bold400,
              hintText: kLabelGSTRate,
              focusColor: kColorPrimary,
            ),
          );
        }),
        // Obx(
        //   () {
        //     return DropdownButtonHideUnderline(
        //       child: DropdownButton2(
        //         value: controller.selectedGST.value,
        //         onMenuStateChange: (isOpen) {
        //           controller.isGSTDropdownOpen.value = isOpen;
        //         },
        //         icon: controller.isGSTDropdownOpen.value
        //             ? SvgPicture.asset(kIconDropDownUp)
        //             : SvgPicture.asset(kIconDropDown),
        //         isDense: true,
        //         selectedItemBuilder: (context) {
        //           return controller.gstList.map<Widget>(
        //             (element) {
        //               return Text(
        //                 controller.isGstSelected.value
        //                     ? (element.value).toString()
        //                     : kLabelGSTRate ?? '',
        //                 style: TextStyles.kTextH14DarkGreyBold400,
        //               );
        //             },
        //           ).toList();
        //         },
        //         items: controller.gstList
        //             .map<DropdownMenuItem<DropdownCommonData>>(
        //                 (DropdownCommonData item) {
        //           return DropdownMenuItem<DropdownCommonData>(
        //             value: item,
        //             child: Row(
        //               children: [
        //                 controller.isGstSelected.value
        //                     ? item.id == controller.selectedGST.value.id
        //                         ? SvgPicture.asset(kIconSelected)
        //                         : SvgPicture.asset(kIconUnSelected)
        //                     : SvgPicture.asset(kIconUnSelected),
        //                 Padding(
        //                   padding: const EdgeInsets.only(left: 9),
        //                   child: Text(
        //                     (item.value).toString() ?? '',
        //                     style: TextStyles.kTextH14DarkGreyBold400,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           );
        //         }).toList(),
        //         onChanged: (value) {
        //           controller.selectedGST.value = value!;
        //           controller.isGstSelected.value = true;
        //         },
        //       ),
        //     );
        //   },
        // ),
      ),
    );
  }

  Widget barCodeTextField() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Focus(
                onFocusChange: (hasFocus) {
                  controller.changeFocus(hasFocus: hasFocus, fieldNumber: 5);
                  // if (controller.barCodeController.text.trim().isNotEmpty) {
                  controller.validateUserInput(fieldNumber: 5, isOnChange: false);
                  // }
                },
                child: Obx(() {
                  return Container(
                    width: Get.width * 0.77,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 43,
                          child: TextFormField(
                            controller: controller.barCodeController,
                            maxLength: 50,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            onChanged: (String value) {
                              controller.validateUserInput(fieldNumber: 5);
                            },
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            style: TextStyles.kTextH14DarkGreyBold400,
                            enableSuggestions: false,
                            autocorrect: false,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: kLabelBarcode,
                              counterText: '',
                              fillColor: kColorGreyF6,
                              filled: true,
                              alignLabelWithHint: true,
                              contentPadding: const EdgeInsets.only(
                                  left: 14.0, bottom: 1, top: 11),
                              labelStyle: controller.isFocusOnBarcodeField.value ||
                                      controller.barCodeController.text.isNotEmpty
                                  ? TextStyles.kTextH14DarkGreyBold400
                                  : TextStyles.kTextH14Grey96Bold400,
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: kColorDarkGrey3535, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: kColorLightGrey, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              hintStyle: TextStyles.kTextH14Grey96Bold400,
                              hintText: kLabelBarcode,
                              focusColor: kColorPrimary,
                            ),
                          ),
                        ),
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
                  padding: const EdgeInsets.only(left: 10, right: 18),
                  child: SvgPicture.asset(kIconBarcodeScanner),
                ),
              ),
            ],
          ),
          Obx(() {
            return Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Visibility(
                visible: controller.barCodeController.text.isNotEmpty ||
                    controller.isValidBarcode.value == false,
                child: controller.barCodeStr.value == ''
                    ? Container()
                    : Padding(
                    padding:
                    const EdgeInsets.only(left: 10, top: 2),
                    child: Text(controller.barCodeStr.value,
                        style: TextStyles.kTextH12Red)),
              ),
            );
          }),
        ],
      ),
    );
  }
  Future<void> openBarCodeScanner() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#202A43', kLabelCancel, true, ScanMode.BARCODE);
      controller.setBarCodeValueToController(barcodeScanRes: barcodeScanRes);
    } catch (e) {
      LoggerUtils.logException('openBarCodeScanner', e);
    }
  }

  void showDeleteDialog() {
    // showDialog(
    //   context: Get.overlayContext!,
    //   builder: (context) {
    //     return
    showConfirmDialogBox(
      title: '',
      message:
          '$kAreYouSureToRemove ${controller.productData.value.name?.trim()} ?',
      negativeButtonTitle: kLabelCancel,
      negativeClicked: () {
        Get.back();
      },
      positiveButtonTitle: kLabelDelete,
      positiveClicked: () {
        Get.back();
        controller.deleteServiceApiCall();
      },
    );
    // },
    // );
  }



  openBottomSheet({required int bottomSheetNumber}) {
    /// 1 : category , 2 : units , 3 : gstRate
    String label = bottomSheetNumber == 1
        ? ''
        : bottomSheetNumber == 2
            ? kLabelSelectUnit
            : kLabelSelectGSTRate;
    Get.bottomSheet(
      GestureDetector(
        onTap: () {
          FocusScope.of(Get.overlayContext!).unfocus();
        },
        child: Container(
          height: bottomSheetNumber == 1 ? 400 : 250,
          color: kColorWhite,
          padding: EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    controller.createCategoryController.text = '';
                    controller.createCatValue.value = '';
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: SvgPicture.asset(kIconClosePrimary)),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: bottomSheetNumber == 1,
                      child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: kColorGreyF6,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.only(top: 26),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 36,
                                child: Obx(() {
                                  return TextFormField(
                                    controller:
                                        controller.createCategoryController,
                                    maxLength: 15,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    onChanged: (String value) {
                                      if (value.trim().isNotEmpty) {
                                        controller.createCatValue.value = value;
                                      } else {
                                        controller.createCatValue.value = '';
                                      }
                                      controller.validateUserInput(
                                          fieldNumber: 1);
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegexData.addressRegex),
                                    ],
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    style: TextStyles.kTextH14DarkGreyBold400,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      suffixIcon: controller
                                              .createCatValue.value.isEmpty
                                          ? Text('')
                                          : GestureDetector(
                                              onTap: () {
                                                controller
                                                    .createCategoryController
                                                    .text = '';
                                                controller
                                                    .createCatValue.value = '';
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
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
                                      // labelText: kLabelCreateNewCategory,
                                      counterText: '',
                                      fillColor: kColorGreyF6,
                                      filled: true,
                                      alignLabelWithHint: true,
                                      // isDense: true,
                                      contentPadding:
                                          EdgeInsets.only(left: 14.0),
                                      labelStyle:
                                          TextStyles.kTextH14DarkGreyBold400,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      hintStyle:
                                          TextStyles.kTextH14Grey96Bold400,
                                      hintText: kLabelCreateNewCategory,
                                      focusColor: kColorPrimary,
                                    ),
                                  );
                                }),
                              ),
                            ),
                            Container(
                              height: 36,
                              width: Get.width * 0.2,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: kColorPrimary,
                                  ),
                                  color: kColorPrimary,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: MaterialButton(
                                onPressed: () {
                                  FocusScope.of(Get.overlayContext!).unfocus();
                                  if (controller.createCategoryController.text
                                      .trim()
                                      .isNotEmpty) {
                                    controller.createCategoryApiCall();
                                  }
                                },
                                child: Center(
                                    child: Text(
                                  kLabelAdd,
                                  style: TextStyles.kTextH14WhiteBold400
                                      .copyWith(color: kColorWhite),
                                )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(label, style: TextStyles.kTextH16Primary600),
                    ),
                    Container(
                      height: bottomSheetNumber == 1 ? 220 : 150,
                      child: SingleChildScrollView(
                        child: Obx(() {
                          return controller.isDataLoading.value
                              ? Container()
                              : Wrap(
                                  spacing: 8,
                                  children: bottomSheetNumber == 1
                                      ? categoryChips()
                                      : bottomSheetNumber == 2
                                          ? unitsChips()
                                          : gstRateChips(),
                                );
                        }),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> unitsChips() {
    List<Widget> widgets = [];
    for (int i = 0; i < controller.unitList.length; i++) {
      Widget chips = Obx(() {
        return FilterChip(
          selectedColor: kColorPrimary,
          showCheckmark: false,
          selected: controller.unitList[i].isSelected == true,
          elevation: 0.4,
          backgroundColor: kColorWhite,
          shadowColor: kColorDarkGreyAFAFAF,
          label: Text(controller.unitList[i].name ?? '',
              style: controller.unitList[i].isSelected == true
                  ? TextStyles.kTextH14WhiteBold400
                  : TextStyles.kTextH14DarkGreyBold400),
          onSelected: (value) {
            controller.updateUnitStatus(i: i);
          },
        );
      });
      widgets.add(chips);
    }
    return widgets;
  }

  List<Widget> categoryChips() {
    List<Widget> widgets = [];
    if (controller.categoryList.isNotEmpty) {
      for (int i = 0; i < controller.categoryList.length; i++) {
        Widget chips = Obx(() {
          return FilterChip(
            selectedColor: kColorPrimary,
            showCheckmark: false,
            selected: controller.categoryList[i].isSelected == true,
            elevation: 0.4,
            backgroundColor: kColorWhite,
            shadowColor: kColorDarkGreyAFAFAF,
            label: Text(controller.categoryList[i].name ?? '',
                style: controller.categoryList[i].isSelected == true
                    ? TextStyles.kTextH14WhiteBold400
                    : TextStyles.kTextH14DarkGreyBold400),
            onSelected: (value) {
              controller.updateCategoryStatus(i: i);
            },
          );
        });
        widgets.add(chips);
      }
    } else {
      return [];
    }
    return widgets;
  }

  List<Widget> gstRateChips() {
    List<Widget> widgets = [];

    for (int i = 0; i < controller.gstList.length; i++) {
      Widget chips = Obx(() {
        return FilterChip(
          selectedColor: kColorPrimary,
          showCheckmark: false,
          selected: controller.gstList[i].isSelected == true,
          elevation: 0.4,
          backgroundColor: kColorWhite,
          shadowColor: kColorDarkGreyAFAFAF,
          label: Text('${controller.gstList[i].value ?? ''} %',
              style: controller.gstList[i].isSelected == true
                  ? TextStyles.kTextH14WhiteBold400
                  : TextStyles.kTextH14DarkGreyBold400),
          onSelected: (value) {
            controller.updateGSTStatus(i: i);
          },
        );
      });
      widgets.add(chips);
    }
    return widgets;
  }
}
