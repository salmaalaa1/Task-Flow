import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const _themeKey = 'theme_mode';
  static const _notifKey = 'notifications';
  static const _soundKey = 'sound_effects';
  static const _langKey = 'language';

  ThemeMode _themeMode = ThemeMode.light;
  bool _notifications = true;
  bool _soundEffects = true;
  String _language = 'en'; // 'en' or 'ar'

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get notifications => _notifications;
  bool get soundEffects => _soundEffects;
  String get language => _language;
  bool get isArabic => _language == 'ar';

  /// Load saved prefs on startup
  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final themeStr = prefs.getString(_themeKey) ?? 'light';
    _themeMode = themeStr == 'dark' ? ThemeMode.dark : ThemeMode.light;
    _notifications = prefs.getBool(_notifKey) ?? true;
    _soundEffects = prefs.getBool(_soundKey) ?? true;
    _language = prefs.getString(_langKey) ?? 'en';
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode == ThemeMode.dark ? 'dark' : 'light');
  }

  Future<void> toggleDarkMode(bool value) async {
    await setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggleNotifications(bool value) async {
    _notifications = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notifKey, value);
  }

  Future<void> toggleSoundEffects(bool value) async {
    _soundEffects = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundKey, value);
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, lang);
  }
}
