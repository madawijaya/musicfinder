import 'package:flutter/material.dart';

class HomeGreeting extends StatelessWidget {
  const HomeGreeting({super.key, required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    final secondaryText = TextStyle(color: Colors.grey.shade400, fontSize: 13);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          username.isEmpty ? 'Explore Music' : 'Halo, $username!',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text('Cari lagu favoritmu dan nikmati musiknya', style: secondaryText),
      ],
    );
  }
}
