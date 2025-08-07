class IngredientQuantity {
  final String name;
  final String quantity;

  IngredientQuantity({required this.name, required this.quantity});

  factory IngredientQuantity.fromJson(Map<String, dynamic> json) {
    return IngredientQuantity(
      name: json['name'] as String,
      quantity: json['quantity'] as String,
    );
  }
}

class AIRecipeMinimal {
  final String title;
  final int timeMinutes;
  final String difficulty;
  final List<String> tags;
  final String description;
  final List<IngredientQuantity> ingredients;
  final List<String> steps;

  AIRecipeMinimal({
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
      title: json['title'] as String,
      timeMinutes: json['time_minutes'] as int,
      difficulty: json['difficulty'] as String,
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      description: json['description'] as String,
      ingredients:
          (json['ingredients'] as List<dynamic>)
              .map(
                (item) =>
                    IngredientQuantity.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
      steps: (json['steps'] as List<dynamic>).cast<String>(),
    );
  }
}

class AIShoppingSuggestion {
  final String name;
  final String reason;

  AIShoppingSuggestion({required this.name, required this.reason});

  factory AIShoppingSuggestion.fromJson(Map<String, dynamic> json) {
    return AIShoppingSuggestion(
      name: json['name'] as String,
      reason: json['reason'] as String,
    );
  }
}

class AIAlmostReadyRecipe {
  final String title;
  final String description;
  final List<String> missingIngredients;
  final List<AIShoppingSuggestion> shoppingSuggestions;
  final int timeMinutes;
  final String difficulty;
  final List<String> tags;

  AIAlmostReadyRecipe({
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
      title: json['title'] as String,
      description: json['description'] as String,
      timeMinutes: json['time_minutes'] as int,
      difficulty: json['difficulty'] as String,
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      missingIngredients:
          (json['missing_ingredients'] as List<dynamic>).cast<String>(),
      shoppingSuggestions:
          (json['shopping_suggestions'] as List<dynamic>)
              .map(
                (item) =>
                    AIShoppingSuggestion.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
    );
  }
}

class AISubstitution {
  final String original;
  final List<String> alternatives;

  AISubstitution({required this.original, required this.alternatives});

  factory AISubstitution.fromJson(Map<String, dynamic> json) {
    return AISubstitution(
      original: json['original'] as String,
      alternatives: (json['alternatives'] as List<dynamic>).cast<String>(),
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
  final List<RecipeWithMissingIngredients>? recipesWithMissingInfo;
  final int? totalRecipesConsidered;

  StructuredAIRecommendation({
    required this.readyToCook,
    required this.almostReady,
    required this.shoppingSuggestions,
    required this.possibleSubstitutions,
    this.processingTime,
    this.filteredRecipes,
    this.recipesWithMissingInfo,
    this.totalRecipesConsidered,
  });

  factory StructuredAIRecommendation.fromJson(Map<String, dynamic> json) {
    return StructuredAIRecommendation(
      readyToCook:
          (json['ready_to_cook'] as List<dynamic>)
              .map(
                (item) =>
                    AIRecipeMinimal.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
      almostReady:
          (json['almost_ready'] as List<dynamic>)
              .map(
                (item) =>
                    AIAlmostReadyRecipe.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
      shoppingSuggestions:
          (json['shopping_suggestions'] as List<dynamic>)
              .map(
                (item) =>
                    AIShoppingSuggestion.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
      possibleSubstitutions:
          (json['possible_substitutions'] as List<dynamic>)
              .map(
                (item) => AISubstitution.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
      processingTime: json['processingTime'] as int?,
      filteredRecipes: json['filteredRecipes'] as List<dynamic>?,
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
      totalRecipesConsidered: json['totalRecipesConsidered'] as int?,
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

// Keep the original models for backward compatibility
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
