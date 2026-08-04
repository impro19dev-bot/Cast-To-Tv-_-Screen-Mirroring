import 'package:flutter/material.dart';

import '../../cast/cast_item.dart';
import '../../cast/cast_session_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/palette.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/url_tools.dart';
import '../../l10n/strings.dart';
import '../../platform/airplay_views.dart';
import '../../platform/player_channel.dart';
import '../../services/haptics.dart';
import '../../ui/components.dart';

class MediaUrlCastPage extends StatefulWidget {
  const MediaUrlCastPage({super.key, this.initialUrl});

  final String? initialUrl;

  @override
  State<MediaUrlCastPage> createState() => _MediaUrlCastPageState();
}

class _MediaUrlCastPageState extends State<MediaUrlCastPage> {
  late final TextEditingController _controller;
  String? _error;
  String? _activeUrl;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialUrl ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _looksLikeMedia(String url) {
    final lower = url.toLowerCase();
    const exts = [
      '.mp4',
      '.m3u8',
      '.mov',
      '.m4v',
      '.mp3',
      '.aac',
      '.jpg',
      '.jpeg',
      '.png',
      '.webp',
    ];
    return exts.any(lower.contains);
  }

  String _titleFor(String url) {
    final segments = Uri.tryParse(url)?.pathSegments;
    if (segments == null || segments.isEmpty) return 'Network media';
    return segments.last;
  }

  Future<void> _cast() async {
    final s = AppStrings.of(context);
    final normalized = UrlTools.normalizeBrowserUrl(_controller.text);
    if (normalized == null) {
      setState(() => _error = s.invalidUrl);
      return;
    }
    if (!_looksLikeMedia(normalized)) {
      setState(() => _error = s.unsupportedMediaUrl);
      return;
    }

    setState(() {
      _error = null;
      _loading = true;
    });
    final session = CastSessionProvider.read(context);
    await Haptics.light();

    final isImage = ['.jpg', '.jpeg', '.png', '.webp']
        .any(normalized.toLowerCase().contains);
    final item = CastItem(
      kind: isImage ? CastItemKind.photo : CastItemKind.networkMedia,
      source: normalized,
      title: _titleFor(normalized),
    );
    session.setSingle(item);

    if (!isImage) {
      try {
        await PlayerChannel.load(url: normalized);
      } catch (_) {
        if (mounted) {
          setState(() => _error = s.videoCannotOpen);
        }
      }
    }

    if (!mounted) return;
    setState(() {
      _loading = false;
      _activeUrl = normalized;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final pad = Breakpoints.pad(context);
    final active = _activeUrl;
    final isImage = active != null &&
        ['.jpg', '.jpeg', '.png', '.webp'].any(active.toLowerCase().contains);

    return Scaffold(
      backgroundColor: context.pageBg,
      appBar: FeatureAppBar(
        title: s.mediaUrl,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: RoutePickerButton(width: 40, height: 40),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          pad,
          8,
          pad,
          MediaQuery.paddingOf(context).bottom + 24,
        ),
        children: [
          Text(s.mediaUrlBody, style: TextStyle(height: 1.45, color: context.muted)),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: s.mediaUrlLabel,
              hintText: 'https://example.com/video.mp4',
              errorText: _error,
            ),
            keyboardType: TextInputType.url,
            autocorrect: false,
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: s.castMediaUrl,
            icon: Icons.cast_rounded,
            onPressed: _loading ? () {} : _cast,
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
          if (active != null) ...[
            const SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: ColoredBox(
                  color: Colors.black,
                  child: isImage
                      ? Image.network(active, fit: BoxFit.contain)
                      : ExternalVideoSurface(url: active),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SectionCard(
              title: s.playbackControls,
              icon: Icons.play_circle_outline,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () => PlayerChannel.skip(-10),
                      icon: const Icon(Icons.replay_10_rounded),
                    ),
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: Palette.brand,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => PlayerChannel.toggle(),
                      icon: const Icon(Icons.play_arrow_rounded),
                    ),
                    IconButton(
                      onPressed: () => PlayerChannel.skip(10),
                      icon: const Icon(Icons.forward_10_rounded),
                    ),
                  ],
                ),
                Text(
                  s.castVideoBody,
                  style: TextStyle(height: 1.45, color: context.muted),
                ),
              ],
            ),
          ],
          const SizedBox(height: 14),
          CautionBanner(message: s.mediaUrlCaution),
        ],
      ),
    );
  }
}
