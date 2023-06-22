import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/customer_base_screen/import_device_contacts/controller/import_device_contacts_controller.dart';
import 'package:bms/app/utils/text_styles.dart';
import 'package:bms/app/widgets/appBar/app_bar_with_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImportDeviceContactsScreen
    extends GetView<ImportDeviceContactsController> {
  ImportDeviceContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBarWithBackButton(title: kLabelContacts, isShowLeadingIcon: true),
      body: Obx(() {
        if (controller.isPermissionDenied.value) {
          return const Center(
              child: Text(
            kLabelPermissionDenied,
            style: TextStyles.kTextH16DarkGrey500,
          ));
        }
        return ListView.builder(
          itemCount: controller.contactDetailsList.length,
          itemBuilder: (context, index) {
            var contactData = controller.contactDetailsList[index];
            return GestureDetector(
              onTap: () {
                controller.navigateToBackScreen(contactDetails: contactData);
              },
              child: ListTile(
                title: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: kColorLightGrey)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(contactData.displayName,
                          style: TextStyles.kTextH14PrimaryBold400),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(contactData.phoneNumber,
                            style: TextStyles.kTextH14DarkGrey3535Bold600),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
