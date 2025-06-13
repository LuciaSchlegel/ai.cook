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

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
    id: json['id'],
    name: json['name'],
    isVegan: json['is_vegan'] ?? false,
    isVegetarian: json['is_vegetarian'] ?? false,
    isGlutenFree: json['is_gluten_free'] ?? false,
    isLactoseFree: json['is_lactose_free'] ?? false,
    category:
        json['category'] != null ? Category.fromJson(json['category']) : null,
    tags:
        json['tags'] != null
            ? List<Tag>.from(json['tags'].map((x) => Tag.fromJson(x)))
            : [],
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_vegan': isVegan,
      'is_vegetarian': isVegetarian,
      'is_gluten_free': isGlutenFree,
      'is_lactose_free': isLactoseFree,
      'category': category,
      'tags': tags,
    };
  }
}
