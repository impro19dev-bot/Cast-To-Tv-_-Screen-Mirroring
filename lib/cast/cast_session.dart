import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cast_item.dart';

/// App-wide cast queue, slideshow timer, and recent history (on-device only).
class CastSession extends ChangeNotifier {
  CastSession();

  static const _recentKey = 'recent_casts_v1';

  final List<CastItem> queue = [];
  final List<CastItem> recent = [];

  int index = 0;
  bool slideshowRunning = false;
  int slideSeconds = 5;
  Timer? _slideTimer;

  bool airPlayExternal = false;
  bool wifiViewerActive = false;
  String? mirrorUrl;
  String? localIpv4;
  String? lastError;

  CastItem? get current =>
      queue.isEmpty || index < 0 || index >= queue.length ? null : queue[index];

  bool get hasQueue => queue.isNotEmpty;

  Future<void> loadRecents() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_recentKey) ?? [];
    recent
      ..clear()
      ..addAll(
        raw.map((e) {
          try {
            return CastItem.fromJson(
              jsonDecode(e) as Map<String, dynamic>,
            );
          } catch (_) {
            return null;
          }
        }).whereType<CastItem>(),
      );
    notifyListeners();
  }

  Future<void> _persistRecent(CastItem item) async {
    recent.removeWhere((e) => e.source == item.source);
    recent.insert(0, item);
    if (recent.length > 12) {
      recent.removeRange(12, recent.length);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _recentKey,
      recent.map((e) => jsonEncode(e.toJson())).toList(),
    );
    notifyListeners();
  }

  void setPhotoQueue(List<CastItem> photos, {bool startSlideshow = true}) {
    _slideTimer?.cancel();
    queue
      ..clear()
      ..addAll(photos);
    index = 0;
    slideshowRunning = startSlideshow && photos.length > 1;
    if (slideshowRunning) _armSlideshow();
    if (photos.isNotEmpty) {
      unawaited(_persistRecent(photos.first));
    }
    notifyListeners();
  }

  void setSingle(CastItem item) {
    _slideTimer?.cancel();
    slideshowRunning = false;
    queue
      ..clear()
      ..add(item);
    index = 0;
    unawaited(_persistRecent(item));
    notifyListeners();
  }

  void clearQueue() {
    _slideTimer?.cancel();
    slideshowRunning = false;
    queue.clear();
    index = 0;
    notifyListeners();
  }

  void next() {
    if (queue.isEmpty) return;
    index = (index + 1) % queue.length;
    notifyListeners();
  }

  void previous() {
    if (queue.isEmpty) return;
    index = (index - 1 + queue.length) % queue.length;
    notifyListeners();
  }

  void jumpTo(int i) {
    if (i < 0 || i >= queue.length) return;
    index = i;
    notifyListeners();
  }

  void setSlideSeconds(int seconds) {
    slideSeconds = seconds.clamp(2, 30);
    if (slideshowRunning) _armSlideshow();
    notifyListeners();
  }

  void playSlideshow() {
    if (queue.length < 2) return;
    slideshowRunning = true;
    _armSlideshow();
    notifyListeners();
  }

  void pauseSlideshow() {
    slideshowRunning = false;
    _slideTimer?.cancel();
    notifyListeners();
  }

  void toggleSlideshow() {
    if (slideshowRunning) {
      pauseSlideshow();
    } else {
      playSlideshow();
    }
  }

  void _armSlideshow() {
    _slideTimer?.cancel();
    _slideTimer = Timer.periodic(Duration(seconds: slideSeconds), (_) {
      if (!slideshowRunning || queue.length < 2) return;
      next();
    });
  }

  void updateMirrorStatus({
    required bool airPlay,
    required bool wifiViewer,
    String? url,
    String? ipv4,
    String? error,
  }) {
    airPlayExternal = airPlay;
    wifiViewerActive = wifiViewer;
    mirrorUrl = url;
    localIpv4 = ipv4;
    lastError = error;
    notifyListeners();
  }

  @override
  void dispose() {
    _slideTimer?.cancel();
    super.dispose();
  }
}
