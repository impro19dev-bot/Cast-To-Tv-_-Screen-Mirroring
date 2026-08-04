import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import '../../app/scope_provider.dart';
import '../../core/constants/app_config.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/palette.dart';
import '../../core/utils/responsive.dart';
import '../../data/app_meta.dart';
import '../../data/prefs_store.dart';
import '../../l10n/strings.dart';
import '../../services/external_actions.dart';
import '../../services/haptics.dart';
import '../../ui/components.dart';
import '../guide/welcome_guide_page.dart';
import '../legal/legal_document_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _haptics = true;

  @override
  void initState() {
    super.initState();
    _haptics = PrefsStore.instance.hapticsEnabled;
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final pad = Breakpoints.pad(context);
    final scope = AppScopeProvider.of(context);

    final body = ListView(
      padding: EdgeInsets.fromLTRB(pad, widget.embedded ? 16 : 8, pad, MediaQuery.paddingOf(context).bottom + 24),
      children: [
        if (widget.embedded) ...[
          Text(
            s.settings,
            style: TextStyle(
              fontSize: Breakpoints.title(context),
              fontWeight: FontWeight.w800,
              color: context.ink,
            ),
          ),
          const SizedBox(height: 12),
        ],
        SoftCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              ListTile(
                title: Text(s.language),
                subtitle: Text(AppScope.languageLabel(scope.locale)),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _pickLanguage(scope),
              ),
              const Divider(height: 1),
              ListTile(
                title: Text(s.appearance),
                subtitle: Text(_appearanceLabel(s, scope.themeMode)),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _pickAppearance(scope),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: Text(s.haptics),
                value: _haptics,
                activeThumbColor: Palette.brand,
                onChanged: (v) async {
                  await PrefsStore.instance.setHapticsEnabled(v);
                  if (v) await Haptics.light();
                  setState(() => _haptics = v);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SoftCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              ListTile(
                title: Text(s.howItWorks),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const WelcomeGuidePage(markComplete: false),
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                title: Text(s.privacyPolicy),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => ExternalActions.openUrl(
                  context,
                  AppConfig.privacyPolicyUrl,
                ),
              ),
              const Divider(height: 1),
              ListTile(
                title: Text(s.termsOfUse),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _openLegal(LegalKind.terms),
              ),
              const Divider(height: 1),
              ListTile(
                title: Text(s.support),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => ExternalActions.openUrl(
                  context,
                  AppConfig.supportUrl,
                ),
              ),
              const Divider(height: 1),
              ListTile(
                title: Text(s.contactUs),
                trailing: const Icon(Icons.mail_outline_rounded),
                onTap: () => ExternalActions.openMail(context),
              ),
              const Divider(height: 1),
              ListTile(
                title: Text(s.shareApp),
                trailing: const Icon(Icons.ios_share_rounded),
                onTap: () => ExternalActions.shareApp(context),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Center(
          child: Text(
            '${s.version} ${AppMeta.instance.label}',
            style: TextStyle(color: context.muted, fontSize: 13),
          ),
        ),
        const SizedBox(height: 12),
        CautionBanner(message: s.disclaimerBody),
      ],
    );

    if (widget.embedded) {
      return Scaffold(backgroundColor: context.pageBg, body: SafeArea(child: body));
    }
    return Scaffold(
      backgroundColor: context.pageBg,
      appBar: FeatureAppBar(title: s.settings),
      body: body,
    );
  }

  String _appearanceLabel(AppStrings s, ThemeMode mode) => switch (mode) {
        ThemeMode.light => s.lightMode,
        ThemeMode.dark => s.darkMode,
        ThemeMode.system => s.systemDefault,
      };

  void _openLegal(LegalKind kind) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => LegalDocumentPage(kind: kind)),
    );
  }

  void _pickLanguage(AppScope scope) {
    final s = AppStrings.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(s.language, style: TextStyle(fontWeight: FontWeight.w700, color: context.ink)),
              ),
              for (final locale in AppStrings.supportedLocales)
                ListTile(
                  title: Text(AppScope.languageLabel(locale)),
                  trailing: scope.locale.languageCode == locale.languageCode
                      ? const Icon(Icons.check_rounded, color: Palette.brand)
                      : null,
                  onTap: () async {
                    await Haptics.selection();
                    await scope.setLocale(locale);
                    if (ctx.mounted) Navigator.pop(ctx);
                    if (mounted) setState(() {});
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _pickAppearance(AppScope scope) {
    final s = AppStrings.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        Widget tile(String label, ThemeMode mode) {
          return ListTile(
            title: Text(label),
            trailing: scope.themeMode == mode
                ? const Icon(Icons.check_rounded, color: Palette.brand)
                : null,
            onTap: () async {
              await Haptics.selection();
              await scope.setThemeMode(mode);
              if (ctx.mounted) Navigator.pop(ctx);
              if (mounted) setState(() {});
            },
          );
        }

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(s.appearance, style: TextStyle(fontWeight: FontWeight.w700, color: context.ink)),
              ),
              tile(s.systemDefault, ThemeMode.system),
              tile(s.lightMode, ThemeMode.light),
              tile(s.darkMode, ThemeMode.dark),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
