import 'package:flutter/foundation.dart';

class AIRecipeRecommendation {
  final String name;
  final String? time;
  final String? difficulty;
  final List<String> tags;
  final String description;
  final bool allIngredientsAvailable;

  AIRecipeRecommendation({
    required this.name,
    this.time,
    this.difficulty,
    required this.tags,
    required this.description,
    required this.allIngredientsAvailable,
  });
}

class AIShoppingSuggestion {
  final String ingredient;
  final String description;

  AIShoppingSuggestion({required this.ingredient, required this.description});
}

class AISubstitution {
  final String ingredient;
  final String substitutes;

  AISubstitution({required this.ingredient, required this.substitutes});
}

class ParsedAIResponse {
  final String greeting;
  final List<AIRecipeRecommendation> readyToCookRecipes;
  final String almostReadySection;
  final List<AIShoppingSuggestion> shoppingSuggestions;
  final List<AISubstitution> substitutions;
  final String conclusion;

  ParsedAIResponse({
    required this.greeting,
    required this.readyToCookRecipes,
    required this.almostReadySection,
    required this.shoppingSuggestions,
    required this.substitutions,
    required this.conclusion,
  });

  static ParsedAIResponse parse(String rawResponse) {
    try {
      // Debug: Print the raw response
      debugPrint('🔍 DEBUG: Raw AI Response (first 200 chars):\n$rawResponse');

      // Clean response and extract greeting
      final cleanResponse =
          rawResponse
              .replaceAll(RegExp(r'###'), '')
              .replaceAll(RegExp(r'---'), '')
              .trim();

      // Extract greeting (content before first emoji section WITH colons)
      final greetingMatch = RegExp(
        r'^(.*?)(?=🍳\s*\*\*Ready-to-cook recipes\*\*:|🛒\s*\*\*Almost-ready recipes\*\*:|💡\s*\*\*Smart shopping suggestions\*\*:|🔄\s*\*\*Possible substitutions\*\*:)',
        dotAll: true,
        caseSensitive: false,
      ).firstMatch(cleanResponse);
      String greeting = greetingMatch?.group(1)?.trim() ?? '';

      debugPrint(
        '🔍 DEBUG: Extracted greeting: "${greeting.length > 50 ? greeting.substring(0, 50) + "..." : greeting}"',
      );

      // Extract ready-to-cook recipes section (with colon)
      final readyToCookMatch = RegExp(
        r'🍳\s*\*\*Ready-to-cook recipes\*\*:\s*(.*?)(?=🛒|💡|🔄|$)',
        dotAll: true,
        caseSensitive: false,
      ).firstMatch(cleanResponse);
      final readyToCookText = readyToCookMatch?.group(1)?.trim() ?? '';
      debugPrint(
        '🔍 DEBUG: Ready-to-cook text: "${readyToCookText.length > 100 ? readyToCookText.substring(0, 100) + "..." : readyToCookText}"',
      );
      final readyToCookRecipes = _parseReadyToCookRecipes(readyToCookText);
      debugPrint(
        '🔍 DEBUG: Ready-to-cook recipes found: ${readyToCookRecipes.length}',
      );

      // Extract almost-ready section (with colon)
      final almostReadyMatch = RegExp(
        r'🛒\s*\*\*Almost-ready recipes\*\*:\s*(.*?)(?=💡|🔄|$)',
        dotAll: true,
        caseSensitive: false,
      ).firstMatch(cleanResponse);
      final almostReadySection = almostReadyMatch?.group(1)?.trim() ?? '';
      debugPrint(
        '🔍 DEBUG: Almost-ready section: "${almostReadySection.length > 100 ? almostReadySection.substring(0, 100) + "..." : almostReadySection}"',
      );

      // Extract shopping suggestions (with colon)
      final shoppingSuggestionsMatch = RegExp(
        r'💡\s*\*\*Smart shopping suggestions\*\*:\s*(.*?)(?=🔄|$)',
        dotAll: true,
        caseSensitive: false,
      ).firstMatch(cleanResponse);
      final shoppingSuggestionsText =
          shoppingSuggestionsMatch?.group(1)?.trim() ?? '';
      debugPrint(
        '🔍 DEBUG: Shopping suggestions text: "${shoppingSuggestionsText.length > 100 ? shoppingSuggestionsText.substring(0, 100) + "..." : shoppingSuggestionsText}"',
      );
      final shoppingSuggestions = _parseShoppingSuggestions(
        shoppingSuggestionsText,
      );
      debugPrint(
        '🔍 DEBUG: Shopping suggestions found: ${shoppingSuggestions.length}',
      );

      // Extract substitutions (with colon)
      final substitutionsMatch = RegExp(
        r'🔄\s*\*\*Possible substitutions\*\*:\s*(.*?)(?=Happy cooking|Feel free|Enjoy|$)',
        dotAll: true,
        caseSensitive: false,
      ).firstMatch(cleanResponse);
      final substitutionsText = substitutionsMatch?.group(1)?.trim() ?? '';
      debugPrint(
        '🔍 DEBUG: Substitutions text: "${substitutionsText.length > 100 ? substitutionsText.substring(0, 100) + "..." : substitutionsText}"',
      );
      final substitutions = _parseSubstitutions(substitutionsText);
      debugPrint('🔍 DEBUG: Substitutions found: ${substitutions.length}');

      // Extract conclusion (common ending phrases)
      final conclusionMatch = RegExp(
        r'((?:Happy cooking|Feel free|I hope you).*?)$',
        dotAll: true,
        caseSensitive: false,
      ).firstMatch(cleanResponse);
      final conclusion = conclusionMatch?.group(1)?.trim() ?? '';
      debugPrint(
        '🔍 DEBUG: Conclusion: "${conclusion.length > 50 ? conclusion.substring(0, 50) + "..." : conclusion}"',
      );

      return ParsedAIResponse(
        greeting:
            greeting.isNotEmpty
                ? greeting
                : 'Welcome to your personalized cooking experience! 🍳',
        readyToCookRecipes: readyToCookRecipes,
        almostReadySection:
            almostReadySection.isNotEmpty
                ? almostReadySection
                : 'Let me analyze your ingredients to find recipes you can make with what you have!',
        shoppingSuggestions: shoppingSuggestions,
        substitutions: substitutions,
        conclusion:
            conclusion.isNotEmpty
                ? conclusion
                : 'Happy cooking! Let me know if you need any help with these recipes! 👨‍🍳✨',
      );
    } catch (e) {
      // If parsing fails, return a basic structure with friendly fallbacks
      return ParsedAIResponse(
        greeting: 'Welcome to your personalized cooking experience! 🍳',
        readyToCookRecipes: [],
        almostReadySection:
            'Let me analyze your ingredients to find the perfect recipes for you!',
        shoppingSuggestions: [],
        substitutions: [],
        conclusion: 'Happy cooking! Let me know if you need any help! 👨‍🍳✨',
      );
    }
  }

  static List<AIRecipeRecommendation> _parseReadyToCookRecipes(String text) {
    final recipes = <AIRecipeRecommendation>[];

    // Match recipe blocks: "- **Recipe Name**" followed by details and metadata
    final recipeMatches = RegExp(
      r'- \*\*(.*?)\*\*(.*?)(?=- \*\*|$)',
      dotAll: true,
    ).allMatches(text);

    for (final match in recipeMatches) {
      final name = match.group(1)?.trim() ?? '';
      final details = match.group(2)?.trim() ?? '';

      // Extract time (various formats)
      final timeMatch = RegExp(
        r'(?:⏱️\s*Time:|Time:)\s*([^\n]*)',
        dotAll: true,
      ).firstMatch(details);
      final time = timeMatch?.group(1)?.trim();

      // Extract difficulty (various formats)
      final difficultyMatch = RegExp(
        r'(?:🎯\s*Difficulty:|Difficulty:)\s*([^\n]*)',
        dotAll: true,
      ).firstMatch(details);
      final difficulty = difficultyMatch?.group(1)?.trim();

      // Extract tags (various formats)
      final tagsMatch = RegExp(
        r'(?:🏷️\s*Tags:|Tags:)\s*([^\n]*)',
        dotAll: true,
      ).firstMatch(details);
      final tagsText = tagsMatch?.group(1)?.trim() ?? '';
      final tags =
          tagsText
              .split(',')
              .map((tag) => tag.trim())
              .where((tag) => tag.isNotEmpty)
              .toList();

      // Extract description - first paragraph after recipe name
      String description = '';
      final lines = details.split('\n');
      for (final line in lines) {
        final cleanLine = line.trim();
        if (cleanLine.isNotEmpty &&
            !cleanLine.startsWith('⏱️') &&
            !cleanLine.startsWith('🎯') &&
            !cleanLine.startsWith('🏷️') &&
            !cleanLine.startsWith('🥘') &&
            !cleanLine.contains('Time:') &&
            !cleanLine.contains('Difficulty:') &&
            !cleanLine.contains('Tags:')) {
          description = cleanLine;
          break;
        }
      }

      // For ready-to-cook recipes, assume all ingredients are available
      final allIngredientsAvailable = true;

      if (name.isNotEmpty) {
        recipes.add(
          AIRecipeRecommendation(
            name: name,
            time: time,
            difficulty: difficulty,
            tags: tags,
            description:
                description.isNotEmpty
                    ? description
                    : 'A delicious recipe ready to cook!',
            allIngredientsAvailable: allIngredientsAvailable,
          ),
        );
      }
    }

    return recipes;
  }

  static List<AIShoppingSuggestion> _parseShoppingSuggestions(String text) {
    final suggestions = <AIShoppingSuggestion>[];

    // First try numbered colon format: "1. **Ingredient:** Description"
    final numberedColonMatches = RegExp(
      r'\d+\.\s*\*\*(.*?)\*\*:\s*(.*?)(?=\n\d+\.|\n\n|$)',
      dotAll: true,
    ).allMatches(text);

    for (final match in numberedColonMatches) {
      final ingredient = match.group(1)?.trim() ?? '';
      final description = match.group(2)?.trim() ?? '';

      if (ingredient.isNotEmpty && description.isNotEmpty) {
        suggestions.add(
          AIShoppingSuggestion(
            ingredient: ingredient,
            description: description,
          ),
        );
      }
    }

    // If no numbered colon matches, try dash format: "- **Ingredient** - Description"
    if (suggestions.isEmpty) {
      final dashMatches = RegExp(
        r'[-•]\s*\*\*(.*?)\*\*\s*[-–]\s*(.*?)(?=\n[-•]|\n\n|$)',
        dotAll: true,
      ).allMatches(text);

      for (final match in dashMatches) {
        final ingredient = match.group(1)?.trim() ?? '';
        final description = match.group(2)?.trim() ?? '';

        if (ingredient.isNotEmpty && description.isNotEmpty) {
          suggestions.add(
            AIShoppingSuggestion(
              ingredient: ingredient,
              description: description,
            ),
          );
        }
      }
    }

    // If still no matches, try numbered dash format: "1. **Ingredient** - Description"
    if (suggestions.isEmpty) {
      final numberedDashMatches = RegExp(
        r'\d+\.\s*\*\*(.*?)\*\*\s*[-–]\s*(.*?)(?=\n\d+\.|$)',
        dotAll: true,
      ).allMatches(text);

      for (final match in numberedDashMatches) {
        final ingredient = match.group(1)?.trim() ?? '';
        final description = match.group(2)?.trim() ?? '';

        if (ingredient.isNotEmpty && description.isNotEmpty) {
          suggestions.add(
            AIShoppingSuggestion(
              ingredient: ingredient,
              description: description,
            ),
          );
        }
      }
    }

    // If still no matches, try bullet colon format: "- **Ingredient**: Description"
    if (suggestions.isEmpty) {
      final bulletColonMatches = RegExp(
        r'[-•]\s*\*\*(.*?)\*\*[:\s]*\s*(.*?)(?=\n[-•]|$)',
        dotAll: true,
      ).allMatches(text);

      for (final match in bulletColonMatches) {
        final ingredient = match.group(1)?.trim() ?? '';
        final description = match.group(2)?.trim() ?? '';

        if (ingredient.isNotEmpty && description.isNotEmpty) {
          suggestions.add(
            AIShoppingSuggestion(
              ingredient: ingredient,
              description: description,
            ),
          );
        }
      }
    }

    return suggestions;
  }

  static List<AISubstitution> _parseSubstitutions(String text) {
    final substitutions = <AISubstitution>[];

    // First try numbered colon format: "1. **Ingredient:** Description"
    final numberedColonMatches = RegExp(
      r'\d+\.\s*\*\*(.*?)\*\*:\s*(.*?)(?=\n\d+\.|\n\n|$)',
      dotAll: true,
    ).allMatches(text);

    for (final match in numberedColonMatches) {
      final ingredient = match.group(1)?.trim() ?? '';
      final substitutes = match.group(2)?.trim() ?? '';

      if (ingredient.isNotEmpty && substitutes.isNotEmpty) {
        substitutions.add(
          AISubstitution(ingredient: ingredient, substitutes: substitutes),
        );
      }
    }

    // If no numbered colon matches, try natural language: "- **Ingredient** could be replaced with..."
    if (substitutions.isEmpty) {
      final naturalMatches = RegExp(
        r'[-•]\s*\*\*(.*?)\*\*\s*(?:could be|can be)\s+(?:replaced|substituted|swapped)\s+with\s+(.*?)(?=\n[-•]|\n\n|$)',
        dotAll: true,
        caseSensitive: false,
      ).allMatches(text);

      for (final match in naturalMatches) {
        final ingredient = match.group(1)?.trim() ?? '';
        final substitutes = match.group(2)?.trim() ?? '';

        if (ingredient.isNotEmpty && substitutes.isNotEmpty) {
          substitutions.add(
            AISubstitution(ingredient: ingredient, substitutes: substitutes),
          );
        }
      }
    }

    // If still no matches, try numbered natural language: "1. **Ingredient** can be substituted..."
    if (substitutions.isEmpty) {
      final numberedNaturalMatches = RegExp(
        r'\d+\.\s*\*\*(.*?)\*\*\s*(?:can be|could be)\s+(?:substituted|swapped|replaced)\s*with\s*(.*?)(?=\n\d+\.|$)',
        dotAll: true,
        caseSensitive: false,
      ).allMatches(text);

      for (final match in numberedNaturalMatches) {
        final ingredient = match.group(1)?.trim() ?? '';
        final substitutes = match.group(2)?.trim() ?? '';

        if (ingredient.isNotEmpty && substitutes.isNotEmpty) {
          substitutions.add(
            AISubstitution(ingredient: ingredient, substitutes: substitutes),
          );
        }
      }
    }

    // If still no matches, try bullet colon format: "- **Ingredient**: substitutes"
    if (substitutions.isEmpty) {
      final bulletColonMatches = RegExp(
        r'[-•]\s*\*\*(.*?)\*\*[:\s]*\s*(.*?)(?=\n[-•]|$)',
        dotAll: true,
      ).allMatches(text);

      for (final match in bulletColonMatches) {
        final ingredient = match.group(1)?.trim() ?? '';
        final substitutes = match.group(2)?.trim() ?? '';

        if (ingredient.isNotEmpty && substitutes.isNotEmpty) {
          substitutions.add(
            AISubstitution(ingredient: ingredient, substitutes: substitutes),
          );
        }
      }
    }

    return substitutions;
  }
}
