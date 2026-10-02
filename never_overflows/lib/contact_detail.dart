import 'package:flutter/material.dart';
import 'contacts.dart';

class ContactDetailPage extends StatelessWidget {
  const ContactDetailPage({super.key, required this.contact});

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final avatarColor = Color(contact.clanColor);
    final onAvatar = ThemeData.estimateBrightnessForColor(avatarColor) ==
        Brightness.dark
        ? Colors.white
        : Colors.black87;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 280,
            backgroundColor: avatarColor,
            foregroundColor: onAvatar,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                contact.name,
                style: text.titleMedium?.copyWith(
                  color: onAvatar,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              background: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      avatarColor,
                      avatarColor.withValues(alpha: 0.6),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: Image.asset(
                                contact.avatar,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Center(
                                  child: Text(
                                    contact.initial,
                                    style: text.displaySmall?.copyWith(
                                      color: avatarColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (contact.unread > 0)
                            Positioned(
                              right: 4,
                              bottom: 4,
                              child: Container(
                                width: 32,
                                height: 32,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: scheme.error,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                                child: Text(
                                  contact.unread > 9
                                      ? '9+'
                                      : '${contact.unread}',
                                  style: text.labelMedium?.copyWith(
                                    color: scheme.onError,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        contact.role,
                        style: text.titleSmall?.copyWith(
                          color: onAvatar.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ActionButton(
                    icon: Icons.call,
                    label: 'Call',
                    onTap: () => _snack(context, 'Calling ${contact.name}…'),
                  ),
                  _ActionButton(
                    icon: Icons.message_outlined,
                    label: 'Message',
                    onTap: () => _snack(context, 'Message to ${contact.name}'),
                  ),
                  _ActionButton(
                    icon: Icons.videocam_outlined,
                    label: 'Video',
                    onTap: () => _snack(context, 'Video with ${contact.name}'),
                  ),
                  _ActionButton(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    onTap: () => _snack(context, 'Email to ${contact.email}'),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Card(
                elevation: 0,
                color: scheme.surfaceContainerHigh,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _InfoTile(
                      icon: Icons.badge_outlined,
                      label: 'Role',
                      value: contact.role,
                    ),
                    const Divider(height: 1, indent: 56),
                    _InfoTile(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: contact.email,
                    ),
                    const Divider(height: 1, indent: 56),
                    _InfoTile(
                      icon: Icons.home_work_outlined,
                      label: 'Village',
                      value: 'Konohagakure',
                    ),
                    const Divider(height: 1, indent: 56),
                    _InfoTile(
                      icon: Icons.mark_email_unread_outlined,
                      label: 'Unread messages',
                      value: '${contact.unread}',
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Text(
                'About',
                style: text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              child: Text(
                '${contact.name} is a shinobi of Konohagakure, '
                    'known as "${contact.role}". '
                    'A trusted member of the village and a valued ally.',
                style: text.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: scheme.onPrimaryContainer,
                size: 22,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: text.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return ListTile(
      leading: Icon(icon, color: scheme.primary),
      title: Text(
        label,
        style: text.bodySmall?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      subtitle: Text(
        value,
        style: text.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: scheme.onSurface,
        ),
      ),
    );
  }
}