import 'dart:convert';
import 'dart:async';
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
  String? _loadingMessage;

  // Request cancellation support
  http.Client? _currentClient;
  String? _currentFilter;
  List<String>? _currentTags;

  List<Recipe> get recipes => _recipes;
  Map<int, int> get missingCountByRecipe => _missingCountByRecipe;
  int missingCountFor(int recipeId) => _missingCountByRecipe[recipeId] ?? 0;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get loadingMessage => _loadingMessage;

  Future<void> getRecipes() async {
    _cancelCurrentRequest();
    _setLoading(true, 'Loading all recipes...');
    _clearError();

    // Reset filter state for "All Recipes"
    _currentFilter = 'All Recipes';
    _currentTags = [];

    try {
      _currentClient = http.Client();
      final response = await _currentClient!.get(
        Uri.parse('${dotenv.env['API_URL']}/recipes'),
        headers: {'Content-Type': 'application/json'},
      );

      // Check if this request is still current
      if (_currentClient == null) {
        // Request was cancelled
        return;
      }

      if (response.statusCode == 200) {
        final List<dynamic> recipesJson = json.decode(response.body);
        _recipes = recipesJson.map((e) => Recipe.fromJson(e)).toList();
      } else {
        _setError(
          'Failed to load recipes. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Don't show error if request was cancelled
      if (_currentClient != null) {
        // Check if it's a cancellation-related error
        if (e.toString().contains('Connection closed') ||
            e.toString().contains('HttpException')) {
          debugPrint('Request cancelled: $e');
        } else {
          _setError('Failed to load recipes: $e');
        }
      }
    } finally {
      _currentClient?.close();
      _currentClient = null;
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
    // Cancel any ongoing request
    _cancelCurrentRequest();

    // Check if this is a duplicate request
    if (_currentFilter == filter && _listsEqual(_currentTags, preferredTags)) {
      return; // Skip duplicate request
    }

    _setLoading(true, _generateLoadingMessage(filter, preferredTags));
    _clearError();

    // Store current filter state
    _currentFilter = filter;
    _currentTags = List.from(preferredTags);

    try {
      _currentClient = http.Client();
      final apiUrl = '${dotenv.env['API_URL']}/recipes/filter';

      final body = {
        "userIngredients": userIngredients.map((u) => u.toJson()).toList(),
        "filter": filter,
        "preferredTags": preferredTags,
        "maxCookingTimeMinutes": maxCookingTimeMinutes,
        "preferredDifficulty": preferredDifficulty,
      };

      final response = await _currentClient!.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      // Check if this request is still current
      if (_currentClient == null) {
        // Request was cancelled
        return;
      }

      // Validate that the response matches current filter state
      if (_currentFilter != filter ||
          !_listsEqual(_currentTags, preferredTags)) {
        // Filter state changed while request was in flight, ignore response
        return;
      }

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
      // Don't show error if request was cancelled
      if (_currentClient != null) {
        // Check if it's a cancellation-related error
        if (e.toString().contains('Connection closed') ||
            e.toString().contains('HttpException')) {
          debugPrint('Filter request cancelled: $e');
        } else {
          _setError('Error filtering recipes: $e');
        }
      }
    } finally {
      _currentClient?.close();
      _currentClient = null;
      _setLoading(false);
    }
  }

  Future<void> getMissingIngredients({
    required List<UserIng> userIngredients,
  }) async {
    // Don't interfere with main filtering requests
    // Use a separate client for missing ingredients
    try {
      final apiUrl = '${dotenv.env['API_URL']}/recipes/filter/ing';

      final body = {
        "userIngredients": userIngredients.map((ui) => ui.toJson()).toList(),
      };

      final client = http.Client();
      final response = await client.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      client.close();

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Expecting [{ recipeId, missingIngredients: [...], missingCount }]
        _missingCountByRecipe = {
          for (final item in data)
            (item['recipeId'] as int): (item['missingCount'] as int),
        };
        notifyListeners();
      } else {
        // Silently fail for missing ingredients to not interfere with main flow
        debugPrint(
          'Error getting missing ingredients. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Silently fail for missing ingredients to not interfere with main flow
      debugPrint('Error getting missing ingredients: $e');
    }
  }

  void _setLoading(bool value, [String? message]) {
    if (_isLoading != value || _loadingMessage != message) {
      _isLoading = value;
      _loadingMessage = value ? message : null;
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

  /// Cancel the current HTTP request if one is in progress
  void _cancelCurrentRequest() {
    if (_currentClient != null) {
      _currentClient!.close();
      _currentClient = null;
    }
  }

  /// Compare two lists for equality (order-independent)
  bool _listsEqual(List<String>? list1, List<String>? list2) {
    if (list1 == null && list2 == null) return true;
    if (list1 == null || list2 == null) return false;
    if (list1.length != list2.length) return false;

    final set1 = Set<String>.from(list1);
    final set2 = Set<String>.from(list2);
    return set1.containsAll(set2) && set2.containsAll(set1);
  }

  /// Generate contextual loading message based on filter and tags
  String _generateLoadingMessage(String filter, List<String> tags) {
    if (tags.isEmpty) {
      // No tags selected, show basic filter message
      switch (filter) {
        case 'All Recipes':
          return 'Loading all recipes...';
        case 'With Available Ingredients':
          return 'Finding recipes with your ingredients...';
        case 'Recommended Recipes':
          return 'Finding recommended recipes...';
        default:
          return 'Applying filter: $filter...';
      }
    } else {
      // Tags selected, create contextual message
      final tagText =
          tags.length == 1
              ? tags.first
              : tags.length == 2
              ? '${tags.first} & ${tags.last}'
              : '${tags.first} & ${tags.length - 1} others';

      switch (filter) {
        case 'All Recipes':
          return 'Looking for $tagText recipes...';
        case 'With Available Ingredients':
          return 'Finding $tagText recipes with your ingredients...';
        case 'Recommended Recipes':
          return 'Finding recommended $tagText recipes...';
        default:
          return 'Looking for $tagText recipes...';
      }
    }
  }

  // Utility
  void clearAll() {
    _cancelCurrentRequest();
    _recipes = [];
    _missingCountByRecipe = {};
    _error = null;
    _isLoading = false;
    _loadingMessage = null;
    _currentFilter = null;
    _currentTags = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _cancelCurrentRequest();
    super.dispose();
  }
}
