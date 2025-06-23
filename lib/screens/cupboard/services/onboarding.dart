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

  // Show onboarding dialog if it's the first time
  if (!hasShownOnboarding && ingredientsProvider.userIngredients.isEmpty) {
    await showGlobalIngredientsDialog(context);
    return true;
  }

  return hasShownOnboarding;
}
