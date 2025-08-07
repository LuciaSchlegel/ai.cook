import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/utils/details_container.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/utils/image_clip.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/utils/recipe_details.dart';
import 'package:ai_cook_project/models/ai_response_model.dart';
import 'package:ai_cook_project/screens/recipes/widgets/recipe_ov_card.dart';
import 'package:flutter/material.dart';

class AIReadyToCookCard extends StatelessWidget {
  final CombinedRecipeViewModel viewModel;

  const AIReadyToCookCard({super.key, required this.viewModel});

  void _showRecipeDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RecipeOverviewCard(recipe: viewModel.recipe),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipe = viewModel.recipe;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () => _showRecipeDetail(context),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.green, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (recipe.image != null && recipe.image!.isNotEmpty)
                ImageClip(viewModel: viewModel),
              DetailsContainer(viewModel: viewModel),
              RecipeDetails(viewModel: viewModel),
            ],
          ),
        ),
      ),
    );
  }
}
