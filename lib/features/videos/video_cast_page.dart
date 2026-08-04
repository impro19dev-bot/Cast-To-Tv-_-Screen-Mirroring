import 'dart:io';

import 'package:flutter/material.dart';

import '../../cast/cast_item.dart';
import '../../cast/cast_session_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../l10n/strings.dart';
import '../../platform/airplay_views.dart';
import '../../platform/player_channel.dart';
import '../../services/haptics.dart';
import '../../services/media_library.dart';
import '../../ui/components.dart';

class VideoCastPage extends StatefulWidget {
  const VideoCastPage({super.key, required this.videoFile});

  final File videoFile;

  @override
  State<VideoCastPage> createState() => _VideoCastPageState();
}

class _VideoCastPageState extends State<VideoCastPage> {
  final _library = MediaLibrary();
  late File _file;
  bool _ready = false;
  bool _error = false;
  bool _picking = false;

  @override
  void initState() {
    super.initState();
    _file = widget.videoFile;
    _prepare();
  }

  Future<void> _prepare() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    if (!_file.existsSync()) {
      setState(() {
        _error = true;
        _ready = true;
      });
      return;
    }

    final item = CastItem(
      kind: CastItemKind.video,
      source: _file.path,
      title: _file.uri.pathSegments.isNotEmpty
          ? _file.uri.pathSegments.last
          : 'Video',
    );
    CastSessionProvider.read(context).setSingle(item);
    try {
      await PlayerChannel.load(filePath: _file.path);
    } catch (_) {}

    if (!mounted) return;
    setState(() {
      _error = false;
      _ready = true;
    });
  }

  Future<void> _pickAnother() async {
    setState(() => _picking = true);
    final file = await _library.pickVideo(context);
    if (!mounted) return;
    setState(() => _picking = false);
    if (file == null) return;
    await Haptics.light();
    setState(() {
      _file = file;
      _ready = false;
      _error = false;
    });
    await _prepare();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final pad = Breakpoints.pad(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(s.videoPlayer),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: RoutePickerButton(width: 40, height: 40),
          ),
        ],
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: !_ready
                ? const ColoredBox(
                    color: Colors.black,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  )
                : _error
                    ? Center(
                        child: Text(
                          s.videoCannotPlay,
                          style: const TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ExternalVideoSurface(filePath: _file.path),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: context.pageBg,
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  pad,
                  16,
                  pad,
                  MediaQuery.paddingOf(context).bottom + 20,
                ),
                children: [
                  if (_error)
                    EmptyPanel(
                      icon: Icons.error_outline_rounded,
                      title: s.videoCannotPlay,
                      message: s.videoCannotOpen,
                      action: PrimaryButton(
                        label: s.chooseAnotherVideo,
                        icon: Icons.video_library_outlined,
                        onPressed: _picking ? () {} : _pickAnother,
                      ),
                    )
                  else ...[
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
                              onPressed: () => PlayerChannel.toggle(),
                              icon: const Icon(Icons.play_arrow_rounded),
                            ),
                            IconButton(
                              onPressed: () => PlayerChannel.pause(),
                              icon: const Icon(Icons.pause_rounded),
                            ),
                            IconButton(
                              onPressed: () => PlayerChannel.skip(10),
                              icon: const Icon(Icons.forward_10_rounded),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      label: s.chooseAnotherVideo,
                      icon: Icons.video_library_outlined,
                      onPressed: _picking ? () {} : _pickAnother,
                      outlined: true,
                    ),
                    const SizedBox(height: 16),
                    SectionCard(
                      title: s.connectTitle,
                      icon: Icons.cast_rounded,
                      children: [
                        Text(
                          s.castVideoBody,
                          style: TextStyle(height: 1.45, color: context.muted),
                        ),
                        const SizedBox(height: 12),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: RoutePickerButton(width: 48, height: 48),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
