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
        border: Border.all(color: AppColors.mutedGreen.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.shopping_basket_outlined,
                size: 20,
                color: AppColors.mutedGreen,
              ),
              const SizedBox(width: 8),
              Text(
                'Ingredients',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.button,
                  fontFamily: 'Casta',
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.mutedGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${recipe.ingredients.length} items',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mutedGreen,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (recipe.ingredients.isNotEmpty)
            Expanded(
              child: ListView.separated(
                itemCount: recipe.ingredients.length,
                separatorBuilder: (context, idx) => const SizedBox(height: 8),
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
                  fontSize: 14,
                  fontFamily: 'Inter',
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.mutedGreen.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.mutedGreen,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              ingredient.ingredient.name,
              style: const TextStyle(
                color: AppColors.button,
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              '${ingredient.quantity} ${ingredient.unit?.name ?? ""}',
              style: TextStyle(
                color: AppColors.mutedGreen.withOpacity(0.8),
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.2,
                letterSpacing: 0.2,
              ),
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            CupertinoIcons.checkmark_circle_fill,
            size: 18,
            color: AppColors.mutedGreen.withOpacity(0.7),
          ),
        ],
      ),
    );
  }
}
