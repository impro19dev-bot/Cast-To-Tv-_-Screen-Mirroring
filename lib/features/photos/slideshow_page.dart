import 'dart:io';

import 'package:flutter/material.dart';

import '../../cast/cast_item.dart';
import '../../cast/cast_session_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/palette.dart';
import '../../core/utils/responsive.dart';
import '../../l10n/strings.dart';
import '../../platform/airplay_views.dart';
import '../../services/haptics.dart';

class SlideshowPage extends StatelessWidget {
  const SlideshowPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final session = CastSessionProvider.of(context);
    final pad = Breakpoints.pad(context);
    final current = session.current;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(s.slideshow),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: RoutePickerButton(width: 40, height: 40),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: current == null || !current.isPhoto
                ? Center(
                    child: Text(
                      s.noPhoto,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  )
                : InteractiveViewer(
                    child: Center(
                      child: Image.file(
                        File(current.source),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
          ),
          Container(
            width: double.infinity,
            color: context.pageBg,
            padding: EdgeInsets.fromLTRB(
              pad,
              16,
              pad,
              MediaQuery.paddingOf(context).bottom + 16,
            ),
            child: Column(
              children: [
                Text(
                  current == null
                      ? ''
                      : '${session.index + 1} / ${session.queue.length} · ${current.title}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: context.ink,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton.filledTonal(
                      onPressed: () async {
                        await Haptics.selection();
                        session.previous();
                      },
                      icon: const Icon(Icons.skip_previous_rounded),
                    ),
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: Palette.brand,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        await Haptics.medium();
                        session.toggleSlideshow();
                      },
                      icon: Icon(
                        session.slideshowRunning
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: () async {
                        await Haptics.selection();
                        session.next();
                      },
                      icon: const Icon(Icons.skip_next_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(s.slideInterval, style: TextStyle(color: context.muted)),
                    Expanded(
                      child: Slider(
                        value: session.slideSeconds.toDouble(),
                        min: 2,
                        max: 15,
                        divisions: 13,
                        label: '${session.slideSeconds}s',
                        onChanged: (v) => session.setSlideSeconds(v.round()),
                      ),
                    ),
                    Text('${session.slideSeconds}s'),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  s.slideshowAirplayHint,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, height: 1.4, color: context.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper to open slideshow from a list of photo files.
Future<void> openPhotoSlideshow(
  BuildContext context,
  List<File> files,
) async {
  if (files.isEmpty) return;
  final session = CastSessionProvider.read(context);
  final items = <CastItem>[
    for (var i = 0; i < files.length; i++)
      CastItem(
        kind: CastItemKind.photo,
        source: files[i].path,
        title: 'Photo ${i + 1}',
      ),
  ];
  session.setPhotoQueue(items, startSlideshow: files.length > 1);
  await Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => const SlideshowPage()),
  );
}
