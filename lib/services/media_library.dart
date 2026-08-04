import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../l10n/strings.dart';

class MediaLibrary {
  MediaLibrary({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  Future<File?> pickPhoto(BuildContext context) async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 92,
      );
      if (file == null) return null;
      return File(file.path);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.of(context).photoPermissionDenied)),
        );
      }
      return null;
    }
  }

  Future<List<File>> pickPhotos(BuildContext context) async {
    try {
      final files = await _picker.pickMultiImage(imageQuality: 92);
      return files.map((e) => File(e.path)).toList();
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.of(context).photoPermissionDenied)),
        );
      }
      return const [];
    }
  }

  Future<File?> pickVideo(BuildContext context) async {
    try {
      final file = await _picker.pickVideo(source: ImageSource.gallery);
      if (file == null) return null;
      return File(file.path);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.of(context).videoPermissionDenied)),
        );
      }
      return null;
    }
  }
}
