import 'package:crypto_buddy/utils/format_number.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Tests for formatNumber():', () {
    test('Numbers >1 have two decimal places', () {
      expect(Formatter.formatNumber(40000.10), '40,000.10');
    });

    test('Numbers <1 have up to four decimal places', () {
      expect(Formatter.formatNumber(0.56), '0.5600');
    });

    test('Overwrite e-Notation', () {
      expect(Formatter.formatNumber(3.08e-8), '0.0000000308');
    });

    test('Additional decimal places for small numbers', () {
      expect(Formatter.formatNumber(0.0000314), '0.0000314');
    });

    test('handles string input that can be parsed as a number', () {
      expect(Formatter.formatNumber('0.56'), '0.5600');
    });

    test('Return "0.0" for NaN inputs ', () {
      expect(Formatter.formatNumber('abc'), '0.0');
    });
  });
}
