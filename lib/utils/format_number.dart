import 'package:intl/intl.dart';

class Formatter {
  static String formatNumber(dynamic number, {int maxDecimalPlaces = 10}) {
    bool isNegative = false;
    if (number is String) {
      isNegative = number.startsWith('-');
      number = double.tryParse(number) ?? 0.0;
    } else {
      isNegative = number < 0;
    }

    number = number.abs();

    String formattedNumber;

    if (number >= 1) {
      formattedNumber = NumberFormat("#,##0.00", "en_US").format(number);
    } else {
      formattedNumber =
          NumberFormat("0.0###############", "en_US").format(number);

      if (number > 0) {
        int nonZeroIndex = formattedNumber.indexOf(RegExp(r"[1-9]"));
        int decimalPointIndex = formattedNumber.indexOf('.');
        int decimalPlaces = nonZeroIndex - decimalPointIndex;

        if (decimalPlaces > 0 && decimalPlaces <= maxDecimalPlaces) {
          formattedNumber = formattedNumber.substring(
              0, decimalPointIndex + decimalPlaces + 1);
        }
      }
    }

    return isNegative ? "-$formattedNumber" : formattedNumber;
  }
}
