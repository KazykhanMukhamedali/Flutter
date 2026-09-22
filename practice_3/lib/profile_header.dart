import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    required this.university,
  });

  final String name;
  final String university;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/my_photo.JPG', width: 300, height: 300),
        const SizedBox(height: 16),
        Text(
          name,
          style: const TextStyle(
            fontFamily: 'MyFont',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          university,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
