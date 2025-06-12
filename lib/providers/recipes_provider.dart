import 'dart:convert';
import 'package:ai_cook_project/models/recipe_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RecipesProvider extends ChangeNotifier {
  List<Recipe> _recipes = [];
  bool _isLoading = false;
  String? _error;

  List<Recipe> get recipes => _recipes;
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
      print('getRecipes response: ${response.body}');
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
}
