import 'package:intl/intl.dart';

class Helper {
  // Currency IDR
  static String convertToIdr(String number, int decimalDigit) {
    var convertNumber = int.parse(number);
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(convertNumber);
  }

  static const _locale = 'id';
  String formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));
  String get currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;
}
