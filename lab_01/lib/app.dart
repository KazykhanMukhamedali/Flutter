import 'package:flutter/material.dart';
import 'models/event.dart';
import 'routes.dart';
import 'screens/detail_screen.dart';
import 'screens/form_screen.dart';
import 'home_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _setTheme(ThemeMode m) => setState(() => _themeMode = m);

  static const _seed = Color(0xFFC94A2E);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Catering',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _seed),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      initialRoute: Routes.shell,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case Routes.detail:
            final args = settings.arguments as DetailArgs;
            return MaterialPageRoute(
              builder: (_) => DetailScreenWrapper(args: args),
            );
          case Routes.form:
            final initial = settings.arguments as Event?;
            return MaterialPageRoute<Event>(
              builder: (_) => FormScreen(initial: initial),
            );
          case Routes.shell:
            return MaterialPageRoute(
              builder: (_) => HomeScreen(
                themeMode: _themeMode,
                onThemeChanged: _setTheme,
              ),
            );
          default:
            return null;
        }
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('Not found')),
        ),
      ),
    );
  }
}