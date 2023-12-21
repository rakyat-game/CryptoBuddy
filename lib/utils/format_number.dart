import 'package:intl/intl.dart';

class Formatter {
  static String formatNumber(dynamic number, {int maxDecimalPlaces = 10}) {
    if (number is String) {
      number = double.tryParse(number) ?? 0.0;
    }

    if (number >= 1) {
      return NumberFormat("#,##0.00", "en_US").format(number);
    }

    // Gets rid of scientific notation
    if (number.toString().contains('e-')) {
      return NumberFormat("0.0###############", "en_US").format(number);
    }

    String formattedNumber =
        NumberFormat("0.0###############", "en_US").format(number);

    if (number > 0 && number < 1) {
      int nonZeroIndex = formattedNumber.indexOf(RegExp(r"[1-9]"));
      int decimalPointIndex = formattedNumber.indexOf('.');
      int decimalPlaces = nonZeroIndex - decimalPointIndex;
      // Increase decimal places until first non-zero digit using the regex
      if (decimalPlaces > 0 && decimalPlaces <= maxDecimalPlaces) {
        return formattedNumber.substring(
            0, decimalPointIndex + decimalPlaces + 1);
      }
    }
    return formattedNumber;
  }
}
