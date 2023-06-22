String returnToStringAsFixed({required double value}) {
  var strValue ='';

  if (value.toStringAsFixed(2).split('.').last == "00") {

    return strValue = value.toStringAsFixed(0);
  } else {

    return strValue = value.toStringAsFixed(2);
  }

}