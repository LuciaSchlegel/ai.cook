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
            child: SizedBox(
              height: size.height * 0.16,
              child: _RecipeCardContent(
                recipe: widget.recipe,
                userIngredients: widget.userIngredients,
              ),
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

  String _getMissingIngredientsText() {
    final missingIngredients = recipe.getMissingIngredients(userIngredients);
    if (missingIngredients.isEmpty) {
      return 'All available';
    }
    return '${missingIngredients.length} missing';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width * 0.24; // Ajusta el valor según tu diseño
    final height = size.height * 0.22; // Ajusta el valor según tu diseño
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
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.14,
                ),
                child: _RecipeDetails(
                  recipe: recipe,
                  missingIngredientsText: _getMissingIngredientsText(),
                ),
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
  final String missingIngredientsText;

  const _RecipeDetails({
    required this.recipe,
    required this.missingIngredientsText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 2,
          child: Text(
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
        ),
        Expanded(
          flex: 3,
          child: Column(
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
                value: missingIngredientsText,
                valueColor:
                    missingIngredientsText.contains('missing')
                        ? AppColors.orange
                        : AppColors.mutedGreen,
              ),
            ],
          ),
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
