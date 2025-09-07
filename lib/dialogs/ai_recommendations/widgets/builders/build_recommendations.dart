import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/sections/ai_almostrecipe_card.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/sections/ai_greeting_section.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/sections/ai_readyrecipe_card.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/sections/ai_conclusion_section.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/sections/ai_shoppingsuggest_section.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/sections/ai_subst_section.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/utils/recipe_finder.dart';
import 'package:ai_cook_project/models/ai_response_model.dart';
import 'package:flutter/material.dart';

class RecommendationsBuilder extends StatelessWidget {
  final StructuredAIRecommendation recommendation;

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
            AIGreetingSection(
              greeting:
                  'Welcome back 👋 Pantry is ready 🧺. Say the vibe—fast ⏱️, vegan 🌱, or high‑protein 💪—and I’ll serve up recipes you’ll love 🍳✨',
            ),

            _buildRecipeCards(
              context,
              recommendation.readyToCook,
              recommendation.almostReady,
            ),

            const SizedBox(height: 20),

            // Almost ready recipes
            // AIAlmostReadySection(content: recommendation.almostReady),

            // Shopping suggestions
            AIShoppingSuggestionsSection(
              suggestions: recommendation.shoppingSuggestions,
            ),

            // Substitutions
            AISubstitutionsSection(
              substitutions: recommendation.possibleSubstitutions,
            ),

            // Conclusion
            AIConclusionSection(
              conclusion:
                  'Bon appétit 😋 I’m here if you want tweaks or another round ✨',
            ),
          ],
        ),
      ],
    );
  }
}

Widget _buildRecipeCards(
  BuildContext context,
  List<AIRecipeMinimal> readyToCook,
  List<AIAlmostReadyRecipe> almostReadyList,
) {
  final readyModels =
      readyToCook.map((aiRecipe) {
        final recipe = RecipeFinderService.findOrThrow(
          context: context,
          id: aiRecipe.id,
        );
        return CombinedRecipeViewModel(
          recipe: recipe,
          description: aiRecipe.description,
        );
      }).toList();

  final almostModels =
      almostReadyList.map((aiRecipe) {
        final recipe = RecipeFinderService.findOrThrow(
          context: context,
          id: aiRecipe.id,
        );
        return CombinedRecipeViewModel(
          recipe: recipe,
          description: aiRecipe.description,
          missingIngredients:
              aiRecipe.missingIngredients
                  .map((name) => MissingIngredientInfo(name: name))
                  .toList(),
          missingCount: aiRecipe.missingIngredients.length,
        );
      }).toList();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (readyModels.isNotEmpty) ...[
        Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 20),
            const SizedBox(width: 8),
            Text(
              'Ready to Cook (${readyModels.length})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...readyModels.map((vm) => AIReadyToCookCard(viewModel: vm)),
      ],
      if (almostModels.isNotEmpty) ...[
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.shopping_cart, color: Colors.orange, size: 20),
            const SizedBox(width: 8),
            Text(
              'Almost Ready (${almostModels.length})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...almostModels.map((vm) => AIAlmostReadyCard(viewModel: vm)),
      ],
    ],
  );
}
