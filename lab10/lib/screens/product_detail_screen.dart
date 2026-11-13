import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/theme.dart';
import '../models/product.dart';
import '../widgets/category_badge.dart';
import '../widgets/net_image.dart';
import '../widgets/rating_row.dart';
import '../widgets/share_sheet.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final PageController _pageController = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _addToCart() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Added to cart  ·  ${formatTenge(widget.product.price)}'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final gallery = product.gallery;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NOVASTEEL',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 3,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Share',
            icon: const Icon(Icons.ios_share_rounded),
            onPressed: () => showShareSheet(context, product),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildCarousel(gallery.length),
          const SizedBox(height: 16),
          _buildDots(gallery.length),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: _buildInfo(product),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(product),
    );
  }

  Widget _buildCarousel(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 340,
          color: NovaColors.surface,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: count,
                onPageChanged: (index) => setState(() => _page = index),
                itemBuilder: (context, index) =>
                    _GallerySlide(product: widget.product, index: index),
              ),
              Positioned(
                top: 14,
                right: 14,
                child: _PageCounter(current: _page + 1, total: count),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDots(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final active = index == _page;
        return GestureDetector(
          onTap: () => _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            width: active ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: active ? NovaColors.steel : const Color(0xFFCBD3DA),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildInfo(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CategoryBadge(product.category),
        const SizedBox(height: 14),
        Text(
          product.title,
          style: const TextStyle(
            fontSize: 22,
            height: 1.28,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        RatingRow(
          rating: product.rating,
          reviewCount: product.reviewCount,
          large: true,
        ),
        const SizedBox(height: 20),
        Text(
          formatTenge(product.price),
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: NovaColors.steel,
          ),
        ),
        const SizedBox(height: 24),
        const Divider(color: NovaColors.line, height: 1),
        const SizedBox(height: 24),
        const Text(
          'Description',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Text(
          product.description,
          style: const TextStyle(
            fontSize: 15,
            height: 1.65,
            color: Color(0xFF3B454E),
          ),
        ),
      ],
    );
  }

  /// Sticky bottom bar: stays visible while the content scrolls.
  Widget _buildBottomBar(Product product) {
    return Container(
      decoration: const BoxDecoration(
        color: NovaColors.surface,
        border: Border(top: BorderSide(color: NovaColors.line)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Price',
                    style: TextStyle(fontSize: 12, color: NovaColors.muted),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formatTenge(product.price),
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _addToCart,
                  icon: const Icon(Icons.shopping_bag_outlined, size: 20),
                  label: const Text('Add to Cart'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One page of the carousel. Page 0 carries the Hero image; pages 1 and 2 show
/// zoomed crops, because the API delivers a single image per product.
class _GallerySlide extends StatelessWidget {
  const _GallerySlide({required this.product, required this.index});

  static const List<String> _labels = [
    'Front view',
    'Detail · upper',
    'Detail · lower',
  ];

  final Product product;
  final int index;

  @override
  Widget build(BuildContext context) {
    final image = NetImage(product.gallery[index]);

    final Widget content;
    if (index == 0) {
      content = Padding(
        padding: const EdgeInsets.all(36),
        child: Hero(tag: 'product_image_${product.id}', child: image),
      );
    } else {
      content = ClipRect(
        child: Transform.scale(
          scale: 1.9,
          alignment: index == 1 ? Alignment.topCenter : Alignment.bottomCenter,
          child: Padding(padding: const EdgeInsets.all(36), child: image),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        content,
        Positioned(
          left: 16,
          bottom: 14,
          child: Text(
            _labels[index % _labels.length],
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
              color: NovaColors.muted,
            ),
          ),
        ),
      ],
    );
  }
}

class _PageCounter extends StatelessWidget {
  const _PageCounter({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xCC14181C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$current / $total',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
