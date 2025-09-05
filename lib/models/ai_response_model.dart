import 'package:ai_cook_project/models/recipe_model.dart';

class IngredientQuantity {
  final String name;
  final String quantity;

  IngredientQuantity({required this.name, required this.quantity});

  factory IngredientQuantity.fromJson(Map<String, dynamic> json) {
    return IngredientQuantity(
      name: (json['name'] ?? '').toString(),
      quantity: (json['quantity'] ?? '').toString(),
    );
  }
}

class AIRecipeMinimal {
  final int id;
  final String title;
  final int timeMinutes;
  final String difficulty;
  final List<String> tags;
  final String description;
  final List<IngredientQuantity> ingredients;
  final List<String> steps;

  AIRecipeMinimal({
    required this.id,
    required this.title,
    required this.timeMinutes,
    required this.difficulty,
    required this.tags,
    required this.description,
    required this.ingredients,
    required this.steps,
  });

  factory AIRecipeMinimal.fromJson(Map<String, dynamic> json) {
    return AIRecipeMinimal(
      id: _asInt(json['id']),
      title: (json['title'] ?? '').toString(),
      timeMinutes: _asInt(json['time_minutes']),
      difficulty: (json['difficulty'] ?? '').toString(),
      tags:
          ((json['tags'] as List?)?.map((e) => e.toString()).toList()) ??
          const [],
      description: (json['description'] ?? '').toString(),
      ingredients:
          ((json['ingredients'] as List?)
              ?.map(
                (item) => IngredientQuantity.fromJson(
                  (item as Map?)?.cast<String, dynamic>() ?? const {},
                ),
              )
              .toList()) ??
          const [],
      steps:
          ((json['steps'] as List?)?.map((e) => e.toString()).toList()) ??
          const [],
    );
  }
}

class AIShoppingSuggestion {
  final String name;
  final String reason;

  AIShoppingSuggestion({required this.name, required this.reason});

  factory AIShoppingSuggestion.fromJson(Map<String, dynamic> json) {
    return AIShoppingSuggestion(
      name: (json['name'] ?? '').toString(),
      reason: (json['reason'] ?? '').toString(),
    );
  }
}

class AIAlmostReadyRecipe {
  final int id;
  final String title;
  final String description;
  final List<String> missingIngredients;
  final List<AIShoppingSuggestion> shoppingSuggestions;
  final int timeMinutes;
  final String difficulty;
  final List<String> tags;

  AIAlmostReadyRecipe({
    required this.id,
    required this.title,
    required this.description,
    required this.missingIngredients,
    required this.shoppingSuggestions,
    required this.timeMinutes,
    required this.difficulty,
    required this.tags,
  });

  factory AIAlmostReadyRecipe.fromJson(Map<String, dynamic> json) {
    return AIAlmostReadyRecipe(
      id: _asInt(json['id']),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      timeMinutes: _asInt(json['time_minutes']),
      difficulty: (json['difficulty'] ?? '').toString(),
      tags:
          ((json['tags'] as List?)?.map((e) => e.toString()).toList()) ??
          const [],
      missingIngredients:
          ((json['missing_ingredients'] as List?)
              ?.map((e) => e.toString())
              .toList()) ??
          const [],
      shoppingSuggestions:
          ((json['shopping_suggestions'] as List?)
              ?.map(
                (item) => AIShoppingSuggestion.fromJson(
                  (item as Map?)?.cast<String, dynamic>() ?? const {},
                ),
              )
              .toList()) ??
          const [],
    );
  }
}

class AISubstitution {
  final String original;
  final List<String> alternatives;

  AISubstitution({required this.original, required this.alternatives});

  factory AISubstitution.fromJson(Map<String, dynamic> json) {
    return AISubstitution(
      original: (json['original'] ?? '').toString(),
      alternatives:
          ((json['alternatives'] as List?)
              ?.map((e) => e.toString())
              .toList()) ??
          const [],
    );
  }
}

// Main structured AI response model
class StructuredAIRecommendation {
  final List<AIRecipeMinimal> readyToCook;
  final List<AIAlmostReadyRecipe> almostReady;
  final List<AIShoppingSuggestion> shoppingSuggestions;
  final List<AISubstitution> possibleSubstitutions;
  final int? processingTime;

  // Legacy fields for backward compatibility
  final List<dynamic>? filteredRecipes;
  final int? totalRecipesConsidered;

  StructuredAIRecommendation({
    required this.readyToCook,
    required this.almostReady,
    required this.shoppingSuggestions,
    required this.possibleSubstitutions,
    this.processingTime,
    this.filteredRecipes,
    this.totalRecipesConsidered,
  });

  factory StructuredAIRecommendation.fromJson(Map<String, dynamic> json) {
    return StructuredAIRecommendation(
      readyToCook:
          ((json['ready_to_cook'] as List?)
              ?.map(
                (item) => AIRecipeMinimal.fromJson(
                  (item as Map?)?.cast<String, dynamic>() ?? const {},
                ),
              )
              .toList()) ??
          const [],
      almostReady:
          ((json['almost_ready'] as List?)
              ?.map(
                (item) => AIAlmostReadyRecipe.fromJson(
                  (item as Map?)?.cast<String, dynamic>() ?? const {},
                ),
              )
              .toList()) ??
          const [],
      shoppingSuggestions:
          ((json['shopping_suggestions'] as List?)
              ?.map(
                (item) => AIShoppingSuggestion.fromJson(
                  (item as Map?)?.cast<String, dynamic>() ?? const {},
                ),
              )
              .toList()) ??
          const [],
      possibleSubstitutions:
          ((json['possible_substitutions'] as List?)
              ?.map(
                (item) => AISubstitution.fromJson(
                  (item as Map?)?.cast<String, dynamic>() ?? const {},
                ),
              )
              .toList()) ??
          const [],
      processingTime: _asNullableInt(json['processingTime']),
      filteredRecipes:
          json['filteredRecipes'] is List
              ? (json['filteredRecipes'] as List).toList()
              : null,
      totalRecipesConsidered: _asNullableInt(json['totalRecipesConsidered']),
    );
  }

  // Computed properties for easy access
  bool get hasReadyToCookRecipes => readyToCook.isNotEmpty;
  bool get hasAlmostReadyRecipes => almostReady.isNotEmpty;
  bool get hasShoppingSuggestions => shoppingSuggestions.isNotEmpty;
  bool get hasSubstitutions => possibleSubstitutions.isNotEmpty;
  bool get hasAnyRecommendations =>
      hasReadyToCookRecipes || hasAlmostReadyRecipes;

  int get totalRecommendations => readyToCook.length + almostReady.length;
}

class CombinedRecipeViewModel {
  final Recipe recipe;
  final String? description;
  final int missingCount;
  final List<MissingIngredientInfo>? missingIngredients;

  const CombinedRecipeViewModel({
    required this.recipe,
    this.description,
    this.missingCount = 0,
    this.missingIngredients,
  });
}

class MissingIngredientInfo {
  final String name;
  final double? quantity;
  final String? unit;

  const MissingIngredientInfo({required this.name, this.quantity, this.unit});
}

// Helpers
int _asInt(dynamic value, {int defaultValue = 0}) {
  if (value is int) return value;
  if (value is double) return value.round();
  if (value is String) return int.tryParse(value) ?? defaultValue;
  return defaultValue;
}

int? _asNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.round();
  if (value is String) return int.tryParse(value);
  return null;
}

// deprecated - original models for backward compatibility
// class RecipeWithMissingIngredients {
//   final Map<String, dynamic> recipe;
//   final List<Map<String, dynamic>> missingIngredients;
//   final int missingCount;
//   final int availableCount;
//   final int totalCount;
//   final double matchPercentage;

//   RecipeWithMissingIngredients({
//     required this.recipe,
//     required this.missingIngredients,
//     required this.missingCount,
//     required this.availableCount,
//     required this.totalCount,
//     required this.matchPercentage,
//   });

//   factory RecipeWithMissingIngredients.fromJson(Map<String, dynamic> json) {
//     return RecipeWithMissingIngredients(
//       recipe: json['recipe'] as Map<String, dynamic>,
//       missingIngredients:
//           (json['missingIngredients'] as List<dynamic>)
//               .cast<Map<String, dynamic>>(),
//       missingCount: json['missingCount'] as int,
//       availableCount: json['availableCount'] as int,
//       totalCount: json['totalCount'] as int,
//       matchPercentage: (json['matchPercentage'] as num).toDouble(),
//     );
//   }
// }

// Legacy model - deprecated
// class AIRecommendation {
//   final String recommendations;
//   final ParsedAIResponse parsedResponse;
//   final List<dynamic> filteredRecipes;
//   final List<RecipeWithMissingIngredients>? recipesWithMissingInfo;
//   final int totalRecipesConsidered;
//   final int? processingTime;

//   AIRecommendation({
//     required this.recommendations,
//     required this.parsedResponse,
//     required this.filteredRecipes,
//     this.recipesWithMissingInfo,
//     required this.totalRecipesConsidered,
//     this.processingTime,
//   });

//   factory AIRecommendation.fromJson(Map<String, dynamic> json) {
//     final rawRecommendations = json['recommendations'] as String;
//     final parsedResponse = ParsedAIResponse.parse(rawRecommendations);
//     return AIRecommendation(
//       recommendations: rawRecommendations,
//       parsedResponse: parsedResponse,
//       filteredRecipes: json['filteredRecipes'] as List<dynamic>,
//       recipesWithMissingInfo:
//           json['recipesWithMissingInfo'] != null
//               ? (json['recipesWithMissingInfo'] as List<dynamic>)
//                   .map(
//                     (item) => RecipeWithMissingIngredients.fromJson(
//                       item as Map<String, dynamic>,
//                     ),
//                   )
//                   .toList()
//               : null,
//       totalRecipesConsidered: json['totalRecipesConsidered'] as int,
//       processingTime: json['processingTime'] as int?,
//     );
//   }
// }
