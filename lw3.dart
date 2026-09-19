class Book {
  String title;
  String author;
  double price;
  bool isBorrowed;

  Book(
    this.title,
    this.author,
    this.price, {
    this.isBorrowed = false,
  });
}

class Library {
  List<Book> _books = [];

  void addBook(Book book) {
    _books.add(book);
  }

  List<Book> getAvailableBooks() {
    return _books.where((book) => book.isBorrowed == false).toList();
  }

  double getTotalValue() {
    return _books.fold(0, (sum, book) => sum + book.price);
  }
}

void main() {
  Library library = Library();

  library.addBook(
    Book('Harry Potter', 'J.K. Rowling', 20.0),
  );

  library.addBook(
    Book('1984', 'George Orwell', 15.0, isBorrowed: true),
  );

  library.addBook(
    Book('The Hobbit', 'J.R.R. Tolkien', 18.0),
  );

  library.addBook(
    Book('The Great Gatsby', 'F. Scott Fitzgerald', 12.0),
  );

  print('Available books:');

  for (var book in library.getAvailableBooks()) {
    print('${book.title} - ${book.author} - \$${book.price}');
  }

  print('Total collection value: \$${library.getTotalValue()}');
}