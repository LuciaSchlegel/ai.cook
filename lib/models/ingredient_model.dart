import 'package:ai_cook_project/models/recipe_model.dart';
import 'package:ai_cook_project/models/tag_model.dart';
import 'package:ai_cook_project/models/category_model.dart';

class Ingredient {
  final int id;
  final String name;
  final Category? category;
  final List<Tag>? tags;
  final List<Recipe> recipes;
  Ingredient({
    required this.id,
    required this.name,
    this.category,
    this.tags,
    this.recipes = const [],
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'] as int,
      name: json['name'] as String,
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
      tags:
          (json['tags'] as List<dynamic>?)
              ?.map((e) => Tag.fromJson(e))
              .toList(),
      recipes:
          (json['recipes'] as List<dynamic>?)
              ?.map((e) => Recipe.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'tags': tags,
      'recipes': recipes.map((e) => e.toJson()).toList(),
    };
  }
}
