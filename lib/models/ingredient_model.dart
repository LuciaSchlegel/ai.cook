import 'package:ai_cook_project/models/tag_model.dart';
import 'package:ai_cook_project/models/category_model.dart' as model;
import 'package:flutter/foundation.dart';

class Ingredient {
  final int id;
  final String name;
  final bool isVegan;
  final bool isVegetarian;
  final bool isGlutenFree;
  final bool isLactoseFree;
  final model.Category? category;
  final List<Tag>? tags;

  Ingredient({
    required this.id,
    required this.name,
    required this.isVegan,
    required this.isVegetarian,
    required this.isGlutenFree,
    required this.isLactoseFree,
    this.category,
    this.tags,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    try {
      return Ingredient(
        id: json['id'] as int,
        name: json['name']?.toString() ?? '',
        isVegan: json['isVegan'] ?? false,
        isVegetarian: json['isVegetarian'] ?? false,
        isGlutenFree: json['isGlutenFree'] ?? false,
        isLactoseFree: json['isLactoseFree'] ?? false,
        category:
            json['category'] != null
                ? model.Category.fromJson(json['category'])
                : null,
        tags:
            (json['tags'] as List<dynamic>?)
                ?.map((e) => Tag.fromJson(e))
                .toList() ??
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
      'is_vegan': isVegan,
      'is_vegetarian': isVegetarian,
      'is_gluten_free': isGlutenFree,
      'is_lactose_free': isLactoseFree,
      'category': category?.toJson(),
      'tags': tags?.map((tag) => tag.toJson()).toList(),
    };
  }
}
