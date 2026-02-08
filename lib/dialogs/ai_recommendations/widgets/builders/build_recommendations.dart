import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/sections/ai_almostrecipe_card.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/sections/ai_readyrecipe_card.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/utils/recipe_finder.dart';
import 'package:ai_cook_project/models/ai_response_model.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';

class RecommendationsBuilder extends StatelessWidget {
  final StructuredAIRecommendation recommendation;

  const RecommendationsBuilder({super.key, required this.recommendation});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
        ),
        _buildRecipeCards(
          context,
          recommendation.readyToCook,
          recommendation.almostReady,
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
        ),
      ],
    );
  }
}

Widget _buildEmptyResults(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(
      vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
    ),
    padding: ResponsiveUtils.padding(context, ResponsiveSpacing.lg),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(
        ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
      ),
      border: Border.all(
        color: AppColors.button.withValues(alpha: 0.08),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.button.withValues(alpha: 0.04),
          blurRadius: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width:
              ResponsiveUtils.iconSize(context, ResponsiveIconSize.xxl) +
              ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
          height:
              ResponsiveUtils.iconSize(context, ResponsiveIconSize.xxl) +
              ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.button.withValues(alpha: 0.06),
            shape: BoxShape.circle,
          ),
          child: Icon(
            CupertinoIcons.search,
            size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.xl),
            color: AppColors.button.withValues(alpha: 0.35),
          ),
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
        ),
        Text(
          'No Recipes Found',
          style: AppTextStyles.casta(
            fontSize: ResponsiveUtils.fontSize(
              context,
              ResponsiveFontSize.title,
            ),
            fontWeight: AppFontWeights.semiBold,
            color: AppColors.button,
            letterSpacing: 0.4,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
        ),
        Text(
          'Try adjusting your filters or adding more items to your pantry.',
          style: AppTextStyles.inter(
            fontSize: ResponsiveUtils.fontSize(
              context,
              ResponsiveFontSize.sm,
            ),
            fontWeight: AppFontWeights.regular,
            color: AppColors.button.withValues(alpha: 0.5),
            letterSpacing: 0.2,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
        ),
        Container(
          padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.lightYellow.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(
                context,
                ResponsiveBorderRadius.md,
              ),
            ),
            border: Border.all(
              color: AppColors.orange.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                CupertinoIcons.lightbulb,
                size: ResponsiveUtils.iconSize(
                  context,
                  ResponsiveIconSize.sm,
                ),
                color: AppColors.orange,
              ),
              SizedBox(
                width: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.sm,
                ),
              ),
              Expanded(
                child: Text(
                  'Try broader cuisine tags or removing time constraints.',
                  style: AppTextStyles.inter(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.sm,
                    ),
                    fontWeight: AppFontWeights.medium,
                    color: AppColors.button.withValues(alpha: 0.6),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
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
          matchScore: aiRecipe.matchScore,
          missingIngredients:
              aiRecipe.missingIngredients
                  .map((name) => MissingIngredientInfo(name: name))
                  .toList(),
          missingCount: aiRecipe.missingIngredients.length,
          recipeSubstitutions: aiRecipe.recipeSubstitutions,
          cookingTips: aiRecipe.steps,
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
          matchScore: aiRecipe.matchScore,
          missingIngredients:
              aiRecipe.missingIngredients
                  .map((name) => MissingIngredientInfo(name: name))
                  .toList(),
          missingCount: aiRecipe.missingIngredients.length,
          recipeSubstitutions: aiRecipe.recipeSubstitutions,
          cookingTips: aiRecipe.steps,
        );
      }).toList();

  if (readyModels.isEmpty && almostModels.isEmpty) {
    return _buildEmptyResults(context);
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (readyModels.isNotEmpty) ...[
        Row(
          children: [
            Icon(
              CupertinoIcons.checkmark_circle_fill,
              color: AppColors.button.withValues(alpha: 0.7),
              size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.md),
            ),
            SizedBox(
              width: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
            ),
            Text(
              'Ready to Cook',
              style: AppTextStyles.inter(
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.md,
                ),
                fontWeight: AppFontWeights.bold,
                color: AppColors.button.withValues(alpha: 0.8),
                letterSpacing: 0.2,
              ),
            ),
            SizedBox(
              width: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.sm,
                ),
                vertical: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.xs,
                ) * 0.5,
              ),
              decoration: BoxDecoration(
                color: AppColors.button.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.borderRadius(
                    context,
                    ResponsiveBorderRadius.md,
                  ),
                ),
              ),
              child: Text(
                '${readyModels.length}',
                style: AppTextStyles.inter(
                  fontSize: ResponsiveUtils.fontSize(
                    context,
                    ResponsiveFontSize.xs,
                  ),
                  fontWeight: AppFontWeights.semiBold,
                  color: AppColors.button.withValues(alpha: 0.6),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
        ),
        ...readyModels.map((vm) => AIReadyToCookCard(viewModel: vm)),
      ],
      if (almostModels.isNotEmpty) ...[
        SizedBox(
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
        ),
        Row(
          children: [
            Icon(
              CupertinoIcons.cart,
              color: AppColors.button.withValues(alpha: 0.7),
              size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.md),
            ),
            SizedBox(
              width: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
            ),
            Text(
              'Almost Ready',
              style: AppTextStyles.inter(
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.md,
                ),
                fontWeight: AppFontWeights.bold,
                color: AppColors.button.withValues(alpha: 0.8),
                letterSpacing: 0.2,
              ),
            ),
            SizedBox(
              width: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.sm,
                ),
                vertical: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.xs,
                ) * 0.5,
              ),
              decoration: BoxDecoration(
                color: AppColors.button.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.borderRadius(
                    context,
                    ResponsiveBorderRadius.md,
                  ),
                ),
              ),
              child: Text(
                '${almostModels.length}',
                style: AppTextStyles.inter(
                  fontSize: ResponsiveUtils.fontSize(
                    context,
                    ResponsiveFontSize.xs,
                  ),
                  fontWeight: AppFontWeights.semiBold,
                  color: AppColors.button.withValues(alpha: 0.6),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
        ),
        ...almostModels.map((vm) => AIAlmostReadyCard(viewModel: vm)),
      ],
    ],
  );
}
