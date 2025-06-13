import 'package:ai_cook_project/models/custom_ing_model.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/models/ingredient_model.dart';

class UserIng {
  final int id;
  final String uid;
  final Ingredient ingredient;
  final CustomIngredient? customIngredient;
  final int quantity;
  final Unit? unit;

  UserIng({
    required this.id,
    required this.uid,
    required this.ingredient,
    this.customIngredient,
    required this.quantity,
    this.unit,
  });

  factory UserIng.fromJson(Map<String, dynamic> json) {
    return UserIng(
      id: json['id'] as int,
      uid: json['user']?['uid'] ?? '', // `uid` ahora está dentro de `user`
      ingredient: Ingredient.fromJson(json['ingredient']),
      customIngredient:
          json['custom_ingredient'] != null
              ? CustomIngredient.fromJson(json['custom_ingredient'])
              : null,
      quantity: json['quantity'] as int,
      unit: json['unit'] != null ? Unit.fromJson(json['unit']) : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': {'uid': uid}, // ahora el uid está dentro de "user"
      'ingredient': ingredient.toJson(),
      'custom_ingredient': customIngredient?.toJson(),
      'quantity': quantity,
      'unit': unit?.toJson(),
    };
  }
}
