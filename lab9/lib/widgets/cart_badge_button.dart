import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../screens/cart_screen.dart';
import '../theme/app_theme.dart';

class CartBadgeButton extends StatelessWidget {
  const CartBadgeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) => Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Semantics(
          label: 'Open cart, ${cart.itemCount} items',
          button: true,
          child: IconButton(
            key: const Key('open_cart'),
            tooltip: 'View cart (${cart.itemCount})',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const CartScreen()),
            ),
            icon: SizedBox(
              width: 38,
              height: 38,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Icon(Icons.shopping_bag_outlined, size: 27, color: AppTheme.ink),
                  ),
                  if (cart.itemCount > 0)
                    Positioned(
                      top: -1, right: -2,
                      child: Container(
                        key: const Key('cart_badge'),
                        constraints: const BoxConstraints(minWidth: 19, minHeight: 19),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.green,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.canvas, width: 1.5),
                        ),
                        child: Center(
                          child: Text('${cart.itemCount}', style: const TextStyle(
                            color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900,
                          )),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
