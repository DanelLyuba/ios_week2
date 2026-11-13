import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'screens/product_list_screen.dart';

void main() => runApp(const NovaSteelApp());

class NovaSteelApp extends StatelessWidget {
  const NovaSteelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NovaSteel',
      debugShowCheckedModeBanner: false,
      theme: buildNovaTheme(),
      home: const ProductListScreen(),
    );
  }
}
