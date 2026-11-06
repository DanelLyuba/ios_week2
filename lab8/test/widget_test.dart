import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lw8_smart_catalog/main.dart';
import 'package:lw8_smart_catalog/models/product.dart';
import 'package:lw8_smart_catalog/screens/catalog_screen.dart';

void main() {
  testWidgets('ListView.separated toggles to 2-column GridView.builder', (tester) async {
    await tester.pumpWidget(const SmartCatalogApp());
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('12 products · Pull down to refresh'), findsOneWidget);
    await tester.tap(find.byKey(const Key('viewToggle')));
    await tester.pumpAndSettle();
    expect(find.byType(GridView), findsOneWidget);
    final grid = tester.widget<GridView>(find.byType(GridView));
    final delegate = grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    expect(delegate.crossAxisCount, 2);
    expect(delegate.childAspectRatio, 0.72);
  });

  testWidgets('Toolbar refresh waits 1500 ms, prepends a product', (tester) async {
    await tester.pumpWidget(const SmartCatalogApp());
    await tester.tap(find.byKey(const Key('refreshButton')));
    await tester.pump();
    expect(find.text('12 products · Pull down to refresh'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();
    expect(find.text('New Arrival #13'), findsOneWidget);
    expect(find.text('13 products · Pull down to refresh'), findsOneWidget);
  });

  testWidgets('Pull down invokes RefreshIndicator and adds item at index zero', (tester) async {
    await tester.pumpWidget(const SmartCatalogApp());
    await tester.drag(find.byType(ListView).first, const Offset(0, 500));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();
    expect(find.text('13 products · Pull down to refresh'), findsOneWidget);
    expect(find.text('New Arrival #13'), findsOneWidget);
  });

  testWidgets('Swipe left shows UNDO and restores original index', (tester) async {
    await tester.pumpWidget(const SmartCatalogApp());
    await tester.drag(find.byKey(const ValueKey(1)), const Offset(-650, 0));
    await tester.pumpAndSettle();
    expect(find.text('11 products · Pull down to refresh'), findsOneWidget);
    expect(find.byKey(const Key('undoSnackbar')), findsOneWidget);
    expect(find.text('UNDO'), findsOneWidget);
    await tester.tap(find.text('UNDO'));
    await tester.pumpAndSettle();
    expect(find.text('12 products · Pull down to refresh'), findsOneWidget);
    expect(find.text('Wireless Headphones'), findsOneWidget);
  });

  testWidgets('Empty state offers Reset Catalog', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: CatalogScreen(initialProducts: [ProductSeed.initial().first]),
    ));
    await tester.drag(find.byKey(const ValueKey(1)), const Offset(-650, 0));
    await tester.pumpAndSettle();
    expect(find.text('Catalog is Empty'), findsOneWidget);
    await tester.tap(find.byKey(const Key('resetCatalog')));
    await tester.pumpAndSettle();
    expect(find.text('12 products · Pull down to refresh'), findsOneWidget);
  });
}
