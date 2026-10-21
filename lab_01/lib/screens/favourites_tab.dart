import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/profile.dart';
import '../routes.dart';
import '../widgets/empty_state.dart';
import '../widgets/event_card.dart';

class FavouritesTab extends StatelessWidget {
  const FavouritesTab({
    super.key,
    required this.events,
    required this.profile,
    required this.onUpdate,
    required this.goToProfile,
  });
  final List<Event> events;
  final Profile profile;
  final void Function(Event) onUpdate;
  final VoidCallback goToProfile;

  @override
  Widget build(BuildContext context) {
    final favs = events.where((e) => e.favourite).toList();
    if (favs.isEmpty) {
      return const EmptyState(
        icon: Icons.star_border,
        message: 'No favourites yet',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: favs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 6),
      itemBuilder: (context, i) {
        final e = favs[i];
        return EventCard(
          event: e,
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.detail,
              arguments: DetailArgs(
                event: e,
                profile: profile,
                onUpdate: onUpdate,
                goToProfile: goToProfile,
              ),
            );
          },
          onFavourite: () => onUpdate(e.copyWith(favourite: !e.favourite)),
        );
      },
    );
  }
}