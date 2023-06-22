import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/image_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/base/controller/settings_base_controller.dart';
import 'package:bms/app/utils/image_encode_decode_base64/decode_image_base64.dart';
import 'package:bms/app/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SettingsBaseScreen extends GetView<SettingsBaseController> {
  SettingsBaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// user name and logo
              controller.isDataLoading.value
                  ? Container()
                  : userNameAndLogoWidget(),
              Container(
                color: kColorDividerGrey,
                height: 1,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              ),
              ListView.builder(
                itemCount: controller.settingTileList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var settingsTileData = controller.settingTileList[index];
                  return ListTile(
                    contentPadding:
                        EdgeInsets.only(right: 20, left: 20, bottom: 10),
                    onTap: () {
                      controller.screenNavigation(
                          screenId: settingsTileData.screenId);
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(settingsTileData.imagePath),
                            const SizedBox(width: 20),
                            Text(settingsTileData.name,
                                style: TextStyles.kTextH14DarkGreyBold500),
                          ],
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(kIconForwardArrow),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              Spacer(),
              Container(
                color: kColorDividerGrey,
                height: 1,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              ),
              ListTile(
                contentPadding:
                    EdgeInsets.only(right: 20, left: 20, bottom: 10),
                onTap: () {
                  controller.clearAllStorageAndNavigateToLoginScreen();
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(kIconLogout),
                        const SizedBox(width: 20),
                        Text(kLabelLogOut,
                            style: TextStyles.kTextH14DarkGreyBold500),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(kIconForwardArrow),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget getProfilePhoto() {
    if (controller.userProfileImageUrl.value.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: controller.userProfileImageUrl.value,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) =>
            Image.asset(kImgDefaultUserProfile),
        width: Get.width * 0.25,
        height: Get.width * 0.25,
        fit: BoxFit.fill,
      );
    } else {
      return Image.asset(
        kImgDefaultUserProfile,
        width: Get.width * 0.25,
        height: Get.width * 0.25,
      );
    }
  }

  userNameAndLogoWidget() {
    return Obx(
      () {
        return Padding(
          padding: const EdgeInsets.only(left: 24, right: 0, top: 16), // r : 24
          child: Row(
            children: [
              controller.businessDetailsData.value.logo == null
                  ? SvgPicture.asset(kImgBusinessLogo, height: 80, width: 80)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8.5),
                      child: Image.memory(
                          convertBase64ToImageString(
                              base64String:
                                  controller.businessDetailsData.value.logo ??
                                      ""),
                          fit: BoxFit.fill,
                          height: 80,
                          width: 80),
                    ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 10.0),
              //   child: Center(
              //     child: ClipRRect(
              //       borderRadius: BorderRadius.circular(20),
              //       child: Container(
              //         decoration: const BoxDecoration(
              //           borderRadius: BorderRadius.all(
              //             Radius.circular(20.0),
              //           ),
              //         ),
              //         child: getProfilePhoto(),
              //       ),
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: SizedBox(
                        width: Get.width * 0.65,
                        child: Text(
                          controller.businessDetailsData.value.name ?? '',
                          style: TextStyles.kTextH18PrimaryBold700,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        '${controller.businessDetailsData.value.mobileNo ?? 0}',
                        style: TextStyles.kTextH14DarkGreyBold400,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: SizedBox(
                        width: Get.width * 0.65,
                        child: Text(
                          controller.businessDetailsData.value.emailId ?? '',
                          style: TextStyles.kTextH12DarkGreyBold400,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
