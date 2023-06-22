import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

Future<String> encodeImageToBase64({required String filePath}) async {
  String base64Str = '';
  Uri myUri = Uri.parse(filePath);
  XFile file = new XFile(myUri.toString());
  late Uint8List bytes;
  await file.readAsBytes().then((value) {
    bytes = Uint8List.fromList(value);
    print('reading of bytes is completed');
  }).catchError((onError) {
    print(
        'Exception Error while reading audio from path:' + onError.toString());
  });
  // base64Str = bytes.toString();
  base64Str = base64.encode(bytes);
  return base64Str;
}
