import 'package:ai_cook_project/models/user_ing.dart';

List<UserIng> filterUserIngredients({
  required List<UserIng> allIngredients,
  required String selectedCategory,
  required String selectedProperty,
  required String searchText,
}) {
  return allIngredients.where((userIng) {
    print('Filtering: ${userIng.customIngredient?.name}');
    print('Tags: ${userIng.customIngredient?.tags?.map((t) => t.name)}');
    print('Category: ${userIng.customIngredient?.category?.name}');
    final ingredientName =
        userIng.ingredient?.name ?? userIng.customIngredient?.name;
    final ingredientCategory =
        userIng.ingredient?.category?.name ??
        userIng.customIngredient?.category?.name;
    final ingredientTags =
        userIng.ingredient?.tags ?? userIng.customIngredient?.tags;

    final matchesCategory =
        selectedCategory == 'All' || ingredientCategory == selectedCategory;

    final matchesProperty =
        selectedProperty == 'All' ||
        (ingredientTags?.any(
              (tag) => tag.name.toLowerCase() == selectedProperty.toLowerCase(),
            ) ??
            false);

    final matchesSearch =
        ingredientName?.toLowerCase().contains(searchText.toLowerCase()) ??
        false;

    return matchesCategory && matchesProperty && matchesSearch;
  }).toList();
}
