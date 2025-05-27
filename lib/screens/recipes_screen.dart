import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Recipes Screen',
        style: TextStyle(fontSize: 24, color: AppColors.white),
      ),
    );
  }
}
