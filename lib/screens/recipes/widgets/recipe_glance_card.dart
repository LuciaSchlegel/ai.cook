import 'package:ai_cook_project/models/recipe_model.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/recipe_ing_card.dart';
import 'package:flutter/material.dart';

class RecipeGlanceCard extends StatelessWidget {
  final Recipe recipe;
  final Size size;

  const RecipeGlanceCard({required this.recipe, required this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.92,
      height: size.height * 0.5,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.mutedGreen, width: 1),
        color: Colors.black.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'at a glance',
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: AppColors.withOpacity(AppColors.button, 0.8),
              fontFamily: 'Casta',
            ),
          ),
          _GlanceDivider(width: size.width * 1),
          const SizedBox(height: 10),
          _GlanceInfoRow(recipe: recipe),
          const SizedBox(height: 10),
          _GlanceDetailsRow(recipe: recipe, size: size),
        ],
      ),
    );
  }
}

class _GlanceDivider extends StatelessWidget {
  final double width;

  const _GlanceDivider({required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF151414).withOpacity(0.5),
            const Color(0xFF151414).withOpacity(0.5),
          ],
        ),
      ),
    );
  }
}

class _GlanceInfoRow extends StatelessWidget {
  final Recipe recipe;

  const _GlanceInfoRow({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildGlanceItem(Icons.timer_outlined, recipe.cookingTime ?? "N/A"),
          _buildGlanceItem(
            Icons.restaurant_menu_rounded,
            'Level: ${recipe.difficulty}',
          ),
          _buildGlanceItem(
            Icons.people_outline_rounded,
            'Servings: ${recipe.servings}',
          ),
        ],
      ),
    );
  }

  Widget _buildGlanceItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.mutedGreen),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.button,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}

class _GlanceDetailsRow extends StatelessWidget {
  final Recipe recipe;
  final Size size;

  const _GlanceDetailsRow({required this.recipe, required this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size.height * 0.34,
        child: RecipeIngCard(
          recipe: recipe,
          size: Size(size.width * 0.85, size.height * 0.3),
        ),
      ),
    );
  }
}
