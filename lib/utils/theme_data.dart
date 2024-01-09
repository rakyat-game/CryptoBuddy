import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme(Color accentColor) {
    return ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.nunitoTextTheme(),
      brightness: Brightness.light,
      primaryColor: Colors.grey.shade800,
      highlightColor: accentColor,
      cardColor: Colors.grey.shade50,
      scaffoldBackgroundColor: Colors.white,
      canvasColor: Colors.transparent,
    );
  }

  static ThemeData darkTheme(Color accentColor) {
    return ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.nunitoTextTheme(),
      brightness: Brightness.dark,
      primaryColor: Colors.white,
      highlightColor: accentColor,
      cardColor: Colors.grey.shade900,
      scaffoldBackgroundColor: const Color(0xFF191414),
      canvasColor: Colors.transparent,
    );
  }

  static Color getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'blue':
        return Colors.white.withRed(10);
      case 'red':
        return Colors.red.shade400;
      case 'green':
        return Colors.green.shade500;
      case 'grey':
        return Colors.grey;
      default:
        return Colors.white.withRed(10);
    }
  }
}
