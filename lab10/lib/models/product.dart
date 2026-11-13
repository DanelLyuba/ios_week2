/// Domain model for one item returned by https://fakestoreapi.com/products
class Product {
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
  });

  final int id;
  final String title;

  /// Price in USD as delivered by the API (converted to tenge in the UI).
  final double price;
  final String description;
  final String category;
  final String imageUrl;
  final double rating;
  final int reviewCount;

  /// The API provides a single image per product, so the gallery shows three
  /// views of it. When a backend returns several URLs, replace this getter
  /// with a real list and the carousel works unchanged.
  List<String> get gallery => List<String>.unmodifiable([imageUrl, imageUrl, imageUrl]);

  /// Deep link shown in the share sheet.
  String get deepLink => 'narxoz://store/product/$id';

  /// Builds a [Product] from decoded JSON.
  ///
  /// * Missing / null fields fall back to safe defaults (null-safety).
  /// * JSON numbers may arrive as `int` (e.g. `100`) or `double` (`109.95`).
  ///   A direct `as double` cast would throw a TypeError for the `int` case, so
  ///   every numeric field goes through `num` first, which is exactly
  ///   `(json['price'] as num).toDouble()` plus a null guard.
  factory Product.fromJson(Map<String, dynamic> json) {
    final rawRating = json['rating'];
    final Map<String, dynamic> rating =
        rawRating is Map<String, dynamic> ? rawRating : const <String, dynamic>{};

    return Product(
      id: _toInt(json['id']),
      title: _toText(json['title'], 'Untitled product'),
      price: _toDouble(json['price']),
      description: _toText(json['description'], 'No description available.'),
      category: _toText(json['category'], 'general'),
      imageUrl: _toText(json['image'], ''),
      rating: _toDouble(rating['rate']),
      reviewCount: _toInt(rating['count']),
    );
  }
}

double _toDouble(Object? value) {
  if (value is num) return value.toDouble(); // int and double both land here
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

int _toInt(Object? value) {
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

String _toText(Object? value, String fallback) {
  if (value is String && value.trim().isNotEmpty) return value.trim();
  return fallback;
}
