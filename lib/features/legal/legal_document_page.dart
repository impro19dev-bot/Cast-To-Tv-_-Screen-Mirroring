import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../l10n/strings.dart';
import '../../ui/components.dart';

enum LegalKind { privacy, terms, support }

class LegalDocumentPage extends StatelessWidget {
  const LegalDocumentPage({super.key, required this.kind});

  final LegalKind kind;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final pad = Breakpoints.pad(context);
    final title = switch (kind) {
      LegalKind.privacy => s.privacyPolicy,
      LegalKind.terms => s.termsOfUse,
      LegalKind.support => s.support,
    };
    final sections = switch (kind) {
      LegalKind.privacy => _privacy(s),
      LegalKind.terms => _terms(s),
      LegalKind.support => _support(s),
    };

    return Scaffold(
      backgroundColor: context.pageBg,
      appBar: FeatureAppBar(title: title),
      body: ListView(
        padding: EdgeInsets.fromLTRB(pad, 8, pad, MediaQuery.paddingOf(context).bottom + 24),
        children: [
          for (final section in sections) ...[
            SoftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.$1,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: context.ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    section.$2,
                    style: TextStyle(height: 1.5, color: context.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  List<(String, String)> _privacy(AppStrings s) => [
        (
          'Overview',
          'Cast To Tv _ Screen Mirroring is built to help you cast media and follow AirPlay / mirroring guidance. We do not sell personal data and we do not run third-party advertising or analytics SDKs in this app.'
        ),
        (
          'Data we process on device',
          'Preferences such as language, appearance, and haptic settings stay on your device via local storage. Photos and videos you choose are accessed only to display and cast them; we do not upload your media library to our servers.'
        ),
        (
          'Permissions',
          'Local Network: discover AirPlay-compatible devices. Photos: pick images/videos to cast. Microphone / Screen Recording: only if you start the optional Wi‑Fi viewer that captures screen frames locally. We request each permission when the related feature is used.'
        ),
        (
          'Network traffic',
          'The in-app browser loads URLs you enter. Optional Wi‑Fi viewer serves JPEG frames on your local network only. We do not operate a backend that receives your browsing or screen content.'
        ),
        (
          'Contact',
          'Questions: impro19dev@gmail.com'
        ),
      ];

  List<(String, String)> _terms(AppStrings s) => [
        (
          'Acceptance',
          'By using Cast To Tv _ Screen Mirroring you agree to these Terms. The app is provided as an independent utility and is not affiliated with Apple, YouTube, Vimeo, or TV manufacturers.'
        ),
        (
          'AirPlay & mirroring limits',
          'Full iOS Screen Mirroring must be started from Control Center. The app may provide guidance, a system route picker (AVRoutePickerView), and an optional local Wi‑Fi viewer. Results depend on your network and hardware.'
        ),
        (
          'Third-party services',
          'Opening YouTube, Vimeo, or other websites is subject to those services’ terms. Playback may be blocked by the site. Brand names are used for identification only.'
        ),
        (
          'Disclaimer',
          'The app is provided “as is” without warranties of uninterrupted casting. Unsupported devices, denied permissions, network failures, and invalid media may prevent features from working.'
        ),
      ];

  List<(String, String)> _support(AppStrings s) => [
        (
          'Getting help',
          'Email impro19dev@gmail.com with your iOS version, TV model, and a short description of the issue.'
        ),
        (
          'Common fixes',
          '1) Same Wi‑Fi for phone and TV. 2) Disable VPN temporarily. 3) Enable AirPlay on the TV. 4) Restart TV and router. 5) For full mirroring, use Control Center → Screen Mirroring.'
        ),
        (
          'Permissions',
          'If casting fails, check Settings → Privacy for Photos, Local Network, and Screen Recording access for this app.'
        ),
      ];
}
