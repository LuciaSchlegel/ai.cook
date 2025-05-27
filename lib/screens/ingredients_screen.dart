import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';

class IngredientsScreen extends StatelessWidget {
  const IngredientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Ingredients Screen',
        style: TextStyle(fontSize: 24, color: AppColors.white),
      ),
    );
  }
}
