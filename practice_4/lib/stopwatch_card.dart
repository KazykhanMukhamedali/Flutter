import 'dart:async';

import 'package:flutter/material.dart';

/// A stopwatch that counts seconds while running.
///
/// The timer is created in [_start] and cancelled in [_stop] and
/// [dispose]; forgetting to cancel it is the classic
/// "setState() called after dispose()" bug.
class StopwatchCard extends StatefulWidget {
  const StopwatchCard({super.key});

  @override
  State<StopwatchCard> createState() => _StopwatchCardState();
}

class _StopwatchCardState extends State<StopwatchCard> {
  int _seconds = 0;
  Timer? _timer;

  bool get _isRunning => _timer != null;

  /// Computed from [_seconds]; not stored as a separate field.
  String get _formattedTime {
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (_seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  void _start() {
    // Guard: do not create a second timer if one is already running.
    if (_timer != null) return;
    setState(() {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() => _seconds++);
      });
    });
  }

  void _stop() {
    _timer?.cancel();
    setState(() => _timer = null);
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _timer = null;
      _seconds = 0;
    });
  }

  @override
  void dispose() {
    // Cancel the timer, then call super.dispose() last.
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green.withValues(alpha: 0.15),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.timer, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Stopwatch',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _formattedTime,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: _isRunning ? null : _start,
                    child: const Text('Start'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isRunning ? _stop : null,
                    child: const Text('Stop'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: (_seconds == 0 && !_isRunning) ? null : _reset,
                    child: const Text('Reset'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
