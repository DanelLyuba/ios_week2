# NOVA / SHOP — Multi-Screen Global Cart with Live Badge

A complete Flutter + Dart lab assignment demonstrating shared reactive state across **two routes** with `ChangeNotifier` and the `provider` package.

## Quick start

Requirements: Flutter SDK installed, Chrome or an Android/iOS emulator.

```bash
# Unzip and open the Global_Cart_Live_Badge directory
flutter create --platforms=android,web .
flutter pub get
flutter run -d chrome
```

For an Android emulator, run `flutter devices` then `flutter run -d <device_id>`.

The `flutter create ... .` command only generates missing platform bootstrap folders, because they are Flutter-version-specific. All application Dart source code and tests are included. Run the command **inside the extracted directory**, not its parent.

## What to demonstrate to the instructor

1. **Catalog:** Six products visible. Click **Add** on headphones and watch. Both buttons turn **Added**, and the AppBar bag badge shows **2**.
2. **Navigation:** Click the bag button to open the cart route. Both selected products appear.
3. **Total:** 24 990 ₸ + 35 990 ₸ = **60 980 ₸**.
4. **Single remove:** Tap the `×` button next to the headphones. The total becomes **35 990 ₸**.
5. **Return:** Press Back. The headphones button is now **Add** (not Added); the watch remains **Added**, and the badge is **1**. No manual refresh was required.
6. **Clear All:** Open the cart, click **Clear All**, observe the empty-cart screen, and return. All six products are no longer selected, and the badge disappears.

## Task checklist

| Requirement | Implementation |
|---|---|
| `CartProvider` extends `ChangeNotifier` | `lib/providers/cart_provider.dart` |
| Wrap `MaterialApp` with `ChangeNotifierProvider` | `lib/main.dart` |
| Catalog with six products and Add/Added toggles | `lib/screens/catalog_screen.dart` + `lib/widgets/product_tile.dart` |
| Live AppBar cart badge | `lib/widgets/cart_badge_button.dart` using `Consumer<CartProvider>` |
| Cart products and individual removal | `lib/screens/cart_screen.dart` |
| Live total price | `CartProvider.totalPrice`, displayed by `_CartSummary` |
| Clear All | `CartProvider.clearAll()` and Cart AppBar action |
| Changes sync across routes | Both screens use the **same** provider above `MaterialApp` |
| Empty cart | Dedicated empty-state widget with Browse products |
| Automated tests | `test/cart_provider_test.dart` + `test/widget_test.dart` |

## Project structure

```text
lib/
  main.dart
  models/product.dart
  providers/cart_provider.dart
  screens/catalog_screen.dart
  screens/cart_screen.dart
  theme/app_theme.dart
  widgets/cart_badge_button.dart
  widgets/product_tile.dart
test/
  cart_provider_test.dart
  widget_test.dart
pubspec.yaml
analysis_options.yaml
```

## Test and quality checks

```bash
flutter analyze
flutter test
```

## Rapid defense Q&A (simple English)

**Q: What is `ChangeNotifier`?**  
A: It is a Flutter class that tells listeners when data changes. I call `notifyListeners()` after changing the cart.

**Q: Why is the provider above `MaterialApp`?**  
A: Both screens need the same cart state. Putting the provider above `MaterialApp` makes it available across routes.

**Q: Why do we use `Consumer<CartProvider>`?**  
A: It listens to cart changes and rebuilds the related user interface automatically.

**Q: How does the badge update?**  
A: It reads `cart.itemCount`. After I add or remove a product, the provider notifies listeners and the badge rebuilds.

**Q: How is the total calculated?**  
A: The provider uses `fold` to sum prices of all selected products.

**Q: How are the catalog and cart synchronized?**  
A: Both screens read the same `CartProvider`. I do not copy cart data into local screen state.

**Q: Can one product be added twice?**  
A: No. I store selected product IDs in a `Set`. A set cannot contain duplicate IDs.

## Notes

- This is an in-memory demo cart. Selection is reset when the application process is restarted.
- No internet access, image hosting, server, database or API key is needed for the product catalog.
- Prices are sample amounts in Kazakhstani tenge.
