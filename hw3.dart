abstract class MediaItem {
  String id;
  String title;
  double price;

  MediaItem(this.id, this.title, this.price);

  String getDetails();
}

mixin Downloadable {
  void download(String title) {
    print('Downloading: $title');
  }
}

class Audiobook extends MediaItem with Downloadable {
  double durationHours;
  String narrator;

  Audiobook(
    String id,
    String title,
    double price,
    this.durationHours,
    this.narrator,
  ) : super(id, title, price);

  @override
  String getDetails() {
    return '$title - Audiobook, $durationHours hours, narrated by $narrator';
  }
}

class EBook extends MediaItem with Downloadable {
  double fileSizeMB;
  String author;

  EBook(
    String id,
    String title,
    double price,
    this.fileSizeMB,
    this.author,
  ) : super(id, title, price);

  @override
  String getDetails() {
    return '$title - EBook, $fileSizeMB MB, by $author';
  }
}

class ShoppingCart {
  List<MediaItem> _items = [];

  void addItem(MediaItem item) {
    _items.add(item);
  }

  double calculateTotalWithTax({double taxRate = 0.12}) {
    double total = _items.fold(0, (sum, item) => sum + item.price);
    return total + total * taxRate;
  }

  List<MediaItem> filterByMaxPrice(double maxPrice) {
    return _items.where((item) => item.price <= maxPrice).toList();
  }

  void printReceipt() {
    print('Receipt:');

    for (var item in _items) {
      print(item.getDetails());

      if (item is Audiobook) {
        item.download(item.title);
      }

      if (item is EBook) {
        item.download(item.title);
      }
    }

    print('Total with tax: ${calculateTotalWithTax()}');
  }
}

void main() {
  ShoppingCart cart = ShoppingCart();

  Audiobook audiobook = Audiobook(
    'A1',
    'Harry Potter',
    15.0,
    8.5,
    'Stephen Fry',
  );

  EBook ebook = EBook(
    'E1',
    '1984',
    10.0,
    2.5,
    'George Orwell',
  );

  cart.addItem(audiobook);
  cart.addItem(ebook);

  cart.printReceipt();

  print('Books under \$12:');

  for (var item in cart.filterByMaxPrice(12)) {
    print(item.getDetails());
  }
}
