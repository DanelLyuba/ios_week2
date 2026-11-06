import 'package:flutter/material.dart';
import '../models/product.dart';
import 'product_tile.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: theme.colorScheme.outlineVariant)),
      child: Padding(
        padding: const EdgeInsets.all(11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(color: product.color.withOpacity(0.12), borderRadius: BorderRadius.circular(13)),
                child: Icon(product.icon, size: 49, color: product.color),
              ),
            ),
            const SizedBox(height: 8),
            Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(product.category, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 5),
            Row(children: [
              const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 16),
              Text(product.rating.toStringAsFixed(1), style: theme.textTheme.labelSmall),
              const Spacer(),
              Flexible(child: Text(priceLabel(product.price), overflow: TextOverflow.ellipsis, maxLines: 1, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w800))),
            ]),
          ],
        ),
      ),
    );
  }
}
