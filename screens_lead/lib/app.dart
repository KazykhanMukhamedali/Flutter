import 'package:flutter/material.dart';

import 'detail_screen.dart';
import 'routes.dart';
import 'students.dart';
import 'students_screen.dart';
import 'theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Shinobi Academy',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light(),
    darkTheme: AppTheme.dark(),
    themeMode: ThemeMode.system,
    initialRoute: Routes.students,
    routes: {
      Routes.students: (_) => const StudentsScreen(),
    },
    onGenerateRoute: (settings) {
      switch (settings.name) {
        case Routes.student:
          final student = settings.arguments as Student;
          return MaterialPageRoute(
            builder: (_) => DetailScreen(student: student),
          );
      }
      return null;
    },
  );
}