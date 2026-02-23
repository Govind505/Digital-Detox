import 'package:flutter/material.dart';

class AuthCard extends StatelessWidget {
  const AuthCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: ListTile(
        title: Text('Local Profile Enabled'),
        subtitle: Text('Google Sign-In is optional and never required.'),
      ),
    );
  }
}
