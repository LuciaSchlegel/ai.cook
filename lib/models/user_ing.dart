import 'package:ai_cook_project/models/custom_ing_model.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:flutter/foundation.dart';

class UserIng {
  final int id;
  final String uid;
  final Ingredient? ingredient;
  final CustomIngredient? customIngredient;
  final int quantity;
  final Unit? unit;

  UserIng({
    required this.id,
    required this.uid,
    this.ingredient,
    this.customIngredient,
    required this.quantity,
    this.unit,
  });

  factory UserIng.fromJson(Map<String, dynamic> json) {
    try {
      final unit =
          json['unit'] != null
              ? Unit.fromJson(json['unit'] as Map<String, dynamic>)
              : Unit(id: -1, name: 'piece', abbreviation: 'pcs', type: 'count');

      final String uid =
          (json['user']?['uid'] ?? json['uid'])?.toString() ?? '';

      return UserIng(
        id: json['id'] as int,
        uid: uid,
        ingredient:
            json['ingredient'] != null
                ? Ingredient.fromJson(
                  json['ingredient'] as Map<String, dynamic>,
                )
                : null,
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
      'ingredient': ingredient?.toJson(),
      'custom_ingredient':
          customIngredient != null ? {'id': customIngredient!.id} : null,
      'quantity': quantity,
      'unit': unit?.id != null ? {'id': unit!.id} : null,
    };
  }

  UserIng copyWith({
    int? id,
    String? uid,
    Ingredient? ingredient,
    CustomIngredient? customIngredient,
    int? quantity,
    Unit? unit,
  }) {
    return UserIng(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      ingredient: ingredient ?? this.ingredient,
      customIngredient: customIngredient ?? this.customIngredient,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }
}
