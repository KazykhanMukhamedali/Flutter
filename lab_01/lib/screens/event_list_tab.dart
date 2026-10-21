import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/profile.dart';
import '../routes.dart';
import '../widgets/empty_state.dart';
import '../widgets/event_card.dart';

class EventListTab extends StatefulWidget {
  const EventListTab({
    super.key,
    required this.events,
    required this.profile,
    required this.onUpdate,
    required this.goToProfile,
    required this.onAdd,
  });
  final List<Event> events;
  final Profile profile;
  final void Function(Event) onUpdate;
  final VoidCallback goToProfile;
  final VoidCallback onAdd;

  @override
  State<EventListTab> createState() => _EventListTabState();
}

class _EventListTabState extends State<EventListTab> {
  final _search = TextEditingController();
  EventCategory? _category;
  bool _showPast = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Event> get _filtered {
    final q = _search.text.toLowerCase();
    final list = widget.events.where((e) {
      if (_category != null && e.category != _category) return false;
      if (!_showPast && e.isPast) return false;
      if (q.isNotEmpty && !e.title.toLowerCase().contains(q)) return false;
      return true;
    }).toList();
    list.sort((a, b) {
      if (a.isPast != b.isPast) return a.isPast ? 1 : -1;
      return a.when.compareTo(b.when);
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search events…',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: _search.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _search.clear();
                    setState(() {});
                  },
                )
                    : null,
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _category == null,
                  onSelected: (_) => setState(() => _category = null),
                ),
                ...EventCategory.values.map((c) => Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: ChoiceChip(
                    label: Text(c.label),
                    selected: _category == c,
                    onSelected: (_) => setState(() => _category = c),
                  ),
                )),
                const SizedBox(width: 6),
                FilterChip(
                  label: const Text('Past'),
                  selected: _showPast,
                  onSelected: (v) => setState(() => _showPast = v),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              final items = _filtered;
              if (items.isEmpty) {
                return EmptyState(
                  icon: Icons.event_busy,
                  message: 'No events match',
                  actionLabel: 'Clear filters',
                  onAction: () {
                    _search.clear();
                    setState(() {
                      _category = null;
                      _showPast = false;
                    });
                  },
                );
              }
              if (constraints.maxWidth >= 600) {
                final cols = (constraints.maxWidth / 360).floor().clamp(2, 4);
                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    childAspectRatio: 2.6,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, i) => _buildCard(items[i]),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (context, i) => _buildCard(items[i]),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onAdd,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCard(Event e) => EventCard(
    event: e,
    onTap: () {
      Navigator.pushNamed(
        context,
        Routes.detail,
        arguments: DetailArgs(
          event: e,
          profile: widget.profile,
          onUpdate: widget.onUpdate,
          goToProfile: widget.goToProfile,
        ),
      );
    },
    onFavourite: () =>
        widget.onUpdate(e.copyWith(favourite: !e.favourite)),
  );
}