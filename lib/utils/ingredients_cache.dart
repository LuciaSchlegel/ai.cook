import 'dart:convert';
import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> loadCachedData({
  required String userIngredientsKey,
  required List<UserIng> userIngredients,
  required String globalIngredientsKey,
  required List<Ingredient> ingredients,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();

    final userIngredientsJson = prefs.getString(userIngredientsKey);
    if (userIngredientsJson != null) {
      final List<dynamic> decoded = json.decode(userIngredientsJson);
      userIngredients
        ..clear()
        ..addAll(decoded.map((e) => UserIng.fromJson(e)));
    }

    final globalIngredientsJson = prefs.getString(globalIngredientsKey);
    if (globalIngredientsJson != null) {
      final List<dynamic> decoded = json.decode(globalIngredientsJson);
      ingredients
        ..clear()
        ..addAll(decoded.map((e) => Ingredient.fromJson(e)));
    }
  } catch (e) {}
}

Future<void> saveCachedData({
  required userIngredientsKey,
  required userIngredients,
  required globalIngredientsKey,
  required ingredients,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      userIngredientsKey,
      json.encode(userIngredients.map((e) => e.toJson()).toList()),
    );

    await prefs.setString(
      globalIngredientsKey,
      json.encode(ingredients.map((e) => e.toJson()).toList()),
    );
  } catch (e) {}
}
