import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../l10n/strings.dart';
import '../../platform/airplay_views.dart';
import '../../ui/components.dart';
import '../mirror/mirror_help_page.dart';

class ConnectPage extends StatelessWidget {
  const ConnectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final pad = Breakpoints.pad(context);

    return Scaffold(
      backgroundColor: context.pageBg,
      appBar: FeatureAppBar(title: s.connectTitle),
      body: ListView(
        padding: EdgeInsets.fromLTRB(pad, 8, pad, MediaQuery.paddingOf(context).bottom + 24),
        children: [
          Text(s.connectSubtitle, style: TextStyle(height: 1.45, color: context.muted)),
          const SizedBox(height: 16),
          SectionCard(
            title: s.airplayPicker,
            icon: Icons.cast_rounded,
            children: [
              Text(s.tapAirplay, style: TextStyle(height: 1.45, color: context.muted)),
              const SizedBox(height: 16),
              const Center(child: RoutePickerButton(width: 52, height: 52)),
            ],
          ),
          const SizedBox(height: 14),
          SectionCard(
            title: s.sameWifi,
            icon: Icons.wifi_rounded,
            children: [
              Text(s.sameWifiBody, style: TextStyle(height: 1.45, color: context.muted)),
            ],
          ),
          const SizedBox(height: 14),
          SectionCard(
            title: s.airplayOnTv,
            icon: Icons.tv_rounded,
            children: [
              Text(s.airplayOnTvBody, style: TextStyle(height: 1.45, color: context.muted)),
            ],
          ),
          const SizedBox(height: 14),
          SectionCard(
            title: s.disableVpn,
            icon: Icons.vpn_key_off_rounded,
            children: [
              Text(s.disableVpnBody, style: TextStyle(height: 1.45, color: context.muted)),
            ],
          ),
          const SizedBox(height: 14),
          SectionCard(
            title: s.restartGear,
            icon: Icons.refresh_rounded,
            children: [
              Text(s.restartGearBody, style: TextStyle(height: 1.45, color: context.muted)),
            ],
          ),
          const SizedBox(height: 14),
          CautionBanner(message: s.airplayNote),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const MirrorHelpPage()),
              );
            },
            icon: const Icon(Icons.menu_book_rounded),
            label: Text(s.detailedHelp),
          ),
        ],
      ),
    );
  }
}
