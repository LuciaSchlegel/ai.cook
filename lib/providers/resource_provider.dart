import 'dart:convert';
import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/models/recipe_tag_model.dart';
import 'package:ai_cook_project/models/dietary_tag_model.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ResourceProvider extends ChangeNotifier {
  bool _initialized = false;
  bool get isInitialized => _initialized;
  List<Unit> _units = [];
  List<Category> _categories = [];
  List<RecipeTag> _recipeTags = [];
  List<DietaryTag> _dietaryTags = [];

  List<Unit> get units => _units;
  List<Category> get categories => _categories;
  List<RecipeTag> get recipeTags => _recipeTags;
  List<DietaryTag> get dietaryTags => _dietaryTags;

  Future<void> initializeResources() async {
    if (_initialized) return;
    await Future.wait([
      getUnits(),
      getCategories(),
      getRecipeTags(),
      getDietaryTags(),
    ]);
    _initialized = true;
    notifyListeners();
  }

  Future<void> getUnits() async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/resources/units'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch units: HTTP ${response.statusCode}');
      }

      final List<dynamic> decoded = json.decode(response.body);
      _units = decoded.map((e) => Unit.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      ('Error fetching units: $e');
    }
  }

  Future<void> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/resources/categories'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to fetch categories: HTTP ${response.statusCode}',
        );
      }

      final List<dynamic> decoded = json.decode(response.body);
      _categories = decoded.map((e) => Category.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      ('Error fetching categories: $e');
    }
  }

  Future<void> getRecipeTags() async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/resources/recipe_tags'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to fetch recipe tags: HTTP ${response.statusCode}',
        );
      }

      final List<dynamic> decoded = json.decode(response.body);
      _recipeTags = decoded.map((e) => RecipeTag.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      ('Error fetching recipe tags: $e');
    }
  }

  Future<void> getDietaryTags() async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/resources/dietary_tags'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch tags: HTTP ${response.statusCode}');
      }

      final List<dynamic> decoded = json.decode(response.body);
      _dietaryTags = decoded.map((e) => DietaryTag.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      ('Error fetching tags: $e');
    }
  }

  /// Extracts unique dietary restrictions from user ingredients
  /// Returns them as a list of strings for filter chips
  List<String> getDietaryFlagsFromIngredients(List<dynamic> userIngredients) {
    final Set<String> dietaryFlags = {};

    for (final userIng in userIngredients) {
      final ingredient = userIng.ingredient;
      final customIngredient = userIng.customIngredient;

      if (ingredient != null) {
        if (ingredient.isVegan) dietaryFlags.add('Vegan');
        if (ingredient.isVegetarian) dietaryFlags.add('Vegetarian');
        if (ingredient.isGlutenFree) dietaryFlags.add('Gluten-Free');
        if (ingredient.isLactoseFree) dietaryFlags.add('Lactose-Free');
      } else if (customIngredient != null) {
        for (final tag in customIngredient.dietaryTags) {
          dietaryFlags.add(tag.name);
        }
      }
    }

    final sortedFlags = dietaryFlags.toList()..sort();
    return sortedFlags;
  }

  // Utility
  void clearAll() {
    _units = [];
    _categories = [];
    _recipeTags = [];
    _dietaryTags = [];
    _initialized = false;
    notifyListeners();
  }
}
