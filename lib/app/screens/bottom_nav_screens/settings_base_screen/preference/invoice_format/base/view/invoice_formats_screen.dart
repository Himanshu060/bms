import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/preference/invoice_format/base/controller/invoice_formats_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/preference/invoice_format/base/model/response/invoice_format_data.dart';
import 'package:bms/app/utils/image_encode_decode_base64/decode_image_base64.dart';
import 'package:bms/app/utils/text_styles.dart';
import 'package:bms/app/widgets/appBar/app_bar_with_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoiceFormatsScreen extends GetView<InvoiceFormatsController> {
  InvoiceFormatsScreen({Key? key}) : super(key: key) {
    final intentData = Get.arguments;
    controller.setIntentData(intentData: intentData);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: kColorWhite,
        appBar: AppBarWithBackButton(
          title: kInvoiceFormats,
          isShowLeadingIcon: true,
          isShowActionWidgets: true,
          widget: [
            GestureDetector(
              onTap: () {
                if (controller.isInvFormatUpdate.value) {
                  controller.updatePref();
                }
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
                child: Text(
                  kLabelSave,
                  style: controller.isInvFormatUpdate.value
                      ? TextStyles.kTextH14PrimaryBold400
                      : TextStyles.kTextH14GreyBold400,
                ),
              ),
            )
          ],
        ),
        body: Obx(
          () {
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: GridView.builder(
                itemCount: controller.invFormatsList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.65),
                itemBuilder: (context, index) {
                  InvoiceFormatData invFormatData =
                      controller.invFormatsList[index];
                  return GestureDetector(
                    onTap: () {
                      controller.updateSelectedInvFormat(index: index);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: kColorLightGrey,
                        border: Border.all(
                            color: invFormatData.isSelected == true
                                ? kColorPrimary
                                : kColorWhite,
                            width: 2),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            child: Image.memory(
                              convertBase64ToImageString(
                                  base64String: invFormatData.base64Img ?? ""),
                              fit: BoxFit.fill,
                              // height: Get.height * 0.24,
                              // width: Get.width * 0.35,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  invFormatData.formatName ?? '',
                                  style: TextStyles.kTextH14DarkGreyBold400,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller.navigateToViewInvFormatScreen(
                                        data: invFormatData);
                                  },
                                  child: const Icon(Icons.remove_red_eye),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
    });
  }
}
