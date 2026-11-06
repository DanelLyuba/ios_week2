import 'package:flutter/foundation.dart';

import '../models/product.dart';

/// The single source of truth shared by CatalogScreen and CartScreen.
class CartProvider extends ChangeNotifier {
  final Set<int> _selectedIds = <int>{};

  /// A snapshot so callers cannot mutate the provider's internal state.
  Set<int> get selectedIds => Set<int>.unmodifiable(_selectedIds);

  bool contains(Product product) => _selectedIds.contains(product.id);

  int get itemCount => _selectedIds.length;

  /// Cart order follows the original catalog order for a stable interface.
  List<Product> get items => List<Product>.unmodifiable(
    demoProducts.where((product) => _selectedIds.contains(product.id)),
  );

  int get totalPrice => items.fold<int>(0, (sum, item) => sum + item.price);

  void add(Product product) {
    if (_selectedIds.add(product.id)) notifyListeners();
  }

  void remove(Product product) {
    if (_selectedIds.remove(product.id)) notifyListeners();
  }

  void toggle(Product product) {
    if (_selectedIds.contains(product.id)) {
      remove(product);
    } else {
      add(product);
    }
  }

  void clearAll() {
    if (_selectedIds.isEmpty) return;
    _selectedIds.clear();
    notifyListeners();
  }
}
