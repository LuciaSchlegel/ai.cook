// widgets/navigation_text_link.dart
import 'package:ai_cook_project/theme.dart';
import 'package:flutter/material.dart';

class NavigationTextLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const NavigationTextLink({
    required this.label,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.button,
          ),
        ),
      ),
    );
  }
}
