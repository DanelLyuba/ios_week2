void main() {
  printMultiplicationTables();

  getNextDay(5, 9, 2026);
  getNextDay(28, 2, 2024);
  getNextDay(28, 2, 2026);
  getNextDay(29, 2, 2026);
  getNextDay(28, 2, 2100);
  getNextDay(31, 12, 2025);

  countVowels('flutter mobile development');

  findMinMax([14, 88, 3, 42, 99, 12, 67]);
  findMinMax([234, 34, 123, 44, 949, 112, 67]);

  checkPrime(3);
  checkPrime(6);
}

void printMultiplicationTables() {
  for (int digit = 1; digit <= 10; digit++) {
    print("MULTIPLICATION TABLE for digit $digit");
    for (int i = 1; i <= 10; i++) {
      print("$digit * $i = ${digit * i}");
    }
  }
}

void getNextDay(int day, int month, int year) {
  bool isLeap = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);

  int maxDays = 31;
  if (month == 4 || month == 6 || month == 9 || month == 11) {
    maxDays = 30;
  } else if (month == 2) {
    maxDays = isLeap ? 29 : 28;
  }

  if (day < 1 || day > maxDays || month < 1 || month > 12) {
    print("$day.$month.$year -> invalid date");
    return;
  }

  String originalDate = "$day.$month.$year";

  day++;
  if (day > maxDays) {
    day = 1;
    month++;
    if (month > 12) {
      month = 1;
      year++;
    }
  }

  print("$originalDate -> $day.$month.$year");
}

void countVowels(String text) {
  int count = 0;
  String vowels = 'aeiouAEIOU';

  for (int i = 0; i < text.length; i++) {
    if (vowels.contains(text[i])) {
      count++;
    }
  }

  print('"$text" -> $count');
}

void findMinMax(List<int> numbers) {
  int min = numbers[0];
  int max = numbers[0];

  for (int i = 1; i < numbers.length; i++) {
    if (numbers[i] < min) min = numbers[i];
    if (numbers[i] > max) max = numbers[i];
  }

  print("max: $max, min: $min");
}

void checkPrime(int number) {
  if (number <= 1) {
    print("$number -> not prime number");
    return;
  }

  bool isPrime = true;
  for (int i = 2; i < number; i++) {
    if (number % i == 0) {
      isPrime = false;
      break;
    }
  }

  if (isPrime) {
    print("$number -> prime number");
  } else {
    print("$number -> not prime number");
  }
}
