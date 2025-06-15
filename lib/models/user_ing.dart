import 'package:ai_cook_project/models/custom_ing_model.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:flutter/foundation.dart';

class UserIng {
  final int id;
  final String uid;
  final Ingredient ingredient;
  final CustomIngredient? customIngredient;
  final int quantity;
  final Unit unit;

  UserIng({
    required this.id,
    required this.uid,
    required this.ingredient,
    this.customIngredient,
    required this.quantity,
    required this.unit,
  });

  factory UserIng.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw Exception('Invalid JSON data: null');
    }

    // Validate required fields
    if (json['ingredient'] == null) {
      throw Exception('Ingredient data is required');
    }

    try {
      // Create a default unit if none is provided
      final unit =
          json['unit'] != null
              ? Unit.fromJson(json['unit'] as Map<String, dynamic>)
              : Unit(id: -1, name: 'piece', abbreviation: 'pcs', type: 'count');

      return UserIng(
        id: json['id'] as int? ?? -1,
        uid: json['user']?['uid'] as String? ?? '',
        ingredient: Ingredient.fromJson(
          json['ingredient'] as Map<String, dynamic>,
        ),
        customIngredient:
            json['custom_ingredient'] != null
                ? CustomIngredient.fromJson(
                  json['custom_ingredient'] as Map<String, dynamic>,
                )
                : null,
        quantity: json['quantity'] as int? ?? 0,
        unit: unit,
      );
    } catch (e) {
      debugPrint('Error parsing UserIng: $e');
      debugPrint('JSON data: $json');
      rethrow;
    }
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': {'uid': uid},
      'ingredient': ingredient.toJson(),
      'custom_ingredient': customIngredient?.toJson(),
      'quantity': quantity,
      'unit': unit.toJson(),
    };
  }
}
