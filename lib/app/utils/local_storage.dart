import 'package:bms/app/utils/logger_utils.dart';
import 'package:bms/app/utils/string_extensions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class LocalStorage extends GetxController {
  late final FlutterSecureStorage _mEncryptedStorage;

  @override
  void onInit() {
    super.onInit();
    initStorageBox();
  }

  /// initialize FlutterSecureStorage
  void initStorageBox() {
    _mEncryptedStorage = const FlutterSecureStorage();
  }

  /// store string values to Getx storage
  Future writeStringStorage(String key, String value) async {
    await _mEncryptedStorage.write(key: key, value: value);
  }

  /// store int values to Getx storage
  Future writeInStorage(String key, int value) async {
    var intToString = value.toString();
    await _mEncryptedStorage.write(key: key, value: intToString);
  }

  /// store string values to Getx storage
  Future writeBoolStorage(String key, bool value) async {
    var boolToString = value.toString();
    await _mEncryptedStorage.write(key: key, value: boolToString);
  }

  /// read string values from Getx storage
  Future<String> getStringFromStorage(String key) async {
    var value = await _mEncryptedStorage.read(key: key);
    return value ?? '';
  }

  /// read int values from Getx storage
  Future<int> getIntFromStorage(String key) async {
    var value = await _mEncryptedStorage.read(key: key) ?? '0';
    var stringToInt = int.parse(value);
    return stringToInt;
  }

  /// read bool values from Getx storage
  Future<bool?> getBoolFromStorage(String key) async {
    try {
      String boolValue = await _mEncryptedStorage.read(key: key) ?? '';
      return boolValue.parseBool();
    } catch (ex) {
      return false;
    }
  }

  /// clear all locally stored data
  Future clearAllData() async {
    try {
      _mEncryptedStorage.deleteAll();
    } catch (ex) {
      LoggerUtils.logException('clearAllData', ex);
    }
  }
}
