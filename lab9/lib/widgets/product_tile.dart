import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/app_theme.dart';

String formatKzt(int amount) {
  final value = amount.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < value.length; i++) {
    if (i > 0 && (value.length - i) % 3 == 0) buffer.write(' ');
    buffer.write(value[i]);
  }
  return '${buffer.toString()} ₸';
}

class ProductArt extends StatelessWidget {
  const ProductArt({super.key, required this.product, this.size = 84});
  final Product product;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      color: product.accent.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Icon(product.icon, size: size * .48, color: product.accent),
  );
}

class ProductTile extends StatelessWidget {
  const ProductTile({
    super.key,
    required this.product,
    required this.isInCart,
    required this.onToggle,
  });

  final Product product;
  final bool isInCart;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.circular(22),
      border: Border.all(color: const Color(0xFFE8EDF0)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ProductArt(product: product),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(product.category, style: const TextStyle(
                fontSize: 10, fontWeight: FontWeight.w800,
                color: AppTheme.green, letterSpacing: 1.1,
              )),
              const SizedBox(height: 4),
              Text(product.name,
                maxLines: 2, overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppTheme.ink, fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(product.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
              const SizedBox(height: 9),
              Text(formatKzt(product.price), style: const TextStyle(
                color: AppTheme.ink, fontSize: 16, fontWeight: FontWeight.w900)),
            ],
          ),
        ),
        const SizedBox(width: 7),
        Tooltip(
          message: isInCart ? 'Remove from cart' : 'Add to cart',
          child: FilledButton.tonalIcon(
            key: Key('toggle_${product.id}'),
            onPressed: onToggle,
            icon: Icon(isInCart ? Icons.check_rounded : Icons.add_rounded, size: 18),
            label: Text(isInCart ? 'Added' : 'Add', style: const TextStyle(fontSize: 12)),
            style: FilledButton.styleFrom(
              backgroundColor: isInCart ? const Color(0xFFDDF5EC) : const Color(0xFFEFF4F5),
              foregroundColor: isInCart ? AppTheme.green : AppTheme.ink,
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
              visualDensity: VisualDensity.compact,
            ),
          ),
        ),
      ],
    ),
  );
}
