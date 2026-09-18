// ============================================================
// LEVEL 1: Classes and Constructors
// ============================================================

/// Author of a book. Country is optional — some authors are unknown.
class Author {
  final String name;
  final String? country;

  const Author({required this.name, this.country});

  @override
  String toString() => 'Author($name${country == null ? '' : ', $country'})';
}

/// Genre with a human-readable label. `unknown` is the fallback.
enum Genre {
  craft('Craft'),
  theory('Theory'),
  unknown('Unknown');

  final String label;
  const Genre(this.label);

  /// Parses a raw string into a Genre. Never throws — returns
  /// [Genre.unknown] for null or anything unrecognised.
  static Genre fromString(String? raw) {
    switch (raw) {
      case 'craft':
        return Genre.craft;
      case 'theory':
        return Genre.theory;
      default:
        return Genre.unknown;
    }
  }
}

/// A book in the catalogue. This is the main model.
class Book extends LibraryItem with Borrowable {
  final int pages;
  final Author author;
  final Genre genre;
  final String? description;

  const Book({
    required super.title,
    required super.year,
    required this.pages,
    required this.author,
    required this.genre,
    this.description,
  });

  /// Builds a Book from a raw JSON-like map. Tolerates missing keys —
  /// this is the ONLY place `dynamic` is allowed.
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: (json['title'] as String?) ?? 'Untitled',
      year: (json['year'] as int?) ?? 0,
      pages: (json['pages'] as int?) ?? 0,
      author: Author(
        name: (json['author'] as String?) ?? 'Unknown',
        country: json['country'] as String?,
      ),
      genre: Genre.fromString(json['genre'] as String?),
      description: json['description'] as String?,
    );
  }

  /// A book is "long" when it has more than 400 pages.
  bool get isLong => pages > 400;

  /// Returns a copy with some fields replaced.
  Book copyWith({
    String? title,
    int? year,
    int? pages,
    Author? author,
    Genre? genre,
    String? description,
  }) {
    return Book(
      title: title ?? this.title,
      year: year ?? this.year,
      pages: pages ?? this.pages,
      author: author ?? this.author,
      genre: genre ?? this.genre,
      description: description ?? this.description,
    );
  }

  @override
  String describe() => '$title by ${author.name} ($year, $pages pp)';

  @override
  String toString() => 'Book($title, $year)';
}

// ============================================================
// LEVEL 2: Hierarchy
// ============================================================

/// Anything that can be stored in the library. Abstract — you never
/// create a bare LibraryItem.
abstract class LibraryItem {
  final String title;
  final int year;

  const LibraryItem({required this.title, required this.year});

  /// Subclasses decide how to describe themselves.
  String describe();

  /// Anything older than 20 years counts as old. Concrete getter,
  /// shared by all subclasses.
  bool get isOld => DateTime.now().year - year > 20;
}

/// A magazine. Same idea as Book, but with an issue number.
class Magazine extends LibraryItem {
  final int issue;

  const Magazine({
    required super.title,
    required super.year,
    required this.issue,
  });

  @override
  String describe() => '$title #$issue ($year)';
}

/// Mixin: "this can also be borrowed". Working code, no second parent.
mixin Borrowable on LibraryItem {
  String borrowLabel() => 'Borrow "$title"';
}

/// A ghost item — nothing inherited, every member written by hand.
/// Demonstrates `implements`: it's a contract, not a parent.
class Ghost implements LibraryItem {
  @override
  final String title;

  @override
  final int year;

  const Ghost({required this.title, required this.year});

  @override
  String describe() => '👻 $title ($year)';

  @override
  bool get isOld => true;
}