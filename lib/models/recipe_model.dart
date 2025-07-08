import 'package:ai_cook_project/models/recipe_ingredient_model.dart';
import 'package:ai_cook_project/models/recipe_tag_model.dart';
import '../models/user_ing.dart';

class Recipe {
  final int id;
  final String name;
  final String description;
  final String? createdByUid;
  final List<RecipeIngredient> ingredients;
  final List<String> steps;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? image;
  final String? cookingTime;
  final String? difficulty;
  final int? servings;
  final List<RecipeTag> tags;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    this.createdByUid,
    required this.ingredients,
    required this.steps,
    required this.createdAt,
    required this.updatedAt,
    this.image,
    this.cookingTime,
    this.difficulty,
    this.servings,
    required this.tags,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    try {
      return Recipe(
        id: json['id'] as int,
        name: json['name'] as String,
        description: json['description'] as String,
        createdByUid:
            json['createdByUser'] is Map<String, dynamic>
                ? json['createdByUser']['uid'] as String?
                : json['createdByUser'] as String?,
        ingredients:
            (json['ingredients'] as List<dynamic>?)?.map((e) {
              try {
                return RecipeIngredient.fromJson(e);
              } catch (err) {
                rethrow;
              }
            }).toList() ??
            [],
        steps:
            (json['steps'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        image: json['image'] as String?,
        cookingTime: json['cookingTime'] as String?,
        difficulty: json['difficulty'] as String?,
        servings:
            json['servings'] is int
                ? json['servings'] as int
                : int.tryParse(json['servings']?.toString() ?? ''),
        tags:
            (json['tags'] as List<dynamic>?)?.map((e) {
              try {
                return RecipeTag.fromJson(e);
              } catch (err) {
                rethrow;
              }
            }).toList() ??
            [],
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdByUser': createdByUid,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'steps': steps,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'image': image,
      'cookingTime': cookingTime,
      'difficulty': difficulty,
      'servings': servings,
      'tags': tags.map((e) => e.toJson()).toList(),
    };
  }

  List<RecipeIngredient> getMissingIngredients(List<UserIng> userIngredients) {
    return ingredients
        .where(
          (recipeIng) =>
              !userIngredients.any(
                (userIng) => userIng.ingredient?.id == recipeIng.ingredient.id,
              ),
        )
        .toList();
  }

  /// Devuelve la cantidad de advertencias por incompatibilidad de unidades entre los ingredientes del usuario y los de la receta.
  int getUnitWarnings(List<UserIng> userIngredients) {
    int warnings = 0;
    for (final recipeIng in ingredients) {
      final userIng = userIngredients.firstWhere(
        (ui) => ui.ingredient?.id == recipeIng.ingredient.id,
        orElse: () => UserIng(id: -1, uid: '', quantity: 0),
      );
      if (userIng.ingredient == null)
        continue; // No está, no cuenta como warning de unidad
      if (userIng.unit == null || recipeIng.unit == null) continue;
      if (!userIng.unit!.isCompatibleWith(recipeIng.unit!)) {
        warnings++;
      }
    }
    return warnings;
  }
}
