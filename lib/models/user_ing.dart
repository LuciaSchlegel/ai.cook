import 'package:ai_cook_project/models/custom_ing_model.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/models/ingredient_model.dart';

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
    return UserIng(
      id: json['id'] as int,
      uid: json['uid'] as String,
      ingredient:
          json['ingredient'] != null
              ? Ingredient.fromJson(json['ingredient'])
              : null,
      customIngredient:
          json['customIngredient'] != null
              ? CustomIngredient.fromJson(json['customIngredient'])
              : null,
      quantity: json['quantity'] as int,
      unit: json['unit'] != null ? Unit.fromJson(json['unit']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'ingredient': ingredient?.toJson(),
      'customIngredient': customIngredient?.toJson(),
      'quantity': quantity,
      'unit': unit?.toJson(),
    };
  }
}

// You might want to create a separate file for this
