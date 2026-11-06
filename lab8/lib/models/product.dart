import 'package:flutter/material.dart';

@immutable
class Product {
  const Product({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.rating,
    required this.icon,
    required this.color,
  });

  final int id;
  final String title;
  final String category;
  final double price;
  final double rating;
  final IconData icon;
  final Color color;
}

class ProductSeed {
  static List<Product> initial() => const [
        Product(id: 1, title: 'Wireless Headphones', category: 'Electronics', price: 24990, rating: 4.8, icon: Icons.headphones, color: Color(0xFF6750A4)),
        Product(id: 2, title: 'Smart Watch', category: 'Wearables', price: 39990, rating: 4.7, icon: Icons.watch, color: Color(0xFF007F86)),
        Product(id: 3, title: 'Coffee Maker', category: 'Home', price: 32990, rating: 4.6, icon: Icons.coffee_maker, color: Color(0xFFD97745)),
        Product(id: 4, title: 'Bluetooth Speaker', category: 'Electronics', price: 18990, rating: 4.5, icon: Icons.speaker, color: Color(0xFF4675BD)),
        Product(id: 5, title: 'Running Shoes', category: 'Fashion', price: 27990, rating: 4.9, icon: Icons.directions_run, color: Color(0xFFB0527C)),
        Product(id: 6, title: 'Desk Lamp', category: 'Home', price: 12990, rating: 4.4, icon: Icons.light, color: Color(0xFF8B6B30)),
        Product(id: 7, title: 'Laptop Backpack', category: 'Accessories', price: 16990, rating: 4.7, icon: Icons.backpack, color: Color(0xFF527E65)),
        Product(id: 8, title: 'Gaming Mouse', category: 'Electronics', price: 14990, rating: 4.8, icon: Icons.mouse, color: Color(0xFF8251A3)),
        Product(id: 9, title: 'Water Bottle', category: 'Lifestyle', price: 5990, rating: 4.6, icon: Icons.water_drop, color: Color(0xFF2689A7)),
        Product(id: 10, title: 'Phone Stand', category: 'Accessories', price: 4990, rating: 4.5, icon: Icons.phone_android, color: Color(0xFFB16839)),
        Product(id: 11, title: 'Portable Charger', category: 'Electronics', price: 19990, rating: 4.7, icon: Icons.battery_charging_full, color: Color(0xFF407D78)),
        Product(id: 12, title: 'Yoga Mat', category: 'Fitness', price: 10990, rating: 4.8, icon: Icons.fitness_center, color: Color(0xFF9B5873)),
      ];
}
