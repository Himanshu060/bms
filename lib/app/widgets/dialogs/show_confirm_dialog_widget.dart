import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/image_constants.dart';
import 'package:bms/app/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/quickalert.dart';

class ShowConfirmationDialogWidget extends StatelessWidget {
  ShowConfirmationDialogWidget({
    Key? key,
    this.title,
    required this.message,
    required this.negativeButtonTitle,
    required this.positiveButtonTitle,
    required this.negativeClicked,
    required this.positiveClicked,
  }) : super(key: key);

  String? title;
  final String message;
  final String negativeButtonTitle;
  final String positiveButtonTitle;
  final Function negativeClicked;
  final Function positiveClicked;

  @override
  Widget build(BuildContext context) {
    // ThemeData currentTheme = Provider.of<ThemeModel>(context).currentTheme;
    return Dialog(
      backgroundColor: Colors.transparent,
      // backgroundColor: currentTheme.appBarTheme.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          width: Get.width,
          color: kColorWhite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              title == ''
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(
                          top: 26, left: 5, right: 10, bottom: 2),
                      child: Text(
                        title ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyles.kTextH16DarkGrey500,
                        // .copyWith(color: currentTheme.textTheme.headline1!.color),
                      ),
                    ),
              Column(
                children: [
                  SizedBox(
                      height: Get.height * 0.18,
                      width: Get.width,
                      child: Image.asset(
                        'lib/assets/gif/success.gif',
                        fit: BoxFit.fitWidth,
                      )),
                  Container(
                    width: Get.width,
                    color: kColorWhite,
                    padding: const EdgeInsets.only(
                        left: 40, right: 43, bottom: 13, top: 13),
                    // decoration: BoxDecoration(
                    //   color: kColorWhite,
                    //   borderRadius: BorderRadius.only(
                    //     topLeft: Radius.circular(10),
                    //     topRight: Radius.circular(10),
                    //   ),
                    //   border: Border.all(color: kColorWhite),
                    // ),
                    // margin: const EdgeInsets.only(right: 18),
                    child: Visibility(
                      visible: message.isNotEmpty,
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyles.kTextH16DarkGrey500,
                        // .copyWith(color: currentTheme.textTheme.headline1!.color),
                      ),
                    ),
                  ),
                  Container(
                    height: 34,
                    width: Get.width,
                    margin: EdgeInsets.only(bottom: 10, left: 20, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Container(
                        //   padding: EdgeInsets.symmetric(
                        //       vertical: 10, horizontal: 20),
                        //   decoration: BoxDecoration(
                        //       border: Border.all(color: kColorPrimary),
                        //       borderRadius: BorderRadius.circular(20)),
                        //   child: Text(kLabelShare),
                        // ),
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 35,
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: kColorPrimary),
                              ),
                              child: CircleAvatar(
                                backgroundColor: kColorWhite,
                                child:SvgPicture.asset(kIconShare),
                              ),
                            ),

                            // Container(
                            //   padding: EdgeInsets.symmetric(
                            //       vertical: 10, horizontal: 20),
                            //   decoration: BoxDecoration(
                            //       border: Border.all(color: kColorPrimary),
                            //       borderRadius: BorderRadius.circular(20)),
                            //   child: Text(kLabelPrint),
                            // ),
                            Container(
                              height: 40,
                              width: 35,
                              // padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: kColorPrimary),
                              ),
                              child: CircleAvatar(
                                backgroundColor: kColorWhite,
                                child: SvgPicture.asset(kIconPrint,fit: BoxFit.fill),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            positiveClicked();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 20),
                            decoration: BoxDecoration(
                                // border: Border.all(
                                //   color: kColorPrimary,
                                // ),
                                color: kColorWhite,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: Center(
                                child: Text(
                              kLabelOkay,
                              // positiveButtonTitle,
                              style: TextStyles.kTextH14PrimaryBold500,
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              /// cancel and delete buttons
              /*   Container(
                decoration: const BoxDecoration(
                  color: kColorWhite,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                margin: const EdgeInsets.only(right: 18),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 36, right: 36, bottom: 18),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 34,
                          // width: 126,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: kColorLightGrey,
                              ),
                              color: kColorLightGrey,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6))),
                          child: MaterialButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              negativeClicked();
                              // Get.back(result: false);
                            },
                            child: Center(
                                child: Text(
                              negativeButtonTitle,
                              // kLabelCancel,
                              style: TextStyles.kTextH14WhiteBold500
                                  .copyWith(color: kColorWhite),
                            )),
                          ),
                        ),
                      ),
                      const SizedBox(width: 26),
                      Expanded(
                        child: Container(
                          height: 34,
                          // width: 126,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: kColorRed,
                              ),
                              color: kColorRed,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6))),
                          child: MaterialButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              positiveClicked();
                              // Get.back(result: false);
                            },
                            child: Center(
                                child: Text(
                              positiveButtonTitle,
                              // kLabelDelete,
                              style: TextStyles.kTextH14WhiteBold500
                                  .copyWith(color: kColorWhite),
                            )),
                          ),
                        ),
                        */ /*      GestureDetector(
                      onTap: () {
                        positiveClicked();
                      },
                      child:
                      Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          height: 40.0,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(width: 1.0, color: kColorRed),
                              left: BorderSide(width: 0.5, color: kColorRed),
                            ),
                          ),
                          child: Center(
                            child: Text(positiveButtonTitle,
                                style: TextStyles.kTextH14WhiteBold500
                                // .copyWith(
                                // color: kColorPopUpButtonsBlue,
                                // color: kColorPrimary,
                                ),
                          )),
                    ),*/ /*
                      ),
                    ],
                  ),
                ),
              )*/
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showConfirmDialogBox({
  title,
  message,
  negativeButtonTitle,
  positiveButtonTitle,
  negativeClicked,
  positiveClicked,
  String type = 'error',
}) async {
  QuickAlert.show(
    context: Get.overlayContext!,
    type: type == 'warning' ? QuickAlertType.info : QuickAlertType.error,
    text: message,
    title: title,
    showCancelBtn: true,
    confirmBtnColor: kColorRed,
    onConfirmBtnTap: positiveClicked,
    onCancelBtnTap: negativeClicked,
    confirmBtnText: positiveButtonTitle,
    cancelBtnText: negativeButtonTitle,
  );
}
