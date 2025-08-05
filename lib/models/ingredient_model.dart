import 'package:ai_cook_project/models/category_model.dart' as model;

class Ingredient {
  final int id;
  final String name;
  final bool isVegan;
  final bool isVegetarian;
  final bool isGlutenFree;
  final bool isLactoseFree;
  final model.Category? category;

  Ingredient({
    required this.id,
    required this.name,
    required this.isVegan,
    required this.isVegetarian,
    required this.isGlutenFree,
    required this.isLactoseFree,
    this.category,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    try {
      return Ingredient(
        id: json['id'] as int,
        name: json['name']?.toString() ?? '',
        isVegan: _parseBool(json['isVegan'] ?? json['is_vegan']),
        isVegetarian: _parseBool(json['isVegetarian'] ?? json['is_vegetarian']),
        isGlutenFree: _parseBool(
          json['isGlutenFree'] ?? json['is_gluten_free'],
        ),
        isLactoseFree: _parseBool(
          json['isLactoseFree'] ?? json['is_lactose_free'],
        ),
        category:
            json['category'] != null
                ? model.Category.fromJson(json['category'])
                : null,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Helper method to parse boolean values from JSON
  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    if (value is int) return value == 1;
    return false;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isVegan': isVegan,
      'isVegetarian': isVegetarian,
      'isGlutenFree': isGlutenFree,
      'isLactoseFree': isLactoseFree,
      'category': category?.toJson(),
    };
  }
}
