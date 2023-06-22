dynamic decodeResponseData({required String responseData}) {
  var decodedResponseData;

  String tempStr = responseData.replaceAll('\'', '');
  // decodedResponseData = tempStr.substring(1, tempStr.length - 1);
  if (tempStr == '{}' || tempStr == '[]') {
    decodedResponseData = '';
  } else {
    decodedResponseData = tempStr;
  }
  return decodedResponseData;
}
