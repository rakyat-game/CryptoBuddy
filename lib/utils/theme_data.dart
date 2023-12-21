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
      cardColor: const Color(0xFFFFFDF5),
      scaffoldBackgroundColor: const Color(0xFFFFFAF0),
      canvasColor: const Color(0xFFFFFAF0), //Colors.white,
    );
  }

  static ThemeData darkTheme(Color accentColor) {
    return ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.nunitoTextTheme(),
      brightness: Brightness.dark,
      primaryColor: Colors.white, //Colors.grey.shade500,
      highlightColor: accentColor,
      cardColor: Colors.grey.shade900,
      scaffoldBackgroundColor: const Color(0xFF191414), //Colors.black,
      canvasColor: Colors.white,
    );
  }

  static Color getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'blue':
        return Colors.white.withRed(10);
      case 'red':
        return Colors.red.shade400;
      case 'green':
        return Colors
            .lime; //const Color(0x0000cc33); //const Color(0x001db954);
      case 'grey':
        return Colors.grey;
      default:
        return Colors.white.withRed(10);
    }
  }
}
