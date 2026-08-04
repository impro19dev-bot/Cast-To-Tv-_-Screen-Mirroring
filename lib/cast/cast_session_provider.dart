import 'package:flutter/material.dart';

import '../cast/cast_session.dart';

class CastSessionProvider extends InheritedNotifier<CastSession> {
  const CastSessionProvider({
    super.key,
    required CastSession session,
    required super.child,
  }) : super(notifier: session);

  static CastSession of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<CastSessionProvider>();
    assert(provider != null, 'CastSessionProvider not found');
    return provider!.notifier!;
  }

  static CastSession read(BuildContext context) {
    final provider =
        context.getInheritedWidgetOfExactType<CastSessionProvider>();
    assert(provider != null, 'CastSessionProvider not found');
    return provider!.notifier!;
  }
}
