import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/constants/app_config.dart';
import '../l10n/strings.dart';

class ExternalActions {
  static Future<void> shareApp(BuildContext context) async {
    final s = AppStrings.of(context);
    await Share.share(s.shareMessage);
  }

  static Future<void> openMail(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: AppConfig.supportEmail,
      queryParameters: {'subject': AppConfig.appDisplayName},
    );
    if (!await launchUrl(uri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.of(context).cannotOpenMail)),
        );
      }
    }
  }

  static Future<void> openUrl(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.of(context).cannotOpenLink)),
        );
      }
    }
  }
}
