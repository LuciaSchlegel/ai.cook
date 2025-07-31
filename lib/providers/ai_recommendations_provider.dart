import 'dart:convert';
import 'package:ai_cook_project/models/recipe_tag_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIRecomendationInput {
  final List<UserIng> userIngredients;
  final List<RecipeTag> preferredTags;
  final int? maxCookingTimeMinutes;
  final String? preferredDifficulty;
  final String? userPreferences;
  final int numberOfRecipes;

  AIRecomendationInput({
    required this.userIngredients,
    required this.preferredTags,
    required this.maxCookingTimeMinutes,
    required this.preferredDifficulty,
    required this.userPreferences,
    required this.numberOfRecipes,
  });
}

class AIRecommendation {
  final String recommendations;
  final List<dynamic> filteredRecipes;
  final int totalRecipesConsidered;
  final int? processingTime;

  AIRecommendation({
    required this.recommendations,
    required this.filteredRecipes,
    required this.totalRecipesConsidered,
    this.processingTime,
  });

  factory AIRecommendation.fromJson(Map<String, dynamic> json) {
    return AIRecommendation(
      recommendations: json['recommendations'] as String,
      filteredRecipes: json['filteredRecipes'] as List<dynamic>,
      totalRecipesConsidered: json['totalRecipesConsidered'] as int,
      processingTime: json['processingTime'] as int?,
    );
  }
}

class AIRecommendationsProvider extends ChangeNotifier {
  AIRecommendation? _currentRecommendation;
  bool _isLoading = false;
  String? _error;

  AIRecommendation? get currentRecommendation => _currentRecommendation;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> generateRecommendations({
    required AIRecomendationInput input,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final apiUrl =
          '${dotenv.env['API_URL']}/ai-recommendations/recommendations';

      final body = {
        "userIngredients":
            input.userIngredients.map((u) => u.toJson()).toList(),
        "preferredTags": input.preferredTags.map((t) => t.name).toList(),
        "maxCookingTimeMinutes": input.maxCookingTimeMinutes,
        "preferredDifficulty": input.preferredDifficulty,
        "userPreferences": input.userPreferences,
        "numberOfRecipes": input.numberOfRecipes,
      };

      debugPrint('🤖 Sending AI recommendation request: ${jsonEncode(body)}');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        _currentRecommendation = AIRecommendation.fromJson(responseData);

        debugPrint('✅ AI recommendations received successfully');
        debugPrint(
          '📊 Processed ${_currentRecommendation!.totalRecipesConsidered} recipes',
        );
        debugPrint(
          '⏱️ Processing time: ${_currentRecommendation!.processingTime}ms',
        );

        notifyListeners();
      } else {
        _setError(
          'Error generating AI recommendations. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      _setError('Error generating AI recommendations: $e');
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

  void clearAll() {
    _currentRecommendation = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
