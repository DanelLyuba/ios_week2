import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_cart_live_badge/main.dart';

void main() {
  testWidgets('badge updates and removal synchronizes back to catalog', (tester) async {
    await tester.pumpWidget(const GlobalCartApp());
    expect(find.text('Discover products'), findsOneWidget);
    expect(find.byKey(const Key('cart_badge')), findsNothing);

    await tester.tap(find.byKey(const Key('toggle_1')));
    await tester.pumpAndSettle();
    expect(find.text('Added'), findsOneWidget);
    expect(find.descendant(
      of: find.byKey(const Key('cart_badge')), matching: find.text('1')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('open_cart')));
    await tester.pumpAndSettle();
    expect(find.text('Your cart'), findsOneWidget);
    expect(find.byKey(const Key('remove_1')), findsOneWidget);
    expect(find.byKey(const Key('cart_total')), findsOneWidget);
    expect(find.text('24 990 ₸'), findsWidgets);

    await tester.tap(find.byKey(const Key('remove_1')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('empty_cart')), findsOneWidget);

    await tester.tap(find.byKey(const Key('browse_products')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('cart_badge')), findsNothing);
    expect(find.byKey(const Key('toggle_1')), findsOneWidget);
    expect(find.text('Added'), findsNothing);
  });

  testWidgets('Clear All removes all selected items', (tester) async {
    await tester.pumpWidget(const GlobalCartApp());
    await tester.tap(find.byKey(const Key('toggle_1')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('toggle_2')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('toggle_2')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('open_cart')));
    await tester.pumpAndSettle();
    expect(find.text('2 selected items'), findsOneWidget);
    await tester.tap(find.byKey(const Key('clear_all')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('empty_cart')), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Added'), findsNothing);
  });
}
