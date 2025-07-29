import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_cook_project/dialogs/ingredients/global_ing/global_ing_dialog.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';

Future<bool> handleOnboarding({
  required BuildContext context,
  required bool hasShownOnboarding,
}) async {
  final ingredientsProvider = Provider.of<IngredientsProvider>(
    context,
    listen: false,
  );
  final resourceProvider = Provider.of<ResourceProvider>(
    context,
    listen: false,
  );

  // Load units if needed
  if (resourceProvider.units.isEmpty) {
    await resourceProvider.initializeResources();
  }

  // Load user ingredients if needed
  if (!ingredientsProvider.isInitialized) {
    await ingredientsProvider.initializeIngredients();
  }

  // Wait for global ingredients to be loaded (max 3 seconds) or until provider is initialized
  int waited = 0;
  while (ingredientsProvider.ingredients.isEmpty &&
      waited < 3000 &&
      ingredientsProvider.isLoading) {
    await Future.delayed(const Duration(milliseconds: 100));
    waited += 100;
  }

  // Show onboarding dialog if it's the first time and user has no ingredients
  // Even if global ingredients failed to load, we should still show onboarding
  if (!hasShownOnboarding && ingredientsProvider.userIngredients.isEmpty) {
    await showGlobalIngredientsDialog(context);
    return true;
  }

  return hasShownOnboarding;
}
