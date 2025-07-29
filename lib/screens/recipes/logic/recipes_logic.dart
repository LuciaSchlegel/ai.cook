import 'package:ai_cook_project/providers/recipes_provider.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> filterRecipesLogic({
  required BuildContext context,
  required String selectedFilter,
  required List<String> selectedTags,
  int? maxCookingTimeMinutes,
  String? preferredDifficulty,
}) async {
  final recipesProvider = Provider.of<RecipesProvider>(context, listen: false);
  final ingredientsProvider = Provider.of<IngredientsProvider>(
    context,
    listen: false,
  );

  await recipesProvider.filterRecipesFromApi(
    userIngredients: ingredientsProvider.userIngredients,
    filter: selectedFilter,
    preferredTags: selectedTags,
    maxCookingTimeMinutes: maxCookingTimeMinutes,
    preferredDifficulty: preferredDifficulty,
  );
}
