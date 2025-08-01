import 'dart:convert';
import 'package:ai_cook_project/models/recipe_tag_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/models/ai_response_model.dart';
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

class RecipeWithMissingIngredients {
  final Map<String, dynamic> recipe;
  final List<Map<String, dynamic>> missingIngredients;
  final int missingCount;
  final int availableCount;
  final int totalCount;
  final double matchPercentage;

  RecipeWithMissingIngredients({
    required this.recipe,
    required this.missingIngredients,
    required this.missingCount,
    required this.availableCount,
    required this.totalCount,
    required this.matchPercentage,
  });

  factory RecipeWithMissingIngredients.fromJson(Map<String, dynamic> json) {
    return RecipeWithMissingIngredients(
      recipe: json['recipe'] as Map<String, dynamic>,
      missingIngredients:
          (json['missingIngredients'] as List<dynamic>)
              .cast<Map<String, dynamic>>(),
      missingCount: json['missingCount'] as int,
      availableCount: json['availableCount'] as int,
      totalCount: json['totalCount'] as int,
      matchPercentage: (json['matchPercentage'] as num).toDouble(),
    );
  }
}

class AIRecommendation {
  final String recommendations;
  final ParsedAIResponse parsedResponse;
  final List<dynamic> filteredRecipes;
  final List<RecipeWithMissingIngredients>? recipesWithMissingInfo;
  final int totalRecipesConsidered;
  final int? processingTime;

  AIRecommendation({
    required this.recommendations,
    required this.parsedResponse,
    required this.filteredRecipes,
    this.recipesWithMissingInfo,
    required this.totalRecipesConsidered,
    this.processingTime,
  });

  factory AIRecommendation.fromJson(Map<String, dynamic> json) {
    final rawRecommendations = json['recommendations'] as String;
    final parsedResponse = ParsedAIResponse.parse(rawRecommendations);

    return AIRecommendation(
      recommendations: rawRecommendations,
      parsedResponse: parsedResponse,
      filteredRecipes: json['filteredRecipes'] as List<dynamic>,
      recipesWithMissingInfo:
          json['recipesWithMissingInfo'] != null
              ? (json['recipesWithMissingInfo'] as List<dynamic>)
                  .map(
                    (item) => RecipeWithMissingIngredients.fromJson(
                      item as Map<String, dynamic>,
                    ),
                  )
                  .toList()
              : null,
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

      debugPrint(
        '🤖 Sending AI recommendation request: \n'
        'Tags: ${input.preferredTags.map((t) => t.name).toList()}\n'
        'User Ingredients: ${input.userIngredients.map((u) => u.toJson()).toList()}\n'
        'Max Cooking Time: ${input.maxCookingTimeMinutes}\n'
        'Preferred Difficulty: ${input.preferredDifficulty}\n'
        'User Preferences: ${input.userPreferences}\n'
        'Number of Recipes: ${input.numberOfRecipes}',
      );

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
        // Handle different error types from server
        String errorMessage = 'Error generating AI recommendations';

        try {
          final errorData = json.decode(response.body);
          if (errorData['error'] == 'NO_INGREDIENTS') {
            errorMessage =
                'Please add some ingredients to your cupboard first before generating AI recommendations.';
          } else if (errorData['message'] != null) {
            errorMessage = errorData['message'];
          } else {
            errorMessage =
                'Server error (${response.statusCode}). Please try again.';
          }
        } catch (e) {
          errorMessage =
              'Server error (${response.statusCode}). Please try again.';
        }

        _setError(errorMessage);
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
