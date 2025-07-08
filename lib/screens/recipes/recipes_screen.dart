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
import '../../utils/recipes_filter.dart';

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
    'Recommended',
  ];

  String selectedTag = 'All';
  List<Recipe> recommendedRecipes = [];
  bool isShowingRecommended = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<RecipesProvider>(context, listen: false).getRecipes(),
    );
  }

  void _testRecipeFiltering() {
    final ingredientsProvider = Provider.of<IngredientsProvider>(
      context,
      listen: false,
    );
    final recipesProvider = Provider.of<RecipesProvider>(
      context,
      listen: false,
    );

    final userIngredients = ingredientsProvider.userIngredients;

    if (userIngredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No tienes ingredientes en tu alacena. Agrega algunos ingredientes primero.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final allRecipes = recipesProvider.recipes;

    if (allRecipes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay recipes disponibles.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final recommended = recommendRecipes(
      allRecipes: allRecipes,
      userIngredients: userIngredients,
      minMatchRatio: 0.6,
      preferredTags: selectedTag != 'All' ? [selectedTag] : [],
      maxCookingTimeMinutes: 60,
      preferredDifficulty: null,
    );

    setState(() {
      recommendedRecipes = recommended;
      isShowingRecommended = true;
      selectedFilter = 'Recommended';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          recommended.isEmpty
              ? 'No se encontraron recipes que coincidan con tus ingredientes y preferencias.'
              : 'Se encontraron ${recommended.length} recipes recomendadas basadas en tus ingredientes.',
        ),
        backgroundColor: recommended.isEmpty ? Colors.orange : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final resourceProvider = Provider.of<ResourceProvider>(context);
    final tagNames = ['All', ...resourceProvider.recipeTags.map((t) => t.name)];

    void onSelected(String tag) {
      setState(() {
        selectedTag = tag;
        if (isShowingRecommended) {
          _testRecipeFiltering();
        }
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
                    isShowingRecommended = value == 'Recommended';
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
                            'Error: ${recipesProvider.error}',
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

                  var recipes = recipesProvider.recipes;

                  if (selectedFilter == 'Recommended' && isShowingRecommended) {
                    recipes = recommendedRecipes;
                  } else if (selectedTag != 'All') {
                    recipes =
                        recipes
                            .where(
                              (r) => r.tags.any((t) => t.name == selectedTag),
                            )
                            .toList();
                  }

                  if (recipes.isEmpty) {
                    String message = 'No recipes found';
                    if (selectedFilter == 'Recommended' &&
                        isShowingRecommended) {
                      message =
                          'No se encontraron recipes recomendadas. Intenta con diferentes ingredientes o preferencias.';
                    }
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(message, textAlign: TextAlign.center),
                          if (selectedFilter == 'Recommended') ...[
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _testRecipeFiltering,
                              child: const Text('Probar de nuevo'),
                            ),
                          ],
                        ],
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
