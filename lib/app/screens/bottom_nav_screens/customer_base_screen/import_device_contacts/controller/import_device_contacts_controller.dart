import 'package:bms/app/utils/alert_message_utils.dart';
import 'package:bms/app/utils/string_utils.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ImportDeviceContactsController extends GetxController {
  RxList<Contact> deviceContactList = List<Contact>.empty(growable: true).obs;
  RxList<ContactDetails> contactDetailsList =
      List<ContactDetails>.empty(growable: true).obs;
  RxBool isPermissionDenied = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    // await fetchDeviceContact();
    await askPermission();
  }

  Future<bool?> askPermission() async{
    PermissionStatus status = await Permission.contacts.request();
    if(status.isDenied == true)
    {
      // askPermission();
      openAppSettings();
    }
    else
    {
      fetchDeviceContact();
      return true;
    }
    return null;
  }

  Future fetchDeviceContact() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      isPermissionDenied.value = true;
     // await askPermission();
      openAppSettings();
    } else {
      Get.find<AlertMessageUtils>().showProgressDialog();
      final contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: false);
      deviceContactList.value = contacts;
      getAllContactDetailsSList();
    }
  }

  void getAllContactDetailsSList() {
    for (int i = 0; i < deviceContactList.length; i++) {
      if (deviceContactList[i].phones.isNotEmpty) {
        for (var item in deviceContactList[i].phones) {
          var removedSpecialCharPhoneNumber = StringUtils.getSanitizedContactNumber(item.number.trim());
          if(removedSpecialCharPhoneNumber.length ==10){
          contactDetailsList.add(ContactDetails(
            displayName: deviceContactList[i].displayName,
            phoneNumber:
            removedSpecialCharPhoneNumber ,
            // item.number.trim(),
          ));}
        }
      }
    }
    Get.find<AlertMessageUtils>().hideProgressDialog();
    contactDetailsList.refresh();
  }

  void navigateToBackScreen({required ContactDetails contactDetails}) {
    Get.back(result: contactDetails);
  }
}

class ContactDetails {
  String displayName;
  String phoneNumber;

  // bool isSelected;
  // String postalAddress;

  ContactDetails({
    required this.displayName,
    required this.phoneNumber,
    // required this.isSelected,
    // required this.postalAddress,
  });
}
