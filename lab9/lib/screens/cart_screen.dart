import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/product_tile.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Your cart', style: TextStyle(fontWeight: FontWeight.w900)),
      actions: [
        Consumer<CartProvider>(
          builder: (context, cart, _) => TextButton.icon(
            key: const Key('clear_all'),
            onPressed: cart.itemCount == 0 ? null : cart.clearAll,
            icon: const Icon(Icons.delete_sweep_outlined, size: 19),
            label: const Text('Clear All'),
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFB64D4D)),
          ),
        ),
        const SizedBox(width: 8),
      ],
    ),
    body: SafeArea(
      child: Consumer<CartProvider>(
        builder: (context, cart, _) {
          final products = cart.items;
          if (products.isEmpty) return const _EmptyCart();
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                    child: Row(children: [
                      Text('${cart.itemCount} selected ${cart.itemCount == 1 ? 'item' : 'items'}',
                        style: const TextStyle(fontSize: 14, color: AppTheme.muted,
                          fontWeight: FontWeight.w700)),
                      const Spacer(),
                      const Icon(Icons.sync_rounded, size: 16, color: AppTheme.green),
                      const SizedBox(width: 5),
                      const Text('Synced live', style: TextStyle(
                        color: AppTheme.green, fontSize: 12, fontWeight: FontWeight.w700)),
                    ]),
                  ),
                  Expanded(
                    child: ListView.separated(
                      key: const Key('cart_list'),
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      itemCount: products.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 11),
                      itemBuilder: (context, index) => _CartItem(
                        key: ValueKey(products[index].id),
                        product: products[index],
                      ),
                    ),
                  ),
                  _CartSummary(totalPrice: cart.totalPrice, count: cart.itemCount),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}

class _CartItem extends StatelessWidget {
  const _CartItem({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
      border: Border.all(color: const Color(0xFFE8EDF0)),
    ),
    child: Row(children: [
      ProductArt(product: product, size: 72),
      const SizedBox(width: 13),
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(product.name, style: const TextStyle(
            fontWeight: FontWeight.w800, color: AppTheme.ink, fontSize: 15)),
          const SizedBox(height: 4),
          Text(product.category, style: const TextStyle(
            color: AppTheme.muted, fontSize: 10, letterSpacing: 0.7)),
          const SizedBox(height: 8),
          Text(formatKzt(product.price), style: const TextStyle(
            fontWeight: FontWeight.w900, color: AppTheme.ink, fontSize: 15)),
        ],
      )),
      IconButton(
        key: Key('remove_${product.id}'),
        tooltip: 'Remove ${product.name}',
        onPressed: () => context.read<CartProvider>().remove(product),
        icon: const Icon(Icons.close_rounded, color: Color(0xFFBD5353)),
      ),
    ]),
  );
}

class _CartSummary extends StatelessWidget {
  const _CartSummary({required this.totalPrice, required this.count});
  final int totalPrice;
  final int count;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(24, 18, 24, 22),
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(top: BorderSide(color: Color(0xFFE7EDF0))),
    ),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Row(children: [
        Text('Subtotal ($count)', style: const TextStyle(color: AppTheme.muted)),
        const Spacer(),
        Text(formatKzt(totalPrice), style: const TextStyle(
          color: AppTheme.ink, fontSize: 17, fontWeight: FontWeight.w800)),
      ]),
      const SizedBox(height: 10),
      const Divider(height: 1),
      const SizedBox(height: 12),
      Row(children: [
        const Text('Total', style: TextStyle(color: AppTheme.ink,
          fontSize: 18, fontWeight: FontWeight.w800)),
        const Spacer(),
        Text(formatKzt(totalPrice), key: const Key('cart_total'),
          style: const TextStyle(color: AppTheme.green,
            fontSize: 23, fontWeight: FontWeight.w900)),
      ]),
    ]),
  );
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 118, width: 118,
            decoration: const BoxDecoration(
              shape: BoxShape.circle, color: Color(0xFFE4F3EE)),
            child: const Icon(Icons.shopping_bag_outlined,
              size: 54, color: AppTheme.green),
          ),
          const SizedBox(height: 20),
          const Text('Your cart is empty', key: Key('empty_cart'),
            style: TextStyle(color: AppTheme.ink, fontSize: 25,
              fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('Choose something you love from the catalog.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.muted, fontSize: 14)),
          const SizedBox(height: 22),
          FilledButton.icon(
            key: const Key('browse_products'),
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Browse products'),
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.green,
              padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 14)),
          ),
        ],
      ),
    ),
  );
}
