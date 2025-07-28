import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/screens/recipes/widgets/recipe_image.dart';
import 'package:ai_cook_project/screens/recipes/widgets/recipe_ov_card.dart';
import 'package:ai_cook_project/widgets/selectors/chips_dropd_card.dart';
import 'package:ai_cook_project/widgets/buttons/floating_add_button.dart';
import 'package:ai_cook_project/widgets/status/loading_indicator.dart';
import 'package:ai_cook_project/widgets/utils/screen_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/recipe_model.dart';
import '../../providers/recipes_provider.dart';
import '../../providers/resource_provider.dart';
import '../../providers/ingredients_provider.dart';
import '../../dialogs/recipes/add_ext_recipe.dart';
import 'logic/recipes_logic.dart';
import '../../theme.dart';

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

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<RecipesProvider>(context, listen: false).getRecipes(),
    );
  }

  Future<void> _applyFilters() async {
    await filterRecipesLogic(
      context: context,
      selectedFilter: selectedFilter,
      selectedTag: selectedTag,
      maxCookingTimeMinutes: null,
      preferredDifficulty: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final resourceProvider = Provider.of<ResourceProvider>(context);
    final tagNames = ['All', ...resourceProvider.recipeTags.map((t) => t.name)];

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
              onDropdownChanged: (value) async {
                if (value != null) {
                  setState(() {
                    selectedFilter = value;
                  });
                  await _applyFilters();
                }
              },
              chipsItems: tagNames,
              chipsSelectedItem: selectedTag,
              onChipSelected: (tag) async {
                setState(() {
                  selectedTag = tag;
                });
                await _applyFilters();
              },
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
                    return const Center(child: LoadingIndicator());
                  }

                  final recipes = recipesProvider.recipes;

                  if (recipes.isEmpty) {
                    return const Center(
                      child: Text(
                        'No recipes found',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenHeight * 0.025,
                      vertical: screenHeight * 0.01,
                    ),
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: _ContainerRecipeCard(
                          key: ValueKey(recipes[index].id),
                          recipe: recipes[index],
                        ),
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

class _ContainerRecipeCard extends StatefulWidget {
  final Recipe recipe;

  const _ContainerRecipeCard({super.key, required this.recipe});

  @override
  State<_ContainerRecipeCard> createState() => _ContainerRecipeCardState();
}

class _ContainerRecipeCardState extends State<_ContainerRecipeCard> {
  void _showRecipeDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RecipeOverviewCard(recipe: widget.recipe),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ingredientsProvider = Provider.of<IngredientsProvider>(
      context,
      listen: false,
    );

    return GestureDetector(
      onTap: () => _showRecipeDetail(context),
      child: _ContainerRecipeCardContent(
        recipe: widget.recipe,
        userIngredients: ingredientsProvider.userIngredients,
      ),
    );
  }
}

class _ContainerRecipeCardContent extends StatelessWidget {
  final Recipe recipe;
  final List<UserIng> userIngredients;

  const _ContainerRecipeCardContent({
    required this.recipe,
    required this.userIngredients,
  });

  String _getIngredientsStatusText() {
    final missingIngredients = recipe.getMissingIngredients(userIngredients);
    final unitWarnings = recipe.getUnitWarnings(userIngredients);
    if (missingIngredients.isNotEmpty) {
      return '${missingIngredients.length} missing';
    }
    if (unitWarnings > 0) {
      return 'All available ($unitWarnings warning${unitWarnings > 1 ? 's' : ''})';
    }
    return 'All available';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width * 0.24;
    final height = size.width * 0.24;
    final unitWarnings = recipe.getUnitWarnings(userIngredients);
    final missingIngredients = recipe.getMissingIngredients(userIngredients);

    return Card(
      elevation: 2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      color: AppColors.white.withOpacity(0.95),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RecipeImage(imageUrl: recipe.image, width: width, height: height),
            const SizedBox(width: 16),
            Expanded(
              child: _ContainerRecipeDetails(
                recipe: recipe,
                ingredientsStatusText: _getIngredientsStatusText(),
                warning: missingIngredients.isEmpty && unitWarnings > 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContainerRecipeDetails extends StatelessWidget {
  final Recipe recipe;
  final String ingredientsStatusText;
  final bool warning;

  const _ContainerRecipeDetails({
    required this.recipe,
    required this.ingredientsStatusText,
    this.warning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          recipe.name,
          style: const TextStyle(
            fontFamily: 'Casta',
            letterSpacing: 1.2,
            fontSize: 20,
            height: 1.1,
            fontWeight: FontWeight.w600,
            color: AppColors.button,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        _ContainerDetailRow(
          label: 'Est. time: ',
          value: recipe.cookingTime ?? "N/A",
        ),
        _ContainerDetailRow(
          label: 'Difficulty: ',
          value: recipe.difficulty ?? "N/A",
        ),
        _ContainerDetailRow(
          label: 'Ingredients: ',
          value: ingredientsStatusText,
          valueColor:
              warning
                  ? AppColors.orange
                  : (ingredientsStatusText.contains('missing')
                      ? AppColors.orange
                      : AppColors.mutedGreen),
        ),
      ],
    );
  }
}

class _ContainerDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _ContainerDetailRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.button,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.mutedGreen,
            fontFamily: 'Inter',
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: valueColor,
              fontFamily: 'Inter',
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
