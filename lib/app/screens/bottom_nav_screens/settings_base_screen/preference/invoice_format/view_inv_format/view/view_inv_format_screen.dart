import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/preference/invoice_format/view_inv_format/controller/view_inv_format_controller.dart';
import 'package:bms/app/utils/image_encode_decode_base64/decode_image_base64.dart';
import 'package:bms/app/widgets/appBar/app_bar_with_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewInvFormatScreen extends GetView<ViewInvFormatController> {
   ViewInvFormatScreen({Key? key}) : super(key: key){
  final intentData = Get.arguments;
  controller.setIntentData(intentData: intentData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBackButton(
        title: controller.invFormatData.value.formatName ?? '',
        isShowLeadingIcon: true,
      ),
      body: Obx(() {
        return Container(
          height: Get.height,
          child: Image.memory(
            convertBase64ToImageString(
                base64String: controller.invFormatData.value.base64Img ?? ""),
            fit: BoxFit.fill,
            // height: Get.height * 0.24,
            // width: Get.width * 0.35,
          ),
        );
      }),
    );
  }
}
