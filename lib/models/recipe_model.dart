import 'package:ai_cook_project/models/ingredient_model.dart';

class Recipe {
  final int id;
  final String name;
  final String description;
  final int createdByUserId;
  final List<Ingredient> ingredients;
  final List<String> steps;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? imageUrl;

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
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      createdByUserId: json['created_by_user_id'] as int,
      ingredients:
          (json['ingredients'] as List<dynamic>)
              .map((e) => Ingredient.fromJson(e))
              .toList(),
      steps: (json['steps'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      imageUrl: json['image_url'] as String?,
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
    };
  }
}
