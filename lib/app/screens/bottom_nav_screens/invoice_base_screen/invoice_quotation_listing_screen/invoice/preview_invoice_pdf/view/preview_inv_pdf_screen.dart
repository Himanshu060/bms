import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/preview_invoice_pdf/controller/preview_inv_pdf_controller.dart';
import 'package:bms/app/widgets/appBar/app_bar_with_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PreviewInvPdfScreen extends GetView<PreviewInvPdfController> {
  PreviewInvPdfScreen({Key? key}) : super(key: key) {
    final intentData = Get.arguments;
    controller.setIntentData(intentData: intentData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBackButton(
          title: controller.pdfFIle.value.path
              .split('/')
              .last,
          isShowLeadingIcon: true),
      body: Obx(() {
        return controller.pdfFIle.value.path==''?Container():SfPdfViewer.file(controller.pdfFIle.value);
      }),
    );
  }
}
