import 'package:flutter/foundation.dart';
import 'ai_service.dart';

/// Model for a single substitution option
class SubstituteOption {
  final String name;
  final String ratio;
  final String notes;

  SubstituteOption({
    required this.name,
    required this.ratio,
    required this.notes,
  });

  factory SubstituteOption.fromJson(Map<String, dynamic> json) {
    return SubstituteOption(
      name: json['name'] ?? '',
      ratio: json['ratio'] ?? '',
      notes: json['notes'] ?? '',
    );
  }
}

/// Model for the full substitution result
class SubstitutionResult {
  final String originalIngredient;
  final List<SubstituteOption> substitutes;
  final String tips;

  SubstitutionResult({
    required this.originalIngredient,
    required this.substitutes,
    required this.tips,
  });

  factory SubstitutionResult.fromJson(Map<String, dynamic> json) {
    return SubstitutionResult(
      originalIngredient: json['original_ingredient'] ?? '',
      substitutes: (json['substitutes'] as List?)
              ?.map((e) => SubstituteOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      tips: json['tip'] ?? json['tips'] ?? '',
    );
  }
}

/// Optional context for more relevant substitution suggestions
class SubstitutionContext {
  final String? recipeName;
  final List<String>? dietaryRestrictions;
  final List<String>? availableIngredients;

  SubstitutionContext({
    this.recipeName,
    this.dietaryRestrictions,
    this.availableIngredients,
  });
}

/// Service for generating ingredient substitutions via Claude API backend
class SubstitutionsService extends ChangeNotifier {
  final AIService _aiService = AIService();

  SubstitutionResult? _result;
  bool _isLoading = false;
  String? _error;

  SubstitutionResult? get result => _result;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasResult => _result != null;

  /// Generate substitutions for an ingredient
  Future<void> generateSubstitutions({
    required String ingredient,
    SubstitutionContext? context,
  }) async {
    if (ingredient.trim().isEmpty) {
      _error = 'Please enter an ingredient';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    _result = null;
    notifyListeners();

    try {
      final data = await _aiService.getSubstitutions(
        ingredient: ingredient.trim(),
        recipeName: context?.recipeName,
        dietaryRestrictions: context?.dietaryRestrictions,
      );

      _result = SubstitutionResult.fromJson(data);
      debugPrint('Got ${_result!.substitutes.length} substitutes');
    } catch (e) {
      debugPrint('Error: $e');
      _error = 'Failed to generate substitutions: $e';
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
