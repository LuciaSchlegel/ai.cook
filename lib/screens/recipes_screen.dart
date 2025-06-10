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

  // TODO: Obtener esta lista de la base de datos o del estado de la aplicación
  final List<UserIng> userIngredients = [];

  @override
  Widget build(BuildContext context) {
    final sampleRecipeArray = [
      Recipe(
        id: 1,
        name: 'Pumpkin Risotto',
        description: 'A creamy and delicious pumpkin risotto',
        createdByUid: '1',
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
            ingredient: Ingredient(id: 3, name: 'Onion'),
            quantity: 1,
            unit: Unit.u,
          ),
          RecipeIngredient(
            ingredient: Ingredient(id: 7, name: 'Celery'),
            quantity: 1,
            unit: Unit.u,
          ),
          RecipeIngredient(
            ingredient: Ingredient(id: 8, name: 'Carrot'),
            quantity: 2,
            unit: Unit.u,
          ),
          RecipeIngredient(
            ingredient: Ingredient(id: 9, name: 'Garlic Clove'),
            quantity: 2,
            unit: Unit.u,
          ),
          RecipeIngredient(
            ingredient: Ingredient(id: 4, name: 'Chicken Broth'),
            quantity: 850,
            unit: Unit.u,
          ),
          RecipeIngredient(
            ingredient: Ingredient(id: 5, name: 'Butter'),
            quantity: 100,
            unit: Unit.g,
          ),
          RecipeIngredient(
            ingredient: Ingredient(id: 6, name: 'Parmesan Cheese'),
            quantity: 120,
            unit: Unit.g,
          ),
          RecipeIngredient(
            ingredient: Ingredient(id: 10, name: 'Salt & Pepper'),
            quantity: 1,
            unit: Unit.u,
          ),
        ],
        steps: [
          'Cut the pumpkin into cubes',
          'Cook the rice with broth',
          'Add pumpkin and stir',
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        imageUrl:
            'https://i.pinimg.com/736x/f7/53/06/f753068c0737f8b60a8d82c8d97adf9b.jpg',
        cookingTime: '40min',
        difficulty: 'easy',
        servings: 2,
        tags: [
          RecipeTag(id: 1, name: 'Italian'),
          RecipeTag(id: 2, name: 'Risotto'),
          RecipeTag(id: 3, name: 'Pumpkin'),
        ],
      ),
      Recipe(
        id: 2,
        name: 'Mediterranean Salad',
        description: 'A fresh and healthy mediterranean salad',
        createdByUid: '1',
        ingredients: [
          RecipeIngredient(
            ingredient: Ingredient(id: 4, name: 'tomato'),
            quantity: 2,
            unit: Unit.u,
          ),
          RecipeIngredient(
            ingredient: Ingredient(id: 5, name: 'cucumber'),
            quantity: 1,
            unit: Unit.u,
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
        imageUrl:
            'https://i.pinimg.com/736x/2f/d6/4c/2fd64c07b9860c72bac8a8002fe80d69.jpg',
        cookingTime: '15min',
        difficulty: 'easy',
        servings: 4,
        tags: [
          RecipeTag(id: 4, name: 'Mediterranean'),
          RecipeTag(id: 5, name: 'Salad'),
          RecipeTag(id: 6, name: 'Healthy'),
        ],
      ),
      Recipe(
        id: 3,
        name: 'Chicken Pie',
        description: 'A delicious chicken pie',
        createdByUid: '1',
        ingredients: [
          RecipeIngredient(
            ingredient: Ingredient(id: 7, name: 'chicken'),
            quantity: 500,
            unit: Unit.g,
          ),
          RecipeIngredient(
            ingredient: Ingredient(id: 8, name: 'pie crust'),
            quantity: 1,
            unit: Unit.u,
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
        imageUrl:
            'https://i.pinimg.com/736x/8b/cf/74/8bcf740e981b2a6222fd9e451ec04539.jpg',
        cookingTime: '60min',
        difficulty: 'medium',
        servings: 6,
        tags: [
          RecipeTag(id: 7, name: 'American'),
          RecipeTag(id: 8, name: 'Pie'),
          RecipeTag(id: 9, name: 'Chicken'),
        ],
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
