import 'package:flutter_test/flutter_test.dart';
import 'package:novasteel_explorer/core/format.dart';
import 'package:novasteel_explorer/models/product.dart';

void main() {
  group('Product.fromJson', () {
    test('parses a complete payload', () {
      final p = Product.fromJson({
        'id': 1,
        'title': 'Test Jacket',
        'price': 109.95,
        'description': 'Warm.',
        'category': "men's clothing",
        'image': 'https://example.com/a.png',
        'rating': {'rate': 3.9, 'count': 120},
      });

      expect(p.id, 1);
      expect(p.title, 'Test Jacket');
      expect(p.price, 109.95);
      expect(p.category, "men's clothing");
      expect(p.imageUrl, 'https://example.com/a.png');
      expect(p.rating, 3.9);
      expect(p.reviewCount, 120);
      expect(p.deepLink, 'narxoz://store/product/1');
    });

    test('an int price does not crash (num -> double)', () {
      final p = Product.fromJson({
        'id': 2,
        'price': 100,
        'rating': {'rate': 4, 'count': 10},
      });

      expect(p.price, isA<double>());
      expect(p.price, 100.0);
      expect(p.rating, 4.0);
    });

    test('null / missing fields fall back to safe defaults', () {
      final p = Product.fromJson({'id': null, 'title': null, 'rating': null});

      expect(p.id, 0);
      expect(p.title, 'Untitled product');
      expect(p.price, 0.0);
      expect(p.category, 'general');
      expect(p.imageUrl, '');
      expect(p.rating, 0.0);
      expect(p.reviewCount, 0);
    });
  });

  group('formatTenge', () {
    test('zero', () => expect(formatTenge(0), '0 ₸'));

    test('groups thousands with non-breaking spaces', () {
      expect(formatTenge(1000 / kUsdToKzt), '1 000 ₸');
    });
  });

  test('titleCase', () {
    expect(titleCase("men's clothing"), "Men's Clothing");
  });
}
