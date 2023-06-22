import 'package:intl/intl.dart';

List<String> dateFormatList = [
  'yyyy-MM-dd',
  'dd/MM/yyyy',
  'yyyy-MM-dd hh:mm',
  'yMMMEd', // day,month+date,year
];

String returnConvertedDateTimerFormat({required String createdOnDate}) {
  String dateTimeFormat = '';
  if (createdOnDate != '') {
    var date = createdOnDate.split('T').first;
    DateTime tempDate =
        DateFormat("yyyy-MM-dd").parse(date);
    dateTimeFormat = DateFormat(dateFormatList[1]).format(tempDate);
  }
  return dateTimeFormat;
}
