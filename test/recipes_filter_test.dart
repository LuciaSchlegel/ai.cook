import 'package:flutter_test/flutter_test.dart';
import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:ai_cook_project/models/recipe_ingredient_model.dart';
import 'package:ai_cook_project/models/recipe_model.dart';
import 'package:ai_cook_project/models/recipe_tag_model.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/models/user_ing.dart';

// Importa tu función
import 'package:ai_cook_project/utils/recipes_filter.dart';

void main() {
  // Units
  final gramUnit = Unit(id: 1, name: 'Gram', abbreviation: 'g', type: 'weight');
  final pieceUnit = Unit(
    id: 2,
    name: 'Piece',
    abbreviation: 'pcs',
    type: 'count',
  );

  // Ingredients
  final chicken = Ingredient(
    id: 1,
    name: 'Chicken',
    isVegan: false,
    isVegetarian: false,
    isGlutenFree: true,
    isLactoseFree: true,
    category: null,
    tags: [],
  );

  final rice = Ingredient(
    id: 2,
    name: 'Rice',
    isVegan: true,
    isVegetarian: true,
    isGlutenFree: true,
    isLactoseFree: true,
    category: null,
    tags: [],
  );

  final tofu = Ingredient(
    id: 3,
    name: 'Tofu',
    isVegan: true,
    isVegetarian: true,
    isGlutenFree: true,
    isLactoseFree: true,
    category: null,
    tags: [],
  );

  // User ingredients (base)
  final baseUserIngredients = [
    UserIng(
      id: 1,
      uid: 'user1',
      ingredient: chicken,
      customIngredient: null,
      quantity: 300,
      unit: gramUnit,
    ),
    UserIng(
      id: 2,
      uid: 'user1',
      ingredient: rice,
      customIngredient: null,
      quantity: 200,
      unit: gramUnit,
    ),
  ];

  // Recipes
  final chickenRiceRecipe = Recipe(
    id: 1,
    name: 'Chicken Rice Bowl',
    description: 'Delicious high protein bowl',
    createdByUid: 'user1',
    ingredients: [
      RecipeIngredient(ingredient: chicken, quantity: 250, unit: gramUnit),
      RecipeIngredient(ingredient: rice, quantity: 150, unit: gramUnit),
    ],
    steps: ['Cook rice', 'Grill chicken', 'Combine and serve'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    image: null,
    cookingTime: '30 min',
    difficulty: 'Easy',
    servings: 2,
    tags: [RecipeTag(id: 1, name: 'high protein')],
  );

  final tofuRiceRecipe = Recipe(
    id: 2,
    name: 'Vegan Tofu Rice Bowl',
    description: 'Plant-based bowl',
    createdByUid: 'user2',
    ingredients: [
      RecipeIngredient(ingredient: tofu, quantity: 200, unit: gramUnit),
      RecipeIngredient(ingredient: rice, quantity: 150, unit: gramUnit),
    ],
    steps: ['Cook rice', 'Fry tofu', 'Combine and serve'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    image: null,
    cookingTime: '25 min',
    difficulty: 'Medium',
    servings: 2,
    tags: [RecipeTag(id: 2, name: 'vegan')],
  );

  final allRecipes = [chickenRiceRecipe, tofuRiceRecipe];

  group('recommendRecipes', () {
    test('returns recipe when all conditions match', () {
      final recommended = recommendRecipes(
        allRecipes: allRecipes,
        userIngredients: baseUserIngredients,
        minMatchRatio: 0.5,
        preferredTags: ['high protein'],
        maxCookingTimeMinutes: 40,
        preferredDifficulty: 'Easy',
      );

      expect(recommended.length, 1);
      expect(recommended.first.name, 'Chicken Rice Bowl');
    });

    test('returns empty when insufficient quantity', () {
      final fewChicken = [
        UserIng(
          id: 1,
          uid: 'user1',
          ingredient: chicken,
          customIngredient: null,
          quantity: 100, // Not enough
          unit: gramUnit,
        ),
        baseUserIngredients[1], // Rice
      ];

      final recommended = recommendRecipes(
        allRecipes: allRecipes,
        userIngredients: fewChicken,
        minMatchRatio: 0.5,
        preferredTags: ['high protein'],
        maxCookingTimeMinutes: 40,
        preferredDifficulty: 'Easy',
      );

      expect(recommended.isEmpty, true);
    });

    test('returns empty when tag does not match', () {
      final recommended = recommendRecipes(
        allRecipes: allRecipes,
        userIngredients: baseUserIngredients,
        minMatchRatio: 0.5,
        preferredTags: ['low carb'], // No recipe has this tag
        maxCookingTimeMinutes: 40,
        preferredDifficulty: 'Easy',
      );

      expect(recommended.isEmpty, true);
    });

    test('returns empty when cooking time too high', () {
      final recommended = recommendRecipes(
        allRecipes: allRecipes,
        userIngredients: baseUserIngredients,
        minMatchRatio: 0.5,
        preferredTags: ['high protein'],
        maxCookingTimeMinutes: 10, // Too strict
        preferredDifficulty: 'Easy',
      );

      expect(recommended.isEmpty, true);
    });

    test('returns empty when difficulty does not match', () {
      final recommended = recommendRecipes(
        allRecipes: allRecipes,
        userIngredients: baseUserIngredients,
        minMatchRatio: 0.5,
        preferredTags: ['high protein'],
        maxCookingTimeMinutes: 40,
        preferredDifficulty: 'Hard', // No recipe is hard
      );

      expect(recommended.isEmpty, true);
    });

    test('returns vegan recipe when ingredients and tag match', () {
      final veganUserIngredients = [
        UserIng(
          id: 2,
          uid: 'user1',
          ingredient: rice,
          customIngredient: null,
          quantity: 300,
          unit: gramUnit,
        ),
        UserIng(
          id: 3,
          uid: 'user1',
          ingredient: tofu,
          customIngredient: null,
          quantity: 300,
          unit: gramUnit,
        ),
      ];

      final recommended = recommendRecipes(
        allRecipes: allRecipes,
        userIngredients: veganUserIngredients,
        minMatchRatio: 0.5,
        preferredTags: ['vegan'],
        maxCookingTimeMinutes: 30,
        preferredDifficulty: 'Medium',
      );

      expect(recommended.length, 1);
      expect(recommended.first.name, 'Vegan Tofu Rice Bowl');
    });

    test('returns multiple recipes when no strict preferences', () {
      final recommended = recommendRecipes(
        allRecipes: allRecipes,
        userIngredients: [
          ...baseUserIngredients,
          UserIng(
            id: 3,
            uid: 'user1',
            ingredient: tofu,
            customIngredient: null,
            quantity: 300,
            unit: gramUnit,
          ),
        ],
        minMatchRatio: 0.5,
        preferredTags: [],
        maxCookingTimeMinutes: 60,
        preferredDifficulty: null,
      );

      expect(recommended.length, 2);
    });

    // Nuevos tests para verificar la lógica mejorada
    test('returns recipe when user has exactly enough ingredients', () {
      final exactIngredients = [
        UserIng(
          id: 1,
          uid: 'user1',
          ingredient: chicken,
          customIngredient: null,
          quantity: 250, // Exact amount needed
          unit: gramUnit,
        ),
        UserIng(
          id: 2,
          uid: 'user1',
          ingredient: rice,
          customIngredient: null,
          quantity: 150, // Exact amount needed
          unit: gramUnit,
        ),
      ];

      final recommended = recommendRecipes(
        allRecipes: allRecipes,
        userIngredients: exactIngredients,
        minMatchRatio: 0.5,
        preferredTags: ['high protein'],
        maxCookingTimeMinutes: 40,
        preferredDifficulty: 'Easy',
      );

      expect(recommended.length, 1);
      expect(recommended.first.name, 'Chicken Rice Bowl');
    });

    test('returns empty when units are incompatible', () {
      final incompatibleUnits = [
        UserIng(
          id: 1,
          uid: 'user1',
          ingredient: chicken,
          customIngredient: null,
          quantity: 300,
          unit: pieceUnit, // Incompatible with gram
        ),
        UserIng(
          id: 2,
          uid: 'user1',
          ingredient: rice,
          customIngredient: null,
          quantity: 200,
          unit: gramUnit,
        ),
      ];

      final recommended = recommendRecipes(
        allRecipes: allRecipes,
        userIngredients: incompatibleUnits,
        minMatchRatio: 0.5,
        preferredTags: ['high protein'],
        maxCookingTimeMinutes: 40,
        preferredDifficulty: 'Easy',
      );

      expect(recommended.isEmpty, true);
    });

    test('returns recipe when user has more than enough ingredients', () {
      final extraIngredients = [
        UserIng(
          id: 1,
          uid: 'user1',
          ingredient: chicken,
          customIngredient: null,
          quantity: 500, // More than needed
          unit: gramUnit,
        ),
        UserIng(
          id: 2,
          uid: 'user1',
          ingredient: rice,
          customIngredient: null,
          quantity: 300, // More than needed
          unit: gramUnit,
        ),
      ];

      final recommended = recommendRecipes(
        allRecipes: allRecipes,
        userIngredients: extraIngredients,
        minMatchRatio: 0.5,
        preferredTags: ['high protein'],
        maxCookingTimeMinutes: 40,
        preferredDifficulty: 'Easy',
      );

      expect(recommended.length, 1);
      expect(recommended.first.name, 'Chicken Rice Bowl');
    });

    test('handles missing units gracefully', () {
      final ingredientsWithoutUnits = [
        UserIng(
          id: 1,
          uid: 'user1',
          ingredient: chicken,
          customIngredient: null,
          quantity: 300,
          unit: null, // Missing unit
        ),
        UserIng(
          id: 2,
          uid: 'user1',
          ingredient: rice,
          customIngredient: null,
          quantity: 200,
          unit: gramUnit,
        ),
      ];

      final recommended = recommendRecipes(
        allRecipes: allRecipes,
        userIngredients: ingredientsWithoutUnits,
        minMatchRatio: 0.5,
        preferredTags: ['high protein'],
        maxCookingTimeMinutes: 40,
        preferredDifficulty: 'Easy',
      );

      expect(recommended.isEmpty, true);
    });
  });
}
