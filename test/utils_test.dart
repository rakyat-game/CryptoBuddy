import 'package:crypto_buddy/utils/format_number.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Tests for formatNumber():', () {
    test('Numbers >=1 have two decimal places', () {
      expect(Formatter.formatNumber(40000.10), equals('40,000.10'));
    });

    test('Numbers <1 have variable decimal places', () {
      expect(Formatter.formatNumber(0.56), equals('0.5'));
    });

    test('Very small numbers are formatted correctly', () {
      expect(Formatter.formatNumber(3.08e-8), equals('0.00000003'));
    });

    test('Additional decimal places for small numbers', () {
      expect(Formatter.formatNumber(0.000039999), equals('0.00003'));
    });

    test('handles string input that can be parsed as a number', () {
      expect(Formatter.formatNumber('0.56'), equals('0.5'));
    });

    test('handles negative numbers', () {
      expect(Formatter.formatNumber(-1234.56), equals('-1,234.56'));
    });

    test('Return "0.00" for strings that cant be parsed', () {
      expect(Formatter.formatNumber('abc'), equals('0.0'));
    });
  });
}
