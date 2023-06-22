import 'package:bms/app/common/app_constants.dart';
import 'package:money_formatter/money_formatter.dart';

MoneyFormatter currencyFormatter({required double amount}) {
  MoneyFormatter cnf;
  cnf = MoneyFormatter(
    amount: amount,
    settings: MoneyFormatterSettings(
      symbol: kRupee,
    ),
  );
  return cnf;
}
