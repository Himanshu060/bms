import 'dart:convert';
import 'dart:typed_data';


Uint8List convertBase64ToImageString({required String base64String}) {
  Uint8List bytes = Uint8List(0);
  bytes = base64.decode(base64String);
  return bytes;
}