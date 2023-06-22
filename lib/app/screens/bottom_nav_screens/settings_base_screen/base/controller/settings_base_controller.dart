import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/image_constants.dart';
import 'package:bms/app/common/local_storage_constants.dart';
import 'package:bms/app/common/route_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/base/model/response/busines_details_data.dart';
import 'package:bms/app/services/repository/setting_repository.dart';
import 'package:bms/app/utils/decode_response_data/decode_response_data.dart';
import 'package:bms/app/utils/local_storage.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:get/get.dart';

class SettingsBaseController extends GetxController {
  var bizId = '';
  RxString userName = ''.obs;
  RxBool isDataLoading = true.obs;

  RxString businessName = ''.obs;
  RxString businessEmailId = ''.obs;
  RxString businessMobileNumber = ''.obs;
  RxString userProfileImageUrl = ''.obs;

  RxList<SettingsTiles> settingTileList =
      List<SettingsTiles>.empty(growable: true).obs;

  Rx<BusinessDetailsData> businessDetailsData = BusinessDetailsData().obs;

  @override
  Future<void> onInit() async {
    Get.lazyPut(() => SettingRepository(), fenix: true);
    bizId = await Get.find<LocalStorage>().getStringFromStorage(kStorageBizId);

    addSettingsTilesListData();
    await getBusinessDetailsFromServer();
    super.onInit();
  }

  addSettingsTilesListData() {
    settingTileList.add(SettingsTiles(
        name: kBusinessDetails, imagePath: kIconBusinessDetail, screenId: 1));
    settingTileList.add(SettingsTiles(
        name: kChangePassword, imagePath: kIconChangePassword, screenId: 2));
    settingTileList.add(
        SettingsTiles(name: kReports, imagePath: kIconReport, screenId: 3));
    settingTileList.add(SettingsTiles(
        name: kImportsExports, imagePath: kIconImportExport, screenId: 4));
    settingTileList.add(SettingsTiles(
        name: kUserPreferences, imagePath: kIconImportExport, screenId: 5));
  }

  /// get business details from server
  Future<void> getBusinessDetailsFromServer() async {
    try {
      var response =
          await Get.find<SettingRepository>().getBusinessDetails(bizId: bizId);

      if (response != null && response.data != null) {
        var res = decodeResponseData(responseData: response.data ?? '');

        if (res != null && res != '') {
          businessDetailsData.value = businessDetailsDataFromJson(res);
        }
      }
      isDataLoading.value = false;
    } catch (e) {
      isDataLoading.value = false;
      LoggerUtils.logException('getBusinessDetailsFromServer', e);
    }
  }

  /// navigate to edit business details screen
  Future<void> navigateToEditBusinessDetailsScreen() async {
    bool isUpdated = await Get.toNamed(kRouteEditBusinessDetailsScreen);
    if (isUpdated) {
      await getBusinessDetailsFromServer();
    }
  }

  /// navigate to change password screen
  void navigateToChangePasswordScreen() {
    Get.toNamed(kRouteChangePasswordScreen);
  }

  /// navigate to preference screen
  void navigateToPreferenceScreen() {
    Get.toNamed(kRoutePrefBaseScreen);
  }

  void screenNavigation({required int screenId}) {
    if (screenId == 1) {
      navigateToEditBusinessDetailsScreen();
    }
    else if(screenId ==2){
      navigateToChangePasswordScreen();
    }else if(screenId ==5){
      navigateToPreferenceScreen();
    }
  }

  /// log out and clear all local storage data and navigate to login screen
  void clearAllStorageAndNavigateToLoginScreen() {
    Get.find<LocalStorage>().clearAllData();
    Get.offAllNamed(kRouteLoginScreen);
  }
}

class SettingsTiles {
  String name;
  String imagePath;
  int screenId;

  SettingsTiles(
      {required this.name, required this.imagePath, required this.screenId});
}
