import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../../theme.dart';
import 'package:ai_cook_project/models/ext_recipe_prev.dart';
import 'package:ai_cook_project/providers/api_rec_provider.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:ai_cook_project/widgets/dropdown_selector.dart';
import 'package:ai_cook_project/screens/recipes/widgets/recipe_image.dart';

class AddExtRecipe extends StatefulWidget {
  const AddExtRecipe({super.key});

  @override
  State<AddExtRecipe> createState() => _AddExtRecipeState();
}

class _AddExtRecipeState extends State<AddExtRecipe> {
  String selectedTag = 'All';
  final searchController = TextEditingController();
  final selectedRecipes = <ExternalRecipePreview>[];
  String selectedIngredient = 'All';

  @override
  Widget build(BuildContext context) {
    final extRecProvider = Provider.of<ExtRecipesProvider>(
      context,
      listen: false,
    );
    final resourceProvider = Provider.of<ResourceProvider>(
      context,
      listen: false,
    );
    final ingredientsProvider = Provider.of<IngredientsProvider>(
      context,
      listen: false,
    );
    final allRecipes = extRecProvider.extRecipes;
    final tagNames = ['All', ...resourceProvider.recipeTags.map((t) => t.name)];
    final searchText = searchController.text.toLowerCase();

    // Dropdown options for user ingredients
    final userIngredients = ingredientsProvider.userIngredients;
    final ingredientNames = [
      'All',
      ...userIngredients
          .map((u) => u.ingredient?.name ?? u.customIngredient?.name ?? '')
          .where((name) => name.isNotEmpty),
    ];

    // Filtrado por tag y búsqueda
    List<ExternalRecipePreview> filteredRecipes = allRecipes;
    if (selectedTag != 'All') {
      filteredRecipes =
          filteredRecipes
              .where((r) => (r.dishTypes ?? []).contains(selectedTag))
              .toList();
    }
    if (searchText.isNotEmpty) {
      filteredRecipes =
          filteredRecipes
              .where((r) => (r.title ?? '').toLowerCase().contains(searchText))
              .toList();
    }

    return Dialog(
      backgroundColor: CupertinoColors.systemGrey6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add Recipe',
              style: TextStyle(
                color: AppColors.button,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Casta',
              ),
            ),
            const SizedBox(height: 16),
            // Dropdown for filtering by cupboard ingredient
            DropdownSelector(
              value: selectedIngredient,
              items: ingredientNames,
              onChanged: (value) async {
                if (value == null) return;
                setState(() {
                  selectedIngredient = value;
                });
                if (value == 'All') {
                  // Optionally, reload all recipes or do nothing
                } else {
                  await extRecProvider.searchRecipesByIngredients(
                    ingredients: [value],
                  );
                  setState(() {});
                }
              },
              width: double.infinity,
            ),
            const SizedBox(height: 16),
            CupertinoTextField(
              controller: searchController,
              placeholder: 'Search recipes...',
              prefix: const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(
                  CupertinoIcons.search,
                  color: AppColors.button,
                  size: 20,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tagNames.length,
                itemBuilder: (context, index) {
                  final tag = tagNames[index];
                  final selected = tag == selectedTag;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => setState(() => selectedTag = tag),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              selected
                                  ? AppColors.mutedGreen
                                  : AppColors.mutedGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            color:
                                selected
                                    ? AppColors.white
                                    : AppColors.button.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.3,
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child:
                    filteredRecipes.isEmpty
                        ? const Center(
                          child: Text(
                            'No recipes found',
                            style: TextStyle(
                              color: AppColors.button,
                              fontFamily: 'Casta',
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                        : ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe = filteredRecipes[index];
                            final isSelected = selectedRecipes.any(
                              (r) => r.id == recipe.id,
                            );
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedRecipes.removeWhere(
                                      (r) => r.id == recipe.id,
                                    );
                                  } else {
                                    selectedRecipes.add(recipe);
                                  }
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? AppColors.mutedGreen.withOpacity(
                                            0.12,
                                          )
                                          : CupertinoColors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? AppColors.mutedGreen
                                            : AppColors.button.withOpacity(
                                              0.15,
                                            ),
                                    width: isSelected ? 2 : 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.button.withOpacity(0.04),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: SizedBox(
                                          width: 70,
                                          height: 70,
                                          child: RecipeImage(
                                            imageUrl: recipe.image,
                                            width: 70,
                                            height: 70,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                recipe.title ?? '',
                                                style: const TextStyle(
                                                  fontFamily: 'Casta',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.button,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 6),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    CupertinoIcons.time,
                                                    size: 15,
                                                    color: AppColors.mutedGreen,
                                                  ),
                                                  const SizedBox(width: 3),
                                                  Text(
                                                    recipe.readyInMinutes !=
                                                            null
                                                        ? '${recipe.readyInMinutes} min'
                                                        : 'N/A',
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          AppColors.mutedGreen,
                                                      fontFamily: 'Inter',
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  const Icon(
                                                    CupertinoIcons.star,
                                                    size: 15,
                                                    color: AppColors.mutedGreen,
                                                  ),
                                                  const SizedBox(width: 3),
                                                  Text(
                                                    'Easy',
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          AppColors.mutedGreen,
                                                      fontFamily: 'Inter',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ),
            const SizedBox(height: 24),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              color:
                  selectedRecipes.isNotEmpty
                      ? AppColors.button
                      : AppColors.button.withOpacity(0.4),
              borderRadius: BorderRadius.circular(18),
              onPressed:
                  selectedRecipes.isNotEmpty
                      ? () async {
                        // Aquí deberías agregar la lógica para agregar la receta seleccionada a tu modelo/BD
                        if (context.mounted) Navigator.pop(context);
                      }
                      : null,
              child: const Text(
                'Add Selected',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
