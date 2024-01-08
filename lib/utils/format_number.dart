import 'package:intl/intl.dart';

class Formatter {
  static String formatNumber(dynamic number, {int maxDecimalPlaces = 10}) {
    // Überprüfen, ob die Eingabe ein String ist und in eine Zahl umwandeln
    bool isNegative = false;
    if (number is String) {
      isNegative =
          number.startsWith('-'); // Überprüfen, ob die Zahl negativ ist
      number = double.tryParse(number) ?? 0.0;
    } else {
      isNegative = number < 0;
    }

    // Verwenden des Absolutwerts der Zahl für die Formatierung
    number = number.abs();

    String formattedNumber;

    if (number >= 1) {
      // Für Zahlen größer oder gleich 1 verwenden wir zwei Dezimalstellen
      formattedNumber = NumberFormat("#,##0.00", "en_US").format(number);
    } else {
      // Für kleine Zahlen verwenden wir eine flexible Anzahl von Dezimalstellen
      formattedNumber =
          NumberFormat("0.0###############", "en_US").format(number);

      // Behandeln von Zahlen zwischen 0 und 1
      if (number > 0) {
        int nonZeroIndex = formattedNumber.indexOf(RegExp(r"[1-9]"));
        int decimalPointIndex = formattedNumber.indexOf('.');
        int decimalPlaces = nonZeroIndex - decimalPointIndex;

        // Erhöhen der Dezimalstellen bis zur ersten nicht-Null-Ziffer
        if (decimalPlaces > 0 && decimalPlaces <= maxDecimalPlaces) {
          formattedNumber = formattedNumber.substring(
              0, decimalPointIndex + decimalPlaces + 1);
        }
      }
    }

    // Fügen Sie das Minuszeichen wieder hinzu, falls die ursprüngliche Zahl negativ war
    return isNegative ? "-$formattedNumber" : formattedNumber;
  }
}
