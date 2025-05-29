import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:flutter/material.dart';

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
    try {
      _setLoading(true);
      _clearError();

      // TODO: Implement API call to fetch user ingredients
      // For now, we'll just simulate an API call
      await Future.delayed(const Duration(seconds: 1));

      // After getting the data from API, update the list
      // _userIngredients = response.data;

      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch user ingredients: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addUserIngredient(UserIng userIngredient) async {
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

      // TODO: Implement API call to add user ingredient
      // For now, we'll just add it to the local list
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

      // TODO: Implement API call to update user ingredient
      // For now, we'll just update the local list
      _userIngredients[index] = userIngredient;

      notifyListeners();
    } catch (e) {
      _setError('Failed to update ingredient: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> removeUserIngredient(int ingredientId) async {
    try {
      _setLoading(true);
      _clearError();

      // TODO: Implement API call to remove user ingredient
      // For now, we'll just remove from the local list
      _userIngredients.removeWhere((ing) => ing.id == ingredientId);

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

      // TODO: Implement API call to fetch ingredients
      // For now, we'll just simulate an API call
      await Future.delayed(const Duration(seconds: 1));

      // After getting the data from API, update the list
      // _ingredients = response.data;

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
    return userIngredients.where((ing) => ing.category == category).toList();
  }

  List<UserIng> searchUserIngredients(String query) {
    if (query.isEmpty) return userIngredients;
    return userIngredients
        .where((ing) => ing.name.toLowerCase().contains(query.toLowerCase()))
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
