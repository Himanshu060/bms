import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/image_constants.dart';
import 'package:bms/app/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AppBarWithBackButton extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final Color? backButtonColor;
  final bool? isShowLeadingIcon;
  final bool? isShowActionWidgets;
  List<Widget>? widget;
  dynamic result;

  AppBarWithBackButton({
    Key? key,
    required this.title,
    this.backButtonColor,
    required this.isShowLeadingIcon,
    this.isShowActionWidgets = false,
    this.widget,
    this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(),
      elevation: 0,
      automaticallyImplyLeading: true,

      // centerTitle: true,
      // centerTitle: isShowLeadingIcon??false ? false : true,
      backgroundColor: Colors.transparent,
      titleSpacing: 0,
      title: Padding(
        padding: EdgeInsets.only(left: 0),
        // padding: EdgeInsets.only(left: isShowLeadingIcon??false?33.5:0),
        child: Text(
          title,
          style: TextStyles.kTextH18DarkGreyBold700,
          textAlign: TextAlign.start,
        ),
      ),
      leading: isShowLeadingIcon ?? false
          ? IconButton(
              // icon: const Icon(Icons.arrow_back_ios),
              icon: SvgPicture.asset(
                kIconBack,
                semanticsLabel: kBackIconDescription,
                color: kColorPrimary,
                // color: kColorPrimary,
              ),
              onPressed: () {
                Get.back(result: result);
              },
            )
          : Container(),
      actions: isShowActionWidgets == true ? widget! : [],
      // title: Text(),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
