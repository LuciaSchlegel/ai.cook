import 'package:ai_cook_project/models/recipe_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';

List<Recipe> recommendRecipes({
  required List<Recipe> allRecipes,
  required List<UserIng> userIngredients,
  double minMatchRatio = 0.6,
  List<String> preferredTags = const [],
  int? maxCookingTimeMinutes,
  String? preferredDifficulty,
}) {
  return allRecipes.where((recipe) {
    // Paso 1: match de ingredientes
    final matchedCount = recipe.ingredients.where((ri) {
      return userIngredients.any((ui) => ui.ingredient?.id == ri.ingredient.id);
    }).length;

    final ratio = matchedCount / recipe.ingredients.length;
    if (ratio < minMatchRatio) return false;

    // Paso 2: verificar cantidades y unidades
    final hasEnoughAll = recipe.ingredients.every((ri) {
      final userIng = userIngredients.firstWhere(
        (ui) => ui.ingredient?.id == ri.ingredient.id,
        orElse: () => UserIng(id: -1, uid: '', quantity: 0),
      );

      // Validar unidad
      if (ri.unit?.id != userIng.unit?.id) {
        // Podrías implementar conversión si querés
        return false;
      }

      return userIng.quantity >= ri.quantity;
    });

    if (!hasEnoughAll) return false;

    // Paso 3: filtrar por tags (preferencias)
    final matchesTags = preferredTags.isEmpty ||
        recipe.tags.any((tag) =>
            preferredTags.any((pref) =>
                tag.name.toLowerCase() == pref.toLowerCase()));

    if (!matchesTags) return false;

    // Paso 4: filtrar por tiempo máximo
    if (maxCookingTimeMinutes != null &&
        recipe.cookingTime != null &&
        _extractCookingTime(recipe.cookingTime!) > maxCookingTimeMinutes) {
      return false;
    }

    // Paso 5: filtrar por dificultad (opcional)
    if (preferredDifficulty != null &&
        recipe.difficulty?.toLowerCase() != preferredDifficulty.toLowerCase()) {
      return false;
    }

    return true;
  }).toList();
}

// Helper para extraer minutos de string "25 min" o "1h 20m"
int _extractCookingTime(String cookingTime) {
  final regex = RegExp(r'(\d+)\s*(h|hour|hours|m|min|minutes)?', caseSensitive: false);
  final matches = regex.allMatches(cookingTime);

  int totalMinutes = 0;

  for (final match in matches) {
    final value = int.tryParse(match.group(1) ?? '') ?? 0;
    final unit = match.group(2)?.toLowerCase() ?? '';

    if (unit.contains('h')) {
      totalMinutes += value * 60;
    } else {
      totalMinutes += value;
    }
  }
  return totalMinutes;
}