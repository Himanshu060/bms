import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/image_constants.dart';
import 'package:bms/app/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CategoryDropDown extends StatefulWidget {
  dynamic callBackValue;
   CategoryDropDown(this.callBackValue,{Key? key}) : super(key: key);

  Future<dynamic> showOverlay(BuildContext context) async {

    // Declaring and Initializing OverlayState
    // and OverlayEntry objects
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry? overlayEntry;
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    overlayEntry = OverlayEntry(
      builder: (context) {
        // You can return any widget you like here
        // to be displayed on the Overlay
        return Positioned(
          width: size.width,
          height: size.height * 0.15,
          top: size.height * 0.35,
          // left: MediaQuery.of(context).size.width * 0.2,
          // top: MediaQuery.of(context).size.height * 0.25,
          // top: MediaQuery.of(context).size.height * 0.35,
          child: Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width * 0.8,
              child: Container(
                height: Get.height * 0.2,
                decoration: BoxDecoration(
                  color: kColorWhite,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 36,
                      child: GestureDetector(
                        onTap: () {
                          callBackValue = true;
                          overlayEntry?.remove();
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(kIconPlusBlue),
                            const Text(
                              kLabelAddGSTRate,
                              style: TextStyles.kTextH14WhiteBold400,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    // Inserting the OverlayEntry into the Overlay
    overlayState?.insert(overlayEntry);
    return callBackValue;
  }

  @override
  State<CategoryDropDown> createState() => CategoryDropDownState();
}

class CategoryDropDownState extends State<CategoryDropDown> {

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

