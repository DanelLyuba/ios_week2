import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:novasteel_explorer/services/product_service.dart';

ProductService _serviceReturning(int status, [String body = '[]']) {
  return ProductService(
    client: MockClient((request) async => http.Response(body, status)),
  );
}

Matcher _apiError({int? status}) => throwsA(
      isA<ApiException>().having((e) => e.statusCode, 'statusCode', status),
    );

void main() {
  test('200 returns parsed products', () async {
    const body = '['
        '{"id":1,"title":"A","price":10,"description":"d","category":"c",'
        '"image":"u","rating":{"rate":4.5,"count":3}},'
        '{"id":2,"title":"B","price":20.5,"description":"d","category":"c",'
        '"image":"u","rating":{"rate":3,"count":1}}'
        ']';

    final products = await _serviceReturning(200, body).fetchProducts();

    expect(products, hasLength(2));
    expect(products.first.title, 'A');
    expect(products.last.price, 20.5);
  });

  test('404 throws ApiException(404)', () {
    expect(_serviceReturning(404).fetchProducts(), _apiError(status: 404));
  });

  test('500 throws ApiException(500)', () {
    expect(_serviceReturning(500).fetchProducts(), _apiError(status: 500));
  });

  test('timeout becomes a friendly ApiException', () {
    final service = ProductService(
      client: MockClient((request) async => throw TimeoutException('slow')),
    );

    expect(
      service.fetchProducts(),
      throwsA(
        isA<ApiException>().having((e) => e.message, 'message', contains('10 seconds')),
      ),
    );
  });

  test('offline becomes a friendly ApiException', () {
    final service = ProductService(
      client: MockClient(
        (request) async => throw Exception('Failed host lookup'),
      ),
    );

    expect(
      service.fetchProducts(),
      throwsA(
        isA<ApiException>().having((e) => e.message, 'message', contains('internet')),
      ),
    );
  });

  test('malformed JSON becomes an ApiException', () {
    expect(_serviceReturning(200, '{not json').fetchProducts(), _apiError());
  });
}
