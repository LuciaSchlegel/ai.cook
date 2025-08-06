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
          final lowerProperty = selectedProperty.toLowerCase();

          if (userIng.ingredient != null) {
            final ingredient = userIng.ingredient!;
            switch (lowerProperty) {
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
            return userIng.customIngredient!.dietaryTags.any(
              (tag) => tag.name.toLowerCase() == lowerProperty,
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
