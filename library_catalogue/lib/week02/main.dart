import 'data.dart';
import 'models.dart';
import 'catalogue.dart';
import 'shelf_state.dart';

void main() {
  // --- Build the library from rawBooks through Book.fromJson ---
  final library = Library();
  for (final raw in rawBooks) {
    library.add(Book.fromJson(raw));
  }
  library.open();

  final books = library.items.whereType<Book>().toList();

  // --- Level 4 queries ---
  print('=== LEVEL 4: Collections ===');
  print('Titles: ${library.allTitles}');
  print('After 2010: ${library.recentBooks.map((b) => b.title).toList()}');
  print('Avg pages: ${library.averagePages.toStringAsFixed(1)}');
  print('By author: ${library.booksByAuthor}');
  print('Authors: ${library.authors}');
  print('Genres: ${library.genres.map((g) => g.label).toList()}');
  print('');
  library.catalogueDisplay.forEach(print);

  // --- Level 5: stats as a record ---
  print('');
  print('=== LEVEL 5: Dart 3 ===');
  final stats = statsOf(books);
  print('statsOf → count: ${stats.count}, avgPages: ${stats.avgPages.toStringAsFixed(1)}');

  // --- Level 5: describe() for all three states ---
  print(describe(const Empty()));
  print(describe(Ready(books.take(3).toList())));
  print(describe(const Broken('connection lost')));
}