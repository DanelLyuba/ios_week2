import 'package:flutter/material.dart';
import '../models/product.dart';

String priceLabel(double amount) {
  final number = amount.toStringAsFixed(0);
  final parts = <String>[];
  for (var end = number.length; end > 0; end -= 3) {
    final start = end - 3 < 0 ? 0 : end - 3;
    parts.insert(0, number.substring(start, end));
  }
  return '${parts.join(' ')} ₸';
}

class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(color: product.color.withOpacity(0.13), borderRadius: BorderRadius.circular(17)),
            child: Icon(product.icon, color: product.color, size: 30),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 5),
                Text(product.category, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                const SizedBox(height: 5),
                Row(children: [const Icon(Icons.star_rounded, size: 17, color: Color(0xFFFFB300)), const SizedBox(width: 3), Text(product.rating.toStringAsFixed(1), style: theme.textTheme.labelMedium)]),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(priceLabel(product.price), style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
