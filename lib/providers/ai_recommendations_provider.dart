import 'package:flutter/material.dart';
import '../models/ai_response_model.dart';
import '../models/recipe_tag_model.dart';
import '../services/ai_service.dart';
import '../services/llm_recommendations.service.dart' show AIRecommendationService, NoIngredientsException, UnauthorizedException;

class AIRecommendationsProvider extends ChangeNotifier {
  final AIRecommendationService _service = AIRecommendationService();
  final AIService _aiService = AIService();

  StructuredAIRecommendation? _currentRecommendation;
  bool _isLoading = false;
  String? _error;

  StructuredAIRecommendation? get currentRecommendation =>
      _currentRecommendation;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> generateRecommendations({
    required String userId,
    required List<RecipeTag> preferredTags,
    int? maxCookingTimeMinutes,
    String? preferredDifficulty,
    Map<String, bool>? dietaryRestrictions,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Step 1: Fetch pre-computed recipes from backend
      final responseData = await _service.fetchStructuredRecipesForAI(
        userId: userId,
        preferredTags: preferredTags,
        maxCookingTimeMinutes: maxCookingTimeMinutes,
        preferredDifficulty: preferredDifficulty,
        dietaryRestrictions: dietaryRestrictions,
      );

      debugPrint('Backend pre-computed data received');
      debugPrint('   Ready to Cook: ${responseData['readyToCook']?.length ?? 0}');
      debugPrint('   Almost Ready: ${responseData['almostReady']?.length ?? 0}');

      // Step 2: Enrich via Claude API backend
      try {
        debugPrint('Enriching recipes via Claude backend...');
        final enrichedData = await _aiService.enrichRecipes(
          userId: userId,
          preComputedData: responseData,
        );

        _currentRecommendation = StructuredAIRecommendation.fromJson(enrichedData);
        debugPrint('Enrichment success!');
        debugPrint('   Ready to cook: ${_currentRecommendation!.readyToCook.length}');
        debugPrint('   Almost ready: ${_currentRecommendation!.almostReady.length}');
        notifyListeners();
        return;
      } catch (e) {
        debugPrint('Enrichment failed, using fallback: $e');
      }

      // Step 3: Fallback — use pre-computed data with default descriptions
      _generateFallback(responseData);
    } on NoIngredientsException catch (e) {
      _setError(e.toString());
    } on UnauthorizedException catch (e) {
      _setError(e.toString());
    } catch (e) {
      debugPrint('Error in generateRecommendations: $e');
      _setError('Failed to generate recommendations: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _generateFallback(Map<String, dynamic> backendData) {
    final readyToCook = (backendData['readyToCook'] as List? ?? []);
    final almostReady = (backendData['almostReady'] as List? ?? []);

    if (readyToCook.isEmpty && almostReady.isEmpty) {
      _setError('notEnoughRecipes');
      return;
    }

    // Build response from pre-computed data without AI enrichment
    final fallbackJson = <String, dynamic>{
      'ready_to_cook': readyToCook.map((r) {
        return <String, dynamic>{
          'id': r['id'],
          'title': r['name'],
          'time_minutes': _extractTimeMinutes(r['cookingTime'] ?? ''),
          'difficulty': r['difficulty'],
          'tags': r['tags'] ?? [],
          'match_score': r['matchScore'],
          'description': 'Great recipe match!',
          'ingredients': ((r['matchingIngredients'] as List?) ?? [])
              .map((name) => <String, dynamic>{'name': name, 'quantity': ''})
              .toList(),
          'steps': <String>[],
          'missing_ingredients': r['missingIngredients'] ?? [],
          'recipe_substitutions': <Map<String, dynamic>>[],
        };
      }).toList(),
      'almost_ready': almostReady.map((r) {
        return <String, dynamic>{
          'id': r['id'],
          'title': r['name'],
          'time_minutes': _extractTimeMinutes(r['cookingTime'] ?? ''),
          'difficulty': r['difficulty'],
          'tags': r['tags'] ?? [],
          'match_score': r['matchScore'],
          'description': 'Almost there! Just a few ingredients away.',
          'ingredients': ((r['matchingIngredients'] as List?) ?? [])
              .map((name) => <String, dynamic>{'name': name, 'quantity': ''})
              .toList(),
          'steps': <String>[],
          'missing_ingredients': r['missingIngredients'] ?? [],
          'recipe_substitutions': <Map<String, dynamic>>[],
        };
      }).toList(),
      'shopping_suggestions': <Map<String, dynamic>>[],
      'possible_substitutions': <Map<String, dynamic>>[],
    };

    _currentRecommendation = StructuredAIRecommendation.fromJson(fallbackJson);
    notifyListeners();
  }

  int _extractTimeMinutes(String timeString) {
    if (timeString.isEmpty) return 0;
    final m = RegExp(r'(\d+)\s*(?:min|m)', caseSensitive: false).firstMatch(timeString);
    if (m != null) return int.parse(m.group(1)!);
    final h = RegExp(r'(\d+)\s*(?:h|hour)', caseSensitive: false).firstMatch(timeString);
    if (h != null) return int.parse(h.group(1)!) * 60;
    final n = RegExp(r'(\d+)').firstMatch(timeString);
    if (n != null) return int.parse(n.group(1)!);
    return 0;
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

  // Convenience getters
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
