import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings with ChangeNotifier {
  bool isDarkModeOn;
  String accentColor;
  String currency;

  Settings({
    this.isDarkModeOn = false,
    this.accentColor = 'Blue',
    this.currency = 'usd',
  });

  void setDarkMode(bool value) {
    isDarkModeOn = value;
    notifyListeners();
  }

  void setAccentColor(String value) {
    accentColor = value;
    notifyListeners();
  }

  static Future<void> saveSettings(Settings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkModeOn', settings.isDarkModeOn);
    await prefs.setString('accentColor', settings.accentColor);
  }
}
