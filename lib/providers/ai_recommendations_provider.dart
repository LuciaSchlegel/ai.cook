// lib/providers/ai_recommendations_provider.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../models/ai_response_model.dart';
import '../models/recipe_tag_model.dart';
import '../services/llm_recommendations.service.dart' show AIRecommendationService, NoIngredientsException, UnauthorizedException;

class AIRecommendationsProvider extends ChangeNotifier {
  final AIRecommendationService _service = AIRecommendationService();

  StructuredAIRecommendation? _currentRecommendation;
  bool _isLoading = false;
  String? _error;

  static const platform = MethodChannel('ai.cook/foundation_models');

  StructuredAIRecommendation? get currentRecommendation =>
      _currentRecommendation;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Prewarm the Foundation Models on iOS to reduce first-generation latency
  Future<void> prewarmModel() async {
    if (!Platform.isIOS) return;

    try {
      debugPrint('🔥 Prewarming Foundation Models...');
      await platform.invokeMethod('prewarmModel');
      debugPrint('✅ Model prewarmed successfully');
    } catch (e) {
      debugPrint('⚠️ Prewarm failed (non-critical): $e');
      // Non-critical - generation will still work
    }
  }

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
      debugPrint('🆕 Generating recommendations with pre-computed data');
      await _generateCleanApproach(
        userId: userId,
        preferredTags: preferredTags,
        maxCookingTimeMinutes: maxCookingTimeMinutes,
        preferredDifficulty: preferredDifficulty,
        dietaryRestrictions: dietaryRestrictions,
      );
    } on NoIngredientsException catch (e) {
      _setError(e.toString());
    } on UnauthorizedException catch (e) {
      _setError(e.toString());
    } catch (e) {
      debugPrint('❌ Error in generateRecommendations: $e');
      _setError('Failed to generate recommendations: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _generateCleanApproach({
    required String userId,
    required List<RecipeTag> preferredTags,
    int? maxCookingTimeMinutes,
    String? preferredDifficulty,
    Map<String, bool>? dietaryRestrictions,
  }) async {
    // Step 1: Fetch PRE-COMPUTED recipes from backend
    final responseData = await _service.fetchStructuredRecipesForAI(
      userId: userId,
      preferredTags: preferredTags,
      maxCookingTimeMinutes: maxCookingTimeMinutes,
      preferredDifficulty: preferredDifficulty,
      dietaryRestrictions: dietaryRestrictions,
    );

    debugPrint('✅ Backend pre-computed data received');
    debugPrint('   - Ready to Cook: ${responseData['readyToCook']?.length ?? 0}');
    debugPrint('   - Almost Ready: ${responseData['almostReady']?.length ?? 0}');

    // Step 2: Try Foundation Models on iOS (clean enrichment)
    if (Platform.isIOS) {
      try {
        debugPrint('🍎 Attempting Foundation Models (CLEAN approach)...');

        final result = await platform
            .invokeMethod<String>('generateRecommendationsClean', responseData);

        if (result != null && result.isNotEmpty) {
          final resultData = json.decode(result);
          _currentRecommendation = StructuredAIRecommendation.fromJson(
            resultData,
          );

          debugPrint('✅ Foundation Models success! (CLEAN)');
          debugPrint(
            '🍽️ Ready to cook: ${_currentRecommendation!.readyToCook.length}',
          );
          debugPrint(
            '🛒 Almost ready: ${_currentRecommendation!.almostReady.length}',
          );

          notifyListeners();
          return;
        }
      } on PlatformException catch (e) {
        debugPrint('⚠️ Foundation Models error (clean): ${e.message}');
        debugPrint('   Code: ${e.code}');
        debugPrint('   Details: ${e.details}');
        // Fall through to API
      } catch (e) {
        debugPrint('⚠️ Foundation Models failed (clean): $e');
        // Fall through to API
      }
    }

    // Step 3: Fallback to API
    debugPrint('🌐 Using API fallback...');
    await _generateViaAPI(responseData);
  }

  Future<void> _generateViaAPI(Map<String, dynamic> backendData) async {
    // TODO: Implement API fallback (OpenAI/Claude)
    // For now, set a friendly message instead of throwing error

    debugPrint('💡 API fallback not yet implemented - showing friendly message');

    // Set a tranquilizing message instead of an error
    _currentRecommendation = null; // No recommendations available
    _setError(
      'notEnoughRecipes', // Special error code for friendly message
    );
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
