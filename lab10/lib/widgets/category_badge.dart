import 'package:flutter/material.dart';

import '../core/theme.dart';

class CategoryBadge extends StatelessWidget {
  const CategoryBadge(this.category, {super.key});

  final String category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: NovaColors.steelSoft,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        category.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
          color: NovaColors.steel,
        ),
      ),
    );
  }
}
