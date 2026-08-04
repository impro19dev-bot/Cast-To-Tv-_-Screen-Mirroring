import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_config.dart';

class PrefsStore {
  PrefsStore._(this._prefs);

  final SharedPreferences _prefs;

  static PrefsStore? _instance;

  static PrefsStore get instance {
    final value = _instance;
    if (value == null) {
      throw StateError('PrefsStore.init() must be called first.');
    }
    return value;
  }

  static Future<void> init() async {
    _instance = PrefsStore._(await SharedPreferences.getInstance());
  }

  bool get onboardingDone =>
      _prefs.getBool(AppConfig.prefsOnboardingDone) ?? false;

  Future<void> setOnboardingDone(bool value) =>
      _prefs.setBool(AppConfig.prefsOnboardingDone, value);

  bool get hapticsEnabled => _prefs.getBool(AppConfig.prefsHaptics) ?? true;

  Future<void> setHapticsEnabled(bool value) =>
      _prefs.setBool(AppConfig.prefsHaptics, value);

  String? get localeCode => _prefs.getString(AppConfig.prefsLocale);

  Future<void> setLocaleCode(String? code) async {
    if (code == null) {
      await _prefs.remove(AppConfig.prefsLocale);
    } else {
      await _prefs.setString(AppConfig.prefsLocale, code);
    }
  }

  String get themeMode => _prefs.getString(AppConfig.prefsTheme) ?? 'system';

  Future<void> setThemeMode(String value) =>
      _prefs.setString(AppConfig.prefsTheme, value);
}
