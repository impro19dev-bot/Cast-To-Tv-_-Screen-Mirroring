import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../l10n/strings.dart';
import '../../platform/airplay_views.dart';
import '../../services/haptics.dart';
import '../../services/media_library.dart';
import '../../ui/components.dart';
import 'photo_cast_page.dart';
import 'slideshow_page.dart';

class PhotosPage extends StatefulWidget {
  const PhotosPage({super.key});

  @override
  State<PhotosPage> createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  final _library = MediaLibrary();
  bool _picking = false;

  Future<void> _pickOne() async {
    setState(() => _picking = true);
    final file = await _library.pickPhoto(context);
    if (!mounted) return;
    setState(() => _picking = false);
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.of(context).photoCancelled)),
      );
      return;
    }
    await Haptics.light();
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => PhotoCastPage(imageFile: file)),
    );
  }

  Future<void> _pickMany() async {
    setState(() => _picking = true);
    final files = await _library.pickPhotos(context);
    if (!mounted) return;
    setState(() => _picking = false);
    if (files.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.of(context).photoCancelled)),
      );
      return;
    }
    await Haptics.light();
    if (!mounted) return;
    await openPhotoSlideshow(context, files);
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final pad = Breakpoints.pad(context);

    return Scaffold(
      backgroundColor: context.pageBg,
      appBar: FeatureAppBar(title: s.photos),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          pad,
          8,
          pad,
          MediaQuery.paddingOf(context).bottom + 24,
        ),
        children: [
          SizedBox(
            height: 180,
            child: EmptyPanel(
              icon: Icons.photo_library_outlined,
              title: s.noPhoto,
              message: s.choosePhotoMsg,
            ),
          ),
          if (_picking)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            )
          else ...[
            PrimaryButton(
              label: s.startSlideshow,
              icon: Icons.slideshow_rounded,
              onPressed: _pickMany,
            ),
            const SizedBox(height: 10),
            PrimaryButton(
              label: s.choosePhoto,
              icon: Icons.photo_outlined,
              onPressed: _pickOne,
              outlined: true,
            ),
          ],
          const SizedBox(height: 16),
          SectionCard(
            title: s.airplayPicker,
            icon: Icons.cast_rounded,
            children: [
              Text(
                s.photoAirplayHint,
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
      ),
    );
  }
}
