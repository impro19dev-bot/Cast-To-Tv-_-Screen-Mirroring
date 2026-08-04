import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../l10n/strings.dart';
import '../../ui/components.dart';

class MirrorHelpPage extends StatelessWidget {
  const MirrorHelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final pad = Breakpoints.pad(context);

    return Scaffold(
      backgroundColor: context.pageBg,
      appBar: FeatureAppBar(title: s.detailedHelp),
      body: ListView(
        padding: EdgeInsets.fromLTRB(pad, 8, pad, MediaQuery.paddingOf(context).bottom + 24),
        children: [
          SectionCard(
            title: s.mirroringUsesCc,
            icon: Icons.control_camera_rounded,
            children: [
              StepRow(number: 1, text: s.step1),
              StepRow(number: 2, text: s.step2),
              StepRow(number: 3, text: s.step3),
              StepRow(number: 4, text: s.step4),
            ],
          ),
          const SizedBox(height: 14),
          SectionCard(
            title: s.wifiViewer,
            icon: Icons.wifi_tethering_rounded,
            children: [
              Text(s.wifiViewerBody, style: TextStyle(height: 1.45, color: context.muted)),
            ],
          ),
          const SizedBox(height: 14),
          SectionCard(
            title: s.sameWifi,
            icon: Icons.wifi_rounded,
            children: [
              Text(s.sameWifiBody, style: TextStyle(height: 1.45, color: context.muted)),
              const SizedBox(height: 10),
              Text(s.disableVpnBody, style: TextStyle(height: 1.45, color: context.muted)),
            ],
          ),
          const SizedBox(height: 14),
          CautionBanner(message: s.mirroringWarning),
          const SizedBox(height: 14),
          CautionBanner(message: s.disclaimerBody),
        ],
      ),
    );
  }
}
