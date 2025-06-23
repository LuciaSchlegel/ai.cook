import 'package:ai_cook_project/models/ingredient_model.dart';

List<Ingredient> filterIngredients({
  required List<Ingredient> globalIngredients,
  required String selectedCategory,
  required String searchText,
}) {
  final filteredIngredients =
      selectedCategory == 'All'
          ? globalIngredients
          : globalIngredients
              .where(
                (ing) =>
                    ing.category!.name.toLowerCase() ==
                    selectedCategory.toLowerCase(),
              )
              .toList();

  final searchFilteredIngredients =
      searchText.isEmpty
          ? filteredIngredients
          : filteredIngredients
              .where((ing) => ing.name.toLowerCase().contains(searchText))
              .toList();
  return searchFilteredIngredients;
}
