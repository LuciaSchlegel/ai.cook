import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class IngredientsProvider with ChangeNotifier {
  List<UserIng> _userIngredients = [];
  List<Ingredient> _ingredients = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<UserIng> get userIngredients => List.unmodifiable(_userIngredients);
  List<Ingredient> get ingredients => List.unmodifiable(_ingredients);
  bool get isLoading => _isLoading;
  String? get error => _error;

  // User Ingredients Operations
  Future<void> fetchUserIngredients() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    try {
      _setLoading(true);
      _clearError();
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/user/$uid/ingredients'),
      );
      _userIngredients =
          (response.body as List).map((e) => UserIng.fromJson(e)).toList();

      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch user ingredients: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addUserIngredient(UserIng userIngredient) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    try {
      _setLoading(true);
      _clearError();

      // Validate the ingredient
      if (userIngredient.quantity <= 0) {
        throw Exception('Quantity must be greater than 0');
      }

      // Check for duplicates
      if (_userIngredients.any((ing) => ing.id == userIngredient.id)) {
        throw Exception('Ingredient already exists');
      }

      final response = await http.post(
        Uri.parse('${dotenv.env['API_URL']}/user/$uid/ingredients'),
        body: userIngredient.toJson(),
      );
      _userIngredients.add(userIngredient);
      notifyListeners();
    } catch (e) {
      _setError('Failed to add ingredient: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateUserIngredient(UserIng userIngredient) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    try {
      _setLoading(true);
      _clearError();

      // Validate the ingredient
      if (userIngredient.quantity <= 0) {
        throw Exception('Quantity must be greater than 0');
      }

      // Find the index of the ingredient to update
      final index = _userIngredients.indexWhere(
        (ing) => ing.id == userIngredient.id,
      );
      if (index == -1) {
        throw Exception('Ingredient not found');
      }

      final response = await http.put(
        Uri.parse('${dotenv.env['API_URL']}/user/$uid/ingredients'),
        body: userIngredient.toJson(),
      );
      _userIngredients[index] = userIngredient;

      notifyListeners();
    } catch (e) {
      _setError('Failed to update ingredient: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> removeUserIngredient(UserIng userIngredient) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    try {
      _setLoading(true);
      _clearError();

      final response = await http.delete(
        Uri.parse('${dotenv.env['API_URL']}/user/$uid/ingredients'),
        body: {'id': userIngredient.id},
      );
      _userIngredients.removeWhere((ing) => ing.id == userIngredient.id);

      notifyListeners();
    } catch (e) {
      _setError('Failed to remove ingredient: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Base Ingredients Operations
  Future<void> fetchIngredients() async {
    try {
      _setLoading(true);
      _clearError();

      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/ingredients/global'),
      );
      _ingredients =
          (response.body as List).map((e) => Ingredient.fromJson(e)).toList();

      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch ingredients: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Helper methods for state management
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  // Filter methods
  List<UserIng> filterUserIngredientsByCategory(String category) {
    if (category == 'All') return userIngredients;
    return userIngredients
        .where((ing) => ing.ingredient?.category?.name == category)
        .toList();
  }

  List<UserIng> searchUserIngredients(String query) {
    if (query.isEmpty) return userIngredients;
    return userIngredients
        .where(
          (ing) =>
              ing.ingredient?.name.toLowerCase().contains(
                query.toLowerCase(),
              ) ??
              false,
        )
        .toList();
  }

  // Utility methods
  void clearAll() {
    _userIngredients = [];
    _ingredients = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
