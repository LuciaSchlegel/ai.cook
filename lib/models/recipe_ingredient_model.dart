import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:ai_cook_project/models/unit.dart';

class RecipeIngredient {
  final Ingredient ingredient;
  final double quantity;
  final Unit? unit;

  RecipeIngredient({
    required this.ingredient,
    required this.quantity,
    this.unit,
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    try {
      return RecipeIngredient(
        ingredient: Ingredient.fromJson(json['ingredient']),
        quantity: (json['quantity'] as num).toDouble(),
        unit: json['unit'] != null ? Unit.fromJson(json['unit']) : null,
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'ingredient': ingredient.toJson(),
      'quantity': quantity,
      'unit': unit?.toJson(),
    };
  }
}
