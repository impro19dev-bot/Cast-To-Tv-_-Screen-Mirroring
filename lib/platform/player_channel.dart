import 'dart:io';

import 'package:flutter/services.dart';

/// Controls the shared native AVPlayer used for AirPlay-capable playback.
class PlayerChannel {
  PlayerChannel._();

  static const _channel =
      MethodChannel('com.casttotv.castscreenmirroring/player');

  static bool get isSupported => Platform.isIOS;

  static Future<void> load({String? filePath, String? url}) async {
    if (!isSupported) return;
    await _channel.invokeMethod<void>('load', <String, dynamic>{
      'filePath': ?filePath,
      'url': ?url,
    });
  }

  static Future<void> play() async {
    if (!isSupported) return;
    await _channel.invokeMethod<void>('play');
  }

  static Future<void> pause() async {
    if (!isSupported) return;
    await _channel.invokeMethod<void>('pause');
  }

  static Future<void> toggle() async {
    if (!isSupported) return;
    await _channel.invokeMethod<void>('toggle');
  }

  static Future<void> seek(double seconds) async {
    if (!isSupported) return;
    await _channel.invokeMethod<void>('seek', {'seconds': seconds});
  }

  static Future<void> skip(double deltaSeconds) async {
    if (!isSupported) return;
    await _channel.invokeMethod<void>('skip', {'seconds': deltaSeconds});
  }

  static Future<Map<String, dynamic>> status() async {
    if (!isSupported) {
      return {'isPlaying': false, 'position': 0.0, 'duration': 0.0};
    }
    final raw = await _channel.invokeMethod<Map<Object?, Object?>>('status');
    return {
      'isPlaying': raw?['isPlaying'] == true,
      'position': (raw?['position'] as num?)?.toDouble() ?? 0,
      'duration': (raw?['duration'] as num?)?.toDouble() ?? 0,
      'external': raw?['external'] == true,
    };
  }

  static Future<void> stop() async {
    if (!isSupported) return;
    try {
      await _channel.invokeMethod<void>('stop');
    } catch (_) {}
  }
}
