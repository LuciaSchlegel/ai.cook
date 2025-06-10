import 'package:ai_cook_project/models/recipe_ingredient_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';

class Recipe {
  final int id;
  final String name;
  final String description;
  final int createdByUserId;
  final List<RecipeIngredient> ingredients;
  final List<String> steps;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? imageUrl;
  final String? cookingTime;
  final String? difficulty;
  final int? servings;
  final List<String> tags;
  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.createdByUserId,
    required this.ingredients,
    required this.steps,
    required this.createdAt,
    required this.updatedAt,
    this.imageUrl,
    this.cookingTime,
    this.difficulty,
    this.servings,
    required this.tags,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      createdByUserId: json['created_by_user_id'] as int,
      ingredients:
          (json['ingredients'] as List<dynamic>)
              .map((e) => RecipeIngredient.fromJson(e))
              .toList(),
      steps: (json['steps'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      imageUrl: json['image_url'] as String?,
      cookingTime: json['cooking_time'] as String?,
      difficulty: json['difficulty'] as String?,
      servings: json['servings'] as int?,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_by_user_id': createdByUserId,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'steps': steps,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'image_url': imageUrl,
      'cooking_time': cookingTime,
      'difficulty': difficulty,
      'servings': servings,
      'tags': tags,
    };
  }

  List<RecipeIngredient> getMissingIngredients(List<UserIng> userIngredients) {
    return ingredients.where((recipeIng) {
      // Buscar el ingrediente del usuario que coincida con el de la receta
      final userIng = userIngredients.firstWhere(
        (userIng) =>
            (userIng.ingredient?.id == recipeIng.ingredient.id) ||
            (userIng.customIngredient?.name.toLowerCase() ==
                recipeIng.ingredient.name.toLowerCase()),
        orElse: () => UserIng(id: -1, userId: -1, quantity: 0),
      );

      // Si no se encontró el ingrediente o la cantidad es menor a la requerida
      if (userIng.id == -1 || userIng.quantity < recipeIng.quantity) {
        return true; // Es un ingrediente faltante
      }

      return false; // El usuario tiene suficiente cantidad
    }).toList();
  }
}
