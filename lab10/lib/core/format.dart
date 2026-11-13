/// Exchange rate used to show the API's USD prices in tenge (₸).
/// Change this single constant to re-price the whole catalogue.
const double kUsdToKzt = 520;

/// Formats a USD price from the API as tenge, e.g. `57 170 ₸`.
/// The result is rounded to the nearest 10 ₸ and uses non-breaking spaces
/// as thousands separators.
String formatTenge(double usd) {
  final value = ((usd * kUsdToKzt) / 10).round() * 10;
  final digits = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final remaining = digits.length - i;
    buffer.write(digits[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(' ');
  }
  return '${buffer.toString()} ₸';
}

/// "men's clothing" -> "Men's Clothing"
String titleCase(String input) {
  return input
      .split(' ')
      .where((word) => word.isNotEmpty)
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');
}
