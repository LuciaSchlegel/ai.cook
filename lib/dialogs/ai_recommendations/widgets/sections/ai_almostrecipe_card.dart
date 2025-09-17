import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/utils/details_container.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/utils/image_clip.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/utils/recipe_details.dart';
import 'package:ai_cook_project/models/ai_response_model.dart';
import 'package:ai_cook_project/screens/recipes/widgets/recipe_ov_card.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
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
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
        vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
      ),
      child: GestureDetector(
        onTap: () => _showRecipeDetail(context),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.md),
            ),
            border: Border.all(
              color:
                  viewModel.missingCount == 1
                      ? AppColors.orange
                      : AppColors.orange.withValues(alpha: 0.15),
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.orange.withValues(alpha: 0.15),
                blurRadius: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.sm,
                ),
                offset: const Offset(0, 4),
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
