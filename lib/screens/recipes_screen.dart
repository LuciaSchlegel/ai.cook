import 'package:ai_cook_project/models/recipe_tag_model.dart';
import 'package:ai_cook_project/widgets/recipe_card.dart';
import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../models/ingredient_model.dart';
import '../models/recipe_ingredient_model.dart';
import '../models/user_ing.dart';
import '../models/unit.dart';
import '../widgets/dropdown_selector.dart';

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

  final List<UserIng> userIngredients = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
          Expanded(
            child: ListView.builder(
              itemCount: sampleRecipeArray.length,
              itemBuilder: (context, index) {
                return RecipeCard(
                  recipe: sampleRecipeArray[index],
                  userIngredients: userIngredients,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
