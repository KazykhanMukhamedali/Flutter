import 'package:flutter/material.dart';

/// A counter that goes both up and down, plus a Save button.
class TwoWayCounter extends StatefulWidget {
  const TwoWayCounter({super.key});

  @override
  State<TwoWayCounter> createState() => _TwoWayCounterState();
}

class _TwoWayCounterState extends State<TwoWayCounter> {
  int _count = 0;
  bool _saving = false;

  void _increment() => setState(() => _count++);
  void _decrement() => setState(() => _count--);

  Future<void> _save() async {
    setState(() => _saving = true);

    await Future.delayed(const Duration(seconds: 2));

    // The widget may have been removed while we were waiting.
    if (!mounted) return;

    setState(() => _saving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved value: $_count'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      color: colors.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.exposure_plus_1, color: colors.onPrimaryContainer),
                const SizedBox(width: 8),
                Text(
                  'Two-way counter',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton.filledTonal(
                  // A null handler disables and greys the button.
                  onPressed: _count == 0 ? null : _decrement,
                  icon: const Icon(Icons.remove),
                ),
                Text(
                  '$_count',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                IconButton.filled(
                  onPressed: _increment,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_saving ? 'Saving…' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}
