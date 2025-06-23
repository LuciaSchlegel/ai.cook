import 'dart:convert';
import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> loadCachedData({
  required userIngredientsKey,
  required userIngredients,
  required globalIngredientsKey,
  required ingredients,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();

    final userIngredientsJson = prefs.getString(userIngredientsKey);
    if (userIngredientsJson != null) {
      final List<dynamic> decoded = json.decode(userIngredientsJson);
      userIngredients = decoded.map((e) => UserIng.fromJson(e)).toList();
    }

    final globalIngredientsJson = prefs.getString(globalIngredientsKey);
    if (globalIngredientsJson != null) {
      final List<dynamic> decoded = json.decode(globalIngredientsJson);
      ingredients = decoded.map((e) => Ingredient.fromJson(e)).toList();
    }
  } catch (e) {
    debugPrint('Error loading cached data: $e');
  }
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
  } catch (e) {
    debugPrint('Error saving cached data: $e');
  }
}
