import 'package:flutter/material.dart';

enum EventCategory {
  starters(label: 'Starters', icon: Icons.local_dining),
  mains(label: 'Mains', icon: Icons.restaurant),
  desserts(label: 'Desserts', icon: Icons.cake),
  drinks(label: 'Drinks', icon: Icons.local_bar),
  catering(label: 'Catering', icon: Icons.room_service);

  const EventCategory({required this.label, required this.icon});
  final String label;
  final IconData icon;

  Color color(ColorScheme scheme) => switch (this) {
    EventCategory.starters => scheme.primary,
    EventCategory.mains => scheme.secondary,
    EventCategory.desserts => scheme.tertiary,
    EventCategory.drinks => scheme.error,
    EventCategory.catering => scheme.primaryContainer,
  };
}

class Event {
  const Event({
    required this.id,
    required this.title,
    required this.category,
    required this.when,
    required this.limit,
    required this.names,
    required this.mode,
    this.optionalText,
    this.favourite = false,
  });

  final String id;
  final String title;
  final EventCategory category;
  final DateTime when;
  final int limit;
  final List<String> names;
  final bool mode;
  final String? optionalText;
  final bool favourite;

  Event.empty()
      : id = '',
        title = '',
        category = EventCategory.starters,
        when = DateTime.now().add(const Duration(days: 1)),
        limit = 10,
        names = const [],
        mode = false,
        optionalText = null,
        favourite = false;

  int get count => names.length;
  int get freePlaces => limit - count;
  bool get isFull => count >= limit;
  bool get isPast => when.isBefore(DateTime.now());
  bool contains(String name) => names.contains(name);

  ({int taken, int free}) get places => (taken: count, free: freePlaces);

  Event copyWith({
    String? title,
    EventCategory? category,
    DateTime? when,
    int? limit,
    List<String>? names,
    bool? mode,
    String? optionalText,
    bool? favourite,
  }) {
    return Event(
      id: id,
      title: title ?? this.title,
      category: category ?? this.category,
      when: when ?? this.when,
      limit: limit ?? this.limit,
      names: names != null ? List.unmodifiable(names) : this.names,
      mode: mode ?? this.mode,
      optionalText: optionalText ?? this.optionalText,
      favourite: favourite ?? this.favourite,
    );
  }
}

sealed class Countdown {
  const Countdown();
}

class Upcoming extends Countdown {
  const Upcoming(this.duration);
  final Duration duration;
}

class Started extends Countdown {
  const Started(this.duration);
  final Duration duration;
}

class Ended extends Countdown {
  const Ended();
}

Countdown countdownFrom(DateTime when) {
  final now = DateTime.now();
  final diff = when.difference(now);
  if (diff.isNegative) {
    final past = now.difference(when);
    if (past.inHours < 1) return Started(past);
    return const Ended();
  }
  return Upcoming(diff);
}