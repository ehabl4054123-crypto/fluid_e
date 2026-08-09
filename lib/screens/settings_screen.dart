import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('شاشة الإعدادات', style: TextStyle(color: Color(0xFF00A8E8), fontSize: 24)),
    );
  }
}
