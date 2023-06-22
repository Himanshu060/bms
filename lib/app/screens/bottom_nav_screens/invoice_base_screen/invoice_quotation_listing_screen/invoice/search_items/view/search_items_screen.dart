import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/image_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/search_items/controller/search_items_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/view_invoice/model/response/total_product_service_data.dart';
import 'package:bms/app/utils/number_formatter/number_formatter.dart';
import 'package:bms/app/utils/return_string_as_fixed_value.dart';
import 'package:bms/app/utils/text_styles.dart';
import 'package:bms/app/widgets/appBar/app_bar_with_back_button.dart';
import 'package:bms/app/widgets/dialogs/show_confirm_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SearchItemsScreen extends GetView<SearchItemsController> {
  SearchItemsScreen({Key? key}) : super(key: key) {
    final intentData = Get.arguments;
    controller.setIntentData(intentData: intentData);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.selectedItemCount.value != 0) {
          showWarningDialogBox();
        } else {
          Get.back(result: []);
        }
        return false;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: kColorWhite,
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(),
            elevation: 0,
            titleSpacing: 0,
            automaticallyImplyLeading: true,
            backgroundColor: Colors.transparent,
            title: Padding(
              padding: EdgeInsets.only(left: 0),
              // padding: EdgeInsets.only(left: isShowLeadingIcon??false?33.5:0),
              child: Text(
                kLabelSelectItems,
                style: TextStyles.kTextH18DarkGreyBold700,
                textAlign: TextAlign.start,
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
                if (controller.selectedItemCount.value != 0) {
                  showWarningDialogBox();
                } else {
                  Get.back(result: []);
                }
              },
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  if (controller.selectedItemCount.value != 0) {
                    controller.navigateToBackScreen();
                  }
                },
                child: Obx(() {
                  return Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Center(
                      child: Text(
                        kLabelAdd,
                        style: controller.selectedItemCount.value == 0
                            ? TextStyles.kTextH14GreyBold400
                            : TextStyles.kTextH14PrimaryBold,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          body: Focus(
            onFocusChange: (hasFocus) {
              controller.changeFocus(hasFocus: hasFocus, fieldNumber: 1);
            },
            child: Column(
              children: [
                searchItemTextField(),
                searchedItemListView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget searchItemTextField() {
    return Obx(() {
      return Container(
        height: 44,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            // prefixIcon: Padding(
            //   padding: const EdgeInsets.only(
            //       left: 1, right: 1, bottom: 11, top: 11),
            //   child: SvgPicture.asset(kIconSearch),
            // ),
            suffixIcon: controller.productNameValue.value.isEmpty
                ? Text('')
                : GestureDetector(
              onTap: () {
                controller.productNameController.text = '';
                controller.productNameValue.value = '';
                controller.searchItemsList.clear();
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
            counterText: '',
            fillColor: kColorGreyF1F1F1,
            filled: true,
            contentPadding: const EdgeInsets.only(
                left: 14.0, bottom: 0, top: 1),
            labelStyle: controller.isFocusOnProductNameField.value ||
                controller.productNameController.text.isNotEmpty
                ? TextStyles.kTextH14DarkGreyBold400
                : TextStyles.kTextH14Grey96Bold400,
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: kColorWhite, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: kColorWhite, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: kColorWhite, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            hintStyle: TextStyles.kTextH14Grey96Bold400,
            hintText: kLabelSearch,
            focusColor: kColorPrimary,
          ),
        ),
      );
    });
  }

  Widget searchedItemListView() {
    return Obx(() {
      return Expanded(
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 12),
          itemCount: controller.productNameValue.value.isNotEmpty
              ? controller.searchItemsList.length
              : controller.itemsListData.length,
          itemBuilder: (context, index) {
            var itemData = controller.productNameValue.value.isNotEmpty
                ? controller.searchItemsList[index]
                : controller.itemsListData[index];
            return Visibility(
              visible: itemData.isAddedToList == false,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4),
                padding: EdgeInsets.only(top: 4, left: 8, bottom: 4, right: 8),
                decoration: BoxDecoration(
                  color:
                  itemData.isSelected == true ? kColorPrimary : kColorWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kColorGreyD8),
                ),
                child: ListTile(
                  onTap: () {
                    var value = controller.productNameValue.value.isNotEmpty
                        ? controller.searchItemsList[index].isSelected ?? false
                        : controller.itemsListData[index].isSelected ?? false;

                    if (controller.productNameValue.isNotEmpty) {
                      controller.updateSelectedTileValues(
                          isSelected: value,
                          itemData: controller.searchItemsList[index]);
                    } else {
                      controller.updateSelectedTileValues(
                          isSelected: value,
                          itemData: controller.itemsListData[index]);
                    }
                  },
                  dense: true,
                  visualDensity:
                  const VisualDensity(horizontal: 0, vertical: 0),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 0.0, vertical: 0.0),
                  title: Row(

                    children: [
                      // Container(
                      //   margin: const EdgeInsets.only(right: 10),
                      //   height: 40,
                      //   width: 30,
                      //   decoration: BoxDecoration(
                      //     color: kColorGreyF1F1F1,
                      //     borderRadius: BorderRadius.circular(6),
                      //     border: Border.all(color: kColorGreyD8),
                      //   ),
                      //   child: Center(
                      //     child: Text(
                      //       '${index + 1}',
                      //       style: TextStyles.kTextH16DarkGrey400,
                      //     ),
                      //   ),
                      // ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            /// item name and price column
                            itemNameAndPriceColumn(
                                itemData: itemData, index: index),

                            /// product or service tag column
                            productOrServiceTage(
                                itemData: itemData, index: index),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  void showWarningDialogBox() {
    // showDialog(
    //   context: Get.overlayContext!,
    //   builder: (context) {
    //     return
    showConfirmDialogBox(
      title: '',
      type: kLabelWarning,
      message: '$kAreYouSureToItems',
      negativeButtonTitle: kLabelNo,
      negativeClicked: () {
        Get.back();
        controller.navigateToBackScreen(isBackPressed: true);
      },
      positiveButtonTitle: kLabelYes,
      positiveClicked: () {
        Get.back();
        controller.navigateToBackScreen();
      },
    );
    // },
    // );
  }

  Widget itemNameAndPriceColumn(
      {required TotalProductServiceData itemData, required int index}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          itemData.name ?? '',
          style: itemData.isSelected == true
              ? TextStyles.kTextH14WhiteBold400
              : TextStyles.kTextH14DarkGreyBold400,
        ),

        /// price and units
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Row(
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: kRupee,
                    style: itemData.isSelected == true
                        ? TextStyles.kTextH14WhiteBold400
                        : TextStyles.kTextH14DarkGreyBold400,
                  ),
                  TextSpan(
                    text:returnFormattedNumber(values: double.parse(returnToStringAsFixed(
                        value: itemData.sellPrice ?? 0.0))) ,
                        // value: itemData.itemTotal ?? 0.0))) ,
                    style: itemData.isSelected == true
                        ? TextStyles.kTextH14WhiteBold600
                        : TextStyles.kTextH14DarkGreyBold600,
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Container(
                  child: Text(
                    '/${controller.returnUnitName(index: index)}',
                    style: itemData.isSelected == true
                        ? TextStyles.kTextH14WhiteBold400
                        : TextStyles.kTextH14DarkGreyBold400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget productOrServiceTage(
      {required TotalProductServiceData itemData, required int index}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: kColorGreyD8,
            ),
          ),
          child: Text(
            itemData.isProduct == true ? kLabelProduct : kLabelService,
            style: itemData.isSelected == true
                ? TextStyles.kTextH14WhiteBold400
                : TextStyles.kTextH14DarkGreyBold400,
          ),
        ),
      ],
    );
  }
}
