import 'package:intl/intl.dart';

String returnFormattedNumber({required double values}) {
  var formatter = NumberFormat.compactCurrency(locale: 'HI',);
  // if(values.toString().length<=4 && values != 0 && values !=0.00){
  //   formatter = NumberFormat('#.00');
  // }

  //  if(values.toString().split('.').last !='0') {
  //    formatter = NumberFormat('#,###.00');
  // }
  // else if(values == 0 || values ==0.00 ){
  //   formatter = NumberFormat('#');
  // }
  // else if(values.toString().split('.').last=='0'){
  //    formatter = NumberFormat('#,###');
  //  }
  // else{
    formatter = NumberFormat('##,##,###.##');
  // }
  return formatter.format(values);
  // return formatter.format(values);
}
