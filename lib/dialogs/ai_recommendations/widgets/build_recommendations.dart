import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/ai_recipe_card.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/ai_response_sections.dart';
import 'package:ai_cook_project/providers/ai_recommendations_provider.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:flutter/cupertino.dart';
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
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.mutedGreen.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              ),
            ],
            border: Border.all(
              color: AppColors.mutedGreen.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.mutedGreen.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  CupertinoIcons.checkmark_alt,
                  color: AppColors.mutedGreen,
                  size: 14,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Successfully analyzed ${recommendation.totalRecipesConsidered} recipes in ${recommendation.processingTime}ms',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.button.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ],
          ),
        ),
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
