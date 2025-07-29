import 'dart:convert';
import 'package:ai_cook_project/models/ext_recipe_prev.dart';
import 'package:ai_cook_project/models/ext_recipe_steps.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ExtRecipesProvider extends ChangeNotifier {
  List<ExternalRecipePreview> _extRecipes = [];
  final List<ExternalRecipeSteps> _extRecipeSteps = [];
  bool _isLoading = false;
  String? _error;

  List<ExternalRecipePreview> get extRecipes => _extRecipes;
  List<ExternalRecipeSteps> get extRecipeSteps => _extRecipeSteps;
  bool get isLoading => _isLoading;
  String? get error => _error;
  //busqueda de recetas en la api por tags o searchController
  Future<void> searchRecipes(
    // RecipeSearchParams recipeSearchParams
  ) async {
    _setLoading(true);
    _clearError();

    try {
      final queryParams = {
        'query': 'pasta',
        'diet': 'vegetarian',
        'number': '1',
      };
      final apiUrl = dotenv.env['API_URL'] ?? '';
      final uri = Uri.parse(
        '$apiUrl/api/recipes',
      ).replace(queryParameters: queryParams);
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<dynamic> extRecipesJson = decoded['results'];
        _extRecipes =
            extRecipesJson
                .map((e) => ExternalRecipePreview.fromJson(e))
                .toList();
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

  //busqueda de recetas en la api por ingredients!
  Future<void> searchRecipesByIngredients({
    required List<String> ingredients,
    int number = 10,
  }) async {
    _setLoading(true);
    _clearError();
    try {
      final apiUrl = dotenv.env['API_URL'] ?? '';
      final ingredientsParam = ingredients.join(',');
      final queryParams = {
        'ingredients': ingredientsParam,
        'number': number.toString(),
      };
      final uri = Uri.parse(
        '$apiUrl/api/recipes/by-ingredients',
      ).replace(queryParameters: queryParams);
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<dynamic> extRecipesJson = decoded['results'];
        _extRecipes =
            extRecipesJson
                .map((e) => ExternalRecipePreview.fromJson(e))
                .toList();
      } else {
        _setError(
          'Failed to load recipes by ingredients. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      _setError('Failed to load recipes by ingredients: $e');
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
    _extRecipes = [];
    _extRecipeSteps.clear();
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
