import 'package:flutter/material.dart';
import 'data/seed.dart';
import 'models/event.dart';
import 'models/profile.dart';
import 'routes.dart';
import 'screens/event_list_tab.dart';
import 'screens/favourites_tab.dart';
import 'screens/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });
  final ThemeMode themeMode;
  final void Function(ThemeMode) onThemeChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  List<Event> _events = seedEvents();
  Profile _profile = Profile.empty();

  void _updateEvent(Event updated) {
    setState(() {
      _events =
          _events.map((e) => e.id == updated.id ? updated : e).toList();
    });
  }

  void _goToTab(int i) => setState(() => _index = i);

  Future<void> _openForm() async {
    final result =
    await Navigator.pushNamed<Event?>(context, Routes.form);
    if (result != null && mounted) {
      setState(() => _events = [..._events, result]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      EventListTab(
        events: _events,
        profile: _profile,
        onUpdate: _updateEvent,
        goToProfile: () => _goToTab(2),
        onAdd: _openForm,
      ),
      FavouritesTab(
        events: _events,
        profile: _profile,
        onUpdate: _updateEvent,
        goToProfile: () => _goToTab(2),
      ),
      ProfileTab(
        profile: _profile,
        onProfileChanged: (p) => setState(() => _profile = p),
        themeMode: widget.themeMode,
        onThemeChanged: widget.onThemeChanged,
        events: _events,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(['Campus Catering', 'Favourites', 'Profile'][_index]),
      ),
      drawer: _buildDrawer(),
      body: tabs[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _goToTab,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.restaurant_menu), label: 'Menu'),
          NavigationDestination(
              icon: Icon(Icons.favorite), label: 'Favourites'),
          NavigationDestination(
              icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildDrawer() => Drawer(
    child: ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
          child: const Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Campus Catering',
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('About'),
          onTap: () {
            Navigator.pop(context);
            showDialog<void>(
              context: context,
              builder: (_) => const AlertDialog(
                title: Text('Campus Catering'),
                content: Text('Lab 01 - campus catering events.'),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.restart_alt),
          title: const Text('Reset data'),
          onTap: () async {
            Navigator.pop(context);
            final ok = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Reset?'),
                content:
                const Text('Restore seed and clear profile?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Reset'),
                  ),
                ],
              ),
            );
            if (ok == true && mounted) {
              setState(() {
                _events = seedEvents();
                _profile = Profile.empty();
              });
            }
          },
        ),
      ],
    ),
  );
}