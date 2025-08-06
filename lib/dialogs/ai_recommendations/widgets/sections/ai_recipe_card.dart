import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/utils/details_container.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/utils/image_clip.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/utils/recipe_details.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/models/recipe_model.dart';
import 'package:ai_cook_project/providers/ai_recommendations_provider.dart';
import 'package:ai_cook_project/screens/recipes/widgets/recipe_ov_card.dart';

class AIRecipeCard extends StatelessWidget {
  final RecipeWithMissingIngredients recipeWithMissingInfo;

  const AIRecipeCard({super.key, required this.recipeWithMissingInfo});

  void _showRecipeDetail(BuildContext context) {
    try {
      final recipe = Recipe.fromJson(recipeWithMissingInfo.recipe);
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => RecipeOverviewCard(recipe: recipe),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error opening recipe: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipe = recipeWithMissingInfo.recipe;
    final missingCount = recipeWithMissingInfo.missingCount;
    final matchPercentage = recipeWithMissingInfo.matchPercentage;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () => _showRecipeDetail(context),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border:
                missingCount > 0
                    ? Border.all(
                      color: missingCount == 1 ? Colors.orange : Colors.red,
                      width: 2,
                    )
                    : Border.all(color: Colors.green, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe image (if available)
              if (recipe['image'] != null &&
                  recipe['image'].toString().isNotEmpty)
                ImageClip(recipe: recipe),
              // Header with recipe name and match status
              DetailsContainer(
                recipe: recipe,
                missingCount: missingCount,
                matchPercentage: matchPercentage,
              ),
              // Recipe details
              RecipeDetails(
                recipe: recipe,
                missingCount: missingCount,
                recipeWithMissingInfo: recipeWithMissingInfo,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
