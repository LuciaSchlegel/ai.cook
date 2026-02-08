import 'dart:convert';
import 'package:http/http.dart' as http;

/// Central HTTP client for AI backend endpoints (Claude API via server)
class AIService {
  final String baseUrl = 'http://127.0.0.1:3000';

  /// Generate ingredient substitutions
  Future<Map<String, dynamic>> getSubstitutions({
    required String ingredient,
    String? recipeName,
    List<String>? dietaryRestrictions,
  }) async {
    return _postAssist({
      'type': 'substitutions',
      'ingredient': ingredient,
      if (recipeName != null) 'recipeName': recipeName,
      if (dietaryRestrictions != null && dietaryRestrictions.isNotEmpty)
        'dietaryRestrictions': dietaryRestrictions,
    });
  }

  /// Adapt a recipe for dietary needs
  Future<Map<String, dynamic>> adaptDiet({
    required String recipeName,
    required List<String> ingredients,
    required List<String> dietaryNeeds,
  }) async {
    return _postAssist({
      'type': 'diet_adaptation',
      'recipeName': recipeName,
      'ingredients': ingredients,
      'dietaryNeeds': dietaryNeeds,
    });
  }

  /// Enrich pre-computed recipes with AI reasoning and tips
  Future<Map<String, dynamic>> enrichRecipes({
    required String userId,
    required Map<String, dynamic> preComputedData,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ai-recommendations/$userId/enrich'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(preComputedData),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    }
    throw AIServiceException(
      'Enrichment failed: ${response.statusCode}',
      'SERVER_ERROR',
    );
  }

  Future<Map<String, dynamic>> _postAssist(Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ai/assist'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data['success'] == true) {
        return data['data'] as Map<String, dynamic>;
      }
      throw AIServiceException(
        data['error']?.toString() ?? 'Unknown error',
        data['code']?.toString() ?? 'UNKNOWN',
      );
    } else if (response.statusCode == 400) {
      final data = json.decode(response.body);
      throw AIServiceException(
        data['error']?.toString() ?? 'Bad request',
        data['code']?.toString() ?? 'VALIDATION_ERROR',
      );
    }
    throw AIServiceException('Server error: ${response.statusCode}', 'SERVER_ERROR');
  }
}

class AIServiceException implements Exception {
  final String message;
  final String code;
  AIServiceException(this.message, this.code);

  @override
  String toString() => message;
}
