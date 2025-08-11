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

  static int? _parseServings(dynamic value) {
    if (value == null) return null;

    if (value is int) return value;

    if (value is String) {
      // Handle ranges like "2-4" or "2-4 servings"
      if (value.contains('-')) {
        final parts = value.split('-');
        if (parts.isNotEmpty) {
          // Extract just the number part from the first element
          final firstPart = parts[0].trim();
          final match = RegExp(r'\d+').firstMatch(firstPart);
          if (match != null) {
            return int.tryParse(match.group(0)!);
          }
        }
      }

      // Handle "X to Y" format like "4 to 6 servings"
      if (value.toLowerCase().contains(' to ')) {
        final parts = value.toLowerCase().split(' to ');
        if (parts.isNotEmpty) {
          // Extract number from first part
          final match = RegExp(r'\d+').firstMatch(parts[0].trim());
          if (match != null) {
            return int.tryParse(match.group(0)!);
          }
        }
      }

      // Extract any number from the string (handles "4 servings", "24 empanadas", etc.)
      final match = RegExp(r'\d+').firstMatch(value);
      if (match != null) {
        return int.tryParse(match.group(0)!);
      }

      return null;
    }

    // Try to convert other types to string first
    return int.tryParse(value.toString());
  }

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
        servings: _parseServings(json['servings']),
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

  /// Devuelve la cantidad de advertencias por incompatibilidad de unidades entre los ingredientes del usuario y los de la receta.
  int getUnitWarnings(List<UserIng> userIngredients) {
    int warnings = 0;
    for (final recipeIng in ingredients) {
      final userIng = userIngredients.firstWhere(
        (ui) => ui.ingredient?.id == recipeIng.ingredient.id,
        orElse: () => UserIng(id: -1, uid: '', quantity: 0),
      );
      if (userIng.ingredient == null) {
        continue; // No está, no cuenta como warning de unidad
      }
      if (userIng.unit == null || recipeIng.unit == null) continue;
      if (!userIng.unit!.isCompatibleWith(recipeIng.unit!)) {
        warnings++;
      }
    }
    return warnings;
  }

  /// Returns the list of missing ingredients for this recipe based on user's ingredients.
  /// Matches by global ingredient id or, if provided as custom ingredient, by fuzzy name match.
  List<RecipeIngredient> getMissingIngredients(List<UserIng> userIngredients) {
    final List<RecipeIngredient> missing = [];

    for (final recipeIng in ingredients) {
      final recipeName = recipeIng.ingredient.name.toLowerCase().trim();

      final hasIngredient = userIngredients.any((ui) {
        // Match global ingredient by id
        if (ui.ingredient?.id != null &&
            ui.ingredient!.id == recipeIng.ingredient.id) {
          return true;
        }
        // Match custom ingredient by name (exact or partial)
        final customName = ui.customIngredient?.name.toLowerCase().trim();
        if (customName != null && customName.isNotEmpty) {
          if (customName == recipeName) return true;
          if (customName.contains(recipeName) ||
              recipeName.contains(customName))
            return true;
        }
        return false;
      });

      if (!hasIngredient) {
        missing.add(recipeIng);
      }
    }

    return missing;
  }
}
