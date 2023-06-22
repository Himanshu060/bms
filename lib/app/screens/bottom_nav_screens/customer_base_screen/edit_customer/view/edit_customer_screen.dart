import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/image_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/customer_base_screen/edit_customer/controller/edit_customer_controller.dart';
import 'package:bms/app/utils/regex.dart';
import 'package:bms/app/utils/text_styles.dart';
import 'package:bms/app/widgets/appBar/app_bar_with_back_button.dart';
import 'package:bms/app/widgets/buttons/primary_button.dart';
import 'package:bms/app/widgets/dialogs/show_confirm_dialog_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class EditCustomerScreen extends GetView<EditCustomerController> {
  EditCustomerScreen({Key? key}) : super(key: key) {
    final intentData = Get.arguments;
    controller.setIntentData(intentData: intentData);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBarWithBackButton(
          title: kLabelEditCustomer,
          isShowLeadingIcon: true,
          isShowActionWidgets: true,
          result: const [null],
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
        body: Obx(() {
          return SingleChildScrollView(
            child: controller.isDataLoading.value
                ? Container()
                : SizedBox(
                    height: Get.height * 0.88,
                    child: Column(
                      children: [
                        customerNameTextField(),
                        customerContactNumberTextField(),
                        customerEmailTextField(),
                        customerGstNoTextField(),
                        customerAddressTextField(),
                        customerPinCodeTextField(),
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: MaterialButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    Get.back(result: [null]);
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: MaterialButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    controller.checkRegexValidation();
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
          );
        }),
      ),
    );
  }

  Widget customerNameTextField() {
    return Focus(
      onFocusChange: (hasFocus) {
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 1);
        if (controller.customerNameController.text.trim().isNotEmpty) {
          controller.validateUserInput(fieldNumber: 1);
        }
      },
      child: Obx(() {
        return Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60,
                child: TextFormField(
                  controller: controller.customerNameController,
                  maxLength: 25,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  // validator: (text) {
                  //   return TwoWaayFormValidation().validate(widget.fieldType, text);
                  // },
                  onChanged: (String value) {
                    controller.validateUserInput(fieldNumber: 1);
                  },
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  style: TextStyles.kTextH14DarkGreyBold400,
                  enableSuggestions: false,
                  // buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                  autocorrect: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: kLabelCustomersName,
                    counterText: '',
                    contentPadding: const EdgeInsets.only(left: 28.0, bottom: 20, top: 19),
                    isCollapsed: true,
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
                      borderSide: BorderSide(color: kColorLightGrey, width: 1.0),
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
                      controller.isValidName.value == false,
                  child: controller.customerNameStr.value == ''
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(left: 10, top: 2),
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
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 2);
      },
      child: Obx(() {
        return Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60,
                child: TextFormField(
                  controller: controller.customerMobileNumberController,
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
                        FocusScope.of(Get.context!).unfocus();
                        controller.navigateToImportContactsScreen();
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 18, bottom: 18, right: 14),
                        child: SvgPicture.asset(kIconAddUserContact),
                      ),
                    ),
                    contentPadding:const EdgeInsets.only(left: 28.0, bottom: 20, top: 19),
                    isCollapsed: true,
                    counterText: '',
                    labelStyle: controller.isFocusOnCustomerNumberField.value ||
                            controller
                                .customerMobileNumberController.text.isNotEmpty
                        ? TextStyles.kTextH14DarkGreyBold400
                        : TextStyles.kTextH14GreyBold400,
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kColorDarkGrey3535, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: kColorLightGrey, width: 1.0),
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
                  visible: controller
                          .customerMobileNumberController.text.isNotEmpty ||
                      controller.isValidPhoneNumber.value == false,
                  child: controller.customerMobileStr.value == ''
                      ? Container():Padding(
                      padding: const EdgeInsets.only(left: 10, top: 2),
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
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 3);
        controller.validateUserInput(fieldNumber: 3, isOnChange: false);
      },
      child: Obx(() {
        return Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60,
                child: TextFormField(
                  maxLength: 50,
                  controller: controller.customerEmailIdController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  // validator: (text) {
                  //   return TwoWaayFormValidation().validate(widget.fieldType, text);
                  // },
                  onChanged: (String value) {
                    controller.validateUserInput(fieldNumber: 3);
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: TextStyles.kTextH14DarkGreyBold400,
                  enableSuggestions: false,
                  // buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                  autocorrect: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: kLabelEmail,
                    contentPadding:const EdgeInsets.only(left: 28.0, bottom: 20, top: 19),
                    isCollapsed: true,
                    counterText: '',
                    labelStyle: controller.isFocusOnCustomerEmailIdField.value ||
                            controller.customerEmailIdController.text.isNotEmpty
                        ? TextStyles.kTextH14DarkGreyBold400
                        : TextStyles.kTextH14GreyBold400,
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kColorDarkGrey3535, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: kColorLightGrey, width: 1.0),
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
                      padding: const EdgeInsets.only(left: 10, top: 2),
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

  Widget customerGstNoTextField() {
    return Focus(
      onFocusChange: (hasFocus) {
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 6);
        controller.validateUserInput(fieldNumber: 6, isOnChange: false);
      },
      child: Obx(() {
        return Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height:
                60,
                child: TextFormField(
                  maxLength: 15,
                  controller: controller.customerGstNoController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (String value) {
                    controller.validateUserInput(fieldNumber: 6);
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
                    labelText: kLabelGSTNo,
                    contentPadding: const EdgeInsets.only(left: 28.0, bottom: 20, top: 19),
                    isCollapsed: true,
                    counterText: '',
                    labelStyle: controller.isFocusOnCustomerGstNoField.value ||
                            controller.customerGstNoController.text.isNotEmpty
                        ? TextStyles.kTextH14DarkGreyBold400
                        : TextStyles.kTextH14GreyBold400,
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kColorDarkGrey3535, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: kColorLightGrey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    hintStyle: TextStyles.kTextH14GreyBold600,
                    hintText: kLabelGSTNo,
                    focusColor: kColorPrimary,
                  ),
                ),
              ),
              Obx(() {
                return Visibility(
                  visible: controller.customerGstNoController.text.isNotEmpty ||
                      controller.isValidGstNo.value == false,
                  child: controller.customerGstStr.value == ''
                      ? Container()
                      : Padding(
                      padding: const EdgeInsets.only(left: 10, top: 2),
                      child: Text(controller.customerGstStr.value,
                          style: TextStyles.kTextH12Red)),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget customerAddressTextField() {
    return Focus(
      onFocusChange: (hasFocus) {
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 4);
        controller.validateUserInput(fieldNumber: 4, isOnChange: false);
      },
      child: Obx(() {
        return Container(
          margin: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                // height: 114,
                child: TextFormField(
                  maxLength: 100,
                  maxLines: 4,
                  controller: controller.customerAddressController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  // validator: (text) {
                  //   return TwoWaayFormValidation().validate(widget.fieldType, text);
                  // },
                  onChanged: (String value) {
                    controller.validateUserInput(fieldNumber: 4);
                  },
                  keyboardType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.next,
                  style: TextStyles.kTextH14DarkGreyBold400,
                  enableSuggestions: false,
                  // buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                  autocorrect: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    labelText: kLabelAddress,
                    contentPadding: const EdgeInsets.only(
                        left: 28.0,  top: 20),
                    isCollapsed: true,
                    counterText: '',
                    labelStyle: controller.isFocusOnCustomerAddressField.value ||
                            controller.customerAddressController.text.isNotEmpty
                        ? TextStyles.kTextH14DarkGreyBold400
                        : TextStyles.kTextH14GreyBold400,
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kColorDarkGrey3535, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: kColorLightGrey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    hintStyle: TextStyles.kTextH14GreyBold600,
                    hintText: kLabelAddress,
                    focusColor: kColorPrimary,
                  ),
                ),
              ),
              Obx(() {
                return Visibility(
                  visible:
                      controller.customerAddressController.text.isNotEmpty ||
                          controller.isValidAddress.value == false,
                  child: controller.customerAddressStr.value == ''
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(left: 10, top: 2),
                          child: Text(controller.customerAddressStr.value,
                              style: TextStyles.kTextH12Red)),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget customerPinCodeTextField() {
    return Focus(
      onFocusChange: (hasFocus) {
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 5);
        controller.validateUserInput(fieldNumber: 5, isOnChange: false);
      },
      child: Obx(() {
        return Container(
          margin: const EdgeInsets.only(left: 18.0, right: 20.0, top: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60,
                child: TextFormField(
                  maxLength: 6,
                  controller: controller.customerPinCodeController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  // validator: (text) {
                  //   return TwoWaayFormValidation().validate(widget.fieldType, text);
                  // },
                  onChanged: (String value) {
                    if (value.isNotEmpty) {
                      controller.validateUserInput(fieldNumber: 5);
                    }
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
                    labelText: kLabelPinCode,
                    contentPadding: const EdgeInsets.only(left: 28.0, bottom: 20, top: 19),
                    isCollapsed: true,
                    counterText: '',
                    labelStyle: controller.isFocusOnCustomerPinCodeField.value ||
                            controller.customerPinCodeController.text.isNotEmpty
                        ? TextStyles.kTextH14DarkGreyBold400
                        : TextStyles.kTextH14GreyBold400,
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kColorDarkGrey3535, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: kColorLightGrey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    hintStyle: TextStyles.kTextH14GreyBold600,
                    hintText: kLabelPinCode,
                    focusColor: kColorPrimary,
                  ),
                ),
              ),
              Obx(() {
                return Visibility(
                  visible:
                      controller.customerPinCodeController.text.isNotEmpty ||
                          controller.isValidPinCode.value == false,
                  child: controller.customerPinCodeStr.value == ''
                      ? Container()
                      :  Padding(
                      padding: const EdgeInsets.only(left: 10, top: 2),
                      child: Text(controller.customerPinCodeStr.value,
                          style: TextStyles.kTextH12Red)),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  void showDeleteDialog() {
    // showDialog(
    //   context: Get.overlayContext!,
    //   builder: (context) {
    //     return
          showConfirmDialogBox(
            title: '',
            message:
                '$kAreYouSureToRemove ${controller.customerNameController.text.trim()} ?',
            negativeButtonTitle: kLabelCancel,
            negativeClicked: () {
              Get.back();
            },
            positiveButtonTitle: kLabelDelete,
            positiveClicked: () {
              Get.back();
              controller.deleteCustomerApiCall();
            },
            );
      // },
    // );
  }
}
