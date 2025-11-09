// lib/services/ai_recommendation_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ai_cook_project/models/recipe_tag_model.dart';

class AIRecommendationService {
  final String baseUrl = 'http://127.0.0.1:3000';

  /// NEW CLEAN APPROACH: Backend pre-computes everything
  Future<Map<String, dynamic>> fetchStructuredRecipesForAI({
    required String userId,
    required List<RecipeTag> preferredTags,
    int? maxCookingTimeMinutes,
    String? preferredDifficulty,
    Map<String, bool>? dietaryRestrictions,
  }) async {
    final url = '$baseUrl/ai-recommendations/$userId/for-llm-clean';

    print('🌐 Fetching STRUCTURED recipes from: $url');
    print('📊 Preferences:');
    print('   - Tags: ${preferredTags.map((t) => t.name).join(", ")}');
    print('   - Max time: ${maxCookingTimeMinutes ?? "unlimited"}min');
    print('   - Difficulty: ${preferredDifficulty ?? "any"}');

    final requestBody = {
      'preferredTags': preferredTags.map((t) => t.name).toList(),
      if (maxCookingTimeMinutes != null)
        'maxCookingTimeMinutes': maxCookingTimeMinutes,
      if (preferredDifficulty != null)
        'preferredDifficulty': preferredDifficulty,
      'dietaryRestrictions':
          dietaryRestrictions ??
          {
            'isVegan': false,
            'isVegetarian': false,
            'isGlutenFree': false,
            'isLactoseFree': false,
          },
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        print('✅ Success!');
        print('   - Ready to Cook: ${data['readyToCook']?.length ?? 0}');
        print('   - Almost Ready: ${data['almostReady']?.length ?? 0}');

        return data;
      } else if (response.statusCode == 400) {
        final errorData = json.decode(response.body);
        if (errorData['error'] == 'NO_INGREDIENTS') {
          throw NoIngredientsException(
            errorData['message'] ?? 'No ingredients available',
          );
        }
        throw Exception(errorData['message'] ?? 'Bad request');
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Session expired. Please log in again.');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching structured recipes: $e');
      rethrow;
    }
  }
}

// Custom exceptions
class NoIngredientsException implements Exception {
  final String message;
  NoIngredientsException(this.message);

  @override
  String toString() => message;
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);

  @override
  String toString() => message;
}
