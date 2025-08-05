import 'package:ai_cook_project/providers/ai_recommendations_provider.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:ai_cook_project/models/recipe_tag_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void generateAIRecommendationsHelper({
  required BuildContext context,
  required List<RecipeTag> selectedTags,
  required String selectedDifficulty,
  required TextEditingController maxTimeController,
  required TextEditingController preferencesController,
}) {
  final ingredientsProvider = Provider.of<IngredientsProvider>(
    context,
    listen: false,
  );
  final aiProvider = Provider.of<AIRecommendationsProvider>(
    context,
    listen: false,
  );

  final maxTime = int.tryParse(maxTimeController.text) ?? 30;

  aiProvider.generateRecommendations(
    input: AIRecomendationInput(
      userIngredients: ingredientsProvider.userIngredients,
      preferredTags: selectedTags,
      maxCookingTimeMinutes: maxTime,
      preferredDifficulty: selectedDifficulty,
      userPreferences:
          preferencesController.text.trim().isEmpty
              ? null
              : preferencesController.text.trim(),
      numberOfRecipes: 5,
    ),
  );
}
