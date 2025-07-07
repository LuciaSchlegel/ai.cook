import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';

class EmptyIngredientListMessage extends StatelessWidget {
  const EmptyIngredientListMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No ingredients match your filters',
        style: TextStyle(
          color: AppColors.white,
          fontFamily: 'Casta',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
