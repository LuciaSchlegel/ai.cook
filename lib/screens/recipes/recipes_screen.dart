import 'package:ai_cook_project/screens/recipes/widgets/recipe_card.dart';
import 'package:ai_cook_project/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_ing.dart';
import '../../widgets/dropdown_selector.dart';
import '../../providers/recipes_provider.dart';
import '../../providers/resource_provider.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

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
  final List<UserIng> userIngredients = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<RecipesProvider>(context, listen: false).getRecipes(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resourceProvider = Provider.of<ResourceProvider>(context);
    final tagNames = ['All', ...resourceProvider.recipeTags.map((t) => t.name)];
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: MediaQuery.of(context).size.height * 0.01,
            ),
            child: DropdownSelector(
              value: selectedFilter,
              items: filterOptions,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedFilter = value;
                  });
                }
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: 8,
            ),
            child: Row(
              children:
                  tagNames.map((tag) {
                    final isSelected = selectedTag == tag;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(tag),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            selectedTag = tag;
                          });
                        },
                        selectedColor: Theme.of(context).colorScheme.secondary,
                        checkmarkColor: Colors.white,
                      ),
                    );
                  }).toList(),
            ),
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
                if (selectedTag != 'All') {
                  recipes =
                      recipes
                          .where(
                            (r) => r.tags.any((t) => t.name == selectedTag),
                          )
                          .toList();
                }

                if (recipes.isEmpty) {
                  return const Center(child: Text('No recipes found'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    return RecipeCard(
                      key: ValueKey(recipes[index].id),
                      recipe: recipes[index],
                      userIngredients: userIngredients,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
