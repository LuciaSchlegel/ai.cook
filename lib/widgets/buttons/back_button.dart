import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';

class BackToFeedButton extends StatelessWidget {
  final VoidCallback onPressed;

  const BackToFeedButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = screenWidth < 400 ? 40.0 : 48.0;

    return IconButton(
      icon: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: AppColors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(buttonSize / 2),
        ),
        child: Center(
          child: Icon(
            Icons.home_rounded,
            color: AppColors.orange,
            size: buttonSize * 0.6,
          ),
        ),
      ),
      onPressed: onPressed,
      splashRadius: buttonSize / 2,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(minWidth: buttonSize, minHeight: buttonSize),
    );
  }
}
