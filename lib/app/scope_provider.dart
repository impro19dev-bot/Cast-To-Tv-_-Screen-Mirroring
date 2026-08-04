import 'package:flutter/material.dart';

import 'app_scope.dart';

class AppScopeProvider extends InheritedNotifier<AppScope> {
  const AppScopeProvider({
    super.key,
    required AppScope scope,
    required super.child,
  }) : super(notifier: scope);

  static AppScope of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AppScopeProvider>();
    assert(provider != null, 'AppScopeProvider not found');
    return provider!.notifier!;
  }
}
