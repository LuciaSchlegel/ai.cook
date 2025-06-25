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

      // Permitir tanto objeto como solo id (para compatibilidad)
      CustomIngredient? customIngredient;
      if (json['custom_ingredient'] != null) {
        if (json['custom_ingredient'] is Map<String, dynamic> &&
            (json['custom_ingredient'] as Map<String, dynamic>).containsKey(
              'name',
            )) {
          customIngredient = CustomIngredient.fromJson(
            json['custom_ingredient'] as Map<String, dynamic>,
          );
        } else if (json['custom_ingredient'] is Map<String, dynamic> &&
            (json['custom_ingredient'] as Map<String, dynamic>).containsKey(
              'id',
            )) {
          // Solo id, crear dummy
          customIngredient = CustomIngredient(
            id: (json['custom_ingredient']['id'] as int?) ?? -1,
            name: '',
            category: null,
            tags: [],
            uid: '',
          );
        }
      } else {
        customIngredient = null;
      }

      return UserIng(
        id: json['id'] as int,
        uid: uid,
        ingredient:
            json['ingredient'] != null
                ? Ingredient.fromJson(
                  json['ingredient'] as Map<String, dynamic>,
                )
                : null,
        customIngredient: customIngredient,
        quantity: json['quantity'] as int? ?? 0,
        unit: unit,
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': {'uid': uid},
      'ingredient': ingredient?.toJson(),
      'custom_ingredient': customIngredient?.toJson(),
      'quantity': quantity,
      'unit': unit?.toJson(),
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
