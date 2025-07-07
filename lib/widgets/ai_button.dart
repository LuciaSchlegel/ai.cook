import 'package:ai_cook_project/theme.dart';
import 'package:flutter/material.dart';

class AiButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isActive;

  const AiButton({super.key, required this.onPressed, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = screenWidth < 400 ? 64.0 : 72.0;

    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: isActive
                ? [AppColors.orange, const Color(0xFFF8D794)]
                : [const Color(0xFFF8D794), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.orange.withOpacity(0.18),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: Center(
              child: Image.asset(
                'assets/icons/ai.png',
                width: 44,
                height: 44,
                color: isActive ? AppColors.white : AppColors.button,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
