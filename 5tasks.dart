void main() {
  for (int i = 1; i <= 10; i++) {
    print('3 * $i = ${3 * i}');
  }

  int day = 28;
  int month = 2;
  int year = 2026;

  bool leap = year % 400 == 0 ||
      (year % 4 == 0 && year % 100 != 0);

  int days = 31;

  if (month == 2) {
    days = leap ? 29 : 28;
  } else if (month == 4 ||
      month == 6 ||
      month == 9 ||
      month == 11) {
    days = 30;
  }

  if (month < 1 || month > 12 || day < 1 || day > days) {
    print('invalid date');
  } else {
    day++;

    if (day > days) {
      day = 1;
      month++;

      if (month > 12) {
        month = 1;
        year++;
      }
    }

    print('$day.$month.$year');
  }

  String text = 'flutter mobile development';
  int vowels = 0;

  for (int i = 0; i < text.length; i++) {
    if ('aeiou'.contains(text[i].toLowerCase())) {
      vowels++;
    }
  }

  print(vowels);

  List<int> numbers = [14, 88, 3, 42, 99, 12, 67];

  int min = numbers[0];
  int max = numbers[0];

  for (int i = 1; i < numbers.length; i++) {
    if (numbers[i] < min) {
      min = numbers[i];
    }

    if (numbers[i] > max) {
      max = numbers[i];
    }
  }

  print('min: $min');
  print('max: $max');

  int number = 3;
  bool prime = true;

  if (number < 2) {
    prime = false;
  }

  for (int i = 2; i < number; i++) {
    if (number % i == 0) {
      prime = false;
    }
  }

  if (prime) {
    print('prime number');
  } else {
    print('not prime number');
  }
}