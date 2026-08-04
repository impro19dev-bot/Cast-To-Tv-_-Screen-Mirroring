import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../cast/cast_session_provider.dart';
import '../../cast/network_diagnostics.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/palette.dart';
import '../../core/utils/responsive.dart';
import '../../l10n/strings.dart';
import '../../platform/airplay_views.dart';
import '../../platform/mirror_channel.dart';
import '../../services/haptics.dart';
import '../../ui/components.dart';
import '../connect/connect_page.dart';
import '../guide/welcome_guide_page.dart';
import '../links/media_url_cast_page.dart';
import '../mirror/mirror_page.dart';
import '../photos/photos_page.dart';
import '../remote/remote_info_page.dart';
import '../videos/videos_page.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  NetworkDiagnostics? _net;
  bool _airPlay = false;
  bool _wifiViewer = false;
  String? _mirrorUrl;

  @override
  void initState() {
    super.initState();
    _refreshStatus();
  }

  Future<void> _refreshStatus() async {
    final net = await NetworkDiagnostics.probe();
    final air = await MirrorChannel.isAirPlayMirrorActive();
    final wifi = await MirrorChannel.isWifiMirrorActive();
    final url = wifi ? await MirrorChannel.getWifiMirrorUrl() : null;
    if (!mounted) return;
    setState(() {
      _net = net;
      _airPlay = air;
      _wifiViewer = wifi;
      _mirrorUrl = url;
    });
    CastSessionProvider.read(context).updateMirrorStatus(
      airPlay: air,
      wifiViewer: wifi,
      url: url,
      ipv4: net.primaryIpv4,
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final pad = Breakpoints.pad(context);
    final session = CastSessionProvider.of(context);
    final net = _net;

    return Scaffold(
      backgroundColor: context.pageBg,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshStatus,
          child: ListView(
            padding: EdgeInsets.fromLTRB(pad, 12, pad, 28),
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/branding/app_icon.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      s.shortName,
                      style: TextStyle(
                        fontSize: Breakpoints.title(context),
                        fontWeight: FontWeight.w800,
                        color: context.ink,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _refreshStatus,
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SoftCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.sessionStatus,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: context.ink,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _StatusRow(
                      label: s.localNetwork,
                      value: net == null
                          ? '…'
                          : (net.wifiLikely
                              ? (net.primaryIpv4 ?? s.active)
                              : s.inactive),
                      ok: net?.wifiLikely == true,
                    ),
                    _StatusRow(
                      label: s.airplayStatus,
                      value: _airPlay ? s.active : s.inactive,
                      ok: _airPlay,
                    ),
                    _StatusRow(
                      label: s.wifiViewer,
                      value: _wifiViewer ? s.active : s.inactive,
                      ok: _wifiViewer,
                    ),
                    _StatusRow(
                      label: s.nowCasting,
                      value: session.current?.title ?? s.nothingCasting,
                      ok: session.hasQueue,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: Text(s.airplayPicker)),
                        const RoutePickerButton(width: 44, height: 44),
                      ],
                    ),
                  ],
                ),
              ),
              if (_mirrorUrl != null) ...[
                const SizedBox(height: 14),
                SoftCard(
                  child: Column(
                    children: [
                      Text(
                        s.scanMirrorQr,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: context.ink,
                        ),
                      ),
                      const SizedBox(height: 12),
                      QrImageView(
                        data: _mirrorUrl!,
                        size: 160,
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      SelectableText(
                        _mirrorUrl!,
                        style: TextStyle(fontSize: 12, color: context.muted),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                await Clipboard.setData(
                                  ClipboardData(text: _mirrorUrl!),
                                );
                                await Haptics.light();
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(s.urlCopied)),
                                );
                              },
                              icon: const Icon(Icons.copy_rounded),
                              label: Text(s.copyUrl),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => Share.share(_mirrorUrl!),
                              icon: const Icon(Icons.ios_share_rounded),
                              label: Text(s.shareApp),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 14),
              Text(
                s.quickActions,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: context.ink,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.slideshow_rounded,
                      label: s.photos,
                      color: Palette.amber,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const PhotosPage(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.videocam_outlined,
                      label: s.videos,
                      color: Palette.coral,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const VideosPage(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.link_rounded,
                      label: s.mediaUrl,
                      color: Palette.brand,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const MediaUrlCastPage(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SoftCard(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const ConnectPage(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.tv_rounded, size: 36, color: context.ink),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.connectDevice,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: context.ink,
                              ),
                            ),
                            Text(
                              s.connectHint,
                              style: TextStyle(
                                color: context.muted,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Palette.brand,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              GradientTile(
                title: s.screenMirror,
                subtitle: s.screenMirrorHint,
                colors: Palette.mirrorGradient,
                icon: Icons.screen_share_rounded,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const MirrorPage()),
                  );
                },
              ),
              const SizedBox(height: 14),
              GradientTile(
                title: s.remoteControl,
                subtitle: s.mediaRemoteBody,
                colors: Palette.remoteGradient,
                icon: Icons.settings_remote_rounded,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const MediaRemotePage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
              SoftCard(
                padding: const EdgeInsets.all(14),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            const WelcomeGuidePage(markComplete: false),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.help_outline_rounded, color: Palette.brand),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          s.howItWorks,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: context.ink,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Palette.brand,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              CautionBanner(message: s.disclaimerBody),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.label,
    required this.value,
    required this.ok,
  });

  final String label;
  final String value;
  final bool ok;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            size: 18,
            color: ok ? Palette.leaf : context.muted,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, style: TextStyle(color: context.muted)),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: context.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          await Haptics.selection();
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: context.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
