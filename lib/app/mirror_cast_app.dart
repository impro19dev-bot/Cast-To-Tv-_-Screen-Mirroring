import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../cast/cast_session.dart';
import '../cast/cast_session_provider.dart';
import '../core/constants/app_config.dart';
import '../core/theme/app_theme.dart';
import '../features/splash/splash_page.dart';
import '../l10n/strings.dart';
import 'app_scope.dart';
import 'scope_provider.dart';

class MirrorCastApp extends StatefulWidget {
  const MirrorCastApp({super.key});

  @override
  State<MirrorCastApp> createState() => _MirrorCastAppState();
}

class _MirrorCastAppState extends State<MirrorCastApp> {
  final _scope = AppScope();
  final _session = CastSession();

  @override
  void initState() {
    super.initState();
    _session.loadRecents();
  }

  @override
  void dispose() {
    _session.dispose();
    _scope.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScopeProvider(
      scope: _scope,
      child: CastSessionProvider(
        session: _session,
        child: ListenableBuilder(
          listenable: Listenable.merge([_scope, _session]),
          builder: (context, _) {
            return MaterialApp(
              title: AppConfig.appDisplayName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              themeMode: _scope.themeMode,
              locale: _scope.locale,
              supportedLocales: AppStrings.supportedLocales,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: const SplashPage(),
            );
          },
        ),
      ),
    );
  }
}
