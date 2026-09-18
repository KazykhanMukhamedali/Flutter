import 'models.dart';

/// A small library. Holds items, can look things up.
/// Level 3 (null safety) — no `!`, no `dynamic` outside fromJson.
class Library {
  final List<LibraryItem> items = [];

  /// Assigned by [open], not in the constructor. That's `late final`.
  late final DateTime openedAt;

  /// Cached report, filled in by `??=` the first time [report] runs.
  String? _cachedReport;

  void add(LibraryItem item) {
    items.add(item);
  }

  /// Opens the library. `late final` gets its value here.
  void open() {
    openedAt = DateTime.now();
  }

  /// Finds a book by title. Returns null when there is none.
  /// No `!`, no throw — just a nullable result.
  Book? findByTitle(String title) {
    for (final item in items) {
      if (item is Book && item.title == title) {
        return item;
      }
    }
    return null;
  }

  /// Author's country for the given title, or 'unknown'.
  /// One expression: `?.` then `??`.
  String countryOf(String title) {
    return findByTitle(title)?.author.country ?? 'unknown';
  }

  /// Builds the report once and caches it via `??=`.
  String report() {
    return _cachedReport ??= _buildReport();
  }

  String _buildReport() {
    final buffer = StringBuffer()
      ..writeln('Library report')
      ..writeln('Items: ${items.length}');
    return buffer.toString();
  }


    // ============================================================
  // LEVEL 4: Collections — every query is ONE expression, no for-loops
  // ============================================================

  /// All book titles in the library.
  List<String> get allTitles =>
      items.whereType<Book>().map((b) => b.title).toList();

  /// Books published after 2010.
  List<Book> get recentBooks =>
      items.whereType<Book>().where((b) => b.year > 2010).toList();

  /// Average page count across all books.
  ///
  /// `fold` is used instead of `reduce` because `reduce` throws on an
  /// empty list — `fold` takes an explicit initial value (0) and always
  /// returns something, even for an empty library.
  double get averagePages {
    final books = items.whereType<Book>().toList();
    if (books.isEmpty) return 0;
    final total = books.fold<int>(0, (sum, b) => sum + b.pages);
    return total / books.length;
  }

  /// Map from author name to how many books they wrote.
  Map<String, int> get booksByAuthor => items
      .whereType<Book>()
      .fold<Map<String, int>>({}, (map, b) {
        map.update(b.author.name, (v) => v + 1, ifAbsent: () => 1);
        return map;
      });

  /// Distinct author names.
  Set<String> get authors =>
      items.whereType<Book>().map((b) => b.author.name).toSet();

  /// Every genre present in the library.
  Set<Genre> get genres =>
      items.whereType<Book>().map((b) => b.genre).toSet();

  /// A single display list, built as one literal.
  List<String> get catalogueDisplay => [
        'CATALOGUE',
        for (final b in items.whereType<Book>())
          '${b.title} (${b.year})',
        ...authors.map((name) => '  • $name'),
        if (items.whereType<Book>().any((b) => b.pages == 0))
          '(incomplete data)',
      ];
}
