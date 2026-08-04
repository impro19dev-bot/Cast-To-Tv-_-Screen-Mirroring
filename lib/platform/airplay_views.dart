import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_theme.dart';
import '../l10n/strings.dart';

class RoutePickerButton extends StatelessWidget {
  const RoutePickerButton({
    super.key,
    this.width = 44,
    this.height = 44,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return SizedBox(
        width: width,
        height: height,
        child: Icon(Icons.cast_rounded, color: context.muted),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: const UiKitView(
        viewType: 'CastRoutePickerView',
        creationParams: <String, dynamic>{},
        creationParamsCodec: StandardMessageCodec(),
      ),
    );
  }
}

class ExternalVideoSurface extends StatelessWidget {
  const ExternalVideoSurface({
    super.key,
    this.filePath,
    this.url,
  });

  final String? filePath;
  final String? url;

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return Center(child: Text(AppStrings.of(context).iosOnlyAirPlay));
    }

    return UiKitView(
      viewType: 'CastVideoPlayerView',
      creationParams: <String, dynamic>{
        if (filePath != null) 'filePath': filePath,
        if (url != null) 'url': url,
      },
      creationParamsCodec: const StandardMessageCodec(),
      layoutDirection: TextDirection.ltr,
    );
  }
}
