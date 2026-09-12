void main() {
  // Test your function here
  processOrder(
    orderId: 'ORD-101',
    itemPrice: 1000.0,
    promoCode: 'SAVE10',
  );
}

double processOrder({
  required String orderId,
  required double itemPrice,
  String? promoCode,
  double? deliveryFee,
}) {
  if (promoCode == 'SAVE10') {
    itemPrice = itemPrice * 0.9;
  }

  double fee = deliveryFee ?? 500.0;
  double total = itemPrice + fee;

  print('Order: $orderId, Total: $total');
  return total;
}

