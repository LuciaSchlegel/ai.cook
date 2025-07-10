import 'package:ai_cook_project/screens/recipes/widgets/recipe_image.dart';
import 'package:flutter/material.dart';
import '../../../models/recipe_model.dart';
import '../../../models/user_ing.dart';
import 'recipe_ov_card.dart';
import '../../../theme.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;
  final List<UserIng> userIngredients;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.userIngredients,
  });

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  void _showRecipeDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RecipeOverviewCard(recipe: widget.recipe),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        children: [
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _showRecipeDetail(context),
            child: _RecipeCardContent(
              recipe: widget.recipe,
              userIngredients: widget.userIngredients,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipeCardContent extends StatelessWidget {
  final Recipe recipe;
  final List<UserIng> userIngredients;

  const _RecipeCardContent({
    required this.recipe,
    required this.userIngredients,
  });

  String _getIngredientsStatusText() {
    final missingIngredients = recipe.getMissingIngredients(userIngredients);
    final unitWarnings = recipe.getUnitWarnings(userIngredients);
    if (missingIngredients.isNotEmpty) {
      return '${missingIngredients.length} missing';
    }
    if (unitWarnings > 0) {
      return 'All available ($unitWarnings warning${unitWarnings > 1 ? 's' : ''})';
    }
    return 'All available';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width * 0.24;
    final height = size.width * 0.24;
    final unitWarnings = recipe.getUnitWarnings(userIngredients);
    final missingIngredients = recipe.getMissingIngredients(userIngredients);
    return Card(
      elevation: 6,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RecipeImage(imageUrl: recipe.image, width: width, height: height),
            const SizedBox(width: 16),
            Expanded(
              child: _RecipeDetails(
                recipe: recipe,
                ingredientsStatusText: _getIngredientsStatusText(),
                warning: missingIngredients.isEmpty && unitWarnings > 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipeDetails extends StatelessWidget {
  final Recipe recipe;
  final String ingredientsStatusText;
  final bool warning;

  const _RecipeDetails({
    required this.recipe,
    required this.ingredientsStatusText,
    this.warning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          recipe.name,
          style: const TextStyle(
            fontFamily: 'Casta',
            letterSpacing: 1.2,
            fontSize: 20,
            height: 1.1,
            fontWeight: FontWeight.w600,
            color: AppColors.button,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailRow(
              label: 'Est. time: ',
              value: recipe.cookingTime ?? "N/A",
            ),
            _DetailRow(
              label: 'Difficulty: ',
              value: recipe.difficulty ?? "N/A",
            ),
            _DetailRow(
              label: 'Ingredients: ',
              value: ingredientsStatusText,
              valueColor:
                  warning
                      ? AppColors.orange
                      : (ingredientsStatusText.contains('missing')
                          ? AppColors.orange
                          : AppColors.mutedGreen),
            ),
          ],
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.button,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.mutedGreen,
            fontFamily: 'Inter',
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: valueColor,
              fontFamily: 'Inter',
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
