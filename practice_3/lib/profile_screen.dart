import 'package:flutter/material.dart';

import 'data.dart';
import 'profile_header.dart';
import 'info_row.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My profile'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
          child: Column(
            children: [
              const ProfileHeader(name: myName, university: myUniversity),
              const SizedBox(height: 24),
              for (final fact in facts)
                InfoRow(label: fact.label, value: fact.value),
            ],
          ),
        ),
      ),
    );
  }
}
