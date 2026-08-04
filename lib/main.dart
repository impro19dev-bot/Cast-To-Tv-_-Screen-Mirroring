import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/mirror_cast_app.dart';
import 'data/app_meta.dart';
import 'data/prefs_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefsStore.init();
  await AppMeta.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MirrorCastApp());
}
