import 'package:flutter/material.dart';

class AppTheme {
  static const ink = Color(0xFF14243B);
  static const muted = Color(0xFF728096);
  static const green = Color(0xFF087F69);
  static const canvas = Color(0xFFF5F7F8);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: canvas,
    colorScheme: ColorScheme.fromSeed(
      seedColor: green,
      brightness: Brightness.light,
      surface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: canvas,
      foregroundColor: ink,
      centerTitle: false,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(fontSize: 29, fontWeight: FontWeight.w800, color: ink, height: 1.12),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: ink),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ink),
      bodyMedium: TextStyle(fontSize: 14, color: muted, height: 1.4),
    ),
  );
}
