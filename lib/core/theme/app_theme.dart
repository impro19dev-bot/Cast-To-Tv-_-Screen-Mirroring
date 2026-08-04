import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'palette.dart';

abstract final class AppTheme {
  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: Palette.brand,
      brightness: brightness,
      primary: Palette.brand,
      secondary: Palette.teal,
      surface: isDark ? Palette.darkCard : Palette.lightCard,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: isDark ? Palette.darkBg : Palette.lightBg,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: isDark ? Palette.darkBg : Palette.lightBg,
        foregroundColor: isDark ? Palette.darkText : Palette.lightText,
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        color: isDark ? Palette.darkCard : Palette.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: Palette.brand,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? Palette.darkCard : Palette.lightCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? Palette.darkCard : Palette.lightCard,
        indicatorColor: Palette.brand.withValues(alpha: 0.14),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? Palette.darkText : Palette.lightText,
          ),
        ),
      ),
    );
  }
}

extension ThemeContextX on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get pageBg =>
      isDark ? Palette.darkBg : Palette.lightBg;

  Color get cardBg =>
      isDark ? Palette.darkCard : Palette.lightCard;

  Color get ink =>
      isDark ? Palette.darkText : Palette.lightText;

  Color get muted =>
      isDark ? Palette.darkMuted : Palette.lightMuted;
}
