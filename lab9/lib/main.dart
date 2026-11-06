import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'screens/catalog_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const GlobalCartApp());

class GlobalCartApp extends StatelessWidget {
  const GlobalCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Important: the provider is ABOVE MaterialApp, so both routes share it.
    return ChangeNotifierProvider<CartProvider>(
      create: (_) => CartProvider(),
      child: MaterialApp(
        title: 'NOVA | Global Cart',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const CatalogScreen(),
      ),
    );
  }
}
