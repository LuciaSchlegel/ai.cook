import 'dart:convert';
import 'package:ai_cook_project/models/custom_ing_model.dart';
import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IngredientsProvider with ChangeNotifier {
  static const String _userIngredientsKey = 'user_ingredients';
  static const String _globalIngredientsKey = 'global_ingredients';

  bool _initialized = false;
  bool get isInitialized => _initialized;

  List<UserIng> _userIngredients = [];
  List<Ingredient> _ingredients = [];
  bool _isLoading = false;
  String? _error;
  DateTime? _lastFetchTime;
  static const Duration _cacheDuration = Duration(minutes: 5);

  // Getters
  List<UserIng> get userIngredients => List.unmodifiable(_userIngredients);
  List<Ingredient> get ingredients => List.unmodifiable(_ingredients);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isStale =>
      _lastFetchTime == null ||
      DateTime.now().difference(_lastFetchTime!) > _cacheDuration;

  Future<void> initializeIngredients() async {
    if (_initialized) return;

    try {
      // Load cached data first
      await _loadCachedData();

      // Then fetch fresh data if cache is stale
      if (isStale) {
        await Future.wait([fetchIngredients(), fetchUserIngredients()]);
      }

      _initialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing ingredients: $e');
      _setError('Failed to initialize ingredients: $e');
    }
  }

  Future<void> _loadCachedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final userIngredientsJson = prefs.getString(_userIngredientsKey);
      if (userIngredientsJson != null) {
        final List<dynamic> decoded = json.decode(userIngredientsJson);
        _userIngredients = decoded.map((e) => UserIng.fromJson(e)).toList();
      }

      final globalIngredientsJson = prefs.getString(_globalIngredientsKey);
      if (globalIngredientsJson != null) {
        final List<dynamic> decoded = json.decode(globalIngredientsJson);
        _ingredients = decoded.map((e) => Ingredient.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Error loading cached data: $e');
    }
  }

  Future<void> _saveCachedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        _userIngredientsKey,
        json.encode(_userIngredients.map((e) => e.toJson()).toList()),
      );

      await prefs.setString(
        _globalIngredientsKey,
        json.encode(_ingredients.map((e) => e.toJson()).toList()),
      );
    } catch (e) {
      debugPrint('Error saving cached data: $e');
    }
  }

  // User Ingredients Operations
  Future<void> fetchUserIngredients() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

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
          continue;
        }
      }

      _userIngredients = parsedIngredients;
      _lastFetchTime = DateTime.now();
      await _saveCachedData();
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

      // If this is a custom ingredient, create it first
      if (userIngredient.customIngredient != null) {
        await addCustomIngredient(
          userIngredient.customIngredient!,
          quantity: userIngredient.quantity,
          unit: userIngredient.unit,
        );
        return;
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

  Future<void> addCustomIngredient(
    CustomIngredient customIngredient, {
    int quantity = 1,
    Unit? unit,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw Exception('User not authenticated');
    }

    if (unit == null) {
      throw Exception('Unit is required');
    }

    try {
      _setLoading(true);
      _clearError();

      // Create a temporary UserIng for optimistic update
      final tempUserIng = UserIng(
        id: -1,
        uid: uid,
        ingredient: null,
        customIngredient: CustomIngredient(
          id: -1,
          name: customIngredient.name,
          category: customIngredient.category,
          tags: customIngredient.tags,
          uid: uid,
        ),
        quantity: quantity,
        unit: unit,
      );

      // Optimistically add to the list
      _userIngredients.add(tempUserIng);
      notifyListeners();

      // Create the custom ingredient
      final response = await http.post(
        Uri.parse('${dotenv.env['API_URL']}/ingredients/custom'),
        body: json.encode({
          'name': customIngredient.name,
          'category': customIngredient.category?.toJson(),
          'tags': customIngredient.tags?.map((tag) => tag.toJson()).toList(),
          'uid': uid,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 201) {
        // Remove the temporary ingredient on failure
        _userIngredients.remove(tempUserIng);
        notifyListeners();
        throw Exception(
          'Failed to add custom ingredient: ${response.statusCode} - ${response.body}',
        );
      }

      final responseData = json.decode(response.body);
      if (responseData == null) {
        throw Exception('Received null response from server');
      }

      final customIngId = responseData['id'] as int;

      // Create the user ingredient
      final requestBody = {
        'ingredient': null,
        'custom_ingredient': {'id': customIngId},
        'quantity': quantity,
        'unit': {'id': unit.id},
      };

      final userIngResponse = await http.post(
        Uri.parse('${dotenv.env['API_URL']}/user/$uid/ingredients'),
        body: json.encode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      if (userIngResponse.statusCode != 201) {
        // Remove the temporary ingredient on failure
        _userIngredients.remove(tempUserIng);
        notifyListeners();
        throw Exception(
          'Failed to add user ingredient: ${userIngResponse.statusCode} - ${userIngResponse.body}',
        );
      }

      final userIngData = json.decode(userIngResponse.body);
      if (userIngData == null) {
        throw Exception(
          'Received null response from server for user ingredient',
        );
      }

      // Replace the temporary ingredient with the real one
      final savedUserIng = UserIng.fromJson(userIngData);

      // Create a new CustomIngredient with the tags from the original request
      if (savedUserIng.customIngredient != null) {
        final updatedCustomIng = CustomIngredient(
          id: savedUserIng.customIngredient!.id,
          name: savedUserIng.customIngredient!.name,
          category: savedUserIng.customIngredient!.category,
          tags: customIngredient.tags,
          uid: savedUserIng.customIngredient!.uid,
        );

        // Create a new UserIng with the updated CustomIngredient
        final updatedUserIng = UserIng(
          id: savedUserIng.id,
          uid: savedUserIng.uid,
          ingredient: null,
          customIngredient: updatedCustomIng,
          quantity: savedUserIng.quantity,
          unit: savedUserIng.unit,
        );

        final index = _userIngredients.indexOf(tempUserIng);
        if (index != -1) {
          _userIngredients[index] = updatedUserIng;
        }
      }

      _lastFetchTime = DateTime.now();
      await _saveCachedData();
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('Error in addCustomIngredient: $e');
      debugPrint('Stack trace: $stackTrace');
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
    return userIngredients.where((ing) {
      final cat =
          ing.ingredient?.category?.name ??
          ing.customIngredient?.category?.name;
      return cat == category;
    }).toList();
  }

  List<UserIng> searchUserIngredients(String query) {
    if (query.isEmpty) return userIngredients;
    return userIngredients.where((ing) {
      final name = ing.ingredient?.name ?? ing.customIngredient?.name;
      return name?.toLowerCase().contains(query.toLowerCase()) ?? false;
    }).toList();
  }

  // Utility
  void clearAll() {
    _userIngredients = [];
    _ingredients = [];
    _error = null;
    _isLoading = false;
    _lastFetchTime = null;
    notifyListeners();
  }
}
