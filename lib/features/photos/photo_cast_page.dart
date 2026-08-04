import 'dart:io';

import 'package:flutter/material.dart';

import '../../cast/cast_item.dart';
import '../../cast/cast_session_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../l10n/strings.dart';
import '../../platform/airplay_views.dart';
import '../../ui/components.dart';

class PhotoCastPage extends StatelessWidget {
  const PhotoCastPage({super.key, required this.imageFile});

  final File imageFile;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final pad = Breakpoints.pad(context);

    // Register single photo in the cast session for Remote / recent.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CastSessionProvider.read(context).setSingle(
        CastItem(
          kind: CastItemKind.photo,
          source: imageFile.path,
          title: imageFile.uri.pathSegments.isNotEmpty
              ? imageFile.uri.pathSegments.last
              : 'Photo',
        ),
      );
    });

    return Scaffold(
      backgroundColor: context.pageBg,
      appBar: FeatureAppBar(
        title: s.photoPreview,
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
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(imageFile, fit: BoxFit.contain),
          ),
          const SizedBox(height: 16),
          SectionCard(
            title: s.airplayPicker,
            icon: Icons.cast_rounded,
            children: [
              Text(
                s.photoAirplayHint,
                style: TextStyle(height: 1.45, color: context.muted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
