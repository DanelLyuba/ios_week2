import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import '../widgets/product_tile.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key, this.initialProducts});

  /// Optional seed override for isolated widget tests.
  final List<Product>? initialProducts;

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late List<Product> _products;
  bool _gridMode = false;
  bool _refreshing = false;
  int _nextId = 13;

  @override
  void initState() {
    super.initState();
    _products = List<Product>.of(widget.initialProducts ?? ProductSeed.initial());
    for (final product in _products) {
      if (product.id >= _nextId) _nextId = product.id + 1;
    }
  }

  /// Used by RefreshIndicator (and the optional toolbar refresh button).
  Future<void> _refresh() async {
    if (_refreshing) return;
    setState(() => _refreshing = true);
    try {
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!mounted) return;
      final id = _nextId++;
      setState(() {
        _products.insert(
          0,
          Product(
            id: id,
            title: 'New Arrival #$id',
            category: 'Just Added',
            price: 7990 + id * 350.0,
            rating: 4.9,
            icon: Icons.auto_awesome,
            color: const Color(0xFF346F9E),
          ),
        );
      });
      // The first item appears immediately after the refresh completes.
      // No snackbar here: a later delete snackbar should stay visible.
    } finally {
      if (mounted) setState(() => _refreshing = false);
    }
  }

  void _deleteProduct(Product product) {
    final originalIndex = _products.indexWhere((p) => p.id == product.id);
    if (originalIndex < 0) return;

    setState(() => _products.removeAt(originalIndex));

    final messenger = ScaffoldMessenger.of(context);
    messenger.removeCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        key: const Key('undoSnackbar'),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        duration: const Duration(seconds: 8),
        showCloseIcon: true,
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.delete_outline, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${product.title} deleted',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            if (!mounted || _products.any((p) => p.id == product.id)) return;
            setState(() {
              _products.insert(
                originalIndex.clamp(0, _products.length).toInt(),
                product,
              );
            });
          },
        ),
      ),
    );
  }

  void _reset() {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    setState(() {
      _products = List<Product>.of(ProductSeed.initial());
      _nextId = 13;
    });
  }

  Widget _deleteBackground() => Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE53C52),
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 22),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete, size: 26, color: Colors.white),
            SizedBox(width: 8),
            Text('DELETE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      );

  Widget _dismissible(Product product, {required bool grid}) => Dismissible(
        key: ValueKey(product.id),
        direction: DismissDirection.endToStart,
        background: _deleteBackground(),
        onDismissed: (_) => _deleteProduct(product),
        child: grid ? ProductCard(product: product) : ProductTile(product: product),
      );

  Widget _emptyState() => LayoutBuilder(
        builder: (context, constraints) => ListView(
          key: const Key('emptyScrollable'),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: constraints.maxHeight > 300 ? constraints.maxHeight - 1 : 300,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE7EBFA),
                        ),
                        child: const Icon(Icons.inventory_2_outlined,
                            size: 55, color: Color(0xFF4962BD)),
                      ),
                      const SizedBox(height: 20),
                      Text('Catalog is Empty',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              )),
                      const SizedBox(height: 10),
                      const Text(
                        'All products have been removed.\nRestore the catalog or pull down to add a new item.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 22),
                      FilledButton.icon(
                        key: const Key('resetCatalog'),
                        onPressed: _reset,
                        icon: const Icon(Icons.restart_alt),
                        label: const Text('Reset Catalog'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final count = _products.length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Catalog',
            style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            key: const Key('refreshButton'),
            tooltip: 'Refresh catalog',
            onPressed: _refreshing ? null : _refresh,
            icon: _refreshing
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                : const Icon(Icons.refresh_rounded),
          ),
          IconButton(
            key: const Key('viewToggle'),
            tooltip: _gridMode ? 'Switch to list view' : 'Switch to grid view',
            onPressed: () => setState(() => _gridMode = !_gridMode),
            icon: Icon(_gridMode ? Icons.view_list_rounded : Icons.grid_view_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Discover products',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                )),
                        const SizedBox(height: 4),
                        Text('$count products · Pull down to refresh',
                            key: const Key('productCount'),
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5EBFD),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_gridMode ? Icons.grid_view_rounded : Icons.view_list_rounded,
                            size: 17, color: const Color(0xFF3857C8)),
                        const SizedBox(width: 5),
                        Text(_gridMode ? 'Grid view' : 'List view',
                            style: const TextStyle(color: Color(0xFF3857C8),
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 0, 18, 10),
              child: Row(
                children: [
                  Icon(Icons.swipe_left_outlined, color: Color(0xFF65718B), size: 18),
                  SizedBox(width: 7),
                  Expanded(
                    child: Text('Swipe a product left to delete · Tap UNDO to restore',
                        style: TextStyle(fontSize: 12, color: Color(0xFF65718B))),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                key: const Key('catalogRefreshIndicator'),
                displacement: 32,
                color: const Color(0xFF3857C8),
                onRefresh: _refresh,
                child: count == 0
                    ? _emptyState()
                    : _gridMode
                        ? GridView.builder(
                            key: const PageStorageKey('catalogGrid'),
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(12, 5, 12, 30),
                            itemCount: count,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.72,
                            ),
                            itemBuilder: (context, index) =>
                                _dismissible(_products[index], grid: true),
                          )
                        : ListView.separated(
                            key: const PageStorageKey('catalogList'),
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 30),
                            itemCount: count,
                            separatorBuilder: (_, __) => const Divider(
                              height: 1,
                              thickness: 0.7,
                              indent: 89,
                              endIndent: 18,
                            ),
                            itemBuilder: (context, index) =>
                                _dismissible(_products[index], grid: false),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
