import 'dart:io';

import 'package:flutter/services.dart';

/// Local-network Wi-Fi frame mirror and AirPlay external-screen status.
class MirrorChannel {
  MirrorChannel._();

  static const _channel =
      MethodChannel('com.casttotv.castscreenmirroring/mirror');

  static bool get isSupported => Platform.isIOS;

  static Future<bool> isAirPlayMirrorActive() async {
    if (!isSupported) return false;
    try {
      return await _channel.invokeMethod<bool>('isAirPlayMirrorActive') ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> isWifiMirrorActive() async {
    if (!isSupported) return false;
    try {
      return await _channel.invokeMethod<bool>('isWifiMirrorActive') ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<String?> startWifiMirror() async {
    if (!isSupported) return null;
    final result =
        await _channel.invokeMethod<Map<Object?, Object?>>('startWifiMirror');
    return result?['url'] as String?;
  }

  static Future<void> stopWifiMirror() async {
    if (!isSupported) return;
    try {
      await _channel.invokeMethod<void>('stopWifiMirror');
    } catch (_) {}
  }

  static Future<String?> getWifiMirrorUrl() async {
    if (!isSupported) return null;
    try {
      return await _channel.invokeMethod<String>('getWifiMirrorUrl');
    } catch (_) {
      return null;
    }
  }
}
