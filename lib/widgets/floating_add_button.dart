import 'package:ai_cook_project/theme.dart';
import 'package:flutter/material.dart';

class FloatingAddButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String heroTag;

  const FloatingAddButton({
    required this.onPressed,
    this.heroTag = 'add_button',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: FloatingActionButton(
        heroTag: heroTag,
        onPressed: onPressed,
        backgroundColor: AppColors.button.withOpacity(0.9),
        elevation: 2,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}
