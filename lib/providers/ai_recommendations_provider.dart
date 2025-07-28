import 'dart:convert';
import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final userIngredientsMock = [
  UserIng(
    id: 1,
    uid: "test-user-123",
    quantity: 1,
    ingredient: Ingredient(
      id: 1,
      name: 'chicken',
      category: Category(id: 1, name: 'Meat'),
      tags: [],
      isVegan: false,
      isVegetarian: false,
      isGlutenFree: false,
      isLactoseFree: false,
    ),
    unit: Unit(id: 1, name: 'kilogram', abbreviation: 'kg', type: 'weight'),
  ),

  UserIng(
    id: 2,
    uid: '2',
    ingredient: Ingredient(
      id: 2,
      name: 'Onion',
      category: Category(id: 2, name: 'Vegetable'),
      tags: [],
      isVegan: false,
      isVegetarian: false,
      isGlutenFree: false,
      isLactoseFree: false,
    ),
    quantity: 1,
    unit: Unit(id: 2, name: 'pcs', abbreviation: 'pcs', type: 'count'),
  ),

  UserIng(
    id: 3,
    uid: '3',
    ingredient: Ingredient(
      id: 3,
      name: 'Chicken',
      category: Category(id: 3, name: 'Meat'),
      tags: [],
      isVegan: false,
      isVegetarian: false,
      isGlutenFree: false,
      isLactoseFree: false,
    ),
    quantity: 1,
    unit: Unit(id: 3, name: 'pcs', abbreviation: 'pcs', type: 'count'),
  ),
];

final preferredTagsMock = ['quick', 'healthy'];
final maxCookingTimeMinutesMock = 30;
final preferredDifficultyMock = 'Easy';
final userPreferencesMock = 'I like Mediterranean cuisine';
final numberOfRecipesMock = 5;

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
    required List<UserIng> userIngredients,
    List<String> preferredTags = const [],
    int? maxCookingTimeMinutes,
    String? preferredDifficulty,
    String? userPreferences,
    int numberOfRecipes = 10,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final apiUrl =
          '${dotenv.env['API_URL']}/ai-recommendations/recommendations';

      // final body = {
      //   "userIngredients": userIngredients.map((u) => u.toJson()).toList(),
      //   "preferredTags": preferredTags,
      //   "maxCookingTimeMinutes": maxCookingTimeMinutes,
      //   "preferredDifficulty": preferredDifficulty,
      //   "userPreferences": userPreferences,
      //   "numberOfRecipes": numberOfRecipes,
      // };

      final body = {
        "userIngredients": userIngredientsMock.map((u) => u.toJson()).toList(),
        "preferredTags": preferredTagsMock,
        "maxCookingTimeMinutes": maxCookingTimeMinutesMock,
        "preferredDifficulty": preferredDifficultyMock,
        "userPreferences": userPreferencesMock,
        "numberOfRecipes": numberOfRecipesMock,
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

  void clearRecommendations() {
    _currentRecommendation = null;
    _error = null;
    notifyListeners();
  }
}
