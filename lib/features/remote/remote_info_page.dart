import 'package:flutter/material.dart';

import '../../cast/cast_item.dart';
import '../../cast/cast_session_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/palette.dart';
import '../../core/utils/responsive.dart';
import '../../l10n/strings.dart';
import '../../platform/airplay_views.dart';
import '../../platform/player_channel.dart';
import '../../services/haptics.dart';
import '../../ui/components.dart';
import '../connect/connect_page.dart';
import '../photos/slideshow_page.dart';

class MediaRemotePage extends StatefulWidget {
  const MediaRemotePage({super.key});

  @override
  State<MediaRemotePage> createState() => _MediaRemotePageState();
}

class _MediaRemotePageState extends State<MediaRemotePage> {
  bool _playing = false;
  double _position = 0;
  double _duration = 0;

  @override
  void initState() {
    super.initState();
    _refreshStatus();
  }

  Future<void> _refreshStatus() async {
    final status = await PlayerChannel.status();
    if (!mounted) return;
    setState(() {
      _playing = status['isPlaying'] == true;
      _position = (status['position'] as num?)?.toDouble() ?? 0;
      _duration = (status['duration'] as num?)?.toDouble() ?? 0;
    });
  }

  Future<void> _loadCurrent() async {
    final item = CastSessionProvider.read(context).current;
    if (item == null) return;
    if (item.kind == CastItemKind.video) {
      await PlayerChannel.load(filePath: item.source);
    } else if (item.kind == CastItemKind.networkMedia) {
      await PlayerChannel.load(url: item.source);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final session = CastSessionProvider.of(context);
    final pad = Breakpoints.pad(context);
    final current = session.current;

    return Scaffold(
      backgroundColor: context.pageBg,
      appBar: FeatureAppBar(title: s.remoteControl),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          pad,
          8,
          pad,
          MediaQuery.paddingOf(context).bottom + 24,
        ),
        children: [
          SoftCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.nowCasting,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: context.ink,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  current?.title ?? s.nothingCasting,
                  style: TextStyle(color: context.muted, height: 1.4),
                ),
                if (session.hasQueue) ...[
                  const SizedBox(height: 6),
                  Text(
                    '${session.index + 1} / ${session.queue.length}',
                    style: const TextStyle(
                      color: Palette.brand,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          SectionCard(
            title: s.playbackControls,
            icon: Icons.settings_remote_rounded,
            children: [
              Text(
                s.mediaRemoteBody,
                style: TextStyle(height: 1.45, color: context.muted),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _RemoteBtn(
                    icon: Icons.skip_previous_rounded,
                    onTap: () async {
                      await Haptics.selection();
                      session.previous();
                      await _loadCurrent();
                      if (session.current?.isPhoto == true && context.mounted) {
                        await Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const SlideshowPage(),
                          ),
                        );
                      }
                      await _refreshStatus();
                    },
                  ),
                  _RemoteBtn(
                    icon: Icons.replay_10_rounded,
                    onTap: () async {
                      await PlayerChannel.skip(-10);
                      await _refreshStatus();
                    },
                  ),
                  _RemoteBtn(
                    icon: _playing || session.slideshowRunning
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    filled: true,
                    onTap: () async {
                      await Haptics.medium();
                      if (current?.isPhoto == true) {
                        session.toggleSlideshow();
                      } else {
                        await PlayerChannel.toggle();
                      }
                      await _refreshStatus();
                    },
                  ),
                  _RemoteBtn(
                    icon: Icons.forward_10_rounded,
                    onTap: () async {
                      await PlayerChannel.skip(10);
                      await _refreshStatus();
                    },
                  ),
                  _RemoteBtn(
                    icon: Icons.skip_next_rounded,
                    onTap: () async {
                      await Haptics.selection();
                      session.next();
                      await _loadCurrent();
                      await _refreshStatus();
                    },
                  ),
                ],
              ),
              if (_duration > 0) ...[
                const SizedBox(height: 12),
                Slider(
                  value: _position.clamp(0, _duration),
                  max: _duration <= 0 ? 1 : _duration,
                  onChanged: (v) async {
                    await PlayerChannel.seek(v);
                    setState(() => _position = v);
                  },
                  onChangeEnd: (_) => _refreshStatus(),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      s.pickAirplayDevice,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: context.ink,
                      ),
                    ),
                  ),
                  const RoutePickerButton(width: 48, height: 48),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          SectionCard(
            title: s.aboutRemote,
            icon: Icons.info_outline_rounded,
            children: [
              Text(
                s.aboutRemoteBody,
                style: TextStyle(height: 1.45, color: context.muted),
              ),
            ],
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const ConnectPage()),
              );
            },
            icon: const Icon(Icons.wifi_rounded),
            label: Text(s.goConnect),
          ),
        ],
      ),
    );
  }
}

class _RemoteBtn extends StatelessWidget {
  const _RemoteBtn({
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    if (filled) {
      return IconButton.filled(
        style: IconButton.styleFrom(
          backgroundColor: Palette.brand,
          foregroundColor: Colors.white,
          minimumSize: const Size(56, 56),
        ),
        onPressed: onTap,
        icon: Icon(icon, size: 28),
      );
    }
    return IconButton.filledTonal(
      onPressed: onTap,
      icon: Icon(icon),
    );
  }
}

/// Kept so older imports of RemoteInfoPage still resolve.
typedef RemoteInfoPage = MediaRemotePage;
