import 'dart:convert';
import 'package:ai_cook_project/models/recipe_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RecipesProvider extends ChangeNotifier {
  List<Recipe> _recipes = [];
  // Backend-computed missing counts keyed by recipe id
  Map<int, int> _missingCountByRecipe = {};
  bool _isLoading = false;
  String? _error;

  List<Recipe> get recipes => _recipes;
  Map<int, int> get missingCountByRecipe => _missingCountByRecipe;
  int missingCountFor(int recipeId) => _missingCountByRecipe[recipeId] ?? 0;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getRecipes() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/recipes'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> recipesJson = json.decode(response.body);
        _recipes = recipesJson.map((e) => Recipe.fromJson(e)).toList();
      } else {
        _setError(
          'Failed to load recipes. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      _setError('Failed to load recipes: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> filterRecipesFromApi({
    required List<UserIng> userIngredients,
    String filter = 'All Recipes',
    List<String> preferredTags = const [],
    int? maxCookingTimeMinutes,
    String? preferredDifficulty,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final apiUrl = '${dotenv.env['API_URL']}/recipes/filter';

      final body = {
        "userIngredients": userIngredients.map((u) => u.toJson()).toList(),
        "filter": filter,
        "preferredTags": preferredTags,
        "maxCookingTimeMinutes": maxCookingTimeMinutes,
        "preferredDifficulty": preferredDifficulty,
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final List<dynamic> recipesJson = json.decode(response.body);
        _recipes = recipesJson.map((e) => Recipe.fromJson(e)).toList();
        notifyListeners();
      } else {
        _setError(
          'Error filtering recipes. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      _setError('Error filtering recipes: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getMissingIngredients({
    required List<UserIng> userIngredients,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final apiUrl = '${dotenv.env['API_URL']}/recipes/filter/ing';

      final body = {
        "userIngredients": userIngredients.map((ui) => ui.toJson()).toList(),
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Expecting [{ recipeId, missingIngredients: [...], missingCount }]
        _missingCountByRecipe = {
          for (final item in data)
            (item['recipeId'] as int): (item['missingCount'] as int),
        };
        notifyListeners();
      } else {
        _setError(
          'Error filtering recipes. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      _setError('Error filtering recipes: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  void _setError(String error) {
    if (_error != error) {
      _error = error;
      notifyListeners();
    }
  }

  void _clearError() {
    _error = null;
  }

  // Utility
  void clearAll() {
    _recipes = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
