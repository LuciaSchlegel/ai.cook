import 'dart:convert';
import 'package:ai_cook_project/models/custom_ing_model.dart';
import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class IngredientsProvider with ChangeNotifier {
  bool _initialized = false;
  bool get isInitialized => _initialized;

  List<UserIng> _userIngredients = [];
  List<Ingredient> _ingredients = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<UserIng> get userIngredients => List.unmodifiable(_userIngredients);
  List<Ingredient> get ingredients => List.unmodifiable(_ingredients);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> initializeIngredients() async {
    if (_initialized) return;
    await Future.wait([fetchIngredients(), fetchUserIngredients()]);
    _initialized = true;
    notifyListeners();
  }

  // User Ingredients Operations
  Future<void> fetchUserIngredients() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return;
    }

    try {
      _setLoading(true);
      _clearError();

      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/user/$uid/ingredients'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to fetch user ingredients: ${response.statusCode}',
        );
      }

      final dynamic decoded = json.decode(response.body);
      if (decoded == null) {
        throw Exception('Received null response from server');
      }

      if (decoded is! List) {
        throw Exception(
          'Expected a list of ingredients, got ${decoded.runtimeType}',
        );
      }

      final List<UserIng> parsedIngredients = [];
      for (var e in decoded) {
        if (e == null) {
          debugPrint('Warning: Skipping null ingredient');
          continue;
        }
        try {
          final userIng = UserIng.fromJson(e as Map<String, dynamic>);
          parsedIngredients.add(userIng);
        } catch (e) {
          debugPrint('Error parsing ingredient: $e');
          debugPrint('Raw ingredient data: $e');
          // Continue processing other ingredients instead of failing completely
          continue;
        }
      }

      _userIngredients = parsedIngredients;
      notifyListeners();
    } catch (e) {
      debugPrint('Error in fetchUserIngredients: $e');
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

      if (userIngredient.quantity <= 0) {
        throw Exception('Quantity must be greater than 0');
      }

      if (_userIngredients.any((ing) => ing.id == userIngredient.id)) {
        throw Exception('Ingredient already exists');
      }

      final response = await http.post(
        Uri.parse('${dotenv.env['API_URL']}/user/$uid/ingredients'),
        body: json.encode(userIngredient.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add ingredient: ${response.statusCode}');
      }

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

      if (userIngredient.quantity <= 0) {
        throw Exception('Quantity must be greater than 0');
      }

      final index = _userIngredients.indexWhere(
        (ing) => ing.id == userIngredient.id,
      );
      if (index == -1) {
        throw Exception('Ingredient not found');
      }

      final response = await http.put(
        Uri.parse('${dotenv.env['API_URL']}/user/$uid/ingredients'),
        body: json.encode(userIngredient.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update ingredient: ${response.statusCode}');
      }

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

      await http.delete(
        Uri.parse('${dotenv.env['API_URL']}/user/$uid/ingredients'),
        body: json.encode({'id': userIngredient.id}),
        headers: {'Content-Type': 'application/json'},
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

  Future<void> addCustomIngredient(CustomIngredient customIngredient) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    try {
      _setLoading(true);
      _clearError();

      final response = await http.post(
        Uri.parse('${dotenv.env['API_URL']}/ingredients/custom'),
        body: json.encode(customIngredient.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 201) {
        throw Exception(
          'Failed to add custom ingredient: ${response.statusCode}',
        );
      }

      final responseData = json.decode(response.body);

      // Create a new UserIng with the custom ingredient
      final newUserIng = UserIng(
        id: responseData['id'] as int,
        uid: uid ?? '',
        ingredient: Ingredient(
          id: responseData['id'] as int,
          name: customIngredient.name,
          isVegan: false,
          isVegetarian: false,
          isGlutenFree: false,
          isLactoseFree: false,
          category: customIngredient.category,
          tags: customIngredient.tags,
        ),
        quantity: 1,
        unit: Unit(id: -1, name: 'piece', abbreviation: 'pcs', type: 'count'),
      );

      _userIngredients.add(newUserIng);
      notifyListeners();
    } catch (e) {
      _setError('Failed to add custom ingredient: $e');
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
      final List<dynamic> decoded = json.decode(response.body);
      _ingredients = decoded.map((e) => Ingredient.fromJson(e)).toList();

      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch ingredients: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Helper methods
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

  // Filters
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

  // Utility
  void clearAll() {
    _userIngredients = [];
    _ingredients = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
