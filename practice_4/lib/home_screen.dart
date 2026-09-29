import 'package:flutter/material.dart';

import 'stopwatch_card.dart';
import 'tap_card.dart';
import 'two_way_counter.dart';

/// The screen that holds the three reactive widgets.
///
/// It stays a [StatelessWidget] on purpose: every changing value lives
/// in the [State] object of the widget that displays it.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('A screen that reacts'),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TwoWayCounter(),
              SizedBox(height: 16),
              StopwatchCard(),
              SizedBox(height: 24),
              TapCard(),
            ],
          ),
        ),
      ),
    );
  }
}
