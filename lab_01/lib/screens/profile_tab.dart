import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/profile.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({
    super.key,
    required this.profile,
    required this.onProfileChanged,
    required this.themeMode,
    required this.onThemeChanged,
    required this.events,
  });
  final Profile profile;
  final void Function(Profile) onProfileChanged;
  final ThemeMode themeMode;
  final void Function(ThemeMode) onThemeChanged;
  final List<Event> events;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final onLists =
        events.where((e) => e.names.contains(profile.name)).length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: scheme.primaryContainer,
                  child: Icon(Icons.person,
                      size: 30, color: scheme.onPrimaryContainer),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name.isEmpty ? 'No name yet' : profile.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.group.isEmpty ? 'No group' : profile.group,
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: () => _openEditDialog(context),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: Icon(Icons.list_alt, color: scheme.primary),
            title: Text('You are on $onLists lists'),
          ),
        ),
        const SizedBox(height: 24),
        Text('Theme',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: const Text('Light'),
              selected: themeMode == ThemeMode.light,
              onSelected: (_) => onThemeChanged(ThemeMode.light),
            ),
            ChoiceChip(
              label: const Text('Dark'),
              selected: themeMode == ThemeMode.dark,
              onSelected: (_) => onThemeChanged(ThemeMode.dark),
            ),
            ChoiceChip(
              label: const Text('System'),
              selected: themeMode == ThemeMode.system,
              onSelected: (_) => onThemeChanged(ThemeMode.system),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _openEditDialog(BuildContext context) async {
    final nameCtrl = TextEditingController(text: profile.name);
    final groupCtrl = TextEditingController(text: profile.group);
    final groupRe = RegExp(r'^[A-Z]{2}-\d{3}$');
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit profile'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                textInputAction: TextInputAction.next,
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.length < 2) return 'At least 2 characters';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: groupCtrl,
                decoration: const InputDecoration(
                  labelText: 'Group (e.g. AB-123)',
                ),
                textInputAction: TextInputAction.done,
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return 'Required';
                  if (!groupRe.hasMatch(t)) return 'Format AB-123';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                onProfileChanged(Profile(
                  name: nameCtrl.text.trim(),
                  group: groupCtrl.text.trim(),
                ));
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}