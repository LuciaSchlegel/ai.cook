import 'dart:convert';
import 'package:ai_cook_project/models/custom_ing_model.dart';
import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/utils/custom_ing_repo.dart';
import 'package:ai_cook_project/utils/ingredients_cache.dart';
import 'package:ai_cook_project/utils/ingredients_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
      await loadCachedData(
        userIngredientsKey: _userIngredientsKey,
        userIngredients: _userIngredients,
        globalIngredientsKey: _globalIngredientsKey,
        ingredients: _ingredients,
      );

      // Then fetch fresh data if cache is stale
      if (isStale) {
        await Future.wait([fetchIngredients(), fetchUserIngredients()]);
      }

      _initialized = true;
      notifyListeners();
    } catch (e) {
      _setError('Failed to initialize ingredients: $e');
    }
  }

  // User Ingredients Operations
  Future<void> fetchUserIngredients() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final ingredients = await IngredientsRepo.fetchUserIngredients(
      uid: uid,
      setLoading: _setLoading,
      setError: _setError,
      clearError: _clearError,
    );

    _userIngredients = ingredients;
    _lastFetchTime = DateTime.now();
    await saveCachedData(
      userIngredientsKey: _userIngredientsKey,
      userIngredients: _userIngredients,
      globalIngredientsKey: _globalIngredientsKey,
      ingredients: _ingredients,
    );
    notifyListeners();
  }

  Future<void> addUserIngredient(
    UserIng userIngredient, {
    bool optimistic = true,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      _setError('User not authenticated');
      return;
    }

    try {
      if (userIngredient.quantity <= 0) {
        throw Exception('Quantity must be greater than 0');
      }

      if (_userIngredients.any((ing) => ing.id == userIngredient.id)) {
        throw Exception('Ingredient already exists');
      }

      final tempId = DateTime.now().millisecondsSinceEpoch * -1;
      final tempUserIng = userIngredient.copyWith(id: tempId, uid: uid);

      if (optimistic) {
        _userIngredients.add(tempUserIng);
        notifyListeners();
      }

      final savedUserIng = await IngredientsRepo.addUserIngredient(
        uid: uid,
        userIngredient: userIngredient,
        setLoading: _setLoading,
        setError: _setError,
        clearError: _clearError,
      );

      if (savedUserIng != null) {
        if (optimistic) {
          final index = _userIngredients.indexWhere((ing) => ing.id == tempId);
          if (index != -1) {
            _userIngredients[index] = savedUserIng;
          } else {}
        }

        _lastFetchTime = DateTime.now();
        await saveCachedData(
          userIngredientsKey: _userIngredientsKey,
          userIngredients: _userIngredients,
          globalIngredientsKey: _globalIngredientsKey,
          ingredients: _ingredients,
        );
        notifyListeners();
        await fetchUserIngredients();
      } else {
        if (optimistic) {
          _userIngredients.removeWhere((ing) => ing.id == tempId);
          notifyListeners();
        }
      }
    } catch (e) {
      _setError('Failed to add user ingredient: $e');
      rethrow;
    }
  }

  Future<UserIng> updateUserIngredient(UserIng userIngredient) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception('User not authenticated');

    UserIng? originalIngredient;

    try {
      _setLoading(true);
      _clearError();

      if (userIngredient.quantity <= 0) {
        throw Exception('Quantity must be greater than 0');
      }

      final tempIndex = _userIngredients.indexWhere(
        (ing) => ing.id == userIngredient.id,
      );
      if (tempIndex == -1) {
        throw Exception('Ingredient not found');
      }

      originalIngredient = _userIngredients[tempIndex];

      // 🔄 Optimistic update
      final tempUserIng = userIngredient.copyWith(
        id: DateTime.now().millisecondsSinceEpoch * -1,
      );

      _userIngredients[tempIndex] = tempUserIng;
      notifyListeners();

      // ✅ Actualización real vía API
      final savedUserIng = await IngredientsRepo.updateUserIngredient(
        uid: uid,
        userIng: userIngredient,
      );

      // Si el backend responde con custom_ingredient: null, mantenemos el anterior
      final mergedCustomIngredient =
          savedUserIng.customIngredient ??
          userIngredient.customIngredient ??
          originalIngredient.customIngredient;

      // ✅ Aplicar las tags actualizadas (del formulario)
      final fullUpdatedUserIng = savedUserIng.copyWith(
        customIngredient: mergedCustomIngredient?.copyWith(
          tags:
              userIngredient.customIngredient?.tags ??
              mergedCustomIngredient.tags,
        ),
      );

      // 🧠 Guardar versión final
      _userIngredients[tempIndex] = fullUpdatedUserIng;

      _lastFetchTime = DateTime.now();
      await saveCachedData(
        userIngredientsKey: _userIngredientsKey,
        userIngredients: _userIngredients,
        globalIngredientsKey: _globalIngredientsKey,
        ingredients: _ingredients,
      );

      notifyListeners();
      return fullUpdatedUserIng;
    } catch (e) {
      final index = _userIngredients.indexWhere(
        (ing) => ing.id == userIngredient.id || ing.id < 0,
      );
      if (index != -1 && originalIngredient != null) {
        _userIngredients[index] = originalIngredient;
      }
      notifyListeners();

      _setError('Failed to update ingredient: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> removeUserIngredient(UserIng userIngredient) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    try {
      await IngredientsRepo.deleteUserIngredient(
        uid: uid ?? '',
        ingredientId: userIngredient.id,
        setLoading: _setLoading,
        setError: _setError,
        clearError: _clearError,
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
    if (uid == null) throw Exception('User not authenticated');
    if (unit == null) throw Exception('Unit is required');

    final tempId = DateTime.now().millisecondsSinceEpoch * -1;
    UserIng? originalTempUserIng;

    try {
      _setLoading(true);
      _clearError();

      // 🔹 Ingrediente temporal (optimistic update)
      final tempUserIng = UserIng(
        id: tempId,
        uid: uid,
        ingredient: null,
        customIngredient: customIngredient.copyWith(id: -1, uid: uid),
        quantity: quantity,
        unit: unit,
      );

      originalTempUserIng = tempUserIng;
      _userIngredients.add(tempUserIng);
      notifyListeners();

      // 🔹 Paso 1: Crear el CustomIngredient en el backend
      final savedCustomIng = await CustomIngredientRepo.createCustomIngredient(
        customIngredient: customIngredient,
        uid: uid,
      );

      // 🔹 Paso 2: Crear el UserIngredient asociado
      final savedUserIng = await IngredientsRepo.addUserIngredient(
        setError: _setError,
        setLoading: _setLoading,
        clearError: _clearError,
        uid: uid,
        userIngredient: UserIng(
          id: 0,
          uid: uid,
          ingredient: null,
          customIngredient: savedCustomIng,
          quantity: quantity,
          unit: unit,
        ),
      );

      // 🔹 Paso 3: Mezclar los tags del formulario con el customIngredient del backend
      if (savedUserIng == null) {
        throw Exception('Error saving user ingredient');
      }

      final mergedUserIng = savedUserIng.copyWith(
        customIngredient: savedUserIng.customIngredient?.copyWith(
          tags: customIngredient.tags,
        ),
      );

      // 🔹 Reemplazar temporal por real
      final index = _userIngredients.indexWhere((ing) => ing.id == tempId);
      if (index != -1) {
        _userIngredients[index] = mergedUserIng;
      } else {}

      _lastFetchTime = DateTime.now();
      await saveCachedData(
        userIngredientsKey: _userIngredientsKey,
        userIngredients: _userIngredients,
        globalIngredientsKey: _globalIngredientsKey,
        ingredients: _ingredients,
      );
      notifyListeners();

      // 🔁 Refrescamos la lista completa como fallback de seguridad
      await fetchUserIngredients();
    } catch (e) {
      // 🔄 Rollback
      if (originalTempUserIng != null) {
        _userIngredients.removeWhere((ing) => ing.id == tempId);
        notifyListeners();
      }
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
