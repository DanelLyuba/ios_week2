import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novasteel_explorer/core/theme.dart';
import 'package:novasteel_explorer/models/product.dart';
import 'package:novasteel_explorer/screens/product_list_screen.dart';
import 'package:novasteel_explorer/services/product_service.dart';
import 'package:novasteel_explorer/widgets/error_view.dart';

/// Fails on the first call (offline), succeeds on the second (back online).
class _FlakyService extends ProductService {
  int calls = 0;

  @override
  Future<List<Product>> fetchProducts() async {
    calls++;
    if (calls == 1) throw const ApiException('No internet connection.');
    return const [
      Product(
        id: 1,
        title: 'Test Jacket',
        price: 100,
        description: 'Warm.',
        category: 'clothing',
        imageUrl: '',
        rating: 4.2,
        reviewCount: 12,
      ),
    ];
  }
}

void main() {
  testWidgets('ErrorView retry button fires the callback', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildNovaTheme(),
        home: Scaffold(
          body: ErrorView(message: 'Offline', onRetry: () => taps++),
        ),
      ),
    );

    await tester.tap(find.text('Retry Connection'));
    expect(taps, 1);
  });

  testWidgets('feed recovers from an error via Retry, no restart needed',
      (tester) async {
    final service = _FlakyService();
    await tester.pumpWidget(
      MaterialApp(
        theme: buildNovaTheme(),
        home: ProductListScreen(service: service),
      ),
    );

    // 1) Loading
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // 2) Error with Retry
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Retry Connection'), findsOneWidget);

    // 3) Success after tapping Retry
    await tester.tap(find.text('Retry Connection'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Test Jacket'), findsOneWidget);
    expect(service.calls, 2);
  });
}
