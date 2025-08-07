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

class AIRecommendationsProvider extends ChangeNotifier {
  StructuredAIRecommendation? _currentRecommendation;
  bool _isLoading = false;
  String? _error;

  StructuredAIRecommendation? get currentRecommendation =>
      _currentRecommendation;
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

      debugPrint('🤖 Sending AI recommendation request (JSON mode)');
      debugPrint('📊 Request details: ${body.toString()}');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      debugPrint('RESPUESTA: ${json.decode(response.body)}');
      debugPrint('RAW: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        _currentRecommendation = StructuredAIRecommendation.fromJson(
          responseData,
        );

        debugPrint('✅ Structured AI recommendations received successfully');
        debugPrint(
          '🍽️ Ready to cook: ${_currentRecommendation!.readyToCook.length} recipes',
        );
        debugPrint(
          '🛒 Almost ready: ${_currentRecommendation!.almostReady.length} recipes',
        );
        debugPrint(
          '💡 Shopping suggestions: ${_currentRecommendation!.shoppingSuggestions.length} items',
        );
        debugPrint(
          '🔄 Substitutions: ${_currentRecommendation!.possibleSubstitutions.length} options',
        );
        debugPrint(
          '⏱️ Processing time: ${_currentRecommendation!.processingTime}ms',
        );

        notifyListeners();
      } else {
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
      debugPrint('❌ Error in generateRecommendations: $e');
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

  // Convenience methods for accessing data
  List<AIRecipeMinimal> get readyToCookRecipes =>
      _currentRecommendation?.readyToCook ?? [];
  List<AIAlmostReadyRecipe> get almostReadyRecipes =>
      _currentRecommendation?.almostReady ?? [];
  List<AIShoppingSuggestion> get shoppingSuggestions =>
      _currentRecommendation?.shoppingSuggestions ?? [];
  List<AISubstitution> get substitutions =>
      _currentRecommendation?.possibleSubstitutions ?? [];

  bool get hasAnyRecommendations =>
      _currentRecommendation?.hasAnyRecommendations ?? false;
  int get totalRecommendations =>
      _currentRecommendation?.totalRecommendations ?? 0;
}
