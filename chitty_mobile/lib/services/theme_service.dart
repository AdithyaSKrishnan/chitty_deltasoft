import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _keyDarkMode = 'is_dark_mode';
  static final ValueNotifier<bool> isDarkModeNotifier = ValueNotifier<bool>(true);

  static Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_keyDarkMode) ?? true;
      isDarkModeNotifier.value = isDark;
    } catch (e) {
      print('ThemeService init error: $e');
    }
  }

  static bool get isDark => isDarkModeNotifier.value;

  static Future<void> setDarkMode(bool isDark) async {
    isDarkModeNotifier.value = isDark;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyDarkMode, isDark);
    } catch (e) {
      print('ThemeService setDarkMode error: $e');
    }
  }

  static Future<void> toggleTheme() async {
    await setDarkMode(!isDark);
  }
}
