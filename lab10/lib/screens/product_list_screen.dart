import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/theme.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/error_view.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

/// The three production UI states of the feed.
enum LoadState { loading, success, error }

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key, this.service});

  /// Injectable for tests; defaults to the live API.
  final ProductService? service;

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late final ProductService _service = widget.service ?? ProductService();

  LoadState _state = LoadState.loading;
  List<Product> _products = const [];
  String _errorMessage = '';
  String _category = 'all';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    if (widget.service == null) _service.close();
    super.dispose();
  }

  /// Initial load and "Retry Connection": shows the spinner first.
  Future<void> _load() async {
    setState(() => _state = LoadState.loading);
    try {
      final items = await _service.fetchProducts();
      if (!mounted) return;
      setState(() {
        _products = items;
        _category = 'all';
        _state = LoadState.success;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
        _state = LoadState.error;
      });
    }
  }

  /// Pull-to-refresh: keeps the current feed visible; a failure only shows a
  /// snackbar so the user never loses what is already on screen.
  Future<void> _refresh() async {
    try {
      final items = await _service.fetchProducts();
      if (!mounted) return;
      setState(() {
        _products = items;
        _state = LoadState.success;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Refresh failed. ${e.message}')));
    }
  }

  void _openDetail(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: NovaColors.steel,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'N',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'NOVASTEEL',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case LoadState.loading:
        return const Center(child: CircularProgressIndicator());
      case LoadState.error:
        return ErrorView(message: _errorMessage, onRetry: _load);
      case LoadState.success:
        return _buildFeed();
    }
  }

  Widget _buildFeed() {
    final visible = _category == 'all'
        ? _products
        : _products.where((p) => p.category == _category).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Product catalogue',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${_products.length} items  ·  prices in tenge (₸)',
                style: const TextStyle(fontSize: 13.5, color: NovaColors.muted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _buildCategoryBar(),
        const SizedBox(height: 6),
        Expanded(
          child: RefreshIndicator(
            color: NovaColors.steel,
            onRefresh: _refresh,
            child: visible.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 120),
                      Center(
                        child: Text(
                          'No products found',
                          style: TextStyle(color: NovaColors.muted),
                        ),
                      ),
                    ],
                  )
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    itemCount: visible.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final product = visible[index];
                      return ProductCard(
                        product: product,
                        onTap: () => _openDetail(product),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryBar() {
    final unique = _products.map((p) => p.category).toSet().toList()..sort();
    final categories = ['all', ...unique];

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = category == _category;
          return ChoiceChip(
            label: Text(category == 'all' ? 'All' : titleCase(category)),
            selected: selected,
            showCheckmark: false,
            onSelected: (_) => setState(() => _category = category),
            selectedColor: NovaColors.steel,
            backgroundColor: NovaColors.surface,
            shape: const StadiumBorder(),
            side: BorderSide(
              color: selected ? NovaColors.steel : NovaColors.line,
            ),
            labelStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : NovaColors.ink,
            ),
          );
        },
      ),
    );
  }
}
