import 'package:flutter/material.dart';

/// Fresh ocean identity — distinct from prior blue/purple marketing look.
abstract final class Palette {
  static const brand = Color(0xFF0B6BCB);
  static const brandDeep = Color(0xFF084B8A);
  static const brandSoft = Color(0xFF3AA0F0);
  static const teal = Color(0xFF0E9F9B);
  static const coral = Color(0xFFE4572E);
  static const amber = Color(0xFFF0A202);
  static const leaf = Color(0xFF2A9D8F);

  static const lightBg = Color(0xFFF3F7FB);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightText = Color(0xFF15202B);
  static const lightMuted = Color(0xFF667788);

  static const darkBg = Color(0xFF0E141B);
  static const darkCard = Color(0xFF182230);
  static const darkText = Color(0xFFF2F6FA);
  static const darkMuted = Color(0xFF9AA8B5);

  static const mirrorGradient = [Color(0xFF0B6BCB), Color(0xFF0E9F9B)];
  static const mediaGradient = [Color(0xFFE4572E), Color(0xFFF0A202)];
  static const remoteGradient = [Color(0xFF084B8A), Color(0xFF3AA0F0)];
}
