import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/utils/details_container.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/utils/image_clip.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/utils/recipe_details.dart';
import 'package:ai_cook_project/models/ai_response_model.dart';
import 'package:ai_cook_project/screens/recipes/widgets/recipe_ov_card.dart';
import 'package:flutter/material.dart';

class AIAlmostReadyCard extends StatelessWidget {
  final CombinedRecipeViewModel viewModel;

  const AIAlmostReadyCard({super.key, required this.viewModel});

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () => _showRecipeDetail(context),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: viewModel.missingCount == 1 ? Colors.orange : Colors.red,
              width: 2,
            ),
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
              if (viewModel.recipe.image != null &&
                  viewModel.recipe.image!.isNotEmpty)
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
