import 'package:flutter/material.dart';

import '../data/prefs_store.dart';
import '../l10n/strings.dart';

class AppScope extends ChangeNotifier {
  AppScope() {
    _load();
  }

  late ThemeMode themeMode;
  late Locale locale;

  void _load() {
    final theme = PrefsStore.instance.themeMode;
    themeMode = switch (theme) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    final code = PrefsStore.instance.localeCode;
    locale = code == null ? const Locale('en') : Locale(code);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await PrefsStore.instance.setThemeMode(value);
    notifyListeners();
  }

  Future<void> setLocale(Locale value) async {
    locale = value;
    await PrefsStore.instance.setLocaleCode(value.languageCode);
    notifyListeners();
  }

  static String languageLabel(Locale locale) =>
      AppStrings.forLocale(locale).languageName(locale.languageCode);
}
