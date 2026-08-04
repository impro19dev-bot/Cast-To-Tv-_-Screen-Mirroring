import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../l10n/strings.dart';
import '../../platform/airplay_views.dart';
import '../../services/haptics.dart';
import '../../services/media_library.dart';
import '../../ui/components.dart';
import 'video_cast_page.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({super.key});

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  final _library = MediaLibrary();
  bool _picking = false;

  Future<void> _pick() async {
    setState(() => _picking = true);
    final file = await _library.pickVideo(context);
    if (!mounted) return;
    setState(() => _picking = false);
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.of(context).noVideo)),
      );
      return;
    }
    await Haptics.light();
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => VideoCastPage(videoFile: file)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final pad = Breakpoints.pad(context);

    return Scaffold(
      backgroundColor: context.pageBg,
      appBar: FeatureAppBar(title: s.videos),
      body: ListView(
        padding: EdgeInsets.fromLTRB(pad, 8, pad, MediaQuery.paddingOf(context).bottom + 24),
        children: [
          SizedBox(
            height: 220,
            child: EmptyPanel(
              icon: Icons.videocam_outlined,
              title: s.noVideo,
              message: s.chooseVideoMsg,
            ),
          ),
          if (_picking)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            )
          else
            PrimaryButton(
              label: s.chooseVideo,
              icon: Icons.video_library_outlined,
              onPressed: _pick,
            ),
          const SizedBox(height: 16),
          SectionCard(
            title: s.airplayPicker,
            icon: Icons.cast_rounded,
            children: [
              Text(s.castVideoBody, style: TextStyle(height: 1.45, color: context.muted)),
              const SizedBox(height: 12),
              const Align(
                alignment: Alignment.centerRight,
                child: RoutePickerButton(width: 48, height: 48),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
