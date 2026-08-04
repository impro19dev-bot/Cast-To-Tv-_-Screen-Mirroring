import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/palette.dart';
import '../../core/utils/responsive.dart';
import '../../l10n/strings.dart';
import '../../platform/mirror_channel.dart';
import '../../services/haptics.dart';
import '../../ui/components.dart';
import 'mirror_help_page.dart';

class MirrorPage extends StatefulWidget {
  const MirrorPage({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<MirrorPage> createState() => _MirrorPageState();
}

class _MirrorPageState extends State<MirrorPage> {
  bool _airPlayActive = false;
  bool _wifiActive = false;
  bool _starting = false;
  String? _url;
  String? _error;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void dispose() {
    if (_wifiActive) {
      MirrorChannel.stopWifiMirror();
    }
    super.dispose();
  }

  Future<void> _refresh() async {
    final air = await MirrorChannel.isAirPlayMirrorActive();
    final wifi = await MirrorChannel.isWifiMirrorActive();
    if (!mounted) return;
    setState(() {
      _airPlayActive = air;
      _wifiActive = wifi;
    });
    if (wifi) {
      final url = await MirrorChannel.getWifiMirrorUrl();
      if (mounted && url != null) setState(() => _url = url);
    }
  }

  Future<void> _toggle() async {
    if (_wifiActive) {
      await MirrorChannel.stopWifiMirror();
      await Haptics.light();
      setState(() {
        _wifiActive = false;
        _url = null;
        _error = null;
      });
      return;
    }

    setState(() {
      _starting = true;
      _error = null;
    });
    try {
      final url = await MirrorChannel.startWifiMirror();
      await Haptics.medium();
      if (!mounted) return;
      setState(() {
        _starting = false;
        _wifiActive = url != null;
        _url = url;
      });
    } on PlatformException {
      if (!mounted) return;
      setState(() {
        _starting = false;
        _error = AppStrings.of(context).mirrorFailed;
      });
    }
  }

  Future<void> _copy() async {
    if (_url == null) return;
    await Clipboard.setData(ClipboardData(text: _url!));
    await Haptics.light();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppStrings.of(context).urlCopied)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final pad = Breakpoints.pad(context);
    final body = ListView(
      padding: EdgeInsets.fromLTRB(pad, widget.embedded ? 16 : 8, pad, MediaQuery.paddingOf(context).bottom + 24),
      children: [
        if (widget.embedded) ...[
          Text(
            s.screenMirror,
            style: TextStyle(
              fontSize: Breakpoints.title(context),
              fontWeight: FontWeight.w800,
              color: context.ink,
            ),
          ),
          const SizedBox(height: 12),
        ],
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: Palette.mirrorGradient),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.screen_share_rounded, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                s.mirroringUsesCc,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(s.mirroringBannerBody, style: const TextStyle(color: Colors.white70, height: 1.45)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: s.wifiViewer,
          icon: Icons.cast_connected_rounded,
          children: [
            Text(s.wifiViewerBody, style: TextStyle(height: 1.45, color: context.muted)),
            const SizedBox(height: 14),
            if (_error != null) ...[
              Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              const SizedBox(height: 10),
            ],
            FilledButton.icon(
              onPressed: _starting ? null : _toggle,
              icon: _starting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Icon(_wifiActive ? Icons.stop_rounded : Icons.play_arrow_rounded),
              label: Text(_wifiActive ? s.stopMirror : s.startMirror),
            ),
            if (_url != null) ...[
              const SizedBox(height: 14),
              Text(s.mirrorUrlLabel, style: TextStyle(fontWeight: FontWeight.w600, color: context.ink)),
              const SizedBox(height: 8),
              SoftCard(
                padding: const EdgeInsets.all(12),
                child: SelectableText(_url!, style: TextStyle(color: context.ink, fontSize: 13)),
              ),
              const SizedBox(height: 12),
              Center(
                child: QrImageView(
                  data: _url!,
                  size: 160,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                s.scanMirrorQr,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: context.muted),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _copy,
                icon: const Icon(Icons.copy_rounded),
                label: Text(s.copyUrl),
              ),
            ],
          ],
        ),
        const SizedBox(height: 14),
        SectionCard(
          title: s.airplayStatus,
          icon: Icons.airplay_rounded,
          children: [
            Row(
              children: [
                Icon(
                  _airPlayActive ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                  color: _airPlayActive ? Palette.leaf : context.muted,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _airPlayActive ? s.active : s.inactive,
                    style: TextStyle(fontWeight: FontWeight.w600, color: context.ink),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _refresh,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(s.refresh),
            ),
            const SizedBox(height: 12),
            StepRow(number: 1, text: s.step1),
            StepRow(number: 2, text: s.step2),
            StepRow(number: 3, text: s.step3),
            StepRow(number: 4, text: s.step4),
          ],
        ),
        const SizedBox(height: 14),
        CautionBanner(message: s.mirroringWarning),
        const SizedBox(height: 14),
        FilledButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const MirrorHelpPage()),
            );
          },
          icon: const Icon(Icons.menu_book_rounded),
          label: Text(s.detailedHelp),
        ),
      ],
    );

    if (widget.embedded) {
      return Scaffold(backgroundColor: context.pageBg, body: SafeArea(child: body));
    }
    return Scaffold(
      backgroundColor: context.pageBg,
      appBar: FeatureAppBar(title: s.screenMirror),
      body: body,
    );
  }
}
