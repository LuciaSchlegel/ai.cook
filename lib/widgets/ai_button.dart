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
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor:
            isActive
                ? const Color.fromARGB(255, 125, 68, 30)
                : AppColors.orange,
        elevation: isActive ? 2 : 6,
        shape: const CircleBorder(),
        child: Text(
          'ai',
          style: TextStyle(
            fontFamily: 'Casta',
            fontSize: 52,
            color: Colors.grey[200],
          ),
        ),
      ),
    );
  }
}
