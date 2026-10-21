import 'package:flutter/material.dart';
import '../models/event.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key, this.initial});
  final Event? initial;
  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _titleCtrl =
  TextEditingController(text: widget.initial?.title ?? '');
  late final _placeCtrl =
  TextEditingController(text: widget.initial?.optionalText ?? '');
  late final _limitCtrl =
  TextEditingController(text: widget.initial?.limit.toString() ?? '10');
  late DateTime _when =
      widget.initial?.when ?? DateTime.now().add(const Duration(days: 1));
  late EventCategory _category =
      widget.initial?.category ?? EventCategory.starters;
  late bool _mode = widget.initial?.mode ?? false;
  bool _saving = false;
  bool _dirty = false;

  final _titleFocus = FocusNode();
  final _placeFocus = FocusNode();
  final _limitFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    for (final c in [_titleCtrl, _placeCtrl, _limitCtrl]) {
      c.addListener(() {
        if (!_dirty) setState(() => _dirty = true);
      });
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _placeCtrl.dispose();
    _limitCtrl.dispose();
    _titleFocus.dispose();
    _placeFocus.dispose();
    _limitFocus.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _when,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      setState(() {
        _when = DateTime(
            picked.year, picked.month, picked.day, _when.hour, _when.minute);
        _dirty = true;
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_when),
    );
    if (picked != null && mounted) {
      setState(() {
        _when = DateTime(
            _when.year, _when.month, _when.day, picked.hour, picked.minute);
        _dirty = true;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    final result = Event(
      id: widget.initial?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      category: _category,
      when: _when,
      limit: int.parse(_limitCtrl.text),
      names: widget.initial?.names ?? const [],
      mode: _mode,
      optionalText:
      _placeCtrl.text.trim().isEmpty ? null : _placeCtrl.text.trim(),
      favourite: widget.initial?.favourite ?? false,
    );
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final currentCount = widget.initial?.count ?? 0;
    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final discard = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Discard changes?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Keep')),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Discard')),
            ],
          ),
        );
        if (discard == true && context.mounted) Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.initial == null ? 'New event' : 'Edit event'),
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _titleCtrl,
                focusNode: _titleFocus,
                maxLength: 60,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Title'),
                onTapOutside: (_) => _titleFocus.unfocus(),
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.length < 3 || t.length > 60) return '3-60 characters';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _placeCtrl,
                focusNode: _placeFocus,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: _mode ? 'Link (must contain ://)' : 'Place',
                ),
                onTapOutside: (_) => _placeFocus.unfocus(),
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return 'Required';
                  if (_mode && !t.contains('://')) return 'Must contain ://';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _limitCtrl,
                focusNode: _limitFocus,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: 'Limit (1-500)'),
                onTapOutside: (_) => _limitFocus.unfocus(),
                validator: (v) {
                  final n = int.tryParse(v?.trim() ?? '');
                  if (n == null || n < 1 || n > 500) return '1-500';
                  if (widget.initial != null && n < currentCount) {
                    return 'Below current count ($currentCount)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<EventCategory>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: EventCategory.values
                    .map((c) => DropdownMenuItem(
                  value: c,
                  child: Row(
                    children: [
                      Icon(c.icon, size: 18),
                      const SizedBox(width: 8),
                      Text(c.label),
                    ],
                  ),
                ))
                    .toList(),
                onChanged: (c) {
                  if (c == null) return;
                  setState(() {
                    _category = c;
                    _dirty = true;
                  });
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      onTap: _pickDate,
                      decoration: InputDecoration(
                        labelText: 'Date',
                        hintText: _when.toIso8601String().split('T').first,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      onTap: _pickTime,
                      decoration: InputDecoration(
                        labelText: 'Time',
                        hintText:
                        '${_when.hour.toString().padLeft(2, '0')}:'
                            '${_when.minute.toString().padLeft(2, '0')}',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Online (mode)'),
                value: _mode,
                onChanged: (v) => setState(() {
                  _mode = v;
                  _dirty = true;
                }),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}