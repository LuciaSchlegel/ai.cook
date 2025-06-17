import 'package:ai_cook_project/models/tag_model.dart';
import 'package:ai_cook_project/models/category_model.dart';

class Ingredient {
  final int id;
  final String name;
  final bool isVegan;
  final bool isVegetarian;
  final bool isGlutenFree;
  final bool isLactoseFree;
  final Category? category;
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
    return Ingredient(
      id: json['id'] as int,
      name: json['name']?.toString() ?? '',
      isVegan: json['is_vegan'] ?? json['isVegan'] ?? false,
      isVegetarian: json['is_vegetarian'] ?? json['isVegetarian'] ?? false,
      isGlutenFree: json['is_gluten_free'] ?? json['isGlutenFree'] ?? false,
      isLactoseFree: json['is_lactose_free'] ?? json['isLactoseFree'] ?? false,
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
      tags:
          (json['tags'] as List<dynamic>?)
              ?.map((e) => Tag.fromJson(e))
              .toList() ??
          [],
    );
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
