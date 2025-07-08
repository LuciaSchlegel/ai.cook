import 'package:ai_cook_project/models/recipe_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';

/// Filtra recetas que el usuario puede preparar con los ingredientes disponibles y cantidades suficientes.
List<Recipe> filterByAvailableIngredients(
  List<Recipe> recipes,
  List<UserIng> userIngredients,
) {
  return recipes.where((recipe) {
    bool allOk = true;
    for (final ri in recipe.ingredients) {
      final userIng = userIngredients.firstWhere(
        (ui) => ui.ingredient?.id == ri.ingredient.id,
        orElse: () => UserIng(id: -1, uid: '', quantity: 0),
      );
      if (userIng.ingredient == null) {
        // DEBUG: No se encontró el ingrediente en userIngredients
        print(
          '[DEBUG] Receta "${recipe.name}": ingrediente faltante: ${ri.ingredient.name} (id: ${ri.ingredient.id})',
        );
        allOk = false;
        break;
      }
      if (userIng.unit == null || ri.unit == null) {
        // Si no hay unidad, no podemos comparar cantidad, pero la receta se muestra igual (warning en la card)
        continue;
      }
      if (!userIng.unit!.isCompatibleWith(ri.unit!)) {
        // Unidades incompatibles: NO descartar, solo warning en la card
        print(
          '[DEBUG] Receta "${recipe.name}": unidades incompatibles: userIng=${userIng.unit!.abbreviation}, receta=${ri.unit!.abbreviation} para ingrediente ${ri.ingredient.name}',
        );
        continue;
      }
      try {
        final userAmountBase = userIng.unit!.convertToBase(
          userIng.quantity.toDouble(),
        );
        final recipeAmountBase = ri.unit!.convertToBase(ri.quantity.toDouble());
        if (userAmountBase < recipeAmountBase) {
          print(
            '[DEBUG] Receta "${recipe.name}": cantidad insuficiente para ${ri.ingredient.name}. Usuario: $userAmountBase, Receta: $recipeAmountBase (base)',
          );
          allOk = false;
          break;
        }
      } catch (e) {
        print(
          '[DEBUG] Receta "${recipe.name}": error en conversión de unidades para ${ri.ingredient.name}: $e',
        );
        allOk = false;
        break;
      }
    }
    if (!allOk) {
      print('[DEBUG] Receta "${recipe.name}" descartada.');
    }
    return allOk;
  }).toList();
}

/// Filtra recetas que requieren al menos un ingrediente que el usuario NO tiene.
List<Recipe> filterByMissingIngredients(
  List<Recipe> recipes,
  List<UserIng> userIngredients,
) {
  return recipes.where((recipe) {
    return recipe.ingredients.any(
      (ri) =>
          !userIngredients.any((ui) => ui.ingredient?.id == ri.ingredient.id),
    );
  }).toList();
}

/// Filtra recetas por tags (preferencias). Si la lista está vacía, no filtra.
List<Recipe> filterByTags(List<Recipe> recipes, List<String> preferredTags) {
  if (preferredTags.isEmpty) return recipes;
  return recipes
      .where(
        (recipe) => recipe.tags.any(
          (tag) => preferredTags.any(
            (pref) => tag.name.toLowerCase() == pref.toLowerCase(),
          ),
        ),
      )
      .toList();
}

/// Filtra recetas por dificultad. Si es null, no filtra.
List<Recipe> filterByDifficulty(List<Recipe> recipes, String? difficulty) {
  if (difficulty == null || difficulty.isEmpty) return recipes;
  return recipes
      .where(
        (recipe) =>
            recipe.difficulty?.toLowerCase() == difficulty.toLowerCase(),
      )
      .toList();
}

/// Filtra recetas por tiempo máximo de preparación (en minutos). Si es null, no filtra.
List<Recipe> filterByCookingTime(List<Recipe> recipes, int? maxMinutes) {
  if (maxMinutes == null) return recipes;
  return recipes.where((recipe) {
    if (recipe.cookingTime == null) return false;
    return _extractCookingTime(recipe.cookingTime!) <= maxMinutes;
  }).toList();
}

/// Extrae minutos de un string como "1h 20m" o "25 min"
int _extractCookingTime(String cookingTime) {
  final regex = RegExp(
    r'(\d+)\s*(h|hour|hours|m|min|minutes)?',
    caseSensitive: false,
  );
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

/// Función principal para filtrar recetas según los criterios seleccionados.
List<Recipe> filterRecipes({
  required List<Recipe> allRecipes,
  required List<UserIng> userIngredients,
  String filter = 'All Recipes',
  List<String> preferredTags = const [],
  int? maxCookingTimeMinutes,
  String? preferredDifficulty,
}) {
  List<Recipe> filtered = allRecipes;
  switch (filter) {
    case 'Available':
      filtered = filterByAvailableIngredients(filtered, userIngredients);
      break;
    case 'Missing Ingredients':
      filtered = filterByMissingIngredients(filtered, userIngredients);
      break;
    // 'Recommended' puede usar lógica especial si se desea
    default:
      // 'All Recipes' no filtra por ingredientes
      break;
  }
  filtered = filterByTags(filtered, preferredTags);
  filtered = filterByDifficulty(filtered, preferredDifficulty);
  filtered = filterByCookingTime(filtered, maxCookingTimeMinutes);
  return filtered;
}
