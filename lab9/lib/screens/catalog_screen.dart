import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/cart_badge_button.dart';
import '../widgets/product_tile.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      toolbarHeight: 72,
      title: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.hexagon_rounded, color: AppTheme.green, size: 31),
          SizedBox(width: 8),
          Text('NOVA', style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 2.3,
          )),
          Text(' / SHOP', style: TextStyle(fontSize: 12, color: AppTheme.muted)),
        ],
      ),
      actions: const [CartBadgeButton()],
    ),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
                sliver: SliverList.list(children: [
                  Container(
                    padding: const EdgeInsets.all(23),
                    decoration: BoxDecoration(
                      color: AppTheme.ink,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CURATED FOR YOU', style: TextStyle(
                          fontSize: 11, letterSpacing: 1.5,
                          color: Color(0xFF96E7D2), fontWeight: FontWeight.w800)),
                        SizedBox(height: 9),
                        Text('Everyday essentials.\nExtraordinary design.', style: TextStyle(
                          fontSize: 26, fontWeight: FontWeight.w900,
                          color: Colors.white, height: 1.15)),
                        SizedBox(height: 12),
                        Text('Explore the collection and build your cart.', style: TextStyle(
                          color: Color(0xFFC5D2DE), fontSize: 13)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  const Row(children: [
                    Expanded(child: Text('Discover products', style: TextStyle(
                      fontSize: 22, color: AppTheme.ink, fontWeight: FontWeight.w900))),
                    Text('06 ITEMS', style: TextStyle(color: AppTheme.muted,
                      fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1)),
                  ]),
                  const SizedBox(height: 14),
                ]),
              ),
              Consumer<CartProvider>(
                builder: (context, cart, _) => SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  sliver: SliverList.separated(
                    itemCount: demoProducts.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 11),
                    itemBuilder: (context, index) {
                      final product = demoProducts[index];
                      return ProductTile(
                        key: Key('product_${product.id}'),
                        product: product,
                        isInCart: cart.contains(product),
                        onToggle: () => context.read<CartProvider>().toggle(product),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
