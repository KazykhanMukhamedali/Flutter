import 'package:flutter/material.dart';
import '../models/event.dart';
import '../utils/format.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    this.onTap,
    this.onFavourite,
  });
  final Event event;
  final VoidCallback? onTap;
  final VoidCallback? onFavourite;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor:
                    event.category.color(scheme).withValues(alpha: 0.2),
                    child: Icon(event.category.icon,
                        size: 26, color: event.category.color(scheme)),
                  ),
                  if (event.isFull)
                    Positioned(
                      right: -8,
                      bottom: -6,
                      child: _badge('FULL', scheme.error, scheme.onError),
                    )
                  else if (event.freePlaces <= 5 && event.freePlaces > 0)
                    Positioned(
                      right: -8,
                      bottom: -6,
                      child: _badge(
                        '${event.freePlaces} left',
                        scheme.tertiaryContainer,
                        scheme.onTertiaryContainer,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${formatDateTime(event.when)} · '
                          '${event.mode ? "Online" : "Campus"}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12, color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  event.favourite ? Icons.favorite : Icons.favorite_border,
                  color: event.favourite ? scheme.error : null,
                ),
                onPressed: onFavourite,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(String text, Color bg, Color fg) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration:
    BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
    child: Text(
      text,
      style: TextStyle(
          fontSize: 9, color: fg, fontWeight: FontWeight.bold),
    ),
  );
}