import 'package:flutter_test/flutter_test.dart';
import 'package:global_cart_live_badge/models/product.dart';
import 'package:global_cart_live_badge/providers/cart_provider.dart';

void main() {
  group('CartProvider', () {
    test('initially empty with zero total', () {
      final cart = CartProvider();
      expect(cart.itemCount, 0);
      expect(cart.totalPrice, 0);
      expect(cart.items, isEmpty);
    });

    test('toggle selects and deselects a product', () {
      final cart = CartProvider();
      cart.toggle(demoProducts.first);
      expect(cart.contains(demoProducts.first), isTrue);
      expect(cart.itemCount, 1);
      cart.toggle(demoProducts.first);
      expect(cart.contains(demoProducts.first), isFalse);
      expect(cart.itemCount, 0);
    });

    test('duplicate add does not increase count; notifications only on change', () {
      final cart = CartProvider();
      var notifications = 0;
      cart.addListener(() => notifications++);
      cart.add(demoProducts.first);
      cart.add(demoProducts.first);
      expect(cart.itemCount, 1);
      expect(notifications, 1);
    });

    test('total updates on individual removal', () {
      final cart = CartProvider();
      cart.add(demoProducts[0]);
      cart.add(demoProducts[1]);
      expect(cart.totalPrice, 24990 + 35990);
      cart.remove(demoProducts[0]);
      expect(cart.totalPrice, 35990);
    });

    test('clearAll removes everything and resets total', () {
      final cart = CartProvider();
      for (final product in demoProducts) {
        cart.add(product);
      }
      expect(cart.itemCount, 6);
      cart.clearAll();
      expect(cart.itemCount, 0);
      expect(cart.totalPrice, 0);
    });
  });
}
