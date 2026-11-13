import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

/// Every failure of the data layer is reported as an [ApiException] carrying a
/// message that is safe to show to the user.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ProductService {
  ProductService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static final Uri endpoint = Uri.parse('https://fakestoreapi.com/products');
  static const Duration timeout = Duration(seconds: 10);

  /// GET /products with a 10 second timeout.
  ///
  /// 200 -> parsed list, 404 / 5xx / other -> [ApiException],
  /// timeout or no network -> [ApiException].
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _client.get(endpoint).timeout(timeout);
      return _handle(response);
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException(
        'The server took longer than 10 seconds to respond. '
        'Check your connection and try again.',
      );
    } on FormatException {
      throw const ApiException('The server sent data in an unexpected format.');
    } catch (_) {
      throw const ApiException(
        'No internet connection. Please check your network and try again.',
      );
    }
  }

  List<Product> _handle(http.Response response) {
    final code = response.statusCode;

    if (code == 200) {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! List) {
        throw const ApiException(
          'Unexpected response from the server.',
          statusCode: 200,
        );
      }
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(Product.fromJson)
          .toList();
    }
    if (code == 404) {
      throw const ApiException(
        'Catalogue not found (404). The endpoint may have moved.',
        statusCode: 404,
      );
    }
    if (code >= 500) {
      throw ApiException(
        'Server error ($code). Please try again in a moment.',
        statusCode: code,
      );
    }
    throw ApiException('Unexpected response ($code).', statusCode: code);
  }

  void close() => _client.close();
}
