# LW8 — Smart Catalog & Infinite Feed (Flutter/Dart)

Narxoz University · Cross-Platform Mobile Application Development · Laboratory Work 8

## Launch

1. Unzip this folder and open **LW8_Smart_Catalog_v2** in VS Code or Android Studio.
2. Install the Flutter SDK and an Android emulator / Chrome target.
3. Run these commands from the project root:

```bash
flutter create --platforms=android,ios,web .
flutter pub get
flutter run
```

**On Windows**, omit `ios`:

```bash
flutter create --platforms=android,web .
flutter pub get
flutter run -d chrome
```

For Android, select your running emulator and use `flutter run`.

> Platform-generated folders (`android/`, `ios/`, `web/`) are intentionally not checked in. The Flutter command creates the official platform scaffolding for your local SDK. No third-party packages, external API, images or backend required.

## How to demonstrate every criterion

1. **List / Grid:** App starts in List view. Tap the grid icon in the top-right to switch to two-column Grid view. Switch back with the list icon. Both are lazy builders.
2. **Pull-to-refresh:** Go to the very TOP of the list, put your finger over the list, **drag down** until the indicator appears, and release. After **1.5 seconds** `New Arrival #13` is inserted at index 0; count becomes 13. Works in Grid view and also with a **mouse drag in Flutter Web**. The top-right refresh icon does the same thing as a reliable alternative on desktop.
3. **Swipe-to-delete:** Swipe a product **LEFT** (right-to-left) all the way: the red DELETE panel appears; after the item disappears, a dark **floating SnackBar** stays for 8 seconds. Tap **UNDO** to bring that item back to its **original index**. (A swipe to the right is intentionally disabled.)
4. **Empty state:** Delete all products, or use the small one-item widget test. The `Catalog is Empty` illustration and **Reset Catalog** button appear. Tap reset to restore all 12 seed products. Pull-to-refresh also works in empty state.

**Note for touchpads:** A two-finger swipe may scroll the page instead of triggering `Dismissible`. To delete, press and drag the item to the **left** using finger/mouse.

## Folder structure

```
lib/
  main.dart                  MaterialApp, theme, mouse/touch ScrollBehavior
  models/product.dart        Immutable Product model, 12 seed items
  screens/catalog_screen.dart State, ListView/GridView, RefreshIndicator,
                               Dismissible, SnackBar UNDO, empty state
  widgets/product_tile.dart  List item with icon, title, category, star, price
  widgets/product_card.dart  Grid card with icon, title, category, star, price

test/widget_test.dart        Automated checks for the grading criteria
```

## Rubric mapping

| Criterion | Code | Score weight |
|---|---|---:|
| Lazy list & 2-column grid | `ListView.separated`, `separatorBuilder`, `GridView.builder`, `childAspectRatio: 0.72` | 3 |
| Refresh | `RefreshIndicator`, `_refresh()`, `Future.delayed(Duration(milliseconds: 1500))`, `insert(0, ...)`, `setState` | 2 |
| Dismiss & undo | `Dismissible(key: ValueKey(product.id))`, `DismissDirection.endToStart`, red `Icons.delete`, floating SnackBar, UNDO restoring original index | 3 |
| Architecture & defense | `models/`, `widgets/`, `screens/`, simple clean methods, tests | 2 |

## Tests

```bash
flutter test
flutter analyze
```

The project includes tests for toggling, toolbar refresh, actual pull-to-refresh, swipe-and-UNDO, and empty-state reset. Run these **on your machine**; automated Flutter execution was unavailable when creating the archive.

## Short defense answers (simple English)

**Q: Why ListView.separated instead of Column?**
A: ListView builds visible items lazily. Column builds all children at once. The list uses less memory for large collections. `separatorBuilder` adds thin dividers.

**Q: What does GridView.builder do?**
A: It creates grid cards only when needed. I use two columns. `childAspectRatio: 0.72` gives each card enough height.

**Q: How does pull-to-refresh work?**
A: RefreshIndicator calls my async `_refresh` method. It waits 1.5 seconds to simulate a server, generates a unique ID, inserts a product at index 0, and calls `setState` to update the screen.

**Q: Why do you use ValueKey?**
A: Each Dismissible needs a stable unique key. I use `ValueKey(product.id)` so Flutter knows which product was swiped.

**Q: How does UNDO work?**
A: Before deleting, I save the product and its original index. After the swipe, I show a floating SnackBar. The UNDO action inserts that product at the saved index and calls `setState`.

**Q: What happens if I delete everything?**
A: The empty-state screen appears with a Reset Catalog button. It restores the 12 original products.
