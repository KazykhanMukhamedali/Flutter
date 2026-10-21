import 'package:flutter/material.dart';
import '../models/book.dart';

enum BookAction { toggleRead, delete }

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(book.title, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Author: ${book.author}'),
            Text('Pages: ${book.pages}'),
            Text('Year: ${book.year ?? 'Year unknown'}'),
            Text('Status: ${book.read ? 'read' : 'unread'}'),
            const Spacer(),
            FilledButton(
              onPressed: () =>
                  Navigator.of(context).pop(BookAction.toggleRead),
              child: Text(book.read ? 'Mark as unread' : 'Mark as read'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text("Delete '${book.title}'?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (!context.mounted) return;
                if (ok == true) {
                  Navigator.of(context).pop(BookAction.delete);
                }
              },
              style: OutlinedButton.styleFrom(foregroundColor: scheme.error),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}