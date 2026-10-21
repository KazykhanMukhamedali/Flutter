import 'dart:async';
import 'package:flutter/material.dart';
import '../models/event.dart';
import '../routes.dart';
import '../utils/format.dart';

class DetailScreenWrapper extends StatelessWidget {
  const DetailScreenWrapper({super.key, required this.args});
  final DetailArgs args;
  @override
  Widget build(BuildContext context) => _DetailScreen(args: args);
}

class _DetailScreen extends StatefulWidget {
  const _DetailScreen({required this.args});
  final DetailArgs args;
  @override
  State<_DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<_DetailScreen> {
  late Event _event;
  Timer? _timer;
  Countdown _countdown = const Ended();

  @override
  void initState() {
    super.initState();
    _event = widget.args.event;
    _updateCountdown();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) _updateCountdown();
    });
  }

  void _updateCountdown() {
    setState(() => _countdown = countdownFrom(_event.when));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _countdownText => switch (_countdown) {
    Upcoming(:final duration) =>
    'In ${duration.inDays}d ${duration.inHours % 24}h',
    Started(:final duration) => 'Started ${duration.inMinutes}m ago',
    Ended() => 'Ended',
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_event.title,
              maxLines: 1, overflow: TextOverflow.ellipsis),
          actions: [
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'edit') _edit();
                if (v == 'delete') _confirmDelete();
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
          bottom: TabBar(tabs: [
            const Tab(text: 'About'),
            Tab(text: 'Names (${_event.count})'),
          ]),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 160,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/event_header.jpg', fit: BoxFit.cover),
                  Container(color: Colors.black26),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Icon(_event.category.icon,
                        color: Colors.white, size: 32),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Chip(
                      backgroundColor: scheme.surface,
                      label: Text(_countdownText),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(children: [
                _aboutTab(),
                _namesTab(scheme),
              ]),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: _primaryButton(),
          ),
        ),
      ),
    );
  }

  Widget _aboutTab() => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      ListTile(
        leading: const Icon(Icons.calendar_today),
        title: Text(formatDateTime(_event.when)),
      ),
      ListTile(
        leading: const Icon(Icons.place),
        title: Text(_event.mode ? 'Online' : 'Campus'),
      ),
      ListTile(
        leading: const Icon(Icons.people),
        title: Text('${_event.places.taken} of ${_event.limit} taken '
            '(${_event.places.free} free)'),
      ),
      if (_event.optionalText != null)
        ListTile(
          leading: const Icon(Icons.notes),
          title: Text(_event.optionalText!),
        ),
    ],
  );

  Widget _namesTab(ColorScheme scheme) {
    if (_event.names.isEmpty) {
      return const Center(child: Text('Nobody on the list yet'));
    }
    return ListView(
      children: _event.names
          .map((n) => ListTile(
        leading: const Icon(Icons.person),
        title: Text(
          n,
          style: TextStyle(
            fontWeight: n == widget.args.profile.name
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
        trailing: n == widget.args.profile.name
            ? Text('You', style: TextStyle(color: scheme.primary))
            : null,
      ))
          .toList(),
    );
  }

  Widget _primaryButton() {
    final me = widget.args.profile.name;
    final onList = me.isNotEmpty && _event.contains(me);
    final canAct = onList || !_event.isFull;
    return FilledButton(
      onPressed: canAct ? () => _primaryAction(onList) : null,
      child: Text(
        onList
            ? 'Leave'
            : _event.isFull
            ? 'Full'
            : 'Register',
      ),
    );
  }

  Future<void> _primaryAction(bool onList) async {
    if (widget.args.profile.name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Set your name in Profile first'),
          action: SnackBarAction(
            label: 'Profile',
            onPressed: widget.args.goToProfile,
          ),
        ),
      );
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(onList ? 'Leave?' : 'Register?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirm')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final newNames = List<String>.from(_event.names);
    if (onList) {
      newNames.remove(widget.args.profile.name);
    } else {
      newNames.add(widget.args.profile.name);
    }
    final updated = _event.copyWith(names: newNames);
    setState(() => _event = updated);
    widget.args.onUpdate(updated);
  }

  Future<void> _edit() async {
    final result = await Navigator.pushNamed<Event?>(
      context,
      Routes.form,
      arguments: _event,
    );
    if (result != null && mounted) {
      setState(() => _event = result);
      widget.args.onUpdate(result);
    }
  }

  Future<void> _confirmDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete this event?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true && mounted) Navigator.pop(context);
  }
}