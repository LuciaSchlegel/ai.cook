import 'package:ai_cook_project/models/recipe_model.dart';
import 'package:ai_cook_project/providers/recipes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeFinderService {
  /// Busca una receta por su [id] dentro del [RecipesProvider].
  static Recipe? findRecipeById({
    required BuildContext context,
    required int id,
    bool listen = false,
  }) {
    final recipesProvider = Provider.of<RecipesProvider>(
      context,
      listen: listen,
    );
    final recipes = recipesProvider.recipes; // getter

    try {
      return recipes.firstWhere((recipe) => recipe.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Variante que lanza excepción si no encuentra la receta
  static Recipe findOrThrow({
    required BuildContext context,
    required int id,
    bool listen = false,
  }) {
    final recipe = findRecipeById(context: context, id: id, listen: listen);
    if (recipe == null) {
      throw Exception('Recipe with ID $id not found in provider.');
    }
    return recipe;
  }
}
