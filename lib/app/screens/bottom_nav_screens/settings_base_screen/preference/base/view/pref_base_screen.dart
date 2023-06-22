import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/image_constants.dart';
import 'package:bms/app/common/route_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/preference/base/controller/pref_base_controller.dart';
import 'package:bms/app/widgets/appBar/app_bar_with_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PrefBaseScreen extends GetView<PrefBaseController> {
  const PrefBaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBackButton(
        title: kLabelPreferences,
        isShowLeadingIcon: true,
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: controller.screeNames.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              dense: false,
              contentPadding: EdgeInsets.only(right: 20, left: 20),
              title: Text(controller.screeNames[index]),
              trailing: SvgPicture.asset(kIconForwardArrow),
              onTap: () {
                controller.navigateToPrefsScreens(index: index);
              },
            );
          },
        );
      }),
    );
  }
}
