import 'package:flutter/foundation.dart';
import 'ai_service.dart';

/// Model for a single ingredient modification
class IngredientModification {
  final String original;
  final String replacement;
  final String notes;

  IngredientModification({
    required this.original,
    required this.replacement,
    required this.notes,
  });

  factory IngredientModification.fromJson(Map<String, dynamic> json) {
    return IngredientModification(
      original: json['original'] ?? '',
      replacement: json['replacement'] ?? '',
      notes: json['notes'] ?? '',
    );
  }
}

/// Model for the full diet adaptation result
class DietAdaptationResult {
  final String originalRecipe;
  final List<String> dietaryNeeds;
  final List<IngredientModification> modifications;
  final String tips;

  DietAdaptationResult({
    required this.originalRecipe,
    required this.dietaryNeeds,
    required this.modifications,
    required this.tips,
  });

  factory DietAdaptationResult.fromJson(Map<String, dynamic> json) {
    return DietAdaptationResult(
      originalRecipe: json['original_recipe'] ?? '',
      dietaryNeeds: (json['dietary_needs'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      modifications: (json['modifications'] as List?)
              ?.map(
                  (e) => IngredientModification.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      tips: json['tip'] ?? json['tips'] ?? '',
    );
  }
}

/// Service for adapting recipes to dietary needs via Claude API backend
class DietAdapterService extends ChangeNotifier {
  final AIService _aiService = AIService();

  DietAdaptationResult? _result;
  bool _isLoading = false;
  String? _error;

  DietAdaptationResult? get result => _result;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasResult => _result != null;

  /// Adapt a recipe for specific dietary needs
  Future<void> adaptRecipe({
    required String recipeName,
    required List<String> ingredients,
    required List<String> dietaryNeeds,
  }) async {
    if (recipeName.trim().isEmpty) {
      _error = 'Please enter a recipe name';
      notifyListeners();
      return;
    }

    if (ingredients.isEmpty) {
      _error = 'Please add at least one ingredient';
      notifyListeners();
      return;
    }

    if (dietaryNeeds.isEmpty) {
      _error = 'Please select at least one dietary requirement';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    _result = null;
    notifyListeners();

    try {
      final data = await _aiService.adaptDiet(
        recipeName: recipeName.trim(),
        ingredients: ingredients.map((e) => e.trim()).toList(),
        dietaryNeeds: dietaryNeeds,
      );

      _result = DietAdaptationResult.fromJson(data);
      debugPrint('Got ${_result!.modifications.length} modifications');
    } catch (e) {
      debugPrint('Error: $e');
      _error = 'Failed to adapt recipe: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _result = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
