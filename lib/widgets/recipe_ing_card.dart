import 'package:ai_cook_project/models/recipe_ingredient_model.dart';
import 'package:ai_cook_project/models/recipe_model.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipeIngCard extends StatelessWidget {
  final Recipe recipe;
  final Size size;

  const RecipeIngCard({required this.recipe, required this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.mutedGreen, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ingredients',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.button,
              fontFamily: 'Casta',
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          if (recipe.ingredients.isNotEmpty)
            Expanded(
              child: ListView.separated(
                itemCount: recipe.ingredients.length,
                separatorBuilder: (context, idx) => const SizedBox(height: 6),
                itemBuilder:
                    (context, index) =>
                        _IngredientRow(ingredient: recipe.ingredients[index]),
                padding: EdgeInsets.zero,
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                '• No ingredients listed',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: AppColors.button,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  final RecipeIngredient ingredient;

  const _IngredientRow({required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: Text(
            '• ${ingredient.ingredient.name}',
            style: const TextStyle(
              color: AppColors.button,
              fontSize: 13,
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w400,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 4,
          child: Text(
            '${ingredient.quantity} ${ingredient.unit?.name ?? ""}',
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: AppColors.button,
              fontSize: 13,
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          CupertinoIcons.checkmark_circle_fill,
          size: 16,
          color: AppColors.mutedGreen,
        ),
      ],
    );
  }
}
