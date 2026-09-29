import 'package:flutter/material.dart';

/// A big circular button that counts taps.
///
/// The number of taps appears in a pill above the circle; a long-press
/// asks to reset the count.
class TapCard extends StatefulWidget {
  const TapCard({super.key});

  @override
  State<TapCard> createState() => _TapCardState();
}

class _TapCardState extends State<TapCard> {
  int _taps = 0;

  void _increment() => setState(() => _taps++);

  Future<void> _confirmReset() async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset the count?'),
        content: Text('This will set the count from $_taps back to 0.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (shouldReset == true) {
      setState(() => _taps = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Number in a pill above the circle.
        Chip(
          label: Text(
            '$_taps',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: colors.primaryContainer,
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _increment,
          onLongPress: _confirmReset,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.primary,
            ),
            child: Icon(Icons.touch_app, size: 72, color: colors.onPrimary),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Tap to count · Long-press to reset',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
