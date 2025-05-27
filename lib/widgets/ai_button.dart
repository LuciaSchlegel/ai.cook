import 'package:ai_cook_project/theme.dart';
import 'package:flutter/material.dart';

class AiButton extends StatelessWidget {
  const AiButton({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = screenWidth < 400 ? 64.0 : 72.0;

    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.orange,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Text(
          'ai',
          style: TextStyle(
            fontFamily: 'Casta',
            fontSize: 42,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
