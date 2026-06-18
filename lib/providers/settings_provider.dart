import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const supportedLanguages = {'en', 'ar'};
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
  Locale get locale => Locale(_language);
  bool get isArabic => _language == 'ar';

  /// Load saved prefs on startup
  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final themeStr = prefs.getString(_themeKey) ?? 'light';
    _themeMode = themeStr == 'dark' ? ThemeMode.dark : ThemeMode.light;
    _notifications = prefs.getBool(_notifKey) ?? true;
    _soundEffects = prefs.getBool(_soundKey) ?? true;
    _language = _normalizedLanguage(prefs.getString(_langKey));
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
    final nextLanguage = _normalizedLanguage(lang);
    if (_language == nextLanguage) return;

    _language = nextLanguage;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, nextLanguage);
  }

  String _normalizedLanguage(String? lang) {
    return supportedLanguages.contains(lang) ? lang! : 'en';
  }
}
