import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Settings Screen',
        style: TextStyle(fontSize: 24, color: AppColors.white),
      ),
    );
  }
}
