import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/sections/ai_almostready_section.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/sections/ai_greeting_section.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/sections/ai_recipe_card.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/sections/ai_conclusion_section.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/sections/ai_shoppingsuggest_section.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/sections/ai_subst_section.dart';
import 'package:ai_cook_project/providers/ai_recommendations_provider.dart';
import 'package:flutter/material.dart';

class RecommendationsBuilder extends StatelessWidget {
  final AIRecommendation recommendation;

  const RecommendationsBuilder({super.key, required this.recommendation});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Success indicator with stats - Enhanced design
        const SizedBox(height: 16),

        // Structured AI Response Sections
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            AIGreetingSection(greeting: recommendation.parsedResponse.greeting),

            // Almost ready recipes
            AIAlmostReadySection(
              content: recommendation.parsedResponse.almostReadySection,
            ),

            // Recipe cards with missing ingredient info - Moved here between sections
            if (recommendation.recipesWithMissingInfo != null &&
                recommendation.recipesWithMissingInfo!.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildRecipeCards(recommendation.recipesWithMissingInfo!),
              const SizedBox(height: 20),
            ],

            // Shopping suggestions
            AIShoppingSuggestionsSection(
              suggestions: recommendation.parsedResponse.shoppingSuggestions,
            ),

            // Substitutions
            AISubstitutionsSection(
              substitutions: recommendation.parsedResponse.substitutions,
            ),

            // Conclusion
            AIConclusionSection(
              conclusion: recommendation.parsedResponse.conclusion,
            ),
          ],
        ),
      ],
    );
  }
}

Widget _buildRecipeCards(
  List<RecipeWithMissingIngredients> recipesWithMissingInfo,
) {
  // Group recipes by missing count
  final perfectMatches = <RecipeWithMissingIngredients>[];
  final almostReady = <RecipeWithMissingIngredients>[];

  for (final recipeData in recipesWithMissingInfo) {
    if (recipeData.missingCount == 0) {
      perfectMatches.add(recipeData);
    } else {
      almostReady.add(recipeData);
    }
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Perfect matches section
      if (perfectMatches.isNotEmpty) ...[
        Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 20),
            const SizedBox(width: 8),
            Text(
              'Ready to Cook (${perfectMatches.length})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...perfectMatches.map(
          (recipeData) => AIRecipeCard(recipeWithMissingInfo: recipeData),
        ),
      ],

      // Almost ready section
      if (almostReady.isNotEmpty) ...[
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.shopping_cart, color: Colors.orange, size: 20),
            const SizedBox(width: 8),
            Text(
              'Almost Ready (${almostReady.length})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...almostReady.map(
          (recipeData) => AIRecipeCard(recipeWithMissingInfo: recipeData),
        ),
      ],
    ],
  );
}
