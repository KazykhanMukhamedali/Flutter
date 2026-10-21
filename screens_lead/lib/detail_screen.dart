import 'package:flutter/material.dart';

import 'students.dart';
import 'theme.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.student});

  final Student student;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Student _student = widget.student;

  Future<void> _edit() async {
    final result = await showDialog<Student>(
      context: context,
      builder: (_) => _EditDialog(student: _student),
    );
    if (result == null || !mounted) return;

    setState(() => _student = result);

    final index = students.indexWhere((s) => s.image == result.image);
    if (index != -1) {
      students[index] = result;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = AppTheme.villageColor(_student.group, scheme);

    return Scaffold(
      appBar: AppBar(
        title: Text(_student.name),
        actions: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit_rounded),
            onPressed: _edit,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.3),
                        blurRadius: 24,
                        spreadRadius: 2,
                      ),
                    ],
                    image: DecorationImage(
                      image: AssetImage(_student.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _student.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_student.group} · ${_student.rank}',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          _InfoCard(
            icon: Icons.location_city_rounded,
            label: 'Village',
            value: _student.village,
          ),
          _InfoCard(
            icon: Icons.auto_awesome_rounded,
            label: 'Ability / Clan',
            value: _student.email,
          ),
          _InfoCard(
            icon: Icons.military_tech_rounded,
            label: 'Rank',
            value: _student.rank,
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: _edit,
            icon: const Icon(Icons.edit_rounded),
            label: const Text('Rename'),
          ),
        ],
      ),
    );
  }
}

class _EditDialog extends StatefulWidget {
  const _EditDialog({required this.student});

  final Student student;

  @override
  State<_EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<_EditDialog> {
  late final TextEditingController _nameController =
  TextEditingController(text: widget.student.name);

  late final TextEditingController _rankController =
  TextEditingController(text: widget.student.rank);

  @override
  void dispose() {
    _nameController.dispose();
    _rankController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    final rank = _rankController.text.trim();
    if (name.isEmpty || rank.isEmpty) return;
    Navigator.of(context).pop(
      widget.student.copyWith(name: name, rank: rank),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final canSave = _nameController.text.trim().isNotEmpty &&
        _rankController.text.trim().isNotEmpty;

    return AlertDialog(
      icon: const Icon(Icons.edit_rounded, size: 28),
      title: const Text('Edit shinobi'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            autofocus: true,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Name',
              prefixIcon: Icon(Icons.person_rounded),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _rankController,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Rank',
              prefixIcon: Icon(Icons.military_tech_rounded),
            ),
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _save(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
        ),
        FilledButton(
          onPressed: canSave ? _save : null,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: scheme.primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}