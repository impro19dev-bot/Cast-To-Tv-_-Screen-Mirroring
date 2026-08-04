import 'package:package_info_plus/package_info_plus.dart';

class AppMeta {
  AppMeta._(this._info);

  final PackageInfo _info;

  static AppMeta? _instance;

  static AppMeta get instance {
    final value = _instance;
    if (value == null) {
      throw StateError('AppMeta.init() must be called first.');
    }
    return value;
  }

  static Future<void> init() async {
    _instance = AppMeta._(await PackageInfo.fromPlatform());
  }

  String get version => _info.version;
  String get build => _info.buildNumber;
  String get label => '$version ($build)';
}
