import 'package:ai_cook_project/models/recipe_model.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/cards/recipe_ing_card.dart';
import 'package:flutter/material.dart';

class RecipeGlanceCard extends StatelessWidget {
  final Recipe recipe;
  final Size size;

  const RecipeGlanceCard({required this.recipe, required this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.92,
      height: size.height * 0.52,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.mutedGreen.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.mutedGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.visibility_outlined,
                  size: 20,
                  color: AppColors.mutedGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Quick Overview',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppColors.button,
                    fontFamily: 'Casta',
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Info Cards Section
          _RecipeInfoCards(recipe: recipe),

          const SizedBox(height: 20),

          // Ingredients Section
          Expanded(child: _IngredientsSection(recipe: recipe, size: size)),
        ],
      ),
    );
  }
}

class _RecipeInfoCards extends StatelessWidget {
  final Recipe recipe;

  const _RecipeInfoCards({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _InfoCard(
            icon: Icons.timer_outlined,
            title: 'Time',
            value: recipe.cookingTime ?? 'N/A',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _InfoCard(
            icon: Icons.restaurant_menu_rounded,
            title: 'Level',
            value: recipe.difficulty ?? 'N/A',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _InfoCard(
            icon: Icons.people_outline_rounded,
            title: 'Serves',
            value: '${recipe.servings ?? 'N/A'}',
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.mutedGreen.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: AppColors.mutedGreen),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.mutedGreen,
              fontFamily: 'Inter',
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.button,
              fontFamily: 'Inter',
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _IngredientsSection extends StatelessWidget {
  final Recipe recipe;
  final Size size;

  const _IngredientsSection({required this.recipe, required this.size});

  @override
  Widget build(BuildContext context) {
    return RecipeIngCard(
      recipe: recipe,
      size: Size(size.width * 0.85, size.height * 0.25),
    );
  }
}
