import 'dart:io';

import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/image_constants.dart';
import 'package:bms/app/screens/authentication/business_sign_up/controller/business_sign_up_controller.dart';
import 'package:bms/app/screens/bottom_navigation/base/model/response/drop_down_common_data.dart';
import 'package:bms/app/utils/text_styles.dart';
import 'package:bms/app/widgets/appBar/app_bar_with_back_button.dart';
import 'package:bms/app/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class BusinessSignUpScreen extends GetView<BusinessSignUpController> {
  BusinessSignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBackButton(
          title: kLabelBusinessDetails, isShowLeadingIcon: false),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// signup graphics
                Padding(
                  padding: const EdgeInsets.only(left: 26, right: 26),
                  child: Center(
                    child: SvgPicture.asset(kImgSignUpImage),
                  ),
                ),

                /// signup text label
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 21),
                  child: Text(
                    kLabelSignUp,
                    style: TextStyles.kTextH30PrimaryBold600,
                  ),
                ),

                Column(
                  children: [
                    businessNameTextField(),
                    businessContactNumberTextField(),
                    businessEmailTextField(),
                    gstNumberTextField(),
                    logoAndSignatureContainer(context),
                    stateTextField(),
                    Row(
                      children: [
                        cityTextField(),
                        pinCodeTextField(),
                      ],
                    ),
                    addressTextField(),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 23),
                  child: PrimaryButtonWidget(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        // if (controller.isButtonEnable.value) {
                        controller.checkLogoOrSignatureSelected();
                        // }
                        // controller.navigateToBottomNavBaseScreen();
                      },
                      color: kColorPrimary,
                      buttonTitle: kLabelSignUpWithDash),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget gstNumberTextField() {
    return Focus(
      onFocusChange: (hasFocus) {
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 4);
        controller.validateUserInput(fieldNumber: 4, isOnChange: false);
      },
      child: Obx(() {
        return Container(
          margin: controller.textFieldsMargin,
          child: Column(
            children: [
              SizedBox(
                height: controller.textFieldsHeight.value,
                child: TextFormField(
                  maxLength: 15,
                  controller: controller.gstNumberController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  // validator: (text) {
                  //   return TwoWaayFormValidation().validate(widget.fieldType, text);
                  // },
                  onChanged: (String value) {
                    controller.validateUserInput(fieldNumber: 4);
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: TextStyles.kTextH14DarkGreyBold400,
                  enableSuggestions: false,
                  // buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                  autocorrect: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: kLabelGSTNo,
                    contentPadding: const EdgeInsets.only(
                        left: 28.0, right: 46.0, bottom: 19, top: 20),
                    counterText: '',
                    labelStyle: controller.isFocusOnGstNumberField.value ||
                        controller.gstNumberController.text.isNotEmpty
                        ? TextStyles.kTextH14DarkGreyBold400
                        : TextStyles.kTextH14GreyBold600,
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
                    hintText: kLabelGSTNo,
                    focusColor: kColorPrimary,
                  ),
                ),
              ),
              Obx(() {
                return Visibility(
                  visible: controller.gstNumberController.text.isNotEmpty &&
                      controller.isValidGstNo.value == false,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 10, top: 2),
                      child: Text(controller.gstNoStr.value,
                          style: TextStyles.kTextH12Red)),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget businessNameTextField() {
    return Focus(
      onFocusChange: (hasFocus) {
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 1);
        // if (controller.businessNameController.text.trim().isNotEmpty) {
        controller.validateUserInput(fieldNumber: 1, isOnChange: false);
        // }
      },
      child: Obx(() {
        return Container(
          margin: controller.textFieldsMargin,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: controller.textFieldsHeight.value,
                child: TextFormField(
                  controller: controller.businessNameController,
                  maxLength: 35,
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
                    labelText: kLabelBusinessName,
                    counterText: '',
                    contentPadding:
                    const EdgeInsets.only(left: 28.0, bottom: 19, top: 20),
                    labelStyle: controller.isFocusOnBusinessNameField.value ||
                        controller.businessNameController.text.isNotEmpty
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
                    hintText: kLabelBusinessName,
                    focusColor: kColorPrimary,
                  ),
                ),
              ),
              Obx(() {
                return Visibility(
                  visible: controller.businessNameController.text.isNotEmpty ||
                      controller.isValidName.value == false,
                  child: controller.nameStr.value == ''
                      ? Container()
                      : Padding(
                      padding: const EdgeInsets.only(left: 10, top: 2),
                      child: Text(controller.nameStr.value,
                          style: TextStyles.kTextH12Red)),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget businessContactNumberTextField() {
    return Focus(
      onFocusChange: (hasFocus) {
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 2);
        controller.validateUserInput(fieldNumber: 2, isOnChange: false);
      },
      child: Obx(() {
        return Container(
          margin: controller.textFieldsMargin,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: controller.textFieldsHeight.value,
                child: TextFormField(
                  controller: controller.businessMobileNumberController,
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
                    labelText: kLabelBusinessContactNo,
                    contentPadding:
                    const EdgeInsets.only(left: 28.0, bottom: 19, top: 20),
                    counterText: '',
                    labelStyle:
                    controller.isFocusOnBusinessContactNumberField.value ||
                        controller.businessMobileNumberController.text
                            .isNotEmpty
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
                    hintText: kLabelBusinessContactNo,
                    focusColor: kColorPrimary,
                  ),
                ),
              ),
              Obx(() {
                return Visibility(
                  visible: controller
                      .businessMobileNumberController.text.isNotEmpty ||
                      controller.isValidPhoneNumber.value == false,
                  child: controller.mobileStr.value == ''
                      ? Container()
                      : Padding(
                      padding: const EdgeInsets.only(left: 10, top: 2),
                      child: Text(controller.mobileStr.value,
                          style: TextStyles.kTextH12Red)),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget businessEmailTextField() {
    return Focus(
      onFocusChange: (hasFocus) {
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 3);
        controller.validateUserInput(fieldNumber: 3, isOnChange: false);
      },
      child: Obx(() {
        return Container(
          margin: controller.textFieldsMargin,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: controller.textFieldsHeight.value,
                child: TextFormField(
                  maxLength: 50,
                  controller: controller.businessEmailIdController,
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
                    labelText: kLabelBusinessEmail,
                    contentPadding:
                    const EdgeInsets.only(left: 28.0, bottom: 19, top: 20),
                    counterText: '',
                    labelStyle: controller.isFocusOnBusinessMailField.value ||
                        controller.businessEmailIdController.text.isNotEmpty
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
                    hintText: kLabelBusinessEmail,
                    focusColor: kColorPrimary,
                  ),
                ),
              ),
              Obx(() {
                return Visibility(
                  visible:
                  controller.businessEmailIdController.text.isNotEmpty ||
                      controller.isValidEmailId.value == false,
                  child: controller.emailStr.value == ''
                      ? Container()
                      : Padding(
                      padding: const EdgeInsets.only(left: 10, top: 2),
                      child: Text(controller.emailStr.value,
                          style: TextStyles.kTextH12Red)),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget stateTextField() {
    return Focus(
        onFocusChange: (hasFocus) {
          controller.changeFocus(hasFocus: hasFocus, fieldNumber: 5);
        },
        child: Container(
          margin: controller.textFieldsMargin,
          height: controller.textFieldsHeight.value,
          child: FormField(
            builder: (field) {
              // return DropdownButtonFormField(
              //   value: controller.stateList[0],
              //   items: controller.stateList.map((element) {
              //     return DropdownMenuItem(
              //         value: element,
              //         child: Row(
              //       children: <Widget>[
              //         Icon(Icons.star),
              //         Text(element.name ?? ''),
              //       ],
              //     ));
              //   }).toList(),
              //   onChanged: (value) {},
              // );
              return Obx(() {
                return InputDecorator(
                  decoration:  InputDecoration(
                    labelText: kLabelState,
                    labelStyle: TextStyles.kTextH14DarkGreyBold400,
                    isDense: false,
                    filled: true,
                    fillColor: kColorWhite,
                    contentPadding: controller.textFieldsMargin,
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                      BorderSide(color: kColorDarkGrey3535, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kColorLightGrey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    disabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kColorLightGrey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<DropdownCommonData>(
                      value: controller.selectedState.value,
                      isDense: true,
                      isExpanded: true,
                      style: controller.selectedState.value.id==0?TextStyles.kTextH14GreyBold400: TextStyles.kTextH14DarkGreyBold400,
                      items: controller.stateList.map((element) {
                        return DropdownMenuItem<DropdownCommonData>(
                          value: element,
                          child: Text(element.name ?? '',
                            style:TextStyles.kTextH14DarkGreyBold400,),
                        );
                      }).toList(),
                      onChanged: (value) {
                        controller.selectedState.value = value!;
                        controller.getCityBasedOnStateSelection();
                      },
                    ),
                  ),
                );
              });
            },
          ),
          // SizedBox(
          //   height: controller.textFieldsHeight.value,
          //   child: TextFormField(
          //     maxLength: 100,
          //     controller: controller.stateController,
          //     autovalidateMode: AutovalidateMode.onUserInteraction,
          //     // validator: (text) {
          //     //   return TwoWaayFormValidation().validate(widget.fieldType, text);
          //     // },
          //     onChanged: (String value) {
          //       // controller.validateUserInput();
          //     },
          //     keyboardType: TextInputType.emailAddress,
          //     textInputAction: TextInputAction.next,
          //     style: TextStyles.kTextH14DarkGreyBold400,
          //     enableSuggestions: false,
          //     // buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
          //     autocorrect: false,
          //     obscureText: false,
          //     decoration: InputDecoration(
          //       labelText: kLabelState,
          //       contentPadding:
          //           const EdgeInsets.only(left: 28.0, bottom: 19, top: 20),
          //       counterText: '',
          //       labelStyle: controller.isFocusOnStateField.value ||
          //               controller.stateController.text.isNotEmpty
          //           ? TextStyles.kTextH14DarkGreyBold400
          //           : TextStyles.kTextH14GreyBold400,
          //       focusedBorder: const OutlineInputBorder(
          //         borderSide: BorderSide(color: kColorDarkGrey3535, width: 1.0),
          //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
          //       ),
          //       enabledBorder: const OutlineInputBorder(
          //         borderSide: BorderSide(color: kColorLightGrey, width: 1.0),
          //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
          //       ),
          //       hintStyle: TextStyles.kTextH14GreyBold600,
          //       hintText: kLabelState,
          //       focusColor: kColorPrimary,
          //     ),
          //   ),
          // ),
        )

    );
  }

  Widget cityTextField() {
    return
      // Focus(
      // onFocusChange: (hasFocus) {
      //   controller.changeFocus(hasFocus: hasFocus, fieldNumber: 6);
      // },
      // child:
      Obx(
            () {
          return IgnorePointer(
            ignoring: controller.selectedState.value.id==0,
            child: Container(
              height: controller.textFieldsHeight.value,
              width: Get.width * 0.55,
              margin: EdgeInsets.only(
                  left: 20.0,
                  top: 12.0,
                  bottom: controller.pinCodeStr.value == "" ? 0.0 : 20),
              child: FormField(
                builder: (field) {
                  // return DropdownButtonFormField(
                  //   value: controller.stateList[0],
                  //   items: controller.stateList.map((element) {
                  //     return DropdownMenuItem(
                  //         value: element,
                  //         child: Row(
                  //       children: <Widget>[
                  //         Icon(Icons.star),
                  //         Text(element.name ?? ''),
                  //       ],
                  //     ));
                  //   }).toList(),
                  //   onChanged: (value) {},
                  // );
                  return InputDecorator(
                    decoration:  InputDecoration(
                      labelText: kLabelCity,
                      labelStyle: TextStyles.kTextH14DarkGreyBold400,
                      filled: true,
                      fillColor: kColorWhite,
                      contentPadding: controller.textFieldsMargin,
                      focusedBorder:const OutlineInputBorder(
                        borderSide:
                        BorderSide(color: kColorDarkGrey3535, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      enabledBorder:const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: kColorLightGrey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      disabledBorder:const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: kColorLightGrey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<DropdownCommonData>(
                        value: controller.selectedCity.value,
                        isDense: true,
                        isExpanded: true,
                        items: controller.cityList.map((element) {
                          return DropdownMenuItem<DropdownCommonData>(
                            value: element,
                            child: Text(element.name ?? '',
                              style:  controller.selectedState.value.id==0?TextStyles.kTextH14GreyBold400:TextStyles.kTextH14DarkGreyBold400,),
                          );
                        }).toList(),
                        onChanged: (value) {
                          controller.selectedCity.value = value!;
                        },
                      ),
                    ),
                  );
                },
              ),
              // SizedBox(
              //   height: controller.textFieldsHeight.value,
              //   child: TextFormField(
              //     enabled: false,
              //     maxLength: 100,
              //     controller: controller.cityController,
              //     autovalidateMode: AutovalidateMode.onUserInteraction,
              //     // validator: (text) {
              //     //   return TwoWaayFormValidation().validate(widget.fieldType, text);
              //     // },
              //     onChanged: (String value) {
              //       // controller.validateUserInput();
              //     },
              //     keyboardType: TextInputType.emailAddress,
              //     textInputAction: TextInputAction.next,
              //     style: TextStyles.kTextH14DarkGreyBold400,
              //     enableSuggestions: false,
              //     // buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
              //     autocorrect: false,
              //     obscureText: false,
              //     decoration: InputDecoration(
              //       labelText: kLabelCity,
              //       contentPadding:
              //           const EdgeInsets.only(left: 28.0, bottom: 19, top: 20),
              //       counterText: '',
              //       labelStyle: controller.isFocusOnCityField.value ||
              //               controller.cityController.text.isNotEmpty
              //           ? TextStyles.kTextH14DarkGreyBold400
              //           : TextStyles.kTextH14GreyBold400,
              //       focusedBorder: const OutlineInputBorder(
              //         borderSide: BorderSide(color: kColorDarkGrey3535, width: 1.0),
              //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //       ),
              //       enabledBorder: const OutlineInputBorder(
              //         borderSide: BorderSide(color: kColorLightGrey, width: 1.0),
              //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //       ),
              //       disabledBorder: const OutlineInputBorder(
              //         borderSide: BorderSide(color: kColorLightGrey, width: 1.0),
              //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //       ),
              //       hintStyle: TextStyles.kTextH14GreyBold600,
              //       hintText: kLabelCity,
              //       focusColor: kColorPrimary,
              //     ),
              //   ),
              // ),
            ),
          );
        },
      );
    // );
  }

  Widget pinCodeTextField() {
    return Focus(
      onFocusChange: (hasFocus) {
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 7);
        controller.validateUserInput(fieldNumber: 5, isOnChange: false);
      },
      child: Obx(() {
        return Container(
          width: Get.width * 0.3,
          margin: const EdgeInsets.only(left: 18.0, right: 20.0, top: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: controller.textFieldsHeight.value,
                child: TextFormField(
                  maxLength: 6,
                  controller: controller.pinCodeController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (String value) {
                    controller.validateUserInput(fieldNumber: 5);
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
                    contentPadding:
                    const EdgeInsets.only(left: 28.0, bottom: 19, top: 0),
                    counterText: '',
                    labelStyle: controller.isFocusOnPinCodeField.value ||
                        controller.pinCodeController.text.isNotEmpty
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
                    hintText: kLabelPinCode,
                    focusColor: kColorPrimary,
                  ),
                ),
              ),
              Obx(() {
                return Visibility(
                  visible: controller.pinCodeController.text.isNotEmpty &&
                      controller.isValidPinCode.value == false,
                  child: controller.pinCodeStr.value == ''
                      ? Container()
                      : Padding(
                      padding: const EdgeInsets.only(left: 10, top: 2),
                      child: Text(controller.pinCodeStr.value,
                          style: TextStyles.kTextH12Red)),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget addressTextField() {
    return Focus(
      onFocusChange: (hasFocus) {
        controller.changeFocus(hasFocus: hasFocus, fieldNumber: 8);
        controller.validateUserInput(fieldNumber: 6, isOnChange: false);
      },
      child: Obx(() {
        return Container(
          margin: controller.textFieldsMargin,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                maxLength: 100,
                maxLines: 4,
                controller: controller.addressController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (String value) {
                  controller.validateUserInput(fieldNumber: 6);
                },
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                style: TextStyles.kTextH14DarkGreyBold400,
                enableSuggestions: false,
                autocorrect: false,
                obscureText: false,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: kLabelAddress,
                  contentPadding: const EdgeInsets.only(left: 28.0, top: 20),
                  counterText: '',
                  labelStyle: controller.isFocusOnAddressField.value ||
                      controller.addressController.text.isNotEmpty
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
              Obx(() {
                return Visibility(
                  visible: controller.addressController.text.isNotEmpty ||
                      controller.isValidAddress.value == false,
                  child: controller.addressStr.value == ''
                      ? Container()
                      : Padding(
                      padding: const EdgeInsets.only(left: 10, top: 2),
                      child: Text(controller.addressStr.value,
                          style: TextStyles.kTextH12Red)),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget logoAndSignatureContainer(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.only(left: 22, right: 22, top: 22),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                showImageOptions(isImagePickerForLogo: true);
              },
              child: controller.isBusinessLogoSet.value
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 60,
                  width: 60,
                  child: Image.file(
                    File(controller.businessLogo.value.path),
                    fit: BoxFit.cover,
                  ),
                ),
              )
                  : SvgPicture.asset(kImgBusinessLogo),
            ),
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                showImageOptions(isImagePickerForLogo: false);
              },
              child: controller.isBusinessSignatureSet.value
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 60,
                  width: 272,
                  child: Image.file(
                    File(controller.businessSignature.value.path),
                    fit: BoxFit.fill,
                  ),
                ),
              )
                  : SvgPicture.asset(kImgSignatureImage),
            )
          ],
        ),
      );
    });
  }

  void showImageOptions({required bool isImagePickerForLogo}) {
    Get.bottomSheet(
      IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [

              /// First row, Gallery
              ImagePickerOptionsWidget(
                title: 'Select from gallery',
                // svgIcon: kIconAttachmentGallery,
                // subTitle: '',
                onClick: () {
                  controller.imagePicker(ImageSource.gallery,
                      isImagePickerForLogo: isImagePickerForLogo);
                },
              ),

              /// Second row, Camera
              ImagePickerOptionsWidget(
                title: 'Take a new photo',
                // svgIcon: kIconAttachmentCamera,
                // subTitle: '',
                onClick: () {
                  controller.imagePicker(ImageSource.camera,
                      isImagePickerForLogo: isImagePickerForLogo);
                },
              ),

              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
      elevation: 20.0,
      enableDrag: true,
      ignoreSafeArea: false,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
    );
  }
}

class ImagePickerOptionsWidget extends StatelessWidget {
  const ImagePickerOptionsWidget({
    Key? key,
    // required this.svgIcon,
    required this.title,
    // required this.subTitle,
    required this.onClick,
  }) : super(key: key);

  // final String svgIcon;
  final String title;

  // final String subTitle;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.back();
        onClick();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16, top: 15),
            child: Row(
              children: <Widget>[
                // SvgPicture.asset(
                //   svgIcon,
                //   semanticsLabel: '',
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyles.kTextH14DarkGrey3535Bold600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: kColorWhite,
            margin: const EdgeInsets.only(top: 4.0, left: 58),
          ),
        ],
      ),
    );
  }
}
