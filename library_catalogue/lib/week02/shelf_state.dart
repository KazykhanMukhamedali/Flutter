import 'models.dart';

/// The state of the shelf. `sealed` means the compiler knows every
/// possible subtype — so a switch expression can be exhaustive
/// without a `default` branch.
sealed class ShelfState {
  const ShelfState();
}

/// The shelf is empty.
class Empty extends ShelfState {
  const Empty();
}

/// The shelf has books.
class Ready extends ShelfState {
  final List<Book> books;
  const Ready(this.books);
}

/// Something went wrong — carries a message.
class Broken extends ShelfState {
  final String message;
  const Broken(this.message);
}



/// Describes the state. A switch expression with NO default —
/// the compiler will complain if we miss a subtype. That's the point.
String describe(ShelfState state) => switch (state) {
      Empty() => 'Shelf is empty.',
      Ready(:final books) =>
        'Shelf has ${books.length} book(s): '
            '${books.map((b) => b.title).join(', ')}',
      Broken(:final message) => 'Shelf is broken: $message',
    };

/// Returns both numbers as a record — not a class, not a List.
({int count, double avgPages}) statsOf(List<Book> books) {
  if (books.isEmpty) return (count: 0, avgPages: 0);
  final total = books.fold<int>(0, (sum, b) => sum + b.pages);
  return (count: books.length, avgPages: total / books.length);
}