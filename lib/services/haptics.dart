import 'package:flutter/services.dart';

import '../data/prefs_store.dart';

class Haptics {
  static Future<void> selection() async {
    if (!PrefsStore.instance.hapticsEnabled) return;
    await HapticFeedback.selectionClick();
  }

  static Future<void> light() async {
    if (!PrefsStore.instance.hapticsEnabled) return;
    await HapticFeedback.lightImpact();
  }

  static Future<void> medium() async {
    if (!PrefsStore.instance.hapticsEnabled) return;
    await HapticFeedback.mediumImpact();
  }
}
