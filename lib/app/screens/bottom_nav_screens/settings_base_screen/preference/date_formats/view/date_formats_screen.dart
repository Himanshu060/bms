import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/preference/date_formats/controller/date_formats_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/preference/date_formats/model/response/date_formats_data.dart';
import 'package:bms/app/utils/text_styles.dart';
import 'package:bms/app/widgets/appBar/app_bar_with_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DateFormatsScreen extends GetView<DateFormatsController> {
  const DateFormatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBarWithBackButton(
          title: kDateFormats,
          isShowLeadingIcon: true,
          isShowActionWidgets: true,
          widget: [
            GestureDetector(
              onTap: () {
                if (controller.isDateFormatUpdate.value) {
                  controller.updatePref();
                }
              },
              child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
                child: Text(
                  kLabelSave,
                  style: controller.isDateFormatUpdate.value
                      ? TextStyles.kTextH14PrimaryBold400
                      : TextStyles.kTextH14GreyBold400,
                ),
              ),
            )
          ],
        ),
        body: Obx(
              () {
            return GridView.builder(
              itemCount: controller.dateFormatsList.length,
              padding: EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.9,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14),
              itemBuilder: (context, index) {
                DateFormatsData dateFormatsData =
                controller.dateFormatsList[index];
                return GestureDetector(
                  onTap: () {
                    controller.updateSelectedDateFormat(index: index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: dateFormatsData.isSelected == true
                              ? kColorPrimary
                              : kColorGrey8DShade,
                          width: dateFormatsData.isSelected == true ? 1.5 : 1),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            controller.returnFormattedDates(
                                dateFormat: dateFormatsData.dateFormat ?? ''),
                            style: dateFormatsData.isSelected == true
                                ? TextStyles.kTextH14PrimaryBold500
                                : TextStyles.kTextH14Grey8DShade500,
                          ),
                        ),

                        Text(
                          dateFormatsData.dateFormat ?? '',
                          style: dateFormatsData.isSelected == true
                              ? TextStyles.kTextH14PrimaryBold500
                              : TextStyles.kTextH14Grey8DShade500,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    });
  }
}
