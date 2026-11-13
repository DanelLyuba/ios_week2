import 'package:flutter/material.dart';

/// NovaSteel design tokens: a quiet, brushed-steel palette.
abstract final class NovaColors {
  static const Color ink = Color(0xFF14181C);
  static const Color steel = Color(0xFF2F4B63);
  static const Color steelSoft = Color(0xFFE6ECF1);
  static const Color mist = Color(0xFFF4F6F8);
  static const Color line = Color(0xFFE3E7EB);
  static const Color muted = Color(0xFF6B7783);
  static const Color star = Color(0xFFC8963E);
  static const Color surface = Color(0xFFFFFFFF);
}

ThemeData buildNovaTheme() {
  final base = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: NovaColors.mist,
    colorScheme: ColorScheme.fromSeed(seedColor: NovaColors.steel).copyWith(
      primary: NovaColors.steel,
      onPrimary: Colors.white,
      surface: NovaColors.surface,
      onSurface: NovaColors.ink,
    ),
  );

  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: NovaColors.ink,
      displayColor: NovaColors.ink,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: NovaColors.mist,
      foregroundColor: NovaColors.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: NovaColors.steel,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: NovaColors.steel,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(0, 52),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: NovaColors.ink,
      contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
