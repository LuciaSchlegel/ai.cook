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

  // TODO: Obtener esta lista de la base de datos o del estado de la aplicación
  final List<UserIng> userIngredients = [];

  @override
  Widget build(BuildContext context) {
    final sampleRecipeArray = [
      Recipe(
        id: 1,
        name: 'Pumpkin Risotto',
        description: 'A creamy and delicious pumpkin risotto',
        createdByUserId: 1,
        ingredients: [
          RecipeIngredient(
            ingredient: Ingredient(id: 1, name: 'Pumpkin'),
            quantity: 500,
            unit: Unit.g,
          ),
          RecipeIngredient(
            ingredient: Ingredient(id: 2, name: 'Arborio Rice'),
            quantity: 300,
            unit: Unit.g,
          ),
          RecipeIngredient(
            ingredient: Ingredient(id: 3, name: 'Parmesan'),
            quantity: 100,
            unit: Unit.g,
          ),
        ],
        steps: [
          'Cut the pumpkin into cubes',
          'Cook the rice with broth',
          'Add pumpkin and stir',
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        imageUrl: 'https://example.com/pumpkin-risotto.jpg',
        cookingTime: '40min',
        difficulty: 'easy',
        servings: 2,
      ),
      Recipe(
        id: 2,
        name: 'mediterranean salad',
        description: 'A fresh and healthy mediterranean salad',
        createdByUserId: 1,
        ingredients: [
          RecipeIngredient(
            ingredient: Ingredient(id: 4, name: 'tomato'),
            quantity: 2,
            unit: Unit.unit,
          ),
          RecipeIngredient(
            ingredient: Ingredient(id: 5, name: 'cucumber'),
            quantity: 1,
            unit: Unit.unit,
          ),
          RecipeIngredient(
            ingredient: Ingredient(id: 6, name: 'olive oil'),
            quantity: 30,
            unit: Unit.ml,
          ),
        ],
        steps: [
          'Cut the tomato and cucumber into cubes',
          'Add the olive oil and salt',
          'Mix the ingredients',
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        imageUrl: 'https://example.com/mediterranean-salad.jpg',
        cookingTime: '15min',
        difficulty: 'easy',
        servings: 4,
      ),
      Recipe(
        id: 3,
        name: 'Chicken Pie',
        description: 'A delicious chicken pie',
        createdByUserId: 1,
        ingredients: [
          RecipeIngredient(
            ingredient: Ingredient(id: 7, name: 'chicken'),
            quantity: 500,
            unit: Unit.g,
          ),
          RecipeIngredient(
            ingredient: Ingredient(id: 8, name: 'pie crust'),
            quantity: 1,
            unit: Unit.unit,
          ),
          RecipeIngredient(
            ingredient: Ingredient(id: 9, name: 'cheese'),
            quantity: 200,
            unit: Unit.g,
          ),
        ],
        steps: [
          'Cut the chicken into cubes',
          'Add the pie crust and cheese',
          'Bake the pie',
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        imageUrl: 'https://example.com/chicken-pie.jpg',
        cookingTime: '60min',
        difficulty: 'medium',
        servings: 6,
      ),
    ];

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
