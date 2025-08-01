import 'package:ai_cook_project/models/user_ing.dart';

List<UserIng> filterUserIngredients({
  required List<UserIng> allIngredients,
  required String selectedCategory,
  required List<String> selectedProperties,
  required String searchText,
}) {
  return allIngredients.where((userIng) {
    final ingredientName =
        userIng.ingredient?.name ?? userIng.customIngredient?.name;
    final ingredientCategory =
        userIng.ingredient?.category?.name ??
        userIng.customIngredient?.category?.name;
    final matchesCategory =
        selectedCategory == 'All' || ingredientCategory == selectedCategory;

    final matchesProperties =
        selectedProperties.isEmpty ||
        selectedProperties.every((selectedProperty) {
          // Check dietary flags for both regular and custom ingredients
          if (userIng.ingredient != null) {
            // Regular ingredient - check boolean dietary flags
            final ingredient = userIng.ingredient!;
            switch (selectedProperty.toLowerCase()) {
              case 'vegan':
                return ingredient.isVegan;
              case 'vegetarian':
                return ingredient.isVegetarian;
              case 'gluten-free':
                return ingredient.isGlutenFree;
              case 'lactose-free':
                return ingredient.isLactoseFree;
              default:
                return false;
            }
          } else if (userIng.customIngredient != null) {
            // Custom ingredient - check tags for dietary restrictions
            final tags = userIng.customIngredient?.tags ?? [];
            return tags.any(
              (tag) => tag.name.toLowerCase() == selectedProperty.toLowerCase(),
            );
          }
          return false;
        });

    final matchesSearch =
        ingredientName?.toLowerCase().contains(searchText.toLowerCase()) ??
        false;

    return matchesCategory && matchesProperties && matchesSearch;
  }).toList();
}
