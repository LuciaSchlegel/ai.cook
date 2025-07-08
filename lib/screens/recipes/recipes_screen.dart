import 'package:ai_cook_project/screens/recipes/widgets/recipe_card.dart';
import 'package:ai_cook_project/widgets/floating_add_button.dart';
import 'package:ai_cook_project/widgets/grey_card_chips.dart';
import 'package:ai_cook_project/widgets/loading_indicator.dart';
import 'package:ai_cook_project/widgets/screen_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/recipe_model.dart';
import '../../providers/recipes_provider.dart';
import '../../providers/resource_provider.dart';
import '../../providers/ingredients_provider.dart';
import '../../dialogs/recipes/add_ext_recipe.dart';
import 'logic/recipes_logic.dart';

class RecipesScreen extends StatefulWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onFeedTap;
  final VoidCallback? onLogoutTap;

  const RecipesScreen({
    super.key,
    this.onProfileTap,
    this.onFeedTap,
    this.onLogoutTap,
  });

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  String selectedFilter = 'All Recipes';
  final List<String> filterOptions = [
    'All Recipes',
    'Available',
    'Missing Ingredients',
  ];

  String selectedTag = 'All';

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<RecipesProvider>(context, listen: false).getRecipes(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final resourceProvider = Provider.of<ResourceProvider>(context);
    final tagNames = ['All', ...resourceProvider.recipeTags.map((t) => t.name)];
    final ingredientsProvider = Provider.of<IngredientsProvider>(
      context,
      listen: false,
    );

    void onSelected(String tag) {
      setState(() {
        selectedTag = tag;
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              onProfileTap: widget.onProfileTap ?? () {},
              onFeedTap: widget.onFeedTap ?? () {},
              onLogoutTap: widget.onLogoutTap ?? () {},
              currentIndex: 0,
            ),
            SizedBox(height: screenHeight * 0.03),
            ChipsDropdownCard(
              dropdownValue: selectedFilter,
              dropdownItems: filterOptions,
              onDropdownChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedFilter = value;
                  });
                }
              },
              chipsItems: tagNames,
              chipsSelectedItem: selectedTag,
              onChipSelected: onSelected,
            ),
            Expanded(
              child: Consumer<RecipesProvider>(
                builder: (context, recipesProvider, child) {
                  if (recipesProvider.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Error:  [38;5;9m${recipesProvider.error} [0m',
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => recipesProvider.getRecipes(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (recipesProvider.isLoading) {
                    return Center(child: LoadingIndicator());
                  }

                  // --- FILTRADO SOLO POR INGREDIENTES DISPONIBLES ---
                  final userIngredients = ingredientsProvider.userIngredients;
                  final allRecipes = recipesProvider.recipes;
                  List<Recipe> recipes;
                  if (selectedFilter == 'Available') {
                    recipes = filterByAvailableIngredients(
                      allRecipes,
                      userIngredients,
                    );
                  } else if (selectedFilter == 'Missing Ingredients') {
                    recipes = filterByMissingIngredients(
                      allRecipes,
                      userIngredients,
                    );
                  } else {
                    recipes = allRecipes;
                  }
                  // Aplicar filtro de tags si corresponde
                  if (selectedTag != 'All' && selectedFilter != 'Recommended') {
                    recipes = filterByTags(recipes, [selectedTag]);
                  }
                  // --- FIN FILTRADO ---

                  if (recipes.isEmpty) {
                    String message = 'No recipes found';
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text(message, textAlign: TextAlign.center)],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      return RecipeCard(
                        key: ValueKey(recipes[index].id),
                        recipe: recipes[index],
                        userIngredients:
                            Provider.of<IngredientsProvider>(
                              context,
                              listen: false,
                            ).userIngredients,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingAddButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddExtRecipe(),
          );
        },
        heroTag: 'add_button_recipes',
      ),
    );
  }
}
