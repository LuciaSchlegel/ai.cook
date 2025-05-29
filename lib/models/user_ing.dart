import 'package:ai_cook_project/models/custom_ing_model.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/models/ingredient_model.dart';

class UserIng {
  final int id;
  final int userId;
  final Ingredient? ingredient;
  final CustomIngredient? customIngredient;
  final int quantity;
  final Unit? unit;

  UserIng({
    required this.id,
    required this.userId,
    this.ingredient,
    this.customIngredient,
    required this.quantity,
    this.unit,
  });

  // Convenience getters to access ingredient properties regardless of type
  String get name => ingredient?.name ?? customIngredient?.name ?? 'Unknown';
  String? get category => ingredient?.category ?? customIngredient?.category;
  List<String>? get tags => ingredient?.tags ?? customIngredient?.tags;

  factory UserIng.fromJson(Map<String, dynamic> json) {
    return UserIng(
      id: json['id'],
      userId: json['user']['id'],
      ingredient:
          json['ingredient'] != null
              ? Ingredient.fromJson(json['ingredient'])
              : null,
      customIngredient:
          json['customIngredient'] != null
              ? CustomIngredient.fromJson(json['customIngredient'])
              : null,
      quantity: json['quantity'],
      unit:
          json['unit'] != null
              ? Unit.values.byName(json['unit'].toLowerCase())
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'ingredient': ingredient?.toJson(),
      'customIngredient': customIngredient?.toJson(),
      'quantity': quantity,
      'unit': unit?.label,
    };
  }
}

// You might want to create a separate file for this
