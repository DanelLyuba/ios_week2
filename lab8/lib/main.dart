import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'screens/catalog_screen.dart';

void main() => runApp(const SmartCatalogApp());

/// Enables pull-to-refresh with finger AND mouse (Flutter Web/desktop).
class CatalogScrollBehavior extends MaterialScrollBehavior {
  const CatalogScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };
}

class SmartCatalogApp extends StatelessWidget {
  const SmartCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Catalog | LW8',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const CatalogScrollBehavior(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3857C8),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF4F6FB),
          scrolledUnderElevation: 0,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: const Color(0xFF202A42),
          actionTextColor: const Color(0xFFB8CBFF),
          contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      home: const CatalogScreen(),
    );
  }
}
