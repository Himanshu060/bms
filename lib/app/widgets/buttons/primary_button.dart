import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrimaryButtonWidget extends StatelessWidget {
  const PrimaryButtonWidget(
      {Key? key,
      required this.onPressed,
      required this.color,
      required this.buttonTitle})
      : super(key: key);

  final Function onPressed;
  final Color color;
  final String buttonTitle;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        FocusScope.of(context).unfocus();
        onPressed();
      },
      child: Container(
        width: Get.width,
        height: 60.0,
        decoration: BoxDecoration(
            border: Border.all(
              color: color,
            ),
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Center(
            child: Text(
          buttonTitle,
          style: TextStyles.kTextH18WhiteBold500.copyWith(color: kColorWhite),
        )),
      ),
    );
  }
}
