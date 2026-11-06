import 'package:flutter/material.dart';

@immutable
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.category,
    required this.price,
    required this.icon,
    required this.accent,
  });

  final int id;
  final String name;
  final String subtitle;
  final String category;
  final int price;
  final IconData icon;
  final Color accent;
}

const List<Product> demoProducts = [
  Product(
    id: 1, name: 'Wireless Headphones', subtitle: 'Studio-quality sound',
    category: 'AUDIO', price: 24990, icon: Icons.headphones_rounded,
    accent: Color(0xFF596DD8),
  ),
  Product(
    id: 2, name: 'Smart Watch', subtitle: 'Everyday fitness companion',
    category: 'WEARABLES', price: 35990, icon: Icons.watch_rounded,
    accent: Color(0xFFCE7962),
  ),
  Product(
    id: 3, name: 'Mini Camera', subtitle: 'Capture every moment',
    category: 'CAMERAS', price: 49990, icon: Icons.camera_alt_rounded,
    accent: Color(0xFF609A7E),
  ),
  Product(
    id: 4, name: 'Portable Speaker', subtitle: 'Sound that travels',
    category: 'AUDIO', price: 18990, icon: Icons.speaker_rounded,
    accent: Color(0xFFAA78BB),
  ),
  Product(
    id: 5, name: 'Desk Lamp', subtitle: 'A brighter workspace',
    category: 'HOME', price: 12990, icon: Icons.light_rounded,
    accent: Color(0xFFDAA04D),
  ),
  Product(
    id: 6, name: 'Wireless Mouse', subtitle: 'Precision in your palm',
    category: 'ACCESSORIES', price: 9990, icon: Icons.mouse_rounded,
    accent: Color(0xFF5F95A6),
  ),
];
